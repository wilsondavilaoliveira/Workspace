#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAR028   ºAutor  ³Cristiane T Polli   º Data ³  02/20/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Esta rotina tem por objetivo permitir a reimpressao das notaº±±
±±º          ³s promiss´rias, caso haja necessidade.                      º±±
±±º          ³Projeto nº FS07529302 PL_39 						          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especificos Quata.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function QUAR028() 

Local aArea			:= GetArea()
Local cDesc1  		:= "Esta rotina tem por objetivo permitir a reimpressão das" 
Local cDesc2  		:= "notas promissórias, casa haja necessidade."
Local cDesc3  		:= ""
Local cString 		:= "PB1"
Local cPerg	  		:= "QUAR028"
Private nLastKey	:= 0         
Private aReturn 	:= {"Zebrado", 1,"Administracao", 2, 2, 1, "",0 }	
Private Tamanho		:= "M"
Private Titulo		:= "Nota Promissória"
Private wnrel		:= "QUAR028" 
Private nBegin		:= 0
Private limite		:= 132 
Private	Li			:= 3 
Private lImpressao	:= .F.                                                                        

if IsInCAllStack("U_QUAA029")	==.T.
	if !MsgYesNo("Deseja imprimir a nota promissória?")
		Return
	Else
		lImpressao	:= .T.     
	EndIf
EndIf

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

if lImpressao
	MV_PAR01	:= MV_PAR02 := PB1->PB1_NUMNOT
	MV_PAR03	:= MV_PAR04 := PB1->PB1_CODPRO
	MV_PAR05	:= ''
EndIf

RptStatus( { |lEnd|  QUAProce() } )

RestArea(aArea)

Return Nil
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
Local cPerg    	:= "QUAR028"  

dbSelectArea("PB1")

PutSx1( cPerg, "01", "Nota promis.de?"	, "", "", "mv_ch1", "C",TamSx3("PB1_NUMNOT")[1],0,0,"G",""				,""			,"","","mv_par01","","","",			 ,"","","","","","","","","","","","" )
PutSx1( cPerg, "02", "Nota promis.ate?"	, "", "", "mv_ch2", "C",TamSx3("PB1_NUMNOT")[1],0,0,"G","!VAZIO()"		,""			,"","","mv_par02","","","","ZZZZZZ" ,"","","","","","","","","","","","" )
PutSx1(	cPerg, "03", "Propriedade de?"	, "", "", "mv_ch3", "C",TamSx3("LBB_CODPRO")[1],0,0,"G", ""			,"LBBCOD"	,"","","mv_par03","","","",""		 ,"","","","","","","","","","","","" )
PutSx1(	cPerg, "04", "Propriedade ate?"	, "", "", "mv_ch4", "C",TamSx3("LBB_CODPRO")[1],0,0,"G", "!VAZIO()"	,"LBBCOD"	,"","","mv_par04","","","","ZZZZZZ"	 ,"","","","","","","","","","","","" )
PutSx1(	cPerg, "05", "Vencimento de?"	, "", "", "mv_ch5", "D",8						,0,0,"G", "!VAZIO()"	,""			,"","","mv_par05","","","",""		 ,"","","","","","","","","","","","" )
PutSx1(	cPerg, "06", "Vencimento Ate?"	, "", "", "mv_ch6", "D",8						,0,0,"G", "!VAZIO()"	,""			,"","","mv_par06","","","",""		 ,"","","","","","","","","","","","" )

RestArea(aArea)
	
Return Nil 



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAProce  ºAutor  ³Cristiane T Polli   º Data ³  02/20/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Seleciona os registros conforme parametros.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especificos Quata                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function QUAProce()

Local aArea		:= GetArea()
Local cQuery	:= ''      

cQuery	:= "SELECT PB2_NUMNOT,PB2_NPARCE,PB1_DTEMIS,PB2_VLPPAR, PB2_DTVENC, PB1_CODPRO, LBB_NOMFOR, LBB_END,LBB_MUN,LBB_EST,LBB_CEP,LBB_INSCR "+CRLF
cQuery	+= " FROM "+RetSqlName("PB2")+" PB2  "+CRLF
cQuery	+= " INNER JOIN "+RetSqlName("PB1")+" PB1  "+CRLF
cQuery	+= " ON PB1_NUMNOT BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "+CRLF
cQuery	+= " AND PB1_CODPRO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'  "+CRLF
cQuery	+= " AND PB1.PB1_FILIAL = '"+xFilial("PB1")+"'  "+CRLF
cQuery	+= " AND PB1.D_E_L_E_T_ = ''  "+CRLF
cQuery	+= " INNER JOIN "+RetSqlName("LBB")+" LBB  "+CRLF
cQuery	+= " ON LBB.LBB_CODPRO = PB1_CODPRO"+CRLF
cQuery	+= " AND LBB.LBB_FILIAL = '"+xFilial("LBB")+"'  "+CRLF
cQuery	+= " AND LBB.D_E_L_E_T_ = ''  "+CRLF
cQuery	+= " WHERE PB2_NUMNOT = PB1_NUMNOT   "+CRLF
If !EMPTY(MV_PAR05)
cQuery	+= " AND PB2.PB2_FILIAL = '"+xFilial("PB2")+"' AND PB2_DTVENC BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "'"+CRLF
Else
cQuery	+= " AND PB2.PB2_FILIAL = '"+xFilial("PB2")+"'" + CRLF
End If
cQuery	+= " AND PB2.D_E_L_E_T_ = '' ORDER BY CAST(LBB_LINHA AS INT),CAST(PB1_CODPRO AS INT),PB2_DTVENC"
	
If Select("QUAR028") > 0
	dbSelectArea("QUAR028")
	QUAR028->(dbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "QUAR028"

if QUAR028->(Eof())
	Aviso("Notas Promissórias","Não existe NP relacionadas as parametros selecionados.",{"OK"})	
Else
	QUAImpri()
EndIf	

RestArea(aArea)

Return  
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAImpri  ºAutor  ³Cristiane T Polli   º Data ³  02/20/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime a(s) nota(s) promissória(s).                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especificos  Quata                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function QUAImpri()                              

Local cExtenso	:= ''
Local cNomeFav	:= SM0->M0_NOMECOM + " - " +SM0->M0_FILIAL
Local cMunicio	:= SM0->M0_CIDENT
Local aMeses	:= {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"	}
Local nCount	:= 1

Local fonte	     := chr(27) + chr(14)	//expandido 
Local fonte1	 := chr(18)				//normal
Local fonte2	 := chr(15)				//cond
Local fonte3     := chr(20)

While !QUAR028->(Eof())
nCount ++
QUAR028->(dbSkip())
End While

QUAR028->(dbGoTop())

SetRegua(nCount)

While !QUAR028->(Eof()) 

	cNumero		:= alltrim(Str(Val(QUAR028->PB2_NUMNOT)))+"/"+Substr(QUAR028->PB1_DTEMIS,3,2)+"-"+QUAR028->PB2_NPARCE
	cExtenso	:= Upper(extenso(QUAR028->PB2_VLPPAR))
	
	IncRegua("Produtor e Nota: "+QUAR028->PB1_CODPRO+" "+cNumero)
		
	SetPrc(0,0)  
	
	@ Li,020 Psay	fonte2 + cNumero
	@ Li,047 Psay	QUAR028->PB2_VLPPAR				Picture "@E 9,999,999,999.99"	//Valor
	@ Li,095 Psay	fonte2 +  Substr(QUAR028->PB2_DTVENC,7)										//vencimento em dia
	@ Li,110 Psay	fonte2 +  aMeses[val(Substr(QUAR028->PB2_DTVENC,5,2))]						//mes
	@ Li,130 Psay	fonte2 +  Substr(QUAR028->PB2_DTVENC,1,4)									// ano		
	Li	:= Li+5
	@ Li,020 Psay	fonte2 +  cNomeFav															//FAVORECIDO
	Li	:= Li+3
	@ Li,040 Psay	fonte2 +  PADR(cExtenso,97,"*")															//VALOR POR EXTENSO
	Li := Li+1
	@ Li,097 Psay	fonte2 +  PADR(AllTrim(cMunicio),40,"*")						// municipio.
	Li	:= 	Li+3
	@ Li,020 Psay	fonte2 +  AllTrim(QUAR028->PB1_CODPRO)+ "-" +Alltrim(QUAR028->LBB_NOMFOR)	//Nome do emitente
	Li	:= 	Li+2
	@ Li,020 Psay	fonte2 +  "Inscricao: " + AllTrim(QUAR028->LBB_INSCR)													//CGC do emitente
	Li	:= 	Li+2
	@ Li,020 Psay	fonte2 +  "Endereco: "   +  Alltrim(QUAR028->LBB_END)+","+Alltrim(QUAR028->LBB_MUN)+"/"+Alltrim(QUAR028->LBB_EST)
	Li := Li + 2
	@ Li,020 Psay 	""
	For i:= 1 to 4
	@ Li,001 Psay ""
	Li ++
	next
	QUAR028->(dbSkip())    
	Li := 3
EndDo	

If aReturn[5] = 1   
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

Ms_Flush()

Return