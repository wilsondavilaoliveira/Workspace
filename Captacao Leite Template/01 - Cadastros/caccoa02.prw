#include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOA02 ³ Autor ³  Choite               ³ Data ³ 16/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cadastro de Linhas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACCOA02()

//CHKTEMPLATE("COL")

//Variaveis privadas usadas no modelo 3
Private AROTINA,CCADASTRO,CALIAS
Private NOPCE,NOPCG
Private NUSADO:=0
Private CTITULO,CALIASENCHOICE,CLINOK,CTUDOK,CFIELDOK
Private NREG,NOPC

nOpc:=0

aRotina := {{ OemToAnsi("Pesquisar") ,"axPesqui", 0 , 1},;
			{ OemToAnsi("Visualizar") 	,'U_CACOL021(2)', 0 , 2},;
			{ OemToAnsi("Incluir")    ,'U_CACOL021(3)', 0 , 3},;
			{ OemToAnsi("Alterar")    ,'U_CACOL021(4)', 0 , 4, 2},;
			{ OemToAnsi("Excluir")    ,'U_CACOL021(5)', 0 , 5, 1} } 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCadastro := OemToAnsi("Cadastro de Linhas")
cAlias    := "LBC"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse( 6, 1,22,75,cAlias)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CAC02    ³ Autor ³  Choite             ³ Data ³ 16/02/2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Tratamento do Cadastro de Linhas                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACOL021(nOpc)

Local nCntFor, _ni, i
Local bCampo   := { |nCPO| Field(nCPO) }
nReg  := 0
aGets := {}  // matriz que contem os campos que vao receber digitacao na enchoice
aTela := {}  // matriz que contem os campos que vao aparecer na enchoice
Private wVar
Private aTELA[0][0],aGETS[0]
Private AHEADER := {}, ACOLS := {}, M->LBD_SEQ := ""

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis M->????? da Enchoice                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCpoEnchoice  :={}
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("LBC")
While !Eof().and.(x3_arquivo=="LBC")
	If X3USO(x3_usado).and.x3_nivel>0 .and. Alltrim(X3_Campo) $ "LBC_CODROT#LBC_DESC#LBC_CODCAM"
		AADD(aCpoEnchoice,x3_campo)
	Endif
	wVar := "M->"+x3_campo
	&wVar:= CriaVar(x3_campo)
	dbSkip()
End

If nOpc#3 // se nao for inclusao
	dbSelectArea("LBC")
	For nCntFor := 1 TO FCount()
		M->&(EVAL(bCampo,nCntFor)) := FieldGet(nCntFor)
	Next
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria aHeader e aCols da GetDados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nUsado:=0
dbSelectArea("SX3")
dbSetOrder(1)

dbSeek("LBD")
While !Eof().And.(x3_arquivo=="LBD")
	
	If Alltrim(x3_campo) $ "LBD_SEQ/LBD_CODPRO/LBD_DESC/LBD_NOMFOR"
		nUsado:=nUsado+1
		Aadd(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,x3_valid,;
		x3_usado, x3_tipo, x3_arquivo, x3_context, x3_Relacao, x3_reserv } )
		wVar  := "M->"+x3_campo
		&wVar := CriaVar(x3_campo)
	Endif
	
	dbSkip()
	
Enddo
dbSelectArea("LBD")

if nOpc == 3 // Incluir
	
	aCols:={Array(nUsado+1)}
	aCols[1,nUsado+1]:=.F.
	For _ni:=1 to nUsado
		aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
	Next
	aCols[1,1] := "001"
	M->LBD_SEQ := "001"
	
Else
	
	aCols:={}
	dbSelectArea("LBD")
	dbSetOrder(1)
	dbSeek(xFilial("LBD")+M->LBC_CODROT)
	While LBD->LBD_FILIAL+LBD->LBD_CODROT == xFilial("LBD")+M->LBC_CODROT .and. !eof()
		AADD(aCols,Array(nUsado+1))
		LBB->(dbSetOrder(1))
		LBB->(dbSeek(xFilial("LBB")+LBD->LBD_CODPRO))
		For _ni:=1 to nUsado
			aCols[Len(aCols),_ni]:=If(aHeader[_ni,10] # "V",FieldGet(FieldPos(aHeader[_ni,2])),CriaVar(aHeader[_ni,2]))
			if  _ni == 4
				aCols[Len(aCols),_ni]  := LBB->LBB_NOMFOR
				M->LBD_NOMFOR:= LBB->LBB_NOMFOR
			Endif
		Next
		aCols[Len(aCols),nUsado+1]:=LBB->LBB_CODTAN
		dbSelectArea("LBD")
		dbSkip()
	Enddo
	
	For i = 1 to len(aCols)
		aCols[i,nUsado+1]:=.F.
	Next
	
Endif


If Len(aHeader) > 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a Modelo 3                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTitulo       :=OemToAnsi("Cadastro de Linhas")
	cAliasEnchoice:="LBC"
	cAliasGetd    :="LBD"
	cAlias        :="LBD"
	cLinOk        :="AllwaysTrue()"
	cTudOk        :="AllwaysTrue()"
	cFieldOk      :="U_AltDesc()"
	
	nOpca := 0
	DEFINE MSDIALOG oDlg TITLE cTitulo From 9,0 to 28,80	of oMainWnd
	EnChoice(cAliasEnchoice,nReg,nOpcE,,,,aCpoEnchoice,{15,1,70,315},,3,,,,,,.F.)
	oGetDados := MsGetDados():New(75,1,143,315,nOpcG,cLinOk,cTudOk,"",.T.,,,,999,cFieldOk)
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| If(oGetDados:TudoOk() .And. obrigatorio(aGets, aTela) .and. FS_VldProd(), oDlg:End(), .f.), nOpca := 1},{|| nOpcA := 0, oDlg:End()})
Endif

if nOpcA == 1  // ok ou nao
	Grvcac02()
Else
	if Inclui
		RollBackSx8()
	Endif
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GrvCAC02   ³ Autor ³  Choite             ³ Data ³ 16/02/2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Gravacao                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvCAC02()

Local i
If nOpcG # 2 // nao for consulta
	
	dbselectArea("LBC")
	wProcura := dbseek(xFilial("LBC")+M->LBC_CODROT)
	If Inclui  .or. Altera
		RecLock("LBC",If(wProcura,.F.,.T.))
		LBC->LBC_FILIAL  := xFilial("LBC")
		LBC->LBC_CODROT  := M->LBC_CODROT
		LBC->LBC_DESC    := M->LBC_DESC
		LBC->LBC_CODCAM  := M->LBC_CODCAM
		MsUnlock()
		if Inclui
			ConfirmSx8()
		Endif
	Else  // exclusao
		
		dbselectarea("LBO")
		DbSetorder(5)
		If DbSeek(xFilial("LBO")+M->LBC_CODROT)
			MsgStop("Registro não pode ser excluido, existem lancamentos para esta Linha!!!", "Atenção")
			Return(.f.)
			dbSelectArea("LBC")
		Else
			RecLock("LBC",.F.,.T.)
			dbdelete()
			MsUnlock()
			WriteSx2("LBC")
		Endif
	Endif
	
	For i:=1 to len(aCols)
		DbSelectArea("LBB")
		DbSetOrder(1)
		If DbSeek(xFilial("LBB") + aCols[i,2])
			If Inclui .Or. Altera
				If !aCols[i,len(aCols[i])]
					RecLock("LBB", .F.)
					LBB->LBB_LINHA := M->LBC_CODROT + "-" + xFilial("LBD")
					MsUnLock()
				Else
					RecLock("LBB", .F.)
					LBB->LBB_LINHA := Space(Len(LBB->LBB_LINHA))
					MsUnLock()
				EndIf
			Else
				RecLock("LBB", .F.)
				LBB->LBB_LINHA := Space(Len(LBB->LBB_LINHA))
				MsUnLock()
			EndIf
		EndIf
		
		dbSelectArea("LBD")
		dbSetOrder(1)
		wProcura := dbseek(xFilial("LBD")+M->LBC_CODROT+aCols[i,1]+aCols[i,2])
		If Inclui  .or. Altera
			If aCols[i,len(aCols[i])] .And. wProcura // exclusao
				RecLock("LBD",.F.,.T.)
				dbdelete()
				MsUnlock()
				WriteSx2("LBD")
			Else
				
				If !aCols[i,len(aCols[i])]
					RecLock("LBD",If(wProcura,.F.,.T.))
					LBD->LBD_FILIAL  := xFilial("LBD")
					LBD->LBD_CODROT  := M->LBC_CODROT
					LBD->LBD_SEQ     := aCols[i,1]
					LBD->LBD_CODPRO  := aCols[i,2]
					MsUnlock()
				Endif
				
			Endif
		Else
			If wProcura  // opcao exclusao do menu
				RecLock("LBD",.F.,.T.)
				dbdelete()
				MsUnlock()
				WriteSx2("LBD")
			Endif
		Endif
	Next
Endif

Return(.T.)


// Cria descricao da Propriedade quando informado o codigo Manualmente (Sem F3)
///////////////////////////
User Function AltDesc()

if ReadVar() == "M->LBD_CODPRO"
	LBB->(dbGoTop())
	LBB->(DbSeek(xFilial("LBB")+M->LBD_CODPRO))
	aCols[n,3]  := LBB->LBB_DESC
	M->LBD_DESC := LBB->LBB_DESC
	aCols[n,4]  := LBB->LBB_NOMFOR
	M->LBD_NOMFOR:= LBB->LBB_NOMFOR
Elseif ReadVar() == "M->LBD_SEQ"
	M->LBD_SEQ  := StrZero(Val(M->LBD_SEQ),3)
	aCols[n,1]  := M->LBD_SEQ
Endif

Return(.T.)

//Cria sequencia automaticamente
User Function IncSeq()

If Inclui .Or. Altera
	If Altera .And. Empty(M->LBD_SEQ) .And. Type("ACOLS")=='A' .And. Len(aCols) > 1
		M->LBD_SEQ := Soma1(aCols[Len(aCols)-1,1],3)
	ElseIf Altera .And. !Empty(M->LBD_SEQ) .And. Type("ACOLS")=='A' .And. Len(aCols) > 1
		M->LBD_SEQ := Soma1(aCols[Len(aCols)-1,1],3)
	Else
		M->LBD_SEQ := Soma1(M->LBD_SEQ, Len(LBD->LBD_SEQ))
	EndIf
EndIf

Return(M->LBD_SEQ)


///////////////////////////
User Function VALPROP()

Local lRet   := .t.
Local nRegM0 := SM0->(recno())
Local cCodEP := SM0->(M0_CODIGO)
Local aArea  := GetArea()

If aScan(aCols, {| aVet | aVet[2] == M->LBD_CODPRO}) > 0
	MsgInfo("Propriedade ja cadastrada", "Atencao!")
	lRet := .F.
Else
	While !SM0->(eof())
		if cCodEP == SM0->(M0_CODIGO)
			dbSelectArea("LBD")
			dbSetOrder(3)
			if dbSeek(SM0->M0_CODFIL + M->LBD_CODPRO)
				if SM0->M0_CODFIL == xFilial("LBD")
					MsgInfo("Propriedade ja cadastrada na Linha: " + LBD->LBD_CODROT, "Atencao!")
				Else
					MsgInfo("Propriedade ja cadastrada na Linha: " + LBD->LBD_CODROT + " na filial: " + SM0->M0_CODFIL, "Atencao!")
				Endif
				lRet := .f.
				Exit
			Endif
		Endif
		SM0->(dbSkip())
	Enddo
EndIf

DbSelectArea("SM0")
Dbgoto(nRegM0)
RestArea(aArea)
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ VldProd   ³ Autor ³  Rogerio Faro       ³ Data ³ 29/03/2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao de Produtores                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_VldProd()
Local i
Local nTotItens := 0

If nOpcG # 2 // nao for consulta
	For i:=1 to len(aCols)
		If Inclui .Or. Altera
			If !aCols[i,len(aCols[i])]
				nTotItens++
			Endif
		Endif
	Next
Endif

Return(.T.)
