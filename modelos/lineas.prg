Define Class lineas As Odata Of "d:\capass\database\data.prg"
	nidcat=0
	desclinea=""
	Function consultardata(np1,np2,ccursor)
	Local lc, lp
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	m.lc		 = 'PROMUESTRALINEAS'
	goapp.npara1 = m.np1
	goapp.npara2 = m.np2
	TEXT To m.lp Noshow
     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, m.ccursor) < 1 Then
		Return 0
	Endif
	Select (ccursor)
	If regdvto(ccursor)<1 Then
		goapp.datoslineas = ''
		Return 1
	Endif
	nCount = Afields(cfieldsfelinea)
	Select * From (ccursor) Into Cursor a_lineas
	cdata = nfcursortojson(.T.)
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'lna' + Alltrim(Str(goapp.xopcion)) + '.json'
	If File(m.rutajson) Then
		Delete File (m.rutajson)
	Endif
	Strtofile (cdata, rutajson)
	goapp.datoslineas = 'S'
	Return 1
	Endfunc
	Function mostrarlineas(np1, np2, ccursor)
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	If Alltrim(goapp.datoslineas) <> 'S' Then
		If This.consultardata(np1,np2,ccursor) < 1 Then
			Return 0
		Endif
	Else
*!*			wait WINDOW 'hola01'
*!*			wait WINDOW VARTYPE(cfieldsfelinea)
		Create Cursor a_lineas From Array cfieldsfelinea
	*	wait WINDOW 'hola02'
		cfilejson = Addbs(Sys(5) + Sys(2003)) + 'lna' + Alltrim(Str(goapp.xopcion)) + '.json'
	*	wait WINDOW 'hola03'
		conerror = 0
		If File(m.cfilejson) Then
			oResponse = nfJsonRead(m.cfilejson)
			If Vartype(m.oResponse) = 'O' Then
				For Each oRow In  oResponse.Array
					Insert Into a_lineas From Name oRow
				Endfor
				Select * From  a_lineas  Into Cursor (ccursor)
			Else
				If This.consultardata(np1,np2,ccursor) < 1 Then
					conerror = 1
				Endif
			Endif
		Else
			If This.consultardata(np1,np2,ccursor) < 1 Then
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
	ccursor = 'c_' + Sys(2015)
	TEXT To lC Noshow Textmerge
     SELECT COUNT(*) as Tlineas FROM fe_art WHERE idcat=<<np1>> and prod_acti='A' GROUP BY idcat;
	ENDTEXT
	If This.EJECutaconsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Select (ccursor)
	tot=Iif(Vartype(tmarcas)='C',Val(tlineas),tlineas)
	If tot > 0 Then
		This.Cmensaje = "Se Han registrado " + Alltrim(Str(tot, 12, 2))+ " Productos con esta Linea"
		Return 0
	Endif
	TEXT To lp Noshow Textmerge
           UPDATE fe cat SET  line_acti='I' WHERE idcat=<<np1>>
	ENDTEXT
	If This.Ejecutarsql(lp) < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'Desactivado Ok'
	Return 1
	Endfunc
	Function buscasiestaregistrado(cb)
	ccursor='c_'+Sys(2015)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select idcat  From fe_cat Where Trim(dcat)='<<ALLTRIM(cb)>>' And line_acti<>'I'
	If This.nidcat>0 Then
       \ and idcat<><<this.nidcat>>
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc,ccursor)<1 Then
		Return  0
	Endif
	Select (ccursor)
	If idcat>0 Then
		This.Cmensaje="Nombre de Línea  Ya existe"
		Return 0
	Endif
	Return 1
Enddefine
