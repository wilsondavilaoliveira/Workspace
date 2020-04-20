#include "Protheus.ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOR05 ³ Autor ³ Marco Aurelio TRT005  ³ Data ³ 25/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao Credito Bancario                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACCOR07()

//CHKTEMPLATE("COL")
nAgE2_SALDO := 0
nBcE2_SALDO := 0
nTE2_SALDO  := 0
cA2_BANCO   := ""
cA2_AGENCIA := ""                   
cPrefixo    := &(GetMv("MV_PREFSE2"))

nQtd        := 0  //CONTADOR PARA TOTALIZAR OS REGISTROS IMPRESSOS
aOrd        := {}
cDesc1      := "Este programa tem como objetivo imprimir relatorio "
cDesc2      := "de acordo com os parametros informados pelo usuario."
cDesc3      := "Credito Bancario"
cPict       := ""
lEnd        := .F.
lAbortPrint := .F.
limite      := 80
tamanho     := "P"
nomeprog    := "CACCOR07"
nTipo       := 15  //COMPRIMIDO 
aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
nLastKey    := 0
cPerg       := "CACR07"
Titulo      := "Credito Bancario"
nLin        := 80
cbtxt       := Space(10)
cbcont      := 00
CONTFL      := 01
m_pag       := 01
imprime     := .T.
wnrel       := "CACR07" // Coloque aqui o nome do arquivo usado para impressao em disco
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

cQuery := "SELECT"
cQuery += "    SA2.A2_BANCO, SA2.A2_AGENCIA, MAX(LBB.LBB_CODFOR) LBB_CODFOR, MAX(SA2.A2_NUMCON) A2_NUMCON,"
cQuery += "    SE2.E2_NOMFOR, SUM(SE2.E2_SALDO) E2_SALDO"
cQuery += " FROM"
cQuery += "    (" + RetSqlName("SE2") + " SE2 INNER JOIN " + RetSqlName("SA2") + " SA2 ON"
cQuery += "    SE2.E2_FORNECE = SA2.A2_COD AND"
cQuery += "    SE2.E2_LOJA = SA2.A2_LOJA)"
cQuery += "    INNER JOIN " + RetSqlName("LBB") + " LBB ON"
cQuery += "    SA2.A2_COD = LBB.LBB_CODFOR AND"
cQuery += "    SA2.A2_LOJA = LBB.LBB_LOJA"
cQuery += " WHERE"
cQuery += "    SE2.E2_VENCTO BETWEEN '" +Dtos(mv_par01)+ "' AND '" +Dtos(mv_par02) + "' AND"
cQuery += "    SE2.E2_TIPO = 'NF' AND"
cQuery += "    SE2.E2_SALDO > 0 AND"
cQuery += "    SE2.E2_PREFIXO = '" + cPrefixo + "' AND"
cQuery += "    SA2.A2_BANCO<>' ' AND"
cQuery += "    SE2.D_E_L_E_T_ = ' ' AND"
cQuery += "    LBB.D_E_L_E_T_ = ' '"
cQuery += " GROUP BY"                           	
cQuery += "    SA2.A2_BANCO, SA2.A2_AGENCIA, SE2.E2_NOMFOR"
              
TCQUERY cQuery ALIAS RQRY NEW

cabec1:="BANCO.: " + A2_BANCO + SPACE(10) + "AGENCIA.: " + A2_AGENCIA + space(10) +  "Período "+dtoc(mv_par01)+ " a " +dtoc(mv_par02) + ""
cabec2:="Matr     Conta Nro.          Nome do Produtor                           Valor" 

cA2_BANCO := A2_BANCO
cA2_AGENCIA := A2_AGENCIA

_wfim:=RecCount() ; ProcRegua(_wfim)    
while !EOF() 

   IncProc("Gerando Relatório... ")  	

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   if nLin > 60 .or. cA2_AGENCIA <> A2_AGENCIA .or. cA2_BANCO <> A2_BANCO	  
      cabec1:="BANCO.: " + A2_BANCO + SPACE(10) + "AGENCIA.: " + A2_AGENCIA   
 	  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)   
 	  nLin := 9
	  cA2_AGENCIA := A2_AGENCIA
      cA2_BANCO := A2_BANCO	  
   endif

	@nLin,00 PSAY LBB_CODFOR
	@nLin,10 PSAY A2_NUMCON
	@nLin,30 PSAY SUBSTR(E2_NOMFOR,1,65)
	@nLin,70 PSAY TRANSFORM(E2_SALDO,"@E 999,999.99")
		
	nAgE2_SALDO += E2_SALDO   ;  nBcE2_SALDO += E2_SALDO  ; nTE2_SALDO += E2_SALDO
	
	dbskip()
	
	nLin++  //;	nQtd++

	if cA2_AGENCIA <> A2_AGENCIA
	    nLin++
	    //imprime o total para Agencia
	    @ nLin,25 PSAY "Total para a Agencia..: " + cA2_AGENCIA 
	    @ nLin,66 PSAY Transform(nAgE2_SALDO,"@E 999,999,999.99")
		nAgE2_SALDO := 0
		nLin++
	endif
	
	if cA2_BANCO <> A2_BANCO  
		nLin++
	    @ nLin,25 PSAY "Total para o Banco....: " +cA2_BANCO 
	    @ nLin,66 PSAY Transform(nBcE2_SALDO,"@E 999,999,999.99")
		nBcE2_SALDO := 0
		nLin++
	endif

EndDo

nLin++  ; nLin++

@nLin,00 PSAY "Total para Todos os Bancos...: "
@nLin,66 PSAY Transform(nTE2_SALDO,"@E 999,999,999.99")

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
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/VaR07/Def04/Cnt04/Var05/Def05/Cnt05
                                                                        
aAdd(aRegs,{cPerg,"01","Data Inicial","Data Inicial","Data Inicial","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Final","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})

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