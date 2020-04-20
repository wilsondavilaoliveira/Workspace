#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xSativ3   ºAutor  ³Wilson Davila       º Data ³  08/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "PROTHEUS.CH"
#include "RWMAKE.CH"
#include "FWMVCDEF.CH"
#include "FWMBROWSE.CH"
#include "TBICONN.CH"
#include "TOPCONN.CH"
#include "FILEIO.CH"
#Include 'Totvs.ch' 
#INCLUDE 'COLORS.CH'
#INCLUDE "PRCONST.CH"
#INCLUDE "FONT.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} CadSus
Controle de formulario de autorizacao de devolucao enviados pelo Tablet AFV
@author Wilson Oliveira
@since 06/01/2020
@version 1.0
@param                                    
@type          
/*/
//-------------------------------------------------------------------
User Function CadSus

Local oBrowse := FwLoadBrw("CadSus")

oBrowse:Activate()
Return

//----------------------------------------------------------
// Função MenuDef
//----------------------------------------------------------

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' 	ACTION 'VIEWDEF.CadSus' OPERATION 2 ACCESS 0
//ADD OPTION aRotina TITLE 'Envia E-mail'	ACTION 'U_WfForDev(AllTrim(ZXO->ZXO_NUMDEV))' OPERATION 2  ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.CadSus' OPERATION 4 ACCESS 0
//ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.CadSus' OPERATION 5 ACCESS 0
//ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.CadSus' OPERATION 8 ACCESS 0
//ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.CadSus' OPERATION 9 ACCESS 0

Return aRotina


Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("SUS")
    oBrowse:SetDescription("Prospects")

   oBrowse:SetMenuDef("CadSus")
   oBrowse:AddLegend( "SUS->US_STATUS == '1'", "BR_MARROM"		, "Classificado")
   oBrowse:AddLegend( "SUS->US_STATUS == '2'", "BR_VERMELHO" 	, "Desenvolvimento")
   oBrowse:AddLegend( "SUS->US_STATUS == '3'", "BR_AZUL"	  	, "Gerente")
   oBrowse:AddLegend( "SUS->US_STATUS == '4'", "BR_AMARELO"  	, "Standy by")
   oBrowse:AddLegend( "SUS->US_STATUS == '5'", "BR_PRETO"	  	, "Cancelado")
   oBrowse:AddLegend( "SUS->US_STATUS == '6'", "BR_VERDE"	  	, "Cliente") 
   oBrowse:AddLegend( "Empty(SUS->US_STATUS)", "BR_BRANCO"	   	, "Maling (sem status)")			
   
   
   oBrowse:SetAmbiente(.F.)        //Desabilita opcao Ambiente do menu Acoes Relacionadas
   oBrowse:SetWalkThru(.F.)        //Desabilita opcao WalkThru do menu Acoes Relacionadas
  
   
Return (oBrowse)

//----------------------------------------------------------
// Função ModelDef
//----------------------------------------------------------
Static Function ModelDef()

 Local oModel := MPFormModel():New("CadSusM")

    // INSTANCIA OS SUBMODELOS
    Local oStruZXO := FwFormStruct(1, "SUS")
    
    // DEFINE SE OS SUBMODELOS SERÃO FIELD OU GRID
    oModel:AddFields("SUSMASTER", NIL, oStruZXO)
   
    // Chave Primaria
    oModel:SetPrimaryKey( {'SUS_COD'} )
    
    // DEFINE A RELACAO ENTRE OS SUBMODELOS
    //oModel:SetRelation("ZXQDETAIL", {{"ZXQ_NUMDEV", "ZXO_NUMDEV"}}, ZXQ->(IndexKey( 1 )))

    // DESCRICAO DO MODELO
    oModel:SetDescription("Prospects" )

    // DESCRICAO DOS SUBMODELOS
    oModel:GetModel("SUSMASTER"):SetDescription("Prospects")
    //oModel:GetModel("ZXQDETAIL"):SetDescription("Itens Formulario Devolucao")

Return oModel

//----------------------------------------------------------
// Função ViewDef
//----------------------------------------------------------
Static Function ViewDef()

  // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // INSTANCIA AS SUBVIEWS
    Local oStruSUS := FwFormStruct(2, "SUS")
    //Local oStruZXQ := FwFormStruct(2, "ZXQ")

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("CadSus")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SUS", oStruSUS, "SUSMASTER")
    //oView:AddGrid("VIEW_ZXQ", oStruZXQ, "ZXQDETAIL")

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("SUPERIOR", 40)
    //oView:CreateHorizontalBox("INFERIOR", 60)

    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VIEW_SUS", "SUPERIOR")
    //oView:SetOwnerView("VIEW_ZXQ", "INFERIOR")

    // DEFINE OS TITULOS DAS SUBVIEWS
    oView:EnableTitleView("VIEW_SUS","PROSPECTS")
    //oView:EnableTitleView("VIEW_ZXQ","ITENS DEVOLUCOES")

Return oView


/*
User Function CadSus()
//--------------------------------------------------------------

Private cCadastro := OemtoAnsi( "Cadastro de pre-clientes" )
Private cFiltro		:= ""
Private bFiltraBrw	:= {|| }
Private aIndexSX5	:= {}
Private cAlias		:= "SUS"
Private nOpc		:= 0
Private cUser		:= __cUserID
//Private aCpos		:= {'X5_DESCRI','X5_DESCSPA','X5_DESCENG'}
//UsrRetMail ( [ __cUserID ] ) 
//SetKey( VK_F5 , { || U_ViewSUS() } )
//AxCadastro("SUS")

//RETURN
Private aRotina := {	{"Pesquisar"		,"AxPesqui",0,1},;
						{"Visualiza"		,"U_ViewSUS(2)",0,2},;
						{"Altera"			,"U_ViewSUS(4)",0,4},;
						{"Inclui"		 	,"MsgAlert('Nao e permitida inclusao!')",0,4}}

aCores := {	{ ".T.", "BR_VERDE"}}

dbSelectArea("SUS")
dbSetOrder(1)
mBrowse(6,1,22,75,cAlias,,,,,,aCores,,,,,,.F.)


Return

User Function ViewSUS(xOpc)

Local bOk := {|| Grava(oDlg1)}
Local bCancel:= {|| oDlg1:end() }
Local aSize1 := {}
Private oDlg1

ZXI->(dbSetOrder(1))

If ZXI->(dbSeek(cUser))

	nOpc := xOpc
	aSize1 := MsAdvSize(.T.)
	
  DEFINE MSDIALOG oDlg1 TITLE "Altera Campos Pre-clientes" FROM aSize1[7],0 To aSize1[6],aSize1[5] COLORS 0, 16777215 PIXEL
  	oDlg1:lMaximized := .T. 
    RegToMemory("SUS", .F., .F.)
    fEnchoic1()

  ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1, bOk , bCancel) CENTERED

Else

	MsgStop("Usuario sem autorizacao para alteracao!")

EndIf

Return

//------------------------------------------------ 
Static Function fEnchoic1()
//------------------------------------------------

Local aFields 		:= {}
Local aAlterFields 	:= {}
Local aCampos		:= {}
Local aSize 		:= {}
Local cCampo		:= ''
Local nCount		:= 0
Static oEnchoic1

ZXI->(dbSetOrder(1))
ZXI->(dbSeek(cUser))

AADD(aCampos,{"NOUSERS"})  

ZXZ->(dbSetOrder(2))
IF ZXZ->(dbSeek(ZXI->(ZXI_CODDEP)))
	While ZXZ->( !Eof() ) .AND. ZXZ->(ZXZ_GRUPO) == ZXI->(ZXI_CODDEP)
		AADD(aCampos,{"US_"+AllTrim(SubStr(ZXZ->(ZXZ_CAMPO),4,7))})
		nCount ++
		ZXZ->(dbSkip())
	EndDo

	aAlterFields 	:= Array(nCount+1)
	aFields			:= Array(nCount+1)
	
	For a := 2 To Len(aAlterFields)
		aAlterFields[a-1] := aCampos[a][1]
	Next a
	
	For b := 1 To Len(aFields)
		aFields[b] := aCampos[b][1]
	Next b

EndIf

//aFields := {"NOUSERS","US_NOME","US_TIPO","US_CGC","US_END"}
//aAlterFields := {"US_NOME","US_TIPO","US_CGC","US_END"}
  
  aSize := MsAdvSize(.T.,.T.)
  oEnchoic1 := MsMGet():New("SUS",0,nOpc,,,,aFields,{30,1,aSize[6],aSize[5]},aAlterFields,1,,.T.,.F.,oDlg1,.F.,.T.,,,.T.)
 
Return

Static function Grava(oDlg1)

	If MsgYesNo("Deseja salvar?")
	
		RecLock("SA1",.F.)
		
			SA1->A1_XKA		:= M->A1_XKA 
			SA1->A1_SATIV3	:= M->A1_SATIV3
			SA1->A1_SATIV4	:= M->A1_SATIV4
			SA1->A1_SATIV5	:= M->A1_SATIV5
			SA1->A1_SATIV6 	:= M->A1_SATIV6 
			SA1->A1_SATIV7	:= M->A1_SATIV7
			SA1->A1_SATIV8	:= M->A1_SATIV8
			SA1->A1_XBAND1	:= M->A1_XBAND1
			SA1->A1_XMOTTAB := M->A1_XMOTTAB
			
			
			If Empty(M->A1_SATIV8) .AND. M->A1_TABELA<>SA1->A1_TABELA //Grava tabela anterior se o campo estiver em branco, usado para comparar as tabelas 
				SA1->A1_SATIV8	:= SA1->A1_TABELA
				SA1->A1_TABELA	:= M->A1_TABELA
			End If
		
			If M->A1_TABELA<>SA1->A1_TABELA
				SA1->A1_TABELA	:= M->A1_TABELA
			End If
		
		MsUnlock()
	
		oDlg1:End()
	
	End If



Return

/////////////////////////////////////////////
User Function AxZXJ()



AxCadastro("ZXJ",'Cadastro Departamentos')



Return()

///////////////////////////////////////////////
User Function AxZxi()



AxCadastro("ZXI",'Cadastro Usuarios x Depto')



Return()

/////////////////////////////////////////////
User Function AxZXZ()


U_xZXZCpo()
AxCadastro("ZXZ",'Cadastro Campos WorkFlow-SUS')



Return()

User Function xZXZCpo()

Local cReservObrig 	:= '' 
Local cUsadoObrig	:= ''
Local cRet			:= ''
Local aArea			:= GetArea()

dbSelectArea("SX3")
SX3->(DbSetOrder(1))

If SX3->(MsSeek("SA1"))
	
	While SX3->( !Eof() ) .AND. Alltrim(SX3->(X3_ARQUIVO)) == 'SA1'
		
		If X3USO(SX3->(X3_USADO)) .AND. X3Obrigat(SX3->(X3_CAMPO)) .AND. !AllTrim(SX3->(X3_CAMPO)) $ "A1_COD|A1_LOJA" 
		//cRet += pad(SX3->(X3_CAMPO),10," ")+"="+X3Titulo(SX3->(X3_CAMPO))+";"
		
		ZXZ->(dbSetOrder(1))
			If !ZXZ->(dbSeek(SX3->(X3_CAMPO)))
				RecLock("ZXZ",.T.)
					ZXZ->ZXZ_CAMPO := SX3->(X3_CAMPO)
					ZXZ->ZXZ_GRUPO := '0001'
				MsUnlock()
			End If
		
		End If
		SX3->(dbSkip())
		
	EndDo

End If

RestArea(aArea)

Return 

User Function cZXZCpo(cCampo)

Local cReservObrig 	:= '' 
Local cUsadoObrig	:= ''
Local cRet			:= ''
Local aArea			:= GetArea()

dbSelectArea("SX3")
SX3->(DbSetOrder(2))

If SX3->(MsSeek(cCampo))

	cRet := X3Titulo(SX3->(X3_CAMPO))

End If

RestArea(aArea)

Return cRet 
*/ 







