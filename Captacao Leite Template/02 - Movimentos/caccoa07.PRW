#include "Protheus.ch"
#include "Topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CACCOA07  º Autor ³ Manoel             º Data ³  22/02/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Recalculo da Cota Total de Leite                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Cooperativa de Graos e Leite                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CACCOA07()

//CHKTEMPLATE("COL")

//Variáveis privadas usadas no modelo 3
Private cTitulo, cAliasEnchoice, cLinOK, cTudOK, cFiledOK
Private nReg, nOpc, _wFim

_wfim := nOpc:=0

aRotina := {{ OemToAnsi("Pesquisar") ,"axPesqui", 0 , 1},;  && Pesquisar
{ OemToAnsi("Visualizar") ,'Processa({|| U_CACOL071(2)})', 0 , 2},;     //Visualizar //
{ OemToAnsi("Incluir")    ,'Processa({|| U_CACOL071(3)})', 0 , 3},;     //Incluir //
{ OemToAnsi("Alterar")    ,'Processa({|| U_CACOL071(4)})', 0 , 4, 2} ,; //Alterar //
{ OemToAnsi("Imprimir")   ,'ExecTemplate("CACCOR25")', 0 , 5, 2}}        //Imprimir //

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCadastro := OemToAnsi("Recalculo da Cota Total")
cAlias := "LBG"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse( 6, 1,22,75,cAlias)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CAC0L071 ³ Autor ³ Manoel                ³ Data ³ 02/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Tratamento do Recalculo da Cota Total do Leite   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACOL071(nOpc)
Local _ni
Local nCntFor
Local bCampo   := { |nCPO| Field(nCPO) }
Private aTELA[0][0], aGETS[0]
Private aHeader:={}, aCols:={}

if nOpc == 3 // Incluir
	nOpcE := 3
	nOpcG := 3
Elseif nOpc == 4 // Alterar
	nOpcE := 4
	nOpcG := 3
Elseif nOpc == 2 // Visualizar
	nOpcE := 2
	nOpcG := 2
Else             // Excluir
	nOpcE := 5
	nOpcG := 5
Endif

cAliasGetd    :="LBG"
cAlias        :="LBG"
cLinOk        :="AllwaysTrue()"
cTudOk        :="AllwaysTrue()"
cFieldOk      :="AllwaysTrue()"

cTitulo       :=OemToAnsi("Recalculo da Cota Total") //
cAliasEnchoice:="LBG"
cLinOk        :="AllwaysTrue()"
nReg          := 0

SetPrvt("wVar,_wFim")

nUsado:=0
lPriVez := .t.

aEditCpos := {"LBG_COTAT", "LBG_COTATU"}

dbSelectArea("SX3")
dbSeek("LBG")
While !Eof().And.(x3_arquivo=="LBG")
	if Alltrim(x3_campo) $ "LBG_DESC/LBG_NOMFOR/LBG_COTAT/LBG_OK/LBG_CODPRO/LBG_COTATU"
		if Alltrim(x3_campo) == "LBG_COTAT"
			// Criacao do Campo Cota Atual
			nUsado++
			Aadd(aHeader,{ "Cota Atual", x3_campo, x3_picture,; //
			x3_tamanho, x3_decimal,x3_valid,;
			x3_usado, x3_tipo, x3_arquivo, "V", x3_Relacao, x3_reserv } )
			M->LBG_COTATU := 0
		Endif
		
		nUsado++
		Aadd(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,x3_valid,;
		x3_usado, x3_tipo, x3_arquivo, x3_context, x3_Relacao, x3_reserv } )
		wVar  := "M->"+x3_campo
		&wVar := CriaVar(x3_campo)
	Endif
	dbSkip()
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis M->????? da Enchoice                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("LBG")
For nCntFor := 1 TO FCount()
	M->&(EVAL(bCampo,nCntFor)) := FieldGet(nCntFor)
Next

if nOpc == 3 // Incluir
	
	aCols:={Array(nUsado+1)}
	aCols[1,nUsado+1]:=.F.
	For _ni:=1 to nUsado
		aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
	Next
	
Else
	aCols:={}
	dbSelectArea("LBG")
	_wFim := RecCount()
	dbSetOrder(2)
	dbSeek(xFilial("LBG")+Dtos(M->LBG_DATINI))
	
	ProcRegua(_wfim-recno()) //MarcoTull - inserir regua progressao
	
	While LBG->LBG_FILIAL == xFilial("LBG") .and. LBG->LBG_DATINI >= M->LBG_DATINI .and. LBG->LBG_DATFIN <= M->LBG_DATFIN .and. !eof()
		
		IncProc("Processando...") //
		
		AADD(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
			aCols[Len(aCols),_ni]:=If(aHeader[_ni,10] # "V",FieldGet(FieldPos(aHeader[_ni,2])),CriaVar(aHeader[_ni,2]))
		Next
		
		dbselectArea("LBB")
		dbSetOrder(1)
		dbseek(xFilial("LBB")+LBG->LBG_CODPRO)
		aCols[Len(aCols),3] := LBB->LBB_COTAT
		
		aCols[Len(aCols),nUsado+1]:=.F.
		
		dbSelectArea("LBG")
		
		dbSkip()
		
	Enddo
	
Endif

if !Inclui
	dDatIni := M->LBG_DATINI
	dDatFin := M->LBG_DATFIN
Else
	dDatIni  := Ctod("")
	dDatFin  := Ctod("")
Endif
nOpca := 0

DEFINE MSDIALOG oDlg TITLE cTitulo From 9,0 to 29,80	of oMainWnd
@ 35,004 SAY OemToAnsi("Data Inicial") OF oDlg PIXEL COLOR CLR_BLUE //
@ 35,044 MSGET oDatIni VAR M->LBG_DATINI PICTURE "@D" SIZE 47,4 OF oDlg PIXEL COLOR CLR_BLACK
@ 35,184 SAY OemToAnsi("Data Final  ") OF oDlg PIXEL COLOR CLR_BLUE //
@ 35,224 MSGET oDatFIn VAR M->LBG_DATFIN PICTURE "@D" VALID LevCotaT() SIZE 47,4 OF oDlg PIXEL COLOR CLR_BLACK
oGetDados := MsGetDados():New(50,4,143,315,nOpcG,cLinOk,cTudOk,"",.T.,aEditCpos,,,,cFieldOk)
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End()},{|| oDlg:End() })

if nOpca == 1                                                                               
	GrvCAC07()
Endif

Return


//////////////////////////
Static Function LevCotaT()

Local aAreaAtu := GetArea()

If M->LBG_DATINI # dDatIni .and. M->LBG_DATFIN # dDatFin
	aCols := {}
	dDatIni := M->LBG_DATINI
	dDatFin := M->LBG_DATFIN
	
	nDias :=(M->LBG_DATFIN-M->LBG_DATINI)+1 //dias para cota
	
	//Inicio do Select
	cQuery := "SELECT"
	cQuery += "   LBB.LBB_CODPRO, LBB.LBB_DESC, MAX(LBO.LBO_NOMFOR) LBO_NOMFOR,  SUM(LBO.LBO_QUANT)LBO_QUANT,"
	cQuery += "   MAX(LBB.LBB_COTAT) CotAnt, SUM(LBO.LBO_QUANT)/" + STR(nDias) + " NCOTA"
	cQuery += " FROM "
	cQuery += "   " + RetSqlName("LBB") + " LBB," + RetSqlName("LBO") + " LBO"
	cQuery += " WHERE"
	cQuery += "   LBB.LBB_CODPRO = LBO.LBO_CODPRO AND"
	cQuery += "   LBO_DATENT BETWEEN '" +Dtos(dDatIni)+ "' AND '" +Dtos(dDatFin) + "' AND"
	cQuery += "   LBB.D_E_L_E_T_ = ' ' AND LBO.D_E_L_E_T_ = ' '"
	cQuery += " GROUP BY"
	cQuery += "   LBB.LBB_CODPRO, LBB.LBB_DESC"
	cQuery += " ORDER BY"
	cQuery += "   LBB.LBB_CODPRO"
	
	TCQUERY cQuery ALIAS RQRY NEW
	//Final do Select
	
	nCont :=0
	_wfim :=RecCount() ; ProcRegua(_wfim)
	
	While !EOF()
		IncProc("Levantando Dados...") //
		nPos := Ascan(aCols,{|x| x[1]+x[2] == LBB_DESC + LBO_NOMFOR })
		if nPos == 0
			nCont++
			AADD(aCols,Array(nUsado+1))
			aCols[nCont,1] := LBB_DESC
			aCols[nCont,2] := LBO_NOMFOR
			aCols[nCont,3] := nCota
			aCols[nCont,4] := LBO_QUANT
			aCols[nCont,5] := LBB_CODPRO
			aCols[nCont,6] := CotAnt  // COTA ANTERIOR
			M->LBG_COTATU   := aCols[nCont,3]
			aCols[Len(aCols),nUsado+1]:=.F.
		Endif
		dbSkip()
	Enddo
	oGetDados:oBrowse:Refresh()
	RQRY->(dbCloseArea())
Endif
// Restaura a area orginal
RestArea(aAreaAtu)                           

Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GrvCAC07   ³ Autor ³  Manoel             ³ Data ³ 15/03/2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Gravacao                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvCAC07()
Local i

If nOpc # 2
	
	ProcRegua(len(aCols))
	
	for i = 1 to Len(aCols)
		
		IncProc("Gravando Dados...")
		
		If aCols[i][Len(aCols[i])]
			Loop
		Endif
		
		dbselectArea("LBG")
		dbSetOrder(1)
		wProcura := dbseek(xFilial("LBG")+aCols[i,5]+Dtos(M->LBG_DATINI))
		If Inclui  .or. Altera
			dbselectArea("LBG")
			RecLock("LBG",If(wProcura,.F.,.T.))
			LBG->LBG_FILIAL  := xFilial("LBG")
			LBG->LBG_CODPRO  := aCols[i,5]
			LBG->LBG_DATINI  := M->LBG_DATINI
			LBG->LBG_DATFIN  := M->LBG_DATFIN
			LBG->LBG_COTAT   := aCols[i,4]
			LBG->LBG_COTANT  := aCols[i,3]
			MsUnlock()
		Endif
		
		dbselectArea("LBB")
		dbSetOrder(1)
		dbseek(xFilial("LBB")+aCols[i,5])
		RecLock("LBB",.F.)
		LBB->LBB_COTAT   := aCols[i,3]
		MsUnlock()
		
	Next
	
Endif

Return(.T.)
