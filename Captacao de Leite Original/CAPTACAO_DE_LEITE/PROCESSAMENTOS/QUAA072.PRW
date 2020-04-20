#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ QUAA072  ³ Autor ³ wmanfre                 ³ Data ³ 24/06/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cadastro de Linhas                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Quata - PL8.4 - FS07529302 - Proposta 4                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.  ³  Data  ³ Bops ³ Manutencao Efetuada                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                ³  /  /  ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QUAA072()

//Variaveis privadas usadas no modelo 3
Private AROTINA,CCADASTRO,CALIAS1
Private CTITULO
Private NREG,NOPC

aRotina := {{ OemToAnsi("Pesquisar"),"axPesqui"	   	, 0 , 1	},;     && Pesquisar //"Pesquisar"
			{ OemToAnsi("Ordenar")	,'U_Quaa72m()'	, 0 , 4	} }  	&& Excluir //"Excluir"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCadastro := OemToAnsi("Ordem de Captação") //"Cadastro de Linhas"
cAlias1    := "PA7"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse( 6, 1,22,75,"PA7")

Return Nil


User Function Quaa72m(cAlias, nReg, nOpc)
Local aAreaAnt 	:= GetArea()
Local aHeadL	:= {}
Local aColL		:= {}
Local aRestr	:= {}
Local aInclud	:= {}
Local aAlter 	:= {}

Local nOrder	:= 7
Local cChave    := ""
Local bWhile    := {|| }
Local cLinha	:= PA7->PA7_CODLIN
Local cDescr	:= PA7->PA7_DESC
Local lOk		:= .F.

aadd(aInclud, "LBB_CODPRO" )
aadd(aInclud, "LBB_DESC" )
aadd(aInclud, "LBB_ORDLIN" )

Aadd( aAlter, "LBB_ORDLIN" )


// Nonta o Aheader
aHeadL := RetAhead("LBB", aRestr, aInclud)

cChave 	:= xFilial("LBB")+cLinha
bWhile  :=  {|| LBB->( LBB_FILIAL + LBB_LINHA ) }

aColL := RetAcol("LBB", nOrder, cChave, bWhile, aHeadL )

lOk := _Mytela(nOpc, aHeadL, aColL, cLinha, cDescr, aAlter)

RestArea(aAreaAnt)
Return nil




Static Function RetAhead(cAlias, aRestr, aInclud)
Local aHeadL 	:= {}
Local aArea 	:= GetArea()
Local aAreaSX3	:= SX3->(GetArea())
Local nXa		:= 0
Local nPos		:= 0
Local nPos1		:= 0
Local cRestr	:= ""
Local cInclui	:= ""
Local nUsado	:= 0

Default aRestr 		:= {}
Default aInclud 	:= {}

// Carrega aHeader

aHeadL := {}

cInclui := ""
For nXa := 1 to len( aInclud )
	cInclui += aInclud[nXa] + "#"
next nXa
If Empty(cInclui)
	cInclui := " "
Endif

cRestr := ""
For nXa := 1 to len( aRestr )
	cRestr += aRestr[nXa] + "#"
next nXa
If Empty(cRestr)
	cRestr := " "
Endif

DbSelectArea("SX3")
dbSetOrder(1)

If dbSeek( cAlias ) 	// encontrou o Alias solicitado

	While !eof() .and. Alltrim(Upper(cAlias)) == Alltrim(Upper(SX3->X3_ARQUIVO))
	
		If len(aInclud) > 0
			If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .And. Alltrim(SX3->X3_CAMPO)$cInclui
				nUsado++
				AADD(aHeadL,{ TRIM(X3Titulo()) 		,;
		    		            SX3->X3_CAMPO       ,;
		        		        SX3->X3_PICTURE     ,;
		        	    	    SX3->X3_TAMANHO     ,; 
		        	        	SX3->X3_DECIMAL     ,; 
			    	            SX3->X3_VALID       ,;
		    	   	         	SX3->X3_USADO       ,;
		    	   	         	SX3->X3_TIPO        ,;
		    	            	SX3->X3_ARQUIVO     ,;
		    	            	SX3->X3_CONTEXT     })
			Endif
		Elseif Len(aRestr) > 0
			If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .And. !Alltrim(SX3->X3_CAMPO)$cRestr
				nUsado++
				AADD(aHeadL,{ TRIM(X3Titulo()) 		,;
		    		            SX3->X3_CAMPO       ,;
		        		        SX3->X3_PICTURE     ,;
		        	    	    SX3->X3_TAMANHO     ,; 
		        	        	SX3->X3_DECIMAL     ,; 
			    	            SX3->X3_VALID       ,;
		    	   	         	SX3->X3_USADO       ,;
		    	   	         	SX3->X3_TIPO        ,;
		    	            	SX3->X3_ARQUIVO     ,;
		    	            	SX3->X3_CONTEXT     })
			Endif
		Else
			If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
				nUsado++
				AADD(aHeadL,{ TRIM(X3Titulo()) 		,;
		    		            SX3->X3_CAMPO       ,;
		        		        SX3->X3_PICTURE     ,;
		        	    	    SX3->X3_TAMANHO     ,; 
		        	        	SX3->X3_DECIMAL     ,; 
			    	            SX3->X3_VALID       ,;
		    	   	         	SX3->X3_USADO       ,;
		    	   	         	SX3->X3_TIPO        ,;
		    	            	SX3->X3_ARQUIVO     ,;
		    	            	SX3->X3_CONTEXT     })
			Endif
		Endif				
		SX3->(dbSkip())
	End
	

EndIf

RestArea(aAreaSX3)		// Restaura a area do SX3

RestArea(aArea)		// restaura a acrea corrente ao chamar a função

Return(aHeadL)



Static Function RetAcol(cAlias, nOrder, cChave, bWhile, aHeadL )
Local aColsL	:= {}
Local nUsado	:= len( aHeadL )

dbSelectArea( cAlias )
dbSetOrder( nOrder )
dbSeek( cChave )

While !Eof() .And. Alltrim(Upper( eVal(bWhile) )) == Alltrim(Upper( cChave ))
   
	aAdd( aColsL, Array(nUsado + 1) )
   
	
	For nXa := 1 to nUsado

		dbSelectArea("SX3")
		dbSeek( Alltrim(Upper( aHeadl[nXa][2] )) )

		cVarTemp := cAlias + "->" + Alltrim( aHeadl[nXa][2] )

		If Alltrim(Upper( aHeadl[nXa][2] )) # "V"
			aColsL[Len(aColsL), nXa] := &cVarTemp
		ElseIf X3_CONTEXT == "V"
			aColsL[Len(aColsL), nXA] := CriaVar(Alltrim( aHeadl[nXa][2] ),.T.)
		Endif

	Next nXa
	aColsL[Len(aColsL), nUsado+1] := .F.
	dbSelectArea(cAlias)
	dbSkip()
EndDo

Return(aColsL)


Static Function _Mytela(nOpc, aHeadL, aColL, cLinha, cDescr, aAlter)
Local aObjects 	:= {}
Local aSize 	:= {}
Local aInfo		:= {}
Local aPosObj	:= {}
Local nMax		:= 0

// objetos da tela
Local oDlgGet	
Local oLinha
Local oDescr

//Variaveis do relatorio
Local cTitulo 	:= OemToAnsi("Ordenação de linhas")
Local cTudOk 	:= "U_Q072Tok"
Local cLinOk 	:= "AlwaysTrue"
Local nOpca 	:= GD_UPDATE	//GD_INSERT+GD_DELETE+GD_UPDATE
Local nOpcGet	:= 0
Local nMax		:= 99

Private oGetd

aSize := MsAdvSize()

AAdd( aObjects, { 030, 100, .T., .F. } )
AAdd( aObjects, { 070, 100, .T., .T. } )

aInfo		:= { aSize[1], aSize[2], aSize[3], aSize[4], 0, 0 }

aPosObj := MsObjSize( aInfo, aObjects,.T.)

//-- Define as posicoes da getdados a partir do folder.
nGd1 := aPosObj[2,1]
nGd2 := aPosObj[2,2]
nGd3 := aPosObj[2,3]
nGd4 := aPosObj[2,4]


DEFINE MSDIALOG oDlgGet FROM aSize[7],00 TO aSize[6],aSize[5] TITLE cTitulo PIXEL

@ 025,007 SAY OemToAnsi( 'Linha:' ) SIZE 40, 10 OF oDlgGet PIXEL COLOR CLR_BLUE
@ 025,050 MSGET oLinha Var cLinha  SIZE 15,10 OF oDlgGet WHEN .F.  PIXEL

@ 045,007 SAY OemToAnsi( 'Descrição:' ) SIZE 40, 10 OF oDlgGet PIXEL COLOR CLR_BLUE
@ 045,050 MSGET oDescr Var cDescr  SIZE 130,10 OF oDlgGet WHEN .F.  PIXEL


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Getdados para lancamentos de varios itens por inclusao 				    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetD:= MsNewGetDados():New(nGd1, nGd2,nGd3,nGd4,nOpcA,cLinOk,cTudOk,/*/cIniCpos/*/,aAlter,/*/nFreeze/*/,nMax,/*/cFieldOk/*/,/*/cSuperDel/*/,/*/cDelOk/*/,oDlgGet,aHeadl,aColL)

oGetD:oBrowse:bEditCol  :={ ||oGetD:oBrowse:GoRight(),oGetD:LinhaOk()}

//DEFINE SBUTTON FROM 055,200 TYPE 1 ACTION (oDlgGet:End(),nOpcGet := 1) ENABLE OF oDlgGet
//DEFINE SBUTTON FROM 055,245 TYPE 2 ACTION (oDlgGet:End(),nOpcGet := 2) ENABLE OF oDlgGet

//ACTIVATE MSDIALOG oDlgGet CENTERED
ACTIVATE MSDIALOG oDlgGet ON INIT EnchoiceBar(oDlgGet,{||IIf(oGetD:TudoOk(),(nOpcGet:= 1,aColL:=oGetD:aCols,oDlgGet:End()),.T.)},{|| oDlgGet:End(), nOpcGet:= 0 })

If nOpcGet == 1
	Qta072Gr( aHeadl, aColL, aAlter )
Endif                       

Return( Iif(nOpcGet == 1, .T., .F.) )



Static Function Qta072Gr( aHeadl, aColL, aAlter ) 
Local nXa 		:= 0
Local nXb 		:= 0
Local aAreaAnt	:= GetArea()
Local nPos		:= 0
Local nPosPro	:= ascan(aHeadl, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBB_CODPRO")) } )
Local nPosOrd	:= ascan(aHeadl, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBB_ORDLIN")) } )

If nPosPro > 0
for nXa := 1 to len(aColL)
	For nXb := 1 to len(aHeadl)
		If ascan(aAlter, {|x| Alltrim(Upper(x)) == Alltrim(Upper(aHeadl[nXb][2])) }) > 0
			dbSelectArea("LBB")
			dbsetOrder(1)
			if dbSeek( xFilial("LBB") + aColL[nXa][nPosPro] )
				RecLock("LBB", .F.)
				LBB->LBB_ORDLIN := aColL[nXa][nPosOrd]
				MsUnlock()
			Endif
		Endif
	next nXb
Next nXa
Endif

RestArea(aAreaAnt)
Return nil


User Function Q072Tok()
Local lRet 		:= .T.
Local aCols 	:= aClone(oGetD:aCols)
Local aHeader	:= aClone(oGetd:aHeader)
Local nXa		:= 0
Local nXb		:= 0
Local nPosOrd	:= ascan(aHeader, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("LBB_ORDLIN")) } )

For nXa := 1 to len(aCols)
	If ( !aCols[nXa][len(aHeader)+1] ) .and. ( Empty(aCols[nXa][nPosOrd]) )
		ApMsgAlert( OemToAnsi("Ordem de captação em branco, verifique!!!"),OemToAnsi("Atenção") )
		lRet := .F.
	Endif
	For nXb := nXa to len(aCols)
		If (nXa <> nXb) .and. ( !aCols[nXa][len(aHeader)+1] ) .and. ( !aCols[nXb][len(aHeader)+1] )
			If (aCols[nXa][nPosOrd] == aCols[nXb][nPosOrd])
				ApMsgAlert( OemToAnsi("Duplicidade encontrada na Ordem de captação, verifique!!!"),OemToAnsi("Atenção") )
				lRet := .F.
			Endif
		Endif	
	next nXb
Next nXa

Return lRet