#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.CH"
#INCLUDE "TopConn.ch"

/*/{Protheus.doc} QUAA061W() ============================================================*
Rotina para incluir Nccs faltantes ou complementar em caso de mudanca de contrato.
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================*
/*/

User Function QUAA061W()

	//Local cMVDTFIN 	:= GetMv("MV_DATAFIN")
	Local cFilA		:= cFilAnt
	Local cMens		:= ''
	Private oProcess	:= NIL
	Private Titulo 		:= "Processando. . ."
	Private cMensagem 	:= ''
	
	cMens := OemToAnsi("< < < < < < < < << < < < < <    A T E N C A O   > > > > > > > > > > > > > >") + CRLF
	cMens += OemToAnsi("Para rotina funcionar é necessário que o contrato seja cadastrado ") 
	cMens += OemToAnsi("com a data de inicio e fim da vigência dentro do período de emissão das Notas Fiscais,") 
	cMens += OemToAnsi("no caso de acerto de % em algum contrato a Data de Vigência deve ser a mesma do contrato ") 
	cMens += OemToAnsi("que esta sendo inativado para acerto. NÃO deve ser a data dia do cadastramento! " )
	
	If AVISO(OemToAnsi("Inclusao de NCC / NCC complementar"),cMens,{"OK","CANCELAR"},2) == 1
	
		If Pergunte("QUAA061W",.T.)
			oProcess := MsNewProcess():New({|| xProc(oProcess,MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04) },Titulo,"Processando...",.T.)
			oProcess:Activate()
			
			//PutMv("MV_DATAFIN",cMVDTFIN)
			cFilAnt := cFilA
		End If
	
	End If
Return

/*/{Protheus.doc} xProc() ===============================================================*
Processa Rotina QUAA061W
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================*
/*/
Static Function xProc(oObj,cFilDe,cFilAte,cNotaIni,cNotaFim)

	Local cQuery 	:= ''
	Local cQuery1 	:= ''
	Local cQuery2 	:= ''
	Local n1		:= 0
	Local n2		:= 0
	Local n3		:= 0
	Local aCpoSE1	:= {}
	Local nRecSA1	:= 0
	Local lRet		:= .F.
	Local cAliasZC6 := ''
	Local aRecno	:= {}
	Private lMsErroAuto := .F.
	
	cQuery := "SELECT DISTINCT SF2.R_E_C_N_O_ AS REG,F2_EMISSAO,F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,SF4.F4_DUPLIC,F2_DUPL " + CRLF
	cQuery += "FROM " + RetSqlName("SF2") + " SF2 " + CRLF
	cQuery += "INNER JOIN " + RetSqlName("SD2") + " SD2  " + CRLF
	cQuery += "ON SD2.D2_FILIAL=SF2.F2_FILIAL AND SD2.D2_DOC=SF2.F2_DOC AND SD2.D2_SERIE=SF2.F2_SERIE " + CRLF 
	cQuery += "AND SD2.D2_CLIENTE=SF2.F2_CLIENTE AND SD2.D2_LOJA=SF2.F2_LOJA AND SD2.D_E_L_E_T_=''  " + CRLF
	cQuery += "INNER JOIN " + RetSqlName("SF4") + " SF4  " + CRLF
	cQuery += "ON SF4.F4_CODIGO=SD2.D2_TES AND SF4.F4_DUPLIC='S' AND SF4.D_E_L_E_T_='' " + CRLF
	cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_COD=F2_CLIENTE AND A1_LOJA=D2_LOJA AND SA1.D_E_L_E_T_='' " + CRLF
	cQuery += "WHERE  " + CRLF
	cQuery += "F2_EMISSAO BETWEEN '" + DTOS(cNotaIni) + "' AND '" + DTOS(cNotaFim) + "' AND (F2_FILIAL BETWEEN '" + cFildE + "' AND  '" + cFilAte + "') " + CRLF
	cQuery += "AND SF2.D_E_L_E_T_='' " + CRLF 
	cQuery += "AND (A1_XBAND IN(SELECT DISTINCT ZC7_BANDEI FROM " + RetSqlName("ZC7") + " ZC7 WHERE ZC7.D_E_L_E_T_='') OR " + CRLF
	cQuery += "A1_COD IN(SELECT DISTINCT ZC7_CODCLI FROM " + RetSqlName("ZC7") + " ZC7 WHERE ZC7.D_E_L_E_T_='')) " + CRLF
	
	If Select( "QUERY" ) > 0
		QUERY->( dbCloseArea() )
	EndIf
	
	MemoWrite("C:\HD\QUERYS\QUAA061W.sql",cQuery)
	
	dbUseArea( .T., "TOPCONN", TCGenQry( ,,cQuery ), "QUERY", .F., .F. )
	
	nCount := 0
	While QUERY->(!Eof())
		nCount ++
		QUERY->( dbSkip())
	EndDo
	
	QUERY->( dbGoTop() ) 
	
	oObj:SetRegua1(nCount)
	oObj:SetRegua2(4)
		
		While QUERY->(!Eof())
		
			oObj:IncRegua1("Emissao--> " + cValtoChar(stod(QUERY->F2_EMISSAO))+" | NF->" + QUERY->F2_DOC)   
			oObj:IncRegua2( "Cliente-> "+QUERY->F2_CLIENTE+'/'+QUERY->F2_LOJA+ " | PRODUTO->#_#_#_#_#")
			
			dbSelectArea("SF2")
			SF2->( DbGoto(QUERY->REG) )
			
			dbSelectArea("SE1")
			dbSetOrder(30)
			
			
			If dbSeek(QUERY->F2_FILIAL+QUERY->F2_DOC+Pad("NF",Len(SE1->E1_TIPO))+QUERY->F2_CLIENTE+QUERY->F2_LOJA)
				
					cFilAnt := QUERY->F2_FILIAL
					//dDataBase := STOD(QUERY->F2_EMISSAO) //VERIFICAR COM A ANDREIA SE A DATA DE EMISSAO EH A MESMA DA NF OU DATA DO DIA
					//PUTMV("MV_DATAFIN", QUERY->F2_EMISSAO) //VERIFICAR COM A ANDREIA SE A DATA DE EMISSAO EH A MESMA DA NF OU DATA DO DIA
					
					cAliasZC6 := GetNextAlias()
					
					BEGINSQL ALIAS cAliasZC6
					
						SELECT  R_E_C_N_O_ AS REC
						FROM %Table:ZC6% (NOLOCK)  ZC6
						WHERE ZC6_FILIAL+ZC6_NUM=%Exp:QUERY->F2_FILIAL+QUERY->F2_DOC%  
						AND ZC6.%NotDel%

					ENDSQL

					DO WHILE (cAliasZC6)->(!Eof())  
						AADD(aRecno,{(cAliasZC6)->(REC)})
						(cAliasZC6)->(dbSkip())
					ENDDO
					
					For _i := 1 To Len(aRecno)
						cQry := "UPDATE " + RetSqlName("ZC6") + " SET D_E_L_E_T_='*' WHERE R_E_C_N_O_=" + cValToChar(aRecno[_i][1]) 
						TcSqlExec(cQry)
					Next _i
						
					U_QUAA060W(2,,,,,,,,,,,@lRet,,,)
					
					If lRet
						For _i := 1 To Len(aRecno)
							cQry := "DELETE " + RetSqlName("ZC6") + " WHERE R_E_C_N_O_=" + cValToChar(aRecno[_i][1]) 
							TcSqlExec(cQry)
						Next _i
						IncPerSD2(@oObj,QUERY->F2_FILIAL+QUERY->F2_DOC)
					Else
						For _i := 1 To Len(aRecno)
							cQry := "UPDATE " + RetSqlName("ZC6") + " SET D_E_L_E_T_='' WHERE R_E_C_N_O_=" + cValToChar(aRecno[_i][1]) 
							TcSqlExec(cQry)
						Next _i
					EndIf
					/*
					If lRet
									
						cQuery := "SELECT * "
						cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
						cQuery += "WHERE SE1.E1_FILIAL='" + QUERY->F2_FILIAL + "' AND "
						cQuery += "SE1.E1_NUM='" + QUERY->F2_DOC + "' AND "
						cQuery += "SE1.E1_CLIENTE='" + QUERY->F2_CLIENTE + "' AND "
						cQuery += "SE1.E1_LOJA='" + QUERY->F2_LOJA + "' AND "
						cQuery += "SE1.D_E_L_E_T_=' ' AND E1_NATUREZ='DSC' AND E1_TIPO in ('NCC','AB-') AND E1_EMISSAO='" + QUERY->F2_EMISSAO + "'"
						cQuery := ChangeQuery(cQuery)
						MemoWrite("C:\HD\QUERYS\descNCC_SE1.sql",cQuery)
						cAliasSE1 := GetNextAlias()
						
						If Select(cAliasSE1) > 0
							DbSelectArea(cAliasSE1)
							(cAliasSE1)->( DbCloseArea() )
						EndIf
						
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE1,.T.,.T.)
						DbSelectArea(cAliasSE1)
						
						nValor := 0
						
						While (cAliasSE1)->(!Eof())
						
							nValor += (cAliasSE1)->(E1_VALOR)
							(cAliasSE1)->(DbSkip())
						
						EndDo
						
						nValor := ((nValor / SE1->E1_VALOR)*100)
					Else
	
					End IF
					*/
			End If	
		
		QUERY->( DBSKIP())
		
		EndDo
		
		ReportExcel()
		cQry := "DELETE " + RetSqlName("ZZZ")  
		TcSqlExec(cQry)
				
Return

/*/{Protheus.doc} xProc() ===============================================================*
Funcao auxiliar altera campo D2_XPERDES com % correto de desconto no item da Nota de saida
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
=========================================================================================*
/*/
Static Function IncPerSD2(oObj,cFilNota)

	Local xDescTot := 0
	
	aArea := GetArea()
	
	dbSelectArea("SD2")
	dbSetOrder(3)
	
	oObj:SetRegua2(4)
	
	If MsSeek(QUERY->F2_FILIAL+QUERY->F2_DOC+QUERY->F2_SERIE+QUERY->F2_CLIENTE+QUERY->F2_LOJA,.T.)
	
		While !Eof()  .And. QUERY->F2_FILIAL+QUERY->F2_DOC+QUERY->F2_SERIE+QUERY->F2_CLIENTE+QUERY->F2_LOJA == ;
							SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
				
			oObj:IncRegua2("Cliente-> "+QUERY->F2_CLIENTE+'/'+QUERY->F2_LOJA+ " | PRODUTO->"+SD2->D2_COD)
			
			QUAA606 := GetArea()
						
			xPerDes := 0						
			xPerDes := U_QUAA060W(5,SD2->D2_CLIENTE,SD2->D2_LOJA,'1',SD2->D2_EMISSAO,SD2->D2_COD,,,,,,,,,)
				
			RestArea(QUAA606)
			
			//=========================================================================================================
	
			aZB6      := {} 
			aItensCtr := {} 
			nPerDesc := 0 
			aAreaZb6 := GetArea()
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+SD2->D2_COD)
			
			aZB6 := U_GetCtrW(SD2->D2_CLIENTE,SD2->D2_LOJA,SD2->D2_FILIAL,DToS(SD2->D2_EMISSAO),SD2->D2_COD,SB1->B1_XCATEGO,SB1->B1_XMARCA)
	
			// SE EXISTIR O CONTRATO ADICIONA OS ITENS DE ACORDO COM O PRODUTO			
			If !Empty(aZB6) 
				U_ItCtrW(aZB6,SD2->D2_TOTAL,@aItensCtr,SD2->D2_ICMSRET)
			EndIf
			
			If Empty( aItensCtr ) 
				// Tratar IST conforme Contrato / Verba 
				nDescUni := 0 
				nDescUni += ( ( ( SD2->D2_TOTAL + SD2->D2_ICMSRET ) * SD2->D2_XPERDES ) / 100 ) 
				nPerDesc += ( ( ( SD2->D2_TOTAL + SD2->D2_ICMSRET ) * SD2->D2_XPERDES ) / 100 ) 
			Else 
				nDescUni := 0 
				For nCtrPerc := 1 To Len(aItensCtr)  
					nDescUni += ( ( aItensCtr[nCtrPerc,9] * aItensCtr[nCtrPerc,3]  ) / 100 ) 
					nPerDesc += ( ( aItensCtr[nCtrPerc,9] * aItensCtr[nCtrPerc,3]  ) / 100 ) 
				Next nCtrPerc 
			EndIf 
			
			RestArea(aAreaZb6)
			
			//=========================================================================================================	
			If xPerdes == 0
				nDescUni := 0
			End If
			
			dbSelectArea("SD2")	
			RecLock("SD2",.F.)
				SD2->D2_XPERDES	:= xPerDes
				SD2->D2_XVLRDES := nDescUni
			MsUnlock()
			dbSkip()
			xDescTot += xPerDes
		EndDo
		
		If xDescTot == 0
			cQry := "DELETE " + RetSqlName("ZC6") + " WHERE ZC6_FILIAL+ZC6_NUM='" + cFilNota + "'"
			TcSqlExec(cQry)
		End If
		xDescTot := 0
	
	End If
	RestArea(aArea)

Return

Static Function ReportExcel()
	
	Local cArq	   	:= RTrim(GetTempPath())+"INCLUSAO_NCC_"+cValToChar(DtoS(dDatabase))+"_"+StrTran(Time(),":","")+".xls" //RTrim("C:\HD\Arq Trabalho\NOVAMIX\SMARTQUESTION\Retorno WebService\RETORNO_WEBSERVICE_SMARTQUESTION.xls")
	Local oExcel 	:= FWMsExcelEx():New()
	Local nConta	:= 0
	
	//aRet[1] - Numero Coleta da Linha
	//aRet[2] - Numero Coleta do Produtor
	//aRet[3] - Codigo Tanque Produtor
	//aRet[4] - Litros de Leite Coletado
	//aRet[5] - Codigo Tanque Pai
	//aRet[6] - Data Entrada
	//aRet[7] - Codigo Linha		
	//aRet[8] - Litros de Leite Recebido
	//aRet[9] - Filial Linha		
	//aRet[10]- Codigo da Linha Leite Recebido
	//aRet[11]- KM Rastreado
	//aRet[12]- Odometro Inicio Dia
	//aRet[13]- Odometro Fim Dia
	//aRet[14]- Placa do Veiculo
	
	oExcel:AddworkSheet("NCC")
	oExcel:AddTable ("NCC","Inclusao NCC")
	
	oExcel:AddColumn("NCC","Inclusao NCC","Filial"		,1,1)
    oExcel:AddColumn("NCC","Inclusao NCC","Prefixo"		,1,1)
	oExcel:AddColumn("NCC","Inclusao NCC","Numero"		,1,1)
    oExcel:AddColumn("NCC","Inclusao NCC","Parcela"		,1,1)
	oExcel:AddColumn("NCC","Inclusao NCC","Tipo"		,1,1)
    oExcel:AddColumn("NCC","Inclusao NCC","Cliente"		,1,1)
	oExcel:AddColumn("NCC","Inclusao NCC","Loja"		,1,1)
    oExcel:AddColumn("NCC","Inclusao NCC","Natureza"	,1,1)
	oExcel:AddColumn("NCC","Inclusao NCC","Emissao"		,1,1)
    oExcel:AddColumn("NCC","Inclusao NCC","Vencimento"	,1,1)
	oExcel:AddColumn("NCC","Inclusao NCC","Valor"		,1,1)
    
    dbSelectArea("ZZZ")
    dbSetOrder(1)
    dbGoTop()
    
    While !Eof()
    	oExcel:AddRow("NCC","Inclusao NCC",{ZZZ->ZZZ_FILIAL				,;
    										ZZZ->ZZZ_CONTRA   			,;
    										ZZZ->ZZZ_REVISA   			,;
    										ZZZ->ZZZ_DATA   			,;
											ZZZ->ZZZ_PRE1   			,;
											ZZZ->ZZZ_VRBRUT				,;
											ZZZ->ZZZ_PRE2   			,;
											ZZZ->ZZZ_VR2				,;
											ZZZ->ZZZ_PRE3   			,;
											ZZZ->ZZZ_VR3   			    ,;
											ZZZ->ZZZ_PRE4       		})
		dbSkip()
    EndDo
    
 
	ProcessMessage()
	oExcel:Activate()
	oExcel:GetXMLFile(cArq)
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cArq)
	oExcelApp:SetVisible(.T.)
	
Return