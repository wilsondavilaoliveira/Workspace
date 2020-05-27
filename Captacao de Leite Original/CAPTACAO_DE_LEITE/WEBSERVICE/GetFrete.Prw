#INCLUDE "PROTHEUS.CH" 
#INCLUDE "RWMAKE.CH" 
#INCLUDE "COLORS.CH" 
#INCLUDE "TOPCONN.CH"  
#INCLUDE "PRCONST.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} QUAA015A()
Simulador de preco de leite produtor
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
/*/

User Function xGetFrete(aRet)

Local cAliasQry := ''
Local nLitros 	:= 0
Local nKm		:= 0
Local TpBonif	:= ''
Local TpFrete	:= ''
Local nValFrt	:= 0 	
Local nNumDia	:= 0
Local nVlrFrt	:= 0	
Local nBonif	:= 0
Local nTotFrete	:= 0
	aSort(aRet,,,{ |x, y | x[9]+x[1] < y[9]+y[1] })
	
	For _i := 1 To Len(aRet)
	
		If nNumDia<>aRet[_i][1] .AND. Alltrim(aRet[_i][9]) == cFilAnt 
		
			//Exp:Val(aRet[_i][1])
			cAliasQry := GetNextAlias()
			BeginSql Alias cAliasQry
			
			%noparser%
		
			SELECT ZA1_FILIAL,LBE_CODCAM,LBE_MOTO,ZA1_PLACA,ZA1_NUMDIA,ZA1_CODLIN,PC1_NUMSEQ,ZA1_DTENTR,PC1_CODPRO,LBB_DESC,
			PC1_QTDLIT,ZA1_KMRAST,ZA1_KMREAL,ZA1_VLRECE,LBE_TPFRET,LBE_PERC1 
			FROM %table:ZA1% ZA1 
			INNER JOIN %table:LBE% LBE ON LBE_FILIAL=ZA1_FILIAL AND ZA1_CODLIN=LBE_CODCAM AND LBE.%notDel% AND LBE_STATUS='S'
			INNER JOIN %table:PC0% PC0 ON PC0_FILIAL=ZA1_FILIAL AND PC0_NUMDIA=ZA1_NUMDIA AND PC0_TPENTR='1' AND PC0.%notDel%
			INNER JOIN %table:PC1% PC1 ON PC1_FILIAL=PC0_FILIAL AND PC0_NUMSEQ=PC1_NUMSEQ AND PC1.%notDel%
			INNER JOIN %table:LBB% LBB ON LBB_FILIAL=PC1_FILIAL AND LBB_CODPRO=PC1_CODPRO AND LBB.%notDel%
			WHERE ZA1_FILIAL=%Exp:Pad(aRet[_i][9],TamSX3("ZA1_FILIAL")[1])% AND ZA1.%notDel% 
			AND ZA1_NUMDIA=%Exp:aRet[_i][1]% AND ZA1_CODLIN=%Exp:aRet[_i][10]% 
			ORDER BY LBE_CODCAM,ZA1_DTENTR,PC1_CODPRO
				
			EndSql
				    
		    If (cAliasQry)->( !Eof())
		    	nKm		:= (cAliasQry)->(ZA1_KMREAL)
		    	TpFrete	:= (cAliasQry)->(LBE_TPFRET)
		    	nValFrt	:= (cAliasQry)->(LBE_PERC1) 	
			EndIf
		    
		    While (cAliasQry)->( !Eof() )
		  
		 
		    	//PA3_FILIAL+PA3_CODCAM+PA3_PERIOD
		    	PA3->(dbSetOrder(1))
			    If !PA3->(dbSeek( (cAliasQry)->(ZA1_FILIAL)+(cAliasQry)->(LBE_CODCAM)+SubStr((cAliasQry)->ZA1_DTENTR,5,2)+SubStr((cAliasQry)->ZA1_DTENTR,1,4)))
			    	PA3->( Reclock("PA3",.T.))
			    		PA3->PA3_FILIAL := (cAliasQry)->(ZA1_FILIAL)
			    		PA3->PA3_CODCAM := (cAliasQry)->(LBE_CODCAM)
			    		PA3->PA3_PERIOD	:= SubStr((cAliasQry)->ZA1_DTENTR,5,2)+SubStr((cAliasQry)->ZA1_DTENTR,1,4)
			    	PA3->(MsUnlock())
			    EndIf
		    	
		    	//PA4_FILIAL+PA4_CODCAM+PA4_CODPRO+PA4_DATA
		    	PA4->(dbSetOrder(4))
			    If !PA4->(dbSeek( (cAliasQry)->(ZA1_FILIAL)+(cAliasQry)->(LBE_CODCAM)+(cAliasQry)->(PC1_CODPRO)+(cAliasQry)->(ZA1_DTENTR)))
		    	   	nLitros 	+= (cAliasQry)->(PC1_QTDLIT)
			    	PA4->( Reclock("PA4",.T.))
			    		PA4->PA4_FILIAL := (cAliasQry)->(ZA1_FILIAL)
			    		PA4->PA4_CODCAM := (cAliasQry)->(LBE_CODCAM)
			    		PA4->PA4_CODPRO	:= (cAliasQry)->(PC1_CODPRO)
			    		PA4->PA4_DATA	:= STOD((cAliasQry)->(ZA1_DTENTR))
			    		PA4->PA4_PERIOD	:= SubStr((cAliasQry)->ZA1_DTENTR,5,2)+SubStr((cAliasQry)->ZA1_DTENTR,1,4)
			    		PA4->PA4_QTDLIT	:= (cAliasQry)->(PC1_QTDLIT)
			    		PA4->PA4_NUMDIA	:= (cAliasQry)->(ZA1_NUMDIA)
			    	PA4->(MsUnlock())
			    EndIf
		
			    (cAliasQry)->( dbSkip() )
		 
		    EndDo
		    
		    (cAliasQry)->( dbGoTop() )
		   	If (cAliasQry)->( !eof() )
			   	PA3->(dbSetOrder(1))
				If PA3->(dbSeek( (cAliasQry)->(ZA1_FILIAL)+(cAliasQry)->(LBE_CODCAM)+SubStr((cAliasQry)->ZA1_DTENTR,5,2)+SubStr((cAliasQry)->ZA1_DTENTR,1,4)))
					
					nLitros 		+= PA3->(PA3_QTDLIT)
					nKm 			+= PA3->(PA3_TOTKM)
					nVlrFrt 		+= PA3->(PA3_VLRFRT)
								
					PA3->(RecLock("PA3"),.F.)
						If 	TpFrete == '1'
					    	PA3->(PA3_QTDLIT)	:= nLitros
					    	PA3->(PA3_TOTKM) 	:= nKm
					    	PA3->(PA3_VLRFRT)	:= (nLitros *  nValFrt) 
						ElseIf TpFrete == '2'
					    	PA3->(PA3_QTDLIT) 	:= nLitros
					    	PA3->(PA3_TOTKM) 	:= nKm
					    	PA3->(PA3_VLRFRT)	:= nValFrt 
					   	Else
					   		PA3->(PA3_QTDLIT) 	:= nLitros
					    	PA3->(PA3_TOTKM) 	:= nKm
					    	PA3->(PA3_VLRFRT)	:= (nKm *  nValFrt) 
					   	EndIf

				   	PA3->( MsUnlock())
					
					nBonif := 0
					
					LJW->(dbSetOrder(1))
					If LJW->(dbSeek(PA3->(PA3_FILIAL)+PA3->(PA3_PERIOD)+PA3->(PA3_CODCAM)))
						While LJW->( !Eof() ) .AND. LJW->(LJW_FILIAL+LJW_PERIOD+LJW_CODCAR) == PA3->(PA3_FILIAL)+PA3->(PA3_PERIOD)+PA3->(PA3_CODCAM) 
							
							TpBonif := POSICIONE("LJS",1,XFILIAL("LJS")+LJW->(LJW_CODBON),"LJS_TPPAGT")
								If TpBonif == '1'
									nBonif += (nLitros * LJW->(LJW_VALOR))
								ElseIf TpBonif =='2'
									nBonif += LJW->(LJW_VALOR)
								Else
									nBonif += (nKm * LJW->(LJW_VALOR))
								EndIf	
						
							LJW->(dbSkip())
						
						EndDo
					EndIf
				
				    PA3->(RecLock("PA3"),.F.)
						PA3->(PA3_VRBON)	:= nBonif
						PA3->(PA3_VRTOT)	:= PA3->(PA3_VLRFRT) + nBonif
					PA3->( MsUnlock())

				EndIf
			EndIf



			nNumDia := aRet[_i][1]
	   	
		EndIf
	   	
	   	nLitros := 0
		nKm		:= 0
		nValFrt	:= 0
	   	nVlrFrt := 0
	
	Next i

Return