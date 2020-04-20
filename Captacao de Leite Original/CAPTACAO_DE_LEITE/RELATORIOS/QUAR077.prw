#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAR077   º Autor ³ Wilson Davila      º Data ³  01/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio Folha de Convenio por linha e produtor           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - Quata                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function QUAR077()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de convenios produtores"
Local cPict          := ""
Local titulo       := "Relatorio de convenios produtores"
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "M"
Private nomeprog         := "QUAR077"
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "QUAR077"
Private cPerg	   := "QUAR077"

Private cString := ""

AjustaSx1(cPerg)

If Pergunte(cPerg,.T.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

End If

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  01/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local lImprimiu	:= .F.
Local cMyTitulo := "Relatorio de convenios produtores"
Local cLinCab1	:= ""
Local cLinCab2	:= ""
Local cLinCab3	:= ""
Local cLinCab0	:= ""
Local nRec		:= 0
Local cCodPro	:= ''
Local cnLinha	:= ''

Private nTot		:= 0
Private nTot1		:= 0


Cabec1 := ""
Cabec2 := ""

Cabec1 := ""


If MV_PAR07 == 1
Cabec1 := Padr("Linha" , 7)
Cabec1 += Padr("CodPro" , 7)
Cabec1 += Padr("Fornecedor" , 30)
Else
Cabec1 := Padr("CodFor" , 7)
Cabec1 += Padr("Convenio" , 30)
End If

Cabec1 += PadL("Valor" , 15)+"  "

If MV_PAR07 == 1
Cabec1 += Padr("Cod" , 4)
Cabec1 += Padr("Descricao" , 30)
Cabec1 += Padr("Observacao" , 60)
ELSE
Cabec1 += Padr("CodPro" , 7)
Cabec1 += Padr("Produtor" , 30)
Cabec1 += Padr("Observacao" , 60)
END IF

cLinCab1 := Cabec1
Cabec1 := ""

RunConv()

While QRYNFE->( !EOF() )
nRec ++
QRYNFE->( dbSkip() )
End While

QRYNFE->( dbGoTop() )

SetRegua(nRec)

nRec := 0

Titulo := "Relatorio de convenios produtores"+ StrZero(month(MV_PAR01),2)+"/"+cValToChar(year(MV_PAR01))+"-"+cValToChar(SM0->M0_FILIAL)

If MV_PAR07 == 1
cCodPro := QRYNFE->PA6_CODPRO
Else
cCodPro := QRYNFE->PA6_FORNEC
End If

While QRYNFE->( !EOF() )

IncRegua(nRec)
nRec ++	
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 5
			lImprimiu := .F.
		Endif
		If !lImprimiu
			nLin ++
			@ nLin, 000 pSay cLinCab1
			nLin++
			@ nLin, 000 pSay __PrtFatLine()
			nLin++
			lImprimiu := .T.
		
		EndIf
				If MV_PAR07 == 1 
				cLinha := Padr(QRYNFE->LBB_LINHA + " " + QRYNFE->PA6_CODPRO		, 14) 			// Linha + CodProdutor
				cLinha += Padr(QRYNFE->LBB_NOMFOR 									, 29) + " "		// Nome Forncedor
				Else
				cLinha := Padr(QRYNFE->PA6_FORNECE									, 7) 				// Linha + CodFornecedor
				cLinha += Padr(QRYNFE->LBR_DESC										, 29) + " "			// Nome Convenio
				End If
				
				cLinha += Padl(Transform(QRYNFE->PA6_VALOR,"@E 999,999,999.99") 	, 15) + "  "		// Valor
				
				IF MV_PAR07 == 1
				cLinha += PadR(QRYNFE->PA6_TIPDES+"-"+SUBSTR(QRYNFE->LBR_DESC,1,29), 34)			// Tipo de despesa
				cLinha += PadR(QRYNFE->PA6_OBSERV 									, 60)			// Observacao
				ELSE
				cLinha += PadR(QRYNFE->PA6_CODPRO+"-"+SUBSTR(LBB_NOMFOR,1,29)		, 36)			// Tipo de despesa
				cLinha += PadR(QRYNFE->PA6_OBSERV 									, 60)			// Observacao
                END IF
				
				@ nLin, 000 pSay cLinha
				nLin++
			
				nTot 	+=  QRYNFE->PA6_VALOR
				nTot1 	+=  QRYNFE->PA6_VALOR
							
				lImprimiu := .T.
			
QRYNFE->( dbSkip() )


IF MV_PAR07 == 1
	IF QRYNFE->PA6_CODPRO <> cCodPro
	nLin := PrtSub(nLin,cCodPro)
	cCodPro := QRYNFE->PA6_CODPRO 
	nTot := 0
	End If
ELSE
	IF QRYNFE->PA6_FORNEC <> cCodPro
	nLin := PrtSub(nLin,cCodPro)
	cCodPro := QRYNFE->PA6_FORNEC 
	nTot := 0
	End If
END IF


	
End While

If lImprimiu
	nLin++
	@ nLin, 000 pSay __PrtFatLine()
	nLin++
	
	IF MV_PAR07 == 1
	cLinha := Padr("Total Convenios --->" , 44)
	ELSE
	cLinha := Padr("Total Convenios --->" , 37)
	END IF
	
	cLinha += padl(Transform(nTot1, "@E 999,999,999.99"), 15)
	
	@ nLin, 000 pSay cLinha
	nLin++
	
	@ nLin, 000 pSay __PrtFatLine()
	nLin++

Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime subtotal por produtor³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/

Static Function PrtSub(nLin,cCodPro)

	@ nLin, 000 pSay "------------------------------------------------------------"
	nLin++
	
	IF MV_PAR07 == 1
	cLinha := Padr("Total Produtor " + cCodPro + " --->" , 44)
	ELSE
	cLinha := Padr("Total Convenio " + cCodPro + " --->" , 37)
    END IF
	
	cLinha += padl(Transform(nTot, "@E 999,999,999.99"), 15)
	@ nLin, 000 pSay cLinha
	nLin++
	
	@ nLin, 000 pSay "------------------------------------------------------------"
	nLin++
	nLin++
	nLin++
	@ nLin, 000 pSay __PrtThinLine()
    nLin ++
	Return(nLin)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³AjustaSX1 ³ Autor ³  Wilson Davila        ³ Data ³01/12/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta perguntas no SX1.                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function AjustaSx1(cPerg)

PutSx1(cPerg,"01","Entrada De?" 	,"","","mv_ch1","D",08,0,0,"G","",""		,"","","mv_par01")
PutSX1(cPerg,"02","Entrada Até?"	,"","","mv_ch2","D",08,0,0,"G","",""		,"","","mv_par02")
PutSx1(cPerg,"03","Produtor De?" 	,"","","mv_ch3","C",06,0,0,"G","","LBBCOD"	,"","","mv_par03")
PutSX1(cPerg,"04","Produtor Até?"	,"","","mv_ch4","C",06,0,0,"G","","LBBCOD"	,"","","mv_par04")
PutSx1(cPerg,"05","Linha De?" 		,"","","mv_ch5","C",06,0,0,"G","","PA7"	,"","","mv_par05")
PutSX1(cPerg,"06","Linha Até?"		,"","","mv_ch6","C",06,0,0,"G","","PA7"	,"","","mv_par06")
PutSX1(cPerg,"07","Ordem?"			,"","","mv_ch7","N",01,0,0,"C","","","","", "mv_par07","1-Produtor"," "," ","","2-Convenio"," "," ")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RunConv   ºAutor  ³Wilson Davila       º Data ³  01/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Query levantamento de dados de Convenio produtores          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - Quata                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunConv()

Local cQuery1	:= ""
Local nRet		:= 0

cQuery1 := "SELECT LBB_LINHA,PA6_CODPRO,LBB_NOMFOR,PA6_FORNEC,PA6_VALOR,PA6_TIPDES,LBR_DESC,PA6_OBSERV " 
cQuery1 += "FROM " + RetSqlName("PA6") + " PA6 "
cQuery1 += "INNER JOIN " + RetSqlName("LBR") + " LBR ON LBR_FILIAL=PA6_FILIAL AND LBR_TIPDES=PA6_TIPDES AND LBR.D_E_L_E_T_='' "
cQuery1 += "INNER JOIN " + RetSqlName("LBB") + " LBB ON LBB_CODPRO=PA6_CODPRO AND LBB_FILIAL=PA6_FILIAL AND LBB.D_E_L_E_T_='' "
cQuery1 += "WHERE PA6_FILIAL = '" + cFilAnt + "' AND PA6.D_E_L_E_T_='' "
cQuery1 += "AND (PA6_CODPRO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "') AND (LBB_LINHA BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "') " 
cQuery1 += "AND PA6_PERIOD='" + StrZero(month (MV_PAR01),2) +  cValTochar(year( MV_PAR02 )) + "' "
IF MV_PAR07 == 1
cQuery1 += "ORDER BY CAST(LBB_LINHA AS INT),CAST(PA6_CODPRO AS INT)"
ELSE
cQuery1 += "ORDER BY CAST(PA6_FORNEC AS INT),CAST(PA6_CODPRO AS INT)"
END IF

MemoWrite("C:\EDI\CONV.SQL",cQuery1)

cQuery1 := ChangeQuery( cQuery1 )

If Select("QRYNFE") > 0
	dbSelectArea("QRYNFE")
	QRYNFE->(dbCloseArea())
EndIf

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery1), 'QRYNFE', .F., .T.)

QRYNFE->( dbGoTop() )

Return()
