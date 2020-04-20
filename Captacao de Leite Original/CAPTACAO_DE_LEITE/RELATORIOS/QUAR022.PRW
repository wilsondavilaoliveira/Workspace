#include "protheus.ch"
#include "tbiconn.ch"
#include "topconn.ch"
#include "rwmake.ch"                                       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ QUAR022  ³ Autor ³  Darlan Maciel        ³ Data ³ 25/01/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Demostrativo Mensal.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Quata - PL8.27 - FS07529302 - Proposta 4                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.  ³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QUAR022

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do relatorio               				                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private nLargura   := 220
Private nTamanho   := "G"
Private nomeprog   := "QUAR022" 
Private nTipo      := "" //18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1 }
Private nLastKey   := 0
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "QUAR022" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    := "LBB"
Private cPerg      := "QUAR022"
Private aNreg      := {}
Private _nPos      := 0
Private nQtdReg    := 0       
Private dDataIni   := CtoD("  /  /  ")
Private dDataFim   := CtoD("  /  /  ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria pergunta no SX1. Parametros do Relatorio.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Linha de          ? 999999        ³
//³ mv_par02 - Linha ate         ? 999999        ³
//³ mv_par03 - Produtor de       ? 999999        ³
//³ mv_par04 - Produtor ate      ? 999999        ³
//³ mv_par05 - Mes               ? 99            ³
//³ mv_par06 - Ano               ? 9999          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CriaSx1( cPerg )
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Rel. de recebimento diario de leite.                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ImpRel()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpRel	º Autor ³  Darlan Maciel         º Data ³  25/01/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Impressao do Demostrativo Mensal.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 													    		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpRel

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Demostrativo Mensal."
Local cPict        := ""
Local nLin         := 80
Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {} 
Local titulo       := "Demostrativo Mensal."    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,nTamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//Define data inicial e final para gerar a query
//dDataIni := CtoD( "01" + "/" + StrZero(mv_par05,2) + "/" + mv_par06 )
//dDataFim := LastDay( dDataIni )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da query principal...(TRB)      		                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT F1_FILIAL,F1_DOC,F1_FORNECE,F1_LOJA,F1_EMISSAO,F1_VALICM, F1_XINCEN, F1_SERIE, "
	cQuery += "(SELECT SUM(D1_QUANT) FROM " + RetSqlName("SD1") + " SD1 WHERE SD1.D_E_L_E_T_ <> '*' AND SD1.D1_FILIAL = SF1.F1_FILIAL "
	cQuery += "AND SD1.D1_DOC = SF1.F1_DOC AND SD1.D1_FORNECE = SF1.F1_FORNECE AND SD1.D1_LOJA = SF1.F1_LOJA) D1_QUANT, "
	cQuery += "(SELECT SUM(D1_TOTAL) FROM " + RetSqlName("SD1") + " SD1 WHERE SD1.D_E_L_E_T_ <> '*' AND SD1.D1_FILIAL = SF1.F1_FILIAL "
	cQuery += "AND SD1.D1_DOC = SF1.F1_DOC AND SD1.D1_FORNECE = SF1.F1_FORNECE AND SD1.D1_LOJA = SF1.F1_LOJA) F1_VALBRUT, "
	cQuery += "A2_CGC,A2_INSCR,LBB_CODPRO,LBB_DESC,LBB_LINHA,LBB_RECANT,LBB_INCENT,LBB_FUNDES, LBB_FAIXA, A2_NOME "
cQuery += "FROM " + RetSqlName("SF1") + " SF1 JOIN " + RetSqlName("SA2") + " SA2 ON "
	cQuery += "SF1.D_E_L_E_T_ = SA2.D_E_L_E_T_ "
	cQuery += "AND SF1.F1_FORNECE = SA2.A2_COD "
	cQuery += "AND SF1.F1_LOJA = SA2.A2_LOJA "
cQuery += "JOIN " + RetSqlName("LBB") + " LBB ON "
	cQuery += "SF1.D_E_L_E_T_ = LBB.D_E_L_E_T_ "
	cQuery += "AND SF1.F1_FORNECE = LBB.LBB_CODFOR "
	cQuery += "AND SF1.F1_LOJA = LBB.LBB_LOJA "
cQuery += "WHERE SF1.D_E_L_E_T_ <> '*' "
	cQuery += "AND SF1.F1_ESPECIE = 'SPED' "
	cQuery += "AND SF1.F1_FILIAL = '" + xFilial("SF1") + "' "
	cQuery += "AND (SF1.F1_EMISSAO BETWEEN '" + DtoS(MV_PAR05) + "' AND '" + DtoS(MV_PAR06) + "') "
	cQuery += "AND (LBB.LBB_LINHA BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "') "
	cQuery += "AND (LBB.LBB_CODPRO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "') "
cQuery += "ORDER BY CAST(LBB_LINHA AS INT),CAST(LBB_CODPRO AS INT) "
//cQuery += "ORDER BY F1_SERIE, F1_DOC "

MemoWrite("C:\EDI\QUAR022.SQL",cQuery)

If Select("TRB") > 0
	TRB->( dbCloseArea() )
EndIf
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)


TcSetField( "TRB","F1_EMISSAO" ,"D" ,TamSX3("F1_EMISSAO")[1] ,TamSX3("F1_EMISSAO")[2])
TcSetField( "TRB","F1_VALBRUT" ,"N" ,TamSX3("F1_VALBRUT")[1] ,TamSX3("F1_VALBRUT")[2])
TcSetField( "TRB","F1_VALICM"  ,"N" ,TamSX3("F1_VALICM")[1]  ,TamSX3("F1_VALICM")[2])
TcSetField( "TRB","D1_QUANT"   ,"N" ,TamSX3("D1_QUANT")[1]   ,TamSX3("D1_QUANT")[2])
TcSetField( "TRB","F1_XINCEN"  ,"N" ,TamSX3("F1_XINCEN")[1]  ,TamSX3("F1_XINCEN")[2])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe registro a ser impresso                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRB->( dbEval( { || nQtdReg++ },, { || !EOF() } ) )
TRB->( dbGoTop() )

If nQtdReg == 0
	MsgAlert( "Não existe registros para impressão do relatório.", "ATENÇÃO" )
	If Select("TRB") > 0
		TRB->( dbCloseArea() )
	EndIf
	return 
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha tabelas criadas para auxiliar na impressao                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("TRB") > 0
	TRB->( dbCloseArea() )
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³  Darlan Maciel         º Data ³  25/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS     º±±
±±º          ³ monta a janela com a regua de processamento.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nTtQtde   := 0 // Total quantidade (litros)
Local nTtVlr    := 0 // Total "global"
Local nTtIcms   := 0 // Total icms
Local nTtCredi  := 0 // Total credito icms
Local nTgCredi  := 0 // Total credito icms
Local nTtSaldo  := 0 // Total saldo icms
Local nTtReduc  := 0 // Total icms com reducao
Local nTtFunde  := 0 // Total fundese
Local nTtIcmST  := 0 // Total icms ST
Local nTtIncen  := 0 // Total incentivo
Local nVlSaldo  := 0 // Valor saldo icms
Local nVlReduc  := 0 // Valor icms com reducao
Local nVlFunde  := 0 // Valor fundese
Local nVlIcmST  := 0 // Valor icms ST
Local nVlIncen  := 0 // Valor incentivo
Local nPercFun  := ( GetMv("MV_FUNDESE")/100) // Valor percentual para fundese
Local nPercInc  := ( GetMv("ES_INCENTI")/100) // Valor percentual para incentivo
Local nVlFaixa1 := 0 // Valor para classificacao do produtor como faixa 1
Local nVlFaixa2 := 0 // Valor para classificacao do produtor como faixa 2
Local nVlFaixa3 := 0 // Valor para classificacao do produtor como faixa 3
Local nPerc1    := 0 // percentual aplicado para faixa 1
Local nPerc2    := 0 // percentual aplicado para faixa 2
Local nPerc3    := 0 // percentual aplicado para faixa 3
                                                                          
dbSelectArea("PC4")
dbSetOrder(1)
dbGotop()
While !eof()
	If PC4->PC4_FAIXA = '1'
    	nVlFaixa1	:= PC4->PC4_VLMAX
    	nPerc1		:= PC4->PC4_PERCEN / 100
	ElseIf PC4->PC4_FAIXA = '2'
    	nVlFaixa2	:= PC4->PC4_VLMAX
    	nPerc2		:= PC4->PC4_PERCEN / 100
	ElseIf PC4->PC4_FAIXA = '3'
    	nVlFaixa3	:= PC4->PC4_VLMAX
    	nPerc3		:= PC4->PC4_PERCEN / 100
	Endif 
	PC4->(dbSkip())
End


titulo := "Demostrativo Mensal - " + SubStr(Dtos(mv_par05),5,2) + "/" + SubStr(Dtos(mv_par05),1,4)

//                                                                                                    1         1         1         1         1         1         1         1         1         1         2         2         2
//          1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//            PRODUTOR RURAL               |    INSCRICAO     |* FAIXA |OPTANTE|NOTA FISCAL|  QUANTIDADE |    VALOR TOTAL  |    VLR ICMS    | CREDITO DE |     SALDO DE   |   ICMS COM |  FUNDESE A |  ICMS-ST A |  VALOR DO  
//                                         |    PROD.RURAL    |CLASSIF.|FUNDESE|DE ENTRADA |   (LITROS)  |        NFE      |    DESTACADO   | ICMS APROV |       ICMS     |   REDUCAO  |  RECOLHER  |  RECOLHER  |  INCENTIVO 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA |999999999999999999|    9   |  AAA  | 999999999 |  999.999.999|   999.999.999,99|  999.999.999,99|  999.999,99|  999.999.999,99|  999.999,99|  999.999,99|  999.999,99|  999.999,99
//                                       T O T A L   G E R A L  --->                       |  999.999.999|   999.999.999,99|  999.999.999,99|  999.999,99|  999.999.999,99|  999.999,99|  999.999,99|  999.999,99|  999.999,99
//           * FAIXA DE CLASSIFICACAO: 1 - Receita Bruta Anual com leite e derivados inferior ou igual a 
//                                     2 - Receita Bruta Anual com leite e derivados superior a 999999999999 e inferior ou igual a  
//                                     3 - Receita Bruta Anual com leite e derivados superior a  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(nQtdReg)

dbselectarea("TRB")

TRB->( dbGoTop() )

Cabec1 := "            PRODUTOR RURAL               |    INSCRICAO     |* FAIXA |OPTANTE|NOTA FISCAL|  QUANTIDADE |    VALOR TOTAL  |    VLR ICMS    | CREDITO DE |     SALDO DE   |   ICMS COM |  FUNDESE A |  ICMS-ST A |  VALOR DO  "
Cabec2 := "                                         |    PROD.RURAL    |CLASSIF.|FUNDESE|DE ENTRADA |   (LITROS)  |        NFE      |    DESTACADO   | ICMS APROV |       ICMS     |   REDUCAO  |  RECOLHER  |  RECOLHER  |  INCENTIVO "

While TRB->( !EOF() )

	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho na quebra de pagina                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLin > 55 // Salto de Página
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,nTamanho,nTipo)
		nLin := 9
	Endif
	
	nTtCredi := 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAbortPrint
		@ nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

//	@ nLin,000 PSAY AllTrim(SubStr(TRB->LBB_DESC,1,40))
	@ nLin,000 PSAY AllTrim(SubStr(TRB->A2_NOME,1,40))
	@ nLin,042 PSAY PADC(AllTrim(TRB->A2_INSCR),18)
//	@ nLin,065 PSAY IIF(TRB->LBB_RECANT <= nVlFaixa1,"1",IIF(TRB->LBB_RECANT > nVlFaixa1 .And. TRB->LBB_RECANT <= nVlFaixa2,"2","3")) 
	@ nLin,065 PSAY TRB->LBB_FAIXA
	@ nLin,072 PSAY IIF(TRB->LBB_FUNDES == "1","SIM","NAO")
	@ nLin,078 PSAY PADC(AllTrim(TRB->F1_DOC),11)
	@ nLin,092 PSAY Transform(TRB->D1_QUANT ,"@E 999,999,999")
	@ nLin,107 PSAY Transform(TRB->F1_VALBRUT ,"@E 999,999,999.99")
	@ nLin,124 PSAY Transform(TRB->F1_VALICM ,"@E 999,999,999.99")
	@ nLin,141 PSAY Transform(nTtCredi ,"@E 999,999.99")
	
	nVlSaldo := (TRB->F1_VALICM - nTtCredi) 
	@ nLin,154 PSAY Transform( nVlSaldo ,"@E 999,999,999.99")	
	
	IF TRB->LBB_INCENT = "S"
		If TRB->LBB_FAIXA = '1'
			nVlReduc := (TRB->F1_VALICM * nPerc1)
		ElseIf TRB->LBB_FAIXA = '2'
			nVlReduc := (TRB->F1_VALICM * nPerc2)
		ElseIf TRB->LBB_FAIXA = '3'
			nVlReduc := (TRB->F1_VALICM * nPerc3)
		Else
			nVlReduc := 0
		Endif
	Else
		nVlReduc := 0
	Endif

	
	@ nLin,171 PSAY Transform( nVlReduc ,"@E 999,999.99")	

	nVlFunde := IIF(TRB->LBB_FUNDES == "1",(nVlReduc * nPercFun),0)
	@ nLin,184 PSAY Transform( nVlFunde ,"@E 999,999.99")	

	nVlIcmST := (nVlReduc - nVlFunde)  
	@ nLin,197 PSAY Transform( nVlIcmST ,"@E 999,999.99")	

	nVlIncen := IIF(TRB->LBB_INCENT == "S",(TRB->F1_XINCEN),0)
	@ nLin,210 PSAY Transform( nVlIncen ,"@E 999,999.99")	

	nTtQtde  := nTtQtde  + TRB->D1_QUANT   // Valor Total quantidade (litros)
	nTtVlr   := nTtVlr   + TRB->F1_VALBRUT // Valor Total "global"
	nTtIcms  := nTtIcms  + TRB->F1_VALICM  // Valor Total icms
	nTgCredi := nTtCredi + nTtCredi        // Valor Total credito icms
	nTtSaldo := nTtSaldo + nVlSaldo        // Valor Total saldo icms
	nTtReduc := nTtReduc + nVlReduc        // Valor Total icms com reducao
	nTtFunde := nTtFunde + nVlFunde        // Valor Total fundese
	nTtIcmST := nTtIcmST + nVlIcmST        // Valor Total icms ST
	nTtIncen := nTtIncen + nVlIncen        // Valor Total incentivo
	
	nLin++
	TRB->( DbSkip() )
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho na quebra de pagina                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLin > 50 // Salto de Página
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,nTamanho,nTipo)
	nLin := 9
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao dos totalizadores das colunas de valores.                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ nLin,000 PSAY __PrtThinLine()
nLin++ 
@ nLin,039 PSAY "T O T A L   G E R A L  --->"
@ nLin,092 PSAY Transform( nTtQtde  ,"@E 999,999,999")
@ nLin,107 PSAY Transform( nTtVlr   ,"@E 999,999,999.99")
@ nLin,124 PSAY Transform( nTtIcms  ,"@E 999,999,999.99")
@ nLin,141 PSAY Transform( nTtCredi ,"@E 999,999.99")
@ nLin,154 PSAY Transform( nTtSaldo ,"@E 999,999,999.99")	
@ nLin,171 PSAY Transform( nTtReduc ,"@E 999,999.99")	
@ nLin,184 PSAY Transform( nTtFunde ,"@E 999,999.99")	
@ nLin,197 PSAY Transform( nTtIcmST ,"@E 999,999.99")	
@ nLin,210 PSAY Transform( nTtIncen ,"@E 999,999.99")	
nLin++ 
@ nLin,000 PSAY __PrtFatLine()
nLin++ 

@ nLin,011 PSAY "* FAIXA DE CLASSIFICACAO: 1 - "+Alltrim(Transform(nPerc1, "@E 999.99"))+"% Receita Bruta Anual com leite e derivados inferior ou igual a " + AllTrim(Transform( nVlFaixa1 ,"@E 999,999,999.99")) 
nLin++ 
@ nLin,037 PSAY "2 - "+Alltrim(Transform(nPerc2, "@E 999.99"))+"% Receita Bruta Anual com leite e derivados superior a " + AllTrim(Transform( nVlFaixa1 ,"@E 999,999,999.99"))  + " e inferior ou igual a " + AllTrim(Transform( nVlFaixa2 ,"@E 999,999,999.99")) 
nLin++ 
@ nLin,037 PSAY "3 - "+Alltrim(Transform(nPerc3, "@E 999.99"))+"% Receita Bruta Anual com leite e derivados superior a " + AllTrim(Transform( nVlFaixa2 ,"@E 999,999,999.99")) + " e inferior ou igual a " + AllTrim(Transform( nVlFaixa3 ,"@E 999,999,999.99")) 
nLin++

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

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaSx1	º Autor ³  Darlan Maciel         º Data ³  22/01/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta os campos contidos no SX1		         	              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 													    		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSx1(cPerg)
Local aArea := GetArea()
Local aHelp	:= {}

Aadd(aHelp,{{"Informe o Cód. da Linha (de...ate)."		},{"Informe o Cód. da Linha (de...ate)."	},{"Informe o Cód. da Linha (de...ate)."	}})
Aadd(aHelp,{{"Informe o Cód. do Produtor (de...ate)."	},{"Informe o Cód. do Produtor (de...ate)."	},{"Informe o Cód. do Produtor (de...ate)."	}})
//Aadd(aHelp,{{"Mês desejado. Ex.:1=Janeiro,4=Abril."		},{"Mês desejado. Ex.:1=Janeiro,4=Abril."	},{"Mês desejado. Ex.:1=Janeiro,4=Abril."	}})
//Aadd(aHelp,{{"Ano desejado com 4 digitos.Ex.: 2008."	},{"Ano desejado com 4 digitos.Ex.: 2008."	},{"Ano desejado com 4 digitos.Ex.: 2008."	}})

PutSX1(cPerg,"01","Linha de "		,"Linha de"			,"Linha de "		,"mv_ch1" ,"C" ,06 ,0 ,0 ,"G" ,""			,"LBC" ,"" ,"" ,"mv_par01" ,"" ,"","","","" ,"","","","","","","","","","","",aHelp[1][1],aHelp[1][2],aHelp[1][3])
PutSX1(cPerg,"02","Linha até "		,"Linha até "		,"Linha até "		,"mv_ch2" ,"C" ,06 ,0 ,0 ,"G" ,"naovazio"	,"LBC" ,"" ,"" ,"mv_par02" ,"" ,"","","","" ,"","","","","","","","","","","",aHelp[1][1],aHelp[1][2],aHelp[1][3])
PutSX1(cPerg,"03","Produtor de "	,"Produtor de "		,"Produtor de "		,"mv_ch3" ,"C" ,06 ,0 ,0 ,"G" ,""			,"LBB" ,"" ,"" ,"mv_par03" ,"" ,"","","","" ,"","","","","","","","","","","",aHelp[2][1],aHelp[2][2],aHelp[2][3])
PutSX1(cPerg,"04","Produtor até "	,"Produtor ate "	,"Produtor até "	,"mv_ch4" ,"C" ,06 ,0 ,0 ,"G" ,"naovazio"	,"LBB" ,"" ,"" ,"mv_par04" ,"" ,"","","","" ,"","","","","","","","","","","",aHelp[2][1],aHelp[2][2],aHelp[2][3])
PutSx1(cPerg,"05","Entrada De?" 	,"","","mv_ch5","D",08,0,0,"G","",""		,"","","mv_par05")
PutSX1(cPerg,"06","Entrada Até?"	,"","","mv_ch6","D",08,0,0,"G","",""		,"","","mv_par06")

RestArea(aArea)
Return NIL