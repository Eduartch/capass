Define Class cajae As OData Of  'd:\capass\database\data.prg'
	dFecha = Date()
	codt = 0
	Ndoc = ""
	Nsgte = 0
	Idserie = 0
	nidprovedor = 0
	cdetalle = ""
	nidcta = 0
	ndebe = 0
	nhaber = 0
	ndolar = 0
	nidusua = 0
	nidclpr = 0
	NAuto = 0
	Cmoneda = ""
	cTdoc = ""
	cforma = ""
	dfi = Date()
	dff = Date()
	confechas = 0
	dffi = Date()
	dfff = Date()
	nsaldoinicial = 0
	Nefectivo = 0
	ctipotarjeta = ""
	cbcotarjeta = ""
	creftarjeta = ""
	Function cerrarcaja(df, nidus)
	lc = 'cierracaja'
	cur = ""
	goapp.npara1 = df
	goapp.npara2 = nidus
	TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(lc, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ReporteCajaEfectivo(dfi, dff, Calias)
	Local lc
	fi = Cfechas(dfi)
	ff = Cfechas(dff)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lc Noshow Textmerge
	   Select a.lcaj_ndoc,a.lcaj_fech,a.lcaj_deta,
	   c.ncta,c.nomb,If(lcaj_mone='S',a.lcaj_deud,Round(a.lcaj_deud*a.lcaj_dola,2)) As debe,
	   If(a.lcaj_mone='S',a.lcaj_acre,Round(a.lcaj_acre*a.lcaj_dola,2)) As haber,
		a.lcaj_idct As idcta,lcaj_tran,If(lcaj_deud>0,'I','S') As tipomvto,lcaj_idca,lcaj_dcto
		From fe_lcaja As a
		inner Join fe_plan As c On c.idcta=a.lcaj_idct
		Where a.lcaj_acti='A' And a.lcaj_fech Between '<<fi>>' And '<<ff>>'  And (lcaj_form='E' OR (lcaj_form='T' AND lcaj_deud>0)) Order By a.lcaj_fech
	ENDTEXT
	If This.EJECutaconsulta(lc, (Calias)) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ReporteCajaEfectivo10(dfi, dff, Calias)
	fi = Cfechas(dfi)
	ff = Cfechas(dff)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	If !Pemstatus(goapp, 'cdatos', 5) Then
		AddProperty(goapp, 'cdatos', '')
	Endif
	If !Pemstatus(goapp, 'tiendas', 5) Then
		AddProperty(goapp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\    Select a.lcaj_ndoc,a.lcaj_fech,a.lcaj_deta,
	\    c.ncta,c.nomb,If(lcaj_mone='S',a.lcaj_deud,Round(a.lcaj_deud*a.lcaj_dola,2)) As debe,
	\    If(a.lcaj_mone='S',a.lcaj_acre,Round(a.lcaj_acre*a.lcaj_dola,2)) As haber,
	\    a.lcaj_idct As idcta,lcaj_tran,If(lcaj_deud>0,'I','S') As tipomvto,lcaj_idca,lcaj_dcto
    \	 From fe_lcaja As a
	\	inner Join fe_plan As c On c.idcta=a.lcaj_idct
	\	Where a.lcaj_acti='A' And a.lcaj_fech Between '<<fi>>' And '<<ff>>'  And lcaj_form='E'
	If goapp.Cdatos = 'S' Then
		If Empty(goapp.Tiendas) Then
	      \And a.lcaj_codt=<<goapp.tienda>>
		Else
	      \And a.lcaj_codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	\Order By a.lcaj_fech
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, (Calias)) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Saldoinicialcajaefectivo10(df)
	F = Cfechas(df)
	If !Pemstatus(goapp, 'cdatos', 5) Then
		AddProperty(goapp, 'cdatos', '')
	Endif
	If !Pemstatus(goapp, 'tiendas', 5) Then
		AddProperty(goapp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
    \ Select
    \ Cast((Sum(If(lcaj_mone='S',a.lcaj_deud,Round(a.lcaj_deud*a.lcaj_dola,2)))-Sum(If(a.lcaj_mone='S',a.lcaj_acre,Round(a.lcaj_acre*a.lcaj_dola,2)))) As Decimal(12,2)) As si
	\ From fe_lcaja As a
	\ Where a.lcaj_acti='A' And a.lcaj_fech<'<<f>>'  And lcaj_idct>0 And lcaj_form='E'
	If goapp.Cdatos = 'S' Then
		If Empty(goapp.Tiendas) Then
	      \And a.lcaj_codt=<<goapp.tienda>>
		Else
	      \And a.lcaj_codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, 'iniciocaja') < 1 Then
		Return 0
	Endif
	Return Iif(Isnull(iniciocaja.si), 0, iniciocaja.si)
	Endfunc
	Function Saldoinicialcajaefectivo(df)
	F = Cfechas(df)
	TEXT To lc Noshow Textmerge Pretext 7
     SELECT
     CAST((SUM(IF(lcaj_mone='S',a.lcaj_deud,ROUND(a.lcaj_deud*a.lcaj_dola,2)))-SUM(IF(a.lcaj_mone='S',a.lcaj_acre,ROUND(a.lcaj_acre*a.lcaj_dola,2)))) as decimal(12,2)) AS si
	 FROM fe_lcaja AS a
	 WHERE a.lcaj_acti='A' AND a.lcaj_fech<'<<f>>'  AND lcaj_idct>0 AND (lcaj_form='E' OR (lcaj_form='T' AND lcaj_deud>0))
	ENDTEXT
	If This.EJECutaconsulta(lc, 'iniciocaja') < 1 Then
		Return 0
	Endif
	Return Iif(Isnull(iniciocaja.si), 0, iniciocaja.si)
	Endfunc
	Function IngresaDatosLCajaEe(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10)
	lc = "FunIngresaDatosLcajaEe"
	cur = "Ca"
	goapp.npara1 = np1
	goapp.npara2 = np2
	goapp.npara3 = np3
	goapp.npara4 = np4
	goapp.npara5 = np5
	goapp.npara6 = np6
	goapp.npara7 = np7
	goapp.npara8 = np8
	goapp.npara9 = np9
	goapp.npara10 = np10
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
	ENDTEXT
	nidpc = This.EJECUTARf(lc, lp, cur)
	If nidpc < 0 Then
		Return 0
	Else
		Return nidpc
	Endif
	Endfunc
	Function IngresaDatosLCajaEFectivo11(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14)
	lc = "ProIngresaDatosLcajaEefectivo"
	goapp.npara1 = np1
	goapp.npara2 = np2
	goapp.npara3 = np3
	goapp.npara4 = np4
	goapp.npara5 = np5
	goapp.npara6 = np6
	goapp.npara7 = np7
	goapp.npara8 = np8
	goapp.npara9 = np9
	goapp.npara10 = np10
	goapp.npara11 = np11
	goapp.npara12 = np12
	goapp.npara13 = np13
	goapp.npara14 = np14
	goapp.npara15 = goapp.tienda
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
	ENDTEXT
	If This.EJECUTARP(lc, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaDatosLCajaEFectivo10()
	lc = "ProIngresaDatosLcajaEefectivo"
	TEXT To lp Noshow Textmerge
     ('<<cfechas(this.dfecha)>>','','<<this.cdetalle>>',<<this.nidcta>>,<<this.ndebe>>,<<this.nhaber>>,'<<this.cmoneda>>',<<this.ndolar>>,<<goapp.nidusua>>,<<this.nidclpr>>,<<this.NAuto>>,'<<this.cforma>>','<<this.ndoc>>','<<this.cTdoc>>')
	ENDTEXT
	If This.EJECUTARP(lc, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaCajaTarjetaEfectivopsysrx()
	cdetalle = Strtran(This.cdetalle, "'", " ")
	This.cdetalle = Strtran(m.cdetalle, '"', " ")
	TEXT To lc Noshow Textmerge
	INSERT INTO fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
    lcaj_idus,lcaj_clpr,lcaj_idau,lcaj_form,lcaj_fope,lcaj_dcto,lcaj_tdoc,lcaj_codt,lcaj_ttar,lcaj_btar,lcaj_rtar,lcaj_efec)VALUES
    ('<<cfechas(this.dfecha)>>','','<<this.cdetalle>>',<<this.nidcta>>,<<this.ndebe>>,<<this.nhaber>>,'<<this.cmoneda>>',<<this.ndolar>>,
    <<goapp.nidusua>>,<<this.nidclpr>>,<<this.NAuto>>,'<<this.cforma>>',localtime,'<<this.ndoc>>','<<this.cTdoc>>',<<this.codt>>,'<<this.ctipotarjeta>>','<<this.cbcotarjeta>>','<<this.creftarjeta>>',<<this.nefectivo>>)
	ENDTEXT
	If This.Ejecutarsql(lc) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaDatosLCajaEFectivo11()
	lc = "ProIngresaDatosLcajaEefectivo11"
	If This.nidusua > 0 Then
		nidcajero = This.nidusua
	Else
		nidcajero = goapp.nidusua
	Endif
	TEXT To lp Noshow Textmerge
     ('<<cfechas(this.dfecha)>>','','<<this.cdetalle>>',<<this.nidcta>>,<<this.ndebe>>,<<this.nhaber>>,'<<this.cmoneda>>',<<this.ndolar>>,<<nidcajero>>,<<this.nidclpr>>,<<this.NAuto>>,'<<this.cforma>>','<<this.ndoc>>','<<this.cTdoc>>',<<this.codt>>)
	ENDTEXT
	If This.EJECUTARP(lc, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function saldoinicialporcajerotienda(nidus, df, df1, nidt)
	dFecha = Cfechas(fe_gene.fech)
	dfecha1 = Cfechas(Ctod("28/12/2017"))
	Ccursor = 'c_' + Sys(2015)
	TEXT To lc Noshow Textmerge
        select lcaj_idus,SUM(if(a.lcaj_deud<>0,lcaj_deud,-lcaj_acre)) as saldo
        FROM fe_lcaja  as a WHERE
        a.lcaj_fech between '<<dfecha1>>' and  '<<dfecha>>' and  a.lcaj_acti='A'  and  a.lcaj_form='E'  and  lcaj_idus=<<nidus>> and lcaj_codt=<<nidt>> group by lcaj_idus
	ENDTEXT
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return - 1
	Endif
	Select (Ccursor)
	nsaldo = Iif(Isnull(saldo), 0, saldo)
	Return nsaldo
	Endfunc
	Function TraspasoDatosLCajaE(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12)
	lc = "FunTraspasoDatosLcajaE"
	cur = 'c_' + Sys(2015)
	goapp.npara1 = np1
	goapp.npara2 = np2
	goapp.npara3 = np3
	goapp.npara4 = np4
	goapp.npara5 = np5
	goapp.npara6 = np6
	goapp.npara7 = np7
	goapp.npara8 = np8
	goapp.npara9 = np9
	goapp.npara10 = np10
	goapp.npara11 = np11
	goapp.npara12 = np12
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12)
	ENDTEXT
	nidc = This.EJECUTARf(lc, lp, cur)
	If nidc < 0 Then
		Return 0
	Endif
	Return nidc
	Endfunc
	Function logscaja(fi, F, Ccursor)
	Set DataSession To This.Idsesion
	dfi = Cfechas(fi)
	ff = F + 1
	dff = Cfechas(ff)
	TEXT To lc Noshow Textmerge
	SELECT a.lcaj_fech as fecha,x.nomb as usuario,a.lcaj_deta as detalle,acaj_fech as fechaoperacion,'' as autorizo,a.lcaj_mone as moneda,
	if(lcaj_deud>0,a.lcaj_deud,lcaj_acre) as importe,a.lcaj_dcto As documento FROM
	fe_lcaja as a
	inner join fe_acaja as b on b.acaj_caja=a.lcaj_idca
	inner join fe_usua as x on x.idusua=a.lcaj_idus
    WHERE a.lcaj_fech BETWEEN '<<dfi>>' AND '<<dff>>' order by lcaj_fech
	ENDTEXT
	If  This.EJECutaconsulta(lc, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function reportecaja0(dfi, dff, Calias)
	fi = Cfechas(dfi)
	ff = Cfechas(dff)
	Set DataSession To This.Idsesion
	TEXT To lc Noshow Textmerge
       select a.lcaj_ndoc,a.lcaj_fech,a.lcaj_deta,
	   c.ncta,c.nomb,if(lcaj_mone='S',a.lcaj_deud,ROUND(a.lcaj_deud*a.lcaj_dola,2)) as debe,
	   if(a.lcaj_mone='S',a.lcaj_acre,ROUND(a.lcaj_acre*a.lcaj_dola,2)) as haber,
	   a.lcaj_idct as idcta,lcaj_tran,if(lcaj_deud>0,'I','S') as tipomvto,'' as lcaj_dcto
	   from fe_lcaja as a
	   inner join fe_plan as c on c.idcta=a.lcaj_idct
	   where a.lcaj_acti='A' AND a.lcaj_fech between '<<fi>>' and '<<ff>>' order by a.lcaj_fech
	ENDTEXT
	If This.EJECutaconsulta(lc, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Saldoinicialcajaefectivo0(df)
	If !Pemstatus(goapp, 'proyecto', 5) Then
		AddProperty(goapp, 'proyecto', '')
	Endif
	F = Cfechas(df)
	Calias = 'c_' + Sys(2015)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
    \ Select Cast((Sum(If(lcaj_mone='S',a.lcaj_deud,Round(a.lcaj_deud*a.lcaj_dola,2)))-Sum(If(a.lcaj_mone='S',a.lcaj_acre,Round(a.lcaj_acre*a.lcaj_dola,2)))) As Decimal(12,2)) As si
	\ From fe_lcaja As a
	\ Where a.lcaj_acti='A' And a.lcaj_fech<'<<f>>' And lcaj_idct>0
	If Alltrim(goapp.proyecto) == 'psys' Then
	 \ And (lcaj_deud>0 Or lcaj_acre>0)
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, (Calias)) < 1 Then
		Return 0
	Endif
	Select (Calias)
	nsaldo = Iif(Isnull(si), 0, si)
*!*		MESSAGEBOX(lc)
	Return nsaldo
	Endfunc
	Function IngresaDatosLCajaECreditos(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13)
	lc = "FunIngresaDatosLcajaECreditos"
	cur = "Cred"
	goapp.npara1 = np1
	goapp.npara2 = np2
	goapp.npara3 = np3
	goapp.npara4 = np4
	goapp.npara5 = np5
	goapp.npara6 = np6
	goapp.npara7 = np7
	goapp.npara8 = np8
	goapp.npara9 = np9
	goapp.npara10 = np10
	goapp.npara11 = np11
	goapp.npara12 = np12
	goapp.npara13 = np13
	TEXT To lp Noshow
    (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7, ?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
	ENDTEXT
	If This.EJECUTARf(lc, lp, cur) < 1 Then
		Return 0
	Endif
	Return cred.Id
	Endfunc
	Function DesactivaCajaEfectivoDe(np1)
	lc = 'ProDesactivaCajaEfectivoDe'
	goapp.npara1 = np1
	TEXT To lp Noshow
	     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(lc, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function DesactivaCajaEfectivoCr(np1)
	lc = 'ProDesactivaCajaEfectivoCr'
	goapp.npara1 = np1
	TEXT To lp Noshow
	     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(lc, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function resumenporcajero(Ccursor)
	fi = Cfechas(This.dfi)
	ff = Cfechas(This.dff)
	TEXT To lc Noshow Textmerge
	  select nomb,saldo,lcaj_idus FROM (
	  SELECT SUM(if(a.lcaj_deud<>0,lcaj_deud,-lcaj_acre)) as saldo,lcaj_idus
      FROM fe_lcaja  as a
      WHERE  a.lcaj_fech between '<<fi>>' and '<<ff>>' and a.lcaj_acti='A' and a.lcaj_form='E'  group by lcaj_idus) as c
      inner join fe_usua as u on u.idusua=c.lcaj_idus order by nomb
	ENDTEXT
	If This.EJECutaconsulta(lc, "tc") < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function historialporcajero(df1, df2, Ccursor)
	f1 = Cfechas(df1)
	f2 = Cfechas(df2)
	Ccursor1 = 'c_' + Sys(2015)
	TEXT To lc Noshow Textmerge Pretext 7
	    select SUM(if(a.lcaj_deud<>0,lcaj_deud,0)) as ingresoss,SUM(if(a.lcaj_acre<>0,lcaj_acre,0)) as egresoss
	    FROM fe_lcaja  as a WHERE  a.lcaj_fech between '<<f1>>' and '<<f2>>'  and a.lcaj_acti='A' and a.lcaj_form='E'
	    and lcaj_idus=<<this.nidusua>>  and lcaj_mone='<<this.cmoneda>>' group by lcaj_idus
	ENDTEXT
	If This.EJECutaconsulta(lc, Ccursor1) < 1 Then
		Return 0
	Endif
	Select (Ccursor1)
	nsaldo = ingresoss - egresoss
	dfi = Cfechas(This.dfi)
	dff = Cfechas(This.dff)
	TEXT To lc Noshow Textmerge
	    select lcaj_fech as fech,round(SUM(if(lcaj_deud<>0,lcaj_deud,0)),2) as ingresos,round(SUM(if(a.lcaj_acre<>0,lcaj_acre,0)),2) as egresos
        FROM  fe_lcaja  as a WHERE  a.lcaj_fech between '<<dfi>>' and '<<dff>>' and a.lcaj_acti='A' and a.lcaj_form='E' and lcaj_idus=<<this.nidusua>> Group by lcaj_idus,lcaj_fech
	ENDTEXT
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Select fech, Ingresos, egresos, Ingresos - egresos As saldo, nidusuario As idus From (Ccursor) Into Cursor rcaja Readwrite Order By fech
	Select rcaja
	Do While !Eof()
		nsaldo = nsaldo + (rcaja.Ingresos - rcaja.egresos)
		Replace saldo With nsaldo
		Select rcaja
		Skip
	Enddo
	Return 1
	Endfunc
	Function liquidapsystr(Ccursor)
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	f11 = Cfechas(This.dffi)
	f12 = Cfechas(This.dfff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select  Sum(If(a.lcaj_deud<>0,lcaj_deud,0)) As ingresoss,Sum(If(a.lcaj_acre<>0,lcaj_acre,0)) As egresoss
	\From fe_lcaja  As a Where  a.lcaj_fech Between '<<f1>>' And '<<f2>>' And a.lcaj_acti='A' And a.lcaj_form='E'
	If This.nidusua > 0 Then
	 \ And lcaj_idus=<<This.nidusua>>
	Endif
	\Group By lcaj_idus
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, "tc1") < 1
		This.conerror = 1
		Return 0
	Endif
	This.nsaldoinicial = tc1.ingresoss - tc1.egresoss
	F = Cfechas(This.dFecha)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select  Deta,Ndoc,
	\		Round(Case Forma When 'E' Then If(tipo='I',Impo,0) Else 0 End,2) As efectivo,
	\		Round(Case Forma When 'C' Then If(tipo='I',Impo,0) Else 0 End,2) As credito,
	\		Round(Case Forma When 'D' Then If(tipo='I',Impo,0) Else 0 End,2) As deposito,
	\		Round(Case Forma When 'H' Then If(tipo='I',Impo,0) Else 0 End,2) As cheque,
	\		Round(Case Forma When 'T' Then If(tipo='I',Impo,0) Else 0 End,2) As tarjeta,
	\		Round(Case Forma When 'R' Then If(tipo='I',Impo,0) Else 0 End,2) As Centrega,
	\		Round(Case Forma When 'Y' Then If(tipo='I',Impo,0) Else 0 End,2) As Yape,
	\		Round(Case tipo When 'S' Then If(Forma='E',Impo,0) Else 0 End,2) As egresos,
	\		usuavtas,fechao,vendedor,lcaj_fech,usua,Forma,mone,tmon1,dola,nimpo,tipo,tdoc,idcredito,iddeudas,idauto,orden
	\		From(
	\		Select a.lcaj_tdoc As tdoc,a.lcaj_form As Forma,If(lcaj_deud<>0,'I',If(lcaj_acre=0,'I','S')) As tipo,lcaj_dcto As Ndoc,
	\		If(lcaj_deud<>0,lcaj_deud,If(lcaj_acre=0,lcaj_deud,lcaj_acre)) As Impo,
    \        lcaj_deta As Deta,lcaj_mone As  mone,lcaj_idcr As idcredito,lcaj_idde As iddeudas,lcaj_idau As idauto,
	\		c.nomb As usua,a.lcaj_fope As fechao,ifnull(u.nomb,'') As usuavtas,a.lcaj_mone As tmon1,lcaj_dola As dola,If(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) As nimpo,lcaj_fech,
	\		'1' As orden,ifnull(z.nomv,'') As vendedor From fe_lcaja As a
	\		inner Join fe_usua As c On 	c.idusua=a.lcaj_idus
	\		Left Join fe_rcom As r On r.idauto=a.lcaj_idau
	\		Left Join fe_usua As u  On u.idusua=r.idusua
	\       Left Join (Select idauto,codv From fe_kar Where Acti='A'  Group By idauto,codv)  As p On p.idauto=a.lcaj_idau
	\       Left Join fe_vend As z On z.idven=p.codv
	\		Where
	If This.confechas = 0 Then
	     \ lcaj_fech='<<f>>'
	Else
	     \ lcaj_fech Between '<<f11>>' And '<<f12>>'
	Endif
	\And lcaj_acti<>'I' And lcaj_idau>0
	If This.nidusua > 0 Then
	 \ And a.lcaj_idus=<<This.nidusua>>
	Endif
	\		Union All
	\		Select a.lcaj_tdoc,a.lcaj_form As Forma,If(lcaj_deud<>0,'I','S') As tipo,a.lcaj_ndoc As Ndoc,If(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) As Impo,
    \       a.lcaj_deta As Deta,a.lcaj_mone As mone,lcaj_idcr As idcredito,lcaj_idde As iddeudas,lcaj_idau As idauto,
	\		c.nomb As usua,a.lcaj_fope As fechao,ifnull(u.nomb,'') As usuavtas,a.lcaj_mone As tmon1,a.lcaj_dola As dola,a.lcaj_deud As nimpo,a.lcaj_fech,
	\		If(lcaj_deud>0,'2','3') As orden ,'' As vendedor From  fe_lcaja As a
	\		inner Join fe_usua As c On c.idusua=a.lcaj_idus
	\		Left Join fe_rcom As r On r.idauto=a.lcaj_idau
	\		Left Join fe_usua As u  On u.idusua=r.idusua
	\		Where
	If This.confechas = 0 Then
	     \ lcaj_fech='<<f>>'
	Else
	     \ lcaj_fech Between '<<f11>>' And '<<f12>>'
	Endif
	\And lcaj_acti<>'I' And lcaj_idau=0
	If This.nidusua > 0 Then
	 \ And a.lcaj_idus=<<This.nidusua>>
	Endif
	\)  As b Order By orden,Ndoc,tdoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listatarjetas(Calias)
	fi = Cfechas(This.dfi)
	ff = Cfechas(This.dff)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
		\	 Select lcaj_dcto As dcto,lcaj_deud-lcaj_efec As importe,lcaj_btar As banco,lcaj_ttar As tipo,lcaj_rtar As referencia,lcaj_deta As detalle,T.nomb As tienda,
		\	 lcaj_fope
		\	 From fe_lcaja As l inner Join fe_sucu As T On T.idalma=l.lcaj_codt
		\	 Where lcaj_form='<<this.cforma>>' And lcaj_acti='A' And lcaj_idau>0 And lcaj_fech Between '<<fi>>' And '<<ff>>'
	If This.codt > 0 Then
	\ And lcaj_codt=<<This.codt>>
	Endif
    \ Order By lcaj_fech,lcaj_dcto
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function  liquidapsysg(Ccursor)
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select  Sum(If(a.lcaj_deud<>0,lcaj_deud,0)) As ingresoss,Sum(If(a.lcaj_acre<>0,lcaj_acre,0)) As egresoss
	\From fe_lcaja  As a Where  a.lcaj_fech Between '<<f1>>' And '<<f2>>' And a.lcaj_acti='A' And a.lcaj_form='E'
	If This.nidusua > 0 Then
	 \ And lcaj_idus=<<This.nidusua>>
	Endif
	If This.codt > 0 Then
	  \ And lcaj_codt=<<This.codt>>
	Endif
	\Group By lcaj_idus
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, "tc1") < 1
		This.conerror = 1
		Return 0
	Endif
	This.nsaldoinicial = tc1.ingresoss - tc1.egresoss
	F = Cfechas(This.dFecha)
	Set  Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	    \   Select Deta,Ndoc,
		\	Round(Case Forma When 'E' Then If(tipo='I',Impo,0) Else 0 End,2) As efectivo,
		\	Round(Case Forma When 'C' Then If(tipo='I',Impo,0) Else 0 End,2) As credito,
		\	Round(Case Forma When 'D' Then If(tipo='I',Impo,0) Else 0 End,2) As deposito,
		\	Round(Case Forma When 'T' Then If(tipo='I',Impo,0) Else 0 End,2) As tarjeta,
		\	Round(Case Forma When 'R' Then If(tipo='I',Impo,0) Else 0 End,2) As Centrega,
		\	Round(Case Forma When 'Y' Then If(tipo='I',Impo,0) Else 0 End,2) As Yape,
		\	Round(Case Forma When 'P' Then If(tipo='I',Impo,0) Else 0 End,2) As Plin,
		\	Round(Case tipo When 'S' Then If(Forma='E',Impo,0) Else 0 End,2) As egresos,
		\	usua,fechao,usuavtas,lcaj_ndoc,Forma,mone,tmon1,dola,nimpo,tipo,tdoc,idcredito,iddeudas,idauto,Impo As timpo,Cast(0 As Decimal(8,2)) As cheque
		\	From (Select a.lcaj_tdoc As tdoc,a.lcaj_form As Forma,If(lcaj_deud<>0,'I',If(lcaj_acre=0,'I','S')) As tipo,
		\	If(Left(lcaj_dcto,1)='0',Concat(If(lcaj_tdoc='01','F/.',If(lcaj_tdoc='03','B/.','P/.')),lcaj_dcto),lcaj_dcto) As Ndoc,
		\	If(lcaj_deud<>0,lcaj_deud,If(lcaj_acre=0,lcaj_deud,lcaj_acre)) As Impo,
        \   lcaj_deta As Deta,lcaj_mone As  mone,lcaj_idcr As idcredito,lcaj_idde As iddeudas,lcaj_idau As idauto,
		\	c.nomb As usua,a.lcaj_fope As fechao,ifnull(z.nomv,'') As usuavtas,a.lcaj_mone As tmon1,lcaj_dola As dola,If(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) As nimpo,lcaj_ndoc From
		\	fe_lcaja As a
		\	inner Join fe_usua As c On c.idusua=a.lcaj_idus
	    \	Left Join rvendedores As p On p.idauto=a.lcaj_idau
		\	Left Join fe_vend As z On z.idven=p.codv
		\	Where lcaj_fech='<<f>>' And lcaj_acti<>'I' And lcaj_idau>0
	If This.codt > 0 Then
		   \ And lcaj_codt=<<This.codt>>
	Endif
	If This.nidusua > 0 Then
		 \ And a.lcaj_idus=<<This.nidusua>>
	Endif
		\	Union All
		\	Select a.lcaj_tdoc,a.lcaj_form As Forma,If(lcaj_deud<>0,'I','S') As tipo,a.lcaj_dcto As Ndoc,If(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) As Impo,
        \    a.lcaj_deta As Deta,a.lcaj_mone As mone,lcaj_idcr As idcredito,lcaj_idde As iddeudas,lcaj_idau As idauto,
		\	c.nomb As usua,a.lcaj_fope As fechao,ifnull(z.nomv,'') As usuavtas,a.lcaj_mone As tmon1,a.lcaj_dola As dola,a.lcaj_deud As nimpo,lcaj_ndoc From
		\	fe_lcaja As a
		\	inner Join fe_usua As c On c.idusua=a.lcaj_idus
		\	Left Join rvendedores As p On p.idauto=a.lcaj_idau
		\	Left Join fe_vend As z On z.idven=p.codv
		\	Where lcaj_fech='<<f>>' And lcaj_acti<>'I' And lcaj_idau=0 And a.lcaj_idus=<<nidusuario>>)
		\	As b Order By tipo,Ndoc,tdoc
	Set Textmerge Off
	Set Textmerge To
	ante = 1
	If This.EJECutaconsulta(lc, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarcobranzapsysl(df, cforma, Ccursor)
	ff = Cfechas(df)
	TEXT To lc Noshow Textmerge
            select '' as t,lcaj_dcto as ndoc,lcaj_fech as fech,lcaj_deta as deta,if(lcaj_deud1>0,lcaj_deud1,lcaj_acre1) as caja_impo,
            lcaj_idcr as idcred,c.ncontrol,lcaj_idca as idcaja,if(lcaj_deud1>0,'I','S') as tipo
            FROM fe_lcaja  as l
            left join fe_cred c on c.idcred=l.lcaj_idcr
            WHERE lcaj_fech='<<ff>>' AND lcaj_idc1=<<idv>> AND lcaj_acti='A' AND (lcaj_deud=0 or lcaj_acre=0)
            and (lcaj_deud1>0 or lcaj_acre1>0)  and lcaj_form='<<cforma>>' order by lcaj_idca,tipo
	ENDTEXT
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function desactivaropcaja(np1)
	If np1 > 0 Then
		TEXT To lc Noshow Textmerge
          UPDATE fe_lcaja SET lcaj_acti='I' WHERE lcaj_idac=<<np1>>
		ENDTEXT
		If This.Ejecutarsql(lc) < 1 Then
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function desactivaropcaja1(np1)
	If np1 > 0 Then
		TEXT To lc Noshow Textmerge
          UPDATE fe_lcaja SET lcaj_acti='I' WHERE lcaj_idau=<<np1>>
		ENDTEXT
		If This.Ejecutarsql(lc) < 1 Then
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function TraspasoDatosLCajaEMas()
	lc = "FunTraspasoDatosLcajaE"
	cur = 'c_' + Sys(2015)
	goapp.npara1 = This.dFecha
	goapp.npara2 = This.Ndoc
	goapp.npara3 = This.cdetalle
	goapp.npara4 = This.nidcta
	goapp.npara5 = This.ndebe
	goapp.npara6 = This.nhaber
	goapp.npara7 = This.Cmoneda
	goapp.npara8 = This.ndolar
	goapp.npara9 = This.nidusua
	goapp.npara10 = This.nidclpr
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
	ENDTEXT
	nidc = This.EJECUTARf(lc, lp, cur)
	If nidc < 0 Then
		Return 0
	Endif
	Return nidc
	Endfunc
	Function TraspasoDatosLCajaEMasConBancos(obcos)
	Set Procedure To d:\capass\modelos\correlativos Additive
	ocorr = Createobject("correlativo")
	ocorr.Ndoc = obcos.cndoc
	ocorr.Nsgte = obcos.Nsgte
	ocorr.Idserie = obcos.Idserie
	If This.iniciaTransaccion() < 1 Then
		Return 0
	Endif
	nidr = This.TraspasoDatosLCajaEMas()
	If m.nidr < 1 Then
		This.deshacerCambios()
		Return  0
	Endif
	obcos.idcajae = m.nidr
	If obcos.registratraspasodesdeLCajaefectivo() < 1 Then
		This.cmensaje = obcos.cmensaje
		Return 0
	Endif
	If ocorr.GeneraCorrelativo() < 1 Then
		This.cmensaje = ocorr.cmensaje
		This.deshacerCambios()
		Return 0
	Endif
	If This.GrabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function reportecajapsys(Ccursor)
	df1 = Cfechas(This.dfi)
	df2 = Cfechas(This.dff)
	TEXT To lc Noshow Textmerge
	   select a.lcaj_ndoc,a.lcaj_fech,a.lcaj_deta,
	   c.ncta,c.nomb,if(lcaj_mone='S',a.lcaj_deud,ROUND(a.lcaj_deud*a.lcaj_dola,2)) as debe,
	   if(a.lcaj_mone='S',a.lcaj_acre,ROUND(a.lcaj_acre*a.lcaj_dola,2)) as haber,ifnull(f.razo,'') as cliente,
	   ifnull(g.razo,'') as proveedor,a.lcaj_idct as idcta,lcaj_tran,a.lcaj_idca
	   from fe_lcaja as a
	   inner join fe_plan as c on c.idcta=a.lcaj_idct
	   left join vlcajacl as f on f.lcaj_idca=a.lcaj_idca
	   left join vlcajapr as g on g.lcaj_idca=a.lcaj_idca
	   where a.lcaj_acti='A' AND a.lcaj_fech between '<<df1>>' and  '<<df2>>'   order by a.lcaj_fech,lcaj_ndoc
	ENDTEXT
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function resumencajaingresos(Ccursor)
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	f11 = Cfechas(This.dffi)
	f12 = Cfechas(This.dfff)
	This.dFecha  = This.dfi
	This.nsaldoinicial = 0  &&This.saldoanteriorpsysrx()
&& ,usuavtas,fechao,vendedor,lcaj_fech,usua,Forma,mone,orden
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select  Deta,Ndoc,
	\		Round(Case Forma When 'E' Then If(tipo='I',Impo,0) Else 0 End,2) As efectivo,
	\		Round(Case Forma When 'C' Then If(tipo='I',Impo,0) Else 0 End,2) As credito,
	\		Round(Case Forma When 'D' Then If(tipo='I',Impo,0) Else 0 End,2) As deposito,
	\		Round(Case Forma When 'H' Then If(tipo='I',Impo,0) Else 0 End,2) As cheque,
	\		Round(Case Forma When 'T' Then If(tipo='I',Impo,0) Else 0 End,2) As tarjeta,
	\		Round(Case Forma When 'R' Then If(tipo='I',Impo,0) Else 0 End,2) As Centrega,
	\		Round(Case Forma When 'Y' Then If(tipo='I',Impo,0) Else 0 End,2) As Yape,
	\		Round(Case tipo When 'S' Then If(Forma='E',Impo,0) Else 0 End,2) As egresos,usuavtas,fechao,vendedor,lcaj_fech,usua,Forma,mone,idauto
	\		From(
	\		Select a.lcaj_tdoc As tdoc,a.lcaj_form As Forma,If(lcaj_deud<>0,'I',If(lcaj_acre=0,'I','S')) As tipo,lcaj_dcto As Ndoc,
	\		If(lcaj_deud<>0,lcaj_deud,If(lcaj_acre=0,lcaj_deud,lcaj_acre)) As Impo,
    \        lcaj_deta As Deta,lcaj_mone As  mone,lcaj_idcr As idcredito,lcaj_idde As iddeudas,lcaj_idau As idauto,
	\		c.nomb As usua,a.lcaj_fope As fechao,ifnull(u.nomb,'') As usuavtas,a.lcaj_mone As tmon1,lcaj_dola As dola,If(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) As nimpo,lcaj_fech,
	\		'1' As orden,ifnull(z.nomv,'') As vendedor From fe_lcaja As a
	\		inner Join fe_usua As c On 	c.idusua=a.lcaj_idus
	\		Left Join fe_rcom As r On r.idauto=a.lcaj_idau
	\		Left Join fe_usua As u  On u.idusua=r.idusua
	\       Left Join (Select idauto,codv From fe_kar Where Acti='A'  Group By idauto,codv)  As p On p.idauto=a.lcaj_idau
	\       Left Join fe_vend As z On z.idven=p.codv
	\		Where  lcaj_fech Between '<<f11>>' And '<<f12>>' And lcaj_acti<>'I' And lcaj_idau>0 and lcaj_deud<>0
	If This.codt > 0 Then
	 \ And a.lcaj_codt=<<This.codt>>
	Endif
   \)  As b Order By orden,Ndoc,tdoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function saldoanteriorpsysrx()
	If !Pemstatus(goapp, 'soloestatienda', 5) Then
		AddProperty(goapp, 'soloestatienda', 0)
	Endif
	If goapp.Soloestatienda = 1 And  This.codt <> goapp.tienda Then
		This.cmensaje = 'NO Permitido'
		Return 0
	Endif
	lc = 'FunSaldoCaja'
	Calias = 'c_' + Sys(2015)
	dFecha = Cfechas(This.dFecha)
	TEXT To lp Noshow Textmerge
     ('<<dfecha>>',<<this.codt>>)
	ENDTEXT
	If This.EJECUTARf(lc, lp, Calias) < 1 Then
		If This.conerror = 1 Then
			Return - 1
		Endif
	Endif
	Select (Calias)
	nsaldo = Iif(Isnull(Id), 0, Id)
	Return nsaldo
	Endfunc
	Function PermiteIngresoACaja(df)
	Ccursor='c_'+Sys(2015)
	lc = 'FunVerificaCaja'
	goapp.npara1=df
	TEXT To lp Noshow Textmerge
     (?goapp.npara1)
	ENDTEXT
	nid=This.EJECUTARf(lc,lp,Ccursor)
	If m.nid<0 Then
		Return 0
	Endif
	Select (Ccursor)
	If nid>0 Then
		this.cmensaje=' En este fecha no se permite Registros '
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine

























