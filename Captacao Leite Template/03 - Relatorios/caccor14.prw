#include "Protheus.ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOR14 ³ Autor ³ Marco Aurelio TRT005  ³ Data ³ 25/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Rendimentos Pagos e Creditados                ³±±
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
±±³Descri‡…o ³ PLANO DE MELHORIA CONTINUA        ³Programa   CACCOR14.PRW ³±±
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
User Function CACCOR14()

//CHKTEMPLATE("COL")

nTLBQ_QTD   := nTVALORR := nTMercad := nTPerc1 := nTPerc2 := nTFunrural := nTABPL := 0
nToLBQ_QTD  := nToVALORR := nToMercad := nToPerc1 := 	nToPerc2 := nToFunrural := 0
nToABPL     := 0   ;    nVABPL:=GetMv("MV_ABPL") ;    cLoja:=cCliNome:=""
nRepete     := 0  ; nDetAbpl := 0

nQtd        := 0 
aOrd        := {}
cDesc1      := "Este programa tem como objetivo imprimir relatorio "
cDesc2      := "de acordo com os parametros informados pelo usuario."
cDesc3      := "Rendimentos Pagos e Creditados
cPict       := ""
lEnd        := .F.
lAbortPrint := .F.
limite      := 80
tamanho     := "P"
nomeprog    := "CACCOR14"
nTipo       := 18  //COMPRIMIDO 
aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
nLastKey    := 0
cPerg       := "CACR14"
Titulo      := "Rendimentos Pagos e Creditados"
nLin        := 80
cbtxt       := Space(10)
cbcont      := 00
CONTFL      := 01
m_pag       := 01
imprime     := .T.
wnrel       := "CACR14" // Coloque aqui o nome do arquivo usado para impressao em disco
cString     := "LBQ"

ValidPerg()  

If Pergunte(cPerg,.t.)

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If ! nLastKey == 27
		
		SetDefault(aReturn,cString)
		
		If ! nLastKey == 27
		
			Processa({|| RptProc("Processando Filtro")})

		Endif
	Endif
Endif
	
Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ RptProc  ³ Autor ³ Marco Aurelio TRT005  ³ Data ³ 25/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Processamento e impressao do relatorio                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Programa principal                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RptProc()

cQuery := "SELECT"
if(Mv_Par03 == 1,cQuery += "    TDER.LBC_DESC,",)
cQuery += "    TDER.LBQ_DATINI, TDER.A2_NOME, TDER.A2_LOJA, MAX(TDER.A2_END) A2_END, "
cQuery += "    MAX(TDER.A2_COD) A2_COD, MAX(TDER.A2_MUN) A2_MUN, MAX(TDER.A2_EST) A2_EST, "
cQuery += "    MAX(TDER.A2_CGC) A2_CGC, MAX(TDER.A2_INSCR) A2_INSCR, "
cQuery += "    SUM(TDER.LBQ_QTD) LBQ_QTD, SUM(TDER.LBQ_VALOR) LBQ_VALOR,"
cQuery += "    SUM(TDER.Mercadorias) Mercad, SUM(TDER.Perc1) Perc1,"
cQuery += "    SUM(TDER.Perc2) Perc2, SUM(TDER.Funrural) Funrural, SUM(TDER.ABPL) ABPL"
cQuery += " FROM ("
cQuery += "  SELECT "
if(Mv_Par03 == 1,cQuery += "    LBC.LBC_DESC,",)
cQuery += "    MONTH(LBQ.LBQ_DATINI) LBQ_DATINI, MAX(SA2.A2_NOME) A2_NOME , MAX(SA2.A2_END) A2_END, "
cQuery += "    MAX(SA2.A2_COD) A2_COD, MAX(SA2.A2_LOJA) A2_LOJA, MAX(SA2.A2_MUN) A2_MUN, MAX(SA2.A2_EST) A2_EST, "
cQuery += "    MAX(SA2.A2_CGC) A2_CGC, MAX(SA2.A2_INSCR) A2_INSCR, "
cQuery += "    SUM(LBQ.LBQ_QTD) LBQ_QTD,"
cQuery += "    'LBQ_VALOR'   = CASE WHEN LBQ.LBQ_FLAG = 'R' "
cQuery += "                             THEN SUM(LBQ.LBQ_VALOR) END,"
cQuery += "    'Mercadorias' = CASE WHEN LBQ.LBQ_DESC LIKE '%LOJA VET%' "
cQuery += "                             THEN SUM(LBQ.LBQ_VALOR) END,"
cQuery += "    'Perc1'       = CASE WHEN LBQ.LBQ_DESC LIKE '%1o. Perc%' "
cQuery += "                             THEN SUM(LBQ.LBQ_VALOR) END,"
cQuery += "    'Perc2'       = CASE WHEN LBQ.LBQ_DESC LIKE '%2o. Perc%'  "
cQuery += "                             THEN SUM(LBQ.LBQ_VALOR) END,       "
cQuery += "    'Funrural'    = CASE WHEN LBQ.LBQ_DESC LIKE '%Funrural%' "
cQuery += "                             THEN SUM(LBQ.LBQ_VALOR) END,"
cQuery += "    'ABPL'        = SUM(LBQ.LBQ_VALOR)"
cQuery += "  FROM"
cQuery += "    " + RetSqlName("LBQ") + " LBQ,"
cQuery += "    " + RetSqlName("LBB") + " LBB,"
if Mv_Par03 == 1
   cQuery += "    " + RetSqlName("LBC") + " LBC,"
   cQuery += "    " + RetSqlName("LBD") + " LBD,"
Endif   
cQuery += "    " + RetSqlName("SA2") + " SA2"
cQuery += "  WHERE"
if(Alltrim(Mv_Par06) <> "",cQuery += "    SUBSTRING(SA2.A2_NOME,1,1) BETWEEN '"+ALLTRIM(MV_PAR05)+"' AND '"+ALLTRIM(MV_PAR06)+"' AND",)
cQuery += "    LBQ.LBQ_CODPRO = LBB.LBB_CODPRO AND"
cQuery += "    LBB.LBB_CODFOR = SA2.A2_COD AND"
cQuery += "    LBB.LBB_LOJA = SA2.A2_LOJA AND"
if Mv_Par03 == 1
  if(Alltrim(Mv_Par04) <> "",cQuery += "    LBC.LBC_CODROT = "+ALLTRIM(MV_PAR04)+" AND",)
   cQuery += "    LBC.LBC_CODROT = LBD.LBD_CODROT AND"
   cQuery += "    LBD.LBD_CODPRO = LBB.LBB_CODPRO AND"
   cQuery += "    LBC.D_E_L_E_T_  = ' ' AND"
   cQuery += "    LBD.D_E_L_E_T_  = ' ' AND"
Endif   
cQuery += "    LBQ.LBQ_DATINI BETWEEN '" +Dtos(mv_par01)+ "' AND '" +Dtos(mv_par02) + "' AND"
cQuery += "    LBQ.LBQ_CRIQUA <> 'S' AND"
cQuery += "    LBQ.D_E_L_E_T_  = ' ' AND"
cQuery += "    LBB.D_E_L_E_T_  = ' ' AND"
cQuery += "    SA2.D_E_L_E_T_  = ' '"
cQuery += "  GROUP BY "                                                 
if(Mv_Par03 == 1,cQuery += "    LBC.LBC_DESC,",)
cQuery += "    SA2.A2_NOME, SA2.A2_LOJA, LBQ.LBQ_DATINI, LBQ.LBQ_FLAG, LBQ.LBQ_DESC "
cQuery += " ) AS TDER"
cQuery += " GROUP BY "
if(Mv_Par03 == 1,cQuery += "    TDER.LBC_DESC,",)
cQuery += " TDER.A2_NOME, TDER.A2_LOJA, TDER.LBQ_DATINI "
cQuery += " ORDER BY "
if(Mv_Par03 == 1,cQuery += "    TDER.LBC_DESC,",)
cQuery += " TDER.A2_NOME, TDER.A2_LOJA, TDER.LBQ_DATINI "

TCQUERY cQuery ALIAS RQRY NEW

cabec1:="" 
cabec2:=""

cCliNome := A2_NOME
cLoja := A2_LOJA

_wfim:=RecCount() ; ProcRegua(_wfim)    
while !EOF() 

   IncProc("Gerando Relatório... ")


   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   if nLin>60 .or. cCliNome+cLoja<>A2_NOME+A2_LOJA
      if Mv_Par03 == 1
         Cabec1 := 'Linha ' + LBC_DESC
      Endif
   	  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)   
 	  nLin := 7
 	  //IMPRIMINDO DADOS DA EMPRESA - SIGAMAT
      @ nLin+1,06 PSAY "Fonte Pagadora: " + SM0->M0_NOMECOM
      @ nLin+2,22 PSAY SM0->M0_ENDCOB
      @ nLin+3,22 PSAY SM0->M0_CIDCOB + space(10)+ SM0->M0_ESTCOB
      @ nLin+4,22 PSAY SM0->M0_CGC 
      @ nLin+5,22 PSAY SM0->M0_INSC 
      
      @ nLin+7 ,06 PSAY "Beneficiario..: " + A2_NOME +space(20)+ A2_COD
      @ nLin+8 ,22 PSAY A2_END
      @ nLin+9 ,22 PSAY A2_MUN + SPACE(5) +  A2_EST
      @ nLin+10,22 PSAY A2_CGC
      @ nLin+11,22 PSAY A2_INSCR + space(12) + " Período "+dtoc(mv_par01)+ " a " +dtoc(mv_par02) + "" 

      @ nLin+12,00 PSAY REPLICATE('-',80)
	  @ nLin+13,00 PSAY '  Mes       Producao      Valor   C/C Mercad    1o Perc    2o Perc   Funrural'    

	  nLin := 21  ;  cCliNome :=A2_NOME	; cLoja := A2_LOJA ; nRepete := 1
      nTLBQ_QTD := nTVALORR := nTMercad := nTPerc1 := nTPerc2 := nTFunrural := nTABPL := 0
   else
      nRepete++
   endif

   @nLin,00 PSAY MesExtenso(LBQ_DATINI) 
   @nLin,11 PSAY TRANSFORM(LBQ_QTD    ,"@E 9,999,999")
   @nLin,20 PSAY TRANSFORM(LBQ_VALOR  ,"@E 9,999,999.99")
   @nLin,34 PSAY TRANSFORM(Mercad     ,"@E 999,999.99")
   @nLin,45 PSAY TRANSFORM(Perc1      ,"@E 999,999.99")
   @nLin,58 PSAY TRANSFORM(Perc2      ,"@E 9,999.99")
   @nLin,69 PSAY TRANSFORM(Funrural   ,"@E 9,999.99")

   nTLBQ_QTD   += LBQ_QTD
   nTVALORR    += LBQ_VALOR
   nTMercad    += Mercad
   nTPerc1     += Perc1
   nTPerc2     += Perc2
   nTFunrural  += Funrural	  

   nToLBQ_QTD   += LBQ_QTD
   nToVALORR    += LBQ_VALOR
   nToMercad    += Mercad
   nToPerc1     += Perc1
   nToPerc2     += Perc2
   nToFunrural  += Funrural	  

   dbskip()

   nLin++  
   
   if (nLin>60 .or. cCliNome+cLoja<>A2_NOME+A2_LOJA) .and. nRepete > 1

          @ nLin,11 PSAY "_________  __________ ___________ __________   ________   ________ " 
          nLin++
	      @ nLin,11 PSAY TRANSFORM(nTLBQ_QTD    ,"@E 9,999,999")
	      @ nLin,20 PSAY TRANSFORM(nTVALORR     ,"@E 9,999,999.99")
	      @ nLin,34 PSAY TRANSFORM(nTMercad     ,"@E 999,999.99")
	      @ nLin,45 PSAY TRANSFORM(nTPerc1      ,"@E 999,999.99")
	      @ nLin,58 PSAY TRANSFORM(nTPerc2      ,"@E 9,999.99")
	      @ nLin,69 PSAY TRANSFORM(nTFunrural   ,"@E 9,999.99")

   endif   
  
EndDo

Cabec1:= "               TOTAL GERAL DOS RENDIMENTOS PAGOS E CREDITADOS"
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)   
nLin := 8

@ nLin,00 PSAY "   Producao           Valor            C/C Mercad             1o Perc"
nLin++
@ nLin,01 PSAY TRANSFORM(nToLBQ_QTD ,"@E 99,999,999")
@ nLin,18 PSAY TRANSFORM(nToVALORR  ,"@E 99,999,999.99")
@ nLin,36 PSAY TRANSFORM(nToMercad  ,"@E 99,999,999.99")
@ nLin,56 PSAY TRANSFORM(nToPerc1   ,"@E 99,999,999.99")
 
nLin++  ; nLin++

@ Nlin,00 PSAY "                                         Funrural             2o Perc "             //  ABPL"
nLin++
@ nLin,36 PSAY TRANSFORM(nToFunrural,"@E 99,999,999.99")
@ nLin,56 PSAY TRANSFORM(nToPerc2   ,"@E 99,999,999.99")

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

Return(Nil)
           


/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ValidPerg³ Autor ³ Marco Aurelio TRT005  ³ Data ³ 25/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Criar as perguntas referentes a este relatorio no SX1      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Programa principal                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg()

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

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/VaR14/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Data Inicial  ","","","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Final    ","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Ordem         ","","","mv_ch3","N",1,0,0,"C","","mv_par03","Por Linha","","","","","Por Produtor","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Codigo Linha  ","","","mv_ch4","C",6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","LBC"})
aAdd(aRegs,{cPerg,"05","Prod Letra Ini","","","mv_ch5","C",1,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Prod Letra Fim","","","mv_ch6","C",1,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !MsSeek(PADR(cPerg,nTamSX1)+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
	    	If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
	    	Endif
		Next
		MsUnlock()				
	endif
Next                 
dbSelectArea(_sAlias)
Return(Nil)
