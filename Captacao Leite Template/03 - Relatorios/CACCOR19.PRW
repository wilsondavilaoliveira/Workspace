#include "Protheus.ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOR19 ³ Autor ³ Microsiga SJRP        ³ Data ³ 28/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Totalizar as Entradas por Propriedades                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACCOR19()

//CHKTEMPLATE("COL")

//Declaracao de Variaveis                                             ³

Private aOrd        := {}
Private cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2      := "de acordo com os parametros informados pelo usuario."
Private cDesc3      := "Total de entradas por propriedade"
Private cPict       := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "CACCOR19" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private titulo      := "Total de entradas por propriedade"
Private nLin        := 80
Private Cabec1      := ""
Private Cabec2      := ""
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private imprime     := .T.
Private wnrel       := "CACCOR19" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "LBO"

dbSelectArea("LBO") 
dbSetOrder(1)

//Monta a interface padrao com o usuario...

cPerg := "CACR19"    
ValidPerg()

if !Pergunte(cPerg,.t.)
	Return
Endif

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//Processamento. RPTSTATUS monta janela com a regua de processamento.

Processa({|| RptProc("Processando...")})
return



/*/
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP5 IDE            º Data ³  17/01/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
/*/
Static function RptProc

Local nTotQtd   := 0
Local nTotCri   := 0
Local nTotQtdL  := 0
Local nTotQtAci := 0
Local nSTotQtd   := 0
Local nSTotCri   := 0
Local nSTotQtdL  := 0
Local nSTotQtAci := 0
Local nPTotQtd   := 0
Local nPTotCri   := 0
Local nPTotQtdL  := 0
Local nPTotQtAci := 0



Private nOrdem

//SELECT PARA SELECIONAR OS DADOS
cQuery := "SELECT"
cQuery += "   LBO_CODROT, LBO_DATENT, MAX(LBO_CODPRO) LBO_CODPRO, LBO_NOMFOR,"
cQuery += "   SUM(LBO_VOLCRI) LBO_VOLCRI, SUM(LBO_QTDACI) LBO_QTDACI, SUM(LBO_QUANT) LBO_QUANT"
cQuery += " FROM"
cQuery += " " + RetSqlName("LBO") + " LBO"
cQuery += " WHERE"
cQuery += "    LBO_FILIAL       = '"+XFILIAL("LBO")+"' AND"
cQuery += "    LBO_DATENT BETWEEN '" +Dtos(mv_par01)+ "' AND '" +Dtos(mv_par02) + "' AND"
cQuery += "    LBO_CODROT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND" 
cQuery += "    LBO_CODPRO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' AND"
cQuery += "    LBO.D_E_L_E_T_  = ' '"
cQuery += " GROUP BY"
cQuery += "   LBO_CODROT, LBO_NOMFOR , LBO_DATENT"
cQuery += " ORDER BY"
cQuery += "   LBO_CODROT, LBO_NOMFOR , LBO_DATENT"

TCQUERY cQuery ALIAS RQRY NEW

//³ PROCREGUA -> Indica quantos registros serao processados para a regua ³
DBGOTOP()
nNumReg:=0
WHILE !EOF()
	nNumReg++
	dbskip()
ENDDO
ProcRegua(nNumReg)

dbGoTop()
cLinha := ""
cProdutor := ""

While !EOF()
	
	IncProc('Processando Linha..: '+cLinha)
	
	//³ Verifica o cancelamento pelo usuario...                             ³
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//³ Impressao do cabecalho do relatorio. . .                            ³
	
	If nLin > 60 .or. cLinha <> LBO_CODROT // Salto de Página. Neste caso o formulario tem 55 linhas...
		
		Cabec1 := "Linha..: " + AllTrim(LBO_CODROT)  + SPACE(26) + "Periodo de "+DTOC(MV_PAR01)+" a "+DTOC(MV_PAR02)
		Cabec2 := "Prop.     Produtor                                  Data     Qtd Entregue  Vol Desc Criosc   Qtd Liquida     Qtd Acido"
		         //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                 //         10        20        30        40        50        60        70        80        90       100       110       120       130
                 //999999    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 99/99/99    99,999,999       99,999,999    99,999,999    99,999,999
                 //							TOTAL DA LINHA..: 999999  	 	   9,999,999,999    9,999,999,999 9,999,999,999 9,999,999,999
                                     
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		
		cLinha := LBO_CODROT
		nLin := 9
		
	Endif
	If cProdutor <> LBO_CODPRO		
		cProdutor := LBO_CODPRO
		@nLin,00 PSAY ALLTRIM(LBO_CODPRO)
		@nLin,10 PSAY ALLTRIM(LBO_NOMFOR)
	Endif
	
	@nLin,51 PSAY STOD(LBO_DATENT)
	@nLin,63 PSAY TRANSFORM(LBO_QUANT,"@E 99,999,999")	// Quantidade entregue
	@nLin,80 PSAY TRANSFORM(LBO_QUANT - LBO_VOLCRI,"@E 99,999,999")   // Volume desconto por crioscopia
	@nLin,94 PSAY TRANSFORM(LBO_VOLCRI,"@E 99,999,999") // Quantidade Liquida
	@nLin,108 PSAY TRANSFORM(LBO_QTDACI,"@E 99,999,999") // Quantidade Acida
    

	nTotQtd    += LBO_QUANT // Total Quantidade Entregue por Linha
	nTotCri    += LBO_QUANT - LBO_VOLCRI // Total Volume desconto por crioscopia por Linha
	nTotQtdL   += LBO_VOLCRI // Total Quantidade Liquida por Linha
	nTotQtAci  += LBO_QTDACI // Total Quantidade Acida por Linha
	
	nSTotQtd   += LBO_QUANT
	nSTotCri   += LBO_QUANT - LBO_VOLCRI // Total Volume desconto por crioscopia por Linha
	nSTotQtdL  += LBO_VOLCRI // Total Quantidade Liquida por Linha
	nSTotQtAci += LBO_QTDACI // Total Quantidade Acida por Linha

	nPTotQtd   += LBO_QUANT
	nPTotCri   += LBO_QUANT - LBO_VOLCRI // Total Volume desconto por crioscopia por Linha
	nPTotQtdL  += LBO_VOLCRI // Total Quantidade Liquida por Linha
	nPTotQtAci += LBO_QTDACI // Total Quantidade Acida por Linha


	
	nLin++   // Avanca a linha de impressao
	
	dbSkip() // Avanca o ponteiro do registro no arquivo
	
	if cProdutor <> LBO_CODPRO	
	
		nLin++ ; nLin++
		
		@nLin,60 PSAY REPLICATE("-",60)
		nLin++
		@nLin,25 PSAY "Total da Propriedade --> "
		@nLin,60 PSAY TRANSFORM(nPTotQtd,"@E 9,999,999,999") 	// Quantidade entregue
		@nLin,77 PSAY TRANSFORM(nPTotCri,"@E 9,999,999,999")   // Volume desconto por crioscopia
		@nLin,91 PSAY TRANSFORM(nPTotQtdL,"@E 9,999,999,999")  // Quantidade Liquida
		@nLin,105 PSAY TRANSFORM(nPTotQtAci,"@E 9,999,999,999") // Quantidade Acida
		nLin++ ; nLin++		
		@nLin,00 PSAY Replicate("_",limite)
		nLin++ ; nLin++
		nPTotQtd   := 0
		nPTotCri   := 0
		nPTotQtdL  := 0
		nPTotQtAci := 0

		
	
	Endif
	
	if cLinha <> LBO_CODROT
		
		nLin++ 
		@nLin,25 PSAY "Total da Linha -------> "
		@nLin,60 PSAY TRANSFORM(nSTotQtd,"@E 9,999,999,999") 	// Quantidade entregue
		@nLin,77 PSAY TRANSFORM(nSTotCri,"@E 9,999,999,999")   // Volume desconto por crioscopia
		@nLin,91 PSAY TRANSFORM(nSTotQtdL,"@E 9,999,999,999")  // Quantidade Liquida
		@nLin,105 PSAY TRANSFORM(nSTotQtAci,"@E 9,999,999,999") // Quantidade Acida

		nSTotQtd   := 0
		nSTotCri   := 0
		nSTotQtdL  := 0
		nSTotQtAci := 0
	
	endif
	
EndDo

nLin++ ; nLin++		
@nLin,000 PSAY Replicate("_",limite)
nLin++ ; nLin++
@nLin,25 PSAY "Total Geral ---------> "
@nLin,60 PSAY TRANSFORM(nTotQtd,"@E 9,999,999,999") 	// Quantidade entregue
@nLin,77 PSAY TRANSFORM(nTotCri,"@E 9,999,999,999")   // Volume desconto por crioscopia
@nLin,91 PSAY TRANSFORM(nTotQtdL,"@E 9,999,999,999")  // Quantidade Liquida
@nLin,105 PSAY TRANSFORM(nTotQtAci,"@E 9,999,999,999") // Quantidade Acida
	
nTotQtd   := 0
nTotCri   := 0
nTotQtdL  := 0
nTotQtAci := 0

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

DBSELECTAREA("RQRY")
DBCLOSEAREA()

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
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/VaR14/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Data Inicial ","Data Inicial","Data Inicial","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","",""}) //
aAdd(aRegs,{cPerg,"02","Data Final   ","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","",""}) //
aAdd(aRegs,{cPerg,"03","Linha De     ","","","mv_ch3","C",6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","LBC","","",""}) //
aAdd(aRegs,{cPerg,"04","Linha Ate    ","","","mv_ch4","C",6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","LBC","","",""}) //
aAdd(aRegs,{cPerg,"05","Propriedade De  ","","","mv_ch5","C",6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","LBB","","",""}) //
aAdd(aRegs,{cPerg,"06","Propriedade Ate ","","","mv_ch6","C",6,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","LBB","","",""}) //

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
