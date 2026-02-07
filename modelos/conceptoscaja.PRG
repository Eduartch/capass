Define Class conceptoscaja As OData Of "d:\capass\database\data.prg"
	Function Listar(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lC Noshow Textmerge
	     SELECT  idcon,nomb,tipo,tdoc FROM fe_con WHERE conc_acti='A' ORDER BY nomb
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine


