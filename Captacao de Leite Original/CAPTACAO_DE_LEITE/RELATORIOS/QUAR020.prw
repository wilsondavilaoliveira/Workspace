#INCLUDE 'PROTHEUS.CH'      
#INCLUDE 'TOPCONN.CH'
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAR020   ºAutor  ³Cristiane T Polli   º Data ³  01/24/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Esta rotina tem por objetivo realizar a impressão do relató-º±±
±±º          ³rio de fornecedores com saldo devedor.                      º±±
±±º          ³Projeto n FS07529302 PL_25                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especificos Quata                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function QUAR020()

Local aArea			:= GetArea()
Local cDesc1  		:= "Esta rotina tem por objetivo realizar a impressão do relatório," 
Local cDesc2  		:= "de fornecedores com saldo devedor."
Local cDesc3  		:= ""
Local cString 		:= "LBO"
Local cPerg	  		:= "QUAR020"
Private nLastKey	:= 0         
Private aReturn 	:= {"Zebrado", 1,"Administracao", 2, 2, 1, "",0 }	
Private Tamanho		:= "M"
Private Titulo		:= "SALDO DEVEDOR"
Private wnrel		:= "QUAR020" 
Private nBegin		:= 0
Private limite		:= 132 
Private	Li			:= 80                                                                         

PergHole(cPerg)

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

RptStatus( { |lEnd|  QUAProce() } )

RestArea(aArea)

Return Nil
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PergHole  ºAutor  ³Cristiane T Polli   º Data ³  01/24/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³monta o arquivo de perguntas caso não exista no SX1.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especificos Quata                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PergHole(cPerg)

Local aArea		:= GetArea()
Local aRegs    	:= {}
  

PutSx1( cPerg, "01", "Linha de?"		, "", "", "mv_ch1", "C",TamSx3("LBC_CODROT")[1],0,0,"G",""			,"LBCCOD"	,"","","mv_par01","","","",""	     ,"","","","","","","","","","","","" )
PutSx1( cPerg, "02", "Linha ate?"		, "", "", "mv_ch2", "C",TamSx3("LBC_CODROT")[1],0,0,"G","!VAZIO()"	,"LBCCOD"	,"","","mv_par02","","","","ZZZZZZ" ,"","","","","","","","","","","","" )
PutSx1( cPerg, "03", "Produtor de?"		, "", "", "mv_ch3", "C",TamSx3("LBB_CODPRO")[1],0,0,"G","" 		,"LBBCOD"	,"","","mv_par03","","","",""	     ,"","","","","","","","","","","","" )
PutSx1( cPerg, "04", "Produtor ate?"	, "", "", "mv_ch4", "C",TamSx3("LBB_CODPRO")[1],0,0,"C","!VAZIO()"	,"LBBCOD"   ,"","","mv_par04","","","","ZZZZZZ" ,"","","","","","","","","","","","" )
//PutSx1(cPerg,"05","Entrada De?" 	,"","","mv_ch5","D",08,0,0,"G","",""		,"","","mv_par05")
//PutSX1(cPerg,"06","Entrada Até?"	,"","","mv_ch6","D",08,0,0,"G","",""		,"","","mv_par06")



RestArea(aArea)
	
Return Nil 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAProce  ºAutor  ³Cristiane T Polli   º Data ³  01/24/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Seleciona os registros conforme parametrização.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³  Especificos Quata                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function QUAProce()

Local aArea		:= GetArea()
Local cQuery	:= ''      
//Local cPeriodo	:= substr(MV_PAR05,4,4)+substr(MV_PAR05,1,2)
Local cPrefixo  := strTran(GetMv("MV_PREFSE1"),'"','')
Local cTipo 	:= strTran(GetMv("MV_TPTITE1"),'"','')
//Local _cMesAno	:= cPeriodo
//Local dIni		:= Stod(cPeriodo+"01")
//Local dFim		:= LastDay(dIni)
//Local cDataIni  := Dtos(dIni)
//Local cDataFim  := dTos(dFim)


cQuery := "SELECT LBB_LINHA, LBB_CODPRO , LBB_NOMFOR , SUM(E2_VALOR) AS VALOR " + CRLF
cQuery += "FROM " + RetSqlName("SE2") + " SE2 " + CRLF
cQuery += "INNER JOIN " + RetSqlName("LBB") + " LBB " + CRLF
cQuery += "ON LBB_FILIAL = '" + xFilial("LBB") + "' "+ CRLF
cQuery += " AND LBB_CODFOR = E2_FORNECE " + CRLF
cQuery += " AND LBB_LOJA = E2_LOJA " + CRLF
cQuery += " AND LBB.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "WHERE E2_FILIAL = '" + xFilial("SE2") + "' " + CRLF
cQuery += " AND E2_TIPO = 'NDF' " + CRLF
//cQuery += " AND E2_VENCREA BETWEEN '" + dTos(MV_PAR05) + "' AND '" + dTOS(MV_PAR06)  + "' " + CRLF
cQuery += " AND E2_BAIXA = ' ' " + CRLF
cQuery += " AND SE2.D_E_L_E_T_ = ' ' " + CRLF
cQuery += " AND LBB_LINHA >= '"+MV_PAR01+"' " + CRLF
cQuery += " AND LBB_LINHA <= '"+MV_PAR02+"' " + CRLF
cQuery += " AND LBB_CODPRO >= '"+MV_PAR03+"' " + CRLF
cQuery += " AND LBB_CODPRO <= '"+MV_PAR04+"' " + CRLF
cQuery += " Group BY LBB_LINHA, LBB_CODPRO , LBB_NOMFOR " + CRLF
cQuery += " ORDER BY LBB_LINHA, LBB_CODPRO " + CRLF

MemoWrite("C:\EDI\SALDODEV.SQL",cQuery)

If Select("QUAR020") > 0
	dbSelectArea("QUAR020")
	QUAR020->(dbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "QUAR020"

if QUAR020->(Eof())
	Aviso("Registros de Débito","Para os parametros informados não existe saldo devedor!",{"OK"})	
Else
	QUAImprime()
EndIf	

If Select("QUAR020") > 0
	dbSelectArea("QUAR020")
	QUAR020->(dbCloseArea())
EndIf

RestArea(aArea)

Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAImprimeºAutor  ³Cristiane T Polli   º Data ³  01/24/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime o holerite se existir registros.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function QUAImprime()
                              
Local nSaldo	:= 0
Local cTitulo	:= '',cabec1 := '', cabec2 := '', nomeprog := "SALDO DEVEDOR"

nTipo    :=IIF(aReturn[4]==1,15,18)
m_pag	:= 1                         

SetRegua(Val(mv_par04)-Val(mv_par03))

While !QUAR020->(Eof())

	If li > 55 	    
		cTitulo := 	"FORNECEDORES DEVEDORES  " 
		cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			
		@ Li,001 Psay "F O R N E C E D O R                                       V A L O R   "
		Li++
		@ Li,001 Psay "--------------------------------------------------     ---------------" 
		Li++         //123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*
	Endif
	
	IncRegua("Produtor: "+QUAR020->LBB_NOMFOR)

	@ Li,001 Psay QUAR020->LBB_CODPRO + " " + QUAR020->LBB_NOMFOR
	@ Li,055 Psay QUAR020->valor Picture "@E 9,999,999,999.99"
	nSaldo += QUAR020->valor
	Li++ 
QUAR020->(dbSkip())	
EndDo	

@ Li,001 Psay __PrtThinLine()
Li++                     
@ Li,001 Psay "Total ----------------------->" 
@ Li,055 Psay  Transform(nSaldo,"@E 9,999,999,999.99")	
Li++
@ Li,001 Psay __PrtThinLine()

Li	:= 80         

If aReturn[5] = 1   
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

Ms_Flush()

Return