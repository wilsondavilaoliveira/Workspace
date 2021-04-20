#Include "RwMake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT410INC  ºAutor  ³MARCIO COSTA        º Data ³  12/19/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PONTO DE ENTRADA PARA EMISSAO DO RELATORIO DE PEDIDO DE     º±±
±±º          ³VENDA DIRETO DO PEDIDO                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT410INC()

Local lImprime 	:= .T.
Local lBlock	:= .F.

//Wilson Davila 16/04/2021
//If Posicione("DA0",1,XFILIAL("DA0")+SC5->C5_TABELA,"DA0_XESCAL") == '1' .AND. Alltrim(SC5->C5_U_ORIGE) == 'ERP'
//    TabEscalo()
//EndIf
//

//Verifica se pedido esta bloqueado por preco a menor que tabela de preco da filial
lBlock := U_xLibSc6(SC5->C5_FILIAL,SC5->C5_NUM)

DbSelectArea('PXC')
DbSetOrder(1)

If lBlock // Se achou bloqueio em algum item bloqueia pedido, senao libera.
	If SC5->C5_BLOQUE <> '00' .And. !PXC->(DbSeek(xFilial("PXC")+SC5->C5_BLOQUE))
		Reclock("SC5",.F.)
			SC5->C5_BLOQUE	:= 'B'
		MsUnlock()
	EndIf
ElseIf Alltrim(SC5->C5_BLOQUE) == 'B'
	If SC5->C5_BLOQUE <> '00' .And. !PXC->(DbSeek(xFilial("PXC")+SC5->C5_BLOQUE))
		Reclock("SC5",.F.)
			SC5->C5_BLOQUE	:= ''
		MsUnlock()
	EndIF
End If

If Alltrim(SC5->C5_U_ORIGE) == 'ERP' .AND. AllTrim(SC5->C5_TIPO) ==  'N' .AND. Empty(SC5->C5_XPEDANT)
	// Não executa a partir da rotina de transferencia automatica.
	If !IsInCallStack("U_NMCB63")
		If lBlock
			MsgStop(OemToAnsi("O Pedido contém iten(s) BLOQUEADO(S) por preço a menor que tabela de preços da Filial, solicite liberação para Diretoria"))
		Else

			If MsgBox("Deseja imprimir o pedido de venda ?","Relatório","YESNO")
				U_RFATR01(lImprime)
			Endif

		End If
	EndIf

EndIf

Return

/*/{Protheus.doc} TabEscalo()
Altera pedido de venda de acordo com agrupamento de quantidades por categoria de produto da linha seca
@type function
@version
@author Wilson Davila
@since 15/04/2021
@return return_type, return_description
/*/
Static Function TabEscalo()

Local aCabec   := {}
Local aItens   := {}
Local aLinha   := {}
Local aArea    := GetArea()
Local nPreco   := 0
Local lBckInc  := INCLUI

Private lMsErroAuto    := .F.
Private lAutoErrNoFile := .F.

INCLUI := .F.
aadd(aCabec, {"C5_FILIAL",  SC5->C5_FILIAL     ,Nil})
aadd(aCabec, {"C5_NUM",     SC5->C5_NUM        ,Nil})
aadd(aCabec, {"C5_TIPO",    SC5->C5_TIPO       ,Nil})
aadd(aCabec, {"C5_CLIENTE", SC5->C5_CLIENTE    ,Nil})
aadd(aCabec, {"C5_LOJACLI", SC5->C5_LOJACLI    ,Nil})
aadd(aCabec, {"C5_LOJAENT", SC5->C5_LOJAENT    ,Nil})
aadd(aCabec, {"C5_CONDPAG", SC5->C5_CONDPAG    ,Nil})

SC6->( DbSetOrder(1))
If SC6->( DbSeek(SC5->C5_FILIAL+SC5->C5_NUM))

  While SC6->( !Eof() ) .AND. ( SC6->(C6_FILIAL+C6_NUM) == SC5->C5_FILIAL+SC5->C5_NUM )

      nPreco := ProcPrc(SC6->(C6_FILIAL),SC6->(C6_PRODUTO),SC6->(C6_PRCVEN),SC6->(C6_NUM),SC5->C5_TABELA)
      //If nPreco <> SC6->(C6_PRCVEN)
          aLinha := {}
          aadd(aLinha,{"C6_FILIAL"  ,SC6->(C6_FILIAL)                                           ,Nil})
          aadd(aLinha,{"C6_ITEM"    ,SC6->(C6_ITEM)                                             ,Nil})
          aadd(aLinha,{"C6_PRODUTO" ,SC6->(C6_PRODUTO)                                          ,.F.})
          aadd(aLinha,{"C6_QTDVEN"  ,SC6->(C6_QTDVEN)                                           ,.F.})
          aadd(aLinha,{"C6_PRCVEN"  ,IIF(nPreco <> SC6->(C6_PRCVEN),nPreco,SC6->(C6_PRCVEN))    ,.F.})

          aadd(aItens, aLinha)
      //EndIf
      SC6->( dbSkip() )

  EndDo


EndIf

nOpcX := 4
//MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, nOpcX, .F.)
MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabec,aItens,4)
If !lMsErroAuto
  AVISO("TABELA ESCALONADA",OemToAnsi("Os Preços foram alterados conforme Tabela Escalonada"),{"OK"},1 )
Else

  aErroAuto := GetAutoGRLog()
  MostraErro()

 EndIf

INCLUI := lBckInc

RestArea(aArea)

Return

/*/{Protheus.doc} ProcPrc
Agrupa quantidades por categoria linha seca
@type function
@version
@author Wilson Davila
@since 16/04/2021
@param xFil, param_type, param_description
@param xProduto, param_type, param_description
@param xPreco, param_type, param_description
@param xNum, param_type, param_description
@param xTab, param_type, param_description
@return return_type, return_description
/*/
Static Function ProcPrc(xFil,xProduto,xPreco,xNum,xTab)

Local nPreco := xPreco

	If Select("TMPESC") > 0
		DbSelectArea("TMPESC")
		TMPESC->(DbCloseArea())
	Endif

    BeginSql Alias "TMPESC"
		%NOPARSER%
		SELECT 	TOP 1
				DA1_CODPRO  AS CODIGOPRODUTO,
				DA1_QTDLOT  AS QTDEVENDA,
				B1_PESOVAR  AS PESOVAR,
				CASE
					WHEN SB1.B1_PESOVAR='S' THEN CAST(DA1_XPRVE2 AS NUMERIC(10,2))
					ELSE CAST(DA1_PRCVEN AS NUMERIC(10,2))
				END AS PRECO,
				DA1_CODTAB AS CODIGOTABPRECO,
				0 AS PrecoNegociado
		FROM DA1010 DA1 WITH (NOLOCK)
		INNER JOIN SB1010 SB1 WITH (NOLOCK)
		ON  SB1.B1_FILIAL   = '  '
		AND SB1.B1_COD      = DA1.DA1_CODPRO
		AND SB1.B1_MSBLQL  <> 1
		AND SB1.B1_TIPO     = 'PA'
		AND SB1.B1_GRUPO   <>'600'
		AND SB1.B1_GRUPO   <> ' '
		AND SB1.B1_COD     <> '999999'
		AND SB1.B1_COD     <> '601004' //PRODUTO PARA TESTE ESTA COMO PA PARA EMISSAO DE NOTA
		AND SB1.B1_COD     NOT IN('002018','002019','007111')
		AND SB1.%NOTDEL%
		INNER JOIN DA0010 DA0 WITH (NOLOCK)
		ON  DA0.DA0_FILIAL  = '  '
		AND DA0.DA0_CODTAB  = DA1_CODTAB
		AND DA0.DA0_ATIVO   = '1'
		AND DA0.DA0_XESCAL   = '1'
		AND DA0.%NOTDEL%
		WHERE DA1.DA1_FILIAL = '  '
		AND DA1.DA1_CODTAB = %Exp:xTab%
		AND DA1.DA1_CODPRO = %Exp:xProduto%
		AND DA1_QTDLOT >= (
            SELECT SUM(C6_QTDVEN) FROM SC6010 SC6
            WHERE C6_FILIAL=%Exp:xFil% AND C6_NUM=%Exp:xNum% AND C6_PRODUTO IN(
            SELECT B1_COD FROM SB1010 SB1 WHERE B1_XCATEGO=(
            (SELECT B1_XCATEGO FROM SB1010 B1A WHERE B1A.B1_COD=%Exp:xProduto% AND B1A.B1_TIPO='PA' AND B1A.D_E_L_E_T_=''))
            AND B1_TIPO='PA' AND SB1.D_E_L_E_T_=''))
		AND DA1.%NOTDEL%
		ORDER BY DA1_QTDLOT
	EndSql

    If TMPESC->( !Eof() )
        nPreco := TMPESC->PRECO
    EndIf

Return nPreco
