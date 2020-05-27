#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "PROTHEUS.CH" 
User Function JExcLei()

Local aArea 	:= GetArea()
Local cQry 		:= ''
Local cNumSeq 	:= 	'' //cValToChar(ZZS->ZZS_NUMSEQ)	
Local cNumDia	:= 	'' //cValToChar(ZZS->ZZS_NUMDIA)	
Local cChvPA4	:= ''
Local nQtdLit	:= 0
Local nKM		:= 0
Local cTpFrt	:= ''
Local nValFrt	:= 0
Local dDtEntr	
Local lEstorna	:= .F.
Local cGetFrete :=  GetNextAlias()
		
		Beginsql Alias cGetFrete
				
				%NOPARSER%
				 SELECT PC0_FILIAL,PC0_NUMDIA AS ZZS_NUMDIA,PC0_DTENTR AS ZZS_DTENTR,PC0_NUMSEQ AS ZZS_NUMSEQ 
				 FROM PC0010 
				 WHERE PC0_DTENTR BETWEEN '20200301' AND '20200331' AND D_E_L_E_T_='' AND PC0_FILIAL='04'	
				
				//SELECT ZZS_FILIAL,ZZS_NUMSEQ,ZZS_NUMDIA,ZZS_DTENTR 
				//FROM %table:ZZS% ZZS 
				//WHERE ZZS_FILIAL=%Exp:cFilAnt%  AND ZZS_DTENTR BETWEEN '20200301' AND '20200331'
				//AND ZZS.%notDel% 		
		
		Endsql
	
While (cGetFrete)->( !Eof())	

 cNumSeq 	:= 	cValToChar((cGetFrete)->(ZZS_NUMSEQ))	
 cNumDia	:= 	cValToChar((cGetFrete)->(ZZS_NUMDIA))	
		dbSelectArea("ZZS")
		dbSetOrder(1)
		//If .T. //MsgYesNo(OemToAnsi("Deseja exclui lancamento?"))

			//If .T. //MsgYesNo(OemToAnsi("Deseja exclui lancamento na TAMBEM na CAPTACAO DE LEITE?"))
				lEstorna := .T.
				//If dbSeek(cFilAnt+cNumDia)
					dDtEntr := 	stod((cGetFrete)->(ZZS_DTENTR))				
					//While !Eof() .AND. (cGetFrete)->(ZZS_FILIAL)+cValToChar((cGetFrete)->(ZZS_NUMDIA)) == cFilAnt+cNumDia
					
						cNumSeq := (cGetFrete)->(ZZS_NUMSEQ)
						
						aArea1 := GetArea()
						
						PC0->(dbSetOrder(1))
						If PC0->(dbSeek(cFilAnt+cNumSeq))
							
							While PC0->(!Eof()) .AND. PC0->(PC0_FILIAL+PC0_NUMSEQ) == cFilAnt+cNumSeq
								PC1->(dbSetOrder(1))
								If PC1->(dbSeek(cFilAnt+cNumSeq))
									
									While PC1->(!Eof()) .AND. PC1->(PC1_FILIAL+PC1_NUMSEQ) == cFilAnt+cNumSeq
										PC1->(RecLock("PC1",.F.))
											PC1->(dbDelete())
										PC1->(MsUnlock())
										PC1->(dbSkip())
									EndDo
								End If
								PC2->(dbSetOrder(1))
								If PC2->(dbSeek(cFilAnt+cNumSeq))
									
									While PC2->(!Eof()) .AND. PC2->(PC2_FILIAL+PC2_NUMSEQ) == cFilAnt+cNumSeq
										PC2->(RecLock("PC2",.F.))
											PC2->(dbDelete())
										PC2->(MsUnlock())
										PC2->(dbSkip())
									EndDo
								End If

								PC0->(RecLock("PC0",.F.))
									PC0->(dbDelete())
								PC0->(MsUnlock())
								PC0->(dbSkip())
								
								//exclui frete
								PA4->(dbSetOrder(5))
								If PA4->(dbSeek(xFilial("PA4")+cValToChar((cGetFrete)->(ZZS_NUMDIA))))
									
									cChvPA4 := PA4->(PA4_FILIAL)+PA4->(PA4_CODCAM)+PA4->(PA4_PERIOD)
									
									nQtdLit	:= 0
									nKM		:= Posicione("ZA1",1,xFilial("ZA1")+cValToChar(PA4->(PA4_NUMDIA)),"ZA1_KMREAL")
									cTpFrt	:= Posicione("LBE",2,xFilial("LBE")+PA4->(PA4_CODCAM),"LBE_TPFRET")
									nValFrt := Posicione("LBE",2,xFilial("LBE")+PA4->(PA4_CODCAM),"LBE_PERC1")
									
									While PA4->( !Eof() ) .AND. PA4->(PA4_FILIAL)+cValToCHar(PA4->(PA4_NUMDIA)) == (cGetFrete)->(ZZS_FILIAL)+cValToChar((cGetFrete)->(ZZS_NUMDIA))
										nQtdLit += PA4->(PA4_QTDLIT)
										PA4->(RecLock("PA4",.F.))
											PA4->(dbDelete())
										PA4->(MsUnlock())
										PA4->( dbSkip() )
									EndDo
									
									PA3->(dbSetOrder(1))
									If PA3->( dbSeek(cChvPA4) )
										PA3->(RecLock("PA3"),.F.)
											
											PA3->PA3_QTDLIT -= nQtdLit 
											PA3->PA3_TOTKM	-= nKM
											
											If 	cTpFrt == '1'
										    	PA3->(PA3_VLRFRT)	:= (PA3->PA3_QTDLIT *  nValFrt) 
										    ElseIf cTpFrt == '2'
										    	PA3->(PA3_VLRFRT)	:= nValFrt 
										   	Else
										    	PA3->(PA3_VLRFRT)	:= (PA3->PA3_TOTKM *  nValFrt) 
										   	EndIf
							
										PA3->(MsUnlock())
									EndIf
								EndIf
							
							EndDo
						End If
							
						RestArea(aArea1)
						
					//	dbSelectArea("ZZS")
					//	dbSkip()
					//EndDo
				//End If
			//End If
			
			If lEstorna
				FAtuEst(2,0,cNumDia,dDtEntr)
			End If
			
			cQry := "DELETE " + RetSqlName("ZZT") + " WHERE ZZT_FILIAL='" + cFilAnt + "' AND ZZT_NUMDIA=" + cValToChar(cNumDia)
			TcSqlExec(cQry)
			
			cQry := "DELETE " + RetSqlName("ZZS") + " WHERE ZZS_FILIAL='" + cFilAnt + "' AND ZZS_NUMDIA=" + cValToChar(cNumDia)
			TcSqlExec(cQry)
			
			cQry := "DELETE " + RetSqlName("ZA1") + " WHERE ZA1_FILIAL='" + cFilAnt + "' AND ZA1_NUMDIA=" + cValToChar(cNumDia)
			TcSqlExec(cQry)
			
		
		//MsgStop("Lancamento Excluido com sucesso !")
		
		//End If
	
	(cGetFrete)->(dbSkip())
	
	EndDo

Return

Static Function FAtuEst(nTipo,nQtd,nNumSeq,dDtEntr)

	Local aAtuEst	:= {}
	Local nI       	:= 0
	Local aArea		:= GetArea()
	
		If nTipo == 1 // Entrada
			
		//cadastro de PRODUTO
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek( xFilial("SB1")+'200113' )
		
			aAtuEst := {}
		
			aAtuEst :=  {	{"D3_TM"		,GETMV("ES_TMENTLE")	,NIL},;
							{"D3_COD"		,SB1->B1_COD			,NIL},;
							{"D3_UM"		,SB1->B1_UM				,NIL},;
							{"D3_QUANT"		,nQtd					,".T."},;
							{"D3_LOCAL"		,SB1->B1_LOCPAD			,NIL},;
							{"D3_EMISSAO"	,dDtEntr				,NIL},;
							{"D3_CUSTO1"	,0.01					,NIL},;
							{"D3_DOC"		,cValToChar(nNumSeq)	,NIL},;
							{"D3_NUMSEQ"	,ProxNum()				,NIL}}
							
			lMsErroAuto := .F.

			MSExecAuto({|x,y| mata240(x,y)},aAtuEst,3) //inclusao

			If lMsErroAuto
				Mostraerro()
				DisarmTransaction()
			Endif

	EndIf
	
	If nTipo == 2 //estorno
			
			//ZZT_FILIAL+ZZT_NUMDIA+ZZT_NUMATE                                                                                                                                
			ZZT->(dbSetOrder(1))
			
			If ZZT->( dbSeek(xFilial("ZZT")+nNumSeq) )
				
			
				While ZZT->( !Eof() ) .AND. ( ZZT->(ZZT_FILIAL+cValToCHar(ZZT_NUMDIA)) == xFilial("ZZT")+nNumSeq )
					nQtd += ZZT->(ZZT_QTDREC)	
					ZZT->( dbSkip() )
				EndDo	

				DbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek( xFilial("SB1")+'200113' )
			
				aAtuEst := {}
			
				aAtuEst :=  {	{"D3_TM"		,GETMV("ES_TMESTLE")	,NIL},;
								{"D3_COD"		,SB1->B1_COD			,NIL},;
								{"D3_UM"		,SB1->B1_UM				,NIL},;
								{"D3_QUANT"		,nQtd					,".T."},;
								{"D3_LOCAL"		,SB1->B1_LOCPAD			,NIL},;
								{"D3_CUSTO1"	,0.01					,NIL},;
								{"D3_DOC"		,nNumSeq				,NIL},;
								{"D3_EMISSAO"	,dDtEntr				,NIL},;
								{"D3_NUMSEQ"	,ProxNum()				,NIL}}
				
	
				lMsErroAuto := .F.
	
				MSExecAuto({|x,y| mata240(x,y)},aAtuEst,3) //estorno
	
				If lMsErroAuto
					Mostraerro()
					DisarmTransaction()
				Endif

			EndIf
		
	EndIf

	RestArea(aArea)

Return

/*/{Protheus.doc} GrvEntWdo =======================================================
description
@type function
@version 
@author wilso
@since 13/05/2020
@return return_type, return_description
/*/
User Function GrvEntWdo()


MsAguarde({|| xEntWdo()},"Aguarde...","Executando Insercao..aguarde!",.T.)


Return 

Static Function xEntWdo()

	Local nI      		:= 0
	Local nY      		:= 0
	Local cVar    		:= ""
	Local lOk     		:= .T.
	Local cMsg    		:= ""
	Local nPos    		:= 0
	Local aAux    		:= {}
	Local lAchou  		:= .F.
	Local cNum			:= " "
	Local aRet			:= {}
	Local nQtdRec	:= 0
	
	dbSelectArea("ZZS")
	dbSetOrder(1)
	
	If dbSeek(xFilial("ZZS"))
		While !Eof() .AND. XFILIAL("ZZS") == ZZS->ZZS_FILIAL
			aRet := {}
			aAreaZZS := GetArea()
			
			If ZZS->ZZS_STATUS=='1'
				
				Begin Transaction
				
				cNum := GetSx8Num("PC0","PC0_NUMSEQ")		
				
				MsProcTxt("Processando NumDia  >>>  * *  " + cValToChar(ZZS->ZZS_NUMDIA) + " * * ")
				
				RecLock("PC0",.T.)
					PC0->PC0_FILIAL := xFilial("PC0")
					PC0->PC0_NUMSEQ := cNum
					PC0->PC0_DTENTR := ZZS->ZZS_DTENTR
					PC0->PC0_TPENTR := "1"
					PC0->PC0_LINROT := ZZS->ZZS_CODLIN
					PC0->PC0_DESCRI := RetField("PA7",1,xFilial("PA7") + ZZS->ZZS_CODLIN,"PA7->PA7_DESC")
					PC0->PC0_QTDAPO := ZZS->ZZS_QTAPLI
					PC0->PC0_QTDMED := ZZS->ZZS_QTAPLI
					PC0->PC0_QTDDIF := 0
					PC0->PC0_NUMDIA := ZZS->ZZS_NUMDIA
				MsUnLock("PC0")
				
				RecLock("PC0",.T.)
					PC0->PC0_FILIAL := xFilial("PC0")
					PC0->PC0_NUMSEQ := cNum
					PC0->PC0_DTENTR := ZZS->ZZS_DTENTR
					PC0->PC0_TPENTR := "2"
					PC0->PC0_LINROT := IIF(cFilAnt $ '05|10',xRotaDou(RetField("PA7",1,xFilial("PA7") + ZZS->ZZS_CODLIN,"PA7->PA7_CODCAR"),cFilAnt),ZZS->ZZS_CODROT)
					PC0->PC0_DESCRI := RetField("LBC",1,xFilial("LBC") + IIF(cFilAnt $ '05|10',xRotaDou(RetField("PA7",1,xFilial("PA7") + ZZS->ZZS_CODLIN,"PA7->PA7_CODCAR"),cFilAnt),ZZS->ZZS_CODROT) ,"LBC->LBC_DESC")
					PC0->PC0_QTDAPO := ZZS->ZZS_QTAPLI
					PC0->PC0_QTDMED := ZZS->ZZS_QTAPLI
					PC0->PC0_QTDDIF := 0
					PC0->PC0_NUMDIA := ZZS->ZZS_NUMDIA
				MsUnLock("PC0")

				RecLock("PC2",.T.)
					PC2->PC2_FILIAL := xFilial("PC2")
					PC2->PC2_NUMSEQ := cNum
					PC2->PC2_ROTA   := IIF(cFilAnt $ '05|10',xRotaDou(RetField("PA7",1,xFilial("PA7") + ZZS->ZZS_CODLIN,"PA7->PA7_CODCAR"),cFilAnt),ZZS->ZZS_CODROT)
					PC2->PC2_QTDMED := ZZS->ZZS_QTAPLI
					PC2->PC2_CODTAN := ZZS->ZZS_CODTAN
					PC2->PC2_QTDLIT := ZZS->ZZS_QTAPLI
					PC2->PC2_VLRLIT := 0
				MsUnLock("PC2")

			    //GRAVA PC1
				//DbSelectArea("ZZT")
				ZZT->(DbSetOrder(2))
				dbSeek(xFilial("ZZT")+pad(cValToChar(ZZS->ZZS_NUMDIA),TamSX3("ZZT_NUMDIA")[1])+ZZS->ZZS_CODLIN)
				
				If ZZT->(DbSeek( xFilial("ZZT")+pad(cValToChar(ZZS->ZZS_NUMDIA),TamSX3("ZZT_NUMDIA")[1])+ZZS->ZZS_CODLIN))

					While ZZT->( !Eof() ) .AND. (ZZT->ZZT_FILIAL+cValToChar(ZZT->ZZT_NUMDIA)+ZZT->ZZT_CODLIN == ZZS->ZZS_FILIAL+cValToChar(ZZS->ZZS_NUMDIA)+ZZS->ZZS_CODLIN)
				
						If ZZT->ZZT_QTDAJU > 0 .AND. SubStr(ZZT->ZZT_CODPRO,1,2) <> 'TC'
							
							nQtdRec += ZZT->ZZT_QTDREC
							
							RecLock("PC1",.T.)
								PC1->PC1_FILIAL := xFilial("PC1")
								PC1->PC1_NUMSEQ := cNum
								PC1->PC1_LINHA  := ZZS->ZZS_CODLIN
								PC1->PC1_QTDMED := ZZS->ZZS_QTAPLI
								PC1->PC1_CARSUB := ""
								PC1->PC1_CODPRO := ZZT->ZZT_CODPRO
								PC1->PC1_QTDLIT := ZZT->ZZT_QTDAJU
								PC1->PC1_VLRLIT := ZZT->ZZT_PRCLEI
								PC1->PC1_NUMATE := ZZT->ZZT_NUMATE
							MsUnLock("PC1")
							
						End If
						
						ZZT->( DbSkip() ) 
					
					EndDo

			    End If

			    RecLock("ZZS",.F.)
			    	ZZS->ZZS_STATUS := '2'
			    	ZZS->ZZS_NUMSEQ := cNum
			    MsUnlock("ZZS")
			    
			    ConfirmSX8()
			    
			    If GETMV("ES_ATUESTO",,.F.) //parametro verifica se atualiza ou nao estoque
						FAtuEst(1,nQtdRec,ZZS->ZZS_NUMDIA,ZZS->ZZS_DTENTR)
				EndIf
			    
			    AADD(aRet,{ZZS->ZZS_NUMDIA,,,,,,,,ZZS->ZZS_FILIAL,ZZS->ZZS_CODLIN})
			    
			    U_xGetFrete(aRet)
			    
			    End Transaction

			EndIf
			RestArea(aAreaZZS)
			dbselectArea("ZZS")
			dbSkip()
				
		EndDo
					
	
	EndIf
Return

Static Function xRotaDou(cCodCam,xFil)

Local aArea := GetArea()
Local cRot := ''
Local cQuery := "SELECT LBC_CODROT FROM " + RetSqlName("LBC") + " LBC WHERE LBC_CODCAM='" + cCodCam + "' AND LBC_FILIAL='" + xFil + "' " + CRLF
Local cAliasQry := "cLbcDou"


TCQUERY cQuery NEW ALIAS cAliasQry

If cAliasQry->( !Eof() )

	cRot := cAliasQry->(LBC_CODROT)

End If

cAliasQry->(DbCloseArea())

RestArea(aArea)

Return cRot
