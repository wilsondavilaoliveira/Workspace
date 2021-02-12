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

User Function QUAR022FA ()

Local aImprim:= {}

If Pergunte("QUAR022F",.T.)
    Processa({|| RunReport(aImprim)},"Imprimindo...","Relatorio Bonificacoes Produtor. . . ",.F.)
EndiF

Return

