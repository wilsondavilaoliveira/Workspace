#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAR022C  º Autor ³ AP6 IDE            º Data ³  18/08/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function QUAR022C(cMesAno)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3         	:= "Resumo da captação de leite"
Local cPict          	:= ""
Local titulo       		:= "Resumo da captação de leite"
Local nLin         		:= 220

Local Cabec1       		:= " "
Local Cabec2       		:= " "
Local imprime      		:= .F.
Local aOrd 				:= {}
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite          := 220
Private tamanho         := "G"
Private nomeprog        := "QUAR022C" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo           := 18
Private wnrel      		:= "QUAR022C" // Coloque aqui o nome do arquivo usado para impressao em disco
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 1, "", "", 1}
Private nLastKey        := 0
Private cPerg       	:= "QT022C"
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private nLinPag			:= 60
Private cString 		:= "SA1"
Private oProcess	:= NIL

dbSelectArea("SA1")
dbSetOrder(1)


//pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.,,,,,1)

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

//RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,@nLin, cMesAno) },Titulo)

oProcess := MsNewProcess():New({|| RunReport(Cabec1,Cabec2,Titulo,@nLin, cMesAno,oProcess) },Titulo,"Processando:. . . ",.T.)
oProcess:Activate()


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  18/08/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin, cMesAno,oObj)

Local nOrdem

dbSelectArea(cString)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oObj:SetRegua1( 10 )

IF !EMPTY(MV_PAR01)
Titulo := "Dados do Fechamento da Captação de Leite "+ StrZero(month(MV_PAR01),2)+"/"+cValToChar(year(MV_PAR01))+"-"+cValToChar(SM0->M0_FILIAL)
ELSE
Titulo := "Dados do Fechamento da Captação de Leite "
END IF

// Imprime as Notas
//prcNotas(Cabec1,Cabec2,Titulo,@nLin)

// Imprime os pedidos
prcPedid(Cabec1,Cabec2,Titulo,@nLin, cMesAno)
oObj:IncRegua1("IMPRIMINDO PEDIDOS .  .  .")
// Imprime contas a pagar proprietario
prcTPPRO(Cabec1,Cabec2,Titulo,@nLin, cMesAno)
oObj:IncRegua1("IMPRIMINDO CONTAS A PAGAR PRODUTORES .  .  .")
// Imprime contas a pagar carreteiro
prcTPCAM(Cabec1,Cabec2,Titulo,@nLin, cMesAno)
oObj:IncRegua1("IMPRIMINDO CONTAS A PAGAR CARRETEIROS .  .  .")
// Imprime titulos a pagar para fornecedores
prcTPFor(Cabec1,Cabec2,Titulo,@nLin, cMesAno)
oObj:IncRegua1("IMPRIMINDO CONTAS A PAGAR FORNECEDORES .  .  .")
// imprime titulos de abatimento produtores
prcTRPRO(Cabec1,Cabec2,Titulo,@nLin, cMesAno)
oObj:IncRegua1("IMPRIMINDO ABATIMENTOS PRODUTORES .  .  .")
// imprime titulos de abatimento dos carreteiros
prcTRCAM(Cabec1,Cabec2,Titulo,@nLin, cMesAno)
oObj:IncRegua1("IMPRIMINDO ABATIMENTOS CARRETEIROS .  .  .")
// imprime o mapa de leite mensal
prcMPLEI(Cabec1,Cabec2,Titulo,@nLin, cMesAno)
oObj:IncRegua1("IMPRIMINDO MAPA DE LEITE .  .  .")
// imprime os dados das notas fiscais recalculados
prcnota1(Cabec1,Cabec2,Titulo,@nLin, cMesAno)
oObj:IncRegua1("IMPRIMINDO DADOS NOTAS FISCAIS .  .  .")
// imprime a folha de pagamento de leite

prcnota2(Cabec1,Cabec2,Titulo,@nLin, cMesAno)
oObj:IncRegua1("IMPRIMINDO FOLHA PRODUTORES .  .  .")

// imprime a folha de pagamento de Carreteiro
prcnota3(Cabec1,Cabec2,Titulo,nLin, cMesAno)
oObj:IncRegua1("IMPRIMINDO FOLHA CARRETEIROS .  .  .")

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




Static Function prcNotas(Cabec1,Cabec2,Titulo,nLin, cMesAno)

Local nXa	:= 0
Local lImprimiu	:= .F.
Local cMyTitulo := "Notas Fiscais de Entrada de produtores"
Cabec1 := ""
Cabec2 := ""
Cabec1 := Padr("Codigo" , 7)
Cabec1 += Padr("Descricao" , 30)
Cabec1 += Padr("Codigo" , 8)
Cabec1 += Padr("Proprietario" , 30)
Cabec1 += Padr("Data Nota" , 10)
Cabec1 += Padl("Qtd.Lts" , 10)
Cabec1 += Padl("Valor Lt." , 10)
Cabec1 += Padl("Valor Nota" , 14)
cLinCab := Cabec1
Cabec1 := ""

For nXa := 1 to Len(aNotas)

	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If nLin > nLinPag // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
		lImprimiu := .F.
	Endif
	If !lImprimiu
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		@ nLin, 000 pSay cMyTitulo
		nLin++
		@ nLin, 000 pSay __PrtThinLine()
		nLin++

		@ nLin, 000 pSay cLinCab
		nLin++
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		lImprimiu := .T.
	EndIf

	dbSelectArea("SA2")
	dbSetOrder(1)

	dbSelectArea("LBB")
	dbSetOrder(1)

	If dbSeek( xFilial("LBB") + aNotas[nXa][2] )

		dbSelectArea("SA2")
		If dbSeek( xFilial("SA2") + LBB->( LBB_CODFOR + LBB_LOJA ) )
			cLinha := Padr(LBB->LBB_CODPRO , 7)
			cLinha += Padr(LBB->LBB_NOMFOR , 30)
			cLinha += Padr(SA2->A2_COD , 8)
			cLinha += Padr(SA2->A2_NOME , 30)
			cLinha += Padr(dtoc(aNotas[nXA][3]) , 10)
			cLinha += Padl(Transform(aNotas[nXA][4],"@E 999,999.99") , 10)
			cLinha += Padl(Transform(aNotas[nXA][5],"@E 99,999.999") , 10)
			cLinha += Padl(Transform(aNotas[nXA][6],"@E 99,999,999.99") , 14)

			@ nLin, 000 pSay cLinha
			nLin++
			lImprimiu := .T.
		Else
			cLinha := Padr(LBB->LBB_CODPRO , 7)
			cLinha += Padr(LBB->LBB_NOMFOR , 30)
			cLinha += Padr("Nao localizado no cadastro de fornecedores", 38)
			cLinha += Padr(LBB->LBB_CODFOR , 10)
			cLinha += Padl(Transform(aNotas[nXA][4],"@E 999,999.99") , 10)
			cLinha += Padl(Transform(aNotas[nXA][5],"@E 99,999.999") , 10)
			cLinha += Padl(Transform(aNotas[nXA][6],"@E 99,999,999.99") , 14)

			@ nLin, 000 pSay cLinha
			nLin++
		Endif
	Endif
next nXA
If lImprimiu
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	nLin++
Endif
Return Nil



Static Function prcPedid(Cabec1,Cabec2,Titulo,nLin, cMesAno)
Local nXa		:= 0
Local lImprimiu	:= .F.
Local cMyTitulo := "Pedidos de venda para Carreteiros"
Local aTots		:= {}
Cabec1 := ""
Cabec2 := ""
Cabec1 := Padr("Codigo" , 7)
Cabec1 += Padr("Motorista" , 30)
Cabec1 += Padr("Codigo" , 8)
Cabec1 += Padr("Fornecedor" , 40)
Cabec1 += Padl("Qtd.Lts" , 10)
Cabec1 += Padl("Valor Lt." , 10)
Cabec1 += Padl("Valor Nota" , 14)
cLinCab := Cabec1
Cabec1 := ""
aTots := {0, 0}

For nXa := 1 to Len(aPedidos)

	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If nLin > nLinPag // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
		lImprimiu := .F.
	Endif
	If !lImprimiu
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		@ nLin, 000 pSay cMyTitulo
		nLin++
		@ nLin, 000 pSay __PrtThinLine()
		nLin++

		@ nLin, 000 pSay cLinCab
		nLin++
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		lImprimiu := .T.
	EndIf

	dbSelectArea("SA2")
	dbSetOrder(1)

	dbSelectArea("LBE")
	dbSetOrder(2)

	If dbSeek( xFilial("LBE") + aPedidos[nXa][2] )

		dbSelectArea("SA2")
		If dbSeek( xFilial("SA2") + LBE->( LBE_FORNEC + LBE_LOJA ) )
			cLinha := Padr(LBE->LBE_CODCAM , 7)
			cLinha += Padr(LBE->LBE_MOTO , 30)
			cLinha += Padr(SA2->A2_COD , 8)
			cLinha += Padr(SA2->A2_NOME , 40)
			cLinha += Padl(Transform(aPedidos[nXA][4],"@E 999,999.99") , 10)
			cLinha += Padl(Transform(aPedidos[nXA][5],"@E 99,999.999") , 10)
			cLinha += Padl(Transform(aPedidos[nXA][6],"@E 99,999,999.99") , 14)
			aTots[1] += aPedidos[nXA][4]
			aTots[2] += aPedidos[nXA][6]

			@ nLin, 000 pSay cLinha
			nLin++
			lImprimiu := .T.
		Else
			cLinha := Padr(LBE->LBE_CODCAM , 7)
			cLinha += Padr("Nao localizou no cadastro de fornecedores" , 58)
			cLinha += Padr(LBE->( LBE_FORNEC + LBE_LOJA ) , 20)
			cLinha += Padl(Transform(aPedidos[nXA][4],"@E 999,999.99") , 10)
			cLinha += Padl(Transform(aPedidos[nXA][5],"@E 99,999.999") , 10)
			cLinha += Padl(Transform(aPedidos[nXA][6],"@E 99,999,999.99") , 14)

			@ nLin, 000 pSay cLinha
			nLin++
		Endif
	Else
		cLinha := Padr(aPedidos[nXa][2] , 7)
		cLinha += Padr("Nao localizou no cadastro de carreteiros" , 58)
		cLinha += Padr(" " , 20)
		cLinha += Padl(Transform(aPedidos[nXA][4],"@E 999,999.99") , 10)
		cLinha += Padl(Transform(aPedidos[nXA][5],"@E 99,999.999") , 10)
		cLinha += Padl(Transform(aPedidos[nXA][6],"@E 99,999,999.99") , 14)

		@ nLin, 000 pSay cLinha
		nLin++
	Endif
next nXA
If lImprimiu
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	cLinha := Padr(" " , 7)
	cLinha += Padr("Total de pedidos de vendas contra carreteiros" , 30)
	cLinha += Padr(" " , 8)
	cLinha += Padr(" " , 40)
	cLinha += Padl(Transform(aTots[1],"@E 999,999.99") , 10)
	cLinha += Padl(" " , 10)
	cLinha += Padl(Transform(aTots[2],"@E 99,999,999.99") , 14)
	@ nLin, 000 pSay cLinha
	nLin++
	aTots := {}

	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	nLin++

Endif
Return Nil



Static Function prcTPPRO(Cabec1,Cabec2,Titulo,nLin, cMesAno)
Local nXa		:= 0
Local lImprimiu	:= .F.
Local cMyTitulo := "Titulos a pagar para produtores"
Local nTots		:= 0

Cabec1 := ""
Cabec2 := ""
Cabec1 := Padr("Codigo" , 7)
Cabec1 += Padr("Propriedade" , 30)
Cabec1 += Padr("Codigo" , 8)
Cabec1 += Padr("Associado" , 40)
Cabec1 += Padr("Data Venc." , 10)
Cabec1 += Padl("Valor Titulo" , 14)
cLinCab := Cabec1
Cabec1 := ""

For nXa := 1 to Len(aPagar)
	If left(aPagar[nXA][1],1) == "P"

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If nLin > nLinPag // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			lImprimiu := .F.
		Endif
		If !lImprimiu
			@ nLin, 000 pSay __PrtThinLine()
			nLin++
			@ nLin, 000 pSay cMyTitulo
			nLin++
			@ nLin, 000 pSay __PrtThinLine()
			nLin++

			@ nLin, 000 pSay cLinCab
			nLin++
			@ nLin, 000 pSay __PrtThinLine()
			nLin++
			lImprimiu := .T.
		EndIf

		dbSelectArea("SA2")
		dbSetOrder(1)

		dbSelectArea("LBB")
		dbSetOrder(1)

		If dbSeek( xFilial("LBB") + aPagar[nXa][2] )

			dbSelectArea("SA2")
			If dbSeek( xFilial("SA2") + LBB->( LBB_CODFOR + LBB_LOJA ) )
				cLinha := Padr(LBB->LBB_CODPRO , 7)
				cLinha += Padr(LBB->LBB_NOMFOR , 30)
				cLinha += Padr(SA2->A2_COD , 8)
				cLinha += Padr(SA2->A2_NOME , 40)
				cLinha += Padr(dtoc(aPagar[nXA][3]) , 10)
				cLinha += Padl(Transform(aPagar[nXA][6],"@E 99,999,999.99") , 14)

				@ nLin, 000 pSay cLinha
				nLin++
				nTots	+= aPagar[nXA][6]
				lImprimiu := .T.
			Else
				cLinha := Padr(LBB->LBB_CODPRO , 7)
				cLinha += Padr("Não localizou o codigo no cadastro de fornecedores" , 68)
				cLinha += Padr(LBB->( LBB_CODFOR + LBB_LOJA ) , 20)
				cLinha += Padl(Transform(aPagar[nXA][6],"@E 99,999,999.99") , 14)

				@ nLin, 000 pSay cLinha
				nLin++
			Endif
		Else
			cLinha := Padr(aPagar[nXa][2] , 7)
			cLinha += Padr("Não localizou o codigo no cadastro de Propriedades" , 68)
			cLinha += Padr(" " , 20)
			cLinha += Padl(Transform(aPagar[nXA][6],"@E 99,999,999.99") , 14)

			@ nLin, 000 pSay cLinha
			nLin++
		Endif
	Endif
next nXA
If lImprimiu
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	cLinha := Padr(" " , 7)
	cLinha += Padr("Total de titulos a pagar para produtores " , 30)
	cLinha += Padr(" " , 8)
	cLinha += Padr(" " , 40)
	cLinha += Padr(" " , 10)
	cLinha += Padl(Transform(nTots, "@E 99,999,999.99") , 14)

	@ nLin, 000 pSay cLinha
	nLin++
    nTots := 0
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	nLin++
Endif
Return Nil



Static Function prcTPCAM(Cabec1,Cabec2,Titulo,nLin, cMesAno)
Local nXa		:= 0
Local lImprimiu	:= .F.
Local cMyTitulo := "Titulos a pagar para Carreteiros"
Local nTots		:= 0
Cabec1 := ""
Cabec2 := ""
Cabec1 := Padr("Codigo" , 7)
Cabec1 += Padr("Motorista" , 30)
Cabec1 += Padr("Codigo" , 8)
Cabec1 += Padr("Fornecedor" , 30)
Cabec1 += Padr("Data Venc." , 10)
Cabec1 += Padl("Valor Titulo" , 14)
cLinCab := Cabec1
Cabec1 := ""

For nXa := 1 to Len(aPagar)
	If left(aPagar[nXA][1],1) == "C"

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If nLin > nLinPag // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			lImprimiu := .F.
		Endif
		If !lImprimiu
			@ nLin, 000 pSay __PrtThinLine()
			nLin++
			@ nLin, 000 pSay cMyTitulo
			nLin++
			@ nLin, 000 pSay __PrtThinLine()
			nLin++

			@ nLin, 000 pSay cLinCab
			nLin++
			@ nLin, 000 pSay __PrtThinLine()
			nLin++
			lImprimiu := .T.
		EndIf

		dbSelectArea("SA2")
		dbSetOrder(1)

		dbSelectArea("LBE")
		dbSetOrder(2)

		If dbSeek( xFilial("LBE") + aPagar[nXa][2] )

			dbSelectArea("SA2")
			If dbSeek( xFilial("SA2") + LBE->( LBE_FORNEC + LBE_LOJA ) )
				cLinha := Padr(LBE->LBE_CODCAM , 7)
				cLinha += Padr(LBE->LBE_MOTO , 30)
				cLinha += Padr(SA2->A2_COD , 8)
				cLinha += Padr(SA2->A2_NOME , 30)
				cLinha += Padr(space(10) , 10)
				cLinha += Padl(Transform(aPagar[nXA][6],"@E 99,999,999.99") , 14)

				@ nLin, 000 pSay cLinha
				nLin++

				nTots += aPagar[nXA][6]
				lImprimiu := .T.
			Else
				cLinha := Padr(LBE->LBE_CODCAM , 7)
				cLinha += Padr("Não foi impresso pois não localizou o codigo no cadastro de fornecedores!" , 68)
				cLinha += Padr(LBE->LBE_FORNEC , 10)
				cLinha += Padl(Transform(aPagar[nXA][6],"@E 99,999,999.99") , 14)

				@ nLin, 000 pSay cLinha
				nLin++
			Endif
		Else
			cLinha := Padr(aPagar[nXa][2] , 7)
			cLinha += Padr("Não foi impresso pois não localizou o codigo no cadastro de carreteiros!" , 68)
			cLinha += Padr(space(10) , 10)
			cLinha += Padl(Transform(aPagar[nXA][6],"@E 99,999,999.99") , 14)

			@ nLin, 000 pSay cLinha
			nLin++
		Endif
	Endif
next nXA
If lImprimiu
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	cLinha := Padr(" ", 7)
	cLinha += Padr("Total a pagar para carreteiros" , 30)
	cLinha += Padr(" " , 8)
	cLinha += Padr(" " , 30)
	cLinha += Padr(space(10) , 10)
	cLinha += Padl(Transform(nTots, "@E 99,999,999.99") , 14)

	@ nLin, 000 pSay cLinha
	nLin++
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	nLin++
	nTots := 0
Endif
Return Nil



Static Function prcTPFor(Cabec1,Cabec2,Titulo,nLin, cMesAno)
Local nXa		:= 0
Local lImprimiu	:= .F.
Local cMyTitulo := "Titulos a pagar para Fornecedores (Convenios)"
Local nTots		:= 0

Cabec1 := ""
Cabec2 := ""
Cabec1 := Padr("Codigo" , 14)
Cabec1 += Padr("Fornecedor" , 40)
Cabec1 += Padr("Data Venc." , 10)
Cabec1 += Padl("Valor Titulo" , 14)
cLinCab := Cabec1
Cabec1 := ""

For nXa := 1 to Len(aPagar)
	If left(aPagar[nXA][1],1) == "F"

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If nLin > nLinPag // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			lImprimiu := .F.
		Endif
		If !lImprimiu
			@ nLin, 000 pSay __PrtThinLine()
			nLin++
			@ nLin, 000 pSay cMyTitulo
			nLin++
			@ nLin, 000 pSay __PrtThinLine()
			nLin++

			@ nLin, 000 pSay cLinCab
			nLin++
			@ nLin, 000 pSay __PrtThinLine()
			nLin++
			lImprimiu := .T.
		EndIf

		dbSelectArea("SA2")
		dbSetOrder(1)

		If dbSeek( xFilial("SA2") + aPagar[nXa][2] )

			cLinha := Padr(SA2->(A2_COD + A2_LOJA) , 14)
			cLinha += Padr(SA2->A2_NOME , 40)
			cLinha += Padr(space(10) , 10)
			cLinha += Padl(Transform(aPagar[nXA][6],"@E 99,999,999.99") , 14)

			@ nLin, 000 pSay cLinha
			nLin++
			nTots += aPagar[nXA][6]
			lImprimiu := .T.
		Else
			cLinha := Padr(aPagar[nXa][2] , 14)
			cLinha += Padr("Nao localizou no cadastro de fornecedores!", 50)
			cLinha += Padl(Transform(aPagar[nXA][6],"@E 99,999,999.99") , 14)

			@ nLin, 000 pSay cLinha
			nLin++
		Endif
	Endif
next nXA
If lImprimiu
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	cLinha := Padr(" " , 14)
	cLinha += Padr("Total a pagar de convenios" , 40)
	cLinha += Padr(space(10) , 10)
	cLinha += Padl(Transform(nTots,"@E 99,999,999.99") , 14)

	@ nLin, 000 pSay cLinha
	nLin++
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	nLin++
	nTots := 0
Endif
Return Nil




Static Function prcTRPRO(Cabec1,Cabec2,Titulo,nLin, cMesAno)
Local nXa		:= 0
Local lImprimiu	:= .F.
Local cMyTitulo := "Titulos a Descontar de produtores (ref. Convenios)"
Local nTots		:= 0

Cabec1 := ""
Cabec2 := ""
Cabec1 := Padr("Codigo" , 7)
Cabec1 += Padr("Descricao" , 30)
Cabec1 += Padr("Codigo" , 8)
Cabec1 += Padr("Proprietario" , 30)
Cabec1 += Padr("Data Venc." , 10)
Cabec1 += Padl("Valor Titulo" , 14)
cLinCab := Cabec1
Cabec1 := ""

For nXa := 1 to Len(aAbat)
	If left(aAbat[nXA][1],1) == "F"

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If nLin > nLinPag // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			lImprimiu := .F.
		Endif
		If !lImprimiu
			@ nLin, 000 pSay __PrtThinLine()
			nLin++
			@ nLin, 000 pSay cMyTitulo
			nLin++
			@ nLin, 000 pSay __PrtThinLine()
			nLin++

			@ nLin, 000 pSay cLinCab
			nLin++
			@ nLin, 000 pSay __PrtThinLine()
			nLin++
			lImprimiu := .T.
		EndIf

		dbSelectArea("SA2")
		dbSetOrder(1)

		dbSelectArea("LBB")
		dbSetOrder(1)

		If dbSeek( xFilial("LBB") + aAbat[nXa][2] )

			dbSelectArea("SA2")
			If dbSeek( xFilial("SA2") + LBB->( LBB_CODFOR + LBB_LOJA ) )
				cLinha := Padr(LBB->LBB_CODPRO , 7)
				cLinha += Padr(LBB->LBB_NOMFOR , 30)
				cLinha += Padr(SA2->A2_COD , 8)
				cLinha += Padr(SA2->A2_NOME , 30)
				cLinha += Padr(space(10) , 10)
				cLinha += Padl(Transform(aAbat[nXA][6],"@E 99,999,999.99") , 14)

				@ nLin, 000 pSay cLinha
				nLin++
				nTots += aAbat[nXA][6]
				lImprimiu := .T.
			Else
				cLinha := Padr(LBB->LBB_CODPRO , 7)
				cLinha += Padr("Não foi impresso pois não localizou no cadastro de fornecedores!" , 68)
				cLinha += Padr(LBB->LBB_CODFOR , 10)
				cLinha += Padl(Transform(aAbat[nXA][6],"@E 99,999,999.99") , 14)

				@ nLin, 000 pSay cLinha
				nLin++
			Endif
		Else
			cLinha := Padr(aAbat[nXa][2] , 7)
			cLinha += Padr("Não foi impresso pois não localizou no cadastro de Propriedades!" , 68)
			cLinha += Padr(" " , 10)
			cLinha += Padl(Transform(aAbat[nXA][6],"@E 99,999,999.99") , 14)

			@ nLin, 000 pSay cLinha
			nLin++
		Endif
	Endif
next nXA
If lImprimiu
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	cLinha := Padr(" " , 7)
	cLinha += Padr("Total de abatimentos dos produtores (convenios)" , 68)
	cLinha += Padr(space(10) , 10)
	cLinha += Padl(Transform(nTots,"@E 99,999,999.99") , 14)

	@ nLin, 000 pSay cLinha
	nLin++
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	nLin++
	nTots := 0
Endif
Return Nil


Static Function prcTRCAM(Cabec1,Cabec2,Titulo,nLin, cMesAno)
Local nXa		:= 0
Local lImprimiu	:= .F.
Local cMyTitulo := "Abatimentos para Carreteiros (Diferenças de leite)"
Local nTots		:= 0

Cabec1 := ""
Cabec2 := ""
Cabec1 := Padr("Codigo" , 7)
Cabec1 += Padr("Motorista" , 30)
Cabec1 += Padr("Codigo" , 8)
Cabec1 += Padr("Fornecedor" , 40)
Cabec1 += Padl("Valor Nota" , 14)
cLinCab := Cabec1
Cabec1 := ""

For nXa := 1 to Len(aAbat)
	If left(aAbat[nXA][1],1) == "C"

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If nLin > nLinPag // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			lImprimiu := .F.
		Endif
		If !lImprimiu
			@ nLin, 000 pSay __PrtThinLine()
			nLin++
			@ nLin, 000 pSay cMyTitulo
			nLin++
			@ nLin, 000 pSay __PrtThinLine()
			nLin++

			@ nLin, 000 pSay cLinCab
			nLin++
			@ nLin, 000 pSay __PrtThinLine()
			nLin++
			lImprimiu := .T.
		EndIf

		dbSelectArea("SA2")
		dbSetOrder(1)

		dbSelectArea("LBE")
		dbSetOrder(2)

		If dbSeek( xFilial("LBE") + aAbat[nXa][2] )

			dbSelectArea("SA2")
			If dbSeek( xFilial("SA2") + LBE->( LBE_FORNEC + LBE_LOJA ) )
				cLinha := Padr(LBE->LBE_CODCAM , 7)
				cLinha += Padr(LBE->LBE_MOTO , 30)
				cLinha += Padr(SA2->A2_COD , 8)
				cLinha += Padr(SA2->A2_NOME , 40)
				cLinha += Padl(Transform(aAbat[nXA][6],"@E 99,999,999.99") , 14)

				@ nLin, 000 pSay cLinha
				nLin++
				nTots += aAbat[nXA][6]
				lImprimiu := .T.
			Else
				cLinha := Padr(LBE->LBE_CODCAM , 7)
				cLinha += Padr("Não foi impresso pois não localizou no cadastro de Fornecedores!" , 68)
				cLinha += Padr(LBE->LBE_FORNEC , 10)
				cLinha += Padl(Transform(aAbat[nXA][6],"@E 99,999,999.99") , 14)

				@ nLin, 000 pSay cLinha
				nLin++
			Endif
		Else
			cLinha := Padr(aAbat[nXa][2] , 7)
			cLinha += Padr("Não foi impresso pois não localizou no cadastro de carreteiros!" , 68)
			cLinha += Padr(" " , 10)
			cLinha += Padl(Transform(aAbat[nXA][6],"@E 99,999,999.99") , 14)

			@ nLin, 000 pSay cLinha
			nLin++
		Endif
	Endif
next nXA
If lImprimiu
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	cLinha := Padr(" " , 7)
	cLinha += Padr("Total de abatimentos para carreteiros" , 30)
	cLinha += Padr(" " , 8)
	cLinha += Padr(" " , 40)
	cLinha += Padl(Transform(nTots,"@E 99,999,999.99") , 14)

	@ nLin, 000 pSay cLinha
	nLin++
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	nLin++
	nTots := 0
Endif
Return Nil



Static Function prcMPLEI(Cabec1,Cabec2,Titulo,nLin, cMesAno)
Local nXa	:= 0
Local lImprimiu	:= .F.
Local cMyTitulo := "Previa do mapa de leite mensal"
Local cLinCab1	:= ""
Local cLinCab2	:= ""
Local aTots		:= 0
Local nXb		:= 0

aTots := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

//                              1      2  3  4  5  6  7  8  9 10  11 12     13
//		aadd( aItens, { aClone(aTemp), 0, 0, 0, 0, 0, 0, 0, 0, 0, "", 0, Array(10) }  )
/*
aItens[n][1][1] = qtd dia 1
aItens[n][1][2] = qtd dia 2
aItens[n][1][3] = qtd dia 3
...
aItens[n][1][31] = qtd dia 31
aItens[n][1][32] = Total da Propriedade
aItens[n][2] = Volume de leite
aItens[n][3] = Valor Médio combinado
aItens[n][4] = Valor total combinado
aItens[n][5] = Perc. ICMS
aItens[n][6] = Vlr Frete 1
aItens[n][7] = Perc. Incentivo
aItens[n][8] = Perc.Funrural
aItens[n][9] = Perc. ST
aItens[n][10] = Perc.Fundese
aItens[n][11] = Cod.Propriedade
aItens[n][12] = Vlr. Frete 2
aItens[n][13][1] = nTotal
aItens[n][13][2] = nBruto
aItens[n][13][3] = nValICMS
aItens[n][13][4] = nFrete
aItens[n][13][5] = nValIncent
aItens[n][13][6] = nValFunrural
aItens[n][13][7] = nValST
aItens[n][13][8] = nValFundese
aItens[n][13][9] = nValST1
aItens[n][13][10] = nValNovo
aItens[n][14]	= TES
*/

Cabec1 := ""
Cabec2 := ""
Cabec1 := Padr("Codigo" , 12)
Cabec1 += Padr("Propriedade" , 28)
Cabec1 += Padl("Dia 1" , 10)
Cabec1 += Padl("Dia 2" , 10)
Cabec1 += Padl("Dia 3" , 10)
Cabec1 += Padl("Dia 4" , 10)
Cabec1 += Padl("Dia 5" , 10)
Cabec1 += Padl("Dia 6" , 10)
Cabec1 += Padl("Dia 7" , 10)
Cabec1 += Padl("Dia 8" , 10)
Cabec1 += Padl("Dia 9" , 10)
Cabec1 += Padl("Dia 10" , 10)
Cabec1 += Padl("Dia 11" , 10)
Cabec1 += Padl("Dia 12" , 10)
Cabec1 += Padl("Dia 13" , 10)
Cabec1 += Padl("Dia 14" , 10)
Cabec1 += Padl("Dia 15" , 10)
Cabec1 += Padl("Dia 16" , 10)
cLinCab1 := Cabec1
Cabec1 := ""
Cabec1 := Padr(" " , 12)
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

For nXa := 1 to Len(aItens)

	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If nLin > nLinPag // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
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
		@ nLin, 000 pSay cLinCab2
		nLin++
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		lImprimiu := .T.
	EndIf


	dbSelectArea("LBB")
	dbSetOrder(1)

	If dbSeek( xFilial("LBE") + aItens[nXa][11] )
		dbSelectArea("SA2")
		dbSetOrder(1)
		If dbSeek( xFilial("SA2") + LBB->( LBB_CODFOR + LBB_LOJA ) )

			cLinha := Padr(SA2->A2_COD + " " + SA2->A2_LOJA , 12)
			cLinha += Padr(SA2->A2_NOME , 27) + " "
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

			cLinha := Padr(" " , 7)
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
			Next
		endif
	Endif
next nXA
If lImprimiu
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	cLinha := Padr("Total de entrada de leite por dia", 40)
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

	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	nLin++
Endif
Return nil



Static Function prcnota1(Cabec1,Cabec2,Titulo,nLin, cMesAno)
Local nXa	:= 0
Local lImprimiu	:= .F.
Local cMyTitulo := "Previsão de emissão de notas fiscais por propriedade"
Local cLinCab1	:= ""
Local cLinCab2	:= ""
Local cLinCab3	:= ""
Local cLinCab0	:= ""
Local nXb		:= 0
Local aTots		:= array(2,12)

//                              1      2  3  4  5  6  7  8  9 10  11 12     13
//		aadd( aItens, { aClone(aTemp), 0, 0, 0, 0, 0, 0, 0, 0, 0, "", 0, Array(10) }  )
/*
aItens[n][1][1] = qtd dia 1
aItens[n][1][2] = qtd dia 2
aItens[n][1][3] = qtd dia 3
...
aItens[n][1][31] = qtd dia 31
aItens[n][1][32] = Total da Propriedade
aItens[n][2] = Volume de leite
aItens[n][3] = Valor Médio combinado
aItens[n][4] = Valor total combinado
aItens[n][5] = Perc. ICMS
aItens[n][6] = Vlr Frete 1
aItens[n][7] = Perc. Incentivo
aItens[n][8] = Perc.Funrural
aItens[n][9] = Perc. ST
aItens[n][10] = Perc.Fundese
aItens[n][11] = Cod.Propriedade
aItens[n][12] = Vlr. Frete 2
aItens[n][13][1] = nTotal
aItens[n][13][2] = nBruto
aItens[n][13][3] = nValICMS
aItens[n][13][4] = nFrete
aItens[n][13][5] = nValIncent
aItens[n][13][6] = nValFunrural
aItens[n][13][7] = nValST
aItens[n][13][8] = nValFundese
aItens[n][13][9] = nValST1
aItens[n][13][10] = nValNovo
aItens[n][14] = Codigo TES
*/
For nXa := 1 to 2
	For nXb := 1 to 12
		aTots[nXa][nXB] := 0
	Next nXb
next nXa

Cabec1 := ""
Cabec2 := ""

Cabec1 := ""
Cabec1 := Padr("Codigo" , 12)
Cabec1 += PadR("Fornecedor" , 30)
Cabec1 += Padl("Volume" , 12)
Cabec1 += Padl("Vl.Lts" , 12)
Cabec1 += Padl("Total" , 16)
Cabec1 += Padl("Tot.Liquido" , 20)
Cabec1 += Padl("" , 10)
Cabec1 += Padl("Volume" , 12)
Cabec1 += Padl("Vl.Lts" , 12)
Cabec1 += Padl("Total" , 16)
Cabec1 += Padl("Tot.Liquido" , 20)
cLinCab0 := Cabec1
Cabec1 := ""
Cabec1 := Padr(" " , 42)
Cabec1 += Padl("Frete" , 10)
Cabec1 += Padl("ICMS" , 10)
Cabec1 += Padl("Incent." , 10)
Cabec1 += Padl("Funrural" , 10)
Cabec1 += Padl("ST" , 10)
Cabec1 += Padl("Fundese" , 10)
Cabec1 += Padl("" , 10)
Cabec1 += Padl("Frete" , 10)
Cabec1 += Padl("ICMS" , 10)
Cabec1 += Padl("Incent." , 10)
Cabec1 += Padl("Funrural" , 10)
Cabec1 += Padl("ST" , 10)
Cabec1 += Padl("Fundese" , 10)
cLinCab1 := Cabec1
Cabec1 := ""


Cabec1 := ""
Cabec1 := Padr("PROPRIEDADE" , 42)
Cabec1 += PadC("Valor Combinado com o produtor" , 60)
Cabec1 += Padl("" , 10)
Cabec1 += PadC("Valor Calculado com os impostos" , 60)
cLinCab2 := Cabec1
Cabec1 := ""

For nXa := 1 to Len(aItens)

	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If nLin > nLinPag // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
		lImprimiu := .F.
	Endif
	If !lImprimiu
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		@ nLin, 000 pSay cMyTitulo
		nLin++
		@ nLin, 000 pSay __PrtThinLine()
		nLin++

		@ nLin, 000 pSay cLinCab2
		nLin++
		@ nLin, 000 pSay __PrtThinLine()
		nLin++
		lImprimiu := .T.
	EndIf


	dbSelectArea("LBB")
	dbSetOrder(1)

	If dbSeek( xFilial("LBE") + aItens[nXa][11] )
		dbSelectArea("SA2")
		dbSetOrder(1)
		If dbSeek( xFilial("SA2") + LBB->( LBB_CODFOR + LBB_LOJA ) )

			nIcms 	:= Round((aItens[nXa][4] * (aItens[nXa][5] / 100)),2)
			nIncent := Round((aItens[nXa][4] * (aItens[nXa][7] / 100)),2)
			nFunrur := Round(((aItens[nXa][4] + nIncent) * (aItens[nXa][8] / 100)),2) //alterado wilson 13-02-09
			//nFunrur := Round((aItens[nXa][4] * (aItens[nXa][8] / 100)),2) //alterar
			nSt		:= Round((nIcms * (aItens[nXa][9] / 100)),2)
			NFundese:= Round((nSt * (aItens[nXa][10] / 100)),2)
			nLiquid1:=Round((aItens[nXa][4] + nIncent - nFunrur - nSt )  , 2)
			nLiquid2:= Round( (aItens[nXa][13][2] - aItens[nXa][13][4] + aItens[nXa][13][5] - aItens[nXa][13][6] - aItens[nXa][13][7]), 2)


			@ nLin, 000 pSay cLinCab0
			nLin ++

			cLinha := PadR(SA2->A2_COD, 7)
			cLinha += PadR(SA2->A2_LOJA, 5)
			cLinha += PadR(SA2->A2_NOME, 29) + " "
			cLinha += padl(Transform(aItens[nXa][2], "@E 999,999.99"), 12)
			cLinha += padl(Transform(aItens[nXa][3], "@E 99,999.9999"), 12)
			cLinha += padl(Transform(aItens[nXa][4], "@E 999,999,999.99"), 16)
			cLinha += padl(Transform(nLiquid1, "@E 999,999,999.99"), 20)
			cLinha += padl("", 10)
			cLinha += padl(Transform(aItens[nXa][2], "@E 999,999.99"), 12)
			cLinha += padl(Transform(aItens[nXa][13][10], "@E 99,999.9999"), 12)
			cLinha += padl(Transform(aItens[nXa][13][2], "@E 999,999,999.99"), 16)
			cLinha += padl(Transform(nLiquid2, "@E 999,999,999.99"), 20)
			@ nLin, 000 pSay cLinha
			nLin++

			aTots[1][1] += aItens[nXa][2]
			aTots[1][3] += aItens[nXa][4]
			aTots[1][4] += nLiquid1
			aTots[1][7] += aItens[nXa][2]
			aTots[1][9] += aItens[nXa][13][2]
			aTots[1][10] += nLiquid2

			@ nLin, 000 pSay cLinCab1
			nLin ++

			cLinha := padr(aItens[nXa][11] + " " + LBB->LBB_NOMFOR, 42)
			cLinha += padl(Transform(0, "@E 999,999.99"), 10)
			cLinha += padl(Transform(nIcms, "@E 999,999.99"), 10)
			cLinha += padl(Transform(nIncent, "@E 999,999.99"), 10)
			cLinha += padl(Transform(nFunRur, "@E 999,999.99"), 10)
			cLinha += padl(Transform(nSt, "@E 999,999.99"), 10)
			cLinha += padl(Transform(nFundese, "@E 999,999.99"), 10)
			cLinha += padl("", 10)
			cLinha += padl(Transform(aItens[nXa][13][4], "@E 999,999.99"), 10)
			cLinha += padl(Transform(aItens[nXa][13][3], "@E 999,999.99"), 10)
			cLinha += padl(Transform(aItens[nXa][13][5], "@E 999,999.99"), 10)
			cLinha += padl(Transform(aItens[nXa][13][6], "@E 999,999.99"), 10)
			cLinha += padl(Transform(aItens[nXa][13][7], "@E 999,999.99"), 10)
			cLinha += padl(Transform(aItens[nXa][13][8], "@E 999,999.99"), 10)
			@ nLin, 000 pSay cLinha
			nLin++

			@ nLin, 000 pSay __PrtThinLine()
			nLin++

			aTots[2][1] += 0            		//Frete
			aTots[2][2] += nIcms                //ICMS
			aTots[2][3] += nIncent              //Incent
			aTots[2][4] += nFunRur              //Funrural
			aTots[2][5] += nSt                  //Subst.trib
			aTots[2][6] += nFundese             //Fundese
			aTots[2][7] += aItens[nXa][13][4]	//Frete
			aTots[2][8] += aItens[nXa][13][3]   //ICMS
			aTots[2][9] += aItens[nXa][13][5]   //Incent
			aTots[2][10] += aItens[nXa][13][6]  //Funrural
			aTots[2][11] += aItens[nXa][13][7]  //Subst.Trib
			aTots[2][12] += aItens[nXa][13][8]  //Fundese

		Endif
	Endif
next nXA
If lImprimiu
	@ nLin, 000 pSay __PrtThinLine()
	nLin++

	@ nLin, 000 pSay cLinCab0
	nLin ++

	cLinha := padr("Totais gerais para todas as notas", 41)
	cLinha += padl(Transform(aTots[1][1], "@E 99,999,999"), 13)
	cLinha += padl(Transform(aTots[1][3] / aTots[1][1], "@E 99,999.9999"), 12)
	cLinha += padl(Transform(aTots[1][3], "@E 999,999,999.99"), 16)
	cLinha += padl(Transform(aTots[1][4], "@E 999,999,999.99"), 20)
	cLinha += padl("", 10)
	cLinha += padl(Transform(aTots[1][7], "@E 99,999,999"), 12)
	cLinha += padl(Transform(aTots[1][9] / aTots[1][7], "@E 99,999.9999"), 12)
	cLinha += padl(Transform(aTots[1][9], "@E 999,999,999.99"), 16)
	cLinha += padl(Transform(aTots[1][10], "@E 999,999,999.99"), 20)
	@ nLin, 000 pSay cLinha
	nLin++

	@ nLin, 000 pSay cLinCab1
	nLin ++

	cLinha := padr("", 41)
	cLinha += padl(Transform(aTots[2][1], "@E 999,999.99"), 10)
	cLinha += padl(Transform(aTots[2][2], "@E 999,999.99"), 10)
	cLinha += padl(Transform(aTots[2][3], "@E 999,999.99"), 10)
	cLinha += padl(Transform(aTots[2][4], "@E 999,999.99"), 10)
	cLinha += padl(Transform(aTots[2][5], "@E 999,999.99"), 10)
	cLinha += padl(Transform(aTots[2][6], "@E 999,999.99"), 10)
	cLinha += padl("", 10)
	cLinha += padl(Transform(aTots[2][7], "@E 999,999.99"), 10)
	cLinha += padl(Transform(aTots[2][8], "@E 999,999.99"), 10)
	cLinha += padl(Transform(aTots[2][9], "@E 999,999.99"), 10)
	cLinha += padl(Transform(aTots[2][10], "@E 999,999.99"), 10)
	cLinha += padl(Transform(aTots[2][11], "@E 999,999.99"), 10)
	cLinha += padl(Transform(aTots[2][12], "@E 999,999.99"), 10)
	@ nLin, 000 pSay cLinha
	nLin++
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	nLin++
Endif

Return nil


Static Function prcnota2(Cabec1,Cabec2,Titulo,nLin, cMesAno)

Local nXa	:= 0
Local lImprimiu	:= .F.
Local cMyTitulo := "Folha de pagamento de Leite"
Local cLinCab1	:= ""
Local cLinCab2	:= ""
Local cLinCab3	:= ""
Local cLinCab0	:= ""
Local nXb		:= 0
Local aTots		:= array(15)

For nXb := 1 to 15
	aTots[nXB] := 0
Next nXb

Cabec1 := ""
Cabec2 := ""

Cabec1 := ""
Cabec1 += Padr("CodPro" , 7)
Cabec1 += Padr("CodFor" , 7)
Cabec1 += Padr("Loja" , 5)
Cabec1 += Padr("Fornecedor" , 30)
Cabec1 += PadL("Volume" , 15)
Cabec1 += PadL("Vlr.Comb." , 11)
Cabec1 += PadL("Tot.Combin." , 14)
Cabec1 += PadL("Vlr.Nota" , 11)
Cabec1 += PadL("Tot.Nota" , 14)
Cabec1 += Padl("Incent." , 11)
Cabec1 += Padl("Tot.+Incent." , 14)
Cabec1 += Padl("Vlr.Final" , 11)
Cabec1 += Padl("Frete" , 8)
Cabec1 += Padl("Funrural" , 12)
//Cabec1 += Padl("Subs.Trib." , 12)
//Cabec1 += Padl("Fundese" , 10)
Cabec1 += Padl("Convenio" , 12)
Cabec1 += Padl("Emprestimo" , 12)
Cabec1 += Padl("Vlr.Liquido" , 14)
cLinCab1 := Cabec1
Cabec1 := ""

For nXa := 1 to Len(aItens)

	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If nLin > nLinPag // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
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


	dbSelectArea("LBB")
	dbSetOrder(1)

	If dbSeek( xFilial("LBE") + aItens[nXa][11] )
		dbSelectArea("SA2")
		dbSetOrder(1)
		If dbSeek( xFilial("SA2") + LBB->( LBB_CODFOR + LBB_LOJA ) )

			nConvenio := 0
			nAdto     := 0
            nPosq := ascan(aAbat, {|x| Alltrim(UPPER(x[1])) == Alltrim(UPPER("F" + LBB->LBB_CODPRO)) } )
			If nPosq > 0
				nConvenio := aAbat[nPosq][6]-aAbat[nPosq][7]
                nAdto     := aAbat[nPosq][7]
            Endif
			//				Valor nota              Incentivo
			nLiquid2 :=  (aItens[nXa][13][2]  + aItens[nXa][13][5] )
			//			 Liquido   -  Frete            - ICMS               -  Funrural          -  ST                - Convenios - Fundese
//			nLiquid2 :=  nLiquid2 - aItens[nXa][13][4] - aItens[nXa][13][3] - aItens[nXa][13][6] - aItens[nXa][13][7] - nConvenio - aItens[nXa][13][8]

			//			 Liquido   -  Frete            -  Funrural          -  ST                - Convenios - Fundese
//			nLiquid2 :=  nLiquid2 - aItens[nXa][13][4] - aItens[nXa][13][6] - aItens[nXa][13][7] - nConvenio - aItens[nXa][13][8]

			//			 Liquido   -  Frete            -  Funrural          -  ST                - Convenios
			nLiquid2 :=  nLiquid2 - aItens[nXa][13][4] - aItens[nXa][13][6] - aItens[nXa][13][7] - (nConvenio+nAdto)

			//cLinha := Padr(SA2->A2_COD+" "+SA2->A2_LOJA , 12)        				//codigo+Loja
			cLinha := Padr(LBB->(LBB_CODPRO) , 7)
            cLinha += Padr(LBB->(LBB_CODFOR) , 7)
            cLinha += Padr(LBB->(LBB_LOJA) , 5)
            cLinha += Padr(SA2->A2_NOME , 29) + " "									//Nome
			cLinha += padl(Transform(aItens[nXa][2], "@E 999,999,999.99"), 15)		//Volume
			cLinha += padl(Transform(aItens[nXa][3], "@E 9,999.9999"), 11)         //Combinado
			cLinha += padl(Transform(aItens[nXa][4], "@E 9,999,999.99"), 14)        //Total Combinado
			cLinha += padl(Transform(aItens[nXa][13][10], "@E 9,999.9999"), 11)    //Valor Nota
			cLinha += padl(Transform(aItens[nXa][13][2], "@E 9,999,999.99"), 14)    //Total Nota
			cLinha += padl(Transform(aItens[nXa][13][5], "@E 99,999.99"), 11)      //Incentivo
			cLinha += padl(Transform(aItens[nXa][13][5]+aItens[nXa][13][2], "@E 9,999,999.99"), 14)      //Nota + Incentivo
			cLinha += padl(Transform((aItens[nXa][13][5]+aItens[nXa][13][2])/aItens[nXa][2], "@E 9,999.9999"), 11)      //Valor nota
			cLinha += padl(Transform(aItens[nXa][13][4], "@E 999.99"), 8)      //Frete
			cLinha += padl(Transform(aItens[nXa][13][6], "@E 999,999.99"), 12)      //Funrural
			//cLinha += padl(Transform(aItens[nXa][13][7], "@E 99,999.99"), 12)      //ST
			//cLinha += padl(Transform(aItens[nXa][13][8], "@E 99,999.99"), 10)      //Fundese

            cLinha += padl(Transform(nConvenio, "@E 9,999,999.99"), 12)               //Convenio
			cLinha += padl(Transform(nAdto, "@E 9,999,999.99"), 12)

            cLinha += padl(Transform(nLiquid2, "@E 9,999,999.99"), 14)              //Vlr.Liquido
//			cLinha += padr(aItens[nXa][15], 6)              //Vlr.Liquido

			@ nLin, 000 pSay cLinha
			nLin++
			lImprimiu := .T.

			aTots[1] += aItens[nXa][2]
			aTots[2] += 0
			aTots[3] += aItens[nXa][4]
			aTots[4] += 0
			aTots[5] += aItens[nXa][13][2]
			aTots[6] += aItens[nXa][13][5]
			aTots[7] += aItens[nXa][13][5]+aItens[nXa][13][2]
			aTots[8] += 0
			aTots[9] += aItens[nXa][13][4]
			aTots[10] += aItens[nXa][13][6]
			aTots[11] += aItens[nXa][13][7]
			aTots[12] += aItens[nXa][13][8]
		 	aTots[13] += nConvenio
            aTots[14] += nAdto
            aTots[15] += nLiquid2

		Endif
	Endif
next nXA
If lImprimiu
	aTots[2] := aTots[3]/aTots[1]
	aTots[4] := aTots[5]/aTots[1]
	aTots[8] += aTots[7]/aTots[1]

	@ nLin, 000 pSay __PrtThinLine()
	nLin++

	cLinha := Padr("Totais" , 7)
	cLinha += Padr("da Folha de pagamento leite" , 27+12)

    cLinha += padl(Transform(aTots[1], "@E 999,999,999.99"), 18)
	cLinha += padl(Transform(aTots[2], "@E 9,999.9999"), 11)
	cLinha += padl(Transform(aTots[3], "@E 9,999,999.99"), 14)
	cLinha += padl(Transform(aTots[4], "@E 9,999.9999"), 11)
	cLinha += padl(Transform(aTots[5], "@E 9,999,999.99"), 14)
	cLinha += padl(Transform(aTots[6], "@E 999,999.99"), 11)
	cLinha += padl(Transform(aTots[7], "@E 9,999,999.99"), 14)
	cLinha += padl(Transform(aTots[8], "@E 9,999.9999"), 11)
	cLinha += padl(Transform(aTots[9], "@E 999.99"), 8)
	cLinha += padl(Transform(aTots[10], "@E 999,999.99"), 12)
	//cLinha += padl(Transform(aTots[11], "@E 99,999.99"), 12)
	//cLinha += padl(Transform(aTots[12], "@E 99,999.99"), 12)
	cLinha += padl(Transform(aTots[13], "@E 9,999,999.99"), 12)
	cLinha += padl(Transform(aTots[14], "@E 9,999,999.99"), 12)
	cLinha += padl(Transform(aTots[15], "@E 9,999,999.99"), 14)

    @ nLin, 000 pSay cLinha
	nLin++
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	nLin++
Endif

Return nil



Static Function prcnota3(Cabec1,Cabec2,Titulo,nLin, cMesAno)

Local nXa	:= 0
Local lImprimiu	:= .F.
Local cMyTitulo := "Folha de pagamento de Carreteiros"
Local cLinCab1	:= ""
Local cLinCab2	:= ""
Local cLinCab3	:= ""
Local cLinCab0	:= ""
Local nXb		:= 0
Local aTots		:= array(13)

For nXb := 1 to 13
	aTots[nXB] := 0
Next nXb

Cabec1 := ""
Cabec2 := ""

Cabec1 := ""
Cabec1 := Padr("Codigo" , 12)
Cabec1 += Padr("Fornecedor" , 30)
Cabec1 += PadL("Volume" , 15)
Cabec1 += PadL("Total Kms" , 12)
Cabec1 += PadL("Valor Frete" , 14)
Cabec1 += PadL("Abatimentos" , 12)
Cabec1 += PadL("Convenios" , 14)
Cabec1 += Padl("Vlr.Liquido" , 14)
cLinCab1 := Cabec1
Cabec1 := ""


For nXa := 1 to Len(aPagar)
	If left(aPagar[nXA][1],1) == "C"

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If nLin > nLinPag // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
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

		dbSelectArea("SA2")
		dbSetOrder(1)

		dbSelectArea("LBE")
		dbSetOrder(2)

		If dbSeek( xFilial("LBE") + aPagar[nXa][2] )

			dbSelectArea("SA2")
			If dbSeek( xFilial("SA2") + LBE->( LBE_FORNEC + LBE_LOJA ) )

				nAbatimentos := 0
				nPosq := ascan(aAbat, {|x| Alltrim(UPPER(x[1])) == Alltrim(UPPER("C" + aPagar[nXa][2])) } )
				If nPosq > 0
					nAbatimentos := aAbat[nPosq][6]
				Endif

				nConvenio := 0

                dbSelectArea("LBB")
                dbSetOrder(2)
                If dbSeek( xFilial("LBB") + SA2->A2_COD + SA2->A2_LOJA )
					nPosq := ascan(aAbat, {|x| Alltrim(UPPER(x[1])) == Alltrim(UPPER("F" + LBB->LBB_CODPRO)) } )
					If nPosq > 0
						nConvenio := aAbat[nPosq][6]
					Endif
				Endif

				nLiquid2 :=  aPagar[nXA][6]
				//
				nLiquid2 :=  nLiquid2 - nConvenio - nAbatimentos

				cLinha := Padr(SA2->A2_COD + " " + SA2->A2_LOJA , 12)
				cLinha += Padr(SA2->A2_NOME , 29) + " "
				cLinha += Padl(Transform(aPagar[nXA][4],"@E 999,999,999.99") , 15)	//volume
				cLinha += Padl(Transform(aPagar[nXA][3],"@E 999,999.99") , 12)	// Total Kms
				cLinha += Padl(Transform(aPagar[nXA][6],"@E 99,999,999.99") , 14)	// Valor Frete
				cLinha += Padl(Transform(nAbatimentos,"@E 99,999,999.99") , 12)		// Abatimentos
				cLinha += Padl(Transform(nConvenio,"@E 99,999,999.99") , 14)		// Convenios
				cLinha += Padl(Transform(nLiquid2,"@E 99,999,999.99") , 14)			// Liquido

				@ nLin, 000 pSay cLinha
				nLin++

				aTots[1] += aPagar[nXA][4]
				aTots[2] += aPagar[nXA][3]
				aTots[3] += aPagar[nXA][6]
				aTots[4] += nAbatimentos
				aTots[5] += nConvenio
				aTots[6] += nLiquid2

				lImprimiu := .T.
			Endif
		Endif
	Endif
next nXA

If lImprimiu

	@ nLin, 000 pSay __PrtThinLine()
	nLin++

	cLinha := Padr("Totais" , 7)
	cLinha += Padr("da Folha de pagamento Carreteiros" , 35)
	cLinha += padl(Transform(aTots[1], "@E 999,999,999.99"), 15)
	cLinha += padl(Transform(aTots[2], "@E 999,999.99"), 12)
	cLinha += padl(Transform(aTots[3], "@E 99,999,999.99"), 14)
	cLinha += padl(Transform(aTots[4], "@E 99,999,999.99"), 12)
	cLinha += padl(Transform(aTots[5], "@E 99,999,999.99"), 14)
	cLinha += padl(Transform(aTots[6], "@E 99,999,999.99"), 14)
	@ nLin, 000 pSay cLinha
	nLin++

	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	nLin++
Endif

Return nil
