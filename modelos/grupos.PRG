Define Class grupos As Odata Of "d:\capass\database\data.prg"
	nidgrupo=0
	descgrupo=""
	nidusua=0
	cmodo=""
	Function consultardata(np1,ccursor)
	Local lc, lp
	m.lc='PROMUESTRAGRUPOS'
	goapp.npara1 = m.np1
	TEXT To m.lp Noshow
     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, m.ccursor) < 1 Then
		Return 0
	Endif
	Select (ccursor)
	If regdvto(ccursor)<1 Then
		goapp.datosgrupos = ''
		Return 1
	Endif
	nCount = Afields(cfieldsfegrupo)
	Select * From (ccursor) Into Cursor g_grupo
	cdata = nfcursortojson(.T.)
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'g' + Alltrim(Str(goapp.xopcion)) + '.json'
	If File(m.rutajson) Then
		Delete File (m.rutajson)
	Endif
	Strtofile (cdata, rutajson)
	goapp.datosgrupos = 'S'
	Return 1
	Endfunc
	Function mostrargrupos(np1, ccursor)
	If Alltrim(goapp.datosgrupos) <> 'S' Then
		If This.consultardata(np1,ccursor) < 1 Then
			Return 0
		Endif
	Else
		Create Cursor a_grupos From Array cfieldsfegrupo
		cfilejson = Addbs(Sys(5) + Sys(2003)) + 'g' + Alltrim(Str(goapp.xopcion)) + '.json'
		conerror = 0
		If File(m.cfilejson) Then
			oResponse = nfJsonRead(m.cfilejson)
			If Vartype(m.oResponse) = 'O' Then
				For Each oRow In  oResponse.Array
					Insert Into a_grupos From Name oRow
				Endfor
				Select *  From  a_grupos  Into Cursor (ccursor)
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
     SELECT COUNT(*) as tgrupos FROM fe_cat WHERE idgrupo=<<np1>>  and line_acti='A' GROUP BY idgrupo
	ENDTEXT
	If This.EJECutaconsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Select (ccursor)
	tgr=Iif(Vartype(tmarcas)='C',Val(tgrupos),tgrupos)
	If tgrupos > 0 Then
		This.Cmensaje = "Se Han registrado " + Alltrim(Str(tgr, 12, 2))+ " Líneas con esta Grupo"
		Return 0
	Endif
	TEXT To lp Noshow Textmerge
           UPDATE fe grupo SET  grup_acti='I' WHERE idgrupo=<<np1>>
	ENDTEXT
	If This.Ejecutarsql(lp) < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'Desactivado Ok'
	Return 1
	Endfunc
	Function Crear()
	oser=Newobject("servicio","d:\capass\services\service.prg")
	m.rpta=oser.Inicializar(This,'grupos')
	If m.rpta<1 Then
		This.Cmensaje=oser.Cmensaje
		Return 0
	Endif
	oser=Null
	goapp.npara1=This.descgrupo
	goapp.npara2=This.nidusua
	goapp.npara3=Id()
	lc="FuncreaGrupo"
	TEXT TO lp NOSHOW
	(?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	nid=This.ejecutarf(lc,lp,'xf')
	If m.nid<1 Then
		Return 0
	Endif
	Return m.nid
	Endfunc
	Function actualizar()
	oser=Newobject("servicio","d:\capass\services\service.prg")
	m.rpta=oser.Inicializar(This,'grupos')
	If m.rpta<1 Then
		This.Cmensaje=oser.Cmensaje
		Return 0
	Endif
	oser=Null
	goapp.npara1=This.descgrupo
	goapp.npara2=This.nidgrupo
	TEXT TO lc NOSHOW
	  UPDATE fe_grupo SET desgrupo=?goapp.npara1 WHERE idgrupo=?goapp.npara2
	ENDTEXT
	If This.Ejecutarsql(lc)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarsiexiste()
	goapp.npara1=Alltrim(This.descgrupo)
	goapp.npara2=This.nidgrupo
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\SELECT idgrupo FROM fe_grupo WHERE TRIM(desgrupo)=?goapp.npara1 AND grup_acti<>'I'
	If This.nidgrupo>0 Then
	  \ AND idgrupo<>?goapp.npara2
	Endif
	 \ limit 1
	Set Textmerge Off
	Set Textmerge To
	ccursor='c_'+Sys(2015)
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Select (ccursor)
	If idgrupo>0 Then
		This.Cmensaje=" Nombre Ya Registrado"
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
