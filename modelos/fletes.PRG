Define Class fletes As OData Of "d:\capass\database\data.prg"
	idflete = 0
	cdesc = ""
	ncosto = 0
	nidusuario = 0
	Function consultardata(np1,ccursor)
	Local lc, lp
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	m.lc		 = 'PROMUESTRAFLETES'
	goapp.npara1 = m.np1
	TEXT To m.lp Noshow
     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, m.ccursor) < 1 Then
		Return 0
	Endif
	Select (ccursor)
	If regdvto(ccursor)<1 Then
		goapp.datosfletes = ''
		Return 1
	Endif
	nCount = Afields(cfieldsfeflete)
	Select * From (ccursor) Into Cursor a_fletes
	cdata = nfcursortojson(.T.)
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'fl' + Alltrim(Str(goapp.xopcion)) + '.json'
	If File(m.rutajson) Then
		Delete File (m.rutajson)
	Endif
	Strtofile (cdata, rutajson)
	goapp.datosfletes = 'S'
	Return 1
	Endfunc
	Function mostrarfletes(np1, ccursor)
	If Alltrim(goapp.datosfletes) <> 'S' Then
		If This.consultardata(np1,ccursor) < 1 Then
			Return 0
		Endif
	Else
		Create Cursor a_fletes From Array cfieldsfeflete
		cfilejson = Addbs(Sys(5) + Sys(2003)) + 'fl' + Alltrim(Str(goapp.xopcion)) + '.json'
		conerror = 0
		If File(m.cfilejson) Then
			oResponse = nfJsonRead(m.cfilejson)
			If Vartype(m.oResponse) = 'O' Then
				For Each oRow In  oResponse.Array
					Insert Into a_fletes From Name oRow
				Endfor
				Select *  From  a_fletes  Into Cursor (ccursor)
			Else
				If This.consultardata(np1,ccursor) < 1 Then
					conerror = 1
				Endif
			Endif
		Else
			If This.consultardata(np1,ccursor) < 1 Then
				conerror = 1
			Endif
		Endif
		If conerror = 1 Then
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function CreaCostoFletes()
	lsql = "FUNCREAFLETES"
	TEXT To lp Noshow Textmerge
	('<<this.cdesc>>',<<this.ncosto>>,<<goapp.nidusua>>,'<<ID()>>')
	ENDTEXT
	nidf = This.EJECUTARf(lsql, lp, 'fl')
	If nidf < 1
		Return 0
	Endif
	Return nidf
	Endfunc
Enddefine
