#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ QUAA071  ³ Autor ³wmanfre                  ³ Data ³ 12/06/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cadastro de Rotas                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Quata - PL8.43 - FS07529302 - Proposta 4                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.  ³  Data  ³ Bops ³ Manutencao Efetuada                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                ³  /  /  ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QUAA071()

//CHKTEMPLATE("COL")

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

nOpc:=0

aRotina := {{ OemToAnsi("Pesquisar"),	"axPesqui"	   	, 0 , 1	},;     
			{ OemToAnsi("Visualizar"),	'U_QuaRot1(2)'	, 0 , 2	},; 
			{ OemToAnsi("Incluir"),		'U_QuaRot1(3)'	, 0 , 3	},;
			{ OemToAnsi("Alterar"),		'U_QuaRot1(4)'	, 0 , 4	},;
			{ OemToAnsi("Excluir"),		'U_QuaRot1(5)'	, 0 , 5	} }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCadastro := OemToAnsi("Cadastro de Rotas") //
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
±±³Fun‡„o    ³ QuaRot1  ³ Autor ³  wmanfre            ³ Data ³ 12/06/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Tratamento do Cadastro de Linhas                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Quata - PL8.43 - FS07529302 - Proposta 4                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QuaRot1(nOpc)

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
Private cRestGet	:= "LBD_FILIAL#LBD_CODROT"
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis M->????? da Enchoice                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCpoEnchoice  :={}
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("LBC")
While !Eof().and.(x3_arquivo=="LBC")
	If X3USO(x3_usado).and.x3_nivel>0 .and. !Alltrim(X3_Campo) $ cCposRestr
		AADD(aCpoEnchoice,x3_campo)
	Endif
	wVar := "M->"+x3_campo
	&wVar:= CriaVar(x3_campo)
	dbSkip()
End

If nOpc != 3 // se nao for inclusao
	dbSelectArea("LBC")
	For nCntFor := 1 TO FCount()
		M->&(EVAL(bCampo,nCntFor)) := FieldGet(nCntFor)
	Next nCntFor
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria aHeader e aCols da GetDados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nUsado:=0
dbSelectArea("SX3")
dbSetOrder(1)

dbSeek("LBD")
While !Eof().And.(x3_arquivo=="LBD")
	
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
dbSelectArea("LBD")

if nOpc == 3 // Incluir
	
	aAdd(aCols,Array(nUsado+1))
	For nXa := 1 to Len(aHeader)
		aCols[1][nXa] := CriaVar(Trim(aHeader[nXa][2]),.T.)
	Next nXa
	aCols[1][nUsado+1] := .F.
	aCols[1][aScan(aHeader,{|x| Trim(x[2])=="LBD_SEQ"})] := "001"
	
Else
	dbSelectArea("LBD")
	dbSetOrder(1)
	dbSeek(xFilial("LBD")+M->LBC_CODROT)

	While !Eof() .And. xFilial("LBD") == LBD->LBD_FILIAL .And. LBD->LBD_CODROT == M->LBC_CODROT
	   aAdd(aCols,Array(nUsado+1))
	   nCols ++
   	   For nX := 1 To nUsado
	      If ( aHeader[nX][10] != "V")
	         aCols[nCols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
	      Else
	         aCols[nCols][nX] := CriaVar(aHeader[nX][2],.T.)
	         If !Empty( aHeader[nX][11] )
	         	cVar := aHeader[nX][11]
	         	aCols[nCols][nX] := &cVar
	         Endif	
	      Endif
	   Next nX
	   
	   aCols[nCols][nUsado+1] := .F.
	   
	   dbSelectArea("LBD")
	   dbSkip()
	End
//	aCols := adjcols(aCols, aHeader)
Endif

If Len(aHeader) > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a Modelo 3                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTitulo       :=OemToAnsi("Cadastro de Rotas")
	cAliasEnchoice:="LBC"
	cAliasGetd    :="LBD"                                
	cAlias        :="LBD"
	cLinOk        :="u_lOkq071()"
	cTudOk        :="u_tOkQ071()"
	cFieldOk      :="u_AltDes1()"

	aButtons:={}
	AAdd(aButtons, { "RELOAD"    ,{|| EscLinha() }, "Seleciona linhas da Rota." , "Sel.Linhas"  } )

	aSize := MsAdvSize()
	aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	
	aAdd(aObjects,{040,100,.T.,.F.})
	aAdd(aObjects,{060,100,.T.,.T.})
	
	aPosObj := MsObjSize(aInfo,aObjects)
	
	nOpca := 0
	DEFINE MSDIALOG oDlg TITLE cTitulo From  aSize[7],aSize[1] TO aSize[6],aSize[5]	of oMainWnd PIXEL
	EnChoice(cAliasEnchoice,nReg,nOpcE,,,,aCpoEnchoice,aPosObj[1],,3,,,,,,.F.)
	oGetDados := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcG,cLinOk,cTudOk,"+LBD_SEQ",.T.,,,,999,cFieldOk)
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| If(oGetDados:TudoOk() .And. obrigatorio(aGets, aTela) .and. FS_VldProd(), oDlg:End(), .f.), nOpca := 1},{|| nOpcA := 0, oDlg:End()},,aButtons)
Endif

if nOpcA == 1  // ok ou nao
	Grvcac02()
Endif

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GrvCAC02   ³ Autor ³  wmanfre            ³ Data ³ 13/06/2008 ³±±
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
Local nPosCodRot	:= 0
Local nPosSeq		:= 0
Local nPosPropri	:= 0

If nOpcG # 2 // nao for consulta
	
	dbselectArea("LBC")
	wProcura := dbseek(xFilial("LBC")+M->LBC_CODROT)
	If Inclui  .or. Altera
		If wProcura
			RecLock("LBC",.F.)
		Else
			RecLock("LBC",.T.)
			LBC->LBC_FILIAL  := xFilial("LBC")
			LBC->LBC_CODROT  := M->LBC_CODROT
		Endif		
		LBC->LBC_DESC    := M->LBC_DESC
		LBC->LBC_CODCAM  := M->LBC_CODCAM
		LBC->LBC_TTKMRT  := M->LBC_TTKMRT
		LBC->LBC_VLMIN   := M->LBC_VLMIN
		LBC->LBC_LINHAS  := M->LBC_LINHAS
		LBC->LBC_TES  	 := M->LBC_TES
		LBC->LBC_TESCOM	 := M->LBC_TESCOM
		MsUnlock()		
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

	nPosCodRot	:= ascan(aHeader, {|x| Upper(Alltrim(x[2])) == Upper(Alltrim("LBD_CODROT")) } )
	nPosSeq		:= ascan(aHeader, {|x| Upper(Alltrim(x[2])) == Upper(Alltrim("LBD_SEQ")) } )
	nPosTanque	:= ascan(aHeader, {|x| Upper(Alltrim(x[2])) == Upper(Alltrim("LBD_CODTAN")) } )
		
	dbSelectArea("LBD")
	dbSetOrder(1)
	wProcura := dbseek(xFilial("LBD")+M->LBC_CODROT)
	if wProcura
		While xFilial("LBD")+M->LBC_CODROT == LBD->(LBD_FILIAL+LBD_CODROT)
		    RecLock("LBD", .F.)
		    LBD->(dbDelete())
		    MsUnlock()
			WriteSx2("LBD")
			LBD->(dbSkip())
		End
	Endif


	For i:=1 to len(aCols)
		If Inclui  .or. Altera
			If !aCols[i,len(aCols[i])]
				RecLock("LBD",.T.)
				LBD->LBD_FILIAL  := xFilial("LBD")
				LBD->LBD_CODROT  := M->LBC_CODROT
				LBD->LBD_SEQ     := aCols[i,nPosSeq]
				LBD->LBD_CODTAN  := aCols[i,nPosTanque]
				For nXa := 1 to len(aHeader)
					nPosCpo := LBD->(Fieldpos(aHeader[nXa][2]))
					If nPosCpo <> 0
						LBD->(FieldPut(nPosCpo, aCols[i][nXa]))
					Endif
				Next nXa
				MsUnlock()
			Endif
		Endif
	Next
Endif

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³AltDes1    ³ Autor ³  wmanfre            ³ Data ³ 13/06/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de validação da ordem de captação                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AltDes1()
Local nPDDescr	:= ascan(aHeader, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_DESC"))})
Local nPOrdCap	:= ascan(aHeader, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_ORDCAP"))})
Local nPNomFor	:= ascan(aHeader, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_NOMFOR"))})
Local nPSeq		:= ascan(aHeader, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_SEQ"))})

If nPDDescr == 0 .or. nPOrdCap == 0 .or. nPNomFor == 0 .or. nPSeq == 0
	Return .T.
Endif

if ReadVar() == "M->LBD_CODTAN"
	LBF->(dbGoTop())
	LBF->(DbSeek(xFilial("LBF")+M->LBD_CODTAN))
	aCols[n,nPDDescr]  := U_RetPro(LBF->LBF_CODPRO, 1)
	M->LBD_DESC := U_RetPro(LBF->LBF_CODPRO, 1)
	aCols[n,nPNomFor]  := U_RetPro(LBF->LBF_CODPRO, 2)
	M->LBD_NOMFOR:= U_RetPro(LBF->LBF_CODPRO, 1)
Elseif ReadVar() == "M->LBD_ORDCAP"
	M->LBD_ORDCAP  := RIGHT("0000"+AllTrim(M->LBD_ORDCAP),4)
	aCols[n,nPOrdCap]     := M->LBD_ORDCAP
    
	For nI:=1 to Len(aCols)
		If nI != n .And. aCols[nI][nPOrdCap] == M->LBD_ORDCAP
			MsgInfo("Ordem de captação já cadastrada para a linha " + M->LBC_CODROT + ". Sequência " + aCols[nI][nPSeq], "Ordem já cadastrada." ) 
			M->LBD_ORDCAP := Space( TamSx3("LBD_ORDCAP")[1] )
			aCols[n,nPOrdCap]     := M->LBD_ORDCAP
		EndIf 
	Next nI
Endif

Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FS_VldProd³ Autor ³  Rogerio Faro       ³ Data ³ 29/03/2004 ³±±
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




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±ºPrograma  ³lOkq071    º Autor ³ wmanfre            º Data ³  12/06/01   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao de Linha Ok da Getdados                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function lOkq071()
Local lRet 		:= .T.
Local nPoslinh	:= ascan(aHeader, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODLIN"))})
Local nPosTanq	:= ascan(aHeader, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODTAN"))})

If Empty(aCols[n][nPosLinh]) .and. empty(aCols[n][nPosTanq])
	ApMsgAlert( OemToAnsi("Codigo de tanque e linha em branco, um dos dois tem qu ser informado!!"), OemToAnsi("Atenção") )
	lRet := .F.
Endif

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±ºPrograma  ³TOkq071    º Autor ³ wmanfre            º Data ³  12/06/01   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao de Tudo Ok da GetDados                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TOkq071()
Return(AllwaysTrue())



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NextRot   º Autor ³ wmanfre            º Data ³  12/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Quata - PL8.4 - Cadastro de linhas                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function NextRot()

Local cRet   	:= ""
Local aAreaAnt	:= GetArea()
Local cQuery	:= ""
cQuery := "Select Max(LBC_CODROT) as CODIGO "
cQuery += "From " + RetSqlName("LBC") + " LBC "
cQuery += "Where LBC_CODROT >= '100000' "
cQuery += " AND LBC_CODROT <= '999999' "
cQuery += " AND LBC.D_E_L_E_T_ = ' ' "

cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRB1", .T., .T.)
dbSelectArea("TRB1")

cRet := TRB1->CODIGO

dbCloseArea()

If !Empty(cRet) .and. Len(cRet) == 6
	cRet := soma1(cRet)
Else
	cRet := "100000"
Endif

RestArea(aAreaAnt)
Return (cRet)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EscLinha  º Autor ³ wmanfre            º Data ³  12/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Escolha das linhas para a getdados                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Quata - PL8.4 - Cadastro de linhas                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function EscLinha()
Local aArea			:= GetArea()
Local aLinhas		:= {}
Local _oDlg, oLbx
Local _lOk			:= .F.
Local nXa			:= 0

Private _oOk    	:= LoadBitMap( GetResources(), 'LBOK' )
Private _oNo    	:= LoadBitMap( GetResources(), 'LBNO' )
Private cMytit		:= 'Seleção de Linhas'
Private _nPosArq	:= 1


aLinhas := GetLin1(M->LBC_CODCAM, M->LBC_CODROT, M->LBC_LINHAS)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Tela de Dialogo                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Define Font _oFontBold Name 'Arial' Size 0, -13 Bold
Define Font _oFontNor  Name 'Arial' Size 0, -11
Define Font _oFontNorB Name 'Arial' Size 0, -11 Bold
If Len(aLinhas) > 0
	Define MSDialog _oDlg From 89, 98 To 430, 720 Title cMyTit Style DS_MODALFRAME Pixel Of oMainWnd
	
	// ListBox Dos Arquivos
	@  15, 10 ListBox oLbx Fields Header '', 'Linha', 'Descrição' Size 245, 142 of _oDlg Pixel;
	On DblClick ( aLinhas[ oLbx:nAt, 1] := !aLinhas[ oLbx:nAt, 1], oLbx:Refresh(),  _oDlg:Refresh() )
	oLbx:SetArray( aLinhas )
	oLbx:bLine    := { || { If( aLinhas[oLbx:nAt, 1], _oOk, _oNo ), aLinhas[oLbx:nAt, 2], aLinhas[oLbx:nAt, 3] } }  // Campos do LIST
	oLbx:lHScroll := .F.
	oLbx:cToolTip := cMyTit
	oLbx:nAt      := _nPosArq
	oLbx:Refresh()
	@ 15, 266 Button _oButOK Prompt '&Ok'    		Size 40, 10 Action (_lOk := .T., _oDlg:End() ) Message 'Confirmar as opções'    Of _oDlg Pixel
	@ 35, 266 Button _oButCld Prompt '&Cancela'    	Size 40, 10 Action (_lOk := .F., _oDlg:End() ) Message 'Cancelar as opções'    Of _oDlg Pixel
	
	Activate MSDialog _oDlg Centered
	
	If _lOk
		For nXa := 1 to len(aLinhas)
			IF aLinhas[nXa][1]
				aCols := InserLin(@M->LBC_LINHAS, aCols, aLinhas[nXa][2], ascan(aHeader, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODTAN"))}), aHeader )
			Else
				aCols := RetirLin(@M->LBC_LINHAS, aCols, aLinhas[nXa][2], ascan(aHeader, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODTAN"))}), aHeader )
			Endif
		Next nXa
		oDlg:refresh()
	Endif
Else
	ApMsgAlert( OemToAnsi("Não existem linhas disponiveis para inclusão"), OemToAnsi("Atenção") )
Endif
Return nil




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetLin1   º Autor ³ wmanfre            º Data ³  12/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Quata - PL8.4 - Cadastro de linhas                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetLin1(cCodCam, cCodRota, _cLinhas)
Local aRet 		:= {}
Local aAreaAnt 	:= GetArea()
Local cQuery	:= ""
Local lvar1		:= .F.
Local nPoslinh	:= ascan(aHeader, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODLIN"))})

cQuery := "SELECT PA7_CODLIN, PA7_DESC, PA7_CODTAN "
cQuery += "FROM " + RetSqlName("PA7") + " PA7 "
cQuery += "WHERE PA7.D_E_L_E_T_ = ' ' "
cQuery += " AND NOT EXISTS ( "
cQuery += " SELECT 1 FROM " + RetSqlName("LBC") + " LBC "
cQuery += " WHERE LBC_LINHAS LIKE '%' + PA7_CODLIN + '%' "
cQuery += " AND LBC.D_E_L_E_T_ = ' ' "
cQuery += " AND LBC.LBC_CODROT <> '" + alltrim(cCodRota) + "' "
cQuery += ") "  


cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRB2", .T., .T.)
dbSelectArea("TRB2")

While !eof()
	lVar1 := .F.
	If ascan( Acols, { |x| Alltrim(Upper(x[nPoslinh])) == Alltrim(Upper(TRB2->PA7_CODLIN)) } ) > 0
		lVAr1 := .T.
	Endif
	aadd( aRet, {lVar1, TRB2->PA7_CODLIN, TRB2->PA7_DESC, TRB2->PA7_CODTAN } )
	dbSkip()
End

dbSelectArea("TRB2")
dbCloseArea()

RestArea(aAreaAnt)
Return(aRet)




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³InserLin  º Autor ³ wmanfre            º Data ³  12/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Quata - PL8.4 - Cadastro de linhas                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function InserLin(cLinhas, aColsPvt, cCodLin, nPosTanque, aHeaderPvt, cCodTan)
Local aRet 		:= aClone(aColsPvt)
Local aAreaLBB 	:= LBB->(GetArea())
Local nPos1		:= 0
Local nPos2		:= 0
Local aTmp 		:= {}
Local nTamLin	:= 0
Local nPSeq		:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_SEQ"))})
Local nPCodTan	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODTAN"))})
Local nPNomFor	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_NOMFOR"))})
Local nPCodLin	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODLIN"))})
Local nPDesLin	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_DESLIN"))})
Local nPOrdCap	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_ORDCAP"))})
Local nPDDescr	:= ascan(aHeaderPVT, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_DESC"))})
Local nXa 		:= 0

If nPSeq == 0 .or. nPCodTan == 0 .or. nPNomFor == 0 .or. nPCodLin == 0 .or. ;
	nPDesLin == 0 .or. nPOrdCap == 0
	Return(aRet)
Endif

dbSelectArea("PA7")
dbSetOrder(1)

if dbSeek(xFilial("PA7")+cCodLin)
	dbSelectArea("LBF")
	dbSetOrder(1)
	If dbSeek( xFilial("LBF") + PA7->PA7_CODTAN )
		nTamLin := Len(aHeaderPvt) 
		nPos2 := ascan( aColsPVT, {|x| x[nPCodLin] == PA7->PA7_CODLIN} )    
		If nPos2 == 0
			aadd(aColsPVT, Array(nTamLin+1))
			nPos2 := Len(aColsPvt) 
		 	aColsPvt[nPos2][nPCodTan] 	:= " "
			aColsPvt[nPos2][nPDDescr] 	:= " "
			aColsPvt[nPos2][nPNomFor] 	:= " "
			aColsPvt[nPos2][nPCodLin] 	:= PA7->PA7_CODLIN
			aColsPvt[nPos2][nPDesLin] 	:= PA7->PA7_DESC
			aColsPvt[nPos2][nPOrdCap] 	:= strZero(nPos2,TamSX3("LBD_ORDCAP")[1])
			aColsPvt[nPos2][nPSeq] 		:= strZero(nPos2,TamSX3("LBD_SEQ")[1])		 	
			aColsPvt[nPos2][nTamLin+1]	:= .F.
		Endif
	Endif
Else
	msgAlert("NAO achei o codigo da linha","Nao Achou")
Endif
cLinhas := Alltrim(cLinhas)
// acrescenta o codigo da linha a variavel correspondente ao LBC_LINHAS
nPos1 := at(cCodLin, cLinhas)
If nPos1 = 0
	cLinhas += "#"+cCodLin
Endif

aTmp 		:= aClone(aColsPvt)
aRet 		:= {}
cFirstSeq 	:= strZero(1,TamSX3("LBD_SEQ")[1])
nTamLin 	:= Len(aHeaderPvt)

For nXa := 1 to len(aTmp) 
	If !aTmp[nXa][nTamLin + 1] .and. ( !empty(aTmp[nXa][nPCodTan]) .or. !empty(aTmp[nXa][nPCodLin]) )
		aadd(aRet, aClone(aTmp[nXa]))
		aRet[len(aRet)][nPSeq] := cFirstSeq
		cFirstSeq := Soma1(cFirstSeq)
	Endif
Next nXa   

If Len(aRet) == 0
	aadd(aRet, Array(nTamLin + 1))
	nXb := Len(aRet)
	For nXa := 1 to len(aHeaderPVT)
         aRet[nXb][nXa] := CriaVar(aHeaderPVT[nXa][2],.T.)
	Next nXa
    aRet[nXb][nTamLin + 1]  := .F. 
	aRet[nXb][nPSeq] 	:= strZero(nXb,TamSX3("LBD_SEQ")[1])		 	
Endif
	
RestArea(aAreaLBB)
Return(aRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetirLin  º Autor ³ wmanfre            º Data ³  12/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Quata - PL8.4 - Cadastro de linhas                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RetirLin(cLinhas, aColsPvt, cCodLin, nPosTanque, aHeaderPvt, cCodTan)
Local aRet 		:= {}
Local aArea 	:= GetArea()
Local nPos1		:= 0
Local nPos2		:= 0
Local aTmp 		:= aClone(aColsPvt)
Local nTamLin	:= 0
Local nXa 		:= 0
Local nPSeq		:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_SEQ"))})
Local nPCodTan	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODTAN"))})
Local nPNomFor	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_NOMFOR"))})
Local nPCodLin	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODLIN"))})
Local nPDesLin	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_DESLIN"))})
Local nPOrdCap	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_ORDCAP"))})


If nPSeq == 0 .or. nPCodTan == 0 .or. nPNomFor == 0 .or. nPCodLin == 0 .or. ;
	nPDesLin == 0 .or. nPOrdCap == 0
	Return(aRet)
Endif

nTamLin := Len(aHeaderPvt)

For nXa := 1 to Len(aTmp)
	If Alltrim(aTmp[nXa][nPCodLin]) <> Alltrim(cCodLin)
		aadd(aRet, aClone(aTmp[nXa]) )
	Endif
Next nXa

// acrescenta o codigo da linha a variavel correspondente ao LBC_LINHAS
nPos1 := at(cCodLin, cLinhas)
If nPos1 <> 0
	cLinhas := Alltrim(strTran(cLinhas, cCodLin, ""))
	cLinhas := strTran(cLinhas, "##", "#")
Endif

cLinhas := Alltrim(cLinhas)


If Len(aRet) == 0
	aadd(aRet, Array(nTamLin+1))
	nXb := Len(aRet)
	For nXa := 1 to len(aHeaderPVT)
         aRet[nXb][nXa] := CriaVar(aHeaderPVT[nXa][2],.T.)
	Next nXa
    aRet[nXb][nTamLin+1]  := .F. 
	aRet[nXb][nPSeq] 	:= strZero(nXb,TamSX3("LBD_SEQ")[1])		 	
Endif


RestArea(aArea)
Return(aRet)






Static function adjcols(aColsPVT, aHeaderPVT)

Local nPSeq		:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_SEQ"))})
Local nPCodTan	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODTAN"))})
Local nPNomFor	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_NOMFOR"))})
Local nPCodLin	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODLIN"))})
Local nPDesLin	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_DESLIN"))})
Local nXa 		:= 0

If nPSeq == 0 .or. nPCodTan == 0 .or. nPNomFor == 0 .or. nPCodLin == 0 .or. ;
	nPDesLin == 0 
	Return(aRet)
Endif

nTamLin := Len(aHeaderPvt) 

For nXa := 1 to len(aColsPVT)
	If	aColsPvt[nXa][nTamLin+1] == .F.

		aColsPvt[nXa][nPNomFor] 	:= U_RETPRO(aColsPVT[nXa][nPCodTan], 2)
		aColsPvt[nXa][nPDesLin] 	:= Posicione("PA7", 1, xFilial("PA7")+ aColsPVT[nXa][nPCodLin], "PA7_DESC")
	Endif
Next nXa	    
aRet := aClone(aColsPVT)
Return aRet



User Function VldEdit()
Local lRet := .T.
Local nXa := 0
Local nPCodTan	:= ascan(aHeader, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODTAN"))})

If len(aCols) >= 1
	for nXa := 1 to len(aCols)
		If !aCols[nXa][Len(aHeader)+1] .and. !Empty(aCols[nXa][nPCodTan])
			lRet := .F.
		Endif
	Next nXA
Endif
Return lRet


User Function RetPro(cCodTanque, nOption)
Local aAreaant := GetArea()
Local aAreaLBF := LBF->(GetArea())
Local aAreaLBB := LBB->(GetArea())

Local cRet := Space(TamSX3("LBB_DESC")[1])

Default nOption := 1

If !Empty(cCodTanque)
	dbSelectArea("LBF")
	dbSetOrder(1)
	if dbSeek( xFilial("LBF") + cCodTanque )
		dbSelectArea("LBB")
		dbsetOrder(1)
		If dbSeek( xFilial("LBB") + LBF->LBF_CODTAN )
			If nOption == 1
			    cRet := LBB->LBB_DESC
			Else
				cRet := Posicione( "SA2", 1, xFilial("SA2") + LBB->( LBB_CODFOR + LBB_LOJA ), "A2_NOME" )
			Endif	
		Endif
	Endif
Endif

RestArea(aAreaLBF)
RestArea(aAreaLBB)
RestArea(aAreaAnt)
Return(cRet)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EscTANQUE  º Autor ³ wmanfre           º Data ³  12/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Escolha das linhas para a getdados                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Quata - PL8.4 - Cadastro de linhas                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function EscTanque()
Local aArea			:= GetArea()
Local aTanques		:= {}
Local _oDlg, oLbx
Local _lOk			:= .F.
Local nXa			:= 0

Private _oOk    	:= LoadBitMap( GetResources(), 'LBOK' )
Private _oNo    	:= LoadBitMap( GetResources(), 'LBNO' )
Private cMytit		:= 'Seleção de Tanques'
Private _nPosArq	:= 1


aTanques := GetTan1( M->LBC_CODROT )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Tela de Dialogo                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Define Font _oFontBold Name 'Arial' Size 0, -13 Bold
Define Font _oFontNor  Name 'Arial' Size 0, -11
Define Font _oFontNorB Name 'Arial' Size 0, -11 Bold
If Len(aTanques) > 0
	Define MSDialog _oDlg From 89, 98 To 430, 720 Title cMyTit Style DS_MODALFRAME Pixel Of oMainWnd
	
	// ListBox Dos Arquivos
	@  15, 10 ListBox oLbx Fields Header '', 'Tanque', 'Descrição' Size 245, 142 of _oDlg Pixel;
	On DblClick ( aTanques[ oLbx:nAt, 1] := !aTanques[ oLbx:nAt, 1], oLbx:Refresh(),  _oDlg:Refresh() )
	oLbx:SetArray( aTanques )
	oLbx:bLine    := { || { If( aTanques[oLbx:nAt, 1], _oOk, _oNo ), aTanques[oLbx:nAt, 2], aTanques[oLbx:nAt, 3] } }  // Campos do LIST
	oLbx:lHScroll := .F.
	oLbx:cToolTip := cMyTit
	oLbx:nAt      := _nPosArq
	oLbx:Refresh()
	@ 15, 266 Button _oButOK Prompt '&Ok'    		Size 40, 10 Action (_lOk := .T., _oDlg:End() ) Message 'Confirmar as opções'    Of _oDlg Pixel
	@ 35, 266 Button _oButCld Prompt '&Cancela'    	Size 40, 10 Action (_lOk := .F., _oDlg:End() ) Message 'Cancelar as opções'    Of _oDlg Pixel
	
	Activate MSDialog _oDlg Centered
	
	If _lOk
		For nXa := 1 to len(atanques)
			IF atanques[nXa][1]
				aCols := InserTan(@M->LBC_LINHAS, aCols, aTanques[nXa][2], ascan(aHeader, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODTAN"))}), aHeader )
			Else
				aCols := RetirTan(@M->LBC_LINHAS, aCols, aTanques[nXa][2], ascan(aHeader, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODTAN"))}), aHeader )
			Endif
		Next nXa
		oDlg:refresh()
	Endif
Else
	ApMsgAlert( OemToAnsi("Não existem Tanques disponiveis para inclusão"), OemToAnsi("Atenção") )
Endif
Return nil




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetTan1   º Autor ³ wmanfre            º Data ³  12/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Quata - PL8.4 - Cadastro de linhas                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetTan1(cCodRota)
Local aRet 		:= {}
Local aAreaAnt 	:= GetArea()
Local cQuery	:= ""
Local lvar1		:= .F.
Local nPoslinh	:= ascan(aHeader, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODTAN"))})

cQuery := "SELECT LBF_CODTAN, LBB_DESC, A2_NOME "
cQuery += "FROM " + RetSqlName("LBF") + " LBF, "
cQuery += RetSqlName("LBB") + " LBB, "
cQuery += RetSqlName("SA2") + " SA2 "
cQuery += "WHERE LBF.D_E_L_E_T_ = ' ' "
cQuery += " AND LBB.D_E_L_E_T_ = ' ' "
cQuery += " AND SA2.D_E_L_E_T_ = ' ' "
cQuery += " AND LBB.LBB_CODPRO = LBF_CODPRO "
cQuery += " AND SA2.A2_COD = LBB_CODFOR "
cQuery += " AND SA2.A2_LOJA = LBB_LOJA "
cQuery += " AND NOT EXISTS ( "
cQuery += " SELECT 1 FROM " + RetSqlName("LBD") + " LBD "
cQuery += " WHERE LBD_CODTAN = LBF_CODTAN "
cQuery += " AND LBD.D_E_L_E_T_ = ' ' "
cQuery += " AND LBD.LBD_CODROT <> '" + alltrim(cCodRota) + "' "
cQuery += ") "  


cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRB2", .T., .T.)
dbSelectArea("TRB2")

While !eof()
	lVar1 := .F.
	If ascan( Acols, { |x| Alltrim(Upper(x[nPoslinh])) == Alltrim(Upper(TRB2->LBF_CODTAN)) } ) > 0
		lVAr1 := .T.
	Endif
	aadd( aRet, {lVar1, TRB2->LBF_CODTAN, TRB2->LBB_DESC, TRB2->A2_NOME } )
	dbSkip()
End

dbSelectArea("TRB2")
dbCloseArea()

RestArea(aAreaAnt)
Return(aRet)




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³InserTan  º Autor ³ wmanfre            º Data ³  12/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Quata - PL8.4 - Cadastro de linhas                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function InserTan(cLinhas, aColsPvt, cCodLin, nPosTanque, aHeaderPvt, cCodTan)
Local aRet 		:= aClone(aColsPvt)
Local aAreaLBB 	:= LBB->(GetArea())
Local nPos1		:= 0
Local nPos2		:= 0
Local aTmp 		:= {}
Local nTamLin	:= 0
Local nPSeq		:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_SEQ"))})
Local nPCodTan	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODTAN"))})
Local nPNomFor	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_NOMFOR"))})
Local nPCodLin	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODLIN"))})
Local nPDesLin	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_DESLIN"))})
Local nPOrdCap	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_ORDCAP"))})
Local nPDDescr	:= ascan(aHeaderPVT, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_DESC"))})
Local nXa 		:= 0

If nPSeq == 0 .or. nPCodTan == 0 .or. nPNomFor == 0 .or. nPCodLin == 0 .or. ;
	nPDesLin == 0 .or. nPOrdCap == 0
	Return(aRet)
Endif

		nTamLin := Len(aHeaderPvt) 
		nPos2 := ascan( aColsPVT, {|x| x[nPCodTan] == cCodTan} )    
		If nPos2 == 0
			aadd(aColsPVT, Array(nTamLin+1))
			nPos2 := Len(aColsPvt) 
		 	aColsPvt[nPos2][nPCodTan] 	:= cCodTan
			aColsPvt[nPos2][nPDDescr] 	:= " "
			aColsPvt[nPos2][nPNomFor] 	:= " "
			aColsPvt[nPos2][nPCodLin] 	:= PA7->PA7_CODLIN
			aColsPvt[nPos2][nPDesLin] 	:= PA7->PA7_DESC
			aColsPvt[nPos2][nPOrdCap] 	:= strZero(nPos2,TamSX3("LBD_ORDCAP")[1])
			aColsPvt[nPos2][nPSeq] 		:= strZero(nPos2,TamSX3("LBD_SEQ")[1])		 	
			aColsPvt[nPos2][nTamLin+1]	:= .F.
		Endif


dbSelectArea("PA7")
dbSetOrder(1)

if dbSeek(xFilial("PA7")+cCodLin)
	dbSelectArea("LBF")
	dbSetOrder(1)
	If dbSeek( xFilial("LBF") + PA7->PA7_CODTAN )
		cCodLin	:= PA7->PA7_CODLIN
		nTamLin := Len(aHeaderPvt) 
		nPos2 := ascan( aColsPVT, {|x| x[nPCodLin] == cCodLin} )    
	Endif
Else
	msgAlert("NAO achei o codigo da linha","Nao Achou")
Endif
cLinhas := Alltrim(cLinhas)
// acrescenta o codigo da linha a variavel correspondente ao LBC_LINHAS
nPos1 := at(cCodLin, cLinhas)
If nPos1 = 0
	cLinhas += "#"+cCodLin
Endif

aTmp 		:= aClone(aColsPvt)
aRet 		:= {}
cFirstSeq 	:= strZero(1,TamSX3("LBD_SEQ")[1])
nTamLin 	:= Len(aHeaderPvt)

For nXa := 1 to len(aTmp) 
	If !aTmp[nXa][nTamLin + 1] .and. ( !empty(aTmp[nXa][nPCodTan]) .or. !empty(aTmp[nXa][nPCodLin]) )
		aadd(aRet, aClone(aTmp[nXa]))
		aRet[len(aRet)][nPSeq] := cFirstSeq
		cFirstSeq := Soma1(cFirstSeq)
	Endif
Next nXa   

If Len(aRet) == 0
	aadd(aRet, Array(nTamLin + 1))
	nXb := Len(aRet)
	For nXa := 1 to len(aHeaderPVT)
         aRet[nXb][nXa] := CriaVar(aHeaderPVT[nXa][2],.T.)
	Next nXa
    aRet[nXb][nTamLin + 1]  := .F. 
	aRet[nXb][nPSeq] 	:= strZero(nXb,TamSX3("LBD_SEQ")[1])		 	
Endif
	
RestArea(aAreaLBB)
Return(aRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetirTan  º Autor ³ wmanfre            º Data ³  12/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Quata - PL8.4 - Cadastro de linhas                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RetirTan(cLinhas, aColsPvt, cCodLin, nPosTanque, aHeaderPvt, cCodTan)
Local aRet 		:= {}
Local aArea 	:= GetArea()
Local nPos1		:= 0
Local nPos2		:= 0
Local aTmp 		:= aClone(aColsPvt)
Local nTamLin	:= 0
Local nXa 		:= 0
Local nPSeq		:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_SEQ"))})
Local nPCodTan	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODTAN"))})
Local nPNomFor	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_NOMFOR"))})
Local nPCodLin	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_CODLIN"))})
Local nPDesLin	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_DESLIN"))})
Local nPOrdCap	:= ascan(aHeaderPvt, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBD_ORDCAP"))})


If nPSeq == 0 .or. nPCodTan == 0 .or. nPNomFor == 0 .or. nPCodLin == 0 .or. ;
	nPDesLin == 0 .or. nPOrdCap == 0
	Return(aRet)
Endif

nTamLin := Len(aHeaderPvt)

For nXa := 1 to Len(aTmp)
	If Alltrim(aTmp[nXa][nPCodLin]) <> Alltrim(cCodLin)
		aadd(aRet, aClone(aTmp[nXa]) )
	Endif
Next nXa

// acrescenta o codigo da linha a variavel correspondente ao LBC_LINHAS
nPos1 := at(cCodLin, cLinhas)
If nPos1 <> 0
	cLinhas := Alltrim(strTran(cLinhas, cCodLin, ""))
	cLinhas := strTran(cLinhas, "##", "#")
Endif

cLinhas := Alltrim(cLinhas)


If Len(aRet) == 0
	aadd(aRet, Array(nTamLin+1))
	nXb := Len(aRet)
	For nXa := 1 to len(aHeaderPVT)
         aRet[nXb][nXa] := CriaVar(aHeaderPVT[nXa][2],.T.)
	Next nXa
    aRet[nXb][nTamLin+1]  := .F. 
	aRet[nXb][nPSeq] 	:= strZero(nXb,TamSX3("LBD_SEQ")[1])		 	
Endif


RestArea(aArea)
Return(aRet)
