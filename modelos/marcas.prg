Define Class marcas As Odata Of "d:\capass\database\data.prg"
	nidmar=0
	descmar=""
	Function consultardata(np1,ccursor)
	Local lc, lp
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	m.lc		 = 'PROMUESTRAMARCAS'
	goapp.npara1 = m.np1
	TEXT To m.lp Noshow
     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, m.ccursor) < 1 Then
		Return 0
	Endif
	Select (ccursor)
	If regdvto(ccursor)<1 Then
		goapp.datosmarcas = ''
		Return 1
	Endif
	nCount = Afields(cfieldsfemarca)
	Select * From (ccursor) Into Cursor a_marcas
	cdata = nfcursortojson(.T.)
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'mca' + Alltrim(Str(goapp.xopcion)) + '.json'
	If File(m.rutajson) Then
		Delete File (m.rutajson)
	Endif
	Strtofile (cdata, rutajson)
	goapp.datosmarcas = 'S'
	Return 1
	Endfunc
	Function mostrarmarcas(np1,ccursor)
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	If Alltrim(goapp.datosmarcas) <> 'S' Then
		If This.consultardata(np1,ccursor) < 1 Then
			Return 0
		Endif
	Else
		Create Cursor a_marcas From Array cfieldsfemarca
		cfilejson = Addbs(Sys(5) + Sys(2003)) + 'mca' + Alltrim(Str(goapp.xopcion)) + '.json'
		conerror = 0
		If File(m.cfilejson) Then
			oResponse = nfJsonRead(m.cfilejson)
			If Vartype(m.oResponse) = 'O' Then
				For Each oRow In  oResponse.Array
					Insert Into a_marcas From Name oRow
				Endfor
				Select *  From  a_marcas  Into Cursor (ccursor)
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
	Function Desactiva(np1)
	ccursor = 'c_' + Sys(2015)
	TEXT To lC Noshow Textmerge
     SELECT COUNT(*) as Tmarcas FROM fe_art WHERE idmar=<<np1>> and prod_acti='A' GROUP BY idmar
	ENDTEXT
	If This.EJECutaconsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Select (ccursor)
	tmar=Iif(Vartype(tmarcas)='C',Val(tmarcas),tmarcas)
	If tmar > 0 Then
		This.Cmensaje = "Se Han registrado " + Alltrim(Str(m.tmar, 12, 2))+ " Productos con esta Marca"
		Return 0
	Endif
	TEXT To lp Noshow Textmerge
       UPDATE fe_mar SET marc_acti='I' WHERE idmar=<<np1>>
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
	\Select idmar  From fe_mar Where Trim(dmar)='<<ALLTRIM(cb)>>' And marc_acti<>'I'
	If This.nidmar>0 Then
       \ and idmar<><<this.nidmar>>
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc,ccursor)<1 Then
		Return  0
	Endif
	Select (ccursor)
	If idmar>0 Then
		This.Cmensaje="Nombre de Marca  Ya existe"
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
