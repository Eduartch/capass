Define Class Empleado As odata Of "d:\capass\database\data.prg"
*np1,np2,np3,np4,np5,np6,np7,np8
	cnombre=""
	cfono=""
	nsueldo=0
	nidus=0
	cidpc=""
	crefe=""
	Function CreaEmpleado()
	lc='FUNCREAEmpleado'
	cur="xt"
	goapp.npara1=This.cnombre
	goapp.npara2=This.cfono
	goapp.npara3=This.nsueldo
	goapp.npara4=This.cidpc
	goapp.npara5=This.nidus
	goapp.npara6=This.crefe
	goapp.npara7=np7
	goapp.npara8=np8
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
	ENDTEXT
	nid=This.ejecutarf(lc,lp,cur)
	If nid<1 Then
		Return 0
	Endif
	Return m.nid
	Endfunc
	Function consultar(np1,ccursor)
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	If Alltrim(goapp.datosempleados) <> 'S' Then
		If This.consultardata(np1,ccursor) < 1 Then
			Return 0
		Endif
	Else
		Create Cursor a_empleados From Array cfieldsfeempleado
		cfilejson = Addbs(Sys(5) + Sys(2003)) + 'empl' + Alltrim(Str(goapp.xopcion)) + '.json'
		conerror = 0
		If File(m.cfilejson) Then
			oResponse = nfJsonRead(m.cfilejson)
			If Vartype(m.oResponse) = 'O' Then
				For Each oRow In  oResponse.Array
					Insert Into a_empleados From Name oRow
				Endfor
				Select * From a_empleados  Into Cursor (ccursor)
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
	Function consultardata(np1,ccursor)
		If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	goapp.npara1=np1
	lc='ProMuestraEmpleados'
	TEXT to lp noshow
     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	ENDIF
	select (ccursor)
	If regdvto(ccursor)<1 Then
		goapp.datosempleados = ''
		Return 1
	Endif
	nCount = Afields(cfieldsfeempleado)
	Select * From (ccursor) Into Cursor a_empleados
	cdata = nfcursortojson(.T.)
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'empl' + Alltrim(Str(goapp.xopcion)) + '.json'
	If File(m.rutajson) Then
		Delete File (m.rutajson)
	Endif
	Strtofile (cdata, rutajson)
	goapp.datosempleados = 'S'
	Return 1
	Endfunc
Enddefine
