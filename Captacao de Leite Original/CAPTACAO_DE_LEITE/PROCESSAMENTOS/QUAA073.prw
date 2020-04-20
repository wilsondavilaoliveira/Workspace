#include "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ QUAA073  º Autor ³ wmanfre                   ³  10/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualizacao do volume do Leite na Entrada de Leite.	      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QUATA	                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function QUAA073()
Local cPerg    := "QUA073"
Local cNomArq  := ""  
Local lRet	   := .F.    
Local aSay          := {}
Local aButton       := {}
Private cCadastro   := "Atualização de Volume do Leite"
AjustaSx1(cPerg)

If Pergunte(cPerg,.T.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³MV_PAR01 - Entrada De                       ³
	//³MV_PAR02 - Entrada Ate                      ³
	//³MV_PAR03 - Produtor De                      ³
	//³MV_PAR04 - Produtor Ate                     ³
	//³MV_PAR05 - Linha De                          ³
	//³MV_PAR06 - Linha Ate                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

	aAdd(aSay,"Esta rotina tem por objetivo atualizar o volume de leite")
	aAdd(aSay,"para os produtores que já tiverem seu leite lançado no laticínio.")
	
	aAdd(aButton, { 5,.T.,{|| Pergunte( cPerg, .T. )}})//Parametros
	aAdd(aButton, { 1,.T.,{||ProQRY()				}})//OK
	aAdd(aButton, { 2,.T.,{|| FechaBatch()          }})//Cancelar
	
	FormBatch(cCadastro,aSay,aButton) 	
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

PutSx1(cPerg,"03","Produtor De?" ,"","?","mv_ch3","C",06,0,0,"G","", "LBOPRO", " ", " ","mv_par03")
PutSX1(cPerg,"04","Produtor Até?"," ","","mv_ch4","C",06,0,0,"G","","LBOPRO","","", "mv_par04")

PutSx1(cPerg,"05","Linha De?" ,"","","mv_ch5","C",06,0,0,"G","","PA7","","","mv_par05")
PutSX1(cPerg,"06","Liha Até?","","","mv_ch6","C",06,0,0,"G","","PA7","","","mv_par06")


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

Processa( {||U_QUAA073I()},"Aguarde...","Atualizando o volume do Leite.", .T. )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAA073I  ºAutor  ³Microsiga           º Data ³  30/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Montagem da Query e atualiza o campo LBO_VALOR             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QUATA                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function QUAA073I()
Local _cQuery  := ""

//_cQuery  := " SELECT LBO_DATENT, LBO_CODPRO, LBO.R_E_C_N_O_ RECNOLBO, LBB_CODPRO, LBB_LINHA, PA7_CODLIN, PA7_CODCAR, LBD_CODROT, "
//_cQuery  += " LBO_QUANT, LBE_CODCAM "
_cQuery  := " SELECT LBO_CODPRO, SUM(LBO_QUANT) QTDPER "
_cQuery  += " FROM "
_cQuery  +=   RetSqlName("LBO") + " LBO, "
_cQuery  +=   RetSqlName("LBB") + " LBB, " 
_cQuery  +=   RetSqlName("LBC") + " LBC, " 
_cQuery  +=   RetSqlName("LBD") + " LBD, "
_cQuery  +=   RetSqlName("LBE") + " LBE, "
_cQuery  +=   RetSqlName("PA7") + " PA7 "
_cQuery  += " WHERE "
_cQuery  += " LBO.D_E_L_E_T_ = ' ' "
_cQuery  += " AND LBB.D_E_L_E_T_ = ' ' "
_cQuery  += " AND LBC.D_E_L_E_T_ = ' ' "
_cQuery  += " AND LBD.D_E_L_E_T_ = ' ' "
_cQuery  += " AND LBE.D_E_L_E_T_ = ' ' "
_cQuery  += " AND PA7.D_E_L_E_T_ = ' ' "
_cQuery  += " AND LBB_CODPRO = LBO_CODPRO " 
_cQuery  += " AND LBD_CODPRO = LBO_CODPRO "
_cQuery  += " AND PA7_CODLIN = LBB_LINHA  " 
_cQuery  += " AND LBE_CODCAM = PA7_CODCAR " 
_cQuery  += " AND LBC_CODCAM = PA7_CODCAR " 
_cQuery  += " AND LBO_DATENT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
_cQuery  += " AND LBO_CODPRO BETWEEN '"+AllTrim(MV_PAR03)+"' AND '"+AllTrim(MV_PAR04)+"'"
_cQuery  += " AND LBC_CODROT BETWEEN '"+AllTrim(MV_PAR05)+"' AND '"+AllTrim(MV_PAR06)+"'"
_cQuery  += " GROUP BY LBO_CODPRO "
_cQuery  += " ORDER LBO_CODPRO "

_cQuery := ChangeQuery(_cQuery) 
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,_cQuery),"QRY",.T.,.T.)
TcSetField( "QRY","QTDPER","N",TamSX3("LBO_VOLANT")[1],TamSX3("LBO_VOLANT")[2])

If QRY->(!EOF())
	ProcRegua(20)
	While QRY->(!EOF())
		IncProc("Processando...")
		dbSelectArea("LBB")
		dbSetOrder(1)
		If dbSeek( xFilial("LBB") + QRY->LBO_CODPRO )
			RecLock("LBB",.F.)
			LBB->LBB_VOLANT := QRY->QTDPER
			MSUnlock()
		Endif
		dbSelectArea("QRY")
		QRY->(DbSkip())
	EndDo
	MsgInfo("volumes atualizados com sucesso.")
Else
	Alert("Não existem registros para atualização do volume do Leite.")
EndIf
QRY->( dbCloseArea() )

Return