#include "Protheus.ch"

/*
����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � CACCOA20 � Autor � Ricardo Berti         � Data � 04.11.05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Manutencao Tab.Criterios para Valorizacao da Qualidade      ���
���          �Sao 4 tabelas basicas(em vigor): GORDURA,PROTEINA,CBT,CCS   ���
���          �Obs.: chave exclusiva = LJY_CODQUA + LJY_TIPOL			  ���
���          �      ou seja, podemos ter o mesmo codigo em 2 tabelas:	  ���
���          �      uma para cada tipo de leite.                          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � CACCOA20()                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Template Leite - COL_LEI                                   ���
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
User Function CaCCOA20()

//��������������������������������������������������������������Ŀ
//� Define Array contendo os campos do arquivo que sempre deverao�
//� aparecer no browse. (funcao mBrowse)                         �
//� ----------- Elementos contidos por dimensao ---------------- �
//� 1. Titulo do campo (Este nao pode ter mais de 12 caracteres) �
//� 2. Nome do campo a ser editado                               �
//����������������������������������������������������������������

LOCAL aFixe := { 	{ OemToAnsi("C�digo"),"LJY_CODQUA" },;
					{ OemToAnsi("Leite"),"LJY_TIPOL"  },;
					{ OemToAnsi("De"),"LJY_VINIC"  },;
					{ OemToAnsi("At�"),"LJY_VFINAL" },;
					{ OemToAnsi("R$/Litro"),"LJY_VRESUL" },;
					{ OemToAnsi("Ult.Atualiz."),"LJY_DTATU"  },;
					{ OemToAnsi("Descricao Tab."),"LJY_DESQUA"  } }

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
Private cCadastro := OemtoAnsi("Crit�rios para Valoriza��o da Qualidade do Leite")

Private aRotina := {{OemToAnsi('Pesquisar'),'AxPesqui',0,1},;
 					{OemToAnsi('Visualizar'),'u_CaL20Man',0,2},;
					{OemToAnsi('Incluir'),'u_CaL20Man',0,3},;
					{OemToAnsi('Alterar'),'u_CaL20Man',0,4},;
					{OemToAnsi('Excluir'),'u_CaL20Man',0,5} }

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
���Funcao    �CaL20Man  � Autor �Ricardo Berti          � Data �04.11.2005���
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
User Function CaL20Man(cAlias,nRecno,nOpc)

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
	If X3Uso(SX3->X3_USADO) .And. SX3->X3_CAMPO != "LJY_CODQUA" .And.;
		SX3->X3_CAMPO != "LJY_DESQUA" .And.;
		SX3->X3_CAMPO != "LJY_TIPOL" .And.;
		SX3->X3_CAMPO != "LJY_DTATU" .And.;
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
	M->LJY_CODQUA := CriaVar("LJY_CODQUA")
	M->LJY_DESQUA := CriaVar("LJY_DESQUA")
	M->LJY_TIPOL  := CriaVar("LJY_TIPOL")
	M->LJY_DTATU  := CriaVar("LJY_DTATU")

	Aadd(aCols, Array(nUsado + 1))

	For nCntFor	:= 1 To Len( aHeader )
		aCols[1][nCntFor] := CriaVar( aHeader[nCntFor][2] )
	Next nCntFor
	
	aCols[1][nUsado + 1]:= .F.
 //	aCols[1][nPItem] := 1
Else
	M->LJY_CODQUA	:= LJY->LJY_CODQUA
	M->LJY_DESQUA	:= LJY->LJY_DESQUA
	M->LJY_TIPOL	:= LJY->LJY_TIPOL
	M->LJY_DTATU	:= LJY->LJY_DTATU

/*	If Empty( M->LJY_DESQUA )
		cTexto1 := Posicione("ACY",1,xFilial("ACY")+M->LJY_DESQUA,"ACY_DESCRI")
	Else
		cTexto2 := Posicione("SA1",1,xFilial("SA1")+M->LJY_TIPOL+M->LJY_DTATU,"A1_NOME")
	EndIf
*/	
	dbSelectArea("LJY")
	dbSetOrder(1)
	dbSeek( xFilial("LJY") + M->LJY_CODQUA + M->LJY_TIPOL )

	nI := 0
	While !Eof() .And. xFilial("LJY") == LJY->LJY_FILIAL ;
	  .And. M->LJY_CODQUA == LJY->LJY_CODQUA .And. M->LJY_TIPOL == LJY->LJY_TIPOL
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

//aadd(aObjects,{100,030,.T.,.F.})  
aadd(aObjects,{100,030,.T.,.F.})  
aadd(aObjects,{100,100,.T.,.T.}) 

aInfo   := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
aPosObj := MsObjSize(aInfo,aObjects) 
//aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{005,045,080,115,160}})
aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{004,031,062,083,120,146}})
                                                              
DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE cCadastro OF oMainWnd PIXEL
@ aPosObj[01,01]   ,aPosGet[1,1] SAY	RetTitle("LJY_CODQUA") SIZE 035,009	OF oDlg PIXEL
@ aPosObj[01,01]   ,aPosGet[1,2] MSGET M->LJY_CODQUA PICTURE "@!" 	SIZE 035,009 OF oDlg PIXEL ;
	WHEN nOpc==3 .And. VisualSX3("LJY_CODQUA") ;
	VALID CheckSX3("LJY_CODQUA")
@ aPosObj[01,01]   ,aPosGet[1,3] SAY 	RetTitle("LJY_DESQUA") SIZE 040,009  OF oDlg PIXEL
@ aPosObj[01,01]   ,aPosGet[1,4] MSGET M->LJY_DESQUA PICTURE "@!" 	SIZE 120,009 OF oDlg PIXEL ;
	VALID CheckSX3("LJY_DESQUA") ; // F3 CpoRetF3('LJY_DESQUA') ;
	WHEN (nOpc==3  .Or. nOpc==4 ) .And. VisualSX3("LJY_CODQUA")
//@ aPosObj[01,01]   ,aPosGet[1,5] SAY oSay1 PROMPT cTexto2 SIZE 120,009  OF oDlg PIXEL
@ aPosObj[01,01]+14,aPosGet[1,1] SAY RetTitle("LJY_TIPOL") SIZE 040,009  OF oDlg PIXEL
@ aPosObj[01,01]+14,aPosGet[1,2] MSGET M->LJY_TIPOL PICTURE "@!" 	SIZE 004,009 OF oDlg PIXEL ;
	VALID CheckSX3("LJY_TIPOL") ;
	F3 CpoRetF3('LJY_TIPOL') ;
	WHEN (nOpc==3) .And. VisualSX3("LJY_CODQUA")
@ aPosObj[01,01]+14,aPosGet[1,3] SAY RetTitle("LJY_DTATU") SIZE 020,009 OF oDlg PIXEL
@ aPosObj[01,01]+14,aPosGet[1,4] SAY M->LJY_DTATU SIZE 030,007 OF oDlg PIXEL // ;

//@ aPosObj[01,01]+14,aPosGet[1,5] SAY RetTitle("LJY_ATIVO") SIZE 040,009 OF oDlg PIXEL
//@ aPosObj[01,01]+14,aPosGet[1,6] MSGET M->LJY_ATIVO PICTURE "@! A" SIZE 004,009 OF oDlg PIXEL  ;
//	VALID CheckSX3("LJY_ATIVO") ;
// 	WHEN (nOpc==3  .Or. nOpc==4 ) .And. VisualSX3("LJY_CODQUA")
//@ aPosObj[01,01]+14,aPosGet[1,5] SAY oSay2 PROMPT cTexto1 SIZE 120,009  OF oDlg PIXEL
//oGetd := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_CAL20LinOK","u_CAL20TudOk","+ACW_ITEM",.T.)
oGetd := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_CAL20LinOK","u_CAL20TudOk",,.T.)
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||IIf(oGetD:TudoOk(),(nOpcA:= 1,oDlg:End()),.T.)},{||oDlg:End()})
If nOpc > 2 .And. nOpcA == 1
	//������������������������������������������������Ŀ
	//� Funcao responsavel pela atualizacao do arquivo �
	//��������������������������������������������������
	Begin Transaction
		If CAL20Grv(nOpc-2,aRegLJY)
			If __lSx8
				ConfirmSx8()
			EndIf
			EvalTrigger()
		Else
			RollBackSx8()
		EndIf
	End Transaction
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
���Funcao    �CAL20Grv  � Autor �Ricardo Berti          � Data �07.11.2005���
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
Static Function CaL20Grv( nOpcao , aRegLJY )

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
			LJY->LJY_CODQUA := M->LJY_CODQUA
			LJY->LJY_DESQUA := M->LJY_DESQUA
			LJY->LJY_TIPOL	:= M->LJY_TIPOL
			LJY->LJY_DTATU  := dDataBase
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
���Funcao    �CAL20LinOk� Autor �Eduardo Riera          � Data �07.11.2005���
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
User Function CAL20LinOk()
 
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
���Funcao    �CaL20TudOk� Autor �Ricardo Berti          � Data �07.11.2005���
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


User Function CaL20TudOk()

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
���Funcao    �CaL20Vld  � Autor �Ricardo Berti          � Data �07.11.2005���
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
User Function CaL20Vld()

Local aArea    := GetArea()

Local cCampo   := ReadVar()  
Local cConteudo:= &( ReadVar() ) 

Local lRetorno := .T.

//�����������������������������������������������������������������������Ŀ
//� Verifica se cabecalho foi preenchido corretamente                     �
//�������������������������������������������������������������������������

If "LJY_TIPOL" $ cCampo
	
	If ExistChav("LJY",M->LJY_TIPOL+M->LJY_CODQUA,1) .And. Inclui
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
���Descri��o �Validacao do campo LJY_CODQUA (COD.CRITERIO QUALIDADE)      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function _VldCodQua()

Local aArea    	 := {}
Local cVarAtu 	 := ReadVar()
Local lRet   	 := .T.
Local cLista	 := ""
Local cValorCrit
Local cCriterio
Local i

//ChkTemplate("COL")

If AllTrim(cVarAtu) == "M->LJY_CODQUA"

	For i :=1 to 4
		Do Case
		Case i = 1
			cCriterio := "MV_CTABGOR"
		Case i = 2
			cCriterio := "MV_CTABPRO"
		Case i = 3
			cCriterio := "MV_CTABCCS"
		Case i = 4
			cCriterio := "MV_CTABCBT"
		EndCase

		cValorCrit := SuperGetMv(cCriterio,,"")
		
		If ! Empty( cValorCrit )
			cLista += Trim(cValorCrit)+","
		EndIf
	Next

	If Empty( cLista )
	  	MsgAlert("Par�metros da Qualidade do Leite nao configurados. Verifique!")
		lRet := .F.
	ElseIf ! Trim(M->LJY_CODQUA) $ cLista // so' pode digitar um codigo dos 4 parametros
	   	MsgAlert("Cod.da Tabela diferente de "+Left(cLista,Len(cLista)-1),"Verifique os PAR�METROS da Qualidade do Leite!")
		lRet := .F.
	ElseIf Inclui

		aArea	:= GetArea()
		dbSelectArea("LJY")
		dbSetOrder(1)
		If dbSeek( xFilial("LJY") + M->LJY_CODQUA )
			M->LJY_DESQUA := LJY->LJY_DESQUA
		Endif
		RestArea(aArea)	
	EndIf

ElseIf AllTrim(cVarAtu) == "M->LJY_TIPOL" .And. Inclui

		aArea	:= GetArea()
		dbSelectArea("LJY")
		dbSetOrder(1)
		If dbSeek( xFilial("LJY") + M->LJY_CODQUA + M->LJY_TIPOL)
		   	MsgAlert("Tabela j� existente!")
			lRet := .F.
		Endif
		RestArea(aArea)
EndIf

Return(lRet)
