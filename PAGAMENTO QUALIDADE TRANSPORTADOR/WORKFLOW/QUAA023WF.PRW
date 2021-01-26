#Include 'Totvs.ch'
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE 'COLORS.CH'
#INCLUDE "PRCONST.CH"
#INCLUDE "FONT.CH"
#include "TBICONN.CH"


/*/{Protheus.doc} QUAA023WF
description
@type function
@version
@author wilso
@since 04/12/2020
@return return_type, return_description
/*/
************************************************************************************************************************************
User Function QUAA023WF()


    *PBK010
    *01	GESTAO ASPECTOS LEGAIS DOCUMENTACAO ("JOB")
    *02	GESTAO TRANSPORTADORA DESBLOQ. MANUAL P/AVALIACAO FOMENTO
    *03	GESTAO MOTORISTAS BLOQUEIO/DESBLOQUEIO MANUAL
    *04	GESTAO TRANSPORTADORA VERIF. DE INATIVIDADE TRANSPORTADORA ("JOB")



Return
************************************************************************************************************************************
/*/{Protheus.doc} WfQua23
JOB DIARIO PARA VERIFICACAO DE VENCIMENTO DE DOCUMENTACAO DE TRANPORTADORES,VEICULOS E MOTORISTAS
JOB DIARIO PARA VERIFICA SE TRANSPORTADORA ESTA ATIVA OU NAO (MOVIMENTO DE LEITE)
@type function
@version
@author wilso
@since 04/12/2020
@return return_type, return_description
/*/
User Function WfQua23()

    RpcSetType(3)
    RpcSetEnv('01','01',,,'FAT')
    cFilAtu := cFilAnt
    For nFil := 1 To 10
        cFilAnt := StrZero(nFil,2)
        Ver_doc(StrZero(nFil,2))
        Ver_trans(StrZero(nFil,2))
        Blk_trans(StrZero(nFil,2))
    Next nFil
    cFilAnt := cFilAtu
    RpcClearEnv()

Return

/*/{Protheus.doc} Ver_doc
VERIFICA DOCUMENTOS VENCIDOS A VENCER POR FILIAL
@type function
@version
@author wilso
@since 04/12/2020
@return return_type, return_description
/*/

Static Function Ver_doc(xFil)

    Local cAliasQry := GetNextAlias()
    Local aRet := {}
    Local nDias
    Local cMail
    Local cAssun
    Local cCorpo
    Local lRet := .F.

    If PBK->(dbSeek(xFil+'01'))

        nDias   := cValToChar(PBK->PBK_DIAANT)
        cMail   := Alltrim(PBK->PBK_EMAILD)
        cAssun  := Alltrim(PBK->PBK_ASSUNT)
        cCorpo  := Alltrim(PBK->PBK_CORPO)

        BeginSql Alias cAliasQry

            %noparser%

            SELECT PBG_FILIAL,PBG_DOC,PBG_DTVALI,
            CASE WHEN PBG_TIPO='M' THEN 'MOTORISTA' WHEN PBG_TIPO='V' THEN 'VEICULO' WHEN PBG_TIPO='T' THEN 'TRANSPORTADORA' END AS 'TIPO',
            CASE WHEN PBG_TIPO='M' THEN (SELECT PBB_CODIGO+'-'+PBB_NOME FROM %Table:PBB% PBB WHERE PBB.%notDel% AND PBB_CODIGO=PBG_CODMOT AND PBB_FILIAL=PBG_FILIAL)
            WHEN PBG_TIPO='T' THEN (SELECT TOP 1 A2_COD+'-'+A2_NOME FROM %Table:SA2% SA2 WHERE SA2.%notDel% AND A2_COD=PBG_CODTRA)
            WHEN PBG_TIPO='V' THEN (SELECT PBJ_CODIGO+'-'+LTRIM(RTRIM(PBJ_DESCRI))+'-'+PBJ_PLACA FROM %Table:PBJ% PBJ WHERE PBJ.%notDel% AND PBJ_CODIGO=PBG_CODVEI
            AND PBJ_FILIAL=PBG_FILIAL)
            END AS 'DESCRI'
            FROM %Table:PBG% PBG
            WHERE PBG_FILIAL=%Exp:xFil% AND PBG.%notDel% AND CAST(PBG_DTVALI AS datetime) < GETDATE()+ CAST(%Exp:nDias% AS INT)
            ORDER BY PBG_FILIAL,PBG_TIPO

        EndSql

        While (cAliasQry)->( !Eof())
            AADD(aRet,{ (cAliasQry)->(TIPO),;
                        (cAliasQry)->(PBG_DOC),;
                        DTOC(STOD((cAliasQry)->(PBG_DTVALI))),;
                        (cAliasQry)->(DESCRI)})
            (cAliasQry)->( dbSkip() )
            lRet := .T.
        EndDo

        If lRet
            WFMail1(aRet,cMail,cAssun,cCorpo)
        EndIf

    End If

Return

/*/{Protheus.doc} Ver_trans
description
@type function
@version
@author Wilson Davila
@since 07/12/2020
@return return_type, return_description
/*/
Static Function Ver_trans(xFil)


    Local cAliasQry := GetNextAlias()
    Local aRet := {}
    Local nDias
    Local cMail
    Local cAssun
    Local cCorpo
    Local lRet := .F.

    If PBK->(dbSeek(xFil+'04'))

        nDias   := cValToChar(PBK->PBK_DIAANT)
        nDiasBl := cValToChar(PBK->PBK_DIASIN)
        nDiasAv := cValToCHar(PBK->PBK_DIAANT+PBK->PBK_DIASIN)

        cMail   := Alltrim(PBK->PBK_EMAILD)
        cAssun  := Alltrim(PBK->PBK_ASSUNT)
        cCorpo  := Alltrim(PBK->PBK_CORPO)

        BeginSql Alias cAliasQry

            %noparser%

            SELECT DISTINCT A2_COD,A2_CGC,A2_TIPO
            FROM %Table:SA2% SA2
            WHERE SA2.%notDel% AND A2_MSBLQL='2' AND
            A2_COD IN (SELECT LBB_CODFOR FROM %Table:LBB% LBB WHERE LBB_FILIAL=%Exp:xFil% AND LBB_TIPREG='2' AND LBB.%notDel%)
            AND A2_COD NOT IN (SELECT DISTINCT LBE_FORNEC
            FROM %Table:LBE% LBE
            WHERE LBE.%notDel%
            AND LBE_FORNEC IN (SELECT LBB_CODFOR FROM %Table:LBB% LBB WHERE LBB_FILIAL=%Exp:xFil% AND LBB_TIPREG='2' AND LBB.%notDel%)
            AND LBE_CODCAM IN (SELECT PC0_LINROT FROM %Table:PC0% PC0 WHERE PC0_FILIAL=%Exp:xFil% AND PC0.%notDel%
            AND CAST(PC0_DTENTR AS datetime) > GETDATE() - CAST(%Exp:nDiasAv% AS INT) ) )
            ORDER BY A2_COD

        EndSql
        aSql := GetLastQuery()
        MemoWrite("C:\HD\QUERYS\QUAA23WF004.SQL",aSql[2])
        While (cAliasQry)->( !Eof())

            AADD(aRet,{ (cAliasQry)->(A2_COD),;
                        POSICIONE("LBB",2,xFil+(cAliasQry)->(A2_COD)+'0001',"LBB_CODPRO"),;
                        IIF((cAliasQry)->(A2_TIPO)='J',TRANSFORM((cAliasQry)->(A2_CGC),"@R 99.999.999/9999-99"),TRANSFORM((cAliasQry)->(A2_CGC),"@R 999.999.999-99")),;
                        POSICIONE("SA2",1,xFilial("SA2")+(cAliasQry)->(A2_COD)+'0001',"A2_NOME")})
            (cAliasQry)->( dbSkip() )

            lRet := .T.
        EndDo

        If lRet
            WFMail4(aRet,cMail,cAssun,cCorpo)
        EndIf

    End If

Return

/*/{Protheus.doc} Ver_trans
description
@type function
@version
@author Wilson Davila
@since 07/12/2020
@return return_type, return_description
/*/
Static Function Blk_trans(xFil)


    Local cAliasQry := GetNextAlias()
    Local aRet := {}
    Local nDias
    Local cMail
    Local cAssun
    Local cCorpo
    Local lRet := .F.

    If PBK->(dbSeek(xFil+'04'))

        nDias   := cValToChar(PBK->PBK_DIAANT)
        nDiasBl := cValToChar(PBK->PBK_DIASIN)
        nDiasAv := cValToCHar(PBK->PBK_DIAANT+PBK->PBK_DIASIN)

        cMail   := Alltrim(PBK->PBK_EMAILD)
        cAssun  := Alltrim(PBK->PBK_ASSUNT)
        cCorpo  := Alltrim(PBK->PBK_CORPO)

        BeginSql Alias cAliasQry

            %noparser%

            SELECT DISTINCT A2_COD,A2_CGC,A2_TIPO
            FROM %Table:SA2% SA2
            WHERE SA2.%notDel% AND A2_MSBLQL='2' AND
            A2_COD IN (SELECT LBB_CODFOR FROM %Table:LBB% LBB WHERE LBB_FILIAL=%Exp:xFil% AND LBB_TIPREG='2' AND LBB.%notDel%)
            AND A2_COD NOT IN (SELECT DISTINCT LBE_FORNEC
            FROM %Table:LBE% LBE
            WHERE LBE.%notDel%
            AND LBE_FORNEC IN (SELECT LBB_CODFOR FROM %Table:LBB% LBB WHERE LBB_FILIAL=%Exp:xFil% AND LBB_TIPREG='2' AND LBB.%notDel%)
            AND LBE_CODCAM IN (SELECT PC0_LINROT FROM %Table:PC0% PC0 WHERE PC0_FILIAL=%Exp:xFil% AND PC0.%notDel%
            AND CAST(PC0_DTENTR AS datetime) > GETDATE() - CAST(%Exp:nDiasBl% AS INT) ) )
            ORDER BY A2_COD

        EndSql

        aSql := GetLastQuery()
        MemoWrite("C:\HD\QUERYS\QUAA23WF004_A.SQL",aSql[2])

        While (cAliasQry)->( !Eof())

            AADD(aRet,{ (cAliasQry)->(A2_COD),;
                        POSICIONE("LBB",2,xFil+(cAliasQry)->(A2_COD)+'0001',"LBB_CODPRO"),;
                        IIF((cAliasQry)->(A2_TIPO)='J',TRANSFORM((cAliasQry)->(A2_CGC),"@R 99.999.999/9999-99"),TRANSFORM((cAliasQry)->(A2_CGC),"@R 999.999.999-99")),;
                        POSICIONE("SA2",1,xFilial("SA2")+(cAliasQry)->(A2_COD)+'0001',"A2_NOME")})
            (cAliasQry)->( dbSkip() )



            lRet := .T.
        EndDo

        If lRet

            For i := 1 To Len(aRet)
                TcSqlExec("UPDATE " + RetSqlName("SA2") + " SET A2_MSBLQL='1' WHERE A2_COD='" + aRet[i][1] + "'")
                TcSqlExec("UPDATE " + RetSqlName("LBB") + " SET LBB_STATUS='N' WHERE LBB_CODFOR='" + aRet[i][2] + "' AND LBB_TIPREG='2' AND LBB_FILIAL='" + xFil + "'")
                TcSqlExec("UPDATE " + RetSqlName("LBE") + " SET LBE_STATUS='N' WHERE LBE_FORNEC='" + aRet[i][2] + "' AND LBE_FILIAL='" + xFil + "'")

                cDesc := DTOC(dDataBase)+"-"+Time()+"->REGISTRO BLOQUEADO AUTOMATICAMENTE PELO SISTEMA" + CRLF
                cDesc += "MOTIVO: FALTA DE MOVIMENTO POR 1 ANO OU MAIS"

                SA2->(dbSetOrder(1))
                If SA2->(dbSeek(xFilial("SA2")+aRet[i][1]+'0001'))
                    SA2->(RecLock("SA2",.F.))
                        SA2->A2_LOG := SA2->A2_LOG + CRLF + cDesc + CRLF + "====================================================================="
                    SA2->(MsUnlock())
                EndIf
            Next i

            WFMail4I(aRet,cMail,cAssun,cCorpo)

        EndIf

    End If

Return

/*/{Protheus.doc} WFMail1
WORKFLOW GESTAO DE DOCUMENTOS
@type function
@version
@author Wilson Davila
@since 04/12/2020
@param aDados, array, param_description
@return return_type, return_description
/*/
Static Function WFMail1(aDados,cMail,cAssun,cCorpo)

Local lRet		:= .T.
Local oProcWF   := Nil
Local cMailAdm  := '' //SuperGetMv('ES_QUAA081',.F.,'') // e-mails
Local cTo		:= cMail //'wilson.oliveira@wdonet.com.br'

	cMailAdm  := ''
	oProcWF := TWFProcess():New("QA23F1","Aviso Vencimento Documentos")
	oProcWF:NewTask("QA23F1","\workflow\QUAA023WF_001.html",.T.)
	oProcWF:cSubject := OemToAnsi(cAssun)

   	// Cabecalho

	oProcWF:oHTML:ValByName("cTitulo"    ,"DOCUMENTOS VENCIDOS OU A VENCER")
    oProcWF:oHTML:ValByName("cCorpo"    ,cCorpo )
    oProcWF:oHTML:ValByName("dthoje"    ,dtoc(dDataBase ))

    For i := 1 to Len(aDados)
        AAdd(oProcWF:oHTML:ValByName("it.cTipo")    ,aDados[i][1] )
	    AAdd(oProcWF:oHTML:ValByName("it.cDoc")		,aDados[i][2] )
	    AAdd(oProcWF:oHTML:ValByName("it.dValid")	,aDados[i][3] )
        AAdd(oProcWF:oHTML:ValByName("it.cNome")	,aDados[i][4] )
    Next i

	// Adiciona e-mail
	oProcWF:cTo := cTo

	oProcWF:Start()
	WFSendMail()
	oProcWF:Finish()
	oProcWF := FreeObj(oProcWF)

Return lRet


/*/{Protheus.doc} WFMail4
GESTAO TRANPORTADORA AVISO DE INATIVIDADE POR 1 ANO E BLOQUEIO
@type function
@version
@author Wilson Davila
@since 04/12/2020
@param aDados, array, param_description
@return return_type, return_description
/*/
Static Function WFMail4(aDados,cMail,cAssun,cCorpo)

Local lRet		:= .T.
Local oProcWF   := Nil
Local cMailAdm  := '' //SuperGetMv('ES_QUAA081',.F.,'') // e-mails
Local cTo		:= cMail //'wilson.oliveira@wdonet.com.br'


	cMailAdm  := ''
	oProcWF := TWFProcess():New("QA23F4","Aviso Transportadoras sem movimento 1 ano")
	oProcWF:NewTask("QA23F4","\workflow\QUAA023WF_004.html",.T.)
	oProcWF:cSubject := OemToAnsi(cAssun)

   	// Cabecalho

	oProcWF:oHTML:ValByName("cTitulo"    ,"AVISO INATIVIDADE TRANSPORTADORA DE LEITE")
    oProcWF:oHTML:ValByName("cCorpo"    ,cCorpo )
    oProcWF:oHTML:ValByName("dthoje"    ,dtoc(dDataBase ))

    For i := 1 to Len(aDados)
        AAdd(oProcWF:oHTML:ValByName("it.cCodFor")  ,aDados[i][1] )
	    AAdd(oProcWF:oHTML:ValByName("it.cCodPro")	,aDados[i][2] )
	    AAdd(oProcWF:oHTML:ValByName("it.cCnpj")	,aDados[i][3] )
        AAdd(oProcWF:oHTML:ValByName("it.cRazao")	,aDados[i][4] )
    Next i

	// Adiciona e-mail
	oProcWF:cTo := cTo

	oProcWF:Start()
	WFSendMail()
	oProcWF:Finish()
	oProcWF := FreeObj(oProcWF)


Return lRet

/*/{Protheus.doc} WFMail4
GESTAO TRANPORTADORA AVISO DE INATIVIDADE POR 1 ANO E BLOQUEIO
@type function
@version
@author Wilson Davila
@since 04/12/2020
@param aDados, array, param_description
@return return_type, return_description
/*/
Static Function WFMail4I(aDados,cMail,cAssun,cCorpo)

Local lRet		:= .T.
Local oProcWF   := Nil
Local cMailAdm  := '' //SuperGetMv('ES_QUAA081',.F.,'') // e-mails
Local cTo		:= cMail //'wilson.oliveira@wdonet.com.br'

    cAssun := "Trasnportadora de Leite bloqueadas pelo sistema"
	cMailAdm  := ''
	oProcWF := TWFProcess():New("QA23F4","Aviso Bloqueio automatico Transportadoras sem movimento 1 ano")
	oProcWF:NewTask("QA23F4","\workflow\QUAA023WF_004.html",.T.)
	oProcWF:cSubject := OemToAnsi(cAssun)

   	// Cabecalho
    cCorpo := "A(s) transportadora(s) abaixo foram bloqueada(s) por inatividade na entrega de leite por mais de 1 ano"
	oProcWF:oHTML:ValByName("cTitulo"    ,"AVISO BLOQUEIO POR INATIVIDADE TRANSPORTADORA DE LEITE")
    oProcWF:oHTML:ValByName("cCorpo"    ,cCorpo )
    oProcWF:oHTML:ValByName("dthoje"    ,dtoc(dDataBase ))

    For i := 1 to Len(aDados)
        AAdd(oProcWF:oHTML:ValByName("it.cCodFor")  ,aDados[i][1] )
	    AAdd(oProcWF:oHTML:ValByName("it.cCodPro")	,aDados[i][2] )
	    AAdd(oProcWF:oHTML:ValByName("it.cCnpj")	,aDados[i][3] )
        AAdd(oProcWF:oHTML:ValByName("it.cRazao")	,aDados[i][4] )
    Next i

	// Adiciona e-mail
	oProcWF:cTo := cTo

	oProcWF:Start()
	WFSendMail()
	oProcWF:Finish()
	oProcWF := FreeObj(oProcWF)


Return lRet
