#INCLUDE "QUAA015.CH"
#INCLUDE "PROTHEUS.CH" 
#INCLUDE "RWMAKE.CH" 
#INCLUDE 'COLORS.CH' 
#INCLUDE "TOPCONN.CH"  
#INCLUDE "PRCONST.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "TbiConn.ch"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"                                      
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

/*
����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � QUAA015  � Autor � Ricardo Berti         � Data � 04.11.05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Manutencao Tab.Criterios para Valorizacao da Qualidade      ���
���          �Sao 4 tabelas basicas(em vigor): GORDURA,PROTEINA,CBT,CCS   ���
���          �Obs.: chave exclusiva = LJY_CODBON + LJY_TIPOL			  ���
���          �      ou seja, podemos ter o mesmo codigo em 2 tabelas:	  ���
���          �      uma para cada tipo de leite.                          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � QUAA015()                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function QUAA015()

U_QUAA015A()

Return

Static Function z()
//��������������������������������������������������������������Ŀ
//� Define Array contendo os campos do arquivo que sempre deverao�
//� aparecer no browse. (funcao mBrowse)                         �
//� ----------- Elementos contidos por dimensao ---------------- �
//� 1. Titulo do campo (Este nao pode ter mais de 12 caracteres) �
//� 2. Nome do campo a ser editado                               �
//����������������������������������������������������������������

LOCAL aFixe := { 	{ OemToAnsi(STR0007),"LJY_CODBON" },;		 //"C�digo"
					{ OemToAnsi(STR0008),"LJY_TIPOL"  },;		 //"Leite"
					{ OemToAnsi(STR0009),"LJY_VINIC"  },;		 //"De"
					{ OemToAnsi(STR0010),"LJY_VFINAL" },;		 //"At�"
					{ OemToAnsi(STR0011),"LJY_VRESUL" },;		 //"R$/Litro"
					{ OemToAnsi(STR0012),"LJY_DTATU"  },;		 //"Ult.Atualiz."
					{ OemToAnsi(STR0014),"LJY_DESQUA"  } }		 //"Descricao Tab."

//��������������������������������������������������������������Ŀ
//� Define Array contendo as Rotinas a executar do programa      �
//� ----------- Elementos contidos por dimensao ------------     �
//� 1. Nome a aparecer no cabecalho                              �
//� 2. Nome da Rotina associada                                  �
//� 3. Usado pela rotina                                         �
//� 4. Tipo de Transa��o a ser efetuada                          �
//�    1 - Pesquisa e Posiciona em um Banco de Dados             �
//�    2 - Simplesmente Mostra os Campos                         �
//�    3 - Inclui registros no Bancos de Dados                   �
//�    4 - Altera o registro corrente                            �
//�    5 - Remove o registro corrente do Banco de Dados          �
//����������������������������������������������������������������
Private cCadastro := OemtoAnsi(STR0001)	 //"Crit�rios para Valoriza��o da Qualidade do Leite"

Private aRotina := {{OemToAnsi(STR0002),'AxPesqui' ,0,1},; //'Pesquisar'
 					{OemToAnsi(STR0003),'u_Quaa15Man',0,2},; //'Visualizar'
					{OemToAnsi(STR0004),'u_Quaa15Man',0,3},; //'Incluir'
					{OemToAnsi(STR0005),'u_Quaa15Man',0,4},; //'Alterar'
					{OemToAnsi(STR0006),'u_Quaa15Man',0,5} } //'Excluir'

//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//� Obs.: O parametro aFixe nao e' obrigatorio e pode ser omitido�
//����������������������������������������������������������������
mBrowse( 6, 1,22,75,"LJY",aFixe,NIL,NIL,NIL,NIL,NIL) // aCores

dbSelectArea("LJY")
dbSetOrder(1)
dbClearFilter()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Quaa15Man � Autor �Ricardo Berti          � Data �04.11.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Manutencao da tabela de Criterio de Valoriz.p/Qualidade     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Alias do arquivo                                     ���
���          �ExpN2: Registro do Arquivo                                  ���
���          �ExpN3: Opcao da MBrowse                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Template Leite - COL_LEI                                   ���
�������������������������������������������������������������������������Ĵ��
��� DATA     � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Quaa15Man(cAlias,nRecno,nOpc)

Local aArea    := GetArea()
Local aSizeAut	:= {}
Local aRegLJY  := {}
Local aObjects	:= {}
Local aInfo 	:= {}
Local aPosGet	:= {}
Local aPosObj	:= {}

Local nOpcA    	:= 0
Local nCntFor  	:= 0
Local nPItem    := 0
Local nUsado   	:= 0

// Local cTexto1   := ""
// Local cTexto2   := ""

Local oDlg
Local oGetD
Local nI

Private aHeader := {}
Private aCols   := {}
Private oSay1
Private oSay2

//������������������������������������������������������Ŀ
//� Montagem do aHeader.                                 �
//��������������������������������������������������������
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("LJY")

While !Eof() .And. SX3->X3_ARQUIVO == "LJY"
	If X3Uso(SX3->X3_USADO) .And. SX3->X3_CAMPO != "LJY_CODBON" .And.;
		SX3->X3_CAMPO != "LJY_DESQUA" .And.;
		SX3->X3_CAMPO != "LJY_TIPOL" .And.;
		SX3->X3_CAMPO != "LJY_DTATU" .And.;
		SX3->X3_CAMPO != "LJY_PAGA" .And.;
		SX3->X3_CAMPO != "LJY_ORDEM" .And.;
		cNivel >= SX3->X3_NIVEL
		
		nUsado++
		Aadd(aHeader,{ AllTrim(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )
		If AllTrim(SX3->X3_CAMPO)=="LJY_ITEM"
			nPItem := nUsado
		EndIf
	EndIf

	dbSelectArea("SX3")
	dbSkip()
EndDo
//������������������������������������������������������Ŀ
//� Montagem do aCols.                                   �
//��������������������������������������������������������
If ( nOpc == 3 )
	M->LJY_CODBON := CriaVar("LJY_CODBON")
	M->LJY_DESQUA := CriaVar("LJY_DESQUA")
	M->LJY_TIPOL  := CriaVar("LJY_TIPOL")
	M->LJY_DTATU  := CriaVar("LJY_DTATU")
	M->LJY_PAGA	  := CriaVar("LJY_PAGA")
	M->LJY_ORDEM  := CriaVar("LJY_ORDEM")
	
	Aadd(aCols, Array(nUsado + 1))

	For nCntFor	:= 1 To Len( aHeader )
		aCols[1][nCntFor] := CriaVar( aHeader[nCntFor][2] )
	Next nCntFor
	
	aCols[1][nUsado + 1]:= .F.
 //	aCols[1][nPItem] := 1
Else
	M->LJY_CODBON	:= LJY->LJY_CODBON
	M->LJY_DESQUA	:= LJY->LJY_DESQUA
	M->LJY_TIPOL	:= LJY->LJY_TIPOL
	M->LJY_DTATU	:= LJY->LJY_DTATU
	M->LJY_PAGA		:= LJY->LJY_PAGA
	M->LJY_ORDEM	:= LJY->LJY_ORDEM
	
/*	If Empty( M->LJY_DESQUA )
		cTexto1 := Posicione("ACY",1,xFilial("ACY")+M->LJY_DESQUA,"ACY_DESCRI")
	Else
		cTexto2 := Posicione("SA1",1,xFilial("SA1")+M->LJY_TIPOL+M->LJY_DTATU,"A1_NOME")
	EndIf
*/	
	dbSelectArea("LJY")
	dbSetOrder(1)
	dbSeek( xFilial("LJY") + M->LJY_CODBON + M->LJY_TIPOL )

	nI := 0
	While !Eof() .And. xFilial("LJY") == LJY->LJY_FILIAL ;
	  .And. M->LJY_CODBON == LJY->LJY_CODBON .And. M->LJY_TIPOL == LJY->LJY_TIPOL
		RecLock("LJY",.F.)
		LJY->LJY_ITEM := ++nI
		LJY->(MsUnLock())
		Aadd(aCols, Array(nUsado + 1))
		For nCntFor	:= 1 To nUsado
			aCols[Len(aCols)][nCntFor] := FieldGet( FieldPos( aHeader[nCntFor][2] ))
		Next nCntFor
		aCols[Len( aCols )][nUsado + 1] := .F.

        aadd(aRegLJY,LJY->(RecNo()))
				
		dbSelectArea("LJY")
		dbSkip()
	EndDo
EndIf
//������������������������������������������������������Ŀ
//� Ativa a Dialog.                                      �
//��������������������������������������������������������

aSizeAut := MsAdvSize(,.F.,300) // 400

aadd(aObjects,{100,030,.T.,.F.})  
aadd(aObjects,{100,100,.T.,.T.}) 

M->LJY_CODBON := ""
aOrdCmb1 := {} 

AADD(aOrdCmb1,Alltrim(GetMv("MV_CTABGOR")))
AADD(aOrdCmb1,Alltrim(GetMv("MV_CTABPRO")))
AADD(aOrdCmb1,Alltrim(GetMv("MV_CTABCCS")))
AADD(aOrdCmb1,Alltrim(GetMv("MV_CTABCBT")))
AADD(aOrdCmb1,Alltrim(GetMv("MV_CTABVOL")))
AADD(aOrdCmb1,Alltrim(GetMv("MV_CTABDIS")))
AADD(aOrdCmb1,Alltrim(GetMv("MV_CTABTMP")))

aOrdCmb2 := {}
AADD(aOrdCmb2,"S=SIM")
AADD(aOrdCmb2,"N=NAO")

aInfo   := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
aPosObj := MsObjSize(aInfo,aObjects) 

aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{004,031,062,083,120,146}})
                                                              
DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE cCadastro OF oMainWnd PIXEL
@ aPosObj[01,01]   ,aPosGet[1,1] SAY	RetTitle("LJY_CODBON") SIZE 035,009	OF oDlg PIXEL

@ aPosObj[01,01]   ,aPosGet[1,2] COMBOBOX oCBX1 VAR M->LJY_CODBON ITEMS aOrdCmb1 SIZE 055,009 PIXEL OF oDlg WHEN INCLUI ON CHANGE U_VldCodQua() //;

@ aPosObj[01,01]   ,aPosGet[1,3] SAY 	RetTitle("LJY_DESQUA") SIZE 040,009  OF oDlg PIXEL
@ aPosObj[01,01]   ,aPosGet[1,4] MSGET M->LJY_DESQUA PICTURE "@!" 	SIZE 120,009 OF oDlg PIXEL ;
	VALID CheckSX3("LJY_DESQUA") ; // F3 CpoRetF3('LJY_DESQUA') ;
	WHEN (nOpc==3  .Or. nOpc==4 ) .And. VisualSX3("LJY_CODBON")

@ aPosObj[01,01]   ,aPosGet[1,5]+60 SAY 	RetTitle("LJY_PAGA") SIZE 040,009  OF oDlg PIXEL
@ aPosObj[01,01]   ,aPosGet[1,6]+30 COMBOBOX oCBX2 VAR M->LJY_PAGA ITEMS aOrdCmb2 SIZE 055,009 PIXEL OF oDlg WHEN .T. //ON CHANGE U_VldCodQua() //;

@ aPosObj[01,01]   ,aPosGet[1,5]+60+60+30 SAY 	RetTitle("LJY_ORDEM") SIZE 040,009  OF oDlg PIXEL
@ aPosObj[01,01]   ,aPosGet[1,6]+30+30+65 MSGET M->LJY_ORDEM PICTURE "@E 99" 	SIZE 020,009 OF oDlg PIXEL WHEN .T. VALID Iif(xOrdem(M->LJY_ORDEM)>0,.F.,.T.)//;

@ aPosObj[01,01]+14,aPosGet[1,1] SAY RetTitle("LJY_TIPOL") SIZE 040,009  OF oDlg PIXEL

M->LJY_TIPOL := 'A'

@ aPosObj[01,01]+14,aPosGet[1,2] MSGET M->LJY_TIPOL PICTURE "@!" 	SIZE 004,009 OF oDlg PIXEL WHEN .F.//;

@ aPosObj[01,01]+14,aPosGet[1,3] SAY RetTitle("LJY_DTATU") SIZE 020,009 OF oDlg PIXEL
@ aPosObj[01,01]+14,aPosGet[1,4] SAY M->LJY_DTATU SIZE 030,007 OF oDlg PIXEL // ;

//@ aPosObj[01,01]+14,aPosGet[1,5] SAY RetTitle("LJY_ATIVO") SIZE 040,009 OF oDlg PIXEL
//@ aPosObj[01,01]+14,aPosGet[1,6] MSGET M->LJY_ATIVO PICTURE "@! A" SIZE 004,009 OF oDlg PIXEL  ;
//	VALID CheckSX3("LJY_ATIVO") ;
// 	WHEN (nOpc==3  .Or. nOpc==4 ) .And. VisualSX3("LJY_CODBON")
//@ aPosObj[01,01]+14,aPosGet[1,5] SAY oSay2 PROMPT cTexto1 SIZE 120,009  OF oDlg PIXEL
//oGetd := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"Qua15LinOK","Qua15TudOk","+ACW_ITEM",.T.)

oGetd := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_Qua15LinOK","u_Qua15TudOk",,.T.)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||IIf(oGetD:TudoOk(),(nOpcA:= 1,oDlg:End()),.T.)},{||oDlg:End()})
If nOpc > 2 .And. nOpcA == 1
	//������������������������������������������������Ŀ
	//� Funcao responsavel pela atualizacao do arquivo �
	//��������������������������������������������������
//	Begin Transaction
		If Qua15Grv(nOpc-2,aRegLJY)
			If __lSx8
				ConfirmSx8()
			EndIf
			EvalTrigger()
		Else
			RollBackSx8()
		EndIf
	//End Transaction
Else
	RollBackSx8()
EndIf
//������������������������������������������������������������������������Ŀ
//� Restaura a Integridade da Tela de Entrada.                             �
//��������������������������������������������������������������������������
RestArea(aArea)
Return(.T.)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Qua15Grv  � Autor �Ricardo Berti          � Data �07.11.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de gravacao da Tab.de Criterios Valoriz. p/ Qualidade���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpL1: Indica se houve atualizacao dos dados                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Codigo de gravacao                                   ���
���          �       [1] Inclusao                                         ���
���          �       [2] Alteracao                                        ���
���          �       [3] Exclusao                                         ���
���          �ExpA2: Registros da tabela                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Qua15Grv( nOpcao , aRegLJY )

Local aArea  := GetArea()
Local lTravou:= .F.
Local lGravou:= .F.
Local nX     := 0
Local nY     := 0
Local nUsado := Len(aHeader)

DEFAULT aRegLJY := {}

If nOpcao <> 3
	For nX := 1 To Len(aCols)
		lTravou := .F.
		If nX <= Len(aRegLJY)
			LJY->(dbGoto(aRegLJY[nX]))
			RecLock("LJY")
			lTravou := .T.
		Else
			If !aCols[nX][nUsado+1]
				RecLock("LJY",.T.)
				lTravou := .T.
			Else
				lTravou := .F.
			EndIf
		EndIf
		If !aCols[nX][nUsado+1]
			lGravou := .T.
			For nY := 1 To nUsado
				If aHeader[nY][10]<>"V"
					LJY->(FieldPut( FieldPos( aHeader[nY][2] ), aCols[nX][nY] ))
				EndIf
			Next nY
			LJY->LJY_FILIAL := xFilial("LJY")
			LJY->LJY_CODBON := M->LJY_CODBON
			LJY->LJY_DESQUA := M->LJY_DESQUA
			LJY->LJY_TIPOL	:= M->LJY_TIPOL
			LJY->LJY_DTATU  := dDataBase
			LJY->LJY_PAGA	:= M->LJY_PAGA
			LJY->LJY_ORDEM	:= M->LJY_ORDEM
			MsUnLock()
		Else
			If lTravou
				LJY->(dbDelete())
			EndIf
		EndIf
	Next nX
Else
	For nX := 1 To Len(aRegLJY)
		LJY->(dbGoto(aRegLJY[nX]))
		RecLock("LJY")
		LJY->(dbDelete())
		lGravou := .T.
	Next nX
EndIf

RestArea(aArea)
Return(lGravou)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Qua15LinOk� Autor �Eduardo Riera          � Data �07.11.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Validacao da LinhaOk                                        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpL1: Indica que as informacoes sao validas                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Qua15LinOk()
 
Local nUsado     := Len(aHeader)
Local lRetorno   := .T.

Local nVInic     := GdFieldPos('LJY_VInic'  )
Local nVFinal    := GdFieldPos('LJY_VFinal' )

If !aCols[n][nUsado + 1]
//�����������������������������������������������������������������������Ŀ
//� Validacao dos campos obrigatorios.                                    �
//�������������������������������������������������������������������������
	Do Case
		Case aCols[n,nVInic] == 0 .And. aCols[n,nVFinal] == 0
			Help(" ", 1, "OBRIGAT",,RetTitle("LJY_VFINAL"))
			lRetorno := .F.
	EndCase

	If lRetorno 
		//�����������������������������������������������������������������������Ŀ
		//� Validacao dos horarios digitados                                      �
		//�������������������������������������������������������������������������
		If ( aCols[ n, nVInic ] > aCols[ n, nVFinal ] ) 
		   	MsgAlert('Conte�do em "'+Trim(RetTitle("LJY_VFINAL"))+'" deve ser maior que "'+Trim(RetTitle("LJY_VINIC"))+'"') 
		   	lRetorno := .F.
	    EndIf 
	
	EndIf 	         
	
	If lRetorno 
		//�����������������������������������������������������������������������Ŀ
		//� Validacao de duplicidade (Coluna "De" )                               �
		//�������������������������������������������������������������������������
		lRetorno := GDCheckKey( { "LJY_VINIC" }, 4 ) 		
	EndIf 

	If lRetorno 
		//�����������������������������������������������������������������������Ŀ
		//� Validacao de duplicidade (Coluna "Ate" )                               �
		//�������������������������������������������������������������������������
		lRetorno := GDCheckKey( { "LJY_VFINAL" }, 4 ) 		
	EndIf 

	If lRetorno 
		//�����������������������������������������������������������������������Ŀ
		//� Validacao de duplicidade (Coluna "R$/Litro" )                               �
		//�������������������������������������������������������������������������
		lRetorno := GDCheckKey( { "LJY_VRESUL" }, 4 ) 		
	EndIf 

	
EndIf                                

Return ( lretorno )


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Qua15TudOk� Autor �Ricardo Berti          � Data �07.11.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Validacao da TudoOk                                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpL1: Indica que as informacoes sao validas                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Qua15TudOk()

Local lRetorno := .T.
//�����������������������������������������������������������������������Ŀ
//� Validacao do cabecalho                                                �
//�������������������������������������������������������������������������	
If Empty( M->LJY_DESQUA)  .Or.  Empty( M->LJY_TIPOL ) 
	Help( " ", 1, "OBRIGAT" ) 
	lRetorno := .F. 
EndIf

Return ( lRetorno )


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Qua15Vld  � Autor �Ricardo Berti          � Data �07.11.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Validacao do cabecalho  Tab.Criterio de Valoriz.da Qualidade���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpL1: Indica se os dados preenchidos estao validos         ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Alias do arquivo                                     ���
���          �ExpN2: Registro do Arquivo                                  ���
���          �ExpN3: Opcao da MBrowse                                     ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Qua15Vld()

Local aArea    := GetArea()

Local cCampo   := ReadVar()  
Local cConteudo:= &( ReadVar() ) 

Local lRetorno := .T.

//�����������������������������������������������������������������������Ŀ
//� Verifica se cabecalho foi preenchido corretamente                     �
//�������������������������������������������������������������������������

If "LJY_TIPOL" $ cCampo
	
	If ExistChav("LJY",M->LJY_TIPOL+M->LJY_CODBON,1) .And. Inclui
	   	MsgAlert("Tabela j� existente!")
	   	lRetorno := .F.
	ElseIf ! Inclui
	   	MsgAlert("Tabela n�o encontrada!")
		//oSay2:SetText(Posicione("SA1",1,xFilial("SA1")+M->LJY_TIPOL+M->LJY_DTATU,"A1_NOME"))
		//M->LJY_DESQUA := CriaVar( "LJY_TIPOL", .T. ) 		
	   	lRetorno := .F.
	EndIf
	
EndIf 

RestArea(aArea)
Return(lRetorno)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �VldCodQua � Autor �Ricardo Berti          � Data �18.11.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Validacao do campo LJY_CODBON (COD.CRITERIO QUALIDADE)      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function VldCodQua()

Local aArea    	 := {}
Local cVarAtu 	 := ReadVar()
Local lRet   	 := .T.
Local cLista	 := ""
Local cValorCrit
Local cCriterio
Local i

If AllTrim(cVarAtu) == "M->LJY_CODBON"

	For i := 1 to 7
		Do Case
		Case i = 1
			cCriterio := "MV_CTABGOR"
		Case i = 2
			cCriterio := "MV_CTABPRO"
		Case i = 3
			cCriterio := "MV_CTABCCS"
		Case i = 4
			cCriterio := "MV_CTABCBT"
		Case i = 5
			cCriterio := "MV_CTABVOL"
		Case i = 6
			cCriterio := "MV_CTABDIS"
		Case i = 7
			cCriterio := "MV_CTABTMP"
		EndCase

		cValorCrit := SuperGetMv(cCriterio,,"")
		
		If ! Empty( cValorCrit )
			cLista += Trim(cValorCrit)+","
		EndIf
	Next

	If Empty( cLista )
	  	MsgAlert("Par�metros da Qualidade do Leite nao configurados. Verifique!")
		lRet := .F.
	ElseIf ! Trim(M->LJY_CODBON) $ cLista // so' pode digitar um codigo dos 4 parametros
	   	MsgAlert("Cod.da Tabela diferente de "+Left(cLista,Len(cLista)-1),"Verifique os PAR�METROS da Qualidade do Leite!")
		lRet := .F.
	ElseIf Inclui

		aArea	:= GetArea()
		dbSelectArea("LJY")
		dbSetOrder(1)
		If dbSeek( xFilial("LJY") + M->LJY_CODBON )
			M->LJY_DESQUA := LJY->LJY_DESQUA
		Endif
		RestArea(aArea)	
	EndIf

ElseIf AllTrim(cVarAtu) == "M->LJY_TIPOL" .And. Inclui

		aArea	:= GetArea()
		dbSelectArea("LJY")
		dbSetOrder(1)
		If dbSeek( xFilial("LJY") + M->LJY_CODBON + M->LJY_TIPOL)
		   	MsgAlert("Tabela j� existente!")
			lRet := .F.
		Endif
		RestArea(aArea)
EndIf

Return(lRet)


User Function CODQUALY()

Local cRet := ''


cRet := Alltrim(GetMv("MV_CTABGOR"))+";"
cRet += Alltrim(GetMv("MV_CTABPRO"))+";"
cRet += Alltrim(GetMv("MV_CTABCCS"))+";"
cRet += Alltrim(GetMv("MV_CTABCBT"))+";"
cRet += Alltrim(GetMv("MV_CTABVOL"))+";"
cRet += Alltrim(GetMv("MV_CTABDIS"))+";"
cRet += Alltrim(GetMv("MV_CTABTMP"))


Return cRet




Static Function xOrdem(nOrdem)

Local cAliasQry := GetNextAlias()
Local nRet		:= 0	
	
	BeginSql Alias cAliasQry
		
		%noparser%
		
		SELECT TOP 1 LJY_ORDEM FROM %table:LJY% LJY WHERE LJY_ORDEM=%Exp:nOrdem% AND LJY.%notDel%
		
		EndSql
		
		aRet := GetLastQuery()
			
		MemoWrite("C:\HD\RELATORIOS\QUAA015_ORDEM.SQL",aRet[2])	

		If (cAliasQry)->(!Eof())
			MsgStop("Ordem ja atribuida a outra categoria!")
			nRet := (cAliasQry)->(LJY_ORDEM)
		EndIf

Return nRet






