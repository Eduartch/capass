Define Class productosneumaticos As Producto Of 'd:\capass\modelos\productos.prg'
	Function MuestraCostosParaVenta(np1, Ccursor)
	Local lC, lp
	m.lC		 = 'ProMuestraCostosParaVenta'
	goApp.npara1 = m.np1
	Text To m.lp Noshow
     (?goapp.npara1)
	Endtext
	If This.EJECUTARP(m.lC, m.lp, m.Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function EnviarListaPreciosServidor()
	Local lC, lp
	Ccursor = 'lprecios'
	m.lC		 = 'ProMuestraCostosParaVenta'
	npara1 = '%%'
	Text To m.lp Noshow
     (?npara1)
	ENDTEXT
	If This.EJECUTARP(m.lC, m.lp, Ccursor) < 1 Then
		Return 0
	ENDIF
	Select (Ccursor)
	hConn = This.Abrirconexionremoto("neumaticosch")
	If hConn > 0
* Configurar timeout de la conexión para consultas pesadas
		This.establecertime(m.hConn)
* 3. Ejecutar inserción en bloques de 1,000 registros
		lnFilasIncertadas = This.InsertarBloqueMySQL(Ccursor, "fe_art", hConn, 1000)
		If lnFilasIncertadas > 0
			This.Cmensaje = "Se insertaron exitosamente " + Transform(lnFilasIncertadas) + " registros."
		Endif
* 4. Cerrar conexión
		This.CierraConexion(hConn)
	Else
		Aerror(laErr)
		This.Cmensaje = "No se pudo conectar a MySQL: " + laErr[1, 2]
	Endif
	Return 1
	Endfunc
	Function Nuevo()
	If This.validarproducto() < 1 Then
		Return 0
	Endif
	cidpc = Id()
	Text To lcINSERT Noshow Textmerge
    INSERT INTO fe_art(descri,unid,prec,pre1,pre2,pre3,peso,idcat,idmar,tipro,idflete,tmon,fechc,usua,idpc,prod_perc,prod_mode,prod_ccai,cost)
    VALUES ('<<this.cdesc>>','<<this.cunid>>',<<this.ncosto>>,<<this.np1>>,<<this.np2>>,<<this.np3>>,<<this.npeso>>,<<this.ccat>>,<<this.cmar>>,'<<this.ctipro>>',<<this.nflete>>,'<<this.moneda>>',
    localtime,'<<this.cusua>>','<<cidpc>>',<<this.nper>>,'<<this.cmodelo>>','<<this.ccai>>',<<this.ncosto>>)
	Endtext
	If This.Ejecutarsql(lcINSERT) < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'Creado Ok'
	Return 1
	Endfunc
	Function Actualizar()
	If This.validarproducto() < 1 Then
		Return 0
	Endif
	Text To lm Noshow Textmerge
     UPDATE fe_art SET descri='<<this.cdesc>>',unid='<<this.cunid>>',cost=<<this.ncosto>>,pre1=<<this.np1>>,pre2=<<this.np2>>,
     pre3=<<this.np3>>,peso=<<this.npeso>>,idcat=<<this.ccat>>,idmar=<<this.cmar>>,tipro='<<this.ctipro>>',idflete=<<this.nflete>>,tmon='<<this.moneda>>',
     prod_perc=<<this.nper>>,prod_mode='<<this.cmodelo>>',prod_ccai='<<this.ccai>>',prod_uact=<<goapp.nidusua>> WHERE idart=<<this.ncoda>>
	Endtext
	If This.Ejecutarsql(lm) < 1
		Return 0
	Endif
	This.Cmensaje = 'Actualizado Ok'
	Return 1
	Endfunc
	Function Listar(cb, Ccursor)
	lw = '%' + Alltrim(cb) + '%'
	Text To lcconsulta Noshow Textmerge
      SELECT idart,descri,unid,prec,uno,pre1,pre2,pre3,peso,idmar,idcat,idflete,tipro,cost,tmon,prod_perc,prod_mode,prod_ccai,prod_grat
      FROM fe_art WHERE descri LIKE ?lw ORDER BY descri
	Endtext
	If EjecutaConsulta(lcconsulta, "lpro") < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function Listar(np1, Calias)
	m.lC		 = 'PROMUESTRAPRODUCTOS'
	goApp.npara1 = m.np1
	Text To m.lp Noshow
     (?goapp.npara1)
	Endtext
	If This.EJECUTARP(m.lC, m.lp, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function validarproducto()
	Do Case
	Case  Empty(This.cdesc)
		This.Cmensaje = 'Ingrese Nombre de producto'
		Return 0
	Case  Empty(This.cUnid)
		This.Cmensaje = 'Ingrese Unidad'
		Return 0
	Case  This.ccat = 0
		This.Cmensaje = 'Ingrese Linea de Producto'
		Return 0
	Case  This.cmar = 0
		This.Cmensaje = 'Ingrese Marca de Producto'
		Return 0
	Case This.nflete = 0
		This.Cmensaje = 'Ingrese Costo de Flete de Producto'
		Return 0
	Case This.npeso <= 0
		This.Cmensaje = 'Ingrese Peso'
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function listarproductosxservicio(lw, Ccursor)
	cb = "%" + Trim(lw) + "%"
	Text To lC Noshow Textmerge
	SELECT prod_ccai,descri,uno,dos,tre,cua,cin,sei,die,sie,onc,doce,trece,catorce,quince,cost*v.igv AS costo,
	IF(tmon="S","Soles","Dólares") AS tmon,ROUND(cost*v.igv*prod_uti1,2) AS pre1,
	CAST(0 AS DECIMAL(12,2)) AS costop,unid,pre2,pre3,peso,prod_perc,tipro,prod_grat,idart 
	FROM fe_art  AS a,fe_gene AS v  WHERE descri LIKE '<<cb>>' AND prod_acti<>'I'  and tipro='S'  ORDER BY descri;
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
********************************************************************************
* Rutina: InsertarBloqueMySQL
* Descripción: Transfiere registros de un cursor local VFP a una tabla MySQL
*              usando inserción en bloque (Batched/Multi-row Insert).
********************************************************************************
	Function InsertarBloqueMySQL(tcCursorVFP, tcTablaMySQL, tnHandleConn, tnTamanoLote)
	Local lnRegistros, lnInsertados, lcSQLBase, lcSQLValues, lnContadorLote
	Local lnIteracion, lcValoresFila, lnExito, lcSqlFinal

* Configuración por defecto del tamaño de lote (1,000 es óptimo)
	If Vartype(tnTamanoLote) <> "N" Or tnTamanoLote <= 0
		tnTamanoLote = 1000
	Endif

* Verificar que el cursor existe y tiene datos
	If !Used(tcCursorVFP) Or Reccount(tcCursorVFP) = 0
		This.Cmensaje = "No Hay Datos para enviar"
		Return 0
	Endif

	lnRegistros   = Reccount()
	lnInsertados  = 0
	lnContadorLote = 0
* Prepara la estructura base del INSERT
* NOTA: Ajusta las columnas según la estructura real de tu tabla MySQL
	lcSQLBase = "INSERT INTO " + tcTablaMySQL + " (descri,unid,peso,idcat,idmar,tipro,idflete,tmon,prod_mode,prod_ccai,cost,uno,dos,tre,cua,cin,sei,die,sie,onc,doce,trece,catorce,quince) VALUES "
	lcSQLValues = ""
* Iniciar transacción en MySQL para mayor velocidad e integridad
	SQLExec(tnHandleConn, "START TRANSACTION")
	lnExito = SQLExec(tnHandleConn, "Call Reiniciaproductos()")
	If lnExito < 1
* Si hay error, revertimos la transacción y salimos
		SQLExec(tnHandleConn, "ROLLBACK")
		Aerror(laErr)
		This.Cmensaje = "Error al  Eliminar Items de Productos: " + laErr[1, 2]
		Return - 1
	Endif
	Select (tcCursorVFP)
	Go Top
	Scan
* Construir la tupla de valores sanitizando datos para SQL
		lcValoresFila = "(" + ;
			"'" + this.LimpiarCadena(lprecios.Descri) + "', " + ;
			"'" + this.LimpiarCadena(lprecios.unid) + "', " + ;
			Transform(lprecios.peso) + ", " + ;
			Transform(lprecios.idcat) + ", " + ;
			Transform(lprecios.idmar) + ", " + ;
			"'" + this.LimpiarCadena(lprecios.tipro) + "', " + ;
			Transform(lprecios.idflete) + ", " + ;
			"'" + this.LimpiarCadena(lprecios.tmoneda) + "', " + ;
			"'" + this.LimpiarCadena(lprecios.prod_mode) + "', " + ;
			"'" + this.LimpiarCadena(lprecios.prod_ccai) + "', " + ;
			Transform(lprecios.cost, "9999999.99") + ", " + ;
			Transform(lprecios.uno) + ", " + ;
			Transform(lprecios.Dos) + ", " + ;
			Transform(lprecios.tre) + ", " + ;
			Transform(lprecios.cua) + ", " + ;
			Transform(lprecios.cin) + ", " + ;
			Transform(lprecios.sei) + ", " + ;
			Transform(lprecios.die) + ", " + ;
			Transform(lprecios.sie) + ", " + ;
			Transform(lprecios.onc) + ", " + ;
			Transform(lprecios.doce) + ", " + ;
			Transform(lprecios.trece) + ", " + ;
			Transform(lprecios.catorce) + ", " + ;
			Transform(lprecios.quince) + ")"
* Acumular valores en el lote actual
		If Empty(lcSQLValues)
			lcSQLValues = lcValoresFila
		Else
			lcSQLValues = lcSQLValues + ", " + lcValoresFila
		Endif
		lnContadorLote = lnContadorLote + 1
* Cuando alcanzamos el tamaño del lote, enviamos la consulta a MySQL
		If lnContadorLote >= tnTamanoLote
			lcSqlFinal = lcSQLBase + lcSQLValues
			lnExito = SQLExec(tnHandleConn, lcSqlFinal)
			If lnExito < 1
* Si hay error, revertimos la transacción y salimos
				SQLExec(tnHandleConn, "ROLLBACK")
				Aerror(laErr)
				This.Cmensaje = "Error al insertar lote en MySQL: " + laErr[1, 2]
				Return - 1
			Endif
			lnInsertados = lnInsertados + lnContadorLote
			lcSQLValues = ""
			lnContadorLote = 0
		Endif
	Endscan
* Procesar los registros remanentes que no completaron un lote entero
	If !Empty(lcSQLValues)
		lcSqlFinal = lcSQLBase + lcSQLValues
		lnExito = SQLExec(tnHandleConn, lcSqlFinal)
		If lnExito < 1
			SQLExec(tnHandleConn, "ROLLBACK")
			Aerror(laErr)
			This.Cmensaje = "Error al insertar lote final en MySQL: " + laErr[1, 2]
			Return - 1
		Endif
		lnInsertados = lnInsertados + lnContadorLote
	Endif
* Confirmar todos los cambios acumulados
	SQLExec(tnHandleConn, "COMMIT")
	Return lnInsertados
	Endfunc
********************************************************************************
* Función Auxiliar: LimpiarCadena
* Escapa apóstrofes (') y barras invertidas (\) para evitar fallos de sintaxis SQL
********************************************************************************
	Function LimpiarCadena(tcTexto)
	Local lcSalida
	lcSalida = Alltrim(Transform(tcTexto))
	lcSalida = Strtran(lcSalida, "\", "\\")
	lcSalida = Strtran(lcSalida, "'", "''")
	Return lcSalida
	Endfunc
Enddefine

















