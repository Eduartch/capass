Define Class OrdendeCompra As OData Of 'd:\capass\database\data.prg'
	CodProducto = 0
	CodProductoR = ""
	Codproveedor = 0
	Nprecio = 0
	Ncantidad = 0
	ndscto = 0
	nstock = 0
	ncodt = 0
	Cestado = ""
	AutoC = 0
	Accion = ""
	Idr = 0
	dFecha = Date()
	cmone = ""
	cndoc = ""
	ctigv = ""
	cobse = ""
	caten = ""
	cdeta = ""
	cdesp = ""
	cforma = ""
	Nv = 0
	nigv = 0
	nimpo = 0
	Idserie = 0
	Nsgte = 0
	Empresa = ""
	Cestado = ""
	Tdoc = ""
	dfi = Date()
	dff = Date()
	Agencia1=""
	Agencia2=""
	Agencia3=""
	Agencia4=""
	Agencia5=""
	Agencia6=""
	Function Registraocompra
	If !Pemstatus(goapp,'OrdendeCompra',5) Then
		AddProperty(goapp,'OrdendeCompra','')
	Endif
	If !Pemstatus(goapp,'proyecto',5) Then
		AddProperty(goapp,'proyecto','')
	Endif
	lC = 'FUNINGRESAORDENCOMPRA'
	cur = "oc"
	goapp.npara1 = This.dFecha
	goapp.npara2 = This.Codproveedor
	goapp.npara3 = This.cmone
	goapp.npara4 = This.cndoc
	goapp.npara5 = This.ctigv
	goapp.npara6 = This.cobse
	goapp.npara7 = This.caten
	goapp.npara8 = This.cdeta
	goapp.npara9 = Id()
	goapp.npara10 = goapp.nidusua
	goapp.npara11 = This.cdesp
	goapp.npara12 = This.cforma
	goapp.npara13 = This.Nv
	goapp.npara14 = This.nigv
	goapp.npara15 = This.nimpo
	If goapp.OrdendeCompra <>'N' And goapp.proyecto='psysl' Then
		goapp.npara16=This.Agencia1
		goapp.npara17=This.Agencia2
		goapp.Npara18=This.Agencia3
		goapp.Npara19=This.Agencia4
		goapp.Npara20=This.Agencia5
		goapp.npara21=This.Agencia6
		TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,
	     ?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21)
		ENDTEXT
	Else
		TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
		ENDTEXT
	Endif
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function IngresaDetalleOrdendeCompra
	If !Pemstatus(goapp, 'proyecto', 5) Then
		AddProperty(goapp, 'proyecto', '')
	Endif
	lC = 'PROINGRESADETALLEOCOMPRA'
	cur = ""
	goapp.npara1 = This.AutoC
	If goapp.proyecto = 'psysrx' Then
		goapp.npara2 = This.CodProductoR
	Else
		goapp.npara2 = This.CodProducto
	Endif
	goapp.npara3 = This.Ncantidad
	goapp.npara4 = This.Nprecio
	goapp.npara5 = This.Cestado
	goapp.npara6 = This.ndscto
	Do Case
	Case This.Empresa = 'Norplast'
		TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
		ENDTEXT
	Case This.Empresa = 'lopezycia'
		If goapp.OrdendeCompra = 'N' Then
			TEXT To lp Noshow
	         (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
			ENDTEXT
		Else
			TEXT To lp Noshow Textmerge
	        (<<this.AutoC>>,<<this.CodProducto>>,<<this.Ncantidad>>,<<this.Nprecio>>,<<otmpp.uno>>,<<otmpp.Dos>>,<<otmpp.tre>>,<<otmpp.cua>>,<<otmpp.cin>>,<<otmpp.sei>>,<<this.ndscto>>)
			ENDTEXT
		Endif
	Otherwise
		TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
		ENDTEXT
	Endcase
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Actualizaocompra()
	If !Pemstatus(goapp,'OrdendeCompra',5) Then
		AddProperty(goapp,'OrdendeCompra','')
	Endif
	If !Pemstatus(goapp,'proyecto',5) Then
		AddProperty(goapp,'proyecto','')
	Endif
	lC = 'PROACTUALIZAORDENCOMPRA'
	goapp.npara1 = This.dFecha
	goapp.npara2 = This.Codproveedor
	goapp.npara3 = This.cmone
	goapp.npara4 = This.cndoc
	goapp.npara5 = This.ctigv
	goapp.npara6 = This.cobse
	goapp.npara7 = This.caten
	goapp.npara8 = This.cdeta
	goapp.npara9 = goapp.nidusua
	goapp.npara10 = This.Idr
	goapp.npara11 = This.cdesp
	goapp.npara12 = This.cforma
	goapp.npara13 = This.Nv
	goapp.npara14 = This.nigv
	goapp.npara15 = This.nimpo
	If goapp.OrdendeCompra <>'N' And goapp.proyecto='psysl' Then
		goapp.npara16=This.Agencia1
		goapp.npara17=This.Agencia2
		goapp.Npara18=This.Agencia3
		goapp.Npara19=This.Agencia4
		goapp.Npara20=This.Agencia5
		goapp.npara21=This.Agencia6
		TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,
	     ?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21)
		ENDTEXT
	Else
		TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
		ENDTEXT
	Endif
	If  This.EJECUTARP(lC, lp, '') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function DesactivaPedidoOrdendeCompra
	lC = 'PROActualizaOCOMPRAXD'
	cur = ""
	goapp.npara1 = This.AutoC
	goapp.npara2 = This.CodProducto
	TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(lC, lp, cur) = 0 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function  ActualizaDetalleOrdendeCompra()
	lC = 'PROACTUALIZAOCOMPRA'
	If !Pemstatus(goapp, 'proyecto', 5) Then
		AddProperty(goapp, 'proyecto', '')
	Endif
	goapp.npara1 = This.Idr
	goapp.npara2 = This.Accion
	If goapp.proyecto = 'psysrx' Then
		goapp.npara3 = This.CodProductoR
	Else
		goapp.npara3 = This.CodProducto
	Endif
	goapp.npara4 = This.Ncantidad
	goapp.npara5 = This.Nprecio
	goapp.npara6 = This.ndscto
	Do Case
	Case This.Empresa = 'Norplast'
		TEXT To lp Noshow
			    (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
		ENDTEXT
	Case This.Empresa = 'lopezycia'
		If goapp.OrdendeCompra = 'N' Then
			TEXT To lp Noshow
			     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
			ENDTEXT
		Else
			TEXT To lp Noshow Textmerge
	     (<<this.idr>>,'<<this.accion>>',<<this.CodProducto>>,<<this.Ncantidad>>,<<this.Nprecio>>,<<otmpp.uno>>,<<otmpp.dos>>,<<otmpp.tre>>,<<otmpp.cua>>,<<otmpp.cin>>,<<otmpp.sei>>,<<this.ndscto>>)
			ENDTEXT
		Endif
	Otherwise
		TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
		ENDTEXT
	Endcase
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Procedure PendientesPorRecibir
	Lparameters nidoc, Ccursor
	TEXT To lC Noshow Textmerge
	    select idart as coda,descri,unid,sum(pedido) as pedido,sum(recibido) as recibido,sum(pedido)-sum(recibido) as saldo,ocom_fech as fecha,
		p.razo,ocom_ndoc as NumeroOC,ocom_idroc,prec,prod_cod1 from(
		SELECT idart,descri,unid,prod_cod1,case doco_tipo when 'I' then doco_cant else 0 end as Pedido,
		case doco_tipo when 'S' then doco_cant else 0 end as Recibido,doco_idro,doco_prec as prec
		FROM fe_docom f
		inner join fe_art g on g.idart=f.doco_coda where doco_acti='A' and doco_tipo in ("I","S") and doco_idro=<<nidoc>>) as q
		inner join fe_rocom r on r.ocom_idroc=q.doco_idro
		inner join fe_prov p on p.idprov=r.ocom_idpr group by idart,descri,unid,prod_cod1,ocom_fech,razo,ocom_ndoc,ocomo_idroc having saldo>0
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endproc
	Procedure PendientesPorRecibir1
	Lparameters Ccursor
	TEXT To lC Noshow Textmerge
	    select idart as codigo,descri,unid,sum(pedido) as pedido,sum(recibido) as recibido,sum(pedido)-sum(recibido) as saldo,ocom_fech as fecha,
		p.razo,ocom_ndoc as NumeroOC,prec,ocom_idroc from(
		SELECT idart,descri,unid,case doco_tipo when 'I' then doco_cant else 0 end as Pedido,
		case doco_tipo when 'S' then doco_cant else 0 end as Recibido,doco_idro,doco_prec as prec
		FROM fe_docom f
		inner join fe_art g on g.idart=f.doco_coda where doco_acti='A' and doco_tipo in ("I","S")) as q
		inner join fe_rocom r on r.ocom_idroc=q.doco_idro
		inner join fe_prov p on p.idprov=r.ocom_idpr group by idart having saldo>0
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endproc
	Procedure ProductoPedido
	Lparameters nidart, Ccursor
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lC Noshow Textmerge
	    select idart as codigo,descri as Producto,unid,sum(pedido) as pedido,sum(recibido) as recibido,sum(pedido)-sum(recibido) as saldo,ocom_fech as fecha,
		p.razo,ocom_ndoc as NumeroOC,ocom_mone as MOneda,prec as Precio,ocom_idroc from(
		SELECT idart,descri,unid,case doco_tipo when 'I' then doco_cant else 0 end as Pedido,
		case doco_tipo when 'S' then doco_cant else 0 end as Recibido,doco_idro,doco_prec as prec
		FROM fe_docom f
		inner join fe_art g on g.idart=f.doco_coda where doco_acti='A' and doco_tipo in ("I","S") and doco_coda=<<nidart>>) as q
		inner join fe_rocom r on r.ocom_idroc=q.doco_idro
		inner join fe_prov p on p.idprov=r.ocom_idpr group by idart,descri,unid,ocom_fech,ocom_ndoc,ocom_mone,ocom_idroc,prec having saldo>0
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endproc
	Procedure GeneraVoc
	Lparameters Cserie, cnumero
	Create Cursor votmp(Coda N(8), Descri c(100), Unid c(4), cant N(10, 3), Prec N(13, 3), d1 N(7, 4), Nreg N(8), Ndoc c(10))
	cn = Val(cnumero)
	Select loc1
	Go Top
	x = 1
	F = loc1.idprov
	cdcto = Cserie + cnumero
	Do While !Eof()
		If F <> loc1.idprov Then
			F = loc1.idprov
			x = x + 1
			cn = cn + 1
			cdcto = Cserie + Right("00000000" + Alltrim(Str(cn)), 8)
		Endif
		If loc1.tmon = 'S' Then
			nprec = loc1.costosf
		Else
			nprec = loc1.costosf / fe_gene.dola
		Endif
		Insert Into votmp(Coda, Descri, Unid, Ndoc, Prec, cant)Values(loc1.idart, ;
			loc1.Descri, loc1.Unid, cdcto, nprec / fe_gene.igv, loc1.cant)
		Skip
	Enddo
	Endproc
	Function Grabar()
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	This.AutoC = This.Registraocompra()
	If This.AutoC < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.grabardetalleocompra() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GeneraCorrelativo(This.Nsgte, This.Idserie) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	This.CONTRANSACCION = ""
	This.cmensaje = 'ok'
	Return 1
	Endfunc
	Function Actualizar()
	This.CONTRANSACCION = 'S'
	If This.IniciaTransaccion() < 1 Then
		Return 1
	Endif
	If This.Actualizaocompra() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	This.AutoC = This.Idr
	If This.grabardetalleocompra() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	This.CONTRANSACCION = ""
	This.cmensaje = 'ok'
	Return 1
	Endfunc
	Function grabardetalleocompra()
	If !Pemstatus(goapp, 'proyecto', 5) Then
		AddProperty(goapp, 'proyecto', '')
	Endif
	Sw = 1
	Select otmpp
	Set Deleted Off
	Go Top
	Do While !Eof()
		If Empty(otmpp.Coda)
			Select otmpp
			Skip
			Loop
		Endif
		If goapp.proyecto = 'psysrx' Then
			This.CodProductoR = otmpp.Coda
		Else
			This.CodProducto = otmpp.Coda
		Endif
		This.Ncantidad = otmpp.cant
		This.Nprecio = otmpp.Prec
		This.ndscto = otmpp.d1
		If Deleted()
			If otmpp.Nreg > 0
				This.Idr = otmpp.Nreg
				This.Accion = 'E'
				If This.ActualizaDetalleOrdendeCompra() < 1 Then
					Sw = 0
					Exit
				Endif
			Endif
			Select  otmpp
			Skip
			Loop
		Endif
		If otmpp.Nreg = 0
			If This.IngresaDetalleOrdendeCompra() < 1 Then
				Sw = 0
				Exit
			Endif
		Else
			This.Idr = otmpp.Nreg
			This.Accion = 'M'
			If This.ActualizaDetalleOrdendeCompra() < 1 Then
				Sw = 0
				Exit
			Endif
		Endif
		Select otmpp
		Skip
	Enddo
	Set Deleted On
	Return Sw
	Endfunc
	Function GeneraCorrelativo(np1, np2)
	Set Procedure To d:\capass\modelos\correlativos Additive
	ocorr = Createobject("correlativo")
	ocorr.Idserie = This.Idserie
	ocorr.Nsgte = This.Nsgte
	If ocorr.GeneraCorrelativo1() < 1 Then
		This.cmensaje = ocorr.cmensaje
		Return 0
	Endif
	Return 1
	Endfunc
	Function CreaTemporal(Calias)
	If !Pemstatus(goapp, 'proyecto', 5) Then
		AddProperty(goapp, 'proyecto', '')
	Endif
	If This.Idsesion > 0
		Set DataSession To This.Idsesion
	Endif
	If goapp.proyecto = 'psysrx' Or goapp.proyecto = 'psysr' Then
		Create Cursor (Calias)(Coda c(15), Descri c(150), Unid c(4), cant N(10, 3), Prec N(14, 6), d1 N(7, 4), Nreg N(8), Ndoc c(10), Nitem N(5), uno N(10, 2), Dos N(10, 2), ;
			Incluido c(1), Razo c(120), aten c(120), Moneda c(20), facturar c(200), despacho c(200), Forma c(100), observa c(200), fech d, rotacion N(12, 2) Default 0, ;
			tipro c(1), come N(8, 2), Comc N(8, 2), tre N(10, 2), cua N(10, 2), cin N(10, 2), sei N(10, 2), Impo N(12, 2), Valida c(1), Codigo c(20), totalstock N(12, 2), ;
			despacharpor c(100), ructr c(11), direcciont c(100), contactot c(100), telefonot c(20), valor N(12, 2), igv N(12, 2), Total N(12, 2), Usuario c(100), Peso N(10, 2), ;
			rucproveedor c(11), idautooc N(8), observaitem c(50))
	Else
		Create Cursor (Calias)(Coda N(8), Descri c(150), Unid c(4), cant N(10, 3), Prec N(14, 6), d1 N(7, 4), Nreg N(8), Ndoc c(10), Nitem N(5), uno N(10, 2), Dos N(10, 2), ;
			Incluido c(1), Razo c(120), aten c(120), Moneda c(20), facturar c(200), despacho c(200), Forma c(100), observa c(200), fech d, rotacion N(12, 2) Default 0, ;
			tipro c(1), come N(8, 2), Comc N(8, 2), tre N(10, 2), cua N(10, 2), cin N(10, 2), sei N(10, 2), Impo N(12, 2), Valida c(1), Codigo c(20), totalstock N(12, 2), ;
			despacharpor c(100), ructr c(11), direcciont c(100), contactot c(100), telefonot c(20), valor N(12, 2), igv N(12, 2), Total N(12, 2), Usuario c(100), Peso N(10, 2), ;
			rucproveedor c(11), idautooc N(8), observaitem c(50))
	Endif
	Select (Calias)
	Index On Descri Tag Descri
	Index On Nitem Tag Items
	Endfunc
	Function listardetalle(nid, Ccursor)
	Set DataSession To This.Idsesion
	TEXT To lC Noshow Textmerge
   	   SELECT   doco_coda,Descri,unid,doco_cant,doco_prec,doco_idro,ocom_mone,
	   ROUND(IF(tmon='S',(a.prec*v.igv)+f.prec,(a.prec*v.igv*IF(prod_dola>v.dola,prod_dola,v.dola))+f.prec),2) AS costo,
	   ROUND(IF(tmon='S',(a.prec*v.igv),(f.prec*v.igv*v.dola)),2) AS costosf,f.prec AS flete,prod_cod1
	   FROM fe_rocom AS r
	   INNER JOIN fe_docom AS d ON d.doco_idro=r.ocom_idroc
	   INNER JOIN fe_art AS a ON a.idart=d.doco_coda
	   INNER JOIN fe_fletes AS f ON f.`idflete`=a.`idflete`, fe_gene AS v
	   WHERE doco_idro=<<nid>> AND doco_acti='A' AND r.ocom_acti='A'
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarocompralopez(cndoc, Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	 \ Select `b`.`doco_iddo`  As `doco_iddo`,	  `b`.`doco_coda`  As `doco_coda`,
	 \ `b`.`doco_cant`  As `doco_cant`,	  `b`.`doco_prec`  As `doco_prec`,
	 \ `c`.`Descri`     As `Descri`,	  `c`.`prod_smin`  As `prod_smin`,
	 \ `c`.`Unid`       As `Unid`,c.prod_cod1,	  `c`.`prod_smax`  As `prod_smax`,
	 \ `a`.`ocom_valor` As `ocom_valor`,	  `a`.`ocom_igv`   As `ocom_igv`,	  `a`.`ocom_impo`  As `ocom_impo`,	  `a`.`ocom_idroc` As `ocom_idroc`,
	 \ `a`.`ocom_fech`  As `ocom_fech`,	  `a`.`ocom_idpr`  As `ocom_idpr`,	  `a`.`ocom_desp`  As `ocom_desp`,	  `a`.`ocom_form`  As `ocom_form`,
	 \ `a`.`ocom_mone`  As `ocom_mone`,	  `a`.`ocom_ndoc`  As `ocom_ndoc`,	  `a`.`ocom_tigv`  As `ocom_tigv`,
	 \ `a`.`ocom_obse`  As `ocom_obse`,	  `a`.`ocom_aten`  As `ocom_aten`,	  `a`.`ocom_deta`  As `ocom_deta`,
	 \ `a`.`ocom_idus`  As `ocom_idus`,	  `a`.`ocom_fope`  As `ocom_fope`,	  `a`.`ocom_idpc`  As `ocom_idpc`,	  `a`.`ocom_idac`  As `ocom_idac`,
	 \ `a`.`ocom_fact`  As `ocom_fact`,	  `d`.`Razo`       As `Razo`,	  `e`.`nomb`       As `nomb`,c.Peso
	If goapp.OrdendeCompra <> 'N' Then
	    \ ,`b`.`doco_uno` , `b`.`doco_dos` ,`b`.`doco_tre`,`b`.`doco_cua` , `b`.`doco_cin`,`b`.`doco_sei`,b.doco_dsct,ocom_age1,ocom_age2,ocom_age3,ocom_age4,ocom_age5,ocom_age6
	Endif
	 \ From `fe_rocom` `a`
	 \Join `fe_docom` `b`  On `b`.`doco_idro` = `a`.`ocom_idroc`
	 \Join `fe_art` `c`    On `b`.`doco_coda` = `c`.`idart`
	 \Join `fe_prov` `d`   On `d`.`idprov` = `a`.`ocom_idpr`
	 \Join `fe_usua` `e`   On `e`.`idusua` = `a`.`ocom_idus`
	 \Where `a`.`ocom_acti` <> 'I'   And `b`.`doco_acti` <> 'I' And a.ocom_ndoc='<<cndoc>>'
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarocompra(cndoc, Ccursor)
	If  Type('oempresa') = 'U' Then
		Cnruc = fe_gene.nruc
	Else
		Cnruc = Oempresa.nruc
	Endif
	If !Pemstatus(goapp, 'proyecto', 5) Then
		AddProperty(goapp, 'proyecto', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\  Select `b`.`doco_iddo`, `b`.`doco_coda` , `b`.`doco_cant`,	  `b`.`doco_prec`,
	\  `c`.`Descri` ,	  `c`.`prod_smin`, `c`.`Unid`, `c`.`prod_smax`  As `prod_smax`,	  `a`.`ocom_valor`,
	\  `a`.`ocom_igv`,	  `a`.`ocom_impo`  As `ocom_impo`,	  `a`.`ocom_idroc` As `ocom_idroc`,	  `a`.`ocom_fech`,
	\  `a`.`ocom_idpr`,	  `a`.`ocom_desp` ,	  `a`.`ocom_form`  As `ocom_form`,	  `a`.`ocom_mone`,
	\  `a`.`ocom_ndoc`,	  `a`.`ocom_tigv` ,	  `a`.`ocom_obse`  As `ocom_obse`,	  `a`.`ocom_aten`,
	\  `a`.`ocom_deta`,	  `a`.`ocom_idus`,	  `a`.`ocom_fope`  As `ocom_fope`,	  `a`.`ocom_idpc`,
	\  `a`.`ocom_idac`,	  `a`.`ocom_fact`,	  `d`.`Razo`,	  `e`.`nomb`
	If goapp.proyecto == 'psysr' Or goapp.proyecto == 'psysrx' Then
	Else
	 \ ,c.prod_cod1
	Endif
	If m.Cnruc = '20601140625' Then
	  \,c.uno+c.Dos+c.tre+c.die+c.onc As totalstock,b.doco_deta
	Else
	 \,c.uno+c.Dos+c.tre+c.cua As totalstock
	Endif
	\ From `fe_rocom` `a`
    \ Join `fe_docom` `b`    On `b`.`doco_idro` = `a`.`ocom_idroc`
    \ Join `fe_art` `c`       On `b`.`doco_coda` = `c`.`idart`
    \ Join `fe_prov` `d`       On `d`.`idprov` = `a`.`ocom_idpr`
    \ Join `fe_usua` `e`     On `e`.`idusua` = `a`.`ocom_idus`
    \ Where `a`.`ocom_acti` <> 'I'   And `b`.`doco_acti` <> 'I' And a.ocom_ndoc='<<cndoc>>'
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarocompranorplast(cndoc, Ccursor)
	TEXT To lC Noshow Textmerge
	  SELECT
	  `b`.`doco_iddo`  AS `doco_iddo`,	  `b`.`doco_coda`  AS `doco_coda`,	  `b`.`doco_cant`  AS `doco_cant`,	  `b`.`doco_prec`  AS `doco_prec`,
	  `c`.`descri`     AS `descri`,	  `c`.`prod_smin`  AS `prod_smin`,doco_dsct,
	  `c`.`unid`       AS `unid`,c.prod_cod1,	  `c`.`prod_smax`  AS `prod_smax`,	  `a`.`ocom_valor` AS `ocom_valor`,
	  `a`.`ocom_igv`   AS `ocom_igv`,	  `a`.`ocom_impo`  AS `ocom_impo`,	  `a`.`ocom_idroc` AS `ocom_idroc`,	  `a`.`ocom_fech`  AS `ocom_fech`,
	  `a`.`ocom_idpr`  AS `ocom_idpr`,	  `a`.`ocom_desp`  AS `ocom_desp`,	  `a`.`ocom_form`  AS `ocom_form`,	  `a`.`ocom_mone`  AS `ocom_mone`,
	  `a`.`ocom_ndoc`  AS `ocom_ndoc`,	  `a`.`ocom_tigv`  AS `ocom_tigv`,	  `a`.`ocom_obse`  AS `ocom_obse`,	  `a`.`ocom_aten`  AS `ocom_aten`,
	  `a`.`ocom_deta`  AS `ocom_deta`,	  `a`.`ocom_idus`  AS `ocom_idus`,	  `a`.`ocom_fope`  AS `ocom_fope`,	  `a`.`ocom_idpc`  AS `ocom_idpc`,
	  `a`.`ocom_idac`  AS `ocom_idac`,	  `a`.`ocom_fact`  AS `ocom_fact`,	  `d`.`razo`       AS `razo`,	  `e`.`nomb`       AS `nomb`,doco_tipo,
	  c.uno,c.dos,c.tre,c.cua
	 FROM `fe_rocom` `a`
     JOIN `fe_docom` `b`    ON `b`.`doco_idro` = `a`.`ocom_idroc`
     JOIN `fe_art` `c`       ON `b`.`doco_coda` = `c`.`idart`
     JOIN `fe_prov` `d`       ON `d`.`idprov` = `a`.`ocom_idpr`
     JOIN `fe_usua` `e`     ON `e`.`idusua` = `a`.`ocom_idus`
     WHERE `a`.`ocom_acti` <> 'I'   AND `b`.`doco_acti` <> 'I' and a.ocom_ndoc='<<cndoc>>'
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarocompraneumaticos(cndoc, Ccursor)
	TEXT To lC Noshow Textmerge
	  SELECT
	  `b`.`doco_iddo`  AS `doco_iddo`,	  `b`.`doco_coda` ,	  `b`.`doco_cant` ,	  `b`.`doco_prec` ,
	  `c`.`descri` ,	  `c`.`prod_smin`, `c`.`unid`,c.prod_ccai as prod_cod1,	  `c`.`prod_smax`  AS `prod_smax`,	  `a`.`ocom_valor` AS `ocom_valor`,
	  `a`.`ocom_igv`   AS `ocom_igv`,	  `a`.`ocom_impo`  AS `ocom_impo`,	  `a`.`ocom_idroc` AS `ocom_idroc`,	  `a`.`ocom_fech` ,
	  `a`.`ocom_idpr`  AS `ocom_idpr`,	  `a`.`ocom_desp`  AS `ocom_desp`,	  `a`.`ocom_form`  AS `ocom_form`,	  `a`.`ocom_mone` ,
	  `a`.`ocom_ndoc`  AS `ocom_ndoc`,	  `a`.`ocom_tigv`  AS `ocom_tigv`,	  `a`.`ocom_obse`  AS `ocom_obse`,	  `a`.`ocom_aten`  ,
	  `a`.`ocom_deta`  AS `ocom_deta`,	  `a`.`ocom_idus`  AS `ocom_idus`,	  `a`.`ocom_fope`  AS `ocom_fope`,	  `a`.`ocom_idpc`,
	  `a`.`ocom_idac`  AS `ocom_idac`,	  `a`.`ocom_fact`  AS `ocom_fact`,	  `d`.`razo`  ,	  `e`.`nomb`,d.nruc as rucproveedor,d.email
	 FROM `fe_rocom` `a`
     JOIN `fe_docom` `b`    ON `b`.`doco_idro` = `a`.`ocom_idroc`
     JOIN `fe_art` `c`       ON `b`.`doco_coda` = `c`.`idart`
     JOIN `fe_prov` `d`       ON `d`.`idprov` = `a`.`ocom_idpr`
     JOIN `fe_usua` `e`     ON `e`.`idusua` = `a`.`ocom_idus`
     WHERE `a`.`ocom_acti` <> 'I'   AND `b`.`doco_acti` <> 'I' and a.ocom_ndoc='<<cndoc>>'
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function verificarpdtes(nid, Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lC Noshow  Textmerge
	    SELECT ocom_idroc AS idauto FROM (
		SELECT idart,SUM(pedido) AS pedido,SUM(recibido) AS recibido,SUM(pedido)-SUM(recibido) AS saldo,
		ocom_idroc FROM(
		SELECT idart,CASE doco_tipo WHEN 'I' THEN doco_cant ELSE 0 END AS Pedido,
		CASE doco_tipo WHEN 'S' THEN doco_cant ELSE 0 END AS Recibido,doco_idro
		FROM fe_docom f
		INNER JOIN fe_art g ON g.idart=f.doco_coda WHERE doco_acti='A' AND doco_tipo IN ("I","S")) AS q
		INNER JOIN fe_rocom r ON r.ocom_idroc=q.doco_idro
		INNER JOIN fe_prov p ON p.idprov=r.ocom_idpr
		WHERE r.ocom_idpr=<<nid>> GROUP BY idart,ocom_idroc) AS x WHERE saldo>0 GROUP BY ocom_idroc;
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function VAlidar()
	Ccursor = 'c_' + Sys(2015)
	TEXT To lC Noshow Textmerge
    SELECT ocom_idroc  as idauto FROM fe_rocom WHERE ocom_ndoc='<<this.cndoc>>' AND ocom_acti='A'  LIMIT 1
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If Idauto > 0 Then
		This.cmensaje = "Número de Orden de Compra Ya Registrado"
		Return 0
	Endif
	Return 1
	Endfunc
	Function Anular(nid)
	If nid < 1 Then
		This.cmensaje = 'Seleccione una Orden de Compra'
		Return 0
	Endif
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	TEXT To lC Noshow Textmerge
	UPDATE fe_rocom SET ocom_acti='I' WHERE ocom_idroc=<<nid>>
	ENDTEXT
	If This.EJECutaconsulta(lC) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	TEXT To lC Noshow Textmerge
	UPDATE fe_docom SET doco_acti='I' WHERE doco_idro=<<nid>>
	ENDTEXT
	If This.EJECutaconsulta(lC) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarresumen(nmes, Na, Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select  'OC' As Tdoc,ocom_ndoc As Ndoc,ocom_fech,Razo,ocom_mone,ocom_valor,ocom_igv,ocom_impo,ocom_idroc  As Idauto From fe_rocom As r
	\inner Join fe_prov As p On p.idprov=r.`ocom_idpr`
	\Where  ocom_acti='A' And Month(ocom_fech)=<<nmes>> And Year(ocom_fech)=<<Na>>
	If This.Codproveedor > 0 Then
    \ And ocom_idpr=<<This.Codproveedor>>
	Endif
	If Len(Alltrim(This.Cestado)) > 0 Then
	\ And ocom_esta='<<this.cestado>>'
	Endif
	If Len(Alltrim(This.Tdoc)) > 0 Then
	\ And ocom_tdoc='<<this.tdoc>>'
	Endif
    \Order By ocom_fech Desc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarrqcompra(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select ocom_ndoc From fe_rocom As r
	\Where  ocom_acti='A' And ocom_tdoc='RQ' And ocom_esta='P' Order By ocom_fech Desc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarresumenrqcompra(nmes, Na, Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select  ocom_tdoc As Tdoc,ocom_ndoc As Ndoc,ocom_fech,"" As Razo,ocom_mone,ocom_valor,ocom_igv,ocom_impo,ocom_idroc  As Idauto From fe_rocom As r
	\Where  ocom_acti='A' And Month(ocom_fech)=<<nmes>> And Year(ocom_fech)=<<Na>>  And ocom_tdoc='RQ' Order By ocom_fech Desc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function cambiaestado(nid, Cestado)
	Local lC
	TEXT To m.lC Noshow Textmerge
      UPDATE fe_rocom SET ocom_esta='<<cestado>>' WHERE ocom_idroc=<<nid>>
	ENDTEXT
	If This.Ejecutarsql(m.lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarporacepar(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Ccursor = 'c_' + Sys(2015)
	TEXT To lC Noshow Textmerge
	select ocom_idroc  as auto FROM fe_rocom WHERE ocom_acti='A' AND ocom_esta='P'  limit 1
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If Auto > 0 Then
		Return 1
	Endif
	Return 0
	Endfunc
	Function GrabarRQ()
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	This.AutoC = This.RegistraRqCompra()
	If This.AutoC < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.grabardetalleRQcompra() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GeneraCorrelativo(This.Nsgte, This.Idserie) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	This.CONTRANSACCION = ""
	Return 1
	Endfunc
	Function RegistraRqCompra
	lC = 'FunIngresaRQCompra'
	cur = "oc"
	goapp.npara1 = This.dFecha
	goapp.npara2 = This.Codproveedor
	goapp.npara3 = This.cmone
	goapp.npara4 = This.cndoc
	goapp.npara5 = This.ctigv
	goapp.npara6 = This.cobse
	goapp.npara7 = This.caten
	goapp.npara8 = This.cdeta
	goapp.npara9 = Id()
	goapp.npara10 = goapp.nidusua
	goapp.npara11 = This.cdesp
	goapp.npara12 = This.cforma
	goapp.npara13 = This.Nv
	goapp.npara14 = This.nigv
	goapp.npara15 = This.ncodt
	TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function RegistraCotCompra
	lC = 'FunIngresaCotCompra'
	cur = "oc"
	goapp.npara1 = This.dFecha
	goapp.npara2 = This.Codproveedor
	goapp.npara3 = This.cmone
	goapp.npara4 = This.cndoc
	goapp.npara5 = This.ctigv
	goapp.npara6 = This.cobse
	goapp.npara7 = This.caten
	goapp.npara8 = This.cdeta
	goapp.npara9 = Id()
	goapp.npara10 = goapp.nidusua
	goapp.npara11 = ""
	goapp.npara12 = This.cforma
	goapp.npara13 = This.Nv
	goapp.npara14 = This.nigv
	goapp.npara15 = This.ncodt
	TEXT To lp Noshow
	(?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function IngresaDetalleRQComppra
	lC = 'ProIngresaDetalleRQCompra'
	cur = ""
	goapp.npara1 = This.AutoC
	goapp.npara2 = This.CodProducto
	goapp.npara3 = This.Ncantidad
	goapp.npara4 = This.nstock
	TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	ENDTEXT
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function grabardetalleRQcompra()
	Sw = 1
	Select otmpp
	Set Deleted Off
	Go Top
	Do While !Eof()
		If Empty(otmpp.Coda)
			Select otmpp
			Skip
			Loop
		Endif
		This.CodProducto = otmpp.Coda
		This.Ncantidad = otmpp.cant
		This.nstock = otmpp.totalstock
		If Deleted()
			If otmpp.Nreg > 0
				This.Idr = otmpp.Nreg
				This.Accion = 'E'
				If This.ActualizaDetalleRQCompra() < 1 Then
					Sw = 0
					Exit
				Endif
			Endif
			Select  otmpp
			Skip
			Loop
		Endif
		If otmpp.Nreg = 0
			If This.IngresaDetalleRQComppra() < 1 Then
				Sw = 0
				Exit
			Endif
		Else
			This.Idr = otmpp.Nreg
			This.Accion = 'M'
			If This.ActualizaDetalleRQCompra() < 1 Then
				Sw = 0
				Exit
			Endif
		Endif
		Select otmpp
		Skip
	Enddo
	Set Deleted On
	Return Sw
	Endfunc
	Function  ActualizaDetalleRQCompra
	lC = 'ProActualizaRQCompra'
	goapp.npara1 = This.Idr
	goapp.npara2 = This.Accion
	goapp.npara3 = This.CodProducto
	goapp.npara4 = This.Ncantidad
	goapp.npara5 = This.nstock
	TEXT To lp Noshow
	(?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
	ENDTEXT
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function ActualizaDetalleItem(Nreg, cdeta)
	TEXT To lC Noshow
	   UPDATE fe_docom SET doco_deta=?cdeta WHERE doco_iddo=?nreg
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	This.cmensaje = 'ok'
	Return 1
	Endfunc
	Function ActualizarRQ()
	This.CONTRANSACCION = 'S'
	If This.IniciaTransaccion() < 1 Then
		Return 1
	Endif
	If This.Actualizaocompra() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	This.AutoC = This.Idr
	If This.grabardetalleRQcompra() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	This.CONTRANSACCION = ""
	Return 1
	Endfunc
	Function mostrarrqcompra(cndoc, Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\  Select `b`.`doco_iddo`, `b`.`doco_coda` , `b`.`doco_cant`,	  `b`.`doco_prec`, `c`.`Descri` ,	  `c`.`prod_smin`,
	\  `c`.`Unid`,c.prod_cod1,	  `c`.`prod_smax`  As `prod_smax`,	  `a`.`ocom_valor` As `ocom_valor`,
	\  `a`.`ocom_igv`,	  `a`.`ocom_impo` ,	  `a`.`ocom_idroc` ,	  `a`.`ocom_fech`  As `ocom_fech`,
	\  Cast(0 As unsigned) As `ocom_idpr`,	  `a`.`ocom_desp` ,	  `a`.`ocom_form`,	  `a`.`ocom_mone`,
	\  `a`.`ocom_ndoc`,	  `a`.`ocom_tigv` ,	  `a`.`ocom_obse`,	  `a`.`ocom_aten`,
	\  `a`.`ocom_deta`,	  `a`.`ocom_idus`,	  `a`.`ocom_fope`  As `ocom_fope`,	  `a`.`ocom_idpc`  As `ocom_idpc`,
	\  `a`.`ocom_idac`,	  `a`.`ocom_fact`,	 '' As Razo,	  `e`.`nomb`,doco_stock As totalstock
	\ From `fe_rocom` `a`
    \ Join `fe_docom` `b`  On `b`.`doco_idro` = `a`.`ocom_idroc`
    \ Join `fe_art` `c`    On `b`.`doco_coda` = `c`.`idart`
    \ Join `fe_usua` `e`   On `e`.`idusua` = `a`.`ocom_idus`
    \ Where `a`.`ocom_acti` = 'A'   And `b`.`doco_acti` ='A' And a.ocom_ndoc='<<cndoc>>'
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function GrabarCotizacion()
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	This.AutoC = This.RegistraCotCompra()
	If This.AutoC < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.grabardetalleocompra() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GeneraCorrelativo(This.Nsgte, This.Idserie) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	This.CONTRANSACCION = ""
	Return 1
	Endfunc
	Function ActualizarCotizacion()
	This.CONTRANSACCION = 'S'
	If This.IniciaTransaccion() < 1 Then
		Return 1
	Endif
	If This.Actualizaocompra() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	This.AutoC = This.Idr
	If This.grabardetalleocompra() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	This.CONTRANSACCION = ""
	Return 1
	Endfunc
	Function mostrarcotcompra(cndoc, Ccursor)
	If  Type('oempresa') = 'U' Then
		Cnruc = fe_gene.nruc
	Else
		Cnruc = Oempresa.nruc
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\  Select `b`.`doco_iddo`, `b`.`doco_coda` , `b`.`doco_cant`,	  `b`.`doco_prec`,
	\  `c`.`Descri` ,	  `c`.`prod_smin`,
	\  `c`.`Unid`,c.prod_cod1,	  `c`.`prod_smax`  As `prod_smax`,	  `a`.`ocom_valor` As `ocom_valor`,
	\  `a`.`ocom_igv`,	  `a`.`ocom_impo`  As `ocom_impo`,	  `a`.`ocom_idroc` As `ocom_idroc`,	  `a`.`ocom_fech`  As `ocom_fech`,
	\  `a`.`ocom_idpr`,	  `a`.`ocom_desp` ,	  `a`.`ocom_form`  As `ocom_form`,	  `a`.`ocom_mone`  As `ocom_mone`,
	\  `a`.`ocom_ndoc`,	  `a`.`ocom_tigv` ,	  `a`.`ocom_obse`  As `ocom_obse`,	  `a`.`ocom_aten`  As `ocom_aten`,
	\  `a`.`ocom_deta`,	  `a`.`ocom_idus`,	  `a`.`ocom_fope`  As `ocom_fope`,	  `a`.`ocom_idpc`  As `ocom_idpc`,
	\  `a`.`ocom_idac`,	  `a`.`ocom_fact`,	  `d`.`Razo`,	  `e`.`nomb`
	If m.Cnruc = '20601140625' Then
	  \,c.uno+c.Dos+c.tre+c.die+c.onc As totalstock
	Else
	 \,c.uno+c.Dos+c.tre+c.cua As totalstock
	Endif
	\ From `fe_rocom` `a`
    \ Join `fe_docom` `b`  On `b`.`doco_idro` = `a`.`ocom_idroc`
    \ Join `fe_art` `c`    On `b`.`doco_coda` = `c`.`idart`
    \ Join `fe_prov` `d`   On `d`.`idprov` = `a`.`ocom_idpr`
    \ Join `fe_usua` `e`   On `e`.`idusua` = `a`.`ocom_idus`
    \ Where `a`.`ocom_acti` ='A'   And `b`.`doco_acti` = 'A' And a.ocom_ndoc='<<cndoc>>' And ocom_tdoc='CO'
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listar(Ccursor)
	fi = cfechas(This.dfi)
	ff = cfechas(This.dff)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select   `b`.`doco_iddo`  As `doco_iddo`, Round(b.doco_cant * b.doco_prec, 2) As importe,
	\`b`.`doco_coda`  As idart,  `b`.`doco_cant`  As cant,  `b`.`doco_prec` As Prec,  `c`.`Descri`     As `Descri`,
	\`c`.`prod_smin`  As `prod_smin`,  `c`.`Unid`       As `Unid`,  `c`.`prod_smax`  As `prod_smax`,  `a`.`ocom_valor` As `ocom_valor`,
	\`a`.`ocom_igv`   As `ocom_igv`,  `a`.`ocom_impo`  As `ocom_impo`,  `a`.`ocom_idroc` As idautop,  `a`.`ocom_fech`  As fech,
	\`a`.`ocom_idpr`  As Codigo,  `a`.`ocom_desp`  As plazo,  `a`.`ocom_form`  As Forma,  `a`.`ocom_mone`  As mone,
	\`a`.`ocom_ndoc`  As ndoc,  `a`.`ocom_tigv`  As `ocom_tigv`,  `a`.`ocom_obse`  As `ocom_obse`,  `a`.`ocom_aten`  As aten,
	\`a`.`ocom_deta`  As detalle,  `a`.`ocom_idus`  As `ocom_idus`,  `a`.`ocom_fope`  As fecho,  `a`.`ocom_idpc`  As idpcped,
	\`a`.`ocom_idac`  As `ocom_idac`,  `a`.`ocom_fact`  As `ocom_fact`,  `d`.`Razo`       As `Razo`,  `e`.`nomb`       As usua,
	\'' As validez, '' As entrega, 'Orden de Compra' As tipopedido, '' As nomv
	\From `fe_rocom` `a`
	\Join `fe_docom` `b` On `b`.`doco_idro` = `a`.`ocom_idroc`
	\Join `fe_art` `c`   On `b`.`doco_coda` = `c`.`idart`
	\Join `fe_prov` `d`  On `d`.`idprov` = `a`.`ocom_idpr`
	\Join `fe_usua` `e`  On `e`.`idusua` = `a`.`ocom_idus`
	\Where `a`.`ocom_acti` <> 'I'       And `b`.`doco_acti` <> 'I' And ocom_fech Between '<<fi>>' And '<<ff>>'
	If This.Codproveedor > 0 Then
	\ And ocom_idpr=<<This.Codproveedor>>
	Endif
	\Order By a.ocom_ndoc,a.ocom_fech
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine













