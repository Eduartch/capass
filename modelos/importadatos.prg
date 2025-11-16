Define Class importadatos As OData Of 'd:\capass\database\data'
	Ruc = ""
	dni = ""
	Url = 'http://companiasysven.com'
	Urlimgcompras = 'https://companysysven.com/app88/sendgemini.php'
	Function consultardata(Ccursor)
	TEXT To lC Noshow Textmerge
    select fech,CAST(valor as decimal(5,3)) as valor,CAST(venta as decimal(5,3)) as venta,idmon FROM fe_mon ORDER BY fech
	ENDTEXT
	If This.EJECutaconsulta(Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function importaruc()
*Try
	Local ocliente
	ocliente = Createobject("custom")
	ocliente.AddProperty("ruc", "")
	ocliente.AddProperty("razon", "")
	ocliente.AddProperty("direccion", "")
	ocliente.AddProperty("ciudad", "")
	ocliente.AddProperty("ubigeo", "")
	ocliente.AddProperty("mensaje", "")
	ocliente.AddProperty("valor", 0)
	ocliente.AddProperty("estado", "")
	ocliente.AddProperty("domicilio", 0)
	If Len(Alltrim(This.Ruc)) <> 11 Then
		ocliente.Mensaje = "El RUC es Obligatorio"
		ocliente.valor = 0
		Return ocliente
	Endif
	tcruc = This.Ruc
	lcToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImVkdWFydGNoQGhvdG1haWwuY29tIn0.ETKCW24wdZCkcfkPupEJTZyrN_-6ntS68MA2ZF9zyxI"
	lcURL = Textmerge(This.Url + "/consulta5.php?cruc=<<tcruc>>")
	loXmlHttp = Createobject("Microsoft.XMLHTTP")
	loXmlHttp.Open('GET', lcURL, .F.)
	loXmlHttp.Send()
	If loXmlHttp.Status <> 200 Then
		ocliente.Mensaje = "Servicio WEB NO Disponible....." + Alltrim(Str(loXmlHttp.Status))
		ocliente.valor = 0
		Return ocliente
	Endif
	This.Cmensaje = ""
	lcHTML = loXmlHttp.responseText
*MESSAGEBOX(lcHTML)
	Set Procedure  To d:\Librerias\nfJsonRead.prg Additive
	ocontrib = nfJsonRead(lcHTML)
	If  Vartype(ocontrib.nombre_o_razon_social) <> 'U' Then
		ocliente.Ruc = This.Ruc
		ocliente.razon = Alltrim(ocontrib.nombre_o_razon_social)
		ocliente.estado = Alltrim(ocontrib.estado_del_contribuyente)
		ocliente.domicilio = Alltrim(ocontrib.condicion_de_domicilio)
		If Left(This.Ruc, 1) <> '1' Then
			ocliente.Direccion = Alltrim(ocontrib.Direccion)
			ocliente.ciudad = Alltrim(ocontrib.DISTRITO) + ' ' + Alltrim(ocontrib.PROVINCIA) + ' ' + Alltrim(ocontrib.DEPARTAMENTO)
			ocliente.Ubigeo = Alltrim(ocontrib.Ubigeo)
		Else
			ocliente.Direccion = ""
			ocliente.ciudad = ""
		Endif
		If Alltrim(ocontrib.estado_del_contribuyente) <> "ACTIVO" Then
			Cmensaje = "El Estado del Contribuyente es  " + Alltrim(ocontrib.estado_del_contribuyente)
			ocliente.Mensaje = Cmensaje
		Endif
		If Alltrim(ocontrib.condicion_de_domicilio) <> "HABIDO"
			Cmensaje = "El Domicilio del Contribuyente es  " + Alltrim(ocontrib.condicion_de_domicilio)
			ocliente.Mensaje = Cmensaje
		Endif
		ocliente.valor = 1
		Return ocliente
	Else
		ocliente.Mensaje = "No se puede Obtener Información"
		ocliente.valor = 0
		Return ocliente
	Endif
	Endfunc
	Function importardni
	Local ocliente
	ocliente = Createobject("custom")
	ocliente.AddProperty("razon", "")
	ocliente.AddProperty("mensaje", "")
	ocliente.AddProperty("valor", 0)
	lcURL = Textmerge(This.Url + '/consulta5.php?cruc=<<cdni>>')
	loXmlHttp = Createobject("Microsoft.XMLHTTP")
	loXmlHttp.Open('GET', lcURL, .F.)
	loXmlHttp.Send()
	If loXmlHttp.Status <> 200 Then
		ocliente.Mensaje = "Servicio NO Disponible " + Alltrim(Str(loXmlHttp.Status))
		ocliente.valor = 0
		Return ocliente
	Endif
	lcHTML = loXmlHttp.responseText
	Set Procedure  To d:\Librerias\nfJsonRead.prg Additive
	opersona = nfJsonRead(lcHTML)
	If  Vartype(opersona.nombre) <> 'U' Then
		ocliente.razon = Alltrim(opersona.nombre)
		ocliente.valor = 1
		Return ocliente
	Else
		ocliente.Mensaje = "No se puede Obtener Información"
		ocliente.valor = 0
		Return ocliente
	Endif
	Endfunc
	Function ubigeos
	lcURL = Textmerge(This.Url + "/ubigeos.php")
	loXmlHttp = Createobject("Microsoft.XMLHTTP")
	loXmlHttp.Open('GET', lcURL, .F.)
	loXmlHttp.setRequestHeader("Content-Type", "application/json")
	loXmlHttp.Send()
	If loXmlHttp.Status <> 200 Then
		This.Cmensaje = "Servicio WEB NO Disponible....." + Alltrim(Str(loXmlHttp.Status))
		Return 0
	Endif
	lcHTML = loXmlHttp.responseText
	Create Cursor Ubigeo(Ubigeo c(8), DISTRITO c(70), PROVINCIA c(80), DEPARTAMENTO c(50), clave c(150))
	Set Procedure  To d:\Librerias\nfJsonRead.prg Additive
	ubigeos = nfJsonRead(lcHTML)
	For Each oub In ubigeos.Array
		Insert Into Ubigeo(Ubigeo, DISTRITO, PROVINCIA, DEPARTAMENTO, clave)Values(oub.Ubigeo, oub.DISTRITO, oub.PROVINCIA, oub.DEPARTAMENTO, Upper(Trim(oub.DISTRITO) + ' ' + Trim(oub.PROVINCIA) + ' ' + Trim(oub.DEPARTAMENTO)))
	Endfor
	Return 1
	Endfunc
	Function ImportaTCSunat(nmes, nanio)
	Local loXmlHttp As "Microsoft.XMLHTTP"
	Local lcHTML, lcURL, ls_compra, ls_venta
	Mensaje("Consultando Tipo de Cambio desde sunat.gob.pe")
	Set Procedure To d:\Librerias\json Additive
	nm	  = Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes)))
	Na	  = Alltrim(Str(nanio))
	lcURL = Textmerge(This.Url + "/tc.php")
	fi	  = Na + '-' + nm + '-01'
	dfecha2	= Dtos(Ctod('01/' + Trim(Str(Iif(nmes < 12, nmes + 1, 1))) + '/' + Trim(Str(Iif(nmes < 12, nanio, nanio + 1)))))
	ff		= Left(dfecha2, 4) + '-' + Substr(dfecha2, 5, 2) + '-' + Right(dfecha2, 2)

	loXmlHttp = Createobject("Microsoft.XMLHTTP")
	TEXT To cdata Noshow Textmerge
	{
	"dfi":"<<fi>>",
	"dff":"<<ff>>"
	}
	ENDTEXT
	loXmlHttp.Open('POST', lcURL, .F.)
	loXmlHttp.setRequestHeader("Content-Type", "application/json")
	loXmlHttp.Send(cdata)
	If loXmlHttp.Status <> 200 Then
		This.Cmensaje = "Servicio WEB NO Disponible....." + Alltrim(Str(loXmlHttp.Status))
		Return 0
	Endif
	lcHTML = Chrtran(loXmlHttp.responseText, '-', '')
	If 	(Atc("precio_compra", lcHTML) > 0) && si tiene la palabra compra es válido
		Create Cursor CurTCambio(DIA N(2), TC_COMPRA N(5, 3), TC_VENTA N(5, 3))
		otc = json_decode(lcHTML)
		If Not Empty(json_getErrorMsg())
			This.Cmensaje = "No se Pudo Obtener la Información " + json_getErrorMsg()
			Return 0
		Endif
		x = 0
		For i = 1 To otc._Data.getSize()
			x	   = x + 1
			ovalor = otc._Data.Get(x)
			If (Vartype(ovalor) = 'O') Then
				Fecha	  = ovalor.Get("fecha")
				ls_compra = ovalor.Get("precio_compra")
				ls_venta  = ovalor.Get('precio_venta')
				d		  = Val(Right(Fecha, 2))
				Insert Into CurTCambio(DIA, TC_COMPRA, TC_VENTA)Values(d, Val(ls_compra), Val(ls_venta))
			Endif
		Next
		This.Cmensaje = ''
		Return 1
	Else
		This.Cmensaje = 'No se encontro información para Tipo de Cambio'
		Return 0
	Endif
	Endfunc
	Function DtipoCambio(Df, ct)
	lC = 'Fundtipocambio'
	goApp.npara1 = Df
	goApp.npara2 = ct
	TEXT To lp Noshow
	    (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	m.ntc = This.EJECUTARf(lC, lp, 'lmone')
	If m.ntc < 1 Then
		If This.conerror = 1 Then
			Return 0
		Endif
	Endif
	If m.ntc > 0 Then
		Return m.ntc
	Else
		If Used("fe_gene") Then
			Return fe_gene.dola
		Else
			Return 0
		Endif
	Endif
	Endfunc
	Function ActualizaTipoCambioSunat(nm, Na)
	Local Sw As Integer
	tcc	= 0
	tcv	= 0
	Sw	= 1
	Df	= Ctod("01/" + Alltrim(Str(nm)) + "/" + Alltrim(Str(Na))) - 1
	F	= Cfechas(Df)
	TEXT To lC Noshow Textmerge
    select valor,venta FROM fe_mon WHERE fech='<<f>>'
	ENDTEXT
	If This.EJECutaconsulta(lC, 'tca') < 1 Then
		Return  0
	Endif
	attca = tca.valor
	attcv = tca.Venta
	TEXT To lC Noshow Textmerge
        select  fech,valor,venta,idmon FROM fe_mon WHERE MONTH(fech)=<<nm>> AND YEAR(fech)=<<na>> ORDER BY fech
	ENDTEXT
	If This.EJECutaconsulta(lC, 'atca') < 1 Then
		Return 0
	Endif
	If This.ImportaTCSunat(nm, Na) < 1 Then
		Return 0
	Endif
	If VerificaAlias("curTcambio") = 1 Then
		If This.IniciaTransaccion() < 1 Then
			Return 0
		Endif
		Select atca
		Go Top
		Do While !Eof()
			x	   = Day(atca.fech)
			nidmon = atca.idmon
			Select CurTCambio
			Locate For DIA = x
			If Found()
				tcc	  = CurTCambio.TC_COMPRA
				tcv	  = CurTCambio.TC_VENTA
				attca = CurTCambio.TC_COMPRA
				attcv = CurTCambio.TC_VENTA
			Else
				tcc	= attca
				tcv	= attcv
			Endif
			TEXT To lC Noshow
                UPDATE fe_mon SET valor=?tcc,venta=?tcv WHERE idmon=?nidmon
			ENDTEXT
			If This.Ejecutarsql(lC) < 1 Then
				Sw = 0
				Exit
			Endif
			Select atca
			Skip
		Enddo
		If Sw = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
		If This.GRabarCambios() < 1 Then
			Return 0
		Endif
		If   nm = Month(fe_gene.fech) And Na = Year(fe_gene.fech) Then
			TEXT To lC Noshow
            UPDATE fe_gene SET dola=?tcv WHERE idgene=1
			ENDTEXT
			If This.Ejecutarsql( lC) < 1 Then
				Return  0
			Endif
		Endif
		This.Cmensaje = "Tipo de Cambio Actualizado Correctamente"
		Return 1
	Endif
	Endfunc
	Function importaFacturacompras(cFile)
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	lcURL = Textmerge(This.Urlimgcompras)
	ls_contentFile = Filetostr(cFile)
	ls_base64	   = Strconv(ls_contentFile, 13)
	cad = "data:image/jpg;base64,"
*!*		STRTOFILE(ls_base64,ADDBS(SYS(5)+SYS(2003))+'b64.txt')
	TEXT To cdata Noshow Textmerge
	{
	"imagen":"<<cad+ls_base64>>"
	}
	ENDTEXT
	loXmlHttp = Createobject("Microsoft.XMLHTTP")
	loXmlHttp.Open('POST', lcURL, .F.)
	loXmlHttp.setRequestHeader("Content-Type", "application/json")
	loXmlHttp.Send(cdata)
	orpta = Createobject("empty")
	AddProperty(orpta, 'estado', 0)
	AddProperty(orpta, 'cmensaje', '')
	If loXmlHttp.Status <> 200 Then
		This.Cmensaje = "Servicio WEB NO Disponible....." + Alltrim(Str(loXmlHttp.Status))
		orpta.estado=0
		orpta.Cmensaje=This.Cmensaje
		Return orpta
	Endif
	lcHTML = loXmlHttp.responseText
*!*		STRTOFILE(lcHTML,ADDBS(SYS(5)+SYS(2003))+'rpta.txt')
*!*		Messagebox(lcHTML)
	AddProperty(orpta, 'proveedor', '')
	AddProperty(orpta, 'ruc', '')
	AddProperty(orpta, 'fecha', '')
	AddProperty(orpta, 'moneda', '')
	AddProperty(orpta, 'documento', '')
	Set Procedure  To d:\Librerias\nfJsonRead.prg Additive
	odcto = nfJsonRead(lcHTML)
	If  Vartype(odcto.proveedor) <> 'U' Then
		orpta.proveedor=odcto.proveedor
		orpta.Ruc=odcto.Ruc
		orpta.documento=odcto.documento
		orpta.moneda=odcto.moneda
		orpta.fecha=odcto.fecha
		Create Cursor idatos(Descri c(150),unid c(20),cant N(10,2),Prec N(13,8))
		For Each oRow In  odcto.carrito_de_compras
			Insert Into idatos(Descri,unid,cant,Prec)Values(Alltrim(oRow.descripcion),Alltrim(oRow.unidad),oRow.cantidad,oRow.Precio)
		Endfor
	Else
		orpta.estado=0
		orpta.Cmensaje='No hay Resultados'
		Return orpta
	Endif
	orpta.estado=1
	orpta.Cmensaje='ok'
	Return orpta
	Endfunc
Enddefine



