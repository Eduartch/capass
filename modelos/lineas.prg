Define Class lineas As Odata Of "d:\capass\database\data.prg"
    nidcat=0
    desclinea=""
	Function mostrarlineas(np1, np2, ccursor)
	Local lc, lp
	IF this.idsesion>0 then
	   SET DATASESSION TO this.idsesion
	ENDIF    
	m.lc		 = 'PROMUESTRALINEAS'
	goapp.npara1 = m.np1
	goapp.npara2 = m.np2
	Text To m.lp Noshow
     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, m.ccursor) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	ENDFUNC
	Function Desactiva(np1)
	ccursor = 'c_' + Sys(2015)
	TEXT To lC Noshow Textmerge
     SELECT COUNT(*) as Tlineas FROM fe_art WHERE idcat=<<np1>> and prod_acti='A' GROUP BY idcat;
	ENDTEXT
	If This.EJECutaconsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Select (ccursor)
	tot=IIF(VARTYPE(tmarcas)='C',VAL(tlineas),tlineas)
	If tot > 0 Then
		This.Cmensaje = "Se Han registrado " + Alltrim(STR(tot, 12, 2))+ " Productos con esta Linea"
		Return 0
	Endif
	TEXT To lp Noshow Textmerge
           UPDATE fe cat SET  line_acti='I' WHERE idcat=<<np1>>
	ENDTEXT
	If This.Ejecutarsql(lp) < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'Desactivado Ok'
	Return 1
	Endfunc
Enddefine