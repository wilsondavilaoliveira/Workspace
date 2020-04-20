#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQUAR022A  บAutor  ณWilson Davila       บ Data ณ  16/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mapa demosntrativo de entrada de leite diario,opcao        บฑฑ
ฑฑบ          ณ 1-Oficial - Impressora matricial entrega posto fiscal      บฑฑ
ฑฑบ          ณ 2-Lista   - Impressora laser somente para conferencia.     บฑฑ
ฑฑบ          ณ Programa PRTMLIT_3 Imprime oficial Teodoro                 บฑฑ
ฑฑบ          ณ Programa PRTMLIT_4 Imprime oficial Vazante                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10 Quata                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Quar022A()       

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Resumo da capta็ใo de leite"
Local cPict         := ""
Local titulo       	:= "Mapa Demonstrativo Capta็ใo de leite - " + cValToChar(SM0->M0_FILIAL)
Local nLin         	:= 220

Local Cabec1       	:= " "
Local Cabec2       	:= " "
Local imprime      	:= .F.
Local aOrd 			:= {}
Local cMesAno		:= ""

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "QUAR022A" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private wnrel      	:= "QUAR022A" // Coloque aqui o nome do arquivo usado para impressao em disco
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 1, "", "", 1}
Private nLastKey    := 0
Private cPerg       := PadR("QT022A",10)
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private nLinPag		:= 60
Private cString 	:= "SA1"
Private oProcess	:= NIL
Private oReport

dbSelectArea("SA1")
dbSetOrder(1)

AjustaSx1(cPerg)


pergunte(cPerg,.t.)

//O relatorio oficial apenas estแ no layout antigo
If MV_PAR09 == 1 .Or. MV_PAR07 == 1

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.,,,,,1)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	
	If nLastKey == 27
		Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If Month(MV_PAR01) == Month(MV_PAR02) .and. Year(MV_PAR01) == Year(MV_PAR02)
		
		cMesAno := Alltrim(StrZero(Month(MV_PAR01),2))+Alltrim(StrZero(Year(MV_PAR01),4))
		
		dDataIni := cTod("01/"+Alltrim(StrZero(Month(MV_PAR01),2))+"/"+Alltrim(StrZero(Year(MV_PAR01),4)) )
		dDataFim := LastDay(dDataIni)
	
	Endif

	oProcess := MsNewProcess():New({|| RunReport(Cabec1,Cabec2,Titulo,@nLin, cMesAno,oProcess) },Titulo,"Processando:. . . ",.T.)
	oProcess:Activate()
Else
	oReport := reportDef()
	oReport:printDialog()
Endif

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRunReport บAutor  ณWilson Davila       บ Data ณ  16/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao do relatorio 2-lista                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin, cMesAno,oObj)

Local nOrdem
Private aNotas 	:= {}
Private aItens	:= {}

dbSelectArea(cString)
dbSetOrder(1)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RunNFET( cMesAno,oObj )
SomaDia( cMesAno,oObj )


If MV_PAR07 == 2
	// Imprime lista
	u_prcMPLEI(Cabec1,Cabec2,Titulo,@nLin, cMesAno) // 2 linhas
Else //Imprime mapa oficial - Vazante e teodoro

//aTemp := aClone(aItens)
//aItens := aSort( aTemp,,,{|X,Y| x[15] < y[15]} )

	Do Case 
		Case cFilAnt == '04' .or. cFilAnt == '05' .or. cFilAnt == '08'
			U_PRTMLIT4(Cabec1,Cabec2,Titulo,@nLin, cMesAno,oObj) // 1 linha - Vazante
		Case cFilAnt == '03' .or. cFilAnt == '02' .or. cFilAnt == '09' .or. cFilAnt == '10'
			U_PRTMLIT3(Cabec1,Cabec2,Titulo,@nLin, cMesAno,oObj,dDataFim,MV_PAR08)	//2 linhas Teodoro
	EndCase
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณprcMPLEI  บAutor  ณWilson Davila       บ Data ณ  16/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime mapa de leite 2-lista somente para conferencia de  บฑฑ
ฑฑบ          ณ leite dia a dia por linha por produtor                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10 - Quata                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function prcMPLEI(Cabec1,Cabec2,Titulo,nLin, cMesAno)

Local nXa	:= 0
Local lImprimiu	:= .F.
Local cMyTitulo := "Previa do mapa de leite mensal"
Local cLinCab1	:= ""
Local cLinCab2	:= ""
Local aTots		:= 0
Local nXb		:= 0
Local aGTots	:= 0
Local cLinAnt	:= ""

nLinPag := 52

aTots := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
aGTots := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

Cabec1 := ""
Cabec2 := ""
Cabec1 := Padr("Codigo" , 12)
Cabec1 += Padr("Propriedade" , 28)
Cabec1 += Padl("Dia 01" , 10)
Cabec1 += Padl("Dia 02" , 10)
Cabec1 += Padl("Dia 03" , 10)
Cabec1 += Padl("Dia 04" , 10)
Cabec1 += Padl("Dia 05" , 10)
Cabec1 += Padl("Dia 06" , 10)
Cabec1 += Padl("Dia 07" , 10)
Cabec1 += Padl("Dia 08" , 10)
Cabec1 += Padl("Dia 09" , 10)
Cabec1 += Padl("Dia 10" , 10)
Cabec1 += Padl("Dia 11" , 10)
Cabec1 += Padl("Dia 12" , 10)
Cabec1 += Padl("Dia 13" , 10)
Cabec1 += Padl("Dia 14" , 10)
Cabec1 += Padl("Dia 15" , 10)
Cabec1 += Padl("Dia 16" , 10)
cLinCab1 := Cabec1
Cabec1 := ""
Cabec1 := Padr("Linha" , 12)
Cabec1 += Padr(" " , 28)
Cabec1 += Padl("Dia 17" , 10)
Cabec1 += Padl("Dia 18" , 10)
Cabec1 += Padl("Dia 19" , 10)
Cabec1 += Padl("Dia 20" , 10)
Cabec1 += Padl("Dia 21" , 10)
Cabec1 += Padl("Dia 22" , 10)
Cabec1 += Padl("Dia 23" , 10)
Cabec1 += Padl("Dia 24" , 10)
Cabec1 += Padl("Dia 25" , 10)
Cabec1 += Padl("Dia 26" , 10)
Cabec1 += Padl("Dia 27" , 10)
Cabec1 += Padl("Dia 28" , 10)
Cabec1 += Padl("Dia 29" , 10)
Cabec1 += Padl("Dia 30" , 10)
Cabec1 += Padl("Dia 31" , 10)
Cabec1 += Padl("Total" , 10)
cLinCab2 := Cabec1
Cabec1 := ""

Cabec1 := cLinCab1
Cabec2 := cLinCab2

Titulo := "Mapa Volume Diแrio de Leite " +StrZero(month(MV_PAR01),2)+"/"+cValToChar(year(MV_PAR01))+"-"+cValToChar(SM0->M0_FILIAL) 

For nXa := 1 to Len(aItens)
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If nLin > nLinPag // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		If lImprimiu
	 		@ nLin, 000 pSay __PrtThinLine()
	 		nLin ++
	 	Endif
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
		lImprimiu := .T.
	Endif

	If cLinAnt <> aItens[nXa][15]
		
		FechLinh(@nLin, aTots, cLinAnt, Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		
		aTots := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
		
		If cLinAnt <> ""
		nLin := 100
		End if
		
		cLinAnt	:= aItens[nXa][15]
		AbreLinh( @nLin, cLinAnt, Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo )
		
	EndIf

	If nLin > nLinPag // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		If lImprimiu
	 		@ nLin, 000 pSay __PrtThinLine()
	 		nLin ++
	 	Endif
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
		lImprimiu := .T.
	Endif
	
	dbSelectArea("LBB")
	dbSetOrder(1)
	
	If dbSeek( xFilial("LBE") + aItens[nXa][11] )
		dbSelectArea("SA2")
		dbSetOrder(1)
		If dbSeek( xFilial("SA2") + LBB->( LBB_CODFOR + LBB_LOJA ) )
		
			//cLinha := Padr(SA2->A2_COD + " " + SA2->A2_LOJA , 12)
			//cLinha += Padr(SA2->A2_NOME , 27) + " "
			cLinha := Padr(LBB->LBB_CODPRO , 12)
			cLinha += Padr(LBB->LBB_NOMFOR , 27) + " "
			cLinha += Padl(Transform(aItens[nXa][1][1], "@E 9,999,999"), 10)
			cLinha += Padl(Transform(aItens[nXa][1][2], "@E 9,999,999"), 10)
			cLinha += Padl(Transform(aItens[nXa][1][3], "@E 9,999,999"), 10)
			cLinha += Padl(Transform(aItens[nXa][1][4], "@E 9,999,999"), 10)
			cLinha += Padl(Transform(aItens[nXa][1][5], "@E 9,999,999"), 10)
			cLinha += Padl(Transform(aItens[nXa][1][6], "@E 9,999,999"), 10)
			cLinha += Padl(Transform(aItens[nXa][1][7], "@E 9,999,999"), 10)
			cLinha += Padl(Transform(aItens[nXa][1][8], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][9], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][10], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][11], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][12], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][13], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][14], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][15], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][16], "@E 9,999,999"), 10)
			@ nLin, 000 pSay cLinha
			nLin++
			lImprimiu := .T.
	
			cLinha := Padr(aItens[nXa][15] , 7)
			cLinha += Padr(" " , 33)
			cLinha += padl(Transform(aItens[nXa][1][17], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][18], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][19], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][20], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][21], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][22], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][23], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][24], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][25], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][26], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][27], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][28], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][29], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][30], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][31], "@E 9,999,999"), 10)
			cLinha += padl(Transform(aItens[nXa][1][32], "@E 9,999,999"), 10)
			@ nLin, 000 pSay cLinha
			nLin++
			nLin++
			For nXb := 1 to 32
				aTots[nXb] += aItens[nXa][1][nXb]
				aGTots[nXb] += aItens[nXa][1][nXb]
			Next
		endif
	Endif
next nXA

If lImprimiu
	FechLinh(@nLin, aTots, cLinAnt, Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	FechRep(@nLin, aGTots, cLinAnt, Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
Endif

Return nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSomaDia   บAutor  ณWilson Davila       บ Data ณ  16/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Totaliza lancamentos de leite por dia                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10 - Quata                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SomaDia( cMesAno,oObj )

Local nXa		:= 0
Local nPosx		:= 0
Local aTemp 	:= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
Local nPosy		:= 0
Local aPropr 	:= {}
Local nFrete	:= 0

aItens := {}

oObj:SetRegua2( Len(aNotas) )

For nXa := 1 to Len(aNotas)
	
	oObj:IncRegua2("TOTALIZANDO Registros: " + cValToChar(nXa) + " de: " + cValToChar(len(aNotas)) )
	
	nPosx := ascan( aItens, { |x| Alltrim(Upper(x[11]))+Alltrim(Upper(x[15])) == Alltrim(Upper(aNotas[nXa][2]))+Alltrim(Upper(aNotas[nXa][7])) } )
	
	If nPosx == 0  // nICMS, nFrete, nIncent, nFunrural, nST, nFundese
		aadd( aItens, { aClone(aTemp), 0, 0, 0, 0, 0, 0, 0, 0, 0, "", 0, Array(10), "", "" }  )
		nPosx := len(aItens)
	Endif
	
	aItens[nPosx][2] += aNotas[nXa][4]							// Qtd Litros
	aItens[nPosx][4] += aNotas[nXa][6]							// Valor total
	aItens[nPosx][3] := aItens[nPosx][4] / aItens[nPosx][2]   // Valor medio litro
	nPosy := Day(aNotas[nXa][3] )
	aItens[nPosx][1][nposy] += aNotas[nXa][4]
	aItens[nPosx][1][32] += aNotas[nXa][4]
	
	aItens[nPosx][11] := aNotas[nXa][2] 
	aItens[nPosx][15] := aNotas[nXa][7] 
	

	//RecLock("ZZZ",.T.)
	//ZZZ->ZZZ_CONTRA := 'AITENS'
	//ZZZ->ZZZ_REVISA := aItens[nPosx][11]
	//ZZZ->ZZZ_PRE1 	:= aItens[nPosx][15]
	//MsUnlock()

Next nXa

For nXa := 1 to Len(aItens)
	For nXb := 1 to 31
		If nXb <= 15
			nPos := 33
		Else
			nPos := 34
		Endif
		aItens[nXa][1][nPos] += aItens[nXa][1][nXb]
	next nXb

next nXa

Return nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ***** NAO USADO SUBSTITUIDO PELO RunNFET,devido performanceบฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*/
Static Function RunNFE( cMesAno,oObj )

Local cQuery	:= ""
Local nCount	:= 1
Local nRec		:= 0




cQuery := "SELECT PC0_FILIAL, PC0_NUMSEQ, PC0_DTENTR, PC0_TPENTR, PC0_LINROT, PC0_DESCRI, PC0_QTDAPO, PC0_QTDMED, PC0_QTDDIF, "
cQuery += "PC1_FILIAL, PC1_NUMSEQ, PC1_LINHA, PC1_QTDMED, PC1_CARSUB, LBEA.LBE_MOTO AS PC1_DESSUB, PC1_CODPRO, PC1_QTDLIT, "
cQuery += "PC1_LINPRO, PC1_VLRLIT "
cQuery += "FROM "+RetSqlName("PC0")+" PC0 Inner join "+RetSqlName("PC1")+" PC1 ON "
cQuery += "PC1_FILIAL = PC0_FILIAL AND PC1_NUMSEQ = PC0_NUMSEQ "
cQuery += "Inner Join "+RetSqlName("PA7")+" PA7 on "
cQuery += "PA7_FILIAL = '" + xFilial("PA7") + "' and PA7_CODLIN = PC1_LINHA AND PA7.D_E_L_E_T_ = ' ' "
cQuery += "LEFT OUTER Join "+RetSqlName("LBE")+" LBE ON "
cQuery += "LBE.LBE_FILIAL = '" + xFilial("LBE") + "' AND LBE.LBE_CODCAM = PA7_CODCAR AND LBE.D_E_L_E_T_ = ' ' "
cQuery += "Left Outer Join "+RetSqlName("LBE")+" as LBEA ON "
cQuery += "LBEA.LBE_FILIAL = '" + xFilial("LBE") + "' AND LBEA.LBE_CODCAM = PC1_CARSUB AND LBEA.D_E_L_E_T_ = ' ' "
cQuery += "WHERE PC0_FILIAL = '" + xFilial("PC0") + "' "
cQuery += " AND PC0_DTENTR >= '" + Right(cMesAno, 4) + left(cMesAno, 2) + "01' "
cQuery += " AND PC0_DTENTR <= '" + Right(cMesAno, 4) + left(cMesAno, 2) + StrZero(Day(LastDay(ctod("01/"+left(cMesAno,2)+"/"+Right(cMesAno,4)))),2)+ "' "
cQuery += "AND PC1_CODPRO >= '" + MV_PAR03 + "' "	
cQuery += "AND PC1_CODPRO <= '" + MV_PAR04 + "' "	
cQuery += "AND PC1_LINHA >= '" + MV_PAR05 + "' "	
cQuery += "AND PC1_LINHA <= '" + MV_PAR06 + "' "	
cQuery += " AND PC0.PC0_TPENTR = '1' "
cQuery += " AND PC0_QTDAPO > 0 "
cQuery += " AND PC0.D_E_L_E_T_ = ' ' "
cQuery += " AND PC1.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY PC1_CODPRO, PC0_DTENTR "

memowrite("wm001v.sql", cQuery)

cQuery := ChangeQuery( cQuery )

If Select("QRYNFE") > 0
	dbSelectArea("QRYNFE")
	QRYNFE->(dbCloseArea())
EndIf

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYNFE', .F., .T.)

TcSetField( 'QRYNFE', "PC0_DTENTR", "D", 8, 0 )
TcSetField( 'QRYNFE', "PC0_QTDAPO", "N", 12, 2 )
TcSetField( 'QRYNFE', "PC0_QTDMED", "N", 12, 2 )
TcSetField( 'QRYNFE', "PC0_QTDDIF", "N", 12, 2 )
TcSetField( 'QRYNFE', "PC1_QTDMED", "N", 12, 2 )
TcSetField( 'QRYNFE', "PC1_QTDLIT", "N", 12, 2 )
TcSetField( 'QRYNFE', "PC1_VLRLIT", "N", 12, 2 )

aNotas 		:= {}

dbSelectArea("QRYNFE")
dbGotop()

While !Eof()
nRec ++
dbskip()
End While

dbGotop()

oObj:SetRegua1( nRec )

While !Eof()

	
	
	nPos := asCan(aNotas, { |x| x[1] == Alltrim( QRYNFE->PC1_CODPRO ) + Dtos( QRYNFE->PC0_DTENTR ) } )
	If  nPos == 0
		aadd( aNotas, Array(7) )
		nPos := len(aNotas)
		aNotas[nPos, 1] := Alltrim( QRYNFE->PC1_CODPRO ) + Dtos( QRYNFE->PC0_DTENTR )
		aNotas[nPos, 2] := QRYNFE->PC1_CODPRO
		aNotas[nPos, 3] := QRYNFE->PC0_DTENTR
		aNotas[nPos, 4] := QRYNFE->PC1_QTDLIT
		aNotas[nPos, 5] := QRYNFE->PC1_VLRLIT
		aNotas[nPos, 6] := ( QRYNFE->PC1_VLRLIT * QRYNFE->PC1_QTDLIT )
		aNotas[nPos, 7] := QRYNFE->PC1_LINHA
	Else
		aNotas[nPos][4] += QRYNFE->PC1_QTDLIT
		aNotas[nPos][6] +=  ( QRYNFE->PC1_VLRLIT * QRYNFE->PC1_QTDLIT )
		aNotas[nPos][5] := aNotas[nPos][6] / aNotas[nPos][4] //Calcula a media do acumulado
	Endif
	
	QRYNFE->(dbSkip())
    nCount ++

oObj:IncRegua1("CodPro: " + AllTrim(QRYNFE->PC1_CODPRO) + " - Reg: " + cValToChar(nCount) + " de :" + cValtoChar(nRec) )
End

nCount ++

oObj:IncRegua1("CodPro: " + AllTrim(QRYNFE->PC1_CODPRO) + " - Reg: " + cValToChar(nCount) + " de :" + cValtoChar(nRec) )


dbSelectArea("QRYNFE")
dbCloseArea()

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAbreLinh  บAutor  ณMicrosiga           บ Data ณ  16/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao auxiliar para impressao                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10 - Quata                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AbreLinh( nLin, cLinAnt, Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo )

Local aAreaSav	:= GetArea()

dbSelectArea("PA7")
dbSetOrder(1)
dbSeek( xFilial("PA7") + cLinAnt )

If nLin > nLinPag // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

@ nLin, 000 Psay "Linha " + Alltrim(cLinAnt) + " - " + Alltrim( PA7->PA7_DESC )
nLin++

@ nLin, 000 pSay __PrtThinLine()
nLin++

RestArea(aAreaSav)
Return Nil


Static Function FechLinh(nLin, aTots, cLinAnt,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

Local nXa := 0

If aTots[32] <> 0

	If nLin > nLinPag // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif

	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	cLinha := Padr("Total Entrada de Leite da Linha " + cLinAnt, 40)
	cLinha += Padl(Transform(aTots[1], "@E 9,999,999"), 10)
	cLinha += Padl(Transform(aTots[2], "@E 9,999,999"), 10)
	cLinha += Padl(Transform(aTots[3], "@E 9,999,999"), 10)
	cLinha += Padl(Transform(aTots[4], "@E 9,999,999"), 10)
	cLinha += Padl(Transform(aTots[5], "@E 9,999,999"), 10)
	cLinha += Padl(Transform(aTots[6], "@E 9,999,999"), 10)
	cLinha += Padl(Transform(aTots[7], "@E 9,999,999"), 10)
	cLinha += Padl(Transform(aTots[8], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[9], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[10], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[11], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[12], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[13], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[14], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[15], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[16], "@E 9,999,999"), 10)
	@ nLin, 000 pSay cLinha
	nLin++
	lImprimiu := .T.

	If nLin > nLinPag // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif

	cLinha := Padr(" " , 12)
	cLinha += Padr(" " , 28)
	cLinha += padl(Transform(aTots[17], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[18], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[19], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[20], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[21], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[22], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[23], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[24], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[25], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[26], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[27], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[28], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[29], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[30], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[31], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[32], "@E 9,999,999"), 10)
	@ nLin, 000 pSay cLinha
	nLin++

	If nLin > nLinPag // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif

	@ nLin, 000 pSay __PrtFatLine()
	nLin++

Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFechRep   บAutor  ณMicrosiga           บ Data ณ  16/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcoa auxiliar na impressa                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10 - Quata                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FechRep(nLin, aTots, cLinAnt,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

Local nXa := 0

If aTots[32] <> 0

	If nLin > nLinPag // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif

	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	nLin++
	cLinha := Padr("T O T A L == >", 40)
	cLinha += Padl(Transform(aTots[1], "@E 9,999,999"), 10)
	cLinha += Padl(Transform(aTots[2], "@E 9,999,999"), 10)
	cLinha += Padl(Transform(aTots[3], "@E 9,999,999"), 10)
	cLinha += Padl(Transform(aTots[4], "@E 9,999,999"), 10)
	cLinha += Padl(Transform(aTots[5], "@E 9,999,999"), 10)
	cLinha += Padl(Transform(aTots[6], "@E 9,999,999"), 10)
	cLinha += Padl(Transform(aTots[7], "@E 9,999,999"), 10)
	cLinha += Padl(Transform(aTots[8], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[9], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[10], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[11], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[12], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[13], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[14], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[15], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[16], "@E 9,999,999"), 10)
	@ nLin, 000 pSay cLinha
	nLin++
	lImprimiu := .T.

	If nLin > nLinPag // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif

	cLinha := Padr(" " , 12)
	cLinha += Padr(" " , 28)
	cLinha += padl(Transform(aTots[17], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[18], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[19], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[20], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[21], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[22], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[23], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[24], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[25], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[26], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[27], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[28], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[29], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[30], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[31], "@E 9,999,999"), 10)
	cLinha += padl(Transform(aTots[32], "@E 9,999,999"), 10)
	@ nLin, 000 pSay cLinha
	nLin++

	If nLin > nLinPag // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif

	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	//nLin := 100

Endif
Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RunNFET  บ Autor ณ Wilson Davila      บ      ณ  16/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Levantemanto de dados                             	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10 - Quata                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*/
Static Function RunNFET( cMesAno,oObj )

Local cQuery	:= ""
Local nCount	:= 1
Local nRec		:= 0

TCSQLExec("DROP VIEW RUNNFE")

cQuery := "CREATE VIEW RUNNFE AS SELECT PC0_FILIAL, PC0_NUMSEQ, PC0_DTENTR, PC0_TPENTR, PC0_LINROT, PC0_DESCRI, PC0_QTDAPO, PC0_QTDMED, PC0_QTDDIF, "
cQuery += "PC1_FILIAL, PC1_NUMSEQ, PC1_LINHA, PC1_QTDMED, PC1_CARSUB, LBEA.LBE_MOTO AS PC1_DESSUB, PC1_CODPRO, PC1_QTDLIT, "
cQuery += "PC1_LINPRO, PC1_VLRLIT "
cQuery += "FROM "+RetSqlName("PC0")+" PC0 Inner join "+RetSqlName("PC1")+" PC1 ON "
cQuery += "PC1_FILIAL = PC0_FILIAL AND PC1_NUMSEQ = PC0_NUMSEQ "
cQuery += "Inner Join "+RetSqlName("PA7")+" PA7 on "
cQuery += "PA7_FILIAL = '" + xFilial("PA7") + "' and PA7_CODLIN = PC1_LINHA AND PA7.D_E_L_E_T_ = ' ' "
cQuery += "LEFT OUTER Join "+RetSqlName("LBE")+" LBE ON "
cQuery += "LBE.LBE_FILIAL = '" + xFilial("LBE") + "' AND LBE.LBE_CODCAM = PA7_CODCAR AND LBE.D_E_L_E_T_ = ' ' "
cQuery += "Left Outer Join "+RetSqlName("LBE")+" as LBEA ON "
cQuery += "LBEA.LBE_FILIAL = '" + xFilial("LBE") + "' AND LBEA.LBE_CODCAM = PC1_CARSUB AND LBEA.D_E_L_E_T_ = ' ' "
cQuery += "WHERE PC0_FILIAL = '" + xFilial("PC0") + "' "
cQuery += " AND PC0_DTENTR >= '" + Right(cMesAno, 4) + left(cMesAno, 2) + "01' "
cQuery += " AND PC0_DTENTR <= '" + Right(cMesAno, 4) + left(cMesAno, 2) + StrZero(Day(LastDay(ctod("01/"+left(cMesAno,2)+"/"+Right(cMesAno,4)))),2)+ "' "
cQuery += "AND PC1_CODPRO >= '" + MV_PAR03 + "' "	
cQuery += "AND PC1_CODPRO <= '" + MV_PAR04 + "' "	
cQuery += "AND PC1_LINHA >= '" + MV_PAR05 + "' "	
cQuery += "AND PC1_LINHA <= '" + MV_PAR06 + "' "	
cQuery += " AND PC0.PC0_TPENTR = '1' "
cQuery += " AND PC0_QTDAPO > 0 "
cQuery += " AND PC0.D_E_L_E_T_ = ' ' "
cQuery += " AND PC1.D_E_L_E_T_ = ' ' "

TCSQLExec(cQuery)

memowrit("C:\EDI\SQLW.SQL", cQuery)

cQuery := "SELECT PC0_DTENTR,PC1_CODPRO,SUM(PC1_QTDLIT)AS PC1_QTDLIT,AVG(PC1_VLRLIT) AS PC1_VLRLIT,PC1_LINHA"
cQuery += " FROM RUNNFE GROUP BY PC0_DTENTR,PC1_CODPRO,PC1_LINHA ORDER BY CAST(PC1_LINHA AS INT),CAST(PC1_CODPRO AS INT),PC0_DTENTR"

cQuery := ChangeQuery( cQuery )

memowrit("C:\EDI\SQLWa.SQL", cQuery)


If Select("QRYNFE") > 0
	dbSelectArea("QRYNFE")
	QRYNFE->(dbCloseArea())
EndIf

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYNFE', .F., .T.)

TcSetField( 'QRYNFE', "PC0_DTENTR", "D", 8, 0 )
TcSetField( 'QRYNFE', "PC1_QTDLIT", "N", 12, 2 )
TcSetField( 'QRYNFE', "PC1_VLRLIT", "N", 12, 2 )

aNotas 		:= {}

dbSelectArea("QRYNFE")
dbGotop()

While !Eof()
	nRec ++
	dbskip()
End While

dbGotop()

oObj:SetRegua1( nRec )

While QRYNFE->(!Eof())

	oObj:IncRegua1("CodPro: " + AllTrim(QRYNFE->PC1_CODPRO) + " - Reg: " + cValToChar(nCount) + " de :" + cValtoChar(nRec) )
	
		aadd( aNotas, Array(7) )
		nPos := len(aNotas)
		aNotas[nPos, 1] := Alltrim( QRYNFE->PC1_CODPRO ) + Dtos( QRYNFE->PC0_DTENTR )
		aNotas[nPos, 2] := QRYNFE->PC1_CODPRO
		aNotas[nPos, 3] := QRYNFE->PC0_DTENTR
		aNotas[nPos, 4] := QRYNFE->PC1_QTDLIT
		aNotas[nPos, 6] := ( QRYNFE->PC1_VLRLIT * QRYNFE->PC1_QTDLIT )
		aNotas[nPos, 7] := QRYNFE->PC1_LINHA
		aNotas[nPos, 5] := QRYNFE->PC1_VLRLIT 

	//RecLock("ZZZ",.T.)
	//ZZZ->ZZZ_CONTRA := 'ANOTAS'
	//ZZZ->ZZZ_REVISA := aNotas[nPos, 2]
	//ZZZ->ZZZ_PRE1 := aNotas[nPos, 7]
	//MsUnlock()
	
	QRYNFE->(dbSkip())
    
    nCount ++

End

dbSelectArea("QRYNFE")
dbCloseArea()

Return nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณAjustaSX1 ณ Autor ณ  Andreia J Silva      ณ Data ณ30/06/08  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Monta perguntas no SX1.                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*/
Static Function AjustaSx1(cPerg)
cPerg := Left(cPerg,6)

U_PutSx1(cPerg,"01","Entrada De?" ,"","","mv_ch1","D",08,0,0,"G","", "", " ", " ","mv_par01")
U_PutSX1(cPerg,"02","Entrada At้?","","","mv_ch2","D",08,0,0,"G","","","","", "mv_par02")

U_PutSx1(cPerg,"03","Produtor De?" ,"","?","mv_ch3","C",06,0,0,"G","", "LBBCOD", " ", " ","mv_par03")
U_PutSX1(cPerg,"04","Produtor At้?"," ","","mv_ch4","C",06,0,0,"G","","LBBCOD","","", "mv_par04")

U_PutSx1(cPerg,"05","Linha De?" ,"","?","mv_ch5","C",06,0,0,"G","", "PA7", " ", " ","mv_par05")
U_PutSX1(cPerg,"06","Linha At้?"," ","","mv_ch6","C",06,0,0,"G","","PA7","","", "mv_par06")

U_PutSX1(cPerg,"07","Oficial/Lista?"," ","","mv_ch7","N",01,0,0,"C","","","","", "mv_par07","1-Oficial"," "," ","","2-Lista"," "," ")

U_PutSX1(cPerg,"08","Numero Mapa"," ","","mv_ch8","C",06,0,0,"G","","","","", "mv_par08",""," "," ","",""," "," ")
U_PutSX1(cPerg,"09","Release 3"," ","","mv_ch9","N",01,0,0,"C","","","","", "mv_par09","2-Nใo"," "," ","","1-Sim"," "," ")

Return

//------------------------------------------------------------------------------------------------------//
//-- Defini็ใo da estrutura do relat๓rio                                                                //
//------------------------------------------------------------------------------------------------------//
Static Function ReportDef()

LOCAL cPictTit := ""
LOCAL cPictVen := ctod('')
LOCAL nTamVal  
LOCAL nTamData

nTamData := TamSX3("E1_VALOR")[1]
cPictTit := PesqPict("SE1","E1_VALOR")
nTamVal	 := TamSx3("E1_VALOR")[1]
nTamUsu  := 10   					  //-- 29/04/15 
 
oReport := TReport():New("QUAR022A", "Mapa Volume Diแrio de Leite", cPerg, {|oReport| PrintReport(oReport)}, "Imprime Mapa Volume Diแrio de Leite.")

oReport:nFontBody	:= 7.5
oReport:cFontBody	:= "Courier New"

oReport:SetLandScape()  //-- 17/04/15 SetPortrait()
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()
 
oSection1 := TRSection():New( oReport, "Mapa Volume Diแrio de Leite", {"QRY"},, .F., .T.)    //-- 28/04/15  
oSection1:SetHeaderSection(.F.) 
oSection1:SetLinesBefore(0)

TRCell():New( oSection1, "CODIGO"	   , "QRY", 'Codigo' 		    ,"@!"   			, 12 , /*lPixel*/, /*{|| code-block de impressao }*/ ,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "PROPRI"      , "QRY", 'Propriedade'		,"@!"   			, 28 , /*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection1, "DIA01"	   , "QRY", 'DIA 01'     		,"@!"   			, 15  , /*lPixel*/, /*{|| code-block de impressao }*/,"RIGHT",,"RIGHT" )
TRCell():New( oSection1, "DIA02"	   , "QRY", 'DIA 02'     		,"@!"   			, 15  , /*lPixel*/, /*{|| code-block de impressao }*/,"RIGHT",,"RIGHT" )
TRCell():New( oSection1, "DIA03"	   , "QRY", 'DIA 03'     		,"@!"   			, 15  , /*lPixel*/, /*{|| code-block de impressao }*/,"RIGHT",,"RIGHT" )
TRCell():New( oSection1, "DIA04"	   , "QRY", 'DIA 04'     		,"@!"   			, 15  , /*lPixel*/, /*{|| code-block de impressao }*/,"RIGHT",,"RIGHT" )
TRCell():New( oSection1, "DIA05"	   , "QRY", 'DIA 05'     		,"@!"   			, 15  , /*lPixel*/, /*{|| code-block de impressao }*/,"RIGHT",,"RIGHT" )
TRCell():New( oSection1, "DIA06"	   , "QRY", 'DIA 06'     		,"@!"   			, 15  , /*lPixel*/, /*{|| code-block de impressao }*/,"RIGHT",,"RIGHT" )
TRCell():New( oSection1, "DIA07"	   , "QRY", 'DIA 07'     		,"@!"   			, 15  , /*lPixel*/, /*{|| code-block de impressao }*/,"RIGHT",,"RIGHT" )
TRCell():New( oSection1, "DIA08"	   , "QRY", 'DIA 08'     		,"@!"   			, 15  , /*lPixel*/, /*{|| code-block de impressao }*/,"RIGHT",,"RIGHT" )
TRCell():New( oSection1, "DIA09"	   , "QRY", 'DIA 09'     		,"@!"   			, 15  , /*lPixel*/, /*{|| code-block de impressao }*/,"RIGHT",,"RIGHT" )
TRCell():New( oSection1, "DIA10"	   , "QRY", 'DIA 10'     		,"@!"   			, 15  , /*lPixel*/, /*{|| code-block de impressao }*/,"RIGHT",,"RIGHT" )
TRCell():New( oSection1, "DIA11"	   , "QRY", 'DIA 11'     		,"@!"   			, 15  , /*lPixel*/, /*{|| code-block de impressao }*/,"RIGHT",,"RIGHT" )
TRCell():New( oSection1, "DIA12"	   , "QRY", 'DIA 12'     		,"@!"   			, 15  , /*lPixel*/, /*{|| code-block de impressao }*/,"RIGHT",,"RIGHT" )
TRCell():New( oSection1, "DIA13"	   , "QRY", 'DIA 13'     		,"@!"   			, 15  , /*lPixel*/, /*{|| code-block de impressao }*/,"RIGHT",,"RIGHT" )
TRCell():New( oSection1, "DIA14"	   , "QRY", 'DIA 14'     		,"@!"   			, 15  , /*lPixel*/, /*{|| code-block de impressao }*/,"RIGHT",,"RIGHT" )
TRCell():New( oSection1, "DIA15"	   , "QRY", 'DIA 15'     		,"@!"   			, 15  , /*lPixel*/, /*{|| code-block de impressao }*/,"RIGHT",,"RIGHT" )
TRCell():New( oSection1, "DIA16"	   , "QRY", 'DIA 16'     		,"@!"   			, 15  , /*lPixel*/, /*{|| code-block de impressao }*/,"RIGHT",,"RIGHT" )
//-- 28/04/15
oSection2 := TRSection():New( oReport, "Mapa Volume Diแrio de Leite", {"QRY"}, NIL, .F., .T.) 
oSection2:SetHeaderSection(.F.) 
oSection2:SetLinesBefore(0)

TRCell():New( oSection2, "LINHA"	   , "QRY", 'Linha' 		    ,"@!"   			, 12 , /*lPixel*/, /*{|| code-block de impressao }*/ ,"RIGHT",,"RIGHT")
TRCell():New( oSection2, "PROPRI2"     , "QRY", 'Propriedade'		,"@!"   			, 28 , /*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection2, "DIA17"	   , "QRY", 'DIA 17'     		,"@E 999,999,999.99", 15  , /*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection2, "DIA18"	   , "QRY", 'DIA 18'     		,"@E 999,999,999.99", 15  , /*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection2, "DIA19"	   , "QRY", 'DIA 19'     		,"@E 999,999,999.99", 15  , /*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection2, "DIA20"	   , "QRY", 'DIA 20'     		,"@E 999,999,999.99", 15  , /*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection2, "DIA21"	   , "QRY", 'DIA 21'     		,"@E 999,999,999.99", 15  , /*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection2, "DIA22"	   , "QRY", 'DIA 22'     		,"@E 999,999,999.99", 15  , /*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection2, "DIA23"	   , "QRY", 'DIA 23'     		,"@E 999,999,999.99", 15  , /*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection2, "DIA24"	   , "QRY", 'DIA 24'     		,"@E 999,999,999.99", 15  , /*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection2, "DIA25"	   , "QRY", 'DIA 25'     		,"@E 999,999,999.99", 15  , /*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection2, "DIA26"	   , "QRY", 'DIA 26'     		,"@E 999,999,999.99", 15  , /*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection2, "DIA27"	   , "QRY", 'DIA 27'     		,"@E 999,999,999.99", 15  , /*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection2, "DIA28"	   , "QRY", 'DIA 28'     		,"@E 999,999,999.99", 15  , /*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection2, "DIA29"	   , "QRY", 'DIA 29'     		,"@E 999,999,999.99", 15  , /*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection2, "DIA30"	   , "QRY", 'DIA 30'     		,"@E 999,999,999.99", 15  , /*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection2, "DIA31"	   , "QRY", 'DIA 31'     		,"@E 999,999,999.99", 15  , /*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection2, "TOTAL"	   , "QRY", 'Total'     		,"@E 999,999,999.99", 15  , /*lPixel*/, /*{|| code-block de impressao }*/ )

Return (oReport)

Static Function PrintReport(oObj)
 
Local cQuery     := ""

//-- 28/04/15
Local cMesAno	:= DtoS(MV_PAR01)
Local nNumPage	:= 0

Private oSection1 := oReport:Section(1)
Private oSection2 := oReport:Section(2)
Private aNotas 	:= {}
Private aItens 	:= {}
Private oObj

cMesAno := SubStr(cMesAno,5,2)+SubStr(cMesAno,1,4)

oObj := MsNewProcess():New({|| RunNFET( cMesAno,oObj ) },"Mapa do Leite","Processando:. . . ",.T.)
oObj:Activate()

oObj := MsNewProcess():New({|| SomaDia( cMesAno,oObj ) },"Mapa do Leite","Processando:. . . ",.T.)
oObj:Activate()

oReport:SetMeter(Len(aItens))

//-- Inicia as se็๕es
oSection1:Init()
oSection2:init()

//-- 28/04/15, Percorre todos os registros
For nXa := 1 to Len(aItens)

	oReport:IncMeter()
	
    If nNumPage != oReport:Page( )
 		nNumPage := oReport:Page( )
 		xImpCab()
	Endif
	
 	dbSelectArea("LBB")
	dbSetOrder(1)
	
	If dbSeek( xFilial("LBE") + aItens[nXa][11] )
		dbSelectArea("SA2")
		dbSetOrder(1)
		If dbSeek( xFilial("SA2") + LBB->( LBB_CODFOR + LBB_LOJA ) )
		
			oSection1:Cell("CODIGO"):SetBlock({ || Padr(LBB->LBB_CODPRO , 12) })
			oSection1:Cell("PROPRI"):SetBlock({ || Padr(LBB->LBB_NOMFOR , 27) })
			oSection1:Cell("DIA01"):SetBlock({  || Transform(aItens[nXa][1][1], "@E 999,999,999.99") })
			oSection1:Cell("DIA02"):SetBlock({  || Transform(aItens[nXa][1][2], "@E 999,999,999.99") })
			oSection1:Cell("DIA03"):SetBlock({  || Transform(aItens[nXa][1][3], "@E 999,999,999.99") })
			oSection1:Cell("DIA04"):SetBlock({  || Transform(aItens[nXa][1][4], "@E 999,999,999.99") })
			oSection1:Cell("DIA05"):SetBlock({  || Transform(aItens[nXa][1][5], "@E 999,999,999.99") })
			oSection1:Cell("DIA06"):SetBlock({  || Transform(aItens[nXa][1][6], "@E 999,999,999.99") })
			oSection1:Cell("DIA07"):SetBlock({  || Transform(aItens[nXa][1][7], "@E 999,999,999.99") })
			oSection1:Cell("DIA08"):SetBlock({  || Transform(aItens[nXa][1][8], "@E 999,999,999.99") })
			oSection1:Cell("DIA09"):SetBlock({  || Transform(aItens[nXa][1][9], "@E 999,999,999.99") })
			oSection1:Cell("DIA10"):SetBlock({  || Transform(aItens[nXa][1][10], "@E 999,999,999.99") })
			oSection1:Cell("DIA11"):SetBlock({  || Transform(aItens[nXa][1][11], "@E 999,999,999.99") })
			oSection1:Cell("DIA12"):SetBlock({  || Transform(aItens[nXa][1][12], "@E 999,999,999.99") })
			oSection1:Cell("DIA13"):SetBlock({  || Transform(aItens[nXa][1][13], "@E 999,999,999.99") })
			oSection1:Cell("DIA14"):SetBlock({  || Transform(aItens[nXa][1][14], "@E 999,999,999.99") })
			oSection1:Cell("DIA15"):SetBlock({  || Transform(aItens[nXa][1][15], "@E 999,999,999.99") })
			oSection1:Cell("DIA16"):SetBlock({  || Transform(aItens[nXa][1][16], "@E 999,999,999.99") })
			oSection1:Printline()
			
			oSection2:Cell("LINHA"):SetValue(Padr(aItens[nXa][15] , 7))
			oSection2:Cell("PROPRI2"):SetValue(Padr(" " , 33))
			oSection2:Cell("DIA17"):SetValue(aItens[nXa][1][17]) 
			oSection2:Cell("DIA18"):SetValue(aItens[nXa][1][18])
			oSection2:Cell("DIA19"):SetValue(aItens[nXa][1][19])
			oSection2:Cell("DIA20"):SetValue(aItens[nXa][1][20])
			oSection2:Cell("DIA21"):SetValue(aItens[nXa][1][21])
			oSection2:Cell("DIA22"):SetValue(aItens[nXa][1][22])
			oSection2:Cell("DIA23"):SetValue(aItens[nXa][1][23])
			oSection2:Cell("DIA24"):SetValue(aItens[nXa][1][24])
			oSection2:Cell("DIA25"):SetValue(aItens[nXa][1][25])
			oSection2:Cell("DIA26"):SetValue(aItens[nXa][1][26])
			oSection2:Cell("DIA27"):SetValue(aItens[nXa][1][27])
			oSection2:Cell("DIA28"):SetValue(aItens[nXa][1][28])
			oSection2:Cell("DIA29"):SetValue(aItens[nXa][1][29])
			oSection2:Cell("DIA30"):SetValue(aItens[nXa][1][30])
			oSection2:Cell("DIA31"):SetValue(aItens[nXa][1][31])
			oSection2:Cell("TOTAL"):SetValue(aItens[nXa][1][32])
			oSection2:Printline() 
		endif
	Endif
	    //-- 
    
Next
//--

oSection1:Finish()		 
oSection2:Finish()

Return

//Imprime cabe็alho
Static Function xImpCab()

oSection1:Cell("CODIGO"):SetBlock({ || "LINHA" })
oSection1:Cell("PROPRI"):SetBlock({ || "PROPRIEDADE" })
oSection1:Cell("DIA01"):SetBlock({  || "DIA 01" })
oSection1:Cell("DIA02"):SetBlock({  || "DIA 02" })
oSection1:Cell("DIA03"):SetBlock({  || "DIA 03" })
oSection1:Cell("DIA04"):SetBlock({  || "DIA 04" })
oSection1:Cell("DIA05"):SetBlock({  || "DIA 05" })
oSection1:Cell("DIA06"):SetBlock({  || "DIA 06" })
oSection1:Cell("DIA07"):SetBlock({  || "DIA 07" })
oSection1:Cell("DIA08"):SetBlock({  || "DIA 08" })
oSection1:Cell("DIA09"):SetBlock({  || "DIA 09" })
oSection1:Cell("DIA10"):SetBlock({  || "DIA 10" })
oSection1:Cell("DIA11"):SetBlock({  || "DIA 11" })
oSection1:Cell("DIA12"):SetBlock({  || "DIA 12" })
oSection1:Cell("DIA13"):SetBlock({  || "DIA 13" })
oSection1:Cell("DIA14"):SetBlock({  || "DIA 14" })
oSection1:Cell("DIA15"):SetBlock({  || "DIA 15" })
oSection1:Cell("DIA16"):SetBlock({  || "DIA 16" })
oSection1:Printline()

oSection1:Cell("CODIGO"):SetBlock({ || "DIA 17" })
oSection1:Cell("PROPRI"):SetBlock({ || "DIA 18" })
oSection1:Cell("DIA01"):SetBlock({  || "DIA 17" })
oSection1:Cell("DIA02"):SetBlock({  || "DIA 18" })
oSection1:Cell("DIA03"):SetBlock({  || "DIA 19" })
oSection1:Cell("DIA04"):SetBlock({  || "DIA 20" })
oSection1:Cell("DIA05"):SetBlock({  || "DIA 21" })
oSection1:Cell("DIA06"):SetBlock({  || "DIA 22" })
oSection1:Cell("DIA07"):SetBlock({  || "DIA 23" })
oSection1:Cell("DIA08"):SetBlock({  || "DIA 24" })
oSection1:Cell("DIA09"):SetBlock({  || "DIA 25" })
oSection1:Cell("DIA10"):SetBlock({  || "DIA 26" })
oSection1:Cell("DIA11"):SetBlock({  || "DIA 27" })
oSection1:Cell("DIA12"):SetBlock({  || "DIA 28" })
oSection1:Cell("DIA13"):SetBlock({  || "DIA 29" })
oSection1:Cell("DIA14"):SetBlock({  || "DIA 30" })
oSection1:Cell("DIA15"):SetBlock({  || "DIA 31" })
oSection1:Cell("DIA16"):SetBlock({  || "TOTAL" })
oSection1:Printline()

oSection1:Cell("CODIGO"):SetBlock({ || "______" })
oSection1:Cell("PROPRI"):SetBlock({ || "______" })
oSection1:Cell("DIA01"):SetBlock({  || "______" })
oSection1:Cell("DIA02"):SetBlock({  || "______" })
oSection1:Cell("DIA03"):SetBlock({  || "______" })
oSection1:Cell("DIA04"):SetBlock({  || "______" })
oSection1:Cell("DIA05"):SetBlock({  || "______" })
oSection1:Cell("DIA06"):SetBlock({  || "______" })
oSection1:Cell("DIA07"):SetBlock({  || "______" })
oSection1:Cell("DIA08"):SetBlock({  || "______" })
oSection1:Cell("DIA09"):SetBlock({  || "______" })
oSection1:Cell("DIA10"):SetBlock({  || "______" })
oSection1:Cell("DIA11"):SetBlock({  || "______" })
oSection1:Cell("DIA12"):SetBlock({  || "______" })
oSection1:Cell("DIA13"):SetBlock({  || "______" })
oSection1:Cell("DIA14"):SetBlock({  || "______" })
oSection1:Cell("DIA15"):SetBlock({  || "______" })
oSection1:Cell("DIA16"):SetBlock({  || "______" })
oSection1:Printline()
Return