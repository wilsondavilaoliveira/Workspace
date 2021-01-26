#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} QUAA023H()
CADASTRO TIPOS DE DOCUMENTOS MOTORISTA/TRANSPORTADOR
@author  Wilson Davila
@since 01/02/2020
/*/
User Function QUAA023H()

    Local oBrowse := FwLoadBrw("QUAA023H")
    oBrowse:Activate()

Return (NIL)
//==============================================================================================================
Static Function BrowseDef()

    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("PBI")
    oBrowse:SetDescription("Cadastro Tipo Documentos Motorista/Transportador")
    oBrowse:AddFilter("FILIAL","PBI_FILIAL==" + cFilAnt ,.T.,.T.)
    oBrowse:SetMenuDef("QUAA023H")

Return (oBrowse)

//==================================================================================================================
Static Function MenuDef()

    Local aRotina := FwMVCMenu("QUAA023H")

 Return (aRotina)

// ==================================================================================================================
Static Function ModelDef()

    Local oModel := MPFormModel():New("QAA015HM",/*bPre*/,/*bPost*/)
    Local oStruPBI := FwFormStruct(1, "PBI")

    oModel:AddFields("PBIMASTER", NIL, oStruPBI)
    oModel:SetPrimaryKey( { 'PBI_FILIAL' }, {'PBI_CODBON'} )
    oModel:SetDescription("Cadastro Tipo Documentos Motorista/Transportador" )
   oModel:GetModel("PBIMASTER"):SetDescription("Cadastro Tipo Documentos Motorista/Transportador")

Return (oModel)

//==================================================================================================================
Static Function ViewDef()

    Local oView := FwFormView():New()
    Local oStruPBI := FwFormStruct(2, "PBI")
    Local oModel := FwLoadModel("QUAA023H")

    oView:SetModel(oModel)
    oView:AddField("VIEW_PBI", oStruPBI, "PBIMASTER")
    oView:CreateHorizontalBox("SUPERIOR", 100)

Return (oView)
