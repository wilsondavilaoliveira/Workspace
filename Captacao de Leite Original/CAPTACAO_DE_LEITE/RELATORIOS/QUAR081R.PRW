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
    Private cPath := ''

    If Pergunte("QUAR81R",.T.)
        cPath := cGetFile (,, 1,, .F., GETF_RETDIRECTORY+GETF_LOCALHARD)
    	If MV_PAR01 == 1
            If !Empty(cPath)
        		MsAguarde({|| CriaXml()},"Aguarde...","Gerando Planilha..aguarde!",.T.)
        	End If
        Else
            If !Empty(cPath)
        		MsAguarde({|| CriaXml1()},"Aguarde...","Gerando Planilha CBT GEO..aguarde!",.T.)
        	End If
        EndIf
     EndIf
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

	fErase(cPath+'\LEITURAS_MENSAL.XLS')
	nHdlImp := fCreate(cPath+'\LEITURAS_MENSAL.XLS', 0)

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

    LJX->(dbSetOrder(2))

    If LJX->(dbSeek(xFilial("LJX")))
        While LJX->(!Eof()) .AND. LJX->(LJX_FILIAL) == xFilial("LJX")
            If LJX->(LJX_PLAN) == 'S'
                cXml += '<Column ss:StyleID="s16" ss:Width="82.5"/>' + CRLF
            EndIf
        	LJX->(dbSkip())
        EndDo
    EndIf

    cXml += '<Row>' + CRLF

    nColAtBio := 0

	If LJX->(dbSeek(xFilial("LJX")))

		cXml += '<Cell ss:StyleID="s18"><Data ss:Type="String">CODIGO</Data></Cell>' + CRLF
		cXml += '<Cell ss:StyleID="s18"><Data ss:Type="String">NOME</Data></Cell>' + CRLF

		While LJX->(!Eof()) .AND. LJX->(LJX_FILIAL) == xFilial("LJX")
			If LJX->(LJX_PLAN) == 'S'
				cXml += '<Cell ss:StyleID="s18"><Data ss:Type="String">' + AllTrim(LJX->(LJX_DESC)) + '</Data></Cell>' + CRLF

                nCol ++

                If LJX->(LJX_CODBON) == '000001'
                    nColAtBio := nCol
                EndIf

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

		cXml := ''
		For _nRow := 1 To 2500
			cXml += '<Row>' + CRLF
			cXml += '<Cell ss:StyleID="s17"><Data ss:Type="String"></Data></Cell>' + CRLF
			cXml += '<Cell ss:StyleID="s17"><Data ss:Type="String"></Data></Cell>' + CRLF

					For _Cell := 1 to nCol
                        If _Cell <> nColAtBio
                            cXml += '<Cell ss:StyleID="s20"><Data ss:Type="Number">0</Data></Cell>' + CRLF
                        Else
                            cXml += '<Cell ss:StyleID="s20"><Data ss:Type="String">NEG</Data></Cell>' + CRLF
                        EndIf
                    Next _Cell

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
		ShellExecute("open", cPath+'/LEITURAS_MENSAL.XLS', "", "", 1)
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

	Local cAlQry     := GetNextAlias()
	Private cXML     := ""
	Private cArq     := ""
	Private oXML
	Private xRet
	Private nI       := 0, nLen:= 0
	Private lLoop    := .T., lRet1 := .F., lRet2 := .F.
	Private nOptions := GETF_OVERWRITEPROMPT+GETF_LOCALHARD+GETF_NETWORKDRIVE

	If Pergunte("QUAR81R",.T.)
        nOp := MV_PAR01
        If Pergunte("QUAR082R",.T.)

    		 //CRIA BASE CASO NAO EXISTA
    		MsAguarde({|| GETDQUA21()},"Aguarde...","Preparando Leitura..aguarde!",.T.)

    		BeginSql Alias cAlQry
    			%noparser%
    			SELECT LJZ_DATCLQ FROM %table:LJZ% LJZ WHERE  LJZ_DATCLQ = %Exp:MV_PAR01% AND LJZ.%notDel%
    		EndSql

    		If (cAlQry)->(Eof())
    			MsgStop(OemToAnsi("Nÿo existe arquivo de leituras montado para esse per­odo!"))
    			Return
    		End If
                If nOp == 1
    		        cArq := cGetFile("Arquivos Laboratorio Mensal|*.xml" ,OemToAnsi("Abrir Arquivo..."),0,,,nOptions)
                Else
                    cArq := cGetFile("Arquivos Media Geometrica|*.xml" ,OemToAnsi("Abrir Arquivo..."),0,,,nOptions)
                EndIf

              If Empty(cArq)
    			Return
    		  Else
    		    If nOp == 1
                    MsAguarde({|| LerXml()},"Aguarde...","Executando Leitura Mensal..aguarde!",.T.)
    		    Else
                    MsAguarde({|| LerXml1()},"Aguarde...","Executando Leitura Geometrica..aguarde!",.T.)
                EndIf
              Endif

        End If
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
    Local lOK       := .T.
	Local aValid    := {}
    Local aProd     := {}
    Local nLinPlan  := 2
    oTXTFile := QUA81RTXT():New(cArq)

	If !oTXTFile:Open()
		MsgStop(oTXTFile:GetErrorStr(),"OPEN ERROR")
		Return
	Endif

	MsProcTxt("Iniciando Leitura...")

    While oTXTFile:ReadLine(@cLine)
	    cXML  += cLine
        nLinha ++
	Enddo

	oTXTFile:Close()

	oXML := TXmlManager():New()

	xRet := oXML:Parse( cXML )
	If xRet == .F.
	  MsgAlert( "Erro ao ler arquivo: " + oXML:Error() )
	  Return
	endif

   //INICIA VALIDACAO DO ARQUIVO==================
    MsProcTxt("Iniciando Validacao Arquivo...")

        While lLoop
	    If AllTrim(oXML:CNAME) == 'Row'
	    	If lFirst
	    		oXML:DOMNextNode()
	    		lFirst := .F.
	    	EndIf

	    	If oXML:DOMHasChildNode()
	    	    aChildren := oXML:DOMGetChildArray()
			    If !Empty(aChildren[1][2])

                    cRet := LerProd(aChildren[1][2],cFilAnt)

                    If Empty(cRet)
                        AADD(aValid,{aChildren[1][2],"PRODUTOR NAO CADASTRADO","LINHA>: "+cValToChar(nLinPlan)})
                        lOK := .F.
                    Else
                        nPos := aScanX(aProd,{ |X| X[1] == aChildren[1][2] })
                        If nPos > 0
                            AADD(aValid,{aChildren[1][2],"PRODUTOR DUPLICADO","LINHA>: "+cValToChar(nLinPlan)})
                            lOK := .F.
                        EndIf

                        AADD(aProd,{aChildren[1][2]})
                    End If

		    	Else
                    AADD(aValid,{aChildren[1][2],"CODIGO DO LAB. EM BRANCO","LINHA>: "+cValToChar(nLinPlan)})
                    lOK := .F.
                End If
	    	End If
            nLinPlan ++

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
	            lLoop := .F.
                //Loop
                //Return
                exit
              Endif
    	        If !lLoop
                    exit
                Endif
            EndDo
                If !lLoop
                    exit
                Endif
	        Loop
	      Else
	        MsgAlert( "Error de estrutura xml" )
	        Return
	      Endif
	    Endif
        if !lLoop
            exit
        Endif
	EndDo
    lLoop := .T.

    If !lOK

        If MsgYesno("A Planilha contem ocorrencias, deseja continuar?")
             lOk := .T.
        EndIf

        MSGINFO("Salve o arquivo com as ocorrencias no diretorio de sua preferencia")

        cTexto := dtoc(MV_PAR01) + CRLF
        cTexto += REPLICATE("-",25)+"|"+REPLICATE("-",25)+"|"+REPLICATE("-",25)+"|" + CRLF
        cTexto += Padr("CODIGO LABORATORIO",25)+"|"+Padr("DESCRICAO ERRO",25)+"|"+Padr("LINHA DO ERRO",25)+"|" + CRLF
        cTexto += REPLICATE("-",25)+"|"+REPLICATE("-",25)+"|"+REPLICATE("-",25)+"|" + CRLF

        For a := 1 To Len(aValid)
            cTexto += PADR(aValid[a][1],25)+"|"+PADR(aValid[a][2],25)+"|"+PADR(aValid[a][3],25)+"|" + CRLF
        Next a

        cPath1 := cGetFile (,"Salvar arquivo de Erros",1,,.F.,GETF_RETDIRECTORY+GETF_LOCALHARD)
        If !Empty(cPath1)
            MemoWrite(cPath1+"Erros Planilha Laboratorio"+StrZero(Month(MV_PAR01),2)+cValToChar(Year(MV_PAR01))+".txt",cTexto)
            MSGINFO("Arquivo Salvo no diretorio:"+cPath1+"\Erros Planilha Laboratorio.txt")
        EndIf

    EndIf

    If lOk
        xRet := oXML:Parse( cXML )//INICIA UPDATE LJZ================================================
    	MsProcTxt("Iniciando Alteracao de dados...")

        While lLoop
    	    If AllTrim(oXML:CNAME) == 'Row'
    	    	If lFirst
    	    		oXML:DOMNextNode()
    	    		lFirst := .F.
    	    	EndIf

    	    	If oXML:DOMHasChildNode()
    	    	aChildren := oXML:DOMGetChildArray()
    			    If !Empty(aChildren[1][2])
    			    	cRet := LerProd(aChildren[1][2],cFilAnt)

    			    	For i := 1 To oXML:DOMChildCount()
    			    		If i > 2
    				    		LJX->(dbSetOrder(2))
    				    		If LJX->(dbSeek(xFilial("LJX")+cValToChar(i-2)))

                                    cQuery := "UPDATE " + RetSqlName("LJZ") + " " + CRLF
                                    If LJX->(LJX_CODBON) <> '000001'
                                        aRet    := U_QuaCAL21(Alltrim(LJX->(LJX_CODBON)),,Val(aChildren[i][2]))
                                        cQuery += "SET LJZ_QTDLEI=" + cValToChar(aChildren[i][2])   + ", " + CRLF
                                    Else
                                        aRet := {}
                                        AAdd(aRet,{0,0,0,1})
                                        cQuery += "SET LJZ_QTDLEI=" + IIF(AllTrim(aChildren[i][2])=='NEG','1','2')   + ", " + CRLF
                                    EndIf

                                    cQuery += "LJZ_RESLEI="     + cValToChar(aRet[1,1])         + ", " + CRLF
                                    cQuery += "LJZ_VINIC="      + cValToChar(aRet[1,2])         + ", " + CRLF
                                    cQuery += "LJZ_VFINAL="     + cValToChar(aRet[1,3])         + ",  " + CRLF
                                    cQuery += "LJZ_ITEM="       + cValToChar(aRet[1,4])         + "  " + CRLF
                                    cQuery += "WHERE LJZ_FILIAL='" + cFilAnt + "' " + CRLF
    						    	cQuery += "AND LJZ_CODPRO='" + cRet + "' AND LJZ_DATCLQ='" + cValToChar(DTOS(MV_PAR01)) + "' " + CRLF
    						    	cQuery += "AND LJZ_CODBON='" + LJX->(LJX_CODBON) + "' AND D_E_L_E_T_=' '   " + CRLF

    						    	TcSqlExec(cQuery)
    							End If
    			    		End If

    			    		If i == 2
    		   		     		//MsProcTxt("Produtor >>> " + aChildren[1][2]+"-"+cValToChar(aChildren[i][2]))
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

    End If

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

	Local cRet  := ''
    Local dData := MV_PAR01
	Local cMes  := ''
    Local cAno  := ''
    //cQuery := "SELECT LBB_CODPRO FROM " + RetSqlName("LBB") + " LBB WHERE LBB.D_E_L_E_T_='' AND LBB_STATUS='S' AND LBB_FILIAL='" + xFil + "' AND LBB.LBB_CODLAB = '" + cCodLab + "' " + CRLF

    //MONTH(PC0_DTENTR)=%Exp:Month(M->LJZ_DATCLQ)% AND YEAR(PC0_DTENTR)=%Exp:Year(M->LJZ_DATCLQ)%

    cQuery := "SELECT DISTINCT LBB_CODPRO FROM " + RetSqlName('LBB') + " LBB " + CRLF
    cQuery += " INNER JOIN " + RetSqlName('PC1') + " PC1 ON PC1_FILIAL=LBB_FILIAL AND PC1.D_E_L_E_T_='' AND PC1_CODPRO=LBB_CODPRO " + CRLF
    cQuery += " INNER JOIN " + RetSqlName('PC0') + " PC0 ON PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC0.D_E_L_E_T_=''  " + CRLF
    cQuery += " AND MONTH(PC0_DTENTR)=" + cValToCHar(Month(dData)) + " AND YEAR(PC0_DTENTR)=" + cValToCHar(year(ddata)) + "  " + CRLF
    cQuery += " WHERE LBB.D_E_L_E_T_='' " + CRLF
    cQuery += " AND LBB_FILIAL='" + xFil + "' AND LBB.LBB_CODLAB = '" + cCodLab + "' " + CRLF

	MemoWrite("C:\HD\QUERYS\GETCODPRO_MESATUAL.SQL",cQuery)
    cQuery := ChangeQuery(cQuery)

	If Select( "QUERY1" ) > 0
		QUERY1->( dbCloseArea() )
	EndIf

	TCQUERY cQuery ALIAS QUERY1 NEW
	dbSelectArea("QUERY1")
	dbGoTop()

	If QUERY1->( !Eof() )
		cRet := QUERY1->(LBB_CODPRO)
    Else

        If month(dData) == 1
            cMes := '12'
            cAno := cValToChar(year(ddata)-1)
        Else
            cMes := cValToChar(month(ddata)-1)
            cAno := cValToChar(year(ddata))
        EndIf

        cQuery := "SELECT DISTINCT LBB_CODPRO FROM " + RetSqlName('LBB') + " LBB " + CRLF
        cQuery += " INNER JOIN " + RetSqlName('PC1') + " PC1 ON PC1_FILIAL=LBB_FILIAL AND PC1.D_E_L_E_T_='' AND PC1_CODPRO=LBB_CODPRO " + CRLF
        cQuery += " INNER JOIN " + RetSqlName('PC0') + " PC0 ON PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC0.D_E_L_E_T_=''  " + CRLF
        cQuery += " AND MONTH(PC0_DTENTR)=" + cMes + " AND YEAR(PC0_DTENTR)=" + cAno + "  " + CRLF
        cQuery += " WHERE LBB.D_E_L_E_T_='' " + CRLF
        cQuery += " AND LBB_FILIAL='" + xFil + "' AND LBB.LBB_CODLAB = '" + cCodLab + "' " + CRLF

        MemoWrite("C:\HD\QUERYS\GETCODPRO_MESANTERIOR.SQL",cQuery)

        cQuery := ChangeQuery(cQuery)

        If Select( "QUERY1" ) > 0
        	QUERY1->( dbCloseArea() )
        EndIf

        TCQUERY cQuery ALIAS QUERY1 NEW
        dbSelectArea("QUERY1")
        dbGoTop()

    	If QUERY1->( !Eof() )
		    cRet := QUERY1->(LBB_CODPRO)
        Endif
    End If

Return cRet

/*/{Protheus.doc} QuaCAL21() ============================================================================================================================
Funcao auxiliar para calculo da valorizacao das bonificacoes de acordo com os parametros
@param cTabQua=Codigo da Bonificacao;cTipoL=NAO USADO;nValor=Valor a ser medido
@return aResul Return Array com 3 valores 1=Resultado;2=Faixa inicial;3=Faixa Final
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
User  Function QuaCAL21( cTabQua, cTipoL, nValor)

Local aResul    := {}
Local aArea		:= GetArea()
Local nTamChave	:= Len(CriaVar("LJY_CODBON"))

	cTabQua := Left(cTabQua+Space(nTamChave),nTamChave)

	dbselectArea("LJY") // Tabela Criterios da Qualidade
	dbSetOrder(2)
	If dbseek( xFilial("LJY")+cTabQua )
    	Do While !Eof() .And. ( LJY->LJY_FILIAL+LJY->LJY_CODBON = xFilial("LJY")+cTabQua )
    		If nValor >= LJY->LJY_VINIC .And. nValor <= LJY->LJY_VFINAL
    		   AAdd(aResul,{LJY->LJY_VRESUL,LJY->LJY_VINIC,LJY->LJY_VFINAL,LJY_ITEM})
               //aResul[1][1] := LJY_VRESUL
    	  	   //aResul[1][2] := LJY_VINIC
               //aResul[1][3] := LJY_VFINAL
    			 Exit
            EndIf
    		dbSkip()
    	EndDo
        If Len(aResul)==0
            AAdd(aResul,{0,0,0,0})
        EndIf
    Else
        AAdd(aResul,{0,0,0,0})
    End If

	RestArea(aArea)

Return(aResul)

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

/*/{Protheus.doc} GETDQUA21() ===========================================================================================================================
Cria Arquivo Base de coletas do laboratorio caso nao existam
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static Function GETDQUA21()

	Local cTipoBon		:= ' '
	Local nResLei 		:= 0
	Local nLitros		:= 0
	Local nDistan   	:= 0
	Local nItem         := 0
    Private cAliasQry  	:= GetNextAlias()

	BeginSql Alias cAliasQry

	%noparser%

		SELECT DISTINCT LBB_CODPRO,LBB_CODTAN,LBB_TIPOL,LBB_LINHA,LJX_CODBON,LJX_DESC,LJX_ORDEM
		FROM %table:LBB% LBB (NOLOCK)
		INNER JOIN %table:LJX% LJX  (NOLOCK) ON LJX_FILIAL=LBB_FILIAL AND LJX.%notDel%
		WHERE LBB_FILIAL=%Exp:cFilAnt% AND LBB.%notDel%
		AND LBB_STATUS='S'
		AND LBB_CODPRO+LJX_CODBON NOT IN (
			SELECT LJZ_CODPRO+LJZ_CODBON
			FROM %table:LJZ% LJZ (NOLOCK)
			WHERE LJZ_FILIAL=%Exp:cFilAnt%
			AND LJZ_DATCLQ=%Exp:DTOS(MV_PAR01)%
			AND LJZ.%notDel%)
		ORDER BY LBB_CODPRO,LJX_ORDEM

	EndSql

	MsProcTxt("Incluindo novos Produtores >>> ")

	While (cAliasQry)->( !Eof() )


		dbselectArea("LJZ")
			RecLock("LJZ",.T.)
					LJZ->LJZ_FILIAL := xFilial("LJZ")
					LJZ->LJZ_DATCLQ := MV_PAR01
					LJZ->LJZ_CODPRO := (cAliasQry)->(LBB_CODPRO)
					LJZ->LJZ_DATCLA := dDataBase
					LJZ->LJZ_CODBON := (cAliasQry)->(LJX_CODBON)
					LJZ->LJZ_DESBON := (cAliasQry)->(LJX_DESC)
					LJZ->LJZ_QTDLEI := 0
					LJZ->LJZ_RESLEI := 0
			MsUnlock()

		(cAliasQry)->(dbSkip())

	Enddo

	DbSelectArea("LJZ") //Historico da classificacao da Qualidade do leite
	DbSetOrder(1)
    MsProcTxt("Recalculando Bonificacoes >>> ")
	If dbSeek( xFilial("LJZ") + Dtos(MV_PAR01 ))

		While !Eof() .AND. xFilial("LJZ") == LJZ->LJZ_FILIAL .AND. LJZ->LJZ_DATCLQ == MV_PAR01

			// 1-PLANILHA-> Sera usada planilha para entrar com dados no sistema,
			// 2-VOLUME->Sera usado o volume captado pelo produtor no sistema para calculo,
			// 3-DISTANCIA->Sera usado o campo distancia do produtor ate o laticinio do cadastro de propriedades,
			// 4-DIGITADO->No caso de adicional de Mercado para composicao do preco no simulador.
			LJZArea := GetArea()

			cTipoBon     := Posicione("LJX",1,XFILIAL("LJZ")+LJZ->LJZ_CODBON,"LJX_TPBON")

			If !cTipoBon $ ('2|3')
				RestArea(LJZArea)
				dbSkip()
				Loop
			EndiF

			If cTipoBon  ==  '2'  // VOLUME

				nLitrosAtu 	:= LJZ->LJZ_QTDLEI
				nLitros        := U_RetLitros(LJZ->LJZ_CODPRO)

				If nLitros <> nLitrosAtu
					aRet    := U_QuaCAL21(Alltrim(LJZ->(LJZ_CODBON)),,nLitros)
                    nResLei := aRet[1,1]
                    nFxINI  := aRet[1,2]
                    nFxFIM  := aRet[1,3]
                    nItem   := aRet[1,4]
                Else
					nLitros := 0
				EndiF

			ElseIf cTipoBon  ==  '3' // DISTANCIA

				nDistanAt  := LJZ->LJZ_QTDLEI
				nDistan 	   := Posicione("LBB",1,XFILIAL("LBB")+LJZ->LJZ_CODPRO,"LBB_DISTAN")

				If nDistan <> nDistanAt
					aRet    := U_QuaCAL21(Alltrim(LJZ->(LJZ_CODBON)),,nDistan)
                    nResLei := aRet[1,1]
                    nFxINI  := aRet[1,2]
                    nFxFIM  := aRet[1,3]
                    nItem   := aRet[1,4]

                Else
					nDistan := 0
				EndiF

			EndiF

			RestArea(LJZArea)



			If (nLitros+nDistan) > 0
				RecLock("LJZ",.F.)
				    LJZ->LJZ_RESLEI	:= nResLei
					LJZ->LJZ_QTDLEI := nLitros+nDistan
                    LJZ->LJZ_VINIC  := nFxINI
                    LJZ->LJZ_VFINAL := nFxFIM
                    LJZ->LJZ_ITEM   := nItem
                MsUnlock()
			EndIf

			nLitros := 0
			nDistan := 0
			nResLei := 0
            nFxINI  := 0
            nFxFIM  := 0
            nItem   := 0

            dbSkip()


		EndDo

	Endif

Return .T.

/*/{Protheus.doc} RetLitros
Funcao auxiliar para somar litros do produtor no periodo
@type function
@version
@author Wilson Davila
@since 13/05/2020
@param cCodPro, character, Codigo do Produtor
@return nLitros numeric, total de litros produtor no periodo
/*/
User Function RetLitros(cCodPro)

	Local nLitros := 0
	Local cAlias := 'QUAR81R'

	BeginSql Alias cAlias

		%noparser%

		SELECT SUM(PC1_QTDLIT) AS PC1_QTDLIT
		FROM %table:PC1%  PC1
		INNER JOIN %table:PC0% PC0 ON PC0_FILIAL=PC1_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC0.%notDel%
		AND MONTH(PC0_DTENTR)=%Exp:Month(MV_PAR01)% AND YEAR(PC0_DTENTR)=%Exp:Year(MV_PAR01)%
		AND PC0_TPENTR='1'
		WHERE PC1_CODPRO=%exp:cCodPro% AND PC1_FILIAL=%EXP:cFilAnt% AND PC1.%notDel%


	EndSql

	If  (cAlias)->(  !Eof() )
		nLitros := (cAlias)->(PC1_QTDLIT)
	EndIf

	(CALIAS)->( dbCloseArea())

Return nLitros

/*/{Protheus.doc} CriaXml() =============================================================================================================================
Funcao auxiliar geracao de planilha base para insercao de dados nas tabelas de qualidade de leite chamada pela funcao QUAR081R()
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static Function CriaXml1()

	Local cXml 	:= ''
	Local nCol	:= 0

	//U_aOrdLJX()

	fErase(cPath+'\LEITURAS_CBT_GEOMETRICA.XLS')
	nHdlImp := fCreate(cPath+'\LEITURAS_CBT_GEOMETRICA.XLS', 0)

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
	cXml += '<Worksheet ss:Name="LEITURAS_CBT_GEO">' + CRLF

	cXml += '<Table x:FullColumns="1" x:FullRows="1" ss:DefaultRowHeight="15">' + CRLF

	cXml += '<Column ss:StyleID="s16" ss:Width="56.25"/>' + CRLF
	cXml += '<Column ss:StyleID="s16" ss:AutoFitWidth="0" ss:Width="240.75"/>' + CRLF
    cXml += '<Column ss:StyleID="s16" ss:Width="90"/>' + CRLF


    cXml += '<Row>' + CRLF
	cXml += '<Cell ss:StyleID="s18"><Data ss:Type="String">CODIGO</Data></Cell>' + CRLF
	cXml += '<Cell ss:StyleID="s18"><Data ss:Type="String">NOME</Data></Cell>' + CRLF
	cXml += '<Cell ss:StyleID="s18"><Data ss:Type="String">CBT GEOMETRICA</Data></Cell>' + CRLF
	cXml += '</Row>' + CRLF

    fWrite(nHdlimp,cXml)

	cXml := ''
    For a := 1 To 2500

        cXml += '<Row>' + CRLF
    	cXml += '<Cell ss:StyleID="s17"><Data ss:Type="String"></Data></Cell>' + CRLF
    	cXml += '<Cell ss:StyleID="s17"><Data ss:Type="String"></Data></Cell>' + CRLF
        cXml += '<Cell ss:StyleID="s20"><Data ss:Type="Number">0</Data></Cell>' + CRLF
    	cXml += '</Row>' + CRLF

    Next a

    fWrite(nHdlimp,cXml)

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
		ShellExecute("open", cPath+'/LEITURAS_CBT_GEOMETRICA.XLS', "", "", 1)
	End if

Return

/*/{Protheus.doc} LerXml1() ============================================================================================================================
Funcao auxiliar para leitura de planilha base para insercao de dados tabelas de qualidade de leite cbt geometrica chamada pela funcao QA081XML()
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================================================================================
/*/
Static Function LerXml1()

	Local cRet 		:= ''
	Local lFirst 	:= .T.
	Local nLinha	:= 0
	Local cQuery	:= ''
	Local nResLei	:= 0
	Local cLine 	:= ''
    Local lOK       := .T.
	Local aValid    := {}
    Local aProd     := {}
    Local nLinPlan  := 2
    oTXTFile := QUA81RTXT():New(cArq)

	If !oTXTFile:Open()
		MsgStop(oTXTFile:GetErrorStr(),"OPEN ERROR")
		Return
	Endif

	MsProcTxt("Iniciando Leitura...")

    While oTXTFile:ReadLine(@cLine)
	    cXML  += cLine
        nLinha ++
	Enddo

	oTXTFile:Close()

	oXML := TXmlManager():New()

	xRet := oXML:Parse( cXML )
	If xRet == .F.
	  MsgAlert( "Erro ao ler arquivo: " + oXML:Error() )
	  Return
	endif

   //INICIA VALIDACAO DO ARQUIVO==================
    MsProcTxt("Iniciando Validacao Arquivo...")

        While lLoop
	    If AllTrim(oXML:CNAME) == 'Row'
	    	If lFirst
	    		oXML:DOMNextNode()
	    		lFirst := .F.
	    	EndIf

	    	If oXML:DOMHasChildNode()
	    	    aChildren := oXML:DOMGetChildArray()
			    If !Empty(aChildren[1][2])

                    cRet := LerProd(aChildren[1][2],cFilAnt)

                    If Empty(cRet)
                        AADD(aValid,{aChildren[1][2],"PRODUTOR NAO CADASTRADO","LINHA>: "+cValToChar(nLinPlan)})
                        lOK := .F.
                    Else
                        nPos := aScanX(aProd,{ |X| X[1] == aChildren[1][2] })
                        If nPos > 0
                            AADD(aValid,{aChildren[1][2],"PRODUTOR DUPLICADO","LINHA>: "+cValToChar(nLinPlan)})
                            lOK := .F.
                        EndIf

                        AADD(aProd,{aChildren[1][2]})
                    End If

		    	Else
                    AADD(aValid,{aChildren[1][2],"CODIGO DO LAB. EM BRANCO","LINHA>: "+cValToChar(nLinPlan)})
                    lOK := .F.
                End If
	    	End If
            nLinPlan ++

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
	            lLoop := .F.
                //Loop
                //Return
                exit
              Endif
    	        If !lLoop
                    exit
                Endif
            EndDo
                If !lLoop
                    exit
                Endif
	        Loop
	      Else
	        MsgAlert( "Error de estrutura xml" )
	        Return
	      Endif
	    Endif
        if !lLoop
            exit
        Endif
	EndDo
    lLoop := .T.

     If !lOK

        If MsgYesno("A Planilha contem ocorrencias, deseja continuar?")
            lOk := .T.
        EndIf

        MSGINFO("Salve o arquivo com as ocorrencias no diretorio de sua preferencia")

        cTexto := dtoc(MV_PAR01) + CRLF
        cTexto := REPLICATE("-",25)+"|"+REPLICATE("-",25)+"|"+REPLICATE("-",25)+"|" + CRLF
        cTexto += Padr("CODIGO LABORATORIO",25)+"|"+Padr("DESCRICAO ERRO",25)+"|"+Padr("LINHA DO ERRO",25)+"|" + CRLF
        cTexto += REPLICATE("-",25)+"|"+REPLICATE("-",25)+"|"+REPLICATE("-",25)+"|" + CRLF

        For a := 1 To Len(aValid)
            cTexto += PADR(aValid[a][1],25)+"|"+PADR(aValid[a][2],25)+"|"+PADR(aValid[a][3],25)+"|" + CRLF
        Next a

        cPath1 := cGetFile (,"Salvar arquivo de Erros",1,,.F.,GETF_RETDIRECTORY+GETF_LOCALHARD)
        If !Empty(cPath1)
            MemoWrite(cPath1+"Erros Planilha Media Geometrica"+StrZero(Month(MV_PAR01),2)+cValToChar(Year(MV_PAR01))+".txt",cTexto)
            MSGINFO("Arquivo Salvo no diretorio:"+cPath1+"\Erros Planilha Media Geometrica.txt")
        EndIf

    End If

    If lOK

        xRet := oXML:Parse( cXML )//INICIA UPDATE LJZ================================================
    	MsProcTxt("Iniciando Alteracao de dados...")

        While lLoop
    	    If AllTrim(oXML:CNAME) == 'Row'
    	    	If lFirst
    	    		oXML:DOMNextNode()
    	    		lFirst := .F.
    	    	EndIf

    	    	If oXML:DOMHasChildNode()
    	    	aChildren := oXML:DOMGetChildArray()
    			    If !Empty(aChildren[1][2])
    			    	cRet := LerProd(aChildren[1][2],cFilAnt)

    			    	For i := 1 To oXML:DOMChildCount()
    			    		If i > 2

                                    cQuery := "UPDATE " + RetSqlName("LJZ") + " " + CRLF
                                    cQuery += "SET LJZ_QTDLEI=" + cValToChar(aChildren[i][2])   + ", " + CRLF
                                    cQuery += "LJZ_RESLEI="     + cValToChar(0)         + ", " + CRLF
                                    cQuery += "LJZ_VINIC="      + cValToChar(0)         + ", " + CRLF
                                    cQuery += "LJZ_VFINAL="     + cValToChar(0)         + ",  " + CRLF
                                    cQuery += "LJZ_ITEM="       + cValToChar(1)         + "  " + CRLF
                                    cQuery += "WHERE LJZ_FILIAL='" + cFilAnt + "' " + CRLF
    						    	cQuery += "AND LJZ_CODPRO='" + cRet + "' AND LJZ_DATCLQ='" + cValToChar(DTOS(MV_PAR01)) + "' " + CRLF
    						    	cQuery += "AND LJZ_CODBON='000002' AND D_E_L_E_T_=' '   " + CRLF

    						    	TcSqlExec(cQuery)
    			    		End If

    			    		//If i == 2
    		   		     		//MsProcTxt("Produtor >>> " + aChildren[1][2]+"-"+cValToChar(aChildren[i][2]))
    			    		//End If
    				    Next i
    		    	End If
    	    	End If
            EndIf

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

    End If

Return
