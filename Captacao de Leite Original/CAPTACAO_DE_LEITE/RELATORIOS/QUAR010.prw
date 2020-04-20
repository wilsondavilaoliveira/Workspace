#include "Protheus.Ch"
#include "MSOle.Ch"                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QUAR010  บAutor  ณElcio Mitsuo Horii  บ Data ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Romaneio de Coleta de Leite (WORD)                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento - Quata                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function QUAR010()

Local nOpcA := 0
Local cPerg := "QUAR10"



Private cCadastro := "Romaneio de Coleta de Leite"

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

Local cQuery   := ""
Local cCodLin  := ""
Local wcCodLin := ""  
Local wcLinha  := ""
Local wcCar    := ""

Local wcCdLin  := {}
Local wcDsLin  := {}
Local nK       := 0
Local nI       := 0

Local cCaminho 	:= ""
Local cPathDot 	:= ""
Local cCamLoc	:= ""
Local lProssegue:= .F.
Local nReg		:= 0

Private	hWord       

//cCaminho := U_MyAdmPa1( "*.DOT", , "Modelo de documento" )
cCaminho 	:= Alltrim(GetMV("ES_DOTWORD",,"\DIRDOC\"))
cCamLoc		:= Alltrim(GetMV("ES_MAQUSU",,"C:\TEMP\"))

If Right(cCaminho, 1) <> "\"
	cCaminho += "\"
Endif

If Right(cCamLoc, 1) <> "\"
	cCamLoc += "\"
Endif

MakeDir( cCaminho ) 
MakeDir( cCamLoc ) 

cPathDot := cCaminho + "QUAR010.dot" 

lProssegue := U_TestaLoc( cCamLoc, cPathDot )

If lProssegue

	cPathDot := cCamLoc + "QUAR010.dot"  
	
	// Filtra somente as linhas
	cQuery := "SELECT PA7.PA7_CODLIN " 
	cQuery += " FROM " + RetSqlName("PA7") + " PA7 "
	cQuery += " WHERE PA7.PA7_CODLIN BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery += " AND PA7.D_E_L_E_T_ = ' ' "
	cQuery += " AND PA7.PA7_FILIAL = '" + xFilial("PA7") + "' "
	cQuery += " ORDER BY CAST(PA7.PA7_CODLIN AS INT)"
	
	MemoWrite("QUAR010.sql", cQuery)        
	
	DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery) ,"TAUX",.T.,.T.)        
	
	// Filtra os propritarios da linha        
	cQuery := "SELECT PA7.PA7_CODLIN "
	cQuery += ", PA7.PA7_DESC " 
	cQuery += ", PA7.PA7_CODCAR "
	cQuery += ", LBE.LBE_MOTO "    
	cQuery += ", LBB.LBB_CODPRO "
	cQuery += ", SUBSTRING(LBB.LBB_NOMFOR,1,29) AS LBB_DESC "
	cQuery += ", LBB.LBB_ORDLIN "
	cQuery += " FROM " + RetSqlName("PA7") + " PA7 "
	cQuery += " JOIN " + RetSqlName("LBE") + " LBE ON LBE.LBE_CODCAM = PA7.PA7_CODCAR "
	cQuery += " AND LBE.LBE_FILIAL = '" + xFilial("LBE") + "' "
	cQuery += " AND LBE.D_E_L_E_T_ = ' ' "
	cQuery += " JOIN " + RetSqlName("LBB") + " LBB ON LBB.LBB_LINHA = PA7.PA7_CODLIN "
	cQuery += " AND LBB.LBB_FILIAL = '" + xFilial("LBB") + "' "
	cQuery += " AND LBB.D_E_L_E_T_ = ' ' "
	cQuery += " AND LBB.LBB_CODPRO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	cQuery += " WHERE PA7.PA7_CODLIN BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery += " AND PA7.D_E_L_E_T_ = ' ' "
	cQuery += " AND PA7.PA7_FILIAL = '" + xFilial("PA7") + "' "
	cQuery += " ORDER BY CAST(PA7.PA7_CODLIN AS INT), CAST(LBB.LBB_CODPRO AS INT) "
	
	MemoWrite("QUAR010a.sql", cQuery)

	DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery) ,"TRB",.T.,.T.)
	
	//Abre consulta temporแria
		
	dbSelectArea("TAUX")
	
	
	While TAUX->(!Eof())
	nReg ++
	TAUX->( DbSkip() )
	End While
	
	SetRegua(nReg) 
    nReg := 1 
   //Conecta ao word
//   hWord := OLE_CreateLink()
	
	TAUX->( dbGoTop() )        
	
	While TAUX->(!Eof())
	   
	   IncRegua(nReg)
	   nReg ++
	   
	   nK := 0	
	   wcCdLin := {}
	   wcDsLin := {}
	   cCodLin := TAUX->PA7_CODLIN
	
	   TRB->( DbSetOrder() )
	   TRB->( DbGoTop() )
	   WHILE TRB->(!Eof())
	      IF cCodLin == TRB->PA7_CODLIN
	
	         wcCodLin := TRB->PA7_CODLIN
	         wcLinha  := TRB->PA7_DESC
	         wcCar    := TRB->LBE_MOTO 
	
	         nK := nK + 1
	         aAdd(wcCdLin, TRB->LBB_CODPRO )
	         aAdd(wcDsLin, TRB->LBB_DESC )
	      ENDIF
	      TRB->(DbSkip())
	   END
	
	   //Conecta ao word
	   hWord := OLE_CreateLink()
	   OLE_SetProperty ( hWord, oleWdVisible, .T.)
	   OLE_NewFile(hWord, cPathDot)       
	
	   BeginMsOle()
	      OLE_SetDocumentVar(hWord, 'Prt_Car'    , wcCar    )	
	      OLE_SetDocumentVar(hWord, 'Prt_CodLin' , wcCodLin )
	      OLE_SetDocumentVar(hWord, 'Prt_Linha'  , wcLinha  )
		   	
	      //Montagem das variaveis do cabecalho		
	      OLE_SetDocumentVar(hWord, 'Prt_NroItens', str(nK) )//variavel para identificar o numero total de
	                                                          //linhas na parte variavel
		        											  //Sera utilizado na macro do documento para execucao 
				        									  //do for next 
															
		  //Montagem das variaveis dos itens. No documento word estas variaveis serao criadas dinamicamente da seguinte forma:
		  // prt_cod1, prt_cod2 ... prt_cod10
		  for nI := 1 to nK
		     //Colunas
		     OLE_SetDocumentVar(hWord, 'Prt_CodPro'+AllTrim(Str(nI)), wcCdLin[nI])
		     OLE_SetDocumentVar(hWord, 'Prt_Desc'  +AllTrim(Str(nI)), wcDsLin[nI])
		  next
	
	      //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ 
	      //ณ Atualizando as variaveis do documento do Word                         ณ
	      //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	      OLE_UpdateFields(hWord)
		  OLE_ExecuteMacro(hWord,"tabitens")

//		  OLE_SetProperty( hWord, oleWdVisible, .T. )
//		  OLE_SetProperty( hWord, oleWdWindowState, "MAX" )
	   EndMsOle()	
//	   If MsgYesNo("Imprime o Documento ?")
//			Ole_PrintFile(hWord,"ALL",,,1)
//	   EndIf
//			
//	   If MsgYesNo("Fecha o Word e Corta o Link ?")
//			OLE_CloseFile( hWord )
//			OLE_CloseLink( hWord )
//	   Endif	

       //OLE_CloseLink( hWord )	
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
	ApMsgAlert("Nao foi possivel fazer a copia do arquivo modelo, relatorio cancelado", "Aten็ใo")	
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
	PutSx1(cPerg, "01", "Linha      De ?", "", "", "MV_CH1", "C",06,0,0,"G","","PA7","","","mv_par01","","","","      ","","","","","","","","","","","","","","","","","","","","","","LBC","","","")
	PutSx1(cPerg, "02", "Linha      At้?", "", "", "MV_CH2", "C",06,0,0,"G","","PA7","","","mv_par02","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","LBC","","","")
	PutSx1(cPerg, "03", "Carreteiro De ?", "", "", "MV_CH3", "C",06,0,0,"G","","LBE","","","mv_par03","","","","      ","","","","","","","","","","","","","","","","","","","","","","LBE","","","")
	PutSx1(cPerg, "04", "Carreteiro At้?", "", "", "MV_CH4", "C",06,0,0,"G","","LBE","","","mv_par04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","LBE","","","")		
EndIf      

Return    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณTestLoc   บAutor  ณwmanfre             บ Data ณ  07/22/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz a copia do modelo para a maquina local                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TestaLoc( cCaminho, cPathDot )
Local cSourcDir	:= ""
Local cNomDot	:= ""
Local cDrive	:= ""
Local cDir		:= ""
Local cFile		:= ""
Local cExtens	:= ""
Local _cType   	:= "*.DOT"
Local _nOpera  	:= GETF_NETWORKDRIVE+GETF_LOCALHARD
Local _cMsg    	:= "Selecione o modelo"
Local cDirAtu	:= ""
Local lRet		:= .F.

SplitPath( cPathDot, @cDrive, @cDir, @cFile, @cExtens )  //SPLITPATH ( < cArq > , [ @cDrive ] , [ @cCaminho ] , [ @cNome ] , [ @cExt ] ) --> NIL

cNomDot 	:= Alltrim(cFile) + Alltrim(cExtens)
cSourcdir 	:= Alltrim(cDrive)+Alltrim(cDir)
cDirAtu 	:= alltrim(cCaminho)
lRet := CpyS2T( cSourcDir+cNomDot, cDirAtu, .T. )

Return lRet