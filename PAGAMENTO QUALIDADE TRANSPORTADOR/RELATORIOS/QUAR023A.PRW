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

Beginsql Alias cAlias

	%NOPARSER%

    SELECT PC6_CODTRA,PC6_TRANSP,PC6_VRIMP,PC6_VRBON,PC6_VRFRT,PC6_VRTOT,A2_MUN,A2_EST,A2_END,A2_INSCR,A2_CGC
    FROM %Table:PC6% PC6
    INNER JOIN %Table:SA2% SA2 ON A2_COD=PC6.PC6_CODTRA AND A2_LOJA='0001' AND SA2.%notDel%
    WHERE PC6_FILIAL=%Exp:cFilAnt% AND PC6_PERIOD=%Exp:MV_PAR01% AND PC6.%notDel%
    AND PC6_CODTRA BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
    ORDER BY PC6_CODTRA

EndSql


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


While (cAlias)->( !Eof() )

    oPrinter:StartPage()

    //====LOGO E TITULO ==================================================================================================
    oPrinter:SayBitmap (002,010, "\logo_quata.png" ,80,37)
    oPrinter:Say( 030,135,OemToAnsi("RELATORIO DE PAGAMENTO DE TRANSPORTE DE LEITE - " + TransForm(MV_PAR01,'@R 99/9999')),oFont20a,,CLR_BLUE)
    //====================================================================================================================

    oPrinter:Box( 079-35, 009, 121-30, 581, "-1")

    oPrinter:Say( 090-30,365,   OemToAnsi("Municipio.: "),oFont10N,,CLR_BLACK)
    oPrinter:Say( 090-30,365+60,OemToAnsi(Alltrim((cAlias)->(A2_MUN))+" - "+(cAlias)->(A2_EST)),oFont10N,,CLR_BLACK)

    //================= SEGUNDA LINHA CABEC
    oPrinter:Say( 090-30,015,   OemToAnsi("Transportadora: "),oFont10N,,CLR_BLACK)
    oPrinter:Say( 090-30,015+73,OemToAnsi((cAlias)->(PC6_CODTRA)+'/00001-'+AllTrim((cAlias)->(PC6_TRANSP))),oFont10N,,CLR_BLACK)

    oPrinter:Say( 102-30,365,   OemToAnsi("I.Estadual: "),oFont10N,,CLR_BLACK)
    oPrinter:Say( 102-30,365+60,OemToAnsi(Transform(StrTran(StrTran((cAlias)->(A2_INSCR),".",""),"-",""),"@R 999999999.99-99")),oFont10N,,CLR_BLACK)

    //TERCEIRA LINHA CABEC
    oPrinter:Say( 102-30,015,   OemToAnsi("Endereço: "),oFont10N,,CLR_BLACK)
    oPrinter:Say( 102-30,015+45,OemToAnsi(Alltrim((cAlias)->(A2_END))),oFont10N,,CLR_BLACK)

    oPrinter:Say( 114-30,365,   OemToAnsi("Cpf/Cnpj..: "),oFont10N,,CLR_BLACK)
    oPrinter:Say( 114-30,365+60,OemToAnsi(Transform((cAlias)->(A2_CGC),"@R 99.999.999/9999-99")),oFont10N,,CLR_BLACK)

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


    cAlias1 := "KM_SOC"

    BeginSql alias cAlias1
        %NOPARSER%

        SELECT PC7_TIPO,SUM(PC7_TOTKM) AS PC7_TOTKM,SUM(PC7_TOTFRT)/SUM(PC7_TOTKM+0.0001) AS 'VUNIT',SUM(PC7_TOTFRT) AS PC7_TOTFRT
        FROM %Table:PC7% PC7
        WHERE PC7.%notDel% AND PC7_PERIOD=%Exp:MV_PAR01% AND PC7_CODTRA=%Exp:(cAlias)->(PC6_CODTRA)%
        GROUP BY PC7_TIPO

    EndSql

    xTotKm := 0

    oPrinter:Say( 161-35,011,OemToAnsi(" TOPICO"),oFont10N,,CLR_BLACK)
    oPrinter:Say( 161-35,081,OemToAnsi(" DESCRIÇÃO"),oFont10N,,CLR_BLACK)
    oPrinter:Say( 161-35,261,OemToAnsi("    REALIZADO"),oFont10N,,CLR_BLACK)
    oPrinter:Say( 161-35,341,OemToAnsi(" VALOR UNITARIO"),oFont10N,,CLR_BLACK)
    oPrinter:Say( 161-35,421,OemToAnsi(" TOTAL CREDITOS"),oFont10N,,CLR_BLACK)
    oPrinter:Say( 161-35,501,OemToAnsi(" TOTAL DEBITOS"),oFont10N,,CLR_BLACK)

    If (cAlias1)->( !Eof())

        oPrinter:Say( 161-35+18,011,OemToAnsi(" KM RODADOS"),oFont10,,CLR_BLACK)
        oPrinter:Say( 161-35+18,081,OemToAnsi("             "),oFont10,,CLR_BLACK)
        oPrinter:Say( 161-35+18,280,OemToAnsi(Transform((cAlias1)->(PC7_TOTKM),"@E 99,999.999")),oFont10,,CLR_BLACK)
        oPrinter:Say( 161-35+18,370,OemToAnsi(Transform((cAlias1)->(VUNIT),"@E 999.999")),oFont10,,CLR_BLACK)
        oPrinter:Say( 161-35+18,441,OemToAnsi(Transform((cAlias1)->(PC7_TOTFRT),"@E 999,999.99")),oFont10,,CLR_BLACK)
        oPrinter:Say( 161-35+18,501,OemToAnsi(""),oFont10,,CLR_BLACK)
        xTotKm += (cAlias1)->(PC7_TOTFRT)
    EndIf

    (cAlias1)->( dbskip() )

    If (cAlias1)->( !Eof())

        oPrinter:Say( 161-35+18+18,011,OemToAnsi(" SOCORRO"),oFont10,,CLR_BLACK)
        oPrinter:Say( 161-35+18+18,081,OemToAnsi("             "),oFont10,,CLR_BLACK)
        oPrinter:Say( 161-35+18+18,280,OemToAnsi(Transform((cAlias1)->(PC7_TOTKM),"@E 99,999.999")),oFont10,,CLR_BLACK)
        oPrinter:Say( 161-35+18+18,370,OemToAnsi(Transform((cAlias1)->(VUNIT),"@E 999.999")),oFont10,,CLR_BLACK)
        oPrinter:Say( 161-35+18+18,441,OemToAnsi(Transform((cAlias1)->(PC7_TOTFRT),"@E 999,999.99")),oFont10,,CLR_BLACK)
        oPrinter:Say( 161-35+18+18,501,OemToAnsi(""),oFont10,,CLR_BLACK)
        xTotKm += (cAlias1)->(PC7_TOTFRT)
    EndIf

    (cAlias1)->( dbCloseArea() )

    cAlias2 := "TOTBON"

    BeginSql alias cAlias2

        %NOPARSER%

        SELECT ISNULL(PBA_DESC,'BONIF. EXTRA') AS PBA_DESC,PC8_DESCRI,PC8_TOTBON,round(PC8_TOTBON/%Exp:xTotKm%,3) as VRUNIT
        FROM %Table:PC8% PC8
        LEFT JOIN %Table:PBA% PBA ON PBA_FILIAL=PC8_FILIAL AND PBA_CODIGO=SUBSTRING(PC8_CODBON,1,2) AND PBA.%notdel%
        WHERE PC8_PERIOD=%Exp:MV_PAR01% AND PC8_CODTRA=%Exp:(cAlias)->(PC6_CODTRA)% AND PC8.%notdel%

    EndSql



    nLinIni += 20
    nLinfin += 20
    nLi     := nLinIni
    nLi1    := nLinIni
    oPrinter:Say( nLi-3,011,OemToAnsi("PAGAMENTO POR QUALIDADE DE SERVIÇOS PRESTADOS"),oFont10N,,CLR_BLACK)
    nLi += 15
    While (cAlias2)->( !Eof() )

    	oPrinter:Box( nLinIni, 009, nLinfin, 581, "-1")
    	nLinIni += 18
    	nLinfin +=18


        oPrinter:Say( nLi,011,OemToAnsi((cAlias2)->(PBA_DESC)),oFont10,,CLR_BLACK)
        oPrinter:Say( nLi,081+10,OemToAnsi((cAlias2)->(PC8_DESCRI)),oFont10,,CLR_BLACK)
        oPrinter:Say( nLi,261,OemToAnsi("          "),oFont10,,CLR_BLACK)
        oPrinter:Say( nLi,381,OemToAnsi(Transform((cAlias2)->(VRUNIT),"@E 9.999")),oFont10,,CLR_BLACK)
        oPrinter:Say( nLi,441,OemToAnsi(Transform((cAlias2)->(PC8_TOTBON),"@E 999,999.99")),oFont10,,CLR_BLACK)
        oPrinter:Say( nLi,501,OemToAnsi(""),oFont10,,CLR_BLACK)
        nLi +=18
        (cAlias2)->( dbSkip() )

    EndDo
    (cAlias2)->( dbCloseArea() )

    oPrinter:Line( nLi1, 85, nLinfin-18, 85,10, "-1")
    oPrinter:Line( nLi1, 260, nLinfin-18,260,10, "-1")
    oPrinter:Line( nLi1, 340, nLinfin-18, 340,10, "-1")
    oPrinter:Line( nLi1, 420, nLinfin-18, 420,10, "-1")
    oPrinter:Line( nLi1, 500, nLinfin-18, 500,10, "-1")




    nLinIni += 15
    nLinfin +=15
    nLi := nLinIni
    For nMes := 1 to 3
    	oPrinter:Box( nLinIni, 009, nLinfin, 581, "-1")
    	nLinIni += 18
    	nLinfin +=18
    Next nMes

    oPrinter:Line( nLi, 420, nLinfin-18, 420,10, "-1")
    oPrinter:Line( nLi, 500, nLinfin-18, 500,10, "-1")

    nLi +=15
    oPrinter:Say( nLi,011,OemToAnsi("SUB-TOTAL DE CREDITOS.................................................................."),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,441,Transform((cAlias)->(PC6_VRFRT+PC6_VRBON),"@E 999,999.99"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,501,OemToAnsi(""),oFont10,,CLR_BLACK)

    nLi +=15
    oPrinter:Say( nLi,011,OemToAnsi("CREDITO IMPOSTOS......................................................................."),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,445,TransForm((cAlias)->(PC6_VRIMP),"@E 99,999.99"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,501,OemToAnsi(""),oFont10,,CLR_BLACK)

    nLi +=15
    oPrinter:Say( nLi,011,OemToAnsi("TOTAL CREDITOS........................................................................."),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,441,TransForm((cAlias)->(PC6_VRTOT),"@E 999,999.99"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,501,OemToAnsi(""),oFont10,,CLR_BLACK)


    cAlias3 := "TOTNDF"

    BeginSql alias cAlias3

        %NOPARSER%

        SELECT TOP 1 E2_FORNECE,E2_LOJA,E2_EMISSAO,E2_PARCELA,E2_SALDO,E2_HIST,E2_VENCREA FROM %Table:SE2% SE2 WHERE SE2.E2_TIPO='NDF' AND E2_FORNECE+E2_LOJA IN
       (SELECT LBB_CODFOR+LBB_LOJA FROM %Table:LBB% LBB WHERE LBB.%notdel% AND LBB_CODFOR=%Exp:(cAlias)->(PC6_CODTRA)% AND LBB_FILIAL=%Exp:cFilAnt% AND LBB_TIPREG='2')
        AND SE2.%notdel% AND E2_SALDO>0
        ORDER BY E2_FORNECE,E2_PARCELA

    EndSql



    nLinIni += 15
    nLinfin +=15
    nLi  := nLinIni
    For nMes := 1 to 2
    	oPrinter:Box( nLinIni, 009, nLinfin, 581, "-1")
    	nLinIni += 18
    	nLinfin +=18
    Next nMes

    oPrinter:Line( nLi, 80, nLinfin-18, 80,10, "-1")
    oPrinter:Line( nLi, 500, nLinfin-18, 500,10, "-1")

    nLi +=15
    oPrinter:Say( nLi,011,OemToAnsi("DEBITO"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,081,OemToAnsi(" NDF....................................................................................."),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,531,TransForm((cAlias3)->(E2_SALDO),"@E 99,999.99"),oFont10,,CLR_BLACK)


    nLi +=15
    oPrinter:Say( nLi,011,OemToAnsi("TOTAL DEBITOS"),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,081,OemToAnsi("........................................................................................."),oFont10,,CLR_BLACK)
    oPrinter:Say( nLi,531,TransForm((cAlias3)->(E2_SALDO),"@E 99,999.99"),oFont10,,CLR_BLACK)
    cTotRec := Transform((cAlias)->(PC6_VRTOT)-(cAlias3)->(E2_SALDO),"@E 999,999.99")
    oPrinter:Say( nLi+32,010,OemToAnsi("SALDO TOTAL A RECEBER........................................................................................R$ "+cTotRec),oFont10N,,CLR_BLACK)


    (cAlias3)->( DbCloseArea() )


    oPrinter:EndPage()
    (cAlias)->( dbskip() )

EndDo


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





