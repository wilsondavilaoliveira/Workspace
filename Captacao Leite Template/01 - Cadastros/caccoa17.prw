#include "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CACCOA17 � Autor � Manoel             � Data �  21/03/01   ���
�������������������������������������������������������������������������͹��
���Descricao � Tabela de Tipos de Despesas                                ���
�������������������������������������������������������������������������͹��
���Uso       � Cooperativa de Graos e Leite                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USer Function CACCOA17

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cVldAlt  := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc  := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cAlias := "LBR"

//CHKTEMPLATE("COL")

dbSelectArea(cAlias)
dbSetOrder(1)

AxCadastro(cAlias,"Tipos de Despesas",cVldAlt,cVldExc)

Return