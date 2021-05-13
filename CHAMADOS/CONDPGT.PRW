#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} xCdPgto
Condicao de pagamento diferenciado por Sku no mesmo pedido
@type function
@author Wilson Davila
@since 07/05/2021
/*/

User Function xCdPgto(xProd,xCliente,xValor,xNumPed)

Local aArea := GetArea()

ZX7->( dbSetOrder(1) )


If ZX7->( dbSeek( xCliente+SB1->B1_XCATEGO ) )





EndIf












RestArea(aArea)

Return
