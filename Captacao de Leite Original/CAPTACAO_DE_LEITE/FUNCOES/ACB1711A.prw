#INCLUDE "PROTHEUS.CH"

User Function ACB1711A() 

Local cSerie	:= ""
Local cNotaIni	:= ""
Local cNotaFim	:= ""
Local cFili

If Pergunte('ACB1711A',.T.)
////
 		cNotaIni 	:= strzero(VAL(MV_PAR02),9)
		cNotaFim 	:= STRZERO(VAL(MV_PAR03),9)
		cSerie		:= ALLTRIM(MV_PAR04)
				
		cNotaIni 	:= padl(cNotaIni, 	TamSX3("F1_DOC")[1], 	"0")
		cNotaFim 	:= padl(cNotaFim, 	TamSX3("F1_DOC")[1], 	"0")
		cSerie		:= Padr(cSerie, 	TamSX3("F1_SERIE")[1], 	" ")
			
		dbSelectArea("SF1")
		dbSetOrder(1)
		dbSeek( xFilial("SF1") + cNotaIni + cSerie )
		
		While !eof() .and. SF1->F1_DOC <= cNotaFim 
		    If SF1->F1_SERIE == cSerie .and. SF1->F1_DOC >= cNotaIni .and. SF1->F1_DOC <= cNotaFim
				     Processa( {||GerComp()},"Aguarde...",SF1->F1_DOC, .T. )
				     //If !GerComp()
					//MsgAlert("Falhou na nota fiscal " + SF1->F1_DOC + ", Serie " + SF1->F1_SERIE + ".", "Atenção")
					//Endif
		    Endif
			SF1->( dbSkip() )
			
		End
msgalert("Fim")
End if

Return nil


Static Function GerComp()
Local aAreaAnt		:= GetArea()
Local lRet 			:= .F. 
Local aCabec		:= {}
Local aItensNF		:= {}
Local aIteTempNFE	:= {}
Private lMsErroAuto := .F.



dbSelectArea("SD1")
dbSetOrder(1)
If dbSeek( xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
//IncProc("Processando registro > " + SF1->F1_DOC)
	While !eof() .and. SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA == ;
			SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA
			
			SB1->(DbGoTop())
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1") + SD1->D1_COD))
			
			SF4->(DbGoTop())
			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4") + SD1->D1_TES))
			
			SA2->(dbGotop())
			SA2->(dbSetOrder(1))
			SA2->(dbSeek(xFilial("SA2") + SD1->D1_FORNECE + SD1->D1_LOJA))
			
			// Itens Nota Fiscal
			aadd(aIteTempNFE,{"D1_ITEM"	  ,SD1->D1_ITEM 	,Nil})
			aadd(aIteTempNFE,{"D1_COD"	  ,SD1->D1_COD		,Nil})
			aadd(aIteTempNFE,{"D1_UM"	  ,SD1->D1_UM		,Nil})
			aadd(aIteTempNFE,{"D1_QUANT"  ,SD1->D1_QUANT	,Nil})
			aadd(aIteTempNFE,{"D1_VUNIT"  ,SD1->D1_VUNIT    ,Nil}) // WM
			aadd(aIteTempNFE,{"D1_TOTAL"  ,SD1->D1_TOTAL	,Nil})
			aadd(aIteTempNFE,{"D1_EMISSAO",SD1->D1_EMISSAO	,Nil})
			aadd(aIteTempNFE,{"D1_TES"	  ,SD1->D1_TES      ,Nil})
			aadd(aIteTempNFE,{"D1_CONTA"  ,SD1->D1_CONTA	,Nil})
			aadd(aIteTempNFE,{"D1_CC"	  ,SD1->D1_CC		,Nil})
			aadd(aIteTempNFE,{"D1_RATEIO" ,'2'		        ,Nil})
			aadd(aIteTempNFE,{"D1_LOCAL"  ,SD1->D1_LOCAL	,Nil})
			aadd(aIteTempNFE,{"D1_DESPESA",SD1->D1_DESPESA  ,Nil})
			aadd(aItensNF,aIteTempNFE)
			SD1->( dbSkip() )
			
	End
			
	// Cabecalho Nota Fiscal
	aadd(aCabec,{"F1_TIPO"  	,SF1->F1_TIPO		,Nil})
	aadd(aCabec,{"F1_ESPECIE"	,SF1->F1_ESPECIE	,Nil})
	aadd(aCabec,{"F1_FORMUL"	,SF1->F1_FORMUL		,Nil})
	aadd(aCabec,{"F1_DOC"  	    ,SF1->F1_DOC		,Nil})
	aadd(aCabec,{"F1_SERIE"	    ,SF1->F1_SERIE		,Nil})
	aadd(aCabec,{"F1_COND"	    ,SF1->F1_COND 		,Nil})
	aadd(aCabec,{"F1_EMISSAO"	,SF1->F1_EMISSAO	,Nil})
	aadd(aCabec,{"F1_FORNECE"	,SF1->F1_FORNECE    ,Nil})
	aadd(aCabec,{"F1_LOJA"  	,SF1->F1_LOJA		,Nil})
	
	MSExecAuto({|x,y,z| MATA103(x,y,z)},aCabec,aItensNf,5)
	
	If lMsErroAuto
		MostraErro()
		//DisarmTransaction()
		Break
	Else
		lRet	:= .T.
	Endif

Endif

RestArea(aAreaAnt)
Return lRet



