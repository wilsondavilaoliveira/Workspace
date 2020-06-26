#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} QUAA015G()|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
Leitura de Planilha Media Geometrica CBT Mensal
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 11/05/2020
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||/*/
User Function QUAA015G()

    Local oBrowse := FwLoadBrw("QUAA015G")
    oBrowse:Activate()

Return (NIL)


//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("LJO")
    oBrowse:SetDescription("Leitura Media Geometrica Mensal CBT")
    oBrowse:AddFilter("FILIAL","LJO_FILIAL=="+cFilAnt,.T.,.T.)
    oBrowse:SetMenuDef("QUAA015G")

Return (oBrowse)

// ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
Static Function MenuDef()

	ADD OPTION aRotina TITLE 'Ordem' ACTION 'U_QUAA015B' 		OPERATION 7                      ACCESS 0 //OPERATION X

Return (aRotina)

// ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
Static Function ModelDef()

	Local oModel := MPFormModel():New("QAA015EG",/*bPre*/,/*bPost*/)
	Local oStruLJO := FwFormStruct(1, "LJO")

    oModel:AddFields("LJOMASTER", NIL, oStruLJO)
    oModel:SetPrimaryKey( { 'LJO_FILIAL' }, {'LJO_CODPRO'}, {'LJO_DATCLQ'})
    oModel:SetDescription("Leitura Media Geometrica Mensal CBT" )
    oModel:GetModel("LJOMASTER"):SetDescription("Leitura Media Geometrica Mensal CBT")

Return (oModel)

// |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
Static Function ViewDef()

    Local oView := FwFormView():New()
    Local oStruLJO := FwFormStruct(2, "LJO")
    Local oModel := FwLoadModel("QUAA015G")

    oView:SetModel(oModel)
    oView:AddField("VIEW_LJO", oStruLJO, "LJOMASTER")

    oView:CreateHorizontalBox("SUPERIOR", 100)

Return (oView)

/*/{Protheus.doc} CriaBase() ===========================================================================================================================
Cria Arquivo Base de coletas do laboratorio media geometrica CBT caso nao exista
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 11/05/2020
=========================================================================================================================================================
/*/
Static Function GeraBase()

	Local cTipoBon		:= ' '
	Local nResLei 		:= 0
	Local nLitros			:= 0
	Local nDistan   	:= 0
	Private cAliasQry  	:= GetNextAlias()

	BeginSql Alias cAliasQry

	%noparser%

		SELECT DISTINCT LBB_CODPRO,LBB_CODTAN,LBB_TIPOL,LBB_LINHA,LJX_CODBON,LJX_DESC,LJX_ORDEM
		FROM %table:LBB% LBB (NOLOCK)
		INNER JOIN %table:LJX% LJX  (NOLOCK) ON LJX_FILIAL=LBB_FILIAL AND LJX.%notDel%
		WHERE LBB_FILIAL=%Exp:cFilAnt% AND LBB.%notDel%
		AND LBB_STATUS='S'
		AND LBB_CODPRO+LJX_CODBON NOT IN (
			SELECT LJZ_CODPRO+LJZ_CODBON
			FROM %table:LJZ% LJZ (NOLOCK)
			WHERE LJZ_FILIAL=%Exp:cFilAnt%
			AND LJZ_DATCLQ=%Exp:DTOS(MV_PAR01)%
			AND LJZ.%notDel%)
		ORDER BY LBB_CODPRO,LJX_ORDEM

	EndSql

	While (cAliasQry)->( !Eof() )

		MsProcTxt("Incluindo novos Produtores >>> " + (cAliasQry)->(LBB_CODPRO))

		dbselectArea("LJZ")
			RecLock("LJZ",.T.)
					LJZ->LJZ_FILIAL  		:= xFilial("LJZ")
					LJZ->LJZ_DATCLQ  	:= MV_PAR01
					LJZ->LJZ_CODPRO    :=  (cAliasQry)->(LBB_CODPRO)
					LJZ->LJZ_DATCLA  	 := dDataBase
					LJZ->LJZ_CODBON    := (cAliasQry)->(LJX_CODBON)
					LJZ->LJZ_DESBON  	:= (cAliasQry)->(LJX_DESC)
					LJZ->LJZ_QTDLEI       := 0
					LJZ->LJZ_RESLEI       := 0
			MsUnlock()

		(cAliasQry)->(dbSkip())

	Enddo

	DbSelectArea("LJZ") //Historico da classificacao da Qualidade do leite
	DbSetOrder(1)
    MsProcTxt("Recalculando Bonificacoes >>> ")
	If dbSeek( xFilial("LJZ") + Dtos(MV_PAR01 ))

		While !Eof() .AND. xFilial("LJZ") == LJZ->LJZ_FILIAL .AND. LJZ->LJZ_DATCLQ == MV_PAR01

			// 1-PLANILHA-> Sera usada planilha para entrar com dados no sistema,
			// 2-VOLUME->Sera usado o volume captado pelo produtor no sistema para calculo,
			// 3-DISTANCIA->Sera usado o campo distancia do produtor ate o laticinio do cadastro de propriedades,
			// 4-DIGITADO->No caso de adicional de Mercado para composicao do preco no simulador.
			LJZArea := GetArea()

			cTipoBon     := Posicione("LJX",1,XFILIAL("LJZ")+LJZ->LJZ_CODBON,"LJX_TPBON")

			If !cTipoBon $ ('2|3')
				RestArea(LJZArea)
				dbSkip()
				Loop
			EndiF

			If cTipoBon  ==  '2'  // VOLUME

				nLitrosAtu 	:= LJZ->LJZ_QTDLEI
				nLitros        := U_RetLitros(LJZ->LJZ_CODPRO)

				If nLitros <> nLitrosAtu
					nResLei 	  := U_QuaCAL21(Alltrim(LJZ->(LJZ_CODBON)),,nLitros)
				Else
					nLitros := 0
				EndiF

			ElseIf cTipoBon  ==  '3' // DISTANCIA

				nDistanAt  := LJZ->LJZ_QTDLEI
				nDistan 	   := Posicione("LBB",1,XFILIAL("LBB")+LJZ->LJZ_CODPRO,"LBB_DISTAN")

				If nDistan <> nDistanAt
					nResLei 	  := U_QuaCAL21(Alltrim(LJZ->(LJZ_CODBON)),,nDistan)
				Else
					nDistan := 0
				EndiF

			EndiF

			RestArea(LJZArea)



			If (nLitros+nDistan) > 0
				RecLock("LJZ",.F.)
					LJZ->LJZ_RESLEI		:= nResLei
					LJZ->LJZ_QTDLEI 	:= nLitros+nDistan
				MsUnlock()
			EndIf

			nLitros := 0
			nDistan := 0
			nResLei := 0

			dbSkip()

		EndDo

	Endif

Return .T.
