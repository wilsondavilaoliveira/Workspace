#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Program   � ColetaSQ � Autor �Wilson Davila            � Data � 02/04/2018 ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o � Leitura Coleta de Leite SmartQuestion x Protheus               ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
User Function ColetaSQ()
	Processa()
Return

//CHKTEMPLATE("COL")
Static Function Processa()
//Variaveis privadas usadas no modelo 3
Private AROTINA
Private CCADASTRO
Private CALIAS
Private NOPCE
Private NOPCG
Private NUSADO
Private CTITULO
Private CALIASENCHOICE
Private CLINOK
Private CTUDOK
Private CFIELDOK
Private NREG
Private NOPC
Private aCores
Private cFiltro		:= ""
Private bFiltraBrw	:= {|| }
Private aIndexZZS	:= {}

nOpc:=0

aRotina := {{ OemToAnsi("Pesquisar")			,"axPesqui"	   	, 0 , 1	},;     
			{ OemToAnsi("Visualizar")			,'U_ColLei(2)'	, 0 , 2	},; 
			{ OemToAnsi("Excluir"	)			,'U_ExcLei()'	, 0 , 5	},;
			{ OemToAnsi("Efetivar Lancamento")	,'U_ColLei(4)'	, 0 , 4	},;
			{ OemToAnsi("Importar")				,'U_Import()'	, 0 , 3	},;
			{ OemToAnsi("Legenda")				,"U_LgColeta()"	, 0	, 2 }}

aCores := {	{ "ZZS->ZZS_STATUS == '1' ","BR_VERDE"},; 
			{ "ZZS->ZZS_STATUS == '2'", "BR_VERMELHO"}} 


//��������������������������������������������������������������Ŀ
//� Define o cabecalho da tela de atualizacoes                   �
//����������������������������������������������������������������
cCadastro := OemToAnsi("Pr�-Lancamento de Leite. - Leituras Recebidas do SmartQuestion") //
cAlias    := "ZZS"
dbSelectArea(cAlias)
dbSetOrder(2)
//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������

	cFiltro	:="ZZS_FILIAL == '" + cFilAnt + "'"
	bFiltraBrw	:= { || FilBrowse( "ZZS" , @aIndexZZS , @cFiltro ) }
	Eval( bFiltraBrw )

mBrowse( 6, 1,22,75,cAlias, , , , , , aCores)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ColLei   � Autor �  Wilson Davila        � Data �02/04/2018���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de Tratamento do Leitursa Leite SmartQuestion       ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ColLei(nOpc)

Local nCntFor, _ni, i, nX
Local bCampo   		:= { |nCPO| Field(nCPO) }
Local nCols    		:= 0
Private nReg  		:= 0
Private aGets 		:= {}  // matriz que contem os campos que vao receber digitacao na enchoice
Private aTela 		:= {}  // matriz que contem os campos que vao aparecer na enchoice
Private wVar
Private AHEADER 	:= {}
Private ACOLS := {}
Private cCposRestr 	:= ""
Private cRestGet	:= "ZZT_FILIAL#ZZT_NUMDIA"
Private aSize    	:= {}
Private aObjects 	:= {}
Private aInfo    	:= {}
Private aPosObj  	:= {}
Private aButtons 	:= {}
Private oDlg

if nOpc == 3 // Incluir
	nOpcE := 3
	nOpcG := 3
elseif nOpc == 4 // Alterar
	nOpcE := 4
	nOpcG := 3
elseif nOpc == 2 // Visualizar
	nOpcE := 2
	nOpcG := 2
else             // Excluir
	nOpcE := 5
	nOpcG := 5
endif

//��������������������������������������������������������������Ŀ
//� Cria variaveis M->????? da Enchoice                          �
//����������������������������������������������������������������
aCpoEnchoice  :={}
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("LBC")
While !Eof().and.(x3_arquivo=="ZZS")
	If X3USO(x3_usado).and.x3_nivel>0 .and. !Alltrim(X3_Campo) $ cCposRestr
		AADD(aCpoEnchoice,x3_campo)
	Endif
	wVar := "M->"+x3_campo
	&wVar:= CriaVar(x3_campo)
	dbSkip()
End

If nOpc != 3 // se nao for inclusao
	dbSelectArea("ZZS")
	For nCntFor := 1 TO FCount()
		M->&(EVAL(bCampo,nCntFor)) := FieldGet(nCntFor)
	Next nCntFor
Endif

//��������������������������������������������������������������Ŀ
//� Cria aHeader e aCols da GetDados                             �
//����������������������������������������������������������������
nUsado:=0
dbSelectArea("SX3")
dbSetOrder(1)

dbSeek("ZZT")
While !Eof().And.(x3_arquivo=="ZZT")
	
	If !Alltrim(x3_campo) $ cRestGet
		nUsado:=nUsado+1
		Aadd(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,x3_valid,;
		x3_usado, x3_tipo, x3_arquivo, x3_context, x3_Relacao, x3_reserv } )
		wVar  := "M->"+x3_campo
		&wVar := CriaVar(x3_campo)
	Endif
	
	dbSkip()
	
Enddo

//+--------------
//| Monta o aCols
//+--------------
dbSelectArea("ZZT")

if nOpc == 3 // Incluir
	
	//aAdd(aCols,Array(nUsado+1))
	//For nXa := 1 to Len(aHeader)
	//	aCols[1][nXa] := CriaVar(Trim(aHeader[nXa][2]),.T.)
	//Next nXa
	//aCols[1][nUsado+1] := .F.
	//aCols[1][aScan(aHeader,{|x| Trim(x[2])=="LBD_SEQ"})] := "001"
	
Else
	dbSelectArea("ZZT")
	dbSetOrder(2)
	dbSeek(xFilial("ZZT")+pad(cValToChar(M->ZZS_NUMDIA),TamSX3("ZZT_NUMDIA")[1])+ZZS->ZZS_CODLIN)
	//MSGALERT(xFilial("ZZT")+cValToChar(M->ZZS_NUMDIA)+ZZS->ZZS_CODLIN)
	While !Eof() .And. xFilial("ZZT") == ZZT->ZZT_FILIAL .And. ZZT->ZZT_NUMDIA == M->ZZS_NUMDIA .AND. ZZT->ZZT_CODLIN == ZZS->ZZS_CODLIN 
	   aAdd(aCols,Array(nUsado+1))
	   nCols ++
   	   For nX := 1 To nUsado
	      If ( aHeader[nX][10] != "V")
	         aCols[nCols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
		  
			  If aHeader[nX][2] == "ZZT_CODPRO"
		         
			         If SubStr(FieldGet(FieldPos(aHeader[nX][2])),1,2) == "TC"
			         	cCodPro := SubStr(FieldGet(FieldPos(aHeader[nX][2])),6,6)
			         Else
			         	cCodPro := FieldGet(FieldPos(aHeader[nX][2]))
			         End If
			     
			  End If
		  
		  Else
		  
	         aCols[nCols][nX] := CriaVar(aHeader[nX][2],.T.)
	         If !Empty( aHeader[nX][11] )
	         	cVar := aHeader[nX][11]
	         	aCols[nCols][nX] := &cVar
	         Endif	
	         
			       	         
	         If aHeader[nX][2] == "ZZT_DESCPR"
	         	aCols[nCols][nX] := Posicione("LBB",1,xFilial("LBB")+cCodPro,"LBB_DESC")
	         ElseIf aHeader[nX][2] == "ZZT_FORNEC"
	         	aCols[nCols][nX] := Posicione("LBB",1,xFilial("LBB")+cCodPro,"LBB_NOMFOR")
	         End If
	      
	      Endif
	   Next nX
	   
	   aCols[nCols][nUsado+1] := .F.
	   
	   dbSelectArea("ZZT")
	   dbSkip()
	End
//	aCols := adjcols(aCols, aHeader)
Endif

If Len(aHeader) > 0
	//��������������������������������������������������������������Ŀ
	//� Executa a Modelo 3                                           �
	//����������������������������������������������������������������
	cTitulo       :=OemToAnsi("Cadastro de Rotas")
	cAliasEnchoice:="ZZS"
	cAliasGetd    :="ZZT"                                
	cAlias        :="ZZT"
	cLinOk        :=  "AllwaysTrue()"
	cTudOk        :=  "AllwaysTrue()"
	cFieldOk      :=  "AllwaysTrue()"

	aButtons:={}
	
	//AAdd(aButtons, { "RELOAD"    ,{|| EscLinha() }, "Seleciona linhas da Rota." , "Sel.Linhas"  } )

	aSize := MsAdvSize()
	aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	
	aAdd(aObjects,{040,100,.T.,.F.})
	aAdd(aObjects,{060,100,.T.,.T.})
	
	aPosObj := MsObjSize(aInfo,aObjects)
	aCpos := {"ZZS_DTENTR"}
	nOpca := 0
	DEFINE MSDIALOG oDlg TITLE cTitulo From  aSize[7],aSize[1] TO aSize[6],aSize[5]	of oMainWnd PIXEL
	EnChoice(cAliasEnchoice,nReg,nOpcE,,,,aCpoEnchoice,aPosObj[1],aCpos,3,,,,,,.F.)
	
	//oGetDados := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcG,cLinOk,cTudOk,"+LBD_SEQ",.T.,,,,999,cFieldOk)
	oGetDados := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcG,cLinOk,cTudOk,"",.T.,,,,999,cFieldOk)
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| If(oGetDados:TudoOk() .And. obrigatorio(aGets, aTela) .and. FS_VldProd(), oDlg:End(), .f.), nOpca := 1},{|| nOpcA := 0, oDlg:End()},,aButtons)
Endif

if nOpcA == 1 .AND. nOpcE == 4 // ok 
	If MsgYesNo("Deseja efetivar lan�amento de leite?")
		MsgRun("Efetivando Lan�amento de Leite no Protheus. . .","SMARTQUESTION",{|| GrvEnt()})
	End If
Endif
Return Nil
/*
�����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � FS_VldProd� Autor �  Rogerio Faro       � Data � 29/03/2004 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao de Produtores                                     ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                             ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function FS_VldProd()
Local i
Local nTotItens := 0



Return(.T.)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � NMCB19G  � Autor � Fabrica Software      � Data � 16/01/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de legenda do processo de Ordem de Separacao        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LgColeta()
Local aCorDesc 

aCorDesc := {		{ "BR_VERDE"   		,"Pronto para Lancar" 	},;
			  		{ "BR_VERMELHO"		,"Registro ja Lancado"	}}
												
BrwLegenda( "Legenda", 	"Status", aCorDesc )

Return( .T. )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �GrvEnt    � Autor �Microsiga              � Data �20/07/08  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava ENTRADA DE LEITE                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                   
Static Function GrvEnt()

	Local nI      	:= 0
	Local nY      	:= 0
	Local cVar    	:= ""
	Local lOk     	:= .T.
	Local cMsg    	:= ""
	Local nPos    	:= 0
	Local aAux    	:= {}
	Local lAchou  	:= .F.
	Local cNum		:= GetSx8Num("PC0","PC0_NUMSEQ")
	Local aRet		:= {}
	Local nQtdRec	:= 0
	
	If ZZS->ZZS_STATUS <> '1'
		MsgStop("Leitura ja lan�ada, nao e possivel novo lan�amento!")
		Return .F.
	End If
	
	Begin Transaction
	
	RecLock("PC0",.F.)
		ZZS->ZZS_DTENTR := M->ZZS_DTENTR
	MsUnlock("ZZS")
	
	RecLock("PC0",.T.)
		PC0->PC0_FILIAL := xFilial("PC0")
		PC0->PC0_NUMSEQ := cNum
		PC0->PC0_DTENTR := M->ZZS_DTENTR
		PC0->PC0_TPENTR := "1"
		PC0->PC0_LINROT := ZZS->ZZS_CODLIN
		PC0->PC0_DESCRI := RetField("PA7",1,xFilial("PA7") + M->ZZS_CODLIN,"PA7->PA7_DESC")
		PC0->PC0_QTDAPO := ZZS->ZZS_QTAPLI
		PC0->PC0_QTDMED := ZZS->ZZS_QTAPLI
		PC0->PC0_QTDDIF := 0
		PC0->PC0_NUMDIA := ZZS->ZZS_NUMDIA
	MsUnLock("PC0")
	
	RecLock("PC0",.T.)
		PC0->PC0_FILIAL := xFilial("PC0")
		PC0->PC0_NUMSEQ := cNum
		PC0->PC0_DTENTR := M->ZZS_DTENTR
		PC0->PC0_TPENTR := "2"
		PC0->PC0_LINROT := IIF(cFilAnt $ '05|10',xRotaDou(RetField("PA7",1,xFilial("PA7") + M->ZZS_CODLIN,"PA7->PA7_CODCAR"),cFilAnt),ZZS->ZZS_CODROT)
		//PC0->PC0_DESCRI := RetField("LBC",1,xFilial("LBC") + ZZS->ZZS_CODROT ,"LBC->LBC_DESC")
		PC0->PC0_DESCRI := RetField("LBC",1,xFilial("LBC") + IIF(cFilAnt $ '05|10',xRotaDou(RetField("PA7",1,xFilial("PA7") + M->ZZS_CODLIN,"PA7->PA7_CODCAR"),cFilAnt),ZZS->ZZS_CODROT) ,"LBC->LBC_DESC")
		PC0->PC0_QTDAPO := ZZS->ZZS_QTAPLI
		PC0->PC0_QTDMED := ZZS->ZZS_QTAPLI
		PC0->PC0_QTDDIF := 0
		PC0->PC0_NUMDIA := ZZS->ZZS_NUMDIA
	MsUnLock("PC0")

	RecLock("PC2",.T.)
		PC2->PC2_FILIAL := xFilial("PC2")
		PC2->PC2_NUMSEQ := cNum
		PC2->PC2_ROTA   := IIF(cFilAnt $ '05|10',xRotaDou(RetField("PA7",1,xFilial("PA7") + M->ZZS_CODLIN,"PA7->PA7_CODCAR"),cFilAnt),ZZS->ZZS_CODROT)
		PC2->PC2_QTDMED := ZZS->ZZS_QTAPLI
		PC2->PC2_CODTAN := ZZS->ZZS_CODTAN
		PC2->PC2_QTDLIT := ZZS->ZZS_QTAPLI
		PC2->PC2_VLRLIT := 0
	MsUnLock("PC2")

    //GRAVA PC1
	//DbSelectArea("ZZT")
	ZZT->(DbSetOrder(2))
	dbSeek(xFilial("ZZT")+pad(cValToChar(M->ZZS_NUMDIA),TamSX3("ZZT_NUMDIA")[1])+ZZS->ZZS_CODLIN)
	
	If ZZT->(DbSeek( xFilial("ZZT")+pad(cValToChar(ZZS->ZZS_NUMDIA),TamSX3("ZZT_NUMDIA")[1])+ZZS->ZZS_CODLIN))

		While ZZT->( !Eof() ) .AND. (ZZT->ZZT_FILIAL+cValToChar(ZZT->ZZT_NUMDIA)+ZZT->ZZT_CODLIN == ZZS->ZZS_FILIAL+cValToChar(ZZS->ZZS_NUMDIA)+ZZS->ZZS_CODLIN)
	
			If ZZT->ZZT_QTDAJU > 0 .AND. SubStr(ZZT->ZZT_CODPRO,1,2) <> 'TC'
				
				nQtdRec += ZZT->ZZT_QTDREC
				
				RecLock("PC1",.T.)
					PC1->PC1_FILIAL := xFilial("PC1")
					PC1->PC1_NUMSEQ := cNum
					PC1->PC1_LINHA  := ZZS->ZZS_CODLIN
					PC1->PC1_QTDMED := ZZS->ZZS_QTAPLI
					PC1->PC1_CARSUB := ""
					PC1->PC1_CODPRO := ZZT->ZZT_CODPRO
					PC1->PC1_QTDLIT := ZZT->ZZT_QTDAJU
					PC1->PC1_VLRLIT := ZZT->ZZT_PRCLEI
					PC1->PC1_NUMATE := ZZT->ZZT_NUMATE
				MsUnLock("PC1")
				
			End If
			
			ZZT->( DbSkip() ) 
		EndDo

    End If

    RecLock("ZZS",.F.)
    	ZZS->ZZS_STATUS := '2'
    	ZZS->ZZS_NUMSEQ := cNum
    MsUnlock("ZZS")
    
    ConfirmSX8()
    
    If GETMV("ES_ATUESTO",,.F.) //parametro verifica se atualiza ou nao estoque
		//FAtuEst(nTipo,nQtd,nNumSeq)
		FAtuEst(1,nQtdRec,ZZS->ZZS_NUMDIA,M->ZZS_DTENTR)
	EndIf
    
    AADD(aRet,{ZZS->ZZS_NUMDIA,,,,,,,,ZZS->ZZS_FILIAL,ZZS->ZZS_CODLIN})
    
    U_xGetFrete(aRet)
    
    End Transaction
    
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ExcLei    � Autor �Wilson Davila          � Data �02/04/18  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exclui ENTRADA DE LEITE                                    ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
User Function ExcLei()

Local aArea 	:= GetArea()
Local cQry 		:= ''
Local cNumSeq 	:= 	cValToChar(ZZS->ZZS_NUMSEQ)	
Local cNumDia	:= 	cValToChar(ZZS->ZZS_NUMDIA)	
Local cChvPA4	:= ''
Local nQtdLit	:= 0
Local nKM		:= 0
Local cTpFrt	:= ''
Local nValFrt	:= 0
Local dDtEntr	
Local lEstorna	:= .F.

BEGIN TRANSACTION		

		dbSetOrder(1)
		If MsgYesNo(OemToAnsi("Deseja exclui lancamento?"))

			If MsgYesNo(OemToAnsi("Deseja exclui lancamento na TAMBEM na CAPTACAO DE LEITE?"))
				lEstorna := .T.
				If dbSeek(cFilAnt+cNumDia)
					dDtEntr := 	ZZS->ZZS_DTENTR				
					While !Eof() .AND. ZZS->ZZS_FILIAL+cValToChar(ZZS->ZZS_NUMDIA) == cFilAnt+cNumDia
					
						cNumSeq := ZZS->ZZS_NUMSEQ
						
						aArea1 := GetArea()
						
						PC0->(dbSetOrder(1))
						If PC0->(dbSeek(cFilAnt+cNumSeq))
							
							While PC0->(!Eof()) .AND. PC0->(PC0_FILIAL+PC0_NUMSEQ) == cFilAnt+cNumSeq
								PC1->(dbSetOrder(1))
								If PC1->(dbSeek(cFilAnt+cNumSeq))
									
									While PC1->(!Eof()) .AND. PC1->(PC1_FILIAL+PC1_NUMSEQ) == cFilAnt+cNumSeq
										PC1->(RecLock("PC1",.F.))
											PC1->(dbDelete())
										PC1->(MsUnlock())
										PC1->(dbSkip())
									EndDo
								End If
								PC2->(dbSetOrder(1))
								If PC2->(dbSeek(cFilAnt+cNumSeq))
									
									While PC2->(!Eof()) .AND. PC2->(PC2_FILIAL+PC2_NUMSEQ) == cFilAnt+cNumSeq
										PC2->(RecLock("PC2",.F.))
											PC2->(dbDelete())
										PC2->(MsUnlock())
										PC2->(dbSkip())
									EndDo
								End If

								PC0->(RecLock("PC0",.F.))
									PC0->(dbDelete())
								PC0->(MsUnlock())
								PC0->(dbSkip())
								
								//exclui frete
								PA4->(dbSetOrder(5))
								If PA4->(dbSeek(xFilial("PA4")+cValToChar(ZZS->ZZS_NUMDIA)))
									
									cChvPA4 := PA4->(PA4_FILIAL)+PA4->(PA4_CODCAM)+PA4->(PA4_PERIOD)
									
									nQtdLit	:= 0
									nKM		:= Posicione("ZA1",1,xFilial("ZA1")+cValToChar(PA4->(PA4_NUMDIA)),"ZA1_KMRAST")
									cTpFrt	:= Posicione("LBE",2,xFilial("LBE")+PA4->(PA4_CODCAM),"LBE_TPFRET")
									nValFrt := Posicione("LBE",2,xFilial("LBE")+PA4->(PA4_CODCAM),"LBE_PERC1")
									
									While PA4->( !Eof() ) .AND. PA4->(PA4_FILIAL)+cValToCHar(PA4->(PA4_NUMDIA)) == ZZS->ZZS_FILIAL+cValToChar(ZZS->ZZS_NUMDIA)
										nQtdLit += PA4->(PA4_QTDLIT)
										PA4->(RecLock("PA4",.F.))
											PA4->(dbDelete())
										PA4->(MsUnlock())
										PA4->( dbSkip() )
									EndDo
									
									PA3->(dbSetOrder(1))
									If PA3->( dbSeek(cChvPA4) )
										PA3->(RecLock("PA3"),.F.)
											
											PA3->PA3_QTDLIT -= nQtdLit 
											PA3->PA3_TOTKM	-= nKM
											
											If 	cTpFrt == '1'
										    	PA3->(PA3_VLRFRT)	:= (PA3->PA3_QTDLIT *  nValFrt) 
										    ElseIf cTpFrt == '2'
										    	PA3->(PA3_VLRFRT)	:= nValFrt 
										   	Else
										    	PA3->(PA3_VLRFRT)	:= (PA3->PA3_TOTKM *  nValFrt) 
										   	EndIf
							
										PA3->(MsUnlock())
									EndIf
								EndIf
							
							EndDo
						End If
							
						RestArea(aArea1)
						
						dbSelectArea("ZZS")
						dbSkip()
					EndDo
				End If
			End If
			
			If lEstorna
				FAtuEst(2,0,cNumDia,dDtEntr)
			End If
			
			cQry := "DELETE " + RetSqlName("ZZT") + " WHERE ZZT_FILIAL='" + cFilAnt + "' AND ZZT_NUMDIA=" + cValToChar(cNumDia)
			TcSqlExec(cQry)
			
			cQry := "DELETE " + RetSqlName("ZZS") + " WHERE ZZS_FILIAL='" + cFilAnt + "' AND ZZS_NUMDIA=" + cValToChar(cNumDia)
			TcSqlExec(cQry)
			
			
		
		MsgStop("Lancamento Excluido com sucesso !")
		
		End If

dbSetOrder(2)

RestArea(aArea)

END TRANSACTION

Return


////////chama funcao de leitura do webservice
User Function Import()
	aArea := GetArea()
		//MsAguarde("Realizando Leitura SmartQuestion. . .","SMARTQUESTION",{|| U_WSGetDiaT()})
		MsAguarde({|| U_WSGetDiaT()},"SMARTQUESTION","Realizando Leitura SmartQuestion. . .",.F.)
	RestArea(aArea)
Return


User Function xZZT()

AxCadastro("ZZT")

Return

Static Function xRotaDou(cCodCam,xFil)

Local aArea := GetArea()
Local cRot := ''
Local cQuery := "SELECT LBC_CODROT FROM " + RetSqlName("LBC") + " LBC WHERE LBC_CODCAM='" + cCodCam + "' AND LBC_FILIAL='" + xFil + "' " + CRLF
Local cAliasQry := "cLbcDou"


TCQUERY cQuery NEW ALIAS cAliasQry

If cAliasQry->( !Eof() )

	cRot := cAliasQry->(LBC_CODROT)

End If

cAliasQry->(DbCloseArea())

RestArea(aArea)

Return cRot

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FAtuEst   � Autor �Microsiga              � Data �20/07/08  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecAuto Movimento interno mod1                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                   
Static Function FAtuEst(nTipo,nQtd,nNumSeq,dDtEntr)

	Local aAtuEst	:= {}
	Local nI       	:= 0
	Local aArea		:= GetArea()
	
		If nTipo == 1 // Entrada
			
		//cadastro de PRODUTO
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek( xFilial("SB1")+'200113' )
		
			aAtuEst := {}
		
			aAtuEst :=  {	{"D3_TM"		,GETMV("ES_TMENTLE")	,NIL},;
							{"D3_COD"		,SB1->B1_COD			,NIL},;
							{"D3_UM"		,SB1->B1_UM				,NIL},;
							{"D3_QUANT"		,nQtd					,".T."},;
							{"D3_LOCAL"		,SB1->B1_LOCPAD			,NIL},;
							{"D3_EMISSAO"	,dDtEntr				,NIL},;
							{"D3_CUSTO1"	,0.01					,NIL},;
							{"D3_DOC"		,cValToChar(nNumSeq)	,NIL},;
							{"D3_NUMSEQ"	,ProxNum()				,NIL}}
							
			lMsErroAuto := .F.

			MSExecAuto({|x,y| mata240(x,y)},aAtuEst,3) //inclusao

			If lMsErroAuto
				Mostraerro()
				DisarmTransaction()
			Endif

	EndIf
	
	If nTipo == 2 //estorno
			
			//ZZT_FILIAL+ZZT_NUMDIA+ZZT_NUMATE                                                                                                                                
			ZZT->(dbSetOrder(1))
			
			If ZZT->( dbSeek(xFilial("ZZT")+nNumSeq) )
				
			
				While ZZT->( !Eof() ) .AND. ( ZZT->(ZZT_FILIAL+cValToCHar(ZZT_NUMDIA)) == xFilial("ZZT")+nNumSeq )
					nQtd += ZZT->(ZZT_QTDREC)	
					ZZT->( dbSkip() )
				EndDo	

				DbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek( xFilial("SB1")+'200113' )
			
				aAtuEst := {}
			
				aAtuEst :=  {	{"D3_TM"		,GETMV("ES_TMESTLE")	,NIL},;
								{"D3_COD"		,SB1->B1_COD			,NIL},;
								{"D3_UM"		,SB1->B1_UM				,NIL},;
								{"D3_QUANT"		,nQtd					,".T."},;
								{"D3_LOCAL"		,SB1->B1_LOCPAD			,NIL},;
								{"D3_CUSTO1"	,0.01					,NIL},;
								{"D3_DOC"		,nNumSeq				,NIL},;
								{"D3_EMISSAO"	,dDtEntr				,NIL},;
								{"D3_NUMSEQ"	,ProxNum()				,NIL}}
				
	
				lMsErroAuto := .F.
	
				MSExecAuto({|x,y| mata240(x,y)},aAtuEst,3) //estorno
	
				If lMsErroAuto
					Mostraerro()
					DisarmTransaction()
				Endif

			EndIf
		
	EndIf

	RestArea(aArea)

Return