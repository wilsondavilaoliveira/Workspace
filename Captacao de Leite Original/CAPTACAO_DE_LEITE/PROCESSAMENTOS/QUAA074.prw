#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH" 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ QUAA074  º Autor ³ Andreia J da Silva º Data ³  30/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualizacao do Preco final do Leite na Entrada de Leite.	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QUATA	                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function QUAA074()
Local cPerg    := "QUA074"
Local cNomArq  := ""  
Local lRet	   := .F.    
Local aSay          := {}
Local aButton       := {}
Local lOK		:= .F.

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
	
	aAdd(aButton, { 5,.T.,{|| Pergunte( cPerg, .T. ) 	}})//Parametros
//	aAdd(aButton, { 1,.T.,{|| lOk := .T., FechaBatch()	}})//OK
	aAdd(aButton, { 1,.T.,{|| ProQRY()	}})//OK
	aAdd(aButton, { 2,.T.,{|| FechaBatch()           	}})//Cancelar
	
	FormBatch(cCadastro,aSay,aButton) 	
	
/*
	If lOk
		ProQRY()
	Endif       
*/
EndIf

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

PutSx1(cPerg,"01","Entrada De?" ,"","","mv_ch1","D",08,0,0,"G","", "", " ", " ","mv_par01")
PutSX1(cPerg,"02","Entrada Até?","","","mv_ch2","D",08,0,0,"G","","","","", "mv_par02")

PutSx1(cPerg,"03","Produtor De?" ,"","?","mv_ch3","C",06,0,0,"G","", "LBB", " ", " ","mv_par03")
PutSX1(cPerg,"04","Produtor Até?"," ","","mv_ch4","C",06,0,0,"G","","LBB","","", "mv_par04")

PutSx1(cPerg,"05","Rota De?" ,"","","mv_ch5","C",06,0,0,"G","","LBC","","","mv_par05")
PutSX1(cPerg,"06","Rota Até?","","","mv_ch6","C",06,0,0,"G","","LBC","","","mv_par06")

PutSx1(cPerg,"07","Linha De?" ,"","","mv_ch7","C",06,0,0,"G","", "PA7", " ", " ","mv_par07")
PutSx1(cPerg,"08","Linha Até?","","","mv_ch8","C",06,0,0,"G","", "PA7", " ", " ","mv_par08")

PutSx1(cPerg,"09","Carreteiro De?" ,"","","mv_ch9","C",06,0,0,"G","", "LBE", " ", " ","mv_par09")
PutSx1(cPerg,"10","Carreteiro Até?","","","mv_cha","C",06,0,0,"G","", "LBE", " ", " ","mv_par10")

PutSx1(cPerg,"11","Volume De?" ,"","","mv_chb","N",07,0,0,"G","", "", " ", " ","mv_par11")
PutSx1(cPerg,"12","Volume Até?","","","mv_chc","N",07,0,0,"G","", "", " ", " ","mv_par12")

PutSx1(cPerg,"13","Processa?","","","mv_chd","N",01,0,0,"C","", " ", " ", " ","mv_par13","Linhas"	,"","",""			,"Rotas"," "," ","Ambos","","","","","","","" )

PutSx1(cPerg,"14","Novo Valor?","","","mv_che","N",08,04,0,"G","", "", " ", " ","mv_par14")

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

Processa( {||U_QUAA074I()},"Aguarde...","Atualizando o Preço do Leite.", .T. )

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
User Function QUAA074I()
_cQuery  := ""
_cQuery 	:= "SELECT PC0.R_E_C_N_O_ as PC0NUM, PC1.R_E_C_N_O_ as PC1NUM, PC2.R_E_C_N_O_ as PC2NUM " + CRLF
_cQuery 	+= "FROM " + RetSqlName("PC0") + " PC0 INNER JOIN " + RetSqlName("PC1") + " PC1 ON " + CRLF
_cQuery 	+= "PC1_FILIAL = PC0_FILIAL AND PC1_NUMSEQ = PC0_NUMSEQ AND PC1.D_E_L_E_T_ = ' ' " + CRLF
_cQuery 	+= "INNER JOIN " + RetSqlName("PA7") + " PA7 ON " + CRLF
_cQuery 	+= "PA7_FILIAL = '"+xFilial("PA7")+"' AND PA7_CODLIN = PC1_LINHA AND PA7.D_E_L_E_T_ = ' ' " + CRLF
_cQuery 	+= "INNER JOIN " + RetSqlName("PC2") + " PC2 ON " + CRLF
_cQuery 	+= "PC2_FILIAL = PC0_FILIAL AND PC2_NUMSEQ = PC0_NUMSEQ AND PC2.D_E_L_E_T_ = ' ' " + CRLF
_cQuery 	+= "INNER JOIN " + RetSqlName("LBC") + " LBC ON " + CRLF
_cQuery 	+= "LBC_FILIAL = '"+xFilial("LBC")+"' AND LBC_CODROT = PC2_ROTA AND LBC.D_E_L_E_T_ = ' ' " + CRLF
_cQuery 	+= "WHERE PC0_FILIAL = '" + xFilial("PC0") + "' " + CRLF
_cQuery 	+= "AND PC0_DTENTR >= '" + dTos(MV_PAR01) + "' " + CRLF
_cQuery 	+= "AND PC0_DTENTR <= '" + dTos(MV_PAR02) + "' " + CRLF
_cQuery 	+= "AND PC1_CODPRO >= '" + MV_PAR03 + "' " + CRLF
_cQuery 	+= "AND PC1_CODPRO <= '" + MV_PAR04 + "' " + CRLF

If MV_PAR13 == 1 .or. MV_PAR13 == 3
	_cQuery 	+= "AND PA7_CODLIN >= '" + MV_PAR07 + "' " + CRLF
	_cQuery 	+= "AND PA7_CODLIN <= '" + MV_PAR08 + "' " + CRLF
	_cQuery 	+= "AND PA7_CODCAR >= '" + MV_PAR09 + "' " + CRLF
	_cQuery 	+= "AND PA7_CODCAR <= '" + MV_PAR10 + "' " + CRLF
Endif

If MV_PAR13 == 2 .or. MV_PAR13 == 3
	_cQuery 	+= "AND LBC_CODROT >= '" + MV_PAR05 + "' " + CRLF
	_cQuery 	+= "AND LBC_CODROT <= '" + MV_PAR06 + "' " + CRLF
	_cQuery 	+= "AND LBC_CODCAM >= '" + MV_PAR09 + "' " + CRLF
	_cQuery 	+= "AND LBC_CODCAM <= '" + MV_PAR10 + "' " + CRLF
Endif

_cQuery 	+= "AND PC1_CODPRO IN ( " + CRLF
_cQuery 	+= "Select B.PC1_CODPRO from ( " + CRLF
_cQuery 	+= "select PC1_CODPRO, SUM(PC1_QTDLIT) as TOTALQT " + CRLF
_cQuery 	+= "from " + RetSqlName("PC1") + " PC1 Inner Join " + RetSqlName("PC0") + " PC0 ON " + CRLF
_cQuery 	+= "PC1_FILIAL = PC0_FILIAL and PC1_NUMSEQ = PC0_NUMSEQ AND PC1.D_E_L_E_T_ = ' ' AND PC0.D_E_L_E_T_ = ' ' " + CRLF
_cQuery 	+= "WHERE PC0_FILIAL = '" + xFilial("PC0") + "' " + CRLF
_cQuery 	+= "AND PC0_DTENTR >= '" + dTos(MV_PAR01) + "' " + CRLF
_cQuery 	+= "AND PC0_DTENTR <= '" + dTos(MV_PAR02) + "' " + CRLF
_cQuery 	+= "AND PC0_TPENTR = '1' " + CRLF
_cQuery 	+= "Group By PC1_CODPRO " + CRLF
_cQuery 	+= ") AS  B " + CRLF
_cQuery 	+= "Where B.TOTALQT Between " + Alltrim(Str(MV_PAR11)) + " AND " + Alltrim(Str(MV_PAR12)) + " " + CRLF
_cQuery 	+= ") " + CRLF

If Select("QRY") > 0
	dbSelectArea("QRY")
	dbCloseArea()
Endif
//_cQuery := ChangeQuery(_cQuery) 

memowrit("C:\HD\wm004.sql", _cQuery)
memowrit("wm004.sql", _cQuery)

DbUseArea(.T.,'TOPCONN',TCGENQRY(,,_cQuery),"QRY",.T.,.T.)

tcSetField("QRY", "PC0NUM", "N", 10, 0 )
tcSetField("QRY", "PC1NUM", "N", 10, 0 )
tcSetField("QRY", "PC2NUM", "N", 10, 0 )

If QRY->(!EOF())
	ProcRegua(20)
	While QRY->(!EOF())
		IncProc("Processando...")
		IF MV_PAR13 == 1 .or. MV_PAR13 == 3
			PC1->(dbGoTo(QRY->PC1NUM))
			RecLock("PC1",.F.)
			PC1->PC1_VLRLIT := MV_PAR14
			PC1->(MSUnlock())
		Endif
		IF MV_PAR13 == 2 .or. MV_PAR13 == 3
			PC2->(dbGoTo(QRY->PC2NUM))
			RecLock("PC2",.F.)
			PC2->PC2_VLRLIT := MV_PAR14
			PC2->(MSUnlock())
		Endif
		QRY->(DbSkip())
	EndDo
//	MsgInfo("Preços atualizados com sucesso.")

Else
	Alert("Não existem registros para atualização do Preço do Leite.")
EndIf
QRY->( dbCloseArea() )
    

Return