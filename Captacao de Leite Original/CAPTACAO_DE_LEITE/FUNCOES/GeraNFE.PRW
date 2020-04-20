#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Microsiga           º Data ³  02/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GerNfCap()

oProcess := MsNewProcess():New({|| xGera(oProcess) },'Titulo',"Processando Inclusao: ",.T.)
oProcess:Activate()


Return



Static Function xGera(oObj)

Local cQuery := ''
Local nCount	:= 1
Local nNota		:= 16091
Local aIteTempNFE := {}
Local aCabec := {}
Local aItensNf := {}

Private lMsErroAuto := .F.


cQuery := "SELECT D1_ITEM,D1_COD,D1_UM,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_EMISSAO,D1_TES,D1_CONTA,D1_CC,D1_RATEIO,D1_LOCAL,D1_DESPESA,"
cQuery += " F1_TIPO,F1_ESPECIE,F1_FORMUL,F1_DOC,F1_SERIE,F1_COND,F1_EMISSAO,F1_FORNECE,F1_LOJA,F1_XINSS,F1_XFRETE,F1_XOUTROS,"
cQuery += " F1_XLIQUID,F1_XLINHA,F1_XINCEN,F1_XSUBST,F1_XADTO,F1_XCONV"
cQuery += " FROM SF1010 SF1 INNER JOIN SD1010 SD1 ON F1_FILIAL=D1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE" 
cQuery += " AND F1_FORNECE=D1_FORNECE AND F1_LOJA=D1_LOJA AND SD1.D_E_L_E_T_='' AND D1_SERIE='002' AND D1_FILIAL='03'"
cQuery += " WHERE SF1.D_E_L_E_T_='' AND (F1_DOC BETWEEN '000015868' AND '000016090')"
cQuery += " AND F1_SERIE='002' AND F1_FILIAL='03'"
cQuery += " ORDER BY F1_DOC"

cQuery := ChangeQuery( cQuery )

If Select("TRB1") > 0
	dbSelectArea("TRB1")
	dbCloseArea()
Endif

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'TRB1', .F., .T.)

oObj:SetRegua1(223)

cNumero := StrZero(nNota,9)

While TRB1->( !Eof() )

oObj:IncRegua1("Incluindo Nota Entrada: "+ cValToChar(nCount))       	
nCount ++
	
		// Itens Nota Fiscal
			aadd(aIteTempNFE,{"D1_ITEM"	  ,TRB1->D1_ITEM 	,Nil})
			aadd(aIteTempNFE,{"D1_COD"	  ,TRB1->D1_COD	   	,Nil})
			aadd(aIteTempNFE,{"D1_UM"	  ,TRB1->D1_UM	   	,Nil})
			aadd(aIteTempNFE,{"D1_QUANT"  ,TRB1->D1_QUANT	,Nil})
			aadd(aIteTempNFE,{"D1_VUNIT"  ,TRB1->D1_VUNIT   ,Nil}) // WM
			aadd(aIteTempNFE,{"D1_TOTAL"  ,TRB1->D1_TOTAL	,Nil})
			aadd(aIteTempNFE,{"D1_EMISSAO",dDatabase	    ,Nil})
			aadd(aIteTempNFE,{"D1_TES"	  ,TRB1->D1_TES     ,Nil})
			aadd(aIteTempNFE,{"D1_CONTA"  ,TRB1->D1_CONTA	,Nil})
			aadd(aIteTempNFE,{"D1_CC"	  ,TRB1->D1_CC		,Nil})
			aadd(aIteTempNFE,{"D1_RATEIO" ,'2'		    	,Nil})
			aadd(aIteTempNFE,{"D1_LOCAL"  ,TRB1->D1_LOCAL	,Nil})
			aadd(aIteTempNFE,{"D1_DESPESA",TRB1->D1_DESPESA	,Nil})
		
			aadd(aItensNF,aIteTempNFE)
			
			// Cabecalho Nota Fiscal
			aadd(aCabec,{"F1_TIPO"  	,"N"		         			,Nil})
			aadd(aCabec,{"F1_ESPECIE"	,"SPED"  	         			,Nil})
			aadd(aCabec,{"F1_FORMUL"	,"S"				 			,Nil})
			aadd(aCabec,{"F1_DOC"  	    ,cNumero  			 			,Nil})
			aadd(aCabec,{"F1_SERIE"	    ,'002'				 			,Nil})
			aadd(aCabec,{"F1_COND"	    ,GetMv("MV_CONDPAD",,"009") 	,Nil})
			aadd(aCabec,{"F1_EMISSAO"	,dDataBase	         			,Nil})
			aadd(aCabec,{"F1_FORNECE"	,TRB1->F1_FORNECE  	 			,Nil})
			aadd(aCabec,{"F1_LOJA"  	,TRB1->F1_LOJA	       			,Nil})
			aadd(aCabec,{"F1_XINSS"  	,TRB1->F1_XINSS	       			,Nil})
			aadd(aCabec,{"F1_XFRETE"  	,TRB1->F1_XFRETE       			,Nil})
			aadd(aCabec,{"F1_XOUTROS"  	,TRB1->F1_XOUTROS				,Nil})
			aadd(aCabec,{"F1_XLIQUID"  	,TRB1->F1_XLIQUID      			,Nil})
			aadd(aCabec,{"F1_XLINHA"  	,TRB1->F1_XLINHA       			,Nil})
			aadd(aCabec,{"F1_XINCEN"  	,TRB1->F1_XINCEN       			,Nil})
			aadd(aCabec,{"F1_XSUBST"  	,TRB1->F1_XSUBST       			,Nil})
			aadd(aCabec,{"F1_XADTO"  	,TRB1->F1_XADTO	       			,Nil})
			aadd(aCabec,{"F1_XCONV"  	,TRB1->F1_XCONV	       			,Nil})
			
			MSExecAuto({|x,y,z| MATA103(x,y,z)},aCabec,aItensNf,3)
			
			If lMsErroAuto
				MostraErro()
				//DisarmTransaction()  RONALDO 20/03/09
				lMsErroAuto := .F.
			Endif
		    
		    RecLock("SF1", .F.)
			SF1->F1_XINSS	:= TRB1->F1_XINSS
			SF1->F1_XFRETE	:= TRB1->F1_XFRETE
			SF1->F1_XOUTROS	:= TRB1->F1_XOUTROS
			SF1->F1_XLIQUID	:= TRB1->F1_XLIQUID
			SF1->F1_XLINHA	:= TRB1->F1_XLINHA
			SF1->F1_XINCEN	:= TRB1->F1_XINCEN
			SF1->F1_XSUBST	:= TRB1->F1_XSUBST
			SF1->F1_XADTO	:= TRB1->F1_XADTO
			SF1->F1_XCONV	:= TRB1->F1_XCONV
			MsUnlock()			

		       
		    aCabec 		:= {}
			aItensNF    := {}
			aIteTempNFE	:= {}
			
			TRB1->( dbSkip() )
            nNota ++
			cNumero := StrZero(nNota,9)
End While			

Return

			
		