Define Class importadatos As OData Of 'd:\capass\database\data'
	Ruc = ""
	dni = ""
	Url = 'http://companiasysven.com'
	Urlimgcompras = 'https://companiasysven.com/app88/parsearxml.php'
	Function consultardata(Ccursor)
	Text To LC Noshow Textmerge
     select fech,CAST(valor as decimal(5,3)) as valor,CAST(venta as decimal(5,3)) as venta,idmon FROM fe_mon ORDER BY fech
	Endtext
	If This.EJECutaconsulta(LC, Ccursor) < 1 Then
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
	Text To cdata Noshow Textmerge
	{
	"dfi":"<<fi>>",
	"dff":"<<ff>>"
	}
	Endtext
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
	LC = 'Fundtipocambio'
	goApp.npara1 = Df
	goApp.npara2 = ct
	Text To lp Noshow
	    (?goapp.npara1,?goapp.npara2)
	Endtext
	m.ntc = This.EJECUTARf(LC, lp, 'lmone')
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
	Text To LC Noshow Textmerge
    select valor,venta FROM fe_mon WHERE fech='<<f>>'
	Endtext
	If This.EJECutaconsulta(LC, 'tca') < 1 Then
		Return  0
	Endif
	attca = tca.valor
	attcv = tca.Venta
	Text To LC Noshow Textmerge
        select  fech,valor,venta,idmon FROM fe_mon WHERE MONTH(fech)=<<nm>> AND YEAR(fech)=<<na>> ORDER BY fech
	Endtext
	If This.EJECutaconsulta(LC, 'atca') < 1 Then
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
			Text To LC Noshow
                UPDATE fe_mon SET valor=?tcc,venta=?tcv WHERE idmon=?nidmon
			Endtext
			If This.Ejecutarsql(LC) < 1 Then
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
			Text To LC Noshow
            UPDATE fe_gene SET dola=?tcv WHERE idgene=1
			Endtext
			If This.Ejecutarsql( LC) < 1 Then
				Return  0
			Endif
		Endif
		This.Cmensaje = "Tipo de Cambio Actualizado Correctamente"
		Return 1
	Endif
	Endfunc
	Function importaFacturacompras(cFile)
	If This.idsesion > 0 Then
		Set DataSession To This.idsesion
	Endif
	lcURL = Textmerge(This.Urlimgcompras)
	ls_contentFile = Filetostr(cFile)
	ls_base64	   = Strconv(ls_contentFile, 13)
	cdata = Filetostr(cFile)
	cad = "data:image/jpg;base64,"
*!*		STRTOFILE(ls_base64,ADDBS(SYS(5)+SYS(2003))+'b64.txt')
*!*		TEXT To cdata Noshow Textmerge
*!*		{
*!*		"imagen":"<<cad+ls_base64>>"
*!*		}
*!*		ENDTEXT
	loXmlHttp = Createobject("Microsoft.XMLHTTP")
	loXmlHttp.Open('POST', lcURL, .F.)
	loXmlHttp.setRequestHeader("Content-Type",  "text/xml; charset=utf-8")
	loXmlHttp.Send(cdata)
	orpta = Createobject("empty")
	AddProperty(orpta, 'estado', 0)
	AddProperty(orpta, 'cmensaje', '')
	If loXmlHttp.Status <> 200 Then
		This.Cmensaje = "Servicio WEB NO Disponible....." + Alltrim(Str(loXmlHttp.Status))
		orpta.estado = 0
		orpta.Cmensaje = This.Cmensaje
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
		orpta.proveedor = odcto.proveedor
		orpta.Ruc = odcto.Ruc
		orpta.documento = odcto.documento
		orpta.moneda = odcto.moneda
		orpta.Fecha = odcto.Fecha
		Create Cursor idatos(Descri c(150), unid c(20), cant N(10, 2), Prec N(13, 8))
		For Each oRow In  odcto.carrito_de_compras
			Insert Into idatos(Descri, unid, cant, Prec)Values(Alltrim(oRow.descripcion), Alltrim(oRow.unidad), oRow.cantidad, oRow.Precio)
		Endfor
	Else
		orpta.estado = 0
		orpta.Cmensaje = 'No hay Resultados'
		Return orpta
	Endif
	orpta.estado = 1
	orpta.Cmensaje = 'ok'
	Return orpta
	Endfunc
	Function consultartcdata(nmes, nanio, Ccursor)
	Text To LC Noshow Textmerge
      select  fech FROM fe_mon WHERE MONTH(feCh)=<<nmes>> anD YEAR(fech)=<<nanio>>
	Endtext
	If EJECutaconsulta(LC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function codigodetraccion(coddetra)
	Text To cdata Noshow
		 [
	  { "codigo": "001", "descripcion": "Azúcar y melaza de caña" },
	  { "codigo": "002", "descripcion": "Arroz" },
	  { "codigo": "003", "descripcion": "Alcohol etílico" },
	  { "codigo": "004", "descripcion": "Recursos hidrobiológicos" },
	  { "codigo": "005", "descripcion": "Maíz amarillo duro" },
	  { "codigo": "007", "descripcion": "Caña de azúcar" },
	  { "codigo": "008", "descripcion": "Madera" },
	  { "codigo": "009", "descripcion": "Arena y piedra" },
	  { "codigo": "010", "descripcion": "Residuos, subproductos, desechos, recortes y desperdicios" },
	  { "codigo": "011", "descripcion": "Bienes gravados con el IGV, o renuncia a la exoneración" },
	  { "codigo": "012", "descripcion": "Intermediación laboral y tercerización" },
	  { "codigo": "013", "descripcion": "Animales vivos" },
	  { "codigo": "014", "descripcion": "Carnes y despojos comestibles" },
	  { "codigo": "015", "descripcion": "Abonos, cueros y pieles de origen animal" },
	  { "codigo": "016", "descripcion": "Aceite de pescado" },
	  { "codigo": "017", "descripcion": "Harina, polvo y “pellets” de pescado, crustáceos, moluscos y demás invertebrados acuáticos" },
	  { "codigo": "019", "descripcion": "Arrendamiento de bienes muebles" },
	  { "codigo": "020", "descripcion": "Mantenimiento y reparación de bienes muebles" },
	  { "codigo": "021", "descripcion": "Movimiento de carga" },
	  { "codigo": "022", "descripcion": "Otros servicios empresariales" },
	  { "codigo": "023", "descripcion": "Leche" },
	  { "codigo": "024", "descripcion": "Comisión mercantil" },
	  { "codigo": "025", "descripcion": "Fabricación de bienes por encargo" },
	  { "codigo": "026", "descripcion": "Servicio de transporte de personas" },
	  { "codigo": "027", "descripcion": "Servicio de transporte de carga" },
	  { "codigo": "028", "descripcion": "Transporte de pasajeros" },
	  { "codigo": "030", "descripcion": "Contratos de construcción" },
	  { "codigo": "031", "descripcion": "Oro gravado con el IGV" },
	  { "codigo": "032", "descripcion": "Paprika y otros frutos de los géneros capsicum o pimienta" },
	  { "codigo": "034", "descripcion": "Minerales metálicos no auríferos" },
	  { "codigo": "035", "descripcion": "Bienes exonerados del IGV" },
	  { "codigo": "036", "descripcion": "Oro y demás minerales metálicos exonerados del IGV" },
	  { "codigo": "037", "descripcion": "Demás servicios gravados con el IGV" },
	  { "codigo": "039", "descripcion": "Minerales no metálicos" },
	  { "codigo": "040", "descripcion": "Bien inmueble gravado con IGV" },
	  { "codigo": "041", "descripcion": "Plomo" },
	  { "codigo": "044", "descripcion": "Servicio de beneficio de minerales metálicos gravado con el IGV" },
	  { "codigo": "045", "descripcion": "Minerales de oro y sus concentrados gravados con el IGV" },
	  { "codigo": "099", "descripcion": "Ley 30737" }
	]
	Endtext
	Set Procedure To d:\Librerias\nfJsonRead.prg Additive
	cdesc = ""
	objjson = nfJsonRead(cdata)
	For Each Row In objjson.Array
		If Trim(m.coddetra) = Row.codigo Then
			cdesc = Alltrim(Row.descripcion)
			Exit
		Endif
	Endfor
	Return m.cdesc
	Endfunc
	Function importapropuestacomprassireodbc()
	cFile = Getfile('csv', 'Descargar en formaTo CSV')
	If !File(m.cFile) Then
		This.Cmensaje =  "NO Existe el Archivo"
		Return 0
	Endif
	lcFicheroOrigen = m.cFile
	lcFicheroDBCS = Addbs(Justpath(m.cFile)) + "importar.csv"
*!*	    WAIT WINDOW lcFicheroOrigen
*!*	     WAIT WINDOW lcFicheroDBCS
	Strtofile(This.DepurarCaracteresPredefinidos(Strconv(Filetostr(lcFicheroOrigen), 11) ), lcFicheroDBCS)
	cruta = Justpath(m.cFile)
	cruta = Justpath(lcFicheroDBCS)
	cfilecsv = Justfname(m.cFile)
	cfilecsv = Justfname(lcFicheroDBCS)
	Local lcConn, lnConn
	lcConn = "Driver={Microsoft Text Driver (*.txt; *.csv)};" + "Dbq=" +(cruta) + ";Extensions=csv;"
	lnConn = Sqlstringconnect(lcConn)
	If SQLExec(lnConn, "SELECT * FROM " + m.cfilecsv, "importa") > 0 Then
		Select importa
		Browse
	Else
		= Aerror(laError)
*!*			Wait Window laError[1]
*!*			Wait Window laError[2]
*!*			Wait Window laError[3]
		This.Cmensaje = laError[3]
		Return 0
	Endif
	SQLDisconnect(lnConn)
	Return 1
	Endfunc
	Function importapropuestacomprassire()
	Local lnHandle, lcLinea, laDatos[1]
	cFile = Getfile('csv', 'Descargar en formaTo CSV')
	If !File(m.cFile) Then
		This.Cmensaje =  "NO Existe el Archivo"
		Return 0
	Endif
	lnHandle = Fopen(m.cFile)
	Create Cursor regsire(carsunat c(20), Fecha d, tdoc c(2), serie c(4), numero c(12), nruc c(11), nombre c(120), importe N(12, 2))
* Leer y descartar encabezado
	lcLinea = Fgets(lnHandle)
	lcLinea = Fgets(lnHandle)
	lcLinea = Fgets(lnHandle)
	lcLinea = Fgets(lnHandle)
	Do While !Feof(lnHandle)
		lcLinea = Fgets(lnHandle)
		lcLinea = Strtran(lcLinea, Chr(13) + Chr(10), "")
*!*			WAIT WINDOW lcLinea
		Alines(laDatos, lcLinea, ",")
*!*			WAIT WINDOW laDatos[4] + ' '+VARTYPE(laDatos[4])
*!*			WAIT WINDOW laDatos[5]+ ' '+VARTYPE(laDatos[5])
*!*			WAIT WINDOW laDatos[7]+ ' '+VARTYPE(laDatos[7])
*!*			WAIT WINDOW laDatos[8]+ ' '+VARTYPE(laDatos[8])
*!*			WAIT WINDOW laDatos[10]+ ' '+VARTYPE(laDatos[10])
*!*			WAIT WINDOW laDatos[13]+ ' '+VARTYPE(laDatos[13])
*!*			WAIT WINDOW laDatos[14]+ ' '+VARTYPE(laDatos[14])
*!*			WAIT WINDOW laDatos[15]+ ' '+VARTYPE(laDatos[15])
*!*			WAIT WINDOW laDatos[16]+ ' '+VARTYPE(laDatos[16])
*!*			WAIT WINDOW laDatos[21]+ ' '+VARTYPE(laDatos[21])
*!*			WAIT WINDOW laDatos[25]+ ' '+VARTYPE(laDatos[25])
*!*			Exit
		If Vartype(laDatos[4]) <> 'U'  Then
*!*				Insert Into regsire(carsunat, Fecha, tdoc, serie, numero, nruc, nombre, importe) ;
Values (laDatos[4], Ctod(laDatos[5]), laDatos[7], laDatos[8], Right('00000000' + laDatos[10], 10), laDatos[13], laDatos[14], Val(laDatos[25]))
			Insert Into regsire(carsunat) ;
				Values (laDatos[4])
		Endif
	Enddo

	Fclose(lnHandle)
	Endfunc
	Function DepurarCaracteresPredefinidos
	Lparameters lcVariable
	lcVariable = Strtran(lcVariable, '»', "'")
	lcVariable = Strtran(lcVariable, "&quote;", "‘")
	lcVariable = Strtran(lcVariable, "&quot;", "‘")
	lcVariable = Strtran(lcVariable, "&apos;", "‘")
	lcVariable = Strtran(lcVariable, "amp;", " &")
	lcVariable = Strtran(lcVariable, "andamp;", "&")
	lcVariable = Strtran(lcVariable, "‘", "'")
	lcVariable = Strtran(lcVariable, "?", "")
	lcVariable = Strtran(lcVariable, "&rsquo;", "'")
	lcVariable = Strtran(lcVariable, "&amp;", "&")
	Return lcVariable
	Endfunc
	Function importacsv()
	m.conerror = 0
	cFile = Getfile('csv', 'Archivo en formaTo CSV')
	If Empty(m.cFile)
		This.Cmensaje =  "No Ha seleccionado El archivo a Importar"
		Return 0
	Endif
	If Lower(Justext(m.cFile)) <> 'csv' Then
		This.Cmensaje =  "El Archivo debe  ser TIPO CSV"
		Return 0
	Endif
	If !File(m.cFile) Then
		This.Cmensaje =  "NO Existe el Archivo"
		Return 0
	Endif
	Try
		Create Cursor  propuesta ;
			( ;
			  Ruc c(11), ;
			  razon_social c(120), ;
			  periodo c(6), ;
			  car_sunat c(20), ;
			  fecha_emision T, ;
			  fecha_vcto d, ;
			  tipo_cp c(5), ;
			  serie_cdp c(10), ;
			  anio c(4), ;
			  nro_cp_ini c(20), ;
			  nro_cp_fin c(20), ;
			  tipo_doc c(2), ;
			  nro_doc c(15), ;
			  proveedor c(120), ;
			  bi_grav_dg N(14, 2), ;
			  igv_dg N(14, 2), ;
			  bi_grav_dgng N(14, 2), ;
			  igv_dgng N(14, 2), ;
			  bi_grav_dng N(14, 2), ;
			  igv_dng N(14, 2), ;
			  valor_ng N(14, 2), ;
			  isc N(14, 2), ;
			  icbper N(14, 2), ;
			  otros_trib N(14, 2), ;
			  total_cp N(14, 2), ;
			  moneda c(3), ;
			  tipo_cambio N(10, 4), ;
			  fec_doc_mod d, ;
			  tipo_cp_mod c(5), ;
			  serie_cp_mod c(10), ;
			  cod_dam c(20), ;
			  nro_cp_mod c(20), ;
			  clasif_bs c(5), ;
			  id_proy c(20), ;
			  porc_part N(6, 2), ;
			  imb N(14, 2), ;
			  car_orig c(5), ;
			  detraccion c(2), ;
			  tipo_nota c(2), ;
			  est_comp c(2), ;
			  incal c(1), ;
			  clu01 c(20), clu02 c(20), clu03 c(20), clu04 c(20), clu05 c(20), ;
			  clu06 c(20), clu07 c(20), clu08 c(20), clu09 c(20), clu10 c(20), ;
			  clu11 c(20), clu12 c(20), clu13 c(20), clu14 c(20), clu15 c(20), ;
			  clu16 c(20), clu17 c(20), clu18 c(20), clu19 c(20), clu20 c(20), ;
			  clu21 c(20), clu22 c(20), clu23 c(20), clu24 c(20), clu25 c(20), ;
			  clu26 c(20), clu27 c(20), clu28 c(20), clu29 c(20), clu30 c(20), ;
			  clu31 c(20), clu32 c(20), clu33 c(20), clu34 c(20), clu35 c(20), ;
			  clu36 c(20), clu37 c(20), clu38 c(20), clu39 c(20) ;
			  )
		Append From (m.cFile) Type Csv
		Select car_sunat As carsunat, Ttod(fecha_emision) As Fecha, tipo_cp As tdoc,;
			serie_cdp As serie, nro_cp_ini As numero, nro_doc As nruc,;
			proveedor, total_cp As Total, Alltrim(Trim(nro_doc) + Trim(tipo_cp) + Trim(serie_cdp) + Trim(nro_cp_ini)) As clave From propuesta Into Cursor propsunat
	Catch To oex
		This.Cmensaje = oex.Message + Chr(13) +  " Opción: " + oex.Procedure + Chr(13) + "Linea: " + Transform(oex.Lineno)
		m.conerror = 1
	Finally
	Endtry
	If m.conerror = 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function importacsvventas()
	m.conerror = 0
	cFile = Getfile('csv', 'Archivo en formaTo CSV')
	If Empty(m.cFile)
		This.Cmensaje =  "No Ha seleccionado El archivo a Importar"
		Return 0
	Endif
	If Lower(Justext(m.cFile)) <> 'csv' Then
		This.Cmensaje =  "El Archivo debe ser  Tipo CSV"
		Return 0
	Endif
	If !File(m.cFile) Then
		This.Cmensaje =  "NO Existe el Archivo"
		Return 0
	Endif
	Try
		Create Cursor propuesta ;
			( ;
			  Ruc c(11), ;
			  razon_social c(100), ;
			  periodo c(6), ;
			  car_sunat c(30), ;
			  fecha_emision t, ;
			  Fecha_Vcto_Pago d, ;
			  Tipo_CP_Doc c(2), ;
			  serie_cdp c(4), ;
			  Nro_CP_Inicial c(20), ;
			  Nro_CP_Final c(20), ;
			  Tipo_Doc_Identidad c(2), ;
			  Nro_Doc_Identidad c(15), ;
			  Apellidos_Nombres c(120), ;
			  Valor_Fact_Export N(14, 2), ;
			  BI_Gravada N(14, 2), ;
			  Dscto_BI N(14, 2), ;
			  IGV_IPM N(14, 2), ;
			  Dscto_IGV N(14, 2), ;
			  Mto_Exonerado N(14, 2), ;
			  Mto_Inafecto N(14, 2), ;
			  isc N(14, 2), ;
			  BI_Grav_IVAP N(14, 2), ;
			  IVAP N(14, 2), ;
			  icbper N(14, 2), ;
			  Otros_Tributos N(14, 2), ;
			  total_cp N(14, 2), ;
			  moneda c(3), ;
			  tipo_cambio N(10, 4), ;
			  Fecha_Emi_Mod d, ;
			  tipo_cp_mod c(2), ;
			  serie_cp_mod c(4), ;
			  nro_cp_mod c(20), ;
			  ID_Proyecto c(20), ;
			  tipo_nota c(2), ;
			  est_comp c(2), ;
			  Valor_FOB N(14, 2), ;
			  Valor_OP_Gratuitas N(14, 2), ;
			  Tipo_Operacion c(2), ;
			  DAM_CP c(20), ;
			  CLU c(20) ;
			  )
		Append From (m.cFile) Type Csv
		Select car_sunat As carsunat, Ttod(fecha_emision) As Fecha,  Tipo_CP_Doc As tdoc,;
			serie_cdp As serie, Nro_CP_Inicial  As numero,  Nro_Doc_Identidad As nruc,;
			Apellidos_Nombres As cliente, total_cp As Total,  Trim(Tipo_CP_Doc) + Trim(serie_cdp) + Trim(Nro_CP_Inicial) As clave From propuesta Into Cursor propsunat
	Catch To oex
		This.Cmensaje = oex.Message + Chr(13) +  " Opción: " + oex.Procedure + Chr(13) + "Linea: " + Transform(oex.Lineno)
		m.conerror = 1
	Finally
	Endtry
	If m.conerror = 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine






















