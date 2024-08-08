#Define MSGTITULO "SISVEN"
Set Procedure To capadatos Additive
Define Class imprimir As Custom
	Archivo=""
	Tdoc=""
	ArchivoPDF=""
	TituloInforme=""
	SubtituloInforme=""
	concopia=""
	conformato=""
	ArchivoPordefecto=""
	Procedure ImprimeComprobante
	Lparameters cmodoimpresion
	Set Procedure To capadatos,foxbarcodeqr Additive
	m.oFbc = Createobject("FoxBarcodeQR")
	calias=""
	If Empty(This.ArchivoPordefecto) Then
		Do Case
		Case This.Tdoc='01'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'factura.frx'
			calias="tmpv"
			car='factura.frx'
		Case This.Tdoc='03'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'boleta.frx'
			car='boleta.frx'
			calias="tmpv"
		Case This.Tdoc='07'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'notasc.frx'
			calias="tmpv"
			car='notasc.frx'
		Case This.Tdoc='08'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'notasd.frx'
			car='notasd.frx'
			calias="tmpv"
		Case This.Tdoc='09'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'guia.frx'
			car='guia.frx'
			calias="tmpvg"
		Case This.Tdoc='OC'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\Reports\')+'Ocompra.frx'
			calias="otmpp"
			car='ocompra.frx'
		Case This.Tdoc='20'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'notasp.frx'
			car='notasp.frx'
			calias="tmpv"
		Case This.Tdoc='PR'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'proforma.frx'
			car='proforma.frx'
			calias="tmpv"
		Case This.Tdoc='TT'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'traspaso.frx'
			car='traspasos.frx'
			calias="tmpv"
		OTHERWISE
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'otros.frx'
			car='boleta.frx'
			calias="tmpv"
		Endcase
	Else
		carchivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+This.ArchivoPordefecto
		car='factura.frx'
		This.Archivo=carchivo
		calias="tmpv"
	Endif
	mensaje("Generando Documento")
	If verificaAlias(calias)=1  And !Empty(calias) Then
		Select (calias)
		Set Filter To
		Go Top
	Endif
	If cmodoimpresion='S' Then
		If File(This.Archivo) Then
			Report Form (This.Archivo) To Printer Prompt Noconsole
		Else
			Report Form (car) To Printer Prompt Noconsole
		Endif
	ENDIF
	Endproc

********************************
	Procedure ImprimeComprobantex
	Lparameters cmodo,Clet,cndoc,nroitems,Nti,Cruc,Crazon,cforma,df,creferencia,cguia,cvendedor,dfv,chash,cmoneda,cdireccion,cdni,ctdoc,ccopia,ndias
	Select tmpv
	Set Filter To
	Set Order To
	Go Top In tmpv
	ni=nroitems
	For x=1 To Nti-nroitems
		ni=ni+1
		Insert Into tmpv(ndoc,Nitem,cletras)Values(cndoc,ni,Clet)
	Next
	Replace All ndoc With cndoc,cletras With Clet,;
		nruc  With Cruc,razon With Crazon,Form With cforma,fech With df,Forma With cforma,;
		referencia With creferencia,ndo2 With cguia,vendedor With cvendedor,fechav With dfv,;
		hash With chash,mone With cmoneda,direccion With cdireccion,;
		dni With cdni,tigv With fe_gene.igv,Tdoc With ctdoc,dias WITH ndias In tmpv
	If  fe_gene.ccopia='S' Then
		Select * From tmpv Into Cursor copiaor Readwrite
		Replace All copia With 'Z' In copiaor
		Select tmpv
		Append From Dbf("copiaor")
	Endif
	Select tmpv
	Go Top
	Set Procedure To capadatos,foxbarcodeqr Additive
	m.oFbc = Createobject("FoxBarcodeQR")
	Select tmpv
	Go Top
	If  goapp.Impresionticket='S'
		Set Filter To !Empty(coda)
		Go Top
		Do Case
		Case This.Tdoc='07' Or This.Tdoc='08'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'ticketn.frx'
		Otherwise
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'ticket.frx'
			car='boleta.frx'
		Endcase
*	obji.ImprimeComprobanteComoTicket('S')
	Else

		Do Case
		Case This.Tdoc='01'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'factura.frx'
			car='factura.frx'
		Case This.Tdoc='03'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'boleta.frx'
			car='boleta.frx'
		Case This.Tdoc='20'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'notasp.frx'
			car='pedido.frx'
		Case This.Tdoc='07'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'notasc.frx'
			car='notasc.frx'
		Case This.Tdoc='08'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'notasd.frx'
			car='notasd.frx'
		Case This.Tdoc='09'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'guia.frx'
			car='guia.frx'
		Case This.Tdoc='OC'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\Reports')+'Ocompra.frx'
			car='ocompra.frx'
		Endcase

	Endif
	If cmodo='S' Then
		If File(This.Archivo) Then
			Report Form (This.Archivo) To Printer Prompt Noconsole
		Else
			Report Form (car) To Printer Prompt Noconsole
		Endif
	Endif
	Endproc
	Procedure ImprimeComprobanteM
	Lparameters cmodo
	cpropiedad="Conformato"
	If !Pemstatus(goapp,cpropiedad,5)
		goapp.AddProperty("Conformato","")
	Endif
	If cmodo='S' Then
		This.conformato=goapp.conformato
	Else
		This.conformato=""
	Endif

	If This.conformato='S' Then
		Do Case
		Case This.Tdoc='01'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\comp')+'factura.frx'
			car='factura.frx'
		Case This.Tdoc='03'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\comp')+'boleta.frx'
			car='boleta.frx'
		Case This.Tdoc='07'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'notasc.frx'
			car='notasc.frx'
		Case This.Tdoc='08'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'notasd.frx'
			car='notasd.frx'
		Case This.Tdoc='09'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\comp')+'guia.frx'
			car='guia.frx'
		Case This.Tdoc='20'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\comp')+'notasp.frx'
			car='notasp.frx'
		Case This.Tdoc='PR'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'proforma.frx'
			car='proforma.frx'
		Case This.Tdoc='OC'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'Ocompra.frx'
			car='ocompra.frx'
		Case This.Tdoc='TT'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'traspaso.frx'
			car='traspaso.frx'
		CASE this.Tdoc ='21'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'preventa.frx'
			car='pedidos.frx'
		Endcase
	Else
		Set Procedure To capadatos,foxbarcodeqr Additive
		m.oFbc = Createobject("FoxBarcodeQR")
		Do Case
		Case This.Tdoc='01'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'factura.frx'
			car='factura.frx'
		Case This.Tdoc='03'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'boleta.frx'
			car='boleta.frx'
		Case This.Tdoc='07'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'notasc.frx'
			car='notasc.frx'
		Case This.Tdoc='08'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'notasd.frx'
			car='notasd.frx'
		Case This.Tdoc='09'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'guia.frx'
			car='guia.frx'
		Case This.Tdoc='20'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'notasp.frx'
			car='notasp.frx'
		Case This.Tdoc='PR'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'proforma.frx'
			car='proforma.frx'
		Case This.Tdoc='OC'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'Ocompra.frx'
			car='ocompra.frx'
		Case This.Tdoc='TT'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'traspaso.frx'
			car='traspaso.frx'
		CASE this.Tdoc ='21'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'preventa.frx'
			car='pedidos.frx'
		Endcase
	Endif
	If cmodo='S' Then
	
		If File(This.Archivo) Then
			Report Form (This.Archivo) To Printer Prompt Noconsole
		Else
			Report Form (car) To Printer Prompt Noconsole
		Endif
	
		cpropiedad="Otraimpresionvtas"
		If !Pemstatus(goapp,cpropiedad,5)
			goapp.AddProperty("Otraimpresionvtas","")
		Endif
		cpropiedad="Otraimpresora"
		If !Pemstatus(goapp,cpropiedad,5)
			goapp.AddProperty("Otraimpresora","")
		Endif
		If goapp.Otraimpresionvtas='S' And !Empty(goapp.Otraimpresora) And Val(goapp.Tiendaconcopia)=goapp.tienda Then
			Declare Integer SetDefaultPrinter In WINSPOOL.DRV ;
				STRING pszPrinter
			lcImpresoraActual = ObtenerImpresoraActual()
			Set Printer To Name (Alltrim(goapp.Otraimpresora))
			Select * From tmpv Into Cursor cop
			Select cop
			Go Top
			Report Form notasp To Printer Noconsole
			lnResultado = SetDefaultPrinter(lcImpresoraActual)
			Set Printer To Name (Alltrim(lcImpresoraActual))
		ENDIF
		If goapp.Otraimpresionvtas='S' And !Empty(goapp.Otraimpresora1) And Val(goapp.Tiendaconcopia)=goapp.tienda Then
			Declare Integer SetDefaultPrinter In WINSPOOL.DRV ;
				STRING pszPrinter
			lcImpresoraActual = ObtenerImpresoraActual()
			Set Printer To Name (Alltrim(goapp.Otraimpresora1))
			Select * From tmpv Into Cursor cop
			Select cop
			Go Top
			Report Form notasp To Printer Noconsole
			lnResultado = SetDefaultPrinter(lcImpresoraActual)
			Set Printer To Name (Alltrim(lcImpresoraActual))
		ENDIF
	Endif
	Endproc
********************
	Procedure GeneraPDF
	Lparameters cmodo
	Set Procedure To capadatos,ple5 Additive
	*wait WINDOW This.Archivo
	*wait WINDOW This.ArchivoPDF
	CrearPdf(This.Archivo,This.ArchivoPDF,cmodo)
	Endproc





	Procedure ImprimirComprobanteTxt(ctdoc)
	Select tmpv
	Go Top
	ncomp=1
	F=0
	cprinter=Getprinter()
	Set Device To Print
	Set Console Off
	Set Printer To Name (cprinter)
	Do While !Eof()
		cndoc=tmpv.ndoc
		Set Printer Font "draft 17cpi", 10
		@F,10 Say goapp.usuario
		@F,20 Say "Referencia:"+Alltrim(tmpv.referencia)
		@F,110 Say Iif(ctdoc='01','Fac','Bol')+ tmpv.ndoc
		F=F+8.5
		@F,16 Say Rtrim(tmpv.razon)
		F=F+1
		@F,16 Say Rtrim(tmpv.direccion)
		F=F+1
		If ctdoc="01"
			@F,16 Say tmpv.nruc
		Else
			@F,16 Say Rtrim(tmpv.dni)
		Endif
		@F,100 Say Alltrim(Str(Day(tmpv.fech)))+' de  '+Alltrim(cmes(tmpv.fech))+'  de '+Alltrim(Str(Year(tmpv.fech)))
		F=F+2
		@F,25 Say Rtrim(tmpv.Forma)
		@F,65 Say Rtrim(tmpv.vendedor)
		@F,130 Say tmpv.ndo2
		Cimporte=Alltrim(tmpv.cletras)
		cforma=Left(Alltrim(tmpv.Forma),1)
		df=tmpv.fech
		cancelado=Alltrim(Iif(cforma='E',Left(Dtoc(df),2)+'   '+Substr(Dtoc(df),4,2)+'    '+Alltrim(Substr(Dtoc(df),7)),""))
		xtot=0
*Fila 15
		F=F+3
		Do While !Eof() And tmpv.ndoc=cndoc
			If tmpv.cant>0 Then
				ccant=Iif(tmpv.cant%1>0,Alltrim(Str(tmpv.cant,10,2)),Alltrim(Str(Int(tmpv.cant))))
				@F,2   Say ccant
				@F,10  Say Alltrim(tmpv.duni)
				@F,30  Say Alltrim(tmpv.codigo1)+' '+Alltrim(tmpv.Desc)
				@F,110  Say Str(tmpv.Prec,8,2)
				@F,120 Say Str(Round(tmpv.cant*tmpv.Prec,2),10,2)
				xtot=xtot+Round(tmpv.cant*tmpv.Prec,2)
			Endif
			F=F+1
			Skip
		Enddo
		If ctdoc="01" Then
			@F,7  Say Alltrim(Cimporte)
			@F,120 Say Str(Round(xtot/fe_gene.igv,2),10,2)
			F=F+1
			@F,115 Say Str((fe_gene.igv*100)-100,2)
			@F,120 Say Str(Round(xtot-(xtot/fe_gene.igv),2), 10,2)
			F=F+1
			@F,120 Say Str(Round(xtot,2),10,2)
			F=F+2.5
			@F,54 Say cancelado
		Else
			F=F+2
			@F,7  Say Alltrim(Cimporte)
			@F,120 Say Str(Round(xtot,2),10,2)
			F=F+2.5
			@F,54 Say cancelado
		Endif
		ncomp=ncomp+1
		If ncomp=2 And F<=35 Then
			F=F+3
		Else
			ncomp=1
			F=0
		Endif
	Enddo
	Close Print
	Set Console On
	Set Printer To
	Set Device To Screen
	Endproc
	Procedure ElijeFormato
	If Empty(This.ArchivoPordefecto) Then
		Do Case
		Case This.Tdoc='01'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'factura.frx'
		Case This.Tdoc='03'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'boleta.frx'
		Case This.Tdoc='07'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'notasc.frx'
		Case This.Tdoc='08'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'notasd.frx'
		Case This.Tdoc='09'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'guia.frx'
		Case This.Tdoc='PR'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'cotizacion.frx'
		Case This.Tdoc='OC'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'Ocompra.frx'
		Case This.Tdoc='20'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'notasp.frx'
		Case This.Tdoc='AJ'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'notasp.frx'
		Case This.Tdoc='TT'
			This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'traspaso.frx'
		Endcase
	Else
		carchivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+This.ArchivoPordefecto
		car='factura.frx'
		This.Archivo=carchivo
	Endif
	Endproc

	Procedure ElijeFormatoM
	Do Case
	Case This.Tdoc='01'
		This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'factura.frx'
	Case This.Tdoc='03'
		This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'boleta.frx'
	Case This.Tdoc='07'
		This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'notasc.frx'
	Case This.Tdoc='08'
		This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'notasd.frx'
	Case This.Tdoc='09'
		This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'guia.frx'
	Case This.Tdoc='PR'
		This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'cotizacion.frx'
	Case This.Tdoc='OC'
		This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'ocompra.frx'
	Case This.Tdoc='20'
		This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'notasp.frx'
	Case This.Tdoc='TT'
		This.Archivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'traspaso.frx'
	Endcase
	Endproc


	Procedure ImprimeComprobanteComoTicket
	Lparameters cmodo
	Set Procedure To capadatos,foxbarcodeqr Additive
	m.oFbc = Createobject("FoxBarcodeQR")
	Do Case
	Case This.Tdoc='07' Or This.Tdoc='08'
		carchivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'ticketn.frx'
	Case This.Tdoc='21'
		carchivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'ticketp.frx'
	Case This.Tdoc='TT'
		carchivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'ticketT.frx'
	Otherwise
		carchivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(fe_gene.nruc))+'ticket.frx'
	Endcase
	Report Form (carchivo) To Printer Prompt Noconsole
	Endproc
************************
	Procedure ImprimeComprobanteComoticketM
	Lparameters cmodo,cctdoc
	Set Procedure To capadatos,foxbarcodeqr Additive
	m.oFbc = Createobject("FoxBarcodeQR")
	If Vartype(cctdoc)='C'
		Do Case
		Case  cctdoc='SC'
			carchivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'ticketp.frx'
		Case  cctdoc='20'
			carchivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'ticket.frx'
		Case cctdoc='07' Or cctdoc='08'
			carchivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'ticketn.frx'
		CASE cctdoc='21'
			carchivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'preventa.frx'
		Otherwise
			carchivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'ticket.frx'
		Endcase
	Else
		carchivo= Addbs(Sys(5)+Sys(2003)+'\'+Alltrim(oempresa.nruc))+'ticket.frx'
	Endif
	Select tmpv
	Go Top
	Report Form (carchivo) To Printer Prompt Noconsole
	Endproc
***************
	Procedure CrearPdfOrdenCompra(np1,np2,np3)
	Private oFbc
	Obj=Createobject("custom")
	Obj.AddProperty("ArchivoXml")
	Obj.ArchivoXml=""
	Set Procedure To capadatos,foxbarcodeqr Additive
	m.oFbc = Createobject("FoxBarcodeQR")
	Do "FoxyPreviewer.App"
	carch = Addbs(Sys(5)+Sys(2003)+'\OrdenCompra\')+np2
	Select otmpp
	Go Top
	Report Form (np1) Object Type 10 To File (carch)
	Do foxypreviewer.App With "Release"
	If np3='S' Then
		Set Procedure To capadatos,abrirpdf Additive
		abrirpdf(carch)
	Endif
	m.oFbc=Null
	Release Obj
	Endproc
********************
	Procedure CrearPdfCotizaciones(np1,np2,np3)
	Private oFbc
	Obj=Createobject("custom")
	Obj.AddProperty("ArchivoXml")
	Obj.ArchivoXml=""
	Set Procedure To capadatos,foxbarcodeqr Additive
	m.oFbc = Createobject("FoxBarcodeQR")
	Do "FoxyPreviewer.App"
	carch = Addbs(Sys(5)+Sys(2003)+'\Cotizaciones\')+np2
	Report Form (np1) Object Type 10 To File (carch)
	Do foxypreviewer.App With "Release"
	If np3='S' Then
		Set Procedure To capadatos,abrirpdf Additive
		abrirpdf(carch)
	Endif
	m.oFbc=Null
	Release Obj
	Endproc

Enddefine
***********************
Function TL(mcTam)
??? Chr(27)+Chr(48)+Chr(27)+Chr(67)+Chr(44)
Do Case
Case mcTam=='GR'
*Fuente Extra Grande 6CPP  CARTA=46 COLUMAS
	??? Chr(13)+Chr(18)+Chr(27)+Chr(77)+Chr(18)+Chr(14)
Case mcTam=='M1'
*Fuente Mediana 10CPP CARTA=80 COLUMNAS RECOMENDADO=78 COLUMNAS
	??? Chr(18)+Chr(27)+Chr(80)
Case mcTam=='M2'
*Fuente Tamaño 13CPP  CARTA=94 COLUMNAS
	??? Chr(18)+Chr(27)+Chr(77)
Case mcTam=='CH'
*Fuente Pequeña 20CPP CARTA=160 COLUMNAS
	???  Chr(18)+Chr(27)+Chr(77)+Chr(15)
Otherwise
*Si no es ninguna de las Anteriores, Es un Espacio.
	??? Chr(10)+Chr(13)
Endcase
Endfunc
****************************
Function EnviarCorreo(ccorreo,carfile,cfilepdf,ctdoc,cndoc,cnrucc,dfecha)
scorreo=DevuelveServidorCorreo()
If Empty(scorreo) Then
	Messagebox("Correo Electrónico de Salida no Configurado")
	Return
Endif
npos=At(".",carfile)
carpdf=Left(carfile,npos-1)+'.Pdf'
obji=Createobject("Imprimir")
obji.Tdoc=rmvtos.Tdoc
obji.ImprimeComprobanteM('N')
obji.ArchivoPDF=carpdf
obji.GeneraPDF('N')
If Type('oempresa')='U' Then
	cpdf=Addbs(Sys(5)+Sys(2003)+'\PDF')+carpdf
	carchivo1=Addbs(Sys(5)+Sys(2003)+'\FirmaXML')+carfile
	cempresa=Alltrim(fe_gene.empresa)
	Cruc=Alltrim(fe_gene.nruc)
Else
	cpdf=Addbs(Sys(5)+Sys(2003)+'\PDF\'+Alltrim(oempresa.nruc)+"\")+carpdf
	carchivo1=Addbs(Sys(5)+Sys(2003)+'\FirmaXML\'+Alltrim(oempresa.nruc)+"\")+carfile
	cempresa=Alltrim(oempresa.empresa)
	Cruc=Alltrim(oempresa.nruc)
Endif
loMail = Createobject("Cdo2000")
With loMail
	If Upper(scorreo)=="GMAIL" Then
		.cServer = "smtp.gmail.com"
		.nServerPort = 465 &&gmail
	Else
		.cServer = "smtp.live.com"
		.nServerPort = 25 &&Hotmail.com
	Endif
	.lUseSSL = .T.

	.nAuthenticate = 1 	&& cdoBasic
	If Type('oempresa')='U' Then
		.cUserName = Alltrim(fe_gene.correo)
		.cPassword = Alltrim(fe_gene.gene_ccor)
	Else
		.cUserName = Alltrim(oempresa.correo)
		.cPassword = Alltrim(oempresa.gene_ccor)
	Endif
	.cFrom = .cUserName
	.cTo = rmvtos.clie_corr
	.cSubject = "EMISIÓN DEL COMPROBANTE DE PAGO ELECTRÓNICO:" +rmvtos.ndoc

	ctexto="Por la presente le comunicamos que la empresa "+ Alltrim(cempresa)+"  emisora de comprobantes electrónicos le ha emitido el siguiente comprobante:" +Chr(13)
&&se usa cunado se va enviar solo texto

	ctexto=ctexto+"Tipo de Documento:"+Icase(ctdoc='01',"FACTURA",ctdoc='03',"BOLETA",ctdoc='07',"Nota de Crédito","Nota de Debito")+ Chr(13)
	ctexto=ctexto+"Serie y número:" +Alltrim(cndoc)+Chr(13)
	ctexto=ctexto+"RUC del emisor :"+Alltrim(Cruc)+Chr(13)
	ctexto=ctexto+"RUC o DNI del Cliente:"+Alltrim(cnrucc) +Chr(13)
	ctexto=ctexto+"Fecha de emisión:"+Alltrim(Dtoc(dfecha))



	lcHTML = "<HTML>" + ctexto + "</HTML>"
	lcHTML = Strtran(lcHTML, "contentEditable=true", "")
	.cHtmlBody = lcHTML




	carchivo2=cpdf
	.cAttachment   = carchivo1+","+carchivo2
	cRecep = ""
	cPrioridad = "High"
	.cReplyTo  = cRecep
	.cPriority = cPrioridad
Endwith
If loMail.Send() > 0
	For i=1 To loMail.GetErrorCount()
		Messagebox(Alltrim(Str(i))+" - "+loMail.Geterror(i),16,"Error...")
	Endfor
Else
	Messagebox("Se envio correctamente el correo:"+ccorreo,64,"Infromacion...")
Endif
***********************************