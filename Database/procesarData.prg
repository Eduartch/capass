Define Class MySQLBatchMulti As Custom

	cConnString = ""
	nConn = -1

* ?? QUERY COMPLETA
	cFrom       = ""   && FROM + JOIN
	cFields     = ""
	cWhereExtra = ""

	cIdField = "id"
	nStartId = 0
	nEndId   = 999999999

	nBatchSize = 1000
	nLastId = 0

	Function Init
	This.Connect()
	This.nLastId = This.nStartId
	Endfunc

	Function Connect
	This.nConn = Sqlstringconnect(This.cConnString)
	If This.nConn <= 0
		Aerror(laErr)
		Error laErr[2]
	Endif
	Endfunc

	Function BuildSQL
	Local lcSQL

	Text To lcSQL Noshow
        SELECT %FIELDS%
        FROM %FROM%
        WHERE %IDFIELD% > %LASTID%
        AND %IDFIELD% <= %ENDID%
	Endtext

	If Not Empty(This.cWhereExtra)
		lcSQL = lcSQL + " AND " + This.cWhereExtra
	Endif

	lcSQL = lcSQL + ;
		" ORDER BY " + This.cIdField + ;
		" LIMIT " + Transform(This.nBatchSize)

	lcSQL = Strtran(lcSQL, "%FIELDS%", This.cFields)
	lcSQL = Strtran(lcSQL, "%FROM%", This.cFrom)
	lcSQL = Strtran(lcSQL, "%IDFIELD%", This.cIdField)
	lcSQL = Strtran(lcSQL, "%LASTID%", Transform(This.nLastId))
	lcSQL = Strtran(lcSQL, "%ENDID%", Transform(This.nEndId))

	Return lcSQL
	Endfunc

	Function Run
	Do While .T.

		lcSQL = This.BuildSQL()

		lnResult = SQLExec(This.nConn, lcSQL, "curData")

		If lnResult < 0
			Aerror(laErr)
			? laErr[2]
			Exit
		Endif

		If Reccount("curData") = 0
			Exit
		Endif

		Select curData
		Scan
			This.ProcessRow()
			This.nLastId = Evaluate("curData." + This.cIdField)
		Endscan

		Use In curData

	Enddo
	Endfunc

	Function ProcessRow
* override
	Endfunc

ENDDEFINE

DEFINE CLASS ProcVentasFull AS MySQLBatchMulti

    FUNCTION Init
        DODEFAULT()

        THIS.cFrom = ;
        "ventas v " + ;
        "JOIN clientes c ON v.idcliente = c.id " + ;
        "LEFT JOIN ventas_detalle d ON v.id = d.idventa"

        THIS.cFields = ;
        "v.id, v.fecha, c.nombre, d.producto, d.cantidad"

        THIS.cIdField = "v.id"
    ENDFUNC

    FUNCTION ProcessRow

        * Ejemplo: transformar o guardar
        * OJO: aquí ya viene todo unido

        ? curData.id, curData.nombre, curData.producto

    ENDFUNC

ENDDEFINE