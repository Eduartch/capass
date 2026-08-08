Define Class planilla As Odata Of "d:\capass\database\data.prg"
	nimpoe=0
	nactae=0
	dFecha=DATE()
	ctipo=""
	nidus=0
	nidcaja=0
	nidem=0
	cdeta=""
	Function IngresarPagosActa()
	lc="FUNINGRESAPAGOSEMPLEADOS"
	np1=This.nimpoe
	np2=This.nactae
	np3=This.dFecha
	np4=This.ctipo
	np5=This.nidus
	np6=This.nidcaja
	np7=This.nidem
	np8=This.cdeta
	TEXT TO lp NOSHOW 
    (?np1,?np2,?np3,?np4,?np5,?np6,?np7,?np8)
	ENDTEXT
	nid=This.ejecutarf(lc,lp,'pla')
	If m.nid<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
