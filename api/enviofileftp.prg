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
	ccopia = ""
	urlenvio = "https://www.companiasysven.com/app88/envemail.php"
	urlenvio1 = "https://www.companiasysven.com/app88/envemail1.php"
	urlenviosoporte = "https://www.companiasysven.com/app88/enviarmailsoporte.php"
	Dimension cfiles[3]
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
	cFile = Addbs(Sys(5) + Sys(2003)) + "ftp.exe"
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
	cad = Addbs(Sys(5) + Sys(2003)) + "ftp.exe"
	concopia = Iif(!Empty(fe_gene.correo), Alltrim(fe_gene.correo), '')
	If This.unsolofile = 1 Then
		Cexe =  cad + ' ' + '1' + ' ' + This.cFile
		cFile = Justfname(This.cFile)
		cmensajeenvio = This.mensajeenvio
		casunto = This.asunto
		unsolofile = 'S'
		Text To cdata Noshow Textmerge
			{
			"emailcliente":"<<this.emailcliente>>",
			"ccopia":"<<concopia>>",
			"cfile":"<<cfile>>",
			"cmensaje":"<<cmensajeenvio>>",
			"unsolofile":"<<unsolofile>>",
		    "asunto":"<<casunto>>",
		    "ccopia":"<<concopia>>"
			}
		Endtext
	Else
		Cexe = cad + ' ' + '0' + ' ' + cpara + ' ' + This.fpdf + ' ' + This.fxml + ' ' + Iif( sincdr = 0, '0', This.fcdr)
		Cserie = Left(This.cndoc, 4)
		cnumero = Substr(This.cndoc, 5)
		cfecha = Dtoc(This.dFecha)
		cfilexml = Justfname(This.fxml)
		cfilepdf = Justfname(This.fpdf)
		cfilecdr = Justfname(This.fcdr)
		unsolofile = 'N'
		Text To cdata Noshow Textmerge
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
		Endtext
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
	Function enviar()
	If This.validaremail() < 1 Then
		This.Cmensaje = 'Correo Electrónico no Válido'
		Return 0
	Endif
	cfilename1 = ""
	cconfile1 = ""
	cfilename2 = ""
	cconfile2 = ""
	cfilename3 = ""
	cconfile3 = ""
	If File(This.cfiles[1])
		cfilename1 = Alltrim(Justfname(This.cfiles[1]))
		ls_contentfile = Filetostr(This.cfiles[1])
		cconfile1	   = Strconv(ls_contentfile, 13)
	Endif
	If File(This.cfiles[2])
		cfilename2 = Alltrim(Justfname(This.cfiles[2]))
		ls_contentfile = Filetostr(This.cfiles[2])
		cconfile2	   = Strconv(ls_contentfile, 13)
	Endif
	If File(This.cfiles[3])
		cfilename3 = Alltrim(Justfname(This.cfiles[3]))
		ls_contentfile = Filetostr(This.cfiles[3])
		cconfile3	   = Strconv(ls_contentfile, 13)
	Endif
	Text To cdata Noshow Textmerge
			{
		    "emailcliente": "<<this.emailcliente>>",
		     "asunto": "<<this.asunto>>",
             "descripcion": "<<this.Cmensaje>>",
             "ccopia": "<<this.ccopia>>",
             "archivos": [
	          {
			"nombrearchivo":"<<Alltrim(Justfname(cfilename1))>>",
			"base64":"<<cconfile1>>"
		          },
		            {
			"nombrearchivo":"<<Alltrim(Justfname(cfilename2))>>",
			"base64":"<<cconfile2>>"
		          },
		            {
			"nombrearchivo":"<<Alltrim(Justfname(cfilename3))>>",
			"base64":"<<cconfile3>>"
		          }
              ]
	       }
	Endtext
	Strtofile(cdata, Addbs(Sys(5) + Sys(2003)) + 'email.json')
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", This.urlenvio1, .F.)
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
		If orpta.rpta = '1' Then
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
	Function validaremail()
	Local loRegExp As "VBScript.RegExp"
	email = This.emailcliente
	If Vartype(email) # "C"
		vd = 0
	Else
		loRegExp			= Createobject("VBScript.RegExp")
		loRegExp.IgnoreCase	= .T.
		loRegExp.Pattern	=  '^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)­*)\.([A-Za-z]{2,})$'
		m.valid				= loRegExp.Test(Alltrim(m.email))
		Release loRegExp
		vd = Iif(m.valid, 1, 0)
	Endif
	Do Case
	Case vd > 0
		ncolor = Rgb(128, 255, 128)
	Otherwise
		ncolor = Rgb(234, 234, 234)
	Endcase
	Return vd
	Endfunc
	Function enviarasoporte()
	Text To cdata Noshow Textmerge
			{
		     "emailcliente": "<<this.emailcliente>>",
		     "asunto": "<<this.asunto>>",
             "descripcion": "<<this.Cmensaje>>"
            }
	Endtext
	Strtofile(cdata, Addbs(Sys(5) + Sys(2003)) + 'email.json')
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", This.urlenviosoporte, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	If oHTTP.Status <> 200 Then
		This.Cmensaje = "Servicio " + Alltrim(This.urlenviosoporte) + ' NO Disponible' + Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	lcHTML = oHTTP.responseText
	Set Procedure To d:\Librerias\nfJsonRead.prg Additive
	orpta = nfJsonRead(lcHTML)
	If  Vartype(orpta.rpta) <> 'U' Then
		This.Cmensaje = orpta.rpta
		If orpta.rpta = '1' Then
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




































