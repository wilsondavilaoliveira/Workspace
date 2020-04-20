#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH" 

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � QUAA074  � Autor � Andreia J da Silva � Data �  30/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualizacao do Preco final do Leite na Entrada de Leite.	  ���
�������������������������������������������������������������������������͹��
���Uso       � QUATA	                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function QUAA074()
Local cPerg    := "QUA074"
Local cNomArq  := ""  
Local lRet	   := .F.    
Local aSay          := {}
Local aButton       := {}
Local lOK		:= .F.

Private cCadastro   := "Atualiza��o de Pre�o Final do Leite"
AjustaSx1(cPerg)

If Pergunte(cPerg,.T.)
	//��������������������������������������������Ŀ
	//�MV_PAR01 - Entrada De                       �
	//�MV_PAR02 - Entrada Ate                      �
	//�MV_PAR03 - Produtor De                      �
	//�MV_PAR04 - Produtor Ate                     �
	//�MV_PAR05 - Rota De                          �
	//�MV_PAR06 - Rota Ate                         �
	//�MV_PAR07 - Carreteiro De                    �
	//�MV_PAR08 - Carreteiro Ate                   �
	//�MV_PAR09 - Novo Valor                       �
	//����������������������������������������������  

	aAdd(aSay,"Esta rotina tem por objetivo atualizar o pre�o a ser pago por litro de leite")
	aAdd(aSay,"para os produtores que j� tiverem seu leite lan�ado no latic�nio.")
	
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

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �AjustaSX1 � Autor �  Andreia J Silva      � Data �30/06/08  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta perguntas no SX1.                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function AjustaSx1(cPerg)
cPerg := Left(cPerg,6)

PutSx1(cPerg,"01","Entrada De?" ,"","","mv_ch1","D",08,0,0,"G","", "", " ", " ","mv_par01")
PutSX1(cPerg,"02","Entrada At�?","","","mv_ch2","D",08,0,0,"G","","","","", "mv_par02")

PutSx1(cPerg,"03","Produtor De?" ,"","?","mv_ch3","C",06,0,0,"G","", "LBB", " ", " ","mv_par03")
PutSX1(cPerg,"04","Produtor At�?"," ","","mv_ch4","C",06,0,0,"G","","LBB","","", "mv_par04")

PutSx1(cPerg,"05","Rota De?" ,"","","mv_ch5","C",06,0,0,"G","","LBC","","","mv_par05")
PutSX1(cPerg,"06","Rota At�?","","","mv_ch6","C",06,0,0,"G","","LBC","","","mv_par06")

PutSx1(cPerg,"07","Linha De?" ,"","","mv_ch7","C",06,0,0,"G","", "PA7", " ", " ","mv_par07")
PutSx1(cPerg,"08","Linha At�?","","","mv_ch8","C",06,0,0,"G","", "PA7", " ", " ","mv_par08")

PutSx1(cPerg,"09","Carreteiro De?" ,"","","mv_ch9","C",06,0,0,"G","", "LBE", " ", " ","mv_par09")
PutSx1(cPerg,"10","Carreteiro At�?","","","mv_cha","C",06,0,0,"G","", "LBE", " ", " ","mv_par10")

PutSx1(cPerg,"11","Volume De?" ,"","","mv_chb","N",07,0,0,"G","", "", " ", " ","mv_par11")
PutSx1(cPerg,"12","Volume At�?","","","mv_chc","N",07,0,0,"G","", "", " ", " ","mv_par12")

PutSx1(cPerg,"13","Processa?","","","mv_chd","N",01,0,0,"C","", " ", " ", " ","mv_par13","Linhas"	,"","",""			,"Rotas"," "," ","Ambos","","","","","","","" )

PutSx1(cPerg,"14","Novo Valor?","","","mv_che","N",08,04,0,"G","", "", " ", " ","mv_par14")

Return   
                             
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ProQRY   �Autor  �Andreia J da Silva   � Data �  30/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao que chama a montagem da Query.                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � QUATA                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function ProQRY()

Processa( {||U_QUAA074I()},"Aguarde...","Atualizando o Pre�o do Leite.", .T. )

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �QUAA074I  �Autor  �Microsiga           � Data �  30/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Montagem da Query e atualiza o campo LBO_VALOR             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � QUATA                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
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
//	MsgInfo("Pre�os atualizados com sucesso.")

Else
	Alert("N�o existem registros para atualiza��o do Pre�o do Leite.")
EndIf
QRY->( dbCloseArea() )
    

Return