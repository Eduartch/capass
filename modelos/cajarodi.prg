Define Class cajarodi As cajae Of 'd:\capass\modelos\cajae'
	cdetalle1 = ""
	cdetalle2 = ""
	Function saldoanterior1()
	lC = 'FunSaldoCaja'
	Calias = 'c_' + Sys(2015)
	dFecha = Cfechas(This.dFecha)
	Text To lp Noshow Textmerge
     ('<<dfecha>>',<<this.codt>>)
	Endtext
	If This.EJECUTARf(lC, lp, Calias) < 1 Then
		If This.conerror = 1 Then
			Return - 1
		Endif
	Endif
	Select (Calias)
	nsaldo = Iif(Isnull(Id), 0, Id)
	Return nsaldo
	Endfunc
	Function reportecaja1(Ccursor)
	Set DataSession To This.Idsesion
	dFecha = Cfechas(This.dFecha)
	nidalma = This.codt
	Text To lC Noshow Textmerge
	     select ifnull(k.prec,0) as prec,ifnull(k.idart,'') as coda,day(a.fech) as dia,ifnull(k.cant,0) as cant,
		 CASE a.forma
         WHEN 'E' THEN 'Efecivo'
         WHEN 'C' THEN 'Crédito'
         WHEN 'T' THEN 'Tarjeta'
         ELSE 'Deposito'
         END AS forma,a.deta,
		ifnull(if(tdoc='01',if(left(b.ndoc,1)='F',b.ndoc,concat('F/.',b.ndoc)),
        if(left(b.ndoc,1)='B',b.ndoc,concat('B/.',b.ndoc))),a.ndoc) as ndoc,
        ifnull(b.tdoc,'99') as tdoc,
		ifnull(ROUND(k.cant*k.prec,2),0) as Np,
		CAST(if(forma='C',ifnull(ROUND(k.cant*k.prec,2),a.impo),0)  as decimal(12,2)) as credito,origen,tipo,
		case origen when "CK" then 'a'
		when "Ca" then 'c' when "CC" then 'b'
		when "CB" then 'd' else 'z' end as orden,
		if(a.origen='CC',a.impo,0) as pagos,
        if(a.origen<>'CC',if(tipo='I',if(a.forma='E',if(left(a.deta,8)="Cambiada",0,ifnull(if(a.impo=0,0,ROUND(k.cant*k.prec,2)),a.impo)),0),0),0) as ingresos,
        CAST(0 as decimal(12,2)) as usada,
		CAST(IF(a.forma='D',IFNULL(ROUND(k.cant*k.prec,2),0),IF(a.origen='CB',a.impo,0)) AS DECIMAL(12,2)) AS bancos,
		if(a.forma='T',if(caja_tarj=0,ROUND(k.cant*k.prec,2),0),0) as tarjeta1,
		if(a.tipo='S',if(a.origen='Ca',a.impo,0),0) as gastos,idcon
		from fe_caja as a
		left join fe_rcom as b on b.idauto=a.idauto
		left join (select idart,alma,cant,prec,idauto from fe_kar as q where acti='A' AND q.alma=<<nidalma>> AND tipo='V') as k on k.idauto=b.idauto
		where a.fech='<<dfecha>>' and a.acti='A' and a.codt=<<nidalma>> and a.caja_form='E'
		union all
		select k.prec,k.idart as coda,day(a.fech) as dia,k.cant,
		 CASE a.forma
         WHEN 'E' THEN 'Efecivo'
         WHEN 'C' THEN 'Crédito'
         WHEN 'T' THEN 'Tarjeta'
         ELSE 'Deposito'
         END AS forma,a.deta,
	    ifnull(if(tdoc='01',if(left(b.ndoc,1)='F',b.ndoc,concat('F/.',b.ndoc)),
        if(left(b.ndoc,1)='B',b.ndoc,concat('B/.',b.ndoc))),a.ndoc) as ndoc,
        ifnull(b.tdoc,'99') as tdoc,
		ROUND(k.cant*-k.prec,2) as Np,
        if(forma='C',ROUND(k.cant*-k.prec,2),0) as credito,origen,tipo,'a' as orden,0 as pagos,0 as ingresos,
        if(a.forma='E',ROUND(k.cant*k.prec,2),0) as usada,0 as bancos,
        if(a.forma='T',if(caja_tarj=0,ROUND(k.cant*-k.prec,2),0),0) as tarjeta1,0 as gastos,idcon
		from fe_caja as a
		inner join fe_rcom as b on b.idauto=a.idauto
        inner join (select q.idart,alma,cant,q.prec,idauto from fe_kar as q join fe_art a on a.idart=q.idart
        where acti='A' AND q.alma=<<nidalma>> AND tipo='C' and a.tipro='C') as k on k.idauto=b.idauto
		where a.fech='<<dfecha>>'  and a.acti='A' and a.codt=<<nidalma>>
		union all
        select 0 as prec,' ' as coda,day(a.fech) as dia,0 as cant,
		'Tarjeta' as forma,a.deta,
	    ifnull(if(tdoc='01',if(left(b.ndoc,1)='F',b.ndoc,concat('F/.',b.ndoc)),
        if(left(b.ndoc,1)='B',b.ndoc,concat('B/.',b.ndoc))),a.ndoc) as ndoc,
        ifnull(b.tdoc,'99') as tdoc,
		0 as Np,0 as credito,origen,tipo,
		case origen when "CK" then 'a'
		when "Ca" then 'c' when "CC" then 'b'
		when "CB" then 'd' else 'z' end as orden,
	    0 as pagos,a.impo as ingresos,CAST(0 as decimal(12,2)) as usada,0 as bancos,caja_tarj as tarjeta1,0 as gastos,idcon
		from fe_caja as a
		inner join fe_rcom as b on b.idauto=a.idauto
		where a.fech='<<dfecha>>'  and a.acti='A' and a.codt=<<nidalma>>  and caja_tarj>0
		union all
		select 0 as prec,' ' as coda,day(a.fech) as dia,0 as cant,
		'Efectivo' as forma,a.deta,
	    ifnull(if(tdoc='01',if(left(b.ndoc,1)='F',b.ndoc,concat('F/.',b.ndoc)),
        if(left(b.ndoc,1)='B',b.ndoc,concat('B/.',b.ndoc))),a.ndoc) as ndoc,
        ifnull(b.tdoc,'99') as tdoc,
		0 as Np,0 as credito,origen,tipo,
		case origen when "CK" then 'a'
		when "Ca" then 'c' when "CC" then 'b'
		when "CB" then 'd' else 'z' end as orden,
	    0 as pagos,a.impo as ingresos,CAST(0 as decimal(12,2)) as usada,0 as bancos,0 as tarjeta1,0 as gastos,idcon
		from fe_caja as a
		inner join fe_rcom as b on b.idauto=a.idauto
		where a.fech='<<dfecha>>'  and a.acti='A' and a.codt=<<nidalma>> and left(a.deta,8)="Cambiada"
	    order by tdoc,ndoc
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaDatosLCajaEFectivorodi(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20)
	lC = "ProIngresaDatosLcajaEefectivo"
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara9 = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	goApp.npara12 = np12
	goApp.npara13 = np13
	goApp.npara14 = np14
	goApp.npara15 = np15
	goApp.npara16 = np16
	goApp.npara17 = np17
	goApp.npara18 = np18
	goApp.npara19 = np19
	goApp.npara20 = np20
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,
     ?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20)
	Endtext
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaDatosLCajaEFectivorodi1(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21)
	lC = "ProIngresaDatosLcajaEefectivo1"
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara9 = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	goApp.npara12 = np12
	goApp.npara13 = np13
	goApp.npara14 = np14
	goApp.npara15 = np15
	goApp.npara16 = np16
	goApp.npara17 = np17
	goApp.npara18 = np18
	goApp.npara19 = np19
	goApp.npara20 = np20
	goApp.npara21 = np21
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,
     ?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21)
	Endtext
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function saldoanterior2()
	lC = 'FunSaldoCaja'
	Calias = 'c_' + Sys(2015)
	dFecha = Cfechas(This.dFecha)
	Text To lp Noshow Textmerge
     ('<<dfecha>>',<<this.codt>>)
	Endtext
	If This.EJECUTARf(lC, lp, Calias) < 1 Then
		If This.conerror = 1 Then
			Return - 1
		Endif
	Endif
	Select (Calias)
	nsaldo = Iif(Isnull(Id), 0, Id)
	Return nsaldo
	Endfunc
	Function reportecaja2(Ccursor)
	Set DataSession To This.Idsesion
	dFecha = Cfechas(This.dFecha)
	nidalma = This.codt
*if(a.lcaj_orig<>'CC',if(lcaj_deud>0,if(a.lcaj_form='E',if(left(a.lcaj_deta,8)="Cambiada",0,ifnull(if(a.lcaj_deud=0,0,ROUND(k.cant*k.prec,2)),a.lcaj_deud)),0),0),0) as ingresos,
*    IF(a.lcaj_orig<>'CC',IF(lcaj_deud>0,IF(a.lcaj_form='E',IF(LEFT(a.lcaj_deta,8)="Cambiada",0,IFNULL(IF(a.lcaj_deud=0,0,ROUND(k.cant*k.prec,2)),a.lcaj_deud)),0),IF(lcaj_deud<0,IF(lcaj_form='E',ROUND(k.cant*k.prec,2),0),0)),0) AS ingresos,
	Text To lC Noshow Textmerge
	     select ifnull(k.prec,0) as prec,ifnull(k.idart,'') as coda,day(a.lcaj_fech) as dia,ifnull(k.cant,0) as cant,
		 CASE a.lcaj_form
         WHEN 'E' THEN 'Efecivo'
         WHEN 'C' THEN 'Crédito'
         WHEN 'T' THEN 'Tarjeta'
         ELSE 'Deposito'
         END AS forma,a.lcaj_deta as deta,
		IFNULL(lcaj_dcto,b.ndoc) AS ndoc,
        ifnull(b.tdoc,'99') as tdoc,
		ifnull(ROUND(k.cant*k.prec,2),0) as Np,
		CAST(if(lcaj_form='C',ifnull(ROUND(k.cant*k.prec,2),a.lcaj_deud),0)  as decimal(12,2)) as credito,
		lcaj_orig AS origen,if(lcaj_deud>0,'I','E') as tipo,
		case lcaj_orig
		when "CK" then 'a'
		when "Ca" then 'c'
		when "CC" then 'b'
		when "CB" then 'd' else 'z' end as orden,
		if(a.lcaj_orig='CC',a.lcaj_deud,0) as pagos,
		IF(a.lcaj_orig<>'CC',IF(lcaj_deud>0,IF(a.lcaj_form='E',IF(LEFT(a.lcaj_deta,8)="Cambiada",0,IFNULL(IF(a.lcaj_deud=0,0,IF(k.prec=0,lcaj_deud,ROUND(k.cant*k.prec,2))),a.lcaj_deud)),0),IF(lcaj_deud<0,IF(lcaj_form='E',ROUND(k.cant*k.prec,2),0),0)),0) AS ingresos,
	    CAST(0 as decimal(12,2)) as usada,
		CAST(IF(a.lcaj_form='D',IFNULL(ROUND(k.cant*k.prec,2),0),IF(a.lcaj_orig='CB',a.lcaj_acre,0)) AS DECIMAL(12,2)) AS bancos,
		if(a.lcaj_form='T',if(lcaj_tarj=0,ROUND(k.cant*k.prec,2),0),0) as tarjeta1,
		if(a.lcaj_acre>0,if(a.lcaj_orig='Ca',if(lcaj_form='C',0,a.lcaj_acre),if(lcaj_orig='CB',0,lcaj_acre)),0) as gastos
		from fe_lcaja as a
		left join fe_rcom as b on b.idauto=a.lcaj_idau
		left join (select idart,alma,cant,prec,idauto from fe_kar as q where acti='A' AND q.alma=<<nidalma>> AND tipo='V') as k on k.idauto=b.idauto
		where a.lcaj_fech='<<dfecha>>' and a.lcaj_acti='A' and a.lcaj_codt=<<nidalma>> and a.caja_form='E' 
		union all
		select k.prec,k.idart as coda,day(a.lcaj_fech) as dia,k.cant,
		CASE a.lcaj_form
        WHEN 'E' THEN 'Efecivo'
        WHEN 'C' THEN 'Crédito'
        WHEN 'T' THEN 'Tarjeta'
        ELSE 'Deposito'
        END AS forma,a.lcaj_deta As deta,
	    ifnull(a.lcaj_dcto,ndoc) as ndoc,
        ifnull(b.tdoc,'99') as tdoc,
		ROUND(k.cant*-k.prec,2) as Np,
        if(lcaj_form='C',ROUND(k.cant*-k.prec,2),0) as credito,lcaj_orig As origen,if(lcaj_deud>0,'I','S') as tipo,'a' as orden,0 as pagos,0 as ingresos,
        if(a.lcaj_form='E',ROUND(k.cant*k.prec,2),0) as usada,0 as bancos,
        if(a.lcaj_form='T',if(lcaj_tarj=0,ROUND(k.cant*-k.prec,2),0),0) as tarjeta1,0 as gastos
		from fe_lcaja as a
		inner join fe_rcom as b on b.idauto=a.lcaj_idau
        inner join (select q.idart,alma,cant,q.prec,idauto from fe_kar as q join fe_art a on a.idart=q.idart
        where acti='A' AND q.alma=<<nidalma>> AND tipo='C' and a.tipro='C' ) as k on k.idauto=b.idauto
		where a.lcaj_fech='<<dfecha>>'  and a.lcaj_acti='A' and a.lcaj_codt=<<nidalma>> and b.idcliente>0
		union all
        select 0 as prec,' ' as coda,day(a.lcaj_fech) as dia,0 as cant,
		'Tarjeta' as forma,a.lcaj_deta As deta,
	    ifnull(if(tdoc='01',if(left(b.ndoc,1)='F',b.ndoc,concat('F/.',b.ndoc)),
        if(left(b.ndoc,1)='B',b.ndoc,concat('B/.',b.ndoc))),a.lcaj_dcto) as ndoc,
        ifnull(b.tdoc,'99') as tdoc,
		0 as Np,0 as credito,lcaj_orig AS origen,if(lcaj_deud>0,'I','S') as tipo,
		case lcaj_orig
		when "CK" then 'a'
		when "Ca" then 'c'
		when "CC" then 'b'
		when "CB" then 'd' else 'z' end as orden,
	    0 as pagos,lcaj_deud as ingresos,CAST(0 as decimal(12,2)) as usada,0 as bancos,lcaj_tarj as tarjeta1,0 as gastos
		from fe_lcaja as a
		inner join fe_rcom as b on b.idauto=a.lcaj_idau
		where a.lcaj_fech='<<dfecha>>'  and a.lcaj_acti='A' and a.lcaj_codt=<<nidalma>>  and lcaj_tarj>0
		union all
		select 0 as prec,' ' as coda,day(a.lcaj_fech) as dia,0 as cant,
		'Efectivo' as forma,a.lcaj_deta As deta,
	    ifnull(if(tdoc='01',if(left(b.ndoc,1)='F',b.ndoc,concat('F/.',b.ndoc)),
        if(left(b.ndoc,1)='B',b.ndoc,concat('B/.',b.ndoc))),a.lcaj_dcto) as ndoc,
        ifnull(b.tdoc,'99') as tdoc,
		0 as Np,0 as credito,lcaj_orig as origen,if(lcaj_deud>0,'I','S') as tipo,
		case lcaj_orig
		when "CK" then 'a'
		when "Ca" then 'c'
		when "CC" then 'b'
		when "CB" then 'd' else 'z' end as orden,
	    0 as pagos,a.lcaj_deud as ingresos,CAST(0 as decimal(12,2)) as usada,0 as bancos,0 as tarjeta1,0 as gastos
		from fe_lcaja as a
		inner join fe_rcom as b on b.idauto=a.lcaj_idau
		where a.lcaj_fech='<<dfecha>>'  and a.lcaj_acti='A' and a.lcaj_codt=<<nidalma>> and left(a.lcaj_deta,8)="Cambiada"
	    order by tdoc,ndoc
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registraTransferenciabancosRetiro(dFecha, cndoc, cdetalle, nidcta, nimpo, Cmoneda, ndolar, nidb, corigen, nidtda, cfp)
	Set DataSession To This.Idsesion
	If BuscarSeries(1, 'LC') = 0 Then
		This.Cmensaje = "NO Hay Correlativo"
		Return 0
	Endif
	ccorrelativo = '001' + Right('0000000' + Alltrim(Str(series.nume)), 7)
	This.Ndoc = ccorrelativo
	This.Nsgte = series.nume
	This.Idserie = series.Idserie
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	vd = This.TraspasoDatosLCajaErodi(dFecha, ccorrelativo, _Screen.ocajae.cdetalle1, nidcta, 0, nimpo, Cmoneda, ndolar, goApp.nidusua, 0, corigen, nidtda, cfp)
	If vd < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If _Screen.obancos.IngresaDatosLCajaT(nidb, dFecha, cndoc, 1, _Screen.ocajae.cdetalle2, 0, 0, ccorrelativo, fe_gene.gene_idca, nimpo, 0, 1, vd) < 1 Then
		This.DEshacerCambios()
		This.Cmensaje = _Screen.obancos.Cmensaje
		Return 0
	Endif
	If This.GeneraCorrelativo() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarparaquitar(todos, fe, f1, f2, Ccursor)
	dfi = Cfechas(f1)
	dff = Cfechas(f2)
	dFecha = Cfechas(fe)
	Set DataSession To This.Idsesion
	If Left(goApp.tipousuario, 1) = "G"  Or Left(goApp.tipousuario, 1) = "A"
		If goApp.Xopcion = 0 Then
			If todos = 1 Then
				Text To lC Noshow Textmerge
                 SELECT idcaja,fech,impo,deta,tmon,origen,idauto FROM fe_caja WHERE origen in ("Ca","CC","CB")  AND acti<>'I' and fech between '<<dfi>>' and '<<dff>>' ORDER BY fech
				Endtext
			Else
				Text To lC Noshow Textmerge
             SELECT idcaja,fech,impo,deta,tmon,origen,idauto FROM fe_caja WHERE origen in ("Ca","CC","CB")  AND acti<>'I'  and fech='<<dfecha>>' ORDER BY fech
				Endtext
			Endif
		Else
			If todos = 1 Then
				Text To lC Noshow Textmerge
                 SELECT lcaj_idca as idcaja,lcaj_fech as fech,if(lcaj_deud>0,lcaj_deud,lcaj_acre) as impo,lcaj_deta as deta,lcaj_mone as tmon,lcaj_orig as origen,lcaj_idau as idauto
                 FROM fe_lcaja WHERE lcaj_orig in ("Ca","CC","CB")  AND lcaj_acti<>'I' and lcaj_fech between '<<dfi>>' and '<<dff>>' ORDER BY lcaj_fech
				Endtext
			Else
				Text To lC Noshow Textmerge
				 SELECT lcaj_idca as idcaja,lcaj_fech as fech,if(lcaj_deud>0,lcaj_deud,lcaj_acre) as impo,lcaj_deta as deta,lcaj_mone as tmon,lcaj_orig as origen,lcaj_idau as idauto
                 FROM fe_lcaja WHERE lcaj_orig in ("Ca","CC","CB")  AND lcaj_acti<>'I' and lcaj_fech='<<dfecha>>' ORDER BY lcaj_fech
				Endtext
			Endif
		Endif
	Else
		If goApp.Xopcion = 0 Then
			If todos = 1 Then
				Text  To  lC Noshow Textmerge
                 SELECT idcaja,fech,impo,deta,tmon,origen,idauto FROM fe_caja WHERE origen in ("Ca","CC","CB") and acti<>'I' AND fech between '<<dfi>>' and '<<dff>>'  ORDER BY fech
				Endtext
			Else
				Text  To  lC Noshow Textmerge
                SELECT idcaja,fech,impo,deta,tmon,origen,idauto FROM fe_caja WHERE origen in ("Ca","CC","CB") and acti<>'I' AND fech='<<dfecha>>' ORDER BY fech
				Endtext
			Endif
		Else
			If todos = 1 Then
				Text To lC Noshow Textmerge
                 SELECT lcaj_idca as idcaja,lcaj_fech as fech,if(lcaj_deud>0,lcaj_deud,lcaj_acre) as impo,lcaj_deta as deta,lcaj_mone as tmon,lcaj_orig as origen,lcaj_idau as idauto
                 FROM fe_lcaja WHERE lcaj_orig in ("Ca","CC","CB")  AND lcaj_acti<>'I' and lcaj_fech between '<<dfi>>' and '<<dff>>' ORDER BY lcaj_fech
				Endtext
			Else
				Text To lC Noshow Textmerge
				 SELECT lcaj_idca as idcaja,lcaj_fech as fech,if(lcaj_deud>0,lcaj_deud,lcaj_acre) as impo,lcaj_deta as deta,lcaj_mone as tmon,lcaj_orig as origen,lcaj_idau as idauto
                 FROM fe_lcaja WHERE lcaj_orig in ("Ca","CC","CB")  AND lcaj_acti<>'I' and lcaj_fech='<<dfecha>>' ORDER BY lcaj_fech
				Endtext
			Endif
		Endif
	Endif
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1.
	Endfunc
	Function registrapagos1(dFecha, cndoc, cdetalle, nidcta, nimporte, cmone, ndolar, Ncontrol, Ctipo)
	q = 1
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If Ctipo = 'I'  Then
		xc = IngresaDatosLcajaE(dFecha, cndoc, cdetalle, nidcta, nimporte, 0, cmone, ndolar, goApp.nidusua, Ncontrol)
		If xc = 0 Then
			q = 0
		Else
			If  Ncontrol > 0 Then
				Select atmp
				Scan All
					cxr = CancelaCreditosCCajaE(cndoc, atmp.saldo, 'P', atmp.Moneda, cdetalle, dFecha, atmp.fevto, atmp.Tipo, atmp.Ncontrol, atmp.nrou, atmp.Idrc, Id(), goApp.nidusua, xc)
					If cxr = 0 Then
						q = 0
						Exit
					Endif
					Select atmp
				Endscan
			Endif
		Endif
	Else
		xc = IngresaDatosLcajaE(dFecha, cndoc, cdetalle, nidcta,	0, nimporte, cmone, ndolar, goApp.nidusua, Ncontrol)
		If xc = 0 Then
			q = 0
		Else
			If Ncontrol > 0 Then
				Select atmp
				Scan All
					cxd = CancelaDeudasCCajae(dFecha, atmp.fevto, atmp.saldo, cndoc, 'P',	atmp.Moneda, cdetalle, atmp.Tipo, atmp.idrd, goApp.nidusua, atmp.Ncontrol, '', Id(), ndolar, xc)
					If cxd = 0 Then
						q = 0
						Exit
					Endif
					Select atmp
				Endscan
			Endif
		Endif
	Endif
	If q = 0  Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GeneraCorrelativo() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function ActualizaLcaja1(dFecha, cndoc, cdetalle, nidcta, nimporte, cmone, ndolar, Ncontrol, n4, Ctipo)
	If ctio = 'I' Then
		If ActualizaDatosLcajaE(dFecha, .cndoc, cdetalle, nidcta, nimporte, 0, n4, 1, cmone, ndolar) < 1
			Return 0
		Endif
	Else
		If ActualizaDatosLcajaE(dFecha, .cndoc, cdetalle, nidcta, nimporte, 0, n4, 1, cmone, ndolar) < 1
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function GeneraCorrelativo()
	Set Procedure To d:\capass\modelos\correlativos Additive
	ocorr = Createobject("correlativo")
	ocorr.Ndoc = This.Ndoc
	ocorr.Nsgte = This.Nsgte
	ocorr.Idserie = This.Idserie
	If ocorr.GeneraCorrelativo() < 1  Then
		This.Cmensaje = ocorr.Cmensaje
		Return 0
	Endif
	Return 1
	Endfunc
	Function Registrapagosporcajarodi(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12)
	lC = "FunIngresaDatosLcajaE"
	cur = 'c_' + Sys(2015)
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara9 = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	goApp.npara12 = np12
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12)
	Endtext
	nidcaja = This.EJECUTARf(lC, lp, cur)
	If nidcaja < 1 Then
		Return 0
	Endif
	Return nidcaja
	Endfunc
	Function registrapagos2(dFecha, cndoc, cdetalle, nidcta, nimporte, cmone, ndolar, nctrl, Ctipo, nidtda)
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If Ctipo = 'I'  Then
		xc = This.Registrapagosporcajarodi(dFecha, cndoc, cdetalle, nidcta, nimporte, 0, cmone, ndolar, goApp.nidusua, nctrl, 'E', nidtda)
		If xc = 0 Then
			q = 0
		Else
			If  nctrl > 0 Then
				Select atmp
				Scan All
					cxr = CancelaCreditosCCajaE(cndoc, atmp.saldo, 'P', atmp.Moneda, cdetalle, dFecha, atmp.fevto, atmp.Tipo, atmp.Ncontrol, atmp.nrou, atmp.Idrc, Id(), goApp.nidusua, xc)
					If cxr = 0 Then
						q = 0
						Exit
					Endif
					Select atmp
				Endscan
			Endif
		Endif
	Else
		xc = This.Registrapagosporcajarodi(dFecha, cndoc, cdetalle, nidcta, 0, nimporte, cmone, ndolar, goApp.nidusua, nctrl, 'E', nidtda)
		If xc = 0 Then
			q = 0
		Else
			If nctrl > 0 Then
				Select atmp
				Scan All
					cxd = CancelaDeudasCCajae(dFecha, atmp.fevto, atmp.saldo, cndoc, 'P',	atmp.Moneda, cdetalle, atmp.Tipo, atmp.idrd, goApp.nidusua, atmp.Ncontrol, '', Id(), ndolar, xc)
					If cxd = 0 Then
						q = 0
						Exit
					Endif
					Select atmp
				Endscan
			Endif
		Endif
	Endif
	If q = 0  Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GeneraCorrelativo() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function TraspasoDatosLCajaErodi(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13)
	lC = "FunTraspasoDatosLcajaE"
	cur = 'c_' + Sys(2015)
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara9 = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	goApp.npara12 = np12
	goApp.npara13 = np13
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
	Endtext
	nidc = This.EJECUTARf(lC, lp, cur)
	If nidc < 0 Then
		Return 0
	Endif
	Return nidc
	Function reportecajacreditos1(Ccursor)
	Set DataSession To This.Idsesion
	dFecha = Cfechas(This.dFecha)
	nidalma = This.codt
	Text To lC Noshow Textmerge
		select day(a.fech) as dia,a.deta,
		ifnull(if(tdoc='01',concat('F/.',b.ndoc),concat('B/.',b.ndoc)),a.ndoc) as ndoc,ifnull(b.tdoc,'99') as tdoc,
		origen,tipo,case tipo when "I" then 'a' when "S" then 'b' else 'z' end as orden,
		if(a.origen='CC',a.impo,CAST(0 as decimal(10,2))) as pagos,idcaja,
		if(a.origen='CB',a.impo,CAST(0 as decimal(10,2))) as bancos from fe_caja as a
		left join fe_rcom as b on b.idauto=a.idauto
		where a.fech='<<df>>' and a.acti='A' and a.impo<>0 and a.codt=<<nidalma>> and a.caja_form='C' order by idcaja
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function reportecajacreditos2(Ccursor)
	Set DataSession To This.Idsesion
	dFecha = Cfechas(This.dFecha)
	nidalma = This.codt
	Text To lC Noshow Textmerge
		select day(a.lcaj_fech) as dia,a.lcaj_deta as deta,
		ifnull(if(tdoc='01',concat('F/.',b.ndoc),concat('B/.',b.ndoc)),a.lcaj_dcto)  as ndoc,ifnull(b.tdoc,'99') as tdoc,
		lcaj_orig as origen,if(lcaj_deud>0,'I','S') as tipo,if(lcaj_deud>0, 'a' , 'b') as orden,
		if(a.lcaj_orig='CC',a.lcaj_deud,CAST(0 as decimal(10,2))) as pagos,lcaj_idca As idcaja,
		if(a.lcaj_orig='CB',a.lcaj_acre,CAST(0 as decimal(10,2))) as bancos from fe_lcaja as a
		left join fe_rcom as b on b.idauto=a.lcaj_idau
		where a.lcaj_fech='<<df>>' and a.lcaj_acti='A' and (a.lcaj_deud<>0 or lcaj_acre<>0) 
		and a.lcaj_codt=<<nidalma>> and a.caja_form='C' order by idcaja
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function TraspasoDatosLCajaErodi0(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10)
	lC = "FunTraspasoDatosLcajaE"
	cur = "Ca"
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara9 = np9
	goApp.npara10 = np10
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
	Endtext
	nidc = This.EJECUTARf(lC, lp, cur)
	If nidc < 1 Then
		Return 0
	Endif
	Return nidc
	Endfunc
	Function reportecajapsysrx(Ccursor)
	dFecha = Cfechas(This.dFecha)
	*		if(lcaj_acre<>0,0,if(lcaj_form='E',if(lcaj_efec>0,lcaj_efec,ifnull(ROUND(k.cant*k.prec,2),a.lcaj_deud),0))) as ingresos,
	*IF(lcaj_acre<>0,0,IF(lcaj_form='E',IF(lcaj_efec>0,lcaj_efec,IFNULL(ROUND(k.cant*k.prec,2),a.lcaj_deud)),0)) AS ingresos,
*!*		if(a.lcaj_form='T',ROUND(k.cant*k.prec,2),0) as tarjeta1,
*!*	    	if(a.lcaj_form='D',ROUND(k.cant*k.prec,2),0) as deposito,
*!*	    	if(a.lcaj_form='Y',ROUND(k.cant*k.prec,2),0) as yape,
	Text To lC Noshow Textmerge
	    select if(lcaj_acre<>0,0,if(lcaj_ttar='.',0,if(lcaj_efec>0,0,ifnull(k.prec,0)))) as prec,
	    IF(lcaj_acre<>0,0,IF(lcaj_ttar='.','',IF(lcaj_efec>0,'',IFNULL(k.idart,'')))) AS coda,day(a.lcaj_fech) as dia,
	    if(lcaj_acre<>0,0,if(lcaj_ttar='.',0,if(lcaj_efec>0,0,ifnull(k.cant,0)))) as cant,
		if(a.lcaj_form='E','Efectivo',if(a.lcaj_form='C','Crédito','Tarjeta')) as forma,a.lcaj_deta as deta,
	    a.lcaj_dcto AS ndoc,
        ifnull(b.tdoc,'99') as tdoc,
		if(lcaj_acre<>0,0,if(lcaj_ttar='.',0,if(lcaj_efec>0,0,ifnull(ROUND(k.cant*k.prec,2),0)))) as Np,
        IF(lcaj_acre<>0,0,IF(lcaj_form='E',IF(lcaj_efec>0,lcaj_efec,IFNULL(ROUND(k.cant*k.prec,2),a.lcaj_deud)),0)) AS ingresos,
		if(lcaj_acre<>0,0,if(lcaj_form='C',ifnull(ROUND(k.cant*k.prec,2),a.lcaj_deud),0)) as credito,
		if(lcaj_deud>0,'I','S') as tipo,
    	if(a.lcaj_form='T',ROUND(k.cant*k.prec,2),0) as  tarjeta1,
    	if(a.lcaj_form='D',ROUND(k.cant*k.prec,2),0) as deposito,
    	if(a.lcaj_form='Y',ROUND(k.cant*k.prec,2),0) as yape,
		if(a.lcaj_acre>0,if(a.lcaj_form='E',a.lcaj_acre,0),0) as gastos,lcaj_fope,'a' as orden,lcaj_idau as idauto,ifnull(c.nruc,'') as nruc,ifnull(c.ndni,'') as ndni from
		fe_lcaja as a 
		left join fe_rcom as b on b.idauto=a.lcaj_idau 
		left join (select idart,alma,cant,prec,idauto from fe_kar as q where acti='A' AND q.alma=<<this.codt>> and tipo='V') as k  on k.idauto=b.idauto 
		LEFT join fe_clie as c on c.idclie=b.idcliente
		where a.lcaj_fech='<<dfecha>>'  and a.lcaj_acti='A' and a.lcaj_codt=<<this.codt>> and a.lcaj_form not in('T','Y','D') and left(a.lcaj_ttar,1)<>'.' and lcaj_efec=0
		union ALL
	    SELECT CAST(0 AS DECIMAL(5))AS prec,
	    '' AS coda,DAY(a.lcaj_fech) AS dia,0 AS cant,
		'Efectivo' AS forma,a.lcaj_deta AS deta,
		a.lcaj_dcto AS ndoc,
                tdoc,0 AS Np,
		a.lcaj_efec AS ingresos,
		0 AS credito,
		'I' AS tipo,
        0 AS tarjeta1,
        0 AS deposito,
        0 AS yape,
		0 AS gastos,lcaj_fope,'a' AS orden,lcaj_idau AS idauto,'' AS nruc,'' AS ndni FROM
		fe_lcaja AS a 
		LEFT JOIN fe_rcom AS b ON b.idauto=a.lcaj_idau 
		WHERE a.lcaj_fech='<<dfecha>>'  AND a.lcaj_acti='A' AND a.lcaj_codt=<<this.codt>> AND lcaj_efec>0 AND lcaj_form='E'
		union all
		select cast(0 as decimal(5))as prec,
	    '' as coda,day(a.lcaj_fech) as dia,0 as cant,
		if(a.lcaj_form='E','Efectivo',if(a.lcaj_form='C','Crédito','Tarjeta')) as forma,a.lcaj_deta as deta,
		a.lcaj_dcto as ndoc,
        ifnull(b.tdoc,'99') as tdoc,
	    0 as Np,
		a.lcaj_deud as ingresos,
		0 as credito,
		if(lcaj_deud>0,'I','S') as tipo,
        0 as tarjeta1,
        0 AS deposito,
        0 as yape,
		0 as gastos,lcaj_fope,'b' as orden,lcaj_idau as idauto,'' as nruc,'' as ndni from
		fe_lcaja as a 
		left join fe_rcom as b on b.idauto=a.lcaj_idau 
		where a.lcaj_fech='<<dfecha>>'  and a.lcaj_acti='A' and a.lcaj_codt=<<this.codt>> and left(a.lcaj_ttar,1)='.' 
		union all
		SELECT if(lcaj_acre<>0,0,if(lcaj_ttar='.',0,ifnull(k.prec,0))) as prec,
	    if(lcaj_acre<>0,0,if(lcaj_ttar='.','',ifnull(k.idart,''))) as coda,day(a.lcaj_fech) as dia,
	    if(lcaj_acre<>0,0,if(lcaj_ttar='.',0,ifnull(k.cant,0))) as cant,
		if(a.lcaj_form='Y','Yape',if(a.lcaj_form='D','Depósito','Tarjeta')) as forma,a.lcaj_deta as deta,
		a.lcaj_dcto as ndoc,
        ifnull(b.tdoc,'99') as tdoc,
		if(lcaj_acre<>0,0,if(lcaj_ttar='.',0,ifnull(ROUND(k.cant*k.prec,2),0))) as Np,
		if(lcaj_acre<>0,0,if(lcaj_form='E',ifnull(ROUND(k.cant*k.prec,2),a.lcaj_deud),0)) as ingresos,
		if(lcaj_acre<>0,0,if(lcaj_form='C',ifnull(ROUND(k.cant*k.prec,2),a.lcaj_deud),0)) as credito,
		if(lcaj_deud>0,'I','S') as tipo,
    	if(a.lcaj_form='T',lcaj_deud-lcaj_efec,0) as tarjeta1,
    	if(a.lcaj_form='D',lcaj_deud-lcaj_efec,0) as deposito,
    	if(a.lcaj_form='Y',lcaj_deud-lcaj_efec,0) as yape,
		0 as gastos,lcaj_fope,'a' as orden,lcaj_idau as idauto,ifnull(c.nruc,'') as nruc,ifnull(c.ndni,'') as ndni  from
		fe_lcaja as a 
		left join fe_rcom as b on b.idauto=a.lcaj_idau 
		left join (select idart,alma,cant,prec,idauto from fe_kar as q where acti='A' AND q.alma=<<this.codt>> and tipo='V') as k on k.idauto=b.idauto 
		LEFT join fe_clie as c on c.idclie=b.idcliente
		where a.lcaj_fech='<<dfecha>>'  and a.lcaj_acti='A' and a.lcaj_codt=<<this.codt>> and a.lcaj_form in('T','D','Y') and left(a.lcaj_ttar,1)<>'.'
		order by tdoc,ndoc
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function saldoanteriorpsysrx()
	lC = 'FunSaldoCaja'
	Calias = 'c_' + Sys(2015)
	dFecha = Cfechas(This.dFecha)
	Text To lp Noshow Textmerge
     ('<<dfecha>>',<<this.codt>>)
	Endtext
	If This.EJECUTARf(lC, lp, Calias) < 1 Then
		If This.conerror = 1 Then
			Return - 1
		Endif
	Endif
	Select (Calias)
	nsaldo = Iif(Isnull(Id), 0, Id)
	Return nsaldo
	Endfunc
Enddefine




