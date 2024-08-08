Define Class exportar As Custom
	Cmensaje = ""
	Cruta = ""
	Idsesion = 0
	Function exporta
	Lparameters tcNomArc, tcRuta, tlTotales, tcListaTotales, tlOW
*--- Para saber si eliminamos primeramente el archivo si ya existe
	If Type("tlOW") # "L"
		lcOW = .F.
	Else
		lcOW = tlOW
	Endif

*--- Para determinar si el archivo de salida va a tener o no totales en las columnas númericas
	If Type("tlTotales") # "L"
		llTotales = .F.
	Else
		llTotales = tlTotales
	Endif

	If llTotales
		If Empty(Alltrim(tcListaTotales))
			This.Cmensaje = [Señor Usuario: debe dar la lista de columnas a totalizar]
			Return 0
		Else
			lcListaTotales = tcListaTotales
		Endif
	Endif

	lcName = Iif(Type("tcNomArc") = "L", Alias(), Alltrim(tcNomArc))
	lcRuta = Iif(Vartype(tcRuta) # "C" Or Empty(tcRuta),  "C:\Temp\", tcRuta)
	lcNombre = lcRuta + Alltrim(lcName) + '.XLSX'
	If lcOW
		Delete File &lcNombre RECYCLE
	Endif
	This.Mensaje("Generando achivo... espere un momento")
	lnAlias = Alias()
	Select &lnAlias
	Go Top
	If llTotales
		If This._Copy2Excel(lnAlias, lcNombre, lcListaTotales)
			This._OpenExcel(lcNombre)
		Else
			Return 0
		Endif
	Else
		If This._Copy2Excel(lnAlias, lcNombre)
			This._OpenExcel(lcNombre)
		Else
			Return 0
		Endif
	Endif
	This.Cmensaje = "Proceso terminado, se ha generado el archivo "
	Return  1
	Endfunc
	Procedure _Copy2Excel
	Lparameters pcCursor, pcFile, pcColTotals
*
	If Pcount() < 2
		This.Cmensaje = 'Error: Faltan al menos 2 de 3 parametros'
		Return .F.
	Endif
	If !Used(pcCursor)
		Return .F.
	Endif
*
	pcColTotals = Iif(Empty(pcColTotals) Or Vartype(pcColTotals) # 'C', '', Upper(pcColTotals))
	Wait Window Noclear Nowait 'Espere, preparando Excel ...'
	Local oExcel, oMasterWorkBook, oSourceWorkBook, nTotal, nFields, nMaxRows, nNeededSheets, nCurrentSheetCount, ix, iy, ;
		cTempDBF, cTempFPT, cTMPDir, cFontName, nFontSize, cPage, nColTotals, lError
	Local Array aFieldsList(1), aRangos(1)
*
	cTMPDir   = 'C:\WV_TMPDir\'
	cFontName = 'Calibri'
	nFontSize = 9
*
	Try
		Md (cTMPDir)
	Catch
	Endtry
	If !Directory(cTMPDir)
		This.Cmensaje = 'Error: No se creó la carpeta temporal: ' + cTMPDir
		Return .F.
	Endif
*
	lError = .F.
	Try
		oExcel = Createobject('Excel.application')
		nTotal = Reccount(pcCursor)
		nFields = Afields(aFieldsList, pcCursor)
	Catch To oErr
		lError = .T.
	Endtry
	If lError
		Return .F.
	Endif
*
	With oExcel
		.Visible = .F.
		oMasterWorkBook = .WorkBooks.Add
		nMaxRows = .ActiveWorkBook.ActiveSheet.Rows.Count
		nNeededSheets = Ceiling(nTotal / (nMaxRows - 1))
		nCurrentSheetCount = .Sheets.Count
		If nNeededSheets > nCurrentSheetCount
			.Sheets.Add(, .Sheets(nCurrentSheetCount), nNeededSheets - nCurrentSheetCount)
		Endif
	Endwith
*
	nColTotals = Getwordcount(pcColTotals, ',')
	Dimension aRangos(nNeededSheets, 3)
*
	With oMasterWorkBook
		For ix = 1 To nNeededSheets
			cPage = 'H' + Transform(ix)
			.Sheets.Item(ix).Name = cPage
			aRangos(ix, 1) = cPage
		Endfor
		For ix = 1 To nNeededSheets
			cTempDBF = cTMPDir + Sys(2015)
			cTempFPT = cTempDBF + '.FPT'
			cTempDBF = cTempDBF + '.DBF'
			Wait Window Noclear Nowait 'Espere, enviando datos a Excel: H' + Transform(ix) + ' de ' + Transform(nNeededSheets)
			lnStart = (ix - 1) * (nMaxRows - 1) + 1
			Copy To (cTempDBF) For Between(Recno(), lnStart, lnStart + nMaxRows - 2) Type Fox2x As 437
			aRangos(ix, 2) = lnStart
			aRangos(ix, 3) = _Tally
			oSourceWorkBook = oExcel.WorkBooks.Open(cTempDBF)
			.WorkSheets(ix).Activate
			oSourceWorkBook.WorkSheets(1).UsedRange.Copy(.WorkSheets(ix).Range('A1'))
			oSourceWorkBook.Close(.F.)
*
			Erase (cTempDBF)
			If File(cTempFPT)
				Erase (cTempFPT)
			Endif
		Endfor
	Endwith
*
	Wait Window Noclear Nowait 'Datos enviados a Excel. Dando formato y totalizando ...'
	Local Array aFormulas(1)
	Local cCol, cCellFormula, cRangeFormula
	Store '' To cCol, cCellFormula, cRangeFormula
	If nColTotals > 0
		Dimension aFormulas(nColTotals, 2)
	Endif
*
	With oExcel
		For ix = 1 To nNeededSheets
			nColx = 1
			For iy = 1 To nFields
				.Sheets(ix).Cells(1, iy).Value = aFieldsList(iy, 1)
* Formulas para totales
				If !Empty(pcColTotals) And Occurs('|' + aFieldsList(iy, 1) + '|', '|' + Chrtran(pcColTotals, ', ', '|') + '|') > 0
					cCol = _Columna(iy)
					aFormulas(nColx, 1) = cCol + Transform(aRangos(ix, 3) + 2)
					aFormulas(nColx, 2) = Iif(Vartype(aFormulas(nColx, 2)) # 'C', '', aFormulas(nColx, 2)) + ;
						.Sheets(ix).Name + '!' + cCol + '2:' + cCol + Transform(aRangos(ix, 3) + 1) + ','
					nColx = nColx + 1
				Endif
			Endfor
* Todas las filas y columnas
			.Sheets(ix).Range(.Sheets(ix).Cells(1, 1), .Sheets(ix).Cells(nMaxRows, nFields)).Font.Name = cFontName
			.Sheets(ix).Range(.Sheets(ix).Cells(1, 1), .Sheets(ix).Cells(nMaxRows, nFields)).Font.Size = nFontSize
* Estilo de los encabezados (Campos)
			.Sheets(ix).Range(.Sheets(ix).Cells(1, 1), .Sheets(ix).Cells(1, nFields)).Font.Bold = .T.
			.Sheets(ix).Range(.Sheets(ix).Cells(1, 1), .Sheets(ix).Cells(1, nFields)).Interior.ColorIndex = 45
			.Sheets(ix).Range(.Sheets(ix).Cells(1, 1), .Sheets(ix).Cells(1, nFields)).Interior.Pattern = 1
* Fijar encabezados
			oMasterWorkBook.WorkSheets(ix).Activate
			.Sheets(ix).Cells(2, 1).Select
			.ActiveWindow.FreezePanes = .T.
*
			.Sheets(ix).Columns.AutoFit
		Endfor
* Totalizar
		If nColTotals > 0
			For ix = 1 To Alen(aFormulas, 1)
				cCellFormula = aFormulas(ix, 1)
				cRangeFormula = aFormulas(ix, 2)
				cRangeFormula = Substr(cRangeFormula, 1, Len(cRangeFormula) - 1)
				.Sheets(nNeededSheets).Range(cCellFormula).Font.Bold = .T.
				.Sheets(nNeededSheets).Range(cCellFormula).Interior.ColorIndex = 15
				.Sheets(nNeededSheets).Range(cCellFormula).Interior.Pattern = 1
				.Sheets(nNeededSheets).Range(cCellFormula).Formula = "=SUM(&cRangeFormula.)"
				.Sheets(nNeededSheets).Columns.AutoFit
			Endfor
		Endif
*
		Wait Window Noclear Nowait 'Libro de Excel completo'
		oMasterWorkBook.WorkSheets(1).Activate
		.DisplayAlerts = .F.
		.ActiveWorkBook.SaveAs(pcFile)
		.Quit
	Endwith
*
	oMasterWorkBook = Null
	oExcel = Null
	Release oExcel, oMasterWorkBook
*
	Wait Clear
	Return .T.
	Endproc
*****************************
	Procedure Mensaje
	Lparameters lcMess
	If Type("lcMess") = "L"
		Return .F.
	Endif
	Wait Window lcMess At Srows() / 2, (Scols() / 2 - (Len(lcMess) / 2)) Timeout 1
	Endproc
	Procedure _Columna
	Lparameters tn
*
	Local lC
	lC = ""
	Do While tn > 26
		lC = Chr(Iif(Mod(tn, 26) = 0, 26, Mod(tn, 26)) + 64) + lC
		tn = Int((tn - 1) / 26)
	Enddo
	lC = Chr(Iif(Mod(tn, 26) = 0, tn, Mod(tn, 26)) + 64) + lC
*
	Return lC


	Procedure _OpenExcel
	Lparameters pcFile
	Declare Integer ShellExecute In Shell32.Dll Integer pcWin, String pcAction, String pcFileName, String pcPars, String pcDir, Integer pnShowWin
	ShellExecute(0, 'Open', pcFile, '', '', 1)
	Clear Dlls ShellExecute
	Endproc
*********************************
	Function Exp2Excel( Ccursor, cFileSave, cTitulo )
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	If Empty(Ccursor)
		Ccursor = Alias()
	Endif
	If Type('cCursor') # 'C' Or !Used(Ccursor)
		This.cmensaje = "Parámetros Inválidos"
		Return 0
	Endif
*********************************
*** Creación del Objeto Excel ***
*********************************
	This.Mensaje('Generando')
	oExcel = Createobject("Excel.Application")
	Wait Clear

	If Type('oExcel') # 'O'
		This.Cmensaje = "No se puede procesar el Archivo porque No tiene la aplicación" ;
			+ Chr(13) + "Microsoft Excel instalada en su computador."
		Return 0
	Endif

	oExcel.WorkBooks.Add

	Local lnRecno, lnPos, lnPag, lnCuantos, lnRowTit, lnRowPos, i, lnHojas, cDefault

	cDefault = Addbs(Sys(5)  + Sys(2003))

	Select (Ccursor)
	lnRecno = Recno(Ccursor)
	Go Top

*************************************************
*** Verifica la cantidad de hojas necesarias  ***
*** en el libro para la cantidad de datos     ***
*************************************************
	lnHojas = Round(Reccount(Ccursor) / 65000, 0)
	Do While oExcel.Sheets.Count < lnHojas
		oExcel.Sheets.Add
	Enddo

	lnPos = 0
	lnPag = 0

	Do While lnPos < Reccount(Ccursor)

		lnPag = lnPag + 1 && Hoja que se está procesando

		this.Mensaje('Exportando   Microsoft Excel...' ;
			  + Chr(13) + '(Hoja '  + Alltrim(Str(lnPag))  + ' de '  + Alltrim(Str(lnHojas)) + ')')

		If File(cDefault  + Ccursor  + ".txt")
			Delete File (cDefault  + Ccursor  + ".txt")
		Endif

		Copy  Next 65000 To (cDefault  + Ccursor  + ".txt") Delimited With Character ";"
		lnPos = Recno(Ccursor)

		oExcel.Sheets(lnPag).Select

		XLSheet = oExcel.ActiveSheet
		XLSheet.Name = Ccursor + '_' + Alltrim(Str(lnPag))

		lnCuantos = Afields(aCampos, Ccursor)

********************************************************
*** Coloca título del informe (si este es informado) ***
********************************************************
		If !Empty(cTitulo)
			XLSheet.Cells(1, 1).Font.Name = "Arial"
			XLSheet.Cells(1, 1).Font.Size = 12
			XLSheet.Cells(1, 1).Font.Bold = .T.
			XLSheet.Cells(1, 1).Value = cTitulo
			XLSheet.Range(XLSheet.Cells(1, 1), XLSheet.Cells(1, lnCuantos)).MergeCells = .T.
			XLSheet.Range(XLSheet.Cells(1, 1), XLSheet.Cells(1, lnCuantos)).Merge
			XLSheet.Range(XLSheet.Cells(1, 1), XLSheet.Cells(1, lnCuantos)).HorizontalAlignment = 3
			lnRowPos = 3
		Else
			lnRowPos = 2
		Endif

		lnRowTit = lnRowPos - 1
**********************************
*** Coloca títulos de Columnas ***
**********************************
		For i = 1 To lnCuantos
			lcName  = aCampos(i, 1)
			lcCampo = Alltrim(Ccursor) + '.' + aCampos(i, 1)
			XLSheet.Cells(lnRowTit, i).Value = lcName
			XLSheet.Cells(lnRowTit, i).Font.Bold = .T.
			XLSheet.Cells(lnRowTit, i).Interior.ColorIndex = 15
			XLSheet.Cells(lnRowTit, i).Interior.Pattern = 1
			XLSheet.Range(XLSheet.Cells(lnRowTit, i), XLSheet.Cells(lnRowTit, i)).BorderAround(7)
		Next

		XLSheet.Range(XLSheet.Cells(lnRowTit, 1), XLSheet.Cells(lnRowTit, lnCuantos)).HorizontalAlignment = 3

*************************
*** Cuerpo de la hoja ***
*************************
		oConnection = XLSheet.QueryTables.Add("TEXT;"  + cDefault  + Ccursor  + ".txt", ;
			  XLSheet.Range("A"  + Alltrim(Str(lnRowPos))))

		With oConnection
			.Name = Ccursor
			.FieldNames = .T.
			.RowNumbers = .F.
			.FillAdjacentFormulas = .F.
			.PreserveFormatting = .T.
			.RefreshOnFileOpen = .F.
			.RefreshStyle = 1 && xlInsertDeleteCells
			.SavePassword = .F.
			.SaveData = .T.
			.AdjustColumnWidth = .T.
			.RefreshPeriod = 0
			.TextFilePromptOnRefresh = .F.
			.TextFilePlatform = 850
			.TextFileStartRow = 1
			.TextFileParseType = 1 && xlDelimited
			.TextFileTextQualifier = 1 && xlTextQualifierDoubleQuote
			.TextFileConsecutiveDelimiter = .F.
			.TextFileTabDelimiter = .F.
			.TextFileSemicolonDelimiter = .T.
			.TextFileCommaDelimiter = .F.
			.TextFileSpaceDelimiter = .F.
			.TextFileTrailingMinusNumbers = .T.
			.Refresh
		Endwith

		XLSheet.Range(XLSheet.Cells(lnRowTit, 1), XLSheet.Cells(XLSheet.Rows.Count, lnCuantos)).Font.Name = "Arial"
		XLSheet.Range(XLSheet.Cells(lnRowTit, 1), XLSheet.Cells(XLSheet.Rows.Count, lnCuantos)).Font.Size = 8

		XLSheet.Columns.AutoFit
		XLSheet.Cells(lnRowPos, 1).Select
		oExcel.ActiveWindow.FreezePanes = .T.

		Wait Clear

	Enddo

	oExcel.Sheets(1).Select
	oExcel.Cells(lnRowPos, 1).Select

	If !Empty(cFileSave)
		oExcel.DisplayAlerts = .F.
		oExcel.ActiveWorkBook.SaveAs(cFileSave)
		oExcel.Quit
	Else
		oExcel.Visible = .T.
	Endif

	Go lnRecno

	Release oExcel, XLSheet, oConnection

	If File(cDefault + Ccursor + ".txt")
		Delete File (cDefault + Ccursor + ".txt")
	Endif
	Return 1
	Endfunc
	Function exporta3(lcursor,  lnombre)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	If Type('lcursor') # 'C' Or !Used(lcursor)
		This.Cmensaje = "Parametros Invalidos"
		Return 0
	Endif
	If Type('lnombre') # 'C'
		lnombre = ''
	Endif
	Local lpag As Integer &&&&variable para determinar la página a ingresar los datos por si hay más de 60 mil registros
	lpag = 1
	
*** Creación del Objeto Excel
	Select (lcursor)
	lcuantos = Afields(lcampos, lcursor)
	Go Top In (lcursor)
	This.Mensaje('Abriendo aplicación Excel.')
	oExcel = Createobject("Excel.Application")
	oExcel .Visible = .F.
	oExcel.ScreenUpdating = .F.
	If Type('Oexcel') # 'O'
		This.Cmensaje = "No esta Instalala aplicación " + Chr(13) + "Microsoft Excel instalada en su computador."
		Return 0
	Endif
	This.Mensaje('Exportando ...' + Lower(lcursor))
	XLApp = oExcel
	XLApp.WorkBooks.Add()
	XLSheet = XLApp.ActiveSheet
	XLSheet.Name = "Sistema"
	Local R, lcampo
	R = 6
	Scan
		If R = 65500
			For i = 1 To lcuantos
				lcName = lcampos(i, 1)
				XLSheet.Cells(4, i).Value = lcName
				XLSheet.Cells(4, i).Font.Name = "tahoma"
				XLSheet.Cells(4, i).Font.Size = 10
				XLSheet.Cells(4, i).Font.Bold = .T.
			Next
			XLSheet.Columns.AutoFit
			XLSheet.Cells(2, 1).Value = lnombre
			XLSheet.Cells(2, 1).Font.Bold = .T.
			XLSheet.Cells(1, 1).Font.Bold = .T.
			XLSheet.Cells(1, Iif((lcuantos - 1) > 0, lcuantos - 1, lcuantos)).Value = Alltrim(Dtoc(Date()))
			XLSheet.Columns.AutoFit
			R = 6
			lpag = lpag + 1
			XLApp.Sheets(lpag).Select
			XLSheet = XLApp.ActiveSheet
			XLSheet.Name = "Hoja 1"
		Endif
		For i = 1 To lcuantos
			XLSheet.Cells(R, i).Font.Name = "tahoma"
			XLSheet.Cells(R, i).Font.Size = 10
			lcampo = Alltrim(lcursor) + '.' + lcampos(i, 1)
			If Type('&lcampo') # 'G'
				Do Case
				Case Type('&lcampo') = 'C'
					XLSheet.Cells(R, i).Value = Alltrim(&lcampo)
				Case Type('&lcampo') = 'T'
					XLSheet.Cells(R, i).Value = Ttoc(&lcampo)
				Otherwise
					XLSheet.Cells(R, i).Value = &lcampo
				Endcase
			Endif
		Next
		R = R + 1
	Endscan
	For i = 1 To lcuantos
		lcName = lcampos(i, 1)
		XLSheet.Cells(4, i).Value = lcName
		XLSheet.Cells(4, i).Font.Name = "tahoma"
		XLSheet.Cells(4, i).Font.Size = 10
		XLSheet.Cells(4, i).Font.Bold = .T.
	Next
	XLSheet.Columns.AutoFit
	XLSheet.Cells(2, 1).Value = lnombre
	XLSheet.Cells(2, 1).Font.Bold = .T.
	XLSheet.Cells(1, 1).Font.Bold = .T.
	XLSheet.Cells(1, Iif((lcuantos - 1) > 0, lcuantos - 1, lcuantos)).Value = Alltrim(Dtoc(Date()))
	XLSheet.Columns.AutoFit
	This.Cmensaje = 'Listo....'
	oExcel.Visible = .T.
	oExcel.ScreenUpdating = .T.
	Return 1
	Endfunc
Enddefine