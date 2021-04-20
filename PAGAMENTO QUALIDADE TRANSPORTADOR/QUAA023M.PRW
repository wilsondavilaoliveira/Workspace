#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE "PRCONST.CH"
#INCLUDE "FONT.CH"
#include "TBICONN.CH"
#INCLUDE 'FWMVCDEF.CH'
#include "TOTVS.CH"

#define MVC_TITLE "Geracao de Cte/Nfs"
#define MVC_ALIAS "PC9"
#define MVC_VIEWDEF_NAME "VIEWDEF.QUAA023M"

/*/{Protheus.doc} QUAA023M
GERACAO DE NFS/CTE
@type function
@version 1
@author Wilson Davila
@since 12/11/2020
/*/
User function QUAA023M()

Local dDataBkp :=  dDataBase

If Pergunte("QUAA023M",.T.)
    dDataBase := MV_PAR01
    If PC6->PC6_STATUS == 'P'
        FWExecView( getTitle(MODEL_OPERATION_UPDATE), MVC_VIEWDEF_NAME, MODEL_OPERATION_UPDATE)
    Else
        MsgStop("Fechamento nao efetuado, nao e possivel emitir as notas")
    EndIf

EndIf

dDataBase := dDataBkp

Return

/*/{Protheus.doc} getTitle
description
@type function
@version
@author Wilson Davila
@since 12/10/2020
@param nOperation, numeric, param_description
@return return_type, return_description
/*/
Static function getTitle(nOperation)

local cTitle as char

if nOperation == MODEL_OPERATION_INSERT
    cTitle := "Inclusão"
elseif nOperation == MODEL_OPERATION_UPDATE
    cTitle := "Alteração"
else
    cTitle := "Visualização"
endif

return cTitle

/*/{Protheus.doc} ModelDef
description
@type function
@version
@author Wilson Davila
@since 12/04/2021
@return return_type, return_description
/*/
Static function ModelDef()
local oModel as object
local oStrField as object
local oStrGrid as object

oStrField := FWFormModelStruct():New()

oStrField:addTable("", {"C_STRING1"}, MVC_TITLE, {|| ""})
oStrField:addField("String 01", "Campo de texto", "C_STRING1", "C", 15)

oStrGrid := FWFormStruct(1, MVC_ALIAS)
oModel := MPFormModel():New("MIDMAIN")

oModel:addFields("CABID", /*cOwner*/, oStrField, /*bPre*/, /*bPost*/, {|oMdl| loadHidFld()})
oStrGrid:AddField( ;
                        AllTrim('') , ; 			// [01] C Titulo do campo
                        AllTrim('') , ; 			// [02] C ToolTip do campo
                        'PC9_LEGEND' , ;               // [03] C identificador (ID) do Field
                        'C' , ;                     // [04] C Tipo do campo
                        50 , ;                      // [05] N Tamanho do campo
                        0 , ;                       // [06] N Decimal do campo
                        NIL , ;                     // [07] B Code-block de validação do campo
                        NIL , ;                     // [08] B Code-block de validação When do campo
                        NIL , ;                     // [09] A Lista de valores permitido do campo
                        NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatório
                        { || Iif(PC9_STATUS=='A', "BR_AMARELO",IIF(PC9_STATUS=='E',"BR_VERMELHO","BR_VERDE")) } , ;  		// [11] B Code-block de inicializacao do campo
                        NIL , ;                     // [12] L Indica se trata de um campo chave
                        NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
                        .T. )                       // [14] L Indica se o campo é virtual


oModel:addGrid("GRIDID", "CABID", oStrGrid, /*bLinePre*/, /*bLinePost*/, /*bPre*/, /*bPost*/, {|oMdl| loadGrid(oMdl)})
oModel:setDescription(MVC_TITLE)
oModel:setActivate({ |oModel| onActivate(oModel)})

Return oModel

/*/{Protheus.doc} onActivate
description
@type function
@version
@author Wilson Davila
@since 12/04/2021
@param oModel, object, param_description
@return return_type, return_description
/*/
Static function onActivate(oModel)

if oModel:GetOperation() == MODEL_OPERATION_INSERT
    FwFldPut("C_STRING1", "FAKE" , /*nLinha*/, oModel)
endif

Return

/*/{Protheus.doc} loadGrid
description
@type function
@version
@author Wilson Davila
@since 12/04/2021
@param oModel, object, param_description
@return return_type, return_description
/*/
Static function loadGrid(oModel)

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
    WHERE D_E_L_E_T_ = ' ' AND PC9_PERIOD=%Exp:PC6->PC6_PERIOD% AND PC9_FILIAL=%Exp:cFilAnt%
    ORDER BY PC9_CODTRA,PC9_TIPDOC
EndSql

aData := FwLoadByAlias(oModel, cAlias, MVC_ALIAS, "RECNO", /*lCopy*/, .T.)

(cAlias)->(DBCloseArea())

if !Empty(cWorkArea) .And. Select(cWorkArea) > 0
    DBSelectArea(cWorkArea)
endif

Return aData

/*/{Protheus.doc} loadHidFld
description
@type function
@version
@author Wilson Davila
@since 12/04/2021
@param oModel, object, param_description
@return return_type, return_description
/*/
Static function loadHidFld(oModel)
return {""}

/*/{Protheus.doc} viewDef
description
@type function
@version
@author Wilson Davila
@since 12/04/2021
@return return_type, return_description
/*/
Static function viewDef()

local oView as object
local oModel as object
local oStrCab as object
local oStrGrid as object

oStrCab := FWFormViewStruct():New()

oStrCab:addField("C_STRING1", "01" , "String 01", "Campo de texto", , "C" )

oStrGrid := FWFormStruct(2, MVC_ALIAS )
oModel := FWLoadModel("QUAA023M")
oView := FwFormView():New()

oView:setModel(oModel)

oStrGrid:AddField(                    ;     // Ord. Tipo Desc.
	'PC9_LEGEND'                   	, ;   	// [01]  C   Nome do Campo
	"00"                         	, ;     // [02]  C   Ordem
	AllTrim( ''    )                , ;     // [03]  C   Titulo do campo
	AllTrim( '' )                   , ;     // [04]  C   Descricao do campo
	{ 'Legenda' } 		            , ;     // [05]  A   Array com Help
	'C'                             , ;     // [06]  C   Tipo do campo
	'@BMP'                          , ;     // [07]  C   Picture
	NIL                             , ;     // [08]  B   Bloco de Picture Var
	''                              , ;     // [09]  C   Consulta F3
	.T.                             , ;     // [10]  L   Indica se o campo é alteravel
	NIL                             , ;     // [11]  C   Pasta do campo
	NIL                             , ;     // [12]  C   Agrupamento do campo
	NIL				               	, ;     // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ;     // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ;     // [15]  C   Inicializador de Browse
	.T.                             , ;     // [16]  L   Indica se o campo é virtual
	NIL                             , ;     // [17]  C   Picture Variavel
	NIL                             )       // [18]  L   Indica pulo de linha após o campo


oView:addField("CAB", oStrCab, "CABID")
oView:addGrid("GRID", oStrGrid, "GRIDID")

oView:SetNoDeleteLine("GRID")
oView:SetNoInsertLine("GRID")

cCSS := "QTableView { selection-background-color: #ade0ff; font-weight:bold;font-size:11px }"
cCSS += "QHeaderView::section { background-color: qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #616161, stop: 0.5 #505050, stop: 0.6 #434343,  stop:1 #656565); color: white; padding-left: 4px; border: 1px solid #6c6c6c; }"

oView:SetViewProperty( "GRID", "SETCSS", {cCSS} )
oView:SetViewProperty("GRID", "GRIDDOUBLECLICK", {{|oFormulario,cFieldName,nLineGrid,nLineModel| Iif(Alltrim(cFieldName) == "PC9_LEGEND",Legenda(),.f.)}})

bBlocoNotas := {|oView| GeraNotas(oView) }
oView:AddUserButton("GERAR NOTAS CTE/NFS","MAGIC_BMP",bBlocoNotas,"Gerar Notas Cte/Nfs")

oView:createHorizontalBox("TOHIDE", 0 )
oView:createHorizontalBox("TOSHOW", 100 )
oView:setOwnerView("CAB", "TOHIDE" )
oView:setOwnerView("GRID", "TOSHOW")

oView:setDescription( MVC_TITLE )

Return oView

/*/{Protheus.doc} Legenda
description
@type function
@version
@author Wilson Davila
@since 12/04/2021
@return return_type, return_description
/*/
Static Function Legenda()

oLegend := FWLegend():New()

oLegend:Add( { || }, 'BR_AMARELO'   , 'AGUARDANDO' )
oLegend:Add( { || }, 'BR_VERDE'     , 'DOCUMENTO GERADO' )
oLegend:Add( { || }, 'BR_VERMELHO'  , 'ERRO NA GERACAO' )

oLegend:Activate()

oLegend:View()

Return Nil

/*/{Protheus.doc} GeraNotas
chama fujcao de Geracao de notas
@type function
@version
@author Wilson Davila
@since 12/04/2021
@param oView, object, param_description
@return return_type, return_description
/*/
Static Function GeraNotas(oView)

Local oProcess := MsNewProcess():New({|lEnd| ProcNf(@oProcess, @lEnd) },"Gerancao Notas Cte/Nfs Transportadoras","Gerando Notas....",.F.)

oProcess:Activate()

oView:DeActivate()
oView:Activate()
oView:Refresh()

Return

/*/{Protheus.doc} ProcNf
Gera notas fiscais
@type function
@version
@author Wilson Davila
@since 12/04/2021
@param oProcess, object, param_description
@param lEnd, logical, param_description
@return return_type, return_description
/*/
Static Function ProcNf(oProcess,lEnd)

Local cAliPC9   := GetNextAlias()
Local nReg      := 1
Local lGerou    := .T.

BeginSql Alias cAliPC9

    SELECT PC9_CODTRA,PC9_TIPDOC,PC9_VALOR,PC9_NUMDOC,PC9_SERDOC,PC9_CHVNFE,PC9_NFORIG,PC9_SERORI,PC9_CODPRO,PC9_LOJA,R_E_C_N_O_ AS RECNO,
    (SELECT COUNT(*) FROM %Table:PC9% PC91 WHERE PC91.%notDel% AND PC9_FILIAL=%Exp:cFilAnt% AND PC9_PERIOD=%Exp:PC6->PC6_PERIOD% AND PC9_STATUS IN ('A','E')) AS REG
    FROM %Table:PC9% PC9 WHERE PC9.%notDel% AND PC9_FILIAL=%Exp:cFilAnt% AND PC9_PERIOD=%Exp:PC6->PC6_PERIOD% AND PC9_STATUS IN ('A','E')
    ORDER BY PC9_CODTRA,PC9_TIPDOC

EndSql

    aSql := GetLastQuery()

    MemoWrite("C:\HD\QUERYS\GERANOTAS.SQL",aSql[2])


If (cAliPC9)->(!Eof())

    nReg := (cAliPC9)->(REG)
    oProcess:SetRegua1(nReg)

    While (cAliPC9)->(!Eof())
        oProcess:SetRegua2(1)
        oProcess:IncRegua1("Nota -> " + STRZERO(VAL((cAliPC9)->(PC9_NUMDOC)),9)+"-"+STRZERO(VAL((cAliPC9)->(PC9_SERDOC)),3)+"-TIPO:"+IIF((cAliPC9)->(PC9_TIPDOC)=='1',"NFS","CTE"))

        If (cAliPC9)->(PC9_TIPDOC) == '1' //NFS
            //EXEC103(cNum,cSerie,cForTrans,nValNf,cNfOri,cSerOri,cForOri,cLojaOri)
            lGerou :=  EXEC103(STRZERO(VAL((cAliPC9)->(PC9_NUMDOC)),9),STRZERO(VAL((cAliPC9)->(PC9_SERDOC)),3),;
            (cAliPC9)->(PC9_CODTRA),(cAliPC9)->(PC9_VALOR),(cAliPC9)->(PC9_NFORIG),;
            (cAliPC9)->(PC9_SERORI),(cAliPC9)->(PC9_CODPRO),(cAliPC9)->(PC9_LOJA))

            PC9->( DbGoto((cAliPC9)->(RECNO)))
            If lGerou
                PC9->( RecLock("PC9",.F.))
                    PC9->PC9_STATUS := 'G'
                    PC9->PC9_DTEMIS := DDATABASE
                PC9->( MsUnlock() )

            Else
                PC9->( RecLock("PC9",.F.))
                    PC9->PC9_STATUS := 'E'
                PC9->( MsUnlock() )
            EndIf

            lGerou := .T.

        Else //2=CTE
            //RMATA116(cNum,cSerie,cForTrans,nValNf,cNfOri,cSerOri,cForOri,cLojaOri,cChvNfe)
            lGerou :=  RMATA116(STRZERO(VAL((cAliPC9)->(PC9_NUMDOC)),9),STRZERO(VAL((cAliPC9)->(PC9_SERDOC)),3),;
            (cAliPC9)->(PC9_CODTRA),(cAliPC9)->(PC9_VALOR),(cAliPC9)->(PC9_NFORIG),;
            (cAliPC9)->(PC9_SERORI),(cAliPC9)->(PC9_CODPRO),(cAliPC9)->(PC9_LOJA),(cAliPC9)->(PC9_CHVNFE))

            PC9->( DbGoto((cAliPC9)->(RECNO)))
            If lGerou
                PC9->( RecLock("PC9",.F.))
                    PC9->PC9_STATUS := 'G'
                    PC9->PC9_DTEMIS := DDATABASE
                PC9->( MsUnlock() )

            Else
                PC9->( RecLock("PC9",.F.))
                    PC9->PC9_STATUS := 'E'
                PC9->( MsUnlock() )
            EndIf

            lGerou := .T.

        EndIf

        oProcess:IncRegua2("Transportadora-> " + (cAliPC9)->(PC9_CODTRA)+"-"+SubStr(Posicione("SA2",1,xFilial("SA2")+(cAliPC9)->(PC9_CODTRA),"A2_NOME"),1,15))

        (cAliPC9)->( dbSkip() )

    EndDo

    MsgAlert("Notas Geradas")

Else

    MsgStop("Nao ha notas para gerar")

EndIf

Return

/*/{Protheus.doc} EXEC103
ExecAuto Geracao de NFS
@type function
@version
@author Wilson Davila
@since 12/04/2021
@param cNum, character, param_description
@param cSerie, character, param_description
@param cForTrans, character, param_description
@param nValNf, numeric, param_description
@param cNfOri, character, param_description
@param cSerOri, character, param_description
@param cForOri, character, param_description
@param cLojaOri, character, param_description
@return return_type, return_description
/*/
Static Function EXEC103(cNum,cSerie,cForTrans,nValNf,cNfOri,cSerOri,cForOri,cLojaOri)

Local aCab := {}
Local aItem := {}
Local aItens := {}
Local nOpc := 3
Local nX := 0
Local cCond := '134'
Local cTes  := "426"
Local lGerou := .T.

Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.


SA2->( dbSetOrder(1))
SA2->( dbSeek(xFilial("SA2")+cForTrans+'0001') )

//Cabeçalho
aadd(aCab,{"F1_TIPO" ,"C" ,NIL})
aadd(aCab,{"F1_TPCOMPL" ,"3" ,NIL})
aadd(aCab,{"F1_DOC" ,cNum ,NIL})
aadd(aCab,{"F1_SERIE" ,cSerie ,NIL})
aadd(aCab,{"F1_FORNECE" ,cForTrans ,NIL})
aadd(aCab,{"F1_LOJA" ,"0001" ,NIL})
aadd(aCab,{"F1_EMISSAO" ,DDATABASE ,NIL})
aadd(aCab,{"F1_DTDIGIT" ,DDATABASE ,NIL})
aadd(aCab,{"F1_FORMUL" ,"N" ,NIL})
aadd(aCab,{"F1_ESPECIE" ,"NFS" ,NIL})
aadd(aCab,{"F1_COND" ,cCond ,NIL})
aadd(aCab,{"F1_EST" ,SA2->(A2_EST) ,NIL})
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
    aadd(aItem,{"D1_VUNIT" ,nValNf ,NIL})
    aadd(aItem,{"D1_TOTAL" ,nValNf ,NIL})
    aadd(aItem,{"D1_TES" ,cTes ,NIL})
    aadd(aItem,{"D1_NFORI" ,cNfOri ,NIL})
    aadd(aItem,{"D1_SERIORI" ,cSerOri ,NIL})
    aadd(aItem,{"D1_ITEMORI" ,"0001" ,NIL})
    aadd(aItem,{"D1_CC" ,"040501" ,NIL})
    aadd(aItem,{"D1_BASEISS" ,0 ,NIL})
    aadd(aItem,{"D1_VALISS" ,0 ,NIL})
    aAdd(aItens,aItem)
Next nX

aAutoImp := { {"NF_ISS" ,  0}}//,;
aAdd(aAutoImp, {'IT_BASEISS', 0, 1}) //Base
aAdd(aAutoImp, {'IT_VALISS', 0,     1}) //Valor imposto

//3-Inclusão / 4-Classificação / 5-Exclusão
MSExecAuto({|x,y,z| MATA103(x,y,z)},aCab,aItens,nOpc)

If !lMsErroAuto
    //ConOut(" Incluido NF: " + cNum)
Else
    MostraErro()
    lGerou := .F.
EndIf

Return lGerou

/*/{Protheus.doc} RMATA116
ExecAuto Geracao CTE
@type function
@version
@author Wilson Davila
@since 12/04/2021
@param cNum, character, param_description
@param cSerie, character, param_description
@param cForTrans, character, param_description
@param nValNf, numeric, param_description
@param cNfOri, character, param_description
@param cSerOri, character, param_description
@param cForOri, character, param_description
@param cLojaOri, character, param_description
@param cChvNfe, character, param_description
@return return_type, return_description
/*/
Static Function RMATA116(cNum,cSerie,cForTrans,nValNf,cNfOri,cSerOri,cForOri,cLojaOri,cChvNfe)

Local aCabec        := {}
Local aItens        := {}
Local nX            := 0
Local nTamFilial       := 0
Local cFilSF1       := cFilAnt
Local cTipo         := 'N'
Local lGerou        := .T.
Local cTes          := "293"
Local cCond         := "134"
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //| Carrega ate 3 documentos de origem - Fornecedor 000001       |
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    //dDataBase := CTOD("01/03/2021")
    dbSelectArea("SF1")
    dbSetOrder(1)

    MsSeek(cFilSF1+cNfOri+cSerOri+cForOri+cLojaOri+cTipo)

    While !EOF() .AND. ( F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO == cFilSF1+cNfOri+cSerOri+cForOri+cLojaOri+cTipo )
        nTamFilial  := Len(cFilSF1)
        aadd(aItens,{{"PRIMARYKEY",AllTrim(SubStr(&(IndexKey()),nTamFilial + 1))}}) //Tratamento para Gestao Empresas
        nX ++
        dbskip()
    EndDo

    SA2->( dbSetOrder(1))
    SA2->( dbSeek(xFilial("SA2")+cForTrans+'0001') )

    IF nX >0

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //| Teste de Inclusao                                            |
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

        aadd(aCabec,{"",dDataBase-300})       //Data Inicial
        aadd(aCabec,{"",dDataBase})          //Data Final
        aadd(aCabec,{"",2})                  //2-Inclusao;1=Exclusao
        aadd(aCabec,{"",cForOri})           //Fornecedor do documento de Origem
        aadd(aCabec,{"",cLojaOri})               //Loja de origem
        aadd(aCabec,{"",1})                  //Tipo da nota de origem: 1=Normal;2=Devol/Benef
        aadd(aCabec,{"",2})                  //1=Aglutina;2=Nao aglutina
        aadd(aCabec,{"F1_EST",SA2->(A2_EST)})
        aadd(aCabec,{"",nValNf})               //Valor do conhecimento
        aadd(aCabec,{"F1_FORMUL",1})
        aadd(aCabec,{"F1_DOC",cNum})    //..Numero da NF de Conhecimento de Frete
        aadd(aCabec,{"F1_SERIE",cSerie})
        aadd(aCabec,{"F1_FORNECE",cForTrans})
        aadd(aCabec,{"F1_LOJA","0001"})
        aadd(aCabec,{"",cTes})              //TES
        aadd(aCabec,{"F1_BASERET",0})
        aadd(aCabec,{"F1_ICMRET",0})
        aadd(aCabec,{"F1_COND",cCond})
        aadd(aCabec,{"F1_EMISSAO",dDataBase})
        aadd(aCabec,{"F1_ESPECIE","CTE"})
        aadd(aCabec,{"F1_CHVNFE",cChvNfe})
        aadd(aCabec,{"F1_TPCTE","N"})
        aadd(aCabec,{"E2_NATUREZ","FORNECEDOR"})
        aadd(aCabec,{"E2_CCD","040501"})

        If Len(aItens)>0
            MATA116(aCabec,aItens,,,)
        EndIf
            If lMsErroAuto
                MostraErro()
                lGerou := .F.
            Else
                RecLock("SD1",.F.)
                    SD1->D1_CC := '040501'
                MsUnlock()
            Endif
    EndIf

Return lGerou
