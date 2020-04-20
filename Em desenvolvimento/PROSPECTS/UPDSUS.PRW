#include "Protheus.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³UpdLEI01  ³ Autor ³Ricardo Berti          ³ Data ³ 20.11.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualizacao das tabelas COL_LEI - Pagto pela Qualidade     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Template COL_LEI                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function UpdSUS() //Para maiores detalhes sobre a utlizacao deste fonte,
					    // leia o boletim "Pagamento pela Qualidade"
					    
cArqEmp := "SigaMat.Emp"
__cInterNet := Nil

PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd 

Set Dele On

lHistorico 	:= MsgYesNo("Deseja efetuar a atualização do Dicionário? Esta rotina deve ser utilizada em modo exclusivo ! Faca um backup dos dicionários e da Base de Dados antes da atualização para eventuais falhas de atualização !", "Atenção")
lEmpenho	:= .F.
lAtuMnu		:= .F.

DEFINE WINDOW oMainWnd FROM 0,0 TO 01,30 TITLE "Atualização do Dicionário"

ACTIVATE WINDOW oMainWnd ;
	ON INIT If(lHistorico,(Processa({|lEnd| LEIProc(@lEnd)},"Processando","Aguarde , processando preparação dos arquivos",.F.) , Final("Atualização efetuada!")),oMainWnd:End())
	
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ LEIProc  ³ Autor ³Ricardo Berti          ³ Data ³ 16.11.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos arquivos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao COL_LEI                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function LEIProc(lEnd)
Local cTexto    := ''
Local cFile     :=""
Local cMask     := "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    := 0
Local nI        := 0
Local nX        :=0
Local aRecnoSM0 := {}     
Local lOpen     := .F. 

ProcRegua(1)
IncProc("Verificando integridade dos dicionários....")
If ( lOpen := MyOpenSm0Ex() )

	dbSelectArea("SM0")
	dbGotop()
	While !Eof() 
  		If Ascan(aRecnoSM0,{ |x| x[2] == M0_CODIGO}) == 0 //--So adiciona no aRecnoSM0 se a empresa for diferente
			Aadd(aRecnoSM0,{Recno(),M0_CODIGO})
		EndIf			
		dbSkip()
	EndDo	
		
	If lOpen
		For nI := 1 To Len(aRecnoSM0)
			SM0->(dbGoto(aRecnoSM0[nI,1]))
			RpcSetType(2) 
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
			nModulo := 2 // MODULO COMPRAS
			lMsFinalAuto := .F.
			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de arquivos (SX2) ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  			//ProcRegua(8)
			//IncProc("Analisando Dicionario de Arquivos...")
			//cTexto += LEIAtuSX2()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados (SX3) ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Dados...")
			cTexto += LEIAtuSX3()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os parametros.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//IncProc("Analisando Parametros...")
			//cTexto += LEIAtuSX6()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os gatilhos (SX7)           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//			IncProc("Analisando Gatilhos...")
//			LEIAtuSX7()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os indices (SIX) ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando arquivos de índices. "+"Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME) 
			//cTexto += LEIAtuSIX()

			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]")
				If Select(aArqUpd[nx])>0
					dbSelecTArea(aArqUpd[nx])
					dbCloseArea()
				EndIf
				X31UpdTable(aArqUpd[nx])
				If __GetX31Error()
					Alert(__GetX31Trace())
					Aviso("Atenção!","Ocorreu um erro desconhecido durante a atualização da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionário e da tabela.",{"Continuar"},2)
					cTexto += "Ocorreu um erro desconhecido durante a atualização da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
                Else
					IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]")
				EndIf
				
			Next nX		
		
//			U_AtuQuali() //Atualiza os novos campos criados

			RpcClearEnv()
			If !( lOpen := MyOpenSm0Ex() )
				Exit 
			EndIf 
		Next nI 
		   
		If lOpen
			
			cTexto := "Log da atualização "+CHR(13)+CHR(10)+cTexto
			__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
			DEFINE MSDIALOG oDlg TITLE "Atualização concluída." From 3,0 to 340,417 PIXEL
			@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
			oMemo:bRClicked := {||AllwaysTrue()}
			oMemo:oFont:=oFont
			DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
			DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
			ACTIVATE MSDIALOG oDlg CENTER
			
		EndIf 
		
	EndIf
		
EndIf 	

Return(.T.)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AtuQuali   ³ Autor ³Ricardo Berti         ³ Data ³16/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza tabela criada                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ UPDTMS48                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
/*
User Function AtuQuali()

Local cQuery    := ''
Local cAliasQry := GetNextAlias()
/*
If TCCanOpen(RetSQLName("SB1")) //Se nao existir a tabela nao processa a atualizacao
	cQuery := " SELECT B1_TRANSGE, SB1.R_E_C_N_O_ R_E_C_N_O_ "
	cQuery += "   FROM "
	cQuery += RetSQLName("SB1") + " SB1 "
	cQuery += "    WHERE B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery += "      AND B1_TRANSGE <> '2' AND SB1.D_E_L_E_T_ = ' ' "
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .T.)
	
	While (cAliasQry)->(!Eof())
		cQuery := " UPDATE " + RetSqlName("SB1") + " SET B1_TRANSGE = '1'"
		cQuery += "   WHERE B1_TRANSGE <> '2' AND R_E_C_N_O_  = '" + AllTrim(Str(R_E_C_N_O_)) + "' "
		TCSqlExec( cQuery ) 
		(cAliasQry)->(DbSkip())
	EndDo
	
	(cAliasQry)->(DbCloseArea())
	
Endif	

Return Nil
*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³LEIAtuSX3 ³ Autor ³Ricardo Berti          ³ Data ³ 16.11.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX3 - Campos        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao COL_LEI                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function LLEIA()
Local aSX3           := {}
Local aEstrut        := {}
Local i              := 0
Local j              := 0
Local lSX3	         := .F.
Local cTexto         := ''
Local cAlias         := ''
Local cReserv        := ''
Local cReservObrig   := ''
Local cUsado         := ''
Local cUsadoObrig    := ''
Local nI             := 0
Local cOrdem

aEstrut:= { "X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,"X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL","X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
	"X3_DESCRIC","X3_DESCSPA","X3_DESCENG","X3_PICTURE","X3_VALID"  ,"X3_USADO"  ,"X3_RELACAO","X3_F3"     ,"X3_NIVEL"  ,;
	"X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,"X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER",;
	"X3_CBOX"   ,"X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,"X3_GRPSXG" ,"X3_FOLDER", "X3_PYME"}

dbSelectArea("SX3")
SX3->(DbSetOrder(2))

//--Pesquisa um campo existente para gravar o Reserv e o Usado
	If SX3->(MsSeek("LBB_DESC")) //Este campo e obrigatorio e permite alterar
		For nI := 1 To SX3->(FCount())
			If "X3_RESERV" $ SX3->(FieldName(nI))
				cReservObrig := SX3->(FieldGet(FieldPos(FieldName(nI))))
			EndIf
			If "X3_USADO"  $ SX3->(FieldName(nI))
				cUsadoObrig  := SX3->(FieldGet(FieldPos(FieldName(nI))))
			EndIf
		Next 							
	EndIf		
If SX3->(MsSeek("LBB_END")) //Este campo e somente visualizacao
	For nI := 1 To SX3->(FCount())
		If "X3_RESERV" $ SX3->(FieldName(nI))
			cReserv := SX3->(FieldGet(FieldPos(FieldName(nI))))
		EndIf
		If "X3_USADO"  $ SX3->(FieldName(nI))
			cUsado  := SX3->(FieldGet(FieldPos(FieldName(nI))))
		EndIf
	Next
EndIf

//Criacao de novos campos em uma tabela nova, nao precisa verificar ordem

		// Tabela LJY - Criterios de Valoriz. da Qualidade

		Aadd(aSX3,{"LJY",;				//Arquivo
			"01",;						//Ordem
			"LJY_FILIAL",;				//Campo
			"C",;					   //Tipo
			2,;						   //Tamanho
			0,;							//Decimal
			"Filial",;			    	//Titulo
			"Sucursal",;			   //Titulo SPA
			"Branch",;			       //Titulo ENG
			"Filial do Sistema",;		//Descricao
			"Sucursal",;				//Descricao SPA
			"Branch of the system.",;	//Descricao ENG
			"@!",;					   //Picture
			"",;							//VALID
			"",;							//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;							//NIVEL
			"",;							//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"N",;							//BROWSE
			"",;							//VISUAL
			"",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;							//CBOX
			"",;							//CBOX SPA
			"",;							//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME
			
		Aadd(aSX3,{"LJY",;			//Arquivo
			"02",;						//Ordem
			"LJY_VINIC",;				//Campo
			"N",;						   //Tipo
			12,;						   //Tamanho
			2,;							//Decimal
			"De          ",;		      //Titulo
			"De          ",;		      //Titulo SPA
			"From        ",;		      //Titulo ENG
			"Valor inicial da faixa",; 		//Descricao
			"Valor de rango inicial",;		//Descricao SPA
			"Initial range value",;		    //Descricao ENG
			"@E 99,999.99",;			   //Picture
			"",;		//VALID
			cUsado,;						//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"A",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJY",;			//Arquivo
			"03",;						//Ordem
			"LJY_VFINAL",;				//Campo
			"N",;						   //Tipo
			12,;						   //Tamanho
			2,;							//Decimal
			"Ate         ",;		      //Titulo
			"A           ",;		      //Titulo SPA
			"To          ",;		      //Titulo ENG
			"Valor final da faixa",; 		//Descricao
			"Valor de rango final",;		//Descricao SPA
			"Final range value",;		    //Descricao ENG
			"@E 99,999.99",;			   //Picture
			"",;		//VALID
			cUsado,;						//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"A",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJY",;			//Arquivo
			"04",;						//Ordem
			"LJY_VRESUL",;				//Campo
			"N",;						   //Tipo
			8,;						   //Tamanho
			4,;							//Decimal
			"R$+/Litro",;		      //Titulo
			"Valor+/Litro",;		      //Titulo SPA
			"Value+/Liter",;		      //Titulo ENG
			"Vlr.acresc/desc.por litro",; 		//Descricao
			"Valor incr/desc.por litro",;		//Descricao SPA
			"Value incr/disc.per liter",;		    //Descricao ENG
			"@E 99.9999",;			   //Picture
			"",;		//VALID
			cUsado,;						//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"A",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJY",;			//Arquivo
			"05",;						//Ordem
			"LJY_CODQUA",;				//Campo
			"C",;						   //Tipo
			8,;						   //Tamanho
			0,;							//Decimal
			"Cod.Tabela",;		      //Titulo
			"Codigo Tabla",;		      //Titulo SPA
			"Table code",;		      //Titulo ENG
			"Cod.da Tabela da Qualid.",; 		//Descricao
			"Cod.de Tabla de Calidad ",;		//Descricao SPA
			"Quality table code",;		 	   //Descricao ENG
			"@!",;	   			  		   //Picture
			"U_VldCodQua()",;	 			//VALID
			cUsadoObrig,;					//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;							//NIVEL
			cReservObrig,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"A",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJY",;			//Arquivo
			"06",;						//Ordem
			"LJY_DESQUA",;				//Campo
			"C",;						   //Tipo
			40,;						   //Tamanho
			0,;							//Decimal
			"Descricao",;		      //Titulo
			"Descripcion",;		      //Titulo SPA
			"Description",;		      //Titulo ENG
			"Descricao da Tabela",; 		//Descricao
			"Descripcion de Tabla",;		//Descricao SPA
			"Description of table",;		    //Descricao ENG
			"@!",;						   //Picture
			"",;		//VALID
			cUsado,;						//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"N",;							//BROWSE
			"A",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJY",;			//Arquivo
			"07",;						//Ordem
			"LJY_TIPOL",;				//Campo
			"C",;						   //Tipo
			2,;						   //Tamanho
			0,;							//Decimal
			"Leite Tipo",;		      //Titulo
			"Leche Tipo",;		      //Titulo SPA
			"Milk type",;		      //Titulo ENG
			"Tipo do leite",; 		//Descricao
			"Tipo de leche",;		//Descricao SPA
			"Milk type",;		    //Descricao ENG
			"@!",;			  		 //Picture
			"Pertence('B ,C ')",;	//VALID   *
			cUsadoObrig,;					//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;							//NIVEL
			cReservObrig,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"A",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJY",;			//Arquivo
			"08",;						//Ordem
			"LJY_DTATU",;				//Campo
			"D",;						   //Tipo
			8,;						   //Tamanho
			0,;							//Decimal
			"Ult.Atualiz.",;		      //Titulo
			"Ultima Act.",;		      //Titulo SPA
			"Last update",;		      //Titulo ENG
			"Data da Ultima atualizacao",; 		//Descricao
			"Fecha ult.actualizacion",;		//Descricao SPA
			"Date of last update",;		    //Descricao ENG
			"@D",;			   //Picture
			"",;		//VALID
			cUsado,;						//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"V",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJY",;			//Arquivo
			"09",;						//Ordem
			"LJY_ITEM",;				//Campo
			"N",;						   //Tipo
			3,;						   //Tamanho
			0,;							//Decimal
			"Item",;		      //Titulo
			"Item",;		      //Titulo SPA
			"Item",;		      //Titulo ENG
			"Item No.",; 			//Descricao
			"Item numero",;			//Descricao SPA
			"Item number",;		    //Descricao ENG
			"@Z 999",;						   //Picture
			"",;		//VALID
			cUsado,;						//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"N",;							//BROWSE
			"V",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		// Tabela LJZ - Historico Pagto.Qualidade
		
		Aadd(aSX3,{"LJZ",;				//Arquivo
			"01",;						//Ordem
			"LJZ_FILIAL",;				//Campo
			"C",;					   //Tipo
			2,;						   //Tamanho
			0,;							//Decimal
			"Filial",;			    	//Titulo
			"Sucursal",;			   //Titulo SPA
			"Branch",;			       //Titulo ENG
			"Filial do Sistema",;		//Descricao
			"Sucursal",;				//Descricao SPA
			"Branch of the system.",;	//Descricao ENG
			"@!",;					   //Picture
			"",;							//VALID
			"",;							//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;							//NIVEL
			"",;							//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"N",;							//BROWSE
			"",;							//VISUAL
			"",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;							//CBOX
			"",;							//CBOX SPA
			"",;							//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJZ",;				//Arquivo
			"02",;						//Ordem
			"LJZ_TIPOL",;				//Campo
			"C",;						   //Tipo
			2,;						   //Tamanho
			0,;							//Decimal
			"Leite Propr.",;		      //Titulo
			"Leche Tipo",;		      //Titulo SPA
			"Milk type",;		      //Titulo ENG
			"Tipo Leite da Propriedade",; 		//Descricao
			"Tipo de leche",;		//Descricao SPA
			"Milk type",;		    //Descricao ENG
			"@!",;			  		 //Picture
			"",;					//VALID
			cUsado,;					//USADO
			'POSICIONE("LBB",1,xFilial("LBB")+LJZ->LJZ_CODPRO,"LBB_TIPOL")',;	//RELACAO
			"",;							//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"V",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			'POSICIONE("LBB",1,XFILIAL("LBB")+LJZ->LJZ_CODPRO,"LBB_TIPOL")',;	//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJZ",;			//Arquivo
			"03",;						//Ordem
			"LJZ_CODROT",;				//Campo
			"C",;						   //Tipo
			6,;						   //Tamanho
			0,;							//Decimal
			"Codigo Rota",;		      //Titulo
			"Codigo Rota",;		      //Titulo SPA
			"Codigo Rota",;		      //Titulo ENG
			"Codigo da Rota",; 		//Descricao
			"Codigo da Rota",;		//Descricao SPA
			"Codigo da Rota",;		    //Descricao ENG
			"@!",;						   //Picture
			"",;		//VALID
			cUsado,;						//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"V",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJZ",;			//Arquivo
			"04",;						//Ordem
			"LJZ_DATCLQ",;				//Campo
			"D",;						   //Tipo
			8,;						   //Tamanho
			0,;							//Decimal
			"Dt Refer.",;		      //Titulo
			"Dt Refer.",;		      //Titulo SPA
			"Dt Refer.",;		      //Titulo ENG
			"Data Referencia Analise",; 		//Descricao
			"Dt Refer.",;		//Descricao SPA
			"Dt Refer.",;		    //Descricao ENG
			"@D",;						   //Picture
			"",;		//VALID
			cUsadoObrig,;					//USADO
			"DDATABASE-2",;				//RELACAO
			"",;						//F3
			1,;							//NIVEL
			cReservObrig,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"A",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJZ",;			//Arquivo
			"05",;						//Ordem
			"LJZ_DESC",;				//Campo
			"C",;						   //Tipo
			30,;						   //Tamanho
			0,;							//Decimal
			"Descr. Rota",;		      //Titulo
			"Descr. Rota",;		      //Titulo SPA
			"Descr. Rota",;		      //Titulo ENG
			"Descricao da Rota",; 		//Descricao
			"Descricao da Rota",;		//Descricao SPA
			"Descricao da Rota",;		    //Descricao ENG
			"@!",;						   //Picture
			"",;		//VALID
			cUsado,;						//USADO
			'If(!Inclui,Posicione("LBC",1,xFilial("LBC")+LJZ->LJZ_CODROT,"LBC_DESC"),"")',; //RELACAO
			"",;							//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"N",;							//BROWSE
			"V",;							//VISUAL
			"V",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			'Posicione("LBC",1,xFilial("LBC")+LJZ->LJZ_CODROT,"LBC_DESC")',;	//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJZ",;			//Arquivo
			"06",;						//Ordem
			"LJZ_CODPRO",;				//Campo
			"C",;						   //Tipo
			6,;						   //Tamanho
			0,;							//Decimal
			"Cod. Propr.",;		      //Titulo
			"Cod. Propr.",;		      //Titulo SPA
			"Cod. Propr.",;		      //Titulo ENG
			"Codigo da Propriedade",; 		//Descricao
			"Codigo da Propriedade",; 		//Descricao SPA
			"Codigo da Propriedade",; 		//Descricao ENG
			"@!",;						   //Picture
			'EXISTCPO("LBB",M->LJZ_CODPRO)',;		//VALID      *
			cUsadoObrig,;						//USADO
			"",; //RELACAO
			"LBB",;							//F3
			1,;							//NIVEL
			cReservObrig,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"V",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJZ",;			//Arquivo
			"07",;						//Ordem
			"LJZ_NOMFOR",;				//Campo
			"C",;						   //Tipo
			40,;						   //Tamanho
			0,;							//Decimal
			"Nome Fornec.",;		      //Titulo
			"Nomb de Prov",;		      //Titulo SPA
			"Supplier Nam",;		      //Titulo ENG
			"Nome do Fornecedor",; 		//Descricao
			"Nombre de Proveedor",; 		//Descricao SPA
			"Name of Supplier",; 		//Descricao ENG
			"@!S30",;						   //Picture
			"",;							//VALID      *
			cUsado,;					//USADO
			"",;						 //RELACAO
			"",;						//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"V",;							//VISUAL
			"V",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			'Posicione("LBB",1,xFilial("LBB")+LJZ->LJZ_CODPRO,"LBB_NOMFOR")',;	//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJZ",;			//Arquivo
			"08",;						//Ordem
			"LJZ_DESCPR",;				//Campo
			"C",;						   //Tipo
			30,;						   //Tamanho
			0,;							//Decimal
			"Descr.Propr.",;		      //Titulo
			"Descr.Propr.",;		      //Titulo SPA
			"Descr.Propr.",;		      //Titulo ENG
			"Descricao da Propriedade",; 		//Descricao
			"Descricao da Propriedade",; 		//Descricao SPA
			"Descricao da Propriedade",; 		//Descricao ENG
			"@!",;						   //Picture
			"",;							//VALID      *
			cUsado,;					//USADO
			'IF(!INCLUI,POSICIONE("LBB",1,XFILIAL("LBB")+LJZ->LJZ_CODPRO,"LBB_DESC"),"")',;						 //RELACAO
			"",;						//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"V",;							//VISUAL
			"V",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			'Posicione("LBB",1,xFilial("LBB")+LJZ->LJZ_CODPRO,"LBB_DESC")',;	//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJZ",;			//Arquivo
			"09",;						//Ordem
			"LJZ_DATCLA",;				//Campo
			"D",;						   //Tipo
			8,;						   //Tamanho
			0,;							//Decimal
			"Data Classif",;		      //Titulo
			"Data Classif",;		      //Titulo SPA
			"Data Classif",;		      //Titulo ENG
			"Data Classificacao Qualid",; 		//Descricao
			"Data Classificacao Qualid",;		//Descricao SPA
			"Data Classificacao Qualid",;	    //Descricao ENG
			"@D",;						   //Picture
			"",;		//VALID
			cUsado,;					//USADO
			"DDATABASE",;				//RELACAO
			"",;						//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"A",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJZ",;			//Arquivo
			"10",;						//Ordem
			"LJZ_GORDUR",;				//Campo
			"N",;						   //Tipo
			5,;						   //Tamanho
			2,;							//Decimal
			"%Gordura",;		      //Titulo
			"%Gordura",;		      //Titulo SPA
			"%Gordura",;		      //Titulo ENG
			"Teor de Gordura do Leite",;		      //Descricao 
			"Teor de Gordura do Leite",;		      //Descricao SPA
			"Teor de Gordura do Leite",;		      //Descricao ENG
			"@E 99.99",;				   //Picture
			"",;		//VALID
			cUsado,;					//USADO
			"",;				//RELACAO
			"",;						//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"A",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJZ",;			//Arquivo
			"11",;						//Ordem
			"LJZ_PROTEI",;				//Campo
			"N",;					   //Tipo
			5,;						   //Tamanho
			2,;							//Decimal
			"%Proteina",;		      //Titulo
			"%Proteina",;		      //Titulo SPA
			"%Proteina",;		      //Titulo ENG
			"Teor de Proteina do Leite",;		      //Descricao 
			"Teor de Proteina do Leite",;		      //Descricao SPA
			"Teor de Proteina do Leite",;		      //Descricao ENG
			"@E 99.99",;				   //Picture
			"",;		//VALID
			cUsado,;					//USADO
			"",;				//RELACAO
			"",;						//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"A",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJZ",;			//Arquivo
			"12",;						//Ordem
			"LJZ_CCS",;				//Campo
			"N",;					   //Tipo
			5,;						   //Tamanho
			0,;							//Decimal
			"CCS  1000/ml",;		      //Titulo
			"CCS  1000/ml",;		      //Titulo SPA
			"CCS  1000/ml",;		      //Titulo ENG
			"Contagem Cel. Somaticas",;		      //Descricao 
			"Contagem Cel. Somaticas",;		      //Descricao SPA
			"Contagem Cel. Somaticas",;		      //Descricao ENG
			"@E 99,999",;				   //Picture
			"",;		//VALID
			cUsado,;					//USADO
			"",;				//RELACAO
			"",;						//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"A",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJZ",;			//Arquivo
			"13",;						//Ordem
			"LJZ_CBT",;				//Campo
			"N",;					   //Tipo
			5,;						   //Tamanho
			0,;							//Decimal
			"CBT  1000/ml",;		      //Titulo
			"CBT  1000/ml",;		      //Titulo SPA
			"CBT  1000/ml",;		      //Titulo ENG
			"Contagem Bacteriana Total",;		      //Descricao 
			"Contagem Bacteriana Total",;		      //Descricao SPA
			"Contagem Bacteriana Total",;		      //Descricao ENG
			"@E 99,999",;				   //Picture
			"",;		//VALID
			cUsado,;					//USADO
			"",;				//RELACAO
			"",;						//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"A",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJZ",;			//Arquivo
			"14",;						//Ordem
			"LJZ_PAGQUA",;				//Campo
			"N",;					   //Tipo
			6,;						   //Tamanho
			3,;							//Decimal
			"Pagto.Qualid",;		      //Titulo
			"Pagto.Qualid",;		      //Titulo SPA
			"Pagto.Qualid",;		      //Titulo ENG
			"Pagto.Qualidade por Litro",;		      //Descricao 
			"Pagto.Qualidade por Litro",;		      //Descricao SPA
			"Pagto.Qualidade por Litro",;		      //Descricao ENG
			"@E 99.999",;				   //Picture
			"",;		//VALID
			cUsado,;					//USADO
			"",;				//RELACAO
			"",;						//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"V",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJZ",;			//Arquivo
			"15",;						//Ordem
			"LJZ_RESGOR",;				//Campo
			"N",;					   //Tipo
			6,;						   //Tamanho
			3,;							//Decimal
			"$/Litro GOR",;		      //Titulo
			"$/Litro GOR",;		      //Titulo SPA
			"$/Litro GOR",;		      //Titulo ENG
			"$/Litro Ref. %Gordura",;		      //Descricao 
			"$/Litro Ref. %Gordura",;		      //Descricao SPA
			"$/Litro Ref. %Gordura",;		      //Descricao ENG
			"@E 99.999",;				   //Picture
			"",;		//VALID
			cUsado,;					//USADO
			"",;				//RELACAO
			"",;						//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"V",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJZ",;			//Arquivo
			"16",;						//Ordem
			"LJZ_RESPRO",;				//Campo
			"N",;					   //Tipo
			6,;						   //Tamanho
			3,;							//Decimal
			"$/Litro PROT",;		      //Titulo
			"$/Litro PROT",;		      //Titulo SPA
			"$/Litro PROT",;		      //Titulo ENG
			"$/Litro Ref. %Proteina",;		      //Descricao 
			"$/Litro Ref. %Proteina",;		      //Descricao SPA
			"$/Litro Ref. %Proteina",;		      //Descricao ENG
			"@E 99.999",;				   //Picture
			"",;		//VALID
			cUsado,;					//USADO
			"",;				//RELACAO
			"",;						//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"V",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJZ",;			//Arquivo
			"17",;						//Ordem
			"LJZ_RESCCS",;				//Campo
			"N",;					   //Tipo
			6,;						   //Tamanho
			3,;							//Decimal
			"$/Litro CCS",;		      //Titulo
			"$/Litro CCS",;		      //Titulo SPA
			"$/Litro CCS",;		      //Titulo ENG
			"$/Litro Ref. CCS",;		      //Descricao 
			"$/Litro Ref. CCS",;		      //Descricao SPA
			"$/Litro Ref. CCS",;		      //Descricao ENG
			"@E 99.999",;				   //Picture
			"",;		//VALID
			cUsado,;					//USADO
			"",;				//RELACAO
			"",;						//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"V",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		Aadd(aSX3,{"LJZ",;			//Arquivo
			"18",;						//Ordem
			"LJZ_RESCBT",;				//Campo
			"N",;					   //Tipo
			6,;						   //Tamanho
			3,;							//Decimal
			"$/Litro CBT",;		      //Titulo
			"$/Litro CBT",;		      //Titulo SPA
			"$/Litro CBT",;		      //Titulo ENG
			"$/Litro Ref. CBT",;		      //Descricao 
			"$/Litro Ref. CBT",;		      //Descricao SPA
			"$/Litro Ref. CBT",;		      //Descricao ENG
			"@E 99.999",;				   //Picture
			"",;		//VALID
			cUsado,;					//USADO
			"",;				//RELACAO
			"",;						//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"V",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		//Atualizacao campo em LBB

		dbSelectArea("SX3")
		SX3->(DbSetOrder(2))
		If SX3->(MsSeek("LBB_GORDUR"))
			cOrdem := SX3->X3_ORDEM
		Else
			cOrdem := NewX3Ord("LBB")
		EndIf

		Aadd(aSX3,{"LBB",;			//Arquivo
			cOrdem,;						//Ordem
			"LBB_GORDUR",;				//Campo
			"N",;						   //Tipo
			5,;						   //Tamanho
			2,;							//Decimal
			"%Gordura",;		      //Titulo
			"%Gordura",;		      //Titulo SPA
			"%Gordura",;		      //Titulo ENG
			"Teor de Gordura do Leite",;		      //Descricao 
			"Teor de Gordura do Leite",;		      //Descricao SPA
			"Teor de Gordura do Leite",;		      //Descricao ENG
			"@E 99.99",;				   //Picture
			"",;		//VALID
			cUsado,;					//USADO
			"",;				//RELACAO
			"",;						//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"V",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		//Atualizacao campo em LBQ

		dbSelectArea("SX3")
		SX3->(DbSetOrder(2))
		If SX3->(MsSeek("LBQ_CRIQUA"))
			cOrdem := SX3->X3_ORDEM
		Else
			cOrdem := NewX3Ord("LBQ")
		EndIf

		Aadd(aSX3,{"LBQ",;			//Arquivo
			cOrdem,;						//Ordem
			"LBQ_CRIQUA",;				//Campo
			"C",;						   //Tipo
			1,;						   //Tamanho
			0,;							//Decimal
			"Crit.Qualid.",;		      //Titulo
			"Crit.Qualid.",;		      //Titulo SPA
			"Crit.Qualid.",;		      //Titulo ENG
			"Criterio da Qualidade",;		      //Descricao 
			"Criterio da Qualidade",;		      //Descricao SPA
			"Criterio da Qualidade",;		      //Descricao ENG
			"@!",;				   //Picture
			"",;		//VALID
			cUsado,;					//USADO
			"",;				//RELACAO
			"",;						//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"S",;							//BROWSE
			"V",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

		cOrdem  := Soma1(cOrdem)
		Aadd(aSX3,{"LBQ",;			//Arquivo
			cOrdem,;						//Ordem
			"LBQ_PAGQUA",;				//Campo
			"N",;						   //Tipo
			5,;						   //Tamanho
			2,;							//Decimal
			"Pg.Qual/Crit",;		      //Titulo
			"Pg.Qual/Crit",;		      //Titulo SPA
			"Pg.Qual/Crit",;		      //Titulo ENG
			"Pag.Qualidade p/Criterio",;      //Descricao 
			"Pag.Qualidade p/Criterio",;      //Descricao SPA
			"Pag.Qualidade p/Criterio",;      //Descricao ENG
			"@EZ 99.99",;				   //Picture
			"",;		//VALID
			cUsado,;					//USADO
			"",;				//RELACAO
			"",;						//F3
			1,;							//NIVEL
			cReserv,;					//RESERV
			"",;							//CHECK
			"",;							//TRIGGER
			"T",;							//PROPRI
			"N",;							//BROWSE
			"V",;							//VISUAL
			"R",;							//CONTEXT
			"",;							//OBRIGAT
			"",;							//VLDUSER
			"",;			//CBOX
			"",;			//CBOX SPA
			"",;			//CBOX ENG
			"",;							//PICTVAR
			"",;							//WHEN
			"",;							//INIBRW
			"",;							//SXG
			"",;							//FOLDER			
			""})							//PYME

ProcRegua(Len(aSX3))

SX3->(DbSetOrder(2))	

For i:= 1 To Len(aSX3)
	If !Empty(aSX3[i][1])
		If !dbSeek(aSX3[i,3])
			lSX3	:= .T.
			If !(aSX3[i,1]$cAlias)
				cAlias += aSX3[i,1]+"/"
				aAdd(aArqUpd,aSX3[i,1])
			EndIf
			RecLock("SX3",.T.)
			For j:=1 To Len(aSX3[i])
				If FieldPos(aEstrut[j])>0 .And. aSX3[i,j] != NIL
					FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Dicionário de Dados...") //
		Endif
	EndIf
Next i

If lSX3
	cTexto := 'Foram alteradas as estruturas das seguintes tabelas : '+cAlias+CHR(13)+CHR(10)
EndIf

Return cTexto


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³LEIAtuSX2 ³ Autor ³Ricardo Berti          ³ Data ³ 17.11.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX2 - Arquivos      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao COL_LEI                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function LEIAtuSX2()
Local aSX2   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local lSX2	 := .F.
Local cAlias := ''
Local cPath
Local cNome

aEstrut:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPA","X2_NOMEENG","X2_DELET","X2_MODO","X2_TTS","X2_ROTINA","X2_PYME"}

ProcRegua(Len(aSX2))

dbSelectArea("SX2")
SX2->(DbSetOrder(1))	
MsSeek("LBB")
cPath := SX2->X2_PATH
cNome := Substr(SX2->X2_ARQUIVO,4,5)

	aadd(aSX2,{	"LJY",; 							//Chave
		cPath,;										//Path
		"LJY"+cNome,;								//Nome do Arquivo
		"CRITERIOS VALORIZ.DA QUALIDADE",;	 		//Nome Port
		"CRITERIOS VALORIZAC. CALIDAD",;			//Nome Esp
		"CRITERIA TO VALUE MILK QUALITY",;			//Nome Ing
		0,;											//Delete
		"E",;										//Modo - (C)Compartilhado ou (E)Exclusivo
		"N",;										//TTS
		"",;										//Rotina
		"N"})										//Pyme
		
	aadd(aSX2,{	"LJZ",; 							//Chave
		cPath,;										//Path
		"LJZ"+cNome,;								//Nome do Arquivo
		"HISTORICO CLASSIF.DA QUALIDADE",;	 		//Nome Port
		"HISTORICO CLASSIF.DA QUALIDADE",;	 		//Nome ESP
		"HISTORICO CLASSIF.DA QUALIDADE",;	 		//Nome ENG
		0,;											//Delete
		"E",;										//Modo - (C)Compartilhado ou (E)Exclusivo
		"N",;										//TTS
		"",;										//Rotina
		"N"})										//Pyme

For i:= 1 To Len(aSX2)
	If !Empty(aSX2[i][1])
		If !MsSeek(aSX2[i,1])
			lSX2	:= .T.
			If !(aSX2[i,1]$cAlias)
				cAlias += aSX2[i,1]+"/"
			EndIf
			RecLock("SX2",.T.)
			For j:=1 To Len(aSX2[i])
				If FieldPos(aEstrut[j]) > 0
					FieldPut(FieldPos(aEstrut[j]),aSX2[i,j])
				EndIf
			Next j
			SX2->X2_PATH := cPath
			SX2->X2_ARQUIVO := aSX2[i,1]+cNome
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Dicionario de Arquivos...") //
		EndIf
	EndIf
Next i

Return cTexto


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³LEIAtuSIX ³ Autor ³Ricardo Berti          ³ Data ³ 17.11.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SIX - Indices       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao LEI                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function LEIAtuSIX()
//INDICE ORDEM CHAVE DESCRICAO DESCSPA DESCENG PROPRI F3 NICKNAME SHOWPESQ
Local cTexto    := ''
Local lSix      := .F.
Local aSix      := {}
Local aEstrut   := {}
Local i         := 0
Local j         := 0
Local cAlias    := ''
Local lDelInd   := .F.

aEstrut:= {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME","SHOWPESQ"}

	aadd(aSIX,{"LJY",;   										//Indice
		"1",;                 									//Ordem
		"LJY_FILIAL+LJY_CODQUA+LJY_TIPOL+STR(LJY_VINIC,12,2)",;  //Chave
		"Cod.Tb.Qual.+Leite Tipo+De",;  						//Descricao Port.
		"Cod.Tb.Calidad+Leche Tipo+De",;  						//Descricao SPA
		"Table Code+Milk type+From",; 			 				//Descricao ENG
		"T",; 													//Proprietario
		"",;  													//F3
		"",;  													//NickName
		"S"}) 													//ShowPesq

	aadd(aSIX,{"LJZ",;   										//Indice
		"1",;                 									//Ordem
		"LJZ_FILIAL+DTOS(LJZ_DATCLQ)+LJZ_CODPRO",; 				//Chave
		"Dt Refer.+Codigo Prop.",;  						//Descricao Port.
		"Dt Refer.+Codigo Prop.",;  						//Descricao SPA
		"Dt Refer.+Codigo Prop.",; 			 				//Descricao ENG
		"T",; 													//Proprietario
		"",;  													//F3
		"",;  													//NickName
		"S"}) 													//ShowPesq

	aadd(aSIX,{"LJZ",;   										//Indice
		"2",;                 									//Ordem
		"LJZ_FILIAL+DTOS(LJZ_DATCLQ)+LJZ_CODROT+LJZ_TIPOL+LJZ_CODPRO",; 	//Chave
		"Dt Refer.+Codigo Rota+Leite Propr.+Codigo Prop.",;  			//Descricao Port.
		"Dt Refer.+Codigo Rota+Leite Propr.+Codigo Prop.",;  			//Descricao SPA
		"Dt Refer.+Codigo Rota+Leite Propr.+Codigo Prop.",; 			//Descricao ENG
		"T",; 													//Proprietario
		"",;  													//F3
		"",;  													//NickName
		"S"}) 													//ShowPesq

	aadd(aSIX,{"LJZ",;   										//Indice
		"3",;                 									//Ordem
		"LJZ_FILIAL+DTOS(LJZ_DATCLQ)+LJZ_TIPOL+LJZ_CODPRO",; 				//Chave
		"Dt Refer.+Leite Propr.+Codigo Prop.",;  						//Descricao Port.
		"Dt Refer.+Leite Propr.+Codigo Prop.",;  						//Descricao SPA
		"Dt Refer.+Leite Propr.+Codigo Prop.",; 			 				//Descricao ENG
		"T",; 													//Proprietario
		"",;  													//F3
		"",;  													//NickName
		"S"}) 													//ShowPesq

	aadd(aSIX,{"LJZ",;   										//Indice
		"4",;                 									//Ordem
		"LJZ_FILIAL+LJZ_CODPRO+DTOS(LJZ_DATCLQ)",; 				//Chave
		"Codigo Prop.+Dt Refer.",;  						//Descricao Port.
		"Codigo Prop.+Dt Refer.",;  						//Descricao SPA
		"Codigo Prop.+Dt Refer.",; 			 				//Descricao ENG
		"T",; 													//Proprietario
		"",;  													//F3
		"",;  													//NickName
		"S"}) 													//ShowPesq

ProcRegua(Len(aSIX))

dbSelectArea("SIX")
SIX->(DbSetOrder(1))

For i:= 1 To Len(aSIX)
	If !Empty(aSIX[i,1])
		If !MsSeek(aSIX[i,1]+aSIX[i,2])
			RecLock("SIX",.T.)
			lDelInd := .F.
		Else
			RecLock("SIX",.F.)
			lDelInd := .T. //Se for alteracao precisa apagar o indice do banco
		EndIf
		
		If UPPER(AllTrim(CHAVE)) != UPPER(Alltrim(aSIX[i,3]))
			aAdd(aArqUpd,aSIX[i,1])
			lSix := .T.
			If !(aSIX[i,1]$cAlias)
				cAlias += aSIX[i,1]+"/"
			EndIf
			For j:=1 To Len(aSIX[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSIX[i,j])
				EndIf
			Next j
			dbCommit()        
			MsUnLock()
			cTexto  += (aSix[i][1] + " - " + aSix[i][3] + Chr(13) + Chr(10))
			If lDelInd
				TcInternal(60,RetSqlName(aSix[i,1]) + "|" + RetSqlName(aSix[i,1]) + aSix[i,2]) //Exclui sem precisar baixar o TOP
			Endif	
		EndIf
		IncProc("Atualizando índices...")
	EndIf
Next i

If lSix
	cTexto += "Índices atualizados  : "+cAlias+CHR(13)+CHR(10)
EndIf

Return cTexto


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyOpenSM0Ex³ Autor ³Sergio Silveira       ³ Data ³07/01/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a abertura do SM0 exclusivo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao FIS                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MyOpenSM0Ex()

Local lOpen := .F. 
Local nLoop := 0 

For nLoop := 1 To 20
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. ) 
	If !Empty( Select( "SM0" ) ) 
		lOpen := .T. 
		dbSetIndex("SIGAMAT.IND") 
		Exit	
	EndIf
	Sleep( 500 ) 
Next nLoop 

If !lOpen
	Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 ) 
EndIf                                 

Return( lOpen ) 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³LEIAtuSX6 ³ Autor ³Ricardo Berti          ³ Data ³20/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX6                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao FIS                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LEIAtuSX6()

Local aSX6   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX6	 := .F.
Local cTexto := ''
Local cAlias := ''
Local cVar	 := ''

aEstrut:= { "X6_FIL","X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1","X6_DSCENG1",;
	"X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI","X6_PYME"}

AADD(aSx6,{"  ",'MV_CTABCBT','C','Codigo p/ o criterio CBT (Contagem Bacteriana     ','Codigo p/ o criterio CBT (Contagem Bacteriana     ','Codigo p/ o criterio CBT (Contagem Bacteriana     ','Total) na Tab.Criterios da Qualidade - Template   ','Total) na Tab.Criterios da Qualidade - Template   ','Total) na Tab.Criterios da Qualidade - Template   ',;
			"Coop.Leite","Coop.Leite","Coop.Leite","CBT","CBT","CBT","T","N"})
AADD(aSx6,{"  ",'MV_CTABCCS','C','Codigo p/ o criterio CCS (Contagem Celulas        ','Codigo p/ o criterio CCS (Contagem Celulas        ','Codigo p/ o criterio CCS (Contagem Celulas        ','Somaticas) na Tab.Crit.Qualidade - Template Coop. ','Somaticas) na Tab.Crit.Qualidade - Template Coop. ','Somaticas) na Tab.Crit.Qualidade - Template Coop. ',;
			"Leite","Leite","Leite","CCS","CCS","CCS","T","N"})
AADD(aSx6,{"  ",'MV_CTABGOR','C','Codigo p/ o criterio GORDURA na Tabela Criterios  ','Codigo p/ o criterio GORDURA na Tabela Criterios  ','Codigo p/ o criterio GORDURA na Tabela Criterios  ','da Qualidade - Template de Cooperativa de Leite   ','da Qualidade - Template de Cooperativa de Leite   ','da Qualidade - Template de Cooperativa de Leite   ',;
			"","","","GORDURA","GORDURA","GORDURA","T","N"})
AADD(aSx6,{"  ",'MV_CTABPRO','C','Codigo p/ o criterio PROTEINA na Tab.de Criterios ','Codigo p/ o criterio PROTEINA na Tab.de Criterios ','Codigo p/ o criterio PROTEINA na Tab.de Criterios ','da Qualidade - Template de Cooperativa de Leite   ','da Qualidade - Template de Cooperativa de Leite   ','da Qualidade - Template de Cooperativa de Leite   ',;
			"","","","PROTEINA","PROTEINA","PROTEINA","T","N"})

ProcRegua(Len(aSX6))

dbSelectArea("SX6")
dbSetOrder(1)
For i:= 1 To 4
	If !Empty(aSX6[i][2])
        cVar :="  MV_FXFAT"+ALLTRIM(STRZERO(i,2))
		If dbSeek(cVar)
			RecLock("SX6",.F.)
			dbDelete()
			dbCommit()
			MsUnLock()
		EndIf
	EndIf
Next i

dbSelectArea("SX6")
dbSetOrder(1)
For i:= 1 To Len(aSX6)
	If !Empty(aSX6[i][2])
		If !dbSeek(aSX6[i,1]+aSX6[i,2])
			lSX6	:= .T.
			If !(aSX6[i,2]$cAlias)
				cAlias += aSX6[i,2]+"/"
			EndIf
			RecLock("SX6",.T.)
			For j:=1 To Len(aSX6[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX6[i,j])
				EndIf
			Next j

			dbCommit()
			MsUnLock()
			IncProc("Atualizando Parametros...") //
		EndIf
	EndIf
Next i

If lSX6
	cTexto := 'Incluidos novos parametros. Verifique as suas configuracoes e funcionalidades : '+cAlias+CHR(13)+CHR(10)
EndIf

Return cTexto







/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ NewX3Ord ³ Autor ³Ricardo Berti          ³ Data ³ 31.03.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Determina o no.da prox.ordem no SX3, p/ uso quando incluir ³±±
±±³          ³ um novo campo numa tabela                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpN1 := NewX3Ord(ExpC1)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpN1 = No.da ordem a utilizar em novo campo               ³±±
±±³          ³         Obs.: Se nao existir a tabela, retorna em branco   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Geral                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function NewX3Ord(cAlias)

Local cOrdem := " "
aAreaSX3	 := GetArea("SX3")
aArea		 := Alias()

SX3->(DbSetOrder(1))	
SX3->(MsSeek(cAlias))
If SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAlias
	Do While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAlias
		SX3->(dbSkip())
	EndDo
	SX3->(dbSkip(-1))
	cOrdem  := Soma1(SX3->X3_ORDEM)
EndIf
RestArea(aAreaSX3)
dbSelectArea(aArea)

Return(cOrdem)

////////////////////////////////////////////////
///////////////////////////////////////////////

User Function X3Sa1Sus()

Local cTexto 	:= ''
Local aEstru	:= {}

dbSelectArea("SX3")
SX3->(DbSetOrder(1))

If SX3->(MsSeek("SA1"))

	While SX3->( !Eof() ) .AND. Alltrim(SX3->(X3_ARQUIVO)) == 'SA1'
		AADD(aEstru,{AllTrim(SX3->(X3_CAMPO)),AllTrim(SX3->(X3_OBRIGAT)),Space(10)})
		SX3->(dbSkip())

	EndDo

End If

dbSelectArea("SX3")
SX3->(DbSetOrder(2))

For i := 1 To Len(aEstru)

If SX3->(MsSeek("US_"+SubStr(aEstru[i][1],4,6)))
	aEstru[i][3] := SX3->(X3_CAMPO)
Else
	aEstru[i][3] := "C R I A R"
EndIf

Next i

For i := 1 To Len(aEstru)
	cTexto += aEstru[i][1]+";"+aEstru[i][2]+";"+aEstru[i][3] + CRLF 
Next i


MemoWrite("C:\HD\QUERYS\ESTRUTURA_SA1.CSV",cTexto)

/*
//--Pesquisa um campo existente para gravar o Reserv e o Usado
	If SX3->(MsSeek("LBB_DESC")) //Este campo e obrigatorio e permite alterar
		For nI := 1 To SX3->(FCount())
			If "X3_RESERV" $ SX3->(FieldName(nI))
				cReservObrig := SX3->(FieldGet(FieldPos(FieldName(nI))))
			EndIf
			If "X3_USADO"  $ SX3->(FieldName(nI))
				cUsadoObrig  := SX3->(FieldGet(FieldPos(FieldName(nI))))
			EndIf
		Next 							
	EndIf		
If SX3->(MsSeek("LBB_END")) //Este campo e somente visualizacao
	For nI := 1 To SX3->(FCount())
		If "X3_RESERV" $ SX3->(FieldName(nI))
			cReserv := SX3->(FieldGet(FieldPos(FieldName(nI))))
		EndIf
		If "X3_USADO"  $ SX3->(FieldName(nI))
			cUsado  := SX3->(FieldGet(FieldPos(FieldName(nI))))
		EndIf
	Next
EndIf
*/
MsgAlert("Fim")

Return



Static Function LEIAtuSX3()

Local aSX3           := {}
Local aEstrut        := {}
Local i              := 0
Local j              := 0
Local lSX3	         := .F.
Local cTexto         := ''
Local cAlias         := ''
Local cReserv        := ''
Local cReservObrig   := ''
Local cUsado         := ''
Local cUsadoObrig    := ''
Local nI             := 0
Local nOrdem		 := 0

Local aEstru	:= {}

dbSelectArea("SX3")
SX3->(DbSetOrder(1))

If SX3->(MsSeek("SA1"))

	While SX3->( !Eof() ) .AND. Alltrim(SX3->(X3_ARQUIVO)) == 'SA1'
		AADD(aEstru,{AllTrim(SX3->(X3_CAMPO)),AllTrim(SX3->(X3_OBRIGAT)),Space(10)})
		SX3->(dbSkip())

	EndDo

End If

dbSelectArea("SX3")
SX3->(DbSetOrder(1))

If SX3->(MsSeek("SUS"))

	While SX3->( !Eof() ) .AND. Alltrim(SX3->(X3_ARQUIVO)) == 'SUS'
		nOrdem ++
		SX3->(dbSkip())
	EndDo

End If

dbSelectArea("SX3")
SX3->(DbSetOrder(2))

For i := 1 To Len(aEstru)

If SX3->(MsSeek("US_"+SubStr(aEstru[i][1],4,6)))
	aEstru[i][3] := SX3->(X3_CAMPO)
Else
	aEstru[i][3] := "C R I A R"
EndIf

Next i

For i := 1 To Len(aEstru)
	cTexto += aEstru[i][1]+";"+aEstru[i][2]+";"+aEstru[i][3] + CRLF 
Next i


MemoWrite("C:\HD\QUERYS\ESTRUTURA_SA1.CSV",cTexto)

//======================================================================================================================

aEstrut := { "X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,"X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL","X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
	"X3_DESCRIC","X3_DESCSPA","X3_DESCENG","X3_PICTURE","X3_VALID"  ,"X3_USADO"  ,"X3_RELACAO","X3_F3"     ,"X3_NIVEL"  ,;
	"X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,"X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER",;
	"X3_CBOX"   ,"X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,"X3_GRPSXG" ,"X3_FOLDER", "X3_PYME"}

dbSelectArea("SX3")
SX3->(DbSetOrder(2))


For i := 1 To Len(aEstru)

	If SX3->(MsSeek(aEstru[i][1])) .AND. AllTrim(aEstru[i][3]) == 'C R I A R'  //Este campo e obrigatorio e permite alterar
			If AllTrim(RetAsc( Str( nOrdem ), 2, .T. )) == 'Z9'
				nOrdem := nOrdem
			Else
				nOrdem ++
			End If
			
			Aadd(aSX3,{"SUS",;							//Arquivo
				RetAsc( Str( nOrdem ), 2, .T. ),;					//Ordem
				"US_"+SubStr(SX3->(X3_CAMPO),4,7),;		//Campo
				SX3->(X3_TIPO),;					   	//Tipo
				SX3->(X3_TAMANHO),;						//Tamanho
				SX3->(X3_DECIMAL),;						//Decimal
				SX3->(X3_TITULO),;			    		//Titulo
				SX3->(X3_TITSPA),;			   			//Titulo SPA
				SX3->(X3_TITENG),;			       		//Titulo ENG
				SX3->(X3_DESCRIC),;						//Descricao
				SX3->(X3_DESCSPA),;						//Descricao SPA
				SX3->(X3_DESCENG),;						//Descricao ENG
				SX3->(X3_PICTURE),;					   	//Picture
				SX3->(X3_VALID),;						//VALID
				SX3->(X3_USADO),;						//USADO
				SX3->(X3_RELACAO),;									//RELACAO
				SX3->(X3_F3),;							//F3
				SX3->(X3_NIVEL),;						//NIVEL
				SX3->(X3_RESERV),;						//RESERV
				SX3->(X3_CHECK),;						//CHECK
				SX3->(X3_TRIGGER),;						//TRIGGER
				SX3->(X3_PROPRI),;						//PROPRI
				SX3->(X3_BROWSE),;						//BROWSE
				SX3->(X3_VISUAL),;						//VISUAL
				SX3->(X3_CONTEXT),;						//CONTEXT
				SX3->(X3_OBRIGAT),;						//OBRIGAT
				SX3->(X3_VLDUSER),;						//VLDUSER
				SX3->(X3_CBOX),;						//CBOX
				SX3->(X3_CBOXSPA),;						//CBOX SPA
				SX3->(X3_CBOXENG),;						//CBOX ENG
				SX3->(X3_PICTVAR),;						//PICTVAR
				SX3->(X3_WHEN),;						//WHEN
				SX3->(X3_INIBRW),;						//INIBRW
				SX3->(X3_GRPSXG),;						//SXG
				SX3->(X3_FOLDER),;						//FOLDER			
				SX3->(X3_PYME)})						//CONDSQL
				
	EndIf


Next i

ProcRegua(Len(aSX3))

SX3->(DbSetOrder(2))	

For i:= 1 To Len(aSX3)
	If !Empty(aSX3[i][1])
		If !dbSeek(aSX3[i,3])
			lSX3	:= .T.
			If !(aSX3[i,1]$cAlias)
				cAlias += aSX3[i,1]+"/"
				aAdd(aArqUpd,aSX3[i,1])
			EndIf
			RecLock("SX3",.T.)
			For j:=1 To Len(aSX3[i])
				If FieldPos(aEstrut[j])>0 .And. aSX3[i,j] != NIL
					FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Dicionário de Dados...") //
		Endif
	EndIf
Next i

If lSX3
	cTexto := 'Foram alteradas as estruturas das seguintes tabelas : '+cAlias+CHR(13)+CHR(10)
EndIf

Return cTexto
