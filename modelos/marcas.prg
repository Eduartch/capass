Define Class marcas As Odata Of "d:\capass\database\data.prg"
    nidmar=0
    descmar=""
	Function mostrarmarcas(np1,ccursor)
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
	Else
		Return 1
	Endif
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
	tmar=IIF(VARTYPE(tmarcas)='C',VAL(tmarcas),tmarcas)
	If tmar > 0 Then
		This.Cmensaje = "Se Han registrado " + Alltrim(Str(m.tmar, 12, 2))+ " Productos con esta Marca"
		Return 0
	ENDIF
	TEXT To lp Noshow Textmerge
       UPDATE fe_mar SET marc_acti='I' WHERE idmar=<<np1>>
	ENDTEXT
	If This.Ejecutarsql(lp) < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'Desactivado Ok'
	Return 1
	Endfunc
Enddefine
