#include 'PROTHEUS.CH'

User Function Quar017()
//+----------------------------------------------------------------+
//| Define Variaveis                                               |
//+----------------------------------------------------------------+
Local cDesc1     := "Este programa emitira a relacao  de etiquetas "
Local cDesc2     := "para os Fornecedores (Produtores)."
Local cDesc3     := ''
Local cString    := 'LBB'
Local Titulo   	 := "Etiquetas para Produtores"
Local Tamanho    := 'M' //G
Local wnRel      := 'QUAR017'
//+----------------------------------------------------------------+
//| Variaveis Tipo Private padrao de todos os relatorios           |
//+----------------------------------------------------------------+
Private aOrd       := {"Por Produtor"}
Private aReturn    := {"Zebrado",1,"Administracao",2, 2, 1, '',1 }
Private cPerg      := "QUAR017"
Private nLastKey   := 0
Private nTipo      := 0
//+----------------------------------------------------------------+
//| Verifica as perguntas selecionadas                             |
//+----------------------------------------------------------------+
AjustaSX1(cPerg)
Pergunte(cPerg, .F.)
//+----------------------------------------------------------------+
//| Envia controle para SETPRINT                                   |
//+----------------------------------------------------------------+
wnRel := SetPrint(cString,wnRel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho)
nTipo := 15 //If(aReturn[4]==1,GetMv('MV_COMP'),GetMv('MV_NORM'))
If nLastKey == 27
	dbClearFilter()
	Return Nil
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	dbClearFilter()
	Return Nil
Endif
RptStatus({|lEnd| QUAR017Imp(@lEnd,wnRel,Tamanho,Titulo)},Titulo)
Return Nil



/*/
+------------+----------+-------+-----------------------+------+----------+
| Funcao     |QUAR017Imp| Autor |Fernando R. Ribeiro    | Data | 14/11/95 |
|------------+----------+-------+-----------------------+------+----------+
| Descricao  |Chamada do Relatorio                                        |
+------------+------------------------------------------------------------+
| Uso        | Especificos Quata                                          |
+------------+------------------------------------------------------------+
/*/

Static Function QUAR017Imp(lEnd, wnRel, Tamanho, Titulo)
//+----------------------------------------------------------------+
//| Variaveis especificas dos relatorios                           |
//+----------------------------------------------------------------+
Local cIndex    := ''
Local cCond     := ''
Local cNomArq   := ''

Local cLinha	:= Space(9)
Local cCodPro	:= Space(6)
Local cNomFor	:= Space(40)
Local cMun		:= Space(15)
Local cQuery1	:= ""


//+----------------------------------------------------------------+
//| Variaveis utilizadas para Impressao do Cabecalho e Rodape      |
//+----------------------------------------------------------------+
Private aLinha  := {}
Private Cabec1  := ''
Private Cabec2  := ''
Private cBTxt   := Space(10)
Private cBCont  := 0
Private Li      := 01
Private M_PAG   := 01

//-- Condicao de Filtragem da IndRegua

cCond := 'LBB_FILIAL=="'+xFilial('LBB')+'".And.'
cCond += 'LBB_CODPRO>="'+mv_par01+'".And.LBB_CODPRO<="'+mv_par02+'".And.'
cCond += 'SubStr(LBB_LINHA,1,6)>="'+mv_par03+'".And.SubStr(LBB_LINHA,1,6)<="'+mv_par04+'"'

If aReturn[8]==1 //Verifica a Ordem para Impressao
	cIndex := 'LBB_FILIAL+LBB_CODPRO'                             
	Titulo := "ETIQUETA POR CODIGO DO PROPRIETARIO"
	Cabec1 := ""
	Cabec2 := ""
EndIf

TcSqlExec("DROP VIEW ETIQUETAS")

cQuery1 := "CREATE VIEW ETIQUETAS AS SELECT DISTINCT LBB_LINHA,LBB_CODPRO,SUBSTRING(LBB_NOMFOR,1,25) AS LBB_NOMFOR,LBB_MUN " 
cQuery1 += "FROM " + RetSqlName("LBB") + " LBB "
cQuery1 += "INNER JOIN " + RetSqlName("SD1") + " SD1 "
cQuery1 += "ON D1_FILIAL=LBB_FILIAL AND D1_FORNECE=LBB_CODFOR AND D1_LOJA=LBB_LOJA "
cQuery1 += "AND D1_EMISSAO BETWEEN '" + DTOS(MV_PAR05)+ "' AND '" + DTOS(MV_PAR06)+ "' AND D1_FORMUL='S' AND D1_FILIAL='" + cFilAnt +  "' AND SD1.D_E_L_E_T_='' "
cQuery1 += "WHERE LBB_FILIAL='" + cFilAnt + "' AND LBB.D_E_L_E_T_='' "

TcSqlExec(cQuery1)

cQuery1 := "SELECT LBB_LINHA,LBB_CODPRO,LBB_NOMFOR,LBB_MUN FROM ETIQUETAS WHERE (LBB_LINHA BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "')"   
cQuery1 += " AND (LBB_CODPRO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "')"
cQuery1 += " ORDER BY CAST(LBB_LINHA AS INT),CAST(LBB_CODPRO AS INT) "


MemoWrite("C:\EDI\ETIQUETAS.SQL",cQuery1)

cQuery1 := ChangeQuery( cQuery1 )

If Select("QRYCONV") > 0
	dbSelectArea("QRYCONV")
	QRYCONV->(dbCloseArea())
EndIf

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery1), 'QRYCONV', .F., .T.)

QRYCONV->( dbGoTop() )

//+----------------------------------------------------------------+
//| Pega o nome do arquivo de indice de trabalho                   |
//+----------------------------------------------------------------+
cNomArq := CriaTrab('', .F.)
//+----------------------------------------------------------------+
//| Cria Indice de Trabalho                                        |
//+----------------------------------------------------------------+
dbSelectArea('LBB')
IndRegua('LBB', cNomArq, cIndex,, cCond, "Selecionando Registros...")
#IFNDEF TOP
	dbSetIndex(cNomArq+OrdBagExt())
#ENDIF
dbGoTop()
SetRegua(LastRec())
//+----------------------------------------------------------------+
//| Processa o Laco de impressao                                   |
//+----------------------------------------------------------------+

@ 0,0 PSay AvalImp(80)

Do While QRYCONV->( !Eof() )
	//+----------------------------------------------------------------+
	//| Cancela a impressao                                            |
	//+----------------------------------------------------------------+
	If lEnd
		@ PRow()+1, 001 PSay "CANCELADO PELO OPERADOR"
		Exit
	EndIf

	//-- Atualiza a Regua de Impressao
	IncRegua()
		
	//+----------------------------------------------------------------+
	//| Cancela a Impressao                                            |
	//+----------------------------------------------------------------+
	If lEnd
		@ PRow()+1, 001 PSay "CANCELADO PELO OPERADOR" //"CANCELADO PELO OPERADOR"
		Exit
	EndIf
		
	//Linhas abaixo para exemplo
	//@ Li, 068 PSay nSaldo   Picture cPicSld
	//@ Li, 105 Psay dValiAnt
	
	cLinha	:= QRYCONV->LBB_LINHA
	cCodPro	:= QRYCONV->LBB_CODPRO
	cNomFor	:= AllTrim(QRYCONV->LBB_NOMFOR)
	cMun	:= QRYCONV->LBB_MUN
	
	QRYCONV->( dbSkip() )

	@ 01, 001 PSay CHR(15) + " "

	If QRYCONV->( Eof() )
		@ 02, 001 Psay "Linha: " + SubStr(cLinha,1,6)
		@ 02, 015 Psay "Ref.: "  + SubStr(DTOS(MV_PAR05),5,2)+"/"+SubStr(DTOS(MV_PAR05),1,4)
		@ 03, 001 Psay "Cod. : " + cCodPro
		@ 04, 001 Psay AllTrim(cNomFor)
		@ 05, 001 Psay AllTrim(cMun)
      	Exit
	EndIf

	
	@ 02, 001 Psay "Linha: " + SubStr(cLinha,1,6)
	@ 02, 015 Psay "Ref.: "  + SubStr(DTOS(MV_PAR05),5,2)+"/"+SubStr(DTOS(MV_PAR05),1,4)             
	@ 02, 031 Psay "Linha: " + SubStr(QRYCONV->LBB_LINHA,1,6)	
	@ 02, 046 Psay "Ref.: "  + SubStr(DTOS(MV_PAR05),5,2)+"/"+SubStr(DTOS(MV_PAR05),1,4)

	@ 03, 001 Psay "Cod. : " + cCodPro
	@ 03, 031 Psay "Cod. : " + QRYCONV->LBB_CODPRO

	@ 04, 001 Psay AllTrim(cNomFor)
	@ 04, 031 Psay AllTrim(QRYCONV->LBB_NOMFOR)

	@ 05, 001 Psay AllTrim(cMun)
	@ 05, 031 Psay AllTrim(QRYCONV->LBB_MUN)

	@ 06, 001 Psay " "	

	SetPrc(0,0)
	
	QRYCONV->( dbSkip() )
    
EndDo

//-- Restaura a Integridade do LBB
dbSelectArea('LBB')
RetIndex('LBB')
dbClearFilter()
If File(cNomArq+OrdBagExt())
	fErase(cNomArq+OrdBagExt())
Endif
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

Static Function AjustaSX1(cPerg)

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

//aHelpPor:={}
//Aadd(aHelpPor,"Informe o Periodo: Mes/Ano.")		
//Aadd(aHelpPor,"Ex.: 12/2007")
//PutSX1(cPerg, "05", "Mes/Ano       ?", "", "", "mv_ch05", "C", 7, 00, 0, "G", "u_vld017()", "","","S","MV_PAR05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

PutSx1(cPerg, "05", "Emissao   De  ?", "", "", "MV_CH5", "D",10,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "06", "Emissao   Até ?", "", "", "MV_CH6", "D",10,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")		

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Vld017   ³ Autor ³Fernando R. Ribeiro    ³ Data ³08/01/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida a digitacao do periodo MM/AAAA                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Vld017()
Local lRet := .T.
Local cPer := MV_PAR05
If ((SubStr(cPer, 1, 2) > '12' .OR. SubStr(cPer, 1, 2) < '01') .OR. ;
   (SubStr(cPer, 4, 4) < '1900' .OR. SubStr(cPer, 4, 4) > '4000'))
		MsgStop("Período inválido, por favor informe novamente no formato MM/AAAA")
		lRet := .F.
Endif
Return lRet


