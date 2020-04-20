#include "Protheus.ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOR21 ³ Autor ³ Microsiga SJRP        ³ Data ³ 28/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Resumo da Entrada do Leite                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACCOR21()

//CHKTEMPLATE("COL")

nT_QtdAci:=nT_QuantB:=nT_QuanTC:=nqtd:=0  //CONTADOR PARA TOTALIZAR OS REGISTROS IMPRESSOS
nT_QuantAB:=nT_QuantAC:=0  //CONTADOR PARA TOTALIZAR OS REGISTROS IMPRESSOS
aOrd        := {}
CbTxt       := ""
cDesc1      := "Este programa tem como objetivo imprimir relatorio "
cDesc2      := "de acordo com os parametros informados pelo usuario."
cDesc3      := "Resumo de Entrada de Leite"
cPict       := ""
lEnd        := .F.
lAbortPrint := .F.
limite      := 80
tamanho     := "P"
nomeprog    := "CACCOR21"
nTipo       := 18
aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
nLastKey    := 0
cPerg       := "CACR21"
Titulo      := "Resumo de Entrada de Leite"
nLin        := 80
cbtxt       := Space(10)
cbcont      := 00
CONTFL      := 01
m_pag       := 01
imprime     := .T.
wnrel       := "CACR21" // Coloque aqui o nome do arquivo usado para impressao em disco
cString     := "LBO"

dbSelectArea(cString)
dbSetOrder(1)


ValidPerg()

if !Pergunte(cPerg,.t.)
	Return
Endif

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

Processa({|| RptProc("Processando Filtro")})
return

static function RptProc

cQuery:="SELECT"
cQuery:=cQuery+" LBO.LBO_CODPRO, LBO.LBO_NOMFOR, LBO.LBO_TIPOL, SUM(LBO.LBO_VOLCRI) LBO_VOLCRI, SUM(LBO.LBO_QTDACI) LBO_QTDACI, LBD.LBD_CODROT"
cQuery:=cQuery+" FROM " + RetSqlName("LBO") + " LBO, "+RetSqlName("LBD")+" LBD"
cQuery:=cQuery+" WHERE"
cQuery:=cQuery+"    LBO.LBO_FILIAL = '"+xFilial("LBO")+"' AND" 
cQuery:=cQuery+"    LBO.LBO_CODPRO = LBD.LBD_CODPRO AND"
cQuery:=cQuery+"    LBO.LBO_DATENT BETWEEN '" +Dtos(mv_par01)+ "' AND '" +Dtos(mv_par02) + "' AND"
cQuery:=cQuery+"    LBO.D_E_L_E_T_ = ' ' AND LBD.D_E_L_E_T_ = ' '"
cQuery:=cQuery+" GROUP BY"
cQuery:=cQuery+"   LBO.LBO_CODPRO,LBO.LBO_NOMFOR,LBO.LBO_TIPOL,LBD.LBD_CODROT"
cQuery:=cQuery+" ORDER BY"
cQuery:=cQuery+"   LBO.LBO_NOMFOR,LBO.LBO_TIPOL,LBD.LBD_CODROT ASC"

TCQUERY cQuery ALIAS RQRY NEW

cabec1:=space(52)+"Período "+dtoc(mv_par01)+ " a " +dtoc(mv_par02)
//                10        20        30        40        50        60        70        80
//		 012345678901234567890123456789012345678901234567890123456789012345678901234567890
cabec2:="Produtor                         Tp Leite Ent. Classific. Quantidade Leite Ácido"


_wfim:=RecCount() 
ProcRegua(_wfim)

while !EOF()
	
	IncProc("Gerando Relatório... ")
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	if nLin>60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin:=9
	endif
	LBB->(DbSelectArea('LBB'))
	LBB->(DbSetOrder(1))
	LBB->(DbSeek(xFilial('LBB')+RQRY->LBO_CODPRO))
	
	@nLin,00 PSAY SUBSTR(LBO_NOMFOR,1,35)
	@nLin,39 PSAY ALLTRIM(LBB->LBB_TIPOL)
	@nLin,51 PSAY LBO_TIPOL
	@nLin,57 PSAY TRANSFORM(LBO_VOLCRI,"@E 999,999,999")
	@nLin,69 PSAY TRANSFORM(LBO_QTDACI,"@E 999,999,999")
	
	// Antes de Classificar
	IF ALLTRIM(LBB->LBB_TIPOL)=="B"
		nT_QuantAB:=nT_QuantAB+LBO_VOLCRI
	ELSE
		nT_QuanTAC:=nT_QuantAC+LBO_VOLCRI
	ENDIF
	// Apos Classificacao
	IF SUBSTR(LBO_TIPOL,1,1)=="B"
		nT_QuantB:=nT_QuantB+LBO_VOLCRI
	ELSEIF SUBSTR(LBO_TIPOL,1,1)=="C"
		nT_QuantC:=nT_QuantC+LBO_VOLCRI
	ENDIF
	
	nT_QtdAci:=nT_QtdAci+LBO_QTDACI
	
	dbskip()
	
	nLin++  //;	nQtd++
	
EndDo

nLin++  ; nLin++

@ nlin,00 PSAY  'Total Leite B - (Entrada)'
@ nlin,29 PSAY  TRANSFORM(nT_QuantAB,"@E 9,999,999,999")
nLin+=1
@ nlin,00 PSAY  'Total Leite C - (Entrada)'
@ nlin,29 PSAY  TRANSFORM(nT_QuantAC,"@E 9,999,999,999")
nLin+=1
@ nlin,00 PSAY  'Total Leite B/C - (Entrada)'
@ nlin,29 PSAY  TRANSFORM(nT_QuantAC+nT_QuantAB,"@E 9,999,999,999")
nLin+=1
@ nlin,00 PSAY  'Total Leite B - (Classif.)'
@ nlin,29 PSAY  TRANSFORM(nT_QuantB,"@E 9,999,999,999")
nLin+=1
@ nlin,00 PSAY  'Total Leite C - (Classif.)'
@ nlin,29 PSAY  TRANSFORM(nT_QuantC,"@E 9,999,999,999")
nLin+=1
@ nlin,00 PSAY  'Total Leite B/C - (Classif.)'
@ nlin,29 PSAY  TRANSFORM(nT_QuantC+nT_QuantB,"@E 9,999,999,999")
nLin+=1
@ nlin,00 PSAY  'Total Leite Acido'
@ nlin,29 PSAY  TRANSFORM(nT_QtdAci,"@E 9,999,999,999")
nLin++

RQRY->(DBCLOSEAREA())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
Funcion: VALIDPERG
Descricao: Criar as perguntas referentes a este relatorio no SX1
*/

Static Function ValidPerg
Local i, j
Local _sAlias	:= Alias()
Local aRegs		:= {}
Local nTamSX1   := Len(SX1->X1_GRUPO)

dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek(PADR(cPerg,nTamSX1)+"01") .And. Empty(X1_PERSPA)
	While !Eof() .And. Trim(X1_GRUPO) == cPerg
		RecLock("SX1",.F.)
		dbDelete()
		MsUnLock()
		dbSkip()
	EndDo		
EndIf
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
//aAdd(aRegs,{cPerg,"01","Associado","","","mv_ch1","C",6,0,0,"G","","mv_par1","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""}) //sao 39 posições  ...F3 TÁ NA 38a
//aAdd(aRegs,{cPerg,"02","Situacao","","","mv_ch2","N",1,0,0,"C","","mv_par2","Normal","","","","","Inativo","","","","","Demitido","","","","","Todos","","","",""})
//aAdd(aRegs,{cPerg,"03","Tp Produtor","","","mv_ch3","C",1,0,0,"G","","mv_par3","","","","","","","","","","","","","",""})

aAdd(aRegs,{cPerg,"01","Data Inicial","Data Inicial","Data Inicial","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","",""}) //
aAdd(aRegs,{cPerg,"02","Data Final","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","",""}) //

For i:=1 to Len(aRegs)
	If !MsSeek(PADR(cPerg,nTamSX1)+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)
Return
