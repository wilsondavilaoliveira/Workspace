#Include 'Totvs.ch'
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE 'COLORS.CH'
#INCLUDE "PRCONST.CH"
#INCLUDE "FONT.CH"
#include "TBICONN.CH"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} QUAA023D()==============================================================================================================================
CADASTRO DE MOTORISTAS
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
User Function QUAA023D()

    Local oBrowse := FwLoadBrw("QUAA023D")

    oBrowse:Activate()

Return (NIL)

/*/{Protheus.doc} BrowseDef()=============================================================================================================================
Chamada mbrowse
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
Static Function BrowseDef()

    Local oBrowse := FwMBrowse():New()
    oBrowse:SetAlias("PBB")
    oBrowse:SetDescription("Cadstro Motoristas")
    oBrowse:AddFilter("FILIAL","PBB_FILIAL=="+cFilAnt,.T.,.T.)
    oBrowse:SetMenuDef("QUAA023D")
    oBrowse:AddLegend( "PBB_STATUS == 'I'", "RED","BLOQUEADO")
    oBrowse:AddLegend( "PBB_STATUS == 'A'", "GREEN","ATIVO")
    SetKey(VK_F4, {|| FOpenx()})

Return (oBrowse)

/*/{Protheus.doc} MenuDef()===============================================================================================================================
Operacao da Rotina
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
Static Function MenuDef()

    Local aRotina := FwMVCMenu("QUAA023D")

    //ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.QUAA023D' OPERATION 2 ACCESS 0
    //ADD OPTION aRotina TITLE 'Alterar' ACTION 'VIEWDEF.QUAA023D' OPERATION 4 ACCESS 0
    //ADD OPTION aRotina TITLE 'Incluir' ACTION 'VIEWDEF.QUAA023D' OPERATION 3 ACCESS 0
    //ADD OPTION aRotina TITLE 'Anexar' ACTION 'U_QUAA023H()' OPERATION 3 ACCESS 0

Return (aRotina)

/*/{Protheus.doc} ModelDef()===============================================================================================================================
Regra de Negocio
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
Static Function ModelDef()

    Local bCommit   := {||GravaLog(oModel)}
    Local oModel 	:= MPFormModel():New("QAA023DM",,,bCommit)
    Local oStruPBB 	:= FwFormStruct(1, "PBB")
    Local oStruPBG 	:= FwFormStruct(1, "PBG")

    //MPFORMMODEL():New(<cID >, <bPre >, <bPost >, <bCommit >, <bCancel >)
    //Local bPre  := { |oModelGrid, nLine,cAction, cField| U_QU23HARQ(oModelGrid, nLine, cAction, cField) }
        //AddGrid([ cId ], [ cOwner ], [ oModelStruct ], [ bLinePre ], [ bLinePost ], [ bPre ], [ bPost ], [ bLoad ])
    oModel:AddFields("PBBMASTER", NIL, oStruPBB)
    oModel:AddGrid("PBGDETAIL","PBBMASTER",oStruPBG,,,,,/*bLoadPB9*/)

    oModel:SetRelation("PBGDETAIL", {{"PBG_FILIAL", "FwXFilial('PBG')"}, {"PBG_CODMOT", "PBB_CODIGO"}}, PBG->(IndexKey( 1 )))

    oModel:SetPrimaryKey( { 'PBB_FILIAL' }, {'PBB_CODIGO'})
    oModel:SetDescription("Cadastro Motorista" )

    oModel:GetModel( 'PBGDETAIL' ):SetUniqueLine( { 'PBG_CODMOT','PBG_CODTIP'})

    oModel:GetModel("PBBMASTER"):SetDescription("Dados Motorista")
    oModel:GetModel("PBGDETAIL"):SetDescription("Documentos")


Return (oModel)

/*/{Protheus.doc} ViewDef()===============================================================================================================================
Interface Grafica
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
Static Function ViewDef()

    Local oView 	:= FwFormView():New()
    Local oStruPBB 	:= FwFormStruct(2,"PBB")
    Local oStruPBG 	:= FwFormStruct(2,"PBG")
    Local oModel 	:= FwLoadModel("QUAA023D")

    oView:SetModel(oModel)

    oView:AddField("VIEW_PBB", oStruPBB, "PBBMASTER")
    oView:AddGrid("VIEW_PBG", oStruPBG, "PBGDETAIL")

    oView:CreateHorizontalBox("DADOS", 50)
    oView:CreateHorizontalBox("DOCUMENTOS", 50)
    //oView:CreateHorizontalBox("KMS", 25)
    //oView:CreateHorizontalBox("BONIFICACAO", 22)

    oView:SetOwnerView("VIEW_PBB", "DADOS")
    oView:SetOwnerView("VIEW_PBG", "DOCUMENTOS")

    oStruPBG:RemoveField( 'PBG_TIPO' )

    //View:AddIncrementField("VIEW_PB9", "PB9_DATA")
    //oView:SetViewProperty( 'VIEW_PB9', "CHANGELINE", {{ |oView, cViewID| MsgAlert("teste") }} )
    //oView:EnableTitleView("VIEW_PA4","ITENS VOMUME PRODUTOR")
    //oView:EnableTitleView("VIEW_ZA1","ITENS KMS CARRETEIRO")
    //oView:EnableTitleView("VIEW_LJW","ITENS BONIFICACAO CARRETEIRO")

Return (oView)
/*/{Protheus.doc} QU23HARQ
anexar documento consulta padrao PBG
@type function
@version
@author wilso
@since 16/11/2020
@return return_type, return_description
/*/
User Function QU23HARQ()

    Public cFileNom  := ''

    cFileNom  := cGetFile( "Arquivo PDF *.PDF | *.PDF", "Arquivo .PDF...",0,FWFldGet('PBG_LOCARQ'),.F., GETF_LOCALHARD,.F.)
    FWFldPut('PBG_LOCARQ',cFileNom)

Return .T.


Static Function FOpenx()

ShellExecute("open", FWFldGet('PBG_LOCARQ'), "", "", 1)

Return

/*/{Protheus.doc} GravaLog
GRAVA LOG DE BLOQUEIO
@type function
@version
@author wilso
@since 16/11/2020
@param oModel, object, param_description
@return return_type, return_description
/*/
Static Function GravaLog(oModel)

Local cDesc := ''
Local nOperation := oModel:GetOperation()
Local lRet := .T.
Local aDados        := {}
Local lBlock        := .T.

If nOperation == MODEL_OPERATION_UPDATE

    cDesc += DTOC(dDataBase)+"-"+Time()+"->REGISTRO " + IiF(PBB->PBB_STATUS=='A','*BLOQUEADO*','*DESBLOQUEADO*') + " PELO USUARIO: " + Alltrim(UsrRetName(__cUserId)) + CRLF
    cDesc += "MOTIVO: "

    If FWFLDGET("PBB_STATUS") <> PBB->PBB_STATUS
    cDesc += U_QUAA023I("MOTORISTA: "+ PBB->PBB_CODIGO+"-"+PBB->PBB_NOME,IiF(PBB->PBB_STATUS=='A','BLOQUEIO','DESBLOQUEIO'))
    EndIf

    lBlock := IiF(PBB->PBB_STATUS=='A',.T.,.F.)

    lRet := FWFormCommit(oModel)

    If lRet
        RecLock("PBB",.F.)
        PBB->PBB_LOG := PBB->PBB_LOG + CRLF + cDesc + CRLF + "====================================================================="
        MsUnlock()
    EndIf

    If PBK->(dbSeek(cFilAnt+'03'))

        cBlok   := IiF(lBlock,'BLOQUEADO','DESBLOQUEADO')
        cBlok1   := IiF(lBlock,'BLOQUEIO','DESBLOQUEIO')

        cMail   := Alltrim(PBK->PBK_EMAILD)
        cCorpo := cDesc

        If lBlock
            cAssun  := "Motorista Bloqueado Manualmente"
        Else
            cAssun := "Motorista Desbloqueado Manualmente"
        EndIf

        AADD(aDados,{ PBB->PBB_CODIGO,PBB->PBB_NOME})

        WFMail3(aDados,cMail,cAssun,cCorpo,cBlok,cBlok1)

    EndIf

Else
    lRet := FWFormCommit(oModel)
EndIf

Return lRet

/*/{Protheus.doc} WFMail4
WORKFLOW BLOQUEIO/DESBLOQUEIO DE TRANSPORTADORA
@type function
@version
@author Wilson Davila
@since 04/12/2020
@param aDados, array, param_description
@return return_type, return_description
/*/
Static Function WFMail3(aDados,cMail,cAssun,cCorpo,cBlok,cBLock1)

Local lRet		:= .T.
Local oProcWF   := Nil
Local cMailAdm  := '' //SuperGetMv('ES_QUAA081',.F.,'') // e-mails
Local cTo		:= cMail //'wilson.oliveira@wdonet.com.br'


	cMailAdm  := ''
	oProcWF := TWFProcess():New("QA23F3","Aviso Motorista " + cBlok )
	oProcWF:NewTask("QA23F3","\workflow\QUAA023WF_003.html",.T.)
	oProcWF:cSubject := OemToAnsi(cAssun)

   	// Cabecalho

	oProcWF:oHTML:ValByName("cTitulo"    ,"AVISO " + cBlock1 + " MOTORISTA")
    oProcWF:oHTML:ValByName("cCorpo"    ,cCorpo )
    oProcWF:oHTML:ValByName("dthoje"    ,dtoc(dDataBase ))

    For i := 1 to Len(aDados)
        AAdd(oProcWF:oHTML:ValByName("it.cCodMot")  ,aDados[i][1] )
	    AAdd(oProcWF:oHTML:ValByName("it.cNome")	,aDados[i][2] )
	Next i

	// Adiciona e-mail
	oProcWF:cTo := cTo

	oProcWF:Start()
	WFSendMail()
	oProcWF:Finish()
	oProcWF := FreeObj(oProcWF)

Return lRet
