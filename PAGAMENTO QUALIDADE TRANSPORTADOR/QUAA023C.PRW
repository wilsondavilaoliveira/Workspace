#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"
//CAD. TP BONIF.
/*/{Protheus.doc} QUAA023C()==============================================================================================================================
@CADASTRO TIPO BONIFICACAO,INTENS DE VERIFICAÇÃO E RANGE DE % E VALORES
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
User Function QUAA023C()

    Local oBrowse := FwLoadBrw("QUAA023C")
    XDESCPBH()
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

    oBrowse:SetAlias("PBA")
    oBrowse:SetDescription("Cabecalho Tp.Bonif. Transp.")
    oBrowse:AddFilter("FILIAL","PBA_FILIAL=="+cFilAnt,.T.,.T.)
    oBrowse:SetMenuDef("QUAA023C")

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

    Local aRotina := {} //FwMVCMenu("QUAA023C")

    ADD OPTION aRotina TITLE 'Incluir'      ACTION 'U_ALTQA23(3)'       OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'      ACTION 'U_ALTQA23(4)'       OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'      ACTION 'VIEWDEF.QUAA023C'   OPERATION 5 ACCESS 0

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

    Local oModel 	:= MPFormModel():New("QAA023CM",/*<bPre >*/,/*<bPost >*/, /*<bCommit >*/,/* <bCancel >*/)
    Local oStruPBA 	:= FwFormStruct(1, "PBA")
    Local oStruPBD 	:= FwFormStruct(1, "PBD")
    Local oStruPBH 	:= FwFormStruct(1, "PBH")
    Local bPost  := { |oModelGrid, nLine,cAction, cField| LinOk(oModelGrid, nLine, cAction, cField) }


    oModel:AddFields("PBAMASTER", NIL, oStruPBA)
    oModel:AddGrid("PBDDETAIL","PBAMASTER",oStruPBD,,,,bPost,/*bLoad*/)
    //AddGrid([ cId ], [ cOwner ], [ oModelStruct ], [ bLinePre ], [ bLinePost ], [ bPre ], [ bPost ], [ bLoad ])
    oModel:AddGrid("PBHDETAIL","PBDDETAIL",oStruPBH,,,,,)

    oModel:SetRelation("PBDDETAIL", {{"PBD_FILIAL", "xFilial('PBD')"}, {"PBD_CODTIP", "PBA_CODIGO"}}, PBD->(IndexKey( 1 )))

    oModel:SetRelation("PBHDETAIL", {{"PBH_FILIAL", "xFilial('PBH')"}, {"PBH_CODIGO", "PBD_CODTIP"},{"PBH_CODITE", "PBD_CODIGO"}}, PBH->(IndexKey( 1 )))

    oModel:SetPrimaryKey( { 'PBA_FILIAL','PBA_CODIGO'})

    oModel:SetDescription("Tp. Bonif. Transportador" )

    oModel:GetModel("PBAMASTER"):SetDescription("Tp. Bonif. Transportador")
    oModel:GetModel("PBDDETAIL"):SetDescription("Itens Bonificacoes")
    oModel:GetModel("PBHDETAIL"):SetDescription("Range Faixa de pagamento")

Return (oModel)


Static Function LinOk( oModelGrid, nLinha, cAcao, cCampo )

  Local lRet        := .T.
  Local oModel      := oModelGrid:GetModel()
  Local nOperation  := oModel:GetOperation()

  Local cTpApon      := ''
  Local cTipDoc      := ''

  For i := 1 To oModel:GetModel('PBDDETAIL'):Length()

      oModel:GetModel('PBDDETAIL'):GoLine(i)

      cTpApon      := oModel:GetValue( 'PBDDETAIL', 'PBD_TPAPOM' )
      cTipDoc      := oModel:GetValue( 'PBDDETAIL', 'PBD_TIPDOC' )

      If cTpApon == 'D'

        If Empty(cTipDoc)
           Help( ,, 'Help',, 'Para o tipo de bonificação *DOCUMENTACAO*,' + CRLF +;
           'o campo Tipo de Documento deve ser preenchido com o *Cod.Tipo.Doc* !' + CRLF +;
           'LINHA-> ' + cValToChar(i), 1, 0 )
            lRet := .F.
        EndIf

      EndIf

  Next i

Return lRet


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
    Local oStruPBA 	:= FwFormStruct(2,"PBA")
    Local oStruPBD 	:= FwFormStruct(2,"PBD")
    Local oStruPBH 	:= FwFormStruct(2,"PBH")

    Local oModel 	:= FwLoadModel("QUAA023C")
    Local bKeyF4    := SetKey( VK_F4 , Nil )
    SetKey( VK_F4 , { || CopyRange(oView,oModel) } )


    oView:SetModel(oModel)

    oView:AddField("VIEW_PBA", oStruPBA, "PBAMASTER")

    //AddGrid([ cId ], [ cOwner ], [ oModelStruct ], [ bLinePre ], [ bLinePost ], [ bPre ], [ bPost ], [ bLoad ])
    oView:AddGrid("VIEW_PBD", oStruPBD, "PBDDETAIL",,,,)
    oView:AddGrid("VIEW_PBH", oStruPBH, "PBHDETAIL")
    oView:AddUserButton( 'COPIAR RANGES', 'CLIPS', {|oView| CopyRange(oView,oModel) } )

    cCSS := "QTableView { selection-background-color: #ade0ff; font-weight:bold;font-size:12px }"
    cCSS += "QHeaderView::section { background-color: qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #616161, stop: 0.5 #505050, stop: 0.6 #434343,  stop:1 #656565); color: white; padding-left: 4px; border: 1px solid #6c6c6c; }"

    oView:SetViewProperty( "VIEW_PBD", "SETCSS", {cCSS} )
    oView:SetViewProperty( "VIEW_PBH", "SETCSS", {cCSS} )

    oView:CreateHorizontalBox("SUPERIOR", 15)
    oView:CreateHorizontalBox("ITENS", 40)
    oView:CreateHorizontalBox("RANGE", 45)

    oStruPBD:RemoveField("PBD_CODTIP")
    oStruPBH:RemoveField("PBH_CODIGO")
    oStruPBH:RemoveField("PBH_CODITE")

    oView:SetOwnerView("VIEW_PBA", "SUPERIOR")
    oView:SetOwnerView("VIEW_PBD", "ITENS")
    oView:SetOwnerView("VIEW_PBH", "RANGE")

    oView:AddIncrementField("VIEW_PBD", "PBD_CODIGO")
    oView:AddIncrementField("VIEW_PBH", "PBH_ITEM")
    oView:EnableTitleView("VIEW_PBA",OemToAnsi("Tipo bonificação"))
    oView:EnableTitleView("VIEW_PBD",OemToAnsi("Itens de verificação"))
    oView:EnableTitleView("VIEW_PBH",OemToAnsi("Range de % e valores"))


Return (oView)


/*/{Protheus.doc} UpdPBH
Carrega valores na grid de range caso nao existem (somente na alteracao)
@type function
@version
@author Wilson Davila
@since 11/11/2020
@return return_type, return_description
/*/
Static Function UpdPBH()

Local cAlias    := GetNextAlias()
Local cCodTipo  := iiF(INCLUI,M->PBA_CODIGO,PBA->PBA_CODIGO)

BeginSql alias cAlias

    SELECT ISNULL(PBH_CODITE,'INC') AS PBH_CODITE,PBD_CODIGO
    FROM %Table:PBD% PBD
    LEFT JOIN %Table:PBH% PBH ON PBD_FILIAL=PBH_FILIAL AND PBD_CODTIP=PBH_CODIGO AND PBD_CODIGO=PBH_CODITE AND PBH.%NOTDEL%
    WHERE PBD_FILIAL = %Exp:cFilAnt% AND PBD_CODTIP=%Exp:cCodTipo% AND PBD.%NOTDEL% AND ISNULL(PBH_CODITE,'INC')='INC'


EndSql

While (cAlias)->( !Eof() )

    RecLock("PBH",.T.)
        PBH->PBH_FILIAL := cFilAnt
        PBH->PBH_VINIC  := 0
        PBH->PBH_VFINAL := 0
        PBH->PBH_VRESUL := 0
        PBH->PBH_ITEM   := '001'
        PBH->PBH_CODIGO := cCodTipo
        PBH->PBH_CODITE := (cAlias)->(PBD_CODIGO)
    MsUnlock()

(cAlias)->(dbSkip())

EndDo

Return .T.

/*/{Protheus.doc} ALTQA23
Funcoes para inclusao e alteracao
@type function
@version
@author Wilson Davila
@since 11/11/2020
@param nOpc, numeric, param_description
@return return_type, return_description
/*/
User Function ALTQA23(nOpc)

   IF nOpc == 3
    FWExecView("Incluir", "QUAA023C",nOpc,, {||.T.})
   Else
    UpdPBH()
    FWExecView("Alterar", "QUAA023C",nOpc,, {||.T.})
   EndIf

Return
/*/{Protheus.doc} xCpoPBH
Inicializador padrao campo PBH_CODITE
@type function
@version
@author Wilson Davila
@since 11/11/2020
@return return_type, return_description
/*/
User Function xCpoPBH()

Local oModel    := FWModelActive()
Local oModelPBD := oModel:GetModel('PBDDETAIL')
Local oModelPBH := oModel:GetModel('PBHDETAIL')

Local cRet := ''

//FOR nI := 1 TO oModelPBD:Length()
//     oModelB:GoLine(nI)
//     IF !oModelB:IsDeleted() // Linha não deletada
//          cValor := oModelB:GetValue("NOME_CAMPO_DIC") // Pegar um valor do GRID
//          oModelB:SetValue("NOME_CAMPO_DIC", "VALOR") // Grava um valor no GRID
//     ENDIF
//NEXT nI


If !PBA->PBA_CODIGO $ '03|04'
    cRet := StrZero(oModelPBD:Length(),3)
Else
    cRet := '001'
EndIf


Return cRet


User Function PbdTipDoc()

Local lRet := .T.

IF FWFLDGET("PBD_TPAPOM") <> 'D'
    lRet := .F.
    Help( ,, 'Help',, 'Para esse tipo de bonificacao nao e necessario codigo!', 1, 0 )
    Return lRet
EndIf

If POSICIONE("PBI",1,XFILIAL("PBI")+FWFLDGET("PBD_TIPDOC"),"PBI_TIPO")<>FWFLDGET("PBD_TIPO")
    lRet := .F.
    Help( ,, 'Help',, 'Codigo invalido para esse tipo de bonificacao!', 1, 0 )
EndIf

Return lRet

User Function XDESCPBH()

Local cRet := ''
Local oModel := FwModelActive()
Local cCampo := oModel:GetModel("PBDDETAIL"):GetValue('PBD_TPAPOM')

    If cCampo == 'A'
        cRet := 'APONT. SIMPLES, CONFORME OU NAO CONFOME, O SISTEMA CONTA O % DE ITENS EM CONFORMIDADE E PAGA PELO %'
    ElseIf cCampo == 'M'
        cRet := 'APONT. MULTIPLO, O SISTEMA CONTA O NUMERO DE ITENS EM *NAO CONFORMIDADE* E PAGA P/NUMERO DE ITENS'
    ELseIf cCampo == 'P'
        cRet := 'APONT. PONTOS,CONFORME OU NAO CONFOME,O SISTEMA SOMA OS PONTOS P/PESO DIVIDE P/FREQUENCIA COLETA MES'
    Else
        cRet := 'DOCUMENTACAO, O SISTEMA CONTA CADA DOC. EM CONFORMIDADE C/ SEUS PESOS E PAGA PELA SOMA DE PONTUACAO'
    EndIf

Return cRet

Static Function XDESCPBH()

Local cRet := ''

PBH->( dbGoTop() )

While PBH->( !Eof())

    aArea := GetArea()

    PBD->(dbSetOrder(4))

    If PBD->(dbSeek(PBH->(PBH_FILIAL)+PBH->(PBH_CODITE)+PBH->(PBH_CODIGO)))
        If PBD->(PBD_TPAPOM) == 'A'
            cRet := 'APONT. SIMPLES, CONFORME OU NAO CONFOME, O SISTEMA CONTA O % DE ITENS EM CONFORMIDADE E PAGA PELO %'
        ElseIf PBD->(PBD_TPAPOM) == 'M'
            cRet := 'APONT. MULTIPLO, O SISTEMA CONTA O NUMERO DE ITENS EM *NAO CONFORMIDADE* E PAGA P/NUMERO DE ITENS'
        ELseIf PBD->(PBD_TPAPOM) == 'P'
            cRet := 'APONT. PONTOS,CONFORME OU NAO CONFOME,O SISTEMA SOMA OS PONTOS P/PESO DIVIDE P/FREQUENCIA COLETA MES'
        Else
            cRet := 'DOCUMENTACAO, O SISTEMA CONTA CADA DOC. EM CONFORMIDADE C/ SEUS PESOS E PAGA PELA SOMA DE PONTUACAO'
        EndIf

        PBH->( RecLock("PBH",.F.) )
            PBH->PBH_DESCRI := cRet
        PBH->( MsUnlock() )
    EndIf

    PBH->( dbSkip() )

EndDo

Return cRet


Static Function CopyRange(oView,oModel)

FwFormCommit(oModel)

If !PBA->PBA_CODIGO $ '03|04'
    MsgStop(OemToAnsi("Ação não permitida para esse tipo de bonificação!"))
    Return
Else

    If MsgYesNo("Deseja copiar os ranges da primeira linha para todas as bonificações")
        TcSqlExec("DELETE " + RetSqlName("PBH") + " WHERE PBH_FILIAL='" + cFilAnt + "' AND PBH_CODITE<>'001' AND PBH_CODIGO='" + PBA->PBA_CODIGO+"'")

        PBD->(dbSetOrder(1))
        If PBD->( DbSeek(cFilAnt+PBA->PBA_CODIGO+'002') )

            While PBD->(PBD_FILIAL+PBD_CODTIP) == cFilAnt+PBA->PBA_CODIGO
                aAreaPDB := PBD->(GetArea())

                PBH->(dbSetOrder(1))
                    If PBH->( DbSeek(cFilAnt+PBA->PBA_CODIGO+'001'+'001' ) )

                        While PBH->(PBH_FILIAL+PBH_CODIGO+PBH_CODITE) == cFilAnt+PBA->PBA_CODIGO+'001'
                            VINIC    := PBH->(PBH_VINIC)
                            VFINAL   := PBH->(PBH_VFINAL)
                            VRESUL   := PBH->(PBH_VRESUL)
                            ITEM     := PBH->(PBH_ITEM)
                            DESCRI   := PBH->(PBH_DESCRI)

                            aArea := PBH->(GetArea())
                            RecLock("PBH",.T.)
                                PBH->PBH_FILIAL := cFilAnt
                                PBH->PBH_VINIC  := VINIC
                                PBH->PBH_VFINAL := VFINAL
                                PBH->PBH_VRESUL := VRESUL
                                PBH->PBH_ITEM   := ITEM
                                PBH->PBH_CODIGO := PBA->PBA_CODIGO
                                PBH->PBH_CODITE := PBD->(PBD_CODIGO)
                                PBH->PBH_DESCRI := DESCRI
                            MsUnlock()

                            PBH->(RestArea(aArea))

                            PBH->( dbSkip() )
                        EndDo
                    EndIf
                PBD->(RestArea(aAreaPDB))
                PBD->( dbSkip())

            EndDo
        EndIf

    MsgAlert("Copia efetuada!")

    oModel:DeActivate()
    oModel:Activate()
    oView:Refresh('PBDDETAIL')
    oView:Refresh('PBHDETAIL')

    EndIf
EndIf


Return
