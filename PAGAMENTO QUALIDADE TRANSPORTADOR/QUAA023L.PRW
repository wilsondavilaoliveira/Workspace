#Include "TOTVS.ch"

#Include "FWMVCDEF.ch"
/*/{Protheus.doc} QUAA023L()==============================================================================================================================
CADASTRO TRANSPORTADORA
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/

User Function QUAA023L()

    Local oBrowse := ''

    If Pergunte("QUAA023L")
        MsAguarde({|| GeraBase()},"Selecionando registros...")
        oBrowse := FwLoadBrw("QUAA023L")
        oBrowse:Activate()
    End If

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

    oBrowse:SetAlias("PC6")
    oBrowse:SetDescription("Pagto de Transportadoras")
    oBrowse:AddFilter("FILIAL","PC6_FILIAL=="+cFilAnt+" .AND. PC6_PERIOD=="+MV_PAR01,.T.,.T.)
    oBrowse:SetMenuDef("QUAA023L")
    oBrowse:AddLegend( "PC6_STATUS=='A'", "BR_VERDE"		, "Aguardando")
    oBrowse:AddLegend( "PC6_STATUS=='S'", "BR_PINK"		    , "Simulacao")
    oBrowse:AddLegend( "PC6_STATUS=='P'", "BR_VERMELHO"		, "Fechado pronto p/Gerar Nota")
    oBrowse:AddLegend( "PC6_STATUS=='F'", "BR_AZUL"		, "Fechado Nota Gerada")

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

    Local aRotina := {} //FwMVCMenu("QUAA023L")
    Local cBnt1   := '' //iif(MV_PAR02==1,"SIMULAÇÃO","FECHAMENTO")

    //Pergunte("QUAA023L",.F.)

    cBnt1   := "SIMULAÇÃO/FECHAMENTO?"

    ADD OPTION aRotina TITLE cBnt1 ACTION 'U_QA023FCH()' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualiza' ACTION 'VIEWDEF.QUAA023L' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Relatorio Conferencia' ACTION 'U_xRelQA23L()' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Gerar Base Cte/Nfs' ACTION 'U_QUAA023M()' OPERATION 2 ACCESS 0
    //ADD OPTION aRotina TITLE 'Gerar Cte/Nfs' ACTION 'U_EXEC103()' OPERATION 2 ACCESS 0
Return (aRotina)


User Function AX23L()

AxCadastro("PC9")

Return


User Function xRelQA23L()

    MsAguarde({|| Relatorio()},"Gerando Relatorio...")

Return


/*/{Protheus.doc} ModelDef()===============================================================================================================================
Regra de Negocio
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
Static Function ModelDef()

    Local oModel 	:= MPFormModel():New("QAA023EL",,,)
    Local oStruPC6 	:= FwFormStruct(1, "PC6")
    Local oStruPC7 	:= FwFormStruct(1, "PC7")
    Local oStruPC8 	:= FwFormStruct(1, "PC8")


    oModel:AddFields("PC6MASTER", NIL, oStruPC6)
    oModel:AddGrid("PC7DETAIL","PC6MASTER",oStruPC7)
    oModel:AddGrid("PC8DETAIL","PC6MASTER",oStruPC8)


    oModel:GetModel("PC7DETAIL"):SetNoInsertLine(.T.)
    oModel:GetModel("PC7DETAIL"):SetNoUpdateLine(.T.)
    oModel:GetModel("PC8DETAIL"):SetNoInsertLine(.T.)
    oModel:GetModel("PC8DETAIL"):SetNoUpdateLine(.T.)


    oModel:SetRelation("PC7DETAIL", {{"PC7_FILIAL",'PC6_FILIAL'},{"PC7_CODTRA", "PC6_CODTRA"},{"PC7_PERIOD", "PC6_PERIOD"}}, PC7->(IndexKey( 1 )))
    oModel:SetRelation("PC8DETAIL", {{"PC8_FILIAL",'PC6_FILIAL'},{"PC8_CODTRA","PC6_CODTRA"},{"PC8_PERIOD","PC6_PERIOD"}}, PC8->(IndexKey( 2 )))


    oModel:SetPrimaryKey( {'PC6_CODTRA'})
    oModel:SetDescription("Pagamento de Transportadoras" )

    oModel:GetModel("PC6MASTER"):SetDescription("Transportadora")
    oModel:GetModel("PC7DETAIL"):SetDescription("Linhas Transportador")
    oModel:GetModel("PC8DETAIL"):SetDescription("Bonificacoes")


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
    Local oStruPC6 	:= FwFormStruct(2,"PC6")
    Local oStruPC7 	:= FwFormStruct(2,"PC7")
    Local oStruPC8 	:= FwFormStruct(2,"PC8")
    Local oModel 	:= FwLoadModel("QUAA023L")
    Local cCSS      := ''
    oView:SetModel(oModel)

    oView:AddField("VIEW_PC6", oStruPC6, "PC6MASTER")
    oView:AddGrid("VIEW_PC7", oStruPC7, "PC7DETAIL")
    oView:AddGrid("VIEW_PC8", oStruPC8, "PC8DETAIL")

    cCSS := "QTableView { selection-background-color: #ade0ff; font-weight:bold;font-size:14px }"
    cCSS += "QHeaderView::section { background-color: qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #616161, stop: 0.5 #505050, stop: 0.6 #434343,  stop:1 #656565); color: white; padding-left: 4px; border: 1px solid #6c6c6c; }"

    oView:SetViewProperty( "VIEW_PC7", "SETCSS", {cCSS} )
    oView:SetViewProperty( "VIEW_PC8", "SETCSS", {cCSS} )

    oView:CreateHorizontalBox("SUPERIOR", 33)
    oView:CreateHorizontalBox("BAIXO1"   , 35)
    oView:CreateHorizontalBox("BAIXO2"   , 32)

    //oView:CreateVerticalBox("BAIXOESQ", 50,'BAIXO2')
    //oView:CreateVerticalBox("BAIXODIR", 50,'BAIXO2')
    //oView:CreateHorizontalBox("BONIFICACAO", 22)

    oStruPC8:RemoveField('PC8_CODTRA' )
    //oStruPC6:RemoveField('PC6_STATUS' )

    oView:SetOwnerView("VIEW_PC6", "SUPERIOR")
    oView:SetOwnerView("VIEW_PC7", "BAIXO1")
    oView:SetOwnerView("VIEW_PC8", "BAIXO2")

    oView:EnableTitleView("VIEW_PC7","Linhas Transportadora")
    oView:EnableTitleView("VIEW_PC8","Bonificacoes")

Return (oView)



/*/{Protheus.doc} U_QA023FCH
description
@type function
@version
@author wilso
@since 06/11/2020
@return return_type, return_description
/*/
User Function QA023FCH()

    Local oModel := FwLoadModel("QUAA023L")


    If PC6->PC6_STATUS $ 'P|F'
        MsgStop("Periodo Fechado! Acao nao permitida.")
    Else

        If Pergunte("QUAA023L")
            If MV_PAR02 == 1

                TcSqlExec("DELETE " + RetSqlName("PC6") + " WHERE PC6_PERIOD='" + MV_PAR01 + "'")
                TcSqlExec("DELETE " + RetSqlName("PC7") + " WHERE PC7_PERIOD='" + MV_PAR01 + "'")
                TcSqlExec("DELETE " + RetSqlName("PC8") + " WHERE PC8_PERIOD='" + MV_PAR01 + "'")
                FWFormCommit(oModel)
                oModel:DeActivate()
                oModel:Activate()

                MsAguarde({|| Processa()},"Executando Calculos...")
            Else
                MsAguarde({|| Processa()},"Gerando base de Nfs para fechamento..")
                FWFormCommit(oModel)
                oModel:DeActivate()
                oModel:Activate()
            EndIf
        End If

    EndIf


Return

Static Function Processa()

Local aLeituras := {}
Local i         := 0
Local cCodTra   := ''
Local cTpDoc    := ''
Local nKm       := 0
Local nResUnit  := 0
Local nTotBon   := 0
Local aLinhas   := {}
Local nKmLin    := 0
Local nBonLin   := 0
Local nAdcImp   := 0
Local nVrFrtL   := 0
Local nVrFrtT   := 0
Local nTotLit   := 0
Local aSocorro  := {}
Local s         := 0
Local a         := 0
Local cAlias    := GetNextAlias()
Local nTotFrt   := 0
Local nTotLin   := 0
Local nTotBonL  := 0
Local nKmSoc    := 0

Pergunte("QUAA023L",.F.)

If MV_PAR02 == 1

    aLeituras := GeraBase()

    For i := 1 To Len(aLeituras)
        cCodTra := aLeituras[1][1]

        If aLeituras[i][12] == '000000'
            nKm                 := GetKM (aLeituras[i][1])

        Else
            nKm := GetKML(aLeituras[i][1],aLeituras[i][12])
        EndIf

        nResUnit    := aLeituras[i][8]//Calcula(aLeituras[i][2],aLeituras[i][7])

        If aLeituras[i][11] == 'Q'
            aLeituras[i][9] := (nResUnit * nKm)
        Else
            aLeituras[i][9] := nResUnit
        EndIf
        aLeituras[i][13]    := GetKM (aLeituras[i][1])
        aLeituras[i][10] := nKm

    Next i

    cTexto := ''

    //(cAlias)->(PC5_CODTRA),;  [1]
    //(cAlias)->(PC5_CODBON),;  [2]
    //(cAlias)->(DESCBON),;     [3]
    //(cAlias)->(CONFORME),;    [4]
    //(cAlias)->(NAOCONF),;     [5]
    //(cAlias)->(TOTAL),;       [6]
    //(cAlias)->(PERCEN)        [7]
    // UNITARIO                 [8]
    // TOTAL                    [9]
    // TOTAO KM OU LINHA        [10]
    // TP BONIF                 [11]
    // LINHA                    [12]
    // KM TOTLA                 [13]

    /*
    For aa := 1 to Len(aLeituras)
    cTexto +=   aLeituras[aa][1]+";";
                +aLeituras[aa][1]+";";
                +aLeituras[aa][3]+";";
                +cValToChar(aLeituras[aa][4])+";";
                +cValToChar(aLeituras[aa][5])+";";
                +cValToChar(aLeituras[aa][6])+";";
                +cValToChar(aLeituras[aa][7])+";";
                +cValToChar(aLeituras[aa][8])+";";
                +transform(aLeituras[aa][9],"@E 99,999.99")+";";
                +cValToChar(aLeituras[aa][10])+";";
                +aLeituras[aa][11]+";";
                +aLeituras[aa][12]+";";
                +cValToChar(aLeituras[aa][13])+CRLF
    Next aa

    MemoWrite("C:\HD\aLeituras.csv",cTexto)
    */

    PC6->( dbSetOrder(1))
    PC7->( dbSetOrder(1))
    PC8->( dbSetOrder(1))

    //(cAlias)->(PC5_CODTRA),;  [1]
    //(cAlias)->(PC5_CODBON),;  [2]
    //(cAlias)->(DESCBON),;     [3]
    //(cAlias)->(CONFORME),;    [4]
    //(cAlias)->(NAOCONF),;     [5]
    //(cAlias)->(TOTAL),;       [6]
    //(cAlias)->(PERCEN)        [7]
    // UNITARIO                 [8]
    // TOTAL                    [9]
    // TOTAO KM OU LINHA        [10]
    // TP BONIF                 [11]
    // LINHA                    [12]
    // KM TOTLA                 [13]

    For i := 1 To Len(aLeituras)

        If cCodTra == aLeituras[i][1]

            nTotBon += Iif(aLeituras[i][12]=='000000',aLeituras[i][9],0)
            nTotLin += Iif(aLeituras[i][12]=='000000',0,aLeituras[i][9])

            If !PC8->( dbSeek(cFilAnt+MV_PAR01+aLeituras[i][2]+aLeituras[i][1]) )
                RecLock("PC8",.T.)
                    PC8->PC8_FILIAL := cFilAnt
                    PC8->PC8_PERIOD := MV_PAR01
                    PC8->PC8_CODBON := aLeituras[i][2]
                    PC8->PC8_DESCRI := Alltrim(aLeituras[i][3])
                    PC8->PC8_TOTBON := aLeituras[i][9]
                    PC8->PC8_CODTRA := aLeituras[i][1]
                MsUnlock()
            Else
                RecLock("PC8",.F.)
                    PC8->PC8_TOTBON += aLeituras[i][9]
                MsUnlock()
            EndIf

        EndIf

        If (cCodTra <> iif(i == Len(aLeituras),aLeituras[i][1],aLeituras[i+1][1]) ) .OR. ( i == Len(aLeituras) )

            aLinhas     := GetLitros(aLeituras[i][1])
            aSocorro    := GetLinSoc(aLeituras[i][1])
            nAdcImp     := Posicione("SA2",1,xFilial("SA2")+aLeituras[i][1]+'0001',"A2_PERIMP")

            For s := 1 To Len(aSocorro)

                If aSocorro[s][2] > 0

                    nKmLin  := aSocorro[s][2]
                    nKmSoc  += aSocorro[s][2]
                    nBonLin := 0 //(nTotBon/aLeituras[i][10])*nKmLin
                    nVrFrtL := nKmLin*Posicione("PBL",1,cFilAnt+aLeituras[i][1]+aLinhas[1][1],"PBL_VALOR")
                    nVrFrtT += nVrFrtL
                    nTotLit += 0

                    PC7->(dbSetOrder(1))
                    If !PC7->( MsSeek( cFilAnt+MV_PAR01+aLeituras[i][1]+aSocorro[s][1] ) )
                        RecLock("PC7",.T.)
                            PC7->PC7_FILIAL := cFilAnt
                            PC7->PC7_PERIOD := MV_PAR01
                            PC7->PC7_CODTRA := aLeituras[i][1]
                            PC7->PC7_LINHA  := aSocorro[s][1]
                            PC7->PC7_TIPO   := 'S'
                            PC7->PC7_TOTBON := nBonLin
                            PC7->PC7_TOTFRT := nVrFrtL
                            PC7->PC7_ENCARG := (((nBonLin+nVrFrtL)*nAdcImp)/100)
                            PC7->PC7_TOTGER := (nBonLin+nVrFrtL) + (((nBonLin+nVrFrtL)*nAdcImp)/100)
                            PC7->PC7_TOTLIT := 0
                            PC7->PC7_CUSLIT := 0
                            PC7->PC7_TOTKM  := nKmLin
                            PC7->PC7_FRETKM := ((nBonLin+nVrFrtL) + (((nBonLin+nVrFrtL)*nAdcImp)/100) ) / nKmLin

                        MsUnlock()
                    Else
                        RecLock("PC7",.F.)
                            PC7->PC7_TOTBON := nBonLin
                            PC7->PC7_TOTFRT := nVrFrtL
                            PC7->PC7_ENCARG := (((nBonLin+nVrFrtL)*nAdcImp)/100)
                            PC7->PC7_TOTGER := (nBonLin+nVrFrtL) + (((nBonLin+nVrFrtL)*nAdcImp)/100)
                            PC7->PC7_TOTLIT := 0
                            PC7->PC7_CUSLIT := 0
                            PC7->PC7_TOTKM  := nKmLin
                            PC7->PC7_FRETKM := ((nBonLin+nVrFrtL) + (((nBonLin+nVrFrtL)*nAdcImp)/100) ) / nKmLin
                        MsUnlock()
                    EndIf
                End If
            Next s

            For a := 1 To Len(aLinhas)

                nKmLin  := GetKML(aLeituras[i][1],aLinhas[a][1])

                For j := 1 To Len(aLeituras)
                    nTotBonL += iif(aLeituras[j][12]==aLinhas[a][1],aLeituras[j][9],0)
                Next j

            /*    iF cCodTra == '007487'

                    MsgAlert("LINHA array- " + cvaltochar(i))
                    MsgAlert("LINHA - " + cvaltochar(aLinhas[a][1]))

                    MsgAlert("ntotbon - " + cvaltochar(nTotBon))
                    MsgAlert("TotKm - " + cvaltochar(aLeituras[i][13]))
                    MsgAlert("KmLinha - " + cvaltochar(nKmLin))
                    MsgAlert("KmSocorro  - " + cvaltochar(nKmSoc))
                    MsgAlert("ntotBon Linha - " + cvaltochar(nTotBonL))
                    MsgAlert("nBonLinha - " + cvaltochar(( (nTotBon/aLeituras[i][13])*(nKmLin+(nKmSoc/Len(aLinhas)) )) + (nTotBonL)))

                EndIf
              */
                nBonLin     := ( (nTotBon/aLeituras[i][13])*(nKmLin+(nKmSoc/Len(aLinhas)) )) + (nTotBonL)
                nTotBonL    := 0
                nVrFrtL     := nKmLin*Posicione("PBL",1,cFilAnt+aLeituras[i][1]+aLinhas[a][1],"PBL_VALOR")
                nVrFrtT     += nVrFrtL
                nTotLit     += aLinhas[a][2]

                If PC7->( MsSeek(cFilAnt+MV_PAR01+aLeituras[i][1]+aLinhas[a][1]))
                    PC7->( Reclock("PC7",.F.))
                        PC7->PC7_TOTBON := nBonLin
                        PC7->PC7_TOTFRT := nVrFrtL
                        PC7->PC7_ENCARG := (((nBonLin+nVrFrtL)*nAdcImp)/100)
                        PC7->PC7_TOTGER := (nBonLin+nVrFrtL) + (((nBonLin+nVrFrtL)*nAdcImp)/100)
                        PC7->PC7_TOTLIT := aLinhas[a][2]
                        PC7->PC7_CUSLIT := ((nBonLin+nVrFrtL) + (((nBonLin+nVrFrtL)*nAdcImp)/100) ) / aLinhas[a][2]
                        PC7->PC7_TOTKM  := nKmLin
                        PC7->PC7_FRETKM := ((nBonLin+nVrFrtL) + (((nBonLin+nVrFrtL)*nAdcImp)/100) ) / nKmLin
                    PC7->( MsUnlock() )
                EndIf
            Next a

            nKmSoc      := 0

            //PC6_VRTOT PC6_TOTLIT PC6_CUSTKM PC6_CUSTLT PC6_STATUS PC6_VRFRT PC6_VRBON PC6_VRIMP
            If PC6->( MsSeek( cFilAnt+aLeituras[i][1]+MV_PAR01 ) )
                RecLock("PC6",.F.)
                    PC6->PC6_STATUS := 'S'
                    PC6->PC6_VRBON  := nTotBon+nTotLin
                    PC6->PC6_TOTKM  := aLeituras[i][10]
                    PC6->PC6_TOTLIT := nTotLit
                    PC6->PC6_VRFRT  := nVrFrtT
                    PC6->PC6_VRIMP  := (((nTotBon+nTotLin+nVrFrtT)*nAdcImp)/100)
                    PC6->PC6_CUSTKM := ((nTotBon+nTotLin+nVrFrtT) + (((nTotBon+nTotLin+nVrFrtT)*nAdcImp)/100) ) / aLeituras[i][10]
                    PC6->PC6_CUSTLT := ((nTotBon+nTotLin+nVrFrtT) + (((nTotBon+nTotLin+nVrFrtT)*nAdcImp)/100) ) / nTotLit
                    PC6->PC6_VRTOT  := ((nTotBon+nTotLin+nVrFrtT) + (((nTotBon+nTotLin+nVrFrtT)*nAdcImp)/100) )
                MsUnlock()
            EndIf

            cCodTra := iif(i == Len(aLeituras),aLeituras[i][1],aLeituras[i+1][1])
            nVrFrtT := 0
            nTotLit := 0
            nTotBon := 0
            nTotLin := 0

        EndIf

    Next i

    MsgAlert("Final de Processamento!")

Else

    BeginSql alias cAlias

        %noparser%

        SELECT D1_COD,LBB_CODMUN,LBB_MUN,F1_VALBRUT,LBB_CODFOR+'-'+LBB_LOJA  AS  LBB_CODFOR,A2_INSCR,LBB_DESC,A2_CGC,

        ROUND(

        ((ISNULL((SELECT SUM(PC7_TOTGER) FROM %Table:PC7% PC7 WHERE PC7_FILIAL=D1_FILIAL AND PC7_PERIOD=%Exp:MV_PAR01%
        AND PC7_TIPO='S' AND PC7_CODTRA=
        (SELECT DISTINCT TOP 1 LBB_CODFOR FROM  %Table:LBB% LBB (NOLOCK) WHERE LBB_LINHA=F1_XLINHA AND LBB_FILIAL=%Exp:cFilAnt%
        AND LBB_TIPREG='2' AND LBB.%notDel%)),0)
        /
        (SELECT SUM(D1_QUANT)
        FROM %Table:SD1% D13 (NOLOCK)
        INNER JOIN  %Table:SF1% SF1A (NOLOCK) ON SF1A.F1_FILIAL=D13.D1_FILIAL AND D13.D1_DOC=SF1A.F1_DOC AND D13.D1_SERIE=SF1A.F1_SERIE AND D13.D1_FORNECE=SF1A.F1_FORNECE
        WHERE SF1A.F1_EMISSAO=SF1.F1_EMISSAO AND SF1A.F1_FILIAL=%Exp:cFilAnt% AND SF1A.F1_XLINHA IN (
        SELECT LBB_LINHA FROM %Table:LBB% LB1 WHERE LBB_TIPREG='2' AND LB1.%notDel% AND LBB_CODFOR IN
        (SELECT DISTINCT TOP 1 LBB_CODFOR FROM %Table:LBB% LBB (NOLOCK) WHERE LBB_LINHA=SF1.F1_XLINHA AND LBB_FILIAL=%Exp:cFilAnt% AND LBB_TIPREG='2'
        AND LBB.%notDel%)))) * D1_QUANT) +


        ((SELECT PC7_TOTGER FROM  %Table:PC7% PC7 WHERE PC7_PERIOD=%Exp:MV_PAR01% AND PC7_CODTRA=
        (SELECT DISTINCT TOP 1 LBB_CODFOR FROM  %Table:LBB% LBB (NOLOCK) WHERE LBB_LINHA=F1_XLINHA AND LBB_FILIAL=%Exp:cFilAnt% AND LBB_TIPREG='2' AND LBB.%notdel%)
        AND PC7.%notdel% AND PC7_LINHA IN( SELECT LBB_LINHA FROM  %Table:LBB% LB1 (NOLOCK) WHERE LBB_FILIAL=%Exp:cFilAnt% AND LB1.LBB_LINHA=LBB.LBB_LINHA AND LBB.%notdel%
        AND LBB_TIPREG='2')) /(SELECT SUM(D1_QUANT) FROM  %Table:SD1% D13 (NOLOCK) INNER JOIN %Table:SF1% SF1 (NOLOCK) ON F1_FILIAL=D1_FILIAL AND D1_DOC=F1_DOC
        AND D1_SERIE=F1_SERIE AND D1_FORNECE=F1_FORNECE WHERE F1_EMISSAO=%Exp:DTOS(LastDay(Ctod("01/"+substr(MV_PAR01,1,2)+"/"+SubStr(MV_PAR01,3,4) ) ))%
        AND F1_FILIAL=%Exp:cFilAnt% AND F1_XLINHA
        IN( SELECT LBB_LINHA FROM  %Table:LBB% LB2 (NOLOCK) WHERE LBB_FILIAL=%Exp:cFilAnt% AND LB2.%notdel% AND LB2.LBB_CODPRO=LBB.LBB_CODPRO))*D1_QUANT),2)
        AS  'FRETE',

        (SELECT DISTINCT TOP 1 LBB_CODFOR FROM  %Table:LBB% LBB (NOLOCK) WHERE LBB_LINHA=F1_XLINHA AND LBB_FILIAL=%Exp:cFilAnt% AND LBB_TIPREG='2' AND LBB.%notdel%)  AS  'CODFOR',
        (SELECT DISTINCT TOP 1 LBB_NOMFOR FROM  %Table:LBB% LBB (NOLOCK) WHERE LBB_LINHA=F1_XLINHA AND LBB_FILIAL=%Exp:cFilAnt% AND LBB_TIPREG='2' AND LBB.%notdel%)  AS  'TRANSP',

        D1_QUANT,LBB_CODPRO,LBB_NOMFOR,LBB_LINHA,F1_EMISSAO,F1_DOC,F1_SERIE,F1_CHVNFE,

        CASE WHEN LBB_CODMUN='71006' THEN 'NFS' ELSE 'CTE' END  AS  'TPDOC'
        FROM  %Table:SF1% SF1 (NOLOCK)
        INNER JOIN  %Table:SD1% SD1 (NOLOCK) ON F1_FILIAL=D1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA AND SD1.%notdel%
        INNER JOIN  %Table:LBB% LBB (NOLOCK) ON LBB_FILIAL=F1_FILIAL AND LBB_CODFOR=F1_FORNECE AND LBB.%notdel%
        INNER JOIN  %Table:SA2% SA2 (NOLOCK) ON A2_COD=LBB_CODFOR AND A2_LOJA=LBB_LOJA AND SA2.%notdel%
        WHERE F1_FILIAL=%Exp:cFilAnt% AND SF1.%notdel% AND F1_EMISSAO=%Exp:DTOS( LastDay(Ctod("01/"+substr(MV_PAR01,1,2)+"/"+SubStr(MV_PAR01,3,4))))%
        AND F1_XLINHA IN (SELECT LBB_LINHA FROM  %Table:LBB% LBB (NOLOCK) WHERE LBB_FILIAL=%Exp:cFilAnt% AND LBB_TIPREG='2' AND LBB.%notdel%)
        ORDER BY F1_FORNECE,CASE WHEN LBB_CODMUN='71006' THEN 'NFS' ELSE 'CTE' END,F1_XLINHA,LBB_CODPRO

    EndSql

    aRet := GetLastQuery()
    MemoWrite("C:\HD\QUERYS\QUAA023L_415.sql",aRet[2])


    If (cAlias)->( Eof())
        MsgStop("Não existem dados para geração de Nota, fechamento do Leite ainda nao foi finalizado")
        Return
    End If

    cCodTra := (cAlias)->(CODFOR)
    cTpDoc  := (cAlias)->(TPDOC)

    Begin transaction

    PC9->( dbSetOrder(1) )

    While (cAlias)->( !Eof() )

        //PC9_FILIAL+PC9_CODTRA+PC9_TIPDOC+PC9_PERIOD
        If !PC9->( dbSeek(cFilAnt+(cAlias)->(CODFOR)+IIF((cAlias)->(TPDOC)=='NFS','1','2')+MV_PAR01) )
            PC9->( RecLock("PC9",.T.))
                PC9->PC9_FILIAL := cFilAnt
                PC9->PC9_CODTRA := (cAlias)->(CODFOR)
                PC9->PC9_TRANSP := (cAlias)->(TRANSP)
                PC9->PC9_PERIOD := MV_PAR01
                PC9->PC9_TIPDOC := IIF((cAlias)->(TPDOC)=='NFS','1','2')
                PC9->PC9_VALOR  := (cAlias)->(FRETE)
                PC9->PC9_STATUS := 'A'
                PC9->PC9_NFORIG := (cAlias)->(F1_DOC)
                PC9->PC9_SERORI := (cAlias)->(F1_SERIE)
                PC9->PC9_CODPRO := (cAlias)->(LBB_CODPRO)
                PC9->PC9_DESPRO := (cAlias)->(LBB_NOMFOR)
                PC9->PC9_VLRORI := (cAlias)->(F1_VALBRUT)

            PC9->( MsUnlock() )
            nTotFrt += (cAlias)->(FRETE)
        Else
            PC9->( RecLock("PC9",.F.))

                PC9->PC9_VALOR  += (cAlias)->(FRETE)

                If (cAlias)->(F1_VALBRUT) > PC9->PC9_VLRORI
                    PC9->PC9_NFORIG := (cAlias)->(F1_DOC)
                    PC9->PC9_SERORI := (cAlias)->(F1_SERIE)
                    PC9->PC9_CODPRO := (cAlias)->(LBB_CODPRO)
                    PC9->PC9_DESPRO := (cAlias)->(LBB_NOMFOR)
                    PC9->PC9_VLRORI := (cAlias)->(F1_VALBRUT)
                End If

            PC9->( MsUnlock() )
            nTotFrt += (cAlias)->(FRETE)
        EndIF


        (cAlias)->( dbSkip() )
    EndDo

    cPer := MV_PAR01
    xLancD3(MV_PAR01,nTotFrt)

    TcSqlExec("UPDATE " + RetSqlName("PC6") + " SET PC6_STATUS='P' WHERE PC6_FILIAL='" + cFilAnt + "' AND PC6_PERIOD='" + cPer + "'")

    End Transaction

    MsgAlert("Base de Notas Geradas!")

EndIf


Return

/*/{Protheus.doc} xLancD3
description
@type function
@version
@author wilso
@since 26/11/2020
@param nOpc, numeric, param_description
@return return_type, return_description
/*/

Static Function xLancD3(MV_PAR01,nValor)

Local aLanc     := {}
Local aEst      := {}
Local cTMlan    := '004'
Local cTMEst    := '504'
Local cProd     := '200113'
Local cCC       := cFilAnt+'0501'
Local cCCtb     := '113011'+cFilAnt
Local cArm      := '04'
Local cGrupo    := '200'
Local cNumDoc   := ''
Local cMotLan   := 'Provisão de frete de compra de leite ' + SubStr(MV_PAR01,1,2)+"-"+SubStr(MV_PAR01,3,4)
Local cMotEst   := 'Estorno Provisão de frete de compra de leite ' + SubStr(MV_PAR01,1,2)+"-"+SubStr(MV_PAR01,3,4)
Local cObs      := 'FRP'
Local aArea     := GetArea()



If      cFilAnt == '02'
            cNumDoc := 'ME'
ElseIf  cFilAnt == '03'
            cNumDoc := 'TS'
ElseIf  cFilAnt == '04'
            cNumDoc := 'VZ'
ElseIf  cFilAnt == '05'
            cNumDoc := 'DO'
ElseIf  cFilAnt == '08'
            cNumDoc := 'CB'
ElseIf  cFilAnt == '09'
            cNumDoc := 'IT'
ElseIf  cFilAnt == '10'
            cNumDoc := 'BJ'
Else
            cNumDoc := ''
EndIf

    If nValor > 0

    cCCtb     := '113011'+cFilAnt

    DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek( xFilial("SB1")+cProd )

    //D3_FILIAL,D3_COD,D3_QUANT,D3_CONTA,D3_LOCAL,D3_DOC,D3_GRUPO,D3_CUSTO1,D3_CC,D3_XOBS
    aLanc :=  {	    {"D3_TM"		,cTMlan	,NIL},;
    				{"D3_COD"		,SB1->B1_COD			                                                    ,NIL},;
    				{"D3_UM"		,SB1->B1_UM				                                                    ,NIL},;
    				{"D3_QUANT"		,0.01		                                                                ,".T."},;
    				{"D3_LOCAL"		,cArm       			                                                    ,NIL},;
    				{"D3_EMISSAO"	,LASTDAY(CTOD("01/"+SubStr(MV_PAR01,1,2)+"/"+SubStr(MV_PAR01,3,4)))      	,NIL},;
    				{"D3_NUMSEQ"	,ProxNum()				                                                    ,NIL},;
    			    {"D3_DOC"	    ,cNumDoc+"FR"+SubStr(MV_PAR01,1,2)+SubStr(MV_PAR01,5,6)        		        ,NIL},;
                	{"D3_CUSTO1"	,nValor				                                                        ,NIL},;
                    {"D3_CONTA" 	,cCCtb				                                                        ,NIL},;
                    {"D3_CC"     	,cCC				                                                        ,NIL},;
                    {"D3_MOTIVO"	,cMotLan			                                                        ,NIL},;
                    {"D3_XOBS"  	,cObs	    		                                                        ,NIL},;
                    {"D3_GRUPO"	    ,cGrupo                                                         		    ,NIL}}

    lMsErroAuto := .F.

    MSExecAuto({|x,y| mata240(x,y)},aLanc,3) //inclusao

    If lMsErroAuto
    	Mostraerro()
    	DisarmTransaction()
    Else

        //cNumDoc := cNumDoc+"EFR"+SubStr(MV_PAR01,1,2)+SubStr(MV_PAR01,5,6)

        DbSelectArea("SB1")
    	DbSetOrder(1)
    	DbSeek( xFilial("SB1")+cProd )

        aLanc :=  {	    {"D3_TM"		,cTMEst	,NIL},;
            			{"D3_COD"		,SB1->B1_COD			                                                        ,NIL},;
        				{"D3_UM"		,SB1->B1_UM				                                                        ,NIL},;
        				{"D3_QUANT"		,0.01		                                                                    ,".T."},;
        				{"D3_LOCAL"		,cArm       			                                                        ,NIL},;
        				{"D3_EMISSAO"	,CTOD("01/"+StrZero(val(SubStr(MV_PAR01,1,2))+1,2)+"/"+SubStr(MV_PAR01,3,4))	,NIL},;
        				{"D3_NUMSEQ"	,ProxNum()				                                                        ,NIL},;
        			    {"D3_DOC"	    ,cNumDoc+"EFR"+SubStr(MV_PAR01,1,2)+SubStr(MV_PAR01,5,6)                        ,NIL},;
                    	{"D3_CUSTO1"	,nValor				                                                            ,NIL},;
                        {"D3_CONTA" 	,cCCtb				                                                            ,NIL},;
                        {"D3_CC"     	,cCC				                                                            ,NIL},;
                        {"D3_MOTIVO"	,cMotEst			                                                            ,NIL},;
                        {"D3_XOBS"  	,cObs	    		                                                            ,NIL},;
                        {"D3_GRUPO"	    ,cGrupo                                                         		        ,NIL}}

        lMsErroAuto := .F.

        MSExecAuto({|x,y| mata240(x,y)},aLanc,3) //inclusao

        If lMsErroAuto
        	Mostraerro()
        	DisarmTransaction()
        Endif

    End If

    End If

RestArea(aArea)

Return


/*/{Protheus.doc} Calcula
description
@type function
@version
@author wilso
@since 06/03/2021
@param cTabQua, character, param_description
@param cTipoL, character, param_description
@param nValor, numeric, param_description
@return return_type, return_description
/*/
Static Function Calcula(cCodBon,nValor)

Local nResul    := 0
Local aArea		:= GetArea()

	//PBH_FILIAL+PBH_CODIGO+PBH_CODITE+PBH_ITEM
    dbselectArea("PBH") // Tabela Criterios da Qualidade
	dbSetOrder(1)
	If dbseek( cFilAnt+SubStr(cCodBon,1,2)+SubStr(cCodBon,4,3) )
    	Do While !Eof() .And. ( PBH->PBH_FILIAL+PBH->PBH_CODIGO+PBH->PBH_CODITE == cFilAnt+SubStr(cCodBon,1,2)+SubStr(cCodBon,4,3) )
    		If nValor >= PBH->PBH_VINIC .And. nValor <= PBH->PBH_VFINAL
    			 nResul := PBH->PBH_VRESUL
                 Exit
            EndIf
    		dbSkip()
    	EndDo
    End If

	RestArea(aArea)

Return(nResul)

/*/{Protheus.doc} GeraBase
description
@type function
@version
@author wilso
@since 06/03/2021
@return return_type, return_description
/*/
Static Function GeraBase()

Local aRet := {}
Local cAlias := GetNextAlias()
Local cAlLBE := ''
Local i


    BeginSql Alias cAlias

        %noparser%

       //APONTAMENTO MULTIPLO O SISTEMA CONTA O NUMERO DE INTENS NAO CONFORME E PAGA PELO NUMERO DE ITENS NAO CONFORME

        SELECT DISTINCT 'Q' AS TPBON,PC5_CODTRA,PC5_LINHA,
        (SELECT PC6_TRANSP FROM %Table:PC6% PC6 WHERE PC6_CODTRA=PC5_CODTRA AND PC6_FILIAL=%Exp:cFilAnt% AND PC6_PERIOD=%Exp:MV_PAR01% AND PC6.%notDel%) AS 'TRANSP',
        PC5_CODBON,
        (SELECT PBD_DESCR FROM %Table:PBD%  PBD WHERE PBD_FILIAL=%Exp:cFilAnt% AND PBD_CODIGO=SUBSTRING(PC5_CODBON,4,3)
        AND PBD_CODTIP = SUBSTRING(PC5_CODBON,1,2) AND PBD.%notDel%) AS 'DESCBON',

        ISNULL((SELECT SUM(PC5_ITAPON) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'M' AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notDel%
        AND PC5A.PC5_FILIAL=PC5.PC5_FILIAL AND PC5A.PC5_CODBON=PC5.PC5_CODBON  AND PC5_STATUS='A' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA),0) AS 'CONFORME',

        ISNULL((SELECT SUM(PC5_ITAPON) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'M' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notDel%
        AND PC5B.PC5_FILIAL=PC5.PC5_FILIAL AND PC5B.PC5_CODBON=PC5.PC5_CODBON AND PC5_STATUS='N' AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA),0) AS 'NAOCONFO',

        ISNULL((SELECT SUM(PC5_ITAPON) FROM %Table:PC5% PC5C WHERE PC5_TPAPOM = 'M' AND PC5C.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5C.%notDel%
        AND PC5C.PC5_FILIAL=PC5.PC5_FILIAL AND PC5C.PC5_CODBON=PC5.PC5_CODBON AND PC5C.PC5_CODTRA=PC5.PC5_CODTRA),0) AS 'TOTAL',

        ISNULL((SELECT SUM(PC5_ITAPON) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'M' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notDel%
        AND PC5B.PC5_FILIAL=PC5.PC5_FILIAL AND PC5B.PC5_CODBON=PC5.PC5_CODBON AND PC5_STATUS='N' AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA),0) AS 'RESULT',

        ISNULL((SELECT PBH_VRESUL FROM %Table:PBH% PBH WHERE PBH_FILIAL=%Exp:cFilAnt% AND PBH_CODIGO=SUBSTRING(PC5_CODBON,1,2) AND PBH_CODITE=SUBSTRING(PC5_CODBON,4,3)
        AND ((ISNULL((SELECT SUM(PC5_ITAPON) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'M' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notDel%
        AND PC5B.PC5_FILIAL=PC5.PC5_FILIAL AND PC5B.PC5_CODBON=PC5.PC5_CODBON AND PC5_STATUS='N' AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA),0)) >= PBH_VINIC
        AND (ISNULL((SELECT SUM(PC5_ITAPON) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'M' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notDel%
        AND PC5B.PC5_FILIAL=PC5.PC5_FILIAL AND PC5B.PC5_CODBON=PC5.PC5_CODBON AND PC5_STATUS='N' AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA),0)) <= PBH_VFINAL ) AND PBH.%notDel%),0) AS 'VR_BON'

        FROM %Table:PC5% PC5 WHERE PC5_PERIOD=%Exp:MV_PAR01% AND PC5.%notDel% AND PC5_TPAPOM = 'M' AND PC5_FILIAL=%Exp:cFilAnt%

        UNION ALL

        //APONTAMENTO SIMPLES CONFORME OU NAO CONFORME SISTEMA CONTA O % DE ITENS EM CONFORMIDADE E PAGA PELO %

        SELECT DISTINCT 'Q' AS TPBON,PC5_CODTRA,PC5_LINHA,
        (SELECT PC6_TRANSP FROM %Table:PC6% PC6 WHERE PC6_CODTRA=PC5_CODTRA AND PC6_FILIAL=%Exp:cFilAnt% AND PC6_PERIOD=%Exp:MV_PAR01% AND PC6.%notDel%) AS 'TRANSP',
        PC5_CODBON,
        (SELECT PBD_DESCR FROM %Table:PBD% PBD WHERE PBD_FILIAL=%Exp:cFilAnt% AND PBD_CODIGO=SUBSTRING(PC5_CODBON,4,3) AND PBD_CODTIP = SUBSTRING(PC5_CODBON,1,2) AND PBD.%notDel%) AS 'DESCBON',
        (SELECT COUNT(PC5_STATUS) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'A' AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notDel%
        AND PC5A.PC5_FILIAL=PC5.PC5_FILIAL AND PC5A.PC5_CODBON=PC5.PC5_CODBON AND PC5_STATUS='C' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA) AS 'CONFORME',

        (SELECT COUNT(PC5_STATUS) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'A' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notDel%
        AND PC5B.PC5_FILIAL=PC5.PC5_FILIAL AND PC5B.PC5_CODBON=PC5.PC5_CODBON AND PC5_STATUS='N' AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA) AS 'NAOCONFO',

        (SELECT COUNT(PC5_STATUS) FROM %Table:PC5% PC5C WHERE PC5_TPAPOM = 'A' AND PC5C.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5C.%notDel%
        AND PC5C.PC5_FILIAL=PC5.PC5_FILIAL AND PC5C.PC5_CODBON=PC5.PC5_CODBON AND PC5C.PC5_CODTRA=PC5.PC5_CODTRA) AS 'TOTAL',

        ROUND(((SELECT CAST(COUNT(PC5_STATUS) AS float) FROM %Table:PC5% PC5D WHERE PC5_TPAPOM = 'A' AND PC5D.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5D.%notDel%
        AND PC5D.PC5_FILIAL=PC5.PC5_FILIAL AND PC5D.PC5_CODBON=PC5.PC5_CODBON AND PC5_STATUS='C' AND PC5D.PC5_CODTRA=PC5.PC5_CODTRA)/
        (SELECT CAST(COUNT(PC5_STATUS) AS float) FROM %Table:PC5% PC5E WHERE PC5_TPAPOM = 'A' AND PC5E.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5E.%notDel%
        AND PC5E.PC5_FILIAL=PC5.PC5_FILIAL AND PC5E.PC5_CODBON=PC5.PC5_CODBON AND PC5E.PC5_CODTRA=PC5.PC5_CODTRA))*100,0) AS 'RESULT',

        ISNULL((SELECT PBH_VRESUL FROM %Table:PBH% PBH WHERE PBH_FILIAL=%Exp:cFilAnt% AND PBH_CODIGO=SUBSTRING(PC5_CODBON,1,2) AND PBH_CODITE=SUBSTRING(PC5_CODBON,4,3)
        AND ((ISNULL((ROUND(((SELECT CAST(COUNT(PC5_STATUS) AS float) FROM %Table:PC5% PC5D WHERE PC5_TPAPOM = 'A'
        AND PC5D.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5D.%notDel%
        AND PC5D.PC5_FILIAL=PC5.PC5_FILIAL AND PC5D.PC5_CODBON=PC5.PC5_CODBON AND PC5_STATUS='C' AND PC5D.PC5_CODTRA=PC5.PC5_CODTRA)/
        (SELECT CAST(COUNT(PC5_STATUS) AS float) FROM %Table:PC5% PC5E WHERE PC5_TPAPOM = 'A' AND PC5E.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5E.%notDel%
        AND PC5E.PC5_FILIAL=PC5.PC5_FILIAL AND PC5E.PC5_CODBON=PC5.PC5_CODBON AND PC5E.PC5_CODTRA=PC5.PC5_CODTRA))*100,0)),0)) >= PBH_VINIC
        AND (ISNULL(((ROUND(((SELECT CAST(COUNT(PC5_STATUS) AS float) FROM %Table:PC5% PC5D WHERE PC5_TPAPOM = 'A'
        AND PC5D.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5D.%notDel%
        AND PC5D.PC5_FILIAL=PC5.PC5_FILIAL AND PC5D.PC5_CODBON=PC5.PC5_CODBON AND PC5_STATUS='C' AND PC5D.PC5_CODTRA=PC5.PC5_CODTRA)/
        (SELECT CAST(COUNT(PC5_STATUS) AS float) FROM %Table:PC5% PC5E WHERE PC5_TPAPOM = 'A' AND PC5E.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5E.%notDel%
        AND PC5E.PC5_FILIAL=PC5.PC5_FILIAL AND PC5E.PC5_CODBON=PC5.PC5_CODBON AND PC5E.PC5_CODTRA=PC5.PC5_CODTRA))*100,0))),0)) <= PBH_VFINAL ) AND PBH.%notDel%),0) AS 'VR_BON'

        FROM %Table:PC5% PC5 WHERE PC5_PERIOD=%Exp:MV_PAR01% AND PC5.%notDel% AND PC5_TPAPOM = 'A' AND PC5_FILIAL=%Exp:cFilAnt%

        UNION ALL

        //APONTAMENTO PONTOS CONFORME OU NAO CONFORME O SISTEMA SOMA OS PONTOS PELO PESO DIVIDE PELO NUMERO DE FREQUENCIA DE COLETAS MES

        SELECT DISTINCT 'Q' AS TPBON,PC5_CODTRA,PC5_LINHA,
        (SELECT PC6_TRANSP FROM %Table:PC6% PC6 WHERE PC6_CODTRA=PC5_CODTRA AND PC6_FILIAL=%Exp:cFilAnt% AND PC6_PERIOD=%Exp:MV_PAR01% AND PC6.%notDel%) AS 'TRANSP',

        '03.999' AS PC5_CODBON,'SEGURANCA TRAB.' AS 'DESCBON',
        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'P' AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notDel%
        AND PC5A.PC5_FILIAL=PC5.PC5_FILIAL AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='C' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'P' AND PC5_TIPO='V' AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notDel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='C' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0) AS 'CONFORME',

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'P' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notDel%
        AND PC5B.PC5_FILIAL=PC5.PC5_FILIAL AND SUBSTRING(PC5B.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='N' AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'P' AND PC5_TIPO='V' AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notDel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='N' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0) AS 'NAOCONFO',

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5C WHERE PC5_TPAPOM = 'P' AND PC5C.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5C.%notDel%
        AND PC5C.PC5_FILIAL=PC5.PC5_FILIAL AND SUBSTRING(PC5C.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5C.PC5_CODTRA=PC5.PC5_CODTRA)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'P' AND PC5_TIPO='V' AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notDel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0) AS 'TOTAL',

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'P' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notDel%
        AND PC5B.PC5_FILIAL=PC5.PC5_FILIAL AND SUBSTRING(PC5B.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='C' AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'P' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notDel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='C' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)/2 AS 'RESULT',

        ISNULL((SELECT PBH_VRESUL FROM %Table:PBH% PBH WHERE PBH_FILIAL=%Exp:cFilAnt% AND PBH_CODIGO=SUBSTRING(PC5_CODBON,1,2) AND PBH_CODITE=SUBSTRING(PC5_CODBON,4,3)
        AND ((ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'P' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notDel%
        AND PC5B.PC5_FILIAL=PC5.PC5_FILIAL AND SUBSTRING(PC5B.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='C' AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'P' AND PC5_TIPO='V' AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notDel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='C' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%)/2,0)) >= PBH_VINIC
        AND (ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'P' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notDel%
        AND PC5B.PC5_FILIAL=PC5.PC5_FILIAL AND SUBSTRING(PC5B.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='C' AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'P' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notDel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='C' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%)/2,0)) <= PBH_VFINAL ) AND PBH.%notDel%),0) AS 'VR_BON'

        FROM %Table:PC5% PC5 WHERE PC5_PERIOD=%Exp:MV_PAR01% AND PC5.%notDel% AND PC5_TPAPOM = 'P' AND PC5_FILIAL=%Exp:cFilAnt%

        UNION ALL

        //DOCUMENTACAO O SISTEMA CONTA CADA DOCUMENTO EM CONFORMIDADE COM SEUS PESOS E PAGA PELA SOMA DA PONTUACAO

        SELECT DISTINCT 'Q' AS TPBON, PC5_CODTRA,PC5_LINHA,
        (SELECT PC6_TRANSP FROM %Table:PC6% PC6 WHERE PC6_CODTRA=PC5_CODTRA AND PC6_PERIOD=%Exp:MV_PAR01% AND PC6.%notdel% AND PC6_FILIAL=%Exp:cFilAnt%) AS 'TRANSP',
        '04.999' AS PC5_CODBON,'ASPECTOS LEGAIS' AS 'DESCBON',

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M' AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%)
        /(SELECT COUNT(DISTINCT PC5_CODMOT) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V' AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='T' AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%),0) AS 'CONFORME',

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notdel%
        AND SUBSTRING(PC5B.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS IN ('S','V') AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA AND PC5B.PC5_FILIAL=%Exp:cFilAnt%)
        /(SELECT COUNT(DISTINCT PC5_CODMOT) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M' AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS IN ('S','V') AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notdel%
        AND SUBSTRING(PC5B.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS IN ('S','V') AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA AND PC5B.PC5_FILIAL=%Exp:cFilAnt%)
        /(SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V' AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS IN ('S','V') AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='T' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notdel%
        AND SUBSTRING(PC5B.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS IN ('S','V') AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA AND PC5B.PC5_FILIAL=%Exp:cFilAnt%),0) AS 'NAOCONFO',

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5C WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M' AND PC5C.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5C.%notdel%
        AND SUBSTRING(PC5C.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5C.PC5_CODTRA=PC5.PC5_CODTRA AND PC5C.PC5_FILIAL=%Exp:cFilAnt%)
        /(SELECT COUNT(DISTINCT PC5_CODMOT) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M' AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5C WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V' AND PC5C.PC5_LINHA=PC5.PC5_LINHA
        AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5C.%notdel%
        AND SUBSTRING(PC5C.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5C.PC5_CODTRA=PC5.PC5_CODTRA AND PC5C.PC5_FILIAL=%Exp:cFilAnt%)
        /(SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5C WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='T' AND PC5C.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5C.%notdel%
        AND SUBSTRING(PC5C.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5C.PC5_CODTRA=PC5.PC5_CODTRA AND PC5C.PC5_FILIAL=%Exp:cFilAnt%),0) AS 'TOTAL',

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M' AND PC5A.PC5_LINHA=PC5.PC5_LINHA
        AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%)
        /(SELECT COUNT(DISTINCT PC5_CODMOT) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='T'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%),0) AS 'RESULT',

        ISNULL((SELECT PBH_VRESUL FROM %Table:PBH% PBH WHERE PBH_CODIGO=SUBSTRING(PC5_CODBON,1,2) AND PBH_CODITE=SUBSTRING(PC5_CODBON,4,3)
        AND ((ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%)
        /(SELECT COUNT(DISTINCT PC5_CODMOT) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM PC5010 PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='T'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%),0)) >= PBH_VINIC

        AND (ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%)
        /(SELECT COUNT(DISTINCT PC5_CODMOT) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM PC5010 PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='T'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%),0)) <= PBH_VFINAL )

        AND PBH.%notdel% AND PBH.PBH_FILIAL=%Exp:cFilAnt%),0) AS 'VR_BON'

        FROM %Table:PC5% PC5 WHERE PC5_PERIOD=%Exp:MV_PAR01% AND PC5.%notDel% AND PC5_TPAPOM = 'D' AND PC5_FILIAL=%Exp:cFilAnt%

        UNION ALL

        SELECT 'F' AS TPBON,LBE_FORNEC AS PC5_CODTRA,'000000' AS PC5_LINHA,LBE_MOTO AS 'TRANSP',LJW_CODBON AS PC5_CODBON,
        LJS_DESC AS 'DESCBON',0 AS 'CONFORME',0 AS 'NAOCONFO',0 AS 'TOTAL',0 AS 'RESULT',LJW_VALOR AS 'VR_BON'
        FROM %Table:LJW% LJW
        INNER JOIN %Table:LJS% LJS ON LJS_CODBON=LJW_CODBON AND LJS_FILIAL=LJW_FILIAL AND LJS.%notDel%
        INNER JOIN %Table:LBE% LBE ON LBE_FILIAL=LJW_FILIAL AND LBE_CODCAM=LJW_CODCAR AND LBE_STATUS='S' AND LBE.%notDel%
        WHERE LJW.%notDel% AND LJW_PERIOD=%Exp:MV_PAR01% AND LJW_FILIAL=%Exp:cFilAnt%

        ORDER BY PC5_CODTRA,PC5_CODBON

    EndSql

    While (cAlias)->( !Eof() )
        AADD(aRet,{ (cAlias)->(PC5_CODTRA),;
                    (cAlias)->(PC5_CODBON),;
                    (cAlias)->(DESCBON),;
                    (cAlias)->(CONFORME),;
                    (cAlias)->(NAOCONFO),;
                    (cAlias)->(TOTAL),;
                    (cAlias)->(RESULT),;
                    (cAlias)->(VR_BON),0,0,(cAlias)->(TPBON),(cAlias)->(PC5_LINHA),0})
        (cAlias)->( dbSkip() )
    EndDo

    For i := 1 To Len(aRet)
        PC6->(dbSetOrder(1))
        If !PC6->( MsSeek( cFilAnt+AllTrim(aRet[i][1])+MV_PAR01 ) )
            RecLock("PC6",.T.)
                PC6->PC6_FILIAL := cFilAnt
                PC6->PC6_PERIOD := MV_PAR01
                PC6->PC6_CODTRA := aRet[i][1]
                PC6->PC6_TRANSP := Posicione("SA2",1,xFilial("SA2")+aRet[i][1]+'0001',"A2_NOME")
                PC6->PC6_STATUS := 'A'
            MsUnlock()
        End If

        cAlLBE := 'cQry'

        BeginSql alias cAlLBE
            %noparser%
            SELECT  LBE_CODCAM,LBE_MOTO FROM %Table:LBE% LBE WHERE LBE_FILIAL=%Exp:cFilAnt%
            AND LBE_FORNEC=%Exp:aRet[i][1]% AND LBE_STATUS='S' AND LBE.%notDel%
            AND LBE_CODCAM IN (
            SELECT DISTINCT PC0_LINROT
            FROM %Table:PC0% PC0
            WHERE PC0_FILIAL=%Exp:cFilAnt%
            AND PC0_LINROT IN (SELECT LBE_CODCAM FROM %Table:LBE% LBE WHERE LBE_FILIAL=PC0_FILIAL AND LBE_FORNEC=%Exp:aRet[i][1]%
            AND LBE_STATUS='S' AND LBE.%notDel%)
            AND MONTH(PC0_DTENTR)=%Exp:SubStr(MV_PAR01,1,2)% AND YEAR(PC0_DTENTR)=%Exp:SubStr(MV_PAR01,3,4)%
            AND PC0.%notDel% AND PC0_TPENTR='1')

        EndSql

        While (cAlLBE)->( !Eof() )
            //PC7_FILIAL+PC7_PERIOD+PC7_CODTRA+PC7_LINHA
            PC7->(dbSetOrder(1))
            If !PC7->( MsSeek( cFilAnt+MV_PAR01+AllTrim(aRet[i][1])+(cAlLBE)->(LBE_CODCAM) ) )
                RecLock("PC7",.T.)
                    PC7->PC7_FILIAL := cFilAnt
                    PC7->PC7_PERIOD := MV_PAR01
                    PC7->PC7_CODTRA := aRet[i][1]
                    PC7->PC7_LINHA  := (cAlLBE)->(LBE_CODCAM)
                    PC7->PC7_TIPO   := 'N'
                MsUnlock()
            EndIf

            (cAlLBE)->( dbSkip() )
        EndDo
        (cAlLBE)->( DbCloseArea() )
    Next i

Return aRet

/*/{Protheus.doc} GetKM
description
@type function
@version
@author wilso
@since 16/03/2021
@param cCodTra, character, param_description
@return return_type, return_description
/*/
Static Function GetKM(cCodTra)

Local nKm       := 0
Local cAlias    := "TOTKM"


BeginSql alias cAlias
    %noparser%
    SELECT SUM(PB9_TOTKM) AS TOTKM FROM %Table:PB9% PB9 WHERE PB9_PERIOD=%Exp:MV_PAR01%  AND PB9_CODTRA=%Exp:cCodTra% AND PB9.%notdel%
EndSql

If (cAlias)->( !Eof())
    nKM := (cAlias)->(TOTKM)
EndIf

(cAlias)->( DbCloseArea() )

Return nKm


/*/{Protheus.doc} GetKML
description
@type function
@version
@author wilso
@since 16/03/2021
@param cCodTra, character, param_description
@param cCodLin, character, param_description
@return return_type, return_description
/*/
Static Function GetKML(cCodTra,cCodLin)

Local nKm       := 0
Local cAlias    := "TOTKM"


BeginSql alias cAlias
    %noparser%
    SELECT SUM(PB9_TOTKM) AS TOTKM FROM %Table:PB9% PB9 WHERE PB9_PERIOD=%Exp:MV_PAR01%  AND PB9_CODTRA=%Exp:cCodTra%
    AND PB9_LINHA=%Exp:cCodLin% AND PB9.%notdel%
EndSql

If (cAlias)->( !Eof())
    nKM := (cAlias)->(TOTKM)
EndIf

(cAlias)->( DbCloseArea() )

Return nKm


/*/{Protheus.doc} GetLitros
description
@type function
@version
@author wilso
@since 16/03/2021
@param cCodTra, character, param_description
@return return_type, return_description
/*/
Static Function GetLitros(cCodTra)

Local cAlias    := 'TOTLIT'
Local aLitros   := {}

BeginSql alias cAlias
    %noparser%

    SELECT PC0_LINROT,SUM(PC0_QTDAPO) AS PC0_QTDAPO
    FROM %Table:PC0% PC0
    WHERE PC0_FILIAL=%Exp:cFilAnt%
    AND PC0_LINROT IN (SELECT LBE_CODCAM FROM %Table:LBE% LBE WHERE LBE_FILIAL=PC0_FILIAL
    AND LBE_FORNEC=%Exp:cCodTra% AND LBE_STATUS='S' AND LBE.%notdel%)
    AND MONTH(PC0_DTENTR)=%Exp:SubStr(MV_PAR01,1,2)% AND YEAR(PC0_DTENTR)=%Exp:SubStr(MV_PAR01,3,4)%
    AND PC0.%notdel% AND PC0_TPENTR='1'
    GROUP BY PC0_LINROT

EndSql

If (cAlias)->( Eof())
    AADD(aLitros,{'000000',0})
EndIf

While (cAlias)->( !Eof())
    AADD(aLitros,{(cAlias)->(PC0_LINROT),(cAlias)->(PC0_QTDAPO)})
    (cAlias)->( dbSkip() )
EndDo

(cAlias)->( DbCloseArea() )

Return aLitros

/*/{Protheus.doc} GetLinSoc
description
@type function
@version
@author wilso
@since 16/03/2021
@param cCodTra, character, param_description
@return return_type, return_description
/*/
Static Function GetLinSoc(cCodTra)

Local aSocorro := {}
Local cAlias    := 'LINSOC'
BeginSql alias cAlias
    %noparser%

    SELECT PB9_LINHA,SUM(PB9_TOTKM) AS 'TOTKM' FROM %Table:PB9% PB9 WHERE PB9_PERIOD=%Exp:MV_PAR01%
    AND PB9_CODTRA=%Exp:cCodTra% AND PB9_TIPO='S' AND PB9.%notDel%
    GROUP BY PB9_LINHA

EndSql

If (cAlias)->( Eof())
    AADD(aSocorro,{'000000',0})
EndIf

While (cAlias)->( !Eof())
    AADD(aSocorro,{(cAlias)->(PB9_LINHA),(cAlias)->(TOTKM)})
    (cAlias)->( dbSkip() )
EndDo

(cAlias)->( DbCloseArea() )

Return aSocorro

/*/{Protheus.doc} Relatorio
description
@type function
@version
@author wilso
@since 16/03/2021
@return return_type, return_description
/*/
Static Function Relatorio()

Local cXml      := ''
Local cAlias    := 'QUAA23L'
Local cArq      := "C:\SPOOL\FECHAMENTO_TRANSPORTADORAS.XLS"

nHdlImp := fCreate(cArq, 0)


cXml := '<?xml version="1.0"?>' + CRLF
cXml += '<?mso-application progid="Excel.Sheet"?>' + CRLF
cXml += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"' + CRLF
cXml += 'xmlns:o="urn:schemas-microsoft-com:office:office"' + CRLF
cXml += 'xmlns:x="urn:schemas-microsoft-com:office:excel"' + CRLF
cXml += 'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"' + CRLF
cXml += 'xmlns:html="http://www.w3.org/TR/REC-html40">' + CRLF
cXml += '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">' + CRLF
cXml += '<Author>Wilson Davila</Author>' + CRLF
cXml += '<LastAuthor>Wilson Davila</LastAuthor>' + CRLF
cXml += '<Created>2021-03-16T13:17:33Z</Created>' + CRLF
cXml += '<LastSaved>2021-03-16T14:33:56Z</LastSaved>' + CRLF
cXml += '<Version>16.00</Version>' + CRLF
cXml += '</DocumentProperties>' + CRLF
cXml += '<OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">' + CRLF
cXml += '<AllowPNG/>' + CRLF
cXml += '</OfficeDocumentSettings>' + CRLF
cXml += '<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">' + CRLF
cXml += '<WindowHeight>7635</WindowHeight>' + CRLF
cXml += '<WindowWidth>20490</WindowWidth>' + CRLF
cXml += '<WindowTopX>32767</WindowTopX>' + CRLF
cXml += '<WindowTopY>32767</WindowTopY>' + CRLF
cXml += '<ProtectStructure>False</ProtectStructure>' + CRLF
cXml += '<ProtectWindows>False</ProtectWindows>' + CRLF
cXml += '</ExcelWorkbook>' + CRLF
cXml += '<Styles>' + CRLF
cXml += '<Style ss:ID="Default" ss:Name="Normal">' + CRLF
cXml += '<Alignment ss:Vertical="Bottom"/>' + CRLF
cXml += '<Borders/>' + CRLF
cXml += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' + CRLF
cXml += '<Interior/>' + CRLF
cXml += '<NumberFormat/>' + CRLF
cXml += '<Protection/>' + CRLF
cXml += '</Style>' + CRLF
cXml += '<Style ss:ID="s16" ss:Name="Vírgula">' + CRLF
cXml += '<NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>' + CRLF
cXml += '</Style>' + CRLF
cXml += '<Style ss:ID="s62">' + CRLF
cXml += '<NumberFormat ss:Format="@"/>' + CRLF
cXml += '</Style>' + CRLF
cXml += '<Style ss:ID="s63" ss:Parent="s16">' + CRLF
cXml += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' + CRLF
cXml += '</Style>' + CRLF

cXml += '<Style ss:ID="s66" ss:Parent="s16">' + CRLF
cXml += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' + CRLF
cXml += '<NumberFormat ss:Format="_-* #,####0.0000_-;\-* #,####0.0000_-;_-* &quot;-&quot;??_-;_-@_-"/>' + CRLF

cXml += '</Style>' + CRLF
cXml += '<Style ss:ID="s68" ss:Parent="s16">' + CRLF
cXml += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' + CRLF
cXml += '<NumberFormat ss:Format="_-* #,##0_-;\-* #,##0_-;_-* &quot;-&quot;??_-;_-@_-"/>' + CRLF
cXml += '</Style>' + CRLF
cXml += '<Style ss:ID="s73">' + CRLF
cXml += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFD966"/>' + CRLF
cXml += '<Interior ss:Color="#44546A" ss:Pattern="Solid"/>' + CRLF
cXml += '<NumberFormat ss:Format="@"/>' + CRLF
cXml += '</Style>' + CRLF
cXml += '<Style ss:ID="s74">' + CRLF
cXml += '<Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
cXml += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFD966"/>' + CRLF
cXml += '<Interior ss:Color="#44546A" ss:Pattern="Solid"/>' + CRLF
cXml += '</Style>' + CRLF
cXml += '<Style ss:ID="s76">' + CRLF
cXml += '<Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
cXml += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFD966"/>' + CRLF
cXml += '<Interior ss:Color="#44546A" ss:Pattern="Solid"/>' + CRLF
cXml += '<NumberFormat ss:Format="@"/>' + CRLF
cXml += '</Style>' + CRLF
cXml += '<Style ss:ID="s77" ss:Parent="s16">' + CRLF
cXml += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' + CRLF
cXml += '<NumberFormat ss:Format="@"/>' + CRLF
cXml += '</Style>' + CRLF
cXml += '<Style ss:ID="s80" ss:Parent="s16">' + CRLF
cXml += '<Alignment ss:Vertical="Bottom"/>' + CRLF
cXml += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' + CRLF
cXml += '<NumberFormat ss:Format="_-* #,##0_-;\-* #,##0_-;_-* &quot;-&quot;??_-;_-@_-"/>' + CRLF
cXml += '</Style>' + CRLF
cXml += '</Styles>' + CRLF

cXml += '<Worksheet ss:Name="RESUMO">' + CRLF
cXml += '<Table x:FullColumns="1"' + CRLF
cXml += 'x:FullRows="1" ss:DefaultRowHeight="15">' + CRLF
cXml += '<Column ss:StyleID="s62" ss:Width="46.5"/>' + CRLF
cXml += '<Column ss:StyleID="s62" ss:Width="266.25"/>' + CRLF
cXml += '<Column ss:AutoFitWidth="0" ss:Width="77.25" ss:Span="7"/>' + CRLF
cXml += '<Row ss:AutoFitHeight="0" ss:Height="16.5">' + CRLF
cXml += '<Cell ss:StyleID="s73"><Data ss:Type="String">COD.TRA</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s73"><Data ss:Type="String">TRANSPORTADORA</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">FRETE</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">BONIF. TOT. R$</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">BONIF. R$/KM</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">ADC.IMPOSTO</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">TOTAL RECEBER</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">TOTAL KM</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">TOTAL LITROS</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">CUSTO P/KM</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">CUSTO P/LITRO</Data></Cell>' + CRLF
cXml += '</Row>' + CRLF

fWrite(nHdlimp,cXml)

BeginSql alias cAlias
    %noparser%

    SELECT PC6_CODTRA,PC6_TRANSP,PC6_VRFRT,PC6_VRBON,PC6_VRIMP,PC6_VRTOT,PC6_TOTKM,PC6_TOTLIT,PC6_CUSTKM,PC6_CUSTLT
    FROM %Table:PC6% PC6
    WHERE PC6.%notDel% AND PC6_FILIAL=%Exp:cFilAnt% AND PC6_PERIOD=%Exp:MV_PAR01%
    ORDER BY PC6_CODTRA
EndSql

While (cAlias)->( !Eof() )

    cXml := '<Row>' + CRLF
    cXml += '<Cell><Data ss:Type="String">' + (cAlias)->(PC6_CODTRA) + '</Data></Cell>' + CRLF
    cXml += '<Cell><Data ss:Type="String">' + AllTrim((cAlias)->(PC6_TRANSP)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s63"><Data ss:Type="Number">' + cValToCHar((cAlias)->(PC6_VRFRT)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s63"><Data ss:Type="Number">' + cValToCHar((cAlias)->(PC6_VRBON)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s66"><Data ss:Type="Number">' + cValToCHar((cAlias)->(PC6_VRBON)/(cAlias)->(PC6_TOTKM)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s63"><Data ss:Type="Number">' + cValToCHar((cAlias)->(PC6_VRIMP)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s63"><Data ss:Type="Number">' + cValToCHar((cAlias)->(PC6_VRTOT)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s66"><Data ss:Type="Number">' + cValToCHar((cAlias)->(PC6_TOTKM)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s68"><Data ss:Type="Number">' + cValToCHar((cAlias)->(PC6_TOTLIT)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s66"><Data ss:Type="Number">' + cValToCHar((cAlias)->(PC6_CUSTKM)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s66"><Data ss:Type="Number">' + cValToCHar((cAlias)->(PC6_CUSTLT)) + '</Data></Cell>' + CRLF
    cXml += '</Row>' + CRLF

    fWrite(nHdlimp,cXml)

    (cAlias)->( dbSkip() )

EndDo

(cAlias)->( dbCloseArea() )


cXml := '</Table>' + CRLF
cXml += '<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' + CRLF
cXml += '<PageSetup>' + CRLF
cXml += '<Header x:Margin="0.31496062000000002"/>' + CRLF
cXml += '<Footer x:Margin="0.31496062000000002"/>' + CRLF
cXml += '<PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"' + CRLF
cXml += 'x:Right="0.511811024" x:Top="0.78740157499999996"/>' + CRLF
cXml += '</PageSetup>' + CRLF
cXml += '<Print>' + CRLF
cXml += '<ValidPrinterInfo/>' + CRLF
cXml += '<PaperSizeIndex>9</PaperSizeIndex>' + CRLF
cXml += '<VerticalResolution>0</VerticalResolution>' + CRLF
cXml += '</Print>' + CRLF
cXml += '<Selected/>' + CRLF
cXml += '<FreezePanes/>' + CRLF
cXml += '<FrozenNoSplit/>' + CRLF
cXml += '<SplitHorizontal>1</SplitHorizontal>' + CRLF
cXml += '<TopRowBottomPane>1</TopRowBottomPane>' + CRLF
cXml += '<ActivePane>2</ActivePane>' + CRLF
cXml += '<Panes>' + CRLF
cXml += '<Pane>' + CRLF
cXml += '<Number>3</Number>' + CRLF
cXml += '</Pane>' + CRLF
cXml += '<Pane>' + CRLF
cXml += '<Number>2</Number>' + CRLF
cXml += '<ActiveRow>0</ActiveRow>' + CRLF
cXml += '</Pane>' + CRLF
cXml += '</Panes>' + CRLF
cXml += '<ProtectObjects>False</ProtectObjects>' + CRLF
cXml += '<ProtectScenarios>False</ProtectScenarios>' + CRLF
cXml += '</WorksheetOptions>' + CRLF
cXml += '</Worksheet>' + CRLF

cXml += '<Worksheet ss:Name="LINHAS">' + CRLF
cXml += '<Table ss:ExpandedColumnCount="13" x:FullColumns="1"' + CRLF
cXml += 'x:FullRows="1" ss:DefaultRowHeight="15">' + CRLF
cXml += '<Column ss:StyleID="s62" ss:Width="46.5"/>' + CRLF
cXml += '<Column ss:StyleID="s62" ss:Width="266.25"/>' + CRLF
cXml += '<Column ss:StyleID="s62" ss:Width="43.5"/>' + CRLF
cXml += '<Column ss:StyleID="s62" ss:Width="210"/>' + CRLF
cXml += '<Column ss:StyleID="s62" ss:Width="51"/>' + CRLF
cXml += '<Column ss:AutoFitWidth="0" ss:Width="77.25" ss:Span="7"/>' + CRLF

cXml += '<Row ss:AutoFitHeight="0" ss:Height="16.5">' + CRLF
cXml += '<Cell ss:StyleID="s73"><Data ss:Type="String">COD.TRA</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s73"><Data ss:Type="String">TRANSPORTADORA</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s73"><Data ss:Type="String">COD.LIN</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s73"><Data ss:Type="String">LINHA</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s73"><Data ss:Type="String">TIPO</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">FRETE</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">BONIF. TOT. R$</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">ADC.IMPOSTO</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">TOTAL RECEBER</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">TOTAL KM</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">TOTAL LITROS</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">CUSTO P/KM</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">CUSTO P/LITRO</Data></Cell>' + CRLF
cXml += '</Row>' + CRLF

fWrite(nHdlimp,cXml)

BeginSql alias cAlias
    %noparser%

    SELECT PC7_CODTRA,PC6_TRANSP,PC7_LINHA,PA7_DESC,
    CASE WHEN PC7_TIPO='S' THEN 'SOCORRO' ELSE 'NORMAL' END AS TIPO,
    PC7_TOTFRT,PC7_TOTBON,PC7_ENCARG,PC7_TOTGER,PC7_TOTKM,PC7_TOTLIT,PC7_FRETKM,PC7_CUSLIT
    FROM %Table:PC7% PC7
    INNER JOIN %Table:PA7% PA7 ON PA7_FILIAL=PC7_FILIAL AND PA7_CODLIN=PC7_LINHA AND PA7.%notDel%
    INNER JOIN %Table:PC6% PC6 ON PC6_FILIAL=PC7_FILIAL AND PC6_CODTRA=PC7_CODTRA AND PC7_PERIOD=PC6_PERIOD AND PC6.%notDel%
    WHERE PC7.%notDel% AND PC7_PERIOD=%Exp:MV_PAR01% AND PC7_FILIAL=%Exp:cFilAnt%
    ORDER BY PC6_CODTRA,PC7_LINHA

EndSql

While (cAlias)->( !Eof() )

    cXml := '<Row>' + CRLF
    cXml += '<Cell><Data ss:Type="String">' + (cAlias)->(PC7_CODTRA) + '</Data></Cell>' + CRLF
    cXml += '<Cell><Data ss:Type="String">' + AllTrim((cAlias)->(PC6_TRANSP)) + '</Data></Cell>' + CRLF
    cXml += '<Cell><Data ss:Type="String">' + (cAlias)->(PC7_LINHA) + '</Data></Cell>' + CRLF
    cXml += '<Cell><Data ss:Type="String">' + AllTrim((cAlias)->(PA7_DESC)) + '</Data></Cell>' + CRLF
    cXml += '<Cell><Data ss:Type="String">' + AllTrim((cAlias)->(TIPO)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s63"><Data ss:Type="Number">' + cValToChar((cAlias)->(PC7_TOTFRT)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s63"><Data ss:Type="Number">' + cValToChar((cAlias)->(PC7_TOTBON)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s63"><Data ss:Type="Number">' + cValToChar((cAlias)->(PC7_ENCARG)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s63"><Data ss:Type="Number">' + cValToChar((cAlias)->(PC7_TOTGER)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s66"><Data ss:Type="Number">' + cValToChar((cAlias)->(PC7_TOTKM)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s68"><Data ss:Type="Number">' + cValToChar((cAlias)->(PC7_TOTLIT)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s66"><Data ss:Type="Number">' + cValToChar((cAlias)->(PC7_FRETKM)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s66"><Data ss:Type="Number">' + cValToChar((cAlias)->(PC7_CUSLIT)) + '</Data></Cell>' + CRLF
    cXml += '</Row>' + CRLF

    fWrite(nHdlimp,cXml)

    (cAlias)->( dbSkip() )

EndDo

(cAlias)->( dbCloseArea() )

cXml := '</Table>' + CRLF
cXml += '<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' + CRLF
cXml += '<PageSetup>' + CRLF
cXml += '<Header x:Margin="0.31496062000000002"/>' + CRLF
cXml += '<Footer x:Margin="0.31496062000000002"/>' + CRLF
cXml += '<PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"' + CRLF
cXml += 'x:Right="0.511811024" x:Top="0.78740157499999996"/>' + CRLF
cXml += '</PageSetup>' + CRLF
cXml += '<Print>' + CRLF
cXml += '<ValidPrinterInfo/>' + CRLF
cXml += '<PaperSizeIndex>9</PaperSizeIndex>' + CRLF
cXml += '<VerticalResolution>0</VerticalResolution>' + CRLF
cXml += '</Print>' + CRLF
cXml += '<FreezePanes/>' + CRLF
cXml += '<FrozenNoSplit/>' + CRLF
cXml += '<SplitHorizontal>1</SplitHorizontal>' + CRLF
cXml += '<TopRowBottomPane>1</TopRowBottomPane>' + CRLF
cXml += '<SplitVertical>5</SplitVertical>' + CRLF
cXml += '<LeftColumnRightPane>5</LeftColumnRightPane>' + CRLF
cXml += '<ActivePane>0</ActivePane>' + CRLF
cXml += '<Panes>' + CRLF
cXml += '<Pane>' + CRLF
cXml += '<Number>3</Number>' + CRLF
cXml += '</Pane>' + CRLF
cXml += '<Pane>' + CRLF
cXml += '<Number>1</Number>' + CRLF
cXml += '</Pane>' + CRLF
cXml += '<Pane>' + CRLF
cXml += '<Number>2</Number>' + CRLF
cXml += '</Pane>' + CRLF
cXml += '<Pane>' + CRLF
cXml += '<Number>0</Number>' + CRLF
cXml += '<ActiveCol>0</ActiveCol>' + CRLF
cXml += '</Pane>' + CRLF
cXml += '</Panes>' + CRLF
cXml += '<ProtectObjects>False</ProtectObjects>' + CRLF
cXml += '<ProtectScenarios>False</ProtectScenarios>' + CRLF
cXml += '</WorksheetOptions>' + CRLF
cXml += '</Worksheet>' + CRLF

cXml += '<Worksheet ss:Name="RESUMO BONIF">' + CRLF
cXml += '<Table ss:ExpandedColumnCount="5" x:FullColumns="1"' + CRLF
cXml += 'x:FullRows="1" ss:DefaultRowHeight="15">' + CRLF
cXml += '<Column ss:StyleID="s62" ss:Width="46.5"/>' + CRLF
cXml += '<Column ss:StyleID="s62" ss:Width="266.25"/>' + CRLF
cXml += '<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="56.25"/>' + CRLF
cXml += '<Column ss:StyleID="s62" ss:Width="205.5"/>' + CRLF
cXml += '<Column ss:AutoFitWidth="0" ss:Width="77.25"/>' + CRLF

cXml += '<Row ss:AutoFitHeight="0" ss:Height="16.5">' + CRLF
cXml += '<Cell ss:StyleID="s73"><Data ss:Type="String">COD.TRA</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s73"><Data ss:Type="String">TRANSPORTADORA</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s76"><Data ss:Type="String">COD.BON</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s76"><Data ss:Type="String">DESCRICAO BONIFICACAO</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">TOT.BONIF.</Data></Cell>' + CRLF
cXml += '</Row>' + CRLF

fWrite(nHdlimp,cXml)

BeginSql alias cAlias
    %noparser%

    SELECT PC8_CODTRA,PC6_TRANSP,PC8_CODBON,PC8_DESCRI,PC8_TOTBON
    FROM %Table:PC8% PC8
    INNER JOIN %Table:PC6% PC6 ON PC6_FILIAL=PC8_FILIAL AND PC6_CODTRA=PC8_CODTRA AND PC8_PERIOD=PC6_PERIOD AND PC6.%notDel%
    WHERE PC8.%notDel% AND PC8_PERIOD=%Exp:MV_PAR01% AND PC8_FILIAL=%Exp:cFilAnt%
    ORDER BY PC8_CODTRA,PC8_CODBON


EndSql

While (cAlias)->( !Eof() )

cXml := '<Row>' + CRLF
cXml += '<Cell><Data ss:Type="String">' + (cAlias)->(PC8_CODTRA) + '</Data></Cell>' + CRLF
cXml += '<Cell><Data ss:Type="String">' + AllTrim((cAlias)->(PC6_TRANSP)) + '</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s77"><Data ss:Type="String">' + (cAlias)->(PC8_CODBON) + '</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s77"><Data ss:Type="String">' + AllTrim((cAlias)->(PC8_DESCRI)) + '</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s63"><Data ss:Type="Number">' + cValToChar((cAlias)->(PC8_TOTBON)) + '</Data></Cell>' + CRLF
cXml += '</Row>' + CRLF

    fWrite(nHdlimp,cXml)

    (cAlias)->( dbSkip() )

EndDo

(cAlias)->( dbCloseArea() )


cXml := '</Table>' + CRLF
cXml += '<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' + CRLF
cXml += '<PageSetup>' + CRLF
cXml += '<Header x:Margin="0.31496062000000002"/>' + CRLF
cXml += '<Footer x:Margin="0.31496062000000002"/>' + CRLF
cXml += '<PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"' + CRLF
cXml += 'x:Right="0.511811024" x:Top="0.78740157499999996"/>' + CRLF
cXml += '</PageSetup>' + CRLF
cXml += '<Print>' + CRLF
cXml += '<ValidPrinterInfo/>' + CRLF
cXml += '<PaperSizeIndex>9</PaperSizeIndex>' + CRLF
cXml += '<VerticalResolution>0</VerticalResolution>' + CRLF
cXml += '</Print>' + CRLF
cXml += '<FreezePanes/>' + CRLF
cXml += '<FrozenNoSplit/>' + CRLF
cXml += '<SplitHorizontal>1</SplitHorizontal>' + CRLF
cXml += '<TopRowBottomPane>1</TopRowBottomPane>' + CRLF
cXml += '<ActivePane>2</ActivePane>' + CRLF
cXml += '<Panes>' + CRLF
cXml += '<Pane>' + CRLF
cXml += '<Number>3</Number>' + CRLF
cXml += '</Pane>' + CRLF
cXml += '<Pane>' + CRLF
cXml += '<Number>2</Number>' + CRLF
cXml += '</Pane>' + CRLF
cXml += '</Panes>' + CRLF
cXml += '<ProtectObjects>False</ProtectObjects>' + CRLF
cXml += '<ProtectScenarios>False</ProtectScenarios>' + CRLF
cXml += '</WorksheetOptions>' + CRLF
cXml += '</Worksheet>' + CRLF

cXml += '<Worksheet ss:Name="BONIF.DETALHE">' + CRLF
cXml += '<Table x:FullColumns="1"' + CRLF
cXml += 'x:FullRows="1" ss:DefaultRowHeight="15">' + CRLF
cXml += '<Column ss:StyleID="s62" ss:Width="46.5"/>' + CRLF
cXml += '<Column ss:StyleID="s62" ss:Width="266.25"/>' + CRLF
cXml += '<Column ss:StyleID="s62" ss:Width="46.5"/>' + CRLF
cXml += '<Column ss:StyleID="s62" ss:Width="46.5"/>' + CRLF
cXml += '<Column ss:StyleID="s62" ss:Width="182.25"/>' + CRLF

cXml += '<Column ss:Width="59.25"/>' + CRLF
cXml += '<Column ss:Width="58.5"/>' + CRLF
cXml += '<Column ss:AutoFitWidth="0" ss:Width="49.5"/>' + CRLF
cXml += '<Column ss:Width="59.25"/>' + CRLF
cXml += '<Column ss:Width="52.5"/>' + CRLF

cXml += '<Row ss:AutoFitHeight="0" ss:Height="16.5">' + CRLF
cXml += '<Cell ss:StyleID="s73"><Data ss:Type="String">COD.TRA</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s73"><Data ss:Type="String">TRANSPORTADORA</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s73"><Data ss:Type="String">COD.LINHA</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s76"><Data ss:Type="String">CODBON</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s76"><Data ss:Type="String">DESCBON</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">CONFORME</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">NAO CONF.</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">TOTAL</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">RESULTADO</Data></Cell>' + CRLF
cXml += '<Cell ss:StyleID="s74"><Data ss:Type="String">VR. BONIF</Data></Cell>' + CRLF
cXml += '</Row>' + CRLF


fWrite(nHdlimp,cXml)

   BeginSql Alias cAlias

        %noparser%

        //APONTAMENTO MULTIPLO O SISTEMA CONTA O NUMERO DE INTENS NAO CONFORME E PAGA PELO NUMERO DE ITENS NAO CONFORME

        SELECT DISTINCT 'Q' AS TPBON,PC5_CODTRA,PC5_LINHA,
        (SELECT PC6_TRANSP FROM %Table:PC6% PC6 WHERE PC6_CODTRA=PC5_CODTRA AND PC6_FILIAL=%Exp:cFilAnt% AND PC6_PERIOD=%Exp:MV_PAR01% AND PC6.%notDel%) AS 'TRANSP',
        PC5_CODBON,
        (SELECT PBD_DESCR FROM %Table:PBD%  PBD WHERE PBD_FILIAL=%Exp:cFilAnt% AND PBD_CODIGO=SUBSTRING(PC5_CODBON,4,3)
        AND PBD_CODTIP = SUBSTRING(PC5_CODBON,1,2) AND PBD.%notDel%) AS 'DESCBON',

        ISNULL((SELECT SUM(PC5_ITAPON) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'M' AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notDel%
        AND PC5A.PC5_FILIAL=PC5.PC5_FILIAL AND PC5A.PC5_CODBON=PC5.PC5_CODBON  AND PC5_STATUS='A' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA),0) AS 'CONFORME',

        ISNULL((SELECT SUM(PC5_ITAPON) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'M' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notDel%
        AND PC5B.PC5_FILIAL=PC5.PC5_FILIAL AND PC5B.PC5_CODBON=PC5.PC5_CODBON AND PC5_STATUS='N' AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA),0) AS 'NAOCONFO',

        ISNULL((SELECT SUM(PC5_ITAPON) FROM %Table:PC5% PC5C WHERE PC5_TPAPOM = 'M' AND PC5C.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5C.%notDel%
        AND PC5C.PC5_FILIAL=PC5.PC5_FILIAL AND PC5C.PC5_CODBON=PC5.PC5_CODBON AND PC5C.PC5_CODTRA=PC5.PC5_CODTRA),0) AS 'TOTAL',

        ISNULL((SELECT SUM(PC5_ITAPON) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'M' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notDel%
        AND PC5B.PC5_FILIAL=PC5.PC5_FILIAL AND PC5B.PC5_CODBON=PC5.PC5_CODBON AND PC5_STATUS='N' AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA),0) AS 'RESULT',

        ISNULL((SELECT PBH_VRESUL FROM %Table:PBH% PBH WHERE PBH_FILIAL=%Exp:cFilAnt% AND PBH_CODIGO=SUBSTRING(PC5_CODBON,1,2) AND PBH_CODITE=SUBSTRING(PC5_CODBON,4,3)
        AND ((ISNULL((SELECT SUM(PC5_ITAPON) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'M' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notDel%
        AND PC5B.PC5_FILIAL=PC5.PC5_FILIAL AND PC5B.PC5_CODBON=PC5.PC5_CODBON AND PC5_STATUS='N' AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA),0)) >= PBH_VINIC
        AND (ISNULL((SELECT SUM(PC5_ITAPON) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'M' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notDel%
        AND PC5B.PC5_FILIAL=PC5.PC5_FILIAL AND PC5B.PC5_CODBON=PC5.PC5_CODBON AND PC5_STATUS='N' AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA),0)) <= PBH_VFINAL ) AND PBH.%notDel%),0) AS 'VR_BON'

        FROM %Table:PC5% PC5 WHERE PC5_PERIOD=%Exp:MV_PAR01% AND PC5.%notDel% AND PC5_TPAPOM = 'M' AND PC5_FILIAL=%Exp:cFilAnt%

        UNION ALL

        //APONTAMENTO SIMPLES CONFORME OU NAO CONFORME SISTEMA CONTA O % DE ITENS EM CONFORMIDADE E PAGA PELO %

        SELECT DISTINCT 'Q' AS TPBON,PC5_CODTRA,PC5_LINHA,
        (SELECT PC6_TRANSP FROM %Table:PC6% PC6 WHERE PC6_CODTRA=PC5_CODTRA AND PC6_FILIAL=%Exp:cFilAnt% AND PC6_PERIOD=%Exp:MV_PAR01% AND PC6.%notDel%) AS 'TRANSP',
        PC5_CODBON,
        (SELECT PBD_DESCR FROM %Table:PBD% PBD WHERE PBD_FILIAL=%Exp:cFilAnt% AND PBD_CODIGO=SUBSTRING(PC5_CODBON,4,3) AND PBD_CODTIP = SUBSTRING(PC5_CODBON,1,2) AND PBD.%notDel%) AS 'DESCBON',
        (SELECT COUNT(PC5_STATUS) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'A' AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notDel%
        AND PC5A.PC5_FILIAL=PC5.PC5_FILIAL AND PC5A.PC5_CODBON=PC5.PC5_CODBON AND PC5_STATUS='C' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA) AS 'CONFORME',

        (SELECT COUNT(PC5_STATUS) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'A' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notDel%
        AND PC5B.PC5_FILIAL=PC5.PC5_FILIAL AND PC5B.PC5_CODBON=PC5.PC5_CODBON AND PC5_STATUS='N' AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA) AS 'NAOCONFO',

        (SELECT COUNT(PC5_STATUS) FROM %Table:PC5% PC5C WHERE PC5_TPAPOM = 'A' AND PC5C.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5C.%notDel%
        AND PC5C.PC5_FILIAL=PC5.PC5_FILIAL AND PC5C.PC5_CODBON=PC5.PC5_CODBON AND PC5C.PC5_CODTRA=PC5.PC5_CODTRA) AS 'TOTAL',

        ROUND(((SELECT CAST(COUNT(PC5_STATUS) AS float) FROM %Table:PC5% PC5D WHERE PC5_TPAPOM = 'A'
        AND PC5D.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5D.%notDel%
        AND PC5D.PC5_FILIAL=PC5.PC5_FILIAL AND PC5D.PC5_CODBON=PC5.PC5_CODBON AND PC5_STATUS='C' AND PC5D.PC5_CODTRA=PC5.PC5_CODTRA)/
        (SELECT CAST(COUNT(PC5_STATUS) AS float) FROM %Table:PC5% PC5E WHERE PC5_TPAPOM = 'A' AND PC5E.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5E.%notDel%
        AND PC5E.PC5_FILIAL=PC5.PC5_FILIAL AND PC5E.PC5_CODBON=PC5.PC5_CODBON AND PC5E.PC5_CODTRA=PC5.PC5_CODTRA))*100,0) AS 'RESULT',

        ISNULL((SELECT PBH_VRESUL FROM %Table:PBH% PBH WHERE PBH_FILIAL=%Exp:cFilAnt% AND PBH_CODIGO=SUBSTRING(PC5_CODBON,1,2) AND PBH_CODITE=SUBSTRING(PC5_CODBON,4,3)
        AND ((ISNULL((ROUND(((SELECT CAST(COUNT(PC5_STATUS) AS float) FROM %Table:PC5% PC5D WHERE PC5_TPAPOM = 'A'
        AND PC5D.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5D.%notDel%
        AND PC5D.PC5_FILIAL=PC5.PC5_FILIAL AND PC5D.PC5_CODBON=PC5.PC5_CODBON AND PC5_STATUS='C' AND PC5D.PC5_CODTRA=PC5.PC5_CODTRA)/
        (SELECT CAST(COUNT(PC5_STATUS) AS float) FROM %Table:PC5% PC5E WHERE PC5_TPAPOM = 'A' AND PC5E.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5E.%notDel%
        AND PC5E.PC5_FILIAL=PC5.PC5_FILIAL AND PC5E.PC5_CODBON=PC5.PC5_CODBON AND PC5E.PC5_CODTRA=PC5.PC5_CODTRA))*100,0)),0)) >= PBH_VINIC
        AND (ISNULL(((ROUND(((SELECT CAST(COUNT(PC5_STATUS) AS float) FROM %Table:PC5% PC5D WHERE PC5_TPAPOM = 'A'
        AND PC5D.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5D.%notDel%
        AND PC5D.PC5_FILIAL=PC5.PC5_FILIAL AND PC5D.PC5_CODBON=PC5.PC5_CODBON AND PC5_STATUS='C' AND PC5D.PC5_CODTRA=PC5.PC5_CODTRA)/
        (SELECT CAST(COUNT(PC5_STATUS) AS float) FROM %Table:PC5% PC5E WHERE PC5_TPAPOM = 'A' AND PC5E.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5E.%notDel%
        AND PC5E.PC5_FILIAL=PC5.PC5_FILIAL AND PC5E.PC5_CODBON=PC5.PC5_CODBON AND PC5E.PC5_CODTRA=PC5.PC5_CODTRA))*100,0))),0)) <= PBH_VFINAL ) AND PBH.%notDel%),0) AS 'VR_BON'

        FROM %Table:PC5% PC5 WHERE PC5_PERIOD=%Exp:MV_PAR01% AND PC5.%notDel% AND PC5_TPAPOM = 'A' AND PC5_FILIAL=%Exp:cFilAnt%

        UNION ALL

        //APONTAMENTO PONTOS CONFORME OU NAO CONFORME O SISTEMA SOMA OS PONTOS PELO PESO DIVIDE PELO NUMERO DE FREQUENCIA DE COLETAS MES

        SELECT DISTINCT 'Q' AS TPBON,PC5_CODTRA,PC5_LINHA,
        (SELECT PC6_TRANSP FROM %Table:PC6% PC6 WHERE PC6_CODTRA=PC5_CODTRA AND PC6_FILIAL=%Exp:cFilAnt% AND PC6_PERIOD=%Exp:MV_PAR01% AND PC6.%notDel%) AS 'TRANSP',

        '03.000' AS PC5_CODBON,'SEGURANCA TRAB. --> TOTAL' AS 'DESCBON',
        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'P' AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notDel%
        AND PC5A.PC5_FILIAL=PC5.PC5_FILIAL AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='C' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'P' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notDel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='C' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0) AS 'CONFORME',

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'P' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notDel%
        AND PC5B.PC5_FILIAL=PC5.PC5_FILIAL AND SUBSTRING(PC5B.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='N' AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'P' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notDel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='N' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0) AS 'NAOCONFO',

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5C WHERE PC5_TPAPOM = 'P' AND PC5C.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5C.%notDel%
        AND PC5C.PC5_FILIAL=PC5.PC5_FILIAL AND SUBSTRING(PC5C.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5C.PC5_CODTRA=PC5.PC5_CODTRA)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'P' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notDel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0) AS 'TOTAL',

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'P' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notDel%
        AND PC5B.PC5_FILIAL=PC5.PC5_FILIAL AND SUBSTRING(PC5B.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='C' AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'P' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notDel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='C' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)/2 AS 'RESULT',

        ISNULL((SELECT PBH_VRESUL FROM %Table:PBH% PBH WHERE PBH_FILIAL=%Exp:cFilAnt% AND PBH_CODIGO=SUBSTRING(PC5_CODBON,1,2) AND PBH_CODITE=SUBSTRING(PC5_CODBON,4,3)
        AND ((ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'P' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notDel%
        AND PC5B.PC5_FILIAL=PC5.PC5_FILIAL AND SUBSTRING(PC5B.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='C' AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'P' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notDel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='C' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%)/2,0)) >= PBH_VINIC
        AND (ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'P' AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notDel%
        AND PC5B.PC5_FILIAL=PC5.PC5_FILIAL AND SUBSTRING(PC5B.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='C' AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'P' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notDel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='C' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%)/2,0)) <= PBH_VFINAL ) AND PBH.%notDel%),0) AS 'VR_BON'

        FROM %Table:PC5% PC5 WHERE PC5_PERIOD=%Exp:MV_PAR01% AND PC5.%notDel% AND PC5_TPAPOM = 'P' AND PC5_FILIAL=%Exp:cFilAnt%

        UNION ALL

        SELECT 'Q' AS 'TPBON',PC5_CODTRA,PC5_LINHA,(SELECT PC6_TRANSP FROM %Table:PC6% PC6 WHERE PC6_CODTRA=PC5_CODTRA AND PC6_PERIOD=%Exp:MV_PAR01% AND PC6.%notdel%) AS 'TRANSP',
        PC5_CODBON,LTRIM(RTRIM((SELECT PBD_DESCR FROM %Table:PBD% PBD WHERE PBD_CODIGO=SUBSTRING(PC5_CODBON,4,3) AND PBD_CODTIP = SUBSTRING(PC5_CODBON,1,2)
        AND PBD.%notdel%)))+' ('+CAST(PC5_ITAPON AS varchar)+')' AS 'DESCBON',
        CASE WHEN PC5_STATUS='C'  THEN PC5_PESO ELSE 0 END AS 'CONFORME',
        CASE WHEN PC5_STATUS<>'C' THEN PC5_PESO ELSE 0 END AS 'NAOCONFO',
        PC5_PESO AS TOTAL,CASE WHEN PC5_STATUS='C' THEN PC5_PESO ELSE 0 END AS 'RESULT',0 AS 'VR_BON'
        FROM %Table:PC5% PC5
        WHERE PC5_PERIOD=%Exp:MV_PAR01% AND PC5_CODBON LIKE '03%' AND PC5.%notdel%

        UNION ALL

        //DOCUMENTACAO O SISTEMA CONTA CADA DOCUMENTO EM CONFORMIDADE COM SEUS PESOS E PAGA PELA SOMA DA PONTUACAO

        SELECT DISTINCT 'Q' AS TPBON, PC5_CODTRA,PC5_LINHA,
        (SELECT PC6_TRANSP FROM %Table:PC6% PC6 WHERE PC6_CODTRA=PC5_CODTRA AND PC6_PERIOD=%Exp:MV_PAR01% AND PC6.%notdel% AND PC6_FILIAL=%Exp:cFilAnt%) AS 'TRANSP',
        '04.000' AS PC5_CODBON,'ASPECTOS LEGAIS --> TOTAL' AS 'DESCBON',

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%)
        /(SELECT COUNT(DISTINCT PC5_CODMOT) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='T' AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%),0) AS 'CONFORME',

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M'
        AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notdel%
        AND SUBSTRING(PC5B.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS IN ('S','V') AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA AND PC5B.PC5_FILIAL=%Exp:cFilAnt%)
        /(SELECT COUNT(DISTINCT PC5_CODMOT) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS IN ('S','V') AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notdel%
        AND SUBSTRING(PC5B.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS IN ('S','V') AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA AND PC5B.PC5_FILIAL=%Exp:cFilAnt%)
        /(SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS IN ('S','V') AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5B WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='T'
        AND PC5B.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5B.%notdel%
        AND SUBSTRING(PC5B.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS IN ('S','V') AND PC5B.PC5_CODTRA=PC5.PC5_CODTRA AND PC5B.PC5_FILIAL=%Exp:cFilAnt%),0) AS 'NAOCONFO',

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5C WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M'
        AND PC5C.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5C.%notdel%
        AND SUBSTRING(PC5C.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5C.PC5_CODTRA=PC5.PC5_CODTRA AND PC5C.PC5_FILIAL=%Exp:cFilAnt%)
        /(SELECT COUNT(DISTINCT PC5_CODMOT) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5C WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V' AND PC5C.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5C.%notdel%
        AND SUBSTRING(PC5C.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5C.PC5_CODTRA=PC5.PC5_CODTRA AND PC5C.PC5_FILIAL=%Exp:cFilAnt%)
        /(SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5C WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='T'
        AND PC5C.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5C.%notdel%
        AND SUBSTRING(PC5C.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5C.PC5_CODTRA=PC5.PC5_CODTRA AND PC5C.PC5_FILIAL=%Exp:cFilAnt%),0) AS 'TOTAL',

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%)
        /(SELECT COUNT(DISTINCT PC5_CODMOT) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='T'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%),0) AS 'RESULT',

        ISNULL((SELECT PBH_VRESUL FROM %Table:PBH% PBH WHERE PBH_CODIGO=SUBSTRING(PC5_CODBON,1,2) AND PBH_CODITE=SUBSTRING(PC5_CODBON,4,3)
        AND ((ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%)
        /(SELECT COUNT(DISTINCT PC5_CODMOT) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM PC5010 PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='T'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%),0)) >= PBH_VINIC

        AND (ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%)
        /(SELECT COUNT(DISTINCT PC5_CODMOT) FROM %Table:PC5% PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='M'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%)/
        (SELECT COUNT(DISTINCT PC5_CODVEI) FROM PC5010 PC5F WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='V'
        AND PC5F.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5F.%notdel%
        AND SUBSTRING(PC5F.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5F.PC5_CODTRA=PC5.PC5_CODTRA AND PC5F.PC5_FILIAL=%Exp:cFilAnt%),0)+

        ISNULL((SELECT SUM(PC5_PESO) FROM %Table:PC5% PC5A WHERE PC5_TPAPOM = 'D' AND PC5_TIPO='T'
        AND PC5A.PC5_LINHA=PC5.PC5_LINHA AND PC5_PERIOD=%Exp:MV_PAR01% AND PC5A.%notdel%
        AND SUBSTRING(PC5A.PC5_CODBON,1,2)=SUBSTRING(PC5.PC5_CODBON,1,2) AND PC5_STATUS='O' AND PC5A.PC5_CODTRA=PC5.PC5_CODTRA AND PC5A.PC5_FILIAL=%Exp:cFilAnt%),0)) <= PBH_VFINAL )

        AND PBH.%notdel% AND PBH.PBH_FILIAL=%Exp:cFilAnt%),0) AS 'VR_BON'

        FROM %Table:PC5% PC5 WHERE PC5_PERIOD=%Exp:MV_PAR01% AND PC5.%notDel% AND PC5_TPAPOM = 'D' AND PC5_FILIAL=%Exp:cFilAnt%

        UNION ALL

        SELECT 'Q' AS 'TPBON',PC5_CODTRA,PC5_LINHA,(SELECT PC6_TRANSP FROM %Table:PC6% PC6 WHERE PC6_CODTRA=PC5_CODTRA AND PC6_PERIOD=%Exp:MV_PAR01% AND PC6.%notdel%) AS 'TRANSP',
        PC5_CODBON,LTRIM(RTRIM((SELECT PBD_DESCR FROM %Table:PBD% PBD WHERE PBD_CODIGO=SUBSTRING(PC5_CODBON,4,3) AND PBD_CODTIP = SUBSTRING(PC5_CODBON,1,2)
        AND PBD.%notdel%)))+' ('+CAST(PC5_ITAPON AS varchar)+')' AS 'DESCBON',
        CASE WHEN PC5_STATUS='O'  THEN PC5_PESO ELSE 0 END AS 'CONFORME',
        CASE WHEN PC5_STATUS<>'O' THEN PC5_PESO ELSE 0 END AS 'NAOCONFO',
        PC5_PESO AS TOTAL,CASE WHEN PC5_STATUS='O' THEN PC5_PESO ELSE 0 END AS 'RESULT',0 AS 'VR_BON'
        FROM %Table:PC5% PC5
        WHERE PC5_PERIOD=%Exp:MV_PAR01% AND PC5_CODBON LIKE '04%' AND PC5.%notdel%

        UNION ALL

        SELECT 'F' AS TPBON,LBE_FORNEC AS PC5_CODTRA,'000000' AS PC5_LINHA,LBE_MOTO AS 'TRANSP',LJW_CODBON AS PC5_CODBON,
        LJS_DESC AS 'DESCBON',0 AS 'CONFORME',0 AS 'NAOCONFO',0 AS 'TOTAL',0 AS 'RESULT',LJW_VALOR AS 'VR_BON'
        FROM %Table:LJW% LJW
        INNER JOIN %Table:LJS% LJS ON LJS_CODBON=LJW_CODBON AND LJS_FILIAL=LJW_FILIAL AND LJS.%notDel%
        INNER JOIN %Table:LBE% LBE ON LBE_FILIAL=LJW_FILIAL AND LBE_CODCAM=LJW_CODCAR AND LBE_STATUS='S' AND LBE.%notDel%
        WHERE LJW.%notDel% AND LJW_PERIOD=%Exp:MV_PAR01% AND LJW_FILIAL=%Exp:cFilAnt%

        ORDER BY PC5_CODTRA,PC5_CODBON

    EndSql

While (cAlias)->( !Eof() )

    cXml := '<Row>' + CRLF
    cXml += '<Cell><Data ss:Type="String">' + (cAlias)->(PC5_CODTRA) + '</Data></Cell>' + CRLF
    cXml += '<Cell><Data ss:Type="String">' + AllTrim((cAlias)->(TRANSP)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s77"><Data ss:Type="String">' + (cAlias)->(PC5_LINHA) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s77"><Data ss:Type="String">' + (cAlias)->(PC5_CODBON) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s77"><Data ss:Type="String">' + AllTrim((cAlias)->(DESCBON)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s68"><Data ss:Type="Number">' + cValtoChar((cAlias)->(CONFORME)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s68"><Data ss:Type="Number">' + cValtoChar((cAlias)->(NAOCONFO)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s68"><Data ss:Type="Number">' + cValtoChar((cAlias)->(TOTAL)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s68"><Data ss:Type="Number">' + cValtoChar((cAlias)->(RESULT)) + '</Data></Cell>' + CRLF
    cXml += '<Cell ss:StyleID="s66"><Data ss:Type="Number">' + cValtoChar((cAlias)->(VR_BON)) + '</Data></Cell>' + CRLF
    cXml += '</Row>' + CRLF

    fWrite(nHdlimp,cXml)

    (cAlias)->( dbSkip() )

EndDo

(cAlias)->( dbCloseArea() )

cXml := '</Table>' + CRLF
cXml += '<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' + CRLF
cXml += '<PageSetup>' + CRLF
cXml += '<Header x:Margin="0.31496062000000002"/>' + CRLF
cXml += '<Footer x:Margin="0.31496062000000002"/>' + CRLF
cXml += '<PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"' + CRLF
cXml += 'x:Right="0.511811024" x:Top="0.78740157499999996"/>' + CRLF
cXml += '</PageSetup>' + CRLF
cXml += '<Print>' + CRLF
cXml += '<ValidPrinterInfo/>' + CRLF
cXml += '<PaperSizeIndex>9</PaperSizeIndex>' + CRLF
cXml += '<VerticalResolution>0</VerticalResolution>' + CRLF
cXml += '</Print>' + CRLF
cXml += '<FreezePanes/>' + CRLF
cXml += '<FrozenNoSplit/>' + CRLF
cXml += '<SplitHorizontal>1</SplitHorizontal>' + CRLF
cXml += '<TopRowBottomPane>1</TopRowBottomPane>' + CRLF
cXml += '<ActivePane>2</ActivePane>' + CRLF
cXml += '<Panes>' + CRLF
cXml += '<Pane>' + CRLF
cXml += '<Number>3</Number>' + CRLF
cXml += '</Pane>' + CRLF
cXml += '<Pane>' + CRLF
cXml += '<Number>2</Number>' + CRLF
cXml += '<ActiveRow>91</ActiveRow>' + CRLF
cXml += '<ActiveCol>6</ActiveCol>' + CRLF
cXml += '</Pane>' + CRLF
cXml += '</Panes>' + CRLF
cXml += '<ProtectObjects>False</ProtectObjects>' + CRLF
cXml += '<ProtectScenarios>False</ProtectScenarios>' + CRLF
cXml += '</WorksheetOptions>' + CRLF
cXml += '</Worksheet>' + CRLF
cXml += '</Workbook>' + CRLF


fWrite(nHdlimp,cXml)

fClose(nHdlImp)

nRet := ShellExecute("open", cArq, "", "", 1)

If nRet <= 32
    MsgStop("Não foi possível abrir o arquivo " +cArq+ "!", "Atenção")
EndIf


Return





