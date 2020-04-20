#include "TopConn.ch"
#include "Protheus.ch"
#include "TbiConn.ch"
#include "Error.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOA14 ³ Autor ³ Manoel                ³ Data ³ 08/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Fechamento das Entradas de Leite                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CACCOA14()

//CHKTEMPLATE("COL")

//Variaveis privadas usadas no modelo 3
Private AROTINA, CCADASTRO, CALIAS, CTITULO, NTOTSENAR
Private NREG, NOPC, NOPCG
Private pPrefixo := alltrim(GetMV("MV_PREFDL"))
Private cEstado  := left(GetMV("MV_ESTADO"), 2)

Private cEmpOld := SM0->M0_CODIGO //Salva Empresa
Private cFilOld := SM0->M0_CODFIL //Salva Filial

nOpc:=0
aRotina :=	{{"Pesquisar"   , "axPesqui"     , 0, 1},; 
			 {"Visualizar"  , 'U_ChamaVz'    , 0, 2},;
			 {"Fechamento"  , 'U_CACOL114(3)', 0, 3}} 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCadastro := OemToAnsi("Rotina de Fechamento")
cAlias := "LBP"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse(06, 01, 22, 75, cAlias)
Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CHAMAVZ  ³ Autor ³ Manoel                ³ Data ³ 08/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Visualizacao do Fechamento                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN2 = Numero do registro                                 ³±±
±±³          ³ ExpN3 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                             		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ChamaVz(xA1,xA2,xA3)

Processa({|| CACO14Vz(xA1,xA2,xA3)})
Return(.T.)
    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CAC014VZ ³ Autor ³ Manoel                ³ Data ³ 11/06/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Visualizacao do Fechamento                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN2 = Numero do registro                                 ³±±
±±³          ³ ExpN3 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                             		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CACO14VZ(xA1,xA2,xA3)
Local nCntFor
Local bCampo := { |nCPO| Field(nCPO) }
Local nPosDesc := 0

DEFAULT xA2 := 1

SetPrvt("nOpc,aVetTipD,aVetDR")
SetPrvt("cCodProp,cDesProp,aColsPropr,aColsTotal,nLinhas,nTotDesp,nTotRece, nCusMedT, nCusMed,nTotGer,nCriosc")

cCodProp   := Space(6)
aCols      := {}
aColsPropr := {{Space(30),0,0,0,Space(1),"",.f.}}
aColsTotal := {{Space(30),0,0,0,Space(1),"",.f.}}

nUsado  := 0
aHeader := {}

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("LBQ")
While !Eof().And.(x3_arquivo=="LBQ")
	If Alltrim(x3_campo) $ "LBQ_DESC#LBQ_VALOR#LBQ_QTD#LBQ_FLAG#LBQ_PAGQUA"
		nUsado++
		Aadd(aHeader, {TRIM(X3Titulo()), x3_campo, x3_picture, x3_tamanho, x3_decimal, x3_valid,;
		x3_usado, x3_tipo, x3_arquivo, x3_context, x3_Relacao, x3_reserv })
		wVar  := "M->"+x3_campo
		&wVar := CriaVar(x3_campo)
		If(Alltrim(x3_campo) $ "LBQ_DESC",nPosDesc := nUsado,)
	Endif
	dbSkip()
Enddo

Aadd(aHeader, {"","EXTRA","",1,0,"","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","C","LBQ","V","","¹Ç"})
M->EXTRA := " "
nUsado++

DbSelectArea("LBP")
DbGoTo(xA2)
For nCntFor := 1 TO FCount()
	M->&(EVAL(bCampo,nCntFor)) := FieldGet(nCntFor)
Next

DbSelectArea("LBQ")
DbSetOrder(2)
Dbgotop()
DbSeek(xFilial("LBQ")+Dtos(LBP->LBP_DATINI))
nCusMedT  := 0
nCusMed   := 0
nTotRece  := 0
nTotDesp  := 0
nTotGer   := 0
nTotReceT := 0
nTotDespT := 0
nTotGerT  := 0
nContLBQ  := 0
ProcRegua(2000)

While !Eof() .and. xFilial("LBQ")+Dtos(LBP->LBP_DATINI) == LBQ->LBQ_FILIAL+Dtos(LBQ->LBQ_DATINI)
	incProc("Aguarde... Levantando dados da Base... " + strzero(nContLBQ++,9))
	
	nPos := Ascan(aCols,{|x| UPPER(AllTrim(x[nPosDesc])) == UPPER(AllTrim(LBQ->LBQ_DESC)) })
	If nPos > 0
		aCols[nPos,3] := aCols[nPos,3] + FieldGet(FieldPos(aHeader[3,2]))
		aCols[nPos,4] := aCols[nPos,4] + FieldGet(FieldPos(aHeader[4,2]))
		aCols[nPos,5] := aCols[nPos,5] + FieldGet(FieldPos(aHeader[5,2]))
	Else
		AADD(aCols,Array(nUsado+1))
		aCols[Len(aCols),1] := FieldGet(FieldPos(aHeader[1,2]))
		aCols[Len(aCols),2] := FieldGet(FieldPos(aHeader[2,2]))
		aCols[Len(aCols),3] := FieldGet(FieldPos(aHeader[3,2]))
		aCols[Len(aCols),4] := FieldGet(FieldPos(aHeader[4,2]))
		aCols[Len(aCols),5] := FieldGet(FieldPos(aHeader[5,2]))
		aCols[Len(aCols),6] := " "
	    nPos := Len(aCols)
	Endif
	
	aCols[Len(aCols),nUsado+1]:=.F.
	
	If LBQ->LBQ_CRIQUA <> "S" // ignora criterios da qualidade na soma de totais
		If UPPER(Alltrim(aCols[nPos,1])) == "D" // DESPESAS // acertar aqui PRICILA
			nTotDespT += Noround(LBQ->LBQ_VALOR,2)
		Else
			nTotReceT += Noround(LBQ->LBQ_VALOR,2)
		Endif
	EndIf
	If LBQ->LBQ_CRIQUA <> "S" .And. LBQ->LBQ_PAGQUA <> 0  // retira o pagto.da qualidade do valor (so' na tela)
		If Upper(AllTrim(aHeader[3,2])) == "LBQ_VALOR"
			aCols[nPos,3] := aCols[nPos,3] - LBQ->LBQ_PAGQUA
		ElseIf Upper(AllTrim(aHeader[4,2])) == "LBQ_VALOR"
			aCols[nPos,4] := aCols[nPos,4] - LBQ->LBQ_PAGQUA
		EndIf
    EndIf

	DbSkip()
	
Enddo

aColsTotal := {{Space(30),0,0,0,Space(1),"",.f.}}
aColsTotal := aClone(aCols)
nTotGerT   := nTotReceT - nTotDespT

cTitulo    :=OemToAnsi("Receitas/Despesas")
cAliasGetd :="LBQ"
cAlias     :="LBQ"
cLinOk     :="AllwaysTrue()"
cTudOk     :="AllwaysTrue()"
cFieldOk   :="AllwaysTrue()"
nLinhas    := 99
nOpcG      := 2
nOpc       := 2
nOpca      := 0

DEFINE MSDIALOG oDlg TITLE cTitulo From 12,14 to 40,104	of oMainWnd
SetEnch("")
@ 014,001 FOLDER oFolder SIZE 356,196 OF oDlg PROMPTS "Total","Por Propriedade" PIXEL

INIFOLDER("oFolder")

nCusMedT := 0
nCusMed  := 0

FS_ABA(1,.F.)
oGetTotal := MsGetDados():New(001,001,148,353,nOpcG,cLinOk,cTudOk,"",.T.,,,,nLinhas,cFieldOk,,,,oFolder:aDialogs[1])
oGetTotal:nMax:=Len(aCols) // maximo de linhas por getdados de entrada.
@ 169,004 SAY OemToAnsi("Total Despesas") of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE
@ 169,044 MSGET oTotDespT VAR nTotDespT PICTURE "@E 9,999,999.99"  SIZE 44,4 OF oFolder:aDialogs[1] PIXEL COLOR CLR_BLACK  when .f.
@ 169,092 SAY OemToAnsi("Total Receitas") of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE
@ 169,132 MSGET oTotReceT VAR nTotReceT PICTURE "@E 9,999,999.99"  SIZE 44,4 OF oFolder:aDialogs[1] PIXEL COLOR CLR_BLACK  when .f.
@ 169,180 SAY OemToAnsi("Total Geral") of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE
@ 169,210 MSGET oTotGerT  VAR nTotGerT  PICTURE "@E 9,999,999.99"  SIZE 44,4 OF oFolder:aDialogs[1] PIXEL COLOR CLR_BLACK  when .f.
@ 169,260 SAY OemToAnsi("Custo Medio") of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE
@ 169,300 MSGET oCusMedT  VAR nCusMedT  PICTURE "@E 9,999.999999"  SIZE 44,4 OF oFolder:aDialogs[1] PIXEL COLOR CLR_BLACK  when .f.

FS_ABA(2)
@ 001,004 SAY OemToAnsi("Propriedade") of oFolder:aDialogs[2] PIXEL COLOR CLR_BLUE
@ 001,044 MSGET oCodProp VAR cCodProp  PICTURE "@!" F3 "LBB" VALID VZPropr().and.VZPropr() SIZE 40,4 OF oFolder:aDialogs[2] PIXEL COLOR CLR_BLACK
@ 001,090 MSGET oDesProp VAR cDesProp  PICTURE "@!" SIZE 70,4 OF oFolder:aDialogs[2] PIXEL COLOR CLR_BLACK when .f.
oGetPropr := MsGetDados():New(013,001,163,353,nOpcG,cLinOk,cTudOk,"",.T.,,,,nLinhas,cFieldOk,,,,oFolder:aDialogs[2])

DbSelectArea("LBB")
DbSetorder(1)
DbSeek(xFilial("LBB")+LBP->LBP_CODPRO)
cDesProp := LBB->LBB_NOMFOR
cCodProp := LBP->LBP_CODPRO

@ 169,004 SAY OemToAnsi("Total Despesas") of oFolder:aDialogs[2] PIXEL COLOR CLR_BLUE
@ 169,044 MSGET oTotDesp VAR nTotDesp PICTURE "@E 9,999,999.99"  SIZE 44,4 OF oFolder:aDialogs[2] PIXEL COLOR CLR_BLACK  when .f.
@ 169,092 SAY OemToAnsi("Total Receitas") of oFolder:aDialogs[2] PIXEL COLOR CLR_BLUE
@ 169,132 MSGET oTotRece VAR nTotRece PICTURE "@E 9,999,999.99"  SIZE 44,4 OF oFolder:aDialogs[2] PIXEL COLOR CLR_BLACK  when .f.
@ 169,180 SAY OemToAnsi("Total Geral") of oFolder:aDialogs[2] PIXEL COLOR CLR_BLUE
@ 169,210 MSGET oTotGer  VAR nTotGer  PICTURE "@E 9,999,999.99"  SIZE 44,4 OF oFolder:aDialogs[2] PIXEL COLOR CLR_BLACK  when .f.
@ 169,260 SAY OemToAnsi("Custo Medio") of oFolder:aDialogs[2] PIXEL COLOR CLR_BLUE
@ 169,300 MSGET oCusMed  VAR nCusMed  PICTURE "@E 9,999.999999"  SIZE 44,4 OF oFolder:aDialogs[2] PIXEL COLOR CLR_BLACK  when .f.

oFolder:bSetOption := {|| FS_SETOPT(oFolder:nOption) }
oFolder:bChange    := {|| FS_ABA(oFolder:nOption) }
//ACTIVATE MSDIALOG oDlg ON INIT (EnChoiceBar(oDlg, {|| oDlg:End(), FS_SETOPT(oFolder:nOption)}, {|| aColsPropr := {}, oDlg:End()}) , FS_ABA(1))
ACTIVATE MSDIALOG oDlg ON INIT (EnChoiceBar(oDlg, {|| FS_SETOPT(oFolder:nOption),oDlg:End() }, {|| aColsPropr := {}, oDlg:End()}) , FS_ABA(1))
Return(.T.)
    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VZPropr  ³ Autor ³ Manoel                ³ Data ³ 08/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Visualiza por Propriedades                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite 		                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VZPropr()

Local lRet  := .t.
DbSelectArea("LBQ")
DbSetOrder(1)
Dbgotop()
If !DbSeek(xFilial("LBQ") + cCodProp + Dtos(LBP->LBP_DATINI))
	lRet := .f.
Endif

If lRet
	nCusMed  := 0
	nTotRece := 0
	nTotDesp := 0
	nTotGer  := 0
	aCols    := {}
	
	While !eof() .and. xFilial("LBQ") + cCodProp + Dtos(LBP->LBP_DATINI) == LBQ->LBQ_FILIAL + LBQ->LBQ_CODPRO + Dtos(LBQ->LBQ_DATINI)
		AADD(aCols,Array(7))
		aCols[Len(aCols),1] := FieldGet(FieldPos(aHeader[1,2]))
		aCols[Len(aCols),2] := FieldGet(FieldPos(aHeader[2,2]))
		aCols[Len(aCols),3] := FieldGet(FieldPos(aHeader[3,2]))
		aCols[Len(aCols),4] := FieldGet(FieldPos(aHeader[4,2]))
		aCols[Len(aCols),5] := FieldGet(FieldPos(aHeader[5,2]))
		aCols[Len(aCols),6] := " "
		aCols[Len(aCols),7] := .F.
		
		If LBQ->LBQ_CRIQUA <> "S" // ignora criterios da qualidade na soma de totais
			If UPPER(Alltrim(aCols[Len(aCols),1])) == "D" // DESPESAS
				nTotDesp += Noround(LBQ->LBQ_VALOR,2)
			Else
				nTotRece += Noround(LBQ->LBQ_VALOR,2)
			Endif
		EndIf
		If LBQ->LBQ_CRIQUA <> "S" .And. LBQ->LBQ_PAGQUA <> 0  // retira o pagto.da qualidade do valor (so' na tela)
			If Upper(AllTrim(aHeader[3,2])) == "LBQ_VALOR"
				aCols[Len(aCols),3] := aCols[Len(aCols),3] - LBQ->LBQ_PAGQUA
			ElseIf Upper(AllTrim(aHeader[4,2])) == "LBQ_VALOR"
				aCols[Len(aCols),4] := aCols[Len(aCols),4] - LBQ->LBQ_PAGQUA
			EndIf
		Endif
		
		DbSkip()
	EndDo
	
	nTotGer := nTotRece - nTotDesp
	
	DbSelectArea("LBB")
	DbSetorder(1)
	DbSeek(xFilial("LBB")+LBP->LBP_CODPRO)
	M->LBB_DESC := LBB->LBB_DESC
	
	oGetPropr:oBrowse:Refresh()
EndIf
Return(lRet)
           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CAC0L114 ³ Autor ³ Rogerio Faro          ³ Data ³ 08/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Fechamento de Periodo por Propriedade            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                             		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USer Function CACOL114(nOpc)

Local nCntFor
Local bCampo := { |nCPO| Field(nCPO) }
Local nAcao  := 0
Private nTotBQ   := 0 // Total de Bonificacao por Quantidade
Private nTotBG   := 0 // Total de Bonificacao a Granel
Private nTotBLT  := 0 // Total de Bonificacao por Linha/Tanque
Private nTotOC   := 0 // Total de Outros Creditos
Private dDatVenc := cTod("")
Private dDatIni  := cTod("")
Private dDatFin  := cTod("")
aCols 	  := {{Space(30),0,0,0,Space(1),"",.f.}}
nSaldo    := 0
lAtuCotaB := .f.
lGravou   := .f.
aVetProp  := {}
aVetFin   := {}
aVetCotB  := {}
aVetCotC  := {}
aSavCotB  := {}
cAlias    := "LBP"
cTitulo   := OemToAnsi("Fechamento do Periodo")
nReg      := 0

if nOpc == 2
	nOpcG  := 2
	nOpc   := 2
Else
	nOpcG  := 4
	nOpc   := 4
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis M->????? da Enchoice                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("LBP")
For nCntFor := 1 TO FCount()
	M->&(EVAL(bCampo,nCntFor)) := FieldGet(nCntFor)
Next

M->LBP_DESC := Space(30)
DEFINE MSDIALOG oDlg1 TITLE cTitulo From 4,34 to 19,70 of oMainWnd
//periodo do fechamento
@ 32,005 TO 67,140 LABEL "Periodo" OF oDlg1 PIXEL
@ 38,016 SAY OemToAnsi("Data Inicial") OF oDlg1 PIXEL COLOR CLR_BLUE
@ 38,080 MSGET oDatEnt VAR dDatIni PICTURE "@D" SIZE 47,4 OF oDlg1 PIXEL COLOR CLR_BLACK
@ 53,016 SAY OemToAnsi("Data Final") OF oDlg1 PIXEL COLOR CLR_BLUE
@ 53,080 MSGET oDatEnt VAR dDatFin PICTURE "@D" SIZE 47,4 OF oDlg1 PIXEL COLOR CLR_BLACK

//dia para geracao dos titulos
@ 69,005 TO 89,140 LABEL "Titulos" OF oDlg1 PIXEL
@ 75,016 SAY OemToAnsi("Vencimento") OF oDlg1 PIXEL COLOR CLR_BLUE
@ 75,080 MSGET oDatVenc VAR dDatVenc PICTURE "@D"  SIZE 47,4 OF oDlg1 PIXEL COLOR CLR_BLACK

oBtnF1 := tButton():New(93, 04, "Entradas"   , oDlg1, {|| Processa({|| DemCP()    })}, 045, 014,,,, .T.)
oBtnF2 := tButton():New(93, 50, "Cota B"   , oDlg1, {|| Processa({|| DemCotB()  })}, 045, 014,,,, .T.)
oBtnF2 := tButton():New(93, 96, "Relatorio"   , oDlg1, {|| Processa({|| RelPla()   })}, 045, 014,,,, .T.)

ACTIVATE MSDIALOG oDlg1 CENTERED ON INIT EnchoiceBar(oDlg1,{||nAcao := 1, oDlg1:End() }, {||nAcao := 0, oDlg1:End() })

If nAcao == 1 .And. VerDtFec() .and. FS_VldClas(dDatFin,dDatVenc)
	Processa({|| GrvCAC14(3)})
Endif

//Desliga Loop do Browse
MBRCHGLOOP(.F.)

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FS_VldClas³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Consiste datas para o Fechamento           		     	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FS_VldClas(ExpD1,ExpD2)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = data final                                         ³±±
±±³          ³ ExpD2 = data do vencto.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.		                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                             		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_VldClas(dDatFin,dDatVenc)

Local aArea := GetArea()
Local lRet  := .t.

If dDatFin <> dDataBase
	MsgStop("Data Base do sistema deve ser igual a Data Final do processamento !!!","Atenção")
	lRet := .f.
Endif

If Empty(dDatVenc)
	MsgStop("Data do Vencimento não pode ser branco !!!","Atenção")
	lRet := .f.
Endif

If lRet
	#IFDEF TOP
		cSql := "SELECT * FROM "
		cSql += RetSQLName("LBO") + " LBO "
		cSql += "WHERE LBO.LBO_TIPOL = ' " + "' AND "
		cSql += "LBO.LBO_FILIAL = '" + xFilial("LBO") + "' AND "
		cSql += "LBO.LBO_DATENT BETWEEN '" + DTOS(dDatIni) + "' AND '" + DTOS(dDatFin) + "' AND "
		cSql += "LBO.D_E_L_E_T_ = ' '"
		TCQUERY cSql NEW ALIAS "DAT"
		dbSelectArea("DAT")
		DbGoTop()
		If !Eof()
			MsgStop("Impossível realizar o fechamento!!!  Para que o fechamento possa ser realizado com sucesso é " + ; 
			"necessário classificar todas as entradas do periodo nas rotinas de classificação de leite B/C " + ; 
			"Para listar as entradas sem classificação execute o relatorio: ENT. NÃO CLASSIFICADAS","Atenção") 
			lRet  := .f.
		Endif
		DbCloseArea()
	#ENDIF
EndIf

RestArea(aArea)
Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ DemCP     ³ Autor ³  Manoel               ³ Data ³16/03/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Levantamento e Demonstrativo de Contas a Pagar              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DemCP(ExpL1)				                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = Refaz a tela ou nao                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.   	                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                             		   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DemCP(lRefaz)

Local nPos, i, x, x_, Cont
Local lPriVez    := .T.
Local nQtdProp   := 0
Local nAjuste    := 0
Local nTotBQT    := 0
Local cPgExce    := GetMv("MV_PGEXCE")
Local nLin       := 1
Local lOk
Local lTLeiPgQua := ExistBlock("TLEIPGQUA")
Local lPagaQuali := .T.
Local lRoundFUN  := SuperGetMv("MV_RNDFUN",.F.,.F.) == .T.
Local nTotLBCri  := 0
Local nTotLCCri  := 0
Local nTamSA2    := (TamSX3("A2_COD")[1] + TamSX3("A2_LOJA")[1])
Local nTamSA2C   := TamSX3("A2_COD")[1]
Local nTamSA2L   := TamSX3("A2_LOJA")[1]
//Local nTeorQ     := 0
//Local nTeorMin   := GetMv("MV_TEORMIN")
Local nTotB1  := 0 // Total de Leite B1
Local nTotB2  := 0 // Total de Leite B2
Local nTotB3  := 0 // Total de Leite B3
Local nTotEB1 := 0 // Total Excesso 1 B
Local nTotEB2 := 0 // Total Excesso 2 B
Local nTotEB3 := 0 // Total Excesso 3 B
Local nTotC1  := 0 // Total de Leite C1
Local nTotC2  := 0 // Total de Leite C2
Local nTotC3  := 0 // Total de Leite C3
Local nTotEC1 := 0 // Total Excesso 1 C
Local nTotEC2 := 0 // Total Excesso 2 C
Local nTotEC3 := 0 // Total Excesso 3 C
Local nTotBQ  := 0 // Total de Bonificacao por Quantidade
Local nTotBG  := 0 // Total de Bonificacao a Granel
Local nTotBLT := 0 // Total de Bonificacao por Linha/Tanque
Local nTotOC  := 0 // Total de Outros Creditos

Local nTotB1Qua  := 0 // Total Pag.Qualidade p/ Leite B1
Local nTotB2Qua  := 0 // Total Pag.Qualidade p/ Leite B2
Local nTotB3Qua  := 0 // Total Pag.Qualidade p/ Leite B3
Local nTotEB1Qua := 0 // Total Pag.Qualidade p/ Excesso 1 B
Local nTotEB2Qua := 0 // Total Pag.Qualidade p/ Excesso 2 B
Local nTotEB3Qua := 0 // Total Pag.Qualidade p/ Excesso 3 B
Local nTotC1Qua  := 0 // Total Pag.Qualidade p/ Leite C1
Local nTotC2Qua  := 0 // Total Pag.Qualidade p/ Leite C2
Local nTotC3Qua  := 0 // Total Pag.Qualidade p/ Leite C3
Local nTotEC1Qua := 0 // Total Pag.Qualidade p/ Excesso 1 C
Local nTotEC2Qua := 0 // Total Pag.Qualidade p/ Excesso 2 C
Local nTotEC3Qua := 0 // Total Pag.Qualidade p/ Excesso 3 C

Private cCodPr   := ""
Private nContLBO := 0

lRefaz := IIF(lRefaz == Nil, .F., lRefaz)

aVetProp   := {}
aVetCotC   := {}
aVetFin    := {}
aVetDR	   := {{Space(30),0,0,0,Space(1),"",.f.}}
aColsTotal := aCols
aColsPropr := aCols

If !lRefaz
	aRotina := {{OemToAnsi("Pesquisar" ), "axPesqui"     , 0, 1}, ;    && Pesquisar 
	{OemToAnsi("Visualizar"), 'U_CACOL114(2)', 0, 2}, ;    && Visualizar
	{OemToAnsi("Incluir"), 'U_CACOL114(3)', 0, 3}, ;    && Incluir
	{OemToAnsi("Alterar"), 'U_CACOL114(4)', 0, 4, 2}, ; && Alterar
	{OemToAnsi("Excluir"), 'U_CACOL114(5)', 0, 5, 1}}   && Excluir
EndIf

// Levantamento das Propriedades que entregaram Leite no Periodo
nVB1   := 0
nVB2   := 0
nVB3   := 0
nVC1   := 0
nVC2   := 0
nVC3   := 0
nVExc1 := 0
nVExc2 := 0
nVExc3 := 0
nVBon1 := 0
nVBon2 := 0
nVBon3 := 0
nVBon4 := 0
nVBon5 := 0
nVBon6 := 0
nVBon7 := 0
nVBon8 := 0
nVBon9 := 0

/*/
aVetProp
01- Codigo da Propriedade                                            
02- Quantidade Entregue                                              
03- Valor em B1				18- Qtd Leite B1			33- Crioscopia
04- Valor em B2				19- Qtd Leite B2			34- Taxa Capital
05- Valor em B3				20- Qtd Leite B3			35- Cota B
06- Valor Excesso B1		21- Qtd Excesso B1			36- Cota Total
07- Valor Excesso B2		22- Qtd Excesso B2			37- Tipo de Leite
08- Valor Excesso B3		23- Qtd Excesso B3			38- Nome do Fornecedor
09- Valor em C1				24- Qtd Leite C1			39- Cod. Cliente + Loja
10- Valor em C2				25- Qtd Leite C2			40- Bonif.  Gordura
11- Valor em C3				26- Qtd Leite C3			41- Bonif.  Proteina
12- Valor Excesso C1		27- Qtd Excesso C1			42- Bonif.  CCS
13- Valor Excesso C2		28- Qtd Excesso C2			43- Bonif.  CBT
14- Valor Excesso C3		29- Qtd Excesso C3			44- Redutor Gordura
15- Bonific.por Qtde.		30- Codigo da Rota			45- Redutor Proteina
16- Bonificacao a Granel	31- Valor do Frete			46- Redutor CCS 
17- Outros Creditos			32- Bonif.por Linha/Tanque	47- Redutor CBT
														48- Pagto.da Qualidade por litro
														49- S = Considerar o Pagto da Qualidade/  N = Nao considerar
/*/

nTotRegLBB := LBB->(reccount()) * ((dDatFin-dDatIni)+1)

DbSelectArea("LBO")
DbGoTop()
DbSetorder(2)
DbSeek(xFilial("LBO")+Dtos(dDatIni),.t.)

LBB->(dbGoTop())
LBB->(dbSetOrder(1))
LBB->(dbSeek(xFilial("LBB")+LBO->LBO_CODPRO))

LBH->(DbSelectArea("LBH"))
LBH->(dbSetOrder(1))

/* antigo calculo da gordura
If cCodPr # LBO->LBO_CODPRO
	cCodPr := LBO->LBO_CODPRO                      
	If LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+"GD"))
		nTeorG := (LBB->LBB_GORDUR - nTeorMin) /100 * LBH->LBH_VALOR
	Endif
EndIf
*/

if LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+"B1"))
	nVB1   := LBH->LBH_VALOR
Endif
if LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+"B2"))
	nVB2   := LBH->LBH_VALOR
Endif
if LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+"B3"))
	nVB3   := LBH->LBH_VALOR
Endif
if LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+if(LBB->LBB_QUENTE='S',"Q1","C1")))
	nVC1   := LBH->LBH_VALOR
Endif
if LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+if(LBB->LBB_QUENTE='S',"Q2","C2")))
	nVC2   := LBH->LBH_VALOR
Endif
if LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+if(LBB->LBB_QUENTE='S',"Q3","C3")))
	nVC3   := LBH->LBH_VALOR
Endif

// Define qual valor será utilizado para pagar o excesso
If AllTrim(cPgExce) == "S"
	if LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+"E1"))
		nVExc1 := LBH->LBH_VALOR
	Endif
	if LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+"E2"))
		nVExc2 := LBH->LBH_VALOR
	Endif
	if LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+"E3"))
		nVExc3 := LBH->LBH_VALOR
	Endif
Else
	If LBO->LBO_TIPOL == if(LBB->LBB_QUENTE='N',"C1","Q1")
		nVExc1 := nVC1
	Endif
	If LBO->LBO_TIPOL == if(LBB->LBB_QUENTE='N',"C2","Q2")
		nVExc2 := nVC2
	Endif
	If LBO->LBO_TIPOL == if(LBB->LBB_QUENTE='N',"C3","Q3")
		nVExc3 := nVC3
	Endif
Endif

if LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+"F1"))
	nVBon1 := LBH->LBH_VALOR
Endif
if LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+"F2"))
	nVBon2 := LBH->LBH_VALOR
Endif
if LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+"F3"))
	nVBon3 := LBH->LBH_VALOR
Endif
if LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+"F4"))
	nVBon4 := LBH->LBH_VALOR
Endif
if LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+"F5"))
	nVBon5 := LBH->LBH_VALOR
Endif
if LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+"F6"))
	nVBon6 := LBH->LBH_VALOR
Endif
if LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+"F7"))
	nVBon7 := LBH->LBH_VALOR
Endif
if LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+"F8"))
	nVBon8 := LBH->LBH_VALOR
Endif
if LBH->(dbSeek(xFilial("LBH")+LBB->LBB_EST+"F9"))
	nVBon9 := LBH->LBH_VALOR
Endif

ProcRegua(nTotRegLBB)

while !eof() .and. LBO->LBO_FILIAL == xFilial("LBO") .and. (LBO->LBO_DATENT >= dDatIni .and. LBO->LBO_DATENT <= dDatFin)
	IncProc("Aguarde... Levantando Entradas B e C... " + strzero(nContLBO++,9))
	
	LBB->(dbSetOrder(1))
	LBB->(dbSeek(xFilial("LBB")+LBO->LBO_CODPRO))
	If LBB->LBB_ATIVO == "N"
		dbSelectArea("LBO")
		dbSkip()
		Loop
	Endif
	
	LBD->(dbSetOrder(3))
	LBD->(dbSeek(xFilial("LBD")+LBO->LBO_CODPRO))

	dbSelectArea("LBO")
	nPos := Ascan(aVetProp,{|x| x[1] == LBO->LBO_CODPRO})


	if nPos == 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Obtem Acresc./Desconto por Litro pela Tab.Classif.da Qualidade  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		LJZ->(DbSelectArea("LJZ"))
		LJZ->(dbSetOrder(4))  // Propriedade + Data Ref
		LJZ->(dbSeek(xFilial("LJZ") + LBO->LBO_CODPRO + Left(Dtos(dDatIni),6)))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada para considerar ou nao o pagto pela Qualidade  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lPagaQuali := .T.
		If lTLeiPgQua
			lPagaQuali := Execblock("TLEIPGQUA",.F.,.F.,{LBO->LBO_CODPRO,LJZ->LJZ_PAGQUA})
			If ValType(lPagaQuali) <> "L"
				lPagaQuali := .T.
			EndIf
		EndIf

		Aadd(aVetProp,{LBO->LBO_CODPRO,LBO->LBO_VOLCRI,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,LBD->LBD_CODROT,0,0,0,0,; //34
		Posicione("LBB", 1, xFilial("LBB")+LBO->LBO_CODPRO,"LBB_COTAB*((dDatFin-dDatIni)+1)"),;  // 35
		Posicione("LBB", 1, xFilial("LBB")+LBO->LBO_CODPRO,"LBB_COTAT*((dDatFin-dDatIni)+1)"),;  // 36
		Posicione("LBB", 1, xFilial("LBB")+LBO->LBO_CODPRO,"LBB_TIPOL"),;
		Posicione("LBB", 1, xFilial("LBB")+LBO->LBO_CODPRO,"LBB_NOMFOR"),;
		Posicione("LBB", 1, xFilial("LBB")+LBO->LBO_CODPRO,"LBB_CODFOR+LBB_LOJA"),;
		0,0,0,0,0,0,0,0,If(lPagaQuali,LJZ->LJZ_PAGQUA,0),If(lPagaQuali,'S','N') })  // LJZ_PAGQUA: Resultado geral por litro (para mais ou para menos) para a propriedade
		nPos := Len(aVetProp)
	Else
		aVetProp[nPos,02] :=  aVetProp[nPos,02] + LBO->LBO_VOLCRI
	Endif
	
	if Subs(LBO->LBO_TIPOL,1,1) == "B"
		if LBO->LBO_TIPOL == "B1"
			aVetProp[nPos,18] :=  aVetProp[nPos,18] +  LBO->LBO_VOLCRI       	   //Qtd B1 na Cota
			aVetProp[nPos,03] :=  aVetProp[nPos,18] * (nVB1 + aVetProp[nPos,48]) //nVB1  //Valor B1 na Cota
		Elseif LBO->LBO_TIPOL == "B2"
			aVetProp[nPos,19] :=  aVetProp[nPos,19] +  LBO->LBO_VOLCRI        	   //Qtd B2 na Cota
			aVetProp[nPos,04] :=  aVetProp[nPos,19] * (nVB2 + aVetProp[nPos,48]) //nVB2  //Valor B1 na Cota
		Elseif LBO->LBO_TIPOL == "B3"
			aVetProp[nPos,20] :=  aVetProp[nPos,20] +  LBO->LBO_VOLCRI  	  		//Qtd B3 na Cota
			aVetProp[nPos,05] :=  aVetProp[nPos,20] * (nVB3 + aVetProp[nPos,48]) //nVB3  //Valor B1 na Cota
		Endif
	Else
		If LBO->LBO_TIPOL $ "C1/Q1"
			aVetProp[nPos,24] :=  aVetProp[nPos,24] + LBO->LBO_VOLCRI             //Qtd C1 na Cota
			aVetProp[nPos,09] :=  aVetProp[nPos,24] * (nVC1 + aVetProp[nPos,48]) //Valor C1 na Cota
		Elseif LBO->LBO_TIPOL $ "C2/Q2"
			aVetProp[nPos,25] :=  aVetProp[nPos,25] + LBO->LBO_VOLCRI 			   //Qtd C2 na Cota
			aVetProp[nPos,10] :=  aVetProp[nPos,25]  * (nVC2 + aVetProp[nPos,48]) //Valor C2 na Cota
		Elseif LBO->LBO_TIPOL $ "C3/Q3"
			aVetProp[nPos,26] :=  aVetProp[nPos,26] + LBO->LBO_VOLCRI 			   //Qtd C3 na Cota
			aVetProp[nPos,11] :=  aVetProp[nPos,26]  * (nVC3 + aVetProp[nPos,48]) //Valor C3 na Cota
		Endif
	Endif
	
	nQtdProp++
	
	dbSelectArea("LBO")
	dbSkip()
Enddo

If Alltrim(cPgExce) == "S"
	For nPos := 1 To Len(aVetProp)
		If aVetProp[nPos,18] + aVetProp[nPos,19] + aVetProp[nPos,20] > aVetProp[nPos,35]
			If aVetProp[nPos,18] > aVetProp[nPos,35]
				aVetProp[nPos,24] := aVetProp[nPos,24] + aVetProp[nPos,18] - aVetProp[nPos,35]
				aVetProp[nPos,18] := aVetProp[nPos,35]
				aVetProp[nPos,35] := 0
			Else
				aVetProp[nPos,35] := aVetProp[nPos,35] - aVetProp[nPos,18]
			EndIf
			If aVetProp[nPos,19] > aVetProp[nPos,35]
				aVetProp[nPos,24] := aVetProp[nPos,24] + aVetProp[nPos,19] - aVetProp[nPos,35]
				aVetProp[nPos,19] := aVetProp[nPos,35]
				aVetProp[nPos,35] := 0
			Else
				aVetProp[nPos,35] := aVetProp[nPos,35] - aVetProp[nPos,19]
			EndIf
			If aVetProp[nPos,20] > aVetProp[nPos,35]
				aVetProp[nPos,24] := aVetProp[nPos,24] + aVetProp[nPos,20] - aVetProp[nPos,35]
				aVetProp[nPos,20] := aVetProp[nPos,35]
				aVetProp[nPos,35] := 0
			Else
				aVetProp[nPos,35] := aVetProp[nPos,35] - aVetProp[nPos,20]
			EndIf
		EndIf
		// Calcula Excesso B
		If aVetProp[nPos,24] > aVetProp[nPos,36] .and. aVetProp[nPos,37] == "B"
			if LBK->(dbSeek(xFilial("LBK")+"1"))
				aVetProp[nPos,21] := (aVetProp[nPos,24] - aVetProp[nPos,36])* LBK->LBK_PEREXC / 100
			Endif
			if LBK->(dbSeek(xFilial("LBK")+"2"))
				aVetProp[nPos,22] := (aVetProp[nPos,24] - aVetProp[nPos,36])* LBK->LBK_PEREXC / 100
			Endif
			if LBK->(dbSeek(xFilial("LBK")+"3"))
				aVetProp[nPos,23] := (aVetProp[nPos,24] - aVetProp[nPos,36])* LBK->LBK_PEREXC / 100
			Endif
			aVetProp[nPos,24] := aVetProp[nPos,36]
		Endif
		aVetProp[nPos,03] :=  aVetProp[nPos,18] * (nVB1 + aVetProp[nPos,48]) // nVB1 //Valor B1 na Cota
		aVetProp[nPos,04] :=  aVetProp[nPos,19] * (nVB2 + aVetProp[nPos,48]) // nVB2 //Valor B1 na Cota
		aVetProp[nPos,05] :=  aVetProp[nPos,20] * (nVB3 + aVetProp[nPos,48]) // nVB3 //Valor B1 na Cota
		aVetProp[nPos,09] :=  aVetProp[nPos,24] * (nVC1 + aVetProp[nPos,48]) // Valor C1 na Cota
		aVetProp[nPos,06] :=  aVetProp[nPos,21] * (nVExc1 + aVetProp[nPos,48]) // nVExc1 //Valor Excesso B1
		aVetProp[nPos,07] :=  aVetProp[nPos,22] * (nVExc2 + aVetProp[nPos,48]) // nVExc2// Valor Excesso B2
		aVetProp[nPos,08] :=  aVetProp[nPos,23] * (nVExc3 + aVetProp[nPos,48]) // nVExc3 // Valor Excesso B3
		// Calcula Excesso C
		If  aVetProp[nPos,37] == 'C'
			If aVetProp[nPos,24] > aVetProp[nPos,36]
				if LBK->(dbSeek(xFilial("LBK")+"1"))
					aVetProp[nPos,27] := (aVetProp[nPos,24] - aVetProp[nPos,36])* LBK->LBK_PEREXC / 100
				Endif
				if LBK->(dbSeek(xFilial("LBK")+"2"))
					aVetProp[nPos,28] := (aVetProp[nPos,24] - aVetProp[nPos,36])* LBK->LBK_PEREXC / 100
				Endif
				if LBK->(dbSeek(xFilial("LBK")+"3"))
					aVetProp[nPos,29] := (aVetProp[nPos,24] - aVetProp[nPos,36])* LBK->LBK_PEREXC / 100
				Endif
				aVetProp[nPos,24] := aVetProp[nPos,36]
				aVetProp[nPos,09] := aVetProp[nPos,24] * (nVC1 + aVetProp[nPos,48]) //Valor C1 na Cota
			Endif
			If aVetProp[nPos,25] > aVetProp[nPos,36]
				if LBK->(dbSeek(xFilial("LBK")+"1"))
					aVetProp[nPos,27] := (aVetProp[nPos,25] - aVetProp[nPos,36])* LBK->LBK_PEREXC / 100
				Endif
				if LBK->(dbSeek(xFilial("LBK")+"2"))
					aVetProp[nPos,28] := (aVetProp[nPos,25] - aVetProp[nPos,36])* LBK->LBK_PEREXC / 100
				Endif
				if LBK->(dbSeek(xFilial("LBK")+"3"))
					aVetProp[nPos,29] := (aVetProp[nPos,25] - aVetProp[nPos,36])* LBK->LBK_PEREXC / 100
				Endif
				aVetProp[nPos,25] := aVetProp[nPos,36]
				aVetProp[nPos,10] :=  aVetProp[nPos,25] * (nVC2 + aVetProp[nPos,48]) //Valor C1 na Cota
			Endif
			If aVetProp[nPos,26] > aVetProp[nPos,36]
				if LBK->(dbSeek(xFilial("LBK")+"1"))
					aVetProp[nPos,27] := (aVetProp[nPos,26] - aVetProp[nPos,36])* LBK->LBK_PEREXC / 100
				Endif
				if LBK->(dbSeek(xFilial("LBK")+"2"))
					aVetProp[nPos,28] := (aVetProp[nPos,26] - aVetProp[nPos,36])* LBK->LBK_PEREXC / 100
				Endif
				if LBK->(dbSeek(xFilial("LBK")+"3"))
					aVetProp[nPos,29] := (aVetProp[nPos,26] - aVetProp[nPos,36])* LBK->LBK_PEREXC / 100
				Endif
				aVetProp[nPos,26] := aVetProp[nPos,36]
				aVetProp[nPos,11] :=  aVetProp[nPos,26] * (nVC3 + aVetProp[nPos,48]) //Valor C1 na Cota
			Endif
			aVetProp[nPos,12] :=  aVetProp[nPos,27] * (nVExc1 + aVetProp[nPos,48]) // Valor Excesso C1
			aVetProp[nPos,13] :=  aVetProp[nPos,28] * (nVExc2 + aVetProp[nPos,48]) // Valor Excesso C2
			aVetProp[nPos,14] :=  aVetProp[nPos,29] * (nVExc3 + aVetProp[nPos,48]) // Valor Excesso C3
		Endif
	Next
Endif

nTotExcC := 0
nTotExc  := 0
nTotSobC := 0
nTotSob  := 0
nRateioC := 0
nRateio  := 0
nCMes    := 0
nCDia    := 0
cPropr   := ""
cTotLB   := 0
cTotLC   := 0
nTotQt   := 0
nTotBGOR := 0
nTotBPRO := 0
nTotBCCS := 0
nTotBCBT := 0
nTotRGOR := 0
nTotRPRO := 0
nTotRCCS := 0
nTotRCBT := 0

ProcRegua(Len(aVetProp))

For i = 1 to Len(aVetProp)
	incProc("Calculo Bonificacao p/ Quantidade... " + strzero(i,9))
	
	cTotLB  += avetProp[i,18] + avetProp[i,19] + avetProp[i,20]
	cTotLC  += avetProp[i,24] + avetProp[i,25] + avetProp[i,26]
	nTotQt  += avetProp[i,2]
	
	cFxBonQ := "0"
	dbSelectArea("LBB")
	dbSetOrder(1)
	dbSeek(xFilial("LBB")+aVetProp[i,1])
	
	If aVetProp[i,37] == "B"
		nCotaAnt := LBB->LBB_COTAB*(if(dDatFin-dDatIni==0,1,(dDatFin-dDatIni)+1))
		nProduc  := aVetProp[i,2]
		if nCotaAnt < nProduc
			nExcesso := nProduc - nCotaAnt
			nSobra   := 0
		Else
			nSobra   := nCotaAnt - nProduc
			nExcesso := 0
		Endif   //           1                   2           3        4       5      6        7      8     9            10
		aadd(aVetCotB,{aVetProp[i,1],LBB->LBB_NOMFOR,nCotaAnt,nProduc,nSobra,nExcesso,nRateio,nCMes,nCDia,aVetProp[i,30],.f.})
		nTotExc := nTotExc + nExcesso
		nTotSob := nTotSob + nSobra
		
	Else
		nCotaAntC := LBB->LBB_COTAT*(if(dDatFin-dDatIni==0,1,(dDatFin-dDatIni)+1))
		nProducC  := aVetProp[i,2]
		if nCotaAntC < nProducC
			nExcessoC := nProducC - nCotaAntC
			nSobraC   := 0
		Else
			nSobraC   := nCotaAntC - nProducC
			nExcessoC := 0
		Endif
		aadd(aVetCotC,{aVetProp[i,1],LBB->LBB_NOMFOR,nCotaAntC,nProducC,nSobraC,nExcessoC,nRateioC,nCMes,nCDia,aVetProp[i,30],.f.})
		nTotExcC := nTotExcC + nExcessoC
		nTotSobC := nTotSobC + nSobraC
		
	Endif
	If aVetProp[i,37] == "B" // Tipo de Leite
		aVetProp[i,17] :=  LBB->LBB_OUTCRE //Outros Creditos
		if cPropr # LBB->LBB_CODPRO
			if !Empty(LBB->LBB_CODTAN)
				aVetProp[i,16] :=  Noround(aVetProp[i,2] * LBB->LBB_VALGRA,2) //Valor a Granel
			Endif
			cPropr := LBB->LBB_CODPRO
			dbSelectArea("LBL")
			dbSetOrder(0)
			dbGoTop()
			while !eof()
				if (aVetProp[i,2]/((dDatFin-dDatIni)+1)) >= LBL->LBL_LITINI .and. (aVetProp[i,2]/((dDatFin-dDatIni)+1)) <= LBL->LBL_LITFIN
					cFxBonQ := Subs(LBL->LBL_TIPBON,2,1)
					Exit
				Endif
				dbSkip()
			Enddo
		Endif
	Else //Leite C
		aVetProp[i,17] :=  LBB->LBB_OUTCRE //Outros Creditos
		nCotaDentro := LBB->LBB_COTAT
		nLeiteC     := 0
		if cPropr # LBB->LBB_CODPRO
			if !Empty(LBB->LBB_CODTAN)
				aVetProp[i,16] :=  Noround(aVetProp[i,2] * LBB->LBB_VALGRA,2) //Valor a Granel
			Endif
			cPropr := LBB->LBB_CODPRO
			nPosC  := Ascan(aVetCotC,{|x| x[1] == LBB->LBB_CODPRO})
			dbSelectArea("LBL")
			dbSetOrder(0)
			dbGoTop()
			while !eof()
				if (aVetProp[i,2]/((dDatFin-dDatIni)+1)) >= LBL->LBL_LITINI .and. (aVetProp[i,2]/((dDatFin-dDatIni)+1)) <= LBL->LBL_LITFIN
					cFxBonQ := Subs(LBL->LBL_TIPBON,2,1)
					Exit
				Endif
				dbSkip()
			Enddo
		Endif
	Endif
	
	if cFxBonQ # "0" .and. LBB->LBB_BONIQT == "S"
		aVetProp[i,15] :=   Noround((aVetProp[i,02] * (nVBon&cFxBonQ)),2) //Bonificacao por Quantidade
	Endif
	
	nTotBQ   := nTotBQ   + aVetProp[i,15]
	nTotBG   := nTotBG   + aVetProp[i,16]
	nTotOC   := nTotOC   + aVetProp[i,17]
Next

For i = 1 to Len(aVetCotB)  // Leite B
	//Rateio
	aVetCotB[i,7] := 0
	//Cota Mes
	aVetCotB[i,8] := (aVetCotB[i,4])
	//Cota B Dia
	aVetCotB[i,9] := aVetCotB[i,8] / (if(dDatFin-dDatIni==0,1,(dDatFin-dDatIni)+1))
Next

For i = 1 to Len(aVetCotC) // Leite C
	//Rateio
	aVetCotC[i,7] := nTotSobC / nTotExcC * aVetCotC[i,6]
	//Cota Mes
	aVetCotC[i,8] := (aVetCotC[i,4] - aVetCotC[i,6]) + aVetCotC[i,7]
	//Cota C Dia
	aVetCotC[i,9] := aVetCotC[i,8] / (if(dDatFin-dDatIni==0,1,(dDatFin-dDatIni)+1))
Next

// Pagamento pela Qualidade: Detalhes por criterio
For i = 1 to Len(aVetProp)
	incProc(OemToAnsi("Cálculo Critérios da Qualidade ") + strzero(i,9))

	If aVetProp[i,49]=="S"  // Considerar o pagto.pela Qualidade para a Propriedade
	
		If aVetProp[i,37]=="B"
			nTotLeiCri := avetProp[i,18] + avetProp[i,19] + avetProp[i,20] + avetProp[i,21] + avetProp[i,22] + avetProp[i,23] + avetProp[i,24]
		Else
			nTotLeiCri := avetProp[i,24] + avetProp[i,25] + avetProp[i,26] + avetProp[i,27] + avetProp[i,28] + avetProp[i,29]
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Obtem Acresc./Desconto por Litro dos criterios da qualidade     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		LJZ->(DbSelectArea("LJZ"))
		LJZ->(dbSetOrder(4))  // Propriedade + Data Ref
		LJZ->(dbSeek(xFilial("LJZ") + aVetProp[i,1] + Left(Dtos(dDatIni),6)))
	
		If LJZ->LJZ_RESGOR >= 0
			aVetProp[i,40]	:=  LJZ->LJZ_RESGOR * nTotLeiCri // Bonif.  total ref.GORDURA
			nTotBGOR		+= aVetProp[i,40]
		Else
			aVetProp[i,44]	:=  ABS(LJZ->LJZ_RESGOR) * nTotLeiCri // Redutor total ref.GORDURA
			nTotRGOR		+= aVetProp[i,44]
		EndIf
	
		If LJZ->LJZ_RESPRO >= 0
			aVetProp[i,41]	:=  LJZ->LJZ_RESPRO * nTotLeiCri // Bonif.  total ref.PROTEINA
			nTotBPRO		+= aVetProp[i,41]
		Else
			aVetProp[i,45]	:=  ABS(LJZ->LJZ_RESPRO) * nTotLeiCri // Redutor total ref.PROTEINA
			nTotRPRO		+= aVetProp[i,45]
		EndIf
	
		If LJZ->LJZ_RESCCS >= 0
			aVetProp[i,42]	:=  LJZ->LJZ_RESCCS * nTotLeiCri // Bonif.  total ref.CCS
			nTotBCCS		+= aVetProp[i,42]
		Else
			aVetProp[i,46]	:=  ABS(LJZ->LJZ_RESCCS) *  nTotLeiCri // Redutor total ref.CCS
			nTotRCCS		+= aVetProp[i,46]
		EndIf
	
		If LJZ->LJZ_RESCBT >= 0
			aVetProp[i,43]	:=  LJZ->LJZ_RESCBT * nTotLeiCri // Bonif.  total ref.CBT
			nTotBCBT		+= aVetProp[i,43]
		Else
			aVetProp[i,47]	:=  ABS(LJZ->LJZ_RESCBT) * nTotLeiCri // Redutor total ref.CBT
			nTotRCBT		+= aVetProp[i,47]
		EndIf
	EndIf
	
Next            

nTotQB1  := 0
nTotQB2  := 0
nTotQB3  := 0
nTotQC1  := 0
nTotQC2  := 0
nTotQC3  := 0

nTotQEB1 := 0
nTotQEB2 := 0
nTotQEB3 := 0
nTotQEC1 := 0
nTotQEC2 := 0
nTotQEC3 := 0

ProcRegua(Len(aVetProp))


For i := 1 to Len(aVetProp)
	incProc("Aguarde... Levantando Despesas... " + strzero(i,9))
	
	nTotB1   := nTotB1   + aVetProp[i,03]
	nTotQB1  := nTotQB1  + aVetProp[i,18]
	nTotB1Qua += aVetProp[i,18] * aVetProp[i,48]

	nTotB2   := nTotB2   + aVetProp[i,04]
	nTotQB2  := nTotQB2  + aVetProp[i,19]
	nTotB2Qua += aVetProp[i,19] * aVetProp[i,48]

	nTotB3   := nTotB3   + aVetProp[i,05]
	nTotQB3  := nTotQB3  + aVetProp[i,20]
	nTotB3Qua += aVetProp[i,20] * aVetProp[i,48]

	nTotC1   := nTotC1   + aVetProp[i,09]
	nTotQC1  := nTotQC1  + aVetProp[i,24]
	nTotC1Qua += aVetProp[i,24] * aVetProp[i,48]
        
    nTotC2   := nTotC2   + aVetProp[i,10]
	nTotQC2  := nTotQC2  + aVetProp[i,25]
	nTotC2Qua += aVetProp[i,25] * aVetProp[i,48]

	nTotC3   := nTotC3   + aVetProp[i,11]
	nTotQC3  := nTotQC3  + aVetProp[i,26]
	nTotC3Qua += aVetProp[i,26] * aVetProp[i,48]

	nTotEB1  := nTotEB1  + aVetProp[i,06]
	nTotQEB1 := nTotQEB1 + aVetProp[i,21]
	nTotEB1Qua += aVetProp[i,21] * aVetProp[i,48]

	nTotEB2  := nTotEB2  + aVetProp[i,07]
	nTotQEB2 := nTotQEB2 + aVetProp[i,22]
	nTotEB2Qua += aVetProp[i,22] * aVetProp[i,48]

	nTotEB3  := nTotEB3  + aVetProp[i,08]
	nTotQEB3 := nTotQEB3 + aVetProp[i,23]
	nTotEB3Qua += aVetProp[i,23] * aVetProp[i,48]

	nTotEC1  := nTotEC1  + aVetProp[i,12]
	nTotQEC1 := nTotQEC1 + aVetProp[i,27]
	nTotEC1Qua += aVetProp[i,27] * aVetProp[i,48]

	nTotEC2  := nTotEC2  + aVetProp[i,13]
	nTotQEC2 := nTotQEC2 + aVetProp[i,28]
	nTotEC2Qua += aVetProp[i,28] * aVetProp[i,48]

	nTotEC3  := nTotEC3  + aVetProp[i,14]
	nTotQEC3 := nTotQEC3 + aVetProp[i,29]
	nTotEC3Qua += aVetProp[i,29] * aVetProp[i,48]
	
	dbSelectArea("LBB")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(xFilial("LBB")+aVetProp[i,1])
	
	
	dbSelectArea("LBB") // incluido por Pricila
	dbSetOrder(1)
	dbSeek(xFilial("LBB")+aVetProp[i,1])

	nPos := Ascan(aVetFin,{|x| SUBSTR(x[1],1,8) == aVetProp[i,39]})

	/*
	If nPos = 0
		DbSelectArea("SE1") // Busca Contas a Receber
		DBSetOrder(2)
		DbGoTop()
		DbSeek(xFilial("SE1")+ SUBSTR(aVetProp[i][39],1,nTamSA2C))
		While !eof() .and. xFilial("SE1")+SUBSTR(aVetProp[i][39],1,nTamSA2C) == SE1->E1_FILIAL+SE1->E1_CLIENTE
			_lFazSit2  := .F.
			_lFazSit1  := .F.
			LBO->(DbSetOrder(6))                                           
			//If LBO->(DbSeek(xFilial("LBO")+ SE1->E1_CLIENTE+SUBSTR(aVetProp[i][39],7,2)))
			If LBO->(DbSeek(xFilial("LBO")+ SE1->E1_CLIENTE+SE1->E1_LOJA))
				While LBO->(!EOF()) .and. xFilial("LBO")+SE1->E1_CLIENTE == LBO->LBO_FILIAL+SUBSTR(LBO->LBO_CODFOR,1,nTamSA2C) .and. !_lFazSit2 
				//While LBO->(!EOF()) .and. xFilial("LBO")+SE1->E1_CLIENTE+SUBSTR(aVetProp[i][39],7,2) == LBO->LBO_FILIAL+LBO->LBO_CODFOR .and. !_lFazSit2
					If LBO->LBO_DATENT >= dDatIni .And. LBO->LBO_DATENT <= dDatFin
						If SE1->E1_VENCREA >= dDatIni .And. SE1->E1_VENCREA <= dDatFin .And. SE1->E1_SALDO > 0 .And. ;
							((Alltrim(SE1->E1_TIPO) == GetMv("MV_TPTITE1") .And. alltrim(SE1->E1_PREFIXO) # pPrefixo) .or. alltrim(SE1->E1_PREFIXO) == pPrefixo) 
//							SE1->E1_LOJA == SUBSTR(aVetProp[i][39],7,2)
							_lFazSit2 := .T.
						Endif
					Endif
					LBO->(DbSkip())
				Enddo
			Elseif LBO->(DbSeek(xFilial("LBO")+ SE1->E1_CLIENTE))
				While LBO->(!EOF()) .and. xFilial("LBO")+SE1->E1_CLIENTE == LBO->LBO_FILIAL+SUBSTR(LBO->LBO_CODFOR,1,nTamSA2C) .and. !_lFazSit1
					If LBO->LBO_DATENT >= dDatIni .And. LBO->LBO_DATENT <= dDatFin
						If SE1->E1_VENCREA >= dDatIni .And. SE1->E1_VENCREA <= dDatFin .And. SE1->E1_SALDO > 0 .And. ;
							((Alltrim(SE1->E1_TIPO) == GetMv("MV_TPTITE1") .And. alltrim(SE1->E1_PREFIXO) # pPrefixo) .or. alltrim(SE1->E1_PREFIXO) == pPrefixo)
							_lFazSit1 := .T.
						Endif
					Endif
					LBO->(DbSkip())
				Enddo
			Endif
			
			If 	_lFazSit2
				nPos := Ascan(aVetFin,{|x| x[1] == E1_CLIENTE+E1_LOJA+E1_PREFIXO})
				If nPos > 0
				    If !(str(recno(),6) $ aVetFin[nPos,4])
						aVetFin[nPos,2] :=  aVetFin[nPos,2] + SE1->E1_SALDO
						aVetFin[nPos,4] :=  aVetFin[nPos,4] + str(recno(),6)
					Endif
				Else
					Aadd(aVetFin,{SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO,SE1->E1_SALDO,"SE1",str(recno(),6) })
				Endif
			Endif
			If _lFazSit1
				nPos := Ascan(aVetFin,{|x| x[1] == E1_CLIENTE+LBB->LBB_LOJA+E1_PREFIXO})
				If nPos > 0                                                              
					If !(str(recno(),6) $ aVetFin[nPos,4])	
						aVetFin[nPos,2] :=  aVetFin[nPos,2] + SE1->E1_SALDO
						aVetFin[nPos,4] :=  aVetFin[nPos,4] + str(recno(),6)
	                Endif
				Else
					Aadd(aVetFin,{SE1->E1_CLIENTE+LBB->LBB_LOJA+SE1->E1_PREFIXO,SE1->E1_SALDO,"SE1",str(recno(),6) })
				Endif
			Endif
			SE1->(DbSkip())
		Enddo
		
		dbSelectArea("SE2") // Busca Contas a Pagar
		dbSetorder(6)
		dbSeek(xFilial("SE2")+SUBSTR(aVetProp[i][39],1,nTamSA2C))
		While !eof() .and. xFilial("SE2")+SUBSTR(aVetProp[i][39],1,nTamSA2C) == SE2->E2_FILIAL+SE2->E2_FORNECE
			_lFazSit2  := .F.
			_lFazSit1  := .F.
			LBO->(DbSetOrder(6)) 
			If LBO->(DbSeek(xFilial("LBO")+ SE2->E2_FORNECE+SE2->E2_LOJA))
				While LBO->(!EOF()) .and. xFilial("LBO")+SE2->E2_FORNECE == LBO->LBO_FILIAL+SUBSTR(LBO->LBO_CODFOR,1,nTamSA2C)
					If LBO->LBO_DATENT >= dDatIni .And. LBO->LBO_DATENT <= dDatFin
						if SE2->E2_VENCREA >= dDatIni .and. SE2->E2_VENCREA <= dDatFin .And. SE2->E2_TIPO $ "NDF#PA " .and. SE2->E2_SALDO > 0
							_lFazSit2 := .T.
						Endif
					Endif
					LBO->(DbSkip())
				Enddo
			Elseif LBO->(DbSeek(xFilial("LBO")+ SE2->E2_FORNECE))
				While LBO->(!EOF()) .and. xFilial("LBO")+SE2->E2_FORNECE == LBO->LBO_FILIAL+SUBSTR(LBO->LBO_CODFOR,1,nTamSA2C)
					If LBO->LBO_DATENT >= dDatIni .And. LBO->LBO_DATENT <= dDatFin
						if SE2->E2_VENCREA >= dDatIni .and. SE2->E2_VENCREA <= dDatFin .And. SE2->E2_TIPO $ "NDF#PA " .and. SE2->E2_SALDO > 0
							_lFazSit1 := .T.
						Endif
					Endif
					LBO->(DbSkip())
				Enddo
			Endif
			
			If 	_lFazSit2
				nPos := Ascan(aVetFin,{|x| x[1] == E2_FORNECE+E2_LOJA+E2_PREFIXO})
				If nPos > 0
					If !(str(recno(),6) $ aVetFin[nPos,4])
						aVetFin[nPos,2] :=  aVetFin[nPos,2] + SE2->E2_SALDO
						aVetFin[nPos,4] :=  aVetFin[nPos,4] + str(recno(),6)
					Endif
				Else
					Aadd(aVetFin,{SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO,SE2->E2_SALDO,"SE2",str(recno(),6)})
				Endif
			Endif
			
			If _lFazSit1
				nPos := Ascan(aVetFin,{|x| x[1] == E2_FORNECE+LBB->LBB_LOJA+E2_PREFIXO})
				If nPos > 0
					If !(str(recno(),6) $ aVetFin[nPos,4])
						aVetFin[nPos,2] :=  aVetFin[nPos,2] + SE2->E2_SALDO
						aVetFin[nPos,4] :=  aVetFin[nPos,4] + str(recno(),6)
			        Endif
				Else
					Aadd(aVetFin,{SE2->E2_FORNECE+LBB->LBB_LOJA+SE2->E2_PREFIXO,SE2->E2_SALDO,"SE2",str(recno(),6)})
				Endif
			Endif
			SE2->(DbSkip())
		Enddo
		
	Endif
	*/
Next

IF SM0->M0_CODIGO $ GETMV("MV_FMLPRC")
	If ExistBlock("FMLPRECO")
		nTotBQT := 0
		nTotBQ  := 0
		nTotBG  := 0
		
		For i = 1 to Len(aVetProp)
			//Formula para calcular o preco final do leite
			nValLiq := ExecBlock("FMLPRECO",.f.,.f.,{aVetProp[i],LevValor(i)})
			aVetProp[i,15] := nValLiq
			nTotBQT        += nValLiq
		Next
		nTotBQ   += nTotBQT
	Else
		nTotBQT := nTotBQ
	Endif
Else
	nTotBQT := nTotBQ
Endif

aVetDR    := {}
nTotDespT := 0
nTotReceT := 0
nTotGerT  := 0
nCusMedT  := 0
nCusMed   := 0

// Criando Receitas TOTAIS
if type("aVetDR[nLin,2]")#"U"
	aVetDR[nLin,3] := nTotB1
	aVetDR[nLin,4] := nTotQB1
	aVetDR[nLin,5] := nTotB1Qua
ElseIf nTotB1 > 0
	aadd(aVetDR,{"R","Leite B1 Cota",nTotB1,nTotQB1,nTotB1Qua,"",.f.})
	nLin += 1
Endif

if type("aVetDR[nLin,2]")#"U"
	aVetDR[nLin,3] := nTotB2
	aVetDR[nLin,4] := nTotQB2
	aVetDR[nLin,5] := nTotB2Qua
ElseIf nTotB2 > 0
	aadd(aVetDR,{"R","Leite B2 Cota",nTotB2,nTotQB2,nTotB2Qua,"",.f.})
	nLin += 1
Endif

if type("aVetDR[nLin,2]")#"U"
	aVetDR[nLin,3] := nTotB3
	aVetDR[nLin,4] := nTotQB3
	aVetDR[nLin,5] := nTotB3Qua
ElseIf nTotB3 > 0
	aadd(aVetDR,{"R","Leite B3 Cota",nTotB3,nTotQB3,nTotB3Qua,"",.f.})
	nLin += 1
Endif
if type("aVetDR[nLin,2]")#"U"
	aVetDR[nLin,3] := nTotEB1
	aVetDR[nLin,4] := nTotQEB1
	aVetDR[nLin,5] := nTotEB1Qua
ElseIf nTotEB1 > 0
	aadd(aVetDR,{"R","Leite B Excesso 1",nTotEB1,nTotQEB1,nTotEB1Qua,"",.f.})
	nLin += 1
Endif
if type("aVetDR[nLin,2]")#"U"
	aVetDR[nLin,3] := nTotEB2
	aVetDR[nLin,4] := nTotQEB2
	aVetDR[nLin,5] := nTotEB2Qua
ElseIf nTotEB2 > 0
	aadd(aVetDR,{"R","Leite B Excesso 2",nTotEB2,nTotQEB2,nTotEB2Qua,"",.f.})
	nLin += 1
Endif
if type("aVetDR[nLin,2]")#"U"
	aVetDR[nLin,3] := nTotEB3
	aVetDR[nLin,4] := nTotQEB3
	aVetDR[nLin,5] := nTotEB3Qua
ElseIf nTotEB3 > 0
	aadd(aVetDR,{"R","Leite B Excesso 3",nTotEB3,nTotQEB3,nTotEB3Qua,"",.f.})
	nLin += 1
Endif
if type("aVetDR[nLin,2]")#"U"
	aVetDR[nLin,3] := nTotC1
	aVetDR[nLin,4] := nTotQC1
	aVetDR[nLin,5] := nTotC1Qua
ElseIf nTotC1 > 0
	aadd(aVetDR,{"R","Leite C1 Cota",nTotC1,nTotQC1,nTotC1Qua,"",.f.})
	nLin += 1
Endif
if type("aVetDR[nLin,2]")#"U"
	aVetDR[nLin,3] := nTotC2
	aVetDR[nLin,4] := nTotQC2
	aVetDR[nLin,5] := nTotC2Qua
Elseif nTotC2 > 0
	aadd(aVetDR,{"R","Leite C2 Cota",nTotC2,nTotQC2,nTotC2Qua,"",.f.})
	nLin += 1
Endif
if type("aVetDR[nLin,2]")#"U"
	aVetDR[9,3] := nTotC3
	aVetDR[9,4] := nTotQC3
	aVetDR[9,5] := nTotC3Qua
ElseIf nTotC3 > 0
	aadd(aVetDR,{"R","Leite C3 Cota",nTotC3,nTotQC3,nTotC3Qua,"",.f.})
	nLin += 1
Endif
if type("aVetDR[nLin,2]")#"U"
	aVetDR[10,3] := nTotEC1
	aVetDR[10,4] := nTotQEC1
	aVetDR[10,5] := nTotEC1Qua
ElseIf nTotEC1 > 0
	aadd(aVetDR,{"R","Leite C Excesso 1",nTotEC1,nTotQEC1,nTotEC1Qua,"",.f.})
	nLin += 1
Endif
if type("aVetDR[nLin,2]")#"U"
	aVetDR[11,3] := nTotEC2
	aVetDR[11,4] := nTotQEC2
	aVetDR[11,5] := nTotEC2Qua
ElseIf nTotEC2 > 0
	aadd(aVetDR,{"R","Leite C Excesso 2",nTotEC2,nTotQEC2,nTotEC2Qua,"",.f.})
	nLin += 1
Endif
if type("aVetDR[nLin,2]")#"U"
	aVetDR[12,3] := nTotEC3
	aVetDR[12,4] := nTotQEC3
	aVetDR[12,5] := nTotEC3Qua
ElseIf nTotEC3 > 0
	aadd(aVetDR,{"R","Leite C Excesso 3",nTotEC3,nTotQEC3,nTotEC3Qua,"",.f.})
	nLin += 1
Endif
if type("aVetDR[nLin,2]")#"U"
	aVetDR[13,3] := nTotBQT
ElseIf nTotBQT > 0
	aadd(aVetDR,{"R","Bonific Quantidade",nTotBQT,0,0,"",.f.})
	nLin += 1
Endif
if type("aVetDR[nLin,2]")#"U"
	aVetDR[14,3] := nToBG
ElseIf nTotBG > 0
	aadd(aVetDR,{"R","Bonific a Granel",nTotBG,0,0,"",.f.})
	nLin += 1
Endif
if type("aVetDR[nLin,2]")#"U"
	aVetDR[15,3] := nTotOC
ElseIf nTotOC > 0
	aadd(aVetDR,{"R","Outros Creditos",nTotOC,0,0,"",.f.})
	nLin += 1
Endif
if type("aVetDR[nLin,2]")#"U"
	aVetDR[16,3] := nTotBGOR
ElseIf nTotBGOR > 0
	aadd(aVetDR,{"B","Bonif.GORDURA",0,0,nTotBGOR,"",.f.})
	nLin += 1
Endif
if type("aVetDR[nLin,2]")#"U"
	aVetDR[17,5] := nTotBPRO
ElseIf nTotBPRO > 0
	aadd(aVetDR,{"B","Bonif.PROTEINA",0,0,nTotBPRO,"",.f.})
	nLin += 1
Endif
if type("aVetDR[nLin,2]")#"U"
	aVetDR[18,5] := nTotBCCS
ElseIf nTotBCCS > 0
	aadd(aVetDR,{"B","Bonif.CCS",0,0,nTotBCCS,"",.f.})
	nLin += 1
Endif
if type("aVetDR[nLin,2]")#"U" 
	aVetDR[19,5] := nTotBCBT
ElseIf nTotBCBT > 0
	aadd(aVetDR,{"B","Bonif.CBT",0,0,nTotBCBT,"",.f.})
	nLin += 1
Endif

nTotReceT  := Noround(nTotB1+nTotB2+nTotB3+nTotEB1+nTotEB2+nTotEB3+nTotC1+nTotC2+nTotC3+nTotEC1+nTotEC2+nTotEC3+nTotBQT+nTotBG+nTotOC,2)


// Criando Despesas TOTAIS   / alterado aqui Fernando
For i := 1 to Len(aVetFin)
	lOk := .f.
	If aVetFin[i,2] # 0
		LBR->(dbGoTop())
		cChave := Alltrim(Subs(aVetFin[i,1],nTamSA2+1,3))
		If LBR->(dbSeek(xFilial("LBR")+cChave))
			nPos := Ascan(aVetDR,{|x| x[2] == LBR->LBR_DESC})
			if nPos > 0
				aVetDR[nPos,3] := aVetDR[nPos,3] + ROUND(aVetFin[i,2], 2)
				nTotDespT      += ROUND(aVetFin[i,2], 2)
			Else
				For x:=1 to Len(aVetDR)-4  // exceto criterios 
					if Empty(aVetDR[x,2])
						aVetDR[x,2] := LBR->LBR_DESC
						aVetDR[x,3] := ROUND(aVetFin[i,2], 2)
						lOk := .t.
						Exit
					Endif
				Next
				if !lOk
					aadd(aVetDR,{"D",LBR->LBR_DESC,aVetFin[i,2],0,0,"",.f.})
				Endif
				nTotDespT += ROUND(aVetFin[i,2], 2)
			Endif
		EndIf
	Endif
Next 

// Retira valores da qualidade do preco do leite (so para tela)
For i:=1 to Len(aVetDR)
	If aVetDR[i,1] == "R" // ("BONIF."$Upper(aVetDR[i,2]).Or. "REDUTOR"$Upper(aVetDR[i,2]))
		aVetDR[i,3] -= aVetDR[i,5]
	EndIf
Next

aCols       := aVetDR
aColsTotal  := aCols

nValorFrete := 0
nVFRuralD   := 0
nVFRuralP   := 0
nVSenarS    := 0
nVSenarN    := 0
nValCri     := 0

//Levantamento do Frete/FunRural por Propriedades
For Cont:=1 to Len(aVetProp)
	dbSelectArea("LBB")
	dbSetorder(1)
	if dbSeek(xFilial("LBB")+aVetProp[Cont,1])
		//Frete
		if LBB->LBB_VALPE1 > 0 .or. LBB->LBB_ALIPE1 > 0 .or. LBB->LBB_VALPE2 > 0 .or. LBB->LBB_ALIPE2 > 0
			if Alltrim(LBB->LBB_TIPFRT) <> "2" //Por Quantidade
				aVetProp[Cont,31] := (LBB->LBB_VALPE1 * aVetProp[Cont,2]) + (LBB->LBB_VALPE2 * aVetProp[Cont,2])
			Else  //Por Valor
				nValorEnt := 0
				For x_:=3 to 16 //Vetor de Valores, so nao entra outros creditos
					nValorEnt += aVetProp[Cont,x_]
				Next
				aVetProp[Cont,31] := ((nValorEnt * LBB->LBB_ALIPE1) / 100) + ((nValorEnt * LBB->LBB_ALIPE2) / 100)
			Endif
			
			nValorFrete += Noround(aVetProp[Cont,31], 2)
		Endif
		
		nValorEnt := 0
		For x_:=3 to 16 //Vetor de Valores, so nao entra outros creditos
			nValorEnt += aVetProp[Cont,x_]
		Next
		
		//FunRural
		dbselectArea("SA2")
		dbsetorder(1)
		if dbseek(xFilial("SA2")+LBB->LBB_CODFOR+LBB->LBB_LOJA)
			dbselectArea("SED")
			dbsetorder(1)
			if dbseek(xFilial("SED")+SA2->A2_NATUREZ)
				nFunRura := IIF ( lRoundFUN ,round((nValorEnt * SED->ED_PERCINS)/100,2),Noround((nValorEnt * SED->ED_PERCINS)/100,2))
				if LBB->LBB_FUNRUR $ "S "
					nVFRuralD += nFunRura
				Else
					if SA2->A2_TIPO <> "J"
						nVFRuralP += nFunRura
					Endif
				Endif
			Endif
		Endif
		
		//Senar
		nVSenar := (nValorEnt * GetMv("MV_SENAR"))/100
		if LBB->LBB_SENAR == "S"
			nVSenarS += nVSenar
		Else
			nVSenarN += nVSenar
		Endif
		
		//Taxa de Capital
		aVetProp[Cont,34] := (nValorEnt * LBB->LBB_TAXADM) / 100
		nTotDespT += Noround(aVetProp[Cont,34],2)
		For i:=1 to Len(aVetDR)
			lOk := .F.
			if aVetDR[i,2] == "Taxa de Capital"
				aVetDR[i,3] += Noround(aVetProp[Cont,34],2)
				lOk := .t.
				Exit
			Endif
		Next
		if !lOk
			if aVetProp[Cont,34] > 0
				aadd(aVetDR,{"D","Taxa de Capital",Noround(aVetProp[Cont,34],2),0,0,"",.f.})
			Endif
		Endif
	Endif
Next


if nValorFrete > 0 //Valor do Frete
	For i:=1 to Len(aVetDR)
		lOk := .f.
		if aVetDR[i,2] == "Desconto de frete no preco"
			aVetDR[i,3] += nValorFrete
			lOk := .t.
			Exit
		Endif
	Next
	if !lOk
		aadd(aVetDR,{"D","Desconto de frete no preco",nValorFrete,0,0,"",.f.})
	Endif
	nTotDespT += Noround(nValorFrete,2)
Endif
if nVFRuralD > 0 //Valor do FunRural a Descontar dos Proprietarios
	For i:=1 to Len(aVetDR)
		lOk := .f.
		if aVetDR[i,2] == "FunRural a Descontar"
			aVetDR[i,3] := nVFRuralD
			lOk := .t.
			Exit
		Endif
	Next
	if !lOk
		aadd(aVetDR,{"D","FunRural a Descontar",nVFRuralD,0,0,"",.f.})
	Endif
Endif
if nVFRuralP > 0 //Valor do FunRural a Pagar pela Cooperativa
	For i:=1 to Len(aVetDR)
		lOk := .f.
		if aVetDR[i,2] == "FunRural a Pagar"
			aVetDR[i,3] := nVFRuralP
			lOk := .t.
			Exit
		Endif
	Next
	if !lOk
		aadd(aVetDR,{"D","FunRural a Pagar",nVFRuralP,0,0,"",.f.})
	Endif
	nTotDespT += Noround(nVFRuralP,2)
Endif
if nVSenarS > 0 //Valor do Senar a Pagar pela Cooperativa
	For i:=1 to Len(aVetDR)
		lOk := .f.
		if aVetDR[i,2] == "Senar a Descontar"
			aVetDR[i,3] := nVSenarS
			lOk := .t.
			Exit
		Endif
	Next
	if !lOk
		aadd(aVetDR,{"D","Senar a Descontar",nVSenarS,0,0,"",.f.})
	Endif
Endif
if nVSenarN > 0 //Valor do Senar a Pagar pela Cooperativa
	For i:=1 to Len(aVetDR)
		lOk := .f.
		if aVetDR[i,2] == "Senar a Pagar"
			aVetDR[i,3] := nVSenarN
			lOk := .t.
			Exit
		Endif
	Next
	if !lOk
		aadd(aVetDR,{"D","Senar a Pagar",nVSenarN,0,0,"",.f.})
	Endif
	nTotDespT += Noround(nVSenarN, 2)
Endif

if nTotRGOR > 0 // Valor desc. da qualidade - GORDURA
	lOk := .f.
	For i:=1 to Len(aVetDR)
		if aVetDR[i,2] == "Redutor GORDURA"
			aVetDR[i,5] := nTotRGOR
			lOk := .t.
			Exit
		Endif
	Next
	if !lOk
		aadd(aVetDR,{"E","Redutor GORDURA",0,0,nTotRGOR,"",.f.})
	Endif
Endif
if nTotRPRO > 0 // Valor desc. da qualidade - PROTEINA
	lOk := .f.
	For i:=1 to Len(aVetDR)
		if aVetDR[i,2] == "Redutor PROTEINA"
			aVetDR[i,5] := nTotRPRO
			lOk := .t.
			Exit
		Endif
	Next
	if !lOk
		aadd(aVetDR,{"E","Redutor PROTEINA",0,0,nTotRPRO,"",.f.})
	Endif
Endif
if nTotRCCS > 0 // Valor desc. da qualidade - CCS
	lOk := .f.
	For i:=1 to Len(aVetDR)
		if aVetDR[i,2] == "Redutor CCS"
			aVetDR[i,5] := nTotRCCS
			lOk := .t.
			Exit
		Endif
	Next
	if !lOk
		aadd(aVetDR,{"E","Redutor CCS",0,0,nTotRCCS,"",.f.})
	Endif
Endif
if nTotRCBT > 0 // Valor desc. da qualidade - CBT
	lOk := .f.
	For i:=1 to Len(aVetDR)
		if aVetDR[i,2] == "Redutor CBT"
			aVetDR[i,5] := nTotRCBT
			lOk := .t.
			Exit
		Endif
	Next
	if !lOk
		aadd(aVetDR,{"E","Redutor CBT",0,0,nTotRCBT,"",.f.})
	Endif
Endif

nTotGerT   := nTotReceT - nTotDespT

nCusMedT   := Round((nTotReceT - nValorFrete - nTotOC) / nTotQt, 6)


If !lRefaz
	nOpca      := 0
	cCodProp   := Space(6)
	cDesProp   := Space(30)
	nUsado     :=0
	aHeader    := {}
	
	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("LBQ")
	While !Eof().And.(x3_arquivo=="LBQ")
		If Alltrim(x3_campo) $ "LBQ_FLAG#LBQ_DESC#LBQ_VALOR#LBQ_QTD#LBQ_PAGQUA"
			nUsado++
			Aadd(aHeader, {TRIM(X3Titulo()), x3_campo, x3_picture, x3_tamanho, x3_decimal, x3_valid,;
			x3_usado, x3_tipo, x3_arquivo, x3_context, x3_Relacao, x3_reserv })
			wVar  := "M->"+x3_campo
			&wVar := CriaVar(x3_campo)
			If(Alltrim(x3_campo) $ "LBQ_DESC",nPosDesc := nUsado,)
		Endif
		dbSkip()
	Enddo
	
	Aadd(aHeader, {"","EXTRA","",1,0,"","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","C","LBQ","V","","¹Ç"})
	M->EXTRA := " "
	nUsado++
	
	cTitulo       :=OemToAnsi("Receitas/Despesas")
	cAliasGetd    :="LBQ"
	cAlias        :="LBQ"
	cLinOk        :="AllwaysTrue()"
	cTudOk        :="AllwaysTrue()"
	cFieldOk      :="AllwaysTrue()"
	nLinhas       := 99
	
	nTotDesp      := 0
	nTotRece      := 0
	nTotGer       := 0
	aColsPropr    := {{Space(30),0,0,0,Space(1),"",.f.}}
	
	DEFINE MSDIALOG oDlg TITLE cTitulo From 12,14 to 45,104 of oMainWnd
	SetEnch("")
	@ 035,001 FOLDER oFolder SIZE 356,208 OF oDlg PROMPTS "Total","Por Propriedade" PIXEL
	
	&& Abas do Folder
	INIFOLDER("oFolder")
	
	FS_ABA(1)
	oGetTotal := MsGetDados():New(001,001,148,353,nOpcG,cLinOk,cTudOk,"",.T.,,,,nLinhas,cFieldOk,,,,oFolder:aDialogs[1])
	oGetTotal:nMax:=Len(aCols) // maximo de linhas por getdados de entrada.
	
	If ExistBlock("FMLPRECO")
		oBtn1 := tButton():New(152, 003, "Produtores", oFolder:aDialogs[1], {|| LstProd(aVetProp)}, 048, 014,,,, .T.)
	Endif
	
	@ 169,004 SAY OemToAnsi("Total Despesas") of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE
	@ 169,044 MSGET oTotDespT VAR nTotDespT  PICTURE "@E 9,999,999.99"  SIZE 44,4 OF oFolder:aDialogs[1] PIXEL COLOR CLR_BLACK  when .f.
	@ 169,092 SAY OemToAnsi("Total Receitas") of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE
	@ 169,132 MSGET oTotReceT VAR nTotReceT PICTURE "@E 9,999,999.99"  SIZE 44,4 OF oFolder:aDialogs[1] PIXEL COLOR CLR_BLACK  when .f.
	@ 169,180 SAY OemToAnsi("Total Geral") of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE
	@ 169,210 MSGET oTotGerT  VAR nTotGerT  PICTURE "@E 9,999,999.99"  SIZE 44,4 OF oFolder:aDialogs[1] PIXEL COLOR CLR_BLACK  when .f.
	@ 169,260 SAY OemToAnsi("Custo Medio") of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE
	@ 169,300 MSGET oCusMedT  VAR nCusMedT  PICTURE "@E 9,999.999999"  SIZE 44,4 OF oFolder:aDialogs[1] PIXEL COLOR CLR_BLACK  when .f.
	
	
	FS_ABA(2)
	
	@ 001,004 SAY OemToAnsi("Propriedade") of oFolder:aDialogs[2] PIXEL COLOR CLR_BLUE
	@ 001,044 MSGET oCodProp VAR cCodProp  PICTURE "@!" F3 "LBB" VALID Desc14R().and.Desc14R() SIZE 40,4 OF oFolder:aDialogs[2] PIXEL COLOR CLR_BLACK
	@ 001,090 MSGET oDesProp VAR cDesProp  PICTURE "@!" SIZE 70,4 OF oFolder:aDialogs[2] PIXEL COLOR CLR_BLACK when .f.
	oGetPropr := MsGetDados():New(013,001,163,353,nOpcG,cLinOk,cTudOk,"",.T.,,,,nLinhas,cFieldOk,,,,oFolder:aDialogs[2])
	
	if nOpcG == 2
		cCodProp := LBP->LBP_CODPRO
		DESC14R()
	Endif
	
	oGetPropr:nMax:=Len(aCols) // maximo de linhas por getdados de entrada.
	@ 169,004 SAY OemToAnsi("Total Despesas") of oFolder:aDialogs[2] PIXEL COLOR CLR_BLUE
	@ 169,044 MSGET oTotDesp VAR nTotDesp PICTURE "@E 9,999,999.99"  SIZE 44,4 OF oFolder:aDialogs[2] PIXEL COLOR CLR_BLACK  when .f.
	@ 169,092 SAY OemToAnsi("Total Receitas") of oFolder:aDialogs[2] PIXEL COLOR CLR_BLUE
	@ 169,132 MSGET oTotRece VAR nTotRece  PICTURE "@E 9,999,999.99"  SIZE 44,4 OF oFolder:aDialogs[2] PIXEL COLOR CLR_BLACK  when .f.
	@ 169,180 SAY OemToAnsi("Total Geral") of oFolder:aDialogs[2] PIXEL COLOR CLR_BLUE
	@ 169,210 MSGET oTotGer  VAR nTotGer  PICTURE "@E 9,999,999.99"  SIZE 44,4 OF oFolder:aDialogs[2] PIXEL COLOR CLR_BLACK  when .f.
	@ 169,260 SAY OemToAnsi("Custo Medio") of oFolder:aDialogs[2] PIXEL COLOR CLR_BLUE
	@ 169,300 MSGET oCusMed  VAR nCusMed  PICTURE "@E 9,999.999999"  SIZE 44,4 OF oFolder:aDialogs[2] PIXEL COLOR CLR_BLACK  when .f.
	
	oFolder:bSetOption := {|| FS_SETOPT(oFolder:nOption) }
	oFolder:bChange    := {|| FS_ABA(oFolder:nOption) }
	//ACTIVATE MSDIALOG oDlg ON INIT ( EnChoiceBar(oDlg,{||oDlg:End(),FS_SETOPT(oFolder:nOption) } , {|| aColsPropr := {}, oDlg:End()}) , FS_ABA(1) ) CENTER
	ACTIVATE MSDIALOG oDlg ON INIT ( EnChoiceBar(oDlg,{||FS_SETOPT(oFolder:nOption),oDlg:End() } , {|| aColsPropr := {}, oDlg:End()}) , FS_ABA(1) ) CENTER
Else
	oGetTotal:oBrowse:Refresh()
EndIf

Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ DemCotB   ³ Autor ³  Manoel               ³ Data ³16/03/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Calculo da Cota de Leite B                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum									                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.									              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                             		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DemCotB()

Local i
Local lPriVez  := .t.
Local nQtdProp := 0
Local lRet  := .t.
aVetCotB := {}
aVetCotC := {}
aVetPro2 := {}

if empty(dDatIni) .or. empty(dDatFin)
	lRet := .F.
Endif

If lRet
	aRotina := {{OemToAnsi("Pesquisar" ),"axPesqui"     , 0, 1}, ;   && Pesquisar
	{OemToAnsi("Visualizar"),'U_CACOL114(2)', 0, 2}, ;   && Visualizar
	{OemToAnsi("Incluir"   ),'U_CACOL114(3)', 0, 3}, ;   && Incluir
	{OemToAnsi("Alterar"   ),'U_CACOL114(4)', 0, 4, 2},; && Alterar
	{OemToAnsi("Excluir"   ),'U_CACOL114(5)', 0, 5, 1} } && Excluir
	
	// Levantamento das Propriedades que entragaram Leite no Periodo
	
	if nOpcG == 2
		dbSelectArea("LBO")
		dbSetorder(1)
		Set SoftSeek on
		dbSeek(xFilial("LBO")+LBP->LBP_CODPRO+Dtos(dDatIni))
		Set SoftSeek off
	Else
		dbSelectArea("LBO")
		dbSetorder(2)
		Set SoftSeek on
		dbSeek(xFilial("LBO")+Dtos(dDatIni))
		Set SoftSeek off
	Endif
	nContLBO := 0
	nTotRegLBB := LBB->(reccount()) * ((dDatFin-dDatIni)+1)
	cCodPr := ""
	ProcRegua(nTotRegLBB)
	while !eof() .and. LBO->LBO_FILIAL == xFilial("LBO") .and. (LBO->LBO_DATENT >= dDatIni .and. LBO->LBO_DATENT <= dDatFin)
		incProc("Levantando Cota B... " + strzero(nContLBO++,9))
		if nOpcG == 2
			if LBO->LBO_CODPRO # LBP->LBP_CODPRO
				Exit
			Endif
		Endif
		
		if Subs(LBO->LBO_TIPOL,1,1) # "B"
			dbSelectArea("LBO")
			dbSkip()
			Loop
		Endif
		
		nPos := Ascan(aVetPro2,{|x| x[1] ==LBO->LBO_CODPRO})
		if nPos > 0
			aVetPro2[nPos,2] :=  aVetPro2[nPos,2] + LBO->LBO_VOLCRI
			lPriVez := .f.
		Else
			dbSelectArea("LBD")
			dbSetOrder(3)
			dbgotop()
			dbSeek(xFilial("LBD")+LBO->LBO_CODPRO)
			Aadd(aVetPro2,{LBO->LBO_CODPRO,LBO->LBO_VOLCRI,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,LBD->LBD_CODROT,0,0,0,0,0,0,0})
			nQtdProp++
		Endif
		
		dbSelectArea("LBO")
		dbSkip()
	Enddo
	
	nTotExc  := 0
	nTotSob  := 0
	nRateio  := 0
	nTotExcC := 0
	nTotSobC := 0
	nRateioC := 0
	nCMes    := 0
	nCDia    := 0
	nTotProduc := 0
	nTotCtAnt  := 0
	
	For i = 1 to Len(aVetPro2)
		dbSelectArea("LBB")
		LBB->(dbGoTop())
		dbSetOrder(1)
		LBB->(dbSeek(xFilial("LBB")+aVetPro2[i,1]))
		
		if LBB->LBB_TIPOL == "B"
			nCotaAnt := LBB->LBB_COTAB*(if(dDatFin-dDatIni==0,1,(dDatFin-dDatIni)+1))
			nProduc  := aVetPro2[i,2]
			if nCotaAnt < nProduc
				nExcesso := nProduc - nCotaAnt
				nSobra   := 0
			Else
				nSobra   := nCotaAnt - nProduc
				nExcesso := 0
			Endif   //           1                   2           3        4       5      6        7      8     9            10
			aadd(aVetCotB,{aVetPro2[i,1],LBB->LBB_NOMFOR,nCotaAnt,nProduc,nSobra,nExcesso,nRateio,nCMes,nCDia,aVetPro2[i,30],.f.})
			
			nTotProduc := nTotProduc + nProduc
			nTotCtAnt  := nTotCtAnt  + nCotaAnt
			nTotExc := nTotExc + nExcesso
			nTotSob := nTotSob + nSobra
		Else
			nCotaAntC := LBB->LBB_COTAT*(if(dDatFin-dDatIni==0,1,(dDatFin-dDatIni)+1))
			nProducC  := aVetPro2[i,2]
			if nCotaAntC < nProducC
				nExcessoC := nProducC - nCotaAntC
				nSobraC   := 0
			Else
				nSobraC   := nCotaAntC - nProducC
				nExcessoC := 0
			Endif   //                  1             2         3        4       5      6        7      8     9      10
			aadd(aVetCotC,{aVetPro2[i,1],LBB->LBB_NOMFOR,nCotaAntC,nProducC,nSobraC,nExcessoC,nRateio,nCMes,nCDia,aVetPro2[i,30],.f.})
			
			nTotExcC := nTotExcC + nExcessoC
			nTotSobC := nTotSobC + nSobraC
		Endif
	Next
	
	nTotCMes := 0
	nTotCDia := 0
	nTotRat  := 0
	
	if Type("AvetCotB") # "U"
		if nTotProduc > nTotCtAnt
			for i = 1 to Len(aVetCotB)
				if aVetCotB[i,3] < aVetCotB[i,4]
					//Rateio
					aVetCotB[i,7] := nTotSob / nTotExc * aVetCotB[i,6]
					//Cota Mes
					aVetCotB[i,8] := (aVetCotB[i,4] - aVetCotB[i,6]) + aVetCotB[i,7]
					//Cota B Dia
					aVetCotB[i,9] := aVetCotB[i,8] / (if(dDatFin-dDatIni==0,1,(dDatFin-dDatIni)+1))
					
					nTotCMes := nTotCMes + aVetCotB[i,8]
					nTotCDia := nTotCDia + aVetCotB[i,9]
					nTotRat  := nTotRat + aVetCotB[i,7]
				Else
					//Sobra
					aVetCotB[i,5] := aVetCotB[i,3] - aVetCotB[i,4]
					//Excesso
					aVetCotB[i,6] := 0
					//Rateio
					aVetCotB[i,7] := 0
					//Cota Mes
					aVetCotB[i,8] := (aVetCotB[i,4])
					//Cota B Dia
					aVetCotB[i,9] := aVetCotB[i,8] / (if(dDatFin-dDatIni==0,1,(dDatFin-dDatIni)+1))
					nTotCMes := nTotCMes + aVetCotB[i,8]
					nTotCDia := nTotCDia + aVetCotB[i,9]
				Endif
			Next
		Else
			for i = 1 to Len(aVetCotB)
				//Sobra
				aVetCotB[i,5] := 0
				//Excesso
				aVetCotB[i,6] := 0
				//Rateio
				aVetCotB[i,7] := 0
				//Cota Mes
				aVetCotB[i,8] := (aVetCotB[i,4])
				//Cota B Dia
				aVetCotB[i,9] := aVetCotB[i,8] / (if(dDatFin-dDatIni==0,1,(dDatFin-dDatIni)+1))
				nTotCMes := nTotCMes + aVetCotB[i,8]
				nTotCDia := nTotCDia + aVetCotB[i,9]
			Next
			nTotCMes := nTotProduc
			nTotCDia := nTotProduc / (if(dDatFin-dDatIni==0,1,(dDatFin-dDatIni)+1))
			nTotSob  := 0
			nTotRat  := 0
			nTotExc  := 0
		Endif
	Endif
	
	aadd(aVetCotB,{"TOTAL","",nTotCtAnt,nTotProduc,nTotSob,nTotExc,nTotRat,nTotCMes,nTotCDia,"",.f.})
	
	if Type("AvetCotC") # "U"
		for i = 1 to Len(aVetCotC)
			if aVetCotC[i,3] < aVetCotC[i,4]
				//Rateio
				aVetCotC[i,7] := nTotSobC / nTotExcC * aVetCotC[i,6]
				//Cota Mes
				aVetCotC[i,8] := (aVetCotC[i,4] - aVetCotC[i,6]) + aVetCotC[i,7]
				//Cota C Dia
				aVetCotC[i,9] := aVetCotC[i,8] / (if(dDatFin-dDatIni==0,1,(dDatFin-dDatIni)+1))
			Else
				//Sobra
				aVetCotC[i,5] := aVetCotC[i,3] - aVetCotC[i,4]
				//Excesso
				aVetCotC[i,6] := 0
				//Rateio
				aVetCotC[i,7] := 0
				//Cota Mes
				aVetCotC[i,8] := (aVetCotC[i,5])
				//Cota B Dia
				aVetCotC[i,9] := aVetCotC[i,8] / (if(dDatFin-dDatIni==0,1,(dDatFin-dDatIni)+1))
			EndIf
		Next
	EndIf
	
	nUsado  := 0
	aHeader := {}
	DbSelectArea("SX3")
	DbSeek("LBP")
	While !Eof().And.(x3_arquivo=="LBP")
		If Alltrim(x3_campo) $ "LBP_CODPRO#LBP_DESC#LBP_COTAAN#LBP_PRODUC#LBP_SOBRA#LBP_EXCESS#LBP_RATEIO#LBP_COTAME#LBP_COTADI"
			nUsado:=nUsado+1
			Aadd(aHeader, {TRIM(X3Titulo()), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal,x3_valid,;
			x3_usado, x3_tipo, x3_arquivo, x3_context, x3_Relacao, x3_reserv } )
			wVar  := "M->"+x3_campo
			&wVar := CriaVar(x3_campo)
		Endif
		
		DbSkip()
	Enddo
	
	aCols := aVetCotB
	
	cTitulo       :=OemToAnsi("Calculo de Cota B")
	cAliasGetd    :="LBP"
	cAlias        :="LBP"
	cLinOk        :="AllwaysTrue()"
	cTudOk        :="AllwaysTrue()"
	cFieldOk      :="AllwaysTrue()"
	
	nOpca := 0
	DEFINE MSDIALOG odlg TITLE cTitulo From 12,14 to 34,94	of oMainWnd
	oGetDados:=MsGetDados():New(35,4,165,315,nOpcG,cLinOk,cTudOk,"",.T.,,,,,cFieldOk)
	oGetDados:nMax:=Len(aCols) // maximo de linhas por getdados de entrada.
	ACTIVATE MSDIALOG odlg ON INIT EnChoiceBar(odlg,{||If(LBB->LBB_TIPOL = "B",AtuCotaB(),.t.),odlg:End()},{||odlg:End() }) CENTER

EndIf
Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ AtuCotaB ³ Autor ³ Manoel                ³ Data ³ 08/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualiza Cota B                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum						                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.         	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                                  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuCotaB()

Local i
aSavCotB := {}

If MsgYesNo("Atualiza Cota B?","")
	for i = 1 to Len(aVetCotB)
		dbSelectArea("LBB")
		dbGoTop()
		dbSetOrder(1)
		if dbSeek(xFilial("LBB")+aVetCotB[i,1])
			RecLock("LBB",.F.)
			aadd(aSavCotB,{aVetCotB[i,1],LBB->LBB_COTAB})
			LBB->LBB_COTAB := aVetCotB[i,9]
			MsUnlock()
		Endif
	Next
Endif
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Desc14R   ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Levantamento Despesas e Receitas alimentando o acols        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum						                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.   	                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                             		   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Desc14R()

Local x, i, x_
Local lRet := .T.

dbSelectArea("LBB")
dbSetorder(1)
if !dbSeek(xFilial("LBB")+cCodProp)
	lRet := .F.
Endif

If lRet
	cDesProp := LBB->LBB_NOMFOR
	
	aVetDR   := {}
	nTotDesp := 0
	nTotRece := 0
	nTotGer  := 0
	nLin     := 1
	
	// Criando Receitas da Propriedade
	nPos := Ascan(aVetProp,{|x| x[1] == LBB->LBB_CODPRO})
	lRet := (nPos > 0)

	if nPos > 0
		nTotB1  := aVetProp[nPos,03]
		nTotB2  := aVetProp[nPos,04]
		nTotB3  := aVetProp[nPos,05]
		nTotEB1 := aVetProp[nPos,06]
		nTotEB2 := aVetProp[nPos,07]
		nTotEB3 := aVetProp[nPos,08]
		nTotC1  := aVetProp[nPos,09]
		nTotC2  := aVetProp[nPos,10]
		nTotC3  := aVetProp[nPos,11]
		nTotEC1 := aVetProp[nPos,12]
		nTotEC2 := aVetProp[nPos,13]
		nTotEC3 := aVetProp[nPos,14]
		
		nTotQB1  := aVetProp[nPos,18]
		nTotQB2  := aVetProp[nPos,19]
		nTotQB3  := aVetProp[nPos,20]
		
		nTotQEB1 := aVetProp[nPos,21]
		nTotQEB2 := aVetProp[nPos,22]
		nTotQEB3 := aVetProp[nPos,23]
		
		nTotQC1  := aVetProp[nPos,24]
		nTotQC2  := aVetProp[nPos,25]
		nTotQC3  := aVetProp[nPos,26]
		nTotQEC1 := aVetProp[nPos,27]
		nTotQEC2 := aVetProp[nPos,28]
		nTotQEC3 := aVetProp[nPos,29]
		nTotBQ   := aVetProp[nPos,15]
		nTotBG   := aVetProp[nPos,16]
		nTotOC   := aVetProp[nPos,17]
		nTotQt   := avetProp[nPos,2]
		nTotBGOR := aVetProp[nPos,40]
		nTotBPRO := aVetProp[nPos,41]
		nTotBCCS := aVetProp[nPos,42]
		nTotBCBT := aVetProp[nPos,43]
		
		// Criando Receitas por Propriedade
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[nLin,3] := nTotB1
			aVetDR[nLin,4] := nTotQB1
			aVetDR[nLin,5] := nTotQB1*aVetProp[nPos,48]
		ElseIf nTotB1 > 0
			aadd(aVetDR,{"R","Leite B1 Cota",nTotB1,nTotQB1,nTotQB1*aVetProp[nPos,48],"",.f.})
			nLin += 1
		Endif
		
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[nLin,3] := nTotB2
			aVetDR[nLin,4] := nTotQB2
			aVetDR[nLin,5] := nTotQB2*aVetProp[nPos,48]
		ElseIf nTotB2 > 0
			aadd(aVetDR,{"R","Leite B2 Cota",nTotB2,nTotQB2,nTotQB2*aVetProp[nPos,48],"",.f.})
			nLin += 1
		Endif
		
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[nLin,3] := nTotB3
			aVetDR[nLin,4] := nTotQB3
			aVetDR[nLin,5] := nTotQB3*aVetProp[nPos,48]
		ElseIf nTotB3 > 0
			aadd(aVetDR,{"R","Leite B3 Cota",nTotB3,nTotQB3,nTotQB3*aVetProp[nPos,48],"",.f.})
			nLin += 1
		Endif
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[nLin,3] := nTotEB1
			aVetDR[nLin,4] := nTotQEB1
			aVetDR[nLin,5] := nTotQEB1*aVetProp[nPos,48]
		ElseIf nTotEB1 > 0
			aadd(aVetDR,{"R","Leite B Excesso 1",nTotEB1,nTotQEB1,nTotQEB1*aVetProp[nPos,48],"",.f.})
			nLin += 1
		Endif
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[nLin,3] := nTotEB2
			aVetDR[nLin,4] := nTotQEB2
			aVetDR[nLin,5] := nTotQEB2*aVetProp[nPos,48]
		ElseIf nTotEB2 > 0
			aadd(aVetDR,{"R","Leite B Excesso 2",nTotEB2,nTotQEB2,nTotQEB2*aVetProp[nPos,48],"",.f.})
			nLin += 1
		Endif
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[nLin,3] := nTotEB3
			aVetDR[nLin,4] := nTotQEB3
			aVetDR[nLin,5] := nTotQEB3*aVetProp[nPos,48]
		ElseIf nTotEB3 > 0
			aadd(aVetDR,{"R","Leite B Excesso 3",nTotEB3,nTotQEB3,nTotQEB3*aVetProp[nPos,48],"",.f.})
			nLin += 1
		Endif
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[nLin,3] := nTotC1
			aVetDR[nLin,4] := nTotQC1
			aVetDR[nLin,5] := nTotQC1*aVetProp[nPos,48]
		ElseIf nTotC1 > 0
			aadd(aVetDR,{"R","Leite C1 Cota",nTotC1,nTotQC1,nTotQC1*aVetProp[nPos,48],"",.f.})
			nLin += 1
		Endif
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[nLin,3] := nTotC2
			aVetDR[nLin,4] := nTotQC2
			aVetDR[nLin,5] := nTotQC2*aVetProp[nPos,48]
		Elseif nTotC2 > 0
			aadd(aVetDR,{"R","Leite C2 Cota",nTotC2,nTotQC2,nTotQC2*aVetProp[nPos,48],"",.f.})
			nLin += 1
		Endif
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[9,3] := nTotC3
			aVetDR[9,4] := nTotQC3
			aVetDR[9,5] := nTotQC3*aVetProp[nPos,48]
		ElseIf nTotC3 > 0
			aadd(aVetDR,{"R","Leite C3 Cota",nTotC3,nTotQC3,nTotQC3*aVetProp[nPos,48],"",.f.})
			nLin += 1
		Endif
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[10,3] := nTotEC1
			aVetDR[10,4] := nTotQEC1
			aVetDR[10,5] := nTotQEC1*aVetProp[nPos,48]
		ElseIf nTotEC1 > 0
			aadd(aVetDR,{"R","Leite C Excesso 1",nTotEC1,nTotQEC1,nTotQEC1*aVetProp[nPos,48],"",.f.})
			nLin += 1
		Endif
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[11,3] := nTotEC2
			aVetDR[11,4] := nTotQEC2
			aVetDR[11,5] := nTotQEC2*aVetProp[nPos,48]
		ElseIf nTotEC2 > 0
			aadd(aVetDR,{"R","Leite C Excesso 2",nTotEC2,nTotQEC2,nTotQEC2*aVetProp[nPos,48],"",.f.})
			nLin += 1
		Endif
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[12,3] := nTotEC3
			aVetDR[12,4] := nTotQEC3
			aVetDR[12,5] := nTotQEC3*aVetProp[nPos,48]
		ElseIf nTotEC3 > 0
			aadd(aVetDR,{"R","Leite C Excesso 3",nTotEC3,nTotQEC3,nTotQEC3*aVetProp[nPos,48],"",.f.})
			nLin += 1
		Endif
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[13,3] := nTotBQ
		ElseIf nTotBQ > 0
			aadd(aVetDR,{"R","Bonific Quantidade",nTotBQ,0,0,"",.f.})
			nLin += 1
		Endif
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[14,3] := nToBG
		ElseIf nTotBG > 0
			aadd(aVetDR,{"R","Bonific a Granel",nTotBG,0,0,"",.f.})
			nLin += 1
		Endif
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[15,3] := nTotOC
		ElseIf nTotOC > 0
			aadd(aVetDR,{"R","Outros Creditos",nTotOC,0,0,"",.f.})
			nLin += 1
		Endif
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[16,5] := nTotBGOR
		ElseIf nTotBGOR > 0
			aadd(aVetDR,{"B","Bonif.GORDURA",0,0,nTotBGOR,"",.f.})
			nLin += 1
		Endif
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[17,5] := nTotBPRO
		ElseIf nTotBPRO > 0
			aadd(aVetDR,{"B","Bonif.PROTEINA",0,0,nTotBPRO,"",.f.})
			nLin += 1
		Endif
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[18,5] := nTotBCCS
		ElseIf nTotBCCS > 0
			aadd(aVetDR,{"B","Bonif.CCS",0,0,nTotBCCS,"",.f.})
			nLin += 1
		Endif
		if type("aVetDR[nLin,2]")#"U"
			aVetDR[19,5] := nTotBCBT
		ElseIf nTotBCBT > 0
			aadd(aVetDR,{"B","Bonif.CBT",0,0,nTotBCBT,"",.f.}) 
			nLin += 1
		Endif
	Endif
	
	if lRet
		nTotRece := Noround((nTotB1+nTotB2+nTotB3+nTotEB1+nTotEB2+nTotEB3+nTotC1+nTotC2+nTotC3+nTotEC1+nTotEC2+nTotEC3+nTotBQ+nTotBG+nTotOC), 2)
		
		//Levantamento das DESPESAS
		For i = 1 to Len(aVetFin)
			lOk := .f.
			if Subs(aVetFin[i,1],1,8) == LBB->LBB_CODFOR+LBB->LBB_LOJA
				cChave := Alltrim(Subs(aVetFin[i,1],9,3))
				LBR->(dbSeek(xFilial("LBR")+cChave))
				nPos := Ascan(aVetDR,{|x| x[2] == LBR->LBR_DESC})
				if nPos > 0
					aVetDR[nPos,3] := aVetDR[nPos,3] + ROUND(aVetFin[nPos,2], 2)
					nTotDesp       += ROUND(aVetFin[nPos,2], 2)
				Else
					For x:=1 to Len(aVetDR)-4  // exceto criterios qualidade
						if Empty(aVetDR[x,2])
							aVetDR[x,2] := LBR->LBR_DESC
							aVetDR[x,3] := aVetFin[i,2]
							lOk := .t.
							Exit
						Endif
					Next
					if !lOk
						aadd(aVetDR,{"D",LBR->LBR_DESC,aVetFin[i,2],0,0,"",.f.})
					Endif
					nTotDesp += ROUND(aVetFin[i,2], 2)
				Endif
			Endif
		Next
		
		Cont := Ascan(aVetProp,{|x| x[1] == LBB->LBB_CODPRO})
		
		nValorFrete := 0
		nVFRuralD := 0
		nVFRuralP := 0
		nVSenarS  := 0
		nVSenarN  := 0
		
		//Taxa de Capital
		nValorEnt := 0
		if Cont # 0
			For x_:=3 to 16 //Vetor de Valores, so nao entra outros creditos
				nValorEnt += aVetProp[Cont,x_]
			Next
			aVetProp[Cont,34] := (nValorEnt * LBB->LBB_TAXADM) / 100
			nTotDesp += Noround(aVetProp[Cont,34],2)
			lOk := .f.
			For i:=1 to Len(aVetDR)
				If Empty(aVetDR[i,2])
					aVetDR[i,2] := "Taxa de Capital"
					aVetDR[i,3] := Noround(aVetProp[Cont,34],2)
					lOk := .t.
					Exit
				Endif
			Next
			if !lOk
				if aVetProp[Cont,34] > 0
					aadd(aVetDR,{"D","Taxa de Capital", Noround(aVetProp[Cont,34],2),0,0,"", .f.})
				Endif
			Endif
			
			//Levantamento do Frete/FunRural por Propriedades
			//Frete
			if Cont <> 0 .and. ((LBB->LBB_VALPE1 > 0 .or. LBB->LBB_ALIPE1 > 0) .or. (LBB->LBB_VALPE2 > 0 .or. LBB->LBB_ALIPE2 > 0))
				if Alltrim(LBB->LBB_TIPFRT) <> "2" //Por Quantidade
					aVetProp[Cont,31] := (LBB->LBB_VALPE1*aVetProp[Cont,2]) + (LBB->LBB_VALPE2*aVetProp[Cont,2])
				Else  //Por Valor
					nValorEnt := 0
					For x_:=3 to 16 //Vetor de Valores, so nao entra outros creditos
						nValorEnt += aVetProp[Cont,x_]
					Next
					aVetProp[Cont,31] := ((nValorEnt * LBB->LBB_ALIPE1) / 100) + ((nValorEnt * LBB->LBB_ALIPE2) / 100)
				Endif
				
				nValorFrete += Noround(aVetProp[Cont,31],2)
			Endif
			//FunRural
			dbSelectArea("SA2")
			dbSetorder(1)
			dbSeek(xFilial("SA2")+LBB->LBB_CODFOR+LBB->LBB_LOJA)
			dbSelectArea("SED")
			dbSetorder(1)
			dbSeek(xFilial("SED")+SA2->A2_NATUREZ)
			nFunRura := Noround(((nTotRece - aVetProp[Cont,17]) * SED->ED_PERCINS) / 100,2)
			
			if LBB->LBB_FUNRUR $ "S "
				nVFRuralD += nFunRura
			Else
				nVFRuralP += nFunRura
			Endif
			
			//Senar
			nVSenar := ((nTotRece-aVetProp[Cont,17]) * GetMv("MV_SENAR"))/100
			if LBB->LBB_SENAR == "S"
				nVSenarS += nVSenar
			Else
				nVSenarN += nVSenar
			Endif
			
			if nValorFrete > 0 //Valor do Frete
				lOk := .f.
				For i:=1 to Len(aVetDR)
					if Empty(aVetDR[i,2])
						aVetDR[i,2] := "Desconto de frete no preco"
						aVetDR[i,3] := nValorFrete
						lOk := .t.
						Exit
					Endif
				Next
				if !lOk
					aadd(aVetDR,{"D","Desconto de frete no preco",nValorFrete,0,0,"",.f.})
				Endif
				nTotDesp += Noround(nValorFrete,2)
			Endif
			if nVFRuralD > 0 //Valor do FunRural a Descontar dos Proprietarios
				lOk := .f.
				For i:=1 to Len(aVetDR)
					if Empty(aVetDR[i,2])
						aVetDR[i,2] := "FunRural a Descontar"
						aVetDR[i,3] := nVFRuralD
						lOk := .t.
						Exit
					Endif
				Next
				if !lOk
					aadd(aVetDR,{"D","FunRural a Descontar",nVFRuralD,0,0,"",.f.})
				Endif
				nTotDesp += Noround(nVFRuralD, 2)
			Endif
			if nVFRuralP > 0 //Valor do FunRural a Pagar pela Cooperativa
				lOk := .f.
				For i:=1 to Len(aVetDR)
					if Empty(aVetDR[i,2])
						aVetDR[i,2] := "FunRural a Pagar"
						aVetDR[i,3] := nVFRuralP
						lOk := .t.
						Exit
					Endif
				Next
				if !lOk
					aadd(aVetDR,{"D","FunRural a Pagar",nVFRuralP,0,0,"",.f.})
				Endif
			Endif
			if nVSenarS > 0 //Valor do Senar a Pagar pela Cooperativa
				lOk := .f.
				For i:=1 to Len(aVetDR)
					if Empty(aVetDR[i,2])
						aVetDR[i,2] := "Senar a Descontar"
						aVetDR[i,3] := nVSenarS
						lOk := .t.
						Exit
					Endif
				Next
				if !lOk
					aadd(aVetDR,{"D","Senar a Descontar",nVSenarS,0,0,"",.f.})
				Endif
				nTotDesp += Noround(nVSenarS, 2)
			Endif
			if nVSenarN > 0 //Valor do Senar a Pagar pela Cooperativa
				lOk := .f.
				For i:=1 to Len(aVetDR)
					if Empty(aVetDR[i,2])
						aVetDR[i,2] := "Senar a Pagar"
						aVetDR[i,3] := nVSenarN
						lOk := .t.
						Exit
					Endif
				Next
				if !lOk
					aadd(aVetDR,{"D","Senar a Pagar",nVSenarN,0,0,"",.f.})
				Endif
			Endif
	
			nTotRGOR := aVetProp[Cont,44]
			nTotRPRO := aVetProp[Cont,45]
			nTotRCCS := aVetProp[Cont,46]
			nTotRCBT := aVetProp[Cont,47]
			if nTotRGOR > 0 // Valor desc. da qualidade - GORDURA
				lOk := .f.
				For i:=1 to Len(aVetDR)
					if aVetDR[i,2] == "Redutor GORDURA"
						aVetDR[i,5] := nTotRGOR
						lOk := .t.
						Exit
					Endif
				Next
				if !lOk
					aadd(aVetDR,{"E","Redutor GORDURA",0,0,nTotRGOR,"",.f.})
				Endif
			Endif
			if nTotRPRO > 0 // Valor desc. da qualidade - PROTEINA
				lOk := .f.
				For i:=1 to Len(aVetDR)
					if aVetDR[i,2] == "Redutor PROTEINA"
						aVetDR[i,5] := nTotRPRO
						lOk := .t.
						Exit
					Endif
				Next
				if !lOk
					aadd(aVetDR,{"E","Redutor PROTEINA",0,0,nTotRPRO,"",.f.})
				Endif
			Endif
			if nTotRCCS > 0 // Valor desc. da qualidade - CCS
				lOk := .f.
				For i:=1 to Len(aVetDR)
					if aVetDR[i,2] == "Redutor CCS"
						aVetDR[i,5] := nTotRCCS
						lOk := .t.
						Exit
					Endif
				Next
				if !lOk
					aadd(aVetDR,{"E","Redutor CCS",0,0,nTotRCCS,"",.f.})
				Endif
			Endif
			if nTotRCBT > 0 // Valor desc. da qualidade - CBT
				lOk := .f.
				For i:=1 to Len(aVetDR)
					if aVetDR[i,2] == "Redutor CBT"
						aVetDR[i,5] := nTotRCBT
						lOk := .t.
						Exit
					Endif
				Next
				if !lOk
					aadd(aVetDR,{"E","Redutor CBT",0,0,nTotRCBT,"",.f.})
				Endif
			Endif
		
		Endif
	
		nTotGer  := nTotRece - nTotDesp
		
		nCusMed  := Round((nTotRece  - nValorFrete - nTotOC) / nTotQt, 6)
		
		// Retira valores da qualidade do preco do leite (so' para tela)
		For i:=1 to Len(aVetDR)
			If aVetDR[i,1] == "R" // ("BONIF."$Upper(aVetDR[i,2]).Or. "REDUTOR"$Upper(aVetDR[i,2]))
				aVetDR[i,3] -= aVetDR[i,5]
			EndIf
		Next
	
		aCols      := aVetDR
		aColsPropr := aCols
		oGetPropr:oBrowse:Refresh()
	Endif
EndIf
Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FS_ABA    ³ Autor ³ Manoel                ³ Data ³ 08/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Tratamento de Aba                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FS_ABA(ExpN1,ExpL1)		                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = numero da aba                                       ³±±
±±³          ³ ExpL1 = .T.= ativa a aba PROPRIEDADE, .F.=ativa a aba TOTAL ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum	 	                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                             		   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_ABA(nAba,lVz)

aCols   := {}

If nAba == 1
	if lVz
		aCols   := Aclone( aColsPropr )
		If Type("oGetPropr") # "U"
			oGetPropr:oBrowse:Enable()
			n := oGetPropr:oBrowse:nAt
			oGetPropr:oBrowse:Refresh()
		EndIf
	Else
		aCols   := Aclone( aColsTotal )
		If Type("oGetTotal") # "U" .And. Type("oGetPropr") # "U"
			oGetPropr:oBrowse:Disable()
			oGetTotal:oBrowse:Enable()
			n := oGetTotal:oBrowse:nAt
			oGetTotal:oBrowse:Refresh()
		EndIf
	Endif
Else
	aCols   := Aclone( aColsPropr )
	If Type("oGetTotal") # "U" .And. Type("oGetPropr") # "U"
		oGetTotal:oBrowse:Disable()
		oGetPropr:oBrowse:Enable()
		n := oGetPropr:oBrowse:nAt
		oGetPropr:oBrowse:Refresh()
	EndIf
EndIf
Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FS_SETOPT ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Tratamento de Aba - atualiza o acols da aba       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FS_SETOPT(ExpN1,ExpL1)		                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = numero da aba                                       ³±±
±±³          ³ ExpL1 = define qual acols atualiza, dependendo da aba       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.		 	                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                             		   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_SETOPT(nAba,lVz)

If nAba == 1
	if lVz
		aColsPropr   := Aclone( aCols )
	Else
		aColsTotal   := Aclone( aCols )
	Endif
Else
	aColsPropr   := Aclone( aCols )
EndIf
Return(.T.)
   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ INIFOLDER³ Autor ³ Manoel                ³ Data ³ 08/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Corrige o problema de foco qdo nao existe campo a Editar   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite 		                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function INIFOLDER(oObj)

Local i:=0, nOpcA := Len(&(oObj):aDialogs)

For i:=1 to nOpcA
	DEFINE SBUTTON  FROM 1000,1000 TYPE 13 ACTION .t.  ENABLE OF &(oObj):aDialogs[i]
Next
Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ VerDtFec ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Consiste datas do periodo e se ja' houve Fechamento no mes ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum				                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.		                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                             		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VerDtFec()

Local lRet := .T.

dbSelectArea("LBP")
dbSetOrder(2)

if dDatFin < dDatIni
	MsgStop("Dada final não pode ser menor que data inicial!!!","Atenção!")
	lRet := .F.
Endif

if Month(dDatFin) # Month(dDatIni)
	MsgStop("O intervalo do periodo de fechamento deve estar dentro do mesmo mês!!!","Atenção!")
	lRet := .F.
Endif

if readvar() == "dDatIni"
	cmes := StrZero(Month(dDatIni),2)
	Set SoftSeek On
	LBP->(dbSeek(xFilial("LBP")+Dtos(CTod("01/"+strzero(month(dDatIni),2)+"/"+Str(year(dDatIni),4)))))
	if Str(year(dDatIni),4)+strzero(month(dDatIni),2) ==  Subs(Dtos(LBP->LBP_DATINI),1,6)
		MsgStop("O Mes "+cMes+" ja foi fechado!","Atencao")
		Set SoftSeek Off
		dbSetOrder(1)
		lRet := .F.
	Endif
	Set SoftSeek Off
Else
	cmes := StrZero(Month(dDatFin),2)
	Set SoftSeek On
	LBP->(dbSeek(xFilial("LBP")+Dtos(CTod("01/"+strzero(month(dDatFin),2)+"/"+Str(year(dDatFin),4)))))
	if Str(year(dDatIni),4)+strzero(month(dDatFin),2) ==  Subs(Dtos(LBP->LBP_DATFIN),1,6)
		MsgStop("O Mes "+cMes+" ja foi fechado!","Atencao")
		Set SoftSeek Off
		dbSetOrder(1)
		lRet := .F.
	Endif
	Set SoftSeek Off
Endif
Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ GRVCAC14  ³ Autor ³ Manoel                ³ Data ³ 26/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera Fechamento do Periodo                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GRVCAC14(ExpN1)      		                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = numero da opcao		                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.   	                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                               		   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GRVCAC14(nOpcao)

Local x_, i, k, g, l
Local cPrefixo 		:= ""
Local aCabec        := {} // Array do Cabecalho da Nota Fiscal
Local aItens        := {} // Array dos Itens da Nota Fiscal
Local lRet			:= .T.
Local lTLeiCpoNF	:= ExistBlock("TLEICPONF")
Local aRetPE		:= {}
Private cCodLeite 	:= ""
Private cTE			:= ""

lMsHelpAuto := .T.
lMsErroAuto := .F.
nTotFun   := 0
nTotSenar := 0
cSerie    := ""
cNumero   := ""
nTValInss := 0
nTBasInss := 0
nTValIcms := 0
nTBasIcms := 0

If !Empty(GetMv("MV_PREFSE2")) //Empty(cPrefixo)
	cPrefixo := GetMv("MV_PREFSE2")
Else
	cPrefixo := GetMv("MV_2DUPREF")
Endif

If nOpcao == 3
	if MsgYesNo("Confirma Fechamento e Geracao de Notas Fiscais de Entrada?","")
		//Geracao Automatica de Notas Fiscais de Entrada
		lOk := Sx5NumNota(.T.,GetNewPar("MV_TPNRNFS","1"))
		if !lOk
			MsgStop(OemToAnsi("Necessario Informar o Numero da NF."),OemToAnsi("Atencao!"))
			lRet := .f.
		Endif
		
		If lRet		
			dbSelectArea("SFT")  // Cria a tabela se nao existe

			Begin Transaction
			ProcRegua(len(aVetProp))
			
			If ExistBlock("CA014AG")
				ExecBlock("CA014AG",.f.,.f.)
			EndIf
			
			For k = 1 to len(aVetProp)
				incProc("Grav Despesas e Receitas...  " + strzero(k,9)+"/"+strzero(len(aVetProp),9))
				
				dbSelectArea("LBB")
				dbSetorder(1)
				dbSeek(xFilial("LBB")+aVetProp[k,1])
				
				// Gravando Despesas e Receitas das Propriedades
				// usar avetfin e avetpropr
				
				dbSelectArea("LBQ")
				
				nValorEnt := 0
				For x_:=3 to 16 //Vetor de Valores, so nao entra outros creditos
					nValorEnt += aVetProp[k,x_]
				Next
				
				If Inclui
					if aVetProp[k,3] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG   := "R"
						LBQ->LBQ_DESC	:= "Leite B1 Cota"
						LBQ->LBQ_VALOR  := aVetProp[k,3]
						LBQ->LBQ_QTD	:= aVetProp[k,18]
						LBQ->LBQ_PAGQUA	:= aVetProp[k,48] * aVetProp[k,18]
						MsUnlock()
					Endif
					if aVetProp[k,4] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG   := "R"
						LBQ->LBQ_DESC	:= "Leite B2 Cota"
						LBQ->LBQ_VALOR  := aVetProp[k,4]
						LBQ->LBQ_QTD	:=	aVetProp[k,19]
						LBQ->LBQ_PAGQUA	:= aVetProp[k,48] * aVetProp[k,19]
						MsUnlock()
					Endif
					if aVetProp[k,5] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL	:= xFilial("LBQ")
						LBQ->LBQ_DATINI	:= dDatIni
						LBQ->LBQ_DATFIN	:= dDatFin
						LBQ->LBQ_CODPRO	:= aVetProp[k,1]
						LBQ->LBQ_FLAG	:= "R"
						LBQ->LBQ_DESC	:= "Leite B3 Cota"
						LBQ->LBQ_VALOR	:= aVetProp[k,5]
						LBQ->LBQ_QTD	:= aVetProp[k,20]
						LBQ->LBQ_PAGQUA	:= aVetProp[k,48] * aVetProp[k,20]
						MsUnlock()
					Endif
					If aVetProp[k,6] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "R"
						LBQ->LBQ_DESC	 := "Leite Excesso 1"
						LBQ->LBQ_VALOR   := aVetProp[k,6]
						LBQ->LBQ_QTD	 :=	aVetProp[k,21]
						LBQ->LBQ_PAGQUA	:= aVetProp[k,48] * aVetProp[k,21]
						MsUnlock()
					Endif
					if aVetProp[k,7] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "R"
						LBQ->LBQ_DESC	 := "Leite Excesso 2"
						LBQ->LBQ_VALOR   := aVetProp[k,7]
						LBQ->LBQ_QTD	 :=	aVetProp[k,22]
						LBQ->LBQ_PAGQUA	:= aVetProp[k,48] * aVetProp[k,22]
						MsUnlock()
					Endif
					if aVetProp[k,8] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "R"
						LBQ->LBQ_DESC	 := "Leite Excesso 3"
						LBQ->LBQ_VALOR   := aVetProp[k,8]
						LBQ->LBQ_QTD	 :=	aVetProp[k,23]
						LBQ->LBQ_PAGQUA	:= aVetProp[k,48] * aVetProp[k,23]
						MsUnlock()
					Endif
					if aVetProp[k,9] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "R"
						LBQ->LBQ_DESC	 := "Leite C1 Cota"
						LBQ->LBQ_VALOR   := aVetProp[k,9]
						LBQ->LBQ_QTD	 :=	aVetProp[k,24]
						LBQ->LBQ_PAGQUA	:= aVetProp[k,48] * aVetProp[k,24]
						MsUnlock()
					Endif
					if aVetProp[k,10] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "R"
						LBQ->LBQ_DESC	 := "Leite C2 Cota"
						LBQ->LBQ_VALOR   := aVetProp[k,10]
						LBQ->LBQ_QTD	 :=	aVetProp[k,25]
						LBQ->LBQ_PAGQUA	:= aVetProp[k,48] * aVetProp[k,25]
						MsUnlock()
					Endif
					if aVetProp[k,11] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "R"
						LBQ->LBQ_DESC	 := "Leite C3 Cota"
						LBQ->LBQ_VALOR   := aVetProp[k,11]
						LBQ->LBQ_QTD	 :=	aVetProp[k,26]
						LBQ->LBQ_PAGQUA	:= aVetProp[k,48] * aVetProp[k,26]
						MsUnlock()
					Endif
					if aVetProp[k,12] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "R"
						LBQ->LBQ_DESC	 := "Leite Excesso 1"
						LBQ->LBQ_VALOR   := aVetProp[k,12]
						LBQ->LBQ_QTD	 :=	aVetProp[k,27]
						LBQ->LBQ_PAGQUA	:= aVetProp[k,48] * aVetProp[k,27]
						MsUnlock()
					Endif
					if aVetProp[k,13] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "R"
						LBQ->LBQ_DESC	 := "Leite Excesso 2"
						LBQ->LBQ_VALOR   := aVetProp[k,13]
						LBQ->LBQ_QTD	 :=	aVetProp[k,28]
						LBQ->LBQ_PAGQUA	:= aVetProp[k,48] * aVetProp[k,28]
						MsUnlock()
					Endif
					if aVetProp[k,14] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "R"
						LBQ->LBQ_DESC	 := "Leite Excesso 3"
						LBQ->LBQ_VALOR   := aVetProp[k,14]
						LBQ->LBQ_QTD	 :=	aVetProp[k,29]
						LBQ->LBQ_PAGQUA	:= aVetProp[k,48] * aVetProp[k,29]
						MsUnlock()
					Endif
					if aVetProp[k,15] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "R"
						LBQ->LBQ_DESC	 := "Bonific Quantidade"
						LBQ->LBQ_VALOR   := aVetProp[k,15]
						LBQ->LBQ_QTD	 :=	0
						MsUnlock()
					Endif
					if aVetProp[k,16] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "R"
						LBQ->LBQ_DESC	 := "Bonific a Granel"
						LBQ->LBQ_VALOR   := aVetProp[k,16]
						LBQ->LBQ_QTD	 :=	0
						MsUnlock()
					Endif
					if aVetProp[k,17] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "R"
						LBQ->LBQ_DESC	 := "Outros Creditos"
						LBQ->LBQ_VALOR   := aVetProp[k,17]
						LBQ->LBQ_QTD	 :=	0
						MsUnlock()
					Endif
					if aVetProp[k,40] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "B"
						LBQ->LBQ_DESC	 := "Bonif.GORDURA"
						LBQ->LBQ_VALOR   := 0
						LBQ->LBQ_QTD	 :=	0
						LBQ->LBQ_CRIQUA	 :=	"S"
						LBQ->LBQ_PAGQUA	 := aVetProp[k,40]
						MsUnlock()
					Endif
					if aVetProp[k,41] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "B"
						LBQ->LBQ_DESC	 := "Bonif.PROTEINA"
						LBQ->LBQ_VALOR   := 0
						LBQ->LBQ_QTD	 :=	0
						LBQ->LBQ_CRIQUA	 :=	"S"
						LBQ->LBQ_PAGQUA	 := aVetProp[k,41]
						MsUnlock()
					Endif
					if aVetProp[k,42] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "B"
						LBQ->LBQ_DESC	 := "Bonif.CCS"
						LBQ->LBQ_VALOR   := 0
						LBQ->LBQ_QTD	 :=	0
						LBQ->LBQ_CRIQUA	 :=	"S"
						LBQ->LBQ_PAGQUA	 := aVetProp[k,42]
						MsUnlock()
					Endif
					if aVetProp[k,43] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "B"
						LBQ->LBQ_DESC	 := "Bonif.CBT"
						LBQ->LBQ_VALOR   := 0
						LBQ->LBQ_QTD	 :=	0
						LBQ->LBQ_CRIQUA	 :=	"S"
						LBQ->LBQ_PAGQUA	 := aVetProp[k,43]
						MsUnlock()
					Endif
					
					// DESPESAS
					
					// Calculo da Taxa Capital
					if aVetProp[k,34] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "D"
						LBQ->LBQ_DESC	 := "Taxa de Capital"
						aVetProp[k,34]   := NOROUND(((nValorEnt * LBB->LBB_TAXADM) / 100) , 2)
						LBQ->LBQ_VALOR   := aVetProp[k,34]
						LBQ->LBQ_QTD	 :=	0
						MsUnlock()
					Endif
					
					// Calculo do Frete 1o. Percurso
					If LBB->LBB_VALPE1 > 0 .or. LBB->LBB_ALIPE1 > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "D"
						LBQ->LBQ_DESC	 := "Carreto 1o. Percurso"
						LBQ->LBQ_QTD	 :=	0
						If Alltrim(LBB->LBB_TIPFRT) <> "2" //Por Quantidade
							LBQ->LBQ_VALOR   :=	 Noround(LBB->LBB_VALPE1*aVetProp[k,2],2)
						Else
							LBQ->LBQ_VALOR   :=	 Noround((nValorEnt * LBB->LBB_ALIPE1) / 100,2)
						Endif
						MsUnlock()
					Endif
					
					// Calculo do Frete 2o. Percurso
					If LBB->LBB_VALPE2 > 0 .or. LBB->LBB_ALIPE2 > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "D"
						LBQ->LBQ_DESC	 := "Carreto 2o. Percurso"
						LBQ->LBQ_QTD	 :=	0
						If Alltrim(LBB->LBB_TIPFRT) <> "2" //Por Quantidade
							LBQ->LBQ_VALOR   :=	 Noround(LBB->LBB_VALPE2*aVetProp[k,2],2)
						Else
							LBQ->LBQ_VALOR   :=	 Noround((nValorEnt * LBB->LBB_ALIPE2) / 100,2)
						Endif
						MsUnlock()
					Endif
					
					// Calculo do Funrural
					If LBB->LBB_FUNRUR <> "N"
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "D"
						LBQ->LBQ_DESC	 := "Funrural"
						LBQ->LBQ_QTD	 :=	0
						_cNATUREZA := Posicione("SA2", 1, xFilial("SA2") + LBB->LBB_CODFOR+LBB->LBB_LOJA, "A2_NATUREZ")
						_nPERCINS  := Posicione("SED", 1, xFilial("SED") + _cNATUREZA, "ED_PERCINS")
						LBQ->LBQ_VALOR := NoRound((nValorEnt  * SED->ED_PERCINS) / 100,2)
						MsUnlock()
						nTotFun  += LBQ->LBQ_VALOR
					Endif
					
					// Calculo do Senar
					If LBB->LBB_SENAR <> "N"
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "D"
						LBQ->LBQ_DESC	 := "Senar"
						LBQ->LBQ_QTD	 :=	0
						LBQ->LBQ_VALOR   := (nValorEnt * GetMv("MV_SENAR"))/100
						MsUnlock()
						nTotSenar +=   LBQ->LBQ_VALOR
					Endif
			
			
					if Len(aVetFin) > 0
						For i = 1 to Len(aVetFin)
							If Subs(aVetFin[i,1],1,8) == LBB->LBB_CODFOR+LBB->LBB_LOJA
								LBR->(dbGoTop())
								cChave := Alltrim(Subs(aVetFin[i,1],9,3))
								If LBR->(dbSeek(xFilial("LBR")+cChave))
									RecLock("LBQ",.T.)
									LBQ->LBQ_FILIAL := xFilial("LBQ")
									LBQ->LBQ_DATINI := dDatIni
									LBQ->LBQ_DATFIN := dDatFin
									LBQ->LBQ_CODPRO := aVetProp[k,1]
									LBQ->LBQ_FLAG   := "D"
									LBQ->LBQ_DESC   := LBR->LBR_DESC
									LBQ->LBQ_VALOR  := aVetFin[i,2]
									LBQ->LBQ_QTD	:=	0
									MsUnlock()
								Endif
							Endif
						Next
					Endif
					
					if aVetProp[k,44] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "E"
						LBQ->LBQ_DESC	 := "Redutor GORDURA"
						LBQ->LBQ_VALOR   := 0
						LBQ->LBQ_QTD	 :=	0
						LBQ->LBQ_CRIQUA	 :=	"S"
						LBQ->LBQ_PAGQUA  := aVetProp[k,44]
						MsUnlock()
					Endif
					if aVetProp[k,45] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "E"
						LBQ->LBQ_DESC	 := "Redutor PROTEINA"
						LBQ->LBQ_VALOR   := 0
						LBQ->LBQ_QTD	 :=	0
						LBQ->LBQ_CRIQUA	 :=	"S"
						LBQ->LBQ_PAGQUA  := aVetProp[k,45]
						MsUnlock()
					Endif
					if aVetProp[k,46] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "E"
						LBQ->LBQ_DESC	 := "Redutor CCS"
						LBQ->LBQ_VALOR   := 0
						LBQ->LBQ_QTD	 :=	0
						LBQ->LBQ_CRIQUA	 :=	"S"
						LBQ->LBQ_PAGQUA  := aVetProp[k,46]
						MsUnlock()
					Endif
					if aVetProp[k,47] > 0
						RecLock("LBQ",.T.)
						LBQ->LBQ_FILIAL := xFilial("LBQ")
						LBQ->LBQ_DATINI := dDatIni
						LBQ->LBQ_DATFIN := dDatFin
						LBQ->LBQ_CODPRO := aVetProp[k,1]
						LBQ->LBQ_FLAG    := "E"
						LBQ->LBQ_DESC	 := "Redutor CBT"
						LBQ->LBQ_VALOR   := 0
						LBQ->LBQ_QTD	 :=	0
						LBQ->LBQ_CRIQUA	 :=	"S"
						LBQ->LBQ_PAGQUA  := aVetProp[k,47]
						MsUnlock()
					Endif
					
				Endif
			Next
			
			// Gravando Propriedades que entregam Leite B
			dbSelectArea("LBP")
			For i = 1 to Len(aVetCotB)
				wProcura := dbSeek(xFilial("LBP")+aVetCotB[i,1]+Dtos(dDatIni))
				If Inclui
					RecLock("LBP",If(wProcura,.F.,.T.))
					LBP->LBP_FILIAL := xFilial("LBP")
					LBP->LBP_DATINI := dDatIni
					LBP->LBP_DATFIN := dDatFin
					LBP->LBP_CODPRO := aVetCotB[i,1]
					LBP->LBP_NOMFOR := aVetCotB[i,2]
					LBP->LBP_COTAAN := aVetCotB[i,3]
					LBP->LBP_PRODUC := aVetCotB[i,4]
					LBP->LBP_SOBRA  := aVetCotB[i,5]
					LBP->LBP_EXCESS := aVetCotB[i,6]
					LBP->LBP_RATEIO := aVetCotB[i,7]
					LBP->LBP_COTAME := aVetCotB[i,8]
					LBP->LBP_COTADI := aVetCotB[i,9]
					LBP->LBP_OK     := "B"
					LBP->LBP_LINHA  := aVetCotB[i,10]
					MsUnlock()
				Endif
			Next
			
			// Gravando Propriedades que entregam Leite C
			dbSelectArea("LBP")
			For i = 1 to Len(aVetCotC)
				wProcura := dbSeek(xFilial("LBP") + aVetCotC[i,1] + Dtos(dDatIni))
				If Inclui
					RecLock("LBP",If(wProcura,.F.,.T.))
					LBP->LBP_FILIAL := xFilial("LBP")
					LBP->LBP_DATINI := dDatIni
					LBP->LBP_DATFIN := dDatFin
					LBP->LBP_CODPRO := aVetCotC[i,1]
					LBP->LBP_NOMFOR := aVetCotC[i,2]
					LBP->LBP_COTAAN := aVetCotC[i,3]
					LBP->LBP_PRODUC := aVetCotC[i,4]
					LBP->LBP_SOBRA  := aVetCotC[i,5]
					LBP->LBP_EXCESS := aVetCotC[i,6]
					LBP->LBP_RATEIO := aVetCotC[i,7]
					LBP->LBP_COTAME := aVetCotC[i,8]
					LBP->LBP_COTADI := aVetCotC[i,9]
					LBP->LBP_OK     := "C"
					LBP->LBP_LINHA  := aVetCotC[i,10]
					MsUnlock()
				Endif
			Next
			
			aSort(avetProp,,,{|x,y| x[30]+x[1] < y[30]+y[1]})
			
			ProcRegua(Len(aVetProp))
			
			For l = 1 to len(aVetProp)
				
				IncProc("Gerando Notas Fiscais... " + strzero(l,9)+"/"+strzero(len(aVetProp),9))
				
				dbSelectArea("LBB")
				dbSetorder(1)
				dbSeek(xFilial("LBB") + aVetProp[l,1])
				dbSelectArea("SA2")
				dbSetorder(1)
				dbSeek(xFilial("SA2") + LBB->LBB_CODFOR + LBB->LBB_LOJA)
				dbSelectArea("LBB")
				
				nTValInss := 0
				nTBasInss := 0
				nTValIcms := 0
				nTBasIcms := 0
				
				nTotDesp := 0
				nTotRece := 0
				nTotDesc := 0
				nQtdLeiteB := 0
				nValLeiteB := 0
				nQtdLeiteC := 0
				nValLeiteC := 0
				
				
				nTotRece := aVetProp[l,03]+aVetProp[l,04]+aVetProp[l,05]+aVetProp[l,06]+;
				aVetProp[l,07]+aVetProp[l,08]+aVetProp[l,09]+aVetProp[l,10]+;
				aVetProp[l,11]+aVetProp[l,12]+aVetProp[l,13]+aVetProp[l,14]+;
				aVetProp[l,15]+aVetProp[l,16]+aVetProp[l,17]
				
				If Alltrim(aVetProp[l,37]) == "B" // PRICILA
					nQtdLeiteB := aVetProp[l,18]+aVetProp[l,19]+aVetProp[l,20]+aVetProp[l,21]+aVetProp[l,22]+aVetProp[l,23]+ aVetProp[l,24]
					nValLeiteB := aVetProp[l,03]+aVetProp[l,04]+aVetProp[l,05]+aVetProp[l,06]+aVetProp[l,07]+aVetProp[l,08]+ aVetProp[l,09]
				Endif
				If Alltrim(aVetProp[l,37]) == "C" // PRICILA
					nQtdLeiteC := aVetProp[l,24]+aVetProp[l,25]+aVetProp[l,26]+aVetProp[l,27]+aVetProp[l,28]+aVetProp[l,29]
					nValLeiteC := aVetProp[l,09]+aVetProp[l,10]+aVetProp[l,11]+aVetProp[l,12]+aVetProp[l,13]+aVetProp[l,14]
				Endif
				nBonifGran := aVetProp[l,16]  // Bonificação Granel
				nBonifQtde := aVetProp[l,15]  // Bonificação por quantidade
				nOutCred   := aVetProp[l,17]  // Outros creditos
				dFrete	   := aVetProp[l,31]  // Frete a descontar
				
				nSeq := 0
				
				if nValLeiteC + nValLeiteB > 0
					// a Pagar do Proprietario
					if LBB->LBB_FUNRUR == "S"
						dbSelectArea("SED")
						dbSetorder(1)
						dbSeek(xFilial("SED")+SA2->A2_NATUREZ)
						nFunRura := Noround(((nTotRece-aVetProp[l,17]) * SED->ED_PERCINS)/100,2)
					Else
						nFunRura := 0
					Endif
					
					if LBB->LBB_SENAR == "S"
						nVSenar   := ((nTotRece-aVetProp[l,17]) * GetMv("MV_SENAR"))/100
					Else
						nVSenar   := 0
					Endif
					
					//Senar,FunRural,Frete,Taxa Adm
					nTotDesc := NoRound(nVSenar, 2) + NoRound(nFunRura, 2) + NoRound(aVetProp[l,31], 2) + NoRound(aVetProp[l,34], 2)
					
					//Utiliza o codigo do leite estabelecido na tabela de precos
					dbSelectArea("LBH")
					dbSetOrder(1)
					if dbSeek(xFilial("LBH")+LBB->LBB_EST+LBB->LBB_TIPOL)
						cCodLeite := LBH->LBH_CODPRO
						cTE		  := LBH->LBH_TES
					Endif
					
					cNumero := NxtSx5Nota(cSerie, .T., GetNewPar("MV_TPNRNFS","1"))
					
					// Processa o ExecAuto para geracao das Notas Fiscais
					
					aIteTempNFE := {}
					aCabec      := {}
					aItens      := {}
					
					SB1->(DbGoTop())
					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial("SB1") + cCodLeite))
					SF4->(DbGoTop())
					SF4->(dbSetOrder(1))
					SF4->(dbSeek(xFilial("SF4") + cTE))
					LBB->(dbSetOrder(1))
					LBB->(dbSeek(xFilial("LBB") + aVetProp[l,1]))
					cCFB     := SF4->F4_CF
					cFornece := LBB->LBB_CODFOR
					cLoja    := LBB->LBB_LOJA
					nSeq     := 1
					
					// Itens Nota Fiscal
					aadd(aIteTempNFE,{"D1_ITEM"	  ,StrZero(nSeq, TamSx3("D1_ITEM")[1]) ,Nil})
					aadd(aIteTempNFE,{"D1_COD"	  ,cCodLeite			    		   ,Nil})
					aadd(aIteTempNFE,{"D1_UM"	  ,SB1->B1_UM						   ,Nil})
					If LBB->LBB_TIPOL == "B"
						aadd(aIteTempNFE,{"D1_QUANT"  ,nQtdLeiteB		                   ,Nil})
						aadd(aIteTempNFE,{"D1_VUNIT"  ,nValLeiteB/nQtdLeiteB	           ,Nil})
						aadd(aIteTempNFE,{"D1_TOTAL"  ,nValLeiteB		                   ,Nil})
					ElseIf LBB->LBB_TIPOL == "C"
						aadd(aIteTempNFE,{"D1_QUANT"  ,nQtdLeiteC		                   ,Nil})
						aadd(aIteTempNFE,{"D1_VUNIT"  ,nValLeiteC/nQtdLeiteC	           ,Nil})
						aadd(aIteTempNFE,{"D1_TOTAL"  ,nValLeiteC		                   ,Nil})
					Endif
					aadd(aIteTempNFE,{"D1_EMISSAO",dDatFin	                   ,Nil})
					aadd(aIteTempNFE,{"D1_TES"	  ,cTE                                 ,Nil})
					aadd(aIteTempNFE,{"D1_CC"	  ,SB1->B1_CC			               ,Nil})
					aadd(aIteTempNFE,{"D1_RATEIO" ,'2'		                           ,Nil})
					aadd(aIteTempNFE,{"D1_LOCAL"  ,SB1->B1_LOCPAD		               ,Nil})
					aadd(aIteTempNFE,{"D1_DESPESA",aVetProp[l,16] + aVetProp[l,15]    ,Nil})
					aadd(aItens,aIteTempNFE)
					
					// Cabecalho Nota Fiscal
					aadd(aCabec,{"F1_TIPO"  	,"N"		         ,Nil})
					aadd(aCabec,{"F1_ESPECIE"	,"NFE"  	         ,Nil})
					aadd(aCabec,{"F1_FORMUL"	,"S"				 ,Nil})
					aadd(aCabec,{"F1_DOC"  	    ,cNumero			 ,Nil})
					aadd(aCabec,{"F1_SERIE"	    ,cSerie				 ,Nil})
					aadd(aCabec,{"F1_COND"	    ,GetMv("MV_CONDPAD") ,Nil})
					aadd(aCabec,{"F1_EMISSAO"	,dDatFin	         ,Nil})
					aadd(aCabec,{"F1_FORNECE"	,cFornece       	 ,Nil})
					aadd(aCabec,{"F1_LOJA"  	,cLoja		         ,Nil})
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Ponto de entrada para adicionar itens ou manipular cabec. na gravacao da NFE  |
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lTLeiCpoNF
						aRetPE := Execblock("TLEICPONF",.F.,.F.,{aItens,aCabec})
						If ValType(aRetPE[1,1]) == "A" .And. !Empty(aRetPE[1,1])
							aItens := aRetPE[1,1]
						EndIf
						If ValType(aRetPE[1,2]) == "A" .And. !Empty(aRetPE[1,2])
							aCabec := aRetPE[1,2]
						EndIf
					EndIf
					
					MSExecAuto({|x,y| MATA103(x,y)},aCabec,aItens,3)
					
					If lMsErroAuto
						MostraErro()
						DisarmTransaction()
						Break
					Endif
					
					nSeq += 1
					
					If !lMsErroAuto
						
						dbSelectArea("SF1")
						RecLock("SF1",.f.)
						F1_PREFIXO  := &(cPrefixo)
						MsUnlock()
						
						dbSelectArea("SE2")
						If !EOF()
							RecLock("SE2",.f.)
							E2_PREFIXO  := &(cPrefixo)
							E2_VENCTO   := dDatVenc
							E2_VENCREA  := DataValida(dDatVenc,.T.)
							E2_VENCORI  := dDatVenc
							E2_HIST   	:= "Tit. Gerado Fech. Leite"
							MsUnlock()
						EndIf
						DbSelectArea("LBP")
						dbSetOrder(1)
						If dbSeek(xFilial("LBP") + aVetProp[l,1] + Dtos(dDatIni),.F.)
							RecLock("LBP",.f.)
							LBP->LBP_NOTA   := SF1->F1_DOC
							LBP->LBP_SERIE  := SF1->F1_SERIE
							MsUnlock()
						Else
							MsgStop("Erro. Nao achou o arq. fechamento:" + aVetProp[l,1] + Dtos(dDatIni))
						EndIf
						
						nSlvRecSE2 := SE2->(recno())
						
						dbSelectArea("LBB")
						For i = 1 to Len(aVetFin)
							
							if Subs(aVetFin[i,1],1,8) == LBB->LBB_CODFOR+LBB->LBB_LOJA
								for g := 1 to len(aVetFin[i,4])/6
									if aVetFin[i,3] == "SE1"
										dbSelectArea("SE1")
										dbgoto(Val(Subs(aVetFin[i,4],g*6-5,6)))
										//Baixa Automatica dos Titulos a Receber da VetFin
										aVetorSE1 := {}
										lMsErroAuto = .F.
										aVetorSE1 := {		{"E1_PREFIXO"		,SE1->E1_PREFIXO   	,Nil},;
										{"E1_NUM"		 	,SE1->E1_NUM       	,Nil},;
										{"E1_PARCELA"	 	,SE1->E1_PARCELA    ,Nil},;
										{"E1_TIPO"	    	,SE1->E1_TIPO      	,Nil},;
										{"AUTMOTBX"	    	,GetMv("MV_MOTBX") 	,Nil},;
										{"AUTHIST"	    	,"BX por Fechamento do Leite",Nil},;
										{"AUTDTBAIXA"      	,dDatFin      ,Nil},;
										{"AUTVALREC"	 	,SE1->E1_SALDO		,Nil},;
										{"AUTBANCO"			,""       			,Nil},;
										{"AUTAGENCIA"		,""       			,Nil},;
										{"AUTCONTA"			,""					,Nil}}
										
										nTotDesp += SE1->E1_SALDO
										MSExecAuto({|x,y| fina070(x,y)},aVetorSE1,3)
										If lMsErroAuto = .T.
											MostraErro()
											DisarmTransaction()
											Break
										EndIf
									Elseif aVetFin[i,3] == "SE2"
										dbSelectArea("SE2")
										dbgoto(Val(Subs(aVetFin[i,4],g*6-5,6)))
										// Baixa automatica de Titulos a Pagar da VetFin
										aVetorSE2   := {}
										lMsErroAuto := .F.
										aVetorSE2   := {		{"E2_PREFIXO"		,SE2->E2_PREFIXO    	,Nil},;
										{"E2_NUM"		 	,SE2->E2_NUM        	,Nil},;
										{"E2_PARCELA"	 	,SE2->E2_PARCELA        ,Nil},;
										{"E2_TIPO"	    	,SE2->E2_TIPO      	    ,Nil},;
										{"AUTMOTBX"	    	,GetMv("MV_MOTBX")     	,Nil},;
										{"AUTHIST"	    	,"BX por Fechamento do Leite",Nil},;
										{"AUTDTBAIXA"	   	,dDatFin          ,Nil},;
										{"AUTVLRPG" 	 	,SE2->E2_SALDO		    ,Nil},;
										{"AUTBANCO"			,""       			,Nil},;
										{"AUTAGENCIA"		,""       			,Nil},;
										{"AUTCONTA"			,""					,Nil}}
										
										nTotDesp += SE2->E2_SALDO
										MSExecAuto({|x,y| fina080(x,y)},aVetorSE2,3)
										
										If lMsErroAuto = .T.
											MostraErro()
											DisarmTransaction()
											Break
										EndIf
									Endif
								Next
							Endif
						Next
						
						If (nTotDesp + nvSenar + aVetProp[l,34]+ aVetProp[l,31]) > 0
							
							dbSelectArea("SE2")
							dbSetOrder(1)
							dbGoTo(nSlvRecSE2)
							
							// Baixa automatica de Titulos a Pagar
							aVetSE2     := {}
							lMsErroAuto := .F.
							aVetSE2     := {		{"E2_PREFIXO"		,SE2->E2_PREFIXO    	,Nil},;
							{"E2_NUM"	 	    ,SE2->E2_NUM        	,Nil},;
							{"E2_PARCELA"	 	,SE2->E2_PARCELA        ,Nil},;
							{"E2_TIPO"	    	,SE2->E2_TIPO      	    ,Nil},;
							{"AUTMOTBX"	    	,GetMv("MV_MOTBX")     	,Nil},;
							{"AUTHIST"	    	,"BX por Fechamento do Leite",Nil},;
							{"AUTDTBAIXA"	   	,dDatFin          ,Nil},;
							{"AUTVLRPG" 	 	,Noround(If((nTotDesp + nvSenar + aVetProp[l,34]+ aVetProp[l,31])>SE2->E2_SALDO,SE2->E2_SALDO,nTotDesp + nvSenar + aVetProp[l,34]+ aVetProp[l,31]),2),Nil},;
							{"AUTBANCO"			,""       			,Nil},;
							{"AUTAGENCIA"		,""       			,Nil},;
							{"AUTCONTA"			,""					,Nil}}
							
							MSExecAuto({|x,y| fina080(x,y)},aVetSE2,3)
							
							If lMsErroAuto = .T.
								MostraErro()
								DisarmTransaction()
								Break
	    					EndIf
							
						Endif
						
						// Caso as Despesas Sejam maiores que as Receitas das Propriedades
						// cria-se um Titulo a Pagar (Debitos Anteriores) com data do Ultimo
						// dia do mes subsequente
						
						if (nTotDesp + nTotDesc) > nTotRece
							
							SA1->(dbsetorder(1))
							SA1->(dbseek(xFilial("SA1")+LBB->LBB_CODFOR+LBB->LBB_LOJA))
							
							dbselectArea("SE1")
							
							aTitSE1     := {}
							lMsErroAuto := .F.
							
							// CAMPOS FIXOS PARA TODOS OS TITULOS
							Aadd(aTitSE1,{"E1_FILIAL" 		,xFilial("SE1")	  					,Nil})
							Aadd(aTitSE1,{"E1_PREFIXO"		,&(GetMv("MV_PREFSE1"))				,Nil})
							Aadd(aTitSE1,{"E1_NUM"    		,cNumero							,Nil})
							Aadd(aTitSE1,{"E1_PARCELA"		,GetMv("MV_1DUP")					,Nil})
							Aadd(aTitSE1,{"E1_TIPO"   		,GetMv("MV_TPTITE1")				,Nil})
							Aadd(aTitSE1,{"E1_NATUREZ"		,&(GetMv("MV_1DUPNAT"))				,Nil})
							Aadd(aTitSE1,{"E1_CLIENTE"		,cFornece							,Nil})
							Aadd(aTitSE1,{"E1_LOJA"   		,cLoja								,Nil})
							Aadd(aTitSE1,{"E1_EMISSAO"		,dDatFin						,Nil})
							Aadd(aTitSE1,{"E1_VENCTO" 		,dDatVenc							,Nil})
							Aadd(aTitSE1,{"E1_VALOR"  		,Noround((nTotDesp+nTotDesc) - nTotRece,2)	,Nil})
							Aadd(aTitSE1,{"E1_HIST"   		,"Tit. Gerado Fech. Leite"	    	,Nil})
							
							// Inclusao dos titulos no SE1
							MsExecAuto({|x,y|FINA040(x,y)},aTitSE1,3)
							SE1->(MsUnlock())
							
							If lMsErroAuto = .T.
								MostraErro()
								DisarmTransaction()
								Break
							EndIf
							
						Endif
						
						if aVetProp[l,17] > 0
							
							
							SA2->(dbSetorder(1))
							SA2->(dbSeek(xFilial("SA2")+LBB->LBB_CODFOR+LBB->LBB_LOJA))
							
							DbSelectArea("SE2")
							aTitSE2 := {}
							lMsErroAuto := .F.
							
							// Geracao automatica de Titulos do tipo OUTROS CREDITOS
							Aadd(aTitSE2,{"E2_FILIAL" 		,xFilial("SE2")  					,Nil})
							Aadd(aTitSE2,{"E2_PREFIXO"		,&(cPrefixo)						,Nil})
							Aadd(aTitSE2,{"E2_NUM"    		,cNumero							,Nil})
							Aadd(aTitSE2,{"E2_PARCELA"		,GetMv("MV_1DUP")  					,Nil})
							Aadd(aTitSE2,{"E2_TIPO"   		,GetMv("MV_TPTITE2")				,Nil})
							Aadd(aTitSE2,{"E2_NATUREZ"		,GetMv("MV_NATREFRI")  				,Nil})
							Aadd(aTitSE2,{"E2_FORNECE"		,SA2->A2_COD                		,Nil})
							Aadd(aTitSE2,{"E2_LOJA"   		,SA2->A2_LOJA               		,Nil})
							Aadd(aTitSE2,{"E2_EMISSAO"		,dDatFin    						,Nil})
							Aadd(aTitSE2,{"E2_VENCTO" 		,dDatVenc							,Nil})
							Aadd(aTitSE2,{"E2_VALOR"  		,aVetProp[l,17] 					,Nil})
							Aadd(aTitSE2,{"E2_HIST"   		,"Tit. Gerado Fech. Leite"	    	,Nil})
							
							MsExecAuto({|x,y|FINA050(x,y)},aTitSE2,3)
							SE2->(MsUnlock())
							
							If lMsErroAuto = .T.
								MostraErro()
								DisarmTransaction()
								Break
							EndIf
						Endif
					Endif
				Endif
				
				DbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+cCodLeite))
			Next
			If !lMsErroAuto
				// Gera Titulo do Senar
				if nTotSenar > 0
					
					SA2->(dbSetorder(1))
					SA2->(dbSeek(xFilial("SA2")+alltrim(GetMv("MV_FORINSS"))))
					
					DbSelectArea("SE2")
					aTitSE2 := {}
					lMsErroAuto := .F.
					
					// Geracao automatica de Titulos a Pagar (Senar)
					Aadd(aTitSE2,{"E2_FILIAL" 		,xFilial("SE2")  					,Nil})
					Aadd(aTitSE2,{"E2_PREFIXO"		,&(cPrefixo)						,Nil})
					Aadd(aTitSE2,{"E2_NUM"    		,SubStr(dtos(dDatFin),3)    		,Nil})
					Aadd(aTitSE2,{"E2_PARCELA"		,"1"								,Nil})
					Aadd(aTitSE2,{"E2_TIPO"   		,GetMv("MV_TPTITE2")				,Nil})
					Aadd(aTitSE2,{"E2_NATUREZ"		,SA2->A2_NATUREZ					,Nil})
					Aadd(aTitSE2,{"E2_FORNECE"		,SA2->A2_COD                		,Nil})
					Aadd(aTitSE2,{"E2_LOJA"   		,SA2->A2_LOJA               		,Nil})
					Aadd(aTitSE2,{"E2_EMISSAO"		,dDatFin    						,Nil})
					Aadd(aTitSE2,{"E2_VENCTO" 		,dDatVenc							,Nil})
					Aadd(aTitSE2,{"E2_VALOR"  		,nTotSenar							,Nil})
					Aadd(aTitSE2,{"E2_HIST"   		,"Tit. Gerado Fech. Leite"	    	,Nil})
					
					MsExecAuto({|x,y|FINA050(x,y)},aTitSE2,3)
					SE2->(MsUnlock())
					
					If lMsErroAuto = .T.
						MostraErro()
						DisarmTransaction()
						Break
					EndIf
				Endif
				
				lGravou := .t.
				
				U_CAC14B()
				
			Endif
			
			If ExistBlock("CA014DG")
				ExecBlock("CA014DG",.f.,.f.)
			EndIf
			
			End Transaction
			
			If MsgYesNo(OemtoAnsi("Executa rotina de atualização de Saldo em Estoque"))
				Processa({|| Mata300()})
			Endif
			
		Endif
	Endif
Endif

Return(lRet)

    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ RelPla    ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada ao relatorio de Pre fechamento                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum	 	                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                             		   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RelPla()

If FS_VldClas(dDatFin,dDatVenc)
	Processa({|| DemCP()})
	Processa({|| U_TPLCOLR01()})
Endif

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ LevValor ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Calcula totais da propriedade	           		     	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ LevValor(ExpN1)		                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = posicao da propriedade no array                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Array contendo os totais da propriedade                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                             		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LevValor(nPos)  // ,nRet)

Local aRet
Local nTotB1  := aVetProp[nPos,03]
Local nTotB2  := aVetProp[nPos,04]
Local nTotB3  := aVetProp[nPos,05]
Local nTotEB1 := aVetProp[nPos,06]
Local nTotEB2 := aVetProp[nPos,07]
Local nTotEB3 := aVetProp[nPos,08]
Local nTotC1  := aVetProp[nPos,09]
Local nTotC2  := aVetProp[nPos,10]
Local nTotC3  := aVetProp[nPos,11]
Local nTotEC1 := aVetProp[nPos,12]
Local nTotEC2 := aVetProp[nPos,13]
Local nTotEC3 := aVetProp[nPos,14]
Local nTotBQ   := aVetProp[nPos,15]
Local nTotBG   := aVetProp[nPos,16]
Local nTotOC   := aVetProp[nPos,17]
dbSelectArea("LBB")
dbSetorder(1)
dbSeek(xFilial("LBB")+aVetProp[nPos,01])

nTotLei := nTotB1+nTotB2+nTotB3+nTotEB1+nTotEB2+nTotEB3+nTotC1+nTotC2+nTotC3+nTotEC1+nTotEC2+nTotEC3
nTotBru := nTotB1+nTotB2+nTotB3+nTotEB1+nTotEB2+nTotEB3+nTotC1+nTotC2+nTotC3+nTotEC1+nTotEC2+nTotEC3+nTotBQ+nTotBG+nTotOC

nTaxaAdm := aVetProp[nPos,34]
nVlFrete := aVetProp[nPos,31]

//FunRural
dbSelectArea("SA2")
dbSetorder(1)
dbSeek(xFilial("SA2")+LBB->LBB_CODFOR+LBB->LBB_LOJA)
dbSelectArea("SED")
dbSetorder(1)
dbSeek(xFilial("SED")+SA2->A2_NATUREZ)
nFunRural := 0
if LBB->LBB_FUNRUR $ "S "
	nFunRural := Noround(((nTotBru-aVetProp[nPos,17]) * SED->ED_PERCINS)/100,2)
Endif

//Senar
nSenar := 0
if LBB->LBB_SENAR == "S"
	nSenar  := ((nTotBru-aVetProp[nPos,17]) * GetMv("MV_SENAR"))/100
Endif

nTotDes := (nTaxaAdm-nVlFrete-nFunRural-nSenar)
nPerDes := LBB->LBB_TAXADM+GetMv("MV_SENAR")+SED->ED_PERCINS+LBB->LBB_ALIPE1+LBB->LBB_ALIPE2

nTotLiq := nTotBru - nTotDes

aRet := {nTotLiq,nTotBru,nTotDes,nPerDes,nTotLei}

Return(aRet)
    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ LstProd  ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Tela para ajustes da Cota Calculada        		     	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ LstProd(ExpA1)		                                   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = vetor com dados das propriedades                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                             		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LstProd(aVP)

Local oDlgLP, oGetDadLP, cLinhaOK := "AllWaysTrue()", cCampoOK := "AllWaysTrue()"
Local nOpcA := 0, nProp := 0
Local cX3_Usado := "", cX3_Reserv := ""
Local nOpc := 2, cNomePr := "", cLinhaPr := ""
Local aColsOld := aCols
Local aHeadOld := aHeader
Local nOld     := n
Local aSavRot  := aClone(aRotina)
nLinhas    := 99
nOpcG      := 2
nOpc       := 2
nOpca      := 0

//nOpc := 3
aRotina := {{"RDMAKE", "SIGAIXB", 0, 3}}

AADD(aRotina, aClone(aRotina[1]))
AADD(aRotina, aClone(aRotina[1]))

aCols   := {}
aHeader := {}

aAdd(aHeader, {"Linha", "cLinProd", "@!"             , 009, 0, ".F.", "", "C", "xxx", "V", "", ""})
aAdd(aHeader, {"Quantidade", "nQtdeEnt", "@E 9,999,999.99", 010, 4, ".F.", "", "N", "xxx", "V", "", ""})
aAdd(aHeader, {"Valor Final", "nValoFin", "@E 999.9999"    , 008, 4, ".T.", "", "N", "xxx", "V", "", ""})
aAdd(aHeader, {"Produtor", "cNomProd", "@!"             , 031, 0, ".F.", "", "C", "xxx", "V", "", ""})

For nProp := 1 To Len(aVP)
	cLinhaPr := POSICIONE("LBB", 1, xFilial("LBB") + aVP[nProp, 1], "LBB_LINHA")
	cNomePr  := POSICIONE("SA2", 1, xFilial("SA2") + LBB->LBB_CODFOR + LBB->LBB_LOJA, "A2_NOME")
	AAdd(aCols, {cLinhaPr, aVP[nProp,2], LBB->LBB_VALFIN, cNomePr, aVP[nProp,1], .F.})
Next

aSort(aCols,,,{| X, Y | X[1] + X[4] < Y[1] + Y[4]})

DEFINE MSDIALOG oDlgLP TITLE "Altera Valor Final" FROM 0,0 TO 400, 600 PIXEL
oGetDadLP := MsGetDados():New(014,  0,200, 301, nOpc, cLinhaOk,,, .T.,, /*nFreeze*/,,, cCampoOk,,,, oDlgLP)
oGetDadLP:nMax:=Len(aCols) // maximo de linhas por getdados de entrada.
ACTIVATE MSDIALOG oDlgLP CENTERED ON INIT EnchoiceBar(oDlgLP, {|| nOpcA := 1, oDlgLP:End()}, {|| nOpcA := 0, oDlgLP:End()})

If nOpcA == 1
	Begin Transaction
	For nProp := 1 To Len(aCols)
		DbSelectArea("LBB")
		DbSetOrder(1)
		DbSeek(xFilial("LBB")+aCols[nProp,5])
		If Found()
			RecLock("LBB", .F.)
			LBB->LBB_VALFIN := aCols[nProp,3]
			MsUnLock()
		Else
			MsgStop("Erro. nao achou o produtor:"+aCols[nProp,5])
		EndIf
	Next
	End Transaction
EndIf

aRotina := aClone(aSavRot)
aCols   := aColsOld
aHeader := aHeadOld
n       := nOld
If nOpcA == 1
	Processa({|| DemCP(.T.)})
EndIf
Return(.T.)
    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CAC14B() ³ Autor ³ Rogeiro Faro          ³ Data ³ 01/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Processa Recalculo                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite			                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CAC14B()

Local nValorTot1 := 0
Local nQuantTot1 := 0
Local nValorTot2 := 0
Local nQuantTot2 := 0
Local nProd      := 0
Local nTotLt
Local lProcessa	 := .T.
Private oBtn1

DbselectArea("SD3")
DbSetOrder(5)

ProcRegua(reccount() * ((dDatFin-dDatIni)+1))

If SD3->(DbSeek(xFilial("SD3") + GetMv("MV_CODMOVD")))
	aTots := {}
	
	Do While SD3->(!Eof()) .And. xFilial("SD3") == SD3->D3_FILIAL ;
		.And. SD3->D3_TM == GetMv("MV_CODMOVD")
		IncProc("Aguarde... Levantando Entradas... ")
		If SD3->D3_EMISSAO < dDatIni .Or. SD3->D3_EMISSAO > dDatFin // Data fora do intervalo
			SD3->(DbSkip())
			Loop
		EndIf
		If (nPosTots := AScan(aTots,{|x,y| x[1] == SD3->D3_COD }) ) == 0
			Aadd(aTots,{SD3->D3_COD,0,0})
			nPosTots := Len(aTots)
		EndIf
		aTots[nPosTots,2] += SD3->D3_CUSTO1
		aTots[nPosTots,3] += SD3->D3_QUANT
		SD3->(DbSkip())
	Enddo
	
	//--------------------------------------
Else
	MsgAlert("O Estoque não foi atualizado !!! Não existem movimentos de entrada !!!")
	lProcessa := .F.
Endif

If lProcessa
	For nProd := 1 To Len(aTots)
		
		nCustoMed := aTots[nProd,2] / aTots[nProd,3]
		
		cSql := "SELECT SUM(D1_QUANT) as nTotLeite FROM  "
		cSql += RetSQLName("SD1") + " SD1, "
		cSql += RetSQLName("LBB") + " LBB, "
		cSql += RetSQLName("LBP") + " LBP "
		cSql += "WHERE D1_COD = '" + aTots[nProd,1] + "' AND "
		cSql += "LBB.LBB_FILIAL = '" + xFilial("LBB") + "' AND "
		cSql += "LBP.LBP_FILIAL = '" + xFilial("LBP") + "' AND "
		cSql += "SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND "
		cSql += "LBB_CODFOR = D1_FORNECE AND LBB_LOJA = D1_LOJA AND "
		cSql += "D1_EMISSAO >= '" + DTOS(dDatini) + "' AND D1_EMISSAO <= '" + DTOS(dDatFin) + "' AND "
		cSql += "LBP_DATINI >= '" + DTOS(dDatini) + "' AND LBP_DATINI <= '" + DTOS(dDatFin) + "' AND "
		cSql += "LBP_CODPRO = LBB_CODPRO AND "
		cSql += "LBP.D_E_L_E_T_ = ' ' AND LBB.D_E_L_E_T_ = ' ' AND SD1.D_E_L_E_T_ = ' '"
		If ExistBlock("COA14CQry")
			cSql += " "+ExecBlock("COA14CQry",.f.,.f.)
		EndIf
		TCQUERY cSql NEW ALIAS "TOT"
		dbSelectArea("TOT")
		If TOT->(Eof())
			lProcessa := .F.
			Exit
		Endif
		nTotLt := TOT->nTotLeite
		TOT->(DbCloseArea())
		
		DbSelectArea("SB1")
		DbGoTop()
		DbSeek(xFilial("SB1")+aTots[nProd,1])
		
		Reclock("SD3",.T.)
		SD3->D3_FILIAL  := xFilial("SD3")
		SD3->D3_COD     := aTots[nProd,1]
		SD3->D3_UM      := SB1->B1_UM
		SD3->D3_TM      := GetMv("MV_CODMOVR")
		SD3->D3_QUANT   := nTotLt
		SD3->D3_LOCAL   := SB1->B1_LOCPAD
		SD3->D3_GRUPO   := SB1->B1_GRUPO
		SD3->D3_NUMSEQ  := ProxNum()
		SD3->D3_TIPO    := SB1->B1_TIPO
		SD3->D3_CONTA   := SB1->B1_CONTA
		SD3->D3_STSERV  :='N'
		SD3->D3_CUSTO1  := nTotLt * nCustoMed
		SD3->D3_USUARIO := "ESTORNO AJUSTE"
		SD3->D3_EMISSAO := dDatFin
		SD3->D3_CF      := GetMv("MV_TIPCFR")                 //"RE6" OU "RE0"
		SD3->D3_CHAVE   := SubStr(GetMv("MV_TIPCFR"), 2, 2)    //"E6"  OU "E0"
		MsUnlock()
		
		dbSelectArea("SB2")
		dbSetorder(1)
		if dbSeek(Xfilial("SB2") + aTots[nProd,1] + SD3->D3_LOCAL, .F.)
			Reclock("SB2",.f.)
			B2_QATU  := SB2->B2_QATU - nTotLt
			B2_CM1   := nCustoMed
			B2_VATU1 := SB2->B2_CM1 * SB2->B2_QATU
			MsUnlock()
		Endif
	Next
EndIf
	
Return(Nil)
