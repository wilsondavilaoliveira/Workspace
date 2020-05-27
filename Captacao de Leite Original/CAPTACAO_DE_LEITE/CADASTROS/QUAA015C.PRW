#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} QUAA015C()
Criterios de Bonificacao Carreteiro
@author  Wilson Davila
@since 01/02/2020
/*/
User Function QUAA015C()

    Local oBrowse := FwLoadBrw("QUAA015C")
    oBrowse:Activate()

Return (NIL)
//==============================================================================================================
Static Function BrowseDef()

    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("LJS")
    oBrowse:SetDescription("Cadastro Bonificacoes Carreteiro")
    oBrowse:AddFilter("FILIAL","LJS_FILIAL==" + cFilAnt ,.T.,.T.)
    oBrowse:SetMenuDef("QUAA015C")

Return (oBrowse)

//==================================================================================================================
Static Function MenuDef()
   
    Local aRotina := FwMVCMenu("QUAA015C")

 Return (aRotina)

// ==================================================================================================================
Static Function ModelDef()
  
    Local oModel := MPFormModel():New("QAA015CM",/*bPre*/,/*bPost*/)
    Local oStruLJS := FwFormStruct(1, "LJS")
 
    oModel:AddFields("LJSMASTER", NIL, oStruLJS)
    oModel:SetPrimaryKey( { 'LJS_FILIAL' }, {'LJS_CODBON'} )
    oModel:SetDescription("Cadastro Bonificacoes Carreteiro" )
   oModel:GetModel("LJSMASTER"):SetDescription("Cadastro Bonificacoes Carreteiro")

Return (oModel)

//==================================================================================================================
Static Function ViewDef()
    
    Local oView := FwFormView():New()
    Local oStruLJS := FwFormStruct(2, "LJS")
    Local oModel := FwLoadModel("QUAA015C")

    oView:SetModel(oModel)
    oView:AddField("VIEW_LJS", oStruLJS, "LJSMASTER")
    oView:CreateHorizontalBox("SUPERIOR", 100)

Return (oView)