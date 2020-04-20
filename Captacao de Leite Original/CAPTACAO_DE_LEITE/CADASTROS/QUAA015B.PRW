#INCLUDE "PROTHEUS.CH" 
#INCLUDE "RWMAKE.CH" 
#INCLUDE 'COLORS.CH' 
#INCLUDE "TOPCONN.CH"  
#INCLUDE "PRCONST.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "TbiConn.ch"
/*/{Protheus.doc} QUAA015B() ============================================================================================================================
Tela para ordenar campos na geracao da planilha e na tela do simulador
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
User Function QUAA015B() 

	Local aCoors	:= FWGetDialogSize( oMainWnd )
	Local cCadastro	:= "ORDEM DE CODIGOS DE BONIFICACAO NA PLANILHA"  
	Local oC1W1 		   
	Local oButt1   		
	Local oOrdem		
	Local oPanPri
	
	Private oPanBotoes
	Private oDlg1
	Private aOrdem		:= {} 
	
	
	DEFINE FONT oFont4	NAME "Arial" SIZE 08,10	BOLD 
	DEFINE FONT oFont2	NAME "Arial" SIZE 11,17	BOLD 
	DEFINE FONT oFont5	NAME "Arial" SIZE 9,12 	BOLD  
	 
	DEFINE MSDIALOG oDlg1 FROM aCoors[1],aCoors[2] TO aCoors[3],aCoors[4] TITLE cCadastro OF oMainWnd COLOR "W+/W" STYLE nOR(WS_VISIBLE,WS_POPUP) PIXEL 
	
	oDlg1:lEscClose:= .F.
	oDlg1:lMaximized := .T.	
	oFWLayer:= FWLayer():New()
	oFWLayer:init( oDlg1, .F. ) // Segundo parametro: Cria um botao de fechar utilizado para Dlg sem cabeçalho. Caso for .t.	  
	
	
	//COLUNA - JANELA 1=====================================================================================================================================
	oFWLayer:addCollumn( "Col01", 100, .F. )
	oFWLayer:addWindow( "Col01", "Win01", cCadastro, 100, .T., .F.)
	oC1W1:= oFWLayer:getWinPanel( "Col01", "Win01" )  
	 
	//Painel Principal dos Botoes para as Manutencoes e Pesquisa
	oPanPri	:=TPanel():New(1,3,,oC1W1,oFont2,,,/*CorTexto*/,/*CLR_GREEN*/,80,15,.T.,.T.) 
	oPanPri :ALIGN:= CONTROL_ALIGN_TOP 
	
	//Painel dos Botoes para Manutencoes
	oPanBotoes:=TPanel():New(1,3,,oPanPri,/*[aoFont]*/,,,/*CorTexto*/,/*CLR_GREEN*/,290,15,.T.,.T.) 
	oPanBotoes:ALIGN:= CONTROL_ALIGN_LEFT
	
	//Painel para Pesquisa
	oPanped	:=TPanel():New(1,3,,oPanPri,oFont2,,,/*CLR_BLUE*/,/*CLR_BLUE*/,380,15,.f.,.f.) //200,07 
	oPanped :ALIGN:= CONTROL_ALIGN_RIGHT  
	
	oButt1:= FWButtonBar():new()											
	oButt1:Init(oPanBotoes, 17, 25,CONTROL_ALIGN_TOP, .T. )   
	oButt1:addBtnImage( "Final",	  	"Sair"	,{|| Sair(oDlg1,oOrdem,aOrdem)},,.T.,CONTROL_ALIGN_LEFT)  
	 
	@ 01,01 LISTBOX oOrdem Fields HEADER "S","D","Ordem","Cod.bonif.","Descricao";
	SIZES {06,06,15,30,30,30} SIZE 490,095 FONT oFont2 PIXEL of oC1W1 ;
	ON DBLCLICK LinUpDo(oOrdem,aOrdem)
	
	oOrdem:Align := CONTROL_ALIGN_ALLCLIENT 
	oOrdem:Refresh()
	LoadOrdem (oOrdem,.F.)
	
	ACTIVATE MSDIALOG oDlg1 
	
Return 

/*/{Protheus.doc} Sair()=================================================================================================================================
Funcao para sair e salvar ordem                                         
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static Function Sair(oDlg1,oOrdem,aOrdem)
	
	Local cQuery := ''
	
		If MsgYesNo("Deseja Salvar ?")
		
			For i := 1 To Len(aOrdem)
				
				cQuery := "UPDATE " + RetSqlName("LJX") + " SET LJX_ORDEM=" + cValToChar(oOrdem:aArray[i,03]) + " " + CRLF
				cQuery += "WHERE LJX_FILIAL='" + cFilAnt + "' AND LJX_CODBON='" + cValToChar(oOrdem:aArray[i,04])+"'"  
				
				TcSqlExec(cQuery)
			
			Next i
			
			
		EndIf
		
		oDlg1:End()
	
Return

/*/{Protheus.doc} LinUpDo() =================================================================================================================================
Funcao para sair e salvar ordem                                         
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static Function LinUpDo (oOrdem,aOrdem)	
	
	If oOrdem:ColPos == 1 .AND. oOrdem:nAT > 1
		oOrdem:aArray[oOrdem:nAT,03] := oOrdem:aArray[oOrdem:nAT,03]-1 
		oOrdem:aArray[(oOrdem:nAT)-1,03] := oOrdem:aArray[(oOrdem:nAT)-1,03]+1
		oOrdem:GoUp()
	ElseIf oOrdem:ColPos == 2 .AND. oOrdem:nAT <> Len(aOrdem) 
		oOrdem:aArray[oOrdem:nAT,03] := oOrdem:aArray[oOrdem:nAT,03]+1
		oOrdem:aArray[(oOrdem:nAT)+1,03] := oOrdem:aArray[(oOrdem:nAT)+1,03]-1
		oOrdem:GoDown()
	EndIf
	
	LoadOrdem (oOrdem,.T.)
	
	oOrdem:Refresh()

Return

/*/{Protheus.doc} LoadOrdem() ============================================================================================================================
Insere dados na grid                                                    
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static Function LoadOrdem (oOrdem,lAjusta)

	Local oSt			:= LoadBitmap(GetResources(),'PMSSETAUP') 
	Local oSt2			:= LoadBitmap(GetResources(),'PMSSETADOWN')    
	Local cQuery		:= ''
	Local aOrdAju		:= {}
	
	If !lAjusta
		
		U_aOrdLJX()
		
		aOrdem		:= {}
		
		cQuery := "SELECT LJX_CODBON,LJX_DESC,LJX_ORDEM FROM " + RetSqlName("LJX") + " LJX WHERE LJX.D_E_L_E_T_='' AND LJX_PLAN='S' AND LJX_FILIAL='" + cFilAnt + "' ORDER BY LJX_ORDEM " + CRLF
		
		MemoWrite("C:\HD\QUERYS\QUAA015B.SQL",cQuery)
				
		IF Select("LoadOrdem") > 0
			LoadOrdem->(dbCloseArea())
		EndIf
			
		dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "LoadOrdem", .T., .F.)
	
		While LoadOrdem->(!Eof())
		 	Aadd(aOrdem,{	oSt,;
						 		oSt2,; 
						 		LoadOrdem->LJX_ORDEM,;
						 		LoadOrdem->LJX_CODBON,;
						 		LoadOrdem->LJX_DESC," "})										 
			LoadOrdem->( dbSkip() )
		EndDo 
	Else
			aOrdAju := aOrdem
		 	aSort(aOrdAju,,,{ |x,y | x[3] < y[3] })
		 	aOrdem := {}
		 	
		 	For i := 1 to Len(aOrdAju)
			 	Aadd(aOrdem,{	oSt,;
			 					oSt2,; 
			 					aOrdAju[i][3],;
			 					aOrdAju[i][4],;
			 					aOrdAju[i][5]," "})										 
		 	Next i
	End If

	If Empty(aOrdem)                                
		aOrdem :={{oSt,oSt2,Space(6),Space(6),Space(6),Space(6)," "}}
	EndIf
	
	oOrdem:SetArray(aOrdem)
	oOrdem:bLine := {|| {	aOrdem[oOrdem:nAt,01],aOrdem[oOrdem:nAt,02],aOrdem[oOrdem:nAt,03],aOrdem[oOrdem:nAt,04],aOrdem[oOrdem:nAt,05],aOrdem[oOrdem:nAt,06]}}						
	oOrdem:Refresh()

Return
/*/{Protheus.doc} aOrdLJX() =============================================================================================================================
Ajusta ordem no arquivo LJX_ORDEM caso se perca a sequencia         
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
User Function aOrdLJX()

	Local cAliasLJX := 'LJXQRY'
	Local nOrdem	:= 1
		
	BeginSql Alias cAliasLJX
		%noparser%
		SELECT LJX_CODBON,LJX_DESC,LJX_ORDEM,R_E_C_N_O_ AS REC  
		FROM %table:LJX% LJX 
		WHERE LJX.D_E_L_E_T_='' AND LJX_PLAN='S' AND LJX_FILIAL=%EXP:cFilAnt% 
		ORDER BY LJX_ORDEM
	EndSql

	While (cAliasLJX)->( !Eof())
		TcSqlExec("UPDATE " + RetSqlName("LJX") + " SET LJX_ORDEM=" + cValToChar(nOrdem) + " WHERE  R_E_C_N_O_=" + cValToChar((cAliasLJX)->(REC)))  
		nOrdem ++
		(cAliasLJX)->( dbSkip() )
	EndDo
	
	(cAliasLJX)->( dbCloseArea())

Return 
