**** Importar Masivo desde Excel
* Poner en Primera Fila los Nombres de Campo, los que se
* chequearan que coincidan en la tabla
* Modificado por Ludwig Corales M.
* 28/08/2009
CLEAR
CLOSE ALL 
xArchivo = "d:\psysl\bbvalopez.xlsx"
USE d:\psysl\opera IN  0 EXCLUSIVE 
SELECT opera 
ZAP 
xTabla=ALIAS()
*-- Creo el objeto Excel
loExcel = Createobject("Excel.Application")
With loExcel.Application
	.Visible = .F.
*-- Abro la planilla con datos
	.WorkBooks.Open("&xArchivo")
*-- Cantidad de columnas
	lnCol = .ActiveSheet.UsedRange.Columns.Count
*-- Cantidad de filas
* Se resta la Fila 1 donde estan los campos
	lnFil = .ActiveSheet.UsedRange.Rows.Count
*-- Recorro todas las celdas
** el Recorrido es columnas y luego filas
	For lnJ = 2 To lnFil
		SELECT ("&xTabla")
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
					Replace &xCampo With Ttod(xValor) In &xTabla
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
	Endfor
*-- Cierro la planilla
	.WorkBooks.Close
*-- Salgo de Excel
	.Quit
Endwith
Release loExcel
Select("&xTabla")
Browse
