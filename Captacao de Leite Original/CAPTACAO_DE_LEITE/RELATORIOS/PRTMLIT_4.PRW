#INCLUDE "PROTHEUS.CH"

USER Function PRTMLIT4(Cabec1,Cabec2,Titulo,nLin, cMesAno,oObj,dDataFim,cMapa)
Local nXa	:= 0
Local lImprimiu	:= .F.
Local cMyTitulo := "mapa de leite mensal"
Local cLinCab1	:= ""
Local cLinCab2	:= ""
Local aTots		:= 0
Local nXb		:= 0
Local aGTots	:= 0
Local cLinAnt	:= ""
Local aMeses	:= {} 
Local cMes		:= ""
Local cAno		:= ""
Local nPosEsq	:= 180

nLinPag	:= 64

aadd(aMeses, "JANEIRO")
aadd(aMeses, "FEVEREIRO")
aadd(aMeses, "MARCO")
aadd(aMeses, "ABRIL")
aadd(aMeses, "MAIO")
aadd(aMeses, "JUNHO")
aadd(aMeses, "JULHO")
aadd(aMeses, "AGOSTO")
aadd(aMeses, "SETEMBRO")
aadd(aMeses, "OUTUBRO")
aadd(aMeses, "NOVEMBRO")
aadd(aMeses, "DEZEMBRO")

nXa		:= val(left(cMesAno,2))
cMes	:= aMeses[nXa]
cAno	:= right(cMesAno,4)

aTots := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

Cabec1 := ""
Cabec2 := ""

SetPrc(0,0)                              // (Zera o Formulario)
@ 0,0 PSAY AvalImp( Limite )

oObj:SetRegua2( Len(aItens) )

For nXa := 1 to Len(aItens)

	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	

	If cLinAnt <> aItens[nXa][15]
		FechLinh(@nLin, aTots, cLinAnt, Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		aTots := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
		cLinAnt	:= aItens[nXa][15]
		nLin := 100
		AbreLinh( @nLin, cLinAnt, Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo, cMes, cAno, cMesAno, nPosEsq )
	EndIf

	If nLin > nLinPag // Salto de Página. Neste caso o formulario tem 55 linhas... 
		CabPrt(@nLin, cMes, cAno, cMesAno, nPosEsq, cLinAnt)
		lImprimiu := .T.
	Endif
	
	dbSelectArea("LBB")
	dbSetOrder(1)
	
	If dbSeek( xFilial("LBE") + aItens[nXa][11] )
		dbSelectArea("SA2")
		dbSetOrder(1)
		If dbSeek( xFilial("SA2") + LBB->( LBB_CODFOR + LBB_LOJA ) )
		
			//cLinha := Padr(SA2->A2_COD, 8)
			//cLinha += Padr(SA2->A2_NOME , 37) + " "
			cLinha := Padr(LBB->LBB_CODPRO, 8)
			cLinha += Padr(LBB->LBB_NOMFOR , 37) + " "
			cLinha += padr(Alltrim(StrTran(SA2->A2_INSCR, "PR", "")),10)
			cLinha += Padl(Transform(aItens[nXa][1][1], "@E 99999"), 6)
			cLinha += Padl(Transform(aItens[nXa][1][2], "@E 99999"), 6)
			cLinha += Padl(Transform(aItens[nXa][1][3], "@E 99999"), 6)
			cLinha += Padl(Transform(aItens[nXa][1][4], "@E 99999"), 6)
			cLinha += Padl(Transform(aItens[nXa][1][5], "@E 99999"), 6)
			cLinha += Padl(Transform(aItens[nXa][1][6], "@E 99999"), 6)
			cLinha += Padl(Transform(aItens[nXa][1][7], "@E 99999"), 6)
			cLinha += Padl(Transform(aItens[nXa][1][8], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][9], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][10], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][11], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][12], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][13], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][14], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][15], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][33], "@E 999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][16], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][17], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][18], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][19], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][20], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][21], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][22], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][23], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][24], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][25], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][26], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][27], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][28], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][29], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][30], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][31], "@E 99999"), 6)
			cLinha += padl(Transform(aItens[nXa][1][34], "@E 999,999"), 9)
			cLinha += padl(Transform(aItens[nXa][1][32], "@E 999,999"), 10)
			@ nLin, 000 pSay cLinha
			nLin++
			For nXb := 1 to 34
				aTots[nXb] += aItens[nXa][1][nXb]
			Next
			lImprimiu := .T.

		endif
	Endif

oObj:IncRegua2("IMPRIMINDO . . : " + cValToChar(nXa) + " de: " + cValToChar(len(aItens)) )	

next nXA

If lImprimiu
	FechLinh(@nLin, aTots, cLinAnt, Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
Endif

Return nil


Static Function AbreLinh( nLin, cLinAnt, Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo, cMes, cAno, cMesAno, nPosEsq )
Local aAreaSav	:= GetArea()

dbSelectArea("PA7")
dbSetOrder(1)
dbSeek( xFilial("PA7") + cLinAnt )

If nLin > nLinPag // Salto de Página. Neste caso o formulario tem 55 linhas...
	CabPrt(@nLin, cMes, cAno, cMesAno, nPosEsq, cLinAnt)
Endif

RestArea(aAreaSav)
Return Nil


Static Function FechLinh(nLin, aTots, cLinAnt,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
Local nXb := 0

If aTots[32] <> 0

	If nLin > nLinPag // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif 
	
	nLin := nLinPag - 2
	
			cLinha := Padr("", 8)
			cLinha += Padr("" , 37) + " "
			cLinha += padr("",10)
			cLinha += Padl(Transform(aTots[1], "@E 99999"), 6)
			cLinha += Padl(Transform(aTots[2], "@E 99999"), 6)
			cLinha += Padl(Transform(aTots[3], "@E 99999"), 6)
			cLinha += Padl(Transform(aTots[4], "@E 99999"), 6)
			cLinha += Padl(Transform(aTots[5], "@E 99999"), 6)
			cLinha += Padl(Transform(aTots[6], "@E 99999"), 6)
			cLinha += Padl(Transform(aTots[7], "@E 99999"), 6)
			cLinha += Padl(Transform(aTots[8], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[9], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[10], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[11], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[12], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[13], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[14], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[15], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[33], "@E 999,999"), 10)
			cLinha += padl(Transform(aTots[16], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[17], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[18], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[19], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[20], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[21], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[22], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[23], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[24], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[25], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[26], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[27], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[28], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[29], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[30], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[31], "@E 99999"), 6)
			cLinha += padl(Transform(aTots[34], "@E 999,999"), 9)
			cLinha += padl(Transform(aTots[32], "@E 9999999"), 10)
			@ nLin, 000 pSay cLinha
			nLin++
Endif
Return Nil


Static Function CabPrt(nLin, cMes, cAno, cMesAno, nPosEsq, cLinAnt)
		nLin := 1
		@ nLin, nPosEsq pSay cMes + " de " + cAno
		nLin ++
		@ nLin, nPosEsq pSay "TIPO"
		nLin ++
		@ nLin, nPosEsq pSay cLinAnt + " - " + PA7->PA7_DESC
		nLin ++
		@ nLin, nPosEsq pSay dToc( LastDay( cTod( "01/" + left(cMesAno,2) + "/" + Right(cMesAno, 4) ) ) )
		nLin ++
		nLin ++
		nLin ++
		nLin ++
Return Nil