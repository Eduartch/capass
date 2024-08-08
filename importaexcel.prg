*-----------------------------------
* AUTHOR: Trevor Hancock
* CREATED: 02/15/08 04:55:31 PM
* ABSTRACT: Code demonstrates how to connect to
* and extract data from an Excel 2007 Workbook
* using the "Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)"
* from the 2007 Office System Driver: Data Connectivity Components
*-----------------------------------

Local lcXLBook As String, lnSQLHand As Integer, ;
	lcSQLCmd As String, lnSuccess As Integer, ;
	lcConnstr As String

lcXLBook = Getfile('xls, xlsx, xlsm, xlsb', 'Archivo:', 'Aceptar', 0, 'Seleccione una hoja de c�lculo')
If Empty(lcXLBook)
	Return .F.
Endif

If !File(lcXLBook)
	Messagebox("Archivo no encontrado", 16)
	Return .F.
Endif

Local oExcel As Excel.Application
m.oExcel = Createobject("Excel.application")

If Vartype(oExcel,.T.)!='O'
	Messagebox("No se puede procesar el archivo porque no tiene la aplicaci�n" ;
		+ Chr(13) + "Microsoft Excel instalada en su computador.", 16)
	m.oExcel = Null
	Release oExcel
	Return .F.
Endif

m.oExcel.Workbooks.Open(m.lcXLBook)
m.oExcel.Sheets(1).Select

Local oSheet As Object, lcSheet As String
m.oSheet = m.oExcel.ActiveSheet
m.lcSheet = m.oSheet.Name

m.oExcel.Quit()
m.oExcel = Null
Release oSheet, oExcel

lcConnstr = [Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ=] + lcXLBook
lnSQLHand = Sqlstringconnect( lcConnstr )
lcSQLCmd = [Select * fROM "] + m.lcSheet + [$"]
lnSuccess = SQLExec( lnSQLHand, lcSQLCmd, [xlista] )

If lnSuccess < 0
	Local Array laErr[1]
	Aerror( laErr )
	Messagebox(laErr(3), 16)
	SQLDisconnect( lnSQLHand )
	Return .F.
Endif

Select xlista
SQLDisconnect(lnSQLHand)