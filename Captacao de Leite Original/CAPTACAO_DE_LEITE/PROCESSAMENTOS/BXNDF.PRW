#INCLUDE "PROTHEUS.CH"

User Function BxNDF(lTipo, dDataIni, dDataFim)
Local aSay      := {}
Local aButton   := {}
Local nOption	:= 0
Local cPerg 	:= ""

Default lTipo		:= .T.
Default dDataIni	:= cTod("01/" + strZero(Month(dDataBase), 2) + "/" + Right(Strzero(Year(dDataBase),4),2) )
Default dDataFim 	:= LastDay( dDataIni )

Private cCadastro   := "Fechamento mensal da captação de leite"
cPerg := "BXNDF"

AjustaSx1(cPerg)

Pergunte(cPerg, .F.)

If lTipo

	aAdd(aSay,"Esta rotina transfere as notas de debitos de produtores para a ")
	aAdd(aSay,"rotina de fechamento de captação de leite, permitindo sua compen-")
	aAdd(aSay,"sação de forma automatica durante o fechamento da captação de")
	aAdd(aSay,"leite.")
	
	aAdd(aButton, { 5,.T.,{|| Pergunte( cPerg, .T. ) 	 }}) //Parametros
	aAdd(aButton, { 1,.T.,{|| nOption := 1, FechaBatch() }}) //OK
	aAdd(aButton, { 2,.T.,{|| FechaBatch()               }}) //Cancelar
	
	FormBatch(cCadastro,aSay,aButton) 	
	
	If nOption == 1
		Processa( {|| ProQRY( lTipo, dDataIni, dDataFim, cPerg ) },"Aguarde...","imprimindo o resumo de holeriths.", .T. )
	Endif
	
Else
	ProQry( lTipo, dDataIni, dDataFim, cPerg )
EndIf

Return Nil



Static Function ProQry(lTipo, dDataIni, dDataFim, cPerg)
Local cQuery	:= ""
Local cDataIni  := Dtos(dDataIni)
Local cDataFim  := dTos(dDataFim)
Local aRegtos	:= {}
Local nXa		:= 0 
Local _cMesAno	:= ""

Pergunte( cPerg, .F. )

//_cMesAno	:= Substr( cDataFim, 5, 2 ) + left( cDataFim, 4)
_cMesAno	:= MV_PAR01

cDataIni  := Dtos(MV_PAR02)
cDataFim  := dTos(MV_PAR03)


cQuery := "SELECT SE2.R_E_C_N_O_ as NumReg, LBB.LBB_CODPRO "
cQuery += "FROM " + RetSqlName("SE2") + " SE2 "
cQuery += "INNER JOIN " + RetSqlName("LBB") + " LBB "
cQuery += "ON LBB_FILIAL = '" + xFilial("LBB") + "' "
cQuery += " AND LBB_CODFOR = E2_FORNECE "
cQuery += " AND LBB_LOJA = E2_LOJA AND LBB.D_E_L_E_T_ = ' ' "
cQuery += "WHERE E2_FILIAL = '" + xFilial("SE2") + "' "
cQuery += " AND E2_TIPO = 'NDF' "
cQuery += " AND E2_VENCTO BETWEEN '" + cDataIni + "' AND '" + cDataFim + "' "
cQuery += " AND E2_BAIXA = ' ' "
cQuery += " AND SE2.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY LBB_CODPRO "

memowrit("Tst001.sql", cQuery)

cQuery := ChangeQuery( cQuery )

If Select("TRB1") > 0
	dbSelectArea("TRB1")
	dbCloseArea()
Endif

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'TRB1', .F., .T.)

TcSetField( 'TRB1', "NumReg", "N", 10, 0 )

dbSelectArea("TRB1")
dbGoTop()
ProcRegua(0)

While !Eof()
	IncProc("Buscando NDFs...")
	Aadd( aRegtos, { TRB1->numReg, TRB1->LBB_CODPRO } )
	dbSkip()
End

dbSelectArea("TRB1")
dbCloseArea()
ProcRegua(len(aRegtos))
For nXa := 1 to len( aRegtos )
	cMsg := "Processando NDF " + ALLTRIM(STR(nXa)) + "/" + aLLTRIM(Str(len( aRegtos ))) + "..."
	IncProc(cMsg)
	DoBxSE2(aRegtos[nXa][1], aRegtos[nXa][2], _cMesAno)
next nXa

Return nil



Static Function DoBxSE2( nNumRegSE2, cCodPro, _cMesAno )

Local aAreaSE2 	:= SE2->( GetArea() )
Local aAreaSA2 	:= SA2->( GetArea() )
Local aAreaLBB 	:= LBB->( GetArea() ) 
Local aCabItem	:= {}
Local aCodFor	:= ""
Local aLoja		:= ""
Local nValor	:= 0
Local cModOrig	:= cModulo
Local nModOrig	:= nModulo

dbSelectArea("SE2")
dbGoto( nNumRegSE2 )

dbSelectArea("SA2")
dbSetOrder(1)

cDespesa := GetMV("MV_DESPAD",,"004")

cModulo := "FIN"
nModulo := 6

If dbSeek( xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA ) .and. !empty(cDespesa) // Verifica se existe o fornecedor
	
	dbSelectArea("LBB")
	dbSetOrder(1)
	
	If dbSeek( xFilial("LBB") + cCodPro ) // verifica se existe a propriedade
		
		If LBB->LBB_CODFOR + LBB->LBB_LOJA == SA2->A2_COD + SA2->A2_LOJA // verifica se o fornecedor da propriedade e o mesmo
			
			dbSelectArea("SE2")
			//aCabItem := {}

			cCodFor	:= SE2->E2_FORNECE
			cLoja	:= SE2->E2_LOJA
			nValor	:= SE2->E2_VALOR
			 
			//alteração 01/06/2012 - execauto de baixa de titulo a pagar nao funciona apos atualizacao.
			RecLock("SE2",.F.)
			//baixa titulo
			SE2->E2_BAIXA 		:= SE2->E2_VENCTO
			SE2->E2_MOVIMENT	:= SE2->E2_VENCTO
			SE2->E2_SALDO		:= 0
			SE2->E2_VALLIQ		:= SE2->E2_VALOR
			MsUnlock()
			//movimento bancario de baixa (nao cosidera no banco pois eh dacao)
			RecLock("SE5",.T.)
			
			SE5->E5_FILIAL 	:= SE2->E2_FILIAL
			SE5->E5_DATA	:= SE2->E2_VENCTO
			SE5->E5_TIPO	:= SE2->E2_TIPO
			SE5->E5_MOEDA	:= '01'
			SE5->E5_VALOR	:= SE2->E2_VALOR
			SE5->E5_NATUREZ	:= SE2->E2_NATUREZ
			SE5->E5_RECPAG	:= 'R'
			SE5->E5_BENEF	:= SE2->E2_NOMFOR
			SE5->E5_HISTOR	:= 'BAIXA PARA COMPENSACAO - FECHAMENTO DE LEITE'
			SE5->E5_TIPODOC	:= 'BA'
			SE5->E5_VLMOED2	:= SE2->E2_VALOR
			SE5->E5_PREFIXO	:= SE2->E2_PREFIXO
			SE5->E5_NUMERO	:= SE2->E2_NUM
			SE5->E5_PARCELA	:= SE2->E2_PARCELA
			SE5->E5_CLIFOR	:= SE2->E2_FORNECE
			SE5->E5_LOJA	:= SE2->E2_LOJA
			SE5->E5_DTDIGIT	:= dDataBase
			SE5->E5_MOTBX	:= 'DAC'
			SE5->E5_SEQ		:= '01'
			SE5->E5_DTDISPO	:= SE2->E2_VENCTO
			SE5->E5_FILORIG	:= SE2->E2_FILIAL
			SE5->E5_FORNECE	:= SE2->E2_FORNECE
			SE5->E5_MSFIL	:= SE2->E2_FILIAL
			
			MsUnlock()
			 
						
			
			//aAdd(aCabItem,{"E2_PREFIXO",  SE2->E2_PREFIXO,       								NIL})
			//aAdd(aCabItem,{"E2_NUM",      SE2->E2_NUM,       									NIL})
			//aAdd(aCabItem,{"E2_PARCELA",  SE2->E2_PARCELA,       								NIL})
			//aAdd(aCabItem,{"E2_TIPO",     SE2->E2_TIPO,       									NIL})
			//aAdd(aCabItem,{"E2_FORNECE",  SE2->E2_FORNECE,       								NIL})
			//aAdd(aCabItem,{"E2_LOJA",     SE2->E2_LOJA,       									NIL})
			//aAdd(aCabItem,{"E2_MOEDA",     SE2->E2_MOEDA,      									NIL})
			//aAdd(aCabItem,{"AUTMOTBX",    'DAC',       											NIL})
			//aAdd(aCabItem,{"AUTBANCO",    ' ',       											NIL})
			//aAdd(aCabItem,{"AUTAGENCIA",  ' ',       											NIL})
			//aAdd(aCabItem,{"AUTCONTA",    ' ',       											NIL})
			//aAdd(aCabItem,{"AUTDTBAIXA",  SE2->E2_VENCTO,       								NIL})
			//aAdd(aCabItem,{"AUTHIST",     'BAIXA PARA COMPENSACAO - FECHAMENTO DE LEITE',      NIL})
			//aAdd(aCabItem,{"AUTDESCONT",  0,       												NIL})
			//aAdd(aCabItem,{"AUTMULTA",    0,       												NIL})
			//AADD(aCabItem,{"AUTJUROS",    0,		  											Nil})
			//aAdd(aCabItem,{"AUTOUTGAS",   0,  				      								NIL})
			//aAdd(aCabItem,{"AUTVLRPG",    SE2->E2_VALOR,      			 						NIL})
			//aAdd(aCabItem,{"AUTVLRME",    0,       												NIL})
			//aAdd(aCabItem,{"E2_FILIAL",   SE2->E2_FILIAL,       								NIL})
			//			aAdd(aCabItem,{"AUTCHEQUE",   ' ',     												".T."})
			
			//If Len(aCabItem) > 0
			//	LMSErroAuto := .F.
			//	lMsHelpAuto := .T.
			//	MSExecAuto({|x,y| Fina080(x,y)},aCabItem,3)
				
		//		If LMSErroAuto
					//	erro na inclusao, gravar log de erro
		 //			cErro := "Baixa Titulo numero " + aBaixas[nXa,14] + "/" + AbAIXAS[NXA][016] + " ignorado. Motivo: "
		   //			cErro += "Discriminado no arquivo " + nomeautolog()
					//lOk := U_GrvLog( cRotina, cExecuta, cHoraIni, dDataIni, cErro )
					cNum := ""
					//__cFileLog := ""
				//Else
					GrvDesp(cCodPro, cCodFor, cLoja, nValor, _cMesAno)
				//Endif
			//Endif
			
		Endif
		
	Endif
Endif

cModulo := cModOrig
nModulo := nModOrig

RestArea(aAreaLBB)
RestArea(aAreaSA2)
RestArea(aAreaSE2)

Return nil



Static Function GrvDesp(cCodPro, cCodFor, cLoja, nValor, _cMesAno)
Local lGravado 	:= .F.
Local cCodFor1	:= ""
Local cCodLoj1  := ""
Local cDespesa	:= ""
Local cSeq1		:= Padl("1", TamSX3("PA8_SEQUEN")[1], "0" )
Local cSeq2		:= Padl("1", TamSX3("PA6_SEQ")[1], "0" )

cDespesa := GetMV("MV_DESPAD",,"004")

dbSelectArea("PA8")
dbSetOrder(1)
If dbSeek( xFilial("PA8") + cDespesa + cSeq1 )
	cCodFor1 := PA8->PA8_FORNEC
	cCodLoj1 := PA8->PA8_LOJA
Endif

If !Empty(cCodFor1) .and. !empty(cCodLoj1)
	
	dbSelectArea("PA5")
	dbSetOrder(1) // PA5_FILIAL, PA5_FORNEC, PA5_LOJA, PA5_PERIOD, R_E_C_N_O_, D_E_L_E_T_
	If !dbSeek( xFilial("PA5") + cCodFor1 + cCodLoj1 + _cMesano + cDespesa )
		RecLock("PA5", .T.)
		
		PA5->PA5_FILIAL	:= xFilial("PA5")
		PA5->PA5_FORNEC	:= cCodFor1
		PA5->PA5_LOJA	:= cCodLoj1
		PA5->PA5_TIPDES	:= cDespesa
		PA5->PA5_PERIOD	:= _cMesAno
		PA5->PA5_VENCTO	:= cTod( "01/" + Left(_cMesAno,2) + "/" + Right(_cMesAno,4) )
		PA5->PA5_VALOR  := nValor
		PA5->PA5_DOC    := _cMesAno
		
		MsUnlock()
	Else
		RecLock("PA5", .F.)
		PA5->PA5_VALOR  := PA5->PA5_VALOR + nValor
		MsUnlock()
	Endif
	
	cSeq2 := MaxSeq2(xFilial("PA6"), cCodFor1, cCodLoj1, _cMesAno)
	
	RecLock("PA6", .T.)
	PA6->PA6_FILIAL	:= xFilial("PA6")
	PA6->PA6_FORNEC	:= cCodFor1
	PA6->PA6_LOJA	:= cCodLoj1
	PA6->PA6_PERIOD	:= _cMesAno
	PA6->PA6_SEQ	:= cSeq2
	PA6->PA6_CODPRO	:= cCodPro
	PA6->PA6_VALOR	:= nValor
	PA6->PA6_DOC	:= _cMesAno
	PA6->PA6_OBSERV	:= "COMPENSACAO FECHAMENTO DE LEITE"
	PA6->PA6_TIPDES	:= cDespesa
	MsUnlock()
	
Endif
Return Nil




Static Function MaxSeq2(cFilPA6, cCodPA6, cLojPA6, cPeriodo)
Local cQuery 	:= ""
Local cRet		:= ""
Local aAreaSav	:= GetArea()

cQuery := "SELECT MAX(PA6_SEQ) ULTSEQ FROM " + RetSqlName("PA6") + " PA6 "
cQuery += "WHERE PA6_FILIAL = '" + cFilPa6 + "' "
cQuery += " AND PA6_FORNEC = '" + cCodPA6 + "' "
cQuery += " AND PA6_LOJA = '" + cLojPA6 + "' "
cQuery += " AND PA6_PERIOD = '" + cPeriodo + "' "
cQuery += " AND PA6.D_E_L_E_T_ = ' ' "

If Select("TRB2") > 0
	dbSelectArea("TRB2")
	dbCloseArea()
Endif

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'TRB2', .F., .T.)

dbSelectArea("TRB2")
dbGotop()

If !eof()
	cRet := TRB2->ULTSEQ
Else
	cRet := strZero(0, TamSX3("PA6_SEQ")[1])
Endif

dbSelectArea("TRB2")
dbCloseArea()

RestArea(aAreaSav)

cRet := Soma1(cRet)
Return cRet




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³AjustaSX1 ³ Autor ³  Andreia J Silva      ³ Data ³30/06/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta perguntas no SX1.                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSx1(cPerg)
cPerg := Left(cPerg,6)

PutSx1(cPerg,"01","Periodo fechamento?" ,"","","mv_ch1","C",06,0,0,"G","", " ", " ", " ", "mv_par01")
PutSx1(cPerg,"02","Vencimento NDF De?" , "","","mv_ch2","D",08,0,0,"G","", " ", " ", " ", "mv_par02")
PutSX1(cPerg,"03","Vencimento NDF Até?", "","","mv_ch3","D",08,0,0,"G","", " ", " ", " ", "mv_par03")


Return
