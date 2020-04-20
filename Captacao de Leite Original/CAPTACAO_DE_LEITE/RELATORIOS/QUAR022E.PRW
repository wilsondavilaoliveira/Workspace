#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAR022D  º Autor ³ Wilson Davila      º Data ³  01/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio Folha de Pagamento Produtores                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - Quata                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function QUAR022E()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Folha de Pagamento Produtores"
Local cPict          := ""
Local nLin         := 80

Local imprime      := .T.
Local aOrd := {}

Private titulo       := "Folha de Pagamento Produtores"
Private Cabec1       := ""
Private Cabec2       := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "QUAR022E"
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "QUAR022E"
Private cPerg	   := "QUAR022E"

Private cString := ""

AjustaSx1(cPerg)

If Pergunte(cPerg,.T.)
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
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

End If

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ Wilson Davila      º Data ³  01/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nXa	:= 0
Local nXb		:= 0
Local aTots		:= array(14)
Local aTotL		:= array(14)
Local nRec		:= 1
Local aFolha	:= {}
Local cnLinha	:= ''

Private cLinCab1	:= ""
Private cLinCab2	:= ""
Private cLinCab3	:= ""
Private cLinCab0	:= ""

Private cMyTitulo := "Folha de pagamento de Leite"
Private lImprimiu	:= .F.
Private aResumo	:= {}

For nXb := 1 to 14
	aTots[nXB] := 0
Next nXb

For nXC := 1 to 14
	aTotL[nXC] := 0
Next nXC

Cabec1 := ""
Cabec2 := ""

Cabec1 := ""
Cabec1 := Padr("Linha/Cod.Pro" , 14)
Cabec1 += Padr("Produtor" , 27)
Cabec1 += PadL("Volume" , 15)
Cabec1 += PadL("Vlr.Comb." , 11)
Cabec1 += PadL("Tot.Combin." , 14)
Cabec1 += PadL("Vlr.Nota" , 11)
Cabec1 += PadL("Tot.Nota" , 14)
Cabec1 += Padl("Incent." , 10)
Cabec1 += Padl("Tot.+Incent." , 14)
Cabec1 += Padl("Vlr.Final" , 11)
Cabec1 += Padl("Frete" , 11)
Cabec1 += Padl("Funrural" , 10)
Cabec1 += Padl("Subs.Trib." , 10)
Cabec1 += Padl("Fundese" , 10)
Cabec1 += Padl("Convenio" , 11)
Cabec1 += Padl("Vlr.Liquido" , 14)
cLinCab1 := Cabec1
Cabec1 := ""

aFolha := RunQuery()

nRec := len(aFolha)

SetRegua(nRec)

nRec := 0

Titulo := "Folha de Pagamento Produtores "+ StrZero(month(MV_PAR01),2)+"/"+cValToChar(year(MV_PAR01))+"-"+cValToChar(SM0->M0_FILIAL)

cnLinha := aFolha[1][1]

For nXa := 1 to Len(aFolha)-1

IncRegua(nRec)
nRec ++	
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 5
		lImprimiu := .F.
	Endif
	If !lImprimiu
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		@ nLin, 000 pSay cMyTitulo
		nLin++                        
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		
		@ nLin, 000 pSay cLinCab1
		nLin++
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		lImprimiu := .T.
	EndIf
	
	
			nConvenio 	:= aFolha[nXa][16]
			nLiquid2 	:= aFolha[nXa][17] 

			cLinha := Padr(cValToChar(aFolha[nXa][1])+" "+cValToChar(aFolha[nXa][2])	, 14)       	//LINHA/COD_PRODUTOR
			cLinha += Padr(aFolha[nXa][3] 												, 27) + " "		//Nome
			cLinha += padl(Transform(aFolha[nXa][4]	, "@E 999,999,999.99")	   		, 15)			//Volume
			cLinha += padl(Transform(aFolha[nXa][5]	, "@E 9,999.9999")				, 11)         	//Combinado
			cLinha += padl(Transform(aFolha[nXa][6]	, "@E 9,999,999.99")			, 14)        	//Total Combinado
			cLinha += padl(Transform(aFolha[nXa][7]	, "@E 9,999.9999")				, 11)    		//Valor Nota
			cLinha += padl(Transform(aFolha[nXa][8]	, "@E 9,999,999.99")			, 14)    		//Total Nota
			cLinha += padl(Transform(aFolha[nXa][9]	, "@E 99,999.99")				, 10)      		//Incentivo
			cLinha += padl(Transform(aFolha[nXa][10]	, "@E 9,999,999.99")			, 14)      		//Nota + Incentivo
			cLinha += padl(Transform(aFolha[nXa][11]	, "@E 9,999.9999")				, 11)      		//Valor nota
			cLinha += padl(Transform(aFolha[nXa][12]	, "@E 999,999.99")				, 11)      		//Frete
			cLinha += padl(Transform(aFolha[nXa][13]	, "@E 99,999.99")				, 10)      		//Funrural
			cLinha += padl(Transform(aFolha[nXa][14]	, "@E 99,999.99")				, 10)      		//ST
			cLinha += padl(Transform(aFolha[nXa][15]	, "@E 99,999.99")				, 10)      		//Fundese
			cLinha += padl(Transform(nConvenio			, "@E 999,999.99")				, 11)           //Convenio
			cLinha += padl(Transform(nLiquid2			, "@E 9,999,999.99")			, 14)           //Vlr.Liquido

			@ nLin, 000 pSay cLinha
			nLin++
			lImprimiu := .T.
		    		
			aTotL[1] += aFolha[nXa][4]
			aTotL[2] += 0
			aTotL[3] += aFolha[nXa][6]
			aTotL[4] += 0
			aTotL[5] += aFolha[nXa][8]
			aTotL[6] += aFolha[nXa][9]
			aTotL[7] += aFolha[nXa][10]
			aTotL[8] += 0
			aTotL[9] += aFolha[nXa][12]
			aTotL[10] += aFolha[nXa][13]
			aTotL[11] += aFolha[nXa][14]
			aTotL[12] += aFolha[nXa][15]
		 	aTotL[13] += nConvenio
			aTotL[14] += nLiquid2

		    If aFolha[nXA+1][1] <> cnLinha
		    	nLin := PrintSub(nLin,aTotL,cnLinha)
				aTotL := array(14)
					For nXC := 1 to 14
					aTotL[nXC] := 0
					Next nXC
				cnLinha:= aFolha[nXA+1][1] 
			End If
			
			aTots[1] += aFolha[nXa][4]
			aTots[2] += 0
			aTots[3] += aFolha[nXa][6]
			aTots[4] += 0
			aTots[5] += aFolha[nXa][8]
			aTots[6] += aFolha[nXa][9]
			aTots[7] += aFolha[nXa][10]
			aTots[8] += 0
			aTots[9] += aFolha[nXa][12]
			aTots[10] += aFolha[nXa][13]
			aTots[11] += aFolha[nXa][14]
			aTots[12] += aFolha[nXa][15]
		 	aTots[13] += nConvenio
			aTots[14] += nLiquid2

next nXA


If lImprimiu
    nLin := 56
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 5
		lImprimiu := .F.
	Endif

	If !lImprimiu
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		@ nLin, 000 pSay cMyTitulo
		nLin++                        
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		
		@ nLin, 000 pSay cLinCab1
		nLin++
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		lImprimiu := .T.
	EndIf

	nLin := PrtResumo(nLin)

	aTots[2] := aTots[3]/aTots[1]
	aTots[4] := aTots[5]/aTots[1]
	aTots[8] += aTots[7]/aTots[1]
	
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	
	cLinha := Padr("Totais" , 7)
	cLinha += Padr("da Folha de pagamento leite" , 35)
	cLinha += padl(Transform(aTots[1], "@E 999,999,999.99"), 15)
	cLinha += padl(Transform(aTots[2], "@E 9,999.9999"), 11)
	cLinha += padl(Transform(aTots[3], "@E 9,999,999.99"), 14)
	cLinha += padl(Transform(aTots[4], "@E 9,999.9999"), 11)
	cLinha += padl(Transform(aTots[5], "@E 9,999,999.99"), 14)
	cLinha += padl(Transform(aTots[6], "@E 99,999.99"), 10)
	cLinha += padl(Transform(aTots[7], "@E 9,999,999.99"), 14)
	cLinha += padl(Transform(aTots[8], "@E 9,999.9999"), 11)
	cLinha += padl(Transform(aTots[9], "@E 999,999.99"), 11)
	cLinha += padl(Transform(aTots[10], "@E 99,999.99"), 10)
	cLinha += padl(Transform(aTots[11], "@E 99,999.99"), 10)
	cLinha += padl(Transform(aTots[12], "@E 99,999.99"), 10)
	cLinha += padl(Transform(aTots[13], "@E 999,999.99"), 11)
	cLinha += padl(Transform(aTots[14], "@E 9,999,999.99"), 14)
	@ nLin, 000 pSay cLinha
	nLin++
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	
Endif

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


/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime Sub Total por linha³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/

Static Function PrintSub(nLin,aTotL,cnLinha)

Local cLinha 	:= ''
Local aRet		:= {} 

	
	aTotL[2] := aTotL[3]/aTotL[1]
	aTotL[4] := aTotL[5]/aTotL[1]
	aTotL[8] += aTotL[7]/aTotL[1]
	
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	
	cLinha := Padr("Totais" , 7)
	cLinha += Padr("da Linha de leite-"+cnLinha , 35)
	cLinha += padl(Transform(aTotL[1], "@E 999,999,999.99"), 15)
	cLinha += padl(Transform(aTotL[2], "@E 9,999.9999"), 11)
	cLinha += padl(Transform(aTotL[3], "@E 9,999,999.99"), 14)
	cLinha += padl(Transform(aTotL[4], "@E 9,999.9999"), 11)
	cLinha += padl(Transform(aTotL[5], "@E 9,999,999.99"), 14)
	cLinha += padl(Transform(aTotL[6], "@E 99,999.99"), 10)
	cLinha += padl(Transform(aTotL[7], "@E 9,999,999.99"), 14)
	cLinha += padl(Transform(aTotL[8], "@E 9,999.9999"), 11)
	cLinha += padl(Transform(aTotL[9], "@E 999,999.99"), 11)
	cLinha += padl(Transform(aTotL[10], "@E 99,999.99"), 10)
	cLinha += padl(Transform(aTotL[11], "@E 99,999.99"), 10)
	cLinha += padl(Transform(aTotL[12], "@E 99,999.99"), 10)
	cLinha += padl(Transform(aTotL[13], "@E 999,999.99"), 11)
	cLinha += padl(Transform(aTotL[14], "@E 9,999,999.99"), 14)
	@ nLin, 000 pSay cLinha
	nLin++
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	nLin++
    
	PA7->( dbSetOrder(1) )
	PA7->( dbSeek(cFilAnt+cnLinha) )
	AADD(aResumo,{cnLinha+"-"+cValToChar(PA7->PA7_DESC),aTotL[1],aTotL[2],aTotL[3],aTotL[4],aTotL[5],aTotL[6],aTotL[7],aTotL[8],;
	aTotL[9],aTotL[10],aTotL[11],aTotL[12],aTotL[13],aTotL[14]})    

Return(nLin)


/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime resumo por linha no final do relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
Static Function PrtResumo(nLin)

Local cLinha 	:= ''
	
	@ nLin, 000 pSay "R E S U M O     L I N H A S"
	nLin++
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	
	For i:=1 To Len(aResumo)
	
	cLinha := Padr(aResumo[i][1] , 42)
	cLinha += padl(Transform(aResumo[i][2], "@E 999,999,999.99"), 15)
	cLinha += padl(Transform(aResumo[i][3], "@E 9,999.9999"), 11)
	cLinha += padl(Transform(aResumo[i][4], "@E 9,999,999.99"), 14)
	cLinha += padl(Transform(aResumo[i][5], "@E 9,999.9999"), 11)
	cLinha += padl(Transform(aResumo[i][6], "@E 9,999,999.99"), 14)
	cLinha += padl(Transform(aResumo[i][7], "@E 99,999.99"), 10)
	cLinha += padl(Transform(aResumo[i][8], "@E 9,999,999.99"), 14)
	cLinha += padl(Transform(aResumo[i][9], "@E 9,999.9999"), 11)
	cLinha += padl(Transform(aResumo[i][10], "@E 999,999.99"), 11)
	cLinha += padl(Transform(aResumo[i][11], "@E 99,999.99"), 10)
	cLinha += padl(Transform(aResumo[i][12], "@E 99,999.99"), 10)
	cLinha += padl(Transform(aResumo[i][13], "@E 99,999.99"), 10)
	cLinha += padl(Transform(aResumo[i][14], "@E 999,999.99"), 11)
	cLinha += padl(Transform(aResumo[i][15], "@E 9,999,999.99"), 14)
	@ nLin, 000 pSay cLinha
	nLin++
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 5
		lImprimiu := .F.
	Endif

	If !lImprimiu
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		@ nLin, 000 pSay cMyTitulo
		nLin++                        
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		
		@ nLin, 000 pSay cLinCab1
		nLin++
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		lImprimiu := .T.
	EndIf

	Next
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 5
		lImprimiu := .F.
	Endif

	If !lImprimiu
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		@ nLin, 000 pSay cMyTitulo
		nLin++                        
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		
		@ nLin, 000 pSay cLinCab1
		nLin++
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		lImprimiu := .T.
	EndIf

	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	   
Return(nLin)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³AjustaSX1 ³ Autor ³  Wilson Davila        ³ Data ³01/12/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta perguntas no SX1.                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function AjustaSx1(cPerg)

PutSx1(cPerg,"01","Entrada De?" 	,"","","mv_ch1","D",08,0,0,"G","",""		,"","","mv_par01")
PutSX1(cPerg,"02","Entrada Até?"	,"","","mv_ch2","D",08,0,0,"G","",""		,"","","mv_par02")
PutSx1(cPerg,"03","Produtor De?" 	,"","","mv_ch3","C",06,0,0,"G","","LBBCOD"	,"","","mv_par03")
PutSX1(cPerg,"04","Produtor Até?"	,"","","mv_ch4","C",06,0,0,"G","","LBBCOD"	,"","","mv_par04")
PutSx1(cPerg,"05","Linha De?" 		,"","","mv_ch5","C",06,0,0,"G","","PA7"	,"","","mv_par05")
PutSX1(cPerg,"06","Linha Até?"		,"","","mv_ch6","C",06,0,0,"G","","PA7"	,"","","mv_par06")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RunQuery  ºAutor  ³Wilson Davila       º Data ³  01/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Query levantamento de dados para relatorio                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - Quata                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunQuery(nMes,nAno)

Local cQuery	:= ""
Local aRetorno	:= {}
Local cCodPro	:= ''
Local nLinha	:= 1
Local lGo		:= .T.

cQuery := "SELECT LBB_LINHA,LBQ_CODPRO,LBB_NOMFOR,LBQ_DATFIN,LBQ_DESC,LBQ_VALOR,LBQ_QTD "
cQuery += "FROM " + RetSqlName("LBQ") + " LBQ "
cQuery += "INNER JOIN " + RetSqlName("LBB") + " LBB ON LBQ_CODPRO=LBB_CODPRO AND LBB_FILIAL=LBQ_FILIAL AND LBB.D_E_L_E_T_='' "
cQuery += "WHERE LBQ_FILIAL='" + cFilAnt + "' AND LBQ_DATFIN>='" + DtOs(MV_PAR01) +"' AND LBQ_DATFIN<='" + DtOs(MV_PAR02) + "' AND LBQ.D_E_L_E_T_=''
cQuery += "AND LBQ_CODPRO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " 
cQuery += "AND LBB_LINHA BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " 
cQuery += "AND LBB_CODFOR+LBB_LOJA NOT IN("
cQuery += "SELECT LBE_FORNEC+LBE_LOJA FROM " + RetSqlName("LBE") + " LBE WHERE LBE_FILIAL='" + cFilAnt + "' AND LBE.D_E_L_E_T_='')
cQuery += "ORDER BY CAST(LBB_LINHA AS INT),CAST(LBQ_CODPRO AS INT) "

MemoWrite("C:\EDI\FOL_PRO.SQL",cQuery)

cQuery := ChangeQuery( cQuery )

If Select("QRYNFE") > 0
	dbSelectArea("QRYNFE")
	QRYNFE->(dbCloseArea())
EndIf

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYNFE', .F., .T.)

dbSelectArea("QRYNFE")
dbGotop()

While QRYNFE->(!Eof())
nLinha ++
QRYNFE->( dbSkip() )
End While 

QRYNFE->( dbGoTop() )

nLinha := 1

cCodPro	:= QRYNFE->LBQ_CODPRO

         
*"Entrada de Leite" R
*"Valor do Incentivo" R
*"Carreto 1o. Percurso" D
*"Carreto 2o. Percurso" D
*"Funrural" D
*"Senar" D
*"FUNDESE" D
*"Subst.Tributaria" D
*"Desconto Convenio" D


AADD(aRetorno,{"","","",0,0,0,0,0,0,0,0,0,0,0,0,0,0})

While QRYNFE->(!Eof())

	If lGo
	
		For nXd := 1 to 17
		aRetorno[nlinha][nXd] := 0
		Next
		lGo := .F.

	End if	
	
	aRetorno[nLinha][1] :=  QRYNFE->LBB_LINHA //LINHA
	aRetorno[nLinha][2]:= QRYNFE->LBQ_CODPRO//CODIGO PRODUTOR
    aRetorno[nLinha][3]:= QRYNFE->LBB_NOMFOR//NOME PRODUTOR
	
	If 		AllTrim(QRYNFE->LBQ_DESC) == "Entrada de Leite"
			aRetorno[nLinha][4]:= QRYNFE->LBQ_QTD //VOLUME
    		aRetorno[nLinha][5]:= RunPrLt(cCodPro)//PRECO UNITARIO MEDIO COMBINADO
    		aRetorno[nLinha][6]:= Round(QRYNFE->LBQ_QTD * aRetorno[nLinha][5],2)//TOTAL COMBINADO 
    		aRetorno[nLinha][7]:= Round(QRYNFE->LBQ_VALOR/QRYNFE->LBQ_QTD,4)//PRECO UNTARIO NOTA (SOMA IMPOSTOS) 
    		aRetorno[nLinha][8]:= QRYNFE->LBQ_VALOR //TOTAL NOTA (SOMA IMPOSTOS)
	ElseIf	AllTrim(QRYNFE->LBQ_DESC) == "Valor do Incentivo"
			aRetorno[nLinha][9]:= QRYNFE->LBQ_VALOR //INCENTIVO
	ElseIf	AllTrim(QRYNFE->LBQ_DESC) == "Carreto 1o. Percurso" .OR. AllTrim(QRYNFE->LBQ_DESC) == "Carreto 2o. Percurso"
			aRetorno[nLinha][12]+= QRYNFE->LBQ_VALOR //FRETE
	ElseIf	AllTrim(QRYNFE->LBQ_DESC) == "Funrural"
			aRetorno[nLinha][13]:= QRYNFE->LBQ_VALOR //FUNRURAL
	ElseIf	AllTrim(QRYNFE->LBQ_DESC) == "Subst.Tributaria"
			aRetorno[nLinha][14]:= QRYNFE->LBQ_VALOR //SUBST.TRIBUTARIA
	ElseIf	AllTrim(QRYNFE->LBQ_DESC) == "FUNDESE"
			aRetorno[nLinha][15]:= QRYNFE->LBQ_VALOR //FUNDESE
	ElseIf	AllTrim(QRYNFE->LBQ_DESC) == "Desconto Convenio"
			aRetorno[nLinha][16]:= QRYNFE->LBQ_VALOR //CONVENIO
    EndIf
    
    aRetorno[nLinha][10]:= aRetorno[nLinha][8] + aRetorno[nLinha][9] //TOTAL (IMPOSTOS) + INCENTIVO
	aRetorno[nLinha][11]:= Round(aRetorno[nLinha][10]/aRetorno[nLinha][4],4)//PRECO UNITARIO TOTAL(IMPOSTOS) + INCENTIVO
	aRetorno[nLinha][17]:= aRetorno[nLinha][10]-aRetorno[nLinha][12]-aRetorno[nLinha][13]-aRetorno[nLinha][14];
	-aRetorno[nLinha][15]-aRetorno[nLinha][16]

QRYNFE->(dbSkip())

If QRYNFE->LBQ_CODPRO <> cCodPro
AADD(aRetorno,{"","","",0,0,0,0,0,0,0,0,0,0,0,0,0,0})

nLinha ++
lGo := .T.
cCodPro := QRYNFE->LBQ_CODPRO
End If

End While 

/*for i:=1 to len(aRetorno)

RecLock("ZZZ",.T.)
ZZZ->ZZZ_CONTRA 	:= cValToChar(aRetorno[i][1])
ZZZ->ZZZ_REVISA 	:= cValToChar(aRetorno[i][2])
ZZZ->ZZZ_DATA 		:= cValToChar(aRetorno[i][3])
ZZZ->ZZZ_PRE1 		:= cValToChar(aRetorno[i][4])
ZZZ->ZZZ_VRBRUT 	:= cValToChar(aRetorno[i][5])
ZZZ->ZZZ_PRE2 		:= cValToChar(aRetorno[i][6])
ZZZ->ZZZ_VR2 		:= cValToChar(aRetorno[i][7])
ZZZ->ZZZ_PRE3 		:= cValToChar(aRetorno[i][8])
ZZZ->ZZZ_VR3 		:= cValToChar(aRetorno[i][9])
ZZZ->ZZZ_PRE4 		:= cValToChar(aRetorno[i][10])
ZZZ->ZZZ_VR4 		:= cValToChar(aRetorno[i][11])
ZZZ->ZZZ_PRE5 		:= cValToChar(aRetorno[i][12])
ZZZ->ZZZ_VR5 		:= cValToChar(aRetorno[i][13])
ZZZ->ZZZ_PRE6 		:= cValToChar(aRetorno[i][14])
ZZZ->ZZZ_VR6 		:= cValToChar(aRetorno[i][15])
ZZZ->ZZZ_PRE7 		:= cValToChar(aRetorno[i][16])
ZZZ->ZZZ_VR7 		:= cValToChar(aRetorno[i][17])

MsUnlock()

Next

break
*/

Return (aRetorno)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RunAbat   ºAutor  ³Wilson Davila       º Data ³  01/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Query levantamento de dados de abatimentos carreteiro       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - Quata                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunPrLt(cCodPro)

Local cQuery1	:= ""
Local nRet		:= 0

cQuery1 := "SELECT AVG(LBO_VALOR) AS VALOR " 
cQuery1 += "FROM " + RetSqlName("LBO") + " LBO "
cQuery1 += "WHERE LBO_FILIAL= '" + cFilAnt + "' AND LBO.D_E_L_E_T_='' "
cQuery1 += "AND LBO_CODPRO='" + cCodPro + "' AND MONTH(LBO_DATENT)=" + cValTochar(month (MV_PAR01)) + " AND YEAR(LBO_DATENT)=" +  cValToChar(year( MV_PAR01 )) + " "

MemoWrite("C:\EDI\CONV.SQL",cQuery1)

cQuery1 := ChangeQuery( cQuery1 )

If Select("QRYCONV") > 0
	dbSelectArea("QRYCONV")
	QRYCONV->(dbCloseArea())
EndIf

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery1), 'QRYCONV', .F., .T.)

QRYCONV->( dbGoTop() )

nRet := QRYCONV->VALOR

Return(nRet)


