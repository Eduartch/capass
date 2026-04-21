Define Class Incidencia As ODATA Of 'd:\capass\database\data.prg'
	idusua = 0
	idusuaa = 0
	idauto = 0
	idautop = 0
	cdetalle = ""
	Procedure GrabaIncidencia()
	lc = 'ProGrabaIncidencia'
	cur = ""
	goapp.npara1 = This.idusua
	goapp.npara2 = This.idusuaa
	goapp.npara3 = This.idautop
	goapp.npara4 = This.idauto
	goapp.npara5 = This.cdetalle
	Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
	Endtext
	If This.EJECUTARP(lc, lp, cur) < 1 Then
		Return 0
	Endif
	Return  1
	Endproc
	Procedure MostrarIncidencia(dfi, dff, cur)
	lc = 'ProMuestraIncidencia'
	goapp.npara1 = dfi
	goapp.npara2 = dff
	Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2)
	Endtext
	If  This.EJECUTARP(lc, lp, cur) < 1Then
		Return 0
	Endif
	Return  1
	Endproc
	Procedure Limpiar()
	idusua = 0
	idusuaa = 0
	idauto = 0
	idautop = 0
	cdetalle = ""
	Endproc
Enddefine
***************************************

