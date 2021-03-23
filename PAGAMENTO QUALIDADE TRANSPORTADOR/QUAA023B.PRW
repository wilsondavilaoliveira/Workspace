#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} QUAA023B()==============================================================================================================================
TELA PARA LANÇAMENTO DE KMS POR TRANPORTADOR POR LINHA
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
User Function QUAA023B()

    Local oBrowse := ""

    If Pergunte("QUAA023B")
        oBrowse := FwLoadBrw("QUAA023B")
        oBrowse:Activate()
    EndIf

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
    INCLUI := .T.
    oBrowse:SetAlias("PB8")
    oBrowse:SetDescription("Cabecalho Fretes")
    oBrowse:AddFilter("FILIAL","PB8_FILIAL=="+cFilAnt+" .AND. PB8_PERIOD=="+MV_PAR01,.T.,.T.)
    oBrowse:SetMenuDef("QUAA023B")

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

    Local aRotina := {} //FwMVCMenu("QUAA023B")

    ADD OPTION aRotina TITLE 'Incluir' ACTION 'VIEWDEF.QUAA023B' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar' ACTION 'VIEWDEF.QUAA023B' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir' ACTION 'VIEWDEF.QUAA023B' OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Imprimir Conferencia' ACTION 'U_ExcelQA23()' OPERATION 5 ACCESS 0



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

    //Local oModel   := MPFormModel():New("QAA023BM",{ | oModel | xCpoPB9( oModel ) },)
    Local oModel   := MPFormModel():New("QAA023BM")
    Local oStruPB8 := FwFormStruct(1, "PB8")
    Local oStruPB9 := FwFormStruct(1, "PB9")

    oModel:AddFields("PB8MASTER", NIL, oStruPB8)

    //AddGrid([ cId ], [ cOwner ], [ oModelStruct ], [ bLinePre ], [ bLinePost ], [ bPre ], [ bPost ], [ bLoad ])
    oModel:AddGrid("PB9DETAIL","PB8MASTER",oStruPB9,,,,,)

    oModel:AddCalc( 'PB8CALC', 'PB8MASTER', 'PB9DETAIL', 'PB9_TOTKM', 'AUX_TOTKM', 'SUM', {|| .T.}, {|| 0},'Total KM' )

    oModel:SetRelation("PB9DETAIL", {{"PB9_FILIAL", "FwXFilial('PB9')"}, {"PB9_CODTRA", "PB8_CODTRA"},{"PB9_PERIOD", "PB8_PERIOD"}}, PB9->(IndexKey( 1 )))
    oModel:SetPrimaryKey( { 'PB8_FILIAL' }, {'PB8_CODTRA'},{'PB8_PERIOD'})

    oModel:SetDescription("Lancamentos de Frete Carreteiro" )

    oModel:GetModel("PB8MASTER"):SetDescription("Cabecalho KM Fretes")
    oModel:GetModel("PB9DETAIL"):SetDescription("Itens KM Fretes")

Return (oModel)

Static Function mens()
    MsgAlert("Linha Duplicada")
Return .F.

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
    Local oModel    := ModelDef()
    Local oStruPB8 	:= FwFormStruct(2,"PB8")
    Local oStruPB9 	:= FwFormStruct(2,"PB9")
    Local oStruAUX  := FwCalcStruct(oModel:GetModel("PB8CALC"))
    Local oModel 	:= FwLoadModel("QUAA023B")

    oView:SetModel(oModel)

    oView:AddField("VIEW_PB8", oStruPB8, "PB8MASTER")
    oView:AddField("VIEW_AUX", oStruAUX, "PB8CALC")
    oView:AddGrid("VIEW_PB9", oStruPB9, "PB9DETAIL",,,,)

    cCSS := "QTableView { selection-background-color: #ade0ff; font-weight:bold;font-size:12px }"
    cCSS += "QHeaderView::section { background-color: qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #616161, stop: 0.5 #505050, stop: 0.6 #434343,  stop:1 #656565); color: white; padding-left: 4px; border: 1px solid #6c6c6c; }"

    oView:SetViewProperty( "VIEW_PB9", "SETCSS", {cCSS} )

    oView:CreateHorizontalBox("SUPERIOR", 10)
    oView:CreateHorizontalBox("AUXILIAR", 10)
    oView:CreateHorizontalBox("FRETE", 80)


    oView:SetOwnerView("VIEW_PB8", "SUPERIOR")
    oView:SetOwnerView("VIEW_AUX", "AUXILIAR")
    oView:SetOwnerView("VIEW_PB9", "FRETE")

    oStruPB9:RemoveField('PB9_CODTRA' )
    oStruPB9:RemoveField('PB9_PERIOD' )

    //oModel:GetModel( 'PB9DETAIL' ):SetUniqueLine( { 'PB9_DATA','PB9_LINHA','PB9_CODTRA','PB9_PERIOD' })

Return (oView)


User Function QA23BCS1()

Local cAliasQry := GetNextAlias()
Local cRet      := 'A2_LOJA == "0001" .AND. A2_COD $ "'
    BeginSql Alias cAliasQry

		%noparser%

        //SELECT DISTINCT A2_COD,(SELECT TOP 1 A2_NOME FROM SA2010 A21 WHERE A21.A2_COD=SA2.A2_COD AND A21.D_E_L_E_T_='') AS A2_NOME FROM SA2010 SA2
        //WHERE SA2.D_E_L_E_T_=''
        //AND A2_COD IN (SELECT LBB_CODFOR FROM LBB010 LBB WHERE LBB_FILIAL='04' AND LBB_TIPREG='2' AND LBB.D_E_L_E_T_='')
        //ORDER BY A2_COD

        SELECT DISTINCT A2_COD
        FROM %table:SA2% SA2
        WHERE SA2.%notDel%
        AND A2_COD IN (SELECT LBB_CODFOR FROM %table:LBB% LBB WHERE LBB_FILIAL=%Exp:cFilAnt% AND LBB_TIPREG='2' AND LBB.%notDel%)
        ORDER BY A2_COD

	EndSql

    While (cAliasQry)->( !Eof())

    cRet += (cAliasQry)->(A2_COD)+"|"
    (cAliasQry)->( dbSkip())

    EndDo
    cRet := SubStr(cRet,1,Len(cRet)-1)+'"'

Return cRet

User Function QA23BCS2()

Local cAliasQry := GetNextAlias()
Local cRet      := ''
Local lRet      := .T.
    BeginSql Alias cAliasQry

		%noparser%

        //SELECT DISTINCT A2_COD,(SELECT TOP 1 A2_NOME FROM SA2010 A21 WHERE A21.A2_COD=SA2.A2_COD AND A21.D_E_L_E_T_='') AS A2_NOME FROM SA2010 SA2
        //WHERE SA2.D_E_L_E_T_=''
        //AND A2_COD IN (SELECT LBB_CODFOR FROM LBB010 LBB WHERE LBB_FILIAL='04' AND LBB_TIPREG='2' AND LBB.D_E_L_E_T_='')
        //ORDER BY A2_COD

        SELECT DISTINCT A2_COD
        FROM %table:SA2% SA2
        WHERE SA2.%notDel%
        AND A2_COD IN (SELECT LBB_CODFOR FROM %table:LBB% LBB WHERE LBB_FILIAL=%Exp:cFilAnt% AND LBB_TIPREG='2' AND LBB.%notDel%)
        ORDER BY A2_COD

	EndSql

    While (cAliasQry)->( !Eof())

    cRet += (cAliasQry)->(A2_COD)+"|"
    (cAliasQry)->( dbSkip())

    EndDo
    cRet := SubStr(cRet,1,Len(cRet)-1)

    If !M->PB8_CODTRA $ cRet
        lRet := .F.
        MsgStop("Codigo noa invalido!")
    EndIf
Return lRet

/*/{Protheus.doc} QA23BLIN
VERIFICA SE O ATENDIMENTO É DA MESMA LINHA OU É ATENDIMENTO DE SOCORRO.
@type function
@version
@author Wilson Davila
@since 12/11/2020
@return return_type, return_description
/*/
User Function QA23BLIN()

Local cAlias  := GetNextAlias()
Local cRet    := 'S'
Local cCodFor := M->PB8_CODTRA
Local cLinha  := FWFldGet("PB9_LINHA")

BeginSql Alias cAlias

%noparser%

    SELECT DISTINCT LBB_LINHA FROM %Table:LBB% LBB WHERE LBB_FILIAL=%Exp:cFilant% AND LBB.%notDel% AND LBB_LINHA=%Exp:cLinha% AND
    %Exp:cLinha% IN (SELECT LBB_LINHA FROM  %Table:LBB% LBB1 (NOLOCK) WHERE LBB_FILIAL=%Exp:cFilant% AND LBB_TIPREG='2'
    AND LBB_CODFOR=%Exp:cCodFor% AND LBB1.%notDel%)

EndSql


If (cAlias)->( !Eof())
    cRet := 'N'
End If


Return cRet

Static Function xCpoPB9(oModel)

//Local oModel    := FWModelActive()
Local oModelPB9 := oModel:GetModel('PB9DETAIL')
Local cLinha	:= oModelPB9:GetValue('PB9_LINHA')

For i := 1 to oModelPB9:Length()
    oModelPB9:GoLine(i)
    cLinha	:= oModelPB9:GetValue('PB9_LINHA')
    oModelPB9:SetValue('PB9_DESLIN',POSICIONE("PA7",1,XFILIAL("PA7")+cLinha,"PA7_DESC"))
Next i

Return .T.

User Function xCpoPB91()


Local oModel := FWModelActive()
Local cLinha := oModel:GetModel("PB9DETAIL"):GetValue('PB9_LINHA')
Local cRet   := ''
//MsgAlert(cLinha)
oModel:GetModel("PB9DETAIL"):SetValue('PB9_DESLIN',POSICIONE("PA7",1,XFILIAL("PA7")+cLinha,"PA7_DESC"))
cRet := POSICIONE("PA7",1,XFILIAL("PA7")+cLinha,"PA7_DESC")

Return cRet

User Function xCpoPB92()

Local lRet   := .T.
Local oModel := FWModelActive()
//Local cLinha := oModel:GetValue('PB9DETAIL','PB9_LINHA')

//If INCLUI
    oModel:SetValue('PB9DETAIL','PB9_CODTRA',M->PB8_CODTRA)
    oModel:SetValue('PB9DETAIL','PB9_PERIOD',M->PB8_PERIOD)
//Endif

Return lRet


/*/{Protheus.doc} ReportExcel
Gera Tela em Excle
@type function
@versionhd
@author Wilson Davila
@since 30/06/2020
/*/

User Function ExcelQA23()

	Local oExcel 	:= FWMsExcelEx():New()
	Local nConta	:= 0
	Local cNomArq   := "Lançamento KM x Linha"
    Local cArq      := ''
    Local cPasta    := "KM X LINHA"
    Local cAlias    := GetNextAlias()

    If Pergunte("QUAA023G",.T.)

        cArq  := cGetFile (,, 1,, .F., GETF_RETDIRECTORY+GETF_LOCALHARD)
        cArq := cArq + "KM_X_LINHA_" + TRANSFORM(MV_PAR01,"@R 99_9999") + ".XLS"

        BeginSql alias cAlias

            %noparser%

            SELECT CAST(PB9_DATA AS SMALLDATETIME) AS PB9_DATA,PB9_LINHA,PA7_DESC,
            CASE WHEN PB9_TIPO='N' THEN 'NORMAL' ELSE 'SOCORRO' END AS PB9_TIPO,PB9_TOTKM
            FROM %Table:PB9% PB9
            INNER JOIN %Table:PA7% PA7 ON PA7_FILIAL=PB9_FILIAL AND PA7_CODLIN=PB9_LINHA AND PA7.%notDel%
            WHERE PB9.%notDel% AND PB9_PERIOD=%Exp:MV_PAR01% AND PB9_FILIAL=%Exp:cFilAnt%
            ORDER BY PB9_CODTRA,PB9_DATA

        EndSql

        aHead := Array(5)
        aHead[1] := "DATA"
        aHead[2] := "CODLIN"
        aHead[3] := "LINHA"
        aHead[4] := "TIPO"
        aHead[5] := "TOTKM"

        oExcel:AddworkSheet(cPasta)
    	oExcel:AddTable (cPasta,cNomArq)


        For a := 1 to Len(aHead)

            oExcel:AddColumn(cPasta,cNomArq,aHead[a])

        Next a

        //aDados := Array(Len(oPrcLeite:aCols),Len(aHead))


        aDados := {}
        While (cAlias)->( !Eof() )
            AADD(aDados,{(cAlias)->(PB9_DATA),(cAlias)->(PB9_LINHA),(cAlias)->(PA7_DESC),(cAlias)->(PB9_TIPO),(cAlias)->(PB9_TOTKM)})
            (cAlias)->( dbSkip() )
        EndDo


        For _a := 1 To Len(aDados)
            oExcel:AddRow(cPasta,cNomArq,aDados[_a])
        Next _a

        MsgInfo("Planilha Gerada")

        //ProcessMessage()
    	oExcel:Activate()
    	oExcel:GetXMLFile(cArq)
    	oExcelApp := MsExcel():New()
    	oExcelApp:WorkBooks:Open(cArq)
    	oExcelApp:SetVisible(.T.)
        //oExcelApp:Destroy()

    EndIf

Return

User Function xPB8Per()

Local lRet      := .T.
Local dDataFech := GetMv("MV_XDTFCHT")

    If ctod( cValToChar( LastDay( ctod( '01'+"/"+substr(M->PB8_PERIOD,1,2)+"/"+substr(M->PB8_PERIOD,3,4) ) )) +"/"+substr(M->PB8_PERIOD,1,2)+"/"+substr(M->PB8_PERIOD,3,4)) <= dDataFech
        MsgStop(OemToAnsi("Data fechada, altere período!"))
        lRet := .F.
    EndIf

    If lRet
        If ! SubStr(M->PB8_PERIOD,1,2) $ '01|02|03|04|05|06|07|08|09|10|11|12' .OR. ! Val(SubStr(M->PB8_PERIOD,3,4)) >= 2020
            MsgStop(OemToAnsi("Período inválido, altere período!"))
            lRet := .F.
        EndIf
    EndIf

Return lRet
