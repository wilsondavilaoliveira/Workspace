#Include 'Protheus.ch'
#Include 'TMKA260.CH' 
#Include 'FWMVCDEF.CH'  
#INCLUDE "CRMDEF.CH"             

Static aAOVMark := {}

//-----------------------------------------------------------------------------------
// 	ATENCAO:                                                                          
// O cadastro de PROSPECT é compartilhado pelos modulos CALL CENTER e FIELD SERVICE     
// qualquer alteracao dever ser feita considerando esse compartilhamento            
//-----------------------------------------------------------------------------------

//------------------------------------------------------------------------------
/*/{Protheus.doc} TmkA260

Cadastro de Prospescts

@sample 	TMKA260( xRotAuto, nOpc, oDlgOwner )

@param		xRotAuto -  Vetor com campos da enchoice utilizado em ExecAuto 
@param		nOpc	 -  Opcao da execauto selecionada:3-inclui,4-altera,etc
@param 		oDlgOwner -  Dialog
		

@return   	Nil

@author		Vendas CRM
@since		06/01/12
@version	12
/*/
//------------------------------------------------------------------------------
Function TMKA260( xRotAuto, nOpc, oDlgOwner, cFilDef, aAddFil, cVDefault )
					
Local aAutoRot		:= {}
Local lTk260Mem		:= FindFunction( "U_TK260MEM" ) //Ponto de entrada para incluir campos memos de usuario
Local aMemUser		:= {} 

Private aRotina 	:= MenuDef()					
Private cCadastro 	:= STR0006 						//"Atualizacao de Prospect" 					
Private aMemos 		:= {}
Private lTk260Auto 	:= ( xRotAuto <> NIL ) 			//Rotina de inclusão automatica

Default oDlgOwner := Nil  
Default cFilDef   := ""
Default aAddFil   := {}
Default xRotAuto  := Nil
Default nOpc      := 1 //Visualizar
Default cVDefault := ""

// Criado o model como estatico para evitar de carregar o model quando a rotina automatica é chamada mais de uma vez. Evitando assim estouro de memoria.
Static oModel		 := Nil	                        

If lTk260Auto
	If oModel == Nil
		oModel := 	ModelDef()	
	EndIf
	aAutoRot := {{ "SUSMASTER", xRotAuto}}
	FWMVCRotAuto(@oModel, "SUS", nOpc, aAutoRot )
	oModel:DeActivate()
Else
    //-------------------------------------------
	//Browse de Prospect. 
	//-------------------------------------------
	BrowseDef( /*oMBrowse*/, cFilDef, aAddFil, cVDefault, oDlgOwner )
EndIf	 

Return ( .T. )

//------------------------------------------------------------------------------
/*/{Protheus.doc} BrowseDef

Browse de Cadastro de Prospect

@sample	BrowseDef( oMBrowse, cFilDef, aAddFil, cVDefault )

@param		oMBrowse	, Objeto	, Browse criado pelo Widget da Area de Trabalho.
			cFilDef	, Caracter	, Filtro padrao.
			aAddFil	, Array		, Filtros relacionados.
			cVDefault	, Caracter , Visao padrao.
			oDlgOwner  , Objeto	, Janela que o browse será utilizado.
			
@return	oMBrowse	, Objeto	, Retorna o objeto FWMBrowse.

@author	Anderson Silva
@since		05/12/2015
@version	P12
/*/
//------------------------------------------------------------------------------
Static Function BrowseDef( oMBrowse, cFilDef, aAddFil, cVDefault, oDlgOwner )

Local oTableAtt		:= Nil
Local nX			:= 0
Local nScan      	:= 0
Local cFiltraSUS	:= ""							//Filtro de retorno do ponto de entrada:= ""
Local lWidget		:= .F.
Local lTk260Fil		:= FindFunction( "U_TK260FIL" ) //Ponto de entrada para filtrar o Browse SUS
Local aCores 		:= {	{ "SUS->US_STATUS == '1'", "BR_MARROM"		, STR0016 	},; // Classificado
		   					{ "SUS->US_STATUS == '2'", "BR_VERMELHO" 	, STR0017 	},; // Desenvolvimento
		   					{ "SUS->US_STATUS == '3'", "BR_AZUL"	  	, STR0018	},; // Gerente
							{ "SUS->US_STATUS == '4'", "BR_AMARELO"  	, STR0019 	},; // Standy by
							{ "SUS->US_STATUS == '5'", "BR_PRETO"	  	, STR0020	},; // Cancelado
							{ "SUS->US_STATUS == '6'", "BR_VERDE"	  	, STR0021  },; // Cliente 
							{ "Empty(SUS->US_STATUS)", "BR_BRANCO"	   	, STR0022  } } // Maling (sem status)			

Default oMBrowse	:= Nil
Default cFilDef		:= ""
Default aAddFil		:= {}
Default cVDefault	:= ""
Default oDlgOwner	:= Nil 

If Empty( oMBrowse )
	//----------------
	// Cria o Browse 
	//----------------
	oMBrowse := FWMBrowse():New()
	oMBrowse:SetAlias( "SUS" )
	If oDlgOwner <> Nil
		oMBrowse:SetOwner(oDlgOwner)		
	EndIf
Else
	lWidget := .T.
EndIf

oMBrowse:SetCanSaveArea(.T.) 

For nX := 1 To Len( aCores )
	oMBrowse:AddLegend( aCores[nX][1], aCores[nX][2], aCores[nX][3] )
Next nX

//---------------------------------
//³ Filtro Default do Browse.
//---------------------------------
If !Empty( cFilDef )
	oMBrowse:SetFilterDefault( cFilDef )
EndIf

//---------------------------------
//³ Filtros adicionais do Browse.   
//---------------------------------
For nX := 1 To Len( aAddFil )
	oMBrowse:DeleteFilter( aAddFil[nX][ADDFIL_ID] )
	oMBrowse:AddFilter( aAddFil[nX][ADDFIL_TITULO], ;
					      aAddFil[nX][ADDFIL_EXPR], ;
					      aAddFil[nX][ADDFIL_NOCHECK], ;
					      aAddFil[nX][ADDFIL_SELECTED], ;
					      aAddFil[nX][ADDFIL_ALIAS], ;
					      aAddFil[nX][ADDFIL_FILASK], ;
					      aAddFil[nX][ADDFIL_FILPARSER], ;
					      aAddFil[nX][ADDFIL_ID] )
	oMBrowse:ExecuteFilter()	
Next nX

//-------------------------------------
// Ponto de entrada para filtrar o SUS
//-------------------------------------	
If lTk260Fil
	cFiltraSUS := AllTrim( ExecBlock( "TK260FIL", .F., .F. ) )
	If Valtype( cFiltraSUS ) == "C" .AND. !Empty( cFiltraSUS )
		oMBrowse:AddFilter( STR0039, cFiltraSUS, .T., .T. ) //"Filtro de Usuário"
		oMBrowse:ExecuteFilter()
	EndIf
EndIf	

oMBrowse:SetDescription( STR0006 ) // Atualizacao de Prospect.
		                           
If !lWidget

	oMBrowse:SetAttach(.T.)	
	oTableAtt := TableAttDef()
	oMBrowse:SetViewsDefault( oTableAtt:aViews )
	oMBrowse:SetChartsDefault( oTableAtt:aCharts )
	
	// selecionando a visão inicial 
	If !Empty( cVDefault ) 
		nScan := aScan( oTableAtt:aViews, { |x| x:cID == cVDefault } )
		If nScan > 0 
			oMBrowse:SetIDViewDefault( oTableAtt:aViews[nScan]:cID )
		EndIf
	EndIf
		
	oMBrowse:SetIDChartDefault( "DSPorVend" ) 
		
	//Se não for SIGACRM inibe a exibição do gráfico
	If nModulo <> 73
		oMBrowse:SetOpenChart( .F. )
	EndIf
	
	oMBrowse:SetMainProc("TMKA260")
	oMBrowse:SetTotalDefault('US_FILIAL','COUNT',STR0055) //'Total de Registros'
	oMBrowse:Activate()

EndIf		

Return Nil

//------------------------------------------------------------------------------
/*/{Protheus.doc} TableAttDef

Cria as visões e gráficos padrão.

@sample		TableAttDef()

@param		Nenhum

@return		ExpA - Array de Objetos com as Visoes e Gráficos.

@author		Aline Kokumai
@since		02/05/2014
@version	12
/*/
//------------------------------------------------------------------------------
Static Function TableAttDef()

Local oTableAtt		:= Nil
Local oDSMyAbert 	:= Nil //  Meus Prospects Abertos
Local oDSProComp 	:= Nil //  Prospects Compartilhados
Local oDSAbertos 	:= Nil	//  Prospects Abertos
Local oDSQualifi 	:= Nil	//  Prospects Qualificados
Local oDSDesqual 	:= Nil	//  Prospects Desqualificados
Local oDSPorOrig 	:= Nil //  Pizza: Prospects por Origem
Local oDSPorCamp 	:= Nil	//  Colunas: Prospects por Campanha de Origem
Local oDSTxGerDt 	:= Nil	//  Linha: Taxa de Geração de Prospects por Data
Local oDSPorStat 	:= Nil	//  Colunas: Prospects por Status
Local oDSPorVend 	:= Nil	//  Colunas: Prospects por Vendedor


Local lTMKV260View		:= ExistBlock("CRMBRWVIEW")	//Ponto entrada para manipulação das views padrão
Local cRotina			:= "TMKA260"
Local cAliasView		:= "SUS"

If lTMKV260View 

	oTableAtt := ExecBlock("CRMBRWVIEW", .F.,.F.,{cRotina,cAliasView})

EndIf


If Empty ( oTableAtt )

	oTableAtt := FWTableAtt():New()
	oTableAtt:SetAlias("SUS")

	If ( IsInCallStack("CRMA070") .Or. IsInCallStack("CRMA290") .Or. IsInCallStack("CRMA290A") .Or. IsInCallStack( "CRM290CWGT" ) )
	
		//  Meus Prospects Abertos
		oDSMyAbert := FWDSView():New()
		oDSMyAbert:SetName(STR0056) //"Meus Prospects Abertos"
		oDSMyAbert:SetID( "DSMyAbert" ) 
		oDSMyAbert:SetOrder(1) // US_FILIAL+US_COD+US_LOJA
		oDSMyAbert:SetCollumns({	"US_COD"		,"US_LOJA"		,"US_NOME"		,"US_NREDUZ"	,"US_END",;
									"US_MUN"		,"US_BAIRRO"	,"US_EST"		,"US_DDD"		,"US_TEL"		,;
									"US_EMAIL"		,"US_CGC"		,"US_STATUS"	,"US_ENTORI"	,"US_CODCLI"	,;
									"US_LOJACLI"	,"US_DTCONV" })
		oDSMyAbert:SetPublic( .T. )
		oDSMyAbert:AddFilterRelation( 'AO4', 'AO4_CHVREG', "US_FILIAL+US_COD+US_LOJA" )
		oDSMyAbert:AddFilter(STR0056, "AO4_ENTIDA = 'SUS' .AND. AO4_CODUSR == '"+RetCodUsr()+"' .AND. AO4_CTRLTT == .T.","AO4") //"Meus Prospects Abertos"
		oDSMyAbert:AddFilter(STR0056, "!(US_STATUS $ '5,6')") //"Meus Prospects Abertos"
		oTableAtt:AddView(oDSMyAbert)
		
		// Prospects Compartilhados
		oDSProComp := FWDSView():New()
		oDSProComp:SetName(STR0067) //"Prospects Compartilhados"
		oDSProComp:SetID( "DSProComp" ) 
		oDSProComp:SetOrder(1) // US_FILIAL+US_COD+US_LOJA
		oDSProComp:SetCollumns({	"US_COD"		,"US_LOJA"		,"US_NOME"		,"US_NREDUZ"	,"US_END"		,;
									"US_MUN"		,"US_BAIRRO"	,"US_EST"		,"US_DDD"		,"US_TEL"		,;
									"US_EMAIL"		,"US_CGC"		,"US_STATUS"	,"US_ENTORI"	,"US_CODCLI"	,;
									"US_LOJACLI"	,"US_DTCONV" })
		oDSProComp:SetPublic( .T. )
		oDSProComp:AddFilterRelation( 'AO4', 'AO4_CHVREG', "US_FILIAL+US_COD+US_LOJA" )
		oDSProComp:AddFilter(STR0067, "AO4_ENTIDA = 'SUS' .AND. AO4_CODUSR == '"+RetCodUsr()+"' .AND. AO4_CTRLTT == .F. .AND. (AO4_PERVIS == .T. .OR. AO4_PEREDT == .T. .OR. AO4_PEREXC == .T. .OR. AO4_PERCOM == .T.)","AO4") //"Prospects Compartilhados"
		oTableAtt:AddView(oDSProComp)
	
	EndIf
	
	
	//  Prospects Abertos
	oDSAbertos := FWDSView():New()
	oDSAbertos:SetName(STR0057) //"Prospects Abertos"
	oDSAbertos:SetID( "DSAbertos" ) 
	oDSAbertos:SetOrder(1) // US_FILIAL+US_COD+US_LOJA
	oDSAbertos:SetCollumns({	"US_COD"		,"US_LOJA"		,"US_NOME"		,"US_NREDUZ"	,"US_END"		,;
								"US_MUN"		,"US_BAIRRO"	,"US_EST"		,"US_DDD"		,"US_TEL"		,;
								"US_EMAIL"		,"US_CGC"		,"US_STATUS"	,"US_ENTORI"	,"US_CODCLI"	,;
								"US_LOJACLI"	,"US_DTCONV" })
	oDSAbertos:SetPublic( .T. )
	oDSAbertos:AddFilter(STR0057, "!(US_STATUS $ '5,6')") //"Prospects Abertos"
	oTableAtt:AddView(oDSAbertos)
	
	//  Prospects Qualificados
	oDSQualifi := FWDSView():New()
	oDSQualifi:SetName(STR0058) //"Prospects Qualificados"
	oDSQualifi:SetID( "DSQualifi" ) 
	oDSQualifi:SetOrder(1) // US_FILIAL+US_COD+US_LOJA
	oDSQualifi:SetCollumns({	"US_COD"		,"US_LOJA"		,"US_NOME"		,"US_NREDUZ"	,"US_END"		,;
								"US_MUN"		,"US_BAIRRO"	,"US_EST"		,"US_DDD"		,"US_TEL"		,;
								"US_EMAIL"		,"US_CGC"		,"US_STATUS"	,"US_ENTORI"	,"US_CODCLI"	,;
								"US_LOJACLI"	,"US_DTCONV" })							
	oDSQualifi:SetPublic( .T. )
	oDSQualifi:AddFilter(STR0058, "US_STATUS == '6'") //"Prospects Qualificados"
	oTableAtt:AddView(oDSQualifi)
	
	//  Prospects Desqualificados
	oDSDesqual := FWDSView():New()
	oDSDesqual:SetName(STR0059) //"Prospects Desqualificados"
	oDSDesqual:SetID( "DSDesqual" ) 
	oDSDesqual:SetOrder(1) // US_FILIAL+US_COD+US_LOJA
	oDSDesqual:SetCollumns({	"US_COD"		,"US_LOJA"		,"US_NOME"		,"US_NREDUZ"	,"US_END"		,;
								"US_MUN"		,"US_BAIRRO"	,"US_EST"		,"US_DDD"		,"US_TEL"		,;
								"US_EMAIL"		,"US_CGC"		,"US_STATUS"	,"US_ENTORI"	,"US_CODCLI"	,;
								"US_LOJACLI"	,"US_DTCONV" })
	oDSDesqual:SetPublic( .T. )
	oDSDesqual:AddFilter(STR0059, "US_STATUS == '5'") //"Prospects Desqualificados"
	oTableAtt:AddView(oDSDesqual)

EndIf

//  Pizza: Prospects por Origem
oDSPorOrig := FWDSChart():New()	
oDSPorOrig:SetName(STR0060) //"Prospects por Origem"
oDSPorOrig:SetID( "DSPorOrig" ) 
oDSPorOrig:SetTitle(STR0060) //"Prospects por Origem"
oDSPorOrig:SetType("PIECHART")
oDSPorOrig:SetSeries({ {"SUS", "US_COD+US_LOJA", "COUNT"} })
oDSPorOrig:SetCategory( { {"SUS", "US_ORIGEM"} } )
oDSPorOrig:SetPublic( .T. )
oDSPorOrig:SetLegend( CONTROL_ALIGN_BOTTOM ) //Inferior
oDSPorOrig:SetTitleAlign( CONTROL_ALIGN_CENTER ) 
oTableAtt:AddChart(oDSPorOrig)

//  Colunas: Prospects por Campanha de Origem
oDSPorCamp := FWDSChart():New()	
oDSPorCamp:SetName(STR0061) //"Prospects por Campanha de Origem"
oDSPorCamp:SetID( "DSPorCamp" ) 
oDSPorCamp:SetTitle(STR0061) //"Prospects por Campanha de Origem"
oDSPorCamp:SetType("BARCOMPCHART")
oDSPorCamp:SetSeries({ {"SUS", "US_COD+US_LOJA", "COUNT"} })
oDSPorCamp:SetCategory( { {"SUO", "UO_DESC"} } )
oDSPorCamp:SetPublic( .T. )
oDSPorCamp:SetLegend( CONTROL_ALIGN_BOTTOM ) //Inferior
oDSPorCamp:SetTitleAlign( CONTROL_ALIGN_CENTER ) 
oTableAtt:AddChart(oDSPorCamp)

//  Linha: Taxa de Geração de Prospects por Data
oDSTxGerDt := FWDSChart():New()	
oDSTxGerDt:SetName(STR0062) //"Taxa de Geração de Prospects por Data"
oDSTxGerDt:SetID( "DSTxGerDt" ) 
oDSTxGerDt:SetTitle(STR0062) //"Taxa de Geração de Prospects por Data"
oDSTxGerDt:SetType("LINECHART")
oDSTxGerDt:SetSeries({ {"SUS", "US_COD+US_LOJA", "COUNT"} })
oDSTxGerDt:SetCategory( { {"SUS", "US_DTCAD"} } )
oDSTxGerDt:SetPublic( .T. )
oDSTxGerDt:SetLegend( CONTROL_ALIGN_BOTTOM ) //Inferior
oDSTxGerDt:SetTitleAlign( CONTROL_ALIGN_CENTER ) 
oTableAtt:AddChart(oDSTxGerDt)

//  Colunas: Prospects por Status
oDSPorStat := FWDSChart():New()	
oDSPorStat:SetName(STR0063) //"Prospects por Status"
oDSPorStat:SetID( "DSPorStat" ) 
oDSPorStat:SetTitle(STR0063) //"Prospects por Status"
oDSPorStat:SetType("BARCOMPCHART")
oDSPorStat:SetSeries({ {"SUS", "US_COD+US_LOJA", "COUNT"} })
oDSPorStat:SetCategory( { {"SUS", "US_STATUS"} } )
oDSPorStat:SetPublic( .T. )
oDSPorStat:SetLegend( CONTROL_ALIGN_BOTTOM ) //Inferior
oDSPorStat:SetTitleAlign( CONTROL_ALIGN_CENTER ) 
oTableAtt:AddChart(oDSPorStat)

//  Colunas: Prospects por Vendedor
oDSPorVend := FWDSChart():New()	
oDSPorVend:SetName(STR0064) //"Prospects por Vendedor"
oDSPorVend:SetID( "DSPorVend" ) 
oDSPorVend:SetTitle(STR0064) //"Prospects por Vendedor"
oDSPorVend:SetType("BARCOMPCHART")
oDSPorVend:SetSeries({ {"SUS", "US_COD+US_LOJA", "COUNT"} })
oDSPorVend:SetCategory( { {"SA3", "A3_NOME"} } )
oDSPorVend:SetPublic( .T. )
oDSPorVend:SetLegend( CONTROL_ALIGN_BOTTOM ) //Inferior
oDSPorVend:SetTitleAlign( CONTROL_ALIGN_CENTER ) 
oTableAtt:AddChart(oDSPorVend)

Return(oTableAtt)
	
		
//------------------------------------------------------------------------------
/*/{Protheus.doc} MenuDef()

MenuDef - Operações que serão utilizadas pela aplicação

@return   	aRotina - Array das operações

@author		Vendas CRM
@since		06/01/2012
@version	12
/*/
//------------------------------------------------------------------------------
Static Function MenuDef()

Local aRotina		:= {}	          			// Opcoes do programa                                                                                   
Local aRotAdic	:= {}						// Retorno do P.E. TK260ROT para entrada automatica

Local nPos        := 0
Local aEntRelac   := {}
Local aAtiv       := {}
Local aAnotac     := {}
Local aApont      := {}
Local aOpor       := {}
Local aCamp       := {}

Local lTk260Rot	:= ExistBlock( "TK260ROT" )	// P.E. para add rotinas no aRotina

ADD OPTION aRotina TITLE STR0001 ACTION "PesqBrw" 	OPERATION  1	 ACCESS 0 		  //"Pesquisar"
ADD OPTION aRotina TITLE STR0002 ACTION "VIEWDEF.TMKA260"	OPERATION  2	 ACCESS 0 //"Visualizar"
ADD OPTION aRotina TITLE STR0003 ACTION "VIEWDEF.TMKA260"	OPERATION  3	 ACCESS 0 //"Incluir"
ADD OPTION aRotina TITLE STR0004 ACTION "VIEWDEF.TMKA260"	OPERATION  4	 ACCESS 0 //"Alterar"
ADD OPTION aRotina TITLE STR0005 ACTION "VIEWDEF.TMKA260"	OPERATION  5	 ACCESS 0 //"Excluir"  

ADD OPTION aRotina TITLE STR0072 ACTION "TK260DesRea('D')"		OPERATION  6	 ACCESS 0 //"Desqualificação"
ADD OPTION aRotina TITLE STR0073 ACTION "TK260DesRea('R')"		OPERATION  6	 ACCESS 0 //"Reativação" 

If !nModulo == 73
	ADD OPTION aRotina TITLE STR0007 ACTION "Tka260Vis()"		OPERATION  6   ACCESS 0 //"Ag.Visita"
EndIf

ADD OPTION aRotina    TITLE STR0015  ACTION "Tk260Legenda" OPERATION  1 ACCESS 0 //"Legenda"
ADD OPTION aEntRelac  TITLE STR0008  ACTION "FtContato('SUS',SUS->(Recno()), 4)" OPERATION  4 ACCESS 0 //"Contato"
ADD OPTION aEntRelac  TITLE STR0009  ACTION "MsDocument('SUS',SUS->(Recno()),4)" OPERATION  9 ACCESS 0 //"Conhecimento"
ADD OPTION aEntRelac  TITLE STR0038  ACTION "Tka260Per()"	   OPERATION  4 ACCESS 0 //"Perfil"

ADD OPTION aEntRelac  TITLE STR0025  ACTION "TkLstScr(4,'SUS', SUS->US_COD, SUS->US_LOJA)" OPERATION  1 ACCESS 0 //Scripts De Campanha

ADD OPTION aEntRelac  TITLE STR0032  ACTION "Tk710VerImg( SUS->US_IMGUMOV )"  OPERATION  8 ACCESS 0 //Foto uMov.me

If nModulo == 73
	aEntRelac := CRMXINCROT( "SUS", aEntRelac )

	ADD OPTION aCamp TITLE STR0068   ACTION "CRMA360(,'SUS')"	 OPERATION  8 ACCESS 0  //"Campanhas"
	ADD OPTION aCamp TITLE STR0069   ACTION "CRMA250('SUS')"	 OPERATION  8 ACCESS 0  //"Campanhas Rápidas"	
	ADD OPTION aEntRelac TITLE STR0068   ACTION aCamp	 OPERATION  8 ACCESS 0  //"Campanhas"

	ADD OPTION aEntRelac TITLE STR0041   ACTION "CRMA200('SUS')"	 OPERATION  8 ACCESS 0  //"Privilégios"
	
	ADD OPTION aOpor     TITLE STR0065   ACTION "CRMXNewOpo('SUS',SUS->US_COD,SUS->US_LOJA)"	 OPERATION  8 ACCESS 0  //"Nova Oportunidade"
	ADD OPTION aOpor     TITLE STR0066   ACTION "CRMA110()"	 OPERATION  8 ACCESS 0  //"Todas as Oportunidades"
	ADD OPTION aEntRelac TITLE STR0048   ACTION aOpor	 OPERATION  8 ACCESS 0  //"Oportunidades"
		
	ADD OPTION aApont    TITLE  STR0053   	ACTION "CRMXNewApo('SUS',SUS->US_COD,SUS->US_LOJA)" OPERATION  8 ACCESS 0  //"Novo Apontamento"
	ADD OPTION aApont    TITLE  STR0054	ACTION "CRMA330()"	 OPERATION  8 ACCESS 0  //"Todos os Apontamentos"
	ADD OPTION aEntRelac TITLE  STR0047   ACTION aApont	 OPERATION  8 ACCESS 0         //"Apontamentos"
	
	//Subsegmentos
	ADD OPTION aEntRelac TITLE STR0106 ACTION "CRMA620(NIL, 'SUS', SUS->US_COD,SUS->US_LOJA, SUS->US_CODSEG, 4)" OPERATION  4 ACCESS 0 
 	 
	nPos := ASCAN(aEntRelac, { |x| IIF(ValType(x[2]) == "C", x[2] == "CRMA190Con()",Nil) })
	If nPos > 0 
		ADD OPTION aRotina TITLE aEntRelac[nPos][1] ACTION aEntRelac[nPos][2] OPERATION 8  ACCESS 0//"Conectar"
		Adel(aEntRelac,nPos)
		Asize(aEntRelac,Len(aEntRelac)-1)
	EndIf
	
	nPos := ASCAN(aEntRelac, { |x|  IIF(ValType(x[2]) == "C", x[2] == "CRMA180()", Nil) })
	If nPos > 0
		ADD OPTION aAtiv   TITLE STR0046 ACTION "CRMA180(,,,3,,)" OPERATION 3  ACCESS 0 //"Nova Atividade" 
		ADD OPTION aAtiv   TITLE STR0050 ACTION "CRMA180()" OPERATION 8  ACCESS 0 //"Todas as ATividades"
		aEntRelac[nPos][2] := aAtiv
	EndIf

	nPos := ASCAN(aEntRelac, { |x| IIF(ValType(x[2]) == "C", x[2] == "CRMA090()", Nil)})
	If nPos > 0
		ADD OPTION aAnotac   TITLE STR0051 ACTION "CRMA090(3)" OPERATION 3  ACCESS 0 //"Nova Anotação"
		ADD OPTION aAnotac   TITLE STR0052 ACTION "CRMA090()" OPERATION 8  ACCESS 0 //"Todas as Anotações" 
		aEntRelac[nPos][2] := aAnotac
	EndIf
EndIf

Asort(aEntRelac,,,{ | x,y | y[1] > x[1] } )
ADD OPTION aRotina TITLE  STR0045 ACTION aEntRelac 	    OPERATION 8  ACCESS 0//"Relacionadas"

//Somente para clientes que utilizam a integração com a Gestão de Concessionária - Solicitado pela MIL
If SuperGetMV("MV_VEICULO",,"N") == "S"
	ADD OPTION aRotina TITLE STR0112  ACTION "FGX_SUSSA1" OPERATION 4 ACCESS 0 //"Converte em Cliente"
EndIf

//------------------------------------------------
// Ponto de entrada - Adiciona rotinas ao aRotina
//------------------------------------------------
If lTk260Rot
	aRotAdic := ExecBlock( "TK260ROT", .F., .F. )
	If ValType( aRotAdic ) == "A"
		AEval( aRotAdic, { |x| AAdd( aRotina, x ) } )
	Endif
Endif
       
Return( aRotina )
    
//------------------------------------------------------------------------------
/*/{Protheus.doc} ModelDef

Modelo de Dados - Regra de Negócio	

@return   	oModel - Objeto do Modelo

@author		Vendas CRM
@since		06/01/2012
@version	12
/*/
//------------------------------------------------------------------------------
Static Function ModelDef()

Local oModel
Local bPosValidacao	:= { |oMdl| Tk260Pos( oMdl ) }		// Efetua a pos validacao
Local bCommit 		:= { |oMdl| Tk260Cmm( oMdl ) }		// Efetua a  validacao
Local bCancel 		:= { |oMdl| Tk260Can() }		    // Efetua o cancelamento

Local oStruSUS		:= FWFormStruct( 1, 'SUS',/*bAvalCampo*/,/*lViewUsado*/ )

//SIGACRM - Atribuir o vendedor ao registro durante a inclusão
If nModulo == 73
	oStruSUS:SetProperty( "US_VEND", MODEL_FIELD_INIT, FwBuildFeature( STRUCT_FEATURE_INIPAD, "CRMXRetVend()" ) ) 
EndIf

oModel := MPFormModel():New( 'TMKA260',/*bPreValidacao*/, bPosValidacao, bCommit,bCancel )
oModel :AddFields( 'SUSMASTER',/*cOwner*/, oStruSUS,/*bPreValidacao*/,/*bPosValidacao*/,/*bCarga*/)
oModel :SetVldActivate( { |oMdl|Tk260Pre( oMdl ) } )
 
Return( oModel )

//------------------------------------------------------------------------------
/*/{Protheus.doc} ViewDef

Interface

@return   	oView - Objeto da interface

@author		Vendas CRM
@since		06/01/2012
@version	12
/*/
//------------------------------------------------------------------------------
Static Function ViewDef()

Local oView
Local oModel   	:= FWLoadModel( 'TMKA260' )
Local oStruSUS	:= FWFormStruct( 2, 'SUS' )
Local nOpc 		:= oModel:GetOperation()  
Local aRetPE	:= {}							// Array contendo os botoes criados no P.E.
Local lTK260BUT	:= FindFunction( "U_TK260BUT" )	// Ponto de entrada para criacao de botoes
Local lCRMTerr := SuperGetMV("MV_CRMTERR",.F.,.F.)
Local nX		   := 0

oStruSUS:RemoveField( "US_IDESTN" )	
oStruSUS:RemoveField( "US_NVESTN" )

oStruSUS:RemoveField( 'US_SATIV'  )
oStruSUS:RemoveField( 'US_SATIV2' )
oStruSUS:RemoveField( 'US_SATIV3' )
oStruSUS:RemoveField( 'US_SATIV4' )
oStruSUS:RemoveField( 'US_SATIV5' )
oStruSUS:RemoveField( 'US_SATIV6' )
oStruSUS:RemoveField( 'US_SATIV7' )
oStruSUS:RemoveField( 'US_SATIV8' )
oStruSUS:RemoveField( 'US_DSATIV' )
oStruSUS:RemoveField( 'US_DSATIV2' )
oStruSUS:RemoveField( 'US_DSATIV3' )
oStruSUS:RemoveField( 'US_DSATIV4' )
oStruSUS:RemoveField( 'US_DSATIV5' )
oStruSUS:RemoveField( 'US_DSATIV6' )
oStruSUS:RemoveField( 'US_DSATIV7' )
oStruSUS:RemoveField( 'US_DSATIV8' )


oView := FWFormView():New()
oView:SetContinuousForm() // Seta formulario continuo 
oView :SetModel( oModel )
oView :AddField( 'VIEW_SUS', oStruSUS, 'SUSMASTER' )

//--------------------
// Criação dos Botões
//-------------------
//Geoprocessamento
oView:AddUserButton( STR0023, "GEOROTA",{|| fGeoWizard("SUS",M->US_COD+M->US_LOJA,{"M->US_END","M->US_MUN","M->US_EST","M->US_CEP","M->US_BAIRRO"},;
{|lContinua| CodGeoRev(aCoor,NIL,@lContinua)[6] <> M->US_CEP })},"Geoprocessamento",,,{MODEL_OPERATION_INSERT,MODEL_OPERATION_UPDATE} )	

//Desqualificação da Conta
oView:AddUserButton(STR0074 , "", { |oView| TK260DesRea('D',oModel,.F.) },,,{ MODEL_OPERATION_UPDATE } ) //"Desqualificação"
//Reativação da Conta
oView:AddUserButton(STR0075 , "", { |oView| TK260DesRea('R',oModel,.F.) },,,{ MODEL_OPERATION_UPDATE } ) //"Reativação"

//Scripts de Segmentos
oView:AddUserButton( STR0106,"",{ |oView| SaveInter(), CRMA620(@aAOVMark,"SUS", FwFldGet("US_COD"), FwFldGet("US_LOJA"), FwFldGet("US_CODSEG"), oModel:GetOperation()),RestInter() },,,{ MODEL_OPERATION_VIEW, MODEL_OPERATION_INSERT, MODEL_OPERATION_UPDATE } ) 

If nModulo == 73 .And. lCRMTerr
	oView:AddUserButton(STR0107,"",{|| CRMA690EvalTerritory("TMKA260","SUS",.T.,.T.) },STR0107,,,{MODEL_OPERATION_INSERT,MODEL_OPERATION_UPDATE} )
EndIf

//-----------------------------------------
// Ponto de entrada para criacao de botoes
//-----------------------------------------
If lTK260BUT 
	aRetPe	:= U_Tk260But()
	If ValType( aRetPE ) == "A"
		For nX := 1 To Len( aRetPE )
			oView:AddUserButton( aRetPE[nX][4], aRetPE[nX][1], aRetPE[nX][2] )
		Next nX
	EndIf
EndIf

oView := CRMXAddAct("SUS",oView) //Adcionar Rotinas no 'Ações relacionadas' do Formulário

Asort(oView:aUserButtons,,,{ | x,y | y[1] > x[1] } )   

oView :CreateHorizontalBox( 'TELA', 100 )
oView :SetOwnerView( 'VIEW_SUS', 'TELA' )

Return( oView )

//------------------------------------------------------------------------------
/*/{Protheus.doc} Tk260Pre

Validacao realizada na ativação do Modelo, permitindo ou não sua ativação    

@sample 	Tk260Pre( oModel )

@param		oModel -  Modelo de dados do sistema

@return   	lRet   -  Retorna verdadeiro ou falso

@author		Vendas CRM
@since		01/02/2012
@version	12
/*/
//------------------------------------------------------------------------------
Function Tk260Pre( oModel )

Local nOpc		:= oModel:GetOperation()
Local lRet 		:= .T.
Local lTMK260A	:= FindFunction( "U_TMK260A" ) 	// P.E. antes da alteracao do cadastro

If nOpc == MODEL_OPERATION_UPDATE
	If lTMK260A
		lRet := U_TMK260A( oModel )
		// Se o retorno for .F. nao prossegue com o cancelamento
		If (ValType(lRet) <> "L")
			lRet := .F.
		Endif 
	Endif
EndIf

If !(IsInCallStack("TK260GRVDESREAT"))		
	If nOpc == MODEL_OPERATION_UPDATE .Or. nOpc == MODEL_OPERATION_DELETE
		If  SUS->US_STATUS == "5" 
		    Help( ,, 'HELP',, STR0102, 1, 0 ) //'O registro selecionado foi desqualificado. Reative o registro através da opção: Outras Ações / Reativar.'	

			lRet := .F.
		EndIf
	EndIf
EndIf


Return( lRet )                      
  
//------------------------------------------------------------------------------
/*/{Protheus.doc} Tk260Pos

Faz a Pos Validação validacao (TudoOk).

@sample 	Tk260Pos( oModel )

@param		oModel -  Modelo de dados do sistema

@return   	lRet   -  Retorna verdadeiro ou falso

@author		Thamara Villa Jacomo
@since		13/02/2014
@version	12
/*/
//------------------------------------------------------------------------------  
Static Function Tk260Pos( oModel ) 

Local aArea		:= GetArea()					
Local aAreaSA3    := SA3->( GetArea() )			
Local aSM0CodFil  := {}							 // Array com as filiais do SM0
Local nOpc		 	:= oModel:GetOperation()   
Local nReg		 	:= SUS->( Recno() )
Local lRet		 	:= .T.  
Local lTMK260D	:= FindFunction( "U_TMK260D" )  // P.E. depois da alteracao do cadastro
Local lTmk260OK	:= ExistBlock( "TMK260OK" )	 // P.E. no momento de clicar no botao OK				
Local nCont 	 	:= 0							// Contador para seek nas filiais do SIGAMAT.EMP
Local nRecnoSM0  	:= SM0->( RecNo() )			// Posicao do SM0
Local cAliasCJ   	:= GetNextAlias()
    

If nOpc == MODEL_OPERATION_INSERT .Or. nOpc == MODEL_OPERATION_UPDATE



	If ( oModel:GetValue( "SUSMASTER", "US_STATUS" ) == "5" ) .And. Empty(oModel:GetValue("SUSMASTER","US_CODDESQ"))

		Help( ,,'HELP',,STR0110, 1, 0 ) //"O campo Ent. Origem tem que ser preenchido"
		lRet := .F.
	EndIf
EndIf

    
//----------------------------------------------------------------------
// Valida o campo US_ENTORI como obrigatorio se a origem for um Mailing
//----------------------------------------------------------------------
If  ( oModel:GetValue( "SUSMASTER", "US_ORIGEM" ) $ "1|5|7" ) .And. Empty( oModel:GetValue( "SUSMASTER", "US_ENTORI" ) )
	Help( ,,STR0028,,STR0027, 1, 0 ) //"O campo Ent. Origem tem que ser preenchido"
	lRet := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o usuario trocou o segmento primario de uma amarracao com os subsegmentos. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	lRet	
	lRet := CRMA620TOkSeg(oModel:GetValue( "SUSMASTER", "US_CODSEG" ),aAOVMark)
Endif	

If nOpc == MODEL_OPERATION_UPDATE
	//------------------------------------
	// Envia para processamento dos Gets
	//------------------------------------
	If ( Type( "lTk260Auto" ) == "U" .OR. !lTk260Auto )
		If lTMK260D
			U_TMK260D( nOpc, nReg, oModel )
		Endif
	EndIf
EndIf

//---------------------------------------------------------------
// Valida se existe PE para verificar se grava ou nao o registro
//---------------------------------------------------------------
If lRet .AND. lTmk260OK
	lRet := ExecBlock( "TMK260OK", .F., .F., { nOpc, oModel } )
	//-------------------------------
	// Valida se o retorno eh logico
	//-------------------------------
	If ( ValType( lRet ) <> "L" )
		lRet := .F.
	Endif
Endif

If nOpc == MODEL_OPERATION_DELETE
	// Preenche um array com as filiais
	DbSelectArea( "SM0" )
	DbGoTop()
	While ! Eof()
		If SM0->M0_CODIGO == cEmpAnt
			Aadd( aSM0CodFil, FWGETCODFILIAL )
		Endif
		DbSkip()
	End
	
	DbGoTo( nRecnoSM0 )
	
	//-------------------------------------------------
	// Verifica se existe Orcamento no Televendas SUA
	//-------------------------------------------------
	DbSelectArea( "SUA" )
	DbSetOrder( 6 )//UA_CLIENTE+UA_LOJA+DTOS(UA_EMISSAO)
	
	If FWModeAccess( "SUA", 3 ) == "E" .AND. FWModeAccess( "SA1",3 ) == "C"
		aFiliais := aClone( aSM0CodFil )
	Else
		aFiliais := { xFilial() }
	Endif
	
	For nCont := 1 To Len( aFiliais )
		If DbSeek( aFiliais[nCont] + SUS->US_COD + SUS->US_LOJA ) .AND. SUA->UA_PROSPEC
			// Essa informacao nao podera ser apagada do sistema porque esta relacionada diretamente com as tabelas de atendimento
			lRet := .F.
			Help( "  ",1,"TMKNDELREL" )
			Exit
		Endif
	Next nCont
	
	//------------------------------------------------------
	// Verifica se existe Atendimento no Telemarketing SUC
	//------------------------------------------------------
	DbSelectArea( "SUC" )
	DbSetOrder( 2 )//UC_ENTIDAD+UC_CHAVE
	
	If FWModeAccess( "SUC", 3 ) == "E" .AND. FWModeAccess( "SUS", 3 ) == "C"
		aFiliais := aClone( aSM0CodFil )
	Else
		aFiliais := { xFilial() }
	Endif
	
	For nCont := 1 To Len( aFiliais )
		If DbSeek( aFiliais[nCont] + 'SUS' + SUS->US_COD + SUS->US_LOJA )
			Help( ,, STR0044,, STR0043, 1, 0 ) //"Atenção" ### "O Prospect não poderá ser excluído, pois, está diretamente relacionado com as tabelas de atendimento."
			lRet := .F.
			Exit
		Endif
	Next nCont	
	
	//-------------------------------------------------------------
	// Verifica se este prospect esta associado a uma oportunidade
	//-------------------------------------------------------------
	If Select( "AD1" ) == 0
		ChkFile( "AD1" )
	EndIf

	DbSelectArea( "AD1" )
	AD1->( DbSetOrder( 4 ) )
	If AD1->( DbSeek( xFilial( "AD1" ) + SUS->US_COD + SUS->US_LOJA ) )
		Help( " ", 1, "TM260OPOR" ) // Existe oportunid. com prospect -> cadastrar
		lRet := .F.
	Else
		//------------------------------------------------------------------------------
		// Verifica se existe vinculo do prospect no cadastro de Apontamento de Visitas
		//------------------------------------------------------------------------------
		If lRet 
			lRet := TK260ApVis()
		EndIf
	Endif
	
	//-------------------------------------------------------------------------
	// Verifica se existe vinculo do Prospect com o Orcamento de Vendas (SCJ)
	//-------------------------------------------------------------------------
	If Select( cAliasCJ ) > 0
		DbSelectArea( cAliasCJ )
		( cAliasCJ )->( DbCloseArea() )
	EndIf
	
	BeginSQL ALIAS cAliasCJ
		SELECT SCJ.CJ_FILIAL, SCJ.CJ_NUM, SCJ.CJ_PROSPE, SCJ.CJ_LOJPRO
		FROM %Table:SCJ% SCJ
		WHERE SCJ.CJ_PROSPE = %Exp:US_COD% AND SCJ.CJ_LOJPRO = %Exp:US_LOJA% AND SCJ.%NotDel% 			
	EndSQL
		
	If !( cAliasCJ )->( Eof() )
		lRet := .F.
		Help( " ", 1, "TM260OORC" ) // Não é possível excluir este prospect, pois, o mesmo está associado a um Orcamento de Vendas.###Exclua todas as referencias deste prospect.        
	EndIf
	
	( cAliasCJ )->( DbCloseArea() )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a avaliação do(s) melhor(es) territorio(s) para atender esta conta . ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lRet .And. nModulo == 73 .And. ( nOpc == MODEL_OPERATION_INSERT .Or. nOpc == MODEL_OPERATION_UPDATE ) )
	lRet := CRMA690EvalTerritory("TMKA260","SUS",.T.,.F.)
EndIf

RestArea( aAreaSA3 )
RestArea( aArea )

Return( lRet )

//------------------------------------------------------------------------------
/*/{Protheus.doc} Tk260Cmm

Faz o Commit dos Dados.   

@sample 	Tk260CMM( oModel )

@param		oModel -  Modelo de dados do sistema

@return   	lRet   -  Retorna verdadeiro ou falso

@author		Vendas CRM
@since		01/02/2012
@version	12
/*/
//------------------------------------------------------------------------------
Static Function Tk260Cmm( oModel )

Local aArea		:= GetArea()		
Local nOperation	:= oModel:GetOperation()			
Local lRet			:= .T.                 
Local cVendAnt	:= ""
Local cCodigo		:= ""
Local cLoja		:= ""
Local cCGCAnt		:= ""
Local cNomeAnt	:= ""
Local cCodSeg	:= oModel:GetValue('SUSMASTER', 'US_CODSEG' )
Local lAOWDeleted := .F.

If nOperation == MODEL_OPERATION_UPDATE .Or. nOperation == MODEL_OPERATION_DELETE
	cVendAnt	:=	SUS->US_VEND	
	cNomeAnt	:=	SUS->US_NOME 
	cCGCAnt	:=	SUS->US_CGC		
	cCodigo	:=	SUS->US_COD
	cLoja		:=	SUS->US_LOJA			
EndIf	

lRet := FWFormCommit( oModel, Nil, { |oModel, cId, cAlias| Tk260After(oModel, cId, cAlias, cVendAnt, cNomeAnt, cCGCAnt, cCodigo, cLoja) } )

// Prepara para apagar as amarracoes caso seja exclusao de prospect ou o segmento principal esteja vazio
If ( nOperation == MODEL_OPERATION_DELETE .Or. Empty(oModel:GetValue("SUSMASTER", "US_CODSEG")) )
	lAOWDeleted := .T.
EndIf

// Efetiva as amarracoes de subsegmentos
If !Empty(cCodSeg)
	CRMA620GrvAOW(aAOVMark, "SUS", oModel:GetValue("SUSMASTER", "US_COD"), oModel:GetValue("SUSMASTER", "US_LOJA"), oModel:GetValue("SUSMASTER", "US_CODSEG") ,lAOWDeleted )
EndIf

RestArea(aArea)

Return( lRet )
  
//------------------------------------------------------------------------------
/*/{Protheus.doc} Tk260Can

Bloco de cancelamento do formulario.   

@sample 	Tk260Can( oModel )

@author		Vendas CRM
@since		16/06/2014
@version	12
/*/
//------------------------------------------------------------------------------
Static Function Tk260Can()
	//Limpa array com subsegmentos.
	aAOVMark := {}
	//Retorna numeração
	If GetSx8Len() > 0
		RollBackSX8()
	EndIf
Return(.T.) 

//------------------------------------------------------------------------------
/*/{Protheus.doc} Tk260After

Faz a gravação dos dados posteriores depois do Commit.     

@sample 	Tk260After( oModel, cId, cAlias, cVendAnt, cNomeAnt, cCGCAnt, cCodigo, cLoja )

@param		oModel 		-  Modelo de dados do sistema 
			cId 	- Id do Modelo
			cAlias - Alias
			cVendAnt	-  Vendedor atual  
			cNomeAnt	-  Nome da entidade
			cCGCAnt		-  CGC do Prospect
			cCodigo     -  Código do Prospect
			cLoja		-  Loja do Prospect			

@return   	lRet   		-  Retorna verdadeiro ou falso

@author		Vendas CRM
@since		06/03/2014
@version	12
/*/
//------------------------------------------------------------------------------
Function Tk260After( oModel, cId, cAlias, cVendAnt, cNomeAnt, cCGCAnt, cCodigo, cLoja )

Local aArea 		 := GetArea()
Local aAreaAO3	 := AO3->(GetArea())			// Armazena posicionamento atual do AO3
Local aAreaAO4	 := AO4->(GetArea())			// Armazena posicionamento atual do AO4
Local aAreaSUS	 := SUS->(GetArea())			// Armazena posicionamento atual do ACH
Local nOperation	 := oModel:GetOperation()
Local lRet			 := .T.
Local lAtuADL		 := .F.
Local lTmk260		 := ExistBlock("TMK260")		    // P.E. Depois da gravacao do Prospect
Local lProcADL  	 := GetMv( "MV_CRMADL",,.T. )  	// Indica se a ADL deverá ter manutenção
Local cVenSusp	 := ""
Local cCodSusp	 := ""
Local cLojSusp	 := ""
Local cChave		 := ""
Local aAutoAO4	 := {}
Local cUserAnt	 := ""
Local aAutoAO4Aux	 := {}
Local aTerritory	 := Nil
Local cCodUsr		 := ""
	
If lTmk260
	DbSelectArea(cAlias)
	ExecBlock("TMK260",.F.,.F.,{} )
Endif
      
If lProcADL   
	DbSelectArea("SX2")
	SX2->(DbSetOrder(1))
	lAtuADL := SX2->(DbSeek("ADL"))
EndIf

If nOperation == MODEL_OPERATION_INSERT
	If lAtuADL .And. !Empty( SUS->US_VEND )
		Ft520Inc( SUS->US_VEND, "SUS", SUS->US_COD, SUS->US_LOJA )
	EndIf
EndIf         

If nOperation == MODEL_OPERATION_UPDATE
	If lAtuADL
		If Empty( cVendAnt ) .AND. !Empty( SUS->US_VEND )
			Ft520Inc( SUS->US_VEND, "SUS", SUS->US_COD, SUS->US_LOJA )
		ElseIf !Empty( cVendAnt ) .AND. SUS->US_VEND <> cVendAnt
			Ft520Alt( cVendAnt, SUS->US_VEND, "SUS", SUS->US_COD, SUS->US_LOJA )
		EndIf
		
		//-------------------------------------
		// Atualiza a tabela de referencia ADL
		//-------------------------------------
		If ( ( cCGCAnt <> SUS->US_CGC ) .OR. ( cNomeAnt <> SUS->US_NOME ) )
			Ft520AtuEn( "SUS", SUS->US_COD, SUS->US_LOJA, SUS->US_NOME, SUS->US_CGC )
		EndIf
	EndIf
EndIf

If nOperation == MODEL_OPERATION_DELETE
	lRet := Tk260AtACH()
	If lAtuADL .AND. !Empty( cVendAnt )  
	   	//Remove amarracao com o vendedor
		Ft520Del( cVendAnt, "SUS", cCodigo, cLoja ) 
		//----------------------------------------------------------------
		// Verifica se foi originado a partir de um suspect para refazer
		//                   a amarracao com a ADL.                                         
		//----------------------------------------------------------------
		DbSelectArea( "ACH" )
		DbSetOrder( 4 ) //ACH_FILIAL+ACH_CODPRO+ACH_LOJPRO
		If DbSeek( xFilial( "ACH" ) + cCodigo + cLoja )
			cCodSusp := ACH->ACH_CODIGO
			cLojSusp := ACH->ACH_LOJA
			cVenSusp := ACH->ACH_VEND				
			If !Empty( cCodSusp )
				//Inclui amarracao com suspect
				Ft520Inc( cVenSusp, "ACH", cCodSusp, cLojSusp ) 
			EndIf	
		EndIf	
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclusao de Anotações    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		                                                                        
	If nModulo == 73 .And. FindFunction( "CRMA090" )
		CRMA090Del( "SUS", SUS->( Recno() ) )
	EndIf			
	If !Tka260Del()
		lRet := .F.
		Return( lRet )
	Endif
EndIf 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adiciona ou Remove o privilegios deste registro.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cId == "SUSMASTER"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a distribuicao da conta + rodizio para o territorio vencedor. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( nModulo == 73 .And. ( nOperation == MODEL_OPERATION_INSERT .OR. nOperation == MODEL_OPERATION_UPDATE ) )	
		aTerritory := CRMA690CasterTerritory() 
		If aTerritory[1]
			RecLock("SUS",.F.)
			SUS->US_CODTER 	:= aTerritory[2]  // Código do Territorio.
			SUS->US_TPMEMB 	:= aTerritory[3]  // Tipo do Membro
			SUS->US_CODMEMB	:= aTerritory[4]  // Codigo do Membro
			SUS->(MsUnLock())
		EndIf
	EndIf
	
	cChave := PadR(xFilial("SUS")+oModel:GetValue("US_COD")+oModel:GetValue("US_LOJA"),TAMSX3("AO4_CHVREG")[1])
	
	If ( nOperation == MODEL_OPERATION_INSERT .OR. nOperation == MODEL_OPERATION_DELETE )
	
		If !Empty(RetCodUsr())
			cCodUsr:= RetCodUsr() //Usuário do protheus
		Else
			cCodUsr:= UsrPrtErp() //Usuario do portal
		EndIf
		
		aAutoAO4	:= CRMA200PAut(nOperation,"SUS",cChave,cCodUsr,/*aPermissoes*/,/*aNvlEstrut*/,/*cCodUsrCom*/,/*dDataVld*/)
		
		If nOperation == MODEL_OPERATION_INSERT
			
			DbSelectArea("AO3")
			AO3->(DbSetOrder(1))	// AO3_FILIAL+AO3_CODUSR
			
			If AO3->(DbSeek(xFilial("AO3")+cCodUsr))
				
				// Se o codigo do vendendor logado for diferente do cadastrado, insere na AO4 como compartilhado
				If !Empty(oModel:GetValue("US_VEND")) .AND. AO3->AO3_VEND <> oModel:GetValue("US_VEND")
					
					AO3->(DbSetOrder(2))	// AO3_FILIAL+AO3_VEND
					
					If AO3->(DbSeek(xFilial("AO3")+oModel:GetValue("US_VEND")))
						aAutoAO4Aux := CRMA200PAut(nOperation,"SUS",cChave,AO3->AO3_CODUSR,/*aPermissoes*/,/*aNvlEstrut*/,RetCodUsr(),/*dDataVld*/)
						aAdd(aAutoAO4[2],aAutoAO4Aux[2][1])
					EndIf
					
				EndIf
				
			EndIf
			
		EndIf
		
	ElseIf nOperation == MODEL_OPERATION_UPDATE
		 
		If !Empty(oModel:GetValue("US_VEND"))
			
			If Empty(cVendAnt)
				cVendAnt := oModel:GetValue("US_VEND")	
			EndIf
			
			DbSelectArea("AO3")
			AO3->(DbSetOrder(2))	// AO3_FILIAL+AO3_VEND
			
			If AO3->(DbSeek(xFilial("AO3")+cVendAnt))
				
				DbSelectArea("AO4")
				AO4->(DbSetOrder(1))		// AO4_FILIAL+AO4_ENTIDA+AO4_CHVREG+AO4_CODUSR
				
				If !AO4->(DbSeek(xFilial("AO4")+"SUS"+cChave+AO3->AO3_CODUSR))
					aAutoAO4 := CRMA200PAut(nOperation,"SUS",cChave,AO3->AO3_CODUSR,/*aPermissoes*/,/*aNvlEstrut*/,RetCodUsr(),/*dDataVld*/)
				Else
					
					cUserAnt := AO3->AO3_CODUSR
						
					If AO3->AO3_VEND <> oModel:GetValue("US_VEND")
							
						If AO3->(DbSeek(xFilial("AO3")+oModel:GetValue("US_VEND"))) 
								
							DbSelectArea("AO4")
							AO4->(DbSetOrder(1))		// AO4_FILIAL+AO4_ENTIDA+AO4_CHVREG+AO4_CODUSR
							
							//Verifica se o vendedor atual possui privilegios para este registro.
							If AO4->(DbSeek(xFilial("AO4")+"SUS"+cChave+AO3->AO3_CODUSR))
								//Se possui deleta o acesso do vendedor anterior
								If AO4->(DbSeek(xFilial("AO4")+"SUS"+cChave+cUserAnt))
									RecLock("AO4",.F.)
									AO4->(DbDelete())
									AO4->(MsUnlock())
								EndIf	
							Else
								//Senão troca o privilegios.
								If AO4->(DbSeek(xFilial("AO4")+"SUS"+cChave+cUserAnt))
									RecLock("AO4",.F.)
									AO4->AO4_CODUSR := AO3->AO3_CODUSR
									AO4->AO4_IDESTN := AO3->AO3_IDESTN
									AO4->AO4_NVESTN := AO3->AO3_NVESTN
									AO4->(MsUnlock())
								EndIf
								
							EndIf
								
						EndIf
							
					EndIf
						
				EndIf
					
			EndIf
				
		Else
			
			If !Empty(cVendAnt)
			
				DbSelectArea("AO3")
				AO3->(DbSetOrder(2))			// AO3_FILIAL+AO3_VEND
				
				If AO3->(DbSeek(xFilial("AO3")+cVendAnt))
					
					DbSelectArea("AO4")
					DbSetOrder(1)		// AO4_FILIAL+AO4_ENTIDA+AO4_CHVREG+AO4_CODUSR
					
					If AO4->(DbSeek(xFilial("AO4")+"SUS"+cChave+AO3->AO3_CODUSR))
						RecLock("AO4",.F.)
						AO4->(DbDelete())
						AO4->(MsUnlock())
					EndIf
					
				EndIf
				
			EndIf
			
		EndIf
		
	EndIf
	
	If Len(aAutoAO4) > 0
		DbSelectArea("AO4")	
		AO4->(DbSetOrder(1)) 	// AO4_FILIAL+AO4_ENTIDA+AO4_CHVREG+AO4_CODUSR
		If !AO4->(DbSeek(xFilial("AO4")+"SUS"+cChave))
			nOperation := MODEL_OPERATION_INSERT 	
		EndIf
		lRet := CRMA200Auto(aAutoAO4[1],aAutoAO4[2],nOperation)
	EndIf
	
EndIf
            
RestArea(aAreaSUS)
RestArea(aAreaAO3)
RestArea(aAreaAO4)
RestArea(aArea)

Return(lRet)   

//------------------------------------------------------------------------------
/*/{Protheus.doc} Tka260Menu

Retorna o menu na rotina crma070 (Contas = Prospects + Cliente) no modulo CRM. 

@return     MenuDef()      - Operações da aplicação

@author		Vendas CRM
@since		08/11/2013
@version	12
/*/
//------------------------------------------------------------------------------
Function Tka260Menu()

Return( MenuDef() )
 
//------------------------------------------------------------------------------
/*/{Protheus.doc} Tka260Per

Chamada para tela de perfil no modulo CRM. 

@return   	Nil

@author		Vendas CRM
@since		07/11/2013
@version	12
/*/
//------------------------------------------------------------------------------
Function Tka260Per()

TK010Con( ,,,,, "SUS", SUS->US_COD + SUS->US_LOJA )

Return
                 
//------------------------------------------------------------------------------
/*/{Protheus.doc} Tk2Tk260DscCli

Incializador do campo virtual SUS_DESCCLI    

@return   	lRet   -  Retorna verdadeiro ou falso

@author		Vendas CRM
@since		27/02/2009
@version	12
/*/
//------------------------------------------------------------------------------
Function Tk260DscCl()                                  
Local lRet := '' 

// Se for inclusao deve ser iniciado com branco           
// Se nao for inclusao deve verificar se os campos SUS->US_CODCLI+SUS->US_LOJACLI estao preenchidos, para buscar 
// no SA1 a descricao. Se nao estiverem devolve branco           
If !Inclui
   lRet := If( !Empty( SUS->US_CODCLI + SUS->US_LOJACLI ), Posicione( "SA1", 1, xFilial( "SA1" ) + SUS->US_CODCLI + SUS->US_LOJACLI, "A1_NOME" ), "" ) 
Endif

Return lRet    

//------------------------------------------------------------------------------
/*/{Protheus.doc} Tka260Vis

Programacao das Visitas dos Representantes Comerciais aos Prospects

@return   	.T.		- Verdadeiro

@author		Vendas CRM
@since		16/11/1999
@version	12
/*/
//------------------------------------------------------------------------------
Function Tka260Vis()

If ( Pergunte( "TMK260", .T. ) )
	FtVisProsp( MV_PAR02, MV_PAR01 )
Endif

Return( .T. )
             
//------------------------------------------------------------------------------
/*/{Protheus.doc} TK260ApVis

Verifica se existe vinculo do prospect no cadastro de apontamento de visitas  

@return   	lRet   -  Retorna verdadeiro ou falso

@author		Vendas CRM
@since		26/12/2011
@version	12
/*/
//------------------------------------------------------------------------------          
Static Function TK260ApVis()                                                    

Local cAliasTRB := GetNextAlias()	// Nome do arquivo temporario
Local cQuery    := ""				// Auxiliar para execucao de query
Local aArea     := GetArea()		// Salva area atual para posterior restauracao
Local lRet      := .T.				// Conteudo de retorno

//-------------------------------------------------------------------------
//Query para pesquisar o prospect na tabela de Apontamento de Visitas(AD5)
//-------------------------------------------------------------------------
cQuery := "SELECT * "

//-----------------------
// Tabela base do filtro 
//-----------------------
cQuery += "FROM "  
cQuery += RetSqlName("AD5")+" AD5 "	 // Apontamento do Contato/Visita 

//---------------------
// Condicoes de filtro 
//---------------------
cQuery += "WHERE "
cQuery += "AD5_FILIAL = '"+ xFilial("AD5")+"' AND "
cQuery += "AD5_PROSPE = '"+ SUS->US_COD   +"' AND "
cQuery += "AD5_LOJPRO = '"+ SUS->US_LOJA  +"' AND "
cQuery += "AD5.D_E_L_E_T_  <> '*'"

cQuery := ChangeQuery( cQuery )

DbUseArea( .T., 'TOPCONN', TCGENQRY( ,, cQuery ), cAliasTRB, .T., .T. )

If !( cAliasTRB )->( Eof() )
	Help( "  ",1,"PROSPNODEL" ) 
	lRet := .F.	
EndIf

( cAliasTRB )->( DbCloseArea() )

RestArea( aArea )

Return( lRet ) 

//------------------------------------------------------------------------------
/*/{Protheus.doc} TKA260DEL

Validacao da exclusao do Prospect  

@sample 	Tka260Del

@param		Nil

@return   	lRet   -  Retorna verdadeiro ou falso

@author		Vendas CRM
@since		27/12/200
@version	12
/*/
//------------------------------------------------------------------------------
Function Tka260Del()

Local aArea      := GetArea()				// Salva a area atual
Local lRet       := .T.						// Retorno da funcao

DbSelectArea( "SUS" )
If lRet 
	//-------------------------------------
	// Exclui a amarracao com os contatos 
	//-------------------------------------
	FtContato( Alias(), RecNo(), 2, , 3 ) 
	//-----------------------------------------
	// Exclui a amarracao com os conhecimentos
	//-----------------------------------------
	MsDocument( Alias(), RecNo(), 2, , 3 )
	//----------------------------------------
	// Exclusao da Geocodificacao da entidade
	//----------------------------------------
	GeoSavCoor( xFilial( "SUS" ), "SUS", SUS->US_COD + SUS->US_LOJA,/*cLatitude*/,/*cLongitude*/,.F.,.T. )
Endif 		

RestArea( aArea )

Return( lRet )   


//------------------------------------------------------------------------------
/*/{Protheus.doc} Tk260CGC

Validacao do CPF/CNPJ do Prospect (Utilizado no Valid do campo US_CGC)           

@sample 	Tk260CGC( cCgc )

@param		cCgc 	-  CNPJ do registro posicionado

@return   	lRet    - Verdadeiro ou Falso

@author		Vendas CRM
@since		12/03/2008
@version	12
/*/
//------------------------------------------------------------------------------
Function Tk260CGC( cCgc )

Local aArea  		:= GetArea()
Local lRet   		:= .T.
Local cMay   		:= ""
Local cValCnpj		:= SuperGetMv("MV_VALCNPJ",,"1")	//Validacao do CNPJ: 1 - Notifica e permite a inclusao  2 - nao inclui CNPJs duplicados.  

Default cCgc := M->US_CGC

If !Empty( cCgc )
	cMay := "SUS" + xFilial( "SUS" ) + cCgc 
   
   	lRet := CGC( cCgc ) 
   	
   	If lRet .AND. !(Existchav( "SUS", cCgc, 4, "US_CGC" ) .AND. MayIUseCode( cMay ) .AND. TmkVeEnt( cCgc, "SUS" ) )
		If cValCnpj == "1"
			If ( Type( "lTk260Auto" ) == "U" .OR. !lTk260Auto )
				Aviso(STR0028,STR0070,{STR0071},2)//"Atenção"##"O Cnpj Informado já está sendo utilizado"##"OK"			
			EndIf
			lRet := .T.
		Else 
			lRet := .F.
			Leave1Code( cMay )
		EndIf
	
	EndIf
	
EndIf

RestArea( aArea )

Return ( lRet )  

//------------------------------------------------------------------------------
/*/{Protheus.doc} Tk260AtACH

Atualiza o cadastro de suspect vinculado ao prospect, excluindo as amarrações 
entre os cadastros.

@sample 	Tk260AtACH()

@return   	lRet   -  Retorna verdadeiro ou falso

@author		Vendas CRM
@since		26/11/2007
@version	12
/*/
//------------------------------------------------------------------------------
Function Tk260AtACH()

Local lRet		:= .T.
Local aArea		:= GetArea()

DbSelectArea( "ACH" )
DbSetOrder( 4 ) //ACH_FILIAL+ACH_CODPRO+ACH_LOJPRO

If DbSeek( xFilial( "ACH" ) + SUS->( US_COD + US_LOJA ) )
	RecLock( "ACH", .F. )
	Replace ACH->ACH_CODPRO With ""
	Replace ACH->ACH_LOJPRO With ""
	Replace ACH->ACH_STATUS With "0"
	Replace ACH->ACH_DTCONV With CtoD("")
	MsUnLock()
EndIf

RestArea( aArea )

Return( lRet )
    
//------------------------------------------------------------------------------
/*/{Protheus.doc} TK260Legenda

Legendas do browse de cadastro de Prospect  

@sample 	TK260Legenda()

@return   	.T.   -  Retorna verdadeiro

@author		Vendas CRM
@since		04/11/2003
@version	12
/*/
//------------------------------------------------------------------------------
Function Tk260Legenda()
                      //Legenda
BrwLegenda( cCadastro, STR0015, { { "BR_BRANCO"   ,STR0022 } ,;  // Mailing 
								  { "BR_MARROM"   ,STR0016 } ,;  // Classificado
   							      { "BR_VERMELHO" ,STR0017 } ,;  // Desenvolvimento
   								  { "BR_AZUL"     ,STR0018 } ,;  // Gerente
								  { "BR_AMARELO"  ,STR0019 } ,;  // Standy by
								  { "BR_PRETO"    ,STR0020 } ,;  // Cancelado
								  { "BR_VERDE"    ,STR0021 } } ) // Cliente     
								  
Return( .T. )                                                                     


//------------------------------------------------------------------------------
/*/{Protheus.doc} Tk260VldEnt

Efetua a validacao da origem para saber se o campo US_ENTORI pode ser editavel.  

@sample 	Tk260VldEnt()

@return   	lRet   -  Retorna verdadeiro ou falso

@author		Vendas CRM
@since		22/05/2013
@version	12
/*/
//------------------------------------------------------------------------------
Function Tk260VldEnt()

Local lRet := .F.

If M->US_ORIGEM $ "1|5|7" 
	 lRet := .T.
EndIf

Return( lRet )


//------------------------------------------------------------------------------
/*/{Protheus.doc} TK260VldCd

Efetua a validacao para saber se o codigo que o usuario digitou 
          no campo US_ENTORI existe na tabela.

@sample 	Tk260VldEnt()

@return   	lRet   -  Retorna verdadeiro ou falso

@author		Vendas CRM
@since		22/05/2013
@version	12
/*/
//------------------------------------------------------------------------------        
Function TK260VldCd()   

Local lRet	:=	.F. 

// 1=Mailing;2=Campanha;3=Web;4=Indicacao;5=Evento;6=Anuncio;7=Parceiro;8=Relacoes publicas;9=Seminario;A=Boca-a-boca;B=Outros
Do Case
	Case M->US_ORIGEM == "1" .AND. !Empty(M->US_ENTORI)		//1=Mailing
		lRet := ExistCpo("SA2", M->US_ENTORI)
	Case M->US_ORIGEM == "5" .AND. !Empty(M->US_ENTORI)		//5=Evento
		lRet := ExistCpo("ACD", M->US_ENTORI)
	Case M->US_ORIGEM == "7" .AND. !Empty(M->US_ENTORI)	 	//7=Parceiro 
		lRet := ExistCpo("AC4", M->US_ENTORI)
	Case Empty(M->US_ENTORI)
		lRet := .T.
EndCase

Return( lRet ) 
//------------------------------------------------------------------------------
/*/{Protheus.doc} Tk260Mile

Importa layout do acelerador MILE referente ao adapter TMKA260 (Prospect)

@sample 	Tk260Mile(cCodLayout) 

@param		cCodLayout				Layout a ser importado	
	
@return	Verdeiro ou Falso

@author	Aline Kokumai
@since		21/06/2013       
@version	P11.80   
/*/ 
//------------------------------------------------------------------------------
Function Tk260Mile(cCodLayout)

Local lRetorno		:= .T.			//Retorno da função
Local cCode 		:= ""			//Codigo do layout
Local cDesc 		:= ""  			//Descrição do layout
Local cAdapter		:= 'TMKA260' 	//Nome do adapter
Local cType	   		:= '1'			//Código tipo
Local cAtivo		:= '1'			//Código ativo
Local cLayout		:= "" 

If cCodLayout == "SUSLAY01"
	Tk341SUSLAY(@cCode, @cDesc, @cLayout)
EndIf

DbSelectArea("XXJ")
RecLock("XXJ",.T.)
XXJ->XXJ_CODE 	:= cCode
XXJ->XXJ_DESC 	:= cDesc
XXJ->XXJ_ADAPT	:= cAdapter
XXJ->XXJ_LAYOUT	:= cLayout
XXJ->XXJ_TYPE	:= cType
XXJ->XXJ_ACTIVE	:= cAtivo
XXJ->(MsUnLock())

Return(lRetorno)  

//------------------------------------------------------------------------------
/*/{Protheus.doc} Tk341SUSLAY

Carrega o conteúdo XML do layout SUSLAY01.

@sample 	Tk341SUSLAY(cCode, cDesc, cLayout) 

@param		cCode				Codigo do layout	
@param		cDesc				Descrição do layout
@param		cLayout			Conteúdo XML do layout
	
@return	

@author	Cristiane Nishizaka
@since		29/10/2013       
@version	P11.90   
/*/
//------------------------------------------------------------------------------

Function Tk341SUSLAY(cCode, cDesc, cLayout)

cCode 				:= 'SUSLAY01' 							//Codigo do layout
cDesc 				:= STR0029								//Descrição do layout: 'LAYOUT IMPORTACAO DE PROSPECT'

//XML do Layout
cLayout := 		'<?xml version="1.0" encoding="UTF-8"?><CFGA600 Operation="4" version="1.01">'+;
					'<XZ1MASTER modeltype="FIELDS" >'+;
					'<XZ1_LAYOUT order="1"><value>SUSLAY01</value></XZ1_LAYOUT>'+;
					'<XZ1_TYPE order="2"><value>2</value></XZ1_TYPE>'+;
					'<XZ1_DESC order="3"><value>'+STR0029+'</value></XZ1_DESC>'+;
					'<XZ1_ADAPT order="4"><value>TMKA260</value></XZ1_ADAPT>'+;
					'<XZ1_STRUC order="5"><value>2</value></XZ1_STRUC>'+;
					'<XZ1_SEPARA order="6"><value>;</value></XZ1_SEPARA>'+;
					'<XZ1_TYPEXA order="7"><value>1</value></XZ1_TYPEXA>'+;
					'<XZ1_SEPINI order="8"><value>2</value></XZ1_SEPINI>'+;
					'<XZ1_SEPFIN order="9"><value>2</value></XZ1_SEPFIN>'+;
					'<XZ1_TABLE order="10"><value>SUS</value></XZ1_TABLE>'+;
					'<XZ1_DESTAB order="11"><value>'+STR0030+'</value></XZ1_DESTAB>'+; //PROSPECTS
					'<XZ1_ORDER order="12"><value>1</value></XZ1_ORDER>'+;
					'<XZ1_SOURCE order="13"><value>0000</value></XZ1_SOURCE>'+;
					'<XZ1_TIPDAT order="18"><value>1</value></XZ1_TIPDAT>'+;
					'<XZ1_DECSEP order="19"><value>2</value></XZ1_DECSEP>'+;
					'<XZ1_EMULTC order="20"><value>2</value></XZ1_EMULTC>'+;
					'<XZ1_DETOPC order="21"><value>2</value></XZ1_DETOPC>'+;
					'<XZ1_IMPEXP order="23"><value>1</value></XZ1_IMPEXP>'+;
					'<XZ1_VERSIO order="24"><value>1.0</value></XZ1_VERSIO>'+;
					'<XZ1_MVCOPT order="25"><value>2</value></XZ1_MVCOPT>'+;
					'<XZ1_MVCMET order="26"><value>1</value></XZ1_MVCMET>'+;
					'<XZ2DETAIL modeltype="GRID">'+;
						'<struct>'+;
							'<XZ2_LAYOUT order="1"></XZ2_LAYOUT>'+;
							'<XZ2_SEQ order="2"></XZ2_SEQ>'+;
							'<XZ2_CHANEL order="3"></XZ2_CHANEL>'+;
							'<XZ2_SUPER order="4"></XZ2_SUPER>'+;
						'</struct>'+;
						'<items>'+;
							'<item id="1" deleted="0" >'+;
								'<XZ2_SEQ>01</XZ2_SEQ>'+;
								'<XZ2_CHANEL>01</XZ2_CHANEL>'+;
									'<XZ3DETAIL modeltype="FIELDS" >'+;
									'<XZ3_CHANEL order="2"><value>01</value></XZ3_CHANEL>'+;
									'<XZ3_DESC order="3"><value>'+STR0031+'</value></XZ3_DESC>'+; //CANAL 01
									'<XZ3_IDOUT order="4"><value>SUSMASTER</value></XZ3_IDOUT>'+;
									'<XZ3_OCCURS order="5"><value>1</value></XZ3_OCCURS>'+;
									'</XZ3DETAIL>'+;
										'<XZ4DETAIL modeltype="GRID" optional="1">'+;
											'<struct>'+;
												'<XZ4_LAYOUT order="1"></XZ4_LAYOUT>'+;
												'<XZ4_CHANEL order="2"></XZ4_CHANEL>'+;
												'<XZ4_SEQ order="3"></XZ4_SEQ>'+;
												'<XZ4_FIELD order="4"></XZ4_FIELD>'+;
												'<XZ4_TYPFLD order="5"></XZ4_TYPFLD>'+;
												'<XZ4_EXEC order="6"></XZ4_EXEC>'+;
												'<XZ4_COND order="7"></XZ4_COND>'+;
												'<XZ4_NOVAL order="8"></XZ4_NOVAL>'+;
												'<XZ4_DESC order="9"></XZ4_DESC>'+;
												'<XZ4_OBS order="10"></XZ4_OBS>'+;
												'<XZ4_SOURCE order="11"></XZ4_SOURCE>'+;
											'</struct>'+;
											'<items>'+;
													'<item id="1" deleted="0" >'+;
														'<XZ4_SEQ>001</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_COD</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_COND>.F.</XZ4_COND>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform ( RetTitle("US_COD"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0001</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="2" deleted="0" >'+;
														'<XZ4_SEQ>002</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_LOJA</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_LOJA"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0002</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="3" deleted="0" >'+;
														'<XZ4_SEQ>003</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_NOME</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_NOME"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0003</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="4" deleted="0" >'+;
														'<XZ4_SEQ>004</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_TIPO</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_TIPO"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0004</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="5" deleted="0" >'+;
														'<XZ4_SEQ>005</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_END</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_END"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0005</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="6" deleted="0" >'+;
														'<XZ4_SEQ>006</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_MUN</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_MUN"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0006</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="7" deleted="0" >'+;
														'<XZ4_SEQ>007</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_EST</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_EST"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0007</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="8" deleted="0" >'+;
														'<XZ4_SEQ>008</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_BAIRRO</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_BAIRRO"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0008</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="9" deleted="0" >'+;
														'<XZ4_SEQ>009</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_CEP</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_EXEC>IIF(!Empty(xA),Strtran(Strtran(Strtran( xA, &quot;-&quot;, &quot;&quot; ),&quot;/&quot;,&quot;&quot;),&quot;.&quot;,&quot;&quot;),&quot;&quot;)</XZ4_EXEC>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_CEP"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0009</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="10" deleted="0" >'+;
														'<XZ4_SEQ>010</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_PAIS</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_PAIS"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0010</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="11" deleted="0" >'+;
														'<XZ4_SEQ>011</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_NREDUZ</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_NREDUZ"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0011</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="12" deleted="0" >'+;
														'<XZ4_SEQ>012</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_DDI</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_DDI"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0012</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="13" deleted="0" >'+;
														'<XZ4_SEQ>013</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_DDD</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_DDD"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0013</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="14" deleted="0" >'+;
														'<XZ4_SEQ>014</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_TEL</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_TEL"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0014</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="15" deleted="0" >'+;
														'<XZ4_SEQ>015</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_FAX</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_FAX"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0015</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="16" deleted="0" >'+;
														'<XZ4_SEQ>016</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_EMAIL</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_EMAIL"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0016</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="17" deleted="0" >'+;
														'<XZ4_SEQ>017</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_URL</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_URL"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0017</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="18" deleted="0" >'+;
														'<XZ4_SEQ>018</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_STATUS</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_STATUS"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0018</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="19" deleted="0" >'+;
														'<XZ4_SEQ>019</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_ORIGEM</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_ORIGEM"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0019</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="20" deleted="0" >'+;
														'<XZ4_SEQ>020</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_ENTORI</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_ENTORI"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0020</XZ4_SOURCE></item>'+;
													'<item id="21" deleted="0" >'+;
														'<XZ4_SEQ>021</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_CGC</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_EXEC>IIF(!Empty(xA),Strtran(Strtran(Strtran( xA, &quot;-&quot;, &quot;&quot; ),&quot;/&quot;,&quot;&quot;),&quot;.&quot;,&quot;&quot;),&quot;&quot;)</XZ4_EXEC>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_CGC"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0021</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="22" deleted="0" >'+;
														'<XZ4_SEQ>022</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_CNAE</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_CNAE"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0022</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="23" deleted="0" >'+;
														'<XZ4_SEQ>023</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_MIDIA</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_MIDIA"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0023</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="24" deleted="0" >'+;
														'<XZ4_SEQ>024</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_ULTVIS</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>D</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_ULTVIS"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0024</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="25" deleted="0" >'+;
														'<XZ4_SEQ>025</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_VEND</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_VEND"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0025</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="26" deleted="0" >'+;
														'<XZ4_SEQ>026</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_CODSEG</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_CODSEG"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0026</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="27" deleted="0" >'+;
														'<XZ4_SEQ>027</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_INSCR</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_INSCR"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0027</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="28" deleted="0" >'+;
														'<XZ4_SEQ>028</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_ALIQIR</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>N</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_ALIQIR"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0028</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="29" deleted="0" >'+;
														'<XZ4_SEQ>029</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_GRPTRIB</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_GRPTRIB"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0029</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="30" deleted="0" >'+;
														'<XZ4_SEQ>030</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_NATUREZ</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_NATUREZ"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0030</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="31" deleted="0" >'+;
														'<XZ4_SEQ>031</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_RECCOFI</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_RECCOFI"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0031</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="32" deleted="0" >'+;
														'<XZ4_SEQ>032</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_RECCSLL</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_RECCSLL"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0032</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="33" deleted="0" >'+;
														'<XZ4_SEQ>033</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_RECISS</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_RECISS"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0033</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="34" deleted="0" >'+;
														'<XZ4_SEQ>034</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_RECINSS</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_RECINSS"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0034</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="35" deleted="0" >'+;
														'<XZ4_SEQ>035</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_CONTRIB</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_CONTRIB"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0035</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="36" deleted="0" >'+;
														'<XZ4_SEQ>036</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_RECPIS</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_RECPIS"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0036</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="37" deleted="0" >'+;
														'<XZ4_SEQ>037</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_SUFRAMA</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_SUFRAMA"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0037</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="38" deleted="0" >'+;
														'<XZ4_SEQ>038</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_TPESSOA</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_TPESSOA"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0038</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="39" deleted="0" >'+;
														'<XZ4_SEQ>039</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_TRASLA</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_TRASLA"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0039</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="40" deleted="0" >'+;
														'<XZ4_SEQ>040</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_LC</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>N</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_LC"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0040</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="41" deleted="0" >'+;
														'<XZ4_SEQ>041</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_VENCLC</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>D</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_VENCLC"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0041</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="42" deleted="0" >'+;
														'<XZ4_SEQ>042</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_MOEDALC</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>N</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_MOEDALC"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0042</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="43" deleted="0" >'+;
														'<XZ4_SEQ>043</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_FATANU</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>N</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_FATANU"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0043</XZ4_SOURCE>'+;
													'</item>'+;
													'<item id="44" deleted="0" >'+;
														'<XZ4_SEQ>044</XZ4_SEQ>'+;
														'<XZ4_FIELD>US_QTFUNC</XZ4_FIELD>'+;
														'<XZ4_TYPFLD>C</XZ4_TYPFLD>'+;
														'<XZ4_NOVAL>2</XZ4_NOVAL>'+;
														'<XZ4_DESC>'+ Transform(RetTitle("US_QTFUNC"), "@!") +'</XZ4_DESC>'+;
														'<XZ4_SOURCE>0044</XZ4_SOURCE>'+;
													'</item>'+;
											'</items>'+;
										'</XZ4DETAIL>'+;
										'<XZ5DETAIL modeltype="GRID" optional="1">'+;
											'<struct>'+;
												'<XZ5_LAYOUT order="1"></XZ5_LAYOUT>'+;
												'<XZ5_CHANEL order="2"></XZ5_CHANEL>'+;
												'<XZ5_SEQ order="3"></XZ5_SEQ>'+;
												'<XZ5_FIELD order="4"></XZ5_FIELD>'+;
												'<XZ5_TYPFLD order="5"></XZ5_TYPFLD>'+;
												'<XZ5_EXEC order="6"></XZ5_EXEC>'+;
												'<XZ5_COND order="7"></XZ5_COND>'+;
												'<XZ5_OBS order="8"></XZ5_OBS>'+;
												'<XZ5_SOURCE order="9"></XZ5_SOURCE>'+;
											'</struct>'+;
										'</XZ5DETAIL>'+; 
							'</item>'+;
						'</items>'+;
					'</XZ2DETAIL>'+;
				'</XZ1MASTER>'+;
		'</CFGA600>'	

Return

//------------------------------------------------------------------------------
/*/{Protheus.doc} Tk260Desq

Motivo da desqualificação do Prospect

@sample 	Tk260Desq() 

@return	

@author	Thamara Villa Jacomo
@since		13/04/2015       
@version	P12
/*/
//------------------------------------------------------------------------------
Function TK260Desq(oModel, lMbrowse)

Local oDlg     := Nil
Local oPanel   := Nil
Local oSay     := Nil
Local oMemo	   := Nil
Local oSay	   := Nil
Local oMotivo  := Nil
Local oDescMot := Nil
Local cCodMot  	:= ""
Local cDescMot := Space( 30 )
Local cObsMot  	:= ""
Local cStatus		:= ""
Local cCodCli 	:= ""
Local cLojCli		:= ""

Default oModel	:= Nil
Default lMbrowse 	:= .T.


If oModel <> Nil
	cStatus 	:= oModel:GetValue( "SUSMASTER", "US_STATUS"  )
	cCodMot	:= oModel:GetValue( "SUSMASTER", "US_CODDESQ" )
	cObsMot	:= oModel:GetValue( "SUSMASTER", "US_OBSDESQ" ) 
	cCodCli 	:= oModel:GetValue( "SUSMASTER", "US_CODCLI"  )
	cLojCli	:= oModel:GetValue( "SUSMASTER", "US_LOJACLI" )
Else
	cStatus 	:= SUS->US_STATUS
	cCodMot	:= SUS->US_CODDESQ
	cObsMot	:= SUS->US_OBSDESQ 
	cCodCli 	:= SUS->US_CODCLI
	cLojCli	:= SUS->US_LOJACLI
EndIf

If cStatus == "5" .Or. oModel == Nil

	If Empty(cCodCli) .And. Empty(cLojCli)

	oDlg := FWDialogModal():New()
		oDlg:SetBackGround( .T. )
		oDlg:SetTitle( STR0076 ) // "Desqualificação de Prospect"
		oDlg:SetEscClose( .T. )
		oDlg:SetSize( 150, 300 )
		oDlg:EnableFormbar( .T. )
	
		//----------------------------------------
		// Cria a Janela
		//----------------------------------------
		oDlg:CreateDialog()
	
		//----------------------------------------
		// Cria o Painel
		//----------------------------------------
		oPanel := oDlg:GetPanelMain()
	
		oDlg:CreateFormBar()
	
		oSay := TSay():New( 10, 10, { || STR0077 }, oPanel,,,,,,.T.) //"Códido do Motivo:"
		@ 10, 55 	MSGET oMotivo VAR cCodMot SIZE 30, 10 F3 "SUN" PIXEL OF oPanel VALID  VALID ExistCpo("SUN",cCodMot)  
		
			
		oSay := TSay():New( 10, 100, { || STR0078 }, oPanel,,,,,,.T.) //"Descrição do Motivo:"
        @ 10, 155   MSGET Alltrim(POSICIONE("SUN",1,FwxFilial("SUN")+cCodMot,"UN_DESC"))   VALID {|| ,oDlg:Refresh()} SIZE 130,009  OF oPanel Pixel WHEN .F.		
	
		
		oSay := TSay():New( 30, 10, { || STR0079 }, oPanel,,,,,,.T.) //"Informe uma descrição mais detalhada:"	
		@ 40, 10 Get oMemo Var cObsMot Of oPanel VALID NAOVAZIO(cObsMot) MULTILINE SIZE 275,050 PIXEL		
					

						
		
		oDlg:AddButton( STR0080,{|| Iif(!ExistCpo("SUN",cCodMot) , "",; //"Atenção"
			            (TK260GrvDesReat( 'D', cCodMot, cObsMot, oModel, lMbrowse ) , oDlg:Deactivate()))}, STR0080, , .T., .F., .T., )//"Confirmar"	

		oDlg:AddButton( STR0099,{|| oDlg:Deactivate() }, STR0099, , .T., .F., .T., )//"Sair"

	oDlg:Activate()
		
Else
	
	Help("",1,"HELP",, STR0104 ,1) //"Esta conta foi convertida, não sera possível desqualifica-la pelo cadastro vigente."
	lRet := .F.	
	
	EndIf	
	
Else

	Help("",1,"HELP",,STR0111,1) //"Esta conta foi convertida, não sera possível desqualifica-la pelo cadastro vigente."
	lRet := .F.

		
EndIf
	
Return( lRet )


//------------------------------------------------------------------------------
/*/{Protheus.doc} Tk260Fecha

Encerrar as oportunidades abertas para o prospect

@sample 	Tk260Fecha() 

@return	

@author	    Totvs
@since		22/05/2015       
@version	P12
/*/
//------------------------------------------------------------------------------
Function Tk260Fecha()

Local oDlg    := Nil
Local oPanel  := Nil
Local oSay    := Nil
Local oMemo	:= Nil
Local oSay		:= Nil
Local oFci    := Nil
Local oComb   := Nil
Local oFecha  := Nil

Local oMotiv  := Nil

Local cFci    := Space( 06 )
Local cFecha  := Space( 06 )
Local cMotiv  := Space( 30 )
Local cComb   := ""
Local aOpcoes := {STR0081, STR0082} //"Perdido", "Suspenso"

Local lRet    := .T.

oDlg := FWDialogModal():New()
	oDlg:SetBackGround( .T. )
	oDlg:SetTitle( STR0084 ) //"Informações de Fechamento"
	oDlg:SetEscClose( .T. )
	oDlg:SetSize( 190, 280 )
	oDlg:EnableFormbar( .T. )
		
	//----------------------------------------
	// Cria a Janela
	//----------------------------------------
	oDlg:CreateDialog()
	
	//----------------------------------------
	// Cria o Painel
	//----------------------------------------
	oPanel := oDlg:GetPanelMain()
	
	oDlg:CreateFormBar()

	oSay := TSay():New( 10, 10, { || STR0085 }, oPanel,,,,,,.T.) //"F.C.I."
	@ 18,10     MSGET oFci   VAR cFci   PICTURE "@!" F3 "A6" SIZE 30,10  OF oPanel PIXEL  Valid ExistCpo("SX5","A6"+cFci)
	
	oSay := TSay():New( 10, 070, { || STR0086 }, oPanel,,,,,,.T.) //"Descrição"
    @ 18, 70   MSGET Alltrim(POSICIONE("SX5",1,XFILIAL("SX5")+"A6"+cFci,"X5_DESCRI")) VALID {|| ,oDlg:Refresh()} SIZE 190,009  OF oPanel Pixel WHEN .F.		

  	oSay := TSay():New( 35, 10, { || STR0087 }, oPanel,,,,,,.T.) //"Status"
	@ 42, 10 COMBOBOX oCbx VAR cCbx ITEMS aOpcoes SIZE 50, 10 OF oPanel PIXEL 	                   

	oSay := TSay():New( 35, 070, { || STR0088 }, oPanel,,,,,,.T.) //"Encerramento"
	@ 42, 70 	MSGET oFecha VAR cFecha PICTURE "@!"  F3 "SUN"  SIZE 30,10  OF oPanel  PIXEL VALID ExistCpo("SUN",cFecha) 	
			

	oSay := TSay():New( 60, 10, { || STR0089 }, oPanel,,,,,,.T.) //"Motivo"	
	@ 70, 10 Get oMotiv Var cMotiv Of oPanel  MULTILINE SIZE 250, 050 PIXEL		
					
	oDlg:AddButton( STR0099,{|| oDlg:Deactivate(),lRet := .F. }, STR0099, , .T., .F., .T., )//"Sair"

	oDlg:AddButton( STR0090,{|| Iif(!ExistCpo("SX5","A6"+cFci) .or. !ExistCpo("SUN",cFecha) , "",; //"Atenção" 
		               ( lRet := TK260EncAD1( cFci, cFecha, cMotiv, oCbx:nAt) , oDlg:Deactivate() ))}, STR0090, , .T., .F., .T., )//"Confirmar"	

oDlg:Activate()

Return lRet


//------------------------------------------------------------------------------
/*/{Protheus.doc} TK260DesRea

Desqualificar ou Reativar um Prospect.

@sample 	TK260DesRea() 

@param      cTipo - D-desqualificado; R-Reativado

@return	

@author	    Totvs
@since		22/05/2015       
@version	P12
/*/
//------------------------------------------------------------------------------
Function TK260DesRea( cTipo, oModel, lMbrowse )






Local lRet      := .F.
Local lContinua := .T.
Local cTexto    := ''
Local cUserL	  	:= RetCodUsr()
Local cCodigo		:= ""
Local cLoja	 	:= ""
Local cCodDesql	:= ""





Default lMbrowse := .T.
Default cTipo    := ''
Default oModel   := Nil


If oModel <> Nil
	cCodigo 	:= oModel:GetValue( "SUSMASTER", "US_COD"  )
	cLoja		:= oModel:GetValue( "SUSMASTER", "US_LOJA" )
	cCodDesql	:= oModel:GetValue( "SUSMASTER", "US_CODDESQ" ) 
Else
	cCodigo 	:= SUS->US_COD
	cLoja	 	:= SUS->US_LOJA	
	cCodDesql	:= SUS->US_CODDESQ
	EndIf

If	cTipo == 'D' //desqualificação

		DbSelectArea( "AD1" )
		AD1->( DbSetOrder( 4 ) )
	If	AD1->( DbSeek( xFilial( "AD1" ) + cCodigo + cLoja ) )
		While !Eof() .AND. (xFilial("AD1") == AD1->AD1_FILIAL) .AND. (cCodigo+cLoja == AD1->AD1_PROSPE+AD1->AD1_LOJPRO)
			If	AD1->AD1_STATUS = '1' 
					lRet := .T.




				Endif	
				DbSkip()
			End
		Endif
		

	If Empty(cCodDesql) 
		If	lRet
			If	Aviso(STR0091, STR0092, { STR0093, STR0094 }) == 1  //"Desqualificação de Prospect", "O prospect possui oportunidade(s) em aberto, ao desqualifica-lo a(s) oportunidade(s) precisará(ão) ser encerrada(s) sem sucesso. Deseja prosseguir?", { "Sim", "Não" }
		          If TK260Fecha()




					TK260Desq(oModel, lMbrowse)
					EndIf
				Endif
			Else

			TK260Desq(oModel, lMbrowse)			
			Endif
		Else
			lContinua := .F.
			cTexto    := STR0109 //"Prospect já está desqualificado." 

	EndIf

	If !lContinua
		Help("",1,"HELP",, cTexto ,1)
	EndIf
Else
	If SUS->US_STATUS == '5' 
		If	Aviso(STR0095, STR0096, { STR0097, STR0098 }) == 1 //"Reativação de Prospect", "Deseja mesmo reativar este registro?", { "Reativar", "Cancelar" }	

			TK260GrvDesReat('R',,,,lMbrowse)
		Endif
	Else
		Help("",1,"HELP",, STR0105 ,1) //"Prospect não está desqualificado." 

	EndIf			
Endif

Return( .T. )



//------------------------------------------------------------------------------
/*/{Protheus.doc} TK260EncAD1

Faz a gravação da oportunidade de venda

@sample 	TK260EncAD1() 

@param      cFci - F.C.I.
            cEncer - Fechamento da oportunidade
            cMotiv - Motivo da oportunidade
            cStatus - status da oportunidade

@return	

@author	    Totvs
@since		22/05/2015       
@version	P12
/*/
//------------------------------------------------------------------------------
Function TK260EncAD1( cFci, cEncer, cMotiv, nOpcao )
Local aArea 	  := GetArea() 

Local oModel 	 	:= Nil
Local oMdlAD1  	:= Nil
Local aError	 	:= {}
Local lRetorno 	:= .T.
Local aAD1Master	:= {}
Local aStructAD1	:= ""
Local nX			:= 0
Local uVariavel	:= Nil

Default cFci   	:= ''
Default cEncer 	:= ''
Default cMotiv 	:= ''
Default nOpcao 	:= 0

Private lMsErroAuto := .F.

BEGIN TRANSACTION

	DbSelectArea( "AD1" )
	AD1->( DbSetOrder( 4 ) )
	IF	AD1->( DbSeek( xFilial( "AD1" ) + SUS->US_COD + SUS->US_LOJA ) )

		aStructAD1 := AD1->(DbStruct())
		












		While !Eof() .AND. (xFilial("AD1") == AD1->AD1_FILIAL) .AND. (SUS->US_COD+SUS->US_LOJA == AD1->AD1_PROSPE+AD1->AD1_LOJPRO)
		

				
						  
			If	AD1->AD1_STATUS == '1'
				
				For nX := 1 To Len(aStructAD1) 
					If X3Obrigat(aStructAD1[nX][1]) .Or. aStructAD1[nX][1] $ "AD1_FCI|AD1_STATUS|AD1_ENCERR|AD1_MTVENC"
						Do Case
							Case aStructAD1[nX][1] == "AD1_FCI"
								uVariavel := cFci
							Case aStructAD1[nX][1] == "AD1_STATUS"
								uVariavel := IIF(nOpcao==1,"2","3")
							Case aStructAD1[nX][1] == "AD1_ENCERR"
								uVariavel := cEncer
							Case aStructAD1[nX][1] == "AD1_MTVENC"
								uVariavel := cMotiv
							OtherWise
								uVariavel := AD1->&(aStructAD1[nX][1])
						EndCase
						aAdd(aAD1Master,{aStructAD1[nX][1],uVariavel,Nil})
					EndIf
				Next nX				
									
				FATA300( MODEL_OPERATION_UPDATE, aAD1Master)
				aAD1Master := {}
				 
				If lMsErroAuto
					lRetorno := .F.
					DisarmTransaction()
					MostraErro()
				EndIf
			EndIf
			AD1->(DbSkip())
		End
			Endif	
	
	If !lRetorno
		DisarmTransaction()
	Endif


END TRANSACTION

RestArea( aArea )

Return( lRetorno )

//------------------------------------------------------------------------------
/*/{Protheus.doc} TK260GrvDesReat

Faz a gravaçao da desqualificacao ou reativacao de um Prospect.

@sample 	TK260GrvDesReat() 

@param      cTipo   - desqualificacao ou reativacao
            cCodMot - codigo do motivo da desqualificação
            cObsMot - obs da desqualificação

@return	

@author	    Totvs
@since		22/05/2015       
@version	P12
/*/
//------------------------------------------------------------------------------
Function TK260GrvDesReat( cTipo, cCodMot, cObsMot, oModel, lMbrowse )

Local aArea 	:= GetArea()
Local aError    := {}
Local cUserL	:= RetCodUsr()

Local oMdlSUS := Nil

Default cTipo	 := ''
Default cCodMot  := ''
Default cObsMot  := ''
Default oModel	 := Nil
Default lMbrowse := .T.

If( lMbrowse )
	oModel    := FwLoadModel('TMKA260')	 
	oModel:SetOperation(MODEL_OPERATION_UPDATE) 
	oModel:Activate()
EndIf

oMdlSUS := oModel:GetModel("SUSMASTER")	

If	cTipo == 'D' //desqualificação

	oMdlSUS:SetValue("US_CODDESQ",cCodMot)
	oMdlSUS:SetValue("US_OBSDESQ",cObsMot)
	oMdlSUS:SetValue("US_STATUS",'5')
	oMdlSUS:SetValue("US_MSBLQL",'1')
	oMdlSUS:SetValue("US_USRDESQ",cUserL)

	oMdlSUS:SetValue("US_DTREATV",Ctod(''))

	oMdlSUS:SetValue("US_DTDESQ",dDataBase)
Else

	oMdlSUS:SetValue("US_CODDESQ",'')
	oMdlSUS:SetValue("US_OBSDESQ",'')
	oMdlSUS:SetValue("US_STATUS",'1')
	oMdlSUS:SetValue("US_MSBLQL",'2')
	oMdlSUS:SetValue("US_USRDESQ",cUserL)
	oMdlSUS:SetValue("US_DTREATV",dDataBase)
	oMdlSUS:SetValue("US_DTDESQ",Ctod(''))

Endif



If lMbrowse
	If oModel:VldData()
		oModel:CommitData()
		oModel:DeActivate()
	Else
		aError := oModel:GetErrorMessage()
		Help("",1,"HELP",,aError[6],1)
	EndIf
EndIf

RestArea( aArea )
Return( .T. )

//------------------------------------------------------------------------------
/*/{Protheus.doc} TK260PermVnd

Atualiza a permissao do vendedor do prospect e oportunidade rapida

@sample 	TK260PermVnd() 

@param      

@return	

@author	    Totvs
@since		09/06/2015       
@version	P12
/*/
//------------------------------------------------------------------------------
Function TK260PermVnd(oModel)

Local aArea 	 := GetArea()
Local aAreaAO3	 := AO3->(GetArea())			// Armazena posicionamento atual do AO3
Local aAreaAO4	 := AO4->(GetArea())			// Armazena posicionamento atual do AO4
Local aAreaSUS	 := SUS->(GetArea())			// Armazena posicionamento atual do ACH
Local aAreaAD1	 := AD1->(GetArea())			// Armazena posicionamento atual do AD1

Local cChave     := ''
Local cVendAnt   := ''
Local aAutoAO4	 := {}


	IF !Empty(oModel:GetValue( "AD1MASTER", "AD1_VEND" ))
			
		If Empty(cVendAnt)
			cVendAnt := oModel:GetValue( "AD1MASTER", "AD1_VEND" )
		EndIf
			
		DbSelectArea("AO3")
		AO3->(DbSetOrder(2))	// AO3_FILIAL+AO3_VEND
			
		If 	AO3->(DbSeek(xFilial("AO3")+cVendAnt))
			
			DbSelectArea("AO4")
			AO4->(DbSetOrder(1))		// AO4_FILIAL+AO4_ENTIDA+AO4_CHVREG+AO4_CODUSR
				
			cChave := PadR(xFilial("SUS")+SUS->US_COD+SUS->US_LOJA,TAMSX3("AO4_CHVREG")[1])
								
			If !AO4->(DbSeek(xFilial("AO4")+"SUS"+cChave+AO3->AO3_CODUSR))
				aAutoAO4 := CRMA200PAut(3,"SUS",cChave,AO3->AO3_CODUSR,/*aPermissoes*/,/*aNvlEstrut*/,RetCodUsr(),/*dDataVld*/)
			Else
					
				DbSelectArea("AO3")
				AO3->(DbSetOrder(2))			// AO3_FILIAL + AO3_VEND
					
				If AO3->(DbSeek(xFilial("AO3")+cVendAnt))
						
					cUserAnt := AO3->AO3_CODUSR
						
					If AO3->AO3_VEND <> oModel:GetValue( "AD1MASTER", "AD1_VEND" )					
							
						If AO3->(DbSeek(xFilial("AO3") + oModel:GetValue( "AD1MASTER", "AD1_VEND" )))						
								
							DbSelectArea("AO4")
							AO4->(DbSetOrder(1))		// AO4_FILIAL+AO4_ENTIDA+AO4_CHVREG+AO4_CODUSR
								
							If AO4->(DbSeek(xFilial("AO4")+"SUS"+cChave+cUserAnt))
								RecLock("AO4",.F.)
								AO4->AO4_CODUSR := AO3->AO3_CODUSR
								AO4->AO4_IDESTN := AO3->AO3_IDESTN
								AO4->AO4_NVESTN := AO3->AO3_NVESTN
								AO4->(MsUnlock())
							EndIf
								
						EndIf
							
					EndIf
						
				EndIf
					
			EndIf

			If 	Len(aAutoAO4) > 0
				lRet := CRMA200Auto(aAutoAO4[1],aAutoAO4[2], 4)
				aAutoAO4 := {}
			EndIf


			//Atualiza AD1 - Oportunidad de Venda
			cChave := PadR(xFilial("AD1")+M->AD1_NROPOR+M->AD1_REVISA,TAMSX3("AO4_CHVREG")[1])
								
			If !AO4->(DbSeek(xFilial("AO4")+"AD1"+cChave+AO3->AO3_CODUSR))
				aAutoAO4 := CRMA200PAut(3,"AD1",cChave,AO3->AO3_CODUSR,/*aPermissoes*/,/*aNvlEstrut*/,RetCodUsr(),/*dDataVld*/)
			Else
					
				DbSelectArea("AO3")
				AO3->(DbSetOrder(2))			// AO3_FILIAL + AO3_VEND
					
				If AO3->(DbSeek(xFilial("AO3")+cVendAnt))
						
					cUserAnt := AO3->AO3_CODUSR
						
					If AO3->AO3_VEND <> oModel:GetValue( "AD1MASTER", "AD1_VEND" )					
							
						If AO3->(DbSeek(xFilial("AO3")+ oModel:GetValue( "AD1MASTER", "AD1_VEND" )))						
								
							DbSelectArea("AO4")
							AO4->(DbSetOrder(1))		// AO4_FILIAL+AO4_ENTIDA+AO4_CHVREG+AO4_CODUSR
								
							If AO4->(DbSeek(xFilial("AO4")+"AD1"+cChave+cUserAnt))
								RecLock("AO4",.F.)
								AO4->AO4_CODUSR := AO3->AO3_CODUSR
								AO4->AO4_IDESTN := AO3->AO3_IDESTN
								AO4->AO4_NVESTN := AO3->AO3_NVESTN
								AO4->(MsUnlock())
							EndIf
								
						EndIf
							
					EndIf
						
				EndIf
					
			EndIf

		EndIf
			
	EndIf
		
	If Len(aAutoAO4) > 0
		lRet := CRMA200Auto(aAutoAO4[1],aAutoAO4[2], 4)
	EndIf
	

RestArea(aAreaSUS)
RestArea(aAreaAO3)
RestArea(aAreaAO4)
RestArea(aAreaAD1)
RestArea(aArea)

Return .T.