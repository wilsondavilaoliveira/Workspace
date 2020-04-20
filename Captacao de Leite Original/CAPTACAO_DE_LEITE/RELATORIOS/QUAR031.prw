#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQUAR031   บ Autor ณ Wilson Davila      บ Data ณ  26/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio notas fiscais entrada emitidas IBGE              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function QUAR031


oProcess := MsNewProcess():New({|| Process(oProcess) },"relatorio IBGE ","Processando Relatorio: ",.T.)
oProcess:Activate()	


MSGALERT("Final de Processamento")


Return



Static Function Process(oObj)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cQuery 	:= ""
Local aBonif	:= {}
Local aQuant	:= {}
Local aConv		:= {}
Local nTotal	:= 0
Local nTotal1	:= 0
Local nBonif	:= 0
Local nProj		:= 0                    
Local nQuant	:= 0
Local aDados	:= {}

If Pergunte("QUAR031",.T.)


cQuery := "SELECT Convert(VARCHAR(12),Cast(F1_EMISSAO As smalldatetime),103) EMISSAO," + CRLF
cQuery += "F1_DOC ,D1_QUANT,D1_VUNIT,D1_TOTAL,LBB_LINHA,LBB_CODPRO, " + CRLF//RONALDO 12/05/2017 INCLUIDO DATA DE EMISSAO CHAMADO 001687
cQuery += "A2_COD,A2_NOME,A2_END,A2_BAIRRO,A2_MUN,A2_EST,A2_CEP,A2_CGC,A2_INSCR " + CRLF
cQuery += "FROM " + RetSqlName("SF1") + " SF1 "  + CRLF
cQuery += "INNER JOIN " + RetSqlName("SD1") + " SD1 ON SF1.F1_FILIAL=SD1.D1_FILIAL AND SF1.F1_DOC=SD1.D1_DOC AND SF1.F1_SERIE=SD1.D1_SERIE " + CRLF   
cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2 ON SA2.A2_COD=SF1.F1_FORNECE AND SA2.A2_LOJA=SF1.F1_LOJA AND SA2.D_E_L_E_T_='' " + CRLF
cQuery += "INNER JOIN " + RetSqlName("LBB") + " LBB ON LBB.LBB_CODFOR=SA2.A2_COD AND LBB.LBB_LOJA=SA2.A2_LOJA  " + CRLF
cQuery += "WHERE SF1.D_E_L_E_T_='' AND SD1.D_E_L_E_T_=''  AND SA2.D_E_L_E_T_='' AND LBB.D_E_L_E_T_='' AND   " + CRLF
cQuery += "SF1.F1_EMISSAO='" + dtos(MV_PAR01) + "' AND SF1.F1_FORMUL='S' AND SF1.F1_FILIAL='" + cFilAnt + "' AND SD1.D1_COD='200113' ORDER BY D1_DOC " + CRLF


MemoWrite("C:\QUAR031.SQL",cQuery)

If Select("QRY030")>0
QRY030->(dbCloseArea())
End If

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRY030', .F., .T.)


QRY030->( dbGoTop() )

nCount := QRY030->( RecCount() )

oObj:SetRegua1(nCount)
oObj:SetRegua2(nCount)                        

nRegistro := 1

While QRY030->( !Eof() )
	
	oObj:IncRegua1("Registro --> " + QRY030->(F1_DOC) )   	
	oObj:IncRegua2("Registro  --> " + QRY030->(F1_DOC) )

	//F1_EMISSAO,F1_DOC ,D1_QUANT,D1_VUNIT,D1_TOTAL,LBB_LINHA,LBB_CODPRO,A2_COD,A2_NOME,A2_END,A2_BAIRRO,A2_MUN,A2_EST,A2_CEP,A2_CGC,A2_INSCR,
	
	AADD(aDados,{	QRY030->(EMISSAO),QRY030->(F1_DOC),QRY030->(D1_QUANT),QRY030->(D1_VUNIT),QRY030->(D1_TOTAL),QRY030->(LBB_LINHA),;//RONALDO 12/05/2017 INCLUIDO DATA DE EMISSAO CHAMADO 001687
					QRY030->(LBB_CODPRO),QRY030->(A2_COD),QRY030->(A2_NOME),QRY030->(A2_END),QRY030->(A2_BAIRRO),QRY030->(A2_MUN),;
					QRY030->(A2_EST),QRY030->(A2_CEP),QRY030->(A2_CGC),QRY030->(A2_INSCR)})	
			
QRY030->( DbSkip() )

End While

GEREXCEL(aDados)

End If

Return

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGEREXCEL  บAutor  ณWilson Davila       บ Data ณ  03/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera relatorio de resumo das comissoes para excel           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10 - Quata                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GEREXCEL(aDados)

Local cXml		:= ' '
Local cDir		:= ''

For i:= 1 to len(alltrim(MV_PAR02))

	cDir += substr(MV_PAR02,i,1)
	
	If Len(MV_PAR02) - i == 1
	
		If substr(MV_PAR02,i+1,1) == '\'
			i := Len(MV_PAR02)
		End If
	End If

Next

fErase(cDir+'\ENTRADA_NOTAS_LEITE.XML')
nHdlImp := fCreate(cDir+'\ENTRADA_NOTAS_LEITE.XML', 0)

cXml :='<?xml version="1.0"?>' + CRLF
cXml +='<?mso-application progid="Excel.Sheet"?>' + CRLF
cXml +='<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"' + CRLF
cXml +='xmlns:o="urn:schemas-microsoft-com:office:office"' + CRLF
cXml +='xmlns:x="urn:schemas-microsoft-com:office:excel"' + CRLF
cXml +='xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"' + CRLF
cXml +='xmlns:html="http://www.w3.org/TR/REC-html40">' + CRLF
cXml +='<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">' + CRLF
cXml +='<Author>Wilson Davila</Author>' + CRLF
cXml +='<LastAuthor>Wilson Davila</LastAuthor>' + CRLF
cXml +='<Created>2013-12-06T18:37:13Z</Created>' + CRLF
cXml +='<LastSaved>2013-12-26T13:48:55Z</LastSaved>' + CRLF
cXml +='<Version>15.00</Version>' + CRLF
cXml +='</DocumentProperties>' + CRLF
cXml +='<OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">' + CRLF
cXml +='<AllowPNG/>' + CRLF
cXml +='</OfficeDocumentSettings>' + CRLF
cXml +='<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">' + CRLF
cXml +='<WindowHeight>7755</WindowHeight>' + CRLF
cXml +='<WindowWidth>20490</WindowWidth>' + CRLF
cXml +='<WindowTopX>0</WindowTopX>' + CRLF
cXml +='<WindowTopY>0</WindowTopY>' + CRLF
cXml +='<ProtectStructure>False</ProtectStructure>' + CRLF
cXml +='<ProtectWindows>False</ProtectWindows>' + CRLF
cXml +='</ExcelWorkbook>' + CRLF
cXml +='<Styles>' + CRLF
cXml +='<Style ss:ID="Default" ss:Name="Normal">' + CRLF
cXml +='<Alignment ss:Vertical="Bottom"/>' + CRLF
cXml +='<Borders/>' + CRLF
cXml +='<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' + CRLF
cXml +='<Interior/>' + CRLF
cXml +='<NumberFormat/>' + CRLF
cXml +='<Protection/>' + CRLF
cXml +='</Style>' + CRLF
cXml +='<Style ss:ID="s57">' + CRLF
cXml +='<NumberFormat ss:Format="@"/>' + CRLF
cXml +='</Style>' + CRLF
cXml +='<Style ss:ID="s58">' + CRLF
cXml +='<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"' + CRLF
cXml +='ss:Bold="1"/>' + CRLF
cXml +='<NumberFormat ss:Format="@"/>' + CRLF
cXml +='</Style>' + CRLF
cXml +='<Style ss:ID="s59">' + CRLF
cXml +='<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"' + CRLF
cXml +='ss:Bold="1"/>' + CRLF
cXml +='</Style>' + CRLF
cXml +='</Styles>' + CRLF
cXml +='<Worksheet ss:Name="PLANILHA">' + CRLF
//cXml +='<Table ss:ExpandedColumnCount="17" ss:ExpandedRowCount="638" x:FullColumns="1"' + CRLF
cXml +='<Table ss:ExpandedColumnCount="17" x:FullColumns="1"' + CRLF
cXml +='x:FullRows="1" ss:DefaultRowHeight="15">' + CRLF
cXml +='<Column ss:Width="66.5"/>' + CRLF
cXml +='<Column ss:Width="56.25"/>' + CRLF
cXml +='<Column ss:Width="61.5"/>' + CRLF
cXml +='<Column ss:Width="52.5"/>' + CRLF
cXml +='<Column ss:Width="55.5"/>' + CRLF
cXml +='<Column ss:Width="66.75"/>' + CRLF
cXml +='<Column ss:Width="42.75"/>' + CRLF
cXml +='<Column ss:Width="338.25"/>' + CRLF
cXml +='<Column ss:Width="234"/>' + CRLF
cXml +='<Column ss:Width="130.5"/>' + CRLF
cXml +='<Column ss:Width="174.75"/>' + CRLF
cXml +='<Column ss:Width="38.25"/>' + CRLF
cXml +='<Column ss:Width="47.25"/>' + CRLF
cXml +='<Column ss:Width="79.5"/>' + CRLF
cXml +='<Column ss:Width="84.75"/>' + CRLF
cXml +='<Column ss:Width="107.25"/>' + CRLF
cXml +='<Column ss:Width="85.5"/>' + CRLF
cXml +='<Row>' + CRLF
cXml +='<Cell ss:StyleID="s58"><Data ss:Type="String">EMISSAO</Data></Cell>' + CRLF//RONALDO 12/05/2017 INCLUIDO DATA DE EMISSAO CHAMADO 001687
cXml +='<Cell ss:StyleID="s58"><Data ss:Type="String">DOC</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s59"><Data ss:Type="String">QUANT</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s59"><Data ss:Type="String">VALOR UNIT</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s59"><Data ss:Type="String">TOTLA</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s58"><Data ss:Type="String">LINHA</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s58"><Data ss:Type="String">CODPRO</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s58"><Data ss:Type="String">CODFOR</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s58"><Data ss:Type="String">FORNECEDOR</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s58"><Data ss:Type="String">ENDERECO</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s58"><Data ss:Type="String">BAIRRO</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s58"><Data ss:Type="String">MUNICIPIO</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s58"><Data ss:Type="String">EST</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s58"><Data ss:Type="String">CEP</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s58"><Data ss:Type="String">CNPJ / CPF</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s58"><Data ss:Type="String">INCRICAO</Data></Cell>' + CRLF
//cXml +='<Cell ss:StyleID="s58"><Data ss:Type="String">FORMA_PAGAMENTO</Data></Cell>' + CRLF
cXml +='</Row>' + CRLF

fWrite(nHdlimp,cXml)	


For xb := 1 to Len(aDados)
		

cXml :='<Row>' + CRLF
cXml +='<Cell ss:StyleID="s57"><Data ss:Type="String">' + Alltrim(aDados[xb][1]) + '</Data></Cell>' + CRLF//RONALDO 12/05/2017 INCLUIDO DATA DE EMISSAO CHAMADO 001687
cXml +='<Cell ss:StyleID="s57"><Data ss:Type="String">' + Alltrim(aDados[xb][2]) + '</Data></Cell>' + CRLF
cXml +='<Cell><Data ss:Type="Number">' + cValTochar(aDados[xb][3]) + '</Data></Cell>' + CRLF
cXml +='<Cell><Data ss:Type="Number">' + cValTochar(aDados[xb][4]) + '</Data></Cell>' + CRLF
cXml +='<Cell><Data ss:Type="Number">' + cValToChar(aDados[xb][5]) + '</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s57"><Data ss:Type="String">' + Alltrim(aDados[xb][6]) + '</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s57"><Data ss:Type="String">' + Alltrim(aDados[xb][7]) + '</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s57"><Data ss:Type="String">' + Alltrim(aDados[xb][8]) + '</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s57"><Data ss:Type="String">' + Alltrim(aDados[xb][9]) + '</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s57"><Data ss:Type="String">' + Alltrim(aDados[xb][10]) + '</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s57"><Data ss:Type="String">' + Alltrim(aDados[xb][11]) + '</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s57"><Data ss:Type="String">' + Alltrim(aDados[xb][12]) + '</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s57"><Data ss:Type="String">' + Alltrim(aDados[xb][13]) + '</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s57"><Data ss:Type="String">' + Alltrim(aDados[xb][14]) + '</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s57"><Data ss:Type="String">' + Alltrim(aDados[xb][15]) + '</Data></Cell>' + CRLF
cXml +='<Cell ss:StyleID="s57"><Data ss:Type="String">' + Alltrim(aDados[xb][16]) + '</Data></Cell>' + CRLF
//cXml +='<Cell ss:StyleID="s57"><Data ss:Type="String">' + Alltrim(aDados[xb][16]) + '</Data></Cell>' + CRLF
cXml +='</Row>' + CRLF

fWrite(nHdlimp,cXml)


Next xb

cXml :='</Table>' + CRLF
cXml +='<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' + CRLF
cXml +='<PageSetup>' + CRLF
cXml +='<Header x:Margin="0.31496062000000002"/>' + CRLF
cXml +='<Footer x:Margin="0.31496062000000002"/>' + CRLF
cXml +='<PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"' + CRLF
cXml +='x:Right="0.511811024" x:Top="0.78740157499999996"/>' + CRLF
cXml +='</PageSetup>' + CRLF
cXml +='<Print>' + CRLF
cXml +='<ValidPrinterInfo/>' + CRLF
cXml +='<PaperSizeIndex>9</PaperSizeIndex>' + CRLF
cXml +='<HorizontalResolution>600</HorizontalResolution>' + CRLF
cXml +='<VerticalResolution>600</VerticalResolution>' + CRLF
cXml +='</Print>' + CRLF
cXml +='<Selected/>' + CRLF
cXml +='<Panes>' + CRLF
cXml +='<Pane>' + CRLF
cXml +='<Number>3</Number>' + CRLF
cXml +='<ActiveRow>12</ActiveRow>' + CRLF
cXml +='<ActiveCol>7</ActiveCol>' + CRLF
cXml +='</Pane>' + CRLF
cXml +='</Panes>' + CRLF
cXml +='<ProtectObjects>False</ProtectObjects>' + CRLF
cXml +='<ProtectScenarios>False</ProtectScenarios>' + CRLF
cXml +='</WorksheetOptions>' + CRLF
cXml +='</Worksheet>' + CRLF
cXml +='</Workbook>' + CRLF

fWrite(nHdlimp,cXml)
fClose(nHdlImp)

if MsgYesno("Deseja abrir a planilha?")

ShellExecute("open", cDir+'/ENTRADA_NOTAS_LEITE.XML', "", "", 1)

End if



Return()
