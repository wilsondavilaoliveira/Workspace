#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} QUAA023K
description
@type function
@author Wilson Davila
@since 10/12/2020
/*/

User Function QUAA023K()

    Local oBrowse := FwLoadBrw("QUAA023K")

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

    oBrowse:SetAlias("PBK")
    oBrowse:SetDescription("Parametros WorkFlow")
    oBrowse:AddFilter("FILIAL","PBK_FILIAL=="+cFilAnt,.T.,.T.)
    oBrowse:SetMenuDef("QUAA023K")

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

    Local aRotina := {}

    ADD OPTION aRotina TITLE 'Alterar'      ACTION 'VIEWDEF.QUAA023K' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.QUAA023K' OPERATION 2 ACCESS 0

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

    Local oModel 	:= MPFormModel():New("QAA023KM")
    Local oStruPBK 	:= FwFormStruct(1, "PBK")

    oModel:AddFields("PBKMASTER", NIL, oStruPBK)
    oModel:SetPrimaryKey( { 'PBK_FILIAL' }, {'PBK_CODCAM'},{'PBK_PERIOD'})
    oModel:SetDescription("Lancamentos de Frete Carreteiro" )
    oModel:GetModel("PBKMASTER"):SetDescription("Cabecalho Fretes")

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
    Local oStruPBK 	:= FwFormStruct(2,"PBK")
    Local oModel 	:= FwLoadModel("QUAA023K")

    oView:SetModel(oModel)

    oView:AddField("VIEW_PBK", oStruPBK, "PBKMASTER")
    oView:CreateHorizontalBox("SUPERIOR", 100)
    oView:SetOwnerView("VIEW_PBK", "SUPERIOR")

Return (oView)

