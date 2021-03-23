#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE 'TOPCONN.CH'
#INCLUDE "TOTVS.CH"
/*/{Protheus.doc} QUAR083R()=============================================================================================================================
Relatorio emissao de Nfe,Nfs carreteiro x contabilidade
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
User Function QUAR083R()

	Private cPath := ''
	Private cAliasQry  := GetNextAlias()

	If Pergunte("QUAR082R",.T.)

		cPath := cGetFile ( ,, 1,, .F., GETF_RETDIRECTORY+GETF_LOCALHARD)

		If !Empty(cPath)
            MsAguarde({|| Query()},"Aguarde...","Efetuando consulta..aguarde!",.T.)
			MsgAlert("Relatorios criados no diretorio:" + cPath)
		End If

	End If

Return NIL

Static Function Query()

        BeginSql Alias cAliasQry

			%noparser%

            SELECT D1_COD,LBB_CODMUN,LBB_MUN,F1_VALBRUT,LBB_CODFOR+'-'+LBB_LOJA AS LBB_CODFOR,A2_INSCR,LBB_DESC,A2_CGC,

			ROUND(
            (SELECT SUM(PA3_VRTOT) FROM %table:PA3% PA3 (NOLOCK) WHERE PA3_PERIOD=%Exp:SubStr(dtoc(MV_PAR01),4,2)+SubStr(dtoc(MV_PAR01),7,4)%
            AND PA3.%notDel% AND PA3_FILIAL=%Exp:cFilAnt% AND PA3_CODCAM IN( SELECT LBB_LINHA
            FROM  %table:LBB% LB1 (NOLOCK) WHERE LBB_FILIAL=%Exp:cFilAnt% AND LB1.LBB_LINHA=LBB.LBB_LINHA AND LBB.%notDel% AND LBB_TIPREG='2'))
            /(SELECT SUM(D1_QUANT) FROM  %table:SD1% D13 (NOLOCK)
            INNER JOIN  %table:SF1% SF1 (NOLOCK) ON F1_FILIAL=D1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND D1_FORNECE=F1_FORNECE
            WHERE F1_EMISSAO=%Exp:MV_PAR01% AND F1_FILIAL=%Exp:cFilAnt% AND F1_XLINHA IN( SELECT LBB_LINHA FROM  %table:LBB% LB2 (NOLOCK) WHERE LBB_FILIAL=%Exp:cFilAnt% AND LB2.%notDel%
            AND LB2.LBB_CODPRO=LBB.LBB_CODPRO))*D1_QUANT,2)  AS  FRETE,

            (SELECT DISTINCT TOP 1 LBB_CODFOR+'-'+LBB_NOMFOR FROM %table:LBB% LBB (NOLOCK) WHERE LBB_LINHA=F1_XLINHA AND LBB_FILIAL=%Exp:cFilAnt%
            AND LBB_TIPREG='2' AND LBB.%notDel%) AS F1_FORNECE,

			D1_QUANT,LBB_CODPRO,LBB_NOMFOR,LBB_LINHA,F1_EMISSAO,F1_DOC+'-'+F1_SERIE AS F1_DOC,F1_CHVNFE,

            CASE WHEN LBB_CODMUN='71006' THEN 'NFS' ELSE 'CTE' END AS TIPOEMISS

            FROM %table:SF1% SF1 (NOLOCK)
            INNER JOIN %table:SD1% SD1 (NOLOCK) ON F1_FILIAL=D1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA AND SD1.%notDel%
            INNER JOIN %table:LBB% LBB (NOLOCK) ON LBB_FILIAL=F1_FILIAL AND LBB_CODFOR=F1_FORNECE AND LBB.%notDel%
            INNER JOIN %table:SA2% SA2 (NOLOCK) ON A2_COD=LBB_CODFOR AND A2_LOJA=LBB_LOJA AND SA2.%notDel%
            WHERE F1_FILIAL=%Exp:cFilAnt% AND SF1.%notDel% AND F1_EMISSAO = %Exp:MV_PAR01%  AND F1_XLINHA
            IN (SELECT LBB_LINHA FROM %table:LBB% LBB (NOLOCK) WHERE LBB_FILIAL=%Exp:cFilAnt% AND LBB_TIPREG='2' AND LBB.%notDel%)
			ORDER BY F1_FORNECE,LBB_CODMUN,F1_XLINHA,LBB_CODPRO

			EndSql

			aRet := GetLastQuery()

			MemoWrite("C:\HD\RELATORIOS\QUAR083R.SQL",aRet[2])

			If (cAliasQry)->(!EOF())
				MsAguarde({|| GeraRel()},"Aguarde...","Gerando Reltorios..aguarde!",.T.)
			End If

Return


/*/{Protheus.doc} GeraRel()==============================================================================================================================
@Funcao auxiliar Relatorio emissao de Nfe,Nfs carreteiro x contabilidade
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/

Static Function GeraRel()

	Local cXml      := ''
	Local cForTrans := ''
    Local nTotCTE   := 0
    Local nTotNFS   := 0
    Local nTotLit   := 0
    Local nTotMer   := 0
    Local nTotGer   := 0

	While (cAliasQry)->(!EOF())

		cForTrans := SubStr((cAliasQry)->(F1_FORNECE),1,6)
        nTotCTE   := 0
        nTotNFS   := 0
        nTotGer   := 0
        nTotLit   := 0
        nTotMer   := 0

        fErase(cPath+'\'+Alltrim((cAliasQry)->(F1_FORNECE))+'.XLS')
		nHdlImp := fCreate(cPath+'\'+Alltrim((cAliasQry)->(F1_FORNECE))+'.XLS', 0)

		MsProcTxt("Transp.->" + SubStr((cAliasQry)->(F1_FORNECE),1,30))

	    cXml := '<?xml version="1.0"?>' + CRLF
        cXml += '<?mso-application progid="Excel.Sheet"?>' + CRLF
        cXml += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"' + CRLF
        cXml += 'xmlns:o="urn:schemas-microsoft-com:office:office"' + CRLF
        cXml += 'xmlns:x="urn:schemas-microsoft-com:office:excel"' + CRLF
        cXml += 'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"' + CRLF
        cXml += 'xmlns:html="http://www.w3.org/TR/REC-html40">' + CRLF
        cXml += '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">' + CRLF
        cXml += '<Author>Wilson Davila</Author>' + CRLF
        cXml += '<LastAuthor>Wilson Davila</LastAuthor>' + CRLF
        cXml += '<Created>2020-10-16T21:10:00Z</Created>' + CRLF
        cXml += '<LastSaved>2020-10-16T21:22:55Z</LastSaved>' + CRLF
        cXml += '<Version>16.00</Version>' + CRLF
        cXml += '</DocumentProperties>' + CRLF
        cXml += '<OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">' + CRLF
        cXml += '<AllowPNG/>' + CRLF
        cXml += '</OfficeDocumentSettings>' + CRLF
        cXml += '<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">' + CRLF
        cXml += '<WindowHeight>7635</WindowHeight>' + CRLF
        cXml += '<WindowWidth>20490</WindowWidth>' + CRLF
        cXml += '<WindowTopX>32767</WindowTopX>' + CRLF
        cXml += '<WindowTopY>32767</WindowTopY>' + CRLF
        cXml += '<ProtectStructure>False</ProtectStructure>' + CRLF
        cXml += '<ProtectWindows>False</ProtectWindows>' + CRLF
        cXml += '</ExcelWorkbook>' + CRLF
        cXml += '<Styles>' + CRLF
        cXml += '<Style ss:ID="Default" ss:Name="Normal">' + CRLF
        cXml += '<Alignment ss:Vertical="Bottom"/>' + CRLF
        cXml += '<Borders/>' + CRLF
        cXml += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' + CRLF
        cXml += '<Interior/>' + CRLF
        cXml += '<NumberFormat/>' + CRLF
        cXml += '<Protection/>' + CRLF
        cXml += '</Style>' + CRLF
        cXml += '<Style ss:ID="s16" ss:Name="Vírgula">' + CRLF
        cXml += '<NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>' + CRLF
        cXml += '</Style>' + CRLF
        cXml += '<Style ss:ID="s70">' + CRLF
        cXml += '<Font ss:FontName="Arial Narrow" x:Family="Swiss" ss:Size="8" ss:Color="#000000"' + CRLF
        cXml += 'ss:Bold="1"/>' + CRLF
        cXml += '<NumberFormat ss:Format="@"/>' + CRLF
        cXml += '</Style>' + CRLF
        cXml += '<Style ss:ID="s71">' + CRLF
        cXml += '<Font ss:FontName="Arial Narrow" x:Family="Swiss" ss:Size="8" ss:Color="#000000"' + CRLF
        cXml += 'ss:Bold="1"/>' + CRLF
        cXml += '</Style>' + CRLF
        cXml += '<Style ss:ID="s72">' + CRLF
        cXml += '<Font ss:FontName="Arial Narrow" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>' + CRLF
        cXml += '</Style>' + CRLF
        cXml += '<Style ss:ID="s73">' + CRLF
        cXml += '<Font ss:FontName="Arial Narrow" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>' + CRLF
        cXml += '<NumberFormat ss:Format="@"/>' + CRLF
        cXml += '</Style>' + CRLF
        cXml += '<Style ss:ID="s74">' + CRLF
        cXml += '<Font ss:FontName="Arial Narrow" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>' + CRLF
        cXml += '<NumberFormat ss:Format="#,##0"/>' + CRLF
        cXml += '</Style>' + CRLF
        cXml += '<Style ss:ID="s75">' + CRLF
        cXml += '<Font ss:FontName="Arial Narrow" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>' + CRLF
        cXml += '<NumberFormat ss:Format="Standard"/>' + CRLF
        cXml += '</Style>' + CRLF
        cXml += '<Style ss:ID="s76" ss:Parent="s16">' + CRLF
        cXml += '<Font ss:FontName="Arial Narrow" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>' + CRLF
        cXml += '</Style>' + CRLF
        cXml += '<Style ss:ID="s77" ss:Parent="s16">' + CRLF
        cXml += '<Font ss:FontName="Arial Narrow" x:Family="Swiss" ss:Size="8" ss:Color="#000000"' + CRLF
        cXml += 'ss:Bold="1"/>' + CRLF
        cXml += '</Style>' + CRLF
        cXml += '</Styles>' + CRLF


        cXml += '<Worksheet ss:Name="CTe">' + CRLF
        cXml += '<Table x:FullColumns="1"' + CRLF
        cXml += 'x:FullRows="1" ss:StyleID="s72">' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:Width="43.5"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:Width="53.25"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:Width="36.75"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:Width="24"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:Width="159"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:Width="135"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:Width="50"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="61.5"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="76.5"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:Width="67.5"/>' + CRLF
        cXml += '<Column ss:StyleID="s72" ss:Width="32.25"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:Width="59.25"/>' + CRLF
        cXml += '<Column ss:StyleID="s72" ss:Width="36"/>' + CRLF
        cXml += '<Column ss:StyleID="s72" ss:Width="40.5"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="170"/>' + CRLF

        cXml += '<Row>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">COD.PROD</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">COD.FORNEC</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">LINHA</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">TIPO</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">REMETENTE</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">ENDERECO</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">BAIRRO</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">MUNICIPIO</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">CPF / CNPJ</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">INSC. EST.:</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s71"><Data ss:Type="String">QUANT.</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">N.FISCAL</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s71"><Data ss:Type="String">VALOR</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s71"><Data ss:Type="String">FRETE</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">CHAVE</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">EMISSAO</Data></Cell>' + CRLF
        cXml += '</Row>' + CRLF

        While (cAliasQry)->( !Eof()) .AND. (cAliasQry)->(TIPOEMISS) == 'CTE' .AND. SubStr((cAliasQry)->(F1_FORNECE),1,6) == cForTrans

            cXml += '<Row>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(LBB_CODPRO) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(LBB_CODFOR) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(LBB_LINHA) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">CTE</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(LBB_NOMFOR) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(LBB_DESC) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">ZONA RURAL</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(LBB_MUN) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(A2_CGC) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(A2_INSCR) + '</Data></Cell>' + CRLF
            cXml += '<Cell ss:StyleID="s74"><Data ss:Type="Number">' + cValToChar((cAliasQry)->(D1_QUANT)) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(F1_DOC) + '</Data></Cell>' + CRLF
            cXml += '<Cell ss:StyleID="s75"><Data ss:Type="Number">' + cValToChar((cAliasQry)->(F1_VALBRUT)) + '</Data></Cell>' + CRLF
            cXml += '<Cell ss:StyleID="s75"><Data ss:Type="Number">' + cValToChar((cAliasQry)->(FRETE)) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(F1_CHVNFE) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + DTOC(MV_PAR01) + '</Data></Cell>' + CRLF
            cXml += '</Row>' + CRLF

            nTotCTE += (cAliasQry)->(FRETE)
            nTotGer += (cAliasQry)->(FRETE)
            nTotLit += (cAliasQry)->(D1_QUANT)
            nTotMer += (cAliasQry)->(F1_VALBRUT)

            (cAliasQry)->( dbskip())

        EndDo


        cXml += '<Row>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">TOTAL LITROS</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s74"><Data ss:Type="Number">' + cValToChar(Round(nTotLit,0)) + '</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">TOTAL CTE</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s77"><Data ss:Type="Number">' + cValToChar(nTotMer) + '</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s77"><Data ss:Type="Number">' + cValToChar(nTotCTE) + '</Data></Cell>' + CRLF
        cXml += '</Row>' + CRLF

        cXml += '</Table>' + CRLF
        cXml += '<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' + CRLF
        cXml += '<PageSetup>' + CRLF
        cXml += '<Header x:Margin="0.31496062000000002"/>' + CRLF
        cXml += '<Footer x:Margin="0.31496062000000002"/>' + CRLF
        cXml += '<PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"' + CRLF
        cXml += 'x:Right="0.511811024" x:Top="0.78740157499999996"/>' + CRLF
        cXml += '</PageSetup>' + CRLF
        cXml += '<Print>' + CRLF
        cXml += '<ValidPrinterInfo/>' + CRLF
        cXml += '<PaperSizeIndex>9</PaperSizeIndex>' + CRLF
        cXml += '<VerticalResolution>0</VerticalResolution>' + CRLF
        cXml += '</Print>' + CRLF
        cXml += '<Selected/>' + CRLF
        cXml += '<FreezePanes/>' + CRLF
        cXml += '<FrozenNoSplit/>' + CRLF
        cXml += '<SplitHorizontal>1</SplitHorizontal>' + CRLF
        cXml += '<TopRowBottomPane>1</TopRowBottomPane>' + CRLF
        cXml += '<ActivePane>2</ActivePane>' + CRLF
        cXml += '<Panes>' + CRLF
        cXml += '<Pane>' + CRLF
        cXml += '<Number>3</Number>' + CRLF
        cXml += '</Pane>' + CRLF
        cXml += '<Pane>' + CRLF
        cXml += '<Number>2</Number>' + CRLF
        cXml += '<ActiveRow>0</ActiveRow>' + CRLF
        cXml += '</Pane>' + CRLF
        cXml += '</Panes>' + CRLF
        cXml += '<ProtectObjects>False</ProtectObjects>' + CRLF
        cXml += '<ProtectScenarios>False</ProtectScenarios>' + CRLF
        cXml += '</WorksheetOptions>' + CRLF
        cXml += '</Worksheet>' + CRLF

        cXml += '<Worksheet ss:Name="NFs">' + CRLF
        cXml += '<Table x:FullColumns="1"' + CRLF
        cXml += 'x:FullRows="1" ss:StyleID="s72">' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:Width="43.5"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:Width="53.25"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:Width="36.75"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:Width="24"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:Width="159"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:Width="135"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:Width="50"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="61.5"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="76.5"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:Width="67.5"/>' + CRLF
        cXml += '<Column ss:StyleID="s72" ss:Width="32.25"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:Width="59.25"/>' + CRLF
        cXml += '<Column ss:StyleID="s72" ss:Width="36"/>' + CRLF
        cXml += '<Column ss:StyleID="s72" ss:Width="44.25"/>' + CRLF
        cXml += '<Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="170"/>' + CRLF

        cXml += '<Row>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">COD.PROD</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">COD.FORNEC</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">LINHA</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">TIPO</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">REMETENTE</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">ENDERECO</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">BAIRRO</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">MUNICIPIO</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">CPF / CNPJ</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">INSC. EST.:</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s71"><Data ss:Type="String">QUANT.</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">N.FISCAL</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s71"><Data ss:Type="String">VALOR</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s71"><Data ss:Type="String">FRETE</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">CHAVE</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">EMISSAO</Data></Cell>' + CRLF
        cXml += '</Row>' + CRLF

        nTotLit := 0
        nTotMer := 0

        While (cAliasQry)->( !Eof()) .AND. (cAliasQry)->(TIPOEMISS) == 'NFS' .AND. SubStr((cAliasQry)->(F1_FORNECE),1,6) == cForTrans

            cXml += '<Row>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(LBB_CODPRO) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(LBB_CODFOR) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(LBB_LINHA) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">NFS</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(LBB_NOMFOR) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(LBB_DESC) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">ZONA RURAL</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(LBB_MUN) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(A2_CGC) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(A2_INSCR) + '</Data></Cell>' + CRLF
            cXml += '<Cell ss:StyleID="s74"><Data ss:Type="Number">' + cValToChar((cAliasQry)->(D1_QUANT)) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(F1_DOC) + '</Data></Cell>' + CRLF
            cXml += '<Cell ss:StyleID="s75"><Data ss:Type="Number">' + cValToChar((cAliasQry)->(F1_VALBRUT)) + '</Data></Cell>' + CRLF
            cXml += '<Cell ss:StyleID="s75"><Data ss:Type="Number">' + cValToChar((cAliasQry)->(FRETE)) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + (cAliasQry)->(F1_CHVNFE) + '</Data></Cell>' + CRLF
            cXml += '<Cell><Data ss:Type="String">' + DTOC(MV_PAR01) + '</Data></Cell>' + CRLF
            cXml += '</Row>' + CRLF

            nTotNFS += (cAliasQry)->(FRETE)
            nTotGer += (cAliasQry)->(FRETE)
            nTotLit += (cAliasQry)->(D1_QUANT)
            nTotMer += (cAliasQry)->(F1_VALBRUT)

            (cAliasQry)->( dbskip())

        EndDo

        cXml += '<Row>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s71"><Data ss:Type="String">TOTAL LITROS</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s74"><Data ss:Type="Number">' + cValToChar(Round(nTotLit,0)) + '</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s71"><Data ss:Type="String">TOTAL NFS</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s76"><Data ss:Type="Number">' + cValToChar(nTotMer) + '</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s76"><Data ss:Type="Number">' + cValToChar(nTotNFS) + '</Data></Cell>' + CRLF
        cXml += '</Row>' + CRLF
        cXml += '<Row>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s71"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s71"><Data ss:Type="String">TOTAL CTE</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s71"/>' + CRLF
        cXml += '<Cell ss:StyleID="s76"><Data ss:Type="Number">' + cValToChar(nTotCTE) + '</Data></Cell>' + CRLF
        cXml += '</Row>' + CRLF
        cXml += '<Row>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s71"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s70"><Data ss:Type="String">TOTAL GERAL</Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s71"/>' + CRLF
        cXml += '<Cell ss:StyleID="s77"><Data ss:Type="Number">' + cValToChar(nTotCTE+nTotNFS) + '</Data></Cell>' + CRLF
        cXml += '</Row>' + CRLF

        cXml += '</Table>' + CRLF
        cXml += '<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' + CRLF
        cXml += '<PageSetup>' + CRLF
        cXml += '<Header x:Margin="0.31496062000000002"/>' + CRLF
        cXml += '<Footer x:Margin="0.31496062000000002"/>' + CRLF
        cXml += '<PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"' + CRLF
        cXml += 'x:Right="0.511811024" x:Top="0.78740157499999996"/>' + CRLF
        cXml += '</PageSetup>' + CRLF
        cXml += '<Print>' + CRLF
        cXml += '<ValidPrinterInfo/>' + CRLF
        cXml += '<PaperSizeIndex>9</PaperSizeIndex>' + CRLF
        cXml += '<VerticalResolution>0</VerticalResolution>' + CRLF
        cXml += '</Print>' + CRLF
        cXml += '<FreezePanes/>' + CRLF
        cXml += '<FrozenNoSplit/>' + CRLF
        cXml += '<SplitHorizontal>1</SplitHorizontal>' + CRLF
        cXml += '<TopRowBottomPane>1</TopRowBottomPane>' + CRLF
        cXml += '<ActivePane>2</ActivePane>' + CRLF
        cXml += '<Panes>' + CRLF
        cXml += '<Pane>' + CRLF
        cXml += '<Number>3</Number>' + CRLF
        cXml += '</Pane>' + CRLF
        cXml += '<Pane>' + CRLF
        cXml += '<Number>2</Number>' + CRLF
        cXml += '<ActiveRow>0</ActiveRow>' + CRLF
        cXml += '</Pane>' + CRLF
        cXml += '</Panes>' + CRLF
        cXml += '<ProtectObjects>False</ProtectObjects>' + CRLF
        cXml += '<ProtectScenarios>False</ProtectScenarios>' + CRLF
        cXml += '</WorksheetOptions>' + CRLF
        cXml += '</Worksheet>' + CRLF

        cXml += '</Workbook>' + CRLF

		fWrite(nHdlimp,cXml)
		fClose(nHdlImp)

	EndDo

Return
