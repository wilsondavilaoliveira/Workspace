#include "Protheus.ch"
#include "TopConn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � CACCOR05 � Autor � Marco Aurelio TRT005  � Data � 25/09/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do Resumo de Carretos                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Cooperativa de Leite                                       ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL              ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���RicardoBerti�11/01/06�087948�Nao listar Crit.da Qualid.: LBQ_CRIQUA="S"���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Descri��o � PLANO DE MELHORIA CONTINUA        �Programa   CACCOR05.PRW ���
�������������������������������������������������������������������������Ĵ��
���ITEM PMC  � Responsavel              � Data                            ���
�������������������������������������������������������������������������Ĵ��
���      01  �                          �                                 ���
���      02  �                          �                                 ���
���      03  �                          �                                 ���
���      04  � Ricardo Berti            � 11/01/06                        ���
���      05  �                          �                                 ���
���      06  �                          �                                 ���
���      07  �                          �                                 ���
���      08  �                          �                                 ���
���      09  �                          �                                 ���
���      10  � Ricardo Berti            � 11/01/06                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CACCOR05()

//CHKTEMPLATE("COL")

//Variaveis Gerais

aImprime  := {}
nPos      := 0
nProducao := 0 
nPerc01   := 0
nPerc02   := 0
nPGranel  := 0
nBGranel  := 0
nTProducao:= 0
nTPerc01  := 0
nTPerc02  := 0
nTPGranel := 0
nTBGranel := 0

//Variaveis da SetPrint

nQtd        := 0  //CONTADOR PARA TOTALIZAR OS REGISTROS IMPRESSOS
aOrd        := {}
cDesc1      := "Este programa tem como objetivo imprimir relatorio "
cDesc2      := "de acordo com os parametros informados pelo usuario."
cDesc3      := "Resumo de Carretos"
cPict       := ""
lEnd        := .F.
lAbortPrint := .F.
limite      := 120
Tamanho     := "M"
nomeprog    := "CACCOR05"
nTipo       := 15  //COMPRIMIDO 
aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
nLastKey    := 0
cPerg       := "CACR05"
Titulo      := "Resumo de Carretos"
nLin        := 80
cbtxt       := Space(10)
cbcont      := 00
CONTFL      := 01
m_pag       := 01
imprime     := .T.
wnrel       := "CACR05" // Coloque aqui o nome do arquivo usado para impressao em disco
cString     := "LBO"

dbSelectArea(cString)
dbSetOrder(1)

ValidPerg() 

If Pergunte(cPerg,.t.)

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If ! nLastKey == 27
	
		SetDefault(aReturn,cString)
	
		If ! nLastKey == 27
	
			Processa({|| RptProc("Processando Filtro")})

		EndIf      
	EndIf      
EndIf      

Return(Nil)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � RptProc  � Autor � Marco Aurelio TRT005  � Data � 25/09/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processamento e impressao do relatorio                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Programa principal                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RptProc()

Local nPos := 1

cQuery := "SELECT"
cQuery += "     LBQ.LBQ_CODPRO, LBQ.LBQ_DESC, LBQ.LBQ_VALOR, LBQ.LBQ_QTD,"
cQuery += "     LBB.LBB_CODTAN"
cQuery += " FROM"
cQuery += "     " + RetSqlName("LBQ") + " LBQ,"
cQuery += "     " + RetSqlName("LBB") + " LBB"
cQuery += " WHERE"  
cQuery += "     LBQ.LBQ_FILIAL  = '" +xFilial("LBQ")+ "'AND" 
cQuery += "     LBB.LBB_FILIAL  = '" +xFilial("LBB")+ "'AND"
cQuery += "     LBQ.LBQ_CODPRO = LBB.LBB_CODPRO AND"
cQuery += "     LBQ.LBQ_DATINI BETWEEN '" +Dtos(mv_par01)+ "' AND '" +Dtos(mv_par02) + "' AND"
cQuery += "     LBQ.LBQ_CRIQUA <> 'S' AND"  // Ignora criterios da qualidade
cQuery += "     LBB.D_E_L_E_T_ = ' ' AND"
cQuery += "     LBQ.D_E_L_E_T_ = ' '"
cQuery += " ORDER BY"
cQuery += "     LBQ.LBQ_CODPRO ASC,"
cQuery += "     LBQ.LBQ_DESC ASC"
         
TCQUERY cQuery ALIAS RQRY NEW

//montar vetor para armazenar os calculos efetuados com o resultado da query

cFornecedor:=LBQ_CODPRO
aadd(aImprime,{cFornecedor,0,0,0,0,0})

_wfim:=RecCount() ; ProcRegua(_wfim)    
while !EOF() 

	IncProc("Gerando Relat�rio... ")


	If "1o. Perc" $ LBQ_DESC .and. empty(LBB_CODTAN)
		nPerc01 += LBQ_VALOR
	Elseif "2o. Perc" $ LBQ_DESC
		nPerc02 += LBQ_VALOR
	Elseif "1o. Perc" $ LBQ_DESC .and. AllTrim(LBB_CODTAN) <> ""
		nPGranel += LBQ_VALOR
    Endif
    
	If "Bonific a Granel" $ LBQ_DESC
		nBGranel += LBQ_VALOR
    Endif

	nProducao += LBQ_QTD

	dbskip()		
	
	if LBQ_CODPRO<>cFornecedor 

		aImprime[nPos,2] := nProducao
		aImprime[nPos,3] := nPerc01
		aImprime[nPos,4] := nPerc02
		aImprime[nPos,5] := nPGranel
		aImprime[nPos,6] := nBGranel

		if !eof()         
		    cFornecedor := LBQ_CODPRO		
			aadd(aImprime,{cFornecedor,0,0,0,0,0})
        	nPos := len(aImprime)
			nProducao := nPerc01 := nPerc02 := nPGranel := nBGranel := 0
		endif
	endif
enddo

cabec1:=space(52)+"Per�odo "+dtoc(mv_par01)+ " a " +dtoc(mv_par02) + ""
                                                               
cabec2:="Nome do Produtor                                 Producao        1o Perc         2o Perc        P Granel    Bonif Granel"
       //                                          _______________ ______________  ______________  ______________  ______________
       // 								           999,999,999,999 999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99 
       //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
       //         10        20        30        40        50        60        70        80        90       100
nTVetor := Len(aImprime)

For nPos := 1 to nTVetor

	If lAbortPrint
    	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	if nLin>60 
 		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)   
		nLin:=9
	endif

	//@ nLin,00 PSAY substr(aImprime[nPos,1],1,40)
	@ nLin,00 PSAY POSICIONE("LBB", 1, xFilial("LBB") + aImprime[nPos,1], "LBB_NOMFOR") 
	@ nLin,42 PSAY Transform(aImprime[nPos,2],"@E 999,999,999,999") 
	@ nLin,58 PSAY Transform(aImprime[nPos,3],"@E 999,999,999.99") 
	@ nLin,74 PSAY Transform(aImprime[nPos,4],"@E 999,999,999.99") 
	@ nLin,90 PSAY Transform(aImprime[nPos,5],"@E 999,999,999.99") 
	@ nLin,106 PSAY Transform(aImprime[nPos,6],"@E 999,999,999.99") 
	
	nLin++  //;	nQtd++
	
	nTProducao += aImprime[nPos,2]
	nTPerc01   += aImprime[nPos,3]
	nTPerc02   += aImprime[nPos,4]
	nTPGranel  += aImprime[nPos,5]
	nTBGranel  += aImprime[nPos,6]

Next

nLin++  
@ nLin, 00 PSAY "                                          _______________ ______________  ______________  ______________  ______________"
nLin++
@ nLin, 00 PSAY "Total Geral"
@ nLin, 42 PSAY Transform(nTProducao,"@E 999,999,999,999") 
@ nLin, 58 PSAY Transform(nTPerc01  ,"@E 999,999,999.99") 
@ nLin, 74 PSAY Transform(nTPerc02  ,"@E 999,999,999.99") 
@ nLin, 90 PSAY Transform(nTPGranel ,"@E 999,999,999.99") 
@ nLin,106 PSAY Transform(nTBGranel ,"@E 999,999,999.99") 

RQRY->(DBCLOSEAREA())

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return(Nil)
           

/* 
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � ValidPerg� Autor � Marco Aurelio TRT005  � Data � 25/09/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Criar as perguntas referentes a este relatorio no SX1      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Programa principal                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
EndI
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/VaR05/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Data Inicial","Data Inicial","Data Inicial","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Final","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
	If !MsSeek(PADR(cPerg,nTamSX1)+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next

dbSelectArea(_sAlias)
Return(Nil)
