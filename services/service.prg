Define Class servicio As Custom
	centidad = ""
	oobjeto = Null
	cmensaje = ""
	Function Inicializar(oobj, cce)
	This.oobjeto = oobj
	This.centidad = m.cce
	cexecute = 'this.validar' + Trim(cce) + '()'
	Return &cexecute
	Endfunc
	Function validarcompras()
	Endfunc
	Function validarVentasxsys()
	obj =(This.oobjeto)
	nt1 = obj.valor + obj.exonerado + obj.igv + obj.inafecta
	nt2 = obj.monto
	If obj.idauto > 0 Then
		If _Screen.octasxcobrar.VerificaSitienePagos(obj.idauto) < 1 Then
			This.cmensaje = _Screen.octasxcobrar.cmensaje
			Return 0
		Endif
	Endif
	Do Case
	Case Month(obj.fecha) <> goApp.mes  Or Year(obj.fecha) <> Val(goApp.año) Or !esfechaValida(obj.fecha)
		This.cmensaje = "Fecha No Permitida por el Sistema"
		Return 0
	Case Len(Alltrim(obj.SErie)) < 3 Or Len(Alltrim(obj.NUmero)) < 7
		This.cmensaje = "EL Número de Documento no es Válido"
		Return 0
	Case obj.VerificaBloqueoVentaxsys(obj.fecha) < 1
		This.cmensaje = "No es Posible Registrar en esta Fecha..Esta Bloqueado los Ingresos en este Período"
		Return 0
	Case obj.ruc = '***********'
		This.cmensaje = "Seleccione Otro Cliente"
		Return 0
	Case (nt1 <> nt2) Or nt1 = 0 Or nt2 = 0
		This.cmensaje = "Importes No Permitidos"
		Return 0
	Case obj.codigo < 1
		This.cmensaje = "Seleccione Un CLiente"
		Return 0
	Case obj.tdoc = "01" And !validaruc(obj.ruc)
		This.cmensaje = "RUC de Cliente no Válido"
		Return 0
	Case obj.verificarsiesta() < 1
		If Empty(obj.cmensaje) Then
			This.cmensaje = "Número de Documento Ya Registrado"
		Else
			This.cmensaje = obj.cmensaje
		Endif
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarmarcas()
	obj =(This.oobjeto)
	Do Case
	Case Empty(obj.descmar)
		This.cmensaje = "Ingrese la Descripción de Marca"
		Return 0
	Case obj.cmodo = 'M' And obj.nidmar < 1
		This.cmensaje = "Seleccione Una Linea"
		Return 0
	Case obj.buscarsiexiste() < 1
		This.cmensaje = obj.cmensaje
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarLineas()
	obj =(This.oobjeto)
	Do Case
	Case Len(Alltrim(obj.desclinea)) < 1
		This.cmensaje = "Ingrese nombre de Línea"
		Return 0
	Case obj.nidgrupo < 1
		This.cmensaje = "Seleccione Un Grupo"
		Return 0
	Case obj.cmodo = 'M' And obj.nidcat < 1
		This.cmensaje = "Seleccione Una Linea"
		Return 0
	Case obj.buscarsiexiste() < 1
		This.cmensaje = obj.cmensaje
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarplanctas()
	obj =(This.oobjeto)
	Do Case
	Case Len(Alltrim(obj.cnombre)) < 1
		This.cmensaje = "Obligatorio el Nombre de Cuenta"
		Return 0
	Case Len(Alltrim(obj.cncta)) < 1
		This.cmensaje = "Obligatorio número de Cuenta"
		Return 0
	Case Left(obj.cncta, 1) <> '6' And (obj.nidctad > 0 Or obj.nidctah > 0)
		This.cmensaje = "NO puede tener Destino Cuentas diferentes a la Clase 6"
		Return 0
	Case Val(Left(obj.cncta, 2)) >= 60 And Val(Left(obj.cncta, 2)) <= 68 And (obj.nidctad = 0 Or obj.nidctah = 0)
		This.cmensaje = "Es Necesario Ingresar las Cuentas Destino de la Clase 6"
		Return 0
	Case obj.cmodo = 'M' And obj.nidcta = 0
		This.cmensaje = "Es Necesario Seleccionar una Cuenta"
		Return 0
	Case obj.buscarcta() < 1
		This.cmensaje = obj.cmensaje
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarldiario()
	obj =(This.oobjeto)
	If Len(Alltrim(obj.ccursor)) = 0 Then
		This.cmensaje = "No Hay Información Para Registrar"
		Return 0
	Endif
	If verificaAlias(obj.ccursor) = 0 Then
		This.cmensaje = "No Hay Información Para Registrar"
		Return 0
	Endif
	ccursor = "c_" + Sys(2015)
	Select ncta From (obj.ccursor) Where idcta < 1 Into Cursor (ccursor)
	Select (ccursor)
	If !Empty(ncta) Then
		This.cmensaje = "Hay una Cuenta Sin ID"
		Return 0
	Endif
	This.cmensaje = ""
	dife = Iif(obj.ndebe - obj.nhaber > 0, obj.ndebe - obj.nhaber, Abs(obj.ndebe - obj.nhaber))
	Do Case
	Case obj.ndebe = 0 Or obj.nhaber = 0
		This.cmensaje = "Los Importes No Pueden Ser 0"
		Return 0
	Case m.dife > 0.20
		This.cmensaje = "La Sumatoria del DEBE Y HABER no Coinciden"
		Return 0
	Case obj.YaIngresadoDiario(obj.ctipomvto, obj.nmes, obj.na) < 1
		This.cmensaje = obj.cmensaje
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarproductos()
	If !Pemstatus(goApp, 'proyecto', 5) Then
		AddProperty(goApp, 'proyecto', '')
	Endif
	obj =(This.oobjeto)
	Do Case
	Case  Len(Alltrim(obj.cdesc)) < 1
		This.cmensaje = "Ingrese Descripcion"
		Return 0
	Case Empty(obj.cunid)
		This.cmensaje = "Ingrese  Unidad del Producto"
		Return 0
	Case  obj.ccat < 1
		This.cmensaje = "Seleccione Linea Del Producto"
		Return 0
	Case   obj.cmar < 1
		This.cmensaje = "Seleccione Marca Del Producto"
		Return 0
	Case obj.nflete < 1
		This.cmensaje = "Seleccione Flete  Del Producto"
		Return 0
	Case obj.npeso <= 0
		This.cmensaje = "Ingrese Peso referencial"
		Return 0
	Case obj.buscarpornombre(obj.cdesc, obj.nidart) < 1
		This.cmensaje = obj.cmensaje
		Return 0
	Case Len(Alltrim(obj.ccodigo1)) > 0 And obj.buscarporcodigo(obj.ccodigo1, obj.nidart) < 1
		This.cmensaje = obj.cmensaje
		Return 0
	Case obj.nPrec = 0 And (obj.np2 > 0 Or obj.np1 > 0 Or obj.np3 > 0)
		This.cmensaje = "Ingrese El costo para determinar los precios de Venta"
		Return 0
	Case ((obj.ncome * 100) > 10 Or (obj.ncomc * 100) > 10) And Alltrim(goApp.proyecto) = 'psysl'
		This.cmensaje = "La comision no puede ser Mayor a 5%"
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarfletes()
	obj =(This.oobjeto)
	Do Case
	Case Empty(obj.cdesc)
		This.cmensaje = "Ingrese la Descripción del Costo Por Fletes"
		Return 0
	Case obj.cmodo = 'M' And obj.idflete < 1
		This.cmensaje = "Seleccione Una Linea"
		Return 0
	Case obj.buscarsiexiste() < 1
		This.cmensaje = obj.cmensaje
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarclientes()
	obj =(This.oobjeto)
	Do Case
	Case Len(Alltrim(obj.nombre)) < 1
		This.cmensaje = "Ingrese Nombre del Cliente"
		Return 0
	Case obj.buscanombre(obj.cmodo, obj.nombre, obj.codigo) < 1
		This.cmensaje = obj.cmensaje
		Return 0
	Case Len(Alltrim(obj.ndni)) > 1 And Len(Alltrim(obj.ndni)) <> 8
		This.cmensaje = "Ingrese DNI Válido"
		Return 0
	Case Len(Alltrim(obj.ndni)) = 8 And  obj.buscardni(obj.ndni, obj.codigo, obj.cmodo) < 1
		This.cmensaje = "DNI ya Registrado"
		Return 0
	Case Len(Alltrim(obj.nruc)) = 11 And !validaruc(obj.nruc)
		This.cmensaje = "RUC NO Válido"
		Return 0
	Case Trim(obj.nruc)  = '***********'
		This.cmensaje = "Este Cliente No es Posible Modificar"
		Return 0
	Case Len(Alltrim(obj.nruc)) = 11 And validaruc(obj.nruc)
		If obj.buscaruc(obj.cmodo, obj.nruc, obj.codigo) < 1 Then
			This.cmensaje = obj.cmensaje
			Return 0
		Endif
		Return 1
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarproveedores()
	obj = This.oobjeto
	Do Case
	Case Empty(obj.nombre)
		This.cmensaje = "Ingrese Nombre del Proveedor"
		Return 0
	Case Len(Alltrim(obj.nruc)) = 11 And !validaruc(obj.nruc)
		This.cmensaje = "RUC NO Válido"
		Return 0
	Case Len(Alltrim(obj.nruc)) = 11 And validaruc(obj.nruc)
		If obj.buscaruc(obj.cmodo, obj.nruc, obj.codigo) < 1 Then
			This.cmensaje = obj.cmensaje
			Return 0
		Endif
		Return 1
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validargrupos()
	obj = This.oobjeto
	Do Case
	Case Len(Alltrim(obj.descgrupo)) < 1
		This.cmensaje = "Ingrese el Nombre del Grupo"
		Return 0
	Case obj.cmodo = 'M' And obj.nidgrupo < 1
		This.cmensaje = "Seleccion  un Grupo Para Editar"
		Return 0
	Case obj.buscarsiexiste() < 1
		This.cmensaje = "Nombre de Grupo Ya Registrado"
		Return 0
	Otherwise
		Return  1
	Endcase
	Endfunc
	Function validarproductosxsysz()
	obj = This.oobjeto
	Do Case
	Case  Len(Alltrim(obj.cdesc)) < 1
		Thi.cmensaje = "Ingrese Descripción del Producto"
		Return 0
	Case  Empty(obj.ccodigo1) Or  Empty(obj.ccodigo2)
		This.cmensaje = "Ingrese Un Código Válido Para este producto"
		Return 0
	Case Len(Alltrim(obj.ccolores)) < 1
		This.cmensaje = "Selecciona Un Color "
		Return 0
	Case Len(Alltrim(obj.ctallas)) < 1
		This.cmensaje = "Selecciona Una Talla "
		Return 0
	Case Len(Alltrim(obj.csexo)) < 1
		This.cmensaje = "Selecciona Un Modelo"
		Return 0
	Case Len(Alltrim(obj.ctipo)) < 1
		This.cmensaje = "Selecciona Un  Tipo de Sexo "
		Return 0
	Case obj.buscarporcodigoxsysz(obj.ccodigo1 + obj.ccodigo2, obj.nidart) < 1
		This.cmensaje = obj.cmensaje
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validardctos()
	obj = This.oobjeto
	Do Case
	Case Empty(obj.codigosunat)
		This.cmensaje = "Ingrese Código de Documento"
		Return 0
	Case Len(Alltrim(obj.descdcto)) = 0
		This.cmensaje = "Ingrese Descripción de Documento"
		Return 0
	Case obj.VerificaCodDcto(obj.codigosunat, obj.idcodigo) < 1
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function ValidarNotasCreditoVentas()
	obj = This.oobjeto
	Do Case
	Case obj.nvalor = 0
		This.cmensaje = "Importes Deben de Ser Diferente de Cero"
		Return 0
	Case Len(Alltrim(obj.cserie)) < 4 Or Len(Alltrim(obj.cnumero)) < 8;
			And (Left(obj.cserie, 2) <> 'FN' Or Left(obj.cnumero, 2) <> 'BC' Or ;
			  Left(obj.cserie, 2) <> 'FD' Or Left(obj.cserie, 2) <> 'BD')
		This.cmensaje = "Falta Ingresar Correctamente el Número del  Documento"
		Return 0
	Case Val(obj.cnumero) = 0
		This.cmensaje = "Número de Documento NO Válido"
		Return 0
	Case obj.ncodigocliente < 1
		This.cmensaje = "Ingrese Un Cliente"
		Return 0
	Case Year(obj.dfecha) <> Val(goApp.año)
		This.cmensaje = "La Fecha No es Válida"
		Return 0
	Case  PermiteIngresox(obj.dfecha) = 0 Or !esfechaValida(obj.dfecha)
		This.cmensaje = "No Es posible Registrar en esta Fecha estan bloqueados Los Ingresos O Fecha de Ingreso NO es Válida"
		Return 0
	Case obj.ctdoc = '07'
		If obj.ntotal > obj.ntfactura Then
			This.cmensaje = "El Importe No Puede Ser Mayor al del Documento"
			Return 0
		Endif
	Case (Len(Alltrim(obj.cnombrecliente)) < 5 Or !validaruc(obj.cruc)) And obj.ctdocref = '01'
		This.cmensaje = "Es Necesario Ingresar el Nombre Completo de Cliente, RUC Válidos"
		Return 0
	Case obj.ctdocref = "03" And (Len(Alltrim(obj.cdni)) <> 8 Or Val(obj.cdni) = 0)
		This.cmensaje = "Es Obligatorio DNI del Cliente"
		Return 0
	Case obj.ctdoc = '07'
		ndif = obj.ntotal - obj.ntfactura
		If ndif > 0.10 Then
			This.cmensaje = "El Importe No Puede Ser Mayor al del Documento"
			Return 0
		Endif
	Case Left(obj.ctiponotacredito, 2) = '13' And  Left(obj.cformapago, 1) <> 'C'
		This.cmensaje = "El documento se debe ingresar como Crédito y fecha de vencimiento "
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function ValidarPresentaciones()
	obj = This.oobjeto
	Do Case
	Case Len(Alltrim(obj.cdesc)) < 1
		This.cmensaje = "Es Obligatorio la Descripción"
		Return 0
	Case obj.ncant < 1
		This.cmensaje = "Es Obligatorio la Cantidad"
		Return 0
	Case obj.buscarsiexiste() < 1
		This.cmensaje = "Nombre Ya Registrado"
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarVendedores()
	obj = This.oobjeto
	Do Case
	Case Len(Alltrim(obj.cnombre)) = 0
		This.cmensaje = 'Ingrese Nombre del Vendedor'
		Return 0
	Case obj.buscanombre() = 0
		This.cmensaje = 'Nombre de Vendedor Ya Registrado'
		Return 0
	Case obj.cmodo = 'M' And obj.nidv < 1
		This.cmensaje = 'Seleccione un Vendedor'
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarUsuarios()
	obj = This.oobjeto
	Do Case
	Case Empty(obj.cnombre)
		This.cmensaje = "Ingrese un Nombre de Usuario"
		Return 0
	Case Len(Alltrim(obj.cpassword)) < 6
		This.cmensaje = 'La Contraseña debe tener mínimo 6 caracteres'
		Return 0
	Case obj.cmodo <> 'N' And obj.idusuario < 1
		This.cmensaje = 'Seleccione un Usuario'
		Return 0
	Case obj.buscausuario(obj.cmodo, obj.idusuario, obj.cnombre) < 1
		This.cmensaje = 'Nombre de Usuario Ya Registrado'
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarventaspsysb()
	obj = This.oobjeto
	If This.validarVentas(obj) < 1 Then
		Return 0
	Endif
	Do Case
	Case This.VerificaIngresoItemsVentas(obj.calias) < 1
		Return 0
	Case This.VerificaEquivalencias(obj.calias) < 1
		Return 0
	Case This.ValidarTemporalVtas(obj.calias) < 1
		Return 0
	Otherwise
		Return 1
	Endcase
	ENDFUNC
	Function validarventasxsys3()
	obj = This.oobjeto
	If This.validarVentas(obj) < 1 Then
		Return 0
	Endif
	Do Case
	Case This.VerificaIngresoItemsVentas(obj.calias) < 1
		Return 0
	Case This.VerificaEquivalencias(obj.calias) < 1
		Return 0
*!*		Case This.ValidarTemporalVtas(obj.calias) < 1
*!*			Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarventaspsysg()
	obj = This.oobjeto
	If This.validarVentas(obj) < 1 Then
		Return 0
	Endif
	Do Case
	Case This.VerificaIngresoItemsVentas(obj.calias) < 1
		Return 0
	Case This.VerificaEquivalencias(obj.calias) < 1
		Return 0
*!*		Case This.ValidarTemporalVtas(obj.calias)<1
*!*			Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarVentas(obj)
	nt1 = obj.valor + obj.exonerado + obj.igv + obj.inafecta
	nt2 = obj.monto
	Do Case
	Case Month(obj.fecha) <> goApp.mes  Or Year(obj.fecha) <> Val(goApp.año) 
		This.cmensaje = "Mes y Año No Configurados por el Sistema"
		Return 0
	Case Len(Alltrim(obj.SErie)) < 3 Or   Alltrim(obj.SErie) = '000' Or Alltrim(obj.SErie) = '0000'
		This.cmensaje = "La SERIE de Documento no es Válido"
		Return 0
	Case Len(Alltrim(obj.NUmero)) < 7  Or Val(obj.NUmero) = 0
		This.cmensaje = "Número de Documento no es Válido"
		Return 0
	Case !esfechaValida(obj.fecha)
		This.cmensaje = "Fecha de Emisión No Válida"
		Return .F.
	Case obj.ruc = '***********'
		This.cmensaje = "Seleccione Otro Cliente Para esta Venta"
		Return 0
	Case obj.codigo < 1
		This.cmensaje = "Seleccione Un CLiente"
		Return 0
	Case obj.tdoc = "01" And !validaruc(obj.ruc)
		This.cmensaje = "RUC de Cliente no Válido"
		Return 0
	Case obj.tdoc = "03" And obj.monto > 700 And Len(Alltrim(obj.dni)) < 8
		This.cmensaje = "Ingrese DNI del Cliente "
		Return 0
	Case (nt1 <> nt2) Or nt1 = 0 Or nt2 = 0
		This.cmensaje = "Importes No Permitidos"
		Return 0
	Case !esfechavalidafvto(obj.Fechavto) And Left(obj.formaPago, 1) = 'C'
		This.cmensaje = "Fecha de Vencimiento NO Válida"
		Return 0
	Case obj.tdoc = '01' And Left(obj.SErie, 1) <> 'F' And  Left(obj.SErie, 1) <> 'E'
		This.cmensaje = "Para Tipo de Documento Factura La serie debe empezar con F"
		Return 0
	Case obj.tdoc = '03' And Left(obj.SErie, 1) <> 'B' And  Left(obj.SErie, 1) <> 'E'
		This.cmensaje = "Para Tipo de Documento Boleta La serie debe empezar con B"
		Return 0
	Case Left(obj.formaPago, 1) = 'C'  And (obj.Fechavto - obj.fecha) = 0
		This.cmensaje = "Ingrese Los días de Vencimiento"
		Return 0
	Case obj.verificarsiesta() < 1
		If Empty(obj.cmensaje) Then
			This.cmensaje = "Número de Documento Ya Registrado"
		Else
			This.cmensaje = obj.cmensaje
		Endif
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function VerificaIngresoItemsVentas(calias)
	Select (calias)
	valido = 1
	Select (calias)
	Scan All
		If (cant * Prec) <= 0 Then
			valido = 0
			Exit
		Endif
	Endscan
	Return valido
	Endfunc
	Function VerificaEquivalencias(calias)
	Select (calias)
	Locate For equi = 0 And !Empty(coda)
	If Found()
		This.cmensaje = "El Item: " + Alltrim(Desc) + " no Tiene Equivalencia"
		Return 0
	Endif
	Return 1
	Endfunc
	Function ValidarTemporalVtas(calias)
	Local Sw As Integer
	Sw		 = 1
	cmensaje = ""
	Select (calias)
	Scan All
		Do Case
		Case costo <= 0 And tipro = 'K' And grati <> 'S'
			Sw		 = 0
			cmensaje = "No hay Costo del Producto: " + Rtrim(Desc)
			Exit
		Case (cant * Prec) <= 0 And tipro = 'K' And grati <> 'S'
			Sw		 = 0
			cmensaje = "Ingrese Cantidad O Precio para El Producto: " + Rtrim(Desc)
			Exit
		Case Prec < costo And aprecios <> 'A' And grati <> 'S'
			Sw		 = 0
			cmensaje = "El Producto: " + Rtrim(Desc) + " Tiene Un precio Por Debajo del Costo y No esta Autorizado para hacer esta Venta"
			Exit
		Case cant * costo <= 0 And grati = 'S' And Prec = 0
			cmensaje = "El Item: " + Alltrim(Desc) + " No Tiene Cantidad o Costo para la Transferencia Gratuita"
			Sw		 = 0
		Endcase
	Endscan
	If Sw = 0 Then
		This.cmensaje = cmensaje
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine























