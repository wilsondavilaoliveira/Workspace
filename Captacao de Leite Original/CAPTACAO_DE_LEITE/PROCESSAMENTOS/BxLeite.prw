#Include 'Protheus.ch'
#Include  "rwmake.ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBXLEITE   บAutor  ณWilson Davila       บ Data ณ  06/01/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Baixa contas a pagar de titulos de leite por linha         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Queijos Quata                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function BxLeite()

Local cCheque
Local cQuery := ''
Local cQuery1 := ''
Local aCpoSE2 := {}
Local cBanco
Local cConta
Local cAgencia
Local cFil
Local cChInicial
Local cChFinal
Local cLinha
Local nLinha := 1
Private aRelatorio	:=  Array(1000,5)
Private aMatriz		:=  Array(1000,12)                            


If Pergunte('BXCHEQUE',.T.)

	cCheque		:= STRZERO(VAL(MV_PAR05),15)
	cBanco 		:= MV_PAR02                                                                                   
	cConta 		:= MV_PAR04
	cAgencia 	:= MV_PAR03                                                                                     
	cFil	 	:= STRZERO(VAL(MV_PAR01),2)
	cChInicial	:= STRZERO(VAL(MV_PAR05),15)
	cLinha 		:= MV_PAR06 
	
	cQuery := "SELECT SE2.R_E_C_N_O_ AS REGISTRO,LBB_CODPRO,LBB_NOMFOR,E2_FILIAL,LBB.LBB_CODPRO AS NUMERO,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,E2_VALOR"
	cQuery += " FROM " + RetSqlName('SE2') + " SE2 INNER JOIN " + RetSqlName('LBB') + " LBB ON E2_FORNECE=LBB_CODFOR AND E2_LOJA=LBB_LOJA"
	cQuery += " AND LBB_FILIAL=E2_FILIAL INNER JOIN " + RetSqlName('SA2') + " SA2 ON A2_COD=E2_FORNECE AND A2_LOJA=E2_LOJA AND SA2.D_E_L_E_T_=''" 
	cQuery += " WHERE E2_FILIAL='" + STRZERO(VAL(MV_PAR01),2) + " ' AND SE2.D_E_L_E_T_<>'*' AND A2_XTIPOPG='1' AND E2_VENCREA='" + dtos(MV_PAR07) + " ' AND E2_XLINHA='" + MV_PAR06 + "' AND E2_BAIXA=''"
	cQuery += " AND E2_TIPO<>'NDF' " 
	
	If STRZERO(VAL(MV_PAR01),2) == '03' //Para Filial Teodoro Sampaio se valor menor que 10 reais nao imprime cheque.
	cQuery += " AND E2_VALOR>10 "
	End If
	
	cQuery += " ORDER BY CAST(LBB_CODPRO AS INT)"
	
	cQuery := ChangeQuery( cQuery )
	
	If Select( "QUERY" ) > 0
		QUERY->( dbCloseArea() )
	EndIf
	
	dbUseArea( .T., "TOPCONN", TCGenQry( ,,cQuery ), "QUERY", .F., .F. )
	TCSETFIELD("QUERY","E2_VALOR","N",10,2)

	QUERY->( dbGoTop() )
	
	if QUERY->(EOF())
		MsgStop('Nao existem duplicatas de acordo com os parametros especificados!')
		return
	Else
	
		While QUERY->(!EOF()) 
		
			aMatriz[nLinha][1]	:= QUERY->NUMERO 		//Cod.Produtor Numerico
			aMatriz[nLinha][2] 	:= QUERY->REGISTRO		//RECNO
			aMatriz[nLinha][3] 	:= QUERY->LBB_CODPRO	//Cod.Produtor Char
			aMatriz[nLinha][4] 	:= QUERY->LBB_NOMFOR	//Nome Produtor
			aMatriz[nLinha][5] 	:= QUERY->E2_FILIAL		//Filial
			aMatriz[nLinha][6] 	:= QUERY->E2_PREFIXO	//Prefixo
			aMatriz[nLinha][7] 	:= QUERY->E2_NUM		//numero Dupl
			aMatriz[nLinha][8] 	:= QUERY->E2_PARCELA	//parcela
			aMatriz[nLinha][9] 	:= QUERY->E2_TIPO		//tipo
			aMatriz[nLinha][10] := QUERY->E2_FORNECE	//Cod.Fornecedor
			aMatriz[nLinha][11] := QUERY->E2_LOJA		//Loja Fornecedor
			aMatriz[nLinha][12]	:= QUERY->E2_VALOR		//Valor
			
			nLinha ++
			
			QUERY->(dbSkip())
			
		End While
		
	nLinha := 1
	
	QUERY->( dbGoTop() )
	
		
		While QUERY->(!EOF())
		
			cQuery1 := "SELECT EF_NUM"
			cQuery1 += " FROM " + RetSqlName('SEF') + " SEF"
			cQuery1 += " WHERE D_E_L_E_T_<>'*' AND EF_BANCO='" + cBanco + " ' AND EF_AGENCIA='" + cAgencia + "' AND EF_CONTA='" + cConta + "' AND EF_NUM='" + cCheque + "'"
				
			If Select( "QUERY1" ) > 0
				QUERY1->( dbCloseArea() )
			EndIf
		
			dbUseArea( .T., "TOPCONN", TCGenQry( ,,cQuery1 ), "QUERY1", .F., .F. )
			QUERY1->( dbGoTop() )
			
				If QUERY1->(!EOF())
			   	    MsgStop("O cheque No:" + cCheque + " Banco:" + cBanco + " Agencia:" + cAgencia + " Conta:" + cConta + " ja existe favor verificar, o processo sera abandonado !")                                                                      
		            Return
		        End If                                                                        
			
			QUERY->(DbSkip())
			cCheque := STRZERO(val(cCheque)+1,15)
		
		End While
			
			cCheque := cChInicial
			
			QUERY->( dbGoTop() )
			
			While QUERY->(!EOF())
			
				AADD(aCpoSE2,{"E2_FILIAL"  ,cFil		 			,Nil})
				AADD(aCpoSE2,{"E2_PREFIXO" ,aMatriz[nLinha][6]		,Nil})
				AADD(aCpoSE2,{"E2_NUM"     ,aMatriz[nLinha][7]		,Nil})
				AADD(aCpoSE2,{"E2_PARCELA" ,aMatriz[nLinha][8]		,Nil})
				AADD(aCpoSE2,{"E2_TIPO"    ,aMatriz[nLinha][9]		,Nil})
				AADD(aCpoSE2,{"E2_FORNECE" ,aMatriz[nLinha][10]	,Nil})
				AADD(aCpoSE2,{"E2_LOJA"    ,aMatriz[nLinha][11]	,Nil})
				AADD(aCpoSE2,{"AUTMOTBX"   ,'NOR',						Nil})                                                                                     
				AADD(aCpoSE2,{"AUTBANCO"   ,cBanco,						Nil})                                                                                     
				AADD(aCpoSE2,{"AUTCONTA"   ,cConta,						Nil})                                                                                     
				AADD(aCpoSE2,{"AUTAGENCIA" ,cAgencia,					Nil})                                                                                     
				AADD(aCpoSE2,{"AUTHIST"    ,'TIT. GERADO FECH. LEITE',	Nil})                                                                                     
				AADD(aCpoSE2,{"AUTCHEQUE"  ,cCheque,					Nil})                                                                                     
				AADD(aCpoSE2,{"AUTVLRPG"   ,aMatriz[nLinha][12],		Nil})                                                                                     
				
				lMsErroAuto:=.F.
				lMSHelpAuto:= .T.
				INCLUI := .F.
											
				MsExecAuto( { |x,y| fina080(x,y)},aCpoSe2,3)
				
					If lMsErroAuto
						aCpoSE2 := {}
						Mostraerro()
						nLinha ++
					Else
						aRelatorio[nLinha][1] := aMatriz[nLinha][3]
						aRelatorio[nLinha][2] := aMatriz[nLinha][4]
						aRelatorio[nLinha][3] := cLinha
						aRelatorio[nLinha][4] := cCheque
						aRelatorio[nLinha][5] := aMatriz[nLinha][12]
						nLinha ++
						aCpoSE2 := {}
						cCheque := STRZERO(val(cCheque)+1,15)
					Endif
						
				QUERY->(DbSkip())
				
			End While
		
	cChFinal := STRZERO(val(cCheque)-1,15)
	nLinha --
	
	RlBxLeite(nLinha)
	
	//MsgAlert("Baixa Efetuada ! LINHA> " + cLinha + " - CH.Inicial> " + cChInicial + " - CH.Final> " + cChFinal + "")
	
	End If
	
End IF

Return nil 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRlBxLeite บ Autor ณ Wilson Davila      บ Data ณ  02/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio lista de propriedades com numeracao de cheque,   บฑฑ
ฑฑบ          ณ por linha  de leite                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P10 QUATA                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RlBxLeite(nLinha)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "BxLeite"
Local cPict    	     := ""
Local titulo       := "Relat๓rio Baixa cheque por linha"
Local nLin         := 80
Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd 		   := {}
Local cQuery	   := ""

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "P"
Private nomeprog         := "RLBXLEITE" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := {"Zebrado",1, "Administracao",2,2,1,"", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RLBXLEITE" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString := ""

wnrel := SetPrint(cString,NomeProg,"RLBXLEITE",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,,,,,.F.,)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,aRelatorio,nLinha) },Titulo)

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  15/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,aRelatorio,nLinha)

Local nOrdem
Local nLinha1 	:= 1
Local nTotal 	:= 0

SetRegua(nlinha)

nLinha1 := 1

While nLinha1 <= nLinha


   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   
   If nLin > 55// Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(ALLTRIM(Titulo) + "-" + cValToChar(aRelatorio[nLinha][3]),Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      @6,000 PSAY "COD.PRO" 
      @6,007 PSAY "|"
      @6,008 PSAY "NOME PRODUTOR" 
      @6,038 PSAY "|"
      @6,039 PSAY "LINHA" 
      @6,045 PSAY "|"
      @6,046 PSAY "CHEQUE" 
      @6,061 PSAY "|"
      @6,062 PSAY "DATA" 
      @6,072 PSAY "|"
      @6,073 PSAY "VALOR"
      @7,000 PSAY __PrtThinLine()
      nLin := 8
   Endif
         
      @nLin,000 PSAY aRelatorio[nLinha1][1] 
      @nLin,007 PSAY "|"
      @nLin,008 PSAY SubStr(aRelatorio[nLinha1][2],1,29) 
      @nLin,038 PSAY "|"
      @nLin,039 PSAY aRelatorio[nLinha1][3] 
      @nLin,045 PSAY "|"
      @nLin,046 PSAY aRelatorio[nLinha1][4] 
      @nLin,061 PSAY "|"
      @nLin,062 PSAY dDatabase
      @nLin,072 PSAY "|"
      @nLin,073 PSAY aRelatorio[nLinha1][5] picture "@E 99,999.99"
      nTotal := nTotal + aRelatorio[nLinha1][5] 		
   	nLin  ++ // Avanca a linha de impressao
    nLinha1 ++
		
	IncRegua("Gerando Impressao . . ." + cvaltochar(nLinha))

EndDo
    
    @nLin,060 PSAY "TOTAL==> 
	@nLin,073 PSAY nTotal picture "@E 99,999.99"

SET DEVICE TO SCREEN

If aReturn[5] == 1
   dbCommitAll()
   SET PRINTER TO 
   OurSpool(wnrel)
Endif


MS_FLUSH()

Return()
