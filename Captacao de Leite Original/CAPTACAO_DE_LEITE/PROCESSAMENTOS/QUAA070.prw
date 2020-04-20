#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ QUAA070  ³ Autor ³Darlan A. Freitas Maciel ³ Data ³ 01/03/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ CADASTRO DE DESPESAS DO PRODUTOR (Mod3)                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³ Controle das despesas do produtor rural.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.  ³  Data  ³ Bops ³ Manutencao Efetuada                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Priscila Prado  ³14/06/08³ ---- ³ Ajustes do PL 42                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QUAA070()                                         
Local aArea      := GetArea()

Private aRotina    := {}
Private cAlias1    := "PA5"
Private cAlias2    := "PA6" 
Private cFilPA5    := xFilial("PA5")
Private cFilPA6    := xFilial("PA6")
Private lGeraSE2   := .F.
Private nMax	   := 2500

aAdd( aRotina, { "Pesquisar"  , "AxPesqui" , 0 , 1 })
aAdd( aRotina, { "Visualizar" , 'u_QuaVis' , 0 , 2 })
aAdd( aRotina, { "Incluir"    , 'u_QuaInc' , 0 , 3 })
aAdd( aRotina, { "Alterar"    , 'u_QuaAlt' , 0 , 4 })
aAdd( aRotina, { "Excluir"    , 'u_QuaExc' , 0 , 5 })

dbSelectArea(cAlias2)
dbSetOrder(1)

mBrowse( ,,,,"PA5")

RestArea( aArea )
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ QuaVis   ³ Autor ³Darlan A. Freitas Maciel ³ Data ³ 22/08/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de visualizacao                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QuaVis( cAlias, nRecNo, nOpc )
Local nX        := 0
Local nCols     := 0
Local nOpcA     := 0
Local oDlg      := Nil
Local oGet      := Nil
Local oMainWnd  := Nil

Private aTela   := {}
Private aGets   := {}
Private aHeader := {}
Private aCols   := {}
Private bCampo  := { |nField| Field(nField) }
Private nUsado     := 0
Private cCadastro  := "Cadastro de despesas do Produtor"
Private aPos       := {15, 1, 70, 315}
Private aSize    := {}
Private aObjects := {}
Private aInfo    := {}
Private aPosObj  := {}
Private aPosGet  := {} 

Private v_Campos := ("PA6_FILIAL|PA6_FORNEC|PA6_LOJA|PA6_PERIOD|PA6_TIPDES")

aSize := MsAdvSize()
aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

aAdd(aObjects,{100,045,.T.,.F.})
aAdd(aObjects,{100,100,.T.,.T.})

aPosObj := MsObjSize(aInfo,aObjects)
aPosGet := MsObjGetPos((aSize[3]-aSize[1]),315,{{004,024,240,270}} )
aPosObj[1,3]+=60
//+----------------------------------
//| Inicia as variaveis para Enchoice
//+----------------------------------
dbSelectArea(cAlias1)
dbSetOrder(1)
dbGoTo(nRecNo)
For nX:= 1 To FCount()
	M->&(Eval(bCampo,nX)) := FieldGet(nX)
Next nX

//+----------------
//| Monta o aHeader
//+----------------
CriaHeader()

//+--------------
//| Monta o aCols
//+--------------
dbSelectArea(cAlias2)
dbSetOrder(1)
MsSeek(cFilPA6+PA5->PA5_FORNEC+PA5->PA5_LOJA+PA5->PA5_PERIOD+PA5->PA5_TIPDES)

While !Eof() .And. cFilPA6 == PA6->PA6_FILIAL .And. PA6->PA6_FORNEC == PA5->PA5_FORNEC .And. PA6->PA6_LOJA == PA5->PA5_LOJA .And. PA6->PA6_PERIOD == PA5->PA5_PERIOD .And. PA6->PA6_TIPDES == PA5->PA5_TIPDES
   aAdd(aCols,Array(nUsado+1))
   nCols ++
   
   For nX := 1 To nUsado
      If ( aHeader[nX][10] != "V")
         aCols[nCols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
      Else
         aCols[nCols][nX] := CriaVar(aHeader[nX][2],.T.)
      Endif
   Next nX
   
   aCols[nCols][nUsado+1] := .F.
   dbSelectArea(cAlias2)
   dbSkip()
End

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],aSize[1] TO aSize[6],aSize[5]  OF oMainWnd PIXEL
EnChoice(cAlias, nRecNo, nOpc,,,,, aPosObj[1])

oGet := MsGetDados():New(aPosObj[2,1]+10,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(oGet:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()})

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ QuaInc   ³ Autor ³Darlan A. Freitas Maciel ³ Data ³ 22/08/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de inclusao                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QuaInc( cAlias, nRecNo, nOpc )
Local nOpcA      := 0
Local nX         := 0
Local oDlg       := Nil

Private aTela    := {}
Private aGets    := {}
Private aHeader  := {}
Private aCols    := {}
Private bCampo   := {|nField| FieldName(nField) }
Private nUsado     := 0
Private cCadastro  := "Cadastro de despesas do Produtor"
Private aPos       := {15, 1, 70, 315}
Private aSize    := {}
Private aObjects := {}
Private aInfo    := {}
Private aPosObj  := {}
Private aPosGet  := {} 

Private v_Campos := ("PA6_FILIAL|PA6_FORNEC|PA6_LOJA|PA6_PERIOD|PA6_TIPDES")

aSize := MsAdvSize()
aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

aAdd(aObjects,{100,045,.T.,.F.})
aAdd(aObjects,{100,100,.T.,.T.})

aPosObj := MsObjSize(aInfo,aObjects)
aPosGet := MsObjGetPos((aSize[3]-aSize[1]),315,{{004,024,240,270}} )
aPosObj[1,3]+=60
//+--------------------------------------
//| Cria Variaveis de Memoria da Enchoice
//+--------------------------------------
dbSelectArea(cAlias1)
For nX := 1 To FCount()
	M->&(Eval(bCampo,nX)) := CriaVar(FieldName(nX),.T.)
Next nX

//+----------------
//| Monta o aHeader
//+----------------
CriaHeader()

//+--------------
//| Monta o aCols
//+--------------
aAdd(aCols,Array(nUsado+1))
nUsado := 0
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias2)
While !Eof() .And. SX3->X3_ARQUIVO == cAlias2
	If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. !Alltrim(SX3->X3_CAMPO) $ v_Campos
		nUsado++
		aCols[1][nUsado] := CriaVar(Trim(SX3->X3_CAMPO),.T.)
	Endif
	dbSkip()
End

aCols[1][nUsado+1] := .F.
aCols[1][aScan(aHeader,{|x| Trim(x[2])=="PA6_SEQ"})] := "0001"

//+----------------------------------
//| Envia para processamento dos Gets
//+----------------------------------
DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL
EnChoice( cAlias, nRecNo, nOpc, , , , , aPosObj[1])

//oGet := MSGetDados():New(aPosObj[2,1]+10,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_QuaLinhaOK()","u_QuaTd_Ok()","+PA6_SEQ",.T.)

oGet := MSGetDados():New(aPosObj[2,1]+10,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_QuaLinhaOK()","u_QuaTd_Ok()","+PA6_SEQ",.T.,,,,nMax)
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpcA:=1,If(u_QuaTd_Ok().And.Obrigatorio(aGets,aTela),oDlg:End(),nOpca:=0)},{||nOpca:=0,oDlg:End()})

If nOpcA == 1
//	Begin Transaction
	If QuaGrava(1,Nil,lGeraSE2)
		EvalTrigger()
	Else
		DisarmTransaction()		
	EndIf
	//End Transaction
EndIf
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ QuaAlt   ³ Autor ³Darlan A. Freitas Maciel ³ Data ³ 22/08/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de alteracao                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QuaAlt( cAlias, nRecNo, nOpc )
Local nOpcA      := 0
Local nX         := 0
Local nCols      := 0
Local oDlg       := Nil
Local nValTit    := PA5->PA5_VALOR
Local aArea      := {}
Private aTela    := {}
Private aGets    := {}
Private aHeader  := {}
Private aCols    := {}
Private aAltera  := {}
Private bCampo   := {|nField| FieldName(nField) }
Private nUsado     := 0
Private cCadastro  := "Cadastro de despesas do Produtor"
Private aPos       := {15, 1, 70, 315}
Private aSize    := {}
Private aObjects := {}
Private aInfo    := {}
Private aPosObj  := {}
Private aPosGet  := {} 

Private v_Campos := ("PA6_FILIAL|PA6_FORNEC|PA6_LOJA|PA6_PERIOD|PA6_TIPDES")

aSize := MsAdvSize()
aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

aAdd(aObjects,{100,045,.T.,.F.})
aAdd(aObjects,{100,100,.T.,.T.})

aPosObj := MsObjSize(aInfo,aObjects)
aPosGet := MsObjGetPos((aSize[3]-aSize[1]),315,{{004,024,240,270}} )
aPosObj[1,3]+=60
//+----------------------------------
//| Inicia as variaveis para Enchoice
//+----------------------------------
dbSelectArea(cAlias1)
dbSetOrder(1)
dbGoTo(nRecNo)
For nX := 1 To FCount()
	M->&(Eval(bCampo,nX)) := FieldGet(nX)
Next nX

//+----------------
//| Monta o aHeader
//+----------------
CriaHeader()

//+--------------
//| Monta o aCols
//+--------------
dbSelectArea(cAlias2)
dbSetOrder(1)
MsSeek(cFilPA6+PA5->PA5_FORNEC+PA5->PA5_LOJA+PA5->PA5_PERIOD+PA5->PA5_TIPDES)

While !Eof() .And. cFilPA6 == PA6->PA6_FILIAL .And. PA6->PA6_FORNEC == PA5->PA5_FORNEC .And. PA6->PA6_LOJA == PA5->PA5_LOJA .And. PA6->PA6_PERIOD == PA5->PA5_PERIOD .And. PA6->PA6_TIPDES == PA5->PA5_TIPDES
   aAdd(aCols,Array(nUsado+1))
   nCols ++
   
   For nX := 1 To nUsado
      If ( aHeader[nX][10] != "V")
         aCols[nCols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
      Else
         aCols[nCols][nX] := CriaVar(aHeader[nX][2],.T.)
      Endif
   Next nX
   
   aCols[nCols][nUsado+1] := .F.
   dbSelectArea(cAlias2)
   aAdd(aAltera,RecNo())
   dbSkip()
End

aArea := GetArea()
dbSelectArea("LBP")
dbSetOrder(2)
If DbSeek(xFilial("LBP") + Dtos(CTod("01/" + SubStr(M->PA5_PERIOD,1,2) + "/" + SubStr(M->PA5_PERIOD,3,6))))
	If Subs(Dtos(CTod("01/" + SubStr(M->PA5_PERIOD,1,2) + "/" + SubStr(M->PA5_PERIOD,3,6))),1,6) ==  Subs(Dtos(LBP->LBP_DATINI), 1, 6)
		MsgStop("O Mes " + SubStr(M->PA5_PERIOD,1,2) + " ja foi fechado e nao pode ser alterado!","Atencao")
		RestArea(aArea)
		Return(.f.)
	Endif
Endif
RestArea(aArea)


//+----------------------------------
//| Envia para processamento dos Gets
//+----------------------------------
DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL 
EnChoice( cAlias, nRecNo, nOpc, , , , , aPosObj[1])

oGet := MSGetDados():New(aPosObj[2,1]+10,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_QuaLinhaOK()","u_QuaTd_Ok()","+PA6_SEQ",.T.,,,,nMax)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca:=1,If(u_QuaTd_Ok().And.Obrigatorio(aGets,aTela),oDlg:End(),nOpca:=0)},{||nOpca:=0,oDlg:End()})

If nOpcA == 1
//	Begin Transaction 
	If nValTit == M->PA5_VALOR
		lGeraSE2 := .F.
	Endif
	If QuaGrava(2,aAltera,lGeraSE2)
		EvalTrigger()
	EndIf
	//End Transaction
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ QuaExc   ³ Autor ³Darlan A. Freitas Maciel ³ Data ³ 22/08/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de exclusao                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QuaExc( cAlias, nRecNo, nOpc )
Local nX        := 0
Local nCols     := 0
Local nOpcA     := 0
Local oDlg      := Nil
Local oGet      := Nil
Local oMainWnd  := Nil

Private aTela   := {}
Private aGets   := {}
Private aHeader := {}
Private aCols   := {}
Private bCampo  := { |nField| Field(nField) }
Private nUsado     := 0
Private cCadastro  := "Cadastro de despesas do Produtor"
Private aPos       := {15, 1, 70, 315}
Private aSize    := {}
Private aObjects := {}
Private aInfo    := {}
Private aPosObj  := {}
Private aPosGet  := {} 

Private v_Campos := ("PA6_FILIAL|PA6_FORNEC|PA6_LOJA|PA6_PERIOD|PA6_TIPDES")

aSize := MsAdvSize()
aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

aAdd(aObjects,{100,045,.T.,.F.})
aAdd(aObjects,{100,100,.T.,.T.})

aPosObj := MsObjSize(aInfo,aObjects)
aPosGet := MsObjGetPos((aSize[3]-aSize[1]),315,{{004,024,240,270}} )
aPosObj[1,3]+=60

//+----------------------------------
//| Inicia as variaveis para Enchoice
//+----------------------------------
dbSelectArea(cAlias1)
dbSetOrder(1)
dbGoTo(nRecNo)
For nX:= 1 To FCount()
	M->&(Eval(bCampo,nX)) := FieldGet(nX)
Next nX

//+----------------
//| Monta o aHeader
//+----------------
CriaHeader()

//+--------------
//| Monta o aCols
//+--------------
dbSelectArea(cAlias2)
dbSetOrder(1)
MsSeek(cFilPA6+PA5->PA5_FORNEC+PA5->PA5_LOJA+PA5->PA5_PERIOD+PA5->PA5_TIPDES)

While !Eof() .And. cFilPA6 == PA6->PA6_FILIAL .And. PA6->PA6_FORNEC == PA5->PA5_FORNEC .And. PA6->PA6_LOJA == PA5->PA5_LOJA .And. PA6->PA6_PERIOD == PA5->PA5_PERIOD .And. PA6->PA6_TIPDES == PA5->PA5_TIPDES
   aAdd(aCols,Array(nUsado+1))
   nCols ++
   
   For nX := 1 To nUsado
      If ( aHeader[nX][10] != "V")
         aCols[nCols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
      Else
         aCols[nCols][nX] := CriaVar(aHeader[nX][2],.T.)
      Endif
   Next nX
   
   aCols[nCols][nUsado+1] := .F.
   dbSelectArea(cAlias2)
   dbSkip()
End

aArea := GetArea()
dbSelectArea("LBP")
dbSetOrder(2)
If DbSeek(xFilial("LBP") + Dtos(CTod("01/" + SubStr(M->PA5_PERIOD,1,2) + "/" + SubStr(M->PA5_PERIOD,3,6))))
	If Subs(Dtos(CTod("01/" + SubStr(M->PA5_PERIOD,1,2) + "/" + SubStr(M->PA5_PERIOD,3,6))),1,6) ==  Subs(Dtos(LBP->LBP_DATINI), 1, 6)
		MsgStop("O Mes " + SubStr(M->PA5_PERIOD,1,2) + " ja foi fechado e nao pode ser alterado!","Atencao")
		RestArea(aArea)
		Return(.f.)
	Endif
Endif
RestArea(aArea)

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL 
EnChoice(cAlias, nRecNo, nOpc,,,,, aPosObj[1])

oGet := MsGetDados():New(aPosObj[2,1]+10,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,,,"+PA6_SEQ",.T.,,,,nMax)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(oGet:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()})

If nOpcA == 1
//	Begin Transaction
	If QuaGrava(3,Nil,lGeraSE2)
		EvalTrigger()
	EndIf
	//End Transaction
Endif

Return .T.                                            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CriaHeader³ Autor ³Darlan A. Freitas Maciel ³ Data ³ 22/08/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para criar variaveis no vetor aHeader.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaHeader()
nUsado  := 0
aHeader := {}
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias2)
While ( !Eof() .And. SX3->X3_ARQUIVO == cAlias2 )
   If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL ) .And. !Alltrim(SX3->X3_CAMPO) $ v_Campos
      aAdd(aHeader,{ Trim(X3Titulo()), ;
                     SX3->X3_CAMPO   , ;
                     SX3->X3_PICTURE , ;
                     SX3->X3_TAMANHO , ;
                     SX3->X3_DECIMAL , ;
                     SX3->X3_VALID   , ;
                     SX3->X3_USADO   , ;
                     SX3->X3_TIPO    , ;
                     SX3->X3_ARQUIVO , ;
                     SX3->X3_CONTEXT } )
      nUsado++
   Endif
   dbSkip()
End
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³QuaLinhaOK³ Autor ³Darlan A. Freitas Maciel ³ Data ³ 22/08/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para Validar a linha antes de mover p/ cima ou p/ baixo.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QuaLinhaOK()
Local lRet  := .T.
Local cMsg  := ""
Local cChav := ""
Local nI    := 0

//+----------------------------------------------------
//| Verifica se o codigo esta em branco, se ok bloqueia
//+----------------------------------------------------
//| Se a linha nao estiver deletada.
If !aCols[n][nUsado+1]
	//Verifica campos obrigatorios
	If Empty(aCols[n][QuaPesq("PA6_VALOR")]) .Or. Empty(aCols[n][QuaPesq("PA6_CODPRO")]) 
		cMsg := "Existe(m) campo(s) obrigatório(s) não preenchido(s)."
		MsgAlert(cMsg)
		lRet := .F.
	Endif
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³QuaTd_Ok  ³ Autor ³Darlan A. Freitas Maciel ³ Data ³ 22/08/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para aliar se todas as linhas estao ok.                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QuaTd_Ok()
Local lRet    := .T.
Local nAux    := 0 
Local nValAux := 0 

For nAux:=1 To Len(aCols)
	If !aCols[nAux][nUsado+1]
		nValAux += aCols[nAux][QuaPesq("PA6_VALOR")]
	Endif
Next
     
M->PA5_VALOR := nValAux
                      
lRet := u_QuaLinhaOK()

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³QuaGrava  ³ Autor ³Darlan A. Freitas Maciel ³ Data ³ 22/08/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao p/ Grava os dados nas variaveis M->??? e no vetor aGETS.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QuaGrava(nOpc,aAltera,lGeraSE2)
Local lGravou  	:= .F.
Local nUsado   	:= 0
Local nSeq     	:= 1
Local nX       	:= 0
Local nI       	:= 0
Local aTiPag   	:= {}
Local cPrefixo 	:= GetMv("MV_PREFSE2",,"PGP")
Local cTpTit   	:= GetMv("ES_TIPTIT",,"BOL")
Local cNaTit  	:= GetMv("ES_NATIT",,"SAL-IND")
Private bCampo 	:= { |nField| FieldName(nField) }
Private lMsErroAuto


nUsado := Len(aHeader) + 1

//+----------------
//| Se for inclusao
//+----------------
If nOpc == 1
	//+--------------------------
	//| Colocar os itens em ordem
	//+--------------------------
	aSort(aCols,,,{|x,y| x[1] < y[1] })
	
	//+---------------
	//| Grava os itens
	//+---------------
	dbSelectArea(cAlias2)
	dbSetOrder(1)
	For nX := 1 To Len(aCols)
		If !aCols[nX][nUsado]
			RecLock(cAlias2,.T.)
			For nI := 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[nI,2])),aCols[nX,nI])
			Next nI
			PA6->PA6_FILIAL := cFilPA6
			PA6->PA6_SEQ    := StrZero(nSeq,4)
			PA6->PA6_FORNEC := M->PA5_FORNEC
			PA6->PA6_LOJA   := M->PA5_LOJA
			PA6->PA6_PERIOD := M->PA5_PERIOD
			PA6->PA6_TIPDES := M->PA5_TIPDES
			MsUnLock()
			nSeq ++
			lGravou := .T.
			
		Endif
	Next nX
	
	//+------------------
	//| Grava o Cabecalho
	//+------------------
	If lGravou
		dbSelectArea(cAlias1)
		RecLock(cAlias1,.T.)
		For nX := 1 To FCount()
			If "FILIAL" $ FieldName(nX)
				FieldPut(nX,cFilPA5)
			Else
				FieldPut(nX,M->&(Eval(bCampo,nX)))
			Endif
		Next nX
		MsUnLock()
	Endif
Endif

//+-----------------
//| Se for alteracao
//+-----------------
If nOpc == 2
	//+--------------------------------------
	//| Grava os itens conforme as alteracoes
	//+--------------------------------------
	dbSelectArea(cAlias2)
	dbSetOrder(1)
	For nX := 1 To Len(aCols)
		If nX <= Len(aAltera)
			dbGoto(aAltera[nX])
			RecLock(cAlias2,.F.)
			If aCols[nX][nUsado]
				dbDelete()
			EndIf
		Else
			If !aCols[nX][nUsado]
				RecLock(cAlias2,.T.)
			Endif
		Endif
		
		If !aCols[nX][nUsado]
			For nI := 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[nI,2])),aCols[nX,nI])
			Next nI
			PA6->PA6_FILIAL := cFilPA6
			PA6->PA6_SEQ    := StrZero(nSeq,4)
			PA6->PA6_FORNEC := M->PA5_FORNEC
			PA6->PA6_LOJA   := M->PA5_LOJA
			PA6->PA6_PERIOD := M->PA5_PERIOD
			PA6->PA6_TIPDES := M->PA5_TIPDES
			nSeq ++
			lGravou := .T.
		EndIf
		MsUnLock()
	Next nX
	
	//+----------------------------------------------------
	//| Aqui eu reordeno a sequencia gravada fora de ordem.
	//+----------------------------------------------------
	If lGravou
		nSeq := 1
		dbSelectArea(cAlias2)
		dbSetOrder(1)
		dbSeek(cFilPA6+M->PA5_FORNEC+M->PA5_LOJA+M->PA5_PERIOD+M->PA5_TIPDES,.F.)
		While !Eof() .And. cFilPA6 == PA5->PA5_FILIAL .And. PA6->PA6_FORNEC == M->PA5_FORNEC .And. PA6->PA6_LOJA == M->PA5_LOJA .And. PA6->PA6_PERIOD == M->PA5_PERIOD .and. PA6->PA6_TIPDES == M->PA5_TIPDES
			RecLock(cAlias2,.F.)
			PA6->PA6_SEQ  := StrZero(nSeq,4)
			MsUnLock()
			nSeq++
			lGravou := .T.
			dbSkip()
		End
	EndIf
	
	//+------------------
	//| Grava o Cabecalho
	//+------------------
	If lGravou
		dbSelectArea(cAlias1)
		RecLock(cAlias1,.F.)
		For nX := 1 To FCount()
			If "FILIAL" $ FieldName(nX)
				FieldPut(nX,cFilPA5)
			Else
				FieldPut(nX,M->&(Eval(bCampo,nX)))
			Endif
		Next
		MsUnLock()
	Else
		dbSelectArea(cAlias1)
		RecLock(cAlias1,.F.)
		dbDelete()
		MsUnLock()
	Endif
Endif

//+----------------
//| Se for exclucao
//+----------------
If nOpc == 3
	//+----------------
	//| Deleta os Itens
	//+----------------
	dbSelectArea(cAlias2)
	dbSetOrder(1)
	dbSeek(cFilPA6+M->PA5_FORNEC+M->PA5_LOJA+M->PA5_PERIOD+M->PA5_TIPDES,.T.)
	While !Eof() .And. cFilPA6 == PA5->PA5_FILIAL .And. PA6->PA6_FORNEC == M->PA5_FORNEC .And. PA6->PA6_LOJA == M->PA5_LOJA .And. PA6->PA6_PERIOD == M->PA5_PERIOD.And. PA6->PA6_TIPDES == M->PA5_TIPDES
		RecLock(cAlias2)
		dbDelete()
		MsUnLock()
		dbSkip()
	End
	
	//+-------------------
	//| Deleta o Cabecalho
	//+-------------------
	dbSelectArea(cAlias1)
	RecLock(cAlias1)
	dbDelete()
	MsUnLock()
	lGravou := .T.
EndIf

If lGravou .And. lGeraSE2
    If nOpc == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Criacao do Array de Titulos a pagar³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AAdd(aTiPag,{"E2_PREFIXO" ,,NiL})//1
		AAdd(aTiPag,{"E2_NUM"     ,,NiL})//2
		AAdd(aTiPag,{"E2_PARCELA" ,,NiL})//3
		AAdd(aTiPag,{"E2_TIPO"    ,,NiL})//4
		AAdd(aTiPag,{"E2_FORNECE" ,,NiL})//5
		AAdd(aTiPag,{"E2_LOJA"    ,,NiL})//6
		AAdd(aTiPag,{"E2_EMISSAO" ,,NiL})//7
		AAdd(aTiPag,{"E2_VENCTO"  ,,NiL})//8
		AAdd(aTiPag,{"E2_VALOR"   ,,NiL})//9
		AAdd(aTiPag,{"E2_NATUREZ" ,,NiL})//10
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Alimentacao Array de Titulos GNRE ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aTiPag[01,2] := cPrefixo           //PREFIXO
		aTiPag[02,2] := M->PA5_DOC         //NUMERO
		aTiPag[03,2] := " "             //PARCELA
		aTiPag[04,2] := cTpTit            //TIPO TITULO CRIAR TIPO PARA GNRE
		aTiPag[05,2] := M->PA5_FORNEC        //FORNECEDOR
		aTiPag[06,2] := M->PA5_LOJA        //LOJA
		aTiPag[07,2] := dDataBase //EMISSSAO
		aTiPag[08,2] := M->PA5_VENCTO       //VENCIMENTO
		aTiPag[09,2] :=  M->PA5_VALOR        //VALOR
		aTiPag[10,2] := cNaTit        //NATUREZA

		MSExecAuto({|x,y| FINA050(x,y)},aTiPag,,3)

	ElseIf nOpc == 2                   

		IF SE2->(dbSeek(xFilial("SE2")+cPrefixo+M->PA5_DOC))
			If Empty(SE2->E2_BAIXA) .And. (SE2->E2_SALDO == SE2->E2_VALOR)
				RecLock("SE2",.F.)
				SE2->E2_VALOR   := M->PA5_VALOR
				SE2->E2_VLCRUZ  := M->PA5_VALOR
				SE2->E2_SALDO   := M->PA5_VALOR
				MsUnLock()
			Else
				ApMsgStop( "Titulo baixado. A alteração não foi finalizada.", 'ATENÇÃO' )
				lGravou := .F.
			EndIf
		Else
			ApMsgStop( "Titulo não encontrado. A alteração não foi finalizada.", 'ATENÇÃO' )
			lGravou := .F.
		Endif
	Else
		IF SE2->(dbSeek(xFilial("SE2")+cPrefixo+M->PA5_DOC))
			If Empty(SE2->E2_BAIXA) .And. (SE2->E2_SALDO == SE2->E2_VALOR)
				RecLock("SE2",.F.)
				SE2->(DbDelete())
				MsUnLock()
			Else
				ApMsgStop( "Titulo baixado. A exclusão não foi finalizada.", 'ATENÇÃO' )
				lGravou := .F.
			EndIf
		Else
			ApMsgStop( "Titulo não encontrado. A exclusão não foi finalizada.", 'ATENÇÃO' )
			lGravou := .F.
		Endif
	Endif	                                     
	
	If  lMsErroAuto
		MOSTRAERRO()
		lGravou := .F.
	EndIf	
	
Endif

Return( lGravou )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ QuaPesq  ³ Autor ³Darlan A. Freitas Maciel ³ Data ³ 22/08/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ POSICAO DO CAMPO                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QuaPesq(cCampo)
Local nPos := 0
nPos := aScan(aHeader,{|x|AllTrim(Upper(x[2]))==cCampo})
Return(nPos)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ Qa70Vld  ³ Autor ³Priscila Prado           ³ Data ³ 16/06/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se o periodo digitado ja foi cadastrado               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Qa70Vld()
Local lRet :=  .T.
//PA5_FILIAL+PA5_FORNEC+PA5_LOJA+PA5_PERIOD+PA5_TIPDES  
If DbSeek(xFilial("PA5")+M->PA5_FORNEC+M->PA5_LOJA+M->PA5_PERIOD+M->PA5_TIPDES)
	ApMsgStop( 'Período já cadastrado para esse fornecedor', 'ATENÇÃO' )
	lRet := .F.
Endif

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ Qa70Tot  ³ Autor ³Priscila Prado           ³ Data ³ 16/06/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o valor das despesas do fornecedor.                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Qa70Tot()
Local nAux := 0 
Local nValAux := 0

For nAux:=1 To Len(aCols)
	If !aCols[n][nUsado+1]
		nValAux += M->PA6_VALOR	
	Endif
Next
     
M->PA5_VALOR := nValAux

oGet:Refresh()

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ Qa70Alt  ³ Autor ³Priscila Prado           ³ Data ³ 17/06/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Permite inclusao ou alteracao das despesas.                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Qa70Alt()
Local aArea := GetArea()

dbSelectArea("LBP")
dbSetOrder(2)
If DbSeek(xFilial("LBP") + Dtos(CTod("01/" + SubStr(M->PA5_PERIOD,1,2) + "/" + SubStr(M->PA5_PERIOD,3,6))))
	If Subs(Dtos(CTod("01/" + SubStr(M->PA5_PERIOD,1,2) + "/" + SubStr(M->PA5_PERIOD,3,6))),1,6) ==  Subs(Dtos(LBP->LBP_DATINI), 1, 6)
		MsgStop("O Mes " + SubStr(M->PA5_PERIOD,1,2) + " ja foi fechado e nao pode ser alterado!","Atencao")
		RestArea(aArea)
		Return(.f.)
	Endif
Endif
RestArea(aArea)

Return(.T.)