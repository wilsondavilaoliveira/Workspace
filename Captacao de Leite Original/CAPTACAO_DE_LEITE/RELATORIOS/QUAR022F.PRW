#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "RPTDEF.CH" 
#INCLUDE "RWMAKE.CH"  
#INCLUDE "TOTVS.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "COLORS.CH"

#DEFINE GRID_COL  108
#DEFINE GRID_LIN  24
#DEFINE MARG_TOP  09
#DEFINE MARG_LEFT 09
#DEFINE PADDING 03 

/*/{Protheus.doc} QUAR022F
description
@type function
@version 
@author wilson
@since 12/05/2020
@return return_type, return_description
/*/

User Function QUAR022F () 
  
Local aImprim:= {}

If Pergunte("QUAR022F",.T.)

	RptStatus({|| RunReport(aImprim) },"Relatorio Bonificacoes Produtor")   

EndiF

Return 

/*/{Protheus.doc} RunReport ===================================================================================================================================================
description
@type function
@version 
@author Wilson Davila
@since 12/05/2020
@param aImprim, array, param_description
@return return_type, return_description
/*/
Static Function RunReport(aImprim)

local cRelName as char
local lAdjust as logical
local nPrintType as numeric
local oFont10 as object
local oPrinter as object
local cText as char
local nSize as numeric

cRelName   := "RELQUALIDADE"
lAdjust    		:= .F.
nPrintType 	:= 6

//FillRect ( < aCoords>, [ oBrush], [ cPixel] )
//{nTop,nLeft,nBottom,nRight}
//Ellipse ( < nLeft>, < nTop>, < nBottom>, < nRigth>, [ nColorIn], [ nColorOut], [ nLineType], [ cPixel] ) 
//oPrinter:Ellipse( 100, 010, 100, 100, CLR_BLACK, CLR_BLACK, 0, "02")
//{nTop,nLeft,nBottom,nRight}
//Say ( < nRow>, < nCol>, < cText>, [ oFont], [ nWidth], [ nClrText], [ nAngle] )

//FONTES USADAS
oFont25		:= TFont():New("ARIAL",10,25,,.T.,,,,,.F.,.F.) ///Fonte 10 Normal
oFont10N   := TFont():New("ARIAL NARROW",10,10,,.T.,,,,,.F.,.F.) ///Fonte 10 Normal
oFont10    	:= TFont():New("ARIAL NARROW",10,10,,.F.,,,,,.F.,.F.) ///Fonte 10 Normal
oFont7    	 := TFont():New("Tahoma",10,7,,.F.,,,,,.F.,.F.) ///Fonte 10 Normal
oFontRot 	:= TFont():New("Arial Narrow (Ocidental)",,14,,.F.,,,,.T.,.F.)  
oFontTxt 	:= TFont():New("Arial Narrow (Ocidental)",,16,,.T.,,,,.T.,.F.) 
oFontTx1 	:= TFont():New("Arial Narrow (Ocidental)",,12,,.T.,,,,.T.,.F.)
oFontTx2 	:= TFont():New("Arial Narrow (Ocidental)",,12,,.F.,,,,.T.,.F.)
oFontTx3 	:= TFont():New("Arial Narrow (Ocidental)",,09,,.F.,,,,.T.,.F.) 
 oFontTx4 	:= TFont():New("Arial Narrow (Ocidental)",,07,,.F.,,,,.T.,.F.)

oPrinter := FWMSPrinter():New(cRelName, nPrintType, lAdjust, "C:\SPOOL\", .T., /*lTReport*/ ,/* oPrintSetup */,/*cPrinter*/, .F. )
oPrinter:SetPortrait()
oPrinter:SetPaperSize(DMPAPER_A4)
oPrinter:setCopies(1)

oPrinter:StartPage() 

//====LOGO E TITULO
oPrinter:SayBitmap (025,010, "C:\HD\Arq Trabalho\NOVAMIX\PROJETO QUALIDADE DO LEITE\logo_quata.png" ,100,46) 
oPrinter:Say( 050,135,OemToAnsi("Resumo de An lises por Produtor - Ano 2019"),oFont25,,CLR_BLUE)

oPrinter:Box( 079, 009, 121, 581, "-1")
oPrinter:Box( 121, 009, 161, 581, "-1")

oBrush := TBrush():New( , CLR_WHITE )
oBrush1 := TBrush():New( , CLR_WHITE )

oPrinter:FillRect ( {080,010,120,580}, oBrush, "-2" )
oPrinter:FillRect ( {122,010,161,580}, oBrush1, "-2" )
oPrinter:Line( 133, 010, 133, 579,10, "-1")

//===============PRIMEIRA LINHA CABEC
oPrinter:Say( 095,015,OemToAnsi("Fornecedor:"),oFont10N,,CLR_BLACK)
oPrinter:Say( 095,070,OemToAnsi("130018-LISLEI GERALDA NOGUEIRA"),oFont10,,CLR_BLACK)

oPrinter:Say( 095,410,OemToAnsi("Total Litros 2020 . .: "),oFont10N,,CLR_BLACK)
oPrinter:Say( 095,530,OemToAnsi("5746"),oFont10,,CLR_BLACK)
//================= SEGUNDA LINHA CABEC
oPrinter:Say( 110,015,OemToAnsi("Linha. . .:"),oFont10N,,CLR_BLACK)
oPrinter:Say( 110,070,OemToAnsi("100013-TRANSPORTADORA VIEIRA ASSUNCAO"),oFont10,,CLR_BLACK)

oPrinter:Say( 110,410,OemToAnsi("Media Litros/dia 2020: "),oFont10N,,CLR_BLACK)
oPrinter:Say( 110,530,OemToAnsi("  63"),oFont10,,CLR_BLACK)

nLinIni := 161
nLinfin := 176
nCol := 11

For nMes := 1 to 12
	oPrinter:Box( nLinIni, 009, nLinfin, 581, "-1")
	nLinIni += 15
	nLinfin +=15
Next nMES

For a := 1 To 14
	oPrinter:Say( 130,nCol,OemToAnsi("PADROES=>"),oFont7,,CLR_BLUE )
		nCol += 41
Next a

nCol := 50
For nColuna := 1 to 13
	oPrinter:Line( 121, nCol, 341, nCol,10, "-1")
	nCol += 41
Next nColuna

oPrinter:EndPage()
oPrinter:Preview()

Return NIL

/*/{Protheus.doc} VALQA22A===================================================================================================================================
description
@type function
@version 
@author wilso
@since 15/05/2020
@return return_type, return_description
/*/
USER FUNCTION VALQA22A()                                                

	LOCAL LRET := .F.
	//IF(!VAZIO(),ExistCpo("PA7",MV_PAR02),.T.) .OR. VAZIO()      
	
	IF IIF(!EMPTY(MV_PAR02),ExistCpo("PA7",MV_PAR03),.T.) 
		LRET := .T.
	END IF
	
	IF EMPTY(MV_PAR02)
		 MV_PAR03 := 'ZZZZZZ'
	END IF


RETURN LRET

/*/{Protheus.doc} VALQA22B=============================================================================================================================================
description
@type function
@version 
@author wilso
@since 15/05/2020
@return return_type, return_description
/*/
USER FUNCTION VALQA22B()                                                

	LOCAL LRET := .F.

	IF IIF(!EMPTY(MV_PAR03),IIF(MV_PAR03=='ZZZZZZ',.T.,ExistCpo("PA7",MV_PAR03)),.F.) .OR. MV_PAR03 == 'ZZZZZZ'       
		LRET := .T.
	END IF

RETURN LRET


/*/{Protheus.doc} VALQA22C
description
@type function
@version 
@author wilso
@since 15/05/2020
@return return_type, return_description
/*/
USER FUNCTION VALQA22C()                                                

	LOCAL LRET := .F.

	IF IIF(!EMPTY(MV_PAR04),ExistCpo("LBB",MV_PAR04),.T.) 
		LRET := .T.
	END IF
	
	IF EMPTY(MV_PAR04)
		 MV_PAR05 := 'ZZZZZZ'
	END IF

RETURN LRET

/*/{Protheus.doc} VALQA22D
description
@type function
@version 
@author wilso
@since 15/05/2020
@return return_type, return_description
/*/
USER FUNCTION VALQA22D()                                                

	LOCAL LRET := .F.

	IF IIF(!EMPTY(MV_PAR05),IIF(MV_PAR05=='ZZZZZZ',.T.,ExistCpo("LBB",MV_PAR05)),.F.) .OR. MV_PAR05 == 'ZZZZZZ'      
		LRET := .T.
	END IF

RETURN LRET



IF(!VAZIO(),ExistCpo("LBB",MV_PAR04),.T.) .OR. VAZIO()      