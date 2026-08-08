Define Class guiaremisionxcompras As GuiaRemision Of 'd:\capass\modelos\guiasremision'
	Function CreaTemporalGuiasElectronicasRodi(Calias)
	Create Cursor (Calias)(Coda c(15), duni c(20), Descri c(120), Unid c(20), cant N(10, 4), Prec N(10, 5), uno N(10, 2), Dos N(10, 2), lote c(15), ;
		Peso N(10, 2), alma N(10, 2), Ndoc c(12), Nreg N(10), codc c(5), tref c(2), Refe c(20), fecr d, Detalle c(120), fechafactura d, costo N(10, 3), ;
		calma c(3), Valida c, Nitem N(3), saldo N(10, 2), idin N(8), nidkar N(10), coda1 c(15), fech d, fect d, ptop c(150), ;
		ptoll c(120), Archivo c(120), valida1 c(1), valido c(1), stock N(10, 2), ;
		razon c(120), nruc c(11), ndni c(8), conductor c(120), marca c(100), Placa c(15), ;
		placa1 c(15), Constancia c(30), equi N(8, 4), prem N(10, 4), pos N(3), idepta N(5), ;
		brevete c(20), razont c(120), ructr c(11), Motivo c(1), Codigo c(30), comi N(5, 3), idem N(8), ;
		Tigv N(5, 3), caant N(12, 2), nlote c(20), Fechavto d, tipotra c(15))
	Select (Calias)
	Index On Descri Tag Descri
	Index On Nitem Tag Items
	Endfunc
	Function Grabar()
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If This.Idautog > 0 Then
		If AnulaGuiasVentas(This.Idautog, goApp.nidusua) = 0 Then
			Return 0
		Endif
	Endif
	nidg = This.IngresaGuiasXComprasRemitente(This.Fecha, This.ptop, This.ptoll, 0, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda, This.Referencia, This.Fechafacturacompra)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s = 1
	Do While !Eof()
		If This.GrabaDetalleGuiasRCompras(tmpvg.Coda, tmpvg.cant, nidg, tmpvg.Codigo) < 1  Then
			s = 0
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If This.GeneraCorrelativo() = 1  And s = 1 Then
		If This.GRabarCambios() < 1  Then
			Return 0
		Endif
		This.Idautog = m.nidg
		This.Imprimir('S')
		Return  1
	Else
		This.DEshacerCambios()
		Return 0
	Endif
	Endfunc
	Function IngresaGuiasXComprasRemitente(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12)
	Local lC, lp
	lC			  = "FunIngresaGuiasxComprasRemitente"
	cur			  = "YY"
	npara1  = np1
	npara2  = np2
	npara3  = np3
	npara4  = np4
	npara5  = np5
	npara6  = np6
	npara7  = np7
	npara8  = np8
	npara9  = np9
	npara10 = np10
	npara11 = np11
	npara12 = np12
	npara13 = This.idprov
	npara14 = This.ubigeocliente
	TEXT To lp Noshow Textmerge
     (?npara1,?npara2,?npara3,?npara4,?npara5,?npara6,?npara7,?npara8,?npara9,?npara10,?npara11,?npara12,?npara13,?npara14)
	ENDTEXT
	nidy = This.EJECUTARf(lC, lp, cur)
	If nidy < 1 Then
		Return 0
	Endif
	Return nidy
	Endfunc
	Function GrabaDetalleGuiasRCompras(np1, np2, np3, np4)
	Local lC, lp
	lC			 = "ProIngresaDetalleGuiaRCompras"
	npara1 = np1
	npara2 = np2
	npara3 = np3
	npara4 = np4
	TEXT To lp Noshow
     (?npara1,?npara2,?npara3,?npara4)
	ENDTEXT
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function validadetalleguia()
	ccursor = This.Calias
	sw = 1
	Select (ccursor)
	Scan All
		If Len(Alltrim(Descri)) = 0 Then
			This.cmensaje = 'Ingrese Descripción del ITEM'
			sw = 0
			Exit
		Endif
		If Len(Alltrim(Unid)) = 0 Then
			This.cmensaje = 'Ingrese Unidad del ITEM'
			sw = 0
			Exit
		Endif
		If cant <= 0 Then
			This.cmensaje = 'Ingrese Cantidad Válida'
			sw = 0
			Exit
		Endif
		If Peso <= 0 Then
			This.cmensaje = 'Ingrese Peso Válido para el ITEM'
			sw = 0
			Exit
		Endif
	Endscan
	If sw < 1 Then
		Return 0
	Endif
	If This.validarguia() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function validarguia()
	If  Type('oempresa') = 'U' Then
		Cruc = fe_gene.nruc
	Else
		Cruc = Oempresa.nruc
	Endif
	Do Case
	Case  This.idprov < 1
		This.cmensaje = "Ingrese El Proveedor"
		Return 0
	Case This.rucremitente = Cruc
		This.cmensaje = "El Remitente no puede Ser la misma Empresa"
		Return 0
	Endcase
	If This.VAlidar() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarguiaxid(nids, ccursor)
	TEXT To lC Noshow Textmerge
	   select guia_ndoc AS ndoc,guia_fech AS fech,guia_fect AS fechat,guia_deta as detalle,
 	   a.descri,IFNULL(unid_codu,'NIU')AS unid,e.entr_cant AS cant,a.peso,g.guia_ptoll AS ptollegada,
	   e.entr_idar AS coda,e.entr_iden AS idkar,g.guia_idtr,entr_codi as codigo,
	   IFNULL(placa,'') AS placa,IFNULL(t.razon,'') AS razont,guia_mens,guia_arch,
	   IFNULL(t.ructr,'') AS ructr,IFNULL(t.nombr,'') AS conductor,'01' as tref,
	   IFNULL(t.dirtr,'') AS direcciont,IFNULL(t.breve,'') AS brevete,guia_dcto as dcto,
	   IFNULL(t.cons,'') AS constancia,IFNULL(t.marca,'') AS marca,v.nruc as nruc,
	   IFNULL(t.placa1,'') AS placa1,g.guia_ndoc AS dcto,v.idgene AS idcliente,
	   ifnull(p.razo,v.empresa) AS Razo,guia_idgui AS idgui,g.`guia_idgui` AS idauto,'09' AS tdoc,guia_fecd,guia_ubig,
	   guia_ptop as ptop,v.ciudad,v.distrito,IFNULL(t.tran_tipo,'01') AS tran_tipo,ifnull(guia_idpr,CAST(0 as unsigned)) as idprov
	   FROM
	   fe_guias AS g
	   INNER JOIN fe_ent AS e ON e.entr_idgu=g.guia_idgui
	   INNER JOIN fe_art AS a ON a.idart=e.entr_idar
	   inner join fe_prov as p on p.idprov=g.guia_idpr
	   LEFT JOIN fe_unidades AS u ON u.unid_codu=a.unid
	   LEFT JOIN fe_tra AS t ON t.idtra=g.guia_idtr,fe_gene AS v
	   WHERE guia_idgui=<<nids>> and entr_acti='A'
	ENDTEXT
	If This.EjecutaConsulta(lC, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizarGuiaComprasRemitente()
	TEXT To lC Noshow Textmerge
	update fe_guias SET guia_fech='<<cfechas(this.fecha)>>',guia_ptop='<<this.ptop>>',guia_ptoll='<<this.ptoll>>',guia_fect='<<cfechas(this.fechat)>>',
	guia_deta='<<this.detalle>>',guia_idtr=<<this.Idtransportista>>,guia_ndoc='<<this.ndoc>>', guia_codt=<<goapp.tienda>>,guia_idu1=<<goapp.nidusua>>,
	guia_dcto='<<this.referencia>>',guia_fecd='<<cfechas(this.Fechafacturacompra)>>',guia_idpr=<<this.idprov>>,guia_ubig='<<this.ubigeocliente>>'
	where guia_idgui=<<this.idautog>>
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Actualizar()
	If This.IniciaTransaccion() < 1Then
		Return 0
	Endif
	If This.ActualizarGuiaComprasRemitente() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.Anuladetalleguia(This.Idautog) < 1  Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s = 1
	Do While !Eof()
		If This.GrabaDetalleGuiasRCompras(tmpvg.Coda, tmpvg.cant, This.Idautog, tmpvg.Codigo) < 1  Then
			s = 0
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If s = 1 Then
		If This.GRabarCambios() = 0 Then
			Return 0
		Endif
		This.Imprimir('S')
		Return  1
	Else
		This.DEshacerCambios()
		Return 0
	Endif
	Endfunc
	Function Anuladetalleguia(nids)
	TEXT To lC Noshow Textmerge
	UPDATE fe_ent SET entr_acti='I' WHERE entr_idgu=<<nids>>
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function GrabarOtraGuia()
	odetalleguia = Createobject("empty")
	AddProperty(odetalleguia, 'coda', 0)
	AddProperty(odetalleguia, 'ncant', 0)
	AddProperty(odetalleguia, 'nidguia', 0)
	AddProperty(odetalleguia, 'codigo', '')
	AddProperty(odetalleguia, 'detalle', '')
	AddProperty(odetalleguia, 'unidad', '')
	AddProperty(odetalleguia, 'npeso', 0)
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If This.Idautog > 0 Then
		If AnulaGuiasVentas(This.Idautog, goApp.nidusua) = 0 Then
			Return 0
		Endif
	Endif
	nidg = This.IngresaGuiasXComprasRemitenteOtros()
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	odetalleguia.nidguia = m.nidg
	Select tmpvg
	Go Top
	s = 1
	nitem=0
	Do While !Eof()
		nitem=nitem+1
		odetalleguia.Coda = m.nitem
		odetalleguia.ncant = tmpvg.cant
		odetalleguia.Codigo = tmpvg.Codigo
		odetalleguia.Detalle = tmpvg.Descri
		odetalleguia.unidad=tmpvg.unid
		odetalleguia.npeso=tmpvg.peso
		If This.GrabaDetalleOtros(odetalleguia) < 1  Then
			s = 0
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If This.GeneraCorrelativo() = 1  And s = 1 Then
		If This.GRabarCambios() < 1  Then
			Return 0
		Endif
		This.Idautog = m.nidg
		This.Imprimir('S')
		Return  1
	Else
		This.DEshacerCambios()
		Return 0
	Endif
	Endfunc
	Function IngresaGuiasXComprasRemitenteOtros()
	Local lC, lp
	lC			  = "FunIngresaGuiasxComprasRemitenteOtros"
	cur			  = "YY"
	npara1  = This.Fecha
	npara2  = This.ptop
	npara3  = This.ptoll
	npara4  = 0
	npara5  = This.fechat
	npara6  = goApp.nidusua
	npara7  = This.Detalle
	npara8  = This.Idtransportista
	npara9  = This.Ndoc
	npara10 = goApp.Tienda
	npara11 = This.Referencia
	npara12 = This.Fechafacturacompra
	npara13 = This.idprov
	npara14 = This.ubigeocliente
	TEXT To lp Noshow Textmerge
     (?npara1,?npara2,?npara3,?npara4,?npara5,?npara6,?npara7,?npara8,?npara9,?npara10,?npara11,?npara12,?npara13,?npara14)
	ENDTEXT
	nidy = This.EJECUTARf(lC, lp, cur)
	If nidy < 1 Then
		Return 0
	Endif
	Return nidy
	Endfunc
	Function GrabaDetalleOtros(objdetalle)
	Local lC, lp
	lC			 = "ProIngresaDetalleGuiaROtrasCompras"
	npara1 = objdetalle.Coda
	npara2 = odetalleguia.ncant
	npara3 = objdetalle.nidguia
	npara4 = objdetalle.Codigo
	npara5 = objdetalle.Detalle
	npara6 = objdetalle.unidad
	npara7 = objdetalle.npeso
	TEXT To lp Noshow
     (?npara1,?npara2,?npara3,?npara4,?npara5,?npara6,?npara7)
	ENDTEXT
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultar(nids,ctipo,ccursor)
	If m.ctipo='S' Then
		TEXT TO lc NOSHOW TEXTMERGE
	       select guia_ndoc AS ndoc,guia_fech AS fech,guia_fect AS fechat,
	       LEFT(guia_ndoc,4) AS serie,SUBSTR(guia_ndoc,5) AS numero,
		   e.entr_desc as descri,entr_unid as unid,e.entr_cant AS cant,entr_codi,e.entr_peso as peso,g.guia_ptoll AS ptoll,
		   e.entr_idar AS coda,e.entr_iden AS idkar,g.guia_idtr,placa,t.razon razont,t.ructr as ructr,t.nombr AS conductor,
		   t.dirtr AS direcciont,t.breve AS brevete,guia_deta,guia_dcto,guia_fecd,guia_mens,
		   t.cons AS constancia,t.marca AS marca,v.nruc as nruc,idprov,guia_ubig,entr_codi as codigo,
		   t.placa1 AS placa1,g.guia_ndoc AS dcto,v.idgene AS idcliente,'' as guia_arch,'01' as tref,
		   v.empresa AS Razo,guia_idgui AS idgui,g.`guia_idgui` AS idauto,'09' AS tdoc,v.rucfirmad,p.nruc as rucremitente,p.razo as remitente,
		   v.razonfirmad,v.nruc AS rucempresa,v.empresa,v.ubigeo,g.guia_ptop as ptop,v.ciudad,v.distrito,t.tran_tipo AS tran_tipo
		   FROM
		   fe_guias AS g
		   INNER JOIN fe_ent AS e ON e.entr_idgu=g.guia_idgui
		   inner join fe_prov as p on p.idprov=g.guia_idpr
		   inner JOIN fe_tra AS t ON t.idtra=g.guia_idtr,fe_gene AS v
		   WHERE guia_idgui=<<nids>> and entr_acti='A' and guia_otro='S'
		ENDTEXT
	Else
		TEXT TO lc NOSHOW TEXTMERGE
	       select guia_ndoc AS ndoc,guia_fech AS fech,guia_fect AS fechat,
	       LEFT(guia_ndoc,4) AS serie,SUBSTR(guia_ndoc,5) AS numero,
		   a.descri,a.unid,e.entr_cant AS cant,entr_codi,a.peso,g.guia_ptoll AS ptoll,
		   e.entr_idar AS coda,e.entr_iden AS idkar,g.guia_idtr,IFNULL(placa,'') AS placa,IFNULL(t.razon,'') AS razont,
		   IFNULL(t.ructr,'') AS ructr,IFNULL(t.nombr,'') AS conductor,guia_mens,guia_ubig,entr_codi as codigo,
		   IFNULL(t.dirtr,'') AS direcciont,IFNULL(t.breve,'') AS brevete,guia_deta,guia_dcto,guia_fecd,
		   IFNULL(t.cons,'') AS constancia,IFNULL(t.marca,'') AS marca,v.nruc as nruc,p.idprov,
		   IFNULL(t.placa1,'') AS placa1,g.guia_ndoc AS dcto,v.idgene AS idcliente,ifnull(guia_arch,'') as guia_arch,'01' as tref,
		   v.empresa AS Razo,guia_idgui AS idgui,g.`guia_idgui` AS idauto,'09' AS tdoc,v.rucfirmad,p.nruc as rucremitente,p.razo as remitente,
		   v.razonfirmad,v.nruc AS rucempresa,v.empresa,v.ubigeo,g.guia_ptop as ptop,v.ciudad,v.distrito,IFNULL(t.tran_tipo,'01') AS tran_tipo
		   FROM
		   fe_guias AS g
		   INNER JOIN fe_ent AS e ON e.entr_idgu=g.guia_idgui
		   INNER JOIN fe_art AS a ON a.idart=e.entr_idar
		   inner join fe_prov as p on p.idprov=g.guia_idpr
		   LEFT JOIN fe_unidades AS u ON u.unid_codu=a.unid
		   LEFT JOIN fe_tra AS t ON t.idtra=g.guia_idtr,fe_gene AS v
		   WHERE guia_idgui=<<nids>> and entr_acti='A'
		ENDTEXT
	Endif
	If This.EjecutaConsulta(lC,ccursor)<1  Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine











