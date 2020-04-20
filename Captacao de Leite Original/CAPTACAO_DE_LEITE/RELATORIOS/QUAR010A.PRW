#include "Protheus.Ch"
#include "MSOle.Ch"                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ QUAR010  ºAutor  ³Elcio Mitsuo Horii  º Data ³  21/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Romaneio de Coleta de Leite (WORD)                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento - Quata                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function QUAR010A()

Local nOpcA := 0
Local cPerg := "QUAR10A"



Private cCadastro := "Romaneio de Coleta de Leite"

AjustaSX1(cPerg)   

//+-------------------------------------------------------------------------------
//| DisponCountbiliza para usuario digitar os parametros
//+-------------------------------------------------------------------------------
If Pergunte(cPerg,	.T.) 
	//+-------------------------------------------------------------------------------
	//| Chama funcao que processa os dados
	//+-------------------------------------------------------------------------------
	RptStatus({|lEnd| GeraDoc() }, "Aguarde...", "Processando registros...", .T. )
EndIf     

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraDoc   ºAutor  ³ Elcio Mitsuo Horii º Data ³  22/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina responsavel pela montagem da consulta e integração  º±±
±±ºDesc.     ³ com Word                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QUAR021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraDoc()

Local 	cQuery	:= ""
Local 	nReg	:= 0
Local	cCodLin	:= "" 
Private	aMatriz	:= {}

	cQuery := "SELECT PA7.PA7_CODLIN "
	cQuery += ", PA7.PA7_DESC " 
	cQuery += ", PA7.PA7_CODCAR "
	cQuery += ", LBE.LBE_MOTO "    
	cQuery += ", LBB.LBB_CODPRO "
	cQuery += ", SUBSTRING(LBB.LBB_NOMFOR,1,29) AS LBB_DESC "
	cQuery += ", LBB.LBB_ORDLIN "
	cQuery += " FROM " + RetSqlName("PA7") + " PA7 "
	cQuery += " JOIN " + RetSqlName("LBE") + " LBE ON LBE.LBE_CODCAM = PA7.PA7_CODCAR "
	cQuery += " AND LBE.LBE_FILIAL = '" + xFilial("LBE") + "' "
	cQuery += " AND LBE.D_E_L_E_T_ = ' ' "
	cQuery += " JOIN " + RetSqlName("LBB") + " LBB ON LBB.LBB_LINHA = PA7.PA7_CODLIN "
	cQuery += " AND LBB.LBB_FILIAL = '" + xFilial("LBB") + "' "
	cQuery += " AND LBB.D_E_L_E_T_ = ' ' "
	cQuery += " AND LBB.LBB_CODPRO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	cQuery += " JOIN " + RetSqlName("SF1") + " SF1 ON F1_FORNECE=LBB_CODFOR AND F1_LOJA=LBB_LOJA AND SF1.D_E_L_E_T_='' "
	cQuery += " WHERE PA7.PA7_CODLIN BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery += " AND PA7.D_E_L_E_T_ = ' ' "
	cQuery += " AND PA7.PA7_FILIAL = '" + xFilial("PA7") + "' "
    cQuery += " AND LBB_CODFOR+LBB_LOJA NOT IN("
	cQuery += " SELECT LBE_FORNEC+LBE_LOJA FROM " + RetSqlName("LBE") + " LBE WHERE LBE_FILIAL='" + cFilAnt + "' AND LBE.D_E_L_E_T_='')"
	cQuery += " AND (F1_EMISSAO BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "') AND F1_FORMUL='S' "
	cQuery += " ORDER BY CAST(PA7.PA7_CODLIN AS INT), CAST(LBB.LBB_CODPRO AS INT) "
	
  	DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery) ,"TRB",.T.,.T.)
	
	MemoWrite("C:\EDI\QUAR010A.SQL",cQuery)
	
	While TRB->(!Eof())
		nReg ++
		TRB->( DbSkip() )
	End While
	
	SetRegua(nReg) 
    
    nReg := 1 
	
	TRB->( dbGoTop() )        
	
	cCodLin := TRB->PA7_CODLIN
	AADD(aMatriz,{"CARRETEIRO"		,AllTrim(TRB->LBE_MOTO)		,AllTrim(TRB->PA7_CODLIN)	,AllTrim(TRB->PA7_DESC)})

	   WHILE TRB->(!Eof())
	
	   		IncRegua(nReg)
	   		nReg ++
	         
	   		If cCodLin <> TRB->PA7_CODLIN
	      			AADD(aMatriz,{"CARRETEIRO"		,AllTrim(TRB->LBE_MOTO)		,AllTrim(TRB->PA7_CODLIN)	,AllTrim(TRB->PA7_DESC)})
	        		cCodLin := TRB->PA7_CODLIN
	   		End If
    
      		AADD(aMatriz,{AllTrim(TRB->LBB_CODPRO)		,AllTrim(TRB->LBB_DESC)		,AllTrim(TRB->LBE_MOTO),AllTrim(TRB->PA7_CODLIN)+"-"+AllTrim(TRB->PA7_DESC)})
    
    		TRB->(DbSkip())

	   END WHILE
	   
TRB->(dbCloseArea())  

AADD(aMatriz,{""	,""	,"",""})

Impress()	

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Elcio Mitsuo Horii  º Data ³ 22/07/08    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria grupo de perguntas se nao encontrar na tabela SX1     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QUAR021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1(cPerg)

DbSelectArea("SX1")
SX1->(DbSetOrder(1)) // x1_grupo
If !SX1->(DbSeek(cPerg))     
	PutSx1(cPerg, "01", "Linha      De ?", "", "", "MV_CH1", "C",06,0,0,"G","","PA7","","","mv_par01","","","","      ","","","","","","","","","","","","","","","","","","","","","","LBC","","","")
	PutSx1(cPerg, "02", "Linha      Até?", "", "", "MV_CH2", "C",06,0,0,"G","","PA7","","","mv_par02","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","LBC","","","")
	PutSx1(cPerg, "03", "Carreteiro De ?", "", "", "MV_CH3", "C",06,0,0,"G","","LBE","","","mv_par03","","","","      ","","","","","","","","","","","","","","","","","","","","","","LBE","","","")
	PutSx1(cPerg, "04", "Carreteiro Até?", "", "", "MV_CH4", "C",06,0,0,"G","","LBE","","","mv_par04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","LBE","","","")		
	PutSx1(cPerg, "05", "Período de?"		, "", "", "mv_ch5", "D",8						,0,0,"G","!vazio()"	,""			,"","","mv_par05",""			,"","",""			,""			,""	,""	,""		,""	,""	,""	,"","","","","" )
	PutSx1(cPerg, "06", "Periodo ate?"		, "", "", "mv_ch6", "D",8						,0,0,"G","!vazio()"	,""			,"","","mv_par06",""			,"","",""			,""			,""	,""	,""		,""	,""	,""	,"","","","","" )

EndIf      

Return    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEGUROD   ºAutor  ³Microsiga           º Data ³  04/15/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPRESSAO                                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Impress()

Local oPrint
LOCAL oFont8C
LOCAL oFont11c
LOCAL oFont11
LOCAL oFont10
LOCAL oFont13
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0
LOCAL nRow	:= 0
LOCAL nCol	:= 65 
LOCAL nSeq	:= 1
LOCAL n		:= 1
LOCAL n1	:= 1
LOCAL n2	:= 510
LOCAL nPag	:= 1
LOCAL cCarr	:= ""
LOCAL cLinha	:=""
//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)

oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9   := TFont():New("Arial",9,9,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8C  := TFont():New("Courier New",9,8,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11  := TFont():New("Arial",9,11,.T.,.F.,5,.T.,5,.T.,.F.)
oFont12  := TFont():New("Arial",9,12,.F.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.F.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:= TMSPrinter	():New( "ROMANEIO DE COLETA DE LEITE" )
oPrint:SetPortrait	() // ou SetLandscape()

// oPrint:Say (linha	,coluna		,Texto impresso		,fonte	 )
//oPrint:SayBitmap(linha,coluna,"QUATA.BMP",altura,largura)
//oPrint:Box(Linha Inicial,Coluna Final,linha Final,coluna Incial)
nRow := 470

For n:= 1 to Len( aMatriz ) - 1
	
    If aMatriz[n][1] == "CARRETEIRO"
		nPag := 1
		nRow := 470
		n2 := 510
		oPrint:EndPage()
		oPrint:StartPage() // Inicia uma nova página
		
		cCarr := allTrim(aMatriz[n][2])
		cLinha := allTrim(aMatriz[n][3])+"-"+allTrim(aMatriz[n][4])
		
		oPrint:SayBitmap	(20	,115	,"QUATA.BMP"								,248,138	)
	    oPrint:Say  		(60	,650	,"* * * ROMANEIO DE COLETA DE LEITE * * *"	,oFont16n	) 			
		oPrint:Say  		(60	,2120	,"Página "+cValToChar(nPag)	,oFont10	) 			
		oPrint:Say  		(200,120 	,"CARRETEIRO: "+allTrim(aMatriz[n][2])+space(60),oFont11)
		oPrint:Say  		(200,1278 	,"LINHA: "+allTrim(aMatriz[n][3])+"-"+allTrim(aMatriz[n][4]),oFont11) 			
		oPrint:Say  		(300,115 	,"D A T A :____/____/________ ",oFont10) 			
	    oPrint:Say  		(300,1278 	,"D A T A :____/____/________ ",oFont10) 			
	    
	    oPrint:Say  (390	,73		,"      CÓDIGO   NOME                                                QTDE.        ÁCIDO",oFont9 ) 			
		oPrint:Say  (390	,1220		,"        CÓDIGO    NOME                                              QTDE.          ÁCIDO",oFont9 ) 			
		
		oPrint:Box(370,270,450,115) 		//box cod1 
		oPrint:Box(370,770,450,270)    //box nome1
		oPrint:Box(370,970,450,770)   //box qtde1
		oPrint:Box(370,1125,450,970)  //box acido1
		
		oPrint:Box(370,1435,450,1280)	//box cod2
		oPrint:Box(370,1935,450,1435)	//box nome2
		oPrint:Box(370,2135,450,1935)	//box qtde2
		oPrint:Box(370,2290,450,2135)	//box acido2
	    
	    oPrint:Box(440,270,450,115)		
		oPrint:Box(440,770,450,270)
		oPrint:Box(440,970,450,770)
		oPrint:Box(440,1125,450,970)
		
		oPrint:Box(440,1435,450,1280)
		oPrint:Box(440,1935,450,1435)
		oPrint:Box(440,2135,450,1935)
		oPrint:Box(440,2290,450,2135)
	    nPag ++
	Else
	
		// oPrint:Say (linha	,coluna		,Texto impresso		,fonte	 )
		
		//oPrint:Box(Linha Inicial,Coluna Final,linha Final,coluna Incial)
		
		oPrint:Box(n2,270,450,115)		
		oPrint:Box(n2,770,450,270)
		oPrint:Box(n2,970,450,770)
		oPrint:Box(n2,1125,450,970)
		
		oPrint:Box(n2,1435,450,1280)
		oPrint:Box(n2,1935,450,1435)
		oPrint:Box(n2,2135,450,1935)
		oPrint:Box(n2,2290,450,2135)
		
		n2 := n2 + 70
			
		//Produtores
		oPrint:Say  (nRow	,123   		,aMatriz[n][1]	,oFont9 )//CODIGO  1 COL
		oPrint:Say  (nRow	,1290		,aMatriz[n][1]	,oFont9 )//PRODUTOR 1 COL
	    
	    oPrint:Say  (nRow	,300	   	,SubStr(aMatriz[n][2],1,21)	,oFont9 )//CODIGO 2 COL
		oPrint:Say  (nRow	,1460		,SubStr(aMatriz[n][2],1,21)	,oFont9 )//PRODUTOR 2 COL
	
		nRow := nRow + 70
				
	End If
	
	If aMatriz[n+1][1] == "CARRETEIRO" .OR. aMatriz[n+1][1] == "" 
		
		For Xa := 1 to 10
		
				If nRow > 2940 
				
				oPrint:EndPage()
				oPrint:StartPage() // Inicia uma nova página
				nRow := 470
				n2 := 510
				oPrint:SayBitmap	(20	,115	,"QUATA.BMP"								,248,138	)
	    		oPrint:Say  		(60	,650	,"* * * ROMANEIO DE COLETA DE LEITE * * *"	,oFont16n	) 			
				oPrint:Say  		(60	,2120	,"Página "+cValToChar(nPag)	,oFont10	) 			
				oPrint:Say  		(200,120 	,"CARRETEIRO: "+allTrim(aMatriz[n][3])+space(60),oFont11)
				oPrint:Say  		(200,1278 	,"LINHA: "+allTrim(aMatriz[n][4]),oFont11) 			
				oPrint:Say  		(300,115 	,"D A T A :____/____/________ ",oFont10) 			
	    		oPrint:Say  		(300,1278 	,"D A T A :____/____/________ ",oFont10) 			

	   			oPrint:Say  (390	,73		,"      CÓDIGO   NOME                                                QTDE.        ÁCIDO",oFont9 ) 			
				oPrint:Say  (390	,1220		,"        CÓDIGO    NOME                                              QTDE.          ÁCIDO",oFont9 ) 			
	   
				oPrint:Box(370,270,450,115) 		//box cod1 
				oPrint:Box(370,770,450,270)    //box nome1
				oPrint:Box(370,970,450,770)   //box qtde1
				oPrint:Box(370,1125,450,970)  //box acido1
		
				oPrint:Box(370,1435,450,1280)	//box cod2
				oPrint:Box(370,1935,450,1435)	//box nome2
				oPrint:Box(370,2135,450,1935)	//box qtde2
				oPrint:Box(370,2290,450,2135)	//box acido2

			End If
				
			oPrint:Box(n2,270,450,115)		
			oPrint:Box(n2,770,450,270)
			oPrint:Box(n2,970,450,770)
			oPrint:Box(n2,1125,450,970)
			
			oPrint:Box(n2,1435,450,1280)
			oPrint:Box(n2,1935,450,1435)
			oPrint:Box(n2,2135,450,1935)
			oPrint:Box(n2,2290,450,2135)
			
			n2 := n2 + 70
			nRow := nRow + 70
		
	Next Xa 
		
		oPrint:Box(n2+20,270,450,115)
		oPrint:Box(n2+20,770,450,270)
		oPrint:Box(n2+20,970,450,770)
		oPrint:Box(n2+20,1125,450,970)
		oPrint:Box(n2+20,1435,450,1280)
		oPrint:Box(n2+20,1935,450,1435)
		oPrint:Box(n2+20,2135,450,1935)
		oPrint:Box(n2+20,2290,450,2135)
		oPrint:Say  (nRow,115,"                      T O T A I S",oFont12 ) 			
		oPrint:Say  (nRow,1320,"                 T O T A I S",oFont12 )

     End If

If nRow > 2940 .AND. aMatriz[n+1][1] <> "CARRETEIRO"
  	
  	oPrint:EndPage()
	oPrint:StartPage() // Inicia uma nova página
	nRow := 470
	n2 := 510
		oPrint:SayBitmap	(20	,115	,"QUATA.BMP"								,248,138	)
	    oPrint:Say  		(60	,650	,"* * * ROMANEIO DE COLETA DE LEITE * * *"	,oFont16n	) 			
		oPrint:Say  		(60	,2120	,"Página "+cValToChar(nPag)	,oFont10	) 			
		oPrint:Say  		(200,120 	,"CARRETEIRO: "+allTrim(aMatriz[n][3])+space(60),oFont11)
		oPrint:Say  		(200,1278 	,"LINHA: "+allTrim(aMatriz[n][4]),oFont11) 			
		oPrint:Say  		(300,115 	,"D A T A :____/____/________ ",oFont10) 			
	    oPrint:Say  		(300,1278 	,"D A T A :____/____/________ ",oFont10) 			
	    
	   	oPrint:Say  (390	,73		,"      CÓDIGO   NOME                                                QTDE.        ÁCIDO",oFont9 ) 			
		oPrint:Say  (390	,1220		,"        CÓDIGO    NOME                                              QTDE.          ÁCIDO",oFont9 ) 			
		
		oPrint:Box(370,270,450,115) 		//box cod1 
		oPrint:Box(370,770,450,270)    //box nome1
		oPrint:Box(370,970,450,770)   //box qtde1
		oPrint:Box(370,1125,450,970)  //box acido1
		
		oPrint:Box(370,1435,450,1280)	//box cod2
		oPrint:Box(370,1935,450,1435)	//box nome2
		oPrint:Box(370,2135,450,1935)	//box qtde2
		oPrint:Box(370,2290,450,2135)	//box acido2
	    
	    oPrint:Box(440,270,450,115)		
		oPrint:Box(440,770,450,270)
		oPrint:Box(440,970,450,770)
		oPrint:Box(440,1125,450,970)
		
		oPrint:Box(440,1435,450,1280)
		oPrint:Box(440,1935,450,1435)
		oPrint:Box(440,2135,450,1935)
		oPrint:Box(440,2290,450,2135)
	    nPag ++
	    
	    End If

If aMatriz[n+1][1] == aMatriz[n][1]
n ++
End If

next n

//oPrint:EndPage() // Finaliza a página

oPrint:Preview()
//oPrint:PRINT()

MS_FLUSH()

Return


/*BEGINDOC
//ÚÄÄÄÄÄÄ¿
//³funcao³
//ÀÄÄÄÄÄÄÙ
ENDDOC*/

Static Function  fPluSpace( cDet )

Local cDetF :=""
Local nX	:= 0

For nX := 1 to Len(cDet)
	cDetF += Subs(cDet,nX,1) + space(2)
Next nX    

Return(cDetF)

Static Function  fPluSpace2( cDet )
Local cDetF :=""
Local nX	:= 0

For nX := 1 to Len(cDet)
	cDetF += Subs(cDet,nX,1) + space(4)
Next nX    

Return(cDetF)