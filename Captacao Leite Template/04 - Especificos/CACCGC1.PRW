/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Programa  ³ GATILHO PARA CODIGO DO CLIENTE           ³ Data ³ 20.03.01 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
X3_VALID em branco, X3_VLDUSER U_CACCGC1()
*/

User Function CACCGC1()

LOCAL aArea := GetArea()
LOCAL lExiste

IF !cgc(M->A1_CGC)
	RETURN(.F.)
ENDIF


IF empty(M->A1_TIPO)
	MsgAlert("Informe o tipo do cliente","ATENÇÃO")
	RETURN(.F.)
ENDIF
IF empty(M->A1_PESSOA)
	MsgAlert("Informe a pessoa do cliente","ATENÇÃO")
	RETURN(.F.)
ENDIF

IF M->A1_PESSOA=="F" .AND. M->A1_TIPO=="L"  // FISICA E PRODUTOR RURAL
	SA1->(DbSetOrder(3))
	IF SA1->(DbSeek(xFilial("SA1")+M->A1_CGC)) .AND. SA1->A1_COD<>M->A1_COD
		alert("cadastrar o associado com o mesmo codigo e com loja diferente")
		
		cChaveCGC := substr(M->A1_CGC,1,8)
		SA1->(DbSeek(xFilial("SA1")+cChaveCGC))
		M->A1_COD  := SA1->A1_COD
		nLoja := 0
		WHILE cChaveCGC==SA1->(substr(SA1->A1_CGC,1,8))
			nLoja++
			SA1->(DbSkip())
		END
		M->A1_LOJA := strzero(nLoja+1,2)
		
		RestAREA(aArea)
		
		RETURN(.T.)
	ELSE
		RETURN(.T.)
	ENDIF
	
ELSE
	lExiste := Existchav("SA1",M->A1_CGC,3,"A1_CGC")
	
	
	IF lExiste
		
		SA1->(DbSetOrder(3))
		cChaveCGC := substr(M->A1_CGC,1,8)
		IF SA1->(DbSeek(xFilial("SA1")+cChaveCGC))
			M->A1_COD  := SA1->A1_COD
			nLoja := 0
			WHILE cChaveCGC==SA1->(substr(SA1->A1_CGC,1,8))
				nLoja++
				SA1->(DbSkip())
			END
			M->A1_LOJA := strzero(nLoja+1,2)
		ENDIF
		
		RestAREA(aArea)
	ENDIF
	
	return(lExiste)
ENDIF

