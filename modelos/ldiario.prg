Define Class Ldiario As OData Of "d:\capass\database\data.prg"
	nmes = 0
	Na = 0
	ncodt = 0
	dfi = Date()
	dff = Date()
	ctipodatos = ""
	Procedure BuscaProvision
	Lparameters	np1, np2
	Ccursor = 'bpr'
	lC = 'PROBuscaProvisionDiario'
	goApp.npara1 = np1
	goApp.npara2 = np2
	Text To lp Noshow
          (?goapp.npara1,?goapp.npara2)
	Endtext
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
	Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
	Endtext
	nidl = This.EJECUTARf(lC, lp, cur)
	If nidl < 1 Then
		Return 0
	Else
		Return nidl
	Endif
	Endproc
*********************
	Procedure IngresaDatosDiarioCProvision(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17)
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
	Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
	Endtext
	nidl = This.EJECUTARf(lC, lp, cur)
	If nidl < 1 Then
		Return 0
	Else
		Return nidl
	Endif
	Endproc

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
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16)
	Endtext
	nidl = This.EJECUTARf(lC, lp, cur)
	If nidl < 1 Then
		Return 0
	Else
		Return rild.Id
	Endif
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
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16)
	Endtext
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
	Set Textmerge Off
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
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
   \Select b.fecr As fech,b.tdoc,a.ncta,Concat(Trim(c.razo),'-',Trim(b.ndoc)) As razo,
   \(Case x.ecta_tipo When 'D' Then If((b.mone = 'S'),x.Impo,Round((x.Impo * b.dolar),2)) Else 0 End) As debe,
   \(Case x.ecta_tipo When 'H' Then If((b.mone = 'S'),x.Impo,Round((x.Impo * b.dolar),2)) Else 0 End) As haber,
   \a.idcta,a.nomb,x.ecta_tipo As tipo,Left(Concat("Com-",Cast(b.idauto As Char)),12) As ndoc,
   \x.idectas,idauto,'N' As Tran,0 As itd,0 As ith,Cast(nitem As unsigned) As nitem,'Com' As tipomvto,'A' As cond
   \From  fe_ectasc x
   \Join fe_plan a On a.idcta = x.idcta
   \Join fe_rcom b On b.idauto = x.idrcon
   \Join fe_prov c On c.idprov = b.idprov Where  x.Impo <> 0 And b.Acti = 'A'
   \ And x.ecta_acti = 'A' And Month(b.fecr)=<<This.nmes>> And Year(b.fecr)=<<This.Na>> And b.Tdoc Not In ('09','II','GI')
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And b.codt=<<This.ncodt>>
		Else
	      \And b.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
   \Union All
   \Select b.fecr As fech, b.tdoc,cdestinod As ncta,Concat(Trim(c.razo),'-',Trim(b.ndoc)) As razo,
   \If(b.mone ='S',x.Impo,Round(x.Impo * b.dolar,2)) As debe,
   \Cast(0 As Decimal(12,2)) As haber,
   \0 As idcta,a.nomb,'D' As tipo,Left(Concat("Com-",Cast(b.idauto As Char)),12) As ndoc,
    \x.idectas,idauto,'N' As Tran,0 As itd,0 As ith,Cast('9'  As signed) As nitem,'Com' As tipomvto,'D' As cond
    \From  fe_ectasc x
	\Join fe_plan a On a.idcta = x.idcta
	\Join fe_rcom b On b.idauto = x.idrcon
	\Join fe_prov c On c.idprov = b.idprov Where  x.Impo <> 0 And b.Acti = 'A'
	\And x.ecta_acti = 'A' And Month(b.fecr)=<<This.nmes>> And Year(b.fecr)=<<This.Na>> And Length(Trim(cdestinod))>0
    \And x.ecta_acti = 'A' And Month(b.fecr)=<<This.nmes>> And Year(b.fecr)=<<This.Na>>
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And b.codt=<<This.ncodt>>
		Else
	      \And b.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	\Union All
	\Select b.fecr As fech,b.tdoc,cdestinoh As ncta,Concat(Trim(c.razo),'-',Trim(b.ndoc)) As razo,
	\Cast(0 As Decimal(12,2)) As debe,
	\If(b.mone = 'S',x.Impo,Round(x.Impo * b.dolar,2)) As haber,
	\0 As idcta,a.nomb,'H' As tipo,Left(Concat("Com-",Cast(b.idauto As Char)),12) As ndoc,
	\x.idectas,idauto,'N' As Tran,0 As itd,0 As ith,Cast('10' As signed) As nitem,'Com' As tipomvto,'D' As cond
	\From  fe_ectasc x
	\Join fe_plan a On a.idcta = x.idcta
	\Join fe_rcom b On b.idauto = x.idrcon
	\Join fe_prov c On c.idprov = b.idprov Where  x.Impo <> 0 And b.Acti = 'A'
	\And x.ecta_acti = 'A' And Month(b.fecr)=<<This.nmes>> And Year(b.fecr)=<<This.Na>> And Length(Trim(cdestinoh))>0
    \And x.ecta_acti = 'A' And Month(b.fecr)=<<This.nmes>> And Year(b.fecr)=<<This.Na>>
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And b.codt=<<This.ncodt>>
		Else
	      \And b.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	\Order By fech,idauto,nitem
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
    \Select b.tdoc,b.ndoc As ndoc,b.fech,b.fecr As fecr,a.ncta As ncta,c.razo As razo,
	\(Case x.ecta_tipo When 'D' Then If((b.mone = 'S'),x.Impo,Round((x.Impo * b.dolar),2)) Else 0 End) As debe,
	\(Case x.ecta_tipo When 'H' Then If((b.mone = 'S'),x.Impo,Round((x.Impo * b.dolar),2)) Else 0 End) As haber,
	\a.idcta As idcta,b.fech As fech,a.nomb As nomb,x.ecta_tipo As tipo,Day(fecr) As dia,
	\b.mone As mone,c.idprov As idprov,x.idectas As idectas,idauto,'N' As Tran,0 As itd,0 As ith,nitem
	\From  fe_ectasc x
	\INNER Join fe_plan a On a.idcta = x.idcta
	\INNER Join fe_rcom b On b.idauto = x.idrcon
	\INNER Join fe_prov c On c.idprov = b.idprov
	\Where  x.Impo <> 0 And b.Acti = 'A' And x.ecta_acti = 'A' And Month(b.fecr)=<<This.nmes>> And Year(b.fecr)=<<This.Na>>  And b.Tdoc Not In ('09','II','GI')
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And b.codt=<<This.ncodt>>
		Else
	      \And b.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	\Order By fecr,tdoc,idauto,tipo,nitem
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function AnularDatosLibroDiario()
	Text To lp Noshow Textmerge
	  DELETE from fe_ldiario WHERE MONTH(ldia_fech)=<<this.nmes>> and YEAR(ldia_fech)=<<this.na>> and LEFT(ldia_comp,3)='<<this.ctipodatos>>';
	Endtext
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
    \Select b.tdoc,b.ndoc As ndoc,b.fech,b.fecr As fecr,a.ncta As ncta,c.razo As razo,
	\(Case x.tipo When 'D' Then If((b.mone = 'S'),x.Impo,Round((x.Impo * b.dolar),2)) Else 0 End) As debe,
	\(Case x.tipo When 'H' Then If((b.mone = 'S'),x.Impo,Round((x.Impo * b.dolar),2)) Else 0 End) As haber,
	\a.idcta As idcta,b.fech As fech,a.nomb As nomb,x.tipo,Day(fecr) As dia,
	\b.mone As mone,b.idcliente As idcliente,x.idectas As idectas,idauto,'N' As Tran,0 As itd,0 As ith,nitem
	\From  fe_ectas x
	\Join fe_plan a On a.idcta = x.idcta
	\Join fe_rcom b On b.idauto = x.idrven
	\Join fe_clie c On c.idclie = b.idcliente
	\Where  x.Impo <> 0 And b.Acti = 'A'  And x.Acti = 'A' And Month(b.fecr)=<<This.nmes>> And Year(b.fecr)=<<This.Na>> And b.Tdoc In ('01','03','07','08')
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And b.codt=<<This.ncodt>>
		Else
	      \And b.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	\Order By fecr,tdoc,idauto,tipo,nitem
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
	\Select '00' As tdoc,b.lcaj_ndoc As ndoc,b.lcaj_fech,b.lcaj_fech As fecr,a.ncta As ncta,
	\If(lcaj_mone='S',lcaj_deud,Round(lcaj_deud*lcaj_dola,2)) As debe,
	\If(lcaj_mone='S',lcaj_acre,Round(lcaj_acre*lcaj_dola,2)) As haber,
	\a.idcta As idcta,a.nomb As nomb,b.lcaj_idau As idauto,Cast(Day(lcaj_fech) As unsigned) As dia,
	\b.lcaj_idct As idcta,lcaj_tran,If(lcaj_deud<>0,'I','S') As tipomvto,lcaj_deta As razo,If(lcaj_deud<>0,'H','D')  As tipo,
	\If(lcaj_tran='T',If(lcaj_deud<>0,If(lcaj_mone='S',lcaj_deud,Round(lcaj_deud*lcaj_dola,2)),Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As itd,
	\If(lcaj_tran='T',If(lcaj_acre<>0,If(lcaj_mone='S',lcaj_acre,Round(lcaj_acre*lcaj_dola,2)),Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As ith
	\From  fe_lcaja As b 
	\ Join fe_plan a On a.idcta = b.lcaj_idct
	\ Where  b.lcaj_acti = 'A' And Month(b.lcaj_fech)=<<This.nmes>> And Year(b.lcaj_fech)=<<This.Na>> And (b.lcaj_deud>0 Or lcaj_acre>0)
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And b.lcaj_codt=<<This.ncodt>>
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
	  \Select tdoc,ndoc,cban_fech,fecr,ncta,debe,haber,idcta,nomb,dia,
	  \If(debe>0,If(Left(ncta,4)='10.4','T','N'),If(Left(ncta,4)='10.1','T','N')) As cban_tran,
	  \cban_ttra,
	  \If(debe>0,If(Left(ncta,4)='10.4',debe,Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As itd,
	  \If(haber>0,If(Left(ncta,4)='10.1',haber,Cast(0 As Decimal(12,2))),Cast(0 As Decimal(12,2))) As ith,cban_idco,razo,If(debe>0,'H','D') As tipo
	  \From(
	  \Select '00' As tdoc,b.cban_ndoc As ndoc,b.cban_fech,b.cban_fech As fecr,a.ncta As ncta,
	  \If(ctas_mone='S',cban_debe,Round(cban_debe*cban_dola,2)) As debe,
	  \If(ctas_mone='S',cban_haber,Round(cban_haber*cban_dola,2)) As haber,
	  \a.idcta,a.nomb As nomb,Day(cban_fech) As dia,
	  \cban_tran,cban_ttra,cban_idco,cban_deta As razo
	  \From  fe_cbancos As b
	  \INNER Join fe_plan a On a.idcta = b.cban_idct
	  \INNER Join fe_ctasb As x On x.ctas_idct=b.cban_idba
	  \Where  b.cban_acti = 'A' And Month(b.cban_fech)=<<This.nmes>> And Year(b.cban_fech)=<<This.Na>> And cban_idba=<<nid>> And (cban_debe<>0 Or cban_haber<>0)
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \ And x.ctas_codt=<<This.ncodt>>
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
Enddefine













