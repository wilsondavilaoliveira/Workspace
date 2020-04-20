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

    Local aRotina := FwMVCMenu("QUAA023A")

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
  
    Local oModel 	:= MPFormModel():New("QAA023AM")
    Local bLoad 	:= {|oGridModel, lCopy| LoadGrid(oGridModel, lCopy)}
    Local oStruPA3 	:= FwFormStruct(1, "PA3")
    Local oStruPA4 	:= FwFormStruct(1, "PA4")

    oModel:AddFields("PA3MASTER", NIL, oStruPA3)
    oModel:AddGrid("PA4DETAIL","PA3MASTER",oStruPA4,,,,,bLoad) 
    oModel:SetRelation("PA4DETAIL", {{"PA4_FILIAL", "FwXFilial('PA4')"}, {"PA4_CODCAM", "PA3_CODCAM"},{"PA4_PERIOD", "PA3_PERIOD"}}, PA4->(IndexKey( 1 )))
    oModel:SetPrimaryKey( { 'PA3_FILIAL' }, {'PA3_CODCAM'},{'PA3_PERIOD'})
    oModel:SetDescription("Lancamentos de Frete Carreteiro" )
    oModel:GetModel("PA3MASTER"):SetDescription("Cabecalho Fretes")
    oModel:GetModel("PA4DETAIL"):SetDescription("Itens Fretes")
    
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
    Local oModel 	:= FwLoadModel("QUAA023A")

    oView:SetModel(oModel)
    oModelZA2 := oModel:GetModel( 'ZA1MASTER' )
    oView:AddField("VIEW_PA3", oStruPA3, "PA3MASTER")
    oView:AddGrid("VIEW_PA4", oStruPA4, "PA4DETAIL")
    oView:CreateHorizontalBox("SUPERIOR", 25)
    oView:CreateHorizontalBox("INFERIOR", 75)
    oView:SetOwnerView("VIEW_PA3", "SUPERIOR")
    oView:SetOwnerView("VIEW_PA4", "INFERIOR")
    oStruPA4:RemoveField( 'PA4_FECHAM' )
    oView:AddIncrementField("VIEW_PA4", "PA4_ITEM")
    oView:EnableTitleView("VIEW_PA4","ITENS")
    
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