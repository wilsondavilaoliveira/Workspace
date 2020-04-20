#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} QUAALJV()===============================================================================================================================
Cadastro Preco Fixado e preco base produtor
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
User Function QUAALJV()

    Local oBrowse := FwLoadBrw("QUAALJV")
    
    oBrowse:Activate()

Return (NIL)

/*/{Protheus.doc} BrowseDef()=============================================================================================================================
Chamad do mbrowser                           
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static Function BrowseDef()

    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("LJV")
    oBrowse:SetDescription("Cadastro Preco Fixo e Base Produtor")
    oBrowse:AddFilter("FILIAL","LJV_FILIAL=="+cFilAnt,.T.,.T.)
    oBrowse:SetMenuDef("QUAALJV")

Return (oBrowse)

/*/{Protheus.doc} MenuDef()==============================================================================================================================
Operacao da rotina                           
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static Function MenuDef()

    Local aRotina := FwMVCMenu("QUAALJV")
    
Return (aRotina)

/*/{Protheus.doc} ModelDef()==============================================================================================================================
Regra de negocio Rotina                      
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static Function ModelDef()

    Local oModel 	:= MPFormModel():New("QUALJVM")
    Local oStruLJV 	:= FwFormStruct(1,"LJV")

    oModel:AddFields("LJVMASTER", NIL, oStruLJV)
    oModel:SetPrimaryKey( { 'LJV_FILIAL' }, {'LJV_DTFECH'} )
    oModel:SetDescription("Cadastro preco fixado e base produtor" )
    oModel:GetModel("LJVMASTER"):SetDescription("Cadastro preco fixado e Base produtor")
    
Return (oModel)

/*/{Protheus.doc} ViewDef()==============================================================================================================================
Interface grafica                            
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/

Static Function ViewDef()

    Local oView 	:= FwFormView():New()
    Local oStruLJV 	:= FwFormStruct(2, "LJV")
    Local oModel 	:= FwLoadModel("QUAALJV")


    oView:SetModel(oModel)
    oView:AddField("VIEW_LJV", oStruLJV, "LJVMASTER")
    oView:CreateHorizontalBox("SUPERIOR", 100)
    oView:SetOwnerView("VIEW_LJV", "SUPERIOR")

Return (oView)