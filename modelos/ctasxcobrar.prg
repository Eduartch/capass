Define Class ctasporcobrar As OData Of 'd:\capass\database\data.prg'
	Tienda = 0
	ninic=0
	chkTIENDA = 0
	cformapago = ""
	chkformapago = 0
	nidclie = 0
	npago = 0
	ndola = 0
	Cmoneda = ""
	cndoc = ""
	Ctipo = ""
	dFech = Date()
	cdetalle = ""
	Fechavto = Date()
	tipodcto = ""
	Codv = 0
	nimpoo = 0
	nimpo = 0
	crefe = ""
	nidaval = 0
	Idauto = 0
	Cestado = ''
	Sintransaccion = ""
	concargocaja = ""
	idcajero = 0
	idzona = 0
	cmodo = ""
	Ncontrol = 0
	nidrc = 0
	NidAnticipo = 0
	nidanticipocr = 0
	cnrou = ""
	dfi = Date()
	dff = Date()
	tipopago = ""
	solocontable = ""
	nidproyecto=0
	Function Actualizardatos(idcreditos,objeto)
	TEXT To lC Noshow Textmerge
         UPDATE fe_cred SET ndoc='<<objeto.cdcto>>',tipo='<<objeto.ctipo>>',banc='<<objeto.cdeta>>',fevto='<<objeto.dfevto>>',fech='<<objeto.dfecha>>'  WHERE idcred=<<idcreditos>>
	ENDTEXT
	If This.Ejecutarsql(lC) < 1
		Return 0
	Endif
	This.cmensaje='Ok'
	Return 1
	Endfunc
	Function mostrarpendientesxcobrar(nidclie, Ccursor)
	TEXT To lC Noshow Textmerge
		SELECT `x`.`idclie`,		`x`.`razo`      AS `razo`,
		v.importe,		v.fevto,		`v`.`rcre_idrc` AS `rcre_idrc`,		`rr`.`rcre_fech` AS `fech`,		`rr`.`rcre_idau` AS `idauto`,
		rcre_codv AS idven,		ifnull(`vv`.`nomv`,'')  AS `nomv`,		 IFNULL(`cc`.`ndoc`,"") AS `docd`,		 IFNULL(`cc`.`tdoc`,'') AS `tdoc`,
		 a.`ndoc`,		`a`.`mone`      AS `mone`,		`a`.`banc`      AS `banc`,		`a`.`tipo`      AS `tipo`,		`a`.`dola`      AS `dola`,		`a`.`nrou`      AS `nrou`,
		`a`.`banco`     AS `banco`,		`a`.`idcred`    AS `idcred`,		a.fech AS fepd,
		v.ncontrol,a.estd,		a.ndoc,		v.rcre_idrc
		FROM (
		SELECT ncontrol,rcre_idrc,rcre_idcl,MAX(`c`.`fevto`) AS `fevto`,ROUND(SUM((`c`.`impo` - `c`.`acta`)),2) AS `importe` FROM
		fe_rcred AS r INNER JOIN fe_cred AS c ON c.`cred_idrc`=r.`rcre_idrc` WHERE r.`rcre_Acti`='A' AND c.`acti`='A' and r.rcre_idcl=<<nidclie>>
		GROUP BY `c`.`ncontrol`,r.rcre_idrc,r.rcre_idcl  HAVING (ROUND(SUM((`c`.`impo` - `c`.`acta`)),2) <> 0)) AS v
		INNER JOIN fe_clie AS `x` ON `x`.`idclie`=v.rcre_idcl
		INNER JOIN fe_rcred AS rr ON rr.`rcre_idrc`=v.rcre_idrc
		left JOIN fe_vend AS vv ON vv.`idven`=rr.`rcre_codv`
		LEFT JOIN  (SELECT tdoc,ndoc,idauto FROM fe_rcom WHERE idcliente=<<nidclie>> AND acti='A') AS cc
		ON cc.idauto=rr.`rcre_idau` INNER JOIN fe_cred AS a ON a.idcred=v.ncontrol
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultaranticipos(nid, Ccursor)
	This.nidclie = m.nid
	If This.calcularsaldosanticipos() < 1 Then
		Return 0
	Endif
	TEXT To lC Noshow Textmerge
       SELECT fech,'S' AS mone,CAST(acta as decimal(10,2)) As acta,CAST(0 AS SIGNED) AS SW,idcred,banc AS deta,ndoc,tipo,rcre_idrc,cred_anti,cred_idant FROM fe_cred f
       INNER JOIN fe_rcred AS g ON g.rcre_idrc=f.cred_idrc
       WHERE ncontrol=-1 AND acti='A' AND rcre_Acti='A'  AND rcre_idcl=<<nid>> and acta>0.1
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaCreditosNormal(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17)
	lC = 'FUNREGISTRACREDITOS'
	cur = "Xn"
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara9 = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	goApp.npara12 = np12
	goApp.npara13 = np13
	goApp.npara14 = np14
	goApp.npara15 = np15
	goApp.npara16 = np16
	goApp.npara17 = np17
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function estadodecuentaporcliente(nidclie, Cmoneda, Ccursor)
	TEXT To lC Noshow Textmerge
	    SELECT b.rcre_idcl,a.fech as fepd,a.fevto as fevd,a.ndoc,b.rcre_impc as impc,b.rcre_inic as inic,a.impo as impd,a.acta as actd,a.dola,
	    a.tipo,a.banc,ifnull(c.ndoc,'0000000000') as docd,a.mone as mond,a.estd,a.idcred as nr,b.rcre_idrc,
	    b.rcre_codv as codv,b.rcre_idau as idauto,ifnull(c.tdoc,'00') as refe,d.nomv,cred_idcb FROM fe_cred as a
	    inner join fe_rcred as b ON(b.rcre_idrc=a.cred_idrc)
	    left join fe_rcom as c ON(c.idauto=b.rcre_idau)
	    left join fe_vend as d ON(d.idven=b.rcre_codv)
	    WHERE b.rcre_idcl=<<nidclie>> AND a.mone='<<cmoneda>>'
	    and a.acti<>'I' and rcre_acti<>'I'  ORDER BY a.ncontrol,a.idcred,a.fech
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function estadodecuentaporcliente10(nidclie, Cmoneda, Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lC Noshow Textmerge
	    SELECT b.rcre_idcl,a.fech as fepd,a.fevto as fevd,a.ndoc,b.rcre_impc as impc,b.rcre_inic as inic,a.impo as impd,a.acta as actd,a.dola,
	    a.tipo,a.banc,ifnull(c.ndoc,'00000000000') as docd,a.mone as mond,a.estd,a.idcred as nr,b.rcre_idrc,
	    b.rcre_codv as codv,b.rcre_idau as idauto,ifnull(c.tdoc,'00') as refe,d.nomv,ifnull(w.ctas_ctas,'') as bancos,ifnull(w.cban_ndoc,'') as nban,
	    cred_idcb,ifnull(t.nomb,'') as tienda  FROM fe_cred as a
	    inner join fe_rcred as b ON(b.rcre_idrc=a.cred_idrc)
	    left join fe_rcom as c ON(c.idauto=b.rcre_idau)
	    inner join fe_vend as d ON(d.idven=b.rcre_codv)
	    left join fe_sucu as t on t.idalma=b.rcre_codt
	    left join (SELECT cban_nume,cban_ndoc,g.ctas_ctas,cban_idco FROM
        fe_cbancos f  inner join fe_ctasb g on g.ctas_idct=f.cban_idba where cban_acti='A')
        as w on w.cban_idco=a.cred_idcb
        WHERE b.rcre_idcl=<<nidclie>> AND a.mone='<<cmoneda>>'  and a.acti<>'I' and rcre_acti<>'I'  ORDER BY a.ncontrol,a.idcred,a.fech
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function vlineacredito(ccodc, nmonto, nlinea)
	Ccursor = 'c_'+Sys(2015)
	lC = "FUNVERIFICALINEACREDITO"
	goApp.npara1 = ccodc
	goApp.npara2 = nmonto
	goApp.npara3 = nlinea
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	Sw = This.EJECUTARf(lC, lp, Ccursor)
	If Sw < 0 Then
		Return 0
	Endif
	Select (Ccursor)
	If Sw = 0 Then
		This.cmensaje = 'Linea de Crédito NO Disponible'
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function verificasaldocliente(codc, nmonto)
	lC = 'PROCALCULARSALDOSCLIENTE'
	Ccursor = '_vsaldos'
	goApp.npara1 = codc
	TEXT To lp Noshow
	(?goapp.npara1)
	ENDTEXT
	If This.ejecutarp(lC, lp, (Ccursor)) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	nimporte=Iif(Isnull(impsoles),0,impsoles)
	If m.nimporte < 0 Then
		Anticipos = Abs(m.nimporte)
	Else
		Anticipos = m.nimporte
	Endif
	If nmonto > m.Anticipos Then
		This.cmensaje = 'Saldo NO Disponible :' + Alltrim(Str(m.Anticipos, 12, 2))
		Return 0
	Endif
	Return 1
	Endfunc
	Function listactasxcobrar(Df, Ccursor)
	If !Pemstatus(goApp, 'cdatos', 5)
		AddProperty(goApp, 'cdatos', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select c.nruc,c.razo As proveedor,c.idclie As codp,a.mone,If(a.mone='S',saldo,0) As tsoles,If(a.mone='D',saldo,0) As tdolar,
	\c.clie_idzo,ifnull(T.ndoc,a.ndoc) As ndoc,
	\ifnull(T.tdoc,'') As tdoc,ifnull(T.fech,a.fech) As fech,b.fech As fecha,ifnull(v.nomv,'') As vendedor,a.tipo,s.nomb As Tienda From
	\(Select a.Ncontrol,Min(fevto) As fech,Round(Sum(a.Impo-a.acta),2) As saldo
	\From fe_cred As a
	\INNER Join fe_rcred As xx  On xx.rcre_idrc=a.cred_idrc
	\Where a.fech<='<<df>>'  And  a.Acti<>'I' And xx.rcre_Acti<>'I'
	If This.chkformapago = 1 Then
     \And rcre_form='<<this.cformapago>>'
	Endif
	If This.chkTIENDA = 1 Then
	\ And rcre_codt=<<This.Tienda>>
	Endif
	\Group By a.Ncontrol Having saldo<>0) As b
	\	INNER Join fe_cred As a On a.idcred=b.Ncontrol
	\	INNER Join fe_rcred As r On r.rcre_idrc=a.cred_idrc
	\	INNER Join fe_clie As c On c.idclie=r.rcre_idcl
	\   Left Join fe_vend As v On v.idven=r.rcre_codv
	\   INNER Join fe_sucu As s On s.idalma=r.rcre_codt
	\	Left Join (Select Idauto,ndoc,tdoc,fech From fe_rcom Where Acti='A' And idcliente>0) As T On T.Idauto=r.rcre_idau
	If This.idzona > 0 Then
	   \ Where clie_idzo=<<This.idzona>>
	Endif
	\Order By proveedor
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function vtosxcliente(nidclie, Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To  Memvar lC Noshow Textmerge
	\Select `x`.`idclie`,`x`.`razo`,v.importe,v.fevto,`v`.`rcre_idrc` As `rcre_idrc`,`rr`.`rcre_fech` As `fech`,
	\`rr`.`rcre_idau` As `Idauto`,rcre_codv As idven,ifnull(`vv`.`nomv`,'') As nomv, ifnull(`cc`.`ndoc`,"") As `docd`, ifnull(`cc`.`tdoc`,'') As `tdoc`, a.`ndoc`,
	\`a`.`mone`      As `mone`,`a`.`banc` ,`a`.`tipo` ,`a`.`dola`,rr.rcre_impc,a.situa,
	\`a`.`nrou`      As `nrou`,`a`.`banco`     As `banco`,`a`.`idcred`    As `idcred`,a.fech As fepd,v.Ncontrol,a.estd,a.ndoc,
	\v.rcre_idrc,rr.rcre_form,a.Impo As impoo,s.nomb As Tienda
	\From (
	\Select Ncontrol,rcre_idrc,rcre_idcl,Max(`c`.`fevto`) As `fevto`,Round(Sum((`c`.`Impo` - `c`.`acta`)),2) As `importe` From
	\fe_rcred As r
	\INNER Join fe_cred As c On c.`cred_idrc`=r.`rcre_idrc` Where r.`rcre_Acti`='A' And c.`Acti`='A' And r.rcre_idcl=<<nidclie>>
	If This.Tienda > 0 Then
	   \ And rcre_codt=<<This.Tienda>>
	Endif
	If Len(Alltrim(This.cformapago)) > 0 Then
	   \ And rcre_form='<<this.cformapago>>'
	Endif
		\Group By `c`.`Ncontrol`,r.rcre_idrc,r.rcre_idcl  Having (Round(Sum((`c`.`Impo` - `c`.`acta`)),2) <> 0)) As v
		\INNER Join fe_clie As `x` On `x`.`idclie`=v.rcre_idcl
		\INNER Join fe_rcred As rr On rr.`rcre_idrc`=v.rcre_idrc
		\Left Join fe_vend As vv On vv.`idven`=rr.`rcre_codv`
		\Left Join  (Select tdoc,ndoc,Idauto From fe_rcom Where idcliente>0 And Acti='A') As cc On cc.Idauto=rr.`rcre_idau`
		\INNER Join fe_cred As a On a.idcred=v.Ncontrol
		\INNER Join fe_sucu As s On s.idalma=rr.rcre_codt Order By tipo,fevto
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfun
	Function registraanticipos(nidclie, dFech, npago, cndoc, cdetalle, ndolar, Cmoneda)
	objant = Createobject("empty")
	Set Procedure To d:\capass\modelos\cajae Additive
	ocaja = Createobject('cajae')
	If This.contransaccion = 'S' Then
		If  This.IniciaTransaccion() < 1 Then
			Return 0
		Endif
	Endif
	ur = This.IngresaCabeceraAnticipo(This.Idauto, nidclie, dFech, This.Codv, npago, goApp.nidusua, goApp.Tienda, 0, Id())
	If ur < 1
		If This.contransaccion = 'S'
			This.DEshacerCambios()
		Endif
		Return 0
	Endif
	AddProperty(objant, 'cndoc', cndoc)
	AddProperty(objant, 'npago', m.npago)
	AddProperty(objant, 'estado', 'P')
	AddProperty(objant, 'cmoneda', m.Cmoneda)
	AddProperty(objant, 'cdetalle', m.cdetalle)
	AddProperty(objant, 'dfech', Dtoc(m.dFech))
	AddProperty(objant, 'tipo', 'F')
	AddProperty(objant, 'nctrl', -1)
	AddProperty(objant, 'cnrou', "")
	AddProperty(objant, 'cpc', Id())
	AddProperty(objant, 'nidus', goApp.nidusua)
	AddProperty(objant, 'nidAnticipo', m.ur )
	nidanti = This.registradetalleAnticipo(m.objant)
	If nidanti < 1 Then
		If This.contrasaccion = 'S'
			This.DEshacerCambios()
		Endif
		Return 0
	Endif
	nmp = Iif(Cmoneda = 'D', Round(npago * ndolar, 2), npago)
	conerrorcaja = ''
	If This.tipopago = 'N' Then
*!*			If ocaja.IngresaDatosLCajaEe(dFech, "", cdetalle, fe_gene.gene_idcre, nmp, 0, 'S', fe_gene.dola, This.idcajero, nidanti) < 1 Then
*!*				conerrorcaja = 'S'
*!*			Endif
*!*			If ocaja.IngresaDatosLCajaEFectivo11(dFech,'',cdetalle,fe_gene.gene_idcre, nmp, 0, 'S', fe_gene.dola, 0, nidclie, this.Idauto,'S','E') < 1 Then
*!*			IngresaDatosLCajaEFectivo12(dfvta, "", .lblRAZON.Value, fe_gene.idctat, Nt, 0,  'S', fe_gene.dola, goApp.idcajero, .txtCodigo.Value, .NAuto, Left(.cmbFORMA.Value, 1), cndcto, cTdoc, goApp.Tienda) = 0 Then
*!*			DEshacerCambios()
*!*				conerrorcaja = 'S'
*!*			Endif
	Else
		If ocaja.IngresaDatosLCajaEe(dFech, "", cdetalle, fe_gene.gene_idcre, nmp, 0, 'S', fe_gene.dola, This.idcajero, nidanti) < 1 Then
			conerrorcaja = 'S'
		Endif
	Endif
	If   conerrorcaja = 'S' Then
		If This.contransaccion = 'S'
			This.DEshacerCambios()
		Endif
		This.cmensaje = ocaja.cmensaje
		Return 0
	Endif
	If This.contransaccion = 'S'
		If This.GRabarCambios() < 1 Then
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function IngresaCabeceraAnticipo(NAuto, nidcliente, dFecha, nidven, nimpoo, nidus, nidtda, ninic, cpc)
	lC = "FUNINGRESARCREDITOSANTICIPOS"
	Ccursor = "nidr"
	goApp.npara1 = NAuto
	goApp.npara2 = nidcliente
	goApp.npara3 = dFecha
	goApp.npara4 = nidven
	goApp.npara5 = nimpoo
	goApp.npara6 = nidus
	goApp.npara7 = nidtda
	goApp.npara8 = ninic
	goApp.npara9 = cpc
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9)
	ENDTEXT
	Sw = This.EJECUTARf(lC, lp, Ccursor)
	If Sw < 0 Then
		Return 0
	Endif
	Return Sw
	Endfunc
	Function CancelaCreditosanticipos()
	lC = "FUNINGRESAPAGOSCREDITOSANTICIPOS"
	Ccursor = "nidp"
	goApp.npara1 = This.cndoc
	goApp.npara2 = This.npago
	goApp.npara3 = This.Cestado
	goApp.npara4 = This.Cmoneda
	goApp.npara5 = This.cdetalle
	goApp.npara6 = This.dFech
	goApp.npara7 = This.dFech
	goApp.npara8 = This.Ctipo
	goApp.npara9 = This.Ncontrol
	goApp.npara10 = This.cnrou
	goApp.npara11 = This.nidrc
	goApp.npara12 = Id()
	goApp.npara13 = goApp.nidusua
	goApp.npara14 = This.NidAnticipo
	goApp.npara15 = This.nidanticipocr
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, Ccursor)
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function compensapagosanticipos(objant1)
	x = 1
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	This.contransaccion = 'S'
	Nacta = 0
	Select pdtes
	Scan For Sw = 1
		This.cndoc = m.objant1.cndoc
		This.npago = pdtes.Montoc
		This.Cestado = 'P'
		This.Cmoneda = 'S'
		This.cdetalle = m.objant1.cdeta
		This.dFech = Ctod(m.objant1.dFech)
		This.Ctipo = m.objant1.Ctipo
		This.Ncontrol = pdtes.Ncontrol
		This.nidrc = pdtes.rcre_idrc
		This.nidanticipocr = m.objant1.nidanticipocr
		This.NidAnticipo = m.objant1.NidAnticipo
*	If This.CancelaCreditosanticipos(cndoc, pdtes.Montoc, 'P', 'S', cdeta, dFech, dFech, Ctipo, pdtes.Ncontrol, '', pdtes.rcre_idrc, Id(), goApp.nidusua, NidAnticipo) < 1 Then
		If This.CancelaCreditosanticipos() < 1 Then
			x = 0
			Exit
		Endif
		Nacta = m.Nacta + pdtes.Montoc
	Endscan
	If x = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	TEXT To lC Noshow Textmerge
        UPDATE fe_cred as f SET acta=f.acta-<<m.nacta>> WHERE idcred=<<this.nidanticipocr>> and acti='A'
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1  Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registrar()
	If !Pemstatus(goApp, "clienteconproyectos", 5) Then
		AddProperty(goApp, "clienteconproyectos", "")
	Endif
	This.crefe = "VENTA AL CREDITO"
	lC = 'FUNREGISTRACREDITOS'
	cur = "xn"
	goApp.npara1 = This.Idauto
	goApp.npara2 = This.nidclie
	goApp.npara3 = This.cndoc
	goApp.npara4 = 'C'
	goApp.npara5 = 'S'
	goApp.npara6 = This.crefe
	goApp.npara7 = This.dFech
	goApp.npara8 = This.Fechavto
	goApp.npara9 = This.tipodcto
	goApp.npara10 = This.cndoc
	goApp.npara11 = This.nimpo
	goApp.npara12 = 0
	goApp.npara13 = This.Codv
	goApp.npara14 = This.nimpoo
	goApp.npara15 = goApp.nidusua
	goApp.npara16 = goApp.Tienda
	goApp.npara17 = Id()
	If goApp.clienteconproyectos='S' Then
		goApp.npara18=This.nidproyecto
		TEXT To lp Noshow
		(?goApp.npara1,?goApp.npara2,?goApp.npara3,?goApp.npara4,?goApp.npara5,?goApp.npara6,?goApp.npara7,?goApp.npara8,?goApp.npara9,
		?goApp.npara10,?goApp.npara11,?goApp.npara12,?goApp.npara13,?goApp.npara14,?goApp.npara15,?goApp.npara16,?goApp.npara17,?goApp.npara18)
		ENDTEXT
	Else
		TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
		ENDTEXT
	Endif
	nidcr = This.EJECUTARf(lC, lp, cur)
	If nidcr < 1 Then
		Return 0
	Endif
	Return nidcr
	Endfunc
	Function IngresaCreditosNormalFormaPago(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18)
	lC = 'FUNREGISTRACREDITOSFormaPago'
	cur = "Xn"
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara9 = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	goApp.npara12 = np12
	goApp.npara13 = np13
	goApp.npara14 = np14
	goApp.npara15 = np15
	goApp.npara16 = np16
	goApp.npara17 = np17
	goApp.npara18 = np18
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
	ENDTEXT
	nidc = This.EJECUTARf(lC, lp, cur)
	If nidc < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listardctosparacancelar(Ccursor)
	If !Pemstatus(goApp, "clienteconproyectos", 5) Then
		AddProperty(goApp, "clienteconproyectos", "")
	Endif
	If !Pemstatus(goApp, "cdatos", 5) Then
		AddProperty(goApp, "cdatos", "")
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	   \ Select e.ndoc,e.fech,xx.fevto,xx.saldo,
	   \ b.rcre_impc,'C' As situa,b.rcre_idau,xx.Ncontrol,e.tipo,rcre_idav,e.banco,ifnull(c.ndoc,'') As docd,ifnull(c.tdoc,'' ) As tdoc,e.nrou,
	   \ e.mone,0 As dscto,rcre_codt As codt,xxx.razo,b.rcre_impc As importec,b.rcre_idau As Idauto,e.mone As moneda,b.rcre_idrc As idrc,xxx.idclie,
	   \ d.idven,d.nomv,xx.rcre_idrc,ifnull(u.nomb,'') As usuario,ifnull(s.nomb,'') As Tienda,
	If goApp.clienteconproyectos = 'S'
	   \ifnull(proy_nomb,'') As proyecto
	Else
	    \ '' As proyecto
	Endif
	   \ From
	   \ (Select Ncontrol,Round(Sum(a.Impo-a.acta),2) As saldo,Max(fevto) As fevto,rcre_idrc From fe_cred As a
	   \ INNER Join fe_rcred As b On(b.rcre_idrc=a.cred_idrc)
	   \ Where a.Acti='A' And b.rcre_Acti='A'
	If This.nidclie > 0 Then
	    \ And b.rcre_idcl=<<This.nidclie>>
	Endif
	If Len(Alltrim(This.Cmoneda)) > 0 Then
	    \ And a.mone='<<this.cmoneda>>'
	Endif
	If Len(Alltrim(This.Ctipo)) > 0 Then
	    \ And a.tipo='<<this.ctipo>>'
	Endif
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And rcre_codt=<<goApp.Tienda>>
		Else
	      \And rcre_codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	    \Group By Ncontrol,rcre_idrc Having saldo<>0) As xx
	    \INNER Join fe_rcred As b On b.rcre_idrc=xx.rcre_idrc
	    \INNER Join fe_cred As e On e.idcred=xx.Ncontrol
	    \INNER Join fe_vend As d On(d.idven=b.rcre_codv)
	    \INNER Join fe_clie As xxx On xxx.idclie=b.rcre_idcl
	    \Left Join fe_usua As u On u.idusua=b.rcre_idus
	    \Left Join fe_sucu As s On s.idalma=b.rcre_codt
	    \Left Join (Select ndoc,tdoc,fech,Idauto From fe_rcom Where Acti='A' And idcliente>0) As c On(c.Idauto=b.rcre_idau)
	If goApp.clienteconproyectos = 'S'
	     \Left Join fe_proyectos As p On p.proy_idpr=b.rcre_idsu
	Endif
	    \Order By fevto
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarpdteslopez(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
	\Select razo,nomv,fech As fepd,fevto As fevd,importe,
	\tipo,docd,If(tdoc='01','F',If(tdoc='03','B',If(tdoc='20','P',''))) As tipodoc,ndoc,idcred As nreg,rcre_codv As idven,idclie,banc,mone As mond,
	\estd,dola,nrou,' ' As usua,Idauto,rcre_idrc,Ncontrol,tdoc From vpdtespagoc Where importe>0
	If This.Codv > 0 Then
	\ And  rcre_codv=<<This.Codv>>
	Endif
	If Len(Alltrim(This.cformapago)) > 0 Then
	\ And rcre_form='<<this.cformapago>>'
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarpendientesparacancelar1(Ccursor)
	If !Pemstatus(goApp, 'cdatos', 5)
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'clienteconproyectos', 5)
		AddProperty(goApp, 'clienteconproyectos', '')
	Endif
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select ifnull(c.ndoc,e.ndoc) As ndoc,e.fech,xx.fevto,xx.saldo,
	\b.rcre_impc,'C' As situa,b.rcre_idau,xx.Ncontrol,e.tipo,rcre_idav,e.banco,ifnull(c.ndoc,' ') As docd,ifnull(c.tdoc,' ' ) As tdoc,e.nrou,
	\e.mone,0 As dscto,rcre_codt As codt,xxx.razo,b.rcre_impc As importec,b.rcre_idau As Idauto,e.mone As moneda,b.rcre_idrc As idrc,xxx.idclie,
	\d.idven,d.nomv,xx.rcre_idrc,
	If goApp.clienteconproyectos = 'S' Then
	 \ifnull(proy_nomb,'') As proyecto
	Else
	 \ '' As proyecto
	Endif
	 \ From (Select Ncontrol,Round(Sum(a.Impo-a.acta),2) As saldo,Max(fevto) As fevto,rcre_idrc From  fe_cred As a
	\       INNER Join fe_rcred As b On(b.rcre_idrc=a.cred_idrc)
	\	  Where a.Acti='A' And b.rcre_Acti='A'
	If goApp.Cdatos = 'S' Then
	   \And b.rcre_codt=<<goApp.Tienda>>
	Endif
	\Group By Ncontrol,rcre_idrc Having saldo<>0) As xx
	\   INNER Join fe_rcred As b On b.rcre_idrc=xx.rcre_idrc
	\   INNER Join (SELECT tipo,banco,nrou,mone,idcred,fech,ndoc FROM fe_cred WHERE ncontrol>0 and acti='A') As e On e.idcred=xx.Ncontrol
	\   INNER Join fe_vend As d On(d.idven=b.rcre_codv)
	\   INNER Join fe_clie As xxx On xxx.idclie=b.rcre_idcl
	\   Left  Join (Select tdoc,ndoc,Idauto From fe_rcom Where idcliente>0 And Acti='A') As c On(c.Idauto=b.rcre_idau)
	If goApp.clienteconproyectos = 'S' Then
	   \  Left Join fe_proyectos As p On p.proy_idpr=b.rcre_idsu
	Endif
	\   Order By fevto
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarpendientesparacancelarxsysg(Ccursor)
	If !Pemstatus(goApp, 'cdatos', 5)
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'clienteconproyectos', 5)
		AddProperty(goApp, 'clienteconproyectos', '')
	Endif
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select ifnull(c.ndoc,e.ndoc) As ndoc,e.fech,xx.fevto,xx.saldo,
	\b.rcre_impc,'C' As situa,b.rcre_idau,xx.Ncontrol,e.tipo,rcre_idav,e.banco,ifnull(c.ndoc,' ') As docd,ifnull(c.tdoc,' ' ) As tdoc,e.nrou,
	\e.mone,0 As dscto,rcre_codt As codt,xxx.razo,b.rcre_impc As importec,b.rcre_idau As Idauto,e.mone As moneda,b.rcre_idrc As idrc,xxx.idclie,
	\CAST(0 as unsigned ) as idven,"" as nomv,xx.rcre_idrc,
	If goApp.clienteconproyectos = 'S' Then
	 \ifnull(proy_nomb,'') As proyecto
	Else
	 \ '' As proyecto
	Endif
	 \ From (Select Ncontrol,Round(Sum(a.Impo-a.acta),2) As saldo,Max(fevto) As fevto,rcre_idrc From  fe_cred As a
	\           INNER Join fe_rcred As b On(b.rcre_idrc=a.cred_idrc)
	\		    Where a.Acti='A' And b.rcre_Acti='A'
	If goApp.Cdatos = 'S' Then
	   \And b.rcre_codt=<<goApp.Tienda>>
	Endif
	\Group By Ncontrol,rcre_idrc Having saldo<>0) As xx
	\   INNER Join fe_rcred As b On b.rcre_idrc=xx.rcre_idrc
	\   INNER Join (SELECT tipo,banco,nrou,mone,idcred,fech,ndoc FROM fe_cred WHERE ncontrol>0 and acti='A') As e On e.idcred=xx.Ncontrol
	\   INNER Join fe_clie As xxx On xxx.idclie=b.rcre_idcl
	\   Left  Join (Select tdoc,ndoc,Idauto From fe_rcom Where idcliente>0 And Acti='A') As c On(c.Idauto=b.rcre_idau)
	If goApp.clienteconproyectos = 'S' Then
	   \  Left Join fe_proyectos As p On p.proy_idpr=b.rcre_idsu
	Endif
	\Order By fevto
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function CancelaCreditosCefectivoConYape(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np12, np13, np14, np15)
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara9 = np9
	goApp.npara10 = np10
	goApp.npara12 = np12
	goApp.npara13 = np13
	goApp.npara14 = np14
	goApp.npara15 = np15
	TEXT To lC Noshow
	INSERT INTO fe_cred(fech,fevto,acta,ndoc,estd,mone,banc,tipo,cred_idrc,cred_idus,cred_fope,ncontrol,nrou,cred_idpc,cred_idcb)
	VALUES(?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,
    ?goapp.npara8,?goapp.npara9,?goapp.npara10,localtime,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15);
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function vtosxcliente1(nidclie, Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Df = Cfechas(This.dFech)
	Set Textmerge On
	Set Textmerge To  Memvar lC Noshow Textmerge
	\Select `x`.`idclie`,`x`.`razo`      As `razo`,
	\v.importe,v.fevto,`v`.`rcre_idrc` As `rcre_idrc`,`rr`.`rcre_fech` As `fech`,
	\`rr`.`rcre_idau` As `Idauto`,rcre_codv As idven,ifnull(`vv`.`nomv`,'')  As `nomv`,
	\ ifnull(`cc`.`ndoc`,"") As `docd`, ifnull(`cc`.`tdoc`,'') As `tdoc`, a.`ndoc`,
	\`a`.`mone` ,`a`.`banc` ,a.situa,rr.rcre_impc,`a`.`tipo` ,`a`.`dola`      As `dola`,rcre_codt,`a`.`nrou`,`a`.`banco` ,
	\`a`.`idcred`,a.fech As fepd,v.Ncontrol,a.estd,a.ndoc,v.rcre_idrc,a.Impo As impoo
	\From (
	\Select Ncontrol,rcre_idrc,rcre_idcl,Max(`c`.`fevto`) As `fevto`,Round(Sum((`c`.`Impo` - `c`.`acta`)),2) As `importe` From
	\fe_rcred As r
	\INNER Join fe_cred As c On c.`cred_idrc`=r.`rcre_idrc` Where r.`rcre_Acti`='A' And c.`Acti`='A' And r.rcre_idcl=<<nidclie>> And c.fech<='<<df>>'
	If This.chkTIENDA > 0 Then
	   \ And rcre_codt=<<This.Tienda>>
	Endif
	If Len(Alltrim(This.cformapago)) > 0 Then
	   \ And rcre_form='<<this.cformapago>>'
	Endif
		\Group By `c`.`Ncontrol`,r.rcre_idrc,r.rcre_idcl  Having (Round(Sum((`c`.`Impo` - `c`.`acta`)),2) <> 0)) As v
		\INNER Join fe_clie As `x` On `x`.`idclie`=v.rcre_idcl
		\INNER Join fe_rcred As rr On rr.`rcre_idrc`=v.rcre_idrc
		\Left Join fe_vend As vv On vv.`idven`=rr.`rcre_codv`
		\Left Join  (Select tdoc,ndoc,Idauto From fe_rcom Where idcliente>0 And Acti='A') As cc On cc.Idauto=rr.`rcre_idau`
		\INNER Join fe_cred As a On a.idcred=v.Ncontrol
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listardetallectasxcobrar(Ccursor)
	f2 = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select  a.razo, ifnull(b.tdoc, "SD") As tdoc, ifnull(b.ndoc, c.ndoc) As ndoc, p.rcre_fech As fech, c.fevto, ifnull(b.mone, 'S') As mone,
	\c.Impo, s.acta, s.saldo, ifnull(b.Idauto, 0) As Idauto, e.nomv, c.tipo, p.rcre_codv, a.idclie  From
	\(Select xx.rcre_idcl As idclie, a.Ncontrol, Round(Sum(a.Impo - a.acta), 2) As saldo, Sum(acta) As acta
	\From fe_cred As a
	\INNER Join fe_rcred As xx  On xx.rcre_idrc = a.cred_idrc
	\Where a.fech <= '<<f2>>' And a.Acti <> 'I' And xx.rcre_Acti <> 'I'
	If This.Tienda > 0 Then
	\  And xx.rcre_codt =<<This.Tienda>>
	Endif
	If This.Codv > 0 Then
	\  And xx.rcre_codv =<<This.Codv>>
	Endif
	\  Group By xx.rcre_idcl, a.Ncontrol, a.mone
	\Having saldo <> 0) As s
	\INNER Join fe_clie As a On a.idclie = s.idclie
	\INNER Join fe_cred As c On c.idcred = s.Ncontrol
	\INNER Join fe_rcred As p On p.rcre_idrc = c.cred_idrc
	\INNER Join fe_vend As e On e.idven = p.rcre_codv
	\Left Join fe_rcom As b On b.Idauto = p.rcre_idau Order By razo
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaCreditosNormalFormaPago1()
	lC = 'FUNREGISTRACREDITOSFormaPago'
	cur = "Xn"
	TEXT To lp Noshow Textmerge
     (<<this.Idauto>> ,<<this.nidclie>>,'<<this.cndoc>>','C','S','<<this.cdetalle>>',
     '<<cfechas(this.dfech)>>','<<cfechas(this.Fechavto)>>','<<this.ctipo>>',
      '<<this.cndoc>>',<<this.nimpo>>,0,<<this.Codv>>,<<This.nimpo>>,<<goapp.nidusua>>,<<goapp.tienda>>,'<<ID()>>','<<LEFT(this.cformapago,1)>>')
	ENDTEXT
	nidc = This.EJECUTARf(lC, lp, cur)
	If nidc < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listardctoscobranzapsysl(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\ Select b.razo,c.nomv,a.fech As fepd,a.fevto As fevd,a.acta As importe,
	\a.tipo,ifnull(Y.ndoc,'')  As docd,ifnull(Y.tdoc,'') As tdoc,a.ndoc,a.idcred As nreg,x.rcre_codv As idven,x.rcre_idcl As idclie,a.banc,a.mone As mond,
	\a.estd,a.dola,a.nrou From fe_rcred As x
	\INNER Join fe_cred As a On a.cred_idrc=x.rcre_idrc
	\INNER Join fe_clie As b On(x.rcre_idcl=b.idclie)
	\INNER Join fe_vend As c On(x.rcre_codv=c.idven)
	\Left Join fe_rcom As Y On Y.Idauto=x.rcre_idau
	\Where a.fech Between '<<f1>>' And '<<f2>>' And a.acta>0 And a.Acti='A'
	If This.Codv > 0 Then
	\ And  x.rcre_codv=<<This.Codv>>
	Endif
	\Order By a.fech
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registradetalleAnticipo(objant)
	lC = "FunIngresaDetalleAnticipo"
	goApp.npara1 = objant.cndoc
	goApp.npara2 = objant.npago
	goApp.npara3 = objant.estado
	goApp.npara4 = objant.Cmoneda
	goApp.npara5 = objant.cdetalle
	goApp.npara6 = Ctod(objant.dFech)
	goApp.npara7 = Ctod(objant.dFech)
	goApp.npara8 = objant.Tipo
	goApp.npara9 = objant.nctrl
	goApp.npara10 = objant.cnrou
	goApp.npara11 = objant.NidAnticipo
	goApp.npara12 = objant.cpc
	goApp.npara13 = objant.nidus
	goApp.npara14 = objant.NidAnticipo
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, 'nidp')
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function calcularsaldosanticipos()
	Ccursor = 'c' + Sys(2015)
	TEXT To lC Noshow Textmerge
	SELECT SUM(acta) as acta,cred_idant FROM fe_cred AS d
	INNER JOIN fe_rcred AS r ON r.rcre_idrc=d.`cred_idrc`
    WHERE acti='A' AND cred_idant>0 AND ncontrol<>-1 AND rcre_idcl=<<this.nidclie>> GROUP BY cred_idant
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Sw = 1
	Select (Ccursor)
	Scan All
		TEXT To lC Noshow Textmerge
	        UPDATE fe_cred as d SET acta=d.cred_mant-<<acta>> where idcred=<<cred_idant>> and ncontrol=-1
		ENDTEXT
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
	Function DesactivaCreditos(np1)
	lC = 'PRODESACTIVARCREDITOS'
	goApp.npara1 = np1
	TEXT To lp Noshow
	     (?goapp.npara1)
	ENDTEXT
	If This.ejecutarp(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function DesactivaDCreditos(np1)
	Set Procedure To d:\capass\modelos\cajae Additive
	ocaja = Createobject("cajae")
	goApp.npara1 = np1
	lC = 'PRODESACTIVACREDITOS'
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	TEXT To lp Noshow
	     (?goapp.npara1)
	ENDTEXT
	If This.ejecutarp(lC, lp, "") < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If ocaja.DesactivaCajaEfectivoCr(np1) < 1 Then
		This.cmensaje = ocaja.cmensaje
		This.DEshacerCambios()
		Return 0
	Endif
	If This.nidanticipocr > 0   Then
		TEXT To lC Noshow Textmerge
	       UPDATE fe_cred AS f SET f.acta=f.acta+<<this.npago>> WHERE f.idcred=<<this.NidAnticipocr>> AND ncontrol=-1 AND acti='A'
		ENDTEXT
		If This.Ejecutarsql(lC) < 1 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarpagosenbancos(nidb, Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lC Noshow Textmerge
	    SELECT ifnull(x.ndoc,a.ndoc) as ndoc,acta,banc,ifnull(x.fech,a.fech) as fech
		from fe_cred as a
		inner join fe_rcred as b on b.rcre_idrc=a.cred_idrc
		left join fe_rcom as x on x.idauto=b.rcre_idau
		where cred_idcb=<<nidb>> and a.acti='A'
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listadetallada(Ccursor)
	If This.Idsesion>0 Then
		Set DataSession To This.Idsesion
	Endif
	Df=Cfechas(This.dFech)
	TEXT to lc NOSHOW TEXTMERGE PRETEXT 7
	    select idclie,nruc,razo,ndoc,fech,mone,tsoles,tdolar,ndni,vendedor from (
		SELECT p.rcre_idcl as idclie,b.razo,'S'  as mone,ifnull(t.ndoc,'') as ndoc,ifnull(t.fech,p.rcre_fech) as fech,
		ROUND(SUM(a.impo-a.acta),2) AS tsoles,b.nruc,b.ndni,0 AS tdolar,v.nomv as vendedor
		FROM fe_cred as a
		inner join fe_rcred as p on p.rcre_idrc=a.cred_idrc
		inner join fe_vend as v on(v.idven=p.rcre_codv)
		inner join  fe_clie as b on b.idclie=p.rcre_idcl
		left join fe_rcom as t on t.idauto=p.rcre_idau
		WHERE a.acti<>'I' and p.rcre_acti='A'  and a.fech<='<<df>>' GROUP BY p.rcre_idrc)
		as t where t.tsoles<>0 or t.tdolar<>0 order by razo
	ENDTEXT
	If This.EJECutaconsulta(lC,'tmp')<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarpdtes(Ccursor)
	If This.Idsesion>0 Then
		Set DataSession To This.Idsesion
	Endif
	ff=Cfechas(This.dFech)
	TEXT to lc NOSHOW TEXTMERGE
	     select c.nruc,c.ndni,c.razo,c.idclie,r.rcre_idau,a.mone,a.tipo,a.banc,b.importe,a.ncontrol,a.ndoc,a.fech,a.fevto,a.dola,a.fech AS fechp,
	 	 IFNULL(y.ndoc,'') AS docp FROM
	     (SELECT ROUND(SUM(a.impo-a.acta),2) AS importe,a.ncontrol
	     FROM fe_rcred AS x INNER JOIN fe_cred AS a  ON a.cred_idrc=x.rcre_idrc
	     WHERE a.acti<>'I' AND x.rcre_acti<>'I' AND a.fech <='<<ff>>' GROUP BY ncontrol HAVING importe>0) AS b
	     INNER JOIN (SELECT fech,fevto,dola,ndoc,ncontrol,cred_idrc,tipo,banc,mone FROM fe_cred WHERE estd='C' AND acti='A') AS a  ON a.ncontrol=b.ncontrol
	     INNER JOIN fe_rcred AS r ON r.rcre_idrc=a.cred_idrc
	     INNER JOIN fe_clie AS c ON (c.idclie=r.rcre_idcl)
	     LEFT JOIN fe_rcom AS y ON y.idauto=r.rcre_idau
	ENDTEXT
	If This.EJECutaconsulta(lC,Ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarpagodesdebanco(nidv,Ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
    SELECT ifnull(x.ndoc,a.ndoc) as ndoc,acta,banc,ifnull(x.fech,a.fech) as fech
	from fe_cred as a
	inner join fe_rcred as b on b.rcre_idrc=a.cred_idrc
	left join fe_rcom as x on x.idauto=b.rcre_idau
	where cred_idcb=<<nidb>>
	ENDTEXT
	If This.EJECutaconsulta(lC,Ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function resumenctasxcobrar(dFecha,Ccursor)
	If !Pemstatus(goApp, 'cdatos', 5)
		AddProperty(goApp, 'cdatos', '')
	Endif
	If This.Idsesion>0 Then
		Set DataSession To This.Idsesion
	Endif
	Df=Cfechas(dFecha)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\SELECT c.nruc,c.razo AS proveedor,c.idclie AS codp,a.mone,SUM(IF(a.mone='S',saldo,0)) AS tsoles,SUM(IF(a.mone='D',saldo,0)) AS tdolar,
	\c.clie_idzo,s.nomb AS Tienda FROM
	\(SELECT a.Ncontrol,MIN(fevto) AS fech,ROUND(SUM(a.Impo-a.acta),2) AS saldo
	\FROM fe_cred AS a
	\INNER JOIN fe_rcred AS xx  ON xx.rcre_idrc=a.cred_idrc
	\WHERE a.fech<='<<df>>'  AND  a.Acti<>'I' AND xx.rcre_Acti<>'I'
	If This.chkformapago = 1 Then
     \And rcre_form='<<this.cformapago>>'
	Endif
	If This.chkTIENDA = 1 Then
	\ And rcre_codt=<<This.Tienda>>
	Endif
	\GROUP BY a.Ncontrol HAVING saldo<>0) AS b
	\INNER JOIN fe_cred AS a ON a.idcred=b.Ncontrol
	\INNER JOIN fe_rcred AS r ON r.rcre_idrc=a.cred_idrc
	\INNER JOIN fe_clie AS c ON c.idclie=r.rcre_idcl
	\INNER JOIN fe_sucu AS s ON s.idalma=r.rcre_codt
	If This.idzona > 0 Then
	   \ Where clie_idzo=<<This.idzona>>
	Endif
	\GROUP BY nruc,proveedor,codp,clie_idzo,tienda ORDER BY proveedor
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function calcularSaldocliente(Ccursor)
	If This.Idsesion>0 Then
		Set DataSession To This.Idsesion
	Endif
	lC = 'PROCALCULARSALDOSCLIENTE'
	TEXT To lp NOSHOW TEXTMERGE
	     (<<this.nidclie>>)
	ENDTEXT
	If This.ejecutarp(lC, lp,Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaCabeceraCreditos()
	lC='FUNINGRESARCREDITOS'
	goApp.npara1 = This.Idauto
	goApp.npara2 = This.nidclie
	goApp.npara3 = This.dFech
	goApp.npara4 = This.Codv
	goApp.npara5 =This.nimpo
	goApp.npara6 = goApp.nidusua
	goApp.npara7 =This.Tienda
	goApp.npara8 = This.ninic
	goApp.npara9 = Id()
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, 'nidp')
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function IngresaDcreditos(obj)
	lC='FUNINGRESAdCREDITOS'
	goApp.npara1 = obj.fecha
	goApp.npara2 = obj.dfevto
	goApp.npara3 = obj.nimpo
	goApp.npara4 = obj.cndoc
	goApp.npara5 =obj.Cestado
	goApp.npara6 =obj.Cmoneda
	goApp.npara7 = obj.cdetalle
	goApp.npara8 = obj.Ctipo
	goApp.npara9 = obj.nidrc
	goApp.npara10 = goApp.nidusua
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, 'dcreditos')
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function registracreditosconcuotas()
	obj=Createobject("empty")
	AddProperty(obj,'fecha',Date())
	AddProperty(obj,'dfevto',Date())
	AddProperty(obj,'nimpo',0)
	AddProperty(obj,'cndoc',"")
	AddProperty(obj,'cestado',"")
	AddProperty(obj,'cmoneda',"")
	AddProperty(obj,'cdetalle',"")
	AddProperty(obj,'ctipo',"")
	AddProperty(obj,'nidrc',0)
	AddProperty(obj,'nidusua',goApp.nidusua)
	If This.Idsesion>0 Then
		Set DataSession To This.Idsesion
	Endif
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	nidrc=This.IngresaCabeceraCreditos()
	If m.nidrc<1 Then
		This.DEshacerCambios()
		Return
	Endif
	Sw=1
	Select tmpd
	Go Top
	Do While !Eof()
		ccimporte=retcimporte(tmpd.Impo,Left(.cmbmoneda.Value,1))
		crefe=Iif(Empty(.referencia),tmpd.detalle,.referencia)
		x=x+1
		obj.fecha=This.dFech
		obj.dfevto=tmpd.fevto
		obj.nimpo=tmpd.Impo
		obj.cndoc=tmpd.ndoc
		obj.Cestado='C'
		obj.Cmoneda='S'
		obj.cdetalle=m.crefe
		obj.Ctipo=This.Ctipo
		obj.nidrc=m.nidrc
		If This.IngresaDcreditos(obj)<1 Then
			Sw=0
			Exit
		Endif
		Select tmpd
		Skip
	Enddo
	If Sw=0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If 	This.GRabarCambios()<1 Then
		Return 0
	Endif
	This.cmensaje='Ok'
	Return 1
	Endfunc
	Function listardetalle(Ccursor)
	f1=Cfechas(This.dfi)
	f2=Cfechas(This.dff)
	If This.Idsesion>0 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT TO lc NOSHOW TEXTMERGE
	SELECT xx.idclie,v.importe,v.fevto,DATEDIFF(CURDATE(),v.fevto) AS dias,v.rcre_idrc,rr.rcre_fech AS fech,razo,
    rr.rcre_idau AS idauto,rcre_codv AS idven,vv.nomv,
    IFNULL(cc.ndoc,'') AS docd,IFNULL(cc.tdoc,'') AS tdoc,a.ndoc,
    a.mone,a.banc,a.tipo,a.dola,a.nrou,a.banco,a.idcred,a.fech AS fepd,v.ncontrol,a.estd,aa.descri,kk.cant,kk.prec,cc.impo,aa.unid
    FROM (
    SELECT ncontrol,rcre_idrc,rcre_idcl,MAX(c.fevto ) AS  fevto ,ROUND(SUM((c.impo - c.acta )),2) AS  importe  FROM
    fe_rcred AS r INNER JOIN fe_cred AS c ON c. cred_idrc =r. rcre_idrc
    WHERE r. rcre_Acti ='A' AND c. acti ='A' AND r.rcre_idcl=<<this.nidclie>>
    GROUP BY  c.ncontrol,r.rcre_idrc,r.rcre_idcl  HAVING (ROUND(SUM((c.impo - c.acta )),2) <> 0)) AS v
    INNER JOIN fe_clie AS  xx  ON xx.idclie =v.rcre_idcl
    INNER JOIN fe_rcred AS rr ON rr.rcre_idrc =v.rcre_idrc
    INNER JOIN fe_vend AS vv ON vv.idven =rr. rcre_codv
    INNER JOIN fe_kar AS kk ON rr.rcre_idau=kk.idauto
    INNER JOIN fe_art AS aa ON kk.idart=aa.idart
    LEFT JOIN
    (SELECT tdoc,ndoc,idauto,impo FROM fe_rcom WHERE acti='A' AND idcliente=<<this.nidclie>>) AS cc ON cc.idauto=rr.rcre_idau
    INNER JOIN fe_cred AS a ON a.idcred=v.ncontrol WHERE kk.acti='A' AND fech BETWEEN '<<f1>>' AND '<<f2>>' ORDER BY fech,docd
	ENDTEXT
	If This.EJECutaconsulta(lC,Ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function devuelveIdCtrlCredito(np1)
	ccur='c_'+Sys(2015)
	TEXT TO lc NOSHOW TEXTMERGE
    SELECT cred_idrc as idrc FROM fe_cred WHERE ncontrol=<<np1>> limit 1
	ENDTEXT
	If This.EJECutaconsulta(lC,ccur)<1 Then
		Return 0
	Endif
	Select (ccur)
	Return idrc
	Endfunc
	Function CancelaCreditos(objdetalle)
	lC='FUNINGRESAPAGOSCREDITOS'
	goApp.npara1 = objdetalle.cndoc
	goApp.npara2 = objdetalle.Nacta
	goApp.npara3 = objdetalle.cesta
	goApp.npara4 = objdetalle.cmone
	goApp.npara5 =objdetalle.cb1
	goApp.npara6 =objdetalle.dFech
	goApp.npara7 = objdetalle.dfevto
	goApp.npara8 = objdetalle.Ctipo
	goApp.npara9 = objdetalle.nctrol
	goApp.npara10 = objdetalle.cnrou
	goApp.npara11 = objdetalle.nidrc
	goApp.npara12 = Id()
	goApp.npara13= goApp.nidusua
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, 'nidcreditos')
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
Enddefine
























