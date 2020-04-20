#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.ch"

User Function xCONTRCLI()

Private oProcess	:= NIL
Private Titulo 		:= "Processando. . ."

	oProcess := MsNewProcess():New({|| CONTRCLI(oProcess) },Titulo,"Processando...",.T.)
	oProcess:Activate()

Return

Static Function CONTRCLI(oObj)

Local lRet		:= .T.
Local oProcWF   := Nil
Local cMailAdm  := SuperGetMv('ES_CONTRCL',.F.,'') // e-mails
Local cTo		:= 'wilson.oliveira@quataalimentos.com.br'
Local cAliasA1  := GetNextAlias()

//-- QUERY
BeginSql alias cAliasA1
%noparser%


	SELECT A1_DTMSBL,A1_MSBLQL,A1_DTNASC,A1_COD,A1_LOJA,A1_XBAND,A1_NOME,A1_XFORNEC,A1_XLJFORN,A1_FORNECE,A1_LOJAFOR,
	ISNULL((SELECT TOP 1 ZC4_CODCON 
	FROM %table:ZC7% ZC7
	INNER JOIN %table:ZC4% ZC4 (NOLOCK) ON ZC4_CODCON=ZC7_CODCTR AND ZC4_OBSOLE='F' AND ZC4.%notDel%
	INNER JOIN %table:ZC5% ZC5 (NOLOCK) ON ZC5_CODCON=ZC4_CODCON AND ZC5_REVISA=ZC4_REVISA AND ZC5.%notDel% AND ZC5_FORMA='3'
	WHERE (ZC7_BANDEI=A1_XBAND OR ZC7_CODCLI=A1_COD)  
	AND ZC7.%notDel%),'') AS CONTRATO 
	FROM %table:SA% SA1 (NOLOCK) WHERE SA1.%notDel% 
	AND A1_XFORNEC='' AND A1_MSBLQL='2' AND A1_DTMSBL='' AND
	(SELECT TOP 1 ZC4_CODCON 
	FROM %table:ZC7% ZC7
	INNER JOIN %table:ZC4% ZC4 (NOLOCK) ON ZC4_CODCON=ZC7_CODCTR AND ZC4_OBSOLE='F' AND ZC4.%notDel%
	INNER JOIN %table:ZC5% ZC5 (NOLOCK) ON ZC5_CODCON=ZC4_CODCON AND ZC5_REVISA=ZC4_REVISA AND ZC5.%notDel% AND ZC5_FORMA='3'
	WHERE (ZC7_BANDEI=A1_XBAND OR ZC7_CODCLI=A1_COD)  
	AND ZC7.%notDel%) <> '' ORDER BY A1_COD,A1_LOJA

EndSql

nCount := 0

While (cAliasA1)->(!EOF())
	nCount ++
	(cAliasA1)->( dbSkip())
EndDo

(cAliasA1)->( dbGoTop() ) 

oObj:SetRegua1(nCount)

//-- ENVIA A CLIENTE O E-MAIL COM OS CLIENTES DA MESMA REDE CADASTRADOS EM CONTRATOS.

//If (cAliasA1)->(!EOF())
Do While (cAliasA1)->(! Eof())
	
	cMailAdm  := SuperGetMv('ES_CONTRCL',.F.,'') // e-mails
	cTo		  := 'wilson.oliveira@quataalimentos.com.br'
	
	oProcWF := TWFProcess():New("CLIENTE","Cadastro Cliente")
	oProcWF:NewTask("CLIENTE","\workflow\WFOcorrenciaCliente.htm")
	oProcWF:cSubject := 'Ocorrência de Cadastro de Cliente: '+AllTrim((cAliasA1)->A1_COD+"\"+(cAliasA1)->A1_LOJA)
	
	// E-Mail ADM
	If ! Empty(cMailAdm)
		If ! Empty(cTo)
			cTo += ';'
		EndIf
		cTo += cMailAdm
	EndIf

	// Cabecalho
	oProcWF:oHTML:ValByName("dDtOco"		,DtoC(dDatabase))
	oProcWF:oHTML:ValByName("cHrOco"		,Time())
	oProcWF:oHTML:ValByName("cNomeUsu"		,AllTrim(UsrRetName(RetCodUsr())))
	oProcWF:oHTML:ValByName("cCodCli"		,AllTrim((cAliasA1)->A1_COD))
	oProcWF:oHTML:ValByName("cLojaCli"		,AllTrim((cAliasA1)->A1_LOJA))
	oProcWF:oHTML:ValByName("cNomeCli"		,AllTrim((cAliasA1)->A1_NOME))
	oProcWF:oHTML:ValByName("cBand"			,AllTrim((cAliasA1)->A1_XBAND))
	oProcWF:oHTML:ValByName("cNomBand"		,Posicione("SX5",1,xFilial("SX5")+'BA'+AllTrim((cAliasA1)->A1_XBAND),"X5_DESCRI"))
	oProcWF:oHTML:ValByName("cObs"			,"Cliente cadastrado possui contratos RETIDO A PAGAR e NAO tem CODIGO DE FORNECEDOR cadastrado!")

	// Itens
	//Do While (cAliasA1)->(! Eof())
		
		oObj:IncRegua1("cliente--> " + AllTrim((cAliasA1)->A1_COD) +" | Loja->" + AllTrim((cAliasA1)->A1_LOJA)+"_"+AllTrim((cAliasA1)->A1_NOME))   
			
	    AAdd(oProcWF:oHTML:ValByName("IT.cCodCli")	, AllTrim((cAliasA1)->A1_COD))
	    AAdd(oProcWF:oHTML:ValByName("IT.cLojaCli")	, AllTrim((cAliasA1)->A1_LOJA))
	    AAdd(oProcWF:oHTML:ValByName("IT.cNomeCli")	, AllTrim((cAliasA1)->A1_NOME))
	    AAdd(oProcWF:oHTML:ValByName("IT.cBand")	, AllTrim((cAliasA1)->A1_XBAND))

    	(cAliasA1)->(dbSkip())
	//EndDo

	// Adiciona e-mail
	oProcWF:cTo := cTo

	oProcWF:Start()
	WFSendMail()
	oProcWF:Finish()
	oProcWF := FreeObj(oProcWF)
	
EndDo

//EndIf

Return lRet
