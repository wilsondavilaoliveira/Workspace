#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ QUAA018  ³ Autor ³Darlan A. Freitas Maciel ³ Data ³ 05/01/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cadastro de Tipos de Despesas.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Quata - PL8.9 - FS07529302 - Proposta 4                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.  ³  Data  ³ Bops ³ Manutencao Efetuada                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Priscila Prado ³13/06/08³ ---- ³ Inclusão da tabela PA8 (Itens)           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QUAA018
Private	nUsado		:= 0
Private cCadastro	:= "Tipo de Despesas"
Private cAlias		:= "LBR"
Private	aRotina		:= {	{ "Pesquisar"	, "AxPesqui" 		, 0 , 1 , 0 , nil },;	//"Pesquisar"
{ "Visualizar"	, "U_QA18PVis"	 	, 0 , 2 , 0 , nil },;	//"Visualizar"
{ "Incluir"		, "U_QA18Incl"		, 0 , 3 , 0 , nil },;	//"Incluir"
{ "Alterar"		, "U_QA18Alte"		, 0 , 4 , 0 , nil },;	//"Alterar"
{ "Excluir"		, "U_QA18Dele"		, 0 , 5 , 0 , nil } }	//"Excluir"

dbSelectArea( "LBR" )

mBrowse( ,,,,"LBR")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ QA18PVs  ºAutor  ³ Priscila Prado  º Data ³  13/06/08      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para visualizacao do cadastro                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Quata                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QA18PVis( cAlias, nRecNo, nOpc )
Local   nX      := 0
Local   nCols   := 0
Local nPosForn  := 0
Local nPosLoja  := 0
Private cTipDes	:= LBR->LBR_TIPDES
Private aHeader := {}
Private aCols   := {}
Private oGetD

// Monta o aHeader
CriaHeader()

nPosForn := aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="PA8_FORNEC"   })
nPosLoja := aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="PA8_LOJA"   })

// Monta o aCols    
dbSelectArea("PA8")
PA8->(dbSetOrder( 1 ))
PA8->(dbSeek( xFilial("PA8") + cTipDes ))
While PA8->(!EOF()) .AND. ( xFilial("PA8") + cTipDes ) == PA8->( PA8_FILIAL + PA8_TIPDES )
	aAdd( aCols, Array( nUsado + 1 ) )
	nCols++
	For nX := 1 To nUsado
		If ( aHeader[nX][10] != "V" )
			aCols[nCols][nX] := FieldGet( FieldPos( aHeader[nX][2] ) )
		ElseIf ( aHeader[nX][2] = "PA8_NOME" )
			aCols[nCols][nX] := Posicione("SA2",1,xFilial("SA2")+aCols[nCols][nPosForn]+aCols[nCols][nPosLoja],"A2_NREDUZ")
		Else
			aCols[nCols][nX] := CriaVar( aHeader[nX][2], .T. )
		EndIf
	Next nX
	aCols[nCols][nUsado + 1] := .F.
	PA8->(dbSkip())
EndDo

//Exibe tela
PA8Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ QA18Incl ºAutor  ³ Priscila Prado  º Data ³  13/06/08      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para inclusao do cadastro                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Quata                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QA18Incl( cAlias, nRecNo, nOpc )
Private aHeader   := {}
Private aCols     := {}
Private oGetD
Private INCLUI    := .T.

RegToMemory( 'LBR' , .T. )

// Monta o aHeader
CriaHeader()

// Monta o aCols
aAdd( aCols, Array( nUsado + 1 ) )
nUsado := 0
dbSelectArea( "SX3" )
dbSetOrder( 1 )
dbSeek( "PA8" )
While !EOF() .AND. SX3->X3_ARQUIVO == "PA8"
	If X3USO( SX3->X3_USADO ) .AND. cNivel >= SX3->X3_NIVEL .And. SX3->X3_CAMPO <> "PA8_TIPDES"
		nUsado++
		If  SX3->X3_CAMPO == "PA8_SEQUEN"
			aCols[1][nUsado] := '001'
		Else
			aCols[1][nUsado] := CriaVar( Trim( SX3->X3_CAMPO ), .T. )
		EndIf
	EndIf
	dbSkip()
Enddo
aCols[1][nUsado + 1] := .F.

//Exibe tela
If PA8Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )
//	Begin TransAction
	If PA8Grava( nOpc , )//Grava as tabelas LBR e PA8
		EvalTrigger()
		If __lSX8
			ConfirmSX8()
		EndIf
	EndIf
	//End TransAction
Else
	If __lSX8
		RollBackSX8()
	EndIf
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ QA18Alte ºAutor  ³ Priscila Prado  º Data ³  13/06/08      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para alteracao do cadastro                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Quata                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QA18Alte( cAlias, nRecNo, nOpc )
Local   nX        := 0
Local   nCols     := 0
Local   aAltera   := {}
Local nPosForn    := 0
Local nPosLoja    := 0
Private cTipDes		:= LBR->LBR_TIPDES
Private oGet      := NIL
Private aHeader   := {}
Private aCols     := {}
Private oGetD
Private ALTERA    := .T.

dbSelectArea( "LBR" )
dbSetOrder( 1 )
dbGoTo( nRecNo )
RegToMemory( 'LBR', .F. )

// Monta o aHeader
CriaHeader()

nPosForn := aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="PA8_FORNEC"   })
nPosLoja := aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="PA8_LOJA"   })

// Monta o aCols
dbSelectArea( "PA8" )
dbSetOrder( 1 )
dbSeek( xFilial("PA8") + cTipDes )
While !EOF() .AND. ( xFilial("PA8") + cTipDes ) == PA8->( PA8_FILIAL + PA8->PA8_TIPDES )
	aAdd( aCols, Array( nUsado + 1 ) )
	nCols++
	For nX := 1 To nUsado
		If ( aHeader[nX][10] != "V" )
			aCols[nCols][nX] := FieldGet( FieldPos( aHeader[nX][2] ) )
		ElseIf ( aHeader[nX][2] = "PA8_NOME" )
			aCols[nCols][nX] := Posicione("SA2",1,xFilial("SA2")+aCols[nCols][nPosForn]+aCols[nCols][nPosLoja],"A2_NREDUZ")
		Else
			aCols[nCols][nX] := CriaVar( aHeader[nX][2], .T. )
		EndIf
	Next nX
	aCols[nCols][nUsado + 1] := .F.
	dbSelectArea( "PA8" )
	aAdd( aAltera, Recno() )
	dbSkip()
EndDo

//Exibe tela
If  PA8Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )
//	Begin TransAction
	If PA8Grava( nOpc, aAltera, ) //Grava tabelas
		EvalTrigger()
		If __lSX8
			ConfirmSX8()
		EndIf
	EndIf
	//End TransAction
Else
	If __lSX8
		RollBackSX8()
	EndIf
EndIf

Return NIL



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ QA18Dele ºAutor  ³ Priscila Prado  º Data ³  13/06/08      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para exclusao do cadastro                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Quata                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QA18Dele( cAlias, nRecNo, nOpc )
Local   nX      := 0
Local   nCols   := 0
Local nPosForn  := 0
Local nPosLoja  := 0
Private cTipDes	:= LBR->LBR_TIPDES
Private aHeader := {}
Private aCols   := {}
Private oGetD

dbSelectArea( "PA8" )
dbSetOrder( 1 )
dbGoTo( nRecNo )
RegToMemory( 'LBR', .F. )

// Monta o aHeader
CriaHeader()

nPosForn := aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="PA8_FORNEC"   })
nPosLoja := aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="PA8_LOJA"   })

// Monta o aCols
dbSelectArea( "PA8" )
dbSetOrder( 1 )
dbSeek( xFilial("PA8") + cTipDes )
While !EOF() .AND. ( xFilial("PA8") + cTipDes ) == PA8->( PA8_FILIAL + PA8->PA8_TIPDES )
	aAdd( aCols, Array( nUsado + 1 ) )
	nCols++
	For nX := 1 To nUsado
		If ( aHeader[nX][10] != "V" )
			aCols[nCols][nX] := FieldGet( FieldPos( aHeader[nX][2] ) )
		ElseIf ( aHeader[nX][2] = "PA8_NOME" )
			aCols[nCols][nX] := Posicione("SA2",1,xFilial("SA2")+aCols[nCols][nPosForn]+aCols[nCols][nPosLoja],"A2_NREDUZ")
		Else
			aCols[nCols][nX] := CriaVar( aHeader[nX][2], .T. )
		EndIf
	Next nX
	aCols[nCols][nUsado + 1] := .F.
	dbSelectArea( "PA8" )
	dbSkip()
End

//Exibe tela
If  PA8Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )
//	Begin TransAction
	If PA8Grava( nOpc,, ) //Grava tabelas
		EvalTrigger()
		If __lSX8
			ConfirmSX8()
		EndIf
	EndIf
	//End TransAction
Else
	If __lSX8
		RollBackSX8()
	EndIf
EndIf


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ PA8Grava º Autor ³ Priscila Prado  º Data ³  13/06/08      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para gravacao dos dados dos cadastros               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Quata                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PA8Grava( nOpc, aAltera )
Local aArea    := GetArea()
Local lGravou  := .F.
Local nX       := 0
Local nI       := 0

nUsado    := Len( aHeader ) + 1

// Se For inclusao
If nOpc == 3
	// Grava os itens
	dbSelectArea( "PA8" )
	dbSetOrder( 1 )
	For nX := 1 To Len( oGetD:aCols )
		lDeletado := oGetD:aCols[nX][nUsado]

		If !lDeletado
			RecLock( "PA8" , .T. )
			For nI := 1 To Len( aHeader )
				FieldPut( FieldPos( Trim( aHeader[nI, 2] ) ), oGetD:aCols[nX, nI] )
			Next nI
			PA8->PA8_FILIAL := xFilial("PA8")
			PA8->PA8_TIPDES := M->LBR_TIPDES
			MsUnLock()
			lGravou := .T.
		EndIf
	Next

	If lGravou
		RecLock( "LBR" , .T. )
		LBR->LBR_FILIAL := xFilial("LBR")
		LBR->LBR_TIPDES := M->LBR_TIPDES
		LBR->LBR_DESC := M->LBR_DESC
		MsUnLock()
	Endif

EndIf

// Se For alteracao
If nOpc == 4
	// Grava os itens conforme as alteracoes
	dbSelectArea( "PA8" )
	dbSetOrder( 1 )
	For nX := 1 To Len( oGetD:aCols )
		lDeletado := oGetD:aCols[nX][nUsado]

		If nX <= Len( aAltera )
			dbGoTo( aAltera[nX] )
			RecLock( "PA8", .F. )

			If lDeletado
				dbDelete()
			EndIf
		Else
			If !lDeletado
				RecLock( "PA8", .T. )
			EndIf
		EndIf

		If !lDeletado
			For nI := 1 To Len( aHeader )
				FieldPut( FieldPos( Trim( aHeader[nI, 2] ) ), oGetD:aCols[nX, nI] )
			Next nI
			PA8->PA8_FILIAL := xFilial("PA8")
			PA8->PA8_TIPDES := cTipDes
			MsUnLock()
			lGravou := .T.
		EndIf

	Next
	If lGravou
		RecLock( "LBR" , .F. )
		LBR->LBR_DESC := M->LBR_DESC
		MsUnLock()
	Endif

EndIf

// Se For exclucao
If nOpc == 5

	// Deleta os Itens
	dbSelectArea( "PA8" )
	dbSetOrder( 1 )
	DbGoTop()
	DbSeek( xFilial("PA8") + cTipDes )

	While !EOF() .AND. ( xFilial("PA8") + cTipDes ) == PA8->( PA8_FILIAL + PA8_TIPDES )
		RecLock( "PA8", .F. )
		dbDelete()
		MsUnLock()
		dbSkip()
	End
	dbSelectArea( "LBR" )
	dbSetOrder( 1 )
	DbSeek( xFilial("LBR") + cTipDes )
	RecLock( "LBR", .F. )
	dbDelete()
	MsUnLock()
	lGravou := .T.

EndIf

RestArea( aArea )

Return lGravou


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ PA8Tela  ºAutor  ³ Priscila Prado  º Data ³  13/06/08      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para montagem da tela                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Quata                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PA8Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )
Local oDlg     := NIL
Local oFontBold
Local oGet1
Local oGet2
Local nOpcX   	:= Iif( INCLUI .Or. ALTERA , GD_INSERT+GD_DELETE+GD_UPDATE , 0 )
Local lOpcA    := .F.
Local lSoExibe := ( nOpc == 2 .OR. nOpc == 5 )
Local aButtons := {}
Local aSize    := {}
Local aObjects := {}

aSize   := MsAdvSize()
AAdd( aObjects, { 100, 040, .T., .T. } )
AAdd( aObjects, { 100, 060, .T., .T. } )
aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
aPosObj := MsObjSize( aInfo, aObjects,.T.)

Define Font oFontBold  Name "Arial" Size 0, -11 Bold
Define MsDialog oDlg Title cCadastro From aSize[7],0 to aSize[6],aSize[5]  Of oMainWnd PIXEL

EnChoice("LBR", nRecNo, nOpc,,,,, aPosObj[1])

oGetD:= MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcX,"u_PA8LinOK()",;
"u_PA8TdOK()","+PA8_SEQUEN",,000,999,"AllwaysTrue","","AllwaysTrue",oDlg,aHeader,aCols)

If lSoExibe
	Activate MsDialog oDlg Centered On Init EnchoiceBar( oDlg, { || lOpcA := .T., IIf( oGetD:TudoOk(), oDlg:End(), lOpcA := .F. ) }, { || oDlg:End() } )
Else
	Activate MsDialog oDlg Centered On Init EnchoiceBar( oDlg, { || lOpcA := .T., IIf( oGetD:TudoOk() .AND. oGetD:LinhaOk(), oDlg:End(), lOpcA := .F. ) }, { || lOpcA := .F., oDlg:End() },, aButtons )
EndIf

Return lOpcA


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³CRIAHEADERº Autor ³ Priscila Prado  º Data ³  03/04/08      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para criacao do aHeader                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Quata                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaHeader()
nUsado  := 0
aHeader := {}

// Carrega aHead
DbSelectArea("SX3")
dbSetOrder( 1 )
dbSeek( "PA8" )
While ( !EOF() .And. SX3->X3_ARQUIVO == "PA8" )
	If ( X3USO( SX3->X3_USADO ) .And. cNivel >= SX3->X3_NIVEL .And. !SX3->X3_CAMPO$"PA8_TIPDES/PA8_DESC" )
		Aadd(aHeader,{ AllTrim(X3Titulo()),;
		SX3->X3_CAMPO	,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID	,;
		SX3->X3_USADO	,;
		SX3->X3_TIPO	,;
		SX3->X3_F3 		,;
		SX3->X3_CONTEXT,;
		SX3->X3_CBOX	,;
		SX3->X3_RELACAO})
		nUsado++
	Endif
	dbSkip()
EndDo

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ PA8LinOK º Autor ³ Priscila Prado  º Data ³  03/04/08      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao LinhaOk da getdados                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Quata                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PA8LinOK()
Local aArea    := GetArea()
Local lRet     := .T.

//Verifica se a linha nao esta deletada
If oGetD:aCols[oGetD:nAt][nUsado + 1]
	Return lRet
EndIf

If Empty(oGetD:aCols[oGetD:nAt][2])
	ApMsgStop( "Preencha o campo Fornecedor." )
	lRet := .F.
EndIf

RestArea( aArea )

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ PA8TdOK  º Autor ³ Priscila Prado  º Data ³  03/04/08      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao TudoOk da getdados                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Quata                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PA8TdOK()
Local aArea      := GetArea()
Local lRet       := .T.
Local nCount     := 0
Local nI         := 0
Local nJ         := 0

// Verifica se tem pelo menos 1 item e se ele nao esta vazio
For nI := 1 To Len( oGetD:aCols )
	If !oGetD:aCols[nI][nUsado + 1]
		lVazio := .T.
		For nJ := 1 To nUsado
			lVazio := IIf( !Empty( oGetD:aCols[nI][nJ] ), .F., lVazio )
		Next nJ
		nCount += IIf( lVazio, 0, 1 )

		// Verifica se a ultima linha nao esta vazia
		If nI == Len( oGetD:aCols ) .AND. lVazio .AND. Len( oGetD:aCols ) > 1
			oGetD:aCols[nI][nUsado + 1] := .T.
		EndIf

	EndIf
Next nI

If  nCount == 0
	ApMsgStop( "Deve haver pelo menos registro cadastrado." )
	lRet := .F.
EndIf

RestArea( aArea )

Return lRet