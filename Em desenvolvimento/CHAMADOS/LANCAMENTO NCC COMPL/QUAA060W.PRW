#INCLUDE 'Protheus.ch'

#define		FORMADESC 	2
#define		PERCENTUAL	3
#define		PREFIXO		4
#define		FORMACALC	5
#define		CCONTRATO	6
#define		NUMREVISAO	7

STATIC cStcCodCli
STATIC cStcLojCli
STATIC cStcSetor
STATIC dStcData
STATIC nStcPercen
STATIC nStcOpcao

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAA060   ºAutor  ³Sabrina Moreira     º Data ³  31/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     |Rotina utilizada para tratar os contratos.                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Queijos Quata                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QUAA060W(nOpcao,cCliente,cLoja,cSetor,dAtual,cProduto,lPed,cCli,cLoja,cFilC5,dDtC5,lRet,cCodCon,nRevisao,lConsNF)

	Local aAreaSE1 	:= SE1->(GetArea())
	Local aAreaSE2 	:= SE2->(GetArea())
	Local aAreaZB4 	:= ZB4->(GetArea())
	Local aAreaZB5 	:= ZB5->(GetArea())
	Local aAreaZB6 	:= ZB6->(GetArea())
	Local aAreaSD1 	:= SD1->(GetArea())
	Local aAreaSF1 	:= SF1->(GetArea())
	Local cContrato 	:= ""
	Local nRet 		:= 0
	Local nTotNF 	:= SF2->F2_VALBRUT
	Local nTotDupl 	:= SE1->E1_VALOR
	Local cFilF2		:= Iif(nOpcao == 6,SF1->F1_FILIAL,SF2->F2_FILIAL)
	Local _nA		:= 0
	Local nCount		:= 0
	Local cQuery		:= ""
	Local cAliasTRB 	:= GetNextAlias()
	Local aCpoSE1	:= {}
	Local aCpoSE2	:= {}
	Local nTotPNf	:= 0
	Local nTotPDup	:= 0
	Local nTotCom	:= 0
	Local lContinua	:= .T.
	Local aArea		:= GetArea()
	Local nPos		:= 0
	Local aZB6		:= {}
	Local nValAB		:= 0
	Local lCliCont   := .F. //ZB6->( FieldPos( "ZB6_XFORNE" ) ) > 0 .And. ZB6->( FieldPos( "ZB6_XLJFOR" ) ) > 0
	Local cLojFor
	Local cForn
	
	DEFAULT cCliente 	:= SF2->F2_CLIENTE
	DEFAULT cLoja		:= SF2->F2_LOJA
	DEFAULT dAtual		:= dDataBase
	DEFAULT lConsNF		:= .F.
	
	Private aItensCtr 	:= {}
	Private nValTit		:= 0
	Private cCodCli		:= ""
	Private cLojCli		:= ""
	Private cDuplic		:= ''
	Private xPrefixo	:= SE1->E1_PREFIXO
	Private xNum		:= SE1->E1_NUM
	Private xParc		:= SE1->E1_PARCELA
	Private xTipo		:= SE1->E1_TIPO
	Private xValor		:= SE1->E1_VALOR
	Private xRec		:= SE1->( Recno() )
	Private nRecSE2
	Private nValNF		:= SF2->F2_VALBRUT
	Private nValProd	:= SF2->F2_VALMERC
	Private lConsNF1	:= lConsNF
// Busco Pedido nos Itens 
	lPed := iif(lPed == NIL,.F.,lPed)

	If !lped
		SD2->( DbSetOrder(3) ) //D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM
		SD2->(dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+cCliente+cLoja,.T.))
	EndIf
	If Select( "SC5" ) == 0
		ChkFile("SC5")
	EndIf
	SC5->( DbSetOrder(1) )
	SC5->( DbSeek(xFilial("SC5") + SC6->C6_NUM, .T.) ) 		// SC5->( DbSeek(xFilial("SC5")+SD2->D2_PEDIDO,.T.) ) // Quando nOpcao=2, D2_PEDIDO estava ponteirado em outro registro
// WMS.SN em 03-12-2015 em atendimento ao chamado 2418 
	If SD2->D2_FILIAL + SD2->D2_PEDIDO <> SC6->C6_FILIAL + SC6->C6_NUM  	// Em alguns casos, a SD2 estava desponteirada
		SD2->( DbSetOrder(3) ) //D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM
		SD2->(dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+cCliente+cLoja,.T.))
	EndIf
// WMS.EN em 03-12-2015 em atendimento ao chamado 2418 
	cDuplic := SF2->F2_DUPL

// Busco Setor no Pedido  
	DEFAULT cSetor := SC5->C5_XSETOR
	cCodCli	:= cCliente
	cLojCli	:= cLoja

	If !Empty(cStcCodCli)  .And. cStcCodCli == cCodCli .And.;
			!Empty(cStcLojCli) .And. cStcLojCli == cLojCli .And.;
			!Empty(cStcSetor)  .And. cStcSetor  == cSetor  .And.;
			ValType(nStcPercen)=='N' .And. nOpcao == nStcOpcao
		nRet := nStcPercen
		lContinua := .F.
	EndIf

	If nOpcao == 5 .Or. nOpcao == 6
		nRet := 0
	EndIf

	If Empty( cDuplic ) .And. nOpcao >= 2 .And. nOpcao <= 3
		lContinua := .F.
	EndIf

	If lContinua .Or. nOpcao == 5 .Or. nOpcao == 6
	
		aItensCtr := {}
	// BUSCA CONTRATO DE ACORDO COM O PRODUTO 
		If nOpcao <> 5 .And. nOpcao <> 6   // gerar contas a receber
			
			SD2->(dbSetOrder(3)) //POSICIONA NO ITEM DA NOTA
			SD2->(MsSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.))
			While SD2->( !Eof() ) .And. SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA == ;
					SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
			// POSICIONA NO PRODUTO
				SB1->(dbSetOrder(1))
				SB1->(MsSeek(xFilial("SB1")+SD2->D2_COD,.T.))
			// BUSCA QUAL CONTRATO ATIVO PARA O PRODUTO
				If GetMv("ES_CTRNEW") //CONTRATOS COMERCIAIS NOVOS, SE .T. COMECA A USAR OS NOVOS PROGRAMAS DE CONTRATOS.
					aZB6 := U_GetCtrW(cCodCli,cLojCli,cFilF2,dtos(SF2->F2_EMISSAO),SD2->D2_COD,SB1->B1_XCATEGO,SB1->B1_XMARCA,.T.)
				Else
					aZB6 := U_GetContrX(cCodCli,cLojCli,cFilF2,dtos(SF2->F2_EMISSAO),SD2->D2_COD,SB1->B1_XCATEGO,SB1->B1_XMARCA)
				End If
			//SE EXISTIR O CONTRATO ADICIONA OS ITENS DE ACORDO COM O PRODUTO			
				If !Empty(aZB6)
					If GetMv("ES_CTRNEW") //CONTRATOS COMERCIAIS NOVOS, SE .T. COMECA A USAR OS NOVOS PROGRAMAS DE CONTRATOS. U_ItCtrW
						U_ItCtrW(aZB6,SD2->D2_TOTAL,@aItensCtr,SD2->D2_ICMSRET)
					Else
						U_ItensCtr(aZB6,SD2->D2_TOTAL,@aItensCtr,SD2->D2_ICMSRET)
					End IF
				EndIf
				SD2->( dbSkip() )
			EndDo
		Else
		// POSICIONA NO PRODUTO
			SB1->(dbSetOrder(1))
		// BUSCA QUAL CONTRATO ATIVO PARA O PRODUTO
			If nOpcao == 5 	//VENDA
				SB1->(MsSeek(xFilial("SB1")+cProduto,.T.))
				If !lPed
					If GetMv("ES_CTRNEW") //CONTRATOS COMERCIAIS NOVOS, SE .T. COMECA A USAR OS NOVOS PROGRAMAS DE CONTRATOS.
						aZB6 := U_GetCtrW(cCodCli,cLojCli,cFilF2,dtos(SF2->F2_EMISSAO),cProduto,SB1->B1_XCATEGO,SB1->B1_XMARCA,.T.)
					Else
						aZB6 := U_GetContrX(cCodCli,cLojCli,cFilF2,dtos(SF2->F2_EMISSAO),cProduto,SB1->B1_XCATEGO,SB1->B1_XMARCA)
					End If
				Else
					If GetMv("ES_CTRNEW") //CONTRATOS COMERCIAIS NOVOS, SE .T. COMECA A USAR OS NOVOS PROGRAMAS DE CONTRATOS.
						aZB6 := U_GetCtrW(cCli,cLoja,cFilC5,dDtC5,cProduto,SB1->B1_XCATEGO,SB1->B1_XMARCA,.T.)
					Else
						aZB6 := U_GetContrX(cCli,cLoja,cFilC5,dDtC5,cProduto,SB1->B1_XCATEGO,SB1->B1_XMARCA)
					End If
				EndIf
			Else 				//DEVOLUCAO
			// Eh necessário Ponteirar SD1 antes ??? 
				SB1->(MsSeek(xFilial("SB1")+cProduto,.T.))
				If GetMv("ES_CTRNEW") //CONTRATOS COMERCIAIS NOVOS, SE .T. COMECA A USAR OS NOVOS PROGRAMAS DE CONTRATOS.
					aZB6 := U_GetCtrW(cCodCli,cLojCli,cFilF2,dtos(SF1->F1_DTDIGIT),cProduto,SB1->B1_XCATEGO,SB1->B1_XMARCA,.T.)
				Else
					aZB6 := U_GetContrX(cCodCli,cLojCli,cFilF2,dtos(SF1->F1_DTDIGIT),cProduto,SB1->B1_XCATEGO,SB1->B1_XMARCA)
				End If
			EndIf
		// SE EXISTIR O CONTRATO ADICIONA OS ITENS DE ACORDO COM O PRODUTO			
			If !Empty(aZB6)
				If nOpcao == 5 	//VENDA
					If GetMv("ES_CTRNEW") //CONTRATOS COMERCIAIS NOVOS, SE .T. COMECA A USAR OS NOVOS PROGRAMAS DE CONTRATOS. U_ItCtrW
						U_ItCtrW(aZB6, SD2->D2_TOTAL,@aItensCtr,SD2->D2_ICMSRET)
					Else
						U_ItensCtr(aZB6, SD2->D2_TOTAL,@aItensCtr,SD2->D2_ICMSRET)
					End If
				Else			//DEVOLUCAO
					If GetMv("ES_CTRNEW") //CONTRATOS COMERCIAIS NOVOS, SE .T. COMECA A USAR OS NOVOS PROGRAMAS DE CONTRATOS. U_ItCtrW
						U_ItCtrW(aZB6,SD1->D1_TOTAL,@aItensCtr,SD1->D1_ICMSRET)
					Else
						U_ItensCtr(aZB6,SD1->D1_TOTAL,@aItensCtr,SD1->D1_ICMSRET)
					End If
				EndIf
			EndIf
		EndIf
		
		If lCliCont .And. Len(aZB6) > 0
			cForn   := aZB6[1][4]
			cLojFor := aZB6[1][5]
		EndIf
		If Empty(cForn) .Or. Empty(cLojFor)			
			SA1->( dbSetOrder( 1 ) )
			If SA1->( MsSeek( xFilial('SA1') + cCodCli + cLojCli, .F. ) )
				cForn   := SA1->A1_XFORNEC
				cLojFor := SA1->A1_XLJFORN
			EndIf
		EndIf
		
		
	//Calculo do Percentual no Forma de Desconto na Nota Fiscal
		If nOpcao == 1 		// Percentual de desconto NF (Utilizado no pedido de vendas para conceder desconto
			aEval( aItensCtr, {|x| nRet += If( x[FORMADESC]=="1" , x[PERCENTUAL], 0 )  } )
		ElseIf nOpcao == 2 	// Inclusao de Titulos (pedido com contrato)
			
			aPrefixos := {}
			For _nA := 1 To Len( aItensCtr )
			// VERIFICA SE EXISTE A MESMA VERBA PARA PRODUTOS DIFERENTES NA NOTA, SE HOUVER SOMA E INCLUI SOMENTE UMA NO "SE1" 
				nPos := aScan( aPrefixos, {|x| x[1] == aItensCtr[_nA,FORMADESC] .and. x[2] == aItensCtr[_nA,PREFIXO]} )
				If  nPos == 0
					Aadd( aPrefixos,;
					 { 	aItensCtr[_nA,FORMADESC],;
					  	aItensCtr[_nA,PREFIXO],;
					  	aItensCtr[_nA,CCONTRATO],;
					    aItensCtr[_nA,NUMREVISAO],;
						aItensCtr[_nA,PERCENTUAL],;
						( (aItensCtr[_nA,9]*aItensCtr[_nA,PERCENTUAL])/100 ),;
						aItensCtr[_nA,10]} )
				Else
					aPrefixos[nPos][6] += ( (aItensCtr[_nA,9]*aItensCtr[_nA,PERCENTUAL])/100 )
					aPrefixos[nPos][7] += aItensCtr[_nA,10]
				EndIf
			Next _nA
			
			nValTncc 	:= 0
			nValTDup	:= 0
			aItens 		:= {}
			nPerDSC		:= 0
			
			// INCLUI NO "SE1" NCC/AB- A CADA ITEM DO CONTRATO 
			For _nA := 1 To Len( aPrefixos )
				If aPrefixos[_nA][6] > 0
					
					nValTit := aPrefixos[_nA][6]
					nValPro	:= aPrefixos[_nA][7]
						
					If aPrefixos[_nA,1] == '2' 		// CodDescDuplNcc
						AADD(aItens,{{aPrefixos[_nA,2],aPrefixos[_nA,3],aPrefixos[_nA,4],'NCC','01'}, nValTit,.F.,.F.,'SE1',nValPro,aPrefixos[_nA,5]})
						nValTncc += nValTit
						nPerDSC += aPrefixos[_nA,5]
					ElseIf aPrefixos[_nA,1] == '3' 	// CodDescDuplCtaPagar
						AADD(aItens,{{aPrefixos[_nA,2],aPrefixos[_nA,3],aPrefixos[_nA,4],'NF','01'}, nValTit,.F.,.F.,'SE2',nValPro,aPrefixos[_nA,5]})
						nValTDup += nValTit
						nPerDSC += aPrefixos[_nA,5]
					ElseIf aPrefixos[_nA,1] == '4' 	// AB-
						nValAB += nValTit
						nPerDSC += aPrefixos[_nA,5]
					EndIf
				
				EndIf
			Next _nA
			//////////////////////////////============================================================================================
			If nValTncc > 0 //GERA RECEBER
				nxRec := 0
				lRet := QuaaRec( {'DSC',aPrefixos[1,3],aPrefixos[1,4]}, nValTncc ,@nxRec)
				
				For nCount := 1 to Len(aItens)
					U_INCZC6(aItens[nCount][1],aItens[nCount][2],aItens[nCount][3],aItens[nCount][4],aItens[nCount][5],aItens[nCount][6],aItens[nCount][7],nxRec)
				Next nCount
				
				// POSICIONA CONTAS A RECEBER PARA VERIFICAR QUANTAS PARCELAS EXISTEM
				SE1->( dbOrderNickName("SE1NUMTIT") ) 	// FILIAL+NUMERO+TIPO+CLIENTE+LOJA
				SE1->( MsSeek( SF2->F2_FILIAL + SF2->F2_DUPL + "NF " + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
				While SE1->( !Eof() ) .And. SE1->E1_FILIAL + SE1->E1_NUM + SE1->E1_TIPO + SE1->E1_CLIENTE + SE1->E1_LOJA == ;
						SF2->F2_FILIAL + SF2->F2_DUPL + "NF " + SF2->F2_CLIENTE + SF2->F2_LOJA
					
					nxRec := SE1->( Recno() )
					
					//AADD( aItensCtr,{SE1->E1_NUM,SE1->E1_PARCELA})
					xPrefixo := SE1->E1_PREFIXO
					xParc := SE1->E1_PARCELA
					xTipo := SE1->E1_TIPO
					xValor := SE1->E1_VALOR
					U_INCZC6({xPrefixo		,aPrefixos[1,3]	,aPrefixos[1,4]		,'NF',SE1->E1_PARCELA}	, xValor	,.F.,.T.,'SE1',0,nPerDSC,nxRec)
					//U_INCZC6({aPrefixos[1,2],aPrefixos[1,3]	,aPrefixos[1,4]	,'NF',xParc}			, nValTit	,.F.,.T.,'SE1',0,nPerDSC,nxRec)	
					SE1->( dbSkip() )

				EndDo
				
				
			
			End If
			
			If nValTDup > 0 //GERA PAGAR
				nxRec := 0
				If lCliCont
					nRecSE2 := QuaaPag( {'DSC',aPrefixos[1,3],aPrefixos[1,4]}, nValTDup, /*cForn*/, /*cLojFor*/, @nxRec)
					Iif(nRecSE2>0,lRet := .T.,lRet := .F.)
				Else
					nRecSE2 := QuaaPag( {'DSC',aPrefixos[1,3],aPrefixos[1,4]}, nValTDup, /*cForn*/, /*cLojFor*/,@nxRec )
					Iif(nRecSE2>0,lRet := .T.,lRet := .F.)
				EndIf
				
				For nCount := 1 to Len(aItens)
					U_INCZC6(aItens[nCount][1],aItens[nCount][2],aItens[nCount][3],aItens[nCount][4],aItens[nCount][5],aItens[nCount][6],aItens[nCount][7],nxRec)
				Next nCount
				
				// POSICIONA CONTAS A RECEBER PARA VERIFICAR QUANTAS PARCELAS EXISTEM
				SE1->( dbOrderNickName("SE1NUMTIT") ) 	// FILIAL+NUMERO+TIPO+CLIENTE+LOJA
				SE1->( MsSeek( SF2->F2_FILIAL + SF2->F2_DUPL + "NF " + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
				While SE1->( !Eof() ) .And. SE1->E1_FILIAL + SE1->E1_NUM + SE1->E1_TIPO + SE1->E1_CLIENTE + SE1->E1_LOJA == ;
						SF2->F2_FILIAL + SF2->F2_DUPL + "NF " + SF2->F2_CLIENTE + SF2->F2_LOJA
					
					nxRec := SE1->( Recno() )
					
					//AADD( aItensCtr,{SE1->E1_NUM,SE1->E1_PARCELA})
					xPrefixo := SE1->E1_PREFIXO
					xParc := SE1->E1_PARCELA
					xTipo := SE1->E1_TIPO
					xValor := SE1->E1_VALOR
					U_INCZC6({xPrefixo		,aPrefixos[1,3]	,aPrefixos[1,4]		,'NF',SE1->E1_PARCELA}	, xValor	,.F.,.T.,'SE1',0,nPerDSC,nxRec)
					//U_INCZC6({aPrefixos[1,2],aPrefixos[1,3],aPrefixos[1,4],'NF',xParc}, nValTit,.F.,.T.,'SE1',0,nPerDSC)
						
					SE1->( dbSkip() )

				EndDo
			
			End If
			//////////////////////////////============================================================================================
			
			// SE FOR TIPO 4-DESCONTO DUPLICATA GERA AB- PARA CADA PARCELA 
			If nValAB > 0 //SE TIPO = AB-
				cContr := aItensCtr[1,6]
				nRevisc := aItensCtr[1,7]
				aItensCtr := {}
				
				// POSICIONA CONTAS A RECEBER PARA VERIFICAR QUANTAS PARCELAS EXISTEM
				SE1->( dbOrderNickName("SE1NUMTIT") ) 	// FILIAL+NUMERO+TIPO+CLIENTE+LOJA
				SE1->( MsSeek( SF2->F2_FILIAL + SF2->F2_DUPL + "NF " + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
				While SE1->( !Eof() ) .And. SE1->E1_FILIAL + SE1->E1_NUM + SE1->E1_TIPO + SE1->E1_CLIENTE + SE1->E1_LOJA == ;
						SF2->F2_FILIAL + SF2->F2_DUPL + "NF " + SF2->F2_CLIENTE + SF2->F2_LOJA
					
					nxRec := SE1->( Recno() )
					
					AADD( aItensCtr,{SE1->E1_NUM,SE1->E1_PARCELA})
					xPrefixo := SE1->E1_PREFIXO
					//xNum	
					xParc := SE1->E1_PARCELA
					xTipo := SE1->E1_TIPO
					//xContra			
					//xRevisc			
					xValor := SE1->E1_VALOR
					//xRec
					U_INCZC6({'AB-',cContr,nRevisc,'NF',SE1->E1_PARCELA}, Round( ( nValAB/Len(aItensCtr) ),2),.F.,.T.,'SE1',0,nPerDSC,nxRec)
					
					SE1->( dbSkip() )

				EndDo
				// ADICIONA UM AB- PARA CADA PARCELA
				nxRec := 0
				For nCount := 1 to Len(aItensCtr)
					lRet := QuaaDup( {'4',cContr,nRevisc,aItensCtr[nCount][2]}, Round( ( nValAB/Len(aItensCtr) ),2),@nxRec )
					U_INCZC6({xPrefixo,cContr,nRevisc,'AB-',aItensCtr[nCount][2]}, Round( ( nValAB/Len(aItensCtr) ),2),.F.,.F.,'SE1',0,nPerDSC,nxRec)
				Next i
			EndIf
		ElseIf nOpcao == 3 	// Exclusao de Titulos gerados pela rotina
			
//			If !Empty(cForn) .And. !Empty(cLojFor)			// WMS.sn em 23/05/2018 - Chamado 005887
			If !Empty(cCodCli) .And. !Empty(cLojCli) 		// WMS.en em 23/05/2018 - Chamado 005887
			// Seleciona os Titulos Gerados pela Rotina Automatica 
				//034582	0001
				//cForn := '034582'
				//cLojFor := '0001' 
				
				SA1->( dbSetOrder( 1 ) )
				If SA1->( MsSeek( xFilial('SA1') + cCodCli + cLojCli, .F. ) )
					cForn   := SA1->A1_XFORNEC
					cLojFor := SA1->A1_XLJFORN
				Else
					cForn   := ""
					cLojFor := ""
				
				EndIf
				
				BeginSql Alias cAliasTRB

					SELECT 'R' CARTEIRA, E1_PREFIXO AS _PREFIXO, E1_NUM AS NUM,E1_PARCELA AS PARCELA, E1_TIPO AS TIPO
					FROM %Table:SE1% SE1
					WHERE SE1.%notDel%
					AND SE1.E1_FILIAL = %xfilial:SE1%
					AND SE1.E1_NUM    = %Exp:cDuplic%
					AND SE1.E1_TIPO IN ('NCC','AB-')
					AND SE1.E1_CLIENTE = %Exp:cCodCli%
					AND SE1.E1_LOJA = %Exp:cLojCli%

					UNION ALL
					
					SELECT  'P' CARTEIRA, E2_PREFIXO AS _PREFIXO, E2_NUM AS NUM,E2_PARCELA AS PARCELA, E2_TIPO AS TIPO
					FROM %Table:SE2% SE2
					WHERE SE2.%notDel%
					AND SE2.E2_FILIAL = %xfilial:SE2%
					AND SE2.E2_NUM    = %Exp:cDuplic%
					AND SE2.E2_PARCELA = ' '
					AND SE2.E2_TIPO = 'NF'
					AND SE2.E2_FORNECE = %Exp:cForn%
					AND SE2.E2_LOJA = %Exp:cLojFor%

				EndSql

				While (cAliasTRB)->(!Eof())

					If (cAliasTRB)->CARTEIRA == 'P'
						aCpoSE2 := {}

						AADD(aCpoSE2,{"E2_PREFIXO"	,(cAliasTRB)->_PREFIXO   ,Nil})
						AADD(aCpoSE2,{"E2_NUM"		,(cAliasTRB)->NUM 			,Nil})
						AADD(aCpoSE2,{"E2_PARCELA"	,(cAliasTRB)->PARCELA		,Nil})
						AADD(aCpoSE2,{"E2_TIPO"	,(cAliasTRB)->TIPO  		,Nil})

						lMsErroAuto:=.F.
						lMSHelpAuto:= .T.
						INCLUI := .F.
						MSExecAuto( { | x, y, z | Fina050( x, y, z ) }, aCpoSE2,, 5 )
						If lMsErroAuto
							Mostraerro()
						Endif
					Else
						aCpoSE1 := {}

						AADD(aCpoSE1,{"E1_PREFIXO"	,(cAliasTRB)->_PREFIXO	,Nil})
						AADD(aCpoSE1,{"E1_NUM"		,(cAliasTRB)->NUM			,Nil})
						AADD(aCpoSE1,{"E1_PARCELA"	,(cAliasTRB)->PARCELA		,Nil})
						AADD(aCpoSE1,{"E1_TIPO"	,(cAliasTRB)->TIPO   		,Nil})
						lMsErroAuto := .F.
						lMSHelpAuto := .T.
						INCLUI 		:= .F.
						MsExecAuto( { |x,y| fina040(x,y)},aCpoSe1,5)
						If lMsErroAuto
							Mostraerro()
						EndIf
					EndIf
					(cAliasTRB)->(Dbskip() )
				Enddo
				(cAliasTRB)->( DbCloseArea() )
			Else
				ConOut(" - Problema na exclusao do titulo: " + cDuplic + " Relacionado ao cliente:" + cCodCli + "/" + cLojCli )
			EndIf
		ElseIf nOpcao == 4 	// Retorna o desconto de base para vendedores
			aPrefixos := {}
			nTotCom := 0
			For _nA := 1 To Len( aItensCtr )
				If aScan( aPrefixos, {|x| x[1] == aItensCtr[_nA,FORMADESC] .and. x[2] == aItensCtr[_nA,PREFIXO]} ) == 0
					Aadd( aPrefixos, { aItensCtr[_nA,FORMADESC], aItensCtr[_nA,PREFIXO], aItensCtr[_nA,CCONTRATO], aItensCtr[_nA,NUMREVISAO] } )
				EndIf
			Next _nA
			For _nA := 1 To Len( aPrefixos )
				nTotPNf 	:= 0
				nTotPDup 	:= 0
				aEval( aItensCtr, {|x| nTotPNf 	+= If( x[FORMADESC] == aPrefixos[_nA,1] .and. x[PREFIXO] == aPrefixos[_nA,2] .and. x[FORMACALC] == '1',x[PERCENTUAL],0)  } )
				aEval( aItensCtr, {|x| nTotPDup += If( x[FORMADESC] == aPrefixos[_nA,1] .and. x[PREFIXO] == aPrefixos[_nA,2] .and. x[FORMACALC] == '2',x[PERCENTUAL],0)  } )
				If nTotPNf+nTotPDup > 0
					nValTit := nTotNF * nTotPNf / 100
					nValTit += nTotDupl * nTotPDup / 100
					nTotCom += nValTit
				EndIf
			Next _nA
		// Alterado para retornar o total de desconto em percentual
			nRet := nTotPNf + nTotPDup
		ElseIf nOpcao == 5 	// Total geral de desconto em percentual
			aEval( aItensCtr, {|x| nRet += x[3] } )
			aEval( aItensCtr, {|x| cCodCon 	:= x[6] } )
			aEval( aItensCtr, {|x| nRevisao := x[7] } )
			//MsgAlert(cCodCon+"-"+nRevisao+"QUAA060W "+cValToChar(nRet))
		ElseIf nOpcao == 6 // Total geral de desconto em percentual verificando se considera ou nao devolucao.
			aEval( aItensCtr, {|x| nRet += If( x[8]=='S', x[3], 0 ) } )
		End If
		
		cStcCodCli := cCodCli
		cStcLojCli := cLojCli
		cStcSetor  := cSetor
		dStcData   := dDataBase
		nStcPercen := nRet
		nStcOpcao  := nOpcao
	EndIf

	RestArea(aAreaSE1)
	RestArea(aAreaSE2)
	RestArea(aAreaZB4)
	RestArea(aAreaZB5)
	RestArea(aAreaZB6)
	RestArea(aAreaSD1)
	RestArea(aAreaSF1)
	RestArea(aArea)

Return (nRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAA060   ºAutor  ³Sabrina Moreira     º Data ³  03/02/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     |Rotina utilizada para Gerar Titulos a Receber conforme      º±±
±±º          ³Regra de Desconto                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Queijos Quata                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QuaaRec( aItensCtr, nValorTit , nxRec)
		
	Local aCpoSE1 	:= {}
	Local cQuery  	:= " "
	Local cAliasSE1 := GetNextAlias()
	Local cAliasSE1A := GetNextAlias()
	Local cNatureza	:= GetMv("ES_NATDESC")
	Local aArea		:= GetArea()
	Local cTipo 	:= "NCC"
	Local lRet		:= .F.
	
	//Validar a existencia de mais titulos para o Contrato
	cQuery := "SELECT R_E_C_N_O_ AS REC,E1_VALOR " + CRLF
	cQuery += "FROM "+RetSqlName("SE1")+" SE1 " + CRLF
	cQuery += "WHERE SE1.E1_FILIAL='"+xFilial("SE1")+"' AND " + CRLF
	cQuery += "SE1.E1_PREFIXO='"+aItensCtr[1]+"' AND " + CRLF
	cQuery += "SE1.E1_NUM='"+cDuplic+"' AND " + CRLF
	cQuery += "SE1.E1_CLIENTE='"+cCodCli+"' AND " + CRLF
	cQuery += "SE1.E1_LOJA='"+cLojCli+"' AND " + CRLF
	cQuery += "SE1.D_E_L_E_T_=' ' " + CRLF
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("C:\HD\QUERYS\QUAA060W_SE1.sql",cQuery)
	
	If Select(cAliasSE1) > 0
		DbSelectArea(cAliasSE1)
		(cAliasSE1)->( DbCloseArea() )
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE1,.T.,.T.)
	DbSelectArea(cAliasSE1)
	
	If (cAliasSE1)->(Eof())
		cNcli := Posicione("SA1"	,1,xFilial("SA1")+Pad(cCodCli,Len(SE1->E1_CLIENTE))+Pad(cLojCli,Len(SE1->E1_LOJA)),"A1_NOME")
		AADD(aCpoSE1,{"E1_FILIAL"  	,xFilial("SE1")								,Nil})
		AADD(aCpoSE1,{"E1_PREFIXO" 	,Pad(aItensCtr[1],Len(SE1->E1_PREFIXO))		,Nil})
		AADD(aCpoSE1,{"E1_NUM"     	,Pad(cDuplic,Len(SE1->E1_NUM))				,Nil})
		AADD(aCpoSE1,{"E1_PARCELA" 	,Pad("01", Len(SE1->E1_PARCELA))			,Nil})
		AADD(aCpoSE1,{"E1_TIPO"    	,Pad(cTipo,Len(SE1->E1_TIPO))    			,Nil})
		AADD(aCpoSE1,{"E1_NATUREZ" 	,Pad(cNatureza,Len(SE1->E1_NATUREZ))		,Nil})
		AADD(aCpoSE1,{"E1_CLIENTE" 	,Pad(cCodCli	,Len(SE1->E1_CLIENTE))		,Nil})
		AADD(aCpoSE1,{"E1_LOJA"    	,Pad(cLojCli,Len(SE1->E1_LOJA))  			,Nil})
		AADD(aCpoSE1,{"E1_EMISSAO" 	,dDatabase     								,Nil})
		AADD(aCpoSE1,{"E1_VENCTO"  	,SE1->E1_VENCTO 	   						,Nil})
		AADD(aCpoSE1,{"E1_VALOR"   	,nValorTit      	   						,Nil})
		AADD(aCpoSE1,{"E1_SALDO"   	,nValorTit      	   						,Nil})
		AADD(aCpoSE1,{"E1_ORIGEM"  	,Pad("QUAA060", Len(SE1->E1_ORIGEM))		,Nil})
		AADD(aCpoSE1,{"E1_XNCONTR"  ,Pad(aItensCtr[2],Len(SE1->E1_XNCONTR))		,Nil})
		AADD(aCpoSE1,{"E1_NREVISC" 	,Pad(aItensCtr[3],Len(SE1->E1_NREVISC))		,Nil})
		AADD(aCpoSE1,{"E1_U_RAZAO" 	,pad(cNcli,Len(SE1->E1_U_RAZAO)) 	   		,Nil})  //WILSON 01/10/08
		AADD(aCpoSE1,{"E1_XSETOR"  	,pad(SC5->C5_XSETOR,Len(SE1->E1_XSETOR))	,Nil})  //WILSON 01/10/08
		AADD(aCpoSE1,{"E1_HIST"		,"REGRA DE DESCONTO - AUTOMATICO"			,Nil})
		lMsErroAuto:=.F.
		lMSHelpAuto:= .T.
		INCLUI := .T.
		MsExecAuto( { |x| fina040(x)},aCpoSe1,3)
		If lMsErroAuto
			U_QUTSMAIL("Erro Inclusao NCC:","Erro Inclusao NCC: " + aItensCtr[1] + '-' + cDuplic,,'fernando.bonacordi@quataalimentos.com.br;wilson.oliveira@quataalimentos.com.br')
			Mostraerro()
		Else
			lRet := .T.
		Endif
	Else
		lRet := .F.
		nxRec := (cAliasSE1)->REC
		
		nValComp := 0
		
		cQuery := "SELECT R_E_C_N_O_ AS REC,E1_VALOR "
		cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
		cQuery += "WHERE SE1.E1_FILIAL='"+xFilial("SE1")+"' AND "
		cQuery += "SE1.E1_PREFIXO='"+aItensCtr[1]+"' AND "
		cQuery += "SE1.E1_NUM='"+cDuplic+"' AND "
		cQuery += "SE1.E1_CLIENTE='"+cCodCli+"' AND "
		cQuery += "SE1.E1_LOJA='"+cLojCli+"' AND "
		cQuery += "SE1.E1_PARCELA='02' AND "
		cQuery += "SE1.D_E_L_E_T_=' ' "
		cQuery := ChangeQuery(cQuery)
		
		MemoWrite("C:\HD\QUERYS\QUAA060W_SE1_2.sql",cQuery)
		
		If Select(cAliasSE1A) > 0
			DbSelectArea(cAliasSE1A)
			(cAliasSE1A)->( DbCloseArea() )
		EndIf
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE1A,.T.,.T.)
		DbSelectArea(cAliasSE1A)
	
		nValComp := Round(nValorTit,2) - (cAliasSE1)->(E1_VALOR)
		
		If (nValorTit > (cAliasSE1)->(E1_VALOR)) .AND. (cAliasSE1A)->(Eof()) .AND. SE1->E1_VENCTO >= dDatabase .AND. nValComp > 0
			
			
		
			cNcli := Posicione("SA1"	,1,xFilial("SA1")+Pad(cCodCli,Len(SE1->E1_CLIENTE))+Pad(cLojCli,Len(SE1->E1_LOJA)),"A1_NOME")
			AADD(aCpoSE1,{"E1_FILIAL"  	,xFilial("SE1")								,Nil})
			AADD(aCpoSE1,{"E1_PREFIXO" 	,Pad(aItensCtr[1],Len(SE1->E1_PREFIXO))		,Nil})
			AADD(aCpoSE1,{"E1_NUM"     	,Pad(cDuplic,Len(SE1->E1_NUM))				,Nil})
			AADD(aCpoSE1,{"E1_PARCELA" 	,Pad("02", Len(SE1->E1_PARCELA))			,Nil})
			AADD(aCpoSE1,{"E1_TIPO"    	,Pad(cTipo,Len(SE1->E1_TIPO))    			,Nil})
			AADD(aCpoSE1,{"E1_NATUREZ" 	,Pad(cNatureza,Len(SE1->E1_NATUREZ))		,Nil})
			AADD(aCpoSE1,{"E1_CLIENTE" 	,Pad(cCodCli	,Len(SE1->E1_CLIENTE))		,Nil})
			AADD(aCpoSE1,{"E1_LOJA"    	,Pad(cLojCli,Len(SE1->E1_LOJA))  			,Nil})
			AADD(aCpoSE1,{"E1_EMISSAO" 	,dDatabase     								,Nil})
			AADD(aCpoSE1,{"E1_VENCTO"  	,SE1->E1_VENCTO 	   						,Nil})
			AADD(aCpoSE1,{"E1_VALOR"   	,nValComp 	     	   						,Nil})
			AADD(aCpoSE1,{"E1_SALDO"   	,nValComp   	   	   						,Nil})
			AADD(aCpoSE1,{"E1_ORIGEM"  	,Pad("QUAA060", Len(SE1->E1_ORIGEM))		,Nil})
			AADD(aCpoSE1,{"E1_XNCONTR"  ,Pad(aItensCtr[2],Len(SE1->E1_XNCONTR))		,Nil})
			AADD(aCpoSE1,{"E1_NREVISC" 	,Pad(aItensCtr[3],Len(SE1->E1_NREVISC))		,Nil})
			AADD(aCpoSE1,{"E1_U_RAZAO" 	,pad(cNcli,Len(SE1->E1_U_RAZAO)) 	   		,Nil})  //WILSON 01/10/08
			AADD(aCpoSE1,{"E1_XSETOR"  	,pad(SC5->C5_XSETOR,Len(SE1->E1_XSETOR))	,Nil})  //WILSON 01/10/08
			AADD(aCpoSE1,{"E1_HIST"		,"COMPLEMENTO REGRA DE DESCONTO-AUTOMATICO"	,Nil})
			
			lMsErroAuto:=.F.
			lMSHelpAuto:= .T.
			INCLUI := .T.
			
			MsExecAuto( { |x| fina040(x)},aCpoSe1,3)
			
			If lMsErroAuto
				U_QUTSMAIL("Erro Inclusao NCC COMPLEMENTO:","Erro Inclusao NCC COMPLEMENTO: " + aItensCtr[1] + '-' + cDuplic,,'fernando.bonacordi@quataalimentos.com.br;wilson.oliveira@wdonet.com.br')
				Mostraerro()
			Else
				
				RecLock("ZZZ",.T.)
					ZZZ->ZZZ_FILIAL	:= xFilial("SE1")
					ZZZ->ZZZ_CONTRA	:= Pad(aItensCtr[1],Len(SE1->E1_PREFIXO))
					ZZZ->ZZZ_REVISA	:= Pad(cDuplic,Len(SE1->E1_NUM))
					ZZZ->ZZZ_DATA	:= Pad("02", Len(SE1->E1_PARCELA))
					ZZZ->ZZZ_PRE1	:= Pad(cTipo,Len(SE1->E1_TIPO))  	
					ZZZ->ZZZ_VRBRUT	:= Pad(cCodCli	,Len(SE1->E1_CLIENTE))	
					ZZZ->ZZZ_PRE2	:= Pad(cLojCli,Len(SE1->E1_LOJA))  	
					ZZZ->ZZZ_VR2	:= Pad(cNatureza,Len(SE1->E1_NATUREZ))
					ZZZ->ZZZ_PRE3	:= cValToChar(dDatabase)
					ZZZ->ZZZ_VR3	:= dtoc(SE1->E1_VENCTO) 	   				
					ZZZ->ZZZ_PRE4	:= +cValToChar(nValComp) 	     	   				
				MsUnlock()
				
				lRet := .T.
			Endif
		
		End If
	
	
	EndIf

	RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAA060   ºAutor  ³Sabrina Moreira     º Data ³  03/02/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     |Rotina utilizada para Gerar Titulos de Abatimento conforme  º±±
±±º          ³Regra de Desconto                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Queijos Quata                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function QuaaDup( aItensCtr, nValorTit, nxRec )

	Local aCpoSE1 	:= {}
	Local cQuery  	:= " "
	Local cAliasSE1 := GetNextAlias()
	Local cNatureza	:= GetMv("ES_NATDESC")
	Local aArea		:= GetArea()
	Local cTipo 	:= "AB-"
	Local lRet		:= .F.
	
// Validar a existencia de mais titulos para o Contrato
	cQuery := "SELECT R_E_C_N_O_ AS REC "
	cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
	cQuery += "WHERE SE1.E1_FILIAL='"+xFilial("SE1")+"' AND "
	cQuery += "SE1.E1_PREFIXO='"+Pad(SF2->F2_PREFIXO,Len(SE1->E1_PREFIXO))+"' AND "
	cQuery += "SE1.E1_PARCELA='" + aItensCtr[4] + "' AND "
	cQuery += "SE1.E1_NUM='"+cDuplic+"' AND "
	cQuery += "SE1.E1_CLIENTE='"+cCodCli+"' AND "
	cQuery += "SE1.E1_LOJA='"+cLojCli+"' AND "
	cQuery += "SE1.E1_ORIGEM= 'QUAA060' AND "   //ALTERADO 01/10/08 estaca QUA060 O CORRETO EH QUAA060
	cQuery += "SE1.D_E_L_E_T_=' ' "
	cQuery := ChangeQuery(cQuery)
	MemoWrite("C:\HD\QUERYS\descab-.sql",cQuery)
	If Select(cAliasSE1) > 0
		dbSelectArea(cAliasSE1)
		(cAliasSE1)->( dbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE1,.T.,.T.)
	dbSelectArea(cAliasSE1)
		
	//POSICIONA SE1 PARA BUSCA DA DATA DO VENCIMENTO	
	//SE1->( dbOrderNickName("SE1NUMTIT") ) 	// FILIAL+NUMERO+TIPO+CLIENTE+LOJA
	//SE1->( MsSeek( SF2->F2_FILIAL + SF2->F2_DUPL + "NF " + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
	
	
	//POSICIONA SE1 PARA BUSCA DA DATA DO VENCIMENTO
	SE1->(dbSetOrder(2))
	SE1->( MsSeek( SF2->F2_FILIAL + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_PREFIXO  + SF2->F2_DUPL + Pad(aItensCtr[4],Len(SE1->E1_PARCELA)) + "NF " ))
	//                    E1_FILIAL       +E1_CLIENTE +      E1_LOJA +      E1_PREFIXO         +E1_NUM                              +E1_PARCELA +E1_TIPO
	
	If (cAliasSE1)->(Eof())
		cNcli := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
		AADD(aCpoSE1,{"E1_FILIAL"	,xFilial("SE1")	   							,Nil})
		AADD(aCpoSE1,{"E1_PREFIXO"	,Pad(SF2->F2_PREFIXO,Len(SE1->E1_PREFIXO))	,Nil})
		AADD(aCpoSE1,{"E1_PARCELA"	,Pad(aItensCtr[4],Len(SE1->E1_PARCELA))		,Nil})
		AADD(aCpoSE1,{"E1_NUM"		,Pad(cDuplic,Len(SE1->E1_NUM))				,Nil})
		AADD(aCpoSE1,{"E1_TIPO"		,Pad(cTipo,Len(SE1->E1_TIPO))    			,Nil})
		AADD(aCpoSE1,{"E1_NATUREZ"	,Pad(cNatureza,Len(SE1->E1_NATUREZ))		,Nil})
		AADD(aCpoSE1,{"E1_CLIENTE"	,Pad(cCodCli	,Len(SE1->E1_CLIENTE))		,Nil})
		AADD(aCpoSE1,{"E1_LOJA"		,Pad(cLojCli,Len(SE1->E1_LOJA))  			,Nil})
		AADD(aCpoSE1,{"E1_EMISSAO"	,dDatabase     	   							,Nil})
		//AADD(aCpoSE1,{"E1_VENCTO"	,dDatabase      	  						,Nil})
		AADD(aCpoSE1,{"E1_VENCTO"	,SE1->E1_VENCTO        						,Nil})//ALTERADO POR RONALDO MENDES- 16/10/2017 - CHAMADO 003161 - VENCTO DEVE SER O MESMO DO TITULO PRINCIPAL
		AADD(aCpoSE1,{"E1_VALOR"	,nValorTit		      	   					,Nil})
		AADD(aCpoSE1,{"E1_ORIGEM"	,Pad("QUAA060", Len(SE1->E1_ORIGEM))		,Nil})
		AADD(aCpoSE1,{"E1_XNCONTR"	,Pad(aItensCtr[2],Len(SE1->E1_XNCONTR))		,Nil})
		AADD(aCpoSE1,{"E1_NREVISC"	,Pad(aItensCtr[3],Len(SE1->E1_NREVISC))		,Nil})
		AADD(aCpoSE1,{"E1_U_RAZAO"	,pad(cNcli,Len(SE1->E1_U_RAZAO)) 	   		,Nil})  //WILSON 01/10/08
		AADD(aCpoSE1,{"E1_XSETOR"	,pad(SC5->C5_XSETOR,Len(SE1->E1_XSETOR))	,Nil})  //WILSON 01/10/08
		lMsErroAuto:=.F.
		lMSHelpAuto:= .T.
		INCLUI := .T.
		MsExecAuto( { |x| fina040(x)},aCpoSe1,3)
		If lMsErroAuto
			Mostraerro()
		Else
			lRet := .T.
		Endif
		RestArea (aArea)
	Else
		nxRec := (cAliasSE1)->REC
	EndIf
Return lRet

//EVENTUAL NAO FAZ PARTE DO PROCESSO
Static Function ProcZZG()

	dbSelectArea("ZB6")
	dbSetOrder(1)
	dbGotop()
	ProcRegua( Reccount() )
	While !Eof()
		IncProc("Contrato --> " + ZB6->ZB6_CODCON)
		If ZB6->ZB6_FILIAL == '01'
			RecLock("ZZG",.T.)
			ZZG->ZZG_FILIAL := '01'
			ZZG->ZZG_CODCLI	:= ZB6->ZB6_CODCLI
			ZZG->ZZG_LOJA	:= ZB6->ZB6_LOJACL
			ZZG->ZZG_CODCTR	:= ZB6->ZB6_CODCON
			ZZG->ZZG_SETOR	:= ZB6->ZB6_SETOR
			ZZG->ZZG_CATEGO	:= '100001'
			ZZG->ZZG_MARCA	:= '999999'
			ZZG->ZZG_ITEM	:= 1
			MsUnlock()
		ElseIf ZB6->ZB6_FILIAL == '08' .Or. ZB6->ZB6_FILIAL == '09' .Or. ZB6->ZB6_FILIAL == '10'
			RecLock("ZZG",.T.)
			ZZG->ZZG_FILIAL := ZB6->ZB6_FILIAL
			ZZG->ZZG_CODCLI	:= ZB6->ZB6_CODCLI
			ZZG->ZZG_LOJA	:= ZB6->ZB6_LOJACL
			ZZG->ZZG_CODCTR	:= ZB6->ZB6_CODCON
			ZZG->ZZG_SETOR	:= ZB6->ZB6_SETOR
			ZZG->ZZG_CATEGO	:= '100004'
			ZZG->ZZG_MARCA	:= '999999'
			ZZG->ZZG_ITEM	:= 1
			MsUnlock()
		EndIf
		dbSelectArea("ZB6")
		dbSkip()
	End While
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QA60FIL() ºAutor  ³WILSON DAVILA       º Data ³  24/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     |Localizar contratos vigentes para o cliente                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function QA60FIL()

	Local cRet:= ''


	dbSelectArea("SM0")
	dbGotop()

	cRet := "SELECIONE FILIAL;"
	cRet += "00-TODAS AS FILIAIS"


	While !Eof()

		cRet += ";"+SM0->M0_CODFIL+"-"+Alltrim(SM0->M0_FILIAL)
		dbSkip()

	End While

Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ INCZC6() ºAutor  ³WILSON DAVILA       º Data ³  02/12/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     |Inclui registros itens contratos ZC6                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function INCZC6(aItensCtr, nValorTit,lEst,lNf,cOrigem,nvPr,nXdesc,nxRec)

	Local cBand := Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_XBAND")
	Local cTipo := aItensCtr[4]

//xPrefixo
//xNum	
//xParc	
//xTipo
//xContra			
//xRevisc			
//xValor			
//xRec :=  IIF(cOrigem=='SE1',xRec,SE2->( Recno() ))			

	//MSGALERT("ENTROU")
	If lNf .and. CheckZC6(SE1->E1_FILIAL,Pad(xPrefixo,Len(SE1->E1_PREFIXO)),Pad(xNum,Len(SE1->E1_NUM)),Pad(xParc, Len(SE1->E1_PARCELA)),Pad(xTipo,Len(SE1->E1_TIPO)),Pad(cCodCli	,Len(SE1->E1_CLIENTE)),Pad(cLojCli,Len(SE1->E1_LOJA))) //TITULO PRINCIPAL
		RecLock("ZC6",.T.)
		ZC6->ZC6_FILIAL := SE1->E1_FILIAL
		ZC6->ZC6_PREFIX	:= Pad(xPrefixo,Len(SE1->E1_PREFIXO))
		ZC6->ZC6_NUM	:= Pad(xNum,Len(SE1->E1_NUM))
		ZC6->ZC6_PARCEL	:= Pad(xParc, Len(SE1->E1_PARCELA))
		ZC6->ZC6_TIPO	:= Pad(xTipo,Len(SE1->E1_TIPO))
		ZC6->ZC6_CODBAN	:= cBand
		ZC6->ZC6_BANDEI	:= Posicione("ZAP",1,xFilial("ZAP")+cBand,"ZAP_DESCR")
		ZC6->ZC6_CODCLI	:= Pad(cCodCli	,Len(SE1->E1_CLIENTE))
		ZC6->ZC6_LOJA	:= Pad(cLojCli,Len(SE1->E1_LOJA))
		ZC6->ZC6_CLIENT := Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_NOME")
		ZC6->ZC6_EMISSA	:= dDatabase
		ZC6->ZC6_VENCIM	:= SE1->E1_VENCTO
		ZC6->ZC6_CONTRA	:= Pad(aItensCtr[2],Len(SE1->E1_XNCONTR))
		ZC6->ZC6_REVIS	:= Pad(aItensCtr[3],Len(SE1->E1_NREVISC))
		ZC6->ZC6_VALOR	:= Round(xValor,2)
		ZC6->ZC6_SALDO	:= Round(xValor,2)
		ZC6->ZC6_ORIGEM	:= cOrigem
		ZC6->ZC6_TOTNF	:= nValNF
		ZC6->ZC6_TOTPRO	:= nValProd
		ZC6->ZC6_PERDES	:= nXdesc
		ZC6->ZC6_RECSE1 := SE1->( Recno() )
		//msgalert("731")
		MsUnlock()
	ElseIf !lNf .and. CheckZC6(SE1->E1_FILIAL,Pad(aItensCtr[1],Len(SE1->E1_PREFIXO)),Pad(cDuplic,Len(SE1->E1_NUM)),Pad(aItensCtr[5], Len(SE1->E1_PARCELA)),Pad(cTipo,Len(SE1->E1_TIPO)),Pad(cCodCli	,Len(SE1->E1_CLIENTE)),Pad(cLojCli,Len(SE1->E1_LOJA))) //DESCONTOS
		RecLock("ZC6",.T.)
		ZC6->ZC6_FILIAL := SE1->E1_FILIAL
		ZC6->ZC6_PREFIX	:= Pad(aItensCtr[1],Len(SE1->E1_PREFIXO))
		ZC6->ZC6_NUM	:= Pad(cDuplic,Len(SE1->E1_NUM))
		ZC6->ZC6_PARCEL	:= Pad(aItensCtr[5], Len(SE1->E1_PARCELA))
		ZC6->ZC6_TIPO	:= Pad(cTipo,Len(SE1->E1_TIPO))
		ZC6->ZC6_CODBAN	:= cBand
		ZC6->ZC6_BANDEI	:= Posicione("ZAP",1,xFilial("ZAP")+cBand,"ZAP_DESCR")
		ZC6->ZC6_CODCLI	:= Pad(cCodCli	,Len(SE1->E1_CLIENTE))
		ZC6->ZC6_LOJA	:= Pad(cLojCli,Len(SE1->E1_LOJA))
		ZC6->ZC6_CLIENT := Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_NOME")
		ZC6->ZC6_EMISSA	:= dDatabase
		ZC6->ZC6_VENCIM	:= SE1->E1_VENCTO
		ZC6->ZC6_CONTRA	:= Pad(aItensCtr[2],Len(SE1->E1_XNCONTR))
		ZC6->ZC6_REVIS	:= Pad(aItensCtr[3],Len(SE1->E1_NREVISC))
		ZC6->ZC6_VALOR	:= Round(nValorTit,2)
		ZC6->ZC6_SALDO	:= Round(nValorTit,2)
		ZC6->ZC6_RECSE1 := IIF(cOrigem=='SE1',IIF(nxRec>0,nxRec,SE1->( Recno() )),Iif(nRecSE2==0,nxRec,nRecSE2) )
		ZC6->ZC6_ORIGEM	:= cOrigem
		ZC6->ZC6_TOTNF	:= 0 //nValNF
		ZC6->ZC6_TOTPRO	:= 0 //nValProd
		ZC6->ZC6_PERDES	:= nXdesc
		//msgalert("756")
		MsUnlock()
	End If

Return .T.


User Function CheckCtr()
Local lRet := .T.
Local cAliasQry := GetNextAlias()
				
	BeginSql Alias cAliasQry
		
		SELECT 1
		FROM %Table:SE2% SE2
		WHERE SE2.%notDel%
		AND SE2.E2_FILIAL = %xfilial:SE2%
		AND SE2.E2_TIPO = 'NF'
		AND SE2.E2_XNCONTR = %Exp:M->ZB6_CODCON%
		AND SE2.E2_FORNECE = %Exp:M->ZB6_XFORNE%
		AND SE2.E2_LOJA   = %Exp:M->ZB6_XLJFOR%
		AND SE2.E2_SALDO > 0

	EndSql

lRet := (cAliasQry)->(EOf() )
(cAliasQry)->(DbCloseArea()  )
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetContrW ºAutor  ³WILSON DAVILA       º Data ³  24/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     |Localizar contratos vigentes para o cliente                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GetCtrW(cCliente,cLoja,cFil,cData,cProduto,cCatego,cMarca,lNf)

	Local aRet 		:= {}
	Local aRet1		:= {}
	Local cQuery 	:= ''
	Local aArea		:= GetArea()
	Local lAchou    := .F.
	Local lQuery	:= .F.
	Local lCliCont  := .F. //ZB6->( FieldPos( "ZB6_XFORNE" ) ) > 0 .And. ZB6->( FieldPos( "ZB6_XLJFOR" ) ) > 0	
	Local nx        := 0	
	DEFAULT lNf		:= .F.

	/////========================================================================================================
	//msgalert(cValToChar(lNf)+ "lNf")
	If !lNf
		lConsNF1 := .F.
	EndIf
	//msgalert(cValToChar(lConsNF1)+ " lConsNF1")
	cQuery := "SELECT ZC4_FILIAL,ZC4_FILSEL,ZC7_CODCLI,ZC7_LOJA,ZC4_CODCON,ZC4_DESC,ZC4_REVISA,ZC7_CODPRO,ZC7_CATEGO,ZC7_MARCA " + CRLF
	
	cQuery += "FROM " + RetSqlName("ZC7") + "  ZC7   " + CRLF
	
	cQuery += "INNER JOIN " + RetSqlName("ZC4") + " ZC4 ON ZC4_CODCON=ZC7_CODCTR AND ZC4.D_E_L_E_T_='' " + CRLF 
	
	cQuery += "AND '" + cData + "' >= ZC4_DTINI AND ('" + cData + "' < ZC4_DTFIM OR ZC4_DTFIM = '') " + CRLF
	
	cQuery += "WHERE ZC7_CODCLI='" + cCliente + "' AND ZC7_LOJA='" + cLoja + "' AND ZC7.D_E_L_E_T_=''  " + CRLF
	cQuery += "AND (ZC4_FILSEL like '00-TODAS AS FILIAIS%' OR '" + cFil + "' IN (ZC4_FILSEL))  " + CRLF
	
	IF !lConsNF1
		cQuery += " AND ZC4_OBSOLE='F' AND ZC4_ATIVO = 'S' " + CRLF
	End If
	
	
	cQuery += "ORDER BY ZC7_CODPRO DESC,ZC7_CATEGO,ZC7_MARCA  " + CRLF
	
	MemoWrite("C:\HD\QUERYS\QUAA060W_CLIENTE_LOJA.SQL",cQuery)
	
	If Select( "QUERY680" ) > 0
		QUERY680->( dbCloseArea() )
	EndIf

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "QUERY680", .F., .T.)

	QUERY680->( dbGoTop() )

	While QUERY680->( !Eof() )
	
			If lCliCont
				AADD(aRet,{QUERY680->ZC4_FILIAL, ;
					QUERY680->ZC4_CODCON, ;
					QUERY680->ZC4_REVISA, ;
					QUERY680->ZC7_CODPRO, ;
					QUERY680->ZC7_CATEGO, ;
					QUERY680->ZC7_MARCA, ;
					QUERY680->ZB6_XFORNE, ;
					QUERY680->ZB6_XLJFOR })
			Else
				AADD(aRet,{QUERY680->(ZC4_FILIAL), ;
					QUERY680->(ZC4_CODCON), ;
					QUERY680->(ZC4_REVISA), ;
					QUERY680->(ZC7_CODPRO), ;
					QUERY680->(ZC7_CATEGO), ;
					QUERY680->(ZC7_MARCA) })
			EndIf

		QUERY680->( dbSkip() )
	
	EndDo

	QUERY680->( dbGoTop() )

	//busca somente por cliente
		
		cQuery := "SELECT ZC4_FILIAL,ZC4_FILSEL,ZC7_CODCLI,ZC7_LOJA,ZC4_CODCON,ZC4_DESC,ZC4_REVISA,ZC7_CODPRO,ZC7_CATEGO,ZC7_MARCA " + CRLF
	
		cQuery += "FROM " + RetSqlName("ZC7") + "  ZC7   " + CRLF
	
		cQuery += "INNER JOIN " + RetSqlName("ZC4") + " ZC4 ON ZC4_CODCON=ZC7_CODCTR AND ZC4.D_E_L_E_T_='' " + CRLF 
		cQuery += "AND '" + cData + "' >= ZC4_DTINI AND ('" + cData + "' < ZC4_DTFIM OR ZC4_DTFIM = '') " + CRLF
		cQuery += "WHERE ZC7_CODCLI='" + cCliente + "' AND ZC7_LOJA='' AND ZC7.D_E_L_E_T_=''  " + CRLF
		cQuery += "AND (ZC4_FILSEL like '00-TODAS AS FILIAIS%' OR '" + cFil + "' IN (ZC4_FILSEL)) " + CRLF
		
		IF !lConsNF1
			cQuery += " AND ZC4_OBSOLE='F' AND ZC4_ATIVO = 'S' " + CRLF
		End If
		
		cQuery += "ORDER BY ZC7_CODPRO DESC,ZC7_CATEGO,ZC7_MARCA  " + CRLF
		
		MemoWrite("C:\HD\QUERYS\QUAA060W_CLIENTE.SQL",cQuery)
		
		If Select( "QUERY700" ) > 0
			QUERY700->( dbCloseArea() )
		EndIf
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "QUERY700", .F., .T.)
		QUERY700->( dbGoTop() )
		While QUERY700->( !Eof() )
		lQuery := .T.
			If lCliCont
				AADD(aRet,{QUERY700->ZC4_FILIAL, ;
					QUERY700->ZC4_CODCON, ;
					QUERY700->ZC4_REVISA, ;
					QUERY700->ZC7_CODPRO, ;
					QUERY700->ZC7_CATEGO, ;
					QUERY700->ZC7_MARCA, ;
					QUERY700->ZB6_XFORNE, ;
					QUERY700->ZB6_XLJFOR })
			Else
				AADD(aRet,{QUERY700->(ZC4_FILIAL), ;
					QUERY700->(ZC4_CODCON), ;
					QUERY700->(ZC4_REVISA), ;
					QUERY700->(ZC7_CODPRO), ;
					QUERY700->(ZC7_CATEGO), ;
					QUERY700->(ZC7_MARCA) })
			EndIf

			QUERY700->( dbSkip() )

		EndDo
	

		// busca BANDEIRA ***NOVO***
	
	
		cQuery := "SELECT ZC4_FILIAL,ZC4_FILSEL,ZC7_CODCLI,ZC7_LOJA,ZC4_CODCON,ZC4_DESC,ZC4_REVISA,ZC7_CODPRO,ZC7_CATEGO,ZC7_MARCA " + CRLF
	
		cQuery += "FROM " + RetSqlName("ZC7") + "  ZC7   " + CRLF
	
		cQuery += "INNER JOIN " + RetSqlName("ZC4") + " ZC4 ON ZC4_CODCON=ZC7_CODCTR AND ZC4.D_E_L_E_T_='' " + CRLF 
		
		cQuery += "AND '" + cData + "' >= ZC4_DTINI AND ('" + cData + "' < ZC4_DTFIM OR ZC4_DTFIM = '') " + CRLF

		cQuery += "WHERE ZC7_BANDEI=(SELECT A1_XBAND FROM " + RetSqlName("SA1") + " SA1 WHERE A1_COD='" + cCliente + "' AND A1_LOJA='" + cLoja + "' " + CRLF 
		cQuery += "AND SA1.D_E_L_E_T_='') AND ZC7.D_E_L_E_T_='' " + CRLF
		cQuery += "AND (ZC4_FILSEL like '00-TODAS AS FILIAIS%' OR '" + cFil + "' IN (ZC4_FILSEL)) " + CRLF
		
		IF !lConsNF1
			cQuery += " AND ZC4_OBSOLE='F' AND ZC4_ATIVO = 'S' " + CRLF
		End If
		
		cQuery += "ORDER BY ZC7_CODPRO DESC,ZC7_CATEGO,ZC7_MARCA  " + CRLF
		
		MemoWrite("C:\HD\QUERYS\QUAA060W_BANDEIRA.SQL",cQuery)
		
		If Select( "QUERY800" ) > 0
			QUERY800->( dbCloseArea() )
		EndIf
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "QUERY800", .F., .T.)
		QUERY800->( dbGoTop() )
		While QUERY800->( !Eof() )

			If lCliCont
				AADD(aRet,{QUERY800->ZC4_FILIAL, ;
					QUERY800->ZC4_CODCON, ;
					QUERY800->ZC4_REVISA, ;
					QUERY800->ZC7_CODPRO, ;
					QUERY800->ZC7_CATEGO, ;
					QUERY800->ZC7_MARCA, ;
					QUERY800->ZB6_XFORNE, ;
					QUERY800->ZB6_XLJFOR })
			Else
				AADD(aRet,{QUERY800->(ZC4_FILIAL), ;
					QUERY800->(ZC4_CODCON), ;
					QUERY800->(ZC4_REVISA), ;
					QUERY800->(ZC7_CODPRO), ;
					QUERY800->(ZC7_CATEGO), ;
					QUERY800->(ZC7_MARCA) })
			EndIf

			QUERY800->( dbSkip() )

		EndDo


	For nx := 1 to len(aRet)
		If !Empty(aRet[nx][4]) .AND. Alltrim(cProduto) == Alltrim(aRet[nx][4])
			lAchou := .T.
		ElseIf Alltrim(aRet[nx][5]) + Alltrim(aRet[nx][6]) == Alltrim(cCatego) + Alltrim(cMarca)
			lAchou := .T.
		ElseIf Alltrim(aRet[nx][5]) + Alltrim(aRet[nx][6]) == '999999' + Alltrim(cMarca)
			lAchou := .T.
		ElseIf Alltrim(aRet[nx][5]) + Alltrim(aRet[nx][6]) == Alltrim(cCatego) + '999999'
			lAchou := .T.
		ElseIf Alltrim(aRet[nx][5]) + Alltrim(aRet[nx][6]) == '999999' + '999999'
			lAchou := .T.
		EndIf
		If lAchou
			If lCliCont
				AADD(aRet1,{aRet[nx][1] ,;
					aRet[nx][2],;
					aRet[nx][3],;
					aRet[nx][7],;
					aRet[nx][8] ;
					})
			Else
				AADD(aRet1,{aRet[nx][1] ,;
					aRet[nx][2],;
					aRet[nx][3] ;
					})
			EndIf
			Exit
		EndIf
	Next nx

Return aRet1

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ItensCtrW ºAutor  ³WILSON DAVILA       º Data ³  24/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     |Localizar itens do contrato                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ItCtrW(aZB6,nValor,aItensCtr,nValSt)

	Local 	nVlrAtu := 0 	// WMS.NN em 03-12-2015 em atendimento ao chamado 2418

	dbSelectArea("ZC5")
	dbSetOrder(1)//ZC5_FILIAL, ZC5_CODCON, ZC5_REVISA,ZC5_CODVER
	dbSeek(aZB6[1][1]+aZB6[1][2]+aZB6[1][3])

	While ZB5->(!Eof()) .And. aZB6[1][1] == ZC5->ZC5_FILIAL .And. aZB6[1][2] == ZC5->ZC5_CODCON .And. aZB6[1][3] == ZC5->ZC5_REVISA
	
		ZC3->( DbSetOrder(1) )
	
		If ZC3->( DbSeek(xFilial("ZC3")+ZC5->ZC5_CODVER,.T.))
	
			If ZC5->ZC5_CALCUL == '2'
				nVlrAtu := (nValor+nValSt)
			Else
				nVlrAtu := nValor 	// WMS.NN em 03-12-2015 em atendimento ao chamado 2418 - Apenas para melhor visualização
			EndIf
	
			//Aadd(aItensCtr,{ZC5->ZC5_CODVER,ZC5->ZC5_FORMA,ZC5->ZC5_PERCEN,ZC3->ZC3_PREFIX,ZC5->ZC5_CALCUL,aZB6[1][2], aZB6[1][3], ZC5->ZC5_DEVOLV,nVlrAtu} )
			Aadd(aItensCtr,{ZC5->ZC5_CODVER,;	//[1]
							ZC5->ZC5_FORMA,;	//[2]
							ZC5->ZC5_PERCEN,;	//[3]
							ZC3->ZC3_PREFIX,;	//[4]
							ZC5->ZC5_CALCUL,;	//[5]
							aZB6[1][2],;		//[6]
							aZB6[1][3],;		//[7]
							ZC5->ZC5_DEVOLV,;	//[8]
							nVlrAtu,;			//[9]
							nValor} ) 			//[10]
	
		EndIf
	
		ZC5->(DbSkip())

	EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAA060   ºAutor  ³Microsiga           º Data ³  03/02/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     |Rotina utilizada para Gerar Titulos a Pagar conforme        º±±
±±º          ³Regra de Desconto                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Queijos Quata                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QuaaPag( aItensCtr, nValorTit,cFornx,cLojForx,nxRec )

	Local aCpoSE2 	:= {}
	Local cQuery  	:= " "
	Local cAliasSE2 := GetNextAlias()
	Local cNatureza	:= GetMv("ES_NATDESC")
	Local nRec 		:= 0
	Local cTipo 	:= "NF"
	Local aArea		:= GetArea()

	SA1->(DbSetOrder(1) )
	If Empty(cFornx) .And. SA1->(Msseek(xFilial("SA1")+cCodCli+cLojCli,.F.))
		cFornx    := SA1->A1_XFORNEC
		cLojForx  := SA1->A1_XLJFORN
	EndIf

	If !Empty( cFornx ) .and. !Empty( cLojForx )
	 
	//Validar a existencia de mais titulos para o Contrato
		cQuery := "SELECT R_E_C_N_O_ AS REC "
		cQuery += "FROM "+RetSqlName("SE2")+" SE2 "
		cQuery += "WHERE SE2.E2_FILIAL='"+xFilial("SE2")+"' AND "
		cQuery += "SE2.E2_PREFIXO='"+aItensCtr[1]+"' AND "
		cQuery += "SE2.E2_NUM='"+cDuplic+"' AND "
		cQuery += "SE2.E2_FORNECE='"+cFornx+"' AND "
		cQuery += "SE2.E2_LOJA='"+cLojForx+"' AND "
		cQuery += "SE2.E2_ORIGEM='FINA050' AND "
		cQuery += "SE2.E2_NATUREZ='" + cNatureza + "' AND "
		cQuery += "SE2.D_E_L_E_T_=' ' "
		cQuery := ChangeQuery(cQuery)
		
		If Select(cAliasSE2) > 0
			dbSelectArea(cAliasSE2)
			(cAliasSE2)->( dbCloseArea() )
		EndIf
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE2,.T.,.T.)

		If (cAliasSE2)->(Eof())

			AADD(aCpoSE2,{"E2_FILIAL"	,xFilial("SE2")											,Nil})
			AADD(aCpoSE2,{"E2_PREFIXO"	,Pad(aItensCtr[1],Len(SE2->E2_PREFIXO))						,Nil})
			AADD(aCpoSE2,{"E2_NUM"		,Pad(cDuplic,	Len(SE2->E2_NUM))								,Nil})
			AADD(aCpoSE2,{"E2_PARCELA"	,Pad(" ",Len(SE2->E2_PARCELA))								,Nil})
			AADD(aCpoSE2,{"E2_TIPO"     ,Pad(cTipo,Len(SE2->E2_TIPO))								,Nil})
			AADD(aCpoSE2,{"E2_NATUREZ"	,Pad(cNatureza,Len(SE2->E2_NATUREZ))							,Nil})
			AADD(aCpoSE2,{"E2_FORNECE"	,cFornx 												,Nil})
			AADD(aCpoSE2,{"E2_LOJA"     ,cLojForx												,Nil})
			AADD(aCpoSE2,{"E2_EMISSAO"	,dDatabase												,Nil})
			AADD(aCpoSE2,{"E2_VENCTO"	,dDatabase												,Nil})
			AADD(aCpoSE2,{"E2_VALOR"	,nValorTit												,Nil})
			AADD(aCpoSE2,{"E2_ORIGEM"	,Pad("FINA050",Len(SE2->E2_ORIGEM))							,Nil})
			AADD(aCpoSE2,{"E2_XNCONTR"	,Pad(aItensCtr[2],Len(SE2->E2_XNCONTR))						,Nil})
			AADD(aCpoSE2,{"E2_REVISC"	,Pad(aItensCtr[3],Len(SE2->E2_REVISC))						,Nil})
			AADD(aCpoSE2,{"E2_HIST"	,Pad("NOTA GERADA POR DESCONTO CONTRATUAL",Len(SE2->E2_HIST))	,Nil})

			lMsErroAuto:=.F.
			lMSHelpAuto:= .T.
			INCLUI := .T.
			MSExecAuto( { | x, y, z | Fina050( x, y, z ) }, aCpoSE2,, 3 )
			If lMsErroAuto
				Mostraerro()
			Else
				nRec := SE2->( Recno() )
			Endif
		Else
			
			nxRec := (cAliasSE2)->REC
			//msgalert(cValToChar(nxRec))
		EndIf
		(cAliasSE2)->( DbCloseArea() )
	Else
		MsgAlert("Nao foram gerados os titulos de Desconto com Retencao a Pagar para o Cliente "+cCodCli+'/'+cLojCli+;
			" porque nao foi preenchido o Codigo do Fornecedor no Cadastro do Cliente", 'Ajustar Cadastro de Cliente')
		
		cMsg 	:= "Nota: "+cDuplic +" da Filial: " + xFilial("SE2") + " NAO gerou Desconto Contratual com Retencao a Pagar para o Cliente " + cCodCli + '/' + cLojCli + '<hr>'
		cMsg	+= ",porque nao foi preenchido o Codigo do Fornecedor no Cadastro do Cliente, ajustar Cadastro de Cliente"
		
		
		cEmail := 'fernando.bonacordi@quataalimentos.com.br;monica.pessoa@quataalimentos.com.br;celso.prado@quataalimentos.com.br;'
		cEmail += 'luiz.coutinho@quataalimentos.com.br;wilson.oliveira@quataalimentos.com.br'
		
		U_QUTSMAIL("Nota " + cDuplic + " nao Gerou Contas a Pagar",cMsg,"",cEmail)
		
		Return nRec
	EndIf
	
Return nRec


Static Function CheckZC6(xFil,xPrefixo,xNum,xParc,xTipo,xCli,xLoja)

Local lRet := .T.
Local cAliasQry := GetNextAlias()
Local aArea	:= GetArea()				
	BeginSql Alias cAliasQry
		
		SELECT ZC6_RECSE1
		FROM %Table:ZC6% ZC6
		WHERE ZC6.%notDel%
		AND ZC6.ZC6_FILIAL 	= %Exp:xFil%
		AND ZC6.ZC6_PREFIX	= %Exp:xPrefixo%
		AND ZC6.ZC6_NUM 	= %Exp:xNum%
		AND ZC6.ZC6_PARCEL 	= %Exp:xParc%
		AND ZC6.ZC6_TIPO 	= %Exp:xTipo%
		AND ZC6.ZC6_CODCLI 	= %Exp:xCli%
		AND ZC6.ZC6_LOJA 	= %Exp:xLoja%
	
	EndSql

lRet := (cAliasQry)->(Eof() )
(cAliasQry)->(DbCloseArea()  )

RestArea(aArea)

Return lRet





	
	
	
	