#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQUAA029   บAutor  ณCristiane T Polli   บ Data ณ  02/14/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Esta rotina tem por objetivo criar as notas promissorias   บฑฑ
ฑฑบ          ณ referente ao adiantamento realizado pelo Quatแ para os pro-บฑฑ
ฑฑบ          ณ dutores.                                                   บฑฑ
ฑฑบ          ณ Projeto n
บ FS07529302  PL_38                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especificos Quata                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function QUAA029()

Private cCadastro := "Nota Promissoria"

Private aRotina := {	{"Pesquisar" ,"AxPesqui"    ,0,1},;
						{"Visualizar","U_QUAA029A"	,0,2},;
						{"Incluir"   ,"U_QUAA029A"	,0,3},;		
						{"Excluir"   ,"U_QUAA029A"	,0,4},;
						{"Trocar"    ,"U_QUAA029A"	,0,5}}
dbSelectArea("PB1")
PB1->(dbSetOrder(1))
dbSelectArea("PB2")
PB2->(dbSetOrder(1))
dbSelectArea("SE2")
SE2->(dbSetOrder(1))                                

mBrowse(06, 01, 22, 75, "PB1")

Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQUAA029A  บAutor  ณCristiane T Polli   บ Data ณ  02/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica qual ้ a op็ใo e chama a fun็ใo para montar a tela.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especificos Quata                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function QUAA029A(cAlias,nReg,nOpc) 

Local aAreaPB1		:= PB1->(GetARea())
Local aAreaPB2		:= PB2->(GetArea())
Private oDlg
Private oGetParc     
Private aHeadPB2  	:= {}
Private aCol		:= {}
Private aColsReg1	:= {}
Private aTmpCols	:= {}

if nOpc == 4  .or. nOpc == 5
	PB2->(dbSetOrder(1))
	if PB2->(dbSeek(xFilial("PB2")+PB1->PB1_NUMNOT))
		if SE2->(dbSeek(xFilial("SE2")+PB2->PB2_PREFTI+PB2->PB2_NTITUL))
			While PB2->PB2_PREFTI+PB2->PB2_NTITUL == SE2->E2_PREFIXO+SE2->E2_NUM		
				if SE2->E2_SALDO == 0
					ApMsgInfo("Jแ houve abatimento para esse adiantamento.","Exclusใo nใo permitida.")		
					Return
				EndIf
				SE2->(dbSkip())
			EndDo
		EndIf
	EndIf
EndIf

//Monta o aHeadPB2er, com exe็ao do campo informado no array.
aHeadPB2 := PB2->(ApBuildHeader("PB2",{"PB2_NUMNOT"})) 

If nOpc == 3 
	aTmpCols  :=  A610CriaCols("PB2", aHeadPB2) 
	PB2->(GDFieldPut("","", 1, aHeadPB2, aTmpCols[1]))
	aCol		:= aClone(aTmpCols[1])
	aColsReg1	:= aClone(aTmpCols[2])
Else
	PB2->(xFilial("PB2")+PB1->PB1_NUMNOT)
	aTmpCols	:= A610CriaCols("PB2", aHeadPB2, xFilial("PB2")+PB1->PB1_NUMNOT, {|| PB2->(PB2_FILIAL+PB2_NUMNOT) == xFilial("PB1")+PB1->PB1_NUMNOT})
	aCol		:= aClone(aTmpCols[1])
	aColsReg1	:= aClone(aTmpCols[2])	
EndIf	

U_QUAATELA(cAlias,nReg,nOpc) 

RestArea(aAreaPB1)
RestArea(aAreaPB2)
	
Return Nil
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQUAATELA  บAutor  ณCristiane T Polli   บ Data ณ  02/14/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta Dialog.                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especificos Quata                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function QUAATELA(cAlias,nReg,nOpc)

Local nOpcA			:= 0
Local _aArea		:= GetArea()              
Local aCpoEnch  	:= {}
Local aAlterEnch	:= {}
Local aPos		  	:= {C(011),C(000),C(075),C(294)}
Local nModelo	  	:= 3       	// Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local lF3 		  	:= .F.		// Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria  	:= .T.		// Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lColumn	  	:= .F.		// Indica se a apresentacao dos campos sera em forma de coluna
Local caTela 	  	:= "" 		// Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lNoFolder 	:= .F.		// Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty 	:= .T.		// Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local aNaoVisual	:= {"PB1_FILIAL"}
Private aObjects 	:= {}
Private aSize, aInfo, aPosObj,oEncho

RegToMemory(cAlias, nOpc==3 , .F.)

dbSelectArea("SX3")
dbSeek("PB1")
while SX3->X3_ARQUIVO = "PB1"
	if Ascan( aNaoVisual, Alltrim(SX3->X3_CAMPO)) = 0
		Aadd( aCpoEnch, SX3->X3_CAMPO)		
		Aadd(aAlterEnch, SX3->X3_CAMPO)
	endif
	dbSkip()
enddo

AADD(aObjects,{100,100,.T.,.T.,.F.}) // Indica dimensoes x e y e indica que redimensiona x e y e assume que retorno sera em linha final coluna final (.F.)
AADD(aObjects,{100,100,.T.,.T.,.F.}) // Indica dimensoes x e y e indica que redimensiona x e y

aSize:=MsAdvSize()
aInfo:={aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj:=MsObjSize(aInfo,aObjects)

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL


oEncho := Msmget():New(cAlias,nReg ,aRotina[nOpc,4],/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,/*cTudoOk*/,oDlg,lF3,lMemoria,lColumn,caTela,lNoFolder,lProperty)
	QUAAGET(nOpc,aPosObj[2])
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| nOpcA:=1,If(U_QUAATUOK(nOpc),oDlg:End(),nOpca:=0)},{||nOpca:=0,oDlg:End()})

If nOpcA == 1 .and. nOpc <> 2 	
//	Begin Transaction
		If QUAAGRV(nOpc)
			EvalTrigger()
			If __lSX8
				ConfirmSX8()			
			Endif
		Else
			If __lSX8
				RollBackSX8()
			Endif	
		EndIf
	//End Transaction
Else
	If __lSX8
		RollBackSX8()
	Endif			 
Endif

RestArea(_aArea)

Return Nil
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQUAAGET   บAutor  ณCristiane T Polli   บ Data ณ  02/14/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta a GetDados.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especificos Quata.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function QUAAGET(nOpcx, aPos)

Local nSuperior    	:= aPos[1]
Local nEsquerda    	:= aPos[2]
Local nInferior    	:= aPos[3]
Local nDireita     	:= aPos[4]
Local nOpc         	:= GD_INSERT+GD_DELETE+GD_UPDATE                                                                            
Local cTudoOk      	:= "AllwaysTrue" 
Loca  cLinhaOk		:= "AllwaysTrue" //ANLnOK()		 
Local nFreeze      	:= 000              // Campos estaticos na GetDados.
Local nMax         	:= 999              // Numero maximo de linhas permitidas. Valor padrao 99                           
Local cFieldOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo                                           
Local cSuperDel    	:= ""              // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cDelOk       	:= "AllwaysTrue"   // Funcao executada para validar a exclusao de uma linha do aCols                   
Local oWnd         	:= oDlg                                                                                                  
oGetParc:= MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc, cLinhaOk,cTudoOk ,"",;                         
                             /*aAlter*/,nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oWnd,aHeadPB2,aCol)
 
Return Nil  
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()   ณ Autores ณ Norbert/Ernani/Mansano ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolucao horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
 
 	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                 
Return Int(nTam)  
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQUAATUOK  บAutor  ณCristiane T Polli   บ Data ณ  02/18/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida a inclusใo da nota promissoria.					  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Quata.                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function QUAATUOK(nOpc) 
 
Local lTudoOK	:= .T.

if INCLUI
	if (U_VLDCODPR()) == .F.
		Return .F.
	Elseif (U_SOMAPARC()) == .F.
		Return .F.
	Elseif (U_VLDCPOEN()) == .F.	
		Return .F.
	EndIf	
Endif
 
Return lTudoOK
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQUAAGRV   บAutor  ณCristiane T Polli   บ Data ณ  02/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ap๓s validar, grava as notas promissorias.                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especificos Quata.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function QUAAGRV(nOpc)
Local _aArea	:= GetArea() 
Local i			:= 0 
Local nI		:= 0 
Local lGravado	:= .T.
Local cNum		:= ''
Local cTexto	:= 'NOTA PROMISSORIA PRODUTOR'           
//Local cPrefixo	:= SuperGetMv("MV_ESPRENP",,"NP")
Local cPrefixo	:= &(GetMv("MV_1DUPREF"))
Local cNaturez	:= SuperGetMv("MV_ESNATNP",,"0000000001")
Local cCodBco	:= SuperGetMv("MV_BCOBAIX",,"341")
Local cAgencia	:= cNConta := ''
Local cParcPB2	:= aScan(aHeadPB2, {|x| rTrim(x[2]) == "PB2_NPARCE"})
Local cVencPB2	:= aScan(aHeadPB2, {|x| rTrim(x[2]) == "PB2_DTVENC"}) 
Local nPosVl	:= aScan(aHeadPB2, {|x| rTrim(x[2]) == "PB2_VLPPAR"})
Local dDtUtil	:= Ctod("  /  /  ")

if nOpc == 3

	SED->(dbSetOrder(1))
	if !SED->(dbSeek(xFilial("SED")+cNaturez))
		Aviso("Natureza - MV_ESNATNP","Nใo ้ possํvel incluir a NP. C๓d.da Natureza("+cNaturez+") nใo localizado.Informe outro c๓d. no parโametro MV_ESNATNP.",{"OK"})
		Return .F.
	EndIf
	SA6->(dbSetOrder(1))
	if !SA6->(dbSeek(xFilial("SA6")+cCodBco))
		Aviso ("Cod.Banco - MV_BCOBAIX","C๓digo de banco("+cCodBco+") nใo localizado.Informe um c๓d. vแlido no parametro MV_BCOBAIX",{"OK"})
		Return .F.
	Else
		cAgencia := SA6->A6_AGENCIA
		cNConta	 := SA6->A6_NUMCON		
	EndIf  
	
	cNum	:= ProxNum()//GetSxeNum("SE2","E2_NUM") 
	
	For i:= 1 to len(oGetParc:aCols)  	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณGrava o titulo a pagar (SE2), caso nใo seja possivel grava-lo, o processo ณ
		//ณda grava็ใo da NP serแ abortado.                                          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if GRAVSE2(cPrefixo,cNum ,oGetParc:aCols[i][cParcPB2],cNaturez,oGetParc:aCols[i][cVencPB2], oGetParc:aCols[i][nPosVl],cTexto,cCodBco,cAgencia,cNConta,nOpc) == .T.
			lGravado	:= .F.
			Exit
		Else
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณse gravou o titulo a pagar grava a  nota promiss๓ria.ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				PB2->(Reclock("PB2",.T.))
				PB2->PB2_FILIAL	:= xFilial("PB2")	//M->PB1_FILIAL	
		  		PB2->PB2_NUMNOT	:= M->PB1_NUMNOT
				For nI := 1 To Len(oGetParc:aHeader)
					PB2->(FieldPut(FieldPos(Trim(oGetParc:aHeader[nI,2])),oGetParc:aCols[i,nI]))
				Next nI 
				PB2->PB2_PREFTI	:= cPrefixo
				PB2->PB2_NTITUL	:= cNum	
				PB2->(MsUnlock())
		Endif
	Next i

	If lGravado
		_cParcela 	:= Iif(GetMv("MV_1DUP")="A", padr("A",tamsx3("E2_PARCELA")[1]), padl("01",tamsx3("E2_PARCELA")[1],"0"))
		_dVenc		:= dDataBase
		_nValor		:= M->PB1_VLTOTA
		

		if GRAVSE2(cPrefixo,cNum ,_cParcela,cNaturez,_dVenc, _nValor,cTexto,cCodBco,cAgencia,cNConta,nOpc,"D")
			lGravado	:= .F.
		Endif
	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณse gravou os itens da nota promiss๓ria, grava o cabe็alho.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if lGravado		
		PB1->(Reclock("PB1",.T.))
			PB1->PB1_FILIAL := xFilial("PB1")
			PB1->PB1_NUMNOT := M->PB1_NUMNOT
			PB1->PB1_CODFOR := M->PB1_CODFOR
			PB1->PB1_LJFORN := M->PB1_LJFORN
			PB1->PB1_NOME 	:= M->PB1_NOME
			PB1->PB1_CODPRO := M->PB1_CODPRO
			PB1->PB1_NOMEPR := M->PB1_NOMEPR
			PB1->PB1_VLTOTA := M->PB1_VLTOTA
			PB1->PB1_NPARCE := M->PB1_NPARCE
			PB1->PB1_DTEMIS := M->PB1_DTEMIS
		PB1->(MsUnlock())
	EndIf
				
Elseif nOpc == 4	
//	Begin Transaction 
		for i := 1 To Len(aColsReg1)
	    	if !Empty(aColsReg1[i])	    	                                              
				PB2->(dbGoto(aColsReg1[i]))
				PB2->(RecLock("PB2",.F.))
				PB2->(dbDelete())
				PB2->(msUnlock())
				SE2->(dbSetOrder(1))
				If SE2->( dbSeek( xFilial("SE2") + PB2->PB2_PREFTI + PB2->PB2_NTITUL + Padr(PB2->PB2_NPARCE,TamSX3("E2_PARCELA")[1]) ) )
				   if GRAVSE2(PB2->PB2_PREFTI,PB2->PB2_NTITUL ,Padr(PB2->PB2_NPARCE,TamSX3("E2_PARCELA")[1]),,,,,,,,5) == .T.
						Aviso("Exclusใo de NP Titulo a Pagar","Nใo foi possํvel excluir o titulo a pagar, processo cancelado.",{"OK"})		   							
						lGravado := .f.
	 				    Exit
				   EndIf
				EndIf
			endif
		next  i	
		If lGravado
			_cParcela 	:= Iif(GetMv("MV_1DUP")="A", padr("A",tamsx3("E2_PARCELA")[1]), padl("01",tamsx3("E2_PARCELA")[1],"0"))

			if GRAVSE2(PB2->PB2_PREFTI,PB2->PB2_NTITUL ,_cParcela,,,,,,,,5,"D") == .T.
				Aviso("Exclusใo de NP Titulo a Pagar","Nใo foi possํvel excluir o titulo a pagar, processo cancelado.",{"OK"})		   							
				lGravado := .F.
		  	endif
		Endif
		if lGravado		
			PB1->(dbSetOrder(1))
			PB1->(dbSeek(xFilial("PB1")+PB1->PB1_NUMNOT))
			PB1->(RecLock("PB1",.F.))
			dbDelete()
			PB1->(msUnlock())
		EndIf	
	//End Transaction 
Elseif nOpc == 5
	cNewCod 	:= ""
	cNewLoja	:= ""
	cNewNome	:= ""
	cNewProp	:= ""
	cNewNomPro	:= ""
	
	If PegaDad()
	
	aMyTemp 	:= {}
	nPosNumParc	:= 0
	nPosValParc	:= 0
	nPosDtVenc	:= 0
	nPosNumParc	:= ascan(oGetParc:aHeader, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("PB2_NPARCE"))} )
	nPosDtVenc	:= ascan(oGetParc:aHeader, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("PB2_DTVENC"))} )
	nPosValParc	:= ascan(oGetParc:aHeader, {|x| Alltrim(Upper(x[2])) == Alltrim(Upper("PB2_VLPPAR"))} )
	If !Empty(nPosNumParc) .and.  !Empty(nPosDtVenc) .and. !Empty(nPosValParc)
//		Begin Transaction 
			for i := 1 To Len(aColsReg1)
			
		    	if !Empty(aColsReg1[i])	    	                                              
					PB2->(dbGoto(aColsReg1[i]))

					SE2->(dbSetOrder(1))
					If SE2->( dbSeek( xFilial("SE2") + PB2->PB2_PREFTI + PB2->PB2_NTITUL + Padr(PB2->PB2_NPARCE,TamSX3("E2_PARCELA")[1]) ) )
						If SE2->E2_SALDO == SE2->E2_VALOR
					   		if GRAVSE2(PB2->PB2_PREFTI,PB2->PB2_NTITUL ,Padr(PB2->PB2_NPARCE,TamSX3("E2_PARCELA")[1]),,,,,,,,5) == .T.
								Aviso("Exclusใo de NP Titulo a Pagar","Nใo foi possํvel excluir o titulo a pagar, processo cancelado.",{"OK"})		   							
								lGravado := .f.
					   		Else	
					   			aadd(aMyTemp, {PB2->PB2_PREFTI, PB2->PB2_NTITUL , Padr(PB2->PB2_NPARCE,TamSX3("E2_PARCELA")[1]), PB2->PB2_VLPPAR } )
								PB2->(RecLock("PB2",.F.))
								PB2->PB2_PREFTI	:= ""
								PB2->PB2_NTITUL := ""
								PB2->PB2_NPARCE := ""
								PB2->PB2_VLPPAR := 0
								PB2->(msUnlock())
					   		EndIf
					   	Endif
					EndIf
				endif
			next  i	
			if lGravado
				cNewNum	:= U_ProxNP()
				nNewVal := 0
				nNewVal	:= aeval(aMyTemp, { |x| nNewVal += x[1] } )
				cNum 	:= cNewNum 		
				
				PB1->(dbSetOrder(1))
				PB1->(dbSeek(xFilial("PB1")+PB1->PB1_NUMNOT))
				PB1->(RecLock("PB1",.F.))
				PB1->PB1_VLTOTA	:= PB1->PB1_VLTOTA - nNewVal
				PB1->(msUnlock())
				cDtEmis := PB1->PB1_DTEMIS
				
				lGrava1 := .T.
				For i := 1 to len(aMyTemp) //{PB2->PB2_PREFTI, PB2->PB2_NTITUL , Padr(PB2->PB2_NPARCE,TamSX3("E2_PARCELA")[1]), PB2->PB2_VLPPAR }
					if GRAVSE2(cPrefixo,cNum ,aMyTemp[i][3],cNaturez,aMyTemp[i][5], aMytemp[i][4],cTexto,cCodBco,cAgencia,cNConta,3) == .T.
						lGrava1	:= .F.
						Exit
					Else
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณse gravou o titulo a pagar grava a  nota promiss๓ria.ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						PB2->(Reclock("PB2",.T.))
						PB2->PB2_FILIAL	:= xFilial("PB2")
		  				PB2->PB2_NUMNOT	:= cNewNum
						PB2->PB2_NPARCE	:= aMyTemp[i][3]
						PB2->PB2_VLPPAR	:= aMyTemp[i][4]
						PB2->PB2_DTVENC	:= aMyTemp[i][5]
						PB2->PB2_PREFTI	:= cPrefixo
						PB2->PB2_NTITUL	:= cNum	
						PB2->(MsUnlock())
					Endif
				Next i
				If lGrava1
					PB1->(Reclock("PB1",.T.))
						PB1->PB1_FILIAL := xFilial("PB1")
						PB1->PB1_NUMNOT := cNewNum
						PB1->PB1_CODFOR := cNewCod
						PB1->PB1_LJFORN := cNewLoja
						PB1->PB1_NOME 	:= cNewNome
						PB1->PB1_CODPRO := cNewProp
						PB1->PB1_NOMEPR := cNewNomPro
						PB1->PB1_VLTOTA := nNewVal
						PB1->PB1_NPARCE := len(aMyTemp)
						PB1->PB1_DTEMIS := cDtEmis
					PB1->(MsUnlock())
				Endif
			EndIf	
		//End Transaction 
    Endif
    Endif
EndIf	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณse concluiu a grava็ใo chama a rotina para impressใo.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if lGravado .AND. nOpc == 3
	U_QUAR028()
EndIf	

RestArea(_aArea) 

Return lGravado

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVLDCODPR  บAutor  ณCristiane T Polli   บ Data ณ  02/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida se o codigo do fornecedor informado esta relacionadoบฑฑ
ฑฑบ          ณ ao codigo do produtor                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especificos Quata.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function VLDCODPR()

Local aArea		:= GetArea()
Local lProdutor	:= .T.
Local cProdutor	:= ''

if !Empty(M->PB1_CODPRO)
	LBB->(dbSetOrder(1))
	if LBB->(dbSeek(xFilial("LBB")+M->PB1_CODPRO))
		cProdutor := LBB->LBB_CODPRO
		While cProdutor == LBB->LBB_CODPRO
			if LBB->LBB_CODFOR == M->PB1_CODFOR .AND. LBB->LBB_LOJA == M->PB1_LJFORN
				RestArea(aArea)
				Return .T.
			Endif
			LBB->(dbSkip())
		EndDo		
	EndIf
	
	Aviso("Valida็ใo de fornecedor","Informe um cod. de fornecedor que esteja relacionado ao cod.do produtor selecionado.",{"OK"})
	lProdutor := .F.
EndIf

RestArea(aArea)

Return lProdutor
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCALCPARC  บAutor  ณCristiane T Polli   บ Data ณ  02/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalcula o valor da parcela ap๓s o preenchimento de campo    บฑฑ
ฑฑบ          ณ PB1_VLTOTA e PB1_NPARCE                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especificos Quata                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CALCPARC()

Local aArea		:= GetArea() 
Local cParcPB2	:= aScan(aHeadPB2, {|x| rTrim(x[2]) == "PB2_NPARCE"})
Local nPosParc	:= aScan(aHeadPB2, {|x| rTrim(x[2]) == "PB2_VLPPAR"})
Local nPosDtVen	:= aScan(aHeadPB2, {|x| rTrim(x[2]) == "PB2_DTVENC"})

Local i,nX		:= 0
Local nParc		:= Val(M->PB1_NPARCE)
Local aAux		:= {} 
Local lCalc		:= .T.
Local nVlparc   := Round(M->PB1_VLTOTA/nParc,2)
Local _dDatIni	:= M->PB1_DTEMIS

if nParc == 0 
	Aviso("N๚mero de parcelas","Informe um n๚mero de parcelas vแlido!",{"OK"})
	RestArea(aArea) 
EndIf
if nVlparc < 0
	Aviso("Valor por parcela","Valor inferior ou igual a zero, nใo ้ permitido.Reveja os valores e as parcelas.",{"OK"})
	RestArea(aArea)
	Return .F.
EndIf
oGetParc:aCols	:= {}

For i:= 1 to nParc
	aAux := {}
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2)) // Campo
	For nX := 1 to Len(aHeadPB2)
		If SX3->(DbSeek(aHeadPB2[nX][2]))
			Aadd(aAux,CriaVar(SX3->X3_CAMPO))
		Endif
	Next nX
	Aadd(aAux,.F.)
 	aAux[cParcPB2]	:= Alltrim(strzero(i,2))
 	aAux[nPosParc]	:= nVlparc
 	aAux[nPosDtVen] := _dDatIni + (30*i)
 	Aadd(oGetParc:aCols,aAux)
Next i

oGetParc:Refresh()

RestArea(aArea) 

Return lCalc 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSOMAPARC  บAutor  ณCristiane T Polli   บ Data ณ  02/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se a soma das parcelas ้ igual ao valor total in- บฑฑ
ฑฑบ          ณ formado.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especificos Quata.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function SOMAPARC()  
Local aArea	:= GetArea()
Local lSoma	:= .T.
Local iSoma	:= 0  
Local nTotal := 0
Local nPosParc	:= aScan(aHeadPB2, {|x| rTrim(x[2]) == "PB2_VLPPAR"})

For iSoma := 1 to len(oGetParc:aCols)
	nTotal	+= oGetParc:aCols[iSoma][nPosParc]
Next iSoma

if nTotal <> M->PB1_VLTOTA
	Aviso("Valor Total","A soma das parcelas estแ diferente do valor total informado no cabe็alho.",{"OK"})
	RestArea(aArea)
	Return .F.
Endif
RestArea(aArea)

Return lSoma  
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVLDCPOEN  บAutor  ณCristiane T Polli   บ Data ณ  02/18/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida se os campos obrigatorios foram preenchidos.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especificos Quata.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function VLDCPOEN()

Local aArea		:= GetArea()
Local lCampo	:= .T.
Local cCampo	:= ReadVar()
Local nC		:= 0
Local nPosVenc	:= aScan(aHeadPB2, {|x| rTrim(x[2]) == "PB2_DTVENC"})

if IsInCallStack("U_QUAATUOK") == .T.
	if Empty(M->PB1_CODPRO) .OR. Empty(M->PB1_CODFOR) .OR. Empty(M->PB1_LJFORN)
		HELP(" ",1,"OBRIGAT",,"Verifique o preenchimento dos campos cod.Fornecedor/loja e/ou cod.produtor.",3,0)
		RestArea(aARea)
		return .F.
	ElseIf 	M->PB1_VLTOTA == 0 .OR. Empty(M->PB1_NPARCE)
		HELP(" ",1,"OBRIGAT",,"Verifique o preenchimento dos campos valor total e/ou parcela.",3,0)		
		RestArea(aARea)
		return .F. 		
	Else
		for nC	:= 1 to len(oGetParc:aCols)
	  		if vazio(oGetParc:aCols[nC][nPosVenc])	  				
			HELP(" ",1,"OBRIGAT",,"Verifique o preenchimento dos campos data de vencimento das parcelas geradas.",3,0)			  			
		 		RestArea(aARea)
		  		return .F.  		
	  		EndIf
		Next nC
	EndIf
Elseif Empty(cCampo)                                          
	MsgStop("Preencha o campo, preenchimento obrigat๓rio!")
	lCampo := .F.	
EndIf

RestArea(aARea)

Return lCampo   
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVLDTVENC  บAutor  ณCristiane T Polli   บ Data ณ  02/18/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se a data de vencimento das parcelas estao corretaบฑฑ
ฑฑบ          ณ s. A data de venc. de uma parcela deverแ ser maior do que  บฑฑ
ฑฑบ          ณ a data de vencimento da parcela anterior.			      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especificos Quata.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function VLDTVENC()

Local aArea	:= GetArea()
Local lDtVenc	:= .T.
Local nlinhas	:= len(oGetParc:aCols)                             
Local nPosVenc	:= aScan(aHeadPB2, {|x| rTrim(x[2]) == "PB2_DTVENC"})
Local cCampo	:= ReadVar()  
Local i			:= 0

if &cCampo <= M->PB1_DTEMIS .and. n == 1
	MsgStop("A data do vencimento deve  ser maior que a data atual.")  
	lDtVenc := .F.
Else
	For i:= nLinhas to 1 step -1 	
		if i < n //se for menor que a linha atual comparo com as linha acima.
			if oGetParc:aCols[i][nPosVenc] >= &cCampo
				MsgStop("A data vencimento deve ser superior a data de vencimento da parcela anterior.")		
				lDtVenc := .F.				
			EndIf		
		EndIf
	Next i
EndIf

RestArea(aArea)

Return lDtVenc 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGRAVSE2   บAutor  ณCristiane T Polli   บ Data ณ  02/18/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava o titulo a pagar (SE2).                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecificos Quata.                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/	
Static Function	GRAVSE2(cPrefixo,cNum ,cParcela,cNaturez,dVenc,nValor,cTexto,cCodBco,cAgencia,cNConta,nOpcao,cTplan)
Local aArea		:= GetArea()
Local dVencre	:= ''
Local aDados	:= {} 
Local cTipo		:= "NDF"
Default cTpLan	:= "P"

Private lMsErroAuto	:= .F.
If cTpLan <> "P"
	cTipo := "NP "
Endif
	
dbSelectArea("SE2")
SE2->(dbSetOrder(1))            

if nOpcao == 3 
	dVencre	:= DataValida(dVenc)
	aDados := {{"E2_PREFIXO"	,cPrefixo	 	,Nil},;
				{"E2_NUM"		,cNum		 	,Nil},;
				{"E2_PARCELA"	,cParcela		,Nil},;			
				{"E2_TIPO"		,cTipo			,Nil},;
				{"E2_NATUREZA"	,cNaturez		,Nil},;			
				{"E2_FORNECE"	,M->PB1_CODFOR	,Nil},;			
				{"E2_LOJA"		,M->PB1_LJFORN	,Nil},;
				{"E2_NOMFOR"	,M->PB1_NOME	,Nil},;					
			   	{"E2_EMISSAO"	,dDataBase		,Nil},;			
				{"E2_VENCTO"	,dVenc			,Nil},;			
				{"E2_VENCREA"	,dVencre		,Nil},;	 
				{"E2_VALOR"		,nValor			,Nil},;	
				{"E2_HIST"		,cTexto			,Nil},;
				{"E2_VLCRUZ"	,nValor			,Nil},;
				{"CHISTOR"		,cTexto			,Nil},;
				{"AUTBANCO"		,cCodBco		,Nil},;								
				{"AUTAGENCIA"	,cAgencia		,Nil},;
				{"AUTCONTA"		,cNConta		,Nil};
				}
	
Else 
	aDados := {{"E2_PREFIXO"	,cPrefixo	 	,Nil},;
				{"E2_NUM"		,cNum		 	,Nil},;
				{"E2_PARCELA"	,cParcela		,Nil},;			
				{"E2_TIPO"		,cTipo			,Nil}}

EndIf

MSExecAuto({|x,y,z| FINA050(x,y,z)},aDados,,nOpcao) 					 

If lMsErroAuto                                             
      	cNomeArq := NomeAutoLog()
      	mostraerro("")
      	MsgStop("Ocorreu um erro na grava็ใo do titulo. Leia o arquivo "+ cNomeArq,"Aten็ใo !")      
      	DisarmTransaction()
EndIf 


dbSetOrder(1)	
dbSelectArea("PB1")
dbSelectArea("PB2")

RestArea(aArea)

Return lMsErroAuto



User Function ProxNP()
Local cRet 		:= ""
Local cQuery 	:= ""
Local nTamanho	:= TamSX3("PB1_NUMNOT")[1]
Local aAreaAnt	:= GetArea()

cQuery := "SELECT IsNull(MAX(PB1_NUMNOT),' ') AS MAIOR FROM " + RETSqlName("PB1") + " WHERE D_E_L_E_T_ = ' ' "

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRY1', .F., .T.)

dbSelectArea("QRY1")
dbGotop()
If !eof()
	If !Empty(QRY1->MAIOR)
		cRet := QRY1->MAIOR
	Else
		cRet := replicate("0", nTamanho)
	Endif
Else
	cRet := replicate("0", nTamanho)
Endif

dbSelectArea("QRY1")
dbCloseArea()

RestArea(aAreaAnt)

cRet := Soma1(cRet)

Return cRet





Static Function PegaDad()
Local cPropri	:= Space( Tamanho("LBB_CODPRO")[1] )
Local _nOpca	:= 0
Local aAreaAnt	:= GetArea()

Define MSDialog oDlg Title "Trocar Propriedade" From 0,0 To 100,350 Pixel

@ 10,10 Say "Nova Propriedade:" Pixel Of oDlg
@ 10,50 MSGET cPropri Picture "@!"  F3 "LBB" Size 120,10 Pixel Of oDlg

@ oDlg:nHeight/2-30,oDlg:nClientWidth/2-70 Button oBtnOk     Prompt "Confirma" Size 30,15 Pixel Action {|| _nOpca:=1, oDlg:End() } Of oDlg
@ oDlg:nHeight/2-30,oDlg:nClientWidth/2-35 Button oBtnCancel Prompt "Cancelar" Size 30,15 Pixel Action oDlg:End() Cancel Of oDlg

Activate MSDialog oDlg Centered

If _nOpca <> 0
	cNewCod 	:= ""
	cNewLoja	:= ""
	cNewNome	:= ""
	cNewProp	:= cPropri
	cNewNomPro	:= ""
	
	dbSelectArea("LBB")
	dbSetOrder(1)
	If dbSeek( xFilial("LBB") + cNewProp )
		cNewNomPro	:= LBB->LBB_DESC
		dbSelectArea("SA2")
		dbSetOrder(1)
		
		If dbSeek( xFilial("SA2") + LBB->(LBB_CODFOR + LBB_LOJA) )
			cNewCod 	:= SA2->A2_COD
			cNewLoja	:= SA2->A2_LOJA
			cNewNome	:= SA2->A2_NOME
		Endif
	Endif
Endif
RestArea(aAreaAnt)
Return (_nOpca<>0)

