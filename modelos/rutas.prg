Define Class ruta As odata Of "d:\capass\database\data.prg"
	cnombre = ""
	nidruta = 0
	cdetalle = ""
	cmodo = ""
	Function crear()
	This.cmodo = 'N'
	oser = Newobject("servicio", "d:\capass\services\service.prg")
	m.rpta = oser.Inicializar(This, 'rutas')
	If m.rpta < 1 Then
		This.Cmensaje = oser.Cmensaje
		Return 0
	Endif
	oser = Null
	lc = 'FunCreaRutas'
	npara1 = This.cnombre
	npara2 = This.cdetalle
	npara3 = goapp.nidusua
	Text To lp Noshow
	(?npara1,?npara2,?npara3)
	Endtext
	m.nidr = This.ejecutarf(lc, lp)
	If m.nidr < 1 Then
		Return 0
	Endif
	Return m.nidr
	Endfunc
	Function editar()
	This.cmodo = 'M'
	oser = Newobject("servicio", "d:\capass\services\service.prg")
	m.rpta = oser.Inicializar(This, 'rutas')
	If m.rpta < 1 Then
		This.Cmensaje = oser.Cmensaje
		Return 0
	Endif
	oser = Null
	lc = 'ProActualizaRutas'
	npara1 = This.cnombre
	npara2 = This.cdetalle
	npara3 = goapp.nidusua
	npara4 = This.nidruta
	Text To lp Noshow
	(?npara1,?npara2,?npara3,?npara4)
	Endtext
	If This.ejecutarp(ls, lp) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function desactivar(nidruta)
	lc = 'ProDesactivaRutas'
	npara1 = m.nidruta
	noara2 = goapp.nidusua
	Text To lp Noshow
    (?npara1,?npara2)
	Endtext
	If This.ejecutarp(lc, lp) < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'Ok'
	Return 1
	Endfunc
	Function buscarsiexiste()
	If Len(Alltrim(This.cnombre)) = 0 Then
		This.Cmensaje = 'ingrese Nombre'
		Return 0
	Endif
	cnomb = Alltrim(This.cnombre)
	ccursor = 'c_' + Sys(2015)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select ruta_idru As idruta From fe_rutas Where trim(ruta_nomb) = '<<cnomb>>' And ruta_acti = 'A'
	If This.nidruta > 0 Then
        \ And ruta_idru<><<This.nidruta>>
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Select (ccursor)
	If idruta > 0 Then
		This.cmmensaje = 'Nombre de RUTA ya creada'
		Return 0
	Endif
	Return 1
	Endfunc
	Function listar(np1, ccursor)
	lc = 'ProMuestraRutas'
	npara1 = np1
	Text To lp Noshow
	(?npara1) 
	Endtext
	If This.ejecutarp(lc, lp, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine