#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAR076   º Autor ³ AP6 IDE            º Data ³  05/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function QUAR076()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3         	:= "Conferencia do valor do leite"
Local cPict          	:= ""
Local titulo       		:= "Conferencia do valor do leite"
Local nLin         		:= 80

Local Cabec1       		:= ""
Local Cabec2       		:= ""
Local imprime      		:= .T.
Local aOrd 				:= {}
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite          := 132
Private tamanho         := "M"
Private nomeprog        := "QUAR076" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       	:= "QUAR76"
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "QUAR076" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "LBB"

dbSelectArea("LBB")
dbSetOrder(1)

AjustaSx1(cPerg)

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  05/12/08   º±±
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

Local nOrdem
Private aTotal	:= {}
Private aHeader	:= {}
Private aCols	:= {}
Private aGTotal	:= {}
Private nTotal	:= 0
Private nGtotal	:= 0

dbSelectArea(cString)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


aParc := QUAR764I()

aHeader := aClone(aParc[1])
aCols	:= aClone(aParc[2])
aTotal 	:= Array(Len(aHeader))
aGTotal := Array(Len(aHeader))

for nXa := 1 to len(aTotal)
	aTotal[nXa] := 0
	aGTotal[nXa] := 0
next nXa
nTotal 	:= 0
nGtotal	:= 0

SetRegua(Len(aCols))

Cabec1 := ""

For nXa := 1 to len(aHeader)
	If aHeader[nXa][8] == "N"
		Cabec1 += PadL(aHeader[nXa][1], aHeader[nXa][4]) + " "
	Else
		Cabec1 += PadR(aHeader[nXa][1], aHeader[nXa][4]) + " "
	Endif

next nXa


cLinAnt	:= ""
nPosLinha	:= ascan(aHeader, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("PC1_LINHA")) } )
If nPosLinha > 0
For nXa	:= 1 to Len(aCols)

   	If lAbortPrint
      	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      	Exit
   	Endif

   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   	//³ Impressao do cabecalho do relatorio. . .                            ³
   	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   	If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
      	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      	nLin := 8
   	Endif

   	If cLinAnt <> aCols[nXa][nPosLinha]
   		FechaLin(@nLin, cLinAnt)
		for nXc := 1 to len(aTotal)
			aTotal[nXc] := 0
		next nXc
		nTotal := 0
   		cLinAnt := aCols[nXa][nPosLinha]
   		AbreLinha(@nLin, cLinAnt)
   	Endif
   	
    
    cLinha := "" 
	For nXb := 1 to len(aHeader)
		If aHeader[nXb][8] == "N"
			cLinha += PadL(Transform(aCols[nXa][nxB], aHeader[nXb][3] ), aHeader[nXb][4]) + " "
		Else
			cLinha += Padr(aCols[nXa][nxB], aHeader[nXb][4]) + " "
		Endif
		
		If nXb > 3  .and. aHeader[nXb][8] == "N"
			aTotal[nXb] += aCols[nXa][nxB]
			aGTotal[nXb]+= aCols[nXa][nXb]
		Else
			aTotal[nXb] := Padr(" ", aHeader[nXb][4])
			aGTotal[nXb] := Padr(" ", aHeader[nXb][4])
		Endif
	next nXb

    @ nLin, 00 pSay cLinha
    nLin++

	nTotal++
	nGtotal++    
Next nXa

FechaLin(@nLin, cLinAnt)
for nXc := 1 to len(aTotal)
	aTotal[nXc] := 0
next nXc
nTotal := 0

FechaRep(@nLin)

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

Return Nil






/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAA074I  ºAutor  ³Microsiga           º Data ³  30/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Montagem da Query e atualiza o campo LBO_VALOR             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QUATA                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function QUAR764I()

Local dDataIni 	:= cTod("01" + "/" + Left(MV_PAR01,2) + "/" + substr(MV_PAR01,3))
Local dDataFim 	:= LastDay(dDataIni)
Local dMAntFim 	:= dDataIni - 1
Local dMantIni 	:= FirstDay( dMantFim )
LOcal nQtdDia	:= (dDataFim - dDataIni) + 1
LOcal nQtdDia1	:= (dMAntFim - dMAntIni) + 1
Local aRestr	:= {}
Local aTemp		:= {}
Local aMesAnt	:= {}
Local aRet		:= {}
Local nRec		:= 0

Private aHeader := {}
Private aCols	:= {}
                     
_cQuery  := ""
_cQuery 	:= "SELECT PC1_LINHA, PC1_CODPRO, Sum(PC1_QTDLIT) QTDLIT, AVG(PC1_VLRLIT) VLRLIT, count(PC1_NUMSEQ) QTDDIA "
_cQuery 	+= "FROM " + RetSqlName("PC0") + " PC0 INNER JOIN " + RetSqlName("PC1") + " PC1 ON "
_cQuery 	+= "PC1_FILIAL = PC0_FILIAL AND PC1_NUMSEQ = PC0_NUMSEQ AND PC1.D_E_L_E_T_ = ' ' "
_cQuery 	+= "INNER JOIN " + RetSqlName("PA7") + " PA7 ON "
_cQuery 	+= "PA7_FILIAL = '"+xFilial("PA7")+"' AND PA7_CODLIN = PC1_LINHA AND PA7.D_E_L_E_T_ = ' ' "
_cQuery 	+= "WHERE PC0_FILIAL = '" + xFilial("PC0") + "' "
_cQuery 	+= "AND PC0_DTENTR >= '" + dTos(dMAntIni) + "' "
_cQuery 	+= "AND PC0_DTENTR <= '" + dTos(dMAntFim) + "' "
_cQuery 	+= "AND PC1_CODPRO >= '" + MV_PAR02 + "' "
_cQuery 	+= "AND PC1_CODPRO <= '" + MV_PAR03 + "' "
_cQuery 	+= "AND PA7_CODLIN >= '" + MV_PAR04 + "' "
_cQuery 	+= "AND PA7_CODLIN <= '" + MV_PAR05 + "' "
_cQuery 	+= "AND PC0.PC0_TPENTR = '1' "
_cQuery 	+= "AND PC0_QTDAPO > 0 "
_cQuery 	+= "AND PC0.D_E_L_E_T_ = ' ' "
_cQuery 	+= "Group By PC1_LINHA, PC1_CODPRO "
_cQuery 	+= "Order By CAST(PC1_LINHA AS INT), CAST(PC1_CODPRO AS INT) "

If Select("QRY") > 0
	dbSelectArea("QRY")
	dbCloseArea()
Endif

_cQuery := ChangeQuery(_cQuery) 

memowrite("wm004C.sql", _cQuery)

DbUseArea(.T.,'TOPCONN',TCGENQRY(,,_cQuery),"QRY",.T.,.T.)

tcSetField("QRY", "QTDLIT", "N", 12, 2 )
tcSetField("QRY", "LVRLIT", "N", 10, 4 )
tcSetField("QRY", "QTDDIA", "N", 10, 2 )

While QRY->(!EOF())
nRec ++
QRY->( DbSkip() )
End While

SetRegua(nRec)
nRec := 1

QRY->( dbGoTop () )

If QRY->(!EOF())
	
	
	
	While QRY->(!EOF())
		
		IncRegua(nRec)
		nRec ++ 
	
		IncProc("Processando...")
		
		aadd(aTemp, QRY->PC1_LINHA)				// 	1
		aadd(aTemp, QRY->PC1_CODPRO)			//	2
		aadd(aTemp, QRY->QTDLIT)				// 	3
		aadd(aTemp, QRY->QTDLIT / nQtdDia1)		//	4
		aadd(aTemp, QRY->VLRLIT)				//	5
		
        aadd(aMesAnt, aTemp)
        aTemp := {}
		QRY->(DbSkip())
	EndDo
EndIf

QRY->( dbCloseArea() )
    

_cQuery  := ""
_cQuery 	:= "SELECT PC1_LINHA, PC1_CODPRO, Sum(PC1_QTDLIT) QTDLIT, AVG(PC1_VLRLIT) VLRLIT, count(PC1_NUMSEQ) QTDDIA "
_cQuery 	+= "FROM " + RetSqlName("PC0") + " PC0 INNER JOIN " + RetSqlName("PC1") + " PC1 ON "
_cQuery 	+= "PC1_FILIAL = PC0_FILIAL AND PC1_NUMSEQ = PC0_NUMSEQ AND PC1.D_E_L_E_T_ = ' ' "
_cQuery 	+= "INNER JOIN " + RetSqlName("PA7") + " PA7 ON "
_cQuery 	+= "PA7_FILIAL = '"+xFilial("PA7")+"' AND PA7_CODLIN = PC1_LINHA AND PA7.D_E_L_E_T_ = ' ' "
_cQuery 	+= "WHERE PC0_FILIAL = '" + xFilial("PC0") + "' "
_cQuery 	+= "AND PC0_DTENTR >= '" + dTos(dDataIni) + "' "
_cQuery 	+= "AND PC0_DTENTR <= '" + dTos(dDataFim) + "' "
_cQuery 	+= "AND PC1_CODPRO >= '" + MV_PAR02 + "' "
_cQuery 	+= "AND PC1_CODPRO <= '" + MV_PAR03 + "' "
_cQuery 	+= "AND PA7_CODLIN >= '" + MV_PAR04 + "' "
_cQuery 	+= "AND PA7_CODLIN <= '" + MV_PAR05 + "' "
_cQuery 	+= "AND PC0.PC0_TPENTR = '1' "
_cQuery 	+= "AND PC0_QTDAPO > 0 "
_cQuery 	+= "AND PC0.D_E_L_E_T_ = ' ' "
_cQuery 	+= "Group By PC1_LINHA, PC1_CODPRO "
_cQuery 	+= "Order By CAST(PC1_LINHA AS INT), CAST(PC1_CODPRO AS INT) "

aadd(aRestr, {"PC1", "PC1_LINHA" , "PC1_LINHA", 	"Linha"})
aadd(aRestr, {"PC1", "PC1_CODPRO", "PC1_CODPRO", 	"Propr." })
aadd(aRestr, {"LBB", "LBB_NOMFOR", "LBB_NOMFOR", 	"Associado" })
aadd(aRestr, {"PC1", "PC1_QTDLIT", "QTDDIA1", 		"Media Ant."})
aadd(aRestr, {"PC1", "PC1_QTDLIT", "MESANT", 		"Vol.Ant."})
aadd(aRestr, {"PC1", "PC1_QTDLIT", "QTDLIT", 		"Vol.Atual"})
aadd(aRestr, {"PC1", "PC1_QTDLIT", "QTDDIA", 		"Media Atual"})
aadd(aRestr, {"PC1", "PC1_VLRLIT", "VLROLD", 		"R$ Mes Ant."})
aadd(aRestr, {"PC1", "PC1_VLRLIT", "VLRLIT",		"R$ Mes Atual"})
aadd(aRestr, {"LBB", "LBB_DESC",   "VLRNOVO", 		"Novo Valor"})

aHeader := MntaHead( aRestr )

If Select("QRY") > 0
	dbSelectArea("QRY")
	dbCloseArea()
Endif
_cQuery := ChangeQuery(_cQuery) 

memowrite("wm004A.sql", _cQuery)

DbUseArea(.T.,'TOPCONN',TCGENQRY(,,_cQuery),"QRY",.T.,.T.)

tcSetField("QRY", "QTDLIT", "N", 12, 2 )
tcSetField("QRY", "LVRLIT", "N", 10, 4 )
tcSetField("QRY", "QTDDIA", "N", 10, 2 )
tcSetField("QRY", "QTDDIA1", "N", 10, 2 )
tcSetField("QRY", "MESANT", "N", 10, 2 )
tcSetField("QRY", "VLROLD", "N", 10, 4 )

nRec := 0

While QRY->(!EOF())
nRec ++
QRY->( DbSkip() )
End While

SetRegua(nRec)
nRec := 1

QRY->( DbGoTop() )

If QRY->(!EOF())
	
	
	
	While QRY->(!EOF())
	
		IncRegua(nRec)
		nRec ++
		IncProc("Processando...")
	
		dbSelectArea("LBB")
		dbSetOrder(1)
		dbSeek( xFilial("LBB") + QRY->PC1_CODPRO )
		
		nPOs	:= ascan(aMesAnt, { |x| alltrim(Upper(x[1]+x[2])) == alltrim(Upper(QRY->(PC1_LINHA+PC1_CODPRO))) })

		aadd(aTemp, QRY->PC1_LINHA)
		aadd(aTemp, QRY->PC1_CODPRO)
		aadd(aTemp, LBB->LBB_NOMFOR)
		aadd(aTemp, Iif(nPos>0,aMesAnt[nPos][4], 0))
		aadd(aTemp, Iif(nPos>0,aMesAnt[nPos][3], 0))
		aadd(aTemp, QRY->QTDLIT)
		aadd(aTemp, QRY->QTDLIT / nQtdDia)
		aadd(aTemp, Iif(nPos>0,aMesAnt[nPos][5], 0) )
		aadd(aTemp, QRY->VLRLIT)
		aadd(aTemp, Replicate("_",11) )
		
        aadd(aCols, aTemp)
        aTemp := {}
		QRY->(DbSkip())
	EndDo
	QRY->( dbCloseArea() )
    aadd(aRet, aHeader)
    aadd(aRet, aCols)
Else
	Alert("Não existem registros para atualização do Preço do Leite.")
	QRY->( dbCloseArea() )
	aadd(aRet, {} )
	aadd(aRet, {} )
EndIf
    

Return aRet




Static Function MntaHead( aRestr )
Local aRet		:= {}
Local aAreaSX3	:= SX3->(GetArea())
Local nXa		:= 0

dbSelectArea("SX3")
dbSetOrder(2)

For nXa := 1 to Len(aRestr)
	If dbSeek( aRestr[nXa][2] )
		Aadd(aRet,{ If(Empty(aRestr[nXa][4]), AllTrim(X3Titulo()),aRestr[nXa][4]),;
			Iif(Empty(aRestr[nXa][3]), SX3->X3_CAMPO,aRestr[nXa][3]),;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )
	Endif
Next nXa

Return aRet                                         



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

PutSx1(cPerg,"01","Mes e Ano?" ,"","","mv_ch1","C",06,0,0,"G","", "", " ", " ","mv_par01")

PutSx1(cPerg,"02","Produtor De?" ,"","?","mv_ch2","C",06,0,0,"G","", "LBB", " ", " ","mv_par02")
PutSX1(cPerg,"03","Produtor Até?"," ","","mv_ch3","C",06,0,0,"G","","LBB","","", "mv_par03")

PutSx1(cPerg,"04","Linha De?" ,"","","mv_ch4","C",06,0,0,"G","", "PA7", " ", " ","mv_par04")
PutSx1(cPerg,"05","Linha Até?","","","mv_ch5","C",06,0,0,"G","", "PA7", " ", " ","mv_par05")

Return   
        



Static Function FechaLin(nLin, cCodLin)
Local nSomar	:= 0

For nXb := 1 to len(aHeader)
	If aHeader[nXb][8] == "N"
		nSomar	+= aTotal[nXB]
	Endif
next nXb


If nSomar > 0
	@ nLin,000 Psay __PrtThinLine()
	nLin++                     

	cLinha := "" 
	For nXb := 1 to len(aHeader)
		If aHeader[nXb][8] == "N"
			If nXb = 4 .or. nXb = 7 .or. nXb = 8 .or. nXb = 9
				cLinha += PadL(Transform(aTotal[nxB]/nTotal, aHeader[nXb][3] ), aHeader[nXb][4]) + " "
			Else
				cLinha += PadL(Transform(aTotal[nxB], aHeader[nXb][3] ), aHeader[nXb][4]) + " "
			Endif
		Else
			cLinha += Padr(aTotal[nxB], aHeader[nXb][4]) + " "
		Endif
	next nXb
	@ nLin, 00 pSay cLinha
	nLin++
	nLin++
Endif
Return nil




Static Function AbreLinha(nLin, cCodLin)
Local aAreaAnt	:= GetArea()

dbSelectArea("PA7")
dbSetOrder(1)
dbSeek( xFilial("PA7") + cCodLin )
cLinha := "Linha Numero " + cCodLin + " - " + PA7->PA7_DESC
@ nLin, 000 pSay cLinha
nLin++

@ nLin,000 Psay __PrtThinLine()
nLin++                     
Return nil




Static Function FechaRep(nLin)
Local nSomar	:= 0

	@ nLin,000 Psay __PrtThinLine()
	nLin++                     

	cLinha := "" 
	For nXb := 1 to len(aHeader)
		If aHeader[nXb][8] == "N"
			If nXb = 4 .or. nXb = 7 .or. nXb = 8 .or. nXb = 9
				cLinha += PadL(Transform(aGTotal[nxB]/nGTotal, aHeader[nXb][3] ), aHeader[nXb][4]) + " "
			Else
				cLinha += PadL(Transform(aGTotal[nxB], aHeader[nXb][3] ), aHeader[nXb][4]) + " "
			Endif
		Else
			cLinha += Padr(aGTotal[nxB], aHeader[nXb][4]) + " "
		Endif
	next nXb
	@ nLin, 00 pSay cLinha
	nLin++

	@ nLin,000 Psay __PrtThinLine()
	nLin++                     
	nLin++

Return nil
