Define Class unidsunat As OData Of 'd:\capass\database\data.prg'
	porCodigo = 0
	porNombre = 0
	Function Listar(Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
     \Select  unid_codu As CodigoUnidad,unid_nome As Descripcion From fe_unidades Where
	If This.porCodigo = 1 Then
     \unid_codu Like '<<cb>>'
	Else
	 \ unid_nome Like '<<cb>>'
	Endif
     \Order By unid_nome,unid_codu
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine