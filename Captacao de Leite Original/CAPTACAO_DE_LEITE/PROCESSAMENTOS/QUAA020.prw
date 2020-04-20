#INCLUDE "QUAA020.ch"
#include "Protheus.ch"
#include "TopConn.ch"
#include "TbiConn.ch"
#include "Error.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ QUAA020  ³ Autor ³ Microsiga             ³ Data ³ 20/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Entrada do Leite                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Controle de entradas de leite                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QUAA020()

//Variaveis privadas usadas no modelo 3
	Private AROTINA
	Private CCADASTRO  := OemToAnsi("Entrada do Leite")
	Private CALIAS     := "PC0"
	Private CALIASLIN  := "PC1"
	Private CALIASROT  := "PC2"
	Private CFILALIAS  := xFilial(CALIAS)
	Private CFILLIN    := xFilial(CALIASLIN)
	Private CFILROT    := xFilial(CALIASROT)
	Private NOPCE
	Private NOPCG
	Private CTITULO    := OemToAnsi("Manutencao Entrada do Leite")
	Private NREG
	Private NOPC
	Private ACPOENCHOICE
	Private aSize    	:= {}
	Private aObjects 	:= {}
	Private aInfo    	:= {}
	Private aPosObj  	:= {}
	Private oLbx1
	Private aVetor1 := {}        //vetor lixtbox linha
	Private oLbx2
	Private aVetor2 := {}        //vetor listbox rota
	Private oTotMedLin
	Private nTotMedLin  := 0     //total medido linha
	Private oTotApoLin
	Private nTotApoLin  := 0     //total apontado linha
	Private oTotDifLin
	Private nTotDifLin  := 0     //total diferenca linha
	Private oTotMedRot
	Private nTotMedRot  := 0     //total medido rota
	Private oTotApoRot
	Private nTotApoRot  := 0     //total apontado rota
	Private oTotDifRot
	Private nTotDifRot  := 0     //diferenca rota
	Private oTotApo
	Private cTotApo     := 0    //total apontado - tela de detalhes linha e rota
	Private oNumSeq
	Private oDtEntr
	Private oFnt1
	Private oFld
	Private wVar
	Private cNomTMP0            //armazena nome da tabela temporaria equivalente a PC0
	Private cNomTMP1            //armazena nome da tabela temporaria equivalente a PC1
	Private cNomTMP2            //armazena nome da tabela temporaria equivalente a PC2
	Private oGetDad1
	Private oGetDad2
	Private aHeader1 := {}
	Private aHeader2 := {}
	Private aHeader  := {}
	Private aCOLS1   := {}
	Private aCOLS2   := {}
	Private aCOLS    := {}
	Private lManut   := .F.
	Private aRecDel1 := {}
	Private aRecDel2 := {}
	Private aRecInc  := {}
	Private lMSErroAuto := .F.
	Private lMsHelpAuto := .T.
	Private cFiltro		:= ""
	Private bFiltraBrw	:= {|| }
	Private aIndexPC0	:= {}

	nOpc:=0

	aRotina := {{ OemToAnsi("Pesquisar")   	,"axPesqui"			, 0 , 1},;
		{ OemToAnsi("Receb.SMARTQ")	,'U_ColetaSQ()'		, 0 , 2 },;
		{ OemToAnsi("Receb. Mod1")	,'U_Qua20Mod1(1)'	, 0 , 3	},;
		{ OemToAnsi("Exclui Mod1")	,'U_Qua20Mod1(2)'	, 0 , 5	},;
		{ OemToAnsi("Receb. Mod2")	,'U_Qua020Man(1)'	, 0 , 3	},;
		{ OemToAnsi("Detalhes")  	,'U_Qua020Man(2)' 	, 0 , 4}}

	DbSelectArea("PC0")
	DbSetOrder(1)

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carregando Filtro de BROWSE                                  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	cFiltro	:="@PC0_FILIAL = '"+xFilial("PC0") + "' "
	bFiltraBrw	:= { || FilBrowse( "PC0" , @aIndexPC0 , @cFiltro ) }
	Eval( bFiltraBrw )


	mBrowse( 6, 1,22,75,"PC0")

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Retirando Filtro do Browse                                   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
EndFilBrw( "PC0" , aIndexPC0 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Qua20Mod1 ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao manutencao da entrada de leite na plataforma        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Qua20Mod1(cAcao,nRecNo)

	Local bCampo
	Local oDlg
	Local oTPane1
	Local oNumSeq
	Local oDtEntr
	Local oRota
	Local oDesc
	Local cDesc   := ""
	Local oQtdMed
	Local nOpcA   := 0

	If cAcao == 1
		INCLUI := .T.
		nOpc := 3
		bCampo  := {|nField| FieldName(nField) }
	ElseIf cAcao == 2
		INCLUI := .F.
		ALTERA := .F.
		VISUAL := .T.
		nOpc := 5
		bCampo  := { |nField| Field(nField) }
	EndIf

//+--------------------------------------
//| Cria Variaveis de Memoria da Enchoice
//+--------------------------------------
	dbSelectArea("PC0")
	For nX:= 1 To FCount()
		If nOpc == 3
			M->&(Eval(bCampo,nX)) := CriaVar(FieldName(nX),.T.)
		ElseIf nOpc == 5
			M->&(Eval(bCampo,nX)) := FieldGet(nX)
		EndIf
	Next nX

//-----------------------------
// Valida exclusao
//-----------------------------
	If cAcao == 2
		DbSelectArea("PC1")
		DbSetOrder(1)
		If DbSeek( xFilial("PC1") + M->PC0_NUMSEQ )
			MsgAlert("Opção inválida. Não é possível excluir registros que possuem amarração.")
			Return
		EndIf

		DbSelectArea("PC2")
		DbSetOrder(1)
		If DbSeek( xFilial("PC2") + M->PC0_NUMSEQ )
			MsgAlert("Opção inválida. Não é possível excluir registros que possuem amarração.")
			Return
		EndIf
	EndIf

	If nOpc == 3
		M->PC0_NUMSEQ := GetSx8Num("PC0","PC0_NUMSEQ")
		M->PC0_DTENTR := dDataBase
	EndIf

	DEFINE MSDIALOG oDlg TITLE "Recebimento Plataforma" From 9,0 to 20,70	of oDlg
    
	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,60,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP

	@ 005,004 SAY OemToAnsi("Num. Entrada") OF oTPane1 PIXEL COLOR CLR_BLUE
	@ 004,040 MSGET oNumSeq VAR M->PC0_NUMSEQ PICTURE "@!" SIZE 40,4 OF oTPane1 PIXEL COLOR CLR_BLACK when .f.
	
	@ 005,090 SAY OemToAnsi("Data Entrada") OF oTPane1 PIXEL COLOR CLR_BLUE
	@ 004,125 MSGET oDtEntr VAR M->PC0_DTENTR PICTURE "@!" VALID NaoVazio() SIZE 40,4 OF oTPane1 PIXEL COLOR CLR_BLACK when nOpc == 3
	
	@ 022,004 SAY OemToAnsi("Num. Rota") OF oTPane1 PIXEL COLOR CLR_BLUE
	@ 021,040 MSGET oRota VAR M->PC0_LINROT PICTURE "@!" F3 "LBC" VALID ExistCpo("LBC") .And. NaoVazio() .And. FRetDes(M->PC0_LINROT) SIZE 35,4 OF oTPane1 PIXEL COLOR CLR_BLACK when nOpc == 3

	@ 022,090 SAY OemToAnsi("Descricao") OF oTPane1 PIXEL COLOR CLR_BLACK
	@ 021,125 MSGET oDesc VAR M->PC0_DESCRI PICTURE "@!" SIZE 140,4 OF oTPane1 PIXEL COLOR CLR_BLACK when .f.

	@ 039,004 SAY OemToAnsi("Qtd.Med.") OF oTPane1 PIXEL COLOR CLR_BLUE
	@ 038,040 MSGET oQtdMed VAR M->PC0_QTDMED PICTURE "@E 99,999,999" Valid NaoVazio() SIZE 60,4 OF oTPane1 PIXEL COLOR CLR_BLACK when nOpc == 3

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(FValCpo(),oDlg:End(),nOpcA:=0)},{||oDlg:End()}) CENTERED

	If nOpcA == 1
//	Begin Transaction
		GrvMod1()
		EvalTrigger()
		If __lSX8
			ConfirmSX8()
		Endif
	//End Transaction
	Else
		If __lSX8
			RollBackSX8()
		Endif
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Qua020Man ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Manutencao da entrada de leite                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Qua020Man(cAcao)

	Local nI, nCntFor
	Local cCposRestr 	:= "PC0_FILIAL/PC0_TPENTR/PC0_LINROT/PC0_DESCRI/PC0_QTDAPO/PC0_QTDMED/PC0_QTDDIF"
	Local bCampo   		:= { |nCPO| Field(nCPO) }
	Local oTPane1
	Local oTPane2
	Local oTPane3
	Local oDlg
	Local nOpcA         := 0

	DEFINE FONT oFnt1 NAME "TIMES NEW ROMAN" SIZE 08,17 BOLD

//zera vetor de controle do recno PC1 e PC2
	aRecDel1  := {}
	aRecDel2  := {}
	aRecInc   := {}

//Monta vetores dos folders
	MontVet(cAcao)

//Cria tabelas temporarias (TMP0,TMP1 e TMP2)
	CriaTmp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis M->????? da Enchoice                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCpoEnchoice  :={}
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAlias)
	While !Eof().and.(x3_arquivo==cAlias)
		If X3USO(x3_usado) .and. !Alltrim(X3_Campo) $ cCposRestr
			AADD(aCpoEnchoice,x3_campo)
		Endif
		wVar := "M->"+x3_campo
		&wVar:= CriaVar(x3_campo)
		dbSkip()
	End

	If cAcao = 2 // manutencao
		dbSelectArea(cAlias)
		For nCntFor := 1 TO FCount()
			M->&(EVAL(bCampo,nCntFor)) := FieldGet(nCntFor)
		Next nCntFor
	Else //incluir
		M->PC0_NUMSEQ := GetSx8Num("PC0","PC0_NUMSEQ")
		M->PC0_DTENTR := dDataBase
	Endif

	if cAcao == 1 // Incluir
		nOpcE := 3
	elseif cAcao == 2 // Manutencao
		nOpcE := 2
	endif

//--------------------------
//Alimenta tabela temporaria
//--------------------------
	If cAcao = 2 // manutencao
		FSetTmp(M->PC0_NUMSEQ)
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ inicia montagem da tela                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize    := {}
	aInfo    := {}
	aObjects := {}
	aPosObj  := {}

	aSize := MsAdvSize()
	aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	aAdd(aObjects,{030,100,.T.,.F.})
	aAdd(aObjects,{070,100,.T.,.T.})
	aPosObj := MsObjSize(aInfo,aObjects)
	
	DEFINE MSDIALOG oDlg TITLE cTitulo From  aSize[7],aSize[1] TO aSize[6]-aSize[2],aSize[5]-aSize[2] of oMainWnd PIXEL

//
// Cria o conteiner onde serão colocados os browses
//
	oFWLayer := FWLayer():New()
	oFWLayer:Init( oDlg, .F., .T. )

//
// Define Painel Superior
//
	oFWLayer:AddLine( 'UP', 20, .F. )                       // Cria uma "linha" com 10% da tela
	oFWLayer:AddCollumn( 'ALL', 100, .T., 'UP' )            // Na "linha" criada eu crio uma coluna com 100% da tamanho dela
	oPanelUp := oFWLayer:GetColPanel( 'ALL', 'UP' )         // Pego o objeto desse pedaço do container

	oTPane1 := TPanel():New(0,0,"",oPanelUp,NIL,.T.,.F.,NIL,NIL,0,60,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP

	@ 005,005 SAY OemToAnsi("Num.Entrada") OF oTPane1 PIXEL COLOR CLR_BLUE //"NUMERO DA ENTRADA"
	@ 004,045 MSGET oNumSeq  VAR M->PC0_NUMSEQ PICTURE "@!" SIZE 35,4 when .F. OF oTPane1 PIXEL COLOR CLR_BLACK

	@ 005,090 SAY OemToAnsi("Data Entrada") OF oTPane1 PIXEL COLOR CLR_BLUE //"DATA DA ENTRADA"
	@ 004,130 MSGET oDtEntr  VAR M->PC0_DTENTR PICTURE "@!" SIZE 40,4 when cAcao == 1 OF oTPane1 PIXEL COLOR CLR_BLACK

	@ 025,005 SAY "Total Medido Linha:" SIZE 200,15 OF oTPane1 PIXEL FONT oFnt1 COLOR CLR_BLACK
	@ 025,090 SAY oTotMedLin VAR nTotMedLin SIZE 100,15 OF oTPane1 PIXEL PICTURE "@E 99,999,999" FONT oFnt1 COLOR CLR_BLUE

	@ 025,155 SAY "Total Apontado Linha:" SIZE 200,15 OF oTPane1 PIXEL FONT oFnt1 COLOR CLR_BLACK
	@ 025,240 SAY oTotApoLin VAR nTotApoLin SIZE 100,15 OF oTPane1 PIXEL PICTURE "@E 99,999,999" FONT oFnt1 COLOR CLR_BLUE

	@ 025,305 SAY "Total Diferenca Linha:" SIZE 200,15 OF oTPane1 PIXEL FONT oFnt1 COLOR CLR_BLACK
	@ 025,390 SAY oTotDifLin VAR nTotDifLin SIZE 100,15 OF oTPane1 PIXEL PICTURE "@E 99,999,999" FONT oFnt1 COLOR CLR_BLUE

	@ 045,005 SAY "Total Medido Rota:" SIZE 200,15 OF oTPane1 PIXEL FONT oFnt1 COLOR CLR_BLACK
	@ 045,090 SAY oTotMedRot VAR nTotMedRot SIZE 100,15 OF oTPane1 PIXEL PICTURE "@E 99,999,999" FONT oFnt1 COLOR CLR_BLUE

	@ 045,155 SAY "Total Apontado Rota:" SIZE 200,15 OF oTPane1 PIXEL FONT oFnt1 COLOR CLR_BLACK
	@ 045,240 SAY oTotApoRot VAR nTotApoRot SIZE 100,15 OF oTPane1 PIXEL PICTURE "@E 99,999,999" FONT oFnt1 COLOR CLR_BLUE

	@ 045,305 SAY "Total Diferenca Rota:" SIZE 200,15 OF oTPane1 PIXEL FONT oFnt1 COLOR CLR_BLACK
	@ 045,390 SAY oTotDifRot VAR nTotDifRot SIZE 100,15 OF oTPane1 PIXEL PICTURE "@E 99,999,999" FONT oFnt1 COLOR CLR_BLUE

//
// Painel Inferior
//
	oFWLayer:AddLine( 'DOWN', 80, .F. )                     // Cria uma "linha" com 80% da tela
	oFWLayer:AddCollumn( 'ALL' ,  100, .T., 'DOWN' )        // Na "linha" criada eu crio uma coluna com 100% da tamanho dela
	oPanelDown  := oFWLayer:GetColPanel( 'ALL' , 'DOWN' )   // Pego o objeto desse pedaço do container

	@ 001,001 FOLDER oFld PROMPT "&Entrada Linha", "&Entrada Rota" SIZE aPosObj[2][4]-10,aPosObj[2][3]-100 OF oPanelDown PIXEL

	oTPane2 := TPanel():New(0,0,"",oFld:aDialogs[1],NIL,.T.,.F.,NIL,NIL,0,25,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_BOTTOM

	@ 00,00 LISTBOX oLbx1 FIELDS HEADER "Cod.Linha", "Descricao", "Qtd.Apontada", "Qtd.Medida", "Diferenca" SIZE 508,235 OF oFld:aDialogs[1] PIXEL
	oLbx1:Align := CONTROL_ALIGN_ALLCLIENT
	oLbx1:SetArray( aVetor1 )
	oLbx1:bLine := {|| {aVetor1[oLbx1:nAt,1],aVetor1[oLbx1:nAt,2],aVetor1[oLbx1:nAt,3],aVetor1[oLbx1:nAt,4],aVetor1[oLbx1:nAt,5]}}
	oLbx1:Refresh()

//@ 005,010 Button "&Visualiza Linha"	Size 050,012 PIXEL ACTION  {|| ManutLin(2,oLbx1:nAt) } OF oTPane2
	@ 005,010 Button "&Inclui Linha"	Size 050,012 PIXEL ACTION  {|| ManutLin(3,oLbx1:nAt) } OF oTPane2
	@ 005,070 Button "&Altera Linha"	Size 050,012 PIXEL ACTION  {|| ManutLin(4,oLbx1:nAt) } OF oTPane2
	@ 005,130 Button "&Exclui Linha"	Size 050,012 PIXEL ACTION  {|| ManutLin(5,oLbx1:nAt) } OF oTPane2

	oTPane3 := TPanel():New(0,0,"",oFld:aDialogs[2],NIL,.T.,.F.,NIL,NIL,0,25,.T.,.F.)
	oTPane3:Align := CONTROL_ALIGN_BOTTOM

	@ 00,00 LISTBOX oLbx2 FIELDS HEADER "Cod.Rota", "Descricao", "Qtd.Apontada", "Qtd.Medida", "Diferenca" SIZE 508,235 OF oFld:aDialogs[2] PIXEL
	oLbx2:Align := CONTROL_ALIGN_ALLCLIENT
	oLbx2:SetArray( aVetor2 )
	oLbx2:bLine := {|| {aVetor2[oLbx2:nAt,1],aVetor2[oLbx2:nAt,2],aVetor2[oLbx2:nAt,3],aVetor2[oLbx2:nAt,4],aVetor2[oLbx2:nAt,5]}}
	oLbx2:Refresh()

//@ 005,010 Button "&Visualiza Rota"	Size 050,012 PIXEL ACTION  {|| ManutRot(2,oLbx2:nAt) } OF oTPane3
	@ 005,010 Button "&Inclui Rota"		Size 050,012 PIXEL ACTION  {|| ManutRot(3,oLbx2:nAt) } OF oTPane3
	@ 005,070 Button "&Altera Rota"		Size 050,012 PIXEL ACTION  {|| ManutRot(4,oLbx2:nAt) } OF oTPane3
	@ 005,130 Button "&Exclui Rota"		Size 050,012 PIXEL ACTION  {|| ManutRot(5,oLbx2:nAt) } OF oTPane3

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(FValVet(cAcao,oLbx1:nAt,oLbx2:nAt),oDlg:End(),nOpca:=0)},{||nOpcA:=0,oDlg:End()},.F.,)

	If nOpcA == 1
//	Begin Transaction
		GrvEnt(cAcao)
		If GETMV("ES_ATUESTO",,.F.) //parametro verifica se atualiza ou nao estoque
			FAtuEst()
		EndIf
		EvalTrigger()
		If __lSX8
			ConfirmSX8()
		Endif
	//End Transaction
	Else
		If __lSX8
			RollBackSX8()
		Endif
	Endif

	TMP0->(DbCloseArea())
	Ferase(cNomTMP0+".dbf")
	Ferase(cNomTMP0+OrdBagExt())

	TMP1->(DbCloseArea())
	Ferase(cNomTMP1+".dbf")
	Ferase(cNomTMP1+OrdBagExt())

	TMP2->(DbCloseArea())
	Ferase(cNomTMP2+".dbf")
	Ferase(cNomTMP2+OrdBagExt())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ManutLin  ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inclui, Altera e Exclui linhas da entrada de leite.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function ManutLin(_nOpc,_nPos)

	Local oDlg
	Local oTPane1
	Local oLinha
	Local oDescri
	Local oTotMed
	Local oCarSub
	Local oDesSub
	Local cDesLin   := ""
	Local cDesCar   := ""
	Local nX        := 0
	Local nI        := 0
	Local aAlter1   := {}
	Local nAlias    := 0
	Local aCpos     := {}
	Local oEnch
	Local nOpcA     := 0
	Local cCpoRestr := "PC1_FILIAL/PC1_NUMSEQ/PC1_LINHA/PC1_DESCRI/PC1_QTDMED/PC1_CARSUB/PC1_DESSUB/PC1_LINPRO/PC1_RECNO"
	Local nXOpc     := 0
	Local bCampo
	Local nUsado    := 0
	Local nCOLS1    := 0
	Local aSvaRot   := {}

	aSvaRot := aClone(aRotina)
	aRotina := {{ 0	,0	, 0 , 1},;
		{ 0	,0  , 0 , 2	},;
		{ 0	,0	, 0 , 3	},;
		{ 0	,0	, 0 , 4	},;
		{ 0	,0	, 0 , 5}}

//So permite inclusao se vetor estiver vazio
	If _nOpc <> 3 .And. Empty(aVetor1[_nPos][1])
		MsgAlert("Não Existe registro para utilizar esta opção. Utilize a opção <Inclui>.")
		Return
	EndIf

	cTotApo := 0

	If _nOpc == 3 //incluir
		aAlter1 := {"PC1_CODPRO","PC1_QTDLIT"}
		nXOpc   := 3
		bCampo  := {|nField| FieldName(nField) }
	ElseIf _nOpc == 4 //alterar
		nXOpc  := 4
		aAlter1 := {"PC1_CODPRO","PC1_QTDLIT"}
		bCampo  := {|nField| Field(nField) }
	ElseIf _nOpc == 5 //excluir
		nXOpc  := 2
		bCampo  := {|nField| Field(nField) }
	EndIf

// Carrega os Campos de Memoria da Tabela PC1
	dbSelectArea("TMP1")
	dbSetOrder(1)
	DbSeek( xFilial("PC1") + M->PC0_NUMSEQ + aVetor1[oLbx1:nAt][1] )

	For nX := 1 To FCount()
		If _nOpc == 3
			If !FieldName(nX) $ "PC1_RECNO"
				M->&(Eval(bCampo,nX)) := CriaVar(FieldName(nX),.T.)
		   //aAdd(aCpos,FieldName(nX))
			EndIf
		Else
			If !FieldName(nX) $ "PC1_RECNO"
				M->&(Eval(bCampo,nX)) := FieldGet(nX)
			EndIf
		EndIf
	Next nX

	If _nOpc <> 3
		cDesLin := RetField("PA7",1,xFilial("PA7") + M->PC1_LINHA ,"PA7->PA7_DESC")
		cDesCar := RetField("LBE",2,xFilial("LBE") + M->PC1_CARSUB ,"LBE->LBE_MOTO")
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria aHeader                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aHeader1 := {}
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("PC1")
	While !Eof() .And. SX3->X3_ARQUIVO == "PC1"
		If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .And. !Alltrim(X3_CAMPO) $ cCpoRestr
			aAdd(aHeader1,{X3Titulo(),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT})
		Endif
		dbSkip()
	End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria aCols                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCOLS1 := {}

	If _nOpc == 3

		aAdd( aCOLS1 , Array( Len( aHeader1 )+1 ) )
		For nI := 1 To Len( aHeader1 )
			aCOLS1[1,nI] := CriaVar( aHeader1[nI,2] )
		Next nI
		aCOLS1[Len(aCOLS1), Len(aHeader1)+1] := .F.

	Else
		dbSelectArea( "TMP1" )
		dbSetOrder( 1 )
		dbSeek( CFILLIN + M->PC0_NUMSEQ + aVetor1[oLbx1:nAt][1] )
   
		While !Eof() .And. CFILLIN + M->PC0_NUMSEQ + aVetor1[oLbx1:nAt][1] == TMP1->PC1_FILIAL + TMP1->PC1_NUMSEQ + TMP1->PC1_LINHA
			aAdd( aCOLS1, Array( Len(aHeader1)+1 ) )
			nCOLS1++
   
			For i := 1 To Len(aHeader1)
				If aHeader1[ i, 10 ] <> "V"
					aCOLS1[ nCOLS1, i ] := FieldGet( FieldPos( aHeader1[ i, 2 ] ) )
					If rTrim(aHeader1[i][2]) == "PC1_QTDLIT"
						cTotApo := cTotApo + FieldGet( FieldPos( aHeader1[ i, 2 ] ) )
					EndIf
				ElseIf rTrim(aHeader1[i][2]) == "PC1_NOMFOR"
					aCOLS1[ nCOLS1, i ] := RetField("LBB",1,xFilial("LBB") + TMP1->PC1_CODPRO ,"LBB->LBB_NOMFOR")
				ElseIf rTrim(aHeader1[i][2]) == "PC1_NOMPRO"
					aCOLS1[ nCOLS1, i ] := RetField("LBB",1,xFilial("LBB") + TMP1->PC1_CODPRO ,"LBB->LBB_DESC")
				Endif
			Next i
   
			aCOLS1[ nCOLS1, Len(aHeader1)+1 ] := .F.
			dbSelectArea( "TMP1" )
			dbSkip()
		End

	Endif

	DEFINE MSDIALOG oDlg TITLE "Manutencao de Linhas" From 9,0 to 31,80	of oMainWnd
    
	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,30,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP

	@ 004,004 SAY OemToAnsi("Linha") OF oTPane1 PIXEL COLOR CLR_BLUE
	@ 003,020 MSGET oLinha VAR M->PC1_LINHA PICTURE "@!" F3 "PA7" VALID ExistCpo("PA7") .And. fValLinRot(M->PC1_LINHA,@cDesLin,1) .And. NaoVazio();
		.and. ValidLn(dtos(M->PC0_DTENTR),M->PC1_LINHA) When nXOpc == 3 SIZE 40,4 OF oTPane1 PIXEL COLOR CLR_BLACK

	@ 004,070 SAY OemToAnsi("Descricao") OF oTPane1 PIXEL COLOR CLR_BLACK
	@ 003,100 MSGET oDescri VAR cDesLin PICTURE "@!" SIZE 100,4 OF oTPane1 PIXEL COLOR CLR_BLACK when .f.
	
	@ 004,210 SAY OemToAnsi("Total Medido") OF oTPane1 PIXEL COLOR CLR_BLUE
	@ 003,245 MSGET oTotMed VAR M->PC1_QTDMED PICTURE "@E 99,999,999" Valid NaoVazio() When nXOpc == 3 SIZE 40,4 OF oTPane1 PIXEL COLOR CLR_BLACK

	@ 018,004 SAY OemToAnsi("Carreteiro") OF oTPane1 PIXEL COLOR CLR_BLACK
	@ 017,032 MSGET oCarSub VAR M->PC1_CARSUB PICTURE "@!" F3 "LBE" VALID fValCar(M->PC1_CARSUB,@cDesCar) When nXOpc == 3 SIZE 40,4 OF oTPane1 PIXEL COLOR CLR_BLACK
	
	@ 018,082 SAY OemToAnsi("Nome Sub.") OF oTPane1 PIXEL COLOR CLR_BLACK
	@ 017,110 MSGET oDescri VAR cDesCar PICTURE "@!" SIZE 100,4 OF oTPane1 PIXEL COLOR CLR_BLACK when .f.

	@ 018,214 SAY "Qtd.Apontada:" SIZE 200,15 OF oTPane1 PIXEL FONT oFnt1 COLOR CLR_BLACK
	@ 018,270 SAY oTotApo VAR cTotApo SIZE 100,15 OF oTPane1 PIXEL PICTURE "@E 99,999,999" FONT oFnt1 COLOR CLR_BLUE

	oGetDad1 := MsNewGetDados():New(0,0,0,0,GD_INSERT+GD_UPDATE+GD_DELETE,"u_Qua20LOk(1)","u_Qua20TOk(1)","",aAlter1,,999,,,,oDlg,@aHeader1,@aCols1)
	oGetDad1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oGetDad1:oBrowse:Refresh()
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(u_Qua20TOk(1),oDlg:End(),nOpca:=0)},{||nOpcA:=0,oDlg:End()},.F.,)

	If nOpcA == 1
//	Begin Transaction
		GrvTMP1(nXOpc,"TMP1")
	//End Transaction
	Endif

	aRotina := aClone(aSvaRot)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ManutRot  ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inclui, Altera e Exclui rotas da entrada de leite.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function ManutRot(_nOpc,_nPos)

	Local oDlg
	Local oTPane1
	Local oRota
	Local oDescri
	Local oTotMed
	Local oCarSub
	Local oDesSub
	Local cDesRot   := ""
	Local cDesCar   := ""
	Local nX        := 0
	Local nI        := 0
	Local aAlter2   := {}
	Local nAlias    := 0
	Local aCpos     := {}
	Local oEnch
	Local nOpcA     := 0
	Local cCpoRestr := "PC2_FILIAL/PC2_NUMSEQ/PC2_ROTA/PC2_DESCRI/PC2_QTDMED/PC2_CARSUB/PC2_DESSUB/PC2_ROTTAN/PC2_RECNO"
	Local nXOpc     := 0
	Local bCampo
	Local nUsado    := 0
	Local nCols2    := 0
	Local aSvaRot   := {}

	aSvaRot := aClone(aRotina)
	aRotina := {{ 0	,0	, 0 , 1},;
		{ 0	,0  , 0 , 2	},;
		{ 0	,0	, 0 , 3	},;
		{ 0	,0	, 0 , 4	},;
		{ 0	,0	, 0 , 5}}

//So permite inclusao se vetor estiver vazio
	If _nOpc <> 3 .And. Empty(aVetor2[_nPos][1])
		MsgAlert("Não Existe registro para utilizar esta opção. Utilize a opção <Inclui>.")
		Return
	EndIf

//nOpc := _nOpc
	cTotApo := 0

	If _nOpc == 3 //incluir
		aAlter2 := {"PC2_CODTAN","PC2_QTDLIT"}
		nXOpc   := 3
		bCampo  := {|nField| FieldName(nField) }
	ElseIf _nOpc == 4 //alterar
		nXOpc  := 4
		aAlter2 := {"PC2_CODTAN","PC2_QTDLIT"}
		bCampo  := {|nField| Field(nField) }
	ElseIf _nOpc == 5 //excluir
		nXOpc  := 2
		bCampo  := {|nField| Field(nField) }
	EndIf

// Carrega os Campos de Memoria da Tabela PC2
	dbSelectArea("TMP2")
	dbSetOrder(1)
	DbSeek( xFilial("PC2") + M->PC0_NUMSEQ + aVetor2[oLbx2:nAt][1] )

	For nX := 1 To FCount()
		If nXOpc == 3
			If !FieldName(nX) $ "PC2_RECNO"
				M->&(Eval(bCampo,nX)) := CriaVar(FieldName(nX),.T.)
		   //aAdd(aCpos,FieldName(nX))
			EndIf
		Else
			If !FieldName(nX) $ "PC2_RECNO"
				M->&(Eval(bCampo,nX)) := FieldGet(nX)
			EndIf
		EndIf
	Next nX

	If lManut // SETA VARIAVEIS QDO ORIGEM FOR MOD1
		M->PC2_ROTA   := M->PC0_LINROT
		M->PC2_QTDMED := M->PC0_QTDMED
	EndIf

	If nXOpc <> 3
		cDesRot := RetField("PA7",1,xFilial("LBC") + M->PC2_ROTA ,"LBC->LBC_DESC")
		cDesCar := RetField("LBE",2,xFilial("LBE") + M->PC2_CARSUB ,"LBE->LBE_MOTO")
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria aHeader                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aHeader2 := {}
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("PC2")
	While !Eof() .And. SX3->X3_ARQUIVO == "PC2"
		If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .And. !Alltrim(X3_CAMPO) $ cCpoRestr
			aAdd(aHeader2,{X3Titulo(),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT})
		Endif
		dbSkip()
	End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria aCols                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols2 := {}

	If nXOpc == 3

		aAdd( aCols2 , Array( Len( aHeader2 )+1 ) )
		For nI := 1 To Len( aHeader2 )
			aCols2[1,nI] := CriaVar( aHeader2[nI,2] )
		Next nI
		aCols2[Len(aCols2), Len(aHeader2)+1] := .F.

	Else
		DbSelectArea("LBF")
		DbSetOrder(1)

		dbSelectArea( "TMP2" )
		dbSetOrder( 1 )
		dbSeek( CFILROT + M->PC0_NUMSEQ + aVetor2[oLbx2:nAt][1] )
   
		While !Eof() .And. CFILROT + M->PC0_NUMSEQ + aVetor2[oLbx2:nAt][1] == TMP2->PC2_FILIAL + TMP2->PC2_NUMSEQ + TMP2->PC2_ROTA
			aAdd( aCols2, Array( Len(aHeader2)+1 ) )
			nCols2++
   
			For i := 1 To Len(aHeader2)
				If aHeader2[ i, 10 ] <> "V"
					aCols2[ nCols2, i ] := FieldGet( FieldPos( aHeader2[ i, 2 ] ) )
					If rTrim(aHeader2[i][2]) == "PC2_QTDLIT"
						cTotApo := cTotApo + FieldGet( FieldPos( aHeader2[ i, 2 ] ) )
					EndIf
				ElseIf rTrim(aHeader2[i][2]) == "PC2_NOMFOR"
					LBF->( DbSeek(xFilial("LBF") + TMP2->PC2_CODTAN ) )
					aCols2[ nCols2, i ] := RetField("LBB",1,xFilial("LBB") + LBF->LBF_CODPRO ,"LBB->LBB_NOMFOR")

				ElseIf rTrim(aHeader2[i][2]) == "PC2_NOMPRO"
					LBF->( DbSeek(xFilial("LBF") + TMP2->PC2_CODTAN ) )
					aCols2[ nCols2, i ] := RetField("LBB",1,xFilial("LBB") + LBF->LBF_CODPRO ,"LBB->LBB_DESC")

				Endif
			Next i
   
			aCols2[ nCols2, Len(aHeader2)+1 ] := .F.
			dbSelectArea( "TMP2" )
			dbSkip()
		End

	Endif

	DEFINE MSDIALOG oDlg TITLE "Manutencao de Rotas" From 9,0 to 31,80	of oMainWnd
    
	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,30,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP

	@ 004,004 SAY OemToAnsi("Rota") OF oTPane1 PIXEL COLOR CLR_BLUE
	@ 003,020 MSGET oRota VAR M->PC2_ROTA PICTURE "@!" F3 "LBC" VALID ExistCpo("LBC") .And. fValLinRot(M->PC2_ROTA,@cDesRot,2) .And. ;
		NaoVazio() .AND. ValidRt(DTOS(M->PC0_DTENTR),M->PC2_ROTA) When nXOpc == 3 SIZE 40,4 OF oTPane1 PIXEL COLOR CLR_BLACK

	@ 004,070 SAY OemToAnsi("Descricao") OF oTPane1 PIXEL COLOR CLR_BLACK
	@ 003,100 MSGET oDescri VAR cDesRot PICTURE "@!" SIZE 100,4 OF oTPane1 PIXEL COLOR CLR_BLACK when .f.
	
	@ 004,210 SAY OemToAnsi("Total Medido") OF oTPane1 PIXEL COLOR CLR_BLUE
	@ 003,245 MSGET oTotMed VAR M->PC2_QTDMED PICTURE "@E 99,999,999" Valid NaoVazio() When nXOpc == 3 SIZE 40,4 OF oTPane1 PIXEL COLOR CLR_BLACK

	@ 018,004 SAY OemToAnsi("Carreteiro") OF oTPane1 PIXEL COLOR CLR_BLACK
	@ 017,032 MSGET oCarSub VAR M->PC2_CARSUB PICTURE "@!" F3 "LBE" VALID fValCar(M->PC2_CARSUB,@cDesCar) When nXOpc == 3 SIZE 40,4 OF oTPane1 PIXEL COLOR CLR_BLACK
	
	@ 018,082 SAY OemToAnsi("Nome Sub.") OF oTPane1 PIXEL COLOR CLR_BLACK
	@ 017,110 MSGET oDescri VAR cDesCar PICTURE "@!" SIZE 100,4 OF oTPane1 PIXEL COLOR CLR_BLACK when .f.

	@ 018,214 SAY "Qtd.Apontada:" SIZE 200,15 OF oTPane1 PIXEL FONT oFnt1 COLOR CLR_BLACK
	@ 018,270 SAY oTotApo VAR cTotApo SIZE 100,15 OF oTPane1 PIXEL PICTURE "@E 99,999,999" FONT oFnt1 COLOR CLR_BLUE

	oGetDad2 := MsNewGetDados():New(0,0,0,0,GD_INSERT+GD_UPDATE+GD_DELETE,"u_Qua20LOk(2)","u_Qua20TOk(2)","",aAlter2,,999,,,,oDlg,@aHeader2,@aCols2)
	oGetDad2:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oGetDad2:oBrowse:Refresh()
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(u_Qua20TOk(2),oDlg:End(),nOpca:=0)},{||nOpcA:=0,oDlg:End()},.F.,)

	If nOpcA == 1
//	Begin Transaction
		GrvTMP2(nXOpc,"TMP2")
	//End Transaction
	Endif

	aRotina := aClone(aSvaRot)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MontVet   ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta vetores das listas dos folders.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontVet(cAcao)

	Local aArea := GetArea()
	Local _cFil := PC0->PC0_FILIAL
	Local _cNum := PC0->PC0_NUMSEQ
	Local _cDtE := PC0->PC0_DTENTR

	aVetor1 := {}        //vetor lixtbox linha
	aVetor2 := {}        //vetor listbox rota

	nTotMedLin  := 0     //total medido linha
	nTotApoLin  := 0     //total apontado linha
	nTotDifLin  := 0     //total diferenca linha

	nTotMedRot  := 0     //total medido rota
	nTotApoRot  := 0     //total apontado rota
	nTotDifRot  := 0     //diferenca rota

	If cAcao == 1
		aAdd( aVetor1, {CriaVar("PC0_LINROT",.T.),CriaVar("PC0_DESCRI",.T.),CriaVar("PC0_QTDAPO",.T.),CriaVar("PC0_QTDMED",.T.),CriaVar("PC0_QTDDIF",.T.)})
		aAdd( aVetor2, {CriaVar("PC0_LINROT",.T.),CriaVar("PC0_DESCRI",.T.),CriaVar("PC0_QTDAPO",.T.),CriaVar("PC0_QTDMED",.T.),CriaVar("PC0_QTDDIF",.T.)})
	Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega o vetor da Lista                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea(cAlias)
		DbSetOrder(1)
		If MsSeek( xFilial(cAlias) + _cNum + DtoS(_cDtE) )
			While PC0->( !Eof() ) .And. _cFil+_cNum+DtoS(_cDtE) == PC0->PC0_FILIAL+PC0->PC0_NUMSEQ+DtoS(PC0->PC0_DTENTR)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ 
			//³aVetor(1-2)[oLbx:nAt, 1] - Linha - Rota     ³ 
			//³aVetor(1-2)[oLbx:nAt, 2] - Descricao(1-2)   ³ 
			//³aVetor(1-2)[oLbx:nAt, 3] - Qtd.Apontada(1-2)³ 
			//³aVetor(1-2)[oLbx:nAt, 4] - Qtd.Medida(1-2)  ³ 
			//³aVetor(1-2)[oLbx:nAt, 5] - Diferenca(1-2)   ³ 
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ           
				If PC0->PC0_TPENTR == "1" //linha
					aAdd( aVetor1, {PC0->PC0_LINROT,PC0->PC0_DESCRI,PC0->PC0_QTDAPO,PC0->PC0_QTDMED,PC0->PC0_QTDDIF })

					nTotMedLin  := nTotMedLin + PC0->PC0_QTDMED     //total medido linha
					nTotApoLin  := nTotApoLin + PC0->PC0_QTDAPO     //total apontado linha
					nTotDifLin  := nTotDifLin + PC0->PC0_QTDDIF     //total diferenca linha
	
				ElseIf PC0->PC0_TPENTR == "2" //rota
					aAdd( aVetor2, {PC0->PC0_LINROT,PC0->PC0_DESCRI,PC0->PC0_QTDAPO,PC0->PC0_QTDMED,PC0->PC0_QTDDIF })

					nTotMedRot  := nTotMedRot + PC0->PC0_QTDMED     //total medido rota
					nTotApoRot  := nTotApoRot + PC0->PC0_QTDAPO     //total apontado rota
					nTotDifRot  := nTotDifRot + PC0->PC0_QTDDIF     //diferenca rota

				EndIf
				PC0->( dbSkip() )
			EndDo
		EndIf
	EndIf

	If Len(aVetor1) == 0
		aAdd( aVetor1, {CriaVar("PC0_LINROT",.T.),CriaVar("PC0_DESCRI",.T.),CriaVar("PC0_QTDAPO",.T.),CriaVar("PC0_QTDMED",.T.),CriaVar("PC0_QTDDIF",.T.)})
	EndIf
	If Len(aVetor2) == 0
		aAdd( aVetor2, {CriaVar("PC0_LINROT",.T.),CriaVar("PC0_DESCRI",.T.),CriaVar("PC0_QTDAPO",.T.),CriaVar("PC0_QTDMED",.T.),CriaVar("PC0_QTDDIF",.T.)})
	EndIf

	RestArea( aArea )
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CriaTMP   ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cria tabelas temporarias para entrada de leite.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function CriaTMP()

	Local aAssoc0  := {}
	Local aArqTMP0 := {}
	Local cIndTMP0
	Local aAssoc1  := {}
	Local aArqTMP1 := {}
	Local cIndTMP1
	Local aAssoc2  := {}
	Local aArqTMP2 := {}
	Local cIndTMP2
	Local nI := 0

//MONTA TMP0 COM BASE NA TABELA PC0 
//---------------------------------
	aAdd( aAssoc0, { "PC0_FILIAL"	,"PC0_FILIAL"	} )
	aAdd( aAssoc0, { "PC0_NUMSEQ"	,"PC0_NUMSEQ"	} )
	aAdd( aAssoc0, { "PC0_DTENTR"	,"PC0_DTENTR"	} )
	aAdd( aAssoc0, { "PC0_TPENTR"	,"PC0_TPENTR"	} )
	aAdd( aAssoc0, { "PC0_LINROT"	,"PC0_LINROT"	} )
	aAdd( aAssoc0, { "PC0_DESCRI"	,"PC0_DESCRI"	} )
	aAdd( aAssoc0, { "PC0_QTDAPO"	,"PC0_QTDAPO"	} )
	aAdd( aAssoc0, { "PC0_QTDMED"	,"PC0_QTDMED"	} )
	aAdd( aAssoc0, { "PC0_QTDDIF"	,"PC0_QTDDIF"	} )
	aAdd( aAssoc0, { "PC0_GEREST"	,"PC0_GEREST"	} )

	dbSelectArea("SX3")
	dbSetOrder(2)
	For nI := 1 To Len( aAssoc0 )
		if dbSeek( aAssoc0[nI,2] )
			aAdd( aArqTMP0, { aAssoc0[nI,1], X3_TIPO, X3_TAMANHO, X3_DECIMAL } )
//	else
//		MsgAlert("Erro no dbseek " + aAssoc0[nI,2] )
		endIf
	Next nI

//cIndTMP0 := "FILIAL+NUMSEQ+DtoS(DTENTR)+TPENTR+LINROT"
	cIndTMP0 := "PC0_FILIAL+PC0_NUMSEQ+DtoS(PC0_DTENTR)+PC0_TPENTR+PC0_LINROT"
	cNomTMP0 := CriaTrab( aArqTMP0, .T. )
	dbUseArea( .T., , cNomTMP0, "TMP0" , .T. ,.F. )

//MsgAlert(cNomTMP0)

	IndRegua( "TMP0", cNomTMP0, cIndTMP0 )
	dbSetOrder(1)

//MONTA TMP1 COM BASE NA TABELA PC1
//---------------------------------
	aAdd( aAssoc1, { "PC1_FILIAL"	,"PC1_FILIAL"	} )
	aAdd( aAssoc1, { "PC1_NUMSEQ"	,"PC1_NUMSEQ"	} )
	aAdd( aAssoc1, { "PC1_LINHA"	,"PC1_LINHA"	} )
	aAdd( aAssoc1, { "PC1_DESCRI"	,"PC1_DESCRI"	} )
	aAdd( aAssoc1, { "PC1_QTDMED"	,"PC1_QTDMED"	} )
	aAdd( aAssoc1, { "PC1_CARSUB"	,"PC1_CARSUB"	} )
	aAdd( aAssoc1, { "PC1_DESSUB"	,"PC1_DESSUB"	} )
	aAdd( aAssoc1, { "PC1_CODPRO"	,"PC1_CODPRO"	} )
	aAdd( aAssoc1, { "PC1_QTDLIT"	,"PC1_QTDLIT"	} )
	aAdd( aAssoc1, { "PC1_NOMFOR"	,"PC1_NOMFOR"	} )
	aAdd( aAssoc1, { "PC1_NOMPRO"	,"PC1_NOMPRO"	} )
	aAdd( aAssoc1, { "PC1_LINPRO"	,"PC1_LINPRO"	} )
	aAdd( aAssoc1, { "PC1_VLRLIT"	,"PC1_VLRLIT"	} )
	aAdd( aAssoc1, { "PC1_RECNO"	,"PC1_QTDLIT"	} )

	dbSelectArea("SX3")
	dbSetOrder(2)
	For nI := 1 To Len( aAssoc1 )
		if dbSeek( aAssoc1[nI,2] )
			aAdd( aArqTMP1, { aAssoc1[nI,1], X3_TIPO, X3_TAMANHO, X3_DECIMAL } )
//	else
//		MsgAlert("Erro no dbseek " + aAssoc1[nI,2] )
		endIf
	Next nI

//cIndTMP1 := "FILIAL+NUMSEQ+LINHA+CODPRO"
	cIndTMP1 := "PC1_FILIAL+PC1_NUMSEQ+PC1_LINHA+PC1_CODPRO"
	cNomTMP1 := CriaTrab( aArqTMP1, .T. )
	dbUseArea( .T., , cNomTMP1, "TMP1" , .T. ,.F. )

//MsgAlert(cNomTMP1)

	IndRegua( "TMP1", cNomTMP1, cIndTMP1 )
	dbSetOrder(1)

//MONTA TMP2 COM BASE NA TABELA PC2
//---------------------------------
	aAdd( aAssoc2, { "PC2_FILIAL"	,"PC2_FILIAL"	} )
	aAdd( aAssoc2, { "PC2_NUMSEQ"	,"PC2_NUMSEQ"	} )
	aAdd( aAssoc2, { "PC2_ROTA"		,"PC2_ROTA"		} )
	aAdd( aAssoc2, { "PC2_DESCRI"	,"PC2_DESCRI"	} )
	aAdd( aAssoc2, { "PC2_QTDMED"	,"PC2_QTDMED"	} )
	aAdd( aAssoc2, { "PC2_CARSUB"	,"PC2_CARSUB"	} )
	aAdd( aAssoc2, { "PC2_DESSUB"	,"PC2_DESSUB"	} )
	aAdd( aAssoc2, { "PC2_CODTAN"	,"PC2_CODTAN"	} )
	aAdd( aAssoc2, { "PC2_QTDLIT"	,"PC2_QTDLIT"	} )
	aAdd( aAssoc2, { "PC2_NOMFOR"	,"PC2_NOMFOR"	} )
	aAdd( aAssoc2, { "PC2_NOMPRO"	,"PC2_NOMPRO"	} )
	aAdd( aAssoc2, { "PC2_ROTTAN"	,"PC2_ROTTAN"	} )
	aAdd( aAssoc2, { "PC2_VLRLIT"	,"PC2_VLRLIT"	} )
	aAdd( aAssoc2, { "PC2_RECNO"	,"PC2_QTDLIT"	} )

	dbSelectArea("SX3")
	dbSetOrder(2)
	For nI := 1 To Len( aAssoc2 )
		if dbSeek( aAssoc2[nI,2] )
			aAdd( aArqTMP2, { aAssoc2[nI,1], X3_TIPO, X3_TAMANHO, X3_DECIMAL } )
//	else
//		MsgAlert("Erro no dbseek " + aAssoc2[nI,2] )
		endIf
	Next nI

//cIndTMP2 := "FILIAL+NUMSEQ+ROTA+CODTAN"
	cIndTMP2 := "PC2_FILIAL+PC2_NUMSEQ+PC2_ROTA+PC2_CODTAN"
	cNomTMP2 := CriaTrab( aArqTMP2, .T. )
	dbUseArea( .T., , cNomTMP2, "TMP2" , .T. ,.F. )

//MsgAlert(cNomTMP2)

	IndRegua( "TMP2", cNomTMP2, cIndTMP2 )
	dbSetOrder(1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fValLinRot³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida linha informada.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fValLinRot(cCod,cDes,nTp)

	Local aArea := GetArea()
	Local lRet  := .T.

	If !Empty(cCod) .And. nTp = 1
		cDes := RetField("PA7",1,xFilial("PA7") + cCod ,"PA7->PA7_DESC")
	ElseIf !Empty(cCod) .And. nTp = 2
		cDes := RetField("LBC",1,xFilial("LBC") + cCod ,"LBC->LBC_DESC")
	EndIf

	RestArea( aArea )
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fValCar   ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida carreterio substituto.                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fValCar(cCodCar,cDesCar)

	Local aArea := GetArea()
	Local lRet  := .T.

	If !Empty(cCodCar)
		If ExistCpo("LBE",cCodCar,2)
			cDesCar := RetField("LBE",2,xFilial("LBE") + cCodCar ,"LBE->LBE_MOTO")
		Else
			lRet  := .F.
		EndIf
	Else
		cDesCar := ""
	EndIf

	RestArea( aArea )
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³IncCod    ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Prepara codigo com zeros adicionais a esquerda.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IncCod(cCod)

	Local lRet  := .T.
	Local _cCpo := ReadVar()

	If !Empty(cCod)
		If AllTrim(_cCpo) == "M->PC1_CODPRO"
			M->PC1_CODPRO := PadL(AllTrim(cCod),6,"0")
		ElseIf AllTrim(_cCpo) == "M->PC2_CODTAN"
			M->PC2_CODTAN := PadL(AllTrim(cCod),6,"0")
		EndIf
	EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Qua20LOk  ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao linha ok.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Qua20LOk(_nOpcX)

	Local nI     := 0
	Local nPos   := 0
	Local lRet   := .T.
	Local lDelet := .F.
	Local _nAt   := Iif( _nOpcX==1 , oGetDad1:nAt , oGetDad2:nAt )
	Local _aAux  := aClone( Iif( _nOpcX==1 , oGetDad1:aCols , oGetDad2:aCols ) )

	If !_aAux[_nAt][Iif( _nOpcX==1, Len(aHeader1)+1 , Len(aHeader2)+1 )]
		If _nOpcX == 1
			If Empty(_aAux[_nAt][Pesq("PC1_CODPRO",1)]) .or. Empty(_aAux[_nAt][Pesq("PC1_QTDLIT",1)])
				APMsgAlert("Existem campos obrigatórios que não foram informados. Favor verificar !!!","Digitação Obrigatória")
				lRet := .F.
				Return(lRet)
			Endif
		ElseIf _nOpcX == 2
			If Empty(_aAux[_nAt][Pesq("PC2_CODTAN",2)]) .or. Empty(_aAux[_nAt][Pesq("PC2_QTDLIT",2)])
				APMsgAlert("Existem campos obrigatórios que não foram informados. Favor verificar !!!","Digitação Obrigatória")
				lRet := .F.
				Return(lRet)
			Endif
		EndIf
	Endif

	cTotApo := 0

	nPos := Iif(_nOpcX == 1,;
		aScan(aHeader1,{|x| Upper(Alltrim(x[2])) == "PC1_QTDLIT" }),;
		aScan(aHeader2,{|x| Upper(Alltrim(x[2])) == "PC2_QTDLIT" }) )
             
	If nPos > 0
		For nI := 1 to Len(_aAux)
			lDelet := Iif(_nOpcX==1, _aAux[nI][Len(aHeader1)+1], _aAux[nI][Len(aHeader2)+1] )
			If !lDelet
				cTotApo := cTotApo + _aAux[nI][nPos]
			EndIf
		Next nI
	EndIf

	oTotApo:Refresh()

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Qua20TOk  ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao tudo ok.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Qua20TOk(_nOpcX)

	Local lRet := .T.

	lRet := u_Qua20LOk(_nOpcX)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FValVet   ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida confirmacao tela principal                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FValVet(cAcao,nPosVet1,nPosVet2)

	Local lRet := .T.

	If Empty( aVetor1[nPosVet1][1] ) .And. Empty( aVetor2[nPosVet2][1] )
		MsgAlert("Não foi informado nenhuma linha e/ou rota.")
		lRet := .F.
	EndIf

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FRetDes   ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para atualizar descricao da rota                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FRetDes(cCodRot)

	M->PC0_DESCRI := RetField("LBC",1,xFilial("LBC") + cCodRot ,"LBC->LBC_DESC")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FValCpo   ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ valida os campos do modelo 1 para gravacao                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FValCpo()

	Local lRet := .T.

	If Empty(M->PC0_NUMSEQ) .Or. Empty(M->PC0_DTENTR) .Or. Empty(M->PC0_LINROT) .Or. Empty(M->PC0_QTDMED)
		MsgAlert("Existe campo obrigatório não informado.")
		lRet := .F.
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Pesq      ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ PESQUISA NO ACOLS                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Pesq(cCampo,nTp)
	Local nPos := 0

	If nTp == 1
		nPos := aScan(aHeader1,{|x|AllTrim(Upper(x[2]))==cCampo})
	ElseIf nTp == 2
		nPos := aScan(aHeader2,{|x|AllTrim(Upper(x[2]))==cCampo})
	EndIf

Return(nPos)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FSetTmp  ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Seta registros nas tabelas temporarias                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FSetTmp(_cNum)

	Local aArea    := GetArea()
	Local _cFilPC1 := xFilial("PC1")
	Local _cFilPC2 := xFilial("PC2")

	DbSelectArea("PC1")
	DbSetOrder(1)
	If DbSeek(_cFilPC1+_cNum)
		While PC1->( !EOF() ) .And. _cFilPC1 + _cNum == PC1->PC1_FILIAL + PC1->PC1_NUMSEQ
			DbSelectArea("TMP1")
			RecLock("TMP1",.T.)
			TMP1->PC1_FILIAL := PC1->PC1_FILIAL
			TMP1->PC1_NUMSEQ := PC1->PC1_NUMSEQ
			TMP1->PC1_LINHA  := PC1->PC1_LINHA
			TMP1->PC1_DESCRI := RetField("PA7",1,xFilial("PA7") + PC1->PC1_LINHA ,"PA7->PA7_DESC")
			TMP1->PC1_QTDMED := PC1->PC1_QTDMED
			TMP1->PC1_CARSUB := PC1->PC1_CARSUB
			TMP1->PC1_DESSUB := RetField("LBE",2,xFilial("LBE") + PC1->PC1_CARSUB ,"LBE->LBE_MOTO")
			TMP1->PC1_CODPRO := PC1->PC1_CODPRO
			TMP1->PC1_QTDLIT := PC1->PC1_QTDLIT
			TMP1->PC1_NOMFOR := RetField("LBB",1,xFilial("LBB") + PC1->PC1_CODPRO ,"LBB->LBB_NOMFOR")
			TMP1->PC1_NOMPRO := RetField("LBB",1,xFilial("LBB") + PC1->PC1_CODPRO ,"LBB->LBB_DESC")
			TMP1->PC1_LINPRO := PC1->PC1_LINPRO
			TMP1->PC1_VLRLIT := PC1->PC1_VLRLIT
			TMP1->PC1_RECNO  := PC1->( RECNO() )
			MsUnLock("TMP1")
			DbSelectArea("PC1")
			PC1->( DbSkip() )
		EndDo
	EndIf

	DbSelectArea("LBF")
	DbSetOrder(1)

	DbSelectArea("PC2")
	DbSetOrder(1)
	If DbSeek(_cFilPC2+_cNum)
		lManut := .F.
		While PC2->( !EOF() ) .And. _cFilPC2 + _cNum == PC2->PC2_FILIAL + PC2->PC2_NUMSEQ
			LBF->( DbSeek(xFilial("LBF") + PC2->PC2_CODTAN ))
			DbSelectArea("TMP2")
			RecLock("TMP2",.T.)
			TMP2->PC2_FILIAL := PC2->PC2_FILIAL
			TMP2->PC2_NUMSEQ := PC2->PC2_NUMSEQ
			TMP2->PC2_ROTA	 := PC2->PC2_ROTA
			TMP2->PC2_DESCRI := RetField("LBC",1,xFilial("LBC") + PC2->PC2_ROTA ,"LBC->LBC_DESC")
			TMP2->PC2_QTDMED := PC2->PC2_QTDMED
			TMP2->PC2_CARSUB := PC2->PC2_CARSUB
			TMP2->PC2_DESSUB := RetField("LBE",2,xFilial("LBE") + PC2->PC2_CARSUB ,"LBE->LBE_MOTO")
			TMP2->PC2_CODTAN := PC2->PC2_CODTAN
			TMP2->PC2_QTDLIT := PC2->PC2_QTDLIT
			TMP2->PC2_NOMFOR := RetField("LBB",1,xFilial("LBB") + LBF->LBF_CODPRO ,"LBB->LBB_NOMFOR")
			TMP2->PC2_NOMPRO := RetField("LBB",1,xFilial("LBB") + LBF->LBF_CODPRO ,"LBB->LBB_DESC")
			TMP2->PC2_ROTTAN := PC2->PC2_ROTTAN
			TMP2->PC2_VLRLIT := PC2->PC2_VLRLIT
			TMP2->PC2_RECNO  := PC2->( RECNO() )
			MsUnLock("TMP2")
			DbSelectArea("PC2")
			PC2->( DbSkip() )
		EndDo
	Else
		lManut := .T.
	EndIf

	RestArea( aArea )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GrvMod1   ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava recebimento modelo 1                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvMod1()
	Local nX       := 0
	Private bCampo := { |nField| FieldName(nField) }

//+----------------
//| Se for inclusao
//+----------------
	If nOpc == 3
	//+------------------
	//| Grava o Cabecalho
	//+------------------
		dbSelectArea("PC0")
		RecLock("PC0",.T.)
		For nX := 1 To FCount()
			If "FILIAL" $ FieldName(nX)
				FieldPut(nX,xFilial("PC0"))
			ElseIf "TPENTR" $ FieldName(nX)
				FieldPut(nX,"2")
			ElseIf "QTDDIF" $ FieldName(nX)
				FieldPut(nX, (M->PC0_QTDAPO - M->PC0_QTDMED) )
			Else
				FieldPut(nX,M->&(Eval(bCampo,nX)))
			Endif
		Next nX
		MsUnLock()
	Endif

//+----------------
//| Se for exclucao
//+----------------
	If nOpc == 5
	//+-------------------
	//| Deleta o Cabecalho
	//+-------------------
		dbSelectArea("PC0")
		RecLock("PC0")
		dbDelete()
		MsUnLock()
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GrvTMP1   ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava LINHA LEITE                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvTMP1(_nOpc,_cAlias)

	Local nI     := 0
	Local nY     := 0
	Local cVar   := ""
	Local lOk    := .T.
	Local cMsg   := ""
	Local nPos   := 0
	Local aAux   := {}
	Local cNum   := M->PC0_NUMSEQ
	Local cLin   := M->PC1_LINHA
	Local nTMed  := 0
	Local nTApo  := 0
	Local lAchou := .F.

	dbSelectArea(_cAlias)
	dbSetOrder(1)

	If _nOpc <> 2 //diferente de exclusao

		For nI := 1 To Len(oGetDad1:aCols)
			lAchou := dbSeek( xFilial("PC1") + cNum + cLin + oGetDad1:aCols[nI][Pesq("PC1_CODPRO",1)] )

			If !oGetDad1:aCols[nI][Len(aHeader1)+1]
				dbSelectArea(_cAlias)
				RecLock(_cAlias,Iif(lAchou,.F.,.T.))
				PC1_FILIAL := xFilial("PC1")
				PC1_NUMSEQ := M->PC0_NUMSEQ
				PC1_LINHA  := M->PC1_LINHA
				PC1_DESCRI := RetField("PA7",1,xFilial("PA7") + cLin ,"PA7->PA7_DESC")
				PC1_QTDMED := M->PC1_QTDMED
				PC1_CARSUB := M->PC1_CARSUB
				PC1_DESSUB := RetField("LBE",2,xFilial("LBE") + M->PC1_CARSUB ,"LBE->LBE_MOTO")
				PC1_VLRLIT := M->PC1_VLRLIT
              
				nTMed := M->PC1_QTDMED
            
				For nY = 1 to Len(aHeader1)
					If aHeader1[nY][10] # "V"
						cVar := Trim(aHeader1[nY][2])
						Replace &cVar. With oGetDad1:aCols[nI][nY]
						If cVar == "PC1_QTDLIT"
							nTApo := nTApo + oGetDad1:aCols[nI][nY]
						EndIf
					Else
						cVar := Trim(aHeader1[nY][2])
						If cVar == "PC1_NOMPRO"
							Replace &cVar. With RetField("LBB",1,xFilial("LBB") + oGetDad1:aCols[nI][Pesq("PC1_CODPRO",1)] ,"LBB->LBB_DESC")
						ElseIf cVar == "PC1_NOMFOR"
							Replace &cVar. With RetField("LBB",1,xFilial("LBB") + oGetDad1:aCols[nI][Pesq("PC1_CODPRO",1)] ,"LBB->LBB_NOMFOR")
						EndIf
					Endif
				Next nY
				MsUnLock(_cAlias)

			Else
				If !Found()
					Loop
				Endif
	      //Fazer pesquisa para saber se o item poderar ser deletado e
				If lOk
					If TMP1->PC1_RECNO > 0
						aAdd( aRecDel1,{"PC1",cNum,cLin,TMP1->PC1_RECNO,TMP1->PC1_QTDLIT,M->PC0_DTENTR})
					EndIf
					RecLock(_cAlias,.F.)
					dbDelete()
					MsUnLock(_cAlias)
				Else
					cMsg := "Nao foi possivel deletar a propriedade "+oGetDad1:aCols[nI][Pesq("PC1_CODPRO",1)]+", o mesmo possui amarracao"
					Help("",1,"","NAOPODE",cMsg,1,0)
				Endif
			Endif
		Next nI

	Else
		dbSelectArea(_cAlias)
		dbSetOrder(1)
		For nI = 1 to Len(oGetDad1:aCols)
			If dbSeek( xFilial("PC1") + cNum + cLin )
				If TMP1->PC1_RECNO > 0
					aAdd( aRecDel1,{"PC1",cNum,cLin,TMP1->PC1_RECNO,TMP1->PC1_QTDLIT,M->PC0_DTENTR})
				EndIf
				RecLock(_cAlias,.F.)
				dbDelete()
				MsUnLock(_cAlias)
			EndIf
		Next nI
   
	EndIf

//atualiza vetor1
	If dbSeek( xFilial("PC1") + cNum + cLin )
		nPos := aScan(aVetor1,{|x|AllTrim(x[1]) == cLin })
		If nPos > 0
			aVetor1[nPos][1] := cLin
			aVetor1[nPos][2] := RetField("PA7",1,xFilial("PA7") + cLin ,"PA7->PA7_DESC")
			aVetor1[nPos][3] := nTApo
			aVetor1[nPos][4] := nTMed
			aVetor1[nPos][5] := (nTApo - nTMed)
		Else
			If Empty(aVetor1[1][1])
				aVetor1[1][1] := cLin
				aVetor1[1][2] := RetField("PA7",1,xFilial("PA7") + cLin ,"PA7->PA7_DESC")
				aVetor1[1][3] := nTApo
				aVetor1[1][4] := nTMed
				aVetor1[1][5] := (nTApo - nTMed)
			Else
				aAdd( aVetor1,{cLin,RetField("PA7",1,xFilial("PA7") + cLin ,"PA7->PA7_DESC"),;
					nTApo,nTMed,(nTApo - nTMed) })
			EndIf
		EndIf
	Else

		aAux := {}
		For nI := 1 to Len(aVetor1)
			If aVetor1[nI][1] <> cLin
				aAdd( aAux ,{ aVetor1[nI][1],aVetor1[nI][2],aVetor1[nI][3],aVetor1[nI][4],aVetor1[nI][5] })
			EndIf
		Next nI

		aVetor1 := aClone(aAux)

		If Len(aVetor1) == 0
			aAdd( aVetor1, {CriaVar("PC0_LINROT",.T.),CriaVar("PC0_DESCRI",.T.),CriaVar("PC0_QTDAPO",.T.),CriaVar("PC0_QTDMED",.T.),CriaVar("PC0_QTDDIF",.T.)})
		EndIf

	EndIf

	nTotMedLin  := 0     //total medido linha
	nTotApoLin  := 0     //total apontado linha
	nTotDifLin  := 0     //total diferenca linha

	For nI := 1 to Len(aVetor1)
		nTotMedLin := nTotMedLin + aVetor1[nI][4]    //total medido linha
		nTotApoLin := nTotApoLin + aVetor1[nI][3]    //total apontado linha
	Next nI

	nTotDifLin := (nTotApoLin - nTotMedLin)     //total diferenca linha

	oTotMedLin:Refresh()
	oTotApoLin:Refresh()
	oTotDifLin:Refresh()
	oLbx1:SetArray( aVetor1 )
	oLbx1:bLine := {|| {aVetor1[oLbx1:nAt,1],aVetor1[oLbx1:nAt,2],aVetor1[oLbx1:nAt,3],aVetor1[oLbx1:nAt,4],aVetor1[oLbx1:nAt,5]}}
	oLbx1:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GrvTMP2   ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava ROTA LEITE                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                   
Static Function GrvTMP2(_nOpc,_cAlias)

	Local nI     := 0
	Local nY     := 0
	Local cVar   := ""
	Local lOk    := .T.
	Local cMsg   := ""
	Local nPos   := 0
	Local aAux   := {}
	Local cNum   := M->PC0_NUMSEQ
	Local cRot   := M->PC2_ROTA
	Local nTMed  := 0
	Local nTApo  := 0
	Local lAchou := .F.

	DbSelectArea("LBF")
	DbSetOrder(1)

	dbSelectArea(_cAlias)
	dbSetOrder(1)

	If _nOpc <> 2 //diferente de exclusao

		For nI := 1 To Len(oGetDad2:aCols)
			lAchou := dbSeek( xFilial("PC2") + cNum + cRot + oGetDad2:aCols[nI][Pesq("PC2_CODTAN",2)] )

			If !oGetDad2:aCols[nI][Len(aHeader2)+1]
				dbSelectArea(_cAlias)
				RecLock(_cAlias,Iif(lAchou,.F.,.T.))
				PC2_FILIAL := xFilial("PC2")
				PC2_NUMSEQ := M->PC0_NUMSEQ
				PC2_ROTA  := M->PC2_ROTA
				PC2_DESCRI := RetField("LBC",1,xFilial("LBC") + cRot ,"LBC->LBC_DESC")
				PC2_QTDMED := M->PC2_QTDMED
				PC2_CARSUB := M->PC2_CARSUB
				PC2_DESSUB := RetField("LBE",2,xFilial("LBE") + M->PC2_CARSUB ,"LBE->LBE_MOTO")
				PC2_VLRLIT := M->PC2_VLRLIT
              
				nTMed := M->PC2_QTDMED
            
				For nY = 1 to Len(aHeader2)
					If aHeader2[nY][10] # "V"
						cVar := Trim(aHeader2[nY][2])
						Replace &cVar. With oGetDad2:aCols[nI][nY]
						If cVar == "PC2_QTDLIT"
							nTApo := nTApo + oGetDad2:aCols[nI][nY]
						EndIf
					Else
						cVar := Trim(aHeader2[nY][2])
						If cVar == "PC2_NOMPRO"
							LBF->( DbSeek(xFilial("LBF") + oGetDad2:aCols[nI][Pesq("PC2_CODTAN",2)] ))
							Replace &cVar. With RetField("LBB",1,xFilial("LBB") + LBF->LBF_CODPRO ,"LBB->LBB_DESC")

						ElseIf cVar == "PC2_NOMFOR"
							LBF->( DbSeek(xFilial("LBF") + oGetDad2:aCols[nI][Pesq("PC2_CODTAN",2)] ))
							Replace &cVar. With RetField("LBB",1,xFilial("LBB") + LBF->LBF_CODPRO ,"LBB->LBB_NOMFOR")

						EndIf
					Endif
				Next nY
				MsUnLock(_cAlias)

			Else
				If !Found()
					Loop
				Endif
	      //Fazer pesquisa para saber se o item poderar ser deletado e
				If lOk
					If TMP2->PC2_RECNO > 0
						aAdd( aRecDel2,{"PC2",cNum,cRot,TMP2->PC2_RECNO,TMP2->PC2_QTDLIT,M->PC0_DTENTR,TMP2->PC2_CODTAN})
					EndIf
					RecLock(_cAlias,.F.)
					dbDelete()
					MsUnLock(_cAlias)
				Else
					cMsg := "Nao foi possivel deletar a propriedade "+oGetDad2:aCols[nI][Pesq("PC2_CODTAN",2)]+", o mesmo possui amarracao"
					Help("",1,"","NAOPODE",cMsg,1,0)
				Endif
			Endif
		Next nI

	Else
		dbSelectArea(_cAlias)
		dbSetOrder(1)
		For nI = 1 to Len(oGetDad2:aCols)
			If dbSeek( xFilial("PC2") + cNum + cRot )
				If TMP2->PC2_RECNO > 0
					aAdd( aRecDel2,{"PC2",cNum,cRot,TMP2->PC2_RECNO,TMP2->PC2_QTDLIT,M->PC0_DTENTR,TMP2->PC2_CODTAN})
				EndIf
				RecLock(_cAlias,.F.)
				dbDelete()
				MsUnLock(_cAlias)
			EndIf
		Next nI
   
	EndIf

//atualiza vetor2
	If dbSeek( xFilial("PC2") + cNum + cRot )
		nPos := aScan(aVetor2,{|x|AllTrim(x[1]) == cRot })
		If nPos > 0
			aVetor2[nPos][1] := cRot
			aVetor2[nPos][2] := RetField("LBC",1,xFilial("LBC") + cRot ,"LBC->LBC_DESC")
			aVetor2[nPos][3] := nTApo
			aVetor2[nPos][4] := nTMed
			aVetor2[nPos][5] := (nTApo - nTMed)
		Else
			If Empty(aVetor2[1][1])
				aVetor2[1][1] := cRot
				aVetor2[1][2] := RetField("LBC",1,xFilial("LBC") + cRot ,"LBC->LBC_DESC")
				aVetor2[1][3] := nTApo
				aVetor2[1][4] := nTMed
				aVetor2[1][5] := (nTApo - nTMed)
			Else
				aAdd( aVetor2,{cRot,RetField("LBC",1,xFilial("LBC") + cRot ,"LBC->LBC_DESC"),;
					nTApo,nTMed,(nTApo - nTMed) })
			EndIf
		EndIf
	Else

		aAux := {}
		For nI := 1 to Len(aVetor2)
			If aVetor2[nI][1] <> cRot
				aAdd( aAux ,{ aVetor2[nI][1],aVetor2[nI][2],aVetor2[nI][3],aVetor2[nI][4],aVetor2[nI][5] })
			EndIf
		Next nI

		aVetor2 := aClone(aAux)

		If Len(aVetor2) == 0
			aAdd( aVetor2, {CriaVar("PC0_LINROT",.T.),CriaVar("PC0_DESCRI",.T.),CriaVar("PC0_QTDAPO",.T.),CriaVar("PC0_QTDMED",.T.),CriaVar("PC0_QTDDIF",.T.)})
		EndIf

	EndIf

	nTotMedRot  := 0     //total medido rota
	nTotApoRot  := 0     //total apontado rota
	nTotDifRot  := 0     //diferenca rota

	For nI := 1 to Len(aVetor2)
		nTotMedRot := nTotMedRot + aVetor2[nI][4]    //total medido ROTA
		nTotApoRot := nTotApoRot + aVetor2[nI][3]    //total apontado ROTA
	Next nI

	nTotDifRot := (nTotApoRot - nTotMedRot)     //total diferenca ROTA

	oTotMedRot:Refresh()
	oTotApoRot:Refresh()
	oTotDifRot:Refresh()

	oLbx2:SetArray( aVetor2 )
	oLbx2:bLine := {|| {aVetor2[oLbx2:nAt,1],aVetor2[oLbx2:nAt,2],aVetor2[oLbx2:nAt,3],aVetor2[oLbx2:nAt,4],aVetor2[oLbx2:nAt,5]}}
	oLbx2:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GrvEnt    ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava ENTRADA DE LEITE                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                   
Static Function GrvEnt(cAcao)

	Local nI      := 0
	Local nY      := 0
	Local cVar    := ""
	Local lOk     := .T.
	Local cMsg    := ""
	Local nPos    := 0
	Local aAux    := {}
	Local lAchou  := .F.
	Local cNum    := M->PC0_NUMSEQ

	DbSelectArea("LBF")
	DbSetOrder(1)

	If cAcao == 1 //1 - INCLUSAO ROTINA REC.MOD2 / 2 - DETALHE (ALTERACAO)
    
	//GRAVA PC0
		dbSelectArea("PC0")
		dbSetOrder(1)
		DbSeek( xFilial("PC0") + cNum + DtoS(M->PC0_DTENTR) )
		If Found()
			lAchou := .F.
		Else
			lAchou := .T.
		EndIf

		For nI := 1 to Len(aVetor1)
			RecLock("PC0",lAchou)
			PC0->PC0_FILIAL := xFilial("PC0")
			PC0->PC0_NUMSEQ := M->PC0_NUMSEQ
			PC0->PC0_DTENTR := M->PC0_DTENTR
			PC0->PC0_TPENTR := "1"
			PC0->PC0_LINROT := aVetor1[nI][1]
			PC0->PC0_DESCRI := aVetor1[nI][2]
			PC0->PC0_QTDAPO := aVetor1[nI][3]
			PC0->PC0_QTDMED := aVetor1[nI][4]
			PC0->PC0_QTDDIF := aVetor1[nI][5]
			MsUnLock("PC0")
		Next nI

		For nI := 1 to Len(aVetor2)
			RecLock("PC0",lAchou)
			PC0->PC0_FILIAL := xFilial("PC0")
			PC0->PC0_NUMSEQ := M->PC0_NUMSEQ
			PC0->PC0_DTENTR := M->PC0_DTENTR
			PC0->PC0_TPENTR := "2"
			PC0->PC0_LINROT := aVetor2[nI][1]
			PC0->PC0_DESCRI := aVetor2[nI][2]
			PC0->PC0_QTDAPO := aVetor2[nI][3]
			PC0->PC0_QTDMED := aVetor2[nI][4]
			PC0->PC0_QTDDIF := aVetor2[nI][5]
			MsUnLock("PC0")
		Next nI

    //GRAVA PC1
		DbSelectArea("PC1")
		DbSetOrder(1)
		DbSeek( xFilial("PC1") + cNum )
		If Found()
			lAchou := .F.
		Else
			lAchou := .T.
		EndIf

		DbSelectArea("TMP1")
		DbGoTop()

		While TMP1->( !Eof() )
			DbSelectArea("PC1")
			RecLock("PC1",lAchou)
			PC1->PC1_FILIAL := TMP1->PC1_FILIAL
			PC1->PC1_NUMSEQ := TMP1->PC1_NUMSEQ
			PC1->PC1_LINHA  := TMP1->PC1_LINHA
			PC1->PC1_QTDMED := TMP1->PC1_QTDMED
			PC1->PC1_CARSUB := TMP1->PC1_CARSUB
			PC1->PC1_CODPRO := TMP1->PC1_CODPRO
			PC1->PC1_QTDLIT := TMP1->PC1_QTDLIT
			PC1->PC1_VLRLIT := TMP1->PC1_VLRLIT
			MsUnLock("PC1")
			DbSelectArea("TMP1")
			TMP1->( DbSkip() )
		EndDo
    
    //GRAVA PC2
		DbSelectArea("PC2")
		DbSetOrder(1)
		DbSeek( xFilial("PC2") + cNum )
		If Found()
			lAchou := .F.
		Else
			lAchou := .T.
		EndIf

		DbSelectArea("TMP2")
		DbGoTop()

		While TMP2->( !Eof() )
			DbSelectArea("PC2")
			RecLock("PC2",lAchou)
			PC2->PC2_FILIAL := TMP2->PC2_FILIAL
			PC2->PC2_NUMSEQ := TMP2->PC2_NUMSEQ
			PC2->PC2_ROTA   := TMP2->PC2_ROTA
			PC2->PC2_QTDMED := TMP2->PC2_QTDMED
			PC2->PC2_CARSUB := TMP2->PC2_CARSUB
			PC2->PC2_CODTAN := TMP2->PC2_CODTAN
			PC2->PC2_QTDLIT := TMP2->PC2_QTDLIT
			PC2->PC2_VLRLIT := TMP2->PC2_VLRLIT
			MsUnLock("PC2")
			If lAchou
				aAdd( aRecInc,{TMP2->PC2_NUMSEQ,M->PC0_DTENTR,TMP2->PC2_CODTAN,TMP2->PC2_QTDLIT})  //vetor para utilizar na execauto
			EndIf
			DbSelectArea("TMP2")
			TMP2->( DbSkip() )
		EndDo

	Else
    
	//apaga registros de PC1 e PC0 que foram excluidos na alteracao
		If Len(aRecDel1) > 0
			For nI := 1 to Len(aRecDel1)
				DbSelectArea( aRecDel1[nI][1] )
				DbGoTo( aRecDel1[nI][4] )
				RecLock(aRecDel1[nI][1],.F.)
				dbDelete()
				MsUnLock(aRecDel1[nI][1])
			
				DbSetOrder(1)
				If !DbSeek( xFilial("PC1") + aRecDel1[nI][2] + aRecDel1[nI][3] ) // filial+num+linha
					DbSelectArea("PC0")
					DbSetOrder(1)
					If DbSeek( xFilial("PC0") + aRecDel1[nI][2] + DtoS(M->PC0_DTENTR) + "1" + aRecDel1[nI][3] )
						RecLock("PC0",.F.)
						dbDelete()
						MsUnLock("PC0")
					EndIf
				EndIf
			
			Next nI
		EndIf
    
	//apaga registros de PC2 e PC0 que foram excluidos na alteracao
		If Len(aRecDel2) > 0
			For nI := 1 to Len(aRecDel2)
				DbSelectArea( aRecDel2[nI][1] )
				DbGoTo( aRecDel2[nI][4] )
				RecLock(aRecDel2[nI][1],.F.)
				dbDelete()
				MsUnLock(aRecDel2[nI][1])
		
				DbSetOrder(1)
				If !DbSeek( xFilial("PC2") + aRecDel2[nI][2] + aRecDel2[nI][3] ) // filial+num+rota
					DbSelectArea("PC0")
					DbSetOrder(1)
					If DbSeek( xFilial("PC0") + aRecDel2[nI][2] + DtoS(M->PC0_DTENTR) + "2" + aRecDel2[nI][3] )
						RecLock("PC0",.F.)
						dbDelete()
						MsUnLock("PC0")
					EndIf
				EndIf
	
			Next nI
		EndIf

	//GRAVA PC0
		dbSelectArea("PC0")
		dbSetOrder(1)
		For nI := 1 to Len(aVetor1)
			DbSeek( xFilial("PC0") + cNum + DtoS(M->PC0_DTENTR) + "1" + aVetor1[nI][1] )
			If Found()
				lAchou := .F.
			Else
				lAchou := .T.
			EndIf
			RecLock("PC0",lAchou)
			PC0->PC0_FILIAL := xFilial("PC0")
			PC0->PC0_NUMSEQ := M->PC0_NUMSEQ
			PC0->PC0_DTENTR := M->PC0_DTENTR
			PC0->PC0_TPENTR := "1"
			PC0->PC0_LINROT := aVetor1[nI][1]
			PC0->PC0_DESCRI := aVetor1[nI][2]
			PC0->PC0_QTDAPO := aVetor1[nI][3]
			PC0->PC0_QTDMED := aVetor1[nI][4]
			PC0->PC0_QTDDIF := aVetor1[nI][5]
			MsUnLock("PC0")
		Next nI

		For nI := 1 to Len(aVetor2)
			DbSeek( xFilial("PC0") + cNum + DtoS(M->PC0_DTENTR) + "2" + aVetor2[nI][1] )
			If Found()
				lAchou := .F.
			Else
				lAchou := .T.
			EndIf
			RecLock("PC0",lAchou)
			PC0->PC0_FILIAL := xFilial("PC0")
			PC0->PC0_NUMSEQ := M->PC0_NUMSEQ
			PC0->PC0_DTENTR := M->PC0_DTENTR
			PC0->PC0_TPENTR := "2"
			PC0->PC0_LINROT := aVetor2[nI][1]
			PC0->PC0_DESCRI := aVetor2[nI][2]
			PC0->PC0_QTDAPO := aVetor2[nI][3]
			PC0->PC0_QTDMED := aVetor2[nI][4]
			PC0->PC0_QTDDIF := aVetor2[nI][5]
			MsUnLock("PC0")
		Next nI
	

    //GRAVA PC1
		DbSelectArea("TMP1")
		DbGoTop()
		While TMP1->( !Eof() )
			DbSelectArea("PC1")
			DbSetOrder(1)
			DbSeek( xFilial("PC1") + cNum + TMP1->PC1_LINHA + TMP1->PC1_CODPRO )
			If Found()
				lAchou := .F.
			Else
				lAchou := .T.
			EndIf
			RecLock("PC1",lAchou)
			PC1->PC1_FILIAL := TMP1->PC1_FILIAL
			PC1->PC1_NUMSEQ := TMP1->PC1_NUMSEQ
			PC1->PC1_LINHA  := TMP1->PC1_LINHA
			PC1->PC1_QTDMED := TMP1->PC1_QTDMED
			PC1->PC1_CARSUB := TMP1->PC1_CARSUB
			PC1->PC1_CODPRO := TMP1->PC1_CODPRO
			PC1->PC1_QTDLIT := TMP1->PC1_QTDLIT
			PC1->PC1_VLRLIT := TMP1->PC1_VLRLIT
			MsUnLock("PC1")
			DbSelectArea("TMP1")
			TMP1->( DbSkip() )
		EndDo

    
    //GRAVA PC2
		DbSelectArea("TMP2")
		DbGoTop()
		While TMP2->( !Eof() )
			DbSelectArea("PC2")
			DbSetOrder(1)
			DbSeek( xFilial("PC2") + cNum + TMP2->PC2_ROTA + TMP2->PC2_CODTAN )
			If Found()
				lAchou := .F.
			Else
				lAchou := .T.
			EndIf
			RecLock("PC2",lAchou)
			PC2->PC2_FILIAL := TMP2->PC2_FILIAL
			PC2->PC2_NUMSEQ := TMP2->PC2_NUMSEQ
			PC2->PC2_ROTA   := TMP2->PC2_ROTA
			PC2->PC2_QTDMED := TMP2->PC2_QTDMED
			PC2->PC2_CARSUB := TMP2->PC2_CARSUB
			PC2->PC2_CODTAN := TMP2->PC2_CODTAN
			PC2->PC2_QTDLIT := TMP2->PC2_QTDLIT
			PC2->PC2_VLRLIT := TMP2->PC2_VLRLIT
			MsUnLock("PC2")
			If lAchou
				aAdd( aRecInc,{TMP2->PC2_NUMSEQ,M->PC0_DTENTR,TMP2->PC2_CODTAN,TMP2->PC2_QTDLIT})  //vetor para utilizar na execauto
			EndIf
			DbSelectArea("TMP2")
			TMP2->( DbSkip() )
		EndDo

	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FAtuEst   ³ Autor ³Microsiga              ³ Data ³20/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ ExecAuto Movimento interno mod1                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                   
Static Function FAtuEst()

	Local aAtuEst  := {}
	Local nI       := 0

	If Len(aRecDel2) > 0
		For nI := 1 to Len(aRecDel2)
	
		//cadastro de tanque
			DbSelectArea("LBF")
			DbSetOrder(1)
			DbSeek( xFilial("LBF")+aRecDel2[nI][7] )
		
		//cadastro de tipo de lete
			DbSelectArea("LBN")
			DbSetOrder(1)
			DbSeek( xFilial("LBN")+LBF->LBF_TIPOL )
		
		//cadastro de PRODUTO
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek( xFilial("SB1")+LBN->LBN_PRODUT )
		
			aAtuEst := {}
		
			aAtuEst :=  {	{"D3_TM"		,GETMV("ES_TMESTLE")	,NIL},;
							{"D3_COD"		,SB1->B1_COD			,NIL},;
							{"D3_UM"		,SB1->B1_UM				,NIL},;
							{"D3_QUANT"		,aRecDel2[nI][5]		,".T."},;
							{"D3_LOCAL"		,SB1->B1_LOCPAD			,NIL},;
							{"D3_EMISSAO"	,aRecDel2[nI][6]		,NIL},;
							{"D3_NUMSEQ"	,ProxNum()				,NIL},;
							{"D3_ENTLEIT"	,aRecDel2[nI][2]		,NIL}}

			lMsErroAuto := .F.

			MSExecAuto({|x,y| mata240(x,y)},aAtuEst,3) //estorno

			If lMsErroAuto
				Mostraerro()
				DisarmTransaction()
			Endif

		Next nI
	EndIf


	If Len(aRecInc) > 0
		For nI := 1 to Len(aRecInc)
		//cadastro de tanque
			DbSelectArea("LBF")
			DbSetOrder(1)
			DbSeek( xFilial("LBF")+aRecInc[nI][3] )
		
		//cadastro de tipo de lete
			DbSelectArea("LBN")
			DbSetOrder(1)
			DbSeek( xFilial("LBN")+LBF->LBF_TIPOL )
		
		//cadastro de PRODUTO
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek( xFilial("SB1")+LBN->LBN_PRODUT )
		
			aAtuEst := {}
		
			aAtuEst :=  {	{"D3_TM"		,GETMV("ES_TMENTLE")	,NIL},;
							{"D3_COD"		,SB1->B1_COD			,NIL},;
							{"D3_UM"		,SB1->B1_UM				,NIL},;
							{"D3_QUANT"		,aRecInc[nI][4]			,".T."},;
							{"D3_LOCAL"		,SB1->B1_LOCPAD			,NIL},;
							{"D3_EMISSAO"	,aRecInc[nI][2]			,NIL},;
							{"D3_NUMSEQ"	,ProxNum()				,NIL},;
							{"D3_ENTLEIT"	,aRecInc[nI][1]			,NIL}}

			lMsErroAuto := .F.

			MSExecAuto({|x,y| mata240(x,y)},aAtuEst,3) //inclusao

			If lMsErroAuto
				Mostraerro()
				DisarmTransaction()
			Endif

		Next nI
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAA020   ºAutor  ³Microsiga           º Data ³  12/19/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidLn(dData,cLinha)

	Local lRet 		:= .F.
	Local cQuery	:= ""


	cQuery := "SELECT PC1_LINHA,PC0_DTENTR FROM "+  RetSqlName("PC1") + " PC1 "
	cQuery += "INNER JOIN " + RetSqlName("PC0") + " PC0 ON PC0_FILIAL=PC1_FILIAL AND PC0_NUMSEQ=PC1_NUMSEQ AND PC0_FILIAL='" + cFilAnt + "' AND PC0.D_E_L_E_T_='' "
	cQuery += "WHERE PC1_FILIAL='" + cFilAnt + "' AND PC0_DTENTR='" + dData + "' AND PC1_LINHA='" + cLinha + "' AND PC1.D_E_L_E_T_=''

	MemoWrite("C:\EDI\SA2.SQL",cQuery)

	cQuery := ChangeQuery( cQuery )

	If Select("QRYNFE") > 0
		dbSelectArea("QRYNFE")
		QRYNFE->(dbCloseArea())
	EndIf

	dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYNFE', .F., .T.)

	dbSelectArea("QRYNFE")
	dbGotop()

	If QRYNFE->( Eof() )
		lRet := .T.
	Else
		lRet := .T.
		IF cFilAnt <> '05' //REFERENTE CHAMADO 004611
			MsgStop("Ja existe Lancamento dessa Linha nessa Data !")
		EndIf
	End If

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAA020   ºAutor  ³Microsiga           º Data ³  12/19/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function ValidRt(dData,cRota)

	Local lRet 		:= .F.
	Local cQuery	:= ""


	cQuery := "SELECT PC2_ROTA,PC0_DTENTR FROM "+  RetSqlName("PC2") + " PC2 "
	cQuery += "INNER JOIN " + RetSqlName("PC0") + " PC0 ON PC0_FILIAL=PC2_FILIAL AND PC0_NUMSEQ=PC2_NUMSEQ AND PC0_FILIAL='" + cFilAnt + "' AND PC0.D_E_L_E_T_='' "
	cQuery += "WHERE PC2_FILIAL='" + cFilAnt + "' AND PC0_DTENTR='" + dData + "' AND PC2_ROTA='" + cRota + "' AND PC2.D_E_L_E_T_=''

	MemoWrite("C:\EDI\SA2.SQL",cQuery)

	cQuery := ChangeQuery( cQuery )

	If Select("QRYNFE") > 0
		dbSelectArea("QRYNFE")
		QRYNFE->(dbCloseArea())
	EndIf

	dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYNFE', .F., .T.)

	dbSelectArea("QRYNFE")
	dbGotop()

	If QRYNFE->( Eof() )
		lRet := .T.
	Else
		lRet := .T.
		IF cFilAnt <> '05' //REFERENTE CHAMADO 004611 batata
			MsgStop("Ja existe Lancamento dessa Rota nessa Data !")
		EndIf
	End If

Return(lRet)

