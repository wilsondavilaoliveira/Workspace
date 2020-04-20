#include "protheus.ch"
#include "rwmake.ch"       
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*/{Protheus.doc} WFPRCVEN
WorkFlow de aprovacao preco de venda negociacao
@author Wilson Davila
@since 24/05/2019
/*/

User Function WFPRCVEN()

Local oProcess	:= Nil                        //Objeto da classe TWFProcess.
Local cMailId   := ""                         //ID do processo gerado.
Local cHostWF   := GetMv("MV_WFHTTPI") // http://192.168.20.11:2215 //"http://127.0.0.1:8088/wf" //URL configurado no ini para WF Link.
Local cTo       := "wilson.oliveira@quataalimentos.com.br"    //Destinatário de email.          


PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

//-------------------------------------------------------------------
// "FORMULARIO"
//-------------------------------------------------------------------        

// Instanciamos a classe TWFProcess informando o código e nome do processo.
oProcess := TWFProcess():New("000001", "Treinamento")

// Criamos a tafefa principal que será respondida pelo usuário.
oProcess:NewTask("FORMULARIO", "\Workflow\WF_FORM.html")

// Atribuímos valor a um dos campos do formulário.
oProcess:oHtml:ValByName("TEXT_TIME", Time() )

// Informamos em qual diretório será gerado o formulário.
oProcess:cTo                := "HTML"  

// Informamos qual função será executada no evento de timeout.
oProcess:bTimeOut        := {{"u_wfTimeout()", 0, 0, 5 }}

// Informamos qual função será executada no evento de retorno.  
oProcess:bReturn        := "u_wfRetorno()"

// Iniciamos a tarefa e recuperamos o nome do arquivo gerado.  
cMailID := oProcess:Start()    


//-------------------------------------------------------------------
// "LINK"
//-------------------------------------------------------------------

// Criamos o ling para o arquivo que foi gerado na tarefa anterior.
oProcess:NewTask("LINK", "\workflow\WF_LINK.html")

// Atribuímos valor a um dos campos do formulário.
oProcess:oHtml:ValByName("A_LINK", cHostWF + "/messenger/emp" + cEmpAnt + "/HTML/" + cMailId + ".htm")        

// Informamos o destinatário do email contendo o link.
oProcess:cTo                := cTo          

// Informamos o assunto do email.
oProcess:cSubject        := "Workflow via link."

// Iniciamos a tarefa e enviamos o email ao destinatário.
oProcess:Start()    
Return

/*
Desenvolvimento do HTML:
Criação do Formulário WF_FORM.html

<html>  
<head>      
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Workflow por Link</title>  
</head>  
<body>      
<form action="mailto:%WFMailTo%" method="POST" name="formulario">
 Processo gerado às !TEXT_TIME!                        
 <br>                                                
 Clique aqui para responder -->                        
<input type="submit" value="Enviar"/>      
</form>  
</body>
</html>

Observação:

1.	%WFMailTo% aponta para o comando de destinatário oProcess:cTo := "HTML"
2.	!TEXT_TIME! Aponta para a tarefa e o comando a seguir:
a.	oProcess:NewTask("FORMULARIO", "\Workflow\WF_FORM.html")
b.	oProcess:oHtml:ValByName("TEXT_TIME", Time() )
 

Criação do Link WF_LINK.html

<html>
<head>
<title>Workflow por Link</title>
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>
</head>
<body>
<form name='form1' method='post' action=''>
 <p>Clique no <a href='!A_LINK!'>link</a> para responder.</p>
</form>
</body>
</html>

Observação:

3.	!A_LINK! Aponta para os comandos a seguir:
a.	oProcess:NewTask("LINK", "\workflow\WF_LINK.html")
b.	oProcess:oHtml:ValByName("A_LINK", <destino do link>)
c.	oProcess:cTo := cTo  
d.	oProcess:cSubject:= "Workflow via link."
e.	oProcess:Start()
*/  

