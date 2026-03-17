Define Class modelos As odata Of "d:\capass\database\data.prg"
	Function Listar(np1, Ccursor)
	lC = 'PROMUESTRAmodelosx'
	goApp.npara1 = np1
	TEXT To lp Noshow
     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(lC, lp, Ccursor) <1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
