Define Class fletes As OData Of "d:\capass\database\data.prg"
	idflete = 0
	cdesc = ""
	ncosto = 0
	nidusuario = 0
	Function mostrarfletes(np1, Ccursor)
	Local lC, lp
	m.lC		 = 'PROMUESTRAFLETES'
	goApp.npara1 = m.np1
	Text To m.lp Noshow
     (?goapp.npara1)
	Endtext
	If This.EJECUTARP(m.lC, m.lp, m.Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function CreaCostoFletes()
	lsql = "FUNCREAFLETES"
	Text To lp Noshow Textmerge
	('<<this.cdesc>>',<<this.ncosto>>,<<goapp.nidusua>>,'<<ID()>>')
	Endtext
	nidf = This.EJECUTARf(lsql, lp, 'fl')
	If nidf < 1
		Return 0
	Endif
	Return nidf
	Endfunc
Enddefine