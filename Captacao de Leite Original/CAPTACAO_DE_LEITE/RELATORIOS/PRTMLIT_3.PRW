#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPRTMLIT_3 บAutor  ณMicrosiga           บ Data ณ  11/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao mapa de leite teodoro sampaio - oficial          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PRTMLIT3(Cabec1,Cabec2,Titulo,nLin, cMesAno,oObj,dDataFim,cMapa)

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
Local nPosEsq	:= 164

nLinPag	:= 60

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
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	

	If cLinAnt <> aItens[nXa][15]
		
		FechLinh(@nLin, aTots, cLinAnt, Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		aTots := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
		cLinAnt	:= aItens[nXa][15]
		nLin := 100
		AbreLinh( @nLin, cLinAnt, Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo, cMes, cAno, cMesAno, nPosEsq )
		
	
	EndIf

	If nLin > nLinPag // Salto de Pแgina. Neste caso o formulario tem 55 linhas... 
		
		if nXa <> 1
		cMapa := StrZero( Val(cMapa)+1,6 )
	    End If
		
		CabPrt(@nLin, cMes, cAno, cMesAno, nPosEsq, cLinAnt)
		lImprimiu := .T.
	
	Endif
	
	dbSelectArea("LBB")
	dbSetOrder(1)
	
	If dbSeek( xFilial("LBE") + aItens[nXa][11] )
		dbSelectArea("SA2")
		dbSetOrder(1)
		If dbSeek( xFilial("SA2") + LBB->( LBB_CODFOR + LBB_LOJA ) )
	    
//	    SF1->( dbSetOrder(9))
	    SF1->( DBORDERNICKNAME('F1FORLJDTM') )
	    If SF1->( dbseek(xFilial("SF1")+LBB->LBB_CODFOR+LBB->LBB_LOJA+DTOS(dDataFim)) )
		
		RecLock("SF1",.F.)
		SF1->F1_XMAPA := StrZero(val(cMapa),6)
		MsUnlock()
		
		End IF	
			
			//cLinha := Padr(SA2->A2_COD, 8)
			//cLinha += Padr(SA2->A2_NOME , 45) + " "
			cLinha := Padr(LBB->LBB_CODPRO, 8)
			cLinha += Padr(LBB->LBB_NOMFOR , 45) + " "
			cLinha += padr(Alltrim(StrTran(SA2->A2_INSCR, "PR", "")),10)
			cLinha += Space(10)
			cLinha += Padl(Transform(aItens[nXa][1][1], "@E 99999"), 8)//DIA 1
			cLinha += Padl(Transform(aItens[nXa][1][2], "@E 99999"), 8)//DIA 2
			cLinha += Padl(Transform(aItens[nXa][1][3], "@E 99999"), 8)//DIA 3
			cLinha += Padl(Transform(aItens[nXa][1][4], "@E 99999"), 8)//DIA 4
			cLinha += Padl(Transform(aItens[nXa][1][5], "@E 99999"), 8)//DIA 5
			cLinha += Padl(Transform(aItens[nXa][1][6], "@E 99999"), 8)//DIA 6
			cLinha += Padl(Transform(aItens[nXa][1][7], "@E 99999"), 8)//DIA 7
			cLinha += Padl(Transform(aItens[nXa][1][8], "@E 99999"), 8)//DIA 8
			cLinha += padl(Transform(aItens[nXa][1][9], "@E 99999"), 8)//DIA 9
			cLinha += padl(Transform(aItens[nXa][1][10], "@E 99999"), 8)//DIA 10
			cLinha += padl(Transform(aItens[nXa][1][11], "@E 99999"), 8)//DIA 11
			cLinha += padl(Transform(aItens[nXa][1][12], "@E 99999"), 8)//DIA 12
			cLinha += padl(Transform(aItens[nXa][1][13], "@E 99999"), 8)//DIA 13
			cLinha += padl(Transform(aItens[nXa][1][14], "@E 99999"), 8)//DIA 14
			cLinha += padl(Transform(aItens[nXa][1][15], "@E 99999"), 8)//DIA 15
			cLinha += padl(Transform(0, "@E 99999"), 8)//DIA 31			
			cLinha += space(6)
			cLinha += padl(Transform(aItens[nXa][1][33], "@E 999,999"), 10) //TOTAL 1A QUINZ 
			
			@ nLin, 000 pSay cLinha
			nLin++
			
			cLinha := Space(74)
			cLinha += padl(Transform(aItens[nXa][1][16], "@E 99999"), 8)//DIA 16
			cLinha += padl(Transform(aItens[nXa][1][17], "@E 99999"), 8)//DIA 17
			cLinha += padl(Transform(aItens[nXa][1][18], "@E 99999"), 8)//DIA 18
			cLinha += padl(Transform(aItens[nXa][1][19], "@E 99999"), 8)//DIA 19
			cLinha += padl(Transform(aItens[nXa][1][20], "@E 99999"), 8)//DIA 20
			cLinha += padl(Transform(aItens[nXa][1][21], "@E 99999"), 8)//DIA 21
			cLinha += padl(Transform(aItens[nXa][1][22], "@E 99999"), 8)//DIA 22
			cLinha += padl(Transform(aItens[nXa][1][23], "@E 99999"), 8)//DIA 23
			cLinha += padl(Transform(aItens[nXa][1][24], "@E 99999"), 8)//DIA 24
			cLinha += padl(Transform(aItens[nXa][1][25], "@E 99999"), 8)//DIA 25
			cLinha += padl(Transform(aItens[nXa][1][26], "@E 99999"), 8)//DIA 26
			cLinha += padl(Transform(aItens[nXa][1][27], "@E 99999"), 8)//DIA 27
			cLinha += padl(Transform(aItens[nXa][1][28], "@E 99999"), 8)//DIA 28
			cLinha += padl(Transform(aItens[nXa][1][29], "@E 99999"), 8)//DIA 29
			cLinha += padl(Transform(aItens[nXa][1][30], "@E 99999"), 8)//DIA 30
			cLinha += padl(Transform(aItens[nXa][1][31], "@E 99999"), 8)//DIA 31
			cLinha += Space(6)
			cLinha += padl(Transform(aItens[nXa][1][34], "@E 999,999"), 10)//TOTAL 2A QUINZ
			cLinha += Space(4)
			cLinha += padl(Transform(aItens[nXa][1][32], "@E 999,999"), 10)//TOTAL GERAL
			cLinha += Space(30)
			cLinha += padl(SF1->F1_DOC, 9)
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAbreLinh  บAutor  ณMicrosiga           บ Data ณ  11/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function AbreLinh( nLin, cLinAnt, Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo, cMes, cAno, cMesAno, nPosEsq )

Local aAreaSav	:= GetArea()

dbSelectArea("PA7")
dbSetOrder(1)
dbSeek( xFilial("PA7") + cLinAnt )

If nLin > nLinPag // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	CabPrt(@nLin, cMes, cAno, cMesAno, nPosEsq, cLinAnt)
Endif

RestArea(aAreaSav)
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFechLinh  บAutor  ณMicrosiga           บ Data ณ  11/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime corpo relatorio                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FechLinh(nLin, aTots, cLinAnt,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

Local nXb := 0

If aTots[32] <> 0

	If nLin > nLinPag // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif 
	
	nLin := nLinPag + 1
	
			cLinha := Space(74)
			cLinha += Padl(Transform(aTots[1], "@E 99999"), 8)//1
			cLinha += Padl(Transform(aTots[2], "@E 99999"), 8)//2
			cLinha += Padl(Transform(aTots[3], "@E 99999"), 8)//3
			cLinha += Padl(Transform(aTots[4], "@E 99999"), 8)//4
			cLinha += Padl(Transform(aTots[5], "@E 99999"), 8)//5
			cLinha += Padl(Transform(aTots[6], "@E 99999"), 8)//6
			cLinha += Padl(Transform(aTots[7], "@E 99999"), 8)//7
			cLinha += Padl(Transform(aTots[8], "@E 99999"), 8)//8
			cLinha += padl(Transform(aTots[9], "@E 99999"), 8)//9
			cLinha += padl(Transform(aTots[10], "@E 99999"), 8)//10
			cLinha += padl(Transform(aTots[11], "@E 99999"), 8)//11
			cLinha += padl(Transform(aTots[12], "@E 99999"), 8)//12
			cLinha += padl(Transform(aTots[13], "@E 99999"), 8)//13
			cLinha += padl(Transform(aTots[14], "@E 99999"), 8)//14
			cLinha += padl(Transform(aTots[15], "@E 99999"), 8)//15
			cLinha += padl(Transform(0, "@E 99999"), 8)//DIA 31
			cLinha += space(6)
			cLinha += padl(Transform(aTots[33], "@E 999,999"), 10)
			@ nLin, 000 pSay cLinha
			nLin++
			
			cLinha := Space(74)
			cLinha += padl(Transform(aTots[16], "@E 99999"), 8)
			cLinha += padl(Transform(aTots[17], "@E 99999"), 8)
			cLinha += padl(Transform(aTots[18], "@E 99999"), 8)
			cLinha += padl(Transform(aTots[19], "@E 99999"), 8)
			cLinha += padl(Transform(aTots[20], "@E 99999"), 8)
			cLinha += padl(Transform(aTots[21], "@E 99999"), 8)
			cLinha += padl(Transform(aTots[22], "@E 99999"), 8)
			cLinha += padl(Transform(aTots[23], "@E 99999"), 8)
			cLinha += padl(Transform(aTots[24], "@E 99999"), 8)
			cLinha += padl(Transform(aTots[25], "@E 99999"), 8)
			cLinha += padl(Transform(aTots[26], "@E 99999"), 8)
			cLinha += padl(Transform(aTots[27], "@E 99999"), 8)
			cLinha += padl(Transform(aTots[28], "@E 99999"), 8)
			cLinha += padl(Transform(aTots[29], "@E 99999"), 8)
			cLinha += padl(Transform(aTots[30], "@E 99999"), 8)
			cLinha += padl(Transform(aTots[31], "@E 99999"), 8)
			cLinha += space(6)
			cLinha += padl(Transform(aTots[34], "@E 999,999"), 10)
			cLinha += space(4)
			cLinha += padl(Transform(aTots[32], "@E 9999999"), 10)
			@ nLin, 000 pSay cLinha
			nLin++

Endif

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCabPr     บAutor  ณMicrosiga           บ Data ณ  11/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime cabecalho relatorio                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CabPrt(nLin, cMes, cAno, cMesAno, nPosEsq, cLinAnt)
	   
		nLin := 2
		@ nLin, nPosEsq pSay cMes 
		nLin ++
		@ nLin, nPosEsq pSay cAno
		nLin ++
		@ nLin, nPosEsq pSay "LEITE CRU"
		nLin ++
		If cFilAnt == '03'
		@ nLin, nPosEsq pSay "TEODORO SAMPAIO"
		ElseIf cFilAnt == '09'
		@ nLin, nPosEsq pSay "ITAPERUNA"
		ElseIf cFilAnt == '10'
		@ nLin, nPosEsq pSay "BOM JESUS"
		Else
		@ nLin, nPosEsq pSay "MERCEDES"
		End IF
		
		nLin ++
		@ nLin, nPosEsq pSay cLinAnt + " - " + PA7->PA7_DESC
		nLin := nLin + 5
		
Return Nil