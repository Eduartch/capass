Define Class promociones As OData Of "d:\capass\database\data.prg"
	feci = Date()
	fecf = Date()
	ncosto = 0
	npunto = 0
	estado = ""
	nidprom = 0
	niDAUTO = 0
	nidclie = 0
	npunto = 0
	ndscto = 0
	Cdetalle = ""
	Ctipo = ""
	dFecha = Date()
	Function Listar()
	Ccursor = 'c_' + Sys(2015)
	Df = Cfechas(fe_gene.fech)
	TEXT To lC Noshow Textmerge
	     SELECT prom_feci,prom_fecf,prom_cost,prom_punt,prom_idprom FROM fe_prom WHERE prom_acti='A'  AND '<<df>>' BETWEEN prom_feci AND prom_fecf limit 1
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	AddProperty(_Screen, 'punto', prom_punt)
	AddProperty(_Screen, 'valorpto', prom_cost)
	AddProperty(_Screen, 'idpromo', prom_idprom)
	CierraCursor(Ccursor)
	Return 1
	Endfunc
	Function registrarpuntos()
	lC		  = 'proregistraptos'
	ffecha = Cfechas(This.dFecha)
	TEXT To lp Noshow Textmerge
	(<<this.nidauto>>,<<this.nidclie>>,<<this.npunto>>,<<this.ndscto>>,'<<ffecha>>',<<this.nidprom>>)
	ENDTEXT
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function descontarpuntos()

	Endfunc
	Function listarpuntos(nidclie, nidpro)
	Ccursor = 'c_' + Sys(2015)
	TEXT To lC Noshow Textmerge
	      select  SUM(dpro_acum-dpro_desc) as ptos FROM fe_dpromo WHERE dpro_idcli=<<nidlcie>> and dpro_acti='A' AND dpro_idpro=<<nidpro>> and datediff(now(),dpro_fech)<=90
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return - 1
	Endif
	Select (Ccursor)
	Return ptos
	Endfunc
	Function calcular(nmonto)
	Return Int(nmonto / _Screen.valorpto)
	Endfunc
	Function calculartotal(nidclie)
	Ccursor = 'c_' + Sys(2015)
	TEXT To lC Noshow Textmerge
	SELECT SUM(dpro_acum-dpro_desc) AS saldo FROM fe_dpromo WHERE dpro_acti='A' AND dpro_idcli=<<nidclie>> and datediff(now(),dpro_fech)<=90
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return - 1
	Endif
	Select (Ccursor)
	nsaldo = Iif(Isnull(saldo), 0, saldo)
	Return nsaldo
	Endfunc
	Function Registrar()
	If This.VAlidar() < 1 Then
		Return 0
	Endif
	goApp.npara1 = This.feci
	goApp.npara2 = This.fecf
	goApp.npara3 = This.Ctipo
	goApp.npara4 = This.Cdetalle
	goApp.npara5 = goApp.nidusua
	TEXT To lC Noshow
      INSERT INTO fe_rcamp(rcam_feci,rcam_fecf,rcam_tipo,rcam_deta,rcam_idus)values(?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	This.cmensaje='ok'
	Return 1
	Endfunc
	Function Actualizar()
	If This.VAlidar() < 1 Then
		Return 0
	Endif
	If This.nidprom < 1 Then
		This.cmensaje = 'Seleccione el dato para Actualizar'
		Return 0
	Endif
	goApp.npara1 = This.feci
	goApp.npara2 = This.fecf
	goApp.npara3 = This.Ctipo
	goApp.npara4 = This.Cdetalle
	goApp.npara5 = goApp.nidusua
	nid = This.nidprom
	TEXT To lC Noshow
     update fe_rcamp SET rcam_feci=?goapp.npara1,rcam_fecf=?goapp.npara2,rcam_tipo=?goapp.npara3,rcam_deta=?goapp.npara4,rcam_idu1=?goapp.npara5 WHERE rcam_idre=?nid
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	This.cmensaje='ok'
	Return 1
	Endfunc
	Function VAlidar()
	Do Case
	Case !esfechaValida(This.feci)
		This.cmensaje = "Fecha de Inicio No Válida"
		Return 0
	Case !esfechaValidaadelantada(This.fecf)
		This.cmensaje = "Fecha Final  No Válida"
		Return 0
	Case Len(Alltrim(This.Cdetalle))=0
		This.cmensaje = "Ingrese el Detalle"
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function Listarcampañas(Ccursor)
	nmes=goApp.mes
	TEXT To lC Noshow Textmerge
	     SELECT rcam_idus,rcam_idre,rcam_feci,rcam_fecf,rcam_tipo,rcam_deta,nomb FROM fe_rcamp
	     INNER JOIN fe_usua ON fe_usua.idusua=fe_rcamp.rcam_idus
	     WHERE rcam_acti='A'  AND month(rcam_feci)=?nmes order by rcam_feci
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Listardetalle(Ccursor)
	TEXT To lC Noshow Textmerge
	     SELECT idart,descri,unid,camp_cant AS cant,camp_idca FROM fe_rcamp
	     INNER JOIN fe_dcamp ON fe_dcamp.camp_idre=fe_rcamp.rcam_idre
	     INNER JOIN fe_art ON fe_art.`idart`=fe_dcamp.`camp_idar`
	     WHERE rcam_acti='A'  AND camp_idre=<<this.nidprom>> and camp_acti='A' ORDER BY descri
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function desactivardetalle(nid)
	TEXT TO lc NOSHOW TEXTMERGE
	    UPDATE fe_dcamp SET camp_acti='I' WHERE camp_idca=<<nid>>
	ENDTEXT
	If This.Ejecutarsql(lC)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Registrardetalle(obj)
	TEXT TO lc NOSHOW TEXTMERGE
	INSERT INTO fe_dcamp(camp_idar,camp_cant,camp_idre)values(<<obj.nidart>>,<<obj.ncant>>,<<obj.nidr>>)
	ENDTEXT
	If This.Ejecutarsql(lC)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Actualizardetalle(obj)
	TEXT TO lc NOSHOW TEXTMERGE
	UPDATE fe_dcamp set camp_idar=<<obj.nidart>>,camp_cant=<<obj.ncant>>,camp_idre=<<obj.nidr>> where camp_idca=<<obj.nid>>
	ENDTEXT
	If This.Ejecutarsql(lC)<1 Then
		Return 0
	Endif
	Return 1
	ENDFUNC
	FUNCTION listarresumencampaña(nidm,ccursor)
	f1=cfechas(this.feci)
	f2=cfechas(this.fecf)
	SET TEXTMERGE on
	SET TEXTMERGE TO memvar lc NOSHOW TEXTMERGE 
    \ SELECT rcam_tipo,rcam_deta,nomb,camp_cant,camp_idar,rcam_idre FROM fe_rcamp
    \ INNER JOIN fe_usua ON fe_usua.idusua=fe_rcamp.rcam_idus
    \ INNER JOIN fe_dcamp ON fe_dcamp.`camp_idre`=fe_rcamp.`rcam_idre`
    \ WHERE rcam_acti='A'  AND rcam_feci>='<<f1>>' AND rcam_fecf<='<<f2>>' AND camp_acti='A' ORDER BY rcam_deta
	SET TEXTMERGE to
	SET TEXTMERGE off
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	ENDFUNC 
Enddefine



