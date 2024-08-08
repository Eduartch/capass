SELECT coda,desc FROM x INTO CURSOR xx
rep_excel('xx','')
Function rep_excel(lcursor As String, lnombre As String)
*!*       Parametros:
*!*      lcursor: Nombre del Cursor o Tabla que se va a llevar a excel
*!*      lnombre: El titulo de la pagina

************************************
*!* Program:Rep_excel
*!* Author: José G. Samper
*!* Date: 10/09/03 04:08:04 PM
*!* Copyright: NetBuzo's
*!* Description: Esta función lleva a una hoja excel el contenido de un cursor
*!* Colocando un Nombre pasado como parametro y los nombres de los campos del cursor como encabezado
*!* Revision Information:1.0
*!* Ejemplo de Uso: =rep_excel('mitabla','Listado de Artículos con sus Precios')
*!* Enviar Bugs o sugerencias para mejoras a j_samper(sin)@cantv.net
*************************************
If Type('lcursor')#'C' Or !Used(lcursor)
	=Messagebox("Parametros Invalidos",16,'De VFP a Excel')
	Return .F.
Endif
If Type('lnombre')#'C'
	lnombre=''
Endif
Local lpag As Integer &&&&variable para determinar la página a ingresar los datos por si hay más de 60 mil registros
lpag=1
*** Creación del Objeto Excel
Wait Window 'Abriendo aplicación Excel.' Nowait
Oexcel = Createobject("Excel.Application")
Wait Clear
If Type('Oexcel')#'O'
	=Messagebox("No se puede procesar el archivo porque no tiene la aplicación"+Chr(13)+;
		"Microsoft Excel instalada en su computador.",16,'De VFP a Excel')
	Return .F.
Endif
Wait Windows 'Procesando Tabla...'+Lower(lcursor) Noclear Nowait
XLApp = Oexcel
XLApp.workbooks.Add()
XLSheet = XLApp.ActiveSheet
XLSheet.Name='VFP_'+Alltr(Str(lpag))
Select(lcursor)
lcuantos=Afields(lcampos,lcursor)
Go Top In (lcursor)
Local R,lcampo
R=6
Scan
	If R= 65500
		For I = 1 To lcuantos
			lcname=lcampos(I,1)
			XLSheet.Cells(4,I).Value=lcname
			XLSheet.Cells(4,I).Font.Name = "Arial"
			XLSheet.Cells(4,I).Font.Size = 10
			XLSheet.Cells(4,I).Font.bold = .T.
		Next
		XLSheet.Columns.AutoFit
		XLSheet.Cells(2,1).Value=lnombre
		XLSheet.Cells(2,1).Font.bold = .T.
		XLSheet.Cells(1,1).Value='Demostración de Vfp a Excel'
		XLSheet.Cells(1,1).Font.bold = .T.
		XLSheet.Cells(1,Iif((lcuantos-1)>0,lcuantos-1,lcuantos)).Value=Alltrim(Dtoc(Date()))
		XLSheet.Columns.AutoFit
		R=6
		lpag=lpag+1
		XLApp.Sheets(lpag).Select
		XLSheet = XLApp.ActiveSheet
		XLSheet.Name='VFP_'+Alltr(Str(lpag))
	Endif
	For I=1 To lcuantos
		lcampo=Alltrim(lcursor)+'.'+lcampos(I,1)
		If Type('&lcampo')#'G'
			If Type('&lcampo')='C'
				XLSheet.Cells(R,I).Value=Alltrim(&lcampo)
				XLSheet.Cells(R,I).Font.Name = "Arial"
				XLSheet.Cells(R,I).Font.Size = 10
			Else
				If Type('&lcampo')='T'
					XLSheet.Cells(R,I).Value=Ttoc(&lcampo)
				Else
					XLSheet.Cells(R,I).Value=&lcampo
				Endif
				XLSheet.Cells(R,I).Font.Name = "Arial"
				XLSheet.Cells(R,I).Font.Size = 10
			Endif
		Endif
	Next
	R=R+1
Endscan
For I = 1 To lcuantos
	lcname=lcampos(I,1)
	XLSheet.Cells(4,I).Value=lcname
	XLSheet.Cells(4,I).Font.Name = "Arial"
	XLSheet.Cells(4,I).Font.Size = 10
	XLSheet.Cells(4,I).Font.bold = .T.
Next
XLSheet.Columns.AutoFit
XLSheet.Cells(2,1).Value=lnombre
XLSheet.Cells(2,1).Font.bold = .T.
XLSheet.Cells(1,1).Value='Demostración de Vfp a Excel'
XLSheet.Cells(1,1).Font.bold = .T.
XLSheet.Cells(1,Iif((lcuantos-1)>0,lcuantos-1,lcuantos)).Value=Alltrim(Dtoc(Date()))
XLSheet.Columns.AutoFit
Wait Windows 'Listo....' Nowait
Oexcel.Visible=.T.
Return .T.
Endfunc
