Define Class guiaremisionxotros As GuiaRemision Of 'd:\capass\modelos\guiasremision'
	Function listaritemsparaguiaotros(nids, Calias)
	TEXT To lc Noshow Textmerge
	       SELECT a.idart AS coda,entr_cant AS cant,g.guia_fech AS fech,r.idcliente AS idclie,k.idkar,guia_idgui,
	       c.razo,c.nruc,c.dire,c.ciud,c.ndni,r.tdoc,a.descri,a.unid,a.peso,guia_ndoc AS ndoc,guia_idau AS idauto,entr_iden
	       FROM fe_guias AS g
	       INNER JOIN fe_ent AS e ON e.entr_idgu=g.guia_idgui
	       INNER JOIN fe_rcom AS r ON r.idauto=g.guia_idau
	       INNER JOIN fe_clie AS c ON c.idclie=r.idcliente
	       INNER JOIN fe_kar AS k ON k.`idauto`=r.`idauto`
	       INNER JOIN fe_art AS a ON a.idart=k.`idart`
	       WHERE guia_idgui=<<nids>> AND guia_acti='A'  AND entr_acti='A' AND guia_idre=0 
	       UNION ALL
	       SELECT a.idart AS coda,entr_cant AS cant,g.guia_fech AS fech,CAST(0 AS UNSIGNED) AS idclie,CAST(0 AS UNSIGNED) AS idkar,guia_idgui,
	       v.empresa AS razo,v.nruc,v.ptop,v.ciudad AS ciud,"" AS ndni,'09' AS tdoc,a.descri,a.unid,a.peso,guia_ndoc AS ndoc,guia_idau AS idauto,entr_iden
	       FROM fe_guias AS g
	       INNER JOIN fe_ent AS e ON e.entr_idgu=g.guia_idgui
	       INNER JOIN fe_art AS a ON a.idart=e.`entr_idar`,fe_gene AS v
	       WHERE guia_idgui=<<nids>> AND guia_acti='A'  AND entr_acti='A' AND guia_idre=0 ORDER BY entr_iden
	ENDTEXT
	If This.EjecutaConsulta(lc, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function GrabarguiaremitenteOtros()
	objdetalle=Createobject("empty")
	AddProperty(objdetalle,'nidart',0)
	AddProperty(objdetalle,'ncant',0)
	AddProperty(objdetalle,'nidg',0)
	AddProperty(objdetalle,'nidkar',0)
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If This.idautog > 0 Then
		If AnulaGuiasVentas(This.idautog, goApp.nidusua) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	nidg = This.IngresaGuiasXOtros()
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s = 1
	Do While !Eof()
		objdetalle.nidart=tmpvg.coda
		objdetalle.ncant=tmpvg.cant
		objdetalle.nidg=m.nidg
		objdetalle.nidkar=tmpvg.nidkar
		If This.registradetalleguia(objdetalle)<1 Then
*	GrabaDetalleGuias(tmpvg.nidkar, tmpvg.cant, nidg) = 0 Then
			s = 0
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If  This.RegistraRelacionGuias(nidg) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.generacorrelativo() = 1 And s = 1 Then
		If This.GrabarCambios() = 0 Then
			Return 0
		Endif
		This.imprimir('S')
		Return  1
	Else
		This.DEshacerCambios()
		Return 0
	Endif
	Endfunc
	Function ActualizarguiaremitenteOtros()
	objdetalle=Createobject("empty")
	AddProperty(objdetalle,'nidart',0)
	AddProperty(objdetalle,'ncant',0)
	AddProperty(objdetalle,'nidg',0)
	AddProperty(objdetalle,'nidkar',0)
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If AnulaGuiasVentas(This.idautog, goApp.nidusua) = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg = This.IngresaGuiasXOtros()
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s = 1
	Do While !Eof()
		objdetalle.nidart=tmpvg.coda
		objdetalle.ncant=tmpvg.cant
		objdetalle.nidg=m.nidg
		objdetalle.nidkar=tmpvg.nidkar
		If This.registradetalleguia(objdetalle)<1 Then
*	GrabaDetalleGuias(tmpvg.nidkar, tmpvg.cant, nidg) = 0 Then
			s = 0
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If  This.RegistraRelacionGuias(nidg) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If  s = 1 Then
		If This.GrabarCambios() = 0 Then
			Return 0
		Endif
		This.imprimir('S')
		Return  1
	Else
		This.DEshacerCambios()
		Return 0
	Endif
	Endfunc
	Function IngresaGuiasXOtros()
	Local lc, lp
	lc			  = "FUNINGRESAGUIASXOTROS"
	cur			  = "YY"
	goApp.npara1  = This.fecha
	goApp.npara2  = Alltrim(This.ptop)
	goApp.npara3  = Alltrim(This.ptoll)
	goApp.npara4  = This.idauto
	goApp.npara5  =This.fechat
	goApp.npara6  = goApp.nidusua
	goApp.npara7  = This.detalle
	goApp.npara8  = This.Idtransportista
	goApp.npara9  = This.ndoc
	goApp.npara10 = goApp.Tienda
	goApp.npara11 = This.ubigeocliente
	goApp.npara12 = This.Codigo
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12)
	ENDTEXT
	nidgg = This.EJECUTARf(lc, lp, cur)
	If nidgg < 1 Then
		Return 0
	Endif
	Return nidgg
	Endfunc
	Function validarguia()
	If Len(Alltrim(This.detalle)) = 0 Then
		This.Cmensaje = "Es Obligatorio el detalle del Motivo del Traslado"
		Return 0
	Endif
	If This.Validar() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function RegistraRelacionGuias(nidg)
	TEXT To lc Noshow Textmerge
	   UPDATE fe_guias SET guia_idre=<<nidg>> where guia_idgui=<<this.nautor>>;
	ENDTEXT
	If This.Ejecutarsql(lc) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarxid(nid,ccursor)
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	TEXT TO lc NOSHOW TEXTMERGE
	 SELECT guia_ndoc AS ndoc,guia_fech AS fech,guia_fect AS fechat,
     LEFT(guia_ndoc,4) AS serie,SUBSTR(guia_ndoc,5) AS numero,
     a.descri,IFNULL(unid_codu,'NIU')AS unid,e.entr_cant AS cant,a.peso,g.guia_ptoll AS ptollegada,
     e.entr_idar AS coda,0 AS prec,0 AS idkar,g.guia_idtr,placa AS placa,t.razon AS razont,
     t.ructr,t.nombr AS conductor,t.dirtr AS direcciont,t.breve,t.cons AS constancia,t.marca,c.nruc,c.ndni,guia_deta,
     t.placa1,'' AS dcto,'' AS tdoc,g.guia_idcl AS idcliente,v.gene_usol,v.gene_csol,guia_ubig,
     c.razo,guia_idgui AS idgui,0 AS idauto,c.dire,c.ciud,'' AS tdoc1,v.rucfirmad,gene_cert,guia_moti,clavecertificado,
     v.razonfirmad,v.nruc AS rucempresa,v.empresa,v.ubigeo,g.guia_ptop AS ptop,v.ciudad,v.distrito,t.tran_tipo AS tran_tipo
     FROM fe_guias AS g
     INNER JOIN fe_clie AS c ON c.idclie=g.guia_idcl
     INNER JOIN fe_ent AS e ON e.entr_idgu=g.guia_idgui
     INNER JOIN fe_art AS a ON a.idart=e.entr_idar
     LEFT JOIN fe_unidades AS u ON u.unid_codu=a.unid
     INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr,fe_gene AS v
     WHERE guia_idgui=<<nid>>  order by entr_iden
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return  1
	Endfunc
Enddefine
