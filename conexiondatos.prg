Define Class CAD_DATOS_REMOTOS As Custom
*
	Protected cBaseDatos, cComando, cContrasena, cDriverODBC, cIP, cMensajeError, cMotorSQL, cPuerto, cRol, cTipoTransaccion, cUsuario, lResultadoOK, ;
		nHandle

	cBaseDatos       = ""      && La Base de Datos actual
	cComando         = ""      && Comando enviado al Servidor
	cContrasena      = ""      && Contraseña (password) de un usuario de la Base de Datos
	cDriverODBC      = ""      && Driver usado para poder comunicar al Cliente con el Servidor
	cIP              = ""      && Dirección IP de la computadora donde se encuentra el Servidor SQL
	cMensajeError    = ""      && Mensaje que muestra el último error ocurrido
	cMotorSQL        = ""      && Motor SQL que se quiere utilizar
	cPuerto          = ""      && Puerto de la computadora que se usará para la conexión a la Base de Datos
	cRol             = ""      && Rol con el cual quiere conectarse el usuario de la Base de Datos
	cTipoTransaccion = ""      && El tipo de la transacción abierta. Siempre debe abrirse una transacción antes de solicitarle algo al Servidor
	cUsuario         = ""      && Nombre del usuario de la Base de Datos
	lResultadoOK     = .F.     && El resultado de la última operación ejecutada en la Base de Datos
	nHandle          = 0       && El "handle" de la conexión a la Base de Datos


	bdconn = .F.
	cdriver = ""
	cservidor = ""
	cdatabase = ""
	cuid = ""
	cpwd = ""
	tipoconexion = ""
	multiempresa = ""
	diasenviocpe = ""
	cdatos = ""
	vercostos = ""
	seriecreditos = ""
	firmaryenviarxml = ""
	imprimirfacturanormal = ""
	mostrarcpeadmin = ""
	precioventaeditable = ""
	tiponegocio = ""
	impresionticket = ""
	costostock = ""
	soloprecios = ""
	ventascpedidos = ""
	controlcontometros = ""
	facturarpedidos = ""
	ventasalmaceninterno = 0
	menumain = ""
	todoenuno = ""
	solounaislapormaquina = .F.
	emisionelectronica = ""
	seriealterna = ""
	ose = ""
	pedidosotraimpresora = ""
	solounaserie = ""
	precioavalidar = ""
	impresioncompleta = ""
	emitirguiaselectronicas = ""
	titulotiendas = ""
	fechavtaeditable = ""
	seriemarket = ""
	conectacontrolador = ""
	turnosm = ""
	nroturnos = 0
	logotipo = ""
	fondo = ""
	barrak = "Barra Herramientas Principal"
	barraventas = "BarraVentas"
	urlsunat = ""
*-- Si tiene Lector de Codifgo de Barras
	lectorcodigobarras = ""
*-- Verifica Si los precios d venta estan OK de acuerdo a los costos
	verificarpreciosventa = ""
*-- Para  firma con libreria DLL
	firmarcondll = ""
	grabarxmlbd = ""
*-- Muestra Todos los Productos
	mostrartodoslosproductos = ""
	idclientegenerico = ""
	emisorguiasremisionelectronica = "Si Es Emisor Guias Remtente"
	impresionpreventa = ""
	seriedefault = ""
	cajeroxtienda = ""
	productoscp = ""
	smtp = ""
	puerto = ""
	inicioenvios = ""
	regimencontribuyente = .F.
	ventascondecimales = ""
	otraimpresionvtas = ""
	otraimpresora = ""
*-- Id Oferta Limitada
	codigopromocion = ""
	controloferta = .F.
*-- Para Impresión normal
	impresoranormal = ""
	facturaguia = ""
	concopia = ""
	conformato = .F.
	imprimevuelto = ""
	validarprecio = ""
	url = ""
	empresa = ""
	proveedorajuste = ""
	tiendaconcopia = ""
	cajeroserie2 = .F.
	cajeroserie3 = .F.
	clienteconproyectos = ""
	rutacertificado = ""
	cajeroserie1 = ""
	listapreciosportienda = .F.
	ccorreo = ""
	codigosucursal = .F.
	rnegocio = ""
	otraimpresora1 = ""
	validarcredito = .F.
	traspasoautomatico = ""
	clientesconretencion = .F.
	dctosvtas = ""
	cajasinsaldo = ""
	vtasdepositoefectivo = ""
	cajacontipogasto = ""


*
	Function DO_ABRIR_TRANSACCION_ABM1
	Local lcMensajeError, lcComando, llComandoOK
	lcMensajeError = ""
*--- Si no hay conexión con el Servidor, no se puede continuar
	If !This.HAY_CONEXION_CON_SERVIDOR() Then
		This.REGISTRAR_ERROR_EN_ARCHIVO("No hay conexión con el Servidor. Verifica la red")
		Return (.F.)
	Endif
*--- Si hay conexión con el Servidor, se intenta abrir una nueva transacción
	If Empty(This.cTipoTransaccion) Then     && Se intenta abrir una nueva transacción solamente si no había ya una transacción abierta
		This.cTipoTransaccion = "ABM1"
		lcComando   = "SET TRANSACTION READ WRITE WAIT READ COMMITTED RECORD_VERSION"
		llComandoOK = This.DO_SQL_EJECUTAR(lcComando)
		If !llComandoOK Then
			This.cTipoTransaccion = ""
			lcMensajeError        = "No se pudo abrir la transacción de tipo ABM1"
		Endif
	Else
		lcMensajeError = "Ya hay una transacción abierta. Ciérrala antes de intentar abrir una nueva transacción"
	Endif
	Return (lcMensajeError)
	Endfunc
*
	Function DO_ABRIR_TRANSACCION_INFORME
	Local lcMensajeError, lcComando, llComandoOK
	lcMensajeError = ""
*--- Si no hay conexión con el Servidor, no se puede continuar
	If !This.HAY_CONEXION_CON_SERVIDOR() Then
		This.REGISTRAR_ERROR_EN_ARCHIVO("No hay conexión con el Servidor. Verifica la red")
		Return (.F.)
	Endif
*--- Si hay conexión con el Servidor, se intenta abrir una nueva transacción
	If Empty(This.cTipoTransaccion) Then     && Se intenta abrir una nueva transacción solamente si no había ya una transacción abierta
		lcComando   = "SET TRANSACTION READ ONLY SNAPSHOT NO WAIT"
		llComandoOK = This.DO_SQL_EJECUTAR(lcComando)
		If llComandoOK Then
			This.cTipoTransaccion = "INFORME"
		Else
			lcMensajeError = "No se pudo abrir la transacción de tipo INFORME"
		Endif
	Else
		lcMensajeError = "Ya hay una transacción abierta. Ciérrala antes de intentar abrir una nueva transacción"
	Endif
	Return (lcMensajeError)
	Endfunc
*
*--- Cierra la transacción abierta
	Function DO_CERRAR_TRANSACCION
	Lparameters tcTipoCierre
	Local lcMensajeError, lcComando, llComandoOK
	lcMensajeError = ""
	If !Empty(This.cTipoTransaccion) Then
		lcComando   = Iif(Vartype(tcTipoCierre) <> "C" .Or. Empty(tcTipoCierre), "CONFIRMAR", tcTipoCierre)
		lcComando   = Upper(lcComando)
		lcComando   = Iif(lcComando <> "CONFIRMAR" .And. lcComando <> "DESHACER", "CONFIRMAR", lcComando)
		lcComando   = Iif(lcComando == "CONFIRMAR", "COMMIT", "ROLLBACK")
		llComandoOK = This.DO_SQL_EJECUTAR(lcComando)
		If llComandoOK Then
			This.cTipoTransaccion = ""
		Else
			lcMensajeError = "No se pudo cerrar la transacción"
		Endif
	Else
		lcMensajeError = "No pude cerrar la transacción. No hay una transacción abierta"
	Endif
	Return (lcMensajeError)
	Endfunc
*
*--- Se conecta con la Base de Datos
	Function DO_CONECTAR_BASEDATOS
	Lparameters tcBaseDatos, tcIP, tcUsuario, tcContrasena, tcRol,tcmotorsql,tcconector
	Local lcCadenaConexion, lcBaseDatos
*--- Primero, se valida que todas las propiedades tengan valores
	With This
		If Empty(tcBaseDatos) Then
			.cMensajeError = "No has especificado el nombre de la Base de Datos"
			Return (.F.)
		Endif
	Endwith
*--- Segundo, se intenta la conexión con la Base de Datos
	With This
		.cContrasena = Alltrim(tcContrasena)

		.cRol        = tcRol
		.cUsuario    = Alltrim(tcUsuario)
		.cBaseDatos  = Iif(!Empty(tcIP), tcIP + Iif(!Empty(.cPuerto), "/" + .cPuerto, "") + ":", "") + tcBaseDatos
		Do Case
		Case This.cMotorSQL = "Firebird"
			.cDriverODBC = "{Firebird/Interbase(r) driver}"
			.cMotorSQL   = "Firebird"
			.cPuerto     = "3050"
			lcCadenaConexion = "DRIVER=   " + .cDriverODBC + ";" ;
				+ "USER=     " + .cUsuario    + ";" ;
				+ "PASSWORD= " + .cContrasena + ";" ;
				+ "ROLE=     " + .cRol        + ";" ;
				+ "DATABASE= " + .cBaseDatos  + ";" ;
				+ "OPTIONS=  " + "131329;"
		Case This.cMotorSQL = "Mysql"
			If Len(Alltrim(tconector))=0 Then
				.cDriverODBC = "{MySQL ODBC 5.1 Driver}"
			Else
				.cDriverODBC = Alltrim(cconector)
			Endif
			.cMotorSQL   = "Mysql"
			.cPuerto     = "3306"
			lcCadenaConexion = "DRIVER=   " + .cDriverODBC + ";" ;
				+ "USER=     " + .cUsuario    + ";" ;
				+ "PASSWORD= " + .cContrasena + ";" ;
				+ "DATABASE= " + .cBaseDatos  + ";" ;
				+ "OPTIONS=  " + "131329;"
			SQLSetprop(0,"DispLogin",3)
		Endcase
		.nHandle = Sqlstringconnect(lcCadenaConexion)
		If .nHandle < 0 Then
			.cMensajeError = "No me pude conectar a la Base de Datos. Verifica usuario, contraseña, y que la Base de Datos existe en esa ubicación"
			.nHandle       = 0
			This.REGISTRAR_ERROR_EN_ARCHIVO()     && Ocurrió algún error, registrarlo para poder verificarlo y corregirlo
		Endif
		goapp.bdconn=.nHandle
	Endwith
	Endfunc
*
	Function DO_DESCONECTAR_BASEDATOS
	Local lnResultado
	With This
		lnResultado = SQLDisconnect(.nHandle)               && Trata de desconectarse de la Base de Datos
		.nHandle    = Iif(lnResultado > 0, 0, .nHandle)     && Si la desconexión tuvo éxito, .nHandle vuelve a valer cero (o sea, no hay conexión)
	Endwith
	Return (lnResultado)
	Endfunc
*
	Protected Function EJECUTAR_STORED_PROCEDURE
		Lparameters toDatosRemotos, toDatosSolicitud
		Local llResultadoOK

		llResultadoOK = .T.     && Se supone que todo saldrá bien

		Do Case
		Case toDatosSolicitud.cNombrePrograma == "ABM_CLIENTES"
			llResultadoOK = CAD_CLIENTES(toDatosRemotos, toDatosSolicitud)
		Case toDatosSolicitud.cNombrePrograma == "ABM_CONFIGURACION"
			llResultadoOK = CAD_CONFIGURACION(toDatosRemotos, toDatosSolicitud)
		Case toDatosSolicitud.cNombrePrograma == "ABM_PRODUCTOS"
			llResultadoOK = CAD_PRODUCTOS(toDatosRemotos, toDatosSolicitud)
		Case toDatosSolicitud.cNombrePrograma == "ABM_VENTAS"
			llResultadoOK = CAD_VENTAS(toDatosRemotos, toDatosSolicitud)
		Case toDatosSolicitud.cNombrePrograma == "FACTURA_IMPRESA"
			llResultadoOK = CAD_STORED_PROCEDURES(toDatosRemotos, toDatosSolicitud)
		Case toDatosSolicitud.cNombrePrograma == "GRAFICOS_MENSUALES"
			llResultadoOK = CAD_STORED_PROCEDURES(toDatosRemotos, toDatosSolicitud)
		Case toDatosSolicitud.cNombrePrograma == "SIGUIENTE_COMPROBANTE"
			llResultadoOK = CAD_STORED_PROCEDURES(toDatosRemotos, toDatosSolicitud)
		Endcase

		Return (llResultadoOK)

		Endfunc
*
	Function DO_ENVIAR_SOLICITUD
	Lparameters toDatosSolicitud
	Local lcObjetoBaseDatos, lcComando, llComandoOK, lnCantidadElementos, lcMensajeError

	#INCLUDE GLOBALES.H

	This.cMensajeError = ""

	If Empty(This.cTipoTransaccion) Then
		This.cMensajeError = "No hay una transacción abierta. Contacta con Asistencia Técnica"
		Return (.F.)
	Endif

	With toDatosSolicitud
		Do Case
		Case .cNombreTarea == "BORRAR"
			llComandoOK        = This.EJECUTAR_STORED_PROCEDURE(This, toDatosSolicitud)
			This.cMensajeError = Iif(!llComandoOK, "No se pudieron borrar estos datos", "")
		Case .cNombreTarea == "CONSULTAR"
			lcObjetoBaseDatos = This.OBTENER_VISTA_BASEDATOS(.cNombrePrograma, .nNumeroVista, .uParametro1, .uParametro2)     && Se obtiene el nombre de la Vista
			If !Empty(lcObjetoBaseDatos) Then
				lcComando   = "SELECT " + .cColumnas + " "
				lcComando   = lcComando + "FROM " + lcObjetoBaseDatos + " "
				lcComando   = lcComando + Iif(!Empty(.cWhere)  , "WHERE "    + .cWhere   + " ", "")
				lcComando   = lcComando + Iif(!Empty(.cGroupBy), "GROUP BY " + .cGroupBy + " ", "")
				lcComando   = lcComando + Iif(!Empty(.cHaving) , "HAVING "   + .cHaving  + " ", "")
				lcComando   = lcComando + Iif(!Empty(.cOrderBy), "ORDER BY " + .cOrderBy + " ", "")
				llComandoOK = This.DO_SQL_EJECUTAR(lcComando, toDatosSolicitud.cCursorConsulta)
				If !llComandoOK Then     && Si ocurrió un error en el Servidor
					If Empty(This.cMensajeError) Then
						lnCantidadElementos = Aerror(laErrores)
						If lnCantidadElementos > 0 Then
							lcMensajeError = laErrores[2]
							lcMensajeError = Strtran(lcMensajeError, "Connectivity error: [ODBC Firebird Driver]", "")
						Else
							lcMensajeError = "No pude obtener la vista " + lcObjetoBaseDatos
						Endif
						This.cMensajeError = lcMensajeError
					Endif
				Endif
			Else
				This.cMensajeError = "En el método .OBTENER_VISTA_BASEDATOS() no existe el programa: " + Chr(KEY_ENTER) + toDatosSolicitud.cNombrePrograma
			Endif
		Case .cNombreTarea == "DESHACER"
			llComandoOK = This.DO_SQL_EJECUTAR("ROLLBACK", toDatosSolicitud.cCursorResultado)
		Case .cNombreTarea == "EJECUTAR"
			llComandoOK        = This.EJECUTAR_STORED_PROCEDURE(This, toDatosSolicitud)
			This.cMensajeError = Iif(!llComandoOK, "Falló la ejecución del stored procedure", "")
		Case .cNombreTarea == "GRABAR"
			llComandoOK        = This.EJECUTAR_STORED_PROCEDURE(This, toDatosSolicitud)
			This.cMensajeError = Iif(!llComandoOK, "No se pudieron grabar estos datos. Verifícalos", "")
		Endcase
		If .cNombreTarea == "CONFIRMAR" .Or. .lConfirmar Then     && Si quiere un COMMIT manual o automático
			llComandoOK        = This.DO_SQL_EJECUTAR("COMMIT", toDatosSolicitud.cCursorResultado)
			This.cMensajeError = Iif(!llComandoOK, "Falló la confirmación, los datos no fueron grabados en el Servidor", "")
		Endif
	Endwith

	Return (llComandoOK)

	Endfunc
*
*--- Devuelve el valor de la propiedad .nHandle
	Function GET_HANDLE
	Return (This.nHandle)
	Endfunc
*
*--- Devuelve el valor de la propiedad .cMensajeError
	Function GET_MENSAJE_ERROR
	Return (This.cMensajeError)
	Endfunc
*
*--- Verifica si hay una conexión activa con el Servidor
	Protected Function HAY_CONEXION_CON_SERVIDOR
		Local lcAlias, lcCursorTemporal, llResultadoOK

		lcAlias          = Alias()
		lcCursorTemporal = "TEMP_" + Sys(3)
		llResultadoOK    = SQLExec(This.nHandle, "SET @ZXC:=00", lcCursorTemporal) = 1

		If Used(lcCursorTemporal) Then
			Select (lcCursorTemporal)
			Use
		Endif

		If !Empty(lcAlias) .And. Used(lcAlias) Then
			Select (lcAlias)
		Endif

		Return (llResultadoOK)

		Endfunc
*
*--- Se obtiene el nombre que tiene la vista en la Base de Datos
	Protected Function OBTENER_VISTA_BASEDATOS
		Lparameters tcPrograma, tnNumeroVista, tcParametro1, tcParametro2
		Local lcNombreVista
		tnNumeroVista = Iif(Vartype(tnNumeroVista) <> "N", 1, tnNumeroVista)
		lcNombreVista = ""
		Do Case
		Case tcPrograma == "ABM_CLIENTES"
			lcNombreVista = "V_DEMO_ABM_CLIENTES"
		Case tcPrograma == "ABM_CONFIGURACION"
			lcNombreVista = "V_DEMO_ABM_CONFIGURACION"
		Case tcPrograma == "ABM_IMPUESTOS"
			lcNombreVista = "V_DEMO_ABM_IMPUESTOS"
		Case tcPrograma == "ABM_PRODUCTOS"
			Do Case
			Case tnNumeroVista = 1
				lcNombreVista = "V_DEMO_ABM_PRODUCTOS"
			Case tnNumeroVista = 2
				lcNombreVista = "V_DEMO_PRODUCTOSFOT"
			Endcase
		Case tcPrograma == "ABM_TIPOS_COMPROBANTES"
			lcNombreVista = "V_DEMO_ABM_TIPOS_COMPROB"
		Case tcPrograma == "ABM_TIPOS_IDENTIFICACIONES"
			lcNombreVista = "V_DEMO_ABM_TIPOS_IDENTIF"
		Case tcPrograma == "ABM_VENTAS"
			Do Case
			Case tnNumeroVista = 1
				lcNombreVista = "V_DEMO_ABM_VENTAS"
			Case tnNumeroVista = 2
				lcNombreVista = "V_DEMO_VENTASDET"
			Case tnNumeroVista = 3
				lcNombreVista = "V_DEMO_VENTASCUO"
			Endcase
		Case tcPrograma == "CONSULTAS_CLIENTES"
			Do Case
			Case tnNumeroVista = 1
				lcNombreVista = "SP_DEMO_CONSULTAS_CLIENTES(" + tcParametro1 + ", " + tcParametro2 + ")"
			Case tnNumeroVista = 2
				lcNombreVista = "V_DEMO_ABM_VENTAS"
			Endcase
		Case tcPrograma == "CONSULTAS_PRODUCTOS"
			lcNombreVista = "V_DEMO_CONSULTAS_PRODUCTOS"
		Case tcPrograma == "GRAFICOS_MENSUALES"
			lcNombreVista = "V_DEMO_VENTAS_MENSUALES WHERE PVM_ANOXXX = " + tcParametro1
		Case tcPrograma == "LST01"
			lcNombreVista = "V_DEMO_ABM_CLIENTES"
		Case tcPrograma == "LST02"
			lcNombreVista = "V_DEMO_ABM_PRODUCTOS"
		Case tcPrograma == "LST03"
			lcNombreVista = "V_DEMO_ABM_VENTAS"
		Case tcPrograma == "LST04"
			lcNombreVista = "V_DEMO_VENTASDET"
		Case tcPrograma == "LST05"
			lcNombreVista = "V_DEMO_ABM_VENTAS"
		Case tcPrograma == "METADATOS"
			lcNombreVista = tcParametro1
		Endcase
		Return (lcNombreVista)
		Endfunc
*
*--- Se encapsula a la función SQLEXEC() para darle más funcionalidad
	Function DO_SQL_EJECUTAR
	Lparameters tcComando, tcCursor
	Local lnI, lcArchivoConsultas, llComandoOK

	#Define KEY_CRLF Chr(13) + Chr(10)

	This.cComando = tcComando

*--- Si no hay una transacción abierta, no se puede continuar
	If Empty(This.cTipoTransaccion) .And. Left(tcComando, 15) <> "SET TRANSACTION" Then
		This.REGISTRAR_ERROR_EN_ARCHIVO("No hay una transacción abierta. Contacta con Asistencia Técnica")
		Return (.F.)
	Endif

*=== Si no se detectaron errores, se continúa ===

	tcCursor = Iif(Vartype(tcCursor) <> "C", "SQL_RESULTADO", tcCursor)

	tcComando = Upper(tcComando)

*--- Todos los comandos SELECT se envían a un archivo de texto para que puedan ser revisados
	If Left(tcComando, 6) == "SELECT" Then
		lcArchivoConsultas = _Screen.cCarpetaUbicacionEjecutable + "SQL_CONSULTAS.TXT"           && Nombre del archivo en el cual se grabarán todos los SELECT
		=Strtofile(Dtoc(Date()) + "   " + Left(Time(), 5) + KEY_CRLF, lcArchivoConsultas, 1)     && Se graban la fecha y la hora en que se ejecutó el SELECT
		=Strtofile(tcComando                              + KEY_CRLF, lcArchivoConsultas, 1)     && Los datos del SELECT se graban en un archivo de texto
		=Strtofile(Replicate("-", 80)                     + KEY_CRLF, lcArchivoConsultas, 1)     && Se pone una línea de 80 guiones para separar del siguiente SELECT
	Endif

*--- Los parámetros de una nueva transacción solamente tienen efecto después del COMMIT
	If Left(tcComando, 15) == "SET TRANSACTION" Then
		llComandoOK = SQLExec(This.nHandle, "COMMIT") = 1
	Endif

*--- Se envía el comando al Servidor
	llComandoOK = SQLExec(This.nHandle, tcComando, tcCursor) = 1     && Si la función SQLEXEC() devuelve 1 entonces terminó exitosamente

*--- Si ocurrió algún error, se registra ese error en un archivo de texto
	If !llComandoOK Then
		This.REGISTRAR_ERROR_EN_ARCHIVO()     && Ocurrió algún error, registrarlo en un archivo de texto para poder verificarlo y corregirlo
	Endif

*--- llComandoOK = .T. si el comando se ejecutó exitosamente
	Return (llComandoOK)

	Endfunc
*
*--- Todos los errores de SQL se registran en el archivo SQL_ERRORES.TXT para poder consultar ese archivo y saber donde estuvo el problema
	Procedure REGISTRAR_ERROR_EN_ARCHIVO
	Lparameters tcMensajeError
	Local lnNumElementos, lcNombreArchivoLog, lcElemento

	#Define KEY_CRLF Chr(13) + Chr(10)

	lcNombreArchivoLog = _Screen.cCarpetaUbicacionEjecutable + "SQL_ERRORES.TXT"     && Nombre del archivo en el cual se grabarán los errores encontrados. Hay que verificar este archivo periódicamente.

	If Vartype(tcMensajeError) <> "C" Then
		lnNumElementos = Aerror(laErrorArray)     && En el array laErrorArray se encontrarán todos los datos del último error ocurrido
		If lnNumElementos >= 1 Then     && Si se encontró algún error
			lcElemento = laErrorArray[2]
			lcElemento = Strtran(lcElemento, "Connectivity error: [ODBC Firebird Driver]", "")
		Endif
	Else
		lcElemento = tcMensajeError
	Endif

	=Strtofile(Dtoc(Date()) + "   " + Left(Time(), 5) + KEY_CRLF, lcNombreArchivoLog, 1)     && Los datos del último error ocurrido se graban en un archivo
	=Strtofile("Comando: " + This.cComando            + KEY_CRLF, lcNombreArchivoLog, 1)     && Los datos del último error ocurrido se graban en un archivo
	=Strtofile(KEY_CRLF + Replicate("-", 80)          + KEY_CRLF, lcNombreArchivoLog, 1)     && Los datos del último error ocurrido se graban en un archivo
	=Strtofile(lcElemento                                       , lcNombreArchivoLog, 1)     && Los datos del último error ocurrido se graban en un archivo
	=Strtofile(KEY_CRLF + Replicate("=", 80)          + KEY_CRLF, lcNombreArchivoLog, 1)     && Los datos del último error ocurrido se graban en un archivo

	This.cMensajeError = lcElemento

	Endproc
*
	Function do_conectardata
	Lparameters  nopcion
	Local loXmlHttp As "Microsoft.XMLHTTP"
	Local lcC1, lcHTML, lcURL
*:Global camino, cdatabase, cdriver, cempresa, cpw, cpw1, cpwd, cservidor, cuid, cusuario, cxml
*:Global cxml2, gnErrFile, nop, ocontrib
	If Type("nopcion") = "L" Then
		nop = goapp.xopcion
	Else
		nop = nopcion
	Endif
	Local idconecta As Integer
	Do Case
	Case nop = 0
		camino = Fullpath('conexion.txt')
		cxml   = Fullpath('conexion.xml')
	Case nop = 1
		camino = Fullpath('conexion1.txt')
		cxml   = Fullpath('conexion1.xml')
	Case nop = 2
		camino = Fullpath('conexion2.txt')
		cxml   = Fullpath('conexion2.xml')
	Case nop = 3
		camino = Fullpath('conexion3.txt')
		cxml   = Fullpath('conexion3.xml')
	Case nop = 4
		camino = Fullpath('conexion4.txt')
		cxml   = Fullpath('conexion4.xml')
	Case nop = 4
		camino = Fullpath('conexion4.txt')
	Case nop = 5
		camino = Fullpath('conexion5.txt')
	Case nop = 8
		camino = Fullpath('conexion8.txt')
		cxml   = Fullpath('conexion8.xml')
	Case nop = 9
		camino = Fullpath('conexion9.txt')
		cxml   = Fullpath('conexion9.xml')
	Otherwise
		camino = Fullpath('conexion.txt')
		cxml   = Fullpath('conexion.xml')
	Endcase
	cUsuario = ""
	cpw		 = ""
	cempresa = ""
	If File(camino)  && verificar si el archivo existe?
		gnErrFile = Fopen(camino, 12)&&si es así,abrir para leer y   escribir
		cservidor = Fgets(gnErrFile)
		cdatabase = Fgets(gnErrFile)
		cUsuario  = Fgets(gnErrFile)
		cpw1	  = Fgets(gnErrFile)
		cempresa  = Fgets(gnErrFile)
		cconector = Fgets(gnErrFile)
		= Fclose(gnErrFile)
	Else
		Return - 1
	Endif
	If Len(Alltrim(cempresa)) > 0 Then
		lcURL	  = Textmerge("http://compania-sysven.com/conexiones.php?empresa=<<cempresa>>")
		loXmlHttp = Createobject("Microsoft.XMLHTTP")
		loXmlHttp.Open('GET', lcURL, .F.)
		loXmlHttp.Send()
		If loXmlHttp.Status <> 200 Then
			This.cMensajeError="Servicio NO Disponible....." + Alltrim(Str(loXmlHttp.Status))
			Return - 1
		Endif
		lcHTML = loXmlHttp.responseText
		Set Procedure To  d:\librerias\json Additive
		ocontrib = json_decode(lcHTML)
		If Not Empty(json_getErrorMsg())
			This.cMensajeError= "No se Pudo Obtener la Información "
		Else
			If Len(Alltrim(ocontrib.Get('server'))) > 0 Then
				cservidor = Alltrim(ocontrib.Get('server'))
				cdatabase = Alltrim(ocontrib.Get('data'))
				cUsuario  = Alltrim(ocontrib.Get('usuario'))
				cpw1	  = Alltrim(ocontrib.Get('pwd'))
			Endif
		Endif
	Endif
	Set Procedure To capadatos, ple5 Additive
	If Empty(cservidor)
		If File(cxml) Then
			cxml2	  = Filetostr(cxml)
			cservidor = leerXMl(cxml2, '<Servidor>', '</Servidor>')
			cdatabase = leerXMl(cxml2, '<BD>', '</BD>')
			This.leerXMl(cxml2)
		Endif
	Endif
	If File(cjson) Then
		This.Leerjson(cjson)
	Endif
	cdriver = "{MySQL ODBC 5.1 Driver };Port=3306;"
	If Len(Alltrim(cUsuario)) = 0 Then
		cuid = "Eduar"
		cpwd = "peluza"
	Else
		cuid = cUsuario
		cpwd = cpw1
	Endif
	If Len(Alltrim(cconector))=0 Then
		lcC1 = "Driver={MySQL ODBC 5.1 Driver};Port=3306;Server=" + cservidor  + ";Database=" + Alltrim(cdatabase) + ";Uid=" + cuid + ";Pwd=" + cpwd + ";OPTION=131329;"
	Else
		lcC1 = "Driver={"+Alltrim(cconector)+"};Port=3306;Server=" + cservidor  + ";Database=" + Alltrim(cdatabase) + ";Uid=" + cuid + ";Pwd=" + cpwd + ";OPTION=131329;"
	Endif
	= SQLSetprop(0, "DispLogin", 3)
	idconecta = Sqlstringconnect(lcC1) && ESTABLECER LA CONEXION
	If idconecta < 1 Then
		=Aerror(laError)
		This.cMensajeError="Error al conectarse"+Chr(13)+"Description:"+laError[2]
		Return - 1
	Else
		= SQLSetprop(idconecta, 'PacketSize', 5000)
		Return idconecta
	Endif
	Endfunc

	Function Leerjson()
	Lparameters cjson

	Set Procedure  To d:\librerias\nfJsonRead.prg Additive
	oJson = nfJsonRead(cjson)
	This.tipoconexion		   = Iif(Vartype(oJson.Array(1).tipoconexion)='U','L',oJson.Array(1).tipoconexion)

	This.diasenviocpe		   = Iif(Vartype(oJson.Array(1).diasenviocpe)='U','2',oJson.Array(1).diasenviocpe)

	This.cdatos				   = Iif(Vartype(oJson.Array(1).cdatos)='U','', oJson.Array(1).cdatos)
	This.vercostos			   = Iif(Vartype(oJson.Array(1).vercostos)='U','', oJson.Array(1).vercostos)
	This.ose				   = Iif(Vartype(oJson.Array(1).ose)='U','', oJson.Array(1).ose)
	This.impresionticket	   = Iif(Vartype(oJson.Array(1).impresionticket)='U','', oJson.Array(1).impresionticket)
	This.clientesconretencion  = Iif(Vartype(oJson.Array(1).clientesconretencion)='U','', oJson.Array(1).clientesconretencion)
	This.grabarxmlbd		   = Iif(Vartype(oJson.Array(1).grabarxmlbd)='U','',oJson.Array(1).grabarxmlbd)
	This.impresioncompleta	   = Iif(Vartype(oJson.Array(1).impresioncompleta)='U','', oJson.Array(1).impresioncompleta)
	This.logotipo			   = Iif(Vartype(oJson.Array(1).logotipo)='U','', oJson.Array(1).logotipo)
	This.fondo				   = Iif(Vartype(oJson.Array(1).fondo)='U','', oJson.Array(1).fondo)
	This.rutacertificado       = Iif(Vartype(oJson.Array(1).rutacertificado)='U','', oJson.Array(1).rutacertificado)
	This.seriecreditos		   = Iif(Vartype(oJson.Array(1).seriecreditos)='U','', oJson.Array(1).seriecreditos)
	This.multiempresa		   = Iif(Vartype(oJson.Array(1).multiempresa)='U','', oJson.Array(1).multiempresa)
	This.controlcontometros	   = Iif(Vartype(oJson.Array(1).controlcontometros)='U','', oJson.Array(1).controlcontometros)
	This.soloprecios		   = Iif(Vartype(oJson.Array(1).soloprecios)='U','', oJson.Array(1).soloprecios)
	This.firmaryenviarxml	   = Iif(Vartype(oJson.Array(1).firmaryenviarxml)='U','', oJson.Array(1).firmaryenviarxml)
	This.imprimirfacturanormal = Iif(Vartype(oJson.Array(1).imprimirfacturanormal)='U','', oJson.Array(1).imprimirfacturanormal)
	This.mostrarcpeadmin	   = Iif(Vartype(oJson.Array(1).mostrarcpeadmin)='U','', oJson.Array(1).mostrarcpeadmin)
	This.precioventaeditable   = Iif(Vartype(oJson.Array(1).precioventaeditable)='U','', oJson.Array(1).precioventaeditable)
	This.tiponegocio		   = Iif(Vartype(oJson.Array(1).tiponegocio)='U','', oJson.Array(1).tiponegocio)
	This.costostock			   = Iif(Vartype(oJson.Array(1).costostock)='U','', oJson.Array(1).costostock)
	This.seriealterna		   = Iif(Vartype(oJson.Array(1).seriealterna)='U','', oJson.Array(1).seriealterna)
	This.ventascpedidos		   = Iif(Vartype(oJson.Array(1).ventascpedidos)='U','', oJson.Array(1).ventascpedidos)
	This.facturarpedidos	   = Iif(Vartype(oJson.Array(1).facturarpedidos)='U','', oJson.Array(1).facturarpedidos)
	This.ventasalmaceninterno  = Iif(Vartype(oJson.Array(1).ventasalmaceninterno)='U','', oJson.Array(1).ventasalmaceninterno)
	This.todoenuno			   = Iif(Vartype(oJson.Array(1).todoenuno)='U','', oJson.Array(1).todoenuno)
	This.solounaislapormaquina = Iif(Vartype(oJson.Array(1).solounaislapormaquina)='U','', oJson.Array(1).solounaislapormaquina)
	This.menumain			   = Iif(Vartype(oJson.Array(1).menumain)='U','', oJson.Array(1).menumain)
	This.emisionelectronica	   = Iif(Vartype(oJson.Array(1).emisionelectronica)='U','', oJson.Array(1).emisionelectronica)
	This.pedidosotraimpresora  = Iif(Vartype(oJson.Array(1).pedidosotraimpresora)='U','', oJson.Array(1).pedidosotraimpresora)

	This.cajeroxtienda		   = Iif(Vartype(oJson.Array(1).cajeroxtienda)='U','', oJson.Array(1).cajeroxtienda)
	This.precioavalidar		   = Iif(Vartype(oJson.Array(1).precioavalidar)='U','', oJson.Array(1).precioavalidar)
	This.solounaserie		   = Iif(Vartype(oJson.Array(1).solounaserie)='U','', oJson.Array(1).solounaserie)

	This.titulotiendas		   = Iif(Vartype(oJson.Array(1).titulotiendas)='U','', oJson.Array(1).titulotiendas)
	This.fechavtaeditable	   = Iif(Vartype(oJson.Array(1).fechavtaeditable)='U','', oJson.Array(1).fechavtaeditable)
*** Serie Parea Market
	This.seriemarket		= Iif(Vartype(oJson.Array(1).seriemarket)='U','', oJson.Array(1).seriemarket)
	This.conectacontrolador	= Iif(Vartype(oJson.Array(1).conectacontrolador)='U','', oJson.Array(1).conectacontrolador)
	This.turnosm			= Iif(Vartype(oJson.Array(1).turnosm)='U','', oJson.Array(1).turnosm)
	This.nroturnos			= Iif(Vartype(oJson.Array(1).nroturnos)='U','', oJson.Array(1).nroturnos)

	This.barrak				= Iif(Vartype(oJson.Array(1).barrak)='U','', oJson.Array(1).barrak)
	This.barraventas		= Iif(Vartype(oJson.Array(1).barraventas)='U','', oJson.Array(1).barraventas)
	This.urlsunat			= Iif(Vartype(oJson.Array(1).urlsunat)='U','', oJson.Array(1).urlsunat)
* Para Lector de barra en market
	This.lectorcodigobarras		  = Iif(Vartype(oJson.Array(1).lectorcodigobarras)='U','', oJson.Array(1).lectorcodigobarras)
	This.verificarpreciosventa	  = Iif(Vartype(oJson.Array(1).verificarpreciosventa)='U','', oJson.Array(1).verificarpreciosventa)
	This.firmarcondll			  = Iif(Vartype(oJson.Array(1).firmarcondll)='U','', oJson.Array(1).firmarcondll)
	This.mostrartodoslosproductos = Iif(Vartype(oJson.Array(1).mostrartodoslosproductos)='U','', oJson.Array(1).mostrartodoslosproductos)
**** CLiente Por defecto
	This.idclientegenerico				= Iif(Vartype(oJson.Array(1).idclientegenerico)='U','', oJson.Array(1).idclientegenerico)
	This.impresionpreventa				= Iif(Vartype(oJson.Array(1).impresionpreventa)='U','', oJson.Array(1).impresionpreventa)
	This.seriedefault					= Iif(Vartype(oJson.Array(1).seriedefault)='U','', oJson.Array(1).seriedefault)
	This.productoscp					= Iif(Vartype(oJson.Array(1).productoscp)='U','', oJson.Array(1).productoscp)
	This.emisorguiasremisionelectronica	= Iif(Vartype(oJson.Array(1).emisorguiasremisionelectronica)='U','', oJson.Array(1).emisorguiasremisionelectronica)
	This.smtp							= Iif(Vartype(oJson.Array(1).smtp)='U','', oJson.Array(1).smtp)
	This.puerto							= Iif(Vartype(oJson.Array(1).puerto)='U','', oJson.Array(1).puerto)

	This.regimencontribuyente = Iif(Vartype(oJson.Array(1).regimencontribuyente)='U','', oJson.Array(1).regimencontribuyente)
	This.inicioenvios		  = Iif(Vartype(oJson.Array(1).inicioenvios)='U','', oJson.Array(1).inicioenvios)
	This.ventascondecimales	  = Iif(Vartype(oJson.Array(1).ventascondecimales)='U','', oJson.Array(1).ventascondecimales)

*Nombre de Otras Impresoras para Imprimir una copia de las  Ventas*
	This.otraimpresora	= Iif(Vartype(oJson.Array(1).otraimpresora)='U','', oJson.Array(1).otraimpresora)
	This.otraimpresora1	= Iif(Vartype(oJson.Array(1).otraimpresora1)='U','', oJson.Array(1).otraimpresora1)
*Para Inprimir en Ventas una copia de le venta S=Si
	This.otraimpresionvtas = Iif(Vartype(oJson.Array(1).otraimpresionvtas)='U','', oJson.Array(1).otraimpresionvtas)
* Codigo del producto para promoción
	This.codigopromocion = Iif(Vartype(oJson.Array(1).codigopromocion)='U','', oJson.Array(1).codigopromocion)
*Para Controlar Ofertas
	This.controloferta = Iif(Vartype(oJson.Array(1).controloferta)='U','', oJson.Array(1).controloferta)
*Nombre de Impresora para generar los comprobantes en formato nornal-No Tickets
	This.impresoranormal = Iif(Vartype(oJson.Array(1).impresoranormal)='U','', oJson.Array(1).impresoranormal)
*Para Emitir Factura Guia
	This.facturaguia = Iif(Vartype(oJson.Array(1).facturaguia)='U','', oJson.Array(1).facturaguia)
*Para Imprinir Original y Copia
	This.concopia = Iif(Vartype(oJson.Array(1).concopia)='U','', oJson.Array(1).concopia)
*Para Imprimir con Formato Preimpreso
	This.conformato = Iif(Vartype(oJson.Array(1).conformato)='U','', oJson.Array(1).conformato)
*Para Imprimir el Vuelto en el Comprobante de Ventas
	This.imprimevuelto = Iif(Vartype(oJson.Array(1).imprimevuelto)='U','', oJson.Array(1).imprimevuelto)
*Url para subir los comprobantes al hosting
	If Empty(This.url) Then
		This.url = Iif(Vartype(oJson.Array(1).url)='U','', oJson.Array(1).url)
	Endif
*Número de Precio a Validar
	This.validarprecio = Iif(Vartype(oJson.Array(1).validarprecio)='U','', oJson.Array(1).validarprecio)
*Codigo del Proveedor para los ajustes de Inventarios
	This.proveedorajuste = Iif(Vartype(oJson.Array(1).proveedorajuste)='U','', oJson.Array(1).proveedorajuste)
*Código de la tienda para Imprimir una copia en almacen
	This.tiendaconcopia = Iif(Vartype(oJson.Array(1).tiendaconcopia)='U','', oJson.Array(1).tiendaconcopia)
* Cajero por Serie
	This.cajeroserie1 = Iif(Vartype(oJson.Array(1).cajeroserie1)='U','', oJson.Array(1).cajeroserie1)
	This.cajeroserie2 = Iif(Vartype(oJson.Array(1).cajeroserie2)='U','', oJson.Array(1).cajeroserie2)
	This.cajeroserie3 = Iif(Vartype(oJson.Array(1).cajeroserie3)='U','', oJson.Array(1).cajeroserie3)
***Cliente Con Varios Proyecctos(Cava)
	This.clienteconproyectos = Iif(Vartype(oJson.Array(1).clienteconproyectos)='U','', oJson.Array(1).clienteconproyectos)
**   Ruta del Certificado

*
**  Lista de Precios por Tienda
	This.listapreciosportienda = Iif(Vartype(oJson.Array(1).listapreciosportienda)='U','', oJson.Array(1).listapreciosportienda)
************
*Con copia a otro correo
	This.ccorreo = Iif(Vartype(oJson.Array(1).ccorreo)='U','', oJson.Array(1).ccorreo)
***Id de sucursal
	This.codigosucursal = Iif(Vartype(oJson.Array(1).codigosucursal)='U','', oJson.Array(1).codigosucursal)
***********Validar Crédito en ventas
	This.validarcredito = Iif(Vartype(oJson.Array(1).validarcredito)='U','', oJson.Array(1).validarcredito)
**********Para Traspasos entre almacenes
	This.traspasoautomatico = Iif(Vartype(oJson.Array(1).traspasoautomatico)='U','', oJson.Array(1).traspasoautomatico)
***************

	This.dctosvtas= Iif(Vartype(oJson.Array(1).dctosvtas)='U','', oJson.Array(1).dctosvtas)
	This.cajasinsaldo=Iif(Vartype(oJson.Array(1).cajasinsaldo)='U','', oJson.Array(1).cajasinsaldo)
	This.vtasdepositoefectivo=Iif(Vartype(oJson.Array(1).vtasdepositoefectivo)='U','', oJson.Array(1).vtasdepositoefectivo)

************para clasifivcar el tipo de gasto
	This.cajacontipogasto=Iif(Vartype(oJson.Array(1).cajacontipogasto)='U','', oJson.Array(1).cajacontipogasto)

	Endfunc

	Function leerXMl
	Lparameters cxml2


**SET PROCEDURE  TO "e:\nfjson-master\nfjson\nfjsonread.prg" additive
**oJson = nfJsonRead( 'd:\psysb\conexion1.json')
**?oJson.array(1).fondo


	This.seriecreditos		   = leerXMl(cxml2, '<Seriecreditos>', '</Seriecreditos>')
	This.tipoconexion		   = leerXMl(cxml2, '<tipoconexion>', '</tipoconexion>')
	This.multiempresa		   = leerXMl(cxml2, '<Multiempresa>', '</Multiempresa>')
	This.diasenviocpe		   = leerXMl(cxml2, '<Diasenviocpe>', '</Diasenviocpe>')
	This.controlcontometros	   = leerXMl(cxml2, '<Controlcontometros>', '</Controlcontometros>')
	This.cdatos				   = leerXMl(cxml2, '<Cdatos>', '</Cdatos>')
	This.vercostos			   = leerXMl(cxml2, '<Vercostos>', '</Vercostos>')
	This.soloprecios		   = leerXMl(cxml2, '<Soloprecios>', '</Soloprecios>')
	This.firmaryenviarxml	   = leerXMl(cxml2, '<Firmaryenviarxml>', '</Firmaryenviarxml>')
	This.imprimirfacturanormal = leerXMl(cxml2, '<ImprimirFacturaNormal>', '</ImprimirFacturaNormal>')
	This.mostrarcpeadmin	   = leerXMl(cxml2, '<Mostrarcpeadmin>', '</Mostrarcpeadmin>')
	This.impresionticket	   = leerXMl(cxml2, '<ImpresionTicket>', '</ImpresionTicket>')
	This.precioventaeditable   = leerXMl(cxml2, '<Precioventaeditable>', '</Precioventaeditable>')
	This.tiponegocio		   = leerXMl(cxml2, '<Tiponegocio>', '</Tiponegocio>')
	This.costostock			   = leerXMl(cxml2, '<Costostock>', '</Costostock>')
	This.seriealterna		   = leerXMl(cxml2, '<Seriealterna>', '</Seriealterna>')
	This.ventascpedidos		   = leerXMl(cxml2, '<Ventascpedidos>', '</Ventascpedidos>')
	This.facturarpedidos	   = leerXMl(cxml2, '<Facturarpedidos>', '</Facturarpedidos>')
	This.ventasalmaceninterno  = leerXMl(cxml2, '<Ventasalmaceninterno>', '</Ventasalmaceninterno>')
	This.todoenuno			   = leerXMl(cxml2, '<Todoenuno>', '</Todoenuno>')
	This.solounaislapormaquina = leerXMl(cxml2, '<Solounaislapormaquina>', '</Solounaislapormaquina>')
	This.menumain			   = leerXMl(cxml2, '<Menumain>', '</Menumain>')
	This.emisionelectronica	   = leerXMl(cxml2, '<EmisionElectronica>', '</EmisionElectronica>')
	This.pedidosotraimpresora  = leerXMl(cxml2, '<Pedidosotraimpresora>', '</Pedidosotraimpresora>')
	This.ose				   = leerXMl(cxml2, '<ose>', '</ose>')
	This.cajeroxtienda		   = leerXMl(cxml2, '<CajeroxTienda>', '</CajeroxTienda>')
	This.precioavalidar		   = leerXMl(cxml2, '<Precioavalidar>', '</Precioavalidar>')
	This.solounaserie		   = leerXMl(cxml2, '<Solounaserie>', '</Solounaserie>')
	This.impresioncompleta	   = leerXMl(cxml2, '<Impresioncompleta>', '</Impresioncompleta>')
	This.titulotiendas		   = leerXMl(cxml2, '<TituloTiendas>', '</TituloTiendas>')
	This.fechavtaeditable	   = leerXMl(cxml2, '<Fechavtaeditable>', '</Fechavtaeditable>')
*** Serie Parea Market
	This.seriemarket		= leerXMl(cxml2, '<Seriemarket>', '</Seriemarket>')
	This.conectacontrolador	= leerXMl(cxml2, '<ConectaControlador>', '</ConectaControlador>')
	This.turnosm			= leerXMl(cxml2, '<Turnosm>', '</Turnosm>')
	This.nroturnos			= leerXMl(cxml2, '<nroturnos>', '</nroturnos>')
	This.logotipo			= leerXMl(cxml2, '<logotipo>', '</logotipo>')
	This.fondo				= leerXMl(cxml2, '<fondo>', '</fondo>')
	This.barrak				= leerXMl(cxml2, '<barrak>', '</barrak>')
	This.barraventas		= leerXMl(cxml2, '<barraventas>', '</barraventas>')
	This.urlsunat			= leerXMl(cxml2, '<urlsunat>', '</urlsunat>')
* Para Lector de barra en market
	This.lectorcodigobarras		  = leerXMl(cxml2, '<Lectorcodigobarras>', '</Lectorcodigobarras>')
	This.verificarpreciosventa	  = leerXMl(cxml2, '<VerificarPreciosVenta>', '</VerificarPreciosVenta>')
	This.firmarcondll			  = leerXMl(cxml2, '<Firmarcondll>', '</Firmarcondll>')
	This.grabarxmlbd			  = leerXMl(cxml2, '<Grabarxmlbd>', '</Grabarxmlbd>')
	This.mostrartodoslosproductos = leerXMl(cxml2, '<MostrarTodoslosProductos>', '</MostrarTodoslosProductos>')
**** CLiente Por defecto
	This.idclientegenerico				= leerXMl(cxml2, '<IdClienteGenerico>', '</IdClienteGenerico>')
	This.impresionpreventa				= leerXMl(cxml2, '<ImpresionPreventa>', '</ImpresionPreventa>')
	This.seriedefault					= leerXMl(cxml2, '<SerieDefault>', '</SerieDefault>')
	This.productoscp					= leerXMl(cxml2, '<productoscp>', '</productoscp>')
	This.emisorguiasremisionelectronica	= leerXMl(cxml2, '<Emisorguiasremisionelectronica>', '</Emisorguiasremisionelectronica>')
	This.smtp							= leerXMl(cxml2, '<Smtp>', '</Smtp>')
	This.puerto							= leerXMl(cxml2, '<Puerto>', '</Puerto>')


	This.regimencontribuyente = leerXMl(cxml2, '<RegimenContribuyente>', '</RegimenContribuyente>')
	This.inicioenvios		  = leerXMl(cxml2, '<Inicioenvios>', '</Inicioenvios>')
	This.ventascondecimales	  = leerXMl(cxml2, '<Ventascondecimales>', '</Ventascondecimales>')

*Nombre de Otras Impresoras para Imprimir una copia de las  Ventas*
	This.otraimpresora	= leerXMl(cxml2, '<Otraimpresora>', '</Otraimpresora>')
	This.otraimpresora1	= leerXMl(cxml2, '<Otraimpresora1>', '</Otraimpresora1>')
*Para Inprimir en Ventas una copia de le venta S=Si
	This.otraimpresionvtas = leerXMl(cxml2, '<Otraimpresionvtas>', '</Otraimpresionvtas>')
* Codigo del producto para promoción
	This.codigopromocion = leerXMl(cxml2, '<Codigopromocion>', '</Codigopromocion>')
*Para Controlar Ofertas
	This.controloferta = leerXMl(cxml2, '<Controloferta>', '</Controloferta>')
*Nombre de Impresora para generar los comprobantes en formato nornal-No Tickets
	This.impresoranormal = leerXMl(cxml2, '<Impresoranormal>', '</Impresoranormal>')
*Para Emitir Factura Guia
	This.facturaguia = leerXMl(cxml2, '<Facturaguia>', '</Facturaguia>')
*Para Imprinir Original y Copia
	This.concopia = leerXMl(cxml2, '<Concopia>', '</Concopia>')
*Para Imprimir con Formato Preimpreso
	This.conformato = leerXMl(cxml2, '<Conformato>', '</Conformato>')
*Para Imprimir el Vuelto en el Comprobante de Ventas
	This.imprimevuelto = leerXMl(cxml2, '<Imprimevuelto>', '</Imprimevuelto>')
*Url para subir los comprobantes al hosting
	If Empty(This.url) Then
		This.url = leerXMl(cxml2, '<Url>', '</Url>')
	Endif
*Número de Precio a Validar
	This.validarprecio = leerXMl(cxml2, '<Validarprecio>', '</Validarprecio>')
*Codigo del Proveedor para los ajustes de Inventarios
	This.proveedorajuste = leerXMl(cxml2, '<Proveedorajuste>', '</Proveedorajuste>')
*Código de la tienda para Imprimir una copia en almacen
	This.tiendaconcopia = leerXMl(cxml2, '<Tiendaconcopia>', '</Tiendaconcopia>')
* Cajero por Serie
	This.cajeroserie1 = leerXMl(cxml2, '<Cajeroserie1>', '</Cajeroserie1>')
	This.cajeroserie2 = leerXMl(cxml2, '<Cajeroserie2>', '</Cajeroserie2>')
	This.cajeroserie3 = leerXMl(cxml2, '<Cajeroserie3>', '</Cajeroserie3>')
***Cliente Con Varios Proyecctos(Cava)
	This.clienteconproyectos = leerXMl(cxml2, '<Clienteconproyectos>', '</Clienteconproyectos>')
**   Ruta del Certificado
	This.rutacertificado = leerXMl(cxml2, '<Rutacertificado>', '</Rutacertificado>')
*
**  Lista de Precios por Tienda
	This.listapreciosportienda = leerXMl(cxml2, '<ListaPreciosPorTienda>', '</ListaPreciosPorTienda>')
************
*Con copia a otro correo
	This.ccorreo = leerXMl(cxml2, '<Ccorreo>', '</Ccorreo>')
***Id de sucursal
	This.codigosucursal = leerXMl(cxml2, '<Codigosucursal>', '</Codigosucursal>')
***********Validar Crédito en ventas
	This.validarcredito = leerXMl(cxml2, '<Validarcredito>', '</Validarcredito>')
**********Para Traspasos entre almacenes
	This.traspasoautomatico = leerXMl(cxml2, '<Traspasoautomatico>', '</Traspasoautomatico>')
***************
	This.clientesconretencion = leerXMl(cxml2, '<Clienestesconretencion>', '</Clienestesconretencion>')
	This.dctosvtas=leerXMl(cxml2, '<Dctosvtas>', '</Dctosventas>')
	This.cajasinsaldo=""
	This.vtasdepositoefectivo=""
	This.cajacontipogasto=""
	Endfunc
	Function solicitar
	Lparameters toDatosSolicitud
	With toDatosSolicitud
		Do Case
		Case .cNombreTarea ='SELECT'
			lcComando   = "SELECT " + .cColumnas + " "
			lcComando   = lcComando + "FROM " + .ctablas + " "
			lcComando   = lcComando + Iif(!Empty(.cWhere)  , "WHERE "    + .cWhere   + " ", "")
			lcComando   = lcComando + Iif(!Empty(.cGroupBy), "GROUP BY " + .cGroupBy + " ", "")
			lcComando   = lcComando + Iif(!Empty(.cHaving) , "HAVING "   + .cHaving  + " ", "")
			lcComando   = lcComando + Iif(!Empty(.cOrderBy), "ORDER BY " + .cOrderBy + " ", "")
			llComandoOK = This.DO_SQL_EJECUTAR(lcComando, toDatosSolicitud.cCursorConsulta)
		Endcase
	Endwith
	ENDFUNC
	Function DO_SQL_EJECUTAR1
	Lparameters tcComando, tcCursor
	Local lnI, lcArchivoConsultas, llComandoOK

	#Define KEY_CRLF Chr(13) + Chr(10)

	This.cComando = tcComando

*--- Si no hay una transacción abierta, no se puede continuar

*=== Si no se detectaron errores, se continúa ===

	tcCursor = Iif(Vartype(tcCursor) <> "C", "SQL_RESULTADO", tcCursor)

	tcComando = Upper(tcComando)

*--- Todos los comandos SELECT se envían a un archivo de texto para que puedan ser revisados
	If Left(tcComando, 6) == "SELECT" Then
	*	lcArchivoConsultas = _Screen.cCarpetaUbicacionEjecutable + "SQL_CONSULTAS.TXT"           && Nombre del archivo en el cual se grabarán todos los SELECT
	*	=Strtofile(Dtoc(Date()) + "   " + Left(Time(), 5) + KEY_CRLF, lcArchivoConsultas, 1)     && Se graban la fecha y la hora en que se ejecutó el SELECT
	*	=Strtofile(tcComando                              + KEY_CRLF, lcArchivoConsultas, 1)     && Los datos del SELECT se graban en un archivo de texto
	*	=Strtofile(Replicate("-", 80)                     + KEY_CRLF, lcArchivoConsultas, 1)     && Se pone una línea de 80 guiones para separar del siguiente SELECT
	Endif
    this.do_conectardata()
*--- Los parámetros de una nueva transacción solamente tienen efecto después del COMMIT
	If Left(tcComando, 15) == "SET TRANSACTION" Then
		llComandoOK = SQLExec(This.nHandle, "COMMIT") = 1
	Endif

*--- Se envía el comando al Servidor
    
	llComandoOK = SQLExec(This.nHandle, tcComando, tcCursor) = 1     && Si la función SQLEXEC() devuelve 1 entonces terminó exitosamente

*--- Si ocurrió algún error, se registra ese error en un archivo de texto
	If !llComandoOK Then
	*	This.REGISTRAR_ERROR_EN_ARCHIVO()     && Ocurrió algún error, registrarlo en un archivo de texto para poder verificarlo y corregirlo
	Endif

*--- llComandoOK = .T. si el comando se ejecutó exitosamente
	Return (llComandoOK)

	Endfunc
Enddefine

