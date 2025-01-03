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
	Function ReporteCajaEfectivo(dfi, dff, Calias)
	Local lC
	fi = Cfechas(dfi)
	ff = Cfechas(dff)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lC Noshow Textmerge
	   Select a.lcaj_ndoc,a.lcaj_fech,a.lcaj_deta,
	   c.ncta,c.nomb,If(lcaj_mone='S',a.lcaj_deud,Round(a.lcaj_deud*a.lcaj_dola,2)) As debe,
	   If(a.lcaj_mone='S',a.lcaj_acre,Round(a.lcaj_acre*a.lcaj_dola,2)) As haber,
		a.lcaj_idct As idcta,lcaj_tran,If(lcaj_deud>0,'I','S') As tipomvto,lcaj_idca,lcaj_dcto
		From fe_lcaja As a
		inner Join fe_plan As c On c.idcta=a.lcaj_idct
		Where a.lcaj_acti='A' And a.lcaj_fech Between '<<fi>>' And '<<ff>>'  And (lcaj_form='E' OR (lcaj_form='T' AND lcaj_deud>0)) Order By a.lcaj_fech
	Endtext
	If This.EJECutaconsulta(lC, (Calias)) < 1 Then
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
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\    Select a.lcaj_ndoc,a.lcaj_fech,a.lcaj_deta,
	\    c.ncta,c.nomb,If(lcaj_mone='S',a.lcaj_deud,Round(a.lcaj_deud*a.lcaj_dola,2)) As debe,
	\    If(a.lcaj_mone='S',a.lcaj_acre,Round(a.lcaj_acre*a.lcaj_dola,2)) As haber,
	\    a.lcaj_idct As idcta,lcaj_tran,If(lcaj_deud>0,'I','S') As tipomvto,lcaj_idca,lcaj_dcto
    \	 From fe_lcaja As a
	\	inner Join fe_plan As c On c.idcta=a.lcaj_idct
	\	Where a.lcaj_acti='A' And a.lcaj_fech Between '<<fi>>' And '<<ff>>'  And lcaj_form='E'
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And a.lcaj_codt=<<goapp.tienda>>
		Else
	      \And a.lcaj_codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	\Order By a.lcaj_fech
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, (Calias)) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Saldoinicialcajaefectivo10(Df)
	F = Cfechas(Df)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \ Select
    \ Cast((Sum(If(lcaj_mone='S',a.lcaj_deud,Round(a.lcaj_deud*a.lcaj_dola,2)))-Sum(If(a.lcaj_mone='S',a.lcaj_acre,Round(a.lcaj_acre*a.lcaj_dola,2)))) As Decimal(12,2)) As si
	\ From fe_lcaja As a
	\ Where a.lcaj_acti='A' And a.lcaj_fech<'<<f>>'  And lcaj_idct>0 And lcaj_form='E'
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And a.lcaj_codt=<<goapp.tienda>>
		Else
	      \And a.lcaj_codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, 'iniciocaja') < 1 Then
		Return 0
	Endif
	Return Iif(Isnull(iniciocaja.si), 0, iniciocaja.si)
	Endfunc
	Function Saldoinicialcajaefectivo(Df)
	F = Cfechas(Df)
	Text To lC Noshow Textmerge Pretext 7
     SELECT
     CAST((SUM(IF(lcaj_mone='S',a.lcaj_deud,ROUND(a.lcaj_deud*a.lcaj_dola,2)))-SUM(IF(a.lcaj_mone='S',a.lcaj_acre,ROUND(a.lcaj_acre*a.lcaj_dola,2)))) as decimal(12,2)) AS si
	 FROM fe_lcaja AS a
	 WHERE a.lcaj_acti='A' AND a.lcaj_fech<'<<f>>'  AND lcaj_idct>0 AND (lcaj_form='E' OR (lcaj_form='T' AND lcaj_deud>0))
	Endtext
	If This.EJECutaconsulta(lC, 'iniciocaja') < 1 Then
		Return 0
	Endif
	Return Iif(Isnull(iniciocaja.si), 0, iniciocaja.si)
	Endfunc
	Function IngresaDatosLCajaEe(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10)
	lC = "FunIngresaDatosLcajaEe"
	cur = "Ca"
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
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
	Endtext
	nidpc = This.EJECUTARf(lC, lp, cur)
	If nidpc < 0 Then
		Return 0
	Else
		Return nidpc
	Endif
	Endfunc
	Function IngresaDatosLCajaEFectivo11(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14)
	lC = "ProIngresaDatosLcajaEefectivo"
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
	goApp.npara15 = goApp.Tienda
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
	Endtext
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaDatosLCajaEFectivo10()
	lC = "ProIngresaDatosLcajaEefectivo"
	Text To lp Noshow Textmerge
     ('<<cfechas(this.dfecha)>>','','<<this.cdetalle>>',<<this.nidcta>>,<<this.ndebe>>,<<this.nhaber>>,'<<this.cmoneda>>',<<this.ndolar>>,<<goapp.nidusua>>,<<this.nidclpr>>,<<this.NAuto>>,'<<this.cforma>>','<<this.ndoc>>','<<this.cTdoc>>')
	Endtext
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaCajaTarjetaEfectivopsysrx()
	Text To lC Noshow Textmerge
	INSERT INTO fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
    lcaj_idus,lcaj_clpr,lcaj_idau,lcaj_form,lcaj_fope,lcaj_dcto,lcaj_tdoc,lcaj_codt,lcaj_ttar,lcaj_btar,lcaj_rtar,lcaj_efec)VALUES
    ('<<cfechas(this.dfecha)>>','','<<this.cdetalle>>',<<this.nidcta>>,<<this.ndebe>>,<<this.nhaber>>,'<<this.cmoneda>>',<<this.ndolar>>,
    <<goapp.nidusua>>,<<this.nidclpr>>,<<this.NAuto>>,'<<this.cforma>>',localtime,'<<this.ndoc>>','<<this.cTdoc>>',<<this.codt>>,'<<this.ctipotarjeta>>','<<this.cbcotarjeta>>','<<this.creftarjeta>>',<<this.nefectivo>>)
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaDatosLCajaEFectivo11()
	lC = "ProIngresaDatosLcajaEefectivo11"
	Text To lp Noshow Textmerge
     ('<<cfechas(this.dfecha)>>','','<<this.cdetalle>>',<<this.nidcta>>,<<this.ndebe>>,<<this.nhaber>>,'<<this.cmoneda>>',<<this.ndolar>>,<<goapp.nidusua>>,<<this.nidclpr>>,<<this.NAuto>>,'<<this.cforma>>','<<this.ndoc>>','<<this.cTdoc>>',<<this.codt>>)
	Endtext
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function saldoinicialporcajerotienda(nidus, Df, df1, nidt)
	dFecha = Cfechas(fe_gene.fech)
	dfecha1 = Cfechas(Ctod("28/12/2017"))
	Ccursor = 'c_' + Sys(2015)
	Text To lC Noshow Textmerge
        select lcaj_idus,SUM(if(a.lcaj_deud<>0,lcaj_deud,-lcaj_acre)) as saldo
        FROM fe_lcaja  as a WHERE
        a.lcaj_fech between '<<dfecha1>>' and  '<<dfecha>>' and  a.lcaj_acti='A'  and  a.lcaj_form='E'  and  lcaj_idus=<<nidus>> and lcaj_codt=<<nidt>> group by lcaj_idus
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return - 1
	Endif
	Select (Ccursor)
	nsaldo = Iif(Isnull(saldo), 0, saldo)
	Return nsaldo
	Endfunc
	Function TraspasoDatosLCajaE(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12)
	lC = "FunTraspasoDatosLcajaE"
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
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12)
	Endtext
	nidc = This.EJECUTARf(lC, lp, cur)
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
	Text To lC Noshow Textmerge
	SELECT a.lcaj_fech as fecha,x.nomb as usuario,a.lcaj_deta as detalle,acaj_fech as fechaoperacion,'' as autorizo,a.lcaj_mone as moneda,
	if(lcaj_deud>0,a.lcaj_deud,lcaj_acre) as importe,a.lcaj_dcto As documento FROM
	fe_lcaja as a
	inner join fe_acaja as b on b.acaj_caja=a.lcaj_idca
	inner join fe_usua as x on x.idusua=a.lcaj_idus
    WHERE a.lcaj_fech BETWEEN '<<dfi>>' AND '<<dff>>' order by lcaj_fech
	Endtext
	If  This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function reportecaja0(dfi, dff, Calias)
	fi = Cfechas(dfi)
	ff = Cfechas(dff)
	Set DataSession To This.Idsesion
	Text To lC Noshow Textmerge
	       select a.lcaj_ndoc,a.lcaj_fech,a.lcaj_deta,
		   c.ncta,c.nomb,if(lcaj_mone='S',a.lcaj_deud,ROUND(a.lcaj_deud*a.lcaj_dola,2)) as debe,
		   if(a.lcaj_mone='S',a.lcaj_acre,ROUND(a.lcaj_acre*a.lcaj_dola,2)) as haber,
		   a.lcaj_idct as idcta,lcaj_tran,if(lcaj_deud>0,'I','S') as tipomvto,'' as lcaj_dcto
		   from fe_lcaja as a
		   inner join fe_plan as c on c.idcta=a.lcaj_idct
		   where a.lcaj_acti='A' AND a.lcaj_fech between '<<fi>>' and '<<ff>>' order by a.lcaj_fech
	Endtext
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Saldoinicialcajaefectivo0(Df)
	F = Cfechas(Df)
	Calias = 'c_' + Sys(2015)
	Text To lC Noshow Textmerge Pretext 7
     SELECT CAST((SUM(IF(lcaj_mone='S',a.lcaj_deud,ROUND(a.lcaj_deud*a.lcaj_dola,2)))-SUM(IF(a.lcaj_mone='S',a.lcaj_acre,ROUND(a.lcaj_acre*a.lcaj_dola,2)))) as decimal(12,2)) AS si
	 FROM fe_lcaja AS a
	 WHERE a.lcaj_acti='A' AND a.lcaj_fech<'<<f>>' AND lcaj_idct>0
	Endtext
	If This.EJECutaconsulta(lC, (Calias)) < 1 Then
		Return 0
	Endif
	Select (Calias)
	nsaldo = Iif(Isnull(si), 0, si)
	Return nsaldo
	Endfunc
	Function IngresaDatosLCajaECreditos(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13)
	lC = "FunIngresaDatosLcajaECreditos"
	cur = "Cred"
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
	Text To lp Noshow
    (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7, ?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
	Endtext
	If This.EJECUTARf(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return cred.Id
	Endfunc
	Function DesactivaCajaEfectivoDe(np1)
	lC = 'ProDesactivaCajaEfectivoDe'
	goApp.npara1 = np1
	Text To lp Noshow
	     (?goapp.npara1)
	Endtext
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function resumenporcajero(Ccursor)
	fi = Cfechas(This.dfi)
	ff = Cfechas(This.dff)
	Text To lC Noshow Textmerge
	  select nomb,saldo,lcaj_idus FROM (
	  SELECT SUM(if(a.lcaj_deud<>0,lcaj_deud,-lcaj_acre)) as saldo,lcaj_idus
      FROM fe_lcaja  as a
      WHERE  a.lcaj_fech between '<<fi>>' and '<<ff>>' and a.lcaj_acti='A' and a.lcaj_form='E'  group by lcaj_idus) as c
      inner join fe_usua as u on u.idusua=c.lcaj_idus
	Endtext
	If This.EJECutaconsulta(lC, "tc") < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function historialporcajero(df1, df2, Ccursor)
	f1 = Cfechas(df1)
	f2 = Cfechas(df2)
	Ccursor1 = 'c_' + Sys(2015)
	Text To lC Noshow Textmerge Pretext 7
	    select SUM(if(a.lcaj_deud<>0,lcaj_deud,0)) as ingresoss,SUM(if(a.lcaj_acre<>0,lcaj_acre,0)) as egresoss
	    FROM fe_lcaja  as a WHERE  a.lcaj_fech between '<<f1>>' and '<<f2>>'  and a.lcaj_acti='A' and a.lcaj_form='E'
	    and lcaj_idus=<<this.nidusua>>  and lcaj_mone='<<this.cmoneda>>' group by lcaj_idus
	Endtext
	If This.EJECutaconsulta(lC, Ccursor1) < 1 Then
		Return 0
	Endif
	Select (Ccursor1)
	nsaldo = ingresoss - egresoss
	dfi = Cfechas(This.dfi)
	dff = Cfechas(This.dff)
	Text To lC Noshow Textmerge
	    select lcaj_fech as fech,round(SUM(if(lcaj_deud<>0,lcaj_deud,0)),2) as ingresos,round(SUM(if(a.lcaj_acre<>0,lcaj_acre,0)),2) as egresos
        FROM  fe_lcaja  as a WHERE  a.lcaj_fech between '<<dfi>>' and '<<dff>>' and a.lcaj_acti='A' and a.lcaj_form='E' and lcaj_idus=<<this.nidusua>> Group by lcaj_idus,lcaj_fech
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
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
*!*		If goApp.Cdatos = 'S' Then
*!*		\And lcaj_codt=<<This.codt>>
*!*		Endif
*!*		If goApp.Cdatos = 'S' Then
*!*		\And lcaj_codt=<<this.codt>>
*!*		Endif
	f12 = Cfechas(This.dfff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select  Sum(If(a.lcaj_deud<>0,lcaj_deud,0)) As ingresoss,Sum(If(a.lcaj_acre<>0,lcaj_acre,0)) As egresoss
	\From fe_lcaja  As a Where  a.lcaj_fech Between '<<f1>>' And '<<f2>>' And a.lcaj_acti='A' And a.lcaj_form='E' 
	IF this.nidusua>0 then
	 \ And lcaj_idus=<<This.nidusua>>
	ENDIF 
	\Group By lcaj_idus
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, "tc1") < 1
		This.conerror = 1
		Return 0
	Endif
	This.nsaldoinicial = tc1.ingresoss - tc1.egresoss
	F = Cfechas(This.dFecha)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
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
	\       Left Join (Select idauto,codv From fe_kar Group By idauto,codv)  As p On p.idauto=a.lcaj_idau
	\       Left Join fe_vend As z On z.idven=p.codv
	\		Where
	If This.confechas = 0 Then
	     \ lcaj_fech='<<f>>'
	Else
	     \ lcaj_fech Between '<<f11>>' And '<<f12>>'
	Endif
	\And lcaj_acti<>'I' And lcaj_idau>0 
	IF this.nidusua>0 then
	 \ And a.lcaj_idus=<<This.nidusua>>
	ENDIF 
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
	IF this.nidusua>0 then
	 \ And a.lcaj_idus=<<This.nidusua>>
	ENDIF 
	\)  As b Order By orden,Ndoc,tdoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
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
	Set Textmerge To Memvar lC Noshow Textmerge
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
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine













