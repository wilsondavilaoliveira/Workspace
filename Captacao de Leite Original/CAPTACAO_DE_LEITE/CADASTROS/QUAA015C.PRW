#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} QUAA015C()
Criterios de Bonificacao Qualidade Leite
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
/*/

///////////////////////FUNCAO PRINCIPAL
User Function QUAA015C()

    Local oBrowse := FwLoadBrw("QUAA015C")
    oBrowse:Activate()

Return (NIL)


// BROWSEDEF() SERA UTIL PARA FUTURAS HERANCAS: FWLOADBRW()
Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("LJS")
    oBrowse:SetDescription("Cabecalho Bonificacoes")
    oBrowse:AddFilter("FILIAL","LJS_FILIAL=="+cFilAnt,.T.,.T.)
   // DEFINE DE ONDE SERÁ RETIRADO O MENUDEF
   oBrowse:SetMenuDef("QUAA015C")
Return (oBrowse)

// OPERACOES DA ROTINA
Static Function MenuDef()
    // FUNCAO PARA CRIAR MENUDEF
    Local aRotina := FwMVCMenu("QUAA015C")
    //ADD OPTION aRotina TITLE 'Ordem' ACTION 'U_QUAA015B' 		OPERATION 7                      ACCESS 0 //OPERATION X
Return (aRotina)

// REGRAS DE NEGOCIO
Static Function ModelDef()
    // INSTANCIA O MODELO
    //MPFormModel():new("ID_MODEL",/*bPre*/,/*bPost*/,bCommit)
    Local bCommit := {|oMld| aOrdLJS(oModel)}
    Local oModel := MPFormModel():New("QAA015CM",/*bPre*/,/*bPost*/,bCommit)

    // INSTANCIA OS SUBMODELOS
    Local oStruLJS := FwFormStruct(1, "LJS")
    Local oStruLJT := FwFormStruct(1, "LJT")

    // DEFINE SE OS SUBMODELOS SERAO FIELD OU GRID
    oModel:AddFields("LJSMASTER", NIL, oStruLJS)
    oModel:AddGrid("LJTDETAIL", "LJSMASTER", oStruLJT)

    // DEFINE A RELACAO ENTRE OS SUBMODELOS
    oModel:SetRelation("LJTDETAIL", {{"LJT_FILIAL", "FwXFilial('LJT')"}, {"LJT_CODBON", "LJS_CODBON"}}, LJT->(IndexKey( 1 )))
    
    // Chave Primaria
    oModel:SetPrimaryKey( { 'LJS_FILIAL' }, {'LJS_CODBON'} )
    
    // DESCRICAO DO MODELO
    oModel:SetDescription("Criterios de Qualidade Carreteiro" )

    // DESCRICAO DOS SUBMODELOS
    oModel:GetModel("LJSMASTER"):SetDescription("Cabecalho Bonificacoes")
    oModel:GetModel("LJTDETAIL"):SetDescription("Itens Classificacao")
Return (oModel)

// INTERFACE GRAFICA
Static Function ViewDef()
    // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // INSTANCIA AS SUBVIEWS
    Local oStruLJS := FwFormStruct(2, "LJS")
    Local oStruLJT := FwFormStruct(2, "LJT")

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("QUAA015C")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_LJS", oStruLJS, "LJSMASTER")
    oView:AddGrid("VIEW_LJT", oStruLJT, "LJTDETAIL")

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("SUPERIOR", 25)
    oView:CreateHorizontalBox("INFERIOR", 75)

    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VIEW_LJS", "SUPERIOR")
    oView:SetOwnerView("VIEW_LJT", "INFERIOR")
    
    oStruLJT:RemoveField( 'LJT_CODBON' )
    
    // DEFINE AUTO-INCREMENTO AO CAMPO
    oView:AddIncrementField("VIEW_LJT", "LJT_ITEM")

    // DEFINE OS TITULOS DAS SUBVIEWS
    oView:EnableTitleView("VIEW_LJT","ITENS")
Return (oView)

