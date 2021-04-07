#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE "PRCONST.CH"
#INCLUDE "FONT.CH"
#include "TBICONN.CH"


#include "fwmvcdef.ch"

#define MVC_TITLE "Geracao de Cte/Nfs"
#define MVC_ALIAS "PC9"
#define MVC_VIEWDEF_NAME "VIEWDEF.QUAA023M"

//-------------------------------------------------------------------
/*/{Protheus.doc} U_MVCGRID
Função principal da rotina MVC

@author Daniel Mendes
@since 10/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
user function QUAA023M()
//Inserção - Inclusão de itens
//FWExecView( getTitle(MODEL_OPERATION_INSERT), MVC_VIEWDEF_NAME, MODEL_OPERATION_INSERT)

//Visualização - Verificar os itens incluídos
//FWExecView( getTitle(MODEL_OPERATION_VIEW), MVC_VIEWDEF_NAME, MODEL_OPERATION_VIEW)

//Alteração - Por ser um grid, a alteração já vai permitir a exclusão
If PC6->PC6_STATUS == 'P'
    Pergunte("QUAA023L",.F.)

    FWExecView( getTitle(MODEL_OPERATION_UPDATE), MVC_VIEWDEF_NAME, MODEL_OPERATION_UPDATE)
Else
    MsgStop("Fechamento nao efetuado, nao e possivel emitir as notas")
EndIf

//Visualização - Verificar os itens adicionados, alterados ou excluidos
//FWExecView( getTitle(MODEL_OPERATION_VIEW), MVC_VIEWDEF_NAME, MODEL_OPERATION_VIEW)
//U_EXEC103()
//U_rmata116()
return

//-------------------------------------------------------------------
/*/{Protheus.doc} getTitle
Retorna o título para a janela MVC, conforme operação

@param nOperation - Operação do modelo

@return cTitle - String com o título da janela

@author Daniel Mendes
@since 10/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
static function getTitle(nOperation)
local cTitle as char

if nOperation == MODEL_OPERATION_INSERT
    cTitle := "Inclusão"
elseif nOperation == MODEL_OPERATION_UPDATE
    cTitle := "Alteração"
else
    cTitle := "Visualização"
endif

return cTitle

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Montagem do modelo dados para MVC

@return oModel - Objeto do modelo de dados

@author Daniel Mendes
@since 10/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
static function ModelDef()
local oModel as object
local oStrField as object
local oStrGrid as object

// Estrutura Fake de Field
oStrField := FWFormModelStruct():New()

oStrField:addTable("", {"C_STRING1"}, MVC_TITLE, {|| ""})
oStrField:addField("String 01", "Campo de texto", "C_STRING1", "C", 15)

//Estrutura de Grid, alias Real presente no dicionário de dados
oStrGrid := FWFormStruct(1, MVC_ALIAS)
oModel := MPFormModel():New("MIDMAIN")

oModel:addFields("CABID", /*cOwner*/, oStrField, /*bPre*/, /*bPost*/, {|oMdl| loadHidFld()})

oModel:addGrid("GRIDID", "CABID", oStrGrid, /*bLinePre*/, /*bLinePost*/, /*bPre*/, /*bPost*/, {|oMdl| loadGrid(oMdl)})

oModel:setDescription(MVC_TITLE)

// É necessário que haja alguma alteração na estrutura Field
oModel:setActivate({ |oModel| onActivate(oModel)})

return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} onActivate
Função estática para o activate do model

@param oModel - Objeto do modelo de dados

@author Daniel Mendes
@since 10/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
static function onActivate(oModel)

//Só efetua a alteração do campo para inserção
if oModel:GetOperation() == MODEL_OPERATION_INSERT
    FwFldPut("C_STRING1", "FAKE" , /*nLinha*/, oModel)
endif

return

//-------------------------------------------------------------------
/*/{Protheus.doc} loadGrid
Função estática para efetuar o load dos dados do grid

@param oModel - Objeto do modelo de dados

@return aData - Array com os dados para exibição no grid

@author Daniel Mendes
@since 10/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
static function loadGrid(oModel)
local aData as array
local cAlias as char
local cWorkArea as char
local cTablename as char

cWorkArea := Alias()
cAlias := GetNextAlias()
cTablename := "%" + RetSqlName(MVC_ALIAS) + "%"

BeginSql Alias cAlias
    SELECT *, R_E_C_N_O_ RECNO
      FROM %exp:cTablename%
    WHERE D_E_L_E_T_ = ' ' AND PC9_PERIOD=%Exp:MV_PAR01% AND PC9_FILIAL=%Exp:cFilAnt%
    ORDER BY PC9_CODTRA,PC9_TIPDOC
EndSql

aData := FwLoadByAlias(oModel, cAlias, MVC_ALIAS, "RECNO", /*lCopy*/, .T.)

(cAlias)->(DBCloseArea())

if !Empty(cWorkArea) .And. Select(cWorkArea) > 0
    DBSelectArea(cWorkArea)
endif

return aData

//-------------------------------------------------------------------
/*/{Protheus.doc} loadHidFld
Função estática para load dos dados do field escondido

@param oModel - Objeto do modelo de dados

@return Array - Dados para o load do field do modelo de dados

@author Daniel Mendes
@since 10/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
static function loadHidFld(oModel)
return {""}

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Função estática do ViewDef

@return oView - Objeto da view, interface

@author Daniel Mendes
@since 10/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
static function viewDef()
local oView as object
local oModel as object
local oStrCab as object
local oStrGrid as object

// Estrutura Fake de Field
oStrCab := FWFormViewStruct():New()

oStrCab:addField("C_STRING1", "01" , "String 01", "Campo de texto", , "C" )

//Estrutura de Grid
oStrGrid := FWFormStruct(2, MVC_ALIAS )
oModel := FWLoadModel("QUAA023M")
oView := FwFormView():New()

oView:setModel(oModel)
oView:addField("CAB", oStrCab, "CABID")
oView:addGrid("GRID", oStrGrid, "GRIDID")
oView:SetNoDeleteLine("GRID")
oView:SetNoInsertLine("GRID")

//FWFORMVIEW():SetFieldAction(<cIDField >, <bAction >)
oView:SetFieldAction( 'PC9_CHVNFE', { |oView, cIDView, cField, xValue| gLine( oView, cIDView, cField, xValue,oModel ) } )



cCSS := "QTableView { selection-background-color: #ade0ff; font-weight:bold;font-size:11px }"
cCSS += "QHeaderView::section { background-color: qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #616161, stop: 0.5 #505050, stop: 0.6 #434343,  stop:1 #656565); color: white; padding-left: 4px; border: 1px solid #6c6c6c; }"

oView:SetViewProperty( "GRID", "SETCSS", {cCSS} )

oView:createHorizontalBox("TOHIDE", 0 )
oView:createHorizontalBox("TOSHOW", 100 )
oView:setOwnerView("CAB", "TOHIDE" )
oView:setOwnerView("GRID", "TOSHOW")

oView:setDescription( MVC_TITLE )

return oView

Static Function gLine( oView, cIDView, cField, xValue ,oModel)

Local oModelPC9 := oModel:GetModel('GRIDID')

//MsgAlert(cValToCHar(oModelPC9:GetLine() ))
 //oModelPC9:GoLine(oModelPC9:GetLine()+1)
oModelPC9:GoLine(oModelPC9:GetLine()+1)
oView:Refresh('GRIDID')

Return
*===============================================================================================================================
*===============================================================================================================================
*===============================================================================================================================
*===============================================================================================================================
*===============================================================================================================================


//DOCUMENTO TIPO COMPLEMENTO

User Function EXEC103()

Local aCab := {}
Local aItem := {}
Local aItens := {}
Local nOpc := 3
Local cNum := ""
Local nI := 0
Local nX := 0

//Conout("Inicio: " + Time())

Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "04" MODULO "COM"

cNum := '000020213'

//Cabeçalho
aadd(aCab,{"F1_TIPO" ,"C" ,NIL})
aadd(aCab,{"F1_TPCOMPL" ,"3" ,NIL})
aadd(aCab,{"F1_DOC" ,cNum ,NIL})
aadd(aCab,{"F1_SERIE" ,"001" ,NIL})
aadd(aCab,{"F1_FORNECE" ,"022581" ,NIL})
aadd(aCab,{"F1_LOJA" ,"0001" ,NIL})
aadd(aCab,{"F1_EMISSAO" ,DDATABASE ,NIL})
aadd(aCab,{"F1_DTDIGIT" ,DDATABASE ,NIL})
aadd(aCab,{"F1_FORMUL" ,"N" ,NIL})
aadd(aCab,{"F1_ESPECIE" ,"NFS" ,NIL})
aadd(aCab,{"F1_COND" ,"134" ,NIL})
//aadd(aCab,{"F1_MODAL" ,"01" ,NIL})
//aadd(aCab,{"F1_TPFRETE" ,"C" ,NIL})
//aadd(aCab,{"F1_TPCTE" ,"N" ,NIL})
aadd(aCab,{"F1_EST" ,"MG" ,NIL})
aadd(aCab,{"F1_DESCONT" , 0 , Nil})
aadd(aCab,{"F1_SEGURO" , 0 , Nil})
aadd(aCab,{"F1_FRETE" , 0 , Nil})
aadd(aCab,{"F1_MOEDA" , 1 , Nil})
aadd(aCab,{"F1_TXMOEDA" , 1 , Nil})
aadd(aCab,{"F1_STATUS" , "A" , Nil})
aadd(aCab,{"F1_ISS" , 0 , Nil})

//Itens
For nX := 1 To 1
aItem := {}
aadd(aItem,{"D1_ITEM" ,'0001' ,NIL})
aadd(aItem,{"D1_COD" ,'200113' ,NIL})
aadd(aItem,{"D1_UM" ,"L" ,NIL})
aadd(aItem,{"D1_LOCAL" ,"04" ,NIL})
aadd(aItem,{"D1_VUNIT" ,21515.72 ,NIL})
aadd(aItem,{"D1_TOTAL" ,21515.72 ,NIL})
aadd(aItem,{"D1_TES" ,"426" ,NIL})
aadd(aItem,{"D1_NFORI" ,"000056620" ,NIL})
aadd(aItem,{"D1_SERIORI" ,"002" ,NIL})
aadd(aItem,{"D1_ITEMORI" ,"0001" ,NIL})
aadd(aItem,{"D1_CC" ,"040501" ,NIL})
aadd(aItem,{"D1_BASEISS" ,0 ,NIL})
aadd(aItem,{"D1_VALISS" ,0 ,NIL})


aAdd(aItens,aItem)
Next nX


//Impostos (Informar a referência do imposto, que consta no valid do campo)

//Para impostos de cabeçalho informar: referência, valor
aAutoImp := { {"NF_ISS" ,  0}}//,;
//                         {"NF_VALIPI",  15},;
 //                        {"NF_VALICM",7}}

//Para impostos de Itens informar: referência, valor, número da linha
aAdd(aAutoImp, {'IT_BASEISS', 0, 1}) //Base
aAdd(aAutoImp, {'IT_VALISS', 0,     1}) //Valor imposto
//aAdd(aAutoImp, {'IT_ALIQICM',12,    1}) //Porcentagem Imposto



//3-Inclusão / 4-Classificação / 5-Exclusão
MSExecAuto({|x,y,z| MATA103(x,y,z)},aCab,aItens,nOpc)

If !lMsErroAuto
ConOut(" Incluido NF: " + cNum)
Else
MostraErro()
ConOut("Erro na inclusao!")
EndIf

ConOut("Fim: " + Time())

//RESET ENVIRONMENT

Return


//CTE COMPLEMENTO FRETE/

User Function rmata116()

Local aCabec        := {}
Local aItens        := {}
Local aLinha        := {}
Local aRatcc        := {}
Local nX            := 0
Local nY            := 0
Local nTamFilial       := 0
Local lOk           := .T.
Local cFilSF1       := "04"
Local cDoc          := '000056620'
Local cSerie        := '002'
Local cForn         := '023482'
Local cLoja         := '0001'
Local cTipo         := 'N'
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //| Carrega ate 3 documentos de origem - Fornecedor 000001       |
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    dDataBase := CTOD("01/03/2021")
    dbSelectArea("SF1")
    dbSetOrder(1)

    MsSeek(cFilSF1+cDoc+cSerie+cForn+cLoja+cTipo)

    While !EOF() .AND. ( F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO == cFilSF1+cDoc+cSerie+cForn+cLoja+cTipo )

                nTamFilial  := Len(cFilSF1)
                aadd(aItens,{{"PRIMARYKEY",AllTrim(SubStr(&(IndexKey()),nTamFilial + 1))}}) //Tratamento para Gestao Empresas
                nX ++
       dbskip()
    EndDo

    IF nX >0

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //| Teste de Inclusao                                            |
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aadd(aCabec,{"",dDataBase-300})       //Data Inicial
        aadd(aCabec,{"",dDataBase})          //Data Final
        aadd(aCabec,{"",2})                  //2-Inclusao;1=Exclusao
        aadd(aCabec,{"",cForn})           //Fornecedor do documento de Origem
        aadd(aCabec,{"",cLoja})               //Loja de origem
        aadd(aCabec,{"",1})                  //Tipo da nota de origem: 1=Normal;2=Devol/Benef
        aadd(aCabec,{"",2})                  //1=Aglutina;2=Nao aglutina
        aadd(aCabec,{"F1_EST","MG"})
        aadd(aCabec,{"",9872.44})               //Valor do conhecimento
        aadd(aCabec,{"F1_FORMUL",1})
        aadd(aCabec,{"F1_DOC","000000057"})    //..Numero da NF de Conhecimento de Frete
        aadd(aCabec,{"F1_SERIE",""})
        aadd(aCabec,{"F1_FORNECE","022581"})
        aadd(aCabec,{"F1_LOJA","0001"})
        aadd(aCabec,{"","293"})              //TES
        aadd(aCabec,{"F1_BASERET",0})
        aadd(aCabec,{"F1_ICMRET",0})
        aadd(aCabec,{"F1_COND","134"})
        aadd(aCabec,{"F1_EMISSAO",dDataBase})
        aadd(aCabec,{"F1_ESPECIE","CTE"})
        aadd(aCabec,{"F1_CHVNFE","31200924496907000151570010000000551038000008"})
        aadd(aCabec,{"F1_TPCTE","N"})
        aadd(aCabec,{"E2_NATUREZ","FORNECEDOR"})
        aadd(aCabec,{"E2_CCD","040501"})

        If Len(aItens)>0
                        //item da nota    //Item do Rateio , Perc. Rate ,Cent.de Cus,,,, Alias,Linha Deletada,   Item 02 do Rateio.
            //aRatcc := {{"0001"        ,{{'01'              ,50          ,"000000000",,,,"SDE",,,,.F.            },{'02',50,"000001",,,,"SDE",,,,.F.}}}}
            MATA116(aCabec,aItens,,,)
        EndIf
            If lMsErroAuto
                MostraErro()
                Alert("Erro!")
            Else
                RecLock("SD1",.F.)
                    SD1->D1_CC := '040501'
                MsUnlock()
                Alert("Ok!")
            Endif
    EndIf

Return(.T.)
