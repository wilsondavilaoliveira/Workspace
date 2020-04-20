#INCLUDE "PROTHEUS.CH" 
#INCLUDE "RWMAKE.CH" 
#INCLUDE 'COLORS.CH' 
#INCLUDE "TOPCONN.CH"  
#INCLUDE "PRCONST.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "TbiConn.ch"
//#INCLUDE "MATC090.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³QUAA080W	³ Autor ³ Luiz Enrique	        ³ Data ³ 15/09/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³GERENCIADOR DE ENTRADAS DE PEDIDOS DE VENDAS.					³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³NOVAMIX	                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function QUAA080W() 

Local aCoors	:= FWGetDialogSize( oMainWnd )
Local cCadastro	:= "MONITOR DE ENTRADAS DE PEDIDOS DE VENDAS"  
Local oC1W1 		// Layer pricipal   
Local oC1W2 		// Layer secundario
Local oButt1   		// Botoes para o Pedido
//Variaveis para os Browses
Local oPedido		// Lista dos Pedidos
Local cPed			// Codigo do Pedido Atual
Local oBroItp		// Lista dos Itens do Pedido 
Local oDesbloq		// Lista dos Pedidos Desbloquados
Local oPanC1W1		// Paineis na Janela do Pedido 
Local oPanPri
Local oPasta 		//Pastas para "PEDIDOS","DESBLOQUEIOS DO PEDIDO","BLOQUEIOS POR VALOR MINIMO"		
Local libera	:= .F. 
Local lHist		:= .F.
Local lfirst	:= .T.
Local oHist 
Private oCodCli
Private oCodLoja
Private oBand
Private oDBand
Private oCodPro
Private oProd
Private oCliente
Private oNota
Private oSerie
Private cCodCli  	:= Space(TamSx3("A1_COD")[1])   
Private cLojaCli 	:= Space(TamSx3("A1_LOJA")[1])
Private cBand  		:= Space(TamSx3("A1_COD")[1])   
Private cDBand		:= Space(45)
Private cCodPro  	:= Space(TamSx3("B1_COD")[1])   
Private cProd		:= Space(45)
Private cCliente	:= Space(45)
Private cNota		:= Space(9)
Private cSerie		:= Space(3)
Private oCBX1 

Private oSaldoPed		// Lista dos Pedidos Gerados Por Saldo (corte)
Private oPanBotoes
Private oDlg1
Private aPedidos	:= {}     
Private cMarca 		:= GetMark()
Private aOrd1		:= {}
Private cFilBloq1
Private cOperador 
Private aVerBloq 	:= {}  
Private oSim		:= LoadBitmap(GetResources(),'lbtik') //lbok
Private oNao		:= LoadBitmap(GetResources(),'lbno') 
Private aLsc6		:= {} 
Private aLsc61		:= {} 
Private oItens
Private oItens1
Private oItens2

Private aItens	:= {}
Private aItens1	:= {}
Private aItens2	:= {}

//Legendas
Private  aLegBloq	:= {}
Private aCores 		:= {} 
Private oDataDe 	
Private dDataDe		:= dDataBase-5
Private oPanRoda
Private oValPed
Private nValPed := 0
Private oKgsPed
Private nKgsPed := 0
Private oPedRoda
Private cPedRoda := Space(6)
Private aSaldoPed 	:= {}
Private cFilCmb2 := ""
Private cFilCmb1 := ""
Private cFilCmb3 := ""

//DEFINE AS LEGENDAS DO MODULO
aAdd(aLegBloq, 	{"BR_VERDE"		,"Liberado"})
aAdd(aLegBloq,	{"BR_AZUL"		,"Liberado Pelo Gestor"}) 
aAdd(aLegBloq,	{"BR_VERMELHO"	,"Bloqueado"})
aAdd(aLegBloq,	{"BR_LARANJA"	,"Bloqueado-Pedido de saldo(CORTE)"})

cNomeUsu := Alltrim(UsrRetName(__cUserId))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ativa tecla F4 para comunicacao com Saldos dos Lotes         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Set Key VK_F4 TO ShowF4(aLsc6[oBroItp:nAT,4],"01")
cTxtTit:= "GESTÃO DE CONTRATOS COMERCIAIS -  Login:  " 

cCadastro:= cTxtTit + cNomeUsu +  "       " + Dtoc(Ddatabase) + " - " + Time()  

DEFINE FONT oFont4	NAME "Arial" 		SIZE 08,10	BOLD 
DEFINE FONT oFont2	NAME "Arial" 		SIZE 11,15 BOLD
DEFINE FONT oFont5	NAME "Arial" 		SIZE 9,15 BOLD  
DEFINE FONT oFont6	NAME "Arial" 		SIZE 7,13 BOLD
 
DEFINE MSDIALOG oDlg1 FROM aCoors[1],aCoors[2] TO aCoors[3],aCoors[4] TITLE cCadastro OF oMainWnd COLOR "W+/W" STYLE nOR(WS_VISIBLE,WS_POPUP) PIXEL 

oDlg1:lEscClose:= .F.
oDlg1:lMaximized := .T.	
oFWLayer:= FWLayer():New()
oFWLayer:init( oDlg1, .F. ) // Segundo parametro: Cria um botao de fechar utilizado para Dlg sem cabeçalho. Caso for .t.	  

//COLUNA - JANELA 1=====================================================================================================================================
oFWLayer:addLine ("Lin01",60,.F.)
oFWLayer:addCollumn( "Col01",100, .F.,"Lin01")
oFWLayer:addWindow( "Col01", "Win01", cCadastro, 50, .T., .F.,,"Lin01")
oC1W1:= oFWLayer:getWinPanel( "Col01", "Win01","Lin01")  

//==TECLAS DE ATALHO ============================================================================================
bKeyF4 := SetKey( VK_F4 , Nil )
SetKey( VK_F4 , { || oDlg1:End() } )

//Painel dos Botoes para Manutencoes=============================================================================
//oPanBotoes:=TPanel():New(5,5,,oC1W1,/*[aoFont]*/,,,/*CorTexto*/,CLR_GREEN,290,15,.T.,.T.) 
//oPanBotoes:ALIGN:= CONTROL_ALIGN_LEFT

//BOTOES=========================================================================================================
oButt1:= FWButtonBar():new()											
oButt1:Init(oC1W1, 17, 20,CONTROL_ALIGN_TOP, .T. )   

oButt1:addBtnImage( "final"		,"Sair"					,{|| oDlg1:End()}			,,.T.,CONTROL_ALIGN_RIGHT)  
oButt1:addBtnImage( "S4WB001N"	,"Incluir"				,{|| U_QA040TELA(,,3,.T.)}	,,.T.,CONTROL_ALIGN_RIGHT) 
oButt1:addBtnImage( "NOTE"		,"Alterar Contrato"		,{|| Altera(1) 	}			,,.T.,CONTROL_ALIGN_RIGHT) 
oButt1:addBtnImage( "S4WB007N"	,"Alt.Nome Contr."		,{|| Altera(3) 	}			,,.T.,CONTROL_ALIGN_RIGHT) 
oButt1:addBtnImage( "SIMULACA"	,"Revisao"				,{|| Altera(2) 	}			,,.T.,CONTROL_ALIGN_RIGHT) 
oButt1:addBtnImage( "PRECO"		,"Nota Fiscal"			,{|| ShowNF()	}			,,.T.,CONTROL_ALIGN_RIGHT)
oButt1:addBtnImage( "cargaseq"	,"Relatorio Contratos"	,{|| U_QUAR080W()}			,,.T.,CONTROL_ALIGN_RIGHT)
//oButt1:addBtnImage( "cargaseq"	,"Relatorio Contratos"	,{|| axcadastro("ZC8")}			,,.T.,CONTROL_ALIGN_RIGHT) 
//==COMBO 1 - STATUS=============================================================================================
cFilCmb1 := ""
aOrdCmb1 := {} 
AADD(aOrdCmb1,"A=ATIVOS")
AADD(aOrdCmb1,"I=INATIVOS")
AADD(aOrdCmb1,"T=TODOS")

@003,001 COMBOBOX oCBX1 VAR cFilCmb1 ITEMS aOrdCmb1 SIZE 80,10 PIXEL OF oC1W1 FONT oFont2 COLOR CLR_BLUE;
ON CHANGE LoadContr(.T.)
oCBX1:Refresh()

//==COMBO 2 - FILIAL=============================================================================================
cFilCmb2 := ""
aOrdCmb2 := QA80FIL() 
@003,085 COMBOBOX oCBX2 VAR cFilCmb2 ITEMS aOrdCmb2 SIZE 110,10 PIXEL OF oC1W1 FONT oFont2 COLOR CLR_BLUE;
ON CHANGE LoadContr(.T.)
oCBX1:Refresh()

//==COMBO 3 - CATEGORIA PRODUTO===================================================================================
cFilCmb3 := ""
aOrdCmb3 := QA80SX5() 
@004+15,001 COMBOBOX oCBX3 VAR cFilCmb3 ITEMS aOrdCmb3 SIZE 150,10 PIXEL OF oC1W1 FONT oFont2 COLOR CLR_BLUE ;
ON CHANGE LoadContr(.T.)
oCBX1:Refresh()

//==PRODUTO=======================================================================================================
@006+15,330+20-198 SAY "Produto.:"	SIZE 048,10 OF oC1W1 	PIXEL FONT oFont2 COLOR CLR_BLUE  
@003+15,380+20-198 MSGET oCodPro 	VAR cCodPro	SIZE 060,10 OF oC1W1 	PIXEL FONT oFont2 COLOR CLR_BLUE WHEN .T. F3 "SB1ZZN";
Valid Iif(Empty(cCodPro),.T.,iif( (ExistCpo("SB1",cCodPro) .OR. Empty(cCodPro)),cProd := Posicione("SB1",1,xFilial("SB1")+cCodPro,"B1_DESC"),cProd := "" ))  PICTURE "@!" ;
ON CHANGE LoadContr(.T.)
@003+15,440+23-198 MSGET oProd 	VAR cProd	SIZE 200,10 OF oC1W1 WHEN .F. PIXEL FONT oFont5 COLOR CLR_BLUE WHEN .T.

//==CLIENTE=======================================================================================================
@020+18,090-089 SAY "Cliente:"		SIZE 040,10 OF oC1W1 	PIXEL FONT oFont2 COLOR CLR_BLUE  
@017+18,130-089 MSGET oCodCli 	VAR cCodCli	SIZE 030,10 OF oC1W1 	PIXEL FONT oFont2 COLOR CLR_BLUE WHEN .T. F3 "SA1";
Valid Iif(Empty(cCodCli),.T.,iif( (ExistCpo("SA1",cCodCli) .OR. Empty(cCodCli)),cCliente := Substr(Posicione("SA1",1,xFilial("SA1")+cCodCli,"A1_NOME"),1,33),cCliente := "" ))  PICTURE "@!" ; 
ON CHANGE LoadContr(.T.)
//==LOJA==========================================================================================================
@020+18,188-087 SAY "Loja:" SIZE 030,10 OF oC1W1 	PIXEL FONT oFont2 COLOR CLR_BLUE  
@017+18,215-087 MSGET oLoja 	VAR cLojaCli	SIZE 018,10 OF oC1W1 	PIXEL FONT oFont2 COLOR CLR_BLUE WHEN .T. ;
Valid Iif(Empty(cLojaCli),.T.,iif( (ExistCpo("SA1",cCodCli+cLojaCli) .OR. Empty(cLojaCli)),cCliente := SubStr(Posicione("SA1",1,xFilial("SA1")+cCodCli+cLojaCli,"A1_NOME"),1,33),cCliente := "" ))  PICTURE "@!"; 
ON CHANGE LoadContr(.T.)
@017+18,215-089+55 MSGET oCliente 	VAR cCliente	SIZE 167,10 OF oC1W1 WHEN .F.	PIXEL FONT oFont5 COLOR CLR_BLUE WHEN .T.

//==BANDEIRA======================================================================================================
@020+18,330+20 SAY "Bandeira:"SIZE 060,10 OF oC1W1 PIXEL FONT oFont2 COLOR CLR_BLUE  
@017+18,380+20 MSGET oBand 	VAR cBand	SIZE 060,10 OF oC1W1 	PIXEL FONT oFont2 COLOR CLR_BLUE F3 "BA" WHEN .T. ;
Valid Iif(Empty(cBand),.T.,iif( (ExistCpo("SX5","BA"+cBand) .OR. Empty(cBand)),cDBand := Posicione("SX5",1,xFilial("SXE")+"BA"+cBand,"X5_DESCRI"),cDBand := "" )) PICTURE "@!"; 
ON CHANGE LoadContr(.T.) 
@017+18,440+23 MSGET oDBand 	VAR cDBand	SIZE 200,10 OF oC1W1 WHEN .F. PIXEL FONT oFont5 COLOR CLR_BLUE


//==NOTA FISCAL====================================================================================================
@035+20,090-089 SAY "Nota....:" SIZE 060,10 OF oC1W1 PIXEL FONT oFont2 COLOR CLR_BLUE  
@032+20,130-089 MSGET oNota 	VAR cNota	SIZE 030,10 OF oC1W1 	PIXEL FONT oFont2 COLOR CLR_BLUE WHEN .T. ;
ON CHANGE LoadContr(.T.)
//Valid Iif(Empty(cBand),.T.,iif( (ExistCpo("SX5","BA"+cBand) .OR. Empty(cBand)),cDBand := Posicione("SX5",1,xFilial("SXE")+"BA"+cBand,"X5_DESCRI"),cDBand := "" )) PICTURE "@!" 

@035+20,188-069 SAY "Serie:" SIZE 060,10 OF oC1W1 PIXEL FONT oFont2 COLOR CLR_BLUE  
@032+20,215-066 MSGET oSerie 	VAR cSerie	SIZE 030,10 OF oC1W1 	PIXEL FONT oFont2 COLOR CLR_BLUE WHEN .T. ;
ON CHANGE LoadContr(.T.)
//Valid Iif(Empty(cBand),.T.,iif( (ExistCpo("SX5","BA"+cBand) .OR. Empty(cBand)),cDBand := Posicione("SX5",1,xFilial("SXE")+"BA"+cBand,"X5_DESCRI"),cDBand := "" )) PICTURE "@!" 

//JANELA 2====================================================================================================================================================================

//oFWLayer:addCollumn("Col01",45,.F.,"Lin01")
oFWLayer:addWindow( "Col01", "Win02", "CONTRATOS",50, .T., .F.,,"Lin01")
oC1W2:= oFWLayer:getWinPanel( "Col01", "Win02","Lin01")  

//LISTBOX ITENS======================================================================================================
@ 01,01 LISTBOX oItens1 Fields HEADER "S","CONTRATO","DESCRICAO                     ","REVISAO","DT.INICIAL","DT.FINAL","ATIVO?","FILIAIS";
SIZES {04,10,10,05,05,05,05,60} SIZE 490,095 PIXEL of oC1W2 FONT oFont6 ;
ON CHANGE LoadItens(.T.)
//ON DBLCLICK Lin_OnOff(oPedido,aPedidos,oBroItp,lHist,oDesbloq,oSaldoPed);
LoadContr(.F.)
oItens1:Align := CONTROL_ALIGN_ALLCLIENT 
oItens1:Refresh()

//JANELA 3====================================================================================================================================================================
oFWLayer:addLine ("Lin02",40,.F.)
oFWLayer:addCollumn("Col02",40,.F.,"Lin02")
oFWLayer:addWindow( "Col02", "Win02", "ITENS CONTRATOS", 100, .T., .F.,,"Lin02")
oC1W3:= oFWLayer:getWinPanel( "Col02", "Win02","Lin02")  

//LISTBOX ITENS======================================================================================================
@ 01,01 LISTBOX oItens Fields HEADER "VERBA","DESCRICAO","CALC","FORMA"," % ","CONS.DEV?";
SIZES {04,04,04,04,04,04,04} SIZE 490,095 PIXEL of oC1W3 FONT oFont6 //  ;
//ON DBLCLICK Lin_OnOff(oPedido,aPedidos,oBroItp,lHist,oDesbloq,oSaldoPed);
//ON CHANGE U_xRodape( aPedidos[oPedido:nAT,3] )
oItens:Align := CONTROL_ALIGN_ALLCLIENT 

oItens:Refresh()
//JANELA 4===============================================================================================================================================
oFWLayer:addCollumn("Col03",60,.F.,"Lin02")
oFWLayer:addWindow( "Col03", "Win03", "RELACAO CLIENTE X CONTRATO X CATEGORIA", 100, .T., .F.,,"Lin02")
oC1W4:= oFWLayer:getWinPanel( "Col03", "Win03","Lin02")  

//LISTBOX ITENS======================================================================================================
//ZC7_ITEM	ZC7_CODCTR	BANDEIRA	ZC7_CODCLI	ZC7_LOJA	CLIENTE	PRODUTO	CATEGORIA	MARCA
@ 01,01 LISTBOX oItens2 Fields HEADER "BANDEIRA","CODCLI","LOJA","CLIENTE","PRODUTO","CATEGORIA","MARCA";
SIZES {04,04,04,04,04,04,04} SIZE 490,095 PIXEL of oC1W4 FONT oFont6  ;
//ON DBLCLICK Lin_OnOff(oPedido,aPedidos,oBroItp,lHist,oDesbloq,oSaldoPed);
//ON CHANGE U_xRodape( aPedidos[oPedido:nAT,3] )
oItens2:Align := CONTROL_ALIGN_ALLCLIENT 

oItens2:Refresh()


//==PAINEL TOTALIZADOR RODAPE ========================================================================================
oPanRoda 		:= TPanel():New(1,3,,oDlg1,oFont2,,,/*CorTexto*/,/*CLR_GREEN*/,80,15,.T.,.T.) 
oPanRoda:ALIGN 	:= CONTROL_ALIGN_BOTTOM 

@004.3,005 SAY "Contrato:"	SIZE 060,10 OF oPanRoda 	PIXEL FONT oFont2 COLOR CLR_RED 
@2.0,060 MSGET oPedRoda 	VAR cPedRoda	SIZE 060,10 OF oPanRoda WHEN .F. PIXEL FONT oFont2

@004.3,130 SAY "% Desconto:"	SIZE 100,10 OF oPanRoda 		PIXEL FONT oFont2 COLOR CLR_RED  
@2.0,200 MSGET oValPed 	VAR nValPed	SIZE 080,10 OF oPanRoda WHEN .F. PIXEL FONT oFont2 PICTURE "@E 99.99%" 

//@004.3,285 SAY "Kgs Pedido:"	SIZE 100,10 OF oPanRoda 		PIXEL FONT oFont2 COLOR CLR_RED  
//@2.0,350 MSGET oKgsPed 	VAR nKgsPed	SIZE 080,10 OF oPanRoda WHEN .F.  PIXEL FONT oFont2 PICTURE "@E 99,999.999" 

//*@2.0,165 MSGET ocodPedido 	VAR cPedAtu	SIZE 060,10 OF oC1W1 	PIXEL FONT oFont2;
//* When libera //Valid VldPedido(oPasta:nOption,oPedido,oBroItp,cPedAtu,lHist,oDesbloq) PICTURE "@!"   //NO BORDER 

//*@005,005 CHECKBOX oHist		VAR lHist PROMPT "Mostrar Liberados" SIZE 110,7  OF oC1W1 	PIXEL FONT oFont2 COLOR CLR_BLUE //;
//ON CLICK Atualizar(oPasta:nOption,oPedido,oBroItp,cPedAtu,lHist,oDesbloq,oSaldoPed) 

//*@004.3,235 SAY "Emissão de:"	SIZE 070,10 OF oC1W1 	PIXEL FONT oFont2 COLOR CLR_BLUE  

//*@2.0,305 MSGET oDataDe 	VAR dDataDe	SIZE 070,10 OF oC1W1 	PIXEL FONT oFont2 //; 
//valid IIF(lHist,Atualizar(oPasta:nOption,oPedido,oBroItp,cPedAtu,lHist,oDesbloq,oSaldoPed),.T.) PICTURE "@E 99/99/9999" 


//*@28.0,140 COMBOBOX oCBX1 VAR cFilBloq1 ITEMS aOrd1 SIZE 80,03 PIXEL OF oC1W1 //FONT oDlg1:oFont
//oCbx1:bChange := {|| nOrd := oCbx1:nAt,Atualizar(oPasta:nOption,oPedido,oBroItp,"",lHist,oDesbloq,oSaldoPed,.T.)}
//oCBX1:ALIGN:= CONTROL_ALIGN_RIGHT
//*oCBX1:Refresh()


//Painel Principal dos Botoes para as Manutenções e Pesquisa
//oPanPri	:=TPanel():New(1,3,,oC1W1,oFont2,,,/*CorTexto*/,/*CLR_GREEN*///,80,15,.T.,.T.) 
//oPanPri :ALIGN:= CONTROL_ALIGN_TOP 


//Painel para Pesquisa do Pedido
//oPanped	:=TPanel():New(1,3,,oC1W1,oFont2,,,/*CLR_BLUE*/,/*CLR_BLUE*/,380,15,.f.,.f.) //200,07 
//oPanped:ALIGN := CONTROL_ALIGN_RIGHT  





//@ 01,01 LISTBOX oSaldoPed FIELDS HEADER "S","Pedido","Cliente","Estado","Cidade","Cep","Data do Pedido","Data Desbloqueio", "Horario Liberacao","Observação"," " ;
//SIZES {05,20,20,20,20,20,20,20,20,35,02} SIZE 490,095 OF oPasta:aDialogs[3] PIXEL ;	
//ON DBLCLICK AtItemSdo(aSaldoPed[oSaldoPed:nAT,2],oBroItp)
//oSaldoPed:Align := CONTROL_ALIGN_ALLCLIENT  //nOption,oBroItp,cPedido
//oSaldoPed:Refresh()

//Painel para Filtro dos Bloqueios============================================================================================================================== 





//========================================================================================================================================================================

//========================================================================================================================================================================
/*
CB1->(DbSetOrder(2)) // Filial+Codigo Usuario Protheus 
cOperador := __cUserID 
If !CB1->(DBSeek(xFilial("CB1") + Padr(cOperador,6)))
	CBAlert("Operador Invalido.")
	Return .F.
Endif

If Alltrim(CB1->CB1_ROTINA) $ 'ADMIN' //Filial Sao Paulo
	oButt1:addBtnImage( "btcalend",	"Roteiro",	  			{|| CadRoteiro ()} 												   		   							,,.T.,CONTROL_ALIGN_LEFT) 
	oButt1:addBtnImage( "nco",	   	"Cadastro de Bloqueio",	{|| U_NMCB53A()} 					   				   												,,.T.,CONTROL_ALIGN_LEFT)   
	oButt1:addBtnImage( "GPEIMG32",	"Usuarios",				{|| CadUsuario(oPasta:nOption,oPedido,oBroItp,lHist,oDesbloq,oCBX1)}	   					,,.T.,CONTROL_ALIGN_LEFT) 
	oButt1:addBtnImage( "folder14",	"Parametros", 	   		{|| AtuParamet()}		   			   													  			,,.T.,CONTROL_ALIGN_LEFT)  
	oButt1:addBtnImage( "DESTINOS",	"Cad.TranspxDias Lib.",	{|| U_AXCADPX9() }		,,.T.,CONTROL_ALIGN_LEFT)
Endif

oButt1:addBtnImage( "svm", 			"Legenda", 	   			{|| FS53legPed(1,oPasta)}			   				   			   		   				  			,,.T.,CONTROL_ALIGN_LEFT)
oButt1:addBtnImage( "PRECO", 		"Pos.Financeira", 		{|| xPosCli(oPedido) }	,,.T.,CONTROL_ALIGN_LEFT)
oButt1:addBtnImage( "cargaseq",	"Imprime Pedidos", 			{|| U_RELPEDBL() }		,,.T.,CONTROL_ALIGN_LEFT)
oButt1:addBtnImage( "carganew",	"Imprime Cortes", 			{|| U_RELACORTE() }		,,.T.,CONTROL_ALIGN_LEFT)
oButt1:addBtnImage( "TK_VERTIT",	"Imprime Posicao Pedidos",	{|| U_RPEDBLFAT() }		,,.T.,CONTROL_ALIGN_LEFT)
oButt1:addBtnImage( "EXCLUIR",	"Excluir Pedido",  		{|| DelPedido(cFilAnt,aPedidos[oPedido:nAT,3]),Atualizar(oPasta:nOption,oPedido,oBroItp,"",lHist,oDesbloq,oSaldoPed) },,.T.,CONTROL_ALIGN_LEFT)
//DelPedido(cFilAnt,aPedidos[oPedido:nAT,3])
*/
//
//RELACORTE
//PAINEIS PRINCIPAIS
//oPasta:= TFolder():New(000,000,{"PEDIDOS","DESBLOQUEIOS DO PEDIDO","BLOQUEIOS POR VALOR MINIMO"},{},oC1W1 ,,,,.T.,.F.,392,244,)//392,244
//oPasta 			:= TFolder():New(000,000,{" P E D I D O S ","H I S T O R I C O   D E S B L O Q U E I O S","PEDIDOS GERADOS DE SALDO (C O R T E)"},{},oC1W1 ,,,,.T.,.F.,392,244,)//392,244
//oPasta 			:= TFolder():New(000,000,{"V E R B A S"},{},oC1W1 ,,,,.T.,.F.,392,244,)//392,244
//oPasta:align 	:= CONTROL_ALIGN_ALLCLIENT
//oPasta:bChange 	:= {|| Atualizar(oPasta:nOption,oPedido,oBroItp,"",lHist,oDesbloq,oSaldoPed)}


//DESBLOQUEIOS DO PEDIDO======================================================================================================================================
//@ 01,01 LISTBOX oDesbloq FIELDS HEADER "S","Pedido","Cod.Bloqueio","Bloqueio Registrado","Data Desbloqueio", "Horario Desbloqueio","Observação","Responsavel"," " ;
//SIZES {02,20,10,30,20,20,20,30,02} SIZE 490,095 PIXEL	 OF oPasta:aDialogs[2] 
//oDesbloq:Align := CONTROL_ALIGN_ALLCLIENT  //nOption,oBroItp,cPedido
//oDesbloq:Refresh()

//ALTERACAO ITENS PEDIDO =================================================================================================================================

//Relacao dos ITENS ;;;;; oSt,C6_ITEM,C6_PRODUTO,cDescProd,C6_QTDVEN,C6_QUANTLI,C6_PRCVEN,C6_VALOR
//@ 01,01 LISTBOX oBroItp1 FIELDS HEADER ;
//"S","PEDIDO","IT","CODPRO","PRODUTO","CLIENTE","CIDADE","EST","ARM","QTD.PED","SEG.UM","QTD.LIB","VR.UNIT","VR.TAB","TOTAL","REPRESENTANTE", " " ;
//SIZES {5,6,2,6,35,70,15,10,10,10,15,15,15,10,10,2} SIZE 550,100 OF oPasta:aDialogs[3] PIXEL ON DBLCLICK cEditArm(oBroItp1)
//oBroItp1:align := CONTROL_ALIGN_ALLCLIENT
//oBroItp1:Refresh()
//LoadSC6 (oBroItp1,'001001')




//COLUNA1 - JANELA 2 =====================================================================================================================================

//oFWLayer:addWindow( "Col01", "Win02", "RELAÇÃO DOS ITENS", 50, .T., .f. )
//oC1W2	:= oFWLayer:getWinPanel( "Col01", "Win02")   

//Relacao dos ITENS ;;;;; oSt,C6_ITEM,C6_PRODUTO,cDescProd,C6_QTDVEN,C6_QUANTLI,C6_PRCVEN,C6_VALOR
//@ 01,01 LISTBOX oBroItp FIELDS HEADER ;
//"S","PEDIDO","IT","CODPRO","PRODUTO","QTD.PED","SEG.UM","QTD.LIB","VR.UNIT","VR.TAB", "TOTAL","ARM","REPRESENTANTE", " " ;
//SIZES {5,6,2,30,15,10,10,15,15,15,10,10,2} SIZE 550,100 OF oC1W2 PIXEL ON DBLCLICK IIF(!lHist,xMat460(oBroItp,oPedido,lHist,oDesbloq,oSaldoPed),.T.)

//oBroItp:align := CONTROL_ALIGN_ALLCLIENT

//====================================================================================================================


//If lfirst
//	Atualizar(oPasta:nOption,oPedido,oBroItp,"",lHist,oDesbloq,oSaldoPed,.T.)
//	lfirst := .F.
//Endif

ACTIVATE MSDIALOG oDlg1 

SET KEY VK_F4 TO

Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Monta_SC6	 ³ Autor ³ Luiz Enrique	         ³ Data ³ 15/09/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta a Lista dos ITENS dos pedidos Bloqueados 				 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function LoadContr(lCombo)

Local oSt			:= LoadBitmap(GetResources(),'BR_VERDE') 
Local oSt2			:= LoadBitmap(GetResources(),'BR_VERMELHO')    
Local aBloqs		:= {} 
Local cDescProd		:= ""
Local nLiberado		:= 0
Local nTotValIt		:= 0 
Local lCorte		:= .F.
Local cQuery		:= ''
Local xFil			:= ""
Local cStatus		:= IIF(SubStr(cFilCmb1,1,1)=="A","S","N")

aItens1 := {}

		If SubStr(cFilCmb2,1,2) <> "00"
			xFil := SubStr(cFilCmb2,1,2)
		End If
	
	If !Empty(cNota)

	cQuery := "SELECT DISTINCT ZC4_CODCON,ZC4_OBSOLE,ZC4_DESC,ZC4_REVISA,ZC4_DTINI,ZC4_DTFIM,ZC4_ATIVO,ZC4_FILSEL " + CRLF
	cQuery += " FROM " + RetSqlName("ZC4") + " ZC4 " + CRLF
	cQuery += " WHERE ZC4.D_E_L_E_T_=''  AND ZC4_CODCON+ZC4_REVISA IN (SELECT E1_XNCONTR+E1_NREVISC FROM SE1010 WHERE E1_NUM='" + cNota + "' AND E1_SERIE='" + cSerie + "' AND E1_TIPO='NF') " + CRLF
		
	Else
	cQuery := "SELECT DISTINCT ZC4_CODCON,ZC4_OBSOLE,ZC4_DESC,ZC4_REVISA,ZC4_DTINI,ZC4_DTFIM,ZC4_ATIVO,ZC4_FILSEL " + CRLF
	cQuery += " FROM " + RetSqlName("ZC4") + " ZC4 " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("ZC7") + " ZC7 ON ZC7_CODCTR=ZC4_CODCON AND ZC7.D_E_L_E_T_=''
	
	cQuery += " WHERE ZC4.D_E_L_E_T_=''   " + CRLF
	
	If SubStr(cFilCmb3,1,6) <> "999999" .AND. Empty(cCodPro)
		cQuery += " AND ZC7_CATEGO = '" + SubStr(cFilCmb3,1,6) + "' " + CRLF
	End If
	
	If !Empty(cCodpro)
		cQuery += " AND ZC7_CODPRO = '" + cCodPro + "' " + CRLF
	End If

	If !Empty(cCodCli)
		cQuery += " AND ZC7_CODCLI = '" + cCodCli + "' " + CRLF
	End If
	
	If !Empty(cLojaCli)
		cQuery += " AND ZC7_LOJA = '" + cLojaCli + "' " + CRLF
	End If

	If !Empty(cBand) .AND. Empty(cCodCli)
		cQuery += " AND ZC7_BANDEI = '" + cBand + "' " + CRLF
	End If
	
	
	If SubStr(cFilCmb2,1,2) <> "00"
		cQuery += " AND ZC4_FILSEL LIKE ('%" + SubStr(cFilCmb2,1,2) + "%') " + CRLF
	End If
	
	If SubStr(cFilCmb1,1,1)=="A"
		cQuery += " AND ZC4_OBSOLE='F' " + CRLF  
	ElseIf SubStr(cFilCmb1,1,1)=="I"
		cQuery += " AND ZC4_OBSOLE='T' " + CRLF
	End If
	
	If !Empty(cBand)
		cQuery += " AND ZC4_CODCON IN (SELECT ZC7_CODCTR FROM " + RetSqlName("ZC7") + " ZC7 WHERE ZC7_BANDEI = '" + cBand + "' AND ZC7.D_E_L_E_T_='') " + CRLF
	End If
	
	cQuery += " ORDER BY ZC4_CODCON,ZC4_REVISA " + CRLF
	
	End If
	
	MemoWrite("C:\HD\Arq Trabalho\NOVAMIX\ACD\QUERYS\CONTRATOS.SQL",cQuery)
			
	IF Select("QUAA080W") > 0
		QUAA080W->(dbCloseArea())
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QUAA080W" 
		
	While QUAA080W->(!Eof())
		
		Aadd(aItens1,{Iif(QUAA080W->ZC4_OBSOLE == "F",oSt,oSt2),; 
					QUAA080W->ZC4_CODCON,;
					QUAA080W->ZC4_DESC,;
			 		QUAA080W->ZC4_REVISA,;
			 		stod(QUAA080W->ZC4_DTINI),;
			 		stod(QUAA080W->ZC4_DTFIM),;
			 		IIF(QUAA080W->ZC4_OBSOLE == 'F',"S","N"),;
			 		QUAA080W->ZC4_FILSEL,;
					," "})										 
		
		QUAA080W->( dbSkip() )

	End While 

//04,10,60,40,30,30,30
//@ 01,01 LISTBOX oItens Fields HEADER "CONTRATO","DESCRICAO","REVISAO","DT.INICIAL","DT.FINAL","ATIVO?","FILIAIS";
//SIZES {04,10,60,05,10,10,10,30} SIZE 490,095 PIXEL of oC1W2//  ;

If Empty(aItens1)                                
	aItens1 := {{oSt,Space(10),Space(35),Space(05),Space(10),Space(10),Space(10),Space(10),Space(30)," "}}
EndIf

//"S","Item","Produto","Descrição","Quantidade","Qtd. Liberada","Valor Unitario", "Total", "Arm"," "	
oItens1:SetArray(aItens1)
oItens1:bLine := {|| {aItens1[oItens1:nAt,01],aItens1[oItens1:nAt,02],Alltrim(aItens1[oItens1:nAt,03]),aItens1[oItens1:nAt,04],aItens1[oItens1:nAt,05],aItens1[oItens1:nAt,06],;
					aItens1[oItens1:nAt,07],aItens1[oItens1:nAt,08],aItens1[oItens1:nAt,09],aItens1[oItens1:nAt,10]}}						
oItens1:Refresh()

If lCombo
	LoadItens(.T.)
End If

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Monta_SC6	 ³ Autor ³ Luiz Enrique	         ³ Data ³ 15/09/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta a Lista dos ITENS dos pedidos Bloqueados 				 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function LoadItens(lCombo)

Local oSt			:= LoadBitmap(GetResources(),'BR_VERDE') 
Local oSt2			:= LoadBitmap(GetResources(),'BR_AZUL')    
Local aBloqs		:= {} 
Local cDescProd		:= ""
Local nLiberado		:= 0
Local nTotValIt		:= 0 
Local lCorte		:= .F.
Local cQuery		:= ''

aItens := {}
//Local aItens		:= {}
	//msgalert(cValToChar(nAt))
	cQuery := " SELECT ZC5_ITEM,ZC5_CODCON,ZC5_CODVER,ZC5_DESC,ZC5_PERCEN, " + CRLF
	cQuery += " CASE WHEN ZC5_CALCUL='1' THEN 'TOTAL PRODUTO' ELSE 'TOTAL NOTA ST' END ZC5_CALCUL, " + CRLF
	cQuery += " CASE WHEN ZC5_FORMA='1' THEN 'DESCONTO NF' " + CRLF
	cQuery += " WHEN ZC5_FORMA='2' THEN 'RETIDO NCC' " + CRLF
	cQuery += " WHEN ZC5_FORMA='3' THEN 'RETIDO PAGAR' " + CRLF
	cQuery += " WHEN ZC5_FORMA='4' THEN 'DESCONTO DUPL' END AS ZC5_FORMA, " + CRLF 
	cQuery += " ZC5_DEVOLV " + CRLF
	cQuery += " FROM " + RetSqlName("ZC5") + " ZC5  " + CRLF
	cQuery += " WHERE ZC5.D_E_L_E_T_='' AND ZC5_CODCON='" + oItens1:aArray[oItens1:nAT,02] + "' AND ZC5_REVISA='" + oItens1:aArray[oItens1:nAT,04] + "' " + CRLF
	cQuery += " ORDER BY ZC5_ITEM " + CRLF
	//oPedido:aArray[oPedido:nAT,10]
	MemoWrite("C:\HD\Arq Trabalho\NOVAMIX\ACD\QUERYS\CONTRATOS_ITENS.SQL",cQuery)
			
	IF Select("QUAA080I") > 0
		QUAA080I->(dbCloseArea())
	EndIf
		
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "QUAA080I", .T., .F.)
	cPedRoda := QUAA080I->ZC5_CODCON
	nValPed := 0
	While QUAA080I->(!Eof())
			nValPed += QUAA080I->ZC5_PERCEN
	 		Aadd(aItens,{QUAA080I->ZC5_CODVER,;
					 	SubStr(QUAA080I->ZC5_DESC,1,16),;
					 	QUAA080I->ZC5_CALCUL,;
					 	QUAA080I->ZC5_FORMA,;
					 	Alltrim(Transform(QUAA080I->ZC5_PERCEN,"@E 99.99")),;
					 	QUAA080I->ZC5_DEVOLV,;
						," "})										 
	
	QUAA080I->( dbSkip() )

End While 

//04,10,60,40,30,30,30
If Empty(aItens)                                
	aItens := {{Space(4),Space(4),Space(4),Space(4),Space(4),Space(4)," "}}
EndIf

//"S","Item","Produto","Descrição","Quantidade","Qtd. Liberada","Valor Unitario", "Total", "Arm"," "	
oItens:SetArray(aItens)
oItens:bLine := {|| {aItens[oItens:nAt,01],aItens[oItens:nAt,02],aItens[oItens:nAt,03],aItens[oItens:nAt,04],aItens[oItens:nAt,05],aItens[oItens:nAt,06],;
						aItens[oItens:nAt,07]}}						
oItens:Refresh()

If lCombo
	LoadCtrCli()
End If

oPedRoda:Refresh()
oValPed:Refresh()	
	 


Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Monta_SC6	 ³ Autor ³ Luiz Enrique	         ³ Data ³ 15/09/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta a Lista dos ITENS dos pedidos Bloqueados 				 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function LoadCtrCli()

Local oSt			:= LoadBitmap(GetResources(),'BR_VERDE') 
Local oSt2			:= LoadBitmap(GetResources(),'BR_AZUL')    
Local aBloqs		:= {} 
Local cDescProd		:= ""
Local nLiberado		:= 0
Local nTotValIt		:= 0 
Local lCorte		:= .F.
Local cQuery		:= ''

aItens2 := {}

	cQuery := " SELECT ZC7_ITEM,ZC7_CODCTR,ISNULL(ZC7_BANDEI+'-'+(SELECT X5_DESCRI FROM SX5010 WHERE D_E_L_E_T_='' AND X5_TABELA='BA' AND X5_CHAVE=ZC7_BANDEI),'') AS 'BANDEIRA', " + CRLF
	cQuery += " ZC7_CODCLI,ZC7_LOJA,ISNULL((SELECT TOP 1 A1_NOME FROM SA1010 WHERE D_E_L_E_T_='' AND A1_COD=ZC7_CODCLI),'') AS 'CLIENTE', " + CRLF
	cQuery += " ISNULL(ZC7_CODPRO+'-'+(SELECT B1_DESC FROM  SB1010 WHERE D_E_L_E_T_='' AND B1_COD=ZC7_CODPRO),'') AS 'PRODUTO', " + CRLF
	cQuery += " ISNULL(ZC7_CATEGO+'-'+(SELECT X5_DESCRI FROM SX5010 WHERE D_E_L_E_T_='' AND X5_TABELA='X4' AND X5_CHAVE=ZC7_CATEGO),'') AS 'CATEGORIA', " + CRLF
	cQuery += " ISNULL(ZC7_MARCA+'-'+(SELECT X5_DESCRI FROM SX5010 WHERE D_E_L_E_T_='' AND X5_TABELA='X8' AND X5_CHAVE=ZC7_MARCA),'') AS 'MARCA'  " + CRLF
	cQuery += " FROM ZC7010 ZC7 WHERE ZC7.D_E_L_E_T_=''  " + CRLF
	cQuery += " AND ZC7_CODCTR='" + oItens1:aArray[oItens1:nAT,02] + "' " + CRLF
	
	If Empty(cNota)
	If SubStr(cFilCmb3,1,6) <> '999999' .AND. Empty(cCodPro)
		cQuery += " AND ZC7_CATEGO='" + SubStr(cFilCmb3,1,6) + "'  " + CRLF
	End If
	
	If !Empty(cCodPro)
		cQuery += " AND ZC7_CODPRO='" + cCodpro + "' " + CRLF
	End If
	
	If !Empty(cCodCli)
		cQuery += " AND ZC7_CODCLI='" + cCodCli + "'  " + CRLF
	End If
	
	If !Empty(cLojaCli)
		cQuery += " AND ZC7_LOJA='" + cLojaCli + "'  " + CRLF
	End If
	
	If !Empty(cBand) .AND. Empty(cCodCli)
		cQuery += " AND ZC7_BANDEI='" + cBand + "'  " + CRLF
	End If
	End If
	cQuery += " ORDER BY ZC7_ITEM  " + CRLF
	
	MemoWrite("C:\HD\Arq Trabalho\NOVAMIX\ACD\QUERYS\CONTRATOS_CLIXCONTRATO.SQL",cQuery)
			
	IF Select("QUAA080C") > 0
		QUAA080C->(dbCloseArea())
	EndIf
		
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "QUAA080C", .T., .F.)
	//ZC7_ITEM	ZC7_CODCTR	BANDEIRA	ZC7_CODCLI	ZC7_LOJA	CLIENTE	PRODUTO	CATEGORIA	MARCA
	While QUAA080C->(!Eof())
		
	 		Aadd(aItens2,{SubStr(QUAA080C->BANDEIRA,1,14),;
					 	QUAA080C->ZC7_CODCLI,;
					 	QUAA080C->ZC7_LOJA,;
					 	SubStr(QUAA080C->CLIENTE,1,14),;
					 	SubStr(QUAA080C->PRODUTO,1,14),;
					 	SubStr(QUAA080C->CATEGORIA,1,20),;
					 	SubStr(QUAA080C->MARCA,1,20),;
						," "})										 
	
	QUAA080C->( dbSkip() )

End While 

//04,10,60,40,30,30,30
If Empty(aItens2)                                
	aItens2 := {{Space(4),Space(4),Space(4),Space(4),Space(4),Space(4),Space(4)," "}}
EndIf

//"S","Item","Produto","Descrição","Quantidade","Qtd. Liberada","Valor Unitario", "Total", "Arm"," "	
oItens2:SetArray(aItens2)
oItens2:bLine := {|| {aItens2[oItens2:nAt,01],aItens2[oItens2:nAt,02],aItens2[oItens2:nAt,03],aItens2[oItens2:nAt,04],aItens2[oItens2:nAt,05],aItens2[oItens2:nAt,06],;
						aItens2[oItens2:nAt,07],aItens2[oItens2:nAt,08]}}						
oItens2:Refresh()

Return


//**************************************************************
Static Function QA80FIL()

	Local aRet := {}
	

	dbSelectArea("SM0")
	dbGotop()

	aadd(aret,"00-TODAS AS FILIAIS")


	While !Eof()

		//cRet += ";"+SM0->M0_CODFIL+"-"+Alltrim(SM0->M0_FILIAL)
		aadd(aRet,SM0->M0_CODFIL+"-"+Alltrim(SM0->M0_FILIAL))
		dbSkip()

	End While

Return aRet
//**************************************************************
Static Function QA80SX5()

	Local aRet := {}

	dbSelectArea("SX5")
	dbSetOrder(1)
	If dbSeek(xFilial("SX5")+'X4')

		While !Eof() .AND. Alltrim(X5_TABELA) == 'X4'
			
			aadd(aRet,SX5->X5_CHAVE+"-"+Alltrim(SX5->X5_DESCRI))
			dbSkip()
	
		EndDo

	End If
Return aRet

//******************************************************
Static Function ShowNF()

Local cAlias
Local nReg
Local nOpc
aArea := GetArea()
dbSelectArea("SF2")
dbSetOrder(1)

If dbSeek(cFilAnt+cNota+cSerie)
 Mc090Visual(cAlias,nReg,nOpc)
End If

RestArea(aArea)

Return
//******************************************************

Static Function Altera(xOp)

INCLUI := .T.

dbSelectArea("ZC4")
dbSetOrder(1)

If dbSeek(xFilial("ZC4")+oItens1:aArray[oItens1:nAT,02]+oItens1:aArray[oItens1:nAT,04])

	If xOp == 1
		U_QA040TELA(,,6,.T.)
	ElseIf xOp == 2
		U_QA040TELA(,,4,.T.)
	ElseIf xOp == 3
		U_xHisZC4()
	End If
End If

LoadContr(.T.)

Return

