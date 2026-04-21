Define Class guiaremisionxintinerante As GuiaRemision Of 'd:\capass\modelos\guiasremision'
	Function grabar()
	If This.Idsesion > 1 Then
		Set DataSession To  This.Idsesion
	Endif
	s = 1
	nidkar = 0
	Cmensaje = ""
	objdetalle = Createobject("empty")
	AddProperty(objdetalle, "nidart", 0)
	AddProperty(objdetalle, "ncant", 0)
	AddProperty(objdetalle, "nidg", 0)
	AddProperty(objdetalle, "nidkar", 0)
	AddProperty(objdetalle, "unid", "")
	Select idauto From tmpvg Into Cursor rgi Group By idauto
	If This.GuiaIntinerarnteVAlidar() < 1 Then
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
	nidkar = 0
	sws = 1
	Go Top
	Do While !Eof()
		objdetalle.nidart = tmpvg.Coda
		objdetalle.ncant = tmpvg.cant
		objdetalle.nidg = m.nidg
		objdetalle.nidkar = m.nidkar
		objdetalle.unid = tmpvg.unid
		If  This.registradetalleguiaunidades(objdetalle) < 1 Then
			sws = 0
			Cmensaje = This.Cmensaje
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If sws = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	sws = 1
	Select rgi
	Scan All
		If _Screen.oventas.ActualizarventaconGuiaIntinerante(rgi.idauto, nidg) < 1 Then
			This.Cmensaje = _Screen.oventas.Cmensaje
			sws = 0
			Exit
		Endif
	Endscan
	If sws = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GeneraCorrelativo() < 1
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() = 0 Then
		Return 0
	Endif
	This.Imprimir('S')
	Return  1
	Endfunc
	Function IngresaGuiasCabecera()
	Local lC, lp
	lC			  = "FuningresaGuiasXIntinerante"
	cur			  = "YY"
	goApp.npara1  = This.Fecha
	goApp.npara2  = This.ptop
	goApp.npara3  = This.ptoll
	goApp.npara4  = 0
	goApp.npara5  = This.fechat
	goApp.npara6  = goApp.nidusua
	goApp.npara7  = This.Detalle
	goApp.npara8  = This.Idtransportista
	goApp.npara9  = This.Ndoc
	goApp.npara10 = goApp.Tienda
	goApp.npara11 = This.ubigeocliente
	Text To lp Noshow Textmerge
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11)
	Endtext
	nidy = This.EJECUTARf(lC, lp, cur)
	If nidy < 1 Then
		Return 0
	Endif
	Return nidy
	Endfunc
	Function buscarxidmulti(nid, ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lC Noshow Textmerge
	 SELECT guia_ndoc AS ndoc,guia_fech AS fech,guia_fect AS fechat,
     LEFT(guia_ndoc,4) AS serie,SUBSTR(guia_ndoc,5) AS numero,
     a.descri,IFNULL(unid_codu,'NIU')AS unid,e.entr_cant AS cant,a.peso,g.guia_ptoll AS ptollegada,
     e.entr_idar AS coda,0 AS prec,0 AS idkar,g.guia_idtr,placa AS placa,t.razon AS razont,guia_mens,
     t.ructr,t.nombr AS conductor,t.dirtr AS direcciont,t.breve,t.cons AS constancia,t.marca,s.nruc,'' AS ndni,guia_deta,
     t.placa1,'' AS dcto,'' AS tdoc,CAST(0 AS UNSIGNED)  AS idcliente,s.gene_usol,s.gene_csol,guia_ubig,entr_iden,
     s.nomb AS razo,guia_idgui AS idgui,0 AS idauto,s.dire,s.ciud,'' AS tdoc1,s.rucfirmad,s.gene_cert,guia_moti,s.clavecertificado,
     s.razonfirmad,s.nruc AS rucempresa,s.nomb AS empresa,s.ubigeo,g.guia_ptop AS ptop,s.ciud AS ciudad,s.distrito,t.tran_tipo AS tran_tipo
     FROM fe_guias AS g
     INNER JOIN fe_ent AS e ON e.entr_idgu=g.guia_idgui
     INNER JOIN fe_art AS a ON a.idart=e.entr_idar
     LEFT JOIN fe_unidades AS u ON u.unid_codu=a.unid
     INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr
     INNER JOIN fe_sucu AS s ON s.idalma=g.guia_codt
     WHERE guia_idgui=<<m.nid>>  ORDER BY entr_iden
	Endtext
	If This.EjecutaConsulta(lC, ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function GuiaIntinerarnteVAlidar()
	Text To lC Noshow Textmerge
     select guia_idgui as idauto FROM fe_guias WHERE guia_ndoc='<<this.ndoc>>' AND guia_acti='A' limit 1
	Endtext
	If This.EjecutaConsulta(lC, 'ig') < 1 Then
		Return 0
	Endif
	If ig.idauto > 0 Then
		cencontrado = 'S'
	Else
		cencontrado = 'N'
	Endif
	If This.Proyecto <> 'psysr' Then
		If  This.Verificacantidadantesvtas() < 1 THEN 
			If !Empty(goApp.mensajeApp) Then
				This.Cmensaje = goApp.mensajeApp
				goApp.mensajeApp = ""
			Else
				This.Cmensaje = "Ingrese Cantidad es Obligatoria"
			Endif
			Return 0
		Endif
	Else
		If Verificacantidadantesvtasbat(This.Calias) = 0
			This.Cmensaje = "Ingrese Cantidad es Obligatoria"
			Return 0
		Endif
	Endif
	If  Type('oempresa') = 'U' Then
		Cruc = fe_gene.nruc
	Else
		Cruc = Oempresa.nruc
	Endif
	Do Case
	Case cencontrado = 'S' And This.Idautog = 0
		This.Cmensaje = "NÚMERO de Documento Ya Registrado"
		Return 0
	Case Left(This.Ndoc, 4) = "0000"  Or Val(Substr(This.Ndoc, 4)) = 0
		This.Cmensaje = "Ingrese NÚMERO de Guia Remitente Válido"
		Return 0
	Case Len(Alltrim(Left(This.Ndoc, 4))) < 4 Or Len(Alltrim(Substr(This.Ndoc, 4))) < 8 Or Len(Alltrim(This.Ndoc)) < 12
		This.Cmensaje = "Número de Documento NO Válido....Longitud Incorrecta"
		Return  0
	Case !esfechaValida(This.Fecha)
		This.Cmensaje = "La Fecha de emisón no es Válida"
		Return 0
	Case !esFechaValidaftraslado(This.fechat)
		This.Cmensaje = "La Fecha de Traslado no es Válida"
		Return 0
	Case This.fechat < This.Fecha
		This.Cmensaje = "La Fecha de Traslado no puede ser menor a la fecha de Emisión"
		Return 0
	Case Date() - This.Fecha > 1 And This.Tdoc <> 'TT'
		This.Cmensaje = "Solo se Emiten Guias con 1 Día de Atraso"
		Return 0
	Case Len(Alltrim(This.ptoll)) = 0
		This.Cmensaje = "Ingrese La dirección de LLegada"
		Return 0
	Case Len(Alltrim(This.ptop)) = 0
		This.Cmensaje = "Ingrese La dirección de Partida"
		Return 0
	Case Left(This.Mensajerptasunat, 1) = '0'
		This.Cmensaje = "Este Documento Ya esta Informado a SUNAT no es posible Actualizar"
		Return 0
	Case This.Tpeso = 0 And This.Tdoc = '09'
		This.Cmensaje = "El Peso de los Productos es Obligatorio"
		Return 0
	Case This.Idtransportista < 1 And This.Tdoc = '09'
		This.Cmensaje = "El Transportista es Obligatorio"
		Return 0
	Case (Empty(This.razont) Or Len(Alltrim(This.ructr)) <> 11 Or  Len(Alltrim(This.Constancia)) = 0) And Left(This.tipotransporte, 2) = '01' And This.Tdoc = '09'
		This.Cmensaje = "Es obligatorio el RUC, el Nombre y el Registro MTC"
		Return 0
	Case Empty(This.razont) And Len(Alltrim(This.ructr)) <> 11 And Left(This.tipotransporte, 2) = '02' And Len(Alltrim(This.brevete)) <> 9 And Len(Alltrim(This.conductor)) = 0 And This.Tdoc = '09'
		This.Cmensaje = "Es obligatorio el nombre de Chofer y Brevete"
		Return 0
	Case This.tipotransporte = '02' And (!Isalpha(Left(This.brevete, 1))  Or  !Isdigit(Substr(This.brevete, 2))) And This.Tdoc = '09'
		This.Cmensaje = "El Brevete no es Válido... empieza con una Letra y lo demás son digitos"
		Return 0
	Case This.tipotransporte = '01' And This.ructr = Cruc
		This.Cmensaje = "El Ruc del Transporte es de la Empresa y el tipo de transporte debe ser Privado Tipo 02"
		Return 0
	Case Empty(This.ubigeocliente) And This.Tdoc = '09'
		This.Cmensaje = "Ingrese el Ubigeo del Punto de LLegada"
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function Actualizadetalle(ccursor)
	Sw = 1
	objdetalle = Createobject("empty")
	AddProperty(objdetalle, "nidart", 0)
	AddProperty(objdetalle, "ncant", 0)
	AddProperty(objdetalle, "nidg", This.Idautog)
	AddProperty(objdetalle, "nidkar", 0)
	AddProperty(objdetalle, "unid", "")
	AddProperty(objdetalle, "nreg", 0)
	AddProperty(objdetalle, "nopt", 0)
	Select tmpvg
	Set Filter To Coda <> 0
	Set Deleted Off
	Go Top
	Do While !Eof()
		objdetalle.nidart = tmpvg.Coda
		objdetalle.ncant = tmpvg.cant
		objdetalle.unid = tmpvg.unid
		If Deleted()
			objdetalle.nreg = tmpvg.nreg
			objdetalle.nopt = 0
			If This.actualizaDetalleData(objdetalle) < 1 Then
				Sw			  = 0
				Exit
			Endif
		Else
			If tmpvg.nreg = 0 Then
				If  This.registradetalleguiaunidades(objdetalle) < 1 Then
					Sw = 0
					Exit
				Endif
			Else
				objdetalle.nreg = tmpvg.nreg
				objdetalle.nopt = 1
				If This.actualizaDetalleData(objdetalle) < 1 Then
					Sw			  = 0
					Exit
				Endif
			Endif
		Endif
		Select tmpvg
		Skip
	Enddo
	Set Deleted On
	If Sw = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function  ActualizaDetalleData(objdetalle)
	Local lC, lp
	cur			 = ""
	m.lC		 = 'ProActualizaDetalleGuiasCons'
	goApp.npara1 = objdetalle.nidart
	goApp.npara2 = objdetalle.ncant
	goApp.npara3 = objdetalle.nreg
	goApp.npara4 = 0
	goApp.npara5 = objdetalle.nidg
	goApp.npara6 = objdetalle.nopt
	goApp.npara7 = objdetalle.unid
	Text To m.lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7)
	Endtext
	If This.EJECUTARP(m.lC, m.lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Actualizar()
	Select idauto From tmpvg Into Cursor rgi Group By idauto
	If This.GuiaIntinerarnteVAlidar() < 1 Then
		Return 0
	Endif
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If This.ActualizaCabecera() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.Actualizadetalle('tmpvg') < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	sws = 1
	Select rgi
	Scan All
		If _Screen.oventas.ActualizarventaconGuiaIntinerante(rgi.idauto, This.Idautog) < 1 Then
			This.Cmensaje = _Screen.oventas.Cmensaje
			sws = 0
			Exit
		Endif
	Endscan
	If sws = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() = 0 Then
		Return 0
	Endif
	This.Imprimir('S')
	Return  1
	Endfunc
Enddefine









