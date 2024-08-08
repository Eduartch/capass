CLEAR ALL
CLOSE ALL

tcRuc='10167263734'
lcUrl=Textmerge("http://compania-sysven.com/consulta5.php?cruc=<<tcRuc>>")
loXmlHttp = Createobject("Microsoft.XMLHTTP")
loXmlHttp.Open('GET', lcUrl, .F.)
loXmlHttp.Send()
If loXmlHttp.Status<>200 Then
	Messagebox("Servicio WEB NO Disponible....."+Alltrim(Str(loXmlHttp.Status)),16,MSGTITULO)
	Return
Endif
*oResult = Json.Parse(loXMLHttp.ResponseText)
lcHTML = loXmlHttp.Responsetext

*   MESSAGEBOX(lcHTML)


*lcHTML = STRCONV(lcHTML,10)
* Messagebox(lcHTML)
*lcHTML=UCES2Chr(lcHTML)

*lcHTML = CHRTRAN( lcHTML, "áéíóú", "aeiou" )



*!*	Set Procedure To  d:\librerias\json Additive

*!*	ocontrib = json_decode(lcHTML)
*!*	If Not Empty(json_getErrorMsg())
*!*		Messagebox("No se Pudo Obtener la Información "+json_getErrorMsg(),16,MSGTITULO)
*!*		Return
*!*	Endif

Set Procedure  To d:\librerias\nfJsonRead.prg Additive
ocontrib = nfJsonRead(lcHTML)
cdire=""
cciud=""
*Iif(Vartype(oJson.Array(1).Tipoconexion) = 'U', 'L', oJson.Array(1).Tipoconexion)
If  VARTYPE(ocontrib.nombre_o_razon_social)<>'U' then

	crazo=Alltrim(ocontrib.nombre_o_razon_social)
	cubigeo=alltrim(ocontrib.ubigeo)
	If Left(tcRuc,1)<>'1' Then
		cdire=Alltrim(ocontrib.DIRECCION)
		cciud=Alltrim(ocontrib.DISTRITO)+' '+Alltrim(ocontrib.PROVINCIA)+' '+Alltrim(ocontrib.DEPARTAMENTO)
	
	ENDIF
	?crazo
	?cdire
	?cciud
	?cubigeo
*!*		If Alltrim(ocontrib.array(1).estado_del_contribuyente)<> "ACTIVO" Then
*!*			cmensaje="El Estado del Contribuyente es  "+Alltrim(ocontrib.array(1).estado_del_contribuyente)
*!*			Do Form ka_mensaje With cmensaje
*!*		Endif
*!*		If Alltrim(ocontrib.array(1).condicion_de_domicilio)<>"HABIDO"
*!*			cmensaje="El Domicilio del Contribuyente es  "+Alltrim(ocontrib.array(1).condicion_de_domicilio)
*!*			Do Form ka_mensaje With cmensaje
*!*		Endif
Endif

*Catch To oerror
*	Messagebox("No Se Pudo Obtener la Infornación Solicitado... Intente Nuevamente",16,MSGTITULO)
*Endtry
*Return (loResult)





*!*	Set Safety Off
*!*	Local XRUC As String
*!*	XRUC = "20480529244"

*!*	#Define CRLF Chr(13)+Chr(10)
*!*	Local oErr As Exception
*!*	Local cStr As Character
*!*	Local SW As Boolean
*!*	SW = .T.
*!*	Try
*!*	Local loXmlHttp As Microsoft.XMLHTTP,;
*!*		lcURL As String,;
*!*		lcHTML As String,;
*!*		lcTexto As String,;
*!*		lcFile As String

*!*	loXmlHttp = Createobject("Microsoft.XMLHTTP")

*!*	lcURL = "http://www.sunat.gob.pe/w/wapS01Alias?ruc="+XRUC
*!*	*lcURL = "http://www.sunat.gob.pe/cl-ti-itmrconsruc/jcrS00Alias?ruc="+XRUC
*!*	loXmlHttp.Open("POST" , lcURL, .F.)
*!*	loXmlHttp.Send

*!*	Wait Window "Espere por favor, obteniendo datos..." Nowait
*!*	Do While loXmlHttp.readyState<>4 Or loXmlHttp.Status <>200
*!*	Enddo

*!*	lcHTML = loXmlHttp.Responsetext
*!*	lcTexto = Chrtran(Alltrim(lcHTML),Chr(10),"")
*!*	MESSAGEBOX(lctexto,16,'aca')
*!*	*/Para los delimitadores
*!*	lcTexto  = Strtran(lcTexto, "N&#xFA;mero Ruc. </b> " + XRUC + " - ","RazonSocial:")
*!*	lcTexto  = Strtran(lcTexto, "Estado.</b>","Estado:")
*!*	lcTexto  = Strtran(lcTexto, "Agente Retenci&#xF3;n IGV.</strong>","ARIGV:")
*!*	lcTexto  = Strtran(lcTexto, "Direcci&#xF3;n.</b><br/>","Direccion:")
*!*	lcTexto  = Strtran(lcTexto, "Situaci&#xF3;n.<b> ","Situacion:")
*!*	lcTexto  = Strtran(lcTexto, "Tel&#xE9;fono(s).</b><br/>","Telefono:")
*!*	lcTexto  = Strtran(lcTexto, "Dependencia.","Dependencia:")
*!*	lcTexto  = Strtran(lcTexto, "Tipo.</b><br/> ","TipoPer:")
*!*	lcTexto  = Strtran(lcTexto, "DNI</b> : ","DNI:")
*!*	lcTexto  = Strtran(lcTexto, "Fecha Nacimiento.</b> ","FechNac:")
*!*	lcTexto  = Strtran(lcTexto, Space(05),Space(01))
*!*	lcTexto  = Strtran(lcTexto, Space(04),Space(01))
*!*	lcTexto  = Strtran(lcTexto, Space(03),Space(01))
*!*	lcTexto  = Strtran(lcTexto, Space(02),Space(01))
*!*	lcTexto  = Strtran(lcTexto, Chr(09),"")

*!*	*** RAZON SOCIAL ***
*!*	PosIni = At("RazonSocial:", lcTexto)+12
*!*	PosFin = At("<br/></small>", lcTexto)-(At("RazonSocial:", lcTexto)+12)
*!*	xRazSocial = Substr(lcTexto,PosIni,PosFin)

*!*	xRazSocial  = Strtran(xRazSocial,"&#209;","Ñ")
*!*	xRazSocial  = Strtran(xRazSocial , "&#xD1;", "Ñ")
*!*	xRazSocial  = Strtran(xRazSocial , "&#193;", "Á")
*!*	xRazSocial  = Strtran(xRazSocial , "&#201;", "É")
*!*	xRazSocial  = Strtran(xRazSocial , "&#205;", "Í")
*!*	xRazSocial  = Strtran(xRazSocial , "&#211;", "Ó")
*!*	xRazSocial  = Strtran(xRazSocial , "&#218;", "Ú")
*!*	xRazSocial  = Strtran(xRazSocial , "&#xC1;", "Á")
*!*	xRazSocial  = Strtran(xRazSocial , "&#xC9;", "É")
*!*	xRazSocial  = Strtran(xRazSocial , "&#xCD;", "Í")
*!*	xRazSocial  = Strtran(xRazSocial , "&#xD3;", "Ó")
*!*	xRazSocial  = Strtran(xRazSocial , "&#xDA;", "Ú")

*!*	lcFile= "Datos_Contribuyente.txt"
*!*	Strtofile(xRazSocial+Chr(13)+Chr(10), lcFile)

*!*	*** ESTADO ***
*!*	PosIni = At("Estado:", lcTexto)+7
*!*	PosFin = (At("ARIGV", lcTexto)-32)-(At("Estado:", lcTexto)+7)
*!*	xEst = Substr(lcTexto,PosIni,PosFin)

*!*	Strtofile(xEst+Chr(13)+Chr(10) , lcFile,1)

*!*	*** AGENTE RETENEDOR IGV ***
*!*	PosIni = At("ARIGV:", lcTexto)+18
*!*	PosFin = At("ARIGV:", lcTexto)+20-(At("ARIGV:", lcTexto)+18)
*!*	xAR = Substr(lcTexto,PosIni,PosFin)

*!*	Strtofile(xAR+Chr(13)+Chr(10), lcFile,1)

*!*	*** DIRECCION ***
*!*	PosIni = At("Direccion:", lcTexto)+10
*!*	PosFin = At("</b></small><br/>", lcTexto)-38-(At("Direccion:",lcTexto)+10)
*!*	xDir = Substr(lcTexto,PosIni,PosFin)

*!*	xDir = Strtran(xDir, "&#209;", "Ñ")
*!*	xDir = Strtran(xDir, "&#xD1;", "Ñ")
*!*	xDir = Strtran(xDir, "&#193;", "Á")
*!*	xDir = Strtran(xDir, "&#201;", "É")
*!*	xDir = Strtran(xDir, "&#205;", "Í")
*!*	xDir = Strtran(xDir, "&#211;", "Ó")
*!*	xDir = Strtran(xDir, "&#218;", "Ú")
*!*	xDir = Strtran(xDir, "&#xC1;", "Á")
*!*	xDir = Strtran(xDir, "&#xC9;", "É")
*!*	xDir = Strtran(xDir, "&#xCD;", "Í")
*!*	xDir = Strtran(xDir, "&#xD3;", "Ó")
*!*	xDir = Strtran(xDir, "&#xDA;", "Ú")
*!*	Strtofile(xDir+Chr(13)+Chr(10), lcFile,1)

*!*	*** SITUACION ***
*!*	PosIni = At("Situacion:", lcTexto)+10
*!*	PosFin = At("</b></small><br/>", lcTexto)-(At("Situacion:", lcTexto)+10)
*!*	xCond = Substr(lcTexto,PosIni,PosFin)
*!*	Strtofile(xCond+Chr(13)+Chr(10), lcFile,1)

*!*	*** TELEFONO ***
*!*	PosIni = At("Telefono:", lcTexto)+9
*!*	PosFin = At("Dependencia:", lcTexto)-25-(At("Telefono:", lcTexto)+9)
*!*	xTelef = Substr(lcTexto,PosIni,PosFin)
*!*	Strtofile(xTelef+Chr(13)+Chr(10), lcFile,1)

*!*	*** TIPO DE PERSONA ***
*!*	PosIni = At("TipoPer:", lcTexto)+8
*!*	PosFin = At("DNI:", lcTexto)-29-(At("TipoPer:", lcTexto)+8)
*!*	xTipoPer = Substr(lcTexto,PosIni,PosFin)
*!*	Strtofile(xTipoPer+Chr(13)+Chr(10), lcFile,1)

*!*	*** DNI ***
*!*	PosIni = At("DNI:", lcTexto)+4
*!*	PosFin = At("FechNac:", lcTexto)-25-(At("DNI:", lcTexto)+4)
*!*	xDNI = Substr(lcTexto,PosIni,PosFin)
*!*	Strtofile(xDNI+Chr(13)+Chr(10), lcFile,1)

*!*	*** FECHA DE NACIMIENTO ***
*!*	PosIni = At("FechNac:", lcTexto)+8
*!*	PosFin = At("FechNac:", lcTexto)+18-(At("FechNac:", lcTexto)+8)
*!*	xFechNac = Substr(lcTexto,PosIni,PosFin)
*!*	Strtofile(xFechNac, lcFile,1)


*!*	Modify File (lcFile)

*!*	Release loXmlHttp

*!*	Catch To oErr
*!*	cStr = "Error:" + CRLF + CRLF + ;
*!*		"[  Error: ] " + Str(oErr.ErrorNo) + CRLF + ;
*!*		"[  Linea: ] " + Str(oErr.Lineno) + CRLF + ;
*!*		"[  Mensaje: ] " + oErr.Message + CRLF + ;
*!*		"[  Procedimiento: ] " + oErr.Procedure + CRLF + ;
*!*		"[  Detalles: ] " + oErr.Details + CRLF + ;
*!*		"[  StackLevel: ] " + Str(oErr.StackLevel) + CRLF + ;
*!*		"[  Instrucción: ] " + oErr.LineContents
*!*	Messagebox(cStr,4112,"Error...!!!")
*!*	SW = .F.
*!*	Endtry

*!*	If SW = .F.
*!*	Return .F.
*!*	Endif

*!*	Return
