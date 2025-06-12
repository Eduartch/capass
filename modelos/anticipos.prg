Define Class anticipo As OData Of 'd:\capass\database\data.prg'
	dFecha = Ctod("  /  /    ")
	cndoc = ""
	cmone = ""
	Ctipo = ""
	cdeta = ""
	nacta = 0
	NidAnticipo = 0
	Ncontrol = 0
	nidr = 0
	Montoc = 0
	idprov = 0
	cproveedor = ""
	nidanticipod = 0
	Function Consultar(nid, Ccursor)
	this.idprov=nid
	IF this.calcularsaldosanticipos()<1 then
	   RETURN 0
	ENDIF    
	Text To lC Noshow Textmerge
       SELECT fech,rdeu_mone as mone,acta,CAST(0 as signed) AS SW,iddeu,banc as deta,ndoc,tipo,deud_anti,deud_idant FROM fe_deu f
       inner join fe_rdeu g on g.rdeu_idrd=f.deud_idrd 
       where ncontrol=-1 and acti='A' and rdeu_Acti='A'  and rdeu_idpr=<<nid>> and acta>0 
	Endtext
	If This.EJECutaconsulta(lC, 'Anti') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function  ConsultarAnticipo(nid, cur)
	Text To lC Noshow
       SELECT acta FROM fe_deu f
       inner join fe_rdeu g on g.rdeu_idrd=f.deud_idrd 
       where ncontrol=-1 and acti='A' and rdeu_Acti='A'  and rdeu_idpr=?nid;
	Endtext
	If This.EJECutaconsulta(lC, cur) < 1 Then
		Return 0
	Endif
	Select (cur)
	Select * From (cur) Where Acta > 0 Into Cursor (cur)
	Select (cur)
	Go Top
	If Acta > 0 Then
		Return 1
	Else
		Return 0
	Endif
	Endfunc
	Function  CompensaDcto
	If This.CancelaDeudasAnticipo() < 1
*CancelaDeudas(dFech, dFech, nds, cndoc, 'P', cmone, cdeta, Ctipo, nidrd, goApp.nidusua, nctrol, '', Id(), fe_gene.dola) = 0 Then
		Return  0
	Endif
	Text To lC Noshow
         UPDATE fe_deu as f SET acta=f.acta-?nds WHERE iddeu=?nid
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Limpiar()
	dFecha = Ctod("  /  /    ")
	cndoc = ""
	cmone = ""
	Ctipo = ""
	cdeta = ""
	nacta = 0
	NidAnticipo = 0
	Ncontrol = 0
	nidr = 0
	Endfunc
	Function registrar
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	ur = This.IngresaCabeceraDeudasCctasAnticipo()
	If ur < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	This.nidr = ur
	This.NidAnticipo = ur
	nidrd = This.registradetalleAnticipo()
	If nidrd < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nmp = Iif(cmone = 'D', Round(This.nacta * fe_gene.dola, 2), This.nacta)
	If IngresaDatosLcajaEDeudas(This.dFecha, "", Rtrim(This.cproveedor) + ' ' + This.cndoc, fe_gene.gene_idpge, 0, nmp, 'S', fe_gene.dola, goApp.nidusua, nidrd, 0, 'E', This.cndoc) = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaCabeceraDeudasCctasAnticipo()
	lC = "FunRegistraDeudasCCtasanticipo"
	goApp.npara1 = 0
	goApp.npara2 = This.idprov
	goApp.npara3 = This.cmone
	goApp.npara4 = This.dFecha
	goApp.npara5 = This.nacta
	goApp.npara6 = goApp.nidusua
	goApp.npara7 = goApp.Tienda
	goApp.npara8 = Id()
	goApp.npara9 = fe_gene.idctact
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9)
	Endtext
	nidranti = This.EJECUTARf(lC, lp, "")
	If m.nidranti < 1 Then
		Return 0
	Endif
	Return m.nidranti
	Endfunc
	Function CancelaDeudasAnticipo()
	dFech = This.dFecha
	cndoc = This.cndoc
	cmone = This.cmone
	Ctipo = 'P'
	cdeta = This.cdeta
	nacta = This.nacta
	nctrol = This.Ncontrol
	nidrd = This.nidr
	nid = This.NidAnticipo
	nidusua = goApp.nidusua
	ndola = fe_gene.dola
	nds = This.nacta
	nidantd = This.nidanticipod
	lC = "FunIngresaPagosDeudasanticipo"
	Text To lp Noshow
	(?dfech,?dfech,?nds,?cndoc,'P',?cmone,?cdeta,?ctipo,?nidrd,?nidusua,?nctrol,'','',?ndola,?nid,?nidantd)
	Endtext
	nida = This.EJECUTARf(lC, lp, 'yyy')
	If m.nida < 1 Then
		Return 0
	Endif
	Return m.nida
	Endfunc
	Function compensaanticipos(objant)
	This.dFecha = Ctod(objant.dFecha)
	This.cproveedor = ""
	This.cdeta = objant.cdetalle
	This.cmone = objant.Cmoneda
	This.NidAnticipo = objant.Idanticipo
	This.cndoc = objant.dcto
	This.nidanticipod = objant.idanticipod
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	x = 1
	m.npago = 0
	Select pdtes
	Scan For Sw = 1
		This.Ncontrol = pdtes.Ncontrol
		This.nidr = pdtes.Idrd
		This.nacta = pdtes.Montoc
		If This.CancelaDeudasAnticipo() < 1 Then
			x = 0
			Exit
		Endif
		m.npago = m.npago + pdtes.Montoc
	Endscan
	If x = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Text To lC Noshow Textmerge
         UPDATE fe_deu as f SET acta=f.acta-<<npago>> WHERE iddeu=<<objant.idanticipod>> AND ncontrol=-1 AND acti='A'
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registradetalleAnticipo()
	dFech = This.dFecha
	cndoc = This.cndoc
	cmone = This.cmone
	Ctipo = 'P'
	cdeta = This.cdeta
	nacta = This.nacta
	nctrol = This.Ncontrol
	nidrd = This.nidr
	nid = This.NidAnticipo
	nidusua = goApp.nidusua
	ndola = fe_gene.dola
	nds = This.nacta
	nidantd = This.nidanticipod
	lC = "FunIngresadetalleanticipo"
	Text To lp Noshow
	(?dfech,?dfech,?nds,?cndoc,'P',?cmone,?cdeta,?ctipo,?nidrd,?nidusua,?nctrol,'','',?ndola,?nid,?nidantd)
	Endtext
	nida = This.EJECUTARf(lC, lp, 'yyy')
	If m.nida < 1 Then
		Return 0
	Endif
	Return m.nida
	Endfunc
	Function calcularsaldosanticipos()
	Ccursor = 'c' + Sys(2015)
	Text To lC Noshow Textmerge
	SELECT SUM(acta) as acta,deud_idant FROM fe_deu AS d   
	INNER JOIN fe_rdeu AS r ON r.rdeu_idrd=d.`deud_idrd`
    WHERE acti='A' AND deud_idant>0 AND ncontrol<>-1 AND rdeu_idpr=<<this.idprov>> GROUP BY deud_idant
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Sw = 1
	Select (Ccursor)
	Scan All
		Text To lC Noshow Textmerge
	        UPDATE fe_deu as d SET acta=d.deud_mant-<<acta>> where iddeu=<<deud_idant>> and ncontrol=-1
		Endtext
		If This.Ejecutarsql(lC) < 1 Then
			Sw = 0
			Exit
		Endif
	Endscan
	If Sw = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine


















