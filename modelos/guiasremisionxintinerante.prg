Define Class guiaremisionxintinerante As GuiaRemision Of 'd:\capass\modelos\guiasremision'
	Function grabar()
	If This.Idsesion > 1 Then
		Set DataSession To  This.Idsesion
	Endif
	s = 1
	nidkar = 0
	Cmensaje = ""
	objdetalle=Createobject("empty")
	AddProperty(objdetalle,"nidart",0)
	AddProperty(objdetalle,"ncant",0)
	AddProperty(objdetalle,"nidg",0)
	AddProperty(objdetalle,"nidkar",0)
	AddProperty(objdetalle,"unid","")
	If This.VAlidar() < 1 Then
		Return 0
	Endif
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	nidg = This.IngresaGuiasCabecera()
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	nidkar=0
	sws = 1
	Go Top
	Do While !Eof()
		objdetalle.nidart=tmpvg.Coda
		objdetalle.ncant=tmpvg.cant
		objdetalle.nidg=m.nidg
		objdetalle.nidkar=m.nidkar
		objdetalle.unid=tmpvg.unid
*registradetalleguiaUnidades(objdetalle)
		If  This.registradetalleguiaunidades(objdetalle)<1 Then
			sws = 0
			Cmensaje = This.Cmensaje
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If This.GeneraCorrelativo() = 1  And sws = 1 Then
		If This.GRabarCambios() = 0 Then
			Return 0
		Endif
		This.Imprimir('S')
		Return  1
	Else
		This.DEshacerCambios()
		This.Cmensaje = Cmensaje
		Return 0
	Endif
	Endfunc
	Function IngresaGuiasCabecera()
	Local lC, lp
	lC			  = "FuningresaGuiasXIntinerante"
	cur			  = "YY"
	goApp.npara1  = This.Fecha
	goApp.npara2  =This.ptop
	goApp.npara3  = This.ptoll
	goApp.npara4  = 0
	goApp.npara5  = This.fechat
	goApp.npara6  = goApp.nidusua
	goApp.npara7  = This.Detalle
	goApp.npara8  = This.Idtransportista
	goApp.npara9  =This.Ndoc
	goApp.npara10 = goApp.Tienda
	goApp.npara11 =This.ubigeocliente
	TEXT To lp Noshow Textmerge
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11)
	ENDTEXT
	nidy = This.EJECUTARf(lC, lp, cur)
	If nidy < 1 Then
		Return 0
	Endif
	Return nidy
	Endfunc
	Function buscarxidmulti(nid,ccursor)
	If This.Idsesion>0 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT TO lc NOSHOW TEXTMERGE
	 SELECT guia_ndoc AS ndoc,guia_fech AS fech,guia_fect AS fechat,
     LEFT(guia_ndoc,4) AS serie,SUBSTR(guia_ndoc,5) AS numero,
     a.descri,IFNULL(unid_codu,'NIU')AS unid,e.entr_cant AS cant,a.peso,g.guia_ptoll AS ptollegada,
     e.entr_idar AS coda,0 AS prec,0 AS idkar,g.guia_idtr,placa AS placa,t.razon AS razont,
     t.ructr,t.nombr AS conductor,t.dirtr AS direcciont,t.breve,t.cons AS constancia,t.marca,s.nruc,'' as ndni,guia_deta,
     t.placa1,'' AS dcto,'' AS tdoc,CAST(0 As unsigned)  AS idcliente,v.gene_usol,v.gene_csol,guia_ubig,
     s.nomb as razo,guia_idgui AS idgui,0 AS idauto,s.dire,s.ciud,'' AS tdoc1,v.rucfirmad,gene_cert,guia_moti,clavecertificado,
     v.razonfirmad,v.nruc AS rucempresa,v.empresa,v.ubigeo,g.guia_ptop AS ptop,v.ciudad,v.distrito,t.tran_tipo AS tran_tipo
     FROM fe_guias AS g
     INNER JOIN fe_ent AS e ON e.entr_idgu=g.guia_idgui
     INNER JOIN fe_art AS a ON a.idart=e.entr_idar
     LEFT JOIN fe_unidades AS u ON u.unid_codu=a.unid
     INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr
     inner join fe_sucu as s on s.idalma=g.guia_codt,fe_gene AS v
     WHERE guia_idgui=<<nid>>  order by entr_iden
	ENDTEXT
	If This.EjecutaConsulta(lC,ccursor)<1 Then
		Return 0
	Endif
	Return  1
	Endfunc
Enddefine
