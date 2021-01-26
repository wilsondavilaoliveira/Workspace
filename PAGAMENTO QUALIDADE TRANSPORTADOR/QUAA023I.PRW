#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} QUAA023I
TELA DE JUSTIFICATIVA BLOQUEIOS PAGAMENTO DE CARRETEIROS DE LEITE
@type function
@version 1.0
@author wilso
@since 08/12/2020
/*/

User Function QUAA023I (cTitulo,cDescBloq,cDescm)


Local lRet 		:= .F.

DEFAULT cDescm	:= ""

DEFINE FONT oFont4	NAME "Arial" SIZE 08,10	//BOLD
DEFINE DIALOG oDlgMot TITLE "Justificativa"  FROM 0, 0 TO 22, 75 SIZE 750, 480  /* OF <oWnd> */    pixel

oFW := FWLayer():New()
oFW:init( oDlgMot, .f. )
oFW:addCollumn( "Col01", 100, .F. )
oFW:addWindow( "Col01", "Win01", "JUSTIFICATIVA PARA O "+Alltrim(cDescBloq), 100, .T., .F.)
oWin:= oFW:getWinPanel( "Col01", "Win01" )


//Painel para os Botoes
oPanC1W1:=TPanel():New(1,3,,oWin,/*[aoFont]*/,,/*Reservado*/,/*CorTexto*/,CLR_BLUE,40,18,.T.,.T.)
oPanC1W1:ALIGN:= CONTROL_ALIGN_TOP
oButt1:= FWButtonBar():new()
oButt1:Init(oPanC1W1, 17, 85,CONTROL_ALIGN_TOP, .T. )
oButt1:addBtnImage( "OK"   		,"Confirmar",	{|| lRet:= .t. ,oDlgMot:End()},,.T.,CONTROL_ALIGN_LEFT)
oButt1:addBtnImage( "final"		,"Sair", 	   	{|| oDlgMot:End()},,.T.,CONTROL_ALIGN_LEFT)

oPanInf := TPanel():New(020,100,,oWin,oFont4,,,CLR_BLUE,/*CLR_BLUE*/,550,400,.T.,.T.)
oPanInf:align :=CONTROL_ALIGN_ALLCLIENT


@ 01.0,002 SAY Alltrim(cTitulo)			            OF oPanInf
@ 02.0,002 SAY Alltrim(cDescBloq)		            OF oPanInf
@ 04.0,002 SAY "Justifique o "+Alltrim(cDescBloq)	OF oPanInf

@ 05.0,002 GET oDescm VAR cDescm MEMO SIZE 340,120  VALID !Empty(cDescm) COLOR CLR_HRED  OF oPanInf
ACTIVATE DIALOG oDlgMot   CENTER

//Grava Motivo pelo qual o Pedido esta Bloqueado C5_JUSTLIB

//If lRet .And. SC5->(DbSeek(xFilial("SC5")+cPedido))
//	SC5->(RecLock("SC5",.F.))
//	SC5->C5_XJUSTLB := Alltrim(cDescm)
//	SC5->(MsUnlock())
//Endif

Return cDescm
