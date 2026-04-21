Define Class ventaslopez As Ventas Of d:\capass\modelos\Ventas
	Importe = 0
	nvtas = 0
	tipocanje = ''
	Function buscarxid(ccursor)
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	TEXT TO lc NOSHOW TEXTMERGE
	   select a.codv,a.idauto,c.codt as alma,a.idkar,a.idart,a.cant,a.prec,a.codv,c.valor,c.igv,c.impo,c.idusua as idusuav,
	   c.fech,c.fecr,c.form,c.deta,c.exon,c.ndo2,c.vigv as igv,c.idcliente as idclie,d.razo,d.clie_corr,
	   d.nruc,d.dire,d.ciud,d.ndni,d.fono,rcom_hash,d.clie_conta,ifnull(w.fevto,c.fech) as fvto,
	   a.tipo,c.tdoc,c.ndoc,c.dolar,c.mone,b.descri,b.unid,b.premay as pre1,b.premen as pre2,b.pre3,
	   round(if(tmon='S',(b.prec*g.igv)+f.prec,(b.prec*g.igv*g.dola)+f.prec),2) as costo,
	   a.incl,b.prod_come,b.prod_comc,rcom_arch
	   FROM fe_art as b
	   inner join fe_kar as a on(b.idart=a.idart)
	   inner JOIN fe_rcom as c on(a.idauto=c.idauto)
	   inner join fe_clie as d on(c.idcliente=d.idclie)
	   inner join fe_fletes as f on f.idflete=b.idflete
	   left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r inner join fe_cred as c on
	   c.cred_idrc=r.rcre_idrc where rcre_acti='A' and acti='A' and rcre_idau=<<this.idauto>> group by rcre_idau) as w on w.rcre_idau=c.idauto,fe_gene as g
	   where c.idauto=<<this.idauto>> AND a.acti='A' order by a.idkar;
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ValidarVtaslopez()
	x = validacaja(This.Fecha)
	If x = "C"
		This.Cmensaje = "La caja de Esta Fecha Esta Cerrada"
		Return .F.
	Endif
	If !Empty(This.Calias) Then
		If This.ValidarTemporalVtas(This.Calias) < 1 Then
			Return .F.
		Endif
	Endif
	cndoc = Alltrim(This.Serie) + Alltrim(This.numero)
	Do Case
	Case This.Codigo = 0 Or Empty(This.Codigo)
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
		This.Cmensaje = "Ingrese Un Número de Documento Válido"
		Return .F.
	Case Empty(This.Almacen)
		This.Cmensaje = "Seleccione Un Almacen"
		Return .F.
	Case Month(This.Fecha) <> goApp.mes Or Year(This.Fecha) <> Val(goApp.Año) Or !esfechaValida(This.Fecha)
		This.Cmensaje = "Fecha NO Permitida Por el Sistema y/o Fecha no Válida"
		Return .F.
	Case  !esFechaValidafvto(This.Fechavto)
		This.Cmensaje = "Fecha de Vencimiento no Válida"
		Return .F.
	Case This.Fechavto <= This.Fecha And This.nroformapago = 2
		This.Cmensaje = "La Fecha de Vencimiento debe ser mayor a la fecha de Emisión "
		Return .F.
	Case This.nroformapago >= 2 And This.CreditoAutorizado = 0 And vlineacredito(This.Codigo, This.Monto, This.lineacredito) = 0
		This.Cmensaje = "LINEA DE CREDITO FUERA DE LIMITE O TIENE VENCIMIENTOS MAYORES A 30 DIAS"
		Return .F.
	Case This.tipocliente = 'm' And This.nroformapago >= 2
		This.Cmensaje = "No es Posible Realizar esta Venta El Cliente esta Calificado Como MALO"
		Return .F.
	Case PermiteIngresoVentas1(cndoc, This.Tdoc, 0, This.Fecha) = 0
		This.Cmensaje = "Número de Documento de Venta Ya Registrado"
		Return .F.
	Case PermiteIngresox(This.Fecha) = 0
		This.Cmensaje = "Los Ingresos con esta Fecha no estan permitidos por estar Bloqueados "
		Return .F.
	Case fe_gene.nruc = '20480172150'
		Do Case
		Case Substr(This.Serie, 2) = '010' And This.nroformapago = 1
			This.Cmensaje = "Solo Se permiten Ventas Al Crédito Con esta Serie de Comprobantes "
			Return .F.
		Case Substr(This.Serie, 2) = '010' And This.nroformapago >= 2 And goApp.nidusua <> goApp.nidusuavcredito
			This.Cmensaje = "Usuario NO AUTORIZADO PARA ESTA VENTA AL CRÉDITO"
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
	Function ImprimirLopez(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, nvalor, nigv, nimpo)
	Select (np6)
	Go Top
	ni = np3
	If goApp.ImpresionTicket <> 'S' Then
		For x = 1 To np2 - np3
			ni = ni + 1
			Insert Into (np6)(Ndoc, Nitem)Values(np4, ni)
		Next
	Endif
	Replace All Tdoc With np1, Ndoc With np4, cletras With np5, hash With np7, fech With np8, ;
		codc With np9, Guia With np10, Direccion With np11, dni With np12, Forma With np13, fono With np14, ;
		Vendedor With np15, valor With nvalor, igv With nigv, Total With nimpo, ;
		dias With np16, razon With np17, nruc With np18, Contacto With np19, Detalle With np20, Archivo With np21, Retencion With np22, ptop With goApp.Direccion  In (np6)
	Go Top In (np6)
	Do Foxypreviewer.App With "Release"
	Set Procedure To Imprimir Additive
	obji = Createobject("Imprimir")
	If goApp.ImpresionTicket = 'S' Then
		obji.Tdoc = np1
		obji.ElijeFormato()
		Select tmpv
		Set Filter To
		Set Order To
		If np1 = '01' Or np1 = '03' Or np1 = '20' Then
			Select * From tmpv Into Cursor copiaor Readwrite
			Replace All copia With 'Z' In copiaor
			Select tmpv
			Append From Dbf("copiaor")
		Endif
		Select tmpv
		Set Filter To !Empty(Coda)
		Go Top
		obji.ImprimeComprobanteComoTicket('S')
		Set Filter To copia <> 'Z'
		Go Top
	Else
		Select tmpv
		Go Top
		Do Case
		Case np1 = '01'
			If Left(np4, 4) = "F008"  Or Left(np4, 4) = "F010" Then
				Report Form factural1 To Printer Prompt Noconsole
			Else
				Report Form factural To Printer Prompt Noconsole
			Endif
		Case np1 = '03'
			If  Left(np4, 4) = "B008" Or Left(np4, 4) = "B010" Then
				Report Form boletal1 To Printer Prompt Noconsole
			Else
				Report Form boletal To Printer Prompt Noconsole
			Endif
		Case np1 = '07'
			Report Form notascl To Printer Prompt Noconsole
		Case np1 = '08'
			Report Form notasdl To Printer Prompt Noconsole
		Case np1 = '20'
			cArchivo = Addbs(Addbs(Sys(5) + Sys(2003)) + fe_gene.nruc) + 'notasp.frx'
			If File(cArchivo) Then
				Report Form (cArchivo) To Printer Prompt Noconsole
			Else
				Report Form (goApp.reporte) To Printer Prompt Noconsole
			Endif
		Endcase
	Endif
	Endfunc
	Function ValidarTemporalVtas(Calias)
	Local Sw As Integer
	Sw		 = 1
	Cmensaje = ""
	Select (Calias)
	Scan All
		Do Case
		Case cant = 0
			Sw		 = 0
			Cmensaje = "El Item: " + Alltrim(Desc) + " No Tiene Cantidad "
			Exit
		Case (cant * Prec) <= 0 And tipro = 'K' And costo = 0
			Sw		 = 0
			Cmensaje = "El Item: " + Alltrim(Desc) + " No Tiene costo Para Transferencia Gratuita"
			Exit
*!*			Case Prec < costo And aprecios <> 'A' And grati <> 'S'
*!*				sw		 = 0
*!*				Cmensaje = "El Producto: " + Rtrim(Desc) + " Tiene Un precio Por Debajo del Costo y No esta Autorizado para hacer esta Venta"
*!*				Exit
*!*			Case cant * costo <= 0 And grati = 'S' And Prec = 0
*!*				Cmensaje = "El Item: " + Alltrim(Desc) + " No Tiene Cantidad o Costo para la Transferencia Gratuita"
*!*				sw		 = 0

		Endcase
	Endscan
	If Sw = 0 Then
		This.Cmensaje = Cmensaje
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function mostrarventasparacanjes(f1, f2, nm, ccursor)
	If (f2 - f1) > 30 Then
		This.Cmensaje = "Máximo 30 Días para filtrar las Ventas"
		Return 0
	Endif
	If This.idsesion > 0 Then
		Set DataSession To This.idsesion
	Endif
	dfi = Cfechas(f1)
	dff = Cfechas(f2)
	nmargen = (nm / 100) + 1
	If This.formaPago = 'E' Then
		TEXT To lC Noshow Textmerge
		SELECT a.idart,descri,unid,cant as cantidad,importe,
		ROUND(IF(a.tmon='S',(a.prec*g.igv)+f.prec,(a.prec*g.igv*g.dola)+f.prec)*<<nmargen>>,4) As precio,
		ROUND(cant*(IF(a.tmon='S',(a.prec*g.igv)+f.prec,(a.prec*g.igv*g.dola)+f.prec)*<<nmargen>>),2) AS importe1,
		ROUND(IF(a.tmon='S',(a.prec*g.igv)+f.prec,(a.prec*g.igv*g.dola)+f.prec),4) AS costo,cant
		FROM(
		SELECT k.idart,SUM(cant) AS cant,SUM(k.cant*k.prec) AS importe
		FROM fe_rcom AS r
		INNER JOIN fe_kar AS k ON k.idauto=r.idauto
		WHERE tdoc='20' AND k.acti='A' AND r.acti='A' AND form='E' AND r.fech BETWEEN '<<dfi>>' AND '<<dff>>' and rcom_idtr=0 and r.codt=<<this.almacen>> GROUP BY idart) AS s
		INNER JOIN fe_art AS a ON a.idart=s.idart
		INNER JOIN fe_fletes AS  f ON f.idflete=a.idflete,fe_gene AS g
		ENDTEXT
		TEXT To lcx Noshow Textmerge
		SELECT r.idauto FROM fe_rcom AS r
		INNER JOIN fe_kar AS k ON k.idauto=r.idauto
		WHERE tdoc='20' AND k.acti='A' AND r.acti='A' AND form='E' AND r.fech BETWEEN '<<dfi>>' AND '<<dff>>'  and rcom_idtr=0 and r.codt=<<this.almacen>> GROUP BY idauto
		ENDTEXT
	Else
		TEXT To lC Noshow Textmerge
	    SELECT a.idart,descri,unid,cant AS cantidad,importe,
		ROUND(IF(a.tmon='S',(a.prec*g.igv)+f.prec,(a.prec*g.igv*g.dola)+f.prec)*1,4) AS precio,
		ROUND(cant*(IF(a.tmon='S',(a.prec*g.igv)+f.prec,(a.prec*g.igv*g.dola)+f.prec)*1),2) AS importe1,
		ROUND(IF(a.tmon='S',(a.prec*g.igv)+f.prec,(a.prec*g.igv*g.dola)+f.prec),4) AS costo,cant
		FROM(
		SELECT k.idart,SUM(cant) AS cant,SUM(k.cant*k.prec) AS importe
		FROM fe_rcom AS r
		INNER JOIN fe_kar AS k ON k.idauto=r.idauto
		INNER JOIN (SELECT  SUM(`c`.`impo` - `c`.`acta`)AS `saldo`, `c`.`ncontrol`  AS `ncontrol`,`c`.`mone` AS `mone`,rcre_idau AS idauto
		FROM `fe_rcred` `r`
		JOIN `fe_cred` `c` ON `c`.`cred_idrc` = `r`.`rcre_idrc`
		JOIN fe_rcom AS rr ON rr.idauto=r.rcre_idau
		WHERE `r`.`rcre_Acti` = 'A'  AND `c`.`acti` = 'A' AND rr.tdoc='20' AND rr.fech BETWEEN   '<<dfi>>' AND '<<dff>>' AND r.rcre_codt=<<this.almacen>>
		GROUP BY c.`ncontrol`,`c`.`mone`,r.rcre_idau HAVING (`saldo`=0)) AS yy ON yy.idauto=r.idauto
		WHERE tdoc='20' AND k.acti='A' AND r.acti='A' AND form in('C','R') AND r.fech BETWEEN  '<<dfi>>' AND '<<dff>>' AND rcom_idtr=0 AND r.codt=<<this.almacen>> GROUP BY idart) AS s
		INNER JOIN fe_art AS a ON a.idart=s.idart
		INNER JOIN fe_fletes AS  f ON f.idflete=a.idflete,fe_gene AS g
		ENDTEXT
*!*	    Para Filtrar los Id de los Pedidos
		TEXT To lcx Noshow Textmerge
		SELECT r.idauto FROM fe_rcom AS r
		INNER JOIN fe_kar AS k ON k.idauto=r.idauto
		inner join
		(SELECT  SUM(`c`.`impo` - `c`.`acta`)AS `saldo`, `c`.`ncontrol`  AS `ncontrol`,`c`.`mone` AS `mone`,rcre_idau AS idauto
		FROM `fe_rcred` `r`
		JOIN `fe_cred` `c` ON `c`.`cred_idrc` = `r`.`rcre_idrc`
		JOIN fe_rcom AS rr ON rr.idauto=r.rcre_idau
		WHERE `r`.`rcre_Acti` = 'A'  AND `c`.`acti` = 'A' AND rr.tdoc='20' AND rr.fech BETWEEN  '<<dfi>>' AND '<<dff>>' AND rr.codt=<<this.almacen>>
		GROUP BY c.`ncontrol`,`c`.`mone`,r.rcre_idau HAVING (`saldo`=0)) AS yy ON yy.idauto=r.idauto
		WHERE tdoc='20' AND k.acti='A' AND r.acti='A' AND form in('C','R') AND r.fech BETWEEN '<<dfi>>' AND '<<dff>>'  and rcom_idtr=0 and r.codt=<<this.almacen>> GROUP BY idauto
		ENDTEXT
	Endif
	If This.ejecutaconsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	If This.ejecutaconsulta(lcx, 'ldx') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function generatmpcanjes(ccursor)
	If This.idsesion > 1 Then
		Set DataSession To This.idsesion
	Endif
	Create Cursor vtas2(Descri c(80), Unid c(4), cant N(10, 2), Prec N(13, 5), Coda N(8), idco N(13, 5), Auto N(5), ;
		Ndoc c(12), Nitem N(3), comi N(7, 4), cletras c(150), Cantidad N(10, 2), IDautoP N(10), costo N(12, 6), valor N(12, 2), igv N(12, 2), Total N(12, 2))
	Create Cursor vtas3(Descri c(80), Unid c(4), cant N(10, 2), Prec N(10, 2), Coda N(8), codt N(10), IDautoP N(10), valor N(12, 2), igv N(12, 2), Total N(12, 2))
	Select (ccursor)
	Go Top
	x = 1
	F = 0
	sws = 1
	cdcto = This.Serie + This.numero
	Cmensaje = ""
	cn = Val(This.numero)
	nimporte = 0
	If This.Tdoc = '03' Then
		nmontob = 700
	Else
		nmontob = 2000
	Endif
	Do While !Eof()
		If lcanjes.cant = 0 Then
			Select lcanjes
			Skip
			Loop
		Endif
		If F >= This.Nitems Or nimporte >= nmontob Then
			For i = 1 To This.Nitems - F
				Insert Into vtas2(Ndoc, Nitem, Auto)Values(cdcto, i, x)
			Next
			F = 1
			x = x + 1
			cn = cn + 1
			nimporte = 0
			cdcto = This.Serie + Right("0000000" + Alltrim(Str(cn)), 8)
		Endif
		F = F + 1
		nimporte = nimporte + (lcanjes.cant * lcanjes.Precio)
		If nimporte <= nmontob Then
			Insert Into vtas2(Descri, Unid, cant, Prec, Coda, idco, Auto, Ndoc, Nitem, comi, IDautoP, costo)Values(lcanjes.Descri, lcanjes.Unid, lcanjes.cant, lcanjes.Precio, lcanjes.idart, 0, x, cdcto, F, 0, 0, lcanjes.costo)
			Replace cant With 0 In lcanjes
		Else
			If (lcanjes.cant = 1 And (lcanjes.cant * lcanjes.Precio) >= nmontob) Then
				Insert Into vtas2(Descri, Unid, cant, Prec, Coda, idco, Auto, Ndoc, Nitem, comi, IDautoP, costo)Values(lcanjes.Descri, lcanjes.Unid, lcanjes.Cantidad, lcanjes.Precio, lcanjes.idart, 0, x, cdcto, F, 0, 0, lcanjes.costo)
				Replace cant With cant - 1 In lcanjes
				For i = 1 To This.Nitems - F
					Insert Into vtas2(Ndoc, Nitem, Auto)Values(cdcto, i, x)
				Next
				F = 1
				x = x + 1
				cn = cn + 1
				nimporte = 0
				cdcto = This.Serie + Right("0000000" + Alltrim(Str(cn)), 8)
			Else
				nimporte = nimporte - (lcanjes.cant * lcanjes.Precio)
				ncant = Int((nmontob - nimporte) / lcanjes.Precio)
				If ncant > 0 Then
					nimporte = nimporte + (ncant * lcanjes.Precio)
					Insert Into vtas2(Descri, Unid, cant, Prec, Coda, idco, Auto, Ndoc, Nitem, comi, IDautoP, costo)Values(lcanjes.Descri, lcanjes.Unid, ncant, lcanjes.Precio, lcanjes.idart, 0, x, cdcto, F, 0, 0, lcanjes.costo)
					Replace cant With cant - ncant In lcanjes
				Else
					If lcanjes.cant - Int(lcanjes.cant) > 0
						ncant = (nmontob - nimporte) / lcanjes.Precio
						nimporte = nimporte + (ncant * lcanjes.Precio)
						Insert Into vtas2(Descri, Unid, cant, Prec, Coda, idco, Auto, Ndoc, Nitem, comi, IDautoP, costo)Values(lcanjes.Descri, lcanjes.Unid, ncant, lcanjes.Precio, lcanjes.idart, 0, x, cdcto, F, 0, 0, lcanjes.costo)
						Replace cant With cant - ncant In lcanjes
					Else
						For i = 1 To This.Nitems - F
							Insert Into vtas2(Ndoc, Nitem, Auto)Values(cdcto, i, x)
						Next
						F = 1
						x = x + 1
						cn = cn + 1
						nimporte = 0
						cdcto = This.Serie + Right("0000000" + Alltrim(Str(cn)), 8)
					Endif
				Endif
				Select (ccursor)
				Loop
			Endif
		Endif
		Select (ccursor)
		Skip
	Enddo
	nit = F
	For i = 1 To This.Nitems - F
		nit = nit + 1
		Insert Into vtas2(Ndoc, Nitem, Auto)Values(cdcto, nit, x)
	Next
*!*		Select * From vtas2 Into Table Addbs(Sys(5) + Sys(2003)) + 'canjes'
	Return 1
	Endfunc
	Function Generacanjes()
	Sw = 1
	If This.idsesion > 0 Then
		Set DataSession To This.idsesion
	Endif
	Set Procedure To d:\capass\modelos\correlativos, d:\capass\modelos\ctasxcobrar Additive
	ocorr = Createobject("correlativo")
	octascobrar = Createobject("ctasporcobrar")
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	nidrv = This.registracanjes()
	If nidrv < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select xvtas
	Go Top
	Do While !Eof()
		If This.registradctocanjeado(nidrv) < 1 Then
			Sw = 0
			Exit
		Endif
		ocorr.Ndoc = xvtas.Ndoc
		ocorr.Nsgte = This.Nsgte
		ocorr.Nsgte = Val(Substr(xvtas.Ndoc, 5))
		ocorr.Idserie = This.Idserie
		If ocorr.GeneraCorrelativo() < 1  Then
			This.Cmensaje = ocorr.Cmensaje
			Sw = 0
			Exit
		Endif
		Select xvtas
		Skip
	Enddo
	If Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.actualizaCanjespedidos(nidrv) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	This.imprimircanjes()
	Return 1
	Endfunc
	Function registracanjes()
	lc = 'funingrecanjesvtas'
	goApp.npara1 = This.Fecha
	goApp.npara2 = This.Importe
	goApp.npara3 = This.nvtas
	goApp.npara4 = This.fechai
	goApp.npara5 = This.fechaf
	goApp.npara6 = goApp.nidusua
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
	ENDTEXT
	nidr = This.EJECUTARf(lc, lp, 'cvtx')
	If nidr < 0 Then
		Return 0
	Endif
	Return nidr
	Endfunc
	Function registradctocanjeado(nidrv)
	If This.idsesion > 0 Then
		Set DataSession To  This.idsesion
	Endif
	cTdoc = This.Tdoc
	cform = 'E'
	cndoc = xvtas.Ndoc
	Nv = Round(xvtas.Importe / fe_gene.igv, 2)
	nigv = Round(xvtas.Importe - Round(xvtas.Importe / fe_gene.igv, 2), 2)
	Nt = xvtas.Importe
	ccodp = This.Codigo
	cmvtoc = "I"
	cdeta = 'Canje  ' + Dtoc(This.fechai) + '-' + ' Hasta ' + Dtoc(This.fechaf)
	cdetalle = ''
	nidusua = goApp.nidusua
	nidtda = goApp.Tienda
	NAuto = This.IngresaResumenDctocanjeado(This.Tdoc, cform, xvtas.Ndoc, This.Fecha, This.Fecha, cdeta, Nv, nigv, Nt, '', 'S', fe_gene.dola, fe_gene.igv, 'k', This.Codigo, 'V', goApp.nidusua, 1, goApp.Tienda, fe_gene.idctav, fe_gene.idctai, fe_gene.idctat, '', nidrv)
	If NAuto < 1 Then
		Return 0
	Endif
	If IngresaDatosLCajaEFectivo11(This.Fecha, "", This.razon, fe_gene.idctat, Nt, 0, 'S', fe_gene.dola, 0, This.Codigo, NAuto, cform, cndoc, This.Tdoc) < 1 Then
		Return 0
	Endif
	If IngresaRvendedores(NAuto, This.Codigo, 4, cform) < 1 Then
		Return 0
	Endif
	If cform <> 'E' Then
		If ctasporcobrar.IngresaCreditosNormalFormaPago(NAuto, This.Codigo, cndoc, 'C', 'S', "", This.Fecha, This.Fecha, 'B', cndoc, Nt, 0, 0, Nt, goApp.nidusua, goApp.Tienda, Id(), 'C')
			Return 0
		Endif
	Endif
	Local sws As Integer
	ccodv = 4
	sws = 1
	Select vtas2
	If This.tipocanje = 'I' Then
	Else
		Set Filter To Auto = xvtas.Auto And Coda > 0
	Endif
	ccursor = 'vtas2'
	Go Top
	Do While !Eof()
		If INGRESAKARDEX1(NAuto, Coda, "V", Prec, cant, "I", "K", ccodv, 0, costo, comi) < 1 Then
			sws = 0
			This.Cmensaje = 'Al Registrar Item ' + Alltrim(Descri)
			Exit
		Endif
		Select (ccursor)
		Skip
	Enddo
	If sws = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function imprimircanjes()
	dFech = This.Fecha
	ncodc = This.Codigo
	cguia = ""
	cdire = ""
	Cdni = ""
	cforma = 'Efectivo'
	Cfono = ""
	Cvendedor = 'Oficina'
	ndias = 0
	crazo = '-'
	Cruc = ""
	chash = ""
	cArchivo = ""
	dfvto = This.Fecha
	cptop = goApp.Direccion
	cContacto = ""
	Npedido = ""
	cdetalle = ""
	cTdoc = This.Tdoc
	If This.tipocanje <> 'I' Then
		Select Descri  As Desc, Unid, cant, Prec, Ndoc, '' As Modi, Coda, cletras, chash As hash, dFech As fech, ncodc As codc, cguia As Guia, ;
			cdire As Direccion, Cdni As dni, cforma As Forma, Cfono As fono, Cvendedor As Vendedor, ndias As dias, crazo As razon, cTdoc As Tdoc, ;
			Cruc As nruc, 'S' As Mone, cguia As Ndo2, cforma As Form, 'I' As IgvIncluido, cdetalle As Detalle, cContacto As Contacto, cArchivo As Archivo, ;
			dfvto As fechav, valor, igv, Total, '' As copia, cptop As ptop,0 As vuelto;
			From vtas2 Into Cursor tmpv Readwrite
	Else
		cndoc = This.Serie + This.numero
		cletras = Diletras(This.Importe, 'S')
		Select Desc, Unid, cant, Prec, cndoc As Ndoc, '' As Modi, Coda, cletras, chash As hash, dFech As fech, ncodc As codc, cguia As Guia, ;
			cdire As Direccion, Cdni As dni, cforma As Forma, Cfono As fono, Cvendedor As Vendedor, ndias As dias, crazo As razon, cTdoc As Tdoc, ;
			Cruc As nruc, 'S' As Mone, cguia As Ndo2, cforma As Form, 'I' As IgvIncluido, cdetalle As Detalle, cContacto As Contacto, cArchivo As Archivo, ;
			dfvto As fechav, This.valor As valor, This.igv As  igv, This.Monto As Total, '' As copia, cptop As ptop,0 As vuelto;
			From vtas2  Into Cursor tmpv Readwrite
		titem = _Tally
		nit = titem
		For i = 1 To This.Nitems - titem
			nit = nit + 1
			Insert Into vtas2(Ndoc, Nitem)Values(cndoc, nit)
		Next
	Endif
	titem = _Tally
	Go Top In tmpv
	goApp.IgvIncluido = 'I'
	Set Procedure To Imprimir Additive
	obji = Createobject("Imprimir")
	If goApp.ImpresionTicket = 'S'  Then
		obji.Tdoc = This.Tdoc
		obji.ElijeFormato()
		If This.Tdoc = '01' Or This.Tdoc = '03' Or This.Tdoc = '20'  Then
			Select * From tmpv Into Cursor copiaor Readwrite
			Replace All copia With 'Z' In copiaor
			Select tmpv
			Append From Dbf("copiaor")
		Endif
		Select tmpv
		Set Filter To !Empty(Coda)
		Go Top
		obji.ImprimeComprobanteComoTicket('S')
		Set Filter To copia <> 'Z'
		Go Top
	Else
		Do Case
		Case This.Tdoc = '01'
			If Left(tmpv.Ndoc, 4) = "F008" Or Left(tmpv.Ndoc, 4) = "B008" Then
				Report Form factural1 To Printer Prompt Noconsole
			Else
				Report Form factural To Printer Prompt Noconsole
			Endif
		Case This.Tdoc = '03'
			If Left(tmpv.Ndoc, 4) = "F008" Or Left(tmpv.Ndoc, 4) = "B008" Then
				Report Form boletal1 To Printer Prompt Noconsole
			Else
				Report Form boletal To Printer Prompt Noconsole
			Endif
		Case This.Tdoc = '20'
			cArchivo = Addbs(Addbs(Sys(5) + Sys(2003)) + fe_gene.nruc) + 'notasp.frx'
			If File(cArchivo) Then
				Report Form (cArchivo) To Printer Prompt Noconsole
			Else
				Report Form (goApp.reporte) To Printer Prompt Noconsole
			Endif
		Endcase
	Endif
	Endfunc
	Function actualizaCanjespedidos(nidrv)
	vd = 1
	Select ldx
	Scan All
		TEXT To ulcx Noshow  Textmerge
           UPDATE fe_rcom SET rcom_idtr=<<nidrv>> where idauto=<<ldx.idauto>>
		ENDTEXT
		If This.Ejecutarsql(ulcx) < 1 Then
			vd = 0
			Exit
		Endif
	Endscan
	If vd = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaResumenDctocanjeado(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24)
	lc = 'FunIngresaCabeceravtascanjeado'
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
	TEXT To lparametros Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24)
	ENDTEXT
	nida = This.EJECUTARf(lc, lparametros, cur)
	If nida < 1 Then
		Return 0
	Endif
	Return nida
	Endfunc
	Function mostrarventaporid(niDAUTO, ccursor)
	If This.idsesion > 1 Then
		Set DataSession To This.idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\  Select  a.kar_Cost,	  c.idusua,a.kar_comi  As kar_comi,	  a.Codv,ifnull(m.Fevto,c.fech) As fvto,
	\  a.Idauto    As Idauto,	  c.codt      As alma,	  a.kar_idco  As idcosto,	  a.idkar     As idkar,
	\  a.idart     As Coda,	  a.cant      As cant,	  a.Prec      As Prec,	  c.valor     As valor,c.rcom_exon,
	\  c.igv       As igv,	  c.Impo      As Impo,	  c.fech      As fech, c.fecr      As fecr,	  c.Form ,	  c.Deta,
	\  c.exon      As exon,	  c.Ndo2      As Ndo2,	  c.rcom_entr As rcom_entr,	  c.idcliente As idclie,	  d.razo,	  d.nruc,
	\  d.Dire      As Dire,	  d.ciud      As ciud,	  d.ndni,	  a.tipo,	  c.Tdoc      As Tdoc,	  c.Ndoc,	  c.dolar,c.Mone,	  b.Descri    As Descri,
	\  IFNULL(xx.idcaja,0) As idcaja,	  b.Unid      As Unid,	  b.premay    As pre1,	  b.tipro     As tipro,
	\  b.peso      As peso,	  b.premen    As pre2,	  IFNULL(z.vend_idrv,0) As nidrv,	  c.vigv      As vigv,	  a.dsnc      As dsnc, a.dsnd      As dsnd,	  a.gast      As gast, c.idcliente As idcliente,
	\  c.codt      As codt, b.pre3      As pre3,	  b.cost      As costo,  b.uno       As uno,	  b.Dos       As Dos,b.tre,b.cua,	  (b.uno + b.Dos+b.tre+b.cua) As TAlma,
	\  c.fusua     As fusua,  p.nomv      As Vendedor,	  q.nomb      As usuario,	  a.Incl      As Incl,	  c.rcom_mens As rcom_mens,rcom_idtr
	If goApp.Prodexo = 'S' Then
	\,kar_tigv
	Endif
	\From fe_art b
    \INNER Join fe_kar a  On a.idart = b.idart
    \INNER  Join fe_rcom c On a.Idauto = c.Idauto
    \Left Join fe_caja xx   On xx.Idauto = c.Idauto
    \INNER Join fe_clie d  On c.idcliente = d.idclie
    \INNER  Join fe_vend p      On p.idven = a.Codv
    \INNER Join fe_usua q     On q.idusua = c.idusua
    \Left Join (Select vend_idau,vend_idrv From fe_rvendedor Where vend_acti='A') As z  On z.vend_idau = c.Idauto
    \Left Join (Select rcre_idau,Min(c.Fevto) As Fevto From fe_rcred As r inner Join fe_cred As c On c.cred_idrc=r.rcre_idrc
    \Where rcre_acti='A' And Acti='A' And rcre_idau=<<nidauto>> Group By rcre_idau) As m On m.rcre_idau=c.Idauto
    \Where c.Acti <> 'I'   And a.Acti <> 'I' And c.Idauto=<<niDAUTO>> Order By idkar
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function resumenventaspsysl(ccursor)
	If This.fechaf-This.fechai>31 Then
		This.Cmensaje='Hasta 31 Días'
		Return 0
	Endif
	dfi = Cfechas(This.fechai)
	dff = Cfechas(This.fechaf)
	If This.idsesion > 1 Then
		Set DataSession To This.idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select a.Ndoc As dcto, a.fech, b.razo, If(Mone = 'S', 'SOLES', 'DOLARES') As Moneda, a.valor, a.rcom_exon, Cast(0 As Decimal(12,2)) As inafecto,
	\a.igv, a.Impo, rcom_hash, rcom_mens, Mone, a.Tdoc, a.Ndoc, Idauto, rcom_arch, b.clie_corr, b.nruc, b.fono, tcom
	\From fe_rcom As a
	\Join fe_clie As b On (a.idcliente = b.idclie)
	\Where a.fech Between '<<dfi>>' And '<<dff>>'  And a.Acti <> 'I'
	If This.codt > 0 Then
	 \ And a.codt=<<This.codt>>
	Endif
	If Len(Alltrim(This.Tdoc)) > 0 Then
	\ And a.Tdoc='<<this.Tdoc>>'
	Endif
    \Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Generatmpvtas(Calias, cdcto, nforma)
	Set Procedure To d:\capass\modelos\productos Additive
	oProductos = Createobject("producto")
	Create Cursor vtas2(Descri c(100), Unid c(4), cant N(10, 2), Prec N(13, 5), Coda N(8), idco N(13, 5), Auto N(5), ;
		Ndoc c(12), Nitem N(3), comi N(7, 4), cletras c(150), Cantidad N(10, 2), IDautoP N(10), costo N(12, 6), ;
		valor N(12, 2), igv N(12, 2), Total N(12, 2), tipro c(1), copia c(1) Default '', Tdoc c(2))
	Select * From (Calias) Into Cursor tpx
	Go Top
	x = 1
	F = 0
	sws = 1
	Cserie = Left(cdcto, 4)
	Cmensaje = ""
	cn = Val(Substr(cdcto, 5))
	Do While !Eof()
		If F > This.Nitems Then
			F = 1
			x = x + 1
			cn = cn + 1
			cdcto = Cserie + Right("0000000" + Alltrim(Str(cn)), 8)
		Endif
		F = F + 1
		If goApp.alma_nega = 0 Then
			If tpx.tipro <> 'S' Then
				oProductos.nidart = tpx.Coda
				If .oProductos.devStocks("st") < 1 Then
					sws = 0
					m.Cmensaje = ""
					Exit
				Endif
				If cant <= Iif(goApp.Tienda = 1, st.uno, Iif(goApp.Tienda = 2, st.Dos, Iif(goApp.Tienda = 3, st.tre, Iif(goApp.Tienda = 4, st.cua, Iif(goApp.Tienda = 5, st.cin, st.sei)))))
					Insert Into vtas2(Descri, Unid, cant, Prec, Coda,  Auto, Ndoc, Nitem, comi, IDautoP, costo, tipro)Values(tpx.Desc, ;
						tpx.Unid, tpx.cant, tpx.Prec, tpx.Coda, x, cdcto, F, Iif(tpx.como > 0, tpx.como, Iif(m.nforma = 1, tpx.come, tpx.Comc)), tpx.IDautoP, tpx.costo, tpx.tipro)
				Else
					m.Cmensaje = "EL Item: " + Alltrim(Descri) + " Sin Disponibilidad:"
					sws = 0
				Endif
			Else
				Insert Into vtas2(Descri, Unid, cant, Prec, Coda, Auto, Ndoc, Nitem, comi, IDautoP, costo, tipro)Values(tpx.Desc, ;
					tpx.Unid, tpx.cant, tpx.Prec, tpx.Coda,  x, cdcto, F, Iif(tpx.como > 0, tpx.como, Iif(m.nforma = 1, tpx.come, tpx.Comc)), tpx.IDautoP, tpx.costo, tpx.tipro)
			Endif
		Else
			Insert Into vtas2(Descri, Unid, cant, Prec, Coda, Auto, Ndoc, Nitem, comi, IDautoP, costo, tipro)Values(tpx.Desc, ;
				tpx.Unid, tpx.cant, tpx.Prec, tpx.Coda, x, cdcto, F, Iif(tpx.como > 0, tpx.como, Iif(m.nforma = 1, tpx.come, tpx.Comc)), tpx.IDautoP, tpx.costo, tpx.tipro)
		Endif
		Select tpx
		Skip
	Enddo
	If sws = 0 Then
		This.Cmensaje = Iif(Empty(Cmensaje), This.Cmensaje, m.Cmensaje)
		Return 0
	Endif
	nit = F
	For i = 1 To This.Nitems - F
		nit = nit + 1
		Insert Into vtas2(Ndoc, Nitem, Auto)Values(cdcto, nit, x)
	Next
	Return 1
	Endfunc
	Function GrabarvtaCanje
	Local Sw As Integer
	Set Classlib To d:\Librerias\fe.vcx Additive
	ofe = Createobject("comprobante")
	If VerificaAlias("cabecera") = 1 Then
		Zap In cabecera
	Else
		Create Cursor cabecera(idcab N(8))
	Endif
	Set Procedure To CapaDatos, ple5, d:\capass\modelos\correlativos, d:\capass\modelos\cotizacion.prg Additive
	ocorr = Createobject("correlativo")
	ocoti = Createobject("cotizacion")
	Select IDautoP From vtas2 Where IDautoP > 0 Into Cursor xlp Group By IDautoP
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	Sw = 1
	Select xvtas
	Go Top
	Do While !Eof()
		This.Serie = Left(xvtas.Ndoc, 4)
		This.numero = Substr(xvtas.Ndoc, 5)
		This.igv = Round(xvtas.Importe - Round(xvtas.Importe / fe_gene.igv, 2), 2)
		This.valor = Round(xvtas.Importe / fe_gene.igv, 2)
		This.Monto = xvtas.Importe
		If This.grabacabeceradcto() = 0 Then
			This.DEshacerCambios()
			Sw = 0
			Exit
		Endif
		ocorr.Ndoc = xvtas.Ndoc
		ocorr.Nsgte = This.Nsgte
		ocorr.Nsgte = Val(Substr(xvtas.Ndoc, 5))
		ocorr.Idserie = This.Idserie
		If ocorr.GeneraCorrelativo() < 1  Then
			This.Cmensaje = ocorr.Cmensaje
			Sw = 0
			Exit
		Endif
		Select xvtas
		Skip
	Enddo
	If Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select xlp
	Scan All
		If ocoti.CamnbiaraFacturado(xlp.IDautoP) < 1 Then
			This.Cmensaje = ocoti.Cmensaje
			Sw = 0
			Exit
		Endif
	Endscan
	If Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	If  goApp.EmisionElectronica = 'S' Then
		ofe.Version = '2.1'
		Try
			Select cabecera
			Scan All
				Do Case
				Case  This.Tdoc = '01'
					Vdvto = ofe.obtenerdatosfactura(cabecera.idcab, Iif(fe_gene.gene_cpea = 'N', 'SF', .F.))
				Case This.Tdoc = "03"
					Vdvto = ofe.obtenerdatosBoleta(cabecera.idcab, 'SF') = 0
				Endcase
			Endscan
		Catch To oErr When oErr.ErrorNo = 1429
			This.Cmensaje = oErr.Message
		Catch To oErr When oErr.ErrorNo = 1924
			This.Cmensaje = oErr.Message
		Finally
		Endtry
	Endif
	This.imprimirdctovtas('vtas2')
	Zap In cabecera
	Return 1
	Endfunc
	Function grabacabeceradcto()
	Set Procedure To d:\capass\modelos\productos, d:\capass\modelos\regkardex, d:\capass\modelos\ctasxcobrar Additive
	ocred = Createobject("ctasporcobrar")
	ocorr = Createobject("correlativo")
	If This.Tdoc = '01' Or This.Tdoc = '03' Then
		nidcta1 = fe_gene.idctav
		nidcta2 = fe_gene.idctai
		nidcta3 = fe_gene.idctat
	Else
		nidcta1 = 0
		nidcta2 = 0
		nidcta3 = 0
	Endif
	NAuto = IngresaResumenDcto(This.Tdoc, Left(This.formaPago, 1),  This.Serie + This.numero, ;
		This.Fecha, This.Fecha, This.Detalle, This.valor, This.igv, This.Monto, This.NroGuia, 'S', ;
		fe_gene.dola, fe_gene.igv, 'k', This.Codigo, 'V',  goApp.idcajero, 1, goApp.Tienda, nidcta1, nidcta2, nidcta3, 0, 0)
	If NAuto = 0 Then
		Return 0
	Endif
	If goApp.EmisionElectronica = 'S'  Then
		If IngresaDatosLCajaEFectivo12(This.Fecha, "", This.razon, nidcta3, This.Monto, 0, 'S', fe_gene.dola, goApp.idcajero, This.Codigo, NAuto, Left(This.formaPago, 1), This.Serie + This.numero, This.Tdoc, goApp.Tienda) = 0 Then
			Return 0
		Endif
	Else
		nidcon = RetConcepto(This.Tdoc + Left(This.formaPago, 1), 'I')
		If nidcon > 0 Then
			If IngresaCaja(NAuto, This.Fecha, This.Monto, 'I', This.formaPago, 'S', This.Serie + This.numero, nidcon, goApp.idcajero, This.Monto, 'CK', Nt, 'S', fe_gene.dola, goApp.Tienda, '', 0, 0) <= 0 Then
				Return 0
			Endif
		Endif
	Endif
	If Left(This.formaPago, 1) = 'E' Then
		If IngresaRvendedores(NAuto, This.Codigo, This.Vendedor, Left(This.formaPago, 1)) = 0 Then
			Return 0
		Endif
	Endif
	If Left(This.formaPago, 1) <> 'E' Then
		ocred.cformapago = Left(This.formaPago, 1)
		ocred.nidclie = This.Codigo
		ocred.Cmoneda = "S"
		ocred.cndoc = This.Serie + This.numero
		ocred.Ctipo = 'C'
		ocred.dFech = This.Fecha
		ocred.cdetalle = This.Detalle
		ocred.Fechavto = This.Fechavto
		ocred.tipodcto = Left(This.Serie, 1)
		ocred.Codv = This.Vendedor
		ocred.nimpoo = This.Monto
		ocred.nimpo = This.Monto
		ocred.crefe = This.Serie + This.numero
		ocred.Idauto = m.NAuto
		If ocred.IngresaCreditosNormalFormaPago1() < 1 Then
			This.Cmensaje = ocred.Cmensaje
			Return 0
		Endif
	Endif
	Local sws As Integer
	sws = 1
	Na = NAuto
	Cmensaje = ""
	ncomi = 0
	opro = Createobject("producto")
	okar = Createobject("regkardex")
	okar.ncosto = vtas2.costo
	okar.nidtda = goApp.Tienda
	okar.niDAUTO = m.NAuto
	okar.nidv = This.Vendedor
	okar.Ctipo = 'V'
	okar.cincl = 'I'
	okar.ctmvto = 'K'
	Select vtas2
	Set Filter To Auto = xvtas.Auto And Coda > 0
	Go Top
	Do While !Eof()
		If vtas2.Prec <= vtas2.costo Then
			ncomi = 0
		Else
			ncomi = vtas2.comi
		Endif
		opro.nidart = vtas2.Coda
		okar.ncoda = vtas2.Coda
		okar.ncant = vtas2.cant
		okar.nprec = vtas2.Prec
		okar.ncomi = m.ncomi
		If goApp.alma_nega = 0 Then
			If vtas2.tipro <> 'S' Then
				If opro.verificaStocks(vtas2.cant, goApp.Tienda) < 1 Then
					sws = 0
					Cmensaje = opro.Cmensaje
					Exit
				Endif
				If okar.INGRESAKARDEX1() < 1 Then
					sws = 0
					Cmensaje =okar.Cmensaje
					Exit
				Endif
				If opro.ActualizaStock(vtas2.Coda, goApp.Tienda, vtas2.cant, 'V') < 1  Then
					sws = 0
					Cmensaje = opro.Cmensaje
					Exit
				Endif
			Endif
		Else
			If okar.INGRESAKARDEX1() < 1 Then
				sws = 0
				Cmensaje = okar.Cmensaje
				Exit
			Endif
			If opro.ActualizaStock(vtas2.Coda, goApp.Tienda, vtas2.cant, 'V') < 1 Then
				sws = 0
				Cmensaje = opro.Cmensaje
				Exit
			Endif
		Endif
		Select vtas2
		Skip
	Enddo
	If sws = 0 Then
		Return 0
	Endif
	Select xlp
	Scan All
		If GrabaCanjesPedidos(NAuto, xlp.IDautoP) = 0
			sws = 0
			Exit
		Endif
	Endscan
	If sws = 0 Then
		Return 0
	Endif
	If sws = 1 Then
		Insert Into cabecera(idcab)Values(NAuto)
		Return 1
	Else
		Return 0
	Endif
	Endfunc
	Function imprimirdctovtas(Calias)
	dFech = This.Fecha
	cptop = goApp.Direccion
	goApp.IgvIncluido = 'I'
	Select Descri  As Desc, Unid, cant, Prec, Ndoc,  Coda, cletras, '' As hash, dFech As fech, This.NroGuia As Guia, ;
		Alltrim(This.Cdireccion) + ' ' + Alltrim(This.Cciudad)  As Direccion, This.dni As dni, This.formaPago As Forma, This.Cfono As fono, This.Cvendedor As Vendedor, This.dias As dias, This.razon As razon, This.Tdoc As Tdoc, ;
		This.Ruc  As nruc, 'S' As Mone, This.NroGuia As Ndo2, This.formaPago As Form, 'I' As IgvIncluido, This.Detalle As Detalle, '' As Contacto, ;
		0.00 As exonerado, dFech As fechav, valor, igv, Total, '' As copia, cptop As ptop, This.Codigo As codc,0 As vuelto;
		From vtas2 Into Cursor tmpv Readwrite
	Set Procedure To Imprimir Additive
	obji = Createobject("Imprimir")
	obji.Tdoc = This.Tdoc
	obji.ElijeFormato()
	If goApp.ImpresionTicket = 'S'  Then
		If This.Tdoc = '01' Or This.Tdoc = '03' Or This.Tdoc = '20'  Then
			Select * From tmpv Into Cursor copiaor Readwrite
			Replace All copia With 'Z' In copiaor
			Select tmpv
			Append From Dbf("copiaor")
		Endif
		Select tmpv
		Set Filter To !Empty(Coda)
		Go Top
		obji.ImprimeComprobanteComoTicket('S')
		Set Filter To copia <> 'Z'
		Go Top
	Else
		obji.ImprimeComprobanteM('S')
		Select tmpv
		Go Top
	Endif
	Endfunc
	Function consultardctoparaimprimir(np1,np2,np3,ccursor)
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	Do Case
	Case np2 = '01' Or np2 = '03' Or np2 = '20'
		If np3='S' Then
			TEXT To lC Noshow Textmerge Pretext 7
			    select rcom_codv AS codv,c.idauto,c.codt AS alma,m.detv_ite1 AS idkar,m.detv_ite1 AS idart,detv_cant AS cant,
			    detv_prec AS prec,tdoc AS tdoc1,
			    c.ndoc AS dcto,c.fech AS fech1,c.vigv,IFNULL(p.fevto,c.fech) AS fvto,valor,c.igv,impo,
		   	    c.fech,c.fecr,c.form,c.deta,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,c.pimpo,u.nomb AS usuario,d.clie_conta,
			    c.tdoc,c.ndoc,c.dolar AS dola,c.mone,m.detv_desc AS descri,detv_unid AS unid,c.rcom_hash,v.nomv,c.impo,rcom_arch,rcom_mret,IFNULL(t.nomb,f.ptop) AS ptop,rcom_detr,
			    rcom_mdet,CAST(0 as decimal(10,2)) as vuelto
			    FROM fe_rcom as c
			    inner join (select detv_idau,detv_cant,detv_prec,detv_desc,detv_unid,detv_ite1 from fe_detallevta where detv_acti='A') as m on m.detv_idau=c.idauto
			    inner join fe_clie as d on(d.idclie=c.idcliente)
			     inner join fe_vend as v on v.idven=c.rcom_codv
			    inner join fe_usua as u on u.idusua=c.idusua
			    left join fe_sucu as t on t.idalma=c.codt
                left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r inner join fe_cred as c on c.cred_idrc=r.rcre_idrc
                where rcre_acti='A' and acti='A' and rcre_idau=<<np1>> group by rcre_idau) as p on p.rcre_idau=c.idauto,fe_gene as f
			    where c.idauto=<<np1>>;
			ENDTEXT
		Else
			Set Textmerge On
			Set Textmerge To Memvar lc Noshow Textmerge
			\Select a.Codv,a.Idauto,a.alma,a.idkar,a.idart,a.cant,a.Prec,c.Tdoc As tdoc1,
			\c.Ndoc As dcto,c.fech As fech1,c.vigv,ifnull(p.fevto,c.fech) As fvto,valor,c.igv,Impo,
			\c.fech,c.fecr,c.Form,c.Deta,c.rcom_exon,c.Ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.Dire,d.ciud,d.ndni,c.pimpo,u.nomb As usuario,d.clie_conta,
			\c.Tdoc,c.Ndoc,c.dolar As dola,c.Mone,b.Descri,b.Unid,c.rcom_hash,v.nomv,c.Impo,rcom_arch,rcom_mret,ifnull(T.nomb,F.ptop) As ptop,rcom_detr,
			\Cast(0 As Decimal(10,2)) As rcom_mdet
			IF fe_gene.nruc='20480172150' then
			 \,c.rcom_vuelto as vuelto
			ELSE 
			 \,CAST(0 as decimal(10,2)) as vuelto
			ENDIF 
			\From fe_kar As a
			\inner Join fe_rcom As c On(c.Idauto=a.Idauto)
			\inner Join fe_clie As d On(d.idclie=c.idcliente)
			\inner Join fe_art As b On(b.idart=a.idart)
			\inner Join fe_vend As v On v.idven=a.Codv
			\inner Join fe_usua As u On u.idusua=c.idusua
			\Left Join fe_sucu As T On T.idalma=c.codt
			\Left Join (Select rcre_idau,Min(c.fevto) As fevto From fe_rcred As r
			\inner Join fe_cred As c On c.cred_idrc=r.rcre_idrc
			\Where rcre_acti='A' And Acti='A' And rcre_idau=<<np1>> Group By rcre_idau) As p On p.rcre_idau=c.Idauto,fe_gene As F
			\Where c.Idauto=<<np1>> And a.Acti='A'
			Set  Textmerge Off
			Set Textmerge To
		Endif
	Case np2 = '08'
		TEXT To lC Noshow Textmerge Pretext 7
			   select r.idauto,r.ndoc,r.tdoc,r.fech,r.mone,abs(r.valor) as valor,r.rcom_exon,r.ndo2,r.fech as fvto,
		       r.vigv,c.nruc,c.razo,c.dire,c.ciud,c.ndni,' ' as nomv,r.form,r.rcom_arch,
		       abs(r.igv) as igv,abs(r.impo) as impo,ifnull(k.cant,CAST(0 as decimal(12,2))) as cant,c.clie_conta,r.idcliente,
		       ifnull(k.prec,ABS(r.impo)) as prec,LEFT(r.ndoc,4) as serie,SUBSTR(r.ndoc,5) as numero,
		       ifnull(a.unid,'') as unid,ifnull(a.descri,r.deta) as descri,r.deta,ifnull(k.idart,CAST(0 as decimal(8))) as idart,w.ndoc as dcto,
		       w.fech as fech1,w.tdoc as tdoc1,r.rcom_hash,u.nomb as usuario,r.rcom_mret,ifnull(t.nomb,ff.ptop) as ptop,r.rcom_detr,
		       CAST(0 As decimal(10,2)) As rcom_mdet,CAST(0 as decimal(10,2)) as vuelto
		       from fe_rcom r
		       inner join fe_clie c on c.idclie=r.idcliente
		       left join fe_kar k on k.idauto=r.idauto
		       left join fe_art a on a.idart=k.idart
		       inner join fe_ncven f on f.ncre_idan=r.idauto
		       inner join fe_rcom as w on w.idauto=f.ncre_idau
		       inner join fe_usua as u on u.idusua=r.idusua
		       left join fe_sucu as t on t.idalma=r.codt,fe_gene as ff
		       where r.idauto=<<np1>> and r.acti='A' and r.tdoc='08'
		ENDTEXT
	Case np2 = '07'
		If  Vartype(np3) = 'C' Then
			cx = np3
		Endif
		If cx = 'S' Then
			TEXT To lC Noshow Textmerge Pretext 7
			select 4 as codv,c.idauto,detv_ite1 as idart,ABS(detv_cant) as cant,detv_prec as prec,c.codt as alma,
			c.fech as fech1,c.vigv,c.rcom_icbper as Ticbper,abs(c.valor) as valor,ABS(c.igv) as igv,
			c.fech,c.fecr,c.form,ABS(c.rcom_exon) as rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,
			c.pimpo,u.nomb as usuario,c.deta,LEFT(c.ndoc,4) as serie,SUBSTR(c.ndoc,5) as numero,'' as prod_cod1,
			c.tdoc,c.ndoc,c.dolar as dola,c.mone,m.detv_desc as descri,m.detv_unid as Unid,c.fech as fvto,c.rcom_arch,
			c.rcom_hash,'Oficina' as nomv,abs(c.impo) as impo,w.ndoc as dcto,clie_corr,c.rcom_detr,d.clie_conta,
			w.fech as fech1,w.tdoc as tdoc1,c.tcom as tipovta,c.fech as fvto,CAST(0 as decimal(12,2)) as acta,d.fono,
			c.rcom_mdet,c.fusua,CAST(0 as decimal(12,2)) as costo,CAST(0 AS DECIMAL(10,2)) AS totalanticipo,CAST(0 AS DECIMAL(10,2)) AS valorganticipo,
			ifnull(t.nomb,ff.ptop) as ptop,CAST(0 As decimal(10,2)) As rcom_mdet,c.rcom_mret,CAST(0 as decimal(10,2)) as vuelto
			FROM fe_rcom as c
			inner join fe_clie as d on(d.idclie=c.idcliente)
			inner join fe_usua as u on u.idusua=c.idusua
			inner join (select detv_idau,detv_cant,detv_prec,detv_desc,detv_unid,detv_ite1 from fe_detallevta where detv_acti='A') as m on m.detv_idau=c.idauto
			inner join fe_ncven f on f.ncre_idan=c.idauto
			inner join fe_rcom as w on w.idauto=f.ncre_idau
		    left join fe_sucu as t on t.idalma=c.codt,fe_gene as ff
			where c.idauto=<<np1>>
			ENDTEXT
		Else
			TEXT To lC Noshow Textmerge Pretext 7
			   select r.idauto,r.ndoc,r.tdoc,r.fech,r.mone,abs(r.valor) as valor,ABS(r.rcom_exon) as rcom_exon,r.ndo2,
		       r.vigv,c.nruc,c.razo,c.dire,c.ciud,c.ndni,' ' as nomv,r.form,u.nomb as usuario,r.fech as fvto,
		       abs(r.igv) as igv,abs(r.impo) as impo,ifnull(k.cant,CAST(0 as decimal(12,2))) as cant,r.rcom_arch,
		       ifnull(k.prec,ABS(r.impo)) as prec,LEFT(r.ndoc,4) as serie,SUBSTR(r.ndoc,5) as numero,c.clie_conta,r.idcliente,
		       ifnull(a.unid,'') as unid,ifnull(a.descri,r.deta) as descri,r.deta,ifnull(k.idart,CAST(0 as decimal(8))) as idart,w.ndoc as dcto,
		       w.fech as fech1,w.tdoc as tdoc1,r.rcom_hash,r.rcom_mret,ifnull(t.nomb,ff.ptop) as ptop,r.rcom_detr,CAST(0 As decimal(10,2)) As rcom_mdet,CAST(0 as decimal(10,2)) as vuelto
		       from fe_rcom r
		       inner join fe_clie c on c.idclie=r.idcliente
		       left join fe_kar k on k.idauto=r.idauto
		       left join fe_art a on a.idart=k.idart
		       inner join fe_ncven f on f.ncre_idan=r.idauto
		       inner join fe_rcom as w on w.idauto=f.ncre_idau
		       inner join fe_usua as u on u.idusua=r.idusua
		       left join fe_sucu as t on t.idalma=r.codt,fe_gene as ff
		       where r.idauto=<<np1>> and r.acti='A' and r.tdoc='07'
			ENDTEXT
		Endif
	Endcase
	If This.ejecutaconsulta(lc, ccursor) < 1  Then
		RETURN 0
	Endif
	Return 1
	Endfunc
Enddefine

































