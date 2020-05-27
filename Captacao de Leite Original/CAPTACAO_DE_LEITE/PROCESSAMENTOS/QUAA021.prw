#INCLUDE "quaa021.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.ch"    

/*/{Protheus.doc} QUAA021()==============================================================================================================================
Leitura dados laboratorio referente a qualidade do leite               
@param xParam Parameter Description
@return xRet Return Description
@author  Wilson Davila
@since 01/02/2020
==========================================================================================================================================================
/*/
User Function QUAA021()

    Local cCadastro, cAlias
    Local aCampos    := {}
    
    Private nOpcg, nUsado
    Private cTitulo, cAliasEnchoice, cLinOK, cTudOK, cFieldOK
    Private nReg, nOpc
    
    nOpc	:=0
    aRotina := { { OemToAnsi("Pesquisar") 					,"axPesqui",0,1,},;  
                        { OemToAnsi("Visualizar")					,'U_xProLJZ(2)',0,2,},; 
                        { OemToAnsi("Alterar")							,'U_xProLJZ(4)',0,4,2},;  
                        { OemToAnsi("Gerar Planilha base")		,'U_QUAR081R()',0,3,},;  
                        { OemToAnsi("Ler Planilha base")		,'U_QA081XML()',0,3,},; 
                        { OemToAnsi("Excluir") 							,'U_xProLJZ(5)',0,5,1}} 
    
    //{ OemToAnsi("Incluir")							,'U_xProLJZ(3)',0,3,},;  
    
    cCadastro := OemToAnsi("Classificacao da Qualidade") 
    cAlias := "LJZ"

    dbSelectArea("LJZ")
    aCampos := PCposBrw()
    
    mBrowse( 6, 1,22,75,cAlias,aCampos,,,,,,,,2) // 14o.param = qtd.col.freeze

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ QUA21MAN ³ Autor ³ Ricardo Berti         ³ Data ³ 18/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Tratamento da Classificacao da Qualidade do Leite³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CACol211(ExpN1)					                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ expN1: numero da opcao selecionada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                              		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xProLJZ(nOpc)
    
    If nOpc <> 3
        MsAguarde({|| GETDQUA2A()},"Aguarde...","Preparando Visualizacao..aguarde!",.T.)
        MsAguarde({|| U_QUA21MAN(nOpc)},"Selecionando registros...")
    Else
        If MSGYESNO("ATENCAO !, antes de efetuar essa rotina certifique-se que todo leite esta lancado e todos os tipos de bonificacoes estao criadas, Deseja continuar?")
            MsAguarde({|| U_QUA21MAN(nOpc)},"Selecionando registros...")
        EndIf
    EndIf     
Return

USER Function QUA21MAN(nOpc)

    Local _ni, nCntFor
    Local bCampo	:= { |nCPO| Field(nCPO) }
    Local lPrima	:= .T.
    LOCAL aSize     := {}
    LOCAL aInfo     := {}
    LOCAL aObjects  := {}
    LOCAL aObj      := {}
    Local nRecnoSX3	:= 0
    
    Private aTELA[0][0]
    Private aGETS[0]
    Private aHeader :={} 
    Private aCols   :={}
    
    
    nReg          := 0
    cAliasGetd    := "LJZ"
    cAlias        := "LJZ"
    cLinOk        := "AllwaysTrue()"
    cTudOk        := "AllwaysTrue()"
    cFieldOk      := "AllwaysTrue()"
    cTitulo       := OemToAnsi("Classificacao da Qualidade")
    cAliasEnchoice:= "LJZ"
    cLinOk        := "AllwaysTrue()"
    
    SetPrvt("wVar")
    nUsado := 0
    
    dbSelectArea("SX3")
    dbSetOrder(1)
    dbSeek("LJZ")
    
    While !Eof().And.(x3_arquivo=="LJZ")
        
        If nUsado == 2  // ja fez o 2
            nRecnoSX3 := SX3->(RECNO())
            dbSetOrder(2) // Ordem de campo
            dbSeek("LBB_CODTAN")
            If !Eof() // .And. X3USO(x3_usado).And.cNivel>=x3_nivel
                nUsado++
                Aadd(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
                x3_tamanho, x3_decimal,x3_valid,;
                x3_usado, x3_tipo, x3_arquivo, x3_context, x3_Relacao, x3_reserv } )
                wVar  := "M->"+x3_campo
                &wVar := CriaVar(x3_campo)
            Endif
            dbSetOrder(1) 
            dbGoto(nRecnoSX3)
        
        ElseIf X3USO(x3_usado).And.cNivel>=x3_nivel .And. ;
        (Alltrim(x3_campo) $ ;
        "LJZ_CODPRO/LJZ_NOMFOR/LJZ_CODBON/LJZ_DESBON/LJZ_QTDLEI/LJZ_RESLEI")
        
            nUsado++
            Aadd(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
            x3_tamanho, x3_decimal,x3_valid,;
            x3_usado, x3_tipo, x3_arquivo, x3_context, x3_Relacao, x3_reserv } )
            wVar  := "M->"+x3_campo
            &wVar := CriaVar(x3_campo)
        Endif
        
        dbSkip()
        
    Enddo
    
    aCols:={Array(nUsado+1)}
    aCols[1,nUsado+1]:=.F.
    For _ni:=1 to nUsado
        aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
    Next
    
    if nOpc == 3 // Incluir
        nOpcE := 4
        nOpcG := 4
    elseif nOpc == 4 // Alterar
        nOpcE := 4
        nOpcG := 4
    elseif nOpc == 2 // Visualizar
        nOpcE := 2
        nOpcG := 2
    else             // Excluir
        nOpcE := 5
        nOpcG := 5
    endif
    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Cria variaveis M->????? da Enchoice                          ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    LBB->(dbSetOrder(1))
    LBB->(dbSeek(xFilial("LBB")+LJZ->LJZ_CODPRO))
    M->LBB_CODTAN := LBB->LBB_CODTAN
    
    dbSelectArea("LJZ")
    For nCntFor := 1 TO FCount()
        M->&(EVAL(bCampo,nCntFor)) := FieldGet(nCntFor)
    Next
    
    if Inclui
        M->LJZ_DATCLQ := Ctod("")
    EndIf
    
    nOpca       := 0
    
    aSize := MsAdvSize()
    
    AAdd( aObjects, { 000, 008, .T., .T. } )
    AAdd( aObjects, { 030, 100, .T., .T. } )
    
    aInfo := { aSize[1],aSize[2],aSize[3],aSize[4],3,3 }
    aObj  := MsObjSize( aInfo, aObjects, .T. )
    
    DEFINE MSDIALOG oDlg TITLE cTitulo From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
    @ aObj[01,01],004 SAY OemToAnsi(STR0008) SIZE 47,8 OF oDlg PIXEL COLOR CLR_BLUE //"Data Referencia"
    @ aObj[01,01],048 MSGET oDatClc VAR M->LJZ_DATCLQ PICTURE "@D" VALID MsAguarde({|| GetDQUA21(@lPrima)},"Selecionando registros...") SIZE 47,4 PIXEL COLOR CLR_BLACK When Inclui .And. lPrima
    oGetDados := MsGetDados():New(aObj[2,1],aObj[2,2],aObj[2,3],aObj[2,4],nOpcG,cLinOk,cTudOk,"",.T.,,,,,cFieldOk) // 29,1,249,386
    If ! Inclui
        GetDQUA21(@lPrima)
    Endif
    ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca := 1,oDlg:End()},{|| nOpca := 0, oDlg:End() })
    //
    if nOpca == 1
        MsAguarde({|| GrvQUA21()},"Gravando registros...")
    Endif

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ GETDQUA21³ Autor ³ Ricardo Berti         ³ Data ³ 18/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao que administra os campos digitados na GetDados      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GetDQUA21(ExpL1) 				                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1: so' alimenta acols qdo.chamada pela 1a.vez (.T.)	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.. / .F.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CACOL211 - Cooperativa de Leite                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GETDQUA21(lPrima)

    Local _ni
    Local i
    Local lContinua := .T.
    Local c
    Local nCont
    Local nContfim 
    Local aColss
    Private cAliasQry  := GetNextAlias()
    
    aCols	 := {}
    cTipoL	 := "  "
    M->LJZ_DATCLQ := MV_PAR01
    if Inclui
        
        DbSelectArea("LJZ") //Historico da classificacao da Qualidade do leite
        DbSetOrder(1)
        if dbSeek( xFilial("LJZ") + Left(Dtos(M->LJZ_DATCLQ),6) )
            MsgInfo(OemToAnsi(STR0011)+" ("+Dtoc(LJZ->LJZ_DATCLQ)+")",STR0010) //"Ja existe analise da qualidade no mês (11/11/05)..."###"Atencao!"
            lContinua = .f.
        Endif
    
        If lContinua
    
            lContinua = .T.
    
            If lContinua
    
            
            BeginSql Alias cAliasQry
            
            %noparser%
            
            SELECT DISTINCT A2_NOME,PC1_CODPRO,LBB_CODTAN,LBB_TIPOL,LBB_LINHA,LJX_CODBON,LJX_DESC,LJX_ORDEM 
            FROM %table:PC0% PC0 
            INNER JOIN %table:PC1% PC1 ON PC1_FILIAL=PC0_FILIAL AND PC1_NUMSEQ=PC0_NUMSEQ AND PC1.%notDel%
            INNER JOIN %table:LBB% LBB ON LBB_FILIAL=PC0_FILIAL AND LBB_CODPRO=PC1_CODPRO AND LBB.%notDel%
            INNER JOIN %table:SA2% SA2 ON A2_COD=LBB_CODFOR AND A2_LOJA=LBB_LOJA AND SA2.%notDel%
            INNER JOIN %table:LJX% LJX ON LJX_FILIAL=PC1_FILIAL AND LJX.%notDel%
            WHERE PC0_FILIAL=%Exp:cFilAnt% AND PC0.%notDel% AND 
            MONTH(PC0_DTENTR)=%Exp:Month(M->LJZ_DATCLQ)% AND YEAR(PC0_DTENTR)=%Exp:Year(M->LJZ_DATCLQ)% 
            ORDER BY PC1_CODPRO,LJX_ORDEM
    
            EndSql
    
                nCont	 := 0
    
                While (cAliasQry)->( !Eof() ) 
                    
                        nCont++
                        aAdd(aCols,Array(nUsado+1))
            
                        aCols[nCont, 1]  := (cAliasQry)->(PC1_CODPRO)
                        aCols[nCont, 2]  := (cAliasQry)->(A2_NOME) 
                        aCols[nCont, 3]  := (cAliasQry)->(LBB_CODTAN)
                        aCols[nCont, 4]  := (cAliasQry)->(LJX_CODBON)
                        aCols[nCont, 5]  := (cAliasQry)->(LJX_DESC)
                        aCols[nCont, 6]  := CriaVar("LJZ_QTDLEI",.F.)
                        aCols[nCont, 7]  := CriaVar("LJZ_RESLEI",.F.)
        
                    (cAliasQry)->(dbSkip())
                Enddo
    
            EndIf
        EndIf
        
    //aqui - fazer sort do acols conf. ordem selecionada
                
    Else
        
        dbSelectArea("LJZ")
    
    //aqui	abrir indice conf. ordem selecionada ou fazer o mesmo sort acima, apos
        dbSetOrder(1)   
        
        dbSeek(xFilial("LJZ")+Dtos(M->LJZ_DATCLQ))
    
        //aqui - inserir query
        
        While LJZ->LJZ_FILIAL == xFilial("LJZ") .and. !eof() .and. M->LJZ_DATCLQ == LJZ->LJZ_DATCLQ
            
            LBB->(dbSetOrder(1))
            LBB->(dbSeek(xFilial("LBB")+LJZ->LJZ_CODPRO))
    
            AADD(aCols,Array(nUsado+1))
            
            For _ni:=1 to nUsado
                if _ni == 1
                    aCols[Len(aCols),_ni] := LJZ->LJZ_CODPRO
                Elseif _ni == 2
                    aCols[Len(aCols),_ni] := POSICIONE("SA2",1,xFilial("SA2")+LBB->LBB_CODFOR,"A2_NOME") // LBB->LBB_DESC
                Elseif _ni == 3
                    aCols[Len(aCols),_ni] := LBB->LBB_CODTAN
                Elseif _ni == 4
                    aCols[Len(aCols), _ni] := LJZ->LJZ_CODBON
                Elseif _ni == 5
                    aCols[Len(aCols), _ni] := LJZ->LJZ_DESBON
                Elseif _ni == 6
                    aCols[Len(aCols), _ni] := LJZ->LJZ_QTDLEI
                Elseif _ni == 7
                    aCols[Len(aCols), _ni] := LJZ->LJZ_RESLEI
                Else                               
                    aCols[Len(aCols),_ni] := If(aHeader[_ni,10] # "V",FieldGet(FieldPos(aHeader[_ni,2])),CriaVar(aHeader[_ni,2]))
                Endif
            Next
            aCols[Len(aCols),nUsado+1]  := .F.
            dbSkip()
            
        Enddo
    
    Endif
    
    If lContinua
        AcolsS := {}
        For i = 1 to Len(aCols)
            if !aCols[i,1] == Nil
                aadd(aColsS,aCols[i])
            Endif
        Next
        aCols := aColsS
        
        if Type("aCols[1,1]") # "U"
            oGetDados:oBrowse:Refresh()
            oGetDados:nMax:=Len(aCols) // maximo de linhas por getdados de entrada.
        else
            msgStop("Nao existem lancamentos nesta data!!!") 
            lContinua := .F.
            
        Endif
    EndIf
    If lContinua
        lPrima := .F.
    EndIf
    
    
Return(lContinua)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ GrvQUA21  ³ Autor ³ Ricardo Berti         ³ Data ³ 18/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Gravacao                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvQUA21()

    Local i
    Local lGravou 
    Local wProcura
    Local nValGOR := 0
    Local nValPRO := 0
    Local nValCCS := 0
    Local nValCBT := 0
    Local cTipoL  := " "
    
    If nOpcG # 2 //Se nao for consulta
        
        For i:=1 to len(aCols)
    
            lGravou := .F.		
            nValGOR := 0
            nValPRO := 0
            nValCCS := 0
            nValCBT := 0
            cTipoL 	:= "  "
            
            dbselectArea("LJZ")
            dbsetorder(5)
            wProcura := dbseek(xFilial("LJZ")+Dtos(M->LJZ_DATCLQ) + aCols[i][1] + aCols[i][4] ) 
            If ( Inclui  .or. Altera ) .And. .Not. ( aCols[i,len(aCols[i])] .And. wProcura ) //neste caso alterou excluindo
                    
    
                If !aCols[i,len(aCols[i])]
                    LBB->(dbSetOrder(1))
                    LBB->(dbSeek(xFilial("LBB")+aCols[i][1]))  // CODPRO
                    RecLock("LBB",.F.)
                    cTipoL := LBB->LBB_TIPOL
                    
                    /*
                    ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
                    RECalcula os resultados pela Tab. de Criterios da Qualidade
                    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
                    */
                    nResLei	:= QuaCAL21(aCols[i][4],,aCols[i][6] )
                    
                    dbselectArea("LJZ")
                    RecLock("LJZ",If(wProcura,.F.,.T.))
                        LJZ->LJZ_FILIAL  	:= xFilial("LJZ")
                        LJZ->LJZ_DATCLQ  	:= M->LJZ_DATCLQ
                        LJZ->LJZ_CODPRO  	:= aCols[i][1]
                        LJZ->LJZ_DATCLA  	:= dDataBase
                        LJZ->LJZ_CODBON  	:= aCols[i][4] 
                        LJZ->LJZ_DESBON  	:= aCols[i][5] 
                        LJZ->LJZ_QTDLEI     := aCols[i][6] 
                        LJZ->LJZ_RESLEI     := nResLei 
        
                        
                    dbselectArea("LBB")
    
                    MsUnlock()
                    lGravou := .T.
                    
                    dbselectArea("LJZ")
                    MsUnlock()
                            
                Endif
                
            ElseIf nOpcG == 5 // nao pode excluir na getdados, so exclui todos
    
                dbselectArea("LJZ")
                RecLock("LJZ",.F.)
                dbdelete()
                MsUnlock()
            
            Endif
            
        Next
        
    Endif
    
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VCriter21³ Autor ³ Ricardo Berti         ³ Data ³ 27/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualiza Campos na Tela (aCols)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ COL_LEI - Cooperativa de Leite                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VCRITER21()

    Local nValGOR
    Local nValPRO
    Local nValCCS
    Local nValCBT
    Local nValVOL  
    Local nValDIS  
    Local nValTMP  
    Local nValAN1  
    Local nValAN2  
    Local nValAN3  
    Local nResLei
    
    /*
    ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
    Calcula os resultados pela Tabela de Criterios da Qualidade
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
    */   
    nValGOR		:= If(ReadVar()=="M->LJZ_GORDUR",QuaCAL21(SuperGetMv("MV_CTABGOR"),aCols[n][1],M->LJZ_GORDUR ), aCols[n][14] )
    nValPRO		:= If(ReadVar()=="M->LJZ_PROTEI",QuaCAL21(SuperGetMv("MV_CTABPRO"),aCols[n][1],M->LJZ_PROTEI ), aCols[n][15] )
    nValCCS		:= If(ReadVar()=="M->LJZ_CCS"   ,QuaCAL21(SuperGetMv("MV_CTABCCS"),aCols[n][1],M->LJZ_CCS    ), aCols[n][16] )
    nValCBT		:= If(ReadVar()=="M->LJZ_CBT"   ,QuaCAL21(SuperGetMv("MV_CTABCBT"),aCols[n][1],M->LJZ_CBT    ), aCols[n][17] )
    
    nValVOL  	:= If(ReadVar()=="M->LJZ_VOLUME"   ,QuaCAL21(SuperGetMv("MV_CTABVOL"),aCols[n][1],M->LJZ_VOLUME    ), aCols[n][18] )
    nValDIS  	:= If(ReadVar()=="M->LJZ_DISTAN"   ,QuaCAL21(SuperGetMv("MV_CTABDIS"),aCols[n][1],M->LJZ_DISTAN    ), aCols[n][19] )
    nValTMP  	:= If(ReadVar()=="M->LJZ_TEMPER"   ,QuaCAL21(SuperGetMv("MV_CTABTMP"),aCols[n][1],M->LJZ_TEMPER    ), aCols[n][20] )
    
    
    aCols[n,6]	:= If(ReadVar()=="M->LJZ_GORDUR",M->LJZ_GORDUR, aCols[n,6] )
    aCols[n,7]	:= If(ReadVar()=="M->LJZ_PROTEI",M->LJZ_PROTEI, aCols[n,7] )
    aCols[n,8]	:= If(ReadVar()=="M->LJZ_CCS"   ,M->LJZ_CCS   , aCols[n,8] )
    aCols[n,9]	:= If(ReadVar()=="M->LJZ_CBT"   ,M->LJZ_CBT   , aCols[n,9] )
    
    aCols[n,10]	:= If(ReadVar()=="M->LJZ_VOLUME",M->LJZ_VOLUME, aCols[n,10] )
    aCols[n,11]	:= If(ReadVar()=="M->LJZ_DISTAN",M->LJZ_DISTAN, aCols[n,11] )
    aCols[n,12]	:= If(ReadVar()=="M->LJZ_TEMPER",M->LJZ_TEMPER, aCols[n,12] )
    
    aCols[n,14]	:= If(ReadVar()=="M->LJZ_GORDUR",nValGOR, aCols[n,14] )
    aCols[n,15]	:= If(ReadVar()=="M->LJZ_PROTEI",nValPRO, aCols[n,15] )
    aCols[n,16]	:= If(ReadVar()=="M->LJZ_CCS"   ,nValCCS, aCols[n,16] )
    aCols[n,17]	:= If(ReadVar()=="M->LJZ_CBT"   ,nValCBT, aCols[n,17] )
    
    aCols[n,18]	:= If(ReadVar()=="M->LJZ_VOLUME",nValVOL, aCols[n,18] )
    aCols[n,19]	:= If(ReadVar()=="M->LJZ_DISTAN",nValDIS, aCols[n,19] )
    aCols[n,20]	:= If(ReadVar()=="M->LJZ_TEMPER",nValTMP, aCols[n,20] )
    
    
    
    aCols[n,13]	:= aCols[n,14]+aCols[n,15]+aCols[n,16]+aCols[n,17]+aCols[n,18]+aCols[n,19]+aCols[n,20]  // nValGOR+nValPRO+nValCCS+nValCBT
    
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ QuaCAL21  ³ Autor ³ Ricardo Berti         ³ Data ³ 18/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Calculo do valor de acresc/desc. no litro do leite³±±
±±³          ³ com base no criterio (GOR/PRO/CCS/CBT) e no tipo do leite   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExprN1 := QuaCAL21( ExprC1, ExprC2, ExprN2 ) 			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExprC1 = Cod.da Tab.de Criterios da Qualidade	   	 	   ³±±
±±³          ³ ExprC2 = Tipo do Leite                            	 	   ³±±
±±³          ³ ExprN2 = Valor ref. a Analise do Criterio da Qualidade      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExprN1 = valor de acresc/desc. no litro do leite			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cooperativa de Leite                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QuaCAL21( cTabQua, cTipoL, nValor)

    Local nResul	:= 0
    Local aArea		:= GetArea()
    Local nTamChave := Len(CriaVar("LJY_CODBON"))  // Adequa nome da tabela ao tam.do campo
    
    cTabQua := Left(cTabQua+Space(nTamChave),nTamChave)
    
    dbselectArea("LJY") // Tabela Criterios da Qualidade
    dbSetOrder(2)
    dbseek( xFilial("LJY")+cTabQua )
    Do While !Eof() .And. ;
        ( LJY->LJY_FILIAL+LJY->LJY_CODBON = xFilial("LJY")+cTabQua )
        If nValor >= LJY_VInic .And. nValor <= LJY_VFinal
           nResul := LJY_VResul
             Exit
        EndIf
        dbSkip()
    EndDo
    RestArea(aArea)

Return(nResul)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ PCposBrw ³Autor  ³Ricardo Berti          ³ Data ³ 05/01/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Trata alguns campos e a seq.a serem exibidos na mBrowse	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PCposBrw() 	    				                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpA1 = array aCampos = campos prioritarios exibidos		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ COL_LEI Cooperativa de Graos                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PCposBrw()

    Local aArea		:= GetArea()
    Local aCampos	:= {}
    
    dbSelectArea("SX3")
    dbSetOrder(1)
    dbSeek("LJZ")
    While !Eof().And.(x3_arquivo=="LJZ")
            If Alltrim(x3_campo) == "LJZ_DATCLQ"
                AAdd(aCampos,  { AllTrim(X3Titulo()) ,"LJZ_DATCLQ"}) 
            ElseIf Alltrim(x3_campo) == "LJZ_CODPRO"
                AAdd(aCampos,  { AllTrim(X3Titulo()) ,"LJZ_CODPRO"})
            EndIf
            dbSkip()
    Enddo
    
    RestArea(aArea)

Return(aCampos)

Static Function GETDQUA2A()
	
	Local cTipoBon		:= ' '
	Local nResLei 		:= 0
	Local nLitros			:= 0
	Local nDistan   	:= 0
	Local dData 		:= dtos(LJZ->LJZ_DATCLQ)
	Private cAliasQry  	:= GetNextAlias()


    Pergunte("QUAR082R",.F.)
    MV_PAR01 := LJZ->LJZ_DATCLQ

	DbSelectArea("LJZ") //Historico da classificacao da Qualidade do leite
	DbSetOrder(1)

	If dbSeek( xFilial("LJZ") + dData)
		
		While !Eof() .AND. xFilial("LJZ") == LJZ->LJZ_FILIAL .AND. LJZ->LJZ_DATCLQ == stod(dData) 
			
			// 1-PLANILHA-> Sera usada planilha para entrar com dados no sistema,
			// 2-VOLUME->Sera usado o volume captado pelo produtor no sistema para calculo,
			// 3-DISTANCIA->Sera usado o campo distancia do produtor ate o laticinio do cadastro de propriedades,
			// 4-DIGITADO->No caso de adicional de Mercado para composicao do preco no simulador.     
			LJZArea := GetArea()
			
			cTipoBon     := Posicione("LJX",1,XFILIAL("LJZ")+LJZ->LJZ_CODBON,"LJX_TPBON") 
            
            If !cTipoBon $ ('2|3') 		
				RestArea(LJZArea)
				dbSkip()
				Loop
			EndiF
				
			If cTipoBon  ==  '2'  // VOLUME
				
				nLitrosAtu 	:= LJZ->LJZ_QTDLEI
				nLitros        := U_RetLitros(LJZ->LJZ_CODPRO)
				
				If nLitros <> nLitrosAtu
					nResLei 	  := U_QuaCAL21(Alltrim(LJZ->(LJZ_CODBON)),,nLitros)
				Else
					nLitros := 0				
				EndiF
			
			ElseIf cTipoBon  ==  '3' // DISTANCIA
				
			nDistanAt  := LJZ->LJZ_QTDLEI
				nDistan 	   := Posicione("LBB",1,XFILIAL("LBB")+LJZ->LJZ_CODPRO,"LBB_DISTAN")
				
				If nDistan <> nDistanAt 
					nResLei 	  := U_QuaCAL21(Alltrim(LJZ->(LJZ_CODBON)),,nDistan)
				Else
					nDistan := 0				
				EndiF

			EndiF	
			
			RestArea(LJZArea)

        MsProcTxt("Recalculando Bonificacoes >>> " + LJZ->LJZ_CODPRO)

			If (nLitros+nDistan) > 0
				RecLock("LJZ",.F.)
					LJZ->LJZ_RESLEI		:= nResLei
					LJZ->LJZ_QTDLEI 	:= nLitros+nDistan 
				MsUnlock()
			EndIf
			
			nLitros := 0
			nDistan := 0
			nResLei := 0
			
			dbSkip()
			
		EndDo
	End If

Return  
