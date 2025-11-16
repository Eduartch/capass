#Define Url "http://compania-sysven.com/app88/"
Define Class liqcompra As Compras Of d:\capass\modelos\Compras
	urlenvio = Url + 'envioliqcompra.php'
	Function informeliqcompra(Ccursor)
	fi = Cfechas(This.fechai)
	ff = Cfechas(This.fechaf)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select a.Ndoc As dcto, a.fech, b.Razo, If(Mone = 'S', 'SOLES', 'DOLARES') As Moneda, a.valor, a.rcom_exon, rcom_irta  As irta,
	\a.igv, a.Impo, rcom_hash, rcom_mens, Mone, a.Tdoc, a.Ndoc, Idauto, rcom_arch, b.email As clie_corr, b.ndni, b.fono
	\From fe_rcom As a
	\Join fe_prov As b On (a.idprov = b.idprov)
	\Where a.Acti <> 'I' And Tdoc='04' And a.fech Between '<<fi>>' And '<<ff>>'
    \Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarxid(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lC Noshow Textmerge
	SELECT a.idauto,a.alma,a.idkar,a.idart,a.cant,a.prec,c.ndoc AS dcto,c.vigv,valor,c.igv,impo,
	c.fech,c.fecr,c.form,c.deta,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,c.pimpo,u.nomb AS usuario,
	c.tdoc,c.ndoc,c.dolar,c.mone,b.descri,b.unid,c.rcom_hash,c.impo,rcom_arch,rcom_mret,IFNULL(t.nomb,f.ptop) AS ptop,rcom_detr,
	rcom_mdet,d.ndni,rcom_lope,rcom_irta,codt,kar_tigv,kar_irta,c.idprov,rcom_mens
	FROM fe_rcom AS c
	INNER JOIN fe_kar AS a ON(c.idauto=a.idauto)
	INNER JOIN fe_prov AS d ON(d.idprov=c.idprov)
	INNER JOIN fe_art AS b ON(b.idart=a.idart)
	INNER JOIN fe_usua AS u ON u.idusua=c.idusua
	LEFT JOIN fe_sucu AS t ON t.idalma=c.codt,fe_gene AS f
	WHERE c.idauto=<<this.nreg>> aND a.acti='A';
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarxreimprimir()
	If This.consultarxid('kardex') < 1 Then
		Return 0
	Endif
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	This.creartmp("tmpv")
	nimpo = Kardex.Impo
	cndoc = Kardex.Ndoc
	cmone = Kardex.Mone
	cTdoc = Kardex.Tdoc
	chash = Kardex.rcom_hash
	cdeta1 = Kardex.Deta
	vvigv = Kardex.vigv
	nvalor = Kardex.valor
	nigv = Kardex.igv
	nimpo = Kardex.Impo
	dFecha = Kardex.fech
	cformapago=Kardex.Form
	nexonerado = Kardex.rcom_exon
	clugar = Kardex.rcom_lope
	nirta = Kardex.rcom_irta
	nneto = (Kardex.valor + Kardex.rcom_exon + Kardex.igv) - (Kardex.igv + Kardex.rcom_irta)
	nf = 0
	Select Kardex
	Scan All
		nf = nf + 1
		Insert Into tmpv(Coda, Desc, Unid, cant, Prec, Ndoc, hash, nruc, razon, Direccion, fech, dni, Mone,  Usuario, Tigv, codc);
			Values(Kardex.idart, Kardex.Descri, Kardex.Unid, Kardex.cant, Kardex.Prec, Kardex.Ndoc, Kardex.rcom_hash, Kardex.nruc, Kardex.Razo, ;
			Alltrim(Kardex.Dire) + ' ' + Alltrim(Kardex.ciud), Kardex.fech, Kardex.ndni, Kardex.Mone, Kardex.Usuario, Kardex.vigv, Kardex.Idcliente)
	Endscan
	Local Cimporte
	Cimporte = Diletras(m.nneto, cmone)
	ni = nf
	Select tmpv
	For x = 1 To fe_gene.Items - nf
		ni = ni + 1
		Insert Into tmpv(Ndoc)Values(cndoc)
	Next
	Select tmpv
	Replace All Ndoc With cndoc, cletras With Cimporte, Mone With cmone, hash With chash, Detalle With cdeta1, ;
		Tdoc With cTdoc, valor With nvalor, igv With nigv, Total With nimpo, fech With dFecha, exonerado With m.nexonerado, ;
		lugar With clugar, irta With nirta, neto With m.nneto,Form With m.cformapago
	Go Top In tmpv
	Return 1
	Endfunc
	Function creartmp(Calias)
	Create Cursor (Calias)(Coda N(8), Desc c(120), Unid c(4), Prec N(13, 8), cant N(10, 3), ;
		Ndoc c(12), Nreg N(8), alma N(10, 2), pre1 N(8, 2), pre2 N(8, 2), Pre3 N(8, 2), ;
		pos N(2), costo N(10, 2), uno N(10, 2), Dos N(10, 2), tre N(10, 2), cua N(10, 2), cin N(10, 2), sei N(10, 2), ;
		Nitem N(3), Valida c(1), Impo N(10, 2), Acti c(1), tipro c(1), idcosto N(10), aprecios c(1), Modi c(1), ;
		cletras c(120), Precio N(13, 8), hash c(30), fech d, codc N(5), Direccion c(120), dni c(8), Forma c(30), fono c(15), ;
		neto N(12, 2), dias N(3), razon c(120), nruc c(11), Mone c(1) Default 'S', Form c(30), valor N(12, 2), exonerado N(12, 2), igv N(12, 2), Total N(12, 2), caant N(10, 2), ;
		Detalle c(200), valida1 c(1), Archivo c(120), Tdoc c(2), Peso N(10, 2), valido c(1), costoRef N(13, 8), ;
		fechav d, Retencion N(8, 2), como N(7, 3), copia c(1), ptop c(150), Idauto N(8), comi N(5, 3), ;
		detraccion N(8, 2), coddetrac c(10), Tigv N(8, 2), irta N(8, 5), lugar c(200), Usuario c(100))
	Endfunc
	Function listarxinformarsunat(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select a.Ndoc As dcto, a.fech, b.Razo, If(Mone = 'S', 'SOLES', 'DOLARES') As Moneda, a.valor, a.rcom_exon, rcom_irta  As irta,
	\a.igv, a.Impo, rcom_hash, rcom_mens, Mone, a.Tdoc, a.Ndoc, Idauto, rcom_arch, b.email As clie_corr, b.ndni, b.fono
	\From fe_rcom As a
	\Join fe_prov As b On (a.idprov = b.idprov)
	\Where a.Acti <> 'I' And Tdoc='04' And Left(a.rcom_mens,1)<>'A' And Left(Ndoc,1)='L' and LEFT(rcom_mens,1)<>'0'
    \Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function EnviarSunat()
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	If Type('oempresa') = 'U' Then
		Cruc = fe_gene.nruc
	Else
		Cruc = Oempresa.nruc
	Endif
	TEXT To cdata Noshow Textmerge
	{
    "nruc":"<<cruc>>",
    "idauto":<<this.nreg>>,
    "empresa":"<<goapp.empresanube>>"
    }
	ENDTEXT
*!*		Messagebox(cdata)
	Set Procedure To d:\Librerias\nfcursortojson, d:\Librerias\nfcursortoobject, d:\Librerias\nfJsonRead.prg Additive
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", This.urlenvio, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	If oHTTP.Status <> 200 Then
		This.Cmensaje = "Servicio WEB NO Disponible " + Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	lcHTML = oHTTP.responseText
	Strtofile(lcHTML,Addbs(Sys(5)+Sys(2003))+'rpta.txt')
*!*		Messagebox(lcHTML)
	orpta = nfJsonRead(lcHTML)
	If  Vartype(orpta.rpta) <> 'U' Then
		If Left(orpta.rpta,1)='0' Then
			This.Cmensaje = Alltrim(orpta.rpta)
		Else
			This.Cmensaje = Left(Alltrim(orpta.rpta),200)
			Return 0
		Endif
	Else
		This.Cmensaje = Alltrim(Left(lcHTML,220))
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarparaseleccionar(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select  Tdoc,Ndoc,fech,b.Razo,Mone,valor,igv,Impo,Idauto,a.idprov As cod,fecr From
    \fe_rcom As a
    \INNER Join fe_prov As b On b.idprov=a.idprov Where  Tdoc='04' And a.Acti<>'I'
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
	Function Actualizarliqcompra()
	Set Procedure To d:\capass\modelos\ctasxpagar, d:\capass\modelos\cajae, d:\capass\modelos\regkardex Additive
	okardex = Createobject("regkardex")
	ocaja = Createobject("cajae")
	oxpagar = Createobject("ctasporpagar")
	nmp = Iif(This.Cmoneda = 'S', This.nimpo8 + This.npercepcion, This.nimpo8 + This.npercepcion * This.ndolar)
	ocaja.dFecha = This.dfechar
	ocaja.codt = This.codt
	ocaja.Ndoc = This.cndoc
	ocaja.cdetalle = This.cdetalle
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
	lC = 'ProActualizacabliqCompras'
	cur = ""
	If IniciaTransaccion() < 1 Then
		Return 0
	Endif
	TEXT To lp Noshow Textmerge
     ('<<This.cTdoc>>', '<<Left(This.cforma, 1)>>', '<<This.cndoc>>', '<<cfechas(This.dFecha)>>',<<this.nreg>>, '<<This.cdetalle>>',<<This.nimpo1>>, <<This.nimpo6>>, <<This.nimpo8>>,'<<This.clugar>>', '<<This.Cmoneda>>', '<<this.ndolar>>', <<this.vigv>>, '<<1>>', <<This.nidprov>>, '<<1>>', <<goApp.nidusua>>, <<this.nirta>>,<<This.codt>>, <<this.nidcta1>>, <<this.nidctai>>, <<this.nidctat>>, <<this.nimpo5>>, <<This.npercepcion>>)
	ENDTEXT
	If This.ejecutarp(lC, lp, '') < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	ocaja.NAuto = This.Nreg
	If Left(This.cforma, 1) = 'E'  Then
		If ocaja.IngresaDatosLCajaEFectivo11() < 1 Then
			This.Cmensaje = ocaja.Cmensaje
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If This.cFormaRegistrada = 'C' And Left(This.cforma, 1) = 'E'
		If oxpagar.ACtualizaDeudas(This.Nreg, goApp.nidusua) < 1 Then
			This.Cmensaje = oxpagar.Cmensaje
			This.DEshacerCambios()
			Return
		Endif
	Endif
	If  Left(This.cforma, 1) = 'C' Then
		If This.Nreg > 0 Then
			If oxpagar.ACtualizaDeudas(This.Nreg, goApp.nidusua) < 1 Then
				This.Cmensaje = oxpagar.Cmensaje
				This.DEshacerCambios()
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
			Return 0
		Endif
	Endif
	Sw = 1
	Select tmpc
	Set Deleted Off
	Go Top
	Do While !Eof()
		okardex.niDAUTO = This.Nreg
		okardex.ncant = tmpc.cant
		okardex.nprec = tmpc.Prec
		okardex.cincl = 'I'
		okardex.ctmvto = 'K'
		okardex.Ctipo = 'C'
		okardex.nidtda = This.codt
		okardex.ncosto = tmpc.Prec
		okardex.ntigv = tmpc.Tigv
		okardex.ncoda = tmpc.Coda
		okardex.nirta = tmpc.Tirta
		If Deleted()
			If tmpc.Nreg > 0 Then
				okardex.nidkar = tmpc.Nreg
				okardex.nopcion = 0
				If okardex.ActualizaKardexcompras5() < 1 Then
					Cmensaje = okardex.Cmensaje
					Sw = 0
					Exit
				Endif
			Endif
		Else
			If tmpc.Nreg > 0   Then
				okardex.nidkar = tmpc.Nreg
				okardex.nopcion = 1
				If okardex.ActualizaKardexcompras5() < 1 Then
					Cmensaje = okardex.Cmensaje
					Sw = 0
					Exit
				Endif
			Else
				nidk = okardex.registrakardexcompras()
				If nidk < 1 Then
					Cmensaje = okardex.Cmensaje
					Sw = 0
					Exit
				Endif
			Endif
			If ActualizaStock11(tmpc.Coda, This.codt, tmpc.cant, 'C', tmpc.caant) = 0 Then
				Sw = 0
				Exit
			Endif
			If tmpc.swcosto = 1 And This.cgrabaprecios = 'S' Then
				If ActualizaCostos(tmpc.Coda, This.dFecha, tmpc.Prec, This.Nreg, This.nidprov, This.Cmoneda, tmpc.Tigv, This.ndolar,0) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
		Endif
		Select tmpc
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
	This.Imprimir()
	Return 1
	Endfunc
	Function Imprimir()
	Set Procedure To, d:\capass\Imprimir.prg  Additive
	oimp = Createobject("imprimir")
	ccletras =	Diletras(This.nneto, 'S')
	Select Count(*) As Ti From tmpc Into Cursor xitems
	Select * From tmpc Into Cursor tmpv Readwrite
	Select tmpv
	For x = 1 To This.Items  - xitems.Ti
		Insert Into tmpv(Ndoc)Values(This.cndoc)
	Next
	Replace  All cletras With  ccletras, dni With This.Cndni, exonerado With This.nimpo5, ;
		irta With This.nirta, neto With This.nneto, valor With This.nimpo1, exonerado With This.nimpo5, ;
		igv With This.nimpo6, Total With This.nimpo8, Mone With This.Cmoneda,  ;
		razon With This.Crazon, Direccion With This.Cdireccion, fech With This.dFecha,Form With This.cforma,;
		lugar With This.clugar, Detalle With This.cdetalle, Ndoc With This.cndoc  In tmpv
	Select tmpv
	Go Top
	oimp.Tdoc = '04'
	oimp.ImprimeComprobanteM('S')
	Endfunc
	Function Grabarliqcompra()
	Set Procedure To d:\capass\modelos\ctasxpagar, d:\capass\modelos\cajae, d:\capass\modelos\regkardex, d:\capass\Imprimir.prg Additive
	okardex = Createobject("regkardex")
	ocaja = Createobject("cajae")
	oimp = Createobject("imprimir")
	nmp = Iif(This.Cmoneda = 'S', This.nimpo8 + This.npercepcion, This.nimpo8 + This.npercepcion * This.ndolar)
	ocaja.dFecha = This.dfechar
	ocaja.codt = This.codt
	ocaja.Ndoc = This.cndoc
	ocaja.cdetalle = This.cdetalle
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
	lC = 'FunIngresacabliqCompras'
	cur = "Xn"
	swk = 1
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	_Screen.ocorrelativo.Idserie = This.Idserie
	_Screen.ocorrelativo.Nsgte = This.Nsgte
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	TEXT To lp Noshow Textmerge
     ('<<This.cTdoc>>', '<<Left(This.cforma, 1)>>', '<<This.cndoc>>', '<<cfechas(This.dFecha)>>','<<cfechas(This.dfechar)>>', '<<This.cdetalle>>',  <<This.nimpo1>>, <<This.nimpo6>>, <<This.nimpo8>>,'<<This.clugar>>', '<<This.Cmoneda>>', '<<this.ndolar>>', <<this.vigv>>, '<<1>>', <<This.nidprov>>, '<<1>>', <<goApp.nidusua>>, <<this.nirta>>,<<This.codt>>, <<this.nidcta1>>, <<this.nidctai>>, <<this.nidctat>>, <<this.nimpo5>>, <<This.npercepcion>>)
	ENDTEXT
	NAuto = This.EJECUTARf(lC, lp, cur)
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If Left(This.cforma, 1) = 'E'  Then
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
			This.Cmensaje = oxpagar.Cmensaje
			Return 0
		Endif
	Endif
	Select tmpc
	Go Top
	Do While !Eof()
		okardex.niDAUTO = NAuto
		okardex.ncant = tmpc.cant
		okardex.nprec = tmpc.Prec
		okardex.cincl = 'I'
		okardex.ctmvto = 'K'
		okardex.Ctipo = 'C'
		okardex.nidtda = This.codt
		okardex.ncosto = tmpc.Prec
		okardex.ntigv = tmpc.Tigv
		okardex.ncoda = tmpc.Coda
		okardex.nirta = tmpc.Tirta
		nidk = okardex.registrakardexcompras()
		If nidk < 1 Then
			Cmensaje = okardex.Cmensaje
			swk = 0
			Exit
		Endif
		If ActualizaStock(tmpc.Coda, This.codt, tmpc.cant, 'C') = 0 Then
			swk = 0
			Exit
		Endif
		If tmpc.swcosto = 1 And This.cgrabaprecios = 'S' And tmpc.Prec > 0 Then
			If ActualizaCostos(tmpc.Coda, This.dFecha, tmpc.Prec, NAuto, This.nidprov, This.Cmoneda, tmpc.Tigv, This.ndolar, 0) = 0 Then
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
	If _Screen.ocorrelativo.GeneraCorrelativo1() < 1 Then
		This.DEshacerCambios()
		This.Cmensaje = _Screen.ocorrelativo.Cmensaje
		Return 0
	Endif
	If This.GRabarCambios() = 0 Then
		Return 0
	Endif
	This.Imprimir()
	Return 1
	Endfunc
Enddefine
