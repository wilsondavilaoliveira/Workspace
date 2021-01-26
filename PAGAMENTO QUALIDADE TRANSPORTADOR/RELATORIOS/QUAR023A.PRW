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

/*/{Protheus.doc} QUAR023A
description
@type function
@version
@author wilson
@since 25/11/2020
@return return_type, return_description
/*/

User Function QUAR023A ()

Local aImprim:= {}

If Pergunte("QUAR023A",.T.)
    Processa({|| RunReport(aImprim)},"Imprimindo...","Extrato Transportador. . . ",.F.)
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
Local cAlias := GetNextAlias()
Local cAlias1 := GetNextAlias()

cRelName   := "RELTRANSP"
lAdjust    		:= .F.
nPrintType 	:= 6


//FillRect ( < aCoords>, [ oBrush], [ cPixel] )
//{nTop,nLeft,nBottom,nRight}
//Ellipse ( < nLeft>, < nTop>, < nBottom>, < nRigth>, [ nColorIn], [ nColorOut], [ nLineType], [ cPixel] )
//oPrinter:Ellipse( 100, 010, 100, 100, CLR_BLACK, CLR_BLACK, 0, "02")
//{nTop,nLeft,nBottom,nRight}
//Say ( < nRow>, < nCol>, < cText>, [ oFont], [ nWidth], [ nClrText], [ nAngle] )

//FONTES USADAS
    /*
    Beginsql Alias cAlias1

	    %NOPARSER%

        SELECT LJX_CODBON,LJX_PADRAO,LJX_DESRED FROM LJX010 WHERE LJX_FILIAL=%exp:cFilAnt% AND LJX_RELATO='S' ORDER BY LJX_ORDEM

    EndSql


	Beginsql Alias cAlias

    	%NOPARSER%

        SELECT MONTH(LJZ_DATCLQ) AS MES,LJZ_CODPRO,LBB_NOMFOR,LJX_PADRAO,LJX_METCLA,LBB_CODLAB,LBB_CODFOR,A2_INSCR,LTRIM(RTRIM(LBB_MUN))+'-'+LBB_EST AS CIDADE,A2_CGC,
        LTRIM(RTRIM(LBB_END)) AS LBB_END,LJX_CODBON,LJX_DESRED,ROUND(LJZ_QTDMES,2) AS LJZ_QTDMES,ROUND(LJZ_QTDLEI,2) AS LJZ_QTDLEI,
        ISNULL((SELECT SUM(PC1_QTDLIT)
        FROM PC1010 PC1 (NOLOCK)
        INNER JOIN PC0010 PC0 (NOLOCK) ON PC0_TPENTR='1' AND PC0_FILIAL=PC1_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1_CODPRO=LJZ_CODPRO
        AND MONTH(PC0_DTENTR) = MONTH(LJZ_DATCLQ) AND YEAR(PC0_DTENTR)=YEAR(LJZ_DATCLQ) AND PC0.D_E_L_E_T_=''
        AND PC1_FILIAL=%EXP:cFilAnt% AND PC1.D_E_L_E_T_=''
        ),0) AS PC1_QTDLIT,
        ISNULL((SELECT SUM(PC1_QTDLIT)
        FROM PC1010 PC1 (NOLOCK)
        INNER JOIN PC0010 PC0 (NOLOCK) ON PC0_TPENTR='1' AND PC0_FILIAL=PC1_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1_CODPRO=LJZ_CODPRO
        AND MONTH(PC0_DTENTR) = MONTH(LJZ_DATCLQ) AND YEAR(PC0_DTENTR)=YEAR(LJZ_DATCLQ) AND PC0.D_E_L_E_T_=''
        AND PC1_FILIAL=%EXP:cFilAnt% AND PC1.D_E_L_E_T_=''
        ),0)/30 AS MED_LIT
        FROM LJZ010 LJZ (NOLOCK)
        INNER JOIN LJX010 LJX (NOLOCK) ON LJX_FILIAL=LJZ_FILIAL AND LJX_CODBON=LJZ_CODBON AND LJX_RELATO='S' AND LJX.D_E_L_E_T_=''
        INNER JOIN LBB010 LBB (NOLOCK) ON LBB_FILIAL=LJZ_FILIAL AND LJZ_CODPRO=LBB_CODPRO AND LBB.D_E_L_E_T_=''
        INNER JOIN SA2010 SA2 (NOLOCK) ON LBB_CODFOR=A2_COD AND LBB_LOJA=A2_LOJA AND SA2.D_E_L_E_T_=''
        AND LBB_LINHA BETWEEN %EXP:MV_PAR02% AND %EXP:MV_PAR03%
        WHERE
        LJZ.D_E_L_E_T_='' AND LJZ_CODPRO BETWEEN %EXP:MV_PAR04% AND %EXP:MV_PAR05% AND
        YEAR(LJZ_DATCLQ)=%exp:SubStr(MV_PAR01,3,4)% AND LJZ_FILIAL=%EXP:cFilAnt%
        AND LJZ_FILIAL+LJZ_CODPRO IN (
        SELECT DISTINCT PC1_FILIAL+PC1_CODPRO
        FROM PC1010 PC1 (NOLOCK)
        INNER JOIN PC0010 PC0 (NOLOCK) ON PC0_TPENTR='1' AND PC0_FILIAL=PC1_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1_CODPRO=LJZ_CODPRO
        AND MONTH(PC0_DTENTR) = %exp:Val(SubStr(MV_PAR01,1,2))% AND YEAR(PC0_DTENTR)=YEAR(LJZ_DATCLQ) AND PC0.D_E_L_E_T_=''
        WHERE PC1_FILIAL=%EXP:cFilAnt% AND PC1.D_E_L_E_T_='')
        ORDER BY LJZ_CODPRO,LJZ_DATCLQ,LJX_ORDEM

    EndSql
    */

oFont25	 := TFont():New("ARIAL",10,25,,.T.,,,,,.F.,.F.) ///Fonte 10 Normal
oFont20a := TFont():New("ARIAL",10,15,,.T.,,,,,.F.,.F.) ///Fonte 10 Normal

oFont10N := TFont():New("ARIAL NARROW",10,10,,.T.,,,,,.F.,.F.) ///Fonte 10 Normal
oFont10  := TFont():New("ARIAL NARROW",10,10,,.F.,,,,,.F.,.F.) ///Fonte 10 Normal
oFont7   := TFont():New("Tahoma",10,7,,.T.,,,,,.F.,.F.) ///Fonte 10 Normal
oFont7a  := TFont():New("Tahoma",10,10,,.T.,,,,,.F.,.F.) ///Fonte 10 Normal
oFont7C  := TFont():New("Courrier New Bold",10,9,,.T.,,,,,.F.,.F.) ///Fonte 10 Normal
oFont8C  := TFont():New("Courrier New Bold",10,10,,.T.,,,,,.F.,.F.) ///Fonte 10 Normal

oFontRot14 	:= TFont():New("Arial Narrow (Ocidental)",,14,,.F.,,,,.T.,.F.)
oFontTxt16 	:= TFont():New("Arial Narrow (Ocidental)",,16,,.T.,,,,.T.,.F.)
oFontTx1 	:= TFont():New("Arial Narrow (Ocidental)",,12,,.T.,,,,.T.,.F.)
oFontTx2 	:= TFont():New("Arial Narrow (Ocidental)",,14,,.T.,,,,.T.,.F.)
oFontTx3 	:= TFont():New("Arial Narrow (Ocidental)",,09,,.F.,,,,.T.,.F.)
oFontTx4 	:= TFont():New("Arial Narrow (Ocidental)",,07,,.F.,,,,.T.,.F.)
oFontTx4N 	:= TFont():New("Agency FB",10,7.8,,.T.,,,,.T.,.F.)
oFontTx5 	:= TFont():New("Arial Narrow (Ocidental)",,07,,.T.,,,,.T.,.F.)
oFontAr6 	:= TFont():New("Arial Narrow (Ocidental)",,07,,.F.,,,,.T.,.F.)
oFontAr6n 	:= TFont():New("Tw Cen MT Condensed",10,6,,.T.,,,,.T.,.F.)

oPrinter := FWMSPrinter():New(cRelName, nPrintType, lAdjust, "C:\SPOOL\", .T., /*lTReport*/ ,/* oPrintSetup */,/*cPrinter*/, .F. )
oPrinter:SetPortrait()
oPrinter:SetPaperSize(DMPAPER_A4)
oPrinter:setCopies(1)
oPrinter:cPathPDF := "c:\spool\"

ProcRegua(3000)

//While (cAlias)->( !Eof() )
//    _cCodFor := (cAlias)->(LBB_CODFOR)
//    _cCodPro := (cAlias)->(LJZ_CODPRO)
    oPrinter:StartPage()

    //====LOGO E TITULO ==================================================================================================
    oPrinter:SayBitmap (002,010, "\logo_quata.png" ,80,37)
    oPrinter:Say( 030,155,OemToAnsi("RELATORIO DE PAGAMENTO DE TRANSPORTE DE LEITE - " + TransForm(MV_PAR01,'@R 99/9999')),oFont20a,,CLR_BLUE)
    //====================================================================================================================
    //100,46
    oPrinter:Box( 079-35, 009, 121-30, 581, "-1")
    //oPrinter:Box( 121-35, 009, 138-25, 581, "-1")


    //oBrush := TBrush():New( , CLR_WHITE )
    //oBrush1 := TBrush():New( , CLR_WHITE )

    //oPrinter:FillRect ( {080-35,010,120-35,580}, oBrush, "-2" )
    //oPrinter:FillRect ( {122-35,010,161-35,580}, oBrush1, "-2" )
    //oPrinter:Line( 133-35, 010, 133-35, 579,10, "-1")

    //===============PRIMEIRA LINHA CABEC =============================================================================
    oPrinter:Say( 090-35,015,OemToAnsi("Linha/Rota:000007"),oFont10N,,CLR_BLACK)
    //oPrinter:Say( 090-35,070,OemToAnsi((cAlias)->(LBB_CODFOR)+"-"+(cAlias)->(LJZ_CODPRO)+"-"+(cAlias)->(LBB_NOMFOR)),oFont10,,CLR_BLACK)

    oPrinter:Say( 090-35,365,OemToAnsi("Municipio.: VAZANTE - MG"),oFont10N,,CLR_BLACK)

    //================= SEGUNDA LINHA CABEC
    oPrinter:Say( 102-35,015,OemToAnsi("Transportadora:022521-0001-STANES TRANSPORTES LTDA"),oFont10N,,CLR_BLACK)
    //oPrinter:Say( 102-35,070,OemToAnsi((cAlias)->(LBB_END)),oFont10,,CLR_BLACK)

    oPrinter:Say( 102-35,365,OemToAnsi("I.Estadual: 001148665.00-23"),oFont10N,,CLR_BLACK)

    //TERCEIRA LINHA CABEC
    oPrinter:Say( 114-35,015,OemToAnsi("Endereço: AV. PRES. TANCREDO DE ALMEIDA NEVES, 1600"),oFont10N,,CLR_BLACK)
    //oPrinter:Say( 114-35,070,OemToAnsi((cAlias)->(CIDADE)),oFont10,,CLR_BLACK)

    oPrinter:Say( 114-35,365,OemToAnsi("Cpf/Cnpj..: 01.570.012/0001-14"),oFont10N,,CLR_BLACK)


    //================================================================================================================

    nLinIni := 161-35-13
    nLinfin := 171-35-5
    nCol := 11
    //BOX MESES=========================================================================================================


    For nMes := 1 to 3
    	oPrinter:Box( nLinIni, 009, nLinfin, 581, "-1")
    	nLinIni += 18
    	nLinfin += 18
    Next nMes

    oPrinter:Line( 161-35-13, 80, nLinfin-18, 80,10, "-1")
    oPrinter:Line( 161-35-13, 260, nLinfin-18,260,10, "-1")
    oPrinter:Line( 161-35-13, 340, nLinfin-18, 340,10, "-1")
    oPrinter:Line( 161-35-13, 420, nLinfin-18, 420,10, "-1")
    oPrinter:Line( 161-35-13, 500, nLinfin-18, 500,10, "-1")

    oPrinter:Say( 161-35,011,OemToAnsi(" TOPICO"),oFont10N,,CLR_BLACK)
    oPrinter:Say( 161-35,081,OemToAnsi(" DESCRIÇÃO"),oFont10N,,CLR_BLACK)
    oPrinter:Say( 161-35,261,OemToAnsi(" REALIZADO"),oFont10N,,CLR_BLACK)
    oPrinter:Say( 161-35,341,OemToAnsi(" VALOR UNIT"),oFont10N,,CLR_BLACK)
    oPrinter:Say( 161-35,421,OemToAnsi(" TOT CREDITOS"),oFont10N,,CLR_BLACK)
    oPrinter:Say( 161-35,501,OemToAnsi(" TOT DEBITO"),oFont10N,,CLR_BLACK)

    oPrinter:Say( 161-35+18,011,OemToAnsi(" KM RODADOS"),oFont10,,CLR_BLACK)
    oPrinter:Say( 161-35+18,081,OemToAnsi("             "),oFont10,,CLR_BLACK)
    oPrinter:Say( 161-35+18,261,OemToAnsi("       6.500,00"),oFont10,,CLR_BLACK)
    oPrinter:Say( 161-35+18,341,OemToAnsi("           3,35"),oFont10,,CLR_BLACK)
    oPrinter:Say( 161-35+18,421,OemToAnsi("   R$ 21.999,00"),oFont10,,CLR_BLACK)
    oPrinter:Say( 161-35+18,501,OemToAnsi(""),oFont10,,CLR_BLACK)


    oPrinter:Say( 161-35+18+18,011,OemToAnsi(" SOCORRO"),oFont10,,CLR_BLACK)
    oPrinter:Say( 161-35+18+18,081,OemToAnsi("             "),oFont10,,CLR_BLACK)
    oPrinter:Say( 161-35+18+18,261,OemToAnsi("         500,00"),oFont10,,CLR_BLACK)
    oPrinter:Say( 161-35+18+18,341,OemToAnsi("           2,35"),oFont10,,CLR_BLACK)
    oPrinter:Say( 161-35+18+18,421,OemToAnsi("      R$ 999,00"),oFont10,,CLR_BLACK)
    oPrinter:Say( 161-35+18+18,501,OemToAnsi(""),oFont10,,CLR_BLACK)


    nLinIni += 20
    nLinfin += 20
    nLi := nLinIni
    For nMes := 1 to 9
    	oPrinter:Box( nLinIni, 009, nLinfin, 581, "-1")
    	nLinIni += 18
    	nLinfin +=18
    Next nMes

    oPrinter:Line( nLi, 80, nLinfin-18, 80,10, "-1")
    oPrinter:Line( nLi, 260, nLinfin-18,260,10, "-1")
    oPrinter:Line( nLi, 340, nLinfin-18, 340,10, "-1")
    oPrinter:Line( nLi, 420, nLinfin-18, 420,10, "-1")
    oPrinter:Line( nLi, 500, nLinfin-18, 500,10, "-1")


    oPrinter:Say( nLi-3,011,OemToAnsi("PAGAMENTO POR QUALIDADE DE SERVIÇOS PRESTADOS"),oFont10N,,CLR_BLACK)
    nLi +=15
    oPrinter:Say( nLi,011,OemToAnsi("ADMINISTRATIVO"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,081,OemToAnsi(" ERROS LEITURA HODÔMETRO"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,261,OemToAnsi("          "),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,341,OemToAnsi("          0,010"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,421,OemToAnsi("          75,00"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,501,OemToAnsi(""),oFont10,,CLR_BLACK)

    nLi +=15
    oPrinter:Say( nLi,011,OemToAnsi("QUALIDADE"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,081,OemToAnsi(" MANGUEIRAS"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,261,OemToAnsi("          "),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,341,OemToAnsi("          0,020"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,421,OemToAnsi("          85,00"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,501,OemToAnsi(""),oFont10,,CLR_BLACK)

     nLi +=15
    oPrinter:Say( nLi,011,OemToAnsi("BONI EXTRA"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,081,OemToAnsi(" XXXXXXXXXXXXXXXXXXXXXXXX"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,261,OemToAnsi("          "),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,341,OemToAnsi("          "),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,421,OemToAnsi("    R$ 1.000,00"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,501,OemToAnsi(""),oFont10,,CLR_BLACK)


    nLinIni += 15
    nLinfin +=15
    nLi := nLinIni
    For nMes := 1 to 3
    	oPrinter:Box( nLinIni, 009, nLinfin, 581, "-1")
    	nLinIni += 18
    	nLinfin +=18
    Next nMes

    //  oPrinter:Line( nLi, 80, nLinfin-18, 80,10, "-1")
    //oPrinter:Line( nLi, 260, nLinfin-18,260,10, "-1")
    //oPrinter:Line( nLi, 340, nLinfin-18, 340,10, "-1")
    oPrinter:Line( nLi, 420, nLinfin-18, 420,10, "-1")
    oPrinter:Line( nLi, 500, nLinfin-18, 500,10, "-1")

    nLi +=15
    oPrinter:Say( nLi,011,OemToAnsi("SUB-TOTAL DE CREDITOS...................................................."),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,081,OemToAnsi(" ERROS LEITURA HODÔMETRO"),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,261,OemToAnsi("          "),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,341,OemToAnsi("          0,010"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,421,OemToAnsi("    R$ 26.000,00"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,501,OemToAnsi(""),oFont10,,CLR_BLACK)

    nLi +=15
    oPrinter:Say( nLi,011,OemToAnsi("CREDITO IMPOSTOS........................................................"),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,081,OemToAnsi(" ERROS LEITURA HODÔMETRO"),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,261,OemToAnsi("          "),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,341,OemToAnsi("          0,010"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,421,OemToAnsi("     R$ 6.000,00"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,501,OemToAnsi(""),oFont10,,CLR_BLACK)

    nLi +=15
    oPrinter:Say( nLi,011,OemToAnsi("TOTAL CREDITOS........................................................"),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,081,OemToAnsi(" ERROS LEITURA HODÔMETRO"),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,261,OemToAnsi("          "),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,341,OemToAnsi("          0,010"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,421,OemToAnsi("    R$ 29.000,00"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,501,OemToAnsi(""),oFont10,,CLR_BLACK)


    nLinIni += 15
    nLinfin +=15
    nLi  := nLinIni
    For nMes := 1 to 3
    	oPrinter:Box( nLinIni, 009, nLinfin, 581, "-1")
    	nLinIni += 18
    	nLinfin +=18
    Next nMes

      oPrinter:Line( nLi, 80, nLinfin-18, 80,10, "-1")
    //oPrinter:Line( nLi, 260, nLinfin-18,260,10, "-1")
    //oPrinter:Line( nLi, 340, nLinfin-18, 340,10, "-1")
    //oPrinter:Line( nLi, 420, nLinfin-18, 420,10, "-1")
    oPrinter:Line( nLi, 500, nLinfin-18, 500,10, "-1")

    nLi +=15
    oPrinter:Say( nLi,011,OemToAnsi("DEBITO"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,081,OemToAnsi(" NDF................................................"),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,261,OemToAnsi("          "),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,341,OemToAnsi("          0,010"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,501,OemToAnsi("    R$ 15.000,00"),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,501,OemToAnsi(""),oFont10,,CLR_BLACK)

    nLi +=15
    oPrinter:Say( nLi,011,OemToAnsi("DEBITO"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,081,OemToAnsi(" XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,261,OemToAnsi("          "),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,341,OemToAnsi("          0,010"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,501,OemToAnsi("     R$ 1.000,00"),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,501,OemToAnsi(""),oFont10,,CLR_BLACK)

    nLi +=15
    oPrinter:Say( nLi,011,OemToAnsi("TOTAL DEBITOS"),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,081,OemToAnsi(" ERROS LEITURA HODÔMETRO"),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,261,OemToAnsi("          "),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,341,OemToAnsi("          0,010"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,501,OemToAnsi("    R$ 16.000,00"),oFont10,,CLR_BLACK)
    //oPrinter:Say( nLi,501,OemToAnsi(""),oFont10,,CLR_BLACK)

    oPrinter:Say( nLi+30,011,OemToAnsi("SALDO TOTAL A RECEBER........................................................................................R$ 13.311,75 "),oFont10N,,CLR_BLACK)
//SALDO TOTAL A RECEBER...........................................................................................................				 R$ 13.311,75




    /*
    oBrush2 := TBrush():New( , CLR_LIGHTGRAY )
    oBrush3 := TBrush():New( , CLR_HCYAN  )

    oPrinter:FillRect ( {nLinIni-18,010,nLinfin-21,580}, oBrush2, "-2" )

    oPrinter:FillRect ( {nLinIni-8,010,nLinfin-11,580}, oBrush3, "-2" )

    //==================================================================================================================

        //DESCRICAO DA BONIFICACAO E PADROES DE MEDIDA==================================================================
        oPrinter:Say( 130-35,nCol,OemToAnsi(padc("PADROES->",10)),oFont7,,CLR_BLUE )
        oPrinter:Say( 150-35-7,nCol,OemToAnsi(padc("M E S",10)),oFont7,,CLR_BLUE )

        nCol += 41
        (cAlias1)->( dbgotop())
        While (cAlias1)->( !Eof() )
            If (cAlias1)->(LJX_CODBON) <> '000001' .AND. (cAlias1)->(LJX_CODBON) <> '000005'
                oPrinter:Say( 130-35,nCol,OemToAnsi(PADC(AllTrim((cAlias1)->(LJX_PADRAO)),10)),oFont7,,CLR_BLUE )
                oPrinter:Say( 150-35-7,nCol,OemToAnsi(PADC(AllTrim((cAlias1)->(LJX_DESRED)),10)),oFont7,,CLR_BLUE )
                nCol += 41

                (cAlias1)->( dbSkip() )
            ElseIf (cAlias1)->(LJX_CODBON) == '000005'
                oPrinter:Say( 130-35,nCol,OemToAnsi(PADC(AllTrim((cAlias1)->(LJX_PADRAO)),10)),oFont7,,CLR_BLUE )
                oPrinter:Say( 130-35,nCol+41,OemToAnsi(PADC(AllTrim((cAlias1)->(LJX_PADRAO)),10)),oFont7,,CLR_BLUE )
                oPrinter:Say( 150-35-7,nCol,OemToAnsi(PADC(AllTrim((cAlias1)->(LJX_DESRED)),10)),oFont7,,CLR_BLUE )
                nCol += 41
                (cAlias1)->( dbSkip() )
            Else
                (cAlias1)->( dbSkip() )
            EndIf
        EndDo

        nCol := 339

        oPrinter:Say( 145-35-5,nCol,OemToAnsi(" MED.GEO"),oFont7,,CLR_BLUE )
        oPrinter:Say( 152-35-5,nCol,OemToAnsi("  C B T "),oFont7,,CLR_BLUE )
        nCol += 41

    	oPrinter:Say( 150-35,nCol,OemToAnsi(" "),oFont7,,CLR_BLUE )
    	nCol += 41
    	oPrinter:Say( 150-35,nCol,OemToAnsi(" "),oFont7,,CLR_BLUE )
    	nCol += 41

    	oPrinter:Say( 150-35-8,nCol,OemToAnsi(PADC("ANTIBIO.",10)),oFont7,,CLR_BLUE )
        nCol += 41
    	oPrinter:Say( 145-35-5,nCol,OemToAnsi(PADC("VOLUME",10)),oFont7,,CLR_BLUE )
        oPrinter:Say( 152-35-5,nCol,OemToAnsi(PADC("LITROS",10)),oFont7,,CLR_BLUE )
        nCol += 41

        oPrinter:Say( 145-35-5,nCol,OemToAnsi(PADC("MEDIA",10)),oFont7,,CLR_BLUE )
        oPrinter:Say( 152-35-5,nCol,OemToAnsi(PADC("LT/DIA",10)),oFont7,,CLR_BLUE )
        //oPrinter:Say( 160-35-38,nCol,OemToAnsi(PADC("DIA",10)),oFont7,,CLR_BLUE )
        //===========================================================================================================

    ///////NUMEROS
    nCol := 11+41
    nLin := 158-35-12
    nVal := 1.1

        cMes    := (cAlias)->(MES)
        cProd   := (cAlias)->(LJZ_CODPRO)

        nToT1   := 0
        nToT1x  := 0
        nToT2   := 0
        nToT2x  := 0
        nToT3   := 0
        nToT3x  := 0
        nToT4   := 0
        nToT4x  := 0
        nToT5   := 0
        nToT5x  := 0
        nToT6   := 0
        nToT6x  := 0
        nToT7   := 0
        nToT7x  := 0
        nToT8   := 0
        nToT9   := 0
        nToT10  := 0
        nNumCol := 1
        nCor    := CLR_BLACK
        nCor1   := CLR_BLACK
        cPadrao1 := ''
        cPadrao2 := ''
        cPadrao3 := ''
        cPadrao4 := ''
        cPadrao5 := ''
        cPadrao6 := ''
        cPadrao7 := ''
        nMesMed  := 1

        IncProc("Imprimindo Produtor > " + AllTrim((cAlias)->(LJZ_CODPRO))+"-"+Alltrim((cAlias)->(LBB_NOMFOR)))

        While (cAlias)->( !Eof() ) .AND. cProd   == (cAlias)->(LJZ_CODPRO)

            If nNumCol == 9
                nNumCol := 1
            EndIf

            If nNumCol == 1
                nTot1    += (cAlias)->(LJZ_QTDMES)
                cPadrao1 := (cAlias)->(LJX_PADRAO)
                If (cAlias)->(MES) == Val(SubStr(MV_PAR01,1,2))
                    nTot1x   := IIF((cAlias)->(LJX_METCLA)=='1',(cAlias)->(LJZ_QTDMES),(cAlias)->(LJZ_QTDLEI))
                EndIf
            ElseIf nNumCol == 2
                nTot2 += (cAlias)->(LJZ_QTDMES)
                cPadrao2 := (cAlias)->(LJX_PADRAO)
                If (cAlias)->(MES) == Val(SubStr(MV_PAR01,1,2))
                    nTot2x   := IIF((cAlias)->(LJX_METCLA)=='1',(cAlias)->(LJZ_QTDMES),(cAlias)->(LJZ_QTDLEI))
                EndIf
            ElseIf nNumCol == 3
                nTot3 += (cAlias)->(LJZ_QTDMES)
                cPadrao3 := (cAlias)->(LJX_PADRAO)
                If (cAlias)->(MES) == Val(SubStr(MV_PAR01,1,2))
                    nTot3x   := IIF((cAlias)->(LJX_METCLA)=='1',(cAlias)->(LJZ_QTDMES),(cAlias)->(LJZ_QTDLEI))
                EndIf
            ElseIf nNumCol == 4
                nTot4 += (cAlias)->(LJZ_QTDMES)
                cPadrao4 := (cAlias)->(LJX_PADRAO)
                If (cAlias)->(MES) == Val(SubStr(MV_PAR01,1,2))
                    nTot4x   := IIF((cAlias)->(LJX_METCLA)=='1',(cAlias)->(LJZ_QTDMES),(cAlias)->(LJZ_QTDLEI))
                EndIf
            ElseIf nNumCol == 5
                nTot5 += (cAlias)->(LJZ_QTDMES)
                cPadrao5 := (cAlias)->(LJX_PADRAO)
                If (cAlias)->(MES) == Val(SubStr(MV_PAR01,1,2))
                    nTot5x   := IIF((cAlias)->(LJX_METCLA)=='1',(cAlias)->(LJZ_QTDMES),(cAlias)->(LJZ_QTDLEI))
                EndIf
            ElseIf nNumCol == 6
                nTot6 += (cAlias)->(LJZ_QTDMES)
                cPadrao6 := (cAlias)->(LJX_PADRAO)
                If (cAlias)->(MES) == Val(SubStr(MV_PAR01,1,2))
                    nTot6x   := IIF((cAlias)->(LJX_METCLA)=='1',(cAlias)->(LJZ_QTDMES),(cAlias)->(LJZ_QTDLEI))
                EndIf
            ElseIf nNumCol == 7
                nTot7 += (cAlias)->(LJZ_QTDMES)
                cPadrao7 := (cAlias)->(LJX_PADRAO)
                If (cAlias)->(MES) == Val(SubStr(MV_PAR01,1,2))
                    nTot7x   := IIF((cAlias)->(LJX_METCLA)=='1',(cAlias)->(LJZ_QTDMES),(cAlias)->(LJZ_QTDLEI))
                EndIf
            EndIf

            nNumCol ++

            If cMes == (cAlias)->(MES)
                If (cAlias)->(LJX_CODBON) <> '000001' .and. (cAlias)->(LJX_CODBON) <> '000005'

                    If &(cValToChar((cAlias)->(LJZ_QTDMES))+(cAlias)->(LJX_PADRAO))
                        nCor := CLR_GREEN
                    Else
                        nCor := CLR_HRED
                    EndIf

                    If (cAlias)->(LJX_CODBON) == '000006'
                        oPrinter:Say( nLin+((cAlias)->(MES)*10),nCol-12,PADL(AllTrim(TransForm(Round((cAlias)->(LJZ_QTDMES),0),"@E 9999")),10),oFont7C,,nCor )
                    Else
                        oPrinter:Say( nLin+((cAlias)->(MES)*10),nCol,PADC(AllTrim(TransForm(Round((cAlias)->(LJZ_QTDMES),1),"@E 99.9")),10),oFont7C,,nCor )
                    EndIf

                    (cAlias)->(dbskip())
                    nCol += 41

                 ElseiF (cAlias)->(LJX_CODBON) == '000005'

                    If &(cValToChar((cAlias)->(LJZ_QTDMES))+(cAlias)->(LJX_PADRAO))
                        nCor := CLR_GREEN
                    Else
                        nCor := CLR_HRED
                    EndIf

                    If &(cValToChar((cAlias)->(LJZ_QTDLEI))+(cAlias)->(LJX_PADRAO))
                        nCor1 := CLR_GREEN
                    Else
                        nCor1 := CLR_HRED
                    EndIf


                    oPrinter:Say( nLin+((cAlias)->(MES)*10),nCol,PADL(AllTrim(Transform(Round((cAlias)->(LJZ_QTDMES),0),"@E 9999")),6),oFont7C,,nCor )
                    oPrinter:Say( nLin+((cAlias)->(MES)*10),nCol+45,PADL(AllTrim(Transform(Round((cAlias)->(LJZ_QTDLEI),0),"@E 9999")),5),oFont7C,,nCor1 )

                    nCol += 41
                    nTot8 += (cAlias)->(LJZ_QTDLEI)
                    nTot9 +=  (cAlias)->(PC1_QTDLIT)
                    nTot10 +=  (cAlias)->(PC1_QTDLIT)
                    (cAlias)->(dbskip())

                Else
                    nCol += 123

                    If (cAlias)->(LJZ_QTDMES)==1
                        nCor := CLR_GREEN
                    Else
                        nCor := CLR_HRED
                    EndIf

                    oPrinter:Say( nLin+((cAlias)->(MES)*10),nCol,        PADC(IIF((cAlias)->(LJZ_QTDMES)==1,'NEG','POS'),10),oFont7C,,nCor )
                    oPrinter:Say( nLin+((cAlias)->(MES)*10),nCol+41,     PADC(Transform((cAlias)->(PC1_QTDLIT),"@E 999,999"),10),oFont7C,,CLR_BLACK )
                    oPrinter:Say( nLin+((cAlias)->(MES)*10),nCol+41+41,  PADC(TransForm(Round((cAlias)->(PC1_QTDLIT)/30,0),"@E 999,999"),10),oFont7C,,CLR_BLACK )
                    (cAlias)->(dbskip())
                    nCol += 41
                EndIf
            Else
               nMesMed  += 1
               nCol := 11+41
               cMes := (cAlias)->(MES)
               //nLin += 15
                    If &(cValToChar((cAlias)->(LJZ_QTDMES))+(cAlias)->(LJX_PADRAO))
                        nCor := CLR_GREEN
                    Else
                        nCor := CLR_HRED
                    EndIf

               oPrinter:Say( nLin+((cAlias)->(MES)*10),nCol,PADC(AllTrim(Transform(Round((cAlias)->(LJZ_QTDMES),1),"@E 99.9")),10),oFont7C,,nCor )
               nCol += 41
            (cAlias)->(dbskip())
            EndIf

        EndDo

        oPrinter:Say( 090-35,540,OemToAnsi(PADC(Transform(nTot9,"@E 999,999"),10)),oFont10,,CLR_BLACK)
        oPrinter:Say( 102-35,540,OemToAnsi(PADC(Transform(Round(nTot10/(nMesMed*30),0),"@E 99,999"),10)),oFont10,,CLR_BLACK)

        nCol := 11+41
        nLin := 170+100+18-35-12
        //TOTAIS ANUAL
        For x := 1 to 13
            if x == 1
                If &(cValToChar(Round(nToT1/nMesMed,1))+cPadrao1)
                    nCor := CLR_GREEN
                Else
                    nCor := CLR_HRED
                EndIf
                oPrinter:Say( nLin,nCol,PADC(TransForm(Round(nToT1/nMesMed,1),"@E 99.9"),10),oFont8C,,nCor )
                nCol += 41
            ElseIf x == 2
                If &(cValToChar(Round(nToT2/nMesMed,2))+cPadrao2)
                    nCor := CLR_GREEN
                Else
                    nCor := CLR_HRED
                EndIf

                oPrinter:Say( nLin,nCol,PADC(TransForm(Round(nToT2/nMesMed,1),"@E 99.9"),10),oFont8C,,nCor )
                nCol += 41
            ElseIf x == 3
                If &(cValToChar(Round(nToT3/nMesMed,1))+cPadrao3)
                    nCor := CLR_GREEN
                Else
                    nCor := CLR_HRED
                EndIf

                oPrinter:Say( nLin,nCol,PADC(TransForm(Round(nToT3/nMesMed,1),"@E 99.9"),10),oFont8C,,nCor )
                nCol += 41
            ElseIf x == 4
                If &(cValToChar(Round(nToT4/nMesMed,1))+cPadrao4)
                    nCor := CLR_GREEN
                Else
                    nCor := CLR_HRED
                EndIf

                oPrinter:Say( nLin,nCol,PADC(TransForm(Round(nToT4/nMesMed,1),"@E 99.9" ),10),oFont8C,,nCor )
                nCol += 41
            ElseIf x == 5
                If &(cValToChar(Round(nToT5/nMesMed,1))+cPadrao5)
                    nCor := CLR_GREEN
                Else
                    nCor := CLR_HRED
                EndIf

                oPrinter:Say( nLin,nCol,PADC(TransForm(Round(nToT5/nMesMed,1),"@E 99.9"),10),oFont8C,,nCor )
                nCol += 41
            ElseIf x == 6
                If &(cValToChar(Round(nToT6/nMesMed,1))+cPadrao6)
                    nCor := CLR_GREEN
                Else
                    nCor := CLR_HRED
                EndIf

                oPrinter:Say( nLin,nCol,PADC(TransForm(Round(nToT6/nMesMed,0),"@E 9999"),10),oFont8C,,nCor )
                nCol += 41
            ElseIf x == 7
                If &(cValToChar(Round(nToT7/nMesMed,2))+cPadrao7)
                    nCor := CLR_GREEN
                Else
                    nCor := CLR_HRED
                EndIf

                oPrinter:Say( nLin,nCol,PADC(TransForm(Round(nToT7/nMesMed,0),"@E 9999"),10),oFont8C,,nCor )
                nCol += 41
            ElseIf x == 8
                If &(cValToChar(Round(nToT8/nMesMed,2))+cPadrao7)
                    nCor := CLR_GREEN
                Else
                    nCor := CLR_HRED
                EndIf

                oPrinter:Say( nLin,nCol,PADC(TransForm(Round(nToT8/nMesMed,0),"@E 9999"),10),oFont8C,,nCor )
                nCol += 41
            ElseIf x == 9
                nCol += 41
            ElseIf x == 10
                nCol += 41
            ElseIf x == 11
                nCol += 41
            ElseIf x == 12
                oPrinter:Say( nLin,nCol,PADC(TransForm(Round(nToT9/nMesMed,0),"@E 999,999"),10),oFont8C,,CLR_BLACK )
                nCol += 41
            ElseIf x == 13
                oPrinter:Say( nLin,nCol-5,PADC(TransForm(Round(nToT10/(nMesMed*30),0),"@E 999,999"),10),oFont8C,,CLR_BLACK )
                nCol += 41
            EndIf
        Next x
        nLin += 10

        //leitura para pagamento
        //TOTAL PARA PAGAMENTO
        nCol := 11+41
        For x := 1 to 7
            if x == 1
                If &(cValToChar(Round(nToT1x,1))+cPadrao1)
                    nCor := CLR_BLACK
                Else
                    nCor := CLR_HRED
                EndIf
                oPrinter:Say( nLin,nCol,PADC(TransForm(Round(nToT1x,1),'@E 99.9'),10),oFont8C,,nCor )
                nCol += 41
            ElseIf x == 2
                If &(cValToChar(Round(nToT2x,1))+cPadrao2)
                    nCor := CLR_BLACK
                Else
                    nCor := CLR_HRED
                EndIf
                oPrinter:Say( nLin,nCol,PADC(TransForm(Round(nToT2x,1),"@E 99.9"),10),oFont8C,,nCor )
                nCol += 41
            ElseIf x == 3
                If &(cValToChar(Round(nToT3x,1))+cPadrao3)
                    nCor := CLR_BLACK
                Else
                    nCor := CLR_HRED
                EndIf
                oPrinter:Say( nLin,nCol,PADC(TransForm(Round(nToT3x,1),"@E 99.9"),10),oFont8C,,nCor )
                nCol += 41
            ElseIf x == 4
                If &(cValToChar(Round(nToT4x,1))+cPadrao4)
                    nCor := CLR_BLACK
                Else
                    nCor := CLR_HRED
                EndIf
                oPrinter:Say( nLin,nCol,PADC(TransForm(Round(nToT4x,1),"@E 99.9"),10),oFont8C,,nCor )
                nCol += 41
            ElseIf x == 5
                If &(cValToChar(Round(nToT5x,1))+cPadrao5)
                    nCor := CLR_BLACK
                Else
                    nCor := CLR_HRED
                EndIf
                oPrinter:Say( nLin,nCol,PADC(TransForm(Round(nToT5x,1),"@E 99.9"),10),oFont8C,,nCor )
                nCol += 41
            ElseIf x == 6
                If &(cValToChar(Round(nToT6x,0))+cPadrao6)
                    nCor := CLR_BLACK
                Else
                    nCor := CLR_HRED
                EndIf
                oPrinter:Say( nLin,nCol,PADC(TransForm(Round(nToT6x,0),"@E 9999"),10),oFont8C,,nCor )
                nCol += 41
            ElseIf x == 7
                If &(cValToChar(Round(nToT7x,0))+cPadrao7)
                    nCor := CLR_BLACK
                Else
                    nCor := CLR_HRED
                EndIf
                oPrinter:Say( nLin,nCol,PADC(TransForm(Round(nToT7x,0),"@E 9999"),10),oFont8C,,nCor )
                nCol += 41
            EndIf
        Next x

    ///////////////////////////////////////
    nlin -= 10
    nCol := 11
    nLin := 169-35-13
    oPrinter:Say( nLin,nCol,OemToAnsi("JANEIRO"),oFont7,,CLR_BLUE )
    nLin += 10
    oPrinter:Say( nLin,nCol,OemToAnsi("FEVEREIRO"),oFont7,,CLR_BLUE )
    nLin += 10
    oPrinter:Say( nLin,nCol,OemToAnsi("MARCO"),oFont7,,CLR_BLUE )
    nLin += 10
    oPrinter:Say( nLin,nCol,OemToAnsi("ABRIL"),oFont7,,CLR_BLUE )
    nLin += 10
    oPrinter:Say( nLin,nCol,OemToAnsi("MAIO"),oFont7,,CLR_BLUE )
    nLin += 10
    oPrinter:Say( nLin,nCol,OemToAnsi("JUNHO"),oFont7,,CLR_BLUE )
    nLin += 10
    oPrinter:Say( nLin,nCol,OemToAnsi("JULHO"),oFont7,,CLR_BLUE )
    nLin += 10
    oPrinter:Say( nLin,nCol,OemToAnsi("AGOSTO"),oFont7,,CLR_BLUE )
    nLin += 10
    oPrinter:Say( nLin,nCol,OemToAnsi("SETEMBRO"),oFont7,,CLR_BLUE )
    nLin += 10
    oPrinter:Say( nLin,nCol,OemToAnsi("OUTUBRO"),oFont7,,CLR_BLUE )
    nLin += 10
    oPrinter:Say( nLin,nCol,OemToAnsi("NOVEMBRO"),oFont7,,CLR_BLUE )
    nLin += 10
    oPrinter:Say( nLin,nCol,OemToAnsi("DEZEMBRO"),oFont7,,CLR_BLUE )
    nLin += 10
    oPrinter:Say( nLin,nCol,OemToAnsi("MED.ANUAL"),oFont7,,CLR_BLUE )
    nLin += 10
    oPrinter:Say( nLin,nCol,OemToAnsi("MED.PG MES"),oFont7,,CLR_BLUE )
    nLin += 10

    nCol := 50
    For nColuna := 1 to 13 //linhas divisorias colunas
        oPrinter:Line( 121-35, nCol, 276-10-13, nCol,10, "-1")
    	nCol += 41
    Next nColuna

    nLin := 370-88-15
    nCol := 11

    cTexto := "DEMONSTRATIVO DE PAGAMENTO"
    oPrinter:Say( nLin,nCol+90,OemToAnsi(cTexto),oFontTx2,,CLR_BLACK )

    nCol += 300
    cTexto := "MÊS DE REFERENCIA:"
    oPrinter:Say( nLin,nCol,OemToAnsi(cTexto),oFontTx2,,CLR_HRED )

    nCol += 120
    cTexto := SubStr(MV_PAR01,1,2)+"/"+SubStr(MV_PAR01,3,4)
    oPrinter:Say( nLin,nCol,OemToAnsi(cTexto),oFontTx2,,CLR_HBLUE )

    nCol := 009
    nLin += 005
    oPrinter:Box( nLin, nCol, nLin+10, 581, "-1")
    oPrinter:Line( nLin, 255, nLin+10, 255,10, "-1")
    oPrinter:Line( nLin, 337, nLin+10, 337,10, "-1")
    oPrinter:Line( nLin, 419, nLin+10, 419,10, "-1")
    oPrinter:Line( nLin, 501, nLin+10, 501,10, "-1")

    nLin += 007
    oPrinter:Say( nLin,nCol,OemToAnsi(padc("D E S C R I Ç Ã O",60)),oFont7,,CLR_BLACK )
    oPrinter:Say( nLin,nCol+255,OemToAnsi(padc("QUANTIDADE",15)),oFont7,,CLR_BLACK )
    oPrinter:Say( nLin,nCol+337,OemToAnsi(padc("VALOR UNIT.",15)),oFont7,,CLR_BLACK )
    oPrinter:Say( nLin,nCol+419,OemToAnsi(padc("PROVENTOS",15)),oFont7,,CLR_BLACK )
    oPrinter:Say( nLin,nCol+501,OemToAnsi(padc("DESCONTOS",15)),oFont7,,CLR_BLACK )

    aRet := {}

    aRet := xPagtos(_cCodFor,_cCodPro)

    nLin += 005
    nLit := 0
    If Len(aRet)>0
        nLit := aRet[1][2]
    EndIf

    nTotCre := 0
    nTotDeb := 0
    nTotRec := 0
    nPrLiq  := 0
    nXAdc   := 0
    nXLiqui := 0
    nXLin   := 0
    nXDif   := 0
    nxInc   := 0
    nCrePr  := 0
    nDebPr  := 0

    For i := 1 To Len(aRet)

        oPrinter:Box( nLin, nCol, nLin+10, 581, "-1")
        oPrinter:Line( nLin, 255, nLin+10, 255,10, "-1")
        oPrinter:Line( nLin, 337, nLin+10, 337,10, "-1")
        oPrinter:Line( nLin, 419, nLin+10, 419,10, "-1")
        oPrinter:Line( nLin, 501, nLin+10, 501,10, "-1")

        oPrinter:Say( nLin+6,nCol+2,OemToAnsi(Alltrim(aRet[i][1])),oFont7,,CLR_BLACK ) //DESCRICAO
        oPrinter:Say( nLin+6,nCol+255,OemToAnsi(padc(TransForm(aRet[i][2],"@E 999,999"),15)),oFont7,,CLR_BLACK ) //QUANTIDADE

        If !'ADICIONAL DE' $ aRet[i][1]
        oPrinter:Say( nLin+6,nCol+337,OemToAnsi(padc("R$ "+TransForm(aRet[i][3],"@E 999.999"),15)),oFont7,,iif(aRet[i][3]>=0,CLR_BLACK,CLR_HRED) ) //VALOR UNITARIO
        oPrinter:Say( nLin+6,nCol+419,OemToAnsi(padc("R$ "+TransForm(aRet[i][4],"@E 999,999.99"),15)),oFont7,,CLR_BLACK ) //PROVENTOS
        EndIf

        oPrinter:Say( nLin+6,nCol+501,OemToAnsi(padc("R$ "+TransForm(aRet[i][5],"@E 999,999.99"),15)),oFont7,,CLR_HRED ) //DESCONTOS

        If 'ADICIONAL DE' $ aRet[i][1]
            nXAdc   := aRet[i][4]
            nXLin   := nLin+6
        EndIf

        If 'LEITE CRU' $ aRet[i][1]
            nXLiqui := aRet[i][6]
        EndIf

        If aRet[i][7] == 'B'
        nCrePr += aRet[i][4]
        nDebPr += abs(aRet[i][5])
        EndIf

        If 'INCENTIVO' $ aRet[i][1]
            nxInc := aRet[i][4]
        EndIf

        nTotCre += aRet[i][4]
        nTotDeb += aRet[i][5]

        nLin += 10
    Next i

        nTotRec := nTotCre + nTotDeb
        nXDif := nTotRec - nXLiqui
        nXAdc := nXAdc - nXDif

        nTotRec := nTotRec-nxDif
        nTotCre := nTotCre-nxDif

        nPrLiq := (nCrePr-nDebPr)/nLit

    oPrinter:Say( nXLin,nCol+337,OemToAnsi(padc("R$ "+TransForm(nXAdc/nLit,"@E 999.999"),15)),oFont7,,iif(nXAdc/nLit>=0,CLR_BLACK,CLR_HRED) ) //VALOR UNITARIO APOS AJUSTE ADC MER
    oPrinter:Say( nXLin,nCol+419,OemToAnsi(padc("R$ "+TransForm(nXAdc,"@E 999,999.99"),15)),oFont7,,CLR_BLACK ) //PROVENTOS APOS AJUSTE ADC MER

    nCol := 11
    nLin += 10
    oPrinter:Say( nLin,nCol,OemToAnsi("TOTAL DE CRÉDITOS...................................."),oFont7a,,CLR_BLACK )
    oPrinter:Say( nLin,nCol+255,OemToAnsi("R$ "+Transform(Round(nTotCre,2),"@E 999,999.99")),oFont7a,,CLR_BLACK )

    oPrinter:Say( nLin,nCol+327,OemToAnsi("TOTAL DE DÉBITOS....................."),oFont7a,,CLR_BLACK )
    oPrinter:Say( nLin,nCol+505,OemToAnsi("R$ "+Transform(Round(nTotDeb,2),"@E 999,999.99")),oFont7a,,CLR_HRED )

    oPrinter:Say( nLin+009,nCol,OemToAnsi("SALDO A RECEBER............  ........................"),oFont7a,,CLR_BLACK )
    oPrinter:Say( nLin+009,nCol+255,OemToAnsi("R$ "+Transform(Round(nTotRec,2),"@E 999,999.99")),oFont7a,,CLR_BLACK )

    oPrinter:Say( nLin+009,nCol+327,OemToAnsi("VALOR LIQUIDO P/LITRO................"),oFont7a,,CLR_BLACK )
    oPrinter:Say( nLin+009,nCol+505,OemToAnsi("R$     "+Transform(Round(nPrLiq,3),"@E 99.999")),oFont7a,,CLR_BLUE )


    nLin += 015
    nCol := 009
    oPrinter:Box( nLin, nCol, nLin+10, 581, "-1")
    cTexto := UPPER("Fique atento aos resultados de análises do leite, devendo ser cumprido na íntegra os procedimentos de Boas Práticas Agropecuárias, conforme abaixo")
    oPrinter:Say( nLin+7,nCol+7,OemToAnsi(cTexto),oFontTx4N,,CLR_BLACK )

    nLin += 009
    oPrinter:Box( nLin, nCol, nLin+15, 581, "-1")
    oPrinter:Line( nLin,80, nLin+15, 80,10, "-1")
    oPrinter:Line( nLin,300, nLin+15, 300,10, "-1")

    cTexto := "   ITENS PARA"
    oPrinter:Say( nLin+6,nCol+2,OemToAnsi(cTexto),oFontTx5,,CLR_BLACK )
    cTexto := "  VERIFICAÇÃO"
    oPrinter:Say( nLin+7+6,nCol+2,OemToAnsi(cTexto),oFontTx5,,CLR_BLACK )

    cTexto := "         PADRÕES PARA O REQUISITO E PRINCIPAIS "
    oPrinter:Say( nLin+6,85,OemToAnsi(cTexto),oFontTx5,,CLR_BLACK )
    cTexto := "      CAUSAS QUE OCASIONAM O DESVIO IDENTIFICADO"
    oPrinter:Say( nLin+7+6,85,OemToAnsi(cTexto),oFontTx5,,CLR_BLACK )

    cTexto := "                           AÇÕES GERAIS"
    oPrinter:Say( nLin+13,310,OemToAnsi(cTexto),oFontTx5,,CLR_BLACK )

    nLin += 015
    oPrinter:Box( nLin, nCol, nLin+60, 581, "-1")
    oPrinter:Line( nLin,80, nLin+60, 80,10, "-1")
    oPrinter:Line( nLin,300, nLin+60, 300,10, "-1")

    cTexto := "LOCAL DE ORDENHA,"
    oPrinter:Say( nLin+21,nCol+2,OemToAnsi(cTexto),oFontTx5,,CLR_BLACK )
    cTexto := "  HIGIENIZAÇÃO E"
    oPrinter:Say( nLin+28,nCol+2,OemToAnsi(cTexto),oFontTx5,,CLR_BLACK )
    cTexto := "    MANUTENÇÃO"
    oPrinter:Say( nLin+35,nCol+2,OemToAnsi(cTexto),oFontTx5,,CLR_BLACK )
    cTexto := " DA ORDENHADEIRA"
    oPrinter:Say( nLin+42,nCol+2,OemToAnsi(cTexto),oFontTx5,,CLR_BLACK )

    cTexto := "A dependência de ordenha deve ser mantida limpa antes,"
    oPrinter:Say( nLin+7,85,OemToAnsi(padc(cTexto,56)),oFontTx4,,CLR_BLACK )
    cTexto := " durante e depois da ordenha.O ambiente deve ser"
    oPrinter:Say( nLin+14,85,OemToAnsi(padc(cTexto,56)),oFontTx4,,CLR_BLACK )
    cTexto := "mantido sem acúmulo de esterco e isento de materiais"
    oPrinter:Say( nLin+21,85,OemToAnsi(padc(cTexto,56)),oFontTx4,,CLR_BLACK )
    cTexto := "indesejáveis. A manutenção e a higienização do"
    oPrinter:Say( nLin+28,85,OemToAnsi(padc(cTexto,56)),oFontTx4,,CLR_BLACK )
    cTexto := "equipamento de ordenha devem ser realizadas de acordo"
    oPrinter:Say( nLin+35,85,OemToAnsi(padc(cTexto,56)),oFontTx4,,CLR_BLACK )
    cTexto := "com as orientações do fabricante. Higienização inadequada"
    oPrinter:Say( nLin+42,84,OemToAnsi(padc(cTexto,56)),oFontTx4,,CLR_BLACK )
    cTexto := "do equipamento poderá comprometer os intervalos"
    oPrinter:Say( nLin+49,85,OemToAnsi(padc(cTexto,56)),oFontTx4,,CLR_BLACK )
    cTexto := "de manutenção.
    oPrinter:Say( nLin+56,85,OemToAnsi(padc(cTexto,56)),oFontTx4,,CLR_BLACK )

    cTexto := "O que?"
    oPrinter:Say( nLin+7,310,OemToAnsi(cTexto),oFontTx5,,CLR_HBLUE )
    cTexto := "Manter o ambiente de ordenha limpo e organizado."
    oPrinter:Say( nLin+7,345,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "Realizar a higienização do equipamento respeitando os procedimentos"
    oPrinter:Say( nLin+14,310,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "e dosagens recomendados pelo fabricante do equipamento e dos produtos"
    oPrinter:Say( nLin+21,310,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "de limpeza utilizados. Não deve ser utilizados produtos com produção"
    oPrinter:Say( nLin+28,310,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "caseira para realização da higienização do equipamento."
    oPrinter:Say( nLin+35,310,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "Quando?"
    oPrinter:Say( nLin+42,310,OemToAnsi(cTexto),oFontTx5,,CLR_HBLUE )
    cTexto := "A cada ordenha."
    oPrinter:Say( nLin+42,345,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "Quem?"
    oPrinter:Say( nLin+49,310,OemToAnsi(cTexto),oFontTx5,,CLR_HBLUE )
    cTexto := "Produtor rural. Realizar a manutenção do equipamento dentro"
    oPrinter:Say( nLin+49,345,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "do prazo estabelecido pelo fabricante."
    oPrinter:Say( nLin+56,310,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )

    //segundo box
    nLin += 060
    oPrinter:Box( nLin, nCol, nLin+45, 581, "-1")
    oPrinter:Line( nLin,80, nLin+45, 80,10, "-1")
    oPrinter:Line( nLin,300, nLin+45, 300,10, "-1")

    cTexto := "  LOCALIZAÇÃO DO"
    oPrinter:Say( nLin+16,nCol+2,OemToAnsi(cTexto),oFontTx5,,CLR_BLACK )
    cTexto := "    TANQUE DE"
    oPrinter:Say( nLin+23,nCol+2,OemToAnsi(cTexto),oFontTx5,,CLR_BLACK )
    cTexto := "   RERIGERAÇÃO"
    oPrinter:Say( nLin+30,nCol+2,OemToAnsi(cTexto),oFontTx5,,CLR_BLACK )

    cTexto := "O tanque de refrigeração deve ser instalado em local"
    oPrinter:Say( nLin+7,85,OemToAnsi(padc(cTexto,54)),oFontTx4,,CLR_BLACK )
    cTexto := "adequado, provido de paredes (laváveis), cobertura,"
    oPrinter:Say( nLin+14,85,OemToAnsi(padc(cTexto,54)),oFontTx4,,CLR_BLACK )
    cTexto := "pavimentação, ponto de água corrente, protegido contra"
    oPrinter:Say( nLin+21,85,OemToAnsi(padc(cTexto,54)),oFontTx4,,CLR_BLACK )
    cTexto := "o acesso de animais, condições de limpeza e higiene"
    oPrinter:Say( nLin+28,85,OemToAnsi(padc(cTexto,54)),oFontTx4,,CLR_BLACK )
    cTexto := "adequados, ter a capacidade mínima de armazenar"
    oPrinter:Say( nLin+35,85,OemToAnsi(padc(cTexto,54)),oFontTx4,,CLR_BLACK )
    cTexto := "a produção de acordo com a frequência de coleta."
    oPrinter:Say( nLin+42,85,OemToAnsi(padc(cTexto,54)),oFontTx4,,CLR_BLACK )


    cTexto := "O que?"
    oPrinter:Say( nLin+7,310,OemToAnsi(cTexto),oFontTx5,,CLR_HBLUE )
    cTexto := "Adequar a localização do tanque de refrigeração. Deve ser "
    oPrinter:Say( nLin+7,345,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "seguido as normas estabelecidas na Instrução Normativa"
    oPrinter:Say( nLin+14,310,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "n°77 de 26/11/2018."
    oPrinter:Say( nLin+21,310,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "Quando?"
    oPrinter:Say( nLin+28,310,OemToAnsi(cTexto),oFontTx5,,CLR_HBLUE )
    cTexto := "Estaremos realizando visita na propriedade para em "
    oPrinter:Say( nLin+28,355,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "conjunto estabelecer o prazo para adequação.
    oPrinter:Say( nLin+35,310,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "Quem?"
    oPrinter:Say( nLin+42,310,OemToAnsi(cTexto),oFontTx5,,CLR_HBLUE )
    cTexto := "Produtor rural/Equipe fomento."
    oPrinter:Say( nLin+42,345,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )

    //terceito box
    nLin += 045
    oPrinter:Box( nLin, nCol, nLin+40, 581, "-1")
    oPrinter:Line( nLin,80, nLin+40, 80,10, "-1")
    oPrinter:Line( nLin,300, nLin+40, 300,10, "-1")

    cTexto := "  HIGIENIZAÇÃO"
    oPrinter:Say( nLin+14,nCol+2,OemToAnsi(cTexto),oFontTx5,,CLR_BLACK )
    cTexto := "   DO TANQUE"
    oPrinter:Say( nLin+21,nCol+2,OemToAnsi(cTexto),oFontTx5,,CLR_BLACK )
    cTexto := "  DE EXPANSAO"
    oPrinter:Say( nLin+28,nCol+2,OemToAnsi(cTexto),oFontTx5,,CLR_BLACK )

    cTexto := "O tanque deve ser mantido em condição de limpeza"
    oPrinter:Say( nLin+7,85,OemToAnsi(padc(cTexto,54)),oFontTx4,,CLR_BLACK )
    cTexto := "e higiene adequada. O não cumprimento da higienização"
    oPrinter:Say( nLin+14,85,OemToAnsi(padc(cTexto,54)),oFontTx4,,CLR_BLACK )
    cTexto := "utilizando produtos apropriados e de acordo com a"
    oPrinter:Say( nLin+21,85,OemToAnsi(padc(cTexto,54)),oFontTx4,,CLR_BLACK )
    cTexto := "recomendação do fabricante comprometerá na"
    oPrinter:Say( nLin+28,85,OemToAnsi(padc(cTexto,54)),oFontTx4,,CLR_BLACK )
    cTexto := "higienização do tanque."
    oPrinter:Say( nLin+35,85,OemToAnsi(padc(cTexto,54)),oFontTx4,,CLR_BLACK )

    cTexto := "O que?"
    oPrinter:Say( nLin+7,310,OemToAnsi(cTexto),oFontTx5,,CLR_HBLUE )
    cTexto := "Realizar a higienização do tanque respeitando "
    oPrinter:Say( nLin+7,345,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "do fabricante do tanque e do fabricante dos produtos "
    oPrinter:Say( nLin+14,310,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "de limpeza."
    oPrinter:Say( nLin+21,310,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "Quando?"
    oPrinter:Say( nLin+28,310,OemToAnsi(cTexto),oFontTx5,,CLR_HBLUE )
    cTexto := "A cada coleta do leite."
    oPrinter:Say( nLin+28,345,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "Quem?"
    oPrinter:Say( nLin+35,310,OemToAnsi(cTexto),oFontTx5,,CLR_HBLUE )
    cTexto := "Produtor rural."
    oPrinter:Say( nLin+35,345,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )

    //quarto box=======================================
    nLin += 040

    oPrinter:Box( nLin, nCol, nLin+30, 581, "-1")
    oPrinter:Line( nLin,80, nLin+30, 80,10, "-1")
    oPrinter:Line( nLin,300, nLin+30, 300,10, "-1")


    cTexto := " TEMPERATURA DE"
    oPrinter:Say( nLin+7+4,nCol+2,OemToAnsi(cTexto),oFontTx5,,CLR_BLACK )
    cTexto := "  CONSERVAÇÃO"
    oPrinter:Say( nLin+14+4,nCol+2,OemToAnsi(cTexto),oFontTx5,,CLR_BLACK )
    cTexto := "   DO LEITE"
    oPrinter:Say( nLin+21+4,nCol+2,OemToAnsi(cTexto),oFontTx5,,CLR_BLACK )


    cTexto := "O leite deverá ser refrigerado a temperatura inferior"
    oPrinter:Say( nLin+7,85,OemToAnsi(padc(cTexto,54)),oFontTx4,,CLR_BLACK )
    cTexto := "a 4°C após 3 h da ordenha."
    oPrinter:Say( nLin+14,85,OemToAnsi(padc(cTexto,54)),oFontTx4,,CLR_BLACK )

    cTexto := "O que?"
    oPrinter:Say( nLin+7,310,OemToAnsi(cTexto),oFontTx5,,CLR_HBLUE )
    cTexto := "Manter o tanque ligado durante todo o tempo de permanência"
    oPrinter:Say( nLin+7,345,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "do leite."
    oPrinter:Say( nLin+14,310,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "Quando?"
    oPrinter:Say( nLin+21,310,OemToAnsi(cTexto),oFontTx5,,CLR_HBLUE )
    cTexto := "Todos os dias."
    oPrinter:Say( nLin+21,345,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )
    cTexto := "Quem?"
    oPrinter:Say( nLin+28,310,OemToAnsi(cTexto),oFontTx5,,CLR_HBLUE )
    cTexto := "Produtor rural."
    oPrinter:Say( nLin+28,345,OemToAnsi(cTexto),oFontTx4,,CLR_BLACK )

    ////////////=================================================================

    oPrinter:Say( nLin+38,85,OemToAnsi(padc("VAMOS ENTENDER SUA ANÁLISE",80)),oFont7a,,CLR_BLUE )

    nLin += 040
    oPrinter:Box( nLin, nCol, nLin+10, 581, "-1")
    oPrinter:Line( nLin,155, nLin+10, 155,10, "-1")
    oPrinter:Line( nLin,312, nLin+10, 312,10, "-1")

    oPrinter:Say( nLin+7,nCol+2,OemToAnsi("          ANALISE DE COMPOSIÇÃO"),oFontTx5,,CLR_BLACK )
    oPrinter:Say( nLin+7,155,OemToAnsi("                  CCS"),oFontTx5,,CLR_BLACK )
    oPrinter:Say( nLin+7,310,OemToAnsi("                                   CBT"),oFontTx5,,CLR_BLACK )

    nLin += 010
    oPrinter:Box( nLin, nCol, nLin+67, 581, "-1")
    oPrinter:Line( nLin,155, nLin+67, 155,10, "-1")
    oPrinter:Line( nLin,312, nLin+67, 312,10, "-1")


    cTexto := "Compõe esse monitoramento as análises"
    oPrinter:Say( nLin+7,nCol+2,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := "de Gordura(G), Proteina(P), Lactose(L)"
    oPrinter:Say( nLin+14,nCol+2,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := ",extrato seco total(EST), extrato seco"
    oPrinter:Say( nLin+21,nCol+2,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := ",desengordurado(ESD). Os fatores que"
    oPrinter:Say( nLin+28,nCol+2,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := " podem influenciar nesses parâmetros"
    oPrinter:Say( nLin+35,nCol+2,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := "   são: raça, estágio de lactação,"
    oPrinter:Say( nLin+42,nCol+2,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := " herança genética, porção e intervalo"
    oPrinter:Say( nLin+49,nCol+2,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := " de ordenhas, estação do ano, saúde do"
    oPrinter:Say( nLin+56,nCol+2,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := " animal, mastite e coleta de amostra."
    oPrinter:Say( nLin+63,nCol+2,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    //cTexto := ""
    //oPrinter:Say( nLin+70,nCol+2,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )

    cTexto := " O que é CCS e para que serve o monitoramento?"
    oPrinter:Say( nLin+7,157,OemToAnsi(cTexto),oFontAr6n,,CLR_BLACK )

    cTexto := "Contagem de células somáticas. Indica de"
    oPrinter:Say( nLin+14,157,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := " maneira quantitativa o grau de mastite"
    oPrinter:Say( nLin+21,157,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := "  na glândula mamária. Já a CCS do"
    oPrinter:Say( nLin+28,157,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := " leite do tanque de resfriamento indica "
    oPrinter:Say( nLin+35,157,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := "a incidência média de mastite no rebanho."
    oPrinter:Say( nLin+42,157,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := "Pode sofrer influência de outros fatores,"
    oPrinter:Say( nLin+49,157,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := "como: estágio de lactação, idade da vaca,"
    oPrinter:Say( nLin+56,157,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := "  época do ano, estresse térmico, etc."
    oPrinter:Say( nLin+63,157,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )

    //=========================================================================
    cTexto := "           O que é CBT e para que serve o monitoramento?"
    oPrinter:Say( nLin+7,314,OemToAnsi(cTexto),oFontAr6,,CLR_HRED )
    cTexto := "Contagem bacteriana total. Avalia a qualidade microbiológica do leite,"
    oPrinter:Say( nLin+14,314,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := "    e sofre impacto direto de vários aspectos, tais como: saúde da"
    oPrinter:Say( nLin+21,314,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := "  glândula mamária, a higiene de ordenha, o ambiente onde a vaca se"
    oPrinter:Say( nLin+28,314,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := " encontra, os procedimentos de higiene de equipamentos/utensilios e"
    oPrinter:Say( nLin+35,314,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := "   ordenhador, além da qualidade da água. A temperatura e o tempo"
    oPrinter:Say( nLin+42,314,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := "   de armazenamento do leite possui impacto direto e significante."
    oPrinter:Say( nLin+49,314,OemToAnsi(cTexto),oFontAr6,,CLR_BLACK )
    cTexto := "   Três meses consecutivos na média geométrica fora do padrão de"
    oPrinter:Say( nLin+56,314,OemToAnsi(cTexto),oFontAr6,,CLR_HRED )
    cTexto := "      qualidade, será feito o bloqueio da captação do leite."
    oPrinter:Say( nLin+63,314,OemToAnsi(cTexto),oFontAr6,,CLR_HRED )
    //cTexto := "          Procedimento este de forma "
    //oPrinter:Say( nLin+70,314,OemToAnsi(cTexto),oFontAr6,,CLR_HRED)
    //cTexto := "                 a atender a legislação vigente."
    //oPrinter:Say( nLin+77,314,OemToAnsi(cTexto),oFontAr6,,CLR_HRED )

    cTexto := "Contatos:Controle de Qualidade (Edna) 34-3813-1180/3813-4722 Assistencia Rural:Cyro: 34-99674-7965 Victor:34-99669-3381 João Paulo:34- 99669-0209"
    oPrinter:Say( nLin+74,009,OemToAnsi(cTexto),oFont7,,CLR_BLACK )

    */

    oPrinter:EndPage()


//EndDo


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
STATIC FUNCTION VALQA22A()

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
STATIC FUNCTION VALQA22B()

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
STATIC FUNCTION VALQA22C()

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
STATIC FUNCTION VALQA22D()

	LOCAL LRET := .F.

	IF IIF(!EMPTY(MV_PAR05),IIF(MV_PAR05=='ZZZZZZ',.T.,ExistCpo("LBB",MV_PAR05)),.F.) .OR. MV_PAR05 == 'ZZZZZZ'
		LRET := .T.
	END IF

RETURN LRET



Static Function xPagtos(xFornece,xCodPro)

Local aRet      := {}
Local cAlias    := 'QA022FPG'
Local nPrBase   := 0
Local nLitros   := 0
Local nIncent   := 0
Local nFunrur   := 0

    Beginsql Alias cAlias

	    %NOPARSER%

        SELECT LJV_PRBASE FROM LJV010 LJV WHERE
        YEAR(LJV_DTFECH)=%EXP:SubStr(MV_PAR01,3,4)% AND MONTH(LJV_DTFECH)=%EXP:Str(Val(SubStr(MV_PAR01,1,2)))% AND LJV_FILIAL=%Exp:cFilAnt% AND LJV.D_E_L_E_T_=''

    EndSql

    If (cAlias)->( !Eof() )
        nPrBase := (cAlias)->(LJV_PRBASE)
    EndIf

    If Select(cAlias)>0
        (cAlias)->( dbCLoseArea() )
    EndIf

    Beginsql Alias cAlias

	    %NOPARSER%

        SELECT D1_QUANT,F1_XINSS,F1_XINCEN,F1_XLIQUID
        FROM SD1010 SD1
        INNER JOIN SF1010 SF1 ON F1_FILIAL=D1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA AND SF1.D_E_L_E_T_=''
        WHERE D1_FORNECE=%Exp:xFornece% AND
        YEAR(D1_EMISSAO)=%EXP:SubStr(MV_PAR01,3,4)% AND MONTH(D1_EMISSAO)=%EXP:Str(Val(SubStr(MV_PAR01,1,2)))%
        AND D1_COD='200113' AND SD1.D_E_L_E_T_='' AND D1_FILIAL=%Exp:cFilAnt%

    EndSql

    If (cAlias)->( !Eof() )
        nLitros := (cAlias)->(D1_QUANT)
        nIncent := (cAlias)->(F1_XINCEN)
        nFunrur := (cAlias)->(F1_XINSS)
        AADD(aRet,{'LEITE CRU RESFRIADO - PREÇO BASE',nLitros,nPrBase,nPrBase*nLitros,0,(cAlias)->(F1_XLIQUID),'B'})
    EndIf

    If Select(cAlias)>0
        (cAlias)->( dbCLoseArea() )
    EndIf

    Beginsql Alias cAlias

	    %NOPARSER%

        SELECT LJX_DESC,LJZ_RESLEI
        FROM LJZ010 LJZ
        INNER JOIN LJX010 LJX ON LJX_FILIAL=LJZ_FILIAL AND LJZ_CODBON=LJX_CODBON AND LJX_PAGA='S' AND LJX.D_E_L_E_T_=''
        WHERE
        YEAR(LJZ_DATCLQ)=%EXP:SubStr(MV_PAR01,3,4)% AND MONTH(LJZ_DATCLQ)=%EXP:Str(Val(SubStr(MV_PAR01,1,2)))%
        AND LJZ_CODPRO=%Exp:xCodPro% AND LJZ_FILIAL=%Exp:cFilAnt%
        UNION ALL
        SELECT 'OUTROS CREDITOS' AS LJX_DESC,LJU_VALOR AS LJZ_RESLEI FROM LJU010 LJU
        WHERE LJU_FILIAL=%Exp:cFilAnt% AND LJU_CODPRO=%eXP:xCodPro% AND
        LJU_PERIOD=%Exp:MV_PAR01%
        AND LJU.D_E_L_E_T_=''

    EndSql

    Do While (cAlias)->( !Eof() )
        If  ! 'OUTROS' $ (cAlias)->(LJX_DESC)
            AADD(aRet,{(cAlias)->(LJX_DESC),;
            nLitros,;
            (cAlias)->(LJZ_RESLEI),;
            iif((cAlias)->(LJZ_RESLEI)>=0.000,(cAlias)->(LJZ_RESLEI)*nLitros,0),;
            iif((cAlias)->(LJZ_RESLEI)<0.000,nLitros*(cAlias)->(LJZ_RESLEI),0),0,'B'})
        Else
            AADD(aRet,{(cAlias)->(LJX_DESC),;
            nLitros,;
            (cAlias)->(LJZ_RESLEI)/nLitros,;
            iif((cAlias)->(LJZ_RESLEI)>=0.000,(cAlias)->(LJZ_RESLEI),0),;
            iif((cAlias)->(LJZ_RESLEI)<0.000,(cAlias)->(LJZ_RESLEI),0),0,'B'})
        EndIf
        (cAlias)->(dbSkip())
    EndDo

    AADD(aRet,{'INCENTIVO A PRODUÇÃO LEITEIRA',nLitros,0,nIncent,0,0,''})
    AADD(aRet,{'PREVIDENCIA SOCIAL(FUNRURAL)',nLitros,0,0,-nFunrur,0,''})

    If Select(cAlias)>0
        (cAlias)->( dbCLoseArea() )
    EndIf

    Beginsql Alias cAlias

	    %NOPARSER%

        SELECT PA6_TIPDES+'-'+LBR_DESC AS LBR_DESC,PA6_VALOR FROM PA6010 PA6
        INNER JOIN LBR010 LBR ON LBR_FILIAL=PA6_FILIAL AND LBR_TIPDES=PA6_TIPDES AND LBR.D_E_L_E_T_=''
        WHERE PA6_PERIOD=%Exp:MV_PAR01% AND PA6_CODPRO=%Exp:xCodPro% AND PA6_FILIAL=%Exp:cFilAnt% AND PA6.D_E_L_E_T_=''

    EndSql

    Do While (cAlias)->( !Eof() )
        AADD(aRet,{(cAlias)->(LBR_DESC),0,0,0,-(cAlias)->(PA6_VALOR),0,''})
        (cAlias)->(dbSkip())
    EndDo

    If Select(cAlias)>0
        (cAlias)->( dbCLoseArea() )
    EndIf

Return aRet





