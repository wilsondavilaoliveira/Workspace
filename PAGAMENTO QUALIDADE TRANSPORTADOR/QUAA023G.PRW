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

Private oFonA7   	:= TFont():New("Arial Narrow (Ocidental)",,07,,.F.,,,,.F.,.F.)
Private oFonA10   	:= TFont():New("Arial Narrow",,10,,.F.,,,,.F.,.F.)
Private oFonA13   	:= TFont():New("Britannic Bold",,12,,.F.,,,,.F.,.F.)
Private oFonA15   	:= TFont():New("Arial Narrow",,15,,.F.,,,,.F.,.F.)
Private oFonA12n 	:= TFont():New("Arial Narrow (Ocidental)",,12,,.T.,,,,.F.,.F.)

If !Pergunte("QUAA023G",.T.)
    Return
Else
    MSAguarde( {||Processa()}    , "Aguarde..." ,"Carregando definições das bonificações...",.F.)
EndIf

Return

Static Function Processa()

Private aCoors	:= FWGetDialogSize( oMainWnd )
Private cCadastro	:= "APONTAMENTO DE BONIFICACOES"
Private oC1W1 		// Layer pricipal
Private oC1W2 		// Layer secundario
Private oButt1   		// Botoes para o Pedido
Private oPeriod
Private aTree := {}
Private i := 0
Private oDlg1
Private oTree1     := Nil
Private oTree2     := Nil
Private oTree3     := Nil
Private cNomeUsu := Alltrim(UsrRetName(__cUserId))

//bKeyF4 := SetKey( VK_F4 , Nil )
//SetKey( VK_F4 , { || PutObs() } )

cTxtTit:= "APONTAMENTO DE BONIFICAÇÕES TRANSPORTADOR/MOTORISTA -  Login:  "
cCadastro:= cTxtTit + cNomeUsu +  "       " + Dtoc(Ddatabase) + " - " + Time()

DEFINE FONT oFont4	NAME "Arial" 		SIZE 08,10	BOLD
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

oC1W1 := oFWLayer:getWinPanel( "Col01", "Win01" )
oC1W2 := oFWLayer:getWinPanel( "Col02", "Win01" )
oC1W3 := oFWLayer:getWinPanel( "Col03", "Win01" )

//Painel dos Botoes para Manutenções
oPanBotoes:=TPanel():New(1,3,,oDlg1,/*[aoFont]*/,,,/*CorTexto*/,/*CLR_GREEN*/,290,15,.T.,.T.)
oPanBotoes:ALIGN:= CONTROL_ALIGN_TOP

cPeriod := AllTrim(TRANSFORM(MV_PAR01,"@R 99/9999"))
@004.7,572 SAY "Periodo:"	SIZE 060,10 OF oDlg1 	PIXEL FONT oFont2 COLOR CLR_RED
@2.0,617 MSGET oPeriod VAR cPeriod	SIZE 035,10 WHEN .F. OF oDlg1 	PIXEL FONT oFont2

oButt1:= FWButtonBar():new()
oButt1:Init(oPanBotoes, 17, 25,CONTROL_ALIGN_TOP, .T. )
oButt1:addBtnImage( "final","Sair"                  ,{|| oDlg1:End()}   ,,.T.,CONTROL_ALIGN_LEFT)
oButt1:addBtnImage( "EXCLUIR","Deletar Apontamento" ,{|| DelApon()}     ,,.T.,CONTROL_ALIGN_LEFT)

CriaTree()

ACTIVATE MSDIALOG oDlg1

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

Local nRec      := Val(oTree:GetCargo())
Local cAlias    := GetNextAlias()
Local cStatus   := ''

    PC5->( dbGoto( Val( oTree:GetCargo() ) ) )

    BeginSql Alias cAlias
        %noparser%
        SELECT PBD_DESCR FROM %Table:PBD% PBD WHERE PBD.%notDel% AND PBD_CODTIP+'.'+PBD_CODIGO=%Exp:PC5->(PC5_CODBON)% AND PBD_FILIAL=%Exp:PC5->(PC5_FILIAL)%
    EndSql

    If oTree:Nivel() == 2 .AND. PC5->(PC5_TPAPOM) == 'A'
        If PC5->(PC5_STATUS) == 'A'
            oTree:ChangePrompt(oTree:GetPrompt(.T.) +"-"+dToc(Ddatabase)+"-"+cNomeUsu,oTree:GetCargo())
            oTree:ChangeBmp("CHECKED","CHECKED",,,oTree:GetCargo())
            PC5->( RecLock("PC5",.F.) )
                PC5->PC5_DTAPON := dDataBase
                PC5->PC5_USRAPO := cNomeUsu
                PC5->PC5_STATUS := 'C'
            PC5->( MsUnlock() )
        ElseIf PC5->(PC5_STATUS) == 'C'
            oTree:ChangePrompt(AllTrim((cAlias)->(PBD_DESCR))+"("+cValToChar(PC5->(PC5_ITAPON))+")-NÃO CONFORME-"+dToc(Ddatabase)+"-"+cNomeUsu,oTree:GetCargo())
            oTree:ChangeBmp("BPMSTASK1","BPMSTASK1",,,oTree:GetCargo())
            PC5->( RecLock("PC5",.F.) )
                PC5->PC5_DTAPON := dDataBase
                PC5->PC5_USRAPO := cNomeUsu
                PC5->PC5_STATUS := 'N'
            PC5->( MsUnlock() )
        ElseIf PC5->(PC5_STATUS) == 'N'
            oTree:ChangePrompt(AllTrim((cAlias)->(PBD_DESCR))+"("+cValToChar(PC5->(PC5_ITAPON))+")",oTree:GetCargo())
            oTree:ChangeBmp("BPMSTASK2","BPMSTASK2",,,oTree:GetCargo())
            PC5->( RecLock("PC5",.F.) )
                PC5->PC5_DTAPON := CTOD("  /  /    ")
                PC5->PC5_USRAPO := ""
                PC5->PC5_STATUS := 'A'
            PC5->( MsUnlock() )
        EndIf
    EndIf

    If oTree:Nivel() == 2 .AND. PC5->(PC5_TPAPOM) == 'M'

        If MsgYesNo("Inclusao=SIM, Estorno=NAO")

            If PC5->(PC5_ITAPON) == 0 .AND. PC5->(PC5_STATUS) == 'A'
                //PBD_CODTIP+'.'+PBD_CODIGO
                oTree:ChangePrompt(AllTrim((cAlias)->(PBD_DESCR))+">("+cValToChar(PC5->(PC5_ITAPON)+1)+")-"+dToc(Ddatabase)+"-"+cNomeUsu,oTree:GetCargo())
                oTree:ChangeBmp("CHECKED","CHECKED",,,oTree:GetCargo())
                PC5->( RecLock("PC5",.F.) )
                    PC5->PC5_DTAPON := dDataBase
                    PC5->PC5_USRAPO := cNomeUsu
                    PC5->PC5_STATUS := 'C'
                    PC5->PC5_ITAPON += 1
                PC5->( MsUnlock() )
            Else
                oTree:ChangePrompt(AllTrim((cAlias)->(PBD_DESCR))+">("+cValToChar(PC5->(PC5_ITAPON)+1)+")-"+dToc(Ddatabase)+"-"+cNomeUsu,oTree:GetCargo())
                PC5->( RecLock("PC5",.F.) )
                    PC5->PC5_DTAPON := dDataBase
                    PC5->PC5_USRAPO := cNomeUsu
                    PC5->PC5_STATUS := 'C'
                    PC5->PC5_ITAPON += 1
                PC5->( MsUnlock() )
            EndIf
        Else
            If PC5->(PC5_ITAPON) == 1
                //PBD_CODTIP+'.'+PBD_CODIGO
                oTree:ChangePrompt(AllTrim((cAlias)->(PBD_DESCR))+">(0)",oTree:GetCargo())
                oTree:ChangeBmp("BPMSTASK2","BPMSTASK2",,,oTree:GetCargo())
                PC5->( RecLock("PC5",.F.) )
                    PC5->PC5_DTAPON := CTOD("  /  /    ")
                    PC5->PC5_USRAPO := ""
                    PC5->PC5_STATUS := 'A'
                    PC5->PC5_ITAPON := 0
                PC5->( MsUnlock() )
            ElseiF PC5->(PC5_ITAPON) > 1
                oTree:ChangePrompt(AllTrim((cAlias)->(PBD_DESCR))+">("+cValToChar(PC5->(PC5_ITAPON)-1)+")-"+dToc(Ddatabase)+"-"+cNomeUsu,oTree:GetCargo())
                PC5->( RecLock("PC5",.F.) )
                    PC5->PC5_DTAPON := dDataBase
                    PC5->PC5_USRAPO := cNomeUsu
                    PC5->PC5_STATUS := 'C'
                    PC5->PC5_ITAPON -= 1
                PC5->( MsUnlock() )
            EndIf
        EndIf


    EndIf

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

        SELECT PC5_CODMOT AS 'COD',PC5_DTAPON,PC5_USRAPO,PC5_STATUS,PBB_NOME AS 'DESC',PC5_CODBON AS 'CODBON',
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

        SELECT PC5_CODVEI AS 'COD',PC5_DTAPON,PC5_USRAPO,PC5_STATUS,LTRIM(RTRIM(PBJ_DESCRI))+'-'+
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

        SELECT PC5_CODTRA AS 'COD',PC5_DTAPON,PC5_USRAPO,PC5_STATUS,
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
    AADD(aRet,{"","","","","","","","","",""})
EndIf

While (cAlias)->( !Eof())

    AADD(aRet,{;
    (cAlias)->(COD),;
    (cAlias)->(DESC),;
    (cAlias)->(CODBON),;
    (cAlias)->(BONIF),;
    iif((cAlias)->(PC5_TPAPOM)<>"D",'>(' + cValToChar((cAlias)->(PC5_ITAPON)) + ')','>Documento'),;
    (cAlias)->(REG),;
    (cAlias)->(PC5_DTAPON),;
    (cAlias)->(PC5_USRAPO),;
    (cAlias)->(PC5_TPAPOM),;
    (cAlias)->(PC5_STATUS);
    })

    (cAlias)->( dbSkip())

EndDo

Return aRet


Static Function CriaTab(oProcess,lEnd)

Local cAlias    := GetNextAlias()
Local aRet      := {}
Local a         := 0

    PC5->( dbSetOrder(1) )

    //If !PC5->( dbSeek(xFilial("PC5")+MV_PAR01) )

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

                PC5->(dbSetOrder(2))
                //PC5_FILIAL+PC5_PERIOD+PC5_TIPO+PC5_CODBON+PC5_CODMOT+PC5_CODVEI+PC5_CODTRA+PC5_ITAPON

                If (cAlias)->(PBD_TPAPOM) <> 'M'
                    IF !PC5->(dbSeek(cFilAnt + MV_PAR01 + (cAlias)->(TIPO) + (cAlias)->(CODBON) + (cAlias)->(CODM) + (cAlias)->(CODV) + (cAlias)->(CODT) + cValToChar(a) ))
                        RecLock("PC5",.T.)
                            PC5->PC5_FILIAL := cFilAnt
                            PC5->PC5_PERIOD := MV_PAR01
                            PC5->PC5_CODMOT := (cAlias)->(CODM)
                            PC5->PC5_CODVEI := (cAlias)->(CODV)
                            PC5->PC5_CODTRA := (cAlias)->(CODT)
                            PC5->PC5_CODBON := (cAlias)->(CODBON)
                            PC5->PC5_FREQUE := (cAlias)->(PBD_FREQUE)
                            PC5->PC5_ITAPON := IIF((cAlias)->(PBD_TPAPOM)=='M',0,a)
                            PC5->PC5_TIPO   := (cAlias)->(TIPO)
                            PC5->PC5_TPAPOM := (cAlias)->(PBD_TPAPOM)
                            PC5->PC5_STATUS := 'A'
                        MsUnlock()
                    EndIf
                Else
                    IF !PC5->(dbSeek(cFilAnt + MV_PAR01 + (cAlias)->(TIPO) + (cAlias)->(CODBON) + (cAlias)->(CODM) + (cAlias)->(CODV) + (cAlias)->(CODT) ) )
                        RecLock("PC5",.T.)
                            PC5->PC5_FILIAL := cFilAnt
                            PC5->PC5_PERIOD := MV_PAR01
                            PC5->PC5_CODMOT := (cAlias)->(CODM)
                            PC5->PC5_CODVEI := (cAlias)->(CODV)
                            PC5->PC5_CODTRA := (cAlias)->(CODT)
                            PC5->PC5_CODBON := (cAlias)->(CODBON)
                            PC5->PC5_FREQUE := (cAlias)->(PBD_FREQUE)
                            PC5->PC5_ITAPON := IIF((cAlias)->(PBD_TPAPOM)=='M',0,a)
                            PC5->PC5_TIPO   := (cAlias)->(TIPO)
                            PC5->PC5_TPAPOM := (cAlias)->(PBD_TPAPOM)
                            PC5->PC5_STATUS := 'A'
                        MsUnlock()
                    EndIf
                End If
            Next a

        (cAlias)->(dbSkip())

        EndDo
    //EndIf


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
                    PC5->PC5_STATUS := 'S'
                ElseIf STOD((cAlias)->(DATAV)) < CTOD('01/'+SubStr(MV_PAR01,1,2)+'/'+SubStr(MV_PAR01,3,4))
                    PC5->PC5_USRAPO := 'Doc.VENCIDO'
                    PC5->PC5_DTAPON := STOD((cAlias)->(DATAV))
                    PC5->PC5_STATUS := 'V'
                Else
                    PC5->PC5_USRAPO := 'Documento OK'
                    PC5->PC5_DTAPON := STOD((cAlias)->(DATAV))
                    PC5->PC5_STATUS := 'O'
                EndIf
            PC5->( MsUnlock() )
        (cAlias)->( dbSkip() )
        EndDo

Return


Static Function PutObs (oTree)

Local cDesc     := ''
Local cDescNew  := ''
Local nRec      := Val(oTree:GetCargo())

    If oTree:Nivel() == 2
        If nRec > 0

            PC5->( dbGoto(nRec)  )

            cDesc := PC5->(PC5_OBSERV)

            cDescNew := U_QUAA023I("Observações Bonificações Carreteiro","Apontamento",cDesc)

            PC5->( RecLock("PC5",.F.) )
                PC5->PC5_OBSERV := cDescNew
            PC5->( MsUnlock() )

        End If
    EndIf

Return

/*/{Protheus.doc} DelApon
Deleta leituras
@type function
@version
@author wilso
@since 07/01/2021
@return return_type, return_description
/*/
Static Function DelApon()


    If MsgYesNo("Deseja deletar leituras?")

        TcSqlExec("DELETE " + RetSqlName("PC5") + " WHERE PC5_FILIAL='" + cFilAnt + "' AND PC5_PERIOD='" + MV_PAR01 + "'")

        Criatree()

    EndIf

Return



Static Function CriaTree()

CriaTab()
Verif_doc()

**Cria a Tree MOTORISTAS ===============================================================================================================================

oTree1 := DbTree():New(000,000,000,000,oC1W1,,{||PutObs(oTree1)},.T.,,)
oTree1:Reset()
oTree1:Align := CONTROL_ALIGN_ALLCLIENT
oTree1:bLDblClick := {||click(oTree1)}
oTree1:BeginUpdate()

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
//[10](cAlias)->(PC5_STATUS)

aTree := LoadTree("M")

For i := 1 to Len(aTree)

    cCargo1 := "9"+StrZero(Val(aTree[1][1]),7)

    If cCodMot <> AllTrim(aTree[i][1])

        If i<>1
            oTree1:EndTree()
        EndIf

        oTree1:AddTree(Padl(AllTrim(aTree[i][1])+"-"+AllTrim(aTree[i][2]),100),,"CLIENTE","MSGFORWD",,,"9"+StrZero(Val(aTree[i][1]),7))
        oTree1:TreeSeek( AllTrim(aTree[i][1]) )

        oTree1:AddTreeItem(AllTrim(aTree[i][4])+AllTrim(aTree[i][5]),"BPMSTASK2",,StrZero(aTree[i][6],8))
        oTree1:TreeSeek( StrZero(aTree[i][6],8) )


        If aTree[i][10] == 'C'
            oTree1:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-"+dtoc(stod(AllTrim(aTree[i][7])))+"-"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))
            oTree1:ChangeBmp("CHECKED","CHECKED",,,StrZero(aTree[i][6],8))
        ElseIf aTree[i][10] == 'N'
            oTree1:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-NÃO CONFORME-"+dtoc(stod(AllTrim(aTree[i][7])))+"-"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))
            oTree1:ChangeBmp("BPMSTASK1","BPMSTASK1",,,StrZero(aTree[i][6],8))
        ElseIf aTree[i][10] == 'S'
            oTree1:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-SEM DOCUMENTO",StrZero(aTree[i][6],8))
            oTree1:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
        ElseIf aTree[i][10] == 'V'
            oTree1:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-DOC VENCIDO",StrZero(aTree[i][6],8))
            oTree1:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
         ElseIf aTree[i][10] == 'O'
            oTree1:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-DOC OK",StrZero(aTree[i][6],8))
            oTree1:ChangeBmp("CHECKED","CHECKED",,,StrZero(aTree[i][6],8))
        EndIf

        cCodMot := AllTrim(aTree[i][1])
    Else
        oTree1:AddTreeItem   (AllTrim(aTree[i][4])+AllTrim(aTree[i][5]),"BPMSTASK2",,StrZero(aTree[i][6],8))
        oTree1:TreeSeek( StrZero(aTree[i][6],8) )

        If aTree[i][10] == 'C'
            oTree1:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-"+dtoc(stod(AllTrim(aTree[i][7])))+"-"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))
            oTree1:ChangeBmp("CHECKED","CHECKED",,,StrZero(aTree[i][6],8))
        ElseIf aTree[i][10] == 'N'
            oTree1:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-NÃO CONFORME-"+dtoc(stod(AllTrim(aTree[i][7])))+"-"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))
            oTree1:ChangeBmp("BPMSTASK1","BPMSTASK1",,,StrZero(aTree[i][6],8))
        ElseIf aTree[i][10] == 'S'
            oTree1:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-SEM DOCUMENTO",StrZero(aTree[i][6],8))
            oTree1:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
        ElseIf aTree[i][10] == 'V'
            oTree1:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-DOC VENCIDO",StrZero(aTree[i][6],8))
            oTree1:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
         ElseIf aTree[i][10] == 'O'
            oTree1:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-DOC OK",StrZero(aTree[i][6],8))
            oTree1:ChangeBmp("CHECKED","CHECKED",,,StrZero(aTree[i][6],8))
        EndIf

    EndIf

 Next i

oTree1:TreeSeek(cCargo1)
oTree1:EndUpdate()
oTree1:EndTree()


**Cria a Tree VEICULOS ===============================================================================================================================
oTree2 := DbTree():New(000,000,000,000,oC1W2,,{||PutObs(oTree2)},.T.,,)
oTree2:Reset()
oTree2:Align := CONTROL_ALIGN_ALLCLIENT
oTree2:bLDblClick := {||click(oTree2)}
oTree2:BeginUpdate()

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

For i := 1 to Len(aTree)

    cCargo1 := "9"+StrZero(Val(aTree[1][1]),7)

    If cCodMot <> AllTrim(aTree[i][1])
        If i<>1
            oTree2:EndTree()
        EndIf
        oTree2:AddTree(AllTrim(aTree[i][1])+"-"+AllTrim(aTree[i][2]),,"CARGA","CARGASEQ",,,"9"+StrZero(Val(aTree[i][1]),7))
        oTree2:TreeSeek( AllTrim(aTree[i][1]) )

        oTree2:AddTreeItem   (AllTrim(aTree[i][4])+AllTrim(aTree[i][5]),"BPMSTASK2",,StrZero(aTree[i][6],8))
        oTree2:TreeSeek( StrZero(aTree[i][6],8) )

        If aTree[i][10] == 'C'
            oTree2:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-"+dtoc(stod(AllTrim(aTree[i][7])))+"-"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))
            oTree2:ChangeBmp("CHECKED","CHECKED",,,StrZero(aTree[i][6],8))
        ElseIf aTree[i][10] == 'N'
            oTree2:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-NÃO CONFORME-"+dtoc(stod(AllTrim(aTree[i][7])))+"-"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))
            oTree2:ChangeBmp("BPMSTASK1","BPMSTASK1",,,StrZero(aTree[i][6],8))
        ElseIf aTree[i][10] == 'S'
            oTree2:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-SEM DOCUMENTO",StrZero(aTree[i][6],8))
            oTree2:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
        ElseIf aTree[i][10] == 'V'
            oTree2:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-DOC VENCIDO",StrZero(aTree[i][6],8))
            oTree2:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
         ElseIf aTree[i][10] == 'O'
            oTree2:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-DOC OK",StrZero(aTree[i][6],8))
            oTree2:ChangeBmp("CHECKED","CHECKED",,,StrZero(aTree[i][6],8))
        EndIf


        cCodMot := AllTrim(aTree[i][1])
    Else
        oTree2:AddTreeItem   (AllTrim(aTree[i][4])+AllTrim(aTree[i][5]),"BPMSTASK2",,StrZero(aTree[i][6],8) )
        oTree2:TreeSeek( StrZero(aTree[i][6],8) )

        If aTree[i][10] == 'C'
            oTree2:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-"+dtoc(stod(AllTrim(aTree[i][7])))+"-"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))
            oTree2:ChangeBmp("CHECKED","CHECKED",,,StrZero(aTree[i][6],8))
        ElseIf aTree[i][10] == 'N'
            oTree2:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-NÃO CONFORME-"+dtoc(stod(AllTrim(aTree[i][7])))+"-"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))
            oTree2:ChangeBmp("BPMSTASK1","BPMSTASK1",,,StrZero(aTree[i][6],8))
        ElseIf aTree[i][10] == 'S'
            oTree2:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-SEM DOCUMENTO",StrZero(aTree[i][6],8))
            oTree2:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
        ElseIf aTree[i][10] == 'V'
            oTree2:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-DOC VENCIDO",StrZero(aTree[i][6],8))
            oTree2:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
         ElseIf aTree[i][10] == 'O'
            oTree2:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-DOC OK",StrZero(aTree[i][6],8))
            oTree2:ChangeBmp("CHECKED","CHECKED",,,StrZero(aTree[i][6],8))
        EndIf
    EndIf

 Next i


oTree2:TreeSeek(cCargo1)
oTree2:EndUpdate()
oTree2:EndTree()

**Cria a Tree TRANSPORTADORAS ===============================================================================================================================
oTree3 := DbTree():New(000,000,000,000,oC1W3,,{||PutObs(oTree3)},.T.,,)
oTree3:Reset()
oTree3:Align := CONTROL_ALIGN_ALLCLIENT
oTree3:bLDblClick := {||click(oTree3)}
oTree3:BeginUpdate()

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

For i := 1 to Len(aTree)

    cCargo1 := "9"+StrZero(Val(aTree[1][1]),7)

    If cCodMot <> AllTrim(aTree[i][1])

        If i<>1
            oTree3:EndTree()
        EndIf
        oTree3:AddTree       (AllTrim(aTree[i][1])+"-"+AllTrim(aTree[i][2]),,"PREDIO","S4WB014B",,,"9"+StrZero(Val(aTree[i][1]),7))
        oTree3:TreeSeek( AllTrim(aTree[i][1]) )

        oTree3:AddTreeItem   (AllTrim(aTree[i][4])+AllTrim(aTree[i][5]),"BPMSTASK2",,StrZero(aTree[i][6],8))
        oTree3:TreeSeek( StrZero(aTree[i][6],8) )

       If aTree[i][10] == 'C'
            oTree3:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-"+dtoc(stod(AllTrim(aTree[i][7])))+"-"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))
            oTree3:ChangeBmp("CHECKED","CHECKED",,,StrZero(aTree[i][6],8))
        ElseIf aTree[i][10] == 'N'
            oTree3:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-NÃO CONFORME-"+dtoc(stod(AllTrim(aTree[i][7])))+"-"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))
            oTree3:ChangeBmp("BPMSTASK1","BPMSTASK1",,,StrZero(aTree[i][6],8))
        ElseIf aTree[i][10] == 'S'
            oTree3:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-SEM DOCUMENTO",StrZero(aTree[i][6],8))
            oTree3:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
        ElseIf aTree[i][10] == 'V'
            oTree3:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-DOC VENCIDO",StrZero(aTree[i][6],8))
            oTree3:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
         ElseIf aTree[i][10] == 'O'
            oTree3:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-DOC OK",StrZero(aTree[i][6],8))
            oTree3:ChangeBmp("CHECKED","CHECKED",,,StrZero(aTree[i][6],8))
        EndIf


        cCodMot := AllTrim(aTree[i][1])
    Else
        oTree3:AddTreeItem   (AllTrim(aTree[i][4])+AllTrim(aTree[i][5]),"BPMSTASK2",,StrZero(aTree[i][6],8) )
        oTree3:TreeSeek( StrZero(aTree[i][6],8) )

       If aTree[i][10] == 'C'
            oTree3:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-"+dtoc(stod(AllTrim(aTree[i][7])))+"-"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))
            oTree3:ChangeBmp("CHECKED","CHECKED",,,StrZero(aTree[i][6],8))
        ElseIf aTree[i][10] == 'N'
            oTree3:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-NÃO CONFORME-"+dtoc(stod(AllTrim(aTree[i][7])))+"-"+AllTrim(aTree[i][8]),StrZero(aTree[i][6],8))
            oTree3:ChangeBmp("BPMSTASK1","BPMSTASK1",,,StrZero(aTree[i][6],8))
        ElseIf aTree[i][10] == 'S'
            oTree3:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-SEM DOCUMENTO",StrZero(aTree[i][6],8))
            oTree3:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
        ElseIf aTree[i][10] == 'V'
            oTree3:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-DOC VENCIDO",StrZero(aTree[i][6],8))
            oTree3:ChangeBmp("MSGHIGH","MSGHIGH",,,StrZero(aTree[i][6],8))
         ElseIf aTree[i][10] == 'O'
            oTree3:ChangePrompt(AllTrim(aTree[i][4])+AllTrim(aTree[i][5])+"-DOC OK",StrZero(aTree[i][6],8))
            oTree3:ChangeBmp("CHECKED","CHECKED",,,StrZero(aTree[i][6],8))
        EndIf

    EndIf

 Next i

oTree3:TreeSeek(cCargo1)
oTree3:EndUpdate()
oTree3:EndTree()

Return
