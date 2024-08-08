Set Talk Off
Set Safety Off
Set Deleted On
Set Date Dmy
Set Century On
Set Null Off
Close Tables All
Close Databases All
Create Cursor mi_cursor (campo1 c(10), campo2 c(10))
lcArchivo = Getfile([xls])
If !Empty(lcArchivo)
* abrir excel y formatear datos
	llError = .F.
	On Error llError = .T.
	loExcel = Createobject([Excel.Application])
	On Error
	If !llError And Vartype(loExcel)="O"
		loExcel.DisplayAlerts = .F.
*!* loExcel.visible = .t.
		llError = .F.
		On Error llError = .T.
		loLibro = loExcel.Workbooks.Open(lcArchivo)
		On Error
		If !llError
			loHoja = loLibro.Sheets(1)
			loHoja.Activate
*!*
*!* Se supone que los datos se encuentran a partir del renglón 2.
*!*
			lnFila = 2
			Do While .T.
				Wait Window [ Procesando el registro ]+Alltrim(Str(lnFila)) Nowait
				With loHoja.Rows
					lcCampo1 = .cells(lnFila, 1).Value
					If Isnull(lcCampo1) Or Empty(lcCampo1)
						Exit
					Endif
					lcCampo2 = .cells(lnFila, 2).Value
					lcCampo2 = Iif(Isnull(lcCampo2), '', lcCampo2)
					lcCampo3 = .cells(lnFila, 3).Value
					lcCampo3 = Iif(Isnull(lcCampo3), '', lcCampo3)
					Insert Into mi_cursor (campo1, campo2) Values (lcCampo1,lcCampo2)
				Endwith
				lnFila = lnFila+1
			Enddo
			loLibro.Close
			loExcel.Quit
			Release loExcel
		Endif
	Endif
Endif
