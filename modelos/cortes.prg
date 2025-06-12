Define Class Cortes As  OData Of 'd:\capass\database\data.prg'
	Idauto = 0
	dfi = Datetime()
	dff = Datetime()
	idart = 0
	ncant = 0
	Prec = 0
	cortador = 0
	tipro = ""
	Hsalida = Datetime()
	Procedure RegistraServicioCorte
	lC = 'ProRegistraServicioCorte'
	cur = ""
	goApp.npara1 = This.Idauto
	goApp.npara2 = This.idart
	goApp.npara3 = This.ncant
	goApp.npara4 = This.Prec
	goApp.npara5 = This.cortador
	goApp.npara6 = This.tipro
	Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
	Endtext
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return  1
	Endproc
	Procedure RegistraHsalidaServicioCorte
	lC = 'ProRegistraHsalidaServicioCorte'
	cur = ""
	goApp.npara1 = This.Idauto
	goApp.npara2 = This.Hsalida
	goApp.npara3 = This.cortador
	Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	Endtext
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return  1
	Endproc
	Procedure SalidaServicioCorte
	lC = 'ProSalidaServicioCorte'
	cur = ""
	goApp.npara1 = This.Idauto
	Text To lp Noshow
	     (?goapp.npara1)
	Endtext
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return  1
	Endproc
	Procedure MostrarServiciosCorte
	Lparameters cur, opt, dfi, dff, nidt
	If Vartype(dfi) <> "L"
		f1 = Cfechas(dfi)
		f2 = Cfechas(dff)
	Endif
	nidt = goApp.Tienda
	Do Case
	Case opt = 'I'
		Text To lC Noshow Textmerge
	      select ndoc,razo,r.impo as Importe,ifnull(e.empl_nomb,'') as cortador,serv_feci,
	      f.estado,serv_fecf,serv_idser,serv_idau FROM
	      (select serv_idau,serv_feci,CAST(ifnull(serv_hsal,'por definir') as char(30)) as serv_hsal,'Ingresado' as estado,serv_fecf,serv_idser,serv_idar,serv_idco
	      from  fe_serviciocorte as a where serv_fecf is null and serv_acti='A' group by serv_idau ) as  f
	      inner join fe_rcom r on r.idauto=f.serv_idau 
	      inner join fe_clie c on c.idclie=r.idcliente 
	      inner join fe_art a on a.idart=f.serv_idar
	      left join fe_empl as e on e.empl_idem=f.serv_idco
	      where codt=<<nidt>> order by fech desc,ndoc desc;
		Endtext
	Case opt = 'E'
		Text To lC Noshow Textmerge
	      select ndoc,razo,r.impo as Importe,ifnull(e.empl_nomb,'') as cortador,serv_feci,
	      CAST(ifnull(serv_hsal,'por definir') as char(30)) as serv_hsal,'Ingresado' as estado,serv_fecf,serv_idser,serv_idau,serv_idco FROM
	      (select serv_idau,serv_feci,CAST(ifnull(serv_hsal,'por definir') as char(30)) as serv_hsal,'Ingresado' as estado,serv_fecf,serv_idser,serv_idar,serv_idco
	      from  fe_serviciocorte as a where serv_hsal is not null  and serv_acti='A' and serv_fecf is null group by serv_idau ) f
	      inner join fe_rcom r on r.idauto=f.serv_idau 
	      inner join fe_clie c on c.idclie=r.idcliente 
	      inner join fe_art a on a.idart=f.serv_idar
	      left join fe_empl as e on e.empl_idem=f.serv_idco
	      where codt=<<nidt>> group by serv_idau order by fech desc,ndoc desc;
		Endtext
	Case opt = 'S'
		Text To lC Noshow Textmerge
		  select ndoc as Documento,razo as Cliente,r.impo as Importe,ifnull(e.empl_nomb,'') as cortador,serv_feci as Ingreso,
		  serv_hsal as Hora_Salida,'Engregado' as estado,
		  serv_fecf as Fecha_Salida,serv_idser,serv_idau,serv_idco FROM
		  (select serv_idau,serv_feci,CAST(ifnull(serv_hsal,'por definir') as char(30)) as serv_hsal,'Ingresado' as estado,serv_fecf,serv_idser,serv_idar,serv_idco
	      from  fe_serviciocorte as a where CAST(serv_fecf as date) between '<<f1>>' and '<<f2>>' and serv_acti='A' group by serv_idau ) f
	      inner join fe_rcom r on r.idauto=f.serv_idau 
	      inner join fe_clie c on c.idclie=r.idcliente join fe_art a on a.idart=f.serv_idar
	      left join fe_empl as e on e.empl_idem=f.serv_idco
	      where codt=?nidt group by serv_idau order by fech desc,ndoc desc;
		Endtext
	Case opt = 'T'
		Text To lC Noshow Textmerge
	      select ndoc,razo,descri,serv_cant as cantidad,serv_prec as precio,ifnull(e.empl_nomb,'')  as cortador,
	      serv_feci,serv_fecf,serv_idser,serv_idau,serv_idco FROM
	      (select serv_cant,serv_prec,serv_feci,serv_fecf,serv_idser,serv_idau,serv_idco,serv_idar from fe_serviciocorte as a
	      where cast(serv_feci as date)  between '<<f1>>' and '<<f2>>' and serv_acti='A' ) as f
	      inner join fe_rcom r on r.idauto=f.serv_idau 
	      inner join fe_clie c on c.idclie=r.idcliente 
	      inner join fe_art a on a.idart=f.serv_idar
	      left join fe_empl as e on e.empl_idem=f.serv_idco
	      where  r.codt=<<nidt>>;
		Endtext
	Case opt = 'X'
		Text To lC Noshow Textmerge
		 select ndoc as Documento,razo as Cliente,ROUND(serv_cant*serv_prec,2) as Importe,ifnull(e.empl_nomb,'') as cortador,serv_feci as Ingreso,
		 serv_hsal as Hora_Salida,'Engregado' as estado,
		 serv_fecf as Fecha_Salida,a.descri as Producto,d.dcat as linea,serv_cant as cantidad,serv_idser,serv_idau,serv_idco,a.idcat,serv_idar,serv_tipro as tipro,serv_idco
		 FROM fe_serviciocorte f
	     inner join fe_rcom r on r.idauto=f.serv_idau 
	     inner join fe_clie c on c.idclie=r.idcliente 
	     inner join fe_art a on a.idart=f.serv_idar
         join fe_cat as d on d.idcat=a.idcat
	     left join fe_empl as e on e.empl_idem=f.serv_idco
	     where CAST(serv_fecf as date) between '<<f1>>' and '<<f2>>' and serv_acti='A'  and codt=<<nidt>> order by fech desc,ndoc desc;
		Endtext
	Endcase
	If This.EJECutaconsulta(lC, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endproc
	Procedure BuscaSiEstaRegistrado
	Lparameters nid
	Text To lC Noshow Textmerge
	      select serv_idau  FROM fe_serviciocorte f
	      where serv_acti='A' and serv_idau=<<nid>> group by serv_idau
	Endtext
	If This.EJECutaconsulta(lC, 'ya') < 1 Then
		Return 0
	Endif
	If Ya.Serv_idau > 0 Then
		Return 0
	Else
		Return 1
	Endif
	Endproc
	Procedure MostrarReporteServiciosCorte
	Lparameters cur, dfi, dff, nidtda
	f1 = Cfechas(dfi)
	f2 = Cfechas(dff)
	Text To lC Noshow Textmerge
	      select descri as Servicio,e.empl_nomb  as Cortador,SUM(cantidad) AS cantidad,SUM(importe) AS Importe,serv_idco
	      FROM (select SUM(serv_cant) as cantidad,SUM(ROUND(serv_cant*serv_prec,2)) as Importe,serv_idco,serv_idar from  fe_serviciocorte
	      where cast(serv_fecf as date)  between '<<f1>>' and '<<f2>>'  and serv_acti='A' and serv_tipro='S'
	      group by serv_idco,serv_idar) f
	      inner join fe_art a on a.idart=f.serv_idar 
	      left join fe_empl as e on e.empl_idem=f.serv_idco
	      order by e.empl_nomb,descri;
	Endtext
	If This.EJECutaconsulta(lC, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endproc
	Function RegistraIngreso()
	Select lsele
	Sw = 1
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	Scan All
		this.cortador = lec.empl_idem
		If this.RegistraHsalidaServicioCorte() < 1 Then
			Sw = 0
			Exit
		Endif
	Endscan
	If Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine