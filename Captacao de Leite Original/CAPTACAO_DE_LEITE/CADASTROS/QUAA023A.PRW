#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} QUAA023A()==============================================================================================================================
Tela para manutencao de fretes carreteiros
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
User Function QUAA023A()

    Local oBrowse := FwLoadBrw("QUAA023A")

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

    oBrowse:SetAlias("PA3")
    oBrowse:SetDescription("Cabecalho Fretes")
    oBrowse:AddFilter("FILIAL","PA3_FILIAL=="+cFilAnt,.T.,.T.)
    oBrowse:SetMenuDef("QUAA023A")

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

    Local aRotina := {} //FwMVCMenu("QUAA023A")

    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.QUAA023A' OPERATION 2 ACCESS 0
  
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
  
    Local oModel 	       := MPFormModel():New("QAA023AM")
    Local bLoadPA4 	     := {|oGridModel, lCopy| LoadGrid(oGridModel, lCopy)}
    Local bLoadLJW 	    := {|oGridModel, lCopy| LoadGrid1(oGridModel, lCopy)}
    Local bLoadZA1 	    := {|oGridModel, lCopy| LoadGrid2(oGridModel, lCopy)}

    Local oStruPA3 	:= FwFormStruct(1, "PA3")
    Local oStruPA4 	:= FwFormStruct(1, "PA4")
    Local oStruLJW 	:= FwFormStruct(1, "LJW")
    Local oStruZA1 	:= FwFormStruct(1, "ZA1")

    oModel:AddFields("PA3MASTER", NIL, oStruPA3)
    oModel:AddGrid("PA4DETAIL","PA3MASTER",oStruPA4,,,,,bLoadPA4) 
    oModel:AddGrid("LJWDETAIL","PA4DETAIL",oStruLJW,,,,,bLoadLJW)
    oModel:AddGrid("ZA1DETAIL","PA3MASTER",oStruZA1,,,,,bLoadZA1)

    oModel:SetRelation("PA4DETAIL", {{"PA4_FILIAL", "FwXFilial('PA4')"}, {"PA4_CODCAM", "PA3_CODCAM"},{"PA4_PERIOD", "PA3_PERIOD"}}, PA4->(IndexKey( 1 )))
    oModel:SetRelation("LJWDETAIL", {{"LJW_FILIAL", "FwXFilial('LJW')"}, {"LJW_CODCAR", "PA4_CODCAM"},{"LJW_PERIOD", "PA4_PERIOD"}}, LJW->(IndexKey( 2 )))
    oModel:SetRelation("ZA1DETAIL", {{"ZA1_FILIAL", "FwXFilial('ZA1)"}, {"ZA1_CODLIN", "PA3_CODCAM"},{"ZA1_PERIOD", "PA3_PERIOD"}}, ZA1->(IndexKey( 1 )))

    oModel:SetPrimaryKey( { 'PA3_FILIAL' }, {'PA3_CODCAM'},{'PA3_PERIOD'})
    oModel:SetDescription("Lancamentos de Frete Carreteiro" )
    
    oModel:GetModel("PA3MASTER"):SetDescription("Cabecalho Fretes")
    oModel:GetModel("PA4DETAIL"):SetDescription("Itens Produtores Litros")
    oModel:GetModel("ZA1DETAIL"):SetDescription("Kms Carreteiro")
    oModel:GetModel("LJWDETAIL"):SetDescription("Itens Bonificacoes")

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
    Local oStruPA3 	:= FwFormStruct(2,"PA3")
    Local oStruPA4 	:= FwFormStruct(2,"PA4")
    Local oStruZA1 	:= FwFormStruct(2,"ZA1")
    Local oStruLJW 	:= FwFormStruct(2,"LJW")
    
    Local oModel 	:= FwLoadModel("QUAA023A")
 
    ReCalTot()

    oView:SetModel(oModel)
       
    oView:AddField("VIEW_PA3", oStruPA3, "PA3MASTER")
    oView:AddGrid("VIEW_PA4", oStruPA4, "PA4DETAIL")
    oView:AddGrid("VIEW_ZA1", oStruZA1, "ZA1DETAIL")
    oView:AddGrid("VIEW_LJW", oStruLJW, "LJWDETAIL")

    oView:CreateHorizontalBox("SUPERIOR", 23)
    oView:CreateHorizontalBox("FRETE", 30)
    oView:CreateHorizontalBox("KMS", 25)
    oView:CreateHorizontalBox("BONIFICACAO", 22)

    oView:SetOwnerView("VIEW_PA3", "SUPERIOR")
    oView:SetOwnerView("VIEW_PA4", "FRETE")
    oView:SetOwnerView("VIEW_ZA1", "KMS")
    oView:SetOwnerView("VIEW_LJW", "BONIFICACAO")

    oStruPA4:RemoveField( 'PA4_FECHAM' )
   
    oStruLJW:RemoveField( 'LJW_PERIOD' )
    oStruLJW:RemoveField('LJW_CODCAR')
    oStruLJW:RemoveField('LJW_DESCAR' )
   
   oStruZA1:RemoveField('ZA1_CODLIN' )
   oStruZA1:RemoveField('ZA1_PLACA' )
   oStruZA1:RemoveField('ZA1_ODOINI' )
   oStruZA1:RemoveField('ZA1_ODOFIM' )
   oStruZA1:RemoveField('ZA1_PERIOD' )
    

    oView:AddIncrementField("VIEW_PA4", "PA4_ITEM")
    
    oView:EnableTitleView("VIEW_PA4","ITENS VOMUME PRODUTOR")
    oView:EnableTitleView("VIEW_ZA1","ITENS KMS CARRETEIRO")
    oView:EnableTitleView("VIEW_LJW","ITENS BONIFICACAO CARRETEIRO")

Return (oView)

/*/{Protheus.doc} LoadGrid()==============================================================================================================================
Carrega dados na grid                         
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
Static Function LoadGrid(oGridModel, lCopy)
	
	Local aLoad := {}

	PA4->(dbSetOrder(3))
	If PA4->(dbSeek(PA3->PA3_FILIAL+PA3->PA3_CODCAM+PA3->PA3_PERIOD))
		While PA4->( !Eof() ) .AND. PA4->(PA4_FILIAL+PA4_CODCAM+PA4_PERIOD) == (PA3->PA3_FILIAL+PA3_CODCAM+PA3->PA3_PERIOD) 
			aAdd(aLoad,{0,{PA4->(PA4_FILIAL),PA4->(PA4_CODCAM),PA4->(PA4_PERIOD),PA4->(PA4_CODPRO),;
			POSICIONE("LBB",1,XFILIAL("LBB")+PA4->(PA4_CODPRO),"LBB_DESC"),POSICIONE("LBB",1,XFILIAL("LBB")+PA4->(PA4_CODPRO),"LBB_NOMFOR"),;
			"",PA4->(PA4_QTDLIT),PA4->(PA4_DATA),"",PA4->(PA4_NUMDIA)}})
			PA4->(dbSkip())
		EndDo
	EndIf

Return aLoad

/*/{Protheus.doc} LoadGrid()==============================================================================================================================
Carrega dados na grid                         
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
Static Function LoadGrid1(oGridModel, lCopy)
	
	Local aLoad := {}

	LJW->(dbSetOrder(1))
	If LJW->(dbSeek(PA3->PA3_FILIAL+PA3->PA3_PERIOD+PA3->PA3_CODCAM))
		While LJW->( !Eof() ) .AND. LJW->(LJW_FILIAL+LJW_PERIOD+LJW_CODCAR) == (PA3->PA3_FILIAL+PA3->PA3_PERIOD+PA3->PA3_CODCAM) 
			aAdd(aLoad,{0,{,,,,LJW->(LJW_CODBON),POSICIONE("LJS",1,XFILIAL("LJS")+LJW->(LJW_CODBON),"LJS_DESC"),;
            POSICIONE("LJS",1,XFILIAL("LJS")+LJW->(LJW_CODBON),"LJS_TPPAGT"),LJW->(LJW_VALOR),LJW->(LJW_OBS),""}})
			LJW->(dbSkip())
		EndDo
	EndIf

Return aLoad

/*/{Protheus.doc} LoadGrid()==============================================================================================================================
Carrega dados na grid                         
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
Static Function LoadGrid2(oGridModel, lCopy)
	
	Local aLoad := {}

	ZA1->(dbSetOrder(2))
	If ZA1->(dbSeek(PA3->PA3_FILIAL+PA3->PA3_PERIOD+PA3->PA3_CODCAM))
		While ZA1->( !Eof() ) .AND. ZA1->(ZA1_FILIAL+ZA1_PERIOD+ZA1_CODLIN) == (PA3->PA3_FILIAL+PA3->PA3_PERIOD+PA3_CODCAM) 
			aAdd(aLoad,{0,{,ZA1->(ZA1_NUMDIA),,ZA1->(ZA1_VLRECE),ZA1->(ZA1_DTENTR),,ZA1->(ZA1_KMRAST),,,ZA1->(ZA1_KMREAL),,""}})
			ZA1->(dbSkip())
		EndDo
	EndIf

Return aLoad

/*/{Protheus.doc} ReCalTot()==============================================================================================================================
Atualiza campos cabecalho PA3 LITROS/KMS/TOTAIS                  
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
Static Function ReCalTot()

Local nKm           := 0
Local nLitros        := 0
Local nBonif         := 0

If GetMv("MV_XDTFCHT") >= CTOD('01\'+SUBS(PA3->PA3_PERIOD,1,2)+'/'+SUBS(PA3->PA3_PERIOD,3,4))       
    Return
End If

PA4->(dbSetOrder(3))
	If PA4->(dbSeek(PA3->PA3_FILIAL+PA3->PA3_CODCAM+PA3->PA3_PERIOD))
		While PA4->( !Eof() ) .AND. PA4->(PA4_FILIAL+PA4_CODCAM+PA4_PERIOD) == (PA3->PA3_FILIAL+PA3_CODCAM+PA3->PA3_PERIOD) 
                nLitros += PA4->(PA4_QTDLIT)
    		PA4->(dbSkip())
		EndDo
	EndIf

ZA1->(dbSetOrder(2)) //ZA1_FILIAL+ZA1_PERIOD+ZA1_CODLIN  
    If ZA1->( dbSeek(xFilial("ZA1")+PA3->PA3_PERIOD+PA3->PA3_CODCAM))
        While ZA1->(!Eof()) .and. ZA1->(ZA1_FILIAL+ZA1_PERIOD+ZA1_CODLIN) == PA3->PA3_FILIAL+PA3->PA3_PERIOD+PA3->PA3_CODCAM
            nKm += ZA1->(ZA1_KMREAL)
            ZA1->( dbSkip() )  
        EndDo
    EndIf

LJW->(dbSetOrder(1))
    If LJW->(dbSeek(PA3->PA3_FILIAL+PA3->PA3_PERIOD+PA3->PA3_CODCAM))
        While LJW->( !Eof() ) .AND. LJW->(LJW_FILIAL+LJW_PERIOD+LJW_CODCAR) == PA3->PA3_FILIAL+PA3->PA3_PERIOD+PA3->PA3_CODCAM 
            
            TpBonif := POSICIONE("LJS",1,XFILIAL("LJS")+LJW->(LJW_CODBON),"LJS_TPPAGT")
                If TpBonif == '1'
                    nBonif += (nLitros * LJW->(LJW_VALOR))
                ElseIf TpBonif =='2'
                    nBonif += LJW->(LJW_VALOR)
                Else
                    nBonif += (nKm * LJW->(LJW_VALOR))
                EndIf	
        
            LJW->(dbSkip())
        
        EndDo
    EndIf
        
        TpFrete     :=  Posicione("LBE",2,xFilial("LBE")+PA3->PA3_CODCAM,"LBE_TPFRET")
    	nValFrt      :=  Posicione("LBE",2,xFilial("LBE")+PA3->PA3_CODCAM,"LBE_PERC1")

    RecLock("PA3",.F.)

        If 	TpFrete == '1'
            PA3->PA3_VLRFRT	:= (nLitros *  nValFrt) 
        ElseIf TpFrete == '2'
            PA3->PA3_VLRFRT	:= nValFrt 
        Else
            PA3->PA3_VLRFRT	:= (nKm *  nValFrt) 
        EndIf
       
        PA3->PA3_TOTKM := nKm
        PA3->PA3_QTDLIT := nLitros
        PA3->PA3_VRBON := nBonif
        PA3->PA3_VRTOT := PA3->PA3_VLRFRT + nBonif

    MsUnlock()

Return 