#INCLUDE "TOTVS.ch"
#INCLUDE "FWMVCDEF.ch"

/*/{Protheus.doc} QUAAZXR()===============================================================================================================================
Cadastro Familia Produtot
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
User Function QUAAZXR()

    Local oBrowse := FwLoadBrw("QUAAZXR")
    
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

    oBrowse:SetAlias("ZXR")
    oBrowse:SetDescription("Cadastro Familia Produtor")
    oBrowse:AddFilter("FILIAL","ZXR_FILIAL=="+cFilAnt,.T.,.T.)
    oBrowse:SetMenuDef("QUAAZXR")

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

    Local aRotina := FwMVCMenu("QUAAZXR")
    
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

    Local oModel 	:= MPFormModel():New("QUAZXRM")
    Local oStruZXR 	:= FwFormStruct(1,"ZXR")

    oModel:AddFields("ZXRMASTER", NIL, oStruZXR)
    oModel:SetPrimaryKey( { 'ZXR_FILIAL' }, {'ZXR_CODFAM'} )
    oModel:SetDescription("Cadastro Familia Produtor" )
    oModel:GetModel("ZXRMASTER"):SetDescription("Cadastro Familia Produtor")
    
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
    Local oStruZXR 	:= FwFormStruct(2, "ZXR")
    Local oModel 	:= FwLoadModel("QUAAZXR")


    oView:SetModel(oModel)
    oView:AddField("VIEW_ZXR", oStruZXR, "ZXRMASTER")
    oView:CreateHorizontalBox("SUPERIOR", 100)
    oView:SetOwnerView("VIEW_ZXR", "SUPERIOR")

Return (oView)