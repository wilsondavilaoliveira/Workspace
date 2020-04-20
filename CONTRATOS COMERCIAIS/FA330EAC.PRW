#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE "PRCONST.CH"
#INCLUDE "FONT.CH"
#include "TBICONN.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} FA330EAC
Exclui compensação a receber
utilizado na exclusão de compensação de contas a receber, antes da contabilização.
@param xParam Parameter Description
@return xRet Return Description
@author  - Wilson Davila
@since 21/02/2019
/*/
//--------------------------------------------------------------
 
User Function FA330EAC()

Local lRet 		:= .F.
Local aArea 
Local nFilial 
Local aAreaZC6
Local nRecSE1 	:= SE1->( Recno() )
Local nRecZC6
Local nValZC6 	:= 0
Local aAreaSE5
Local aRecZC6 	:= {}
Local nValSE5 	:= 0
Local nValTot 	:= 0
Local cAliasQry	:= ''
Local aDelZC8	:= {}

xFil	:= SE1->E1_FILIAL 
xPref	:= SE1->E1_PREFIXO 
xNum	:= SE1->E1_NUM 
xParc	:= SE1->E1_PARCELA 
xTipo 	:= SE1->E1_TIPO 

For i := 1 To Len(aTitulos)

	If aTitulos[i,11]
			
			aAreaSE5 := GetArea()
			
			SE5->(dbSetOrder(2))
			
			If Alltrim(aTitulos[i,04]) == 'NCC' //Alltrim(SE1->E1_TIPO) == 'NF'
			//BEGIN TRANSACTION		
	
				cAliasQry	:= GetNextAlias()
				
				BeginSql alias cAliasQry
				column E5_VALOR as Numeric(10,2)
				SELECT TOP 1 R_E_C_N_O_ AS REG,E5_VALOR,E5_FILIAL, E5_TIPODOC, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_DATA, E5_CLIFOR, E5_LOJA, E5_SEQ 
				FROM %table:SE5% SE5 (NOLOCK) WHERE D_E_L_E_T_='*' AND 
				E5_FILIAL=%Exp:Alltrim(aTitulos[i,12])% 
				AND E5_TIPODOC=%Exp:"BA"% 
				AND E5_PREFIXO=%Exp:Alltrim(aTitulos[i,01])% 
				AND E5_NUMERO=%Exp:Alltrim(aTitulos[i,02])% 
				AND E5_PARCELA=%Exp:Alltrim(aTitulos[i,03])% 
				AND E5_TIPO=%Exp:Alltrim(aTitulos[i,04])% 
				AND E5_SEQ=%Exp:aTitulos[i,08]%
				//AND E5_VALOR=%Exp:Fa330VTix(aTitulos[i,10])%
				
				ORDER BY R_E_C_N_O_ DESC

				EndSql
				
				aRet := GetLastQuery()
				MemoWrite("C:\HD\Arq Trabalho\NOVAMIX\ACD\QUERYS\EXCLUI_COMP.SQL",aRet[2])
						
				While (cAliasQry)->(!Eof())	
					
					aAreaZC8 := GetArea()
					
					ZC8->(dbSetOrder(2))
						If ZC8->(dbSeek((cAliasQry)->(REG)))
							While ZC8->( !Eof()) .AND. ZC8->(ZC8_RECSE5) == (cAliasQry)->(REG) 
								//Baixa Ncc arquivo Zc6======================================================================	
								AADD(aDelZC8,{ZC8->( Recno() )})
								aAreaZC6 := GetArea()
									ZC6->( dbGoto(ZC8->(ZC8_RECZC6)))
										RecLock("ZC6",.F.)
											ZC6->ZC6_SALDO 	+= ZC8->(ZC8_VALOR)
											ZC6->ZC6_BAIXA	:= CTOD("  /  /  ")
											ZC6->ZC6_RECSE5	:= 0
										MsUnlock()
								RestArea(aAreaZC6)
								ZC8->( dbSkip() )
							EndDo
					
						End If
						RestArea(aAreaZC8)
						
						aAreaZC8 := GetArea()
						For _AdelZC8 := 1 To Len(aDelZC8)
							ZC8->( dbGoto(aDelZC8[_AdelZC8,1] ))
							ZC8->(RecLock("ZC8",.F.))
								ZC8->( dbDelete() )
							ZC8->( Msunlock() )
						Next _AdelZC8
						RestArea(aAreaZC8)

						aAreaZC6 := GetArea()
						
							dbSelectArea("ZC6")
							dbSetOrder(3)
							If dbSeek(cValToChar(SE1->( Recno() )))
							nRecSE1 := ZC6->( Recno()) 
							End If
						
						RestArea(aAreaZC6)
						
						aAreaZC6 := GetArea()
							//Baixa Nf arquivo ZC6======================================================================= 
							ZC6->( dbGoto(nRecSE1))
							ZC6->(RecLock("ZC6",.F.))
								ZC6->ZC6_SALDO 	+= (cAliasQry)->(E5_VALOR)
								ZC6->ZC6_BAIXA	:= CTOD("  /  /  ")
							ZC6->( MsUnlock() )
						RestArea(aAreaZC6)
				(cAliasQry)->( dbskip())
				EndDo
			
			//END TRANSACTION
			
			Else
			
			//BEGIN TRANSACTION
				
				cAliasQry	:= GetNextAlias()
				
				BeginSql alias cAliasQry
				column E5_VALOR as Numeric(10,2)
				SELECT TOP 1 R_E_C_N_O_ AS REG,E5_VALOR,E5_FILIAL, E5_TIPODOC, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_DATA, E5_CLIFOR, E5_LOJA, E5_SEQ 
				FROM %table:SE5% SE5 (NOLOCK) WHERE D_E_L_E_T_='*' AND 
				E5_FILIAL=%Exp:SE1->E1_FILIAL% 
				AND E5_TIPODOC=%Exp:"BA"% 
				AND E5_PREFIXO=%Exp:xPref% 
				AND E5_NUMERO=%Exp:xNum% 
				AND E5_PARCELA=%Exp:xParc% 
				AND E5_TIPO=%Exp:xTipo% 
				AND E5_SEQ=%Exp:aTitulos[i,08]%
				ORDER BY R_E_C_N_O_ DESC

				EndSql
				
				aRet := GetLastQuery()
				MemoWrite("C:\HD\Arq Trabalho\NOVAMIX\ACD\QUERYS\EXCLUI_COMP1.SQL",aRet[2])
		
				While (cAliasQry)->(!Eof())	
					
					aAreaSE1 := GetArea()
						SE1->(dbSetOrder(1))
						If SE1->(MsSeek(Pad(aTitulos[i,12],TamSX3("E1_FILIAL")[1])+;
										Pad(aTitulos[i,01],TamSX3("E1_PREFIXO")[1])+;
										Pad(aTitulos[i,02],TamSX3("E1_NUM")[1])+;
										Pad(aTitulos[i,03],TamSX3("E1_PARCELA")[1])+;
										Pad(aTitulos[i,04],TamSX3("E1_TIPO")[1])))
										
										nRecSE1 := SE1->( Recno() )
						End If
					RestArea(aAreaSE1)

					aAreaZC8 := GetArea()
					
					ZC8->(dbSetOrder(2))
						If ZC8->(dbSeek((cAliasQry)->(REG)))
							While ZC8->( !Eof()) .AND. ZC8->(ZC8_RECSE5) == (cAliasQry)->(REG) 
								//Baixa Ncc arquivo Zc6======================================================================	
								AADD(aDelZC8,{ZC8->( Recno() )})
								aAreaZC6 := GetArea()
									ZC6->( dbGoto(ZC8->(ZC8_RECZC6)))
										RecLock("ZC6",.F.)
											ZC6->ZC6_SALDO 	+= ZC8->ZC8_VALOR
											ZC6->ZC6_BAIXA	:= CTOD("  /  /  ")
											ZC6->ZC6_RECSE5	:= 0
										MsUnlock()
								RestArea(aAreaZC6)
								ZC8->( dbSkip() )
							EndDo
					
						End If
						RestArea(aAreaZC8)
						
						aAreaZC8 := GetArea()
						For _AdelZC8 := 1 To Len(aDelZC8)
							ZC8->( dbGoto(aDelZC8[_AdelZC8,1] ))
							ZC8->(RecLock("ZC8",.F.))
								ZC8->( dbDelete() )
							ZC8->( Msunlock() )
						Next _AdelZC8
						RestArea(aAreaZC8)
						
						aAreaZC6 := GetArea()
						
							dbSelectArea("ZC6")
							dbSetOrder(3)
							If dbSeek(cValToChar(nRecSE1))
							nRecSE1 := ZC6->( Recno()) 
							End If
						
						RestArea(aAreaZC6)
						
						aAreaZC6 := GetArea()	
						
							ZC6->( dbGoto(nRecSE1))
							
							//Baixa Nf arquivo 
							ZC6->(RecLock("ZC6",.F.))
								ZC6->ZC6_SALDO 	+= (cAliasQry)->(E5_VALOR)
								ZC6->ZC6_BAIXA	:= CTOD("  /  /  ")
							ZC6->( MsUnlock() )
							
						RestArea(aAreaZC6)
					(cAliasQry)->( dbskip())
				EndDo
			End If
	
		RestArea(aAreaSE5)
	//END TRANSACTION
	End If

Next i

Return NIL 


Static Function Fa330VTix(aTitulo,cTipoTit,cValorx)
LOCAL nValor
cValorx := IIF (cValorx == NIL,aTitulo,cValorx)
If ValType(cValorx)=="N"
	nValor := cValorx
Else
	nValor := DesTrans(cValorx)
Endif
Return nValor
