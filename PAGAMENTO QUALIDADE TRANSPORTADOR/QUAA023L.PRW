#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"
/*/{Protheus.doc} QUAA023L()==============================================================================================================================
CADASTRO TRANSPORTADORA
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
User Function QUAA023L()

    Local oBrowse := ''

    oBrowse := FwLoadBrw("QUAA023L")
    oBrowse:Activate()

Return (NIL)

/*/{Protheus.doc} BrowseDef()=============================================================================================================================
Chamada mbrowse
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
Static Function BrowseDef()

    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("PC6")
    oBrowse:SetDescription("Pagto de Transportadoras")
    oBrowse:AddFilter("FILIAL","PC6_FILIAL=="+cFilAnt,.T.,.T.)
    oBrowse:SetMenuDef("QUAA023L")

Return (oBrowse)

/*/{Protheus.doc} MenuDef()===============================================================================================================================
Operacao da Rotina
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
Static Function MenuDef()

    Local aRotina := {} //FwMVCMenu("QUAA023L")


    ADD OPTION aRotina TITLE 'Fechamento' ACTION 'U_QA023FCH()' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualiza' ACTION 'VIEWDEF.QUAA023L' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Copia' ACTION 'U_QUAA023WF()' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Gerar Cte/Nfs' ACTION 'U_QUAA023M()' OPERATION 2 ACCESS 0
Return (aRotina)

/*/{Protheus.doc} ModelDef()===============================================================================================================================
Regra de Negocio
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
Static Function ModelDef()

    Local oModel 	:= MPFormModel():New("QAA023EL",,,)
    Local oStruPC6 	:= FwFormStruct(1, "PC6")
    Local oStruPC7 	:= FwFormStruct(1, "PC7")
    Local oStruPC8 	:= FwFormStruct(1, "PC8")


    oModel:AddFields("PC6MASTER", NIL, oStruPC6)
    oModel:AddGrid("PC7DETAIL","PC6MASTER",oStruPC7)
    oModel:AddGrid("PC8DETAIL","PC6MASTER",oStruPC8)


    oModel:GetModel("PC7DETAIL"):SetNoInsertLine(.T.)
    oModel:GetModel("PC7DETAIL"):SetNoUpdateLine(.T.)
    oModel:GetModel("PC8DETAIL"):SetNoInsertLine(.T.)
    oModel:GetModel("PC8DETAIL"):SetNoUpdateLine(.T.)


    oModel:SetRelation("PC7DETAIL", {{"PC7_FILIAL",'PC6_FILIAL'},{"PC7_CODTRA", "PC6_CODTRA"}}, PC7->(IndexKey( 1 )))
    oModel:SetRelation("PC8DETAIL", {{"PC8_FILIAL",'PC7_FILIAL'},{"PC8_CODLIN","PC7_LINHA"}}, PC8->(IndexKey( 2 )))


    oModel:SetPrimaryKey( {'PC6_CODTRA'})
    oModel:SetDescription("Pagamento de Transportadoras" )

    oModel:GetModel("PC6MASTER"):SetDescription("Transportadora")
    oModel:GetModel("PC7DETAIL"):SetDescription("Linhas Transportador")
    oModel:GetModel("PC8DETAIL"):SetDescription("Bonificacoes")


Return (oModel)

/*/{Protheus.doc} ViewDef()===============================================================================================================================
Interface Grafica
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
Static Function ViewDef()

    Local oView 	:= FwFormView():New()
    Local oStruPC6 	:= FwFormStruct(2,"PC6")
    Local oStruPC7 	:= FwFormStruct(2,"PC7")
    Local oStruPC8 	:= FwFormStruct(2,"PC8")
    Local oModel 	:= FwLoadModel("QUAA023L")

    oView:SetModel(oModel)

    oView:AddField("VIEW_PC6", oStruPC6, "PC6MASTER")
    oView:AddGrid("VIEW_PC7", oStruPC7, "PC7DETAIL")
    oView:AddGrid("VIEW_PC8", oStruPC8, "PC8DETAIL")

    oView:CreateHorizontalBox("SUPERIOR", 15)
    oView:CreateHorizontalBox("BAIXO1"   , 45)
    oView:CreateHorizontalBox("BAIXO2"   , 40)

    //oView:CreateVerticalBox("BAIXOESQ", 50,'BAIXO2')
    //oView:CreateVerticalBox("BAIXODIR", 50,'BAIXO2')
    //oView:CreateHorizontalBox("BONIFICACAO", 22)

    oView:SetOwnerView("VIEW_PC6", "SUPERIOR")
    oView:SetOwnerView("VIEW_PC7", "BAIXO1")
    oView:SetOwnerView("VIEW_PC8", "BAIXO2")

    oView:EnableTitleView("VIEW_PC7","Linhas Transportadora")
    oView:EnableTitleView("VIEW_PC8","Bonificacoes")

Return (oView)

Static Function CarrA2()

Local cAliasQry := GetNextAlias()

    BeginSql Alias cAliasQry

		%noparser%

        SELECT LBE_FORNEC,LBE_MOTO
        FROM %table:LBE% LBE
        WHERE LBE.%notDel%
        AND A2_COD IN (SELECT LBB_CODFOR FROM %table:LBB% LBB WHERE LBB_FILIAL=%Exp:cFilAnt% AND LBB_TIPREG='2' AND LBB.%notDel%)
        ORDER BY A2_COD

	EndSql

    While (cAliasQry)->( !Eof())
        RecLock("PC6",.T.)
            PC6->PC6_PERIOD := '102020'
            PC6->PC6_FILIAL := '04'
            PC6->PC6_CODTRA := (cAliasQry)->(A2_COD)
            PC6->PC6_TRANSP := (cAliasQry)->(A2_NOME)
        MsUnlock()

    (cAliasQry)->( dbSkip())

    EndDo


Return

/*/{Protheus.doc} U_QA023FCH
description
@type function
@version
@author wilso
@since 06/11/2020
@return return_type, return_description
/*/
User Function QA023FCH()

 Local aFrete   := {}
 Local aKm      := {}
 Local aLitros  := {}
 Local aBonFixa := {}
 Local aBonif   := {}

    If Pergunte("QUAA023L",.T.)
        xLancD3(MV_PAR01)
        MsgALert("FIM")
        //retorna valore do Frete
        //aFrete      := GetFrete()
        //retorna valore do KM
        //aKm         := GetKm()
        //retorna valore do Litros
       // aLitros     := GetLitros()
        //retorna valore do Bonificaxao Fixa
        //aBonFixa    := GetBonFixa()
        //retorna valore Bonificacao por qualidade
        //aBonif      := GetBonif()

    End If

//MsAguarde({|| Processa(aFrete,aKm,aLitros,aBonFixa,aBonif)},"GERANDO FECHAMENTO . . .")

Return

/*/{Protheus.doc} xLancD3
description
@type function
@version
@author wilso
@since 26/11/2020
@param nOpc, numeric, param_description
@return return_type, return_description
/*/

Static Function xLancD3(MV_PAR01)

Local aLanc     := {}
Local aEst      := {}
Local cTMlan    := '004'
Local cTMEst    := '504'
Local cProd     := '200113'
Local cCC       := '040501'
Local cCCtb     := '113011'+cFilAnt
Local cArm      := '04'
Local cGrupo    := '200'
Local cNumDoc   := ''
Local cMotLan   := 'Provisão de frete de compra de leite ' + SubStr(MV_PAR01,1,2)+"-"+SubStr(MV_PAR01,3,4)
Local cMotEst   := 'Estorno Provisão de frete de compra de leite ' + SubStr(MV_PAR01,1,2)+"-"+SubStr(MV_PAR01,3,4)
Local cObs      := 'FRP'
Local cFilAtu   := cFilAnt
Local nValor    := 0
For i := 1 To 10

cFilAnt := StrZero(i,2)

If      cFilAnt == '02'
            cNumDoc := 'ME'
            nValor := 23000.02
ElseIf  cFilAnt == '03'
            cNumDoc := 'TS'
            nValor := 23000.03
ElseIf  cFilAnt == '04'
            cNumDoc := 'VZ'
            nValor := 23000.04
ElseIf  cFilAnt == '05'
            cNumDoc := 'DO'
            nValor := 23000.05
ElseIf  cFilAnt == '08'
            cNumDoc := 'CB'
            nValor := 23000.08
ElseIf  cFilAnt == '09'
            cNumDoc := 'IT'
            nValor := 23000.09
ElseIf  cFilAnt == '10'
            cNumDoc := 'BJ'
            nValor := 23000.10
Else
            cNumDoc := ''
            nValor  := 0
EndIf

    If nValor > 0

    cCCtb     := '113011'+cFilAnt

    DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek( xFilial("SB1")+cProd )

    //D3_FILIAL,D3_COD,D3_QUANT,D3_CONTA,D3_LOCAL,D3_DOC,D3_GRUPO,D3_CUSTO1,D3_CC,D3_XOBS
    aLanc :=  {	    {"D3_TM"		,cTMlan	,NIL},;
    				{"D3_COD"		,SB1->B1_COD			                                                    ,NIL},;
    				{"D3_UM"		,SB1->B1_UM				                                                    ,NIL},;
    				{"D3_QUANT"		,0.01		                                                                ,".T."},;
    				{"D3_LOCAL"		,cArm       			                                                    ,NIL},;
    				{"D3_EMISSAO"	,LASTDAY(CTOD("01/"+SubStr(MV_PAR01,1,2)+"/"+SubStr(MV_PAR01,3,4)))      	,NIL},;
    				{"D3_NUMSEQ"	,ProxNum()				                                                    ,NIL},;
    			    {"D3_DOC"	    ,cNumDoc+"FR"+SubStr(MV_PAR01,1,2)+SubStr(MV_PAR01,5,6)        		                                                    ,NIL},;
                	{"D3_CUSTO1"	,nValor				                                                        ,NIL},;
                    {"D3_CONTA" 	,cCCtb				                                                        ,NIL},;
                    {"D3_CC"     	,cCC				                                                        ,NIL},;
                    {"D3_MOTIVO"	,cMotLan			                                                        ,NIL},;
                    {"D3_XOBS"  	,cObs	    		                                                        ,NIL},;
                    {"D3_GRUPO"	    ,cGrupo                                                         		    ,NIL}}

    lMsErroAuto := .F.

    MSExecAuto({|x,y| mata240(x,y)},aLanc,3) //inclusao

    If lMsErroAuto
    	Mostraerro()
    	DisarmTransaction()
    Else

        //cNumDoc := cNumDoc+"EFR"+SubStr(MV_PAR01,1,2)+SubStr(MV_PAR01,5,6)

        DbSelectArea("SB1")
    	DbSetOrder(1)
    	DbSeek( xFilial("SB1")+cProd )

        aLanc :=  {	    {"D3_TM"		,cTMEst	,NIL},;
            			{"D3_COD"		,SB1->B1_COD			                                                    ,NIL},;
        				{"D3_UM"		,SB1->B1_UM				                                                    ,NIL},;
        				{"D3_QUANT"		,0.01		                                                                ,".T."},;
        				{"D3_LOCAL"		,cArm       			                                                    ,NIL},;
        				{"D3_EMISSAO"	,CTOD("01/"+StrZero(val(SubStr(MV_PAR01,1,2))+1,2)+"/"+SubStr(MV_PAR01,3,4))	,NIL},;
        				{"D3_NUMSEQ"	,ProxNum()				                                                    ,NIL},;
        			    {"D3_DOC"	    ,cNumDoc+"EFR"+SubStr(MV_PAR01,1,2)+SubStr(MV_PAR01,5,6)                    ,NIL},;
                    	{"D3_CUSTO1"	,nValor				                                                        ,NIL},;
                        {"D3_CONTA" 	,cCCtb				                                                        ,NIL},;
                        {"D3_CC"     	,cCC				                                                        ,NIL},;
                        {"D3_MOTIVO"	,cMotEst			                                                        ,NIL},;
                        {"D3_XOBS"  	,cObs	    		                                                        ,NIL},;
                        {"D3_GRUPO"	    ,cGrupo                                                         		    ,NIL}}

        lMsErroAuto := .F.

        MSExecAuto({|x,y| mata240(x,y)},aLanc,3) //inclusao

        If lMsErroAuto
        	Mostraerro()
        	DisarmTransaction()
        Endif

    End If

    End If

Next i

cFilAnt := cFilAtu

Return



