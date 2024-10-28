Define Class menusapp As Odata Of 'd:\capass\database\data.prg'
	Function muestramenu(np1, np2, Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	If Alltrim(goApp.datosmenus) <> 'S' Then
		If This.consultadata0('menusop') < 1 Then
			Return 0
		Endif
	Endif
	If This.consultadata1(np1, np2, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	Return 1
	Endfunc
	Function consultadata1(np1, np2, Ccursor)
	m.cfilejson = Addbs(Sys(5) + Sys(2003)) + 'm' + Alltrim(Str(goApp.Xopcion)) + '.json'
	If File(m.cfilejson) Then
		Create Cursor b_menus From Array cfieldsfemenu
		responseType1 = Addbs(Sys(5) + Sys(2003)) + 'm' + Alltrim(Str(goApp.Xopcion)) + '.json'
		oResponse = nfJsonRead(m.responseType1)
		If Vartype(m.oResponse) = 'O' Then
			For Each oRow In  oResponse.Array
				Insert Into b_menus From Name oRow
			Endfor
			Select * From b_menus Where menu_tipo = np2 Into Cursor (Ccursor)
			Return 1
		Else
			goApp.datosmenus = ""
			This.Cmensaje = 'Consultando...'
			Return 0
		Endif
	Else
		goApp.datosmenus = ""
		This.Cmensaje = 'Consultando...'
		Return 0
	Endif
	Endfunc
	Function MostrarMenu1(np1, np2, np3, np4, Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	If Alltrim(goApp.datosmenus1) <> 'S' Then
		If This.consultadata2(np1, np2, np3, np4, Ccursor) < 1 Then
			Return 0
		Endif
	Endif
	cfilejson = Addbs(Sys(5) + Sys(2003)) + 'm1' + Alltrim(Str(goApp.Xopcion)) + '.json'
	Create Cursor b_menus1 From Array cfieldsfemenu1
	If File(m.cfilejson) Then
		responseType1 = Addbs(Sys(5) + Sys(2003)) + 'm1' + Alltrim(Str(goApp.Xopcion)) + '.json'
		oResponse = nfJsonRead( m.responseType1 )
		If Vartype(m.oResponse) = 'O' Then
			For Each oRow In  oResponse.Array
				Insert Into b_menus1 From Name oRow
			Endfor
			Select * From b_menus1  Where menu_tipo = np2 Into Cursor (Ccursor)
		Else
			goApp.datosmenus1 = ""
			This.Cmensaje = 'Consultando...'
			Return 0
		Endif
	Else
		goApp.datosmenus1 = ""
		This.Cmensaje = 'Consultando...'
		Return 0
	Endif
	Select (Ccursor)
	Return 1
	Endfunc
	Function consultadata2(N, ct, nidus, dFecha, Ccursor)
	Df = Cfechas(dFecha)
	Text To lC Noshow Textmerge
	  SELECT a.Menu_idme AS iKey,a.Menu_text AS Texto,a.menu_enla AS Parent,a.menu_clav AS clave,menu_tipo FROM fe_menus a 
	  INNER  JOIN fe_opt b ON b.opti_idme=a.menu_idme 
	  WHERE b.opti_idus=<<nidus>> AND b.opti_acti=1 AND '<<df>>' BETWEEN b.opti_feci AND b.opti_fecf
	  UNION ALL
	  SELECT Menu_idme AS iKey,Menu_text AS Texto,menu_enla AS Parent,menu_clav AS clave,menu_tipo FROM fe_menus WHERE  menu_enla='0_' ;
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1  Then
		Return 0
	Endif
	Select (Ccursor)
	nCount = Afields(cfieldsfemenu1)
	Select * From (Ccursor) Into Cursor a_menus1
	cdata = nfcursortojson(.T.)
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'm1' + Alltrim(Str(goApp.Xopcion)) + '.json'
	If File(m.rutajson) Then
		Delete File m.rutajson
	Endif
	Strtofile (cdata, rutajson)
	goApp.datosmenus1 = 'S'
	Return 1
	Endfunc
	Function consultadata0(Ccursor)
	Text To lC Noshow Textmerge
	SELECT Menu_idme AS iKey,Menu_text AS Texto,menu_enla AS Parent,menu_clav AS clave,menu_tipo FROM fe_menus 
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	nCount = Afields(cfieldsfemenu)
	Select * From (Ccursor) Into Cursor a_menus
	cdata = nfcursortojson(.T.)
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'm' + Alltrim(Str(goApp.Xopcion)) + '.json'
	If File(m.rutajson) Then
		Delete File m.rutajson
	Endif
	Strtofile (cdata, rutajson)
	goApp.datosmenus = 'S'
	Return 1
	Endfunc
Enddefine