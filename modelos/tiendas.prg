Define Class Tienda As Odata Of 'd:\capass\database\data.prg'
	Function Muestratiendas(Ccursor)
	If This.Muestratiendasx(Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function Muestratiendasx(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	If Alltrim(goApp.datostdas) <> 'S' Then
		If This.consultardata(Ccursor) < 1 Then
			Return 0
		Endif
	Else
		If Type("cfieldsfesucu") <> 'U' Then
*!*		       wait WINDOW cfieldsfesucu[1,1]
		Endif
		Create Cursor b_tdas From Array cfieldsfesucu
		cfilejson = Addbs(Sys(5) + Sys(2003)) + 'a' + Alltrim(Str(goApp.Xopcion)) + '.json'
		conerror = 0
		If File(m.cfilejson) Then
			responseType1 = Addbs(Sys(5) + Sys(2003)) + 'a' + Alltrim(Str(goApp.Xopcion)) + '.json'
			If Vartype(m.oResponse) = 'O' Then
				For Each oRow In  oResponse.Array
					Insert Into a_tdas From Name oRow
				Endfor
				Select * From a_tdas Into Cursor (Ccursor)
			Else
				If This.consultardata(Ccursor) < 1 Then
					conerror = 1
				Endif
			Endif
		Else
			If This.consultardata(Ccursor) < 1 Then
				conerror = 1
			Endif
		Endif
		If conerror = 1 Then
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function almacenesmovizatrujillo(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lC Noshow Textmerge
	   SELECT nomb,idalma,dire,ciud,sucuidserie FROM fe_sucu  WHERE idalma IN(1,2) ORDER BY nomb
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function almaceneslyg(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lC Noshow Textmerge
	   SELECT nomb,idalma,dire,ciud,sucuidserie FROM fe_sucu  WHERE idalma IN(1,2,3,4,5,6,7,8) ORDER BY idalma
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function consultardata(Ccursor)
	lC = "PROMUESTRAALMACENES"
	If This.EJECUTARP(lC, "", Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	nCount = Afields(cfieldsfesucu)
	Select * From (Ccursor) Into Cursor a_tdas
	cdata = nfcursortojson(.T.)
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'a' + Alltrim(Str(goApp.Xopcion)) + '.json'
	If File(m.rutajson) Then
		Delete File (m.rutajson)
	Endif
	Strtofile (cdata, rutajson)
	goApp.datostdas = 'S'
	Return 1
	Endfunc
Enddefine













