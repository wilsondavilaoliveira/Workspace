#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAR018   ºAutor  ³Fernando R. Ribeiro º Data ³  08/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Vales e Relatorio de Vales                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Quata                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QUAR018()

//+----------------------------------------------------------------+
//| Define Variaveis                                               |
//+----------------------------------------------------------------+
Local cDesc1     := "Este programa emitira o "
Local cDesc2     := "Relatorio de Vales "
Local cDesc3     := ''
Local cString    := 'LBB'
Local Titulo   	 := "Retatorio de Vales"
Local Tamanho    := 'M'
Local wnRel      := 'QUAR018'
//+----------------------------------------------------------------+
//| Variaveis Tipo Private padrao de todos os relatorios           |
//+----------------------------------------------------------------+
Private aOrd       := {"Por Produtor"}
Private aReturn    := {"Zebrado",1,"Administracao",2, 2, 1, '',1 }
Private cPerg      := "QUA018"
Private nLastKey   := 0
Private nTipo      := 0
//+----------------------------------------------------------------+
//| Verifica as perguntas selecionadas                             |
//+----------------------------------------------------------------+
AjustaSX1()
Pergunte("QUA018", .F.)
//+----------------------------------------------------------------+
//| Envia controle para SETPRINT                                   |
//+----------------------------------------------------------------+
wnRel := SetPrint(cString,wnRel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)
nTipo := 15
If nLastKey == 27
	Return Nil
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Return Nil
Endif

RptStatus({|lEnd| QUAR018Imp(@lEnd,wnRel,Tamanho,Titulo)},Titulo)

Return()



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

Local cPerg	   := "QUA018"

aHelpEng := {""}
aHelpSpa := {""}

aHelpPor:={}
Aadd(aHelpPor,"Informe a Linha.")
PutSx1(cPerg, "01", "Linha De        ?", "", "", "mv_ch01", "C", 6, 00, 0, "G", "", "PA7", "","S","MV_PAR01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1(cPerg, "02", "Linha Ate       ?", "", "", "mv_ch02", "C", 6, 00, 0, "G", "", "PA7", "","S","MV_PAR02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor:={}
Aadd(aHelpPor,"Informe o Produtor.")
PutSx1(cPerg, "03", "Produtor De     ?", "", "", "mv_ch03", "C", 6, 00, 0, "G", "", "LBB", "","S","MV_PAR03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1(cPerg, "04", "Produtor Ate    ?", "", "", "mv_ch04", "C", 6, 00, 0, "G", "", "LBB", "","S","MV_PAR04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor:={}
Aadd(aHelpPor,"Informe o Carreteiro.")
PutSx1(cPerg, "05", "Carreteiro De   ?", "", "", "mv_ch05", "C", 6, 00, 0, "G", "", "LBE", "","S","MV_PAR05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1(cPerg, "06", "Carreteiro Ate  ?", "", "", "mv_ch06", "C", 6, 00, 0, "G", "", "LBE", "","S","MV_PAR06","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor:={}
Aadd(aHelpPor,"Informe o Periodo")		
PutSX1(cPerg, "07", "Periodo Emissao ?", "", "", "mv_ch07", "C", 7, 00, 0, "G", "u_Vld018()", "","","S","MV_PAR07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Vld018   ³ Autor ³Fernando R. Ribeiro    ³ Data ³08/01/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida a digitacao do periodo MM/AAAA                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Vld018()
Local lRet := .T.
Local cPer := MV_PAR07
If ((SubStr(cPer, 1, 2) > '12' .OR. SubStr(cPer, 1, 2) < '01') .OR. ;
   (SubStr(cPer, 4, 4) < '1900' .OR. SubStr(cPer, 4, 4) > '4000'))
		MsgStop("Período inválido, por favor informe novamente no formato MM/AAAA")
		lRet := .F.
Endif
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAR018ImpºAutor  ³Fernando R. Ribeiro º Data ³  08/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processamento do Relatorio                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Quata                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function QUAR018Imp(lEnd, wnRel, Tamanho, Titulo)
//+----------------------------------------------------------------+
//| Variaveis especificas dos relatorios                           |
//+----------------------------------------------------------------+
Local cIndex     := ''
Local cCond      := ''
Local cNomArq    := ''
Local cRotaAnt   := ''
Local cCodCar	 := ''	

//+----------------------------------------------------------------+
//| Variaveis utilizadas para Impressao do Cabecalho e Rodape      |
//+----------------------------------------------------------------+
Private aLinha    := {}
Private Cabec1    := Alltrim(DtoC(dDataBase))
Private Cabec2    := 'Relatorio de Vales'
Private cBTxt     := Space(10)
Private cBCont    := 0
Private Li        := 11
Private M_PAG     := 1

cQuery := "SELECT "
cQuery += "PA7.PA7_CODLIN, PA7_DESC, PA7_CODCAR, LBB.LBB_CODPRO, LBB.LBB_NOMFOR, LBB_CODFOR, SE2.E2_FORNECE, SE2.E2_NUMBCO, SE2.E2_VALOR, SE2.E2_VENCREA, LBB_NOMFOR "
cQuery += "FROM " 
cQuery += RetSQLName("PA7")+" PA7, "
cQuery += RetSQLName("LBB")+" LBB, "
cQuery += RetSQLName("SE2")+" SE2 "
cQuery += "WHERE "
cQuery += "PA7_CODLIN >= '"+MV_PAR01+"' AND "
cQuery += "PA7_CODLIN <= '"+MV_PAR02+"' AND "
cQuery += "LBB.LBB_CODPRO >= '"+MV_PAR03+"' AND "
cQuery += "LBB.LBB_CODPRO <= '"+MV_PAR04+"' AND "
cQuery += "PA7_CODLIN = LBB_LINHA AND "
cQuery += "LBB.LBB_CODFOR = SE2.E2_FORNECE AND "
cQuery += "SE2.E2_TIPO IN ('NP','PA') AND "
cQuery += "PA7_FILIAL = '" + xFilial("PA7") + "' AND "
cQuery += "LBB_FILIAL = '" + xFilial("LBB") + "' AND "
cQuery += "E2_FILIAL = '" + xFilial("SE2") + "' AND "
cQuery += "SE2.E2_EMISSAO >= '"+SubStr(MV_PAR07, 4, 4)+SubStr(MV_PAR07, 1, 2)+"01' AND "
cQuery += "SE2.E2_EMISSAO <= '"+SubStr(MV_PAR07, 4, 4)+SubStr(MV_PAR07, 1, 2)+SubStr(dtos(LastDay(stod(SubStr(MV_PAR07, 4, 4)+SubStr(MV_PAR07, 1, 2)+"01"))),7,2)+"' AND "
cQuery += "PA7.D_E_L_E_T_ = ' ' AND "
cQuery += "LBB.D_E_L_E_T_ = ' ' AND "
cQuery += "SE2.D_E_L_E_T_ = ' ' " 
cQuery += "ORDER BY CAST(LBB_LINHA AS INT), CAST(LBB_CODPRO AS INT) "

cQuery := ChangeQuery(cQuery)

MsAguarde({|| dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB", .F., .T.)},"Selecionando registros...")

SetRegua(TRB->(LastRec()))
//+----------------------------------------------------------------+
//| Processa o Laco de impressao                                   |
//+----------------------------------------------------------------+
TRB->(dbGoTop())
cRotaAnt := TRB->PA7_CODLIN

Cabec(Titulo,Cabec1,Cabec2,wnRel,Tamanho,nTipo)
Li := 11

Do While !TRB->(Eof())
	//+----------------------------------------------------------------+
	//| Cancela a impressao                                            |
	//+----------------------------------------------------------------+
	If lEnd
		@ PRow()+1, 001 PSay "CANCELADO PELO OPERADOR"
		Exit
	EndIf
     
    If (TRB->PA7_CODLIN <> cRotaAnt)
    
		@ 050, 061 PSay "Carreteiro:   "+Replicate("_",35)
		@ 051, 075 PSay Posicione("LBE", 2, xFilial("LBE")+cCodCar, "LBE_MOTO") 
    
   		Roda(cBCont, cBTxt, Tamanho)
        cRotaAnt := TRB->PA7_CODLIN
        Cabec(Titulo,Cabec1,Cabec2,wnRel,Tamanho,nTipo)
        Li := 11        
    Endif
    
		//-- Atualiza a Regua de Impressao
		IncRegua()
			
		If Li == 11
			@ 011, 003 PSay "ADIANTAMENTOS - "+Upper(TRB->PA7_DESC)
			@ 012, 003 PSay Replicate("_",98)
			@ 014, 003 PSay "Cod.    Nome Produtor                    Num Cheque        Valor                  Vencimento"
			@ 015, 003 PSay "------  -----------------------------    ---------------   --------------------   ----------"
			Li := 16
		EndIf
	
		@ Li, 003 PSay TRB->LBB_CODPRO //6
		@ Li, 012 PSay TRB->LBB_NOMFOR //30
	
		@ Li, 045 PSay TRB->E2_NUMBCO //15
		@ Li, 063 PSay Alltrim(Transform(TRB->E2_VALOR, "@E 999,999.99")) //20
		@ Li, 086 PSay SToD(TRB->E2_VENCREA) // 10
		
		Li ++
		
		If (Li==80)	
			Roda(cBCont, cBTxt, Tamanho)
		EndIf
	    
	    cCodCar := TRB->PA7_CODCAR
		
		TRB->(dbSkip())    
EndDo
 
		@ 050, 061 PSay "Carreteiro:   "+Replicate("_",35)
		@ 051, 075 PSay Posicione("LBE", 2, xFilial("LBE")+cCodCar, "LBE_MOTO") 
    
   		Roda(cBCont, cBTxt, Tamanho)

//-- Restaura a Integridade do LBB
dbSelectArea('LBB')
RetIndex('LBB')

If Select("TRB") <> 0
	TRB->(dbCloseArea())
Endif

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnRel)
Endif

MS_Flush()

Return Nil

