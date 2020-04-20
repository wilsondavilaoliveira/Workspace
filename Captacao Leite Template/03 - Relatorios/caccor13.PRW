#include "Protheus.ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOR13 ³ Autor ³ Marco Aurelio TRT005  ³ Data ³ 25/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Saldo Devedor                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite   			                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACCOR13()

//CHKTEMPLATE("COL")

nTE1_SALDO  := 0
nTE1_VALOR  := 0
cPrefixo    := &(GetMv("MV_PREFSE1"))

nQtd        :=0 
aOrd        := {}
cDesc1      := "Este programa tem como objetivo imprimir relatorio "
cDesc2      := "de acordo com os parametros informados pelo usuario."
cDesc3      := "Relação de Saldo Devedor"
cPict       := ""
lEnd        := .F.
lAbortPrint := .F.
limite      := 80
tamanho     := "P"
nomeprog    := "CACCOR13"
nTipo       := 18  //COMPRIMIDO 
aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
nLastKey    := 0
cPerg       := "CACR13"
Titulo      := "Relação de Saldo Devedor"
nLin        := 80
cbtxt       := Space(10)
cbcont      := 00
CONTFL      := 01
m_pag       := 01
imprime     := .T.
wnrel       := "CACR13" // Coloque aqui o nome do arquivo usado para impressao em disco
cString     := "SE1"

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
cQuery += "         MAX(SA1.A1_COD) A1_COD, SA1.A1_NOME, SUM(SE1.E1_SALDO) E1_SALDO, SUM(SE1.E1_VALOR) E1_VALOR"
cQuery += "    FROM"
cQuery += "        " + RetSqlName("SA1") + " SA1,"
cQuery += "        " + RetSqlName("SE1") + " SE1"
cQuery += "    WHERE"
cQuery += "        SA1.A1_COD = SE1.E1_CLIENTE AND"
cQuery += "        SA1.A1_LOJA = SE1.E1_LOJA AND"
cQuery += "        SE1.E1_TIPO = '" +GetMv("MV_TPTITE1")+ "' AND" 
cQuery += "        SE1.E1_PREFIXO = '" + cPrefixo + "' AND"
cQuery += "        SE1.E1_VENCREA BETWEEN '" +Dtos(mv_par01)+ "' AND '" +Dtos(mv_par02) + "' AND"
cQuery += "    	   SA1.A1_COD >= '" +ALLTRIM(mv_par03) + "' AND"
cQuery += "    	   SA1.A1_COD <= '" +ALLTRIM(mv_par04) + "' AND"
cQuery += "        SE1.E1_SALDO > 0 AND"
cQuery += "        SA1.D_E_L_E_T_ = ' ' AND"
cQuery += "        SE1.D_E_L_E_T_ = ' '"
cQuery += "    GROUP BY "
cQuery += "        SA1.A1_NOME"

TCQUERY cQuery ALIAS RQRY NEW

cabec1:=space(52)+"Período "+dtoc(mv_par01)+ " a " +dtoc(mv_par02) + ""
                                                               
cabec2:="Codigo  Nome                                                  Valor        Saldo"
       //012345678901234567890123456789012345678901234567890123456789012345678901234567890
	   //									             	    9,999,999.99 9,999,999.99
_wfim:=RecCount() ; ProcRegua(_wfim)    
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

	@nLin,00 PSAY A1_COD
	@nLin,08 PSAY SUBSTR(A1_NOME,1,40)              
	@nLin,55 PSAY TRANSFORM(E1_VALOR,"@E 9,999,999.99") 
	@nLin,68 PSAY TRANSFORM(E1_SALDO,"@E 9,999,999.99") 

    nTE1_SALDO += E1_SALDO 
    nTE1_VALOR += E1_VALOR

	dbskip()
	
	nLin++  //;	nQtd++
  
EndDo

nLin++  ; nLin++

@nLin,00 PSAY "Total --------------------------------->"
@nLin,55 PSAY TRANSFORM(nTE1_VALOR,"@E 9,999,999.99")
@nLin,68 PSAY TRANSFORM(nTE1_SALDO,"@E 9,999,999.99")

RQRY->(DBCLOSEAREA())  //Fecha o Alias Temporario

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

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/VaR13/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Data Inicial","Data Inicial","Data Inicial","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","",""}) //
aAdd(aRegs,{cPerg,"02","Data Final","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","",""}) //
aAdd(aRegs,{cPerg,"03","Produtor De","","","mv_ch3","C",6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","",""}) //
aAdd(aRegs,{cPerg,"04","Produtor Ate","","","mv_ch4","C",6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","",""}) //

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