Define Class servicio As Custom
	centidad=""
	oobjeto=Null
	cmensaje=""
	Function Inicializar(oobj,cce)
	This.oobjeto=oobj
	This.centidad=m.cce
	cexecute='this.validar'+Trim(cce)+'()'
	Return &cexecute
	Endfunc
	Function validarcompras()
	Endfunc
	Function validarVentas()
	Endfunc
	Function validarmarcas()
	obj=(This.oobjeto)
	Do Case
	Case Empty(obj.descmar)
		This.cmensaje = "Ingrese la Descripción de Marca"
		Return 0
	Case obj.cmodo='M' And obj.nidmar<1
		This.cmensaje="Seleccione Una Linea"
		Return 0
	Case obj.buscarsiexiste()<1
		This.cmensaje=obj.cmensaje
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarLineas()
	obj=(This.oobjeto)
	Do Case
	Case Len(Alltrim(obj.desclinea))<1
		This.cmensaje="Ingrese nombre de Línea"
		Return 0
	Case obj.nidgrupo<1
		This.cmensaje="Seleccione Un Grupo"
		Return 0
	Case obj.cmodo='M' And obj.nidcat<1
		This.cmensaje="Seleccione Una Linea"
		Return 0
	Case obj.buscarsiexiste()<1
		This.cmensaje=obj.cmensaje
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarplanctas()
	obj=(This.oobjeto)
	Do Case
	Case Len(Alltrim(obj.cnombre))<1
		This.cmensaje="Obligatorio el Nombre de Cuenta"
		Return 0
	Case Len(Alltrim(obj.cncta))<1
		This.cmensaje="Obligatorio número de Cuenta"
		Return 0
	Case Left(obj.cncta,1)<>'6' And (obj.nidctad>0 Or obj.nidctah>0)
		This.cmensaje="NO puede tener Destino Cuentas diferentes a la Clase 6"
		Return 0
	Case Val(Left(obj.cncta,2))>=60 And Val(Left(obj.cncta,2))<=68 And (obj.nidctad=0 Or obj.nidctah=0)
		This.cmensaje="Es Necesario Ingresar las Cuentas Destino de la Clase 6"
		Return 0
	Case obj.cmodo='M' And obj.nidcta=0
		This.cmensaje="Es Necesario Seleccionar una Cuenta"
		Return 0
	Case obj.buscarcta()<1
		This.cmensaje=obj.cmensaje
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarldiario()
	obj=(This.oobjeto)
	If Len(Alltrim(obj.ccursor))=0 Then
		This.cmensaje="No Hay Información Para Registrar"
		Return 0
	Endif
	If verificaAlias(obj.ccursor)=0 Then
		This.cmensaje="No Hay Información Para Registrar"
		Return 0
	Endif
	ccursor="c_"+Sys(2015)
	Select ncta From (obj.ccursor) Where idcta<1 Into Cursor (ccursor)
	Select (ccursor)
	If !Empty(ncta) Then
		This.cmensaje="Hay una Cuenta Sin ID"
		Return 0
	Endif
	This.cmensaje=""
	dife=Iif(obj.ndebe-obj.nhaber>0,obj.ndebe-obj.nhaber,Abs(obj.ndebe-obj.nhaber))
	Do Case
	Case obj.ndebe=0 Or obj.nhaber=0
		This.cmensaje="Los Importes No Pueden Ser 0"
		Return 0
	Case m.dife>0.20
		This.cmensaje="La Sumatoria del DEBE Y HABER no Coinciden"
		Return 0
	Case obj.YaIngresadoDiario(obj.ctipomvto,obj.nmes,obj.na)<1
		This.cmensaje=obj.cmensaje
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarproductos()
	obj=(This.oobjeto)
	Do Case
	Case  Len(Alltrim(obj.cdesc))<1
		This.cmensaje = "Ingrese Descripcion"
		Return 0
	Case Empty(obj.cunid)
		This.cmensaje = "Ingrese  Unidad del Producto"
		Return 0
	Case  obj.ccat<1
		This.cmensaje = "Seleccione Linea Del Producto"
		Return 0
	Case   obj.cmar<1
		This.cmensaje = "Seleccione Marca Del Producto"
		Return 0
	Case obj.nflete<1
		This.cmensaje = "Seleccione Flete  Del Producto"
		Return 0
	Case obj.npeso<=0
		This.cmensaje = "Ingrese Peso referencial"
		Return 0
	Case obj.buscarpornombre(obj.cdesc, obj.nidart)<1
		This.cmensaje = obj.cmensaje
		Return 0
	Case Len(Alltrim(obj.ccodigo1))>0 And obj.buscarporcodigo(obj.ccodigo1, obj.nidart)<1
		This.cmensaje =obj.cmensaje
		Return 0
	Case obj.nPrec = 0 And (obj.np2 > 0 Or obj.np1 > 0 Or obj.np3 > 0)
		This.cmensaje="Ingrese El costo para determinar los precios de Venta"
		Return 0
	Case (obj.ncome*100)>10 Or (obj.ncomc*100)>10
		This.cmensaje="La comision no puede ser Mayor a 5%"
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarfletes()
	obj=(This.oobjeto)
	Do Case
	Case Empty(obj.cdesc)
		This.cmensaje = "Ingrese la Descripción del Costo Por Fletes"
		Return 0
	Case obj.cmodo='M' And obj.idflete<1
		This.cmensaje="Seleccione Una Linea"
		Return 0
	Case obj.buscarsiexiste()<1
		This.cmensaje=obj.cmensaje
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarclientes()
	obj=(This.oobjeto)
	Do Case
	Case Len(Alltrim(obj.nombre))<1
		This.cmensaje = "Ingrese Nombre del Cliente"
		Return 0
	Case obj.buscanombre(obj.cmodo, obj.nombre, obj.codigo) <1
		This.cmensaje =obj.cmensaje
		Return 0
	Case Len(Alltrim(obj.ndni))>1 And Len(Alltrim(obj.ndni))<>8
		This.cmensaje ="Ingrese DNI Válido"
		Return 0
	Case Len(Alltrim(obj.ndni))=8 And  obj.buscardni(obj.ndni,obj.codigo,obj.cmodo)<1
		This.cmensaje = "DNI ya Registrado"
		Return 0
	Case Len(Alltrim(obj.nruc)) = 11 And !ValidaRuc(obj.nruc)
		This.cmensaje = "RUC NO Válido"
		Return 0
	Case Len(Alltrim(obj.nruc)) = 11 And ValidaRuc(obj.nruc)
		If obj.buscaruc(obj.cmodo, obj.nruc, obj.codigo)<1 Then
			This.cmensaje =obj.cmensaje
			Return 0
		Endif
		Return 1
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validarproveedores()
	obj=This.oobjeto
	Do Case
	Case Empty(obj.nombre)
		This.cmensaje="Ingrese Nombre del Proveedor"
		Return 0
	Case Len(Alltrim(obj.nruc)) = 11 And !ValidaRuc(obj.nruc)
		This.cmensaje = "RUC NO Válido"
		Return 0
	Case Len(Alltrim(obj.nruc)) = 11 And ValidaRuc(obj.nruc)
		If obj.buscaruc(obj.cmodo, obj.nruc, obj.codigo)<1 Then
			This.cmensaje =obj.cmensaje
			Return 0
		Endif
		Return 1
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function validargrupos()
	obj=This.oobjeto
	Do Case
	Case Len(Alltrim(obj.descgrupo))<1
		This.cmensaje="Ingrese el Nombre del Grupo"
		Return 0
	Case obj.cmodo='M' And obj.nidgrupo<1
		This.cmensaje="Seleccion  un Grupo Para Editar"
		Return 0
	Case obj.buscarsiexiste()<1
		This.cmensaje="Nombre de Grupo Ya Registrado"
		Return 0
	Otherwise
		Return  1
	Endcase
	Endfunc
	Function validarproductosxsysz()
	obj=This.oobjeto
	Do Case
	Case  Len(Alltrim(obj.cdesc))<1
		Thi.cmensaje="Ingrese Descripción del Producto"
		Return 0
	Case  Empty(obj.ccodigo1) Or  Empty(obj.ccodigo2)
		This.cmensaje="Ingrese Un Código Válido Para este producto"
		Return 0
	Case Len(Alltrim(obj.ccolores))<1
		This.cmensaje="Selecciona Un Color "
		Return 0
	Case Len(Alltrim(obj.ctallas))<1
		This.cmensaje="Selecciona Una Talla "
		Return 0
	Case Len(Alltrim(obj.csexo))<1
		This.cmensaje="Selecciona Un Modelo"
		Return 0
	Case Len(Alltrim(obj.ctipo))<1
		This.cmensaje="Selecciona Un  Tipo de Sexo "
		Return 0
	Case obj.buscarporcodigoxsysz(obj.ccodigo1+obj.ccodigo2, obj.nidart)<1
		This.cmensaje =obj.cmensaje
		Return 0	
	Otherwise
		Return 1
	Endcase
	ENDFUNC
	Function validardctos()
	obj=This.oobjeto
	Do Case
	Case Empty(obj.codigosunat)
		This.cmensaje="Ingrese Código de Documento"
		Return 0
	Case Len(Alltrim(obj.descdcto))=0
		This.cmensaje="Ingrese Descripción de Documento"
		Return 0
	Case obj.VerificaCodDcto(obj.codigosunat,obj.idcodigo)<1
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
Enddefine
