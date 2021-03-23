#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} QUAA023J()==============================================================================================================================
Tela para manutencao de fretes carreteiros
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
User Function QUAA023J()

    Local oBrowse := FwLoadBrw("QUAA023J")

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

    oBrowse:SetAlias("PBJ")
    oBrowse:SetDescription(OemToAnsi("Cadastro Veículos"))
    oBrowse:AddFilter("FILIAL","PBJ_FILIAL=="+cFilAnt,.T.,.T.)
      oBrowse:AddLegend( "PBJ_STATUS == 'I'", "RED","INATIVO")
    oBrowse:AddLegend( "PBJ_STATUS == 'A'", "GREEN","ATIVO")

    oBrowse:SetMenuDef("QUAA023J")
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

    Local aRotina := FwMVCMenu("QUAA023J")

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

    Local oModel 	       := MPFormModel():New("QAA023AM")
    Local oStruPBJ 	:= FwFormStruct(1, "PBJ")
    Local oStruPBG 	:= FwFormStruct(1, "PBG")

    oModel:AddFields("PBJMASTER", NIL, oStruPBJ)
    oModel:AddGrid("PBGDETAIL","PBJMASTER",oStruPBG,,,,,/*bLoadPB9*/)
    oModel:SetRelation("PBGDETAIL", {{"PBG_FILIAL", "FwXFilial('PBG')"}, {"PBG_CODVEI", "PBJ_CODIGO"}}, PBG->(IndexKey( 1 )))



    oModel:SetPrimaryKey( { 'PBJ_FILIAL' }, {'PBJ_PLACA'})
    oModel:SetDescription(OemToAnsi("Cadastro de Veículos" ))
    oModel:GetModel("PBJMASTER"):SetDescription(OemToAnsi("Cabecalho Veículos"))
    oModel:GetModel("PBGDETAIL"):SetDescription("Documentos")
    oModel:GetModel( 'PBGDETAIL' ):SetUniqueLine( { 'PBG_CODVEI','PBG_CODTIP'})


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
    Local oStruPBJ 	:= FwFormStruct(2,"PBJ")
    Local oStruPBG 	:= FwFormStruct(2,"PBG")
    Local oModel 	:= FwLoadModel("QUAA023J")

    oView:SetModel(oModel)
    oView:AddField("VIEW_PBJ", oStruPBJ, "PBJMASTER")
    oView:AddGrid("VIEW_PBG", oStruPBG, "PBGDETAIL")

    cCSS := "QTableView { selection-background-color: #ade0ff; font-weight:bold;font-size:12px }"
    cCSS += "QHeaderView::section { background-color: qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #616161, stop: 0.5 #505050, stop: 0.6 #434343,  stop:1 #656565); color: white; padding-left: 4px; border: 1px solid #6c6c6c; }"

    oView:SetViewProperty( "VIEW_PBG", "SETCSS", {cCSS} )


    oView:CreateHorizontalBox("DADOS", 30)
    oView:CreateHorizontalBox("DOCUMENTOS", 70)

    oView:SetOwnerView("VIEW_PBJ", "DADOS")
    oView:SetOwnerView("VIEW_PBG", "DOCUMENTOS")

    oStruPBG:RemoveField( 'PBG_TIPO' )

    oView:EnableTitleView("VIEW_PBJ",OemToAnsi("Cadastro de Veículos"))


Return (oView)

Static Function FOpenx()

ShellExecute("open", FWFldGet('PBG_LOCARQ'), "", "", 1)

Return
