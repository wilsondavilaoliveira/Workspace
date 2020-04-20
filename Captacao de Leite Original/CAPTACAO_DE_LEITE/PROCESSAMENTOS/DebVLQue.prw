#include 'protheus.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Microsiga           º Data ³  12/15/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DebVLQue(cCli,cLoja,nValor,cDoc,cSer)

Local cQuery	:= " "
Local nVal		:=  nValor
Local cNum		:= 	cDoc
Local cSerie	:= 	cSer

cQuery := "SELECT LBB_CODPRO,LBB_NOMFOR,A1_COD,A1_LOJA,A1_FORNECE,A1_LOJAFOR,A1_NOME FROM " + RetSqlName("SA1") + " SA1 "
cQuery += "INNER JOIN " + RetSqlName("LBB") + " LBB ON LBB_CODFOR=A1_FORNECE AND LBB_LOJA=A1_LOJAFOR AND LBB.D_E_L_E_T_='' " 
cQuery += "WHERE A1_XBAND='000487' AND SA1.D_E_L_E_T_='' AND A1_COD='" + cCli + "' AND A1_LOJA='" + cLoja + "' " 

cQuery := ChangeQuery( cQuery )

If Select("QRYVALE") > 0
	dbSelectArea("QRYVALE")
	QRYVALE->(dbCloseArea())
EndIf

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYVALE', .F., .T.)

QRYVALE->( dbGoTop() )

If QRYVALE->( Eof() )
	Return
Else
	RunProc(QRYVALE->LBB_CODPRO,nVal,cNum,cSerie)
End If

Return()


Static Function RunProc(cCodPro,nVal,cNum,cSerie)

Local cQuery1	:= ""
Local cQuery2	:= ""
Local cQuery3	:= ""
Local cFor		:= ""
Local cLojFor	:= ""
Local cTipDes	:= ""
Local cSeq		:= ""

Do Case

Case cFilAnt == '02'
	cFor 	:= '009644'
	cLojFor	:= '0001' 
	cTipDes	:= '013'
Case cFilAnt == '03'
	cFor 	:= '012433'
	cLojFor	:= '0001' 
	cTipDes	:= '017'
Case cFilAnt == '04'
	cFor 	:= '011000'
	cLojFor	:= '0001'
	cTipDes	:= '041' 
Case cFilAnt == '05'
	cFor 	:= '013038'
	cLojFor	:= '0001'
	cTipDes	:= '013' 
EndCase

cQuery1 := "SELECT R_E_C_N_O_ AS REGISTRO,PA5_VALOR AS VALOR FROM " + RetSqlName("PA5") + " PA5 "
cQuery1 += "WHERE PA5_FILIAL='" + cFilAnt + "' AND PA5_PERIOD='" + StrZero(month(dDatabase),2)+cValToChar(year(dDatabase)) + "' "
cQuery1 += "AND PA5_FORNEC='" + cFor + "' AND PA5_LOJA='" + cLojFor + "' AND PA5_TIPDES='" + cTipDes + "' AND D_E_L_E_T_=' ' " 


cQuery1 := ChangeQuery( cQuery1 )

If Select("QRYPA5") > 0
	dbSelectArea("QRYPA5")
	QRYPA5->(dbCloseArea())
EndIf

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery1), 'QRYPA5', .F., .T.)

QRYPA5->( dbGoTop() )

If QRYPA5->( Eof() )

	RecLock("PA5",.T.)
 	
 	PA5->PA5_FILIAL 	:= cFilAnt
 	PA5->PA5_FORNECE 	:= cFor
 	PA5->PA5_LOJA		:= cLojFor
 	PA5->PA5_TIPDES		:= cTipDes
 	PA5->PA5_VENCTO		:= dDataBase
 	PA5->PA5_PERIOD		:= StrZero(month(dDatabase),2)+cValToChar(year(dDatabase)) 
	PA5->PA5_VALOR		:= nVal

	MsUnlock()
    

Else

	PA5->( dbGoTo(QRYPA5->REGISTRO) )
	
	RecLock("PA5",.F.)
 
 	PA5->PA5_VALOR	:= nVal + QRYPA5->VALOR

	MsUnlock()

End If


cQuery2 := "SELECT MAX(PA6_SEQ) AS SEQUENCIA FROM " + RetSqlName("PA6") + " PA6 "
cQuery2 += "WHERE PA6_FILIAL='" + cFilAnt + "' AND PA6_PERIOD='" + StrZero(month(dDatabase),2)+cValToChar(year(dDatabase)) + "' "
cQuery2 += "AND PA6_FORNEC='" + cFor + "' AND PA6_LOJA='" + cLojFor + "' AND PA6_TIPDES='" + cTipDes + "' AND D_E_L_E_T_=' ' " 


cQuery2 := ChangeQuery( cQuery2 )

If Select("QRYPA6") > 0
	dbSelectArea("QRYPA6")
	QRYPA6->(dbCloseArea())
EndIf

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery2), 'QRYPA6', .F., .T.)

QRYPA6->( dbGoTop() )

If QRYPA6->( Eof() )
	cSeq := '0001'
Else	
	cSeq := STRZERO(VAL(QRYPA6->SEQUENCIA)+1,4)
End If
    
    
    RecLock("PA6",.T.)
 	
 	PA6->PA6_FILIAL 	:= cFilAnt
 	PA6->PA6_CODPRO 	:= cCodPro
 	PA6->PA6_VALOR		:= nVal
 	PA6->PA6_OBSERV		:= "NF: "+cNum+"-"+cSerie
 	PA6->PA6_FORNEC		:= cFor
 	PA6->PA6_PERIOD		:= StrZero(month(dDatabase),2)+cValToChar(year(dDatabase)) 
	PA6->PA6_LOJA		:= cLojFor
	PA6->PA6_SEQ		:= cSeq   
	PA6->PA6_TIPDES		:= cTipDes

	MsUnlock()

Return()




