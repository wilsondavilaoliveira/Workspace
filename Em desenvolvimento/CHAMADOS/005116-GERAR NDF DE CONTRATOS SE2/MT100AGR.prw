#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100AGR  ºAutor  ³Wilson Davila       º      ³  14/05/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada final gravacao Nf ENTRADA                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100AGR()

	Local aAreaAnt      := GetArea()
	Local nXa           := 0
	Local __nFrete       := 0
	Local __nOutros      := 0
	Local __nINSS        := 0
	Local __nLiquid 		:= 0
	Local __nIncen		:= 0
	Local nPos			:= 0
	Local aAreaSD1 		:= GetArea()
	Local _nBaseSolx      := 0
	Local _nValSolx 		:= 0
	Local nLinha	        := 1
	Local aMva          := {}
	
	Private oProcess	:= NIL
	Private cData
	SetPrvt("__oDlg1","__oSay1","__oGet1","__oBtn1")

		
	//If INCLUI

	If !atisrotina("U_QUAA022B") .and. !atisrotina("U_ACB1711A") .and. !atisrotina("U_ACB2001A") .and. !atisrotina("U_GERNFCAP")
			//msgalert("atis")
			////Wilson 21/05/2013 -- MVA

			// WMS.sn em 02/03/2017 Chamado 000794
		If INCLUI .And. SF1->F1_TIPO == 'D' .And. SF1->F1_FORMUL == 'S'
			Processa({|| FeitFora()})
		EndIf
			// WMS.en em 02/03/2017 Chamado 000794

		If SF1->F1_TIPO == 'D' //.AND. SF1->F1_BRICMS+SF1->F1_ICMSRET = 0///SF1->F1_FORMUL <> 'S' //SOMENTE SE FOR DEVOLUCAO E FORUMLARIO <> DE PROPRIO
			//msgalert("sf1") 
			_nBaseSolx := 0
			_nValSolx  := 0
								
			SD1->(dbSetOrder(1)) //POSICIONO NO ITEM DA NOTA DE ENTRADA
			SD1->(dbSeek(Alltrim(SF1->F1_FILIAL)+Alltrim(SF1->F1_DOC)+Pad(SF1->F1_SERIE,3)+Alltrim(SF1->F1_FORNECE)+Alltrim(SF1->F1_LOJA)))
								
				//ENQUANTO FILIAL+DOC+SERIE+FORNECEDOR+LOJA DO ITEM FOR IGUAL AO CABECALHO DA NOTA
			While SD1->(!Eof()) .and. (SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
									
				_nBaseSol := 0
				_nValSol  := 0
										 
				SA1->(dbSetOrder(1))
				SA1->(dbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA))
					
				If ALLTRIM(SA1->A1_TIPO) == 'S' .AND. ALLTRIM(SA1->A1_XMVA) == 'S' .AND. SD1->D1_TIPO == "D"
					
					aMva := U_BuscMVAE( SA1->A1_EST, SD1->D1_COD )
					//{ ZZC_PERMVA, ZZC_PERICM, ZZC_REDSAI, ZZC_PICMSE, ZZC_REDENT }
					
					If Len(aMva) > 0
						_nBaseSol 	:=  ( ( (SD1->D1_TOTAL * aMva[1] )/100 ) + SD1->D1_TOTAL ) //D1_BRICMS
							
						If aMva[3]>0 //Verifica se existe redução na Saida
	
							_nBaseSol 	:=   ( _nBaseSol - ( _nBaseSol * (aMva[3] ))/100)
				
						End If
				
						_nDebST := (_nBaseSol *  aMva[2] ) /100 //Debito ST
							
							
						If aMva[5] > 0 //Verifica se existe reducao na Entrada
			
							_nBasEnt := SD1->D1_TOTAL - ( (SD1->D1_TOTAL * aMva[5]) / 100 ) //Base ICMS Entrada COM reducao
								
						Else
							
							_nBasEnt := SD1->D1_TOTAL //Base ICMS Entrada SEM reducao
								
						End If
												
							
						_nICMEnt := ( (_nBasEnt *  aMva[4])/100 ) // Valor ICMS Entrada
			
						_nValSol	:= Round( _nDebST - _nICMEnt  ,2) //Valor a pagar ICMS ST
						
					Endif
						
				End If
					
				_nBaseSolx	+=	_nBaseSol
				_nValSolx	+=	_nValSol
					
				SD1->( dbSkip() )
					
			End While
					
			nValor := SF1->F1_VALMERC
										
			IF _nBaseSolx + _nValSolx > 0
				RecLock("SF1",.F.)
				SF1->F1_BRICMS 	:= Round(_nBaseSolx,2)
				SF1->F1_ICMSRET := _nValSolx
				SF1->F1_VALBRUT	:= nValor + _nValSolx
				MsUnlock()
			End If
			
		End If
			
			///FIM MVA - WILSON
						
			* Wilson 23/09/09 Gravar vendedores Quata e Cristina para calculo de desconto de comissao nas devolucoes relatorio QUTR540A
		If SF1->F1_TIPO == 'D' .AND. SF1->F1_FORMUL == 'S'
			RecLock("SF1",.F.)
			SF1->F1_VEND1 := SF2->F2_VEND1
			SF1->F1_VEND4 := SF2->F2_VEND4
				*Adicionado 19/02/10 comissao venda de leite
			SF1->F1_VEND7 := SF2->F2_VEND7
				*
				*Adicionado 06/09/12 comissao venda Gloria
			SF1->F1_VEND8 := SF2->F2_VEND8

				*Adicionado 18/02/13 comissao venda bom jesus
			SF1->F1_VEND9 := SF2->F2_VEND9


				*
			MsUnlock()
		ElseIf SF1->F1_TIPO == 'D'
			RecLock("SF1",.F.)
			SF1->F1_VEND1 := Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_XVEND01")
			SF1->F1_VEND4 := Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_XVEND02")
				*Adicionado 19/02/10 comissao venda de leite
			SF1->F1_VEND7 := Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_XVEND03")
				*
				*Adicionado 06/09/12 comissao venda Gloria
			SF1->F1_VEND8 := Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_XVEND04")
				*Adicionado 18/02/3 comissao venda Perdoes
			SF1->F1_VEND9 := Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_XVEND05")
				*
			MsUnlock()
		End If

		dbSelectArea("LBB")
		dbSetOrder(2)

		If dbSeek( xFilial("LBB") + SF1->F1_FORNECE + SF1->F1_LOJA )
			If Pegadado(@__nFrete, @__nOutros, @__nINSS, @__nLiquid,@__nIncen)
				dbSelectArea("SF1")
				RecLock("SF1", .F.)
				SF1->F1_XINSS 	:= __nINSS
				SF1->F1_XFRETE	:= __nFrete
				SF1->F1_XOUTROS	:= __nOutros
				SF1->F1_XLIQUID	:= __nLiquid
				SF1->F1_XINCEN	:= __nIncen
				MsUnlock()
			Endif
		Endif
		RestArea(aAreaAnt)
		aAreaAnt := GetArea()
			
		SE1->(dbSetOrder(2))
			
		If SE1->(dbSeek(xFilial('SE1')+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DUPL))
			If SF1->F1_TIPO == 'D' .AND. !EMPTY(SF1->F1_DUPL)
					
				nValor := IIF( (_nBaseSolx + _nValSolx) > 0,SF1->F1_VALBRUT,SE1->E1_VALOR ) //MVA ALTERACAO VALOR NCC WILSON 22/05/13
				nSaldo  := SE1->E1_SALDO
				nSdoMva	:= nValor - (SE1->E1_VALOR-SE1->E1_SALDO)
					
				RecLock("SE1",.F.)
					
				SE1->E1_U_RAZAO := SA1->A1_NOME
							 
				If (_nBaseSolx + _nValSolx) > 0 .AND. nSaldo > 0
					SE1->E1_VALOR	:= nValor
					SE1->E1_VLCRUZ	:= nValor
					SE1->E1_SALDO	:= nSdoMva
					SE1->E1_XVLRIST	:= _nValSolx 	// WMS.NN em 28-12-2015 em atendimento do chamado 2418 - Gravar valor de ICMS ST em campo específico para poder demonstrar composição de valores de descontos e ST em separado.
				End If
							
				MsUnlock()
			EndIf
		EndIf

		If SF1->F1_TIPO == 'D' .AND. SF1->F1_FORMUL <> 'S' .AND. !EMPTY(SF1->F1_DUPL)

			SE4->(dbSetOrder(1))
			SE4->(dbseek(xFilial("SE4")+SA1->A1_COND))
				
			SE1->(dbSetOrder(2))
			If SE1->(dbSeek(xFilial('SE1')+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DUPL))
              
				RecLock("SE1",.F.)
              
				If SE4->E4_TIPO <> '4'
					SE1->E1_EMISSAO := DDEMISSAO
					SE1->E1_VENCTO  := DataValida(DDEMISSAO + VAL(SUBSTR(SE4->E4_COND,1,2)))
					SE1->E1_VENCREA := DataValida(DDEMISSAO + VAL(SUBSTR(SE4->E4_COND,1,2)))
					SE1->E1_VENCORI := DataValida(DDEMISSAO + VAL(SUBSTR(SE4->E4_COND,1,2)))
				Else

					For i := 1 to Len(SE4->E4_COND)

						If Substr(SE4->E4_COND,i,1) == ','
							nPos := i + 1
							i := Len(SE4->E4_COND)
						End If

					Next i

					SE1->E1_EMISSAO := DDEMISSAO
					SE1->E1_VENCTO  := DataValida(DDEMISSAO + VAL(SUBSTR(SE4->E4_COND,nPos,2)))
					SE1->E1_VENCREA := DataValida(DDEMISSAO + VAL(SUBSTR(SE4->E4_COND,nPos,2)))
					SE1->E1_VENCORI := DataValida(DDEMISSAO + VAL(SUBSTR(SE4->E4_COND,nPos,2)))

				End If

				MsUnlock()

				If MsgYesNo("Data de Vencimento Devolução Cliente : " + SPACE(48) + CVALTOCHAR(SE1->E1_CLIENTE)	+ "/" + CVALTOCHAR(SE1->E1_LOJA) + "-" + SA1->A1_NOME + SPACE(38) + SPACE(38) + " < < < " +  CVALTOCHAR(SE1->E1_VENCREA) + " > > >  -  Deseja Alterar a Data de vencimento ?","Vencimento Devoluções")
					SE4->(dbSetOrder(1))
					SE4->(dbseek(xFilial("SE4")+SA1->A1_COND))
					cData := DataValida(DDEMISSAO + VAL(SUBSTR(SE4->E4_COND,1,2)))
					__oDlg1:= MSDialog():New( 112,231,193,468,"Data de Vencimento ",,,.F.,,,,,,.T.,,,.T. )
					__oSay1:= TSay():New( 004,004,{||" Data de Vencimento"},__oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
					__oGet1:= TGet():New( 012,005,{|u| If(PCount()>0,cData:=u,cData)},__oDlg1,035,010,'99/99/99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
					__oBtn1:= TButton():New( 012,068,"Altera Data",__oDlg1,{ ||DlgExit()  },040,012,,,,.T.,,"",,,,.F. )
					__oDlg1:Activate(,,,.T.)
				End If


			End If

		End If

	End If

	//End If
	RestArea(aAreaAnt)

	aAreaAnt := GetArea()
   // chamado 7198 - alterado por Roberto R. Mezzalira 07/11/16 - incluso tratamento para a classificação da pre nota 
	IIF(SF1->F1_TIPO == 'D' .AND. SF1->F1_FORMUL <> 'S' .AND. !EMPTY(SF1->F1_DUPL),PagDev(INCLUI.or.ALTERA),NIL) //PagDev(INCLUI)
    
    //MVA WILSON 22/05/13
	IF SF1->F1_TIPO == 'D' .AND. ( _nBaseSolx + _nValSolx > 0 ) //.AND. SF1->F1_FORMUL <> 'S'
    
	    //REPROCESSA LIVRO DE ENTRADA
		Pergunte("MTA930",.F.)
	  // MSGALERT("LIVRO FISCAL") 
		MV_PAR01 := SF1->F1_DTDIGIT
		MV_PAR02 := SF1->F1_DTDIGIT
		MV_PAR04 := SF1->F1_DOC
		MV_PAR05 := SF1->F1_DOC
		MV_PAR06 := SF1->F1_SERIE
		MV_PAR07 := SF1->F1_SERIE
		MV_PAR08 := SF1->F1_FORNECE
		MV_PAR09 := SF1->F1_FORNECE
		MV_PAR10 := SF1->F1_LOJA
		MV_PAR11 := SF1->F1_LOJA
	    
	    if !IsBlind() 
	    	oProcess := MsNewProcess():New({|| A930RPEntrada(.T.,oProcess) }," Processando Livro Fiscal ","Processando Livro Fiscal: ",.T.)
	    Else
	    	A930RPEntrada(.T.)
	    EndIf
	    
	End If
    
    //FIM MVA

	RestArea(aAreaAnt)
    
    //// ACD - Tratamento para nota de devolucao que sera usada para revenda do produto.
    aAreaAnt := GetArea()
    
    If SF1->F1_TIPO == 'D' .AND. SF1->F1_FILIAL == '01'

	lRevenda := .F.	

		SD1->(DbSetOrder(1))
		If SD1->(DbSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)) 
		
			While SD1->( !Eof() ) .AND. (SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		
				If SD1->D1_LOCAL == '23'
					U_NMCB56D(SD1->D1_NFORI,SD1->D1_SERIORI,SD1->D1_COD)//Marca CB0 e PX3 com status 'R' revenda
					lRevenda := .T.
				End If
			
			SD1->( dbSkip() )
			
			End While
		
		End If

		If lRevenda // No caso de revenda ja indica que nota de devolucao foi conferida.
			RecLock("SF1",.F.)
				SF1->F1_STATCON := '4'
		    MsUnlock()
		End If
	
	End If

    RestArea(aAreaAnt)
    
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100AGR  ºAutor  ³Microsiga           º Data ³  11/17/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function DlgExit()

	SE1->(dbSetOrder(2))
	If SE1->(dbSeek(xFilial('SE1')+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DUPL))

		If cData < SE1->E1_EMISSAO
			Alert("Data de vencimento não pode ser inferior a data de emissão !                     ")
		Else
			RecLock("SE1",.F.)
			SE1->E1_VENCTO 	:= DataValida(cData)
			SE1->E1_VENCREA := DataValida(cData)
			SE1->E1_VENCORI := DataValida(cData)
			MsUnlock()
			__oDlg1:end()
		End If

	End If

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100AGR  ºAutor  ³Microsiga           º Data ³  11/17/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Pegadado(__nFrete, __nOutros, __nINSS, __nLiquid, __nIncen)

	Local oBmp, oDlgLogin,oCbxEmp,oFrete, oOutros, oINSS, oLiquid, oBtnOk, oBtnCancel, oFont, oIncen
	Local lOk				:= .F.

	oFont := TFont():New('Arial',, -11, .T., .T.)


	DEFINE MSDIALOG oDlgLogin FROM  0,0 TO 220,380  Pixel TITLE OemToAnsi("Dados Adicionais")
	oDlgLogin:lEscClose := .F.
	@ 000,000 BITMAP oBmp RESNAME "LOGIN" oF oDlgLogin SIZE 95,oDlgLogin:nBottom  NOBORDER WHEN .F. PIXEL

	@ 010,050 Say "FUNRURAL:" PIXEL of oDlgLogin   FONT oFont //
	@ 018,050 GET oINSS  VAR __nINSS  SIZE 70, 9 Picture "@E 999,999,999.99" OF oDlgLogin PIXEL FONT oFont

	@ 010,130 Say "Frete:" PIXEL of oDlgLogin  FONT oFont //
	@ 018,130 GET oFrete VAR __nFrete  SIZE 70, 9 Picture "@E 999,999,999.99" OF oDlgLogin PIXEL FONT oFont

	@ 034,050 Say "Outros:" PIXEL of oDlgLogin  FONT oFont //
	@ 042,050 GET oOutros VAR __nOutros  SIZE 70, 9 Picture "@E 999,999,999.99" OF oDlgLogin PIXEL FONT oFont

	@ 058,050 Say "Liquido:" PIXEL of oDlgLogin  FONT oFont //
	@ 066,050 GET oLiquid VAR __nLiquid  SIZE 70, 9 Picture "@E 999,999,999.99" OF oDlgLogin PIXEL FONT oFont

	@ 058,130 Say "Incentivo:" PIXEL of oDlgLogin  FONT oFont //
	@ 066,130 GET oIncen VAR __nIncen  SIZE 70, 9 Picture "@E 999,999,999.99" OF oDlgLogin PIXEL FONT oFont

	TButton():New( 090,100,"&Ok", oDlgLogin, {|| lOk := .T. , oDlgLogin:End() }, 38, 14,,, .F., .t., .F.,, .F.,,, .F. )
	TButton():New( 090,140,"&Cancelar", oDlgLogin, {|| lOk := .F. , oDlgLogin:End() }, 38, 14,,, .F., .t., .F.,, .F.,,, .F. ) //

	ACTIVATE MSDIALOG oDlgLogin CENTERED

Return lOk


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGDEV    ºAutor  ³Wilson Davila       º Data ³  21/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Lanca devolucao no contas a pagar SE2  e deleta lancamento º±±
±±º          ³ NCC SE1 execeto para clientes cadastrados na tabela ZAE    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Queijos Quata                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PagDev(lIncExc,dVenc)

	Local aCpoSE2 	:= {}
	Local aCpoSE1 	:= {}
	Local cForn		:= ''
	Local cLojaf	:= ''
	Local nPerDesc	:= 0
	Local nPerPag	:= 0
	Local lExclui	:= .T.
	Default dVenc	:= CtoD("  /  /  ")
	
	IF lIncExc //INCLUSAO DOCUMENTO DE ENTRADA.
		
		DBSELECTAREA("ZAE")
		ZAE->(dbSetOrder(1))
		DBGOTOP()
		//Se o cliente estiver na tabela ZAE segue o padrao (NCC) a receber, se nao encontrar exclui a NCC e lanca titulo a pagar
		//if cFilAnt == '01' .AND. !ZAE->(DbSeek(xFilial('ZAE')+ SF1->F1_FORNECE))
		//Retirada opcao para filial 01, vale para todas as filias - pedido Luiz 21/08/2014
		
		IF !ZAE->(DbSeek(xFilial('ZAE')+ SF1->F1_FORNECE))
			
			SA1->(dbSetOrder(1))
			SA1->(DbSeek(xFilial('SA1')+ SF1->F1_FORNECE+SF1->F1_LOJA))

			If !Empty(SA1->A1_FORNECE) .AND. !Empty(SA1->A1_LOJAFOR)//Se nao existir amarracao Cliente x Fornecedor segue o padrao (NCC) e avisa.

				cForn	:= SA1->A1_FORNECE
				cLojaf	:= SA1->A1_LOJAFOR

				//SE1->(dbSetOrder(24)) V - E1_FILIAL+E1_NUM+E1_TIPO+E1_CLIENTE+E1_LOJA 
				SE1->( DBORDERNICKNAME('SE1NUMTIT') )



				If SE1->(dbSeek(xFilial('SE1')+PAD(SF1->F1_DUPL,LEN(SE1->E1_NUM))+'NCC'+alltrim(SF1->F1_FORNECE)+alltrim(SF1->F1_LOJA)))

					IF Empty(SE1->E1_BAIXA) //Se titulo nao esta baixado exclui

						AADD(aCpoSE1,{"E1_PREFIXO" ,SE1->E1_PREFIXO		,Nil})
						AADD(aCpoSE1,{"E1_NUM"     ,SE1->E1_NUM			,Nil})
						AADD(aCpoSE1,{"E1_PARCELA" ,SE1->E1_PARCELA		,Nil})
						AADD(aCpoSE1,{"E1_TIPO"    ,SE1->E1_TIPO    	,Nil})

						lMsErroAuto:=.F.
						lMSHelpAuto:= .T.
						INCLUI := .F.
						_FlagCTB := .F.
						
						IF _FlagCTB := SubStr(SE1->E1_LA,1,1) == "S" //Chamado 001081
							RecLock("SE1",.F.)
								SE1->E1_LA 		:= ''
							MsUnlock()
						EndIF
						
						MsExecAuto( { |x,y| fina040(x,y)},aCpoSe1,5)
						
						If lMsErroAuto
						
							IF _FlagCTB //Chamado 001081
								RecLock("SE1",.F.)
									SE1->E1_LA 	:= 'S'
								MsUnlock()
							EndIF
							
							Mostraerro()
							lExclui := .F.
						Endif

					Else //Se titulo esta baixado exclui baixa

						AADD(aCpoSE1,{"E1_PREFIXO" ,SE1->E1_PREFIXO		,Nil})
						AADD(aCpoSE1,{"E1_NUM"     ,SE1->E1_NUM			,Nil})
						AADD(aCpoSE1,{"E1_PARCELA" ,SE1->E1_PARCELA		,Nil})
						AADD(aCpoSE1,{"E1_TIPO"    ,SE1->E1_TIPO    	,Nil})

						lMsErroAuto:=.F.
						lMSHelpAuto:= .T.
						INCLUI := .F.

						MsExecAuto( { |x,y| fina070(x,y)},aCpoSe1,5)
						If lMsErroAuto
							Mostraerro()
						Endif

						//Apos excluir baixa, exclui titulo
						AADD(aCpoSE1,{"E1_PREFIXO" ,SE1->E1_PREFIXO		,Nil})
						AADD(aCpoSE1,{"E1_NUM"     ,SE1->E1_NUM			,Nil})
						AADD(aCpoSE1,{"E1_PARCELA" ,SE1->E1_PARCELA		,Nil})
						AADD(aCpoSE1,{"E1_TIPO"    ,SE1->E1_TIPO    	,Nil})

						lMsErroAuto:=.F.
						lMSHelpAuto:= .T.
						INCLUI := .F.
						_FlagCTB := .F.
						
						IF _FlagCTB := SubStr(SE1->E1_LA,1,1) == "S" //Chamado 001081
							RecLock("SE1",.F.)
								SE1->E1_LA 		:= ''
							MsUnlock()
						EndIF
						
						MsExecAuto( { |x,y| fina040(x,y)},aCpoSe1,5)
						
						If lMsErroAuto
						
							IF _FlagCTB //Chamado 001081
								RecLock("SE1",.F.)
									SE1->E1_LA 	:= 'S'
								MsUnlock()
							EndIF
							
							lExclui := .F.
							Mostraerro()
						Endif

					End If

					
					if FunName()!="XPAGDEV"
						dData 		:= dDataBase
						dDataBase 	:= SF1->F1_DTDIGIT //E1->E1_EMISSAO
					endif
					
					IF lExclui //SOMENTE LANCA NO CONTAS A PAGAR SE A EXCLUSAO DO TITULO NCC FOI EXCLUIDO
						
						//Renato Ruy - 17/04/2019
						//Quando a data de vencimento e inferior ao dia atual
						If Empty(dVenc) .And. SE1->E1_VENCTO < Date()
							dVenc := Date()+30
						Endif
						
						//Efetua lancamento no contas a pagar
						AADD(aCpoSE2,{"E2_FILIAL"  ,xFilial("SE2"),										Nil})
						AADD(aCpoSE2,{"E2_PREFIXO" ,Pad(SF1->F1_PREFIXO,	Len(SE2->E2_PREFIXO)),		Nil})
						AADD(aCpoSE2,{"E2_NUM"     ,Pad(SF1->F1_DUPL,		Len(SE2->E2_NUM)),			Nil})
						AADD(aCpoSE2,{"E2_PARCELA" ,Pad(" ", 				Len(SE2->E2_PARCELA)),		Nil})
						AADD(aCpoSE2,{"E2_TIPO"    ,Pad("NF",				Len(SE2->E2_TIPO)),			Nil})
						AADD(aCpoSE2,{"E2_NATUREZ" ,Pad("PGDV",				Len(SE2->E2_NATUREZ)),		Nil})
						AADD(aCpoSE2,{"E2_FORNECE" ,Pad(cForn,				Len(SE2->E2_FORNECE)),		Nil})
						AADD(aCpoSE2,{"E2_LOJA"    ,Pad(cLojaf,				Len(SE2->E2_LOJA)),			Nil})
						AADD(aCpoSE2,{"E2_EMISSAO" ,SF1->F1_EMISSAO,									Nil})
						AADD(aCpoSE2,{"E2_VENCTO"  ,iif(Empty(dVenc),SE1->E1_VENCTO,dVenc),				Nil})
						AADD(aCpoSE2,{"E2_VALOR"   ,SE1->E1_VALOR,										Nil})
						AADD(aCpoSE2,{"E2_DESCONT" ,SE1->E1_VALLIQ,										Nil})
						AADD(aCpoSE2,{"E2_ORIGEM"  ,Pad("PAGDEV",			Len(SE2->E2_ORIGEM)),		Nil})
						AADD(aCpoSE2,{"E2_HIST"    ,Pad("NF DEVOLUCAO",		Len(SE2->E2_HIST))	,		Nil})
						AADD(aCpoSE2,{"E2_CCD"     ,Pad("999999",			Len(SE2->E2_CCD))	,		Nil})
	
						lMsErroAuto:=.F.
						lMSHelpAuto:= .T.
						INCLUI := .T.
	
						MSExecAuto( { | x, y, z | Fina050( x, y, z ) }, aCpoSE2,, 3 )
	
						If lMsErroAuto
						
							U_QUTSMAIL("Erro Inclusao PAGDEV:","Erro Inclusao PAGDEV: NF - " + SF1->F1_DUPL,,'fernando.bonacordi@quataalimentos.com.br;wilson.oliveira@quataalimentos.com.br;andreia.bezerra@quataalimentos.com.br')
							Mostraerro()
						
						Else //se execauto e inclusao no SE2 for ok
						
							//SE TIVER CONTRATO FAZ BAIXA DO VALOR REFERENTE A CONTRATO COMERCIAL
							
							aCpoSE2 	:= {}
							aDesc		:= U_xDescF1()
							nPerDesc 	:= aDesc[1][1]
							nPerPag		:= aDesc[1][2]
							
							If nPerDesc > 0 //Somente se houver valor de contrato faz baixa parcial.
								
								AADD(aCpoSE2,{"E2_FILIAL"  ,xFilial("SE2"),										Nil})
								AADD(aCpoSE2,{"E2_PREFIXO" ,Pad(SF1->F1_PREFIXO,	Len(SE2->E2_PREFIXO)),		Nil})
								AADD(aCpoSE2,{"E2_NUM"     ,Pad(SF1->F1_DUPL,		Len(SE2->E2_NUM)),			Nil})
								AADD(aCpoSE2,{"E2_PARCELA" ,Pad(" ", 				Len(SE2->E2_PARCELA)),		Nil})
								AADD(aCpoSE2,{"E2_TIPO"    ,Pad("NF",				Len(SE2->E2_TIPO)),			Nil})
								AADD(aCpoSE2,{"E2_NATUREZ" ,Pad("PGDV",				Len(SE2->E2_NATUREZ)),		Nil})
								AADD(aCpoSE2,{"E2_FORNECE" ,Pad(cForn,				Len(SE2->E2_FORNECE)),		Nil})
								AADD(aCpoSE2,{"E2_LOJA"    ,Pad(cLojaf,				Len(SE2->E2_LOJA)),			Nil})
								aAdd(aCpoSE2,{"AUTMOTBX",    'EDC',       										NIL})
								aAdd(aCpoSE2,{"AUTBANCO",    ' ',       										NIL})
								aAdd(aCpoSE2,{"AUTAGENCIA",  ' ',       										NIL})
								aAdd(aCpoSE2,{"AUTCONTA",    ' ',       										NIL})
								aAdd(aCpoSE2,{"AUTDTBAIXA",  dDataBase,       									NIL})
								aAdd(aCpoSE2,{"AUTHIST",     'Estorno Desconto Concedido',      				NIL})
								aAdd(aCpoSE2,{"AUTDESCONT",  0,       											NIL})
								aAdd(aCpoSE2,{"AUTMULTA",    0,       											NIL})
								aAdd(aCpoSE2,{"AUTJUROS",    0,		  											Nil})
								aAdd(aCpoSE2,{"AUTOUTGAS",   0,  				      							NIL})
								aAdd(aCpoSE2,{"AUTVLRPG",    nPerDesc,      			 						NIL})
								aAdd(aCpoSE2,{"AUTVLRME",    0,       											NIL})
								aAdd(aCpoSE2,{"AUTCHEQUE",   ' ',     											".T."})
					
				
								LMSErroAuto := .F.
								lMsHelpAuto := .T.
								
								MSExecAuto({|a,b,c,d,e,f| Fina080(a,b,c,d,e,f)},aCpoSE2,3,Nil,Nil,Nil,.F.)  // NAO Contabiliza On-Line
								
								If lMsErroAuto
									//msgalert("erro")							
									U_QUTSMAIL("Erro EDC PAGDEV:","Erro Inclusao EDC: NF - " + SF1->F1_DUPL,,'fernando.bonacordi@quataalimentos.com.br;wilson.oliveira@quataalimentos.com.br;andreia.bezerra@quataalimentos.com.br')
									Mostraerro()
								Else
							
								End If
								
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
									AADD(aCpoSE2,{"E2_NATUREZ" ,Pad("DSC",Len(SE2->E2_NATUREZ))								,Nil})
									AADD(aCpoSE2,{"E2_FORNECE" ,Pad(cForCon,Len(SE2->E2_FORNECE))							,Nil})
									AADD(aCpoSE2,{"E2_LOJA"    ,Pad(cLjfCon,Len(SE2->E2_LOJA))								,Nil})
									AADD(aCpoSE2,{"E2_EMISSAO" ,SF1->F1_EMISSAO												,Nil})
									AADD(aCpoSE2,{"E2_VENCTO"  ,iif(Empty(dVenc),SE1->E1_VENCTO,dVenc)						,Nil})
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
							
							End IF
							if FunName()!="XPAGDEV"
								dDataBase := dData
							endif
				
						Endif
					
					Else
					
						MsgStop ("Devolução não lançada no Contas a pagar, informe Depto. Financeiro ! ")
						U_QUTSMAIL("PAGDEV-CLIENTE: "+SF1->F1_FORNECE+"-"+SF1->F1_LOJA,"NOTA DE DEVOLUÇÃO: "+SF1->F1_DUPL+" CLIENTE: "+SF1->F1_FORNECE+"-"+SF1->F1_LOJA+" NÃO LANÇADA NO CONTAS A PAGAR, GEROU NCC PELO PADRÃO.",;
							,"fernando.bonacordi@quataalimentos.com.br;celso.prado@quataalimentos.com.br;contasareceber@quataalimentos.com.br;cadastro.cliente@quataalimentos.com.br")
			
					End If

				End If

			Else

				MsgStop ("Devolução não lançada no Contas a pagar, informe Depto. Financeiro ! ")
				U_QUTSMAIL("PAGDEV-CLIENTE: "+SF1->F1_FORNECE+"-"+SF1->F1_LOJA,"NOTA DE DEVOLUÇÃO: "+SF1->F1_DUPL+" CLIENTE: "+SF1->F1_FORNECE+"-"+SF1->F1_LOJA+" NÃO LANÇADA NO CONTAS A PAGAR, GEROU NCC PELO PADRÃO,COLOCAR CODIGO E LOJA DE FORNECEDOR CORRESPONDENTE AO CLIENTE NO CADASTRO DE CLIENTES",;
					,"fernando.bonacordi@quataalimentos.com.br;celso.prado@quataalimentos.com.br;contasareceber@quataalimentos.com.br;cadastro.cliente@quataalimentos.com.br")
			
			End If

		End If

	Else //EXCLUSAO DOCUMENTO DE ENTRADA
		
		
		if !ZAE->(DbSeek(xFilial('ZAE')+ SF1->F1_FORNECE))
			SA1->(dbSetOrder(1))
			SA1->(DbSeek(xFilial('SA1')+ SF1->F1_FORNECE+SF1->F1_LOJA))
		
			SE2->(dbSetOrder(1))
			
			cForn	:= SA1->A1_FORNECE
			cLojaf	:= SA1->A1_LOJAFOR
			
									
			If SE2->(dbSeek(SF1->F1_FILIAL+Pad(SF1->F1_PREFIXO,TamSX3("E2_PREFIXO")[1])+Pad(SF1->F1_DUPL,TamSX3("E2_NUM")[1]) + "  " + Pad("NF",TamSX3("E2_TIPO")[1])+cForn+cLojaf))
			
				nReg := SE2->( Recno() )
			
			//MSGALERT("SE2")	
			
				If !Empty(SE2->(E2_BAIXA))
			
					aBaixa := {}
					AADD(aBaixa, {"E2_FILIAL" 	,SE2->(E2_FILIAL) 	, Nil})
					AADD(aBaixa, {"E2_PREFIXO" 	,SE2->(E2_PREFIXO) 	, Nil})
					AADD(aBaixa, {"E2_NUM" 		,SE2->(E2_NUM) 		, Nil})
					AADD(aBaixa, {"E2_PARCELA" 	,SE2->(E2_PARCELA) 	, Nil})
					AADD(aBaixa, {"E2_TIPO" 	,SE2->(E2_TIPO) 	, Nil})
					AADD(aBaixa, {"E2_FORNECE" 	,SE2->(E2_FORNECE) 	, Nil})
					AADD(aBaixa, {"E2_LOJA" 	,SE2->(E2_LOJA)		, Nil})
										
					MSEXECAUTO({|x,y| FINA080(x,y)}, aBaixa, 6)
					
					lMsErroAuto:=.F.
					lMSHelpAuto:= .T.
					INCLUI := .T.
		
					If lMsErroAuto
						MOSTRAERRO()
					End IF
				
				End IF
									
				SE2->( dbGoto( nReg ) )
					
					//MsgAlert(cValToChar(nReg))
					//MsgAlert(SE2->E2_NUM+' - '+SE2->E2_FORNECE)
					
				aCpoSE2 := {}
					
				AADD(aCpoSE2,{"E2_FILIAL"  ,SE2->E2_FILIAL,										Nil})
				AADD(aCpoSE2,{"E2_PREFIXO" ,Pad(SE2->E2_PREFIXO,	Len(SE2->E2_PREFIXO)),		Nil})
				AADD(aCpoSE2,{"E2_NUM"     ,Pad(SE2->E2_NUM	,		Len(SE2->E2_NUM)),			Nil})
				AADD(aCpoSE2,{"E2_PARCELA" ,Pad(SE2->E2_PARCELA,	Len(SE2->E2_PARCELA)),		Nil})
				AADD(aCpoSE2,{"E2_TIPO"    ,Pad(SE2->E2_TIPO,		Len(SE2->E2_TIPO)),			Nil})
				AADD(aCpoSE2,{"E2_FORNECE" ,Pad(cForn,				Len(SE2->E2_FORNECE)),		Nil})
				AADD(aCpoSE2,{"E2_LOJA"    ,Pad(cLojaF,				Len(SE2->E2_LOJA)),			Nil})
					
				lMsErroAuto := .F.
				lMSHelpAuto := .T.
				INCLUI      := .F.
		
				MSExecAuto( { | x, y, z | Fina050( x, y, z ) }, aCpoSE2,,5)
		
				If lMsErroAuto
					U_QUTSMAIL("PAGDEV-EXCLUSAO","NOTA: "+SF1->F1_DUPL+" CLIENTE: "+SA1->A1_FORNECE+"-"+SA1->A1_LOJAFOR+"NÃO FOI EXCLUIDA JUNTAMENTE COM EXCLUSAO DO DOC DE ENTRADA!" ,,"fernando.bonacordi@quataalimentos.com.br")
					Mostraerro()
				Else
					//msgalert("exec")
				Endif
									
			End If
		
		End IF
	
	End If

Return

User Function xDescF1()

	Local	nPerDesc	:= 0
	Local	nPerPag 	:= 0
	Local 	aRet		:= {}
	
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
		
		EndIf
		SD1->( dbSkip() )
	
	EndDo
	AADD(aRet,{nPerDesc,nPerPag})
Return aRet
/*
////////////////////////////*/
Static Function FeitFora()
/*///////////////////////////*/


// WMS.sn em 22/02/2017 - Chamado 000794
	Local _lCmpAut := SuperGetMv("MV_CMPDEVV",.F.,.F.)
	Local _nCtrAco := 0
	Local _nCtrSek := 0
	Local _nSerOri := 0
	Local _nNFsOri := 0
	Local _nVD1Tot := 0
	Local _nValAB  := 0
	Local _nValTit := 0
	Local _aRecNCC := {}
	Local _aRecNFS := {}
	Local _aNFsOri := {}
	Local _cQrySE1 := ""
	Local _lCtabil := .T.
	Local _lAglutn := .F.
	Local _lDigita := .F.
	Local _aTitulo := {}
	Local _aParcela:= {}
	Local _nLinha  := 0
	Local _nParcela:= 0
	Local _aAreAtu := GetArea()
	Local _aAreSE2 := SE2->(GetArea())
	Local _aAreSE1 := SE1->(GetArea())
	Local _cAliasW

	IncProc("Compensando Titulos...")

	If !_lCmpAut 			// Apenas se NAO for compensacao automatica, ou seja, o padrao NAO COMPENSOU nada
		_aNFsOri := {}
		_nSerOri := aScan(aHeader, {|x| AllTrim(Upper(X[2])) == "D1_SERIORI" })
		_nNFsOri := aScan(aHeader, {|x| AllTrim(Upper(X[2])) == "D1_NFORI" })
		_nVD1Tot := aScan(aHeader, {|x| AllTrim(Upper(X[2])) == "D1_TOTAL" })
		_nCtrAco := 0
	// Sintetiza por Serie + Nota Fiscal
		For _nCtrAco := 1 to Len(aCols)
			If !aCols[_nCtrAco][Len(aHeader)+1]
				If !Empty(aCols[_nCtrAco][_nSerOri]) // Busca valor da Serie da Nota Origem
					If !Empty(aCols[_nCtrAco][_nNfsOri]) // Busca valor da Serie da Nota Origem
						_nCtrSek := aScan(_aNFsOri, {|x,y| x[1] == aCols[_nCtrAco][_nSerOri]+aCols[_nCtrAco][_nNfsOri] })
						If _nCtrSek <= 0 	// Se não encontrou o Serie+NF Origem no array _aNFsOri, inclui elemento
							AAdd( _aNFsOri, {aCols[_nCtrAco][_nSerOri]+aCols[_nCtrAco][_nNfsOri],  aCols[_nCtrAco][_nVD1Tot]  } )
						Else
							_aNFsOri[ _nCtrSek ][ 2 ] := ( _aNFsOri[ _nCtrSek ][ 2 ] + aCols[_nCtrAco][_nVD1Tot] )
						EndIf
					EndIf
				EndIf
			EndIf
		Next _nCtrAco
		If !Empty(_aNFsOri) // Se encontrou Serie + Nota Fiscal de Origem
			DbSelectArea("SE1")
			AAdd( _aRecNCC, SE1->(RecNo()) ) 	// Por conveniencia inclui a NCC neste ponto
			DbSetOrder(1)
			For _nCtrAco := 1 To Len(_aNFsOri)
				_cAliasW := GetNextAlias()
				_cQrySE1 := "SELECT SE1.R_E_C_N_O_ SE1RECNO, "
				_cQrySE1 += "		SE1.E1_PARCELA PARCELA,"
				_cQrySE1 += "		SE1.E1_SALDO SALDO,"
				_cQrySE1 += "		SE1.E1_TIPO TIPO"
				_cQrySE1 += " FROM "+RetSqlName("SE1")+" SE1 "
				_cQrySE1 += " WHERE SE1.E1_FILIAL  = '"+xFilial("SE1")+"'"
				_cQrySE1 += " AND SE1.E1_CLIENTE = '"+SF1->F1_FORNECE+"'"
				_cQrySE1 += " AND SE1.E1_LOJA    = '"+SF1->F1_LOJA+"'"
				//_cQrySE1 += " AND SE1.E1_SERIE   = '" + SubStr(_aNFsOri[_nCtrAco][1], 1,3) + "'"
				_cQrySE1 += " AND SE1.E1_NUM     = '" + SubStr(_aNFsOri[_nCtrAco][1], 4,9) + "'"
				_cQrySE1 += " AND SE1.E1_TIPO    IN ('NF ','AB-')" 	// " + MV_CRNEG + "
				_cQrySE1 += " AND SE1.D_E_L_E_T_ = ' ' "
				_cQrySE1 += " ORDER BY SE1.E1_PARCELA, SE1.E1_TIPO DESC"
				_cQrySE1 := ChangeQuery(_cQrySE1)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrySE1),_cAliasW,.T.,.T.)
				
				_aParcela := {}
				While !(_cAliasW)->(EOF())
					//Renato Ruy - 28/08/2019
					//Abater valor do AB- para nao gerar erro de contabilizacao
					_nLinha := aScan(_aParcela, {|x| x[1] == (_cAliasW)->PARCELA })
					If _nLinha == 0
						Aadd(_aParcela, {(_cAliasW)->PARCELA,0,0,0} )
						_nLinha := Len(_aParcela)
					Endif
						
					_aParcela[_nLinha,2] := Iif(RTrim((_cAliasW)->TIPO) == "NF",(_cAliasW)->SE1RECNO	,_aParcela[_nLinha,2])
					_aParcela[_nLinha,3] := Iif(RTrim((_cAliasW)->TIPO) == "NF",(_cAliasW)->SALDO		,_aParcela[_nLinha,3])
					_aParcela[_nLinha,4] := Iif(RTrim((_cAliasW)->TIPO) != "NF",(_cAliasW)->SALDO		,_aParcela[_nLinha,4])
					
					(_cAliasW)->(dbSkip())
				EndDo
				//Renato Ruy - 30/08/2019
				//Faz Compensação para cada parcela, devido a abatimentos
				For _nParcela := 1 To Len(_aParcela)
					
					MaIntBxCR(3, {_aParcela[_nParcela,2]}, , _aRecNCC, ,{_lCtabil, _lAglutn, .F.,.F.,.F.,.T.}, , , , , _aParcela[_nParcela,3]-_aParcela[_nParcela,4],,,,,,.T.)
					_aRecNFS := {}
					
					//Soma AB- para baixar por estorno na NF de Devolucao
					_nValAB  += _aParcela[_nParcela,4]
					
				Next
				
				//Renato Ruy - 29/08/2019
				//Efetua baixa por estorno do AB- na NCC de devolução.
				If _nValAB > 0
					SE1->(DbGoTo(_aRecNCC[1]))
					_aTitulo := {}
					_aTitulo := { 	{"E1_PREFIXO"	, SE1->E1_PREFIXO	,Nil},;
									{"E1_NUM"		, SE1->E1_NUM		,Nil},;
									{"E1_PARCELA"	, SE1->E1_PARCELA	,Nil},;
									{"E1_TIPO"		, SE1->E1_TIPO		,Nil},;
									{"E1_CLIENTE"	, SE1->E1_CLIENTE	,Nil},;
									{"E1_LOJA"		, SE1->E1_LOJA		,Nil},;
									{"AUTDESCONT"	, 0					,Nil},;
									{"AUTMULTA"		, 0					,Nil},;       
						   			{"AUTJUROS"		, 0					,Nil},;
									{"AUTMOTBX"		, "EAB"				,Nil},; 
									{"AUTBANCO"		, ""				,Nil},;
						   			{"AUTAGENCIA"	, ""				,Nil},;
							   		{"AUTCONTA"		, ""				,Nil},;
								   	{"AUTDTBAIXA"	, dDataBase			,Nil},;
				   					{"AUTDTCREDITO"	, dDataBase			,Nil},;
				   					{"AUTHIST"		, "Estorno de Abatimento Concedido"	,Nil},;
									{"AUTVALREC"	, _nValAB			,Nil}}
			
					MSExecAuto({|x, y| FINA070(x, y)}, _aTitulo, 3) 
					_nValAB  := 0
				Endif
				
			Next _aNFsOri
			
		EndIf
	EndIf
	RestArea(_aAreSE2)
	RestArea(_aAreSE1)
	RestArea(_aAreAtu)
Return Nil
// WMS.en em 22/02/2017 - Chamado 000794
