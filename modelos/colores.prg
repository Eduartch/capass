Define Class colores As odata OF "d:\capass\database\data.prg"
    nidcolor=0
    cnombre=""
	Function Listar(np1, np2, Ccursor)
	lC = 'PROMUESTRAColoresx'
	goApp.npara1 = np1
	goApp.npara2 = np2
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(lC, lp, Ccursor) <1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
