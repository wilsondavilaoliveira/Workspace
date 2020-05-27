#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} QUAA015F()
Lancamento Bonificacoes Carreteiro
@author  Wilson Davila
@since 01/02/2020
/*/

User Function QUAA015F()

    Local oBrowse := FwLoadBrw("QUAA015F")
    oBrowse:Activate()

Return (NIL)


// =================================================================================================================================================
Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("LJW")
    oBrowse:SetDescription("Lancamento Bonificacoes Carreteiro")
    oBrowse:AddFilter("FILIAL","LJW_FILIAL=="+cFilAnt,.T.,.T.)
    oBrowse:SetMenuDef("QUAA015F")

Return (oBrowse)

//==================================================================================================================================================
Static Function MenuDef()
    
     Local aRotina := FwMVCMenu("QUAA015F")
    
Return (aRotina)

// ==================================================================================================================================================
Static Function ModelDef()
    
    Local oModel := MPFormModel():New("QAA015FM",/*bPre*/,/*bPost*/)
    Local oStruLJW := FwFormStruct(1, "LJW")
    
    oModel:AddFields("LJWMASTER", NIL, oStruLJW)
    oModel:SetPrimaryKey( { 'LJW_FILIAL' }, {'LJW_CODBON'} )
    oModel:SetDescription("Lancamento Bonificacoes Carreteiro" )
    oModel:GetModel("LJWMASTER"):SetDescription("Lancamento Bonificacoes Carreteiro")
 
 Return (oModel)

//==================================================================================================================================================
Static Function ViewDef()
    
    Local oView := FwFormView():New()
    Local oStruLJW := FwFormStruct(2, "LJW")
    Local oModel := FwLoadModel("QUAA015F")

    oView:SetModel(oModel)
    oView:AddField("VIEW_LJW", oStruLJW, "LJWMASTER")
    oView:CreateHorizontalBox("SUPERIOR", 25)
    oView:CreateHorizontalBox("INFERIOR", 75)

Return (oView)

/*/{Protheus.doc} XVALLJW
   @Wilson Davila
    @since 30/04/2020
    /*/
User  Function XVALLJW()
    Local lRet := .T.

    M->LJW_TPPAG := POSICIONE("LJS",1,XFILIAL("LJS")+M->LJW_CODBON,"LJS_TPPAGT")                                                                     

Return lRet