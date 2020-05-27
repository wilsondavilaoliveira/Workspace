#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} QUAA015D()
Cadastro Bonificacoes fixas produtor de Leite
@author  Wilson Davila
@since 01/02/2020
/*/
User Function QUAA015D()

    Local oBrowse := FwLoadBrw("QUAA015D")
    oBrowse:Activate()

Return (NIL)

//====================================================================================================================
Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("LJT")
    oBrowse:SetDescription("Cadastro Bonificacoes Fixas Produtor ")
    oBrowse:AddFilter("FILIAL","LJT_FILIAL=="+cFilAnt,.T.,.T.)
    oBrowse:SetMenuDef("QUAA015D")
Return (oBrowse)

//====================================================================================================================
Static Function MenuDef()
    Local aRotina := FwMVCMenu("QUAA015D")
Return (aRotina)

//====================================================================================================================
Static Function ModelDef()

    Local oModel := MPFormModel():New("QAA015DM",/*bPre*/,/*bPost*/)
    Local oStruLJT := FwFormStruct(1, "LJT")

    oModel:AddFields("LJTMASTER", NIL, oStruLJT)
    oModel:SetPrimaryKey( { 'LJT_FILIAL' }, {'LJT_CODBON'} )
    oModel:SetDescription("Cadastro Bonificacao Fixa Produtor" )
    oModel:GetModel("LJTMASTER"):SetDescription(" Cadastro Bonificacoes Fixas Produtor")

Return (oModel)

//====================================================================================================================
Static Function ViewDef()
 
    Local oView := FwFormView():New()
    Local oStruLJT := FwFormStruct(2, "LJT")
    Local oModel := FwLoadModel("QUAA015D")
 
    oView:SetModel(oModel)
    oView:AddField("VIEW_LJT", oStruLJT, "LJTMASTER")
    oView:CreateHorizontalBox("SUPERIOR", 100)
 
Return (oView)