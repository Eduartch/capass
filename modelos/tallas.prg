Define Class tallas As odata Of "d:\capass\database\data.prg"
	Function Listar(Ccursor)
	lC = 'PROMUESTRATallas'
	lp = ""
	If This.EJECUTARP(lC, "", Ccursor) <1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
