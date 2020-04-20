/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Programa  ³ GATILHO PARA CODIGO DO fornecedor        ³ Data ³ 20.03.01 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
Criado campo A2_PRODRUR C	1	S=Sim;N=Nao  Produtor Rural, VALID pertence("SN")
*/      

User Function CACCGC2()
LOCAL aArea := GetArea()
LOCAL lExiste

IF !cgc(M->A2_CGC)
	RETURN(.F.)
ENDIF

IF empty(M->A2_TIPO)
	MsgAlert("Informe o tipo do fornecedor","ATENÇÃO")
	RETURN(.F.)
ENDIF


IF M->A2_PRODRUR=="S" .AND. M->A2_TIPO=="F"  // PRODUTOR RURAL E FISICA
	SA2->(DbSetOrder(3))
	IF SA2->(DbSeek(xFilial("SA2")+M->A2_CGC)) .AND. SA2->A2_COD<>M->A2_COD
		alert("cadastrar o associado com o mesmo codigo e com loja diferente") 
		
		cChaveCGC := substr(M->A2_CGC,1,8)
		SA2->(DbSeek(xFilial("SA2")+cChaveCGC))
		M->A2_COD  := SA2->A2_COD
		nLoja := 0
		WHILE cChaveCGC==SA2->(substr(SA2->A2_CGC,1,8))
			nLoja++
			SA2->(DbSkip())
		END
		M->A2_LOJA := strzero(nLoja+1,2)
		
		RestAREA(aArea)
		
		RETURN(.T.)
	ELSE
		RETURN(.T.)
	ENDIF
	
ELSE
	lExiste := Existchav("SA2",M->A2_CGC,3,"A2_CGC")
	
	IF lExiste
		
		SA2->(DbSetOrder(3))
		cChaveCGC := substr(M->A2_CGC,1,8)
		IF SA2->(DbSeek(xFilial("SA2")+cChaveCGC))
			M->A2_COD  := SA2->A2_COD
			nLoja := 0
			WHILE cChaveCGC==SA2->(substr(SA2->A2_CGC,1,8))
				nLoja++
				SA2->(DbSkip())
			END
			M->A2_LOJA := strzero(nLoja+1,2)
		ENDIF
		
		RestAREA(aArea)
	ENDIF
	
	return(lExiste)
ENDIF

