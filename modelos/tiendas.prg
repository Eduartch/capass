Define Class Tienda As OData Of 'd:\capass\database\data.prg'
	cnomb = ""
	cdire = ""
	cciud = ""
	nserie = 0
	nidus = 0
	nid = 0
	nmetavtas = 0

	Function EditaAlmacen()
	cur = "Tda"
	lC = 'ProEditaAlmacen'
	goApp.npara1 = this.cnomb
	goApp.npara2 = this.cdire
	goApp.npara3 = this.cciud
	goApp.npara4 = this.nserie
	goApp.npara5 = this.nidus
	goApp.npara6 = this.nid
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
	Endtext
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
    Function EditaAlmacenmetasvtas()
	cur = "Tda"
	lC = 'ProEditaAlmacen'
	goApp.npara1 = this.cnomb
	goApp.npara2 = this.cdire
	goApp.npara3 = this.cciud
	goApp.npara4 = this.nserie
	goApp.npara5 = this.nidus
	goApp.npara6 = this.nid
	goApp.npara7 = this.nmetavtas
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7)
	Endtext
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
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
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function almaceneslyg(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lC Noshow Textmerge
	   SELECT nomb,idalma,dire,ciud,sucuidserie FROM fe_sucu  WHERE idalma IN(1,2,3,4,5,6,7,8,9,10) ORDER BY idalma
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
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















