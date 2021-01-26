

Atrav�s do exemplo abaixo, � poss�vel montar um tree com itens e sub-itens.

Vale lembrar que devem ser utilizados os includes 'protheus.ch' e 'dbtree.ch'

Para testar o programa abaixo, basta compil�-lo, e inserir uma chamada ao mesmo no Menu do ERP, no m�dulo desejado.

#include 'protheus.ch'
#include 'dbtree.ch'
User Function MyTree()// Cria um di�logo
DEFINE DIALOG oDlg TITLE "Teste de DBTree"
FROM 10,10 TO 400,700 COLOR CLR_BLACK,CLR_WHITE PIXEL// Cria o DbTree no di�logo, ocupando o tamanho total do mesmo
DEFINE DBTREE oEmpTree FROM 00,00 TO oDlg:nHeight,oDlg:nWidth OF oDlg CARGOD
BADDTREE oEmpTree PROMPT "Menu 001" RESOURCE "BMPTABLE" CARGO "#0001"
DBADDITEM oEmpTree PROMPT "Item 001" RESOURCE "BMPSXG" CARGO "#0002"
DBENDTREE oEmpTree
DBADDITEM oEmpTree PROMPT "Item 002" RESOURCE "BMPTRG"   CARGO "#0003"
DBADDITEM oEmpTree PROMPT "Item 003" RESOURCE "BMPCONS"  CARGO "#0004"
DBADDITEM oEmpTree PROMPT "Item 004" RESOURCE "BMPPARAM" CARGO "#0005"
DBADDTREE oEmpTree PROMPT "Menu 002" OPENED RESOURCE "BMPTABLE" CARGO "#0006"
DBADDITEM oEmpTree PROMPT "Item 005" RESOURCE "BMPSXG" CARGO "#0007"
DBADDTREE oEmpTree PROMPT "Menu 003" OPENED RESOURCE "BMPTABLE" CARGO "#0008"
DBADDITEM oEmpTree PROMPT "Item 006" RESOURCE "BMPSXG" CARGO "#0009"
DBADDTREE oEmpTree PROMPT "Menu 004" OPENED RESOURCE "BMPTABLE" CARGO "#0010"
DBADDITEM oEmpTree PROMPT "Item 007" RESOURCE "BMPSXG" CARGO "#0011"
DBENDTREE oEmpTree		DBADDITEM oEmpTree PROMPT "Item 008" RESOURCE "BMPSXG" CARGO "#0012"
DBENDTREE oEmpTreeDBENDTREE oEmpTreeDBADDITEM oEmpTree PROMPT "Item 009" RESOURCE "BMPSXB"   CARGO "#0013"
ACTIVATE DIALOG oDlg CENTER Return
