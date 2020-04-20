#include "rwmake.ch" 

/*
	Programa......:	COFAT06
	Autor.........:	Geraldo E. Franciscon
	Data..........:	29/12/00
	Descricao.....:	Verifica se o Fornecedor esta cadastrado como Cliente
	Mudanca Versao:	** indice ok ** 17/02/2003 10:17
	Alterado      : DAniel em 16/06/2003 pesquisa codigo ja cadastrado e atualizacao de dados
*/

User Function cofat06()

_aArea := GetArea()

dbSelectArea( "SA1" )
_aAreaSA1 := GetArea()
dbSetOrder(3)
If dbSeek( xFilial("SA1") + M->A2_CGC )
	
	MsgBox("Este Fornecedor esta cadastrado como Cliente com o Codigo " + SA1->A1_COD + " e Loja " + SA1->A1_LOJA + ".","Consistencia entre Fornecedor X Cliente")
	dbSelectArea( "SA2" )
	dbSetOrder(1)
	dbSeek( xFilial("SA2") + SA1->A1_COD + SA1->A1_LOJA)
    	If  SA2->A2_COD + SA2->A2_LOJA == SA1->A1_COD + SA1->A1_LOJA 
    		M->A2_Nome    := SA1->A1_Nome
	    	M->A2_Nreduz  := SA1->A1_Nreduz
	    	M->A2_Pessoa  := SA1->A1_Tipo
	    	M->A2_Cod_Mun := SA1->A1_Cod_Mun
		    M->A2_Mun     := SA1->A1_Mun
    		M->A2_Est     := SA1->A1_Est
	    	M->A2_Bairro  := SA1->A1_Bairro
	    	M->A2_Cep     := SA1->A1_Cep
		    M->A2_endcob  := SA1->A1_End
	    	M->A2_End     := SA1->A1_End
	    	M->A2_tel     := SA1->A1_Tel
		    M->A2_Inscr   := SA1->A1_Inscr
		    M->A2_fax     := SA1->A1_Fax
	    	M->A2_contato := SA1->A1_Contato
		    M->A2_Inscrm  := SA1->A1_Inscrm
	    	M->A2_email   := SA1->A1_Email
		    M->A2_Hpage   := SA1->A1_Hpage
	   
    Else
    
       		M->A2_Cod  := SA1->A1_Cod
    		M->A2_Loja := SA1->A1_Loja 
	    	M->A2_Nome := SA1->A1_Nome
		    M->A2_Nreduz := SA1->A1_Nreduz
    		M->A2_Pessoa := SA1->A1_Tipo    
    		M->A2_Cod_Mun := SA1->A1_Cod_Mun
	    	M->A2_Mun    := SA1->A1_Mun
	    	M->A2_Est    := SA1->A1_Est
		    M->A2_Bairro := SA1->A1_Bairro
    		M->A2_Cep    := SA1->A1_Cep
		    M->A2_endcob := SA1->A1_End
		    M->A2_End    := SA1->A1_End
    		M->A2_tel    := SA1->A1_Tel
		    M->A2_Inscr  := SA1->A1_Inscr
		    M->A2_fax    := SA1->A1_Fax
	    	M->A2_contato := SA1->A1_Contato
		    M->A2_Inscrm  := SA1->A1_Inscrm
    		M->A2_email   := SA1->A1_Email
		    M->A2_Hpage   := SA1->A1_Hpage
	 Endif  
	  

Endif

RestArea(_aAreaSA1)
RestArea(_aArea)

Return( M->A2_CGC )
	