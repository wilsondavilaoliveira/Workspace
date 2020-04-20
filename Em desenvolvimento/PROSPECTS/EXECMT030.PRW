//-------------------------------------------------------------------
/*/{Protheus.doc} MyCRMA980
Função de exemplo para utilização da rotina automática de Clientes.
@param     Nenhum
@return 	Nenhum
@author    Squad CRM / FAT
@version   12.1.17 / Superior
@since     24/05/2017
/*/
//-------------------------------------------------------------------
User Function MyCRMA980()
 
Local aSA1Auto  := {}
Local aAI0Auto  := {}
Local nOpcAuto  := MODEL_OPERATION_INSERT
Local lRet      := .T.
 
Private lMsErroAuto := .F.
 
lRet := RpcSetEnv("T1","D MG 01","Admin")
 
If lRet
     
    //----------------------------------
    // Dados do Cliente
    //----------------------------------
    aAdd(aSA1Auto,{"A1_COD"     ,"XBX139"               ,Nil})
    aAdd(aSA1Auto,{"A1_LOJA"    ,"01"                   ,Nil})
    aAdd(aSA1Auto,{"A1_NOME"    ,"ROTINA AUTOMATICA"    ,Nil})
    aAdd(aSA1Auto,{"A1_NREDUZ"  ,"ROTAUTO"              ,Nil}) 
    aAdd(aSA1Auto,{"A1_TIPO"    ,"F"                    ,Nil})
    aAdd(aSA1Auto,{"A1_END"     ,"BRAZ LEME"            ,Nil}) 
    aAdd(aSA1Auto,{"A1_BAIRRO"  ,"CASA VERDE"           ,Nil}) 
    aAdd(aSA1Auto,{"A1_EST"     ,"SP"                   ,Nil})
    aAdd(aSA1Auto,{"A1_MUN"     ,"SAO PAULO"            ,Nil})
     
    //---------------------------------------------------------
    // Dados do Complemento do Cliente
    //---------------------------------------------------------
    aAdd(aAI0Auto,{"AI0_SALDO"  ,30                     ,Nil})
     
    //------------------------------------
    // Chamada para cadastrar o cliente.
    //------------------------------------
    MSExecAuto({|a,b,c| CRMA980(a,b,c)}, aSA1Auto, nOpcAuto, aAI0Auto)
      
    If lMsErroAuto  
        lRet := lMsErroAuto
    Else
        Conout("Cliente incluído com sucesso!")
    EndIf
     
EndIf
 
RpcClearEnv()
              
Return lRet