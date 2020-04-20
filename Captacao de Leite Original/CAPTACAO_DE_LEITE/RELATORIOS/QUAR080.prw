#include "rwmake.ch"
#INCLUDE "Topconn.ch"
//-- Programa        : QUAR080.PRW
//-- Objetivo        : Relatorio para extração de dados de Pedidos Liberados e Bloqueados
//-- Autor Relatorio : Renato Ruy
//-- Data/Hora       : 03/09/19 10:05 hs
//-- Uso             : Especifico Novamix
//-- Alteracao       :   /  /

////////////////////////
User Function QUAR080()
	////////////////////////
	fImpr()
Return

///////////////////////
Static Function fImpr()
	///////////////////////
	
	Local bValid := {|| .T. }
	Local aPar 	 := {}
	Local dDiaF	:= StoD(Substr(DtoS(Date()),1,6)+"01")-1
	Local dDiaI	:= LastDay(dDiaF,1)
	Local cArq	   := RTrim(GetTempPath())+"QUAR080"+DtoS(dDatabase)+StrTran(Time(),":","")+".xls"
	
	Private oExcel := FWMsExcelEx():New()
	Private aRet 		:= {}
	
	//Utilizo parambox para fazer as perguntas
	aAdd( aPar,{ 1  ,"Data De"	 	,dDiaI,"@D","","","",50,.F.})
	aAdd( aPar,{ 1  ,"Data Até"		,dDiaF,"@D","","","",50,.F.})
	
	ParamBox( aPar, 'Parâmetros', @aRet, bValid, , , , , ,"QUAR080" , .T., .F. )
	If Len(aRet) > 0
		Processa( {|| QUAR080Q() }, "Gerando Rastreamento Leite Produtor...")
		Processa( {|| QUAR080S() }, "Gerando Rastreamento Leite Spot...")
		
		IncProc( "Abre o relatorio em tela ...")
		ProcessMessage()
		oExcel:Activate()
		oExcel:GetXMLFile(cArq)
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cArq)
		oExcelApp:SetVisible(.T.)
		
	Else
		Alert("Rotina Cancelada!")
	EndIf
Return

//Renato Ruy - 25/10/2018
//Efetua consulta de dados
Static Function QUAR080Q
	
	Local nRegua   := 0
	Local cDataIni := DtoS(aRet[1])
	Local cDataFim := DtoS(aRet[2])
	
	//Exclui arquivo caso exista
	If Select("TMPPRO") > 0
		DbSelectArea("TMPPRO")
		TMPPRO->(DbCloseArea())
	Endif
	
	IncProc( "Consultando dados ...")
	ProcessMessage()
	
	Beginsql Alias "TMPPRO"
		
		//PARA NAO EXECUTAR O CHANGEQUERY
		%NOPARSER%
		
		SELECT 	FILIAL_KEY FILKEY,         
		        convert(varchar, DATA_KEY, 103) DATAKEY,          
	            FACT.PROPRIEDADE_KEY PROPKEY,
	            PROPRIEDADE_NOME PROPNOME,
	            FACT.FORNECEDOR_KEY FORNKEY,
	            FORNECEDOR_NOME FORNNOME,
	            LINH.LINHA_LEITE_KEY+'-'+LINH.LINHA_LEITE_NOME AS LIN_LEITE,
	            LEITE_COLETADO_LITROS LITROS
		FROM BI_FACT_LEITE_COLETADO FACT            
		LEFT JOIN BI_DIM_FORNECEDORES FORN ON FORN.FORNECEDOR_KEY  = FACT.FORNECEDOR_KEY           
		LEFT JOIN BI_DIM_PROPRIEDADES PROP ON PROP.PROPRIEDADE_KEY = FACT.PROPRIEDADE_KEY          
		LEFT JOIN BI_DIM_LINHA_LEITE  LINH ON LINH.LINHA_LEITE_KEY = FACT.LINHA_LEITE_KEY          
		WHERE convert(varchar, DATA_KEY, 112) BETWEEN %EXP:cDataIni% AND %EXP:cDataFim%             
		AND FILIAL_KEY = '10'         
		ORDER BY FILIAL_KEY, DATA_KEY, PROPKEY     
	    
	Endsql
	
	IncProc( "Imprimindo relatorio ...")
	ProcessMessage()
	
	//Ajusta parametros da regua
	While !TMPPRO->(EOF())
		nRegua++
		TMPPRO->(DBSKIP())
	Enddo
	TMPPRO->(DbGoTop())
	ProcRegua(nRegua)
	
	//Chama rotina para gerar arquivo excel
	If nRegua > 0
		QUAR080R(nRegua)
	Endif
	
Return

//Renato Ruy - 25/10/2018
//Gera arquivo no formato XLS
Static Function QUAR080R
	oExcel:AddworkSheet("LEITE PRODUTOR")
	oExcel:AddTable ("LEITE PRODUTOR","Leite Produtor")
	
	oExcel:AddColumn("LEITE PRODUTOR","Leite Produtor","Filial"					,1,1)
	oExcel:AddColumn("LEITE PRODUTOR","Leite Produtor","Data"					,1,1)
	oExcel:AddColumn("LEITE PRODUTOR","Leite Produtor","Codigo Propriedade"		,1,1)
	oExcel:AddColumn("LEITE PRODUTOR","Leite Produtor","Nome Propriedade"		,1,1)
	oExcel:AddColumn("LEITE PRODUTOR","Leite Produtor","Fornecedor"				,1,1)
	oExcel:AddColumn("LEITE PRODUTOR","Leite Produtor","Razao Social Fornecedor"	,1,1)
	oExcel:AddColumn("LEITE PRODUTOR","Leite Produtor","Linha Leite"				,1,1)
	oExcel:AddColumn("LEITE PRODUTOR","Leite Produtor","Litros"					,1,1)
	
	While !TMPPRO->(EOF())
		oExcel:AddRow("LEITE PRODUTOR","Leite Produtor",{TMPPRO->FILKEY,;
												TMPPRO->DATAKEY,;
												TMPPRO->PROPKEY,;
												TMPPRO->PROPNOME,;
												TMPPRO->FORNKEY,;
												TMPPRO->FORNNOME,;
												TMPPRO->LIN_LEITE,;
												TMPPRO->LITROS})
				
		TMPPRO->(DBSKIP())
		IncProc()
	Enddo
	
Return

//Renato Ruy - 25/10/2018
//Efetua consulta de dados
Static Function QUAR080S
	
	Local nRegua   := 0
	Local cDataIni := DtoS(aRet[1])
	Local cDataFim := DtoS(aRet[2])
	
	//Exclui arquivo caso exista
	If Select("TMPSPO") > 0
		DbSelectArea("TMPSPO")
		TMPSPO->(DbCloseArea())
	Endif
	
	IncProc( "Consultando dados ...")
	ProcessMessage()
	
	Beginsql Alias "TMPSPO"
		
		//PARA NAO EXECUTAR O CHANGEQUERY
		%NOPARSER%
		
		SELECT  F1_FILIAL  AS FILKEY,
				D1_DOC NOTA,
	            CONVERT(VARCHAR,CAST(F1_DTDIGIT AS date),103) DATAKEY,
	            F1_FORNECE+'-'+F1_LOJA FORNKEY,
	            A2_NOME AS FORNNOME,
	            A2_EST EST,
	            D1_COD PRODUTO,
	            SUM(D1_QUANT) LITROS,
	            ROUND(SUM(D1_CUSTO),2) CUSTO,
	            ROUND(SUM(D1_TOTAL),2) TOTAL_ITEM,
	            ROUND(SUM(D1_BASIMP5),2) BCALCULO,
		        ROUND(SUM(D1_VALIMP5),2) COFINS,
		        ROUND(SUM(D1_VALIMP6),2) PIS,
		        ROUND((D1_ALQIMP5),2) AS PERCOFINS,
		        ROUND((D1_ALQIMP6),2) AS PERPIS,
	            F4_LFICM FISICMS,
	            F1_ICMSRET ICMSSOL,
	            F1_VALICM VALICMS,
	            D1_PICM ALIQICMS,
	            F1_TPFRETE TPFRETE,
	            ROUND(SUM(ISNULL(LTCAPRLIQ,0)),2) FRETE_LIQ,
	            ROUND(SUM(ISNULL(LTCAPRPBR,0)),2) FRETE_BR
	FROM [SF1010] SF1 (NOLOCK)           
	INNER JOIN [DADOSADV].[dbo].[SD1010] SD1 (NOLOCK) ON D1_FILIAL=F1_FILIAL AND D1_SERIE=F1_SERIE AND D1_DOC=F1_DOC AND D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA AND SD1.D_E_L_E_T_=''             
	INNER JOIN [DADOSADV].[dbo].[SF4010] SF4 (NOLOCK) ON F4_CODIGO=D1_TES AND SF4.D_E_L_E_T_=''         
	INNER JOIN [DADOSADV].[dbo].[SB1010] SB1 (NOLOCK) ON D1_COD=B1_COD AND SB1.D_E_L_E_T_=''            
	INNER JOIN [DADOSADV].[dbo].[SA2010] SA2 (NOLOCK) ON A2_COD=F1_FORNECE AND A2_LOJA = F1_LOJA AND SA2.D_E_L_E_T_=''
	LEFT JOIN [DADOSADV].[dbo].[SF8010] SF8 (NOLOCK) ON F8_FORNECE = F1_FORNECE AND F8_LOJA = F1_LOJA AND F8_NFORIG = F1_DOC AND F1_FILIAL = F8_FILIAL AND SF8.D_E_L_E_T_ = ''
	LEFT JOIN (SELECT ROUND(SUM(D1_QUANT),2)  AS 'LEITECAPLP',SUM(D1_CUSTO) AS 'LTCAPRLIQ',ROUND(SUM(D1_TOTAL)+SUM(F1_XINCEN),2) AS 'LTCAPRPBR',D1_COD AS 'PRODUTO',SB1.B1_DESC AS DESC_PROD,F1_DOC NFORIG, F1_SERIE SERORIG,F1_FORNECE FORNECE
    FROM [DADOSADV].[dbo].[SF1010] SF1 (NOLOCK) 
    INNER JOIN [DADOSADV].[dbo].[SD1010] SD1 (NOLOCK) ON D1_FILIAL=F1_FILIAL AND D1_SERIE=F1_SERIE AND D1_DOC=F1_DOC AND D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA AND SD1.D_E_L_E_T_='' 
    INNER JOIN [DADOSADV].[dbo].[SF4010] F4 (NOLOCK)ON F4_CODIGO=D1_TES AND F4.D_E_L_E_T_='' 
    INNER JOIN [DADOSADV].[dbo].[SB1010] SB1 (NOLOCK) ON D1_COD=B1_COD AND SB1.D_E_L_E_T_='' 
    WHERE SF1.D_E_L_E_T_=''
    AND D1_COD IN( '200113','200136') 
    AND F1_FORNECE+F1_LOJA+F1_DOC IN (SELECT F8.F8_TRANSP+F8.F8_LOJTRAN+F8.F8_NFDIFRE FROM [DADOSADV].[dbo].[SF8010] F8 (NOLOCK) WHERE F8.F8_FORNECE NOT IN (SELECT LBB_CODFOR FROM [DADOSADV].[dbo].[LBB010] LBB (NOLOCK) WHERE LBB_CODFOR=F8.F8_FORNECE AND LBB.D_E_L_E_T_='') ) 
    GROUP BY F1_FILIAL,F1_DTDIGIT,D1_COD,SB1.B1_DESC,F1_DOC,F1_SERIE,F1_FORNECE) TRB ON NFORIG = F8_NFDIFRE AND SERORIG = F8_SEDIFRE AND FORNECE = F8_TRANSP
	WHERE SF1.D_E_L_E_T_ = ' '
	AND F4_ESTOQUE='S' AND D1_TIPO IN('N','C','I') AND D1_COD IN ('200113','200136')
	AND F1_FORNECE NOT IN ('009644','011000','012433','013038','010432','010421','004685')
	AND F1_FORNECE+D1_LOJA NOT IN (SELECT LBB_CODFOR+LBB_LOJA FROM [DADOSADV].[dbo].[LBB010] LBB (NOLOCK) WHERE LBB_FILIAL=F1_FILIAL AND F1_FORNECE=LBB_CODFOR AND F1_LOJA=LBB_LOJA AND LBB.D_E_L_E_T_='')
	AND F1_ESPECIE NOT IN ('NFST','CTE','CTR','NFS')
	AND F1_DTDIGIT BETWEEN %EXP:cDataIni% AND %EXP:cDataFim%
	AND F1_FILIAL = '10'
	GROUP BY D1_ALQIMP5,D1_DOC,D1_ALQIMP6,F1_FILIAL,D1_COD,F1_DTDIGIT,F1_FORNECE,F1_LOJA,A2_NOME,F1_TPFRETE,F1_ICMSRET,F1_VALICM,F4_LFICM,A2_EST,D1_PICM 
	ORDER BY F1_FILIAL,F1_DTDIGIT,F1_FORNECE,F1_LOJA,A2_NOME     
	    
	Endsql
	
	IncProc( "Imprimindo relatorio ...")
	ProcessMessage()
	
	//Ajusta parametros da regua
	While !TMPSPO->(EOF())
		nRegua++
		TMPSPO->(DBSKIP())
	Enddo
	TMPSPO->(DbGoTop())
	ProcRegua(nRegua)
	
	//Chama rotina para gerar arquivo excel
	If nRegua > 0
		QUAR080T(nRegua)
	Endif
	
Return

//Renato Ruy - 25/10/2018
//Gera arquivo no formato XLS
Static Function QUAR080T
	oExcel:AddworkSheet("LEITE SPOT")
	oExcel:AddTable ("LEITE SPOT","Leite Spot")
	
                    

	
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Filial"					,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Nota"					,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Data Digitacao"			,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Fornecedor"				,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Razao Social Fornecedor"	,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Estado"					,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Produto"					,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Entrada de Leite Litros"	,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Custo"					,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Total Item"				,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Base Calculo"			,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Cofins"					,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","PIS"						,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Percentual Cofins"		,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Percentual PIS"			,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","L.Fiscal ICMS"			,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","ICMS Solid."				,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Vlr.ICMS"				,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Aliq. ICMS"				,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Tipo Frete"				,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Frete Litro Liquido"		,1,1)
	oExcel:AddColumn("LEITE SPOT","Leite Spot","Frete Litro Bruto"		,1,1)
	
	While !TMPSPO->(EOF())
		
		oExcel:AddRow("LEITE SPOT","Leite Spot",{TMPSPO->FILKEY,;
												TMPSPO->NOTA,;
										        TMPSPO->DATAKEY,;
										        TMPSPO->FORNKEY,;
										        TMPSPO->FORNNOME,;
										        TMPSPO->EST,;
										        TMPSPO->PRODUTO,;
										        TMPSPO->LITROS,;
										        TMPSPO->CUSTO,;
										        TMPSPO->TOTAL_ITEM,;
										        TMPSPO->BCALCULO,;
										        TMPSPO->COFINS,;
										        TMPSPO->PIS,;
										        TMPSPO->PERCOFINS,;
										        TMPSPO->PERPIS,;
										        TMPSPO->FISICMS,;
										        TMPSPO->ICMSSOL,;
										        TMPSPO->VALICMS,;
										        TMPSPO->ALIQICMS,;
										        TMPSPO->TPFRETE,;
										        TMPSPO->FRETE_LIQ,;
										        TMPSPO->FRETE_BR})
				
		TMPSPO->(DBSKIP())
		IncProc()
	Enddo
	
Return
