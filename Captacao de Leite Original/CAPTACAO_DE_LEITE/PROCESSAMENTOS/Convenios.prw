#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     ºAutor  ³Microsiga           º Data ³  07/30/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Convenios(cFil,cFor,cLoja,cEmis,cOpc)

Local aConvenio := {}                                                
Local cQuery	:= ''

cQuery := "SELECT PA6_TIPDES,LBR_DESC,Sum(PA6_VALOR) AS PA6_VALOR FROM " + RetSqlName('PA6') + " PA6 INNER JOIN " + RetSqlName('LBR') + " LBR"
cQuery += " ON LBR_FILIAL=PA6_FILIAL AND LBR_TIPDES=PA6_TIPDES"
cQuery += " WHERE PA6_CODPRO IN (SELECT LBB_CODPRO FROM " + RetSqlName('LBB') + " LBB WHERE LBB_CODFOR='" + cFor + "' AND LBB_LOJA='" + cLoja + "' AND D_E_L_E_T_='')"
cQuery += " AND PA6_PERIOD='" + cEmis + "' AND PA6_FILIAL='" + cFil + "' AND PA6.D_E_L_E_T_='' GROUP BY PA6_TIPDES,LBR_DESC "  	

memowrite("C:\EDI\CONVENIOS.SQL",cQuery)

If Select( "QUERY" ) > 0
	QUERY->( dbCloseArea() )
End If

dbUseArea( .T., "TOPCONN", TCGenQry( ,,cQuery ), "QUERY", .F., .F. )
QUERY->( dbGoTop() ) 

	if cOpc == '1'
	
	While QUERY->( !Eof() )
    aadd(aConvenio,{QUERY->PA6_TIPDES,QUERY->PA6_VALOR})
    QUERY->( dbSkip() )
    End While
    
    Else
    
	While QUERY->( !Eof() )
    aadd(aConvenio,AllTrim(QUERY->LBR_DESC) + SPACE(30-LEN(AllTrim(QUERY->LBR_DESC))) + ": " + cValToChar(Transform(QUERY->PA6_VALOR,"@r 999,999.99")) )
    QUERY->( dbSkip() )
    End While

    End IF

Return (aConvenio)




