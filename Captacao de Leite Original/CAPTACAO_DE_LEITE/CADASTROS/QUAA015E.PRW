#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} QUAA015E()
Lancamento Bonificacoes Fixas Produtor de Leite
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
/*/
User Function QUAA015E()

    Local oBrowse := FwLoadBrw("QUAA015E")
    oBrowse:Activate()

Return (NIL)


// BROWSEDEF() SERA UTIL PARA FUTURAS HERANCAS: FWLOADBRW()
Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("LJU")
    oBrowse:SetDescription("Lancamento Bonificacoes Fixas Produtor")
    oBrowse:AddFilter("FILIAL","LJU_FILIAL=="+cFilAnt,.T.,.T.)
   // DEFINE DE ONDE SERÁ RETIRADO O MENUDEF
   oBrowse:SetMenuDef("QUAA015E")
Return (oBrowse)

// OPERACOES DA ROTINA
Static Function MenuDef()
    // FUNCAO PARA CRIAR MENUDEF
    Local aRotina := FwMVCMenu("QUAA015E")
    //ADD OPTION aRotina TITLE 'Ordem' ACTION 'U_QUAA015B' 		OPERATION 7                      ACCESS 0 //OPERATION X
Return (aRotina)

// REGRAS DE NEGOCIO
Static Function ModelDef()
    // INSTANCIA O MODELO
    //MPFormModel():new("ID_MODEL",/*bPre*/,/*bPost*/,bCommit)
    //Local bCommit := {|oMld| aOrdLJU(oModel)}
    Local oModel := MPFormModel():New("QAA015EM",/*bPre*/,/*bPost*/)

    // INSTANCIA OS SUBMODELOS
    Local oStruLJU := FwFormStruct(1, "LJU")
    //Local oStruLJT := FwFormStruct(1, "LJT")

    // DEFINE SE OS SUBMODELOS SERAO FIELD OU GRID
    oModel:AddFields("LJUMASTER", NIL, oStruLJU)
    //oModel:AddGrid("LJTDETAIL", "LJUMASTER", oStruLJT)

    // DEFINE A RELACAO ENTRE OS SUBMODELOS
   // oModel:SetRelation("LJTDETAIL", {{"LJT_FILIAL", "FwXFilial('LJT')"}, {"LJT_CODBON", "LJU_CODBON"}}, LJT->(IndexKey( 1 )))
    
    // Chave Primaria
    oModel:SetPrimaryKey( { 'LJU_FILIAL' }, {'LJU_CODPRO'}, {'LJU_CODBON'} , {'LJU_PERIOD'})
    
    // DESCRICAO DO MODELO
    oModel:SetDescription("Lancamento Bonificacao Fixa Produtor" )

    // DESCRICAO DOS SUBMODELOS
    oModel:GetModel("LJUMASTER"):SetDescription("Bonificacoes Fixas Produtor")
    //oModel:GetModel("LJTDETAIL"):SetDescription("Itens Classificacao")
Return (oModel)

// INTERFACE GRAFICA
Static Function ViewDef()
    // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // INSTANCIA AS SUBVIEWS
    Local oStruLJU := FwFormStruct(2, "LJU")
   // Local oStruLJT := FwFormStruct(2, "LJT")

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("QUAA015E")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_LJU", oStruLJU, "LJUMASTER")
    //oView:AddGrid("VIEW_LJT", oStruLJT, "LJTDETAIL")

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("SUPERIOR", 100)
    //oView:CreateHorizontalBox("INFERIOR", 75)

    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    //oView:SetOwnerView("VIEW_LJU", "SUPERIOR")
    //oView:SetOwnerView("VIEW_LJT", "INFERIOR")
    
    //oStruLJT:RemoveField( 'LJT_CODBON' )
    
    // DEFINE AUTO-INCREMENTO AO CAMPO
    //oView:AddIncrementField("VIEW_LJT", "LJT_ITEM")

    // DEFINE OS TITULOS DAS SUBVIEWS
    //oView:EnableTitleView("VIEW_LJT","ITENS")
Return (oView)

