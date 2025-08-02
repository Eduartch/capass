Define Class Ldiario As OData Of "d:\capass\database\data.prg"
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
	Procedure BuscaProvision
	Lparameters	np1, np2
	Ccursor = 'bpr'
	lC = 'PROBuscaProvisionDiario'
	goApp.npara1 = np1
	goApp.npara2 = np2
	TEXT To lp Noshow
          (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Else
		If bpr.idb > 0 Then
			This.Cmensaje = "Ya existe La provisión"
			Return 0
		Else
			Return 1
		Endif
	Endif
	Endproc
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
	Function Listar(f1, f2, Ccursor)
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
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarOperacionesCompras(Ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	If !Pemstatus(goApp, 'ccostos', 5) Then
		AddProperty(goApp, 'ccostos', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
   \Select b.fecr As fech,b.Tdoc,a.ncta,Trim(c.Razo) As Razo,
   \(Case x.ecta_tipo When 'D' Then If((b.Mone = 'S'),x.Impo,Round((x.Impo * b.dolar),2)) Else 0 End) As debe,
   \(Case x.ecta_tipo When 'H' Then If((b.Mone = 'S'),x.Impo,Round((x.Impo * b.dolar),2)) Else 0 End) As haber,
   \a.idcta,a.nomb,x.ecta_tipo As Tipo,Left(Concat("Com-",Cast(b.idauto As Char)),12) As Ndoc,
   \x.idectas,idauto,'N' As Tran,0 As itd,0 As ith,Cast(Nitem As unsigned) As Nitem,'Com' As tipomvto,'A' As cond,tcom,b.Ndoc As dcto,s.nomb As tienda,
	If goApp.Ccostos = 'S' Then
    \ 0 As rcom_ccos,ifnull(q.cent_desc,'') As Ccostos,b.fech As fechaemision
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
   \ And x.ecta_acti = 'A' And Month(b.fecr)=<<This.nmes>> And Year(b.fecr)=<<This.Na>> And b.Tdoc Not In ('09','II','GI')
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And b.codt=<<goApp.tienda>>
		Else
	      \And b.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
   \Union All
   \Select b.fecr As fech, b.Tdoc,cdestinod As ncta,Trim(c.Razo) As Razo,
   \If(b.Mone ='S',x.Impo,Round(x.Impo * b.dolar,2)) As debe,
   \Cast(0 As Decimal(12,2)) As haber,
   \0 As idcta,a.nomb,'D' As Tipo,Left(Concat("Com-",Cast(b.idauto As Char)),12) As Ndoc,
   \x.idectas,idauto,'N' As Tran,0 As itd,0 As ith,Cast('9'  As signed) As Nitem,'Com' As tipomvto,'D' As cond,tcom,b.Ndoc As dcto,s.nomb As tienda,
	If goApp.Ccostos = 'S' Then
    \ b.rcom_ccos,ifnull(q.cent_desc,'') As Ccostos,b.fech As fechaemision
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
   \Select b.fecr As fech,b.Tdoc,cdestinoh As ncta,Trim(c.Razo) As Razo,
   \Cast(0 As Decimal(12,2)) As debe,
   \If(b.Mone = 'S',x.Impo,Round(x.Impo * b.dolar,2)) As haber,
   \0 As idcta,a.nomb,'H' As Tipo,Left(Concat("Com-",Cast(b.idauto As Char)),12) As Ndoc,
   \x.idectas,idauto,'N' As Tran,0 As itd,0 As ith,Cast('10' As signed) As Nitem,'Com' As tipomvto,'D' As cond,tcom,b.Ndoc As dcto,s.nomb As tienda,
	If goApp.Ccostos = 'S' Then
    \ b.rcom_ccos,ifnull(q.cent_desc,'') As Ccostos,b.fech As fechaemision
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
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaroperacionescompras1(Ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select b.Tdoc,b.Ndoc As Ndoc,b.fech,b.fecr As fecr,a.ncta As ncta,c.Razo As Razo,
	\(Case x.ecta_tipo When 'D' Then If((b.Mone = 'S'),x.Impo,Round((x.Impo * b.dolar),2)) Else 0 End) As debe,
	\(Case x.ecta_tipo When 'H' Then If((b.Mone = 'S'),x.Impo,Round((x.Impo * b.dolar),2)) Else 0 End) As haber,
	\a.idcta As idcta,b.fech As fech,a.nomb As nomb,x.ecta_tipo As Tipo,Day(fecr) As dia,
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
	\Order By fecr,Tdoc,idauto,Tipo,Nitem
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
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
	Function listaroperacionesventas(Ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select b.Tdoc,b.Ndoc As Ndoc,b.fech,b.fecr As fecr,a.ncta As ncta,c.Razo As Razo,
	\(Case x.Tipo When 'D' Then If((b.Mone = 'S'),x.Impo,Round((x.Impo * b.dolar),2)) Else 0 End) As debe,
	\(Case x.Tipo When 'H' Then If((b.Mone = 'S'),x.Impo,Round((x.Impo * b.dolar),2)) Else 0 End) As haber,
	\a.idcta As idcta,b.fech As fech,a.nomb As nomb,x.Tipo,Day(fecr) As dia,
	\b.Mone As Mone,b.idcliente As idcliente,x.idectas As idectas,idauto,'N' As Tran,0 As itd,0 As ith,Nitem,'Ven' As tipomvto,'A' As cond,s.nomb As tienda
	\From fe_ectas x
	\Join fe_plan a On a.idcta = x.idcta
	\Join fe_rcom b On b.idauto = x.idrven
	\Join fe_sucu As s On s.idalma=b.codt
	\Join fe_clie c On c.idclie = b.idcliente
	\Where  x.Impo <> 0 And b.Acti = 'A'  And x.Acti = 'A' And Month(b.fecr)=<<This.nmes>> And Year(b.fecr)=<<This.Na>> And b.Tdoc In ('01','03','07','08')
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And b.codt=<<goApp.tienda>>
		Else
	      \And b.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	\ Order By fecr,Tdoc,idauto,Tipo,Nitem
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaroperacionesCaja(Ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select '00' As Tdoc,b.lcaj_ndoc As Ndoc,b.lcaj_fech,b.lcaj_fech As fecr,a.ncta As ncta,
	\If(lcaj_mone='S',lcaj_deud,Round(lcaj_deud*lcaj_dola,2)) As debe,
	\If(lcaj_mone='S',lcaj_acre,Round(lcaj_acre*lcaj_dola,2)) As haber,
	\a.idcta As idcta,a.nomb As nomb,b.lcaj_idau As idauto,Cast(Day(lcaj_fech) As unsigned) As dia,
	\b.lcaj_idct As idcta,lcaj_tran,If(lcaj_deud<>0,'I','S') As tipomvto,lcaj_deta As Razo,If(lcaj_deud<>0,'H','D')  As Tipo,
	\If(lcaj_tran='T',If(lcaj_deud<>0,If(lcaj_mone='S',lcaj_deud,Round(lcaj_deud*lcaj_dola,2)),Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As itd,
	\If(lcaj_tran='T',If(lcaj_acre<>0,If(lcaj_mone='S',lcaj_acre,Round(lcaj_acre*lcaj_dola,2)),Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As ith,'' As tienda
	\From  fe_lcaja As b
	\Join fe_plan a On a.idcta = b.lcaj_idct
	\ Where  b.lcaj_acti = 'A' And Month(b.lcaj_fech)=<<This.nmes>> And Year(b.lcaj_fech)=<<This.Na>> And (b.lcaj_deud>0 Or lcaj_acre>0)
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
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaroperacionesbancos(nid, Ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	  \Select Tdoc,Ndoc,cban_fech,fecr,ncta,debe,haber,idcta,nomb,dia,
	  \If(debe>0,If(Left(ncta,4)='10.4','T','N'),If(Left(ncta,4)='10.1','T','N')) As cban_tran,
	  \cban_ttra,
	  \If(debe>0,If(Left(ncta,4)='10.4',debe,Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As itd,
	  \If(haber>0,If(Left(ncta,4)='10.1',haber,Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As ith,cban_idco,Razo,If(debe>0,'H','D') As Tipo,'' As tienda
	  \From(
	  \Select '00' As Tdoc,b.cban_ndoc As Ndoc,b.cban_fech,b.cban_fech As fecr,a.ncta As ncta,
	  \If(ctas_mone='S',cban_debe,Round(cban_debe*cban_dola,2)) As debe,
	  \If(ctas_mone='S',cban_haber,Round(cban_haber*cban_dola,2)) As haber,
	  \a.idcta,a.nomb As nomb,Day(cban_fech) As dia,
	  \cban_tran,cban_ttra,cban_idco,cban_deta As Razo
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
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarcomprasctas(Ccursor)
	dfi = Cfechas(This.dfi)
	dff = Cfechas(This.dff)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select Tdoc, Ndoc, fecr, ncta, Razo, debe, haber, idrcon As idauto,idcta, fech, nomb, idrcon,Tipo, Mone, idprov, 'N' As Tran, idectas
	\From vmuestractascompras Where fecr Between '<<dfi>>' And '<<dff>>' And Tdoc Not In('GI','II','20')
	If This.nidcta > 0 Then
	   \ And  idcta=<<This.nidcta>>
	Endif
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \ And ldia_codt=<<goApp.tienda>>
		Else
	      \ And ldia_codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	\ Order By Ndoc, Tipo
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarventasctas(Ccursor)
	dfi = Cfechas(This.dfi)
	dff = Cfechas(This.dff)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select Tdoc,Ndoc,fech,ncta,Razo,debe,haber,idrven As idauto,idcta,fech,nomb,Tipo,idrven,Mone,idclie,'N' As Tran,idectas
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
	\ Order By fech,Ndoc,Tipo
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaropcaja(Ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\	Select Cast(b.lcaj_fech As Date) As fech,'00' As Tdoc,
	\	Left(Concat("Caj-",Cast(b.lcaj_idca As Char)),12) As Ndoc,a.ncta As ncta,
    \	lcaj_deta As Razo,
	\	If(lcaj_mone='S',lcaj_acre,Round(lcaj_acre*lcaj_dola,2)) As debe,
	\	If(lcaj_mone='S',lcaj_deud,Round(lcaj_deud*lcaj_dola,2)) As haber,
	\	a.nomb,ifnull(If(b.lcaj_idau=0,If(lcaj_acre>0,rdeu_idau,rcre_idau),lcaj_idau),0) As idauto,
	\	b.lcaj_idct As idcta,lcaj_tran As Tran,If(lcaj_acre<>0,'D','H') As Tipo,
	\	'a' As orden,b.lcaj_idca,
	\	If(lcaj_tran='T',If(lcaj_acre<>0,If(lcaj_mone='S',lcaj_acre,Round(lcaj_acre*lcaj_dola,2)),Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As itd,
	\	If(lcaj_tran='T',If(lcaj_deud<>0,If(lcaj_mone='S',lcaj_deud,Round(lcaj_deud*lcaj_dola,2)),Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As ith,
	\    'Caj' As tipomvto,'A' As cond,Cast('11' As signed) As Nitem
	\	From  fe_lcaja As b Join fe_plan a On a.idcta = b.lcaj_idct
	\	Left Join (Select deud_idrd,acta,iddeu From fe_deu Where Acti='A') As d On d.iddeu=lcaj_idde
	\	Left Join fe_rdeu As r On r.rdeu_idrd=d.deud_idrd
    \    Left Join (Select cred_idrc,idcred,acta From fe_cred Where Acti='A') As c On c.idcred=lcaj_idcr
    \    Left Join fe_rcred As p On p.rcre_idrc=c.cred_idrc
	\	Where  b.lcaj_acti = 'A' And Month(b.lcaj_fech)=<<This.nmes>> And Year(b.lcaj_fech)=<<This.Na>> And (b.lcaj_deud<>0 Or lcaj_acre<>0) And lcaj_form='E'
	If goApp.Cdatos = 'S' Then
	    \And lcaj_codt=<<goApp.tienda>>
	Endif
	\	Union All
	\	Select Cast(b.lcaj_fech As Date) As fech,'00' As Tdoc,Left(Concat("Caj-",Cast(b.lcaj_idca As Char)),12) As Ndoc,'10.11.10' As ncta,
	\	lcaj_deta As Razo,
	\	If(lcaj_mone='S',lcaj_deud,Round(lcaj_deud*lcaj_dola,2)) As debe,Cast(0 As Decimal(12,2)) As haber,
	\    a.nomb,b.lcaj_idau As idauto,Cast(0 As signed) As idcta,'N' As Tran,'D'  As Tipo,'b' As orden,lcaj_idca,
	\	Cast(0 As Decimal(12,2)) As itd,Cast(0 As Decimal(12,2)) As ith,'Caj' As tipomvto,'A' As cond,Cast('12'As signed) As Nitem
	\	From  fe_lcaja As b Join fe_plan a On a.idcta = b.lcaj_idct
	\	Where  b.lcaj_acti = 'A' And Month(b.lcaj_fech)=<<This.nmes>> And Year(b.lcaj_fech)=<<This.Na>>  And b.lcaj_deud<>0 And lcaj_form='E'
	If goApp.Cdatos = 'S' Then
	    \And lcaj_codt=<<goApp.tienda>>
	Endif
	\	Union All
	\	Select Cast(b.lcaj_fech As Date) As fech,'00' As Tdoc,Left(Concat("Caj-",Cast(b.lcaj_idca As Char)),12) As Ndoc,'10.11.10' As ncta,
	\	lcaj_deta As Razo,
	\	Cast(0 As Decimal(12,2)) As debe,If(lcaj_mone='S',lcaj_acre,Round(lcaj_acre*lcaj_dola,2)) As haber,
	\	a.nomb As nomb,b.lcaj_idau As idauto,
    \    Cast(0 As signed) As idcta,'N' As Tran,'H'  As Tipo,'c' As orden,lcaj_idca,
	\	Cast(0 As Decimal(12,2)) As itd,Cast(0 As Decimal(12,2)) As ith,'Caj' As tipomvto,'A' As cond,Cast('13' As signed) As Nitem
	\	From  fe_lcaja As b Join fe_plan a On a.idcta = b.lcaj_idct
	\	Where  b.lcaj_acti = 'A' And Month(b.lcaj_fech)=<<This.nmes>> And Year(b.lcaj_fech)=<<This.Na>> And b.lcaj_acre<>0 And lcaj_form='E'
	If goApp.Cdatos = 'S' Then
	    \And lcaj_codt=<<goApp.tienda>>
	Endif
	\	Union All
	\	Select Cast(b.lcaj_fech As Date) As fech,'00' As Tdoc,Left(Concat("Caj-",Cast(b.lcaj_idca As Char)),12) As Ndoc,
	\	cdestinod As ncta,Concat("Dest :",Trim(lcaj_deta)) As Razo,
	\	If(lcaj_mone='S',lcaj_acre,Round(lcaj_acre*lcaj_dola,2)) As debe,Cast(0 As Decimal(12,2)) As haber,
  	\    a.nomb As nomb,Cast(0 As unsigned) As idauto,
	\	Cast(0 As signed) As idcta,lcaj_tran As Tran,'D'  As Tipo,'d' As orden,lcaj_idca,
	\	Cast(0 As Decimal(12,2)) As itd,Cast(0 As Decimal(12,2)) As ith,'Caj' As tipomvto,'D' As cond,Cast('14' As signed) As Nitem
	\	From  fe_lcaja As b Join fe_plan a On a.idcta = b.lcaj_idct
	\	Where  b.lcaj_acti = 'A' And Month(b.lcaj_fech)=<<This.nmes>> And Year(b.lcaj_fech)=<<This.Na>> And Length(Trim(cdestinod))>0 And lcaj_form='E'
	If goApp.Cdatos = 'S' Then
	    \And lcaj_codt=<<goApp.tienda>>
	Endif
	\	Union All
	\	Select Cast(b.lcaj_fech As Date) As fech,'00' As Tdoc,Left(Concat("Caj-",Cast(b.lcaj_idca As Char)),12) As Ndoc,
	\	cdestinoh As ncta,Concat("Destino :",Trim(lcaj_deta)) As Razo,
	\	Cast(0 As Decimal(12,2)) As debe,If(lcaj_mone='S',lcaj_acre,Round(lcaj_acre*lcaj_dola,2)) As haber,
	\	a.nomb As nomb,Cast(0 As unsigned)As idauto,
	\	Cast(0 As signed) As idcta,lcaj_tran As Tran,'H'  As Tipo,'e' As orden,lcaj_idca,
	\	Cast(0 As Decimal(12,2)) As itd,Cast(0 As Decimal(12,2)) As ith,'Caj' As tipomvto,'D' As cond,Cast('15' As signed) As Nitem
	\	From  fe_lcaja As b Join fe_plan a On a.idcta = b.lcaj_idct
	\	Where  b.lcaj_acti = 'A' And Month(b.lcaj_fech)=<<This.nmes>> And Year(b.lcaj_fech)=?Na And Length(Trim(cdestinoh))>0 And lcaj_form='E'
	If goApp.Cdatos = 'S' Then
	    \And lcaj_codt=<<goApp.tienda>>
	Endif
    \   Order By fech,lcaj_idca,orden
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaropbancos(Ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\	Select cban_fech As fech,'00' As Tdoc,Left(Concat("Ban-",Cast(b.cban_idco As Char)),12) As Ndoc,
	\	a.ncta As ncta,Concat(Trim(cban_deta),'-',Trim(cban_ndoc)) As Razo,
	\	If(ctas_mone='S',ifnull(If(d.Mone='D',d.acta*cban_dola,d.acta),cban_haber),Round(ifnull(If(d.Mone='S',d.acta/cban_dola,d.acta),cban_haber)*cban_dola,2)) As debe,
	\	If(ctas_mone='S',ifnull(If(e.Mone='D',e.acta*cban_dola,e.acta),cban_debe),Round(ifnull(If(e.Mone='S',e.acta/cban_dola,e.acta),cban_debe)*cban_dola,2)) As haber,
	\	a.idcta,a.nomb As nomb,cban_idba,If(rdeu_idau>0,rdeu_idau,ifnull(rcre_idau,0)) As idauto,
	\	If(cban_debe>0,If(Left(a.ncta,4)='10.4','T','N'),If(Left(a.ncta,4)='10.1','T','N')) As Tran,
	\	cban_ttra,cban_idco As idbancos,T.ncta As nctab,T.idcta As idctab,'a' As orden,If(cban_haber<>0,'D','H') As Tipo,
	\	'Ban' As tipomvto,'A' As cond,Cast('16' As signed) As Nitem,
	\	If(cban_haber>0,If(Left(a.ncta,4)='10.4',If(ctas_mone='S',cban_haber,cban_haber*cban_dola),Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As itd,
	\    If(cban_debe>0,If(Left(a.ncta,4)='10.1',If(ctas_mone='S',cban_debe,cban_debe*cban_dola),Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As ith,'' As tienda
	\	From  fe_cbancos As b
	\	INNER Join fe_plan a On a.idcta = b.cban_idct
	\	INNER Join fe_ctasb As x On x.ctas_idct=b.cban_idba
	\	INNER Join fe_plan As T On T.idcta=x.ctas_ncta
	\	Left Join (Select deud_idcb,deud_idrd,acta,iddeu,rdeu_mone As Mone From fe_deu q INNER Join fe_rdeu As F On F.rdeu_idrd=q.deud_idrd Where Acti='A') As d On deud_idcb=b.cban_idco
	\	Left Join fe_rdeu As q On q.rdeu_idrd=d.deud_idrd
	\	Left Join (Select cred_idcb,cred_idrc,idcred,acta,Mone From fe_cred Where Acti='A') As e On e.cred_idcb=b.cban_idco Left Join fe_rcred As w On w.rcre_idrc=e.cred_idrc
	\	Where  b.cban_acti = 'A' And Month(b.cban_fech)=<<This.nmes>> And Year(b.cban_fech)=<<This.Na>>
	If goApp.Cdatos = 'S' Then
	    \And x.ctas_codt=<<goApp.tienda>>
	Endif
	\	Union All
	\	Select cban_fech As fech,'00' As Tdoc,Left(Concat("Ban-",Cast(b.cban_idco As Char)),12) As Ndoc,
	\	T.ncta As ncta,Concat(Trim(cban_deta),'-',Trim(cban_ndoc)) As Razo,
	\	If(ctas_mone='S',cban_debe,Round(cban_debe*cban_dola,2)) As debe,
	\	Cast(0 As Decimal(12,2))  As haber,
	\	T.idcta As idcta,a.nomb As nomb,cban_idba,Cast(0 As signed) As idauto,
	\	'N' As Tran,cban_ttra,cban_idco As idbancos,T.ncta As nctab,T.idcta As idctab,'b' As orden,
	\	'D' As Tipo,'Ban' As tipomvto,'A' As cond,Cast('17' As signed) As Nitem,
	\	Cast(0 As Decimal(12,2)) As itd,Cast(0 As Decimal(12,2)) As ith,'' As tienda
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
	\	T.ncta As ncta,Concat(Trim(cban_deta),'-',Trim(cban_ndoc)) As Razo,
	\	Cast(0 As Decimal(12,2))  As debe,
	\	If(ctas_mone='S',cban_haber,Round(cban_haber*cban_dola,2)) As haber,
	\	T.idcta As idcta,a.nomb As nomb,cban_idba,Cast(0 As signed) As idauto,
	\	'N' As Tran,cban_ttra,cban_idco As idbancos,T.ncta As nctab,T.idcta As idctab,'c' As orden,
	\	'H' As Tipo,'Ban' As tipomvto,'A' As cond,Cast('18' As signed) As Nitem,
	\	Cast(0 As Decimal(12,2)) As itd,Cast(0 As Decimal(12,2)) As ith,'' As tienda
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
	\	a.cdestinod As ncta,Concat("Destino :",cban_ndoc) As Razo,
	\	If(ctas_mone='S',cban_haber,Round(cban_haber*cban_dola,2)) As haber,
	\	Cast(0 As Decimal(12,2))  As haber,
	\	Cast(0 As unsigned) As idcta,a.nomb As nomb,cban_idba,0 As idauto,
	\	'N' As Tran,cban_ttra,cban_idco As idbancos,T.ncta As nctab,T.idcta As idctab,'d' As orden,
	\	'D' As Tipo,'Ban' As tipomvto,'D' As cond,Cast('19' As signed) As Nitem,
	\	Cast(0 As Decimal(12,2)) As itd,Cast(0 As Decimal(12,2)) As ith,'' As tienda
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
	\   a.cdestinoh As ncta,Concat("Destino :",cban_ndoc) As Razo,
	\	Cast(0 As Decimal(12,2))  As debe,
	\	If(ctas_mone='S',cban_haber,Round(cban_haber*cban_dola,2)) As haber,
	\	Cast(0 As unsigned) As idcta,a.nomb As nomb,cban_idba,0 As idauto,
	\	'N' As Tran,cban_ttra,cban_idco As idbancos,T.ncta As nctab,T.idcta As idctab,'e' As orden,
	\	'H' As Tipo,'Ban' As tipomvto,'D' As cond,Cast('20' As signed) As Nitem,
	\	Cast(0 As Decimal(12,2)) As itd,Cast(0 As Decimal(12,2)) As ith,'' As tienda
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
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
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
	Do While !Eof()
		ni = ni + 1
		This.dFecha = Il.Fecha
		This.ndebe = Il.debe
		This.nhaber = Il.haber
		This.cglosa = Il.glosa
		This.Ctipo = Il.Tipo
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
		Skip
	Enddo
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
	cur			  = ""
	lC			  = "ProIngresaDatosLibroDiarioPLE55"
	TEXT To lp Noshow Textmerge
     ('<<cfechas(this.dfecha)>>',<<this.ndebe>>,<<this.nhaber>>,'<<this.cglosa>>',
     '<<this.ctipo>>','<<this.cndoc>>',<<this.nidcta>>,'<<this.ccond>>',
     <<this.Nitem>>,'<<this.ctipomvto>>',0,0,'S','<<this.ctran>>',<<this.nttd>>,
     <<this.ntth>>,'<<this.cTdoc>>',<<goapp.tienda>>)
	ENDTEXT
	If This.EJECUTARP(lC, lp, cur) < 1 Then
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
	If Len(Alltrim(nid)) < 1 Then
		This.Cmensaje = "Ingrese Un Número de Asiento Válido"
		Return 0
	Endif
	TEXT To lC  Noshow Textmerge
      UPDATE fe_ldiario SET ldia_acti='I' WHERE ldia_nume='<<nid>>'
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'Anulado Ok'
	Return 1
	Endfunc
	Function  ObtieneCtasPrincipales(Ccursor)
	Local lp
*!*		cur	= "Ctaspr"
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
	If This.EJECutaconsulta(lp, Ccursor) < 1 Then
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
	Function listadiariosimplificado(Ccursor)
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
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
*!*		select * FROM (ccursor) INTO TABLE ADDBS(SYS(5)+SYS(2003))+'rldsimpl'
	Return 1
*!*	    IF !USED("rldsimpl") then
*!*	       USE D:\xmsys\rldsimpl IN  0 SHARED
*!*	    ENDIF 
   * SET FILTER TO ldia_idau=1811
*!*		x=0
*!*		ccampos=''
*!*		cTitulos = 'Fecha Operación,Nro.Operación,Glosa de Operación'
*!*		cwidth = '100,100,300'
*!*		Create Cursor rlds(Fecha d, Ndoc c(12), Detalle c(100),idauto n(10))
*!*		Select rldsimpl
*!*		Go Top
*!*		Do While !Eof()
*!*			Select rldsimpl
*!*			cndoc = rldsimpl.ldia_nume
*!*			Cdetalle = Alltrim(rldsimpl.ldia_glosa)+' '+Alltrim(rldsimpl.Ndoc)
*!*			cncta = Left(rldsimpl.ncta, 2)
*!*			ccampo ='c_'+m.cncta
*!*			Select rlds
*!*			If Fsize(ccampo)=0 Then
*!*				Alter Table rlds Add Column (ccampo) N(12, 2)
*!*				m.ccampos=Iif(x=0,Trim(m.ccampos)+'sum('+(ccampo)+') as '+(ccampo),Trim(m.ccampos)+','+'sum('+(ccampo)+') as '+(ccampo))
*!*				cTitulos=cTitulos+','+m.cncta
*!*				cwidth = m.cwidth+','+'100'
*!*			Endif
*!*			tc = Iif(rldsimpl.ldia_debe>0,rldsimpl.ldia_debe,-rldsimpl.ldia_haber)
*!*			x=x+1
*!*			Select rlds
*!*			If rldsimpl.ldia_idau>0 Then
*!*				Locate For idauto = rldsimpl.ldia_idau
*!*			Else
*!*				Locate For Alltrim(Ndoc) = Alltrim(m.cndoc)
*!*			Endif
*!*			If !Found()
*!*				Insert Into rlds(Fecha, Detalle, Ndoc,(ccampo),idauto)Values(rldsimpl.ldia_fech,m.Cdetalle,m.cndoc,m.tc,rldsimpl.ldia_idau)
*!*			Else
*!*				TEXT TO lr NOSHOW TEXTMERGE 
*!*				replace <<ccampo>> with <<ccampo>>+<<m.tc>>
*!*				ENDTEXT 
*!*				Execscript(lr)
*!*			Endif
*!*			Select rldsimpl
*!*			Skip
*!*		Enddo
*!*		Select rlds
*!*		Alter Table rlds Drop Column 'idauto'
*!*		Messagebox(m.ccampos)
*!*		If Len(Alltrim(m.ccampos))>0 Then
*!*			cad=[select dfecha2 as fecha,'' as ndoc,'TOTALES' as detalle,]+m.ccampos+' from rlds into cursor ttt'
*!*	*		MESSAGEBOX(m.cad)
*!*			Execscript(cad)
*!*			Select rlds
*!*			Append From Dbf("ttt")
*!*			Go Top
*!*		Endif
	Endfunc
Enddefine































