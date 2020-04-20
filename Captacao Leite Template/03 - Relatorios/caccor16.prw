#include "Protheus.ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOR16 ³ Autor ³ Marco Aurelio TRT005  ³ Data ³ 25/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao de Produtores para retorno                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACCOR16()

//CHKTEMPLATE("COL")

nTLBP_QUANT := nTValor := 0

nQtd        := 0
aOrd        := {}
cDesc1      := "Este programa tem como objetivo imprimir relatorio "
cDesc2      := "de acordo com os parametros informados pelo usuario."
cDesc3      := "Produtores para Retorno"
cPict       := ""
lEnd        := .F.
lAbortPrint := .F.
limite      := 80
tamanho     := "P"
nomeprog    := "CACCOR16"
nTipo       := 18  //COMPRIMIDO
aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
nLastKey    := 0
cPerg       := "CACR16"
Titulo      := "Produtores para Retorno"
nLin        := 80
cbtxt       := Space(10)
cbcont      := 00
CONTFL      := 01
m_pag       := 01
imprime     := .T.
wnrel       := "CACR16" // Coloque aqui o nome do arquivo usado para impressao em disco
cString     := "LBP"

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

Processa({|| RptProc("Processando Filtro")})

Return


Static Function RptProc 

Local cParcela := GetMV("MV_1DUP")
// Local cParcela := "1"
Local nGeraSE2 := MV_PAR04
Local dVencto  := MV_PAR05      
Local cPrefixo := MV_PAR06
Local cTipo    := MV_PAR07
Local cNaturez := MV_PAR08

Private cQuery

cQuery := "SELECT"
cQuery += "    MAX(LBP.LBP_CODPRO) LBP_CODPRO, LBP.LBP_NOMFOR, SUM(LBP.LBP_PRODUC) LBP_PRODUC,SUM(LBP.LBP_PRODUC* " + STR(mv_par03) + ") VALOR"
cQuery += " FROM"
cQuery += "    " + RetSqlName("LBP") + " LBP"
cQuery += " WHERE"
cQuery += "    LBP.LBP_DATINI >= '" +Dtos(mv_par01)+ "' AND"
cQuery += "    LBP.LBP_DATFIN <= '" +Dtos(mv_par02)+ "' AND"
cQuery += "    LBP.D_E_L_E_T_ = ' '"
cQuery += " GROUP BY LBP.LBP_NOMFOR"
cQuery += " ORDER BY LBP.LBP_NOMFOR"

TCQUERY cQuery NEW ALIAS "RQRY"

cabec1:=space(52)+"Período "+dtoc(mv_par01)+ " a " +dtoc(mv_par02) + ""

cabec2:="Produtor                                           Producao             Valor"

_wfim:=RecCount()
ProcRegua(_wfim)

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
	
	@nLin,00 PSAY SUBSTR(LBP_NOMFOR,1,40)
	@nLin,50 PSAY TRANSFORM(LBP_PRODUC,"@E 999,999,999")
	@nLin,65 PSAY TRANSFORM(VALOR    ,"@E 9,999,999.99")
	
	nTLBP_QUANT += LBP_PRODUC
	nTValor     += VALOR
	nValor      := VALOR
	
	if  nGeraSE2 == 1 // Gera Titulos
		
		// Inicio da Geracao de Titulos a Pagar
			
		dbselectArea("LBB")
		dbsetorder(1)
		dbseek(xFilial("LBB")+RQRY->LBP_CODPRO)
		
		dbselectArea("SA2")
		dbsetorder(1)
		dbseek(xFilial("SA2")+LBB->LBB_CODFOR+LBB->LBB_LOJA)
		
		DbSelectArea("SE2")
		DbSetOrder(6)
		If DbSeek(xFilial("SE2")+LBB->LBB_CODFOR+LBB->LBB_LOJA+cPrefixo)
		    While !Eof() .and. xFilial("SE2")+LBB->LBB_CODFOR+LBB->LBB_LOJA+cPrefixo == SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO
			    cParcela := SE2->E2_PARCELA
			    DbSkip()
		    Enddo
		    cParcela := Soma1(cParcela)
		Endif
		
		aTitSE2 := {}
		lMsErroAuto := .F.
		
		// Geracao automatica de Titulos a Pagar
		Aadd(aTitSE2,{"E2_FILIAL" 		,xFilial("SE2")  					,Nil})
		Aadd(aTitSE2,{"E2_PREFIXO"		,Alltrim(cPrefixo)					,Nil})
		Aadd(aTitSE2,{"E2_NUM"    		,LBB->LBB_CODFOR					,Nil})
		Aadd(aTitSE2,{"E2_PARCELA"		,cParcela							,Nil})
		Aadd(aTitSE2,{"E2_TIPO"   		,cTipo								,Nil})
		Aadd(aTitSE2,{"E2_NATUREZ"		,cNaturez							,Nil})
		Aadd(aTitSE2,{"E2_FORNECE"		,LBB->LBB_CODFOR               		,Nil})
		Aadd(aTitSE2,{"E2_LOJA"   		,LBB->LBB_LOJA               		,Nil})
		Aadd(aTitSE2,{"E2_EMISSAO"		,dDataBase							,Nil})
		Aadd(aTitSE2,{"E2_VENCTO" 		,dVencto							,Nil})
		Aadd(aTitSE2,{"E2_VALOR"  		,nValor								,Nil})
		Aadd(aTitSE2,{"E2_HIST"   		,"Produtores retorno."	        	,Nil})
		
		MsExecAuto({|x,y|FINA050(x,y)},aTitSE2,3)
		SE2->(MsUnlock())
		//cParcela := "1"
		
		If lMsErroAuto = .T.
			MostraErro()
		EndIf
		
	Endif
	
	dbselectArea("RQRY")
	dbskip()
	
	nLin++
	
EndDo

nLin++  ; nLin++

@nLin,16 PSAY "Total Geral "
@nLin,48 PSAY TRANSFORM(nTLBP_QUANT,"@E 999,999,999")
@nLin,63 PSAY TRANSFORM(nTValor,"@E 999,999,999.99")

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
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/VaR16/Def04/Cnt04/Var05/Def05/Cnt05

aAdd(aRegs,{cPerg,"01","Data Inicial","Data Inicial","Data Inicial","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","",""}) //
aAdd(aRegs,{cPerg,"02","Data Final","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","",""}) //
aAdd(aRegs,{cPerg,"03","Valor Litro","","","mv_ch3","N",9,7,0,"G","","mv_par03","","","","","","","","","","","","","",""}) //
aAdd(aRegs,{cPerg,"04","Gera Titulos CP?","","","mv_ch4","N",01,0,0,"C","","mv_par04","Sim","","","","","Nao","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Data Vencto.Titulos?","","","mv_ch5","D",8,0,0,"G","","mv_par05","","","","","","","","","","","","","",""}) //
aAdd(aRegs,{cPerg,"06","Prefixo","","","mv_ch6","C",3,0,0,"G","","mv_par06","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Tipo","","","mv_ch7","C",3,0,0,"G","","mv_par07","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Natureza","","","mv_ch8","C",10,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SED","","",""})

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
