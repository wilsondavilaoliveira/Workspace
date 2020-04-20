#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "protheus.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF1100I   ºAutor  ³ Evaldo V. Batista  º Data ³  02/29/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para estorno de desconto de contrato de           º±±
±±º          ³ fornecimento                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10 / Desconto Grandes Redes                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
///////////////////////
User Function SF1100I()
///////////////////////
Local nPerDesc	:= 0
Local nPerPag	:= 0
Local nDescUni	:= 0
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local cAliasQry := GetNextAlias()
Local cMotBaix	:= GetMv('ES_MOTBAIX',.F.,'EDC')
Local _aTit		:= {}
Local cChave
Local aArea   := GetArea()
Local aAreaE2 := SE2->(GetArea())
Local cPrefixo := AllTrim(&(GetMv("MV_1DUPREF"))) 
Local nCtrPerc := 0 
Local aItensCtr := {} 
Local aZB6 := {} 
Local cQuery := ''
Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.

// Cadu em 30/04/08
// Volta o conteudo do campo D1_SERIORI que foi alterado no PE SD1100I, para que a compensacao automatica seja efetuada.
// Informacoes adicionais:
// Para que o processo de devolucao de venda com compensacao automatica do titulo e necessario os pre-requisitos abaixo:
// 1- Deixar o parametro MV_CMPDEVV = T;
// 2- O titulo original a ser compensado com a NCC a ser gerada deve estar em carteira(E1_SITUACA = 0) e com valor igual a origem;
// 3- Caso o sistema esteja configurado para gravar o prefixo do titulo diferente da serie da nota,
// utilizar o ponto de entrada SD1100I para gravar o campo D1_SERIORI no campo criado D1_SERIOR2, e gravar
// no campo D1_SERIORI o campo F2_PREFIXO, pois o campo D1_SERIORI e utilizado na query no MATA103 para
// selecionar o titulo original;
// 4- Depois utilizar o ponto de entrada SF1100I, para voltar o conteudo do campo D1_SERIORI com o D1_SERIOR2

// WILSON 19/08/2013 - COMPENSACAO AUTOMATICA DE CONTAS A RECEBER AO RETORNAR DOCUMENTO DE SAIDA
// RETORNADO AO PADRAO DO SISTEMA, MICROSIGA ACERTOU A ROTINA NAO EH NECESSARIO MAIS ESSA ACAO
// cUpdate := "UPDATE " + RetSQLName("SD1")
// cUpdate += " SET D1_SERIORI = D1_SERIOR2 "
// cUpdate += " WHERE D1_FILIAL 	= '"+xFilial("SD1")	+ "' AND "
// cUpdate += " D1_DOC   			= '"+SF1->F1_DOC		+ "' AND "
// cUpdate += " D1_SERIE 			= '"+SF1->F1_SERIE	+ "' AND "
// cUpdate += " D1_FORNECE 		= '"+SF1->F1_FORNECE	+ "' AND "
// cUpdate += " D1_LOJA 			= '"+SF1->F1_LOJA		+ "' AND "
// cUpdate += " D1_TIPO 			<> 'C'  AND" 
// cUpdate += " D1_FILIAL          <> '06' AND " 
// cUpdate += " D_E_L_E_T_ = ' '"
// TCSQLExec(cUpdate ) //executo o update na string cUpdate
// TCSQLExec("COMMIT") //por GARANTIA dou um COMMIT

//Cadu

If SF1->F1_TIPO == 'D' .And. !Empty(cMotBaix) .And. SF1->F1_FORMUL <> 'S' 	// Deve funcionar somente para devolucao
	
	nPerDesc := 0 
	SB1->(dbSetOrder(1)) 
	dbSelectArea("SD1") 
	SD1->(dbSetOrder(1)) 
	SD1->(MsSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)) 
	
	While (SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA == ;
		SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA) .AND. SD1->( !Eof() ) 
		SB1->(MsSeek(xFilial("SB1")+SD1->D1_COD,.T.))       
		aZB6 := {} 
		aItensCtr := {} 
		// BUSCA QUAL CONTRATO ATIVO PARA O PRODUTO 
			aZB6 := U_GetCtrW(SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_FILIAL,dtos(SF1->F1_EMISSAO),SD1->D1_COD,SB1->B1_XCATEGO,SB1->B1_XMARCA)

		// SE EXISTIR O CONTRATO ADICIONA OS ITENS DE ACORDO COM O PRODUTO			
		If !Empty(aZB6) 
			U_ItCtrW(aZB6,SD1->D1_TOTAL,@aItensCtr,SD1->D1_ICMSRET)
		EndIf
		
		If Empty( aItensCtr ) 
			
			nDescUni := 0 
			nDescUni += ( ( ( SD1->D1_TOTAL + SD1->D1_ICMSRET ) * SD1->D1_XPERDES ) / 100 ) 
			nPerDesc += ( ( ( SD1->D1_TOTAL + SD1->D1_ICMSRET ) * SD1->D1_XPERDES ) / 100 ) 
			RecLock("SD1",.F.)  
			SD1->D1_XVLRDES := nDescUni 	// WMS.NN em 07-12-2015 em atendimento do chamado 2418 - Gravar valores de desconto => Funcionalidade solicitada por Jullian. 
			MsUnLock()
		
		Else 
		
			nDescUni := 0 
			
			For nCtrPerc := 1 To Len(aItensCtr)  
				If aItensCtr[nCtrPerc,8] == "S" 	// Considerar DEVOLUCOES
					nDescUni += ( ( aItensCtr[nCtrPerc,9] * aItensCtr[nCtrPerc,3]  ) / 100 )
					If aItensCtr[nCtrPerc,2] <> '3'
						nPerDesc += ( ( aItensCtr[nCtrPerc,9] * aItensCtr[nCtrPerc,3]  ) / 100 )
					Else
						nPerPag += ( ( aItensCtr[nCtrPerc,9] * aItensCtr[nCtrPerc,3]  ) / 100 )
					End If
				EndIf
		Next nCtrPerc 
			
			RecLock("SD1",.F.) 
			SD1->D1_XVLRDES := nDescUni 	  
			MsUnLock()

		EndIf 
		
		// WMS.EN em 03-12-2015 em atendimento do chamado 2418 - Tratar Devoluções conforme Contratos / Verbas do Cliente 
	
		SD1->( dbSkip() )
	
	EndDo
	
		ZAE->(dbSetOrder(1))

		//Se o cliente estiver na tabela ZAE segue o padrao (NCC) a receber, se nao encontrar exclui a NCC e lanca titulo a pagar
		//if cFilAnt == '01' .AND. !ZAE->(DbSeek(xFilial('ZAE')+ SF1->F1_FORNECE))
		//Retirada opcao para filial 01, vale para todas as filias - pedido Luiz 21/08/2014
	
	If nPerDesc > 0 .and. ZAE->(DbSeek(xFilial('ZAE')+ SF1->F1_FORNECE))

		cQuery := "SELECT SE1.R_E_C_N_O_ AS NUMREG "
		cQuery += "	FROM " + RetSqlTab('SE1')
		cQuery += "		WHERE SE1.D_E_L_E_T_ <> '*' "
		cQuery += "			AND SE1.E1_FILIAL = '"+xFilial('SE1')+"' "
		cQuery += "			AND SE1.E1_PREFIXO = '"+SF1->F1_PREFIXO+"' "
		cQuery += "			AND SE1.E1_NUM = '"+SF1->F1_DUPL+"' "
		cQuery += "			AND SE1.E1_TIPO = 'NCC'  "
		cQuery += "			AND SE1.E1_CLIENTE = '"+SF1->F1_FORNECE+"' "
		cQuery += "			AND SE1.E1_LOJA = '"+SF1->F1_LOJA+"' "
		dbUseArea( .T., 'TOPCONN', TcGenQry(,,cQuery), cAlias, .F., .F.)
		
		While !(cAlias)->( Eof() )
			
			SE1->( dbGoTo( (cAlias)->NUMREG ) )
			
			If SE1->E1_SALDO >= nPerDesc
		
				_aTit := {}
						
				_aTit := { 	{"E1_PREFIXO"  ,SE1->E1_PREFIXO            	 	,Nil},;
							{"E1_NUM"      ,SE1->E1_NUM 	             	,Nil},;
							{"E1_PARCELA"  ,SE1->E1_PARCELA              	,Nil},;
							{"E1_TIPO"     ,'NCC'		                 	,Nil},;
							{"E1_CLIENTE"  ,SE1->E1_CLIENTE              	,Nil},;
							{"E1_LOJA"     ,SE1->E1_LOJA                 	,Nil},;
							{"AUTDESCONT"  ,0  								,Nil},;
							{"AUTMULTA"	   ,0         						,Nil},;       
				   			{"AUTJUROS"	   ,0                      			,Nil},;
					   		{"AUTMOTBX"    ,cMotBaix                        ,Nil},; 
			   				{"AUTBANCO"    ,""                           	,Nil},;
				   			{"AUTAGENCIA"  ,""                           	,Nil},;
					   		{"AUTCONTA"    ,""                           	,Nil},;
						   	{"AUTDTBAIXA"  ,dDataBase                      	,Nil},;
			   				{"AUTDTCREDITO",dDataBase                      	,Nil},;
				   			{"AUTHIST"     ,'Estorno Desconto Concedido'    ,Nil},;
					   		{"AUTVALREC"   ,nPerDesc                     	,Nil}}
					
				
				MSExecAuto({|x, y| FINA070(x, y)}, _aTit, 3) 
				
				
				If  lMsErroAuto	 
					MOSTRAERRO()
				EndIf
			
			End If
			
			(cAlias)->( dbSkip() )
			
		EndDo
		
		(cAlias)->( dbCloseArea() )
	
	EndIf

	/*wilson 28/11/19 chamado 005116*/
	
	SA1->(dbSetOrder(1))
	SA1->(DbSeek(xFilial('SA1')+ SF1->F1_FORNECE+SF1->F1_LOJA))
	
	cForCon	:= SA1->A1_XFORNEC
	cLjfCon	:= SA1->A1_XLJFORN
	aCpoSE2 := {}
	
	If nPerPag > 0 .AND. (!Empty(SA1->A1_XFORNEC) .AND. !Empty(SA1->A1_XLJFORN))

		AADD(aCpoSE2,{"E2_FILIAL"  ,xFilial("SE2")												,Nil})
		AADD(aCpoSE2,{"E2_PREFIXO" ,Pad(SF1->F1_PREFIXO,Len(SE2->E2_PREFIXO))					,Nil})
		AADD(aCpoSE2,{"E2_NUM"     ,Pad(SF1->F1_DUPL,Len(SE2->E2_NUM))							,Nil})
		AADD(aCpoSE2,{"E2_PARCELA" ,Pad(" ",Len(SE2->E2_PARCELA))								,Nil})
		AADD(aCpoSE2,{"E2_TIPO"    ,Pad("NDF",Len(SE2->E2_TIPO))								,Nil})
		AADD(aCpoSE2,{"E2_NATUREZ" ,Pad("DSC",Len(SE2->E2_NATUREZ))							,Nil})
		AADD(aCpoSE2,{"E2_FORNECE" ,Pad(cForCon,Len(SE2->E2_FORNECE))							,Nil})
		AADD(aCpoSE2,{"E2_LOJA"    ,Pad(cLjfCon,Len(SE2->E2_LOJA))								,Nil})
		AADD(aCpoSE2,{"E2_EMISSAO" ,SF1->F1_EMISSAO												,Nil})
		AADD(aCpoSE2,{"E2_VENCTO"  ,dDatabase													,Nil})
		AADD(aCpoSE2,{"E2_VALOR"   ,nPerPag														,Nil})
		AADD(aCpoSE2,{"E2_ORIGEM"  ,Pad("PAGDEV",Len(SE2->E2_ORIGEM))							,Nil})
		AADD(aCpoSE2,{"E2_HIST"    ,Pad("NF DEVOLUCAO-ESTORNO DESC CONCEDIDO",Len(SE2->E2_HIST)),Nil})
		AADD(aCpoSE2,{"E2_CCD"     ,Pad("999999",Len(SE2->E2_CCD))								,Nil})

		lMsErroAuto:=.F.
		lMSHelpAuto:= .T.
		INCLUI := .T.

		MSExecAuto( { | x, y, z | Fina050( x, y, z ) }, aCpoSE2,, 3 )

		If lMsErroAuto
		
			U_QUTSMAIL("Erro Inclusao NDF PAGDEV:","Erro Inclusao NDF PAGDEV GERADO POR DEVOLUCAO: NF - " + SF1->F1_DUPL,,'fernando.bonacordi@quataalimentos.com.br;wilson.oliveira@quataalimentos.com.br;andreia.bezerra@quataalimentos.com.br')
			Mostraerro()
			
		Else
		
		End If

	EndIf

EndIf




If !SF1->F1_TIPO $ "BD"
	aAreaE2 := SE2->(GetArea())
	dbSelectArea("SF1")
	dbSetOrder(1)
	nVlrTit := 0.00
	nVlrCsl := 0.00
	nVlrPis := 0.00
	nVlrCof := 0.00
	nVlrIrf := 0.00
	nVlrIss := 0.00
	dbSelectArea("SE2")
	SE2->(dbSetOrder(6))  // E2_FILIAL + E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO.
	cChave  := xFilial("SE2") + SF1->F1_FORNECE + SF1->F1_LOJA + cPrefixo + SF1->F1_DOC
	MSSeek(cChave)
	While SE2->(!eof() .and. E2_FILIAL + E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM == cChave)
		If SE2->E2_NUM == SF1->F1_DOC .and. AllTrim(SE2->E2_TIPO) == "NF"
			nVlrTit += SE2->E2_VALOR
			nVlrCsl += SE2->E2_VRETCSL
			nVlrPis += SE2->E2_VRETPIS
			nVlrCof += SE2->E2_VRETCOF
			nVlrIrf += SE2->E2_IRRF
			nVlrIss += SE2->E2_ISS
		Endif
		dbSkip()
	End
	dbSelectArea("SF1")
	RecLock("SF1",.F.)
	SF1->F1_XVLRTIT := nVlrTit
	SF1->F1_XVLRCSL := nVlrCsl
	SF1->F1_XVLRPIS := nVlrPis
	SF1->F1_XVLRCOF := nVlrCof
	SF1->F1_XVLRIRF := nVlrIrf
	SF1->F1_XVLRISS := nVlrIss
	MsUnLock()
	// Restaura as areas de trabalho.
	SE2->(RestArea(aAreaE2))
Endif

//========================================================================================================
//CHAMADO 9667 24/05/2019 - WILSON
aAreaF1 := GetArea()

If SF1->F1_TIPO == "D" .AND. SF1->F1_FORMUL == "S"
		
	SD1->(dbSetOrder(1))
	
	If SD1->(dbSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
	
		
		//Query para selecionar os titulos de AB- e NCC originado de contrato
		cQuery := " SELECT R_E_C_N_O_ REC,E1_SITUACA SITUACA,E1_EMISSAO EMISSAO, "
		cQuery += " E1_PREFIXO PREFIXO,E1_NUM NUMERO,E1_PARCELA PARCELA,E1_CLIENTE CLIENTE,E1_LOJA LOJA,E1_SALDO SALDO "
		cQuery += " FROM "+RetSqlName("SE1")+" SE1 (NOLOCK) "
		cQuery += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' "
		cQuery += " AND E1_NUM = '"+SD1->(D1_NFORI)+"' "
		cQuery += " AND E1_CLIENTE = '"+SD1->(D1_FORNECE)+"' "
		cQuery += " AND E1_LOJA = '"+SD1->(D1_LOJA)+"' "
		cQuery += " AND E1_NATUREZ = 'DSC' "
		cQuery += " AND E1_TIPO IN ('NCC') "
		cQuery += " AND E1_SALDO = E1_VALOR "
		cQuery += " AND SE1.D_E_L_E_T_ = '' "

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.t.,.f.)

		While (cAliasQry)->( !Eof() )

			cMsg := ""

			//Caso o titulo esteja em carteira e esteja dentro do mes e ano de devolucao, delete o registro
			If (cAliasQRy)->SITUACA == "0" //.and. SubStr((cAliasQRy)->EMISSAO,1,6) == SubStr(Dtos(SD1->D1_DTDIGIT),1,6)
				
				SE1Area := GetArea()
				
				SE1->( dbGoTo((cAliasQry)->REC) )
				
				lMsErroAuto := .F.
				SE1->( dbGoTo((cAliasQry)->REC) )
				
				_aTit := {}
							
				_aTit := { 	{"E1_PREFIXO"  ,(cAliasQRy)->PREFIXO       	 	,Nil},;
							{"E1_NUM"      ,(cAliasQRy)->NUMERO 	       	,Nil},;
							{"E1_PARCELA"  ,(cAliasQRy)->PARCELA           	,Nil},;
							{"E1_TIPO"     ,'NCC'		                 	,Nil},;
							{"E1_CLIENTE"  ,(cAliasQRy)->CLIENTE           	,Nil},;
							{"E1_LOJA"     ,(cAliasQRy)->LOJA              	,Nil},;
							{"AUTDESCONT"  ,0  								,Nil},;
							{"AUTMULTA"	   ,0         						,Nil},;       
				   			{"AUTJUROS"	   ,0                      			,Nil},;
					   		{"AUTMOTBX"    ,'EDC'                           ,Nil},; 
			   				{"AUTBANCO"    ,""                           	,Nil},;
				   			{"AUTAGENCIA"  ,""                           	,Nil},;
					   		{"AUTCONTA"    ,""                           	,Nil},;
						   	{"AUTDTBAIXA"  ,dDataBase 				    	,Nil},;
			   				{"AUTDTCREDITO",dDataBase     					,Nil},;
				   			{"AUTHIST"     ,'Estorno Desconto Concedido'    ,Nil},;
					   		{"AUTVALREC"   ,(cAliasQRy)->SALDO             	,Nil}}
				
				
							//{"AUTDTBAIXA"  ,STOD((cAliasQRy)->EMISSAO)     	,Nil},;
			   				//{"AUTDTCREDITO",STOD((cAliasQRy)->EMISSAO)     	,Nil},;
				
				MSExecAuto({|x, y| FINA070(x, y)}, _aTit, 3) 
					
				If  lMsErroAuto	 
				cErrolog := MemoRead(NomeAutolog())
				MostraErro()
				DisarmTransaction()
				EndIf
			
				RestArea(SE1Area)
			
			End If
		
		(cAliasQry)->( dbSkip() )	
		
		EndDo
		//BAIXA TITULO A PAGAR
		
		SA1->(dbSetOrder(1))
		SA1->(DbSeek(xFilial('SA1')+ SF1->F1_FORNECE+SF1->F1_LOJA))

		If !Empty(SA1->A1_XFORNEC) .AND. !Empty(SA1->A1_XLJFORN)
			cForn	:= SA1->A1_XFORNEC
			cLojaf	:= SA1->A1_XLJFORN
		Else
			cForn	:= ""
			cLojaf	:= ""
		End If
		
		//Query para selecionar os titulos DSC no contas a pagar originado de contrato
		cQuery := " SELECT R_E_C_N_O_ REC,E2_NUM,E2_TIPO,E2_NATUREZ,E2_SALDO,E2_PREFIXO,E2_PARCELA "
		cQuery += " FROM "+RetSqlName("SE2")+" SE2 (NOLOCK) "
		cQuery += " WHERE E2_FILIAL = '" + SF1->F1_FILIAL + "' "
		cQuery += " AND E2_NUM = '"+SD1->(D1_NFORI)+"' "
		cQuery += " AND E2_FORNECE = '"+cForn+"' "
		cQuery += " AND E2_LOJA = '"+cLojaf+"' "
		cQuery += " AND E2_NATUREZ = 'DSC' "
		cQuery += " AND E2_PREFIXO = 'DSC' "
		cQuery += " AND E2_TIPO  = 'NF' "
		cQuery += " AND E2_SALDO>0 "
		cQuery += " AND SE2.D_E_L_E_T_ = '' "
		
		cAliasE2 := "cAliasE2" 
		
		If Select(cAliasE2) > 0
			DbSelectArea(cAliasE2)
			(cAliasE2)->( DbCloseArea() )
		EndIf
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasE2,.T.,.F.)
			
			aCpoSE2 := {}
			While (cAliasE2)->( !Eof() )	
			
				AADD(aCpoSE2,{"E2_FILIAL"  ,xFilial("SE2")										,Nil})
				AADD(aCpoSE2,{"E2_PREFIXO" ,Pad((cAliasE2)->(E2_PREFIXO),Len(SE2->E2_PREFIXO))	,Nil})
				AADD(aCpoSE2,{"E2_NUM"     ,Pad((cAliasE2)->(E2_NUM)	,Len(SE2->E2_NUM))		,Nil})
				AADD(aCpoSE2,{"E2_PARCELA" ,Pad((cAliasE2)->(E2_PARCELA),Len(SE2->E2_PARCELA))	,Nil})
				AADD(aCpoSE2,{"E2_TIPO"    ,Pad((cAliasE2)->(E2_TIPO)	,Len(SE2->E2_TIPO))		,Nil})
				AADD(aCpoSE2,{"E2_NATUREZ" ,Pad((cAliasE2)->(E2_NATUREZ),Len(SE2->E2_NATUREZ))	,Nil})
				AADD(aCpoSE2,{"E2_FORNECE" ,Pad(cForn					,Len(SE2->E2_FORNECE))	,Nil})
				AADD(aCpoSE2,{"E2_LOJA"    ,Pad(cLojaf					,Len(SE2->E2_LOJA))		,Nil})
				aAdd(aCpoSE2,{"AUTMOTBX",    'EDC',       										NIL})
				aAdd(aCpoSE2,{"AUTBANCO",    ' ',       										NIL})
				aAdd(aCpoSE2,{"AUTAGENCIA",  ' ',       										NIL})
				aAdd(aCpoSE2,{"AUTCONTA",    ' ',       										NIL})
				aAdd(aCpoSE2,{"AUTDTBAIXA",  dDataBase,       									NIL})
				aAdd(aCpoSE2,{"AUTHIST",     'Estorno Desconto Concedido-DEVOLUCAO',			NIL})
				aAdd(aCpoSE2,{"AUTDESCONT",  0,       											NIL})
				aAdd(aCpoSE2,{"AUTMULTA",    0,       											NIL})
				aAdd(aCpoSE2,{"AUTJUROS",    0,		  											Nil})
				aAdd(aCpoSE2,{"AUTOUTGAS",   0,  				      							NIL})
				aAdd(aCpoSE2,{"AUTVLRPG",    (cAliasE2)->(E2_SALDO),	 						NIL})
				aAdd(aCpoSE2,{"AUTVLRME",    0,       											NIL})
				aAdd(aCpoSE2,{"AUTCHEQUE",   ' ',     											".T."})
	
	
				LMSErroAuto := .F.
				lMsHelpAuto := .T.
				
				MSExecAuto({|a,b,c,d,e,f| Fina080(a,b,c,d,e,f)},aCpoSE2,3,Nil,Nil,Nil,.F.)  // NAO Contabiliza On-Line
				
				If lMsErroAuto
					U_QUTSMAIL("Erro BAIXA EDC PAGDEV:","Erro BAIXA EDC ORIGINADO DE DEVOLUCAO FORMULARIO PROPRIO: NF - " + SF1->F1_DUPL,,'fernando.bonacordi@quataalimentos.com.br;wilson.oliveira@quataalimentos.com.br;andreia.bezerra@quataalimentos.com.br')
					Mostraerro()
				Else
			
				End If
			
				(cAliasE2)->( dbSkip() )
			EndDo
	
	End If



End If

RestArea(aAreaF1)

Return
