Define Class planctas As OData Of 'd:\capass\database\data.prg'
	Function MuestraPlanCuentasx(np1, cur)
	lC = "PROMUESTRAPLANCUENTAS"
	goApp.npara1 = np1
	goApp.npara2 = Val(goApp.a�o)
	Text To lp Noshow
       (?goapp.npara1,?goapp.npara2)
	Endtext
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
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
Enddefine






