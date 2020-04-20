#INCLUDE 'PROTHEUS.CH'      
#INCLUDE 'TOPCONN.CH'
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAR019C  ºAutor  ³Cristiane T Polli   º Data ³  01/17/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Esta Rotina tem por objetivo realizar a impressão do holeri-º±±
±±º          ³te.                                                         º±±
±±º          ³Projeto n FS07529302 PL_24                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especificos Quata                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function QUAR019C()

Local aArea			:= GetArea()
Local cDesc1  		:= "Esta rotina tem por objetivo realizar a impressão de holerite," 
Local cDesc2  		:= "conforme parametrização.Selecione os parametros!"
Local cDesc3  		:= ""
Local cString 		:= "LBO"
Local cPerg	  		:= "QUAR019C"
Private nLastKey	:= 0         
Private aReturn 	:= {"Zebrado", 1,"Administracao", 2, 2, 1, "",0 }	
Private Tamanho		:= "M"
Private Titulo		:= "HOLERITE"
Private wnrel		:= "QUAR019C" 
Private nBegin		:= 0
Private limite		:= 132 
Private	Li			:= 80                                                                         

AjustaSx1(cPerg)

If !Pergunte(cPerg,.T.)
	Return Nil
EndIf

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey == 27
	Set Filter to
	Return Nil
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return Nil
Endif                 

RptStatus( { |lEnd|  RunQuery() } )

RestArea(aArea)

Return Nil
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PergHole  ºAutor  ³Cristiane T Polli   º Data ³  01/17/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³monta o arquivo de perguntas caso não exista no SX1.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSx1(cPerg)

Local aArea		:= GetArea()

PutSx1(cPerg,"01","Entrada De?" 	,"","","mv_ch1","D",08,0,0,"G","",""		,"","","mv_par01")
PutSX1(cPerg,"02","Entrada Até?"	,"","","mv_ch2","D",08,0,0,"G","",""		,"","","mv_par02")
PutSx1(cPerg,"03","Produtor De?" 	,"","","mv_ch3","C",06,0,0,"G","","LBBCOD"	,"","","mv_par03")
PutSX1(cPerg,"04","Produtor Até?"	,"","","mv_ch4","C",06,0,0,"G","","LBBCOD"	,"","","mv_par04")
PutSx1(cPerg,"05","Linha De?" 		,"","","mv_ch5","C",06,0,0,"G","","PA7"	,"","","mv_par05")
PutSX1(cPerg,"06","Linha Até?"		,"","","mv_ch6","C",06,0,0,"G","","PA7"	,"","","mv_par06")

RestArea(aArea)
	
Return Nil 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAImprimeºAutor  ³Cristiane T Polli   º Data ³  01/21/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime o holerite se existir registros.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function QUAImprime()                              

Local cPag		:= '01'
Local cProdutor	:= ''
Local nDebito	:= 0
Local nCredito	:= 0
Local cTitulo	:= '',cabec1 := '', cabec2 := '', nomeprog := "Extrato"  
Local cMesAno	:= strTran(MV_PAR07,"/","")
Local cLinha	:= ' '
Local nRec		:= 0
Local cNLinha	:= ''

nTipo    :=IIF(aReturn[4]==1,15,18)
m_pag	:= 1                         

While !QRYNFE->(Eof())
	nRec ++
	QRYNFE->( dbskip() )
End While

SetRegua(nRec)
nRec := 0

QRYNFE->( dbGoTop() )

While !QRYNFE->(Eof())
    
	cTitulo := 	"EXTRATO CARRETEIRO - " + StrZero(Month(MV_PAR01),2)+ "/" + cValToChar(Year(MV_PAR01)) + " - " + cValToChar(SM0->M0_FILIAL)
	IF li > 55 
		cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	
	li ++
	@ Li,001 Psay "NOME : " + QRYNFE->MOTO
	Li++
	@ Li,001 Psay "-------------------------------------------------------------------------------------------------------------------"
	Li ++
	@ Li,001 Psay "D E S C R I Ç Ã O                          L I T R O S     KILOMETROS      F R E T E     ABATIMENTOS      CONVENIO "
	Li++
	@ Li,001 Psay "----------------------------------------   ------------   ------------   ------------   ------------   ------------" 
	Li++         //123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*
	
	cProdutor 		:= QRYNFE->MOTO
	
	IncRegua("Registro: " + cValToChar(nRec))
	nRec ++
	
	LBB->(dbSetOrder(2))
	LBB->( dbSeek( xFilial("LBB") + QRYNFE->FORN + QRYNFE->LOJA ) )
	cCodPro := LBB->LBB_CODPRO
	
	cPropriedade	:= LBB->LBB_CODPRO
	cNLinha			:= QRYNFE->PC1_LINHA
	nCredito		:= 0 
	nDebito			:= 0
	nSaldo			:= 0

	While QRYNFE->MOTO == cProdutor
	        
	        cLinha := "F R E T E" + space(34) 
			cLinha += Padl(Transform(QRYNFE->VOLUME, "@E 999,999"),12)+"   "
			cLinha += Padl(Transform(QRYNFE->KILOMETRO, "@E 999,999"),12)+"   "
			cLinha += Padl(Transform(QRYNFE->FRETE, "@E 999,999.99"),12)+"   "
			cLinha += Padl(Transform(0, "@E 999,999.99"),12)+"   "			
			cLinha += Padl(Transform(0, "@E 999,999.99"),12)+"   "
			nCredito += QRYNFE->FRETE 
			@ Li,001 Psay cLinha
			Li ++
			
			RunAbat(cNLinha)
			
			If QRYABA->ABATIMENTO > 0
			
			cLinha := "ABATIMENTO DIF.LITROS" + space(22) 
			cLinha += Padl(Transform(QRYABA->DIFERENCA, "@E 999,999"),12)+"   "
			cLinha += Padl(Transform(0, "@E 999,999"),12)+"   "
			cLinha += Padl(Transform(0, "@E 999,999.99"),12)+"   "
			cLinha += Padl(Transform(QRYABA->ABATIMENTO, "@E 999,999.99"),12)+"   "			
			cLinha += Padl(Transform(0, "@E 999,999.99"),12)+"   "
			nDebito += QRYABA->ABATIMENTO
			@ Li,001 Psay cLinha
		    Li ++
			
			End If
			
			RunConv(cPropriedade)
			
			
			While QRYCONV->( !Eof() )
			
			cLinha := Padr(Upper(AllTrim(QRYCONV->LBR_DESC)),43) 
			cLinha += Padl(Transform(0, "@E 999,999"),12)+"   "
			cLinha += Padl(Transform(0, "@E 999,999"),12)+"   "
			cLinha += Padl(Transform(0, "@E 999,999.99"),12)+"   "
			cLinha += Padl(Transform(0, "@E 999,999.99"),12)+"   "			
			cLinha += Padl(Transform(QRYCONV->PA6_VALOR, "@E 999,999.99"),12)+"   "
			nDebito += QRYCONV->PA6_VALOR
			@ Li,001 Psay cLinha
		    Li ++
			
			QRYCONV->( dbskip() )
			
			End While
		
	QRYNFE->( dbSkip() )
	
	EndDo
	
	Li++	
	@ Li,001 Psay __PrtThinLine()
	Li++                     
	if (nSaldo := nCredito - nDebito) > 0
		@ Li,001 Psay "Saldo Credor ----------------------->" 
	Elseif nSaldo < 0
		@ Li,001 Psay "Saldo Devedor ----------------------->" 
	Else
		@ Li,001 Psay "Saldo ----------------------->" 		
	EndIf	
	
	@ Li,043 Psay  padl(Transform(nSaldo,"@E 9,999,999.99"),12)	
	Li++
	@ Li,001 Psay __PrtThinLine()

	cProdutor := QRYNFE->MOTO 
	
	nCredito	:= 0 
	nDebito		:= 0
	nSaldo		:= 0
	Li	:= 80         

EndDo	

If aReturn[5] = 1   
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

Ms_Flush()

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

TcSqlExec("DROP VIEW FOL_CARRH")

cQuery := "CREATE VIEW FOL_CARRH AS " 
cQuery += "SELECT DISTINCT LBE.LBE_FORNEC AS FORN,LBE.LBE_LOJA AS LOJA,LBE.LBE_CODCAM AS CODCAM,LBE.LBE_MOTO AS MOTO,PC0_TPENTR,PC0_NUMSEQ,PC1_LINHA,LBE.LBE_TPFRET AS PC1_FRETE, "
cQuery += "PC1_CARSUB,LBEA.LBE_TPFRET AS PC1_FRTSUB,LBE.LBE_PERC1 AS PC1_VLFRT,LBEA.LBE_PERC1 AS PC1_VLFSUB,AVG(PA7_QTDKM) PA7_QTDKM,AVG(PC1_VLRLIT) AS PC1_VLRMED, "
cQuery += "MAX(PC1_QTDMED) AS PC1_MEDIDO,SUM(PC1_QTDLIT) AS PC1_INFORM "
cQuery += "FROM " + RetSqlName("PC0") + " PC0 " 
cQuery += "INNER JOIN " + RetSqlName("PC1") + " PC1 ON PC1_FILIAL = PC0_FILIAL AND PC1_NUMSEQ = PC0_NUMSEQ AND PC1.D_E_L_E_T_ = ' ' "
cQuery += "INNER JOIN " + RetSqlName("PA7") + " PA7 ON PA7_FILIAL = '" + cFilAnt + "' AND PA7.PA7_CODLIN = PC1_LINHA AND PA7.D_E_L_E_T_ = ' ' "
cQuery += "LEFT OUTER JOIN " + RetSqlName("LBE") + " LBE ON LBE.LBE_FILIAL = '" + cFilAnt + "' AND LBE.LBE_CODCAM = PA7.PA7_CODCAR AND LBE.D_E_L_E_T_ = ' ' " 
cQuery += "LEFT OUTER JOIN " + RetSqlName("LBE") + " LBEA ON LBEA.LBE_FILIAL = '" + cFilAnt + "' AND LBEA.LBE_CODCAM = PC1.PC1_CARSUB AND LBEA.D_E_L_E_T_ = ' ' " 
cQuery += "WHERE PC0_FILIAL = '" + cFilAnt + "' AND (PC0_DTENTR >= '" + DtoS(MV_PAR01) + "' AND PC0_DTENTR <= '" + DtoS(MV_PAR02) + "') "
cQuery += "AND PC0_TPENTR = '1' AND PC1_CODPRO >= '" + MV_PAR03 + "'  "   
cQuery += "AND PC1_CODPRO <= '" + MV_PAR04 + "' AND PC0_QTDAPO > 0 AND PC0.D_E_L_E_T_ = ' ' AND (PC1_LINHA BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "')"
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
cQuery += "AND (PC2_ROTA BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "') GROUP BY LBE.LBE_FORNEC,LBE.LBE_LOJA,LBE.LBE_CODCAM,LBE.LBE_MOTO,PC0_TPENTR,PC0_NUMSEQ, PC2_ROTA,LBE.LBE_TPFRE2, PC2_CARSUB, LBEA.LBE_TPFRE2, LBE.LBE_PERC2, LBEA.LBE_PERC2 "

TcSqlExec(cQuery)

MemoWrite("C:\EDI\FOL_CARH.SQL",cQuery)

cQuery := "SELECT PC1_LINHA,CODCAM,MOTO,FORN,LOJA, "
cQuery += "CASE WHEN PC1_FRETE='1' THEN "
cQuery += "AVG(PC1_VLFRT) * SUM(PC1_INFORM) "
cQuery += "WHEN PC1_FRETE='2' THEN "
cQuery += "AVG(PC1_VLFRT) ELSE "
cQuery += "AVG(PC1_VLFRT) * SUM(PA7_QTDKM) END AS FRETE, "
cQuery += "SUM(PA7_QTDKM) AS KILOMETRO, "
cQuery += "SUM(PC1_INFORM) AS VOLUME " 
cQuery += "FROM FOL_CARRH WHERE PC1_VLFRT<>0 "
cQuery += "GROUP BY PC1_FRETE,PC1_LINHA,CODCAM,MOTO,FORN,LOJA "
cQuery += "ORDER BY CAST(CODCAM AS INT) "

MemoWrite("C:\EDI\FOL_CARH_VIEW.SQL",cQuery)

cQuery := ChangeQuery( cQuery )

If Select("QRYNFE") > 0
	dbSelectArea("QRYNFE")
	QRYNFE->(dbCloseArea())
EndIf


dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYNFE', .F., .T.)

dbSelectArea("QRYNFE")
dbGotop()

QUAImprime()

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

cQuery1 := "SELECT LBB_LINHA,PA6_CODPRO,LBB_NOMFOR,PA6_VALOR,PA6_TIPDES,LBR_DESC,PA6_OBSERV FROM PA6010 PA6 " 
cQuery1 += "INNER JOIN " + RetSqlName("LBR") + " LBR ON LBR_FILIAL=PA6_FILIAL AND LBR_TIPDES=PA6_TIPDES AND LBR.D_E_L_E_T_='' "
cQuery1 += "INNER JOIN " + RetSqlName("LBB") + " LBB ON LBB_CODPRO=PA6_CODPRO AND LBB_FILIAL=PA6_FILIAL AND LBB.D_E_L_E_T_='' "
cQuery1 += "WHERE PA6_FILIAL='" + cFilAnt + "' AND PA6_PERIOD='" + StrZero(month (MV_PAR01),2) +  cValTochar(year( MV_PAR02 )) + "' "
cQuery1 += "AND PA6.D_E_L_E_T_='' AND PA6_CODPRO='" + cCodPro + "' " 
cQuery1 += "ORDER BY LBB_DESC"

MemoWrite("C:\EDI\CONV_HOL.SQL",cQuery1)

cQuery1 := ChangeQuery( cQuery1 )

If Select("QRYCONV") > 0
	dbSelectArea("QRYCONV")
	QRYCONV->(dbCloseArea())
EndIf

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery1), 'QRYCONV', .F., .T.)

QRYCONV->( dbGoTop() )

Return()

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

Static Function RunAbat(cLinha)

Local cQuery2	:= ""
Local nRet		:= 0

TcSqlExec("DROP VIEW ABATIMENTOSH")

cQuery2 := "CREATE VIEW ABATIMENTOSH AS " 
cQuery2 += "SELECT PC0_TPENTR ,PC0_NUMSEQ, PC1_NUMSEQ, Max(PC0_QTDAPO) AS PC0_APONT, max(PC0_QTDMED) AS PC0_MEDIDO, "
cQuery2 += "max(PC1_QTDMED) AS PC1_MEDIDO,SUM(PC1_QTDLIT	) AS PC1_INFORM, AVG(PC1_VLRLIT) AS PC1_VLRMED, PC1_LINHA,PC1_CARSUB "
cQuery2 += "FROM " + RetSqlName("PC0") + " PC0," + RetSqlName("PC1") + " PC1 " 
cQuery2 += "WHERE PC1_NUMSEQ = PC0_NUMSEQ  AND PC1_FILIAL = PC0_FILIAL  AND PC0_FILIAL = '" + cFilAnt + "' "  
cQuery2 += "AND (PC0_DTENTR >= '" + DtoS(MV_PAR01) + "' AND PC0_DTENTR <= '" + DtoS(MV_PAR02) + "') "
cQuery2 += "AND PC0_TPENTR = '1'  AND PC0_QTDAPO > 0  AND PC0.D_E_L_E_T_ = ' '  AND PC1.D_E_L_E_T_ = ' ' AND PC1_LINHA='" + cLinha + "' " 
cQuery2 += "Group by PC0_NUMSEQ,PC0_TPENTR , PC1_NUMSEQ,PC1_LINHA, PC1_CARSUB " 

MemoWrite("C:\EDI\ABATIH.SQL",cQuery2)

TcSqlExec(cQuery2)


cQuery2 := "SELECT SUM(PC1_MEDIDO),SUM(PC1_INFORM),SUM(PC1_MEDIDO-PC1_INFORM) AS DIFERENCA,AVG(PC1_VLRMED) AS VALOR_MEDIO,CAST((SUM(PC1_INFORM-PC1_MEDIDO))*AVG(PC1_VLRMED) AS NUMERIC(10,2)) AS ABATIMENTO,  "
cQuery2 += "PC1_LINHA FROM ABATIMENTOSH GROUP BY PC1_LINHA HAVING SUM(PC1_MEDIDO-PC1_INFORM)<0 "

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

