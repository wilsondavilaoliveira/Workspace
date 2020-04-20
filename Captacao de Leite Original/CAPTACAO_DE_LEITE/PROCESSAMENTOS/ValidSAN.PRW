#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ QUAA022B º Autor ³ wmanfre                   ³  21/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fechamento mensal da captação de leite            	      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QUATA	                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValidSAN()

Local cQuery := ""

// BUSCAR AS LINHAS

cQuery := "SELECT DISTINCT PC0_TPENTR, PC0_NUMSEQ, PC1_LINHA, PA7.PA7_CODCAR, LBE.LBE_TPFRET AS PC1_FRETE, PC1_CARSUB, "
cQuery += "LBEA.LBE_TPFRET AS PC1_FRTSUB, LBE.LBE_PERC1 AS PC1_VLFRT, LBEA.LBE_PERC1 AS PC1_VLFSUB, AVG(PA7_QTDKM) PA7_QTDKM, "
cQuery += "AVG(PC1_VLRLIT) AS PC1_VLRMED, Max(PC1_QTDMED) AS PC1_MEDIDO, SUM(PC1_QTDLIT) AS PC1_INFORM "
cQuery += "FROM " + RetSqlName( "PC0" ) + " PC0 Inner Join " + RetSqlName( "PC1" ) + " PC1 ON "
cQuery += "PC1_FILIAL = PC0_FILIAL  AND PC1_NUMSEQ = PC0_NUMSEQ  AND PC1.D_E_L_E_T_ = ' ' "
cQuery += "Inner Join " + RetSqlName( "PA7" ) + " PA7 ON "
cQuery += "PA7_FILIAL = '" + xFilial("PA7") +"' AND PA7.PA7_CODLIN = PC1_LINHA  AND PA7.D_E_L_E_T_ = ' '  "
cQuery += "Left Outer Join " + RetSqlName( "LBE" ) + " LBE ON "
cQuery += "LBE.LBE_FILIAL = '"+xFilial("LBE")+"'  AND LBE.LBE_CODCAM = PA7.PA7_CODCAR  AND LBE.D_E_L_E_T_ = ' '  ""
cQuery += " Left Outer Join "  + RetSqlName( "LBE" ) + " LBEA  ON "
cQuery += "LBEA.LBE_FILIAL = '"+xFilial("LBE")+"'  AND LBEA.LBE_CODCAM = PC1.PC1_CARSUB  AND LBEA.D_E_L_E_T_ = ' '  "
cQuery += "WHERE PC0_FILIAL = '"+xFilial("PC0")+"'  "
cQuery += "AND (PC0_DTENTR >= '"+dTOS(MV_PAR01)+"'  "
cQuery += "AND PC0_DTENTR <= '"+dTos(MV_PAR02)+"')  "
cQuery += "AND PC0_TPENTR = '1'  "
IF MV_PAR05 = 1
	cQuery += "AND PC1_CODPRO >= '" + MV_PAR03 + "' "	
	cQuery += "AND PC1_CODPRO <= '" + MV_PAR04 + "' "	
Endif
cQuery += "AND PC0_QTDAPO > 0 "
cQuery += "AND PC0.D_E_L_E_T_ = ' '  "
cQuery += "Group BY PC0_TPENTR, PC0_NUMSEQ, PC1_LINHA,PA7.PA7_CODCAR, LBE.LBE_TPFRET, PC1_CARSUB, "
cQuery += "LBEA.LBE_TPFRET, LBE.LBE_PERC1, LBEA.LBE_PERC1 "
cQuery += "ORDER BY PC1_LINHA, PA7_CODCAR  "

cQuery := ChangeQuery( cQuery )

memowrit("C:\EDI\RUNCPP.SQL", cQuery)

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYNFS', .F., .T.)

TcSetField( 'QRYNFS', "PC1_INFORM", "N", 12, 2 )
TcSetField( 'QRYNFS', "PC1_VLRMED", "N", 12, 4 )
TcSetField( 'QRYNFS', "PC1_MEDIDO", "N", 12, 2 )
TcSetField( 'QRYNFS', "PC1_VLFRT",  "N", 12, 2 )
TcSetField( 'QRYNFS', "PC1_VLFSUB", "N", 12, 2 )
TcSetField( 'QRYNFS', "PA7_QTDKM",  "N", 12, 2 )

dbSelectArea("QRYNFS")
dbGotop()

Return()
