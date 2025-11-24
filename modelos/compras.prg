Define Class Compras As OData Of 'd:\capass\database\data.prg'
	cTdoc	 = ""
	cforma	 = ""
	cndoc	 = ""
	dFecha	 = Date()
	dfechar	 = Date()
	Cdetalle = ""
	nimpo1	 = 0
	nimpo2	 = 0
	nimpo3	 = 0
	nimpo4	 = 0
	nimpo5	 = 0
	nimpo6	 = 0
	nimpo7	 = 0
	nimpo8	 = 0
	npercepcion = 0
	cguia	 = ""
	Cmoneda	 = ""
	ndolar	 = 0
	vigv	 = 0
	Ctipo	 = ""
	nidprov	 = 0
	ctipo1	 = ""
	nidusua	 = 0
	nidt	 = 0
	Nreg	 = 0
	nidcta1 = 0
	nidcta2 = 0
	nidcta3 = 0
	nidcta4 = 0
	nidctai = 0
	nidctae = 0
	nidcta7 = 0
	nidctat = 0
	idcta1 = 0
	idcta2 = 0
	idcta3 = 0
	idcta4 = 0
	idcta5 = 0
	idcta6 = 0
	idcta7 = 0
	idcta8 = 0
	Ct1 = ""
	Ct2 = ""
	Ct3 = ""
	Ct4 = ""
	Ct5 = ""
	ct6 = ""
	ct7 = ""
	ct8 = ""
	cproveedor = ""
	Cdetalle = ""
	Serie = ''
	Ndoc = ''
	nforma = 0
	nmontor = 0
	cFormaRegistrada = ""
	ntienepagos = 0
	cencontrado = ""
	conedaregistrada = ""
	cgrabaprecios = ""
	fechai = Date()
	fechaf = Date()
	codt = 0
	nmes = 0
	Naño = 0
	nredondeo = 0
	cincluido = ""
	ctipoingreso = ""
	Item = 0
	Nsgte = 0
	Idserie = 0
	clugar = ""
	nirta = 0
	Items = 0
	cletras = ""
	Cndni = ""
	Crazon = ""
	nneto = 0
	Cdireccion = ""
	nidccostos = 0
	ctemporal = ""
	solocontables = ''
	Function actualizaparteotrascompras()
	This.CONTRANSACCION = 'S'
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	lC = 'ProActualizaRCompras1'
	cur = ""
	goApp.npara1 = This.cTdoc
	goApp.npara2 = This.cforma
	goApp.npara3 = This.cndoc
	goApp.npara4 = This.dFecha
	goApp.npara5 = This.dfechar
	goApp.npara6 = This.Cdetalle
	goApp.npara7 = This.nimpo1 + This.nimpo2 + This.nimpo3 + This.nimpo4
	goApp.npara8 = This.nimpo5
	goApp.npara9 = This.nimpo8
	goApp.npara10 = ""
	goApp.npara11 = This.Cmoneda
	goApp.npara12 = This.ndolar
	goApp.npara13 = This.vigv
	goApp.npara14 = This.Ctipo
	goApp.npara15 = This.nidprov
	goApp.npara16 = This.ctipo1
	goApp.npara17 = This.nidusua
	goApp.npara18 = 0
	goApp.npara19 = This.nidt
	goApp.npara20 = 0
	goApp.npara21 = 0
	goApp.npara22 = 0
	goApp.npara22 = 0
	goApp.npara24 = 0
	goApp.npara25 = This.Nreg
	goApp.npara26 = This.nimpo7
	goApp.npara27 = This.nimpo8
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26,?goapp.npara27)
	ENDTEXT
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		This.Cmensaje = ' Actualizando Cabecera de Documento de Compras/Gastos'
		Return 0
	Endif
	If This.actualizacuentascontablesocompras() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	This.CONTRANSACCION = ""
	Return 1
	Endfunc
	Function actualizacuentascontablesocompras()
	lcsql = 'ProActualizaCtascsolocuentas'
	goApp.npara1 = 0
	goApp.npara2 = 0
	goApp.npara3 = 0
	goApp.npara4 = 0
	goApp.npara5 = 0
	goApp.npara6 = 0
	goApp.npara7 = 0
	goApp.npara8 = 0
	goApp.npara9 = This.nidcta1
	goApp.npara10 = This.nidcta2
	goApp.npara11 = This.nidcta3
	goApp.npara12 = This.nidcta4
	goApp.npara13 = This.nidctai
	goApp.npara14 = This.nidctae
	goApp.npara15 = This.nidcta7
	goApp.npara16 = This.nidctat
	goApp.npara17 = This.idcta1
	goApp.npara18 = This.idcta2
	goApp.npara19 = This.idcta3
	goApp.npara20 = This.idcta4
	goApp.npara21 = This.idcta5
	goApp.npara22 = This.idcta6
	goApp.npara23 = This.idcta7
	goApp.npara24 = This.idcta8
	goApp.npara25 = ""
	goApp.npara26 = ""
	goApp.npara27 = ""
	goApp.npara28 = ""
	goApp.npara29 = ""
	goApp.npara30 = ""
	goApp.npara31 = ""
	goApp.npara32 = ""
	TEXT To lC1 Noshow Textmerge
	  UPDATE fe_ectasc SET idcta=<<This.nidcta1>> WHERE idectas=<<This.idcta1>>;
	ENDTEXT
	If This.Ejecutarsql(lC1) < 1 Then
		Return 0
	Endif
	TEXT To lC2 Noshow Textmerge
	  UPDATE fe_ectasc SET idcta=<<This.nidcta1>> WHERE idectas=<<This.idcta2>>;
	ENDTEXT
	If This.Ejecutarsql(lC2) < 1 Then
		Return 0
	Endif
	TEXT To lC3 Noshow Textmerge
	  UPDATE fe_ectasc SET idcta=<<This.nidcta3>> WHERE idectas=<<This.idcta3>>;
	ENDTEXT
	If This.Ejecutarsql(lC3) < 1 Then
		Return 0
	Endif
	TEXT To lC4 Noshow Textmerge
	  UPDATE fe_ectasc SET idcta=<<This.nidcta4>> WHERE idectas=<<This.idcta4>>;
	ENDTEXT
	If This.Ejecutarsql(lC4) < 1 Then
		Return 0
	Endif
	TEXT To lc5 Noshow Textmerge
	  UPDATE fe_ectasc SET idcta=<<This.nidctai>> WHERE idectas=<<This.idcta5>>;
	ENDTEXT
	If This.Ejecutarsql(lc5) < 1 Then
		Return 0
	Endif
	TEXT To lc6 Noshow Textmerge
	  UPDATE fe_ectasc SET idcta=<<This.nidctae>> WHERE idectas=<<This.idcta6>>;
	ENDTEXT
	If This.Ejecutarsql(lc6) < 1 Then
		Return 0
	Endif
	TEXT To lc7 Noshow Textmerge
	  UPDATE fe_ectasc SET idcta=<<This.nidcta7>> WHERE idectas=<<This.idcta7>>;
	ENDTEXT
	If This.Ejecutarsql(lc7) < 1 Then
		Return 0
	Endif
	TEXT To lc8 Noshow Textmerge
	  UPDATE fe_ectasc SET idcta=<<This.nidctat>> WHERE idectas=<<This.idcta8>>;
	ENDTEXT
	If This.Ejecutarsql(lc8) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function BuscarcomprasGrifos(nid, Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	    \Select  c.Deta As Deta, a.idauto,a.alma, a.idkar As idkar,b.Descri As Descri, b.Peso As Peso, b.prod_idco As prod_idco, b.Unid As Unid,
		\b.tipro  As tipro, a.idart As idart, a.Incl As Incl, c.Ndoc As Ndoc, c.valor     As valor, c.igv       As igv,
		\c.Impo   As Impo, c.pimpo,a.cant, a.Prec, c.fech      As fech, c.fecr      As fecr,
		\c.Form   As Form, c.Exon  As Exon, c.ndo2  As ndo2, c.vigv  As vigv, c.idprov    As idprov, a.Tipo      As Tipo,
		\c.Tdoc, c.dolar  As dolar, c.Mone  As Mone,p.Razo,p.Dire, p.ciud      As ciud,
		\p.nruc   As nruc, c.codt As codt, a.dsnc,a.dsnd,a.gast, c.fusua,c.idusua As idusua, w.nomb  As Usuario, c.rcom_fise,rcom_exon
		\From fe_rcom c
		\Left Join fe_kar a  On c.idauto = a.idauto
		\Left Join fe_art b  On b.idart = a.idart
		\Join fe_prov p  On p.idprov = c.idprov
		\Join fe_usua w On w.idusua = c.idusua
		\Where c.Acti='A' And a.Acti= 'A'
	If nid > 0 Then
		\And c.idauto=<<nid>>
	Else
		\And c.Ndoc='<<this.cndoc>>' And c.Tdoc='<<this.ctdoc>>' And c.idprov=<<This.nidprov>>
	Endif
	\Order By a.idkar
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ValidarCanjesGuiascompras()
	Do Case
	Case Len(Alltrim(This.Serie)) <> 4 Or Len(Alltrim(This.Ndoc)) <> 8
		This.Cmensaje = "Ingrese Un Número de Documento Válido"
		Return 0
	Case Val(This.Ndoc) = 0
		This.Cmensaje = "Ingrese Un Número de Documento Válido"
		Return 0
	Case This.nimpo8 = 0
		This.Cmensaje = "Ingrese Importes Válidos Diferentes de 0"
		Return  0
	Case !esfechaValida(This.dfechar) Or !esfechaValida(This.dfechar)
		This.Cmensaje = "Fecha de Registro No Permitido Diferente al Mes Actual"
		Return  0
	Case Year(This.dfechar) <> Val(goApp.Año) Or Year(This.dfechar) <> Val(goApp.Año)
		This.Cmensaje = "Fecha No Permitida Por el Sistema ... Diferente al Año Actual"
		Return 0
	Case PermiteIngresoCompras(This.cndoc, '01', This.nidprov, 0, This.dfechar) = 0
		This.Cmensaje = "Número de Documento de Compra Ya Registrado"
		Return 0
	Case  PermiteIngresox(This.dfechar) = 0
		This.Cmensaje = "No Es posible Registrar en esta Fecha estan bloqueados Los Ingresos"
		Return 0
	Case Empty(This.nidprov) Or This.nidprov = 0
		This.Cmensaje = "Seleccione Un Proveedor"
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function comprasxproducto(nidart, Ccursor)
	TEXT To lC Noshow Textmerge
	        SELECT b.razo,c.fech,cant,ROUND(prec*c.vigv,2) as prec,c.mone,If(mone='D',Round(Prec*g.dola*c.vigv,2),ROUND(Prec*c.vigv,2)) As precios,
	        tdoc,ndoc,MONTH(c.fech) as mes,a.alma
	        FROM fe_kar as a
			INNER JOIN fe_rcom  as c ON(c.idauto=a.idauto)
			inner join fe_prov as b ON (b.idprov=c.idprov),fe_gene as g
			WHERE idart=<<nidart>> AND  c.acti<>'I' and a.acti='A' order by c.fech desc;
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registraotracompras()
	Set Procedure To d:\capass\modelos\cajae, d:\capass\modelos\ctasxpagar Additive
	ocaja = Createobject("cajae")
	octaspagar = Createobject("ctasporpagar")
	If This.validaocompras() < 1 Then
		Return 0
	Endif
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	NAuto = This.IngresaResumenDctoC(This.cTdoc, This.cforma, This.cndoc, This.dFecha, This.dfechar, This.Cdetalle, This.nimpo1 + This.nimpo2 + This.nimpo3 + This.nimpo4, This.nimpo5, This.nimpo8, ;
		'', This.Cmoneda, This.ndolar, fe_gene.igv, This.Ctipo, This.nidprov, This.ctipo1, goApp.nidusua, 0, goApp.Tienda, 0, 0, 0, 0, 0, This.nimpo6, This.nimpo8)
	If NAuto < 1  Then
		This.DEshacerCambios()
		Return 0
	Endif

	If This.IngresaValoresCtasC1(This.nimpo1, This.nimpo2, This.nimpo3, This.nimpo4, This.nimpo5, This.nimpo6, This.nimpo7, This.nimpo8, This.nidcta1, This.nidcta2, This.nidcta3, This.nidcta4, ;
			This.nidctai, This.nidctae, This.nidcta7, This.nidctat, This.Ct1, This.Ct2, This.Ct3, This.Ct4, This.Ct5, This.ct6, This.ct7, This.ct8, NAuto) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If ocaja.IngresaDatosLCajaEFectivo11(This.dfechar, "", This.cproveedor, This.nidctat, 0, This.nimpo8, This.Cmoneda, This.ndolar, goApp.nidusua, This.nidprov, NAuto, This.cforma, This.cndoc, This.cTdoc) < 1 Then
		This.Cmensaje = ocaja.Cmensaje
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.nforma = 2 Then
		If  ctaspagar.registrarcuentasporpagar('tmpd', NAuto, This.nidprov, This.Cmoneda, This.dFecha, This.nimpo8, This.nidctat, This.ndolar) < 1 Then
			This.Cmensaje = octaspagar.Cmensaje
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaValoresCtasC1(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25)
	Local cur As String
	lC = 'IngresaCuentas'
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
	goApp.npara19 = np19
	goApp.npara20 = np20
	goApp.npara21 = np21
	goApp.npara22 = np22
	goApp.npara23 = np23
	goApp.npara24 = np24
	goApp.npara25 = np25
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
	ENDTEXT
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaResumenDctoC(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25, np26)
	lC = 'FunIngresaRCompras'
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
	goApp.npara19 = np19
	goApp.npara20 = np20
	goApp.npara21 = np21
	goApp.npara22 = np22
	goApp.npara23 = np23
	goApp.npara24 = np24
	goApp.npara25 = np25
	goApp.npara26 = np26
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1 Then
		Return 0
	Else
		Return nid
	Endif
	Endfunc
	Function validaocompras()
	Do Case
	Case PermiteIngresoCompras(This.Ndoc, This.cTdoc, This.nidprov, This.Nreg, This.dFecha) = 0
		This.Cmensaje = "NUMERO de Documento de Compra Ya Registrado "
		Return 0
	Case  PermiteIngresox(This.dfechar) = 0
		This.Cmensaje = "No Es posible Registrar en esta Fecha estan bloqueados Los Ingresos"
		Return 0
	Case Len(Alltrim(This.Serie)) < 4 Or Len(Alltrim(This.Ndoc)) < 8
		This.Cmensaje = "Ingrese un Nº de Documento Válido"
		Return 0
	Case Year(This.dfechar) <> Val(goApp.Año) Or !esfechaValida(This.dFecha) Or !esfechaValida(This.dfechar)
		This.Cmensaje = "Fecha No permitida por el Sietema"
		Return 0
	Case This.nidprov = 0
		This.Cmensaje = "Seleccione Un Proveedor"
		Return 0
	Case (This.nmontor <> This.nimpo8  Or This.cmonedaregistrada <> This.Cmoneda) And This.ntienepagos = 1 And This.cencontrado = 'V'
		This.Cmensaje = "El Nuevo Monto Ingresado o el Tipo de Moneda es Diferente al Registrado como Deuda(Tiene Que ser los mismos Datos) "
		Return 0
	Case This.cFormaRegistrada <> This.cforma And This.ntienepagos = 1 And This.cencontrado = 'V'
		This.Cmensaje = "Este Documento Tiene Pagos Aplicados y no es Posible Cambiar la forma de pago"
		Return 0
	Case Empty(This.cTdoc)
		This.Cmensaje = "Seleccione Un Tipo de Documento"
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function ActualizaResumenDctoC(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25, np26, np27)
	lC = 'ProActualizaRCompras'
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
	goApp.npara19 = np19
	goApp.npara20 = np20
	goApp.npara21 = np21
	goApp.npara22 = np22
	goApp.npara23 = np23
	goApp.npara24 = np24
	goApp.npara25 = np25
	goApp.npara26 = np26
	goApp.npara27 = np27
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26,?goapp.npara27)
	ENDTEXT
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function actualizarocompras()
	Set Procedure To d:\capass\modelos\cajae, d:\capass\modelos\ctasxpagar Additive
	ocaja = Createobject("cajae")
	octaspagar = Createobject("ctasporpagar")
	If This.validaocompras() < 1 Then
		Return 0
	Endif
	If This.IniciaTransaccion() = 0 Then
		Return 0
	Endif
	If This.ActualizaResumenDctoC(This.Tdoc, This.cforma, This.cndoc, This.dFecha, This.dfechar, This.Cdetalle, This.nimpo1 + This.nimpo2 + This.nimpo3 + This.nimpo4, This.nimpo5, This.nimpo8, '', This.Cmoneda, ;
			This.ndolar, fe_gene.igv, This.Ctipo, This.nidprov, This.ctipo1, goApp.nidusua, 0, goApp.Tienda, 0, 0, 0, 0, 0, This.Nreg, This.nimpo6, This.nimpo8) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If ocaja.IngresaDatosLCajaEFectivo11(This.dfechar, "", This.cproveedor, This.nidctat, 0, This.nimpo8, This.Cmoneda, ;
			This.ndolar, goApp.nidusua, This.nidprov, This.Nreg, This.cforma, This.cndoc, This.cTdoc) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.FormaRegistrada = 'C' And This.nforma = 1 Then
		If ACtualizaDeudas(This.Nreg, goApp.nidusua) = 0
			Return 0
		Endif
	Endif
	If This.actualizaparteotrascompras() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.nforma = 2 Then
		If This.Nreg > 0 Then
			If ACtualizaDeudas(This.Nreg, goApp.nidusua) = 0
				This.DEshacerCambios()
				Return 0
			Endif
		Endif
		If  ctaspagar.registrarcuentasporpagar('tmpd', This.Nreg, This.nidprov, This.Cmoneda, This.dFecha, This.nimpo8, This.nidctat, This.ndolar) < 1 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If This.GRabarCambios() = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function actualizactasocompras()
	lC = 'ProActualizactasc'
	TEXT To lp  Noshow Textmerge
	(<<this.nimpo1>>,<<this.nimpo2>>,<<this.nimpo3>>,<<this.nimpo4>>,<<this.nimpo5>>,<<this.nimpo6>>,<<this.nimpo7>>,<<this.nimpo8>>,
	<<this.nidcta1>>,<<this.nidcta2>>,<<this.nidcta3>>,<<this.nidcta4>>,<<this.nidctai>>,<<this.nidctae>>,<<this.nidcta7>>,<<this.nidctat>>,
	<<this.idcta1>>,<<this.idcta2>>,<<this.idcta3>>,<<this.idcta4>>,<<this.idcta5>>,<<this.idcta6>>,<<this.idcta7>>,<<this.idcta8>>,'<<this.ct1>>','<<this.ct2>>','<<this.ct3>>','<<this.ct4>>','<<this.ct5>>','<<this.ct6>>','<<this.ct7>>','<<this.ct8>>')
	ENDTEXT
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarxdcto(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lC Noshow Textmerge
	SELECT  `c`.`deta`      AS `deta`, `a`.`idauto`    AS `idauto`, `a`.`alma`      AS `alma`, `a`.`idkar`     AS `idkar`,
	  `b`.`descri`    AS `descri`,  `b`.`peso`      AS `peso`,  `b`.`prod_idco` AS `prod_idco`,
	  `b`.`unid`      AS `unid`,  `b`.`tipro`     AS `tipro`,  `a`.`idart`     AS `idart`,
	  `a`.`incl`      AS `incl`,  `c`.`ndoc`      AS `ndoc`,  `c`.`valor`     AS `valor`,
	  `c`.`igv`       AS `igv`,  `c`.`impo`      AS `impo`,  `c`.`pimpo`     AS `pimpo`,
	  `a`.`cant`      AS `cant`, `a`.`prec`      AS `prec`,  `c`.`fech`      AS `fech`,
	  `c`.`fecr`      AS `fecr`, `c`.`form`      AS `form`,  `c`.`exon`      AS `exon`,
	  `c`.`ndo2`      AS `ndo2`,  `c`.`vigv`      AS `vigv`,  `c`.`idprov`    AS `idprov`,
	  `a`.`tipo`      AS `tipo`, `c`.`tdoc`      AS `tdoc`,  `c`.`dolar`     AS `dolar`,
	  `c`.`mone`      AS `mone`,  `p`.`razo`      AS `razo`,  `p`.`dire`      AS `dire`,
	  `p`.`ciud`      AS `ciud`, `p`.`nruc`      AS `nruc`,  `c`.`codt`      AS `codt`,
	  `a`.`dsnc`      AS `dsnc`, `a`.`dsnd`      AS `dsnd`,  `a`.`gast`      AS `gast`,prod_cod1,
	  `c`.`fusua`     AS `fusua`, `c`.`idusua`    AS `idusua`,  `w`.`nomb`      AS `Usuario`
    FROM `fe_rcom` `c`
    LEFT JOIN `fe_kar` `a`  ON `c`.`idauto` = `a`.`idauto`
    LEFT JOIN `fe_art` `b`  ON `b`.`idart` = `a`.`idart`
    JOIN `fe_prov` `p`  on `p`.`idprov` = `c`.`idprov`
    JOIN `fe_usua` `w` ON `w`.`idusua` = `c`.`idusua`
    WHERE `c`.`acti` <> 'I'     AND `a`.`acti` <> 'I' and c.ndoc='<<this.cndoc>>' AND c.tdoc='<<this.ctdoc>>' AND c.idprov=<<this.nidprov>>
    order by idkar
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarxid(niDAUTO, Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lC Noshow Textmerge
	 SELECT  `c`.`deta`, `a`.`idauto`, `a`.`alma`, `a`.`idkar`,
	`b`.`descri` , `b`.`peso` ,  `b`.`prod_idco`,b.uno,b.dos,b.tre,b.cua,b.uno+b.dos+b.tre+b.cua as talma,
	 `b`.`unid`,  `b`.`tipro` ,  `a`.`idart`,ifnull(b.tmon,'') as tmon,
	 `a`.`incl`,  `c`.`ndoc` ,  `c`.`valor`,
	 `c`.`igv` ,  `c`.`impo` ,  `c`.`pimpo`,
	 `a`.`cant`, `a`.`prec`  ,  `c`.`fech` ,
	 `c`.`fecr`, `c`.`form` ,  `c`.`exon`      AS `exon`,rcom_exon,
	 `c`.`ndo2`,  `c`.`vigv`,  `c`.`idprov`    AS `idprov`,
	 `a`.`tipo`, `c`.`tdoc` ,  CAST(`c`.`dolar` as  decimal(6,4))   AS `dolar`,
	 `c`.`mone`,  `p`.`razo`,  `p`.`dire`,if(tmon='S',b.prec*v.igv,b.prec*v.dola*v.igv) as costo,
	 `p`.`ciud`, `p`.`nruc` ,  `c`.`codt`      AS `codt`,l.lcaj_idus,
	 `a`.`dsnc`, `a`.`dsnd` ,  `a`.`gast`      AS `gast`,prod_cod1,b.prec as preccosto,
	 `c`.`fusua`     AS `fusua`, `c`.`idusua` ,  `w`.`nomb`      AS `Usuario`
	 FROM `fe_rcom` `c`
	 LEFT JOIN `fe_kar` `a`  ON `c`.`idauto` = `a`.`idauto`
	 LEFT JOIN `fe_art` `b`  ON `b`.`idart` = `a`.`idart`
	 JOIN `fe_prov` `p`  on `p`.`idprov` = `c`.`idprov`
	 JOIN `fe_usua` `w` ON `w`.`idusua` = `c`.`idusua`
	 left join (select lcaj_idus,lcaj_idau from fe_lcaja  as w where lcaj_idau=<<nidauto>> and lcaj_acti='A') as l on l.lcaj_idau=c.idauto,fe_gene as v
	 WHERE `c`.`acti` <> 'I'     AND `a`.`acti` <> 'I' and c.idauto=<<nidauto>>  order by idkar
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registradetraccion(c1, f1, nid)
	F = Cfechas(f1)
	TEXT To lC Noshow Textmerge
      UPDATE fe_rcom SET rcom_detr='<<c1>>',rcom_fecd='<<f>>' WHERE idauto=<<nid>>
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	ENDFUNC
	Function porproveedorpsystr(Ccursor)
	If (This.fechaf - This.fechai) > 360 Then
		This.Cmensaje = 'Hasta 360 Días'
		Return 0
	Endif
	fi = Cfechas(This.fechai)
	ff = Cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
	\Select p.Razo As proveedor,x.fech,x.fecr,x.Tdoc,x.Ndoc,x.ndo2,x.Mone,x.valor,x.igv,x.Impo,x.dolar As dola,x.Form,x.idauto,
	\k.cant,Round(k.Prec*x.vigv,2) As Prec,Round(k.cant*k.Prec*x.vigv,2) As Importe,ifnull(a.Descri,'') As Descri,
	\ifnull(a.Unid,'') As Unid,u.nomb As Usuario,x.fusua,a.idart,ifnull(prod_cod1,'') As prod_cod1 From fe_rcom As x
	\INNER Join fe_prov As p  On p.idprov=x.idprov
	\INNER Join fe_usua As u On u.idusua=x.idusua
	\Left Join fe_kar As k On k.idauto=x.idauto
	\Left Join fe_art As a On a.idart=k.idart
	\Where x.fech Between '<<fi>>' And '<<ff>>'  And x.Acti='A'
	If This.nidprov > 0 Then
	   \And x.idprov=<<This.nidprov>>
	Endif
	If This.codt > 0 Then
	   \ And x.codt=<<This.codt>>
	ENDIF
	IF LEN(ALLTRIM(this.cTdoc))>0 then
	 \ and x.tdoc='<<this.ctdoc>>'
	ENDIF 
	\Order By x.fech,x.idauto,k.idkar
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registrocompras(Ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	If !Pemstatus(goApp, 'ccostos', 5) Then
		AddProperty(goApp, 'ccostos', '')
	Endif
	If !Pemstatus(goApp, 'proyecto', 5) Then
		AddProperty(goApp, 'proyecto', '')
	Endif
	f1 = Cfechas(This.fechai)
	f2 = Cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
	\Select a.idauto As Auto,Form,fecr,fech,Tdoc,If(Length(Trim(a.Ndoc))<=10,Left(a.Ndoc,3),Left(a.Ndoc,4)) As Serie,
	\			If(Length(Trim(a.Ndoc))<=10,Substr(a.Ndoc,4),Substr(a.Ndoc,5)) As Ndoc,nruc,Razo,
	\			Round(v1+v2+v3+v4,2) As valorg,c.Exon,c.igv As igvg,c.otros,Round(If(Tdoc<>'41',v1+v2+v3+v4+c.Exon+c.igv+otros,0),2) As Importe,
	\			Round(If(Tdoc='41',If(Mone="D",c.Impo*a.dolar,c.Impo),If(Mone="D",pimpo*a.dolar,pimpo)),2) As pimpo,
	\			a.Deta,Cast(a.dolar As Decimal(8,3)) As dola,Mone,a.idprov As Codigo,
	\			If(Tdoc='07',fech,If(Tdoc='08',fech,Cast("0001-01-01" As Date))) As fechn,
	\			If(Tdoc='07','01',If(Tdoc='08','01',' ')) As tref,
	\			If(Tdoc='07',a.Ndoc,If(Tdoc='08',a.Ndoc,' ')) As Refe,
	\			ndni,Cast('0' As unsigned) As T,
	\			ifnull(rcom_detr,'')  As detra,rcom_fecd As fechad,
	\			vigv,tipom As Tipo,fech As Fevto,a.rcom_icbper As icbper,'M002' As cuo,ifnull(p.ncta,'') As ncta,ifnull(r.ncta,'') As ncta1,
	If goApp.Ccostos = 'S' Then
	   \ rcom_ccos,ifnull(w.cent_desc,'') As centcostos
	Else
	  \  Cast(0 As unsigned) As rcom_ccos,''  As centcostos
	Endif
	\ From fe_rcom As a INNER Join
	\			(Select a.idauto,
	\			Sum(Case c.Nitem When 1 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As v1,
	\			Sum(Case c.Nitem When 2 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As v2,
	\			Sum(Case c.Nitem When 3 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As v3,
	\			Sum(Case c.Nitem When 4 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As v4,
	\   		Sum(Case c.Nitem When 5 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As igv,
	\			Sum(Case c.Nitem When 6 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As Exon,
	\			Sum(Case c.Nitem When 7 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As otros,
	\			Sum(Case c.Nitem When 8 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As Impo,
    \       Case
	\       When Sum(Case c.Nitem When 1 Then
    \            If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End)>0 Then
	\	         Sum(Case c.Nitem When 1 Then c.`idcta` End)
	\	    When Sum(Case c.Nitem When 2 Then
    \             If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End)>0 Then
    \		      Sum(Case c.Nitem When 2 Then c.`idcta` End)
    \       When Sum(Case c.Nitem When 3 Then
    \            If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End)>0 Then
    \		     Sum(Case c.Nitem When 3 Then c.`idcta` End)
    \       When Sum(Case c.Nitem When 4 Then
    \            If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End)>0 Then
    \		     Sum(Case c.Nitem When 4 Then c.`idcta` End)
	\       When Sum(Case c.Nitem When 5 Then
    \            If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End)>0 Then
	\	         Sum(Case c.Nitem When 5 Then c.`idcta` End)
	\	    When Sum(Case c.Nitem When 6 Then
    \            If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End)>0 Then
    \		     Sum(Case c.Nitem When 6 Then c.`idcta` End)
	\       When Sum(Case c.Nitem When 7 Then
    \            If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End)>0 Then
    \		     Sum(Case c.Nitem When 7 Then c.`idcta` End)
    \		 Else
    \		   Sum(Case c.Nitem When 8 Then c.`idcta` End)
	\      End As ctav,
	\    Case
	\       When Sum(Case c.Nitem When 8 Then
    \            If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End)>0 Then
	\	         Sum(Case c.Nitem When 8 Then c.`idcta` End) End As ctat
    \	From fe_rcom As a
	\	INNER Join fe_ectasc As c On(c.idrcon=a.idauto)
	\	Where  fecr Between '<<f1>>' And '<<f2>>'
	If Alltrim(goApp.Proyecto) = 'xmsys' Then
	 \And Tdoc Not In ('09','II','GI','02')  And Acti='A' And ecta_acti='A'
	Else
	 \And Tdoc Not In ('09','II','GI')  And Acti='A' And ecta_acti='A'
	Endif
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And a.codt=<<goApp.Tienda>>
		Else
	      \And a.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	If Len(Alltrim(This.Ctipo)) > 0 Then
	   \ And a.tipom='<<this.ctipo>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	  \ And Tdoc='<<this.ctdoc>>'
	Endif
	\Group By idauto)
	\As c  On(c.idauto=a.idauto)
	\Join fe_prov  As b On(b.idprov=a.idprov)
	\Left Join fe_plan As p On p.idcta=c.ctav
	\Left Join fe_plan As r On r.idcta=c.ctat
	If goApp.Ccostos = 'S' Then
	 \Left Join fe_centcostos As w On w.cent_idco=a.rcom_ccos
	Endif
	If goApp.Ccostos = 'S' Then
		If This.nidccostos > 0 Then
			\ Where a.rcom_ccos =<< This.nidccostos >>
		Endif
	Endif
	\ Order By fech,Serie,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, 'registro1') < 1 Then
		Return 0
	Endif
	Set Textmerge On
	Set Textmerge To  Memvar lg Noshow
    \Select a.Ndoc,a.Tdoc,a.fech,b.ncre_idnc As idn,ncre_idan  From (
	\Select ncre_idnc,ncre_idau,ncre_idan From fe_nccom As N
	\INNER Join fe_rcom As r On r.idauto=N.`ncre_idan`
	\Where Month(r.fecr)=<<This.nmes>> And Year(r.fecr)=<<This.Naño>>  And r.Acti='A' And  ncre_acti='A' ) As b
	\INNER Join  fe_rcom As a On a.idauto=b.ncre_idau
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lg, 'xnotas') < 1 Then
		Return 0
	Endif
	Create Cursor registro(Auto N(15), Form c(1) Null, fecr d Null, fech d Null, Tdoc c(2) Null, Serie c(4), Ndoc c(10), nruc c(11)Null, Razo c(120)Null, valorg N(14, 2), Exon N(12, 2), ;
		igvg N(10, 2), otros N(12, 2), Importe N(14, 2), pimpo N(8, 2), Deta c(80), dola N(5, 3), detra c(24), fechad d, fechn d, tref c(2), Refe c(12), ncta c(10), ncta1 c(10), Ccostos c(150), Mone c(1), Codigo N(5), Fevto d, ;
		ndni c(8), T N(1), Tipo c(1), icbper N(8, 2), vigv N(5, 3), ccost N(5))
	x = 1
	notas = 0
	Select registro1
	Scan All
		nidn = registro1.Auto
		ntdoc = '00'
		nndoc = '            '
		nfech = Ctod("  /  /    ")
		If registro1.Tdoc = '07' Or registro1.Tdoc = '08' Then
			NAuto = registro1.Auto
			Select * From xnotas Where ncre_idan = NAuto Into Cursor Xn
			notas = 1
			nidn = Xn.idn
			ntdoc = Xn.Tdoc
			nndoc = Xn.Ndoc
			nfech = Xn.fech
		Endif
		nccostos = Iif(Vartype(registro1.rcom_ccos) = 'C', Val(registro1.rcom_ccos), registro1.rcom_ccos)
		Insert Into registro(Form, fecr, fech, Tdoc, Serie, Ndoc, nruc, Razo, valorg, Exon, igvg, otros, Importe, pimpo, Deta,  dola, Mone, detra, Codigo, ;
			Auto,  tref, Refe,  Tipo, icbper, fechn, fechad, T, vigv, ncta, Ccostos, ccost, ncta1);
			Values(registro1.Form, registro1.fecr, registro1.fech, registro1.Tdoc, registro1.Serie, registro1.Ndoc, ;
			registro1.nruc, registro1.Razo, registro1.valorg, registro1.Exon, registro1.igvg, registro1.otros, registro1.Importe, registro1.pimpo, registro1.Deta, ;
			registro1.dola,  registro1.Mone, registro1.detra,  ;
			registro1.Codigo, registro1.Auto, Iif(m.notas = 1, m.ntdoc, ''), Iif(m.notas = 1, m.nndoc, ''), registro1.Tipo, Iif(Isnull(registro1.icbper), 0, registro1.icbper), Iif(m.notas = 1, m.nfech, Ctod("  /  /   ")), ;
			Iif(Isnull(registro1.fechad), Ctod("  /  /    "), registro1.fechad), Iif(Tdoc = '03', 1, 6), registro1.vigv, registro1.ncta, registro1.centcostos, m.nccostos, registro1.ncta1)

	Endscan
	Go Top In registro
	Return 1
	Endfunc
	Function registrocomprasxsys(Ccursor)
	f1 = Cfechas(This.fechai)
	f2 = Cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To  Memvar lC Noshow Textmerge
	\Select a.Auto, a.fech, a.Fevto, b.Tdoc, If(Length(Trim(a.Ndoc)) <= 10, Left(a.Ndoc, 3), Left(a.Ndoc, 4)) As Serie,
	\If(Length(Trim(a.Ndoc)) <= 10, MID(a.Ndoc, 4, 7), MID(a.Ndoc, 5, 8)) As Ndoc, d.nruc, d.Razo,
    \	Sum(Case c.Nitem When 1 Then If(a.Mone = 'S', c.Impo, Round(c.Impo * a.dolar, 2)) Else 0 End) As v1,
	\	Sum(Case c.Nitem When 2 Then If(a.Mone = 'S', c.Impo, Round(c.Impo * a.dolar, 2)) Else 0 End) As v2,
	\	Sum(Case c.Nitem When 3 Then If(a.Mone = 'S', c.Impo, Round(c.Impo * a.dolar, 2)) Else 0 End) As v3,
	\	Sum(Case c.Nitem When 4 Then If(a.Mone = 'S', c.Impo, Round(c.Impo * a.dolar, 2)) Else 0 End) As v4,
	\	Sum(Case c.Nitem When 5 Then If(a.Mone = 'S', c.Impo, Round(c.Impo * a.dolar, 2)) Else 0 End) As igv,
	\	Sum(Case c.Nitem When 6 Then If(a.Mone = 'S', c.Impo, Round(c.Impo * a.dolar, 2)) Else 0 End) As Exon,
	\	Sum(Case c.Nitem When 7 Then If(a.Mone = 'S', c.Impo, Round(c.Impo * a.dolar, 2)) Else 0 End) As otros,
	\	Sum(Case c.Nitem When 8 Then If(a.Mone = 'S', c.Impo, Round(c.Impo * a.dolar, 2)) Else 0 End) As Impo, ifnull(e.Ndoc, '') As Refe,
	\	ifnull(w.Tdoc, '00') As tref, e.fech As fechn, ifnull(e.idrefe, 0) As idrefe,
	\	a.idprov As Codigo, a.vigv, a.Detalle, ifnull(z.nomb, ' ') As Tienda, a.dolar As dola, a.Mone, a.Form, a.rcom_detr, a.rcom_fecd, Tipo, rcom_icbper
	\	From fe_rcon As a
	\	INNER Join fe_tdoc As b On(b.idtdoc = a.idtdoc)
	\	INNER Join fe_ectasc As c On(c.idrcon = a.idrcon)
	\	INNER Join fe_prov As d On(d.idprov = a.idprov)
	\	Left Join fe_refe As e On(e.idrcon = a.idrcon)
	\	Left Join fe_sucu As z On z.idalma = a.idalma
	\	Left Join fe_tdoc As w On w.idtdoc = e.idtdoc
	\Where a.rcon_acti = 'A'
	If This.nmes > 0 Then
	\ And Month(fecr) = <<This.nmes>> And Year(fecr) = <<This.Naño>>
	Else
		\And fecr Between '<<f1>>' And '<<f2>>'
	Endif
	If This.nidt > 0 Then
	   \ And a.idalma = <<This.codt>>
	Endif
	If Len(Alltrim(This.Ctipo)) > 0 Then
	\ And a.Tipo='<<this.ctipo>>'
	Endif
	\Group By a.idrcon, idrefe
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registrocompras1(Ccursor)
	f1 = Cfechas(This.fechai)
	f2 = Cfechas(This.fechaf)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select a.Form, a.fecr, a.fech, a.Tdoc, If(Length(Trim(a.Ndoc)) <= 10, Left(a.Ndoc, 3), Left(a.Ndoc, 4)) As Serie,
	\If(Length(Trim(a.Ndoc)) <= 10, MID(a.Ndoc, 4, 7), MID(a.Ndoc, 5, 8)) As Ndoc,
	\	b.nruc, b.Razo, a.valor, a.rcom_exon As Exon, a.igv, a.Impo As Importe, a.pimpo, a.Mone, a.dolar As dola, vigv, a.idprov As Codigo,
	\	ifnull(a.Deta, '')  As Detalle, a.idauto, rcom_inaf As inafecta, rcom_icbper,Concat(Trim(Dire),'',Trim(ciud)) As Direccion,tcom From fe_rcom As a
	\	Join fe_prov  As b On(b.idprov = a.idprov), fe_gene As xx
	\	Where fecr Between '<<f1>>' And '<<f2>>'  And Tdoc Not In('09','II','21')  And Acti <> 'I'
	If Len(Alltrim(This.cTdoc)) > 0 Then
	\And Tdoc='<<this.ctdoc>>'
	Endif
	If goApp.Cdatos = 'S' Then
	   \ And a.codt=<<goApp.Tienda>>
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Listarnotascreditoydebito(Ccursor)
	f1 = Cfechas(This.fechai)
	f2 = Cfechas(This.fechaf)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lC Noshow Textmerge
	select a.ndoc,a.tdoc,a.fech,b.ncre_idnc AS idn,ncre_idan  FROM (
	SELECT ncre_idnc,ncre_idau,ncre_idan FROM fe_nccom AS n
	INNER JOIN fe_rcom AS r ON r.idauto=n.`ncre_idan`
	WHERE r.fecr BETWEEN '<<f1>>'  AND '<<f2>>'  AND r.acti='A' AND  ncre_acti='A' ) AS b
	INNER JOIN  fe_rcom AS a ON a.idauto=b.ncre_idau
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function creartmp(Calias)
	Create Cursor (Calias)(Coda N(5), Desc c(40), Unid c(4), cant N(10, 2), Prec N(15, 8), ;
		alma N(10, 2), dsnc N(6, 4), dsnd N(6, 4), gast N(6, 4), Peso N(9, 4), d1 N(6, 4), d2 N(6, 4), d3 N(6, 4), Ndoc c(10), Impo N(12, 2), ;
		Nitem N(3), tipro c(1), costosf N(8, 2), costoAnt N(8, 2), costoact N(8, 2), Flete N(10, 5), swcosto N(1), Nreg N(10), ;
		valida1 c(1), nocompra N(12), Valida c(1), swpromedio N(1), Moneda c(1), preccosto N(15, 8), caant N(10, 2), TAlma N(12, 2), idcosto N(10), codigof c(20))
	Select (Calias)
	Index On Desc Tag Descri
	Index On Nitem Tag Items
	Set Order To
	Endfunc
	Function  creartmppsysl(Calias)
	Create Cursor (Calias) (Coda N(5), Desc c(150), Unid c(4), cant N(10, 2), Prec N(13, 8), ;
		alma N(10, 2), dsnc N(6, 4), dsnd N(6, 4), gast N(6, 4), Peso N(9, 4), d1 N(6, 4), d2 N(6, 4), d3 N(6, 4), Ndoc c(12), ;
		Nitem N(3), tipro c(1), costosf N(8, 2), costoAnt N(8, 2), costoact N(8, 2), Flete N(10, 5), swcosto N(1), Nreg N(10) Default 0, ;
		Impo N(12, 2), Valida c(1), swpromedio N(1), Moneda c(1), preccosto N(15, 8), caant N(10, 2), idcosto N(10), Tigv N(8, 2), ;
		swafecto N(1) Default 1, dni c(10), cletras c(150), irta N(10, 2), neto N(10, 2), valor N(12, 2), igv N(10, 2), Total N(12, 2), ;
		swirta N(1), exonerado N(12, 2), Tirta N(8, 5), razon c(200), Direccion c(200), fech d, lugar c(200), Mone c(1), Detalle c(200), Form c(20))
	Select (Calias)
	Index On Desc Tag Descri
	Index On Nitem Tag Items
	Set Order To
	Endfunc
	Function registrocomprasxsys3(Ccursor)
	f1 = Cfechas(This.fechai)
	f2 = Cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
	\Select Form,fecr,fech,Tdoc,If(Length(Trim(a.Ndoc))<=10,Left(a.Ndoc,3),Left(a.Ndoc,4)) As Serie,
	\			If(Length(Trim(a.Ndoc))<=10,Substr(a.Ndoc,4),Substr(a.Ndoc,5)) As Ndoc,nruc,Razo,
	\			Round(v1+v2+v3+v4,2) As valorg,c.Exon,c.igv As igvg,c.otros,Round(If(Tdoc<>'41',v1+v2+v3+v4+c.Exon+c.igv+otros,0),2) As Importe,
	\			Round(If(Tdoc='41',If(Mone="D",c.Impo*a.dolar,c.Impo),If(Mone="D",pimpo*a.dolar,pimpo)),2) As pimpo,
	\			a.Deta,Cast(a.dolar As Decimal(8,3)) As dola,Mone,a.idprov As Codigo,
	\			If(Tdoc='07',fech,If(Tdoc='08',fech,Cast("0001-01-01" As Date))) As fechn,
	\			If(Tdoc='07','01',If(Tdoc='08','01',' ')) As tref,
	\			If(Tdoc='07',a.Ndoc,If(Tdoc='08',a.Ndoc,' ')) As Refe,
	\			a.idauto As Auto,ndni,Cast('0' As unsigned) As T,
	\			ifnull(rcom_detr,'')  As detra,rcom_fecd As fechad,
	\			vigv,tipom As Tipo,fech As Fevto,a.rcom_icbper As icbper,'M002' As cuo,ifnull(v.nomv,'') As Vendedor From fe_rcom As a INNER Join
	\			(Select a.idauto,
	\			Sum(Case c.Nitem When 1 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As v1,
	\			Sum(Case c.Nitem When 2 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As v2,
	\			Sum(Case c.Nitem When 3 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As v3,
	\			Sum(Case c.Nitem When 4 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As v4,
	\   		Sum(Case c.Nitem When 5 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As igv,
	\			Sum(Case c.Nitem When 6 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As Exon,
	\			Sum(Case c.Nitem When 7 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As otros,
	\			Sum(Case c.Nitem When 8 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As Impo
	\			From fe_rcom As a
	\			INNER Join fe_ectasc As c On(c.idrcon=a.idauto)
	\           Where  fecr Between '<<f1>>' And '<<f2>>'  And Tdoc Not In ('09','II')  And Acti='A' And ecta_acti='A'
	If goApp.Cdatos = 'S' Then
	   \ And a.codt=<<goApp.Tienda>>
	Endif
	If Len(Alltrim(This.Ctipo)) > 0 Then
	\ And a.tipom='<<this.ctipo>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	\And Tdoc='<<this.ctdoc>>'
	Endif
	\Group By idauto)
	\As c  On(c.idauto=a.idauto)
	\Join fe_prov  As b On(b.idprov=a.idprov)
	\Left Join fe_vend As v On v.idven=a.rcom_vend  Order By fech,Serie,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, 'registro1') < 1 Then
		Return 0
	Endif
	Set Textmerge On
	Set Textmerge To  Memvar lg Noshow
    \Select a.Ndoc,a.Tdoc,a.fech,b.ncre_idnc As idn,ncre_idan  From (
	\Select ncre_idnc,ncre_idau,ncre_idan From fe_nccom As N
	\INNER Join fe_rcom As r On r.idauto=N.`ncre_idan`
	\Where Month(r.fecr)=<<This.nmes>> And Year(r.fecr)=<<This.Naño>>  And r.Acti='A' And  ncre_acti='A' ) As b
	\INNER Join  fe_rcom As a On a.idauto=b.ncre_idau
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lg, 'xnotas') < 1 Then
		Return 0
	Endif
	Create Cursor registro(Form c(1) Null, fecr d Null, fech d Null, Tdoc c(2) Null, Serie c(4), Ndoc c(8), nruc c(11)Null, Razo c(120)Null, valorg N(14, 2), Exon N(12, 2), ;
		igvg N(10, 2), otros N(12, 2), Importe N(14, 2), pimpo N(8, 2), Deta c(80), dola N(5, 3), detra c(24), fechad d,  Vendedor c(50), vigv N(5, 3), Mone c(1), Codigo N(5), fechn d, tref c(2), Refe c(12), Fevto d, ;
		Auto N(15), ndni c(8), T N(1), Tipo c(1), icbper N(8, 2))
	x = 1
	notas = 0
	Select registro1
	Scan All
		nidn = registro1.Auto
		ntdoc = '00'
		nndoc = '            '
		nfech = Ctod("  /  /    ")
		If registro1.Tdoc = '07' Or registro1.Tdoc = '08' Then
			NAuto = registro1.Auto
			Select * From xnotas Where ncre_idan = NAuto Into Cursor Xn
			notas = 1
			nidn = Xn.idn
			ntdoc = Xn.Tdoc
			nndoc = Xn.Ndoc
			nfech = Xn.fech
		Endif
		Insert Into registro(Form, fecr, fech, Tdoc, Serie, Ndoc, nruc, Razo, valorg, Exon, igvg, otros, Importe, pimpo, Deta,  dola, Mone, detra, Codigo, ;
			Auto,  tref, Refe,  Tipo, icbper, fechn, fechad, T, vigv, Vendedor);
			Values(registro1.Form, registro1.fecr, registro1.fech, registro1.Tdoc, registro1.Serie, registro1.Ndoc, ;
			registro1.nruc, registro1.Razo, registro1.valorg, registro1.Exon, registro1.igvg, registro1.otros, registro1.Importe, registro1.pimpo, registro1.Deta, ;
			registro1.dola,  registro1.Mone, registro1.detra,  ;
			registro1.Codigo, registro1.Auto,  ntdoc, nndoc, registro1.Tipo, registro1.icbper, registro1.fechn, ;
			Iif(Isnull(registro1.fechad), Ctod("  /  /    "), registro1.fechad), Iif(Tdoc = '03', 1, 6), registro1.vigv, registro1.Vendedor)

		If notas = 1 Then
			Y = 1
			Select Xn
			Scan All
				If Y > 1 Then
					Insert Into registro(Form, fecr, fech, Tdoc, Serie, Ndoc, nruc, Razo, Auto, tref, Refe, fechn, vigv);
						Values(registro1.Form, registro1.fecr, registro1.fech, registro1.Tdoc, registro1.Serie, registro1.Ndoc, ;
						registro1.nruc, registro1.Razo, Xn.idn,  Xn.Tdoc, Xn.Ndoc, Xn.fech, registro1.vigv)
					x = x + 1
				Endif
				Y = Y + 1
			Endscan
			notas = 0
		Endif

	Endscan
	Go Top In registro
	Return 1
	Endfunc
	Function AnularXsys()
	TEXT To lC Noshow  Textmerge
	 DELETE from fe_rcon WHERE idalma=<<this.codt>> and MONTH(fechr)=<<this.nmes>> and YEAR(fecr)=<<this.naño>>
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function porproveedor(Ccursor)
	fi = Cfechas(This.fechai)
	ff = Cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
	\Select x.fech,x.fecr,x.Tdoc,x.Ndoc,x.ndo2,x.Mone,x.valor,x.igv,x.Impo,x.pimpo,x.dolar As dola,x.Form,x.idauto,
	\Y.cant,Y.Prec,Round(Y.cant*Y.Prec,2)As Importe,dsnc,dsnd,gast,
	\z.Descri,z.Unid,w.nomb As Usuario,x.fusua From fe_rcom x
	\INNER Join fe_prov T On T.idprov=x.idprov
	\INNER Join fe_usua w On w.idusua=x.idusua
	\Left Join
	\(Select idart,cant,Prec,dsnc,dsnd,gast,idauto From fe_kar As k Where Acti='A' And Tipo='C') As Y
	\On Y.idauto=x.idauto
	\Left Join fe_art z On z.idart=Y.idart Where x.fech Between '<<fi>>' And '<<ff>>' And x.Acti='A'
	If This.nidprov > 0 Then
	   \And x.idprov=<<This.nidprov>>
	Endif
	If This.codt > 0 Then
	   \ And x.codt=<<This.codt>>
	Endif
	\ Order By fech
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function GrabarcomprasMercaderias()
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	NAuto = IngresaResumenDcto(This.cTdoc, Left(This.cforma, 1), This.cndoc, This.dFecha, This.dfechar, This.Cdetalle, Nv, nigv, Nt, This.cguia, This.Cmoneda, ndolar, Tigv, '1', This.nidprov, '1', goApp.nidusua, 0, This.codt, nidcta1, nidcta2, nidcta3, 0, This.npercepcion)
	If NAuto = 0
		This.DEshacerCambios()
		Return 0
	Endif
	If Left(This.cforma, 1) = 'E' And This.cTdoc <> 'II'  And  This.cTdoc <> '09'  Then
		If IngresaDatosLCajaEFectivo12(This.dfechar, "", This.cproveedor, nidcta3, 0, nmp, 'S', fe_gene.dola, nidcajero, This.nidprov, NAuto, 'E', This.cndoc, This.cTdoc, This.codt) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If Swcreditos = 1 And .cmbFORMA.ListIndex = 2 And  .txttOTAL.Value > 0
		If This.ingresadeudas() = 0
			This.DEshacerCambios()
			Return
		Endif
	Endif
	swk = 1
	Select tmpc
	Go Top
	Do While !Eof()
		If .txtredondeo.Value <> 0
			ximporte = (Round(tmpc.cant * tmpc.Prec * (100 - tmpc.d1) / 100 * (100 - tmpc.d2) / 100 * (100 - tmpc.d3) / 100, 2) + .txtredondeo.Value) + 0.00000001
			vprec = ximporte / tmpc.cant
			.txtredondeo.Value = 0
		Endif
		If .optigv.optincluido.Value = 1
			If vprec > 0
				xprec = vprec / Tigv
				vprec = 0
			Else
				xprec = (tmpc.Prec * (100 - tmpc.d1) / 100 * (100 - tmpc.d2) / 100 * (100 - tmpc.d3) / 100) / Tigv
			Endif
		Else
			If vprec > 0
				xprec = vprec
				vprec = 0
			Else
				xprec = tmpc.Prec * (100 - tmpc.d1) / 100 * (100 - tmpc.d2) / 100 * (100 - tmpc.d3) / 100
			Endif
		Endif
		nidcosto = NuevoCosto(tmpc.costoact, .NAuto, tmpc.Coda, tmpc.gast, xprec, This.Cmoneda, fe_gene.dola, This.dFecha)
		If nidcosto = 0
			swk = 0
			Exit
		Endif
		nidk = INGRESAKARDEX1(NAuto, tmpc.Coda, 'C', xprec, tmpc.cant, cincl, 'K', 0, This.codt, nidcosto, 0)
		If nidk = 0 Then
			swk = 0
			Exit
		Endif
		If This.cTdoc = '09' Then
			If IngresaGuiasCompras(.NAuto, nidk) = 0 Then
				swk = 0
				Exit
			Endif
		Endif
		If ActualizaStock(tmpc.Coda, This.codt, tmpc.cant, 'C') = 0 Then
			swk = 0
			Exit
		Endif
		If tmpc.swcosto = 1 And .r1 = 6  And xprec > 0 Then
			If tmpc.swpromedio = 1 Then
				Do Case
				Case Left(Thisform.cmbMONEDA.Value, 1) = 'S' And tmpc.Moneda = 'D'
					ncostopro = (((tmpc.preccosto * ndolar) * tmpc.TAlma) + (xprec * tmpc.cant)) / (tmpc.cant + tmpc.TAlma)
				Case Left(Thisform.cmbMONEDA.Value, 1) = 'D' And tmpc.Moneda = 'S'
					ncostopro = (((tmpc.preccosto / ndolar) * tmpc.TAlma) + (xprec * tmpc.cant)) / (tmpc.cant + tmpc.TAlma)
				Otherwise
					If tmpc.preccosto > 0 And tmpc.TAlma > 0 Then
						ncostopro = ((tmpc.preccosto * tmpc.TAlma) + (xprec * tmpc.cant)) / (tmpc.cant + tmpc.TAlma)
					Else
						ncostopro = xprec
					Endif
				Endcase
				If ncostopro = 0 Then
					swk = 0
					Exit
				Endif
				If ActualizaCostos(tmpc.Coda, This.dFecha, ncostopro, NAuto, This.nidprov, This.Cmoneda, Tigv, fe_gene.dola, 1) = 0 Then
					swk = 0
					Exit
				Endif
			Else
				If ActualizaCostos(tmpc.Coda, This.dFecha, xprec, NAuto, This.nidprov, This.Cmoneda, Tigv, fe_gene.dola, nidcosto) = 0 Then
					swk = 0
					Exit
				Endif
			Endif
		Endif
		Select tmpc
		Skip
	Enddo
	If swk = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function GrabarComprasMercaderiaspsysw()
	cproc = "rnw"
	Set Procedure To (cproc), d:\capass\modelos\ctasxpagar, d:\capass\modelos\cajae  Additive
	nmp = Iif(This.Cmoneda = 'S', This.nimpo8 + This.npercepcion, This.nimpo8 + This.npercepcion * This.ndolar)
	Obj = Createobject("SerieProducto")
	ocaja = Createobject("cajae")
	swk = 1
	ocaja.dFecha = This.dfechar
	ocaja.codt = This.codt
	ocaja.Ndoc = This.cndoc
	ocaja.Cdetalle = This.Cdetalle
	ocaja.nidcta = This.nidctat
	ocaja.ndebe = 0
	ocaja.nhaber = nmp
	ocaja.ndolar = This.ndolar
	ocaja.nidusua = goApp.nidusua
	ocaja.nidclpr = This.nidprov
	ocaja.Cmoneda = This.Cmoneda
	ocaja.cTdoc = This.cTdoc
	ocaja.cforma = This.cforma
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	NAuto = IngresaResumenDcto(This.cTdoc, This.cforma, This.cndoc, This.dFecha, This.dfechar, This.Cdetalle, This.nimpo1, This.nimpo6, This.nimpo8, This.cguia, This.Cmoneda, ;
		This.ndolar, This.vigv, '1', This.nidprov, '1', goApp.nidusua, 0, This.codt, This.nidcta1, This.nidctai, This.nidctat, 0, This.npercepcion)
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If Left(This.cforma, 1) = 'E' And This.cTdoc <> 'II'  And  This.cTdoc <> '09'  Then
		ocaja.NAuto = NAuto
		If ocaja.IngresaDatosLCajaEFectivo10() < 1 Then
			This.Cmensaje = ocaja.Cmensaje
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If  This.cforma = 'C' Then
		oxpagar = Newobject("ctasporpagar")
		oxpagar.codt = This.codt
		oxpagar.cdcto = This.cndoc
		oxpagar.Ctipo = This.Ctipo
		oxpagar.dFech = This.dFecha
		oxpagar.nimpo = This.nimpo8
		oxpagar.nidprov = This.nidprov
		oxpagar.NAuto = NAuto
		oxpagar.ccta = This.nidctat
		oxpagar.Cmoneda = This.Cmoneda
		oxpagar.ndolar = This.ndolar
		oxpagar.Calias = "tmpd"
		If  oxpagar.registramasmas() < 1 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	Select tmpc
	Go Top
	Do While !Eof()
		If This.nredondeo <> 0 Then
			ximporte = (Round(tmpc.cant * tmpc.Prec * (100 - tmpc.d1) / 100 * (100 - tmpc.d2) / 100 * (100 - tmpc.d3) / 100, 2) + This.nredondeo) + 0.00000001
			vprec = ximporte / tmpc.cant
			This.nredondeo = 0
		Endif
		If This.cincluido = 'S' Then
			If vprec > 0
				xprec = vprec / This.vigv
				vprec = 0
			Else
				xprec = (tmpc.Prec * (100 - tmpc.d1) / 100 * (100 - tmpc.d2) / 100 * (100 - tmpc.d3) / 100) / This.vigv
			Endif
		Else
			If vprec > 0
				xprec = vprec
				vprec = 0
			Else
				xprec = tmpc.Prec * (100 - tmpc.d1) / 100 * (100 - tmpc.d2) / 100 * (100 - tmpc.d3) / 100
			Endif
		Endif
		nidcosto = NuevoCosto(tmpc.costoact, NAuto, tmpc.Coda, tmpc.gast, xprec, This.Cmoneda, This.ndolar, This.dFecha)
		If nidcosto = 0
			swk = 0
			Exit
		Endif
		nidk = INGRESAKARDEX1(NAuto, tmpc.Coda, 'C', xprec, tmpc.cant, cincl, 'K', 0, This.codt, 0, 0)
		If nidk < 1 Then
			swk = 0
			Exit
		Endif
		If !Empty(tmpc.SerieProducto) Then
			Obj.AsignaValores(tmpc.SerieProducto, NAuto, nidk, tmpc.Coda)
			nidrs = Obj.RegistraRserie()
			If nidrs <= 0 Then
				swk = 0
				Exit
			Endif
			If Obj.RegistraDseries(nidrs) < 1 Then
				swk = 0
				Exit
			Endif
		Endif
		If This.cTdoc = '09' Then
			If IngresaGuiasCompras(NAuto, nidk) = 0 Then
				swk = 0
				Exit
			Endif
		Endif
		If ActualizaStock(tmpc.Coda, This.codt, tmpc.cant, 'C') = 0 Then
			swk = 0
			Exit
		Endif
		If tmpc.swcosto = 1 And This.cgrabaprecios = 'S'  And This.cTdoc = '01' Then
			If ActualizaCostos(tmpc.Coda, This.dFecha, xprec, NAuto, This.nidprov, This.Cmoneda, This.vigv, This.ndolar, nidcosto) = 0 Then
				swk = 0
				Exit
			Endif
		Endif
		Select tmpc
		Skip
	Enddo
	If swk = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizarComprasTdctoPsysw()
	Set Procedure To d:\capass\modelos\ctasxpagar, d:\capass\modelos\cajae  Additive
	nmp = Iif(This.Cmoneda = 'S', This.nimpo8 + This.npercepcion, This.nimpo8 + This.npercepcion * This.ndolar)
	ocaja = Createobject("cajae")
	oxpagar = Createobject("ctasporpagar")
	ocaja.dFecha = This.dfechar
	ocaja.codt = This.codt
	ocaja.Ndoc = This.cndoc
	ocaja.Cdetalle = This.Cdetalle
	ocaja.nidcta = This.nidctat
	ocaja.ndebe = 0
	ocaja.nhaber = nmp
	ocaja.ndolar = This.ndolar
	ocaja.nidusua = goApp.nidusua
	ocaja.nidclpr = This.nidprov
	ocaja.Cmoneda = This.Cmoneda
	ocaja.cTdoc = This.cTdoc
	ocaja.cforma = This.cforma
	If IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If ActualizaResumenDcto(This.cTdoc, This.cforma, This.cndoc, This.dFecha, This.dfechar, "", This.nimpo1, This.nimpo6, This.nimpo8, This.cguia, This.Cmoneda, ;
			This.ndolar, This.vigv, '1', This.nidprov, '1', goApp.nidusua, 0, This.codt, This.nidcta1, This.nidctai, This.nidctat, 0, This.npercepcion, This.Nreg) = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	ocaja.NAuto = This.Nreg
	If ocaja.IngresaDatosLCajaEFectivo10() < 1 Then
		This.Cmensaje = ocaja.Cmensaje
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.cforma = 'C' Then
		If This.Nreg > 0 Then
			If oxpagar.ACtualizaDeudas(This.Nreg, goApp.nidusua) < 1 Then
				This.DEshacerCambios()
				This.Cmensaje = oxpagar.Cmensaje
				Return 0
			Endif
		Endif
		oxpagar.codt = This.codt
		oxpagar.cdcto = This.cndoc
		oxpagar.Ctipo = This.Ctipo
		oxpagar.dFech = This.dFecha
		oxpagar.nimpo = This.nimpo8
		oxpagar.nidprov = This.nidprov
		oxpagar.NAuto = This.Nreg
		oxpagar.ccta = This.nidctat
		oxpagar.Cmoneda = This.Cmoneda
		oxpagar.ndolar = This.ndolar
		oxpagar.Calias = "tmpd"
		If  oxpagar.registramasmas() < 1 Then
			This.DEshacerCambios()
			This.Cmensaje = oxpagar.Cmensaje
			Return 0
		Endif
	Endif
	Sw = 1
	vprec = 0
	xprec = 0
	Select utmpc
	Set Deleted Off
	Go Top
	Do While !Eof()
		If Deleted()
			If utmpc.Nreg > 0 Then
				If Actualizakardex1(This.Nreg, utmpc.Coda, 'C', 0, utmpc.cant, This.cincluido, 'K', 0, This.codt, 0, utmpc.Nreg, 0, 0) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
		Else
			If This.nredondeo <> 0
				ximporte = (Round(utmpc.cant * utmpc.Prec * (100 - utmpc.d1) / 100 * (100 - utmpc.d2) / 100 * (100 - utmpc.d3) / 100, 2) + This.nredondeo) + 0.00000001
				vprec = ximporte / utmpc.cant
				This.nredondeo = 0
			Endif
			If This.cincluido = 'S' Then
				If vprec > 0 Then
					xprec = vprec / This.vigv
					vprec = 0
				Else
					xprec = (utmpc.Prec * (100 - utmpc.d1) / 100 * (100 - utmpc.d2) / 100 * (100 - utmpc.d3) / 100) / This.vigv
				Endif
			Else
				If vprec > 0 Then
					xprec = vprec
					vprec = 0
				Else
					xprec = utmpc.Prec * (100 - utmpc.d1) / 100 * (100 - utmpc.d2) / 100 * (100 - utmpc.d3) / 100
				Endif
			Endif
			If utmpc.Nreg = 0  Or Empty(utmpc.Nreg) Then
				nidcosto = NuevoCosto(utmpc.costoact, This.Nreg, utmpc.Coda, utmpc.gast, xprec, This.Cmoneda, This.ndolar, This.dFecha)
				If nidcosto = 0 Then
					Sw = 0
					Exit
				Endif
				nidk = INGRESAKARDEX1(This.Nreg, utmpc.Coda, 'C', xprec, utmpc.cant, This.cincluido, 'K', 0, This.codt, 0, 0)
				If nidk = 0 Then
					Sw = 0
					Exit
				Endif
			Else
				nidcosto = utmpc.idcosto
				nidk = utmpc.Nreg
				If Actualizakardex1(This.Nreg, utmpc.Coda, 'C', xprec, utmpc.cant, This.cincluido, 'K', 0, This.codt, 0, utmpc.Nreg, 1, 0) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
			If This.cTdoc = '09' Then
				If IngresaGuiasCompras(This.Nreg, nidk) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
			If  This.codt > 0 Then
				If ActualizaStock11(utmpc.Coda, This.codt, utmpc.cant, 'C', utmpc.caant) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
			If utmpc.swcosto = 1 And This.cgrabaprecios = 'S' Then
				If ActualizaCostos(utmpc.Coda, This.dFecha, xprec, This.Nreg, This.nidprov, This.Cmoneda, This.vigv, This.ndolar, nidcosto) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
		Endif
		Select utmpc
		Skip
	Enddo
	Set Deleted On
	If Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.GRabarCambios() = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizarDetalleComprasMercaderias()
	vprec = 0
	xprec = 0
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	Sw = 1
	Select utmpc
	Set Deleted Off
	Go Top
	Do While !Eof()
		If Deleted()
			If utmpc.Nreg > 0 Then
				If Actualizakardex1(This.Nreg, utmpc.Coda, 'C', xprec, utmpc.cant, This.cincluido, 'K', 0, This.codt, 0, utmpc.Nreg, 0, 0) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
		Else
			If This.nredondeo <> 0
				ximporte = (Round(utmpc.cant * utmpc.Prec * (100 - utmpc.d1) / 100 * (100 - utmpc.d2) / 100 * (100 - utmpc.d3) / 100, 2) + This.nredondeo) + 0.00000001
				vprec = ximporte / utmpc.cant
				This.nredondeo = 0
			Endif
			If This.cincluido = 'S' Then
				If vprec > 0
					xprec = vprec / This.vigv
					vprec = 0
				Else
					xprec = (utmpc.Prec * (100 - utmpc.d1) / 100 * (100 - utmpc.d2) / 100 * (100 - utmpc.d3) / 100) / This.vigv
				Endif
			Else
				If vprec > 0
					xprec = vprec
					vprec = 0
				Else
					xprec = utmpc.Prec * (100 - utmpc.d1) / 100 * (100 - utmpc.d2) / 100 * (100 - utmpc.d3) / 100
				Endif
			Endif
			If utmpc.Nreg = 0  Or Empty(utmpc.Nreg) Then
				nidk = INGRESAKARDEX1(This.Nreg, utmpc.Coda, 'C', xprec, utmpc.cant, This.cincluido, 'K', 0, This.codt, 0, 0)
				If nidk = 0 Then
					Sw = 0
					Exit
				Endif
			Else
				nidcosto = utmpc.idcosto
				nidk = utmpc.Nreg
				If Actualizakardex1(This.Nreg, utmpc.Coda, 'C', xprec, utmpc.cant, This.cincluido, 'K', 0, This.codt, 0, utmpc.Nreg, 1, 0) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
			If This.codt > 0 Then
				If ActualizaStock11(utmpc.Coda, This.codt, utmpc.cant, 'C', utmpc.caant) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
		Endif
		Select utmpc
		Skip
	Enddo
	Set Deleted On
	If Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If 	This.GRabarCambios() = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function actualizarcostosdesdecompras()
	Local vprec, xprec
	vprec = 0
	xprec = 0
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	Sw = 1
	Select utmpc
	Go Top
	Do While !Eof()
		If This.nredondeo <> 0 Then
			ximporte = (Round(utmpc.cant * utmpc.Prec * (100 - utmpc.d1) / 100 * (100 - utmpc.d2) / 100 * (100 - utmpc.d3) / 100, 2) + This.nredondeo) + 0.00000001
			vprec = ximporte / utmpc.cant
			This.nredondeo = 0
		Endif
		If This.cincluido = 'S' Then
			If vprec > 0
				xprec = vprec / This.vigv
				vprec = 0
			Else
				xprec = (utmpc.Prec * (100 - utmpc.d1) / 100 * (100 - utmpc.d2) / 100 * (100 - utmpc.d3) / 100) / This.vigv
			Endif
		Else
			If vprec > 0
				xprec = vprec
				vprec = 0
			Else
				xprec = utmpc.Prec * (100 - utmpc.d1) / 100 * (100 - utmpc.d2) / 100 * (100 - utmpc.d3) / 100
			Endif
		Endif
		If utmpc.Nreg > 0
			nidcosto = utmpc.idcosto
			If utmpc.swcosto = 1 Then
				If ActualizaCostos(utmpc.Coda, This.dFecha, xprec, This.Nreg, This.nidprov, This.Cmoneda, This.vigv, This.ndolar, nidcosto) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
		Endif
		Select utmpc
		Skip
	Enddo
	If Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizarPartedcto()
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If ActualizaResumenDcto(This.cTdoc, This.cforma, This.cndoc, This.dFecha, This.dfechar, This.Cdetalle, This.nimpo1, This.nimpo6, This.nimpo8, This.cguia, This.Cmoneda, ;
			This.ndolar, This.vigv, '1', This.ndolar, '1', goApp.nidusua, 0, This.codt, This.nidcta1, This.nidctai, This.nidctat, 0, This.npercepcion, This.Nreg) = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Sw = 1
	Select utmpc
	Set Deleted Off
	Go Top
	Do While !Eof()
		If Deleted()
			If utmpc.Nreg > 0 Then
				If Actualizakardex1(This.Nreg, utmpc.Coda, 'C', xprec, utmpc.cant, This.cincluido, 'K', 0, This.codt, 0, utmpc.Nreg, 0, 0) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
		Else
			If This.nredondeo <> 0 Then
				ximporte = (Round(utmpc.cant * utmpc.Prec * (100 - utmpc.d1) / 100 * (100 - utmpc.d2) / 100 * (100 - utmpc.d3) / 100, 2) + This.nredondeo) + 0.00000001
				vprec = ximporte / utmpc.cant
				This.nredondeo = 0
			Endif
			If This.cincluido = 'S' Then
				If vprec > 0
					xprec = vprec / This.vigv
					vprec = 0
				Else
					xprec = (utmpc.Prec * (100 - utmpc.d1) / 100 * (100 - utmpc.d2) / 100 * (100 - utmpc.d3) / 100) / This.vigv
				Endif
			Else
				If vprec > 0
					xprec = vprec
					vprec = 0
				Else
					xprec = utmpc.Prec * (100 - utmpc.d1) / 100 * (100 - utmpc.d2) / 100 * (100 - utmpc.d3) / 100
				Endif
			Endif
			If utmpc.Nreg = 0  Or Empty(utmpc.Nreg) Then
				nidcosto = NuevoCosto(utmpc.costoact, This.Nreg, utmpc.Coda, utmpc.gast, xprec, This.Cmoneda, fe_gene.dola, This.dFecha)
				If nidcosto = 0
					Sw = 0
					Exit
				Endif
				nidk = INGRESAKARDEX1(This.Nreg, utmpc.Coda, 'C', xprec, utmpc.cant, This.cincluido, 'K', 0, This.codt, nidcosto, 0)
				If nidk = 0 Then
					Sw = 0
					Exit
				Endif
			Else
				nidcosto = utmpc.idcosto
				nidk = utmpc.Nreg
				If Actualizakardex1(This.Nreg, utmpc.Coda, 'C', xprec, utmpc.cant, This.cincluido, 'K', 0, This.codt, 0, utmpc.Nreg, 1, 0) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
			If This.cTdoc = '09' Then
				If IngresaGuiasCompras(This.Nreg, nidk) = 0 Then
					.swk = 0
					Exit
				Endif
			Endif
			If This.codt > 0 Then
				If ActualizaStock11(utmpc.Coda, This.codt, utmpc.cant, 'C', utmpc.caant) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
			If utmpc.swcosto = 1 And This.cgrabaprecios = 6 Then
				If ActualizaCostos(utmpc.Coda, This.dFecha, xprec, This.Nreg, This.nidprov, This.Cmoneda, This.vigv, This.ndolar, nidcosto) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
		Endif
		Select utmpc
		Skip
	Enddo
	Set Deleted On
	If Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function GrabarComprasMercaderiasvarios()
	Set Procedure To d:\capass\modelos\ctasxpagar, d:\capass\modelos\cajae  Additive
	nmp = Iif(This.Cmoneda = 'S', This.nimpo8 + This.npercepcion, This.nimpo8 + This.npercepcion * This.ndolar)
	ocaja = Createobject("cajae")
	swk = 1
	ocaja.dFecha = This.dfechar
	ocaja.codt = This.codt
	ocaja.Ndoc = This.cndoc
	ocaja.Cdetalle = This.Cdetalle
	ocaja.nidcta = This.nidctat
	ocaja.ndebe = 0
	ocaja.nhaber = nmp
	ocaja.ndolar = This.ndolar
	ocaja.nidusua = goApp.nidusua
	ocaja.nidclpr = This.nidprov
	ocaja.Cmoneda = This.Cmoneda
	ocaja.cTdoc = This.cTdoc
	ocaja.cforma = This.cforma
	ocaja.codt = This.codt
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	NAuto = IngresaResumenDcto(This.cTdoc, This.cforma, This.cndoc, This.dFecha, This.dfechar, This.Cdetalle, This.nimpo1, This.nimpo6, This.nimpo8, This.cguia, This.Cmoneda, ;
		This.ndolar, This.vigv, '1', This.nidprov, '1', goApp.nidusua, 0, This.codt, This.nidcta1, This.nidctai, This.nidctat, 0, This.npercepcion)
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If Left(This.cforma, 1) = 'E' And This.cTdoc <> 'II'  And  This.cTdoc <> '09'  Then
		ocaja.NAuto = NAuto
		If ocaja.IngresaDatosLCajaEFectivo11() < 1 Then
			This.Cmensaje = ocaja.Cmensaje
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If  This.cforma = 'C' Then
		oxpagar = Newobject("ctasporpagar")
		oxpagar.codt = This.codt
		oxpagar.cdcto = This.cndoc
		oxpagar.Ctipo = This.Ctipo
		oxpagar.dFech = This.dFecha
		oxpagar.nimpo = This.nimpo8
		oxpagar.nidprov = This.nidprov
		oxpagar.NAuto = NAuto
		oxpagar.ccta = This.nidctat
		oxpagar.Cmoneda = This.Cmoneda
		oxpagar.ndolar = This.ndolar
		oxpagar.Calias = "tmpd"
		If  oxpagar.registramasmas() < 1 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	Select tmpc
	Go Top
	Do While !Eof()
		If This.nredondeo <> 0 Then
			ximporte = (Round(tmpc.cant * tmpc.Prec * (100 - tmpc.d1) / 100 * (100 - tmpc.d2) / 100 * (100 - tmpc.d3) / 100, 2) + This.nredondeo) + 0.00000001
			vprec = ximporte / tmpc.cant
			This.nredondeo = 0
		Endif
		If This.cincluido = 'S' Then
			If vprec > 0
				xprec = vprec / This.vigv
				vprec = 0
			Else
				xprec = (tmpc.Prec * (100 - tmpc.d1) / 100 * (100 - tmpc.d2) / 100 * (100 - tmpc.d3) / 100) / This.vigv
			Endif
		Else
			If vprec > 0
				xprec = vprec
				vprec = 0
			Else
				xprec = tmpc.Prec * (100 - tmpc.d1) / 100 * (100 - tmpc.d2) / 100 * (100 - tmpc.d3) / 100
			Endif
		Endif
		nidcosto = NuevoCosto(tmpc.costoact, NAuto, tmpc.Coda, tmpc.gast, xprec, This.Cmoneda, This.ndolar, This.dFecha)
		If nidcosto = 0
			swk = 0
			Exit
		Endif
		nidk = INGRESAKARDEX1(NAuto, tmpc.Coda, 'C', xprec, tmpc.cant, cincl, 'K', 0, This.codt, nidcosto, 0)
		If nidk < 1 Then
			swk = 0
			Exit
		Endif
		If This.cTdoc = '09' Then
			If IngresaGuiasCompras(NAuto, nidk) = 0 Then
				swk = 0
				Exit
			Endif
		Endif
		If ActualizaStock(tmpc.Coda, This.codt, tmpc.cant, 'C') = 0 Then
			swk = 0
			Exit
		Endif
		If tmpc.swcosto = 1 And This.cgrabaprecios = 'S' And xprec > 0 Then
			If ActualizaCostos(tmpc.Coda, This.dFecha, xprec, NAuto, This.nidprov, This.Cmoneda, This.vigv, This.ndolar, nidcosto) = 0 Then
				swk = 0
				Exit
			Endif
		Endif
		Select tmpc
		Skip
	Enddo
	If swk = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizarComprasTdctovarios()
	Set Procedure To d:\capass\modelos\ctasxpagar, d:\capass\modelos\cajae  Additive
	nmp = Iif(This.Cmoneda = 'S', This.nimpo8 + This.npercepcion, This.nimpo8 + This.npercepcion * This.ndolar)
	ocaja = Createobject("cajae")
	ocaja.dFecha = This.dfechar
	ocaja.codt = This.codt
	ocaja.Ndoc = This.cndoc
	ocaja.Cdetalle = This.Cdetalle
	ocaja.nidcta = This.nidctat
	ocaja.ndebe = 0
	ocaja.nhaber = nmp
	ocaja.ndolar = This.ndolar
	ocaja.nidusua = goApp.nidusua
	ocaja.nidclpr = This.nidprov
	ocaja.Cmoneda = This.Cmoneda
	ocaja.cTdoc = This.cTdoc
	ocaja.cforma = This.cforma
	ocaja.codt = This.codt
	If IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If ActualizaResumenDcto(This.cTdoc, This.cforma, This.cndoc, This.dFecha, This.dfechar, "", This.nimpo1, This.nimpo6, This.nimpo8, This.cguia, This.Cmoneda, ;
			This.ndolar, This.vigv, '1', This.nidprov, '1', goApp.nidusua, 0, This.codt, This.nidcta1, This.nidctai, This.nidctat, 0, This.npercepcion, This.Nreg) = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	ocaja.NAuto = This.Nreg
	If ocaja.IngresaDatosLCajaEFectivo10() < 1 Then
		This.Cmensaje = ocaja.Cmensaje
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.cforma = 'C' Then
		If This.Nreg > 0 Then
			If ACtualizaDeudas(This.Nreg, goApp.nidusua) = 0
				This.DEshacerCambios()
				Return 0
			Endif
		Endif
		oxpagar = Newobject("ctasporpagar")
		oxpagar.codt = This.codt
		oxpagar.cdcto = This.cndoc
		oxpagar.Ctipo = This.Ctipo
		oxpagar.dFech = This.dFecha
		oxpagar.nimpo = This.nimpo8
		oxpagar.nidprov = This.nidprov
		oxpagar.NAuto = This.Nreg
		oxpagar.ccta = This.nidctat
		oxpagar.Cmoneda = This.Cmoneda
		oxpagar.ndolar = This.ndolar
		oxpagar.Calias = "tmpd"
		If  oxpagar.registramasmas() < 1 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	Sw = 1
	vprec = 0
	xprec = 0
	Select utmpc
	Set Deleted Off
	Go Top
	Do While !Eof()
		If Deleted()
			If utmpc.Nreg > 0 Then
				If Actualizakardex1(This.Nreg, utmpc.Coda, 'C', 0, utmpc.cant, This.cincluido, 'K', 0, This.codt, 0, utmpc.Nreg, 0, 0) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
		Else
			If This.nredondeo <> 0
				ximporte = (Round(utmpc.cant * utmpc.Prec * (100 - utmpc.d1) / 100 * (100 - utmpc.d2) / 100 * (100 - utmpc.d3) / 100, 2) + This.nredondeo) + 0.00000001
				vprec = ximporte / utmpc.cant
				This.nredondeo = 0
			Endif
			If This.cincluido = 'S' Then
				If vprec > 0 Then
					xprec = vprec / This.vigv
					vprec = 0
				Else
					xprec = (utmpc.Prec * (100 - utmpc.d1) / 100 * (100 - utmpc.d2) / 100 * (100 - utmpc.d3) / 100) / This.vigv
				Endif
			Else
				If vprec > 0 Then
					xprec = vprec
					vprec = 0
				Else
					xprec = utmpc.Prec * (100 - utmpc.d1) / 100 * (100 - utmpc.d2) / 100 * (100 - utmpc.d3) / 100
				Endif
			Endif
			If utmpc.Nreg = 0  Or Empty(utmpc.Nreg) Then
				nidcosto = NuevoCosto(utmpc.costoact, This.Nreg, utmpc.Coda, utmpc.gast, xprec, This.Cmoneda, This.ndolar, This.dFecha)
				If nidcosto = 0 Then
					Sw = 0
					Exit
				Endif
				nidk = INGRESAKARDEX1(This.Nreg, utmpc.Coda, 'C', xprec, utmpc.cant, This.cincluido, 'K', 0, This.codt, nidcosto, 0)
				If nidk = 0 Then
					Sw = 0
					Exit
				Endif
			Else
				nidcosto = utmpc.idcosto
				nidk = utmpc.Nreg
				If Actualizakardex1(This.Nreg, utmpc.Coda, 'C', xprec, utmpc.cant, This.cincluido, 'K', 0, This.codt, 0, utmpc.Nreg, 1, 0) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
			If This.cTdoc = '09' Then
				If IngresaGuiasCompras(This.Nreg, nidk) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
			If  This.codt > 0 Then
				If ActualizaStock11(utmpc.Coda, This.codt, utmpc.cant, 'C', utmpc.caant) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
			If utmpc.swcosto = 1 And This.cgrabaprecios = 'S' Then
				If ActualizaCostos(utmpc.Coda, This.dFecha, xprec, This.Nreg, This.nidprov, This.Cmoneda, This.vigv, This.ndolar, nidcosto) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
		Endif
		Select utmpc
		Skip
	Enddo
	Set Deleted On
	If Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.GRabarCambios() = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function GrabarcomprasMercaderia()
	lC = 'FunIngresaCabeceraCompras'
	cur = "Xn"
	TEXT To lp Noshow Textmerge
     ('<<This.cTdoc>>', '<<Left(This.cforma, 1)>>', '<<This.cndoc>>', '<<cfechas(This.dFecha)>>','<<cfechas(This.dfechar)>>', '<<This.cdetalle>>',  <<This.nimpo1>>, <<This.nimpo6>>, <<This.nimpo8>>,'<<This.cguia>>', '<<This.Cmoneda>>', '<<this.ndolar>>', <<this.vigv>>, '<<1>>', <<This.nidprov>>, '<<1>>', <<goApp.nidusua>>, 0, <<This.codt>>, <<this.nidcta1>>, <<this.nidctai>>, <<this.nidctat>>, '<<this.ctipoingreso>>', <<This.npercepcion>>)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function listardetallecomprasxmercaderia(Ccursor)
	dfechaI = Cfechas(This.fechai)
	dfechaf = Cfechas(This.fechaf)
	If !Pemstatus(goApp, 'proyecto', 5) Then
		AddProperty(goApp, 'proyecto', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select Tdoc,Ndoc,a.fech,c.Razo,
	If goApp.Proyecto = 'psysrx' Or goApp.Proyecto = 'psysr' Then
    \ Concat(Trim(d.idart),' ',Trim(d.Descri)) As Descri,
	Else
    \ d.Descri,
	Endif
    \d.Unid,cant,e.Prec,Mone,F.nomb As Usuario,Form,e.cant*e.Prec As Impo,valor,a.igv,Impo As Importe,e.idart As Codigo,s.nomb As Almacen From
  	\fe_rcom As a
	\INNER Join fe_prov As c On c.idprov=a.idprov
	\Left Join fe_kar As e On e.idauto=a.idauto
	\Left Join fe_art As d On d.idart=e.idart
	\INNER Join fe_sucu As s On s.idalma=e.alma
	\INNER Join fe_usua As F On F.idusua=a.idusua,fe_gene As z
	\Where a.fech Between '<<dfechai>>' And '<<dfechaf>>'  And a.Acti='A' And e.Acti='A'
	If This.codt > 0 Then
	 \ And a.codt=<<This.codt>>
	Endif
	If This.solocontables = 'S' Then
	 \ And a.Tdoc In("01","50","07","08","09")
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\Order By a.fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listardetallecomprasxmercaderia1(Ccursor)
	dfechaI = Cfechas(This.fechai)
	dfechaf = Cfechas(This.fechaf)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select a.Tdoc,a.Ndoc,a.fech,c.Razo As proveedor,ifnull(d.Descri,'') As producto,ifnull(d.Unid,'') As Unid,
	\ifnull(e.cant,0) As cant,ifnull(e.Prec,0) As Prec,a.Mone,F.nomb As Usuario,prod_cod1 As codigofabrica,
	\ifnull(l.dcat,'') As categoria,ifnull(desgrupo,'') As grupo,ifnull(m.dmar,'') As marca,
	\ifnull(prod_acti,'') As estado,Round(If(d.tmon='S',(d.Prec*z.igv)+b.Prec,(d.Prec*z.igv*z.dola)+b.Prec),2) As costo,
	\Cast(ifnull(e.cant*e.Prec,0) As Decimal(12,2))  As Impo,
	\a.Form,c.nruc,c.ndni,d.idart,a.dolar From
  	\	fe_rcom As a
	\INNER Join fe_prov As c On c.idprov=a.idprov
	\Left Join fe_kar As e On e.idauto=a.idauto
	\Left Join fe_art As d On d.idart=e.idart
	\Left Join fe_cat As l On l.idcat=d.idcat
	\Left Join fe_grupo As g On g.idgrupo=l.idgrupo
	\Left  Join fe_mar As m On m.idmar=d.idmar
	\Left Join fe_fletes As b On b.idflete=d.idflete
	\INNER Join fe_usua As F On F.idusua=a.idusua,fe_gene As z
	\Where a.fech Between '<<dfechai>>' And '<<dfechaf>>'  And a.Acti='A' And e.Acti='A'
	If This.codt > 0 Then
	 \ And a.codt=<<This.codt>>
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\Order By a.fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarxidpsysu(Ccursor)
	TEXT To lC Noshow Textmerge
	  SELECT   c.idusua, a.idauto,  a.alma ,  a.idkar,  a.kar_equi ,  b.descri ,  b.peso,
	  b.prod_idco ,  a.kar_unid  AS unid,  b.tipro,  a.idart,  a.incl,  c.ndoc,
	  c.valor   ,  c.igv,  c.impo,rcom_exon,  c.pimpo,  a.cant  a.prec,c.fech  ,  c.fecr,  c.form ,  c.exon,  c.ndo2,  c.vigv,
	  c.idprov,  a.tipo,  c.tdoc,  c.dolar,  c.mone,  p.razo, p.dire , p.ciud ,  p.nruc,  a.kar_posi,  a.kar_epta,  IFNULL(x.idcaja,0) AS Idcaja,
	  c.codt ,  c.fusua,  w.nomb      AS Usuario,kar_tigv
	 FROM fe_rcom c
     LEFT JOIN fe_kar a   ON c.idauto = a.idauto
     LEFT JOIN fe_art b    ON b.idart = a.idart
     JOIN fe_prov p         ON p.idprov = c.idprov
     LEFT JOIN fe_caja x     ON x.idauto = c.idauto
     JOIN fe_usua w    ON w.idusua = c.idusua
     WHERE c.acti = 'A'    AND a.acti = 'A' and c.idauto=<<this.Nreg>> order by idkar
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarcomprasresumidas(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select Ndoc,fech,b.Razo,Mone,valor,igv,Impo,idauto,Tdoc,a.idprov As cod From
	\fe_rcom As a
	\INNER Join fe_prov As b On b.idprov=a.idprov Where  a.Acti<>'I'
	If This.nidprov > 0 Then
       \a.idprov=<<This.nidprov>> And Tdoc="01"
	Endif
	If This.codt > 0 Then
       \ And a.codt=<<This.codt>>
	Endif
	If This.nmes > 0 Then
	\ And Month(a.fech)=<<This.nmes>>
	Endif
	If This.Naño > 0 Then
	\ And Year(a.fech)=<<This.Naño>>
	Endif
    \ Order By fech Desc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarparaaplicarnotasunidades(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lC Noshow Textmerge
          SELECT a.idart,a.descri,x.kar_unid as unid,x.cant,ROUND(x.prec*r.vigv,2) as prec,
          ROUND(x.cant*x.prec*r.vigv,2) as importe,r.idauto,r.mone,r.valor,r.igv,r.impo,x.kar_equi,
          r.fech,r.ndoc,r.tdoc,r.dolar as dola FROM fe_rcom as r
          inner join fe_kar as x  ON x.idauto=r.idauto
          inner join fe_art as a on a.idart=x.idart, fe_gene as v  WHERE r.idauto=<<this.Nreg>>
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarparaaplicarnotas(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lC Noshow Textmerge
      SELECT a.idart,a.descri,a.unid,k.cant,ROUND(k.prec*r.vigv,2) AS prec,
      ROUND(k.cant*k.prec*r.vigv,2) AS importe,r.idauto,r.mone,r.valor,r.igv,r.impo,r.rcom_exon,
      r.fech,r.ndoc,r.tdoc,r.dolar AS dola FROM fe_rcom AS r
      INNER JOIN fe_kar AS k ON k.`idauto`=r.`idauto`
      INNER JOIN fe_art AS a ON a.idart=k.`idart`
      WHERE r.idauto=<<this.Nreg>>
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarcomprasparaseleccionar(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar  lC Noshow Textmerge
    \Select  Tdoc,Ndoc,fech,b.Razo,Mone,valor,igv,Impo,idauto,a.idprov As cod,fecr From
    \fe_rcom As a
    \INNER Join fe_prov As b On b.idprov=a.idprov Where a.Acti<>'I'
	If This.nidprov > 0 Then
       \ And a.idprov=<<This.nidprov>>
	Else
		If This.nmes > 0 Then
           \And Month(fech)=<<This.nmes>> And Year(fech)=<<This.Naño>>
		Endif
	Endif
    \Order By fech Desc,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarotracompra(Ccursor)
	If !Pemstatus(goApp, 'ccostos', 5) Then
		AddProperty(goApp, 'ccostos', '')
	Endif
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	  \Select  `c`.`Ndoc`   As `Ndoc`,  `c`.`valor`  As `valor`,  `c`.`igv`    As `igv`,
	  \`c`.`Impo`   As `Impo`,  `c`.`pimpo`  As `pimpo`,  `c`.`fech`   As `fech`,
	  \`c`.`fecr`   As `fecr`,  `c`.`Form`   As `Form`,  `c`.`Exon`   As `Exon`,
	  \`c`.`ndo2`   As `ndo2`,  `c`.`idauto` As `idauto`,  `c`.`Deta`   As `Deta`,
	  \`c`.`tcom`   As `tcom`,  `c`.`vigv`   As `vigv`,  `c`.`idprov` As `idprov`,
	  \`c`.`Tdoc`   As `Tdoc`,  `c`.`dolar`  As `dolar`,  `c`.`Mone`   As `Mone`,
	  \`p`.`Razo`   As `Razo`,  `p`.`Dire`   As `Dire`,  `p`.`ciud`   As `ciud`,
	  \`p`.`nruc`   As `nruc`,  Cast(0 As unsigned) As `idcaja`,  c.codt
	If  goApp.Ccostos = 'S' Then
       \ ,rcom_ccos
	Endif
	  \`c`.`fusua`  As `fusua`,  `w`.`nomb`   As `Usuario`From `fe_rcom` `c`
      \Join `fe_prov` `p`      On `p`.`idprov` = `c`.`idprov`
      \Join `fe_usua` `w`  On `w`.`idusua` = `c`.`idusua`
      \Where `c`.`Acti` = 'A' And c.idauto=<<This.Nreg>>
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function estadisticacompras(chk, Ccursor)
	fi = Cfechas(This.fechai)
	ff = Cfechas(This.fechaf)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\ Select q.mes,Sum(q.Impo) As tah From ( Select w.mes,
    \      Sum(w.Impo) As Impo  From (Select Month(a.fech) As mes,Year(a.fech) As Año,
    \      a.Form,If(a.Mone='S',a.Impo,a.Impo*a.dolar) As Impo From fe_rcom As a
 	\	  Where a.Acti='A'  And idprov>0
	If chk = 0 Then
 	  \ And Year(fech)=<<This.Naño>>
	Else
 	   \ And a.fech Between '<<fi>>' And '<<ff>>'
	Endif
	If This.codt > 0 Then
 	 \ And a.codt=<<This.codt>>
	Endif
	If Len(Alltrim(This.cforma)) > 0 Then
 	  \ And a.Form='<<this.cforma>>'
	Endif
 	\Order By fech) As w  Group By mes) As q Group By mes
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarComprasporProducto(ccoda, Na, Ccursor)
	dfi = Cfechas(This.fechai)
	dff = Cfechas(This.fechaf)
	If !Pemstatus(goApp, 'proyecto', 5)
		AddProperty(goApp, 'proyecto', '')
	Endif
	If This.Idsesion > 0 Then
		Set DataSession To  This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select b.Razo,c.fech
	If goApp.Proyecto = 'psysg' Or goApp.Proyecto = 'xsys3'  Or goApp.Proyecto = 'psysu' Then
      \,kar_unid As Unid,kar_equi
	Endif
    \,cant,CAST(a.Prec*c.vigv as decimal(12,6)) As Prec,If(c.Mone='S','Soles','Dólares') As Moneda,c.Tdoc As Tdoc,
	\c.Ndoc As Ndoc,Month(c.fech) As mes,s.nomb As Tienda,c.Mone,a.alma,a.Prec As preciocompra,c.idprov,CAST(If(c.Mone='D',Prec*c.dolar*c.vigv,Prec*c.vigv) as decimal(12,6))As precios From fe_kar As a
	\INNER Join fe_rcom  As c On(c.idauto=a.idauto)
	\INNER Join fe_prov As b On (b.idprov=c.idprov)
	\INNER Join fe_sucu As s On s.idalma=c.codt
	\Where c.Acti<>'I' And a.Acti='A'
	If goApp.Proyecto = 'psysrx' Or goApp.Proyecto = 'psysr' Then
       \ And  idart='<<ccoda>>'
	Else
       \ And  idart=<<ccoda>>
	Endif
	If Na > 0 Then
        \ And Year(c.fech)=<<Na>>
	Else
		\ And c.fech Between '<<dfi>>' And '<<dff>>'
	Endif
	If This.codt > 0 Then
	   \ And c.codt=<<This.codt>>
	Endif
    \ Order By c.fech Desc
	Set Textmerge To
	Set Textmerge Off
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function haycompra(objcompra)
	Ccursor = 'c_' + Sys(2015)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	 \  Select idauto  As Sw From fe_rcom Where Ndoc='<<objcompra.cdcto>>' And Tdoc='<<objcompra.ctdoc>>' And idprov=<<objcompra.idp>>  And Acti<>'I'
	If This.Nreg > 0 Then
	   \ And idauto<><<This.Nreg>>
	Endif
	 \ Group By idauto limit 1
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If Sw > 0 Then
		This.Cmensaje = "Ya Existe un Documento Registrado con este Número"
		Return 0
	Endif
	Return 1
	Endfunc
	Function Verificaestadodeuda()
	Ccursor1 = 'c_' + Sys(2015)
	lC = "FunVerificaEstadoDeuda"
	TEXT To lp Noshow
	  (<<this.nreg>>)
	ENDTEXT
	m.nid = This.EJECUTARf(lC, lp, Ccursor1)
	If Vartype(m.nid) = 'C' Then
		If Val(m.nid) > 0 Then
			This.Cmensaje = 'Este Documento esta Registrado al Crédito y Tiene Pagos a Cuenta '
			Return 0
		Endif
	Else
		If m.nid > 0 Then
			This.Cmensaje = 'Este Documento esta Registrado al Crédito y Tiene Pagos a Cuenta '
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function buscarxidpsysr(Ccursor)
	TEXT To lC Noshow Textmerge
	  SELECT  `a`.`idauto`    AS `idauto`,  `a`.`alma`      AS `alma`,  `a`.`idkar`     AS `idkar`,  `b`.`descri`    AS `descri`,
	  `b`.`peso`      AS `peso`,  `b`.`prod_idco` AS `prod_idco`,  `b`.`unid`      AS `unid`,  `b`.`tipro`     AS `tipro`,
	  `a`.`idart`     AS `idart`,  `a`.`incl`      AS `incl`,  `c`.`ndoc`      AS `ndoc`,  `c`.`valor`     AS `valor`,
	  `c`.`igv`       AS `igv`,  `c`.`impo`      AS `impo`,  `c`.`pimpo`     AS `pimpo`,  `a`.`cant`      AS `cant`,
	  `a`.`prec`      AS `prec`,  `c`.`fech`      AS `fech`,  `a`.`kar_codi`  AS `kar_codi`,  IFNULL(`q`.`codi_desc`,'') AS `codi_desc`,
	  `c`.`fecr`      AS `fecr`,  `c`.`form`      AS `form`,  `c`.`exon`      AS `exon`,  `c`.`ndo2`      AS `ndo2`,
	  `c`.`vigv`      AS `vigv`,  `c`.`idprov`    AS `idprov`,  `a`.`tipo`      AS `tipo`,  `c`.`tdoc`      AS `tdoc`,
	  `c`.`dolar`     AS `dolar`,  `c`.`mone`      AS `mone`,  `p`.`razo`      AS `razo`,  `p`.`dire`      AS `dire`,
	  `p`.`ciud`      AS `ciud`,  `p`.`nruc`      AS `nruc`,  CAST(0 AS UNSIGNED) AS `Idcaja`,  `c`.`codt`      AS `codt`,
	  `a`.`dsnc`      AS `dsnc`,  `a`.`dsnd`      AS `dsnd`,  `a`.`gast`      AS `gast`,  `c`.`fusua`     AS `fusua`,  `w`.`nomb`      AS `Usuario`,  rcom_exon
	  FROM `fe_rcom` `c`
	  LEFT JOIN `fe_kar` `a`     ON `c`.`idauto` = `a`.`idauto`
	  LEFT JOIN `fe_art` `b`      ON `b`.`idart` = `a`.`idart`
	  JOIN `fe_prov` `p`      ON `p`.`idprov` = `c`.`idprov`
	  LEFT JOIN `fe_cingreso` `q`      ON `q`.`codi_idco` = `a`.`kar_codi`
	  JOIN `fe_usua` `w`    ON `w`.`idusua` = `c`.`idusua`
	  WHERE `c`.`acti` <> 'I'    AND `a`.`acti` <> 'I'  and c.idauto=<<this.nreg>> order by idkar
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarxidpsysw(Ccursor)
	TEXT To lC Noshow Textmerge
	  SELECT   a.idauto ,a.alma, a.idkar,  b.descri,  b.peso,
      b.prod_idco,  b.unid,  b.tipro,  a.idart, a.incl,  c.ndoc,  c.valor, c.igv,  c.impo,
      c.pimpo,  a.cant,  a.prec,  c.fech,  c.fecr,  c.form,c.exon ,  c.ndo2,  c.vigv,  c.idprov , a.tipo,  c.tdoc,  c.dolar,  c.mone,
      p.razo ,  p.dire,  p.ciud,  p.nruc,  CAST(0 AS UNSIGNED) AS Idcaja, c.codt,  a.dsnc ,  a.dsnd ,  a.gast,  c.fusua, w.nomb AS Usuario
      FROM   fe_rcom c
      LEFT JOIN fe_kar a   ON   c.idauto = a.idauto
      LEFT JOIN fe_art b   ON   b.idart = a.idart
      JOIN fe_prov p       ON   p.idprov = c.idprov
      JOIN fe_usua w  ON   w.idusua = c.idusua
      WHERE  c.idauto=<<this.nreg>>   AND  a.acti <> 'I'
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function validacomprasM()
	objcompra = Createobject("empty")
	AddProperty(objcompra, 'cdcto', This.cndoc)
	AddProperty(objcompra, 'ctdoc', This.cTdoc)
	AddProperty(objcompra, 'idp', This.nidprov)
	Select (This.ctemporal)
	enc=1
	Go Top 
	Scan All
		If Empty(Coda) Or Coda<1 Then
			This.cmensaje='El Item '+Alltrim(Desc) +' No Esta Enlazado a la Lista de Productos'
			enc=0
			Exit
		Endif
	Endscan
	If enc=0 Then
		Return .F.
	Endif
    Do Case
	Case REgdvto(This.ctemporal) = 0
		This.Cmensaje = "Ingrese Items "
		Return .F.
	Case Len(Alltrim(Left(This.cndoc, 4))) < 4 Or Len(Alltrim(Substr(This.cndoc, 5))) < 8
		This.Cmensaje = "Ingrese Serie y Número de Documento Válido"
		Return .F.
	Case This.cencontrado = "V"
		This.Cmensaje = "NO es Posible Actualizar este Documento"
		Return .F.
	Case Month(This.dfechar) <> goApp.mes Or Year(This.dfechar) <> Val(goApp.Año) Or !esfechaValida(This.dFecha) Or !esfechaValida(This.dfechar)
		This.Cmensaje = "Fecha No Permitida Por el Sistema"
		Return .F.
	Case This.nidprov < 1
		This.Cmensaje = "Ingrese Proveedor"
		Return .F.
	Case Empty(This.codt)
		This.Cmensaje = "Seleccione Un Almacen de Ingreso"
		Return .F.
	Case This.haycompra(objcompra) = 0
		This.Cmensaje = "NÚMERO de Documento de Compra Ya Registrado"
		Return .F.
	Case  PermiteIngresox(This.dfechar) = 0
		This.Cmensaje = "No Es posible Registrar en esta Fecha estan bloqueados Los Ingresos"
		Return .F.
	Otherwise
		Return .T.
	Endcase
	Endfunc
	Function listardetallecompra(niDAUTO, Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lC Noshow Textmerge
	 SELECT   `a`.`idauto`, `a`.`alma`, `a`.`idkar`     AS `idkar`,
	 `a`.`idart`,`a`.`incl`,  `c`.`ndoc` ,  `c`.`valor`     AS `valor`,
	 `c`.`igv` ,  `c`.`impo` ,  `c`.`pimpo`     AS `pimpo`,
	 `a`.`cant`,if(mone='S',`a`.`prec` *c.vigv,a.prec*c.vigv*dolar) as prec ,  `c`.`fech`, rcom_exon,
	 `c`.`vigv`,  `c`.`idprov`    AS `idprov`,
	 `a`.`tipo`, `c`.`tdoc` ,  c.`dolar`,b.descri,b.unid,
	 `c`.`mone`, `c`.`codt`   FROM `fe_rcom` `c`
	 INNER  JOIN `fe_kar` `a`  ON `c`.`idauto` = `a`.`idauto`
	 inner join fe_art as b on b.idart=a.idart
	 WHERE `c`.`acti` <> 'I'     AND `a`.`acti` <> 'I' and c.idauto=<<nidauto>> order by idart
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarlogscompras(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lC Noshow Textmerge
	SELECT ac.comp_ndoc as Compra,s.nomb AS Sucursal,u.nomb AS Usuario,fech as Fecha,comp_fech as Operacion	FROM fe_acompras ac
	INNER JOIN fe_sucu s ON ac.comp_codt=s.idalma
	INNER JOIN fe_usua u ON ac.comp_idus=u.idusua
	inner join fe_rcom r on ac.comp_ndoc=r.ndoc	where acti='A'
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarctascompras(nid, Ccursor)
	TEXT To lC Noshow  Textmerge
	    select p.idcta,p.ncta,idectas,nitem FROM fe_ectasc as e
	    inner join fe_plan as p on p.idcta=e.idcta
	    where idrcon=<<nid>> and ecta_acti='A'
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaGuiasXcanjear(Ccursor)
	f1=Cfechas(This.fechai)
	f2=Cfechas(This.fechaf)
	If This.Idsesion>0 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
    select ndoc,fech,razo,impo,descri,unid,cant,r.idauto FROM
    (select guic_idau from fe_guiac where guic_acti='A' and guic_tipo<>'E' group by guic_idau) as g
    inner join fe_rcom AS r on r.idauto=g.guic_idau
	INNER JOIN fe_prov AS p ON p.idprov=r.idprov
	INNER JOIN fe_kar AS k ON k.idauto=g.guic_idau
	INNER JOIN fe_art AS a ON a.idart=k.idart  WHERE tdoc="09" and fech between '<<f1>>' and '<<f2>>' order by fech
	ENDTEXT
	If This.EJECutaconsulta(lC,Ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine










































































