#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PRCONST.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TBICONN.CH"


User Function QUAR023B()

Local cAlias := GetNextAlias()

If Pergunte("QUAA023L",.T.)

    BeginSql Alias cAlias

        %noparser%

        SELECT PB9_LINHA,PA7_DESC,SUM(PB9_TOTKM) AS KM,0 AS BONIF,0 AS FRETE,0 AS CUSTO
        FROM PB9010 PB9
        INNER JOIN PA7010 PA7 ON PA7_FILIAL=PB9_FILIAL AND PA7_CODLIN=PB9_LINHA AND PA7.D_E_L_E_T_=''
        WHERE PB9.D_E_L_E_T_='' AND PB9_PERIOD='112020'
        GROUP BY PB9_LINHA,PA7_DESC
        ORDER BY PB9_LINHA

    EndSql

    ReportExcel(cAlias)

EndIf

Return


Static Function ReportExcel(cAlias)

	Local oExcel 	:= FWMsExcelEx():New()
	Local nConta	:= 0
	Local cArq := cGetFile (,, 1,, .F., GETF_RETDIRECTORY+GETF_LOCALHARD)
    Local cPasta := "CUSTO"
    cArq := cArq + "CUSTO_TRANSPORTADORA.XLS"

    oExcel:AddworkSheet(cPasta)
	oExcel:AddTable (cPasta,"Custo Transportadora")



    oExcel:AddColumn(cPasta,"Custo Transportadora","Cod.Linha")
    oExcel:AddColumn(cPasta,"Custo Transportadora","Linha")
    oExcel:AddColumn(cPasta,"Custo Transportadora","KM")
    oExcel:AddColumn(cPasta,"Custo Transportadora","Bonif.")
    oExcel:AddColumn(cPasta,"Custo Transportadora","Frete")
    oExcel:AddColumn(cPasta,"Custo Transportadora","Custo")


   //PB9_LINHA	PA7_DESC	KM	BONIF	FRETE	CUSTO

    While (cAlias)->( !Eof() )

        oExcel:AddRow(cPasta,"Custo Transportadora",{(cAlias)->(PB9_LINHA),(cAlias)->(PA7_DESC),(cAlias)->(KM),(cAlias)->(BONIF),(cAlias)->(FRETE),(cAlias)->(CUSTO)})
        //oExcel:AddRow(cPasta,"Custo Transportadora",)
        //oExcel:AddRow(cPasta,"Custo Transportadora",)
        //oExcel:AddRow(cPasta,"Custo Transportadora",)
        //oExcel:AddRow(cPasta,"Custo Transportadora",)
        //oExcel:AddRow(cPasta,"Custo Transportadora",()
        (cAlias)->( dbSkip() )

    EndDo

    MsgInfo("Planilha Gerada")

    //ProcessMessage()
	oExcel:Activate()
	oExcel:GetXMLFile(cArq)
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cArq)
	oExcelApp:SetVisible(.T.)

Return
