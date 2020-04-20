#include "Protheus.ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOR17 ³ Autor ³PRICILA PREMICI        ³ Data ³ 25/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Entradas por Linha                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite			                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACCOR17()

//CHKTEMPLATE("COL")

//Declaracao de Variaveis                                             

Private aOrd        := {}
Private cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2      := "de acordo com os parametros informados pelo usuario."
Private cDesc3      := "Entradas Por Linha"
Private cPict       := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "CACCOR17" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private titulo      := "Entradas Por Linha"
Private nLin        := 80
Private Cabec1      := ""
Private Cabec2      := ""
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private imprime     := .T.
Private wnrel       := "CACCOR17" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "LBC"

dbSelectArea("LBC")
dbSetOrder(1)

//Monta a interface padrao com o usuario...

cPerg := "CACR26"    

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

Local nTotQtdB  := 0
Local nTotQtdC  := 0
Local nTotQtd   := 0
Local nTotCri   := 0
Local nTotQtdL  := 0 
Local nTotQtdLB := 0
Local nTotQtdLC := 0
Local nTotQtAci := 0
Private nOrdem

//SELECT PARA SELECIONAR OS DADOS
cQuery := "SELECT"
cQuery += "   MAX(LBO_CODROT) LBO_CODROT, LBC_DESC, LBB_TIPOL,"
cQuery += "   SUM(LBO_VOLCRI) LBO_VOLCRI, SUM(LBO_QTDACI) LBO_QTDACI, SUM(LBO_QUANT) LBO_QUANT"
cQuery += " FROM"
cQuery += " " + RetSqlName("LBC") + " LBC,"
cQuery += " " + RetSqlName("LBB") + " LBB,"
cQuery += " " + RetSqlName("LBO") + " LBO"
cQuery += " WHERE"
cQuery += "    LBC_FILIAL       = '"+XFILIAL("LBC")+"' AND" //Linhas 111 a 114 foram  criadas para
cQuery += "    LBB_FILIAL       = '"+XFILIAL("LBB")+"' AND" //filial em uso
cQuery += "    LBO_FILIAL       = '"+XFILIAL("LBO")+"' AND"
cQuery += "    LBO_CODROT = LBC_CODROT AND"
cQuery += "    LBB_CODPRO = LBO_CODPRO AND"
cQuery += "    LBO_DATENT BETWEEN '" +Dtos(mv_par01)+ "' AND '" +Dtos(mv_par02) + "' AND"
cQuery += "    LBO_CODROT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND"
cQuery += "    LBB.D_E_L_E_T_  = ' ' AND"
cQuery += "    LBC.D_E_L_E_T_  = ' ' AND"
cQuery += "    LBO.D_E_L_E_T_  = ' '"
cQuery += " GROUP BY"
cQuery += "   LBC_DESC, LBB_TIPOL"
cQuery += " ORDER BY"
cQuery += "   LBC_DESC, LBB_TIPOL"

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

While !EOF()
	
	IncProc('Processando Linhas... ')
	
	//³ Verifica o cancelamento pelo usuario...                             ³
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//³ Impressao do cabecalho do relatorio. . .                            ³
	
	If nLin > 60 
		
		Cabec1  := "                                          Periodo " + Dtoc(MV_Par01) + " a " + Dtoc(MV_Par02)
		Cabec2 :=  "Linha  Nome                                    Tipo   Qtd Entregue Vol Desc Criosc   Qtd Liquida     Qtd Acido"
		         //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                 //         10        20        30        40        50        60        70        80        90       100       110       120       130
                 //999999 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA  AA     99,999,999      99,999,999    99,999,999    99,999,999
                 //							TOTAL DA LINHA..: 999999   	9,999,999,999   9,999,999,999 9,999,999,999 9,999,999,999

		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		
		nLin := 9
		
	Endif
	
	@nLin,00 PSAY ALLTRIM(LBO_CODROT)
	@nLin,07 PSAY POSICIONE("LBC", 1, xFilial("LBC") + LBO_CODROT, "LBC_DESC")  
	@nLin,49 PSAY ALLTRIM(LBB_TIPOL)
	@nLin,56 PSAY TRANSFORM(LBO_QUANT,"@E 99,999,999")	// Quantidade entregue
	@nLin,72 PSAY TRANSFORM(LBO_QUANT - LBO_VOLCRI,"@E 99,999,999")   // Volume desconto por crioscopia
	@nLin,86 PSAY TRANSFORM(LBO_VOLCRI,"@E 99,999,999") // Quantidade Liquida
	@nLin,100 PSAY TRANSFORM(LBO_QTDACI,"@E 99,999,999") // Quantidade Acida
    
	nTotQtd    += LBO_QUANT // Total Quantidade Entregue por Linha
	nTotCri    += LBO_QUANT - LBO_VOLCRI // Total Volume desconto por crioscopia por Linha
	nTotQtdL   += LBO_VOLCRI // Total Quantidade Liquida por Linha
	nTotQtAci  += LBO_QTDACI // Total Quantidade Acida por Linha
    
    If Alltrim(LBB_TIPOL) == "B"
   	  nTotQtdB += LBO_QUANT
   	  nTotQtdLB += LBO_VOLCRI
    ElseIf Alltrim(LBB_TIPOL) == "C"
	  nTotQtdC += LBO_QUANT
   	  nTotQtdLC += LBO_VOLCRI
	Endif   


	nLin++   // Avanca a linha de impressao
	
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

nLin++ ; nLin++

@nLin,25 PSAY "Total Leite B"
@nLin,53 PSAY TRANSFORM(nTotQtdB,"@E 9,999,999,999") 	// Quantidade entregue
@nLin,83 PSAY TRANSFORM(nTotQtdLB,"@E 9,999,999,999")  // Quantidade Liquida
nLin++ 

@nLin,25 PSAY "Total Leite C"
@nLin,53 PSAY TRANSFORM(nTotQtdC,"@E 9,999,999,999") 	// Quantidade entregue
@nLin,83 PSAY TRANSFORM(nTotQtdLC,"@E 9,999,999,999")  // Quantidade Liquida

nLin++ ; nLin++

@nLin,50 PSAY REPLICATE("-",60)
nLin++                     
@nLin,25 PSAY "Total Geral"
@nLin,53 PSAY TRANSFORM(nTotQtd,"@E 9,999,999,999") 	// Quantidade entregue
@nLin,69 PSAY TRANSFORM(nTotCri,"@E 9,999,999,999")   // Volume desconto por crioscopia
@nLin,83 PSAY TRANSFORM(nTotQtdL,"@E 9,999,999,999")  // Quantidade Liquida
@nLin,97 PSAY TRANSFORM(nTotQtAci,"@E 9,999,999,999") // Quantidade Acida

nTotQtdB  := 0
nTotQtdC  := 0	
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
