#INCLUDE "PROTHEUS.CH"
Static lFWCodFil := FindFunction("FWCodFil")
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ QUAA070W ³ Autor ³ WDO                   ³ Data ³ 01/12/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Baixa por compensacao de NCCs tabela especifica (ZC6)   	  ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³                  										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±                                     
±±³ Uso		 ³          												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QUAA070W(nRecZC6,nValx,nRegSE1)

Local lPanelFin 	:= If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Local nTotal		:= 0
Local nHdlPrv		:= 0
Local nValorComp	:= 0
Local nSeq			:= 0
Local nValBX		:= 0			// Valor da baixa na moeda 1
Local nValBX2		:= 0			// Valor da baixa na moeda do tit principal
Local nX
Local cAdiantamento
Local cDadosTitulo
Local cArquivo
Local cPadrao		:= "596"
Local lContabil		:= .F.
Local lPadrao
Local lDigita
Local dEmissao		:= SE1->E1_EMISSAO         
Local lMarcado		:= .F.
Local aBaixas		:= {}
Local nTotAbat		:= 0
Local nTotAbtIni	:= 0		//Abatimento do titulo de Partida
Local nTitIni		:= SE1->(Recno())
Local nDecs			:= 2
Local nSalTit		:= 0
Local nDecs1		:= MsDecimais(1)
Local oOk			:= LoadBitmap( GetResources(), "LBOK" )
Local oNo			:= LoadBitmap( GetResources(), "LBNO" )
Local cVarQ			:= "  "                                                                                  
Local oTitulox
Local oDlg
Local lFa330Cmp		:= .f. //ExistBlock( "FA330CMP" )
Local nSldReal		:= 0
Local oGet01
Local oGet02
Local oGet03

Local nLinha		:= 0
Local nTit			:= 0 
Local nA			:= 0
Local cKeyAbt		:= ""
Local nSe1Rec		:= 0
Local nAcresc		:= 0
Local nDecres		:= 0
Local nIndexAtu		:= SE1->(IndexOrd())
Local nVlrCompe // Criadaa para exibir o conteudo do Help correto quando o usuario
					 // pressionar F1 sobre o campo
Local aSize			:= {}
Local lDeleted		:= .F.
Local lfa330Bx		:= .F. //Existblock("FA330BX")
Local oPanel
Local aArea			:={}
Local lACAtivo		:= GetNewPar("MV_ACATIVO", .F.) //Verifica se o cliente utiliza o modulo Educacional
Local lVldDtFin		:= .T.
Local aDiario		:= {}

//Controla o Pis Cofins e Csll na baixa  (1-Retem PCC na Baixa ou 2-Retem PCC na Emissão(default) )
Local lPccBxCr		:= If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)
//Controla IRPJ na baixa
Local lIrPjBxCr		:= If (FindFunction("FIrPjBxCr"),FIrPjBxCr(),.F.) 
Local nPropIR		:= 1
Local nTotIrAbt		:=0   
Local nLoop			:= 0
LOCAL nSalvRec		:= SE1->(Recno())
Local lAplVlMin 	:= .T.
Local nVlMinImp 	:= GetNewPar("MV_VL10925",5000)
Local nTotCsAbt		:= 0	
Local nTotPisAbt	:= 0 
Local nTotCofAbt	:= 0
Local aImpPcc		:= {0,0,0}
Local nTotAdto		:= 0
Local lBaixaAbat	:= .F.
Local nVlrBaixa		:= 0
Local lBxCec		:= .F.
Local lBxLiq		:= .F.
Local nParciais		:= 0
Local nTamSeq		:= TamSX3("E5_SEQ")[1]
Local cSequencia	:= Replicate("0",nTamSeq)
Local nRecnoRA		:= 0
Local lF330BOTON 	:= .F. //ExistBlock("F330BOTON")

Local cTipoOr		:= SE1->E1_TIPO
Local lOkTitAb		:= .F.
Local lCompRa		:=	.F.
Local nPropPcc		:=	0   
Local nRegRa		:=	0

Local nPOs			:=  0
Local lPropRA 		:= SuperGetMv("MV_COMPCR",,.F.) //Verifica se vai proporcionalizar quando RA para NF.
Local nPisRaRet 	:= nCofRaRet := nCslRaRet := nBaseImp := nValImp := 0  
Local nSabTPis  	:=  nSabTCof :=  nSabTCsl := 0                         
Local lTipBxCP  	:= .F.                                                 
Local lSigaLoja 	:= .F.                                                 
//Local cFilComp		:=	xFilial("SE1")
Local nDesFin 		:= 0
//Controle de abatimento
Local lTitpaiSE1 	:= ( SE1->(FieldPos("E1_TITPAI")) > 0 )
Local nOrdTitPai	:=0
Local cTipo	 		:= ""
Local bWhile 		:= {|| !EOF() .And. E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA==xFilSE1+cKeyAbt} 
Local nRecOri		:= SE1->(Recno()) 
Local lNcc			:= SE1->E1_TIPO $ MV_CRNEG

//Impostos gerados pela rotina de Borderô de Recebimento de Imposto (FINA061).
Local	nPisFina061	:=	0
Local	nCofFina061	:=	0
Local	nCslFina061	:=	0
Local	nIrfFina061	:=	0  
Local nOrdSE5	:=	0
Local nRegSE5	:=	0

/* GESTAO - inicio */
Local oBtFilial	:= Nil
/* GESTAO - fim */

Local cOrigem 	:= ""              
Local aNumLay 	:= {}
PRIVATE lRet := .T.

PRIVATE nPosPis		:= 14		//Posicao Pis na Tela
PRIVATE nPosCof		:= 15		//Posicao Cofins na Tela
PRIVATE nPosCsl		:= 16		//Posicao Csll na Tela
PRIVATE nPosIrf		:= 17		//Posicao IRRF na Tela
PRIVATE nValx1		:= nValx
PRIVATE nRecSE1		:= nRegSE1
PRIVATE aTitulosx	:={}
PRIVATE aRecNo 		:= {}
PRIVATE aRegSE1 	:= {}
PRIVATE aBaixaSE5 	:= {}
PRIVATE	cPrefixo 	:= SE1->E1_PREFIXO
PRIVATE	cNum		:= SE1->E1_NUM
PRIVATE	cTipoTit 	:= SE1->E1_TIPO
PRIVATE	cCliente 	:= SE1->E1_CLIENTE
PRIVATE	cLoja 		:= SE1->E1_LOJA
PRIVATE	cSaldo		:= CriaVar("E1_SALDO")
PRIVATE	nValor		:= CriaVar("E1_SALDO")
PRIVATE	cParcela 	:= SE1->E1_PARCELA
PRIVATE	nMoeda		:= SE1->E1_MOEDA
PRIVATE	dBaixa		:= dDataBase
PRIVATE	nTxMoeda	:= SE1->E1_TXMOEDA
PRIVATE	nValTotx	:= 0
PRIVATE nFalta		:= 0
PRIVATE	nSeqBx 		:= 0
PRIVATE	nPosSaldo	:=0
PRIVATE	nPosValor	:=0
PRIVATE	cBanco		:= Criavar("E1_PORTADO")
Private lCredito 	:= .F.
Private nPosATit 	:= 0
Private aFlagCTB 	:= {}
Private lUsaFlag 	:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
Private aImpIR		:= {}     //array que armazena o IR na baixa
//PCC Baixa CR
PRIVATE nPis 		:= 0
PRIVATE nCofins   	:= 0
PRIVATE nCsll		:= 0
PRIVATE nIss		:= 0
PRIVATE nInss		:= 0
PRIVATE aDadosRef 	:=  {0,0,0,0,0,0,0} //Array(7)
PRIVATE aDadosRet 	:=  {0,0,0,0,0,0,0} //Array(7)
PRIVATE nVlRetPis	:= 0
PRIVATE nVlRetCof	:= 0
PRIVATE nVlRetCsl	:= 0
PRIVATE nDiferImp	:= 0
PRIVATE nValRec		:= 0
PRIVATE nOldValRec	:= 0
PRIVATE lRetParc  	:= .T.                                                                                  
PRIVATE nIrrf 	  	:= 0 
PRIVATE ntotIrbx  	:= 0 
PRIVATE nIndVld   	:= 0 
PRIVATE nRecVld   	:= 0
PRIVATE nValCorCM 	:= 0 
PRIVATE nTotImpbx  	:= 0 //Total de impostos calculados na baixa, quando posiciona !lCredito
Private aDadosRA1 	:= {{},{},{},{},{},{},{},{},{},{},{}}
Private lRaRtImp  	:= .F.//lFinImp .and. FRaRtImp()       //Define se ha retencao de impostos PCC/IRPJ no R.A 
Private nValAbat	:= 0
PRIVATE lF330SE5      := .F.
PRIVATE aRecSe5     := {}
private cCadastro := "Nscc de contratos a compensar" 
	
	aSize := MsAdvSize(,.F.,400)
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	oDLg:lMaximized := .T.
	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_TOP
	
	@003,005 Say "Selecionar Nccs a Baixar"   PIXEL Of oPanel  // "Compensaçäo de Titulos - Valores expressos em "

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montando cabecalho do list box³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 1.0,1.0 LISTBOX oTitulox VAR cVarQ Fields HEADER; 
"",; //1
"Prefixo",;//2
"Numero",;//3
"Parcela",;//4
"Tipo",;//5
"Loja",;//6
"Saldo do t¡tulo",; //7
"Valor compensado",;//8
"Limite de compensacao",;//9 
"Acrescimos",;//10
"Decrescimos",;//11
"Cliente/Loja",;//12
"Nome do Cliente",;//13
Rtrim(RetTitle("A1_CGC")),; //"CGC do Cliente" 14
Rtrim(RetTitle("E1_HIST")),; //Historico 15
RetTitle("E1_FILIAL"),; //FILIAL 16
RetTitle("E1_PIS"),; //17
RetTitle("E1_COFINS"),; //18
RetTitle("E1_CSLL"),; //19
RetTitle("E1_IRRF"); ///20
COLSIZES 12,GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBBBBBB"),; //21
GetTextWidth(0,"BBBB"),GetTextWidth(0,"BBB"),GetTextWidth(0,"BBB"),; //22
GetTextWidth(0,"BBBBBBBBB"),GetTextWidth(0,"BBBBBBBBB"),; //23
GetTextWidth(0,"BBBBBBBBB"),GetTextWidth(0,"BBBBBBBBB"),; //24
GetTextWidth(0,"BBBBBBBBB"),GetTextWidth(0,"BBBBBBBBB"),; //25
GetTextWidth(0,"BBBBBBBBB"),GetTextWidth(0,"BBBBBBBBBBBBBBBBBBBB"),GetTextWidth(0,REPLICATE("B",IIf( lFWCodFil, FWGETTAMFILIAL, 2 ))),; //26
GetTextWidth(0,"BBBBBB"),GetTextWidth(0,"BBBBBB"),GetTextWidth(0,"BBBBBB");//27
SIZE 293,54.5 ON DBLCLICK (aTitulosx:=FA330Troca(oTitulox:nAt,aTitulosx,oGet01,,@oTitulox,oGet03),oTitulox:Refresh()) NOSCROLL
//(aTitulosx:=FA330Troca(oTitulox:nAt,aTitulosx,oGet01,,@oTitulox),oTitulox:Refresh()) NOSCROLL


dbSelectArea("ZC6")
dbSetOrder(3)

If dbSeek(cValToChar(nRecZC6))

	While !Eof() .AND. ZC6->ZC6_RECSE1 == nRecZC6
	
	 aAdd(aTitulosx,;
	 	{ZC6->ZC6_PREFIX,;		//01
		ZC6->ZC6_NUM,;						//02
		ZC6->ZC6_PARCEL,;					//03
		ZC6->ZC6_TIPO,;						//04
		ZC6->ZC6_LOJA,;						//05
		Transform(ZC6->ZC6_SALDO,"@E 9999,999,999.99"),; //06
		Transform(nValx1 ,"@E 9999,999,999.99"),;//07
		.F.,;										//08
		nValTotx,;										//09
		Transform(0,"@E 9999,999,999.99"),; //10
		Transform(0,"@E 9999,999,999.99"),; //11
		'VALOR DA COMPENSACAO DIFERE DAS NCCs GERADAS',;						//12 
		ZC6->ZC6_FILIAL,;						//13
		Transform(0,"@E 9999,999,999.99"),;//PCC Baixa CR - Pis 		//14	
		Transform(0,"@E 9999,999,999.99"),;//PCC Baixa CR - Cofins 	//15
		Transform(0,"@E 9999,999,999.99"),;//PCC Baixa CR - Csll		//16
		Transform(0,"@E 9999,999,999.99"),;//PCC Baixa CR - Irrf		//17	
		Transform(0,"@E 9999,999,999.99"),;								//18
		Transform(0,"@E 9999,999,999.99"),;								//19
		ZC6->(RecNo()),;				//20
		123333,;//21
		iif(nValx1<=ZC6->ZC6_SALDO,Transform(nValx1,"@E 9999,999,999.99"),Transform(ZC6->ZC6_SALDO,"@E 9999,999,999.99")),;//Limite de Compensacao  //22
		0,; //23
		0,;//24
		iif(nValx1<=ZC6->ZC6_SALDO,Transform(nValx1,"@E 9999,999,999.99"),Transform(ZC6->ZC6_SALDO,"@E 9999,999,999.99")),;//25
		0,;//26
		0,;//27
		})
	
	ZC6->( dbSkip() )
		
	End


End If
oTitulox:SetArray(aTitulosx)
oTitulox:bLine := { || {If(aTitulosx[oTitulox:nAt,8],oOk,oNo),;
	aTitulosx[oTitulox:nAt,1],;//Prefixo [01]
	aTitulosx[oTitulox:nAt,2],;//Numero [02]
	aTitulosx[oTitulox:nAt,3],;//Parcela [03]
	aTitulosx[oTitulox:nAt,4],;//Tipo [04]
	aTitulosx[oTitulox:nAt,5],;//Loja [05]
	aTitulosx[oTitulox:nAt,6],;//Saldo do Titulo [06]
	If(aTitulosx[oTitulox:nAt,8],aTitulosx[oTitulox:nAt,7],Transform(0,PesqPict("SE1","E1_SALDO"))),;//Saldo Compensar [07]
	aTitulosx[oTitulox:nAt,25],;//Limite de Compensacao [08]
	aTitulosx[oTitulox:nAt,13],;//Acréscimos [09]
	aTitulosx[oTitulox:nAt,14],;//Decréscimos [10]
	aTitulosx[oTitulox:nAt,10],;//CLiente+Loja [11]
	aTitulosx[oTitulox:nAt,11],;//Nome CLiente [12]
	aTitulosx[oTitulox:nAt,12],;//CGC [13]
	aTitulosx[oTitulox:nAt,15],;//Historico [14]
	aTitulosx[oTitulox:nAt,16],;//FIlial [15]
	aTitulosx[oTitulox:nAt,17],;//Pis [16]
	aTitulosx[oTitulox:nAt,18],;//Cofins [17]
	aTitulosx[oTitulox:nAt,19],;//Csll [18]
	aTitulosx[oTitulox:nAt,20]}}//Irrf [19]
                                          
	oTitulox:bHeaderClick := {|oObj,nCol| If( nCol==1, FA330Troca(oTitulox:nAt,@aTitulosx,oGet01,.T.,@oTitulox,oGet03),Nil), oTitulox:Refresh(),oGet01:Refresh()}   
	
	oTitulox:Align := CONTROL_ALIGN_ALLCLIENT

	@  4, 253-30 SAY "Total a Compenar" PIXEL OF oPanel SIZE 70,7
	@  4, 303-30 MSGET oGet02 VAR nValx1 PICTURE "@E 999,999,999.99" WHEN .F. PIXEL OF oPanel SIZE 70,7

	@  4, 353 SAY "Total Selecionado" PIXEL OF oPanel SIZE 70,7
	@  4, 403 MSGET oGet01 VAR nValTotx PICTURE "@E 999,999,999.99" WHEN .F. PIXEL OF oPanel SIZE 70,7
		
	@  4, 353+130 SAY "Saldo restante:" PIXEL OF oPanel SIZE 70,7
	@  4, 403+130 MSGET oGet03 VAR nFalta PICTURE "@E 999,999,999.99" WHEN .F. PIXEL OF oPanel SIZE 70,7
	   	
		oPanel2 := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,20,20,.T.,.T. )
		oPanel2:Align := CONTROL_ALIGN_BOTTOM   
	
		DEFINE SBUTTON FROM 4,325 TYPE 1 ACTION fValid(@nOpcA,oDlg,aTitulosx,@lRet) ENABLE OF oPanel2 PIXEL
   	    DEFINE SBUTTON FROM 4,360 TYPE 2 ACTION (lRet := .F.,nOpcA := 0,oDlg:End()) ENABLE OF oPanel2 PIXEL
		
		ACTIVATE MSDIALOG oDlg CENTERED //ON INIT (oTitulox:Refresh())    
	
	
Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa330Troca³ Autor ³ Marcos Patricio		³ Data ³ 19/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Troca o flag para marcado ou nao,aceitando valor.		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa330Troca												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA330Troca(nIt,aArrayx,oGet,lTodos,oTitulox,oGet1)

Local oDlg
Local nOpca    := 0
Local nX       := 0
Local nAcresc  := 0
Local nY	   := 0
Local xy       := 0
Local nVezes   := 1
Local nOldIt   := nIt
//Controla IRPJ na baixa
Local lIrPjBxCr:= FIrPjBxCr()
Local lPccBxCr	:= FPccBxCr()
Local nPosIr	:=0
Local cLimite  := ''
Local nValOld  :=0
Local nPos 	   := 0
LOCAL nTotAbat := 0
Local aAreaSE1 := SE1->(GetArea())
Local nItemRA	:= 0
Local nItemOu	:= 0
Local lNcc		:= SE1->E1_TIPO $ MV_CRNEG
Local nVlMinImp := GetNewPar("MV_VL10925",5000)
Local nAltVal	:= 0
Local lBq10925	:= SuperGetMV("MV_BQ10925",,"2") == "1"
Local nVTit		:= 0
Local aArrAux		:= {}
Local nVlAbt		:= 0
Local lMSal		:= .F.
Local cOldVl		:= 0
Local nVlrSldPcc	:= 0
DEFAULT lTodos := .F.

//If dDataBase >= dLastPcc
//	nVlMinImp	:= 0
//EndIf

If MV_PAR02 == 2
	nPos := 25
Else
	nPos := 22
Endif
If cPaisLoc == "BRA"
	cValorx  :=Fa330VTix(aTitulosx[nIt,6 ])
	cSaldo  := Fa330VTix(aTitulosx[nIt,nPos ])//Limite de Compensação
	cSalTit := Fa330VTix(aTitulosx[nIt,6 ])
	cLimite := Fa330VTix(aTitulosx[nIt,nPos]) //Limite de Compensação
	nVezes  := If(lTodos,Len(aArrayx),1)
	If mv_par02 == 1
		nAcresc := Fa330VTix(aTitulosx[nIt,10])
	Else
		nAcresc := Fa330VTix(aTitulosx[nIt,13])
	Endif
	If (lPccBxCr .or.lIRPJBxCr) .And. lRaRtImp
		cValorx  := Fa330VTix(aTitulosx[nIt,22])
	EndIf
Else
	cValorx  := Fa330VTix(aTitulosx[nIt,6 ])
	If mv_par02 == 1
		cSaldo  := Fa330VTix(aTitulosx[nIt,14])
	Else
		cSaldo  := Fa330VTix(aTitulosx[nIt,17])
	EndIf
	cSalTit := Fa330VTix(aTitulosx[nIt,6 ])
	nVezes  := If(lTodos,Len(aArrayx),1)
Endif
xValTot := nValTotx
nValTotx := 0
nVlComp := 0

For xy := 1 to Len(aTitulosx)
	If aTitulosx[xy,8] .And. xy <> nIt
		nVlComp += Fa330VTix(aTitulosx[xy,7])
	EndIf
Next

cSaldo := Iif(cSaldo > nSaldo - nVlComp,nSaldo - nVlComp,cSaldo)
nValOld	:= cSaldo
For nY := 1 to nVezes

	If nVezes > 1
		nIt := nY
		cValorx  := Fa330VTix(aTitulosx[nIt,6])
		cSaldo  := Fa330VTix(aTitulosx[nIt, If( cPaisLoc == "BRA", nPos, 14 ) ])
		cLimite := Fa330VTix(aTitulosx[nIt,nPos])
		
		If (lPccBxCr .or.lIRPJBxCr) .And. lRaRtImp
			cValorx  := Fa330VTix(aTitulosx[nIt,22])
		EndIf
	Endif

	aArrayx[nIt,8] := !aArrayx[nIt,8]

	If (lPccBxCr .or. lIRPJBxCr) .And. lRaRtImp .AND. !lNcc
  		aDadosRA1[9][nIt] := !aDadosRA1[9][nIt]
 	Endif


	If aArrayx[nIt,8]

		If FA330Lock(aArrayx[nIt,1]+aArrayx[nIt,2]+aArrayx[nIt,3]+aArrayx[nIt,4],,,aArrayx[nIt,Iif(MV_PAR02== 2, 16,13)])

			If !lTodos
				If cPaisLoc == "BRA"
					If aArrayx[nIt,4] $ MV_CRNEG .and. (mv_par08 == 1 .OR. lRaRtImp)
						F330VALNCC(@aArrayx,nIt, cValorx < cLimite, .T.)
						cSaldo  := nSaldo - nVlComp
					Endif
					If cSaldo >= aArrayx[nIt,(nPos-1)]
						cLimite := Fa330VTix(aArrayx[nIt,nPos]) //Limite de Compensação
						cValorx	:= Fa330VTix(aArrayx[nIt,nPos]) //Limite de Compensação
					Else
						If !lNcc .or. (lNCC .and. cValorx > cSaldo)
							cLimite := cSaldo
							cValorx	:= cSaldo
						Endif
					Endif
					If cLimite < cValorx
						cValorx	:= cLimite
					EndIf
					
					If lPccBxCr .And. !lRartimp .And. SE1->E1_TIPO $ MVRECANT
						aArrAux 	:= aClone(aArrayx)
						nVlAbt 	:= SomaAbat(aArrayx[nIt][1],aArrayx[nIt][2],aArrayx[nIt][3],"R",,,SE1->E1_CLIENTE,,aArrayx[nIt][13])
						nVlrSldPcc  := DesTrans( aArrAux[nIt][nPos] ) 
						F330CalcPCC(nIt,aArrAux,@nVlrSldPcc,cValorx < cLimite)
						If lBq10925 //Pcc Bruto 
							If ( cValorx + ( DesTrans(aArrAux[nIt][nPosPis]) + DesTrans(aArrAux[nIt][nPosCof]) + DesTrans(aArrAux[nIt][nPosCsl]) ) ) > Val(Replace(Replace(aArrAux[nIt][6],".", "" ), ",", ".")) //Verifica se é maior que Saldo do titulo							
								cValorx     := ( nVlrSldPcc - ( DesTrans(aArrAux[nIt][nPosPis]) + DesTrans(aArrAux[nIt][nPosCof]) + DesTrans(aArrAux[nIt][nPosCsl]) ) )
								lMSal      := .T.
								nVlrSldPcc := DesTrans( aArrayx[nIt][nPos] )
							EndIf  
						Else //Pcc Liquido
							If cValorx > ( nVlrSldPcc - ( DesTrans(aArrAux[nIt][nPosPis]) + DesTrans(aArrAux[nIt][nPosCof]) + DesTrans(aArrAux[nIt][nPosCsl]) ) )
								cValorx     := ( nVlrSldPcc - ( DesTrans(aArrAux[nIt][nPosPis]) + DesTrans(aArrAux[nIt][nPosCof]) + DesTrans(aArrAux[nIt][nPosCsl]) ) )
								lMSal      := .T.
								nVlrSldPcc := DesTrans( aArrayx[nIt][nPos] )
							EndIf
						EndIf
						If lIrPjBxCr 
					   		nIrrf := FCaIrBxCR(nVlrSldPcc,,(SE1->E1_VALOR <> SE1->E1_SALDO .And. lRaRtImp ) )
					   		aArrayx[nIt,nPosIrf] := Transf(nIrrf,PesqPict("SE1","E1_IRRF"))  
					   		aTitulosx[nIt,nPosIrf]:= Transf(nIrrf,PesqPict("SE1","E1_IRRF")) 
							cValorx := cValorx - Val(StrTran(Replace(aArrayx[nIt][nPosIrf],".",""),",","."))
							aArrayx[nIt,nPosBIRF] := Transform(nVlrSldPcc,"@E 99,999,999.99")
							
						EndIf
						
					EndIf
				Endif

				DEFINE MSDIALOG oDlg FROM  80,100 TO 180,400 TITLE OemToAnsi("Nccs Contratos") PIXEL Style DS_MODALFRAME //"Compensa‡„o CR"
				
				cValorx := Fa330VTix(aTitulosx[nIt,nPos])
				cValorx -= xValTot
				cSaldo := nValx1-xValTot
				xLimite := Fa330VTix(aTitulosx[nIt,nPos])
				
				@ -3, 2 TO 22, 128 OF oDlg	PIXEL
				@ 7, 68 MSGET cValorx Picture "@E 9999,999,999.99" VALID cValorx <= cSaldo  .And. cValorx > 0 .And. ;
				                                                        cValorx >= nAcresc .and. cValorx <= xLimite  ;
				                                                        SIZE 54, 10 OF oDlg PIXEL hasbutton
				@ 8, 9 SAY "Valor a compensar"  SIZE 54, 7 OF oDlg PIXEL  //"Valor a compensar"

				If aArrayx[nIt,4] $ MV_CRNEG .Or. lNcc    

					@ 21, 2 SAY "Ao selecionar esse titulo os impostos calculados na baixa serão desconsiderados"  SIZE 120, 60 OF oDlg PIXEL //"Ao selecionar esse titulo os impostos calculados na baixa serão desconsiderados"

				Endif

				DEFINE SBUTTON FROM 37, 71 TYPE 1 ENABLE ACTION (nOpca:=1,If((cValorx <= cSaldo  .AND. cValorx > 0 .AND. cValorx >= nAcresc .AND. If(cPaisLoc== "BRA", cValorx<=cLimite, cValorx <= cSalTit)),oDLg:End(),nOpca:=0)) OF oDlg
				DEFINE SBUTTON FROM 37, 99 TYPE 2 ENABLE ACTION oDlg:End() OF oDlg

				ACTIVATE MSDIALOG oDlg
			Else
				nOpca := 1
			Endif
			If lMSal
				cOldVl := cValorx
				cValorx := nVlrSldPcc
			Endif
			If 	nOpca == 0
				aArrayx[nIt,8] := .F.
				If lRaRtImp .And. !lNcc
					aDadosRA1[9][nIt] := .F.
				EndIf
				If aArrayx[nIt,4] $ MV_CRNEG .and. (mv_par08 == 1 .OR. lRaRtImp) .And. !Empty( cLimite )
					F330VALNCC(@aArrayx,nIt, cValorx < cLimite, .F.)
					cSaldo  := nSaldo - nVlComp
					cLimite := Fa330VTix(aTitulosx[nIt,nPos]) //Limite de Compensação
				EndIf
			Endif
			IF	nOpca == 1
				nFalta := nValx1-xValTot
				If lCredito .And. SE1->E1_TIPO == MV_CRNEG
					dbSelectArea("SE1")
					If MV_PAR02 == 2
						dbGoTo(aArrayx[nIt,23])
					Else
				   		dbGoTo(aArrayx[nIt,20])
				    Endif
					nValAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,,SE1->E1_CLIENTE,,SE1->E1_FILIAL)
					RestArea(aAreaSE1)
				EndIf
			
				//Pcc Baixa CR
				//Caso a compensacao tenha partido de um Adiantamento
				If lCredito .And. (SE1->E1_TIPO <> MV_CRNEG) .And. !lRaRtImp .And. cPaisLoc == "BRA"
					dbSelectArea("SE1")
					If MV_PAR02 == 2
						dbGoTo(aArrayx[nIt,23])
					Else
				   		dbGoTo(aArrayx[nIt,20])
				    Endif
					If mv_par08 == 1 .OR. lRaRtImp
						nTotAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,,SE1->E1_CLIENTE,,SE1->E1_FILIAL)
						nValAbat	:= nTotAbat
					Else
						nTotAbat := 0
					Endif
					
					If lRartimp .And. (!(cValorx+nPis+nCofins+nCsll == SE1->E1_SALDO))
						F330CalcPCC(nIt,aArrayx,@cValorx+If(cValorx==cSalTit,nTotAbat,0),cValorx < cLimite)
					EndIf
					nOldValRec	:= nValOld
					If cValorx > cLimite
						cValorx := cLimite
					EndIf
					If dDatabase <= dLastPcc
						If !lRaRtImp .and. mv_par08 == 1 .and. lPccBxCr .and. SE1->E1_TIPO <> MVRECANT .and. nPis+nCofins+nCsll+nIrrf > 0 .AND. aDadosret[1] < nVlMinImp .and. aDadosRet[1]+nValRec > nVlMinImp
		  					nProp	:= (aDadosret[1]+ nValRec) / nSaldo
							nPis	:= SE1->E1_PIS * nProp
							nCofins := SE1->E1_COFINS * nProp
							nCsll	:= SE1->E1_CSLL * nProp
						EndIf
					EndIf
				EndIf
				If cPaisLoc == "BRA"
					aArrayx[nIt,9] := Iif(lMSal .And. cValorx > cOldVl,cOldVl,cValorx)
					
					If lIrPjBxCr .and. lCredito .and.  (SE1->E1_TIPO <> MV_CRNEG) 
							If MV_PAR02 == 2
								nIrrf := Val(StrTran(Replace(aArrayx[nIt][nPosIrf],".",""),",","."))//FCaIrBxCR(aArrayx[nIt,9],aArrayx[nIt,23])
								If (nPosIr := aScan(aImpIR,{|x| x[2] == aArrayx[nIt,23]})) == 0
									aAdd(aImpIR,{nIrrf,aArrayx[nIt,23]})
									nPosIr := Len( aImpIR )								
								Else
									aImpIR[nPosIr][1] := nIrrf
								EndIf
							Else
								nIrrf := Val(StrTran(Replace(aArrayx[nIt][nPosIrf],".",""),",","."))//FCaIrBxCR(aArrayx[nIt,9],aArrayx[nIt,20])
								If (nPosIr := aScan(aImpIR,{|x| x[2] == aArrayx[nIt,20]})) == 0
									aAdd(aImpIR,{nIrrf,aArrayx[nIt,20]})
									nPosIr := Len( aImpIR )
								Else
									aImpIR[nPosIr][1] := nIrrf
								EndIf
							EndIf
							
					EndIf

					If (lPccBxCr .or.lIRPJBxCr) .And. lRaRtImp .and. !lNcc
						dbSelectArea("SE1")
						If MV_PAR02 == 2
							dbGoTo(aArrayx[nIt,23])
						Else
				   			dbGoTo(aArrayx[nIt,20])
				    	Endif
						If lCredito
							nItemOU := aScan(aDadosRA1[2],{|x| x==SE1->(Recno())})
						Else
							nItemRA := aScan(aDadosRA1[1],{|x| x==SE1->(Recno())})
						EndIf
				        If !(aArrayx[nIt,4] $ MV_CRNEG)
							If F330RaRtIm(@aDadosRA1,cValorx,nItemRA,nItemOu, cValorx < cLimite )
								If lCredito
									nAltVal	:= cValorx
									If nAltVal+nPis+nCofins+nCsll == SE1->E1_SALDO 
										nAltVal	:= nAltVal+nPis+nCofins+nCsll
									ElseIf nAltVal+aDadosRA1[3][nItemOU]+aDadosRA1[4][nItemOU]+aDadosRA1[5][nItemOU] == SE1->E1_SALDO
										nAltVal	:= nAltVal+aDadosRA1[3][nItemOU]+aDadosRA1[4][nItemOU]+aDadosRA1[5][nItemOU]
									EndIf
									If dDataBase >= dLastPcc .AND. !lRaRtImp
										If cValorx <> cLimite 
											aPcc	:= newMinPcc(dbaixa,nAltVal,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE+SE1->E1_LOJA)
											nPis	:= 	aPcc[2]
											nCofins	:=	aPcc[3]
											nCsll	:=  aPcc[4]
											nPisCalc	:= nPis
											nPisBaseC	:= nAltVal	
											nPisBaseR 	:= nAltVal
											nCofCalc	:= nCofins	
											nCofBaseC	:= nAltVal
											nCofBaseR 	:= nAltVal
											nCslCalc	:= nCsll	
											nCslBaseC	:= nAltVal
											nCslBaseR 	:= nAltVal
											
											If lIrPjBxCr .And. cPaisLoc == "BRA"
												nIrrf	:= nIrrf * (nAltVal / SE1->E1_BASEIRF)
											EndIf
										EndIf
										aArrayx[nIt,nPosPis]		:= aDadosRA1[3][nItemOu]	:= nPis
										aArrayx[nIt,nPosCof]		:= aDadosRA1[4][nItemOu]	:= nCofins
										aArrayx[nIt,nPosCsl] 	:= aDadosRA1[5][nItemOu]	:= nCsll
									Else
										aArrayx[nIt,nPosPis]:=Transf(aDadosRA1[3][nItemOu],PesqPict("SE1","E1_PIS"))
										aArrayx[nIt,nPosCof]:=Transf(aDadosRA1[4][nItemOu],PesqPict("SE1","E1_COFINS"))
										aArrayx[nIt,nPosCsl]:=Transf(aDadosRA1[5][nItemOu],PesqPict("SE1","E1_CSLL"))
									EndIf
									aArrayx[nIt,nPosIrf]:=Transf(aDadosRA1[6][nItemOu],PesqPict("SE1","E1_IRRF"))
									If dDataBase < dLastPcc
									If cValorx < cLimite
										cValorx := cValorx - (aDadosRA1[3][nItemOu]+aDadosRA1[4][nItemOu]+aDadosRA1[5][nItemOu]+aDadosRA1[6][nItemOu];
															+aDadosRA1[10][nItemOu]+aDadosRA1[11][nItemOu])
										EndIf
									Else
										If cValorx < cLimite
											cValorx := cValorx - (nPis+nCofins+nCsll)
											If lIrPjBxCr
												cValorx	:= cValorx - nIrrf
											EndIf
										EndIf
									EndIf
								Else
									nAltVal	:= cValorx
									If nAltVal+nPis+nCofins+nCsll == SE1->E1_SALDO 
										nAltVal	:= nAltVal+nPis+nCofins+nCsll
									ElseIf nAltVal+aDadosRA1[3][nItemRA]+aDadosRA1[4][nItemRA]+aDadosRA1[5][nItemRA] == SE1->E1_SALDO
										nAltVal	:= nAltVal+aDadosRA1[3][nItemRA]+aDadosRA1[4][nItemRA]+aDadosRA1[5][nItemRA]
									EndIf
									If dDataBase >= dLastPcc .AND. !lRaRtImp
										If cValorx <> cLimite 
											aPcc	:= newMinPcc(dbaixa,nAltVal,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE+SE1->E1_LOJA)
											nPis	:= 	aPcc[2]
											nCofins	:=	aPcc[3]
											nCsll	:=  aPcc[4]
											nPisCalc	:= nPis
											nPisBaseC	:= nAltVal
											nPisBaseR 	:= nAltVal
											nCofCalc	:= nCofins	
											nCofBaseC	:= nAltVal
											nCofBaseR 	:= nAltVal
											nCslCalc	:= nCsll	
											nCslBaseC	:= nAltVal
											nCslBaseR 	:= nAltVal
											
											If lIrPjBxCr .And. cPaisLoc == "BRA"
												nIrrf	:= nIrrf * (nAltVal / SE1->E1_BASEIRF)
											EndIf
										EndIf
										aArrayx[nIt,nPosPis]		:= aDadosRA1[3][nItemRA]	:= nPis
										aArrayx[nIt,nPosCof]		:= aDadosRA1[4][nItemRA]	:= nCofins
										aArrayx[nIt,nPosCsl] 	:= aDadosRA1[5][nItemRA]	:= nCsll
								Else
									aArrayx[nIt,nPosPis]:=Transf(aDadosRA1[3][nItemRA],PesqPict("SE1","E1_PIS"))
									aArrayx[nIt,nPosCof]:=Transf(aDadosRA1[4][nItemRA],PesqPict("SE1","E1_COFINS"))
									aArrayx[nIt,nPosCsl]:=Transf(aDadosRA1[5][nItemRA],PesqPict("SE1","E1_CSLL"))
								EndIf
									aArrayx[nIt,nPosIrf]:=Transf(aDadosRA1[6][nItemRA],PesqPict("SE1","E1_IRRF"))
									If dDataBase < dLastPcc
										If cValorx < cLimite
									   		cValorx := cValorx - (aDadosRA1[3][nItemRA]+aDadosRA1[4][nItemRA]+aDadosRA1[5][nItemRA]+aDadosRA1[6][nItemRA];
																+aDadosRA1[10][nItemRA]+aDadosRA1[11][nItemRA])
										Endif
									Else
										If cValorx < cLimite
											cValorx := cValorx - (nPis+nCofins+nCsll)
											If lIrPjBxCr
												cValorx	:= cValorx - nIrrf
											EndIf
										EndIf
									EndIf
								EndIf
								aArrayx[nIt,9] := cValorx
							EndIf
						Endif
					EndIf
				EndIf
				
				If lPccBxCr .And. !lRaRtImp //.and. (cValorx <> cSaldo .or. nValrec <> cLimite)
					nTotAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,,SE1->E1_CLIENTE,,SE1->E1_FILIAL)
					If ((cValorx <= cLimite .and. SE1->E1_SALDO - nPis -nCofins - nCsll - nTotAbat <> cValorx) .Or.;
								(SE1->(E1_PIS+E1_CSLL+E1_COFINS) > 0 .And. (nPis+nCofins+nCsll) == 0 .And. cValorx <= cLimite .And. mv_par08 == 1))//essa cond ocorre quando os tít são marca indiv, removido a seleç e depois selec todos.
						For nX:=1 to Len(aArrayx) // verifica todos os títulos ja marcados
							If	aArrayx[nX,8] 
								nVTit += Fa330VTix(aArrayx[nX,7])
							Endif
						Next
						If lMSal
							cValorx	:= cOldVl
						EndIf
						If nVtit + cValorx == SE1->E1_VALOR - SE1->E1_PIS - SE1->E1_COFINS - SE1->E1_CSLL - nTotAbat
							nAltVal := SE1->E1_SALDO - nVtit // se os titulos ja marcados + o titulo do momento for igual o liquido, deve calcular pelo restante do saldo.
						Else
							nAltVal := Iif(MV_PAR08==1, (cValorx + Iif(lIrPjBxCr, SE1->E1_IRRF, 0) + If(lTodos, 0, SE1->(E1_PIS+SE1->E1_COFINS+SE1->E1_CSLL)) + nTotAbat), cValorx)
						EndIf
						
						If (aArrayx[nIt,4] $ MV_CRNEG .and.  SE1->E1_SALDO - nTotAbat == cValorx) .or. (lNCC .and.  SE1->E1_SALDO - nValAbat == cValorx ) 
							//baixa total
							nAltVal := SE1->E1_SALDO
						EndIf	
						
						If dDataBase >= dLastPcc
							aPcc	:= newMinPcc(dBaixa,nAltVal,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE+SE1->E1_LOJA)
							nPis	:= 	aPcc[2]
							nCofins	:=	aPcc[3]
							nCsll	:=  aPcc[4]
														
							nPisCalc	:= nPis
							nPisBaseC	:= nAltVal	
							nPisBaseR 	:= nAltVal
							nCofCalc	:= nCofins	
							nCofBaseC	:= nAltVal
							nCofBaseR 	:= nAltVal
							nCslCalc	:= nCsll	
							nCslBaseC	:= nAltVal
							nCslBaseR 	:= nAltVal
							
							If lIrPjBxCr .And. cPaisLoc == "BRA"
								nIrrf	:= nIrrf * (nAltVal / SE1->E1_BASEIRF)
							EndIf
						EndIf
						If !lBq10925
							cValorx := cValorx - nPis - nCofins - nCsll - Iif (lIrPjBxCr,nIrrf,0)
						EndIf
					
						aArrayx[nIt,nPosPis]	:= Transf(nPis,PesqPict("SE1","E1_PIS"))
						aArrayx[nIt,nPosCof]	:= Transf(nCofins,PesqPict("SE1","E1_COFINS"))
						aArrayx[nIt,nPosCsl]	:= Transf(nCsll,PesqPict("SE1","E1_CSLL"))					
					EndIf
				EndIf
				
				If lTodos .And. lPccBxCr .And. !lRaRtImp .And. mv_par08 == 1
					aArrayx[nIt,7]		:=Transf((cValorx-nPis-nCofins-nCsll),PesqPict("SE1","E1_SALDO"))
					//Vld para ñ gerar mov.diferentes
					cValorx := If(lBq10925, Val(StrTran(aArrayx[nIt,7], ".", "")), cValorx) 
					aArrayx[nIt,9] := cValorx					 
				Else				
					aArrayx[nIt,7] := Transf(cValorx,PesqPict("SE1","E1_SALDO"))
				EndIf
				
				If  !lRaRtImp
					aArrayx[nIt,9]			:= cValorx
					aArrayx[nIt,nPosPis]	:= Transf(nPis,PesqPict("SE1","E1_PIS"))
					aArrayx[nIt,nPosCof]	:= Transf(nCofins,PesqPict("SE1","E1_COFINS"))
					aArrayx[nIt,nPosCsl]	:= Transf(nCsll,PesqPict("SE1","E1_CSLL"))
					aArrayx[nIt,nPosBPCC]	:= Transf(nAltVal,PesqPict("SE1","E1_CSLL"))
					aArrayx[nIt,nPosBPCR]	:= Transf(nAltVal,PesqPict("SE1","E1_CSLL"))
				Endif
				
				If cValorx <> nValRec // cValorx é uma variavel numerica
					nValRec	:= cValorx
				EndIf
			//cValorx -= nValTotx
			//cSaldo -= nValTotx
			Endif
	    Else
			aArrayx[nIt,8] := !aArrayx[nIt,8]
			If aArrayx[nIt,4] $ MV_CRNEG
				F330VALNCC(@aArrayx,nIt, cValorx < cLimite, .F.)
			Endif
		Endif
	Else
	nFalta := nValx1+nValTotx
		If  !aArrayx[nIt,8]
			aArrayx[nIt,7]:=Transf(0,PesqPict("SE1","E1_SALDO"))
			If cPaisLoc == "BRA"
				aArrayx[nIt,9] := 0
				If lCredito
					dbSelectArea("SE1")
					If MV_PAR02 == 2
						dbGoTo(aArrayx[nIt,23])
					Else
				   		dbGoTo(aArrayx[nIt,20])
				    Endif
					If mv_par08 == 1 .OR. lRaRtImp
						nTotAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,,SE1->E1_CLIENTE)
					Else
						nTotAbat := 0
					Endif

					F330CalcPCC(nIt,aArrayx,@cValorx+If(cValorx==cSalTit,nTotAbat,0),cValorx < cLimite)
				Endif
				If lIrPjBxCr .and. lCredito
					nIrrf:=FCaIrBxCR(aArrayx[nIt,9])
					If (nPosIr:=ascan(aImpIR,{|x| x[2]=SE1->(REcno())}))=0
						aAdd(aImpIR,{nIrrf,SE1->(Recno())})
						nPosIr := Len( aImpIR )
					else
						aImpIR[nPosIr][1]:= nIrrf
					EndIf
				EndIf
			Endif
		Endif

		FA330UnLock(aArrayx[nIt,1]+aArrayx[nIt,2]+aArrayx[nIt,3]+aArrayx[nIt,4],,aArrayx[nIt,Iif(MV_PAR02== 2, 16,13)])

	Endif
	
Next

For nX:=1 to Len(aArrayx)
	If	aArrayx[nX,8]
		nValTotx += Fa330VTix(aArrayx[nX,7])
	Endif
Next

nIt := nOldIt
nFalta := nValx1-nValTotx
If oGet != Nil
	oGet:Refresh()
	oGet1:Refresh()
Endif

//If ExistBlock("F330ATLIS")
//	ExecBlock("F330ATLIS",.F.,.F., {  , 2 , nValTotx, nValor } )
//EndIf  

RestArea(aAreaSE1)
Return aArrayx

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa330VTit ³ Autor ³ Mauricio Pequim Jr.   ³ Data ³ 22/09/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o saldo ou valor do titulo a ser compensado		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fina330													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa330VTix(aTitulo,cTipoTit,cValorx)
LOCAL nValor
cValorx := IIF (cValorx == NIL,aTitulo,cValorx)
If ValType(cValorx)=="N"
	nValor := cValorx
Else
	nValor := DesTrans(cValorx)
Endif
Return nValor




Static Function FA330Unlock(cChave,nRecno,cfilorig)
Local aArea
Local nPosRec

//If aRLocks == Nil
//	aRLocks:={}
//Endif
//If nRecno <> Nil
//	SE1->(MsGoto(nRecno))
//Else
//	aArea	:=	getArea()
//	SE1->(DbSetOrder(1))
//	SE1->(MsSeek(cfilorig+cChave))
//Endif

//**********************************************
// Retirado para permitir utilizacao de rotina *
// automatica dentro de transacao no banco     *
// **********************************************

//SE1->(MsUnlock())


//If (nPosRec:=Ascan(aRLocks,SE1->(REcno()))) > 0
//	Adel(aRlocks,nPosRec)
//	aSize(aRlocks,Len(aRlocks)-1)
//Endif

//If aArea <> Nil
//	RestArea(aArea)
//Endif

Return

//------------------------------------------------------------------------------------------------------------------------------------------------

Static Function FA330Lock(cChave,nRecno,lHelp,cfilOrig)
Local aArea
Local lRet	:=	.T.
DEFAULT lHelp	:=	.T.

//If aRLocks == Nil
//	aRLocks:={}
//Endif

//If nRecno <> Nil
//	SE1->(MsGoto(nRecno))
//Else
//	aArea	:=	SE1->(getArea())
//	SE1->(DbSetOrder(1))
//	SE1->(MsSeek(cfilorig+cChave))
//Endif

//**********************************************
// Retirado para permitir utilizacao de rotina *
// automatica dentro de transacao no banco     *
// **********************************************

//If  SE1->(RecLock("SE1",.F.))
//	AAdd(aRLocks, SE1->(Recno()))
//	lRet	:=	.T.
//ElseIf lHelp
//	MsgAlert("Negado")
//Endif
//If aArea <> Nil
//	RestArea(aArea)
//Endif

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA330   ºAutor  TOTVS		         º Data ³  07/23/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recompor Valor de compensação, nSaldo, limite de compensaçãoº±±
±±º          ³ quando marcado uma NCC para compensação                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA330                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F330VALNCC(aArrayx, nX, lAltValor, lSoma)

Local nProp:= 0
Local nLim := 0
Local nPos := 0
Local nImpBx := 0

DEFAULT nX 			:= 1
DEFAULT lAltValor 	:= .F.
DEFAULT aArrayx		:= {}
DEFAULT lSoma		:= .F.

If MV_PAR02 == 2
	nPos := 25
Else
	nPos := 22
Endif
If MV_PAR08 == 1
	nImpBx := nTotImpbx-nIss-nInss
Else
	nImpBx := nTotImpbx
Endif

If lAltValor
	nProp:=  aTitulosx[nX,9]/SE1->E1_VALOR
Else
    If aArrayx[nX,(nPos+1)]< SE1->E1_VALOR
		nProp:= aTitulosx[nX,(nPos+1)]/SE1->E1_VALOR
	Else
		nProp:=  1
	Endif
Endif
If lSoma
	nLim := Fa330VTix(aArrayx[nX,nPos])
	nSaldo+= nImpBx*nProp
	nLim += nImpBx *nProp
	If nLim <= aArrayx[nX,(nPos-1)]
		aArrayx[nX,nPos]:= Transf(nLim,PesqPict("SE1","E1_SALDO"))
	Endif

Else
	nLim := Fa330VTix(aArrayx[nX,nPos])
	nSaldo-= nImpBx *nProp
	nLim -= nImpBx *nProp
	If nLim <= aArrayx[nX,(nPos-1)]
		aArrayx[nX,nPos]:= Transf(nLim,PesqPict("SE1","E1_SALDO"))
	Endif
Endif
return

//--------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} fValid
Efetua Baixa
@param xParam Parameter Description
@return xRet Return Description
@author  - Wilson Davila
@since 21/02/2019
/*/
//--------------------------------------------------------------------------------------------------------------------------
Static Function fValid(nOpcA,oDlg,aTit,lRet)

If nFalta <> 0
	MsgAlert(OemToAnsi("Valor selecionado nao é igual ao da compensação,faça o ajuste!"))
	nOpcA := 0
	lRet := .F.
Else

	//BEGIN TRANSACTION
	aAreaZC6 := GetArea()
	
	dbSelectArea("ZC6")
	dbSetOrder(3)
	
	//Baixa Ncc arquivo Zc6	
	For i := 1 to Len(aTit)
		If aTit[i,8]
				ZC6->( dbGoto(aTit[i,20]) )
				If ZC6->( !Eof() )	
					If ZC6->(ZC6_SALDO) <> 0
						ZC6->( RecLock("ZC6",.F.) )
							ZC6->ZC6_SALDO 	-= Fa330VTix(aTit[i,07]) 
							ZC6->ZC6_BAIXA	:= DDATABASE
						ZC6->( MsUnlock() )
						
						AADD(aRegZC6,{ZC6->( Recno() ) } )
						
						aAreaZC8 := GetArea()
							
								RecLock("ZC8",.T.)
									ZC8->ZC8_FILIAL := ZC6->(ZC6_FILIAL)
									ZC8->ZC8_DATA	:= DDATABASE
									ZC8->ZC8_VALOR	:= Fa330VTix(aTit[i,07])
									ZC8->ZC8_RECZC6	:= ZC6->( Recno() )
								MsUnlock()
						RestArea(aAreaZC8)
					End If
				End If
		End If
	Next i
	
	//Baixa NF arquivo ZC6
	If dbSeek(cValToChar(nRecSE1))
		RecLock("ZC6",.F.)
			ZC6->ZC6_SALDO 	-= nValTotx
			ZC6->ZC6_BAIXA	:= DDATABASE
		MsUnlock()
	End If

	RestArea(aAreaZC6)
	//END TRANSACTION

	nOpcA := 1
	lRet := .T.
	oDlg:End()

End If

Return
