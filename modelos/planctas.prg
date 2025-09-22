Define Class planctas As OData Of 'd:\capass\database\data.prg'
	Function MuestraPlanCuentasx(np1, ccursor)
	If Alltrim(goApp.datosplanctas) <> 'S' Then
		If This.consultardata(np1,Ccursor) < 1 Then
			Return 0
		Endif
	Else
		Create Cursor l_planctas From Array cfieldsfeplan
		cfilejson = Addbs(Sys(5) + Sys(2003)) + 'l' + Alltrim(Str(goApp.xopcion)) + '.json'
		conerror = 0
		If File(m.cfilejson) Then
			oResponse = nfJsonRead( m.cfilejson )
			If Vartype(m.oResponse) = 'O' Then
				For Each oRow In  oResponse.Array
					Insert Into l_planctas From Name oRow
				Endfor
				Select * From l_planctas Into Cursor (Ccursor)
			Else
				If This.consultardata(np1,Ccursor) < 1 Then
					conerror = 1
				Endif
			Endif
		Else
			If This.consultardata(np1,Ccursor) < 1 Then
				conerror = 1
			Endif
		Endif
		If conerror = 1 Then
			Return 0
		Endif
	Endif
	Return 1
	ENDFUNC
	FUNCTION consultarData(np1,ccursor)
	lC = "PROMUESTRAPLANCUENTAS"
	goApp.npara1 = np1
	goApp.npara2 = Val(goApp.Año)
	Text To lp Noshow
       (?goapp.npara1,?goapp.npara2)
	Endtext
	If This.EJECUTARP(lC, lp, ccursor) < 1 Then
		Return 0
	ENDIF
	Select (Ccursor)
	nCount = Afields(cfieldsfeplan)
	Select * From (Ccursor) Into Cursor l_planctas
	cdata = nfcursortojson(.T.)
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'l' + Alltrim(Str(goApp.xopcion)) + '.json'
	If File(m.rutajson) Then
		Delete File m.rutajson
	Endif
	Strtofile (cdata, rutajson)
	goApp.datosplanctas = 'S'
	Return 1
	Endfunc
	Function listarctasrcompras()
	If !Pemstatus(goApp, 'ctasmp', 5 ) Then
		AddProperty(goApp, 'ctasmp', '')
	Endif
	If goApp.Ctasmp = 'S' Then
		Text To lC Noshow Textmerge
         SELECT ncta,idctacv AS idcta  FROM fe_gene  AS g INNER JOIN fe_plan AS p ON p.idcta=g.idctacv  WHERE idgene=1
		 UNION ALL
		 SELECT ncta,gene_ctamp AS idcta FROM fe_gene AS g INNER JOIN fe_plan AS p ON p.idcta=g.gene_ctamp   WHERE idgene=1
		Endtext
	Else
		Text To lC Noshow Textmerge
         SELECT ncta,idctacv AS idcta  FROM fe_gene  AS g INNER JOIN fe_plan AS p ON p.idcta=g.idctacv  WHERE idgene=1
		Endtext
	Endif
	If EJECutaconsulta(lC, 'ctascompras') < 1 Then
		Return  0
	Endif
	Return  1
	Endfunc
	Function MuestraPlanCuentas(np1, cur)
	cb = '%' + Alltrim(np1) + '%'
	Text To lC Noshow Textmerge
      SELECT ncta,idcta,nomb,cdestinod,cdestinoh,tipocta,plan_oper FROM fe_plan WHERE ncta LIKE '<<cb>>'  AND plan_acti='A'  ORDER BY ncta;
	Endtext
	If This.EJECutaconsulta(lC, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraPlanCuentasz(np1, np2, cur)
	lC = "PROMUESTRACUENTASx"
	goApp.npara1 = np1
	goApp.npara2 = np2
	Text To lp Noshow
       (?goapp.npara1,?goapp.npara2)
	Endtext
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarcuentasseleccionadas(cb, Ccursor)
	Text To lC Noshow Textmerge
	      SELECT ncta,idcta,nomb,cdestinod,cdestinoh,tipocta,plan_oper
	      FROM fe_plan WHERE LEFT(ncta,2)='<<cb>>'  AND plan_acti='A'  ORDER BY ncta; 
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function carganombrectasgenerales()
	Ccursor = 'c_' + Sys(2015)
	If !Pemstatus(_Screen, 'nctatavtas', 5) Then
			AddProperty(_Screen, 'nctatavtas', '')
	Endif
	Text To lC Noshow
	  SELECT idctat,fe_plan.ncta FROM fe_gene LEFT JOIN fe_plan ON fe_plan.idcta=fe_gene.`idctat` WHERE idgene=1 LIMIT 1
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	_Screen.nctatavtas= ncta
	Return 1
	Endfunc
Enddefine








