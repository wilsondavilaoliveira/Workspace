#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} QUAR082R()=============================================================================================================================
Relatorio emissao de Nfe,Nfs carreteiro x contabilidade
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
User Function QUAR082R()

	Local cPulaLin	:= CRLF
	Private cPath := ''
	Private cAliasQry  := GetNextAlias()
	
	If Pergunte("QUAR082R",.T.)
		
		cPath := cGetFile ( ,, 1,, .F., GETF_RETDIRECTORY+GETF_LOCALHARD)
		
		If !Empty(cPath)
		
			BeginSql Alias cAliasQry
			
			%noparser%
			
			SELECT D1_COD,D1_QUANT,LBB_CODPRO,LBB_NOMFOR,LBB_LINHA,LBC_CODROT,LBC_DESC,F1_EMISSAO,F1_DOC+'-'+F1_SERIE AS F1_DOC,F1_CHVNFE 
			FROM %table:SF1% SF1
			INNER JOIN %table:SD1% SD1 ON F1_FILIAL=D1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND D1_FORNECE=F1_FORNECE 
			AND D1_LOJA=F1_LOJA AND SD1.%notDel%
			INNER JOIN %table:LBB% LBB ON LBB_FILIAL=F1_FILIAL AND LBB_CODFOR=F1_FORNECE AND LBB_LOJA=F1_LOJA AND LBB.%notDel%
			INNER JOIN %table:LBC% LBC ON LBC_FILIAL=LBB_FILIAL AND LBC_CODROT=LBB_LINHA AND LBC.%notDel%
			WHERE F1_FILIAL=%Exp:cFilAnt% AND SF1.%notDel% AND F1_EMISSAO = %Exp:MV_PAR01%  AND F1_XLINHA<>''
			ORDER BY LBC_CODROT,F1_FORNECE,F1_LOJA
		
			EndSql
			
			aRet := GetLastQuery()
				
			MemoWrite("C:\HD\RELATORIOS\QUAR082R.SQL",aRet[2])	
				
			If (cAliasQry)->(!EOF())
				MsAguarde({|| GeraRel()},"Aguarde...","Gerando Reltorios..aguarde!",.T.)
			EndIf
			MsgAlert("Relatorios criados no diretorio:" + cPath)
		End If
	
	End If


Return

/*/{Protheus.doc} GeraRel()==============================================================================================================================
Funcao auxiliar Relatorio emissao de Nfe,Nfs carreteiro x contabilidade
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/

Static Function GeraRel()

	Local cXml := ''
	Local cRota := ''
	
	While (cAliasQry)->(!EOF())
	
		cRota := (cAliasQry)->(LBC_CODROT)
		
		fErase(cPath+'\'+Alltrim((cAliasQry)->(LBC_CODROT)+'_'+(cAliasQry)->(LBC_DESC))+'.XLS')
		nHdlImp := fCreate(cPath+'\'+Alltrim((cAliasQry)->(LBC_CODROT)+'_'+(cAliasQry)->(LBC_DESC))+'.XLS', 0)
		
		MsProcTxt("Carreteiro >>> " + (cAliasQry)->(LBC_CODROT)+'_'+(cAliasQry)->(LBC_DESC))
		
		cXml := '<?xml version="1.0"?>' + CRLF
		cXml += '<?mso-application progid="Excel.Sheet"?>' + CRLF
		cXml += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"' + CRLF
		cXml += 'xmlns:o="urn:schemas-microsoft-com:office:office"' + CRLF
		cXml += 'xmlns:x="urn:schemas-microsoft-com:office:excel"' + CRLF
		cXml += 'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"' + CRLF
		cXml += 'xmlns:html="http://www.w3.org/TR/REC-html40">' + CRLF
		cXml += '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">' + CRLF
		cXml += '<Author>Wilson</Author>' + CRLF
		cXml += '<LastAuthor>Wilson</LastAuthor>' + CRLF
		cXml += '<Created>2020-02-11T02:49:11Z</Created>' + CRLF
		cXml += '<LastSaved>2020-02-11T02:56:10Z</LastSaved>' + CRLF
		cXml += '<Version>16.00</Version>' + CRLF
		cXml += '</DocumentProperties>' + CRLF
		cXml += '<OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">' + CRLF
		cXml += '<AllowPNG/>' + CRLF
		cXml += '</OfficeDocumentSettings>' + CRLF
		cXml += '<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">' + CRLF
		cXml += '<WindowHeight>7485</WindowHeight>' + CRLF
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
		cXml += '<Style ss:ID="s62">' + CRLF
		cXml += '<NumberFormat ss:Format="@"/>' + CRLF
		cXml += '</Style>' + CRLF
		cXml += '<Style ss:ID="s65">' + CRLF
		cXml += '<Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>' + CRLF
		cXml += '<NumberFormat ss:Format="@"/>' + CRLF
		cXml += '</Style>' + CRLF
		cXml += '<Style ss:ID="s66">' + CRLF
		cXml += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>' + CRLF
		cXml += '<NumberFormat ss:Format="@"/>' + CRLF
		cXml += '</Style>' + CRLF
		cXml += '<Style ss:ID="s67">' + CRLF
		cXml += '<Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>' + CRLF
		cXml += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>' + CRLF
		cXml += '<NumberFormat ss:Format="@"/>' + CRLF
		cXml += '</Style>' + CRLF
		cXml += '</Styles>' + CRLF
		cXml += '<Worksheet ss:Name="Planilha1">' + CRLF
		cXml += '<Table ss:ExpandedColumnCount="5" x:FullColumns="1" x:FullRows="1" ss:StyleID="s62" ss:DefaultRowHeight="15">' + CRLF
		cXml += '<Column ss:StyleID="s62" ss:Width="67.5"/>' + CRLF
		cXml += '<Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="238.5"/>' + CRLF
		cXml += '<Column ss:StyleID="s65" ss:AutoFitWidth="0"/>' + CRLF
		cXml += '<Column ss:StyleID="s62" ss:Width="72.75"/>' + CRLF
		cXml += '<Column ss:StyleID="s62" ss:Width="243"/>' + CRLF
		cXml += '<Row>' + CRLF
		cXml += '<Cell ss:StyleID="s66"><Data ss:Type="String">Carreteiro:</Data></Cell>' + CRLF
		
		cXml += '<Cell><Data ss:Type="String">'+(cAliasQry)->(LBC_CODROT)+'_'+(cAliasQry)->(LBC_DESC)+'</Data></Cell>' + CRLF
		
		cXml += '</Row>' + CRLF
		cXml += '<Row ss:Index="3">' + CRLF
		cXml += '<Cell ss:StyleID="s66"><Data ss:Type="String">Cod.Produtor</Data></Cell>' + CRLF
		cXml += '<Cell ss:StyleID="s66"><Data ss:Type="String">Produtor</Data></Cell>' + CRLF
		cXml += '<Cell ss:StyleID="s67"><Data ss:Type="String">Litros</Data></Cell>' + CRLF
		cXml += '<Cell ss:StyleID="s66"><Data ss:Type="String">Nota Fiscal</Data></Cell>' + CRLF
		cXml += '<Cell ss:StyleID="s66"><Data ss:Type="String">Chave Nfe</Data></Cell>' + CRLF
		cXml += '</Row>' + CRLF
		
		While (cAliasQry)->(!Eof()) .AND. cRota == (cAliasQry)->(LBC_CODROT)
		
			cXml += '<Row>' + CRLF
			cXml += '<Cell><Data ss:Type="String">'+(cAliasQry)->(LBB_CODPRO)+'</Data></Cell>' + CRLF
			cXml += '<Cell><Data ss:Type="String">'+AllTrim((cAliasQry)->(LBB_NOMFOR))+'</Data></Cell>' + CRLF
			cXml += '<Cell><Data ss:Type="String">'+cValToChar((cAliasQry)->(D1_QUANT))+'</Data></Cell>' + CRLF
			cXml += '<Cell><Data ss:Type="String">'+(cAliasQry)->(F1_DOC)+'</Data></Cell>' + CRLF
			cXml += '<Cell><Data ss:Type="String">'+(cAliasQry)->(F1_CHVNFE)+'</Data></Cell>' + CRLF
			cXml += '</Row>' + CRLF
			
			(cAliasQry)->(dBSkip())
		
		EndDo
		
		cXml += '</Table>' + CRLF
		cXml += '<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' + CRLF
		cXml += '<PageSetup>' + CRLF
		cXml += '<Header x:Margin="0.31496062000000002"/>' + CRLF
		cXml += '<Footer x:Margin="0.31496062000000002"/>' + CRLF
		cXml += '<PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024" x:Right="0.511811024" x:Top="0.78740157499999996"/>' + CRLF
		cXml += '</PageSetup>' + CRLF
		cXml += '<Print>' + CRLF
		cXml += '<ValidPrinterInfo/>' + CRLF
		cXml += '<PaperSizeIndex>9</PaperSizeIndex>' + CRLF
		cXml += '<VerticalResolution>0</VerticalResolution>' + CRLF
		cXml += '</Print>' + CRLF
		cXml += '<Selected/>' + CRLF
		cXml += '<FreezePanes/>' + CRLF
		cXml += '<FrozenNoSplit/>' + CRLF
		cXml += '<SplitHorizontal>3</SplitHorizontal>' + CRLF
		cXml += '<TopRowBottomPane>3</TopRowBottomPane>' + CRLF
		cXml += '<ActivePane>2</ActivePane>' + CRLF
		cXml += '<Panes>' + CRLF
		cXml += '<Pane>' + CRLF
		cXml += '<Number>3</Number>' + CRLF
		cXml += '</Pane>' + CRLF
		cXml += '<Pane>' + CRLF
		cXml += '<Number>2</Number>' + CRLF
		cXml += '<ActiveRow>0</ActiveRow>' + CRLF
		cXml += '<ActiveCol>4</ActiveCol>' + CRLF
		cXml += '</Pane>' + CRLF
		cXml += '</Panes>' + CRLF
		cXml += '<ProtectObjects>False</ProtectObjects>' + CRLF
		cXml += '<ProtectScenarios>False</ProtectScenarios>' + CRLF
		cXml += '</WorksheetOptions>' + CRLF
		cXml += '</Worksheet>' + CRLF
		cXml += '</Workbook>' + CRLF
		
		fWrite(nHdlimp,cXml)
		fClose(nHdlImp)
		
	EndDo

Return