#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAR011   ºAutor  ³RAFAEL MARIN        º Data ³  19/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio Resumo de Entradas de Leite por Municipio         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QUAR011()
Local cDesc1        := "Esta rotina imprime relatório Resumo das entradas de "
Local cDesc2        := "leite por municipio, de acordo com os parametros "
Local cDesc3        := "informados pelo usuario."
Local cPict         := ""
Local nLin          := 80                    
Local Titulo        := "Resumo das Entradas de Leite por Municipio"                                   

        		    //		   10        20		   30	     40        50        60        70        80        90       100       110       120       130
					// 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 12
					//"Data        Num. NF   CFOP   Código  Produtor                     Rota       Qtd.Leite      Tot. Bruto    Incentivo    Tot. Liquido"
Local cCabec1		:=" Data        Num. NF   CFOP   Código  Produtor                  Rota          Qtd.Leite      Tot. Bruto    Incentivo    Tot. Liquido"
Local cCabec2       :=""
Private nomeprog    := "QUAR011"
Private nTipo       := 15
Private lDic        := .F. // Habilita/Desabilita Dicionario
Private lComp       := .T. // Habilita/Desabilita o Formato Comprimido/Expandido
Private lFiltro     := .F. // Habilita/Desabilita o Filtro
Private lAbortPrint := .F.
Private tamanho     := "M"
Private Limite      := 132 // 80/132/220
Private aOrdem      := {}  // Ordem do Relatorio
Private aReturn     := {"Zebrado", 1,"Administracao", 2, 1, 1, "",1 } //"Zebrado"###"Administracao"
						//[1] Reservado para Formulario
						//[2] Reservado para N§ de Vias
						//[3] Destinatario
						//[4] Formato => 1-Comprimido  2-Normal
						//[5] Midia   => 1-Disco  2-Impressora
						//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
						//[7] Expressao do Filtro
						//[8] Ordem a ser selecionada
						//[9]..[10]..[n] Campos a Processar (se houver)

Private nLastKey    := 0
Private cPerg       := "QUAR11"
Private wnrel       := "QUAR011" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01

Private cTrans     := ""

SET CENTURY ON

X1QUAR011(cPerg)
Pergunte(cPerg, .F.)

wnrel:=SetPrint("",wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)

If nLastKey == 27
	Return
Endif
              
//nTipo := If(aReturn[4]==1,15,18)
SetDefault(aReturn,"")

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| QUAR011Imp(Titulo, cCabec1, cCabec2, nLin) },Titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³X1QUAR011 ºAutor  ³RAFAEL MARIN        º Data ³  27/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³CRIACAO DE PERGUNTAS DA ROTINA NO SX1                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function X1QUAR011(cPerg)
	Local aArea := GetArea()
	
	DbSelectArea("SX1")                                  
	SX1->(DbSetOrder(1)) // x1_grupo 
	If !SX1->(DbSeek(cPerg))                                                       
		PutSx1(cPerg, "01", "Municipio De  ?", "", "", "MV_CH1", "C",06,0,0,"G","","CC2","","","mv_par01","","","","      ","","","","","","","","","","","","","","","","","","","","","","CC2","","","")
		PutSx1(cPerg, "02", "Municipio Até ?", "", "", "MV_CH2", "C",06,0,0,"G","","CC2","","","mv_par02","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","CC2","","","")
		PutSx1(cPerg, "03", "Linha     De  ?", "", "", "MV_CH3", "C",06,0,0,"G","","LDC","","","mv_par03","","","","      ","","","","","","","","","","","","","","","","","","","","","","LDC","","","")
		PutSx1(cPerg, "04", "Linha     Até ?", "", "", "MV_CH4", "C",06,0,0,"G","","LDC","","","mv_par04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","LDC","","","")
		PutSx1(cPerg, "05", "Emissao   De  ?", "", "", "MV_CH5", "D",10,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
		PutSx1(cPerg, "06", "Emissao   Até ?", "", "", "MV_CH6", "D",10,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")		
	EndIf                   '
	
	RestArea(aArea)
Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAR011ImpºAutor  ³RAFAEL MARIN        º Data ³  03/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processamento do Relatorio                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function QUAR011Imp(Titulo, cCabec1, cCabec2, nLin)

	Local cQuery 	:= ""
	Local cFiltro 	:= ""
	Local nReg		:= 0  
	Local nPosCid, nPos := 0
	Local nIncent	:= 0  //Percentual para calculo do Incentivo
	Local nVlIncent := 0
	Local aCFOP		:= {}
	Local aMUNI		:= {}
	Local cMun		:= '' 
	
	Local nQtdTot	:= 0
	Local nValTot	:= 0
	Local nIncentTot:= 0
	Local nQtdTotS		:= 0
	Local nValTotS		:= 0
	Local nIncentToS 	:= 0



	cQuery := " SELECT SD1.D1_EMISSAO, SD1.D1_DOC, SD1.D1_CF, LBB.LBB_CODPRO, LBB.LBB_DESC, LBB.LBB_LINHA, CC2.CC2_CODMUN, CC2.CC2_MUN, SUM(SD1.D1_QUANT) QTDETOT, SUM(SD1.D1_TOTAL) VLTOTAL, A2_NOME, MAX(F1_XINCEN) AS F1_XINCEN " +chr(13)+chr(10)
	cQuery += " FROM "+RETSQLNAME("SD1")+" SD1 "+chr(13)+chr(10)
	cQuery += " JOIN "+RETSQLNAME("LBB")+" LBB ON (LBB.LBB_FILIAL = '" + xFilial("LBB") + "') AND (LBB.LBB_CODFOR = SD1.D1_FORNECE) AND (LBB.LBB_LOJA = SD1.D1_LOJA) AND   LBB.D_E_L_E_T_ = ' ' "+chr(13)+chr(10)
	cQuery += " JOIN "+RETSQLNAME("SA2")+" SA2 ON (SA2.A2_FILIAL = '" + xFilial("SA2") + "') AND (SA2.A2_COD = SD1.D1_FORNECE) AND (SA2.A2_LOJA = SD1.D1_LOJA) AND SA2.D_E_L_E_T_ = ' ' "+chr(13)+chr(10)
	cQuery += " Left Outer JOIN "+RETSQLNAME("CC2")+" CC2 ON (CC2.CC2_CODMUN = LBB.LBB_CODMUN) AND CC2.CC2_EST=LBB.LBB_EST AND CC2.D_E_L_E_T_ = ' ' "+chr(13)+chr(10)
	cQuery += " JOIN "+RETSQLNAME("SF1")+" SF1 ON (SF1.F1_FILIAL = '" + xFilial("SF1") + "') AND (SF1.F1_DOC = SD1.D1_DOC) AND (SF1.F1_SERIE = SD1.D1_SERIE) "+chr(13)+chr(10)
	cQuery += " AND (SF1.F1_FORNECE = SD1.D1_FORNECE) AND (SF1.F1_LOJA = SD1.D1_LOJA) AND   SF1.D_E_L_E_T_ = ' ' "+chr(13)+chr(10)
	
	cQuery += "     WHERE SD1.D1_EMISSAO >= '"+DTOS(MV_PAR05)+"'"+chr(13)+chr(10)	//Emissao
	cQuery += "     AND   SD1.D1_EMISSAO <= '"+DTOS(MV_PAR06)+"'"+chr(13)+chr(10)
	cQuery += "     AND   LBB.LBB_CODMUN >= '"+MV_PAR01+"'"+chr(13)+chr(10)		//Municipio
	cQuery += "     AND   LBB.LBB_CODMUN <= '"+MV_PAR02+"'"+chr(13)+chr(10)               
	cQuery += "     AND   LBB.LBB_LINHA  >= '"+MV_PAR03+"'"+chr(13)+chr(10)			//Rota
	cQuery += "     AND   LBB.LBB_LINHA  <= '"+MV_PAR04+"'"+chr(13)+chr(10)	
	cQuery += "     AND   SD1.D1_TIPO    = 'N' "+chr(13)+chr(10)					
	cQuery += "     AND   SD1.D1_FILIAL    = '"+xFilial("SD1")+"'"+chr(13)+chr(10)						

	cQuery += "		AND   SD1.D_E_L_E_T_ = ' '"	+chr(13)+chr(10)

	cQuery += " GROUP BY D1_EMISSAO, D1_DOC, D1_CF, LBB_CODPRO, LBB_DESC, LBB_LINHA, CC2_CODMUN, CC2_MUN, A2_NOME" +chr(13)+chr(10)
	cQuery += " ORDER BY CC2_MUN, CAST(LBB_LINHA AS INT),CAST(LBB_CODPRO AS INT)" +chr(13)+chr(10)     ///wm Ordem e quebra  municipio e nota
	
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRB", .T., .T.)
	
	MemoWrite("C:\EDI\MUNICIPIO.SQL",cQuery)
		
	TRB->( DbGoTop() )
	
	While TRB->( !EOF() )
 		nReg ++		
		TRB->( DbSkip () ) 				
	End
	   
	SetRegua(nReg)
	
	TRB->( DbGoTop() )
	
	cMun := AllTrim(TRB->CC2_MUN)
	
	While TRB->( !EOF() )
	                                                             				
	    IncRegua("Imprimindo nota: " + TRB->D1_DOC )
	    
		If lAbortPrint
			@nLin,01 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...			
	        Cabec(Titulo,cCabec1,cCabec2,NomeProg,Tamanho,nTipo)
	        nLin := 08
		EndIf
  
		//		   10        20		   30	     40        50        60        70        80        90       100       110       120       130
		// 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 12
		//"Data        Num. NF   CFOP   Código  Produtor                  Rota          Qtd.Leite      Tot. Bruto    Incentivo    Tot. Liquido"
//		nVlIncent := TRB->VLTOTAL * nIncent / 100				
	
		nVlIncent := TRB->F1_XINCEN
		
				
		@nLin,001  PSAY	DTOC(STOD(TRB->D1_EMISSAO))
		@nLin,013  PSAY	TRB->D1_DOC
		@nLin,023  PSAY	TRB->D1_CF
		@nLin,030  PSAY	TRB->LBB_CODPRO
		@nLin,038  PSAY	ALLTRIM(SUBSTR(TRB->A2_NOME, 1, 25))
                        
		IF ALLTRIM(TRB->LBB_LINHA) <> '' 
			@nLin,065  PSAY	ALLTRIM(TRB->LBB_LINHA)
		ENDIF

		@nLin,075  PSAY	TRB->QTDETOT 				Picture "@E 9,999,999.99"	// Valor Qtd.Leite
		@nLin,091  PSAY	TRB->VLTOTAL				Picture "@E 9,999,999.99"	// Valor Bruto
		@nLin,104  PSAY	nVlIncent					Picture "@E 9,999,999.99"	// Incentivo
		@nLin,120  PSAY	(TRB->VLTOTAL + nVlIncent) 	Picture "@E 9,999,999.99"	// Valor Liquido
		                      	
		//Totalizador de Colunas
		
		nQtdTot	  += TRB->QTDETOT
		nValTot	  += TRB->VLTOTAL
		nIncentTot+= nVlIncent
	    
	    nQtdTotS	+= TRB->QTDETOT
		nValTotS	+= TRB->VLTOTAL
		nIncentToS 	+= nVlIncent
	    
	    	
        	//Totalizando CFOP      
	        //Pos 1: numero CFOP
	        //Pos 2: Descricao CFOP
	
		nPos := aScan(aCFOP,{|x| (x[01]==TRB->D1_CF)})
		If (nPos > 0)      
			aCFOP[nPos, 2 ] += 	TRB->VLTOTAL
		Else
		    aAdd( aCFOP, {TRB->D1_CF, TRB->VLTOTAL} )
		EndIf
		
	        //Totalizando Municipios
	        //Pos 1: Codigo Municipio
	        //Pos 2: Nome Municipio
			//Pos 3: Array com Codigo dos Produtores do Municipio
	        //Pos 4: Quantidade de Notas
	        //Pos 5: Quantidade de Leite
	        //Pos 6: Valor Total
	
		nPos := aScan(aMUNI,{|x| (x[01]==TRB->CC2_CODMUN)})
		
		If (nPos > 0)      
	    	
			nPosCid := aScan(aMUNI[nPos, 03], {|x| (x == TRB->LBB_CODPRO)})
			If (nPosCid <=0)
			    aAdd( aMUNI[LEN(aMUNI), 03], TRB->LBB_CODPRO )	    	    						
			EndIf			
			
		    aMUNI[nPos, 04] ++ 
		    aMUNI[nPos, 05] += TRB->QTDETOT
   		    aMUNI[nPos, 06] += TRB->VLTOTAL			
		Else
		    aAdd( aMUNI, {TRB->CC2_CODMUN, AllTrim(TRB->CC2_MUN), {TRB->LBB_CODPRO}, 1, TRB->QTDETOT, TRB->VLTOTAL} )
		EndIf		
		
		nLin ++ // Avanca a linha de impressao			    	    
		
		TRB->( DbSkip () )
        
        if cMun <> AllTrim(TRB->CC2_MUN)
        	nLin++
        	@nLin,001 Psay __PrtThinLine()
        	nLin++
        	@nLin,001  PSAY	"TOTAL MUNICIPIO-> "+cMun
			@nLin,074  PSAY	nQtdTotS			Picture "@E 99,999,999.99"	// Valor Qtd.Leite
			@nLin,090  PSAY	nValTotS			Picture "@E 99,999,999.99"	// Valor Bruto
			@nLin,103  PSAY	nIncentToS			Picture "@E 99,999,999.99"	// Incentivo
			@nLin,119  PSAY	nValTotS+nIncentToS Picture "@E 99,999,999.99"	// Valor Liquido
        	nLin ++
        	@nLin,001 Psay __PrtThinLine()
        	nLin ++
        	nLin ++
        	cMun := AllTrim(TRB->CC2_MUN)
         	
         	nQtdTotS	:= 0
			nValTotS	:= 0
			nIncentToS 	:= 0	
        
        End If
    
    End
    
    //Imprimindo cabecalho do ultimo estado e Total Geral
    If nLin > 61 // Salto de Página. Neste caso o formulario tem 55 linhas, mas verifica se possui espaco para rodape
      Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)			
      nLin := 10
    EndIF
    
    impRodape(@nLin, nQtdTot, nValTot, nIncentTot, aCFOP, aMUNI, titulo) 
    
    TRB->(DbCloseArea())
       	
	SET DEVICE TO SCREEN
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OURSPOOL(wnrel)
	Endif

	MS_FLUSH()
Return()   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  Rodape  ºAutor  ³RAFAEL MARIN        º Data ³  23/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime totalizacoes por Estado                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function impRodape(nLin, nQtdTot, nValTot, nIncentTot, aCFOP, aMUNI, titulo)         
	Local nI := 0
	Local nTotProd, nTotNota
	  
	@nLin,001 Psay __PrtThinLine()                     
	nLin ++
	@nLin,001  PSAY	"TOTAIS"
	@nLin,074  PSAY	nQtdTot				Picture "@E 99,999,999.99"	// Valor Qtd.Leite
	@nLin,090  PSAY	nValTot				Picture "@E 99,999,999.99"	// Valor Bruto
	@nLin,103  PSAY	nIncentTot			Picture "@E 99,999,999.99"	// Incentivo
	@nLin,119  PSAY	nValTot+nIncentTot 	Picture "@E 99,999,999.99"	// Valor Liquido
    nLin ++
	@nLin,001 Psay __PrtThinLine()
	nLin ++	
    nLin ++
    @nLin,001  PSAY	"CFOP           VALOR"
	nLin ++
	@nLin,001  PSAY	"-----   ------------"	      
	aTtGer := 0
	For nI := 1 To LEN(aCFOP)
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas, mas verifica se possui espaco para rodape
			Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)			
			nLin := 10	      

		    @nLin,001  PSAY	"CFOP           VALOR"
			nLin ++
			@nLin,001  PSAY	"-----   ------------"	      			
		EndIF	                                          
		nLin ++    
	    @nLin,001  PSAY	aCFOP[nI, 01]
	    @nLin,008  PSAY	aCFOP[nI, 02]	Picture "@E 99,999,999.99" 
	    	    	   	    
	    aTtGer += aCFOP[nI, 02]
	Next nI
	nLin++
	@nLin,001  PSAY	"        ------------"	      			
	nLin++
    @nLin,008  PSAY	aTtGer	Picture "@E 99,999,999.99"	    	   	    
	nLin++ 

	If nLin > 51 // Salto de Página. Neste caso o formulario tem 55 linhas, mas verifica se possui espaco para rodape
		Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)			
		nLin := 10	      
	EndIf
	
	nLin ++	                 
	@nLin,001  PSAY			"MUNICIPIO                         PRODUTORES      QTD.NOTAS      QTD.LEITE      VL.TOTAL"
	nLin ++
	@nLin,001  PSAY			"------------------------------    ----------      ---------      ---------      --------"	

	nTotProd := 0
	nTotNota := 0    
	nVlnotaTT:= 0
	nqtltsTT := 0

	For nI := 1 To LEN(aMUNI)
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas, mas verifica se possui espaco para rodape
			Cabec(Titulo, "", "", NomeProg, Tamanho, nTipo)			
			nLin := 10
				      
			@nLin,001  PSAY	"MUNICIPIO                         PRODUTORES      QTD.NOTAS      QTD.LEITE        VL.TOTAL"
			nLin ++
			@nLin,001  PSAY	"------------------------------    ----------      ---------      ---------        --------"
		EndIF	                                          
		nLin ++                                                 
		
	    @nLin,001  PSAY	aMUNI[nI, 02]								        //Pos 2: Nome Municipio
	    @nLin,035  PSAY	LEN(aMUNI[nI, 03]) Picture "@E 99,999,999" 		//Pos 3: Array com Codigo dos Produtores do Municipio
	    @nLin,050  PSAY	aMUNI[nI, 04]	Picture "@E 99,999,999"	    		//Pos 4: Quantidade de Notas
	    @nLin,062  PSAY	aMUNI[nI, 05]	Picture "@E 99,999,999.99"			//Pos 5: Quantidade de Leite
	    @nLin,076  PSAY	aMUNI[nI, 06]	Picture "@E 99,999,999.99"	    	//Pos 6: Valor Total		
	    
		nTotProd 	+= LEN(aMUNI[nI, 03])
		nTotNota 	+= aMUNI[nI, 04]
		nVlnotaTT 	+= aMUNI[nI, 06]
		nqtltsTT	+= aMUNI[nI, 05]	 		   
	Next nI                                                                            
 	nLin ++                                                 	 
	@nLin,035  PSAY	"----------      ---------" 	
    nLin ++
    @nLin,035  PSAY	nTotProd 	Picture "@E 99,999,999" 		//Pos 3: Array com Codigo dos Produtores do Municipio
    @nLin,050  PSAY	nTotNota 	Picture "@E 99,999,999"	    //Pos 4: Quantidade de Notas	 
    @nLin,062  PSAY	nqtltsTT	Picture "@E 99,999,999.99"			//Pos 5: Quantidade de Leite
    @nLin,076  PSAY	nVlnotaTT	Picture "@E 99,999,999.99"	    	//Pos 6: Valor Total		
Return Nil