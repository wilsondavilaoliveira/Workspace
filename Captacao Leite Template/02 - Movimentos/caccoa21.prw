#Include "Protheus.ch"    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOA21 ³ Autor ³ Ricardo Berti         ³ Data ³ 18/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Classificacao da Qualidade do Leite: GORD/PROTEINA/CCS/CBT ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                               		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CACCOA21()

Local cCadastro, cAlias
Local aCampos    := {}

//CHKTEMPLATE("COL")

Private nOpcg, nUsado, nCpoPad
Private cTitulo, cAliasEnchoice, cLinOK, cTudOK, cFieldOK
Private nReg, nOpc

nOpc:=0
aRotina := {{ OemToAnsi("Pesquisar") ,"axPesqui"     , 0 , 1   },; 
			{ OemToAnsi("Visualizar") ,'U_CACOL211(2)', 0 , 2   },; 
			{ OemToAnsi("Incluir") ,'U_CACOL211(3)', 0 , 3   },;   // Param=5 inclui e volta ao mbrowse
			{ OemToAnsi("Alterar") ,'U_CACOL211(4)', 0 , 4, 2},;  
			{ OemToAnsi("Excluir") ,'U_CACOL211(5)', 0 , 5, 1} } 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCadastro := OemToAnsi("Classificacao da Qualidade")
cAlias := "LJZ"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("LJZ")
aCampos := PCposBrw()

mBrowse( 6, 1,22,75,cAlias,aCampos,,,,,,,,2) // 14o.param = qtd.col.freeze

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACOL211 ³ Autor ³ Ricardo Berti         ³ Data ³ 18/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Tratamento da Classificacao da Qualidade do Leite³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CACol211(ExpN1)					                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ expN1: numero da opcao selecionada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                              		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACOL211(nOpc)

Local _ni, nCntFor
Local bCampo	:= { |nCPO| Field(nCPO) }
Local lPrima	:= .T.
LOCAL aSize     := {}
LOCAL aInfo     := {}
LOCAL aObjects  := {}
LOCAL aObj      := {}
Local nRecnoSX3	:= 0

Private aTELA[0][0]
Private aGETS[0]
Private aHeader :={} 
Private aCols   :={}

nReg          := 0
cAliasGetd    := "LJZ"
cAlias        := "LJZ"
cLinOk        := "AllwaysTrue()"
cTudOk        := "AllwaysTrue()"
cFieldOk      := "U__VCriter21()"
cTitulo       := OemToAnsi("Classificacao da Qualidade") 
cAliasEnchoice:= "LJZ"
cLinOk        := "AllwaysTrue()"

SetPrvt("wVar")
nUsado :=0

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("LJZ")

While !Eof().And.(x3_arquivo=="LJZ")
	If nUsado == 2  // ja fez o 2
		nRecnoSX3 := SX3->(RECNO())
		dbSetOrder(2) // Ordem de campo
		dbSeek("LBB_CODTAN")
		If !Eof() // .And. X3USO(x3_usado).And.cNivel>=x3_nivel
			nUsado++
			Aadd(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal,x3_valid,;
			x3_usado, x3_tipo, x3_arquivo, x3_context, x3_Relacao, x3_reserv } )
			wVar  := "M->"+x3_campo
			&wVar := CriaVar(x3_campo)
		Endif
		dbSetOrder(1) 
		dbGoto(nRecnoSX3)
	ElseIf X3USO(x3_usado).And.cNivel>=x3_nivel .And. ;
	(Alltrim(x3_campo) $ "LJZ_TIPOL/LJZ_CODROT/LJZ_CODPRO/LJZ_NOMFOR/LJZ_GORDUR/LJZ_PROTEI/LJZ_CCS/LJZ_CBT/LJZ_PAGQUA/LJZ_RESGOR/LJZ_RESPRO/LJZ_RESCCS/LJZ_RESCBT")
		nUsado++
		Aadd(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,x3_valid,;
		x3_usado, x3_tipo, x3_arquivo, x3_context, x3_Relacao, x3_reserv } )
		wVar  := "M->"+x3_campo
		&wVar := CriaVar(x3_campo)
	Endif
	dbSkip()
Enddo

// Adiciona campos de usuario ao aHeader
nCpoPad := nUsado
dbSeek("LJZ")
While !Eof().And.(X3_ARQUIVO == "LJZ")
	If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .And. X3_PROPRI == "U"
		nUsado++
		Aadd(aHeader,{ TRIM(X3Titulo()), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL,X3_VALID,;
		X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT, X3_RELACAO, X3_RESERV } )
		wVar  := "M->"+X3_CAMPO
		&wVar := CriaVar(X3_CAMPO)
	EndIf
	dbSkip()
EndDo

aCols:={Array(nUsado+1)}
aCols[1,nUsado+1]:=.F.
For _ni:=1 to nUsado
	aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
Next

if nOpc == 3 // Incluir
	nOpcE := 4
	nOpcG := 4
elseif nOpc == 4 // Alterar
	nOpcE := 4
	nOpcG := 4
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
LBB->(dbSetOrder(1))
LBB->(dbSeek(xFilial("LBB")+LJZ->LJZ_CODPRO))
M->LBB_CODTAN := LBB->LBB_CODTAN

dbSelectArea("LJZ")
For nCntFor := 1 TO FCount()
	M->&(EVAL(bCampo,nCntFor)) := FieldGet(nCntFor)
Next

if Inclui
	M->LJZ_DATCLQ := Ctod("")
EndIf

nOpca       := 0

aSize := MsAdvSize()

AAdd( aObjects, { 000, 008, .T., .T. } )
AAdd( aObjects, { 030, 100, .T., .T. } )

aInfo := { aSize[1],aSize[2],aSize[3],aSize[4],3,3 }
aObj  := MsObjSize( aInfo, aObjects, .T. )

DEFINE MSDIALOG oDlg TITLE cTitulo From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
@ aObj[01,01],004 SAY OemToAnsi("Data Referencia") SIZE 47,8 OF oDlg PIXEL COLOR CLR_BLUE 
@ aObj[01,01],048 MSGET oDatClc VAR M->LJZ_DATCLQ PICTURE "@D" VALID GetDCAC21(@lPrima) SIZE 47,4 PIXEL COLOR CLR_BLACK When Inclui .And. lPrima
oGetDados := MsGetDados():New(aObj[2,1],aObj[2,2],aObj[2,3],aObj[2,4],nOpcG,cLinOk,cTudOk,"",.T.,,,,,cFieldOk) // 29,1,249,386
If ! Inclui
	GetDCAC21(@lPrima)
Endif
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca := 1,oDlg:End()},{|| nOpca := 0, oDlg:End() })

if nOpca == 1
	GrvCAC21()
Endif

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ GETDCAC21³ Autor ³ Ricardo Berti         ³ Data ³ 18/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao que administra os campos digitados na GetDados      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GetDCac21(ExpL1) 				                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1: so' alimenta acols qdo.chamada pela 1a.vez (.T.)	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.. / .F.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CACOL211 - Cooperativa de Leite                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GETDCAC21(lPrima)

Local _ni, nX
Local i
Local lContinua := .T.
Local c
Local nCont
Local nContfim 

Local aColss

aCols	 := {}
cTipoL	 := "  "

if Inclui
	
	DbSelectArea("LJZ") //Historico da classificacao da Qualidade do leite
	DbSetOrder(1)
	if dbSeek( xFilial("LJZ") + Left(Dtos(M->LJZ_DATCLQ),6) )
		MsgInfo(OemToAnsi("Ja existe analise da qualidade no mês (11/11/05)...")+" ("+Dtoc(LJZ->LJZ_DATCLQ)+")","Atencao!")
		lContinua = .f.
	Endif

	If lContinua

		DbSelectArea("LBO") // Entrada do Leite
		DbSetOrder(2)  // DT.ENTRADA DO LEITE

		Set SoftSeek On
		if !dbSeek(xFilial("LBO") + Left( Dtos(M->LJZ_DATCLQ), 6 )  )
			MsgInfo("Nenhuma entrada de leite encontrada no mês","Atencao!")
			lContinua = .f.
		EndIf
		Set SoftSeek Off

		If lContinua
			nCont	 :=0

			dbSelectArea("LBO")
			while !eof() .and. xFilial("LBO") == LBO->LBO_FILIAL .and. Left(Dtos(M->LJZ_DATCLQ),6) == Left(Dtos(LBO->LBO_DATENT),6)
				
				If Ascan(aCols,{|x| x[4] == LBO->LBO_CODPRO}) == 0
					nCont++
					LBB->(dbSetOrder(1))
					LBB->(dbSeek(xFilial("LBB")+LBO->LBO_CODPRO))
					aAdd(aCols,Array(nUsado+1))
		
					aCols[nCont, 5] := POSICIONE("SA2",1,xFilial("SA2")+LBB->LBB_CODFOR,"A2_NOME") // LBB->LBB_DESC
					aCols[nCont, 4] := LBO->LBO_CODPRO
					aCols[nCont, 3] := LBB->LBB_CODTAN
					aCols[nCont, 2] := LBO->LBO_CODROT
					aCols[nCont, 1] := LBB->LBB_TIPOL
					aCols[nCont, 6] := CriaVar("LJZ_GORDUR",.F.)
					aCols[nCont, 7] := CriaVar("LJZ_PROTEI",.F.)
					aCols[nCont, 8] := CriaVar("LJZ_CCS",.F.)
					aCols[nCont, 9] := CriaVar("LJZ_CBT",.F.)
					aCols[nCont,10] := CriaVar("LJZ_PAGQUA",.F.)
					aCols[nCont,11] := CriaVar("LJZ_RESGOR",.F.)
					aCols[nCont,12] := CriaVar("LJZ_RESPRO",.F.)
					aCols[nCont,13] := CriaVar("LJZ_RESCCS",.F.)
					aCols[nCont,14] := CriaVar("LJZ_RESCBT",.F.)
					aCols[nCont,nUsado+1]:=.F.
					If nUsado > nCpoPad
						For nX := (nCpoPad+1) To Len(aHeader)
							aCols[nCont,nX] := CriaVar(aHeader[nX,2],.F.)
						Next nX
					EndIf
				EndIf
	
				dbSkip()
			Enddo

		EndIf
	EndIf
	
//aqui - fazer sort do acols conf. ordem selecionada
			
Else
	
	dbSelectArea("LJZ")

//aqui	abrir indice conf. ordem selecionada ou fazer o mesmo sort acima, apos
	dbSetOrder(1)   
	
	dbSeek(xFilial("LJZ")+Dtos(M->LJZ_DATCLQ))

	//aqui - inserir query
	
	While LJZ->LJZ_FILIAL == xFilial("LJZ") .and. !eof() .and. M->LJZ_DATCLQ == LJZ->LJZ_DATCLQ
		
		LBB->(dbSetOrder(1))
		LBB->(dbSeek(xFilial("LBB")+LJZ->LJZ_CODPRO))

		AADD(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
			if _ni == 5
				aCols[Len(aCols),_ni] := POSICIONE("SA2",1,xFilial("SA2")+LBB->LBB_CODFOR,"A2_NOME") // LBB->LBB_DESC
			Elseif _ni == 1
				aCols[Len(aCols),_ni] := LBB->LBB_TIPOL
			Elseif _ni == 2
				aCols[Len(aCols),_ni] := LJZ->LJZ_CODROT
			Elseif _ni == 3
				aCols[Len(aCols),_ni] := LBB->LBB_CODTAN
			Elseif _ni == 4
				aCols[Len(aCols),_ni] := LJZ->LJZ_CODPRO
			Elseif _ni == 6
				aCols[Len(aCols), _ni] := LJZ->LJZ_GORDUR
			Elseif _ni == 7
				aCols[Len(aCols), _ni] := LJZ->LJZ_PROTEI
			Elseif _ni == 8
				aCols[Len(aCols), _ni] := LJZ->LJZ_CCS
			Elseif _ni == 9
				aCols[Len(aCols), _ni] := LJZ->LJZ_CBT
			Elseif _ni == 10
				aCols[Len(aCols), _ni] := (LJZ->LJZ_RESGOR +LJZ->LJZ_RESPRO +LJZ->LJZ_RESCCS +LJZ->LJZ_RESCBT)
			Elseif _ni == 11
				aCols[Len(aCols), _ni] := LJZ->LJZ_RESGOR
			Elseif _ni == 12
				aCols[Len(aCols), _ni] := LJZ->LJZ_RESPRO
			Elseif _ni == 13
				aCols[Len(aCols),_ni] := LJZ->LJZ_RESCCS
			Elseif _ni == 14
				aCols[Len(aCols),_ni] := LJZ->LJZ_RESCBT
			Else                               
				aCols[Len(aCols),_ni] := If(aHeader[_ni,10] # "V",FieldGet(FieldPos(aHeader[_ni,2])),CriaVar(aHeader[_ni,2]))
			Endif
		Next
		aCols[Len(aCols),nUsado+1]  := .F.
		dbSkip()
		
	Enddo

Endif

If lContinua
	AcolsS := {}
	For i = 1 to Len(aCols)
		if !aCols[i,1] == Nil
			aadd(aColsS,aCols[i])
		Endif
	Next
	aCols := aColsS
	
	if Type("aCols[1,1]") # "U"
		oGetDados:oBrowse:Refresh()
		oGetDados:nMax:=Len(aCols) // maximo de linhas por getdados de entrada.
	else
		msgStop("Nao existem lancamentos nesta data!!!")
		lContinua := .F.
		
	Endif
EndIf
If lContinua
	lPrima := .F.
EndIf


Return(lContinua)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ GrvCAC21  ³ Autor ³ Ricardo Berti         ³ Data ³ 18/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Gravacao                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvCAC21()

Local i, nX
Local lGravou 
Local wProcura
Local nValGOR := 0
Local nValPRO := 0
Local nValCCS := 0
Local nValCBT := 0
Local cTipoL  := " "

If nOpcG # 2 //Se nao for consulta
	
	For i:=1 to len(aCols)

		lGravou := .F.		
		nValGOR := 0
		nValPRO := 0
		nValCCS := 0
		nValCBT := 0
        cTipoL 	:= "  "
		
		dbselectArea("LJZ")
		dbsetorder(1)
		wProcura := dbseek(xFilial("LJZ")+Dtos(M->LJZ_DATCLQ) + aCols[i][4] ) 
		If ( Inclui  .or. Altera ) .And. ;
			.Not. ( aCols[i,len(aCols[i])] .And. wProcura ) //neste caso alterou excluindo
				
			If !aCols[i,len(aCols[i])]
				LBB->(dbSetOrder(1))
				LBB->(dbSeek(xFilial("LBB")+aCols[i][4]))  // CODPRO
				RecLock("LBB",.F.)
				cTipoL := LBB->LBB_TIPOL
				
				/*
				ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
				RECalcula os resultados pela Tab. de Criterios da Qualidade
				ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
				*/
				nValGOR  := QuaCAL21(SuperGetMv("MV_CTABGOR"),cTipoL,aCols[i][6] )
				nValPRO  := QuaCAL21(SuperGetMv("MV_CTABPRO"),cTipoL,aCols[i][7] )
				nValCCS  := QuaCAL21(SuperGetMv("MV_CTABCCS"),cTipoL,aCols[i][8] )
				nValCBT  := QuaCAL21(SuperGetMv("MV_CTABCBT"),cTipoL,aCols[i][9] )
				
				dbselectArea("LJZ")
				RecLock("LJZ",If(wProcura,.F.,.T.))
				LJZ->LJZ_FILIAL  := xFilial("LJZ")
				LJZ->LJZ_CODROT  := aCols[i][2] 
				LJZ->LJZ_TIPOL   := LBB->LBB_TIPOL
				LJZ->LJZ_DATCLQ  := M->LJZ_DATCLQ
				LJZ->LJZ_CODPRO  := aCols[i][4]
				LJZ->LJZ_DATCLA  := dDataBase
				LJZ->LJZ_GORDUR  := aCols[i][6] 
				LJZ->LJZ_PROTEI  := aCols[i][7] 
				LJZ->LJZ_CCS     := aCols[i][8] 
				LJZ->LJZ_CBT     := aCols[i][9] 
				LJZ->LJZ_RESGOR  := nValGOR
				LJZ->LJZ_RESPRO  := nValPRO
				LJZ->LJZ_RESCCS  := nValCCS
				LJZ->LJZ_RESCBT  := nValCBT
				LJZ->LJZ_PAGQUA  := nValGOR+nValPRO+nValCCS+nValCBT
				// Tratamento para gravacao de campos de usuario
				If nUsado > nCpoPad
					For nX := (nCpoPad+1) To Len(aHeader)
						LJZ->&(aHeader[nX,2]) := aCols[i,nX]
					Next nX
				EndIf

				dbselectArea("LBB")
				LBB->LBB_GORDUR  := aCols[i][6] 
				MsUnlock()
				lGravou := .T.
				
				dbselectArea("LJZ")
				MsUnlock()
						
			Endif
			
		//Else  // Excluindo
		ElseIf nOpcG == 5 // nao pode excluir na getdados, so exclui todos

			dbselectArea("LJZ")
			RecLock("LJZ",.F.)
			dbdelete()
			MsUnlock()
        
		Endif
		
	Next
	
Endif

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VCriter21³ Autor ³ Ricardo Berti         ³ Data ³ 27/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualiza Campos na Tela (aCols)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ COL_LEI - Cooperativa de Leite                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function _VCRITER21()

Local nValGOR
Local nValPRO
Local nValCCS
Local nValCBT
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
Calcula os resultados pela Tabela de Criterios da Qualidade
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
nValGOR		:= If(ReadVar()=="M->LJZ_GORDUR",QuaCAL21(SuperGetMv("MV_CTABGOR"),aCols[n][1],M->LJZ_GORDUR ), aCols[n][11] )
nValPRO		:= If(ReadVar()=="M->LJZ_PROTEI",QuaCAL21(SuperGetMv("MV_CTABPRO"),aCols[n][1],M->LJZ_PROTEI ), aCols[n][12] )
nValCCS		:= If(ReadVar()=="M->LJZ_CCS"   ,QuaCAL21(SuperGetMv("MV_CTABCCS"),aCols[n][1],M->LJZ_CCS    ), aCols[n][13] )
nValCBT		:= If(ReadVar()=="M->LJZ_CBT"   ,QuaCAL21(SuperGetMv("MV_CTABCBT"),aCols[n][1],M->LJZ_CBT    ), aCols[n][14] )

aCols[n,6]	:= If(ReadVar()=="M->LJZ_GORDUR",M->LJZ_GORDUR, aCols[n,6] )
aCols[n,7]	:= If(ReadVar()=="M->LJZ_PROTEI",M->LJZ_PROTEI, aCols[n,7] )
aCols[n,8]	:= If(ReadVar()=="M->LJZ_CCS"   ,M->LJZ_CCS   , aCols[n,8] )
aCols[n,9]	:= If(ReadVar()=="M->LJZ_CBT"   ,M->LJZ_CBT   , aCols[n,9] )

aCols[n,11]	:= If(ReadVar()=="M->LJZ_GORDUR",nValGOR, aCols[n,11] )
aCols[n,12]	:= If(ReadVar()=="M->LJZ_PROTEI",nValPRO, aCols[n,12] )
aCols[n,13]	:= If(ReadVar()=="M->LJZ_CCS"   ,nValCCS, aCols[n,13] )
aCols[n,14]	:= If(ReadVar()=="M->LJZ_CBT"   ,nValCBT, aCols[n,14] )

aCols[n,10]	:= aCols[n,11]+aCols[n,12]+aCols[n,13]+aCols[n,14]  // nValGOR+nValPRO+nValCCS+nValCBT

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ QuaCAL21  ³ Autor ³ Ricardo Berti         ³ Data ³ 18/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Calculo do valor de acresc/desc. no litro do leite³±±
±±³          ³ com base no criterio (GOR/PRO/CCS/CBT) e no tipo do leite   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExprN1 := QuaCAL21( ExprC1, ExprC2, ExprN2 ) 			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExprC1 = Cod.da Tab.de Criterios da Qualidade	   	 	   ³±±
±±³          ³ ExprC2 = Tipo do Leite                            	 	   ³±±
±±³          ³ ExprN2 = Valor ref. a Analise do Criterio da Qualidade      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExprN1 = valor de acresc/desc. no litro do leite			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QuaCAL21( cTabQua, cTipoL, nValor)

Local nResul	:= 0
Local aArea		:= GetArea()
Local nTamChave := Len(CriaVar("LJY_CODQUA"))  // Adequa nome da tabela ao tam.do campo

cTabQua := Left(cTabQua+Space(nTamChave),nTamChave)

dbselectArea("LJY") // Tabela Criterios da Qualidade
dbSetOrder(1)
dbseek( xFilial("LJY")+cTabQua+cTipoL )
Do While !Eof() .And. ;
	( LJY->LJY_FILIAL+LJY->LJY_CODQUA+LJY->LJY_TIPOL = xFilial("LJY")+cTabQua+cTipoL )
	If nValor >= LJY_VInic .And. nValor <= LJY_VFinal
	   nResul := LJY_VResul
  	   Exit
    EndIf
	dbSkip()
EndDo
RestArea(aArea)

Return(nResul)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ PCposBrw ³Autor  ³Ricardo Berti          ³ Data ³ 05/01/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Trata alguns campos e a seq.a serem exibidos na mBrowse	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PCposBrw() 	    				                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpA1 = array aCampos = campos prioritarios exibidos		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ COL_LEI Cooperativa de Graos                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PCposBrw()

Local aArea		:= GetArea()
Local aCampos	:= {}
//Local nI		:= 0
//Local nRecnoSX3	:= 0

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("LJZ")
While !Eof().And.(x3_arquivo=="LJZ")
		If Alltrim(x3_campo) == "LJZ_DATCLQ"
			AAdd(aCampos,  { AllTrim(X3Titulo()) ,"LJZ_DATCLQ"}) //AAdd(aCampos,  {OemToAnsi("Dt.Refer.") ,"LJZ_DATCLQ"})
		ElseIf Alltrim(x3_campo) == "LJZ_CODPRO"
			AAdd(aCampos,  { AllTrim(X3Titulo()) ,"LJZ_CODPRO"})
		EndIf
		dbSkip()
Enddo

RestArea(aArea)

Return(aCampos)
