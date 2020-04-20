#include "Protheus.ch"
#include "TopConn.ch"
#include "TbiConn.ch"
#include "Error.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOA11 ³ Autor ³ Microsiga             ³ Data ³ 07/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Entrada do Leite                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Controle de entradas de leite                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACCOA11()

//CHKTEMPLATE("COL")

/*
SE FOR INCLUSAO VALIDAR SE EXISTE LANCAMENTO NA DATA E NAO PERMITIR ALTERACAO
NA INCLUSAO. NA ALTERACAO, EXIBIR TAMBEM AS PROPRIEDADES DAS  LINHAS QUE  NAO
TIVERAM  ENTRADAS EXIBIR MENSAGEM PARA DELETAR SE FOR  NECESSARIO  ZERAR  UMA
QUANTIDADE LANCADO ERRONEAMENTE NO CASO DE DELECAO, GERANDO MOVIMENTACAO TIPO
600 A DATA DA MOVIMENTACAO DEVE SER A DATA DA ENTRADA E NAO A DATABASE.
*/

Private nOpcG, nUsado, cTitulo, cAliasEnchoice, nCpoPad
Private cLinOK, cTudOK, cFieldOK
Private nReg, nOpc

Private cEmpOld := SM0->M0_CODIGO //Salva Empresa
Private cFilOld := SM0->M0_CODFIL //Salva Filial

nOpc     :=0
Inclui   := .f.

aRotina := {;
{ OemToAnsi("Pesquisar")      ,"axPesqui"     , 0 , 1},;
{ OemToAnsi("Visualizar")     ,'U_CACOL111(2)', 0 , 2},;
{ OemToAnsi("Incluir")        ,'U_CACOL111(3)', 0 , 3},;
{ OemToAnsi("Alterar")        ,'U_CACOL111(4)', 0 , 4, 2},;
{ OemToAnsi("Rel.Divergencia"),'U_CACOL11R()' , 0 , 2}}


cCadastro := OemToAnsi("Entrada do Leite")
cAlias    := "LBO"

mBrowse( 6, 1,22,75,cAlias)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CAC0L111 ³ Autor ³                       ³ Data ³02/03/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Tratamento da Classificacao do Leite             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACOL111(nOpc)

Local _ni, nCntFor
Local   bCampo   := { |nCPO| Field(nCPO) }
Private aTELA[0][0], aGETS[0]
Private aHeader:={}, aCols  :={}
Private aOrdem_ := {"1-Por Sequencia","2-Por Nome"}
Private oOrdem_, cOrdem_, oGetDados
Private nQtdBal := 0
Private nPosCODPRO := 0,nPosDesc := 0,nPosNomFor := 0, nPosQuant := 0,nPosQtdAci := 0
Private nPosResul := 0,nPosTipoL := 0,nPosValor := 0,nPosCriosc := 0,nPosVolcri := 0,nPosCodRot := 0

cOrdem_       := aOrdem_[Val(GetMv("MV_ORDENTC"))]

cAliasGetd    :="LBO"
cAlias        :="LBO"
cLinOk        :="AllwaysTrue()"
cTudOk        :="AllwaysTrue()"
cFieldOk      :="U_FO_COA11()"
cTitulo       :=OemToAnsi("Entrada do Leite")
cAliasEnchoice:="LBO"
cLinOk        :="AllwaysTrue()"
nReg          := 0

SetPrvt("wVar")

nUsado:=0
dbSelectArea("SX3")
DbSetOrder(1)
dbSeek("LBO")
While !Eof().And.(x3_arquivo=="LBO")
	if X3USO(x3_usado).And.cNivel>=x3_nivel .And. Alltrim(x3_campo) $ "LBO_CODPRO/LBO_DESC/LBO_NOMFOR/LBO_QUANT/LBO_QTDACI/LBO_RESUL/LBO_TIPOL/LBO_VALOR/LBO_CRIOSC/LBO_VOLCRI/LBO_CODROT"
		nUsado:=nUsado+1
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
dbSeek("LBO")
While !Eof() .And. (X3_ARQUIVO == "LBO")
	If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .And. X3_PROPRI == "U"
		nUsado++
		Aadd(aHeader,{ TRIM(X3Titulo()), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL,;
		X3_VALID,X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT, X3_RELACAO, X3_RESERV } )
		wVar  := "M->"+X3_CAMPO
		&wVar := CriaVar(X3_CAMPO)
	EndIf
	dbSkip()
EndDo

nPosCodPro := Ascan(aHeader,{|x| AllTrim(x[2]) == "LBO_CODPRO"})
nPosDesc   := Ascan(aHeader,{|x| AllTrim(x[2]) == "LBO_DESC"})
nPosNomFor := Ascan(aHeader,{|x| AllTrim(x[2]) == "LBO_NOMFOR"})
nPosQuant  := Ascan(aHeader,{|x| AllTrim(x[2]) == "LBO_QUANT"})
nPosQtdAci := Ascan(aHeader,{|x| AllTrim(x[2]) == "LBO_QTDACI"})
nPosResul  := Ascan(aHeader,{|x| AllTrim(x[2]) == "LBO_RESUL"})
nPosTipoL  := Ascan(aHeader,{|x| AllTrim(x[2]) == "LBO_TIPOL"})
nPosValor  := Ascan(aHeader,{|x| AllTrim(x[2]) == "LBO_VALOR"})
nPosCriosc := Ascan(aHeader,{|x| AllTrim(x[2]) == "LBO_CRIOSC"})
nPosVolcri := Ascan(aHeader,{|x| AllTrim(x[2]) == "LBO_VOLCRI"})
nPosCodRot := Ascan(aHeader,{|x| AllTrim(x[2]) == "LBO_CODROT"})

aCols:={Array(nUsado+1)}
aCols[1,nUsado+1]:=.F.
For _ni := 1 to nUsado
	aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
Next

if nOpc == 3 // Incluir
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

dbSelectArea("LBO")
For nCntFor := 1 TO FCount()
	M->&(EVAL(bCampo,nCntFor)) := FieldGet(nCntFor)
Next

if Inclui
	M->LBO_DATENT := dDataBase
	cDescRota     := space(30)
	cCodRota      := space(6)
Else
	if Altera
		aArea := GetArea()
		dbSelectArea("LBP")
		dbSetOrder(2)
		cmes := StrZero(Month(LBO->LBO_DATENT), 2)
		DbSeek(xFilial("LBP") + Dtos(CTod("01/" + strzero(month(LBO->LBO_DATENT), 2) + "/" + Str(year(LBO->LBO_DATENT), 4))),.T.)
		If Str(year(LBO->LBO_DATENT), 4) + strzero(month(LBO->LBO_DATENT), 2) ==  Subs(Dtos(LBP->LBP_DATINI), 1, 6)
			MsgStop("O Mes " + cMes + " ja foi fechado e nao pode ser alterado!", "Atencao")
			RestArea(aArea)
			Return(.f.)
		Endif
		RestArea(aArea)
	Endif
	
	cCodRota  := LBO->LBO_CODROT
	dbSelectArea("LBC") // Rotas
	dbSetOrder(1)       // LBC_FILIAL+LBC_CODROT
	dbSeek(xFilial("LBC")+cCodRota)
	cDescRota := LBC->LBC_DESC
Endif

U_OrdemEnt(cOrdem_,.F.)

nOpca     := 0
nTotQuant := 0  // Quantidade total apurada pélo sistema
nTotPlan  := 0  // Quantidade total na planilha
nTotDif   := 0  // Diferenca Entre Apurada - Planilha

DEFINE MSDIALOG oDlg TITLE cTitulo From 9,0 to 33,80	of oMainWnd
@ 35,004 SAY   OemToAnsi("Codigo Linha") OF oDlg PIXEL COLOR CLR_BLUE
@ 35,044 MSGET oCodRota VAR cCodRota     PICTURE "@!" F3 "LBC" VALID ExistRota() .and. CAC11DescR() SIZE 40,4 OF oDlg PIXEL COLOR CLR_BLACK
@ 35,090 MSGET oDesc    VAR cDescRota    PICTURE "@!" SIZE 70,4 OF oDlg PIXEL COLOR CLR_BLACK when .f.
@ 35,184 SAY   OemToAnsi("Data Entrada") OF oDlg PIXEL COLOR CLR_BLUE
@ 35,224 MSGET oDatEnt  VAR M->LBO_DATENT PICTURE "@D" VALID ExistRota(1) .and. GetDCAC11() SIZE 47,4 OF oDlg PIXEL COLOR CLR_BLACK
@ 50,004 SAY   OemToAnsi("Qtde Balanca") OF oDlg PIXEL COLOR CLR_BLUE
@ 50,044 MSGET oTotPlan    VAR nTotPlan PICTURE "999999" VALID (nTotPlan>=0 .AND. U_FO_COA11()) SIZE 40,4 OF oDlg PIXEL COLOR CLR_BLUE
@ 50,100 SAY   OemToAnsi("Qtde Informada") OF oDlg PIXEL COLOR CLR_BLUE
@ 50,140 MSGET oTotQuant    VAR nTotQuant PICTURE "999999" SIZE 40,4 OF oDlg PIXEL COLOR CLR_BLUE WHEN .F.
@ 50,193 SAY   OemToAnsi("Diferenca") OF oDlg PIXEL COLOR CLR_BLUE
@ 50,231 MSGET oTotDif    VAR nTotDif  PICTURE "999999" SIZE 40,4 OF oDlg PIXEL COLOR CLR_BLUE WHEN .F.

oGetDados := MsGetDados():New(65,1,150,315,nOpcG,cLinOk,cTudOk,"",.T.,,,,,cFieldOk)

@ 153, 01 SAY "Ordem" SIZE 40,08 OF oDlg PIXEL COLOR CLR_BLUE
@ 153, 30 MSCOMBOBOX oOrdem_ VAR cOrdem_ SIZE 70,50 ITEMS aOrdem_ ON CHANGE (U_OrdemEnt(Subs(cOrdem_,1,1))) OF oDlg PIXEL

// Se nao for inclusao carrega acols
if !Inclui
	GetDCAC11()
Endif

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| if(MsgYesNo("Confirma os Dados Informados ?","Atencao!"),(nOpca := 1, oDlg:End()),.f.)},{|| oDlg:End() }) CENTER 

if nOpca==1
	GrvCAC11()
	
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GETDCAC11 ºAutor  ³                    º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Carrega acols com entradas                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Cooperativa de Graos e Leite                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GETDCAC11()

Local _ni       := 0
Local nTamTipoL := TamSX3("LBO_TIPOL")[1]
aCols           := {}

if !Inclui
	CAC11DescR()
	nCodRota := M->LBO_CODROT
	LBO->(dbSetOrder(2))  // LBO_FILIAL+Dtos(LBO_DATENT)+LBO_CODPRO
Endif

dbSelectArea("LBD") //ITENS DO CADASTRO DE ROTAS
dbSetOrder(1)       //LBD_FILIAL+LBD_CODROT+LBD_SEQ+LBD_CODPRO
dbSeek(xFilial("LBD")+cCodRota)

// Carrega rotas no acols
While !eof() .and. LBD->LBD_FILIAL+LBD->LBD_CODROT == xFilial("LBD")+cCodRota
	AADD(aCols,Array(nUsado+1))
	
	For _ni := 1 to nUsado
		
		LBO->(dbSetOrder(1))
		if LBO->(dbSeek(xFilial("LBO")+LBD->LBD_CODPRO+Dtos(M->LBO_DATENT)))
			nTotPlan := LBO->LBO_TOTPLA
			lInclui := inclui
			inclui := .f.
			aCols[Len(aCols),_ni] := If(aHeader[_ni,10] # "V",LBO->(FieldGet(FieldPos(aHeader[_ni,2]))),CriaVar(aHeader[_ni,2]))
			inclui := lInclui
		Else
			LBB->(dbSetOrder(1))
			LBB->(dbSeek(xFilial("LBB")+LBD->LBD_CODPRO))
			
			Do Case
				Case _ni == nPosCodPro
					aCols[Len(aCols),_ni] := LBB->LBB_CODPRO
				Case _ni == nPosDesc
					aCols[Len(aCols),_ni] := LBB->LBB_DESC
				Case _ni == nPosNomFor
					aCols[Len(aCols),_ni] := LBB->LBB_NOMFOR
				Case _ni == nPosTipoL
					aCols[Len(aCols),_ni] := Space(nTamTipoL)
				Case _ni == nPosCodRot
					aCols[Len(aCols),_ni] := LBD->LBD_CODROT
				OtherWise
					If aHeader[_ni,8] == "C"
						aCols[Len(aCols),_ni] := Space(aHeader[_ni,4])
					Else
						aCols[Len(aCols),_ni] := 0
					EndIf
			EndCase
		Endif
	Next
	
	aCols[Len(aCols),nUsado+1]:=.F.
	
	// Totaliza quantidade
	nTotQuant += aCols[Len(aCols),nPosQuant]  // Quantidade total apurada pélo sistema
	
	dbSelectArea("LBD")
	dbSkip()
	
Enddo

if !Inclui
	nQtdBal := nTotPlan
Endif

U_OrdemEnt(cOrdem_)

nTotDif := nTotPlan-nTotQuant
oGetDados:oBrowse:Refresh()
oGetDados:nMax:=Len(aCols) // maximo de linhas por getdados de entrada.

Return(.t.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CAC11DescRºAutor  ³                    º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exibe nome da linha                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CAC11DescR()
Local aAreaAnt := GetArea()
Local aAreaLBC := LBC->(GetArea())

dbSelectArea("LBC") // Rotas
dbSetOrder(1)       // LBC_FILIAL+LBC_CODROTA
dbSeek(xFilial("LBC")+cCodRota)
cDescRota := LBC->LBC_DESC
oDlg:Refresh()

RestArea(aAreaLBC)
RestArea(aAreaAnt)
Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GrvCAC11   ³ Autor ³  Manoel             ³ Data ³ 07/03/2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Gravacao                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvCAC11()
Local i
Local nQuantAnt 	:= 0
Local cCodigoL		:= ""
Local nX			:= 0

If nOpcG # 2 // nao for consulta
	
	For i := 1 to len(aCols)
		// e se for alteracao ????
		If aCols[i, nPosVolcri] == 0
			loop
		Endif
		
		dbselectArea("LBO")
		dbSetOrder(1)
		wProcura := dbseek(xFilial("LBO")+aCols[i,nPosCodPro]+Dtos(M->LBO_DATENT))
		If Inclui  .or. Altera
			If aCols[i,len(aCols[i])] .And. wProcura // exclusao
				RecLock("LBO",.F.,.T.)
				dbdelete()
				MsUnlock()
				WriteSx2("LBO")
				
				dbSelectArea("SD3")
				_cFilial := xFilial("SD3")
				dbselectArea("LBO")
				
				// Integracao
				dbSelectArea("LBB")
				dbSetOrder(1)
				If dbSeek(xFilial("LBB")+aCols[i,nPosCodPro])
					dbSelectArea("LBH")
					dbSetOrder(1)
					if dbSeek(xFilial("LBH")+LBB->LBB_EST+LBB->LBB_TIPOL)
						cCodigoL := LBH->LBH_CODPRO
					Endif
				Endif
				dbSelectArea("SB1")
				DbSeek(xFilial("SB1")+cCodigoL)
				
				cTipMov := GetMv("MV_CODMOVR") // Cancelamento da Entrada do Leite
				
				dbSelectArea("SD3")
				Reclock("SD3",.T.)
				SD3->D3_FILIAL  := _cFILIAL
				SD3->D3_COD     := cCodigoL
				SD3->D3_UM      := SB1->B1_UM
				SD3->D3_TM      := cTipMov
				SD3->D3_QUANT   := aCols[i, nPosVolcri]
				SD3->D3_LOCAL   := SB1->B1_LOCPAD
				SD3->D3_GRUPO   := SB1->B1_GRUPO
				SD3->D3_NUMSEQ  := ProxNum()
				SD3->D3_TIPO    := SB1->B1_TIPO
				SD3->D3_CONTA   := SB1->B1_CONTA
				SD3->D3_STSERV  :='N'
				SD3->D3_CUSTO1  := SB1->B1_CUSTD
				SD3->D3_USUARIO := "EXC ENTRADA LEITE"
				SD3->D3_EMISSAO := M->LBO_DATENT //dDataBase
				SD3->D3_CF      := GetMv("MV_TIPCFR")                 //"RE6" OU "RE0"
				SD3->D3_CHAVE   := SubStr(GetMv("MV_TIPCFR"),2,2)    //"E6"  OU "E0"
				
				dbSelectArea("SB2")
				dbSetorder(1)
				dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD,.F.)
				If found()
					SD3->D3_CUSTO1  := SB2->B2_CM1*SD3->D3_QUANT
				ELSE
					SD3->D3_CUSTO1  := SB1->B1_CUSTD*SD3->D3_QUANT
				Endif
				dbSelectArea("SD3")
				MsUnlock()
				
				dbSelectArea("SB2")
				dbSetorder(1)
				If dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD,.F.)
					Reclock("SB2",.f.)
					B2_QATU  := SB2->B2_QATU - aCols[i, nPosVolcri]
					B2_CM1   := SB1->B1_CUSTD
					B2_VATU1 := SB2->B2_CM1 * SB2->B2_QATU
					MsUnlock()
				Endif
				
				dbSelectArea("LBM")
				
				If left(aCols[i,nPosTipoL],1)  == "B"
					dbSetorder(1)
				ElseIf left(aCols[i,nPosTipoL],1)  == "C"
					dbSetorder(4)
				EndIf
				
				If dbSeek(xFilial("LBM") + cCodRota + Dtos(M->LBO_DATENT) + aCols[i,nPosCodPro] + aCols[i,nPosTipoL])
					RecLock("LBM",.F.,.T.)
					dbdelete()
					MsUnlock()
				Endif
			Else
				If !aCols[i,len(aCols[i])]
					dbSelectArea("LBB")
					dbSetOrder(1)
					dbSeek(xFilial("LBB")+aCols[i,nPosCodPro])
					if LBB->LBB_TIPOL == "B" // Leite B
						nCotaDentro := LBB->LBB_COTAB
						nLeiteC     := If(aCols[i, nPosVolcri] > LBB->LBB_COTAB,LBB->LBB_COTAT - LBB->LBB_COTAB,0)
					Else // Leite C
						nCotaDentro := LBB->LBB_COTAT
						nLeiteC     := 0
					Endif
					
					dbSelectArea("LBK")
					dbSetOrder(1)
					nQExc1 := 0
					nQExc2 := 0
					nQExc3 := 0
					nVExc1 := 0
					nVExc2 := 0
					nVExc3 := 0
					
					if nCotaDentro < aCols[i, nPosVolcri]
						
						if dbSeek(xFilial("LBK")+"1")
							nQExc1 := ((aCols[i, nPosVolcri] - (nCotaDentro+nLeiteC)) * LBK->LBK_PEREXC) / 100
						Endif
						if dbSeek(xFilial("LBK")+"2")
							nQExc2 := ((aCols[i, nPosVolcri] - (nCotaDentro+nLeiteC)) * LBK->LBK_PEREXC) / 100
						Endif
						if dbSeek(xFilial("LBK")+"3")
							nQExc3 := ((aCols[i, nPosVolcri] - (nCotaDentro+nLeiteC)) * LBK->LBK_PEREXC) / 100
						Endif
						dbSelectArea("LBH")
						dbSetOrder(1)
						if dbSeek(xFilial("LBH")+LBB->LBB_EST+"E1")
							nVExc1 := LBH->LBH_VALOR
						Endif
						if dbSeek(xFilial("LBH")+LBB->LBB_EST+"E2")
							nVExc2 := LBH->LBH_VALOR
						Endif
						if dbSeek(xFilial("LBH")+LBB->LBB_EST+"E3")
							nVExc3 := LBH->LBH_VALOR
						Endif
						
					Endif
					
					If ExistBlock("CA011AG")
						ExecBlock("CA011AG",.f.,.f.)
					EndIf
					
					dbselectArea("LBO")
					nQuantAnt := LBO->LBO_VOLCRI //LBO->LBO_QUANT //LBO->LBO_TOTPLA
					RecLock("LBO",If(wProcura,.F.,.T.))
					LBO->LBO_FILIAL  := xFilial("LBO")
					LBO->LBO_DATENT  := M->LBO_DATENT
					LBO->LBO_CODPRO  := aCols[i,nPosCodPro]
					LBO->LBO_NOMFOR  := aCols[i,nPosNomFor]
					LBO->LBO_QUANT   := aCols[i,nPosQuant]
					LBO->LBO_QTDACI  := aCols[i,nPosQtdAci]
					LBO->LBO_CRIOSC  := aCols[i,nPosCriosc]
					LBO->LBO_VOLCRI  := aCols[i,nPosVolcri]
					LBO->LBO_QCOTA   := nCotaDentro
					LBO->LBO_QEXC1   := nQExc1
					LBO->LBO_QEXC2   := nQExc2
					LBO->LBO_QEXC3   := nQExc3
					LBO->LBO_VEXC1   := nVExc1
					LBO->LBO_VEXC2   := nVExc2
					LBO->LBO_VEXC3   := nVExc3
					LBO->LBO_TOTPLA  := nTotPlan
					LBO->LBO_CODROT  := aCols[i,nPosCodRot]
					LBO->LBO_CODFOR  := Posicione("LBB", 1, xFilial("LBB")+aCols[i,nPosCodPro],"LBB_CODFOR+LBB_LOJA")
					// Tratamento para gravacao de campos de usuario
					If nUsado > nCpoPad
						For nX := (nCpoPad+1) To Len(aHeader)
							LBO->&(aHeader[nX,2]) := aCols[i,nX]
						Next nX
					EndIf
					MsUnlock()
					
					If ExistBlock("CA011DG")
						ExecBlock("CA011DG",.f.,.f.)
					EndIf
					
					
					// Inclui Integracao SD3, SB2
					
					
					dbSelectArea("SD3")
					_cFilial := xFilial("SD3")
					dbselectArea("LBO")
					
					dbSelectArea("LBB")
					dbSetOrder(1)
					If dbSeek(xFilial("LBB")+aCols[i,nPosCodPro])
						dbSelectArea("LBH")
						dbSetOrder(1)
						if dbSeek(xFilial("LBH")+LBB->LBB_EST+LBB->LBB_TIPOL)
							cCodigoL := LBH->LBH_CODPRO
						Endif
					Endif
					dbSelectArea("SB1")
					DbSeek(xFilial("SB1")+cCodigoL)
					
					cTipMov := GetMv("MV_CODMOVD") // Entrada do Leite
					
					dbSelectArea("SD3")
					dbsetorder(7) //D3_FILIAL+D3_COD+D3_LOCAL+DTOS(D3_EMISSAO)+D3_NUMSEQ
					lProcura := DbSeek(xFilial("SD3")+cCodigoL+Space(15-Len(cCodigoL))+SB1->B1_LOCPAD+Dtos(M->LBO_DATENT))
					
					Reclock("SD3",If(lProcura,.f.,.t.))
					If !lProcura // nao achou registro - INCLUI
						D3_FILIAL  := _cFilial  //xFILIAL("SD3")
						D3_COD     := cCodigoL
						D3_UM      := SB1->B1_UM
						D3_TM      := cTipMov
						D3_QUANT   := aCols[i, nPosVolcri]
						D3_LOCAL   := SB1->B1_LOCPAD
						D3_GRUPO   := SB1->B1_GRUPO
						D3_NUMSEQ  := ProxNum()
						D3_TIPO    := SB1->B1_TIPO
						D3_CONTA   := SB1->B1_CONTA
						D3_STSERV  :='N'
						D3_CUSTO1  := SB1->B1_CUSTD
						D3_USUARIO := "ENTRADA DE LEITE"
						D3_EMISSAO := M->LBO_DATENT
						D3_CF      := GetMv("MV_TIPCFD")                 //"DE6" OU "DE0"
						D3_CHAVE   := SubStr(GetMv("MV_TIPCFD"),2,2)    //"E6"  OU "E0"
					Else
						IF INCLUI
							D3_QUANT   := D3_QUANT + aCols[i, nPosVolcri]
						ELSEIF ALTERA .AND. nQuantAnt<> aCols[i, nPosVolcri]
							D3_QUANT   := D3_QUANT + aCols[i, nPosVolcri] - nQuantAnt  // SOMA A NOVA QUANTIDADE E ABATE A ANTERIOR
						ENDIF
					ENDIF
					
					dbSelectArea("SB2")
					dbSetorder(1)
					dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD,.F.)
					If found()
						SD3->D3_CUSTO1  := SB2->B2_CM1*SD3->D3_QUANT
					ELSE
						SD3->D3_CUSTO1  := SB1->B1_CUSTD*SD3->D3_QUANT
					Endif
					dbSelectArea("SD3")
					MsUnlock()
					
					dbSelectArea("SB2")
					dbSetorder(1)
					dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD,.F.)
					If Found()
						Reclock("SB2",.f.)
						B2_QATU  := SB2->B2_QATU + aCols[i, nPosVolcri] - nQuantAnt // SOMA A NOVA QUANTIDADE E ABATE A ANTERIOR
						B2_CM1   := SB1->B1_CUSTD
						B2_VATU1 := SB2->B2_CM1 * SB2->B2_QATU
						MsUnlock()
					Else
						Reclock("SB2",.T.)
						SB2->B2_FILIAL := xFilial("SB2")
						SB2->B2_COD    := cCodigoL
						SB2->B2_LOCAL  := SB1->B1_LOCPAD
						IF INCLUI
							SB2->B2_QATU  := SB2->B2_QATU + aCols[i, nPosVolcri]
						ELSEIF ALTERA .AND. nQuantAnt<> aCols[i, nPosVolcri]
							SB2->B2_QATU  := SB2->B2_QATU + aCols[i, nPosVolcri] - nQuantAnt  // SOMA A NOVA QUANTIDADE E ABATE A ANTERIOR
						ENDIF
						
						iF SB2->B2_CM1 == 0
							SB2->B2_VATU1 := SB1->B1_CUSTD * SB2->B2_QATU
							SB2->B2_CM1   := SB1->B1_CUSTD
						Else
							SB2->B2_VATU1 := SB2->B2_CM1 * SB2->B2_QATU
						Endif
						MsUnlock()
					EndIf
				Endif
			Endif
		Else
			If wProcura  // opcao exclusao do menu
				RecLock("LBO",.F.,.T.)
				dbdelete()
				MsUnlock()
				WriteSx2("LBO")
				
				dbSelectArea("SD3")
				_cFilial := xFilial("SD3")
				dbselectArea("LBO")
				
				// Integracao
				dbSelectArea("LBB")
				dbSetOrder(1)
				If dbSeek(xFilial("LBB")+aCols[i,nPosCodPro])
					dbSelectArea("LBH")
					dbSetOrder(1)
					if dbSeek(xFilial("LBH")+LBB->LBB_EST+LBB->LBB_TIPOL)
						cCodigoL := LBH->LBH_CODPRO
					Endif
				Endif
				dbSelectArea("SB1")
				DbSeek(xFilial("SB1")+cCodigoL)
				
				cTipMov := GetMv("MV_CODMOVR") // Cancelamento da Entrada do Leite
				
				dbSelectArea("SD3")
				Reclock("SD3",.T.)
				D3_FILIAL  := _cFilial //xFILIAL("SD3")
				D3_COD     := cCodigoL
				D3_UM      := SB1->B1_UM
				D3_TM      := cTipMov
				D3_QUANT   := aCols[i, nPosVolCri]
				D3_LOCAL   := SB1->B1_LOCPAD
				D3_GRUPO   := SB1->B1_GRUPO
				D3_NUMSEQ  := ProxNum()
				D3_TIPO    := SB1->B1_TIPO
				D3_CONTA   := SB1->B1_CONTA
				D3_STSERV  :='N'
				D3_CUSTO1  := SB1->B1_CUSTD
				D3_USUARIO := "EXC ENTRADA LEITE"
				D3_EMISSAO := M->LBO_DATENT //dDataBase
				D3_CF      := GetMv("MV_TIPCFR")                //"RE6" OU "RE0"
				D3_CHAVE   := SubStr(GetMv("MV_TIPCFR"),2,2)    //"E6"  OU "E0"
				MsUnlock()
				
				dbSelectArea("SB2")
				dbSetorder(1)
				dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD,.F.)
				Reclock("SB2",!Found())
				B2_FILIAL := xFilial("SB2")
				B2_COD    := cCodigoL
				B2_LOCAL  := SB1->B1_LOCPAD
				B2_QATU   := SB2->B2_QATU - aCols[i, nPosVolCri]
				B2_VATU1  := SB2->B2_CM1 * SB2->B2_QATU
				MsUnlock()
				
			Endif
		Endif
		If ExistBlock("GMOVINTE")
			ExecBlock("GMOVINTE",.f.,.f.,{i, wProcura, cCodigoL, nQuantAnt, SD3->D3_TM})
		EndIf
	Next
Endif

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CACCOA11  ºAutor  ³ Choite             º Data ³  14/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ FieldOK                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Calcular e mostrar total da quatidade                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FO_COA11()

Local i
Local nFaixa
Local nFormula

if ReadVar() == "M->LBO_CRIOSC" .Or. ReadVar() == "M->LBO_QUANT"
	//Levanta Crioscopia
	nFaixa   := GetMv("MV_FXCRIOS")
	nFormula := GetMv("MV_FMCRIOS")
	if nFaixa > 0
		If IIf(ReadVar() == "M->LBO_QUANT", aCols[n, nPosCriosc], M->LBO_CRIOSC) > 0 .And. ;
			IIf(ReadVar() == "M->LBO_QUANT", aCols[n, nPosCriosc], M->LBO_CRIOSC) < nFaixa
			nQtdade    := IIf(ReadVar() == "M->LBO_QUANT", M->LBO_QUANT, aCols[n,nPosQuant])
			nCriosc    := IIf(ReadVar() == "M->LBO_QUANT", aCols[n, nPosCriosc], M->LBO_CRIOSC)
			nVolCri    := (&(&nFormula))
			nVolCri    := IIf(ReadVar() == "M->LBO_QUANT", M->LBO_QUANT, aCols[n, nPosQuant]) - Round(nVolCri, 0)
			nVolCri    := IIf(nVolCri > 0, nVolCri, 0)
			aCols[n,nPosVolcri] := nVolCri
		Else
			aCols[n,nPosVolcri] := IIf(ReadVar() == "M->LBO_QUANT", M->LBO_QUANT, aCols[n, nPosQuant])
		Endif
	Else
		aCols[n,nPosVolcri] := IIf(ReadVar() == "M->LBO_QUANT", M->LBO_QUANT, aCols[n, nPosQuant])
	Endif
Endif

// Exibe Totais de quantidade
if ReadVar()=="M->LBO_QUANT" .OR. READVAR()=="NTOTPLAN"
	
	if ReadVar()=="M->LBO_QUANT"
		If M->LBO_QUANT == 0 .AND. aCols[n,nPosQuant] > 0
			Alert("Para zerar quantidade utilize a tecla DEL para deletar lancamento")
			Return(.F.)
		Endif
	Endif
	
	nTotQuant := 0
	
	if ReadVar()=="M->LBO_QUANT"
		aCols[n,nPosQuant] := M->LBO_QUANT
	Endif
	
	For i:=1 to len(aCols)
		if !aCols[i,len(aCols[i])]
			nTotQuant += aCols[i,nPosQuant]  //Quantidade total apurada pélo sistema
		Endif
	Next
	nTotDif := nTotPlan-nTotQuant
	oTotDif:refresh()
	oTotQuant:refresh()
Endif

Return(.t.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CACOL11R ³ Autor ³ Jose Choite Kita jr   ³ Data ³ 23/05/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Relatorio de Incosnsistencia nas entradas          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User function CACOL11R()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PARAMETROS                                                       ³
//³ MV_PAR01   Do Motorista                                          ³
//³ MV_PAR02   Ate o Motorista                                       ³
//³ MV_PAR03   Da Linha                                              ³
//³ MV_PAR04   Ate o a Linha                                         ³
//³ MV_PAR05   Data da Entrada                                       ³
//³ MV_PAR06   Ate Data de Entrada                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pergunta                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPerg  := "CCOA11"
GeraX1()
if !pergunte(cPerg,.T.)
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aOrd        := {}
titulo      := "Divergencia na Entrada de Leite"
cDesc1      := "Imprime Relatorio de " +titulo
cDesc2      := ""
cDesc3      := ""
lAbortPrint := .F.
tamanho     := "P"
nomeprog    := "CACCOA11"
nTipo       := 18
aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 3}
nLin        := 70
cCabec1 	   := ""
cCabec2		:= ""
m_pag       := 01
wnrel       := "CACCOA11"
lDic        := .F.
lComp       := .F.
cString     := "LBO"

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrd,lComp,tamanho)

if nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
if nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| ExecImp(cCabec1,cCabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ ExecImp  º Autor ³ Choite             º Data ³ 23.05.03    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ExecImp(Cabec1,Cabec2,Titulo,nLin)


//TOTAL PARA REGUA
cSql := "SELECT COUNT(LBD.LBD_FILIAL) AS TOTREG"
cSql += " FROM " + RetSQLName("LBO") + " LBO, "
cSql += RetSQLName("LBC") + " LBC,"
cSql += RetSQLName("LBD") + " LBD "
cSql += " WHERE LBO.LBO_FILIAL='" + XFILIAL("LBO") + "' AND"
cSql += " LBC.LBC_FILIAL='" + XFILIAL("LBC") + "' AND"
cSql += " LBD.LBD_FILIAL='" + XFILIAL("LBD") + "' AND"
cSql += " LBO.LBO_CODPRO=LBD.LBD_CODPRO AND"
cSql += " LBC.LBC_CODROT=LBD.LBD_CODROT AND"
cSql += " LBD.LBD_CODROT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND"
cSql += " LBO.LBO_DATENT BETWEEN '" + DTOS(mv_par05) + "' AND '" + DTOS(mv_par06) + "' AND"
cSql += " LBO.D_E_L_E_T_ = ' ' AND"
cSql += " LBC.D_E_L_E_T_ = ' ' AND"
cSql += " LBD.D_E_L_E_T_ = ' '"
cSql := ChangeQuery(cSql)
TCQUERY cSql NEW ALIAS "TOT"
dbSelectArea("TOT")
dbGoTop()
SetRegua(TOT->TOTREG)
dbCloseArea()

// SELECIONA QUANTIDADES POR DIA
cSql := "SELECT LBC.LBC_CODCAM, LBO.LBO_CODROT,LBO.LBO_DATENT, MAX(LBE_MOTO) AS NOMEMOT, MAX(LBC.LBC_DESC) AS DESCLIN, SUM(LBO_QUANT) AS TOTAPUR,MAX(LBO_TOTPLA) AS TOTPLAN"
cSql += " FROM " + RetSQLName("LBO") + " LBO, "
cSql += RetSQLName("LBC") + " LBC,"
cSql += RetSQLName("LBD") + " LBD,"
cSql += RetSQLName("LBE") + " LBE "
cSql += " WHERE LBO.LBO_FILIAL='" + XFILIAL("LBO") + "' AND"
cSql += " LBC.LBC_FILIAL='" + XFILIAL("LBO") + "' AND"
cSql += " LBO.LBO_CODPRO=LBD.LBD_CODPRO AND"
cSql += " LBC.LBC_CODROT=LBO.LBO_CODROT AND"
cSql += " LBC.LBC_CODCAM=LBE.LBE_CODCAM AND"
cSql += " LBC.LBC_CODCAM BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND"
cSql += " LBO.LBO_CODROT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND"
cSql += " LBO.LBO_DATENT BETWEEN '" + DTOS(mv_par05) + "' AND '" + DTOS(mv_par06) + "' AND"
cSql += " LBO.D_E_L_E_T_ = ' ' AND"
cSql += " LBC.D_E_L_E_T_ = ' ' AND"
cSql += " LBD.D_E_L_E_T_ = ' ' AND"
cSql += " LBE.D_E_L_E_T_ = ' '"
cSql += " GROUP BY LBC.LBC_CODCAM,LBO.LBO_CODROT,LBO.LBO_DATENT"
cSql += " ORDER BY LBC.LBC_CODCAM,LBO.LBO_CODROT,LBO.LBO_DATENT"

cSql := ChangeQuery(cSql)
TCQUERY cSql NEW ALIAS "ENT"

nTotApur := 0
nTotPlan := 0
nTotApurT:= 0
nTotPlanT:= 0

dbSelectArea("ENT")
dbGoTop()
cLinha  := ENT->LBO_CODROT
cCodMot := ENT->LBC_CODCAM
while !eof()
	IncRegua()
	
	if (ENT->TOTPLAN-ENT->TOTAPUR) == 0
		cLinha := ENT->LBO_CODROT
		dbSkip()
		Loop
	Endif
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	if nLin>55 .or. cCodMot <> ENT->LBC_CODCAM
		cCabec1 	 := "Linha: " + alltrim(ENT->LBO_CODROT) + "-" + alltrim(ENT->DESCLIN) + space(3)
		cCabec1 	 += "Mot: " + alltrim(ENT->NOMEMOT)
		cCabec1      := substr(cCabec1,1,80)
		cCabec2	     := "Data              Leite Bom    Entrada   Diferenca"
		nLin         := Cabec(Titulo, cCabec1, cCabec2, NomeProg, tamanho, nTipo)+1
		cCodMot      := ENT->LBC_CODCAM
	Endif
	
	@nLin,000 PSAY stod(ENT->LBO_DATENT) PICTURE "@D"
	@nLin,018 PSAY ENT->TOTPLAN PICTURE "999999999"
	@nLin,029 PSAY ENT->TOTAPUR PICTURE "999999999"
	@nLin,041 PSAY (ENT->TOTPLAN-ENT->TOTAPUR) PICTURE "999999999"
	
	nLin++
	nTotPlan  += ENT->TOTPLAN
	nTotApur  += ENT->TOTAPUR
	nTotPlanT += ENT->TOTPLAN
	nTotApurT += ENT->TOTAPUR
	
	dbSkip()
	
	if cLinha<>ENT->LBO_CODROT
		cLinha := ENT->LBO_CODROT
		@nLin++,000 PSAY replicate("_",80)
		@nLin,000 PSAY "TOTAL DA LINHA"
		@nLin,018 PSAY nTotPlan PICTURE "999999999"
		@nLin,029 PSAY nTotApur PICTURE "999999999"
		@nLin,041 PSAY (nTotPlan-nTotApur) PICTURE "999999999"
		nTotApur := 0
		nTotPlan := 0
		if cCodMot == ENT->LBC_CODCAM
			nLin+=3
			@nLin,000 PSAY "Linha: " + alltrim(ENT->LBO_CODROT) + "-" + alltrim(ENT->DESCLIN) + space(3)
			nLin++
			@nLin,000 PSAY "Data              Leite Bom    Entrada   Diferenca"
			nLin++
		Else
			nLin+=2
			@nLin++,000 PSAY replicate("_",80)
			@nLin,000 PSAY "TOTAL DO MOTORISTA"
			@nLin,018 PSAY nTotPlanT PICTURE "999999999"
			@nLin,029 PSAY nTotApurT PICTURE "999999999"
			@nLin,041 PSAY (nTotPlanT-nTotApurT) PICTURE "999999999"
			nTotApurT := 0
			nTotPlanT := 0
			nLin      := 80
		Endif
	Endif
	
Enddo

dbSelectArea("ENT")
dbCloseArea()

Set Device to Screen

if aReturn[5]==1
	dbCommitAll()
	Set Printer To
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GeraX1   ³ Autor ³ MICROSIGA             ³ Data ³ 21/03/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Uso Generico.                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraX1()

Local i, j
Local _sAlias	:= Alias()
Local aRegs		:= {}
Local nTamSX1   := Len(SX1->X1_GRUPO)

dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek(PADR(cPerg,nTamSX1)+"01") .And. Empty(X1_PERSPA)
	While !Eof() .And. Trim(X1_GRUPO) == cPerg
		RecLock("SX1",.F.)
		dbDelete()
		MsUnLock()
		dbSkip()
	EndDo		
EndIf

AADD(aRegs,{cPerg,"01","Do Motorista       ?","Do Motorista       ?","Do Motorista       ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate o Motorista    ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Da Linha           ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate a Linha        ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Da Data Entrada    ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate a Data Entrada ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !MsSeek(PADR(cPerg,nTamSX1)+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			if j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ExistRota³ Autor ³ Choite                ³ Data ³ 23/05/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se existe entrada para a linha na data            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Controle de entradas de leite                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ExistRota(nOpcao)

Local cret := .T.
Local aArea := GetArea()

IF nOpcao == 1
	dbSelectArea("LBP")
	dbSetOrder(2)
	cmes := StrZero(Month(M->LBO_DATENT), 2)
	Set SoftSeek On
	dbSeek(xFilial("LBP") + Dtos(CTod("01/" + strzero(month(M->LBO_DATENT), 2) + "/" + Str(year(M->LBO_DATENT), 4))))
	if Str(year(M->LBO_DATENT), 4) + strzero(month(M->LBO_DATENT), 2) ==  Subs(Dtos(LBP->LBP_DATINI), 1, 6)
		MsgStop("O Mes " + cMes + " ja foi fechado, nao pode haver novas entradas!", "Atencao")
		cRet := .F.
	Endif
	Set SoftSeek Off
Endif

if Inclui
	dbSelectArea("LBD") //ITENS DO CADASTRO DE ROTAS
	dbSetOrder(1)       //LBD_FILIAL+LBD_CODROTA+LBD_SEQ+LBD_CODPRO
	dbSeek(xFilial("LBD")+cCodRota)
	// Verifica se alguma propriedade da linha ja tem lancamento na data
	While LBD->LBD_FILIAL+LBD->LBD_CODROT == xFilial("LBD") + cCodRota .and. !eof()
		LBO->(dbSetOrder(1))
		if LBO->(dbSeek(xFilial("LBO")+LBD->LBD_CODPRO+Dtos(M->LBO_DATENT)))
			Alert("Ja existe entrada para a linha "+cCodRota+" em "+dtoc(M->LBO_DATENT))
			cRet := .F.
			Exit
		Endif
		dbSelectArea("LBD")
		dbSkip()
	EndDo
Endif

IF nOpcao == 1
	If ExistBlock("CA011DT") 
		cRet := ExecBlock("CA011DT",.F.,.F.)
		If ValType( cRet ) <> "L"
			cRet := .T.
		Endif
	Endif     
Endif

RestArea(aArea)

Return(cRet)


//////////////////////////////////////
User Function OrdemEnt(cOrdem_,lOp)

Default lOp := .t.

If Subs(cOrdem_,1,1) = "1"
	aCols := aClone(Asort(aCols,,,{|x,y| x[nPosCodPro] < y[nPosCodPro] }))
Else
	aCols := aClone(Asort(aCols,,,{|x,y| x[nPosNomFor] < y[nPosNomFor] }))
Endif

if lOp
	oGetDados:oBrowse:Refresh()
Endif

Return(.t.)
