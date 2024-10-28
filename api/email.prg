#Define SMTP0 "mail.compania-sysven.com"
#Define SMTP1 "mail.companysysven.com"
#Define DOMINIO1  "http://companysysven.com/"
#Define DOMINIO2  "http://compania-sysven.com/"
Define Class E_MAIL As Custom
	cAdjuntos		= ""                   && Archivos adjuntos que se enviarán con el e-mail. Deben separarse con punto y coma (;)
	cContrasena		= ""                   && La contraseña de quien envía el e-mail. Requerido.
	cConCopia		= ""                   && Este e-mail se enviará a varios destinatarios, cada uno de ellos ve los e-mails de los demás destinatarios
	cConCopiaOculta	= ""                   && Este e-mail se enviará a varios destinatarios, ninguno de ellos ve los e-mails de los demás destinatarios
	cDestinatario	= ""                   && La dirección de e-mail a donde se envía. Requerido.
	CmensajeError	= ""                   && Mensaje de error si no se pudo enviar el e-mail
	cPaginaHTML		= ""                   && Enlace a una página web (puede ser una página .HTML o solamente una imagen o un vídeo, etc.)
	cRemitente		= ""                   && La dirección de e-mail de quien lo envía. Requerido.
	cSMTPServidor0	= SMTP0                 && El Servidor SMTP que se usará para enviar el e-mail
	cSMTPServidor1	= SMTP1                && El Servidor SMTP que se usará para enviar el e-mail
	cTexto			= ""                   && Texto del e-mail que se enviará. Requerido.
	ctitulo			= ""                   && Título que tendrá el e-mail que se enviará. Requerido.
	lConfirmacion	= .F.                  && Si se quiere recibir confirmación de lectura
	lMostrarAviso	= .T.                  && Si se quiere que dentro de la clase se muestren mensajes de aviso al usuario, o no
	lSMTPAutenticar	= .T.                  && Si se requiere autenticación o no
	lSMTPUsarSSL	= .T.                  && Si se necesita usar SSL. Se puede poner en .F. y This.nSMTPPuerto = 587
	nImportancia	= 1                    && Importancia de este e-mail       :  0 (baja)      , 1 (normal), 2 (alta)
	nPrioridad		= 0                    && Prioridad para enviar este e-mail: -1 (no urgente), 0 (normal), 1 (urgente)
	nSMTPPuerto		= 465                  && Se pueden usar: 465, 587, 25 (en este caso poner: This.lSMTPUsarSSL = .F.)
	nSMTPUsando		= 2                    && 1 = Se enviará usando un directorio. 2 = Se enviará usando un puerto. 3 = Se enviará usando Exchange
	cdominio        = ""                   &&   Dominio
	Function ENVIAR
	Local lcEsquema, loCDO, loMsg, loError, lnI, lcArchivo
	#Define KEY_ENTER Chr(13)
	If !Pemstatus(goapp,'puerto',5) Then
		AddProperty(goapp,'puerto','465')
	Endif
	This.nSMTPPuerto=IIF(Val(goapp.puerto)>0,VAL(goapp.puerto),465)
	If !Pemstatus(goapp,'clavecorreo',5)
		AddProperty(goapp,'clavecorreo','')
	Endif
	If  'companysysven.com' $ This.cRemitente  Then
		This.cdominio='companysysven.com'
	Else
		This.cdominio='compania-sysven.com'
	Endif
	If 'compania-sysven.com' $ This.cRemitente  Then
		If Empty(goapp.clavecorreo)
			cpassword= This.SolicitaContraseña(This.cRemitente)
			goapp.clavecorreo=cpassword
			If Empty(cpassword) Or Left(cpassword,1)='N' Then
				This.CmensajeError='Correo No Encontrado'
				Return (.F.)
			Endif
			This.cContrasena=cpassword
		Else
			This.cContrasena=goapp.clavecorreo
		Endif
	Else
		objcorreo=This.Solicitaemail('cpe')
		If Vartype(objcorreo.correo)='L' Then
			This.CmensajeError='No se Puede Acceder a la URL del Correo '+This.cRemitente
			Return
		Endif

		This.cContrasena=objcorreo.Password
	Endif
	With This
		.VALIDAR()
		If !Empty(.CmensajeError) Then
			Return (.F.)
		Endif
	Endwith
	Try
		lcEsquema = "http://schemas.microsoft.com/cdo/configuration/"
		loCDO	  = Createobject("CDO.Configuration")
		With loCDO.Fields
			If 'companysysven.com' $ This.cRemitente  Then
				.Item(lcEsquema + "smtpserver")		  = This.cSMTPServidor1
			Else
				.Item(lcEsquema + "smtpserver")		  = This.cSMTPServidor0
			Endif
			.Item(lcEsquema + "smtpserverport")	  = This.nSMTPPuerto
			.Item(lcEsquema + "sendusing")		  = This.nSMTPUsando
			.Item(lcEsquema + "smtpauthenticate") = This.lSMTPAutenticar
			.Item(lcEsquema + "smtpusessl")		  = This.lSMTPUsarSSL
			.Item(lcEsquema + "sendusername")	  = This.cRemitente
			.Item(lcEsquema + "sendpassword")	  = This.cContrasena
			.Update()
		Endwith
		loMsg = Createobject("CDO.Message")
		With loMsg
			.Configuration = loCDO
			.From		   = ALLTRIM(This.cRemitente)          && Requerido
			.To			   = ALLTRIM(This.cDestinatario)       && Requerido
			.Cc			   = ALLTRIM(This.cConCopia)           && Los e-mails de los demás destinatarios (si los hubiera), separados con punto y coma
	     	.Bcc		   = ALLTRIM(This.cConCopiaOculta)     && Los e-mails de los demás destinatarios (si los hubiera), separados con punto y coma
			.Subject	   = ALLTRIM(This.ctitulo)             && Requerido
			.TextBody	   = ALLTRIM(This.cTexto)              && Requerido
			
*!*	WAIT WINDOW loMsg.From
*!*	WAIT WINDOW loMsg.To
*!*	WAIT WINDOW loMsg.cc
*!*	WAIT WINDOW loMsg.Bcc	
*!*	WAIT WINDOW This.cSMTPServidor
*--- Si hay archivos adjuntos, se los agrega al e-mail
			If !Empty(This.cAdjuntos) Then
				For lnI = 1 To Alines(aAdjuntos, This.cAdjuntos, 5, ";")     && 5 = remueve espacios y no incluye elementos vacíos en el array
					lcArchivo = aAdjuntos[lnI]
*!*		WAIT WINDOW lcArchivo
					.AddAttachment(lcArchivo)
				Endfor
			Endif
*--- Si se quiere usar HTML, se agrega el contenido HTML
			If !Empty(This.cPaginaHTML) Then
				.CreateMHTMLBody(This.cPaginaHTML, 0)
				.CreateMHTMLBody("file://"+This.cPaginaHTML)
			Endif
*--- Se determina a quien se debe notificar
			If This.lConfirmacion Then
				.Fields("urn:schemas:mailheader:disposition-notification-to") = .From
				.Fields("urn:schemas:mailheader:return-receipt-to")			  = .From
				.Fields.Update()
			Endif
*--- Se coloca la importancia (algunos servidores solamente reconocen la importancia, no la prioridad)
			.Fields.Item("urn:schemas:httpmail:importance")	  = This.nImportancia
			.Fields.Item("urn:schemas:mailheader:importance") = Icase(This.nImportancia = 0, "Low", This.nImportancia = 1, "Normal", "High")
*--- Se coloca la prioridad (algunos servidores solamente reconocen la importancia, no la prioridad)
			.Fields.Item("urn:schemas:httpmail:priority")	= This.nPrioridad
			.Fields.Item("urn:schemas:mailheader:priority")	= This.nPrioridad
*--- Se actualizan la importancia y la prioridad
			.Fields.Update()
*--- Se muestran mensajes al usuario, si se especificó la opción de avisarle
			With This
				If Empty(.cAdjuntos) .And. .lMostrarAviso Then
					mensaje("Enviando  a: " + Alltrim(.cDestinatario))
				Endif
				If !Empty(.cAdjuntos) .And. .lMostrarAviso Then
					mensaje("Enviando el e-mail a: " + Alltrim(.cDestinatario))
				Endif
			Endwith
*--- Los CharSet deben estar inmediatamente antes que el método SEND(). Se usan para mostrar vocales acentuadas y letras eñe
			.BodyPart.Charset	  = "UTF-8"
			.TextBodyPart.Charset = "UTF-8"
			If !Empty(This.cPaginaHTML) Then
				.HTMLBodyPart.Charset = "UTF-8"
			Endif
*--- Se trata de enviar el e-mail
			.Send()
*--- Se le avisa al usuario que el e-mail fue enviado, si se especificó la opción de avisarle
			If This.lMostrarAviso Then
				mensaje("Enviado exitosamente." )
			Endif
		Endwith
	Catch To loError
*--- Ocurrió un error, se guardan en un string los datos del error ocurrido
		This.CmensajeError = "No pudo enviarse el e-mail" + KEY_ENTER ;
			+ "Error Nº: " + Transform(loError.ErrorNo) + KEY_ENTER ;
			+ "Mensaje: " + loError.Message
	Finally
		loCDO = .Null.           && Hay que ponerle .NULL. para que el objeto ya no pueda ser usado
		loMsg = .Null.           && Hay que ponerle .NULL. para que el objeto ya no pueda ser usado
		Release loCDO, loMsg     && Después de usar un objeto hay que liberarlo de la memoria. Y desaparece totalmente.
	Endtry
	Return (Empty(This.CmensajeError))
	Endfunc
*
	Hidden Function VALIDAR

		#Define KEY_ENTER Chr(13)
		With This
			Do Case
			Case Vartype(.cRemitente) <> "C" .Or. !.cdominio  $ .cRemitente
				.CmensajeError = "La cuenta de correo del remitente "+Alltrim(This.cRemitente)+' '+Alltrim(.cdominio) + KEY_ENTER + "debe ser una cuenta de Corporativa"
			Case !"@" $ .cRemitente
				.CmensajeError = "No puedo enviar este e-mail" + KEY_ENTER + "La cuenta de correo del remitente" + KEY_ENTER + "no es válida"
			Case Empty(.cRemitente)
				.CmensajeError = "Necesito conocer cual es la cuenta de correo" + KEY_ENTER + "que está enviando este e-mail"
			Case Vartype(.cDestinatario) <> "C" .Or. !"@" $ .cDestinatario
				.CmensajeError = "No puedo enviar este e-mail" + KEY_ENTER + "La cuenta de correo del destinatario" + KEY_ENTER + "no es válida"
			Case Empty(.cDestinatario)
				.CmensajeError = "Necesito conocer la cuenta de correo" + KEY_ENTER + "a la cual se enviará este e-mail"
			Case Vartype(.cContrasena) <> "C" .Or. Empty(.cContrasena)
				.CmensajeError = "Necesito conocer la contraseña" + KEY_ENTER + "de la cuenta de correo que envía este e-mail"
			Case Vartype(.cTexto) <> "C" .Or. Empty(.cTexto)
				.CmensajeError = "No puedo enviar este e-mail" + KEY_ENTER + "porque no tiene texto"
			Case Vartype(.ctitulo) <> "C" .Or. Empty(.ctitulo)
				.CmensajeError = "No puedo enviar este e-mail" + KEY_ENTER + "porque no tiene Título"
			Case Vartype(.lConfirmacion) <> "L"
				.CmensajeError = "lConfirmacion debe ser .F. o .T."
			Case Vartype(.nImportancia) <> "N" .Or. .nImportancia < 0 .Or. .nImportancia > 2
				.CmensajeError = "La importancia del e-mail es incorrecta" + KEY_ENTER + "Debe ser uno de estos valores: 0, 1, 2"
			Case Vartype(.nPrioridad) <> "N" .Or. .nPrioridad < -1 .Or. .nPrioridad > 1
				.CmensajeError = "La prioridad del e-mail es incorrecta" + KEY_ENTER + "Debe ser uno de estos valores: -1, 0, 1"
			Endcase
		Endwith
		Endfunc

	Function Solicitaemail(cemail)
	URL=DOMINIO1+'dcorreo.php'
	TEXT To cdata Noshow Textmerge
	{
	"nombre":"<<cemail>>"
	}
	ENDTEXT
	oHTTP=Createobject("Microsoft.XMLHTTP")
	oHTTP.Open("post", URL, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	cvalor=""
*!*	    Wait Window URL
	If oHTTP.Status<>200 Then
		This.CmensajeError="Servicio "+Trim(URL)+" NO Disponible "+Alltrim(Str(oHTTP.Status))
		Return cvalor
	Endif

	lcHTML = oHTTP.responseText
	Set Procedure To  d:\librerias\json Additive
	ovalor = json_decode(lcHTML)
	If Not Empty(json_getErrorMsg())
		This.CmensajeError="No se Pudo Obtener la Información desde la WEB "+URL+' '+json_getErrorMsg()
		Return cvalor
	Endif
	objcorreo=Createobject("empty")
	If !Pemstatus(goapp,'clavecorreo',5)
		AddProperty(goapp,'clavecorreo','')
	Endif
	If Len(Alltrim(ovalor.Get('correo')))>0 Then
		AddProperty(objcorreo,'correo',ovalor.Get('correo'))
		AddProperty(objcorreo,'password',ovalor.Get('password'))
		goapp.clavecorreo=ovalor.Get('password')
	Endif
	Return objcorreo
	Endfunc
*********************************
	Function SolicitaContraseña(cemail)
	URL=DOMINIO2+'i.php'
	TEXT To cdata Noshow Textmerge
	{
	"correo":"<<cemail>>"
	}
	ENDTEXT
	oHTTP=Createobject("Microsoft.XMLHTTP")
	oHTTP.Open("post", URL, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	cvalor=""
*Wait Window URL
	If oHTTP.Status<>200 Then
		This.CmensajeError="Servicio WEB "+URL +" NO Disponible."+Alltrim(Str(oHTTP.Status))
		Return cvalor
	Endif

	lcHTML = oHTTP.responseText
	Set Procedure To  d:\librerias\json Additive
	ovalor = json_decode(lcHTML)
	If Not Empty(json_getErrorMsg())
		This.CmensajeError="No se Pudo Obtener la Información desde la WEB "+URL+' '+json_getErrorMsg()
		Return cvalor
	Endif
	If Len(Alltrim(ovalor.Get('id')))>0 Then
		cvalor=Alltrim(ovalor.Get('id'))
	Endif
	Return cvalor
	Endfunc
Enddefine
