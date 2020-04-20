#include "rwmake.ch" 

/*
	Programa......:	COFAT05
	Autor.........:	Geraldo E. Franciscon
	Data..........:	29/12/00
	Descricao.....:	Verifica se o Cliente esta cadastrado como Fornecedor
	Mudanca Versao:	** indice ok ** 17/02/2003 10:15
		Alterado      : DAniel em 16/06/2003 pesquisa codigo ja cadastrado e atualizacao de dados
*/

User Function cofat05()		    

_aArea := GetArea()

dbSelectArea( "SA2" )
_aAreaSA2 := GetArea()
dbSetOrder(3)
If dbSeek( xFilial("SA2") + M->A1_CGC )
	
	MsgBox("Este Cliente esta cadastrado como Fornecedor com o Codigo " + SA2->A2_COD + " e Loja " + SA2->A2_LOJA + ".","Consistencia entre Cliente X Fornecedor")
    dbSelectArea( "SA1" )
	dbSetOrder(1)
	dbSeek( xFilial("SA1") + SA2->A2_COD + SA2->A2_LOJA)
    	If SA1->A1_COD + SA1->A1_LOJA == SA2->A2_COD + SA2->A2_LOJA 
    		M->A1_Nome    := SA2->A2_Nome
	    	M->A1_Nreduz  := SA2->A2_Nreduz
	    	M->A1_Pessoa  := SA2->A2_Tipo
	    	M->A1_Cod_Mun := SA2->A2_Cod_Mun
		    M->A1_Mun     := SA2->A2_Mun
    		M->A1_Est     := SA2->A2_Est
	    	M->A1_Bairro  := SA2->A2_Bairro
	    	M->A1_Cep     := SA2->A2_Cep
		    M->A1_endcob  := SA2->A2_End
	    	M->A1_End     := SA2->A2_End
	    	M->A1_tel     := SA2->A2_Tel
		    M->A1_Inscr   := SA2->A2_Inscr
		    M->A1_fax     := SA2->A2_Fax
	    	M->A1_contato := SA2->A2_Contato
		    M->A1_Inscrm  := SA2->A2_Inscrm
	    	M->A1_email   := SA2->A2_Email
		    M->A1_Hpage   := SA2->A2_Hpage
	   
    Else
    
       		M->A1_Cod  := SA2->A2_Cod
    		M->A1_Loja := SA2->A2_Loja 
	    	M->A1_Nome := SA2->A2_Nome
		    M->A1_Nreduz := SA2->A2_Nreduz
    		M->A1_Pessoa := SA2->A2_Tipo    
    		M->A1_Cod_Mun := SA2->A2_Cod_Mun
	    	M->A1_Mun    := SA2->A2_Mun
	    	M->A1_Est    := SA2->A2_Est
		    M->A1_Bairro := SA2->A2_Bairro
    		M->A1_Cep    := SA2->A2_Cep
		    M->A1_endcob := SA2->A2_End
		    M->A1_End    := SA2->A2_End
    		M->A1_tel    := SA2->A2_Tel
		    M->A1_Inscr  := SA2->A2_Inscr
		    M->A1_fax    := SA2->A2_Fax
	    	M->A1_contato := SA2->A2_Contato
		    M->A1_Inscrm  := SA2->A2_Inscrm
    		M->A1_email   := SA2->A2_Email
		    M->A1_Hpage   := SA2->A2_Hpage
	 Endif  
	  
Endif

RestArea(_aAreaSA2)
RestArea(_aArea)

Return(M->A1_CGC)
