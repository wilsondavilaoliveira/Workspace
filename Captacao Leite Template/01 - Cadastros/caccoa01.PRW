#include "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CACCOA01  º Autor ³ Choite             º Data ³  14/02/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³CADASTRO DE PROPRIEDADES                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³COOPERATIVA DE GRAOS E LEITE                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CACCOA01
//CHKTEMPLATE("COL")
// TESTE

Private cAlias := "LBB"

dbSelectArea(cAlias)
dbSetOrder(1)

AxCadastro(cAlias,"Cadastro de Propriedades", "U_DelCac01()", "U_IncCac01()")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DelCac01  º Autor ³ Choite             º Data ³  14/02/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Validacao da Exclusao do Cadastro de Propriedades           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Cooperativa de Graos e Leite                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DelCac01()

Local lRet := .t. , ni := 0 , cRet
Local aArea,cArqPes,cFilDel,cFilPes,nPosFil,lFil,lIndtemp
Private cIndice , cChave
aChave := {}

Aadd(aChave, {"LBD","LBD_CODPRO",LBB->LBB_CODPRO,NIL} )
Aadd(aChave, {"LBF","LBF_CODPRO",LBB->LBB_CODPRO,NIL} )
Aadd(aChave, {"LBG","LBG_CODPRO",LBB->LBB_CODPRO,NIL} )
Aadd(aChave, {"LBM","LBM_CODPRO",LBB->LBB_CODPRO,NIL} )
Aadd(aChave, {"LBO","LBO_CODPRO",LBB->LBB_CODPRO,NIL} )
Aadd(aChave, {"LBP","LBP_CODPRO",LBB->LBB_CODPRO,NIL} )
Aadd(aChave, {"LBQ","LBQ_CODPRO",LBB->LBB_CODPRO,NIL} )

dbSelectArea("LBB")
cSele   := Alias()
cArqDel := cSele
cFilDel := xFilial(cArqDel)

aArea := sGetArea(aArea,cSele)
aArea := sGetArea(aArea,"SX2")

&& Procura se existe registro
For ni := 1 to Len(aChave)
	If !(aChave[ni,1]$cFOPENed)
		ChkFile(aChave[ni,1],.F.)
	EndIf
	cArqPes  := aChave[ni,1]
	cFilPes  := xFilial(cArqPes)
	lFil     := .T.
	lIndTemp := .F.
	
	dbSelectArea(aChave[ni,1])
	&& Salva configuracao dos arquivos relacionados
	aArea := sGetArea(aArea,aChave[nI,1])
	
	&& Se nao existir indice acessivel cria indregua
	If ValType(aChave[ni,2]) == "N" .And. aChave[ni,4] == NIL .And. cFilDel == cFilPes
		dbSetOrder(aChave[ni,2])
	Else
		cIndice := CriaTrab(Nil, .F.)
		If ValType(aChave[ni,2]) == "N"
			dbSetOrder(aChave[ni,2])
			cChave  := IndexKey()
		Else
			cChave  := Alltrim(aChave[ni,1])+"_FILIAL+"+Alltrim(aChave[ni,2])
			If SubStr(cChave,1,1) == "S"    // quando e' um alias que comeca com "S" tipo (SA1,SB1,SB2,etc) as iniciais do campo sao apenas 2 caracteres (ALTERADO POR EDUARDO MOTTA - MICROSIGA)
				cChave := SubStr(cChave,2)
			EndIf
		EndIf
		If Empty(cFilDel) .and. !Empty(cFilPes)    // se o Alias do registro que sera deletado for compartilhado e o outro nao ignora a filial
			nPosFil := At("_FILIAL+",cChave)+8
			cChave  := substr(cChave,nPosFil)
			lFil    := .F.
		EndIf
		IndRegua(aChave[ni,1],cIndice,cChave,,aChave[ni,4],OemToAnsi(aChave[ni,1]) )
		lIndTemp := .T.
	EndIf
	
	lRet := !dbSeek( If(lFil,xFilial(aChave[ni,1]),"") + aChave[ni,3] )
	
	&& Apaga indice criado pela indregua
	If lIndTemp
		RetIndex()
		#IFNDEF TOP
			If File(cIndice+OrdBagExt())
				fErase(cIndice+OrdBagExt())
			Endif
		#ENDIF
	EndIf
	
	If !lRet
		cRet := aChave[nI,1]
		Exit
	EndIf
Next

&& Volta posicoes originais
sRestArea(aArea)

If !lRet
	lRet := .F.
	SX2->(dbSeek(cRet))
	Help("  ",1,"CANCELDEL",,cRet+"- "+OemToAnsi(X2Nome() ),4,1)
EndIf

dbSelectArea(cSele)

Return(lRet)

User Function _LINHAPRO(Opc)

Local cRet   := ""
Local cAlias := Alias()
Local nRec   := SM0->(recno())

default Opc := .f.

dbSelectArea("SM0")
dbGotop() //Todas as Filiais
while !EOF()
	dbSelectArea("LBD")
	dbSetOrder(3)
	if dbSeek(SM0->M0_CODFIL+M->LBB_CODPRO)
		cRet := LBD->LBD_CODROTA+"-"+SM0->M0_CODFIL
		dbSelectArea("LBB")
		RecLock("LBB",.f.)
		LBB->LBB_LINHA := cRet
		MsUnlock()
		Exit
	Endif
	dbSelectArea("SM0")
	dbSkip()
Enddo
dbSelectArea("SM0")
dbGoto(nRec)
dbSelectArea(cAlias)

if Opc
	cRet := .t.
Endif

Return (cRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IncCac01  º Autor ³ Rogerio Faro       º Data ³  30/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Validacao da Inclusao no Cadastro de Propriedades           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Cooperativa de Graos e Leite                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function IncCac01()
Local lRet 	:= .T.
Local aArea := GetArea()
if Inclui
	Dbsetorder(2)
	If Dbseek(xfilial("LBB") + M->LBB_CODFOR + M->LBB_LOJA)
		MsgStop("Fornecedor/loja já cadastrado!!!", "Atenção")
		lRet := .F.
	EndIf
Endif
RestArea(aArea)
Return (lRet)
