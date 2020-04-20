#INCLUDE "PROTHEUS.CH"

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Program   � QUAA014  � Autor �Darlan A. Freitas Maciel � Data � 05/01/2008 ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o � Cadastro de Tipo de Leite.                                     ���
�����������������������������������������������������������������������������Ĵ��
���Retorno   �                                                                ���
�����������������������������������������������������������������������������Ĵ��
���Parametros�                                                                ���
�����������������������������������������������������������������������������Ĵ��
���Aplicacao �                                                                ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Quata - PL8.5 - FS07529302 - Proposta 4                        ���
�����������������������������������������������������������������������������Ĵ��
���Analista Resp.  �  Data  � Bops � Manutencao Efetuada                      ���
�����������������������������������������������������������������������������Ĵ��
���                �  /  /  �      �                                          ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
User Function QUAA014

Private cAlias := "LBN"

dbSelectArea(cAlias)
dbSetOrder(1)
AxCadastro(cAlias, "Cadastro de Tipo de Leite" ,"U_DelQua14()") //"Tipos de Leite"

Return


// Funcao de Validacao para Exclusao de Registros
/////////////////////////////////////////////////////////////////
User Function DelQua14()

Local lRet := .t. , ni := 0 , cRet
Local aArea,cArqPes,cFilDel,cFilPes,nPosFil,lFil,lIndtemp
Private cIndice , cChave 
aChave := {}

Aadd(aChave, {"LBH","LBH_TIPOL",LBN->LBN_TIPOL,NIL} )
Aadd(aChave, {"LBO","LBO_TIPOL",LBN->LBN_TIPOL,NIL} )
          
dbSelectArea("LBN")  
cSele   := Alias()
cArqDel := cSele
cFilDel := xFilial(cArqDel)

aArea := sGetArea(aArea,cSele)
aArea := sGetArea(aArea,"SX2")

&& Procura se existe registro 
For ni := 1 to Len(aChave)

    If !(aChave[ni,1]$cFOPENed)
       ChkFile(aChave[ni,1],.F.)
    EndIf
    cArqPes  := aChave[ni,1]
    cFilPes  := xFilial(cArqPes)
    lFil     := .T.
    lIndTemp := .F.

    dbSelectArea(aChave[ni,1])
    && Salva configuracao dos arquivos relacionados
    aArea := sGetArea(aArea,aChave[nI,1])

    && Se nao existir indice acessivel cria indregua
    If ValType(aChave[ni,2]) == "N" .And. aChave[ni,4] == NIL .And. cFilDel == cFilPes
    
       dbSetOrder(aChave[ni,2])
       
    Else
    
       cIndice := CriaTrab(Nil, .F.)  
                               
       If ValType(aChave[ni,2]) == "N"
       
          dbSetOrder(aChave[ni,2])
          cChave  := IndexKey()
        
       Else
       
          cChave  := Alltrim(aChave[ni,1])+"_FILIAL+"+Alltrim(aChave[ni,2])
          If SubStr(cChave,1,1) == "S"    // quando e' um alias que comeca com "S" tipo (SA1,SB1,SB2,etc) as iniciais do campo sao apenas 2 caracteres (ALTERADO POR EDUARDO MOTTA - MICROSIGA)
             cChave := SubStr(cChave,2)
          EndIf
          
       EndIf

       If Empty(cFilDel) .and. !Empty(cFilPes)    // se o Alias do registro que sera deletado for compartilhado e o outro nao ignora a filial
          nPosFil := At("_FILIAL+",cChave)+8
          cChave  := substr(cChave,nPosFil)
          lFil    := .F.
       EndIf
          
       IndRegua(aChave[ni,1],cIndice,cChave,,aChave[ni,4],OemToAnsi(aChave[ni,1]) )
       lIndTemp := .T.
       
    EndIf
    
    lRet := !dbSeek( If(lFil,xFilial(aChave[ni,1]),"") + aChave[ni,3] )
                                                    
    && Apaga indice criado pela indregua
    If lIndTemp
       RetIndex()
       #IFNDEF TOP
          If File(cIndice+OrdBagExt())
             fErase(cIndice+OrdBagExt())
          Endif
       #ENDIF
    EndIf   

    If !lRet
       cRet := aChave[nI,1]
       Exit
    EndIf   
    
Next                     
   
&& Volta posicoes originais
sRestArea(aArea)

If !lRet
   lRet := .F.
   SX2->(dbSeek(cRet))
   Help("  ",1,"CANCELDEL",,cRet+"- "+OemToAnsi(X2Nome() ),4,1)
EndIf                  

dbSelectArea(cSele)

Return(lRet)

