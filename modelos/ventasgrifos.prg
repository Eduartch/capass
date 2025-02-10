Define Class ventasgrifos As Ventas  Of 'd:\capass\modelos\ventas.prg'
	nturno = 0
	Idlectura = 0
	Function vtascomparativas(nidt, fi, ff, Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
        \Select Fecha,Sum(ventalectura) As ventalectura,Sum(ventafacturada) As ventafacturada From(
		\Select  lect_fech As Fecha,Sum(lect_mfinal-lect_inim) As ventalectura,Cast(0 As Decimal(12,2)) As ventafacturada
		\From fe_lecturas F Where lect_fech Between '<<fi>>' And '<<ff>>'  And lect_acti='A' And lect_idtu=<<nidt>> And lect_mfinal>0 And lect_inim>0 Group By lect_fech
		\Union All
		\Select lcaj_fech As Fecha,Cast(0 As Decimal(12,2)) As ventalectura,Sum(lcaj_deud) As ventafacturada
		\From fe_lcaja Where lcaj_fech Between '<<dfi>>' And '<<ff>>' And lcaj_deud<>0 And lcaj_acti='A'
		\And lcaj_idau>0
	If nidt > 0 Then
		\And lcaj_idtu=<<nidt>>
	Endif
		\ Group By lcaj_fech) As F Group By Fecha
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function canjearguiasporfacturas()
	Local Sw As Integer
	If This.validarcanjeguias() < 1 Then
		Return 0
	Endif
	Set Classlib To "d:\librerias\fe" Additive
	ocomp = Createobject("comprobante")
	If VerificaAlias("cabecera") = 1 Then
		Zap In cabecera
	Else
		Create Cursor cabecera(idcab N(8))
	Endif
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If This.actualizardesdeguias() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Sw = 1
	Select  tmpp
	Scan All
		Text To lC Noshow  Textmerge
	     UPDATE fe_kar SET prec=<<tmpp.prec>> where idkar=<<tmpp.nreg>>
		Endtext
		If This.Ejecutarsql(lC) < 1 Then
			Sw = 0
			Exit
		Endif
	Endscan
	If Sw = 0 Then
		Return 0
	Endif
	If This.GeneraCorrelativo(This.Serie + This.numero, This.Idserie) < 1  Then
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.GRabarCambios() = 0 Then
		Return 0
	Endif
	ocomp.Version = '2.1'
	Try
		Select cabecera
		Scan All
			Do Case
			Case  This.Tdoc = '01'
				vdx = ocomp.obtenerdatosfactura(cabecera.idcab, Iif(fe_gene.gene_cpea = 'N', 'SF', .F.))
			Case This.Tdoc = '03'
				vdx = ocomp.obtenerdatosBoleta(cabecera.idcab, 'SF')
			Endcase
		Endscan
	Catch To oErr When oErr.ErrorNo = 1429
		Messagebox(MENSAJE1 + MENSAJE2 + MENSAJE3, 16, MSGTITULO)
	Catch To oErr When oErr.ErrorNo = 1924
		Messagebox(MENSAJE1 + MENSAJE2 + MENSAJE3, 16, MSGTITULO)
	Finally
	Endtry
	This.imprimirdctocanjeado()
	Zap In cabecera
	Return 1
	Endfunc
	Function actualizardesdeguias()
	cform = Left(This.formaPago, 1)
	ndolar = fe_gene.dola
	ni = fe_gene.igv
	nidusua = goApp.nidusua
	nidtda = goApp.Tienda
	If This.Tdoc = '01' Or This.Tdoc = '03' Then
		nidcta1 = fe_gene.idctav
		nidcta2 = fe_gene.idctai
		nidcta3 = fe_gene.idctat
	Else
		nidcta1 = 0
		nidcta2 = 0
		nidcta3 = 0
	Endif
	If This.ActualizaresumentDctoCanjeado(This.Tdoc, cform, This.Serie + This.numero, This.Fecha, This.Fecha, This.Detalle, ;
			  This.valor, This.igv, This.Monto, This.NroGuia, This.Moneda, ndolar, fe_gene.igv, 'k', This.Codigo, 'V', goApp.nidusua, 1, goApp.Tienda, nidcta1, nidcta2, nidcta3, This.Iddire, This.idautoguia, This.Idauto) < 1 Then
		Return 0
	Endif
	If IngresaDatosLCajaEFectivo12(This.Fecha, "", This.razon, nidcta3, This.Monto, 0, 'S', fe_gene.dola, goApp.nidusua, This.Codigo, This.Idauto, cform, This.Serie + This.numero, This.Tdoc, goApp.Tienda) = 0 Then
		Return 0
	Endif
	If cform = 'E' Then
		If IngresaRvendedores(This.Idauto, This.Codigo, goApp.nidusua, cform) = 0 Then
			Return 0
		Endif
	Endif
	If cform = 'C' Or cform = 'D' Then
		Set Procedure To d:\capass\modelos\ctasxcobrar.prg Additive
		ocre = Createobject("ctasporcobrar")
		ocre.dFech = This.Fecha
		ocre.Fechavto = This.Fechavto
		ocre.nimpo = This.Monto
		ocre.nimpoo = This.Monto
		ocre.tipodcto = 'F'
		ocre.crefe = "VENTA AL CREDITO"
		ocre.cndoc = This.Serie + This.numero
		ocre.nidclie = This.Codigo
		ocre.Idauto = This.Idauto
		ocre.Codv = goApp.nidusua
		If ocre.registrar() < 1 Then
			Return 0
		Endif
	Endif
	Insert Into cabecera(idcab)Values(This.Idauto)
	Return 1
	Endfunc
	Function imprimirdctocanjeado()
	Select * From tmpp Into Cursor tmpv Readwrite
	Select tmpv
	Replace All cletras With This.cletras, ;
		hash With This.hash, Archivo With This.ArchivoXml, fech With This.Fecha In tmpv
	Select tmpv
	Go Top In tmpv
	Set Procedure To Imprimir Additive
	obji = Createobject("Imprimir")
	obji.Tdoc = This.Tdoc
	obji.ArchivoPdf = This.ArchivoPdf
	obji.ElijeFormato()
	obji.GeneraPDF("")
	obji.ImprimeComprobante('S')
	If !Empty(This.correo) Then
*.comprobante1.enviarcorreocliente(.comprobante1.correo)
	Endif
	Endfunc
	Function validarcanjeguias()
	Do Case
	Case This.Idauto = 0
		This.Cmensaje = "Seleccione un Documento para Canje"
		Return 0
	Case  This.idautoguia = 0
		This.Cmensaje = "Seleccione una Guia de Remisión para Canje"
		Return 0
	Case PermiteIngresoVentas(This.Serie + This.numero, This.Tdoc, 0, This.Fecha) = 0
		This.Cmensaje = "Número de Documento de Venta Ya Registrado"
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function ActualizaresumentDctoCanjeado(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25)
	lsql = 'ProActualizaCanjeguia'
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara9 = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	goApp.npara12 = np12
	goApp.npara13 = np13
	goApp.npara14 = np14
	goApp.npara15 = np15
	goApp.npara16 = np16
	goApp.npara17 = np17
	goApp.npara18 = np18
	goApp.npara19 = np19
	goApp.npara20 = np20
	goApp.npara21 = np21
	goApp.npara22 = np22
	goApp.npara23 = np23
	goApp.npara24 = np24
	goApp.npara25 = np25
	Text To lparms Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
	Endtext
	If This.EJECUTARP(lsql, lparms, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ValidarVtasGrifos()
	Local lo
	x = 'C'
	Set Procedure To d:\capass\modelos\ctasxcobrar Additive
	ctasxcobrar = Createobject('ctasporcobrar')
	Select (This.temporal)
	Locate For cant = 0 And !Empty(Coda)
	Do Case
	Case !esfechaValida(This.Fecha) Or Month(This.Fecha) <> goApp.mes Or Year(This.Fecha) <> Val(goApp.año)
		This.Cmensaje = "Fecha NO Permitida Por el Sistema"
		lo = 0
	Case This.Monto = 0 And This.gratuita = 0
		This.Cmensaje = "Ingrese Cantidad y Precio"
		lo = 0
	Case This.Monto < 5 And This.Tdoc = '01' And This.gratuita = 0
		This.Cmensaje = "Se Emite Factura a Partir de S/5.00"
		lo = 0
	Case This.Monto < 1 And This.Tdoc = '03'  And This.gratuita = 0
		This.Cmensaje = "Se Emite Boleta a Partir de S/1.00"
		lo = 0
	Case This.sinstock = "S"
		This.Cmensaje = "Hay Un Item que No tiene Stock Disponible"
		lo = 0
	Case Found()
		This.Cmensaje = "El producto:" + Alltrim(tmpv.Desc) + " no Tiene Cantidad o Precio"
		lo = 0
	Case PermiteIngresox(This.Fecha) = 0
		This.Cmensaje = "NO Es posible Registrar en esta Fecha estan bloqueados Los Ingresos"
		lo = 0
	Case This.nroformapago = 2  And This.dias = 0
		This.Cmensaje = "Ingrese Los días de Vencimiento de Crédito"
		lo = 0
	Case  !esFechaValidafvto(This.Fechavto)
		This.Cmensaje = "Fecha de Vencimiento no Válida"
		lo = 0
	Case This.nroformapago = 4 And  ctasxcobrar.verificasaldocliente(This.Codigo, This.Monto) = 0
		This.Cmensaje = ctasxcobrar.Cmensaje
		lo = 0
	Case This.nroformapago = 2 And  ctasxcobrar.vlineacredito(This.Codigo, This.Monto, This.lineacredito) = 0
		If goApp.Validarcredito <> 'N' Then
			Do Form V_verifica With "A" To xv
			If !xv
				This.Cmensaje = "No esta Autorizado a Ingresar Este Documento"
				lo = 0
			Else
				lo = 1
			Endif
		Else
			lo = 1
		Endif
	Otherwise
		lo = 1
	Endcase
	If lo = 1 Then
		Return .T.
	Else
		Return .F.
	Endif
	Endfunc
	Function listardctonotascredtito(nid, Ccursor)
	Text To lC Noshow Textmerge
	    SELECT a.idart,a.descri,a.unid,k.cant,k.prec,
		ROUND(k.cant*k.prec,2) as importe,k.idauto,r.mone,r.valor,r.igv,r.impo,kar_comi as comi,k.alma,
		r.fech,r.ndoc,r.tdoc,r.dolar as dola,r.vigv,r.rcom_exon,'K' as tcom,k.idkar,if(k.prec=0,kar_cost,0) as costoref from fe_rcom r
		inner join fe_kar k on k.idauto=r.idauto
		inner join fe_art a on a.idart=k.idart
		where k.acti='A' and r.acti='A' and r.idauto=<<nid>>
		union all
		SELECT cast(0 as unsigned) as idart,k.detv_desc as descri,'.' as unid,k.detv_cant as cant,k.detv_prec as prec,
		ROUND(k.detv_cant*k.detv_prec,2) as importe,r.idauto,r.mone,r.valor,r.igv,r.impo,cast(0 as unsigned) as comi,
		cast(1 as unsigned) as alma,r.fech,r.ndoc,r.tdoc,r.dolar as dola,r.vigv,r.rcom_exon,'S' as tcom,detv_idvt as idkar,CAST(0 as decimal(6,2)) as costRef
		from fe_rcom r
		inner join fe_detallevta k on k.detv_idau=r.idauto
		where k.detv_acti='A' and r.acti='A' and r.idauto=<<nid>> order by idkar
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function GrabarIdjornaly(np1)
	Text To cupdate Noshow Textmerge
        update venta  set estado=2 where idjournal=<<np1>>
	Endtext
	If This.Ejecutarsql(cupdate) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarvtascreditocantidad(dfi, dff, nidus, nisla, nidl, Calias)
	fi = Cfechas(dfi)
	ff = Cfechas(dff)
	Set Textmerge On
	Set  Textmerge To Memvar lC Nosho Textmerge
		\   Select a.Ndoc,a.fech,c.razo,d.Descri,d.unid,e.cant,e.Prec,F.nomb As usuario,Cast(e.cant*e.Prec As Decimal(12,2)) As Impo,
	    \   a.Deta,a.fusua,kar_idco,a.codt As Isla,'credito' As tipo From
	    \   fe_rcom As a
	    \   inner Join fe_clie As c On c.idclie=a.idcliente
	    \ 	inner Join fe_kar As e On e.Idauto=a.Idauto
		\	inner Join fe_art As d On d.idart=e.idart
	    \	inner Join fe_usua As F On F.idusua=a.idusua
	    \	Where rcom_idis=<<nidl>> And a.Acti='A' And e.Acti='A' And a.Form='C' And kar_idco>0  And codt=<<nisla>>
	If nidus > 0 Then
	       \And a.idusua=<<nidus>>
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function grabarvtacombustibles()
	dATOSGLOBALES()
	nrot = Iif(Vartype("goapp.nroturnos") = 'C', Val(goApp.Nroturnos), goApp.Nroturnos)
	Do Case
	Case  nrot = 2
		If Hour(Datetime()) = 0 Or Hour(Datetime()) = 1 Or Hour(Datetime()) = 2 Or Hour(Datetime()) = 3 Or Hour(Datetime()) = 4 Or Hour(Datetime()) = 5  Then
			If Hour(Datetime()) <= 4
				dfe1 = This.Fecha - 1
			Else
				dfe1 = This.Fecha
			Endif
		Else
			If Hour(Datetime()) = 6  And fe_gene.alma_Sepa = 3 Then
				dfe1 = This.Fecha - 1
			Else
				dfe1 = This.Fecha
			Endif
		Endif
	Case nrot = 3
		If Hour(Datetime()) = 0 Or Hour(Datetime()) = 1 Or Hour(Datetime()) = 2 Or Hour(Datetime()) = 3 Or Hour(Datetime()) = 4 Or Hour(Datetime()) = 5 Or Hour(Datetime()) = 6  Then
			If Hour(Datetime()) <= 5
				dfe1 = This.Fecha - 1
			Else
				dfe1 = This.Fecha
			Endif
		Else
			If Hour(Datetime()) = 6  And fe_gene.alma_Sepa = 3 Then
				dfe1 = This.Fecha - 1
			Else
				dfe1 = This.Fecha
			Endif
		Endif
	Case nrot = 4
		dfe1 = This.Fecha
	Otherwise
		If Hour(Datetime()) = 0 Or Hour(Datetime()) = 1 Or Hour(Datetime()) = 2 Or Hour(Datetime()) = 3 Or Hour(Datetime()) = 4 Or Hour(Datetime()) = 5 Or Hour(Datetime()) = 6  Then
			If Hour(Datetime()) <= 6
				dfe1 = This.Fecha - 1
			Else
				dfe1 = This.Fecha
			Endif
		Else
			If Hour(Datetime()) = 7  And fe_gene.tama = 2 Then
				dfe1 = This.Fecha - 1
			Else
				dfe1 = This.Fecha
			Endif
		Endif
	Endcase
	dfe1 = This.Fecha
	dFecha = This.Fecha
	.Swcreditos = 1
	.NAuto = 0
	If .Tdoc = '01' Or .Tdoc = '03' Then
		nidcta1 = fe_gene.idctav
		nidcta2 = fe_gene.idctai
		nidcta3 = fe_gene.idctat
	Else
		nidcta1 = 0
		nidcta2 = 0
		nidcta3 = 0
	Endif
	If This.Etarjeta > 0 Then
		necaja = This.Impo - This.Etarjeta
	Else
		necaja = This.Impo
	Endif
	Select tmpv
	Set Filter To Coda <> 0
	Go Top
	calma = tmpv.Isla
	If oconecta.consucursales = 'S' Then
		ncodt = goApp.Tienda
	Else
		ncodt = goApp.Isla
	Endif
	Set Procedure To CapaDatos, rngrifo, ple5 Additive
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If This.tipoventa = 'E' Then
		If goApp.Direcciones = 'S' Then
			NAuto = This.ovtas.IngresaDocumentoElectronicocondirecciones(.Tdoc, .Forma, .Ndoc, .Fecha, .Detalle, 0, 0, .Impo, .Guia, ;
				  .Moneda, .dolar, 1, 'k', .Codigo, goApp.IDturno, goApp.nidusua, goApp.Tienda, nidcta1, nidcta2, nidcta3, .tgratuitas, 0, .valor, This.Tdscto, This.Iddire)
		Else
			NAuto = IngresaDocumentoElectronico(.Tdoc, .Forma, .Ndoc, .Fecha, .Detalle, 0, 0, .Impo, .Guia, .Moneda, .dolar, 1, 'k', .Codigo, goApp.IDturno, goApp.nidusua, ncodt, nidcta1, nidcta2, nidcta3, .tgratuitas, This.Idlectura, .valor, This.Tdscto)
		Endif
	Else
		If goApp.Direcciones = 'S' Then
			NAuto = This.ovtas.IngresaDocumentoElectronicocondirecciones(.Tdoc, .Forma, .Ndoc, .Fecha, .Detalle, .valor, .igv, .Impo, .Guia, ;
				  .Moneda, .dolar, fe_gene.igv, 'k', .Codigo, goApp.IDturno, goApp.nidusua, goApp.Tienda, nidcta1, nidcta2, nidcta3, .tgratuitas, 0, 0, This.Tdscto, This.Iddire)
		Else
			NAuto = IngresaDocumentoElectronico(.Tdoc, .Forma, .Ndoc, .Fecha, .Detalle, .valor, .igv, .Impo, .Guia, .Moneda, .dolar, fe_gene.igv, 'k', .Codigo, goApp.IDturno, goApp.nidusua, ncodt, nidcta1, nidcta2, nidcta3, .tgratuitas, This.Idlectura, 0, This.Tdscto)
		Endif
	Endif
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.Tdscto > 0 Then
		If IngresaDatosLCajaEFectivoCturnos20(dfe1, "", .razon, nidcta3, necaja, 0, 'S', fe_gene.dola, goApp.nidusua, .Codigo, .NAuto, Left(.Forma, 1), .Ndoc, .Tdoc, ncodt, goApp.IDturno, This.Tdscto, This.Creferencia, This.Ctarjeta, This.CtarjetaBanco) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Else
		If IngresaDatosLCajaEFectivoCturnosTarjetas(dfe1, "", .razon, nidcta3, necaja, 0, 'S', fe_gene.dola, goApp.nidusua, .Codigo, .NAuto, Left(.Forma, 1), .Ndoc, .Tdoc, ncodt, goApp.IDturno, This.Creferencia, This.Ctarjeta, This.CtarjetaBanco) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If This.Etarjeta > 0 Then
		If IngresaDatosLCajaEFectivoCturnos(dfe1, "", .razon, nidcta3, .Etarjeta, 0, 'S', fe_gene.dola, goApp.nidusua, .Codigo, .NAuto, 'E', .Ndoc, .Tdoc, ncodt, goApp.IDturno) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If This.Forma = "C" Or This.Forma = "D" Or This.Forma = 'A' Then
		If This.grabacreditos() = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	Na = NAuto
	If goApp.Promopuntos = 'S' Then
		_Screen.opromo.niDAUTO = Na
		_Screen.opromo.nidclie = This.Codigo
		_Screen.opromo.npunto = This.puntos
		_Screen.opromo.ndscto = 0
		_Screen.opromo.dFecha = This.Fecha
		_Screen.opromo.nidprom = _Screen.idpromo
		If _Screen.opromo.registrarpuntos() < 1 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	swk = 1
	Select tmpv
	Go Top
	Do While !Eof()
		If IngresaKardexGrifo(Na, tmpv.Coda, 'V', tmpv.Prec, tmpv.cant, 'I', 'K', .Codv, goApp.Tienda, tmpv.nidcontometro, tmpv.costo / fe_gene.igv, tmpv.pre1) < 1
			swk = 0
			Exit
		Endif
		If goApp.ConectaControlador = 'Y' Then
			If tmpv.Idjournal > 0 Then
				If _Screen.oventasg.GrabarIdjornaly(tmpv.Idjournal) < 1 Then
					swk = 0
					Exit
				Endif
			Endif
		Endif
		Select tmpv
		Skip
	Enddo
	If swk = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If swk = 1 And .GeneraNumero() = 1  Then
		If This.GRabarCambios() < 1 Then
			Return 0
		Endif
		If goApp.ConectaControlador = 'S'   Then
			GrabarIdjornal(This.Idjornal)
		Endif
		Return This.NAuto
	Endif
	Endfunc
	Function GrabarVtascontroladory()
	goApp.datosg = ""
	dATOSGLOBALES()
	NAuto = 0
	If This.Etarjeta > 0 Then
		necaja = This.Monto - This.Etarjeta
	Else
		necaja = This.Monto
	Endif
	Select tmpv
	Set Filter To Coda <> 0
	Go Top
	calma = tmpv.Isla
	Set Procedure To CapaDatos, rngrifo, ple5 Additive
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If goApp.ConectaControlador = 'Y' Then
		NAuto = This.IngresaDocumentoElectronicoy()
	Else
		NAuto = IngresaDocumentoElectronico(This.Tdoc, This.formaPago, This.Serie + This.numero, This.Fecha, This.Detalle, This.valor, This.igv, This.Monto, This.NroGuia, This.Moneda, This.ndolar, fe_gene.igv, 'k', This.Codigo, goApp.IDturno, goApp.nidusua, This.codt, This.cta1, This.cta2, This.cta3, This.gratuita, This.Idlectura, This.exonerado, This.Tdscto)
	Endif
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.Tdscto > 0 Then
		If IngresaDatosLCajaEFectivoCturnos30(This.Fecha, "", This.razon, This.cta3, necaja, 0, 'S', fe_gene.dola, goApp.nidusua, This.Codigo, NAuto, Left(This.formaPago, 1), This.Serie + This.numero, This.Tdoc, This.codt, goApp.IDturno, This.Tdscto, This.Creferencia, This.Ctarjeta, This.CtarjetaBanco, This.Idlectura) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Else
		If IngresaDatosLCajaEFectivoCturnosTarjetas30(This.Fecha, "", This.razon, This.cta3, necaja, 0, 'S', fe_gene.dola, goApp.nidusua, This.Codigo, NAuto, Left(This.formaPago, 1), This.Serie + This.numero, This.Tdoc, This.codt, goApp.IDturno, This.Creferencia, This.Ctarjeta, This.CtarjetaBanco, This.Idlectura) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If This.Etarjeta > 0 Then
		If IngresaDatosLCajaEFectivoCturnos31(This.Fecha, "", This.razon, This.cta3, This.Etarjeta, 0, 'S', fe_gene.dola, goApp.nidusua, This.Codigo, NAuto, 'E', This.Serie + This.numero, This.Tdoc, This.codt, goApp.IDturno, This.Idlectura) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If Left(This.formaPago, 1) = "C" Or Left(This.formaPago, 1) = "D" Or Left(This.formaPago, 1) = 'A' Then
		If This.grabacreditos(NAuto) < 1 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If goApp.Promopuntos = 'S' Then
		_Screen.opromo.niDAUTO = NAuto
		_Screen.opromo.nidclie = This.Codigo
		_Screen.opromo.npunto = This.puntos
		_Screen.opromo.ndscto = 0
		_Screen.opromo.dFecha = This.Fecha
		_Screen.opromo.nidprom = _Screen.idpromo
		If _Screen.opromo.registrarpuntos() < 1 Then
			This.Cmensaje = _Screen.opromo.Cmensaje
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	swk = 1
	Cmensaje = ""
	Select tmpv
	Go Top
	Do While !Eof()
		cdesc = tmpv.Desc
		If IngresaKardexGrifo(NAuto, tmpv.Coda, 'V', tmpv.Prec, tmpv.cant, 'I', 'K', This.Vendedor, goApp.Tienda, tmpv.nidcontometro, tmpv.costo / fe_gene.igv, tmpv.pre1) < 1
			swk = 0
			Cmensaje = "El Item:" + Alltrim(cdesc) + " NO Tiene Stock Disponible Para Venta O no se ha fijado El valor del Contometro"
			This.Cmensaje = Cmensaje
			Exit
		Endif
		If goApp.ConectaControlador = 'Y' Then
			If tmpv.Idjournal > 0 Then
				If _Screen.oventasg.GrabarIdjornaly(tmpv.Idjournal) < 1 Then
					This.Cmensaje = Screen.oventasg.Cmensaje
					swk = 0
					Exit
				Endif
			Endif
		Endif
		Select tmpv
		Skip
	Enddo
	If swk = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GeneraCorrelativovtas() < 1  Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1  Then
		Return 0
	Endif
	Return NAuto
	Endfunc
	Function IngresaDocumentoElectronicoy()
	lC = 'FuningresaDocumentoElectronicoy'
	cur = "Xn"
	Text To lp Noshow Textmerge
	('<<This.Tdoc>>','<<LEFT(This.formaPago,1)>>','<<This.Serie + This.numero>>','<<cfechas(This.Fecha)>>',
	'<<This.Detalle>>',<<This.valor>>,<<This.igv>>,<<This.Monto>>,'','<<This.Moneda>>',
	<<This.ndolar>>,<<fe_gene.igv>>,'k',<<This.Codigo>>,<<goApp.IDturno>>,<<goApp.nidusua>>,
	<<This.codt>>,<<This.cta1>>,<<This.cta2>>,<<This.cta3>>,<<This.gratuita>>,<<This.Idlectura>>,
	<<This.exonerado>>,<<This.Tdscto>>,'<<cfechastime(This.foperacion)>>')
	Endtext
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function grabacreditos(NAuto)
	Set Procedure To d:\capass\modelos\ctasxcobrar Additive
	ocreditos = Createobject("ctasporcobrar")
	nimpo = This.Monto - This.nacta
	idcredito = ocreditos.IngresaCreditosNormal(NAuto, This.Codigo, This.Serie + This.numero, 'C', 'S', "VENTA AL CREDITO", This.Fecha, This.Fechavto, Left(This.tipodcto, 1), This.Serie + This.numero, nimpo, 0, This.Vendedor, This.Monto, goApp.nidusua, This.codt, Id())
	If idcredito < 1 Then
		Return 0
	Endif
	If Left(This.formaPago, 1) = 'A' Then
		x = 1
		If ocreditos.consultaranticipos(This.Codigo, 'lanti') < 1 Then
			Return 0
		Endif
		If REgdvto('lanti') > 0 Then
			nidrc = DevuelveIdCtrlCredito(idcredito)
			If nidrc < 1 Then
				Return 0
			Endif
			Select * From lanti Into Cursor lanti Readwrite
			Select lanti
			Go Top
			Scan All
				If nimpo <= lanti.Acta Then
					nacta = nimpo
				Else
					nacta = lanti.Acta
				Endif
				If ocreditos.CancelaCreditosanticipos(This.Serie + This.numero, nacta, 'P', 'S', 'Aplicado con Anticipo ' + Alltrim(Str(lanti.Acta, 12, 2)), This.Fecha, This.Fecha, Left(This.tipodcto, 1), idcredito, '', nidrc, Id(), goApp.nidusua, lanti.rcre_idrc) < 1
					x = 0
					Exit
				Endif
				nid = lanti.idcred
				Text To lC Noshow
                     UPDATE fe_cred as f SET acta=f.acta-?nacta WHERE idcred=?nid
				Endtext
				If This.Ejecutarsql(lC) < 1 Then
					x = 0
					Exit
				Endif
				Update lanti Set Acta = Acta - nacta  Where idcred = nid
			Endscan
		Endif
		If x = 0 Then
			Return 0
		Endif
		Return 1
	Else
		Return 1
	Endif
	Endfunc
	Function consultardctovta(np2)
*!*		Do Case
*!*		Case np2 = '01' Or np2 = '03' Or np2 = '20'
*!*			cx = ""
*!*			If  Vartype(np3) = 'C' Then
*!*				cx = np3
*!*			Endif
*!*			If cx = 'S' Then
*!*				If goApp.vtascondetraccion = 'S' Then
*!*					SET TEXTMERGE on
*!*					SET TEXTMERGE TO menvar lc NOSHOW TEXTMERGE 
*!*				  	select 4 as codv,c.idauto,0 as idart,m.cant,m.prec as prec,c.codt as alma,
*!*	          		c.tdoc as tdoc1,c.ndoc as dcto,c.fech as fech1,c.vigv,CAST(0 as unsigned) as puntos,
*!*				    c.fech,c.fecr,c.form,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,
*!*				    If goApp.Direcciones = 'S' Then
*!*				        \ifnull(dd.dire_dire,d.dire) as dire,IF(!ISNULL(dd.dire_dire),'',d.ciud) AS ciud,
*!*				      ELSE
*!*				         \d.dire,d.ciud,
*!*				    ENDIF 
*!*				    d.ndni,c.pimpo,u.nomb as usuario,c.deta,rcom_mdet as detraccion, c.tdoc,c.ndoc,c.dolar as dola,c.mone,m.detv_desc as descri,m.detv_unid as Unid,
*!*	          		c.rcom_hash,'Oficina' as nomv,c.impo,ifnull(p.fevto,c.fech) as fvto,c.rcom_dsct,c.valor,c.igv,if(detv_item=1,impo,0) as preciolista,rcom_detr,c.fusua
*!*	          		FROM fe_rcom as c
*!*	          		inner join fe_clie as d on(d.idclie=c.idcliente)
*!*				    inner join fe_usua as u on u.idusua=c.idusua
*!*				    inner join (select detv_item,detv_desc,detv_cant AS cant,detv_prec AS prec,detv_ite1,detv_idau,detv_unid from fe_detallevta where detv_acti='A' and detv_idau=<<np1>>) as m on m.detv_idau=c.idauto
*!*				    left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r inner join fe_cred as c on c.cred_idrc=r.rcre_idrc
*!*	                where rcre_acti='A' and acti='A' and rcre_idau=<<np1>> group by rcre_idau) as p on p.rcre_idau=c.idauto
*!*	                If goApp.Direcciones = 'S' Then
*!*	                  \left join fe_direcciones as dd on dd.dire_iddi=c.alma
*!*	                ENDIF 
*!*				 	where c.idauto=<<np1>> order by detv_ite1
*!*				    SET TEXTMERGE off
*!*				    SET TEXTMERGE TO 
*!*				
*!*					Else
*!*						Text To lC Noshow Textmerge Pretext 7
*!*				  	4 as codv,c.idauto,0 as idart,m.cant,m.prec as prec,c.codt as alma,
*!*	          		c.tdoc as tdoc1,c.ndoc as dcto,c.fech as fech1,c.vigv,CAST(0 as unsigned) as puntos,
*!*				    c.fech,c.fecr,c.form,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,
*!*	          		c.pimpo,u.nomb as usuario,c.deta,rcom_mdet as detraccion,
*!*				    c.tdoc,c.ndoc,c.dolar as dola,c.mone,m.detv_desc as descri,m.detv_unid as Unid,
*!*	          		c.rcom_hash,'Oficina' as nomv,c.impo,ifnull(p.fevto,c.fech) as fvto,c.rcom_dsct,c.valor,c.igv,if(detv_item=1,impo,0) as preciolista,rcom_detr,c.fusua
*!*	          		FROM fe_rcom as c
*!*	          		inner join fe_clie as d on(d.idclie=c.idcliente)
*!*				    inner join fe_usua as u on u.idusua=c.idusua
*!*				    inner join (select detv_item,detv_desc,detv_cant AS cant,detv_prec AS prec,detv_ite1,detv_idau,detv_unid from fe_detallevta where detv_acti='A' and detv_idau=<<np1>>) as m on m.detv_idau=c.idauto
*!*				    left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r inner join fe_cred as c on c.cred_idrc=r.rcre_idrc
*!*	                where rcre_acti='A' and acti='A' and rcre_idau=<<np1>> group by rcre_idau) as p on p.rcre_idau=c.idauto
*!*				 	where c.idauto=<<np1>> order by detv_ite1
*!*						Endtext
*!*					Endif
*!*				Else
*!*					If goApp.Direcciones = 'S' Then
*!*						Text To lC Noshow Textmerge Pretext 7
*!*				  	4 as codv,c.idauto,0 as idart,CAST(1  as decimal(12,2)) as cant,if(detv_item=1,impo,0) as prec,c.codt as alma,CAST(0 as unsigned) as puntos,
*!*	          		c.tdoc as tdoc1, c.ndoc as dcto,c.fech as fech1,c.vigv, c.fech,c.fecr,c.form,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,
*!*	          		ifnull(dd.dire_dire,d.dire) as dire,IF(!ISNULL(dd.dire_dire),'',d.ciud) AS ciud,d.ndni,
*!*	          		c.pimpo,u.nomb as usuario,c.deta, c.tdoc,c.ndoc,c.dolar as dola,c.mone,m.detv_desc as descri,'' as Unid,CAST(0 as decimal(12,2)) as detraccion,
*!*	          		c.rcom_hash,'Oficina' as nomv,c.impo,ifnull(p.fevto,c.fech) as fvto,c.rcom_dsct,c.valor,c.igv,if(detv_item=1,impo,0) as preciolista,rcom_detr,c.fusua
*!*	          		FROM fe_rcom as c
*!*	          		inner join fe_clie as d on(d.idclie=c.idcliente)
*!*				    inner join fe_usua as u on u.idusua=c.idusua
*!*				    inner join (select detv_item,detv_desc,detv_ite1,detv_idau,detv_cant AS cant,detv_prec AS prec from fe_detallevta where detv_acti='A' and detv_idau=<<np1>>) as m on m.detv_idau=c.idauto
*!*				    left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r inner join fe_cred as c on c.cred_idrc=r.rcre_idrc
*!*	                where rcre_acti='A' and acti='A' and rcre_idau=<<np1>> group by rcre_idau) as p on p.rcre_idau=c.idauto
*!*	                left join fe_direcciones as dd on dd.dire_iddi=c.alma
*!*				 	where c.idauto=<<np1>> order by detv_ite1
*!*						Endtext
*!*					Else
*!*						Text To lC Noshow Textmerge Pretext 7
*!*				  	4 as codv,c.idauto,0 as idart,CAST(1  as decimal(12,2)) as cant,if(detv_item=1,impo,0) as prec,c.codt as alma,
*!*	          		c.tdoc as tdoc1, c.ndoc as dcto,c.fech as fech1,c.vigv, c.fech,c.fecr,c.form,c.rcom_exon,c.ndo2,c.igv,c.idcliente,
*!*	          		d.razo,d.nruc,d.dire,d.ciud,d.ndni,c.pimpo,u.nomb as usuario,c.deta,CAST(0 as unsigned) as puntos,
*!*				    c.tdoc,c.ndoc,c.dolar as dola,c.mone,m.detv_desc as descri,'' as Unid,CAST(0 as decimal(12,2)) as detraccion,
*!*	          		c.rcom_hash,'Oficina' as nomv,c.impo,ifnull(p.fevto,c.fech) as fvto,c.rcom_dsct,c.valor,c.igv,if(detv_item=1,impo,0) as preciolista,rcom_detr,c.fusua
*!*	          		FROM fe_rcom as c
*!*	          		inner join fe_clie as d on(d.idclie=c.idcliente)
*!*				    inner join fe_usua as u on u.idusua=c.idusua
*!*				    inner join (select detv_item,detv_desc,detv_ite1,detv_idau,detv_cant AS cant,detv_prec AS prec from fe_detallevta where detv_acti='A' and detv_idau=<<np1>>) as m on m.detv_idau=c.idauto
*!*				    left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r inner join fe_cred as c on c.cred_idrc=r.rcre_idrc
*!*	                where rcre_acti='A' and acti='A' and rcre_idau=<<np1>> group by rcre_idau) as p on p.rcre_idau=c.idauto
*!*				 	where c.idauto=<<np1>> order by detv_ite1
*!*						Endtext
*!*					Endif
*!*				Endif

*!*			Else
*!*				If goApp.Direcciones = 'S' Then
*!*					Text To lC Noshow Textmerge Pretext 7
*!*				    a.codv,a.idauto,a.alma,a.idkar,a.idauto,a.idart,a.cant,a.prec,a.alma,c.tdoc as tdoc1,c.ndoc as dcto,c.fech as fech1,c.vigv,a.kar_prel as preciolista,CAST(0 as decimal(12,2)) as detraccion,
*!*				    c.fech,c.fecr,c.form,c.deta,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,ifnull(dd.dire_dire,d.dire) as dire,IF(!ISNULL(dd.dire_dire),'',d.ciud) AS ciud,d.ndni,c.pimpo,u.nomb as usuario,
*!*				    c.tdoc,c.ndoc,c.dolar as dola,c.mone,b.descri,b.unid,c.rcom_hash,u.nomb as nomv,c.impo,ifnull(p.fevto,c.fech) as fvto,c.rcom_dsct,c.valor,c.igv,CAST(0 as unsigned) as puntos,rcom_detr,c.fusua
*!*				    FROM fe_rcom as c
*!*				    inner join fe_kar As a on a.idauto=c.idauto
*!*				    inner join fe_clie as d on(c.idcliente=d.idclie)
*!*				    inner join fe_art As b on(b.idart=a.idart)
*!*				    inner join fe_usua as u on u.idusua=c.idusua
*!*				    left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r inner join fe_cred as c on c.cred_idrc=r.rcre_idrc
*!*	                where rcre_acti='A' and acti='A' and rcre_idau=<<np1>> group by rcre_idau) as p on p.rcre_idau=c.idauto
*!*	                left join fe_direcciones as dd on dd.dire_iddi=c.alma
*!*				    where c.idauto=<<np1>> and a.acti='A';
*!*					Endtext
*!*				Else
*!*					If goApp.Promopuntos = 'S' Then
*!*						Text To lC Noshow Textmerge Pretext 7
*!*				    a.codv,a.idauto,a.alma,a.idkar,a.idauto,a.idart,a.cant,a.prec,a.alma,c.tdoc as tdoc1,CAST(ifnull(dpro_acum,0) as unsigned )as puntos,
*!*				    c.ndoc as dcto,c.fech as fech1,c.vigv,a.kar_prel as preciolista,CAST(0 as decimal(12,2)) as detraccion,
*!*				    c.fech,c.fecr,c.form,c.deta,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,c.pimpo,u.nomb as usuario,
*!*				    c.tdoc,c.ndoc,c.dolar as dola,c.mone,b.descri,b.unid,c.rcom_hash,u.nomb as nomv,c.impo,ifnull(p.fevto,c.fech) as fvto,c.rcom_dsct,c.valor,c.igv,rcom_detr,c.fusua
*!*				    FROM fe_rcom as c
*!*				    inner join fe_kar As a on a.idauto=c.idauto
*!*				    inner join fe_clie as d on(c.idcliente=d.idclie)
*!*				    inner join fe_art As b on(b.idart=a.idart)
*!*				    inner join fe_usua as u on u.idusua=c.idusua
*!*				    left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r inner join fe_cred as c on c.cred_idrc=r.rcre_idrc
*!*	                where rcre_acti='A' and acti='A' and rcre_idau=<<np1>> group by rcre_idau) as p on p.rcre_idau=c.idauto
*!*	                left join (select dpro_idau,dpro_acum from fe_dpromo where dpro_idau=<<np1>> and dpro_acti='A') as pt on pt.dpro_idau=c.idauto
*!*				    where c.idauto=<<np1>> and a.acti='A';
*!*						Endtext
*!*					Else
*!*						Text To lC Noshow Textmerge Pretext 7
*!*				    a.codv,a.idauto,a.alma,a.idkar,a.idauto,a.idart,a.cant,a.prec,a.alma,c.tdoc as tdoc1,
*!*				    c.ndoc as dcto,c.fech as fech1,c.vigv,a.kar_prel as preciolista,CAST(0 as decimal(12,2)) as detraccion,CAST(0 as unsigned) as puntos,
*!*				    c.fech,c.fecr,c.form,c.deta,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,c.pimpo,u.nomb as usuario,
*!*				    c.tdoc,c.ndoc,c.dolar as dola,c.mone,b.descri,b.unid,c.rcom_hash,u.nomb as nomv,c.impo,ifnull(p.fevto,c.fech) as fvto,c.rcom_dsct,c.valor,c.igv,rcom_detr,c.fusua
*!*				    FROM fe_rcom as c
*!*				    inner join fe_kar As a on a.idauto=c.idauto
*!*				    inner join fe_clie as d on(c.idcliente=d.idclie)
*!*				    inner join fe_art As b on(b.idart=a.idart)
*!*				    inner join fe_usua as u on u.idusua=c.idusua
*!*				    left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r inner join fe_cred as c on c.cred_idrc=r.rcre_idrc
*!*	                where rcre_acti='A' and acti='A' and rcre_idau=<<np1>> group by rcre_idau) as p on p.rcre_idau=c.idauto
*!*				    where c.idauto=<<np1>> and a.acti='A';
*!*						Endtext
*!*					Endif
*!*				Endif
*!*			Endif
*!*		Case np2 = '08'
*!*			Text To lC Noshow Textmerge Pretext 7
*!*				   r.idauto,r.ndoc,r.tdoc,r.fech,r.mone,abs(r.valor) as valor,r.ndo2,r.rcom_exon,
*!*			       r.vigv,c.nruc,c.razo,c.dire,c.ciud,c.ndni,u.nomb as nomv,r.form,CAST(0 as decimal(12,2)) as detraccion,
*!*			       abs(r.igv) as igv,abs(r.impo) as impo,ifnull(IF(k.cant=0,1,k.cant),CAST(1 as decimal(12,2))) as cant,
*!*			       ifnull(k.prec,ABS(r.impo)) as prec,LEFT(r.ndoc,4) as serie,SUBSTR(r.ndoc,5) as numero,CAST(0 as unsigned) as puntos,
*!*			       ifnull(a.unid,'') as unid,ifnull(a.descri,r.deta) as descri,r.deta,ifnull(k.idart,CAST(0 as decimal(8))) as idart,w.ndoc as dcto,
*!*			       w.fech as fech1,w.tdoc as tdoc1,r.rcom_hash,u.nomb as usuario,r.fech as fvto,r.rcom_dsct,ifnull(k.prec,ABS(r.impo)) as preciolista,r.rcom_detr,r.fusua
*!*			       from fe_rcom r
*!*			       inner join fe_clie c on c.idclie=r.idcliente
*!*			       left join fe_kar k on k.idauto=r.idauto
*!*			       left join fe_art a on a.idart=k.idart
*!*			       inner join fe_ncven f on f.ncre_idan=r.idauto
*!*			       inner join fe_rcom as w on w.idauto=f.ncre_idau
*!*			       inner join fe_usua as u on u.idusua=r.idusua
*!*			       where r.idauto=<<np1>> and r.acti='A' and r.tdoc='08'
*!*			Endtext
*!*		Case np2 = '07'
*!*			cx = ""
*!*			If  Vartype(np3) = 'C' Then
*!*				cx = np3
*!*			Endif
*!*			If cx = 'S' Then
*!*				Text To lC Noshow Textmerge Pretext 7
*!*				4 as codv,c.idauto,detv_idvt as idart,ABS(cant) as cant,prec,c.codt as alma,
*!*				c.fech as fech1,c.vigv,
*!*				c.fech,c.fecr,c.form,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,
*!*				c.pimpo,u.nomb as usuario,c.deta,LEFT(c.ndoc,4) as serie,SUBSTR(c.ndoc,5) as numero,
*!*				c.tdoc,c.ndoc,c.dolar as dola,c.mone,m.detv_desc as descri,'' as Unid,CAST(0 as unsigned) as puntos,
*!*				c.rcom_hash,'Oficina' as nomv,abs(c.impo) as impo,w.ndoc as dcto,CAST(0 as decimal(12,2)) as detraccion,
*!*				w.fech as fech1,w.tdoc as tdoc1,c.fech as fvto,c.rcom_dsct,abs(c.valor) as valor,ABS(c.igv) as igv,prec as preciolista,c.rcom_detr,c.fusua
*!*				FROM fe_rcom as c
*!*				inner join fe_clie as d on(d.idclie=c.idcliente)
*!*				inner join fe_usua as u on u.idusua=c.idusua
*!*			    inner join (select detv_idvt,detv_item,detv_desc,detv_cant AS cant,detv_prec AS prec,detv_ite1,detv_idau,detv_unid from fe_detallevta where detv_acti='A' and detv_idau=<<np1>>) as m on m.detv_idau=c.idauto
*!*		     	inner join fe_ncven f on f.ncre_idan=c.idauto
*!*				inner join fe_rcom as w on w.idauto=f.ncre_idau
*!*				where c.idauto=<<np1>> order by detv_ite1
*!*				Endtext
*!*			Else
*!*				Text To lC Noshow Textmerge Pretext 7
*!*				   r.idauto,r.ndoc,r.tdoc,r.fech,r.mone,abs(r.valor) as valor,r.ndo2,
*!*			       r.vigv,c.nruc,c.razo,c.dire,c.ciud,c.ndni,u.nomb as nomv,r.form,u.nomb as usuario,r.rcom_exon,
*!*			       abs(r.igv) as igv,abs(r.impo) as impo,ifnull(k.cant,CAST(0 as decimal(12,2))) as cant,CAST(0 as decimal(12,2)) as detraccion,
*!*			       ifnull(k.prec,ABS(r.impo)) as prec,LEFT(r.ndoc,4) as serie,SUBSTR(r.ndoc,5) as numero,CAST(0 as unsigned) as puntos,
*!*			       ifnull(a.unid,'') as unid,ifnull(a.descri,r.deta) as descri,r.deta,ifnull(k.idart,CAST(0 as decimal(8))) as idart,w.ndoc as dcto,
*!*			       w.fech as fech1,w.tdoc as tdoc1,r.rcom_hash,r.fech as fvto,r.rcom_dsct,ifnull(k.prec,ABS(r.impo)) as preciolista,r.rcom_detr,r.fusua
*!*			       from fe_rcom r
*!*			       inner join fe_clie c on c.idclie=r.idcliente
*!*			       left join fe_kar k on k.idauto=r.idauto
*!*			       left join fe_art a on a.idart=k.idart
*!*			       inner join fe_ncven f on f.ncre_idan=r.idauto
*!*			       inner join fe_rcom as w on w.idauto=f.ncre_idau
*!*			       inner join fe_usua as u on u.idusua=r.idusua
*!*			       where r.idauto=<<np1>> and r.acti='A' and r.tdoc='07'
*!*				Endtext
*!*			Endif
*!*		Endcase
*!*		If EJECutaconsulta(lC, 'kardex') < 1 Then
*!*			Return
*!*		Endif
	Endfunc
	Function buscarxid(Ccursor)
	Text To lC Noshow Textmerge Pretext 7
		 select  c.idusua    AS idusua,  a.kar_comi  AS kar_comi,  a.codv      AS codv,  a.idauto    AS idauto,
		  a.alma      AS alma,  a.kar_idco  AS idcosto,  a.idkar     AS idkar,  a.idart ,
		  a.cant      AS cant,  a.prec      AS prec,  c.valor     AS valor,  c.igv       AS igv,  c.impo      AS impo,
		  c.fech      AS fech,  c.fecr      AS fecr,  c.form      AS form,  c.deta      AS deta,
		  c.exon      AS exon,  c.ndo2      AS ndo2,  c.rcom_entr AS rcom_entr,  c.idcliente AS idclie,
		  d.razo      AS razo,  d.nruc      AS nruc,  d.dire      AS dire,
		  d.ciud      AS ciud,  d.ndni      AS ndni,  a.tipo      AS tipo,  c.tdoc      AS tdoc,
		  c.ndoc      AS ndoc,  c.dolar     AS dolar,  c.mone      AS mone,  b.descri    AS descri,  0 AS idcaja,
		  b.unid      AS unid,  b.pre1      AS pre1,  b.peso      AS peso,  b.pre2      AS pre2,  IFNULL(z.vend_idrv,0) AS nidrv,
		  c.vigv      AS vigv,  a.dsnc      AS dsnc,  a.dsnd      AS dsnd,  a.gast      AS gast,
		  c.idcliente AS idcliente,  c.codt      AS codt,  b.pre3      AS pre3,  b.cost      AS costo,  b.uno       AS uno,
		  b.dos       AS dos,  (b.uno + b.dos) AS TAlma,  c.fusua     AS fusua,  p.nomv      AS Vendedor,  q.nomb      AS Usuario,
		  c.rcom_idtr AS rcom_idtr,  c.rcom_tipo AS rcom_tipo,  c.rcom_exon AS rcom_exon,ifnull(p.fevto,c.fech) as fvto
		FROM fe_rcom c
		     JOIN fe_kar a           ON a.idauto = c.idauto        
		     JOIN vlistaprecios b          ON b.idart = a.idart
		     JOIN fe_clie d        ON d.idclie = c.idcliente
		     LEFT JOIN fe_vend p       ON p.idven = a.codv
		     JOIN fe_usua q      ON q.idusua = c.idusua
		     LEFT JOIN (SELECT rcre_idau,MIN(c.fevto) AS fevto FROM fe_rcred AS r  INNER JOIN fe_cred AS c ON c.cred_idrc=r.rcre_idrc
		     WHERE rcre_acti='A' AND acti='A' AND rcre_idau=<<this.idauto>> GROUP BY rcre_idau) AS p ON p.rcre_idau=a.idauto
		     LEFT JOIN (SELECT vend_idrv,vend_idau FROM fe_rvendedor WHERE vend_acti='A' AND vend_idau=<<this.idauto>> LIMIT 1) z ON z.vend_idau = c.idauto
		WHERE c.tipom = 'V'  AND c.acti = 'A'  AND a.acti = 'A' AND c.idauto=<<this.idauto>> order by a.idkar
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function resumenventasfechaproducto(Ccursor)
	fi = Cfechas(This.fechai)
	ff = Cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
		\Select fech,Descri,unid,cant,importe,q.idart From(
		\Select Sum(cant) As cant,Sum(cant*Prec)As importe,fech,k.idart
	If goApp.ConectaControlador = 'Y' Then
		 \,rcom_idis
	Endif
		\From fe_rcom As r
		\inner Join fe_kar As k On k.`Idauto`=r.`Idauto`
		\Where 	idcliente>0 And k.Acti='A' And r.Acti='A'
	If This.Idlectura > 0 Then
		\And rcom_idis=<<This.Idlectura>>
	Else
		\And fech Between '<<fi>>' And '<<ff>>'
	Endif
	If goApp.ConectaControlador = 'Y' Then
		   \And k.`kar_idco`>0
	Endif
	If This.codt > 0 Then
	      \ And r.codt=<<This.codt>>
	Endif
	If goApp.ConectaControlador = 'Y' Then
		  \ Group By k.idart,rcom_idis,fech)
	Else
		   \Group By k.idart,fech)
	Endif
		\As q inner Join fe_art As a On a.idart=q.idart Order By Descri
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function resumenventasxmesmontos(ntipo, Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select Descri As Producto,unid As Unidad,
	\Sum(Case mes When 1 Then Impo Else 0 End) As 'Enero',
	\Sum(Case mes When 2 Then Impo Else 0 End) As 'Febrero',
	\Sum(Case mes When 3 Then Impo Else 0 End) As 'Marzo',
	\Sum(Case mes When 4 Then Impo Else 0 End) As 'Abril',
	\Sum(Case mes When 5 Then Impo Else 0 End) As 'Mayo',
	\Sum(Case mes When 6 Then Impo Else 0 End) As 'Junio',
	\Sum(Case mes When 7 Then Impo Else 0 End) As 'Julio',
	\Sum(Case mes When 8 Then Impo Else 0 End) As 'Agosto',
	\Sum(Case mes When 9 Then Impo Else 0 End) As 'Septiembre',
	\Sum(Case mes When 10 Then Impo Else 0 End) As 'Octubre',
	\Sum(Case mes When 11 Then Impo Else 0 End) As 'Noviembre',
	\Sum(Case mes When 12 Then Impo Else 0 End) As 'Diciembre',Sum(Impo) As Total,
	\x.idart From(
	\Select Month(fech) As mes,idart,Cast(Sum(If(mone='S',cant*Prec,cant*Prec*dolar)) As Decimal(12,2)) As Impo
	\From fe_rcom r
	\inner Join fe_kar k On k.Idauto=r.Idauto Where k.Acti='A' And r.Acti='A'  And Year(fech)=<<This.naño>> And idcliente>0
	Do Case
	Case m.ntipo = 2
	     \ And r.Tdoc In("01","03","07","08")
	Case m.ntipo = 3
	    \ And r.Tdoc="20"
	Otherwise
	    \
	Endcase
	\ Group By idart,fech
	\Order By fech) As x inner Join fe_art As c On c.idart=x.idart
	\Group By idart Order By Descri
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function resumenventasxmescantidad(ntipo, Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
  	\Select Descri As Producto,unid As Unidad,
	\Sum(Case mes When 1 Then Impo Else 0 End) As 'Enero',
	\Sum(Case mes When 2 Then Impo Else 0 End) As 'Febrero',
	\Sum(Case mes When 3 Then Impo Else 0 End) As 'Marzo',
	\Sum(Case mes When 4 Then Impo Else 0 End) As 'Abril',
	\Sum(Case mes When 5 Then Impo Else 0 End) As 'Mayo',
	\Sum(Case mes When 6 Then Impo Else 0 End) As 'Junio',
	\Sum(Case mes When 7 Then Impo Else 0 End) As 'Julio',
	\Sum(Case mes When 8 Then Impo Else 0 End) As 'Agosto',
	\Sum(Case mes When 9 Then Impo Else 0 End) As 'Septiembre',
	\Sum(Case mes When 10 Then Impo Else 0 End) As 'Octubre',
	\Sum(Case mes When 11 Then Impo Else 0 End) As 'Noviembre',
	\Sum(Case mes When 12 Then Impo Else 0 End) As 'Diciembre',Sum(Impo) As Total,
	\x.idart From(
	\Select Month(fech) As mes,idart,Cast(Sum(cant) As Decimal(12,2)) As Impo
	\From fe_rcom r inner Join fe_kar k On k.Idauto=r.Idauto Where k.Acti='A' And r.Acti='A'  And Year(fech)=<<This.naño>> And idcliente>0
	Do Case
	Case m.ntipo = 2
	     \ And r.Tdoc In("01","03","07","08")
	Case m.ntipo = 3
	    \ And r.Tdoc="20"
	Otherwise
	    \
	Endcase
	\Group By idart,fech
	\Order By fech) As x inner Join fe_art As c On c.idart=x.idart
	\Group By idart Order By Descri
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function resumenventasproductoxlectura(Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select Descri,unid,cant,importe,q.idart From(
	\Select Sum(cant) As cant,Sum(cant*Prec)As importe,k.idart,rcom_idis
	\From fe_rcom As r
	\inner Join fe_kar As k On k.`Idauto`=r.`Idauto`
	\Where 	idcliente>0 And k.Acti='A' And r.Acti='A'And k.`kar_idco`>0 And rcom_idis=<<This.Idlectura>>
	If This.codt > 0 Then
      \ And r.codt=<<This.codt>>
	Endif
	\ Group By k.idart,rcom_idis) As q inner Join fe_art As a On a.idart=q.idart
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function flujoventasxdespacho(Ccursor)
	If (This.fechaf - This.fechai) > 31 Then
		This.Cmensaje = "Máximo 30 Días"
		Return 0
	Endif
	dfi = Cfechas(This.fechai)
	dff = Cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar Cc Noshow Textmerge
	\Select Sum(Volume) As cantidad,Sum(amount) As importe,idgrade,gradename,Cast(fecreg_inicio As Date) As Fecha From venta
	\Where Cast(fecreg_inicio As Date) Between '<<dfi>>' And '<<dff>>'
	If This.codt > 0 Then
		If fe_gene.nruc = '20609310902' Then
			Do Case
			Case This.codt = 1
	        \ And pump In(1,2,3,4)
			Case This.codt = 2
	         \ And pump In(5,6,7,8)
			Endcase
		Else
			Do Case
			Case This.codt = 1
	       \ And pump In(1,2)
			Case This.codt = 2
	       \ And pump In(3,4)
			Case This.codt = 3
	       \ And pump In(5,6)
			Endcase
		Endif
	Endif
    \Group By Fecha,idgrade,gradename Order By Fecha,idgrade,gradename
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(Cc, 'vv') < 1 Then
		Return 0
	Endif
	Create Cursor (Ccursor) (Producto  c(20))
	Select vv
	Go Top
	Do While !Eof()
		Cdia = "Dia_" + Alltrim(Str(Day(vv.Fecha)))
		Alter Table (Ccursor) Add Column (Cdia) N(12, 2)
		dFecha = vv.Fecha
		Do While !Eof() And vv.Fecha = m.dFecha
			Select (Ccursor)
			Locate  For Alltrim(Producto) = Alltrim(vv.gradename)
			If !Found()
				Text To lC1 Noshow Textmerge
	            INSERT INTO  <<ccursor>> (producto,<<cdia>>)values('<<ALLTRIM(vv.gradename)>>',<<vv.cantidad>>)
				Endtext
				Execscript(lC1)
				Text To lC2 Noshow Textmerge
	            INSERT INTO  <<ccursor>> (producto,<<cdia>>)values('<<ALLTRIM(vv.gradename)>>',<<vv.importe>>)
				Endtext
				Execscript(lC2)
			Else
				Text To lC3 Noshow Textmerge
			      replace <<cdia>> with <<vv.cantidad>> in <<ccursor>>
				Endtext
				Execscript(lC3)
				Select (Ccursor)
				If !Eof()
					Skip 1
					Text To lC4 Noshow Textmerge
			         replace <<cdia>> with <<vv.importe>> in <<ccursor>>
					Endtext
					Execscript(lC4)
				Endif
			Endif
			Select vv
			Skip
		Enddo
	Enddo
	Select (Ccursor)
	Go Top
	Return 1
	Endfunc
	Function flujodeventasxturnos(Ccursor)
	If (This.fechaf - This.fechai) > 31 Then
		This.Cmensaje = "Máximo 30 Días"
		Return 0
	Endif
	f1 = Cfechas(This.fechai)
	f2 = Cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar Cc Noshow Textmerge
	\Select cantidad,importe,lect_idar,lect_fech As Fecha,lect_idin,a.Descri As gradename From
	\(Select Sum(lect_cfinal-lect_inic) As cantidad,Sum(lect_mfinal-lect_inim) As importe,lect_idar,lect_fech,lect_idin
	\From fe_lecturas As l
	\Where lect_acti='A'  And lect_cfinal>0 And lect_mfinal>0 And lect_fech Between '<<f1>>' And '<<f2>>'
	If This.codt > 0 Then
		If fe_gene.nruc = '20609310902' Then
			Do Case
			Case This.codt = 1
	        \ And lect_idco In(1,2,3,4)
			Otherwise
	        \ And lect_idco In(5,6,7,8)
			Endcase
		Else
			Do Case
			Case This.codt = 1
	       \ And lect_idco In(1,2)
			Case This.codt = 2
	       \ And lect_idco In(3,4)
			Case This.codt = 3
	       \ And lect_idco In(5,6)
			Endcase
		Endif
	Endif
	\Group By lect_fech,lect_idar,lect_idin) As q
	\inner Join fe_art As a On a.idart=q.lect_idar
	\Order By lect_fech,lect_idin
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(Cc, 'vv') < 1 Then
		Return 0
	Endif
	Create Cursor (Ccursor) (Producto  c(20))
	Select vv
	Go Top
	Do While !Eof()
		Cdia = "Dia_" + Alltrim(Str(Day(vv.Fecha)))
		Alter Table (Ccursor) Add Column (Cdia) N(12, 2)
		dFecha = vv.Fecha
		Do While !Eof() And vv.Fecha = m.dFecha
			Select (Ccursor)
			Locate  For Alltrim(Producto) = Alltrim(vv.gradename)
			If !Found()
				Text To lC1 Noshow Textmerge
	            INSERT INTO  <<ccursor>> (producto,<<cdia>>)values('<<ALLTRIM(vv.gradename)>>',<<vv.cantidad>>)
				Endtext
				Execscript(lC1)
				Text To lC2 Noshow Textmerge
	            INSERT INTO  <<ccursor>> (producto,<<cdia>>)values('<<ALLTRIM(vv.gradename)>>',<<vv.importe>>)
				Endtext
				Execscript(lC2)
			Else
				Text To lC3 Noshow Textmerge
			      replace <<cdia>> with <<vv.cantidad>> in <<ccursor>>
				Endtext
				Execscript(lC3)
				Select (Ccursor)
				If !Eof()
					Skip 1
					Text To lC4 Noshow Textmerge
			         replace <<cdia>> with <<vv.importe>> in <<ccursor>>
					Endtext
					Execscript(lC4)
				Endif
			Endif
			Select vv
			Skip
		Enddo
	Enddo
	Select (Ccursor)
	Go Top
	Return 1
	Endfunc
Enddefine


































