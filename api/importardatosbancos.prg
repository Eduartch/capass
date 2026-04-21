Define Class importabancos As Custom
	cfilejson = ""
	Cmensaje = ""
	Function tocursorfromjson()
	Set Procedure To d:\Librerias\nfjsoncreate, d:\Librerias\nfcursortojson.prg, ;
		d:\Librerias\nfcursortoobject, d:\Librerias\nfJsonRead.prg, ;
		d:\Librerias\_.prg, d:\Librerias\nfjsontocursor Additive
	If File(This.cfilejson) Then
		If !Pemstatus(_Screen, 'nctatavtas', 5) Then
			AddProperty(_Screen, 'nctatavtas', '')
		Endif
		Create Cursor ctas(nro N(2), idcta N(8), Fecha d, nrop c(12), Detalle c(100), Importe N(12, 2), ncta c(15), Moneda c(1), Ndoc c(12))
		oJson = nfJsonRead(This.cfilejson)
		If Vartype(oJson) = 'O' Then
			For z = 1 To Alen(oJson.Array)
				dFecha = Ctod(Right(oJson.Array(z).Date, 2) + '/' + Substr(oJson.Array(z).Date, 6, 2) + '/' + Alltrim(Str(Year(Date()))))
				Cdetalle = oJson.Array(z).Name
				m.nidcta = 0
				m.cncta = ""
				COperacion = Iif(Vartype(oJson.Array(z).operation) = 'N', Alltrim(Str(oJson.Array(z).operation)), Alltrim(oJson.Array(z).operation))
				nimporte = oJson.Array(z).Amount
				If nimporte > 0 Then
					Cdetalle = 'POR LA COBRANZA'
					m.nidcta = fe_gene.idctat
					m.cncta = _Screen.nctatavtas
				Endif
				cndoc = Right("000000000000" + Alltrim(Str(z)), 12)
				Insert Into ctas(Fecha, nrop, Detalle, Importe, Ndoc, idcta, ncta)Values(dFecha, m.COperacion, Cdetalle, nimporte, cndoc, m.nidcta, m.cncta)
			Next
		Endif
	Endif
	Endfunc
	Function desdeexcel(xArchivo)
	Create Cursor ctasexcel(Fecha d, operacion c(12), concepto c(100) null, Importe N(12, 2), nro N(2), idcta N(8), ncta c(15), Moneda c(1))
	Select ctasexcel
	xTabla = Alias()
*-- Creo el objeto Excel
	loExcel = Createobject("Excel.Application")
	With loExcel.Application
		.Visible = .F.
*-- Abro la planilla con datos
		.WorkBooks.Open("&xArchivo")
*-- Cantidad de columnas
		lnCol = .ActiveSheet.UsedRange.Columns.Count
		If lnCol <> 4 Then
			This.Cmensaje = "Número de Columnas Diferente al Solicitado"
			Return 0
		Endif
*-- Cantidad de filas
* Se resta la Fila 1 donde estan los campos
		lnFil = .ActiveSheet.UsedRange.Rows.Count
		If lnFil = 0 Then
			This.Cmensaje = "Sin Información"
			Return 0
		Endif
*!*			wait WINDOW lnFil
		xCampo = .ActiveSheet.Cells(1, 1).Value
		If Lower(xCampo) <> 'fecha' Then
			This.Cmensaje = "Columna Fecha no encontrada"
			Return 0
		Endif
*!*			wait WINDOW TYPE(xcampo)
*!*			wait WINDOW VarTYPE(xcampo)
		xCampo = .ActiveSheet.Cells(1, 2).Value
		If Lower(xCampo) <> 'operacion' Then
			This.Cmensaje = "Columna Operacion no encontrada"
			Return 0
		Endif
		xCampo = .ActiveSheet.Cells(1, 3).Value
		If Lower(xCampo) <> 'concepto' Then
			This.Cmensaje = "Columna Concepto no encontrada"
			Return 0
		Endif
		xCampo = .ActiveSheet.Cells(1, 4).Value
		If Lower(xCampo) <> 'importe' Then
			This.Cmensaje = "Columna Importe  no encontrada"
			Return 0
		Endif
*-- Recorro todas las celdas
** el Recorrido es columnas y luego filas
		For lnJ = 2 To lnFil
			xValor = .ActiveSheet.Cells(lnJ, 1).Value
			If !Isnull(xValor)  Then
				Select ("&xTabla")
				Append Blank   && se inserta el nuevo registro
				For lnI = 1 To lnCol
					xCampo = .ActiveSheet.Cells(1, lnI).Value  && Nombre del campo destino
					xTipoCampo = Type(xCampo)  && se obtiene de la tabla el tipo de campo
					xValor = .ActiveSheet.Cells(lnJ, lnI).Value  && Recupera el valor de la Celda en Excel
*? xcampo+": "  && Muestra el nombre de campo
*?? xValor         && Muestra el valor

					Do Case
					Case xTipoCampo = "D"  && si el campo es de fecha
						If Isnull(xValor)  &&Es fecha en blanco o nulo
							Replace &xCampo With Ctod("  /  /  ") In &xTabla
						Else
							If Vartype(xValor) = 'T' Then
								Replace &xCampo With Ttod(xValor) In &xTabla
							Else
								Replace &xCampo With Ctod(xValor) In &xTabla
							Endif
						Endif
					Case xTipoCampo = "C"
						If Vartype(xValor) = "N"  && por si en excel el valor no es TEXT
							Replace &xCampo With Alltrim(Upper(Str(xValor))) In &xTabla
						Else
							Replace &xCampo With xValor In &xTabla
						Endif
					Case xTipoCampo = "N"
						If Isnull(xValor)
							Replace &xCampo With 0 In &xTabla
						Else
							Replace &xCampo With xValor In &xTabla
						Endif
					Endcase
				Endfor
			Endif
		Endfor
*-- Cierro la planilla
		.WorkBooks.Close
*-- Salgo de Excel
		.Quit
	Endwith
	This.Cmensaje = 'ok'
	Return 1
	Endfunc
Enddefine









