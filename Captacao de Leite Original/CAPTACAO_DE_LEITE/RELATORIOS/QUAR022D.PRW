#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAR022D  º Autor ³ Wilson Davila      º Data ³  01/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio Folha de Pagamento Carreteiros                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - Quata                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function QUAR022D()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Folha de Pagamento Carreteiros"
Local cPict          := ""
Local titulo       := "Folha de Pagamento Carreteiros"
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "M"
Private nomeprog         := "QUAR022D"
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "QUAR022D"
Private cPerg	   := "QUAR022D"

Private cString := ""

AjustaSx1(cPerg)

If Pergunte(cPerg,.T.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	RunQuery()
	
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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  01/12/09   º±±
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

Local lImprimiu	:= .F.
Local cMyTitulo := "Folha de pagamento de Carreteiros"
Local cLinCab1	:= ""
Local cLinCab2	:= ""
Local cLinCab3	:= ""
Local cLinCab0	:= ""
Local nRec		:= 0
Local nTot		:= 0
Local nTot1		:= 0
Local nTot2		:= 0
Local nTot3		:= 0
Local nTot4		:= 0
Local nTot5		:= 0
Local nTot6		:= 0
Local cCodPro	:= ''

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

While QRYNFE->( !EOF() )
nRec ++
QRYNFE->( dbSkip() )
End While

QRYNFE->( dbGoTop() )

SetRegua(nRec)

nRec := 0

Titulo := "Folha de Pagamento Carreteiros "+ StrZero(month(MV_PAR01),2)+"/"+cValToChar(year(MV_PAR01))+"-"+cValToChar(SM0->M0_FILIAL)
While QRYNFE->( !EOF() )

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

				
                LBB->(dbSetOrder(2))
                LBB->( dbSeek( xFilial("LBB") + QRYNFE->FORN + QRYNFE->LOJA ) )
				cCodPro := LBB->LBB_CODPRO
				
				nAbatimentos 	:= RunAbat() 
				nConvenio 		:= RunConv(cCodPro)
				nLiquid2 		:= QRYNFE->FRETE
				nLiquid2 		:= nLiquid2 - nConvenio - nAbatimentos
	
				cLinha := Padr(QRYNFE->CODCAM + " " + SPACE(4) , 12) 
				cLinha += Padr(QRYNFE->MOTO , 29) + " "
				cLinha += Padl(Transform(QRYNFE->VOLUME,"@E 999,999,999.99") , 15)	//volume
				cLinha += Padl(Transform(QRYNFE->KILOMETRO,"@E 999,999.99") , 12)	// Total Kms
				cLinha += Padl(Transform(QRYNFE->FRETE,"@E 99,999,999.99") , 14)	// Valor Frete
				cLinha += Padl(Transform(nAbatimentos,"@E 99,999,999.99") , 12)		// Abatimentos
				cLinha += Padl(Transform(nConvenio,"@E 99,999,999.99") , 14)		// Convenios
				cLinha += Padl(Transform(nLiquid2,"@E 99,999,999.99") , 14)			// Liquido
				
				@ nLin, 000 pSay cLinha
				nLin++
				
				nTot 	+= QRYNFE->VOLUME
				nTot1 	+= QRYNFE->KILOMETRO
				nTot2 	+= QRYNFE->FRETE
				nTot3 	+= nAbatimentos
				nTot4 	+= nConvenio
				nTot5 	+= nLiquid2
				
				lImprimiu := .T.
			
QRYNFE->( dbSkip() )

End While

If lImprimiu
	
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
	
	cLinha := Padr("Totais" , 7)
	cLinha += Padr("da Folha de pagamento Carreteiros" , 35)
	cLinha += padl(Transform(nTot, "@E 999,999,999.99"), 15)
	cLinha += padl(Transform(nTot1, "@E 999,999.99"), 12)
	cLinha += padl(Transform(nTot2, "@E 99,999,999.99"), 14)
	cLinha += padl(Transform(nTot3, "@E 99,999,999.99"), 12)
	cLinha += padl(Transform(nTot4, "@E 99,999,999.99"), 14)
	cLinha += padl(Transform(nTot5, "@E 99,999,999.99"), 14)
	@ nLin, 000 pSay cLinha
	nLin++
	
	@ nLin, 000 pSay __PrtThinLine()
	nLin++
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

Static Function RunQuery()

Local cQuery	:= ""

TcSqlExec("DROP VIEW FOL_CARR")

cQuery := "CREATE VIEW FOL_CARR AS " 
cQuery += "SELECT DISTINCT LBE.LBE_FORNEC AS FORN,LBE.LBE_LOJA AS LOJA,LBE.LBE_CODCAM AS CODCAM,LBE.LBE_MOTO AS MOTO,PC0_TPENTR,PC0_NUMSEQ,PC1_LINHA,LBE.LBE_TPFRET AS PC1_FRETE, "
cQuery += "PC1_CARSUB,LBEA.LBE_TPFRET AS PC1_FRTSUB,LBE.LBE_PERC1 AS PC1_VLFRT,LBEA.LBE_PERC1 AS PC1_VLFSUB,AVG(PA7_QTDKM) PA7_QTDKM,AVG(PC1_VLRLIT) AS PC1_VLRMED, "
cQuery += "MAX(PC1_QTDMED) AS PC1_MEDIDO,SUM(PC1_QTDLIT) AS PC1_INFORM "
cQuery += "FROM " + RetSqlName("PC0") + " PC0 " 
cQuery += "INNER JOIN " + RetSqlName("PC1") + " PC1 ON PC1_FILIAL = PC0_FILIAL AND PC1_NUMSEQ = PC0_NUMSEQ AND PC1.D_E_L_E_T_ = ' ' "
cQuery += "INNER JOIN " + RetSqlName("PA7") + " PA7 ON PA7_FILIAL = '" + cFilAnt + "' AND PA7.PA7_CODLIN = PC1_LINHA AND PA7.D_E_L_E_T_ = ' ' "
cQuery += "LEFT OUTER JOIN " + RetSqlName("LBE") + " LBE ON LBE.LBE_FILIAL = '" + cFilAnt + "' AND LBE.LBE_CODCAM = PA7.PA7_CODCAR AND LBE.D_E_L_E_T_ = ' ' " 
cQuery += "LEFT OUTER JOIN " + RetSqlName("LBE") + " LBEA ON LBEA.LBE_FILIAL = '" + cFilAnt + "' AND LBEA.LBE_CODCAM = PC1.PC1_CARSUB AND LBEA.D_E_L_E_T_ = ' ' " 
cQuery += "WHERE PC0_FILIAL = '" + cFilAnt + "' AND (PC0_DTENTR >= '" + DtoS(MV_PAR01) + "' AND PC0_DTENTR <= '" + DtoS(MV_PAR02) + "') "
cQuery += "AND PC0_TPENTR = '1' AND PC1_CODPRO >= '" + MV_PAR03 + "' AND (PC1_LINHA BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "') "   
cQuery += "AND PC1_CODPRO <= '" + MV_PAR04 + "' AND PC0_QTDAPO > 0 AND PC0.D_E_L_E_T_ = ' ' "
cQuery += "GROUP BY LBE.LBE_FORNEC,LBE.LBE_LOJA,LBE.LBE_CODCAM,LBE.LBE_MOTO,PC0_TPENTR, PC0_NUMSEQ, PC1_LINHA,PA7.PA7_CODCAR, LBE.LBE_TPFRET, PC1_CARSUB, LBEA.LBE_TPFRET, LBE.LBE_PERC1, LBEA.LBE_PERC1 "
cQuery += "UNION ALL "
cQuery += "SELECT DISTINCT LBE.LBE_FORNEC AS FORN,LBE.LBE_LOJA AS LOJA,LBE.LBE_CODCAM AS CODCAM,LBE.LBE_MOTO AS MOTO, "
cQuery += "PC0_TPENTR,PC0_NUMSEQ,PC2_ROTA AS PC1_LINHA,LBE.LBE_TPFRE2 AS PC1_FRETE,PC2_CARSUB AS PC1_CARSUB, "
cQuery += "LBEA.LBE_TPFRE2 AS PC1_FRTSUB,LBE.LBE_PERC2 AS PC1_VLFRT,LBEA.LBE_PERC2 AS PC1_VLFSUB, "
cQuery += "AVG(LBC_TTKMRT) AS PA7_QTDKM,AVG(PC2_VLRLIT) AS PC1_VLRMED,MAX(PC2_QTDMED) AS PC1_MEDIDO, "
cQuery += "SUM(PC2_QTDLIT) AS PC1_INFORM "
cQuery += "FROM " + RetSqlName("PC0") + " PC0 " 
cQuery += "INNER JOIN " + RetSqlName("PC2") + " PC2 ON PC2_FILIAL = PC0_FILIAL AND PC2_NUMSEQ = PC0_NUMSEQ AND PC2.D_E_L_E_T_ = ' ' " 
cQuery += "INNER JOIN " + RetSqlName("LBC") + " LBC ON LBC.LBC_FILIAL = '" + cFilAnt + "' AND LBC.LBC_CODROT = PC2_ROTA AND LBC.D_E_L_E_T_ = ' ' " 
cQuery += "LEFT OUTER JOIN " + RetSqlNAme("LBE") + " LBE ON LBE.LBE_FILIAL = '" + cFilAnt + "' AND LBE.LBE_CODCAM = LBC.LBC_CODCAM AND LBE.D_E_L_E_T_ = ' ' "
cQuery += "LEFT OUTER JOIN " + RetSqlName("LBE") + " LBEA ON LBEA.LBE_FILIAL = '" + cFilAnt + "' " 
cQuery += "AND LBEA.LBE_CODCAM = PC2.PC2_CARSUB AND LBEA.D_E_L_E_T_ = ' ' "
cQuery += "WHERE PC0_FILIAL = '" + cFilAnt + "' AND (PC0_DTENTR >= '" + DtoS(MV_PAR01) + "' AND PC0_DTENTR <= '" + DtoS(MV_PAR02) + "') AND PC0_TPENTR = '2' AND PC0_QTDAPO > 0 AND PC0.D_E_L_E_T_ = ' ' "
cQuery += "AND (PC2_ROTA BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "') "
cQuery += "GROUP BY LBE.LBE_FORNEC,LBE.LBE_LOJA,LBE.LBE_CODCAM,LBE.LBE_MOTO,PC0_TPENTR,PC0_NUMSEQ, PC2_ROTA,LBE.LBE_TPFRE2, PC2_CARSUB, LBEA.LBE_TPFRE2, LBE.LBE_PERC2, LBEA.LBE_PERC2 "

TcSqlExec(cQuery)

MemoWrite("C:\EDI\FOL_CAR.SQL",cQuery)

cQuery := "SELECT PC1_LINHA,CODCAM,MOTO,FORN,LOJA, "
cQuery += "CASE WHEN PC1_FRETE='1' THEN "
cQuery += "AVG(PC1_VLFRT) * SUM(PC1_INFORM) "
cQuery += "WHEN PC1_FRETE='2' THEN "
cQuery += "AVG(PC1_VLFRT) ELSE "
cQuery += "AVG(PC1_VLFRT) * SUM(PA7_QTDKM) END AS FRETE, "
cQuery += "SUM(PA7_QTDKM) AS KILOMETRO, "
cQuery += "SUM(PC1_INFORM) AS VOLUME " 
cQuery += "FROM FOL_CARR WHERE PC1_VLFRT<>0 "
cQuery += "GROUP BY PC1_FRETE,PC1_LINHA,CODCAM,MOTO,FORN,LOJA "
cQuery += "ORDER BY CAST(CODCAM AS INT) "

MemoWrite("C:\EDI\FOL_CAR_VIEW.SQL",cQuery)

cQuery := ChangeQuery( cQuery )

If Select("QRYNFE") > 0
	dbSelectArea("QRYNFE")
	QRYNFE->(dbCloseArea())
EndIf


dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYNFE', .F., .T.)

dbSelectArea("QRYNFE")
dbGotop()

Return nil


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

Static Function RunConv(cCodPro)

Local cQuery1	:= ""
Local nRet		:= 0

cQuery1 := "SELECT SUM(PA6_VALOR) AS VALOR " 
cQuery1 += "FROM " + RetSqlName("PA6") + " PA6 "
cQuery1 += "WHERE PA6_FILIAL = '" + cFilAnt + "' AND PA6.D_E_L_E_T_='' "
cQuery1 += "AND PA6_CODPRO='" + cCodPro + "' AND PA6_PERIOD='" + StrZero(month (MV_PAR01),2) +  cValTochar(year( MV_PAR02 )) + "' "

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

Static Function RunAbat()

Local cQuery2	:= ""
Local nRet		:= 0

TcSqlExec("DROP VIEW ABATIMENTOS")

cQuery2 := "CREATE VIEW ABATIMENTOS AS " 
cQuery2 += "SELECT PC0_TPENTR ,PC0_NUMSEQ, PC1_NUMSEQ, Max(PC0_QTDAPO) AS PC0_APONT, max(PC0_QTDMED) AS PC0_MEDIDO, "
cQuery2 += "max(PC1_QTDMED) AS PC1_MEDIDO,SUM(PC1_QTDLIT	) AS PC1_INFORM, AVG(PC1_VLRLIT) AS PC1_VLRMED, PC1_LINHA,PC1_CARSUB "
cQuery2 += "FROM " + RetSqlName("PC0") + " PC0," + RetSqlName("PC1") + " PC1 " 
cQuery2 += "WHERE PC1_NUMSEQ = PC0_NUMSEQ  AND PC1_FILIAL = PC0_FILIAL  AND PC0_FILIAL = '" + cFilAnt + "' "  
cQuery2 += "AND (PC0_DTENTR >= '" + DtoS(MV_PAR01) + "' AND PC0_DTENTR <= '" + DtoS(MV_PAR02) + "') AND (PC1_LINHA BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "') "
cQuery2 += "AND PC0_TPENTR = '1'  AND PC0_QTDAPO > 0  AND PC0.D_E_L_E_T_ = ' '  AND PC1.D_E_L_E_T_ = ' ' " 
cQuery2 += "Group by PC0_NUMSEQ,PC0_TPENTR , PC1_NUMSEQ,PC1_LINHA, PC1_CARSUB " 

MemoWrite("C:\EDI\ABATI.SQL",cQuery2)

TcSqlExec(cQuery2)


cQuery2 := "SELECT SUM(PC1_MEDIDO),SUM(PC1_INFORM),SUM(PC1_MEDIDO-PC1_INFORM) AS DIFERENCA,AVG(PC1_VLRMED) AS VALOR_MEDIO,CAST((SUM(PC1_INFORM-PC1_MEDIDO))*AVG(PC1_VLRMED) AS NUMERIC(10,2)) AS ABATIMENTO,  "
cQuery2 += "PC1_LINHA FROM ABATIMENTOS GROUP BY PC1_LINHA HAVING SUM(PC1_MEDIDO-PC1_INFORM)<0 AND PC1_LINHA='" + QRYNFE->PC1_LINHA + "' "

MemoWrite("C:\EDI\ABAT_VIEW.SQL",cQuery2)

cQuery2 := ChangeQuery( cQuery2 )
  
If Select("QRYABA") > 0
	dbSelectArea("QRYABA")
	QRYABA->(dbCloseArea())
EndIf

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery2), 'QRYABA', .F., .T.)

nRet := QRYABA->ABATIMENTO

dbSelectArea("QRYABA")
dbGotop()

Return (nRet)



