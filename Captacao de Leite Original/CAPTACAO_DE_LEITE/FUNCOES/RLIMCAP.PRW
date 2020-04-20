#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RLIMCAP  ºAutor  ³ROBERTO R.MEZZALIRA  º      ³  21/11/16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ EXCLUI DOCUMENTO DE CAPTAÇÃO DE LEITE INDEVIDO             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ NOVAMIX                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION RLIMCAV()

Private oDlg  := NIL
Private cPerg := "RLIMCAP   "

If !FwIsAdmin()	//verifica se o usuario pertence ao grupo de administradores 
	
	ApMsgAlert("Esta rotina só pode ser utilizada pelo(s) Administrador(es) do Sistema")
	return()

EndIf


ValidPerg(cPerg)
Pergunte(cPerg,.f.)

DEFINE MSDIALOG oDlg TITLE "Rotina para exclusao de captação" FROM 0,0 TO 200,400 OF oDlg PIXEL
@ 02,005 TO 100,195 PIXEL OF oDlg
@ 10,020 Say " Este programa excluir od documentos de capatação indevidos" PIXEL OF oDlg

DEFINE SBUTTON FROM  85,105 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg)                 ENABLE OF oDlg
DEFINE SBUTTON FROM  85,135 BMPBUTTON TYPE 01 ACTION (oDlg:END(),OkLIMPA())          ENABLE OF oDlg
DEFINE SBUTTON FROM  85,165 BMPBUTTON TYPE 02 ACTION oDlg:END()                      ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTER

RETURN()


STATIC FUNCTION OKLIMPA()
Local  cAlispc0 := " " 
Local  cAlispc1 := " "
Local  cAlispc2 := " "
Local  lpc0     := .f.
Local  lpc1     := .f.
Local  lpc2     := .f.
Local  lpc0ne   := ''
Local  lpc1ne   := ''
Local  lpc2ne   := ''
local  cMens    := ""


cAliaspc0:= GetNextAlias()
IF Select(cAliaspc0) > 0
	dbSelectArea(cAliaspc0)
	dbCloseArea()
EndIf

BEGINSQL ALIAS cAliaspc0
					
		SELECT  *
		FROM %Table:PC0% (NOLOCK)  PC0
				
		WHERE PC0_FILIAL = %Exp: mv_par01%  AND
		PC0_NUMSEQ       BETWEEN  %Exp: mv_par02%  AND  %Exp: mv_par03%  AND
		PC0.%NotDel%
		

ENDSQL
				
DbSelectArea(cAliaspc0)
DBGOTOP()

DO WHILE (cAliaspc0)->(!Eof())  
			
	//INCPROC("Processando Cliente: "+(cAliasa1)->A1_COD +" Loja: "+(cAliasa1)->A1_LOJA )
	
	DBSELECTAREA("PC0")
	DBSETORDER(1) //PC0_FILIAL+PC0_NUMSEQ+DTOS(PC0_DTENTR)+PC0_TPENTR+PC0_LINROT                                                
	
	IF DBSEEK((cAliaspc0)->PC0_FILIAL+(cAliaspc0)->PC0_NUMSEQ+(cAliaspc0)->PC0_DTENTR+(cAliaspc0)->PC0_TPENTR+(cAliaspc0)->PC0_LINROT)
	
		RECLOCK("PC0",.F.)
	        DBDELETE()
	    MSUNLOCK()
	    
	    lpc0     := .T.
	ELSE
	   IF EMPTY(lpc0ne)
	   		lpc0ne := (cAliaspc0)->PC0_FILIAL+" - "+(cAliaspc0)->PC0_NUMSEQ
	   ELSE 
	        lpc0ne +=',' + (cAliaspc0)->PC0_FILIAL+" - "+(cAliaspc0)->PC0_NUMSEQ
	   ENDIF 	    
	ENDIF
	
	DbSelectArea(cAliaspc0)
	Dbskip()
						   
ENDDO

IF Select(cAliaspc0) > 0
	DbSelectArea(cAliaspc0)
	DbCloseArea()
ELSE

	RETURN 
ENDIF

cAliaspc1:= GetNextAlias()
IF Select( cAliaspc1) > 0
	dbSelectArea( cAliaspc1)
	dbCloseArea()
EndIf

BEGINSQL ALIAS cAliaspc1
					
		SELECT  *
		FROM %Table:PC1% (NOLOCK)  PC1
				
		WHERE PC1_FILIAL =  %Exp: mv_par01%  AND
		PC1_NUMSEQ       BETWEEN  %Exp: mv_par02%  AND  %Exp: mv_par03%  AND
		PC1.%NotDel%
		

ENDSQL

DO WHILE (cAliaspc1)->(!Eof())  
			
	//INCPROC("Processando Cliente: "+(cAliasa1)->A1_COD +" Loja: "+(cAliasa1)->A1_LOJA )
	
	DBSELECTAREA("PC1")
	DBSETORDER(1) //PC1_FILIAL+PC1_NUMSEQ+PC1_LINHA+PC1_CODPRO                                                
	
	IF DBSEEK( (cAliaspc1)->PC1_FILIAL+(cAliaspc1)->PC1_NUMSEQ+(cAliaspc1)->PC1_LINHA+(cAliaspc1)->PC1_CODPRO ) 
	
		RECLOCK("PC1",.F.)
	        DBDELETE()
	    MSUNLOCK()
	
	    lpc1     := .T.
	ELSE
	 
	   IF EMPTY(lpc1ne)
	   		lpc1ne := (cAliaspc1)->PC1_FILIAL+" - "+(cAliaspc1)->PC1_NUMSEQ
	   ELSE 
	        lpc1ne +=',' + (cAliaspc1)->PC1_FILIAL+" - "+(cAliaspc1)->PC1_NUMSEQ
	   ENDIF 	    
	
	ENDIF
	
	DbSelectArea(cAliaspc1)
	Dbskip()
						   
ENDDO
IF Select(cAliaspc1) > 0			
	DbSelectArea(cAliaspc1)
	DBGOTOP()
ENDIF

cAliaspc2:= GetNextAlias()
IF Select(cAliaspc2) > 0
	dbSelectArea(cAliaspc2)
	dbCloseArea()
EndIf

BEGINSQL ALIAS cAliaspc2
					
		SELECT  *
		FROM %Table:PC2% (NOLOCK)  PC2
				
		WHERE PC2_FILIAL = %Exp: mv_par01% AND
		PC2_NUMSEQ        BETWEEN  %Exp: mv_par02%  AND  %Exp: mv_par03%  AND
		PC2.%NotDel%
		

ENDSQL
				
DbSelectArea(cAliaspc2)
DBGOTOP()

DO WHILE (cAliaspc2)->(!Eof())  
			
	DBSELECTAREA("PC2")
	DBSETORDER(1) //PC2_FILIAL+PC2_NUMSEQ+PC2_ROTA+PC2_CODTAN                                             
	
	IF DBSEEK( (cAliaspc2)->PC2_FILIAL+(cAliaspc2)->PC2_NUMSEQ+(cAliaspc2)->PC2_ROTA+(cAliaspc2)->PC2_CODTAN ) 
	
		RECLOCK("PC2",.F.)
	        DBDELETE()
	    MSUNLOCK()
	    
	    lpc2     := .T.
	ELSE
	 
	   IF EMPTY(lpc2ne)
	   		lpc2ne := (cAliaspc2)->PC2_FILIAL+" - "+(cAliaspc2)->PC2_NUMSEQ
	   ELSE 
	        lpc2ne +=',' + (cAliaspc2)->PC2_FILIAL+" - "+(cAliaspc2)->PC2_NUMSEQ
	   ENDIF 	    
	
	ENDIF
	
	DbSelectArea(cAliaspc2)
	Dbskip()
						   
ENDDO
IF Select(cAliaspc2) > 0			
	DbSelectArea(cAliaspc2)
	DBGOTOP()
ENDIF
	

IF lpc0
   cMens:= "Registro Excluido com sucesso"
   cMens+= " Tabela - PC0"+chr(13)+chr(10)
   IF !EMPTY(lpc0ne)
   	   cMens+= "Registro não encontrado Filial-NUMSEQ: "+ lpc0ne+chr(13)+chr(10)
   ENDIF
ELSE
   cMens:= "Registro não encontrado PC0 - Filial-NUMSEQ: "+ iif(Empty(lpc0ne),MV_PAR01+" - NUMSEQ: "+MV_PAR02+' ATE '+MV_PAR03,lpc0ne)+chr(13)+chr(10)
	
ENDIF 

IF lpc1
   cMens+= "Registro Excluido com sucesso"
   cMens+= " Tabela - PC1"+chr(13)+chr(10)
   IF !EMPTY(lpc1ne)
   	   cMens+= "Registro não encontrado PC1 - Filial-NUMSEQ: "+ lpc1ne+chr(13)+chr(10)
   ENDIF
ELSE
   cMens+= "Registro não encontrado PC1 - Filial-NUMSEQ: "+ iif(Empty(lpc1ne),MV_PAR01+" - NUMSEQ: "+MV_PAR02+' ATE '+MV_PAR03,lpc1ne)+chr(13)+chr(10)
	
ENDIF 

IF lpc2
   cMens+= "Registro Excluido com sucesso"
   cMens+= " Tabela - PC2"+chr(13)+chr(10)
   IF !EMPTY(lpc2ne)
   	   cMens+= "Registro não encontrado PC2 - Filial-NUMSEQ: "+ lpc2ne+chr(13)+chr(10)
   ENDIF
ELSE
   cMens+= "Registro não encontrado PC2 - Filial-NUMSEQ: "+ iif(Empty(lpc2ne),MV_PAR01+" - NUMSEQ: "+MV_PAR02+' ATE '+MV_PAR03,lpc2ne)+chr(13)+chr(10)
	
ENDIF 


MsgAlert(cMens ,"Aviso" )

RETURN()



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±³Funcao    ³VALIDPERG³ Autor ³ ROBERTO R.MEZZALIRA   ³ Data ³ 21.11.16 ³±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±³Descricao ³ Verifica perguntas, incluindo-as caso nao existam         ³±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±³Uso       ³ QUATA                                                     ³±
±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 13/08/01 ==> Function ValidPerg
Static Function ValidPerg(cPerg)

Local sAlias := Alias()
Local aRegs := {}
Local i,j

aAdd(aRegs,{cPerg,"01","Filial  "           ,"","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","033","","",""})
aAdd(aRegs,{cPerg,"02","Numero Lcto de "    ,"","","mv_ch2","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Numero Lcto ate"    ,"","","mv_ch3","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

DbSelectArea("SX1")
DbSetOrder(1)

For i := 1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next

Return


/*
#include "protheus.ch"
User Function Sample( )
Local aGrupos
If ( __cUserId == '000000' )       // e usuario administrador.
Else      // Para verificar se faz parte do grupo de administradores 
           PswOrder(1)    
           If (  PswSeek(__cUserId, .T.) )        
               aGrupos := Pswret(1)           
                If ( Ascan(aUser[1][10],'000000') <> 0 )                   // O usuario corrente faz parte do grupo de administradores   
                EndIf     
           EndIfEndIfReturn
           
           */