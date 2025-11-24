Define Class Imprimir As Custom
	Archivo = ""
	Tdoc = ""
	ArchivoPdf = ""
	TituloInforme = ""
	SubtituloInforme = ""
	Concopia = ""
	Conformato = ""
	ArchivoPordefecto = ""
	Calias = ""
	nvalor = 0
	nigv = 0
	nTotal = 0
	Idsesion = 0
	Cmensaje = ""
	ConvistaPrevia = ""
	Cgarantia = ""
	reimpresion = ''
	crucempresa = ''
	Procedure ImprimeComprobante
	Lparameters cmodoimpresion
	This.ImprimeComprobanteM(cmodoimpresion)
	Endproc
	Procedure ImprimeComprobantex
	Lparameters cmodo, Clet, cndoc, nroitems, Nti, Cruc1, Crazon, cforma, Df, Creferencia, cguia, Cvendedor, dFv, chash, Cmoneda, Cdireccion, Cdni, cTdoc, ccopia, ndias
	If Type('oempresa') = 'U' Then
		Cruc = fe_gene.nruc
	Else
		Cruc = Oempresa.nruc
	Endif
	Select tmpv
	Set Filter To
	Set Order To
	Go Top In tmpv
	ni = nroitems
	For x = 1 To Nti - nroitems
		ni = ni + 1
		Insert Into tmpv(Ndoc, Nitem, cletras)Values(cndoc, ni, Clet)
	Next
	Replace All Ndoc With cndoc, cletras With Clet, ;
		nruc  With Cruc1, razon With Crazon, Form With cforma, fech With Df, Forma With cforma, ;
		Referencia With Creferencia, Ndo2 With cguia, Vendedor With Cvendedor, fechav With dFv, ;
		hash With chash, Mone With Cmoneda, Direccion With Cdireccion, ;
		dni With Cdni, Tigv With fe_gene.igv, Tdoc With cTdoc, dias With ndias In tmpv
	If This.nvalor > 0 Then
		Replace All igv With This.nigv, valor With This.nvalor, Total With This.nTotal In tmpv
	Endif
	If Len(Alltrim(This.Cgarantia)) > 0 Then
		Replace All garantia With This.Cgarantia
	Endif
	If  fe_gene.ccopia = 'S' Then
		Select * From tmpv Into Cursor copiaor Readwrite
		Replace All copia With 'Z' In copiaor
		Select tmpv
		Append From Dbf("copiaor")
	Endif
	Cruta = Addbs(Addbs(Sys(5) + Sys(2003)) + Alltrim(Cruc))
	Select tmpv
	Go Top
	If  goApp.ImpresionTicket = 'S'
		Set Filter To !Empty(Coda)
		Go Top
		Do Case
		Case This.Tdoc = '07' Or This.Tdoc = '08'
			This.Archivo = Cruta + 'ticketn.frx'
		Otherwise
			This.Archivo = Cruta + 'ticket.frx'
			car = 'boleta.frx'
		Endcase
	Else
		Do Case
		Case This.Tdoc = '01'
			This.Archivo = Cruta + 'factura.frx'
			car = 'factura.frx'
		Case This.Tdoc = '03'
			This.Archivo = Cruta + 'boleta.frx'
			car = 'boleta.frx'
		Case This.Tdoc = '20'
			This.Archivo = Cruta + 'notasp.frx'
			car = 'pedido.frx'
		Case This.Tdoc = '07'
			This.Archivo = Cruta + 'notasc.frx'
			car = 'notasc.frx'
		Case This.Tdoc = '08'
			This.Archivo = Cruta + 'notasd.frx'
			car = 'notasd.frx'
		Case This.Tdoc = '09'
			This.Archivo = Cruta + 'guia.frx'
			car = 'guia.frx'
		Case This.Tdoc = 'OC'
			This.Archivo = Addbs(Sys(5) + Sys(2003) + '\Reports') + 'Ocompra.frx'
			car = 'ocompra.frx'
		Endcase
	Endif
	This.GeneraQR()
	Set Procedure To FoxbarcodeQR Additive
	m.oFbc = Createobject("FoxBarcodeQR")
	If cmodo = 'S' Then
		If File(This.Archivo) Then
			Report Form (This.Archivo) To Printer Prompt Noconsole
		Else
			Report Form (car) To Printer Prompt Noconsole
		Endif
	Endif
	m.oFbc = Null
	Endproc
	Procedure ImprimeComprobanteM
	Lparameters cmodo
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Calias = ""
	If !Pemstatus(goApp, "Conformato", 5)
		goApp.AddProperty("Conformato", "")
	Endif
	If !Pemstatus(goApp, 'proyecto', 5) Then
		AddProperty(goApp, 'proyecto', '')
	Endif
	If cmodo = 'S' Then
		This.Conformato = goApp.Conformato
	Else
		This.Conformato = ""
	Endif
	If 	Type('oempresa') = 'U' Then
		Cruc = fe_gene.nruc
	Else
		If Empty(This.crucempresa) Then
			Cruc = Oempresa.nruc
		Else
			Cruc = This.crucempresa
		Endif
	Endif
	Cruta = Addbs(Addbs(Sys(5) + Sys(2003)) + Alltrim(Cruc))
	Set Procedure To FoxbarcodeQR Additive
	m.oFbc = Createobject("FoxBarcodeQR")
	If Empty(This.ArchivoPordefecto) Then
		If This.Conformato = 'S' Then
			Do Case
			Case This.Tdoc = '01'
				This.Archivo = Addbs(Addbs(Sys(5) + Sys(2003)) + 'comp') + 'factura.frx'
				car = 'factura.frx'
				Calias = "tmpv"
			Case This.Tdoc = '03'
				This.Archivo = Addbs(Addbs(Sys(5) + Sys(2003)) + 'comp') + 'boleta.frx'
				car = 'boleta.frx'
				Calias = "tmpv"
			Case This.Tdoc = '04'
				This.Archivo = Addbs(Addbs(Sys(5) + Sys(2003)) + 'comp') + 'liqcompra.frx'
				car = 'liqcompra.frx'
				Calias = "tmpv"
			Case This.Tdoc = '07'
				This.Archivo = Cruta + 'notasc.frx'
				car = 'notasc.frx'
				Calias = "tmpv"
			Case This.Tdoc = '08'
				This.Archivo = Cruta + 'notasd.frx'
				car = 'notasd.frx'
				Calias = "tmpv"
			Case This.Tdoc = '09'
				This.Archivo = Addbs(Addbs(Sys(5) + Sys(2003)) + 'comp') + 'guia.frx'
				car = 'guia.frx'
				If goApp.Proyecto = 'xsysz' Then
					Calias = 'imp'
				Else
					Calias = "tmpvg"
				Endif
			Case This.Tdoc = '20' Or This.Tdoc = '00'
				This.Archivo = Addbs(Addbs(Sys(5) + Sys(2003)) + 'comp') + 'notasp.frx'
				car = 'notasp.frx'
				Calias = "tmpv"
			Case This.Tdoc = 'PR'
				This.Archivo = Cruta + 'proforma.frx'
				car = 'proforma.frx'
				Calias = "tmpp"
			Case This.Tdoc = 'OC'
				This.Archivo = Cruta + 'Ocompra.frx'
				car = 'ocompra.frx'
				Calias = "otmpp"
			Case This.Tdoc = 'TT'
				This.Archivo = Cruta  + 'traspaso.frx'
				car = 'traspaso.frx'
				Calias = "tmpv"
			Case This.Tdoc = '21'
				This.Archivo = Cruta  + 'preventa.frx'
				car = 'pedidos.frx'
				Calias = "tmpp"
			Otherwise
				This.Archivo = Cruta  + 'boleta.frx'
				car = 'boleta.frx'
				Calias = "tmpv"
			Endcase
		Else
			Do Case
			Case This.Tdoc = '01'
				This.Archivo = Cruta + 'factura.frx'
				car = 'factura.frx'
				Calias = "tmpv"
			Case This.Tdoc = '03'
				This.Archivo = Cruta + 'boleta.frx'
				car = 'boleta.frx'
				Calias = "tmpv"
			Case This.Tdoc = '04'
				This.Archivo = Cruta + 'liqcompra.frx'
				car = 'liqcompra.frx'
				Calias = "tmpv"
			Case This.Tdoc = '07'
				This.Archivo = Cruta + 'notasc.frx'
				car = 'notasc.frx'
				Calias = "tmpv"
			Case This.Tdoc = '08'
				This.Archivo = Cruta + 'notasd.frx'
				car = 'notasd.frx'
				Calias = "tmpv"
			Case This.Tdoc = '09'
				This.Archivo = Cruta + 'guia.frx'
				car = 'guia.frx'
				If goApp.Proyecto = 'xsysz' Then
					Calias = 'imp'
				Else
					Calias = "tmpvg"
				Endif
			Case This.Tdoc = '20' Or This.Tdoc = '00' Or This.Tdoc = 'SC'
				This.Archivo = Cruta + 'notasp.frx'
				car = 'notasp.frx'
				Calias = "tmpv"
			Case This.Tdoc = 'PR'
				This.Archivo = Cruta + 'proforma.frx'
				car = 'proforma.frx'
				Calias = "tmpp"
			Case This.Tdoc = 'OC'
				This.Archivo = Cruta + 'Ocompra.frx'
				car = 'ocompra.frx'
				Calias = "otmpp"
			Case This.Tdoc = 'RQ'
				This.Archivo = Cruta + 'RQcompra.frx'
				car = 'RQCompra.frx'
				Calias = "otmpp"
			Case This.Tdoc = 'CO'
				This.Archivo = Cruta + 'cotcompra.frx'
				car = 'cotCompra.frx'
				Calias = "otmpp"
			Case This.Tdoc = 'TT'
				This.Archivo = Cruta + 'traspaso.frx'
				car = 'traspaso.frx'
				Calias = "tmpv"
			Case This.Tdoc = '21'
				This.Archivo = Cruta + 'preventa.frx'
				car = 'pedidos.frx'
				Calias = "tmpp"
			Otherwise
				This.Archivo = Cruta + 'boleta.frx'
				car = 'boleta.frx'
				Calias = "tmpv"
			Endcase
		Endif
	Else
		cArchivo = Cruta + This.ArchivoPordefecto
		car = 'factura.frx'
		This.Archivo = cArchivo
		Calias = "tmpv"
	Endif
	If VerificaAlias(Calias) = 1  And !Empty(Calias) Then
		Select (Calias)
		Set Filter To
		Go Top
	Endif
	If cmodo = 'S' Then
		This.GeneraQR()
		If File(This.Archivo) Then
			Report Form (This.Archivo) To Printer Prompt Noconsole
		Else
			Report Form (car) To Printer Prompt Noconsole
		Endif
		m.oFbc = Null
		cpropiedad = "Otraimpresionvtas"
		If !Pemstatus(goApp, cpropiedad, 5)
			goApp.AddProperty("Otraimpresionvtas", "")
		Endif
		cpropiedad = "Otraimpresora"
		If !Pemstatus(goApp, cpropiedad, 5)
			goApp.AddProperty("Otraimpresora", "")
		Endif
		If This.Tdoc = '01' Or This.Tdoc = '03' Or This.Tdoc = '20' Then
			If This.reimpresion <> 'S' Then
				carfilee = Addbs(Addbs(Sys(5) + Sys(2003)) + fe_gene.nruc) + 'oentrega.frx'
				If goApp.Otraimpresionvtas = 'S' And !Empty(goApp.Otraimpresora) And Val(goApp.Tiendaconcopia) = goApp.Tienda Then
					Declare Integer SetDefaultPrinter In WINSPOOL.DRV ;
						String pszPrinter
					lcImpresoraActual = ObtenerImpresoraActual()
					Set Printer To Name (Alltrim(goApp.Otraimpresora))
					Select * From tmpv Into Cursor cop
					Select cop
					Go Top
					If File(carfilee) Then
						Report Form (carfilee) To Printer Noconsole
					Endif
					lnResultado = SetDefaultPrinter(lcImpresoraActual)
					Set Printer To Name (Alltrim(lcImpresoraActual))
				Endif
				If goApp.Otraimpresionvtas = 'S' And !Empty(goApp.Otraimpresora1) And Val(goApp.Tiendaconcopia) = goApp.Tienda Then
					Declare Integer SetDefaultPrinter In WINSPOOL.DRV ;
						String pszPrinter
					lcImpresoraActual = ObtenerImpresoraActual()
					Set Printer To Name (Alltrim(goApp.Otraimpresora1))
					Select * From tmpv Into Cursor cop
					Select cop
					Go Top
					If File(carfilee) Then
						Report Form (carfilee) To Printer Noconsole
					Endif
					lnResultado = SetDefaultPrinter(lcImpresoraActual)
					Set Printer To Name (Alltrim(lcImpresoraActual))
				Endif
			Endif
		Endif
	Endif
	Endproc
	Procedure GeneraPDF
	Lparameters cmodo
	Set Procedure To ple5 Additive
	This.GeneraQR()
*!*		wait WINDOW This.Archivo
*!*		wait WINDOW This.Archivopdf
	This.CrearPdf(This.Archivo, This.ArchivoPdf, cmodo)
	Endproc
	Function cambiarimpresoranormalpdf(creporte)
	cpropiedad = "Impresoranormal"
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("Impresoranormal", "")
	Else
		lcImpresora = goApp.Impresoranormal
	Endif
	Do "FoxyPreviewer.App"
	If !Empty(goApp.Impresoranormal) Then
		Declare Integer SetDefaultPrinter In WINSPOOL.DRV ;
			String pszPrinter
		lcImpresoraActual = ObtenerImpresoraActual()
		lcImpresora		  = goApp.Impresoranormal
		lnResultado		  = SetDefaultPrinter(lcImpresora)
		Set Printer To Name (lcImpresora)
		Report Form (creporte) Preview
		lnResultado = SetDefaultPrinter(lcImpresoraActual)
		Set Printer To Name (lcImpresoraActual)
	Else
		Report Form (creporte) Preview
	Endif
	Do Foxypreviewer.App With "Release"
	Endfunc
	Function GeneraQR()
	cpropiedad = 'archivoqr'
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("archivoqr", "")
	Endif
	cpropiedad = 'qr'
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("qr", "")
	Endif
	carpetaqr = Addbs(Sys(5) + Sys(2003)) + 'qr'
	If !Directory(carpetaqr) Then
		Mkdir (carpetaqr)
	Endif
	cfileqr = "codigoqr" + Sys(2015) + ".png"
	goApp.archivoqr = carpetaqr + '\' + cfileqr
	Endfunc
	Procedure ElijeFormato
	If 	 Type('oempresa') = 'U' Then
		Cruc = fe_gene.nruc
	Else
		Cruc = Oempresa.nruc
	Endif
	If Empty(This.ArchivoPordefecto) Then
		This.ElijeFormatoM()
	Else
		cArchivo = Addbs(Addbs(Sys(5) + Sys(2003)) + Alltrim(Cruc)) + This.ArchivoPordefecto
		car = 'factura.frx'
		This.Archivo = cArchivo
	Endif
	Endproc
	Procedure ElijeFormatoM
	If 	 Type('oempresa') = 'U' Then
		Cruc = fe_gene.nruc
	Else
		Cruc = Oempresa.nruc
	Endif
	Cruta = Addbs(Addbs(Sys(5) + Sys(2003)) + Alltrim(Cruc))
	Do Case
	Case This.Tdoc = '01'
		This.Archivo = Cruta + 'factura.frx'
	Case This.Tdoc = '03'
		This.Archivo = Cruta + 'boleta.frx'
	Case This.Tdoc = '07'
		This.Archivo = Cruta + 'notasc.frx'
	Case This.Tdoc = '08'
		This.Archivo = Cruta + 'notasd.frx'
	Case This.Tdoc = '09'
		This.Archivo = Cruta + 'guia.frx'
	Case This.Tdoc = 'PR'
		This.Archivo = Cruta + 'cotizacion.frx'
	Case This.Tdoc = 'OC'
		This.Archivo = Cruta + 'ocompra.frx'
	Case This.Tdoc = '20'
		This.Archivo = Cruta + 'notasp.frx'
	Case This.Tdoc = 'TT'
		This.Archivo = Cruta + 'traspaso.frx'
	Endcase
	Endproc
	Procedure ImprimeComprobanteComoTicket
	Lparameters modo
	This.ImprimeComprobanteComoticketM(modo, This.Tdoc)
	Endproc
	Procedure ImprimeComprobanteComoticketM
	Lparameters cmodo, cctdoc
	Set Procedure To FoxbarcodeQR Additive
	Private m.oFbc
	m.oFbc = Createobject("FoxBarcodeQR")
	If 	 Type('oempresa') = 'U' Then
		Cruc = fe_gene.nruc
	Else
		Cruc = Oempresa.nruc
	Endif
	If Vartype(cctdoc) = 'C'
		Do Case
		Case cctdoc = '04'
			cArchivo = Addbs(Addbs(Sys(5) + Sys(2003)) + Alltrim(Cruc)) + 'ticketlq.frx'
		Case  cctdoc = 'SC'
			cArchivo = Addbs(Addbs(Sys(5) + Sys(2003)) + Alltrim(Cruc)) + 'ticketp.frx'
		Case  cctdoc = 'PR'
			cArchivo = Addbs(Addbs(Sys(5) + Sys(2003)) + Alltrim(Cruc)) + 'ticketp.frx'
		Case  cctdoc = '20'
			cFile = Addbs(Addbs(Sys(5) + Sys(2003))  + Alltrim(Cruc)) + 'ticketv.frx'
			If File(cFile) Then
				cArchivo = Addbs(Addbs(Sys(5) + Sys(2003)) + Alltrim(Cruc)) + 'ticketv.frx'
			Else
				cArchivo = Addbs(Addbs(Sys(5) + Sys(2003)) + Alltrim(Cruc)) + 'ticket.frx'
			Endif
		Case cctdoc = '07' Or cctdoc = '08'
			cArchivo = Addbs(Addbs(Sys(5) + Sys(2003)) + Alltrim(Cruc)) + 'ticketn.frx'
		Case cctdoc = '21'
			cArchivo = Addbs(Addbs(Sys(5) + Sys(2003))  + Alltrim(Cruc)) + 'preventa.frx'
		Case cctdoc = 'TT'
			cArchivo = Addbs(Addbs(Sys(5) + Sys(2003) ) + Alltrim(Cruc)) + 'ticketT.frx'
		Case cctdoc = '09'
			cArchivo = Addbs(Addbs(Sys(5) + Sys(2003) ) + Alltrim(Cruc)) + 'ticketguia.frx'
			If goApp.Proyecto = 'xsysz' Then
				This.Calias = 'imp'
			Else
				This.Calias = "tmpvg"
			Endif
		Otherwise
			cArchivo = Addbs(Addbs(Sys(5) + Sys(2003)) + Alltrim(Cruc)) + 'ticket.frx'
		Endcase
	Else
		cArchivo = Addbs(Addbs(Sys(5) + Sys(2003))  + Alltrim(Cruc)) + 'ticket.frx'
	Endif
	This.GeneraQR()
	If !Empty(This.Calias) Then
		Select (This.Calias)
		Go Top
	Else
		Select tmpv
		Go Top
	Endif
	Go Top
	Report Form (cArchivo) To Printer Prompt Noconsole
	If This.Tdoc = '01' Or This.Tdoc = '03' Or This.Tdoc = '20' Then
		cpropiedad = "Otraimpresionvtas"
		If This.reimpresion <> 'S' Then
			If !Pemstatus(goApp, cpropiedad, 5)
				goApp.AddProperty("Otraimpresionvtas", "")
			Endif
			cpropiedad = "Otraimpresora"
			If !Pemstatus(goApp, cpropiedad, 5)
				goApp.AddProperty("Otraimpresora", "")
			Endif
			carfilee = Addbs(Addbs(Sys(5) + Sys(2003)) + fe_gene.nruc) + 'oentrega.frx'
			If goApp.Otraimpresionvtas = 'S' And !Empty(goApp.Otraimpresora) Then
				Declare Integer SetDefaultPrinter In WINSPOOL.DRV ;
					String pszPrinter
				lcImpresoraActual = ObtenerImpresoraActual()
				Set Printer To Name (Alltrim(goApp.Otraimpresora))
				Select * From tmpv Into Cursor cop
				Select cop
				Go Top
				If File(carfilee) Then
					Report Form (carfilee) To Printer Noconsole
				Endif
				lnResultado = SetDefaultPrinter(lcImpresoraActual)
				Set Printer To Name (Alltrim(lcImpresoraActual))
			Endif
		Endif
	Endif
	Release m.oFbc
	Delete File (goApp.archivoqr)
	Endproc
***************
	Procedure CrearPdfOrdenCompra(np1, np2, np3)
	Set Procedure To abrirpdf  Additive
	Do "FoxyPreviewer.App"
	carch = Addbs(Sys(5) + Sys(2003) + '\OrdenCompra\') + np2
	Select otmpp
	Go Top
	Report Form (np1) Object Type 10 To File (carch)
	Do Foxypreviewer.App With "Release"
	If np3 = 'S' Then
		abrirpdf(carch)
	Endif
	Endproc
********************
	Procedure CrearPdfCotizaciones(np1, np2, np3)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Procedure To abrirpdf, FoxbarcodeQR   Additive
	Do "FoxyPreviewer.App"
	If  !Directory(Sys(5) + Sys(2003) + "\cotizaciones") Then
		ccarpeta = Sys(5) + Sys(2003) + "\cotizaciones"
		Mkdir (ccarpeta)
	Endif
	carch = Addbs(Sys(5) + Sys(2003) + '\cotizaciones') + np2
	Report Form (np1) Object Type 10 To File (carch)
	Do Foxypreviewer.App With "Release"
	If np3 = 'S' Then
		abrirpdf(carch)
	Endif
	Endproc
	Function  CrearPdf(np1, np2, np3)
	Private oFbc
	Local lcImpresora, lcImpresoraActual, lcStrings, lnResultado
	Do "Foxypreviewer.App" With "Release"
	Set Procedure To CapaDatos, abrirpdf, FoxbarcodeQR Additive
	m.oFbc = Createobject("FoxBarcodeQR")
	If !Pemstatus(goApp, 'archivoqr', 5) Then
		goApp.AddProperty("archivoqr", "")
	Endif
	If !Pemstatus(goApp, 'proyecto', 5) Then
		goApp.AddProperty("proyecto", "")
	Endif
	goApp.archivoqr = Addbs(Sys(5) + Sys(2003)) + "codigoqr.png"
	Do "FoxyPreviewer.App"
	lcStrings = np2
	crutapdf1 = Left(Substr(lcStrings, Rat("pdf", lcStrings)), 3)
	crutapdf2 = Left(Substr(lcStrings, Rat("PDF", lcStrings)), 3)
	filepdf	  = Justfname(np2)
	Cruta = Addbs(Sys(5) + Sys(2003))
	If This.Tdoc='09' Then
		If !Directory( Cruta + "pdfguias") Then
			ccarpeta = Cruta + "pdfguias"
			Mkdir (ccarpeta)
		Endif
		carchivopdf = Addbs(Addbs(Sys(5) + Sys(2003)) + 'pdfguias') + filepdf
	Else
		If Type('oempresa') = 'U' Then
			If !Directory( Cruta + "pdf") Then
				ccarpeta = Cruta + "pdf"
				Mkdir (ccarpeta)
			Endif
			carchivopdf = Addbs(Addbs(Sys(5) + Sys(2003)) + 'PDF') + filepdf
		Else
			If !Directory(Addbs(Cruta + 'pdf') + Alltrim(Oempresa.nruc)) Then
				ccarpeta = Addbs(Cruta + "pdf") + Alltrim(Oempresa.nruc)
				Mkdir (ccarpeta)
			Endif
			carchivopdf  = Addbs(Addbs(Addbs(Sys(5) + Sys(2003)) + 'PDF') + Alltrim(Oempresa.nruc)) + filepdf
		Endif
	Endif
	cpropiedad = "Impresoranormal"
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("Impresoranormal", "")
	Else
		lcImpresora = goApp.Impresoranormal
	Endif
	cpropiedad = "Impresionticket"
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("Impresionticket", "")
	Else
		lcImpresora = goApp.Impresoranormal
	Endif
	If !Empty(goApp.Impresoranormal) Then
		Declare Integer SetDefaultPrinter In WINSPOOL.DRV ;
			String pszPrinter
		lcImpresoraActual = ObtenerImpresoraActual()
		lcImpresora		  = goApp.Impresoranormal
		lnResultado		  = SetDefaultPrinter(lcImpresora)
		Set Printer To Name (lcImpresora)
		Report Form (np1) Object Type 10 To File (carchivopdf)
		Do Foxypreviewer.App With "Release"
		lnResultado = SetDefaultPrinter(lcImpresoraActual)
		Set Printer To Name (lcImpresoraActual)
	Else
		If goApp.ImpresionTicket = 'S' And np3 = 'S'  Then
			Declare Integer SetDefaultPrinter In WINSPOOL.DRV ;
				String pszPrinter
			lcImpresoraActual = ObtenerImpresoraActual()
			lcImpresora		  = Getprinter()
			If !Empty(lcImpresora) Then
				Set Printer To Name (lcImpresora)
				Report Form (np1) Object Type 10 To File (carchivopdf)
				Do Foxypreviewer.App With "Release"
				lnResultado = SetDefaultPrinter(lcImpresoraActual)
				Set Printer To Name (lcImpresoraActual)
			Endif
		Else
			Report Form (np1) Object Type 10 To File (carchivopdf)
		Endif
	Endif
	If np3 = 'S' Then
		abrirpdf(carchivopdf )
	Endif
	m.oFbc = Null
	Release Obj
	Do Foxypreviewer.App With "Release"
	Endproc
	Function cambiarimpresoranormal(creporte)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	cpropiedad = "Impresoranormal"
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("Impresoranormal", "")
	Else
		lcImpresora = goApp.Impresoranormal
	Endif
	If !Empty(goApp.Impresoranormal) Then
		Declare Integer SetDefaultPrinter In WINSPOOL.DRV ;
			String pszPrinter
		lcImpresoraActual = ObtenerImpresoraActual()
		lcImpresora		  = goApp.Impresoranormal
		lnResultado		  = SetDefaultPrinter(lcImpresora)
		Set Printer To Name (lcImpresora)
		If This.ConvistaPrevia = 'S' Then
			Report Form (creporte) Preview
		Else
			Report Form (creporte) To Printer Prompt Noconsole
		Endif
		lnResultado = SetDefaultPrinter(lcImpresoraActual)
		Set Printer To Name (lcImpresoraActual)
	Else
		If This.ConvistaPrevia = 'S' Then
			Report Form (creporte) Preview
		Else
			Report Form (creporte) To Printer Prompt Noconsole
		Endif
	Endif
	This.ConvistaPrevia = ""
	Endfunc
	Function ImprimeComprobantexx(objimp)
*!*		 cmodo, Clet, cndoc, nroitems, Nti, Cruc1, Crazon, cforma, Df, Creferencia, cguia, Cvendedor, dfv, chash, Cmoneda, Cdireccion, cdni, cTdoc, ccopia, ndias

	If Type('oempresa') = 'U' Then
		Cruc = fe_gene.nruc
	Else
		Cruc = Oempresa.nruc
	Endif
	Select tmpv
	Set Filter To
	Set Order To
	Go Top In tmpv
	ni = objimp.Nitems
	For x = 1 To objimp.ntitem - objimp.Nitems
		ni = ni + 1
		Insert Into tmpv(Ndoc, Nitem, cletras)Values(objimp.cndoc, ni, objimp.Cimporte)
	Next
	Replace All Ndoc With objimp.cndoc, cletras With objimp.Cimporte, ;
		nruc  With m.objimp.Cruc, razon With m.objimp.Crazon, Form With m.objimp.cforma, fech With Ctod(objimp.dFecha), Forma With m.objimp.cforma, ;
		Referencia With m.objimp.cdetalle, Ndo2 With m.objimp.cguia, Vendedor With objimp.Cvendedor, fechav With Ctod(objimp.dfevto), ;
		hash With m.objimp.chash, Mone With m.objimp.Cmoneda, Direccion With m.objimp.Cdireccion, ;
		dni With m.objimp.Cdni,Tdoc With m.objimp.cTdoc, dias With m.objimp.ndias, ;
		igv With objimp.nigv, valor With m.objimp.nvalor, Total With m.objimp.nTotal, exonerado With m.objimp.nexonerado In tmpv
	If Len(Alltrim(This.Cgarantia)) > 0 Then
		Replace All garantia With This.Cgarantia
	Endif
	If  fe_gene.ccopia = 'S' Then
		Select * From tmpv Into Cursor copiaor Readwrite
		Replace All copia With 'Z' In copiaor
		Select tmpv
		Append From Dbf("copiaor")
	Endif
	Cruta = Addbs(Addbs(Sys(5) + Sys(2003)) + Alltrim(Cruc))
	Select tmpv
	Go Top
	If  goApp.ImpresionTicket = 'S'
		Set Filter To !Empty(Coda)
		Go Top
		Do Case
		Case This.Tdoc = '07' Or This.Tdoc = '08'
			This.Archivo = Cruta + 'ticketn.frx'
		Otherwise
			This.Archivo = Cruta + 'ticket.frx'
			car = 'boleta.frx'
		Endcase
	Else
		Do Case
		Case This.Tdoc = '01'
			This.Archivo = Cruta + 'factura.frx'
			car = 'factura.frx'
		Case This.Tdoc = '03'
			This.Archivo = Cruta + 'boleta.frx'
			car = 'boleta.frx'
		Case This.Tdoc = '20'
			This.Archivo = Cruta + 'notasp.frx'
			car = 'pedido.frx'
		Case This.Tdoc = '07'
			This.Archivo = Cruta + 'notasc.frx'
			car = 'notasc.frx'
		Case This.Tdoc = '08'
			This.Archivo = Cruta + 'notasd.frx'
			car = 'notasd.frx'
		Case This.Tdoc = '09'
			This.Archivo = Cruta + 'guia.frx'
			car = 'guia.frx'
		Case This.Tdoc = 'OC'
			This.Archivo = Addbs(Sys(5) + Sys(2003) + '\Reports') + 'Ocompra.frx'
			car = 'ocompra.frx'
		Endcase
	Endif
	This.GeneraQR()
	Set Procedure To FoxbarcodeQR Additive
	m.oFbc = Createobject("FoxBarcodeQR")
	If objimp.cestado = 'S' Then
		If File(This.Archivo) Then
			Report Form (This.Archivo) To Printer Prompt Noconsole
		Else
			Report Form (car) To Printer Prompt Noconsole
		Endif
	Endif
	m.oFbc = Null
	Endproc
Enddefine























