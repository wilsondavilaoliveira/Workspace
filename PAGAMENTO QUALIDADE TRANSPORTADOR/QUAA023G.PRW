#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE "PRCONST.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "TbiConn.ch"

/*/{Protheus.doc} QUAA023G
APONTAMENTO DE BONIFICACOES TRANSPORTADORES
@type function
@version
@author Wilson Davila
@since 01/11/2020
@return return_type, return_description
/*/
User Function QUAA023G()

If !Pergunte("QUAA023G",.T.)
    Return
Else
    MSAguarde( {||Processa()}    , "Aguarde..." ,"Carregando definição das bonificacoes...",.F.)
EndIf



Return

Static Function Processa()

Local aCoors	:= FWGetDialogSize( oMainWnd )
Local cCadastro	:= "APONTAMENTO DE BONIFICACOES"
Local oC1W1 		// Layer pricipal
Local oC1W2 		// Layer secundario
Local oButt1   		// Botoes para o Pedido
//Variaveis para os Browses
Local oPedido		// Lista dos Pedidos
Local cPed			// Codigo do Pedido Atual
Local oBroItp		// Lista dos Itens do Pedido
Local oDesbloq		// Lista dos Pedidos Desbloquados
//Local oBroSC5		// Lista dos Pedidos Bloqueados
Local oPanC1W1		// Paineis na Janela do Pedido
//Paineis para os Botoes de Manutencoes
Local oPanPri
//Local oPanBtPlt
Local oPasta 		//Pastas para "PEDIDOS","DESBLOQUEIOS DO PEDIDO","BLOQUEIOS POR VALOR MINIMO"
//Local oPaniPd		//Painel para os Botoes dos Itens da Separacao
	// Painel dos Botoes para Manutencões
//Local oPanBlok		// Painel para Filtro dos Bloqueios
//Local nInd		:= 1
//Local cSeek
//Local cWhere
Local libera	:= .F.
Local lHist		:= .F.
Local lfirst	:= .T.
Local oHist
Local ocodPedido
Local cPedAtu := Space(TamSx3("C5_NUM")[1])
Local oCBX1
Local aTree := {}
Local oProcess

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
Private oTree1     := Nil
Private oTree2     := Nil
Private oTree3     := Nil
Private cNomeUsu := Alltrim(UsrRetName(__cUserId))

//DEFINE AS LEGENDAS DO MODULO
aAdd(aLegBloq, 	{"BR_VERDE"		,"Liberado"})
aAdd(aLegBloq,	{"BR_AZUL"		,"Liberado Pelo Gestor"})
aAdd(aLegBloq,	{"BR_VERMELHO"	,"Bloqueado"})
aAdd(aLegBloq,	{"BR_LARANJA"	,"Bloqueado-Pedido de saldo(CORTE)"})

libera := .T.

cTxtTit:= "APONTAMENTO DE BONIFICAÇÕES TRANSPORTADOR/MOTORISTA -  Login:  "
cCadastro:= cTxtTit + cNomeUsu +  "       " + Dtoc(Ddatabase) + " - " + Time()

DEFINE FONT oFont4	NAME "Arial" 		SIZE 08,10	BOLD
//DEFINE FONT oFont1 	NAME "Courier New" 	SIZE 5,0   //6,15
DEFINE FONT oFont2	NAME "Arial" 		SIZE 11,15 BOLD
DEFINE FONT oFont5	NAME "Arial" 		SIZE 9,12 BOLD

DEFINE MSDIALOG oDlg1 FROM aCoors[1],aCoors[2] TO aCoors[3],aCoors[4] TITLE cCadastro OF oMainWnd COLOR "W+/W" STYLE nOR(WS_VISIBLE,WS_POPUP) PIXEL

oDlg1:lEscClose:= .F.
oDlg1:lMaximized := .T.
oFWLayer:= FWLayer():New()
oFWLayer:init( oDlg1, .F. ) // Segundo parametro: Cria um botao de fechar utilizado para Dlg sem cabeçalho. Caso for .t.


//COLUNA - JANELA 1=====================================================================================================================================
oFWLayer:addCollumn( "Col01", 33, .F. )
oFWLayer:addCollumn( "Col02", 34, .F. )
oFWLayer:addCollumn( "Col03", 33, .F. )

oFWLayer:addWindow( "Col01", "Win01", "M o t o r i s t a s", 100, .T., .F.)
oFWLayer:addWindow( "Col02", "Win01", "V e i c u l o s", 100, .T., .F.)
oFWLayer:addWindow( "Col03", "Win01", "T r a n s p o r t a d o r a s", 100, .T., .F.)

oC1W1:= oFWLayer:getWinPanel( "Col01", "Win01" )
oC1W2:= oFWLayer:getWinPanel( "Col02", "Win01" )
oC1W3:= oFWLayer:getWinPanel( "Col03", "Win01" )

//Painel Principal dos Botoes para as Manutenções e Pesquisa
//oPanPri	:=TPanel():New(1,3,,oDlg1,oFont2,,,/*CorTexto*/,/*CLR_GREEN*/,80,15,.T.,.T.)
//oPanPri :ALIGN:= CONTROL_ALIGN_TOP

//Painel dos Botoes para Manutenções
oPanBotoes:=TPanel():New(1,3,,oDlg1,/*[aoFont]*/,,,/*CorTexto*/,/*CLR_GREEN*/,290,15,.T.,.T.)
oPanBotoes:ALIGN:= CONTROL_ALIGN_TOP

cPedAtu := AllTrim(TRANSFORM(MV_PAR01,"@R 99/9999"))
@004.7,572 SAY "Periodo:"	SIZE 060,10 OF oDlg1 	PIXEL FONT oFont2 COLOR CLR_RED
@2.0,617 MSGET oCodPedido VAR cPedAtu	SIZE 035,10 WHEN .F. OF oDlg1 	PIXEL FONT oFont2



//Painel para Pesquisa do Pedido
//oPanped	:=TPanel():New(1,3,,oPanPri,oFont2,,,/*CLR_BLUE*/,/*CLR_BLUE*/,380,15,.f.,.f.) //200,07
//oPanped :ALIGN:= CONTROL_ALIGN_RIGHT

//cPedAtu := '123456'


// When libera Valid VldPedido(oPasta:nOption,oPedido,oBroItp,cPedAtu,lHist,oDesbloq) PICTURE "@!"   //NO BORDER
//If cFilAnt == '01' //Filial Sao Paulo
//	@005,005 CHECKBOX oHist		VAR lHist PROMPT "Mostrar Liberados" SIZE 110,7  OF oPanped 	PIXEL FONT oFont2 COLOR CLR_BLUE ON CLICK Atualizar(oPasta:nOption,oPedido,oBroItp,cPedAtu,lHist,oDesbloq,oSaldoPed)
//Endif

//@004.3,235 SAY "Emissão de:"	SIZE 070,10 OF oPanped 	PIXEL FONT oFont2 COLOR CLR_BLUE
//@2.0,305 MSGET oDataDe 	VAR dDataDe	SIZE 070,10 OF oPanped 	PIXEL FONT oFont2;
//valid IIF(lHist,Atualizar(oPasta:nOption,oPedido,oBroItp,cPedAtu,lHist,oDesbloq,oSaldoPed),.T.) PICTURE "@E 99/99/9999"

oButt1:= FWButtonBar():new()
oButt1:Init(oPanBotoes, 17, 25,CONTROL_ALIGN_TOP, .T. )
oButt1:addBtnImage( "final",	  	"Sair", 	   	   		{|| oDlg1:End()}				   						   									   			,,.T.,CONTROL_ALIGN_LEFT)
//oButt1:addBtnImage( "reload",		"Atualiza Lista",		{|| Atualizar(oPasta:nOption,oPedido,oBroItp,"",lHist,oDesbloq,oSaldoPed,.T.)},,.T.,CONTROL_ALIGN_LEFT)
//oButt1:addBtnImage( "poscli",  		"Libera Bloqueio",		{|| ProcBloq (oPasta:nOption,oPedido,oBroItp,lHist,oDesbloq)}				   				,,.T.,CONTROL_ALIGN_LEFT)
//oButt1:addBtnImage( "pedido", 		"Reanalisa Pedido", 	{|| AnalisePed (oPasta:nOption,oPedido,oBroItp,aPedidos[oPedido:nAT,3],lHist,oDesbloq)}	,,.T.,CONTROL_ALIGN_LEFT)
//oButt1:addBtnImage( "produto",		"Ver Saldo Lote",		{|| ShowF4(aLsc6[oBroItp:nAT,4],"01",aLsc61[oBroItp1:nAT,4],oPasta) }								   						   		,,.T.,CONTROL_ALIGN_LEFT)
//oButt1:addBtnImage( "pin",  		"Informar Motivo",		{|| Info_Bloqueio (aPedidos[oPedido:nAT,3],aPedidos[oPedido:nAT,10]),Atualizar(oPasta:nOption,oPedido,oBroItp,"",lHist,oDesbloq,oSaldoPed)}				   				,,.T.,CONTROL_ALIGN_LEFT)


//If Alltrim(CB1->CB1_ROTINA) $ 'ADMIN' //Filial Sao Paulo
	//oButt1:addBtnImage( "btcalend",	"Roteiro",	  			{|| CadRoteiro ()} 												   		   							,,.T.,CONTROL_ALIGN_LEFT)
	//oButt1:addBtnImage( "nco",	   	"Cadastro de Bloqueio",	{|| U_NMCB53A()} 					   				   												,,.T.,CONTROL_ALIGN_LEFT)
	//oButt1:addBtnImage( "GPEIMG32",	"Usuarios",				{|| CadUsuario(oPasta:nOption,oPedido,oBroItp,lHist,oDesbloq,oCBX1)}	   					,,.T.,CONTROL_ALIGN_LEFT)
	//oButt1:addBtnImage( "folder14",	"Parametros", 	   		{|| AtuParamet()}		   			   													  			,,.T.,CONTROL_ALIGN_LEFT)
	//oButt1:addBtnImage( "DESTINOS",	"Cad.TranspxDias Lib.",	{|| U_AXCADPX9() }		,,.T.,CONTROL_ALIGN_LEFT)
//Endif

//oButt1:addBtnImage( "svm", 			"Legenda", 	   			{|| FS53legPed(1,oPasta)}			   				   			   		   				  			,,.T.,CONTROL_ALIGN_LEFT)
//oButt1:addBtnImage( "PRECO", 		"Pos.Financeira", 		{|| xPosCli(oPedido) }	,,.T.,CONTROL_ALIGN_LEFT)
//oButt1:addBtnImage( "cargaseq",	"Imprime Pedidos", 			{|| U_RELPEDBL() }		,,.T.,CONTROL_ALIGN_LEFT)
//oButt1:addBtnImage( "carganew",	"Imprime Cortes", 			{|| U_RELACORTE() }		,,.T.,CONTROL_ALIGN_LEFT)
//oButt1:addBtnImage( "TK_VERTIT","Imprime Posicao Pedidos",	{|| U_RPEDBLFAT() }		,,.T.,CONTROL_ALIGN_LEFT)
//oButt1:addBtnImage( "EXCLUIR",	"Excluir Pedido",  			{|| DelPedido(cFilAnt,aPedidos[oPedido:nAT,3]),Atualizar(oPasta:nOption,oPedido,oBroItp,"",lHist,oDesbloq,oSaldoPed) },,.T.,CONTROL_ALIGN_LEFT)
//oButt1:addBtnImage( "cadeado",  "Bloqueio Interno",			{|| BLQINT(oPasta:nOption,oPedido,oBroItp,"",lHist,oDesbloq,oSaldoPed,.T.) }	,,.T.,CONTROL_ALIGN_LEFT)
//oButt1:addBtnImage( "ALTERA",  "Alterar Pedido",			{|| CBALTPED(aPedidos[oPedido:nAT,3]) } ,,.T.,CONTROL_ALIGN_LEFT)
//DelPedido(cFilAnt,aPedidos[oPedido:nAT,3])

//
//RELACORTE
//PAINEIS PRINCIPAIS
//oPasta:= TFolder():New(000,000,{"PEDIDOS","DESBLOQUEIOS DO PEDIDO","BLOQUEIOS POR VALOR MINIMO"},{},oC1W1 ,,,,.T.,.F.,392,244,)//392,244
//oPasta 			:= TFolder():New(000,000,{" P E D I D O S ","H I S T O R I C O   D E S B L O Q U E I O S","PEDIDOS GERADOS DE SALDO (C O R T E)"},{},oC1W1 ,,,,.T.,.F.,392,244,)//392,244
//oPasta 			:= TFolder():New(000,000,{" P E D I D O S ","H I S T O R I C O  BLOQUEIOS / DESBLOQUEIOS","ALTERA ITENS PEDIDO"},{},oC1W1 ,,,,.T.,.F.,392,244,)//392,244

//oPasta 			:= TFolder():New(000,000,{"A P O N T A M E N T O S"},{},oC1W1 ,,,,.T.,.F.,392,244,)//392,244
//oPasta:align 	:= CONTROL_ALIGN_ALLCLIENT


//oProcess := MsNewProcess():New({|lEnd| T114299(@oProcess, @lEnd) },"Teste MsNewProcess","Lendo Registros do Pedido de Vendas",.T.)



//MSAguarde( {||CriaTab()}    , "Aguarde..." ,"Carregando definição das bonificacoes...",.F.)
//MSAguarde( {||Verif_doc()}  , "Aguarde..." ,"Carregando Arvore...",.F.)
CriaTab()
Verif_doc()

**Cria a Tree MOTORISTAS ===============================================================================================================================
//DBTree(): New ( [ nTop], [ nLeft], [ nBottom], [ nRight], [ oWnd],[ bChange], [ bRClick], [ lCargo], [ lDisable], [ oFont], [ cHeaders] )

oTree1 := DbTree():New(000,000,000,000,oC1W1,,,.T.)
oTree1:Align := CONTROL_ALIGN_ALLCLIENT
oTree1:bLDblClick := {||click(oTree1)}
oTree1:BeginUpdate()
//oTree1:AddTree       ('MOTORISTAS                                                            ' ,.T.,"FOLDER12"  ,"FOLDER13"  ,,,'00000001')
//oTree1:TreeSeek('00000001')

cCodMot := ''
//aTree
//[1](cAlias)->(CODM)
//[2](cAlias)->(MOTO)
//[3](cAlias)->(CODBON)
//[4](cAlias)->(BONIF)
//[5](cAlias)->(PBD_FREQUE)
//[6](cAlias)->(REG)
//[7](cAlias)->(PC5_DTAPON)
//[8](cAlias)->(PC5_USRAPO)
//[9](cAlias)->(PC5_TPAPOM)

aTree := LoadTree("M")

For i:=1 to Len(aTree)

    cCargo1 := AllTrim(aTree[1][1])

    If cCodMot <> AllTrim(aTree[i][1])

        If i<>1
            oTree1:EndTree()
        EndIf

        oTree1:AddTree(Padl(AllTrim(aTree[i][1])+"-"+AllTrim(aTree[i][2]),100),,"CLIENTE","MSGFORWD",,,AllTrim(aTree[i][1]))
        //oTree1:TreeSeek( AllTrim(aTree[i][1]) )

        //DBTree(): AddItem ( [ cPrompt], [ cCargo], [ cRes1], [ cRes2], [ cFile1], [ cFile2], [ nTipo] )
        //oTree1:AddItem   (AllTrim(aTree[i][4])+AllTrim(aTree[i][5]),StrZero(aTree[i][6],8),"BPMSTASK2","BPMSTASK2",,,2)
        oTree1:AddTreeItem   (AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-"+StrZero(aTree[i][6],8),"BPMSTASK2",,StrZero(aTree[i][6],8))
        //oTree1:TreeSeek( StrZero(aTree[i][6],8) )

        If !Empty(AllTrim(aTree[i][7]))
            oTree1:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"*"+dtoc(stod(AllTrim(aTree[i][7])))+"-"+AllTrim(aTree[i][8])+"-"+StrZero(aTree[i][6],8),StrZero(aTree[i][6],8))
            If !AllTrim(aTree[i][8]) == "Doc.VENCIDO"
                oTree1:ChangeBmp("CHECKED","CHECKED",,,StrZero(aTree[i][6],8))
            Else
                oTree1:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
            EndIf
        EndIf
        If !Empty(AllTrim(aTree[i][8])) .AND. Empty(AllTrim(aTree[i][7]))
            oTree1:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"*"+AllTrim(aTree[i][8])+"-"+StrZero(aTree[i][6],8),StrZero(aTree[i][6],8))
            oTree1:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
        EndIf

        cCodMot := AllTrim(aTree[i][1])
    Else
        //oTree1:AddItem   (AllTrim(aTree[i][4])+AllTrim(aTree[i][5]),"BPMSTASK2",,StrZero(aTree[i][6],8) )
        //oTree1:AddItem   (AllTrim(aTree[i][4])+AllTrim(aTree[i][5]),StrZero(aTree[i][6],8),"BPMSTASK2","BPMSTASK2",,,1)
        //oTree1:TreeSeek( cCargo2 )
        oTree1:AddTreeItem   (AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-"+StrZero(aTree[i][6],8),"BPMSTASK2",,StrZero(aTree[i][6],8))
        //oTree1:TreeSeek( StrZero(aTree[i][6],8) )
        //oTree1:TreeSeek( cCargo2 )

        If !Empty(AllTrim(aTree[i][7]))
            oTree1:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"*"+dtoc(stod(AllTrim(aTree[i][7])))+"-"+AllTrim(aTree[i][8])+"-"+StrZero(aTree[i][6],8),StrZero(aTree[i][6],8))

            If !AllTrim(aTree[i][8]) == "Doc.VENCIDO"
                oTree1:ChangeBmp("CHECKED","CHECKED",,,StrZero(aTree[i][6],8))
            Else
                oTree1:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
            EndIf
        EndIf
        If !Empty(AllTrim(aTree[i][8])) .AND. Empty(AllTrim(aTree[i][7]))
            oTree1:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"*"+AllTrim(aTree[i][8])+"-"+StrZero(aTree[i][6],8),StrZero(aTree[i][6],8))
            oTree1:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
        EndIf

    EndIf

 Next i

oTree1:TreeSeek(cCargo1)
oTree1:EndUpdate()
oTree1:EndTree()

/*
**Cria a Tree VEICULOS ===============================================================================================================================
//DBTree(): New ( [ nTop], [ nLeft], [ nBottom], [ nRight], [ oWnd],[ bChange], [ bRClick], [ lCargo], [ lDisable], [ oFont], [ cHeaders] )
oTree2 := DbTree():New(000,000,000,000,oC1W2,,,.T.)
oTree2:Align := CONTROL_ALIGN_ALLCLIENT
oTree2:AddTree       ('VEICULOS                                                             ' ,           ,"FOLDER12"  ,"FOLDER13"  ,,,'00000002')
oTree2:bLDblClick := {||click(oTree2)}
oTree2:BeginUpdate()
oTree2:TreeSeek('00000002')

aTree := LoadTree("V")
cCodMot := ''

//aTree
//[1](cAlias)->(CODM)
//[2](cAlias)->(MOTO)
//[3](cAlias)->(CODBON)
//[4](cAlias)->(BONIF)
//[5](cAlias)->(PBD_FREQUE)
//[6](cAlias)->(REG)
//[7](cAlias)->(PC5_DTAPON)
//[8](cAlias)->(PC5_USRAPO)
//[9](cAlias)->(PC5_TPAPOM)

For i:=1 to Len(aTree)
    If cCodMot <> AllTrim(aTree[i][1])
        If i<>1
            oTree2:EndTree()
        EndIf
        oTree2:AddTree       (AllTrim(aTree[i][1])+"-"+AllTrim(aTree[i][2]),,"CARGA","CARGASEQ",,,AllTrim(aTree[i][1]))
        oTree2:TreeSeek( AllTrim(aTree[i][1]) )

        oTree2:AddTreeItem   (AllTrim(aTree[i][4])+AllTrim(aTree[i][5]),"BPMSTASK",,StrZero(aTree[i][6],8))
        oTree2:TreeSeek( StrZero(aTree[i][6],8) )

        If !Empty(AllTrim(aTree[i][7]))
            oTree2:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"*"+dtoc(stod(AllTrim(aTree[i][7])))+"-"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))
            If !AllTrim(aTree[i][8]) == "Doc.VENCIDO"
                oTree2:ChangeBmp("CHECKED","CHECKED",,,StrZero(aTree[i][6],8))
            Else
                oTree2:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
            EndIf
        EndIf
        If !Empty(AllTrim(aTree[i][8])) .AND. Empty(AllTrim(aTree[i][7]))
            oTree2:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"*"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))
            oTree2:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
        EndIf


        cCodMot := AllTrim(aTree[i][1])
    Else
        oTree2:AddTreeItem   (AllTrim(aTree[i][4])+AllTrim(aTree[i][5]),"BPMSTASK1",,StrZero(aTree[i][6],8) )
        oTree2:TreeSeek( StrZero(aTree[i][6],8) )
        If !Empty(AllTrim(aTree[i][7]))
            oTree2:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"*"+dtoc(stod(AllTrim(aTree[i][7])))+"-"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))

            If !AllTrim(aTree[i][8]) == "Doc.VENCIDO"
                oTree2:ChangeBmp("CHECKED","CHECKED",,,StrZero(aTree[i][6],8))
            Else
                oTree2:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
            EndIf
        EndIf
        If !Empty(AllTrim(aTree[i][8])) .AND. Empty(AllTrim(aTree[i][7]))
            oTree2:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"*"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))
            oTree2:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
        EndIf
    EndIf

 Next i

oTree2:TreeSeek('00000002')
oTree2:EndUpdate()
oTree2:EndTree()

**Cria a Tree TRANSPORTADORAS ===============================================================================================================================
//DBTree(): New ( [ nTop], [ nLeft], [ nBottom], [ nRight], [ oWnd],[ bChange], [ bRClick], [ lCargo], [ lDisable], [ oFont], [ cHeaders] )
oTree3 := DbTree():New(000,000,000,000,oC1W3,,,.T.)
oTree3:Align := CONTROL_ALIGN_ALLCLIENT
oTree3:bLDblClick := {||click(oTree3)}
oTree3:BeginUpdate()
oTree3:AddTree       ('TRANSPORTADORAS                                                           ' ,           ,"FOLDER12"  ,"FOLDER13"  ,,,'00000003')
oTree3:TreeSeek('00000003')

aTree := LoadTree("T")
cCodMot := ''
//aTree
//[1](cAlias)->(CODM)
//[2](cAlias)->(MOTO)
//[3](cAlias)->(CODBON)
//[4](cAlias)->(BONIF)
//[5](cAlias)->(PBD_FREQUE)
//[6](cAlias)->(REG)
//[7](cAlias)->(PC5_DTAPON)
//[8](cAlias)->(PC5_USRAPO)
//[9](cAlias)->(PC5_TPAPOM)
//"PREDIO","S4WB014B"
For i:=1 to Len(aTree)
    If cCodMot <> AllTrim(aTree[i][1])
        If i<>1
            oTree3:EndTree()
        EndIf
        oTree3:AddTree       (AllTrim(aTree[i][1])+"-"+AllTrim(aTree[i][2]),,"PREDIO","S4WB014B",,,AllTrim(aTree[i][1]))
        oTree3:TreeSeek( AllTrim(aTree[i][1]) )

        oTree3:AddTreeItem   (AllTrim(aTree[i][4])+AllTrim(aTree[i][5]),"BPMSTASK1",,StrZero(aTree[i][6],8))
        oTree3:TreeSeek( StrZero(aTree[i][6],8) )

        If !Empty(AllTrim(aTree[i][7]))
            oTree3:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"*"+dtoc(stod(AllTrim(aTree[i][7])))+"-"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))
            If !AllTrim(aTree[i][8]) == "Doc.VENCIDO"
                oTree3:ChangeBmp("CHECKED","CHECKED",,,StrZero(aTree[i][6],8))
            Else
                oTree3:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
            EndIf
        EndIf
        If !Empty(AllTrim(aTree[i][8])) .AND. Empty(AllTrim(aTree[i][7]))
            oTree3:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"*"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))
            oTree3:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
        EndIf


        cCodMot := AllTrim(aTree[i][1])
    Else
        oTree3:AddTreeItem   (AllTrim(aTree[i][4])+AllTrim(aTree[i][5]),"BPMSTASK2",,StrZero(aTree[i][6],8) )
        oTree3:TreeSeek( StrZero(aTree[i][6],8) )
        If !Empty(AllTrim(aTree[i][7]))
            oTree3:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"*"+dtoc(stod(AllTrim(aTree[i][7])))+"-"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))

            If !AllTrim(aTree[i][8]) == "Doc.VENCIDO"
                oTree3:ChangeBmp("CHECKED","CHECKED",,,StrZero(aTree[i][6],8))
            Else
                oTree3:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
            EndIf
        EndIf
        If !Empty(AllTrim(aTree[i][8])) .AND. Empty(AllTrim(aTree[i][7]))
            oTree3:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"*"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))
            oTree3:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
        EndIf
    EndIf

 Next i

oTree3:TreeSeek('00000003')
oTree3:EndUpdate()
oTree3:EndTree()
*/
//oPasta:bChange 	:= {|| Atualizar(oPasta:nOption,oPedido,oBroItp,"",lHist,oDesbloq,oSaldoPed)}

//PEDIDOS===========================================================================================================================================
//@ 01,01 LISTBOX oPedido Fields HEADER "S","OK ","Pedido","Cliente","Estado","Cidade","Cep","Data Pedido","Último Bloqueio","Data Entrega","Horario Desbloqueio","Ocorrencia" ;
//SIZES {06,03,15,30,12,20,18,18,40,20,20,40} SIZE 490,095 PIXEL of oPasta:aDialogs[1] ;

//@ 01,01 LISTBOX oPedido Fields HEADER "S","OK ","Pedido","Tp.Operacao","Cliente","Estado","Cidade","Cep","Obedece LC","Data Pedido","Último Bloqueio","Data Entrega","Horario Desbloqueio","Ocorrencia";
//SIZES {06,03,15,03,30,12,20,18,18,40,20,20,40} SIZE 490,095 PIXEL of oPasta:aDialogs[1] ;
//ON DBLCLICK Lin_OnOff(oPedido,aPedidos,oBroItp,lHist,oDesbloq,oSaldoPed);
//ON CHANGE U_xRodape( aPedidos[oPedido:nAT,3] )

//oPedido:Align := CONTROL_ALIGN_ALLCLIENT
//oPedido:Refresh()

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

//bKeyF4 := SetKey( VK_F4 , Nil )
//SetKey( VK_F4 , { || cEditProd(oBroItp1) } )

//@ 01,01 LISTBOX oSaldoPed FIELDS HEADER "S","Pedido","Cliente","Estado","Cidade","Cep","Data do Pedido","Data Desbloqueio", "Horario Liberacao","Observação"," " ;
//SIZES {05,20,20,20,20,20,20,20,20,35,02} SIZE 490,095 OF oPasta:aDialogs[3] PIXEL ;
//ON DBLCLICK AtItemSdo(aSaldoPed[oSaldoPed:nAT,2],oBroItp)
//oSaldoPed:Align := CONTROL_ALIGN_ALLCLIENT  //nOption,oBroItp,cPedido
//oSaldoPed:Refresh()

//Painel para Filtro dos Bloqueios==============================================================================================================================
//@08.0,140 COMBOBOX oCBX1 VAR cFilBloq1 ITEMS aOrd1 SIZE 80,03 PIXEL OF oC1W1 //FONT oDlg1:oFont
//oCbx1:bChange := {|| nOrd := oCbx1:nAt,Atualizar(oPasta:nOption,oPedido,oBroItp,"",lHist,oDesbloq,oSaldoPed,.T.)}
//oCBX1:ALIGN:= CONTROL_ALIGN_TOP
//oCBX1:Refresh()


//COLUNA1 - JANELA 2 =====================================================================================================================================

//oFWLayer:addWindow( "Col01", "Win02", "RELAÇÃO DOS ITENS", 50, .T., .f. )
//oC1W2	:= oFWLayer:getWinPanel( "Col01", "Win02")

//Relacao dos ITENS ;;;;; oSt,C6_ITEM,C6_PRODUTO,cDescProd,C6_QTDVEN,C6_QUANTLI,C6_PRCVEN,C6_VALOR
//@ 01,01 LISTBOX oBroItp FIELDS HEADER ;
//"S","PEDIDO","IT","CODPRO","PRODUTO","QTD.PED","SEG.UM","QTD.LIB","VR.UNIT","VR.TAB", "TOTAL","ARM","REPRESENTANTE", " " ;
//SIZES {5,6,2,30,15,10,10,15,15,15,10,10,2} SIZE 550,100 OF oC1W2 PIXEL ON DBLCLICK IIF(!lHist,xMat460(oBroItp,oPedido,lHist,oDesbloq,oSaldoPed),.T.)

//oBroItp:align := CONTROL_ALIGN_ALLCLIENT

//==PAINEL TOTALIZADOR RODAPE ========================================================================================
//oPanRoda 		:= TPanel():New(1,3,,oC1W2,oFont2,,,/*CorTexto*/,/*CLR_GREEN*/,80,15,.T.,.T.)
//oPanRoda:ALIGN 	:= CONTROL_ALIGN_BOTTOM

//@004.3,005 SAY "Pedido:"	SIZE 060,10 OF oPanRoda 	PIXEL FONT oFont2 COLOR CLR_RED
//@2.0,060 MSGET oPedRoda 	VAR cPedRoda	SIZE 060,10 OF oPanRoda WHEN .F. PIXEL FONT oFont2

//@004.3,130 SAY "Valor Pedido:"	SIZE 100,10 OF oPanRoda 		PIXEL FONT oFont2 COLOR CLR_RED
//@2.0,200 MSGET oValPed 	VAR nValPed	SIZE 080,10 OF oPanRoda WHEN .F. PIXEL FONT oFont2 PICTURE "@E 999,999.99"

//@004.3,285 SAY "Kgs Pedido:"	SIZE 100,10 OF oPanRoda 		PIXEL FONT oFont2 COLOR CLR_RED
//@2.0,350 MSGET oKgsPed 	VAR nKgsPed	SIZE 080,10 OF oPanRoda WHEN .F.  PIXEL FONT oFont2 PICTURE "@E 99,999.999"
//====================================================================================================================


//If lfirst
//	Atualizar(oPasta:nOption,oPedido,oBroItp,"",lHist,oDesbloq,oSaldoPed,.T.)
	//lfirst := .F.
//Endif

ACTIVATE MSDIALOG oDlg1

//SET KEY VK_F4 TO

Return


/*/{Protheus.doc} click
description
@type function
@version
@author Wilson Davila
@since 01/11/2020
@return return_type, return_description
/*/
Static Function click(oTree)

Local nRec := Val(oTree:GetCargo())

    If oTree:Nivel() == 3 .AND. !"Documentacao" $ oTree:GetPrompt(.T.)
        If ! '*' $ oTree:GetPrompt(.T.)

            Grava(nRec,.T.)
            oTree:ChangePrompt(oTree:GetPrompt(.T.) +"*"+dToc(Ddatabase)+"-"+cNomeUsu,oTree:GetCargo())
            oTree:ChangeBmp("CHECKED","CHECKED",,,oTree:GetCargo())
            oTree:PTUpdateNodes('3')
            oTree:PTRefresh()
            oTree:TreeSeek( "9"+StrZero( Val(oTree:GetCargo()),7) )

        ElseIf '*' $ oTree:GetPrompt(.T.) .AND. !'*NAO CONFORME*' $ oTree:GetPrompt(.T.)

            oTree:ChangeBmp("BPMSTASK1","BPMSTASK1",,,oTree:GetCargo())
            cPrompt := ''
            For i := 1 to Len(oTree:GetPrompt(.T.))
                If SubStr(oTree:GetPrompt(.T.),i,1) <> '*'
                    cPrompt  += SubStr(oTree:GetPrompt(.T.),i,1)
                Else
                    i := Len(oTree:GetPrompt(.T.))
                EndIf
            Next i
            cPrompt += "*NAO CONFORME*-"+dToc(Ddatabase)+"-"+cNomeUsu
            Grava(nRec,.F.)
            oTree:ChangePrompt(cPrompt,oTree:GetCargo())
            oTree:PTUpdateNodes('3')
            oTree:PTRefresh()


        ElseIf '*NAO CONFORME*' $ oTree:GetPrompt(.T.)

            oTree:ChangeBmp("BPMSTASK2","BPMSTASK2",,,oTree:GetCargo())
            cPrompt := ''
            For i := 1 to Len(oTree:GetPrompt(.T.))
                If SubStr(oTree:GetPrompt(.T.),i,1) <> '*'
                    cPrompt  += SubStr(oTree:GetPrompt(.T.),i,1)
                Else
                    i := Len(oTree:GetPrompt(.T.))
                EndIf
            Next i
            Grava(nRec,.F.)
            oTree:ChangePrompt(cPrompt,oTree:GetCargo())
            oTree:PTUpdateNodes('3')
            oTree:PTRefresh()

        EndIf
    EndIf
Return


Static Function Grava(nRec,lInclui)

    PC5->( dbgoto(nRec) )
    PC5->( RecLock("PC5",.F.) )
        PC5->PC5_DTAPON := IIF(lInclui,dDataBase,CTOD("  /  /    "))
        PC5->PC5_USRAPO := IIF(lInclui,cNomeUsu,"")
    PC5->( MsUnlock() )

Return



/*/{Protheus.doc} LoadTree
description
@type function
@version
@author Wilson Davila
@since 16/11/2020
@param cTipo, character, param_description
@return return_type, return_description
/*/
Static Function LoadTree(cTipo)

Local cAlias    := GetNextAlias()
Local aRet      := {}


If cTipo == 'M'

    BeginSql Alias cAlias

        %noparser%

        SELECT TOP 10 PC5_CODMOT AS 'COD',PC5_DTAPON,PC5_USRAPO,PBB_NOME AS 'DESC',PC5_CODBON AS 'CODBON',
        PBD_DESCR AS 'BONIF',PBD_FREQUE,PC5.R_E_C_N_O_ AS 'REG',PC5_ITAPON,PC5_TPAPOM
        FROM %Table:PC5% PC5
        INNER JOIN %Table:PBB% PBB ON PBB_FILIAL=PC5_FILIAL AND PC5_CODMOT=PBB_CODIGO AND PBB.%notDel%
        INNER JOIN %Table:PBD% PBD ON PBD_FILIAL=PBB_FILIAL AND PBD_TIPO=PC5_TIPO AND PBD_CODTIP+'.'+PBD_CODIGO=PC5_CODBON
        AND PBD.%notDel%
        WHERE PC5_FILIAL=%Exp:cFilAnt% AND PC5.%notDel% AND PC5_TIPO=%Exp:cTipo% AND PC5_PERIOD=%Exp:MV_PAR01%
        ORDER BY PBB_CODIGO,PBD_CODTIP+'.'+PBD_CODIGO,PC5_ITAPON

    EndSql

ElseIf cTipo == 'V'

    BeginSql Alias cAlias

        %noparser%

        SELECT PC5_CODVEI AS 'COD',PC5_DTAPON,PC5_USRAPO,LTRIM(RTRIM(PBJ_DESCRI))+'-'+
        ISNULL((SELECT TOP 1 A2_NOME FROM %Table:SA2% SA2 WHERE SA2.%notDel%  AND  A2_COD = PBC_CODTRA),'') AS 'DESC',
        PBD_CODTIP+'.'+PBD_CODIGO AS 'CODBON',PBD_DESCR AS 'BONIF',PBD_FREQUE,PC5.R_E_C_N_O_ AS 'REG',PC5_ITAPON,PC5_TPAPOM
        FROM %Table:PC5% PC5
        INNER JOIN %Table:PBD% PBD ON PBD_FILIAL=PC5_FILIAL AND PBD_TIPO=%Exp:cTipo% AND PBD.%notDel% AND PBD_CODTIP+'.'+PBD_CODIGO=PC5_CODBON
        INNER JOIN %Table:PBC% PBC ON PBC_FILIAL=PC5_FILIAL AND PBC_CODMOT=PC5_CODVEI AND PBC.%notDel%
        INNER JOIN %Table:PBJ% PBJ ON PBJ_FILIAL=PC5_FILIAL AND PBJ_CODIGO=PC5_CODVEI AND PBJ.%notDel% AND PBJ_STATUS='A'
        WHERE PC5_FILIAL=%Exp:cFilAnt% AND PC5.%notDel% AND PC5_PERIOD=%Exp:MV_PAR01%
        ORDER BY PBJ_CODIGO,PBD_CODTIP+'.'+PBD_CODIGO,PC5_ITAPON

    EndSql

ElseIf cTipo == 'T'

    BeginSql Alias cAlias

        %noparser%

        SELECT PC5_CODTRA AS 'COD',PC5_DTAPON,PC5_USRAPO,
        (SELECT TOP 1 A2_NOME FROM %Table:SA2% SA2 WHERE A2_COD=PC5_CODTRA AND SA2.%notDel%) AS 'DESC',
        PBD_CODTIP+'.'+PBD_CODIGO AS 'CODBON',PBD_DESCR AS 'BONIF',PBD_FREQUE,PC5.R_E_C_N_O_ AS 'REG',PC5_ITAPON,PC5_TPAPOM
        FROM %Table:PC5% PC5
        INNER JOIN %Table:PBD% PBD ON PBD_FILIAL=%Exp:cFilAnt% AND PBD_TIPO=%Exp:cTipo% AND PBD.%notDel%
        AND PBD_CODTIP+'.'+PBD_CODIGO=PC5_CODBON
        WHERE PC5.%notDel% AND PC5_PERIOD=%Exp:MV_PAR01%
        ORDER BY PC5_CODTRA,PBD_CODTIP+'.'+PBD_CODIGO,PC5_ITAPON

    EndSql

EndIf

If (cAlias)->( Eof() )
    AADD(aRet,{"","","","","","","","",""})
EndIf

While (cAlias)->( !Eof())

    //For a := 1 To IIF((cAlias)->(PBD_FREQUE)==0,1,(cAlias)->(PBD_FREQUE))
        AADD(aRet,{;
        (cAlias)->(COD),;
        (cAlias)->(DESC),;
        (cAlias)->(CODBON),;
        (cAlias)->(BONIF),;
        iif((cAlias)->(PC5_TPAPOM)=="A",'>Apontamento(' + cValToChar((cAlias)->(PC5_ITAPON)) + ')','>Documentacao'),;
        (cAlias)->(REG),;
        (cAlias)->(PC5_DTAPON),;
        (cAlias)->(PC5_USRAPO),;
        (cAlias)->(PC5_TPAPOM);
        })
    //Next a
    (cAlias)->( dbSkip())

EndDo



Return aRet


Static Function CriaTab(oProcess,lEnd)

Local cAlias    := GetNextAlias()
Local aRet      := {}


    PC5->( dbSetOrder(1) )

    If !PC5->( dbSeek(xFilial("PC5")+MV_PAR01) )

        BeginSql Alias cAlias

        %noparser%

            SELECT PBB_CODIGO AS 'CODM',PBB_NOME AS 'DESC','' AS 'CODV',PBC_CODTRA AS 'CODT',PBD_CODTIP+'.'+PBD_CODIGO AS 'CODBON',
            PBD_DESCR AS 'BONIF',PBD_FREQUE,'M' AS 'TIPO',PBD_TPAPOM
            FROM %Table:PBB%  PBB
            INNER JOIN %Table:PBD% PBD ON PBD_FILIAL=PBB_FILIAL AND PBD_TIPO='M' AND PBD.%notDel%
            INNER JOIN %Table:PBC% PBC ON PBC_FILIAL=PBB_FILIAL AND PBC_CODMOT=PBB_CODIGO AND PBC.%notDel%
            WHERE PBB_FILIAL=%Exp:cFilAnt% AND PBB.%notDel% AND PBB_STATUS='A'
            UNION ALL
            SELECT '' AS 'CODM',LTRIM(RTRIM(PBJ_DESCRI))+'-'+
            ISNULL((SELECT TOP 1 A2_NOME FROM %Table:SA2% SA2 WHERE SA2.%notDel%  AND  A2_COD = PBC_CODTRA),'') AS 'DESC',
            PBJ_CODIGO AS 'CODV',PBC_CODTRA AS 'CODT',PBD_CODTIP+'.'+PBD_CODIGO AS 'CODBON',PBD_DESCR AS 'BONIF',PBD_FREQUE,'V' AS 'TIPO',PBD_TPAPOM
            FROM %Table:PBJ% PBJ
            INNER JOIN %Table:PBD% PBD ON PBD_FILIAL=PBJ_FILIAL AND PBD_TIPO='V' AND PBD.%notDel%
            INNER JOIN %Table:PBC% PBC ON PBC_FILIAL=PBJ_FILIAL AND PBC_CODMOT=PBJ_CODIGO AND PBC.%notDel%
            WHERE PBJ_STATUS='A' AND PBJ_FILIAL=%Exp:cFilAnt% AND PBJ.%notDel%
            UNION ALL
            SELECT DISTINCT '' AS 'CODM',A2_NOME 'DESC',
            '' AS 'CODV',A2_COD AS 'CODT',PBD_CODTIP+'.'+PBD_CODIGO AS 'CODBON',PBD_DESCR AS 'BONIF',PBD_FREQUE,'T' AS 'TIPO',PBD_TPAPOM
            FROM %Table:SA2% SA2
            INNER JOIN %Table:PBD% PBD ON PBD_FILIAL=%Exp:cFilAnt% AND PBD_TIPO='T' AND PBD.%notDel%
            WHERE SA2.%notDel% AND A2_MSBLQL='2' AND A2_COD IN
            (SELECT DISTINCT A2_COD FROM %Table:SA2% SA21 WHERE SA21.%notDel%
            AND A2_COD IN (SELECT LBB_CODFOR FROM %Table:LBB% LBB WHERE LBB_FILIAL=%Exp:cFilAnt% AND LBB_TIPREG='2' AND LBB.%notDel%))
            ORDER BY TIPO,CODM,CODV,CODT,CODBON
        EndSql


        While (cAlias)->(!Eof())

            For a := 1 To IIF((cAlias)->(PBD_FREQUE)==0,1,(cAlias)->(PBD_FREQUE))
                RecLock("PC5",.T.)
                    PC5->PC5_FILIAL := cFilAnt
                    PC5->PC5_PERIOD := MV_PAR01
                    PC5->PC5_CODMOT := (cAlias)->(CODM)
                    PC5->PC5_CODVEI := (cAlias)->(CODV)
                    PC5->PC5_CODTRA := (cAlias)->(CODT)
                    PC5->PC5_CODBON := (cAlias)->(CODBON)
                    PC5->PC5_FREQUE := (cAlias)->(PBD_FREQUE)
                    PC5->PC5_ITAPON := a
                    PC5->PC5_TIPO   := (cAlias)->(TIPO)
                    PC5->PC5_TPAPOM := (cAlias)->(PBD_TPAPOM)
                MsUnlock()
            Next a

        (cAlias)->(dbSkip())

        EndDo
    EndIf


Return


Static Function Verif_doc(oProcess,lEnd)

Local cAlias    := GetNextAlias()

        BeginSql Alias cAlias

        %noparser%

            SELECT PC5.R_E_C_N_O_ AS REG,PC5_CODMOT,PC5_CODVEI,PC5_CODTRA,PC5_TIPO,PC5_CODBON,PBD_DESCR,
            CASE WHEN PC5_TIPO='M'
            THEN ISNULL((SELECT PBG_DTVALI FROM %Table:PBG% PBG WHERE PBG.%notDel% AND PBG_CODMOT=PC5_CODMOT AND PBG_TIPO=PC5_TIPO AND PBG_CODTIP=PBD_TIPDOC),'')
            WHEN PC5_TIPO='T'
            THEN ISNULL((SELECT PBG_DTVALI FROM %Table:PBG% PBG WHERE PBG.%notDel% AND PBG_CODTRA=PC5_CODTRA AND PBG_TIPO=PC5_TIPO AND PBG_CODTIP=PBD_TIPDOC),'')
            WHEN PC5_TIPO='V'
            THEN ISNULL((SELECT PBG_DTVALI FROM %Table:PBG% PBG WHERE PBG.%notDel% AND PBG_CODVEI=PC5_CODVEI AND PBG_TIPO=PC5_TIPO AND PBG_CODTIP=PBD_TIPDOC),'')
            END AS 'DATAV'
            FROM %Table:PC5% PC5
            INNER JOIN %Table:PBD% PBD ON PBD_FILIAL=PC5_FILIAL AND PBD_CODTIP+'.'+PBD_CODIGO=PC5_CODBON AND PBD.%notDel%
            WHERE PC5.%notDel% AND PC5_TPAPOM='D' AND PC5_FILIAL=%Exp:cFilAnt% AND PC5_PERIOD=%Exp:MV_PAR01%

        EndSql

        While (cAlias)->(!Eof())
            PC5->( dbGoTo( (cAlias)->(REG) ) )
            //IncProc()
            PC5->( RecLock("PC5",.F.) )
                If Empty( (cAlias)->(DATAV) )
                    PC5->PC5_USRAPO := 'SEM Documento'
                    PC5->PC5_DTAPON := CTOD("  /  /    ")
                ElseIf STOD((cAlias)->(DATAV)) < CTOD('01/'+SubStr(MV_PAR01,1,2)+'/'+SubStr(MV_PAR01,3,4))
                    PC5->PC5_USRAPO := 'Doc.VENCIDO'
                    PC5->PC5_DTAPON := STOD((cAlias)->(DATAV))
                Else
                    PC5->PC5_USRAPO := 'Documento OK'
                    PC5->PC5_DTAPON := STOD((cAlias)->(DATAV))
                EndIf
            PC5->( MsUnlock() )
        (cAlias)->( dbSkip() )
        EndDo

Return





