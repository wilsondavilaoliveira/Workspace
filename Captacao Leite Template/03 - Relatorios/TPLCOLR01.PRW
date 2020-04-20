#INCLUDE "rwmake.ch"
#include "TopConn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ TPLCOLR01³ Autor ³ PRICILA PREMICI       ³ Data ³ 19/10/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ RELATORIO DE PRE-FECHAMENTO                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Template COL_LEI - Cooperativa de Leite                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³RicardoBerti³11/01/06³087948³Calculo Pagto.da Qualidade 				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ PLANO DE MELHORIA CONTINUA        ³Programa   TPLCOLR01.PRW³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ITEM PMC  ³ Responsavel              ³ Data                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³      01  ³                          ³                                 ³±±
±±³      02  ³                          ³                                 ³±±
±±³      03  ³                          ³                                 ³±±
±±³      04  ³ Ricardo Berti            ³ 11/01/06                        ³±±
±±³      05  ³                          ³                                 ³±±
±±³      06  ³                          ³                                 ³±±
±±³      07  ³                          ³                                 ³±±
±±³      08  ³                          ³                                 ³±±
±±³      09  ³                          ³                                 ³±±
±±³      10  ³ Ricardo Berti            ³ 11/01/06                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TPLCOLR01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de Pre Fechamento"
Local cPict          := ""
Local titulo	     := ""
Local nLin         	 := 80
Local Cabec1         := "Codigo Nome                                      Extra   Valor            Leite     Valor        Valor      Leite Valor Percen    Valor  Valor            Valor      Valor      Valor      Liquido Redutase    Preco"
Local Cabec2	     := "       Produtor                                   Cota   Extra Cota        Cota  Unitario        Total      Acido Acido Gordur  Qualid.  Total Bruto   Funrural    Capital      Frete      a Pagar           Liquido"
					//   999999 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 999,999,999 9,999,999.99 999,999,999 99.999999 9,999,999.99 99,999,999     9  99.99 9,999.99 9,999,999.99 999,999.99 999,999.99 999,999.99 9,999,999.99 9,999.99 99,9999
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "TPLCOLR01" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "COLR01"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "TPLCOLR01" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := "LBO"

dbSelectArea("LBO")
dbSetOrder(1)

ValidPerg()
Pergunte(cPerg,.F.)               // Pergunta no SX1

_cMes   := MesExtenso(Month(dDatIni))
_cAno   := Alltrim(STR(YEAR(dDatIni)))
titulo	:= "Relatorio de Pre Fechamento - " +_cMes+ " / " + _cAno
wnrel 	:= SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If ! nLastKey == 27
	
	SetDefault(aReturn,cString)

	If ! nLastKey == 27

		nTipo := If(aReturn[4]==1,15,18)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

	EndIf
EndIf
Return(Nil)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RUNREPORT ³ Autor ³ AP6 IDE              ³ Data ³ 19/10/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ³±±
±±³          ³ monta a janela com a regua de processamento.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RUNREPORT(ExpC1,ExpC2,ExpC3,ExpN1)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = 1a.linha cabecalho                                 ³±±
±±³          ³ ExpC2 = 2a.linha cabecalho                                 ³±±
±±³          ³ ExpC2 = titulo relatorio                                   ³±±
±±³          ³ ExpN1 = no.linha                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Template COL_LEI								              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local i, x_
Local nOrdem
Local cSql
Local cLinha := ""
Local lRoundFUN  := SuperGetMv("MV_RNDFUN",.F.,.F.) == .T.
// Private nTeorMin  := GetMv("MV_TEORMIN")

// Inicializacao das variaveis...
//-------------------------------------------------------------------------------------------------
_nQTEXT  := _nQTCOT  := _nQTACI  := 0
_nVLEXT  := _nVLTOT  := _nVLGOR  := _nVLBRU  := _nVLFUN  := _nVLLIQ  := 0
_nQTEXTT := _nQTCOTT := 0
_nVLEXTT := _nVLTOTT := _nVLBRUT := _nVLFUNT := _nVLTXCT := _nVLFRET := _nVLLIQT := 0
_nQTEXTL := _nQTCOTL := _nQTACIL := 0
_nVLEXTL := _nVLTOTL := _nVLBRUL := _NVLGORL := _nVLFUNL := _nVLTXCL := _nVLFREL := _nVLLIQL := 0
//--------------------------------------------------------------------------------------------------

dbSelectArea(cString)
dbSetOrder(1)

SetRegua(RecCount())

ASort(aVetProp,,,{|x,y| x[30] + x[38]  < y[30] + y[38] })

For i:= 1 to Len(aVetProp)
	
	If !Empty(cLinha) .and. cLinha <> aVetProp[i,30]
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin,000 PSAY "Total Linha " + cLinha + " - " +LEFT(Posicione("LBC", 1, xFilial("LBC")+cLinha,"LBC_DESC"),20)
		@nLin,043 PSAY _nQTEXTL           												PICTURE "@E 999,999,999"  // Extra Cota
		@nLin,055 PSAY _nVLEXTL            												PICTURE "@E 9,999,999.99" // Valor Extra Cota
		@nLin,068 PSAY _nQTCOTL            												PICTURE "@E 999,999,999"  // Leite Cota
		@nLin,090 PSAY _nVLTOTL            												PICTURE "@E 9,999,999.99" // Valor Total
		@nLin,103 PSAY _nQTACIL            												PICTURE "@E 99,999,999"   // Leite Acido
		@nLin,118 PSAY 0                  																		  // Valor Acido
		@nLin,127 PSAY _nVLGORL            											    PICTURE "@E 9999.999"     // Valor Qualidade
		@nLin,136 PSAY _nVLBRUL			 												PICTURE "@E 9,999,999.99" // Valor Total Bruto
		@nLin,149 PSAY _nVLFUNL            												PICTURE "@E 999,999.99"     // Valor Funrural
		@nLin,160 PSAY _nVLTXCL		     												PICTURE "@E 999,999.99"     // Valor Taxa Capital
		@nLin,171 PSAY _nVLFREL     													PICTURE "@E 999,999.99"     // Valor Frete
		@nLin,182 PSAY _nVLLIQL															PICTURE "@E 9,999,999.99" // Liquido a Pagar
		nLin := nLin + 1
		// Finalização das variaveis ...
		//-------------------------------------------------------------------------------------------------
		_nQTEXTL := _nQTCOTL := _nQTACIL := 0
		_nVLEXTL := _nVLTOTL := _nVLBRUL := _NVLGORL := _nVLFUNL := _nVLTXCL := _nVLFREL := _nVLLIQL := 0
		//--------------------------------------------------------------------------------------------------
		
	Endif
	
	If aVetProp[i,30] < MV_PAR01 .OR. aVetProp[i,30] > MV_PAR02
		Loop
	Endif
	
	If aVetProp[i,01] < MV_PAR03 .OR. aVetProp[i,01] > MV_PAR04
		Loop
	Endif
	
	//  Leite Acido
	cSql := "SELECT SUM(LBO.LBO_QTDACI) AS LEI_ACIDO FROM "
	cSql += RetSQLName("LBO") + " LBO, "
	cSql += RetSQLName("LBD") + " LBD "
	cSql += "WHERE "
	cSql += "LBO.LBO_FILIAL = '" + xFilial("LBO") + "' AND "
	cSql += "LBD.LBD_FILIAL = '" + xFilial("LBD") + "' AND "
	cSql += "LBD.LBD_CODPRO = '" + aVetProp[i,1] + "' AND "
	cSql += "LBO.LBO_DATENT >= '" + Dtos(M->LBP_DATINI) + "' AND LBO.LBO_DATENT <= '" + Dtos(M->LBP_DATFIN) + "' AND "
	cSql += "LBO.D_E_L_E_T_ = ' ' AND "
	cSql += "LBD.D_E_L_E_T_ = ' '"
	TCQUERY cSql NEW ALIAS "DAT"
	dbSelectArea("DAT")
	DbGoTop()
	IF !Eof()
		_nQTACI := Int(DAT->LEI_ACIDO)
	Else
		_nQTACI := 0
	Endif
	DbCloseArea()
	
	DbSelectArea("LBB")
	DbSetOrder(1)
	DbSeek(xFilial("LBB")+aVetProp[i,01])
	
/*	// Valor da Gordura (calculo antigo)
	If LBH->(DbSeek(xFilial("LBH") + LBB->LBB_EST + "GD"))
		nValGor := LBH->LBH_VALOR
	Else
		nValGor := 0
	Endif
	_nVLGOR := Round(((LBB->LBB_GORDUR - nTeorMin) / 100 )* nValGor,2)
*/	
	_nVLGOR := aVetProp[i,48]  // Pagto Qualidade
	
	//FunRural
	nValorEnt := 0
	For x_:=3 to 16 //Vetor de Valores, so nao entra outros creditos
		nValorEnt += aVetProp[i,x_]
	Next
	
	SA2->(Dbsetorder(1))
	if SA2->(Dbseek(xFilial("SA2")+LBB->LBB_CODFOR+LBB->LBB_LOJA))
		SED->(Dbsetorder(1))
		if SED->(dbseek(xFilial("SED")+SA2->A2_NATUREZ))
			nFunRura := IIF ( lRoundFUN ,round((nValorEnt * SED->ED_PERCINS)/100,2),Noround((nValorEnt * SED->ED_PERCINS)/100,2))
			if LBB->LBB_FUNRUR $ "S "
				_nVLFUN := nFunRura
			Endif
		Endif
	Endif
	If aVetProp[i,37] == "B"
		_nQTCOT  := aVetProp[i,18] + aVetProp[i,19] + aVetProp[i,20]  // Leite Cota B
		_nVLTOT  := aVetProp[i,03] + aVetProp[i,04] + aVetProp[i,05] + aVetProp[i,15] + aVetProp[i,16]// Valor Total B
		_nQTEXT  := aVetProp[i,21] + aVetProp[i,22] + aVetProp[i,23] + aVetProp[i,24]// Extra Cota B
		_nVLEXT  := aVetProp[i,06] + aVetProp[i,07] + aVetProp[i,08] + aVetProp[i,09]// Valor Extra Cota B
	Else
		_nQTCOT  := aVetProp[i,24] + aVetProp[i,25] + aVetProp[i,26] // Leite Cota C
		_nVLTOT  := aVetProp[i,09] + aVetProp[i,10] + aVetProp[i,11] + aVetProp[i,15] + aVetProp[i,16]// Valor Total C
		_nQTEXT  := aVetProp[i,27] + aVetProp[i,28] + aVetProp[i,29] // Extra Cota C
		_nVLEXT  := aVetProp[i,12] + aVetProp[i,13] + aVetProp[i,14] // Valor Extra Cota C
	Endif
	_nVLLIQ  := (_nVLEXT + _nVLTOT) - (_nVLFUN + Noround(aVetProp[i,31],2) + Noround(aVetProp[i,34],2))
	_nVLBRU  := _nVLEXT + _nVLTOT // Valor Total Bruto
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8       
		nLin := nLin + 1     
	Endif
	// 0        10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210
	// 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	// Codigo Nome                                      Extra   Valor            Leite     Valor        Valor      Leite Valor Percen    Valor  Valor            Valor      Valor      Valor      Liquido Redutase   Preço
	//        Produtor                                   Cota   Extra Cota        Cota  Unitário        Total      Ácido Ácido Gordur Qualidad  Total Bruto   Funrural    Capital      Frete      a Pagar          Líquido
	// 999999 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 999,999,999 9,999,999.99 999,999,999 99.999999 9,999,999.99 99,999,999     9  99.99 9,999.99 9,999,999.99 999,999.99 999,999.99 999,999.99 9,999,999.99 9,999.99 99,9999
	
	If Empty(cLinha) .or.  cLinha <> aVetProp[i,30]
		nLin := nLin + 1
		@nLin,000 PSAY "Linha : " + aVetProp[i,30] + " - " +Posicione("LBC", 1, xFilial("LBC")+aVetProp[i,30],"LBC_DESC") //
		nLin := nLin + 1
	Endif
	
	@nLin,000 PSAY aVetProp[i,1] 																			  // Codigo
	@nLin,007 PSAY Substr(aVetProp[i,38],1,35)													              // Nome Fornecedor
	@nLin,043 PSAY _nQTEXT           												PICTURE "@E 999,999,999"  // Extra Cota
	@nLin,055 PSAY _nVLEXT            												PICTURE "@E 9,999,999.99" // Valor Extra Cota
	@nLin,068 PSAY _nQTCOT            												PICTURE "@E 999,999,999"  // Leite Cota
	@nLin,080 PSAY _nVLTOT / _nQTCOT  												PICTURE "@E 99.999999"	  // Valor Unitario
	@nLin,090 PSAY _nVLTOT            												PICTURE "@E 9,999,999.99" // Valor Total
	@nLin,103 PSAY _nQTACI            												PICTURE "@E 99,999,999"   // Leite Acido
	@nLin,118 PSAY 0                  																		  // Valor Acido
	@nLin,121 PSAY Posicione("LBB", 1, xFilial("LBB")+aVetProp[i,1],"LBB_GORDUR") PICTURE "@E 99.99"        // Percentual de Gordura
	@nLin,127 PSAY _nVLGOR            											    PICTURE "@E 9999.999"     // Valor Qualidade
	@nLin,136 PSAY _nVLBRU			  												PICTURE "@E 9,999,999.99" // Valor Total Bruto
	@nLin,149 PSAY _nVLFUN            												PICTURE "@E 999,999.99"   // Valor Funrural
	@nLin,160 PSAY Noround(aVetProp[i,34],2)										PICTURE "@E 999,999.99"   // Valor Taxa Capital
	@nLin,171 PSAY Noround(aVetProp[i,31],2)     									PICTURE "@E 999,999.99"   // Valor Frete
	@nLin,182 PSAY _nVLLIQ															PICTURE "@E 9,999,999.99" // Liquido a Pagar
	@nLin,195 PSAY IIF(aVetProp[i,37]== 'B',0, LBO->LBO_RESUL) 					PICTURE "@E 9,999.99"     // Redutase
	@nLin,204 PSAY  _nVLLIQ / _nQTCOT 												PICTURE "@E 999.9999"      // Preco Liquido
	
	nLin := nLin + 1 // Avanca a linha de impressao
	
	// Armazenamento de Valores LINHA
	_nQTEXTL  +=  _nQTEXT
	_nVLEXTL  +=  _nVLEXT
	_nQTCOTL  +=  _nQTCOT
	_nVLTOTL  +=  _nVLTOT
	_nQTACIL  +=  _nQTACI
	_nVLGORL  +=  _nVLGOR
	_nVLBRUL  +=  _nVLBRU
	_nVLFUNL  +=  _nVLFUN
	_nVLTXCL  +=  Noround(aVetProp[i,34],2)
	_nVLFREL  +=  Noround(aVetProp[i,31],2)
	_nVLLIQL  +=  _nVLLIQ
	
	// Armazenamento de Valores TOTAIS
	_nQTEXTT  +=  _nQTEXT
	_nVLEXTT  +=  _nVLEXT
	_nQTCOTT  +=  _nQTCOT
	_nVLTOTT  +=  _nVLTOT
	_nVLBRUT  +=  _nVLBRU
	_nVLFUNT  +=  _nVLFUN
	_nVLTXCT  +=  Noround(aVetProp[i,34],2)
	_nVLFRET  +=  Noround(aVetProp[i,31],2)
	_nVLLIQT  +=  _nVLLIQ
	
	cLinha    := aVetProp[i,30]
	
Next                                 

// Impressao do total da ultima linha
nLin := nLin + 1
@nLin,000 PSAY "Total Linha " + cLinha + " - " +LEFT(Posicione("LBC", 1, xFilial("LBC")+cLinha,"LBC_DESC"),20)
@nLin,043 PSAY _nQTEXTL           												PICTURE "@E 999,999,999"  // Extra Cota
@nLin,055 PSAY _nVLEXTL            												PICTURE "@E 9,999,999.99" // Valor Extra Cota
@nLin,068 PSAY _nQTCOTL            												PICTURE "@E 999,999,999"  // Leite Cota
@nLin,090 PSAY _nVLTOTL            												PICTURE "@E 9,999,999.99" // Valor Total
@nLin,103 PSAY _nQTACIL            												PICTURE "@E 99,999,999"   // Leite Acido
@nLin,118 PSAY 0                  																		  // Valor Acido
@nLin,127 PSAY _nVLGORL            											    PICTURE "@E 9999.999"    // Valor Qualidade
@nLin,136 PSAY _nVLBRUL			 												PICTURE "@E 9,999,999.99" // Valor Total Bruto
@nLin,149 PSAY _nVLFUNL            												PICTURE "@E 999,999.99"     // Valor Funrural
@nLin,160 PSAY _nVLTXCL		     												PICTURE "@E 999,999.99"     // Valor Taxa Capital
@nLin,171 PSAY _nVLFREL     													PICTURE "@E 999,999.99"     // Valor Frete
@nLin,182 PSAY _nVLLIQL															PICTURE "@E 9,999,999.99" // Liquido a Pagar
nLin := nLin + 1

nLin := nLin + 1 // Avanca a linha de impressao
@nLin,000 PSAY "Total Geral"
@nLin,043 PSAY _nQTEXTT           												PICTURE "@E 999,999,999"  // Extra Cota
@nLin,055 PSAY _nVLEXTT            												PICTURE "@E 9,999,999.99" // Valor Extra Cota
@nLin,068 PSAY _nQTCOTT            												PICTURE "@E 999,999,999"  // Leite Cota
@nLin,090 PSAY _nVLTOTT            												PICTURE "@E 9,999,999.99" // Valor Total
@nLin,136 PSAY _nVLBRUT			 												PICTURE "@E 9,999,999.99" // Valor Total Bruto
@nLin,149 PSAY _nVLFUNT            												PICTURE "@E 999,999.99"     // Valor Funrural
@nLin,160 PSAY _nVLTXCT		     												PICTURE "@E 999,999.99"     // Valor Taxa Capital
@nLin,171 PSAY _nVLFRET     													PICTURE "@E 999,999.99"     // Valor Frete
@nLin,182 PSAY _nVLLIQT															PICTURE "@E 9,999,999.99" // Liquido a Pagar

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³Microsiga           º Data ³  10/20/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Criar as perguntas referentes a este relatorio no SX1       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TPL - Cooperativa de Leite                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg()

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
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/VaR14/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Linha De      ","Linha De      ","Linha De      ","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","LBC"}) //
aAdd(aRegs,{cPerg,"02","Linha Ate     ","","","mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","LBC"}) //
aAdd(aRegs,{cPerg,"03","Produtor De   ","","","mv_ch3","C",6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","LBB"}) //
aAdd(aRegs,{cPerg,"04","Produtor Ate  ","","","mv_ch4","C",6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","LBB"}) //

For i:=1 to Len(aRegs)
	If !MsSeek(PADR(cPerg,nTamSX1)+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	endif
Next

dbSelectArea(_sAlias)
Return(Nil)
