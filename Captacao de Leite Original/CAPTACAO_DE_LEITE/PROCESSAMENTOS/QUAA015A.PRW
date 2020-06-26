#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} QUAA015A()
Criterios de Bonificacao Qualidade Leite
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
/*/

///////////////////////FUNCAO PRINCIPAL
User Function QUAA015A()

    Local oBrowse := FwLoadBrw("QUAA015A")

    GeraLJX()

    oBrowse:Activate()

Return (NIL)


// BROWSEDEF() SERA UTIL PARA FUTURAS HERANCAS: FWLOADBRW()
Static Function BrowseDef()

    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("LJX")
    oBrowse:SetDescription("Cabecalho Bonificacoes")
    oBrowse:AddFilter("FILIAL","LJX_FILIAL=="+cFilAnt,.T.,.T.)
    oBrowse:AddLegend( "LJX_CODBON $ '000001|000002'", "RED","RESERVADO SISTEMA")
    oBrowse:AddLegend( "!LJX_CODBON $ '000001|000002'", "GREEN","LIVRE USUARIO")
    oBrowse:SetMenuDef("QUAA015A")

Return (oBrowse)

// OPERACOES DA ROTINA
Static Function MenuDef()

    Private aRotina := {} //FwMVCMenu("QUAA015A")

    ADD OPTION aRotina TITLE 'Visualizar' 	ACTION 'VIEWDEF.QUAA015A'    OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'      ACTION 'VIEWDEF.QUAA015A'    OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'      ACTION 'U_Qua15Alt(4)'       OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Ordem"        ACTION "U_QUAA015B()"        OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Legenda"      ACTION "U_LegQA15A()"        OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'      ACTION 'U_Qua15Alt(5)'       OPERATION 5 ACCESS 0

Return (aRotina)

// REGRAS DE NEGOCIO
Static Function ModelDef()
    // INSTANCIA O MODELO
    //MPFormModel():new("ID_MODEL",/*bPre*/,/*bPost*/,bCommit)
    Local bCommit   := {|oMld| aOrdLJX(oModel)}
    //Local bPre          := {|oMld| Valid(oMld)}

    Local oModel := MPFormModel():New("QAA015AM",/*bPre*/,/*bPost*/,bCommit)

    // INSTANCIA OS SUBMODELOS
    Local oStruLJX := FwFormStruct(1, "LJX")
    Local oStruLJY := FwFormStruct(1, "LJY")

    // DEFINE SE OS SUBMODELOS SERAO FIELD OU GRID
    oModel:AddFields("LJXMASTER", NIL, oStruLJX)
    oModel:AddGrid("LJYDETAIL", "LJXMASTER", oStruLJY)

    // DEFINE A RELACAO ENTRE OS SUBMODELOS
    oModel:SetRelation("LJYDETAIL", {{"LJY_FILIAL", "FwXFilial('LJY')"}, {"LJY_CODBON", "LJX_CODBON"}}, LJY->(IndexKey( 1 )))

    // Chave Primaria
    oModel:SetPrimaryKey( { 'LJX_FILIAL' }, {'LJX_CODBON'} )

    // DESCRICAO DO MODELO
    oModel:SetDescription("Criterios de Qualidade Leite" )

    // DESCRICAO DOS SUBMODELOS
    oModel:GetModel("LJXMASTER"):SetDescription("Cabecalho Bonificacoes")
    oModel:GetModel("LJYDETAIL"):SetDescription("Itens Classificacao")

Return (oModel)

// INTERFACE GRAFICA
Static Function ViewDef()
    // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // INSTANCIA AS SUBVIEWS
    Local oStruLJX := FwFormStruct(2, "LJX")
    Local oStruLJY := FwFormStruct(2, "LJY")

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("QUAA015A")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_LJX", oStruLJX, "LJXMASTER")
    oView:AddGrid("VIEW_LJY", oStruLJY, "LJYDETAIL")

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("SUPERIOR", 35)
    oView:CreateHorizontalBox("INFERIOR", 65)

    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VIEW_LJX", "SUPERIOR")
    oView:SetOwnerView("VIEW_LJY", "INFERIOR")

    oStruLJY:RemoveField( 'LJY_CODBON' )

    // DEFINE AUTO-INCREMENTO AO CAMPO
    oView:AddIncrementField("VIEW_LJY", "LJY_ITEM")

    // DEFINE OS TITULOS DAS SUBVIEWS
    oView:EnableTitleView("VIEW_LJY","ITENS")

Return (oView)

User Function OrdemLJX()

Local nRet := 0
Local cAlLJX :=  GetNextAlias()

If INCLUI .AND. M->LJX_PLAN=='S'

	Beginsql Alias cAlLJX

			%NOPARSER%

			SELECT MAX(LJX_ORDEM)+1 AS ORDEM FROM %table:LJX% LJX WHERE LJX_PLAN='S' AND LJX_FILIAL=%Exp:cFilAnt% AND LJX.%notDel%


	Endsql

	If !Empty((cAlLJX)->(ORDEM))
		nRet := (cAlLJX)->(ORDEM)
	Else
		nRet := 1
	End If

EndIf

M->LJX_ORDEM := nRet

Return .T.


Static Function aOrdLJX(oModel)

	Local cAliasLJX := 'LJXQRY'
	Local nOrdem	:= 1
	Local lRet := fwformcommit(oModel)

	If lRet

		BeginSql Alias cAliasLJX
			%noparser%
			SELECT LJX_CODBON,LJX_DESC,LJX_ORDEM,R_E_C_N_O_ AS REC
			FROM %table:LJX% LJX
			WHERE LJX.D_E_L_E_T_='' AND LJX_PLAN='S' AND LJX_FILIAL=%EXP:cFilAnt%
			ORDER BY LJX_ORDEM
		EndSql

		While (cAliasLJX)->( !Eof())
			TcSqlExec("UPDATE " + RetSqlName("LJX") + " SET LJX_ORDEM=" + cValToChar(nOrdem) + " WHERE  R_E_C_N_O_=" + cValToChar((cAliasLJX)->(REC)))
			nOrdem ++
			(cAliasLJX)->( dbSkip() )
		EndDo

		(cAliasLJX)->( dbCloseArea())

	End If
Return lRet

/*/{Protheus.doc} Qua15Alt()
Funcao auxiliar para validar exclusao e alteracao de bonificacoes 1 e 2 - antibiotico e CBT Geometrica
@type function
@version
@author wilso
@since 27/05/2020
@param nOp, numeric, param_description
@return return_type, return_description
/*/
User Function Qua15Alt(nOp)

   Local lRet := .T.

   IF LJX->LJX_CODBON $ '000001|000002'
        Help( ,, 'HELP',, 'Operacao nao pode ser efetuada! Bonificacoes fixas do sistema!', 1, 0)
        lRet := .F.
   Else
        FWExecView("Alterar", "QUAA015A",nOp,, {||.T.})
   EndIf

Return lRet

/*/{Protheus.doc} GeraLJX
description
@type function
@version
@author wilso
@since 27/05/2020
@return return_type, return_description
/*/
Static Function GeraLJX()

    Local aArea := GetArea()

    dbSelectArea("LJX")
    dbSetOrder(1)

    If !dbSeek(xFilial("LJX")+'000001')

        RecLock("LJX",.T.)
            LJX->LJX_FILIAL := cFilAnt
            LJX->LJX_CODBON := '000001'
            LJX->LJX_DESC   := 'ANTIBIOTICO'
            LJX->LJX_DESRED := 'ANTIB'
            LJX->LJX_PADRAO := 'NEG'
            LJX->LJX_TIPOL  := 'A'
            LJX->LJX_PAGA   := 'N'
            LJX->LJX_PLAN   := 'S'
            LJX->LJX_ORDEM  := 1
            LJX->LJX_EDITA  := 'N'
            LJX->LJX_RELATO := 'S'
            LJX->LJX_TPBON  := '5'
        MsUnlock()

        RecLock("LJX",.T.)
            LJX->LJX_FILIAL := cFilAnt
            LJX->LJX_CODBON := '000002'
            LJX->LJX_DESC   := 'CBT MEDIA GEOMETRICA'
            LJX->LJX_DESRED := 'CBT GEO'
            LJX->LJX_PADRAO := '<=300'
            LJX->LJX_TIPOL  := 'A'
            LJX->LJX_PAGA   := 'N'
            LJX->LJX_PLAN   := 'N'
            LJX->LJX_ORDEM  := 0
            LJX->LJX_EDITA  := 'N'
            LJX->LJX_RELATO := 'S'
            LJX->LJX_TPBON  := '6'
        MsUnlock()

    EndIf

    RestArea(aArea)

Return

User Function LegQA15A()
                      //Legenda
BrwLegenda( "Cadastro de Bonificacoes","Legenda", { { "BR_VERMELHO" ,"Reservado Sistema"      } ,;
								                    { "BR_VERDE"    ,"Livre para Cadastro"    } } ) // Cliente

Return( .T. )
