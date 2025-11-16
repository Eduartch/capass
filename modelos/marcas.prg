Define Class marcas As OData Of "d:\capass\database\data.prg"
	nidmar = 0
	descmar = ""
	cidpc = ""
	nidusua = 0
	Function VAlidar()
	Do Case
	Case Empty(This.descmar)
		This.Cmensaje = "Ingrese la Descripción de Marca"
		Return .F.
	Otherwise
		Return .T.
	Endcase
	Endfunc
	Function Crear()
	If !This.VAlidar()
		Return 0
	Endif
	lsql = "FUNCREAMARCAS"
	goApp.npara1 = This.descmar
	goApp.npara2 = This.nidusua
	goApp.npara3 = This.cidpc
	Text To lp Noshow
	(?goapp.npara1,?goapp.npara2,?goapp.npara3)
	Endtext
	nidmar = This.EJECUTARf(lsql, lp, 'mm')
	If m.nidmar < 1 Then
		Return  0
	Endif
	This.Cmensaje = 'Ok'
	Return m.nidmar
	Endfunc
	Function Editar()
	If !This.VAlidar()
		Return 0
	Endif
	If This.nidmar < 1 Then
		This.Cmensaje = 'Seleccione Una Marca para Editar'
		Return 0
	Endif
	goApp.npara1 = This.descmar
	nidmar = This.nidmar
	Text To lsql Noshow
	 UPDATE fe_mar SET dmar=?goapp.npara1 WHERE idmar=?nidmar
	Endtext
	If This.Ejecutarsql(lsql) < 1 Then
		Return  0
	Endif
	This.Cmensaje = 'Ok'
	Return m.nidmar
	Endfunc
	Function consultardata(np1, Ccursor)
	Local lC, lp
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	m.lC		 = 'PROMUESTRAMARCAS'
	goApp.npara1 = m.np1
	Text To m.lp Noshow
     (?goapp.npara1)
	Endtext
	If This.EJECUTARP(m.lC, m.lp, m.Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If REgdvto(Ccursor) < 1 Then
		goApp.datosmarcas = ''
		Return 1
	Endif
	nCount = Afields(cfieldsfemarca)
	Select * From (Ccursor) Into Cursor a_marcas
	cdata = nfcursortojson(.T.)
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'mca' + Alltrim(Str(goApp.Xopcion)) + '.json'
	If File(m.rutajson) Then
		Delete File (m.rutajson)
	Endif
	Strtofile (cdata, rutajson)
	goApp.datosmarcas = 'S'
	Return 1
	Endfunc
	Function MostrarMarcas(np1, Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	If Alltrim(goApp.datosmarcas) <> 'S' Then
		If This.consultardata(np1, Ccursor) < 1 Then
			Return 0
		Endif
	Else
		Create Cursor a_marcas From Array cfieldsfemarca
		cfilejson = Addbs(Sys(5) + Sys(2003)) + 'mca' + Alltrim(Str(goApp.Xopcion)) + '.json'
		conerror = 0
		If File(m.cfilejson) Then
			oResponse = nfJsonRead(m.cfilejson)
			If Vartype(m.oResponse) = 'O' Then
				For Each oRow In  oResponse.Array
					Insert Into a_marcas From Name oRow
				Endfor
				Select *  From  a_marcas  Into Cursor (Ccursor)
			Else
				If This.consultardata(np1, Ccursor) < 1 Then
					conerror = 1
				Endif
			Endif
		Else
			If This.consultardata(np1, Ccursor) < 1 Then
				conerror = 1
			Endif
		Endif
		If conerror = 1 Then
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function Desactiva(np1)
	Ccursor = 'c_' + Sys(2015)
	Text To lC Noshow Textmerge
     SELECT COUNT(*) as Tmarcas FROM fe_art WHERE idmar=<<np1>> and prod_acti='A' GROUP BY idmar
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	tmar = Iif(Vartype(tmarcas) = 'C', Val(tmarcas), tmarcas)
	If tmar > 0 Then
		This.Cmensaje = "Se Han registrado " + Alltrim(Str(m.tmar, 12, 2)) + " Productos con esta Marca"
		Return 0
	Endif
	Text To lp Noshow Textmerge
       UPDATE fe_mar SET marc_acti='I' WHERE idmar=<<np1>>
	Endtext
	If This.Ejecutarsql(lp) < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'Desactivado Ok'
	Return 1
	Endfunc
	Function BuscaSiEstaRegistrado(cb)
	Ccursor = 'c_' + Sys(2015)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select idmar  From fe_mar Where Trim(dmar)='<<ALLTRIM(cb)>>' And marc_acti<>'I'
	If This.nidmar > 0 Then
       \ And idmar<><<This.nidmar>>
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return  0
	Endif
	Select (Ccursor)
	If idmar > 0 Then
		This.Cmensaje = "Nombre de Marca  Ya existe"
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine




