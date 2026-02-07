Define Class productosgrifos As producto  Of 'd:\capass\modelos\productos.prg'
	Function MuestraProductosDescCod(np1, np2, np3, np4, ccursor)
	Local lc, lp
	m.lc		 = 'PROMUESTRAPRODUCTOS1'
	goapp.npara1 = m.np1
	If goapp.Listapreciosportienda = 'S' Then
		goapp.npara2 = goapp.tienda
	Else
		goapp.npara2 = m.np2
	Endif
	goapp.npara3 = m.np3
	goapp.npara4 = m.np4
	Text To m.lp Noshow
        (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	Endtext
	If This.EJECUTARP(m.lc, m.lp, m.ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	
Enddefine

