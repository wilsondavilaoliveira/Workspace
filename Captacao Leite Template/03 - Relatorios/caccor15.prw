#include "Protheus.ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOR08 ³ Autor ³ Marco Aurelio TRT005  ³ Data ³ 25/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Niveis de Producao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Subdivide a producao em faixas e necessario criar uma ma-  ³±±
±±³          ³ triz onde coloca-se a faixa de producao, a qtde de produ-  ³±±
±±³          ³ tores que fazem parte desta faixa.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACCOR15() 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Níveis de Produção."
Local cPict          := ""
Local imprime        := .T.
Local aOrd           := {}
Private nLin         := 80
Private Cabec1       := ""
Private Cabec2       := ""
Private titulo       := "Níveis de Produção"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 80
Private tamanho      := "P"
Private nCaracter    := 15
Private nomeprog     := "CACCOR15"
Private nTipo        := 18
Private aReturn      := {"Zebrado" , 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "CACCOR15"
Private cString      := "LBP"

//CHKTEMPLATE("COL")

Private AFAIXA,FXINI,FXFIM,CCODPRO,NTOTPROP
Private NPRODTOTAL,FLITROS,I,FA,FB,LimAFaixa

ValidPerg()

if !Pergunte("CACR15",.t.)
	Return
Endif

Cabec1     := "                                          Periodo " + Dtoc(MV_Par01) + " a " + Dtoc(MV_Par02)
Cabec2     := "     Faixa Producao       Qtd.Produtores          %         Litros         %"
nProdTotal := 0
fLitros    := 0
nTotProp   := 0
LimAFaixa  := 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif          

nTipo := If(aReturn[4]==1,15,18)

Processa({|| Impr_Relat()})

Return

Static Function Impr_Relat()
Local I

AFaixa := {}
FxIni  := 1
FxFim  := mv_par03

While FxFim <= 100000
	AADD(AFaixa,{ FxIni,FxFim , 0 , 0 , 0, 0 })  //Preenche o vetor com as Faixas
	FxIni:=FxFim+1
	FxFim:=FxFim+Mv_par03
enddo

DbSelectArea(cString)
DbSetOrder(2) 
_wfim:=RecCount() 
dbgotop()
DbSeek(xFilial("LBP")+Dtos(mv_par01),.T.)

ProcRegua(_wfim-recno())

cCODPRO  := LBP->LBP_CODPRO
nTotProp := 1

While !Eof() .and.LBP->LBP_DATINI >= mv_par01.and.LBP->LBP_DATFIN <=mv_par02
	
	IncProc("Gerando Relatório... ")
	
	IF ALLTRIM(LBP->LBP_CODPRO)="TOTAL"
		DBSKIP()
		LOOP
	ENDIF
	fLitros:=LBP->LBP_PRODUC  / ((mv_par02-mv_par01)+1)        //Faixa em Litros
	
	NINIFOR := INT(FLITROS/MV_PAR03)-1  //CONFIGURA UM INTERVALO DE 3 FAIXAS POSSIVEIS
	NFINFOR := INT(FLITROS/MV_PAR03)+1
	if nIniFor <= 0
		nIniFor := 1
		nFinFor := 3
	Endif
	FOR I = NINIFOR TO NFINFOR
		Fa:=aFaixa[I][1]
		Fb:=aFaixa[I][2]
		
		If fLitros >= Fa .and. fLitros <= Fb
			AFaixa[I][3]:=Afaixa[I][3]+1
			AFaixa[I][5]:=Afaixa[I][5]+FLitros
			nProdtotal:=nProdtotal+fLitros  //Soma a produção total
			exit
		Endif
		
	NEXT
	
   if LBP->LBP_CODPRO<>cCODPRO
		nTotProp:=nTotProp+1   //Soma a quantidade de produtores
		cCODPRO:=LBP->LBP_CODPRO
	endif
	dbskip()
enddo

For i:=1 to Len(aFaixa)
	if Afaixa[I][3] > 0
		AFaixa[I][4]:=Afaixa[I][3]/nTotProp*100   //CALCULA O PERCENTUAL DE PRODUTORES
		AFaixa[I][6]:=Afaixa[I][5]/nProdtotal*100  //CALCULA O PERCENTUAL DE PRODUÇÃO
		LimaFaixa := aFaixa[I][1]
	Endif
Next

nLin := cabec(titulo,Cabec1,Cabec2,nomeprog,Tamanho,nCaracter) + 1

For I:= 1 To len(aFaixa)
	If nLin >= 62
		nLin := cabec(titulo,Cabec1,Cabec2,nomeprog,Tamanho,nCaracter) + 1
	Endif
	if aFaixa[i,5] # 0
		@ nLin,00 PSAY ' '+Transform(aFaixa[I,1],"99999")+'  a  '+Transform(aFaixa[I,2],"99999")+'               '+Transform(aFaixa[I,3],"999")+'             '+Transform(aFaixa[I,4],"@e 999.99")+'    '+Transform(aFaixa[I,5],"@E 999,999,999")+'    '+Transform(aFaixa[I,6],"@E 999.99")
		nLin++
	Endif
	If  aFaixa[I][1]>LimAFaixa
		@ nLin,00 PSAY "      Totais                 "+Transform(nTotProp,"99999")+'                       '+Transform(nProdTotal,"@E 999,999,999")
		exit
	endif
Next

RetIndex(cString)

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

/*-----------------------------------------------------------------------------
Função   VALIDPERG
Descrição Verifica e inclui as perguntas no sx1
------------------------------------------------------------------------------*/
Static Function ValidPerg
Local i, j
Local _sAlias	:= Alias()
Local aRegs		:= {}
Local nTamSX1   := Len(SX1->X1_GRUPO)
Local cPerg		:= "CACR15"

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

AADD(aRegs,{cPerg,"01"	,"Periodo Inicial ?","Periodo Inicial ?"	,"Periodo Inicial ?"	,"mv_ch1"	,"D"	,8			,0			,0		,"G"	,""		,"mv_par01"		,""		,"01/01/80"		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"","","","","","","","","","","","","",""}) //
AADD(aRegs,{cPerg,"02"	,"Periodo Final ?"	,"                "		,"                "		,"mv_ch2"	,"D"	,8			,0			,0		,"G"	,""		,"mv_par02"		,""		,"01/01/10"		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"","","","","","","","","","","","","",""}) //
AADD(aRegs,{cPerg,"03"	,"Faixa ?"			,"                "		,"                "		,"mv_ch3"	,"N"	,5			,0			,0		,"G"	,""		,"mv_par03"		,""		,"50"			,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"","","","","","","","","","","","","",""}) //

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
return(nil)
