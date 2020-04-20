#include "Protheus.ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOR25 ³ Autor ³MARCO AURELIO (TRT005) ³ Data ³ 25/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Recalculo de Cota Total                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACCOR25()

//CHKTEMPLATE("COL")

nT_COTANT:=nT_COTAT:=_wfim:=0

nqtd        :=0 
aOrd        := {"Cod Propr","Cod Propr"}
cDesc1      := "Este programa tem como objetivo imprimir relatorio "
cDesc2      := "de acordo com os parametros informados pelo usuario."
cDesc3      := "Relatorio Cota Total"
cPict       := ""
lEnd        := .F.
lAbortPrint := .F.
limite      := 80
tamanho     := "M"
nomeprog    := "CACCOR25"
nTipo       := 18  //COMPRIMIDO 
aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
nLastKey    := 0
cPerg       := "CACR25"
Titulo      := "Relatorio Cota Total"
nLin        := 80
cbtxt       := Space(10)
cbcont      := 00
CONTFL      := 01
m_pag       := 01
imprime     := .T.
wnrel       := "CACR25" // Coloque aqui o nome do arquivo usado para impressao em disco
cString     := "LBG"

//dbSelectArea(cString)
//dbSetOrder(1)

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

Processa({|| RptProc("Selecionando Dados")})
return

static function RptProc

nOrdem := aReturn[8]  // recebe o código relacionado ao ordenamento desejada

cQuery := "SELECT"
cQuery += "    COUNT(LBG.LBG_CODPRO) nQtdReg"
cQuery += " FROM "
cQuery += "   " + RetSqlName("LBG") + " LBG,"
cQuery += "   " + RetSqlName("LBB") + " LBB"
cQuery += " WHERE"
cQuery += "   LBG.LBG_CODPRO = LBB.LBB_CODPRO AND"
cQuery += "   LBG.LBG_DATINI = '" + dtos(MV_PAR01) + "' AND LBG.LBG_DATFIN = '" + dtos(MV_PAR02) + "' AND"
cQuery += "   LBB.D_E_L_E_T_  = ' ' AND LBG.D_E_L_E_T_ = ' '"

TCQUERY cQuery ALIAS RQRY NEW

_wfim := nQtdReg

RQRY->(dbclosearea())

cQuery := "SELECT"
cQuery += "    LBG.LBG_CODPRO, LBB.LBB_CODFOR, LBB.LBB_LOJA, LBB.LBB_NOMFOR, "
cQuery += "    LBG.LBG_DATINI, LBG.LBG_DATFIN, LBG.LBG_COTANT, LBG.LBG_COTAT"
cQuery += " FROM "
cQuery += "   " + RetSqlName("LBG") + " LBG,"
cQuery += "   " + RetSqlName("LBB") + " LBB"
cQuery += " WHERE"
cQuery += "   LBG.LBG_CODPRO = LBB.LBB_CODPRO AND"
cQuery += "   LBG.LBG_DATINI = '" + dtos(MV_PAR01) + "' AND LBG.LBG_DATFIN = '" + dtos(MV_PAR02) + "' AND"
cQuery += "   LBB.D_E_L_E_T_  = ' ' AND LBG.D_E_L_E_T_ = ' '"
cQuery += " ORDER BY "
cQuery += if(nOrdem==1,"   LBG.LBG_CODPRO","   LBB.LBB_NOMFOR")

TCQUERY cQuery ALIAS RQRY NEW

cabec1:=space(52)+"Período "+dtoc(mv_par01)+ " a " +dtoc(mv_par02) + ""
                                                               
cabec2:="CodProp    CodFor   Loja   Nome Fornecedor                              DT Ini      DT Fim         Ct Ant.        Cota Atual"

ProcRegua(_wfim)    

while !EOF() 

   IncProc("Gerando Relatório... ")

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   if nLin>65 
 	  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)   
 	  nLin:=9
   endif

    @nLin,00  PSAY LBG_CODPRO
	@nLin,11  PSAY LBB_CODFOR
	@nLin,20  PSAY LBB_LOJA
	@nLin,27  PSAY substr(LBB_NOMFOR,1,40)
	@nLin,70  PSAY SUBSTR(LBG_DATINI,7,2)+"/"+SUBSTR(LBG_DATINI,5,2)+"/"+SUBSTR(LBG_DATINI,1,4)
	@nLin,82  PSAY SUBSTR(LBG_DATFIN,7,2)+"/"+SUBSTR(LBG_DATFIN,5,2)+"/"+SUBSTR(LBG_DATFIN,1,4)
	@nLin,96  PSAY TRANSFORM(LBG_COTANT,"99999999")
	@nLin,111 PSAY TRANSFORM(LBG_COTAT,"99999999")

    nT_COTANT  += LBG_COTANT
    nT_COTAT   += LBG_COTAT
    
	dbskip()
	
	nLin++  
  
EndDo

nLin++  ; nLin++

@nLin,40 PSAY "Totais/Cotas "
@nLin,92 PSAY TRANSFORM(nT_COTANT,"999999999999")
@nLin,107 PSAY TRANSFORM(nT_COTAT,"999999999999")


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
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/VaR25/Def04/Cnt04/Var05/Def05/Cnt05

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