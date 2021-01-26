#INCLUDE "protheus.ch"
/*/{Protheus.doc} TestCopy
description
@type function
@version
@author wilso
@since 03/12/2020
@return return_type, return_description
/*/
User Function TestCopy()

Local cFile
Local cFileDest

cFile 	:= 'SA3010'
cFileDest := '\WILSON\SA3010_A.DTC'

If ! MsCopyFile(cFile, cFileDest)
    MsgAlert("O arquivo não pôde ser copiado.")
Else
    MsgAlert("O arquivo foi copiado com sucesso.")
EndIF

Return
