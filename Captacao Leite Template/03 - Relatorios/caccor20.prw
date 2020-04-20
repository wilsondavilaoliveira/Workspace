#include "Protheus.ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOR20 ³ Autor ³ Microsiga SJRP        ³ Data ³ 28/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Entradas nao Analizadas                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACCOR20()

//CHKTEMPLATE("COL")

nTLBO_QUANT  := nTValor := 0

nqtd        := 0
aOrd        := {}
cDesc1      := "Este programa tem como objetivo imprimir relatorio "
cDesc2      := "de acordo com os parametros informados pelo usuario."
cDesc3      := "Entradas nao Analisadas"
cPict       := ""
lEnd        := .F.
lAbortPrint := .F.
limite      := 80
tamanho     := "P"
nomeprog    := "CACCOR20"
nTipo       := 18  //COMPRIMIDO 
aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
nLastKey    := 0
cPerg       := "CACR20"
Titulo      := "Entradas nao Analisadas"
nLin        := 80
cbtxt       := Space(10)
cbcont      := 00
CONTFL      := 01
m_pag       := 01
imprime     := .T.
wnrel       := "CACR20" // Coloque aqui o nome do arquivo usado para impressao em disco
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


Static Function RptProc
Local cCodRot := ""

cQuery := "SELECT"
cQuery += " LBO.LBO_CODROT, LBO.LBO_DATENT, LBO.LBO_CODPRO, LBO.LBO_NOMFOR"
cQuery += " FROM" 
cQuery += "    " + RetSqlName("LBD") + " LBD,"
cQuery += "    " + RetSqlName("LBO") + " LBO"
cQuery += " WHERE LBO_TIPOL = ' ' AND"
cQuery += "    LBD.LBD_CODPRO = LBO.LBO_CODPRO AND"      
cQuery += "    LBO.LBO_DATENT BETWEEN '" +Dtos(mv_par01)+ "' AND '" +Dtos(mv_par02) + "' AND"
cQuery += "    LBO.D_E_L_E_T_ = ' ' AND"     
cQuery += "    LBD.D_E_L_E_T_ = ' '"     
cQuery += " GROUP BY"
cQuery += "	   LBO.LBO_CODROT, LBO.LBO_DATENT, LBO.LBO_CODPRO, LBO.LBO_NOMFOR"
cQuery += " ORDER BY"
cQuery += "   LBO.LBO_CODROT, LBO.LBO_DATENT, LBO.LBO_NOMFOR"

TCQUERY cQuery ALIAS RQRY NEW

cabec1:=space(52)+"Período "+dtoc(mv_par01)+ " a " +dtoc(mv_par02) + ""
                                                               
cabec2:="Linha   Data Entrada  Propriedade  Fornecedor"
	   //01234567890123456789012345678901234567890123456789012345678901234567890123456789
	   //999999  99/99/99      999999       AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
_wfim:=RecCount() ; ProcRegua(_wfim)    
while !EOF()           

   cCodRot := LBO_CODROT
   
   IncProc("Gerando Relatório... ")

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   if nLin>60 
 	  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)   
 	  nLin:=9
   endif                    
   
	@nLin,00 PSAY LBO_CODROT
	@nLin,08 PSAY STOD(LBO_DATENT)
	@nLin,22 PSAY LBO_CODPRO
	@nLin,35 PSAY LBO_NOMFOR

	dbskip()                
	
	If cCodRot <> LBO_CODROT
		nLin++  //;	nQtd++
		@nLin,00 PSAY Replicate("_",limite)
		nLin++  //;	nQtd++
	eNDIF
	
	nLin++  //;	nQtd++
  
EndDo

nLin++  ; nLin++

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
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/VaR20/Def04/Cnt04/Var05/Def05/Cnt05

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