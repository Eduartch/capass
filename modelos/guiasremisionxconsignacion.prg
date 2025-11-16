Define Class guiaremisionxconsignacion As GuiaRemision Of 'd:\capass\modelos\guiasremision'
	Function grabarx3()
	Set DataSession To This.Idsesion
	If This.VAlidar() < 1 Then
		Return  0
	Endif
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	NAuto = IngresaResumenDcto('09', 'E', This.Ndoc, This.Fecha, This.Fecha, "", ;
		  This.nvalor, This.nigv, This.nTotal, '', 'S', fe_gene.dola, fe_gene.igv, 'k', This.Codigo, ;
		  'V', goApp.nidusua, 1, goApp.Tienda, 0, 0, 0, 0, 0)
	If NAuto < 1
		This.DEshacerCambios()
		Return 0
	Endif
	nidg = This.IngresaGuiasConsignacionx3(This.Fecha, This.ptop, This.ptoll, NAuto, This.Fechat, ;
		  goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, 'N', This.Codigo, This.ubigeocliente, This.codt)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select ltmpvg
	sws = 1
	Go Top
	Do While !Eof()
		If goApp.Tiponegocio = 'D' Then
			dFv = Ctod("01/01/0001")
			nidkar = IngresaKardexFl(NAuto, ltmpvg.Coda, 'V', ltmpvg.Prec, ltmpvg.cant, 'I', 'K', 0, goApp.Tienda, 0, 0, ltmpvg.equi, ;
				  ltmpvg.Unid, ltmpvg.idepta, ltmpvg.pos, ltmpvg.costo, fe_gene.igv, Iif(Empty(ltmpvg.Fechavto), dFv, ltmpvg.Fechavto), ltmpvg.nlote)
		Else
			nidkar = INGRESAKARDEXUAl(NAuto, ltmpvg.Coda, 'V', ltmpvg.Prec, ltmpvg.cant, 'I', 'K', 0, goApp.Tienda, 0, 0, ;
				  ltmpvg.Unid, ltmpvg.idepta, ltmpvg.pos, ltmpvg.costo / fe_gene.igv, fe_gene.igv)
		Endif
		If nidkar = 0
			sws = 0
			Exit
		Endif
		If GrabaDetalleGuiasCons(ltmpvg.Coda, ltmpvg.cant, nidg, nidkar) = 0
			sws = 0
			Exit
		Endif
		If Actualizastock1(ltmpvg.Coda, goApp.Tienda, ltmpvg.cant, 'V', ltmpvg.equi) = 0 Then
			sws = 0
			Exit
		Endif
		Select ltmpvg
		Skip
	Enddo
	If sws = 0 Then
		This.DEshacerCambios()
		This.Cmensaje = "El Item:" + Alltrim(ltmpvg.Desc) + " - " + "Unidad:" + ltmpvg.Unid + " NO TIENE STOCK DISPONIBLE"
		Return 0
	Endif
	If 	This.GeneraCorrelativo() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Select * From (This.Calias) Into Cursor tmpvg Readwrite
	This.Imprimir('S')
	Return 1
	Endfunc
	Function IngresaGuiasConsignacionx3(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13)
	Local lC, lp
	lC			  = "FUNINGRESAGUIASCons"
	cur			  = "yy"
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
	goApp.npara12 = np13
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
	Endtext
	nidguia = This.EJECUTARf(lC, lp, cur)
	If nidguia < 1 Then
		Return 0
	Endif
	Return nidguia
	Endfunc
	Function Grabar()
	If This.IniciaTransaccion() = 0 Then
		Return 0
	Endif
	NAuto = IngresaResumenDcto('09', 'E', This.Ndoc, This.Fecha, This.Fecha, "", 0, 0, 0, '', 'S', fe_gene.dola, fe_gene.igv, 'k', This.Codigo, 'V', goApp.nidusua, 1, goApp.Tienda, 0, 0, 0, 0, 0)
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg = This.IngresaCabecera(Nauto)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s = 1
	Do While !Eof()
		If This.Proyecto = 'psysw' Or This.Proyecto = 'xmsys' Or This.Proyecto = 'psysm' Then
			nidkar = INGRESAKARDEX1(NAuto, tmpvg.Coda, 'V', tmpvg.Prec, tmpvg.cant, 'I', 'K', 0, goApp.Tienda, 0)
		Else
			nidkar = IngresaKardexGrifo(NAuto, tmpvg.Coda, 'V', tmpvg.Prec, tmpvg.cant, 'I', 'K', 0, goApp.Tienda, 0, 0, 0)
		Endif
		If nidkar < 1 Then
			s = 0
			This.Cmensaje = "Al Ingresar al Kardex Detalle de Items"
			Exit
		Endif
		If GrabaDetalleGuias(nidkar, tmpvg.cant, nidg) = 0 Then
			s = 0
			This.Cmensaje = "Al Ingresar Detalle de Guia "
			Exit
		Endif
		If VerificaAlias("tramos") = 1
			Select * From tramos Where idart = tmpvg.Coda  And Cantidad > 0  And Nitem = tmpvg.Nitem Into Cursor strasalidas
			If REgdvto("strasalidas") > 0 Then
				Select strasalidas
				Scan All
					If RegistraTramosSalidas(strasalidas.Cantidad, 'V', nidkar, strasalidas.idart, 0, strasalidas.idin) = 0 Then
						s = 0
						Exit
					Endif
				Endscan
			Endif
		Endif
		If ActualizaStock(tmpvg.Coda, goApp.Tienda, tmpvg.cant, 'V') = 0 Then
			s = 0
			This.Cmensaje = "Al Actualizar Stock "
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If s = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.GeneraCorrelativo() = 1 Then
		If This.GRabarCambios() = 0 Then
			Return 0
		Endif
		This.Imprimir('S')
		Return  1
	Else
		This.DEshacerCambios()
		Return 0
	Endif
	ENDFUNC
	Function IngresaCabecera()
	Local lC, lp
	lC			  = "FUNINGRESAGUIASCONSIGNACION"
	cur			  = "YY"
	goApp.npara1  = This.Fecha
	goApp.npara2  = This.ptop
	goApp.npara3  = This.ptoll
	goApp.npara4  = Nauto
	goApp.npara5  = This.Fechat
	goApp.npara6  = goApp.nidusua
	goApp.npara7  =This.Detalle
	goApp.npara8  = This.Idtransportista
	goApp.npara9  = This.Ndoc
	goApp.npara10 = goApp.Tienda
	goApp.npara11 = This.ubigeocliente
	goApp.npara12= this.Idcliente
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12)
	ENDTEXT
	nidgg = This.EJECUTARf(lC, lp, cur)
	If nidgg < 1 Then
		Return 0
	Endif
	Return nidgg
	ENDFUNC
	Function consultarparaImprimir(Ccursor)
	If !Pemstatus(goApp, 'proyecto', 5) Then
		AddProperty(gpapp, 'proyecto', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\  Select guia_ndoc As Ndoc,guia_fech As fech,guia_fect As fechat,
	If goApp.Proyecto = 'psysr' Or goApp.Proyecto = 'psys' Then
	 \ '' As prod_cod1,
	Else
	 \  prod_cod1,
	Endif
	 \  a.Descri,a.Unid,k.cant,a.Peso,g.guia_ptoll As ptoll,guia_ptop As ptop,
	 \  k.idart As Coda,k.Prec,k.idkar,g.guia_idtr,IFNULL(Placa,'') As Placa,IFNULL(T.razon,'') As razont,
	 \  IFNULL(T.ructr,'') As ructr,IFNULL(T.nombr,'') As conductor,
	 \  IFNULL(T.dirtr,'') As direcciont,IFNULL(T.breve,'') As brevete,
	 \  IFNULL(T.Cons,'') As Constancia,IFNULL(T.Marca,'') As Marca,gg.nruc,"" As ndni,"" As kar_lote,guia_fech As kar_fvto,
	 \  IFNULL(T.placa1,'') As placa1,r.Ndoc As dcto,r.Tdoc,r.Idcliente,r.fech As fechafactura,
	 \  c.Razo,r.Idauto,c.dire,c.ciud,'' As guia_arch,'' As guia_hash,guia_mens,guia_deta,IFNULL(T.tran_tipo,'') As tran_tipo
	 \ From
	 \  fe_guias As g
	 \  INNER Join fe_rcom As r On r.Idauto=g.guia_idau
	 \  Inner join fe_clie as c on c.idclie=r.idcliente
	 \  INNER Join fe_kar As k On k.Idauto=r.Idauto
	 \  INNER Join fe_art As a On a.idart=k.idart
	 \  Left Join fe_tra As T On T.idtra=g.guia_idtr,fe_gene As gg
	 \ Where guia_idgui=<<This.nidguia>> And k.Acti='A' And k.tipo='V'
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine

