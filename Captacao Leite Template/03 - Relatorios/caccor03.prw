#include "Protheus.ch"
#include "TopConn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOR03 ³ Autor ³ Marco Aurelio TRT005  ³ Data ³ 28/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Resumo das Entradas de Leite por Municipio                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³RicardoBerti³11/01/06³087948³Nao listar Crit.da Qualid.: LBQ_CRIQUA="S"³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ PLANO DE MELHORIA CONTINUA        ³Programa   CACCOR03.PRW ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ITEM PMC  ³ Responsavel              ³ Data                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³      01  ³                          ³                                 ³±±
±±³      02  ³                          ³                                 ³±±
±±³      03  ³                          ³                                 ³±±
±±³      04  ³ Ricardo Berti            ³ 11/01/06                        ³±±
±±³      05  ³                          ³                                 ³±±
±±³      06  ³                          ³                                 ³±±
±±³      07  ³                          ³                                 ³±±
±±³      08  ³                          ³                                 ³±±
±±³      09  ³                          ³                                 ³±±
±±³      10  ³ Ricardo Berti            ³ 11/01/06                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CACCOR03()

//CHKTEMPLATE("COL")

nQtd   := 0  //CONTADOR PARA TOTALIZAR OS REGISTROS IMPRESSOS
nQtdAci:= 0
nQTDB  := 0
nVALOB := 0
nQTDC  := 0
nVALOC := 0

aOrd        := {}
CbTxt       := ""
cDesc1      := "Este programa tem como objetivo imprimir relatorio "
cDesc2      := "de acordo com os parametros informados pelo usuario."
cDesc3      := "Resumo por Municipio"
cPict       := ""
lEnd        := .F.
lAbortPrint := .F.
limite      := 80
tamanho     := "P"
nomeprog    := "CACCOR03"
nTipo       := 18
aReturn     := {"Zebrado" , 1, "Administracao", 1, 2, 1, "", 1}
nLastKey    := 0
cPerg       := "CACR03"
Titulo      := "Resumo por Municipio
nLin        := 80
cbtxt       := Space(10)
cbcont      := 00
CONTFL      := 01
m_pag       := 01
imprime     := .T.
wnrel       := "CACR03" // Coloque aqui o nome do arquivo usado para impressao em disco
cString     := "LBO"

dbSelectArea(cString)
dbSetOrder(1)

ValidPerg() 

if Pergunte(cPerg,.t.)

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If ! nLastKey == 27
	
		SetDefault(aReturn,cString)
		
		If ! nLastKey == 27
		
			Processa({|| RptProc( "Processando Filtro")}) 
	
		EndIf
	EndIf
EndIf

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ RptProc  ³ Autor ³ Marco Aurelio TRT005  ³ Data ³ 28/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Processamento e impressao do relatorio                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Programa principal                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RptProc()

//SELECIONA LEITE B e C
cQuery := "SELECT"
cQuery += "    LBB.LBB_MUN, LBB.LBB_TIPOL, COUNT(DISTINCT LBB.LBB_CODPRO) QtdProd, "
cQuery += "    sum(LBQ.LBQ_QTD) LBQ_QTD,sum(LBQ.LBQ_VALOR) LBQ_VALOR, LBQ.LBQ_FLAG"
cQuery += " FROM"
cQuery += "   " + RetSqlName("LBQ") + " LBQ,"
cQuery += "   " + RetSqlName("LBB") + " LBB"
cQuery += " WHERE"
cQuery += "    LBQ.LBQ_CODPRO = LBB.LBB_CODPRO AND"
cQuery += "    LBQ.LBQ_DATINI BETWEEN '" +Dtos(mv_par01)+ "' AND '" +Dtos(mv_par02) + "' AND"
cQuery += "    LBQ.LBQ_CRIQUA <> 'S' AND"  // Ignora criterios da qualidade
cQuery += "    LBQ.LBQ_FLAG <> 'D' AND"
cQuery += "    LBQ.LBQ_DESC <> 'OUTROS CREDITOS' AND"
cQuery += "    LBB.D_E_L_E_T_ = ' ' AND"
cQuery += "    LBQ.D_E_L_E_T_ = ' '" 
cQuery += "  GROUP BY"
cQuery += "    LBB.LBB_MUN,LBB.LBB_TIPOL,LBQ.LBQ_FLAG"
cQuery += " ORDER BY"
cQuery += "    LBB.LBB_MUN ASC,"
cQuery += "    LBB.LBB_TIPOL ASC"

TCQUERY cQuery New ALIAS "RQRY"

//SELECIONA APENAS LEITE ACIDO
cQuery := "SELECT"
cQuery += "    LBB.LBB_MUN,SUM(LBO.LBO_QTDACI)LBO_QTDACI"
cQuery += " FROM"
cQuery += "    " + RetSqlName("LBB") + " LBB INNER JOIN " + RetSqlName("LBO") + " LBO ON"
cQuery += "    LBB.LBB_CODPRO = LBO.LBO_CODPRO"
cQuery += " WHERE"
cQuery += "    LBO.LBO_QTDACI > 0 AND"
cQuery += "    LBO.LBO_DATENT BETWEEN '" +Dtos(mv_par01)+ "' AND '" +Dtos(mv_par02) + "' AND"
cQuery += "    LBB.D_E_L_E_T_ = ' ' AND LBO.D_E_L_E_T_ = ' '"
cQuery += " GROUP BY"
cQuery += "    LBB.LBB_MUN,LBB.LBB_TIPOL"
cQuery += " ORDER BY"
cQuery += "    LBB.LBB_MUN ASC,"
cQuery += "    LBB.LBB_TIPOL ASC"

TCQUERY cQuery New ALIAS "RQRY2"

cabec1 := space(52)+"Período "+dtoc(mv_par01)+ " a " +dtoc(mv_par02)
                                                               
cabec2 := "  Municipio         Tipo Leite        QtdProd        Quantidade         Valor"

DbSelectArea("RQRY")

_wfim:=RecCount() 
ProcRegua(_wfim)    
while !EOF() 

   IncProc("Gerando Relatório... ")

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   if nLin > 60
 	  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)   
 	  nLin := 9
   endif

	@nLin,02 PSAY RQRY->LBB_MUN
	@nLin,25 PSAY RQRY->LBB_TIPOL
	@nLin,35 PSAY TRANSFORM(RQRY->QtdProd,"@E 99,999")
	@nLin,52 PSAY TRANSFORM(RQRY->LBQ_QTD,"@E 999,999,999")
	@nLin,63 PSAY TRANSFORM(RQRY->LBQ_VALOR,"@E 999,999,999.99")

    IF RQRY->LBB_MUN==RQRY2->LBB_MUN 
    	nLin++
		@nLin,02 PSAY RQRY->LBB_MUN
		@nLin,25 PSAY 'A'            
		@nLin,52 PSAY TRANSFORM(RQRY2->LBO_QTDACI,"@E 999,999,999")
		nQtdAci += RQRY2->LBO_QTDACI		
		RQRY2->(DBSKIP())
	ENDIF
	
	IF ALLTRIM(RQRY->LBB_TIPOL)=="B"
		nQTDB := nQTDB + RQRY->LBQ_QTD
		nVALOB := nVALOB + RQRY->LBQ_VALOR
	Endif
	IF ALLTRIM(RQRY->LBB_TIPOL)=="C"
		nQTDC := nQTDC + RQRY->LBQ_QTD
		nVALOC := nVALOC + RQRY->LBQ_VALOR		
	ENDIF

	dbskip() 
	
	nLin++
   
EndDo

nLin++  ; nLin++

@ nlin,03 PSAY  'Total Leite B'
@ nlin,23 PSAY  'Total Leite C'
@ nlin,43 PSAY  'Total Leite B+C'
@ nlin,60 PSAY  '     Leite Acido'
nLin++ 
@ nlin,03 PSAY  TRANSFORM(nQTDB,"@E 9,999,999,999")
@ nlin,23 PSAY  TRANSFORM(nQTDC,"@E 9,999,999,999")
@ nlin,43 PSAY  TRANSFORM(nQTDB+nQTDC,"@E 9,999,999,999")
@ nlin,63 PSAY  TRANSFORM(nQtdAci,"@E 9,999,999,999")

nLin++ ; nLin++
@ nlin,03 PSAY  'Valor Leite B'
@ nlin,23 PSAY  'Valor Leite C'
@ nlin,43 PSAY  '  Valor Total'
nLin++
@ nlin,00 PSAY  TRANSFORM(nVALOB,"@E 9,999,999,999.99")
@ nlin,20 PSAY  TRANSFORM(nVALOC,"@E 9,999,999,999.99")
@ nlin,40 PSAY  TRANSFORM(nVALOB+nVALOC,"@E 9,999,999,999.99")


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

DbSelectArea("RQRY")
DBCLOSEAREA()
DbSelectArea("RQRY2")
DBCLOSEAREA()

MS_FLUSH()

Return(Nil)
           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ValidPerg³ Autor ³ Marco Aurelio TRT005  ³ Data ³ 28/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Criar as perguntas referentes a este relatorio no SX1      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Programa principal                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()

Local aArea		:= GetArea()
Local aHelpP01	:= {}
Local aHelpE01	:= {}
Local aHelpS01	:= {}
Local aHelpP02	:= {}
Local aHelpE02	:= {}
Local aHelpS02	:= {}
Local nTamSX1   := Len(SX1->X1_GRUPO)

If MsSeek(PADR(cPerg,nTamSX1)+"01") .And. Empty(X1_PERSPA)
	While !Eof() .And. Trim(X1_GRUPO) == cPerg
		RecLock("SX1",.F.)
		dbDelete()
		MsUnLock()
		dbSkip()
	EndDo		
EndIf

/*-----------------------MV_PAR01--------------------------*/
PutSx1(	cPerg,"01","Data Inicial ?","¿Fecha Inicial ?","Initial date ?","mv_ch1",;
		"D",8,0,0,"G","NaoVazio()","","","","mv_par01","","",""," ","","","","","","","","","",;
		"","","",{},{},{})

Aadd( aHelpP01, "Informe a data inicial para a filtragem " )
Aadd( aHelpP01, "dos dados.	                             " )

Aadd( aHelpE01, "Enter initial date to filter data.      " )

Aadd( aHelpS01, "Informe la fecha inicial para filtrado  " )
Aadd( aHelpS01, "de los datos.	                         " )

PutSX1Help("P."+cPerg+"01.",aHelpP01,aHelpE01,aHelpS01)

/*-----------------------MV_PAR02--------------------------*/
PutSx1(	cPerg,"02","Data Final ?","¿Fecha Final ?","Final date ?","mv_ch2",;
		"D",8,0,0,"G","NaoVazio()","","","","mv_par02","","",""," ","","","","","","","","","",;
		"","","",{},{},{})

Aadd( aHelpP02, "Informe a data final para a filtragem   " )
Aadd( aHelpP02, "dos dados.	                             " )

Aadd( aHelpE02, "Enter final date to filter data.        " )

Aadd( aHelpS02, "Informe la fecha final para filtrado    " )
Aadd( aHelpS02, "de los datos.	                         " )

PutSX1Help("P."+cPerg+"02.",aHelpP02,aHelpE02,aHelpS02)

RestArea(aArea)
Return(Nil)           
