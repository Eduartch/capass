Define Class guiaremisionxvtas As GuiaRemision Of 'd:\capass\modelos\guiasremision'
	Function listaritemsparaguia(nid, Calias)
	TEXT To lC Noshow Textmerge
           select a.idauto,a.idkar,a.idart AS coda,a.saldo AS cant,r.fech,r.form,r.idcliente AS idclie,
	       c.razo,c.nruc,c.dire,c.ciud,c.ndni,r.tdoc,r.ndoc,e.descri,e.unid,e.peso,a.saldo
	       FROM (SELECT SUM(IFNULL(`f`.`entr_cant`,0)) AS `entregado`, (`b`.`cant` - SUM(IFNULL(`f`.`entr_cant`,CAST(0 as decimal(12,2))))) AS `saldo`, `a`.`idauto` AS `idauto`, `b`.`idkar`  AS `idkar`, `b`.`idart`  AS `idart`
	       FROM `fe_kar` `b`
	       INNER JOIN `fe_rcom` `a`   ON `a`.`idauto` = `b`.`idauto`
	       LEFT JOIN (SELECT SUM(entr_cant) AS entr_cant,guia_idau,entr_idkar FROM fe_guias AS g
	       INNER JOIN fe_ent AS e ON e.`entr_idgu`=g.`guia_idgui`
	       WHERE g.`guia_idau`=<<nids>> AND g.guia_acti='A' AND e.`entr_acti`='A' GROUP BY entr_idkar,entr_idgu) AS f   ON f.entr_idkar=b.`idkar`
	       WHERE (`a`.`acti` = 'A'   AND `b`.`acti` = 'A' AND a.idauto=<<nids>>) GROUP BY `b`.`idkar`,`a`.`idauto`,`b`.`idart`) AS a
	       INNER JOIN fe_rcom AS r ON r.idauto=a.idauto
	       INNER JOIN fe_clie AS c  ON c.idclie=r.idcliente
	       INNER JOIN fe_art AS e ON e.idart=a.idart
	       where saldo>0  ORDER BY a.idkar
	ENDTEXT
	If This.EjecutaConsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaritemsparaguiaxsyz(nid, Calias)
	TEXT To lC Noshow Textmerge
           select a.idauto,a.idkar,a.idart AS coda,a.saldo AS cant,r.fech,r.form,r.idcliente AS idclie,
	       c.razo,c.nruc,c.dire,c.ciud,c.ndni,r.tdoc,r.ndoc,e.descri,e.unid,e.peso,a.saldo,prod_coda
	       FROM (SELECT SUM(IFNULL(`f`.`entr_cant`,0)) AS `entregado`, (`b`.`cant` - SUM(IFNULL(`f`.`entr_cant`,CAST(0 as decimal(12,2))))) AS `saldo`, `a`.`idauto` AS `idauto`, `b`.`idkar`  AS `idkar`, `b`.`idart`  AS `idart`
	       FROM `fe_kar` `b`
	       INNER JOIN `fe_rcom` `a`   ON `a`.`idauto` = `b`.`idauto`
	       LEFT JOIN (SELECT SUM(entr_cant) AS entr_cant,guia_idau,entr_idkar FROM fe_guias AS g
	       INNER JOIN fe_ent AS e ON e.`entr_idgu`=g.`guia_idgui`
	       WHERE g.`guia_idau`=<<nids>> AND g.guia_acti='A' AND e.`entr_acti`='A' GROUP BY entr_idkar,entr_idgu) AS f   ON f.entr_idkar=b.`idkar`
	       WHERE (`a`.`acti` = 'A'   AND `b`.`acti` = 'A' AND a.idauto=<<nids>>) GROUP BY `b`.`idkar`,`a`.`idauto`,`b`.`idart`) AS a
	       INNER JOIN fe_rcom AS r ON r.idauto=a.idauto
	       INNER JOIN fe_clie AS c  ON c.idclie=r.idcliente
	       INNER JOIN fe_art AS e ON e.idart=a.idart
	       where saldo>0  ORDER BY a.idkar
	ENDTEXT
	If This.EjecutaConsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaritemsparaguiaunidades(nid, Calias)
	TEXT To lC Noshow Textmerge
           select a.idauto,a.idkar,a.idart AS coda,a.saldo AS cant,r.fech,r.form,r.idcliente AS idclie,
	       c.razo,c.nruc,c.dire,c.ciud,c.ndni,r.tdoc,r.ndoc,e.descri,a.kar_unid as unid,e.peso,a.saldo,fvto,lote
	       FROM (SELECT SUM(IFNULL(`f`.`entr_cant`,0)) AS `entregado`, (`b`.`cant` - SUM(IFNULL(`f`.`entr_cant`,0))) AS `saldo`,
	        `a`.`idauto` AS `idauto`, `b`.`idkar`  AS `idkar`, `b`.`idart`  AS `idart`,b.kar_unid,MAX(kar_fvto) as fvto,MAX(kar_lote) As lote
	       FROM `fe_kar` `b`
	       JOIN `fe_rcom` `a`   ON `a`.`idauto` = `b`.`idauto`
	       LEFT JOIN (SELECT SUM(entr_cant) AS entr_cant,guia_idau,entr_idkar FROM fe_guias AS g
	       INNER JOIN fe_ent AS e ON e.`entr_idgu`=g.`guia_idgui`
	       WHERE g.`guia_idau`=<<nids>> AND g.guia_acti='A' AND e.`entr_acti`='A' GROUP BY entr_idkar,entr_idgu) AS f   ON f.entr_idkar=b.`idkar`
	       WHERE (`a`.`acti` = 'A'   AND `b`.`acti` = 'A' AND a.idauto=<<nids>>) GROUP BY `b`.`idkar`,`a`.`idauto`,`b`.`idart`,b.kar_unid) AS a
	       INNER JOIN fe_rcom AS r ON r.idauto=a.idauto
	       INNER JOIN fe_clie AS c  ON c.idclie=r.idcliente
	       INNER JOIN fe_art AS e ON e.idart=a.idart
	       where saldo>0  ORDER BY a.idkar
	ENDTEXT
	If This.EjecutaConsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarguiaporventa(nids, Calias)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\   Select guia_ndoc As Ndoc,guia_fech As fech,guia_fect As fechat,
	\   a.Descri,a.Unid,e.entr_cant As cant,a.peso,g.guia_ptoll,g.guia_ptop As ptop,
	\   k.idart As coda,k.Prec,k.idkar,g.guia_idtr,IFNULL(placa,'') As placa,IFNULL(T.razon,'') As razont,
	\   IFNULL(T.ructr,'') As ructr,IFNULL(T.nombr,'') As conductor,guia_mens,
	\   IFNULL(T.dirtr,'') As direcciont,IFNULL(T.breve,'') As brevete,
	\   IFNULL(T.Cons,'') As constancia,IFNULL(T.marca,'') As marca,c.nruc,c.ndni,entr_iden,
	\   IFNULL(T.placa1,'') As placa1,r.Ndoc As dcto,tdoc,r.idcliente,r.fech As fechadcto,
	\   c.razo,'S' As mone,guia_idgui As idgui,r.Idauto,c.Dire,c.ciud,guia_arch,guia_hash,guia_mens,guia_ubig
	If goApp.Proyecto = 'xsysz' Then
	   \, proc_coda
	Endif
	\   From
	\   fe_guias As g
	\   INNER Join fe_rcom As r On r.Idauto=g.guia_idau
	\   INNER Join fe_clie As c On c.idclie=r.idcliente
	\   INNER Join fe_ent As e On e.entr_idgu=g.guia_idgui
	\   INNER Join fe_kar As k On k.idkar=e.entr_idkar
	\   INNER Join fe_art As a On a.idart=k.idart
	\   Left Join fe_tra As T On T.idtra=g.guia_idtr
	\   Where guia_idgui=<<nids>> and e.entr_acti='A'
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Grabarguiaremitente()
	If !Pemstatus(goApp,'proyecto',5) Then
		AddProperty(goApp,'proyecto','')
	Endif
	Set Procedure To d:\capass\modelos\inventarios Additive
	objinv=Createobject("inventarios")
	objentrega=Createobject("custom")
	AddProperty(objentrega,'cant',0)
	AddProperty(objentrega,'idin',0)
	AddProperty(objentrega,'nidguia',0)
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If This.Idautog > 0 Then
		If AnulaGuiasVentas(This.Idautog, goApp.nidusua) = 0 Then
			DEshacerCambios()
			Return 0
		Endif
	Endif
	nidg = This.IngresaGuiasX(This.Fecha, Alltrim(This.ptop), Alltrim(This.ptoll), This.Idauto, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda, This.ubigeocliente)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s = 1
	Do While !Eof()
		If goApp.Proyecto='psys3' Then
			If This.GrabaDetalleGuiasx3(0, tmpvg.cant, nidg, tmpvg.Coda) < 1 Then
				s = 0
				Exit
			Endif
		Else
			If GrabaDetalleGuias(tmpvg.nidkar, tmpvg.cant, nidg) = 0 Then
				s = 0
				Exit
			Endif
		Endif
		If This.conentregasparciales='S' Then
			objentrega.cant=tmpvg.cant
			objentrega.idin=tmpvg.idin
			objentrega.nidguia=nidg
			If objinv.IngresaEntregas(m.objentrega)<1 Then
				This.cmensaje=objinv.cmensaje
				s=0
				Exit
			Endif
		Endif
		Select tmpvg
		Skip
	Enddo
	If s=0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.GeneraCorrelativo() = 1 And s = 1 Then
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
		Return 0
	Endif
	Endfunc
	Function ActualizaguiasRemitenteventas()
	This.contransaccion = 'S'
	If This.IniciaTransaccion() = 0
		This.contransaccion = ''
		Return 0
	Endif
	If This.ActualizaGuiasVtas(This.Fecha, This.ptop, This.ptoll, This.nautor, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, This.Idautog, goApp.Tienda, This.Codigo) < 1 Then
		This.DEshacerCambios()
		This.contransaccion = ""
		Return 0
	Endif
	If This.ActualizaDetalleGuiasVtasR(This.Calias) < 1 Then
		This.DEshacerCambios()
		This.contransaccion = ""
		Return 0
	Endif
	If This.GRabarCambios() = 0 Then
		This.contransaccion = ""
		Return 0
	Endif
	This.Imprimir('S')
	Return 1
	Endfunc
	Function ActualizaDetalleGuiasVtasR(Ccursor)
	Sw = 1
	Select (m.Ccursor)
	If Vartype(Coda) = 'N' Then
		Set Filter To Coda <> 0
	Else
		Set Filter To Len(Alltrim(Coda)) > 0
	Endif
	Set Deleted Off
	Go Top
	Do While !Eof()
		cdesc = Alltrim(tmpvg.Descri)
		If Deleted()
			If tmpvg.Nreg > 0 Then
				If This.ActualizaDetalleGuiaCons1(tmpvg.Coda, tmpvg.cant, tmpvg.idem, tmpvg.nidkar, This.Idautog, 0, '') = 0 Then
					Sw			  = 0
					This.cmensaje = "Al Desactivar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
					Exit
				Endif
			Endif
		Else
			If tmpvg.Nreg = 0 Then
				If GrabaDetalleGuias(tmpvg.nidkar, tmpvg.cant, This.Idautog) = 0 Then
					s			  = 0
					This.cmensaje = "Al Ingresar Detalle de Guia " + Alltrim(cdesc)
					Exit
				Endif
			Else
				If This.ActualizaDetalleGuiaCons1(tmpvg.Coda, tmpvg.cant, tmpvg.idem, tmpvg.nidkar, This.Idautog, 1, '') = 0 Then
					Sw			  = 0
					This.cmensaje = Alltrim(This.cmensaje) + " Al Actualizar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
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
	Function grabarguiaremitentedirectau
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	NAuto = IngresaResumenDcto('09', 'E', This.Ndoc, This.Fecha, This.Fecha, "", 0, 0, 0, '', 'S', fe_gene.dola, fe_gene.igv, 'k', This.Codigo, 'V', goApp.nidusua, 1, goApp.Tienda, 0, 0, 0, 0, 0)
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg = This.IngresaGuiasX(This.Fecha, This.ptop, Alltrim(This.ptoll), NAuto, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda, This.ubigeocliente)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s = 1
	Do While !Eof()
		nidkar = INGRESAKARDEXUAl(NAuto, tmpvg.Coda, 'V', tmpvg.Prec, tmpvg.cant, 'I', 'K', This.idvendedor, goApp.Tienda, 0, tmpvg.comi / 100, tmpvg.equi, ;
			tmpvg.Unid, tmpvg.idepta, tmpvg.pos, tmpvg.costo, fe_gene.igv)
		If nidkar < 1 Then
			s = 0
			cmensaje = "Al Ingresar al Kardex Detalle de Items"
			Exit
		Endif
		If  This.GrabaDetalleGuias(nidkar, tmpvg.cant, nidg) < 1 Then
			s = 0
			Exit
		Endif
		If Actualizastock1(tmpvg.Coda, goApp.Tienda, tmpvg.cant, 'V', tmpvg.equi) = 0 Then
			s = 0
			This.cmensaje = "Al Actualizar Stock "
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If  This.GeneraCorrelativo() = 1 And s = 1  Then
		If This.GRabarCambios() < 1 Then
			Return 0
		Endif
		This.Imprimir('S')
		Return  1
	Else
		This.DEshacerCambios()
		Return 0
	Endif
	Endfunc
*******************
	Function GrabaDetalleGuias(nidk, ncant, nidg)
	Local lC, lp
	lC			  = "FunDetalleGuiaVentas"
	cur			  = "ig"
	goApp.npara1  = nidk
	goApp.npara2  = ncant
	goApp.npara3  = nidg
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	idg = This.EJECUTARf(lC, lp, cur)
	If idg < 1 Then
		Return 0
	Endif
	Return idg
	Endfunc
	Function actualiaguiasventasdirectasu()
	This.contransaccion = 'S'
	If This.IniciaTransaccion() = 0
		This.contransaccion = ''
		Return 0
	Endif
	If This.ActualizaCabeceraGuiaventasdirectas() < 1 Then
		This.DEshacerCambios()
		This.contransaccion = ""
		Return 0
	Endif
	If This.ActualizaDetalleGuiasVtas(This.Calias) < 1 Then
		This.DEshacerCambios()
		This.contransaccion = ""
		Return 0
	Endif
	If This.GRabarCambios() = 0 Then
		This.contransaccion = ""
		Return 0
	Endif
	This.Imprimir('S')
	Return 1
	Endfunc
	Function grabarguiaremitentevtasx3
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	nidg = This.IngresaGuiasX3vtas(This.Fecha, This.ptop, Alltrim(This.ptoll), This.Codigo, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda, This.ubigeocliente)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s = 1
	Do While !Eof()
		If This.GrabaDetalleGuiasx3(0, tmpvg.cant, nidg, tmpvg.Coda) < 1 Then
			s = 0
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If  This.GeneraCorrelativo() = 1 And s = 1  Then
		If This.GRabarCambios() < 1 Then
			Return 0
		Endif
		This.Imprimir('S')
		Return  1
	Else
		This.DEshacerCambios()
		Return 0
	Endif
	Endfunc
	Function GrabaDetalleGuiasx3(nidk, ncant, nidg, ncoda)
	Local lC, lp
	lC			  = "proDetalleGuiaVentas"
	cur			  = ""
	goApp.npara1  = nidk
	goApp.npara2  = ncant
	goApp.npara3  = nidg
	goApp.npara4  = ncoda
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	ENDTEXT
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaGuiasX3vtas(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11)
	Local lC, lp
	lC			  = "FUNINGRESAGUIAS1"
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
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11)
	ENDTEXT
	nidgg = This.EJECUTARf(lC, lp, cur)
	If nidgg < 1 Then
		Return 0
	Endif
	Return nidgg
	Endfunc
	Function actualiaguiasremitentevtasx3()
	This.contransaccion = 'S'
	If This.IniciaTransaccion() = 0
		This.contransaccion = ''
		Return 0
	Endif
	If This.ActualizaGuiasVtasx3(This.Fecha, This.ptop, This.ptoll, 0, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, This.Idautog, goApp.Tienda, This.Codigo) < 1
		Return 0
	Endif
	If This.ActualizaDetalleGuiasVtas(This.Calias) < 1 Then
		This.DEshacerCambios()
		This.contransaccion = ""
		Return 0
	Endif
	If This.GRabarCambios() = 0 Then
		This.contransaccion = ""
		Return 0
	Endif
	This.Imprimir('S')
	Return 1
	Endfunc
	Function ActualizaGuiasVtasx3(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12)
	Local lC, lp
	m.lC		  = "ProActualizaGuiasVtas"
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
	Else
		Return 1
	Endif
	Endfunc
	Function ActualizaDetalleGuiasVtasx3(Ccursor)
	Sw = 1
	Select (m.Ccursor)
	Set Filter To Coda <> 0
	Set Deleted Off
	Go Top
	Do While !Eof()
		cdesc = Alltrim(tmpvg.Descri)
		If Deleted()
			If Nreg > 0 Then
				If This.ActualizaDetalleGuiaCons1(tmpvg.Coda, tmpvg.cant, tmpvg.idem, tmpvg.Nreg, This.Idautog, 0, '') = 0 Then
					Sw			  = 0
					This.cmensaje = "Al Desactivar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
					Exit
				Endif
			Endif
		Else

			If tmpvg.Nreg = 0 Then
				If  This.GrabaDetalleGuiasx3(nidkar, tmpvg.cant, This.Idautog, tmpvg.Coda) = 0 Then
					s			  = 0
					This.cmensaje = "Al Ingresar Detalle de Guia " + Alltrim(cdesc)
					Exit
				Endif
			Else
				If This.ActualizaDetalleGuiaCons1(tmpvg.Coda, tmpvg.cant, tmpvg.idem, tmpvg.Nreg, This.Idautog, 1, '') < 1 Then
					Sw			  = 0
					This.cmensaje = Alltrim(This.cmensaje) + " Al Actualizar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
					Exit
				Endif
			Endif
		Endif
		Select (Ccursor)
		Skip
	Enddo
	Set Deleted On
	If Sw = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarguiasxcanjear(nidtda, Cestado, Calias)
	Do Case
	Case Cestado = 'P'
		TEXT To lC Noshow Textmerge
	         SELECT guia_ndoc,guia_fech,ndoc,fech,c.razo,r.impo FROM fe_guias AS g
             INNER JOIN fe_rcom AS r ON r.`idauto`=g.guia_idau
             inner join fe_clie as c on c.idclie=r.idcliente
             WHERE guia_acti='A' AND r.`acti`='A' AND r.`codt`=<<nidtda>> AND r.tdoc='09'
		ENDTEXT
	Case Cestado = 'T'
		TEXT To lC Noshow Textmerge
	         SELECT guia_ndoc,guia_fech,ndoc,fech,c.razo,r.impo FROM fe_guias AS g
             INNER JOIN fe_rcom AS r ON r.`idauto`=g.guia_idau
             inner join fe_clie as c on c.idclie=r.idcliente
             WHERE guia_acti='A' AND r.`acti`='A' AND r.`codt`=<<nidtda>>
		ENDTEXT
	Case Cestado = "F"
		TEXT To lC Noshow Textmerge
	         SELECT guia_ndoc,guia_fech,ndoc,fech,c.razo,r.impo FROM fe_guias AS g
             INNER JOIN fe_rcom AS r ON r.`idauto`=g.guia_idau
             inner join fe_clie as c on c.idclie=r.idcliente
             WHERE guia_acti='A' AND r.`acti`='A' AND r.tdoc='01' and  r.`codt`=<<nidtda>>
		ENDTEXT
	Endcase
	If This.EjecutaConsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listartguias(Ccursor)
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select Ndoc,fech,fect,cliente,Refe,tdoc,Transportista,placa,chofer,Detalle,usuario,idguia,
    \coda,Descri,Unid,cant From vguiasventas Where fech Between '<<f1>>' And '<<f2>>'
	If This.Idcliente > 0 Then
     \ And idcliente=<<This.idcliente>>
	Endif
    \ Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine


