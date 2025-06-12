Define Class guiaremisionxdevolucion As GuiaRemision Of 'd:\capass\modelos\guiasremision'
	Function Grabar()
	If This.Idsesion > 1 Then
		Set DataSession To  This.Idsesion
	Endif
	s = 1
	nidkar = 0
	Cmensaje = ""
	Set Procedure To d:\capass\modelos\productos Additive
	oprod = Createobject("producto")
	oitems = Createobject("EMPTY")
	AddProperty(oitems, 'nidkar', 0)
	AddProperty(oitems, 'ncant', 0)
	AddProperty(oitems, 'nidart', 0)
	AddProperty(oitems, 'nidguia', 0)
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	Na = IngresaResumenDcto('09', 'E',  This.Ndoc, This.Fecha, This.Fecha, This.Detalle, 0, 0, 0, '', 'S',  fe_gene.dola, fe_gene.igv, 'k', This.idprov, 'C', goApp.nidusua, 0, goApp.Tienda, 0, 0, 0, 0, 0)
	If Na < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg = This.IngresaGuiasxDcompras(This.Fecha, This.ptop, This.ptoll, Na, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	Do While !Eof()
		If This.condsctostock = 'S' Then
			ncodalmacen = goApp.Tienda
			If fe_gene.alma_nega = 0 Then
				If oprod.consultarStocks(tmpvg.Coda, "Stock") < 1 Then
					s = 0
					This.Cmensaje = oprod.Cmensaje
					Exit
				Endif
				Do Case
				Case goApp.Tienda = 1
					Ts = stock.uno
				Case goApp.Tienda = 2
					Ts = stock.Dos
				Case goApp.Tienda = 3
					Ts = stock.tre
				Case goApp.Tienda = 4
					Ts = stock.cua
				Case goApp.Tienda = 5
					Ts = stock.cin
				Case goApp.Tienda = 6
					Ts = stock.sei
				Case goApp.Tienda = 7
					Ts = stock.sie
				Case goApp.Tienda = 8
					Ts = stock.och
				Case goApp.Tienda = 9
					Ts = stock.nue
				Case goApp.Tienda = 10
					Ts = stock.die
				Endcase
				If tmpvg.cant > Ts Then
					s = 0
					Cmensaje = 'En Stock ' + Alltrim(Str(Ts, 10)) + '  no Disponible para esta Transacción '
					Exit
				Endif
				m.nidkar = INGRESAKARDEX1(Na, tmpvg.Coda, "V", 0, tmpvg.cant, "I", "K", 0, ncodalmacen, 0, 0)
				If nidkar < 1 Then
					s = 0
					Cmensaje = 'Al Registrar Kardex'
					Exit
				Endif
			Endif
		Else
			m.nidkar=0
			ncodalmacen = 0
		Endif
		m.oitems.nidkar = m.nidkar
		m.oitems.ncant = tmpvg.cant
		m.oitems.nidguia = m.nidg
		m.oitems.nidart = tmpvg.Coda
		If This.RegistraItemsGuia(m.oitems) < 1
			s = 0
			Cmensaje = This.Cmensaje
			Exit
		Endif
		If This.condsctostock= 'S' Then
			If oprod.ActualizaStock(tmpvg.Coda, goApp.Tienda, tmpvg.cant, 'V') < 1 Then
				s = 0
				Cmensaje = oprod.Cmensaje
				Exit
			Endif
		Endif
		Select tmpvg
		Skip
	Enddo
	If This.GeneraCorrelativo() = 1  And s = 1 Then
		If This.GRabarCambios() = 0 Then
			Return 0
		Endif
		If This.Proyecto = 'xsysz' Then
			This.Imprimirguiaxsysz("tmpvg", 'S')
		Else
			This.Imprimir('S')
		Endif
		Return  1
	Else
		This.DEshacerCambios()
		This.Cmensaje = Cmensaje
		Return 0
	Endif
	Endfunc
	Function IngresaGuiasxDcompras(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10)
	Local lC, lp
	lC			  = "FUNINGRESAGUIASxdCompras"
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
	goApp.npara11 = This.idprov
	goApp.npara12 = This.ubigeocliente
	TEXT To lp Noshow Textmerge
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12)
	ENDTEXT
	nidy = This.EJECUTARf(lC, lp, cur)
	If nidy < 1 Then
		Return 0
	Endif
	Return nidy
	Endfunc
	Function validarguia()
	If This.Idsesion > 1 Then
		Set DataSession To  This.Idsesion
	Endif
	If This.idprov < 1 Then
		This.Cmensaje = "Ingrese El Proveedor"
		Return 0
	Endif
	If This.Encontrado <> 'S'  Then
		If  PermiteIngresoCompras(This.Ndoc, This.Tdoc, This.idprov, 0, This.Fecha) < 1
			This.Cmensaje = "NÚmero de Guia Ya Registrado"
			Return 0
		Endif
	Endif
	If This.VAlidar() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function grabarodi()
	If This.Idsesion > 1 Then
		Set DataSession To  This.Idsesion
	Endif
	s = 1
	nidkar = 0
	Cmensaje = ""
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	Na = IngresaResumenDcto('09', 'E', ;
		This.Ndoc, This.Fecha, This.Fecha, This.Detalle, 0, 0, 0, '', 'S', fe_gene.dola, fe_gene.igv, 'k', This.idprov, 'C', goApp.nidusua, 0, goApp.Tienda, 0, 0, 0, 0, 0)
	If Na < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg = This.IngresaGuiasxDcompras(This.Fecha, This.ptop, This.ptoll, Na, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	Do While !Eof()
		If fe_gene.alma_nega = 0 Then
			If DevuelveStocks(tmpvg.Coda, "Stock") < 1 Then
				s = 0
				Cmensaje = 'No está activado la venta con Negativos'
				Exit
			Endif
			Do Case
			Case goApp.Tienda = 1
				Ts = stock.uno
			Case goApp.Tienda = 2
				Ts = stock.Dos
			Case goApp.Tienda = 3
				Ts = stock.tre
			Case goApp.Tienda = 4
				Ts = stock.cua
			Case goApp.Tienda = 5
				Ts = stock.cin
			Case goApp.Tienda = 6
				Ts = stock.sei
			Case goApp.Tienda = 7
				Ts = stock.sie
			Case goApp.Tienda = 8
				Ts = stock.och
			Case goApp.Tienda = 9
				Ts = stock.nue
			Case goApp.Tienda = 10
				Ts = stock.die
			Endcase
			If tmpvg.cant > Ts Then
				s = 0
				Cmensaje = 'En Stock ' + Alltrim(Str(Ts, 10)) + '  no Disponible para esta Transacción '
				Exit
			Endif
		Endif
		nidkar = INGRESAKARDEXR(Na, tmpvg.Coda, "V", 0, tmpvg.cant, "I", "K", 0, goApp.Tienda, 0, 0, '')
		If nidkar < 1 Then
			s = 0
			Cmensaje = 'Al Registrar Kardex'
			Exit
		Endif
		If GrabaDetalleGuias(nidkar, tmpvg.cant, nidg) < 1 Then
			s = 0
			Cmensaje = 'Al Registrar detalle de Guia'
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
		This.Cmensaje = Cmensaje
		Return 0
	Endif
	Endfunc
	Function grabarx()
	If This.Idsesion > 1 Then
		Set DataSession To  This.Idsesion
	Endif
	s = 1
	nidkar = 0
	Cmensaje = ""
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	Na = IngresaResumenDcto('09', 'E',	This.Ndoc, This.Fecha, This.Fecha, This.Detalle, 0, 0, 0, '', 'S', fe_gene.dola, fe_gene.igv, 'k', This.idprov, 'C', goApp.nidusua, 0, goApp.Tienda, 0, 0, 0, 0, 0)
	If Na < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg = This.IngresaGuiasxDcompras(This.Fecha, This.ptop, This.ptoll, Na, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	Do While !Eof()
		If fe_gene.alma_nega = 0 Then
			If DevuelveStocks(tmpvg.Coda, "Stock") < 1 Then
				s = 0
				Cmensaje = 'No está activado la venta con Negativos'
				Exit
			Endif
			Do Case
			Case goApp.Tienda = 1
				Ts = stock.uno
			Case goApp.Tienda = 2
				Ts = stock.Dos
			Case goApp.Tienda = 3
				Ts = stock.tre
			Case goApp.Tienda = 4
				Ts = stock.cua
			Case goApp.Tienda = 5
				Ts = stock.cin
			Case goApp.Tienda = 6
				Ts = stock.sei
			Case goApp.Tienda = 7
				Ts = stock.sie
			Case goApp.Tienda = 8
				Ts = stock.och
			Case goApp.Tienda = 9
				Ts = stock.nue
			Case goApp.Tienda = 10
				Ts = stock.die
			Endcase
			If tmpvg.cant > Ts Then
				s = 0
				Cmensaje = 'En Stock ' + Alltrim(Str(Ts, 10)) + '  no Disponible para esta Transacción '
				Exit
			Endif
		Endif
		nidkar = INGRESAKARDEXR(Na, tmpvg.Coda, "V", 0, tmpvg.cant, "I", "K", 0, goApp.Tienda, 0, 0, 0)
		If nidkar < 1 Then
			s = 0
			Cmensaje = 'Al Registrar Kardex'
			Exit
		Endif
		If GrabaDetalleGuias(nidkar, tmpvg.cant, nidg) < 1 Then
			s = 0
			Cmensaje = 'Al Registrar detalle de Guia'
			Exit
		Endif
		If ActualizaStock(tmpvg.Coda, goApp.Tienda, tmpvg.cant, 'V') < 1 Then
			s = 0
			Cmensaje = 'Al actualizar Stock'
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
		This.Cmensaje = Cmensaje
		Return 0
	Endif
	Endfunc
	Function grabarD()
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
	If This.VAlidar() < 1 Then
		Return 0
	Endif
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	Na = IngresaResumenDcto('09', 'E', This.Ndoc, This.Fecha, This.Fecha, This.Detalle, 0, 0, 0, '', 'S', fe_gene.dola, fe_gene.igv, 'k', This.idprov, 'C', goApp.nidusua, 0, goApp.Tienda, 0, 0, 0, 0, 0)
	If Na < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg = This.IngresaGuiasxDcompras(This.Fecha, This.ptop, This.ptoll, Na, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	nidkar=0
	sws = 1
	Go Top
	Do While !Eof()
		dFv = Ctod("01/01/0001")
		If This.condsctostock='S' Then
			nidkar = IngresaKardexFl(Na, tmpvg.Coda, 'V', tmpvg.Prec, tmpvg.cant, 'I', 'K', 0, goApp.Tienda, 0, 0, tmpvg.equi, ;
				tmpvg.Unid, tmpvg.idepta, tmpvg.pos, tmpvg.costo, fe_gene.igv, Iif(Empty(tmpvg.Fechavto), dFv, tmpvg.Fechavto), tmpvg.nlote)
			If nidkar < 1
				sws = 0
				Cmensaje = "Al Registrar el detalle de la guia"
				Exit

			Endif
			If Actualizastock1(tmpvg.Coda, goApp.Tienda, tmpvg.cant, 'V', tmpvg.equi) = 0 Then
				Cmensaje = "Al Actualizar Stock"
				sws = 0
				Exit
			Endif
		Endif
		objdetalle.nidart=tmpvg.Coda
		objdetalle.ncant=tmpvg.cant
		objdetalle.nidg=m.nidg
		objdetalle.nidkar=m.nidkar
		If  This.registradetalleguia(objdetalle)<1 Then
*GrabaDetalleGuiasCons(tmpvg.Coda, tmpvg.cant, nidg, nidkar) = 0
			sws = 0
			Cmensaje = This.Cmensaje
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
		This.Cmensaje = Cmensaje
		Return 0
	Endif
	Endfunc
	Function listarguiapordevolucion(nids, Calias)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\   Select guia_ndoc As Ndoc,guia_fech As fech,guia_fect As fechat,
	\   a.Descri,a.Unid,e.entr_cant As cant,a.peso,g.guia_ptoll,g.guia_ptop As ptop,
	\   a.idart As Coda,0 As Prec,e.entr_iden As idkar,g.guia_idtr,ifnull(placa,'') As placa,ifnull(T.razon,'') As razont,
	\   T.ructr As ructr,T.nombr As conductor,guia_mens,
	\   T.dirtr As direcciont,T.breve As brevete,
	\   T.Cons As constancia,T.marca As marca,c.nruc,c.ndni,entr_iden,
	\   T.placa1 As placa1,r.Ndoc As dcto,Tdoc,r.idcliente,r.fech As fechadcto,guia_deta,
	\   c.Razo,'S' As mone,guia_idgui As idgui,r.Idauto,c.Dire,c.ciud,guia_arch,guia_hash,guia_mens,guia_ubig,guia_idpr
	If goApp.Proyecto = 'xsysz' Then
	   \,prod_coda
	Endif
	\   From
	\   fe_guias As g
	\   inner Join fe_rcom As r On r.Idauto=g.guia_idau
	\   inner Join fe_prov As c On c.idprov=g.guia_idpr
	\   inner Join fe_ent As e On e.entr_idgu=g.guia_idgui
    \   inner Join fe_art As a On a.idart=e.entr_idar
	\   inner Join fe_tra As T On T.idtra=g.guia_idtr
	\   Left Join fe_kar As k On k.idkar=e.entr_idkar
	\   Where guia_idgui=<<nids>>
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizaguiasRemitentedevolucion()
	Set Procedure To d:\capass\modelos\productos Additive
	oprod = Createobject("producto")
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If This.Idautog > 0 Then
		If AnulaGuiasVentas(This.Idautog, goApp.nidusua) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If  ActualizaResumenDcto('09', 'E', This.Ndoc, This.Fecha, This.Fecha, This.Detalle, 0, 0, 0, "", 'S', fe_gene.dola, fe_gene.igv, 'K', This.idprov, 'V', goApp.nidusua, 0, goApp.Tienda, 0, 0, 0, 0, 0, This.Idauto) = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg = This.IngresaGuiasxDcompras(This.Fecha, This.ptop, This.ptoll, This.Idauto, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	Do While !Eof()
		If This.condsctostock = 'S' Then
			If fe_gene.alma_nega = 0 Then
				If oprod.consultarStocks(tmpvg.Coda, "Stock") < 1 Then
					s = 0
					Cmensaje =  oprod.Cmensaje
					Exit
				Endif
				Do Case
				Case goApp.Tienda = 1
					Ts = stock.uno
				Case goApp.Tienda = 2
					Ts = stock.Dos
				Case goApp.Tienda = 3
					Ts = stock.tre
				Case goApp.Tienda = 4
					Ts = stock.cua
				Case goApp.Tienda = 5
					Ts = stock.cin
				Case goApp.Tienda = 6
					Ts = stock.sei
				Case goApp.Tienda = 7
					Ts = stock.sie
				Case goApp.Tienda = 8
					Ts = stock.och
				Case goApp.Tienda = 9
					Ts = stock.nue
				Case goApp.Tienda = 10
					Ts = stock.die
				Endcase
				If tmpvg.cant > Ts Then
					s = 0
					Cmensaje = 'En Stock ' + Alltrim(Str(Ts, 10)) + '  no Disponible para esta Transacción '
					Exit
				Endif
				ncodalmacen = goApp.Tienda
			Endif
		Else
			ncodalmacen = 0
		Endif
		nidkar = INGRESAKARDEX1(This.Idauto, tmpvg.Coda, "V", 0, tmpvg.cant, "I", "K", 0, ncodalmacen, 0, 0)
		If nidkar < 1 Then
			s = 0
			Cmensaje = 'Al Registrar Kardex'
			Exit
		Endif
		If GrabaDetalleGuias(nidkar, tmpvg.cant, nidg) < 1 Then
			s = 0
			Cmensaje = 'Al Registrar detalle de Guia'
			Exit
		Endif
		If This.condsctostock = 'S' Then
			If oprod.ActualizaStock(tmpvg.Coda, goApp.Tienda, tmpvg.cant, 'V') < 1 Then
				s = 0
				Cmensaje = oprod.Cmensaje
				Exit
			Endif
		Endif
		Select tmpvg
		Skip
	Enddo
	If This.GRabarCambios() = 0 Then
		Return 0
	Endif
	If This.Proyecto = 'xsysz' Then
		This.Imprimirguiaxsysz("tmpvg", 'S')
	Else
		This.Imprimir('S')
	Endif
	Return 1
	Endfunc
	Function ActualizaGuiasdevolucion(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12)
	Local lC, lp
*:Global cur
	m.lC		  = "ProActualizaGuiasDevolucion"
	cur			  = ""
	goApp.npara1  = m.np1
	goApp.npara2  = m.np2
	goApp.npara3  = m.np3
	goApp.npara4  = m.np4
	goApp.npara5  = m.np5
	goApp.npara6  = m.np6
	goApp.npara7  = m.np7
	goApp.npara8  = m.np8
	goApp.npara9  = m.np9
	goApp.npara10 = This.Idautog
	goApp.npara11 = m.np11
	goApp.npara12 = m.np12
	goApp.npara13 = This.ubigeocliente
	TEXT To m.lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?this.idautog,?goapp.npara11,?goapp.npara12,?goapp.npara13)
	ENDTEXT
	If This.EJECUTARP(m.lC, m.lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registradetalleguia(objdetalle)
	TEXT TO lc NOSHOW TEXTMERGE
	   INSERT INTO fe_ent(entr_idar,entr_cant,entr_idgu,entr_idkar)VALUES(<<objdetalle.nidart>>,<<objdetalle.ncant>>,<<objdetalle.nidg>>,<<objdetalle.nidkar>>)
	ENDTEXT
	If This.ejecutarsql(lC)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine

















