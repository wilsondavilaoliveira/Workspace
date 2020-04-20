#include "Protheus.ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOR12 ³ Autor ³ Marco Aurelio TRT005  ³ Data ³ 25/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio Resumo de Nota Fiscal                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACCOR12()

//CHKTEMPLATE("COL")

nTVALBRUT   := 0

nQtd        := 0 
aOrd        := {}
cDesc1      := "Este programa tem como objetivo imprimir relatorio "
cDesc2      := "de acordo com os parametros informados pelo usuario."
cDesc3      := "Resumo de Notas Fiscais"
cPict       := ""
lEnd        := .F.
lAbortPrint := .F.
limite      := 80
tamanho     := "P"
nomeprog    := "CACCOR12"
nTipo       := 18  //COMPRIMIDO 
aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
nLastKey    := 0
cPerg       := "CACR12"
Titulo      := "Resumo de Notas Fiscais"
nLin        := 80
cbtxt       := Space(10)
cbcont      := 00
CONTFL      := 01
m_pag       := 01
imprime     := .T.
wnrel       := "CACR12" // Coloque aqui o nome do arquivo usado para impressao em disco
cString     := "LBQ"

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

Local cQuery

cQuery := "SELECT"
cQuery += "    SF1.F1_FORNECE, SA2.A2_NOME, SF1.F1_DOC, SF1.F1_SERIE,  "
cQuery += "    SF1.F1_VALBRUT "
cQuery += " FROM"
cQuery += "    " + RetSqlName("SF1") + " SF1,"
cQuery += "    " + RetSqlName("SA2") + " SA2"
cQuery += " WHERE"
cQuery += "    SF1.F1_FORNECE >= '" +ALLTRIM(mv_par04) + "' AND"
cQuery += "    SF1.F1_FORNECE <= '" +ALLTRIM(mv_par06) + "' AND"
cQuery += "    SF1.F1_LOJA >= '" +ALLTRIM(mv_par05) + "' AND"
cQuery += "    SF1.F1_LOJA <= '" +ALLTRIM(mv_par07) + "' AND" 
cQuery += "    SF1.F1_FORNECE = SA2.A2_COD AND"
cQuery += "    SF1.F1_LOJA = SA2.A2_LOJA AND"
cQuery += "    SF1.F1_EMISSAO BETWEEN '" +Dtos(mv_par01)+ "' AND '" +Dtos(mv_par02) + "' AND"
IF( AllTrim(MV_PAR03) <> "" , cQuery += "    SF1.F1_EST = '" +ALLTRIM(mv_par03) + "' AND",)
IF( AllTrim(MV_PAR08) <> "" , cQuery += "    SF1.F1_SERIE = '" +ALLTRIM(mv_par08) + "' AND",)
cQuery += "    SF1.D_E_L_E_T_ = ' ' AND SA2.D_E_L_E_T_ = ' '"
cQuery += " ORDER BY "
cQuery += "    CAST(SF1.F1_DOC AS NUMERIC)"

cQuery := ChangeQuery(cQuery)

TCQUERY cQuery NEW ALIAS "RQRY"

cabec1:=IF( ALLTRIM(MV_PAR03) <> "", "Estado..: " + MV_PAR03+SPACE(39),SPACE(52)) ;
              +"Período "+dtoc(mv_par01)+ " a " +dtoc(mv_par02) + ""
                                                               
cabec2:="CodProd  Produtor                                Nota Fiscal Serie         Valor"
       //012345678901234567890123456789012345678901234567890123456789012345678901234567890
       // 															   999	   999,999.99
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

	@nLin,00 PSAY F1_FORNECE
	@nLin,10 PSAY SUBSTR(A2_NOME,1,37)
	@nLin,50 PSAY TRANSFORM(F1_DOC ,"@E 999999")       
	@nLin,62 PSAY TRANSFORM(F1_SERIE ,"@E 999")        	
	@nLin,70 PSAY TRANSFORM(F1_VALBRUT,"@E 999,999.99")

    nTVALBRUT += F1_VALBRUT

	dbskip()
	
	nLin++  //;	nQtd++
  
EndDo

nLin++  ; nLin++

@nLin,00 PSAY "Total --------------------------------->"
@nLin,68 PSAY TRANSFORM(nTVALBRUT,"@E 9,999,999.99")

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
Local j, i
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
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/VaR12/Def04/Cnt04/Var05/Def05/Cnt05

aAdd(aRegs,{cPerg,"01","Data Inicial" ,"Data Inicial","Data Inicial","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Final"   ,"","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Estado"       ,"","","mv_ch3","C",2,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","12","","",""})
aAdd(aRegs,{cPerg,"04","Fornecedor De","","","mv_ch4","C",6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","",""})
aAdd(aRegs,{cPerg,"05","Loja De"      ,"","","mv_ch5","C",2,0,0,"G","","mv_par05","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Fornecedor Ate","","","mv_ch6","C",6,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","",""})
aAdd(aRegs,{cPerg,"07","Loja Ate"     ,"","","mv_ch7","C",2,0,0,"G","","mv_par07","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Serie da Nota ","","","mv_ch8","C",3,0,0,"G","","mv_par08","","","","","","","","","","","","","",""})

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