Define Class bancos As OData Of  'd:\capass\database\data.prg'
	idcta = 0
	ctab=""
	dFecha = Date()
	cope = ""
	nmpago = 0
	cdeta = ""
	idclpr = 0
	cndoc = ""
	idcta1 = 0
	ndebe = 0
	nhaber = 0
	idcliE = 0
	idprov = 0
	norden = 0
	idcajae = 0
	ndolar = 0
	Correlativo = ""
	idb = 0
	nserie = 0
	Cmoneda = ""
	Function ReporteBancos(dfi, dff, ccta, Calias)
	Local lC
	f1 = Cfechas(dfi)
	f2 = Cfechas(dff)
	Local lC
	TEXT To lC Noshow Textmerge
	   SELECT a.cban_nume,a.cban_fech,b.pago_codi,b.pago_deta,a.cban_deta,if(a.cban_debe>0,ifnull(m.razo,''),ifnull(n.razo,'')) as razon,
	   a.cban_ndoc,c.ncta,c.nomb,a.cban_debe,a.cban_haber,a.cban_idct,a.cban_idmp,a.cban_idco,a.cban_idcl,a.cban_idpr,a.cban_dola as dolar,cban_tran,
	   cban_ttra as ttra,if(cban_debe<>0,'I','S') as tipo
	   from fe_cbancos as a
	   inner join fe_mpago as b on  b.pago_idpa=a.cban_idmp
	   left join fe_clie as m on m.idclie=a.cban_idcl
	   left join fe_prov as n on n.idprov=a.cban_idpr
	   inner join fe_plan as c on c.idcta=a.cban_idct
	   where a.cban_acti='A' AND a.cban_fech between '<<f1>>' and '<<f2>>'  and a.cban_idba=<<cta>> order by a.cban_fech,tipo,a.cban_ndoc
	ENDTEXT
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Saldoinicialbancos(Df, cta)
	F = Cfechas(Df)
	TEXT To lC Noshow Textmerge Pretext 7
       SELECT CAST(ifnull(SUM(a.cban_debe)-SUM(a.cban_haber),0) AS DECIMAL(12,2)) AS si
	   FROM fe_cbancos AS a
	   WHERE a.cban_acti='A' AND a.cban_fech<='<<F>>'  AND a.cban_idba=<<cta>> AND a.cban_idct>0
	ENDTEXT
	If This.EJECutaconsulta(lC, 'iniciobancos') < 1 Then
		Return 0
	Endif
	Return iniciobancos.si
	Endfunc
	Function MuestraLCaja(np1, Ccursor)
	lC = 'PROMUESTRALCAJA'
	goApp.npara1 = np1
	TEXT To lp Noshow
     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function MuestraCtasBancos(Ccursor)
	If Alltrim(goApp.datosctasb) <> 'S' Then
		If This.consultardata(Ccursor) < 1 Then
			Return 0
		Endif
	Else
		Create Cursor t_ctasb From Array cfieldsfectasb
		cfilejson = Addbs(Sys(5) + Sys(2003)) + 't' + Alltrim(Str(goApp.Xopcion)) + '.json'
		conerror = 0
		If File(m.cfilejson) Then
			responseType1 = Addbs(Sys(5) + Sys(2003)) + 't' + Alltrim(Str(goApp.Xopcion)) + '.json'
			If Vartype(m.oResponse) = 'O' Then
				For Each oRow In  oResponse.Array
					Insert Into t_ctasb From Name oRow
				Endfor
				Select * From t_ctasb Into Cursor (Ccursor)
			Else
				If This.consultardata(Ccursor) < 1 Then
					conerror = 1
				Endif
			Endif
		Else
			If This.consultardata(Ccursor) < 1 Then
				conerror = 1
			Endif
		Endif
		If conerror = 1 Then
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function IngresaDatosLCajaT(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13)
	lC = 'FUNIngresaCajaBancosT'
	cur = 'c_' + Sys(2015)
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
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
	ENDTEXT
	nidb = This.EJECUTARf(lC, lp, cur)
	If nidb < 1 Then
		Return 0
	Endif
	Return nidb
	Endfunc
	Function Registra(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14)
	lC = 'FUNIngresaCajaBancos2'
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
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
	ENDTEXT
	nidb = This.EJECUTARf(lC, lp, cur)
	If nid < 1 Then
		Return 0
	Endif
	Return  nidb
	Endfunc
	Function listardepositosencuenta(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Calias = 'c_' + Sys(2015)
	TEXT To lC Noshow Textmerge
	SELECT a.banc_nomb as banco,b.ctas_ctas as numerocta,cban_fech,cban_nume,c.razo,cban_debe as impo,
	ifnull(acta,cast(0 as unsigned)) as acta,cban_idcl,cban_idco,cban_ndoc FROM fe_cbancos as d
	inner join fe_ctasb as b on b.ctas_idct=d.cban_idba
	inner join fe_bancos as a on a.banc_idba=b.ctas_idba
	inner join fe_clie as c on c.idclie=d.cban_idcl
	left join (select sum(acta) as acta,cred_idcb from fe_cred where acti='A' and acta>0 and cred_idcb>0 group by cred_idcb )as x on
	x.cred_idcb=d.cban_idco where cban_acti='A'  and cban_tipo='P' and cban_idcl=<<this.idclpr>>;
	ENDTEXT
	If This.EJECutaconsulta(lC, Calias) < 1
		Return 0
	Endif
	Select banco, numerocta, cban_fech, cban_nume, Impo, Acta, 000000.00 As Apagar, cban_idcl, cban_idco, Impo - Acta As saldo, cban_ndoc;
		From (Calias) Into Cursor (Ccursor)  Readwrite
	Return 1
	Endfunc
	Function IngresaDatosLCajax(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14)
	lC = 'FUNIngresaCajaBancos2'
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
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1  Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function listarBancos(cb, Ccursor)
	lC = "ProMuestraBancos"
	TEXT To lp Noshow Textmerge
	    ('<<cb>>')
	ENDTEXT
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function consultardata(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select a.ctas_ctas,b.banc_nomb,a.ctas_mone,a.ctas_deta,a.ctas_idct,a.ctas_idba,a.ctas_ncta,ctas_seri,banc_idco
    \From fe_ctasb As a
    \inner Join fe_bancos As b On b.banc_idba=a.ctas_idba
    \Where a.ctas_acti='A'
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And a.ctas_codt=<<goApp.tienda>>
		Else
	      \And a.ctas_codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
    \Order By a.ctas_ctas
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	nCount = Afields(cfieldsfectasb)
	Select * From (Ccursor) Into Cursor t_ctasb
	cdata = nfcursortojson(.T.)
	rutajson = Addbs(Sys(5) + Sys(2003)) + 't' + Alltrim(Str(goApp.Xopcion)) + '.json'
	If File(m.rutajson) Then
		Delete File m.rutajson
	Endif
	Strtofile (cdata, rutajson)
	goApp.datosctasb = 'S'
	Return 1
	Endfunc
	Function MuestraMediosPago(Ccursor)
	If Alltrim(goApp.datosmpago) <> 'S' Then
		If This.consultardatamediospago(Ccursor) < 1 Then
			Return 0
		Endif
	Else
		If Type("cfieldsfempago") <> 'U' Then
		Endif
		Create Cursor m_mpago From Array cfieldsfempago
		cfilejson = Addbs(Sys(5) + Sys(2003)) + 'p' + Alltrim(Str(goApp.Xopcion)) + '.json'
		conerror = 0
		If File(m.cfilejson) Then
			responseType1 = Addbs(Sys(5) + Sys(2003)) + 'p' + Alltrim(Str(goApp.Xopcion)) + '.json'
			If Vartype(m.oResponse) = 'O' Then
				For Each oRow In  oResponse.Array
					Insert Into m_mpago From Name oRow
				Endfor
				Select * From m_mpago Into Cursor (Ccursor)
			Else
				If This.consultardatamediospago(Ccursor) < 1 Then
					conerror = 1
				Endif
			Endif
		Else
			If This.consultardatamediospago(Ccursor) < 1 Then
				conerror = 1
			Endif
		Endif
		If conerror = 1 Then
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function consultardatamediospago(Ccursor)
	TEXT To lC Noshow Textmerge
     SELECT pago_deta,pago_codi,pago_idpa  FROM fe_mpago  WHERE pago_acti='A' ORDER BY pago_deta
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	nCount = Afields(cfieldsfempago)
	Select * From (Ccursor) Into Cursor m_mpago
	cdata = nfcursortojson(.T.)
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'p' + Alltrim(Str(goApp.Xopcion)) + '.json'
	If File(m.rutajson) Then
		Delete File m.rutajson
	Endif
	Strtofile (cdata, rutajson)
	goApp.datosmpago = 'S'
	Return 1
	Endfunc
	Function registratraspasodesdeLCajaefectivo()
	lC = 'FUNIngresaCajaBancosTx'
	cur = "Xn"
	goApp.npara1 = This.idcta
	goApp.npara2 = This.dFecha
	goApp.npara3 = This.cope
	goApp.npara4 = This.nmpago
	goApp.npara5 = This.cdeta
	goApp.npara6 = This.idcliE
	goApp.npara7 = This.idprov
	goApp.npara8 = This.cndoc
	goApp.npara9 = This.idcta1
	goApp.npara10 = This.ndebe
	goApp.npara11 = This.nhaber
	goApp.npara12 = This.norden
	goApp.npara13 = This.idcajae
	goApp.npara14 = This.ndolar
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function IngresaDatosLCajabancos()
	lC = 'FUNIngresaCajaBancos2'
	cur = "Xn"
	goApp.npara1 = This.idcta
	goApp.npara2 = This.dFecha
	goApp.npara3 = This.cope
	goApp.npara4 = This.nmpago
	goApp.npara5 = This.cdeta
	goApp.npara6 = 0
	goApp.npara7 = This.idcliE
	goApp.npara8 = This.cndoc
	goApp.npara9 = This.idcta1
	goApp.npara10 = This.ndebe
	goApp.npara11 = This.nhaber
	goApp.npara12 = This.norden
	goApp.npara13 = This.idcliE
	goApp.npara14 = This.ndolar
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1  Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function registraopbancosmasiva()
	Set Procedure To d:\capass\modelos\cajae, d:\capass\modelos\correlativos, d:\capass\modelos\Ldiario Additive
	ocajae = Createobject("cajae")
	ocorr = Createobject("correlativo")
	odiario = Createobject("ldiario")
	If ocorr.buscarseries(This.nserie, 'LC', 'series') < 1 Then
		This.Cmensaje = ocorr.Cmensaje
		Return 0
	Endif
	This.idcta = This.idcta
	This.ndolar = fe_gene.dola
	This.nmpago = 1
	ocorr.Nsgte = series.nume
	ocorr.Idserie = series.Idserie
	ocajae.ndolar = fe_gene.dola
	ocajae.nidusua = goApp.nidusua
	ocajae.Cmoneda = This.Cmoneda
	odiario.ctran = ""
	odiario.nttd = 0
	odiario.ntth = 0
	odiario.cTdoc = ""
	odiario.niDAUTO = 0
	odiario.nidprovision = 0
	odiario.nidclie = 0
	odiario.nidprov = 0
	odiario.nidcaja = 0
	This.idcliE = 0
	This.idprov = 0
	Sw = 1
	If This.iniciatransaccion() <1  Then
		Return 0
	Endif
	Select ctas
	Scan All
		ocajae.dFecha = ctas.Fecha
		This.dFecha=ctas.Fecha
		cdcto = Right("0000" + Alltrim(Str(This.nserie)), 3) + Right('000000000' + Alltrim(Str(ocorr.Nsgte)), 7)
		If ctas.Importe > 0 Then
			If ctas.idcta = fe_gene.gene_idca Then
				ocajae.cdetalle = "Ret. y Dep. a la Cuenta:" + Alltrim(This.ctab)
				ocajae.Ndoc = m.cdcto
				ocajae.nidcta = ctas.idcta
				ocajae.ndebe = 0
				ocajae.nhaber = ctas.Importe
				ocajae.nidclpr = 0
				nidcajae = ocajae.TraspasoDatosLCajaEmas()
				If m.nidcajae < 1 Then
					Sw = 0
					This.Cmensaje = ocaja.Cmensaje
					Exit
				Endif
				This.cope = ctas.nrop
				This.cdeta = ctas.Detalle
				This.cndoc = m.cdcto
				This.idcta1 = ctas.idcta
				This.ndebe = Abs(ctas.Importe)
				This.nhaber = 0
				This.norden = 1
				This.idcajae = m.nidcajae
				If This.registratraspasodesdeLCajaefectivo() < 1 Then
					Sw = 0
					Exit
				Endif
			Else
				This.cope = ctas.nrop
				This.cdeta = ctas.Detalle
				This.cndoc = m.cdcto
				This.idcta1 = ctas.idcta
				This.ndebe = Abs(ctas.Importe)
				This.nhaber = 0
				This.norden = 1
				This.idcajae = 0
				If This.IngresaDatosLCajabancos() < 1 Then
					Sw = 0
					Exit
				Endif
			Endif
		Else
			If ctas.idcta = fe_gene.gene_idca Then
				ocajae.cdetalle = "Dep.Caja desde la Cta.:" + Alltrim(This.ctab)
				ocajae.Ndoc = m.cdcto
				ocajae.nidcta = ctas.idcta
				ocajae.ndebe = Abs(ctas.Importe)
				ocajae.nhaber = 0
				ocajae.nidclpr = 0
				nidcajae = ocajae.TraspasoDatosLCajaEmas()
				If m.nidcajae < 1 Then
					Sw = 0
					This.Cmensaje = ocajae.Cmensaje
					Exit
				Endif
				This.cope = This.nrop
				This.cdeta = ctas.Detalle
				This.idcliE = 0
				This.idprov = 0
				This.cndoc = m.cdcto
				This.idcta1 = ctas.idcta
				This.ndebe = 0
				This.nhaber = Abs(ctas.Importe)
				This.norden = 1
				This.idcajae = m.nidcajae
				If This.registratraspasodesdeLCajaefectivo() < 1 Then
					Sw = 0
					Exit
				Endif
			Else
				This.cope = ctas.nrop
				This.cdeta = ctas.Detalle
				This.cndoc = m.cdcto
				This.idcta1 = ctas.idcta
				This.ndebe = 0
				This.nhaber = Abs(ctas.Importe)
				This.norden = 1
				This.idcajae = 0
				nidopbancos = This.IngresaDatosLCajabancos()
				If m.nidopbancos < 1 Then
					Sw = 0
					Exit
				Endif
				Select * From provdiario Where Trim(cndoc) = Trim(ctas.Ndoc) Into Cursor provi
				If _Tally > 0 Then
					Select provi
					Go Top
					ni = 1
					odiario.dFecha = ctas.Fecha
					odiario.Cmoneda = 'S'
					Do While !Eof()
						ni = ni + 1
						cnume = "Pb." + m.cdcto
						odiario.ncodt = 0
						odiario.nidcta = provi.idcta
						odiario.ndebe = provi.debe
						odiario.nhaber = provi.haber
						odiario.cglosa = Alltrim(provi.Detalle) + ' ' + m.cdcto
						odiario.Ctipo = provi.Tipo
						odiario.cndoc = m.cnume
						odiario.ccond = provi.cond
						odiario.Nitem = m.ni
						odiario.ctipomvto = "Pba"
						odiario.nidbancos = m.nidopbancos
						iddi = odiario.IngresaDatosLDiarioCProvisiobancos()
						If iddi < 1 Then
							Sw = 0
							This.Cmensaje = odiario.Cmensaje
							Exit
						Endif
						Select provi
						Skip
					Enddo
				Endif
			Endif
		Endif
		If ocorr.GeneraCorrelativo1() < 1 Then
			This.Cmensaje = ocorr.Cmensaje
			Sw = 0
			Exit
		Endif
		ocorr.Nsgte =	ocorr.Nsgte + 1
	Endscan
	If  Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarsaldosctasbancos(Ccursor)
	If This.Idsesion>0 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT TO lc NOSHOW TEXTMERGE
	SELECT CONCAT(TRIM(banc_nomb),' ',TRIM(fe_ctasb.ctas_ctas)) AS ctas,saldo FROM(
	SELECT SUM(cban_debe-cban_haber) AS saldo,cban_idba FROM fe_cbancos
	WHERE cban_acti='A' GROUP BY cban_idba) AS w
	INNER JOIN fe_ctasb ON fe_ctasb.`ctas_idct`=w.`cban_idba`
	INNER JOIN fe_bancos AS b ON b.`banc_idba`=fe_ctasb.`ctas_idba`
	ENDTEXT
	If This.EJECutaconsulta(lC,Ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine





















