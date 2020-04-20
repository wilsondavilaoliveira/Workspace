#INCLUDE 'PROTHEUS.CH' 
#INCLUDE 'TOPCONN.CH'
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAR029   ºAutor  ³Cristiane T Polli   º Data ³  02/21/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esta rotina tem por objetivo imprimir todas os adiantamentosº±±
±±º          ³concedidos em forma de nota promissória ao produtor.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especificos Quata.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function QUAR029()   

Local aArea			:= GetArea()
Local cDesc1  		:= "Esta rotina tem por objetivo imprimir a reimpressão das" 
Local cDesc2  		:= "notas promissórias, casa haja necessidade."
Local cDesc3  		:= ""
Local cString 		:= "PB1"
Local cPerg	  		:= "QUAR29"
Private nLastKey	:= 0         
Private aReturn 	:= {"Zebrado", 1,"Administracao", 2, 2, 1, "",0 }	
Private Tamanho		:= "M"
Private Titulo		:= "Nota Promissória"
Private wnrel		:= "QUAR029" 
Private nBegin		:= 0
Private limite		:= 132 
Private	Li			:= 80 
Private lImpressao	:= .F.                                                                        

PergNP()

if lImpressao	
	Pergunte(cPerg,.F.)
Else	
	Pergunte(cPerg,.T.)
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

Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PergNP    ºAutor  ³Cristiane T Polli   º Data ³  02/20/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta o arquivo de perguntas.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especificos Quata                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PergNP()

Local aArea		:= GetArea()
Local cPerg    	:= "QUAR29"  

dbSelectArea("PB1")

PutSx1( cPerg, "01", "Nota promis.de?"	, "", "", "mv_ch1", "C",TamSx3("PB1_NUMNOT")[1],0,0,"G",""			,"PB1COD"	,"","","mv_par01",""			,"","",		   		,""			,""	,""	,""		,""	,""	,""	,"","","","","" )
PutSx1( cPerg, "02", "Nota promis.ate?"	, "", "", "mv_ch2", "C",TamSx3("PB1_NUMNOT")[1],0,0,"G","!vazio()"	,"PB1COD"	,"","","mv_par02",""			,"","","ZZZZZZ" 	,""			,""	,""	,""		,""	,""	,""	,"","","","","" )
PutSx1( cPerg, "03", "Fornecedor de?"	, "", "", "mv_ch3", "C",TamSx3("A2_COD")[1]	,0,0,"G","" 	   	,"LBBFOR"	,"","","mv_par03",""			,"","",""			,""			,""	,""	,""		,""	,""	,""	,"","","","","" )
PutSx1( cPerg, "04", "Fornecedor ate?"	, "", "", "mv_ch5", "C",TamSx3("A2_COD")[1]	,0,0,"G","!vazio()"	,"LBBFOR"	,"","","mv_par04",""			,"","","ZZZZZZ" 	,""			,""	,""	,""		,""	,""	,""	,"","","","","" )
PutSx1( cPerg, "05", "loja de?"			, "", "", "mv_ch4", "C",TamSx3("A2_LOJA")[1]	,0,0,"G",""		   	,""   		,"","","mv_par05",""			,"","",""			,""			,""	,""	,""		,""	,""	,""	,"","","","","" )
PutSx1(	cPerg, "06", "loja ate?"		, "", "", "mv_ch6", "C",TamSx3("A2_LOJA")[1]	,0,0,"G","!vazio()"	,""			,"","","mv_par06",""			,"","","ZZZZ"		,""			,""	,""	,""		,""	,""	,""	,"","","","","" )
PutSx1(	cPerg, "07", "Período de?"		, "", "", "mv_ch7", "D",8						,0,0,"G","!vazio()"	,""			,"","","mv_par07",""			,"","",""			,""			,""	,""	,""		,""	,""	,""	,"","","","","" )
PutSx1(	cPerg, "08", "Periodo ate?"		, "", "", "mv_ch8", "D",8						,0,0,"G","!vazio()"	,""			,"","","mv_par08",""			,"","",""			,""			,""	,""	,""		,""	,""	,""	,"","","","","" )
PutSx1(	cPerg, "09", "Tipo ?"			, "", "", "mv_ch9", "C",10						,0,0,"C",""			,""			,"","","mv_par09","Em Aberto"	,"","",""			,"Abatido"	,""	,"" ,"Ambos","" ,""	,""	,"","","","","" )

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
 
cQuery	:= " SELECT PB2_NUMNOT,PB1_CODPRO+'-'+PB1_NOME PRODUTOR,PB2_NPARCE,PB2_DTVENC,PB2_VLPPAR, SE2.E2_SALDO " + CRLF
cQuery	+= "  FROM "+RetSqlName("PB1")+" PB1   " + CRLF
cQuery	+= "   INNER JOIN "+RetSqlName("PB2")+" PB2 " + CRLF
cQuery	+= "   			ON  PB2_NUMNOT BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'   " + CRLF
cQuery	+= "  			AND PB2.PB2_DTVENC BETWEEN '"+dtos(MV_PAR07)+"' AND '"+dtos(MV_PAR08)+"'    " + CRLF
cQuery	+= "    		AND PB2.PB2_FILIAL = '"+xFilial("PB2")+"'   " + CRLF
cQuery	+= "   			AND PB2.D_E_L_E_T_ = '' " + CRLF
cQuery	+= "  INNER JOIN "+RetSqlName("SE2")+" SE2 " + CRLF
cQuery	+= "  			ON SE2.E2_PREFIXO = PB2.PB2_PREFTI " + CRLF
cQuery	+= "  INNER JOIN "+RetSqlName("LBB")+" LBB " + CRLF
cQuery	+= "  			ON PB1.PB1_CODPRO = LBB.LBB_CODPRO " + CRLF
cQuery	+= "  			AND SE2.E2_NUM = PB2.PB2_NTITUL " + CRLF
cQuery	+= "  			AND SE2.E2_PARCELA = PB2.PB2_NPARCE  " + CRLF 
if MV_PAR09 == 1
	cQuery	+= "  			AND SE2.E2_SALDO > 0  " + CRLF
Elseif	MV_PAR09 == 2                                    
	cQuery	+= "  			AND SE2.E2_SALDO = 0  " + CRLF
EndIf
cQuery	+= "    		AND SE2.E2_FILIAL = '"+xFilial("SE2")+"'   " + CRLF
cQuery	+= "  		 	AND SE2.D_E_L_E_T_ = ''  " + CRLF 
cQuery	+= "  		 	AND SE2.E2_TIPO = 'NDF'  " + CRLF 
cQuery	+= "   WHERE PB2_NUMNOT = PB1_NUMNOT  " + CRLF
cQuery	+= "   		AND PB1_CODFOR BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'   " + CRLF
cQuery	+= "   		AND PB1_LJFORN	BETWEEN '"+MV_PAR05+"  ' AND '"+MV_PAR06+"'   " + CRLF
cQuery	+= "   		AND PB1.PB1_FILIAL = '"+xFilial("PB1")+"'   " + CRLF
cQuery	+= "   		AND PB1.D_E_L_E_T_ = '' ORDER BY CAST(LBB_LINHA AS INT),CAST(PB1_CODPRO AS INT),PB2_DTVENC " 
 	     
If Select("QUAR029") > 0
	dbSelectArea("QUAR029")
	QUAR029->(dbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "QUAR029"

if QUAR029->(Eof())
	Aviso("Notas Promissorias","Para os parametros informados não existe NP!",{"OK"})	
Else
	QUAImprime()
EndIf	

RestArea(aArea)

Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAImprimeºAutor  ³Cristiane T Polli   º Data ³  02/21/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime a relacao de notas promissórias.					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especificos Quata.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function QUAImprime()
                              
Local nSaldo	:= 0
Local cTitulo	:= '',cabec1 := '', cabec2 := '', nomeprog := "NOTAS PROMISSÓRIAS"
Local nCount	:= 1

nTipo    :=IIF(aReturn[4]==1,15,18)
m_pag	:= 1                         

While !QUAR029->(Eof())
nCount ++
QUAR029->(dbSkip())
End While

QUAR029->(dbGoTop())

SetRegua(nCount)

While !QUAR029->(Eof())

	If li > 55 	    
		cTitulo := 	"Resumo Notas Promissórias Vencimento de: "+cValToChar(MV_PAR07)+" a: "+cValToChar(MV_PAR08)+" - "+cValToChar(SM0->M0_FILIAL) 
		cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,nTipo)			
		@ Li,001 Psay "Número NP     Código/Nome do Fornecedor                    Parcela     Vencimento               Valor     Tipo"
		             //123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*
		Li++         //         1         2         3         4         5         6         7         8         9         10        11        12
		@ Li,001 Psay __PrtThinLine()
		Li++
	Endif
	
	IncRegua("Nota Promissória: "+QUAR029->PB2_NUMNOT)
	
	@ Li,001 Psay QUAR029->PB2_NUMNOT
	@ Li,015 Psay SubStr(QUAR029->PRODUTOR,1,35)                          
	@ Li,060 Psay QUAR029->PB2_NPARCE	
	@ Li,072 Psay DTOC(STOD(QUAR029->PB2_DTVENC))
	@ Li,087 Psay QUAR029->PB2_VLPPAR					Picture "@E 9,999,999,999.99"
	
	if QUAR029->E2_SALDO > 0
		@ Li,107 Psay "Em Aberto"
	Elseif QUAR029->E2_SALDO == 0
		@ Li,107 Psay "Abatido"
	EndIf
			
	nSaldo += QUAR029->PB2_VLPPAR
	Li++ 
QUAR029->(dbSkip())	
EndDo	

@ Li,001 Psay __PrtThinLine()
Li++                     
@ Li,001 Psay "Total geral" 
@ Li,087 Psay  Transform(nSaldo,"@E 9,999,999,999.99")	
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