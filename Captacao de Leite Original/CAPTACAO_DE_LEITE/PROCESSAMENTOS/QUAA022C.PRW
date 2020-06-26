#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PRCONST.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} QUAA022C() ============================================================================================================================
Simulador de preco de leite produtor
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
User Function QUAA022C()

    Local aCoors      := FWGetDialogSize( oMainWnd )
    Local cCadastro   := "SIMULADOR PRECOS LEITE PRODUTOR"
    Local aSize       := ''
    Local aInfo       := ''
    Local oC1W1
    Local oButt1
    Local oPanPri

    Private nPrMdFl   := 0
    Private nPrBase   := 0
    Private nPerInc   := 0
    Private nPerFun   := 0
    Private nPrReal   := 0
    Private cHead     := ''
    Private nHead     := 0
    Private aHead     := {}
    Private aPrcLeite := {}
    Private aAlter    := {}
    Private aCpo      := {}
    Private aCabec    := {}
    Private nTotal    := 0
    Private oPanBotoes
    Private oDlg1
    Private oPrMedFL
    Private oPrcLeite
    Private oPrReal
    Private oPerInc
    Private oPerRur

    Private nCLCodPro   := 1    //CODIGO PRODUTOR
    Private nCLNomPro   := 2    //NOME PRODUTOR
    Private nCLFamili   := 3    //FAMILIA PRODUTOR
    Private nCLLitAnt   := 4    //LITROS TOTAL MES ANTERIOR
    Private nCLMdLtDA   := 5    //MEDIA LITROS DIA MES ANTERIOR
    Private nCLPrcAnt   := 6    //PRECO MES ANTERIOR
    Private nCLLitros   := 7    //LITROS TOTAL MES ATUAL
    Private nCLMedDia   := 8    //MEDIA LITROS DIA MES ATUAL
    Private nCLPrBase   := 9    //PRECO BASE MES ATUAL
    Private nCLPrFim    := 10   //PRECO FINAL MEA ATUAL
    Private nCLFrete    := 11   //FRETE MES ATUAL
    Private nCLIncen    := 12   //INCENTIVO FISCAL MES ATUAL
    Private nCLFunRur   := 13   //FUN.RURAL MES ATUAL
    Private nColuna     := 14   //COLUNA INICIA BONIFICACOES VARIAVEIS


	If !Pergunte("QUAA22C",.T.)
		Return
	End If

	LJV->(dbSetOrder(1))
	If !LJV->(dbSeek(xFilial("LJV")+DTOS(MV_PAR01)))
		MsgStop("Tabela de preco medio do mes nao existe, corrija o cadastro para executar simulador!")
		Return
	EndIf

	DEFINE FONT oFont2	NAME "Arial" SIZE 11,17 BOLD

	DEFINE MSDIALOG oDlg1 FROM aCoors[1],aCoors[2] TO aCoors[3],aCoors[4] TITLE cCadastro OF oMainWnd COLOR "W+/W" STYLE nOR(WS_VISIBLE,WS_POPUP) PIXEL

	oDlg1:lEscClose:= .T.
	oDlg1:lMaximized := .T.
	oFWLayer:= FWLayer():New()
	oFWLayer:init( oDlg1, .F. ) // Segundo parametro: Cria um botao de fechar utilizado para Dlg sem cabeçalho. Caso for .t.

	//COLUNA - JANELA 1=====================================================================================================================================
	oFWLayer:addCollumn( "Col01", 100, .F. )
	oFWLayer:addWindow( "Col01", "Win01", cCadastro, 100, .T., .F.)
	oC1W1:= oFWLayer:getWinPanel( "Col01", "Win01" )

	//Painel Principal dos Botoes para as Manutencoes e Pesquisa
	oPanPri	:=TPanel():New(1,3,,oC1W1,oFont2,,,/*CorTexto*/,/*CLR_GREEN*/,80,15,.T.,.T.)
	oPanPri :ALIGN:= CONTROL_ALIGN_TOP

	//Painel dos Botoes para Manutencoes
	oPanBotoes:=TPanel():New(1,3,,oPanPri,/*[aoFont]*/,,,/*CorTexto*/,/*CLR_GREEN*/,090,15,.T.,.T.)
	oPanBotoes:ALIGN:= CONTROL_ALIGN_LEFT

	//Painel com os precos
	oPanped	:=TPanel():New(1,3,,oPanPri,oFont2,,,/*CLR_BLUE*/,/*CLR_BLUE*/,580,15,.f.,.f.) //200,07
	oPanped :ALIGN:= CONTROL_ALIGN_RIGHT


	nPrMdFl := Posicione("LJV",1,XFILIAL("LJV")+DTOS(MV_PAR01),"LJV_PRFIX")
	nPrBase := Posicione("LJV",1,XFILIAL("LJV")+DTOS(MV_PAR01),"LJV_PRBASE")
	nPerInc	:= Posicione("LJV",1,XFILIAL("LJV")+DTOS(MV_PAR01),"LJV_INCENT")
	nPerFun	:= Posicione("LJV",1,XFILIAL("LJV")+DTOS(MV_PAR01),"LJV_FUNRUR")

	@004.3	,005 SAY "% INCENTIVO:"	SIZE 080,10 OF oPanped 	PIXEL FONT oFont2 COLOR CLR_RED
	@2.0	,075 MSGET oPerInc VAR nPerInc	SIZE 040,10 OF oPanped 	PIXEL FONT oFont2 When .F.  PICTURE "@E 99.99%"

	@004.3	,130 SAY "% FUN.RURAL:"	SIZE 080,10 OF oPanped 	PIXEL FONT oFont2 COLOR CLR_RED
	@2.0	,203 MSGET oPerRur 	VAR nPerFun	SIZE 040,10 OF oPanped 	PIXEL FONT oFont2 WHEN .F. PICTURE "@E 99.99%"

	@004.3	,260 SAY "$ MEDIO META:"	SIZE 080,10 OF oPanped 	PIXEL FONT oFont2 COLOR CLR_BLUE
	@2.0	,335 MSGET oPrMedFL VAR nPrMdFl	SIZE 060,10 OF oPanped 	PIXEL FONT oFont2 When .F.  PICTURE "@E 99.999"

	@004.3	,404 SAY "$ MEDIO REAL:"	SIZE 080,10 OF oPanped 	PIXEL FONT oFont2 COLOR CLR_GREEN
	@2.0	,480 MSGET oPrReal 	VAR nPrReal	SIZE 060,10 OF oPanped 	PIXEL FONT oFont2 WHEN .F. PICTURE "@E 99.999"

	//BOTOES
	oButt1:= FWButtonBar():new()
	oButt1:Init(oPanBotoes, 17, 25,CONTROL_ALIGN_TOP, .T. )
	oButt1:addBtnImage( "Final","Sair",{|| oDlg1:End()},,.T.,CONTROL_ALIGN_LEFT)

	aHead := xCabLJX()
	aSize := MsAdvSize()
	aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	aPrcLeite := {}
	oPrcLeite := MsNewGetDados():New(025,;                //nTop      - Linha Inicial
	                                001,;                //nLeft     - Coluna Inicial
	                                300,;     			 //nBottom   - Linha Final
	                                650,;     			 //nRight    - Coluna Final
	                                GD_UPDATE,;			 //nStyle    - Estilos para edição da Grid (GD_INSERT = Inclusão de Linha; GD_UPDATE = Alteração de Linhas; GD_DELETE = Exclusão de Linhas)
	                                "AllwaysTrue",;    	//cLinhaOk  - Validação da linha
	                                "AllwaysTrue",;     //cTudoOk   - Validação de todas as linhas
	                                "AllwaysTrue",;     //cIniCpos  - Função para inicialização de campos
	                                aAlter,;  			//aAlter    - Colunas que podem ser alteradas
	                                2,;                   //nFreeze   - Número da coluna que será congelada
	                                9999,;               //nMax      - Máximo de Linhas
	                                "AllwaysTrue",;                   //cFieldOK  - Validação da coluna
	                                ,;                   //cSuperDel - Validação ao apertar '+'
	                                ,;                   //cDelOk    - Validação na exclusão da linha
	                                oC1W1,;            	 //oWnd      - Janela que é a dona da grid
	                                aHead,;           	 //aHeader   - Cabeçalho da Grid
	                                aPrcLeite)

	oPrcLeite:SetEditLine (.T.)
	oPrcLeite:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	 Processa( {||LoadOrdem(oPrcLeite,.T.,cHead)},"Aguarde...","Carregando...", .F. )


	ACTIVATE MSDIALOG oDlg1

Return


/*/{Protheus.doc} Lin_OnOff()============================================================================================================================
Simulador de preco de leite produtor
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static Function Lin_OnOff (oPrcLeite,aPrcLeite)


	If oPrcLeite:ColPos == 1 .AND. oPrcLeite:nAT > 1
		oPrcLeite:aArray[oPrcLeite:nAT,03] := oPrcLeite:aArray[oPrcLeite:nAT,03]-1
		oPrcLeite:aArray[(oPrcLeite:nAT)-1,03] := oPrcLeite:aArray[(oPrcLeite:nAT)-1,03]+1
		oPrcLeite:GoUp()
	ElseIf oPrcLeite:ColPos == 2 .AND. oPrcLeite:nAT <> Len(aPrcLeite)
		oPrcLeite:aArray[oPrcLeite:nAT,03] := oPrcLeite:aArray[oPrcLeite:nAT,03]+1
		oPrcLeite:aArray[(oPrcLeite:nAT)+1,03] := oPrcLeite:aArray[(oPrcLeite:nAT)+1,03]-1
		oPrcLeite:GoDown()
	EndIf

	Processa( {||LoadOrdem(oPrcLeite,.T.,cHead)},"Aguarde...","Carregando...", .F. )

	oPrcLeite:Refresh()

Return


/*/{Protheus.doc} LoadOrdem()============================================================================================================================
Carrega Grid
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static Function LoadOrdem (oPrcLeite,lAjusta)

	//Local oSt			:= LoadBitmap(GetResources(),'PMSSETAUP')
	//Local oSt2			:= LoadBitmap(GetResources(),'PMSSETADOWN')
	Local cQuery		:= ''
	Local nArray		:= 1
	Local nPrTotal		:= nPrBase
	Local cAliasQry		:= "QUAA22C"
	Local xIncen		:= 0
	Local xFun			:= 0
	Local cNomPro		:= ''
    Local cMes  := ''
    Local cAno  := ''
	Local dData := MV_PAR01

    aPrcLeite := {}

   			If month(dData) == 1
                cMes := '12'
                cAno := cValToChar(year(ddata)-1)
            Else
                cMes := cValToChar(month(ddata)-1)
                cAno := cValToChar(year(ddata))
            EndIf


			BeginSql Alias cAliasQry


            %noparser%

				SELECT DISTINCT PC1_CODPRO,A2_NOME,LBB_DESC,LBB_NOMFOR,LJX_EDITA,
                ISNULL((SELECT ZXR_DESC FROM %table:ZXR% ZXR WHERE ZXR_CODFAM=LBB_CODFAM AND ZXR_FILIAL=LBB_FILIAL AND ZXR.%notDel%),
                ISNULL((SELECT ZXR_DESC FROM %table:ZXR% ZXR WHERE ZXR_CODPAI=LBB_CODPRO AND ZXR_FILIAL=LBB_FILIAL AND ZXR.%notDel%),'SEM FAMILIA')) AS ZXR_DESC,
                ROUND(SUM(PC1_QTDLIT),0) AS PC1_QTDLIT,
				ROUND(AVG(PC1_VLRLIT),2) AS PC1_VLRLIT,ROUND(ROUND(SUM(PC1_QTDLIT),0)/COUNT(PC0_DTENTR),0) AS MEDLIT,
                LJX_CODBON,LJX_DESC,LJX_ORDEM,ISNULL(ROUND(AVG(LJZ_RESLEI),3),0) AS LJZ_RESLEI,

                (SELECT ROUND(SUM(PC1_QTDLIT),0)
                 FROM %table:PC0% PC0
                 INNER JOIN %table:PC1% PC1 ON PC1_CODPRO=LBB_CODPRO AND PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
                 WHERE PC0_FILIAL=%EXP:cFilAnt% AND PC0_TPENTR='1' AND MONTH(PC0_DTENTR)=%Exp:cMes% AND YEAR(PC0_DTENTR)=%Exp:cAno% AND PC0.%notDel%) AS QTDLIT_A,
                 (SELECT ROUND(AVG(PC1_VLRLIT),2) AS VLRLITA
                 FROM %table:PC0% PC0
                 INNER JOIN %table:PC1% PC1 ON PC1_CODPRO=LBB_CODPRO AND PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
                 WHERE PC0_FILIAL=%EXP:cFilAnt% AND PC0_TPENTR='1' AND MONTH(PC0_DTENTR)=%Exp:cMes% AND YEAR(PC0_DTENTR)=%Exp:cAno% AND PC0.%notDel%) AS VLRLIT_A,
                 ROUND(((SELECT ROUND(SUM(PC1_QTDLIT),0)
                 FROM %table:PC0% PC0
                 INNER JOIN %table:PC1% PC1 ON PC1_CODPRO=LBB_CODPRO AND PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
                 WHERE PC0_FILIAL=%EXP:cFilAnt% AND PC0_TPENTR='1' AND MONTH(PC0_DTENTR)=%Exp:cMes% AND YEAR(PC0_DTENTR)=%Exp:cAno% AND PC0.%notDel%)/
                 (SELECT COUNT(PC0_DTENTR)
                 FROM %table:PC0% PC0
                 INNER JOIN %table:PC1% PC1 ON PC1_CODPRO=LBB_CODPRO AND PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
                 WHERE PC0_FILIAL=%EXP:cFilAnt% AND PC0_TPENTR='1' AND MONTH(PC0_DTENTR)=%Exp:cMes% AND YEAR(PC0_DTENTR)=%Exp:cAno% AND PC0.%notDel%)),0) AS MEDLIT_A

				FROM %table:PC0% PC0
				INNER JOIN %table:PC1% PC1 ON PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
				INNER JOIN %table:LBB% LBB ON LBB_FILIAL=PC0_FILIAL AND LBB_CODPRO=PC1_CODPRO AND LBB.%notDel%
				INNER JOIN %table:SA2% SA2 ON A2_COD=LBB_CODFOR AND A2_LOJA=LBB_LOJA AND SA2.%notDel%
				INNER JOIN %table:LJX% LJX ON LJX_FILIAL=PC1_FILIAL AND LJX_PAGA='S' AND LJX.%notDel%
				LEFT  JOIN %table:LJZ% LJZ ON LJZ_FILIAL=LJX_FILIAL AND LJZ_CODBON=LJX_CODBON AND LJZ_CODPRO=LBB_CODPRO
				AND LJZ_DATCLQ=%EXP:MV_PAR01% AND LJZ.%notDel%
				WHERE PC0_FILIAL=%EXP:cFilAnt% AND PC0.%notDel%  AND PC0_TPENTR='1'
				AND MONTH(PC0_DTENTR)=%Exp:Month(MV_PAR01)% AND YEAR(PC0_DTENTR)=%Exp:Year(MV_PAR01)%
				GROUP BY PC1_CODPRO,A2_NOME,LBB_DESC,LBB_NOMFOR,LBB_CODPRO,LJX_CODBON,LJX_DESC,LJX_ORDEM,LBB_CODFAM,LBB_FILIAL,LJX_EDITA

                UNION ALL

                SELECT PC1_CODPRO,LBB_NOMFOR  AS  A2_NOME,LBB_DESC,LBB_NOMFOR,'N' AS LJX_EDITA,
                ISNULL((SELECT ZXR_DESC FROM %table:ZXR% ZXR WHERE ZXR_CODFAM=LBB_CODFAM AND ZXR_FILIAL=LBB_FILIAL AND ZXR.%notDel%),
                ISNULL((SELECT ZXR_DESC FROM %table:ZXR% ZXR WHERE ZXR_CODPAI=LBB_CODPRO AND ZXR_FILIAL=LBB_FILIAL AND ZXR.%notDel%),'SEM FAMILIA')) AS ZXR_DESC,
                ROUND(SUM(PC1_QTDLIT),0) AS PC1_QTDLIT,
				ROUND(AVG(PC1_VLRLIT),2) AS PC1_VLRLIT,ROUND(ROUND(SUM(PC1_QTDLIT),0)/COUNT(PC0_DTENTR),0) AS MEDLIT,
				'999999'  AS  LJX_CODBON, 'BONIF.FIXA'  AS  LJX_DESC,99  AS  LJX_ORDEM,
                ISNULL(
                (SELECT SUM(LJU_VALOR) FROM %table:LJU% LJU WHERE  LJU_FILIAL=PC0_FILIAL AND LJU_CODPRO=PC1_CODPRO
                AND LJU_PERIOD=%EXP:SubStr(dtoc(MV_PAR01),4,2)+SubStr(dtoc(MV_PAR01),7,4)% AND LJU.%notDel% )
                /SUM(PC1_QTDLIT),0)  AS  LJZ_RESLEI,

                (SELECT ROUND(SUM(PC1_QTDLIT),0)
                 FROM %table:PC0% PC0
                 INNER JOIN %table:PC1% PC1 ON PC1_CODPRO=LBB_CODPRO AND PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
                 WHERE PC0_FILIAL=%EXP:cFilAnt% AND PC0_TPENTR='1' AND MONTH(PC0_DTENTR)=%Exp:cMes% AND YEAR(PC0_DTENTR)=%Exp:cAno% AND PC0.%notDel%) AS QTDLIT_A,
                 (SELECT ROUND(AVG(PC1_VLRLIT),2) AS VLRLITA
                 FROM %table:PC0% PC0
                 INNER JOIN %table:PC1% PC1 ON PC1_CODPRO=LBB_CODPRO AND PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
                 WHERE PC0_FILIAL=%EXP:cFilAnt% AND PC0_TPENTR='1' AND MONTH(PC0_DTENTR)=%Exp:cMes% AND YEAR(PC0_DTENTR)=%Exp:cAno% AND PC0.%notDel%) AS VLRLIT_A,
                 ROUND(((SELECT ROUND(SUM(PC1_QTDLIT),0)
                 FROM %table:PC0% PC0
                 INNER JOIN %table:PC1% PC1 ON PC1_CODPRO=LBB_CODPRO AND PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
                 WHERE PC0_FILIAL=%EXP:cFilAnt% AND PC0_TPENTR='1' AND MONTH(PC0_DTENTR)=%Exp:cMes% AND YEAR(PC0_DTENTR)=%Exp:cAno% AND PC0.%notDel%)/
                 (SELECT COUNT(PC0_DTENTR)
                 FROM %table:PC0% PC0
                 INNER JOIN %table:PC1% PC1 ON PC1_CODPRO=LBB_CODPRO AND PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
                 WHERE PC0_FILIAL=%EXP:cFilAnt% AND PC0_TPENTR='1' AND MONTH(PC0_DTENTR)=%Exp:cMes% AND YEAR(PC0_DTENTR)=%Exp:cAno% AND PC0.%notDel%)),0) AS MEDLIT_A

				FROM  %table:PC0% PC0
				INNER JOIN  %table:PC1% PC1 ON PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
				INNER JOIN  %table:LBB% LBB ON LBB_FILIAL=PC0_FILIAL AND LBB_CODPRO=PC1_CODPRO AND LBB.%notDel%
				INNER JOIN  %table:SA2% SA2 ON A2_COD=LBB_CODFOR AND A2_LOJA=LBB_LOJA AND SA2.%notDel%
				WHERE PC0_FILIAL=%EXP:cFilAnt%AND PC0.%notDel% AND MONTH(PC0_DTENTR)=%Exp:Month(MV_PAR01)% AND YEAR(PC0_DTENTR)=%Exp:Year(MV_PAR01)%
				AND PC0_TPENTR='1'
				GROUP BY PC0_FILIAL,PC1_CODPRO,LBB_NOMFOR,LBB_CODPRO,LBB_DESC,LBB_CODFAM,LBB_FILIAL
				ORDER BY ZXR_DESC,PC1_CODPRO,LJX_ORDEM,LJX_EDITA DESC,LJX_CODBON

			EndSql

			aRet := GetLastQuery()

			MemoWrite("C:\HD\QUERYS\QUAA22C.SQL",aRet[2])


			nLinha := 1

			cCodPro := (cAliasQry)->(PC1_CODPRO)

			While (cAliasQry)->( !Eof() )
				If cCodPro <> (cAliasQry)->(PC1_CODPRO)
					nArray ++
					cCodPro := (cAliasQry)->(PC1_CODPRO)
				EndIf
				(cAliasQry)->(dbSkip())
			EndDo

			aPrcLeite := Array(nArray,Len(aCabec)+1)

			(cAliasQry)->(dbGoTop())
			cCodPro := (cAliasQry)->(PC1_CODPRO)

			ProcRegua(nArray)

			While (cAliasQry)->(!Eof())

					If cCodPro == (cAliasQry)->(PC1_CODPRO)
						aPrcLeite[nLinha][nCLCodPro] := (cAliasQry)->(PC1_CODPRO)
						aPrcLeite[nLinha][nCLNomPro] := (cAliasQry)->(LBB_NOMFOR)
						aPrcLeite[nLinha][nCLFamili] := (cAliasQry)->(ZXR_DESC)
                        aPrcLeite[nLinha][nCLLitAnt] := (cAliasQry)->(QTDLIT_A)
                        aPrcLeite[nLinha][nCLMdLtDA] := (cAliasQry)->(MEDLIT_A)
                        aPrcLeite[nLinha][nCLPrcAnt] := (cAliasQry)->(VLRLIT_A)
                        aPrcLeite[nLinha][nCLLitros] := (cAliasQry)->(PC1_QTDLIT)
                        aPrcLeite[nLinha][nCLMedDia] := (cAliasQry)->(MEDLIT)

						aPrcLeite[nLinha][nCLPrBase] := nPrBase
						aPrcLeite[nLinha][nCLFrete] := nFrete((cAliasQry)->(PC1_CODPRO))
						cNomPro := (cAliasQry)->(LBB_NOMFOR)
						aPrcLeite[nLinha][nColuna] := (cAliasQry)->(LJZ_RESLEI)
						nPrTotal += (cAliasQry)->(LJZ_RESLEI)
						nColuna ++
					Else
						IncProc("Processando Produtor > " + AllTrim(cCodPro)+"-"+Alltrim(cNomPro))
						xIncen 	:= nIncen(cCodPro)
						xFun	:= nFunRur(cCodPro)

						If xIncen > 0 .AND. nPerInc > 0
							xIncen := ( ( (nPrTotal + aPrcLeite[nLinha][nCLPrBase] ) * nPerInc ) / 100 )
						End If

						If xFun > 0 .AND. nPerFun > 0
							xFun := ( ( (nPrTotal + aPrcLeite[nLinha][nCLPrBase] ) * nPerFun ) / 100 )
						End If

						aPrcLeite[nLinha][nCLIncen]     := Iif(nPerInc > 0,xIncen	,0)
						aPrcLeite[nLinha][nCLFunRur]    := Iif(nPerFun > 0,xFun	,0)
						aPrcLeite[nLinha][nCLPrFim]     := Round(nPrTotal + aPrcLeite[nLinha][nCLFrete] + aPrcLeite[nLinha][nCLIncen] + aPrcLeite[nLinha][nCLFunRur],3)
						aPrcLeite[nLinha][nColuna]      := .F.

						nTotal 		+= aPrcLeite[nLinha][nCLPrFim]
						cCodPro		:= (cAliasQry)->(PC1_CODPRO)
						nPrTotal 	:= nPrBase
						nColuna 	:= 14
						nLinha ++

                        aPrcLeite[nLinha][nCLCodPro] := (cAliasQry)->(PC1_CODPRO)
						aPrcLeite[nLinha][nCLNomPro] := (cAliasQry)->(LBB_NOMFOR)
						aPrcLeite[nLinha][nCLFamili] := (cAliasQry)->(ZXR_DESC)
                        aPrcLeite[nLinha][nCLLitAnt] := (cAliasQry)->(QTDLIT_A)
                        aPrcLeite[nLinha][nCLMdLtDA] := (cAliasQry)->(MEDLIT_A)
                        aPrcLeite[nLinha][nCLPrcAnt] := (cAliasQry)->(VLRLIT_A)
                        aPrcLeite[nLinha][nCLLitros] := (cAliasQry)->(PC1_QTDLIT)
                        aPrcLeite[nLinha][nCLMedDia] := (cAliasQry)->(MEDLIT)

                        aPrcLeite[nLinha][nCLPrBase] := nPrBase
						aPrcLeite[nLinha][nCLFrete]  := nFrete((cAliasQry)->(PC1_CODPRO))
						aPrcLeite[nLinha][nColuna]   := (cAliasQry)->(LJZ_RESLEI)
						nPrTotal += (cAliasQry)->(LJZ_RESLEI)
						nColuna ++
					EndIf

				(cAliasQry)->(dbskip())

				If (cAliasQry)->( Eof() )

						xIncen 	:= nIncen(cCodPro)
						xFun	:= nFunRur(cCodPro)

						If xIncen > 0 .AND. nPerInc > 0
							xIncen := ( ( (nPrTotal + aPrcLeite[nLinha][nCLPrBase] ) * nPerInc ) / 100 )
						End If

						If xFun > 0 .AND. nPerFun > 0
							xFun := ( ( (nPrTotal + aPrcLeite[nLinha][nCLPrBase] ) * nPerFun ) / 100 )
						End If

						aPrcLeite[nLinha][nCLIncen]     := Iif(nPerInc > 0,xIncen	,0)
						aPrcLeite[nLinha][nCLFunRur]    := Iif(nPerFun > 0,xFun	,0)
						aPrcLeite[nLinha][nCLPrFim]     := Round(nPrTotal + aPrcLeite[nLinha][nCLFrete] + aPrcLeite[nLinha][nCLIncen] + aPrcLeite[nLinha][nCLFunRur],3)
						aPrcLeite[nLinha][nColuna]      := .F.

						nTotal 		+= aPrcLeite[nLinha][nCLPrFim]

						nPrTotal 	:= nPrBase

				End If

			EndDo

			(cAliasQry)->(dbCloseArea())

		If Empty(aPrcLeite)

			aPrcLeite := Array(1,Len(aCabec)+1)
			For _c := 1 To Len(aCabec+1)
				aPrcLeite[1][_c] := Space(Len(aCabec[1][_c]))
			Next _c

		EndIf

	oPrcLeite:aCols := aPrcLeite
	nPrReal := Round(nTotal/Len(aPrcLeite),3)
	oPrReal:Refresh()
	oPrcLeite:Refresh()
	oPrcLeite:ForceRefresh()

Return

/*/{Protheus.doc} cHead()================================================================================================================================
Carrega descricao do cabecaho da grid
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static Function cHead()

	Local cRet 			:=  '"'
	Local aRet			:= {}
	Local cAl022C 	:=  GetNextAlias()
	Local cAl022C1 :=  GetNextAlias()
		Beginsql Alias cAl022C

				%NOPARSER%

				SELECT LJX_DESRED,LJX_EDITA,LJX_CODBON FROM %table:LJX% LJX WHERE LJX_FILIAL=%Exp:cFilAnt% AND LJX_PAGA='S' AND LJX.%notDel% ORDER BY LJX_ORDEM,LJX_EDITA DESC
		Endsql

		Beginsql Alias cAl022C1

				%NOPARSER%

				SELECT LJU_CODPRO,LJU_CODBON,LJU_PERIOD,LJU_VALOR,LJU_OBS FROM %table:LJU% LJU
				WHERE LJU_FILIAL=%Exp:cFilAnt% AND LJU.%notDel% AND LJU_PERIOD=%Exp:SUBSTR(dtoc(MV_PAR01),4,2)+SUBSTR(dtoc(MV_PAR01),7,4)%

		EndSql

		aRet := {}

		(cAl022C)->(dbGoTop())
		nHead := 1
		While (cAl022C)->( !Eof() )
			AADD(aRet,{AllTrim((cAl022C)->(LJX_DESRED)), AllTrim((cAl022C)->(LJX_EDITA)),AllTrim((cAl022C)->(LJX_CODBON))})
			(cAl022C)->( dbSkip() )
			nHead ++
		EndDo

		iF (cAl022C1)->( !Eof() )
			AADD(aRet,{"BONIF.FIXA", "N","999999"})
			nHead ++
		EndiF

Return aRet

/*/{Protheus.doc} xCabLJX()==============================================================================================================================
Carrega propriedades campos grid
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static function xCabLJX()

	Local aCampos	:= {}
	Local aCampos1 	:= {}

	AADD(aCampos,{"LBB_CODPRO","LBB_CODPRO"})
	AADD(aCampos,{"LBB_NOMFOR","LBB_NOMFOR"})
	AADD(aCampos,{"ZXR_DESC","ZXR_DESC"})

    AADD(aCampos,{"PC1_QTDLIT","PC1_QTDLITA"})
    AADD(aCampos,{"PC1_QTDLIT","PC1_MEDLITA"})
    AADD(aCampos,{"PC1_QTDLIT","PC1_PRBASEA"})

    AADD(aCampos,{"PC1_QTDLIT","PC1_QTDLIT"})
    AADD(aCampos,{"PC1_QTDLIT","PC1_MEDLIT"})
    AADD(aCampos,{"LJV_PRBASE","LJV_PRBASE"})
	AADD(aCampos,{"LJV_PRFIM","LJV_PRFIM"})
	AADD(aCampos,{"F1_XFRETE","F1_XFRETE"})
	AADD(aCampos,{"F1_XINCEN","F1_XINCEN"})
	AADD(aCampos,{"F1_XINSS","F1_XINSS"})

	// CAMPOS FIXOS
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))

	For nCampo:=1 To Len(aCampos)
		If DbSeek(PadR(aCampos[nCampo][1],10))

		    If AllTrim(aCampos[nCampo][2]) == "LBB_CODPRO"
		    	cTitulo := "CODPRO "
		    	nTam := 7
		    	nPict	:= "@E 999999"
		    ElseIf AllTrim(aCampos[nCampo][2]) == "LBB_NOMFOR"
		    	cTitulo := "PRODUTOR"
		    	nTam := 25
		    	nPict	:= "@E"
            ElseIf AllTrim(aCampos[nCampo][2]) == "ZXR_DESC"
		    	cTitulo := "FAMILIA"
		    	nTam := 15
		    	nPict	:= "@E"
            ElseIf AllTrim(aCampos[nCampo][2]) == "PC1_QTDLITA"
		    	cTitulo := "Vol.ANT"
		    	nTam := 6
		    	nPict	:= "@E 999999"
            ElseIf AllTrim(aCampos[nCampo][2]) == "PC1_MEDLITA"
		    	cTitulo := "Md.ANT"
		    	nTam := 6
		    	nPict	:= "@E 999999"
            ElseIf AllTrim(aCampos[nCampo][2]) == "PC1_PRBASEA"
		    	cTitulo := "$ ANT"
		    	nTam := 6
		    	nPict	:= "@E 9.999"
            ElseIf AllTrim(aCampos[nCampo][2]) == "PC1_QTDLIT"
		    	cTitulo := "Vol.ATU"
		    	nTam := 6
		    	nPict	:= "@E 999999"
            ElseIf AllTrim(aCampos[nCampo][2]) == "PC1_MEDLIT"
		    	cTitulo := "Md. ATU"
		    	nTam := 6
		    	nPict	:= "@E 999999"
		    ElseIf AllTrim(aCampos[nCampo][2]) == "LJV_PRBASE"
		    	cTitulo := " $ BASE"
		    	nTam := 6
		    	nPict	:= "@E 9.999"
		   ElseIf AllTrim(aCampos[nCampo][2]) == "LJV_PRFIM"
		    	cTitulo := " $ ATU"
		    	nTam := 6
		    	nPict	:= "@E 999.999"
		   ElseIf AllTrim(aCampos[nCampo][2]) == "F1_XFRETE"
		    	cTitulo := "FRETE"
		    	nTam := 6
		    	nPict	:= "@E 9.999"
		   ElseIf AllTrim(aCampos[nCampo][2]) == "F1_XINCEN"
		    	cTitulo := "INCENT."
		    	nTam := 6
		    	nPict	:= "@E 9.999"
		   ElseIf AllTrim(aCampos[nCampo][2]) == "F1_XINSS"
		    	cTitulo := "FUNRUR"
		    	nTam := 6
		    	nPict	:= "@E 9.999"
		    Else
		   	 	cTitulo := SX3->X3_TITULO
		    	nTam 	:= SX3->X3_TAMANHO
		    	nPict	:= SX3->X3_PICTURE
		    EndIf
		    Aadd(aCabec, {cTitulo,;
						      SX3->X3_CAMPO,;
						      nPict,;
						      nTam,;
						      SX3->X3_DECIMAL,;
						      SX3->X3_VALID,;
						      SX3->X3_USADO,;
						      SX3->X3_TIPO,;
						      SX3->X3_F3,;
						      SX3->X3_CONTEXT,})

		Endif
	Next

	aCpo    := cHead()
	cRet    := '"'
	aCpoGDa := {}

	For _a := 1 To Len(aCpo)
		If aCpo[_a][2] == "S"
			AADD(aCpoGDa,"LJZ_"+SubStr(aCpo[_a][3],1,6))
		EndIf
	Next _a
	aAlter := aClone(aCpoGDa)

	//CAMPOS VARIAVEIS
	AADD(aCampos1,"LJZ_RESLEI")

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For a := 1 to len(aCpo)
		For nCampo:=1 To Len(aCampos1)
			If DbSeek(PadR(aCampos1[nCampo],10))

				    Aadd(aCabec, {Alltrim(aCpo[a][1]),;
							      "LJZ_"+SubStr(aCpo[a][3],1,6),;
							      SX3->X3_PICTURE,;
							      SX3->X3_TAMANHO,;
							      SX3->X3_DECIMAL,;
							      "U_RetCampo()",;
							      SX3->X3_USADO,;
							      SX3->X3_TIPO,;
							      SX3->X3_F3,;
							      SX3->X3_CONTEXT})
			Endif
		Next
	Next a

return aCabec

/*/{Protheus.doc} AtuLJZ()===============================================================================================================================
Sem utilidade
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
User Function AtuLJZ()

	//nPrReal := Round(nTotal/Len(aCols),2)
	//oPrReal:Refresh()
	//oPrcLeite:Refresh()

Return .T.

/*/{Protheus.doc} RetCampo()=============================================================================================================================
Carrega conteudo dos campos na grid
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
User Function RetCampo()

	//aCpo[1] == DESCRICAO
	//aCpo[2] == EDITAVEL?
	//aCpo[3] == COD.BONIFICACAO
    Local nPrcCal   := 0
	Local nPrAtu    := aCols[n,nCLPrFim]
    Local nPrGrv    := 0
    nTotal := 0
	aCols[n,nCLPrFim] := nPrBase

	LJZ->(dbSetOrder(5))
	//LJZ_FILIAL+DTOS(LJZ_DATCLQ)+LJZ_CODPRO+LJZ_CODBON

	For b := 11 To Len(aHead)

		If "M->"+AllTrim(aHead[b][2]) == AllTrim(ReadVar())
            nPrcCal := &(ReadVar())
            If nPrcCal == 0
                aCols[n,nCLPrFim] := (aCols[n,nCLPrFim]-aCols[n,b])
                nPrGrv := 0
                aCols[n,b] := nPrGrv
            Else
                aCols[n,nCLPrFim] += (nPrcCal - nPrAtu)
                nPrGrv := (nPrcCal - nPrAtu)
                aCols[n,b] := nPrGrv
            EndIf
        Else
            aCols[n,nCLPrFim] += iif("M->"+AllTrim(aHead[b][2]) == AllTrim(ReadVar()),&(ReadVar()),aCols[n,b])
        End If

        For _aAlter := 1 To Len(aAlter)
			If ( AllTrim(ReadVar()) == "M->"+AllTrim(aAlter[_aAlter]) ) .AND. ( AllTrim(ReadVar()) == "M->"+AllTrim(aHead[b][2]) )
				//msgalert(AllTrim(ReadVar()))
				//msgalert("M->"+AllTrim(aAlter[_aAlter]))
				If LJZ->(dbSeek(xFilial("LJZ")+DTOS(MV_PAR01)+AllTrim(aCols[n,1])+SubStr(aHead[b][2],5,6)))
					LJZ->( RecLock("LJZ",.F.) )
						///LJZ->LJZ_RESLEI := &(ReadVar())
                        LJZ->LJZ_RESLEI := nPrGrv
					LJZ->( MsUnlock() )
				End If
			EndIf
		Next _aAlter

	Next b

	oPrcLeite:Refresh()

	For x := 1 To Len(aCols)
		nTotal += aCols[x][nCLPrFim]
	Next x

	nPrReal := Round(nTotal/Len(aCols),3)
	oPrReal:Refresh()
	oPrcLeite:Refresh()

Return .T.

/*/{Protheus.doc} nFrete()===============================================================================================================================
Carrega custo do frete do produtor na grid
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/

Static Function nFrete(cCodPro)

	Local nRet 		:= 0
	Local cAliasPA4 := 'PA4QRY'
	Local cAliasPA3 := 'PA3QRY'
	Local aRet1		:= {}

			BeginSql Alias cAliasPA4

				%noparser%

				SELECT ISNULL(SUM(PA4_QTDLIT),0) AS PA4_QTDLIT,PA4_CODCAM
				FROM %table:PA4% PA4
				WHERE PA4_PERIOD=%Exp:SubStr(DTOC(MV_PAR01),4,2)+SubStr(DTOC(MV_PAR01),7,4)%
				AND PA4_CODPRO=%Exp:cCodPro% AND PA4.%notDel%
				GROUP BY PA4_CODCAM

			EndSql

			aRet := GetLastQuery()

			If (cAliasPA4)->( !Eof() )

				BeginSql Alias cAliasPA3

					%noparser%

					SELECT PA3_VRTOT,PA3_QTDLIT FROM %table:PA3% PA3 WHERE
					PA3_PERIOD=%Exp:SubStr(DTOC(MV_PAR01),4,2)+SubStr(DTOC(MV_PAR01),7,4)%
					AND PA3_CODCAM=%Exp:(cAliasPA4)->(PA4_CODCAM)% AND PA3.%notDel%

				EndSql

				aRet1 := GetLastQuery()

			    If (cAliasPA4)->(PA4_QTDLIT) > 0
			    	nRet := ( (cAliasPA3)->(PA3_VRTOT)/(cAliasPA3)->(PA3_QTDLIT) )
			    End If

		    (cAliasPA3)->( dbCloseArea())

			End IF

		    (cAliasPA4)->( dbCloseArea())

		    //If cCodPro == '470027'
		    //MemoWrite("C:\HD\QUERYS\QUA22A.SQL",aRet[2])
		    //MemoWrite("C:\HD\QUERYS\QUA22B.SQL",aRet1[2])
		    //MsgAlert(cValToCHar(nRet))
		    //EndiF

Return nRet

/*/{Protheus.doc} nIncen()===============================================================================================================================
Carrega custo do incentivo fiscal produtor rural na grid
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/

Static Function nIncen(cCodPro)

	Local cCdLjFor 	:= Posicione("LBB",1,xFilial("LBB")+cCodPro,"LBB_CODFOR+LBB_LOJA")
	Local nRet		:= 0

	If (ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+cCdLjFor,"A2_INCLTMG")) == "1" ;
	 .AND. ( ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+cCdLjFor,"A2_EST"))) = "MG" ) .OR. cFilAnt =='09'
		If cFilAnt <> '09'
		nRet := POSICIONE("SB1",1,xFilial("SB1")+'200113',"B1_PRINCMG")
		Else
		nRet := 12.28
		End IF
	Endif

Return nRet

/*/{Protheus.doc} nFunRur()==============================================================================================================================
Carreador custos Funrural produtor rurar na grid
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static Function nFunRur(cCodPro)

	Local _cNATUREZA 	:= ''
	Local _nPERCINS		:= 0
	Local nRet			:= 0

	LBB->(dbSetOrder(1))
	If LBB->(dbSeek(xFilial("LBB")+cCodPro))
		If Alltrim(Upper(LBB->(LBB_FUNRUR))) == "S"
			_cNATUREZA := Posicione("SA2", 1, xFilial("SA2") + LBB->(LBB_CODFOR)+LBB->(LBB_LOJA), "A2_NATUREZ")

			If !Empty(_cNATUREZA)
	        	_nPERCINS  := Posicione("SED", 1, xFilial("SED") + _cNATUREZA, "ED_PERCINS")
	  		Else
	  			_nPERCINS := GetMV("MV_FUNRURA",,2.3)
	  		Endif
			nRet := _nPERCINS
		Endif
	EndIf

Return nRet

