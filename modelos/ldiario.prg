Define Class Ldiario As OData Of "d:\capass\database\data.prg"
	urlenvio = "http://www.companysysven.com/app88/registrarlibrodiario.php"
	urlenvio = "https://www.companiasysven.com/API/registrarlibrodiario.php"
	nmes = 0
	Na = 0
	dfi = Date()
	dff = Date()
	ncodt = 0
	ctipodatos = ""
	nidcta = 0
	dFecha = Date()
	ndebe = 0
	nhaber = 0
	cglosa = ""
	Ctipo = ""
	cndoc = ""
	ccond = ""
	Nitem = 0
	ctipomvto = ""
	ctran = ""
	nttd = 0
	ntth = 0
	cTdoc = ""
	niDAUTO = 0
	nidprovision = 0
	Cmoneda = 'S'
	nidclie = 0
	nidprov = 0
	nidbancos = 0
	nidcaja = 0
	ccursor = ""
	Function BuscaProvision
	Lparameters	np1, np2
	ccursor = 'bpr'
	lC = 'PROBuscaProvisionDiario'
	goApp.npara1 = np1
	goApp.npara2 = np2
	TEXT To lp Noshow
          (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(lC, lp, ccursor) < 1 Then
		Return 0
	Else
		If bpr.idb > 0 Then
			This.Cmensaje = "Ya existe La provisión"
			Return 0
		Else
			Return 1
		Endif
	Endif
	Endfunc
	Function listardatosncuenta(ncta, ccursor)
	TEXT To lC Noshow Textmerge
	SELECT idcta,nomb,ncta FROM fe_plan WHERE TRIM(ncta)='<<TRIM(ncta)>>' limit 1;
	ENDTEXT
	If This.ejecutaconsulta(lC, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarAsiento(cndoc, ccursor)
	lC = "PROMUESTRADIARIO"
	TEXT To lp Noshow Textmerge
	SELECT b.ncta,b.nomb,a.ldia_glosa AS glosa,ldia_debe AS debe,ldia_haber AS haber,ldia_tipo AS tipo,a.ldia_idcta AS idcta,
	a.ldia_idld AS nreg,ldia_fech AS fecha,ldia_cond AS cond,a.ldia_comp AS Comp,IFNULL(m.razo,'') AS Cliente,IFNULL(q.razo,'') AS Proveedor,
	IFNULL(m.idcred,CAST(0 AS UNSIGNED)) AS idcred,IFNULL(q.iddeu,CAST(0 AS UNSIGNED)) AS iddeu,ifnull(cred_iddi,CAST(0 as unsigned)) as cred_iddi,
	IFNULL(m.idclie,CAST(0 AS UNSIGNED)) AS idcliente,IFNULL(q.idprov,CAST(0 AS UNSIGNED)) AS idproveedor,ifnull(deud_iddi,CAST(0 as unsigned)) as deud_iddi,
	IFNULL(m.pagoingreso,CAST(0 AS decimal(12,2))) AS pagoingreso,
	IFNULL(q.pagoegreso,CAST(0 AS decimal(12,2))) as pagoegreso
	FROM fe_ldiario AS a
	INNER JOIN fe_plan AS b ON b.idcta=a.ldia_idcta
	LEFT JOIN (SELECT acta AS pagoingreso,idcred,cred_iddi,cred_idrc,d.razo,d.idclie FROM fe_cred AS c
	INNER JOIN fe_rcred AS r ON r.rcre_idrc=cred_idrc
	INNER JOIN fe_clie AS d ON d.idclie=r.rcre_idcl WHERE acti='A' AND cred_iddi>0) AS m ON m.cred_iddi=a.ldia_idld
	LEFT JOIN (SELECT acta AS pagoegreso,iddeu,deud_iddi,deud_idrd,p.razo,p.idprov FROM fe_deu AS d
	INNER JOIN fe_rdeu AS r ON r.rdeu_idrd=d.deud_idrd
	INNER JOIN fe_prov AS p ON p.idprov=r.rdeu_idpr WHERE acti='A' AND deud_iddi>0) AS q ON q.deud_iddi=a.`ldia_idld`
	WHERE ldia_nume='<<cndoc>>' AND ldia_acti<>'I'
	ENDTEXT
	If This.ejecutaconsulta(lp, 'detalle') < 1 Then
		Return 0
	Endif
	Select ncta, nomb, glosa, debe, haber, tipo, idcta, nreg, fecha, cond, Comp, cliente, proveedor,;
		idcred, iddeu, idcliente, idproveedor From detalle Into Cursor (ccursor) Group By nreg
	Return 1
	Endfunc
	Procedure  IngresaDatosDiarioBProvision(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17)
	cur = "rild"
	lC = "FunIngresaDatosLibroDiarioBP"
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
	nidl = This.EJECUTARf(lC, lp, cur)
	If nidl < 1 Then
		Return 0
	Endif
	Return nidl
	Endproc
*********************
	Function  IngresaDatosDiarioCProvision(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17)
	cur = "rild"
	lC = "FunIngresaDatosLibroDiarioCP"
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
	nidl = This.EJECUTARf(lC, lp, cur)
	If nidl < 1 Then
		Return 0
	Else
		Return nidl
	Endif
	Endfunc
	Function  IngresaDatosDiarioCanjes42(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16)
	cur = "rild"
	lC = "FunIngresaDatosLibroDiarioCanjes42"
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
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16)
	ENDTEXT
	nidl = This.EJECUTARf(lC, lp, cur)
	If nidl < 1 Then
		Return 0
	Endif
	Return rild.Id
	Endfunc
	Function  IngresaDatosDiarioCanjes12(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16)
	cur = "rild"
	lC = "FunIngresaDatosLibroDiarioCanjes12"
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
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16)
	ENDTEXT
	nidl = This.EJECUTARf(lC, lp, cur)
	If nidl < 1 Then
		Return 0
	Else
		Return nidl
	Endif
	Endfunc
	Function Listar(f1, f2, ccursor)
	cpropiedad = "cdatos"
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("cdatos", "")
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \    Select  w.ldia_nume As Auto,ldia_fech As fech,w.ldia_glosa As detalle,'' As e1,'' As e2,'' As e3,
	\	a.ncta,a.nomb,debe,haber,estado,ldia_idld From
	\	(Select ldia_idcta,ldia_nume,ldia_fech,ldia_glosa,Sum(ldia_debe) As debe,
	\	Sum(w.ldia_haber) As haber,ldia_inic As estado,ldia_item,ldia_tipo,ldia_idld From fe_ldiario  As w
	\	Where w.ldia_acti<>'I' And w.ldia_fech Between '<<f1>>' And '<<f2>>'
	If goApp.Cdatos = 'S' Then
	\	And ldia_codt=<<goApp.tienda>>
	Endif
	\	Group By w.ldia_nume,w.ldia_idcta,w.ldia_tipo,ldia_fech,ldia_glosa,ldia_inic,ldia_item,ldia_idld) As w
	\	INNER Join fe_plan As a On a.idcta=w.ldia_idcta
	\	Order By w.ldia_nume,w.ldia_item
	Set Textmerge To
	If This.ejecutaconsulta(lC, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarOperacionesCompras(ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	If !Pemstatus(goApp, 'ccostos', 5) Then
		AddProperty(goApp, 'ccostos', '')
	Endif
*!*		ncta,nomb,idcta,cdestinod,cdestinoh,tipocta,plan_oper
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
   \Select b.fecr As fech,b.Tdoc,a.ncta,a.nomb As nombre,Trim(c.razo) As razo,
   \(Case x.ecta_tipo When 'D' Then If((b.Mone = 'S'),x.Impo,Round((x.Impo * b.dolar),2)) Else 0 End) As debe,
   \(Case x.ecta_tipo When 'H' Then If((b.Mone = 'S'),x.Impo,Round((x.Impo * b.dolar),2)) Else 0 End) As haber,
   \a.idcta,a.nomb,x.ecta_tipo As tipo,Left(Concat("Com-",Cast(b.idauto As Char)),12) As Ndoc,
   \x.idectas,idauto,'N' As Tran,0 As itd,0 As ith,Cast(Nitem As UNSIGNED) As Nitem,'Com' As tipomvto,'A' As cond,
   \tcom,b.Ndoc As dcto,s.nomb As tienda,b.fecr As fecha,' Por la Compras Realizadas' As glosa,
	If goApp.Ccostos = 'S' Then
    \ 0 As rcom_ccos,IFNULL(q.cent_desc,'') As Ccostos,b.fech As fechaemision
	Else
    \ 0 As rcom_ccos,'' As Ccostos,b.fech As fechaemision
	Endif
   \From fe_ectasc x
   \Join fe_plan a On a.idcta = x.idcta
   \Join fe_rcom b On b.idauto = x.idrcon
   \Join fe_sucu As s On s.idalma=b.codt
   \Join fe_prov c On c.idprov = b.idprov
	If goApp.Ccostos = 'S' Then
    \ Left Join fe_centcostos As q On q.cent_idco=b.rcom_ccos
	Endif
   \Where  x.Impo <> 0 And b.Acti = 'A'  And x.ecta_acti = 'A' And Month(b.fecr)=<<This.nmes>> And Year(b.fecr)=<<This.Na>> And b.Tdoc Not In ('09','II','GI')
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And b.codt=<<goApp.tienda>>
		Else
	      \And b.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
   \Union All
   \Select b.fecr As fech, b.Tdoc,cdestinod As ncta,a.nomb As nombre,Trim(c.razo) As razo,
   \If(b.Mone ='S',x.Impo,Round(x.Impo * b.dolar,2)) As debe,
   \Cast(0 As Decimal(12,2)) As haber,
   \idctadd As idcta,a.nomb,'D' As tipo,Left(Concat("Com-",Cast(b.idauto As Char)),12) As Ndoc,
   \x.idectas,idauto,'N' As Tran,0 As itd,0 As ith,Cast('9'  As signed) As Nitem,'Com' As tipomvto,'D' As cond,
   \tcom,b.Ndoc As dcto,s.nomb As tienda,b.fecr As fecha,' Por los Destino de la Compras' As glosa,
	If goApp.Ccostos = 'S' Then
    \ b.rcom_ccos,IFNULL(q.cent_desc,'') As Ccostos,b.fech As fechaemision
	Else
    \ 0 As rcom_ccos,'' As Ccostos,b.fech As fechaemision
	Endif
   \From fe_ectasc x
   \Join fe_plan a On a.idcta = x.idcta
   \Join fe_rcom b On b.idauto = x.idrcon
   \Join fe_sucu As s On s.idalma=b.codt
   \Join fe_prov c On c.idprov = b.idprov
	If goApp.Ccostos = 'S' Then
     \ Left Join fe_centcostos As q On q.cent_idco=b.rcom_ccos
	Endif
   \Where  x.Impo <> 0 And b.Acti = 'A'
   \And x.ecta_acti = 'A' And Month(b.fecr)=<<This.nmes>> And Year(b.fecr)=<<This.Na>> And Length(Trim(cdestinod))>0
   \And x.ecta_acti = 'A' And Month(b.fecr)=<<This.nmes>> And Year(b.fecr)=<<This.Na>>
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And b.codt=<<goApp.tienda>>
		Else
	      \And b.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
   \Union All
   \Select b.fecr As fech,b.Tdoc,cdestinoh As ncta,a.nomb As nombre,Trim(c.razo) As razo,
   \Cast(0 As Decimal(12,2)) As debe,
   \If(b.Mone = 'S',x.Impo,Round(x.Impo * b.dolar,2)) As haber,
   \idctadh As idcta,a.nomb,'H' As tipo,Left(Concat("Com-",Cast(b.idauto As Char)),12) As Ndoc,
   \x.idectas,idauto,'N' As Tran,0 As itd,0 As ith,Cast('10' As signed) As Nitem,'Com' As tipomvto,'D' As cond,
   \tcom,b.Ndoc As dcto,s.nomb As tienda,b.fecr As fecha,' Por los Destino de la Compras' As glosa,
	If goApp.Ccostos = 'S' Then
    \ b.rcom_ccos,IFNULL(q.cent_desc,'') As Ccostos,b.fech As fechaemision
	Else
    \ 0 As rcom_ccos,'' As Ccostos,b.fech As fechaemision
	Endif
   \From fe_ectasc x
   \Join fe_plan a On a.idcta = x.idcta
   \Join fe_rcom b On b.idauto = x.idrcon
   \Join fe_sucu As s On s.idalma=b.codt
   \Join fe_prov c On c.idprov = b.idprov
	If goApp.Ccostos = 'S' Then
   \ Left Join fe_centcostos As q On q.cent_idco=b.rcom_ccos
	Endif
   \Where  x.Impo <> 0 And b.Acti = 'A'
   \And x.ecta_acti = 'A' And Month(b.fecr)=<<This.nmes>> And Year(b.fecr)=<<This.Na>> And Length(Trim(cdestinoh))>0
   \And x.ecta_acti = 'A' And Month(b.fecr)=<<This.nmes>> And Year(b.fecr)=<<This.Na>>
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And b.codt=<<goApp.tienda>>
		Else
	      \And b.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
   \Order By fech,idauto,Nitem
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lC, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaroperacionescompras1(ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select b.Tdoc,b.Ndoc As Ndoc,b.fech,b.fecr As fecr,a.ncta As ncta,c.razo As razo,
	\(Case x.ecta_tipo When 'D' Then If((b.Mone = 'S'),x.Impo,Round((x.Impo * b.dolar),2)) Else 0 End) As debe,
	\(Case x.ecta_tipo When 'H' Then If((b.Mone = 'S'),x.Impo,Round((x.Impo * b.dolar),2)) Else 0 End) As haber,
	\a.idcta As idcta,b.fech As fech,a.nomb As nomb,x.ecta_tipo As tipo,Day(fecr) As dia,
	\b.Mone As Mone,c.idprov As idprov,x.idectas As idectas,idauto,'N' As Tran,0 As itd,0 As ith,Nitem
	\From  fe_ectasc x
	\INNER Join fe_plan a On a.idcta = x.idcta
	\INNER Join fe_rcom b On b.idauto = x.idrcon
	\INNER Join fe_prov c On c.idprov = b.idprov
	\Where  x.Impo <> 0 And b.Acti = 'A' And x.ecta_acti = 'A' And Month(b.fecr)=<<This.nmes>> And Year(b.fecr)=<<This.Na>>  And b.Tdoc Not In ('09','II','GI')
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And b.codt=<<goApp.tienda>>
		Else
	      \And b.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	\Order By fecr,Tdoc,idauto,tipo,Nitem
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lC, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function AnularDatosLibroDiario()
	TEXT To lp Noshow Textmerge
	  DELETE from fe_ldiario WHERE MONTH(ldia_fech)=<<this.nmes>> and YEAR(ldia_fech)=<<this.na>> and LEFT(ldia_comp,3)='<<this.ctipodatos>>';
	ENDTEXT
	If This.Ejecutarsql(lp) < 1  Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaroperacionesventas(ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select b.Tdoc,b.Ndoc,b.fech,a.ncta As ncta,a.nomb As nombre,c.razo As razo,
	\(Case x.tipo When 'D' Then If((b.Mone = 'S'),x.Impo,Round((x.Impo * b.dolar),2)) Else 0 End) As debe,
	\(Case x.tipo When 'H' Then If((b.Mone = 'S'),x.Impo,Round((x.Impo * b.dolar),2)) Else 0 End) As haber,
	\a.idcta As idcta,a.nomb As nomb,x.tipo,Day(fecr) As dia,
	\b.Mone As Mone,b.idcliente As idcliente,x.idectas As idectas,idauto,'N' As Tran,0 As itd,0 As ith,Nitem,'Ven' As tipomvto,'A' As cond,
	\s.nomb As tienda,b.fech As fecha, 'Por las Ventas Realizadas' As glosa,b.Ndoc As dcto
	\From fe_ectas x
	\Join fe_plan a On a.idcta = x.idcta
	\Join fe_rcom b On b.idauto = x.idrven
	\Join fe_sucu As s On s.idalma=b.codt
	\Join fe_clie c On c.idclie = b.idcliente
	\Where  x.Impo > 0 And b.Acti = 'A'  And x.Acti = 'A' And Month(b.fech)=<<This.nmes>> And Year(b.fech)=<<This.Na>> And b.Tdoc In ('01','03','07','08')
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And b.codt=<<goApp.tienda>>
		Else
	      \And b.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	\Union All
	\Select b.Tdoc,b.Ndoc,b.fech,a.ncta As ncta,a.nomb As nombre,c.razo As razo,
	\(Case x.tipo When 'H' Then If((b.Mone = 'S'),Abs(x.Impo),Round((Abs(x.Impo) * b.dolar),2)) Else 0 End) As debe,
	\(Case x.tipo When 'D' Then If((b.Mone = 'S'),Abs(x.Impo),Round((Abs(x.Impo) * b.dolar),2)) Else 0 End) As haber,
	\a.idcta As idcta,a.nomb As nomb,If(x.tipo='D','H','D') As tipo,Day(fecr) As dia,
	\b.Mone As Mone,b.idcliente As idcliente,x.idectas As idectas,idauto,'N' As Tran,0 As itd,0 As ith,Nitem,'Ven' As tipomvto,'A' As cond,
	\s.nomb As tienda,b.fech As fecha,'Por las Ventas Realizadas' As glosa,b.Ndoc As dcto
	\From fe_ectas x
	\Join fe_plan a On a.idcta = x.idcta
	\Join fe_rcom b On b.idauto = x.idrven
	\Join fe_sucu As s On s.idalma=b.codt
	\Join fe_clie c On c.idclie = b.idcliente
	\Where  x.Impo < 0 And b.Acti = 'A'  And x.Acti = 'A' And Month(b.fech)=<<This.nmes>> And Year(b.fech)=<<This.Na>> And b.Tdoc In ('01','03','07','08')
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And b.codt=<<goApp.tienda>>
		Else
	      \And b.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	\ Order By fech,Tdoc,idauto,tipo,Nitem
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lC, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaroperacionesCaja(ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select '00' As Tdoc,b.lcaj_ndoc As Ndoc,b.lcaj_fech As fech,b.lcaj_fech As fecr,a.ncta As ncta,
	\If(lcaj_mone='S',lcaj_deud,Round(lcaj_deud*lcaj_dola,2)) As debe,
	\If(lcaj_mone='S',lcaj_acre,Round(lcaj_acre*lcaj_dola,2)) As haber,
	\a.idcta As idcta,a.nomb As nombre,b.lcaj_idau As idauto,Cast(Day(lcaj_fech) As UNSIGNED) As dia,
	\b.lcaj_idct As idcta,lcaj_tran,If(lcaj_deud<>0,'I','S') As tipomvto,lcaj_deta As razo,If(lcaj_deud<>0,'H','D')  As tipo,
	\If(lcaj_tran='T',If(lcaj_deud<>0,If(lcaj_mone='S',lcaj_deud,Round(lcaj_deud*lcaj_dola,2)),Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As itd,
	\If(lcaj_tran='T',If(lcaj_acre<>0,If(lcaj_mone='S',lcaj_acre,Round(lcaj_acre*lcaj_dola,2)),Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As ith,'' As tienda
	\From  fe_lcaja As b
	\Join fe_plan a On a.idcta = b.lcaj_idct
	\ Where  b.lcaj_acti = 'A' And Month(b.lcaj_fech)=<<This.nmes>> And Year(b.lcaj_fech)=<<This.Na>> And (b.lcaj_deud<>0 Or lcaj_acre<>0)
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And b.lcaj_codt=<<goApp.tienda>>
		Else
	      \And b.lcaj_codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	\Order By lcaj_fech
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lC, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaroperacionesbancos(nid, ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	  \Select Tdoc,Ndoc ,cban_fech As fech,ncta,debe,haber,idcta,nombre,dia,
	  \If(debe>0,If(Left(ncta,4)='10.4','T','N'),If(Left(ncta,4)='10.1','T','N')) As cban_tran,
	  \cban_ttra,
	  \If(debe>0,If(Left(ncta,4)='10.4',debe,Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As itd,
	  \If(haber>0,If(Left(ncta,4)='10.1',haber,Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As ith,cban_idco,razo,If(debe>0,'H','D') As tipo,'' As tienda,fecr
	  \From(
	  \Select '00' As Tdoc,b.cban_ndoc As Ndoc,b.cban_fech,b.cban_fech As fecr,a.ncta As ncta,
	  \If(ctas_mone='S',cban_debe,Round(cban_debe*cban_dola,2)) As debe,
	  \If(ctas_mone='S',cban_haber,Round(cban_haber*cban_dola,2)) As haber,
	  \a.idcta,a.nomb As nombre,Day(cban_fech) As dia,
	  \cban_tran,cban_ttra,cban_idco,cban_deta As razo
	  \From  fe_cbancos As b
	  \INNER Join fe_plan a On a.idcta = b.cban_idct
	  \INNER Join fe_ctasb As x On x.ctas_idct=b.cban_idba
	  \Where  b.cban_acti = 'A' And Month(b.cban_fech)=<<This.nmes>> And Year(b.cban_fech)=<<This.Na>> And cban_idba=<<nid>> And (cban_debe<>0 Or cban_haber<>0)
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \ And x.ctas_codt=<<goApp.tienda>>
		Else
	      \ And x.ctas_codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	  \) As x Order By cban_fech
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lC, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarcomprasctas(ccursor)
	dfi = Cfechas(This.dfi)
	dff = Cfechas(This.dff)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif,
	If !Pemstatus(goApp, 'proyecto', 5) Then
		AddProperty(goApp, 'proyecto', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select Tdoc, Ndoc, fecr, ncta, razo, debe, haber, idrcon As idauto,idcta, fech, nomb, idrcon,tipo, Mone, idprov, 'N' As Tran, idectas
	If Alltrim(goApp.proyecto) == 'psys' Then
	    \,nruc,tienda
	Endif
	\From vmuestractascompras Where fecr Between '<<dfi>>' And '<<dff>>' And Tdoc Not In('GI','II','20')
	If This.nidcta > 0 Then
	   \ And  idcta=<<This.nidcta>>
	Endif
	If goApp.Cdatos == 'S' Then
		If Empty(goApp.Tiendas) Then
	      \ And codt=<<goApp.tienda>>
		Else
	      \ And codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	\ Order By Ndoc, tipo
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lC, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarventasctas(ccursor)
	dfi = Cfechas(This.dfi)
	dff = Cfechas(This.dff)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	If !Pemstatus(goApp, 'proyecto', 5) Then
		AddProperty(goApp, 'proyecto', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select Tdoc,Ndoc,fech,ncta,razo,debe,haber,idrven As idauto,idcta,fech,nomb,tipo,idrven,Mone,idclie,'N' As Tran,idectas
	If Alltrim(goApp.proyecto) == 'psys' Then
	    \,nruc,tienda
	Endif
    \From vmuestractasventas Where  fech Between '<<dfi>>' And '<<dff>>' And Tdoc Not In('20')
	If This.nidcta > 0 Then
	   \ And  idcta=<<This.nidcta>>
	Endif
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \ And codt=<<goApp.tienda>>
		Else
	      \ And codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	\ Order By fech,Ndoc,tipo
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lC, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaropcaja(ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\	Select Cast(b.lcaj_fech As Date) As fech,'00' As Tdoc,
	\	Left(Concat("Caj-",Cast(b.lcaj_idca As Char)),12) As Ndoc,a.ncta As ncta,lcaj_deta As razo,
	\	If(lcaj_mone='S',lcaj_acre,Round(lcaj_acre*lcaj_dola,2)) As debe,
	\	If(lcaj_mone='S',lcaj_deud,Round(lcaj_deud*lcaj_dola,2)) As haber,
	\	a.nomb As nomb,IFNULL(If(b.lcaj_idau=0,If(lcaj_acre>0,rdeu_idau,rcre_idau),lcaj_idau),0) As idauto,
	\	b.lcaj_idct As idcta,lcaj_tran As Tran,If(lcaj_acre<>0,'D','H') As tipo,
	\	'a' As orden,b.lcaj_idca,
	\	If(lcaj_tran='T',If(lcaj_acre<>0,If(lcaj_mone='S',lcaj_acre,Round(lcaj_acre*lcaj_dola,2)),Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As itd,
	\	If(lcaj_tran='T',If(lcaj_deud<>0,If(lcaj_mone='S',lcaj_deud,Round(lcaj_deud*lcaj_dola,2)),Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As ith,
	\    'Caj' As tipomvto,'A' As cond,Cast('11' As signed) As Nitem,lcaj_fech As fecha,a.nomb As nombre,'Por las Operaciones de Caja Realizadas' As glosa,lcaj_dcto As dcto
	\	From  fe_lcaja As b Join fe_plan a On a.idcta = b.lcaj_idct
	\	Left Join (Select deud_idrd,acta,iddeu From fe_deu Where Acti='A') As d On d.iddeu=lcaj_idde
	\	Left Join fe_rdeu As r On r.rdeu_idrd=d.deud_idrd
    \   Left Join (Select cred_idrc,idcred,acta From fe_cred Where Acti='A') As c On c.idcred=lcaj_idcr
    \   Left Join fe_rcred As p On p.rcre_idrc=c.cred_idrc
	\	Where  b.lcaj_acti = 'A' And Month(b.lcaj_fech)=<<This.nmes>> And Year(b.lcaj_fech)=<<This.Na>> And (b.lcaj_deud<>0 Or lcaj_acre<>0) And lcaj_form='E'
	If goApp.Cdatos = 'S' Then
	    \And lcaj_codt=<<goApp.tienda>>
	Endif
	\	Union All
	\	Select Cast(b.lcaj_fech As Date) As fech,'00' As Tdoc,Left(Concat("Caj-",Cast(b.lcaj_idca As Char)),12) As Ndoc,'10.11.10' As ncta,
	\	lcaj_deta As razo,
	\	If(lcaj_mone='S',lcaj_deud,Round(lcaj_deud*lcaj_dola,2)) As debe,Cast(0 As Decimal(12,2)) As haber,
	\   a.nomb,b.lcaj_idau As idauto,idctadd As idcta,'N' As Tran,'D'  As tipo,'b' As orden,lcaj_idca,
	\	Cast(0 As Decimal(12,2)) As itd,Cast(0 As Decimal(12,2)) As ith,'Caj' As tipomvto,'A' As cond,Cast('12'As signed) As Nitem,lcaj_fech As fecha,
	\   a.nomb As nombre,'Por las Operaciones de Caja Realizadas' As glosa,lcaj_dcto As dcto
	\	From  fe_lcaja As b
	\   Join fe_plan a On a.idcta = b.lcaj_idct
	\	Where  b.lcaj_acti = 'A' And Month(b.lcaj_fech)=<<This.nmes>> And Year(b.lcaj_fech)=<<This.Na>>  And b.lcaj_deud<>0 And lcaj_form='E'
	If goApp.Cdatos = 'S' Then
	    \And lcaj_codt=<<goApp.tienda>>
	Endif
	\	Union All
	\	Select Cast(b.lcaj_fech As Date) As fech,'00' As Tdoc,Left(Concat("Caj-",Cast(b.lcaj_idca As Char)),12) As Ndoc,'10.11.10' As ncta,
	\	lcaj_deta As razo,
	\	Cast(0 As Decimal(12,2)) As debe,If(lcaj_mone='S',lcaj_acre,Round(lcaj_acre*lcaj_dola,2)) As haber,
	\	a.nomb As nomb,b.lcaj_idau As idauto,
    \   idctadh As idcta,'N' As Tran,'H'  As tipo,'c' As orden,lcaj_idca,
	\	Cast(0 As Decimal(12,2)) As itd,Cast(0 As Decimal(12,2)) As ith,'Caj' As tipomvto,'A' As cond,Cast('13' As signed) As Nitem,
	\   lcaj_fech As fecha,a.nomb  As nombre,'Por la Cancelación   ' As glosa,lcaj_dcto As dcto
	\	From  fe_lcaja As b
	\   Join fe_plan a On a.idcta = b.lcaj_idct
	\	Where  b.lcaj_acti = 'A' And Month(b.lcaj_fech)=<<This.nmes>> And Year(b.lcaj_fech)=<<This.Na>> And b.lcaj_acre<>0 And lcaj_form='E'
	If goApp.Cdatos = 'S' Then
	    \And lcaj_codt=<<goApp.tienda>>
	Endif
	\	Union All
	\	Select Cast(b.lcaj_fech As Date) As fech,'00' As Tdoc,Left(Concat("Caj-",Cast(b.lcaj_idca As Char)),12) As Ndoc,
	\	cdestinod As ncta,Concat("Dest :",Trim(lcaj_deta)) As razo,
	\	If(lcaj_mone='S',lcaj_acre,Round(lcaj_acre*lcaj_dola,2)) As debe,Cast(0 As Decimal(12,2)) As haber,
  	\   a.nomb,Cast(0 As UNSIGNED) As idauto,
	\	idctadd As idcta,lcaj_tran As Tran,'D'  As tipo,'d' As orden,lcaj_idca,
	\	Cast(0 As Decimal(12,2)) As itd,Cast(0 As Decimal(12,2)) As ith,'Caj' As tipomvto,'D' As cond,Cast('14' As signed) As Nitem,
	\   lcaj_fech As fecha,a.nomb  As nombre,'Por El Destino de  Operaciones de Caja Realizadas' As glosa,lcaj_dcto As dcto
	\	From  fe_lcaja As b
	\   Join fe_plan a On a.idcta = b.lcaj_idct
	\	Where  b.lcaj_acti = 'A' And Month(b.lcaj_fech)=<<This.nmes>> And Year(b.lcaj_fech)=<<This.Na>> And Length(Trim(cdestinod))>0 And lcaj_form='E'
	If goApp.Cdatos = 'S' Then
	    \And lcaj_codt=<<goApp.tienda>>
	Endif
	\	Union All
	\	Select Cast(b.lcaj_fech As Date) As fech,'00' As Tdoc,Left(Concat("Caj-",Cast(b.lcaj_idca As Char)),12) As Ndoc,
	\	cdestinoh As ncta,Concat("Destino :",Trim(lcaj_deta)) As razo,
	\	Cast(0 As Decimal(12,2)) As debe,If(lcaj_mone='S',lcaj_acre,Round(lcaj_acre*lcaj_dola,2)) As haber,
	\	a.nomb,Cast(0 As UNSIGNED)As idauto,
	\	idctadh As idcta,lcaj_tran As Tran,'H'  As tipo,'e' As orden,lcaj_idca,
	\	Cast(0 As Decimal(12,2)) As itd,Cast(0 As Decimal(12,2)) As ith,'Caj' As tipomvto,'D' As cond,Cast('15' As signed) As Nitem,
	\   lcaj_fech As fecha,a.nomb As nombre,'Por el Destino de las Operaciones de Caja Realizadas' As glosa,lcaj_dcto As dcto
	\	From  fe_lcaja As b
	\   Join fe_plan a On a.idcta = b.lcaj_idct
	\	Where  b.lcaj_acti = 'A' And Month(b.lcaj_fech)=<<This.nmes>> And Year(b.lcaj_fech)=<<This.Na>> And Length(Trim(cdestinoh))>0 And lcaj_form='E'
	If goApp.Cdatos = 'S' Then
	    \And lcaj_codt=<<goApp.tienda>>
	Endif
    \   Order By fech,lcaj_idca,orden
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lC, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaropbancos(ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\	Select cban_fech As fech,'00' As Tdoc,Left(Concat("Ban-",Cast(b.cban_idco As Char)),12) As Ndoc,
	\	a.ncta As ncta,Concat(Trim(cban_deta),'-',Trim(cban_ndoc)) As razo,
	\	If(ctas_mone='S',IFNULL(If(d.Mone='D',d.acta*cban_dola,d.acta),cban_haber),Round(IFNULL(If(d.Mone='S',d.acta/cban_dola,d.acta),cban_haber)*cban_dola,2)) As debe,
	\	If(ctas_mone='S',IFNULL(If(e.Mone='D',e.acta*cban_dola,e.acta),cban_debe),Round(IFNULL(If(e.Mone='S',e.acta/cban_dola,e.acta),cban_debe)*cban_dola,2)) As haber,
	\	a.idcta,a.nomb,cban_idba,If(rdeu_idau>0,rdeu_idau,IFNULL(rcre_idau,0)) As idauto,
	\	If(cban_debe>0,If(Left(a.ncta,4)='10.4','T','N'),If(Left(a.ncta,4)='10.1','T','N')) As Tran,
	\	cban_ttra,cban_idco As idbancos,T.ncta As nctab,T.idcta As idctab,'a' As orden,If(cban_haber<>0,'D','H') As tipo,
	\	'Ban' As tipomvto,'A' As cond,Cast('16' As signed) As Nitem,
	\	If(cban_haber>0,If(Left(a.ncta,4)='10.4',If(ctas_mone='S',cban_haber,cban_haber*cban_dola),Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As itd,
	\    If(cban_debe>0,If(Left(a.ncta,4)='10.1',If(ctas_mone='S',cban_debe,cban_debe*cban_dola),Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As ith,
	\   '' As tienda,cban_fech As fecha,a.nomb As nombre,'Por las Operaciones Realizadas en Caja y Bancos' As glosa,cban_ndoc As dcto
	\	From  fe_cbancos As b
	\	INNER Join fe_plan a On a.idcta = b.cban_idct
	\	INNER Join fe_ctasb As x On x.ctas_idct=b.cban_idba
	\	INNER Join fe_plan As T On T.idcta=x.ctas_ncta
	\	Left Join (Select deud_idcb,deud_idrd,acta,iddeu,rdeu_mone As Mone From fe_deu q
	\   INNER Join fe_rdeu As F On F.rdeu_idrd=q.deud_idrd Where Acti='A') As d On deud_idcb=b.cban_idco
	\	Left Join fe_rdeu As q On q.rdeu_idrd=d.deud_idrd
	\	Left Join (Select cred_idcb,cred_idrc,idcred,acta,Mone From fe_cred Where Acti='A') As e On e.cred_idcb=b.cban_idco Left Join fe_rcred As w On w.rcre_idrc=e.cred_idrc
	\	Where  b.cban_acti = 'A' And Month(b.cban_fech)=<<This.nmes>> And Year(b.cban_fech)=<<This.Na>>
	If goApp.Cdatos = 'S' Then
	    \And x.ctas_codt=<<goApp.tienda>>
	Endif
	\	Union All
	\	Select cban_fech As fech,'00' As Tdoc,Left(Concat("Ban-",Cast(b.cban_idco As Char)),12) As Ndoc,
	\	T.ncta As ncta,Concat(Trim(cban_deta),'-',Trim(cban_ndoc)) As razo,
	\	If(ctas_mone='S',cban_debe,Round(cban_debe*cban_dola,2)) As debe,
	\	Cast(0 As Decimal(12,2))  As haber,
	\	T.idcta As idcta,T.nomb,cban_idba,Cast(0 As signed) As idauto,
	\	'N' As Tran,cban_ttra,cban_idco As idbancos,T.ncta As nctab,T.idcta As idctab,'b' As orden,
	\	'D' As tipo,'Ban' As tipomvto,'A' As cond,Cast('17' As signed) As Nitem,
	\	Cast(0 As Decimal(12,2)) As itd,Cast(0 As Decimal(12,2)) As ith,'' As tienda,cban_fech As fecha,T.nomb As nombre,
	\ 'Por las Operaciones Realizadas en Caja y Bancos' As glosa,cban_ndoc As dcto
	\	From  fe_cbancos As b
	\	INNER Join fe_plan a On a.idcta = b.cban_idct
	\	INNER Join fe_ctasb As x On x.ctas_idct=b.cban_idba
	\	INNER Join fe_plan As T On T.idcta=x.ctas_ncta
	\	Where  b.cban_acti  In('A') And Month(b.cban_fech)=<<This.nmes>> And Year(b.cban_fech)=<<This.Na>> And cban_debe>0
	If goApp.Cdatos = 'S' Then
	    \And x.ctas_codt=<<goApp.tienda>>
	Endif
	\	Union All
	\	Select cban_fech As fech,'00' As Tdoc,Left(Concat("Ban-",Cast(b.cban_idco As Char)),12) As Ndoc,
	\	T.ncta As ncta,Concat(Trim(cban_deta),'-',Trim(cban_ndoc)) As razo,
	\	Cast(0 As Decimal(12,2))  As debe,
	\	If(ctas_mone='S',cban_haber,Round(cban_haber*cban_dola,2)) As haber,
	\	T.idcta As idcta,T.nomb,cban_idba,Cast(0 As signed) As idauto,
	\	'N' As Tran,cban_ttra,cban_idco As idbancos,T.ncta As nctab,T.idcta As idctab,'c' As orden,
	\	'H' As tipo,'Ban' As tipomvto,'A' As cond,Cast('18' As signed) As Nitem,
	\	Cast(0 As Decimal(12,2)) As itd,Cast(0 As Decimal(12,2)) As ith,'' As tienda,cban_fech As fecha,T.nomb As nombre,
	\   'Por las Operaciones Realizadas en Caja y Bancos' As glosa,cban_ndoc As dcto
	\	From  fe_cbancos As b
	\	INNER Join fe_plan a On a.idcta = b.cban_idct
	\	INNER Join fe_ctasb As x On x.ctas_idct=b.cban_idba
	\	INNER Join fe_plan As T On T.idcta=x.ctas_ncta
	\	Where  b.cban_acti  In('A') And Month(b.cban_fech)=<<This.nmes>> And Year(b.cban_fech)=<<This.Na>>  And cban_haber>0
	If goApp.Cdatos = 'S' Then
	    \And x.ctas_codt=<<goApp.tienda>>
	Endif
	\	Union All
	\	Select cban_fech As fech,'00' As Tdoc,Left(Concat("Ban-",Cast(b.cban_idco As Char)),12) As Ndoc,
	\	a.cdestinod As ncta,Concat("Destino :",cban_ndoc) As razo,
	\	If(ctas_mone='S',cban_haber,Round(cban_haber*cban_dola,2)) As haber,
	\	Cast(0 As Decimal(12,2))  As haber,
	\	a.idctadd As idcta,a.nomb,cban_idba,0 As idauto,
	\	'N' As Tran,cban_ttra,cban_idco As idbancos,T.ncta As nctab,T.idcta As idctab,'d' As orden,
	\	'D' As tipo,'Ban' As tipomvto,'D' As cond,Cast('19' As signed) As Nitem,
	\	Cast(0 As Decimal(12,2)) As itd,Cast(0 As Decimal(12,2)) As ith,'' As tienda,cban_fech As fecha,a.nomb As nombre,
	\ 'Por los Destinos de Operaciones en Caja y Bancos' As glosa,cban_ndoc As dcto
	\	From  fe_cbancos As b
	\	INNER Join fe_plan a On a.idcta = b.cban_idct
	\	INNER Join fe_ctasb As x On x.ctas_idct=b.cban_idba
	\	INNER Join fe_plan As T On T.idcta=x.ctas_ncta
	\	Where  b.cban_acti In ('A') And Month(b.cban_fech)=<<This.nmes>> And Year(b.cban_fech)=<<This.Na>> And Length(Trim(a.cdestinod))>0
	If goApp.Cdatos = 'S' Then
	    \And x.ctas_codt=<<goApp.tienda>>
	Endif
	\	Union All
	\	Select cban_fech As fech,'00' As Tdoc,Left(Concat("Ban-",Cast(b.cban_idco As Char)),12) As Ndoc,
	\   a.cdestinoh As ncta,Concat("Destino :",cban_ndoc) As razo,
	\	Cast(0 As Decimal(12,2))  As debe,
	\	If(ctas_mone='S',cban_haber,Round(cban_haber*cban_dola,2)) As haber,
	\	a.idctadh As idcta,a.nomb,cban_idba,0 As idauto,
	\	'N' As Tran,cban_ttra,cban_idco As idbancos,T.ncta As nctab,T.idcta As idctab,'e' As orden,
	\	'H' As tipo,'Ban' As tipomvto,'D' As cond,Cast('20' As signed) As Nitem,
	\	Cast(0 As Decimal(12,2)) As itd,Cast(0 As Decimal(12,2)) As ith,'' As tienda,cban_fech As fecha,a.nomb As nombre,
	\ 'Por los Destinos de Operaciones en Caja y Bancos' As glosa,cban_ndoc As dcto
	\	From  fe_cbancos As b
	\	INNER Join fe_plan a On a.idcta = b.cban_idct
	\	INNER Join fe_ctasb As x On x.ctas_idct=b.cban_idba
	\	INNER Join fe_plan As T On T.idcta=x.ctas_ncta
	\	Where  b.cban_acti  In('A') And Month(b.cban_fech)=<<This.nmes>> And Year(b.cban_fech)=<<This.Na>>  And Length(Trim(a.cdestinoh))>0
	If goApp.Cdatos = 'S' Then
	    \And x.ctas_codt=<<goApp.tienda>>
	Endif
	\	Order By fech,idbancos,orden
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lC, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ProRegistraDatosDiarioPle55()
	ni = 0
	q = 1
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	Select Il
	Go Top
	Scan All
		ni = ni + 1
		This.dFecha = Il.fecha
		This.ndebe = Il.debe
		This.nhaber = Il.haber
		This.cglosa = Il.glosa
		This.Ctipo = Il.tipo
		This.cndoc = Il.Ndoc
		This.nidcta = Il.idcta
		This.ctipomvto = Il.tipomvto
		This.ccond = Il.cond
		This.ctran = Il.Tran
		This.nttd = Il.ittd
		This.ntth = Il.itth
		This.cTdoc = Il.Tdoc
		This.Nitem = m.ni
		If  This.ingresadatosldiario() < 1 Then
			q = 0
			Exit
		Endif
		Select Il
	Endscan
	If q = 1   Then
		If This.GRabarCambios() < 1 Then
			Return 0
		Endif
		This.Cmensaje = "Grabado Correctamente"
		Return 1
	Else
		If This.DEshacerCambios() < 1 Then
		Endif
		Return 0
	Endif
	Endfunc
	Function ingresadatosldiario()
	Local lC, lp
	lC			  = "ProIngresaDatosLibroDiarioPLE55"
	TEXT To lp Noshow Textmerge
     ('<<cfechas(this.dfecha)>>',<<this.ndebe>>,<<this.nhaber>>,'<<this.cglosa>>', '<<this.ctipo>>','<<this.cndoc>>',<<this.nidcta>>,'<<this.ccond>>', <<this.Nitem>>,'<<this.ctipomvto>>',0,0,'S','<<this.ctran>>',<<this.nttd>>,
     <<this.ntth>>,'<<this.cTdoc>>',<<goapp.tienda>>)
	ENDTEXT
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function  IngresaDatosDiarioBProvision5()
	cur = "rild"
	lC = "FunIngresaDatosLibroDiarioCP"
	TEXT To lp Noshow Textmerge
     ('<<cfechas(this.dfecha)>>',<<this.ndebe>>,<<this.nhaber>>,'<<this.cglosa>>',
     '<<this.ctipo>>','<<this.cndoc>>',<<this.nidcta>>,'<<this.ccond>>',
     <<this.Nitem>>,'<<this.ctipomvto>>',0,0,'<<this.cmoneda>>','<<this.ctran>>',<<this.nttd>>,
     <<this.ntth>>,<<this.nidprovision>>,<<this.ncodt>>)
	ENDTEXT
	nidl = This.EJECUTARf(lC, lp, cur)
	If nidl < 1 Then
		Return 0
	Endif
	Return nidl
	Endfunc
	Function  IngresaDatosDiarioretencion(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16)
	cur = ""
	lC = "proIngresaDatosLibroDiarioretencion"
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
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16)
	ENDTEXT
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function AnulaAsientoDiario(nid)
	If Len(Alltrim(nid)) < 10 Then
		This.Cmensaje = "Ingrese Un Número de Asiento Válido"
		Return 0
	Endif
	TEXT To lC  Noshow Textmerge
      UPDATE fe_ldiario SET ldia_acti='I' WHERE TRIM(ldia_nume)='<<TRIM(nid)>>' AND ldia_acti='A'
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'Anulado Ok'
	Return 1
	Endfunc
	Function Anulapagoscreditos(nid)
	TEXT To lC Noshow Textmerge
      UPDATE fe_cred SET acti='I' WHERE cred_iddi=<<nid>> and cred_iddi>0
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Anulapagosdeudas(nid)
	TEXT To lC Noshow Textmerge
      UPDATE fe_deu SET acti='I' WHERE deud_iddi=<<nid>> and deud_iddi>0
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function  ObtieneCtasPrincipales(ccursor)
	Local lp
	Na	= Val(goApp.Año)
	If Na >= 2020 Then
		TEXT To lp Noshow Textmerge
        select pcta as ctap,GROUP_CONCAT(TRIM(nomb)) AS nomb FROM (
        SELECT LEFT(ncta,2) AS pcta,nomb FROM fe_plan WHERE plan_acti='A' AND RIGHT(ncta,2)='00' ORDER BY pcta) AS p GROUP BY pcta
		ENDTEXT
	Else
		TEXT To lp Noshow Textmerge
        select  pcta as ctap,GROUP_CONCAT(TRIM(nomb)) AS nomb FROM (
        SELECT LEFT(ncta,2) AS pcta,nomb FROM fe_plan WHERE plan_acti='A' AND RIGHT(ncta,2)='00' ORDER BY pcta) AS p GROUP BY pcta
		ENDTEXT
	Endif
	If This.ejecutaconsulta(lp, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function  IngresaDatosLDiarioCProvisiobancos()
	cur = "rild"
	lC = "FunIngresaDatosLibroDiarioBP"
	goApp.npara1 = This.dFecha
	goApp.npara2 = This.ndebe
	goApp.npara3 = This.nhaber
	goApp.npara4 = This.cglosa
	goApp.npara5 = This.cTdoc
	goApp.npara6 = This.cndoc
	goApp.npara7 = This.nidcta
	goApp.npara8 = This.ctipomvto
	goApp.npara9 =  This.Nitem
	goApp.npara10 = This.ccond
	goApp.npara11 = 0
	goApp.npara12 = 0
	goApp.npara13 = This.Cmoneda
	goApp.npara14 = ""
	goApp.npara15 = 0
	goApp.npara16 = 0
	goApp.npara17 = This.nidbancos
	TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
	ENDTEXT
	nidl = This.EJECUTARf(lC, lp, cur)
	If nidl < 1 Then
		Return 0
	Endif
	Return nidl
	Endfunc
	Function listadiariosimplificado(ccursor)
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	TEXT To lC Noshow Textmerge
	  SELECT ncta,ldia_fech,ldia_idcta,ldia_debe,ldia_haber as ldia_haber,ldia_glosa,ldia_nume,ldia_idau,ldia_comp,ifnull(ndoc,'') as ndoc,ldia_cond FROM fe_ldiario
	  INNER JOIN fe_plan  ON fe_plan.`idcta`=fe_ldiario.`ldia_idcta`
	  left join fe_rcom on fe_rcom.idauto=fe_ldiario.ldia_idau
	  WHERE ldia_fech BETWEEN '<<f1>>' AND '<<f2>>' AND ldia_acti='A' AND LEFT(ncta,2) BETWEEN '10' AND '39'
	  UNION ALL
	  SELECT ncta,ldia_fech,ldia_idcta,ldia_debe as ldia_debe,ldia_haber,ldia_glosa,ldia_nume,ldia_idau,ldia_comp,ifnull(ndoc,'') as ndoc,ldia_cond FROM fe_ldiario
	  INNER JOIN fe_plan  ON fe_plan.`idcta`=fe_ldiario.`ldia_idcta`
	  left join fe_rcom on fe_rcom.idauto=fe_ldiario.ldia_idau
	  WHERE ldia_fech BETWEEN '<<f1>>' AND '<<f2>>' AND ldia_acti='A' AND LEFT(ncta,2) BETWEEN '40' AND '46'
	  UNION ALL
	  SELECT ncta,ldia_fech,ldia_idcta,ldia_debe as ldia_debe,ldia_haber,ldia_glosa,ldia_nume,ldia_idau,ldia_comp,ifnull(ndoc,'') as ndoc,ldia_cond FROM fe_ldiario
	  INNER JOIN fe_plan  ON fe_plan.`idcta`=fe_ldiario.`ldia_idcta`
	  left join fe_rcom on fe_rcom.idauto=fe_ldiario.ldia_idau
	  WHERE ldia_fech BETWEEN '<<f1>>' AND '<<f2>>' AND ldia_acti='A' AND LEFT(ncta,2) BETWEEN '50' AND '59'
	  UNION ALL
	  SELECT ncta,ldia_fech,ldia_idcta,ldia_debe,ldia_haber as ldia_haber,ldia_glosa,ldia_nume,ldia_idau,ldia_comp,ifnull(ndoc,'') as ndoc,ldia_cond FROM fe_ldiario
	  INNER JOIN fe_plan  ON fe_plan.`idcta`=fe_ldiario.`ldia_idcta`
	  left join fe_rcom on fe_rcom.idauto=fe_ldiario.ldia_idau
	  WHERE ldia_fech BETWEEN '<<f1>>' AND '<<f2>>' AND ldia_acti='A' AND (LEFT(ncta,2)  BETWEEN '60' AND '69' OR  LEFT(ncta,2)  BETWEEN '91' AND '97')
	  UNION ALL
	  SELECT ncta,ldia_fech,ldia_idcta,ldia_debe as ldia_debe,ldia_haber,ldia_glosa,ldia_nume,ldia_idau,ldia_comp,ifnull(ndoc,'') as ndoc,ldia_cond FROM fe_ldiario
	  INNER JOIN fe_plan  ON fe_plan.`idcta`=fe_ldiario.`ldia_idcta`
	  left join fe_rcom on fe_rcom.idauto=fe_ldiario.ldia_idau
	  WHERE ldia_fech BETWEEN '<<f1>>' AND '<<f2>>' AND ldia_acti='A' AND LEFT(ncta,2) BETWEEN '70' AND '79'
	  ORDER BY ncta,ldia_fech,ldia_idau,ldia_nume,ldia_cond
	ENDTEXT
	If This.ejecutaconsulta(lC, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function YaIngresadoDiario(np1, np2, np3)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	If !Pemstatus(goApp, 'cdatos', 5)
		AddProperty(goApp, 'cdatos', '')
	Endif
	ccursor = 'c_' + Sys(2015)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \ Select ldia_idld From fe_ldiario Where ldia_acti='A' And Left(ldia_comp,3)='<<np1>>' And Month(ldia_fech)=<<np2>> And Year(ldia_fech)=<<np3>>
	If goApp.Cdatos = 'S' Then
      \ And ldia_codt=<<goApp.tienda>>
	Endif
    \ limit 1
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lC, ccursor) < 1 Then
		Return 0
	Endif
	Select (ccursor)
*!*		wait WINDOW VARTYPE(ldia_idld)
	If ldia_idld > 0 Then
*!*		    wait WINDOW m.np1
*!*		      wait WINDOW ldia_idld
		This.Cmensaje = 'Ya Hay al menos Un Registro de  En este Período'
*'+Icase(m.np1='COM','Compras','VEN','Ventas','CAJ','Caja','BAN','Bancos')+
*!*			wait WINDOW this.cmensaje
		Return 0
	Endif
	Return 1
	Endfunc
	Function enviardiarioservidor(ccursor)
	oser = Newobject("servicio", "d:\capass\services\service.prg")
	m.rpta = oser.Inicializar(This, 'ldiario')
	If m.rpta < 1 Then
		This.Cmensaje = oser.Cmensaje
		Return 0
	Endif
	oser = Null
	Set Procedure To d:\Librerias\nfjsoncreate, d:\Librerias\nfcursortojson.prg, ;
		d:\Librerias\nfcursortoobject, d:\Librerias\nfJsonRead.prg, ;
		d:\Librerias\_.prg  Additive
	Select (ccursor)
	m.cdata = nfcursortojson(.T.)
	TEXT To m.envio Noshow Textmerge
	{
	     "ruc":"<<fe_gene.nruc>>",
	     "lista":<<m.cdata>>
	}
	ENDTEXT
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'datos.json'
	Strtofile(m.envio, rutajson)
	oHTTP = Createobject("Microsoft.XMLHTTP")
	oHTTP.Open("POST", This.urlenvio, .F.)
	oHTTP.setRequestHeader("Content-Type ", "application/json")
	oHTTP.Send(m.envio)
	If oHTTP.Status <> 200 Then
		This.Cmensaje = "Servicio WEB NO Disponible....." + Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	lcHTML = oHTTP.responseText
	conerror = 0
	Try
		orpta = nfJsonRead(lcHTML)
	Catch To loException
		This.Cmensaje = lcHTML
		conerror = 1
	Endtry
	If conerror = 0 Then
		If  Vartype(orpta) <> 'U' Then
			This.Cmensaje = orpta.Message
		Else
			crpta =  orpta.messge
		Endif
	Else
		This.Cmensaje = Left(Alltrim(lcHTML), 200)
		Return 0
	Endif
	Return 1
	Endfunc
	Function devvuelveidcta(ncta)
	TEXT To lC Noshow Textmerge
	SELECT idcta,nomb,ncta FROM fe_plan WHERE ncta='<<ncta>>' AND plan_acti='A' limit 1
	ENDTEXT
	ccursor = 'c_' + Sys(2015)
	If This.ejecutaconsulta(lC, ccursor) < 1 Then
		Return 0
	Endif
	Select (ccursor)
	If idcta < 1 Then
		This.Cmensaje = "No hay Cuenta Destino"
		Return 0
	Endif
	Return idcta
	Endfunc
	Function listardetallecta(nid,fi,ff,ccursor)
	f1=Cfechas(m.fi)
	f2=Cfechas(m.ff)
	TEXT To lC Noshow Textmerge
    select ldia_fech,ldia_nume,ldia_debe,ldia_haber,ldia_glosa,
    ldia_tipo,ldia_comp,p.ncta from fe_ldiario  as l
    inner join fe_plan as p   ON p.idcta=l.ldia_idcta
    where ldia_fech between'<<f1>>'  and '<<f2>>'  and ldia_idcta=<<nid>> and ldia_Acti='A' and ldia_tran<>'T'  order by ldia_fech,ldia_tipo
	ENDTEXT
	If This.ejecutaconsulta(lC, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function remplazarcuentasectasc(nidcta,ccursor)
	Select cctas
	Scan For sw=1
		idec=cctas.idectas
		TEXT TO lc noshow
         UPDATE fe_ectasc SET idcta=?nidcta WHERE idectas=?idec
		ENDTEXT
		If This.Ejecutarsql(lC)<1 Then
			Exit
		Endif
	Endscan
	Endfunc
Enddefine


































