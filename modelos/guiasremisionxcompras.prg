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
	Function IngresaGuiasXComprasRemitente(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12)
	Local lC, lp
*:Global cur
	lC			  = "FunIngresaGuiasxComprasRemitente"
	cur			  = "YY"
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
	goApp.npara13 = This.idprov
	goApp.npara14 = This.ubigeocliente
	Text To lp Noshow Textmerge
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,
     ?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
	Endtext
	nidy = This.EJECUTARf(lC, lp, cur)
	If nidy < 1 Then
		Return 0
	Endif
	Return nidy
	Endfunc
	Function GrabaDetalleGuiasRCompras(np1, np2, np3, np4)
	Local lC, lp
	lC			 = "ProIngresaDetalleGuiaRCompras"
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	Endtext
	If This.EJECUTARP(lC, lp, "") < 1 Then
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
		This.Cmensaje = "Ingrese El Proveedor"
		Return 0
*!*		Case This.nruc = Cruc
*!*			This.Cmensaje = "El Remitente no puede Ser la misma Empresa"
*!*			Return 0
	Endcase
	If This.VAlidar() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarguiaxid(nids, Ccursor)
	Text To lC Noshow Textmerge
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
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizarGuiaComprasRemitente()
	Text To lC Noshow Textmerge
	update fe_guias SET guia_fech='<<cfechas(this.fecha)>>',guia_ptop='<<this.ptop>>',guia_ptoll='<<this.ptoll>>',guia_fect='<<cfechas(this.fechat)>>',
	guia_deta='<<this.detalle>>',guia_idtr=<<this.Idtransportista>>,guia_ndoc='<<this.ndoc>>', guia_codt=<<goapp.tienda>>,guia_idu1=<<goapp.nidusua>>,
	guia_dcto='<<this.referencia>>',guia_fecd='<<cfechas(this.Fechafacturacompra)>>',guia_idpr=<<this.idprov>>,guia_ubig='<<this.ubigeocliente>>'
	where guia_idgui=<<this.idautog>>
	Endtext
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
		If This.GrabaDetalleGuiasRCompras(tmpvg.Coda, tmpvg.cant, this.idautog, tmpvg.Codigo) < 1  Then
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
	Text To lC Noshow Textmerge
	UPDATE fe_ent SET entr_acti='I' WHERE entr_idgu=<<nids>>
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
Enddefine










