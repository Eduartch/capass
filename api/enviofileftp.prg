Define Class envioftpcorreo As Custom
	fxml = ""
	fcdr = ""
	fpdf = ""
	Cmensaje = ""
	nruc = ""
	cndoc = ""
	ctipodcto = ""
	cempresa = ""
	cFile = ""
	dFecha = Date()
	emailcliente = ""
	unsolofile = 0
	mensajeenvio = ""
	asunto = ""
	ccopia=""
	urlenvio = "http://companysysven.com/app88/envemail.php"
	Function subiryenviarcorreo()
	If This.unsolofile = 1 Then
		If !File(This.cFile) Then
			This.Cmensaje = "NO existe el Arhivo " + Alltrim(This.cFile)
			Return 0
		Endif
	Else
		If !File(This.fxml) Then
			This.Cmensaje = "NO existe el Arhivo XML " + Alltrim(This.fxml)
			Return 0
		Endif
		If !File(This.fpdf) Then
			This.Cmensaje = "NO existe el Arhivo PDF " + Alltrim(This.fpdf)
			Return 0
		Endif
		sincdr = 1
		If !File(This.fcdr) Then
			sincdr = 0
		Endif
	Endif
	cFile = Sys(5) + Sys(2003) + "\ftp.exe"
	If !File(cFile) Then
		This.Cmensaje = "NO existe el Arhivo de envio"
		Return 0
	Endif
	If Type("oempresa") = 'U' Then
		cpara = 'N'
	Else
		cpara = 'S'
	Endif
	oWSH = Createobject("WScript.Shell")
	cad = Sys(5) + Sys(2003) + "\ftp.exe"
	concopia=Iif(!Empty(fe_gene.correo),Alltrim(fe_gene.correo),'')
	If This.unsolofile = 1 Then
		Cexe =  cad + ' ' + '1' + ' ' + This.cFile
		cFile = Justfname(This.cFile)
		cmensajeenvio = This.mensajeenvio
		casunto = This.asunto
		unsolofile = 'S'

		TEXT To cdata Noshow Textmerge
			{
			"emailcliente":"<<this.emailcliente>>",
			"ccopia":"<<concopia>>",
			"cfile":"<<cfile>>",
			"cmensaje":"<<cmensajeenvio>>",
			"unsolofile":"<<unsolofile>>",
		    "asunto":"<<casunto>>",
		    "ccopia":"<<concopia>>"
			}
		ENDTEXT
	Else
		Cexe = cad + ' ' + '0' + ' ' + cpara + ' ' + This.fpdf + ' ' + This.fxml + ' ' + Iif( sincdr = 0, '0', This.fcdr)
		Cserie = Left(This.cndoc, 4)
		cnumero = Substr(This.cndoc, 5)
		cfecha = Dtoc(This.dFecha)
		cfilexml = Justfname(This.fxml)
		cfilepdf = Justfname(This.fpdf)
		cfilecdr = Justfname(This.fcdr)
		unsolofile = 'N'
		TEXT To cdata Noshow Textmerge
			{
			"ruc":"<<this.nruc>>",
			"empresa":"<<this.cempresa>>",
			"serie":"<<cserie>>",
			"numero":"<<cnumero>>",
			"fecha":"<<cfecha>>",
			"emailcliente":"<<this.emailcliente>>",
			"ccopia":"<<concopia>>",
			"xml":"<<cfilexml>>",
			"pdf":"<<cfilepdf>>",
			"cdr":"<<cfilecdr>>"
			}
		ENDTEXT
	Endif
*!*		wait WINDOW cexe
	oWSH.Run(Cexe, 0, .T.)
	Mensaje("enviando Archivos Adjuntos")
	Strtofile(cdata, Addbs(Sys(5) + Sys(2003)) + 'envio.json')
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", This.urlenvio, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	If oHTTP.Status <> 200 Then
		This.Cmensaje = "Servicio " + Alltrim(This.urlenvio) + ' NO Disponible' + Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	lcHTML = oHTTP.responseText
	Set Procedure To d:\Librerias\nfJsonRead.prg Additive
	orpta = nfJsonRead(lcHTML)
	If  Vartype(orpta.rpta) <> 'U' Then
		This.Cmensaje = orpta.rpta
		If orpta.rpta = '0' Then
			This.Cmensaje = orpta.Mensaje
			Return 1
		Else
			This.Cmensaje = orpta.Mensaje
			Return 0
		Endif
	Else
		This.Cmensaje = Alltrim(lcHTML)
		Return 0
	Endif
	Endfunc
Enddefine
























