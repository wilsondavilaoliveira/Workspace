#include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOA06 ³ Autor ³  Manoel               ³ Data ³ 02/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Classificacao do Leite Tipo B                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USer Function CACCOA06()

Local cCadastro, cAlias
Private nOpcg, nUsado
Private cTitulo, cAliasEnchoice, cLinOK, cTudOK, cFieldOK
Private nReg, nOpc

//CHKTEMPLATE("COL")

nOpc:=0
aRotina := {{ OemToAnsi("Pesquisar") ,"axPesqui", 0 , 1},;  && Pesquisar
{ OemToAnsi("Visualizar") ,'U_CACOL061(2)', 0 , 2},;      && Visualizar
{ OemToAnsi("Incluir")    ,'U_CACOL061(3)', 0 , 3},;      && Incluir
{ OemToAnsi("Alterar")    ,'U_CACOL061(4)', 0 , 4, 2},;   && Alterar
{ OemToAnsi("Excluir")    ,'U_CACOL061(5)', 0 , 5, 1} }   && Excluir

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCadastro := OemToAnsi("Classificacao do Leite B") 
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
±±³Fun‡„o    ³ CAC0L061 ³ Autor ³  Manoel               ³ Data ³02/03/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Tratamento da Classificacao do Leite             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USer Function CACOL061(nOpc)
Local _ni, nCntFor
Local bCampo   := { |nCPO| Field(nCPO) }
Private wVar
Private aTELA[0][0], aGETS[0]
Private aHeader:={}, aCols  :={}

cAliasGetd    :="LBM"
cAlias        :="LBM"
cLinOk        :="AllwaysTrue()"
cTudOk        :="AllwaysTrue()"
cFieldOk      :="U_VTIPOLT1()"

cTitulo       :=OemToAnsi("Classificacao do Leite")
cAliasEnchoice:="LBM"
cLinOk        :="AllwaysTrue()"
nReg          := 0

nTipoL        := ""
nUsado        := 0

dbSelectArea("SX3")
dbsetorder(1)
dbSeek("LBM")
While !Eof().And.(x3_arquivo=="LBM")
	If X3USO(x3_usado).And.cNivel>=x3_nivel .And. (Alltrim(x3_campo) $ "LBM_CODPRO/LBM_UFCPML/LBM_TIPOL/LBM_NOMFOR" .or. Alltrim(x3_campo) == "LBM_DESCPR")
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

if nOpc == 3     // Incluir
	nOpcE := 4
	nOpcG := 4
Elseif nOpc == 4 // Alterar
	nOpcE := 4
	nOpcG := 4
Elseif nOpc == 2 // Visualizar
	nOpcE := 2
	nOpcG := 2
Else             // Excluir
	nOpcE := 5
	nOpcG := 5
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis M->????? da Enchoice                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("LBM")
For nCntFor := 1 TO FCount()
	M->&(EVAL(bCampo,nCntFor)) := FieldGet(nCntFor)
Next

cDesRot := ""
if inclui
	cCodRot := space(Len(LBC->LBC_CODROT))
Else
	cCodRot := LBC->LBC_CODROT
	cDesRot := LBC->LBC_DESC
Endif
cRotAnt := ""
dDatEnt := ctod("")
dDatAnt := ctod("")
nOpca   := 0

DEFINE MSDIALOG oDlg TITLE cTitulo From 9,0 to 29,80	of oMainWnd

@ 35,004 SAY OemToAnsi("Codigo Linha") OF oDlg PIXEL COLOR CLR_BLUE
@ 35,044 MSGET oCodRot VAR cCodRot PICTURE "@!" F3 "LBC" VALID Desc06R() SIZE 40,4 OF oDlg PIXEL COLOR CLR_BLACK WHEN Inclui
@ 35,090 MSGET oDesRot VAR cDesRot PICTURE "@!" SIZE 70,4 OF oDlg PIXEL COLOR CLR_BLACK when .f.
@ 35,184 SAY OemToAnsi("Data Entrada") OF oDlg PIXEL COLOR CLR_BLUE
@ 35,224 MSGET oDatEnt VAR dDatEnt PICTURE "@D" VALID GetDCAC06() SIZE 47,4 OF oDlg PIXEL COLOR CLR_BLACK
oGetDados := MsGetDados():New(50,4,143,315,nOpcG,cLinOk,cTudOk,"",.T.,,,,,cFieldOk)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca := 1,oDlg:End()},{|| oDlg:End() })

if nOpca == 1
	GrvCAC06()
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GETDCAC06 ³ Autor ³  Manoel               ³ Data ³02/03/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Funcao de Tratamento da Classificacao do Leite              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Cooperativa de Graos e Leite                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GETDCAC06()
Local _ni

aCols   := {}

if Inclui
	
	dbSelectArea("LBD") //Itens da Rota
	dbSetOrder(1)
	dbSeek(xFilial("LBD")+cCodRot)
	
	DbSelectArea("LBO") //Historico da classificacao do leite
	DbSetOrder(2)
	if !dbSeek(xFilial("LBO") + dtos(dDatEnt))
		MsgInfo("Nao existem lancamentos nesta data...","Atencao!")
		DbSetOrder(1)
		Return(.f.)
	Endif
	
	DbSetOrder(1)
	dbSelectArea("LBD") //Itens da Rota
	dbSetOrder(1)
	
	While LBD->LBD_FILIAL+LBD->LBD_CODROT == xFilial("LBD")+cCodRot .and. !eof()
		
		LBB->(dbSelectArea("LBB")) //Propriedades
		LBB->(dbSetOrder(1))
		LBB->(dbSeek(xFilial("LBB")+LBD->LBD_CODPRO))
		
		if LBB->LBB_TIPOL # "B"
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("LBM") //Historico da classificacao do leite
		dbsetorder(2)
		if dbSeek(xFilial("LBM")+LBD->LBD_CODPRO+dtos(dDatEnt))
			MsgInfo("Ja foi feita uma classificacao nesta data...","Atencao!")
			Return(.f.)
		Endif
		
		dbSelectArea("LBM")
		AADD(aCols,Array(nUsado+1))
		aCols[Len(aCols),nUsado+1]:=.F.
		For _ni:=1 to nUsado
			aCols[Len(aCols),_ni] := CriaVar(aHeader[_ni,2])
			if _ni == 1
				aCols[Len(aCols),_ni] := LBB->LBB_CODPRO
			Elseif _ni == 2
				aCols[Len(aCols),_ni] := LBB->LBB_DESC
			Elseif _ni == 3
				aCols[Len(aCols),_ni] := LBB->LBB_NOMFOR
			Endif
		Next
		
		dbSelectArea("LBD") //Itens da Rota
		dbSkip()
		
	Enddo
	
Else
	
	dbSelectArea("LBM") //Historico da classificacao do leite
	dbSetOrder(1)
	if dbSeek(xFilial("LBM")+cCodRot+Dtos(dDatEnt))
		
		While LBM->LBM_FILIAL+LBM->LBM_CODROT == xFilial("LBM")+cCodRot .and. dDatEnt == LBM->LBM_DATENT .and. !Eof()
			
			LBB->(dbSelectArea("LBB")) // CADASTRO DE PROPRIEDADES
			LBB->(dbSetOrder(1))
			LBB->(dbSeek(xFilial("LBB")+LBM->LBM_CODPRO))
			
			if LBB->LBB_TIPOL # "B"
				dbSkip()
				Loop
			Endif
			
			dbSelectArea("LBM")
			AADD(aCols,Array(nUsado+1))
			For _ni:=1 to nUsado
				aCols[Len(aCols),_ni] := If(aHeader[_ni,10] # "V",FieldGet(FieldPos(aHeader[_ni,2])),CriaVar(aHeader[_ni,2]))
				if _ni == 2
					aCols[Len(aCols),_ni] := LBB->LBB_DESC
				Elseif _ni == 3
					aCols[Len(aCols),_ni] := LBB->LBB_NOMFOR
				Endif
			Next
			aCols[Len(aCols),nUsado+1]:=.F.
			
			dbSelectArea("LBM")
			dbSkip()
			
		Enddo
	Else
		MsgInfo("Nao existem lancamentos nesta data!","Atencao!")
	Endif
	
Endif

if Len(aCols) = 0
	aCols:={Array(nUsado+1)}
	aCols[1,nUsado+1]:=.F.
	For _ni:=1 to nUsado
		aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
	Next
Endif

oGetDados:nMax:=Len(aCols) //Maximo de linhas por getdados de entrada.
oGetDados:oBrowse:Refresh()

Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GrvCAC06   ³ Autor ³  Manoel               ³ Data ³08/03/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Gravacao                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvCAC06()
Local i
Local nPosLBM := Ascan(aHeader,{|x| Alltrim(x[2]) == "LBM_UFCPML"})

If nOpcG # 2 //Se nao for consulta
	//Valida se existe precos para todos estado/tipo de leite
	For i:=1 to len(aCols)
		If !aCols[i,len(aCols[i])]
			
			dbSelectArea("LBB")
			dbSetOrder(1)
			dbSeek(xFilial("LBB")+aCols[i,1])
			
			// Define tipo de leite de acordo com tabela
			dbSelectArea("LBI") // TABELA CLASSIFICACAO LEITE B
			dbSetOrder(1)
			dbSeek(xFilial("LBI"))
			while !eof()
				if aCols[i,nPosLBM] >= LBI->LBI_UFCINI .and. aCols[i,nPosLBM] <= LBI->LBI_UFCFIN
					nTipoL := LBI->LBI_TIPOL
					exit
				Endif
				dbSkip()
			Enddo
			
			// Determina o preco do leite de acordo com tabela
			dbSelectArea("LBH")  // TABELA DE PRECOS
			dbSetOrder(1)
			if !dbSeek(xFilial("LBH")+LBB->LBB_EST+nTipoL)
				MsgStop("Nao existe preco para Estado="+LBB->LBB_EST+" Leite="+nTipoL,"Nao foi possivel classificar")
				Return(.f.)
			Endif
		Endif
	Next
	
	For i:=1 to len(aCols)
		dbselectArea("LBM") //Historico da classificacao do Leite
		dbsetorder(2)
		wProcura := dbseek(xFilial("LBM")+aCols[i,1]+Dtos(dDatEnt))
		If Inclui  .or. Altera
			If aCols[i,len(aCols[i])] .And. wProcura //Exclusao
				RecLock("LBM",.F.,.T.)
				dbdelete()
				MsUnlock()
				WriteSx2("LBM")
			Else
				If !aCols[i,len(aCols[i])]
					dbSelectArea("LBB") //Propriedades
					dbSetOrder(1)
					dbSeek(xFilial("LBB")+aCols[i,1])
					
					// Define tipo de leite de acordo com tabela
					dbSelectArea("LBI") //Tabela de classificacao do Leite B
					dbSetOrder(1)
					dbSeek(xFilial("LBI"))
					while !eof()
						if aCols[i,nPosLBM] >= LBI->LBI_UFCINI .and. aCols[i,nPosLBM] <= LBI->LBI_UFCFIN
							nTipoL := LBI->LBI_TIPOL
							Exit
						Endif
						dbSkip()
					Enddo
					
					// Determina o preco do leite de acordo com tabela
					dbSelectArea("LBH") //Precos do Leite
					dbSetOrder(1)
					if dbSeek(xFilial("LBH")+LBB->LBB_EST+nTipoL)
						nValor := LBH->LBH_VALOR
					Endif
					
					dbselectArea("LBM") //Historico da classificacao do Leite
					RecLock("LBM",If(wProcura,.F.,.T.))
					LBM->LBM_FILIAL   := xFilial("LBM")
					LBM->LBM_CODROT   := cCodRot
					LBM->LBM_TIPOL    := nTipoL
					LBM->LBM_DATENT   := dDatEnt
					LBM->LBM_DATCLA   := dDataBase
					LBM->LBM_UFCPML   := aCols[i,nPosLBM]
					LBM->LBM_CODPRO   := aCols[i,1]
					MsUnlock()
					
					dbselectArea("LBB")
					dbSetOrder(1)
					dbseek(xFilial("LBB")+aCols[i,1])
					if !Empty(LBB->LBB_CODTAN)
						
						cCodTan := LBB->LBB_CODTAN
						dbselectArea("LBB")
						dbSetOrder(3)
						dbSeek(xFilial("LBB")+cCodTan+aCols[i,1])
						while !eof() .and. LBB->LBB_FILIAL+LBB->LBB_CODTAN+LBB->LBB_CODPRO == xFilial("LBB")+cCodTan+aCols[i,1]
							dbselectArea("LBO") //Entrada do Leite
							dbsetorder(1)
							dbseek(xFilial("LBO")+LBB->LBB_CODPRO+Dtos(dDatEnt))
							while !eof() .and. xFilial("LBO")+LBB->LBB_CODPRO == LBO->LBO_FILIAL+LBO->LBO_CODPRO .and. LBO->LBO_DATENT == dDatEnt
								RecLock("LBO",.F.)
								LBO->LBO_VALOR   := nValor
								LBO->LBO_TIPOL   := nTipoL
								LBO->LBO_RESUL   := aCols[i,4]
								MsUnlock()
								dbSkip()
							Enddo
							dbselectArea("LBB")
							dbSkip()
						Enddo
						
					Else
						
						dbselectArea("LBO") //Entrada do Leite
						dbsetorder(1)
						dbseek(xFilial("LBO")+LBB->LBB_CODPRO+Dtos(dDatEnt))
						while !eof() .and. xFilial("LBO")+LBB->LBB_CODPRO == LBO->LBO_FILIAL+LBO->LBO_CODPRO .and. LBO->LBO_DATENT == dDatEnt
							RecLock("LBO",.F.)
							LBO->LBO_VALOR   := nValor
							LBO->LBO_TIPOL   := nTipoL
							LBO->LBO_RESUL   := aCols[i,4]
							MsUnlock()
							dbSkip()
						Enddo
						
					Endif
					
				Endif
			Endif
		Else
			If wProcura  // opcao exclusao do menu
				RecLock("LBM",.F.,.T.)
				dbdelete()
				MsUnlock()
				WriteSx2("LBM")
			Endif
		Endif
	Next
Endif

Return(.T.)


/////////////////////////
Static Function Desc06R()

dbselectArea("LBC")  //CADASTRO DE ROTAS
dbsetorder(1)
dbseek(xFilial("LBC")+cCodRot)
cDesRot := LBC->LBC_DESC

oGetDados:oBrowse:Refresh()

dbSelectArea("LBD") //ITENS DO CADASTRO DE ROTAS
dbSetOrder(1)
dbSeek(xFilial("LBD")+cCodRot)

dbselectArea("LBB")  // CADASTRO DE PROPRIEDADES
dbSetOrder(1)
dbseek(xFilial("LBB")+LBD->LBD_CODPRO)

Return .t.


User Function VTIPOLT1()

// Define tipo de leite de acordo com tabela
dbSelectArea("LBI") //Tabela de classificacao do Leite B
dbSetOrder(1)
dbSeek(xFilial("LBI"))
while !Eof()
	if M->LBM_UFCPML >= LBI->LBI_UFCINI .and. M->LBM_UFCPML <= LBI->LBI_UFCFIN
		aCols[n,5] := LBI->LBI_TIPOL
		Exit
	Endif
	M->LBM_TIPOL := aCols[n,5]
	aCols[n,4]   := M->LBM_UFCPML
	dbSkip()
Enddo

Return(.t.)
