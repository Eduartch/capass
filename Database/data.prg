Define Class Odata As Custom
	Url = 'companiasysven.com'
	Cmensaje = ""
	ncon	 = 0
	contransaccion = ""
	Url = ""
	Idsesion = 0
	conerror = 0
	conconexion = 0
	Function EjecutaConsulta(tcComando As String, NCursor As String )
	Local r As Integer
	Local laError[1], lcError
	If This.conconexion = 0 Then
		If This.contransaccion <> 'S' Then
			If This.verificaconexion() < 1 Then
				Return 0
			Endif
		Endif
		ncon = goApp.bdConn
	Else
		ncon = This.Abreconexion1()
		If ncon < 1 Then
			Return 0
		Endif
	Endif
	m.NCursor = Iif(Vartype(m.NCursor) <> "C", "", m.NCursor)
	Dimension m.laError(1)
	csql = Alltrim(m.tcComando)
*!*		wait WINDOW 'hola'
*!*		wait WINDOW ncon
*!*		wait WINDOW goapp.bdconn
	If Empty(m.NCursor) Then
		m.r = SQLExec(ncon, csql)
	Else
		m.r = SQLExec(ncon, csql, m.NCursor)
	Endif
	If This.conconexion = 1 Then
		This.CierraConexion(ncon)
		This.conconexion = 0
	Endif
	If m.r > 0 Then
		This.conerror = 0
		Return 1
	Else
		If Aerror(laError) > 0
			This.Cmensaje = This.mensajeError(@laError)
		Endif
		This.conerror = 1
		Return 0
	Endif
	Endfunc
	Function verificaconexion()
	If SQLExec(goApp.bdConn, "SET @ZXC:=00") < 1 Then
		If Aerror(laError) > 0
			This.Cmensaje = This.mensajeError(@laError)
		Endif
		This.CierraConexion(goApp.bdConn)
		If This.AbreConexion(goApp.Xopcion) > 0 Then
			Return 1
		Else
			If Aerror(laError) > 0
				This.Cmensaje = This.mensajeError(@laError)
			Endif
			Return 0
		Endif
	Else
		Return 1
	Endif
	Endfunc
	Function AbreConexion(nopcion)
	If Len(Alltrim(_Screen.conector)) = 0 Then
		m.lcC1 = "Driver={MySQL ODBC 5.1 Driver};Port=3306;Server=" + Alltrim(_Screen.Server)  + ";Database=" + Alltrim(_Screen.Database) + ";Uid=" + Alltrim(_Screen.User) + ";Pwd=" + Alltrim(_Screen.pwd) + ";OPTION=131329;"
	Else
		m.lcC1 = "Driver={" + Alltrim(_Screen.conector) + "};Port=3306;Server=" + Alltrim(_Screen.Server)  + ";Database=" + Alltrim(_Screen.Database) + ";Uid=" + Alltrim(_Screen.User) + ";Pwd=" + Alltrim(_Screen.pwd) + ";OPTION=131329;"
	Endif
*  wait WINDOW lcC1
	= SQLSetprop(0, "DispLogin", 3)
	This.ncon = Sqlstringconnect(m.lcC1) && ESTABLECER LA CONEXION
*WAIT WINDOW this.ncon
	If This.ncon < 1 Then
		= Aerror(laError)
		This.Cmensaje = "Error al conectarse" + Chr(13) + "Description:" + Alltrim(m.laError[2])
		Return - 1
	Else
		= SQLSetprop(This.ncon, 'PacketSize', 5000)
		goApp.bdConn = This.ncon
		Return This.ncon
	Endif
	Endfunc
	Function CierraConexion(ncon)
	= SQLDisconnect(m.ncon)
	Endfunc
	Function Leerjson
	Lparameters cjson
	Local oconecta As "conectar"
	Set Classlib To d:\Librerias\clasesvisuales Additive
	m.oconecta = Createobject("conectar")
	m.oconecta.Leerjson(m.cjson)
	m.oconecta = Null
	Endfunc
	Function leerXMl
	Lparameters cxml2
	Local oconecta As "conectar"
	Set Classlib To d:\Librerias\clasesvisuales Additive
	m.oconecta = Createobject("conectar")
	m.oconecta.Leerxmln(m.cxml2)
	m.oconecta = Null
	Endfunc
	Function EJECUTARP(tcComando As String, clparametros As String, NombCursor As String)
	Local lResultado As Integer
	Local lR
	If This.contransaccion <> 'S' Then
		If This.verificaconexion() < 1 Then
			Return 0
		Endif
	Endif
	NCursor = Iif(Vartype(m.NombCursor) <> "C", "", m.NombCursor)
	m.lR = 0
	If Empty(m.NCursor) Then
		m.lR = SQLExec(goApp.bdConn, 'CALL ' + m.tcComando + m.clparametros)
	Else
		m.lR = SQLExec(goApp.bdConn, 'CALL ' + m.tcComando + m.clparametros, m.NombCursor)
	Endif
	If m.lR > 0 Then
		Return 1
	Else
		csql		  = 'CALL ' + m.tcComando + m.clparametros
		If Aerror(laError) > 0
			This.Cmensaje = This.mensajeError(@laError)
		Endif
		Return 0
	Endif
	Endfunc
	Function EJECUTARf(tcComando As String, lp As String, NCursor As String )
	Local lResultado As Integer
	Local lR
*:Global csql
	If This.contransaccion <> 'S' Then
		If This.verificaconexion() < 1 Then
			Return 0
		Endif
	Endif
	If Len(Alltrim(m.NCursor)) = 0  Or Vartype(m.NCursor) <> 'C' Then
		m.NCursor = 'c_' + Alltrim(Sys(2015))
	Else
		m.NCursor = m.NCursor
	Endif
*!*		m.NCursor = Iif(Vartype(m.NCursor) <> "C", m.Ccursor, m.NCursor)
	Local laError[1], lcError
	If Empty(m.NCursor) Then
		m.lR = SQLExec(goApp.bdConn, 'Select  ' + Alltrim(m.tcComando) + Alltrim(m.lp))
	Else
		m.lR = SQLExec(goApp.bdConn, 'Select  ' + Alltrim(m.tcComando) + Alltrim(m.lp) + ' as Id ', m.NCursor)
	Endif
	If m.lR > 0 Then
		This.conerror = 0
		Return Evaluate(m.NCursor + '.id')
	Else
		csql		  = 'Select  ' + m.tcComando + Alltrim(m.lp)
		If Aerror(laError) > 0
			This.Cmensaje = This.mensajeError(@laError)
		Endif
		This.conerror = 1
		Return 0
	Endif
	Endfunc
	Function Ejecutarsql(tcComando As String, lp As String, NCursor As String )
	Local lR As Integer
	If This.contransaccion <> 'S' Then
		If This.verificaconexion() < 1 Then
			Return 0
		Endif
	Endif
	m.NCursor = Iif(Vartype(m.NCursor) <> "C", "", m.NCursor)
	If Empty(m.NCursor) Then
		m.lR = SQLExec(goApp.bdConn, m.tcComando)
	Else
		m.lR = SQLExec(goApp.bdConn, m.tcComando, m.NCursor)
	Endif
	If m.lR > 0 Then
		Return 1
	Else
		If Aerror(laError) > 0
			This.Cmensaje = This.mensajeError(@laError)
		Endif
		Return 0
	Endif
	Endfunc
	Function IniciaTransaccion
	If  This.verificaconexion() < 1  Then
		Return 0
	Endif
	If SQLExec(goApp.bdConn, "SET TRANSACTION ISOLATION LEVEL READ COMMITTED") < 1 Then
		This.Cmensaje = "No se Pudo Iniciar Las Transacciones"
		Return 0
	Endif
	If SQLExec(goApp.bdConn, "START TRANSACTION") < 1 Then
		This.Cmensaje = "No se Pudo Iniciar Las Transacciones"
		Return 0
	Endif
	This.contransaccion = 'S'
	Return 1
	Endfunc
	Function  DEshacerCambios()
	If SQLExec(goApp.bdConn, "ROLLBACK") > 0
		This.contransaccion = ""
		Return 1
	Else
		This.contransaccion = ""
		= Aerror(laError)
		m.lcError	  = m.laError(2)
		This.Cmensaje = "Al Deshacer Cambios " + Chr(13) + Alltrim(m.lcError)
		Return 0
	Endif
	Endfunc
	Function GRabarCambios()
	If SQLExec(goApp.bdConn, "COMMIT") > 0
		This.contransaccion = ""
		Return 1
	Else
		= Aerror(laError)
		m.lcError	  = m.laError(1, 2)
		This.Cmensaje = "Al Confirmar Grabación " + Chr(13) + Alltrim(m.lcError)
		This.contransaccion = ""
		Return 0
	Endif
	Endfunc
	Function Abreconexion1(nopcion)
	If Len(Alltrim(_Screen.conector)) = 0 Then
		m.lcC1 = "Driver={MySQL ODBC 5.1 Driver};Port=3306;Server=" + Alltrim(_Screen.Server)  + ";Database=" + Alltrim(_Screen.Database) + ";Uid=" + Alltrim(_Screen.User) + ";Pwd=" + Alltrim(_Screen.pwd) + ";OPTION=131329;"
	Else
		m.lcC1 = "Driver={" + Alltrim(_Screen.conector) + "};Port=3306;Server=" + Alltrim(_Screen.Server)  + ";Database=" + Alltrim(_Screen.Database) + ";Uid=" + Alltrim(_Screen.User) + ";Pwd=" + Alltrim(_Screen.pwd) + ";OPTION=131329;"
	Endif
	= SQLSetprop(0, "DispLogin", 3)
	idconecta = Sqlstringconnect(lcC1) && ESTABLECER LA CONEXION
	If idconecta < 1 Then
		= Aerror(laError)
		This.Cmensaje = "Al Conectar " + Chr(13) + "Description:" + laError[2]
		Return - 1
	Else
		= SQLSetprop(idconecta, 'PacketSize', 5000)
		Return idconecta
	Endif
	Endfunc
	Function EJECUTARP1(tcComando As String, clparametros As String, NombCursor As String, ncon As Integer)
	Local lResultado As Integer
	Local lR

	NCursor = Iif(Vartype(m.NombCursor) <> "C", "", m.NombCursor)
	Local laError[1], lcError
	m.lR = 0
	If Empty(m.NCursor) Then
		m.lR = SQLExec(ncon, 'CALL ' + m.tcComando + m.clparametros)
	Else
		m.lR = SQLExec(ncon, 'CALL ' + m.tcComando + m.clparametros, m.NombCursor)
	Endif

	If m.lR > 0 Then
		Return 1
	Else
		csql		  = 'CALL ' + m.tcComando + m.clparametros
		If Aerror(laError) > 0
			This.Cmensaje = This.mensajeError(@laError)
		Endif
		Return 0
	Endif
	Endfunc
	Function EJECUTARP10(tcComando As String, clparametros As String, NombCursor As String)
	Local lResultado As Integer
	Local lR

	NCursor = Iif(Vartype(m.NombCursor) <> "C", "", m.NombCursor)
	Local laError[1], lcError
	m.lR = 0
	ncon = This.Abreconexion1()
	If ncon < 1 Then
		Return 0
	Endif
	If Empty(m.NCursor) Then
		m.lR = SQLExec(ncon, 'CALL ' + m.tcComando + m.clparametros)
	Else
		m.lR = SQLExec(ncon, 'CALL ' + m.tcComando + m.clparametros, m.NombCursor)
	Endif
	This.CierraConexion(ncon)
	If m.lR > 0 Then
		Return 1
	Else
		csql		  = 'CALL ' + m.tcComando + m.clparametros
		If Aerror(laError) > 0
			This.Cmensaje = This.mensajeError(@laError)
		Endif
		Return 0
	Endif
	Endfunc
	Function mensajeError(laError)
	lcMsg = ""
	For ln = 1 To Alen(laError, 2)
		lcMsg = lcMsg + Transform(laError(1, ln)) + Chr(13)
	Endfor
	Return lcMsg
	Endfunc
	Function sabersihay(ctabla, cfield)
	Ccursor = 'c_' + Sys(2015)
	Text To lC Noshow  Textmerge
	 SHOW COLUMNS FROM <<ctabla>> WHERE FIELD = '<<cfield>>'     
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	If REgdvto(Ccursor) = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine









