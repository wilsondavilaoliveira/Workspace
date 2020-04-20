#INCLUDE 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUAA60AW  ºAutor  ³Wilson Davila       º Data ³  23/11/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     |Rotina ajustar saldo contrato detalhados iten ZC6           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Queijos Quata                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QUAA60AW()

If Pergunte("QUAA60AW",.T.)
	MsAguarde({|| xProcessa()},"Aguarde...","aguarde...",.T.)
EndIf

Return

Static Function xProcessa()

Local cQuery 	:= ''
Local cFilNum	:= ''
Local aTitulos	:= {}
Local cAliasZC6 := GetNextAlias()



	cQuery := "SELECT ZC6_RECSE1,ZC6_RECSE5,ZC6_FILIAL,ZC6_NUM,ZC6_PREFIX,ZC6_PARCEL, " + CRLF
	cQuery += "ZC6_TIPO,ZC6_ORIGEM,ZC6_VALOR,ZC6_SALDO,ZC6_BAIXA,ZC6.R_E_C_N_O_ AS RECZC6,ZC6_EMISSA  " + CRLF
	cQuery += "FROM " + RetSqlName("ZC6") + " ZC6 WHERE  " + CRLF
	cQuery += "ZC6_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  AND " + CRLF
	cQuery += "ZC6_EMISSA BETWEEN '" + dtos(MV_PAR03) + "' AND '" + dtos(MV_PAR04) + "' AND " + CRLF
	cQuery += "ZC6_NUM BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "'  " + CRLF
	cQuery += "AND D_E_L_E_T_='' " + CRLF
	cQuery += "ORDER BY ZC6_FILIAL,ZC6_NUM,ZC6_PREFIX,ZC6_TIPO DESC " + CRLF
	
	MemoWrite("C:\HD\QUERYS\QUAA06AW.sql",cQuery)
	
	If Select(cAliasZC6) > 0
		DbSelectArea(cAliasZC6)
		(cAliasZC6)->( DbCloseArea() )
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZC6,.T.,.T.)


	If (cAliasZC6)->(!Eof())
		cFilNum := (cAliasZC6)->(ZC6_FILIAL+ZC6_NUM)
	End If
	
	aTitulos := {}
	
	While (cAliasZC6)->(!Eof())
		
		MsProcTxt("Processando Nota > " + (cAliasZC6)->(ZC6_FILIAL)+"-"+(cAliasZC6)->(ZC6_NUM)+"-"+(cAliasZC6)->(ZC6_PREFIX))	
		
		If cFilNum <> (cAliasZC6)->(ZC6_FILIAL+ZC6_NUM)
			cFilNum  := (cAliasZC6)->(ZC6_FILIAL+ZC6_NUM)
			aTitulos := {}
		EndIf
			
			lDel := .F.
			
			If Alltrim((cAliasZC6)->(ZC6_ORIGEM)) == 'SE1' 
				SE1->( dbGoto((cAliasZC6)->(ZC6_RECSE1)))
				If SE1->( Deleted() )
					//MsgAlert("entrou E1")
					lDel := .T.	
				End If
			ElseIf Alltrim((cAliasZC6)->(ZC6_ORIGEM)) == 'SE2'
				SE2->( dbGoto((cAliasZC6)->(ZC6_RECSE1)))
				If SE2->( Deleted() )
					//MsgAlert("entrou E2")
					lDel := .T.
				End If
			End If
			
			If lDel
			
				ZC6->( dbGoto((cAliasZC6)->(RECZC6)))
				If ZC6->(!Eof())
					ZC6->(RecLock("ZC6",.F.))
						ZC6->( dbDelete())
					ZC6->(MsUnlock())
				End If
			
			ElseIf AllTrim((cAliasZC6)->(ZC6_TIPO)) $ 'NF|AB-' .AND. Alltrim((cAliasZC6)->(ZC6_ORIGEM)) == 'SE1'
			
				SE1->( dbGoto((cAliasZC6)->(ZC6_RECSE1)))
				If SE1->(!Eof())
					ZC6->( dbGoto((cAliasZC6)->(RECZC6)))
					If ZC6->(!Eof())
						ZC6->(RecLock("ZC6",.F.))
							ZC6->ZC6_SALDO := SE1->(E1_SALDO)
							ZC6->ZC6_BAIXA := SE1->(E1_BAIXA)
						ZC6->(MsUnlock())
					EndIf
				EndIf
			
			ElseIf AllTrim((cAliasZC6)->(ZC6_TIPO)) $ 'NF' .AND. Alltrim((cAliasZC6)->(ZC6_ORIGEM)) == 'SE2'
			
				SE2->( dbGoto((cAliasZC6)->(ZC6_RECSE1)))
				If SE2->(!Eof())
					ZC6->( dbGoto((cAliasZC6)->(RECZC6)))
					If ZC6->(!Eof())
						ZC6->(RecLock("ZC6",.F.))
							ZC6->ZC6_SALDO := SE2->(E2_SALDO)
							ZC6->ZC6_BAIXA := SE2->(E2_BAIXA)
						ZC6->(MsUnlock())
					EndIf
				EndIf
			
			ElseIf AllTrim((cAliasZC6)->(ZC6_TIPO)) $ 'NCC' .AND. Alltrim((cAliasZC6)->(ZC6_ORIGEM)) == 'SE1'
				
				SE1->( dbGoto((cAliasZC6)->(ZC6_RECSE1)))
				
				If SE1->(!Eof()) .AND. SE1->(E1_SALDO) == 0
					ZC6->( dbGoto((cAliasZC6)->(RECZC6)))
					If ZC6->(!Eof())
						ZC6->(RecLock("ZC6",.F.))
							ZC6->ZC6_SALDO := 0
						ZC6->(MsUnlock())
					EndIf
				Else
				
					ZC8->(dbSetOrder(1))
					If ZC8->(dbSeek((cAliasZC6)->(RECZC6)))
	
						ZC6->( dbGoto((cAliasZC6)->(RECZC6)))
						If ZC6->(!Eof())
							ZC6->(RecLock("ZC6",.F.))
								ZC6->ZC6_SALDO := ZC6->(ZC6_VALOR)
							ZC6->(MsUnlock())
						EndIf
						
						While ZC8->( !Eof()) .AND. (ZC8->(ZC8_RECZC6) == (cAliasZC6)->(RECZC6))
								If ZC6->(!Eof())
									ZC6->(RecLock("ZC6",.F.))
										ZC6->ZC6_SALDO -= ZC8->(ZC8_VALOR)
										ZC6->ZC6_BAIXA := ZC8->(ZC8_DATA)
									ZC6->(MsUnlock())
								EndIf
							ZC8->( dbSkip())
						EndDo
					Else
						SE1->( dbGoto((cAliasZC6)->(ZC6_RECSE1)))
						If SE1->(!Eof())
							
							If Len(aTitulos) == 0
								aTitulos := ConsSE5(SE1->(E1_FILIAL),SE1->(E1_NUM),SE1->(E1_TIPO),'R',SE1->(E1_PARCELA))
							End If
							
							For i := 1 To Len(aTitulos)
							
								If aTitulos[i][5]
									If Abs(aTitulos[i][2] - (cAliasZC6)->(ZC6_VALOR)) < 0.03
										ZC6->( dbGoto((cAliasZC6)->(RECZC6)))
										If ZC6->(!Eof())
											ZC6->(RecLock("ZC6",.F.))
												ZC6->ZC6_SALDO := Round(ZC6->(ZC6_VALOR)- aTitulos[i][2],1)
												ZC6->ZC6_BAIXA := STOD(aTitulos[i][4])
											ZC6->(MsUnlock())
											aTitulos[i][5] := .F.
											i := len(aTitulos)
										EndIf
									End If  
								End If
							Next i
						
						EndIf
					EndIf
				
				EndIf
			
			EndIf
		
			
			
			ZC6->( dbGoto((cAliasZC6)->(RECZC6)))
			If ( ( (ZC6->ZC6_SALDO == 0.01) .AND. (ZC6->ZC6_VALOR > 0.01) ) .OR. ( (ZC6->ZC6_SALDO == 0.02) .AND. (ZC6->ZC6_VALOR > 0.02) ) )
				If ZC6->(!Eof())
					ZC6->(RecLock("ZC6",.F.))
						ZC6->ZC6_SALDO := 0
					ZC6->(MsUnlock())
				End If
			End If
		
		(cAliasZC6)->( dbSkip() )
	EndDo

Return 


Static Function ConsSE5(xFil,xNum,xTipo,xRecPag,xParcela)

Local cQuery 	:= ''
Local aRet		:= {}	
Local aArea		:= GetArea()
Local cAliasSE5	:= "CONSSE5"

	
	//cQuery := "SELECT E5_FILIAL,E5_VALOR,E5_DATA,R_E_C_N_O_ AS REC FROM SE5010 WHERE E5_FILIAL='" + xFil + "' AND E5_NUMERO='" + xNum + "' AND E5_TIPO='" + xTipo + "' " + CRLF 
	//cQuery += "AND E5_RECPAG='" + xRecPag + "' AND E5_PARCELA='" + xParcela + "' AND D_E_L_E_T_='' " + CRLF
	cQuery := "SELECT E5_FILIAL,E5_VALOR,E5_DATA,R_E_C_N_O_ AS REC FROM SE5010 WHERE E5_FILORIG='" + xFil + "' AND E5_NUMERO='" + xNum + "' AND E5_TIPO='" + xTipo + "' " + CRLF
	cQuery += "AND E5_PARCELA='" + xParcela + "' AND D_E_L_E_T_='' " + CRLF
	
	//MemoWrite("C:\HD\QUERYS\QUAA06AW_SE5.sql",cQuery)
	
	If Select(cAliasSE5) > 0
		DbSelectArea(cAliasSE5)
		(cAliasSE5)->( DbCloseArea() )
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE5,.T.,.T.)

	While (cAliasSE5)->( !Eof())
		AADD(aRet,{(cAliasSE5)->(E5_FILIAL),(cAliasSE5)->(E5_VALOR),(cAliasSE5)->(REC),(cAliasSE5)->(E5_DATA),.T.})
		(cAliasSE5)->( dbskip())
	EndDo

	RestArea(aArea)

Return aRet

User Function JobZC6()

	RpcSetType(3)
	RpcSetEnv("01","01",,,'FIN')
	
	Pergunte("QUAA60AW",.F.)


	RpcClearEnv()

Return






	
	
	
	