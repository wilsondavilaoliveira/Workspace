#INCLUDE "RWMAKE.CH"

//Gatilho para calcular o preco de venda na segunda unidade.
// Produto contra-dominio Produto
// QtdVen  contra-dominio QtdVen
// UnsVen  contra-dominio UnsVen
// PrcVen  contra-dominio PrcVen

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATG01  ³ Autor ³                       ³ Data ³ 02.11.07   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Conversao de Unidade de Medidas (1a.->2a. / 2a.->1a.)        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void RESBG03(void)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Rogerio Leite ³17/03/08³170308³Qdo alterar tb deve converte.Solicitacao  ³±±
±±³              ³        ³      ³Thiago.                                   ³±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFATG01()

Local nPrUnit1:=0,nDesc:=0,nDesc2:=0,nPrUnit2:=0,nPrcVnd:=0.00,nPrcVnd2:=0.00
Local aArea:=GetArea(),cRetG01 := &(ReadVar())
Local aAreaSC6 := SC6->(GetArea())
Local cProd       := aCols[n,Ascan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})]
Local nPosPrcVn1  := Ascan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local nPosPrcVn2  := Ascan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN2"})
Local nPosxPrTab  := Ascan(aHeader,{|x| AllTrim(x[2])=="C6_XPRTAB"})
Local nPosPrUnt1  := Ascan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
Local nPosPrUnt2  := Ascan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT2"})
Local nPosDescto  := Ascan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})
Local nPosValDsc  := Ascan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
Local nPosValor   := Ascan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPosQtdVen  := Ascan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPosUnsVen  := Ascan(aHeader,{|x| AllTrim(x[2])=="C6_UNSVEN"})
Local nPosQtdLib  := Ascan(aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB"})
Local nPosLocal   := Ascan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})
Local nItem		  := GDFieldGet ("C6_ITEM", n)
//Local nVlrCheio   := 0.00
Local nQtdVen1    := 0
Local nQtdVen2    := 0
Local cUserAlt    := SuperGetMV("ES_ALTPESO",,"") //-- usuário que pode alterar o peso sem alterar a quantidade do item

IF Empty(AllTrim(cProd))  // PARA O CASO DO EFABA00 TER LIMPADO O CAMPO PRODUTO
	Return
Endif

//If !l410Auto
dbselectarea("SA1")
dbSetOrder(1)
dbSeek(xfilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI)

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+cProd)


dbSelectArea("SC6")
dbSetOrder(1)
If  (ValType(GDFieldGet("C6_XPRVEN")) != 'N') .And. dbSeek(xFilial("SC6")+M->C5_NUM+nItem+cProd)
	GDFieldPut("C6_XPRVEN", 0)
	//GDFieldPut("C6_U_EAN" , C6_U_EAN)
EndIf
RestArea(aAreaSC6)


nPrcVnd  := aCols[n,nPosPrcVn1]
nPrcVnd2 := aCols[n,nPosPrcVn2]

//If (AllTrim(FunName()) <> "RFATM02B" .AND. AllTrim(FunName()) <> "RFATM02" .AND. AllTrim(FunName()) <> "JOBFTM2" .AND. AllTrim(FunName()) <> "AFVMOD3" .and. AllTrim(FunName()) <>"CONVAFV") .or. SB1->B1_PESOVAR == "N"
If (AllTrim(FunName()) <> "JOBFTM2" .AND. AllTrim(FunName()) <> "AFVMOD3" .and. AllTrim(FunName()) <>"CONVAFV") .or. SB1->B1_PESOVAR == "N"
    //If (AllTrim(FunName()) <> "AFVMOD3" .and. AllTrim(FunName()) <>"CONVAFV") .or. SB1->B1_PESOVAR == "N"

    If SB1->B1_PESOVAR == "S"
    	nPrcVnd := 0
    Else //Ajustado por Cadu em 06/03
    	If Alltrim(ReadVar()) == "M->C6_UNSVEN" .OR. Alltrim(ReadVar()) == "M->C6_QTDVEN"
    		If Empty(GDFieldGet ("C6_PRCVEN", n))
    			nPrcVnd  := nPrcVnd2*SB1->B1_XCONV
    		Else
    		   //	If Upper(GetEnvServer()) == "HOMOLOGACAO"
    				If  (GDFieldGet ("C6_XPRVEN", n) > 0)               // Manter o Preco digitado (13/08/08)
    					nPrcVnd  := GDFieldGet ("C6_XPRVEN", n)	     // Manter o Preco digitado (13/08/08)
    				Else                                             // Manter o Preco digitado (13/08/08)
    					nPrcVnd  := GDFieldGet ("C6_PRCVEN", n)
    				Endif                                            // Manter o Preco digitado (13/08/08)
    			//Else
    			//	nPrcVnd  := GDFieldGet ("C6_PRCVEN", n)
    		   //	Endif
    		EndIf

    	Else
    		nPrcVnd2 := 0
    	EndIf
    Endif

    //Renato Bernardo - 17/02/2021
	//Consulta para retornar valor da tabela escalonada
	//Caso exista não faz os demais tratamentos
	If Select("TMPESC") > 0
		DbSelectArea("TMPESC")
		TMPESC->(DbCloseArea())
	Endif
	BeginSql Alias "TMPESC"
		%NOPARSER%
		SELECT 	TOP 1
				DA1_CODPRO  AS CODIGOPRODUTO,
				DA1_QTDLOT  AS QTDEVENDA,
				B1_PESOVAR  AS PESOVAR,
				CASE 
					WHEN SB1.B1_PESOVAR='S' THEN CAST(DA1_XPRVE2 AS NUMERIC(10,2)) 
					ELSE CAST(DA1_PRCVEN AS NUMERIC(10,2)) 
				END AS PRECO,
				DA1_CODTAB AS CODIGOTABPRECO,
				0 AS PrecoNegociado
		FROM DA1010 DA1 WITH (NOLOCK)
		INNER JOIN SB1010 SB1 WITH (NOLOCK)
		ON  SB1.B1_FILIAL   = '  '
		AND SB1.B1_COD      = DA1.DA1_CODPRO
		AND SB1.B1_MSBLQL  <> 1
		AND SB1.B1_TIPO     = 'PA'
		AND SB1.B1_GRUPO   <>'600'
		AND SB1.B1_GRUPO   <> ' '
		AND SB1.B1_COD     <> '999999'
		AND SB1.B1_COD     <> '601004' //PRODUTO PARA TESTE ESTA COMO PA PARA EMISSAO DE NOTA
		AND SB1.B1_COD     NOT IN('002018','002019','007111')
		AND SB1.%NOTDEL%
		INNER JOIN DA0010 DA0 WITH (NOLOCK)
		ON  DA0.DA0_FILIAL  = '  '
		AND DA0.DA0_CODTAB  = DA1_CODTAB
		AND DA0.DA0_ATIVO   = '1'
		AND DA0.DA0_XESCAL   = '1'
		AND DA0.%NOTDEL%
		WHERE DA1.DA1_FILIAL = '  '
		AND DA1.DA1_CODTAB = %Exp:M->C5_TABELA%
		AND DA1.DA1_CODPRO = %Exp:cProd%
		AND DA1_QTDLOT >= %Exp:aCols[n,nPosQtdVen]%
		AND DA1.%NOTDEL%
		ORDER BY DA1_QTDLOT
	EndSql 

	dbselectarea("DA1")
	dbsetorder(1)
	If TMPESC->QTDEVENDA > 0 .And. Empty(nPrcVnd) .And. Empty(nPrcVnd2)
		If TMPESC->PESOVAR == "S"
			nPrcVnd2 := TMPESC->PRECO
			nPrUnit1 := 0
		Else
			nPrcVnd  := TMPESC->PRECO
			nPrUnit2 := 0
		EndIf
	ElseIf Empty(nPrcVnd) .And. Empty(nPrcVnd2)//Somente na Inclusao
    	dbselectarea("DA1")
    	dbsetorder(1)
    	If dbSeek(xFilial("DA1")+M->C5_TABELA+cProd)
    		If SB1->B1_PESOVAR == "S"
    			//nPrcVnd	  := DA1->DA1_PRCVEN
    			nPrcVnd2  := DA1->DA1_XPRVE2
    			nPrUnit1 := 0
    		Else
    			nPrcVnd  := DA1->DA1_PRCVEN
    			nPrUnit2 := 0
    		EndIf
    	Else
    		nPrcVnd 	:= aCols[n,nPosPrcVn1]
    		nPrcVnd2 := aCols[n,nPosPrcVn2]
    	Endif
    EndIf

    nPrUnit1  := nPrcVnd
    nPrUnit2  := nPrcVnd2

    If SB1->B1_XCONV > 0
    	IF SB1->B1_PESOVAR == "S"
    		If SB1->B1_TIPCONV == "D"
    			//aCols[n,nPosQtdVen]  := Round((aCols[n,nPosUnsVen] ) * SB1->B1_XCONV,0)
    			//Cadu em 09/01/08
    			If Inclui       /// 17/03/08 - Realizar a conversao tb na Alteracao
    				If ReadVar() $ "M->C6_QTDVEN"
    					aCols[n,nPosUnsVen]  := Round( (aCols[n,nPosQtdVen] ) / SB1->B1_XCONV,2 )
    				Else
    					aCols[n,nPosQtdVen]  := Round( (aCols[n,nPosUnsVen] ) * SB1->B1_XCONV,2 )
    				EndIf
    			EndIf           // 17/03/08
    			//aCols[n,nPosQtdLib]  := aCols[n,nPosQtdVen]
    			If Empty(nPrcVnd2)
    				nPrUnit2 := (nPrcVnd ) * SB1->B1_XCONV
    			EndIf

    			//////Cadu em 09/04/08
    			If Altera
    				If ReadVar() $ "M->C6_UNSVEN"
    					If !(aCols[n,nPosLocal]=="23" .AND. __cUserID $ cUserAlt)
    						aCols[n,nPosQtdVen]  := Round( (aCols[n,nPosUnsVen] ) * SB1->B1_XCONV,2 )
    					EndIf
    				EndIf
    			EndIf
    			///////

    			//Cadu em 04/01/08
    			If !Empty(aCols[n,nPosUnsVen]) //.and. (!ReadVar()$"M->C6_QTDVEN/M->C6_UNSVEN" .or. inclui)
    				//nPrUnit1 := Round((Round(nPrUnit2,2) * aCols[n,nPosUnsVen]) / aCols[n,nPosQtdVen],4)
    				// Almir Bandina - 01.03.08
    				nPrUnit1 := Round((Round(nPrUnit2,2) * aCols[n,nPosUnsVen]) / aCols[n,nPosQtdVen],TAMSX3("C6_PRUNIT")[2])
    			EndIf
    		Else
    			//aCols[n,nPosQtdVen]  := Round((aCols[n,nPosUnsVen] ) / SB1->B1_XCONV,0)
    			//Cadu em 09/01/08
    			If Inclui      /// 17/03/08 - Realizar a conversao tb na Alteracao
    				If ReadVar() $ "M->C6_QTDVEN"
    					aCols[n,nPosUnsVen]  := Round( (aCols[n,nPosQtdVen] ) * SB1->B1_XCONV,2 )
    				Else
    					//aCols[n,nPosQtdVen]  := Round( (aCols[n,nPosUnsVen] ) / SB1->B1_XCONV,2 ) //WILSON 22/03/18
    					aCols[n,nPosQtdVen]  := Round( (aCols[n,nPosUnsVen] ) / SB1->B1_XCONV,0 )
    				EndIf
    			EndIf          // 17/03/08
    			//aCols[n,nPosQtdLib]  := aCols[n,nPosQtdVen]
    			If Empty(nPrcVnd2)
    				nPrUnit2 := (nPrcVnd ) / SB1->B1_XCONV
    			EndIf

    			//////Cadu em 09/04/08
    			If Altera
    				If ReadVar() $ "M->C6_UNSVEN"
    					If !(aCols[n,nPosLocal]=="23" .AND. __cUserID $ cUserAlt)
    						//aCols[n,nPosQtdVen]  := Round( (aCols[n,nPosUnsVen] ) / SB1->B1_XCONV,2 ) //WILSON 22/03/18
    						aCols[n,nPosQtdVen]  := Round( (aCols[n,nPosUnsVen] ) / SB1->B1_XCONV,0 )
    					EndIf
    				EndIf
    			EndIf
    			///////

    			//Cadu em 04/01/08
    			If !Empty(aCols[n,nPosUnsVen]) //.and. (!ReadVar()$"M->C6_QTDVEN/M->C6_UNSVEN" .or. inclui)
    				//nPrUnit1 := Round((Round(nPrUnit2,2) * aCols[n,nPosUnsVen]) / aCols[n,nPosQtdVen],4)
    				// Almir Bandina - 01.03.08
    				nPrUnit1 := Round((Round(nPrUnit2,2) * aCols[n,nPosUnsVen]) / aCols[n,nPosQtdVen],TAMSX3("C6_PRUNIT")[2])
    			EndIf
    		Endif
    	Else
    		If SB1->B1_TIPCONV == "D"
    			//If Inclui    /// 17/03/08 - Realizar a conversao tb na Alteracao

    				If (AllTrim(FunName()) <> "RFATM02B" .AND. AllTrim(FunName()) <> "RFATM02" .AND. AllTrim(FunName()) <> "JOBFTM2" .AND. AllTrim(FunName()) <> "AFVMOD3" .AND. AllTrim(FunName()) <>"CONVAFV")
    				   //If  (aCols[n,nPosQtdVen] > 0)
    					IF ReadVar() $ "M->C6_QTDVEN"
    						aCols[n,nPosUnsVen]  := Round((aCols[n,nPosQtdVen] ) / SB1->B1_XCONV,2)
    					Else
    						aCols[n,nPosQtdVen]  := Round((aCols[n,nPosUnsVen] ) * SB1->B1_XCONV,2)
    					EndIf
    				Else
    					If  (aCols[n,nPosQtdVen] > 0)
    					//IF ReadVar() $ "M->C6_QTDVEN"
    						aCols[n,nPosUnsVen]  := Round((aCols[n,nPosQtdVen] ) / SB1->B1_XCONV,2)
    					Else
    						aCols[n,nPosQtdVen]  := Round((aCols[n,nPosUnsVen] ) * SB1->B1_XCONV,2)
    					EndIf
    				End If

    			//EndIf
    			//aCols[n,nPosQtdLib]  := aCols[n,nPosQtdVen]
    		Else
    			//If Inclui    /// 17/03/08 - Realizar a conversao tb na Alteracao

    				IF (AllTrim(FunName()) <> "RFATM02B" .AND. AllTrim(FunName()) <> "RFATM02" .AND. AllTrim(FunName()) <> "JOBFTM2" .AND. AllTrim(FunName()) <> "AFVMOD3" .AND. AllTrim(FunName()) <>"CONVAFV")
    					//If  (aCols[n,nPosQtdVen] > 0)
    					IF ReadVar() $ "M->C6_QTDVEN"
    						aCols[n,nPosUnsVen]  := IIF(SB1->B1_MARCA $ '6|7|8', int((aCols[n,nPosQtdVen] ) * SB1->B1_XCONV),Round((aCols[n,nPosQtdVen] ) * SB1->B1_XCONV,2))
    					Else
    						aCols[n,nPosQtdVen]  := IIF(SB1->B1_MARCA $ '6|7|8', Round((aCols[n,nPosUnsVen] ) / SB1->B1_XCONV,0),Round((aCols[n,nPosUnsVen] ) / SB1->B1_XCONV,2))
    					EndIf
    				Else
    					If  (aCols[n,nPosQtdVen] > 0)
    					//IF ReadVar() $ "M->C6_QTDVEN"
    						aCols[n,nPosUnsVen]  := IIF(SB1->B1_MARCA $ '6|7|8', int((aCols[n,nPosQtdVen] ) * SB1->B1_XCONV),Round((aCols[n,nPosQtdVen] ) * SB1->B1_XCONV,2))
    					Else
    						aCols[n,nPosQtdVen]  := IIF(SB1->B1_MARCA $ '6|7|8', Round((aCols[n,nPosUnsVen] ) / SB1->B1_XCONV,0),Round((aCols[n,nPosUnsVen] ) / SB1->B1_XCONV,2))
    					EndIf

    				End If

    			//EndIf        // 17/03/08
    			//aCols[n,nPosQtdLib]  := aCols[n,nPosQtdVen]
    			If Empty(nPrcVnd2)
    				nPrUnit2 := (nPrcVnd ) / SB1->B1_XCONV
    			EndIf
    		Endif
    		*
    		If Empty(nPrUnit2)  // 060308 - Qdo estiver vazio pega do acols
    			nPrUnit2 := aCols[n,nPosPrcVn2]
    		Endif
    		*
    		If Empty(nPrUnit1) // 060308 - Qdo estiver vazio pega do acols
    			nPrUnit1 := aCols[n,nPosPrcVn1]
    		Endif

    	Endif

    Endif

    // BUSCA DESCONTOS POR ITENS
    nDesc := MARGRDESC(cProd,M->C5_CLIENTE,M->C5_LOJACLI,M->C5_TABELA,,M->C5_CONDPAG,,1,,)

    // SE DESCONTO POR ITENS FOR ZERADO, BUSCA DESCONTO GENERICO DE REDE/GRUPO
    IF nDesc==0
    	nDesc := MARGRDESC(cProd,M->C5_CLIENTE,M->C5_LOJACLI,M->C5_TABELA,,M->C5_CONDPAG,,2,,)
    ENDIF

    //Incluido por Evaldo em 18/04/2008 as 16:21 para calculo de desconto grandes redes.
    //nDesc += u_QUAA060(1,M->C5_CLIENTE,M->C5_LOJACLI,M->C5_XSETOR,dDataBase)

    //aCols[n,nPosPrcVn1] := Round(nPrUnit1  * (1-((nDesc+nDesc2)/100)),4)    // PRCVEN
    // Almir - 01.03.08
    aCols[n,nPosPrcVn1] := Round(nPrUnit1  * (1-((nDesc+nDesc2)/100)),TAMSX3("C6_PRCVEN")[2])    // PRCVEN
    If Empty(aCols[n,nPosxPrTab])
    	aCols[n,nPosxPrTab] := Round(nPrUnit1  * (1-((nDesc+nDesc2)/100)),TAMSX3("C6_PRCVEN")[2])    // PRC TAB
    Endif

    //aCols[n,nPosPrcVn2] := Round(nPrUnit2  * (1-((nDesc+nDesc2)/100)),2)
    aCols[n,nPosPrcVn2] := Round(nPrUnit2  * (1-((nDesc+nDesc2)/100)),TAMSX3("C6_PRCVEN2")[2])

    //aCols[n,nPosPrUnt1]  := Round(aCols[n,nPosPrcVn1],2)
    // Almir Bandina - 01.03.08
    aCols[n,nPosPrUnt1]  := Round(aCols[n,nPosPrcVn1],TAMSX3("C6_PRUNIT")[2])
    //aCols[n,nPosPrUnt2]  := Round(aCols[n,nPosPrcVn2],2)
    aCols[n,nPosPrUnt2]  := Round(aCols[n,nPosPrcVn2],TAMSX3("C6_PRUNIT2")[2])
    //aCols[n,nPosPrUnt2]  := Round(nVlrCheio,2)

    aCols[n,nPosDescto]  := 0
    //aCols[n,nPosDescto]  := u_QUAA060(1,M->C5_CLIENTE,M->C5_LOJACLI,M->C5_XSETOR,dDataBase)
    aCols[n,nPosValDsc]  := 0
    aCols[n,nPosValor]   := Round(aCols[n,nPosQtdVen] * aCols[n,nPosPrcVn1],TAMSX3("C6_VALOR")[2])
    //aCols[n,nPosValor]   := IIF(M->C5_TIPO='B',Round(aCols[n,nPosQtdVen] * aCols[n,nPosPrcVn1],2),Round(aCols[n,nPosQtdVen] * aCols[n,nPosPrcVn1],TAMSX3("C6_VALOR")[2]))
    MA410RODAP()
    //Endif
    RestArea(aArea)

End If

Return(cRetG01)












