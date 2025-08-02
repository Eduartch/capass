Define Class grupos As Odata Of "d:\capass\database\data.prg"
	nidgrupo=0
	descgrupo=""
	Function mostrargrupos(np1, ccursor)
	Local lc, lp
	m.lc='PROMUESTRAGRUPOS'
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
     SELECT COUNT(*) as tgrupos FROM fe_cat WHERE idgrupo=<<np1>>  and line_acti='A' GROUP BY idgrupo
	ENDTEXT
	If This.EJECutaconsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Select (ccursor)
	tgr=Iif(Vartype(tmarcas)='C',Val(tgrupos),tgrupos)
	If tgrupos > 0 Then
		This.Cmensaje = "Se Han registrado " + Alltrim(Str(tgr, 12, 2))+ " Líneas con esta Grupo"
		Return 0
	Endif
	TEXT To lp Noshow Textmerge
           UPDATE fe grupo SET  grup_acti='I' WHERE idgrupo=<<np1>>
	ENDTEXT
	If This.Ejecutarsql(lp) < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'Desactivado Ok'
	Return 1
	Endfunc
Enddefine
