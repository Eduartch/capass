Define Class Rboletas As OData Of 'd:\capass\database\data.prg'
	todos = 0
	dfecha = Date()
	cTdoc = ""
	Cserie = ""
	ndesde = 0
	nhasta = 0
	nimpo = 0
	nvalor = 0
	nexon = 0
	ninafectas = 0
	nigv = 0
	ngrati = 0
	cxml = ""
	chash = ""
	cfile = ""
	estado = ""
	cticket = ""
	crespuesta = ""
	ncodt = 0
	nidr = 0
	cfilecdr = ""
	soloporenviar = ""
*curb.fech, curb.Tdoc, curb.Serie, curb.desde, curb.hasta, curb.Impo, curb.valor, curb.Exon, curb.inafectas, curb.igv, curb.gratificaciones,  carxml, crhash, goApp.cArchivo, cresp
	conmensajerapido = ""
	Function ConsultaBoletasyNotasporenviar(f1, f2)
	Local lC
	Text To lC Noshow Textmerge
	    SELECT resu_fech,enviados,resumen,resumen-enviados,enviados-resumen
		FROM(SELECT resu_fech,CAST(SUM(enviados) AS DECIMAL(12,2)) AS enviados,CAST(SUM(resumen) AS DECIMAL(12,2))AS resumen FROM(
		SELECT resu_fech,CASE tipo WHEN 1 THEN resu_impo ELSE 0 END AS enviados,
		CASE tipo WHEN 2 THEN resu_impo ELSE 0 END AS Resumen,resu_mens,tipo FROM (
		SELECT resu_fech,resu_impo AS resu_impo,resu_mens,1 AS Tipo FROM fe_resboletas f
		WHERE  resu_fech between '<<f1>>' and '<<f2>>' and f.resu_acti='A' AND LEFT(resu_mens,1)='0'
		UNION ALL
		SELECT fech AS resu_fech,IF(mone='S',impo,impo*dolar) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		WHERE  f.fech between '<<f1>>' and '<<f2>>' and f.acti='A' AND tdoc='03' AND LEFT(ndoc,1)='B' AND f.idcliente>0
		UNION ALL
		SELECT f.fech AS resu_fech,IF(f.mone='S',ABS(f.impo),ABS(f.impo*f.dolar)) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		INNER JOIN fe_ncven g ON g.ncre_idan=f.idauto
		INNER JOIN fe_rcom AS w ON w.idauto=g.ncre_idau
		WHERE  f.fech between '<<f1>>' and '<<f2>>' and f.acti='A' AND f.tdoc IN ('07','08') AND LEFT(f.ndoc,1) in('F','B') AND w.tdoc='03' AND f.idcliente>0) AS x)
		AS y GROUP BY resu_fech ORDER BY resu_fech) AS zz  WHERE resumen-enviados>=1
	Endtext
	If  This.EJECutaconsulta(lC, 'rbolne') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarticket10(cticket)
	This.ActualizaDesdeticket()
	Endfunc
	Function ConsultaBoletasyNotasporenviarsinfechas()
	Local lC
*:Global cpropiedad
	cpropiedad = "cdatos"
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("cdatos", "")
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	    \Select resu_fech,enviados,resumen,resumen-enviados,enviados-resumen
		\From(Select resu_fech,Cast(Sum(enviados) As Decimal(12,2)) As enviados,Cast(Sum(resumen) As Decimal(12,2))As resumen From(
		\Select resu_fech,Case Tipo When 1 Then resu_impo Else 0 End As enviados,
		\Case Tipo When 2 Then resu_impo Else 0 End As resumen,resu_mens,Tipo From (
		\Select resu_fech,resu_impo As resu_impo,resu_mens,1 As Tipo From fe_resboletas F
		\Where  F.resu_acti='A' And Left(resu_mens,1)='0'
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And F.resu_codt=<<goApp.tienda>>
		Else
	      \And F.resu_codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
		\Union All
		\Select fech As resu_fech,If(mone='S',Impo,Impo*dolar) As resu_impo,' ' As resu_mens,2 As Tipo From fe_rcom F
		\Where   F.Acti='A' And Tdoc='03' And Left(Ndoc,1)='B' And F.idcliente>0
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \ And F.codt=<<goApp.tienda>>
		Else
	      \ And F.codt  In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
		\Union All
		\Select F.fech As resu_fech,If(F.mone='S',Abs(F.Impo),Abs(F.Impo*F.dolar)) As resu_impo,' ' As resu_mens,2 As Tipo From fe_rcom F
		\INNER Join fe_ncven g On g.ncre_idan=F.Idauto
		\INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
		\Where F.Acti='A' And F.Tdoc In ('07','08') And Left(F.Ndoc,1) In('F','B') And w.Tdoc='03' And F.idcliente>0
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And F.codt=<<goApp.tienda>>
		Else
	      \And F.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
		\) As x)
		\As Y Group By resu_fech Order By resu_fech) As zz  Where resumen-enviados>=1
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, 'rbolne') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function solounticketenvio(Df, Ccursor)
	Text To lC Noshow Textmerge
	    select resu_tick,resu_arch FROM fe_resboletas f
        where f.resu_acti='A' and (LEFT(resu_mens,1)<>'0' OR ISNULL(resu_mens)) and resu_fech='<<df>>' and length(TRIM(resu_tick))>0 limit 1
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrardetalleboletasxenviarurl(Df, Ccursor)
	Text To lC Noshow Textmerge
	SELECT tdoc,ndoc,fech,impo,idauto FROM fe_rcom WHERE tdoc='03' AND acti='A' AND idcliente>0 AND fech='<<df>>'
	UNION ALL
	SELECT f.tdoc,f.ndoc,f.fech,f.impo,f.idauto FROM fe_rcom  AS f
	INNER JOIN fe_ncven g ON g.ncre_idan=f.idauto
	INNER JOIN fe_rcom AS w ON w.idauto=g.ncre_idau
	WHERE f.tdoc="07"  AND f.acti='A' AND f.idcliente>0 AND w.tdoc='03' AND f.fech='<<df>>'
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ConsultaApisunat1(cndoc, cTdoc, dfechae, cticket, niDAUTO, nimpo)
	Local oHTTP As "MSXML2.XMLHTTP"
	pURL_WSDL = "http://companiasysven.com/apisunat1.php"
	If Type('oempresa') = 'U' Then
		Cruc = fe_gene.nruc
	Else
		Cruc = Oempresa.nruc
	Endif
	Text To cdata Noshow Textmerge
	{
	"ruc":"<<cruc>>",
	"ndoc":"<<cndoc>>",
	"tdoc":"<<ctdoc>>",
	"fech":"<<dfechae>>",
	"impo":"<<nimpo>>",
	"ticket":"<<cticket>>",
	"idauto":"<<nidauto>>"
	}
	Endtext
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", pURL_WSDL, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	lcHTML = oHTTP.responseText
	Mensaje(lcHTML)
	If oHTTP.Status <> 200 Then
		This.Cmensaje = "Servicio WEB NO Disponible....." + Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultardesdeurl
	Lparameters fi, ff, Cruc
	Local loXmlHttp As "Microsoft.XMLHTTP"
	Local lcHTML, lcURL, ls_compra, ls_venta
	Set Procedure To d:\Librerias\json Additive
	m.lcURL		= "http://companiasysven.com/apisunat20.php"
	m.loXmlHttp	= Createobject("Microsoft.XMLHTTP")
	Text To cdata Noshow Textmerge
	{
	"fi":"<<fi>>",
	"ff":"<<ff>>",
	"ruc":"<<cruc>>"
	}
	Endtext
	m.loXmlHttp.Open('POST', m.lcURL, .F.)
	m.loXmlHttp.setRequestHeader("Content-Type", "application/json")
	m.loXmlHttp.Send(cdata)
	If m.loXmlHttp.Status <> 200 Then
		This.Cmensaje = "Servicio WEB NO Disponible....." + Alltrim(Str(m.loXmlHttp.Status))
		Return 0
	Endif
	m.lcHTML = m.loXmlHttp.responseText
	If Atc('idauto', m.lcHTML) > 0 Then
		otc = json_decode(m.lcHTML)
		If Not Empty(json_getErrorMsg())
			This.Cmensaje = "No se Pudo Obtener la Información " + json_getErrorMsg()
			Return 0
		Endif
		x = 1
		Create Cursor boletas(Idauto N(10), Ndoc c(12), fech d, Mensaje c(50), ticket c(30), Importe N(12, 2))
		For i = 1 To otc._Data.getSize()
			ovalor = otc._Data.Get(x)
			If (Vartype(ovalor) = 'O') Then
				niDAUTO	 = Val(ovalor.Get("idauto"))
				dfecha	 = ovalor.Get("fech")
				cndoc	 = ovalor.Get('ndoc')
				Cmensaje = ovalor.Get("mensaje")
				cticket	 = ovalor.Get("ticket")
				Df = Ctod(Right(dfecha, 2) + '/' + Substr(dfecha, 6, 2) + '/' + Left(dfecha, 4))
				Insert Into boletas(Idauto, Ndoc, fech, Mensaje, ticket)Values(niDAUTO, cndoc, Df, Cmensaje, cticket)
			Endif
			x = x + 1
		Next
		Return 1
	Else
		This.Cmensaje = "No hay Infornacíon Para Consultar"
		Return 0
	Endif
	Endfunc
	Function Actualizarbxbresumendesdeurl()
	Sw = 1
	This.CONTRANSACCION = 'S'
	If This.IniciaTransaccion() = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select boletas
	Go Top
	Do While !Eof()
		cticket = boletas.ticket
		totenvio = 0
		Select boletas
		Do While !Eof() And Trim(boletas.ticket) = Trim(cticket)
*totenvio=totenvio+boletas.importe
			Cmensaje = boletas.Mensaje
*	Wait Window cticket
			Text To lC Noshow Textmerge
	           UPDATE fe_rcom SET rcom_mens='<<boletas.mensaje>>',rcom_fecd=curdate() WHERE idauto=<<boletas.idauto>>
			Endtext
			If This.Ejecutarsql(lC) < 1 Then
				Sw = 0
				Exit
			Endif
			Select boletas
			Skip
		Enddo
		If Sw = 0 Then
			Exit
		Endif
		Text To lcc Noshow Textmerge
		  UPDATE fe_resboletas SET resu_mens='<<cmensaje>>',resu_feen=curdate() WHERE resu_tick='<<cticket>>'
		Endtext
		If This.Ejecutarsql(lcc) < 1 Then
			Sw = 0
			Exit
		Endif
		Select boletas
	Enddo
	If Sw = 1 Then
		This.GRabarCambios()
		This.CONTRANSACCION = ""
		Return 1
	Else
		This.DEshacerCambios()
		This.CONTRANSACCION = ""
		Return 0
	Endif
	Endfunc
	Function  EnviarBoletasiNotas(Df)
	Local ocomp As "comprobante"
	If !Pemstatus(goApp, "cdatos", 5)
		goApp.AddProperty("cdatos", "")
	Endif
	If !Pemstatus(goApp,  "Firmarcondll", 5)
		goApp.AddProperty("Firmarcondll", "")
	Endif
	If !Pemstatus(goApp, "multiempresa", 5)
		goApp.AddProperty("multiempresa", "")
	Endif
	goApp.datosg = ""
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	dATOSGLOBALES()
	Set Classlib To d:\Librerias\fe.Vcx Additive
	ocomp = Createobject("comprobante")
	F	  = Cfechas(Df)
	dfecha = Date()
	If This.getallboletas(Df, 'rmbol', 'rb1') < 1 Then
		Return 0
	Endif
	Select Tdoc, Serie, desde, hasta, valor, Exon, ;
		inafecta As inafectas, igv, Impo, rcom_otro As gratificaciones, Df As fech From rb1 Into Cursor curb
	Select fech, Tdoc, Serie, numero, tipodoc, ndni, valor, rcom_exon As Exon, ;
		rcom_inaf As inafectas, igv, Impo, rcom_otro As gratificaciones, trefe, serieref, numerorefe, Idauto From rmbol Into Cursor crb
	Select crb
	ocomp.itemsdocumentos = Reccount()
	tr					  = ocomp.itemsdocumentos
	If tr = 0 Then
		This.Cmensaje = "No Hay Boletas Por enviar"
		Return 0
	Endif
	ocomp.FechaDocumentos = Alltrim(Str(Year(Df))) + '-' + Iif(Month(Df) <= 9, '0' + Alltrim(Str(Month(Df))), Alltrim(Str(Month(Df)))) + '-' + Iif(Day(Df) <= 9, '0' + Alltrim(Str(Day(Df))), Alltrim(Str(Day(Df))))
	cnombreArchivo		  = Alltrim(Str(Year(dfecha))) + Iif(Month(dfecha) <= 9, '0' + Alltrim(Str(Month(dfecha))), Alltrim(Str(Month(dfecha)))) + Iif(Day(dfecha) <= 9, '0' + Alltrim(Str(Day(dfecha))), Alltrim(Str(Day(dfecha))))
	ocomp.Moneda		  = 'PEN'
	ocomp.Tigv			  = '10'
	ocomp.vigv			  = '18'
	ocomp.fechaemision	  = Alltrim(Str(Year(dfecha))) + '-' + Iif(Month(dfecha) <= 9, '0' + Alltrim(Str(Month(dfecha))), Alltrim(Str(Month(dfecha)))) + '-' + Iif(Day(dfecha) <= 9, '0' + Alltrim(Str(Day(dfecha))), Alltrim(Str(Day(dfecha))))
	If Type('oempresa') = 'U' Then
		ocomp.rucfirma			 = fe_gene.rucfirmad
		ocomp.nombrefirmadigital = fe_gene.razonfirmad
		ocomp.rucemisor			 = fe_gene.nruc
		ocomp.razonsocialempresa = fe_gene.Empresa
		ocomp.Ubigeo			 = fe_gene.Ubigeo
		ocomp.direccionempresa	 = fe_gene.ptop
		ocomp.ciudademisor		 = fe_gene.ciudad
		ocomp.distritoemisor	 = fe_gene.distrito
		Cnruc					 = fe_gene.nruc
	Else
		ocomp.rucfirma			 = Oempresa.rucfirmad
		ocomp.nombrefirmadigital = Oempresa.razonfirmad
		ocomp.rucemisor			 = Oempresa.nruc
		ocomp.razonsocialempresa = Oempresa.Empresa
		ocomp.Ubigeo			 = Oempresa.Ubigeo
		ocomp.direccionempresa	 = Oempresa.ptop
		ocomp.ciudademisor		 = Oempresa.ciudad
		ocomp.distritoemisor	 = Oempresa.distrito
		Cnruc					 = Oempresa.nruc
	Endif
	nres					 = fe_gene.gene_nres
	ocomp.pais = 'PE'
	Dimension ocomp.ItemsFacturas[tr, 16]
	i  = 0
	ta = 1
	Select crb
	Scan All
		i						   = i + 1
		ocomp.ItemsFacturas[i, 1]  = crb.Tdoc
		ocomp.ItemsFacturas[i, 2]  = Alltrim(crb.Serie) + '-' + Alltrim(Str(Val(crb.numero)))
		ocomp.ItemsFacturas[i, 3]  = Alltrim(crb.ndni)
		ocomp.ItemsFacturas[i, 4]  = crb.tipodoc
		ocomp.ItemsFacturas[i, 5]  = crb.trefe
		ocomp.ItemsFacturas[i, 6]  = Alltrim(crb.serieref) + '-' + Alltrim(crb.numerorefe)
		ocomp.ItemsFacturas[i, 7]  = Alltrim(Str(crb.Impo, 12, 2))
		ocomp.ItemsFacturas[i, 8]  = Alltrim(Str(crb.valor, 12, 2))
		ocomp.ItemsFacturas[i, 9]  = Alltrim(Str(crb.Exon, 12, 2))
		ocomp.ItemsFacturas[i, 10] = Alltrim(Str(crb.inafectas, 12, 2))
		ocomp.ItemsFacturas[i, 11] = "0.00"
		ocomp.ItemsFacturas[i, 12] = "0.00"
		ocomp.ItemsFacturas[i, 13] = Alltrim(Str(crb.igv, 12, 2))
		ocomp.ItemsFacturas[i, 14] = "0.00"
		ocomp.ItemsFacturas[i, 15] = "0.00"
		ocomp.ItemsFacturas[i, 16] = Alltrim(Str(crb.gratificaciones, 12, 2))
	Endscan

	ocomp.Cmulti = goApp.Multiempresa
	ocomp.FirmarconDLL = goApp.FirmarconDLL
	If nres = 0 Then
		If generaCorrelativoEnvioResumenBoletas() = 0 Then
			This.Cmensaje = "No se Grabo el Corretalivo de Envio de Resumen de Boletas"
			Return 0
		Endif
		goApp.datosg = ''
		dATOSGLOBALES()
		nres = fe_gene.gene_nres
	Endif
	Cserie = cnombreArchivo + "-" + Alltrim(Str(nres))
	If ocomp.generaxmlrboletas(Cnruc, Cserie) = 1 Then
		generaCorrelativoEnvioResumenBoletas()
	Else
		This.Cmensaje = "No se Genero el XML de envío "
		Return 0
	Endif
	If !Empty(goApp.ticket) Then
		Do While .T.
			nr = This.ConsultaTicket(Alltrim(goApp.ticket), goApp.cArchivo)
			If nr >= 0 Or nr < 0 Then
				v = 0
				Exit
			Endif
		Enddo
		v = 1
		If nr = 1 Then
			Select crb
			Go Top
			Scan All
				np1		= crb.Idauto
				dfenvio	= fe_gene.fech
				np3		= "0 El Resumen de Boletas ha sido aceptada " + goApp.ticket
				dfenvio	= Cfechas(fe_gene.fech)
				Text To lC Noshow
                    UPDATE fe_rcom SET rcom_mens=?np3,rcom_fecd=?dfenvio WHERE idauto=?np1
				Endtext
				If  This.Ejecutarsql(lC) < 1 Then
					v = 0
					Exit
				Endif
			Endscan
		Endif
	Else
		This.Cmensaje = 'No se Obtuvo el Ticket de Respuesta'
		v = 0
	Endif
	Return v
	Endfunc
	Function soloregistraRboletas(Df)
	Local ocomp As "comprobante"
*:Global cpropiedad
	cpropiedad = "cdatos"
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("cdatos", "")
	Endif
	dATOSGLOBALES()
	Set Classlib To d:\Librerias\fe.Vcx Additive
	ocomp = Createobject("comprobante")
	F	  = Cfechas(Df)
	dfecha = Date()
*	WAIT WINDOW 'aqui  '+goapp.cdatos
	If goApp.Cdatos = 'S' Then
		nidt = goApp.tienda
		Text To lC Noshow Textmerge
		SELECT fech,tdoc,
		left(ndoc,4) as serie,substr(ndoc,5) as numero,If(Length(trim(c.ndni))<8,'0','1') as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,"" as trefe,"" as serieref,"" as numerorefe,f.idauto
		fROM fe_rcom f
		inner join fe_clie c on c.idclie=f.idcliente
		where tdoc="03" and fech='<<f>>' and acti='A' and idcliente>0 and LEFT(ndoc,1)='B' and f.codt=<<nidt>>
		union all
		select f.fech,f.tdoc,
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
        inner join fe_clie c on c.idclie=f.idcliente
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' and f.codt=<<nidt>>
		union all
		select f.fech,f.tdoc,
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',ndni) as ndni,
        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
        inner join fe_clie c on c.idclie=f.idcliente
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' and f.codt=<<nidt>>
		Endtext
		If This.EJECutaconsulta(lC, "rboletas") < 1 Then
			Return 0
		Endif
		Text To lcx Noshow Textmerge
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo
		from(select
		left(ndoc,4) as serie,substr(ndoc,5) as numero,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,tdoc
		fROM fe_rcom f where tdoc="03" and fech='<<f>>' and acti='A' and idcliente>0 and f.codt=<<nidt>>  order by ndoc) as x  group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo from(select
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto inner join fe_rcom as w on w.idauto=g.ncre_idau
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>'  and f.codt=<<nidt>>  order by f.ndoc) as x group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo  from(select
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto inner join fe_rcom as w on w.idauto=g.ncre_idau
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' and f.codt=<<nidt>>  order by f.ndoc) as x group by serie
		Endtext
	Else
		Text To lC Noshow Textmerge
		SELECT fech,tdoc,
		left(ndoc,4) as serie,substr(ndoc,5) as numero,If(Length(trim(c.ndni))<8,'0','1') as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,"" as trefe,"" as serieref,"" as numerorefe,f.idauto
		fROM fe_rcom f
		inner join fe_clie c on c.idclie=f.idcliente where tdoc="03" and fech='<<f>>' and acti='A' and idcliente>0 and LEFT(ndoc,1)='B'
		union all
		select f.fech,f.tdoc,
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
        inner join fe_clie c on c.idclie=f.idcliente
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>'
		union all
		select f.fech,f.tdoc,
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',ndni) as ndni,
        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
        inner join fe_clie c on c.idclie=f.idcliente
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>'
		Endtext
		If This.EJECutaconsulta(lC, "rboletas") < 1 Then
			Return 0
		Endif
		Text To lcx Noshow Textmerge
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo
		from(select
		left(ndoc,4) as serie,substr(ndoc,5) as numero,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,tdoc
		fROM fe_rcom f where tdoc="03" and fech='<<f>>' and acti='A' and idcliente>0  order by ndoc) as x  group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo from(select
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>'  order by f.ndoc) as x group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo  from(select
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>'  order by f.ndoc) as x group by serie
		Endtext
	Endif
	If This.EJECutaconsulta(lcx, "rb1") < 1 Then
		Return 0
	Endif

	Select Tdoc, Serie, desde, hasta, valor, Exon, ;
		000000.00 As inafectas, igv, Impo, 0.00 As gratificaciones, Df As fech;
		From rb1 Into Cursor curb


	Select fech, Tdoc, Serie, numero, tipodoc, ndni, valor, rcom_exon As Exon, ;
		000000.00 As inafectas, igv, Impo, 0.00 As gratificaciones, trefe, serieref, numerorefe, Idauto;
		From Rboletas Into Cursor crb


	Select crb
	ocomp.itemsdocumentos = Reccount()
	tr					  = ocomp.itemsdocumentos
	If tr = 0 Then
*	This.Cmensaje="No Hay Boletas Por enviar"
*	Return 0
	Endif
	ocomp.FechaDocumentos = Alltrim(Str(Year(Df))) + '-' + Iif(Month(Df) <= 9, '0' + Alltrim(Str(Month(Df))), Alltrim(Str(Month(Df)))) + '-' + Iif(Day(Df) <= 9, '0' + Alltrim(Str(Day(Df))), Alltrim(Str(Day(Df))))
	cnombreArchivo		  = Alltrim(Str(Year(dfecha))) + Iif(Month(dfecha) <= 9, '0' + Alltrim(Str(Month(dfecha))), Alltrim(Str(Month(dfecha)))) + Iif(Day(dfecha) <= 9, '0' + Alltrim(Str(Day(dfecha))), Alltrim(Str(Day(dfecha))))
	ocomp.Moneda		  = 'PEN'
	ocomp.Tigv			  = '10'
	ocomp.vigv			  = '18'
	ocomp.fechaemision	  = Alltrim(Str(Year(dfecha))) + '-' + Iif(Month(dfecha) <= 9, '0' + Alltrim(Str(Month(dfecha))), Alltrim(Str(Month(dfecha)))) + '-' + Iif(Day(dfecha) <= 9, '0' + Alltrim(Str(Day(dfecha))), Alltrim(Str(Day(dfecha))))
	If Type('oempresa') = 'U' Then
		ocomp.rucfirma			 = fe_gene.rucfirmad
		ocomp.nombrefirmadigital = fe_gene.razonfirmad
		ocomp.rucemisor			 = fe_gene.nruc
		ocomp.razonsocialempresa = fe_gene.Empresa
		ocomp.Ubigeo			 = fe_gene.Ubigeo
		ocomp.direccionempresa	 = fe_gene.ptop
		ocomp.ciudademisor		 = fe_gene.ciudad
		ocomp.distritoemisor	 = fe_gene.distrito
		Cnruc					 = fe_gene.nruc
	Else
		ocomp.rucfirma			 = Oempresa.rucfirmad
		ocomp.nombrefirmadigital = Oempresa.razonfirmad
		ocomp.rucemisor			 = Oempresa.nruc
		ocomp.razonsocialempresa = Oempresa.Empresa
		ocomp.Ubigeo			 = Oempresa.Ubigeo
		ocomp.direccionempresa	 = Oempresa.ptop
		ocomp.ciudademisor		 = Oempresa.ciudad
		ocomp.distritoemisor	 = Oempresa.distrito
*	nres					 = oempresa.gene_nres
		Cnruc					 = Oempresa.nruc
	Endif
	nres					 = fe_gene.gene_nres
	ocomp.pais = 'PE'
	Dimension ocomp.ItemsFacturas[tr, 16]
	i  = 0
	ta = 1
	Select crb
	Scan All
		i						   = i + 1
		ocomp.ItemsFacturas[i, 1]  = crb.Tdoc
		ocomp.ItemsFacturas[i, 2]  = Alltrim(crb.Serie) + '-' + Alltrim(Str(Val(crb.numero)))
		ocomp.ItemsFacturas[i, 3]  = Alltrim(crb.ndni)
		ocomp.ItemsFacturas[i, 4]  = crb.tipodoc
		ocomp.ItemsFacturas[i, 5]  = crb.trefe
		ocomp.ItemsFacturas[i, 6]  = Alltrim(crb.serieref) + '-' + Alltrim(crb.numerorefe)
		ocomp.ItemsFacturas[i, 7]  = Alltrim(Str(crb.Impo, 12, 2))
		ocomp.ItemsFacturas[i, 8]  = Alltrim(Str(crb.valor, 12, 2))
		ocomp.ItemsFacturas[i, 9]  = Alltrim(Str(crb.Exon, 12, 2))
		ocomp.ItemsFacturas[i, 10] = Alltrim(Str(crb.inafectas, 12, 2))
		ocomp.ItemsFacturas[i, 11] = "0.00"
		ocomp.ItemsFacturas[i, 12] = "0.00"
		ocomp.ItemsFacturas[i, 13] = Alltrim(Str(crb.igv, 12, 2))
		ocomp.ItemsFacturas[i, 14] = "0.00"
		ocomp.ItemsFacturas[i, 15] = "0.00"
		ocomp.ItemsFacturas[i, 16] = Alltrim(Str(crb.gratificaciones, 12, 2))
	Endscan

	cpropiedad = "Firmarcondll"
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("Firmarcondll", "")
	Endif
	cpropiedad = "multiempresa"
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("multiempresa", "")
	Endif
	ocomp.Cmulti = goApp.Multiempresa
	ocomp.FirmarconDLL = goApp.FirmarconDLL
	If nres = 0 Then
		If generaCorrelativoEnvioResumenBoletas() = 0 Then
			This.Cmensaje = "No se Grabo el Corretalivo de Envio de Resumen de Boletas"
			Return 0
		Endif
		dATOSGLOBALES()
		nres = fe_gene.gene_nres
	Endif
	Cserie = cnombreArchivo + "-" + Alltrim(Str(nres))
	Vdvto = 1
	x = 0
	Select curb
	Scan All
		x = x + 1
		carxml = ""
		cresp = Alltrim(Str(Year(curb.fech))) + Alltrim(Str(Month(curb.fech))) + Alltrim(Str(Day(curb.fech))) + '-' + Alltrim(Str(x))
		If RegistraResumenBoletas(curb.fech, curb.Tdoc, curb.Serie, curb.desde, curb.hasta, curb.Impo, curb.valor, curb.Exon, curb.inafectas, curb.igv, curb.gratificaciones, ;
				  carxml, "", goApp.cArchivo, cresp) = 0 Then
			This.Cmensaje = "NO se Registro el Informe de Envío de Boletas en Base de Datos"
			Vdvto = 0
			Exit
		Endif
	Endscan
	If Vdvto = 0 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function getallboletas(dfecha, Ccursor, Ccursor1)
	If !Pemstatus(goApp, 'cdatos', 5)
		goApp.AddProperty("cdatos", "")
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Df = Cfechas(dfecha)
	If This.todos = 0 Then
		Set Textmerge On
		Set Textmerge To Memvar lC Noshow Textmerge
			\	Select fech,Tdoc,
			\	Left(Ndoc,4) As Serie,Substr(Ndoc,5) As numero,If(Length(Trim(c.ndni))<8,'0','1') As tipodoc,If(Length(Trim(c.ndni))<8,'00000000',c.ndni) As ndni,
		    \   c.razo,If(F.mone='S',valor,valor*dolar) As valor,If(F.mone='S',rcom_exon,rcom_exon*dolar) As rcom_exon,If(F.mone='S',rcom_inaf,rcom_inaf*dolar) As rcom_inaf,
		    \   If(F.mone='S',rcom_otro,rcom_otro*dolar) As rcom_otro,If(F.mone='S',igv,igv*dolar) As igv,
			\	If(F.mone='S',Impo,Impo*dolar) As Impo,"" As trefe,"" As serieref,"" As numerorefe,F.Idauto
			\	From fe_rcom F
			\	INNER Join fe_clie c On c.idclie=F.idcliente
			\	Where Tdoc="03" And fech='<<df>>' And Acti='A' And idcliente>0 And Left(Ndoc,1)='B' And (F.Impo>0 Or F.rcom_otro>0)
		If This.soloporenviar = 'S' Then
		    \ And Left(F.rcom_mens,1)<>'0'
		Endif
		If goApp.Cdatos = 'S' Then
			If Empty(goApp.Tiendas) Then
	    		\ And F.codt=<<goApp.tienda>>
			Else
	           \And F.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
			Endif
		Endif
			\	Union All
			\	Select F.fech,F.Tdoc,
			\	Concat("BD",Substr(F.Ndoc,3,2)) As Serie,Substr(F.Ndoc,5) As numero,'1' As tipodoc,If(Length(Trim(c.ndni))<8,'00000000',c.ndni) As ndni,
		    \   c.razo,Abs(If(F.mone='S',F.valor,F.valor*F.dolar)) As valor,
			\	Abs(If(F.mone='S',F.rcom_exon,F.rcom_exon*F.dolar)) As rcom_exon,Abs(If(F.mone='S',F.rcom_inaf,F.rcom_inaf*F.dolar)) As rcom_inaf,
			\   Abs(If(F.mone='S',F.rcom_otro,F.rcom_otro*F.dolar)) As rcom_otro,Abs(If(F.mone='S',F.igv,F.igv*F.dolar)) As igv,
		    \   Abs(If(F.mone='S',F.Impo,F.Impo*F.dolar)) As Impo,w.Tdoc As trefe,Left(w.Ndoc,4) As serieref,Substr(w.Ndoc,5) As numerorefe,
		    \   F.Idauto
			\	From fe_rcom F
			\	INNER Join fe_ncven g On g.ncre_idan=F.Idauto
			\	INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
		    \   INNER Join fe_clie c On c.idclie=F.idcliente
			\	Where F.Tdoc="08"  And F.Acti='A' And F.idcliente>0 And w.Tdoc='03' And F.fech='<<df>>' And (F.Impo<>0 Or F.rcom_otro>0)
		If This.soloporenviar = 'S' Then
		    \ And Left(F.rcom_mens,1)<>'0'
		Endif
		If goApp.Cdatos = 'S' Then
			If Empty(goApp.Tiendas) Then
	    		\ And F.codt=<<goApp.tienda>>
			Else
	           \And F.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
			Endif
		Endif
			\	Union All
			\	Select F.fech,F.Tdoc,
			\	Concat("BC",Substr(F.Ndoc,3,2)) As Serie,Substr(F.Ndoc,5) As numero,'1' As tipodoc,If(Length(Trim(c.ndni))<8,'00000000',c.ndni) As ndni,
		    \   c.razo,Abs(If(F.mone='S',F.valor,F.valor*F.dolar)) As valor,
			\	Abs(If(F.mone='S',F.rcom_exon,F.rcom_exon*F.dolar)) As rcom_exon,Abs(If(F.mone='S',F.rcom_inaf,F.rcom_inaf*F.dolar)) As rcom_inaf,
			\   Abs(If(F.mone='S',F.rcom_otro,F.rcom_otro*F.dolar)) As rcom_otro,Abs(If(F.mone='S',F.igv,F.igv*F.dolar)) As igv,
		    \   Abs(If(F.mone='S',F.Impo,F.Impo*F.dolar)) As Impo,w.Tdoc As trefe,Left(w.Ndoc,4) As serieref,Substr(w.Ndoc,5) As numerorefe,
		    \  F.Idauto
			\	From fe_rcom F
			\	INNER Join fe_ncven g On g.ncre_idan=F.Idauto
			\	INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
		    \   INNER Join fe_clie c On c.idclie=F.idcliente
			\	Where F.Tdoc="07"  And F.Acti='A' And F.idcliente>0 And w.Tdoc='03' And F.fech='<<df>>' And (F.Impo<>0 Or F.rcom_otro>0)
		If This.soloporenviar = 'S' Then
		    \ And Left(F.rcom_mens,1)<>'0'
		Endif
		If goApp.Cdatos = 'S' Then
			If Empty(goApp.Tiendas) Then
	    		\ And F.codt=<<goApp.tienda>>
			Else
	           \And F.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
			Endif
		Endif
		Set Textmerge To
		Set Textmerge Off
		Set Textmerge On
		Set Textmerge To Memvar lcx Noshow Textmerge
			\   Select Serie,Tdoc,Min(numero) As desde,Max(numero) As hasta,Sum(valor) As valor,Sum(rcom_exon) As Exon,Sum(rcom_inaf) As inafecta,Sum(rcom_otro) As rcom_otro,
			\	Sum(igv) As igv,Sum(Impo) As Impo
			\	From(Select
			\	Left(Ndoc,4) As Serie,Substr(Ndoc,5) As numero,If(F.mone='S',valor,valor*dolar) As valor,If(F.mone='S',F.rcom_exon,F.rcom_exon*F.dolar) As rcom_exon,
			\   If(F.mone='S',F.rcom_inaf,F.rcom_inaf*F.dolar) As rcom_inaf,If(F.mone='S',rcom_otro,rcom_otro*dolar) As rcom_otro,
			\	If(F.mone='S',igv,igv*dolar) As igv,If(F.mone='S',Impo,Impo*dolar) As Impo,Tdoc
			\	From fe_rcom F
			\   Where Tdoc="03" And fech='<<df>>' And Acti='A' And idcliente>0
		If This.soloporenviar = 'S' Then
		    \ And Left(F.rcom_mens,1)<>'0'
		Endif
		If  goApp.Cdatos = 'S' Then
			If Empty(goApp.Tiendas) Then
	    		\ And F.codt=<<goApp.tienda>>
			Else
	           \And F.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
			Endif
		Endif
			\ Order By Ndoc) As x  Group By Serie
			\	Union All
			\	Select Serie,Tdoc,Min(numero) As desde,Max(numero) As hasta,Sum(valor) As valor,Sum(rcom_exon) As Exon,Sum(rcom_inaf) As inafecta,Sum(rcom_otro) As rcom_otro,
			\	Sum(igv) As igv,Sum(Impo) As Impo From(Select
			\	Concat("BC",Substr(F.Ndoc,3,2)) As Serie,Substr(F.Ndoc,5) As numero,Abs(If(F.mone='S',F.valor,F.valor*F.dolar)) As valor,
			\	Abs(If(F.mone='S',F.rcom_exon,F.rcom_exon*F.dolar)) As rcom_exon,Abs(If(F.mone='S',F.rcom_inaf,F.rcom_inaf*F.dolar)) As rcom_inaf,Abs(If(F.mone='S',F.igv,F.igv*F.dolar)) As igv,Abs(If(F.mone='S',F.Impo,F.Impo*F.dolar)) As Impo,
			\   Abs(If(F.mone='S',F.rcom_otro,F.rcom_otro*F.dolar)) As rcom_otro,F.Tdoc
			\	From fe_rcom F
			\	INNER Join fe_ncven g On g.ncre_idan=F.Idauto
			\	INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
			\	Where F.Tdoc="07"  And F.Acti='A' And F.idcliente>0 And w.Tdoc='03' And F.fech='<<df>>'
		If This.soloporenviar = 'S' Then
		    \ And Left(F.rcom_mens,1)<>'0'
		Endif
		If  goApp.Cdatos = 'S' Then
			If Empty(goApp.Tiendas) Then
	    		\ And F.codt=<<goApp.tienda>>
			Else
	           \And F.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
			Endif
		Endif
			\ Order By F.Ndoc) As x Group By Serie
			\	Union All
			\	Select Serie,Tdoc,Min(numero) As desde,Max(numero) As hasta,Sum(valor) As valor,Sum(rcom_exon) As Exon,Sum(rcom_inaf) As inafecta,Sum(rcom_otro) As rcom_otro,
			\	Sum(igv) As igv,Sum(Impo) As Impo From(Select
			\	Concat("BD",Substr(F.Ndoc,3,2)) As Serie,Substr(F.Ndoc,5) As numero,Abs(If(F.mone='S',F.valor,F.valor*F.dolar)) As valor,
			\	Abs(If(F.mone='S',F.rcom_exon,F.rcom_exon*F.dolar)) As rcom_exon,Abs(If(F.mone='S',F.rcom_inaf,F.rcom_inaf*F.dolar)) As rcom_inaf,Abs(If(F.mone='S',F.igv,F.igv*F.dolar)) As igv,Abs(If(F.mone='S',F.Impo,F.Impo*F.dolar)) As Impo,
			\   If(F.mone='S',F.rcom_otro,F.rcom_otro*F.dolar) As rcom_otro,F.Tdoc
			\	From fe_rcom F
			\	INNER Join fe_ncven g On g.ncre_idan=F.Idauto
			\	INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
			\	Where F.Tdoc="08"  And F.Acti='A' And F.idcliente>0 And w.Tdoc='03' And F.fech='<<df>>'
		If This.soloporenviar = 'S' Then
		    \ And Left(F.rcom_mens,1)<>'0'
		Endif
		If  goApp.Cdatos = 'S' Then
			If Empty(goApp.Tiendas) Then
	    		\ And F.codt=<<goApp.tienda>>
			Else
	           \And F.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
			Endif
		Endif
			\ Order By F.Ndoc) As x Group By Serie Order By Serie
		Set Textmerge Off
		Set Textmerge To
	Else
		If This.cTdoc = '03' Then
			Set Textmerge On
			Set Textmerge To Memvar lC Noshow Textmerge
				\Select fech,Tdoc,Serie,numero,If(Length(Trim(ndni))<8,'0','1') As tipodoc,If(Length(Trim(ndni))<8,'00000000',ndni) As ndni,
  		        \razo,valor,rcom_exon,rcom_inaf,rcom_otro,igv,Impo,trefe,serieref,numerorefe,Idauto
			    \From(Select F.fech,F.Tdoc,
			    \Left(F.Ndoc,4) As Serie,Substr(F.Ndoc,5) As numero,If(F.mone='S',F.valor,F.valor*F.dolar) As valor,
			    \If(F.mone='S',F.rcom_exon,F.rcom_exon*F.dolar) As rcom_exon,If(F.mone='S',F.rcom_inaf,F.rcom_inaf*F.dolar) As rcom_inaf,If(F.mone='S',F.igv,F.igv*F.dolar) As igv,
			    \If(F.mone='S',F.Impo,F.Impo*F.dolar) As Impo,Cast(mid(F.Ndoc,5) As unsigned) As numero1,c.razo,c.ndni,
		        \"" As trefe,"" As serieref,""  As numerorefe,If(F.mone='S',F.rcom_otro,F.rcom_otro*F.dolar) As rcom_otro,F.Idauto
		     	\From fe_rcom F
		     	\INNER Join fe_clie As c On c.idclie=F.idcliente
			    \Left Join fe_ncven g On g.ncre_idan=F.Idauto
			    \Left Join fe_rcom As w On w.Idauto=g.ncre_idau
			    \Where F.Tdoc='<<this.ctdoc>>' And F.fech='<<df>>'  And F.Acti='A' And (F.Impo<>0 Or F.rcom_otro>0)
			If This.soloporenviar = 'S' Then
		    \ And Left(F.rcom_mens,1)<>'0'
			Endif
			If  goApp.Cdatos = 'S' Then
				If Empty(goApp.Tiendas) Then
	    		\ And F.codt=<<goApp.tienda>>
				Else
	           \And F.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
				Endif
			Endif
			    \ Order By F.Ndoc) As x
			    \Where numero1 Between <<This.ndesde>> And <<This.nhasta>> And Serie='<<this.cserie>>'
			Set Textmerge Off
			Set Textmerge To
		Else
			Set Textmerge On
			Set Textmerge To Memvar lC Noshow Textmerge
			\Select fech,Tdoc,Serie,numero,If(Length(Trim(ndni))<8,'0','1') As tipodoc,If(Length(Trim(ndni))<8,'00000000',ndni) As ndni,
	        \razo,valor,rcom_exon,rcom_inaf,rcom_otro,igv,Impo,trefe,serieref,numerorefe,Idauto
		    \From(Select F.fech,F.Tdoc,
		    \If(F.Tdoc='07',Concat("BC",Substr(F.Ndoc,3,2)),Concat("BD",Substr(F.Ndoc,3,2))) As Serie,Substr(F.Ndoc,5) As numero,Abs(If(F.mone='S',F.valor,F.valor*F.dolar)) As valor,
	        \Abs(If(F.mone='S',F.rcom_exon,F.rcom_exon*F.dolar)) As rcom_exon,Abs(If(F.mone='S',F.rcom_inaf,F.rcom_inaf*F.dolar)) As rcom_inaf,Abs(If(F.mone='S',F.igv,F.igv*F.dolar)) As igv,
	        \Abs(If(F.mone='S',F.Impo,F.Impo*F.dolar)) As Impo,Cast(mid(F.Ndoc,5) As unsigned) As numero1,c.razo,c.ndni,
	        \ifnull(w.Tdoc,"") As trefe,ifnull(Left(w.Ndoc,4),"") As serieref,ifnull(Substr(w.Ndoc,5),"") As numerorefe,Abs(If(F.mone='S',F.rcom_otro,F.rcom_otro*F.dolar)) As rcom_otro,F.Idauto
	     	\From fe_rcom F
	     	\INNER Join fe_clie As c On c.idclie=F.idcliente
		    \Left Join fe_ncven g On g.ncre_idan=F.Idauto
		    \Left Join fe_rcom As w On w.Idauto=g.ncre_idau
		    \Where F.Tdoc='<<this.ctdoc>>' And F.fech='<<df>>'  And F.Acti='A'  And (F.Impo<>0 Or F.rcom_otro<>0)
			If This.soloporenviar = 'S' Then
		    \ And Left(F.rcom_mens,1)<>'0'
			Endif
			If goApp.Cdatos = 'S' Then
				If Empty(goApp.Tiendas) Then
	    		\ And F.codt=<<goApp.tienda>>
				Else
	           \And F.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
				Endif
			Endif
			    \ Order By F.Ndoc) As x
			    \ Where numero1 Between <<This.ndesde>> And <<This.nhasta>> And Serie='<<this.cserie>>'
			Set Textmerge Off
			Set Textmerge To
		Endif
		Set Textmerge On
		Set Textmerge To Memvar lcx Noshow Textmerge
		\Select Serie,Tdoc,Min(numero) As desde,Max(numero) As hasta,Sum(valor) As valor,Sum(rcom_exon) As Exon,Sum(rcom_inaf) As inafecta,Sum(rcom_otro) As rcom_otro,
		\Sum(igv) As igv,Sum(Impo) As Impo
		\From(Select
		\If(Tdoc='03',Left(Ndoc,4),If(Tdoc='07',Concat("BC",Substr(F.Ndoc,3,2)),Concat("BD",Substr(F.Ndoc,3,2)))) As Serie,Substr(Ndoc,5) As numero,Abs(If(F.mone='S',F.valor,F.valor*F.dolar)) As valor,
        \Abs(If(F.mone='S',F.rcom_exon,F.rcom_exon*F.dolar)) As rcom_exon,Abs(If(F.mone='S',F.rcom_inaf,F.rcom_inaf*F.dolar)) As rcom_inaf,Abs(If(F.mone='S',F.igv,F.igv*F.dolar)) As igv,
        \Abs(If(F.mone='S',F.Impo,F.Impo*F.dolar)) As Impo,Tdoc,Cast(mid(Ndoc,5) As unsigned) As numero1,Abs(If(F.mone='S',rcom_otro,rcom_otro*dolar)) As rcom_otro
		\From fe_rcom F Where Tdoc='<<this.ctdoc>>' And fech='<<df>>' And Acti='A' And idcliente>0
		If This.soloporenviar = 'S' Then
		    \ And Left(F.rcom_mens,1)<>'0'
		Endif
		If goApp.Cdatos = 'S' Then
			If Empty(goApp.Tiendas) Then
	    		\ And F.codt=<<goApp.tienda>>
			Else
	            \ And F.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
			Endif
		Endif
		\ Order By Ndoc) As x
		\ Where numero1 Between <<This.ndesde>> And <<This.nhasta>> And Serie='<<this.cserie>>'
		\ Group By Serie Order By Serie
		Set Textmerge Off
		Set Textmerge To
	Endif
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	If This.EJECutaconsulta(lcx, Ccursor1) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function generaserieboletas()
	Ccursor = 'c_' + Sys(2015)
	Text To lC Noshow Textmerge
	    UPDATE fe_gene as g SET gene_nres=gene_nres+1 WHERE idgene=1
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Text To lC Noshow Textmerge
	    select gene_nres FROM fe_gene WHERE idgene=1
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	Return gene_nres
	Endfunc
	Function ConsultarBoletas(dfi, dff, Tipo, Calias)
	cpropiedad = "Cdatos"
	fi = Cfechas(dfi)
	ff = Cfechas(dff)
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("Cdatos", "")
	Endif
	Do Case
	Case  This.estado = 'A'
		Cestado = " and   f.resu_acti='A' "
	Case This.estado = 'I'
		Cestado = "I" And   F.resu_acti = 'I'
	Otherwise
		Cestado = ""
	Endcase
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\ Select  resu_feen,resu_fech,resu_tdoc,resu_serie,resu_desd,resu_hast,resu_valo,resu_exon,resu_inaf,resu_igv,resu_grat,
	\ resu_impo,resu_arch,resu_tick,resu_mens,resu_hash,resu_idre From fe_resboletas F
	If Tipo = 1 Then
	 \ Where resu_feen Between '<<fi>>' And '<<ff>>'
	Else
	 \ Where resu_fech Between '<<fi>>' And '<<ff>>'  And   F.resu_acti='A'
	Endif
	If goApp.Cdatos = 'S' Then
	\ And resu_codt=<<goApp.tienda>>
	Endif
	\ Order By resu_fech,resu_tdoc,resu_serie
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarticket1000(cticket)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Local lC, lcr
	np3		= "0 El Resumen de Boletas ha sido aceptado desde API-SUNAT"
	dfenvio	= Cfechas(fe_gene.fech)
	Text To lcr Noshow Textmerge
     UPDATE fe_resboletas SET resu_mens='<<np3>>',resu_feen=CURDATE() WHERE resu_tick='<<cticket>>';
	Endtext
	Sw	 = 1
	Select * From rmvtos Where Alltrim(rmvtos.resu_tick) = cticket Into Cursor ax
	Select ax
	Go Top
	Scan All
		ndesde = ax.resu_desd
		nhasta = ax.resu_hast
		cTdoc  = ax.resu_tdoc
		If cTdoc = '07' Or cTdoc = '08' Then
			Cserie = Iif(cTdoc = '07', 'FN', 'FD') + Substr(ax.resu_serie, 3, 2)
		Else
			Cserie = ax.resu_serie
		Endif
		Text To lC Noshow
			Select  idauto,	numero,tdoc,fech,Impo,ndoc FROM (Select  idauto,	ndoc,Cast(mid(ndoc, 5) As unsigned) As numero,tdoc,	fech,Impo From fe_rcom F
			Where tdoc = ?ctdoc And Acti = 'A'  And idcliente > 0 and impo<>0) As x where numero Between ?ndesde And ?nhasta And Left(ndoc, 4) = ?cserie
		Endtext
		If  This.EJECutaconsulta(lC, 'crb') < 1 Then
			Sw = 0
			Exit
		Endif
		Select crb
		Go Top
		Scan All
			np1	  = crb.Idauto
			odvto = ConsultaApisunat(crb.Tdoc, Left(crb.Ndoc, 4), Trim(Substr(crb.Ndoc, 5)), Dtoc(crb.fech), Alltrim(Str(crb.Impo, 12, 2)))
			If odvto.Vdvto = '1' Then
				Mensaje(odvto.Mensaje + ' ' + crb.Ndoc)
				Text  To lC Noshow Textmerge Pretext 7
                 UPDATE fe_rcom SET rcom_mens='<<np3>>',rcom_fecd='<<dfenvio>>' WHERE idauto=<<np1>>
				Endtext
				If This.Ejecutarsql(lC) < 1 Then
					Sw = 0
					Exit
				Endif
			Else
				This.Cmensaje = Alltrim(odvto.Mensaje)
				Sw = 0
				Exit
			Endif
		Endscan
		Select ax
	Endscan
	If Sw = 1 Then
		If Ejecutarsql(lcr) < 1 Then
			Return 0
		Endif
		This.Cmensaje = "Proceso Culminado Correctamente"
		Return 1
	Else
		Return 0
	Endif
	Endfunc
	Function ActualizaDesdeticket()
	np3 = "0 El Resumen de Boletas ha sido aceptado "
	dfenvio = Cfechas(fe_gene.fech)
	Sw = 1
	Text To lC Noshow Textmerge
   	select resu_desd,resu_hast,resu_tdoc,resu_serie FROM fe_resboletas where resu_tick='<<ALLTRIM(this.cticket)>>' AND resu_acti='A'
	Endtext
	If This.EJECutaconsulta(lC, 'ax') < 1 Then
		This.cticket = ""
		Return 0
	Endif
	If This.IniciaTransaccion() < 1 Then
		This.cticket = ""
		Return 0
	Endif
	Select ax
	Go Top
	Scan All
		ndesde = ax.resu_desd
		nhasta = ax.resu_hast
		cTdoc = ax.resu_tdoc
		If cTdoc = '07' Or cTdoc = '08' Then
			Cserie = Iif(cTdoc = '07', 'FN', 'FD') + Substr(ax.resu_serie, 3, 2)
		Else
			Cserie = ax.resu_serie
		Endif
		Text To lC Noshow Textmerge
			select idauto,numero from(
			SELECT idauto,ndoc,cast(mid(ndoc,5) as unsigned) as numero FROM fe_rcom f where tdoc='<<ctdoc>>' and acti='A' and idcliente>0) as x
			where numero between <<ndesde>> and <<nhasta>> and LEFT(ndoc,4)='<<cserie>>'
		Endtext
		If This.EJECutaconsulta(lC, 'crb') < 1 Then
			Sw = 0
			Exit
		Endif
		Select crb
		Go Top
		Scan All
			Text  To lC Noshow Textmerge Pretext 7
             UPDATE fe_rcom SET rcom_mens='<<np3>>',rcom_fecd='<<dfenvio>>' WHERE idauto=<<crb.idauto>>
			Endtext
			If This.Ejecutarsql(lC) < 1 Then
				Sw = 0
				Exit
			Endif
		Endscan
		Select ax
	Endscan
	If Sw = 1 Then
		Text To lC Noshow Textmerge
        UPDATE fe_resboletas SET resu_mens='<<np3>>',resu_feen=CURDATE() WHERE resu_tick='<<this.cticket>>';
		Endtext
		If This.Ejecutarsql(lC) < 1 Then
			Return 0
		Endif
		If This.GRabarCambios() = 0 Then
			Return 1
		Endif
		This.cticket = ""
		This.Cmensaje = "Proceso Culminado Correctamente"
		Return 1
	Else
		This.cticket = ""
		This.DEshacerCambios()
		Return 0
	Endif
	Endfunc
	Function Anularenvio()
	Text  To lC Noshow Textmerge
        UPDATE fe_resboletas SET resu_acti='I' WHERE resu_idre=<<this.nidr>>
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ConsultaTicket(cticket, cArchivo)
	Local ArchivoRespuestaSunat As "MSXML2.DOMDocument.6.0"
	Local loXMLResp As "MSXML2.DOMDocument.6.0"
	Local oShell As "Shell.Application"
	Local oXMLBody As 'MSXML2.DOMDocument.6.0'
	Local oXMLHttp As "MSXML2.XMLHTTP.6.0"
	Local lcXML, lnCount, lnI, lsURL, ls_envioXML, ls_fileName, ls_pwd_sol, ls_ruc_emisor, ls_user
	Declare Integer CryptBinaryToString In Crypt32;
		String @pbBinary, Long cbBinary, Long dwFlags, ;
		String @pszString, Long @pcchString

	Declare Integer CryptStringToBinary In Crypt32;
		String @pszString, Long cchString, Long dwFlags, ;
		String @pbBinary, Long @pcbBinary, ;
		Long pdwSkip, Long pdwFlags

	#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056

	cpropiedad = "ose"
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("ose", "")
	Endif
	cpropiedad = "urlsunat"
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("urlsunat", "")
	Endif

	cpropiedad = "Grabarxmlbd"
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("Grabarxmlbd", "")
	Endif
	If !Empty(goApp.ose) Then
		Do Case
		Case goApp.ose = "nubefact"
			lsURL		  =  "https://ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Case goApp.ose = "efact"
			lsURL		  =  "https://ose.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Case goApp.ose = "bizlinks"
			lsURL		  =  "https://ose.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Case goApp.ose = "conastec"
			lsURL		  =  "https://prod.conose.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
	Else
		If Empty(goApp.urlsunat) Then
			lsURL   = "https://e-factura.sunat.gob.pe/ol-ti-itcpfegem/billService"
		Else
			lsURL = Alltrim(goApp.urlsunat)
		Endif
		ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
		ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
		ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
	Endif
	npos		 = At('.', cArchivo)
	carchivozip	 = Substr(cArchivo, 1, npos - 1)
	ps_fileZip	 = carchivozip + '.zip'
	ls_fileName	 = Justfname(ps_fileZip)
	ctipoarchivo = Justfname(cArchivo)
	crespuesta	 = ls_fileName
	Do Case
	Case  goApp.ose = 'conastec'
		Text To ls_envioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe">
		<soapenv:Header>
		<wsse:Security   xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
		<wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
		<wsse:Username><<ls_user>></wsse:Username>
		<wsse:Password><<ls_pwd_sol>></wsse:Password>
		</wsse:UsernameToken>
		</wsse:Security>
		</soapenv:Header>
		<soapenv:Body>
	     <ser:getStatus>
		<!--Optional:-->
		   <ticket><<cticket>></ticket>
		</ser:getStatus>
		</soapenv:Body>
		</soapenv:Envelope>
		Endtext
	Case goApp.ose = "efact"
		Text To ls_envioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
     <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe" xmlns:wsse="http://docs.oasisopen.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
	   <soapenv:Header>
	   <wsse:Security soapenv:mustUnderstand="0" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
	      <wsse:UsernameToken>
	        <wsse:Username><<ls_user>></wsse:Username>
	         <wsse:Password><<ls_pwd_sol>></wsse:Password>
	      </wsse:UsernameToken>
	   </wsse:Security>
	   </soapenv:Header>
	   <soapenv:Body>
	        <ser:getStatus>
	          <ticket><<cticket>></ticket>
	     </ser:getStatus>
	   </soapenv:Body>
	</soapenv:Envelope>
		Endtext
	Case  goApp.ose = 'bizlinks'
		Text To ls_envioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
			<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe">
			<soapenv:Header xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
			<wsse:Security soap:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" xmlns:soap="soap">
			<wsse:UsernameToken>
			<wsse:Username><<ls_user>></wsse:Username>
			<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText"><<ls_pwd_sol>></wsse:Password></wsse:UsernameToken>
			</wsse:Security>
			</soapenv:Header>
			   <soapenv:Body>
			      <ser:getStatus>
			         <!--Optional:-->
			        <ticket><<cticket>></ticket>
			      </ser:getStatus>
			   </soapenv:Body>
			</soapenv:Envelope>
		Endtext
	Otherwise
		Text To ls_envioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
			<soapenv:Envelope xmlns:ser="http://service.sunat.gob.pe" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
					xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
				<soapenv:Header>
					<wsse:Security>
						<wsse:UsernameToken>
							<wsse:Username><<ls_user>></wsse:Username>
							<wsse:Password><<ls_pwd_sol>></wsse:Password>
						</wsse:UsernameToken>
					</wsse:Security>
				</soapenv:Header>
				<soapenv:Body>
					<ser:getStatus>
						<ticket><<cticket>></ticket>
					</ser:getStatus>
				</soapenv:Body>
			</soapenv:Envelope>
		Endtext
	Endcase
	If goApp.ose = 'bizlinks' Then
		oXMLHttp = Createobject("MSXML2.XMLHTTP.6.0")
	Else
		oXMLHttp = Createobject("MSXML2.ServerXMLHTTP.6.0")
	Endif

*oXMLHttp=Createobject("MSXML2.ServerXMLHTTP.6.0")
	oXMLBody = Createobject('MSXML2.DOMDocument.6.0')
	If !(oXMLBody.LoadXML(ls_envioXML)) Then
		oResp.Mensaje = "No se cargo XML: " + oXMLBody.parseError.reason
		Return - 1
	Endif
	oXMLHttp.Open('POST', lsURL, .F.)

	If goApp.ose = 'conastec' Or goApp.ose = 'efact' Or goApp.ose = 'bizlinks' Then
		oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8" )
	Else
		oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" )
	Endif
*oXMLHttp.setRequestHeader( "Content-Type", "text/xml" )
*oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" )
	oXMLHttp.setRequestHeader( "Content-Length", Len(ls_envioXML) )
	If goApp.ose = 'bizlinks' Or goApp.ose = 'conastec' Or goApp.ose = 'efact'  Then
		oXMLHttp.setRequestHeader( "SOAPAction", "urn:getStatus" )
	Else
		oXMLHttp.setRequestHeader( "SOAPAction", "getStatus" )
	Endif
	If goApp.ose <> 'bizlinks' Then
		oXMLHttp.setOption(2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS)
	Endif
	oXMLHttp.Send(oXMLBody.documentElement.XML)
	If (oXMLHttp.Status <> 200) Then
		This.Cmensaje = 'STATUS: ' + Alltrim(Str(oXMLHttp.Status)) + '-' + Nvl(oXMLHttp.responseText, '')
		Return 0
	Endif
	loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
	loXMLResp.LoadXML(oXMLHttp.responseText)
	CmensajeError	= leerXMl(Alltrim(oXMLHttp.responseText), "<faultcode>", "</faultcode>")
	CMensajeMensaje	= leerXMl(Alltrim(oXMLHttp.responseText), "<faultstring>", "</faultstring>")
	If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Then
		This.Cmensaje = Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje)
		Return 0
	Endif
	lcXML = oXMLHttp.responseText
	If "<statusCode>" $ lcXML
		lnCount = 1
	Else
		lnCount = 2
	Endif

	cresp = ""
	For lnI = 1 To Occurs('<statusCode>', lcXML)
		cresp = Strextract(lcXML, '<statusCode>', '</statusCode>', lnI)
	Next lnI
	ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
	ArchivoRespuestaSunat.LoadXML(oXMLHttp.responseText)			&&Llenamos el archivo de respuesta
	TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//content")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
	If Vartype(TxtB64) <> 'O' Then
		This.Cmensaje = 'Aún No Hay Respuesta de los Servidores de SUNAT Código de Respuesta ' + Alltrim(cresp)
		Return  0
	Endif

	If Type('oempresa') = 'U' Then
		cnombre	  = VerificaArchivoRespuesta(Addbs(Sys(5) + Sys(2003) + '\SunatXml') + crespuesta, crespuesta, cticket)
		cfilerpta = Addbs( Sys(5) + Sys(2003) + '\SunatXML') + 'R-' + carchivozip + '.XML'
		cDirDesti = Addbs(Sys(5) + Sys(2003) + '\SunatXML')
	Else
		cnombre = VerificaArchivoRespuesta(Addbs(Sys(5) + Sys(2003) + '\SunatXml\' + Alltrim(Oempresa.nruc)) + crespuesta, crespuesta, cticket)
		cfilerpta = Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc)) + 'R-' + carchivozip + '.XML'
		cDirDesti = Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc))
	Endif
	If !Directory(cDirDesti)
		Md (cDirDesti)
	Endif
	If File(cfilerpta) Then
		Delete File (cfilerpta)
	Endif
	decodefile(TxtB64.Text, cnombre)
	oShell	  = Createobject("Shell.Application")
	cfilerpta = "R"
	For Each oArchi In oShell.NameSpace(cnombre).Items
		If Left(oArchi.Name, 1) = 'R' Then
			oShell.NameSpace(cDirDesti).CopyHere(oArchi)
			cfilerpta = Juststem(oArchi.Name) + '.XML'
		Endif
	Endfor
	If Type('oempresa') = 'U' Then
		rptaSunat = LeerRespuestaSunat(Sys(5) + Sys(2003) + '\SunatXML\' + cfilerpta)
		cfilecdr  = Sys(5) + Sys(2003) + '\SunatXML\' + cfilerpta
	Else
		rptaSunat = LeerRespuestaSunat(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\" + cfilerpta)
		cfilecdr  = Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\" + cfilerpta
	Endif
	If !Empty(rptaSunat)
		If Len(Alltrim(rptaSunat)) > 100  Then
			This.Cmensaje = Left(rptaSunat, 240)
			Return 0
		Endif
	Endif
	If !Empty(rptaSunat) Then
		If Left(rptaSunat, 1) == '0' Then
			If Substr(ctipoarchivo, 13, 2) = 'RA' Then
				If ActualizaResumenBajas(cticket, cfilecdr) = 0 Then
					This.Cmensaje = "NO se Grabo la Respuesta de SUNAT en Base de Datos"
				Endif
			Else
				This.cticket = cticket
				This.cfilecdr = m.cfilecdr
				If  This.ActualizaDesdeticket() < 1 Then
					Return 0
				Endif
			Endif
			This.Cmensaje = rptaSunat
			Return 1
		Else
			Return 0
		Endif
	Else
		Return 0
	Endif
	Endfunc
	Function RegistraResumenBoletasConbaja()
	Local lC, lp
	lC			  = "proIngresaResumenBoletasconbaja"
	npara1  = This.dfecha
	npara2  = This.cTdoc
	npara3  = This.Cserie
	npara4  = This.ndesde
	npara5  = This.nhasta
	npara6  = This.nimpo
	npara7  = This.nvalor
	npara8  = This.nexon
	npara9  = This.ninafectas
	npara10 = This.nigv
	npara11 = This.ngrati
	npara12 = This.cxml
	npara13 = This.chash
	npara14 = This.cfile
	npara15 = This.cticket
	Text To lp Noshow
     (?npara1,?npara2,?npara3,?npara4,?npara5,?npara6,?npara7,?npara8,?npara9,?npara10,?npara11,?npara12,?npara13,?npara14,?npara15)
	Endtext
	If This.EJECUTARP(lC, lp, '') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function AnuladesdesRboletas()
	Text To lC Noshow Textmerge
   	select resu_desd,resu_hast,resu_tdoc,resu_serie FROM fe_resboletas where resu_tick='<<this.cticket>>' AND resu_acti='A'
	Endtext
	If This.EJECutaconsulta(lC, 'ax') < 1 Then
		Return 0
	Endif
	ndesde = ax.resu_desd
	nhasta = ax.resu_hast
	cTdoc = ax.resu_tdoc
	If cTdoc = '07' Or cTdoc = '08' Then
		Cserie = Iif(cTdoc = '07', 'FN', 'FD') + Substr(ax.resu_serie, 3, 2)
	Else
		Cserie = ax.resu_serie
	Endif
	Text To lC Noshow Textmerge
			select idauto,numero,tech,tdoc from(
			SELECT idauto,ndoc,cast(mid(ndoc,5) as unsigned) as numero,fech,tdoc FROM fe_rcom f where tdoc='<<ctdoc>>' and acti='A' and idcliente>0) as x
			where numero between <<ndesde>> and <<nhasta>> and LEFT(ndoc,4)='<<cserie>>'
	Endtext
	If This.EJECutaconsulta(lC, 'crb') < 1 Then
		Sw = 0
		Exit
	Endif
	Select crb
	Go Top
	Cdetalle = 'Baja con Código 3'
	Sw = 1
	dfecha = fe_gene.fech
	Scan All
		If AnulaTransaccionConMotivo('', '', 'V', crb.Idauto, goApp.nidusua, 'S', crb.fech, goApp.uauto, Cdetalle) = 0 Then
			This.Cmensaje = "NO  Se Anulo Correctamente de la Base de Datos"
			Sw = 0
			Exit
		Endif
	Endscan
	If Sw = 0 Then
		Return 0
	Endif
	This.Cmensaje = 'Proceso Culminado Correctamente'
	Return 1
	Endfunc
	Function estadoenvio()
	Ccursor = 'c_' + Sys(2015)
	Text To lC Noshow Textmerge
	    select resu_esta FROM fe_resboletas where resu_acti='A' ALLTRIM(resu_tick)='<<this.cticket>>'  limit 1
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If resu_esta = '3' Then
		Return 1
	Endif
	Return 2
	Endfunc
	Function ConsultaBoletasyNotasporenviarpsys(dfi, dff, Ccursor)
	f1 = Cfechas(dfi)
	f2 = Cfechas(dff)
	Local lC
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\    Select resu_fech,enviados,resumen,resumen-enviados,enviados-resumen
	\	From(Select resu_fech,Cast(Sum(enviados) As Decimal(12,2)) As enviados,Cast(Sum(resumen) As Decimal(12,2))As resumen From(
	\	Select resu_fech,Case Tipo When 1 Then resu_impo Else 0 End As enviados,
	\	Case Tipo When 2 Then resu_impo Else 0 End As resumen,resu_mens,Tipo From (
	\	Select resu_fech,resu_impo As resu_impo,resu_mens,1 As Tipo From fe_resboletas F
	\	Where  F.resu_acti='A' And Left(resu_mens,1)='0' And resu_fech Between '<<f1>>' And '<<f2>>'
	 \	Union All
	\	Select fech As resu_fech,If(mone='S',Impo,Impo*dolar) As resu_impo,' ' As resu_mens,2 As Tipo From fe_rcom F
	\	Where   F.Acti='A' And Tdoc='03' And Left(Ndoc,1)='B' And F.idcliente>0 And fech Between '<<f1>>' And '<<f2>>'
	\	Union All
	\	Select F.fech As resu_fech,If(F.mone='S',Abs(F.Impo),Abs(F.Impo*F.dolar)) As resu_impo,' ' As resu_mens,2 As Tipo From fe_rcom F
	\	INNER Join fe_refe g On g.idrven=F.Idauto
	\	INNER Join fe_rcom As w On w.Idauto=g.idrven
	\	Where F.Acti='A' And F.Tdoc In ('07','08') And Left(F.Ndoc,1)='F' And w.Tdoc='03' And F.idcliente>0 And F.fech  Between '<<f1>>' And '<<f2>>'
	\) As x)
	\ As Y Group By resu_fech Order By resu_fech) As zz  Where resumen-enviados>=1
	Set Textmerge Off
	Set Textmerge  To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActuazlizadesdeticketEnvio()
	Sw = 1
	Try
		Do While .T.
			nr = This.ConsultaTicket(Alltrim(This.cticket), goApp.cArchivo)
			If nr >= 0 Then
				Exit
			Endif
		Enddo
		If nr = 1 Then
			np3 = "0 El Resumen de Boletas ha sido aceptada"

			Select crb
			Go Top
			If This.IniciaTransaccion() < 1 Then
				Return 0
			Endif
			Scan All
				np1 = crb.Idauto
				Text  To lC Noshow Textmerge
                  UPDATE fe_rcom SET rcom_mens='<<np3>>' WHERE idauto=<<np1>>
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
			If This.GRabarCambios() < 1 Then
				Return 0
			Endif
		Endif
	Catch To oErr
		This.Cmensaje = oErr.Message
	Finally
	Endtry
	Return 1
	Endfunc
	Function RegistraResumenBoletas()
	Local lC, lp
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	lC			  = "proIngresaResumenBoletas"
	npara1  = This.dfecha
	npara2  = This.cTdoc
	npara3  = This.Cserie
	npara4  = This.ndesde
	npara5  = This.nhasta
	npara6  = This.nimpo
	npara7  = This.nvalor
	npara8  = This.nexon
	npara9  = This.ninafectas
	npara10 = This.nigv
	npara11 = This.ngrati
	npara12 = This.cxml
	npara13 = This.chash
	npara14 = This.cfile
	npara15 = This.cticket
	If goApp.Cdatos = 'S' Then
		npara16 = goApp.tienda
		Text To lp Noshow
     (?npara1,?npara2,?npara3,?npara4,?npara5,?npara6,?npara7,?npara8,?npara9,?npara10,?npara11,?npara12,?npara13,?npara14,?npara15,?npara16)
		Endtext
	Else
		Text To lp Noshow
     (?npara1,?npara2,?npara3,?npara4,?npara5,?npara6,?npara7,?npara8,?npara9,?npara10,?npara11,?npara12,?npara13,?npara14,?npara15)
		Endtext
	Endif
	If This.EJECUTARP(lC, lp, "") < 1Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function GetAllboletaspsys(dfecha, Ccursor, Ccursor1)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Df = Cfechas(dfecha)
	If This.todos = 0 Then
		Text To lC Noshow Textmerge
		select fech,tdoc,
		left(ndoc,4) as serie,substr(ndoc,5) as numero,If(Length(trim(c.ndni))<8,'0','1') as tipodoc,If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,if(f.mone='S',impo,impo*dolar) as impo,if(f.mone='S',f.rcom_otro,f.rcom_otro*f.dolar) as grati,"" as trefe,"" as serieref,"" as numerorefe,f.idauto
		fROM fe_rcom f
		inner join fe_clie c on c.idclie=f.idcliente 
		where tdoc="03" and fech='<<DF>>' and acti='A' and idcliente>0 and LEFT(ndoc,1)='B'
		union all
		SELECT f.fech,f.tdoc,concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,c.razo,
		abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,abs(rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,
		if(f.mone='S',f.rcom_otro,f.rcom_otro*f.dolar) as grati,w.tdoc as trefe,LEFT(ff.ndoc,4) as serieref,SUBSTR(ff.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_rven as rv on rv.idauto=f.idauto
		inner join fe_refe ff on ff.idrven=rv.idrven
		inner join fe_tdoc as w on w.idtdoc=ff.idtdoc
		inner join fe_clie as c on c.idclie=f.idcliente 
		where f.tdoc="07"  and f.fech='<<DF>>' and f.acti='A' and w.tdoc='03'
		union all
		SELECT f.fech,f.tdoc,concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,c.razo,
		abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,abs(rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,
		if(f.mone='S',f.rcom_otro,f.rcom_otro*f.dolar) as grati,w.tdoc as trefe,LEFT(ff.ndoc,4) as serieref,SUBSTR(ff.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_rven as rv on rv.idauto=f.idauto
		inner join fe_refe ff on ff.idrven=rv.idrven
		inner join fe_tdoc as w on w.idtdoc=ff.idtdoc
		inner join fe_clie as c on c.idclie=f.idcliente 
		where f.tdoc="08"  and f.fech='<<DF>>' and f.acti='A' and w.tdoc='03'
		Endtext
********
		Text To lcx Noshow Textmerge
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo,SUM(grati) as grati
		from(select
		left(ndoc,4) as serie,substr(ndoc,5) as numero,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,if(f.mone='S',f.rcom_otro,f.rcom_otro*f.dolar) as grati,tdoc
		fROM fe_rcom f 
		where tdoc="03" and fech='<<DF>>' and acti='A' and idcliente>0 order by ndoc) as x  group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo,SUM(grati) as grati from(select
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,
		if(f.mone='S',f.rcom_otro,f.rcom_otro*f.dolar) as grati,f.tdoc
		FROM fe_rcom f
		inner join fe_rven as rv on rv.idauto=f.idauto
		inner join fe_refe ff on ff.idrven=rv.idrven
		inner join fe_tdoc as w on w.idtdoc=ff.idtdoc
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<DF>>' order by f.ndoc) as x group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo,SUM(grati) as grati from(select
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,
		if(f.mone='S',f.rcom_otro,f.rcom_otro*f.dolar) as grati,f.tdoc
		FROM fe_rcom f
		inner join fe_rven as rv on rv.idauto=f.idauto
		inner join fe_refe ff on ff.idrven=rv.idrven
		inner join fe_tdoc as w on w.idtdoc=ff.idtdoc
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<DF>>' order by f.ndoc) as x group by serie
		Endtext
	Else
		If This.cTdoc = '03' Then
			Text To lC Noshow Textmerge
			SELECT fech,tdoc,serie,numero,If(Length(trim(ndni))<8,'0','1') as tipodoc,If(Length(trim(ndni))<8,'00000000',ndni) as ndni,
	        razo,valor,rcom_exon,igv,impo,grati,trefe,serieref,numerorefe,idauto
		    from(select f.fech,f.tdoc,
		    left(f.ndoc,4) as serie,substr(f.ndoc,5) as numero,if(f.mone='S',f.valor,f.valor*f.dolar) as valor,
		    f.rcom_exon,if(f.mone='S',f.igv,f.igv*f.dolar) as igv,
		    if(f.mone='S',f.impo,f.impo*f.dolar) as impo,if(f.mone='S',f.rcom_otro,f.rcom_otro*f.dolar) as grati,
		    cast(mid(f.ndoc,5) as unsigned) as numero1,c.ndni,c.razo,
	        "" as trefe,"" as serieref,"" as numerorefe,f.idauto
	     	fROM fe_rcom f
	     	inner join fe_clie as c on c.idclie=f.idcliente
		    inner join fe_rven as rv on rv.idauto=f.idauto
		    where f.tdoc='03' and f.fech='<<DF>>'  and f.acti='A' order by f.ndoc) as x
		    where numero1 between <<This.ndesde>> And <<This.nhasta>> And Serie='<<this.cserie>>'
			Endtext
		Else
			Text To lC Noshow Textmerge
			SELECT fech,tdoc,serie,numero,If(Length(trim(ndni))<8,'0','1') as tipodoc,If(Length(trim(ndni))<8,'00000000',ndni) as ndni,
	        razo,valor,rcom_exon,igv,impo,grati,trefe,serieref,numerorefe,idauto
		    from(select f.fech,f.tdoc,
		    left(f.ndoc,4) as serie,substr(f.ndoc,5) as numero,if(f.mone='S',f.valor,f.valor*f.dolar) as valor,
		    f.rcom_exon,if(f.mone='S',f.igv,f.igv*f.dolar) as igv,
		    if(f.mone='S',f.impo,f.impo*f.dolar) as impo,if(f.mone='S',f.rcom_otro,f.rcom_otro*f.dolar) as grati,
		    cast(mid(f.ndoc,5) as unsigned) as numero1,c.ndni,c.razo,
	        ifnull(w.tdoc,"") as trefe,ifnull(left(ff.ndoc,4),"") as serieref,ifnull(substr(ff.ndoc,5),"") as numerorefe,f.idauto
	     	fROM fe_rcom f
	     	inner join fe_clie as c on c.idclie=f.idcliente
		    inner join fe_rven as rv on rv.idauto=f.idauto
		    inner join fe_refe ff on ff.idrven=rv.idrven
		    inner join fe_tdoc as w on w.idtdoc=ff.idtdoc
		    where f.tdoc='<<this.ctdoc>>' and f.fech='<<DF>>'  and f.acti='A' order by f.ndoc) as x
		    where numero1 between <<This.ndesde>> And <<This.nhasta>> And Serie='<<this.cserie>>'
			Endtext
		Endif
********
		Text To lcx Noshow Textmerge
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo,SUM(grati) as grati
		from(select
		left(ndoc,4) as serie,substr(ndoc,5) as numero,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,if(f.mone='S',f.rcom_otro,f.rcom_otro*f.dolar) as grati,tdoc,cast(mid(ndoc,5) as unsigned) as numero1
		fROM fe_rcom f where tdoc='<<this.ctdoc>>' and fech='<<DF>>' and acti='A' and idcliente>0 order by ndoc) as x
		where numero1 between <<This.ndesde>> And <<This.nhasta>> And Serie='<<this.cserie>>'
		group by serie
		Endtext
	Endif
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	If This.EJECutaconsulta(lcx, Ccursor1) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function  EnviarBoletasiNotasporserie(Df, Ccursor1, ccursor2)
	If !Pemstatus(goApp, 'cdatos', 5)
		goApp.AddProperty("cdatos", "")
	Endif
	If !Pemstatus(goApp, "Firmarcondll", 5)
		goApp.AddProperty("Firmarcondll", "")
	Endif
	If !Pemstatus(goApp, "multiempresa", 5)
		goApp.AddProperty("multiempresa", "")
	Endif
	Set Classlib To d:\Librerias\fe.Vcx Additive
	ocomp = Createobject("comprobante")
	ocomp.Cmulti = goApp.Multiempresa
	ocomp.FirmarconDLL = goApp.FirmarconDLL
	goApp.datosg = ""
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	oapp = Newobject("appsysven", "d:\capass\modelos\appsysven.prg")
	If oapp.dATOSGLOBALES("fe_gene") < 1 Then
		This.Cmensaje = oapp.Cmensaje
		Return 0
	Endif
	F	  = Cfechas(m.Df)
	m.dfecha = fe_gene.fech
	Sw = 1
	ncont = 0
	tvalor = 0
	TExon = 0
	Tinafectas = 0
	Tigv = 0
	TImpo = 0
	Tgratificaciones = 0
	cinicio = ''
	cfinal = ''
	cerie = ''
	cierre = ''
	entro = 0
	Create Cursor curb(Tdoc c(2), Serie c(4), desde c(8), hasta c(8), valor N(12, 2), Exon N(12, 2), inafectas N(12, 2), igv N(12, 2), Impo N(12, 2), gratificaciones N(12, 2), fech d)
	Create Cursor crb(fech d, Tdoc c(2), Serie c(4), numero c(8), tipodoc c(2), ndni c(10), valor N(10, 2), Exon N(10, 2), inafectas N(10, 2), igv N(10, 2), Impo N(12, 2), gratificaciones N(10, 2), trefe c(2), serieref c(4), numerorefe c(8), Idauto N(15))
*!*		Select Serie From (Ccursor1) Into Cursor seriesbol
	Select (ccursor2)
	Scan All
		entro = 1
		If m.ncont = 0 Then
			m.cinicio = rmvtos.numero
			m.Cserie = rmvtos.Serie
			ocomp.fechaemision	  = Alltrim(Str(Year(m.dfecha))) + '-' + Iif(Month(m.dfecha) <= 9, '0' + Alltrim(Str(Month(m.dfecha))), Alltrim(Str(Month(m.dfecha)))) + '-' + Iif(Day(m.dfecha) <= 9, '0' + Alltrim(Str(Day(m.dfecha))), Alltrim(Str(Day(m.dfecha))))
			ocomp.FechaDocumentos = Alltrim(Str(Year(Df))) + '-' + Iif(Month(Df) <= 9, '0' + Alltrim(Str(Month(Df))), Alltrim(Str(Month(Df)))) + '-' + Iif(Day(Df) <= 9, '0' + Alltrim(Str(Day(Df))), Alltrim(Str(Day(Df))))
			cnombreArchivo		  = Alltrim(Str(Year(m.dfecha))) + Iif(Month(m.dfecha) <= 9, '0' + Alltrim(Str(Month(m.dfecha))), Alltrim(Str(Month(m.dfecha)))) + Iif(Day(m.dfecha) <= 9, '0' + Alltrim(Str(Day(m.dfecha))), Alltrim(Str(Day(m.dfecha))))
			ocomp.Moneda		  = 'PEN'
			ocomp.Tigv			  = '10'
			ocomp.vigv			  = '18'
			ocomp.fechaemision	  = Alltrim(Str(Year(m.dfecha))) + '-' + Iif(Month(m.dfecha) <= 9, '0' + Alltrim(Str(Month(m.dfecha))), Alltrim(Str(Month(m.dfecha)))) + '-' + Iif(Day(m.dfecha) <= 9, '0' + Alltrim(Str(Day(m.dfecha))), Alltrim(Str(Day(m.dfecha))))
			If Type('oempresa') = 'U' Then
				ocomp.rucfirma			 = fe_gene.rucfirmad
				ocomp.nombrefirmadigital = fe_gene.razonfirmad
				ocomp.rucemisor			 = fe_gene.nruc
				ocomp.razonsocialempresa = fe_gene.Empresa
				ocomp.Ubigeo			 = fe_gene.Ubigeo
				ocomp.direccionempresa	 = fe_gene.ptop
				ocomp.ciudademisor		 = fe_gene.ciudad
				ocomp.distritoemisor	 = fe_gene.distrito
				Cnruc					 = fe_gene.nruc
			Else
				ocomp.rucfirma			 = Oempresa.rucfirmad
				ocomp.nombrefirmadigital = Oempresa.razonfirmad
				ocomp.rucemisor			 = Oempresa.nruc
				ocomp.razonsocialempresa = Oempresa.Empresa
				ocomp.Ubigeo			 = Oempresa.Ubigeo
				ocomp.direccionempresa	 = Oempresa.ptop
				ocomp.ciudademisor		 = Oempresa.ciudad
				ocomp.distritoemisor	 = Oempresa.distrito
				Cnruc					 = Oempresa.nruc
			Endif
		Endif
		m.ncont = m.ncont + 1
		cTdoc = rmvtos.Tdoc
		If m.ncont <= 500  Then
			If  rmvtos.Serie <> m.Cserie Then
				Insert Into curb(Tdoc, Serie, desde, hasta, valor, Exon, inafectas, igv, Impo, gratificaciones, fech);
					Values(m.cTdoc, m.Cserie, m.cinicio, m.cfinal, m.tvalor, m.TExon, m.Tinafectas, m.Tigv, m.TImpo, m.Tgratificaciones, m.dfecha)
				m.ncont = 0
				m.tvalor = 0
				m.TExon = 0
				m.Tinafectas = 0
				m.Tigv = 0
				m.TImpo = 0
				Tgratificaciones = 0
				cierre = 'S'
				cfinal = ''
				If This.enviarsunat(ocomp, m.dfecha) < 1 Then
					Sw = 0
				Endif
				Zap In curb
				Zap In crb
			Endif
		Else
			Insert Into curb(Tdoc, Serie, desde, hasta, valor, Exon, inafectas, igv, Impo, gratificaciones, fech);
				Values(m.cTdoc, m.Cserie, m.cinicio, m.cfinal, m.tvalor, m.TExon, m.Tinafectas, m.Tigv, m.TImpo, m.Tgratificaciones, m.dfecha)
			m.ncont = 0
			m.tvalor = 0
			m.TExon = 0
			m.Tinafectas = 0
			m.Tigv = 0
			m.TImpo = 0
			m.cfinal = ""
			Tgratificaciones = 0
			cierre = 'S'
			If This.enviarsunat(ocomp, m.dfecha) < 1 Then
				Sw = 0
			Endif
			Zap In curb
			Zap In crb
		Endif
		m.tvalor = + m.tvalor + rmvtos.valor
		m.TExon = m.TExon + rmvtos.rcom_exon
		m.Tinafectas = m.Tinafectas + rmvtos.rcom_inaf
		m.Tigv = m.Tigv + rmvtos.igv
		m.TImpo = m.TImpo + rmvtos.Impo
		Tgratificaciones = m.Tgratificaciones + rmvtos.rcom_otro
		m.cfinal = rmvtos.numero
		m.Cserie = rmvtos.Serie
		cierre = ''
		Insert Into crb(fech, Tdoc, Serie, numero, tipodoc, ndni, valor, Exon, inafectas, igv, Impo, gratificaciones, trefe, serieref, numerorefe, Idauto);
			Value(rmvtos.fech, rmvtos.Tdoc, rmvtos.Serie, rmvtos.numero, rmvtos.tipodoc, rmvtos.ndni, rmvtos.valor, rmvtos.rcom_exon, rmvtos.rcom_inaf, rmvtos.igv, rmvtos.Impo, rmvtos.rcom_otro, rmvtos.trefe, rmvtos.serieref, rmvtos.numerorefe, rmvtos.Idauto )
*!*			Select Tdoc, Serie, desde, hasta, valor, Exon, inafecta As inafectas, igv, Impo, rcom_otro As gratificaciones, Df As fech From (Ccursor1)  Where Serie = seriesbol.Serie Into Cursor curb
*!*			Select fech, Tdoc, Serie, numero, tipodoc, ndni, valor, rcom_exon As Exon, rcom_inaf As inafectas, igv, Impo, rcom_otro As gratificaciones, trefe, serieref, numerorefe, Idauto From (m.ccursor2)  Where Serie = seriesbol.Serie Into Cursor crb
*!*			Select crb
*!*			ocomp.itemsdocumentos = Reccount()
*!*			tr					  = ocomp.itemsdocumentos
*!*			If tr = 0 Then
*!*				This.Cmensaje = "No Hay Boletas Por enviar"
*!*				swenvio = 0
*!*				Exit
*!*			Endif
*!*			If oapp.dATOSGLOBALES("fe_gene") < 1 Then
*!*				This.Cmensaje = oapp.Cmensaje
*!*				swenvio = 0
*!*				Exit
*!*			Endif
*!*			nres					 = fe_gene.gene_nres
*!*			ocomp.pais = 'PE'
*!*			Dimension ocomp.ItemsFacturas[tr, 16]
*!*			i  = 0
*!*			ta = 1
*!*			Select crb
*!*			Scan All
*!*				i						   = i + 1
*!*				ocomp.ItemsFacturas[i, 1]  = crb.Tdoc
*!*				ocomp.ItemsFacturas[i, 2]  = Alltrim(crb.Serie) + '-' + Alltrim(Str(Val(crb.numero)))
*!*				ocomp.ItemsFacturas[i, 3]  = Alltrim(crb.ndni)
*!*				ocomp.ItemsFacturas[i, 4]  = crb.tipodoc
*!*				ocomp.ItemsFacturas[i, 5]  = crb.trefe
*!*				ocomp.ItemsFacturas[i, 6]  = Alltrim(crb.serieref) + '-' + Alltrim(crb.numerorefe)
*!*				ocomp.ItemsFacturas[i, 7]  = Alltrim(Str(crb.Impo, 12, 2))
*!*				ocomp.ItemsFacturas[i, 8]  = Alltrim(Str(crb.valor, 12, 2))
*!*				ocomp.ItemsFacturas[i, 9]  = Alltrim(Str(crb.Exon, 12, 2))
*!*				ocomp.ItemsFacturas[i, 10] = Alltrim(Str(crb.inafectas, 12, 2))
*!*				ocomp.ItemsFacturas[i, 11] = "0.00"
*!*				ocomp.ItemsFacturas[i, 12] = "0.00"
*!*				ocomp.ItemsFacturas[i, 13] = Alltrim(Str(crb.igv, 12, 2))
*!*				ocomp.ItemsFacturas[i, 14] = "0.00"
*!*				ocomp.ItemsFacturas[i, 15] = "0.00"
*!*				ocomp.ItemsFacturas[i, 16] = Alltrim(Str(crb.gratificaciones, 12, 2))
*!*			Endscan
*!*			If nres = 0 Then
*!*				If This.generaCorrelativoEnvioResumenBoletas() < 1 Then
*!*					swenvio = 0
*!*					Exit
*!*				Endif
*!*				goApp.datosg = ''
*!*				If oapp.dATOSGLOBALES("fe_gene") < 1 Then
*!*					This.Cmensaje = oapp.Cmensaje
*!*					swenvio = 0
*!*					Exit
*!*				Endif
*!*				nres = fe_gene.gene_nres
*!*			Endif
*!*			Cserie = cnombreArchivo + "-" + Alltrim(Str(nres))
*!*			If ocomp.generaxmlrboletas(Cnruc, Cserie) = 1 Then
*!*				If This.generaCorrelativoEnvioResumenBoletas() < 1  Then
*!*					swenvio = 0
*!*					Exit
*!*				Endif
*!*			Else
*!*				This.Cmensaje = "No se Genero el XML de envío "
*!*				swenvio = 0
*!*				Exit
*!*			Endif
*!*			If !Empty(goApp.ticket) Then
*!*				Do While .T.
*!*					nr = This.ConsultaTicket(Alltrim(goApp.ticket), goApp.cArchivo)
*!*					If nr >= 0 Or nr < 0 Then
*!*						swenvio = 0
*!*						Exit
*!*					Endif
*!*				Enddo
*!*				v = 1
*!*				If nr = 1 Then
*!*					dfenvio	= fe_gene.fech
*!*					np3		= "0 El Resumen de Boletas ha sido aceptada " + goApp.ticket
*!*					dfenvio	= Cfechas(fe_gene.fech)
*!*					If This.IniciaTransaccion() < 1 Then
*!*						swenvio = 0
*!*						Exit
*!*					Endif
*!*					Select crb
*!*					Go Top
*!*					Scan All
*!*						np1		= crb.Idauto
*!*						Text To lC Noshow
*!*	                    UPDATE fe_rcom SET rcom_mens=?np3,rcom_fecd=?dfenvio WHERE idauto=?np1
*!*						Endtext
*!*						If  This.Ejecutarsql(lC) < 1 Then
*!*							v = 0
*!*							Exit
*!*						Endif
*!*					Endscan
*!*					If v = 0 Then
*!*						This.DEshacerCambios()
*!*						swenvio = 0
*!*						Exit
*!*					Endif
*!*					If This.GRabarCambios() < 1 Then
*!*						swenvio = 0
*!*						Exit
*!*					Endif
*!*				Endif
*!*			Else
*!*				This.Cmensaje = 'No se Obtuvo el Ticket de Respuesta'
*!*				swenvio = 0
*!*				Exit
*!*			Endif
*!*			Select seriesbol
	Endscan
	If m.cierre <> 'S'  And entro = 1 Then
		Insert Into curb(Tdoc, Serie, desde, hasta, valor, Exon, inafectas, igv, Impo, gratificaciones, fech);
			Values(m.cTdoc, m.Cserie, m.cinicio, m.cfinal, m.tvalor, m.TExon, m.Tinafectas, m.Tigv, m.TImpo, m.Tgratificaciones, m.dfecha)
		If This.enviarsunat(ocomp, m.dfecha) < 1 Then
			Sw = 0
		Endif
	Endif
	If Sw = 0 Then
		Return 0
	Endif
*!*		If swenvio = 0 Then
*!*			Return 0
*!*		Endif
*!*		oapp = Null
*!*		Select * From crb Into Table Addbs(Sys(5) + Sys(2003)) + 'detalle.dbf'
*!*		Select * From curb Into Table Addbs(Sys(5) + Sys(2003)) + 'resumen.dbf'
	Return 1
	Endfunc
	Function  generaCorrelativoEnvioResumenBoletas()
	Local lC
	Text To lC Noshow Textmerge
	UPDATE fe_gene  as f SET gene_nres=f.gene_nres+1 WHERE idgene=1
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizaResumenBoletas(np1, np2)
	Local lC, lp
	cur			 = []
	lC			 = "ProactualizaResumenBoletas"
	npara1 = np1
	npara2 = np2
	crptaSunat	 = LeerRespuestaSunat(np2)
	cdrxml		 = Filetostr(np2)
	cdrxml = ""
	If goApp.Grabarxmlbd = 'S' Then
		Text To lp Noshow
       (?npara1,?crptaSunat,?cdrxml)
		Endtext
	Else
		Text To lp Noshow
        (?npara1,?crptaSunat)
		Endtext
	Endif
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function enviarsunat(ocomp, dfecha)
	If verificaAlias("crb") = 0 Then
		This.Cmensaje = 'No hay Boletas Para Enviar'
		Return 0
	Endif
	Select crb
	ocomp.itemsdocumentos = Reccount()
	tr					  = ocomp.itemsdocumentos
	If tr = 0 Then
		This.Cmensaje = "No Hay Boletas Por enviar"
		Return 0
	Endif
	If oapp.dATOSGLOBALES("fe_gene") < 1 Then
		This.Cmensaje = oapp.Cmensaje
		Return 0
	Endif
	cnombreArchivo		  = Alltrim(Str(Year(m.dfecha))) + Iif(Month(m.dfecha) <= 9, '0' + Alltrim(Str(Month(m.dfecha))), Alltrim(Str(Month(m.dfecha)))) + Iif(Day(m.dfecha) <= 9, '0' + Alltrim(Str(Day(m.dfecha))), Alltrim(Str(Day(m.dfecha))))
	nres					 = fe_gene.gene_nres
	ocomp.pais = 'PE'
	Dimension ocomp.ItemsFacturas[tr, 16]
	i  = 0
	ta = 1
	Select crb
	Scan All
		i						   = i + 1
		ocomp.ItemsFacturas[i, 1]  = crb.Tdoc
		ocomp.ItemsFacturas[i, 2]  = Alltrim(crb.Serie) + '-' + Alltrim(Str(Val(crb.numero)))
		ocomp.ItemsFacturas[i, 3]  = Alltrim(crb.ndni)
		ocomp.ItemsFacturas[i, 4]  = crb.tipodoc
		ocomp.ItemsFacturas[i, 5]  = crb.trefe
		ocomp.ItemsFacturas[i, 6]  = Alltrim(crb.serieref) + '-' + Alltrim(crb.numerorefe)
		ocomp.ItemsFacturas[i, 7]  = Alltrim(Str(crb.Impo, 12, 2))
		ocomp.ItemsFacturas[i, 8]  = Alltrim(Str(crb.valor, 12, 2))
		ocomp.ItemsFacturas[i, 9]  = Alltrim(Str(crb.Exon, 12, 2))
		ocomp.ItemsFacturas[i, 10] = Alltrim(Str(crb.inafectas, 12, 2))
		ocomp.ItemsFacturas[i, 11] = "0.00"
		ocomp.ItemsFacturas[i, 12] = "0.00"
		ocomp.ItemsFacturas[i, 13] = Alltrim(Str(crb.igv, 12, 2))
		ocomp.ItemsFacturas[i, 14] = "0.00"
		ocomp.ItemsFacturas[i, 15] = "0.00"
		ocomp.ItemsFacturas[i, 16] = Alltrim(Str(crb.gratificaciones, 12, 2))
	Endscan
	If nres = 0 Then
		If This.generaCorrelativoEnvioResumenBoletas() < 1 Then
			Return 0
		Endif
		goApp.datosg = ''
		If oapp.dATOSGLOBALES("fe_gene") < 1 Then
			This.Cmensaje = oapp.Cmensaje
			Return 0
		Endif
		nres = fe_gene.gene_nres
	Endif
	Cserie = cnombreArchivo + "-" + Alltrim(Str(nres))
	If ocomp.generaxmlrboletas(Cnruc, Cserie) = 1 Then
		If This.generaCorrelativoEnvioResumenBoletas() < 1  Then
			Return 0
		Endif
	Else
		This.Cmensaje = "No se Genero el XML de envío "
		Return 0
	Endif
	If !Empty(goApp.ticket) Then
		Do While .T.
			nr = This.ConsultaTicket(Alltrim(goApp.ticket), goApp.cArchivo)
			If nr >= 0 Or nr < 0 Then
				swenvio = 0
				Exit
			Endif
		Enddo
		If m.swenvio = 0 Then
			Return 0
		Endif
		v = 1
		If nr = 1 Then
			dfenvio	= fe_gene.fech
			np3		= "0 El Resumen de Boletas ha sido aceptada " + goApp.ticket
			dfenvio	= Cfechas(fe_gene.fech)
			If This.IniciaTransaccion() < 1 Then
				m.swenvio = 0
				Return 0
			Endif
			Select crb
			Go Top
			Scan All
				np1		= crb.Idauto
				Text To lC Noshow
                    UPDATE fe_rcom SET rcom_mens=?np3,rcom_fecd=?dfenvio WHERE idauto=?np1
				Endtext
				If  This.Ejecutarsql(lC) < 1 Then
					v = 0
					Exit
				Endif
			Endscan
			If v = 0 Then
				This.DEshacerCambios()
				Return 0
			Endif
			If This.GRabarCambios() < 1 Then
				Return 0
			Endif
		Endif
	Else
		This.Cmensaje = 'No se Obtuvo el Ticket de Respuesta'
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine


















































