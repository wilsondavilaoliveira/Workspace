#include "Protheus.ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOR04 ³ Autor ³ Marco Aurelio TRT005  ³ Data ³ 25/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao do Calculo da Cota de Leite B ou C ou ambos      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACCOR04()

//CHKTEMPLATE("COL")

nQtd        := 0  //CONTADOR PARA TOTALIZAR OS REGISTROS IMPRESSOS
TCOTAANT    := 0
TPRODUC     := 0
TSOBRA      := 0
TEXCESSO    := 0
TRATEIO     := 0
TCOTAMES    := 0
TCOTADIA    := 0

aOrd        := {}
cLBP_Ok     := ""
cbTxt       := ""
cDesc1      := "Este programa tem como objetivo imprimir relatorio "
cDesc2      := "de acordo com os parametros informados pelo usuario."
cDesc3      := "Calculo de cota de Leite"
cPict       := ""
lEnd        := .F.
lAbortPrint := .F.
limite      := 80
tamanho     := "M"
nomeprog    := "CACCOR04"
nTipo       := 15  //COMPRIMIDO
aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
nLastKey    := 0
cPerg       := "CACR04"
Titulo      := "Calculo de Cota de Leite"
nLin        := 80
cbtxt       := Space(10)
cbcont      := 00
CONTFL      := 01
m_pag       := 01
imprime     := .T.
wNRel       := "CACR04" // Coloque aqui o nome do arquivo usado para impressao em disco
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

Return


Static Function RptProc()

cQuery := "SELECT"
cQuery += "     LBP.LBP_OK, LBB.LBB_NOMFOR, MAX(LBB.LBB_DESC) LBB_DESC,"
cQuery += "     SUM(LBP.LBP_COTAAN) LBP_COTAAN, SUM(LBP.LBP_PRODUC) LBP_PRODUC, SUM(LBP.LBP_SOBRA) LBP_SOBRA, SUM(LBP.LBP_EXCESS) LBP_EXCESS,"
cQuery += "     SUM(LBP.LBP_RATEIO) LBP_RATEIO, SUM(LBP.LBP_COTAME) LBP_COTAME, SUM(LBP.LBP_COTADI) LBP_COTADI"
cQuery += " FROM"
cQuery += "     " + RetSqlName("LBB") + " LBB,"
cQuery += "     " + RetSqlName("LBP") + " LBP"
cQuery += " WHERE"
cQuery += "     LBB.LBB_CODPRO = LBP.LBP_CODPRO AND"
cQuery += "     LBP.LBP_DATINI <= '" +Dtos(mv_par01)+ "' AND"
cQuery += "     LBP.LBP_DATFIN >= '" +Dtos(mv_par02) + "' AND"
IIF( AllTrim(MV_PAR03) <> "" , cQuery +=  "     LBP.LBP_OK = '" +ALLTRIM(mv_par03) + "' AND",)
cQuery += "     LBB.D_E_L_E_T_ = ' ' AND"
cQuery += "     LBP.D_E_L_E_T_ = ' '"
cQuery += " GROUP BY LBP.LBP_OK, LBB.LBB_NOMFOR "
cQuery += " ORDER BY"
cQuery += "     LBP.LBP_OK ASC,"
cQuery += "     LBB.LBB_NOMFOR ASC"

TCQUERY cQuery NEW ALIAS "RQRY"

cabec1:=space(52)+"Período "+dtoc(mv_par01)+ " a " +dtoc(mv_par02) + ""

cabec2:="Produtor                            Propriedade                 C. Ant    Producao  Sobra     Excesso   Rateio    C.Mes     C. Dia"

cLBP_Ok:=LBP_OK

_wfim:=RecCount() ; ProcRegua(_wfim)
while !EOF()
	
	IncProc("Gerando Relatório... ")
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	if nLin>60 .or. LBP_OK<>cLBP_Ok
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin:=9
		@ nLin,00 PSAY LBP_OK
		nLin++
		cLBP_Ok:=LBP_OK
	endif
	
	@nLin,00 PSAY SUBSTR(LBB_NOMFOR,1,35)
	@nLin,37 PSAY SUBSTR(LBB_DESC,1,24)
	@nLin,63 PSAY TRANSFORM(LBP_COTAAN,"@E 999,999")
	@nLin,73 PSAY TRANSFORM(LBP_PRODUC,"@E 999,999")
	@nLin,83 PSAY TRANSFORM(LBP_SOBRA,"@E 999,999")
	@nLin,93 PSAY TRANSFORM(LBP_EXCESS,"@E 999,999")
	@nLin,103 PSAY TRANSFORM(LBP_RATEIO,"@E 999,999")
	@nLin,113 PSAY TRANSFORM(LBP_COTAME,"@E 999,999")
	@nLin,123 PSAY TRANSFORM(LBP_COTADI,"@E 999,999")
	
	TCOTAANT += LBP_COTAAN
	TPRODUC  += LBP_PRODUC
	TSOBRA   += LBP_SOBRA
	TEXCESSO += LBP_EXCESS
	TRATEIO  += LBP_RATEIO
	TCOTAMES += LBP_COTAME
	TCOTADIA += LBP_COTADI
	
	dbskip()
	
	nLin++  //;	nQtd++
	
	if LBP_OK<>cLBP_Ok
		
		nLin++
		
		@nLin,00  PSAY "Totais para o Leite "+cLBP_OK
		@nLin,61  PSAY TRANSFORM(TCOTAANT,"@E 9,999,999")
		@nLin,71  PSAY TRANSFORM(TPRODUC,"@E 9,999,999")
		@nLin,81  PSAY TRANSFORM(TSOBRA,"@E 9,999,999")
		@nLin,91  PSAY TRANSFORM(TEXCESSO,"@E 9,999,999")
		@nLin,101 PSAY TRANSFORM(TRATEIO,"@E 9,999,999")
		@nLin,111 PSAY TRANSFORM(TCOTAMES,"@E 9,999,999")
		@nLin,121 PSAY TRANSFORM(TCOTADIA,"@E 9,999,999")
		
		TCOTAANT := TPRODUC := TSOBRA := TEXCESSO := 0
		TRATEIO := TCOTAMES := TCOTADIA := 0
		
	Endif
	
EndDo

nLin++  ; nLin++

if TCOTAANT > 0 .and.  TPRODUC >0 .and.  TSOBRA > 0 .and. TEXCESSO > 0 ;
	.and. TRATEIO > 0 .and. TCOTAMES > 0 .and. TCOTADIA > 0
	
	@nLin,00  PSAY "Totais para o Leite "+cLBP_OK
	@nLin,61  PSAY TRANSFORM(TCOTAANT,"@E 9,999,999")
	@nLin,71  PSAY TRANSFORM(TPRODUC,"@E 9,999,999")
	@nLin,81  PSAY TRANSFORM(TSOBRA,"@E 9,999,999")
	@nLin,91  PSAY TRANSFORM(TEXCESSO,"@E 9,999,999")
	@nLin,101 PSAY TRANSFORM(TRATEIO,"@E 9,999,999")
	@nLin,111 PSAY TRANSFORM(TCOTAMES,"@E 9,999,999")
	@nLin,121 PSAY TRANSFORM(TCOTADIA,"@E 9,999,999")
	
Endif

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
EndI
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

aAdd(aRegs,{cPerg,"01","Data Inicial","Data Inicial","Data Inicial","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Final","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","TP Leite","","","mv_ch3","C",1,0,0,"G","","mv_par03","","","","","","","","","","","","","",""})

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
