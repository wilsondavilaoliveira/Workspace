#Include 'Totvs.ch'
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE 'COLORS.CH'
#INCLUDE "PRCONST.CH"
#INCLUDE "FONT.CH"
#include "TBICONN.CH"
#Include "FWMVCDEF.ch"
/*/{Protheus.doc} QUAA023E()==============================================================================================================================
CADASTRO TRANSPORTADORA
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
User Function QUAA023E()

    Local oBrowse := FwLoadBrw("QUAA023E")

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

    oBrowse:SetAlias("SA2")
    oBrowse:SetDescription("Cadastro de Transportadoras")
    oBrowse:AddFilter("FILIAL", U_QA23BCS1() ,.T.,.T.)
    oBrowse:SetMenuDef("QUAA023E")
    oBrowse:AddLegend( "A2_MSBLQL == '1'", "RED","BLOQUEADO")
    oBrowse:AddLegend( "A2_MSBLQL == '2'", "GREEN","ATIVO")

    SetKey(VK_F4, {|| FOpenx()})

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

    Local aRotina := {} //FwMVCMenu("QUAA023E")

    ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'U_QUA23EAV(2)'   OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'      ACTION 'U_QUA23EAV(4)'   OPERATION 4 ACCESS 0


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

    Local bCommit   := {||GravaLog(oModel)}
    Local oModel 	:= MPFormModel():New("QAA023EM",,,bCommit)

    Local oStruSA2 	:= FwFormStruct(1, "SA2")
    Local oStruPBG 	:= FwFormStruct(1, "PBG")
    Local oStruPBC 	:= FwFormStruct(1, "PBC")
    Local oStruLBE 	:= FwFormStruct(1, "LBE")
    Local oStruPBL 	:= FwFormStruct(1, "PBL")

    oModel:AddFields("SA2MASTER", NIL, oStruSA2)
    oModel:AddGrid("PBGDETAIL","SA2MASTER",oStruPBG)
    oModel:AddGrid("PBCDETAIL","SA2MASTER",oStruPBC)
    oModel:AddGrid("LBEDETAIL","SA2MASTER",oStruLBE)
    oModel:AddGrid("PBLDETAIL","LBEDETAIL",oStruPBL)

    oModel:GetModel("LBEDETAIL"):SetNoInsertLine(.T.)
    oModel:GetModel("LBEDETAIL"):SetNoUpdateLine(.T.)

    oModel:SetRelation("PBCDETAIL", {{"PBC_FILIAL",'xFilial("PBC")'},{"PBC_CODTRA", "A2_COD"}}, PBC->(IndexKey( 1 )))
    oModel:SetRelation("PBGDETAIL", {{"PBG_FILIAL",'xFilial("PBG")'},{"PBG_CODTRA","A2_COD"}}, PBG->(IndexKey( 2 )))
    oModel:SetRelation("LBEDETAIL", {{"LBE_FORNEC", "A2_COD"}}, LBE->(IndexKey( 2 )))
    oModel:SetRelation("PBLDETAIL", {{"PBL_FILIAL","LBE_FILIAL"},{"PBL_CODTRA", "LBE_FORNEC"},{"PBL_CODCAM", "LBE_CODCAM"}}, PBL->(IndexKey( 1 )))

    oModel:GetModel("LBEDETAIL"):SetLoadFilter( , " LBE_STATUS = 'S'" )

    oModel:SetPrimaryKey( {'A2_CODIGO'})
    oModel:SetDescription("Cadastro de Transportadoras" )

    oModel:GetModel("SA2MASTER"):SetDescription("Cadastro de Transportadoras")
    oModel:GetModel("PBCDETAIL"):SetDescription("Transportadora x Motoristas")
    oModel:GetModel("PBGDETAIL"):SetDescription("Documentos Transportadora")
    oModel:GetModel("LBEDETAIL"):SetDescription("Veiculos x Linhas")
    oModel:GetModel("PBLDETAIL"):SetDescription("Formas de Pagamento")

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
    Local oStruSA2 	:= FwFormStruct(2,"SA2")
    Local oStruPBC 	:= FwFormStruct(2,"PBC")
    Local oStruPBG 	:= FwFormStruct(2,"PBG")
    Local oStruLBE 	:= FwFormStruct(2,"LBE")
    Local oStruPBL 	:= FwFormStruct(2,"PBL")
    Local oModel 	:= FwLoadModel("QUAA023E")

    oView:SetModel(oModel)

    oView:AddField("VIEW_SA2", oStruSA2, "SA2MASTER")
    oView:AddGrid("VIEW_PBC", oStruPBC, "PBCDETAIL")
    oView:AddGrid("VIEW_PBG", oStruPBG, "PBGDETAIL")
    oView:AddGrid("VIEW_LBE", oStruLBE, "LBEDETAIL")
    oView:AddGrid("VIEW_PBL", oStruPBL, "PBLDETAIL")


    oView:CreateHorizontalBox("SUPERIOR", 35)
    oView:CreateHorizontalBox("BAIXO1"   , 30)
    oView:CreateHorizontalBox("BAIXO2"   , 35)

    //oView:CreateVerticalBox("BAIXOESQ1", 50,'BAIXO1')
    //oView:CreateVerticalBox("BAIXODIR1", 50,'BAIXO1')

    oView:CreateVerticalBox("BAIXOESQ2", 30,'BAIXO2')
    oView:CreateVerticalBox("BAIXOCEN2", 30,'BAIXO2')
    oView:CreateVerticalBox("BAIXODIR2", 40,'BAIXO2')
    //oView:CreateHorizontalBox("BONIFICACAO", 22)

    oView:SetOwnerView("VIEW_SA2", "SUPERIOR")

    oView:SetOwnerView("VIEW_PBG", "BAIXO1")

    oView:SetOwnerView("VIEW_PBC", "BAIXOESQ2")
    oView:SetOwnerView("VIEW_LBE", "BAIXOCEN2")
    oView:SetOwnerView("VIEW_PBL", "BAIXODIR2")


    //oStruPA4:RemoveField( 'PA4_FECHAM' )

    //oStruPBG:RemoveField( 'PBG_PERIOD' )
    //oStruPBG:RemoveField('PBG_CODCAR')
    //oStruPBG:RemoveField('PBG_DESCAR' )

   oStruPBC:RemoveField('PBC_CODTRA' )
   oStruPBG:RemoveField( 'PBG_TIPO' )

   oStruLBE:RemoveField('LBE_LOJA' )
   //oStruLBE:RemoveField('LBE_CODCAM' )
   oStruLBE:RemoveField('LBE_ENDERE' )
   oStruLBE:RemoveField('LBE_CNH' )
   oStruLBE:RemoveField('LBE_REGCNH' )
   oStruLBE:RemoveField('LBE_EMISSA' )
   oStruLBE:RemoveField('LBE_MUNCNH' )
   oStruLBE:RemoveField('LBE_UFCNH' )
   oStruLBE:RemoveField('LBE_VENCIM' )
   oStruLBE:RemoveField('LBE_CATEGO' )
   oStruLBE:RemoveField('LBE_NUMRG' )
   oStruLBE:RemoveField('LBE_UFRG' )
   oStruLBE:RemoveField('LBE_TPFRET' )
   oStruLBE:RemoveField('LBE_PERC1' )
   oStruLBE:RemoveField('LBE_PERC2' )
   oStruLBE:RemoveField('LBE_LOGIN' )
   oStruLBE:RemoveField('LBE_DESCRI' )
   oStruLBE:RemoveField('LBE_TIPVEI' )
   oStruLBE:RemoveField('LBE_CAPACI' )
   oStruLBE:RemoveField('LBE_STATUS' )
   oStruLBE:RemoveField('LBE_FORNEC' )
   oStruLBE:RemoveField('LBE_CODVEI' )
   oStruLBE:RemoveField('LBE_DESC' )
   oStruLBE:RemoveField('LBE_DESVEI' )

   oStruPBL:RemoveField('PBL_CODTRA' )
   oStruPBL:RemoveField('PBL_CODCAM' )


   //oStruLBE:RemoveField('LBE_' )
   //oStruLBE:RemoveField('LBE_' )
    oView:AddIncrementField("VIEW_PBL", "PBL_ITEM")
    //oView:SetViewProperty( 'VIEW_PBC', "CHANGELINE", {{ |oView, cViewID| MsgAlert("teste") }} )
    oView:EnableTitleView("VIEW_SA2","Cadastro Transportadora")
    oView:EnableTitleView("VIEW_PBC","Motoristas X Transportadora")
    oView:EnableTitleView("VIEW_PBG","Documentos anexos Transportadora")
    oView:EnableTitleView("VIEW_LBE","Veiculos X Linhas")
    oView:EnableTitleView("VIEW_PBL","Formas de Pagamento")

Return (oView)

User Function QA23EPBG()

Local cTipo :=  ''
Local lRet := .T.

If ATISROTINA("U_QUAA023D")
    cTipo := 'M'
ElseIf ATISROTINA("U_QUAA023J")
    cTipo := "V"
Else
    cTipo := "T"
EnDIf

If POSICIONE("PBI",1,XFILIAL("PBI")+FWFLDGET("PBG_CODTIP"),"PBI_TIPO") <> cTipo
    lRet := .F.
    Help( ,, 'Help',, 'Codigo invalido para esse tipo de bonificacao!', 1, 0 )
EndIf

Return lRet

Static Function FOpenx()

ShellExecute("open", FWFldGet('PBG_LOCARQ'), "", "", 1)

Return

/*/{Protheus.doc} GravaLog
GRAVA LOG DE BLOQUEIO
@type function
@version
@author wilso
@since 16/11/2020
@param oModel, object, param_description
@return return_type, return_description
/*/
Static Function GravaLog(oModel)

Local cDesc         := ''
Local nOperation    := oModel:GetOperation()
Local lRet          := .T.
Local aDados        := {}
Local lBlock        := .T.

If nOperation == MODEL_OPERATION_UPDATE

    cDesc += DTOC(dDataBase)+"-"+Time()+"->REGISTRO " + IiF(SA2->A2_MSBLQL=='2','*BLOQUEADO*','*DESBLOQUEADO*') + " PELO USUARIO: " + Alltrim(UsrRetName(__cUserId)) + CRLF
    cDesc += "MOTIVO: "
    If FWFLDGET("A2_MSBLQL") <> SA2->A2_MSBLQL
        cDesc += U_QUAA023I("TRANSPORTADORA: "+ SA2->A2_COD+"-"+SA2->A2_NOME,IiF(SA2->A2_MSBLQL=='2','BLOQUEIO','DESBLOQUEIO'))
    EndIf

    lBlock := IiF(SA2->A2_MSBLQL=='2',.T.,.F.)

    lRet := FWFormCommit(oModel)

    If lRet

        RecLock("SA2",.F.)
            SA2->A2_LOG := SA2->A2_LOG + CRLF + cDesc + CRLF + "====================================================================="
        MsUnlock()

        If PBK->(dbSeek(cFilAnt+'02'))

            nDias   := cValToChar(PBK->PBK_DIAANT)
            nDiasBl := cValToChar(PBK->PBK_DIASIN)
            nDiasAv := cValToCHar(PBK->PBK_DIAANT+PBK->PBK_DIASIN)
            cBlok   := IiF(lBlock,'BLOQUEADA','DESBLOQUEADA')
            cBlok1   := IiF(lBlock,'BLOQUEIO','DESBLOQUEIO')

            cMail   := Alltrim(PBK->PBK_EMAILD)

            If !lBlock
                cCorpo  := Alltrim(PBK->PBK_CORPO)+CRLF
                cCorpo += " - Observações: "+ cDesc
                cAssun  := Alltrim(PBK->PBK_ASSUNT)
            Else
                cCorpo := cDesc
                cAssun := "Transportadora de Leite Bloqueada Manualmente"
            EndIf

            AADD(aDados,{ SA2->A2_COD,;
                            POSICIONE("LBB",2,cFilAnt+SA2->A2_COD+'0001',"LBB_CODPRO"),;
                            IIF(SA2->A2_TIPO='J',TRANSFORM(SA2->A2_CGC,"@R 99.999.999/9999-99"),TRANSFORM(SA2->A2_CGC,"@R 999.999.999-99")),;
                            SA2->A2_NOME})

            WFMail2(aDados,cMail,cAssun,cCorpo,cBlok,cBlok1)

        EndIf

    EndIf

Else
    lRet := FWFormCommit(oModel)
EndIf

Return lRet


/*/{Protheus.doc} WFMail4
WORKFLOW BLOQUEIO/DESBLOQUEIO DE TRANSPORTADORA
@type function
@version
@author Wilson Davila
@since 04/12/2020
@param aDados, array, param_description
@return return_type, return_description
/*/
Static Function WFMail2(aDados,cMail,cAssun,cCorpo,cBlok,cBLock1)

Local lRet		:= .T.
Local oProcWF   := Nil
Local cMailAdm  := '' //SuperGetMv('ES_QUAA081',.F.,'') // e-mails
Local cTo		:= cMail //'wilson.oliveira@wdonet.com.br'


	cMailAdm  := ''
	oProcWF := TWFProcess():New("QA23F2","Aviso Transportadora de Leite " + cBlok )
	oProcWF:NewTask("QA23F2","\workflow\QUAA023WF_002.html",.T.)
	oProcWF:cSubject := OemToAnsi(cAssun)

   	// Cabecalho

	oProcWF:oHTML:ValByName("cTitulo"    ,"AVISO " + cBlock1 + " TRANSPORTADORA")
    oProcWF:oHTML:ValByName("cCorpo"    ,cCorpo )
    oProcWF:oHTML:ValByName("dthoje"    ,dtoc(dDataBase ))

    For i := 1 to Len(aDados)
        AAdd(oProcWF:oHTML:ValByName("it.cCodFor")  ,aDados[i][1] )
	    AAdd(oProcWF:oHTML:ValByName("it.cCodPro")	,aDados[i][2] )
	    AAdd(oProcWF:oHTML:ValByName("it.cCnpj")	,aDados[i][3] )
        AAdd(oProcWF:oHTML:ValByName("it.cRazao")	,aDados[i][4] )
    Next i

	// Adiciona e-mail
	oProcWF:cTo := cTo

	oProcWF:Start()
	WFSendMail()
	oProcWF:Finish()
	oProcWF := FreeObj(oProcWF)


Return lRet


User Function QUA23EAV(nOp)

Local aCodCam := getCodCam()

PBL->(dbSetOrder(1))


    For a := 1 to Len(aCodCam)
        If !PBL->(dbSeek(cFilAnt+SA2->A2_COD+aCodCam[a][1]+'01'))
            RecLock("PBL",.T.)
                PBL->PBL_FILIAL := cFilAnt
                PBL->PBL_ITEM   := '01'
                PBL->PBL_TIPO   := '1'
                PBL->PBL_VALOR   := 0
                PBL->PBL_CODTRA := SA2->A2_COD
                PBL->PBL_CODCAM := aCodCam[a][1]
            MsUnlock()
        EndIf
    Next a

    If nOp == 4
        FWExecView("Alterar", "QUAA023E",nOp,, {||.T.})
    Else
        FWExecView("Visualizar", "QUAA023E",nOp,, {||.T.})
    EndIf

return


Static Function getCodCam()

Local cAlias    := GetNextAlias()
Local aCodCam   := {}

    BeginSql  alias cAlias

        %noparser%

        SELECT LBE_CODCAM FROM %Table:LBE% LBE WHERE LBE_FORNEC=%Exp:SA2->A2_COD% AND LBE_FILIAL=%Exp:cFilAnt% AND LBE_STATUS='S' AND LBE.%notdel%
        ORDER BY LBE_CODCAM

    EndSql

    While (cAlias)->( !Eof() )
        AADD(aCodCam,{(cAlias)->(LBE_CODCAM)})
        (cAlias)->( dbSkip() )
    EndDo

Return aCodCam
