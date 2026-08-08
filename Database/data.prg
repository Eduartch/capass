Define Class Odata As Custom
	Url = 'companiasysven.com'
	Cmensaje = ""
	ncon	 = 0
	contransaccion = ""
	Url = ""
	Idsesion = 0
	conerror = 0
	conconexion = 0
	comandosql = ""
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
		Strtofile(m.csql, Addbs(Sys(5) + Sys(2003)) + 'error.txt')
		This.comandosql = m.tcComando
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
		m.lcC1 = "Driver={" + Alltrim(_Screen.conector) + "};Port=" + Alltrim(_Screen.puerto) + ";Server=" + Alltrim(_Screen.Server)  + ";Database=" + Alltrim(_Screen.Database) + ";Uid=" + Alltrim(_Screen.User) + ";Pwd=" + Alltrim(_Screen.pwd);
			+ Iif(Len(Alltrim(_Screen.charset)) > 0, ';' + Alltrim(_Screen.charset), '');
			+ Iif(Len(Alltrim(_Screen.sslmode)) > 0, ';' + Alltrim(_Screen.sslmode), '');
			+ Iif(Len(Alltrim(_Screen.Option)) > 0, ';' + Alltrim(_Screen.Option), '')
	Else
		m.lcC1 = "Driver={" + Alltrim(_Screen.conector) + "};Port=" + Alltrim(_Screen.puerto) + ";Server=" + Alltrim(_Screen.Server)  + ";Database=" + Alltrim(_Screen.Database) + ";Uid=" + Alltrim(_Screen.User) + ";Pwd=" + Alltrim(_Screen.pwd);
			+ Iif(Len(Alltrim(_Screen.charset)) > 0, ';' + Alltrim(_Screen.charset), '');
			+ Iif(Len(Alltrim(_Screen.sslmode)) > 0, ';' + Alltrim(_Screen.sslmode), '');
			+ Iif(Len(Alltrim(_Screen.Option)) > 0, ';' + Alltrim(_Screen.Option), '')
	Endif
*  wait WINDOW lcC1
	= SQLSetprop(0, "DispLogin", 3)
	This.ncon = Sqlstringconnect(m.lcC1) && ESTABLECER LA CONEXION
*WAIT WINDOW this.ncon
	If This.ncon < 1 Then
		= Aerror(laError)
		This.Cmensaje = "Al Conectar" + Chr(13) + "Description:" + Alltrim(m.laError[2])
		Return - 1
	Endif
	= SQLSetprop(This.ncon, 'PacketSize', 5000)
	goApp.bdConn = This.ncon
	Return This.ncon
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
	This.conerror = 0
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
		Strtofile(tcComando, Addbs(Sys(5) + Sys(2003)) + 'error.txt')
		This.comandosql = m.csql
		If Aerror(laError) > 0
			This.Cmensaje = This.mensajeError(@laError)
		Endif
		This.conerror = 1
		Return 0
	Endif
	This.Cmensaje = 'Ok'
	Endfunc
	Function EJECUTARf(tcComando As String, lp As String, NCursor As String )
	This.conerror = 0
	Local lResultado As Integer
	Local lR
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
		This.Cmensaje = 'Ok'
		Return Evaluate(m.NCursor + '.id')
	Else
		Strtofile('Select  ' + Alltrim(m.tcComando) + Alltrim(m.lp), Addbs(Sys(5) + Sys(2003)) + 'error.txt')
		This.comandosql = 'Select  ' + Alltrim(m.tcComando) + Alltrim(m.lp)
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
		Strtofile(tcComando, Addbs(Sys(5) + Sys(2003)) + 'error.txt')
		This.comandosql = m.tcComando
		If Aerror(laError) > 0
			This.Cmensaje = This.mensajeError(@laError)
		Endif
		Return 0
	Endif
	This.Cmensaje = 'Ok'
	Endfunc
	Function IniciaTransaccion
	If  This.verificaconexion() < 1  Then
		Return 0
	Endif
	If SQLExec(goApp.bdConn, "SET TRANSACTION ISOLATION LEVEL READ COMMITTED") < 1 Then
		If Aerror(laError) > 0
			This.Cmensaje = This.mensajeError(@laError)
		Endif
		Return 0
	Endif
	If SQLExec(goApp.bdConn, "START TRANSACTION") < 1 Then
		If Aerror(laError) > 0
			This.Cmensaje = This.mensajeError(@laError)
		Endif
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
		If Aerror(laError) > 0
			This.Cmensaje = This.mensajeError(@laError)
		Endif
		Return 0
	Endif
	Endfunc
	Function GRabarCambios()
	If SQLExec(goApp.bdConn, "COMMIT") > 0
		This.contransaccion = ""
		This.Cmensaje = 'Ok'
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
		m.lcC1 = "Driver={" + Alltrim(_Screen.conector) + "};Port=" + Alltrim(_Screen.puerto) + ";Server=" + Alltrim(_Screen.Server)  + ";Database=" + Alltrim(_Screen.Database) + ";Uid=" + Alltrim(_Screen.User) + ";Pwd=" + Alltrim(_Screen.pwd);
			+ Iif(Len(Alltrim(_Screen.charset)) > 0, ';' + Alltrim(_Screen.charset), '');
			+ Iif(Len(Alltrim(_Screen.sslmode)) > 0, ';' + Alltrim(_Screen.sslmode), '');
			+ Iif(Len(Alltrim(_Screen.Option)) > 0, ';' + Alltrim(_Screen.Option), '')
	Else
		m.lcC1 = "Driver={" + Alltrim(_Screen.conector) + "};Port=" + Alltrim(_Screen.puerto) + ";Server=" + Alltrim(_Screen.Server)  + ";Database=" + Alltrim(_Screen.Database) + ";Uid=" + Alltrim(_Screen.User) + ";Pwd=" + Alltrim(_Screen.pwd);
			+ Iif(Len(Alltrim(_Screen.charset)) > 0, ';' + Alltrim(_Screen.charset), '');
			+ Iif(Len(Alltrim(_Screen.sslmode)) > 0, ';' + Alltrim(_Screen.sslmode), '');
			+ Iif(Len(Alltrim(_Screen.Option)) > 0, ';' + Alltrim(_Screen.Option), '')
	Endif
	= SQLSetprop(0, "DispLogin", 3)
	idconecta = Sqlstringconnect(lcC1) && ESTABLECER LA CONEXION
	If idconecta < 1 Then
		= Aerror(laError)
		This.Cmensaje = "Al Conectar " + Chr(13) + "Description:" + laError[2]
*MESSAGEBOX(m.lcC1)
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
		Strtofile('CALL ' + m.tcComando + m.clparametros, Addbs(Sys(5) + Sys(2003)) + 'error.txt')
		This.comandosql = 'call  ' + Alltrim(m.tcComando) + Alltrim(m.lp)
		If Aerror(laError) > 0
			This.Cmensaje = This.mensajeError(@laError)
		Endif
		Return 0
	Endif
	This.Cmensaje = 'Ok'
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
		This.comandosql = m.csql
		Strtofile(m.csql, Addbs(Sys(5) + Sys(2003)) + 'error.txt')
		If Aerror(laError) > 0
			This.Cmensaje = This.mensajeError(@laError)
		Endif
		Return 0
	Endif
	Endfunc
	Function mensajeError(laError)
	lcMsg = ""
	m.lsMsgenvio = Alltrim(This.comandosql)
*!*		m.lsMsgenvio=""
	For ln = 1 To Alen(laError, 2)
		lcMsg = lcMsg + Transform(laError(1, ln)) + Chr(13)
		m.lsMsgenvio = Alltrim(m.lsMsgenvio) + ' ' + Alltrim(Transform(laError(1, ln)))
	Endfor
	This.enviarCorreoSoporte(m.lsMsgenvio)
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
	Function JsonToCursor(tcJson, tcCursor)
	Local loRoot
	Local loItem
	Local laFields[1]
	Local lcCreate
	Local ix
	Set Procedure To  d:\Librerias\nfJsonRead Additive
	loRoot = nfJsonRead(tcJson)
	If loRoot.Count = 0
		Return .F.
	Endif
	Amembers(laFields, loRoot.Item(1), 0)
	lcCreate = "CREATE CURSOR " + tcCursor + " ("
	For ix = 1 To Alen(laFields)
		lcCreate = lcCreate + ;
			laFields[ix] + " C(250)"
		If ix < Alen(laFields)
			lcCreate = lcCreate + ","
		Endif
	Endfor
	lcCreate = lcCreate + ")"
	&lcCreate
	For Each loItem In loRoot
		Append Blank
		For ix = 1 To Alen(laFields)
			If Pemstatus(loItem, laFields[ix], 5)
				Replace ;
					(laFields[ix]) ;
					With Transform(Evaluate("loItem." + laFields[ix]))
			Endif
		Endfor
	Endfor
	Return .T.
	Endfunc
	Function enviarCorreoSoporte(cmessage)
	ocorreo = Newobject("envioftpcorreo", "d:\capass\api\enviofileftp.prg")
	ocorreo.emailcliente = "soporte@companysysven.com"
	ocorreo.asunto = " Error Database: - " + Alltrim(fe_gene.empresa)
	cadena = Strtran(Alltrim(Strtran(Strtran(Alltrim(m.cmessage), Chr(13), ' '), Chr(10), ' ')), Chr(9), ' ')
	ocorreo.Cmensaje = reduceAUnEspacio(m.cadena)
	If ocorreo.enviarasoporte() < 1 Then
*aviso(ocorreo.Cmensaje)
	Else
*mensaje(ocorreo.Cmensaje)
	Endif
	ocorreo = Null
	Endfunc
	Function Abrirconexionremoto(cempresa)
	lcURL = "http://companiasysven.com/otros.php"
	Text To cenvio Noshow  Textmerge
	{
	"empresa":"neumaticosch"
	}
	Endtext
	Set Procedure To  d:\Librerias\json Additive
	loXmlHttp = Createobject("Microsoft.XMLHTTP")
	loXmlHttp.Open('POST', lcURL, .F.)
	loXmlHttp.setRequestHeader("Content-Type", "application/json")
	loXmlHttp.Send(m.cenvio)
	If loXmlHttp.Status <> 200 Then
		This.Mensaje = "Acceso NO Disponible....." + Alltrim(Str(loXmlHttp.Status))
		lcHTML = loXmlHttp.responseText
		Strtofile(lcHTML, Addbs(Sys(5) + Sys(2003)) + 'errorconexion.txt')
		Return - 1
	Endif
	lcHTML = loXmlHttp.responseText
	ocontrib = json_decode(lcHTML)
	If Not Empty(json_getErrorMsg())
		This.Mensaje = "No se Pudo Obtener la Información " + json_getErrorMsg()
		Return - 1
	Endif
	If Len(Alltrim(ocontrib.Get('server'))) > 0 Then
		cservidor = Alltrim(ocontrib.Get('server'))
		cdatabase = Alltrim(ocontrib.Get('data'))
		cuid = Alltrim(ocontrib.Get('usuario'))
		cpwd = Alltrim(ocontrib.Get('pwd'))
	Else
		This.Mensaje = Alltrim(lcHTML)
		Return - 1
	Endif
	lcC1 = "Driver={MySQL ODBC 5.1 Driver};";
		+ "Port=3306;";
		+ "Server=" + Alltrim(cservidor )  + ";";
		+ "Database=" + Alltrim(cdatabase) + ";";
		+ "Uid=" + Alltrim(cuid) + ";";
		+ "Pwd=" + Alltrim(cpwd) + ";";
		+ "OPTION=131329;"
	cconector = 'MySQL ODBC 5.1 Driver'
	cpuerto = '3306'
	charset = ""
	sslmode = ""
	coption = "OPTION=131329;"
	nConn = Sqlstringconnect(lcC1)
	Return m.nConn
	Endfunc
	Function establecertime(ncon)
	= SQLSetprop(ncon, 'QueryTimeout', 300)
	Endfunc
Enddefine













