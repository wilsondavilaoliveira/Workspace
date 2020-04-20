#include "PROTHEUS.CH"
#include "RWMAKE.CH"
#include "FWMVCDEF.CH"
#include "FWMBROWSE.CH"
#include "TBICONN.CH"
#include "TOPCONN.CH"
#include "FILEIO.CH"
#Include 'Totvs.ch' 
#INCLUDE 'COLORS.CH'
#INCLUDE "PRCONST.CH"
#INCLUDE "FONT.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} AXFORMDEV
Controle de formulario de autorizacao de devolucao enviados pelo Tablet AFV
@author Wilson Oliveira
@since 06/01/2020
@version 1.0
@param                                    
@type          
/*/
//-------------------------------------------------------------------
User Function AXFORMDEV

Local oBrowse := FwLoadBrw("AXFORMDEV")

oBrowse:Activate()
Return

//----------------------------------------------------------
// Função MenuDef
//----------------------------------------------------------

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' 	ACTION 'VIEWDEF.AXFORMDEV' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Envia E-mail'	ACTION 'U_xBdAfv()' OPERATION 2  ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.AXFORMDEV' OPERATION 4 ACCESS 0
//ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.AXFORMDEV' OPERATION 5 ACCESS 0
//ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.AXFORMDEV' OPERATION 8 ACCESS 0
//ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.AXFORMDEV' OPERATION 9 ACCESS 0

Return aRotina


Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("ZXO")
    oBrowse:SetDescription("Formulario Devolucoes")

   oBrowse:SetMenuDef("AXFORMDEV")
   oBrowse:AddLegend("ZXO->ZXO_STATUS=='1'","RED","Bloqueado")
   oBrowse:AddLegend("ZXO->ZXO_STATUS=='2'","GREEN","Liberado")
   oBrowse:SetAmbiente(.F.)        //Desabilita opcao Ambiente do menu Acoes Relacionadas
   oBrowse:SetWalkThru(.F.)        //Desabilita opcao WalkThru do menu Acoes Relacionadas
   
Return (oBrowse)

//----------------------------------------------------------
// Função ModelDef
//----------------------------------------------------------
Static Function ModelDef()

 Local oModel := MPFormModel():New("FORMDVM")

    // INSTANCIA OS SUBMODELOS
    Local oStruZXO := FwFormStruct(1, "ZXO")
    Local oStruZXQ := FwFormStruct(1, "ZXQ")

    // DEFINE SE OS SUBMODELOS SERÃO FIELD OU GRID
    oModel:AddFields("ZXOMASTER", NIL, oStruZXO)
    oModel:AddGrid("ZXQDETAIL", "ZXOMASTER", oStruZXQ)

    // Chave Primaria
    oModel:SetPrimaryKey( {'ZXO_NUMDEV'} )
    
    // DEFINE A RELACAO ENTRE OS SUBMODELOS
    oModel:SetRelation("ZXQDETAIL", {{"ZXQ_NUMDEV", "ZXO_NUMDEV"}}, ZXQ->(IndexKey( 1 )))

    // DESCRICAO DO MODELO
    oModel:SetDescription("Modelo Formulario Devolucao" )

    // DESCRICAO DOS SUBMODELOS
    oModel:GetModel("ZXOMASTER"):SetDescription("Cebecalho Formulario Devolucao")
    oModel:GetModel("ZXQDETAIL"):SetDescription("Itens Formulario Devolucao")

Return oModel

//----------------------------------------------------------
// Função ViewDef
//----------------------------------------------------------
Static Function ViewDef()

  // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // INSTANCIA AS SUBVIEWS
    Local oStruZXO := FwFormStruct(2, "ZXO")
    Local oStruZXQ := FwFormStruct(2, "ZXQ")

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("AXFORMDEV")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_ZXO", oStruZXO, "MPFormModel")
    oView:AddGrid("VIEW_ZXQ", oStruZXQ, "ZXQDETAIL")

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("SUPERIOR", 40)
    oView:CreateHorizontalBox("INFERIOR", 60)

    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VIEW_ZXO", "SUPERIOR")
    oView:SetOwnerView("VIEW_ZXQ", "INFERIOR")

    // DEFINE OS TITULOS DAS SUBVIEWS
    oView:EnableTitleView("VIEW_ZXO","CABECALHO DEVOLUCOES")
    oView:EnableTitleView("VIEW_ZXQ","ITENS DEVOLUCOES")

Return oView



User Function WfForDev(cNumDev)

Local lRet		:= .T.
Local oProcWF   := Nil
Local cMailAdm  := '' //SuperGetMv('ES_QUAA081',.F.,'') // e-mails
Local cTo		:= 'wilson.oliveira@wdonet.com.br;tatiana.carneiro@quataalimentos.com.br'
Local cAliasA1  := GetNextAlias()

//-- QUERY
BeginSql alias cAliasA1
	%noparser%
	
	SELECT ZXO_NUMDEV,ZXO_DATA,ZXO_CODCLI+'-'+
	(SELECT A1_NOME FROM %table:SA1% SA1 WHERE A1_COD+'.'+A1_LOJA=ZXO_CODCLI AND SA1.%notDel%) AS CLIENTE,
	ZXO_CODREP+'-'+(SELECT A3_NOME FROM %table:SA3% SA3 WHERE A3_COD=ZXO_CODREP AND SA3.%notDel%) AS REPRE,
	ZXO_OBSERV,ZXQ_CODPRO+'-'+(SELECT B1_DESC FROM %table:SB1% SB1 WHERE B1_COD=ZXQ_CODPRO AND SB1.%notDel%) AS ZXQ_CODPRO,
	ZXQ_QTD,ZXQ_VALOR,LTRIM(RTRIM(STR(ZXQ_CODMOT)+'-'+(SELECT X5_DESCRI FROM %table:SX5% SX5 WHERE X5_TABELA='ZG' AND SX5.%notDel%
	AND X5_CHAVE=ZXQ_CODMOT))) AS ZXQ_CODMOT,ZXQ_LOTE,ZXQ_OBSERV 
	FROM %table:ZXQ% ZXQ 
	INNER JOIN %table:ZXO% ZXO ON ZXO_NUMDEV=ZXQ_NUMDEV AND ZXO.%notDel%
	WHERE ZXQ.%notDel% AND ZXQ_NUMDEV=%exp:cNumDev%
	

EndSql	

	
	cMailAdm  := ''//SuperGetMv('ES_QUAA081',.F.,'') // e-mails
	
	oProcWF := TWFProcess():New("FORDEV","Formulario Devolucoes")
	oProcWF:NewTask("FORDEV","\workflow\WFFormularioDev.html",.T.)
	oProcWF:cSubject := 'Formulario de Devolucoes: '
	

	// E-Mail ADM
	If ! Empty(cMailAdm)
		If ! Empty(cTo)
			cTo += ';'
		EndIf
		cTo += cMailAdm
	EndIf

If (cAliasA1)->(!EOF())

	// Cabecalho
	oProcWF:oHTML:ValByName("cNumCtr"	,AllTrim((cAliasA1)->ZXO_NUMDEV))
	oProcWF:oHTML:ValByName("dDtDev"	,stod((cAliasA1)->ZXO_DATA))
	oProcWF:oHTML:ValByName("cCliente"	,AllTrim((cAliasA1)->CLIENTE))
	oProcWF:oHTML:ValByName("cRepre"	,AllTrim((cAliasA1)->REPRE))
	oProcWF:oHTML:ValByName("cObs"		,AllTrim((cAliasA1)->ZXO_OBSERV))


	// Itens
	nTotDe 		:= 0
	nTotPara 	:= 0 
	
	Do While (cAliasA1)->(! Eof())
	
	    AAdd(oProcWF:oHTML:ValByName("it.cProd")	, AllTrim((cAliasA1)->ZXQ_CODPRO))
	    AAdd(oProcWF:oHTML:ValByName("it.Qtd")		, Transform((cAliasA1)->ZXQ_QTD,"@E 99,999.99"))
	    AAdd(oProcWF:oHTML:ValByName("it.Valor")	, Transform((cAliasA1)->ZXQ_VALOR,"@E 99,999.99"))
	    AAdd(oProcWF:oHTML:ValByName("it.Motivo")	, AllTrim((cAliasA1)->ZXQ_CODMOT))
	    AAdd(oProcWF:oHTML:ValByName("it.Lote")		, AllTrim((cAliasA1)->ZXQ_LOTE))
	    AAdd(oProcWF:oHTML:ValByName("it.Obs")		, AllTrim((cAliasA1)->ZXQ_OBSERV))
	
	   	(cAliasA1)->(dbSkip())
	EndDo
	
End If	
	
	// Adiciona e-mail
	oProcWF:cTo := cTo

	oProcWF:Start()
	WFSendMail()
	oProcWF:Finish()
	oProcWF := FreeObj(oProcWF)
	MsgAlert("Email enviado")
	//RpcClearEnv()

Return lRet


User Function xBdAfv()

Local cQuery := ''



cQuery := "SELECT TOP 1 OBSERVACAO AS OBS FROM [192.168.20.10].AFVServer_20180730.dbo.TESP_DEVOLUCAO"


If Select( "BDAFV" ) > 0
	BDAFV->( dbCloseArea() )
EndIf

	dbUseArea( .T., "TOPCONN", TCGenQry( ,,cQuery ), "BDAFV", .F., .F. )
	BDAFV->( dbGoTop() )

	While BDAFV->(!Eof())
		MsgAlert(BDAFV->(OBS))
		BDAFV->(dbSkip())
	EndDo


Return


