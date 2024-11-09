Define Class Ventas As OData Of 'd:\capass\database\data.prg'
	Fecha = Date()
	Fechavto = Date()
	foperacion = Datetime()
	temporal = ""
	Codigo = 0
	sinserie = ""
	Ruc = ""
	Tdoc = ""
	dni = ""
	Encontrado = ""
	Serie = ""
	numero = ""
	Almacen = 0
	nroformapago = 0
	formaPago = ""
	igv = 0
	valor = 0
	exonerado = 0
	inafecta = 0
	gratuita = 0
	Monto = 0
	Moneda = ""
	Usuario = 0
	sinstock = ""
	dias = 0
	lineacredito = 0
	rptaSunat = ""
	Vendedor = 0
	Idauto = 0
	CreditoAutorizado = 0
	tipocliente = ""
	Tiponotacredito = ""
	nombre = ""
	tdocref = ""
	agrupada = 0
	noagrupada = 0
	montoreferencia = 0
	montonotacredito13 = 0
	detraccion = 0
	coddetraccion = ""
	chkdetraccion = 0
	Calias = ""
	NroGuia = ""
	razon = ""
	cletras = ""
	hash = ""
	Idserie = 0
	Nitems = 0
	Nsgte = 0
	ArchivoXml = ""
	ArchivoPdf = ""
	correo = ""
	idautoguia = 0
	Detalle = ""
	DetalleCaja = ""
	Iddire = 0
	clienteseleccionado = ""
	codt = 0
	fechai = Date()
	fechaf = Date()
	nmarca = 0
	nlinea = 0
	bancarizada = ""
	nmes = 0
	Na�o = 0
	Nreg = 0
	Proyecto = ""
	ndolar = 0
	vigv = 0
	cta1 = 0
	cta2 = 0
	cta3 = 0
	cta4 = 0
	tipodcto = ""
	Condetraccion = ""  && para Ventas con detracci�n
	Concaja = 0
	Ctipovta = ""
	etarjata = 0
	idanticipo = 0
	idanticipo2 = 0
	Tdscto = 0
	Creferencia = ""
	Ctarjeta = ""
	CtarjetaBanco = ""
	puntos = 0
	nacta = 0
	Etarjeta = 0
	AgrupadaGanancia = ''
	ctipoconsulta = ""
	Function mostraroventasservicios(np1, Ccursor)
	Text To lC Noshow Textmerge
	        SELECT b.nruc,b.razo,b.dire,b.ciud,a.dolar,a.fech,a.fecr,a.mone,a.idauto,a.vigv,a.valor,a.igv,
	        a.impo,ndoc,a.deta,a.tcom,a.idcliente,
	        w.impo as impo1,c.nomb,w.nitem,c.ncta,w.tipo,a.form,
	        w.idectas,w.idcta,a.rcom_dsct,rcom_idtr,rcom_mens,ifnull(p.fevto,a.fech) as fvto
	        from fe_rcom as a
	        inner join fe_ectas as w ON w.idrven=a.idauto
	        inner join fe_plan as c on c.idcta=w.idcta
	        inner join fe_clie as b on b.idclie=a.idcliente
	        left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r inner join fe_cred as c on c.cred_idrc=r.rcre_idrc
            where rcre_acti='A' and acti='A' and rcre_idau=<<np1>> group by rcre_idau) as p on p.rcre_idau=a.idauto
	        where a.idauto=<<np1>> and a.acti='A' and w.acti='A'
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostraroventasserviciosconretdet(np1, Ccursor)
	Text To lC Noshow Textmerge
	        SELECT b.nruc,b.razo,b.dire,b.ciud,a.dolar,a.fech,a.fecr,a.mone,a.idauto,a.vigv,a.valor,a.igv,
	        a.impo,ndoc,a.deta,a.tcom,a.idcliente,
	        w.impo as impo1,c.nomb,w.nitem,c.ncta,w.tipo,a.form,
	        w.idectas,w.idcta,a.rcom_dsct,rcom_idtr,rcom_mens,rcom_mdet,rcom_mret,ifnull(p.fevto,a.fech) as fvto,rcom_detr
	        from fe_rcom as a
	        inner join fe_ectas as w ON w.idrven=a.idauto
	        inner join fe_plan as c on c.idcta=w.idcta
	        inner join fe_clie as b on b.idclie=a.idcliente
	        left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r inner join fe_cred as c on c.cred_idrc=r.rcre_idrc
            where rcre_acti='A' and acti='A' and rcre_idau=<<np1>> group by rcre_idau) as p on p.rcre_idau=a.idauto
	        where a.idauto=<<np1>> and a.acti='A' and w.acti='A'
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function  mostrarotrasventas(np1, Ccursor)
	Text To lC Noshow Textmerge
	        SELECT b.nruc,b.razo,b.dire,b.ciud,a.dolar,a.fech,a.fecr,a.mone,a.idauto,a.vigv,a.valor,a.igv,
	        a.impo,ndoc,a.deta,a.tcom,a.idcliente,codt,tdoc,
	        w.impo as impo1,c.nomb,w.nitem,c.ncta,w.tipo,a.form,rcom_mdet,rcom_mret,
	        w.idectas,w.idcta,a.rcom_dsct,rcom_idtr,b.clie_corr,rcom_carg,rcom_mens,rcom_detr
	        from fe_rcom as a
	        inner join fe_ectas as w  ON w.idrven=a.idauto
	        inner join fe_plan as c on c.idcta=w.idcta
	        inner join fe_clie as b on b.idclie=a.idcliente
	        where a.idauto=<<np1>> and w.acti='A'
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function obteneridventa(np1, np2, Ccursor)
	Text To lC Noshow Textmerge
		    SELECT a.idauto,b.nruc FROM fe_rcom as a
		    inner JOIN fe_clie as b  on(b.idcliE=a.idcliente)
		    where a.ndoc='<<np1>>' and a.tdoc='<<np2>>' and acti<>'I'
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function obteneranticipo2(Ccursor)
	Text To lC Noshow Textmerge
		    SELECT ifnull(z.Ndoc,'') As dctoanticipo,ifnull(z.Impo,Cast(0 As Decimal(10,2))) As totalanticipo,
		    ifnull(If(z.rcom_exon>0,z.rcom_exon,z.valor),Cast(0 As Decimal(10,2))) As valorganticipo
		    from fe_rcom as r
		    inner join fe_rcom as z on z.idauto=r.rcom_idan2
		    where r.idauto=<<this.Idauto>>
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrardetalleotrasventas(np1, Ccursor)
	Text To lC Noshow Textmerge
				  SELECT q.detv_desc,q.detv_item,q.detv_ite1,q.detv_ite2,detv_prec,detv_cant FROM fe_detallevta as q
				  where detv_acti='A' and detv_idau=<<np1>> order by detv_idvt
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarventasxzonas(dfi, dff, nidzona, Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\    Select Descri As producto,p.Unid,Cast(T.Importe As Decimal(12,2)) As Importe,z.`zona_nomb` As zona,c.Razo As cliente From
	\	(Select Sum(k.cant*k.Prec) As Importe,idart,idcliente From fe_rcom  As r
	\	inner Join fe_kar As k On k.Idauto=r.Idauto
	\	Where fech='<<dfi>>' And '<<dff>>'  And r.Acti='A' And k.Acti='A'
	If nidzona > 0 Then
		   \ And clie_idzo=<<nidzona>>
	Endif
	\Group By k.idart,r.`idcliente` ) As T
	\	inner Join fe_clie As c On c.idclie=T.`idcliente`
	\	inner Join fe_art As p  On p.`idart`=T.`idart`
	\	inner Join fe_zona As z On z.`zona_idzo`=c.`clie_idzo` Order By zona_nomb
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ventasxusuario(fi, ff, nidtda, Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
		\Select fech,Ndoc,FUsua As fechahora,u.nomb As Usuario,T.nomb As tienda,r.idusua,If(Mone='S',r.Impo,r.Impo*dolar) As Impo From fe_rcom As r
		\inner Join fe_clie As c On c.`idclie`=r.`idcliente`
		\inner Join fe_usua As u  On u.`idusua`=r.`idusua`
		\inner Join fe_sucu As T On T.`idalma`=r.`codt`
		\Where fech Between '<<fi>>' And '<<ff>>'  And Acti='A'
	If nidtda > 0 Then
			\And r.codt=<<nidtda>>
	Endif
		\Order By u.nomb,T.nomb
	Set Textmerge Off
	Set Textmerge To
	If  This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function actualizaarsolofecha(np1, np2)
	Text To lC Noshow Textmerge
	      UPDATE fe_rcom SET fech='<<np2>>' WHERE idauto=<<np1>>
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function RentabilidadAgrupadaporproducto(fi, ff, Ccursor)
	Text To lC Noshow Textmerge
	    SELECT k.idart,p.descri,p.unid,cant,costototal,ventatotal,renta,c.dcat AS linea  FROM
       (SELECT k.idart,SUM(cant) AS cant,
	    CAST(SUM(cant*kar_cost) AS DECIMAL(12,2)) AS costoTotal,
	    CAST(SUM(cant*k.prec)  AS DECIMAL(12,2)) AS ventaTotal,
	    CAST(SUM(cant*k.prec)-SUM(cant*k.kar_cost) AS DECIMAL(12,2)) AS renta
		FROM fe_rcom AS r
		INNER JOIN fe_kar AS k ON k.idauto=r.idauto
	    WHERE r.fech BETWEEN '<<fi>>' AND '<<ff>>' AND idcliente>0 AND r.acti='A' AND k.acti='A' GROUP BY k.idart) AS k
	    INNER JOIN fe_art AS p ON p.idart=k.idart
	    INNER JOIN fe_cat AS c ON c.idcat=p.idcat  ORDER BY descri
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function RentabilidadAgrupadaporlinea(fi, ff, Ccursor)
	Text To lC Noshow Textmerge
	   SELECT c.dcat AS linea,SUM(cant) AS cant,SUM(costototal) AS costototal,SUM(ventatotal) AS ventatotal,SUM(renta) AS renta  FROM
       (SELECT k.idart,SUM(cant) AS cant,
	   CAST(SUM(cant*kar_cost) AS DECIMAL(12,2)) AS costoTotal,
	   CAST(SUM(cant*k.prec)  AS DECIMAL(12,2)) AS ventaTotal,
	   CAST(SUM(cant*k.prec)-SUM(cant*k.kar_cost) AS DECIMAL(12,2)) AS renta
	   fROM fe_rcom AS r
	   INNER JOIN fe_kar AS k ON k.idauto=r.idauto
	   WHERE r.fech BETWEEN '<<fi>>' AND '<<ff>>' AND idcliente>0 AND r.acti='A' AND k.acti='A' GROUP BY k.idart) AS k
	   INNER JOIN fe_art AS p ON p.idart=k.idart
	   INNER JOIN fe_cat AS c ON c.idcat=p.idcat  GROUP BY c.dcat  ORDER BY dcat
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function obtenervendedorlopez(np1, Ccursor)
	Text To lC Noshow Textmerge
	SELECT nomv AS vendedor,idven,CAST(IFNULL(dctos_idau,0) as decimal) AS dctos_idau FROM fe_rvendedor AS r
	INNER JOIN fe_vend AS v ON v.idven=r.vend_codv
	LEFT JOIN (SELECT dctos_idau FROM fe_ldctos WHERE dctos_idau=<<np1>> and dctos_acti='A') AS l ON l.dctos_idau=r.vend_idau
	WHERE vend_idau=<<np1>>
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function validarvtas()
*:Global x
	x = validacaja(This.Fecha)
	If x = "C"
		This.Cmensaje = "La caja de Esta Fecha Esta Cerrada"
		Return .F.
	Endif
	Select (This.temporal)
	Locate For Valida = "N"
	cndoc = Alltrim(This.Serie) + Alltrim(This.numero)
	Do Case
	Case This.Codigo = 0 Or Empty(This.Codigo)
		This.Cmensaje = "Seleccione un Cliente Para Esta Venta"
		Return .F.
	Case This.sinserie = "N"
		This.Cmensaje = "Serie NO Permitida"
		Return .F.
	Case Found()
		This.Cmensaje = "Hay Un Producto que Falta Cantidad o Precio"
		Return .F.
	Case This.Ruc = "***********"
		This.Cmensaje = "Seleccione Otro Cliente"
		Return .F.
	Case This.Tdoc = "01" And !ValidaRuc(This.Ruc)
		This.Cmensaje = "Ingrese RUC del Cliente"
		Return .F.
	Case This.Tdoc = "03" And This.Monto > 700 And Len(Alltrim(This.dni)) < 8
		This.Cmensaje = "Ingrese DNI del Cliente "
		Return .F.
	Case This.Encontrado = "V"
		This.Cmensaje = "NO Es Posible Actualizar Este Documento El Numero del Comprobante Pertenece a uno ya Registrado"
		Return .F.
	Case This.Monto = 0
		This.Cmensaje = "Ingrese Cantidad y Precio"
		Return .F.
	Case This.Serie = "0000" Or Val(This.numero) = 0 Or Len(Alltrim(This.Serie)) < 3;
			Or Len(Alltrim(This.numero)) < 8
		This.Cmensaje = "Ingrese Un N�mero de Documento V�lido"
		Return .F.
	Case Empty(This.Almacen)
		This.Cmensaje = "Seleccione Un Almacen"
		Return .F.
	Case Month(This.Fecha) <> goApp.mes Or Year(This.Fecha) <> Val(goApp.a�o) Or !esfechaValida(This.Fecha)
		This.Cmensaje = "Fecha NO Permitida Por el Sistema y/o Fecha no V�lida"
		Return .F.
	Case  !esFechaValidafvto(This.Fechavto)
		This.Cmensaje = "Fecha de Vencimiento no V�lida"
		Return .F.
	Case This.Fechavto <= This.Fecha And This.nroformapago = 2
		This.Cmensaje = "La Fecha de Vencimiento debe ser diferente de le fecha de Emisi�n "
		Return .F.
	Case PermiteIngresoVentas1(cndoc, This.Tdoc, 0, This.Fecha) = 0
		This.Cmensaje = "N�mero de Documento de Venta Ya Registrado"
		Return .F.
	Otherwise
		Return .T.
	Endcase
	Endfunc
	Function ValidarVtaslopez()
*:Global x
	x = validacaja(This.Fecha)
	If x = "C"
		This.Cmensaje = "La caja de Esta Fecha Esta Cerrada"
		Return .F.
	Endif
*	Select (This.temporal)
*Locate For Valida = "N"
	cndoc = Alltrim(This.Serie) + Alltrim(This.numero)
	Do Case
	Case This.Codigo = 0 Or Empty(This.Codigo)
		This.Cmensaje = "Seleccione un Cliente Para Esta Venta"
		Return .F.
	Case This.sinserie = "N"
		This.Cmensaje = "Serie NO Permitida"
		Return .F.
*Case Found()
*	This.Cmensaje = "Hay Un Producto que Falta Cantidad o Precio"
*!*			Return .F.
	Case This.Ruc = "***********"
		This.Cmensaje = "Seleccione Otro Cliente"
		Return .F.
	Case This.Tdoc = "01" And !ValidaRuc(This.Ruc)
		This.Cmensaje = "Ingrese RUC del Cliente"
		Return .F.
	Case This.Tdoc = "03" And This.Monto > 700 And Len(Alltrim(This.dni)) <> 8
		This.Cmensaje = "Ingrese DNI del Cliente "
		Return .F.
	Case This.Encontrado = "V"
		This.Cmensaje = "NO Es Posible Actualizar Este Documento El Numero del Comprobante Pertenece a uno ya Registrado"
		Return .F.
	Case This.Monto = 0
		This.Cmensaje = "Ingrese Cantidad y Precio"
		Return .F.
	Case This.Serie = "0000" Or Val(This.numero) = 0 Or Len(Alltrim(This.Serie)) <> 4;
			Or Len(Alltrim(This.numero)) < 8
		This.Cmensaje = "Ingrese Un N�mero de Documento V�lido"
		Return .F.
	Case Empty(This.Almacen)
		This.Cmensaje = "Seleccione Un Almacen"
		Return .F.
	Case Month(This.Fecha) <> goApp.mes Or Year(This.Fecha) <> Val(goApp.a�o) Or !esfechaValida(This.Fecha)
		This.Cmensaje = "Fecha NO Permitida Por el Sistema y/o Fecha no V�lida"
		Return .F.
	Case  !esFechaValidafvto(This.Fechavto)
		This.Cmensaje = "Fecha de Vencimiento no V�lida"
		Return .F.
	Case This.Fechavto <= This.Fecha And This.nroformapago = 2
		This.Cmensaje = "La Fecha de Vencimiento debe ser mayor a la fecha de Emisi�n "
		Return .F.
	Case This.nroformapago >= 2 And This.CreditoAutorizado = 0 And vlineacredito(This.Codigo, This.Monto, This.lineacredito) = 0
		This.Cmensaje = "LINEA DE CREDITO FUERA DE LIMITE O TIENE VENCIMIENTOS MAYORES A 30 DIAS"
		Return .F.
	Case This.tipocliente = 'm' And This.nroformapago >= 2
		This.Cmensaje = "No es Posible Efecuar esta Venta El Cliente esta Calificado Como MALO"
		Return .F.
	Case PermiteIngresoVentas1(cndoc, This.Tdoc, 0, This.Fecha) = 0
		This.Cmensaje = "N�mero de Documento de Venta Ya Registrado"
		Return .F.
	Case PermiteIngresox(This.Fecha) = 0
		This.Cmensaje = "Los Ingresos con esta Fecha no estan permitidos por estar Bloqueados "
		Return .F.
	Case goApp.Xopcion = 0
		Do Case
		Case Substr(This.Serie, 2) = '010' And This.nroformapago = 1
			This.Cmensaje = "Solo Se permiten Ventas Al Cr�dito Con esta Serie de Comprobantes "
			Return .F.
		Case Substr(This.Serie, 2) = '010' And This.nroformapago >= 2 And goApp.nidusua <> goApp.nidusuavcredito
			This.Cmensaje = "Usuario NO AUTORIZADO PARA ESTA VENTA AL CR�DITO"
			Return .F.
		Case Substr(This.Serie, 2) = '010' And This.nroformapago = 1 And goApp.nidusua = goApp.nidusuavcredito
			This.Cmensaje = "Usuario NO AUTORIZADO PARA ESTA VENTA EN EFECTIVO"
			Return .F.
		Otherwise
			Return .T.
		Endcase
	Otherwise
		Return .T.
	Endcase
	Endfunc
	Function validarvtasporservicios()
	If Len(Alltrim(This.temporal)) > 0 And VerificaAlias(This.temporal) = 1
		Calias = This.temporal
		Select Sum(cant * Prec) As Impo From (Calias) Where Nitem > 0 And (cant * Prec) = 0 Into Cursor tvalidar
		If _Tally > 0 Then
			This.Cmensaje = 'Hay Item(s) que no tinen Importe'
			Return .F.
		Endif
		Select Desc From (Calias) Where Nitem > 0 And Len(Alltrim(Desc)) = 0 Into Cursor tvalidar
		If _Tally > 0 Then
			This.Cmensaje = 'Hay Item(s) que no tine Descripci�n'
			Return .F.
		Endif
	Endif
	cndoc = Alltrim(This.Serie) + Alltrim(This.numero)
	Do Case
	Case  PermiteIngresox(This.Fecha) = 0
		This.Cmensaje = "No Es posible Registrar en esta Fecha estan bloqueados Los Ingresos"
		Return .F.
	Case This.Vendedor = 0
		This.Cmensaje = "Seleccione Un Vendedor"
		Return .F.
	Case Left(This.rptaSunat, 1) = '0'
		This.Cmensaje = "Este Documento ya fue Informado a SUNAT"
		Return .F.
	Case This.Encontrado = 'V' And TieneKardex(This.Idauto) = 0
		This.Cmensaje = "Este Documento Tiene Movimientos Relacionados con el Kardex...Utilice por la Opci�n ACTUALIZAR VENTAS"
		Return .F.
	Case This.Codigo = 0  Or Empty(This.Codigo)
		This.Cmensaje = "Seleccione un Cliente Para Esta Venta"
		Return .F.
	Case This.sinserie = "N"
		This.Cmensaje = "Serie NO Permitida"
		Return .F.
	Case This.Ruc = "***********"
		This.Cmensaje = "Seleccione Otro Cliente"
		Return .F.
	Case This.Tdoc = "01" And !ValidaRuc(This.Ruc)
		This.Cmensaje = "Ingrese RUC del Cliente"
		Return .F.
	Case This.Tdoc = "03" And This.Monto >= 700 And Len(Alltrim(This.dni)) <> 8
		This.Cmensaje = "Ingrese DNI del Cliente "
		Return .F.
	Case This.Serie = "0000" Or Val(This.numero) = 0 Or Len(Alltrim(This.Serie)) < 3Or Len(Alltrim(This.numero)) < 8
		This.Cmensaje = "Ingrese Un N�mero de Documento V�lido"
		Return .F.
	Case Month(This.Fecha) <> goApp.mes Or Year(This.Fecha) <> Val(goApp.a�o) Or !esfechaValida(This.Fecha)
		This.Cmensaje = "Fecha NO Permitida Por el Sistema y/o Fecha no V�lida"
		Return .F.
	Case  !esFechaValidafvto(This.Fechavto)
		This.Cmensaje = "Fecha de Vencimiento no V�lida"
		Return .F.
	Case This.Fechavto <= This.Fecha And This.nroformapago = 2
		This.Cmensaje = "La Fecha de Vencimiento debe ser diferente de le fecha de Emisi�n "
		Return .F.
	Case This.chkdetraccion = 1 And Len(Alltrim(This.coddetraccion)) <> 3
		This.Cmensaje = "Ingrese C�digo de Detracci�n V�lido"
		Return .F.
	Case This.Monto = 0 And This.idanticipo = 0
		This.Cmensaje = "Ingrese Cantidad y Precio"
		Return .F.
	Case This.verificarsiesta() < 1
		This.Cmensaje = "N�mero de Documento de Venta Ya Registrado"
		Return .F.
	Otherwise
		Return .T.
	Endcase
	Endfunc
	Function buscardctoparaplicarncndconseries(np1, Ccursor)
	Text To lC Noshow Textmerge
	   SELECT a.coda as idart,a.descri,a.unid,a.cant,a.prec,
	   ROUND(a.cant*a.prec,2) as importe,a.idauto,a.mone,a.valor,a.igv,a.impo,kar_comi as comi,alma,
	   a.fech,a.ndoc,a.tdoc,a.dolar as dola,vigv,rcom_exon,ifnull(s.seriep,"") as serieproducto,ifnull(idseriep,0) as idseriep FROM vmuestraventas as a
	   left join (SELECT rser_seri as seriep,rser_idse as idseriep,dser_idka FROM fe_rseries f
       inner join fe_dseries g on g.dser_idre=f.rser_idse
       where g.dser_acti='A' and rser_acti='A') as s ON s.dser_idka=a.idkar WHERE a.idauto=<<np1>>
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function extornarstockenventas(Ccursor)
	Set Procedure To d:\capass\modelos\productos Additive
	opro = Createobject("producto")
	This.CONTRANSACCION = 'S'
	xy = 1
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	Scan All
		Text To lC Noshow Textmerge
		    UPDATE fe_kar SET alma=0 where idkar=<<dvtas.idkar>>
		Endtext
		If  This.Ejecutarsql(lC) < 1 Then
			xy = 0
			Exit
		Endif
		If opro.ActualizaStock(dvtas.idart, dvtas.alma, dvtas.cant, 'C') < 1 Then
			xy		 = 0
			Exit
		Endif
	Endscan
	If xy = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	This.CONTRANSACCION = ""
	Return 1
	Endfunc
	Function mostrarresumenventasxproducto(dfi, dff, Ccursor)
	Text To lC Noshow Textmerge
	   SELECT  a.descri,a.unid,k.cant,CAST(k.importe AS DECIMAL(12,2))AS importe,k.idart FROM
	   (SELECT idart,SUM(cant) as cant,SUM(cant*prec) as importe from fe_rcom AS r
	   INNER JOIN fe_kar AS k ON k.idauto=r.idauto
	   WHERE r.fech between '<<dfi>>' and '<<dff>>' AND k.acti='A' and r.acti='A' and idcliente>0 group by idart) as k
	   INNER JOIN fe_art AS a ON a.idart=k.idart
	   order by descri
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrardetalleventas(np1, Ccursor)
	Text To lC Noshow Textmerge
	   SELECT  c.razo,a.descri,a.unid,k.cant,k.prec,k.idart,k.alma,r.idcliente AS idclie,r.idauto,rcom_idtr,
	   r.fech,r.valor,r.igv,r.impo,r.mone,u.nomb AS usuario,r.fusua,ndoc,idkar FROM fe_rcom AS r
	   INNER JOIN fe_clie AS c ON c.idclie=r.idcliente
	   INNER JOIN fe_kar AS k ON k.idauto=r.idauto
	   INNER JOIN fe_art AS a ON a.idart=k.idart
	   INNER JOIN fe_usua AS u  ON u.idusua=r.idusua
	   WHERE r.idauto=<<np1>> AND k.acti='A'
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ValidarNotaCreditoVentas()
	If This.noagrupada = 1 Then
		Select Sum(devo) As tdevo From tmpn Into Cursor tdevol
		Sw = 1
		Select tmpn
		Scan All
			If tdevol.tdevo > 0 Then
				If (tmpn.devo * tmpn.dsct) = 0 And (tmpn.dsct > 0 Or tmpn.devo > 0)  Then
					If Fsize("descri") > 0 Then
						This.Cmensaje = "Los Importes del Item " + Alltrim(tmpn.Descri) + " No son V�lidos"
					Else
						This.Cmensaje = "Los Importes del Item " + Alltrim(tmpn.Desc) + " No son V�lidos"
					Endif
					Sw = 0
					Exit
				Endif
			Endif
		Endscan
		If Sw = 0 Then
			Return 0
		Endif
	Endif
	Do Case
	Case This.Monto = 0 And  This.Tiponotacredito <> '13'
		This.Cmensaje = "Importes Deben de Ser Diferente de Cero"
		Return 0
	Case Len(Alltrim(This.Serie)) < 4 Or Len(Alltrim(This.numero)) < 8;
			Or This.Serie = "0000" Or Val(This.numero) = 0
		This.Cmensaje = "Falta Ingresar Correctamente el N�mero del  Documento"
		Return 0
	Case This.tdocref = '01' And  !'FN' $ Left(This.Serie, 2) And This.Tdoc = '07'
		This.Cmensaje = "N�mero del  Documento NO V�lido"
		Return 0
	Case This.tdocref = '01' And  !'FD' $ Left(This.Serie, 2) And This.Tdoc = '08'
		This.Cmensaje = "N�mero del  Documento NO V�lido"
		Return 0
	Case This.Codigo = 0
		This.Cmensaje = "Ingrese Un Cliente"
		Return 0
	Case (Len(Alltrim(This.nombre)) < 5 Or !ValidaRuc(This.Ruc)) And This.tdocref = '01'
		This.Cmensaje = "Es Necesario Ingresar el Nombre Completo de Cliente, RUC V�lido"
		Return 0
	Case (Len(Alltrim(This.nombre)) < 5 Or Len(Alltrim(This.dni)) <> 8) And This.tdocref = '03'
		This.Cmensaje = "Es Necesario Ingresar el Nombre Completo de Cliente, DNI V�lidos"
		Return 0
	Case Year(This.Fecha) <> Val(goApp.a�o)
		This.Cmensaje = "La Fecha No es V�lida"
		Return 0
	Case  PermiteIngresox(This.Fecha) = 0
		This.Cmensaje = "No Es posible Registrar en esta Fecha estan bloqueados Los Ingresos"
		Return 0
	Case PermiteIngresoVentas1(This.Serie + This.numero, This.Tdoc, 0, This.Fecha) = 0
		This.Cmensaje = "N� de Documento de Venta Ya Registrado"
		Return 0
	Case Left(This.Tiponotacredito, 2) = '13' And This.agrupada = 0
		This.Cmensaje = "Tiene que seleccionar la opci�n  Agrupada para este documento"
		Return 0
	Case Left(This.Tiponotacredito, 2) = '13' And This.Monto > 0
		This.Cmensaje = "Los Importes Deben de ser 0"
		Return 0
	Case Left(This.Tiponotacredito, 2) = '13' And This.montonotacredito13 = 0
		This.Cmensaje = "Ingrese Importe para Nota Cr�dito Tipo 13"
		Return 0
	Case This.Tdoc = '07'
		If This.Monto > This.montoreferencia
			This.Cmensaje = "El Importe No Puede Ser Mayor al del Documento"
			Return 0
		Else
			Return 1
		Endif
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function Buscarsiestaregistrado(cdcto, cTdoc)
	Text To lC Noshow Textmerge
       SELECT  idauto FROM fe_rcom WHERE ndoc='<<cdcto>>' AND tdoc='<<ctdoc>>' and acti<>'I' AND idcliente>0
	Endtext
	Ccursor = Alltrim(Sys(2015))
	If This.EJECutaconsulta (lC, (Ccursor)) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If Idauto > 0 Then
		This.Cmensaje = 'Este Documento Ya esta Registrado en la Base de Datos'
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function mostrarventaspornumerosh(Df, cTdoc, Cserie, ndesde, nhasta, Ccursor)
	If cTdoc = '20' Then
		Text To lC Noshow Textmerge
	        SELECT serie,numero,ndni,razo,if(mone='S','Soles','D�lares') as mone,valor,igv,impo,idauto,fech,tdoc
		    from(select f.fech,f.tdoc,mone,
		    left(f.ndoc,3) as serie,substr(f.ndoc,4) as numero,
		    if(f.mone='S',f.valor,f.valor*f.dolar) as valor,f.rcom_exon,
		    if(f.mone='S',f.igv,f.igv*f.dolar) as igv,
		    if(f.mone='S',f.impo,f.impo*f.dolar) as impo,cast(mid(f.ndoc,4) as unsigned) as numero1,c.ndni,c.razo,f.idauto
	     	fROM fe_rcom f
	     	inner join fe_clie as c on c.idclie=f.idcliente
		    where f.tdoc='<<ctdoc>>' and f.fech='<<df>>'  and f.acti='A'   order by f.ndoc) as x
		    where numero1 between <<ndesde>> and <<nhasta>> and serie='<<cserie>>'
		Endtext
	Else
		Text To lC Noshow Textmerge
	        SELECT serie,numero,ndni,razo,if(mone='S','Soles','D�lares') as mone,valor,igv,impo,idauto,fech,tdoc
		    from(select f.fech,f.tdoc,mone,
		    left(f.ndoc,4) as serie,substr(f.ndoc,5) as numero,if(f.mone='S',f.valor,f.valor*f.dolar) as valor,
		    f.rcom_exon,if(f.mone='S',f.igv,f.igv*f.dolar) as igv,
		    if(f.mone='S',f.impo,f.impo*f.dolar) as impo,cast(mid(f.ndoc,5) as unsigned) as numero1,c.ndni,c.razo,f.idauto
	     	fROM fe_rcom f
	     	inner join fe_clie as c on c.idclie=f.idcliente
		    where f.tdoc='<<ctdoc>>' and f.fech='<<df>>'  and f.acti='A'   order by f.ndoc) as x
		    where numero1 between <<ndesde>> and <<nhasta>> and serie='<<cserie>>'
		Endtext
	Endif
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function imprimirenbloque(Calias)
	Create Cursor tmpv(Desc c(100), Unid c(20), Prec N(13, 8), cant N(10, 3), ;
		  Ndoc c(10), Coda N(8), Nitem N(3), cletras c(120), duni c(20), Tdoc c(2), razon c(100), Direccion c(100), ndni c(8), fech d, Impo N(8, 2), copia c(1), Importe N(12, 2))
	Select rid
	Go Top
	Sw = 1
	Do While !Eof()
		Cimporte = ""
		Cimporte = Diletras(rid.Impo, 'S')
		xid = rid.Idauto
		nimporte = rid.Impo
		Text To lC Noshow Textmerge
		    SELECT a.ndoc,a.fech,a.tdoc,a.impo,b.idart,
		    left(concat(trim(f.dcat),' ',substr(c.descri,instr(c.descri,',')+1),' ',substr(c.descri,1,instr(c.descri,',')-1)),150) as descri,
		    b.kar_unid as unid,b.cant,b.prec,e.razo,e.dire,e.ciud,e.ndni FROM fe_rcom as a
			inner join fe_kar as b on b.idauto=a.idauto
			inner join fe_clie as e on e.idclie=a.idcliente
			inner join fe_art as c on c.idart=b.idart
			inner join fe_cat as f on f.idcat=c.idcat
			where a.acti='A' and b.acti='A' and  a.idauto=<<rid.idauto>> order by b.idkar
		Endtext
		If This.EJECutaconsulta(lC, 'xtmpv') < 1 Then
			Sw = 0
			Exit
		Endif
		Select Ndoc, fech, Tdoc, Impo, Descri As Desc, Unid As duni, cant, Prec, Razo, Dire, ciud, ndni, Cimporte As cletras, Recno() As Nitem, Unid From xtmpv Into Cursor xtmpv
		ni = 0
		Select xtmpv
		Scan All
			cndoc = xtmpv.Ndoc
			ni = ni + 1
			Insert Into tmpv(Ndoc, Nitem, cletras, Tdoc, fech, Desc, duni, cant, Prec, razon, Direccion, ndni, Unid, Importe);
				Values(cndoc, ni, Cimporte, xtmpv.Tdoc, xtmpv.fech, xtmpv.Desc, xtmpv.duni, xtmpv.cant, xtmpv.Prec, xtmpv.Razo, Alltrim(xtmpv.Dire) + ' ' + Alltrim(xtmpv.ciud), ;
				  xtmpv.ndni, xtmpv.Unid, nimporte)
		Endscan
		Select tmpv
		For x = 1 To 17 - ni
			ni = ni + 1
			Insert Into tmpv(Ndoc, Nitem, cletras, Importe)Values(cndoc, ni, Cimporte, nimporte)
		Next
		Select rid
		Skip
	Enddo
	If Sw = 0 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function GeneraCorrelativovtas()
	Set Procedure To d:\capass\modelos\correlativos Additive
	ocorr = Createobject("correlativo")
	ocorr.Nsgte = This.Nsgte
	ocorr.Idserie = This.Idserie
	If ocorr.GeneraCorrelativo1() < 1  Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function GeneraCorrelativo(cndoc, nIdserie)
	Local cn As Integer
	cn = Val(Substr(cndoc, 5)) + 1
	If GeneraCorrelativo(cn, nIdserie) = 0 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function IngresaDocumentoElectronicocondirecciones(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25)
	lC = 'FuningresaDocumentoElectronico'
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
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
	Endtext
	nidf = This.EJECUTARf(lC, lp, cur)
	If nidf < 1 Then
		Return 0
	Endif
	Return nidf
	Endfunc
	Function IngresaResumenDctovtascondetraccioncondirecciones(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25, np26)
	Local lC, lp
*:Global cur
	lC			  = 'FunIngresaCabeceraVtascdetraccion'
	cur			  = "Xn"
	goApp.npara1  = np1
	goApp.npara2  = np2
	goApp.npara3  = np3
	goApp.npara4  = np4
	goApp.npara5  = np5
	goApp.npara6  = np6
	goApp.npara7  = np7
	goApp.npara8  = np8
	goApp.npara9  = np9
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
	Text To lp Noshow
    (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26)
	Endtext
	nidf = This.EJECUTARf(lC, lp, cur)
	If nidf < 1 Then
		Return 0
	Endif
	Return nidf
	Endfunc
	Function ActualizaResumenDctocondirecciones(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25)
	lC = 'ProActualizaCabeceravtas'
	cur = ""
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
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
	Endtext
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrardctoparanotascreditogral(np1, Ccursor)
	Text To lC Noshow Textmerge
	   SELECT a.idart,a.descri,unid,k.cant,k.prec,k.codv,
	   ROUND(k.cant*k.prec,2) as importe,r.idauto,r.mone,r.valor,r.igv,r.impo,kar_comi as comi,k.alma,
	   r.fech,r.ndoc,r.tdoc,r.dolar as dola,kar_cost FROM fe_rcom as r
	   inner join fe_kar as k on k.idauto=r.idauto
	   inner join fe_art as a on a.idart=k.idart
	   WHERE r.idauto=<<np1>> and k.acti='A' order By  idkar
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarvtasresumidaspormes(ccoda, Ccursor)
	dff = Cfechas(fe_gene.fech)
	dfi = Cfechas(fe_gene.fech - 90)
	Text To lC Noshow Textmerge
    SELECT
	CASE nromes
	 WHEN 1 THEN 'Enero'
	 WHEN 2 THEN 'Febrero'
	 WHEN 3 THEN 'Marzo'
	 WHEN 4 THEN 'Abril'
	 WHEN 5 THEN 'Mayo'
	 WHEN 6 THEN 'Junio'
	 WHEN 7 THEN 'Julio'
	 WHEN 8 THEN 'Agosto'
	 WHEN 9 THEN 'Septiembre'
	 WHEN 10 THEN 'Octubre'
	 WHEN 11 THEN 'Noviembre'
	 ELSE 'Diciembre'
	END AS mes,
	SUM(cant) AS cant,nromes FROM(
	SELECT cant,MONTH(fech) AS nromes FROM fe_kar AS a
	INNER JOIN fe_rcom  AS c ON(c.idauto=a.idauto)
	WHERE idart=<<ccoda>>  AND c.acti='A' AND a.acti='A' AND idcliente>0 AND c.fech between '<<dfi>>' and '<<dff>>') AS xx GROUP BY mes,nromes order by nromes
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function ultimamontoventas()
	Ccursor = 'c_' + Sys(2015)
	Text To lC Noshow Textmerge
	SELECT MAX(lcaj_fope) AS fope,lcaj_deud as monto FROM fe_lcaja WHERE lcaj_deud>0 AND lcaj_acti='A' AND lcaj_idau>0 GROUP BY lcaj_fope,lcaj_deud  ORDER BY lcaj_fope DESC LIMIT 1
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	Return Monto
	Endfunc
	Function mnostrarventasagrupdasporcantidadymes(Calias)
	fi = Cfechas(This.fechai)
	ff = Cfechas(This.fechaf)
	Set DataSession To This.Idsesion
	Text To lC Noshow Textmerge
	  SELECT idart,SUM(enero) AS enero,SUM(febrero) AS febrero,SUM(marzo) AS marzo,
      SUM(abril) AS abril,SUM(mayo) AS mayo,SUM(junio) AS junio,SUM(julio) AS julio,SUM(agosto) AS agosto,
      SUM(septiembre) AS septiembre,SUM(octubre) AS octubre,SUM(noviembre) AS noviembre,SUM(diciembre) AS diciembre
      FROM(
      SELECT idart,
	  CASE mes WHEN 1 THEN cant ELSE 0 END AS enero,
	  CASE mes WHEN 2 THEN cant ELSE 0 END AS febrero,
	  CASE mes WHEN 3 THEN cant ELSE 0 END AS marzo,
	  CASE mes WHEN 4 THEN cant ELSE 0 END AS abril,
	  CASE mes WHEN 5 THEN cant ELSE 0 END AS mayo,
	  CASE mes WHEN 6 THEN cant ELSE 0 END AS junio,
	  CASE mes WHEN 7 THEN cant ELSE 0 END AS julio,
	  CASE mes WHEN 8 THEN cant ELSE 0 END AS agosto,
	  CASE mes WHEN 9 THEN cant ELSE 0 END AS septiembre,
	  CASE mes WHEN 10 THEN cant ELSE 0 END AS octubre,
	  CASE mes WHEN 11 THEN cant ELSE 0 END AS noviembre,
	  CASE mes WHEN 12 THEN cant ELSE 0 END AS diciembre
	  FROM(
	  SELECT idart,SUM(cant) AS cant,MONTH(fech) AS mes FROM fe_kar AS k
	  INNER JOIN fe_rcom AS r ON r.`idauto`= k.`idauto`
	  WHERE r.fech BETWEEN '<<fi>>' AND '<<ff>>' AND r.acti='A' AND k.`acti`='A' and r.idcliente>0
	  GROUP BY idart,mes) AS xx) AS yy GROUP BY idart ORDER BY idart
	Endtext
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ventasxcliente(Ccursor)
	dfi = Cfechas(This.fechai)
	dff = Cfechas(This.fechaf)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To  Memvar lcc Noshow
		    \Select x.fech,x.fecr,x.Tdoc,x.Ndoc,x.ndo2,x.Mone,x.valor,x.igv,x.Impo,x.pimpo,x.dolar As dola,x.Form,x.Idauto,
			\Y.cant,Y.Prec,Round(Y.cant*Y.Prec,2)As Importe,dsnc,dsnd,gast,
			\z.Descri,z.Unid,w.nomb As Usuario,x.FUsua From fe_rcom x
			\inner Join fe_kar Y On Y.Idauto=x.Idauto
			\inner Join fe_clie T On T.idclie=x.idcliente
			\inner Join fe_usua w On w.idusua=x.idusua
			\inner Join fe_art z  On z.idart=Y.idart
			\Where x.fech Between '<<dfi>>' And '<<dff>>'
	If This.codt > 0 Then
			   \ And x.codt=<<This.codt>>
	Endif
	If This.Codigo > 0 Then
			\ And x.idcliente=<<This.Codigo>>
	Endif
	If This.nmarca > 0 Then
			\ And z.idmar=<<This.nmarca>>
	Endif
	Set Textmerge To
	Set Textmerge To Memvar lcc Noshow  Additive
			\ And x.Acti='A' And Y.Acti='A' Order By fech,x.Tdoc,x.Ndoc
	Set Textmerge To
	Set Textmerge Off
	If This.EJECutaconsulta(lcc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Registroventaspsystr(Ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	f1 = Cfechas(This.fechai)
	f2 = Cfechas(This.fechaf)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
	   \Select a.Form,a.fecr,a.fech,a.Tdoc,If(Length(Trim(a.Ndoc))<=10,Left(a.Ndoc,3),Left(a.Ndoc,4)) As Serie,
	   \If(Length(Trim(a.Ndoc))<=10,mid(a.Ndoc,4,7),mid(a.Ndoc,5,8)) As Ndoc,
	   \b.nruc,b.ndni ,b.Razo,Round(If(Mone='S',a.valor,(a.Impo*a.dolar)/a.vigv),2) As valorg,
	   \Round(If(Mone='D',rcom_exon*dolar,rcom_exon),2) As Exon,Cast(0 As Decimal(12,2)) As inafecta,
	   \Round(If(Mone="D",Impo*dolar-(Impo*dolar)/vigv,igv),2) As igvg,
	   \Round(If(Mone="D",Impo*dolar,Impo),2) As Importe,
	   \Cast(a.rcom_icbper As Decimal(5,2)) As icbper,a.pimpo,a.Deta As Detalle,rcom_mens As Mensaje,Cast(a.dolar As Decimal(8,3))As dola,a.Mone,a.idcliente As Codigo,fech As fevto,
	   \If(Tdoc='07',fech,If(Tdoc='08',fech,Cast("0001-01-01" As Date))) As fechn,
   	   \If(Tdoc='07',Tdoc,If(Tdoc='08',Tdoc,' ')) As tref,
	   \If(Tdoc='07',Ndoc,If(Tdoc='08',Ndoc,' ')) As Refe,a.vigv,
	   \a.Idauto  From fe_rcom As a
	   \inner Join fe_clie  As b On(b.idclie=a.idcliente)
	   \Where fecr Between '<<f1>>' And '<<f2>>'   And Tdoc In ('01','03','07','08') And Acti='A'
	If goApp.Cdatos = 'S' Then
	      \And a.codt=<<goApp.tienda>>
	Endif
	If Len(Alltrim(This.Serie)) > 0 Then
	   \ And Left(a.Ndoc,4)='<<this.serie>>'
	Endif
	If Len(Alltrim(This.Tdoc)) > 0 Then
    	\  And  a.Tdoc='<<this.tdoc>>'
	Endif
	If goApp.Cdatos = 'S' Then
	      \And z.codt=<<goApp.tienda>>
	Endif
	If This.Serie <> '' Then
	   \ And Left(a.Ndoc,4)='<<this.serie>>'
	Endif
	  \ Order By Serie,fech,Ndoc
	Set Textmerge To
	Set Textmerge Off
	If This.EJECutaconsulta(lC, 'registro1') < 1 Then
		Return 0
	Endif
	If This.Listarnotascreditoydebito('xnotas') < 1 Then
		Return 0
	Endif
	Create Cursor registro(Form c(1) Null, fecr d Null, fech d Null, Tdoc c(2) Null, Serie c(4), Ndoc c(8), nruc c(11)Null, ndni c(8), Razo c(100)Null, valorg N(14, 2), Exon N(12, 2), inafecta N(12, 2), ;
		  igvg N(10, 2), Importe N(14, 2), icbper N(12, 2), pimpo N(8, 2), Detalle c(50), Mensaje c(100), tref c(2), Refe c(12), dola N(5, 3),  Mone c(1), Codigo N(5), fechn d, fevto d, ;
		  Auto N(15),  T N(1))
	notas = 0
	x = 0
	Select registro1
	Go Top
	Do While !Eof()
		nidn = registro1.Idauto
		ntdoc = '00'
		nndoc = '            '
		nfech = Ctod("  /  /    ")
		If registro1.Tdoc = '07' Or registro1.Tdoc = '08' Then
			NAuto = registro1.Idauto
			Select * From xnotas Where ncre_idan = NAuto Into Cursor Xn
			notas = 1
			nidn = Xn.idn
			ntdoc = Xn.Tdoc
			nndoc = Xn.Ndoc
			nfech = Xn.fech
		Endif
		Insert Into registro(Form, fecr, fech, Tdoc, Serie, Ndoc, nruc, Razo, valorg, igvg, Exon, inafecta, Importe, pimpo, Detalle, Mone, dola, Codigo, Auto, ndni, T, tref, Refe, fechn,  icbper, Mensaje);
			Values(registro1.Form, registro1.fecr, registro1.fech, registro1.Tdoc, registro1.Serie, registro1.Ndoc, ;
			  registro1.nruc, registro1.Razo, registro1.valorg, registro1.igvg, registro1.Exon, registro1.inafecta, registro1.Importe, registro1.pimpo, registro1.Detalle, ;
			  registro1.Mone, registro1.dola, registro1.Codigo, registro1.Idauto, registro1.ndni, Iif(Tdoc = '03', 1, 6), ntdoc, nndoc, nfech, ;
			  registro1.icbper, registro1.Mensaje)
		If notas = 1 Then
			Y = 1
			Select Xn
			Scan All
				If Y > 1 Then
					Insert Into registro(Form, fecr, fech, Tdoc, Serie, Ndoc, nruc, Razo, Auto, ndni, tref, Refe, fechn, dola, Mone);
						Values(registro1.Form, registro1.fecr, registro1.fech, registro1.Tdoc, registro1.Serie, registro1.Ndoc, ;
						  registro1.nruc, registro1.Razo, Xn.idn, registro1.ndni, Xn.Tdoc, Xn.Ndoc, Xn.fech, registro1.dola, registro1.Mone)
					x = x + 1
				Endif
				Y = Y + 1
			Endscan
			notas = 0
		Endif
		Select registro1
		x = x + 1
		totreg = totreg + 1
		nvalorp = nvalorp + registro1.valorg
		nexon = nexon + registro1.Exon
		nigvp = nigvp + registro1.igvg
		nimportep = nimportep + registro1.Importe
		Skip
	Enddo
	Go Top In registro
	Return 1
	Endfunc
	Function ventasxvendedorpsystr(Ccursor)
	f1 = Cfechas(This.fechai)
	f2 = Cfechas(This.fechaf)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
	\Select  a.kar_comi As comi, a.Idauto, e.Tdoc, e.Ndoc, e.fech, b.idart, a.cant, a.Prec, Round(a.cant * a.Prec, 2) As timporte,
	\e.Mone, a.alma, a.idart, b.idmar, c.nomv As nomb, e.Form,
	\e.vigv As igv, a.Codv, e.dolar As dola, b.Descri, b.Unid, d.Razo, m.dmar As marca, d.nruc, d.ndni, b.prod_cod1 From fe_rcom As e
	\inner Join fe_clie As d  On d.idclie = e.idcliente
	\Left Join fe_kar As a On a.Idauto = e.Idauto
	\Left Join fe_vend As c On c.idven = a.Codv
	\Left Join fe_art As  b On b.idart = a.idart
	\Left Join fe_mar As m On m.idmar = b.idmar
	\Where e.Acti <> 'I' And a.Acti <> 'I'  And e.fech  Between '<<f1>>' And '<<f2>>'
	If This.Vendedor > 0 Then
	      \ And a.Codv=<<This.Vendedor>>
	Endif
	      \Order By a.Codv,a.Idauto,e.Mone
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ventasxusuario(Ccursor)
	f1 = Cfechas(This.fechai)
	f2 = Cfechas(This.fechaf)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
	\Select  a.kar_comi As comi, a.Idauto, e.Tdoc, e.Ndoc, e.fech, b.idart, a.cant, a.Prec, Round(a.cant * a.Prec, 2) As timporte,
	\e.Mone, a.alma, a.idart, b.idmar, c.nomb, e.Form,
	\e.vigv As igv, e.idusua As Codv, e.dolar As dola, b.Descri, b.Unid, d.Razo, m.dmar As marca, d.nruc, d.ndni, b.prod_cod1 From fe_rcom As e
	\inner Join fe_clie As d  On d.idclie = e.idcliente
	\Left Join fe_kar As a On a.Idauto = e.Idauto
	\Left Join fe_usua As c On c.idusua = e.idusua
	\Left Join fe_art As  b On b.idart = a.idart
	\Left Join fe_mar As m On m.idmar = b.idmar
	\Where e.Acti <> 'I' And a.Acti <> 'I'  And e.fech  Between '<<f1>>' And '<<f2>>'
	If This.Vendedor > 0 Then
	      \ And e.idusua=<<This.Vendedor>>
	Endif
	      \Order By e.idusua,a.Idauto,e.Mone
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registroventasx5(Ccursor)
	f1 = Cfechas(This.fechai)
	f2 = Cfechas(This.fechaf)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
	\Select a.Form,a.fecr,a.fech,a.Tdoc,If(Length(Trim(a.Ndoc))<=10,Left(a.Ndoc,3),Left(a.Ndoc,4)) As Serie,
	\If(Length(Trim(a.Ndoc))<=10,mid(a.Ndoc,4,7),mid(a.Ndoc,5,8)) As Ndoc,
	\b.nruc,b.Razo,a.valor,ifnull(a.Exon,0) As Exon,a.igv,a.Impo As Importe,a.pimpo,a.Mone,a.dolar As dola,a.vigv,a.idcliente As Codigo,
	\a.Deta As Detalle,a.Idauto,b.ndni,rcom_mens As Mensaje From fe_rcom As a
	\Join fe_clie  As b On(b.idclie=a.idcliente)
	\Where fecr Between '<<f1>>' And '<<f2>>'  And Tdoc In('01','03','07','08') And Acti<>'I' And a.codt=<<nidalma>>
	If Len(Alltrim(This.Serie)) > 0 Then
	\And Left(a.Ndoc,4)='<<this.serie>>'
	Endif
    \Order By fecr,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Registroventas(Ccursor)
	f1 = Cfechas(This.fechai)
	f2 = Cfechas(This.fechaf)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To  Memvar lC Noshow
	\Select  a.Form,a.fecr,a.fech,a.Tdoc,Left(a.Ndoc,4) As Serie,
	\If(Length(Trim(a.Ndoc))<=10,mid(a.Ndoc,4,7),mid(a.Ndoc,5,8)) As Ndoc,
	\b.nruc,b.Razo,a.valor,rcom_exon As Exon,a.igv,a.Impo As Importe,rcom_otro As grati,a.pimpo,rcom_icbper As icbper,
	\a.Mone,a.dolar As dola,a.vigv,a.idcliente As Codigo,
	\a.Deta As Detalle,a.Idauto,b.ndni,rcom_mens As Mensaje,ifnull(p.fevto,a.fech) As fvto From fe_rcom As a
	\inner Join fe_clie  As b On(b.idclie=a.idcliente)
	\Left Join (Select rcre_idau,Min(c.fevto) As fevto From fe_rcred As r inner Join fe_cred As c On c.cred_idrc=r.rcre_idrc Where rcre_acti='A' And Acti='A' And fech Between '<<f1>>' And '<<f2>>' Group By rcre_idau)  As p On p.rcre_idau=a.Idauto
	\Where fech Between '<<f1>>' And '<<f2>>'  And Tdoc In('01','07','08','03') And Acti<>'I'
	If Len(Alltrim(This.Serie)) > 0 Then
	   \And Left(a.Ndoc,4)='<<this.serie>>'
	Endif
	If Len(Alltrim(This.Tdoc)) > 0 Then
    	\  And  a.Tdoc='<<this.tdoc>>'
	Endif
	If goApp.Cdatos = 'S' Then
	   \ And a.codt=<<goApp.tienda>>
	Endif
	\Order By fecr,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, 'facturas') < 1
		Return 0
	Endif
	nfilas = fe_gene.lrven
	Create Cursor registro(Form c(1) Null, fech d, fvto d, Tdoc c(2), Serie c(4), Ndoc c(8), nruc c(11)Null, ;
		  Razo c(40)Null, valor N(12, 2), Exon N(12, 2), igv N(10, 2), Importe N(12, 2), pimpo N(8, 2), ttip c(1), Mone c(1)Null, ;
		  dola N(6, 4), icbper N(6, 2), vigv N(5, 3), Codigo N(5), Detalle c(50), ndni c(8), Idauto N(8), fecr d, grati N(12, 2), Mensaje c(100))
	Select registro
	Append From Dbf("facturas")
	Select Form, fecr, fech, fvto, Tdoc, Serie, Ndoc, nruc, Razo, Iif(Mone = "D", Round((Importe * dola) / vigv, 2), valor) As valorg, ;
		Iif(Mone = "D", Round(Round(Importe * dola, 2) - Round((Importe * dola) / vigv, 2), 2), igv)As igvg, ;
		Iif(Mone = "D", Round((Exon * dola) / vigv, 2), Exon) As Exon, ;
		Iif(Mone = "D", Round(Importe * dola, 2), Importe) As Importe, ;
		Iif(Mone = 'D', Round(grati * dola, 2), grati) As tgrati, pimpo, Detalle, Mone, dola, Codigo, ndni, Idauto, vigv, icbper, Mensaje From registro Into Cursor registro1 Order By Serie, fech, Ndoc

	Create Cursor registro(Form c(1) Null, fech d Null, fvto d, Tdoc c(2) Null, Serie c(4), Ndoc c(8), nruc c(11)Null, Razo c(40)Null, valorg N(14, 2), Exon N(12, 2), ;
		  igvg N(10, 2), Importe N(14, 2), tgrati N(12, 2), igvgr N(12, 2), Detalle c(50), icbper N(12, 2), tref c(2), Refe c(12), dola N(5, 3), Mensaje c(100), Mone c(1), Codigo N(5), fechn d, fevto d, ;
		  Auto N(15), ndni c(8), T N(1), fecr d Null, pimpo N(8, 2), inafecta N(12, 2))
	x = 1
	If This.Listarnotascreditoydebito("xnotas") < 1 Then
		Return 0
	Endif
	notas = 0
	Select registro1
	Go Top
	Do While !Eof()
		nidn = registro1.Idauto
		ntdoc = '00'
		nndoc = '            '
		nfech = Ctod("  /  /    ")
		If registro1.Tdoc = '07' Or registro1.Tdoc = '08' Then
			NAuto = registro1.Idauto
			Select * From xnotas Where ncre_idan = NAuto Into Cursor Xn
			notas = 1
			nidn = Xn.idn
			ntdoc = Xn.Tdoc
			nndoc = Xn.Ndoc
			nfech = Xn.fech
		Endif
		Insert Into registro(Form, fecr, fech, fvto, Tdoc, Serie, Ndoc, nruc, Razo, valorg, igvg, Exon, Importe, pimpo, Detalle, Mone, dola, Codigo, Auto, ndni, T, tref, Refe, fechn, tgrati, igvgr, icbper, Mensaje);
			Values(registro1.Form, registro1.fecr, registro1.fech, registro1.fvto, registro1.Tdoc, registro1.Serie, registro1.Ndoc, ;
			  registro1.nruc, registro1.Razo, registro1.valorg, registro1.igvg, registro1.Exon, registro1.Importe, registro1.pimpo, registro1.Detalle, ;
			  registro1.Mone, registro1.dola, registro1.Codigo, registro1.Idauto, registro1.ndni, Iif(Tdoc = '03', 1, 6), ntdoc, nndoc, nfech, ;
			  registro1.tgrati, Round(registro1.tgrati * (registro1.vigv - 1), 2), registro1.icbper, registro1.Mensaje)
		If notas = 1 Then
			Y = 1
			Select Xn
			Scan All
				If Y > 1 Then
					Insert Into registro(Form, fecr, fech, Tdoc, Serie, Ndoc, nruc, Razo, Auto, ndni, tref, Refe, fechn, dola, Mone);
						Values(registro1.Form, registro1.fecr, registro1.fech, registro1.Tdoc, registro1.Serie, registro1.Ndoc, ;
						  registro1.nruc, registro1.Razo, Xn.idn, registro1.ndni, Xn.Tdoc, Xn.Ndoc, Xn.fech, registro1.dola, registro1.Mone)
					x = x + 1
					totreg = totreg + 1
				Endif
				Y = Y + 1
			Endscan
			notas = 0
		Endif
		Select registro1
		x = x + 1
		totreg = totreg + 1
		nvalorp = nvalorp + registro1.valorg
		nexon = nexon + registro1.Exon
		nigvp = nigvp + registro1.igvg
		nimportep = nimportep + registro1.Importe
		Skip
	Enddo
	Return 1
	Endfunc
	Function Registroventasxsysg(Ccursor)
	f1 = Cfechas(This.fechai)
	f2 = Cfechas(This.fechaf)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To  Memvar lC Noshow
	\Select a.Form,a.fecr,a.fech,a.Tdoc,If(Length(Trim(a.Ndoc))<=10,Left(a.Ndoc,3),Left(a.Ndoc,4)) As Serie,
	\If(Length(Trim(a.Ndoc))<=10,mid(a.Ndoc,4,7),mid(a.Ndoc,5,8)) As Ndoc,
	\b.nruc,b.Razo,a.valor,rcom_exon As Exon,a.igv,a.Impo As Importe,a.pimpo,rcom_otro As grati,a.Mone,a.dolar As dola,a.vigv,a.idcliente As Codigo,
	\a.Deta As Detalle,a.Idauto,b.ndni,u.nomb As Usuario,FUsua,rcom_icbper,rcom_mens,codt From fe_rcom As a
	\inner Join fe_clie  As b On(b.idclie=a.idcliente)
	\inner Join fe_usua As u On u.idusua=a.idusua
	\ Where fech Between '<<f1>>' And '<<f2>>'  And Tdoc In('01','07','08','03') And Acti<>'I'
	If Len(Alltrim(This.Serie)) > 0 Then
	   \And Left(a.Ndoc,4)='<<this.serie>>'
	Endif
	If Len(Alltrim(This.Tdoc)) > 0 Then
    	\  And  a.Tdoc='<<this.tdoc>>'
	Endif
	\Order By fecr,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, 'facturas') < 1
		Return 0
	Endif
	If This.Listarnotascreditoydebito('xnotas') < 1 Then
		Return 0
	Endif
	Create Cursor registro(Form c(1) Null, fecr d, fech d, Tdoc c(2), Serie c(4), Ndoc c(8), nruc c(11)Null, ;
		  Razo c(40)Null, valor N(14, 2), Exon N(12, 2), igv N(14, 2), Importe N(14, 2), pimpo N(8, 2), grati N(10, 2), ttip c(1), Mone c(1)Null, ;
		  dola N(6, 4), vigv N(5, 3), Codigo N(5), Detalle c(50), Usuario c(30), FUsua T, Mensaje c(120), ndni c(8), Idauto N(8), rcom_icbper N(8, 2), rcom_mens c(120), codt N(2))
	Select registro
	Append From Dbf("facturas")
	Select Icase(Form = 'E', 'Ef',   Form = 'C', 'Cr',   Form = 'D', 'Dp',  Form = 'H', 'Ch', 'OT') As Form, ;
		fecr, fech, Tdoc, Serie, Ndoc, nruc, Razo, Iif(Mone = "D", Round((Importe * dola) / vigv, 2), valor) As valorg, ;
		Iif(Mone = "D", Round(Round(Importe * dola, 2) - Round((Importe * dola) / vigv, 2), 2), igv)As igvg, ;
		Iif(Mone = "D", Round(Exon * dola, 2), Exon) As Exon, ;
		Iif(Mone = "D", Round(Importe * dola, 2), Importe) As Importe, pimpo, ;
		Iif(Mone = 'D', Round(grati * dola, 2), grati) As grati, ;
		Detalle, Mone, dola, Codigo, ndni, Idauto, Usuario, FUsua, rcom_icbper As icbper, rcom_mens As Mensaje, codt From registro Into Cursor registro1 Order By Serie, fecr, Ndoc
	Create Cursor registro(Form c(2) Null, fecr d Null, fech d Null, Tdoc c(2) Null, Serie c(4), Ndoc c(8), nruc c(11)Null, Razo c(100)Null, valorg N(14, 2), Exon N(12, 2), ;
		  igvg N(10, 2), Importe N(14, 2), pimpo N(8, 2), grati N(10, 2), Detalle c(50), Usuario c(30), FUsua T, Mensaje c(120), dola N(5, 3), Mone c(1), Codigo N(5), fechn d, tref c(2), Refe c(12), fevto d, Auto N(15), ndni c(8), ;
		  T N(1), inafecta N(12, 2), icbper N(8, 2), codt N(2))
	x = 1
	notas = 0
	Select registro1
	Go Top
	Do While !Eof()
		nidn = registro1.Idauto
		ntdoc = '00'
		nndoc = '            '
		nfech = Ctod("  /  /    ")
		If registro1.Tdoc = '07' Or registro1.Tdoc = '08' Then
			NAuto = registro1.Idauto
			Select * From xnotas Where ncre_idan = NAuto Into Cursor Xn
			notas = 1
			nidn = Xn.idn
			ntdoc = Xn.Tdoc
			nndoc = Xn.Ndoc
			nfech = Xn.fech
		Endif
		Insert Into registro(Form, fecr, fech, Tdoc, Serie, Ndoc, nruc, Razo, valorg, igvg, Exon, Importe, pimpo, Detalle, Mone, dola, Codigo, Auto, ndni, T, tref, Refe, fechn, Usuario, FUsua, icbper, Mensaje, codt, grati);
			Values(registro1.Form, registro1.fecr, registro1.fech, registro1.Tdoc, registro1.Serie, registro1.Ndoc, ;
			  registro1.nruc, registro1.Razo, registro1.valorg, registro1.igvg, registro1.Exon, registro1.Importe, registro1.pimpo, registro1.Detalle, ;
			  registro1.Mone, registro1.dola, registro1.Codigo, registro1.Idauto, registro1.ndni, Iif(Tdoc = '03', 1, 6), ntdoc, nndoc, nfech, registro1.Usuario, registro1.FUsua, ;
			  registro1.icbper, registro1.Mensaje, registro1.codt, registro1.grati)
		If notas = 1 Then
			Y = 1
			Select Xn
			Scan All
				If Y > 1 Then
					Insert Into registro(Form, fecr, fech, Tdoc, Serie, Ndoc, nruc, Razo, Auto, ndni, tref, Refe, fechn, dola, Mone);
						Values(registro1.Form, registro1.fecr, registro1.fech, registro1.Tdoc, registro1.Serie, registro1.Ndoc, ;
						  registro1.nruc, registro1.Razo, Xn.idn, registro1.ndni, Xn.Tdoc, Xn.Ndoc, Xn.fech, registro1.dola, registro1.Mone)
					x = x + 1
					totreg = totreg + 1
				Endif
				Y = Y + 1
			Endscan
			notas = 0
		Endif
		Select registro1
		x = x + 1
		totreg = totreg + 1
		nvalorp = nvalorp + registro1.valorg
		nexon = nexon + registro1.Exon
		nigvp = nigvp + registro1.igvg
		nimportep = nimportep + registro1.Importe
		Skip
	Enddo
	Return 1
	Endfunc
	Function Listarnotascreditoydebito(Ccursor)
	f1 = Cfechas(This.fechai)
	f2 = Cfechas(This.fechaf)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lC Noshow Textmerge
       select a.ndoc,a.tdoc,a.fech,b.ncre_idnc as idn,ncre_idan FROM (select ncre_idnc,ncre_idau,ncre_idan from fe_ncven as n
       INNER JOIN fe_rcom AS r ON r.idauto=n.`ncre_idan`
       where  r.fech BETWEEN '<<f1>>'  AND '<<f2>>'  AND r.acti='A' and ncre_acti='A' ) as b
       INNER JOIN fe_rcom as a on a.idauto=b.ncre_idau
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listardctosnotasdecreditoproductosyservicios(nid, Ccursor)
	Text To lC Noshow Textmerge Pretext 7
	    select a.idart,a.descri,a.unid,k.cant,k.prec,
		ROUND(k.cant*k.prec,2) as importe,k.idauto,r.mone,r.valor,r.igv,r.impo,kar_comi as comi,k.alma,
		r.fech,r.ndoc,r.tdoc,r.dolar as dola,r.vigv,r.rcom_exon,'K' as tcom,k.idkar,if(k.prec=0,kar_cost,0) as costoref,kar_cost as costo,k.codv
		from fe_rcom r
		inner join fe_kar k on k.idauto=r.idauto
		inner join fe_art a on a.idart=k.idart
		where k.acti='A' and r.acti='A' and r.idauto=<<nid>>
		union all
		SELECT cast(0 as unsigned) as idart,k.detv_desc as descri,'.' as unid,k.detv_cant as cant,k.detv_prec as prec,
		ROUND(k.detv_cant*k.detv_prec,2) as importe,r.idauto,r.mone,r.valor,r.igv,r.impo,cast(0 as unsigned) as comi,
		cast(1 as unsigned) as alma,r.fech,r.ndoc,r.tdoc,r.dolar as dola,r.vigv,r.rcom_exon,'S' as tcom,detv_idvt as idkar,
		CAST(0 as decimal(6,2)) as costRef,
		CAST(0 as decimal(12,2)) as costo,CAST(0 as decimal(2)) as codv from fe_rcom r
		inner join fe_detallevta k on k.detv_idau=r.idauto
		where k.detv_acti='A' and r.acti='A' and r.idauto=<<nid>>  order by idkar
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function AnularXsys()
	Text To lC Noshow  Textmerge
	 DELETE from fe_rven WHERE idalma=<<this.codt>> and MONTH(fech)=<<this.nmes>> and YEAR(fech)=<<this.na�o>>
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarxidpsysr(niDAUTO, Ccursor)
	Text To lC Noshow Textmerge
		SELECT   `a`.`kar_comi`  AS `kar_comi`,  `a`.`codv`      AS `codv`,  `a`.`idauto`    AS `idauto`,  `c`.`codt`      AS `alma`,
	  `a`.`kar_idco`  AS `idcosto`,  `a`.`idkar`     AS `idkar`,  `a`.`idart` ,  `a`.`cant`      AS `cant`,
	  `a`.`prec`      AS `prec`,  `c`.`valor`     AS `valor`,  `c`.`igv`       AS `igv`,  `c`.`impo`      AS `impo`,
	  `c`.`fech`      AS `fech`,  `c`.`fecr`      AS `fecr`,  `c`.`rcom_dsct` AS `rcom_dsct`,  `c`.`rcom_mens` AS `rcom_mens`,
	  `c`.`form`      AS `form`,  `c`.`deta`      AS `deta`,  `c`.`exon`      AS `exon`,  `c`.`ndo2`      AS `ndo2`,
	  `c`.`rcom_entr` AS `rcom_entr`,  `c`.`idcliente` AS `idclie`,  `d`.`razo`      AS `razo`,  `d`.`nruc`      AS `nruc`,
	  `d`.`dire`      AS `dire`,  `d`.`ciud`      AS `ciud`,  `d`.`ndni`      AS `ndni`,  `a`.`tipo`      AS `tipo`,
	  `c`.`tdoc`      AS `tdoc`,  `c`.`ndoc`      AS `ndoc`,  `c`.`dolar`     AS `dolar`,  `c`.`mone`      AS `mone`,
	  `b`.`descri`    AS `descri`,  IFNULL(`x`.`idcaja`,0) AS `idcaja`,  `b`.`unid`      AS `unid`,  `b`.`premay`    AS `pre1`,
	  `b`.`peso`      AS `peso`,  `b`.`premen`    AS `pre2`,  IFNULL(`z`.`vend_idrv`,0) AS `nidrv`,
	  `c`.`vigv`      AS `vigv`,  `a`.`dsnc`      AS `dsnc`,  `a`.`dsnd`      AS `dsnd`,  `a`.`gast`      AS `gast`,
	  `c`.`idcliente` AS `idclie`,  `c`.`codt`      AS `codt`,  IFNULL(b.pre3,0) AS pre3,  `b`.`cost`      AS `costo`,
	  `b`.`uno`       AS `uno`,  `b`.`dos`       AS `dos`,  b.tre,  (((((`b`.`uno` + `b`.`dos`) + `b`.`sei`) + `b`.`cin`) + `b`.`cua`) + `b`.`nue`) AS `TAlma`,
	  `b`.`sei`       AS `sei`,  `b`.`cua`       AS `cua`,  `b`.`cin`       AS `cin`,  b.sie,b.och,
	  `b`.`nue`       AS `nue`,  b.die,  `a`.`kar_codi`  AS `kar_codi`,  `c`.`fusua`     AS `fusua`,IFNULL(p.fevto,c.fech) AS fvto,
	  `p`.`nomv`      AS `Vendedor`,  `q`.`nomb`      AS `Usuario`,  `b`.`tipro`     AS `tipro`,  `c`.`rcom_mret` AS `rcom_mret`,
	  `c`.`rcom_mdet` AS `rcom_mdet`
	FROM `fe_rcom` `c`
	    JOIN `fe_kar` `a`            ON `a`.`idauto` = `c`.`idauto`
	    JOIN `fe_art` `b`          ON `b`.`idart` = `a`.`idart`
		LEFT JOIN `fe_caja` `x`         ON `x`.`idauto` = `c`.`idauto`
		JOIN `fe_clie` `d`        ON `c`.`idcliente` = `d`.`idclie`
		JOIN `fe_vend` `p`       ON `p`.`idven` = `a`.`codv`
		JOIN `fe_usua` `q`      ON `q`.`idusua` = `c`.`idusua`
	    LEFT JOIN (SELECT    `fe_rvendedor`.`vend_idau` AS `vend_idau`,   `fe_rvendedor`.`vend_idrv` AS `vend_idrv`
	              FROM `fe_rvendedor`
	              WHERE `fe_rvendedor`.`vend_acti` = 'A' )`z`      ON `z`.`vend_idau` = `c`.`idauto`
	    LEFT JOIN (SELECT rcre_idau,MIN(c.fevto) AS fevto FROM fe_rcred AS r INNER JOIN fe_cred AS c ON c.cred_idrc=r.rcre_idrc
	   WHERE rcre_acti='A' AND acti='A' AND rcre_idau=<<nidauto>> GROUP BY rcre_idau) AS p ON p.rcre_idau=c.idauto
	WHERE `c`.`tipom` = 'V'       AND `c`.`acti` <> 'I' AND c.idauto=<<nidauto>>    AND `a`.`acti` <> 'I'
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaDocumentoElectronicocondetraccionconanticipocod(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25, np26, np27)
	Local lC, lp
*:Global cur
	lC			  = 'FuningresaDocumentoElectronicocondetraccion'
	cur			  = "Xn"
	goApp.npara1  = np1
	goApp.npara2  = np2
	goApp.npara3  = np3
	goApp.npara4  = np4
	goApp.npara5  = np5
	goApp.npara6  = np6
	goApp.npara7  = np7
	goApp.npara8  = np8
	goApp.npara9  = np9
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
	Text To lp Noshow
    (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26,?goapp.npara27)
	Endtext
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1  Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function ActualizaResumenDctoVtasdetraccioncod(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25, np26)
	lC = 'ProActualizaCabeceracvtasdetraccion'
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
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26)
	Endtext
	If This.EJECUTARP(lC, lp, "") < 1  Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function Validarovtas()
	Do Case
	Case This.Vendedor = 0
		This.Cmensaje = "Seleccione Un Vendedor"
		Return 0
	Case Len(Alltrim(This.Serie)) < 3 Or Len(Alltrim(This.numero)) < 7
		This.Cmensaje = "Ingrese un N� de Documento V�lido"
		Return 0
	Case Year(This.Fecha) <> Val(goApp.a�o) Or !esfechaValida(This.Fecha)
		This.Cmensaje = "Fecha No V�lida No permitida por el Sistema"
		Return 0
	Case Empty(This.Codigo)
		This.Cmensaje = "Seleccione Un Cliente"
		Return 0
	Case  PermiteIngresox(This.Fecha) = 0
		This.Cmensaje = "No Es posible Registrar en esta Fecha estan bloqueados Los Ingresos"
		Return 0
	Case This.Encontrado  = 'V' And TieneKardex(This.Nreg) = 0
		This.Cmensaje = "Este Documento Tiene Movimientos Relacionados con el Kardex...Utilice por la Opci�n ACTUALIZAR VENTAS"
		Return 0
	Case Empty(This.Tdoc)
		This.Cmensaje = "Seleccione Un Tipo de Documento"
		Return 0
	Case Len(Alltrim(This.coddetraccion)) = 0 And This.detraccion > 0
		This.Mensaje = "Es Obligatorio el C�digo de Detraccion"
		Return 0
	Case This.detraccion = 0 And  Len(Alltrim(This.coddetraccion)) = 0
		This.Cmensaje = "Ingrese el Importe de Detracci�n"
		Return 0
	Case Left(This.rptaSunat, 1) = "0"
		This.Mensaje = "Este Documento Electr�nico Ya esta Informado a SUNAT"
		Return 0
	Case This.Tdoc = "01" And !ValidaRuc(This.Ruc)
		This.Cmensaje = "Ingrese RUC del Cliente V�lido"
		Return 0
	Case This.Tdoc = "03" And This.Monto >= 700 And Len(Alltrim(This.dni)) < 8
		This.Cmensaje = "Ingrese DNI del Cliente"
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function listarotrasvtasxml(Ccursor)
	If !Pemstatus(goApp, 'vtasconanticipo', 5) Then
		AddProperty(goApp, 'vtasconanticipo', '')
	Endif
	Set Textmerge  On
	Set Textmerge To Memvar lcx Noshow  Textmerge
	  \Select  r.Idauto,r.Ndoc,r.Tdoc,r.fech As dFecha,r.Mone,r.valor,Cast(0 As Decimal(12,2)) As inafectas,r.rcom_otro As gratificaciones,
      \r.rcom_exon As exoneradas,'10' As tigv,r.vigv,v.rucfirmad,v.razonfirmad,r.ndo2,v.nruc As rucempresa,v.empresa,v.ubigeo,
      \Cast(0 As Decimal(5,2)) As costoref,r.Deta,ifnull(s.codigoestab,'0000') As codigoestab,
      \v.ptop,v.ciudad,v.distrito,c.nruc,'6' As tipodoc,c.Razo,Concat(Trim(c.Dire),' ',Trim(c.ciud)) As Direccion,c.ndni,
      \'PE' As pais,r.igv,Cast(0 As Decimal(12,2)) As Tdscto,Cast(0 As Decimal(12,2)) As Tisc,r.Impo,Cast(0 As Decimal(12,2)) As montoper,'I' As Incl,
      \Cast(0 As Decimal(12,2)) As totalpercepcion,k.detv_cant As cant,k.detv_prec As Prec,
      \Left(r.Ndoc,4) As Serie,Substr(r.Ndoc,5) As numero,ifnull(unid_codu,'NIU')As Unid,detv_unid As unid1,detv_desc As Descri,detv_ite2 As Coda,r.Form,r.rcom_detr,k.detv_prec As precioo
	If goApp.Vtasconanticipo = 'S' Then
		\,ifnull(z.Ndoc,'') As dctoanticipo,ifnull(z.Impo,Cast(0 As Decimal(10,2))) As totalanticipo,
		\ifnull(If(z.rcom_exon>0,z.rcom_exon,z.valor),Cast(0 As Decimal(10,2))) As valorganticipo
	Endif
	If This.Condetraccion = 'S' Then
         \,r.rcom_mdet
	Endif
	If This.Proyecto = 'xsysr' Then
         \,r.rcom_vref As valorref
	Else
         \,Cast(0 As Decimal(12,2)) As valorref
	Endif
      \From fe_rcom r
      \inner Join fe_clie c On c.idclie=r.idcliente
      \inner Join fe_detallevta k On k.detv_idau=r.Idauto
      \Left Join fe_sucu s On s.idalma=r.codt
      \Left Join fe_unidades As u On u.unid_codu=k.detv_unid
	If goApp.Vtasconanticipo = 'S' Then
	  \Left Join fe_rcom As z On z.Idauto=r.rcom_idan
	Endif
	\,fe_gene As v
      \Where r.Idauto=<<This.Idauto>> And r.Acti='A' And detv_item>0 And detv_acti='A'
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lcx, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarvtasxml(Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select r.Idauto,r.Ndoc,r.Tdoc,r.fech As dFecha,r.Mone,valor,Cast(0 As Decimal(12,2)) As inafectas,Cast(0 As Decimal(12,2)) As gratificaciones,
	\      Cast(0 As Decimal(12,2)) As exoneradas,'10' As tigv,vigv,v.rucfirmad,v.razonfirmad,ndo2,v.nruc As rucempresa,v.empresa,v.ubigeo,
	\      v.ptop,v.ciudad,v.distrito,c.nruc,'6' As tipodoc,c.Razo,Concat(Trim(c.Dire),' ',Trim(c.ciud)) As Direccion,c.ndni,rcom_otro,kar_cost As costoref,Deta,
	\      'PE' As pais,r.igv,Cast(0 As Decimal(12,2)) As Tdscto,Cast(0 As Decimal(12,2)) As Tisc,Impo,Cast(0 As Decimal(12,2)) As montoper,k.Incl,
	\     Cast(0 As Decimal(12,2)) As totalpercepcion,k.cant,k.Prec,Left(r.Ndoc,4) As Serie,Substr(r.Ndoc,5) As numero,a.Unid,a.Descri,k.idart As Coda,
	\      ifnull(unid_codu,'NIU')As unid1,s.codigoestab,r.Form
	If This.Conretencion = 'S' Then
	\,rcom_mret
	Endif
	\      From fe_rcom r
	\      inner Join fe_clie c On c.idclie=r.idcliente
	\      inner Join fe_kar k On k.Idauto=r.Idauto
	\      inner Join fe_art a On a.idart=k.idart
	\      inner Join fe_sucu s On s.idalma=r.codt
	\      Left Join fe_unidades As u On u.unid_codu=a.Unid, fe_gene As v
	\      Where r.Idauto=<<This.Idauto>> And r.Acti='A' And k.Acti='A'
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function buscarvcentaxidpsysm(niDAUTO, Ccursor)
	Text To lC Noshow Textmerge
	  SELECT  c.idusua      AS idusua,  a.kar_comi    AS kar_comi,
	  a.codv        AS codv,  a.idauto      AS idauto,  c.codt        AS alma,  a.kar_perc    AS kar_perc,
	  a.kar_idco    AS idcosto,  a.idkar       AS idkar,  a.idart,  a.cant        AS cant,
	  a.prec        AS prec,  c.valor       AS valor,  c.igv         AS igv,  c.impo        AS impo,
	  c.fech        AS fech,  c.fecr        AS fecr,  c.form        AS form,  c.deta        AS deta,
	  c.exon        AS exon,  c.ndo2        AS ndo2,  c.rcom_entr   AS rcom_entr,  c.idcliente   AS idclie,
	  d.razo        AS razo,  d.nruc        AS nruc,  d.dire        AS dire,  d.ciud        AS ciud,
	  d.ndni        AS ndni,  a.tipo        AS tipo,  c.tdoc        AS tdoc,  c.ndoc        AS ndoc,
	  c.dolar       AS dolar,  c.mone        AS mone,  b.descri      AS descri,  0                 AS idcaja,
	  b.unid        AS unid,  b.premay      AS pre1,  b.peso        AS peso,  b.premen      AS pre2,
	  CAST(0 AS DECIMAL(4,2)) AS nidrv,  c.vigv        AS vigv,  a.dsnc        AS dsnc,  a.dsnd        AS dsnd,
	  a.gast        AS gast,  c.codt        AS codt,  b.pre3        AS pre3,
	  b.cost        AS costo,  b.uno         AS uno,  b.dos         AS dos,  b.uno + b.dos AS TAlma,
	  c.fusua       AS fusua,  p.nomv        AS Vendedor,  q.nomb        AS Usuario,  c.rcom_icbper AS rcom_icbper,  a.kar_icbper  AS kar_icbper,
	  c.rcom_mens   AS rcom_mens,rcom_mdet,rcom_detr,ifnull(p.fevto,c.fech) as fvto
	  FROM fe_rcom as c
	  JOIN fe_kar a   on a.idauto=c.idauto
	  JOIN fe_art b   ON b.idart = a.idart
	  JOIN fe_clie d  ON c.idcliente = d.idclie
	  JOIN fe_vend p  ON p.idven = a.codv
	  JOIN fe_usua q  ON q.idusua = c.idusua
	  left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r
      inner join fe_cred as c on c.cred_idrc=r.rcre_idrc
      where rcre_acti='A' and acti='A' and rcre_idau=<<nidauto>> group by rcre_idau) as p on p.rcre_idau=a.idauto
	  WHERE c.acti <> 'I'    and c.idauto=<<nidauto>>  AND a.acti <> 'I'
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarventaxidxsysz(niDAUTO, Ccursor)
	Text To lC Noshow Textmerge
	  SELECT c.rcom_mens   AS rcom_mens,  c.idusua      AS idusua,  a.kar_comi    AS kar_comi,
	  a.codv        AS codv,  a.idauto      AS idauto,  a.alma        AS alma,  a.kar_idco    AS idcosto,
	  a.idkar       AS idkar,  a.idart, a.cant        AS cant,  a.prec        AS prec,
	  c.valor       AS valor,  c.igv         AS igv,  c.impo        AS impo,  c.fech        AS fech,
	  c.fecr        AS fecr,  c.form        AS form,  c.deta        AS deta,  c.exon        AS exon,
	  c.ndo2        AS ndo2,  c.rcom_entr   AS rcom_entr,  c.idcliente   AS idclie,
	  d.razo        AS razo,  d.nruc        AS nruc,  d.dire        AS dire,  d.ciud        AS ciud,
	  d.ndni        AS ndni,  a.tipo        AS tipo,  c.tdoc        AS tdoc,  c.ndoc        AS ndoc,
	  c.dolar       AS dolar,  c.mone        AS mone,  b.descri      AS descri,
	  b.unid        AS unid,  b.pre1        AS pre1,  b.peso        AS peso,  b.pre2        AS pre2,  IFNULL(z.vend_idrv,0) AS nidrv,
	  c.vigv        AS vigv,  a.dsnc        AS dsnc,  a.dsnd        AS dsnd,  a.gast        AS gast,
	  c.codt        AS codt,  b.pre3        AS pre3,  b.cost        AS costo,  b.tre         AS tre,  b.uno        AS uno,
	  b.dos         AS dos,  (b.uno + b.dos) AS TAlma,  c.fusua       AS fusua,  p.nomv        AS Vendedor,
	  q.nomb        AS Usuario,  c.rcom_idtr   AS rcom_idtr,  c.rcom_tipo   AS rcom_tipo,  c.rcom_icbper AS rcom_icbper,
	  a.kar_icbper  AS kar_icbper,  c.rcom_vtar   AS rcom_vtar
	  FROM fe_rcom c
	  JOIN fe_kar a        ON a.idauto = c.idauto
	  JOIN vlistaprecios b  ON b.idart = a.idart
	  JOIN fe_clie d         ON d.idclie = c.idcliente
	  LEFT JOIN fe_vend p    ON p.idven = a.codv
	  JOIN fe_usua q    ON q.idusua = c.idusua
	  LEFT JOIN (SELECT fe_rvendedor.vend_idau AS vend_idau, fe_rvendedor.vend_idrv AS vend_idrv FROM fe_rvendedor WHERE fe_rvendedor.vend_acti = 'A') z   ON z.vend_idau = c.idauto
	  WHERE c.acti <> 'I'  AND a.acti <> 'I' and c.idauto=<<nidauto>> order by idkar
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registrarxservicios()
	Set Procedure To d:\capass\modelos\correlativos Additive
	ocorr = Createobject("correlativo")
	If This.IniciaTransaccion() < 1  Then
		Return 0
	Endif
	If goApp.vtascondetraccion = 'S' Then
		NAuto = IngresaResumenDctovtascondetraccion(This.Tdoc, Left(This.formaPago, 1), This.Serie + This.numero, This.Fecha, This.Fecha, ;
			  This.Detalle, This.valor, This.igv, This.Monto, '', Left(This.Moneda, 1), ;
			  This.ndolar, This.vigv, 'S', This.Codigo, "V", goApp.nidusua, This.Vendedor, This.codt, This.cta1, This.cta2, This.cta3, This.exonerado, This.detraccion, This.coddetraccion)
	Else
		NAuto = IngresaDocumentoElectronico(This.Tdoc, Left(This.formaPago, 1), This.Serie + This.numero, This.Fecha, This.Detalle, This.valor, This.igv, This.Monto, "", ;
			  Left(This.Moneda, 1), This.ndolar, This.vigv, 'S', This.Codigo, "V", goApp.nidusua, This.codt, This.cta1, This.cta2, This.cta3, This.Vendedor, 0, This.exonerado, 0)
	Endif
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If IngresaDatosLCajaEFectivo12(This.Fecha, "", This.clienteseleccionado, This.cta3, This.Monto, 0, 'S', fe_gene.dola, goApp.nidusua, This.Codigo, NAuto, Left(This.formaPago, 1), This.Serie + This.numero, This.Tdoc, goApp.Tienda) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If Left(This.formaPago, 1) = 'C' Then
		Vdvto = IngresaCreditosNormal(NAuto, This.Codigo, This.Serie + This.numero, 'C', Left(This.Moneda, 1), This.Detalle, This.Fecha, This.Fechavto, Left(This.tipodcto, 1), This.Serie + This.numero, This.Monto, 0, This.Vendedor, This.Monto, goApp.nidusua, This.codt, Id())
		If Vdvto < 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	Select tmpv
	Go Top
	Scan All
		If IngresaDetalleVTaCunidad(tmpv.Desc, tmpv.Nitem, tmpv.nitem1, tmpv.nitem2, NAuto, tmpv.Prec, tmpv.cant, tmpv.Unid) = 0 Then
			Sw = 0
			Exit
		Endif
	Endscan
	If  Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	ocorr.Idserie = This.Idserie
	ocorr.Nsgte = This.Nsgte
	If ocorr.GeneraCorrelativo1() < 1 Then
		This.Cmensaje = ocorr.Cmensaje
		Return 0
	Endif
	If This.GRabarCambios() < 1  Then
		Return 0
	Endif
	Return NAuto
	Endfunc
	Function actualizarxservicios()
	cndoc = This.Serie + This.numero
	If This.IniciaTransaccion() < 1  Then
		Return 0
	Endif
	If goApp.vtascondetraccion = 'S' Then
		If ActualizaResumenDctovtascondetraccion(This.Tdoc, Left(This.formaPago, 1), cndoc, This.Fecha, This.Fecha, This.Detalle, This.valor, This.igv, This.Monto, "", Left(This.Moneda, 1), ;
				  This.ndolar, This.vigv, 'S', This.Codigo, "V", goApp.nidusua, This.Vendedor, This.codt, This.cta1, This.cta2, This.cta3, This.exonerado, 0, This.detraccion, This.Idauto, This.coddetraccion) < 1 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Else
		If ActualizaResumenDctoVtas(This.Tdoc, Left(This.formaPago, 1), cndoc, This.Fecha, This.Detalle, This.valor, This.igv, This.Monto, "", Left(This.Moneda, 1), ;
				  This.ndolar, This.vigv, 'S', This.Codigo, 'V', goApp.nidusua, 0, This.codt, This.cta1, This.cta2, This.cta3, This.exonerado, 0, This.Idauto, This.Vendedor) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If ActualizaCreditos(This.Idauto, goApp.nidusua) = 0
		This.DEshacerCambios()
		Return 0
	Endif
	If IngresaDatosLCajaEFectivo12(This.Fecha, "", This.clienteseleccionado, This.cta3, This.Monto, 0, 'S', fe_gene.dola, goApp.nidusua, This.Codigo, This.Idauto, Left(This.formaPago, 1), This.Serie + This.numero, This.Tdoc, goApp.Tienda) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If Left(This.formaPago, 1) = 'C' Then
		Vdvto = IngresaCreditosNormal(This.Idauto, This.Codigo, This.Serie + This.numero, 'C', Left(This.Moneda, 1), This.Detalle, This.Fecha, This.Fechavto, Left(This.tipodcto, 1), This.Serie + This.numero, This.Monto, 0, This.Vendedor, This.Monto, goApp.nidusua, This.codt, Id())
		If Vdvto < 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If ActualizaDetalleVTa(This.Idauto) = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpv
	Go Top
	Scan All
		If IngresaDetalleVTaCunidad(tmpv.Desc, tmpv.Nitem, tmpv.nitem1, tmpv.nitem2, This.Idauto, tmpv.Prec, tmpv.cant, tmpv.Unid) = 0 Then
			Sw = 0
			Exit
		Endif
	Endscan
	If  Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listardctonotascredtitoproductosserviciosUnidades(nid, Ccursor)
	Text To lC Noshow Textmerge
	  SELECT a.idart,a.descri,a.unid,k.cant,k.prec,ROUND(k.cant*k.prec,2) AS importe,
	    k.idauto,r.mone,r.valor,r.igv,r.impo,kar_comi AS comi,k.alma,
		r.fech,r.ndoc,r.tdoc,r.dolar AS dola,r.vigv,r.rcom_exon,tcom,k.idkar,IF(k.prec=0,kar_cost,0) AS costoref,
		kar_equi,prod_cod1,kar_cost,codv FROM fe_rcom r
		INNER JOIN fe_kar k ON k.idauto=r.idauto
		INNER JOIN fe_art a ON a.idart=k.idart
		WHERE k.acti='A' AND r.acti='A' AND r.idauto=<<nid>>
		UNION ALL
		SELECT CAST(0 AS UNSIGNED) AS idart,k.detv_desc AS descri,'.' AS unid,k.detv_cant AS cant,k.detv_prec AS prec,
		ROUND(k.detv_cant*k.detv_prec,2) AS importe,r.idauto,r.mone,r.valor,r.igv,r.impo,CAST(0 AS UNSIGNED) AS comi,
		CAST(1 AS UNSIGNED) AS alma,r.fech,r.ndoc,r.tdoc,r.dolar AS dola,r.vigv,r.rcom_exon,'S' AS tcom,detv_idvt AS idkar,
		CAST(0 AS DECIMAL(6,2)) AS costRef,CAST(0 as decimal) AS kar_equi,'' AS prod_cod1,CAST(0 AS DECIMAL(10,2))kar_cost,CAST(0 AS DECIMAL) AS codv
		FROM fe_rcom r
		INNER JOIN fe_detallevta k ON k.detv_idau=r.idauto
		WHERE k.detv_acti='A' AND r.acti='A' AND r.idauto=<<nid>> ORDER BY idkar
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function consultardetalleoventasxml(pk, ncoda)
	Obj = Createobject("custom")
	Text To lC Noshow Textmerge
	SELECT detv_desc FROM fe_detallevta WHERE detv_idau=<<pk>> AND detv_ite2=<<ncoda>> and detv_acti='A' order BY detv_idvt
	Endtext
	If This.EJECutaconsulta(lC, 'ddd') < 1 Then
		Obj.AddProperty("mensaje", "")
		Obj.AddProperty("valor", 0)
		Return Obj
	Endif
	cdetalle = ""
	x = 0
	Select ddd
	Scan All
		If x = 0 Then
			cdetalle = ddd.detv_desc
		Else
			cdetalle = Alltrim(cdetalle) + ' ' + Alltrim(ddd.detv_desc)
		Endif
		x = x + 1
	Endscan
	Obj.AddProperty("mensaje", cdetalle)
	Obj.AddProperty("valor", 1)
	Return Obj
	Endfunc
	Function listarxlineavendedorxsys3(Ccursor)
	dfi = Cfechas(This.fechai)
	dff = Cfechas(This.fechaf)
	Text To lC Noshow Textmerge
	SELECT v.nomv AS vendedor,c.dcat AS linea,d.razo AS cliente,importe
	FROM(
	SELECT SUM(cant*k.prec) AS importe,a.idcat,rcom_vend,idcliente FROM
	fe_rcom AS r
	INNER JOIN fe_kar AS k ON k.idauto=r.idauto
	INNER JOIN fe_art AS a ON a.idart=k.idart
	WHERE fech BETWEEN  '<<dfi>>' AND '<<dff>>'  AND r.acti='A' AND idcliente>0 AND k.acti='A' GROUP BY a.idcat,rcom_vend,idcliente) AS xx
	INNER JOIN fe_vend AS v ON  v.idven=xx.rcom_vend
	INNER JOIN fe_cat AS c ON c.idcat=xx.idcat
	INNER JOIN fe_clie AS d ON d.idclie=xx.idcliente order by v.nomv
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function verificarsiesta()
	cndoc = This.Serie + This.numero
	Ccursor = 'c_' + Sys(2015)
	Text To lC Noshow Textmerge
     SELECT idauto  FROM fe_rcom WHERE ndoc='<<cndoc>>' AND tdoc='<<this.tdoc>>' AND acti<>'I' AND idauto<><<this.idauto>> AND idcliente>0 LIMIT 1;
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If Idauto > 0 Then
		Return  0
	Else
		Return 1
	Endif
	Endfunc
	Function Registroventaspsys(Ccursor)
	f1 = Cfechas(This.fechai)
	f2 = Cfechas(This.fechaf)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To  Memvar lC Noshow
	 \Select a.Auto,a.fech,a.fevto,b.Tdoc,If(Length(Trim(a.Ndoc))<=10,Left(a.Ndoc,3),Left(a.Ndoc,4)) As Serie,
     \If(Length(Trim(a.Ndoc))<=10,mid(a.Ndoc,4,7),mid(a.Ndoc,5,8)) As Ndoc,
	 \      d.nruc,d.Razo,
	 \      Sum(Case c.Nitem When 1 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As valor,
	 \      Sum(Case c.Nitem When 5 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As exonerado,
	 \      Sum(Case c.Nitem When 2 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As igv,
	 \      Sum(Case c.Nitem When 3 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As Impo,
	 \      Sum(Case c.Nitem When 4 Then If(a.Mone='S',c.Impo,Round(c.Impo*a.dolar,2)) Else 0 End) As pimpo,
	 \      a.idrven,ifnull(e.Ndoc,'') As Refe,ifnull(w.Tdoc,'00') As tref,
	 \      e.fech As fechn,ifnull(e.Impo,0) As impn,
	 \      a.idclie As Codigo,a.vigv,ifnull(a.Detalle,'') As Detalle,a.Mone,a.dolar As dola,a.Form,ifnull(d.ndni,'') As ndni,rcom_icbper
	 \      From fe_rven As a
	 \      inner Join fe_tdoc As b On(b.idtdoc=a.idtdoc)
	 \      inner Join fe_ectas As c On(c.idrven=a.idrven)
	 \      inner Join fe_clie As d On(d.idclie=a.idclie)
	 \      Left Join fe_refe As e On(e.idrven=a.idrven)
	 \      Left Join fe_tdoc As w On w.idtdoc=e.idtdoc
	 \      Where fecr Between '<<f1>>' And '<<f2>>' And a.Acti<>'I' And b.Tdoc In("01","03","07","08")
	If Len(Alltrim(This.Serie)) > 0 Then
	   \And Left(a.Ndoc,4)='<<this.serie>>'
	Endif
	\Group By a.idrven,e.idrefe
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function registrarxserviciosconanticipo()
	Set Procedure To d:\capass\modelos\correlativos Additive
	ocorr = Createobject("correlativo")
	cguia = ""
	If fe_gene.nruc = '20439488736' Then
		cguia = This.idanticipo2
	Endif
	If This.IniciaTransaccion() < 1  Then
		Return 0
	Endif
	If goApp.vtascondetraccion = 'S' Then
		NAuto = IngresaResumenDctovtascondetraccion(This.Tdoc, Left(This.formaPago, 1), This.Serie + This.numero, This.Fecha, This.Fecha, ;
			  This.Detalle, This.valor, This.igv, This.Monto, cguia, Left(This.Moneda, 1), ;
			  This.ndolar, This.vigv, 'S', This.Codigo, This.idanticipo, goApp.nidusua, This.Vendedor, This.codt, This.cta1, This.cta2, This.cta3, This.exonerado, This.detraccion, This.coddetraccion)
	Else
		NAuto = IngresaDocumentoElectronico(This.Tdoc, Left(This.formaPago, 1), This.Serie + This.numero, This.Fecha, This.Detalle, This.valor, This.igv, This.Monto, "", ;
			  Left(This.Moneda, 1), This.ndolar, This.vigv, 'S', This.Codigo, "V", goApp.nidusua, This.codt, This.cta1, This.cta2, This.cta3, This.Vendedor, 0, This.exonerado, 0)
	Endif
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If IngresaDatosLCajaEFectivo12(This.Fecha, "", This.clienteseleccionado, This.cta3, This.Monto, 0, 'S', fe_gene.dola, goApp.nidusua, This.Codigo, NAuto, Left(This.formaPago, 1), This.Serie + This.numero, This.Tdoc, goApp.Tienda) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If Left(This.formaPago, 1) = 'C' Then
		Vdvto = IngresaCreditosNormal(NAuto, This.Codigo, This.Serie + This.numero, 'C', Left(This.Moneda, 1), This.Detalle, This.Fecha, This.Fechavto, Left(This.tipodcto, 1), This.Serie + This.numero, This.Monto, 0, This.Vendedor, This.Monto, goApp.nidusua, This.codt, Id())
		If Vdvto < 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	Select tmpv
	Go Top
	Scan All
		If IngresaDetalleVTaCunidad(tmpv.Desc, tmpv.Nitem, tmpv.nitem1, tmpv.nitem2, NAuto, tmpv.Prec, tmpv.cant, tmpv.Unid) = 0 Then
			Sw = 0
			Exit
		Endif
	Endscan
	If  Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	ocorr.Idserie = This.Idserie
	ocorr.Nsgte = This.Nsgte
	If ocorr.GeneraCorrelativo1() < 1 Then
		This.Cmensaje = ocorr.Cmensaje
		Return 0
	Endif
	If This.GRabarCambios() < 1  Then
		Return 0
	Endif
	Return NAuto
	Endfunc
	Function actualizarxserviciosconanticipo()
	cndoc = This.Serie + This.numero
	cguia = ""
	If fe_gene.nruc = '20439488736' Then
		cguia = This.idanticipo2
	Endif
	If This.IniciaTransaccion() < 1  Then
		Return 0
	Endif
	If goApp.vtascondetraccion = 'S' Then
		If ActualizaResumenDctovtascondetraccion(This.Tdoc, Left(This.formaPago, 1), cndoc, This.Fecha, This.Fecha, This.Detalle, This.valor, This.igv, This.Monto, cguia, Left(This.Moneda, 1), ;
				  This.ndolar, This.vigv, 'S', This.Codigo, This.idanticipo, goApp.nidusua, This.Vendedor, This.codt, This.cta1, This.cta2, This.cta3, This.exonerado, 0, This.detraccion, This.Idauto, This.coddetraccion) < 1 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Else
		If ActualizaResumenDctoVtas(This.Tdoc, Left(This.formaPago, 1), cndoc, This.Fecha, This.Detalle, This.valor, This.igv, This.Monto, "", Left(This.Moneda, 1), ;
				  This.ndolar, This.vigv, 'S', This.Codigo, 'V', goApp.nidusua, 0, This.codt, This.cta1, This.cta2, This.cta3, This.exonerado, 0, This.Idauto, This.Vendedor) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If ActualizaCreditos(This.Idauto, goApp.nidusua) = 0
		This.DEshacerCambios()
		Return 0
	Endif
	If IngresaDatosLCajaEFectivo12(This.Fecha, "", This.clienteseleccionado, This.cta3, This.Monto, 0, 'S', fe_gene.dola, goApp.nidusua, This.Codigo, This.Idauto, Left(This.formaPago, 1), This.Serie + This.numero, This.Tdoc, goApp.Tienda) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If Left(This.formaPago, 1) = 'C' Then
		Vdvto = IngresaCreditosNormal(This.Idauto, This.Codigo, This.Serie + This.numero, 'C', Left(This.Moneda, 1), This.Detalle, This.Fecha, This.Fechavto, Left(This.tipodcto, 1), This.Serie + This.numero, This.Monto, 0, This.Vendedor, This.Monto, goApp.nidusua, This.codt, Id())
		If Vdvto < 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If ActualizaDetalleVTa(This.Idauto) = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpv
	Go Top
	Scan All
		If IngresaDetalleVTaCunidad(tmpv.Desc, tmpv.Nitem, tmpv.nitem1, tmpv.nitem2, This.Idauto, tmpv.Prec, tmpv.cant, tmpv.Unid) = 0 Then
			Sw = 0
			Exit
		Endif
	Endscan
	If  Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function resumenvtasxsysz(Ccursor)
	f1 = Cfechas(This.fechai)
	f2 = Cfechas(This.fechaf)
	Set Textmerge On
	Set  Textmerge To Memvar lC Noshow Textmerge
	\ Select	a.Ndoc As dcto,a.Tdoc,a.fech,b.Razo,a.Form,k.cantidad,a.valor,a.igv,
	\		    a.Impo,Mone,a.Ndoc,u.nomb As Usuario,FUsua,ifnull(v.nomv,'') As Vendedor,a.Idauto,rcom_vtar
	\		    From fe_rcom As a
	\		    inner Join fe_clie As b On (a.idcliente=b.idclie)
	\		    inner Join fe_usua u On u.idusua=a.idusua
	\		    Left Join
	\		   (Select r.Idauto,Sum(cant) As cantidad From fe_rcom As r
	\		    inner Join fe_kar As k  On k.Idauto=r.Idauto
	\		    Where k.Acti='A' And tipo='V' And kar_icbper=0   And rcom_ccaj='P' And r.Acti='A' And fech Between '<<f1>>' And '<<f2>>'  Group By r.Idauto) As k On k.Idauto=a.Idauto
	\		    Left Join rvendedores As g On g.Idauto=a.Idauto
	\		    Left Join fe_vend As v On v.idven=g.Codv
	\		    Where a.fech Between '<<f1>>' And '<<f2>>'  And a.Acti<>'I' And rcom_ccaj='P'
	If This.codt > 0 Then
	\And a.codt=<<This.codt>>
	Endif
	If Len(Alltrim(This.Tdoc)) > 0 Then
	   \ And a.Tdoc='<<this.tdoc>>'
	Endif
	If Len(Alltrim(This.formaPago)) > 0 Then
	  \ And a.Form='<<this.formapago>>'
	Endif
	\Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function resumenvtasxformapago(Ccursor)
	f1 = Cfechas(This.fechai)
	f2 = Cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select	fech,Sum(cantidad) As cantidad,Sum(efectivo) As efectivo,Sum(visa) As visa,
	\		Sum(Master) As Master,Sum(deposito) As deposito,
	\		Sum(credito) As credito,Sum(efectivo)+Sum(visa)+Sum(Master)+Sum(deposito)+Sum(credito)+Sum(yape)+Sum(plin) As Importe,Sum(yape) As yape,Sum(plin) As plin From(
	\		Select a.fech,k.cantidad,a.Form,
	\		Case a.Form When'E' Then Impo Else 0 End As efectivo,
	\		Case a.Form When 'V' Then Impo Else 0 End  As  visa,
	\		Case a.Form When 'M' Then Impo Else 0 End As Master,
	\		Case a.Form When 'D' Then Impo Else 0 End As deposito,
	\		Case a.Form When 'C' Then Impo Else 0 End As credito,
	\		Case a.Form When 'Y' Then Impo Else 0 End As yape,
	\		Case a.Form When 'P' Then Impo Else 0 End As plin
	\		From fe_rcom As a Join fe_clie As b On (a.idcliente=b.idclie )
	\       inner Join
	\		(Select k.Idauto,Sum(cant) As cantidad From fe_kar As k
	\		inner Join fe_rcom As r On r.Idauto=k.Idauto
	\		Where k.Acti='A' And tipo='V' And kar_icbper=0 And r.Acti='A' And idcliente>0
	\		And r.fech Between '<<f1>>' And '<<f2>>'   Group By Idauto) As k On k.Idauto=a.Idauto
	\		Where  a.Acti<>'I' And rcom_ccaj='P' And a.fech Between '<<f1>>' And '<<f2>>'
	If This.codt > 0 Then
	\ And a.codt=<<This.codt>>
	Endif
	\Order By fech) As x Group By fech
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Rentabilidad(Ccursor)
	dfi = Cfechas(This.fechai)
	dff = Cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
		\Select z.Coda,z.Descri,z.Unid,z.cant As cantidad,z.costopr As costo,
		\z.prVtas As PrecioPromedioVtas,z.prVtas*z.cant As ImporteVentas,z.cant*z.costopr As ImporteCompras,
		\((z.prVtas*z.cant)-(z.cant*z.costopr))/z.cant As Utilidad,
	    \(z.prVtas*z.cant)-(z.cant*z.costopr) As margen,
	    \((((z.prVtas*z.cant)-(z.cant*z.costopr))/z.cant)*100)/If(z.costopr>0,z.costopr,1)  As porcentaje From
		\(Select a.idart As Coda,b.Descri,b.Unid,Sum(a.cant) As cant,Sum(cant*a.Prec)/Sum(cant) As prVtas,
		\Sum(a.cant*If(a.kar_cost=0,If(tmon='S',b.Prec*c.vigv,b.Prec*c.dolar*c.vigv),a.kar_cost*c.vigv))/Sum(a.cant) As costopr,
		\cc.Razo As cliente,v.nomv As Vendedor,
		\From fe_rcom As c
		\inner Join fe_kar As a On a.Idauto=c.Idauto
		\inner Join fe_art As b On b.idart=a.idart
	    \inner Join  (Select Idauto From fe_kar As a Where alma>0 And Acti='A' And tipo='V' Group By a.Idauto Order By a.Idauto ) As k On k.Idauto=a.Idauto
	    \Where c.idcliente>0 And a.Acti='A' And c.Acti='A' And c.fech Between  '<<dfi>>' And '<<dff>>'  And c.tcom<>'T'
	If This.nmarca > 0 Then
	    \ And b.idmar=<<This.nmarca>>
	Endif
	If This.nlinea > 0 Then
	      \ And b.idcat=<<This.nlinea>>
	Endif
	If This.codt > 0 Then
	        \ And c.codt=<<This.codt>>
	Endif
	     \Group By b.idart,b.Descri,b.Unid) As z Order By z.Descri
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listardetalleventas(Ccursor)
	dfechai = Cfechas(This.fechai)
	dfechaf = Cfechas(This.fechaf)
	If !Pemstatus(goApp, 'proyecto', 5) Then
		AddProperty(goApp, 'proyecto', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC  Noshow Textmerge
    \Select a.Tdoc,a.Ndoc,a.fech,c.Razo,
	If goApp.Proyecto = 'psysrx' Or goApp.Proyecto = 'psysr' Then
    \ Concat(Trim(d.idart),' ',Trim(d.Descri)) As Descri,
	Else
    \ d.Descri,
	Endif
	\d.Unid,e.cant,e.Prec,a.Mone,F.nomb As Usuario,e.cant*e.Prec  As Impo,a.Form,valor,igv,Impo As Importe
	\From
	\fe_rcom As a inner Join fe_clie As c On c.idclie=a.idcliente
	\inner Join fe_kar As e On e.Idauto=a.Idauto
	\inner Join fe_art As d On d.idart=e.idart
	\inner Join fe_usua As F On F.idusua=a.idusua
	\Where a.fech Between '<<dfechai>>' And '<<dfechaf>>' And a.Acti='A' And e.Acti='A'
	If 	This.codt > 0 Then
	  \ And a.codt=<<This.codt>>
	Endif
	If Len(Alltrim(This.Tdoc)) > 0 Then
	   \ And a.Tdoc='<<this.tdoc>>'
	Endif
	\Order By a.fech,a.Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listardetalleventas1(Ccursor)
	dfechai = Cfechas(This.fechai)
	dfechaf = Cfechas(This.fechaf)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC  Noshow Textmerge
    \Select a.Tdoc,a.Ndoc,a.fech,c.Razo As cliente,d.Descri As producto,d.Unid,e.cant,e.Prec,a.Mone,F.nomb As Usuario,prod_cod1 As codigofabrica,
	\ifnull(l.dcat,'') As categoria,ifnull(desgrupo,'') As grupo,ifnull(m.dmar,'') As marca,ifnull(prod_acti,'') As estado,
	\Round(If(d.tmon='S',(d.Prec*z.igv)+b.Prec,(d.Prec*z.igv*z.dola)+b.Prec),2) As costo,v.nomv As Vendedor,
	\e.cant*e.Prec  As Impo,a.Form,c.nruc,c.ndni,d.idart,a.dolar  From fe_rcom As a
	\inner Join fe_clie As c On c.idclie=a.idcliente
	\inner Join fe_kar As e On e.Idauto=a.Idauto
	\inner Join fe_art As d On d.idart=e.idart
	\Left Join fe_cat As l On l.idcat=d.idcat
	\Left Join fe_grupo As g On g.idgrupo=l.idgrupo
	\Left  Join fe_mar As m On m.idmar=d.idmar
	\Left Join fe_fletes As b On b.idflete=d.idflete
	\inner Join fe_usua As F On F.idusua=a.idusua
	\inner Join fe_vend As v On v.idven=e.Codv,fe_gene As z
	\Where a.fech Between '<<dfechai>>' And '<<dfechaf>>' And a.Acti='A' And e.Acti='A'
	If 	This.codt > 0 Then
	  \ And a.codt=<<This.codt>>
	Endif
	If Len(Alltrim(This.Tdoc)) > 0 Then
	   \ And a.Tdoc='<<this.tdoc>>'
	Endif
	\Order By a.fech,a.Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Rentabilidad10(Ccursor)
	dfi = Cfechas(This.fechai)
	dff = Cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	If This.AgrupadaGanancia = 'S' Then
	    \Select Ndoc,fech,cliente,Vendedor,Importe,(Sum(Utilidad)*100)/Sum(costototal) As porcentaje,Sum(Utilidad) As Utilidad,Idauto From
        \(Select k.idart As Coda,b.Descri,b.Unid,cant,Cast(kar_cost  As Decimal(12,4)) As costounitario,
	    \Cast(If(c.Mone='S',k.Prec,k.Prec*c.dolar)  As Decimal(12,4))As PrecioVenta,
	    \Cast(cant*kar_cost As Decimal(12,2)) As costototal,
	    \Cast(cant*If(c.Mone='S',k.Prec,k.Prec*c.dolar)  As Decimal(12,2)) As ventatotal,
	    \Cast((cant*If(c.Mone='S',k.Prec,k.Prec*c.dolar))-(cant*k.kar_cost) As Decimal(12,2)) As Utilidad,
	    \cc.Razo As cliente,v.`nomv` As Vendedor,c.Idauto,Ndoc,fech,If(c.Mone='S',Impo,Impo*c.dolar) As Importe
	    \From fe_rcom As c
		\inner Join fe_kar As k On k.Idauto=c.Idauto
		\inner Join fe_art As b On b.idart=k.idart
		\inner Join fe_clie As cc On cc.idclie=c.idcliente
		\inner Join fe_vend As v On v.idven=k.Codv
	    \Where k.Acti='A' And c.Acti='A' And c.fech Between  '<<dfi>>' And '<<dff>>'   And c.tcom<>'T'
		If This.nmarca > 0 Then
	    \ And b.idmar=<<This.nmarca>>
		Endif
		If This.nlinea > 0 Then
	      \ And b.idcat=<<This.nlinea>>
		Endif
		If This.codt > 0 Then
	        \ And c.codt=<<This.codt>>
		Endif
		If This.Vendedor > 0 Then
		   \  And k.Codv=<<This.Vendedor>>
		Endif
		\) As xx Group By Idauto Order By fech,Ndoc
	Else
		\Select prod_cod1,b.Descri,b.Unid,cant,Cast(kar_cost  As Decimal(12,4)) As costounitario,
	    \Cast(If(c.Mone='S',k.Prec,k.Prec*c.dolar)  As Decimal(12,4))As PrecioVenta,
	    \Cast(cant*kar_cost As Decimal(12,2)) As costototal,
	    \Cast(cant*If(c.Mone='S',k.Prec,k.Prec*c.dolar)  As Decimal(12,2)) As ventatotal,
	    \Cast((cant*If(c.Mone='S',k.Prec,k.Prec*c.dolar))-(cant*k.kar_cost) As Decimal(12,2)) As Utilidad,
	    \Cast((((cant*If(c.Mone='S',k.Prec,k.Prec*c.dolar))-(cant*k.kar_cost))*100)/(cant*kar_cost) As Decimal(6,2)) As porcentaje,
	    \cc.Razo As cliente,v.`nomv` As Vendedor,Ndoc,fech,c.Idauto,k.idart As Coda
	    \ From fe_rcom As c
		\inner Join fe_kar As k On k.Idauto=c.Idauto
		\inner Join fe_art As b On b.idart=k.idart
		\inner Join fe_clie As cc On cc.idclie=c.idcliente
		\inner Join fe_vend As v On v.idven=k.Codv
	    \Where k.Acti='A' And c.Acti='A' And c.fech Between  '<<dfi>>' And '<<dff>>'   And c.tcom<>'T'
		If This.nmarca > 0 Then
	    \ And b.idmar=<<This.nmarca>>
		Endif
		If This.nlinea > 0 Then
	      \ And b.idcat=<<This.nlinea>>
		Endif
		If This.codt > 0 Then
	        \ And c.codt=<<This.codt>>
		Endif
		If This.Vendedor > 0 Then
		   \  And k.Codv=<<This.Vendedor>>
		Endif
	     \ Order By Descri
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function resumenvtas(Ccursor)
	If !Pemstatus(goApp, 'proyecto', 5) Then
		AddProperty(goApp, 'proyecto', '')
	Endif
	f1 = Cfechas(This.fechai)
	f2 = Cfechas(This.fechaf)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
		\Select a.Ndoc As dcto,a.fech,b.nruc,b.Razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
		\    a.igv,a.Impo,rcom_hash,rcom_mens,Mone,a.Tdoc,a.Ndoc,Idauto,rcom_arch,b.clie_corr,tcom,FUsua,u.nomb,b.fono,ndo2,
		\Concat(Trim(b.Dire),' ',Trim(b.ciud)) As Dire,rcom_otro,b.ndni,nruc,Form,dolar,a.codt
		\    From fe_rcom As a
		\    Join fe_clie As b On (a.idcliente=b.idclie)
		\    Join fe_usua As u On u.idusua=a.idusua
		\    Where a.fech Between '<<f1>>' And '<<f2>>'  And a.Acti<>'I' And Left(Ndoc,1) In("F","B","P")
	If This.codt > 0 Then
		   \ And a.codt=<<This.codt>>
	Endif
	If Len(Alltrim(This.Tdoc)) > 0 Then
	\ And a.Tdoc='<<this.Tdoc>>'
	ENDIF
	IF this.Usuario>0 THEN 
	\ and a.idusua=<<this.Usuario>>
	ENDIF 
	If Left(goApp.tipousuario, 1) = 'V'  And goApp.Proyecto = 'psystr' Then
	   \And a.idusua=<<goApp.nidusua>>
	Endif
	\Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarventasresumidas(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To  Memvar lC Noshow Textmerge
    \ Select Ndoc,fech,b.Razo,Mone,valor,igv,Impo,Idauto,Tdoc,a.idcliente As cod,rcom_hash,rcom_arch,rcom_mens,a.idusua As idusuav  From fe_rcom As a
    \ inner Join fe_clie As b On b.idclie=a.idcliente
    \ Where a.Acti<>'I'
	If This.Codigo > 0 Then
    \ And a.idcliente=<<This.Codigo>>
	Endif
	If This.ctipoconsulta = 'V' Then
	  \  And (Tdoc="01" Or Tdoc="03" Or Tdoc="20")
	Endif
	If This.ctipoconsulta = 'v' Then
	  \  And (Tdoc="01" Or Tdoc="03")
	Endif
	If This.ctipoconsulta = 'z' Then
	   \ And Tdoc="20"
	Endif
	If This.Na�o > 0 Then
	\ And Month(a.fech)=<<This.Na�o>>
	Endif
	If This.nmes > 0 Then
	\ And Month(a.fech)=<<This.Nmess>>
	Endif
	If This.codt > 0 Then
	\ And a.codt=<<This.codt>>
	Endif
	\ Order By Ndoc,fech Desc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscardctoparaplicarncnd(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lC Noshow Textmerge
	  select k.idart,a.descri,a.unid,k.cant,k.prec,
	  r.impo as importe,r.idauto,r.mone,r.valor,r.igv,r.impo,kar_comi as comi,
	  r.fech,r.ndoc,r.tdoc,r.dolar as dola FROM fe_rcom as r
	  inner join fe_kar as k on k.idauto=r.idauto
	  inner join fe_art as a on a.idart=k.idart
	  WHERE r.idauto=<<this.Idauto>> and k.acti='A' 
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function canjearguiasporfacturas()
	Local Sw As Integer
	If This.validarcanjeguias() < 1 Then
		Return 0
	Endif
	Set Classlib To "d:\librerias\fe" Additive
	ocomp = Createobject("comprobante")
	If VerificaAlias("cabecera") = 1 Then
		Zap In cabecera
	Else
		Create Cursor cabecera(idcab N(8))
	Endif
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If This.actualizardesdeguias() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Sw = 1
	Select  tmpp
	Scan All
		Text To lC Noshow  Textmerge
	     UPDATE fe_kar SET prec=<<tmpp.prec>> where idkar=<<tmpp.nreg>>
		Endtext
		If This.Ejecutarsql(lC) < 1 Then
			Sw = 0
			Exit
		Endif
	Endscan
	If Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GeneraCorrelativo(This.Serie + This.numero, This.Idserie) < 1  Then
		This.DEshacerCambios()
		This.Cmensaje = This.GeneraCorrelativo.Cmensaje
		Return 0
	Endif
	If  This.GRabarCambios() = 0 Then
		Return 0
	Endif
	ocomp.Version = '2.1'
	Try
		Select cabecera
		Scan All
			Do Case
			Case  This.Tdoc = '01'
				vdx = ocomp.obtenerdatosfactura(cabecera.idcab, 'SF')
			Case This.Tdoc = '03'
				vdx = ocomp.obtenerdatosBoleta(cabecera.idcab, 'SF')
			Endcase
		Endscan
	Catch To oErr When oErr.ErrorNo = 1429
		Messagebox(MENSAJE1 + MENSAJE2 + MENSAJE3, 16, MSGTITULO)
	Catch To oErr When oErr.ErrorNo = 1924
		Messagebox(MENSAJE1 + MENSAJE2 + MENSAJE3, 16, MSGTITULO)
	Finally
	Endtry
	This.imprimirdctocanjeado()
	Zap In cabecera
	Return 1
	Endfunc
	Function imprimirdctocanjeado()
	Select * From tmpp Into Cursor tmpv Readwrite
	Select tmpv
	Replace All cletras With This.cletras, hash With This.hash, Archivo With This.ArchivoXml, fech With This.Fecha In tmpv
	Select tmpv
	Go Top In tmpv
	Set Procedure To Imprimir Additive
	obji = Createobject("Imprimir")
	obji.Tdoc = This.Tdoc
	obji.ArchivoPdf = This.ArchivoPdf
	obji.ElijeFormato()
	obji.GeneraPDF("")
	obji.ImprimeComprobante('S')
	If !Empty(This.correo) Then
*.comprobante1.enviarcorreocliente(.comprobante1.correo)
	Endif
	Endfunc
	Function validarcanjeguias()
	Do Case
	Case This.Idauto = 0
		This.Cmensaje = "Seleccione un Documento para Canje"
		Return 0
	Case  This.idautoguia = 0
		This.Cmensaje = "Seleccione una Guia de Remisi�n para Canje"
		Return 0
	Case PermiteIngresoVentas(This.Serie + This.numero, This.Tdoc, 0, This.Fecha) = 0
		This.Cmensaje = "N�mero de Documento de Venta Ya Registrado"
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function actualizardesdeguias()
	Set Procedure To d:\capass\modelos\cajae, d:\capass\modelos\ctasxcobrar.prg  Additive
	ocaja = Createobject("cajae")
	ni = fe_gene.igv
	nidusua = goApp.nidusua
	nidtda = goApp.Tienda
	nidcta1 = fe_gene.idctav
	nidcta2 = fe_gene.idctai
	nidcta3 = fe_gene.idctat
	ocaja.dFecha = This.Fecha
	ocaja.codt =  goApp.Tienda
	ocaja.Ndoc = This.Serie + This.numero
	ocaja.nidprovedor = 0
	ocaja.cdetalle = This.razon
	ocaja.nidcta = nidcta3
	ocaja.ndebe = This.Monto
	ocaja.nhaber = 0
	ocaja.ndolar = fe_gene.dola
	ocaja.nidusua = goApp.nidusua
	ocaja.nidclpr = This.Codigo
	ocaja.NAuto = This.Idauto
	ocaja.Cmoneda = This.Moneda
	ocaja.cTdoc = This.Tdoc
	cform = Left(This.formaPago, 1)
	ndolar = fe_gene.dola
	If This.ActualizaresumentDctoCanjeado(This.Tdoc, cform, This.Serie + This.numero, This.Fecha, This.Fecha, This.Detalle, ;
			  This.valor, This.igv, This.Monto, This.NroGuia, This.Moneda, ndolar, fe_gene.igv, 'k', This.Codigo, 'V', goApp.nidusua, 1, goApp.Tienda, nidcta1, nidcta2, nidcta3, 0, This.idautoguia, This.Idauto) < 1 Then
		Return 0
	Endif
	If ocaja.IngresaDatosLCajaEFectivo11() < 1 Then
		This.Cmensaje = ocaja.Cmensaje
		Return 0
	Endif
	If cform = 'E' Then
		If IngresaRvendedores(This.Idauto, This.Codigo, This.Vendedor, cform) = 0 Then
			Return 0
		Endif
	Endif
	If cform = 'C' Or cform = 'D' Then
		ocre = Createobject("ctasporcobrar")
		ocre.dFech = This.Fecha
		ocre.Fechavto = This.Fechavto
		ocre.nimpo = This.Monto
		ocre.nimpoo = This.Monto
		ocre.tipodcto = 'F'
		ocre.crefe = "VENTA AL CREDITO"
		ocre.cndoc = This.Serie + This.numero
		ocre.nidclie = This.Codigo
		ocre.Idauto = This.Idauto
		ocre.Codv = goApp.nidusua
		If ocre.registrar() < 1 Then
			Return 0
		Endif
	Endif
	Insert Into cabecera(idcab)Values(This.Idauto)

	Return 1
	Endfunc
	Function ActualizaresumentDctoCanjeado(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25)
	lsql = 'ProActualizaCanjeguia'
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
	Text To lparms Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
	Endtext
	If This.EJECUTARP(lsql, lparms, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarRetenciones(Ccursor)
	dfi = Cfechas(This.fechai)
	dff = Cfechas(This.fechaf)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \  Select Ndoc,fech,Form,q.Razo,a.rcom_rete,rcom_pert,Idauto,T.nomb As tienda From fe_rcom As a
    \  inner Join fe_clie As q On q.idclie=a.idcliente
    \  inner Join fe_sucu As T On T.idalma=a.codt
    \  Where Acti='A' And tipom='C' And Tdoc='20' And fech Between '<<dfi>>' And '<<dff>>'
	If This.codt > 0 Then
      \ And a.codt=<<This.codt>>
	Endif
	If This.tipodcto = 'X' Then
	\ And rcom_pert =''
	Endif
    \ Order By fech
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarxidpsystr(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\ Select  `c`.`rcom_icbper` As `rcom_icbper`, `a`.`kar_icbper`  As `kar_icbper`, `c`.`rcom_mens`   As `rcom_mens`,ifnull(m.fevto,c.fech) As fvto,
	\  `c`.`idusua`      As `idusua`, `a`.`kar_comi`    As `kar_comi`, `a`.`Codv`        As `Codv`,`a`.`Idauto`      As `Idauto`,
	\  `a`.`alma`        As `alma`, `a`.`kar_idco`    As `idcosto`, `a`.`idkar`       As `idkar`, `a`.`idart`       As `Coda`,
	\  `a`.`cant`        As `cant`, `a`.`Prec`        As `Prec`, `c`.`valor`       As `valor`, `c`.`igv`         As `igv`,
	\  `c`.`Impo`        As `Impo`, `c`.`fech`        As `fech`, `c`.`fecr`        As `fecr`, `c`.`Form`        As `Form`,
	\  `c`.`Deta`        As `Deta`, `c`.`Exon`        As `Exon`, `c`.`ndo2`        As `ndo2`, `c`.`rcom_entr`   As `rcom_entr`,
	\  `c`.`idcliente`   As `idclie`, `d`.`Razo`        As `Razo`, `d`.`nruc`        As `nruc`, `d`.`Dire`        As `Dire`,
	\  `d`.`ciud`        As `ciud`,  `d`.`ndni`        As `ndni`, `a`.`tipo`        As `tipo`, `c`.`Tdoc`        As `Tdoc`,
	\  `c`.`Ndoc`        As `Ndoc`, `c`.`dolar`       As `dolar`, `c`.`Mone`        As `Mone`,  `b`.`Descri`      As `Descri`,
	\  `b`.`Unid`        As `Unid`, `b`.`pre1`        As `pre1`, `b`.`peso`        As `peso`, `b`.`pre2`        As `pre2`,
	\  `c`.`vigv`        As `vigv`, `a`.`dsnc`        As `dsnc`, `a`.`dsnd`        As `dsnd`, `a`.`gast`        As `gast`,
	\  `c`.`idcliente`   As `idcliente`, `c`.`codt`        As `codt`, `b`.`pre3`        As `pre3`, `b`.`cost`        As `costo`,
	\  `b`.`uno`         As `uno`, `b`.`Dos`         As `Dos`, (`b`.`uno` + `b`.`Dos`) As `TAlma`, `c`.`FUsua`       As `FUsua`,
	\  `p`.`nomv`        As `Vendedor`, `q`.`nomb`        As `Usuario`, `c`.`rcom_idtr`   As `rcom_idtr`, `c`.`rcom_tipo`   As `rcom_tipo`
	If goApp.Clienteconproyectos = 'S' Then
	\ , `c`.`alma`        As `codproyecto`
	Endif
	\  From `fe_rcom` `c`
    \  Join `fe_kar` `a`  On ((`a`.`Idauto` = `c`.`Idauto`))
    \  Join `vlistaprecios` `b`  On ((`b`.`idart` = `a`.`idart`))
    \  Join `fe_clie` `d`  On ((`d`.`idclie` = `c`.`idcliente`))
    \  Left Join `fe_vend` `p`  On ((`p`.`idven` = `a`.`Codv`))
    \  Join `fe_usua` `q`  On ((`q`.`idusua` = `c`.`idusua`))
    \  Left Join (Select rcre_idau,Min(c.fevto) As fevto From fe_rcred As r inner Join fe_cred As c On c.cred_idrc=r.rcre_idrc
    \  Where rcre_acti='A' And Acti='A' And rcre_idau=<<This.Idauto>> Group By rcre_idau) As m On m.rcre_idau=c.Idauto
    \  Where `c`.`Acti` <> 'I'  And `a`.`Acti` <> 'I' And a.Idauto=<<This.Idauto>>
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
















































