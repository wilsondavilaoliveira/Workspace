#include "Protheus.ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOR02 ³ Autor ³ Microsiga SJRP        ³ Data ³ 28/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Resumo Geral do Fecham. Periodo e Estado (Creditos/Debitos)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³RicardoBerti³11/01/06³087948³Calculo Pagto.da Qualidade: LBQ_CRIQUA="S"³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ PLANO DE MELHORIA CONTINUA        ³Programa   CACCOR02.PRW ³±±
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

User Function CACCOR02()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Resumo Geral do Fechamento."
Local cPict          := ""
Local imprime        := .T.
Local aOrd           := {}

Private nLin         := 80
Private Cabec1       := ""
Private Cabec2       := ""
Private titulo       := "Resumo Geral do Fechamento"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 80
Private tamanho      := "P"
Private nCaracter    := 15
Private nomeprog     := "CACCOR02"
Private nTipo        := 18
Private aReturn      := { "Zebrado" , 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "CACCOR02"
Private cString      := "LBQ"

//CHKTEMPLATE("COL")

Private aReceita, aDespesa
Private nTotQtd, nSTotValor, nTotBruto, nTotDesc, nTotLiquido, nSaldoDev
Private nOutrCred  
Private nMes, dData, nPos
Private nPosD
Private n
Private nProdTotal:=0 ; fLitros:=0 ; nTotProp:=0
Private cEstado := ''

aReceita 	:= {}
aDespesa 	:= {}
nTotQtd		:= 0
nSTotValor	:= 0
nTotBruto	:= 0
nTotDesc	:= 0
nTotLiquido	:= 0
nSaldoDev	:= 0
nOutrCred	:= 0

ValidPerg()

If Pergunte("CACR02",.t.)

	If Empty(MV_PAR03)
		cEstado := "Todos"
	Else
		cEstado := Alltrim(MV_PAR03)
	Endif
	
	Cabec1  := "     Periodo " + Dtoc(MV_Par01) + " a " + Dtoc(MV_Par02) + " - " + cEstado
	Cabec2  := "     Discriminacao                     Quantidade                   Valor          "
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If ! nLastKey == 27
	
		SetDefault(aReturn,cString)
	
		If ! nLastKey == 27
	
			nTipo := If(aReturn[4]==1,15,18)
	
			Processa({|| Impr_Relat()})
			
		EndIf
	EndIf
EndIf

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Impr_Relat³ Autor ³                       ³ Data ³ 28/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do Relatorio Resumo Geral do Fecham.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Cooperativa de Leite                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Impr_Relat()

Local cTipo    := GetMv("MV_TPTITE1")
Local cPrefixo := &(GetMv("MV_PREFSE1"))
Local I
Local nQuaQual :=0
Local nValQual :=0
Local lTemCriQua := .F.

setprc(0,0)
aadd(aReceita,{"Leite B1 Cota",0,0}) //       1 
aadd(aReceita,{"Leite B2 Cota",0,0}) //       2
aadd(aReceita,{"Leite B3 Cota",0,0}) //       3
aadd(aReceita,{"Leite C1 Cota",0,0}) //       4
aadd(aReceita,{"Leite C2 Cota",0,0}) //       5
aadd(aReceita,{"Leite C3 Cota",0,0}) //       6
aadd(aReceita,{"Leite Excesso 1",0,0}) //     7
aadd(aReceita,{"Leite Excesso 2",0,0}) //     8
aadd(aReceita,{"Leite Excesso 3",0,0}) //     9
aadd(aReceita,{"Bonific Quantidade",0,0}) // 10
aadd(aReceita,{"Bonific a Granel",0,0}) //   11
aadd(aReceita,{"Outros Creditos",0,0}) //    12

nMes:=month(mv_Par01)+1
if nMes > 12
	nMes := 1
	nAno := year(mv_par01) + 1
Else
	nAno := year(mv_par01)
Endif
dDataIni:=str(nAno,4)+strzero(nMes,2)+"01"
If nMes == 2
	dDataFin:=str(nAno,4)+strzero(nMes,2)+"28"
ElseIf nMes == 4 .or. nMes == 6 .or. nMes == 9 .or. nMes == 11
	dDataFin:=str(nAno,4)+strzero(nMes,2)+ "30"
Else
	dDataFin:=str(nAno,4)+strzero(nMes,2)+"31"
Endif

dbSelectArea("SE1")
dbsetorder(7) 
dbGoTop()
_wfim:=RecCount()
//dbseek(xFilial("SE1")+dDataIni,.t.)

ProcRegua(_wfim-recno())

While SE1->(!Eof()) 
	IF DTOS(SE1->E1_VENCREA) < dDataIni .AND. DTOS(SE1->E1_VENCREA) > dDataFin
		SE1->(dbSkip())	
		Loop
	Endif
	
	IncProc("Verificando Saldo Devedor...")
	
	dbSelectArea("SE1")
	If ALLTRIM(SE1->E1_TIPO) == cTipo .AND. ALLTRIM(SE1->E1_PREFIXO) == cPrefixo
		nSaldoDev := SE1->E1_VALOR + nSaldoDev
	Endif
	
	SE1->(dbSkip())
	
Enddo

dbSelectArea(cString)
dbsetorder(2)
_wfim:=RecCount()
dbseek(xfilial(cString)+dTos(mv_par01),.t.)
ProcRegua(_wfim-recno())

nPerABPL := GETMV("MV_ABPL")/100
nABPL    := 0

While !Eof()  .and. LBQ->LBQ_FILIAL==xfilial(cString) .AND. LBQ->LBQ_DATINI>=mv_par01 .AND. LBQ->LBQ_DATINI<=mv_par02
	
	IncProc("Levantando Despesas Receitas...")
	
	DbSelectArea("LBB")
	dbsetorder(1)
	dbgotop()
	dbSeek(xFilial("LBB")+LBQ->LBQ_CODPRO)
	If !Empty(MV_PAR03)
		If Alltrim(MV_PAR03) <> Alltrim(LBB->LBB_EST)
			LBQ->(DbSkip())
			Loop
		Endif
	Endif
		
	DbSelectArea("LBQ")

	If Alltrim(LBQ->LBQ_FLAG) == 'R' .And. Upper(Left(LBQ->LBQ_DESC,5)) == "LEITE"
		// pagto por qualidade paga sobre toda entrega de leite
		nQuaQual += LBQ->LBQ_QTD
	EndIf	

	If LBQ->LBQ_CRIQUA == "S"	// E' criterio da qualidade

		lTemCriQua := .T.
		If Alltrim(LBQ->LBQ_FLAG) == 'R'
			nValQual += LBQ->LBQ_VALOR
		Else
			nValQual -= LBQ->LBQ_VALOR
		EndIf

	Else

		If Alltrim(LBQ->LBQ_FLAG) == 'R'
			nPos := aScan(aReceita,{ |x| x[1] == Alltrim(LBQ->LBQ_DESC)})
			if npos > 0
				aReceita[nPos,2] := aReceita[nPos,2] + LBQ->LBQ_QTD
				aReceita[nPos,3] := aReceita[nPos,3] + LBQ->LBQ_VALOR
			endif
		Else
			nPosd := aScan(aDespesa,{ |x| x[1] == Alltrim(LBQ->LBQ_DESC)})
			if nposd > 0
				aDespesa[nPosd,2] := aDespesa[nPosd,2] + LBQ->LBQ_VALOR
			Else
				aadd(aDespesa,{alltrim(LBQ->LBQ_DESC),LBQ->LBQ_VALOR})
			endif
		Endif
		
		dbSelectArea("LBB")
		dbsetorder(1)
		dbSeek(xFilial("LBB")+LBQ->LBQ_CODPRO)

		/* calculo antigo da Gordura paga
		if LBB->LBB_GORDUR>0
			nPos := aScan(aReceita,{ || subs(LBQ->LBQ_DESC,1,7) $ "Leite C/Leite E"}) //
			if  nPos > 0
				DbSelectArea("LBH")
				DbSetOrder(1)
				dbgotop()
				dbSeek(xFilial("LBH")+LBB->LBB_EST+"GD")
				nVTG     := LBH->LBH_VALOR
				nTeorG   := (LBB->LBB_GORDUR - nTeorMin) / 100 * nVTG
				nGORDURA := nGORDURA + (nTeorg * LBQ->LBQ_QTD)
				nGdQuant :=nGDQuant+ ( LBQ->LBQ_QTD * ( (LBB->LBB_GORDUR - nTeorMin) / 100 ) )
			Endif
		Endif
		*/

		if LBB->LBB_ABPL == "S"
			dbselectArea("SA2")
			dbsetorder(1)
			dbseek(xFilial("SA2")+LBB->LBB_CODFOR+LBB->LBB_LOJA)
			nABPL := nABPL + (LBQ->LBQ_VALOR*(nPerABPL))
		Endif
	
		dbSelectArea("LBQ")
	EndIf

	dbskip()
Enddo

nLin := cabec(titulo,Cabec1," ",nomeprog,Tamanho,nCaracter) + 1

// ABPL
aadd(aDespesa,{"A.B.P.L. - Leite Brasil",nABPL})

@ nLin,00 PSay 'RECEITA'
@ nLin,35 PSay 'QUANTIDADE'
@ nLin,70 PSay 'VALOR'

nLin++  ;   nLin++
For I:= 1 To len(aReceita)
	if aReceita[I,1] <> "Outros Creditos"
		@ nLin,00 PSAY aReceita[I,1]
		@ nLin,36 PSAY Transform(aReceita[I,2],"@e 999999999")+'                  '+Transform(aReceita[I,3],"@e 9,999,999.99")
		nTotQtd := aReceita[I,2] + ntotQtd
		nSTotValor	:= aReceita[I,3] + nStotValor
		nLin++
	else
		nOutrCred := aReceita[I,3]
	endif
Next

nLin++  ; nLin++
@ nLin,00 PSay 'SUBTOTAL PRODUCAO'
@ nLin,36 PSAY Transform(nTotQtd,"@e 999999999")+'                  '+Transform(nSTotValor,"@e 9,999,999.99")
nLin++  ; nLin++

@ nLin,00 PSay 'OUTROS CREDITOS'
@ nLin,63 PSAY Transform(nOutrCred,"@e 9,999,999.99")
nLin++  ; nLin++

@ nLin,00 PSay 'SUBTOTAL BRUTO'
@ nLin,63 PSAY Transform(nSTotValor+nOutrCred,"@e 9,999,999.99")
nLin++

@ nLin,00 PSAY REPLICATE('_',80)

nLin++  ; nLin++

@ nLin,00 PSay 'DESPESA'
@ nLin,70 PSay 'VALOR'

nLin++ ; nLin++

nPos := aScan(aDespesa,{|x|alltrim(x[1]) == "DEBITO ANTERIOR"})
if nPos > 0
	@ nLin,00 PSAY aDespesa[nPos,1]
	@ nLin,63 PSAY Transform(aDespesa[nPos,2],"@e 9,999,999.99")
	nLin++
	nTotDesc := nTotDesc + aDespesa[nPos,2]
Endif
For I:= 1 To len(aDespesa)
	if  !Alltrim(aDespesa[I,1]) == "DEBITO ANTERIOR"
		if Subs(aDespesa[I,1],1,9) == "Carreto 1"
			@ nLin,00 PSAY "Carreto 1o. Perc"
		Else
			@ nLin,00 PSAY aDespesa[I,1]
		Endif
		@ nLin,63 PSAY Transform(aDespesa[I,2],"@e 9,999,999.99")
		if adESPESA[I,1]<>"Saldo Devedor Anterior"
			nTotDesc := aDespesa[I,2]+nTotDesc
		endif
		nLin++
	Endif
Next

nLin++
@ nLin,00 PSay 'TOTAL DESCONTOS'
@ nLin,63 PSay Transform(nTotDesc,"@e 9,999,999.99")
nLin++  ; nLin++
nTotLiquido:=nStotValor-(ntotDesc+nSaldoDev)
@ nLin,00 PSay 'TOTAL LIQUIDO'
@ nLin,63 PSay Transform(nTotLiquido,"@e 9,999,999.99")
nLin++  ; nLin++
@ nLin,00 PSay 'LIQUIDO A RECEBER'
@ nLin,63 PSay Transform(nSTotValor+nOutrCred-nTotDesc+nSaldoDev,"@e 9,999,999.99")
nLin++  ; nLin++
@ nLin,00 PSay 'SALDO DEVEDOR ATUAL'
@ nLin,63 PSay Transform(nSaldoDev,"@e 9,999,999.99")
nLin++  ; nLin++
@ nLin,00 PSay 'Pagto.da Qualidade'  // antes: Gordura paga (kg)
If lTemCriQua
	@ nLin,37 PSay Transform(nQuaQual,"@E 999999999")
	@ nLin,63 PSay Transform(nValQual,"@E 9,999,999.99")
Else 
	@ nLin,32 PSay "NAO HOUVE ANALISE DA QUALIDADE NO MES"
EndIf

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
±±³Funcao    ³ VALIDPERG³ Autor ³                       ³ Data ³ 28/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica e inclui as perguntas no sx1                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg()

Local i, j
Local _sAlias	:= Alias()
Local aRegs		:= {}
Local nTamSX1   := Len(SX1->X1_GRUPO)
Local cPerg		:= "CACR02"

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

AADD(aRegs,{cPerg,"01"	,"Periodo Inicial ","Periodo Inicial "		,"Periodo Inicial "		,"mv_ch1"	,"D"	,8			,0			,0		,"G"	,""		,"mv_par01"		,""		,"01/01/80"		,""		,""		,""		,""	,""		,""		,""		,""		,""		,""		,""		,""		,"","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02"	,"Periodo Final   ","                "		,"                "		,"mv_ch2"	,"D"	,8			,0			,0		,"G"	,""		,"mv_par02"		,""		,"01/01/10"		,""		,""		,""		,""	,""		,""		,""		,""		,""		,""		,""		,""		,"","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03"	,"Estado          ","                "		,"                "		,"mv_ch3"	,"C"	,2			,0			,0		,"G"	,""		,"mv_par03"		,""      ,""				,""		,""		,""		,""	,""		,""		,""		,""		,""		,""		,""		,""		,"","","","","","","","","","","12","","",""})

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
