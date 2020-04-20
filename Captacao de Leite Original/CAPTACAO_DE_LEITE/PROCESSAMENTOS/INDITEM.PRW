#INCLUDE "PROTHEUS.CH"

User Function IndItem(aEnt,oProces2)

Local aTemp		:= {}
Local aRet		:= {}
Local nXa		:= 0
Local aLinha	:= {}
Local aAreaSav	:= GetArea()
Local aAreaLBB	:= LBB->(GetArea())
Local aAreaSA2	:= SA2->(GetArea())
Local aAreaPA7	:= PA7->(GetArea())

aTemp := {}

nRec := len(aEnt)

oProces2:setregua2(nrec)

oProces2:IncRegua1( OemToansi("Ordenando o array" ) )

For nXa := 1 to len(aEnt)

	oProces2:IncRegua2( "Registro.: "+cValToChar(nXa)+" De: "+cValtochar(nRec)  )
	
	aLinha := aClone(aEnt[nXa])
	
	dbSelectArea("LBB")
	dbSetorder(1)
	dbSeek(xFilial("LBB") + aEnt[nXa][11])

	dbSelectArea("SA2")
	dbSetorder(1)
	dbSeek(xFilial("SA2") + LBB->LBB_CODFOR + LBB->LBB_LOJA)
	
	dbSelectArea("PA7")
	dbSetOrder(1)
	dbSeek( xFilial("PA7") + LBB->LBB_LINHA )
	
	aadd( aLinha, strzero(val(LBB->LBB_LINHA ),6) )
	aadd( aLinha, strzero(val(LBB->LBB_CODPRO) , 6) )
    
	aadd(aTemp, aLinha)
	aLinha := {}
	
	
next nXa

aRet := aSort( aTemp,,,{|X,Y| x[15] +  x[16] < y[15]+ y[16]  } )

RestArea( aAreaLBB )
RestArea( aAreaSA2 )
RestArea( aAreaPA7 )
RestArea( aAreaSav )

Return aRet  
