#Define Url "http://app88.test/"
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
	Text To lC Noshow Textmerge
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
	Endtext
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
		lugar With clugar, irta With nirta, neto With m.nneto
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
		  fechav d, retencion N(8, 2), como N(7, 3), copia c(1), ptop c(150), Idauto N(8), comi N(5, 3), ;
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
	\Where a.Acti <> 'I' And Tdoc='04' And Left(a.rcom_mens,1)<>'A'
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
	Text To cdata Noshow Textmerge
	{
    "nruc":"<<cruc>>",
    "idauto":<<this.nreg>>,
    "empresa":"<<goapp.empresanube>>"
    }
	Endtext
	Messagebox(cdata)
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
	Messagebox(lcHTML)
	orpta = nfJsonRead(lcHTML)
	If  Vartype(orpta.rpta) <> 'U' Then
		This.Cmensaje = orpta.rpta
		If Left(orpta.rpta, 1) = '0' Then
			crpta = orpta.rpta
		Endif
	Else
		This.Cmensaje = Alltrim(lcHTML)
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarparaseleccionar(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To memvar lC Noshow Textmerge
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
Enddefine