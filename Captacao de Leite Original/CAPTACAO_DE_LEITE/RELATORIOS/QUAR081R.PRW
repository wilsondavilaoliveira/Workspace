#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} QUAR081R() ============================================================================================================================
Gera planilha base para insercao de dados nas tabelas de qualidade de leite
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/ 
User function QUAR081R()

	Private cPath := cGetFile ( ,, 1,, .F., GETF_RETDIRECTORY+GETF_LOCALHARD)
	
	If !Empty(cPath)
		MsAguarde({|| CriaXml()},"Aguarde...","Gerando Planilha..aguarde!",.T.)
	End If

Return

/*/{Protheus.doc} CriaXml() =============================================================================================================================
Funcao auxiliar geracao de planilha base para insercao de dados nas tabelas de qualidade de leite chamada pela funcao QUAR081R()
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/ 
Static Function CriaXml()

	Local cXml 	:= ''
	Local nCol	:= 0
	
	U_aOrdLJX()
	
	fErase(cPath+'\LEITURAS.XLS')
	nHdlImp := fCreate(cPath+'\LEITURAS.XLS', 0)
	
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
	cXml += '<Created>2020-02-05T20:52:23Z</Created>' + CRLF
	cXml += '<LastSaved>2020-02-06T00:01:49Z</LastSaved>' + CRLF
	cXml += '<Version>16.00</Version>' + CRLF
	cXml += '</DocumentProperties>' + CRLF
	cXml += '<OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">' + CRLF
	cXml += '<AllowPNG/>' + CRLF
	cXml += '</OfficeDocumentSettings>' + CRLF
	cXml += '<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">' + CRLF
	cXml += '<WindowHeight>11160</WindowHeight>' + CRLF
	cXml += '<WindowWidth>20730</WindowWidth>' + CRLF
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
	cXml += '<Style ss:ID="s16">' + CRLF
	cXml += '<NumberFormat ss:Format="@"/>' + CRLF
	cXml += '</Style>' + CRLF
	cXml += '<Style ss:ID="s17">' + CRLF
	cXml += '<Borders/>' + CRLF
	cXml += '<NumberFormat ss:Format="@"/>' + CRLF
	cXml += '</Style>' + CRLF
	cXml += '<Style ss:ID="s18">' + CRLF
	cXml += '<Borders/>' + CRLF
	cXml += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>' + CRLF
	cXml += '<Interior ss:Color="#E7E6E6" ss:Pattern="Solid"/>' + CRLF
	cXml += '<NumberFormat ss:Format="@"/>' + CRLF
	cXml += '</Style>' + CRLF
	cXml += '<Style ss:ID="s19">' + CRLF
	cXml += '<Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>' + CRLF
	cXml += '<Borders/>' + CRLF
	cXml += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>' + CRLF
	cXml += '<Interior ss:Color="#E7E6E6" ss:Pattern="Solid"/>' + CRLF
	cXml += '<NumberFormat ss:Format="Standard"/>' + CRLF
	cXml += '</Style>' + CRLF
	cXml += '<Style ss:ID="s20">' + CRLF
	cXml += '<Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>' + CRLF
	cXml += '<Borders/>' + CRLF
	cXml += '<NumberFormat ss:Format="Standard"/>' + CRLF
	cXml += '</Style>' + CRLF
	cXml += '<Style ss:ID="s21">' + CRLF
	cXml += '<Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>' + CRLF
	cXml += '<NumberFormat ss:Format="Standard"/>' + CRLF
	cXml += '</Style>' + CRLF
	cXml += '</Styles>' + CRLF
	cXml += '<Worksheet ss:Name="LEITURAS">' + CRLF
	
	cXml += '<Table x:FullColumns="1" x:FullRows="1" ss:DefaultRowHeight="15">' + CRLF
	
	cXml += '<Column ss:StyleID="s16" ss:Width="56.25"/>' + CRLF
	cXml += '<Column ss:StyleID="s16" ss:AutoFitWidth="0" ss:Width="240.75"/>' + CRLF
	cXml += '<Column ss:StyleID="s21" ss:AutoFitWidth="0" ss:Width="82.5"/>' + CRLF
	
	cXml += '<Row>' + CRLF
	
	LJX->(dbSetOrder(2))
	
	If LJX->(dbSeek(xFilial("LJX")))
	
		cXml += '<Cell ss:StyleID="s18"><Data ss:Type="String">CODIGO</Data></Cell>' + CRLF
		cXml += '<Cell ss:StyleID="s18"><Data ss:Type="String">NOME</Data></Cell>' + CRLF
		
		While LJX->(!Eof()) .AND. LJX->(LJX_FILIAL) == xFilial("LJX") 
			If LJX->(LJX_PLAN) == 'S'
				cXml += '<Cell ss:StyleID="s18"><Data ss:Type="String">' + AllTrim(LJX->(LJX_DESC)) + '</Data></Cell>' + CRLF
				nCol ++
			End If
			LJX->(dbSkip())
		EndDo
	
	Else
	
		cXml += '<Cell ss:StyleID="s18"><Data ss:Type="String">CODIGO</Data></Cell>' + CRLF
		cXml += '<Cell ss:StyleID="s18"><Data ss:Type="String">NOME</Data></Cell>' + CRLF
		cXml += '<Cell ss:StyleID="s19"><Data ss:Type="String">GORDURA</Data></Cell>' + CRLF
		cXml += '<Cell ss:StyleID="s19"><Data ss:Type="String">PROTEINA</Data></Cell>' + CRLF
		cXml += '<Cell ss:StyleID="s19"><Data ss:Type="String">CCS</Data></Cell>' + CRLF
		cXml += '<Cell ss:StyleID="s19"><Data ss:Type="String">CBT</Data></Cell>' + CRLF
		cXml += '<Cell ss:StyleID="s19"><Data ss:Type="String">VOLUME</Data></Cell>' + CRLF
		cXml += '<Cell ss:StyleID="s19"><Data ss:Type="String">DISTANCIA</Data></Cell>' + CRLF
		cXml += '<Cell ss:StyleID="s19"><Data ss:Type="String">TEMPERATURA</Data></Cell>' + CRLF
	
	End If

	cXml += '</Row>' + CRLF
	
	fWrite(nHdlimp,cXml)
	
	
	
	//LJX->(dbSetOrder(2))
	
	//If LJX->(dbSeek(xFilial("LJX")))
		cXml := ''
		For _nRow := 1 To 2500
			cXml += '<Row>' + CRLF
			cXml += '<Cell ss:StyleID="s17"><Data ss:Type="String"></Data></Cell>' + CRLF
			cXml += '<Cell ss:StyleID="s17"><Data ss:Type="String"></Data></Cell>' + CRLF
			
			//While LJX->(!Eof()) .AND. LJX->(LJX_FILIAL) == xFilial("LJX") 
			//	If LJX->(LJX_PLAN) == 'S'
					For _Cell := 1 to nCol
						cXml += '<Cell ss:StyleID="s20"><Data ss:Type="Number">0</Data></Cell>' + CRLF
					Next _Cell
			//	EndIf
			//	LJX->(dbSkip())
			//EndDo
			cXml += '</Row>' + CRLF
		Next _nRow

	fWrite(nHdlimp,cXml)
	//Else
	
	//	cXml += '<Cell ss:StyleID="s17"><Data ss:Type="String"></Data></Cell>' + CRLF
	//	cXml += '<Cell ss:StyleID="s17"><Data ss:Type="String"></Data></Cell>' + CRLF
	//	cXml += '<Cell ss:StyleID="s20"><Data ss:Type="Number">0</Data></Cell>' + CRLF
	//	cXml += '<Cell ss:StyleID="s20"><Data ss:Type="Number">0</Data></Cell>' + CRLF
	//	cXml += '<Cell ss:StyleID="s20"><Data ss:Type="Number">0</Data></Cell>' + CRLF
	//	cXml += '<Cell ss:StyleID="s20"><Data ss:Type="Number">0</Data></Cell>' + CRLF
	//	cXml += '<Cell ss:StyleID="s20"><Data ss:Type="Number">0</Data></Cell>' + CRLF
	//	cXml += '<Cell ss:StyleID="s20"><Data ss:Type="Number">0</Data></Cell>' + CRLF
	//	cXml += '<Cell ss:StyleID="s20"><Data ss:Type="Number">0</Data></Cell>' + CRLF
	
	//EndIf
			
	//cXml += '</Row>' + CRLF
	
	cXml := '</Table>' + CRLF
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
	cXml += '<Panes>' + CRLF
	cXml += '<Pane>' + CRLF
	cXml += '<Number>3</Number>' + CRLF
	cXml += '<ActiveRow>1</ActiveRow>' + CRLF
	cXml += '<ActiveCol>5</ActiveCol>' + CRLF
	cXml += '</Pane>' + CRLF
	cXml += '</Panes>' + CRLF
	cXml += '<ProtectObjects>False</ProtectObjects>' + CRLF
	cXml += '<ProtectScenarios>False</ProtectScenarios>' + CRLF
	cXml += '</WorksheetOptions>' + CRLF
	cXml += '</Worksheet>' + CRLF
	cXml += '</Workbook>' + CRLF
	
	fWrite(nHdlimp,cXml)
	fClose(nHdlImp)
	
	If MsgYesno("Deseja abrir a planilha?")
		ShellExecute("open", cPath+'/LEITURAS.XLS', "", "", 1)
	End if
	
Return

/*/{Protheus.doc} QA081XML() ============================================================================================================================
Funcao principal para leitura de planilha base para insercao de dados tabelas de qualidade de leite 
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/ 
User Function QA081XML()
 
	Local cAlQry 		:= GetNextAlias()
	Private cXML 		:= ""
	Private cArq		:= ""
	Private oXML
	Private xRet
	Private nI 			:= 0, nLen:= 0
	Private lLoop 		:= .T., lRet1 := .F., lRet2 := .F.
	Private nOptions	:= GETF_OVERWRITEPROMPT+GETF_LOCALHARD+GETF_NETWORKDRIVE
  

	If Pergunte("QUAR082R",.T.)
		BeginSql Alias cAlQry
			%noparser%
			SELECT LJZ_DATCLQ FROM %table:LJZ% LJZ WHERE  LJZ_DATCLQ = %Exp:MV_PAR01% AND LJZ.%notDel% 
		EndSql
		
		If (cAlQry)->(Eof())
			MsgStop(OemToAnsi("Náo existe arquivo de leituras montado para esse período!"))
			Return
		End If
	
		  cArq := cGetFile("Arquivos Laboratorio|*.*" ,OemToAnsi("Abrir Arquivo..."),0,,,nOptions)
		  
		  If Empty(cArq)
			Return
		  Else
		  	MsAguarde({|| LerXml()},"Aguarde...","Executando Leitura..aguarde!",.T.)
		  Endif
	End If

Return

/*/{Protheus.doc} LerXml() ============================================================================================================================
Funcao auxiliar para leitura de planilha base para insercao de dados tabelas de qualidade de leite chamada pela funcao QA081XML()
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/ 
Static Function LerXml()

	Local cRet 		:= ''  
	Local lFirst 	:= .T.   
	Local nLinha	:= 0
	Local cQuery	:= ''
	Local nResLei	:= 0  
	Local cLine 	:= ''

	oTXTFile := QUA81RTXT():New(cArq)	

	If !oTXTFile:Open()
		MsgStop(oTXTFile:GetErrorStr(),"OPEN ERROR")
		Return
	Endif
	
	MsProcTxt("Iniciando Leitura...")
	
	While oTXTFile:ReadLine(@cLine)
	  cXML  += cLine
	  MsProcTxt("Processando Leitura  >>>    " + cValToChar(nLinha))
	  nLinha ++
	Enddo
	
	oTXTFile:Close()
	
	  
	oXML := TXmlManager():New()
	   
	xRet := oXML:Parse( cXML )
	If xRet == .F.
	  MsgAlert( "Erro ao ler ar1uivo: " + oXML:Error() )
	  Return
	endif
 
	MsProcTxt("Iniciando Alteracao de dados...")
	cTexto := ''
	While lLoop
	    If AllTrim(oXML:CNAME) == 'Row'
	    	If lFirst
	    		oXML:DOMNextNode()
	    		lFirst := .F.
	    	EndIf
	    	
	    	If oXML:DOMHasChildNode()
	    	aChildren := oXML:DOMGetChildArray()
			    If !Empty(aChildren[1][2])	
			    	cRet := LerProd(aChildren[1][2],LJZ->LJZ_FILIAL)
			    	
			    	For i := 1 To oXML:DOMChildCount()
			    		If i > 2 
				    		LJX->(dbSetOrder(2))
				    		If LJX->(dbSeek(xFilial("LJX")+cValToChar(i-2)))
				    		
				    		nResLei := QuaCAL21(Alltrim(LJX->(LJX_CODBON)),,Val(aChildren[i][2]))
				    			
					    		cQuery := "UPDATE LJZ010 SET LJZ_QTDLEI=" + cValToChar(aChildren[i][2]) + ", " + CRLF 
					    		cQuery += "LJZ_RESLEI=" + cValToChar(nResLei) + " " + CRLF
					    		cQuery += "WHERE LJZ_FILIAL='" + LJZ->LJZ_FILIAL + "' " + CRLF
					    		cQuery += "AND LJZ_CODPRO='" + cRet + "' AND LJZ_DATCLQ='" + cValToChar(DTOS(MV_PAR01)) + "' " + CRLF
					    		cQuery += "AND LJZ_CODBON='" + LJX->(LJX_CODBON) + "'  " + CRLF
					    			
					    		TcSqlExec(cQuery) 
						    End If
			    		End If
			    		
			    		If i == 2
		   		     		MsProcTxt("Produtor >>> " + aChildren[1][2]+"-"+cValToChar(aChildren[i][2]))
			    		End If
				    Next i
		    	End If
	    	End If
	    End If
	    
	    If oXML:DOMHasChildNode()
	      xRet := oXML:DOMChildNode()
	    ElseIf oXML:DOMHasNextNode()
	      xRet := oXML:DOMNextNode()
	    Else
	      lRet1 := oXML:DOMParentNode()
	      If lRet1
	        lRet2 := oXML:DOMNextNode()
	        While !lRet2
	          lRet1 := oXML:DOMParentNode()
	          lRet2 := oXML:DOMNextNode()
	          If !lRet1 .And. !lRet2
	            Return
	          Endif
	        EndDo
	         
	        Loop
	      Else
	        MsgAlert( "Error de estrutura xml" )
	        Return
	      Endif
	    Endif
	EndDo

Return

/*/{Protheus.doc} LerProd() ============================================================================================================================
Funcao auxiliar para buscar codigo de produtor atraves do codigo do laboratorio                                                  
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static Function LerProd(cCodLab,xFil)

	Local cRet := ''

	cQuery := "SELECT LBB_CODPRO FROM " + RetSqlName("LBB") + " LBB WHERE LBB.D_E_L_E_T_='' AND LBB_STATUS='S' AND LBB_FILIAL='" + xFil + "' AND LBB.LBB_CODLAB = '" + cCodLab + "' " + CRLF

	cQuery := ChangeQuery(cQuery)
	
	If Select( "QUERY1" ) > 0
		QUERY1->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery ALIAS QUERY1 NEW
	dbSelectArea("QUERY1")
	dbGoTop()

	If QUERY1->( !Eof() )
		cRet := QUERY1->(LBB_CODPRO)
	End If

Return cRet

/*/{Protheus.doc} QuaCAL21() ============================================================================================================================
Funcao auxiliar para calculo da valorizacao das bonificacoes de acordo com os parametros                                         
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static Function QuaCAL21( cTabQua, cTipoL, nValor)

	Local nResul	:= 0
	Local aArea		:= GetArea()
	Local nTamChave := Len(CriaVar("LJY_CODBON"))  
	
	cTabQua := Left(cTabQua+Space(nTamChave),nTamChave)
	
	dbselectArea("LJY") // Tabela Criterios da Qualidade
	dbSetOrder(2)
	dbseek( xFilial("LJY")+cTabQua )
	Do While !Eof() .And. ;
		( LJY->LJY_FILIAL+LJY->LJY_CODBON = xFilial("LJY")+cTabQua )
		If nValor >= LJY_VInic .And. nValor <= LJY_VFinal
		   nResul := LJY_VResul
	  	   Exit
	    EndIf
		dbSkip()
	EndDo

	RestArea(aArea)
	
Return(nResul)

/*/{Protheus.doc} QUA81RTXT() ===========================================================================================================================
Classe para leitura de arquivo de texto usado para ler planilha de qualidade de leite do laboratorio                           
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/

#DEFINE DEFAULT_FILE_BUFFER 4096

CLASS QUA81RTXT FROM LONGNAMECLASS

  DATA nHnd as Integer
  DATA cFName as String
  DATA cFSep as String
  DATA nFerror as Integer
  DATA nOsError as Integer
  DATA cFerrorStr as String
  DATA nFSize as Integer
  DATA nFReaded as Integer
  DATA nFBuffer as Integer

  DATA _Buffer as Array
  DATA _PosBuffer as Integer
  DATA _Resto as String

  // Metodos Pubicos
  METHOD New()
  METHOD Open()
  METHOD Close()
  METHOD GetFSize()
  METHOD GetError()
  METHOD GetOSError()
  METHOD GetErrorStr()
  METHOD ReadLine()

  // Metodos privados
  METHOD _CleanLastErr()
  METHOD _SetError()
  METHOD _SetOSError()

ENDCLASS

/*/{Protheus.doc} QUA81RTXT() ===========================================================================================================================
METODO leitura de arquivo de texto usado para ler planilha de qualidade de leite do laboratorio                           
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
METHOD New( cFName , cFSep , nFBuffer ) CLASS QUA81RTXT

	DEFAULT cFSep := CRLF
	DEFAULT nFBuffer := DEFAULT_FILE_BUFFER
	
	::nHnd 			:= -1
	::cFName 		:= cFName
	::cFSep 		:= cFSep
	::_Buffer 		:= {}
	::_Resto 		:= ''
	::nFSize 		:= 0
	::nFReaded 		:= 0
	::nFerror 		:= 0
	::nOsError 		:= 0
	::cFerrorStr 	:= ''
	::_PosBuffer 	:= 0
	::nFBuffer 		:= nFBuffer

Return self

/*/{Protheus.doc} QUA81RTXT() ===========================================================================================================================
METODO abertura de arquivo                           
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
METHOD Open( iFMode ) CLASS QUA81RTXT

	DEFAULT iFMode := 0

	::_CleanLastErr()
	If ::nHnd != -1
		 _SetError(-1,"Open Error - File already open")
		 Return .F.
	Endif

	::nHnd := FOpen( ::cFName , iFMode )
	If ::nHnd < 0
		 _SetOSError(-2,"Open File Error (OS)",ferror())
		Return .F.
	Endif

	::nFSize := fSeek(::nHnd,0,2)

	fSeek(::nHnd,0)
Return .T.

/*/{Protheus.doc} QUA81RTXT() ===========================================================================================================================
METODO FECHAMENTO DE ARQUIVO                         
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
METHOD Close() CLASS QUA81RTXT
	
	::_CleanLastErr()
	
	If ::nHnd == -1
		 _SetError(-3,"Close Error - File already closed")
		Return .F.
	Endif

	fClose(::nHnd)

	aSize(::_Buffer,0)
	
	::_Resto 		:= ''
	::nHnd 			:= -1
	::nFSize 		:= 0
	::nFReaded 		:= 0
	::_PosBuffer 	:= 0

Return .T.

/*/{Protheus.doc} QUA81RTXT() ===========================================================================================================================
METODO LEITURA DE LINHA                              
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
METHOD ReadLine( /*@*/ cReadLine ) CLASS QUA81RTXT

	Local cTmp := ''
	Local cBuffer
	Local nRPos
	Local nRead

	::_PosBuffer++
	If ( ::_PosBuffer <= len(::_Buffer) )
		 cReadLine := ::_Buffer[::_PosBuffer]
		 Return .T.
	Endif
	
	If ( ::nFReaded < ::nFSize )
	
		  nRead := fRead(::nHnd , @cTmp, ::nFBuffer)
	
		  if nRead < 0
		    _SetOSError(-5,"Read File Error (OS)",ferror())
		    Return .F.
		  Endif
		
		  ::nFReaded += nRead
		
		  cBuffer := ::_Resto + cTmp
		
		  nRPos := Rat(::cFSep,cBuffer)
	
		  If nRPos > 0
		    ::_Resto := substr(cBuffer , nRPos + len(::cFSep))
		    cBuffer := left(cBuffer , nRPos-1 )
		  Else
		    ::_Resto := ''
		  Endif
		
		 aSize(::_Buffer,0)
		 ::_Buffer 		:= StrTokArr2( cBuffer , ::cFSep )
		 ::_PosBuffer 	:= 1
		 cReadLine 		:= ::_Buffer[::_PosBuffer]
		 
		 Return .T.
	
	Endif

	::_SetError(-4,"File is in EOF")

Return .F.

/*/{Protheus.doc} QUA81RTXT() ===========================================================================================================================
METODOS DE TRATAMENTO ERRO                               
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
METHOD GetError() CLASS QUA81RTXT
Return ::nFerror

METHOD GetOSError() CLASS QUA81RTXT
Return ::nOSError

METHOD GetErrorStr() CLASS QUA81RTXT
Return ::cFerrorStr

METHOD GetFSize() CLASS QUA81RTXT
Return ::nFSize

METHOD _SetError(nCode,cStr) CLASS QUA81RTXT
::nFerror := nCode
::cFerrorStr := cStr
Return

METHOD _SetOSError(nCode,cStr,nOsError) CLASS QUA81RTXT
::nFerror := nCode
::cFerrorStr := cStr
::nOsError := nOsError
Return

METHOD _CleanLastErr() CLASS QUA81RTXT
::nFerror := 0
::cFerrorStr := ''
::nOsError := 0
Return