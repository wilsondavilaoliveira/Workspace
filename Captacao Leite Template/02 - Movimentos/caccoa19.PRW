#include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOA19 ³ Autor ³  Manoel               ³ Data ³ 05/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Classificacao do Leite Tipo C                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACCOA19()

Local cCadastro, cAlias

//CHKTEMPLATE("COL")

Private nOpcg, nUsado
Private cTitulo, cAliasEnchoice, cLinOK, cTudOK, cFieldOK
Private nReg, nOpc

nOpc:=0
aRotina := {{ OemToAnsi('Pesquisar') ,"axPesqui"     , 0 , 1   },;  && Pesquisar 
			{ OemToAnsi('Visualizar') ,'U_CACOL191(2)', 0 , 2   },;  && Visualizar
			{ OemToAnsi('Incluir') ,'U_CACOL191(3)', 0 , 3   },;  && Incluir
			{ OemToAnsi('Alterar') ,'U_CACOL191(4)', 0 , 4, 2},;  && Alterar
			{ OemToAnsi('Excluir') ,'U_CACOL191(5)', 0 , 5, 1} }  && Excluir

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCadastro := OemToAnsi("Classificacao do Leite C") 
cAlias := "LBC"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("LBC")  //Rotas

mBrowse( 6, 1,22,75,cAlias)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CAC0L191 ³ Autor ³  Manoel               ³ Data ³05/04/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Tratamento da Classificacao do Leite             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACOL191(nOpc)

Local _ni, nCntFor
Local bCampo	  := { |nCPO| Field(nCPO) }
Local aButtons    := {} 
Local aUsrButtons := {} 

Private aTELA[0][0]
Private aGETS[0]
Private aHeader :={} 
Private aCols   :={}

nSvReg  := LBM->(Recno())
RetIndex()
LBM->(Dbgoto(nSvReg))

nReg          := 0
cAliasGetd    := "LBM"
cAlias        := "LBM"
cLinOk        := "AllwaysTrue()"
cTudOk        := "AllwaysTrue()"
cFieldOk      := "U_VTIPOLT2()"
cTitulo       := OemToAnsi("Classificacao do Leite C")
cAliasEnchoice:= "LBM"
cLinOk        := "AllwaysTrue()"

SetPrvt("wVar")

nTipoL := ""
nUsado :=0

dbSelectArea("SX3")
dbSeek("LBM")
While !Eof().And.(x3_arquivo=="LBM")
	
	If X3USO(x3_usado).And.cNivel>=x3_nivel .And. (Alltrim(x3_campo) $ "LBM_CODPRO/LBM_HORAS/LBM_TIPOL/LBM_NOMFOR")
		nUsado:=nUsado+1
		Aadd(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,x3_valid,;
		x3_usado, x3_tipo, x3_arquivo, x3_context, x3_Relacao, x3_reserv } )
		wVar  := "M->"+x3_campo
		&wVar := CriaVar(x3_campo)
	Endif
	
	dbSkip()
	
Enddo

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
dbSelectArea("LBM")
For nCntFor := 1 TO FCount()
	M->&(EVAL(bCampo,nCntFor)) := FieldGet(nCntFor)
Next

if Inclui
	M->LBM_DATCLC := Ctod("")
Endif

M->LBM_DESC := space(30)

dDatAnt     := Ctod("")
nCodRota    := ""
nOpca       := 0

If ExistBlock("TLEI19BUT")
	If ValType( aUsrButtons := ExecBlock("TLEI19BUT",.F.,.F., { nOpc } ) ) == "A" 
		AEval( aUsrButtons, { |x| AAdd( aButtons, x ) } ) 
	EndIf 			
EndIf                                                           

DEFINE MSDIALOG oDlg TITLE cTitulo From 9,0 to 29,80	of oMainWnd

@ 35,004 SAY OemToAnsi("Codigo Linha") OF oDlg PIXEL COLOR CLR_BLUE
@ 35,044 MSGET oCodRota VAR M->LBM_CODROT PICTURE "@!" F3 "LBC" VALID Desc19R() SIZE 40,4 OF oDlg PIXEL COLOR CLR_BLACK
@ 35,090 MSGET oDesc VAR M->LBM_DESC PICTURE "@!" SIZE 70,4 OF oDlg PIXEL COLOR CLR_BLACK when .f.
@ 35,184 SAY OemToAnsi("Data Classif") OF oDlg PIXEL COLOR CLR_BLUE
@ 35,224 MSGET oDatClc VAR M->LBM_DATCLC PICTURE "@D" VALID GetDCAC19() SIZE 47,4 OF oDlg PIXEL COLOR CLR_BLACK
oGetDados := MsGetDados():New(50,4,143,315,nOpcG,cLinOk,cTudOk,"",.T.,,,,,cFieldOk)
oGetDados:oBrowse:bChange     := {|| U_ReplHoras() }

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca := 1,oDlg:End()},{|| nOpca := 0, oDlg:End() },, aButtons )

if nOpca == 1
	GrvCAC19()
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOA19 ³ Autor ³  Manoel               ³ Data ³ 05/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao que administra os campos digitados na GetDados      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GETDCAC19()

Local _ni, i

if dDatAnt # M->LBM_DATCLC .or. nCodRota # M->LBM_CODROT
	
	nCodRota := M->LBM_CODROT
	dDatAnt := M->LBM_DATCLC
	aCols := {}
	
	if Inclui
		
		dbSelectArea("LBD")
		dbSetOrder(1)
		dbSeek(xFilial("LBD")+M->LBM_CODROT)
		
		DbSelectArea("LBO") //Historico da classificacao do leite
		DbSetOrder(2)
		
		if !dbSeek(xFilial("LBO") + Dtos(M->LBM_DATCLC))
			MsgInfo("Nao existem lancamentos nesta data!!!","Atencao!")
			DbSetOrder(1)
			Return(.f.)
		Endif
		DbSetOrder(1)
		
		dbSelectArea("LBD")
		
		While LBD->LBD_FILIAL+LBD->LBD_CODROT == xFilial("LBD")+M->LBM_CODROT .and. !eof()
			
			LBB->(dbSelectArea("LBB"))
			LBB->(dbSetOrder(1))
			LBB->(dbSeek(xFilial("LBB")+LBD->LBD_CODPRO))
			
			if LBB->LBB_TIPOL # "C"
				dbSkip()
				Loop
			Endif
			
			DbSelectArea("LBM") //Historico da classificacao do leite
			DbSetOrder(3)
			if dbSeek(xFilial("LBM") + LBD->LBD_CODPRO + Dtos(M->LBM_DATCLC))
				MsgInfo("Ja foi feita uma classificacao nesta data...","Atencao!")
				Return(.f.)
			Endif
			
			aAdd(aCols,Array(nUsado+1))
			For _ni:=1 to nUsado
				aCols[Len(aCols),_ni]:=CriaVar(aHeader[_ni,2])
			Next
			
			For _ni:=1 to nUsado
				dbSelectArea("LBB")
				dbSetOrder(1)
				dbSeek(xFilial("LBB")+LBD->LBD_CODPRO)
				if _ni == 1
					aCols[Len(aCols),_ni] := LBD->LBD_CODPRO
				Elseif _ni == 2
					aCols[Len(aCols),_ni] := LBB->LBB_DESC
				Endif
			Next
			
			aCols[Len(aCols),nUsado+1]:=.F.
			
			dbSelectArea("LBD")
			dbSkip()
			
		Enddo
		
	Else
		
		Desc19R()
		dbSelectArea("LBM")
		dbSetOrder(4)
		dbgotop()
		dbSeek(xFilial("LBM")+M->LBM_CODROT+Dtos(M->LBM_DATCLC))
		
		While LBM->LBM_FILIAL+LBM->LBM_CODROT == xFilial("LBM")+M->LBM_CODROT .and. !eof() .and. M->LBM_DATCLC == LBM->LBM_DATCLC
			
			LBB->(dbSelectArea("LBB"))
			LBB->(dbSetOrder(1))
			LBB->(dbSeek(xFilial("LBB")+LBM->LBM_CODPRO))
			if LBB->LBB_TIPOL # "C"
				DbSkip()
				Loop
			Endif
			
			dbSelectArea("LBM")
			AADD(aCols,Array(nUsado+1))
			For _ni:=1 to nUsado
				aCols[Len(aCols),_ni] := If(aHeader[_ni,10] # "V",FieldGet(FieldPos(aHeader[_ni,2])),CriaVar(aHeader[_ni,2]))
				if _ni == 2
					aCols[Len(aCols),_ni] := LBB->LBB_DESC
				Endif
			Next
			aCols[Len(aCols),nUsado+1]  := .F.
			dbSkip()
			
		Enddo
		
		dbSelectArea("LBM")
		dbSkip()
		
	Endif
	
Endif

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
	msgStop("Nenhuma propriedade encontrada  na linha")
	aCols:={Array(nUsado+1)}
	aCols[1,nUsado+1]:=.F.
	For _ni:=1 to nUsado
		aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
	Next
	
Endif

Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ GRVCAC19  ³ Autor ³  Manoel               ³ Data ³ 08/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Gravacao                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvCAC19()

Local i

If nOpcG # 2 //Se nao for consulta
	
	// Valida se existe precos para todos estado/tipo de leite
	For i:=1 to len(aCols)
		If !aCols[i,len(aCols[i])]
			
			dbSelectArea("LBB")  // CADASTRO DE PROPRIEDADES
			dbSetOrder(1)
			dbSeek(xFilial("LBB")+aCols[i,1])
			
			// Define tipo de leite de acordo com tabela
			dbSelectArea("LBJ")
			dbSetOrder(1)
			dbSeek(xFilial("LBJ"))
			while !eof()
				if aCols[i,3] >= LBJ->LBJ_HORINI .and. aCols[i,3] <= LBJ->LBJ_HORFIN
					nTipoL := LBJ->LBJ_TIPOL
					Exit
				Endif
				dbSkip()
			Enddo
			
			/*
			ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
			Se o codigo do tanque for vazio e porque entrega Leite quente, e por definicao
			e substituido o C (Leite quente somente sera tipo C) do tipo do Leite e coloca
			do Q.
			ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
			*/
			if LBB->LBB_QUENTE == "S"
				nTipoL := "Q"+Substr(nTipoL,2,1) //Leite quente
			Endif
			
			// Determina o preco do leite de acordo com tabela
			dbSelectArea("LBH")  //Precos de Leite
			dbSetOrder(1)
			if !dbSeek(xFilial("LBH")+LBB->LBB_EST+nTipoL)
				msgStop("Nao existe preco para Estado = "+LBB->LBB_EST+" Leite = "+nTipoL,"Nao foi possivel classificar")
				Return
			Endif
			
		Endif
	Next
	
	For i:=1 to len(aCols)
		
		nValor   := 0
		nTipoL 	 := " "
		nAnalise := 0
		
		dbselectArea("LBM")
		dbsetorder(3)
		wProcura := dbseek(xFilial("LBM")+aCols[i,1]+Dtos(M->LBM_DATCLC))
		If Inclui  .or. Altera
			
			If aCols[i,len(aCols[i])] .And. wProcura //Se for exclusao
				
				RecLock("LBM",.F.,.T.)
				dbdelete()
				MsUnlock()
				WriteSx2("LBM")
				
			Else
				
				If !aCols[i,len(aCols[i])]
					
					dbSelectArea("LBB")
					dbSetOrder(1)
					dbSeek(xFilial("LBB")+aCols[i,1])
					
					dbSelectArea("LBJ")
					dbSetOrder(1)
					dbSeek(xFilial("LBJ"))
					
					while !eof()
						
						if aCols[i,3] >= LBJ->LBJ_HORINI .and. aCols[i,3] <= LBJ->LBJ_HORFIN
							nTipoL := LBJ->LBJ_TIPOL
							exit
						Endif
						
						dbSkip()
						
					Enddo
					
					/*
					ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
					Se o codigo do tanque for vazio e porque entrega Leite quente, e por definicao
					e substituido o C (Leite quente somente sera tipo C) do tipo do Leite e coloca
					do Q.
					ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
					*/
					if LBB->LBB_QUENTE == "S"
						nTipoL := "Q"+Substr(nTipoL,2,1) //Leite quente
					Endif
					
					dbSelectArea("LBH")
					dbSetOrder(1)
					if dbSeek(xFilial("LBH")+LBB->LBB_EST+nTipoL)
						nValor := LBH->LBH_VALOR
					Endif
					
					dbselectArea("LBM")
					RecLock("LBM",If(wProcura,.F.,.T.))
					LBM->LBM_FILIAL  := xFilial("LBM")
					LBM->LBM_CODROT  := M->LBM_CODROT
					LBM->LBM_TIPOL   := nTipoL
					LBM->LBM_DATCLC  := M->LBM_DATCLC
					LBM->LBM_HORAS   := aCols[i,3]
					LBM->LBM_CODPRO  := aCols[i,1]
					LBM->LBM_DATCLA  := dDataBase
					MsUnlock()
					
					dbselectArea("LBB")
					dbSetOrder(1)
					dbseek(xFilial("LBB")+aCols[i,1])
					// Se o codigo do tanque não estiver vazio
					if !Empty(LBB->LBB_CODTAN )
						cCodTan := LBB->LBB_CODTAN
						dbselectArea("LBB")
						dbSetOrder(3)
						dbSeek(xFilial("LBB")+cCodTan+aCols[i,1])
						while !eof() .and. LBB->LBB_FILIAL+LBB->LBB_CODTAN+LBB->LBB_CODPRO == xFilial("LBB")+cCodTan+aCols[i,1]
							
							dbselectArea("LBM")
							dbsetorder(3)
							set SoftSeek on
							nqtdana  := 0
							nAnalise := 0
							dbseek( xFilial("LBM")+aCols[i,1]+dTos(cToD("01/"+Strzero(month(M->LBM_DATCLC),2)+"/"+Strzero(year(M->LBM_DATCLC),4)) ))
							while !eof()  .and. xFilial("LBM") == LBM->LBM_FILIAL .and. Month(M->LBM_DATCLC) == month(LBM->LBM_DATCLC) .and. aCols[i,1] == LBM->LBM_CODPRO
								nqtdana++
								nAnalise := nAnalise + int(LBM->LBM_HORAS) + ((LBM->LBM_HORAS - Int(LBM->LBM_HORAS))/60*100)
								dbSkip()
							Enddo
							
							nAnalise := U_DivHora(nAnalise,nqtdana)
							
							set SoftSeek off
							
							dbSelectArea("LBJ")
							dbSetOrder(1)
							dbSeek(xFilial("LBJ"))
							while !eof()
								if nAnalise >= LBJ->LBJ_HORINI .and. nAnalise <= LBJ->LBJ_HORFIN
									nTipoL := LBJ->LBJ_TIPOL
									exit
								Endif
								dbSkip()
							Enddo
							
							/*
							ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
							Se o codigo do tanque for vazio e porque entrega Leite quente, e por definicao
							e substituido o C (Leite quente somente sera tipo C) do tipo do Leite e coloca
							do Q.
							ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
							*/
							if LBB->LBB_QUENTE == "S"
								nTipoL := "Q"+Substr(nTipoL,2,1) //Leite quente
							Endif
							
							dbselectArea("LBO")
							set SoftSeek on
							dbsetorder(1)
							dbseek(xFilial("LBO")+LBB->LBB_CODPRO+Dtos(Ctod("01/"+Subs(Dtos(M->LBM_DATCLC),5,2)+"/"+Subs(Dtos(M->LBM_DATCLC),1,4))))
							set SoftSeek off
							while !eof() .and. xFilial("LBO") == LBO->LBO_FILIAL .and. Month(M->LBM_DATCLC) == month(LBO->LBO_DATENT) .and. LBB->LBB_CODPRO == LBO->LBO_CODPRO
								RecLock("LBO",.F.)
								LBO->LBO_VALOR   := nValor
								LBO->LBO_TIPOL   := nTipoL
								LBO->LBO_RESUL   := nAnalise
								MsUnlock()
								dbSkip()
							Enddo
							dbselectArea("LBB")
							dbSkip()
						Enddo
						
					Else
						// Se o código do Tanque estiver vazio
						dbselectArea("LBM")
						dbsetorder(3)
						set SoftSeek on
						nqtdana  := 0
						nAnalise := 0
						dbseek( xFilial("LBM")+aCols[i,1]+dTos(cToD("01/"+Strzero(month(M->LBM_DATCLC),2)+"/"+Strzero(year(M->LBM_DATCLC),4)) ))
						while !eof() .and. Month(M->LBM_DATCLC) == month(LBM->LBM_DATCLC) .and. xFilial("LBM") == LBM->LBM_FILIAL .AND. aCols[i,1] == LBM->LBM_CODPRO
							nqtdana++
							nAnalise := nAnalise + int(LBM->LBM_HORAS) + ((LBM->LBM_HORAS - Int(LBM->LBM_HORAS))/60*100)
							dbSkip()
						Enddo
						
						nAnalise := U_DivHora(nAnalise,nqtdana)
						
						set SoftSeek off
						
						dbSelectArea("LBJ")
						dbSetOrder(1)
						dbSeek(xFilial("LBJ"))
						while !eof()
							if nAnalise >= LBJ->LBJ_HORINI .and. nAnalise <= LBJ->LBJ_HORFIN
								nTipoL := LBJ->LBJ_TIPOL
								exit
							Endif
							dbSkip()
						Enddo
						
						/*
						ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
						Se o codigo do tanque for vazio e porque entrega Leite quente, e por definicao
						e substituido o C (Leite quente somente sera tipo C) do tipo do Leite e coloca
						do Q.
						ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
						*/
						if LBB->LBB_QUENTE == "S"
							nTipoL := "Q"+Substr(nTipoL,2,1) //Leite quente
						Endif
						
						dbselectArea("LBO")
						set SoftSeek on
						dbsetorder(1)
						
						dbseek(xFilial("LBO")+LBB->LBB_CODPRO+Dtos(Ctod("01/"+Subs(Dtos(M->LBM_DATCLC),5,2)+"/"+Subs(Dtos(M->LBM_DATCLC),1,4))))
						set SoftSeek off
						while !eof() .and. xFilial("LBO")+LBB->LBB_CODPRO == LBO->LBO_FILIAL+LBO->LBO_CODPRO .and. Month(M->LBM_DATCLC) == month(LBO->LBO_DATENT)
							RecLock("LBO",.F.)
							LBO->LBO_VALOR   := nValor
							LBO->LBO_TIPOL   := nTipoL
							LBO->LBO_RESUL   := nAnalise
							MsUnlock()
							dbSkip()
						Enddo
					Endif
				Endif
				
			Endif
			
		Else
			// Se eu estiver Excluindo
			If wProcura
				RecLock("LBM",.F.,.T.)
				dbdelete()
				MsUnlock()
				WriteSx2("LBM")
			Endif
			
			dbselectArea("LBB")
			dbSetOrder(1)
			dbseek(xFilial("LBB")+aCols[i,1])
			// Se tiver código de Tanque
			if !Empty(LBB->LBB_CODTAN )
				cCodTan := LBB->LBB_CODTAN
				dbselectArea("LBB")
				dbSetOrder(3)
				dbSeek(xFilial("LBB")+cCodTan+aCols[i,1])
				while !eof() .and. LBB->LBB_FILIAL+LBB->LBB_CODTAN+LBB->LBB_CODPRO == xFilial("LBB")+cCodTan+aCols[i,1]
					
					dbselectArea("LBM")
					dbsetorder(3)
					set SoftSeek on
					nqtdana  := 0
					nAnalise := 0
					dbseek( xFilial("LBM")+aCols[i,1]+dTos(cToD("01/"+Strzero(month(M->LBM_DATCLC),2)+"/"+Strzero(year(M->LBM_DATCLC),4)) ))
					while !eof() .and. Month(M->LBM_DATCLC) == month(LBM->LBM_DATCLC) .and. xFilial("LBM") == LBM->LBM_FILIAL .and. aCols[i,1] == LBM->LBM_CODPRO
						nqtdana++
						nAnalise := nAnalise + int(LBM->LBM_HORAS) + ((LBM->LBM_HORAS - Int(LBM->LBM_HORAS))/60*100)
						dbSkip()
					Enddo
					
					nAnalise := U_DivHora(nAnalise,nqtdana)
					
					set SoftSeek off
					
					dbSelectArea("LBJ")
					dbSetOrder(1)
					dbSeek(xFilial("LBJ"))
					while !eof()
						if nAnalise >= LBJ->LBJ_HORINI .and. nAnalise <= LBJ->LBJ_HORFIN
							nTipoL := LBJ->LBJ_TIPOL
							exit
						Endif
						dbSkip()
					Enddo
					
					/*
					ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
					Se o codigo do tanque for vazio e porque entrega Leite quente, e por definicao
					e substituido o C (Leite quente somente sera tipo C) do tipo do Leite e coloca
					do Q.
					ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
					*/
					if LBB->LBB_QUENTE == "S"
						nTipoL := "Q"+Substr(nTipoL,2,1) //Leite quente
					Endif
					
					dbSelectArea("LBH")
					dbSetOrder(1)
					if dbSeek(xFilial("LBH")+LBB->LBB_EST+nTipoL)
						nValor := LBH->LBH_VALOR
					Endif
					
					dbselectArea("LBO")
					dbsetorder(1)
					dbseek( xFilial("LBO")+LBB->LBB_CODPRO+dTos(cToD("01/"+Strzero(month(M->LBM_DATCLC),2)+"/"+Strzero(year(M->LBM_DATCLC),4)) ), .t.)
					while !eof() .and. Month(M->LBM_DATCLC) == month(LBO->LBO_DATENT) .and. xFilial("LBO") == LBO->LBO_FILIAL .and. LBB->LBB_CODPRO == LBO->LBO_CODPRO
						RecLock("LBO",.F.)
						LBO->LBO_VALOR   := nValor
						LBO->LBO_TIPOL   := nTipoL
						LBO->LBO_RESUL   := nAnalise
						MsUnlock()
						dbSkip()
					Enddo
					
					dbselectArea("LBB")
					dbSkip()
					
				Enddo
				
			Else
				// Se não tiver codigo do Tanque
				dbselectArea("LBM")
				dbsetorder(3)
				nqtdana  := 0
				nAnalise := 0
				dbseek( xFilial("LBM")+aCols[i,1]+dTos(cToD("01/"+Strzero(month(M->LBM_DATCLC),2)+"/"+Strzero(year(M->LBM_DATCLC),4)) ), .t.)
				while !eof() .and. Month(M->LBM_DATCLC) == month(LBM->LBM_DATCLC) .and. xFilial("LBM") == LBM->LBM_FILIAL .and. aCols[i,1] == LBM->LBM_CODPRO
					nqtdana++
					nAnalise := nAnalise + int(LBM->LBM_HORAS) + ((LBM->LBM_HORAS - Int(LBM->LBM_HORAS))/60*100)
					dbSkip()
				Enddo
				
				nAnalise := U_DivHora(nAnalise,nqtdana)
				
				dbSelectArea("LBJ")
				dbSetOrder(1)
				dbSeek(xFilial("LBJ"))
				
				while !eof()
					if nAnalise >= LBJ->LBJ_HORINI .and. nAnalise <= LBJ->LBJ_HORFIN
						nTipoL := LBJ->LBJ_TIPOL
						exit
					Endif
					dbSkip()
				Enddo
				
				/*
				ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
				Se o codigo do tanque for vazio e porque entrega Leite quente, e por definicao
				e substituido o C (Leite quente somente sera tipo C) do tipo do Leite e coloca
				do Q.
				ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
				*/
				if LBB->LBB_QUENTE == "S"
					nTipoL := "Q"+Substr(nTipoL,2,1) //Leite quente
				Endif
				
				dbSelectArea("LBH")
				dbSetOrder(1)
				if dbSeek(xFilial("LBH")+LBB->LBB_EST+nTipoL)
					nValor := LBH->LBH_VALOR
				Endif
				
				dbselectArea("LBO")
				set SoftSeek on
				dbsetorder(1)
				wProcura := dbseek(xFilial("LBO")+LBB->LBB_CODPRO+dTos(M->LBM_DATCLC))
				set SoftSeek off
				while !eof() .and. xFilial("LBO")+LBB->LBB_CODPRO == LBO->LBO_FILIAL+LBO->LBO_CODPRO .and. Month(M->LBM_DATCLC) == month(LBO->LBO_DATENT)
					RecLock("LBO",.F.)
					LBO->LBO_VALOR   := nValor
					LBO->LBO_TIPOL   := nTipoL
					LBO->LBO_RESUL   := nAnalise
					MsUnlock()
					dbSkip()
				Enddo
				
			Endif
			
		Endif
		
	Next
	
Endif


Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOA19 ³ Autor ³  MarcoTull            ³ Data ³ 05/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualiza Campos na Tela                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Desc19R()

dbselectArea("LBC")
dbsetorder(1)
dbseek(xFilial("LBC")+M->LBM_CODROT)
M->LBM_DESC := LBC->LBC_DESC
oGetDados:oBrowse:Refresh()

dbSelectArea("LBD")
dbSetOrder(1)
dbSeek(xFilial("LBD")+M->LBM_CODROT)

DbselectArea("LBB")
DbSetOrder(1)
dbseek(xFilial("LBB")+LBD->LBD_CODPRO)

Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOA19 ³ Autor ³  MarcoTull            ³ Data ³ 05/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Joga Qtd de horas da linha anterior para a proxima linha   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USer Function ReplHoras()

If type("aCols[n,1]") # "U"
	If empty(aCols[n,3])  .and. !empty(aCols[n,1]) .and. n>1
		M->LBM_HORAS  := aCols[n-1,3]
		aCols[n,3]    := aCols[n-1,3]
		oGetDados:oBrowse:Refresh()
	Endif
Endif

Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOA19 ³ Autor ³  MarcoTull            ³ Data ³ 05/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Dividir Hora                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DivHora(nHoras,nDivisor)

Local nHorRet,nDivisao

nHorRet:=nDivisao := 0

nDivisao := nHoras / nDivisor
nHorRet := INT(nDivisao)+((nDivisao-INT(nDivisao))*60/100)

Return(nHorRet)


User Function VTIPOLT2()

LBB->(dbSelectArea("LBB"))
LBB->(dbSetOrder(1))
LBB->(dbSeek(xFilial("LBB")+aCols[n,1]))

// Define tipo de leite de acordo com tabela
dbSelectArea("LBJ") //Tabela de classificacao do Leite C
dbSetOrder(1)
dbSeek(xFilial("LBJ"))
while !eof()
	if M->LBM_HORAS >= LBJ->LBJ_HORINI .and. M->LBM_HORAS <= LBJ->LBJ_HORFIN
		if LBB->LBB_QUENTE <> "S"
			aCols[n,4] := LBJ->LBJ_TIPOL
		Else
			aCols[n,4] := "Q"+substr(LBJ->LBJ_TIPOL,2,1)  //Leite Quente
		Endif
		Exit
	Endif
	M->LBM_TIPOL := aCols[n,4]
	aCols[n,3]   := M->LBM_HORAS
	dbSkip()
Enddo

Return(.t.)
