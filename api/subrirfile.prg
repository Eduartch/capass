Define Class subirftp As Custom
	cdirectory=""
	cfileftp=""
	cfilelocal=""
	cmensaje=""
	Function enviartaly()
	Set Procedure To d:\capass\api\ftp_class Additive
	loFTP = Createobject("CLASE_FTP")
	With loFTP
*!*			.cServidorFTP   = "ftp.companysysven.com"
*!*			.cNombreUsuario = "syscom"
*!*			.cContrasena    = "f2pwO0lao1D9"
*!*				.cServidorFTP   = "ftp.companiasysven.com"
*!*				.cNombreUsuario = "sysven"
*!*				.cContrasena    = "gkMLjR0HJ09I"
*!*				.cPuertoNro     = "21"
		.cServidorFTP   = "ftp.comercialnieto.com"
		.cNombreUsuario = "comerci5"
		.cContrasena    = "h5cTzK8v06"
		lcCarpetaFTP="public_html/admin/img/producto/"+Alltrim(This.cdirectory)
		.CONECTAR_SERVIDOR_FTP()
		If Empty(.cMensajeError) Then
			.CREAR_CARPETA_REMOTA(lcCarpetaFTP)
			If Empty(.cMensajeError) Then
				lcNombreArchivoFTP = lcCarpetaFTP+"/" + Alltrim(This.cfileftp)
				lcNombreTXT=This.cfilelocal
				.ENVIAR_ARCHIVO_AL_SERVIDOR_FTP(lcNombreTXT, lcNombreArchivoFTP)
				.DESCONECTAR_SERVIDOR_FTP()
				Return 1
			Else
				This.cmensaje=.cMensajeError
				Return 0
			Endif
		Else
			This.cmensaje="No me pude conectar al Servidor FTP"
			Return 0
		Endif
	Endwith
	Endfunc
	Function enviaracttaly()
	Set Procedure To d:\capass\api\ftp_class Additive
	loFTP = Createobject("CLASE_FTP")
	With loFTP
		.cServidorFTP   = "ftp.comercialnieto.com"
		.cNombreUsuario = "comerci5"
		.cContrasena    = "h5cTzK8v06"
		lcCarpetaFTP="public_html/admin/img/producto/"+Alltrim(This.cdirectory)
		lcNombreArchivoFTP = lcCarpetaFTP+"/" + Alltrim(This.cfileftp)
		.CONECTAR_SERVIDOR_FTP()
		If Empty(.cMensajeError) Then
			If .EXISTE_EL_ARCHIVO_EN_EL_SERVIDOR_FTP(lcNombreArchivoFTP) Then
				.BORRAR_ARCHIVO_REMOTO(lcNombreArchivoFTP)
			Endif
*!*					If !Empty(.cMensajeError)
*!*						This.cmensaje=  .cMensajeError
*!*					Endif
			.BORRAR_CARPETA_REMOTA(lcCarpetaFTP)
			.cMensajeError=""
			.CREAR_CARPETA_REMOTA(lcCarpetaFTP)
*!*				Endif
			If Empty(.cMensajeError) Then
				lcNombreTXT=This.cfilelocal
				.ENVIAR_ARCHIVO_AL_SERVIDOR_FTP(lcNombreTXT, lcNombreArchivoFTP)
				.DESCONECTAR_SERVIDOR_FTP()
				Return 1
			Else
				This.cmensaje=.cMensajeError
				Return 0
			Endif
		Else
			This.cmensaje="No me pude conectar al Servidor FTP"
			Return 0
		Endif
	Endwith
	Endfunc
Enddefine
