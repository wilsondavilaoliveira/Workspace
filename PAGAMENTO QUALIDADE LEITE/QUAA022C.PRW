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
    Private oProdutor
    Private oPrAnt
    Private oFam
    Private cFam        := Space(3)
    Private cProdutor   := Space(50)
    Private cCpoSel     := Space(150)
    Private nPrAnt      := 0
    Private nColClas    := 0
    Private lExec       := .F.
    Private xCodPro     := space(6)
    Private dTFechto    := ''
    Private nCLCodPro   := 1    //CODIGO PRODUTOR
    Private nCLNomPro   := 2    //NOME PRODUTOR
    Private nCLTpFam    := 3    //NOME PRODUTOR

    Private nCLFamili   := 4    //FAMILIA PRODUTOR
    Private nCLPrCust   := 5   //PRECO CUSTO MES ATUAL

    Private nCLPrBase   := 6    //PRECO BASE MES ATUAL
    Private nCLFrete    := 7   //FRETE MES ATUAL
    Private nCLIncen    := 8   //INCENTIVO FISCAL MES ATUAL
    Private nCLFunRur   := 9   //FUN.RURAL MES ATUAL

    Private nCLLitAnt   := 10    //LITROS TOTAL MES ANTERIOR
    Private nCLLitros   := 11    //LITROS TOTAL MES ATUAL

    Private nCLMdLtDA   := 12    //MEDIA LITROS DIA MES ANTERIOR
    Private nCLMedDia   := 13    //MEDIA LITROS DIA MES ATUAL

    Private nCLPrcAnt   := 14   //PRECO MES ANTERIOR
    Private nCLPrFim    := 15   //PRECO FINAL MEA ATUAL
    Private nCLPrDif    := 16   //DIFENCA PRECO ANTERIOR PARA PRECO ATUAL

    Private nColuna     := 17   //COLUNA INICIA BONIFICACOES VARIAVEIS
    Private nColOri     := 17   //COLUNA INICIA BONIFICACOES VARIAVEIS

    If !Pergunte("QUAA22C",.T.)
		Return
	End If

    dTFechto := MV_PAR01

    //Processa({||RclBnToT()},"Aguarde...","Carregando. . . ",.F.)
    //Return


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

	//Painel 1
	oPanped	:=TPanel():New(1,3,,oC1W1,oFont2,,,/*CLR_BLUE*/,/*CLR_BLUE*/,80,15,.f.,.f.) //200,07
	oPanped :ALIGN:= CONTROL_ALIGN_TOP

    nPrMdFl := Posicione("LJV",1,XFILIAL("LJV")+DTOS(MV_PAR01),"LJV_PRFIX")
	nPrBase := Posicione("LJV",1,XFILIAL("LJV")+DTOS(MV_PAR01),"LJV_PRBASE")
	nPerInc	:= Posicione("LJV",1,XFILIAL("LJV")+DTOS(MV_PAR01),"LJV_INCENT")
	nPerFun	:= Posicione("LJV",1,XFILIAL("LJV")+DTOS(MV_PAR01),"LJV_FUNRUR")

    @004.3	,003+000 SAY "DATA FECHT.:"	        SIZE 080,10 OF oPanped 	PIXEL FONT oFont2 COLOR CLR_RED
    @2.0	,072+000 MSGET oDtFech VAR MV_PAR01	SIZE 060,10 OF oPanped 	PIXEL FONT oFont2 When .F.  PICTURE "@ 99/99/9999"

    @004.3	,005+130 SAY "% INCENTIVO:"	        SIZE 080,10 OF oPanped 	PIXEL FONT oFont2 COLOR CLR_RED
	@2.0	,075+130 MSGET oPerInc VAR nPerInc	SIZE 040,10 OF oPanped 	PIXEL FONT oFont2 When .F.  PICTURE "@E 99.99%"

	@004.3	,130+130 SAY "% FUN.RURAL:"	        SIZE 080,10 OF oPanped 	PIXEL FONT oFont2 COLOR CLR_RED
	@2.0	,203+130 MSGET oPerRur 	VAR nPerFun	SIZE 040,10 OF oPanped 	PIXEL FONT oFont2 WHEN .F. PICTURE "@E 99.99%"

	@004.3	,260+130 SAY "$ MEDIO META:"	    SIZE 080,10 OF oPanped 	PIXEL FONT oFont2 COLOR CLR_BLUE
	@2.0	,335+130 MSGET oPrMedFL VAR nPrMdFl	SIZE 060,10 OF oPanped 	PIXEL FONT oFont2 When .F.  PICTURE "@E 99.999"

	@004.3	,404+125 SAY "$ MEDIO REAL:"	    SIZE 080,10 OF oPanped 	PIXEL FONT oFont2 COLOR CLR_GREEN
	@2.0	,480+125 MSGET oPrReal 	VAR nPrReal	SIZE 060,10 OF oPanped 	PIXEL FONT oFont2 WHEN .F. PICTURE "@E 99.999"

     //Painel dos Botoes para Manutencoes
	oPanBotoes:=TPanel():New(1,3,,oC1W1,/*[aoFont]*/,,,/*CorTexto*/,/*CLR_GREEN*/,090,15,.T.,.T.)
	oPanBotoes:ALIGN:= CONTROL_ALIGN_TOP

    //TECLAS DE ATALHO
    bKeyF3 := SetKey( VK_F3 , Nil )
    SetKey( VK_F3 , { || xBusca() } )

    //BOTOES//////////////////
	oButt1:= FWButtonBar():new()
	oButt1:Init(oPanBotoes, 17, 25,CONTROL_ALIGN_TOP, .T. )

    oButt1:addBtnImage( "Final"     ,"Sair"              ,{|| Processa({||ProcPreco()},"Atualizando Preco...","Atualizando Preco. . . ",.F.),oDlg1:End()}                                                              ,,.T.,CONTROL_ALIGN_LEFT)
    oButt1:addBtnImage( "Reload"    ,"Processa Adicional",{|| Processa({||GetAdcVol(oPrcLeite)},"Aguarde...","Carregando. . . ",.F.)}   ,,.T.,CONTROL_ALIGN_LEFT)
    oButt1:addBtnImage( "OBJETIVO"  ,"Zera Adc Mercado"  ,{|| Processa({||ZeraAdc(oPrcLeite,.T.)},"Aguarde...","Carregando. . . ",.F.)} ,,.T.,CONTROL_ALIGN_LEFT)
    oButt1:addBtnImage( "LINE"      ,"Planilha"          ,{|| ReportExcel(oPrcLeite)}                                                   ,,.T.,CONTROL_ALIGN_LEFT)
    oButt1:addBtnImage( "BMPCONS"   ,"Busca"             ,{|| xBusca()}                                                   ,,.T.,CONTROL_ALIGN_LEFT)

    oButt1:addBtnImage( "AUTOM"   ,"Processa todos os meses"             ,{|| Processa({||RclBnToT()},"Aguarde...","Carregando. . . ",.F.)}                                                   ,,.T.,CONTROL_ALIGN_LEFT)



    /////////////////////////

    aHead := xCabLJX()
	aSize := MsAdvSize()
	aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	aPrcLeite := {}
	oPrcLeite := MsNewGetDados():New(025,;                //nTop      - Linha Inicial
	                                001,;                //nLeft     - Coluna Inicial
	                                300,;     			 //nBottom   - Linha Final
	                                650,;     			 //nRight    - Coluna Final
	                                GD_UPDATE,;			 //nStyle    - Estilos para edição da Grid (GD_INSERT = Inclusão de Linha; GD_UPDATE = Alteração de Linhas; GD_DELETE = Exclusão de Linhas)
	                                "AllwaysTrue",;    	 //cLinhaOk  - Validação da linha
	                                "AllwaysTrue",;      //cTudoOk   - Validação de todas as linhas
	                                "AllwaysTrue",;      //cIniCpos  - Função para inicialização de campos
	                                aAlter,;  			 //aAlter    - Colunas que podem ser alteradas
	                                ,;                   //nFreeze   - Número da coluna que será congelada
	                                9999,;               //nMax      - Máximo de Linhas
	                                "U_QA22Col(oPrcleite)",;      //cFieldOK  - Validação da coluna
	                                ,;                   //cSuperDel - Validação ao apertar '+'
	                                ,;                   //cDelOk    - Validação na exclusão da linha
	                                oC1W1,;            	 //oWnd      - Janela que é a dona da grid
	                                aHead,;           	 //aHeader   - Cabeçalho da Grid
	                                aPrcLeite,{||U_QA22Linha(oPrcleite)})

	oPrcLeite:SetEditLine (.T.)

    oPrcLeite:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

    oPrcLeite:oBrowse:bHeaderClick := {|oBrw1,nCol|  Ordena(nCol)}

    oPrcLeite:oBrowse:lUseDefaultColors := .F.

    oPrcLeite:oBrowse:SetBlkBackColor(  {|| CorFundo(oPrcLeite:nAt,8421376)})

    oPrcLeite:oBrowse:SetBlkColor(      {|| CorFonte(oPrcLeite:nAt,8421376)})

    AjuLitCar()

    //Processa({||LoadOrdem(oPrcLeite,.T.,cHead)},"Aguarde...","Carregando. . . ",.F.)
    LoadOrdem(oPrcLeite,.T.,cHead)

    ACTIVATE MSDIALOG oDlg1

Return
/*/{Protheus.doc} Ordena
Ordena aCols
@type function
@version
@author Wilson Davila
@since 14/07/2020
/*/
Static Function Ordena(nCol)

     If !lExec

         If nCol <> nColClas

            If ( nCol == nCLFamili ) .or. ( nCol == nCLTpFam )
                oPrcLeite:aCols := aSort( oPrcLeite:aCols,,,{|x,y| x[nCLFamili]+x[nCLTpFam] < y[nCLFamili]+y[nCLTpFam]  } )
            Else
                oPrcLeite:aCols := aSort( oPrcLeite:aCols,,,{|x,y| x[nCol] < y[nCol]})
            EndIf

            nColClas := nCol
        Else

            If ( nCol == nCLFamili ) .or. ( nCol == nCLTpFam )
                oPrcLeite:aCols := aSort( oPrcLeite:aCols,,,{|x,y| x[nCLFamili]+x[nCLTpFam] > y[nCLFamili]+y[nCLTpFam]  } )
            Else
                oPrcLeite:aCols := aSort( oPrcLeite:aCols,,,{|x,y| x[nCol] > y[nCol]})
            EndIf

            nColClas := 0
        End If

        oPrcLeite:GoTop()

        oPrcLeite:Refresh()

        lExec := .T.
    Else
        lExec := .F.
    EndIf

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

		aRet := {}

		(cAl022C)->(dbGoTop())
		nHead := 1
		While (cAl022C)->( !Eof() )
			AADD(aRet,{AllTrim((cAl022C)->(LJX_DESRED)), AllTrim((cAl022C)->(LJX_EDITA)),AllTrim((cAl022C)->(LJX_CODBON))})
			(cAl022C)->( dbSkip() )
			nHead ++
		EndDo

		AADD(aRet,{"BONIF.FIXA", "N","999999"})
		nHead ++

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

    AADD(aCampos,{"ZXR_DESC","ZXR_FAM"})
    AADD(aCampos,{"ZXR_DESC","ZXR_DESC"})

    AADD(aCampos,{"PC1_QTDMED","PC1_PRCUST"})
    AADD(aCampos,{"LJV_PRBASE","LJV_PRBASE"})
    AADD(aCampos,{"F1_XFRETE","F1_XFRETE"})
	AADD(aCampos,{"F1_XINCEN","F1_XINCEN"})
	AADD(aCampos,{"F1_XINSS","F1_XINSS"})

    AADD(aCampos,{"PC1_QTDMED","PC1_QTDLITA"})
    AADD(aCampos,{"PC1_QTDLIT","PC1_QTDLIT"})

    AADD(aCampos,{"PC1_QTDMED","PC1_MEDLITA"})
    AADD(aCampos,{"PC1_QTDMED","PC1_MEDLIT"})

    AADD(aCampos,{"PC1_QTDMED","PC1_PRBASEA"})
    AADD(aCampos,{"LJV_PRFIM","LJV_PRFIM"})
    AADD(aCampos,{"PC1_QTDMED","PC1_PRDIF"})


	// CAMPOS FIXOS
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))

	For nCampo:=1 To Len(aCampos)
		cCalculo := 'N'
        nDecimal := 0
        If DbSeek(PadR(aCampos[nCampo][1],10))

		    If AllTrim(aCampos[nCampo][2]) == "LBB_CODPRO"
		    	cTitulo := "CODPRO "
		    	nTam := 7
		    	nPict	:= "@E 999999"
                cCalculo := 'N'
                nDecimal := 0
            ElseIf AllTrim(aCampos[nCampo][2]) == "LBB_NOMFOR"
		    	cTitulo := "PRODUTOR"
		    	nTam := 10
		    	nPict	:= "@E"
                cCalculo := 'N'
                nDecimal := 0
            ElseIf AllTrim(aCampos[nCampo][2]) == "ZXR_DESC"
		    	cTitulo := "FAMILIA"
		    	nTam := 10
		    	nPict	:= "@E"
                cCalculo := 'N'
                nDecimal := 0
            ElseIf AllTrim(aCampos[nCampo][2]) == "ZXR_FAM"
		    	cTitulo := "TP"
		    	nTam := 2
		    	nPict	:= "@E"
                cCalculo := 'N'
                nDecimal := 0
            ElseIf AllTrim(aCampos[nCampo][2]) == "PC1_QTDLITA"
		    	cTitulo := "Vol.ANT"
		    	nTam := 6
		    	nPict	:= "@E 999999"
                cCalculo := 'N'
                nDecimal := 0
            ElseIf AllTrim(aCampos[nCampo][2]) == "PC1_MEDLITA"
		    	cTitulo := "Md.ANT"
		    	nTam := 6
		    	nPict	:= "@E 999999"
                cCalculo := 'N'
                nDecimal := 0
            ElseIf AllTrim(aCampos[nCampo][2]) == "PC1_PRCUST"
		    	cTitulo := "$ CUS"
		    	nTam := 6
		    	nPict	:= "@E 9.999"
                cCalculo := 'N'
                nDecimal := 6
            ElseIf AllTrim(aCampos[nCampo][2]) == "PC1_PRBASEA"
		    	cTitulo := "$ ANT"
		    	nTam := 6
		    	nPict	:= "@E 9.999"
                cCalculo := 'N'
                nDecimal := 6
            ElseIf AllTrim(aCampos[nCampo][2]) == "PC1_QTDLIT"
		    	cTitulo := "Vol.ATU"
		    	nTam := 6
		    	nPict	:= "@E 999999"
                cCalculo := 'N'
                nDecimal := 0
            ElseIf AllTrim(aCampos[nCampo][2]) == "PC1_MEDLIT"
		    	cTitulo := "Md.ATU"
		    	nTam := 6
		    	nPict	:= "@E 999999"
                cCalculo := 'N'
                nDecimal := 0
		    ElseIf AllTrim(aCampos[nCampo][2]) == "LJV_PRBASE"
		    	cTitulo := "BASE"
		    	nTam := 6
		    	nPict	:= "@E 9.999"
                cCalculo := 'S'
                nDecimal := 6
		   ElseIf AllTrim(aCampos[nCampo][2]) == "LJV_PRFIM"
		    	cTitulo := "$ ATU"
		    	nTam := 6
		    	nPict	:= "@E 9.999"
                cCalculo := 'N'
                nDecimal := 6
            ElseIf AllTrim(aCampos[nCampo][2]) == "PC1_PRDIF"
		    	cTitulo := "$ DIF"
		    	nTam := 6
		    	nPict	:= "@E 99.999"
                cCalculo := 'N'
                nDecimal := 6
           ElseIf AllTrim(aCampos[nCampo][2]) == "F1_XFRETE"
		    	cTitulo := "FRETE"
		    	nTam := 6
		    	nPict	:= "@E 9.9999"
                cCalculo := 'N'
                nDecimal := 6
		   ElseIf AllTrim(aCampos[nCampo][2]) == "F1_XINCEN"
		    	cTitulo := "INCENT."
		    	nTam := 6
		    	nPict	:= "@E 99.9999"
                cCalculo := 'N'
                nDecimal := 6
		   ElseIf AllTrim(aCampos[nCampo][2]) == "F1_XINSS"
		    	cTitulo := "FUNRUR"
		    	nTam := 6
		    	nPict	:= "@E 99.9999"
                cCalculo := 'N'
                nDecimal := 6
		    Else
		   	 	cTitulo := SX3->X3_TITULO
		    	nTam 	:= SX3->X3_TAMANHO
		    	nPict	:= SX3->X3_PICTURE
                cCalculo := 'N'
                nDecimal := 0
		    EndIf
		    Aadd(aCabec, {cTitulo,;
						      SX3->X3_CAMPO,;
						      nPict,;
						      nTam,;
						      nDecimal,;
						      SX3->X3_VALID,;
						      SX3->X3_USADO,;
						      SX3->X3_TIPO,;
						      SX3->X3_F3,;
						      SX3->X3_CONTEXT,,,,cCalculo})

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
    cCalculo := 'S'
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For a := 1 to len(aCpo)
		For nCampo:=1 To Len(aCampos1)
			If DbSeek(PadR(aCampos1[nCampo],10))

				    Aadd(aCabec, {Alltrim(aCpo[a][1]),;
							      "LJZ_"+SubStr(aCpo[a][3],1,6),;
							      "@E 999.9999",;//SX3->X3_PICTURE
							      SX3->X3_TAMANHO,;
							      SX3->X3_DECIMAL,;
							      "U_RetCampo()",;
							      SX3->X3_USADO,;
							      SX3->X3_TIPO,;
							      SX3->X3_F3,;
							      SX3->X3_CONTEXT,,,,cCalculo})
			Endif
		Next
	Next a

return aCabec


/*/{Protheus.doc} ()=============================================================================================================================
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
    Local nIncen    := 0
    Local nFunRur   := 0
    Local nTotCal   := 0
    Local nColAtu   := 0
    Local nColInc   := 0
    Local nColFun   := 0
    Local nBonFix   := 0
    Local xPrfim    := aCols[n,nCLPrFim]
    Local xAdcMer   := aCols[n,nColOri]


    If ( &(ReadVar()) == aCols[n,nColOri] ) .OR. ( &(ReadVar()) == aCols[n,nCLPrFim] )
        aCols[n,nColOri] := xAdcMer
        Return .F.
    EndIf

    nTotal := 0
	aCols[n,nCLPrFim] := nPrBase

    LJZ->(dbSetOrder(5))
	//LJZ_FILIAL+DTOS(LJZ_DATCLQ)+LJZ_CODPRO+LJZ_CODBON
    nValAnt := 0
	For b := 1 To Len(aHead)

		If      AllTrim(aHead[b][2]) == "F1_XINCEN"
                nColInc := b
        ElseIf  AllTrim(aHead[b][2]) == "F1_XINSS"
                nColFun := b
        EndIf



        If "M->"+AllTrim(aHead[b][2]) == AllTrim(ReadVar())
            nValAnt := aCols[n,b]
            nPrcCal := &(ReadVar())
            nColAtu := b
            If nPrcCal == 0
                aCols[n,b] := 0
            EndIf
        Else
            If aHead[b][14] == 'S'
                nTotCal += iif("M->"+AllTrim(aHead[b][2]) == AllTrim(ReadVar()),&(ReadVar()),aCols[n,b])
                If AllTrim(aHead[b][2]) == "LJZ_999999"
                    nBonFix += aCols[n,b]
                EndIf
            EndIf
        End If

	Next b

    If nPrcCal>0
        nFunRur	          := Round( ( ( (nPrcCal) * nFunRur( aCols[n][1]) ) / 100 ),6 )
        aCols[n][nColFun] := nFunRur := -(Round( ( ( (nFunRur) * nFunRur( aCols[n][1]) ) / 100 ),6 ) + nFunRur)
        aCols[n][nColInc] := ( ( (nPrcCal-nFunRur) * nIncen(aCols[n][1]) ) / 100 )
        aCols[n][nColInc] := nIncen := aCols[n][nColInc] - ( ( aCols[n][nColInc]  *  nIncen(aCols[n][1]) ) / 100  )
    Else
        nFunRur	          := Round( ( ( (nTotCal) * nFunRur( aCols[n][1]) ) / 100 ),6 )
        aCols[n][nColFun] := nFunRur := -(Round( ( ( (nFunRur) * nFunRur( aCols[n][1]) ) / 100 ),6 ) + nFunRur)
        aCols[n][nColInc] := ( ( (nTotCal-nFunRur) * nIncen(aCols[n][1]) ) / 100 )
        aCols[n][nColInc] := nIncen := aCols[n][nColInc] - ( ( aCols[n][nColInc]  *  nIncen(aCols[n][1]) ) / 100  )
    EndIf

    If nPrcCal > 0
        aCols[n,nColAtu]    := (nPrcCal) - ((nTotCal ))
    Else
        aCols[n,nColAtu]    := 0
    EndIf

    //aCols[n,nCLPrCust]  := Round((aCols[n,nColAtu]+nTotCal + nIncen + nFunRur + aCols[n,nCLFrete]),6)
    //aCols[n,nCLPrFim]   := Round((aCols[n,nColAtu]+nTotCal + nIncen + nFunRur),3)
    aCols[n,nCLPrCust]  := Round(( ( (aCols[n,nColAtu]+nTotCal) - nFunRur) + aCols[n,nCLFrete]),6)
    aCols[n,nCLPrFim]   := Round((aCols[n,nColAtu]+nTotCal ),3)


    aCols[n,nCLPrDif]   := aCols[n,nCLPrFim] - aCols[n,nCLPrcAnt]

    For _aAlter := 1 To Len(aAlter)
		If ( AllTrim(ReadVar()) == "M->"+AllTrim(aAlter[_aAlter]) )
        	If LJZ->(dbSeek(xFilial("LJZ")+DTOS(MV_PAR01)+AllTrim(aCols[n,1])+SubStr(AllTrim(ReadVar()),8,6)))
				LJZ->( RecLock("LJZ",.F.) )
                    LJZ->LJZ_RESLEI := aCols[n,nColAtu]
                    LJZ->LJZ_RECALC := IIF(aCols[n,nColAtu]==0,'','S')
                LJZ->( MsUnlock() )
			End If
		EndIf
	Next _aAlter

    If aCols[n,nCLTpFam] == 'PA'
        cFam := SubStr(Alltrim(aCols[n,nCLFamili]),1,6)
        For _Fam := 1 to Len(aCols)
            If cFam == SubStr(Alltrim(aCols[_Fam,nCLFamili]),1,6) .AND. _Fam<>n
                 RetFam(oPrcLeite,_Fam,AllTrim(ReadVar()),(nPrcCal-nBonFix))
            EndIf
        Next _Fam
    EndIf

    nLitros := 0
    nTotal  := 0

    For _acl := 1 To Len(oPrcLeite:aCols)
        nLitros += oPrcLeite:aCols[_acl][nCLLitros]
        nTotal += oPrcLeite:aCols[_acl][nCLLitros] * oPrcLeite:aCols[_acl][nCLPrCust]
    Next _acl

    nTotal := nTotal/nLitros

    nPrReal := Round(nTotal,3)

    oPrReal:Refresh()
    oPrcLeite:Refresh()

Return .T.

/*/{Protheus.doc} LoadOrdem()============================================================================================================================
Carrega Grid
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static Function LoadOrdem (oPrcLeite,lAjusta)

	Local cQuery		:= ''
	Local nArray		:= 1
	Local nPrTotal		:= nPrBase
	Local cAliasQry		:= "QUAA22C"
	Local xIncen		:= 0
	Local xFun			:= 0
	Local cNomPro		:= ''
    Local cMes          := ''
    Local cAno          := ''
	Local dData         := MV_PAR01
    Local nAdcMer       := 0

    Processa({||RecalBon()},"Aguarde...","Recalculando Bonif. . . ",.F.)

    //MsAguarde({|| RecalBon()},"Recalculando Bonif. . . ")

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

				SELECT DISTINCT PC1_CODPRO,PC1_LINHA,LBB_DESC,LBB_NOMFOR,LJX_EDITA,

                ISNULL((SELECT '_F' FROM %table:ZXR% ZXR WHERE ZXR_CODFAM=LBB_CODFAM AND ZXR_FILIAL=LBB_FILIAL AND ZXR.%notDel%),
                ISNULL((SELECT 'PA' FROM %table:ZXR% ZXR WHERE ZXR_CODPAI=LBB_CODPRO AND ZXR_FILIAL=LBB_FILIAL AND ZXR.%notDel%),'SF')) AS ZXR_FAM,

                ISNULL((SELECT ZXR_CODFAM+'-'+ZXR_DESC FROM %table:ZXR% ZXR WHERE ZXR_CODFAM=LBB_CODFAM AND ZXR_FILIAL=LBB_FILIAL AND ZXR.%notDel%),
                ISNULL((SELECT ZXR_CODFAM+'-'+ZXR_DESC FROM %table:ZXR% ZXR WHERE ZXR_CODPAI=LBB_CODPRO AND ZXR_FILIAL=LBB_FILIAL AND ZXR.%notDel%),'999999-SEM FAMILIA')) AS ZXR_DESC,

                ROUND(SUM(PC1_QTDLIT),0) AS PC1_QTDLIT,
				ROUND(AVG(PC1_VLRLIT),3) AS PC1_VLRLIT,ROUND(ROUND(SUM(PC1_QTDLIT),0)/30,0) AS MEDLIT,
                LJX_CODBON,LJX_DESC,LJX_ORDEM,ISNULL(ROUND(AVG(LJZ_RESLEI),6),0) AS LJZ_RESLEI,

                (SELECT ROUND(SUM(PC1_QTDLIT),0)
                 FROM %table:PC0% PC0
                 INNER JOIN %table:PC1% PC1 ON PC1_CODPRO=LBB_CODPRO AND PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
                 WHERE PC0_FILIAL=%EXP:cFilAnt% AND PC0_TPENTR='1' AND MONTH(PC0_DTENTR)=%Exp:cMes% AND YEAR(PC0_DTENTR)=%Exp:cAno% AND PC0.%notDel%) AS QTDLIT_A,
                 (SELECT ROUND(AVG(PC1_VLRLIT),3) AS VLRLITA
                 FROM %table:PC0% PC0
                 INNER JOIN %table:PC1% PC1 ON PC1_CODPRO=LBB_CODPRO AND PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
                 WHERE PC0_FILIAL=%EXP:cFilAnt% AND PC0_TPENTR='1' AND MONTH(PC0_DTENTR)=%Exp:cMes% AND YEAR(PC0_DTENTR)=%Exp:cAno% AND PC0.%notDel%) AS VLRLIT_A,
                 ROUND(((SELECT ROUND(SUM(PC1_QTDLIT),0)
                 FROM %table:PC0% PC0
                 INNER JOIN %table:PC1% PC1 ON PC1_CODPRO=LBB_CODPRO AND PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
                 WHERE PC0_FILIAL=%EXP:cFilAnt% AND PC0_TPENTR='1' AND MONTH(PC0_DTENTR)=%Exp:cMes% AND YEAR(PC0_DTENTR)=%Exp:cAno% AND PC0.%notDel%)/
                 (30)),0) AS MEDLIT_A

				FROM %table:PC0% PC0
				INNER JOIN %table:PC1% PC1 ON PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
				INNER JOIN %table:LBB% LBB ON LBB_FILIAL=PC0_FILIAL AND LBB_CODPRO=PC1_CODPRO AND LBB.%notDel%
				INNER JOIN %table:LJX% LJX ON LJX_FILIAL=PC1_FILIAL AND LJX_PAGA='S' AND LJX.%notDel%
				LEFT  JOIN %table:LJZ% LJZ ON LJZ_FILIAL=LJX_FILIAL AND LJZ_CODBON=LJX_CODBON AND LJZ_CODPRO=LBB_CODPRO
				AND LJZ_DATCLQ=%EXP:MV_PAR01% AND LJZ.%notDel%
				WHERE PC0_FILIAL=%EXP:cFilAnt% AND PC0.%notDel%  AND PC0_TPENTR='1'
				AND MONTH(PC0_DTENTR)=%Exp:Month(MV_PAR01)% AND YEAR(PC0_DTENTR)=%Exp:Year(MV_PAR01)%
				GROUP BY PC1_CODPRO,PC1_LINHA,LBB_DESC,LBB_NOMFOR,LBB_CODPRO,LJX_CODBON,LJX_DESC,LJX_ORDEM,LBB_CODFAM,LBB_FILIAL,LJX_EDITA

                UNION ALL

                SELECT PC1_CODPRO,PC1_LINHA,LBB_DESC,LBB_NOMFOR,'N' AS LJX_EDITA,

                ISNULL((SELECT '_F' FROM %table:ZXR% ZXR WHERE ZXR_CODFAM=LBB_CODFAM AND ZXR_FILIAL=LBB_FILIAL AND ZXR.%notDel%),
                ISNULL((SELECT 'PA' FROM %table:ZXR% ZXR WHERE ZXR_CODPAI=LBB_CODPRO AND ZXR_FILIAL=LBB_FILIAL AND ZXR.%notDel%),'SF')) AS ZXR_FAM,

                ISNULL((SELECT ZXR_CODFAM+'-'+ZXR_DESC FROM %table:ZXR% ZXR WHERE ZXR_CODFAM=LBB_CODFAM AND ZXR_FILIAL=LBB_FILIAL AND ZXR.%notDel%),
                ISNULL((SELECT ZXR_CODFAM+'-'+ZXR_DESC FROM %table:ZXR% ZXR WHERE ZXR_CODPAI=LBB_CODPRO AND ZXR_FILIAL=LBB_FILIAL AND ZXR.%notDel%),'999999-SEM FAMILIA')) AS ZXR_DESC,

                ROUND(SUM(PC1_QTDLIT),0) AS PC1_QTDLIT,
				ROUND(AVG(PC1_VLRLIT),3) AS PC1_VLRLIT,ROUND(ROUND(SUM(PC1_QTDLIT),0)/30,0) AS MEDLIT,
				'999999'  AS  LJX_CODBON, 'BONIF.FIXA'  AS  LJX_DESC,99  AS  LJX_ORDEM,
                ISNULL(
                (SELECT SUM(LJU_VALOR) FROM %table:LJU% LJU WHERE  LJU_FILIAL=PC0_FILIAL AND LJU_CODPRO=PC1_CODPRO
                AND LJU_PERIOD=%EXP:SubStr(dtoc(MV_PAR01),4,2)+SubStr(dtoc(MV_PAR01),7,4)% AND LJU.%notDel% )
                /SUM(PC1_QTDLIT),0)  AS  LJZ_RESLEI,

                (SELECT ROUND(SUM(PC1_QTDLIT),0)
                 FROM %table:PC0% PC0
                 INNER JOIN %table:PC1% PC1 ON PC1_CODPRO=LBB_CODPRO AND PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
                 WHERE PC0_FILIAL=%EXP:cFilAnt% AND PC0_TPENTR='1' AND MONTH(PC0_DTENTR)=%Exp:cMes% AND YEAR(PC0_DTENTR)=%Exp:cAno% AND PC0.%notDel%) AS QTDLIT_A,
                 (SELECT ROUND(AVG(PC1_VLRLIT),3) AS VLRLITA
                 FROM %table:PC0% PC0
                 INNER JOIN %table:PC1% PC1 ON PC1_CODPRO=LBB_CODPRO AND PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
                 WHERE PC0_FILIAL=%EXP:cFilAnt% AND PC0_TPENTR='1' AND MONTH(PC0_DTENTR)=%Exp:cMes% AND YEAR(PC0_DTENTR)=%Exp:cAno% AND PC0.%notDel%) AS VLRLIT_A,
                 ROUND(((SELECT ROUND(SUM(PC1_QTDLIT),0)
                 FROM %table:PC0% PC0
                 INNER JOIN %table:PC1% PC1 ON PC1_CODPRO=LBB_CODPRO AND PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
                 WHERE PC0_FILIAL=%EXP:cFilAnt% AND PC0_TPENTR='1' AND MONTH(PC0_DTENTR)=%Exp:cMes% AND YEAR(PC0_DTENTR)=%Exp:cAno% AND PC0.%notDel%)/
                 (30)),0) AS MEDLIT_A

				FROM  %table:PC0% PC0
				INNER JOIN  %table:PC1% PC1 ON PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
				INNER JOIN  %table:LBB% LBB ON LBB_FILIAL=PC0_FILIAL AND LBB_CODPRO=PC1_CODPRO AND LBB.%notDel%
				WHERE PC0_FILIAL=%EXP:cFilAnt%AND PC0.%notDel% AND MONTH(PC0_DTENTR)=%Exp:Month(MV_PAR01)% AND YEAR(PC0_DTENTR)=%Exp:Year(MV_PAR01)%
				AND PC0_TPENTR='1'
				GROUP BY PC0_FILIAL,PC1_CODPRO,PC1_LINHA,LBB_NOMFOR,LBB_CODPRO,LBB_DESC,LBB_CODFAM,LBB_FILIAL
				ORDER BY ZXR_DESC,ZXR_FAM,PC1_CODPRO,LJX_ORDEM,LJX_EDITA DESC,LJX_CODBON

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

			//ProcRegua(nArray)
            //IncProc("Processando Produtor > " + AllTrim(cCodPro)+"-"+Alltrim(cNomPro))
            xLitros := 0
			While (cAliasQry)->(!Eof())
                //IncProc("Processando Produtor > " + AllTrim(cCodPro)+"-"+Alltrim(cNomPro))
					If cCodPro == (cAliasQry)->(PC1_CODPRO)
						aPrcLeite[nLinha][nCLCodPro] := (cAliasQry)->(PC1_CODPRO)
						aPrcLeite[nLinha][nCLNomPro] := Subst((cAliasQry)->(LBB_NOMFOR),1,15)
						aPrcLeite[nLinha][nCLTpFam]  := (cAliasQry)->(ZXR_FAM)
                        aPrcLeite[nLinha][nCLFamili] := subst((cAliasQry)->(ZXR_DESC),1,15)
                        aPrcLeite[nLinha][nCLLitAnt] := (cAliasQry)->(QTDLIT_A)
                        aPrcLeite[nLinha][nCLMdLtDA] := (cAliasQry)->(MEDLIT_A)
                        aPrcLeite[nLinha][nCLPrcAnt] := (cAliasQry)->(VLRLIT_A) + Round(( ( (cAliasQry)->(VLRLIT_A)*nPerInc )/100 ) - ( ( (cAliasQry)->(VLRLIT_A)*nPerFun )/100 ),3)
                        aPrcLeite[nLinha][nCLLitros] := (cAliasQry)->(PC1_QTDLIT)
                        aPrcLeite[nLinha][nCLMedDia] := (cAliasQry)->(MEDLIT)

						aPrcLeite[nLinha][nCLPrBase] := nPrBase
						aPrcLeite[nLinha][nCLFrete]  := nFrete((cAliasQry)->(PC1_CODPRO),(cAliasQry)->(PC1_LINHA),(cAliasQry)->(PC1_QTDLIT))
						cNomPro                      := (cAliasQry)->(LBB_NOMFOR)
						aPrcLeite[nLinha][nColuna]   := (cAliasQry)->(LJZ_RESLEI)

                        If (cAliasQry)->(LJX_EDITA) == 'N'
                            nPrTotal += (cAliasQry)->(LJZ_RESLEI)
						Else
                            nAdcMer += (cAliasQry)->(LJZ_RESLEI)
                        End If

                        nColuna ++
					Else

                        xFun := ( (nPrTotal+nAdcMer) * nPerFun )/100
                        xFun := -( ( ( (xFun) * nPerFun ) / 100 ) + xFun)

                        xIncen  := ( ( ((nPrTotal+nAdcMer)-xFun) )  * nPerInc )/100
                        xIncen  := xIncen - ( ( xIncen  *  nPerInc ) / 100  )

                        aPrcLeite[nLinha][nCLPrCust]    :=  (nPrTotal + nAdcMer - xIncen - xFun) +  aPrcLeite[nLinha][nCLFrete] + xIncen
                        aPrcLeite[nLinha][nCLPrFim]     := Round(nPrTotal + nAdcMer  ,3)

                        aPrcLeite[nLinha][nCLPrDif]     := aPrcLeite[nLinha][nCLPrFim] - aPrcLeite[nLinha][nCLPrcAnt]

                        aPrcLeite[nLinha][nCLIncen]     := Iif(nPerInc > 0,xIncen	,0)
						aPrcLeite[nLinha][nCLFunRur]    := Iif(nPerFun > 0,xFun	    ,0)

                        aPrcLeite[nLinha][nColuna]      := .F.

						nTotal 	+= aPrcLeite[nLinha][nCLPrCust] * aPrcLeite[nLinha][nCLLitros]
						xLitros += aPrcLeite[nLinha][nCLLitros]
                        cCodPro		:= (cAliasQry)->(PC1_CODPRO)
						nPrTotal 	:= nPrBase
						nColuna 	:= nColOri
						nAdcMer     := 0
                        nLinha ++

                        aPrcLeite[nLinha][nCLCodPro] := (cAliasQry)->(PC1_CODPRO)
						aPrcLeite[nLinha][nCLNomPro] := Subst((cAliasQry)->(LBB_NOMFOR),1,15)
						aPrcLeite[nLinha][nCLTpFam]  := (cAliasQry)->(ZXR_FAM)
                        aPrcLeite[nLinha][nCLFamili] := subst((cAliasQry)->(ZXR_DESC),1,15)
                        aPrcLeite[nLinha][nCLLitAnt] := (cAliasQry)->(QTDLIT_A)
                        aPrcLeite[nLinha][nCLMdLtDA] := (cAliasQry)->(MEDLIT_A)
                        aPrcLeite[nLinha][nCLPrcAnt] := Round(( ( (cAliasQry)->(VLRLIT_A)*nPerInc )/100 ) - ( ( (cAliasQry)->(VLRLIT_A)*nPerFun )/100 ),3)
                        aPrcLeite[nLinha][nCLLitros] := (cAliasQry)->(PC1_QTDLIT)
                        aPrcLeite[nLinha][nCLMedDia] := (cAliasQry)->(MEDLIT)

                        aPrcLeite[nLinha][nCLPrBase] := nPrBase
						aPrcLeite[nLinha][nCLFrete]  := nFrete((cAliasQry)->(PC1_CODPRO),(cAliasQry)->(PC1_LINHA),(cAliasQry)->(PC1_QTDLIT))
						aPrcLeite[nLinha][nColuna]   := (cAliasQry)->(LJZ_RESLEI)

                        If (cAliasQry)->(LJX_EDITA) == 'N'
                            nPrTotal += (cAliasQry)->(LJZ_RESLEI)
						Else
                            nAdcMer += (cAliasQry)->(LJZ_RESLEI)
 						EndIf

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

                        xFun := ( (nPrTotal+nAdcMer) * nPerFun )/100
                        xFun := -(( ( (xFun) * nPerFun ) / 100 ) + xFun)

                        xIncen  := ( ( ((nPrTotal+nAdcMer)-xFun) )  * nPerInc )/100
                        xIncen  := xIncen - ( ( xIncen  *  nPerInc ) / 100  )

                        //aPrcLeite[nLinha][nCLPrCust]    := Round(nPrTotal + nAdcMer +  aPrcLeite[nLinha][nCLFrete]  + xFun,6)
                        aPrcLeite[nLinha][nCLPrCust]    :=  (nPrTotal + nAdcMer - xIncen - xFun) +  aPrcLeite[nLinha][nCLFrete] + xIncen
                        aPrcLeite[nLinha][nCLPrFim]     := Round(nPrTotal + nAdcMer  ,3)

                        aPrcLeite[nLinha][nCLPrDif]     := aPrcLeite[nLinha][nCLPrFim] - aPrcLeite[nLinha][nCLPrcAnt]

                        aPrcLeite[nLinha][nCLIncen]     := Iif(nPerInc > 0,xIncen	,0)
						aPrcLeite[nLinha][nCLFunRur]    := Iif(nPerFun > 0,xFun	    ,0)

                    	nTotal 	+= aPrcLeite[nLinha][nCLPrCust] * aPrcLeite[nLinha][nCLLitros]
						xLitros += aPrcLeite[nLinha][nCLLitros]

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
	//nPrReal := Round(nTotal/Len(aPrcLeite),3)

    //if abs(Round(nPrReal-Round(nTotal/Len(oPrcLeite:aCols),3),3)) == 0.001
    //    nPrReal := nPrMdFl
	//Else
        nPrReal := Round(nTotal/xLitros,3)
    //EndIf


    oPrReal:Refresh()
	oPrcLeite:Refresh()
	oPrcLeite:ForceRefresh()

Return

/*/{Protheus.doc} nFrete()===============================================================================================================================
Carrega custo do frete do produtor na grid
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static Function nFrete(cCodPro,cCodCar,nLitros)

	Local nRet 		:= 0
	Local cAliasPA3 := 'PA3QRY'
	Local nRet 		:= 0

    	BeginSql Alias cAliasPA3

			%noparser%

			SELECT (PA3_VRTOT/PA3_QTDLIT) as CUSTO FROM %table:PA3% PA3 WHERE
			PA3_PERIOD=%Exp:SubStr(DTOC(MV_PAR01),4,2)+SubStr(DTOC(MV_PAR01),7,4)%
			AND PA3_CODCAM=%Exp:cCodCar% AND PA3.%notDel%

		EndSql

		aRet1 := GetLastQuery()

	    If (cAliasPA3)->(!Eof())
	    	nRet :=  (cAliasPA3)->(CUSTO)
	    End If

	    (cAliasPA3)->( dbCloseArea())


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
/*/{Protheus.doc} RecalBon()
Recalcula bonificacoes de volume e distancia
@type function
@version
@author Wilson Davila
@since 21/02/2020
@return return_type, return_description
/*/
Static Function RecalBon()

	Local cTipoBon		:= ' '
	LOcal cTipoCal      := '' //1=Mensal;2=Aritmetica;3=Geometrica
    Local nResLei 		:= 0
	Local nLitros		:= 0
	Local nDistan   	:= 0
	Local nSoma         := 0
    Local nSoma1        := 0
    Local nSoma2        := 0
    Local dData 		:= dtos(MV_PAR01)
	Local nItem         := 0
    Local dDtAtu        := MV_PAR01
    Local nArred        := 0
    Private cAliasQry  	:= GetNextAlias()

	DbSelectArea("LJZ") //Historico da classificacao da Qualidade do leite
	DbSetOrder(6)

    ProcRegua(0)
    IncProc("Recalc. Bonif." + AllTrim(LJZ->LJZ_CODPRO)+"-"+Alltrim(LJZ->LJZ_DESBON)+" "+DTOC(LJZ->LJZ_DATCLQ))

    If dbSeek( xFilial("LJZ") + dData)

        //DBGOTOP()

        While !Eof() .AND. xFilial("LJZ") == LJZ->LJZ_FILIAL .AND. LJZ->LJZ_DATCLQ == stod(dData)
            //Tipo Bom
			// 1-PLANILHA-> Sera usada planilha para entrar com dados no sistema,
			// 2-VOLUME->Sera usado o volume captado pelo produtor no sistema para calculo,
			// 3-DISTANCIA->Sera usado o campo distancia do produtor ate o laticinio do cadastro de propriedades,
			// 4-DIGITADO->No caso de adicional de Mercado para composicao do preco no simulador.

            // Tipo Calculo
            //1=Mensal;2=Aritmetica;3=Geometrica
            IncProc("Recalc. Bonif." + AllTrim(LJZ->LJZ_CODPRO)+"-"+Alltrim(LJZ->LJZ_DESBON)+" "+DTOC(LJZ->LJZ_DATCLQ))

            LJX->( dbSetOrder(1) )

            If LJX->( dbSeek(cFilAnt+LJZ->(LJZ_CODBON)))
                nArred := LJX->(LJX_ARRED)
            EndIf

            LJZArea := GetArea()
            //MV_PAR01 := LJZ->LJZ_DATCLQ
            //dTFechto := MV_PAR01

			cTipoBon := LJZ->LJZ_TPBON
            cTipoCal := LJZ->LJZ_METCLA

			If cTipoBon  ==  '2'  // VOLUME
                //IncProc("Recalc. Bonif." + AllTrim(LJZ->LJZ_CODPRO)+"-"+Alltrim(LJZ->LJZ_DESBON))
				nLitrosAtu 	:= LJZ->LJZ_QTDLEI
				nLitros     := U_RetLitros(LJZ->LJZ_CODPRO)

					aRet    := U_QuaCAL21(Alltrim(LJZ->(LJZ_CODBON)),,nLitros)
                    nResLei := aRet[1][1]
                    nFxINI  := aRet[1][2]
                    nFxFIM  := aRet[1][3]
                    nItem   := aRet[1][4]

			ElseIf cTipoBon  ==  '3' // DISTANCIA

			    nDistan	   := Posicione("LBB",1,XFILIAL("LBB")+LJZ->LJZ_CODPRO,"LBB_DISTAN")

					aRet    := U_QuaCAL21(Alltrim(LJZ->(LJZ_CODBON)),,nDistan)
                    nResLei := aRet[1][1]
                    nFxINI  := aRet[1][2]
                    nFxFIM  := aRet[1][3]
                    nItem   := aRet[1][4]

            EndiF

            If !cTipoBon $ '2|3' .AND. cTipoCal == '1' //mensal

                aRet    := U_QuaCAL21(Alltrim(LJZ->(LJZ_CODBON)),,LJZ->(LJZ_QTDMES))
                nSoma   := LJZ->(LJZ_QTDMES)
                nResLei := aRet[1][1]
                nFxINI  := aRet[1][2]
                nFxFIM  := aRet[1][3]
                nItem   := aRet[1][4]

            ElseIf !cTipoBon $ '2|3' .AND. cTipoCal == '2' //aritmetica

                aRes := xCalculo(LJZ->(LJZ_CODBON),LJZ->(LJZ_CODPRO))
                nSoma1 := 0

                For i := 1 To Len(aRes)
                    nSoma1 += aRes[i][1]
                Next i

                If nSoma1 > 0
                    nSoma1 := ( nSoma1 / Len(aRes) )
                Else
                    nSoma1 := LJZ->(LJZ_QTDMES)
                EndIf

                aRet    := U_QuaCAL21(Alltrim(LJZ->(LJZ_CODBON)),,Round(nSoma1,nArred))
                nResLei := aRet[1][1]
                nFxINI  := aRet[1][2]
                nFxFIM  := aRet[1][3]
                nItem   := aRet[1][4]

            ElseIf !cTipoBon $ '2|3' .AND. cTipoCal == '3' //geometrica

                aRes := xCalculo(LJZ->(LJZ_CODBON),LJZ->(LJZ_CODPRO))
                nSoma2 := 0

                For i := 1 To Len(aRes)
                    If i == 1
                        nSoma2 := aRes[i][1]
                    Else
                        nSoma2 := ( nSoma2 * aRes[i][1] )
                    EndIf
                Next i

                If nSoma2 > 0
                    nSoma2 := ( nSoma2 ^ ( 1/Len(aRes) ) )
                Else
                    nSoma2 := LJZ->(LJZ_QTDMES)
                EndIf

                aRet    := U_QuaCAL21(Alltrim(LJZ->(LJZ_CODBON)),,Round(nSoma2,nArred))
                nResLei := aRet[1][1]
                nFxINI  := aRet[1][2]
                nFxFIM  := aRet[1][3]
                nItem   := aRet[1][4]

            EndIf

			RestArea(LJZArea)

            If   cTipoBon $ '2|3'
				RecLock("LJZ",.F.)
					LJZ->LJZ_RESLEI	:= nResLei
					LJZ->LJZ_QTDLEI := nLitros+nDistan
                    LJZ->LJZ_RESMES	:= nResLei
					LJZ->LJZ_QTDMES := nLitros+nDistan
                    LJZ->LJZ_VINIC  := nFxINI
                    LJZ->LJZ_VFINAL := nFxFIM
                    LJZ->LJZ_ITEM   := nItem
                MsUnlock()
			ElseIf !cTipoBon $ '4'
                RecLock("LJZ",.F.)
					LJZ->LJZ_QTDLEI := nSoma+nSoma1+nSoma2
                    LJZ->LJZ_RESLEI	:= nResLei
					LJZ->LJZ_VINIC  := nFxINI
                    LJZ->LJZ_VFINAL := nFxFIM
                    LJZ->LJZ_ITEM   := nItem
                MsUnlock()
            EndIf

			nSoma   := 0
            nSoma1  := 0
            nSoma2  := 0
            nLitros := 0
			nDistan := 0
			nResLei := 0
	        nFxINI  := 0
            nFxFIM  := 0
            nItem   := 0
			dbSkip()

		EndDo
	End If
//MV_PAR01 := dDtAtu
//dTFechto := MV_PAR01
Return

/*/{Protheus.doc} ReportExcel
Gera Tela em Excle
@type function
@versionhd
@author Wilson Davila
@since 30/06/2020
/*/

Static Function ReportExcel(oPrcLeite)

	Local oExcel 	:= FWMsExcelEx():New()
	Local nConta	:= 0
	Local cArq := cGetFile (,, 1,, .F., GETF_RETDIRECTORY+GETF_LOCALHARD)
    Local cPasta := "SIMULADOR D"+CVALTOCHAR(DTOS(Ddatabase))+" H"+StrTran(time(), ":", "" )
    cArq := cArq + "SIMULADOR_D"+CVALTOCHAR(DTOS(Ddatabase))+"_H"+StrTran(time(), ":", "" )+".XLS"

    oExcel:AddworkSheet(cPasta)
	oExcel:AddTable (cPasta,"Simulador Preço Leite")


    For a := 1 to Len(aHead)

        oExcel:AddColumn(cPasta,"Simulador Preço Leite",padr(aHead[a][1],5),iif(AllTrim(aHead[a][8])=="N",3,1),iif(AllTrim(aHead[a][8])=="N",1,2))

    Next a

    aDados := Array(Len(oPrcLeite:aCols),Len(aHead))

    For _a := 1 To Len(oPrcLeite:aCols)

        For b := 1 to Len(aHead)
        aDados[_a][b] := oPrcLeite:aCols[_a][b]
        Next b

        oExcel:AddRow(cPasta,"Simulador Preço Leite",aDados[_a])

    Next _a

    MsgInfo("Planilha Gerada")

    //ProcessMessage()
	oExcel:Activate()
	oExcel:GetXMLFile(cArq)
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cArq)
	oExcelApp:SetVisible(.T.)

Return

/*/{Protheus.doc} ZeraAdc
Zera Coluna adicional de Mercado
@type function
@version
@author Wilson Davila
@since 30/06/2020
/*/
Static Function ZeraAdc(oPrcLeite,lCalc)

    Local lRecalc   := .F.
    Local lZeraALL  := .F.

    ProcRegua(Len(oPrcLeite:aCols))

    LJZ->(dbSetOrder(5))

    If lCalc
        If MsgYesNo("Deseja zerar TODOS os produtores? ###Se SIM zera todos se NAO zera somente os sem preco fixo##")
            lZeraALL := .T.
        EndIf
    EndIf

        For n := 1 To Len(oPrcLeite:aCols)
        IncProc("Processando Produtor > " + AllTrim(oPrcLeite:aCols[n][1])+"-"+Alltrim(oPrcLeite:aCols[n][2]))
            lRecalc := .F.

            If !lZeraALL
               If LJZ->(dbSeek(xFilial("LJZ")+DTOS(MV_PAR01)+AllTrim(oPrcLeite:aCols[n,1])+'000009'))
                    If LJZ->(LJZ_RECALC) == 'S'
                        lRecalc := .T.
                    Else
                        LJZ->( RecLock("LJZ",.F.) )
                                LJZ->LJZ_RESLEI := 0
            			LJZ->( MsUnlock() )
                    End If
                EndIf

                If !lRecalc
                    oPrcLeite:aCols[n][nColOri] := 0
                    RecalPr(oPrcLeite,n)
                EndIf
            Else
                If LJZ->(dbSeek(xFilial("LJZ")+DTOS(MV_PAR01)+AllTrim(oPrcLeite:aCols[n,1])+'000009'))
                    LJZ->( RecLock("LJZ",.F.) )
                        LJZ->LJZ_RESLEI := 0
            		    LJZ->LJZ_RECALC := ''
                    LJZ->( MsUnlock() )
                EndIf

                oPrcLeite:aCols[n][nColOri] := 0
                RecalPr(oPrcLeite,n)
            EndIf
        Next n

    If lCalc
        MsgInfo("Adicional de Mercador Zerado!")
    End If
Return

/*/{Protheus.doc} ()=============================================================================================================================
Recalcula colunas apos zerar valor de adcional de mercado.
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static Function RecalPr(oPrcLeite,n)

	//aCpo[1] == DESCRICAO
	//aCpo[2] == EDITAVEL?
	//aCpo[3] == COD.BONIFICACAO

    Local nPrcCal   := 0
	Local nPrAtu    := oPrcLeite:aCols[n,nCLPrFim]
    Local nPrGrv    := 0
    Local nIncen    := 0
    Local nFunRur   := 0
    Local nTotCal   := 0
    Local nColAtu   := 0
    Local nColInc   := 0
    Local nColFun   := 0

    nTotal := 0
	oPrcLeite:aCols[n,nCLPrFim] := nPrBase

	//LJZ_FILIAL+DTOS(LJZ_DATCLQ)+LJZ_CODPRO+LJZ_CODBON
    LJZ->(dbSetOrder(5))

	For b := 1 To Len(aHead)

		If      AllTrim(aHead[b][2]) == "F1_XINCEN"
                nColInc := b
        ElseIf  AllTrim(aHead[b][2]) == "F1_XINSS"
                nColFun := b
        EndIf

        If "M->"+AllTrim(aHead[b][2]) == "M->LJZ_000009"
            nPrcCal := oPrcLeite:aCols[n,b]
            nColAtu := b
            If nPrcCal == 0
                oPrcLeite:aCols[n,b] := 0
            EndIf
        Else
            If aHead[b][14] == 'S'
                nTotCal += iif("M->"+AllTrim(aHead[b][2]) == "M->LJZ_000009",0,oPrcLeite:aCols[n,b])
            EndIf
        End If

	Next b

    //oPrcLeite:aCols[n][nColInc] := nIncen   :=  Round( ( ( nTotCal * nIncen(  oPrcLeite:aCols[n][1]) ) / 100 ),4 )
	//oPrcLeite:aCols[n][nColFun] := nFunRur	:= -Round( ( ( (nTotCal+nIncen) * nFunRur( oPrcLeite:aCols[n][1]) ) / 100 ),4 )

    //oPrcLeite:aCols[n][nColInc] := nIncen  := Round( ( ( nTotCal * nIncen(  oPrcLeite:aCols[n][1]) ) / 100 ),6 )
    //nFunRur := Round( ( ( (nTotCal) * nFunRur( oPrcLeite:aCols[n][1]) ) / 100 ),6 )
    //oPrcLeite:aCols[n][nColFun] := nFunRur	:= -(Round( ( ( (nFunRur) * nFunRur( oPrcLeite:aCols[n][1]) ) / 100 ),6 ) + nFunRur )

    nFunRur	          := Round( ( ( (nTotCal) * nFunRur( oPrcLeite:aCols[n][1]) ) / 100 ),6 )
    oPrcLeite:aCols[n][nColFun] := nFunRur := -(Round( ( ( (nFunRur) * nFunRur( oPrcLeite:aCols[n][1]) ) / 100 ),6 ) + nFunRur)

    oPrcLeite:aCols[n][nColInc] := ( ( (nTotCal-nFunRur) * nIncen(oPrcLeite:aCols[n][1]) ) / 100 )
    oPrcLeite:aCols[n][nColInc] := nIncen := oPrcLeite:aCols[n][nColInc] - ( ( oPrcLeite:aCols[n][nColInc]  *  nIncen(oPrcLeite:aCols[n][1]) ) / 100  )


    //If nPrcCal > 0
    //    oPrcLeite:aCols[n,nColAtu]    := nPrcCal-((nTotCal + nIncen + nFunRur))
    //Else
        oPrcLeite:aCols[n,nColAtu]    := 0
    //EndIf

    //oPrcLeite:aCols[n,nCLPrCust]  := nTotCal+oPrcLeite:aCols[n,nCLFrete]+nFunRur//Round((oPrcLeite:aCols[n,nColAtu]+nTotCal + nIncen + nFunRur + oPrcLeite:aCols[n,nCLFrete]),6)
    oPrcLeite:aCols[n,nCLPrCust]  := (nTotCal-nIncen-nFunRur) + nIncen + oPrcLeite:aCols[n,nCLFrete]//Round((oPrcLeite:aCols[n,nColAtu]+nTotCal + nIncen + nFunRur + oPrcLeite:aCols[n,nCLFrete]),6)
    oPrcLeite:aCols[n,nCLPrFim]   := nTotCal //Round((oPrcLeite:aCols[n,nColAtu]+nTotCal + nIncen + nFunRur),3)
    oPrcLeite:aCols[n,nCLPrDif]   := oPrcLeite:aCols[n,nCLPrFim] - oPrcLeite:aCols[n,nCLPrcAnt]

    oPrcLeite:Refresh()


    nLitros := 0
    nTotal  := 0
    For _acl := 1 To Len(oPrcLeite:aCols)
        nLitros += oPrcLeite:aCols[_acl][nCLLitros]
        nTotal += oPrcLeite:aCols[_acl][nCLLitros] * oPrcLeite:aCols[_acl][nCLPrCust]
    Next _acl

    nTotal := nTotal/nLitros

  	nPrReal := Round(nTotal,3)

    oPrReal:Refresh()
	oPrcLeite:Refresh()

Return .T.

/*/{Protheus.doc} GetAdcMed
Calcula adicional de mercado para produtores sem valor fixado pela diferenca do preco medio x Realizado
@type function
@version
@author Wilson Davila
@since 06/07/2020
/*/
Static Function GetAdcMed(oPrcLeite)

    Local nPrcCal   := 0
	Local n         := 1
    Local nPrAtu    := oPrcLeite:aCols[n,nCLPrFim]
    Local nPrGrv    := 0
    Local nIncen    := 0
    Local nFunRur   := 0
    Local nTotCal   := 0
    Local nColAtu   := 0
    Local nColInc   := 0
    Local nColFun   := 0
    Local nPrcus    := 0
    Local lRecalc   := .F.
    Local nPerCen   := 0
    Local nPerCen1  := 0
    Local xTotCus   := 0
    Local nLitros   := 0

    ZeraAdc(oPrcLeite,.F.)

    LJZ->(dbSetOrder(5))

    ProcRegua(Len(oPrcLeite:aCols))

    For _a := 1 To 1

        xTotCus     := 0
        nMediaFixa  := 0
        nMediaVar   := 0
        nPrFilAju   := 0
        nDifMdFix   := 0
        nLinFix     := 0
        nLinVar     := 0
        nDifMedPr   := 0
        nPrFimCal   := 0
        nTemFixo    := 0
        nLitros     := 0
        nLitTot     := 0
        nCusMeta    := 0
        nCusFixo    := 0
        nCusVar     := 0
        For _acl := 1 To Len(oPrcLeite:aCols)
                nTemFixo += oPrcLeite:aCols[_acl][nColOri]
                nLitTot += oPrcLeite:aCols[_acl][nCLLitros]
                //nCusMeta += oPrcLeite:aCols[_acl][nCLPrCust] * oPrcLeite:aCols[_acl][nCLLitros]
        Next _acl

        nCusMeta := nPrMdFl * nLitTot

        If nTemFixo > 0 .AND. _a == 1
            //msgAlert("tem fixo")
            If _a == 1

                For _acl := 1 To Len(oPrcLeite:aCols)
                    If oPrcLeite:aCols[_acl][nColOri] > 0
                        nLinFix ++
                        nLitros     += oPrcLeite:aCols[_acl][nCLLitros]
                        nMediaFixa  += oPrcLeite:aCols[_acl][nCLPrCust] * oPrcLeite:aCols[_acl][nCLLitros]
                        nCusFixo    += oPrcLeite:aCols[_acl][nCLPrCust] * oPrcLeite:aCols[_acl][nCLLitros]
                    End If
                Next _acl

                nMediaFixa := nMediaFixa/nLitros

                nLitros := 0


                For _acl := 1 To Len(oPrcLeite:aCols)
                    If oPrcLeite:aCols[_acl][nColOri] == 0
                        nLinVar ++
                        nLitros     += oPrcLeite:aCols[_acl][nCLLitros]
                        nMediaVar   += oPrcLeite:aCols[_acl][nCLPrCust] * oPrcLeite:aCols[_acl][nCLLitros]
                        nCusVar += oPrcLeite:aCols[_acl][nCLPrCust] * oPrcLeite:aCols[_acl][nCLLitros]
                    End If
                Next _acl

                nMediaVar := nMediaVar/nLitros

            Else

                nLitros := 0
                For _acl := 1 To Len(oPrcLeite:aCols)
                    If LJZ->(dbSeek(xFilial("LJZ")+DTOS(MV_PAR01)+AllTrim(oPrcLeite:aCols[_acl,1])+'000009'))
                        If LJZ->(LJZ_RECALC) == 'S'
                            nLinFix ++
                            nLitros += oPrcLeite:aCols[_acl][nCLLitros]
                            nMediaFixa += oPrcLeite:aCols[_acl][nCLPrCust] * oPrcLeite:aCols[_acl][nCLLitros]
                            nCusFixo += oPrcLeite:aCols[_acl][nCLPrCust] * oPrcLeite:aCols[_acl][nCLLitros]
                        End If
                    End If
                Next _acl

                nMediaFixa := nMediaFixa/nLitros

                nLitros := 0

                For _acl := 1 To Len(oPrcLeite:aCols)
                    If LJZ->(dbSeek(xFilial("LJZ")+DTOS(MV_PAR01)+AllTrim(oPrcLeite:aCols[_acl,1])+'000009'))
                        If LJZ->(LJZ_RECALC) <> 'S'
                            nLinVar ++
                            nLitros += oPrcLeite:aCols[_acl][nCLLitros]
                            nMediaVar += oPrcLeite:aCols[_acl][nCLPrCust] * oPrcLeite:aCols[_acl][nCLLitros]
                            nCusVar += oPrcLeite:aCols[_acl][nCLPrCust] * oPrcLeite:aCols[_acl][nCLLitros]
                        End If
                    End If
                Next _acl

                nMediaVar := nMediaVar/nLitros

            End If

            //nDifMedPr := nPrMdFl-nMediaFixa
            //nPrFimCal := nPrMdFl+nDifMedPr

            //nPerCen := ((nPrFimCal-nMediaVar)/nMediaVar)*100+((nPerInc*((((nPrFimCal-nMediaVar)/nMediaVar)*100)))/100)
            //nPerCen :=   (((nPrMdFl-xTotCus)/xTotCus)*100)+((nPerInc*((((nPrMdFl-xTotCus)/xTotCus)*100)))/100)
            //custototal-(custofixo+custovariavel)+custovariaval
            nPerCen := ((((nCusMeta-(nCusFixo+nCusVar)+nCusVar)-nCusVar)/(nCusVar))*100) + ((nPerInc*((((nCusMeta-(nCusFixo+nCusVar)+nCusVar)-nCusVar)/(nCusVar))*100))/100)
        Else
           //msgAlert("NAO tem fixo")
           For _acl := 1 To Len(oPrcLeite:aCols)
                nLitros += oPrcLeite:aCols[_acl][nCLLitros]
                xTotCus += oPrcLeite:aCols[_acl][nCLLitros] * oPrcLeite:aCols[_acl][nCLPrCust]
            Next _acl

            xTotCus := xTotCus/nLitros
            nPerCen :=   (((nPrMdFl-xTotCus)/xTotCus)*100)+((nPerInc*((((nPrMdFl-xTotCus)/xTotCus)*100)))/100)

        EndIf

        For n := 1 To Len(oPrcLeite:aCols)

            IncProc("Processando Produtor > " + AllTrim(oPrcLeite:aCols[n][1])+"-"+Alltrim(oPrcLeite:aCols[n][2]))

            nTotCal := 0

            If _a == 1
                If oPrcLeite:aCols[n][nColOri] > 0
                    Loop
                EndIf
            Else
                If LJZ->(dbSeek(xFilial("LJZ")+DTOS(MV_PAR01)+AllTrim(oPrcLeite:aCols[n,1])+'000009'))
                    If LJZ->(LJZ_RECALC) == 'S'
                        Loop
                    End If
                EndIf
            EndIf

            nTotal := 0

            nPrAtu := oPrcLeite:aCols[n,nCLPrFim]
            nPrcus := oPrcLeite:aCols[n,nCLPrCust]

            If _a == 1
                oPrcLeite:aCols[n,nCLPrFim] := nPrBase
            EndIf

            //LJZ_FILIAL+DTOS(LJZ_DATCLQ)+LJZ_CODPRO+LJZ_CODBON
            LJZ->(dbSetOrder(5))

        	For b := 1 To Len(aHead)

        		If      AllTrim(aHead[b][2]) == "F1_XINCEN"
                        nColInc := b
                ElseIf  AllTrim(aHead[b][2]) == "F1_XINSS"
                        nColFun := b
                EndIf

                If "M->"+AllTrim(aHead[b][2]) == "M->LJZ_000009" //AllTrim(ReadVar())
                    nPrcCal := ( (nPrAtu-oPrcLeite:aCols[n][nColInc]-oPrcLeite:aCols[n][nColFun]) + (((nPrAtu-oPrcLeite:aCols[n][nColInc]-oPrcLeite:aCols[n][nColFun]) * nPerCen)/100))  //- (oPrcLeite:aCols[n,nCLFrete])
                    nColAtu := b
                    If nPrcCal == 0
                        oPrcLeite:aCols[n,b] := 0
                    EndIf
                Else
                    If aHead[b][14] == 'S'
                        nTotCal += iif("M->"+AllTrim(aHead[b][2]) == "M->LJZ_000009",nPrcCal,oPrcLeite:aCols[n,b])
                    EndIf
                End If

        	Next b

            nInceAtu := oPrcLeite:aCols[n][nColInc] + ( (oPrcLeite:aCols[n][nColInc]*nPerCen)/100 )
            nPrbAtu  := (nInceAtu*100)/nPerInc
            nFunAtu  := -(((nInceAtu+nPrbAtu))*nPerFun/100)
            nPrFimC  := nInceAtu + nPrbAtu + nFunAtu
            xAdcMer  := nPrFimC - (nTotCal-oPrcLeite:aCols[n][nColInc]-oPrcLeite:aCols[n][nColFun])
            nPrcCal  := nTotCal + xAdcMer

            nFunRur	          :=  ( ( (nPrcCal) * nFunRur( oPrcLeite:aCols[n][1]) ) / 100 )
            oPrcLeite:aCols[n][nColFun] := nFunRur := -( ( ( (nFunRur) * nFunRur( oPrcLeite:aCols[n][1]) ) / 100 ) + nFunRur)
            oPrcLeite:aCols[n][nColInc] := ( ( (nPrcCal-nFunRur) * nIncen(oPrcLeite:aCols[n][1]) ) / 100 )
            oPrcLeite:aCols[n][nColInc] := oPrcLeite:aCols[n][nColInc] - ( ( oPrcLeite:aCols[n][nColInc]  *  nIncen(oPrcLeite:aCols[n][1]) ) / 100  )

            If nPrcCal > 0
                oPrcLeite:aCols[n,nColAtu]    := xAdcMer //nPrcCal-nTotCal//Round(nPrcCal-((nTotCal + nIncen + nFunRur + oPrcLeite:aCols[n,nCLFrete])),6)
            Else
                oPrcLeite:aCols[n,nColAtu]    := 0
            EndIf

            oPrcLeite:aCols[n,nCLPrCust]  :=  (oPrcLeite:aCols[n,nColAtu] + nTotCal) - nFunRur + oPrcLeite:aCols[n,nCLFrete]

            oPrcLeite:aCols[n,nCLPrFim]   := Round(oPrcLeite:aCols[n,nColAtu]+nTotCal,3)
            oPrcLeite:aCols[n,nCLPrDif]   := oPrcLeite:aCols[n,nCLPrFim] - oPrcLeite:aCols[n,nCLPrcAnt]

            For _aAlter := 1 To Len(aAlter)
        		If ( "M->LJZ_000009" == "M->"+AllTrim(aAlter[_aAlter]) )
                	If LJZ->(dbSeek(xFilial("LJZ")+DTOS(MV_PAR01)+AllTrim(oPrcLeite:aCols[n,1])+"000009"))
        				LJZ->( RecLock("LJZ",.F.) )
                            LJZ->LJZ_RESLEI := oPrcLeite:aCols[n,nColAtu]
        				LJZ->( MsUnlock() )
        			End If
        		EndIf
        	Next _aAlter

        Next n

        oPrcLeite:Refresh()

            nLitros := 0
            nTotal  := 0

            For _acl := 1 To Len(oPrcLeite:aCols)
                nLitros += oPrcLeite:aCols[_acl][nCLLitros]
                nTotal += oPrcLeite:aCols[_acl][nCLLitros] * oPrcLeite:aCols[_acl][nCLPrCust]
            Next _acl

            nTotal := nTotal/nLitros
            //nPerCen :=   (((nPrMdFl-xTotCus)/xTotCus)*100)+((nPerInc*((((nPrMdFl-xTotCus)/xTotCus)*100)))/100)


        //For x := 1 To Len(oPrcLeite:aCols)
        //    nTotal += oPrcLeite:aCols[x][nCLPrCust]
    	//Next x

    	nPrReal := Round(nTotal,3)

        oPrReal:Refresh()
    	oPrcLeite:Refresh()

    Next _a

    MsgInfo("Recalculo de preco efetuado!")

Return
/*/{Protheus.doc} RetFam
Copia precos digitados no produtor pai da familia para os filhos
@type function
@version
@author Wilson Davila
@since 21/02/2020
/*/
Static Function RetFam(oPrcLeite,n,cCampo,nValor)

	//aCpo[1] == DESCRICAO
	//aCpo[2] == EDITAVEL?
	//aCpo[3] == COD.BONIFICACAO

    Local nPrcCal   := 0
	Local nPrAtu    := oPrcLeite:aCols[n,nCLPrFim]
    Local nPrGrv    := 0
    Local nIncen    := 0
    Local nFunRur   := 0
    Local nTotCal   := 0
    Local nColAtu   := 0
    Local nColInc   := 0
    Local nColFun   := 0
    Local nBonFix   := 0
    nTotal := 0
	oPrcLeite:aCols[n,nCLPrFim] := nPrBase

    //LJZ_FILIAL+DTOS(LJZ_DATCLQ)+LJZ_CODPRO+LJZ_CODBON
	LJZ->(dbSetOrder(5))

	For b := 1 To Len(aHead)

		If      AllTrim(aHead[b][2]) == "F1_XINCEN"
                nColInc := b
        ElseIf  AllTrim(aHead[b][2]) == "F1_XINSS"
                nColFun := b
        EndIf

        If "M->"+AllTrim(aHead[b][2]) == cCampo
            nPrcCal := nValor
            nColAtu := b
            If nPrcCal == 0
                oPrcLeite:aCols[n,b] := 0
            EndIf
        Else
            If aHead[b][14] == 'S'
                nTotCal += iif("M->"+AllTrim(aHead[b][2]) == cCampo,nValor,oPrcLeite:aCols[n,b])
                If AllTrim(aHead[b][2]) == "LJZ_999999"
                    nBonFix += aCols[n,b]
                EndIf
            EndIf
        End If

	Next b


    nFunRur	          := Round( ( ( (nPrcCal) * nFunRur( oPrcLeite:aCols[n][1]) ) / 100 ),6 )
    oPrcLeite:aCols[n][nColFun] := nFunRur := -(Round( ( ( (nFunRur) * nFunRur( oPrcLeite:aCols[n][1]) ) / 100 ),6 ) + nFunRur)
    oPrcLeite:aCols[n][nColInc] := ( ( (nPrcCal-nFunRur) * nIncen(oPrcLeite:aCols[n][1]) ) / 100 )
    oPrcLeite:aCols[n][nColInc] := oPrcLeite:aCols[n][nColInc] - ( ( oPrcLeite:aCols[n][nColInc]  *  nIncen(oPrcLeite:aCols[n][1]) ) / 100  )

    If nPrcCal > 0
        oPrcLeite:aCols[n,nColAtu]    := (nPrcCal + nBonFix)-((nTotCal))
    Else
        oPrcLeite:aCols[n,nColAtu]    := 0
    EndIf

    //oPrcLeite:aCols[n,nCLPrCust]  := Round((oPrcLeite:aCols[n,nColAtu]+nTotCal + nIncen + nFunRur + oPrcLeite:aCols[n,nCLFrete]),6)
    //oPrcLeite:aCols[n,nCLPrFim]   := Round((oPrcLeite:aCols[n,nColAtu]+nTotCal + nIncen + nFunRur),3)
    //oPrcLeite:aCols[n,nCLPrDif]   := oPrcLeite:aCols[n,nCLPrFim] - oPrcLeite:aCols[n,nCLPrcAnt]

    //If nPrcCal > 0
    //    oPrcLeite:aCols[n,nColAtu]    := xAdcMer //nPrcCal-nTotCal//Round(nPrcCal-((nTotCal + nIncen + nFunRur + oPrcLeite:aCols[n,nCLFrete])),6)
    //Else
    //    oPrcLeite:aCols[n,nColAtu]    := 0
    //EndIf

    //If nPrcCal > 0
    //    aCols[n,nColAtu]    := (nPrcCal) - ((nTotCal ))
    //Else
    //    aCols[n,nColAtu]    := 0
    //EndIf

    //aCols[n,nCLPrCust]  := Round((aCols[n,nColAtu]+nTotCal + nIncen + nFunRur + aCols[n,nCLFrete]),6)
    //aCols[n,nCLPrFim]   := Round((aCols[n,nColAtu]+nTotCal + nIncen + nFunRur),3)
    //aCols[n,nCLPrCust]  := Round(( ( (aCols[n,nColAtu]+nTotCal) - nFunRur) + aCols[n,nCLFrete]),6)
    //aCols[n,nCLPrFim]   := Round((aCols[n,nColAtu]+nTotCal ),3)

    oPrcLeite:aCols[n,nCLPrCust]  :=  (oPrcLeite:aCols[n,nColAtu] + nTotCal) - nFunRur + oPrcLeite:aCols[n,nCLFrete]

    oPrcLeite:aCols[n,nCLPrFim]   := Round(oPrcLeite:aCols[n,nColAtu]+nTotCal,3)
    oPrcLeite:aCols[n,nCLPrDif]   := oPrcLeite:aCols[n,nCLPrFim] - oPrcLeite:aCols[n,nCLPrcAnt]




    If nPrcCal == 0
        oPrcLeite:aCols[n][nColInc] := nIncen   := Round( ( ( ( oPrcLeite:aCols[n,nCLPrFim] ) * nIncen(  oPrcLeite:aCols[n][1]) ) / 100 ),6 )
        oPrcLeite:aCols[n][nColFun] := nFunRur	:= -Round( ( ( ( oPrcLeite:aCols[n,nCLPrFim] ) * nFunRur( oPrcLeite:aCols[n][1]) ) / 100 ),6 )
    End If

    For _aAlter := 1 To Len(aAlter)
		If ( cCampo == "M->"+AllTrim(aAlter[_aAlter]) )
        	If LJZ->(dbSeek(xFilial("LJZ")+DTOS(MV_PAR01)+AllTrim(oPrcLeite:aCols[n,1])+SubStr(cCampo,8,6)))
				LJZ->( RecLock("LJZ",.F.) )
                    LJZ->LJZ_RESLEI := oPrcLeite:aCols[n,nColAtu]
                    LJZ->LJZ_RECALC := IIF(oPrcLeite:aCols[n,nColAtu]==0,'','S')
                LJZ->( MsUnlock() )
			End If
		EndIf
	Next _aAlter

    oPrcleite:oBrowse:GoColumn(nColOri)

Return .T.

/*/{Protheus.doc} QA22Linha
Atualiza campos no cabecalho
@type function
@version
@author Wilson Davila
@since 14/07/2020
/*/
User Function QA22Linha(oPrcleite)

    //cProdutor   := oPrcleite:aCols[n][1]+"-"+oPrcleite:aCols[n][2]
    //nPrAnt      := oPrcleite:aCols[n][nCLPrFim]
    //cFam        := oPrcleite:aCols[n][nCLTpFam]
    xCodPro     := oPrcleite:aCols[n][1]
    //oPrcLeite:oBrowse:SetBlkBackColor({|| GETDCLR(n,8421376,oPrcleite:aCols[n][1])})
    //oPrcleite:oBrowse:DrawSelect()
    //oProdutor:Refresh()
    //oPrAnt:Refresh()
    //oFam:Refresh()
    oPrcleite:oBrowse:GoColumn(nColOri)
    oPrcleite:Refresh()

Return .T.


User Function QA22Col(oPrcleite)

    //cProdutor   := oPrcleite:aCols[n][1]+"-"+oPrcleite:aCols[n][2]
    //nPrAnt      := oPrcleite:aCols[n][nCLPrFim]
    //cFam        := oPrcleite:aCols[n][nCLTpFam]
    //xCodPro     := oPrcleite:aCols[n][1]
    //oPrcLeite:oBrowse:SetBlkBackColor({|| GETDCLR(n,8421376,oPrcleite:aCols[n][1])})
    //oPrcleite:oBrowse:DrawSelect()
    //oProdutor:Refresh()
    //oPrAnt:Refresh()
    //oFam:Refresh()
    //oPrcleite:GoTo(oPrcLeite:nAt+1)
    //oPrcleite:oBrowse:GoColumn(nColOri)
    //oPrcleite:oBrowse:DrawSelect()
    //oPrcleite:Refresh()

Return .T.

/*/{Protheus.doc} RetLitCar
Calcula frete paga para o carreteiro
@type function
@version
@author Wilson Davila
@since 15/07/2020
/*/
Static Function AjuLitCar()

	Local cAlias := 'QUAR22CA'

	PA3->(dbSetOrder(2))
	If PA3->( dbSeek(xFilial("PA3")+StrZero(month(MV_PAR01),2)+cValToChar(year(MV_PAR01))))

        While PA3->( !Eof()) .AND. PA3->(PA3_FILIAL)+PA3->(PA3_PERIOD) == xFilial("PA3")+StrZero(month(MV_PAR01),2)+cValToChar(year(MV_PAR01))

            BeginSql Alias cAlias

        		%noparser%

        		SELECT SUM(PC1_QTDLIT) AS PC1_QTDLIT
        		FROM %table:PC1%  PC1
        		INNER JOIN %table:PC0% PC0 ON PC0_FILIAL=PC1_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC0.%notDel%
        		AND MONTH(PC0_DTENTR)=%Exp:Month(MV_PAR01)% AND YEAR(PC0_DTENTR)=%Exp:Year(MV_PAR01)%
        		AND PC0_TPENTR='1'
        		WHERE PC1_LINHA=%exp:PA3->(PA3_CODCAM)% AND PC1_FILIAL=%EXP:cFilAnt% AND PC1.%notDel%

        	EndSql

        	If  (cAlias)->(  !Eof() )
                PA3->(RecLock("PA3",.F.))
                    PA3->PA3_QTDLIT := (cAlias)->(PC1_QTDLIT)
                PA3->(MsUnlock())
            EndIf

        	(CALIAS)->( dbCloseArea())

            PA3->(dbSkip())

        EndDo

    EndIf

Return

/*/{Protheus.doc} xBusca
Funcao para busca no Acols
@type function
@version
@author Wilson Davila
@since 21/07/2020
/*/
Static Function xBusca()

    GdSeek( oPrcLeite ,"Busca",,.T.)

Return

/*/{Protheus.doc} CorFundo
description
@type function
@version
@author Wilson Davila
@since 27/07/2020
@param nLinha, numeric, param_description
@param nCor, numeric, param_description
@return return_type, return_description
/*/
Static Function CorFundo(nLinha,nCor)

    Local nRet := 16777215

    If (oPrcLeite:aCols[nLinha,nCLCodPro]==xCodPro)   //se na coluna 2 tiver o conteudo informado pinte de outra cor
        nRet := CLR_BROWN
    ElseIf Subst(oPrcLeite:aCols[nLinha,nCLTpFam ],1,2) == 'PA'
        nRet := CLR_HGREEN
    Else
        nRet := 16777215
    Endif

Return nRet

/*/{Protheus.doc} CorLinha
description
@type function
@version
@author Wilson Davila
@since 27/07/2020
@param nLinha, numeric, param_description
@param nCor, numeric, param_description
@return return_type, return_description
/*/
Static Function CorFonte(nLinha,nCor)

    Local nRet := 16777215

    If (oPrcLeite:aCols[nLinha,nCLCodPro]==xCodPro) //se na coluna 2 tiver o conteudo informado pinte de outra cor
        nRet := CLR_WHITE
    Else
        nRet := CLR_BLACK
    Endif

Return nRet


Static Function ProcPreco()
Local _nPreco := 0
If MsgYesNo(OemToAnsi("Deseja gravar preço para fechamento?"))


    ProcRegua(Len(oPrcLeite:aCols))
    For i := 1 To Len(oPrcLeite:aCols)
        _nPreco := oPrcLeite:aCols[i][nCLPrFim] - oPrcLeite:aCols[i][nCLIncen] - oPrcLeite:aCols[i][nCLFunRur]
        IncProc("Processando Produtor > " + oPrcLeite:aCols[i][nCLCodPro]+"-"+oPrcLeite:aCols[i][nCLNomPro])
        AtualPRC(Round(_nPreco,3),oPrcLeite:aCols[i][nCLCodPro] )
    Next i

EndIf

Return


Static Function AtualPRC( _nPreco, _cCodPro )

Local dDataFim 	:= dTFechto
Local dDataIni 	:= FirstDate(dTFechto)
LOcal nQtdDia	:= (dDataFim - dDataIni) + 1
Local _cQuery	:= ""

_cQuery 	:= "SELECT PC0.R_E_C_N_O_ as PC0NUM, PC1.R_E_C_N_O_ as PC1NUM, PC2.R_E_C_N_O_ as PC2NUM "
_cQuery 	+= "FROM " + RetSqlName("PC0") + " PC0 INNER JOIN " + RetSqlName("PC1") + " PC1 ON "
_cQuery 	+= "PC1_FILIAL = PC0_FILIAL AND PC1_NUMSEQ = PC0_NUMSEQ AND PC1.D_E_L_E_T_ = ' ' "
_cQuery 	+= "INNER JOIN " + RetSqlName("PA7") + " PA7 ON "
_cQuery 	+= "PA7_FILIAL = '"+xFilial("PA7")+"' AND PA7_CODLIN = PC1_LINHA AND PA7.D_E_L_E_T_ = ' ' "
_cQuery 	+= "INNER JOIN " + RetSqlName("PC2") + " PC2 ON "
_cQuery 	+= "PC2_FILIAL = PC0_FILIAL AND PC2_NUMSEQ = PC0_NUMSEQ AND PC2.D_E_L_E_T_ = ' ' "
_cQuery 	+= "INNER JOIN " + RetSqlName("LBC") + " LBC ON "
_cQuery 	+= "LBC_FILIAL = '"+xFilial("LBC")+"' AND LBC_CODROT = PC2_ROTA AND LBC.D_E_L_E_T_ = ' ' "
_cQuery 	+= "WHERE PC0_FILIAL = '" + xFilial("PC0") + "' "
_cQuery 	+= "AND PC0_DTENTR >= '" + dTos(dDataIni) + "' "
_cQuery 	+= "AND PC0_DTENTR <= '" + dTos(dDataFim) + "' "
_cQuery 	+= "AND PC1_CODPRO = '" + _cCodPro + "' "
_cQuery 	+= "AND PC0.PC0_TPENTR = '1' "
_cQuery 	+= "AND PC0.D_E_L_E_T_ = ' ' "
_cQuery 	+= "AND PC0.D_E_L_E_T_ = ' ' "

If Select("QRY") > 0
	dbSelectArea("QRY")
	dbCloseArea()
Endif
_cQuery := ChangeQuery(_cQuery)

memowrit("C:\HD\wm004b.sql", _cQuery)

DbUseArea(.T.,'TOPCONN',TCGENQRY(,,_cQuery),"QRY",.T.,.T.)

tcSetField("QRY", "PC0NUM", "N", 10, 0 )
tcSetField("QRY", "PC1NUM", "N", 10, 0 )
tcSetField("QRY", "PC2NUM", "N", 10, 0 )

If QRY->(!EOF())

	While QRY->(!EOF())
		//IncProc("Processando...")
		PC1->(dbGoTo(QRY->PC1NUM))
		RecLock("PC1",.F.)
		PC1->PC1_VLRLIT := _nPreco
		PC1->(MSUnlock())
		PC2->(dbGoTo(QRY->PC2NUM))
		RecLock("PC2",.F.)
		PC2->PC2_VLRLIT := _nPreco
		PC2->(MSUnlock())
		QRY->(DbSkip())
	EndDo
//	MsgInfo("Preços atualizados com sucesso.")

Else
	Alert("Não existem registros para atualização do Preço do Leite.")
EndIf
QRY->( dbCloseArea() )

Return Nil

/*/{Protheus.doc} xCalculo
description
@type function
@version
@author wilso
@since 01/09/2020
@return return_type, return_description
/*/
Static Function xCalculo(cCodBon,cCodPro)

Local cAlias    := "QUAA22C"
Local aRet      := {}
Local nMeses    := 0

    If month(dTFechto) == 1
            cMes  := '12'
            cMes1 := '11'
            cMes2 := '10'
            cAno  := cValToChar(year(dTFechto)-1)
            cAno1  := cValToChar(year(dTFechto)-1)
            cAno2  := cValToChar(year(dTFechto)-1)
        ElseIf month(dTFechto) == 2
            cMes  := '1'
            cMes1 := '12'
            cMes2 := '11'
            cAno  := cValToChar(year(dTFechto))
            cAno1  := cValToChar(year(dTFechto)-1)
            cAno2  := cValToChar(year(dTFechto)-1)
        ElseIf month(dTFechto) == 3
            cMes  := '2'
            cMes1 := '1'
            cMes2 := '12'
            cAno  := cValToChar(year(dTFechto))
            cAno1  := cValToChar(year(dTFechto))
            cAno2  := cValToChar(year(dTFechto)-1)
        Else
            cMes  := cValToChar(month(dTFechto)-1)
            cMes1 := cValToChar(month(dTFechto)-2)
            cMes2 := cValToChar(month(dTFechto)-3)
            cAno  := cValToChar(year(dTFechto))
            cAno1  := cValToChar(year(dTFechto))
            cAno2  := cValToChar(year(dTFechto))
        EndIf

    BeginSql Alias cAlias

		%noparser%

        SELECT LJZ_DATCLQ,LJZ_QTDMES FROM %table:LJZ% LJZ
        WHERE LJZ_CODBON=%Exp:cCodBon%
        AND RTRIM(LTRIM(STR(MONTH(LJZ_DATCLQ))))+LTRIM(RTRIM(STR(YEAR(LJZ_DATCLQ)))) IN (%Exp:cMes+cAno%,%Exp:cMes1+cAno1%,%Exp:cMes2+cAno2%)
        AND LJZ_CODPRO=%Exp:cCodPro%
        AND LJZ.%notDel%
        ORDER BY LJZ_DATCLQ

	EndSql

	While (cAlias)->(  !Eof() )

        If (cAlias)->(LJZ_QTDMES) > 0
            AADD(aRet,{(cAlias)->(LJZ_QTDMES)})
        EndIf

        (cAlias)->( dbSkip() )

    EndDo

	(cAlias)->( dbCloseArea())

Return aRet

/*/{Protheus.doc} GetAdcVol
Calcula adicional de mercado para produtores sem valor fixado pela diferenca do preco medio x Realizado
@type function
@version
@author Wilson Davila
@since 06/07/2020
/*/
Static Function GetAdcVol(oPrcLeite)

    Local nPrcCal   := 0
	Local n         := 1
    Local nPrAtu    := oPrcLeite:aCols[n,nCLPrFim]
    Local nFunRur   := 0
    Local nTotCal   := 0
    Local nColAtu   := 0
    Local nColInc   := 0
    Local nColFun   := 0
    Local nPrcus    := 0
    Local xTotCus   := 0
    Local nLitros   := 0
    Local _acl      := 0
    Local b         := 0
    Local _a        := 0
    Local _aAlter   := 0

    ZeraAdc(oPrcLeite,.F.)

    LJZ->(dbSetOrder(5))

    ProcRegua(Len(oPrcLeite:aCols))

    For _a := 1 To 1

        xTotCus     := 0
        nMediaFixa  := 0
        nMediaVar   := 0
        nPrFilAju   := 0
        nDifMdFix   := 0
        nLinFix     := 0
        nLinVar     := 0
        nDifMedPr   := 0
        nPrFimCal   := 0
        nTemFixo    := 0
        nLitros     := 0
        nLitTot     := 0
        nCusMeta    := 0
        nCusFixo    := 0
        nCusVar     := 0
        nCusAtu     := 0
        nDifCus     := 0
        nIndPro     := 0
        nLitPar     := 0
        nCusPar     := 0

        For _acl := 1 To Len(oPrcLeite:aCols)

            nTemFixo += oPrcLeite:aCols[_acl][nColOri]

            nLitTot += oPrcLeite:aCols[_acl][nCLLitros]
            nCusAtu += oPrcLeite:aCols[_acl][nCLLitros] *  oPrcLeite:aCols[_acl][nCLPrCust]
            If oPrcLeite:aCols[_acl][nColOri] > 0
                nCusPar += oPrcLeite:aCols[_acl][nCLLitros] *  oPrcLeite:aCols[_acl][nCLPrCust]
                nLitPar += oPrcLeite:aCols[_acl][nCLLitros]
            EndIf

        Next _acl

        nCusMeta    := nPrMdFl * nLitTot

        If nTemFixo > 0
            nDifCus := (nCusMeta-nCusAtu)/(nLitTot-nLitPar)
        Else
            nDifCus     := (nCusMeta-nCusAtu)/nLitTot
        EndIf

        nNovoCus := 0

        For _acl := 1 To Len(oPrcLeite:aCols)
                nCusAtu     := oPrcLeite:aCols[_acl][nCLLitros] * oPrcLeite:aCols[_acl][nCLPrCust]
                nCusMet     := oPrcLeite:aCols[_acl][nCLLitros] * nDifCus
                nIndLit     := (oPrcLeite:aCols[_acl][nCLLitros]/nLitTot)/100
                nPrNvCus    := (nDifCus*nIndLit)+nDifCus
                If oPrcLeite:aCols[_acl][nColOri] == 0
                    nNovoCus    += nCusAtu+(nPrNvCus*oPrcLeite:aCols[_acl][nCLLitros])
                Else
                    nNovoCus    += oPrcLeite:aCols[_acl][nCLLitros]*(oPrcLeite:aCols[n][nCLPrCust])
                EndIf
        Next _acl


        For n := 1 To Len(oPrcLeite:aCols)

            IncProc("Processando Produtor > " + AllTrim(oPrcLeite:aCols[n][1])+"-"+Alltrim(oPrcLeite:aCols[n][2]))

            nTotCal := 0

            If _a == 1
                If oPrcLeite:aCols[n][nColOri] > 0
                    Loop
                EndIf
            Else
                If LJZ->(dbSeek(xFilial("LJZ")+DTOS(MV_PAR01)+AllTrim(oPrcLeite:aCols[n,1])+'000009'))
                    If LJZ->(LJZ_RECALC) == 'S'
                        Loop
                    End If
                EndIf
            EndIf

            nTotal := 0

            nPrAtu := oPrcLeite:aCols[n,nCLPrFim]
            nPrcus := oPrcLeite:aCols[n,nCLPrCust]

            If _a == 1
                oPrcLeite:aCols[n,nCLPrFim] := nPrBase
            EndIf

            //LJZ_FILIAL+DTOS(LJZ_DATCLQ)+LJZ_CODPRO+LJZ_CODBON
            LJZ->(dbSetOrder(5))

        	For b := 1 To Len(aHead)

        		If      AllTrim(aHead[b][2]) == "F1_XINCEN"
                        nColInc := b
                ElseIf  AllTrim(aHead[b][2]) == "F1_XINSS"
                        nColFun := b
                EndIf

                If "M->"+AllTrim(aHead[b][2]) == "M->LJZ_000009"
                    nPrcCal := (oPrcLeite:aCols[n][nCLPrCust] + nDifCus)
                    nColAtu := b
                    If nPrcCal == 0
                        oPrcLeite:aCols[n,b] := 0
                    EndIf
                Else
                    If aHead[b][14] == 'S'
                        nTotCal += iif("M->"+AllTrim(aHead[b][2]) == "M->LJZ_000009",nPrcCal,oPrcLeite:aCols[n,b])
                    EndIf
                End If

        	Next b

            nCusAtu     := oPrcLeite:aCols[n][nCLLitros] * oPrcLeite:aCols[n][nCLPrCust]
            nCusMet     := oPrcLeite:aCols[n][nCLLitros] * nDifCus
            nIndLit     := (oPrcLeite:aCols[n][nCLLitros]/nLitTot)/100
            nPrNvCus    := (nDifCus*nIndLit)+nDifCus
            nNovoCus    := nCusAtu+(nPrNvCus*oPrcLeite:aCols[n][nCLLitros])
            nPrNvCus    := nNovoCus / oPrcLeite:aCols[n][nCLLitros]
            nCusSfrt    := nPrNvCus - oPrcLeite:aCols[n][nCLfrete]
            nNvPrFim    := nCusSfrt-((nCusSfrt*nPerFun)/100)
            xAdcMer     := nNvPrFim - nPrAtu
            nPrcCal     := nNvPrFim

            nFunRur	          :=  ( ( (nPrcCal) * nFunRur( oPrcLeite:aCols[n][1]) ) / 100 )
            oPrcLeite:aCols[n][nColFun] := nFunRur := -( ( ( (nFunRur) * nFunRur( oPrcLeite:aCols[n][1]) ) / 100 ) + nFunRur)
            oPrcLeite:aCols[n][nColInc] := ( ( (nPrcCal-nFunRur) * nIncen(oPrcLeite:aCols[n][1]) ) / 100 )
            oPrcLeite:aCols[n][nColInc] := oPrcLeite:aCols[n][nColInc] - ( ( oPrcLeite:aCols[n][nColInc]  *  nIncen(oPrcLeite:aCols[n][1]) ) / 100  )

            If nPrcCal > 0
                oPrcLeite:aCols[n,nColAtu]    := xAdcMer
            Else
                oPrcLeite:aCols[n,nColAtu]    := 0
            EndIf

            oPrcLeite:aCols[n,nCLPrCust]  :=  (oPrcLeite:aCols[n,nColAtu] + nTotCal) - nFunRur + oPrcLeite:aCols[n,nCLFrete]

            oPrcLeite:aCols[n,nCLPrFim]   := Round(oPrcLeite:aCols[n,nColAtu]+nTotCal,3)
            oPrcLeite:aCols[n,nCLPrDif]   := oPrcLeite:aCols[n,nCLPrFim] - oPrcLeite:aCols[n,nCLPrcAnt]

            For _aAlter := 1 To Len(aAlter)
        		If ( "M->LJZ_000009" == "M->"+AllTrim(aAlter[_aAlter]) )
                	If LJZ->(dbSeek(xFilial("LJZ")+DTOS(MV_PAR01)+AllTrim(oPrcLeite:aCols[n,1])+"000009"))
        				LJZ->( RecLock("LJZ",.F.) )
                            LJZ->LJZ_RESLEI := oPrcLeite:aCols[n,nColAtu]
        				LJZ->( MsUnlock() )
        			End If
        		EndIf
        	Next _aAlter

        Next n

        oPrcLeite:Refresh()

        nLitros := 0
        nTotal  := 0

        For _acl := 1 To Len(oPrcLeite:aCols)
            nLitros += oPrcLeite:aCols[_acl][nCLLitros]
            nTotal += oPrcLeite:aCols[_acl][nCLLitros] * oPrcLeite:aCols[_acl][nCLPrCust]
        Next _acl

        nTotal := nTotal/nLitros

    	nPrReal := Round(nTotal,3)

        oPrReal:Refresh()
    	oPrcLeite:Refresh()

    Next _a

    MsgInfo("Recalculo de preco efetuado!")

Return

Static Function RclBnToT()

	Local cTipoBon		:= ' '
	LOcal cTipoCal      := '' //1=Mensal;2=Aritmetica;3=Geometrica
    Local nResLei 		:= 0
	Local nLitros		:= 0
	Local nDistan   	:= 0
	Local nSoma         := 0
    Local nSoma1        := 0
    Local nSoma2        := 0
    Local dData 		:= dtos(MV_PAR01)
	Local nItem         := 0
    Local dDtAtu        := MV_PAR01
    Private cAliasQry  	:= GetNextAlias()

	DbSelectArea("LJZ") //Historico da classificacao da Qualidade do leite
	DbSetOrder(6)

    ProcRegua(100)
    IncProc("Recalc. Bonif." + AllTrim(LJZ->LJZ_CODPRO)+"-"+Alltrim(LJZ->LJZ_DESBON)+" "+DTOC(LJZ->LJZ_DATCLQ))

    //If dbSeek( xFilial("LJZ") + dData)

        DBGOTOP()

        While !Eof() .AND. xFilial("LJZ") == LJZ->LJZ_FILIAL //.AND. LJZ->LJZ_DATCLQ == stod(dData)
            //Tipo Bom
			// 1-PLANILHA-> Sera usada planilha para entrar com dados no sistema,
			// 2-VOLUME->Sera usado o volume captado pelo produtor no sistema para calculo,
			// 3-DISTANCIA->Sera usado o campo distancia do produtor ate o laticinio do cadastro de propriedades,
			// 4-DIGITADO->No caso de adicional de Mercado para composicao do preco no simulador.

            // Tipo Calculo
            //1=Mensal;2=Aritmetica;3=Geometrica
            IncProc("Recalc. Bonif." + AllTrim(LJZ->LJZ_CODPRO)+"-"+Alltrim(LJZ->LJZ_DESBON)+" "+DTOC(LJZ->LJZ_DATCLQ))

            LJZArea := GetArea()
            MV_PAR01 := LJZ->LJZ_DATCLQ
            dTFechto := MV_PAR01

			cTipoBon := LJZ->LJZ_TPBON
            cTipoCal := LJZ->LJZ_METCLA

            LJX->( dbSetOrder(1) )

            If LJX->( dbSeek(cFilAnt+LJZ->(LJZ_CODBON)))
                nArred := LJX->(LJX_ARRED)
            EndIf

				If cTipoBon  ==  '2'  // VOLUME
                //IncProc("Recalc. Bonif." + AllTrim(LJZ->LJZ_CODPRO)+"-"+Alltrim(LJZ->LJZ_DESBON))
				nLitrosAtu 	:= LJZ->LJZ_QTDLEI
				nLitros     := U_RetLitros(LJZ->LJZ_CODPRO)

					aRet    := U_QuaCAL21(Alltrim(LJZ->(LJZ_CODBON)),,nLitros)
                    nResLei := aRet[1][1]
                    nFxINI  := aRet[1][2]
                    nFxFIM  := aRet[1][3]
                    nItem   := aRet[1][4]

			ElseIf cTipoBon  ==  '3' // DISTANCIA

			    nDistan	   := Posicione("LBB",1,XFILIAL("LBB")+LJZ->LJZ_CODPRO,"LBB_DISTAN")

					aRet    := U_QuaCAL21(Alltrim(LJZ->(LJZ_CODBON)),,nDistan)
                    nResLei := aRet[1][1]
                    nFxINI  := aRet[1][2]
                    nFxFIM  := aRet[1][3]
                    nItem   := aRet[1][4]

            EndiF

            If !cTipoBon $ '2|3' .AND. cTipoCal == '1' //mensal

                aRet    := U_QuaCAL21(Alltrim(LJZ->(LJZ_CODBON)),,LJZ->(LJZ_QTDMES))
                nSoma   := LJZ->(LJZ_QTDMES)
                nResLei := aRet[1][1]
                nFxINI  := aRet[1][2]
                nFxFIM  := aRet[1][3]
                nItem   := aRet[1][4]

            ElseIf !cTipoBon $ '2|3' .AND. cTipoCal == '2' //aritmetica

                aRes := xCalculo(LJZ->(LJZ_CODBON),LJZ->(LJZ_CODPRO))
                nSoma1 := 0

                For i := 1 To Len(aRes)
                    nSoma1 += aRes[i][1]
                Next i

                If nSoma1 > 0
                    nSoma1 := ( nSoma1 / Len(aRes) )
                Else
                    nSoma1 := LJZ->(LJZ_QTDMES)
                EndIf

                aRet    := U_QuaCAL21(Alltrim(LJZ->(LJZ_CODBON)),,Round(nSoma1,nArred))
                nResLei := aRet[1][1]
                nFxINI  := aRet[1][2]
                nFxFIM  := aRet[1][3]
                nItem   := aRet[1][4]

            ElseIf !cTipoBon $ '2|3' .AND. cTipoCal == '3' //geometrica

                aRes := xCalculo(LJZ->(LJZ_CODBON),LJZ->(LJZ_CODPRO))
                nSoma2 := 0

                For i := 1 To Len(aRes)
                    If i == 1
                        nSoma2 := aRes[i][1]
                    Else
                        nSoma2 := ( nSoma2 * aRes[i][1] )
                    EndIf
                Next i

                If nSoma2 > 0
                    nSoma2 := ( nSoma2 ^ ( 1/Len(aRes) ) )
                Else
                    nSoma2 := LJZ->(LJZ_QTDMES)
                EndIf

                aRet    := U_QuaCAL21(Alltrim(LJZ->(LJZ_CODBON)),,Round(nSoma2,nArred))
                nResLei := aRet[1][1]
                nFxINI  := aRet[1][2]
                nFxFIM  := aRet[1][3]
                nItem   := aRet[1][4]

            EndIf

			RestArea(LJZArea)

            If   cTipoBon $ '2|3'
				RecLock("LJZ",.F.)
					LJZ->LJZ_RESLEI	:= nResLei
					LJZ->LJZ_QTDLEI := nLitros+nDistan
                    LJZ->LJZ_RESMES	:= nResLei
					LJZ->LJZ_QTDMES := nLitros+nDistan
                    LJZ->LJZ_VINIC  := nFxINI
                    LJZ->LJZ_VFINAL := nFxFIM
                    LJZ->LJZ_ITEM   := nItem
                MsUnlock()
			ElseIf !cTipoBon $ '4'
                RecLock("LJZ",.F.)
					LJZ->LJZ_QTDLEI := nSoma+nSoma1+nSoma2
                    LJZ->LJZ_RESLEI	:= nResLei
					LJZ->LJZ_VINIC  := nFxINI
                    LJZ->LJZ_VFINAL := nFxFIM
                    LJZ->LJZ_ITEM   := nItem
                MsUnlock()
            EndIf

			nSoma   := 0
            nSoma1  := 0
            nSoma2  := 0
            nLitros := 0
			nDistan := 0
			nResLei := 0
	        nFxINI  := 0
            nFxFIM  := 0
            nItem   := 0
			dbSkip()

		EndDo

    //End If

MV_PAR01 := dDtAtu
dTFechto := MV_PAR01

Return
