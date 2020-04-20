#include "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ QUAA074A º Autor ³ Andreia J da Silva º Data ³  30/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualizacao do Preco final do Leite na Entrada de Leite.	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QUATA	                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function QUAA074A()
Local cPerg    	:= "QUA74A"
Local cNomArq  	:= ""  
Local lRet	   	:= .F.    
Local aSay      := {}
Local aButton   := {}
Local lOK		:= .F.

Private lImpMes	:= .F.
Private cCadastro   := "Atualização de Preço Final do Leite"

AjustaSx1(cPerg)

If Pergunte(cPerg,.T.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³MV_PAR01 - Entrada De                       ³
	//³MV_PAR02 - Entrada Ate                      ³
	//³MV_PAR03 - Produtor De                      ³
	//³MV_PAR04 - Produtor Ate                     ³
	//³MV_PAR05 - Rota De                          ³
	//³MV_PAR06 - Rota Ate                         ³
	//³MV_PAR07 - Carreteiro De                    ³
	//³MV_PAR08 - Carreteiro Ate                   ³
	//³MV_PAR09 - Novo Valor                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

	aAdd(aSay,"Esta rotina tem por objetivo atualizar o preço a ser pago por litro de leite")
	aAdd(aSay,"para os produtores que já tiverem seu leite lançado no laticínio.")
	aAdd(aSay,Iif(lImpMes,"COM","SEM") + " importacao do mes anterior.")
	
	aAdd(aButton, { 5,.T.,{|| Pergunte( cPerg, .T. ) 	}})//Parametros
	aAdd(aButton, { 16,.T.,{|| InvImp()	}})				   //OK
	aAdd(aButton, { 1,.T.,{|| FechaBatch(), ProQRY()	}})//OK
	aAdd(aButton, { 2,.T.,{|| FechaBatch()           	}})//Cancelar
		
	FormBatch(cCadastro,aSay,aButton) 	
	
EndIf
Return Nil

Static Function InvImp()
lImpMes := !lImpMes
Return Nil         


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
                             
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProQRY   ºAutor  ³Andreia J da Silva   º Data ³  30/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que chama a montagem da Query.                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QUATA                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProQRY()

Processa( {|| QUAA074I()},"Aguarde...","Atualizando o Preço do Leite.", .T. )

Return

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
Static Function QUAA074I()
Local dDataIni := cTod("01" + "/" + Left(MV_PAR01,2) + "/" + substr(MV_PAR01,3))
Local dDataFim := LastDay(dDataIni)
Local dMAntFim := dDataIni - 1
Local dMantIni := FirstDay( dMantFim )
LOcal nQtdDia	:= (dDataFim - dDataIni) + 1
LOcal nQtdDia1	:= (dMAntFim - dMAntIni) + 1
Local aRestr	:= {}
Local aTemp		:= {}
Local aMesAnt	:= {}
Private aHeader := {}
Private aCols	:= {}
                     
_cQuery  := ""
_cQuery 	:= "SELECT PC1_LINHA, PC1_CODPRO, Sum(PC1_QTDLIT) QTDLIT, AVG(PC1_VLRLIT) VLRLIT, count(PC1_NUMSEQ) QTDDIA "
_cQuery 	+= "FROM " + RetSqlName("PC0") + " PC0 INNER JOIN " + RetSqlName("PC1") + " PC1 ON "
_cQuery 	+= "PC1_FILIAL = PC0_FILIAL AND PC1_NUMSEQ = PC0_NUMSEQ AND PC1.D_E_L_E_T_ = ' ' "
_cQuery 	+= "INNER JOIN " + RetSqlName("PA7") + " PA7 ON "
_cQuery 	+= "PA7_FILIAL = '"+xFilial("PA7")+"' AND PA7_CODLIN = PC1_LINHA AND PA7.D_E_L_E_T_ = ' ' "
_cQuery 	+= "INNER JOIN " + RetSqlName("PC2") + " PC2 ON "
_cQuery 	+= "PC2_FILIAL = PC0_FILIAL AND PC2_NUMSEQ = PC0_NUMSEQ AND PC2.D_E_L_E_T_ = ' ' "
_cQuery 	+= "WHERE PC0_FILIAL = '" + xFilial("PC0") + "' "
_cQuery 	+= "AND PC0_DTENTR >= '" + dTos(dMAntIni) + "' "
_cQuery 	+= "AND PC0_DTENTR <= '" + dTos(dMAntFim) + "' "
_cQuery 	+= "AND PC1_CODPRO >= '" + MV_PAR02 + "' "
_cQuery 	+= "AND PC1_CODPRO <= '" + MV_PAR03 + "' "
_cQuery 	+= "AND PA7_CODLIN >= '" + MV_PAR04 + "' "
_cQuery 	+= "AND PA7_CODLIN <= '" + MV_PAR05 + "' "
_cQuery 	+= "AND PC0.PC0_TPENTR = '1' "
_cQuery 	+= "AND PC0.D_E_L_E_T_ = ' ' "
_cQuery 	+= "Group By PC1_LINHA, PC1_CODPRO "

If Select("QRY") > 0
	dbSelectArea("QRY")
	dbCloseArea()
Endif
_cQuery := ChangeQuery(_cQuery) 

memowrit("wm004C.sql", _cQuery)

DbUseArea(.T.,'TOPCONN',TCGENQRY(,,_cQuery),"QRY",.T.,.T.)

tcSetField("QRY", "QTDLIT", "N", 12, 2 )
tcSetField("QRY", "VLRLIT", "N", 10, 4 )
tcSetField("QRY", "QTDDIA", "N", 10, 2 )

If QRY->(!EOF())
	ProcRegua(20)
	While QRY->(!EOF())
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
_cQuery 	+= "INNER JOIN " + RetSqlName("PC2") + " PC2 ON "
_cQuery 	+= "PC2_FILIAL = PC0_FILIAL AND PC2_NUMSEQ = PC0_NUMSEQ AND PC2.D_E_L_E_T_ = ' ' "
_cQuery 	+= "WHERE PC0_FILIAL = '" + xFilial("PC0") + "' "
_cQuery 	+= "AND PC0_DTENTR >= '" + dTos(dDataIni) + "' "
_cQuery 	+= "AND PC0_DTENTR <= '" + dTos(dDataFim) + "' "
_cQuery 	+= "AND PC1_CODPRO >= '" + MV_PAR02 + "' "
_cQuery 	+= "AND PC1_CODPRO <= '" + MV_PAR03 + "' "
_cQuery 	+= "AND PA7_CODLIN >= '" + MV_PAR04 + "' "
_cQuery 	+= "AND PA7_CODLIN <= '" + MV_PAR05 + "' "
_cQuery 	+= "AND PC0.PC0_TPENTR = '1' "
_cQuery 	+= "AND PC0.D_E_L_E_T_ = ' ' "
_cQuery 	+= "Group By PC1_LINHA, PC1_CODPRO "
_cQuery 	+= "Order By PC1_LINHA, PC1_CODPRO "


aadd(aRestr, {"PC1", "PC1_LINHA" , "PC1_LINHA", 	""})
aadd(aRestr, {"PC1", "PC1_CODPRO", "PC1_CODPRO", 	"" })
aadd(aRestr, {"PC1", "PC1_QTDLIT", "QTDDIA1", 		"Media Ant."})
aadd(aRestr, {"PC1", "PC1_QTDLIT", "MESANT", 		"Vol.Mes Ant."})
aadd(aRestr, {"PC1", "PC1_QTDLIT", "QTDLIT", 		""})
aadd(aRestr, {"PC1", "PC1_QTDLIT", "QTDDIA", 		"Media Dia"})
aadd(aRestr, {"PC1", "PC1_VLRLIT", "VLRLIT",		""})
aadd(aRestr, {"PC1", "PC1_VLRLIT", "VLRNOVO", 		"Novo Valor"})
aadd(aRestr, {"LBB", "LBB_NOMFOR", "LBB_NOMFOR", 	"" })
aadd(aRestr, {"LBB", "LBB_DESC" ,  "LBB_DESC", 	""})

aHeader := MntaHead( aRestr )

If Select("QRY") > 0
	dbSelectArea("QRY")
	dbCloseArea()
Endif
_cQuery := ChangeQuery(_cQuery) 

memowrit("wm004A.sql", _cQuery)

DbUseArea(.T.,'TOPCONN',TCGENQRY(,,_cQuery),"QRY",.T.,.T.)

tcSetField("QRY", "QTDLIT", "N", 12, 2 )
tcSetField("QRY", "VLRLIT", "N", 10, 4 )
tcSetField("QRY", "QTDDIA", "N", 10, 2 )

If QRY->(!EOF())
	ProcRegua(20)
	While QRY->(!EOF())
		IncProc("Processando...")
		dbSelectArea("LBB")
		dbSetOrder(1)
		dbSeek( xFilial("LBB") + QRY->PC1_CODPRO )
		
		nPOs	:= ascan(aMesAnt, { |x| alltrim(Upper(x[1]+x[2])) == alltrim(Upper(QRY->(PC1_LINHA+PC1_CODPRO))) })
		
		aadd(aTemp, QRY->PC1_LINHA)
		aadd(aTemp, QRY->PC1_CODPRO)
		aadd(aTemp, Iif(nPos>0,aMesAnt[nPos][4], 0))
		aadd(aTemp, Iif(nPos>0,aMesAnt[nPos][3], 0))
		aadd(aTemp, QRY->QTDLIT)
		aadd(aTemp, QRY->QTDLIT / nQtdDia)
		aadd(aTemp, QRY->VLRLIT)
		aadd(aTemp, Iif(nPos>0.and.lImpMes,aMesAnt[nPos][5], 0) )
		aadd(aTemp, LBB->LBB_NOMFOR)
		aadd(aTemp, LBB->LBB_DESC)
		aadd(aTemp, .F.)
		
        aadd(aCols, aTemp)
        aTemp := {}
		QRY->(DbSkip())
	EndDo
	QRY->( dbCloseArea() )

	aAlter := {}
	aadd(aAlter, "VLRNOVO" )	
	_Mytela(4, aHeader, aCols, aAlter)

Else
	Alert("Não existem registros para atualização do Preço do Leite.")
	QRY->( dbCloseArea() )
EndIf
    

Return Nil


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

Static Function _Mytela(nOpc, aHeadL, aColL, aAlter)
Local aObjects 	:= {}
Local aSize 	:= {}
Local aInfo		:= {}
Local aPosObj	:= {}
Local nMax		:= 0

// objetos da tela
Local oDlgGet	
Local oLinha
Local oDescr

//Variaveis do relatorio
Local cTitulo 	:= OemToAnsi("Acerto Valor Leite")
Local cTudOk 	:= "AlwaysTrue"
Local cLinOk 	:= "AlwaysTrue"
Local nOpca 	:= GD_UPDATE	//GD_INSERT+GD_DELETE+GD_UPDATE
Local nOpcGet	:= 0
Local nMax		:= 99

Private oGetd

aSize := MsAdvSize()

AAdd( aObjects, { 070, 100, .T., .T. } )

aInfo		:= { aSize[1], aSize[2], aSize[3], aSize[4], 0, 0 }

aPosObj := MsObjSize( aInfo, aObjects,.T.)

//-- Define as posicoes da getdados a partir do folder.
nGd1 := aPosObj[1,1]
nGd2 := aPosObj[1,2]
nGd3 := aPosObj[1,3]
nGd4 := aPosObj[1,4]


DEFINE MSDIALOG oDlgGet FROM aSize[7],00 TO aSize[6],aSize[5] TITLE cTitulo PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Getdados para lancamentos de varios itens por inclusao 				    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetD:= MsNewGetDados():New(nGd1, nGd2,nGd3,nGd4,nOpcA,cLinOk,cTudOk,/*/cIniCpos/*/,aAlter,/*/nFreeze/*/,nMax,/*/cFieldOk/*/,/*/cSuperDel/*/,/*/cDelOk/*/,oDlgGet,aHeadl,aColL)

oGetD:oBrowse:bEditCol  :={ ||oGetD:oBrowse:GoRight(),oGetD:LinhaOk()}

ACTIVATE MSDIALOG oDlgGet ON INIT EnchoiceBar(oDlgGet,{||IIf(oGetD:TudoOk(),(nOpcGet:= 1,aColL:=oGetD:aCols,oDlgGet:End()),.T.)},{|| oDlgGet:End(), nOpcGet:= 0 })

If nOpcGet == 1
	Qta074Gr( aHeadl, aColL, aAlter )
Endif                       

Return( Iif(nOpcGet == 1, .T., .F.) )




Static Function Qta074Gr( aHeadl, aColL, aAlter )
Local nXb 		:= 0
Local nPosPrec  := 0
Local nPosProd  := 0

nPosPrec := Ascan( aHeadl, {|x| Alltrim(Upper(x[2])) == "VLRNOVO" } )
nPosProd := Ascan( aHeadl, {|x| Alltrim(Upper(x[2])) == "PC1_CODPRO" } )

If !Empty(nPosPrec) .and. !Empty(nPosProd)
	For nXb := 1 to Len(aColL)
		If !Empty(aColL[nXb][nPosPrec])
			aTUALPRC(	aColL[nXb][nPosPrec], AcolL[nXb][nPosProd] )
		Endif
	Next nXb
Endif
Return Nil
                                                         

Static Function AtualPRC( _nPreco, _cCodPro )
Local dDataIni 	:= cTod("01" + "/" + Left(MV_PAR01,2) + "/" + substr(MV_PAR01,3))
Local dDataFim 	:= LastDay(dDataIni)
LOcal nQtdDia	:= (dDataFim - dDataIni) + 1
Local _cQuery	:= ""

_cQuery 	:= "SELECT PC0.R_E_C_N_O_ as PC0NUM, PC1.R_E_C_N_O_ as PC1NUM, PC2.R_E_C_N_O_ as PC2NUM "
_cQuery 	+= "FROM " + RetSqlName("PC0") + " PC0 INNER JOIN " + RetSqlName("PC1") + " PC1 ON "
_cQuery 	+= "PC1_FILIAL = PC0_FILIAL AND PC1_NUMSEQ = PC0_NUMSEQ AND PC1.D_E_L_E_T_ = ' ' "
_cQuery 	+= "INNER JOIN " + RetSqlName("PA7") + " PA7 ON "
_cQuery 	+= "PA7_FILIAL = '"+xFilial("PA7")+"' AND PA7_CODLIN = PC1_LINHA AND PA7.D_E_L_E_T_ = ' ' "
_cQuery 	+= "INNER JOIN " + RetSqlName("PC2") + " PC2 ON "
_cQuery 	+= "PC2_FILIAL = PC0_FILIAL AND PC2_NUMSEQ = PC0_NUMSEQ AND PC2.D_E_L_E_T_ = ' ' "
_cQuery 	+= "INNER JOIN " + RetSqlName("LBC") + " LBC ON "
_cQuery 	+= "LBC_FILIAL = '"+xFilial("LBC")+"' AND LBC_CODROT = PC2_ROTA AND LBC.D_E_L_E_T_ = ' ' "
_cQuery 	+= "WHERE PC0_FILIAL = '" + xFilial("PC0") + "' "
_cQuery 	+= "AND PC0_DTENTR >= '" + dTos(dDataIni) + "' "
_cQuery 	+= "AND PC0_DTENTR <= '" + dTos(dDataFim) + "' "
_cQuery 	+= "AND PC1_CODPRO = '" + _cCodPro + "' "
_cQuery 	+= "AND PC0.PC0_TPENTR = '1' "
_cQuery 	+= "AND PC0.D_E_L_E_T_ = ' ' "
_cQuery 	+= "AND PC0.D_E_L_E_T_ = ' ' "

If Select("QRY") > 0
	dbSelectArea("QRY")
	dbCloseArea()
Endif
_cQuery := ChangeQuery(_cQuery) 

memowrit("C:\HD\wm004b.sql", _cQuery)

DbUseArea(.T.,'TOPCONN',TCGENQRY(,,_cQuery),"QRY",.T.,.T.)

tcSetField("QRY", "PC0NUM", "N", 10, 0 )
tcSetField("QRY", "PC1NUM", "N", 10, 0 )
tcSetField("QRY", "PC2NUM", "N", 10, 0 )

If QRY->(!EOF())
	ProcRegua(20)
	While QRY->(!EOF())
		IncProc("Processando...")
		PC1->(dbGoTo(QRY->PC1NUM))
		RecLock("PC1",.F.)
		PC1->PC1_VLRLIT := _nPreco
		PC1->(MSUnlock())
		PC2->(dbGoTo(QRY->PC2NUM))
		RecLock("PC2",.F.)
		PC2->PC2_VLRLIT := _nPreco
		PC2->(MSUnlock())
		QRY->(DbSkip())
	EndDo
//	MsgInfo("Preços atualizados com sucesso.")

Else
	Alert("Não existem registros para atualização do Preço do Leite.")
EndIf
QRY->( dbCloseArea() )
    


Return Nil

