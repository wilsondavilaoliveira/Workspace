#include "protheus.ch"
#include "fwmvcdef.ch"

#define MVC_TITLE "Condicoes de pagamento"
#define MVC_ALIAS "ZX7"
#define MVC_VIEWDEF_NAME "VIEWDEF.ALTCOND"

//-------------------------------------------------------------------
/*/{Protheus.doc} QUAA023F
Função principal da rotina MVC

@author Wilson Davila
@since 14/10/2020
@version 1.0
/*/
//-------------------------------------------------------------------
user function ALTCOND()
//Inserção - Inclusão de itens
//FWExecView( getTitle(MODEL_OPERATION_INSERT), MVC_VIEWDEF_NAME, MODEL_OPERATION_INSERT)

//Visualização - Verificar os itens incluídos
//FWExecView( getTitle(MODEL_OPERATION_VIEW), MVC_VIEWDEF_NAME, MODEL_OPERATION_VIEW)

//Alteração - Por ser um grid, a alteração já vai permitir a exclusão
FWExecView( getTitle(MODEL_OPERATION_UPDATE), MVC_VIEWDEF_NAME, MODEL_OPERATION_UPDATE)

//Visualização - Verificar os itens adicionados, alterados ou excluidos
//FWExecView( getTitle(MODEL_OPERATION_VIEW), MVC_VIEWDEF_NAME, MODEL_OPERATION_VIEW)
return

//-------------------------------------------------------------------
/*/{Protheus.doc} getTitle
Retorna o título para a janela MVC, conforme operação

@param nOperation - Operação do modelo

@return cTitle - String com o título da janela

@author Wilson Davila
@since 14/10/2020
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

@author Wilson Davila
@since 14/10/2020
@version 1.0
/*/
//-------------------------------------------------------------------
Static function ModelDef()

Local oModel as object
Local oStrField as object
Local oStrGrid as object

Local cCampo1 as String
Local cCampo2 as String
Local cCampo3 as String
Local cCampo4 as String


dbSelectArea("SX3")
dbSetOrder(2)

If dbSeek("A1_COND")
    cCampo1 := X3Titulo()
EndIf

If dbSeek("A1_XCOND1")
    cCampo3 := X3Titulo()
EndIf


// Estrutura Fake de Field
oStrField := FWFormModelStruct():New()

oStrField:addTable("", {"C_STRING1"}, MVC_TITLE, {|| ""})

oStrField:addField(cCampo1, "", "C_STRING1", "C", 30,,,{||.F.})
//oStrField:addField("Refrigerada", "", "C_STRING2", "C", 15,,,{||.F.})
oStrField:addField(cCampo3, "", "C_STRING3", "C", 30,,,{||.F.})
//oStrField:addField("Seca", "", "C_STRING4", "C", 15,,,{||.F.})

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

@author Wilson Davila
@since 14/10/2020
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

@author Wilson Davila
@since 14/10/2020
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
    WHERE D_E_L_E_T_ = ' ' and ZX7_CODCLI=%EXP:SA1->A1_COD%
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

@author Wilson Davila
@since 14/10/2020
@version 1.0
/*/
//-------------------------------------------------------------------
Static function loadHidFld(oModel)

Local aRet := {SA1->A1_COND+" --> "+Posicione("SE4",1,xFilial("SE4")+SA1->A1_COND,"E4_DESCRI"),SA1->A1_XCOND1+" --> "+Posicione("SE4",1,xFilial("SE4")+SA1->A1_XCOND1,"E4_DESCRI")}


Return aRet
//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Função estática do ViewDef

@return oView - Objeto da view, interface

@author Wilson Davila
@since 14/10/2020
@version 1.0
/*/
//-------------------------------------------------------------------
Static function viewDef()

Local oView as object
Local oModel as object
Local oStrCab as object
Local oStrGrid as object
Local cCampo1 as String
Local cCampo2 as String

dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("A1_COND")
    cCampo1 := X3Titulo()
EndIf

If dbSeek("A1_XCOND1")
    cCampo2 := X3Titulo()
EndIf

// Estrutura Fake de Field
oStrCab := FWFormViewStruct():New()

oStrCab:addField("C_STRING1", "01" , cCampo1, "Campo de texto1", , "C" )
//oStrCab:addField("C_STRING2", "02" , "Refrigerada", "Campo de texto2", , "C" )
oStrCab:addField("C_STRING1", "03" , cCampo2, "Campo de texto1", , "C" )
//oStrCab:addField("C_STRING2", "04" , "Seca", "Campo de texto2", , "C" )


//Estrutura de Grid
oStrGrid := FWFormStruct(2, MVC_ALIAS )
oModel := FWLoadModel("ALTCOND")
oView := FwFormView():New()

oView:setModel(oModel)

oView:addField("CAB", oStrCab, "CABID")
oView:addGrid("GRID", oStrGrid, "GRIDID")

cCSS := "QTableView { selection-background-color: #ade0ff; font-weight:bold;font-size:12px }"
cCSS += "QHeaderView::section { background-color: qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #616161, stop: 0.5 #505050, stop: 0.6 #434343,  stop:1 #656565); color: white; padding-left: 4px; border: 1px solid #6c6c6c; }"

oView:SetViewProperty( "GRID", "SETCSS", {cCSS} )

oView:createHorizontalBox("TOHIDE", 10 )
oView:createHorizontalBox("TOSHOW", 90 )

oView:setOwnerView("CAB", "TOHIDE" )
oView:setOwnerView("GRID", "TOSHOW")

oView:setDescription( MVC_TITLE )

return oView
