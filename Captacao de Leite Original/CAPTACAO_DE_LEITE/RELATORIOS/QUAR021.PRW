#include "Protheus.Ch"
#Include "MSOLE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQUAR021   บAutor  ณElcio Mitsuo Horii  บ Data ณ  22/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressใo do formulแrio de Itinerแrio, integra็ใo com Word  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function QUAR021()
Local aAreaAnt := GetArea()
Private cTitulo:= " Formulแrio de Itinerแrio "
Private cPerg  := "QUR021"


AjustaSX1(cPerg)

//+-------------------------------------------------------------------------------
//| DisponCountbiliza para usuario digitar os parametros
//+-------------------------------------------------------------------------------
If Pergunte(cPerg,	.T.)
	
	//+-------------------------------------------------------------------------------
	//| Chama funcao que processa os dados
	//+-------------------------------------------------------------------------------
	RptStatus({|lEnd| GeraDoc() }, "Aguarde...", "Processando registros...", .T. )
EndIf

RestArea(aAreaAnt)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraDoc   บAutor  ณ Elcio Mitsuo Horii บ Data ณ  22/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina responsavel pela montagem da consulta e integra็ใo  บฑฑ
ฑฑบDesc.     ณ com Word                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUAR021                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraDoc()
Local cQuery   	:= ""
Local nContador	:= 0 
Local cCodCam  	:= ""  
Local wcTransp 	:= ""
Local wcItem   	:= {}
Local nK       	:= 0
Local nI       	:= 0
//Local cCaminho := GetSrvProfString("RootPath","")
Local cCaminho 	:= ""
Local cPathDot 	:= ""
Local wcRoteiro := ""
Local lRet		:= .T.

Private	hWord       

cCaminho 	:= Alltrim(GetMV("ES_DOTWORD",,"\DIRDOC\"))
If Right(cCaminho, 1) <> "\"
	cCaminho += "\"
Endif
MakeDir( cCaminho ) 
cPathDot := cCaminho + "QUAR021.dot" 

cCaminho := Alltrim(GetMV("ES_MAQUSU",,"C:\TEMP\"))
If Right(cCaminho, 1) <> "\"
	cCaminho += "\"
Endif
MakeDir( cCaminho ) 


lRet := U_TestaLoc( cCaminho, cPathDot )

If lRet 
	cPathDot := cCaminho + "QUAR021.dot"
	// Filtra somente as rotas
	cQuery := "SELECT LBC.LBC_CODROT "
	cQuery += " FROM " + RetSqlName("LBD") + " LBD "
	cQuery += " JOIN " + RetSqlName("LBC") + " LBC ON LBC.LBC_CODROT = LBD.LBD_CODROT "
	cQuery += " AND LBC.LBC_FILIAL = '" + xFilial("LBC") + "' "
	cQuery += " AND LBD.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT OUTER JOIN " + RetSqlName("LBE") + " LBE ON LBE.LBE_CODCAM = LBC.LBC_CODCAM "
	cQuery += " AND LBE.LBE_FILIAL = '" + xFilial("LBE") + "' "
	cQuery += " AND LBE.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT OUTER JOIN " + RetSqlName("LBF") + " LBF ON LBF.LBF_CODTAN = LBD.LBD_CODTAN "
	cQuery += " AND LBF.LBF_FILIAL = '" + xFilial("LBF") + "' "
	cQuery += " AND LBF.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT OUTER JOIN " + RetSqlName("LBB") + " TAN ON TAN.LBB_CODPRO = LBF.LBF_CODPRO "
	cQuery += " AND TAN.LBB_FILIAL = '" + xFilial("LBB") + "' "
	cQuery += " AND TAN.D_E_L_E_T_ = ' ' "
	cQuery += " AND TAN.LBB_CODPRO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery += " LEFT OUTER JOIN " + RetSqlName("PA7") + " PA7 ON PA7.PA7_CODLIN = LBD.LBD_CODLIN "
	cQuery += " AND PA7.PA7_FILIAL = '" + xFilial("PA7") + "' "
	cQuery += " AND PA7.D_E_L_E_T_ = ' ' "
	cQuery += " AND PA7.PA7_CODLIN BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	cQuery += " LEFT OUTER JOIN " + RetSqlName("LBF") + " LBF_PA7 ON LBF_PA7.LBF_CODTAN = PA7.PA7_CODTAN "
	cQuery += " AND LBF_PA7.LBF_FILIAL = '" + xFilial("LBF") + "' "
	cQuery += " AND LBF_PA7.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT OUTER JOIN " + RetSqlName("LBB") + " LIN ON LIN.LBB_CODPRO = LBF_PA7.LBF_CODPRO "
	cQuery += " AND LBF_PA7.LBF_FILIAL = '" + xFilial("LBB") + "' "
	cQuery += " AND LBF_PA7.D_E_L_E_T_ = ' ' "
	cQuery += " AND LIN.LBB_CODPRO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery += " WHERE LBD.LBD_CODLIN BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	cQuery += " GROUP BY LBC.LBC_CODROT "
	cQuery += " ORDER BY LBC.LBC_CODROT "
	        
	DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery) ,"TAUX",.T.,.T.)        
	
	// Filtra as rotas com as linhas/tanque        
	cQuery := "SELECT LBC.LBC_CODROT "
	cQuery += ", LBD.LBD_SEQ "
	cQuery += ", LBC.LBC_DESC "
	cQuery += ", LBE.LBE_MOTO "
	cQuery += ", NMFOR = CASE WHEN LBD.LBD_CODLIN = '      ' THEN TAN.LBB_NOMFOR "
	cQuery += " WHEN LIN.LBB_CODTAN = '      ' THEN LIN.LBB_NOMFOR "
	cQuery += " END "
	cQuery += " FROM " + RetSqlName("LBD") + " LBD "  
	cQuery += " JOIN " + RetSqlName("LBC") + " LBC ON LBC.LBC_CODROT = LBD.LBD_CODROT "
	cQuery += " AND LBC.LBC_FILIAL = '" + xFilial("LBC") + "' "
	cQuery += " AND LBD.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT OUTER JOIN " + RetSqlName("LBE") + " LBE ON LBE.LBE_CODCAM = LBC.LBC_CODCAM "
	cQuery += " AND LBE.LBE_FILIAL = '" + xFilial("LBE") + "' "
	cQuery += " AND LBE.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT OUTER JOIN " + RetSqlName("LBF") + " LBF ON LBF.LBF_CODTAN = LBD.LBD_CODTAN "
	cQuery += " AND LBF.LBF_FILIAL = '" + xFilial("LBF") + "' "
	cQuery += " AND LBF.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT OUTER JOIN " + RetSqlName("LBB") + " TAN ON TAN.LBB_CODPRO = LBF.LBF_CODPRO "
	cQuery += " AND TAN.LBB_FILIAL = '" + xFilial("LBB") + "' "
	cQuery += " AND TAN.D_E_L_E_T_ = ' ' "
	cQuery += " AND TAN.LBB_CODPRO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery += " LEFT OUTER JOIN " + RetSqlName("PA7") + " PA7 ON PA7.PA7_CODLIN = LBD.LBD_CODLIN "
	cQuery += " AND PA7.PA7_FILIAL = '" + xFilial("PA7") + "' "
	cQuery += " AND PA7.D_E_L_E_T_ = ' ' "
	cQuery += " AND PA7.PA7_CODLIN BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	cQuery += " LEFT OUTER JOIN " + RetSqlName("LBF") + " LBF_PA7 ON LBF_PA7.LBF_CODTAN = PA7.PA7_CODTAN "
	cQuery += " AND LBF_PA7.LBF_FILIAL = '" + xFilial("LBF") + "' "
	cQuery += " AND LBF_PA7.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT OUTER JOIN " + RetSqlName("LBB") + " LIN ON LIN.LBB_CODPRO = LBF_PA7.LBF_CODPRO "
	cQuery += " AND LBF_PA7.LBF_FILIAL = '" + xFilial("LBB") + "' "
	cQuery += " AND LBF_PA7.D_E_L_E_T_ = ' ' "
	cQuery += " AND LIN.LBB_CODPRO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery += " WHERE LBD.LBD_CODLIN BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	cQuery += " ORDER BY LBC.LBC_CODROT, LBD.LBD_SEQ "
	
	
	DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery) ,"TRB",.T.,.T.)
	
	//Abre consulta temporแria
	dbSelectArea("TAUX")
	SetRegua(0) 
	        
	While TAUX->(!Eof())
	   IncRegua()
	   nK := 0	
	   wcItem  := {}
	   cCodRot := TAUX->LBC_CODROT
	
	   TRB->( DbSetOrder() )
	   TRB->( DbGoTop() )
	   WHILE TRB->(!Eof())
	      IF cCodRot == TRB->LBC_CODROT
	         
	         wcTransp  := TRB->LBE_MOTO 
	         wcRoteiro := TRB->LBC_DESC
	
	         nK := nK + 1
	         aAdd(wcItem, TRB->NMFOR)
	      ENDIF
	      TRB->(DbSkip())
	   END
	
	   //Conecta ao word
	   hWord := OLE_CreateLink()
	   OLE_SetProperty ( hWord, oleWdVisible, .T.)
	   OLE_NewFile(hWord, cPathDot)       
	
	   BeginMsOle()
	      OLE_SetDocumentVar(hWord, 'Prt_Roteiro', wcRoteiro )	
	      OLE_SetDocumentVar(hWord, 'Prt_Transp' , wcTransp  )
		   	
	      //Montagem das variaveis do cabecalho		
	      OLE_SetDocumentVar(hWord, 'Prt_NroItens', str(nK) )//variavel para identificar o numero total de
	                                                          //linhas na parte variavel
		        											  //Sera utilizado na macro do documento para execucao 
				        									  //do for next 
															
		  //Montagem das variaveis dos itens. No documento word estas variaveis serao criadas dinamicamente da seguinte forma:
		  // prt_cod1, prt_cod2 ... prt_cod10
		  for nI := 1 to nK
		     //Colunas
		     OLE_SetDocumentVar(hWord, 'Prt_Desc'+AllTrim(Str(nI)), wcItem[nI])
		  next nI
	
	      //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ 
	      //ณ Atualizando as variaveis do documento do Word                         ณ
	      //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	      OLE_UpdateFields(hWord)
		  OLE_ExecuteMacro(hWord,"tabitens")
	   EndMsOle()	
	
	   TAUX->(DbSkip())
	End
	
	OLE_SetProperty( hWord, oleWdVisible, .T. )
	OLE_SetProperty( hWord, oleWdWindowState, "MAX" )
	
	If MsgYesNo("Imprime o Documento ?")
		Ole_PrintFile(hWord,"ALL",,,1)
	EndIf
			
	If MsgYesNo("Fecha o Word e Corta o Link ?")
		OLE_CloseFile( hWord )
		OLE_CloseLink( hWord )
	Endif	
	
	TRB->(dbCloseArea())  
	TAUX->(dbCloseArea())
Else
	ApMsgAlert( "Nใo foi possivel copiar o modelo do Word, Relatorio cancelado.", "Atencao")
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณElcio Mitsuo Horii  บ Data ณ 22/07/08    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria grupo de perguntas se nao encontrar na tabela SX1     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUAR021                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1(cPerg)

DbSelectArea("SX1")
SX1->(DbSetOrder(1)) // x1_grupo
If !SX1->(DbSeek(cPerg))     
	PutSx1(cPerg, "01","Do Produtor        ?", "", "", "mv_ch1", "C",06,0,0,"G",          "","LBB","","","mv_par01",         "","","","      ",        "","","",            "","","",        "","","",       "","","","","","","","LBB","","","","","","","","")
	PutSx1(cPerg, "02","At้ Produtor       ?", "", "", "mv_ch2", "C",06,0,0,"G",          "","LBB","","","mv_par02",         "","","","ZZZZZZ",        "","","",            "","","",        "","","",       "","","","","","","","LBB","","","","","","","","")
	PutSx1(cPerg, "03","Da Linha           ?", "", "", "mv_ch3", "C",06,0,0,"G",          "","LBC","","","mv_par03",         "","","","      ",        "","","",            "","","",        "","","",       "","","","","","","","LBC","","","","","","","","")
	PutSx1(cPerg, "04","At้ Linha          ?", "", "", "mv_ch4", "C",06,0,0,"G",          "","LBC","","","mv_par04",         "","","","ZZZZZZ",        "","","",            "","","",        "","","",       "","","","","","","","LBC","","","","","","","","")	
EndIf      

Return    


