#include "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function QUAA022B()

Local cPerg    		:= "QUA22B"
Local cNomArq  		:= ""
Local lRet	   		:= .F.
Local aSay      	:= {}
Local aButton   	:= {}
Local nOption		:= 0
Local dDiaCer		:= ctod(" ")
Local cMesAn1 		:= ""
Local dDataIn1 		:= ctod(" ")
Local dDataFi1 		:= ctod(" ")
Private lFim		:= .T.
Private cMensagem 	:= ''
Private dMVPAR_01	:= ''

/*
Sequencia de execu็ใo:
QUAA022B
PROQRY
RUNPROC
RunNFE
RunNFS
RunCPP
RunCPT
RunCPF
RunCRP
RunCRT
RunQLT
RunAdj
PRCRel
GerProc
*/

Private cCadastro   := "Fechamento mensal da capta็ใo de leite"

if AVISO("Database", "Antes de continuar VERIFIQUE se a DATABASE esta com o ultimo dia do m๊s do Fechamento !", {"OK","CANCELA"}, 2) == 2
Return
End if

AjustaSx1(cPerg)

If Pergunte(cPerg,.T.)

	If Month(MV_PAR01) == Month(MV_PAR02) .and. Year(MV_PAR01) == Year(MV_PAR02)

		cMesAn1 := Alltrim(StrZero(Month(MV_PAR01),2))+Alltrim(StrZero(Year(MV_PAR01),4))

		dDataIn1 := cTod("01/"+Alltrim(StrZero(Month(MV_PAR01),2))+"/"+Alltrim(StrZero(Year(MV_PAR01),4)) )
		dDataFi1 := LastDay(dDataIn1)

		dDiaCer := dDataFi1

	    dMVPAR_01 := MV_PAR01
	Else
		lFim := .F.
		APMsgAlert(OemToAnsi("As datas de Inicio e Fim do periodo devem pertencer ao mesmo Mes e Ano"),OemToAnsi("Aten็ใo"))

	Endif

	If GetMv('MV_ULMES') >= dDataBase
	lFim := .F.
	cMensagem := 'Verifique junto a controladoria o parโmetro ### MV_ULMES  ###, com conte๚do atual NรO permite o fechamento.' + CRLF
    End if

	If GetMv('MV_DATAFIN') >= dDataBase
	lFim := .F.
	cMensagem += 'Verifique junto a controladoria o parโmetro ### MV_DATAFIN ###, com conte๚do atual NรO permite o fechamento.' + CRLF
    End if

	If !EMPTY(FornBlock())
	lFim := .F.
	cMensagem += "Existem fornecedore(s) Bloqueado(s), verifique os c๓digo(s) : " + FornBlock() + CRLF
	End If

	if cMensagem <> ''
	lFim := .F.
	Aviso("Problemas Pr้_fechamento",cMensagem,{"OK"},3)
    End if

	If GetMv("MV_XDTFCHT") >= dDataBase .AND. GetMv("MV_DTFCHPG") >= dDataBase
	lFim := .F.
	MsgStop("O perํodo solicitado ja foi fechado !","Atencao")
	End If

	If MV_PAR02 <> dDataBase
	lFim := .F.
	MsgStop("Database deve ser o alterada para o ultimo dia do mes do fechamento!","Atencao")
	end If


//	If dDataBase == dDiaCer
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMV_PAR01 - Entrada De                       ณ
		//ณMV_PAR02 - Entrada Ate                      ณ
		//ณMV_PAR03 - Produtor De                      ณ
		//ณMV_PAR04 - Produtor Ate                     ณ
		//ณMV_PAR05 - Fechamento                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		aAdd(aSay,"Esta rotina faz o fechamento mensal da capta็ใo de leite, gerando")
		aAdd(aSay,"um relatorio para conferencia. Favor avaliar o parametro de fecha-")
		aAdd(aSay,"mento, como simula็ใo apenas gera o relat๓rio, ja como encerramento")
		aAdd(aSay,"o mes sera fechado, nใo permitindo mais sua reabertura.")

		aAdd(aButton, { 5,.T.,{|| Pergunte( cPerg, .T. )}})//Parametros
		aAdd(aButton, { 1,.T.,{|| nOption := 1, FechaBatch() }})//OK
		aAdd(aButton, { 2,.T.,{|| FechaBatch()          }})//Cancelar

		FormBatch(cCadastro,aSay,aButton)

		If nOption == 1
			ProQRY()
		Endif

	IF lFim
	Aviso("Final do Processamento","Fim do Processamento",{"OK"},2)
	End If

EndIf


Return nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ProQry()

Local aAreaAnt		:= GetArea()
Local oProces1		:= GetWndDefault()
Local cMesAno		:= ""

Private aNotas 		:= {}
Private aPagar		:= {}
Private aPedidos	:= {}
Private aAbat		:= {}
Private aItens		:= {}
Private aFrete		:= {}
Private nContGer	:= 0
Private nConta1		:= 0
Private nConta2		:= 0
Private nContSec	:= 0
Private nTTSegund	:= 0
Private dDataIni	:= ctod(" ")
Private dDataFim	:= cTod(" ")

If Month(MV_PAR01) == Month(MV_PAR02) .and. Year(MV_PAR01) == Year(MV_PAR02)

	cMesAno := Alltrim(StrZero(Month(MV_PAR01),2))+Alltrim(StrZero(Year(MV_PAR01),4))

	dDataIni := cTod("01/"+Alltrim(StrZero(Month(MV_PAR01),2))+"/"+Alltrim(StrZero(Year(MV_PAR01),4)) )
	dDataFim := LastDay(dDataIni)

    lValida := .T.
Else
	lValida := .F.
	APMsgAlert(OemToAnsi("As datas de Inicio e Fim do periodo devem pertencer ao mesmo Mes e Ano"),OemToAnsi("Aten็ใo"))
Endif

//Validacoes parametros fechamento de estoque e financeiro e verificacao de fornecedor  bloqueado - Wilson 17-06-09

	If lValida

		If GetMv('MV_ULMES') >= dDataBase
			cMensagem := 'Verifique junto a controladoria o parโmetro ### MV_ULMES  ###, com conte๚do atual NรO permite o fechamento.' + CRLF
	    End if

		If GetMv('MV_DATAFIN') >= dDataBase
			cMensagem += 'Verifique junto a controladoria o parโmetro ### MV_DATAFIN ###, com conte๚do atual NรO permite o fechamento.' + CRLF
	    End if

		If !EMPTY(FornBlock())
			cMensagem += "Existem fornecedore(s) Bloqueado(s), verifique os c๓digo(s) : " + FornBlock() + CRLF
		End If

		If !Empty(cMensagem)
			lValida := .F.
			Aviso("Problemas Pr้_fechamento",cMensagem,{"OK"},3)
	    End if

		If GetMv("MV_XDTFCHT") >= dDataBase .AND. GetMv("MV_DTFCHPG") >= dDataBase
			lValida := .F.
			MsgStop("O perํodo solicitado ja foi fechado !","Atencao")
		End If

		If MV_PAR02 <> dDataBase
			lValida := .F.
			MsgStop("Database deve ser o alterada para o ultimo dia do mes do fechamento!","Atencao")
		End If

	End if

	IF lValida
    oProces1	:= MsNewProcess():New( { |lEnd| RunProc( oProces1, cMesAno ) }, "Processando o Fechamento de capta็ใo", "Processando..." )
	oProces1:Activate()
    End if

RestArea(aAreaAnt)

Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RunProc( oProces1, cMesAno )

Local nProcessos := 9

If MV_PAR05 == 2
	nProcessos ++
	MV_PAR03 := Replicate(" ", tamsx3("LBB_CODPRO")[1] )
	MV_PAR04 := Replicate("Z", tamsx3("LBB_CODPRO")[1] )
Endif

oProces1:SetRegua1( 20 )

RunNFE( oProces1, cMesAno )

oProces1:IncRegua1( "Gerando notas fiscais de Saida" )
RunNFS( oProces1, cMesAno )

oProces1:IncRegua1( "Gerando titulos a pagar do produtor" )
RunCPP( oProces1, cMesAno )

oProces1:IncRegua1( "Gerando titulos a pagar do Transportador" )
RunCPT( oProces1, cMesAno )

oProces1:IncRegua1( "Gerando titulos a pagar de Fornecedores" )
RunCPF( oProces1, cMesAno )

oProces1:IncRegua1( "Gerando Abatimentos do produtor" )
RunCRP( oProces1, cMesAno )

oProces1:IncRegua1( "Gerando Abatimentos do Transportador" )
RunCRT( oProces1, cMesAno )

oProces1:IncRegua1( "Gerando Movimento de Qualidade" )
RunQLT( oProces1, cMesAno )

oProces1:IncRegua1( "Ajustando arredondamentos" )
RunAdj( oProces1, cMesAno )

oProces1:IncRegua1( "Montando o relatorio do processo" )
PrcREL( oProces1, cMesAno )

If MV_PAR05 == 2

	If GETMV("ES_PERFECH",,.F.) //parametro verifica se atualiza ou nao estoque
		If MsgYesNo("Confirma o Encerramento do mes?","Confirma็ใo")
			oProces1:IncRegua1( "Efetivando os movimentos" )
        	GerProc( oProces1, cMesAno )
  		    lFim := .T.
  		Else
  			lFim := .F.
  		Endif
  	Else
  		ApMsgAlert("Fun็ใo desabilitada, verificar o parametro ES_PERFECH.","Atencao")
	Endif
Endif

Return nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RunNFE( oProces2, cMesAno )

Local cQuery		:= ""
Private nCount 		:= 0
Private nRec		:= 0

TCSQLExec("DROP VIEW RUNNFEF")

cQuery := "CREATE VIEW RUNNFEF AS SELECT PC0_FILIAL, PC0_NUMSEQ, PC0_DTENTR, PC0_TPENTR, PC0_LINROT, PC0_DESCRI, PC0_QTDAPO, PC0_QTDMED, PC0_QTDDIF, "
cQuery += "PC1_FILIAL, PC1_NUMSEQ, PC1_LINHA, PC1_QTDMED, PC1_CARSUB, PC1_CODPRO, PC1_QTDLIT, "
cQuery += "PC1_LINPRO, PC1_VLRLIT "
cQuery += "FROM "+RetSqlName("PC0")+" PC0 Inner join "+RetSqlName("PC1")+" PC1 ON "
cQuery += "PC1_FILIAL = PC0_FILIAL AND PC1_NUMSEQ = PC0_NUMSEQ "
cQuery += "Inner Join "+RetSqlName("PA7")+" PA7 on "
cQuery += "PA7_FILIAL = '" + xFilial("PA7") + "' and PA7_CODLIN = PC1_LINHA AND PA7.D_E_L_E_T_ = ' ' "
cQuery += "WHERE PC0_FILIAL = '" + xFilial("PC0") + "' "
cQuery += " AND (PC0_DTENTR >= '" + Right(cMesAno, 4) + left(cMesAno, 2) + "01' "
cQuery += " AND PC0_DTENTR <= '" + Right(cMesAno, 4) + left(cMesAno, 2) + StrZero(Day(LastDay(ctod("01/"+left(cMesAno,2)+"/"+Right(cMesAno,4)))),2)+ "') "
IF MV_PAR05 = 1
	cQuery += "AND PC1_CODPRO >= '" + MV_PAR03 + "' "
	cQuery += "AND PC1_CODPRO <= '" + MV_PAR04 + "' "
Endif
cQuery += " AND PC0.PC0_TPENTR = '1' "
cQuery += " AND PC0_QTDAPO > 0 "
cQuery += " AND PC0.D_E_L_E_T_ = ' ' "
cQuery += " AND PC1.D_E_L_E_T_ = ' ' "

TCSQLExec(cQuery)

memowrit("wm001.sql", cQuery)

cQuery := "SELECT PC0_DTENTR,PC1_CODPRO,SUM(PC1_QTDLIT)AS PC1_QTDLIT,AVG(PC1_VLRLIT) AS PC1_VLRLIT,PC1_LINHA"
cQuery += " FROM RUNNFEF GROUP BY PC0_DTENTR,PC1_CODPRO,PC1_LINHA ORDER BY CAST(PC1_LINHA AS INT),CAST(PC1_CODPRO AS INT),PC0_DTENTR"

cQuery := ChangeQuery( cQuery )

If Select("QRYNFE")>0
QRYNFE->(dbCloseArea())
End If

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYNFE', .F., .T.)

TcSetField( 'QRYNFE', "PC0_DTENTR", "D", 8, 0 )
TcSetField( 'QRYNFE', "PC1_QTDLIT", "N", 12, 2 )
TcSetField( 'QRYNFE', "PC1_VLRLIT", "N", 12, 4 )

aNotas 		:= {}

dbSelectArea("QRYNFE")
dbGotop()

While !Eof()
	nRec ++
	dbskip()
End While

dbGotop()

oProces2:IncRegua1( "Gerando notas fiscais de Entrada" )
oProces2:SetRegua2( nRec )

While QRYNFE->( !Eof() )

	oProces2:IncRegua2("CodPro: " + AllTrim(QRYNFE->PC1_CODPRO) + " - Reg: " + cValToChar(nCount) + " de :" + cValtoChar(nRec) )

	nCount ++

		aadd( aNotas, Array(7) )
		nPos := len(aNotas)
		aNotas[nPos, 1] := Alltrim( QRYNFE->PC1_CODPRO ) + Dtos( QRYNFE->PC0_DTENTR )
		aNotas[nPos, 2] := QRYNFE->PC1_CODPRO
		aNotas[nPos, 3] := QRYNFE->PC0_DTENTR
		aNotas[nPos, 4] := QRYNFE->PC1_QTDLIT
		aNotas[nPos, 6] := ( QRYNFE->PC1_VLRLIT * QRYNFE->PC1_QTDLIT )
		aNotas[nPos, 7] := QRYNFE->PC1_LINHA
		aNotas[nPos, 5] := QRYNFE->PC1_VLRLIT


//	RecLock("ZZZ",.T.)
//	ZZZ->ZZZ_CONTRA := aNotas[nPos, 1]
//	ZZZ->ZZZ_PRE1 := aNotas[nPos, 2]
//	ZZZ->ZZZ_PRE2 := cvaltochar(aNotas[nPos, 3])
//	ZZZ->ZZZ_PRE3 := cvaltochar(aNotas[nPos, 4])
//	ZZZ->ZZZ_PRE4 := cvaltochar(aNotas[nPos, 5])
//	ZZZ->ZZZ_PRE5 := cvaltochar(aNotas[nPos, 6])
//	ZZZ->ZZZ_PRE6 := aNotas[nPos, 7]
//	MsUnlock()


	QRYNFE->(dbSkip())

End

dbSelectArea("QRYNFE")
dbCloseArea()

Return nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RunNFS( oProces2, cMesAno )

Local cQuery := ""

oProces2:SetRegua2( 0 )

// BUSCAR AS LINHAS

cQuery := "select PC0_TPENTR ,PC0_NUMSEQ, PC1_NUMSEQ, Max(PC0_QTDAPO) AS PC0_APONT, max(PC0_QTDMED) AS PC0_MEDIDO, "
cQuery += "max(PC1_QTDMED) AS PC1_MEDIDO, SUM(PC1_QTDLIT	) AS PC1_INFORM, AVG(PC1_VLRLIT) AS PC1_VLRMED, PC1_LINHA, PC1_CARSUB "
cQuery += "FROM " + RetSqlName( "PC0" ) + " PC0, " + RetSqlName( "PC1" ) + " PC1 "
cQuery += "WHERE PC1_NUMSEQ = PC0_NUMSEQ "
cQuery += " AND PC1_FILIAL = PC0_FILIAL "
cQuery += " AND PC0_FILIAL = '"+xFilial("PC0")+"' "
cQuery += " AND (PC0_DTENTR >= '"+dTOS(MV_PAR01)+"' "
cQuery += " AND PC0_DTENTR <= '"+dTos(MV_PAR02)+"') "
cQuery += " AND PC0_TPENTR = '1' "
cQuery += " AND PC0_QTDAPO > 0 "
cQuery += " AND PC0.D_E_L_E_T_ = ' ' "
cQuery += " AND PC1.D_E_L_E_T_ = ' ' "
cQuery += "Group by PC0_NUMSEQ,PC0_TPENTR , PC1_NUMSEQ,PC1_LINHA, PC1_CARSUB "
cQuery += "ORDER BY PC0_NUMSEQ,PC0_TPENTR ,PC1_NUMSEQ,PC1_LINHA, PC1_CARSUB  "

MEMOWRITE("C:\EDI\ABAT.SQL",cQuery)
cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYNFS', .F., .T.)

TcSetField( 'QRYNFS', "PC1_MEDIDO", "N", 12, 2 )
TcSetField( 'QRYNFS', "PC1_VLRMED", "N", 12, 4 )
TcSetField( 'QRYNFS', "PC1_INFORM", "N", 12, 2 )

aPedidos 		:= {}

dbSelectArea("QRYNFS")
dbGotop()

nCount 	:= 0
nRec	:= 0
While !Eof()
	nRec ++
	dbskip()
End While

dbGotop()

oProces2:IncRegua1( "Gerando Notas de Saํda-LINHAS" )
oProces2:SetRegua2( nRec )
//oProces2:IncRegua2( "Registro.: "+cValToChar(nCount)+" De: "+cValtochar(nRec)  )
//nCount ++

While !Eof()

	oProces2:IncRegua2( "Registro.: "+cValToChar(nCount)+" De: "+cValtochar(nRec)  )
	nCount ++

	dbSelectArea("PA7")
	dbSetOrder(1)
	dbSeek( xFilial("PA7") + QRYNFS->PC1_LINHA )
	cCodBus := PA7->PA7_CODCAR
	If !Empty(QRYNFS->PC1_CARSUB)
		cCodBus := QRYNFS->PC1_CARSUB
	Endif
	nPos := asCan(aPedidos, { |x| Alltrim(Upper(x[1])) == Alltrim(Upper( cCodBus ) ) } )
	If  nPos == 0
		aadd( aPedidos, Array(6) )
		nPos := len(aPedidos)
		aPedidos[nPos, 1] := cCodBus
		aPedidos[nPos, 2] := cCodBus
		aPedidos[nPos, 3] := 0
		aPedidos[nPos, 4] := QRYNFS->PC1_INFORM - QRYNFS->PC1_MEDIDO
		aPedidos[nPos, 5] := QRYNFS->PC1_VLRMED
		aPedidos[nPos, 6] := ( aPedidos[nPos, 5] * aPedidos[nPos, 4] )
	Else
		aPedidos[nPos][4] += QRYNFS->PC1_INFORM - QRYNFS->PC1_MEDIDO
		aPedidos[nPos][6] += ( QRYNFS->PC1_VLRMED * ( QRYNFS->PC1_INFORM - QRYNFS->PC1_MEDIDO ) )
		aPedidos[nPos][5] := aPedidos[nPos][6] / aPedidos[nPos][4] // valor medio do litro de leite
	Endif

	QRYNFS->(dbSkip())
End
dbSelectArea("QRYNFS")
dbCloseArea()

// BUSCAR AS ROTAS

cQuery := "select PC0_TPENTR ,PC0_NUMSEQ, PC2_NUMSEQ, Max(PC0_QTDAPO) AS PC0_APONT, max(PC0_QTDMED) AS PC0_MEDIDO, "
cQuery += "max(PC2_QTDMED) AS PC2_MEDIDO, SUM(PC2_QTDLIT) AS PC2_INFORM, AVG(PC2_VLRLIT) AS PC2_VLRMED, PC2_ROTA, PC2_CARSUB "
cQuery += "FROM " + RetSqlName( "PC0" ) + " PC0, " + RetSqlName( "PC2" ) + " PC2 "
cQuery += "WHERE PC2_NUMSEQ = PC0_NUMSEQ "
cQuery += " AND PC2_FILIAL = PC0_FILIAL "
cQuery += " AND PC0_FILIAL = '"+xFilial("PC0")+"' "
cQuery += " AND (PC0_DTENTR >= '"+dTOS(MV_PAR01)+"' "
cQuery += " AND PC0_DTENTR <= '"+dTos(MV_PAR02)+"') "
cQuery += " AND PC0_TPENTR = '2' "
cQuery += " AND PC0_QTDAPO > 0 "
cQuery += " AND PC0.D_E_L_E_T_ = ' ' "
cQuery += " AND PC2.D_E_L_E_T_ = ' ' "
cQuery += "Group by PC0_NUMSEQ,PC0_TPENTR , PC2_NUMSEQ,PC2_ROTA, PC2_CARSUB "
cQuery += "ORDER BY PC0_NUMSEQ,PC0_TPENTR ,PC2_NUMSEQ,PC2_ROTA, PC2_CARSUB  "

cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYNFS', .F., .T.)

TcSetField( 'QRYNFS', "PC2_MEDIDO", "N", 12, 2 )
TcSetField( 'QRYNFS', "PC2_VLRMED", "N", 12, 4 )
TcSetField( 'QRYNFS', "PC2_INFORM", "N", 12, 2 )

dbSelectArea("QRYNFS")
dbGotop()

nCount 	:= 0
nRec	:= 0
While !Eof()
	nRec ++
	dbskip()
End While

dbGotop()

oProces2:IncRegua1( "Gerando Notas de Saํda-ROTAS" )
oProces2:SetRegua2( nRec )

While !Eof()

	oProces2:IncRegua2( "Registro.: "+cValToChar(nCount)+" De: "+cValtochar(nRec)  )
	nCount ++

	dbSelectArea("LBC")
	dbSetOrder(1)
	dbSeek( xFilial("LBC") + QRYNFS->PC2_ROTA )
	cCodBus := LBC->LBC_CODCAM
	If !Empty(QRYNFS->PC2_CARSUB)
		cCodBus := QRYNFS->PC2_CARSUB
	Endif
	nPos := asCan(aPedidos, { |x| Alltrim(Upper(x[1])) == Alltrim(Upper( cCodBus )) } )
	If  nPos == 0
		aadd( aPedidos, Array(6) )
		nPos := len(aPedidos)
		aPedidos[nPos, 1] := cCodBus
		aPedidos[nPos, 2] := cCodBus
		aPedidos[nPos, 3] := 0
		aPedidos[nPos, 4] := QRYNFS->PC2_INFORM - QRYNFS->PC2_MEDIDO
		aPedidos[nPos, 5] := QRYNFS->PC2_VLRMED
		aPedidos[nPos, 6] := ( aPedidos[nPos, 5] * aPedidos[nPos, 4] )
	Else
		aPedidos[nPos][4] += QRYNFS->PC2_INFORM - QRYNFS->PC2_MEDIDO
		aPedidos[nPos][6] += ( QRYNFS->PC2_VLRMED * ( QRYNFS->PC2_INFORM - QRYNFS->PC2_MEDIDO ) )
		aPedidos[nPos][5] := aPedidos[nPos][6] / aPedidos[nPos][4]// valor medio do litro de leite
	Endif

	QRYNFS->(dbSkip())
End
dbSelectArea("QRYNFS")
dbCloseArea()

Return nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RunCPP( oProces2, cMesAno )

Local nXa	:= 0
Local nPos	:= 0

oProces2:IncRegua1( "Gerando Titulos Pagar Produtor" )
oProces2:SetRegua2( len(aNotas) )

nRec := len(aNotas)
nCount :=0

For nXa := 1 to Len(aNotas)


	oProces2:IncRegua2( "Registro.: "+cValToChar(nCount)+" De: "+cValtochar(nRec))
	nCount ++

	nPos := ascan( aPagar, { |x| Alltrim(Upper(x[1])) == Alltrim(Upper("P"+aNotas[nXa][2])) } )
	If nPos == 0
		aadd( aPagar, Array(6) )
		nPos := len(aPagar)
		aPagar[nPos, 1] := "P"+aNotas[nXa][2] 	// codigo Propriedade
		aPagar[nPos, 2] := aNotas[nXa][2]		// codigo propriedade
		aPagar[nPos, 3] := aNotas[nXa][3]       // Data Entrada
		aPagar[nPos, 4] := aNotas[nXa][4]       // Litros
		aPagar[nPos, 5] := ( aNotas[nXa][6] / aNotas[nXa][4] )	//valor litro
		aPagar[nPos, 6] := aNotas[nXa][6]       // Total
	Else
		aPagar[nPos, 4] += aNotas[nXa][4]
		aPagar[nPos, 6] += aNotas[nXa][6]
		aPagar[nPos, 5] := ( aNotas[nXa][6] / aNotas[nXa][4] )
	Endif

next nXa

Return nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RunCPT( oProces2, cMesAno )

Local nXa	:= 0
Local nPos	:= 0
Local cQuery := ""


// BUSCAR AS LINHAS

cQuery := "SELECT DISTINCT PC0_TPENTR, PC0_NUMSEQ, PC1_LINHA, PA7.PA7_CODCAR, LBE.LBE_TPFRET AS PC1_FRETE, PC1_CARSUB, "
cQuery += "LBEA.LBE_TPFRET AS PC1_FRTSUB, LBE.LBE_PERC1 AS PC1_VLFRT, LBEA.LBE_PERC1 AS PC1_VLFSUB, AVG(PA7_QTDKM) PA7_QTDKM, "
cQuery += "AVG(PC1_VLRLIT) AS PC1_VLRMED, Max(PC1_QTDMED) AS PC1_MEDIDO, SUM(PC1_QTDLIT) AS PC1_INFORM "
cQuery += "FROM " + RetSqlName( "PC0" ) + " PC0 Inner Join " + RetSqlName( "PC1" ) + " PC1 ON "
cQuery += "PC1_FILIAL = PC0_FILIAL  AND PC1_NUMSEQ = PC0_NUMSEQ  AND PC1.D_E_L_E_T_ = ' ' "
cQuery += "Inner Join " + RetSqlName( "PA7" ) + " PA7 ON "
cQuery += "PA7_FILIAL = '" + xFilial("PA7") +"' AND PA7.PA7_CODLIN = PC1_LINHA  AND PA7.D_E_L_E_T_ = ' '  "
cQuery += "Left Outer Join " + RetSqlName( "LBE" ) + " LBE ON "
cQuery += "LBE.LBE_FILIAL = '"+xFilial("LBE")+"'  AND LBE.LBE_CODCAM = PA7.PA7_CODCAR  AND LBE.D_E_L_E_T_ = ' '  ""
cQuery += " Left Outer Join "  + RetSqlName( "LBE" ) + " LBEA  ON "
cQuery += "LBEA.LBE_FILIAL = '"+xFilial("LBE")+"'  AND LBEA.LBE_CODCAM = PC1.PC1_CARSUB  AND LBEA.D_E_L_E_T_ = ' '  "
cQuery += "WHERE PC0_FILIAL = '"+xFilial("PC0")+"'  "
cQuery += "AND (PC0_DTENTR >= '"+dTOS(MV_PAR01)+"'  "
cQuery += "AND PC0_DTENTR <= '"+dTos(MV_PAR02)+"')  "
cQuery += "AND PC0_TPENTR = '1'  "
IF MV_PAR05 = 1
	cQuery += "AND PC1_CODPRO >= '" + MV_PAR03 + "' "
	cQuery += "AND PC1_CODPRO <= '" + MV_PAR04 + "' "
Endif
cQuery += "AND PC0_QTDAPO > 0 "
cQuery += "AND PC0.D_E_L_E_T_ = ' '  "
cQuery += "Group BY PC0_TPENTR, PC0_NUMSEQ, PC1_LINHA,PA7.PA7_CODCAR, LBE.LBE_TPFRET, PC1_CARSUB, "
cQuery += "LBEA.LBE_TPFRET, LBE.LBE_PERC1, LBEA.LBE_PERC1 "
cQuery += "ORDER BY PC1_LINHA, PA7_CODCAR  "

cQuery := ChangeQuery( cQuery )

memowrit("C:\EDI\RUNCPP.SQL", cQuery)

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYNFS', .F., .T.)

TcSetField( 'QRYNFS', "PC1_INFORM", "N", 12, 2 )
TcSetField( 'QRYNFS', "PC1_VLRMED", "N", 12, 4 )
TcSetField( 'QRYNFS', "PC1_MEDIDO", "N", 12, 2 )
TcSetField( 'QRYNFS', "PC1_VLFRT",  "N", 12, 2 )
TcSetField( 'QRYNFS', "PC1_VLFSUB", "N", 12, 2 )
TcSetField( 'QRYNFS', "PA7_QTDKM",  "N", 12, 2 )

dbSelectArea("QRYNFS")
dbGotop()

nCount 	:= 0
nRec	:= 0
While !Eof()
	nRec ++
	dbskip()
End While

dbGotop()

oProces2:IncRegua1( "Gerando Titulos a Pagar Transportador" )
oProces2:SetRegua2( nRec )

While !Eof()

	oProces2:IncRegua2( "Registro.: "+cValToChar(nCount)+" De: "+cValtochar(nRec))
	nCount ++

	cCodBus := "C" + QRYNFS->PA7_CODCAR
	cMyCod	:= QRYNFS->PA7_CODCAR
	cTipoFrt:= QRYNFS->PC1_FRETE
	nValUni	:= QRYNFS->PC1_VLRMED
	nQtdLts	:= QRYNFS->PC1_INFORM
	nQtdKms	:= QRYNFS->PA7_QTDKM
	nVlFret	:= QRYNFS->PC1_VLFRT
	If !Empty(QRYNFS->PC1_CARSUB)
		cCodBus := "C"+QRYNFS->PC1_CARSUB
		cMyCod	:= QRYNFS->PC1_CARSUB
		cTipoFrt:= QRYNFS->PC1_FRTSUB
		nValUni	:= QRYNFS->PC1_VLRMED
		nQtdLts	:= QRYNFS->PC1_INFORM
		nQtdKms	:= QRYNFS->PA7_QTDKM
		nVlFret	:= QRYNFS->PC1_VLFSUB
	Endif
	//Analisa tipo do Frete
	Do Case
		Case cTipoFrt == "1" // valor por litro
			nValor := nQtdLts * nVlFret
		Case cTipoFrt == "2" // Fixo mensal
			nValor := nVlFret
		Otherwise // por Km Rodado
			nValor := nVlFret * nQtdKms
	Endcase

	If nValor > 0

		nPos := asCan(aPagar, { |x| Alltrim(Upper(x[1])) == Alltrim(Upper( cCodBus ) ) } )

		If  nPos == 0
			aadd( aPagar, Array(6) )
			nPos := len(aPagar)
			aPagar[nPos, 1] := cCodBus
			aPagar[nPos, 2] := cMyCod
			aPagar[nPos, 3] := nQtdKms
			aPagar[nPos, 4] := nQtdLts
			aPagar[nPos, 6] := nValor
			aPagar[nPos, 5] := aPagar[nPos, 6] / aPagar[nPos, 4]
		Else
			If cTipoFrt <> "2"
				aPagar[nPos, 3] += nQtdKms
				aPagar[nPos, 4] += nQtdLts
				aPagar[nPos, 6] += nValor
				aPagar[nPos, 5] := aPagar[nPos, 6] / aPagar[nPos, 4]
			else
				aPagar[nPos, 3] += nQtdKms
				aPagar[nPos, 4] += nQtdLts
				aPagar[nPos, 5] := aPagar[nPos, 6] / aPagar[nPos, 4]
			Endif
		Endif
	Endif


	QRYNFS->(dbSkip())
End
dbSelectArea("QRYNFS")
dbCloseArea()


cQuery := "SELECT DISTINCT PC0_TPENTR, PC1_LINHA, PC1_CODPRO, PA7.PA7_CODCAR, PC1_CARSUB "
cQuery += "FROM " + RetSqlName( "PC0" ) + " PC0 Inner Join " + RetSqlName( "PC1" ) + " PC1 ON "
cQuery += "PC1_FILIAL = PC0_FILIAL  AND PC1_NUMSEQ = PC0_NUMSEQ  AND PC1.D_E_L_E_T_ = ' ' "
cQuery += "Inner Join " + RetSqlName( "PA7" ) + " PA7 ON "
cQuery += "PA7_FILIAL = '" + xFilial("PA7") +"' AND PA7.PA7_CODLIN = PC1_LINHA  AND PA7.D_E_L_E_T_ = ' '  "
cQuery += "WHERE PC0_FILIAL = '"+xFilial("PC0")+"'  "
cQuery += "AND (PC0_DTENTR >= '"+dTOS(MV_PAR01)+"'  "
cQuery += "AND PC0_DTENTR <= '"+dTos(MV_PAR02)+"')  "
cQuery += "AND PC0_TPENTR = '1'  "
IF MV_PAR05 = 1
	cQuery += "AND PC1_CODPRO >= '" + MV_PAR03 + "' "
	cQuery += "AND PC1_CODPRO <= '" + MV_PAR04 + "' "
Endif
cQuery += "AND PC0_QTDAPO > 0 "
cQuery += "AND PC0.D_E_L_E_T_ = ' '  "
cQuery += "Group BY PC0_TPENTR, PC1_LINHA, PC1_CODPRO, PA7_CODCAR, PC1_CARSUB "
cQuery += "ORDER BY PC1_LINHA, PC1_CODPRO, PA7_CODCAR, PC1_CARSUB "

cQuery := ChangeQuery( cQuery )

memowrit("WM005a.sql", cQuery)

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYNFS', .F., .T.)

dbSelectArea("QRYNFS")
dbGotop()

While !Eof()
	cMyCod	:= QRYNFS->PA7_CODCAR
	If !Empty(QRYNFS->PC1_CARSUB)
		cMyCod	:= QRYNFS->PC1_CARSUB
    Endif

	nPos := Ascan(aFrete, {|x| Alltrim(upper(x[1])) == alltrim(Upper(QRYNFS->PC1_CODPRO)) } )

	If nPos == 0
		aadd(aFrete, {QRYNFS->PC1_CODPRO, {}, 0 })
		nPos := Len(aFrete)
	Endif

	aadd(aFrete[nPos][2], cMyCod)
	QRYNFS->(dbSkip())
End

dbSelectArea("QRYNFS")
dbCloseArea()


// BUSCAR AS ROTAS

cQuery := "SELECT DISTINCT PC0_TPENTR, PC0_NUMSEQ, PC2_ROTA, LBC.LBC_CODCAM, LBE.LBE_TPFRE2 AS PC2_FRETE, PC2_CARSUB, "
cQuery += "LBEA.LBE_TPFRE2 AS PC2_FRTSUB, LBE.LBE_PERC2 AS PC2_VLFRT, LBEA.LBE_PERC2 AS PC2_VLFSUB, avg(LBC_TTKMRT) LBC_TTKMRT,  "
cQuery += "AVG(PC2_VLRLIT) AS PC2_VLRMED, Max(PC2_QTDMED) AS PC2_MEDIDO, SUM(PC2_QTDLIT) AS PC2_INFORM "
cQuery += "FROM " + RetSqlName( "PC0" ) + " PC0 Inner Join " + RetSqlName( "PC2" ) + " PC2 ON "
cQuery += "PC2_FILIAL = PC0_FILIAL AND PC2_NUMSEQ = PC0_NUMSEQ AND PC2.D_E_L_E_T_ = ' ' "
cQuery += "INNER JOIN " + RetSqlName( "LBC" ) + " LBC ON "
cQuery += "LBC.LBC_FILIAL = '"+xFilial("LBC")+"' AND LBC.LBC_CODROT = PC2_ROTA AND LBC.D_E_L_E_T_ = ' ' "
cQuery += "LEFT OUTER JOIN "  + RetSqlName( "LBE" ) + " LBE ON "
cQuery += "LBE.LBE_FILIAL = '"+xFilial("LBE")+"' AND LBE.LBE_CODCAM = LBC.LBC_CODCAM AND LBE.D_E_L_E_T_ = ' ' "
cQuery += "LEFT OUTER Join " + RetSqlName( "LBE" ) + " LBEA ON "
cQuery += "LBEA.LBE_FILIAL = '"+xFilial("LBE")+"' AND LBEA.LBE_CODCAM = PC2.PC2_CARSUB AND LBEA.D_E_L_E_T_ = ' ' "
cQuery += "WHERE PC0_FILIAL = '"+xFilial("PC0")+"'  "
cQuery += "AND (PC0_DTENTR >= '"+dTOS(MV_PAR01)+"'  "
cQuery += "AND PC0_DTENTR <= '"+dTos(MV_PAR02)+"')  "
cQuery += "AND PC0_TPENTR = '2'  "
cQuery += "AND PC0_QTDAPO > 0 "
cQuery += "AND PC0.D_E_L_E_T_ = ' '  "
cQuery += "Group BY PC0_TPENTR, PC0_NUMSEQ, PC2_ROTA,LBC.LBC_CODCAM, LBE.LBE_TPFRE2, PC2_CARSUB, "
cQuery += "LBEA.LBE_TPFRE2, LBE.LBE_PERC2, LBEA.LBE_PERC2 "
cQuery += "ORDER BY PC2_ROTA "


cQuery := ChangeQuery( cQuery )

memowrite("c:\WM006.sql", cQuery)

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYNFS', .F., .T.)

TcSetField( 'QRYNFS', "PC2_INFORM", "N", 12, 2 )
TcSetField( 'QRYNFS', "PC2_VLRMED", "N", 12, 4 )
TcSetField( 'QRYNFS', "PC2_MEDIDO", "N", 12, 2 )
TcSetField( 'QRYNFS', "PC2_VLFRT",  "N", 12, 2 )
TcSetField( 'QRYNFS', "PC2_VLFSUB", "N", 12, 2 )
TcSetField( 'QRYNFS', "LBC_TTKMRT", "N", 12, 2 )

dbSelectArea("QRYNFS")
dbGotop()

_nTotalKms := 0
_nTotalLts := 0
_nTotalfrt := 0

While !Eof()

	cCodBus := "C" + QRYNFS->LBC_CODCAM
	cMyCod	:= QRYNFS->LBC_CODCAM
	cTipoFrt:= QRYNFS->PC2_FRETE
	nValUni	:= QRYNFS->PC2_VLRMED
	nQtdLts	:= QRYNFS->PC2_INFORM
	nQtdKms	:= QRYNFS->LBC_TTKMRT
	nVlFret	:= QRYNFS->PC2_VLFRT
	If !Empty(QRYNFS->PC2_CARSUB)
		cCodBus := "C"+QRYNFS->PC2_CARSUB
		cMyCod	:= QRYNFS->PC2_CARSUB
		cTipoFrt:= QRYNFS->PC2_FRTSUB
		nValUni	:= QRYNFS->PC2_VLRMED
		nQtdLts	:= QRYNFS->PC2_INFORM
		nQtdKms	:= QRYNFS->LBC_TTKMRT
		nVlFret	:= QRYNFS->PC2_VLFSUB
	Endif
	//Analisa tipo do Frete
	Do Case
		Case cTipoFrt == "1" // valor por litro
			nValor := nQtdLts * nVlFret
		Case cTipoFrt == "2" // Fixo mensal
			nValor := nVlFret
		Otherwise // por Km Rodado
			nValor := nVlFret * nQtdKms
	Endcase


	If nValor > 0
		nPos := asCan(aPagar, { |x| Alltrim(Upper(x[1])) == Alltrim(Upper( cCodBus )) } )

		If  nPos == 0
			aadd( aPagar, Array(6) )
			nPos := len(aPagar)
			aPagar[nPos, 1] := cCodBus
			aPagar[nPos, 2] := cMyCod
			aPagar[nPos, 3] := nQtdKms
			aPagar[nPos, 4] := nQtdLts
			aPagar[nPos, 6] := nValor
			aPagar[nPos, 5] := aPagar[nPos, 6] / aPagar[nPos, 4]
		Else
			If cTipoFrt <> "2"
				aPagar[nPos, 3] += nQtdKms
				aPagar[nPos, 4] += nQtdLts
				aPagar[nPos, 6] += nValor
				aPagar[nPos, 5] := aPagar[nPos, 6] / aPagar[nPos, 4]
			Else
				aPagar[nPos, 3] += nQtdKms
				aPagar[nPos, 4] += nQtdLts
				aPagar[nPos, 5] := aPagar[nPos, 6] / aPagar[nPos, 4]
				nValor := 0
			Endif
		Endif
		_nTotalKms += nQtdKms
		_nTotalLts += nQtdLts
		_nTotalfrt += nValor
	Endif


	QRYNFS->(dbSkip())
End

nTTSegund := _nTotalfrt / _nTotalLts
For nXa := 1 to Len(aFrete)
	aFrete[nXa][3] := nTTSegund
next nXA

dbSelectArea("QRYNFS")
dbCloseArea()

Return nil




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RunCPF( oProces2, cMesAno )

Local cQuery := ""

cQuery := "SELECT PA5_FORNEC, PA5_LOJA, PA5_TIPDES, PA5_PERIOD, PA5_VENCTO, PA5_VALOR, PA5_DOC, "
cQuery += "PA6_SEQ, PA6_CODPRO, PA6_VALOR, PA6_DOC, PA6_OBSERV "
cQuery += "FROM "+RetSqlName("PA5")+" PA5 INNER JOIN "+RetSqlName("PA6")+" PA6 ON "
cQuery += "PA6_FILIAL = PA5_FILIAL AND PA6_FORNEC = PA5_FORNEC "
cQuery += "AND PA6_LOJA = PA5_LOJA AND PA6_PERIOD = PA5_PERIOD AND PA6_TIPDES = PA5_TIPDES "
//cQuery += "AND PA6_LOJA = PA5_LOJA AND PA6_PERIOD = PA5_PERIOD "
cQuery += "WHERE PA5_PERIOD = '" + Alltrim(cMesAno) + "' "
cQuery += "AND PA5.PA5_FILIAL = '"+xFilial("PA5")+"' "
cQuery += "AND PA6.PA6_FILIAL = '"+xFilial("PA6")+"' "
cQuery += "AND PA5.D_E_L_E_T_ = ' ' "
cQuery += "AND PA6.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY PA5_FORNEC, PA5_LOJA, PA5_PERIOD, PA6_SEQ, PA6_CODPRO, PA5_TIPDES "

cQuery := ChangeQuery( cQuery )

memowrit("WM007.sql", cQuery)

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYNFS', .F., .T.)

TcSetField( 'QRYNFS', "PA5_VENCTO", "D", 8, 0 )
TcSetField( 'QRYNFS', "PA5_VALOR", "N", 12, 2 )
TcSetField( 'QRYNFS', "PA6_VALOR", "N", 12, 2 )

oProces2:SetRegua2( 0 )

dbSelectArea("QRYNFS")
dbGotop()


nCount 	:= 0
nRec	:= 0

While !Eof()
	nRec ++
	dbskip()
End While

dbGotop()


oProces2:IncRegua1( "Gerando Titulos a pagar Fornecedores" )
oProces2:SetRegua2( nRec )
//oProces2:IncRegua2( "Registro.: "+cValToChar(nCount)+" De: "+cValtochar(nRec)  )
//nCount ++



While !Eof()

	oProces2:IncRegua2( "Registro.: "+cValToChar(nCount)+" De: "+cValtochar(nRec)  )
	nCount ++

	cMyCod := QRYNFS->(PA5_FORNEC+PA5_LOJA)
	cCodBus := "F" + cMyCod
	nPos := asCan(aPagar, { |x| Alltrim(Upper(x[1])) == Alltrim(Upper( cCodBus ) ) } )
	If  nPos == 0
		aadd( aPagar, Array(6) )
		nPos := len(aPagar)
		aPagar[nPos, 1] := cCodBus
		aPagar[nPos, 2] := cMyCod
		aPagar[nPos, 3] := QRYNFS->PA5_VENCTO
		aPagar[nPos, 4] := 1
		aPagar[nPos, 5] := 0
		aPagar[nPos, 6] := QRYNFS->PA6_VALOR
	Else
		aPagar[nPos][4] += 1
		aPagar[nPos][6] +=  QRYNFS->PA6_VALOR
		aPagar[nPos][5] := 0
	Endif

	QRYNFS->(dbSkip())
End
dbSelectArea("QRYNFS")
dbCloseArea()

Return nil



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RunCRP( oProces2, cMesAno )

Local cQuery := ""

cQuery := "SELECT PA5_FORNEC, PA5_LOJA, PA5_TIPDES, PA5_PERIOD, PA5_VENCTO, PA5_VALOR, PA5_DOC, "
cQuery += "PA6_SEQ, PA6_CODPRO, PA6_VALOR, PA6_DOC, PA6_OBSERV, PA6_TIPDES "
cQuery += "FROM "+RetSqlName("PA5")+" PA5 INNER JOIN "+RetSqlName("PA6")+" PA6 ON "
cQuery += "PA6_FILIAL = PA5_FILIAL AND PA6_FORNEC = PA5_FORNEC "
cQuery += "AND PA6_LOJA = PA5_LOJA AND PA6_PERIOD = PA5_PERIOD AND PA6_TIPDES = PA5_TIPDES "
cQuery += "WHERE PA5_PERIOD = '" + Alltrim(cMesAno) + "' "
cQuery += "AND PA5.PA5_FILIAL = '"+xFilial("PA5")+"' "
cQuery += "AND PA6.PA6_FILIAL = '"+xFilial("PA6")+"' "
cQuery += "AND PA5.D_E_L_E_T_ = ' ' "
cQuery += "AND PA6.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY PA6_CODPRO, PA5_PERIOD, PA5_TIPDES "

cQuery := ChangeQuery( cQuery )

memowrite("WM008.sql", cQuery)

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYNFS', .F., .T.)

TcSetField( 'QRYNFS', "PA5_VENCTO", "D", 8, 0 )
TcSetField( 'QRYNFS', "PA5_VALOR", "N", 14, 2 )
TcSetField( 'QRYNFS', "PA6_VALOR", "N", 14, 2 )


oProces2:SetRegua2( 0 )

dbSelectArea("QRYNFS")
dbGotop()


nCount 	:= 0
nRec	:= 0

While !Eof()
	nRec ++
	dbskip()
End While

dbGotop()


oProces2:IncRegua1( "Gerando Abatimentos do produtor" )
oProces2:SetRegua2( nRec )
//oProces2:IncRegua2( "Registro.: "+cValToChar(nCount)+" De: "+cValtochar(nRec)  )
//nCount ++

While !Eof()

	oProces2:IncRegua2( "Registro.: "+cValToChar(nCount)+" De: "+cValtochar(nRec)  )

    nCount ++
    lAdto := .F.

    If cFilAnt == '02' .and. (QRYNFS->PA6_TIPDES == '001' .or. QRYNFS->PA6_TIPDES == '009')
        lAdto := .T.
    ElseIf cFilAnt == '03' .and. QRYNFS->PA6_TIPDES == '034'
        lAdto := .T.
    ElseIf cFilAnt == '04' .and. (QRYNFS->PA6_TIPDES == '006' .or. QRYNFS->PA6_TIPDES == '009')
        lAdto := .T.
    ElseIf cFilAnt == '05' .and. (QRYNFS->PA6_TIPDES == '001' .or. QRYNFS->PA6_TIPDES == '002')
        lAdto := .T.
    ElseIf cFilAnt == '08' .and. (QRYNFS->PA6_TIPDES == '001')
        lAdto := .T.
    ElseIf cFilAnt == '09' .and. (QRYNFS->PA6_TIPDES == '001')
        lAdto := .T.
    ElseIf cFilAnt == '10' .and. (QRYNFS->PA6_TIPDES == '001')
        lAdto := .T.
    End If

	cMyCod := QRYNFS->(PA6_CODPRO)
	cCodBus := "F" + cMyCod
	nPos := asCan(aAbat, { |x| Alltrim(Upper(x[1])) == Alltrim(Upper( cCodBus )) } )

	If  nPos == 0
		aadd( aAbat, Array(7) )
		nPos := len(aAbat)
		aAbat[nPos, 1] := cCodBus
		aAbat[nPos, 2] := cMyCod
		aAbat[nPos, 3] := QRYNFS->PA5_VENCTO
		aAbat[nPos, 4] := 1
		aAbat[nPos, 5] := 0
		aAbat[nPos, 6] := QRYNFS->PA6_VALOR
        If lAdto
            aAbat[nPos, 7] := QRYNFS->PA6_VALOR
        Else
            aAbat[nPos, 7] := 0
        EndIf
    Else
		aAbat[nPos][4] += 1
		aAbat[nPos][6] +=  QRYNFS->PA6_VALOR
		aAbat[nPos][5] := 0
        If lAdto
            aAbat[nPos][7] += QRYNFS->PA6_VALOR
        Else
            aAbat[nPos][7] += 0
        EndIf
    Endif

	QRYNFS->(dbSkip())
End

dbSelectArea("QRYNFS")
dbCloseArea()

Return nil





/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RunCRT( oProces2, cMesAno )
Local nXa	:= 0
Local nPos	:= 0

/*
Gerar pedidos de vendas liberados
gerar titulos financeiros de abatimento (AB-)
faturar normalmente na rotina de faturamento
*/

oProces2:SetRegua2( 0 )

nCount 	:= 0
nRec	:= 0

nRec := len(aPedidos)

oProces2:IncRegua1( "Gerando Abatimentos do Transportador" )
oProces2:SetRegua2( nRec )


For nXa := 1 to Len(aPedidos)

	oProces2:IncRegua2( "Registro.: "+cValToChar(nXa)+" De: "+cValtochar(nRec)  )

	IF aPedidos[nXa][4] > 0
		nPos := ascan( aAbat, { |x| Alltrim(Upper(x[1])) == "C"+Alltrim(Upper(aPedidos[nXa][2])) } )
		If nPos == 0
			aadd( aAbat, Array(7) )
			nPos := len(aAbat)
			aAbat[nPos, 1] := "C"+aPedidos[nXa][2]
			aAbat[nPos, 2] := aPedidos[nXa][2]
			aAbat[nPos, 3] := aPedidos[nXa][3]
			aAbat[nPos, 4] := aPedidos[nXa][4]
			aAbat[nPos, 6] := aPedidos[nXa][6]
			aAbat[nPos, 5] := aPedidos[nXa][6] / aPedidos[nXa][4]
		Else
			aAbat[nPos, 4] += aPedidos[nXa][4]
			aAbat[nPos, 6] += aPedidos[nXa][6]
			aAbat[nPos, 5] += aPedidos[nXa][6] / aPedidos[nXa][4]
		Endif
	Endif
next nXa

Return nil




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RunQLT( oProces2, cMesAno )

Local nXa		:= 0
Local nPosx		:= 0
Local aTemp 	:= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
Local nPosy		:= 0
Local aPropr 	:= {}
Local nFrete	:= 0


nCount 	:= 0
nRec	:= len(aNotas)

oProces2:SetRegua2( nRec )
oProces2:IncRegua1( OemToansi("Gerando Movimentos de Qualidade" ) )

aItens := {}

For nXa := 1 to Len(aNotas)+len(aItens)

	oProces2:IncRegua2( "Registro.: "+cValToChar(nXa)+" De: "+cValtochar(nRec)  )

	nPosx := ascan( aItens, { |x| Alltrim(Upper(x[11])) == Alltrim(Upper(aNotas[nXa][2])) } )
	If nPosx == 0  // nICMS, nFrete, nIncent, nFunrural, nST, nFundese
		aadd( aItens, { aClone(aTemp), 0, 0, 0, 0, 0, 0, 0, 0, 0, "", 0, Array(10), "" }  )
		aPropr := {}
		nPosx := len(aItens)
		aPropr := RetImppr(aNotas[nXa][2])			// Recuperar impostos e taxas
		aItens[nPosx][11] 	:= aNotas[nXa][2]       // Codigo da propriedade
		aItens[nPosx][5] 	:= aPropr[1]			// ICMS
		aItens[nPosx][6] 	:= Round(aPropr[2], 11)  // Frete 1
		aItens[nPosx][7] 	:= aPropr[3]         	// Incentivo
		aItens[nPosx][8] 	:= aPropr[4]         	// Funrural
		aItens[nPosx][9] 	:= aPropr[5]         	// nST
		aItens[nPosx][10] 	:= aPropr[6]         	// Fundese
		aItens[nPosx][12] 	:= Round(aPropr[7], 11)  // Frete 2
		aItens[nPosx][14] 	:= aPropr[8]         	// TES

	Endif
	aItens[nPosx][2] += aNotas[nXa][4]									// Qtd Litros
	aItens[nPosx][4] += aNotas[nXa][6]									// Valor total
	aItens[nPosx][3] := Round(aItens[nPosx][4] / aItens[nPosx][2], 6)   // Valor medio litro
	nPosy := Day(aNotas[nXa][3] )
	aItens[nPosx][1][nposy] += aNotas[nXa][4]
	aItens[nPosx][1][32] += aNotas[nXa][4]


//	RecLock("ZZZ",.T.)
//	ZZZ->ZZZ_CONTRA 	:= cvaltochar(aNotas[nXa][7])
//	ZZZ->ZZZ_PRE1 		:= cvaltochar(aItens[nPosx][2])
//	ZZZ->ZZZ_PRE2	 	:= cvaltochar(aItens[nPosx][3])
//	ZZZ->ZZZ_PRE3 		:= cvaltochar(aItens[nPosx][4])
//	MsUnlock()



Next nXa

nCount := len(aNotas)

For nXa := 1 to len(aItens)

	oProces2:IncRegua2( "Registro.: "+cValToChar(nCount+nXa)+" De: "+cValtochar(nRec)  )

	aPropr := {}

	nFrete := Round(( aItens[nXa][2] * aItens[nXa][6] ) + ( aItens[nXa][2] * aItens[nXa][12] ),2)

	aPropr := U_CalcVlLi(aItens[nXa][2], aItens[nXa][3], aItens[nXa][5], nFrete, aItens[nXa][7], aItens[nXa][8], aItens[nXa][9], aItens[nXa][10] )

	aItens[nXA][13][1] := aPropr[1]	// Total Bruto+incent
	aItens[nXA][13][2] := aPropr[2]	// Bruto
	aItens[nXA][13][3] := aPropr[3]	// ICMS
	aItens[nXA][13][4] := aPropr[4]	// Frete
	aItens[nXA][13][5] := aPropr[5]	// Incentivo
	aItens[nXA][13][6] := aPropr[6]	// Funrural
	aItens[nXA][13][7] := aPropr[7]	// Subst trib
	aItens[nXA][13][8] := aPropr[8]	// Fundese
	aItens[nXA][13][9] := aPropr[9]	// Subst. Trib 1
	aItens[nXA][13][10] := aPropr[10]	// valor novo

next nXA


Return nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿a฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RunADJ( oProces2, cMesAno )

Local nXa		:= 0
Local nPosx		:= 0
Local nPosy		:= 0
Local nFrete	:= 0
Local nProcs	:= 0

If MV_PAR06 == 1
	nProcs := 4
Else
	nProcs := 6
Endif

//oProces2:SetRegua2( nProcs )

oProces2:IncRegua2( OemToansi("Fazendo Ajustes de arrendondamentos" ) )
ArredFret(oProces2)

oProces2:IncRegua2( OemToansi("Refazendo os valores para acerto de totais" ) )
ArredGer(oProces2)

oProces2:IncRegua2( OemToansi("Calculando o liquido" ) )
CalcLiq(oProces2)

atmp1 := aclone(aItens)
aItens := {}
oProces2:IncRegua2( OemToansi("Ordenando o array" ) )
aItens := u_IndItem(aTmp1,oProces2) //WM Janeiro 2009 Classifica

If MV_PAR06 == 2
	oProces2:IncRegua2( OemToansi("Gravando tabela temporaria 1" ) )
	//Grava็ใo dos dados da LBO
	GerLBO(oProces2, cMesAno)

	oProces2:IncRegua2( OemToansi("Gravando tabela temporaria 2" ) )
	//Grava็ใo dos dados da LBQ
	GerLBQ(oProces2, cMesAno)
Endif

Return nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function CalcLiq(oProces2)

Local cMyCod	:= ""
Local cCodBus	:= ""
Local nPos		:= 0



nCount 	:= 0
nRec	:= Len(aItens)

oProces2:IncRegua1( "Calculando o Liquido")
oProces2:SetRegua2( nRec )

For nXa := 1 to len(aItens)

oProces2:IncRegua2( "Registro.: "+cValToChar(nXa)+" De: "+cValtochar(nRec)  )

/*
	nIcms 	:= Round((aItens[nXa][4] * (aItens[nXa][5] / 100)),2)
	nIncent := Round((aItens[nXa][4] * (aItens[nXa][7] / 100)),2)
	nFunrur := Round((aItens[nXa][4] * (aItens[nXa][8] / 100)),2)
	nSt		:= Round((nIcms * (aItens[nXa][9] / 100)),2)
	NFundese:= Round((nSt * (aItens[nXa][10] / 100)),2)
	nLiquid1:= Round((aItens[nXa][4] + nIncent - nFunrur - nSt)  , 2)
*/
	nFrete	:= Round(aItens[nXa][13][4],2)
	nIncent := Round(aItens[nXA][13][5],2)
	nFunrur := Round(aItens[nXA][13][6],2)
	nSt		:= Round(aItens[nXA][13][7],2)
	nLiquid1:= Round((aItens[nXa][13][2] + nIncent - nFrete - nFunrur - nSt)  , 2)


	cMyCod := aItens[nXa][11]
	cCodBus := "P" + cMyCod
	nPos := asCan(aPagar, { |x| Alltrim(x[1]) == Alltrim( cCodBus ) } )
	If nPos > 0
		aPagar[nPos, 6] := nLiquid1
	Endif
next nXa

Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function PrcREL( oProces2, cMesAno )


oProces2:SetRegua2( 0 )
oProces2:IncRegua2( OemToansi("Imprimindo o relat๓rio" ) )

SaveInter()
U_QUAR022C(cMesAno)
RestInter()

Return nil





/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CalcVlLi(nVolume, nValNeg, nICMS, nFrete, nIncent, nFunrural, nST, nFundese )
Local aRet			:= {}
Local nValICMS		:= 0
Local nValIncent	:= 0
Local nValFunrural	:= 0
Local nValST		:= 0
Local nValFundese	:= 0
Local nValNovo		:= 0
Local nBruto		:= 0
Local nParc			:= 0
Local nTotal		:= 0

Default	nICMS		:= 0
Default nFrete 		:= 0
Default nIncent		:= 0
Default	nFunrural	:= 0
Default	nSt			:= 0
Default nFundese	:= 0

nBruto 	:= Round(nVolume * nValNeg,2)
nParc 	:= Round(nFrete / ( 1 + (nIncent/100) - (nFunrural / 100) - ((nICMS/100) * (nSt/100) )),2)
nBruto 	+= nParc

nValICMS 		:= Round(nBruto * (nIcms/100),2)
nValIncent 		:= Round(nBruto * (nIncent /100),2)
//nTotal 			:= Round(nBruto + nValIncent,2) //manfre 13-02-08
nValFunrural 	:= Round((nBruto + nValIncent)  * (nFunrural/100),2)
nValST			:= Round(nValICMS * (nSt / 100),2)
nValST1 		:= nValST
nValFundese 	:= 0
If nFundese <> 0
	nValFundese := Round(nValSt * (nFundese / 100 ),2)
	nvalST1 	:= nValSt - nValFundese
Endif
nTotal 			:= Round(nBruto + nValIncent,2)//manfre 13-02-08
nValNovo		:= Round(nBruto / nVolume, 4)

aadd( aRet, nTotal )   		//1
aadd( aRet, nBruto )		//2
aadd( aRet, nValICMS )  	//3
aadd( aRet, nFrete )    	//4
aadd( aRet, nValIncent) 	//5
aadd( aRet, nValFunrural)   //6
aadd( aRet, nValST )        //7
aadd( aRet, nValFundese)    //8
aadd( aRet, nValST1 )       //9
aadd( aRet, nValNovo )      //10

Return aRet






/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function testcalc()
Local oBmp, oDlgLogin, oBtnOk, oBtnCancel, oFont

Local oValor, oFaixa, oResult
Local aValores := { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
Local aRetorno := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
Local oValComb,oVolume,oFrete,oTotal,oICMS
Local oIncent,oFunrural,oST,oFundese,oValCalc
Local oTotalnew,ovalICMS,ovalIncent,ovalFunrural
Local ovalST,ovalFundese,oValST1,oValBrut

oFont := TFont():New('Arial',, -11, .T., .T.)

DEFINE MSDIALOG oDlgLogin FROM  0,0 TO 320,720  Pixel TITLE OemToAnsi("Teste")
oDlgLogin:lEscClose := .F.
@ 000,000 BITMAP oBmp RESNAME "LOGIN" oF oDlgLogin SIZE 95,oDlgLogin:nBottom  NOBORDER WHEN .F. PIXEL
@ 010,050 Say "Combinado:" PIXEL of oDlgLogin   FONT oFont //
@ 010,130 GET oValComb  VAR aValores[1]  Picture "@E 999,999.9999" SIZE 70, 9 OF oDlgLogin PIXEL FONT oFont //combinado
@ 020,050 Say "Volume:" PIXEL of oDlgLogin  FONT oFont //
@ 020,130 GET oVolume VAR aValores[2]   Picture "@E 999,999.99" SIZE 70, 9 OF oDlgLogin PIXEL FONT oFont //volume
@ 030,050 Say "Frete:" PIXEL of oDlgLogin  FONT oFont //
@ 030,130 GET oFrete VAR aValores[3]  Picture "@E 999,999.99" SIZE 100, 9 OF oDlgLogin PIXEL FONT oFont //Frete
@ 040,050 Say "Total:" PIXEL of oDlgLogin  FONT oFont //
@ 040,130 GET oTotal VAR aValores[4]  Picture "@E 999,999.99" SIZE 100, 9 OF oDlgLogin WHEN .F. PIXEL FONT oFont //Total
@ 060,050 Say "ICMS:" PIXEL of oDlgLogin  FONT oFont //
@ 060,130 GET oICMS VAR aValores[5]  Picture "@E 999,999.99" SIZE 100, 9 OF oDlgLogin PIXEL FONT oFont // ICMS
@ 070,050 Say "Incentivo:" PIXEL of oDlgLogin  FONT oFont //
@ 070,130 GET oIncent VAR aValores[6] Picture "@E 999,999.99" SIZE 100, 9 OF oDlgLogin PIXEL FONT oFont //Incentivo
@ 080,050 Say "Funrural:" PIXEL of oDlgLogin  FONT oFont //
@ 080,130 GET oFunrural VAR aValores[7] Picture "@E 999,999.99" SIZE 100, 9 OF oDlgLogin PIXEL FONT oFont //Funrural
@ 090,050 Say "ST:" PIXEL of oDlgLogin  FONT oFont //
@ 090,130 GET oST VAR aValores[8] Picture "@E 999,999.99" SIZE 100, 9 OF oDlgLogin PIXEL FONT oFont //ST
@ 100,050 Say "Fundese:" PIXEL of oDlgLogin  FONT oFont //
@ 100,130 GET oFundese VAR aValores[9] Picture "@E 999,999.99" SIZE 100, 9 OF oDlgLogin PIXEL FONT oFont //Fundese

@ 010,250 GET oValCalc  VAR aRetorno[10]  Picture "@E 999,999.9999" When .F. SIZE 70, 9 OF oDlgLogin PIXEL FONT oFont
@ 040,250 GET oTotalnew VAR aRetorno[1]  Picture "@E 999,999.99" SIZE 100, 9 OF oDlgLogin WHEN .F. PIXEL FONT oFont
@ 060,250 GET ovalICMS VAR aRetorno[3]  Picture "@E 999,999.99" SIZE 100, 9 OF oDlgLogin  when .F. PIXEL FONT oFont
@ 070,250 GET ovalIncent VAR aRetorno[5] Picture "@E 999,999.99" SIZE 100, 9 OF oDlgLogin  when .F. PIXEL FONT oFont
@ 080,250 GET ovalFunrural VAR aRetorno[6] Picture "@E 999,999.99" SIZE 100, 9 OF oDlgLogin  when .F. PIXEL FONT oFont
@ 090,250 GET ovalST VAR aRetorno[7] Picture "@E 999,999.99" SIZE 100, 9 OF oDlgLogin  when .F. PIXEL FONT oFont
@ 100,250 GET ovalFundese VAR aRetorno[8] Picture "@E 999,999.99" SIZE 100, 9 OF oDlgLogin when .F.  PIXEL FONT oFont
@ 110,050 Say "Nova ST:" PIXEL of oDlgLogin  FONT oFont //
@ 110,250 GET oValST1 VAR aRetorno[9] Picture "@E 999,999.99" SIZE 100, 9 OF oDlgLogin when .F. PIXEL FONT oFont
@ 120,050 Say "Mercadoria:" PIXEL of oDlgLogin  FONT oFont //
@ 120,250 GET oValBrut VAR aRetorno[2] Picture "@E 999,999.99" SIZE 100, 9 OF oDlgLogin when .F. PIXEL FONT oFont

TButton():New( 145,100,"&Calcula", oDlgLogin, {|| aRetorno :=U_CalcVlLi(aValores[2], aValores[1], aValores[5], aValores[3], aValores[6], aValores[7], aValores[8], aValores[9] ), aValores[4] := aValores[1] * aValores[2], oDlgLogin:Refresh() },38, 14,,, .F., .t., .F.,, .F.,,, .F. ) //
TButton():New( 145,140,"&Sair", oDlgLogin, {|| lOk := .F. , oDlgLogin:End() }, 38, 14,,, .F., .t., .F.,, .F.,,, .F. ) //
ACTIVATE MSDIALOG oDlgLogin CENTERED
Return Nil





/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RetImppr(cCodProp)			// Recuperar impostos e taxas

Local aAreaAnt	:= GetArea()
Local aRet 		:= {0, 0, 0, 0, 0, 0, 0, 0}
Local aAreaLBB	:= LBB->( GetArea() )
Local aAreaPA7	:= PA7->( GetArea() )
Local aAreaSB1	:= SB1->( GetArea() )
Local cCodTes	:= ""
Local cCodCar1	:= ""
Local cCodCar2	:= ""
Local cCodTipo	:= GetMV("ES_TIPLEI",,"A")
Local cCodProd	:= ""

dbSelectArea("LBN")
dbSetOrder(1)
If dbSeek( xFilial("LBN") + cCodTipo )
	cCodProd 	:= LBN->LBN_PRODUT
	cCodTes		:= LBN->LBN_TES
Else
	ApMsgAlert("Tipo de leite nใo cadastrado!!", "Falha")
Endif

If !Empty( cCodProd )
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek( xFilial("SB1") + cCodProd )
		nPercICMS := SB1->B1_PICM
	Else
		nPercICMS := 0
	Endif
Else
	nPercICMS := 0
Endif


dbSelectArea( "LBB" )
dbSetOrder(1)
if dbSeek( xFilial("LBB") + cCodProp )
	dbSelectArea("PA7")
	dbSetOrder(1)
	If dbSeek( xFilial("PA7") + LBB->LBB_LINHA )
		cCodCar1	:= PA7->PA7_CODCAR
		dbSelectArea("LBD")
		dbSetOrder(3)
		If dbSeek( xFilial("LBD") + PA7->PA7_CODTAN )
			dbSelectArea("LBC")
			dbSetOrder(1)
			If dbSeek( xFilial( "LBC" ) + LBD->LBD_CODROT )
				cCodCar2 	:= LBC->LBC_CODCAM

				* WILSON 21/03/2012 - ALTERACAO PARA INCENTIVO MG  NO PADRAO MICROSIGA

				//If ALLTRIM(UPPER(LBB->LBB_INCENT)) = "S" .and. LBB->LBB_EST = "MG"
				//	cCodTES	:= IIF(!Empty(LBC->LBC_TESCOM),LBC->LBC_TESCOM,cCodTES)
				//Else
				//	cCodTES	:= IIF(!Empty(LBC->LBC_TES),LBC->LBC_TES,cCodTES)
				//Endif

				If (ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+ALLTRIM(LBB->LBB_CODFOR)+ALLTRIM(LBB->LBB_LOJA),"A2_INCLTMG")) == "1" ;
				 .and. ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+ALLTRIM(LBB->LBB_CODFOR)+ALLTRIM(LBB->LBB_LOJA),"A2_EST")) == "MG")  ;
				 .or. cFilAnt =='09'

					cCodTES	:= IIF(!Empty(LBC->LBC_TESCOM),LBC->LBC_TESCOM,cCodTES)

				Else
					cCodTES	:= IIF(!Empty(LBC->LBC_TES),LBC->LBC_TES,cCodTES)

				Endif
                *

				dbSelectArea("SF4")
				if dbSeek( xFilial( "SF4" ) + cCodTes )
					IF SF4->F4_ICM = "S"
						aRet[1] := nPercICMS
					Else
						aRet[1] := 0
					Endif
				Else
					aRet[1] := 0
				Endif
			Else
				aRet[1] := 0
				aRet[2] := 0
			Endif
		Else
			aRet[1] := 0
			aRet[2] := 0
		Endif
	Else
		aRet[1] := 0
		aRet[2] := 0
	Endif

	If Alltrim(Upper(LBB->LBB_FUNRUR)) == "S"
		_cNATUREZA := Posicione("SA2", 1, xFilial("SA2") + LBB->LBB_CODFOR+LBB->LBB_LOJA, "A2_NATUREZ")

		If !Empty(_cNATUREZA)
        	_nPERCINS  := Posicione("SED", 1, xFilial("SED") + _cNATUREZA, "ED_PERCINS")
  		Else
  			_nPERCINS := GetMV("MV_FUNRURA",,2.3)
  		Endif
		aRet[4] := _nPERCINS

	Else
		aRet[4] := 0
	Endif

	aRet[2]		:= 0
	aRet[7]		:= 0
    nContad 	:= 0
    nValorfr	:= 0
	nPosc 		:= ascan(aFrete, { |x| Alltrim(Upper(x[1])) == Alltrim(Upper(cCodProp)) } )
	If nPosc > 0
		For nXa := 1 to len(aFrete[nPosc][2])
			nPos1 := ascan(aPagar, { |x| x[1] == "C"+aFrete[nPosc][2][nXa] } )
			if nPos1 > 0
				If aPagar[nPos1][5] > 0
			    	nContad 	+= 1
			    	nValorfr	+= aPagar[nPos1][5]
			 	Endif
			Endif
		next nXA
		if nContad > 0
			aRet[2] := nValorfr / nContad
		Endif
		aRet[7] := aFrete[nPosc][3]
	Endif

	If !Empty( cCodTES )
		aRet[8] := cCodTES
	Else
		aRet[8] := "   "
	Endif

	* WILSON 21/03/2012 - ALTERACAO PARA INCENTIVO MG  NO PADRAO MICROSIGA
	//If ALLTRIM(UPPER(LBB->LBB_INCENT)) = "S" .and. LBB->LBB_EST = "MG"
	//	aRet[3] := GetMV("ES_INCENTI",,2.5)
	//Else
	//	aRet[3] := 0
	//Endif

	If (ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+ALLTRIM(LBB->LBB_CODFOR)+ALLTRIM(LBB->LBB_LOJA),"A2_INCLTMG")) == "1" ;
	 .and. ( ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+ALLTRIM(LBB->LBB_CODFOR)+ALLTRIM(LBB->LBB_LOJA),"A2_EST"))) = "MG" )  .or. cFilAnt =='09'

		If cFilAnt <> '09'
		aRet[3] := POSICIONE("SB1",1,xFilial("SB1")+'200113',"B1_PRINCMG")
		Else
		aRet[3] := 12.28
		End IF

	Else
		aRet[3] := 0
	Endif

	If ALLTRIM(UPPER(LBB->LBB_FUNDES)) = "1" .and. LBB->LBB_EST = "MG"
		aRet[6] := GetMV("MV_FUNDESE",,5)
	Else
		aRet[6] := 0
	Endif

	If Upper(Alltrim(LBB->LBB_EST)) = "MG"
		If !Empty(LBB->LBB_FAIXA)
			dbSelectArea("PC4")
			dbSetOrder(1)
			If dbSeek( xFilial("PC4") + LBB->LBB_FAIXA )
				aRet[5] := PC4->PC4_PERCEN
			Else
				aRet[5] := 0
			Endif
		Else
			aRet[5] := 0
		Endif
	Endif
Else
	aRet[1] := 0		// ICMS
	aRet[2] := 0        // Frete 1
	aRet[3] := 0        // Incentivo
	aRet[4] := 0        // Funrural
	aRet[5] := 0        // nST
	aRet[6] := 0        // Fundese
	aRet[7] := 0		// Frete 2
	aRet[8] := ""
Endif

RestArea( aAreaSB1 )
RestArea( aAreaPA7 )
RestArea( aAreaLBB )
RestArea( aAreaAnt )

Return aRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GerProc( oProces1, cMesAno )

Local aAreaAnt 	:= GetArea()
Local nXa		:= 0
Local cTipoNF	:= GetNewPar("MV_TPNRNFS","1")
Local cSerie	:= Space(TamSX3("F1_SERIE")[1])

//Geracao Automatica de Notas Fiscais de Entrada
lOk := Sx5NumNota(@cSerie,cTipoNF)
if !lOk
	MsgStop(OemToAnsi("Necessario Informar o Numero da NF."),OemToAnsi("Atencao!"))
	lRet := .f.
Endif

oProces1:SetRegua2( 5 )
oProces1:IncRegua2( OemToansi("Realizando o fechamento" ) )

//Begin Transaction

If MV_PAR06 == 1
	oProces1:IncRegua2( OemToansi("Copiando tabela temporaria 1" ) )
	GerLBO(oProces1, cMesAno)

	oProces1:IncRegua2( OemToansi("Copiando tabela temporaria 2" ) )
	GerLBQ(oProces1, cMesAno)
Endif

oProces1:SetRegua1(3)
oProces1:IncRegua1(OemToansi("Gravando Notas de Entrada" ))

GRVnotas( oProces1, cMesAno, cSerie, cTipoNf )

oProces1:IncRegua1(OemToansi("Gerando Contas a Pagar" ))
GerCP(oProces1, cMesAno)	// Gera็ใo dos contas a pagar

oProces1:IncRegua1(OemToansi("Gerando Pedido de Venda Carreteiros" ))
GerPedV(oProces1, cMesAno)	// Gera็ใo dos pedidos de venda dos carreteiros
//End Transaction

RestArea(aAreaAnt)
Return nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GERLBO(oProces2, cMesAno)

Local aAreaAnt 	:= GetArea()
Local aAreaPC1 	:= PC1->( GetArea() )
Local aAreaPC2 	:= PC2->( GetArea() )
Local aAreaLBO 	:= LBO->( GetArea() )
Local cQuery	:= ""
Local cQuery1	:= ""
Local cQuery2	:= ""
Local nOk		:= 0
Local cCodTipo	:= GetMV("ES_TIPLEI",,"A")
Local nSeq		:= 0

cQuery := "DELETE " + RetSqlName("LBO")+ ""
cQuery += " WHERE LBO_FILIAL = '" + xFilial("LBO") + "' "
cQuery += " AND (LBO_DATENT >= '" + Right(cMesAno, 4) + left(cMesAno, 2) + "01' "
cQuery += " AND LBO_DATENT <= '" + Right(cMesAno, 4) + left(cMesAno, 2) + StrZero(Day(LastDay(ctod("01/"+left(cMesAno,2)+"/"+Right(cMesAno,4)))),2)+ "') "
//cQuery += " AND D_E_L_E_T_ = ' ' "

TCSqlExec( cQuery )

dbSelectArea("LBO")
cTarget := RetSqlName("LBO")
TCRefresh(cTarget)


//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::       Transfere as quantidades das Linhas para o LBO                                     ::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

cQuery1 := "SELECT MAX(LBO_NUMSEQ) AS REGISTRO FROM " + RetSqlName("LBO") + " "

If Select( "QRYMAX" ) > 0
	QRYMAX->( dbCloseArea() )
EndIf

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery1), 'QRYMAX', .F., .T.)

nSeq :=  VAL(QRYMAX->REGISTRO)

nSeq ++


cQuery := "SELECT PC0_FILIAL,PC0_DTENTR,PC0_QTDDIF, "
cQuery += "PC1_LINHA,PC1_CARSUB, PC1_CODPRO, PC1_QTDLIT, "
cQuery += "PC1_VLRLIT, PA7_QTDKM,LBB_CODFOR,LBB_LOJA,LBB_NOMFOR"
cQuery += " FROM "+RetSqlName("PC0")+" PC0 INNER JOIN "+RetSqlName("PC1")+" PC1 ON "
cQuery += "PC1_FILIAL = PC0_FILIAL AND PC1_NUMSEQ = PC0_NUMSEQ AND PC1.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN " + RetSqlName("PA7") + " PA7 ON "
cQuery += "PA7_FILIAL = '" + xFilial("PA7") + "' and PA7_CODLIN = PC1_LINHA AND PA7.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN " + RetSqlName("LBB") + " LBB ON PC1_CODPRO=LBB_CODPRO AND PC1_FILIAL=LBB_FILIAL"
cQuery += " WHERE PC0_FILIAL = '" + xFilial("PC0") + "' "
cQuery += " AND PC0_TPENTR = '1' "
cQuery += " AND (PC0_DTENTR >= '" + Right(cMesAno, 4) + left(cMesAno, 2) + "01' "
cQuery += " AND PC0_DTENTR <= '" + Right(cMesAno, 4) + left(cMesAno, 2) + StrZero(Day(LastDay(ctod("01/"+left(cMesAno,2)+"/"+Right(cMesAno,4)))),2)+ "') "
IF MV_PAR05 = 1
	cQuery += "AND PC1_CODPRO >= '" + MV_PAR03 + "' "
	cQuery += "AND PC1_CODPRO <= '" + MV_PAR04 + "' "
Endif
cQuery += " AND PC0_QTDAPO > 0 "
cQuery += " AND PC0.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY PC1_CODPRO, PC0_DTENTR "

MemoWrite("C:\EDI\LBO.SQL",cQuery)

cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYNFE', .F., .T.)

TcSetField( 'QRYNFE', "PC0_DTENTR", "D", 8, 0 )
TcSetField( 'QRYNFE', "PC0_QTDAPO", "N", 12, 2 )
TcSetField( 'QRYNFE', "PC0_QTDMED", "N", 12, 2 )
TcSetField( 'QRYNFE', "PC0_QTDDIF", "N", 12, 2 )
TcSetField( 'QRYNFE', "PC1_QTDMED", "N", 12, 2 )
TcSetField( 'QRYNFE', "PC1_QTDLIT", "N", 12, 2 )
TcSetField( 'QRYNFE', "PC1_VLRLIT", "N", 12, 4 )

dbSelectArea("QryNFE")

QryNFE->( dbGotop() )

nCount 	:= 0
nRec	:= 0
While !Eof()
	nRec ++
	dbskip()
End While

dbGotop()

oProces2:IncRegua1( "Gerando Fechamento-LINHAS" )
oProces2:SetRegua2( nRec )


While !eof()

	//dbSelectArea("LBB")
	//dbSetOrder(1)
	//dbSeek( xFilial("LBB") + QryNFE->PC1_CODPRO )

	oProces2:IncRegua2("CodPro: " + AllTrim(QRYNFE->PC1_CODPRO) + " - Reg: " + cValToChar(nCount) + " de :" + cValtoChar(nRec) )
	nCount ++

	dbSelectArea("LBO")
	dbSetOrder(1)

	If dbSeek( xFilial("LBO") + QryNFE->PC1_CODPRO + dTos(QryNFE->PC0_DTENTR) + "1" )
		RecLock("LBO", .F.)
	Else
		RecLock("LBO", .T.)
		LBO->LBO_FILIAL := xFilial("LBO")
		LBO->LBO_DATENT := QryNFE->PC0_DTENTR
		LBO->LBO_TPENTR := "1"
		LBO->LBO_CARSUB := QryNFE->PC1_CARSUB
		LBO->LBO_CODPRO := QryNFE->PC1_CODPRO
		LBO->LBO_KMRODA := QryNFE->PA7_QTDKM
		LBO->LBO_NOMFOR := QryNFE->LBB_NOMFOR
		LBO->LBO_TIPOL 	:= cCodTipo
		LBO->LBO_NUMSEQ := cValTochar(nSeq)
		LBO->LBO_CODROT := QryNFE->PC1_LINHA
		LBO->LBO_CODFOR := QryNFE->LBB_CODFOR + QryNFE->LBB_LOJA
	nSeq ++
	Endif

	nValor 	:= LBO->LBO_QUANT * LBO->LBO_VALOR
	nValor1 := QryNFE->PC1_QTDLIT * QryNFE->PC1_VLRLIT
	nValor 	:= ( ( nValor + nValor1 ) / ( LBO->LBO_QUANT + QryNFE->PC1_QTDLIT ) )

	LBO->LBO_QUANT 	+= QryNFE->PC1_QTDLIT
	LBO->LBO_QTDDIF := QryNFE->PC0_QTDDIF
	LBO->LBO_VALOR 	:= nValor

	MsUnlock()

	dbSelectArea("QryNFE")
	dbSkip()

End

dbSelectArea("QryNFE")
dbCloseArea()


//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::       Transfere as quantidades das ROTAS para o LBO                                      ::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

If Select( "QRYMAX2" ) > 0
	QRYMAX2->( dbCloseArea() )
EndIf

cQuery2 := "SELECT MAX(LBO_NUMSEQ) AS REGISTRO FROM " + RetSqlName("LBO") + " "
dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery2), 'QRYMAX2', .F., .T.)
nSeq :=  val(QRYMAX2->REGISTRO)
nSeq ++

cQuery := "SELECT PC0_FILIAL, PC0_NUMSEQ, PC0_DTENTR, PC0_TPENTR, PC0_LINROT, PC0_DESCRI, PC0_QTDAPO, PC0_QTDMED, PC0_QTDDIF, "
cQuery += "PC2_FILIAL, PC2_NUMSEQ, PC2_ROTA, PC2_QTDMED, PC2_CARSUB, PC2_CODTAN as TANQUE, PC2_QTDLIT, "
cQuery += "PC2_ROTTAN, PC2_VLRLIT, LBC_TTKMRT, LBF_CODPRO,LBB_NOMFOR,LBB_CODFOR,LBB_LOJA"
cQuery += " FROM "+RetSqlName("PC0")+" PC0 INNER JOIN "+RetSqlName("PC2")+" PC2 ON "
cQuery += "PC2_FILIAL = PC0_FILIAL AND PC2_NUMSEQ = PC0_NUMSEQ AND PC2.D_E_L_E_T_ = ' ' "
cQuery += "INNER JOIN "+RetSqlName("LBD")+" LBD ON "
cQuery += "LBD_FILIAL = '" + xFilial("LBD") + "' AND LBD_CODROT = PC2_ROTA AND LBD.D_E_L_E_T_ = ' ' "
cQuery += "INNER JOIN "+RetSqlName("LBC")+ " LBC ON "
cQuery += "LBC_FILIAL = '" + xFilial("LBC") + "' AND LBC_CODROT = LBD_CODROT AND LBC.D_E_L_E_T_ = ' ' "
cQuery += "INNER JOIN "+RetSqlName("LBF")+" LBF ON "
cQuery += "LBF_FILIAL = '" + xFilial("LBF") + "' AND LBF_CODTAN = LBD_CODTAN AND LBF.D_E_L_E_T_ = ' ' "
cQuery += "INNER JOIN "+RetSqlName("LBB")+" LBB ON "
cQuery += "LBB_FILIAL = '" + xFilial("LBB") + "' AND LBB_CODPRO = LBF_CODPRO AND LBB.D_E_L_E_T_ = ' ' AND LBB_FILIAL=LBF_FILIAL "
cQuery += "WHERE PC0_FILIAL = '" + xFilial("PC0") + "' "
cQuery += " AND PC0_TPENTR = '2' "
cQuery += " AND (PC0_DTENTR >= '" + Right(cMesAno, 4) + left(cMesAno, 2) + "01' "
cQuery += " AND PC0_DTENTR <= '" + Right(cMesAno, 4) + left(cMesAno, 2) + StrZero(Day(LastDay(ctod("01/"+left(cMesAno,2)+"/"+Right(cMesAno,4)))),2)+ "')"
cQuery += " AND PC0.D_E_L_E_T_ = ' ' "
cQuery += " AND PC0_QTDAPO > 0 "
cQuery += "Union "
cQuery += "SELECT PC0_FILIAL, PC0_NUMSEQ, PC0_DTENTR, PC0_TPENTR, PC0_LINROT, PC0_DESCRI, PC0_QTDAPO, PC0_QTDMED, PC0_QTDDIF, "
cQuery += "PC2_FILIAL, PC2_NUMSEQ, PC2_ROTA, PC2_QTDMED, PC2_CARSUB, PA7_CODTAN as TANQUE, PC2_QTDLIT, "
cQuery += "PC2_ROTTAN, PC2_VLRLIT, LBC_TTKMRT, LBF_CODPRO,LBB_NOMFOR,LBB_CODFOR,LBB_LOJA "
cQuery += " FROM "+RetSqlName("PC0")+" PC0 INNER JOIN "+RetSqlName("PC2")+" PC2 ON "
cQuery += "PC2_FILIAL = PC0_FILIAL AND PC2_NUMSEQ = PC0_NUMSEQ AND PC2.D_E_L_E_T_ = ' ' "
cQuery += "INNER JOIN "+RetSqlName("LBD")+" LBD ON "
cQuery += "LBD_FILIAL = '" + xFilial("LBD") + "' AND LBD_CODROT = PC2_ROTA AND LBD.D_E_L_E_T_ = ' ' "
cQuery += "INNER JOIN "+RetSqlName("LBC")+" LBC ON "
cQuery += "LBC_FILIAL = '" + xFilial("LBC") + "' AND LBC_CODROT = LBD_CODROT AND LBC.D_E_L_E_T_ = ' ' "
cQuery += "INNER JOIN "+RetSqlName("PA7")+" PA7 ON "
cQuery += "PA7_FILIAL = '" + xFilial("PA7") + "' AND PA7_CODLIN = LBD_CODLIN AND PA7.D_E_L_E_T_ = ' ' "
cQuery += "INNER JOIN "+RetSqlName("LBF")+" LBF ON "
cQuery += "LBF_FILIAL = '" + xFilial("LBF") + "' AND LBF_CODTAN = PA7_CODTAN AND LBF.D_E_L_E_T_ = ' ' "
cQuery += "INNER JOIN "+RetSqlName("LBB")+" LBB ON "
cQuery += "LBB_FILIAL = '" + xFilial("LBB") + "' AND LBB_CODPRO = LBF_CODPRO AND LBB.D_E_L_E_T_ = ' ' "
cQuery += "WHERE PC0_FILIAL = '" + xFilial("PC0") + "' "
cQuery += " AND PC0_TPENTR = '2' "
cQuery += " AND (PC0_DTENTR >= '" + Right(cMesAno, 4) + left(cMesAno, 2) + "01' "
cQuery += " AND PC0_DTENTR <= '" + Right(cMesAno, 4) + left(cMesAno, 2) + StrZero(Day(LastDay(ctod("01/"+left(cMesAno,2)+"/"+Right(cMesAno,4)))),2)+ "') "
cQuery += " AND PC0.D_E_L_E_T_ = ' ' "
cQuery += " AND PC0_QTDAPO > 0 "
cQuery += "ORDER BY LBF_CODPRO, PC0_DTENTR "

Memowrit("C:\EDI\WM003.SQL", cQuery )

cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYNFE', .F., .T.)

TcSetField( 'QRYNFE', "PC0_DTENTR", "D", 8, 0 )
TcSetField( 'QRYNFE', "PC0_QTDAPO", "N", 12, 2 )
TcSetField( 'QRYNFE', "PC0_QTDMED", "N", 12, 2 )
TcSetField( 'QRYNFE', "PC0_QTDDIF", "N", 12, 2 )
TcSetField( 'QRYNFE', "PC2_QTDMED", "N", 12, 2 )
TcSetField( 'QRYNFE', "PC2_QTDLIT", "N", 12, 2 )
TcSetField( 'QRYNFE', "PC2_VLRLIT", "N", 12, 4 )

dbSelectArea("QryNFE")
QryNFE->( dbGotop() )

nCount 	:= 0
nRec	:= 0
While !Eof()
	nRec ++
	dbskip()
End While

dbGotop()

oProces2:IncRegua1( "Gerando Fechamento-ROTAS" )
oProces2:SetRegua2( nRec )

While !eof()

	//dbSelectArea("LBB")
	//dbSetOrder(1)
	//dbSeek( xFilial("LBB") + QryNFE->LBF_CODPRO )

	oProces2:IncRegua2("Registro : " + cValToChar(nCount) + " de :" + cValtoChar(nRec) )
	nCount ++

	dbSelectArea("LBO")
	dbSetOrder(1)

	If dbSeek( xFilial("LBO") + QryNFE->LBF_CODPRO + dTos(QryNFE->PC0_DTENTR) + "2" + QryNFE->PC0_LINROT ) //Acrescentado campo PC0_LINROT no indice 1 LBO, estava somando errado as entradas por linha - Wilson 27/11/09
		RecLock("LBO", .F.)
	Else
		RecLock("LBO", .T.)
		LBO->LBO_FILIAL := xFilial("LBO")
		LBO->LBO_DATENT := QryNFE->PC0_DTENTR
		LBO->LBO_TPENTR := "2"
		LBO->LBO_CARSUB := QryNFE->PC2_CARSUB
		LBO->LBO_CODPRO := QryNFE->LBF_CODPRO
		LBO->LBO_KMRODA := QryNFE->LBC_TTKMRT
		LBO->LBO_NOMFOR := QryNFE->LBB_NOMFOR
		LBO->LBO_TIPOL 	:= cCodTipo
		LBO->LBO_NUMSEQ := cValTochar(nSeq)
		LBO->LBO_CODROT := QryNFE->PC2_ROTA
		LBO->LBO_CODFOR := QryNFE->LBB_CODFOR + QryNFE->LBB_LOJA
	nSeq ++
	Endif

	nValor 	:= LBO->LBO_QUANT * LBO->LBO_VALOR
	nValor1 := QryNFE->PC2_QTDLIT * QryNFE->PC2_VLRLIT
	nValor 	:= ( ( nValor + nValor1 ) / ( LBO->LBO_QUANT + QryNFE->PC2_QTDLIT ) )

	LBO->LBO_QUANT 	+= QryNFE->PC2_QTDLIT
	LBO->LBO_QTDDIF := QryNFE->PC0_QTDDIF
	LBO->LBO_VALOR 	:= nValor

	MsUnlock()

	dbSelectArea("QryNFE")
	dbSkip()

End

dbSelectArea("QryNFE")
dbCloseArea()

RestArea( aAreaLBO )
RestArea( aAreaPC2 )
RestArea( aAreaPC1 )
RestArea( aAreaAnt )

Return nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
/*
STATIC FUNCTION GERENTR(OPROCES1, CMESANO)
LOCAL NPOS	:= 0
LOCAL NXA	:= 0



RETURN NIL
*/



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User function GrvLog( cRotina, cExecuta, cHoraIni, dDataIni, cErro, cHoraFim, dDataFim )
Local lRet := .T.
Local lContinua := .T.
Local aAreaAnt := GetArea()

RestArea(aAreaAnt)
Return(lRet)






/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GerLBQ(oProces2, cMesAno)

Local nXA 		:= 0
Local aAreaAnt	:= GetArea()
Local aAreaLBB	:= LBB->( GetArea() )
Local aAreaLBE	:= LBE->( GetArea() )
Local aAreaLBF	:= LBF->( GetArea() )
Local aAreaLBC	:= LBE->( GetArea() )
Local aAreaLBD	:= LBF->( GetArea() )
Local aAreaPA7	:= LBE->( GetArea() )
Local aVetor	:= {}
Local cQuery	:= ""

cQuery := "DELETE FROM " + RetSqlName("LBQ") + " "
cQuery += "WHERE LBQ_FILIAL = '" + xFilial("LBQ") + "' "
cQuery += "AND (LBQ_DATINI >= '" + DTOS(MV_PAR01) + "' "
cQuery += "AND LBQ_DATFIN <= '" + DTOS(MV_PAR02) + "') "
//cQuery += "AND LBQ_FLAG = ' ' "
cQuery += "AND D_E_L_E_T_ = ' ' "

nOk := TcSqlExec( cQuery )
If nOk <> 0
	ApMsgAlert( "Falha ao apagar o arquivo de Fechamento anterior!!", "Falha" )
	Return Nil
Else
	dbSelectArea("LBQ")
	cTarget := RetSqlName("LBQ")
	TCRefresh(cTarget)
Endif

nTotSenar	:= 0
nTotST		:= 0
nTotFUNDESE	:= 0
nTotFunr 	:= 0
cCodProp 	:= ""
nTTLts		:= 0
nTTValor	:= 0
/*

Local _nVolume		:= aDados[2] // Volume de leite
Local _nVLComb		:= aDados[3] // Valor M้dio combinado
Local _nTTComb		:= aDados[4] // Valor total combinado
Local _nPercICMS	:= aDados[5] // Perc. ICMS
Local _nUnitFR1		:= aDados[6] // Vlr Frete 1 Unitario
LOcal _nPercInc		:= aDados[7] // Perc. Incentivo
Local _nPerFunr		:= aDados[8] // Perc.Funrural
Local _PercST		:= aDados[9] // Perc. ST
Local _PercFund		:= aDados[10] // Perc.Fundese
Local _cCodPro		:= aDados[11] // Cod.Propriedade
LOcal _nUnitFR2		:= aDados[12] // Vlr. Frete 2
Local _cTes			:= aDados[14] // TES
/*
aItens[n][13][1] = nTotal
aItens[n][13][2] = nBruto
aItens[n][13][3] = nValICMS
aItens[n][13][4] = nFrete
aItens[n][13][5] = nValIncent
aItens[n][13][6] = nValFunrural
aItens[n][13][7] = nValST
aItens[n][13][8] = nValFundese
aItens[n][13][9] = nValST1
aItens[n][13][10] = nValNovo
*/


nRec := len(aItens)
oProces2:IncRegua1( "Gravando Arquivos de Fechamento-LBQ1" )
oProces2:SetRegua2( nRec )

For nXa := 1 to len(aItens)

oProces2:IncRegua2("Registro: " + cValToChar(nXa) + " de :" + cValtoChar(nRec) )

	nPos := ascan(aVetor, { |x| x[1] == aItens[nXa][11] } )
	//                   1               2     3     4     5     6     7   8   9    10     11   12
	If nPos == 0     //Propriedade     Total  ICMS  FRETE Incen  Funr  ST  fund ST1  VLlts Vol Frt2
		aadd(aVetor, {aItens[nXa][11], 0,     0,    0,     0,    0,    0,  0,   0,     0,   0,  0 } )
		nPos := len(aVetor)
	Endif
	aVetor[nPos][2] += aItens[nXa][13][2]
	aVetor[nPos][3] += aItens[nXa][13][3]
	aVetor[nPos][4] += aItens[nXa][6]
	aVetor[nPos][5] += aItens[nXa][13][5]
	aVetor[nPos][6] += aItens[nXa][13][6]
	aVetor[nPos][7] += aItens[nXa][13][7]
	aVetor[nPos][8] += aItens[nXa][13][8]
	aVetor[nPos][9] += aItens[nXa][13][9]
	aVetor[nPos][10] += aItens[nXa][13][10]
	aVetor[nPos][11] += aItens[nXa][2]
	aVetor[nPos][12] += aItens[nXa][12]
Next nXa

nRec := len(aVetor)

oProces2:IncRegua1( "Gravando Arquivos de Fechamento-LBQ2" )
oProces2:SetRegua2( nRec )

For nXa := 1 to len(aVetor)

oProces2:IncRegua2("Registro: " + cValToChar(nXa) + " de :" + cValtoChar(nRec) )

		cCodProp 	:= aVetor[nXA][1]
		nTTLts		:= aVetor[nXA][11]
		nTTValor	:= aVetor[nXA][2]
		nFrete1		:= aVetor[nXA][4] * aVetor[nXA][11]
		nFrete2		:= aVetor[nXA][12] * aVetor[nXA][11]
		nValInc		:= aVetor[nXa][5]
		nValST		:= aVetor[nXa][7]
		nValFund	:= aVetor[nXa][8]
		nValFunr	:= aVetor[nXa][6]

		// Gravando Despesas e Receitas das Propriedades
		// usar avetfin e avetpropr
		dbSelectArea("LBB")
		dbSetOrder(1)
		dbSeek( xFilial("LBB") + cCodProp )

		dbSelectArea("LBQ")

		if nTTValor > 0
			RecLock("LBQ",.T.)
			LBQ->LBQ_FILIAL := xFilial("LBQ")
			LBQ->LBQ_DATINI := dDataIni
			LBQ->LBQ_DATFIN := dDataFim
			LBQ->LBQ_CODPRO := cCodProp
			LBQ->LBQ_FLAG   := "R"
			LBQ->LBQ_DESC	:= "Entrada de Leite"
			LBQ->LBQ_VALOR  := nTTValor
			LBQ->LBQ_QTD	:= nTTLts
			LBQ->LBQ_PAGQUA	:= 0
			MsUnlock()
		Endif
		// Valor Incentivo
		if nValInc > 0
			RecLock("LBQ",.T.)
			LBQ->LBQ_FILIAL := xFilial("LBQ")
			LBQ->LBQ_DATINI := dDataIni
			LBQ->LBQ_DATFIN := dDataFim
			LBQ->LBQ_CODPRO := cCodProp
			LBQ->LBQ_FLAG    := "R"
			LBQ->LBQ_DESC	 := "Valor do Incentivo"
			LBQ->LBQ_QTD	 :=	0
			LBQ->LBQ_VALOR   :=	 Noround(nValInc, 2)
			MsUnlock()
		Endif

		// DESPESAS

		// Calculo do Frete 1o. Percurso
		if nFrete1 > 0
			RecLock("LBQ",.T.)
			LBQ->LBQ_FILIAL := xFilial("LBQ")
			LBQ->LBQ_DATINI := dDataIni
			LBQ->LBQ_DATFIN := dDataFim
			LBQ->LBQ_CODPRO := cCodProp
			LBQ->LBQ_FLAG    := "D"
			LBQ->LBQ_DESC	 := "Carreto 1o. Percurso"
			LBQ->LBQ_QTD	 :=	0
			LBQ->LBQ_VALOR   :=	 Noround(nFrete1, 2)
			MsUnlock()
		Endif

		// Calculo do Frete 2o. Percurso
		if nFrete2 > 0
			RecLock("LBQ",.T.)
			LBQ->LBQ_FILIAL := xFilial("LBQ")
			LBQ->LBQ_DATINI := dDataIni
			LBQ->LBQ_DATFIN := dDataFim
			LBQ->LBQ_CODPRO := cCodProp
			LBQ->LBQ_FLAG    := "D"
			LBQ->LBQ_DESC	 := "Carreto 2o. Percurso"
			LBQ->LBQ_QTD	 :=	0
			LBQ->LBQ_VALOR   :=	 Noround(nFrete2, 2)
			MsUnlock()
		Endif

		// Calculo do Funrural
		If LBB->LBB_FUNRUR <> "N" .and. nValFunR > 0
			RecLock("LBQ",.T.)
			LBQ->LBQ_FILIAL := xFilial("LBQ")
			LBQ->LBQ_DATINI := dDataIni
			LBQ->LBQ_DATFIN := dDataFim
			LBQ->LBQ_CODPRO := cCodProp
			LBQ->LBQ_FLAG   := "D"
			LBQ->LBQ_DESC	:= "Funrural"
			LBQ->LBQ_QTD	:=	0
			LBQ->LBQ_VALOR 	:= nValFunr
			MsUnlock()
			nTotFunr  += LBQ->LBQ_VALOR
		Endif

		// Calculo do Senar
		If LBB->LBB_SENAR <> "N"
			RecLock("LBQ",.T.)
			LBQ->LBQ_FILIAL := xFilial("LBQ")
			LBQ->LBQ_DATINI := dDataIni
			LBQ->LBQ_DATFIN := dDataFim
			LBQ->LBQ_CODPRO := cCodProp
			LBQ->LBQ_FLAG   := "D"
			LBQ->LBQ_DESC	:= "Senar"
			LBQ->LBQ_QTD	:=	0
			LBQ->LBQ_VALOR  := (nTTValor * GetMv("MV_SENAR",,0.65))/100
			MsUnlock()
			nTotSenar +=   LBQ->LBQ_VALOR
		Endif

		If nValFund > 0
			RecLock("LBQ",.T.)
			LBQ->LBQ_FILIAL := xFilial("LBQ")
			LBQ->LBQ_DATINI := dDataIni
			LBQ->LBQ_DATFIN := dDataFim
			LBQ->LBQ_CODPRO := cCodProp
			LBQ->LBQ_FLAG   := "D"
			LBQ->LBQ_DESC	:= "FUNDESE"
			LBQ->LBQ_QTD	:=	0
			LBQ->LBQ_VALOR  := NoRound(nValFund, 2)
			MsUnlock()
			nTotFundese +=   LBQ->LBQ_VALOR
		Endif

		If nValST > 0
			RecLock("LBQ",.T.)
			LBQ->LBQ_FILIAL := xFilial("LBQ")
			LBQ->LBQ_DATINI := dDataIni
			LBQ->LBQ_DATFIN := dDataFim
			LBQ->LBQ_CODPRO := cCodProp
			LBQ->LBQ_FLAG   := "D"
			LBQ->LBQ_DESC	:= "Subst.Tributaria"
			LBQ->LBQ_QTD	:=	0
			LBQ->LBQ_VALOR  := NoRound(nValST, 2)
			MsUnlock()
			nTotST +=   LBQ->LBQ_VALOR
		Endif
next nXA

//Grava  abatimentos dos Convenios

nRec := len(aAbat)

oProces2:IncRegua1( "Gravando Arquivos de Fechamento-Abatimentos" )
oProces2:SetRegua2( nRec )



For nXa := 1 to Len(aAbat)
oProces2:IncRegua2("Registro: " + cValToChar(nXa) + " de :" + cValtoChar(nRec) )

	If left(aAbat[nXA][1],1) == "F"

		If aAbat[nXA][6] > 0
			RecLock("LBQ",.T.)
			LBQ->LBQ_FILIAL := xFilial("LBQ")
			LBQ->LBQ_DATINI := dDataIni
			LBQ->LBQ_DATFIN := dDataFim
			LBQ->LBQ_CODPRO := aAbat[nXa][2]
			LBQ->LBQ_FLAG   := "D"
			LBQ->LBQ_DESC	:= "Desconto Convenio"
			LBQ->LBQ_QTD	:=	0
			LBQ->LBQ_VALOR  := NoRound(aAbat[nXa][6], 2)
			MsUnlock()
		Endif
    Endif
Next nXA


RestArea( aAreaLBB )
RestArea( aAreaLBE )
RestArea( aAreaLBF )
RestArea( aAreaLBC )
RestArea( aAreaLBD )
RestArea( aAreaPA7 )
RestArea( aAreaAnt )

Return nil




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GRVnotas( oProces2, cMesAno, cSerie, cTipoNf )

Local lRet			:= .T.
Local k				:= 0
Local nTotFunr		:= 0
Local nTotSenar		:= 0
Local _cCCDeb		:= ""
Local nModOrig		:= nModulo
Local cModOrig		:= cModulo
Local aConvenios	:= {}
Local	__nAdto 	:= 0
Local	__nConv 	:= 0

Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.
Private cPrefixo	:= "TST"
Private cCodLeite	:= ''


oProces2:SetRegua2(len(aItens))

if MsgYesNo("Confirma Fechamento e Geracao de Notas Fiscais de Entrada?","Confirma")

	If GetMv("MV_XDTFCHT") >= dDataBase
	MsgStop("As Notas desse perํodo ja foram geradas !","Atencao")
	return
	End If

		PutMv("MV_XDTFCHT",dDatabase)
		cModulo := "COM"
		nModulo := 2

		For k = 1 to len(aItens)

			oProces2:IncRegua2("Gerando Notas Fiscais... " + strzero(k,9)+"/"+strzero(len(aItens),9))

			dbSelectArea("LBB")
			dbSetorder(1)
			dbSeek(xFilial("LBB") + aItens[k][11])

			dbSelectArea("LBD")
			dbSetOrder(3)
			msSeek( xFilial("LBD") + LBB->LBB_CODTAN )

			dbSelectArea("LBC") // posiciona cad. rota
			dbSetorder(1)
			MsSeek(xFilial("LBC")+LBD->LBD_CODROT) //FILIAL + COD.ROTA

			dbSelectArea("LBE") // posiciona cad. carreteiro
			dbSetorder(2)
			MsSeek(xFilial("LBE")+LBC->LBC_CODCAM) //FILIAL + COD.CARRETEIRO

			dbSelectArea("SA2")
			dbSetorder(1)
			dbSeek(xFilial("SA2") + LBB->LBB_CODFOR + LBB->LBB_LOJA)

			wProcura := dbSeek(xFilial("LBP")+aItens[k][11]+Dtos(dMVPAR_01))
			RecLock("LBP",If(wProcura,.F.,.T.))
			LBP->LBP_FILIAL := xFilial("LBP")
			LBP->LBP_DATINI := dDataIni
			LBP->LBP_DATFIN := dDataFim
			LBP->LBP_CODPRO := aItens[k][11]
			LBP->LBP_NOMFOR := SA2->A2_NOME
			LBP->LBP_COTAAN := 0
			LBP->LBP_PRODUC := aItens[k][2]
			LBP->LBP_SOBRA  := 0
			LBP->LBP_EXCESS := 0
			LBP->LBP_RATEIO := 0
			LBP->LBP_COTAME := 0
			LBP->LBP_COTADI := 0
			LBP->LBP_OK     := LBB->LBB_TIPOL	// "A"
			LBP->LBP_LINHA  := LBB->LBB_LINHA
			MsUnlock()

			nTValInss := 0
			nTBasInss := 0
			nTValIcms := 0
			nTBasIcms := 0

			nTotDesp := 0
			nTotRece := 0
			nTotDesc := 0
			nQtdLeiteB := 0
			nValLeiteB := 0
			nQtdLeiteC := 0
			nValLeiteC := 0


			nTotRece := aItens[k][13][1]

			nBonifGran := 0  				// Bonifica็ใo Granel
			nBonifQtde := 0 	 			// Bonifica็ใo por quantidade
			nOutCred   := 0  				// Outros creditos
			dFrete	   := 0  				// Frete a descontar

			nSeq := 0

			nConvenio := 0
			nPosq := ascan(aAbat, {|x| Alltrim(UPPER(x[1])) == Alltrim(UPPER("F" + LBB->LBB_CODPRO)) } )
			If nPosq > 0
				nConvenio := aAbat[nPosq][6]
			Endif


			__nFunRura 	:= aItens[k][13][6]

			__nFrete	:= aItens[k][13][4]

			__nSubsttr 	:= aItens[k][13][7]
			_nICMS		:= aItens[k][13][8]
			nIncent		:= aItens[k][13][5]

			__nOutros	:=  nConvenio

			__nLiquid	:= (nTotRece) - ( __nFunrura + __nFrete + __nOutros + __nSubsttr )

			if LBB->LBB_SENAR == "S"
				nVSenar   := ((nTotRece) * GetMv("MV_SENAR"))/100
			Else
				nVSenar   := 0
			Endif

			//Senar,FunRural,Frete,Taxa Adm
			nTotDesc := NoRound(nVSenar, 2)

			dbSelectArea("LBN")
			dbSetOrder(1)
			if dbSeek(xFilial("LBN")+LBB->LBB_TIPOL)
				cCodLeite := LBN->LBN_PRODUT
				cTE		  := LBN->LBN_TES
			Endif

			cTE := aItens[k][14]

			cNumero := NxtSX5Nota(cSerie,.T.,cTipoNF)

			// Processa o ExecAuto para geracao das Notas Fiscais

			aIteTempNFE 	:= {}
			aCabec      	:= {}
			aItensnf      	:= {}

			SB1->(DbGoTop())
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1") + cCodLeite))

			SF4->(DbGoTop())
			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4") + cTE))

			cCFB     := SF4->F4_CF
			cFornece := LBB->LBB_CODFOR
			cLoja    := LBB->LBB_LOJA
			nSeq     := 1

			//Itens Nota Fiscal
			aadd(aIteTempNFE,{"D1_ITEM"	  	,StrZero(nSeq, TamSx3("D1_ITEM")[1]) 		,Nil})
			aadd(aIteTempNFE,{"D1_COD"	  	,iif(!EMPTY(cCodLeite),cCodLeite,'200113')	,Nil})
			aadd(aIteTempNFE,{"D1_UM"	  	,SB1->B1_UM								   	,Nil})
			aadd(aIteTempNFE,{"D1_QUANT"  	,aItens[k][2]		               	   		,Nil})
			aadd(aIteTempNFE,{"D1_VUNIT"  	,aItens[k][13][10]       					,Nil}) // WM
			aadd(aIteTempNFE,{"D1_TOTAL"  	,Round(aItens[k][2]*aItens[k][13][10], 2)	,Nil})
			aadd(aIteTempNFE,{"D1_EMISSAO"	,dDataFim	      	             			,Nil})
			aadd(aIteTempNFE,{"D1_TES"	  	,IIF(cFilAnt =='09','368',cTE)            	,Nil})
			aadd(aIteTempNFE,{"D1_CONTA"  	,SB1->B1_CONTA		               			,Nil})
			aadd(aIteTempNFE,{"D1_CC"		,SB1->B1_CC			               			,Nil})
			aadd(aIteTempNFE,{"D1_RATEIO" 	,'2'		                        		,Nil})
			aadd(aIteTempNFE,{"D1_LOCAL"  	,SB1->B1_LOCPAD		               			,Nil})
			aadd(aIteTempNFE,{"D1_PRINCMG" 	,IIF(cFilAnt == '09',0,SB1->B1_PRINCMG)	    ,Nil})
			aadd(aIteTempNFE,{"D1_VLINCMG" 	,IIF(cFilAnt == '09',0,nIncent)			    ,Nil})
			aadd(aIteTempNFE,{"D1_DESPESA"	,IIF(cFilAnt == '09',round( (Round(aItens[k][2]*aItens[k][13][10], 2)*0.1228),2),0)				,Nil})
			//CHAMADO 6578 - RRM alterado 12/09/16
			//incluso tratamento para o campo D1_ORIGEM  - SIGLA CAP - PARA NOTA DE CAPTAวรO
			aadd(aIteTempNFE,{"D1_ORIGEM"	,'CAP'  ,   Nil})

			aadd(aItensNF,aIteTempNFE)

			// Cabecalho Nota Fiscal
			aadd(aCabec,{"F1_TIPO"  	,"N"		         			,Nil})
			aadd(aCabec,{"F1_ESPECIE"	,"SPED"  	         			,Nil})
			aadd(aCabec,{"F1_FORMUL"	,"S"				 			,Nil})
			aadd(aCabec,{"F1_DOC"  	    ,cNumero			 			,Nil})
			aadd(aCabec,{"F1_SERIE"	    ,cSerie				 			,Nil})
			aadd(aCabec,{"F1_COND"	    ,GetMv("MV_CONDPAD",,"009") 	,Nil})
			aadd(aCabec,{"F1_EMISSAO"	,dDataFim	         			,Nil})
			aadd(aCabec,{"F1_FORNECE"	,cFornece       	 			,Nil})
			aadd(aCabec,{"F1_LOJA"  	,cLoja		         			,Nil})

			MSExecAuto({|x,y,z| MATA103(x,y,z)},aCabec,aItensNf,3)


			__nAdto := 0
			__nConv := 0

			aConvenios := u_convenios(SF1->F1_FILIAL,SF1->F1_FORNECE,SF1->F1_LOJA,StrZero(month(SF1->F1_EMISSAO),2)+cValToChar(year(SF1->F1_EMISSAO)),'1')

			For i := 1 to Len(aConvenios)

				If cFilAnt == '02' .and. (aConvenios[i][1] == '001' .or. aConvenios[i][1] == '009')
	    	    __nAdto += aConvenios[i][2]
	    	    Elseif cFilAnt == '02' .and. (aConvenios[i][1] <> '001' .and. aConvenios[i][1] <> '009')
	    	    __nConv += aConvenios[i][2]
	    	    ElseIf cFilAnt == '03' .and. aConvenios[i][1] == '034'
	    	    __nAdto += aConvenios[i][2]
	    	    ElseIf cFilAnt == '03' .and. aConvenios[i][1] <> '034'
	    	    __nConv += aConvenios[i][2]
	    	    ElseIf cFilAnt == '04' .and. (aConvenios[i][1] == '006' .or. aConvenios[i][1] == '009')
	    	    __nAdto += aConvenios[i][2]
	    	    Elseif cFilAnt == '04' .and. (aConvenios[i][1] <> '006' .and. aConvenios[i][1] <> '009')
	    	    __nConv += aConvenios[i][2]
	   			ElseIf cFilAnt == '05' .and. (aConvenios[i][1] == '001' .or. aConvenios[i][1] == '002')
	    	    __nAdto += aConvenios[i][2]
	    	    Elseif cFilAnt == '05' .and. (aConvenios[i][1] <> '001' .and. aConvenios[i][1] <> '002')
	    	    __nConv += aConvenios[i][2]
	    	    ElseIf cFilAnt == '08' .and. (aConvenios[i][1] == '001')
	    	    __nAdto += aConvenios[i][2]
	    	    Elseif cFilAnt == '08' .and. (aConvenios[i][1] <> '001')
	    	    __nConv += aConvenios[i][2]

	    	    ElseIf cFilAnt == '09' .and. (aConvenios[i][1] == '001')
	    	    __nAdto += aConvenios[i][2]
	    	    Elseif cFilAnt == '09' .and. (aConvenios[i][1] <> '001')
	    	    __nConv += aConvenios[i][2]

	    	    ElseIf cFilAnt == '10' .and. (aConvenios[i][1] == '001')
	    	    __nAdto += aConvenios[i][2]
	    	    Elseif cFilAnt == '10' .and. (aConvenios[i][1] <> '001')
	    	    __nConv += aConvenios[i][2]

	    	    Else
	    	    __nAdto += 0
	    		__nConv += 0
	    	    End If

	    	next

			aConvenios := {}

			If lMsErroAuto
				MostraErro()
				//DisarmTransaction()  RONALDO 20/03/09
				Break
			Else
				// Descontos corpo da nota conforme discutido em 12/11/2008
				RecLock("SF1", .F.)

				SF1->F1_XINSS	:= __nFunrura
				SF1->F1_XFRETE	:= __nFrete
				SF1->F1_XOUTROS	:= __nOutros
				SF1->F1_XLINHA	:= LBB->LBB_LINHA
				SF1->F1_XSUBST	:= __nSubsttr
				SF1->F1_XADTO	:= __nAdto
				SF1->F1_XCONV	:= __nConv

				IF cFilAnt <> '09'
					Posicione("SD1",1,SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA),"D1_VLINCMG")
					SF1->F1_XLIQUID	:= round( ( SF1->F1_VALMERC + SD1->D1_VLINCMG - (__nFunrura + __nFrete + __nOutros) ) , 2)
					SF1->F1_XINCEN	:= SD1->D1_VLINCMG
				else
					SF1->F1_XLIQUID	:= round( ( SF1->F1_VALMERC + nIncent - (__nFunrura + __nFrete + __nOutros) ) , 2)
					SF1->F1_XINCEN	:= nIncent
				End IF


				*Desabilitado nao credita mais pis e cofins - WILSON 21/03/2012
				//* Wilson 17/03/10 - Campo criado para evitar dif.arredondamento na contabilizacao.
				//SF1->F1_XVLRPIS	:=	Round( ( (SF1->F1_VALBRUT+SF1->F1_XINCEN)*0.0099),2)
				//SF1->F1_XVLRCOF	:=	Round( ( (SF1->F1_VALBRUT+SF1->F1_XINCEN)*0.0456),2)
				//*
				MsUnlock()

				If !Empty(__nFunrura) //Ajusta FUNRURAL campo padrใo TOTVS

					RecLock("SF1", .F.)
						SF1->F1_BASEFUN := SF1->F1_VALBRUT
						SF1->F1_CONTSOC	:= ROUND(SF1->F1_VALBRUT*0.013,2)
						SF1->F1_VLSENAR := ROUND(SF1->F1_VALBRUT*0.001,2) //SF1->F1_VLSENAR := ROUND(SF1->F1_VALBRUT*0.002,2)
					MsUnlock()

					Posicione("SD1",1,SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA),"D1_BASEFUN")

					If SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
						RecLock("SD1", .F.)
							SD1->D1_BASEFUN := SF1->F1_BASEFUN
							SD1->D1_ALIQFUN := 1.3
							SD1->D1_VALFUN  := SF1->F1_CONTSOC
							SD1->D1_BSSENAR := SF1->F1_BASEFUN
							SD1->D1_ALSENAR := 0.2 //SD1->D1_ALSENAR := 0.1
							SD1->D1_VLSENAR := ROUND(SF1->F1_BASEFUN*0.002,2) //SD1->D1_VLSENAR := ROUND(SF1->F1_BASEFUN*0.001,2)

						MsUnlock()
					EndIf

				EndIF
				/*RecLock("SF1", .F.)

				IF cFilAnt <> '09'
					SF1->F1_XLIQUID	:= round( ( SF1->F1_VALMERC + SD1->D1_VLINCMG - (__nFunrura + __nFrete + __nOutros) ) , 2)
					SF1->F1_XINCEN	:= SD1->D1_VLINCMG
				else
					SF1->F1_XLIQUID	:= round( ( SF1->F1_VALMERC + nIncent - (__nFunrura + __nFrete + __nOutros) ) , 2)
					SF1->F1_XINCEN	:= nIncent
				End IF

				MsUnlock()
                */
			Endif

			nSeq += 1

			nTotSenar += nTotDesc
			nTotFunr  += aItens[k][13][6]

			//cPerg    	:= "QUA22B"
			//Pergunte(cPerg, .F.)

			If !lMsErroAuto

				DbSelectArea("LBP")
				dbSetOrder(1)
				If dbSeek(xFilial("LBP") + aItens[k][11] + dtos( dMVPAR_01 ), .F.)
					RecLock("LBP",.f.)
					LBP->LBP_NOTA   := SF1->F1_DOC
					LBP->LBP_SERIE  := SF1->F1_SERIE
					MsUnlock()
				Else
					MsgStop("Erro. Nao achou o arq. fechamento: " + aItens[k][11] + Dtos(dMVPAR_01)) //
				EndIf

			Endif

			DbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+cCodLeite))
		Next

/* desabilitado por wmanfre em 16/01/2009
		If !lMsErroAuto

			If nTotSenar > 0		// gera็ใo de titulo do SENAR
				SA2->(dbSetorder(1))
				SA2->(dbSeek(xFilial("SA2")+alltrim(GetMv("MV_FORINSS"))))

				cModulo := "FIN"
				nModulo := 6

				DbSelectArea("SE2")
				dbSetOrder(1)    // E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA
				_cPrefix	:= padr("SEN", tamsx3("E2_PREFIXO")[1])
				_cNum		:= ProxNum()
				_cParcela	:= Iif(GetMv("MV_1DUP")="A", padr("A",tamsx3("E2_PARCELA")[1]), padl("01",tamsx3("E2_PARCELA")[1],"0"))
				_cTipo 		:= padr(GetMv("MV_TPTITE2"), tamsx3("E2_TIPO")[1])
				_cCCDeb		:= GetMV("ES_CENCUS",,"")


				if !dbSeek( xFilial("SE2") + _cPrefix + _cNum + _cParcela + _cTipo + SA2->A2_COD + SA2->A2_LOJA )
					aTitSE2 := {}
					lMsErroAuto := .F.

					// Geracao automatica de Titulos do tipo OUTROS CREDITOS
					Aadd(aTitSE2,{"E2_PREFIXO"		,_cPrefix								,Nil})
					Aadd(aTitSE2,{"E2_NUM"    		,_cNum									,Nil})
					Aadd(aTitSE2,{"E2_PARCELA"		,_cParcela  							,Nil})
					Aadd(aTitSE2,{"E2_TIPO"   		,_cTipo									,Nil})
					Aadd(aTitSE2,{"E2_NATUREZ"		,GetMv("ES_NATTIT")  					,Nil})
					Aadd(aTitSE2,{"E2_FORNECE"		,SA2->A2_COD                			,Nil})
					Aadd(aTitSE2,{"E2_LOJA"   		,SA2->A2_LOJA               			,Nil})
					Aadd(aTitSE2,{"E2_EMISSAO"		,dDataFim    							,Nil})
					Aadd(aTitSE2,{"E2_VENCTO" 		,dDataFim + 10							,Nil})
					Aadd(aTitSE2,{"E2_VALOR"  		,nTotSenar		 						,Nil})
					Aadd(aTitSE2,{"E2_CCD"   		,_cCCDeb  								,Nil})
					Aadd(aTitSE2,{"E2_HIST"   		,"Tit. Gerado Fech. Leite - Funrural"  	,Nil})

					MsExecAuto({|x,y|FINA050(x,y)},aTitSE2,3)
					SE2->(MsUnlock())

					If lMsErroAuto = .T.
						MostraErro()
						DisarmTransaction()
						Break
					EndIf
				Else
					ApMsgAlert("Titulo do SENAR ja existente na base, nใo foi gerado","Atencao")
				Endif
			Endif


			If nTotFunr > 0			// Gera็ใo de titulo do FUNRURAL

				SA2->(dbSetorder(1))
				SA2->(dbSeek(xFilial("SA2")+alltrim(GetMv("MV_FORINSS"))))

				cModulo := "FIN"
				nModulo := 6

				DbSelectArea("SE2")
				dbSetOrder(1)
				_cPrefix	:= padr("FUN", tamsx3("E2_PREFIXO")[1])
//				_cNum		:= padr(substr(dtos(dDataFim),1,6), tamsx3("E2_NUM")[1] )
				_cNum		:= ProxNum()
				_cParcela	:= Iif(GetMv("MV_1DUP")="A", padr("A",tamsx3("E2_PARCELA")[1]), padl("1",tamsx3("E2_PARCELA")[1],"0"))
				_cTipo 		:= padr(GetMv("MV_TPTITE2"), tamsx3("E2_TIPO")[1])
				_cCCDeb		:= GetMV("ES_CENCUS",,"")

				if !dbSeek( xFilial("SE2") + _cPrefix + _cNum + _cParcela + _cTipo + SA2->A2_COD + SA2->A2_LOJA )


					aTitSE2 := {}
					lMsErroAuto := .F.

					// Geracao automatica de Titulos do tipo OUTROS CREDITOS
					Aadd(aTitSE2,{"E2_PREFIXO"		,_cPrefix								,Nil})
					Aadd(aTitSE2,{"E2_NUM"    		,_cNum									,Nil})
					Aadd(aTitSE2,{"E2_PARCELA"		,_cParcela  							,Nil})
					Aadd(aTitSE2,{"E2_TIPO"   		,_cTipo									,Nil})
					Aadd(aTitSE2,{"E2_NATUREZ"		,GetMv("ES_NATTIT")  					,Nil})
					Aadd(aTitSE2,{"E2_FORNECE"		,SA2->A2_COD                			,Nil})
					Aadd(aTitSE2,{"E2_LOJA"   		,SA2->A2_LOJA               			,Nil})
					Aadd(aTitSE2,{"E2_EMISSAO"		,dDataFim    							,Nil})
					Aadd(aTitSE2,{"E2_VENCTO" 		,dDataFim + 10							,Nil})
					Aadd(aTitSE2,{"E2_VALOR"  		,nTotFunr		 						,Nil})
					Aadd(aTitSE2,{"E2_CCD"   		,_cCCDeb  								,Nil})
					Aadd(aTitSE2,{"E2_HIST"   		,"Tit. Gerado Fech. Leite - Funrural"  	,Nil})

					MsExecAuto({|x,y|FINA050(x,y)},aTitSE2,3)
					SE2->(MsUnlock())

					If lMsErroAuto = .T.
						MostraErro()
						DisarmTransaction()
						Break
					EndIf
				Else
					ApMsgAlert("Titulo do FUNRURAL ja existente na base, nใo foi gerado","Atencao")
				Endif
			Endif
		Endif
fim do bloco desabilitado por wmanfre
*/

	   //	End Transaction   RONALDO 20/03/09

		cModulo := cModOrig
		nModulo := nModOrig

Endif
Return Nil




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GerCP(oProces2, cMesAno)

Local nXa	:= 0
Local nXb	:= 0
Local nSeq	:= 0
Local nModOrig	:= nModulo
Local cModOrig	:= cModulo
Local _cFornPS  := GetMV("QU_FORNCON",,"") 		// WMS.nn em 30/08/2016 - Chamado 4758

Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.
Private cPrefixo	:= "TST"
Private _cCCDeb		:= GetMV("ES_CENCUS",,"")
Private _cNatureza	:= ""

If MsgYesNo("Confima a Gera็ใo dos contas a Pagar","Confirma")

If GetMv("MV_DTFCHPG") >= dDataBase
MsgStop("Contas a pagar desse perํodo ja foi gerado !","Atencao")
return
End If

PutMv("MV_DTFCHPG",dDatabase)

oProces2:SetRegua2(Len(aItens))

_cNatureza := GetMV("ES_NATPRO")

cModulo := "FIN"
nModulo := 6


//Alterado por Roberto R.Mezzalira - CHAMADO 000933 02/03/17  ALterado a forma de gerar o vencimento atraves de uma condicao de pagto
//_dDataVen	:= cTod(Alltrim(GetMV("ES_VCTPRD",,"20"))+"/"+StrZero(iif(Month(dDataFim)+1>12,1,Month(dDataFim)+1),2)+"/"+StrZero(iif(Month(dDataFim)+1>12,Year(dDataFim)+1,Year(dDataFim)),4))
aNwdt 		:= {}
DBSELECTAREA("SE4")
DBSETORDER(1)//E4_FILIAL+E4_CODIGO
IF DBSEEK(XFILIAL("SE4")+GetMV("ES_VCTPRD"))

	aNwdt 		:= Condicao(1000, GetMV("ES_VCTPRD"),0,ddatabase,0)
	_dDataVen	:= IIF(EMPTY(aNwdt[1][1]),cTod("19/"+StrZero(iif(Month(dDataFim)+1>12,1,Month(dDataFim)+1),2)+"/"+StrZero(iif(Month(dDataFim)+1>12,Year(dDataFim)+1,Year(dDataFim)),4)),aNwdt[1][1])

ELSE
	_dDataVen	:= cTod("19/"+StrZero(iif(Month(dDataFim)+1>12,1,Month(dDataFim)+1),2)+"/"+StrZero(iif(Month(dDataFim)+1>12,Year(dDataFim)+1,Year(dDataFim)),4))

ENDIF

For nXa := 1 to Len(aItens)

	oProces2:IncRegua2("Gerando titulos de produtores - "+"Registro: "+cValToChar(nXa)+" De: "+cValToChar( len(aItens) ))

	dbSelectArea("LBB")
	dbSetOrder(1)

	If dbSeek( xFilial("LBB") + aItens[nXa][11] )
		dbSelectArea("SA2")
		dbSetOrder(1)
//// 	If dbSeek( xFilial("SA2") + LBB->( LBB_CODFOR + LBB_LOJA ) )
		If dbSeek( xFilial("SA2") + LBB->( LBB_CODFOR + LBB_LOJA ) )  .And. !(LBB->LBB_CODFOR + LBB->LBB_LOJA $ _cFornPS )  // WMS.nn em 30/08/2016 - Chamado 4758
			nConvenio := 0
			nPosq := ascan(aAbat, {|x| Alltrim(UPPER(x[1])) == Alltrim(UPPER("F" + LBB->LBB_CODPRO)) } )
			If nPosq > 0
				nConvenio := aAbat[nPosq][6]
			Endif
			//				Valor nota              Incentivo
//			nLiquid2 :=  (aItens[nXa][13][2]  + aItens[nXa][13][5] )
            nLiquid2 := aItens[nXa][13][1]
			//			 Liquido   -  Frete            -  Funrural          -  ST                - Convenios
			nLiquid2 :=  nLiquid2 - aItens[nXa][13][4] - aItens[nXa][13][6] - aItens[nXa][13][7] - nConvenio


			nSeq ++

//			_cPrefix	:= padr("P"+substr(dtos(dDataFim),5,2), tamsx3("E2_PREFIXO")[1])
			_cPrefix	:= &(GetMv("MV_1DUPREF"))
//			_cNum		:= padr(substr(dtos(dDataFim),5,2)+strzero(nSeq,4), tamsx3("E2_NUM")[1] )
			_cNum		:= ProxNum()
			_cParcela	:= Iif(GetMv("MV_1DUP")="A", padr("A",tamsx3("E2_PARCELA")[1]), padl("1",tamsx3("E2_PARCELA")[1],"0"))
			_cTipo 		:= padr(GetMv("MV_TPTITE2"), tamsx3("E2_TIPO")[1])
			//Alterado por Roberto R.Mezzalira - CHAMADO 000469 ALterado a forma de gerar o vencimento atraves de uma condicao de pagto
			//_dDataVen	:= cTod(Alltrim(GetMV("ES_VCTPRD",,"20"))+"/"+StrZero(iif(Month(dDataFim)+1>12,1,Month(dDataFim)+1),2)+"/"+StrZero(iif(Month(dDataFim)+1>12,Year(dDataFim)+1,Year(dDataFim)),4))
			// aNwdt 		:= {}
			 //aNwdt 		:= Condicao(nLiquid2,GetMV("ES_VCTPRD"),0,ddatabase,0)
           //_dDataVen	:=   aNwdt[1][1]

			IF nLiquid2 > 0 .and. _dDataVen  >= dDataFim
				DbSelectArea("SE2")
				aTitSE2 := {}

				// Geracao automatica de Titulos do tipo OUTROS CREDITOS
//				Aadd(aTitSE2,{"E2_FILIAL" 		,xFilial("SE2")  								,Nil})
				Aadd(aTitSE2,{"E2_PREFIXO"		,_cPrefix										,Nil})
				Aadd(aTitSE2,{"E2_NUM"    		,_cNum											,Nil})
				Aadd(aTitSE2,{"E2_PARCELA"		,_cParcela  									,Nil})
				Aadd(aTitSE2,{"E2_TIPO"   		,_cTipo											,Nil})
				Aadd(aTitSE2,{"E2_NATUREZ"		,_cNatureza  									,Nil})
				Aadd(aTitSE2,{"E2_FORNECE"		,SA2->A2_COD                					,Nil})
				Aadd(aTitSE2,{"E2_LOJA"   		,SA2->A2_LOJA               					,Nil})
				Aadd(aTitSE2,{"E2_NOMFOR"  		,SA2->A2_NOME               					,Nil})
				Aadd(aTitSE2,{"E2_EMISSAO"		,dDataFim    									,Nil})
				Aadd(aTitSE2,{"E2_VENCTO" 		,_dDataVen										,Nil})
				Aadd(aTitSE2,{"E2_VENCREA" 		,DataValida(_dDataVen)							,Nil})
				Aadd(aTitSE2,{"E2_VALOR"  		,nLiquid2		 								,Nil})
//				Aadd(aTitSE2,{"E2_HIST"   		,"Tit. Gerado Fech. Leite - Pagamento Leite"  	,Nil}) 		// WMS.sn em 30/08/2016 - Chamado 4758
				Aadd(aTitSE2,{"E2_HIST"   		,"Tit.Fech.Leite-Pagt.Leite"  					,Nil}) 		// WMS.en em 30/08/2016 - Chamado 4758
				Aadd(aTitSE2,{"E2_VLCRUZ"  		,nLiquid2	 									,Nil})
				Aadd(aTitSE2,{"E2_CCD"   		,_cCCDeb  										,Nil})
				Aadd(aTitSE2,{"E2_XLINHA"  		,LBB->LBB_LINHA									,Nil})

				MsExecAuto({|x,y|FINA050(x,y)},aTitSE2,3)
				SE2->(MsUnlock())

				If lMsErroAuto = .T.
					MostraErro()
					DisarmTransaction()
					Break
				EndIf

			Else

				If nLiquid2 <> 0 .and. _dDataVen  >= dDataFim
//				    if U_DescCar(SA2->A2_COD, SA2->A2_LOJA, nLiquid2 )
						DbSelectArea("SE2")
						aTitSE2 := {}

						// Geracao automatica de Titulos do tipo OUTROS CREDITOS
//						Aadd(aTitSE2,{"E2_FILIAL" 		,xFilial("SE2")  								,Nil})
						Aadd(aTitSE2,{"E2_PREFIXO"		,_cPrefix										,Nil})
						Aadd(aTitSE2,{"E2_NUM"    		,_cNum											,Nil})
						Aadd(aTitSE2,{"E2_PARCELA"		,_cParcela  									,Nil})
						//Aadd(aTitSE2,{"E2_TIPO"   		,_cTipo											,Nil})
						Aadd(aTitSE2,{"E2_TIPO"   		,PAdr("NDF",TamSX3("E2_TIPO")[1])				,Nil})
						Aadd(aTitSE2,{"E2_NATUREZ"		,_cNatureza		 								,Nil})
						Aadd(aTitSE2,{"E2_FORNECE"		,SA2->A2_COD                					,Nil})
						Aadd(aTitSE2,{"E2_LOJA"   		,SA2->A2_LOJA               					,Nil})
						Aadd(aTitSE2,{"E2_NOMFOR"  		,SA2->A2_NOME              						,Nil})
						Aadd(aTitSE2,{"E2_EMISSAO"		,dDataFim    									,Nil})
						Aadd(aTitSE2,{"E2_VENCTO" 		,_dDataVen										,Nil})
						Aadd(aTitSE2,{"E2_VENCREA" 		,DataValida(_dDataVen)							,Nil})
						Aadd(aTitSE2,{"E2_VALOR"  		,abs(nLiquid2)		 							,Nil})
						//Aadd(aTitSE2,{"E2_HIST"   		,"Tit. Gerado Fech. Leite - Pagamento Leite"  	,Nil})
						Aadd(aTitSE2,{"E2_HIST"   		,"Debito Saldo Negativo Mes Anterior"		  	,Nil})
						Aadd(aTitSE2,{"E2_VLCRUZ"  		,abs(nLiquid2) 									,Nil})
						Aadd(aTitSE2,{"E2_CCD"   		,_cCCDeb  										,Nil})
						Aadd(aTitSE2,{"E2_XLINHA"  		,LBB->LBB_LINHA									,Nil})

						MsExecAuto({|x,y|FINA050(x,y)},aTitSE2,3)
						SE2->(MsUnlock())

						If lMsErroAuto = .T.
							MostraErro()
							DisarmTransaction()
							Break
						EndIf
//					Endif
				Endif
			Endif
		Endif
	Endif
next nXA

oProces2:SetRegua2(Len(aPagar))

_cNatureza := GetMV("ES_NATPRO")

For nXa := 1 to Len(aPagar)


	oProces2:IncRegua2("Gerando titulos de Carreteiros - "+"Registro: "+cValToChar(nXa)+" De: "+cValToChar( len(aPagar) ))

	If left(aPagar[nXA][1],1) == "C"

		dbSelectArea("SA2")
		dbSetOrder(1)

		dbSelectArea("LBE")
		dbSetOrder(2)

		If dbSeek( xFilial("LBE") + aPagar[nXa][2] )

			dbSelectArea("SA2")
			If dbSeek( xFilial("SA2") + LBE->( LBE_FORNEC + LBE_LOJA ) )

				nAbatimentos := 0
				nPosq := ascan(aAbat, {|x| Alltrim(UPPER(x[1])) == Alltrim(UPPER("C" + aPagar[nXa][2])) } )
				If nPosq > 0
					nAbatimentos := aAbat[nPosq][6]
				Endif

				nConvenio := 0

				dbSelectArea("LBB")
				dbSetOrder(2)
				If dbSeek( xFilial("LBB") + SA2->A2_COD + SA2->A2_LOJA )
					nPosq := ascan(aAbat, {|x| Alltrim(UPPER(x[1])) == Alltrim(UPPER("F" + LBB->LBB_CODPRO)) } )
					If nPosq > 0
						nConvenio := aAbat[nPosq][6]
					Endif
				Endif

				nLiquid2 :=  aPagar[nXA][6]
				//
				nLiquid2 :=  nLiquid2 - nConvenio - nAbatimentos

				nSeq ++

//				_cPrefix	:= padr("C"+substr(dtos(dDataFim),5,2), tamsx3("E2_PREFIXO")[1])
				_cPrefix	:= &(GetMv("MV_1DUPREF"))
//				_cNum		:= padr(substr(dtos(dDataFim),5,2)+strzero(nSeq,4), tamsx3("E2_NUM")[1] )
				_cNum		:= ProxNum()
				_cParcela	:= Iif(GetMv("MV_1DUP")="A", padr("A",tamsx3("E2_PARCELA")[1]), padl("1",tamsx3("E2_PARCELA")[1],"0"))
				_cTipo 		:= padr(GetMv("MV_TPTITE2"), tamsx3("E2_TIPO")[1])
				_dDataVen	:= cTod(Alltrim(GetMV("ES_VCTCAR",,"20"))+"/"+StrZero(iif(Month(dDataFim)+1>12,1,Month(dDataFim)+1),2)+"/"+StrZero(iif(Month(dDataFim)+1>12,Year(dDataFim)+1,Year(dDataFim)),4))


				IF nLiquid2 > 0 .and. _dDataVen  >= dDataFim
					DbSelectArea("SE2")
					aTitSE2 := {}

					// Geracao automatica de Titulos do tipo OUTROS CREDITOS
//					Aadd(aTitSE2,{"E2_FILIAL" 		,xFilial("SE2")  								,Nil})
					Aadd(aTitSE2,{"E2_PREFIXO"		,_cPrefix										,Nil})
					Aadd(aTitSE2,{"E2_NUM"    		,_cNum											,Nil})
					Aadd(aTitSE2,{"E2_PARCELA"		,_cParcela  									,Nil})
					Aadd(aTitSE2,{"E2_TIPO"   		,_cTipo											,Nil})
					Aadd(aTitSE2,{"E2_NATUREZ"		,_cNatureza		  								,Nil})
					Aadd(aTitSE2,{"E2_FORNECE"		,SA2->A2_COD                					,Nil})
					Aadd(aTitSE2,{"E2_LOJA"   		,SA2->A2_LOJA               					,Nil})
					Aadd(aTitSE2,{"E2_NOMFOR"  		,SA2->A2_NOME              						,Nil})
					Aadd(aTitSE2,{"E2_EMISSAO"		,dDataFim    									,Nil})
					Aadd(aTitSE2,{"E2_VENCTO" 		,_dDataVen										,Nil})
					Aadd(aTitSE2,{"E2_VENCREA" 		,DataValida(_dDataVen)							,Nil})
					Aadd(aTitSE2,{"E2_VALOR"  		,nLiquid2		 								,Nil})
					Aadd(aTitSE2,{"E2_HIST"   		,"Tit. Gerado Fech. Leite - Pagamento Carreteiro"  	,Nil})
					Aadd(aTitSE2,{"E2_VLCRUZ"  		,nLiquid2	 									,Nil})
					Aadd(aTitSE2,{"E2_CCD"   		,_cCCDeb  										,Nil})

					MsExecAuto({|x,y|FINA050(x,y)},aTitSE2,3)
					SE2->(MsUnlock())

					If lMsErroAuto = .T.
						MostraErro()
						DisarmTransaction()
						Break
					EndIf

				Else
					If nLiquid2 <> 0 .and. _dDataVen  >= dDataFim
					DbSelectArea("SE2")
					aTitSE2 := {}

					// Geracao automatica de Titulos do tipo OUTROS CREDITOS
//					Aadd(aTitSE2,{"E2_FILIAL" 		,xFilial("SE2")  									,Nil})
					Aadd(aTitSE2,{"E2_PREFIXO"		,_cPrefix											,Nil})
					Aadd(aTitSE2,{"E2_NUM"    		,_cNum												,Nil})
					Aadd(aTitSE2,{"E2_PARCELA"		,_cParcela  										,Nil})
					Aadd(aTitSE2,{"E2_TIPO"   		,padr("NDF",TamSx3("E2_TIPO")[1])					,Nil})
					Aadd(aTitSE2,{"E2_NATUREZ"		,_cNatureza		  									,Nil})
					Aadd(aTitSE2,{"E2_FORNECE"		,SA2->A2_COD                						,Nil})
					Aadd(aTitSE2,{"E2_LOJA"   		,SA2->A2_LOJA               						,Nil})
					Aadd(aTitSE2,{"E2_NOMFOR"  		,SA2->A2_NOME               						,Nil})
					Aadd(aTitSE2,{"E2_EMISSAO"		,dDataFim    										,Nil})
					Aadd(aTitSE2,{"E2_VENCTO" 		,_dDataVen											,Nil})
					Aadd(aTitSE2,{"E2_VENCREA" 		,DataValida(_dDataVen)								,Nil})
					Aadd(aTitSE2,{"E2_VALOR"  		,abs(nLiquid2)		 								,Nil})
					//Aadd(aTitSE2,{"E2_HIST"   		,"Tit. Gerado Fech. Leite - Pagamento Carreteiro"  	,Nil})
					Aadd(aTitSE2,{"E2_HIST"   		,"Debito Saldo Negativo Mes Anterior"  							,Nil})
					Aadd(aTitSE2,{"E2_VLCRUZ"  		,abs(nLiquid2)	 									,Nil})
					Aadd(aTitSE2,{"E2_CCD"   		,_cCCDeb  	  										,Nil})

					MsExecAuto({|x,y|FINA050(x,y)},aTitSE2,3)
					SE2->(MsUnlock())

					If lMsErroAuto = .T.
						MostraErro()
						DisarmTransaction()
						Break
					EndIf
					Endif
				Endif

			Endif
		Endif
	Endif
next nXA


oProces2:SetRegua2(Len(aPagar))

_cNatureza := GetMV("ES_NATPRO")

For nXa := 1 to Len(aPagar)
	If aPagar[nXa][6] <> 0

	oProces2:IncRegua2("Gerando titulos de Fornecedores - "+"Registro: "+cValToChar(nXa)+" De: "+cValToChar( len(aPagar) ))
	If left(aPagar[nXA][1],1) == "F"
		dbSelectArea("SA2")
		dbSetOrder(1)

		If dbSeek( xFilial("SA2") + aPagar[nXa][2] )

			nSeq ++
			DbSelectArea("SE2")
			aTitSE2 := {}
//			_cPrefix	:= padr("F"+substr(dtos(dDataFim),5,2), tamsx3("E2_PREFIXO")[1])
			_cPrefix	:= &(GetMv("MV_1DUPREF"))
//			_cNum		:= padr(substr(dtos(dDataFim),5,2)+strzero(nSeq,4), tamsx3("E2_NUM")[1] )
			_cNum		:= ProxNum()
			_cParcela	:= Iif(GetMv("MV_1DUP")="A", padr("A",tamsx3("E2_PARCELA")[1]), padl("1",tamsx3("E2_PARCELA")[1],"0"))
			_cTipo 		:= padr(GetMv("MV_TPTITE2"), tamsx3("E2_TIPO")[1])

			If aPagar[nXA][3] >= dDataFim
			// Geracao automatica de Titulos do tipo OUTROS CREDITOS
//			Aadd(aTitSE2,{"E2_FILIAL" 		,xFilial("SE2")  									,Nil})
			Aadd(aTitSE2,{"E2_PREFIXO"		,_cPrefix											,Nil})
			Aadd(aTitSE2,{"E2_NUM"    		,_cNum												,Nil})
			Aadd(aTitSE2,{"E2_PARCELA"		,_cParcela  										,Nil})
			Aadd(aTitSE2,{"E2_TIPO"   		,_cTipo												,Nil})
			Aadd(aTitSE2,{"E2_NATUREZ"		,_cNatureza		  									,Nil})
			Aadd(aTitSE2,{"E2_FORNECE"		,SA2->A2_COD                						,Nil})
			Aadd(aTitSE2,{"E2_LOJA"   		,SA2->A2_LOJA               						,Nil})
			Aadd(aTitSE2,{"E2_NOMFOR"  		,SA2->A2_NOME               						,Nil})
			Aadd(aTitSE2,{"E2_EMISSAO"		,dDataFim    										,Nil})
			Aadd(aTitSE2,{"E2_VENCTO" 		,aPagar[nXA][3]										,Nil})
			Aadd(aTitSE2,{"E2_VENCREA" 		,DataValida(aPagar[nXA][3])							,Nil})
			Aadd(aTitSE2,{"E2_VALOR"  		,aPagar[nXA][6]	 									,Nil})
			Aadd(aTitSE2,{"E2_HIST"   		,"Tit. Gerado Fech. Leite - Pagamento Fornecedor"  	,Nil})
			Aadd(aTitSE2,{"E2_VLCRUZ"  		,aPagar[nXA][6]	 									,Nil})
			Aadd(aTitSE2,{"E2_CCD"   		,_cCCDeb  											,Nil})

			MsExecAuto({|x,y|FINA050(x,y)},aTitSE2,3)
			SE2->(MsUnlock())

			If lMsErroAuto = .T.
				MostraErro()
				DisarmTransaction()
				Break
			EndIf
			Endif
		Endif
	Endif
	Endif
next nXA

//End Transaction

Endif


cModulo := cModOrig
nModulo := nModOrig

Return nil





/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAA022B บ Autor ณ wmanfre                   ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fechamento mensal da capta็ใo de leite            	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUATA	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GerPedV(oProces2, cMesAno)

Local nXA		:= 0
Local cModOrig	:= cModulo
Local nModOrig	:= nModulo

Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.
Private aCabIntem	:= {}
Private aCabPed		:= {}
Private aItemPed	:= {}
Private nCodMoe		:= 1
Private nTaxa		:= 1

oProces2:SetRegua2(Len(aPedidos))

cModulo := "FAT"
nModulo := 5

If MsgYesNo("Confirma a Gera็ใo dos pedidos de venda para carreteiros?","Confirma")

//Begin Transaction

For nXa := 1 to Len(aPedidos)
	If aPedidos[nXA][4] > 0

	oProces2:IncRegua2("Gerando Pedidos de Venda de Carreteiros - "+"Registro: "+cValToChar(nXa)+" De: "+cValToChar( len(aPedidos) ))

	dbSelectArea("SA2")
	dbSetOrder(1)

	dbSelectArea("LBE")
	dbSetOrder(2)

	If dbSeek( xFilial("LBE") + aPedidos[nXa][2] )

		dbSelectArea("SA2")
		If dbSeek( xFilial("SA2") + LBE->( LBE_FORNEC + LBE_LOJA ) )
            cNum := GetSx8Num("SC5", "C5_NUM")
            RollBackSx8()

			aCabPed := {}
			aAdd(aCabPed,{"C5_NUM"     ,   	cNum ,                     		NIL})
			aAdd(aCabPed,{"C5_TIPO"    ,   	"B" ,                     		NIL})
			aAdd(aCabPed,{"C5_EMISSAO" ,   	dDataFim,             			NIL})
			aAdd(aCabPed,{"C5_CLIENTE" ,   	SA2->A2_COD,                 	NIL})
			aAdd(aCabPed,{"C5_LOJACLI" ,  	SA2->A2_LOJA,                   NIL})
			aAdd(aCabPed,{"C5_U_TIPO" ,   	"01",                    		NIL})
			aAdd(aCabPed,{"C5_TRANSP" ,   	GetMV("ES_TRANSPOR",,"000001"),	NIL})
			aAdd(aCabPed,{"C5_CONDPAG" ,   	GetMv("MV_CONDPAD",,"009"),     NIL})
//			aAdd(aCabPed,{"C5_LOJAENT" ,   	xFilial("SC5"),             	NIL})
			aAdd(aCabPed,{"C5_MOEDA" ,     	nCodMoe,                  		NIL})
			aAdd(aCabPed,{"C5_TXMOEDA" ,   	nTaxa,                    		NIL})
			aAdd(aCabPed,{"C5_TIPOCLI" ,   	"F",                			NIL})
			aAdd(aCabPed,{"C5_TABELA" ,    	GetMv("ES_TABELA",,"011"),      ".T."})
			aAdd(aCabPed,{"C5_VEND1" ,     	GetMv("ES_REPQUAT",,"000001"), 	NIL})
			aAdd(aCabPed,{"C5_COMIS1" ,    	0.00,                     		NIL})
			aAdd(aCabPed,{"C5_VEND4" ,     	GetMv("ES_REPCRIS",,"000047"), 	NIL})
			aAdd(aCabPed,{"C5_COMIS4" ,    	0.00,                     		NIL})
			aAdd(aCabPed,{"C5_DESC1" ,     	0.00,                     		NIL})
			aAdd(aCabPed,{"C5_DESCFI" ,    	0.00,             				NIL})
			aAdd(aCabPed,{"C5_TIPLIB" ,    	"1",                     	 	NIL})
			aAdd(aCabPed,{"C5_TPFRETE" ,   	'C', 							NIL})
			aCabItem:={}
			aItemPed := {}
			nItem:=1

			dbSelectArea("LBN")
			dbSetOrder(1)
			if dbSeek(xFilial("LBN")+GetMV("ES_TIPLEI",,"A"))
				cCodLeite := LBN->LBN_PRODUT
			Endif
			cTES	  := GetMV("ES_TESCAR",,"501")


			SB1->(DbGoTop())
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1") + cCodLeite))

			SF4->(DbGoTop())
			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4") + cTES))

			cCFB     := SF4->F4_CF

				aAdd(aCabItem,{"C6_NUMERO",   cNum,               		NIL})
//				aAdd(aCabItem,{"C6_ITEM",     strZero(nItem,TamSX3("C6_ITEM")[1]),   		NIL})
				aAdd(aCabItem,{"C6_PRODUTO",  SB1->B1_COD,          	NIL})
				aAdd(aCabItem,{"C6_DESCRI",   SB1->B1_DESC,           	NIL})
				aAdd(aCabItem,{"C6_UM",       SB1->B1_UM,             	NIL})
				aAdd(aCabItem,{"C6_QTDVEN",   aPedidos[nXA][4],         NIL})
				aAdd(aCabItem,{"C6_PRCVEN",   aPedidos[nXA][5],         NIL})
				aAdd(aCabItem,{"C6_VALOR",    aPedidos[nXA][6],         NIL})
				aAdd(aCabItem,{"C6_QTDLIB",   aPedidos[nXA][4],         NIL})
				aAdd(aCabItem,{"C6_TES",      cTES ,                	NIL})
				aAdd(aCabItem,{"C6_CF",       cCFB,                 	NIL})
				aAdd(aCabItem,{"C6_DESCONT",  0.00,               		NIL})
				aAdd(aCabItem,{"C6_VALDESC",  0.00,               		NIL})
				aAdd(aCabItem,{"C6_ENTREG",   dDataFim,      			NIL})
				aAdd(aCabItem,{"C6_COMIS1",   0.00,       				NIL})
				aAdd(aCabItem,{"C6_PRUNIT",   aPedidos[nXA][5],         NIL})
				aAdd(aCabItem,{"C6_LOCAL",    SB1->B1_LOCPAD,     		NIL})

				aAdd(aItemPed, aCabItem)
				nItem ++
				aCabItem := {}

			MsExecAuto({|x,y,z|Mata410( x, y, z)},aCabPed,aItemPed,3)

			If lMsErroAuto = .T.
				MostraErro()
				DisarmTransaction()
				Break
			EndIf

		Endif
	Endif
	Endif

next nXA

//End Transaction

Endif

cModulo := cModOrig
nModulo := nModOrig

Return nil


Static Function ArredFret(oProces2)

Local nXa 		:= 0
Local nTotFret	:= 0
Local nTotDesc	:= 0
Local nPerc 	:= 0


nCount 	:= 0
nRec	:= Len(aPagar)+len(aPagar)+Len(aItens)

oProces2:IncRegua1( "Fazendo Ajustes de arrendondamentos")
oProces2:SetRegua2( nRec )

For nXa := 1 to Len(aPagar)

	oProces2:IncRegua2( "Registro.: "+cValToChar(nXa)+" De: "+cValtochar(nRec)  )
	If left(aPagar[nXA][1],1) == "C"

		dbSelectArea("SA2")
		dbSetOrder(1)

		dbSelectArea("LBE")
		dbSetOrder(2)

		If dbSeek( xFilial("LBE") + aPagar[nXa][2] )
			dbSelectArea("SA2")
			If dbSeek( xFilial("SA2") + LBE->( LBE_FORNEC + LBE_LOJA ) )
	            nTotFret += aPagar[nXA][6]
			Endif
		Endif
	Endif
next nXA

nCount := len(aPagar)

For nXa := 1 to len(aItens)

	oProces2:IncRegua2( "Registro.: "+cValToChar(nCount+nXa)+" De: "+cValtochar(nRec)  )

	dbSelectArea("LBB")
	dbSetOrder(1)

	If dbSeek( xFilial("LBE") + aItens[nXa][11] )
		dbSelectArea("SA2")
		dbSetOrder(1)
		If dbSeek( xFilial("SA2") + LBB->( LBB_CODFOR + LBB_LOJA ) )

			nTotDesc += aItens[nXa][13][4]

		Endif
	Endif
next nXa

nPerc := nTotFret - nTotDesc
nPerc := 1 + (nPerc / nTotDesc)
//Alert( "Total da folha de carreteiro: " + str(nTotFret) )
//Alert( "Total descontado de frete: " + Str(nTotDesc) )
//Alert( "percentual aplicado ao frete: " + str(nPerc) )

nCount := len(aPagar)+len(aItens)

For nXa := 1 to Len(aItens)

	oProces2:IncRegua2( "Registro.: "+cValToChar(nCount+nXa)+" De: "+cValtochar(nRec)  )
	aItens[nXa][13][4] := Round( (aItens[nXa][13][4] * nPerc), 2 )

next nXa

Return nil


Static Function ArredGer(oProces2)

Local nXa 		:= 0
Local nTotFret	:= 0
Local nTotDesc	:= 0
Local nPerc 	:= 0

nRec := len(aItens)
oProces2:IncRegua1( OemToansi("Refazendo os valores para acerto de totais" ) )

oProces2:SetRegua2( nRec )

For nXa := 1 to Len(aItens)

	oProces2:IncRegua2( "Registro.: "+cValToChar(nXa)+" De: "+cValtochar(nRec)  )

	aPropr := U_CalcVlLi(aItens[nXa][2], aItens[nXa][3], aItens[nXa][5], aItens[nXa][13][4], aItens[nXa][7], aItens[nXa][8], aItens[nXa][9], aItens[nXa][10] )

	aItens[nXA][13][1] := aPropr[1]	// Total
	aItens[nXA][13][2] := aPropr[2]	// Bruto
	aItens[nXA][13][3] := aPropr[3]	// ICMS
	aItens[nXA][13][4] := aPropr[4]	// Frete
	aItens[nXA][13][5] := aPropr[5]	// Incentivo
	aItens[nXA][13][6] := aPropr[6]	// Funrural
	aItens[nXA][13][7] := aPropr[7]	// Subst trib
	aItens[nXA][13][8] := aPropr[8]	// Fundese
	aItens[nXA][13][9] := aPropr[9]	// Subst. Trib 1
	aItens[nXA][13][10] := aPropr[10]	// valor novo

	aItens[nXA][13][2] := Round(aItens[nXa][13][10] * aItens[nXa][2], 2)
	aItens[nXA][13][1] := Round((aItens[nXa][13][2]  + aItens[nXa][13][5] ),2)
next nXa

Return nil

User Function SalvFec(cMesAno)

Local nXa 	:= 0
Local nXb	:= 0

LimpaPB5(cMesAno)
LimpaPB6(cMesAno)
LimpaPB7(cMesAno)
LimpaPB8(cMesAno)
LimpaPB9(cMesAno)

For nXa := 1 to len(aItens)
	// salva leite diario
	dbSelectArea("PB7")
    RecLock( "PB7", .T. )
    PB7->PB7_MESANO	:= cMesAno
    PB7->PB7_CODPRO	:= aItens[nXa][11]
    PB7->PB7_DIA01	:= aItens[nXa][1][01]
    PB7->PB7_DIA02	:= aItens[nXa][1][02]
    PB7->PB7_DIA03	:= aItens[nXa][1][03]
    PB7->PB7_DIA04	:= aItens[nXa][1][04]
    PB7->PB7_DIA05	:= aItens[nXa][1][05]
    PB7->PB7_DIA06	:= aItens[nXa][1][06]
    PB7->PB7_DIA07	:= aItens[nXa][1][07]
    PB7->PB7_DIA08	:= aItens[nXa][1][08]
    PB7->PB7_DIA09	:= aItens[nXa][1][09]
    PB7->PB7_DIA10	:= aItens[nXa][1][10]
    PB7->PB7_DIA11	:= aItens[nXa][1][11]
    PB7->PB7_DIA12	:= aItens[nXa][1][12]
    PB7->PB7_DIA13	:= aItens[nXa][1][13]
    PB7->PB7_DIA14	:= aItens[nXa][1][14]
    PB7->PB7_DIA15	:= aItens[nXa][1][15]
    PB7->PB7_DIA16	:= aItens[nXa][1][16]
    PB7->PB7_DIA17	:= aItens[nXa][1][17]
    PB7->PB7_DIA18	:= aItens[nXa][1][18]
    PB7->PB7_DIA19	:= aItens[nXa][1][19]
    PB7->PB7_DIA20	:= aItens[nXa][1][20]
    PB7->PB7_DIA21	:= aItens[nXa][1][21]
    PB7->PB7_DIA22	:= aItens[nXa][1][22]
    PB7->PB7_DIA23	:= aItens[nXa][1][23]
    PB7->PB7_DIA24	:= aItens[nXa][1][24]
    PB7->PB7_DIA25	:= aItens[nXa][1][25]
    PB7->PB7_DIA26	:= aItens[nXa][1][26]
    PB7->PB7_DIA27	:= aItens[nXa][1][27]
    PB7->PB7_DIA28	:= aItens[nXa][1][28]
    PB7->PB7_DIA29	:= aItens[nXa][1][29]
    PB7->PB7_DIA30	:= aItens[nXa][1][30]
    PB7->PB7_DIA31	:= aItens[nXa][1][31]
    PB7->PB7_DIA32	:= aItens[nXa][1][32]

    MsUnlock()

	// Grava dados fechamento
	dbSelectArea("PB8")
    RecLock( "PB8", .T. )
    PB8->PB8_MESANO	:= cMesAno
    PB8->PB8_CODPRO	:= aItens[nXa][11]
	PB8->PB8_QTDLTS	:= aItens[nXa][02]
	PB8->PB8_VLRMED	:= aItens[nXa][03]
	PB8->PB8_VLRTOT	:= aItens[nXa][04]
	PB8->PB8_ICMS	:= aItens[nXa][05]
	PB8->PB8_FRETE1	:= aItens[nXa][06]
	PB8->PB8_INCENT	:= aItens[nXa][07]
	PB8->PB8_INSS	:= aItens[nXa][08]
	PB8->PB8_SUBTRI	:= aItens[nXa][09]
	PB8->PB8_FUNDES	:= aItens[nXa][10]
	PB8->PB8_FRETE2	:= aItens[nXa][12]
	PB8->PB8_CODTES	:= aItens[nXa][14]
	PB8->PB8_CODLIN	:= aItens[nXa][15]
	MsUnlock()

	//Grava Liquido
	dbSelectArea("PB9")
	ReckLock("PB9")
    PB9->PB9_MESANO	:= cMesAno
    PB9->PB9_CODPRO	:= aItens[nXa][11]
	PB9->PB9_TOTAL	:= aItens[nXa][13][01]
	PB9->PB9_LIQUID	:= aItens[nXa][13][02]
	PB9->PB9_ICMS	:= aItens[nXa][13][03]
	PB9->PB9_FRETE	:= aItens[nXa][13][04]
	PB9->PB9_INCENT	:= aItens[nXa][13][05]
	PB9->PB9_INSS	:= aItens[nXa][13][06]
	PB9->PB9_SUBTRI	:= aItens[nXa][13][07]
	PB9->PB9_FUNDES	:= aItens[nXa][13][08]
	PB9->PB9_STLIQ	:= aItens[nXa][13][09]
	PB9->PB9_MEDFRT	:= aItens[nXa][13][10]
	MSUNLOCK()
next nXa

For nXa := 1 to len(aPagar)
	nQtdKms	:= 0
	nQtdLts	:= 0
	nVlMedio:= 0
	dData	:= ctod(' ')
	dDtVenc	:= ctod(' ')

    If left(aPagar[nXa][1],1) == "P"
    	cTipo	:= "PRODUTOR"
        dData	:= aPagar[nXa][3]
		nQtdLts	:= aPagar[nXa][4]
		nVlMedio:= aPagar[nXa][5]

    ElseIF left(aPagar[nXa][1],1) == "C"
    	cTipo 	:= "CARRETEIRO"
		nQtdLts	:= aPagar[nXa][4]
		nVlMedio:= aPagar[nXa][5]
		nQtdKms	:= aPagar[nXa][3]

    Else
    	cTipo	:= "FORNECEDOR"
    	dDtVenc	:= aPagar[nXa][3]
    Endif

	dbSelectArea("PB5")
	RecLock("PB5",.T.)
    PB5->PB5_MESANO	:= cMesAno
    PB5->PB5_CODPRO	:= aPagar[nXa][2]
	PB5->PB5_TIPO	:= cTipo
	PB5->PB5_VLMED  := nVlMedio
	PB5->PB5_QTDKMS := nQtdKms
	PB5->PB5_QTDLTS	:= nQtdLts
	PB5->PB5_VALOR	:= aPagar[nXa][6]
	PB5->PB5_DTENTR	:= dData
	PB5->PB5_DTVENC	:= dDtVenc

	MsUnlock()
next nXa

For nXa := 1 to len(aAbat)
	nQtdLts	:= 0
	nVlMedio:= 0
  	dDtVenc	:= ctod(' ')

    If left(aPagar[nXa][1],1) == "F"
    	cTipo	:= "PRODUTOR"
    	dDtVenc	:= aPagar[nXa][3]

    Else
    	cTipo 	:= "CARRETEIRO"
		nQtdLts	:= aPagar[nXa][4]
		nVlMedio:= aPagar[nXa][5]
    Endif

	dbSelectArea("PB6")
	RecLock("PB6",.T.)
    PB6->PB6_MESANO	:= cMesAno
    PB6->PB6_CODPRO	:= aPagar[nXa][2]
	PB6->PB6_TIPO	:= cTipo
	PB6->PB6_VLMED  := nVlMedio
	PB6->PB6_QTDLTS	:= nQtdLts
	PB6->PB6_VALOR	:= aPagar[nXa][6]
	PB6->PB6_DTVENC	:= dDtVenc

	MsUnlock()
next nXa


Return Nil



Static Function LimpaPB5(cMesAno)

Local cTabela	:= Alltrim(RetSqlName("PB5"))
Local cQuery := ""
Local nOk	:= 0

cQuery += "DELETE FROM " + cTabela
cQuery += "WHERE PB5_MESANO = '" + cMesAno + "' "

nOk := TCSqlExec( cQuery )

If nOk <> 0
    ApMsgAlert("Falha na limpeza da tabela PB5", "Falha")
    Return Nil
Endif

Return Nil


Static Function LimpaPB6(cMesAno)
Local cTabela	:= Alltrim(RetSqlName("PB6"))
Local cQuery := ""
Local nOk	:= 0

cQuery += "DELETE FROM " + cTabela
cQuery += "WHERE PB6_MESANO = '" + cMesAno + "' "

nOk := TCSqlExec( cQuery )

If nOk <> 0
    ApMsgAlert("Falha na limpeza da tabela PB6", "Falha")
    Return Nil
Endif

Return Nil



Static Function LimpaPB7(cMesAno)

Local cTabela	:= Alltrim(RetSqlName("PB7"))
Local cQuery := ""
Local nOk	:= 0

cQuery += "DELETE FROM " + cTabela
cQuery += "WHERE PB7_MESANO = '" + cMesAno + "' "

nOk := TCSqlExec( cQuery )

If nOk <> 0
    ApMsgAlert("Falha na limpeza da tabela PB7", "Falha")
    Return Nil
Endif

Return Nil



Static Function LimpaPB8(cMesAno)

Local cTabela	:= Alltrim(RetSqlName("PB8"))
Local cQuery := ""
Local nOk	:= 0

cQuery += "DELETE FROM " + cTabela
cQuery += "WHERE PB8_MESANO = '" + cMesAno + "' "

nOk := TCSqlExec( cQuery )

If nOk <> 0
    ApMsgAlert("Falha na limpeza da tabela PB8", "Falha")
    Return Nil
Endif
Return nil


Static Function LimpaPB9(cMesAno)
Local cTabela	:= Alltrim(RetSqlName("PB9"))
Local cQuery := ""
Local nOk	:= 0

cQuery += "DELETE FROM " + cTabela
cQuery += "WHERE PB9_MESANO = '" + cMesAno + "' "

nOk := TCSqlExec( cQuery )

If nOk <> 0
    ApMsgAlert("Falha na limpeza da tabela PB9", "Falha")
    Return Nil
Endif
Return Nil



User Function RetFec(cMesAno)

Local nXa 		:= 0
Local nXb		:= 0
Local aTemp		:= {}
Local aTemp1	:= {}
LocaL aTemp2	:= {}

Apagar 	:= {}
aItens	:= {}
aAbat	:= {}

dbSelectArea( "PB8" )
dbSetOrder(1)
dbSeek( xFilial("PB8") + cMesAno )

While !eof() .and. PB8->PB8_MESANO = cMesAno
	dbSelectArea("PB7")
	dbSetOrder(1)
	dbSeek( xFilial("PB7") + cMesAno + PB8->PB8_CODPRO )

	aTemp := Array(32)
	for nxb := 1 to 32
		aTemp[nXb] := 0
	next nXb

	While PB7->(PB7_FILIAL + PB7_MESANO + PB7_CODPRO ) == xFilial("PB7") + cMesAno + PB8->PB8_CODPRO
		For nXb := 1 to 32
			cVar := "PB7->PB7_DIA" + Alltrim(StrZero(nXb,2))
			aTemp[nXb] += &cVar
		Next nXb
		dbSelectArea("PB7")
		dbSkip()
	End

    aTemp1 := Array(10)
	for nxb := 1 to 32
		aTemp1[nXb] := 0
	next nXb

	dbSelectArea("PB9")
	dbSetOrder(1)
	dbSeek( xFilial("PB9") + cMesAno + PB8->PB8_CODPRO )
	While PB9->(PB9_FILIAL + PB9_MESANO + PB9_CODPRO ) == xFilial("PB9") + cMesAno + PB8->PB8_CODPRO
		aTemp1[01] += PB9->PB9_TOTAL
		aTemp1[02] += PB9->PB9_LIQUID
		aTemp1[03] += PB9->PB9_ICMS
		aTemp1[04] += PB9->PB9_FRETE
		aTemp1[05] += PB9->PB9_INCENT
		aTemp1[06] += PB9->PB9_INSS
		aTemp1[07] += PB9->PB9_SUBTRI
		aTemp1[08] += PB9->PB9_FUNDES
		aTemp1[09] += PB9->PB9_STLIQ
		aTemp1[10] += PB9->PB9_MEDFRT
		dbSelectArea("PB9")
		dbSkip()
	End

	aadd( aTemp2, aTemp )
	aadd( aTemp2, PB8->PB8_QTDLTS)
	aadd( aTemp2, PB8->PB8_VLRMED)
	aadd( aTemp2, PB8->PB8_VLRTOT)
	aadd( aTemp2, PB8->PB8_ICMS)
	aadd( aTemp2, PB8->PB8_FRETE1)
	aadd( aTemp2, PB8->PB8_INCENT)
	aadd( aTemp2, PB8->PB8_INSS)
	aadd( aTemp2, PB8->PB8_SUBTRI)
	aadd( aTemp2, PB8->PB8_FUNDES)
    aadd( aTemp2, PB8->PB8_CODPRO)
	aadd( aTemp2, PB8->PB8_FRETE2)
	aadd( aTemp2, aTemp )
	aadd( aTemp2, PB8->PB8_CODTES)
	aadd( aTemp2, PB8->PB8_CODLIN)

	aadd( aItens, aTemp2)

	aTemp := {}
	aTemp1 := {}
	aTemp2 := {}

	dbSelectARea("PB8")
	dbskip()
End

dbSelectArea("PB5")
dbSetOrder(1)
dbSeek(xFilial("PB5") + cMesAno )
While !Eof() .and. PB5->(PB5_FILIAL + PB5_MESANO) == xFilial("PB5") + cMesAno
    aTemp := {}
    If Alltrim(Upper(PB5->PB5_TIPO)) == "PRODUTOR"
	    aadd( aTemp, "P"+PB5->PB5_CODPRO)
	    aadd( aTemp, PB5->PB5_CODPRO)
		aadd( aTemp, PB5->PB5_DTENTR)
		aadd( aTemp, PB5->PB5_QTDLTS)
		aadd( aTemp, PB5->PB5_VLMED)
		aadd( aTemp, PB5->PB5_VALOR)

    ElseIf Alltrim(Upper(PB5->PB5_TIPO)) == "CARRETEIRO"
	    aadd( aTemp, "C"+PB5->PB5_CODPRO)
	    aadd( aTemp, PB5->PB5_CODPRO)
		aadd( aTemp, PB5->PB5_QTDKMS)
		aadd( aTemp, PB5->PB5_QTDLTS)
		aadd( aTemp, PB5->PB5_VLMED)
		aadd( aTemp, PB5->PB5_VALOR)

	Else
	    aadd( aTemp, "F"+PB5->PB5_CODPRO)
	    aadd( aTemp, PB5->PB5_CODPRO)
		aadd( aTemp, PB5->PB5_DTVENC)
		aadd( aTemp, 1)
		aadd( aTemp, 0)
		aadd( aTemp, PB5->PB5_VALOR)
	Endif

	aadd(aPagar, aTemp)
	aTemp := {}

	dbSelectArea("PB5")
	dbSkip()
End


dbSelectArea("PB6")
dbSetOrder(1)
dbSeek(xFilial("PB6") + cMesAno )
While !Eof() .and. PB6->(PB6_FILIAL + PB6_MESANO) == xFilial("PB6") + cMesAno
    aTemp := {}
    If Alltrim(Upper(PB5->PB5_TIPO)) == "PRODUTOR"
	    aadd( aTemp, "F"+PB6->PB6_CODPRO)
	    aadd( aTemp, PB6->PB6_CODPRO)
		aadd( aTemp, PB6->PB6_DTVENC)
		aadd( aTemp, 1)
		aadd( aTemp, 0)
		aadd( aTemp, PB5->PB6_VALOR)
	Else
	    aadd( aTemp, "C"+PB6->PB6_CODPRO)
	    aadd( aTemp, PB6->PB6_CODPRO)
		aadd( aTemp, 0)
		aadd( aTemp, PB6->PB6_QTDLTS)
		aadd( aTemp, PB6->PB6_VLMED)
		aadd( aTemp, PB6->PB6_VALOR)
	Endif

	aadd(aAbat, aTemp)
	aTemp := {}

	dbSelectArea("PB6")
	dbSkip()
End

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQUAA022T  บAutor  ณWilson Davila       บ Data ณ  17/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para checar se existem fornececores bloqueados      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Quata P10                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FornBlock()

Local cQuery	:= ""
Private cMens	:= ""

cQuery := "SELECT A2_COD,A2_LOJA FROM " + RetSqlName('SA2') + " SA2 INNER JOIN " + RetSqlName('LBB') + " LBB"
cQuery += " ON LBB_CODFOR=A2_COD AND LBB_LOJA=A2_LOJA AND LBB_FILIAL='" + cFilant + "'"
cQuery += " WHERE SA2.D_E_L_E_T_='' AND A2_MSBLQL='1'"

If Select( "QRYFOR" ) > 0
	QRYFOR->( dbCloseArea() )
EndIf

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYFOR', .F., .T.)

QRYFOR->( dBGotop() )

While QRYFOR->( !Eof() )

	cMens += "-" + QRYFOR->A2_COD + "-" + QRYFOR->A2_LOJA

	QRYFOR->( dBSkip() )

End While


Return(cMens)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQUAA022T  บAutor  ณWilson Davila       บ Data ณ  17/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para checar se periodo ja foi fechado               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Quata P10                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PerFech()

Local cQuery	:= ""
Private lOk		:= .T.

cQuery := "SELECT LBP_FILIAL FROM " + RetSqlName('LBP') + " LBP"
cQuery += " WHERE LBP.D_E_L_E_T_='' AND LBP_FILIAL='" + cFilAnt + "' AND LBP_DATINI='" + DtOs(MV_PAR01) + "'"

If Select( "QRYPER" ) > 0
	QRYPER->( dbCloseArea() )
EndIf

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYPER', .F., .T.)

If QRYPER->( !Eof() )
lOk := .F.
End If

Return(lOk)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณAjustaSX1 ณ Autor ณ  Andreia J Silva      ณ Data ณ30/06/08  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Monta perguntas no SX1.                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function AjustaSx1(cPerg)

cPerg := Left(cPerg,6)

PutSx1(cPerg,"01","Entrada De?" ,"","","mv_ch1","D",08,0,0,"G","", "", " ", " ","mv_par01")
PutSX1(cPerg,"02","Entrada At้?","","","mv_ch2","D",08,0,0,"G","","","","", "mv_par02")

PutSx1(cPerg,"03","Produtor De?" ,"","?","mv_ch3","C",06,0,0,"G","", "LBB", " ", " ","mv_par03")
PutSX1(cPerg,"04","Produtor At้?"," ","","mv_ch4","C",06,0,0,"G","","LBB","","", "mv_par04")

PutSx1(cPerg,"05","Fechamento" ,"","","mv_ch5","N",01,0,0,"C","","","","","mv_par05","1-Simulacao"," "," ","","2-Fechamento"," "," ")
PutSx1(cPerg,"06","Dados p/ relatorios" ,"","","mv_ch6","N",01,0,0,"C","","","","","mv_par06","1-Fechamento"," "," ","","2-Simula็ใo"," "," ")

Return

 /*/{Protheus.doc} DataLeite
	 (long_description)
	 @type  Function
	 @author user
	 @since 29/04/2020
	 @version version
	 @param param_name, param_type, param_descr
	 @return return_var, return_type, return_description
	 @example
	 (examples)
	 @see (links_or_refer)
	 /*/
User  Function DataLeite(dDataVer)

	Local lRet  :=  .T.

	If GetMv("MV_XDTFCHT") >= dDataVer
		lRet := .F.
		MsgStop("O perํodo informado ja foi fechado !","Atencao")
	End If

 Return lRet
