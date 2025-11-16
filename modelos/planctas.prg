Define Class planctas As OData Of 'd:\capass\database\data.prg'
	Ctodas = ""
	Function MuestraPlanCuentasx(np1, Ccursor)
	If Alltrim(goApp.datosplanctas) <> 'S' Then
		If This.consultardata(np1, Ccursor) < 1 Then
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
				cvalor='%'+Alltrim(np1)+'%'
				Select * From l_planctas Where ncta Like cvalor Into Cursor (Ccursor)
			Else
				If This.consultardata(np1, Ccursor) < 1 Then
					conerror = 1
				Endif
			Endif
		Else
			If This.consultardata(np1, Ccursor) < 1 Then
				conerror = 1
			Endif
		Endif
		If conerror = 1 Then
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function consultardata(np1, Ccursor)
	lC = "PROMUESTRAPLANCUENTAS"
	goApp.npara1 = np1
	goApp.npara2 = Val(goApp.Año)
	TEXT To lp Noshow
       (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
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
	Function listarctasrcompras(Nivel, ccta, Ccursor)
	Do Case
	Case m.Nivel = 1
		If Alltrim(goApp.datosctascv) <> 'S' Then
			If This.consultardataplanctascompras(Nivel, ccta, Ccursor) < 1 Then
				Return 0
			Endif
		Else
			Create Cursor l_ctascomprascv From Array cfieldsfectascv
			cfilejson = Addbs(Sys(5) + Sys(2003)) + 'ctascv' + Alltrim(Str(goApp.xopcion)) + '.json'
			conerror = 0
			If File(m.cfilejson) Then
				oResponse = nfJsonRead( m.cfilejson )
				If Vartype(m.oResponse) = 'O' Then
					For Each oRow In  oResponse.Array
						Insert Into l_ctascomprascv From Name oRow
					Endfor
					Select * From l_ctascomprascv Into Cursor (Ccursor)
				Else
					If This.consultardataplanctascompras(Nivel, ccta, Ccursor) < 1 Then
						conerror = 1
					Endif
				Endif
			Else
				If This.consultardataplanctascompras(Nivel, ccta, Ccursor) < 1 Then
					conerror = 1
				Endif
			Endif
			If conerror = 1 Then
				Return 0
			Endif
		Endif
	Case m.Nivel = 2
		If Alltrim(goApp.datosctasci) <> 'S' Then
			If This.consultardataplanctascompras(Nivel, ccta, Ccursor) < 1 Then
				Return 0
			Endif
		Else
			Create Cursor l_ctascomprasci From Array cfieldsfectasci
			cfilejson = Addbs(Sys(5) + Sys(2003)) + 'ctasci' + Alltrim(Str(goApp.xopcion)) + '.json'
			conerror = 0
			If File(m.cfilejson) Then
				oResponse = nfJsonRead( m.cfilejson )
				If Vartype(m.oResponse) = 'O' Then
					For Each oRow In  oResponse.Array
						Insert Into l_ctascomprasci From Name oRow
					Endfor
					Select * From l_ctascomprasci Into Cursor (Ccursor)
				Else
					If This.consultardataplanctascompras(Nivel, ccta, Ccursor) < 1 Then
						conerror = 1
					Endif
				Endif
			Else
				If This.consultardataplanctascompras(Nivel, ccta, Ccursor) < 1 Then
					conerror = 1
				Endif
			Endif
			If conerror = 1 Then
				Return 0
			Endif
		Endif
	Case m.Nivel = 3
		If Alltrim(goApp.datosctasct) <> 'S' Then
			If This.consultardataplanctascompras(Nivel, ccta, Ccursor) < 1 Then
				Return 0
			Endif
		Else
			Create Cursor l_ctascomprasct From Array cfieldsfectasct
			cfilejson = Addbs(Sys(5) + Sys(2003)) + 'ctasct' + Alltrim(Str(goApp.xopcion)) + '.json'
			conerror = 0
			If File(m.cfilejson) Then
				oResponse = nfJsonRead( m.cfilejson )
				If Vartype(m.oResponse) = 'O' Then
					For Each oRow In  oResponse.Array
						Insert Into l_ctascomprasct From Name oRow
					Endfor
					Select * From l_ctascomprasct Into Cursor (Ccursor)
				Else
					If This.consultardataplanctascompras(Nivel, ccta, Ccursor) < 1 Then
						conerror = 1
					Endif
				Endif
			Else
				If This.consultardataplanctascompras(Nivel, ccta, Ccursor) < 1 Then
					conerror = 1
				Endif
			Endif
			If conerror = 1 Then
				Return 0
			Endif
		Endif
	Endcase
	Return 1
	Endfunc
	Function MuestraPlanCuentas(np1, cur)
	If This.MuestraPlanCuentasx(np1, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraPlanCuentasz(np1, np2, cur)
	lC = "PROMUESTRACUENTASx"
	goApp.npara1 = np1
	goApp.npara2 = np2
	TEXT To lp Noshow
       (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarcuentasseleccionadas(cb, Ccursor)
	TEXT To lC Noshow Textmerge
	      SELECT ncta,idcta,nomb,cdestinod,cdestinoh,tipocta,plan_oper
	      FROM fe_plan WHERE LEFT(ncta,2)='<<cb>>'  AND plan_acti='A'  ORDER BY ncta;
	ENDTEXT
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
	TEXT To lC Noshow
	  SELECT idctat,fe_plan.ncta FROM fe_gene LEFT JOIN fe_plan ON fe_plan.idcta=fe_gene.`idctat` WHERE idgene=1 LIMIT 1
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	_Screen.nctatavtas = ncta
	Return 1
	Endfunc
	Function consultardataplanctascompras(Nivel, ccta, Ccursor)
	If !Pemstatus(goApp, 'ctasmp', 5 ) Then
		AddProperty(goApp, 'ctasmp', '')
	Endif
	If goApp.Ctasmp = 'S'  And m.Nivel = 1  Then
		TEXT To lC Noshow Textmerge
         SELECT ncta,idctacv AS idcta  FROM fe_gene  AS g
         INNER JOIN fe_plan AS p ON p.idcta=g.idctacv  WHERE idgene=1
		 UNION ALL
		 SELECT ncta,gene_ctamp AS idcta FROM fe_gene AS g
		 INNER JOIN fe_plan AS p ON p.idcta=g.gene_ctamp   WHERE idgene=1
		ENDTEXT
	Else
		Do Case
		Case m.Nivel = 1
			If This.Ctodas = 'S' Then
				TEXT To lC Noshow Textmerge
				 SELECT ncta,idcta FROM fe_plan AS p WHERE LEFT(ncta,2)='<<ccta>>' ORDER BY ncta
				ENDTEXT
			Else
				TEXT To lC Noshow Textmerge
				 SELECT ncta,idctacv AS idcta FROM fe_gene  AS g
		         INNER JOIN fe_plan AS p ON p.idcta=g.idctacv
		         WHERE idgene=1 AND LEFT(ncta,2)='<<ccta>>'
				ENDTEXT
			Endif
		Case m.Nivel = 2
			TEXT To lC Noshow Textmerge
	         SELECT ncta,idctaci AS idcta  FROM fe_gene  AS g
	         INNER JOIN fe_plan AS p ON p.idcta=g.idctaci
	         WHERE idgene=1 AND LEFT(ncta,2)='<<ccta>>'
			ENDTEXT
		Case m.Nivel = 3
			TEXT To lC Noshow Textmerge
	         SELECT ncta,idctact AS idcta  FROM fe_gene  AS g
	         INNER JOIN fe_plan AS p ON p.idcta=g.idctact
	         WHERE idgene=1 AND LEFT(ncta,2)='<<ccta>>'
			ENDTEXT
		Endcase
	Endif
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return  0
	Endif
	Select (Ccursor)
	Do Case
	Case m.Nivel = 1
		nCount = Afields(cfieldsfectascv)
		Select * From (Ccursor) Into Cursor l_ctascomprascv
		cdata = nfcursortojson(.T.)
		rutajson = Addbs(Sys(5) + Sys(2003)) + 'ctascv' + Alltrim(Str(goApp.xopcion)) + '.json'
		If File(m.rutajson) Then
			Delete File m.rutajson
		Endif
		Strtofile (cdata, rutajson)
		goApp.datosctascv = 'S'
	Case m.Nivel = 2
		nCount = Afields(cfieldsfectasci)
		Select * From (Ccursor) Into Cursor l_ctascomprasci
		cdata = nfcursortojson(.T.)
		rutajson = Addbs(Sys(5) + Sys(2003)) + 'ctasci' + Alltrim(Str(goApp.xopcion)) + '.json'
		If File(m.rutajson) Then
			Delete File m.rutajson
		Endif
		Strtofile (cdata, rutajson)
		goApp.datosctasci = 'S'
	Case m.Nivel = 3
		nCount = Afields(cfieldsfectasct)
		Select * From (Ccursor) Into Cursor l_ctascomprasct
		cdata = nfcursortojson(.T.)
		rutajson = Addbs(Sys(5) + Sys(2003)) + 'ctasct' + Alltrim(Str(goApp.xopcion)) + '.json'
		If File(m.rutajson) Then
			Delete File m.rutajson
		Endif
		Strtofile (cdata, rutajson)
		goApp.datosctasct = 'S'
	Endcase
	Return  1
	Endfunc
	Function cambiarctacompras(idec,nidcta)
	TEXT TO lc noshow
       UPDATE fe_ectasc SET idcta=?nidcta WHERE idectas=?idec
	ENDTEXT
	If This.ejecutarsql(lC)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraSoloCuenta(ccta,opt,Ccursor)
	np1=ccta
	If opt=0 Then
		TEXT TO lc NOSHOW
          SELECT idcta,nomb,ncta,plan_ncta,cdestinod,cdestinoh,tipocta,plan_oper FROM fe_plan WHERE ncta=?np1 AND plan_acti='A' limit 1;
		ENDTEXT
	Else
		TEXT TO lc NOSHOW
          SELECT idcta,nomb,ncta,plan_ncta,cdestinod,cdestinoh,tipocta,plan_oper FROM fe_plan WHERE idcta=?np1 AND plan_acti='A' limit 1;
		ENDTEXT
	Endif
	If This.EJECutaconsulta(lC,Ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine






















