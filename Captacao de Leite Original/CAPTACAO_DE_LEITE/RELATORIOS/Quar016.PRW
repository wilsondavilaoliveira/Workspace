#include 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAR016   ºAutor  ³Fernando R. Ribeiro º Data ³  08/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Mapa do Recebimento Diario de Leite                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Quata                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Quar016()
//+----------------------------------------------------------------+
//| Define Variaveis                                               |
//+----------------------------------------------------------------+
Local cDesc1     := "Este programa emitira a impressao do "
Local cDesc2     := "Mapa de Recebimento Diario de Leite."
Local cDesc3     := ''
Local cString    := 'LBO'
Local Titulo   	 := "Mapa de Recebimento Diario de Leite"
Local Tamanho    := 'P'
Local wnRel      := 'QUAR016'
//+----------------------------------------------------------------+
//| Variaveis Tipo Private padrao de todos os relatorios           |
//+----------------------------------------------------------------+
Private aOrd       := {"Dias do Mes"}
Private aReturn    := {"Zebrado",1,"Administracao",2, 2, 1, '',1 }
Private cPerg      := "QUA016"
Private nLastKey   := 0
Private nTipo      := 0
//+----------------------------------------------------------------+
//| Verifica as perguntas selecionadas                             |
//+----------------------------------------------------------------+
AjustaSX1()
Pergunte("QUA016", .F.)
//+----------------------------------------------------------------+
//| Envia controle para SETPRINT                                   |
//+----------------------------------------------------------------+
wnRel := SetPrint("",wnRel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho)
nTipo := 15 

If nLastKey == 27
	Return Nil
Endif

SetDefault(aReturn,"")

If nLastKey == 27
	Return Nil
Endif

RptStatus({|lEnd| QUAR016Imp(@lEnd,wnRel,Tamanho,Titulo)},Titulo)

Return Nil



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³QUAR016Imp³ Autor ³ Fernando Ribeiro      ³ Data ³08/01/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especificos Quata                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function QUAR016Imp(lEnd, wnRel, Tamanho, Titulo)
//+----------------------------------------------------------------+
//| Variaveis especificas dos relatorios                           |
//+----------------------------------------------------------------+
Local cIndex     := ''
Local cCond      := ''
Local cNomArq    := ''
Local cQuery     := ''
Local cDtIni     := ''
Local cDtFim     := ''
Local nTotal     := 0
Local nRec		 := 0

//+----------------------------------------------------------------+
//| Variaveis utilizadas para Impressao do Cabecalho e Rodape      |
//+----------------------------------------------------------------+
Private aLinha    := {}
Private Cabec1    := ''
Private Cabec2    := ''
Private cBTxt     := Space(10)
Private cBCont    := 0
Private Li        := 3
Private M_PAG     := 1
Private stotal		:= 0


cUltDia := SubStr(dtos(LastDay(stod(SubStr(MV_PAR05, 4, 4)+SubStr(MV_PAR05, 1, 2)+"01"))),7,2)
cDtIni  := SubStr(MV_PAR05, 4, 4) + SubStr(MV_PAR05, 1, 2) + "01"
cDtFim  := SubStr(MV_PAR05, 4, 4) + SubStr(MV_PAR05, 1, 2) + cUltDia

Cabec2 := "Mapa Diario Recebimento de Leite. "+Replicate(" ",20)+"Referente: 01 a "+cUltDia+"/"+MV_PAR05

cQuery := "SELECT SubString(LBO.LBO_DATENT,7,2) AS DIA, LBO.LBO_CODPRO, SUM(LBO.LBO_QUANT) AS VOL_TRANSP "  
cQuery += "FROM "
cQuery += RetSQLName("LBO")+" LBO "
cQuery += "WHERE "
cQuery += "LBO.LBO_FILIAL = '"+xFilial("LBO")+"' AND "
cQuery += "LBO.LBO_CODPRO >= '"+MV_PAR01+"' AND LBO.LBO_CODPRO <= '"+MV_PAR02+"' AND "
cQuery += "LBO.LBO_DATENT >= '"+cDtIni+"' AND LBO.LBO_DATENT <= '"+cDtFim+"' AND "
cQuery += "LBO.LBO_TPENTR = '1' AND "
cQuery += "LBO.D_E_L_E_T_ = '' "
cQuery += "GROUP BY LBO.LBO_DATENT, LBO.LBO_CODPRO "
cQuery += "ORDER BY CAST(LBO.LBO_CODPRO AS INT), DIA "     

cQuery := ChangeQuery(cQuery)

MsAguarde({|| dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB", .F., .T.)},"Selecionando registros...")


//+----------------------------------------------------------------+
//| Processa o Laco de impressao                                   |
//+----------------------------------------------------------------+
TRB->(dbGoTop())

While !TRB->(Eof())
nRec ++
TRB->( DbSkip() )
End While

SetRegua(nRec)

@ 0,0 PSay AvalImp(80)

nRec := 1

TRB->(dbGoTop())

Do While !TRB->(Eof())

	//-- Atualiza a Regua de Impressao
	IncRegua(nRec)
	nRec ++
	
	Cabec1 := ""
	Cabec1 += Posicione("LBB", 1, xFilial("LBB")+TRB->LBO_CODPRO, "LBB_CODPRO") + " - " 
	Cabec1 += AllTrim(Posicione("LBB", 1, xFilial("LBB")+TRB->LBO_CODPRO, "LBB_DESC")) + Space(3) + "/" + space(3)
	Cabec1 += AllTrim(Posicione("LBB", 1, xFilial("LBB")+TRB->LBO_CODPRO, "LBB_NOMFOR"))
	 

	If !TRB->(EOF())
		Cabec(Titulo,Cabec1,Cabec2,wnRel,Tamanho,nTipo)
    Endif

	@ 009, 003 PSay "Dia      Litros Recebidos por Dia     Total"
	@ 010, 003 PSay "------   ------------------------     ----------------"

    cProdutor := AllTrim(TRB->LBO_CODPRO)
	Li := 11
	nTotal := 0
	
	Do While Alltrim(TRB->LBO_CODPRO) == cProdutor .AND. !TRB->(EOF())
	   
		nTotal := nTotal + TRB->VOL_TRANSP
		@ Li, 003 PSay TRB->DIA
		@ Li, 013 PSay TRB->VOL_TRANSP 	Picture "@E 9,999,999"
		@ Li, 042 PSay nTotal			Picture "@E 9,999,999"
		
		Li ++
		
		TRB->(dbSkip())    
    EndDo
    
    @ 44, 003 PSay "Total:"
    @ 44, 013 PSay nTotal Picture "@E 9,999,999"

	sTotal += nTotal
    //@ 48, 003 PSay "Total Mes:"
    //@ 48, 013 PSay sTotal Picture "@E 9,999,999"
	    
EndDo


TRB->(dbCloseArea())

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnRel)
Endif

MS_Flush()

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ AjustaSX1³ Autor ³ Fernando Ribeiro      ³ Data ³08/01/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta as perguntas do SX1                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Quata                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AjustaSX1()

Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

aHelpEng := {""}
aHelpSpa := {""}

aHelpPor:={}
Aadd(aHelpPor,"Informe o Produtor.")
PutSx1(cPerg, "01", "Do Produtor    ?", "", "", "mv_ch01", "C", 6, 00, 0, "G", "", "LBB", "","S","MV_PAR01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1(cPerg, "02", "Ate Produtor   ?", "", "", "mv_ch02", "C", 6, 00, 0, "G", "", "LBB", "","S","MV_PAR02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor:={}
Aadd(aHelpPor,"Informe a Linha.")
PutSx1(cPerg, "03", "Da Linha       ?", "", "", "mv_ch03", "C", 6, 00, 0, "G", "", "LBC", "","S","MV_PAR03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1(cPerg, "04", "Ate Linha      ?", "", "", "mv_ch04", "C", 6, 00, 0, "G", "", "LBC", "","S","MV_PAR04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor:={}
Aadd(aHelpPor,"Informe o Periodo: Mes/Ano.")		
Aadd(aHelpPor,"Ex.: 12/2007")
PutSX1(cPerg, "05", "Mes/Ano       ?", "", "", "mv_ch05", "C", 7, 00, 0, "G", "u_vld016()", "","","S","MV_PAR05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Vld016   ³ Autor ³Fernando R. Ribeiro    ³ Data ³08/01/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida a digitacao do periodo MM/AAAA                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Vld016()
Local lRet := .T.
Local cPer := MV_PAR05
If ((SubStr(cPer, 1, 2) > '12' .OR. SubStr(cPer, 1, 2) < '01') .OR. ;
   (SubStr(cPer, 4, 4) < '1900' .OR. SubStr(cPer, 4, 4) > '4000'))
		MsgStop("Período inválido, por favor informe novamente no formato MM/AAAA")
		lRet := .F.
Endif
Return lRet