Define Class zona As Odata Of 'd:\capass\database\data.prg'
	Function consultardata(np1, ccursor)
	cproc		 ='PROMUESTRAZONAS'
	goapp.npara1 =m.np1
	TEXT To m.lparametros Noshow
          (?goapp.npara1)
	ENDTEXT
	If  This.ejecutarp(cproc,lparametros, ccursor) < 1 Then
		Return 0
	Endif
	Select (ccursor)
	If regdvto(ccursor)<1 Then
		goapp.datoszonas = ''
		Return 1
	Endif
	nCount = Afields(cfieldsfezona)
	Select * From (ccursor) Into Cursor a_zonas
	cdata = nfcursortojson(.T.)
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'z' + Alltrim(Str(goapp.xopcion)) + '.json'
	If File(m.rutajson) Then
		Delete File (m.rutajson)
	Endif
	Strtofile (cdata, rutajson)
	goapp.datoszonas = 'S'
	Return 1
	Endfunc
	Function listar(ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
	SELECT a.zona_nomb as zona,a.zona_idzo FROM fe_zona AS a  WHERE a.zona_acti<>'I'  ORDER BY a.zona_nomb
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarzonas(np1,ccursor)
	If Alltrim(goapp.datoszonas) <> 'S' Then
		If This.consultardata(np1,ccursor) < 1 Then
			Return 0
		Endif
	Else
		Create Cursor a_zonas From Array cfieldsfezona
		cfilejson = Addbs(Sys(5) + Sys(2003)) + 'z' + Alltrim(Str(goapp.xopcion)) + '.json'
		conerror = 0
		If File(m.cfilejson) Then
			oResponse = nfJsonRead(m.cfilejson)
			If Vartype(m.oResponse) = 'O' Then
				For Each oRow In  oResponse.Array
					Insert Into a_zonas From Name oRow
				Endfor
				Select * From a_zonas Into Cursor (ccursor)
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
Enddefine
