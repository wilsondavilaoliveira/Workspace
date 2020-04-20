#include "Protheus.ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CACCOR10 ³ Autor ³ Marco Aurelio TRT005  ³ Data ³ 25/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Bonificacao por Quantidade                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Graos e Leite                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CACCOR10()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Bonificação por Quantidade."
Local cPict          := ""
Local imprime        := .T.
Local aOrd           := {}
Private nLin         := 80
Private Cabec1       := ""
Private Cabec2       := ""
Private titulo       := "Bonificacao p/ Qtd"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 80
Private tamanho      := "P"
Private nCaracter    := 15
Private nomeprog     := "CACCOR10"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "CACCOR10"
Private cString      := "LBL"


//CHKTEMPLATE("COL")

ValidPerg()

if !Pergunte("CACR10",.t.)
   Return
Endif        

Cabec1  := "                                          Periodo " + Dtoc(MV_Par01) + " a " + Dtoc(MV_Par02)
Cabec2  := "     Faixas           Qtd.Produtores          Litros                 Valor"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Processa({|| Impr_Relat()})       
Return

Static Function Impr_Relat()
Local i

AFaixa:={}
ATotais:={0,0,0}
DbSelectArea(cString)
DbGotop()

_wfim := RecCount() 
ProcRegua(_wfim)    

while !EOF() 

  IncProc("Determinando Faixas...")

  If len(aFaixa) < 4000
     AADD(AFaixa,{ LBL_LITINI,LBL_LITFIN , 0 , 0 ,0 })
  Endif
  DbSkip()
Endd

DbSelectArea("LBP")
DbSetOrder(2)
_wfim:=RecCount() 
DbSeek(xFilial("LBP")+Dtos(mv_par01),.T.)

ProcRegua(_wfim-recno())    

While !Eof().and.LBP->LBP_DATINI >= mv_par01.and.LBP->LBP_DATFIN <=mv_par02

    IncProc("Gerando Relatório... ")

	IF ALLTRIM(LBP->LBP_CODPRO)="TOTAL"
		DBSKIP()
		LOOP
	ENDIF

      fLitros:=LBP->LBP_PRODUC  / ((mv_par02-mv_par01)+1)        //Faixa em Litros

      For i:=1 to Len(aFaixa)
             Fa:=aFaixa[I][1]
             Fb:=aFaixa[I][2]             

               If  fLitros >= Fa .and. fLitros <= Fb
                    AFaixa[I][3]:=Afaixa[I][3]+1
                    AFaixa[I][4]:=Afaixa[I][4]+LBP->LBP_PRODUC
                       DbSelectarea("LBQ")
                       DbSetorder(1)
                       DbSeek(xFilial("LBQ")+LBP->LBP_CODPRO+Dtos(LBP->LBP_DATINI),.T.)
                  	
                    Quebra:= xFilial("LBQ")+LBP->LBP_CODPRO
                    While !Eof().and.quebra==LBQ->LBQ_FILIAL+LBQ->LBQ_CODPRO .AND. LBQ->LBQ_DATINI>=MV_PAR01 .AND. LBQ->LBQ_DATINI<=MV_PAR02
                            If  Trim(LBQ->LBQ_DESC)== "Bonific Quantidade"
                                AFaixa[I][5]:=AFaixa[I][5]+LBQ->LBQ_VALOR
                            Endif 
                           DbSkip()
                     Endd

               Endif
      Next

  DbSelectArea("LBP")
  DbSkip()
Enddo

setprc(0,0)

nLin := cabec(titulo,Cabec1,Cabec2,nomeprog,Tamanho,nCaracter) + 1

For I:= 1 To len(aFaixa)
	@ nLin,00 PSAY Transform(aFaixa[I,1],"9999")+'      '+Transform(aFaixa[I,2],"9999")+'           '+Transform(aFaixa[I,3],"999")+'            '+Transform(aFaixa[I,4],"@e 999,999,999")+'            '+Transform(aFaixa[I,5],"@E 99,999,999.99")
	aTotais[1]:=aFaixa[i,3]+aTotais[1]
	aTotais[2]:=aFaixa[i,4]+aTotais[2]
	aTotais[3]:=aFaixa[i,5]+aTotais[3]	
	nLin++
Next
@ nLin,24 PSAY '----            ------------            -------------'
nLin++   
@ nlin,10 PSAY 'Totais'
@ nLin,24 PSAY Transform(aTotais[1],"9999")+'            '+Transform(aTotais[2],"@e 999,999,999")+'            '+Transform(aTotais[3],"@E 99,999,999.99")
Ms_Flush()              
  

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

/*-----------------------------------------------------------------------------
	Função   VALIDPERG    
    Descrição Verifica e inclui as perguntas no sx1   
------------------------------------------------------------------------------*/
Static Function ValidPerg
Local j, i
Local _sAlias	:= Alias()
Local aRegs		:= {}
Local nTamSX1   := Len(SX1->X1_GRUPO)
Local cPerg		:= "CACR10"

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

AADD(aRegs,{cPerg,"01"	,"Periodo Inicial ?","Periodo Inicial ?","Periodo Inicial ?"	,"mv_ch1"	,"D"	,8			,0			,0		,"G"	,""		,"mv_par01"		,""		,"01/01/80"		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02"	,"Periodo Final ?"	,"                "		,"                "	,"mv_ch2"	,"D"	,8			,0			,0		,"G"	,""		,"mv_par02"		,""		,"01/01/10"		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"","","","","","","","","","","","","",""})

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

Return(nil)