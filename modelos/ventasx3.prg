Define Class ventasx3 As Ventas  Of 'd:\capass\modelos\ventas.prg'
	Function listardctonotascredtitod(nid, Ccursor)
	Text To lC Noshow Textmerge
	    SELECT a.idart,a.descri,a.unid,k.cant,k.prec,rOUND(k.cant*k.prec,2) as importe,
	    k.idauto,r.mone,r.valor,r.igv,r.impo,kar_comi as comi,k.alma,
		r.fech,r.ndoc,r.tdoc,r.dolar as dola,r.vigv,r.rcom_exon,'K' as tcom,k.idkar,if(k.prec=0,kar_cost,0) as costoref,
		kar_equi,prod_cod1,kar_cost,kar_lote,kar_fvto,codv  from fe_rcom r
		inner join fe_kar k on k.idauto=r.idauto
		inner join fe_art a on a.idart=k.idart
		where k.acti='A' and r.acti='A' and r.idauto=<<nid>>  order by idkar
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function listardctonotascredtito(nid, Ccursor)
	Text To lC Noshow Textmerge
	    SELECT a.idart,a.descri,a.unid,k.cant,k.prec,rOUND(k.cant*k.prec,2) as importe,
	    k.idauto,r.mone,r.valor,r.igv,r.impo,kar_comi as comi,k.alma,
		r.fech,r.ndoc,r.tdoc,r.dolar as dola,r.vigv,r.rcom_exon,tcom,k.idkar,if(k.prec=0,kar_cost,0) as costoref,
		kar_equi,prod_cod1,kar_cost,codv from fe_rcom r
		inner join fe_kar k on k.idauto=r.idauto
		inner join fe_art a on a.idart=k.idart
		where k.acti='A' and r.acti='A' and r.idauto=<<nid>>  order by idkar
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function listardetallevtas(Ccursor)
	dfi = cfechas(This.fechai)
	dff = cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge  To Memvar lC Noshow
	    \Select Tdoc, ndoc, r.fech, Razo, Descri, kar_unid As unid, cant, k.Prec, mone, u.nomb As Usuario,
	    \If(a.tmon = 'S', a.Prec, a.Prec * v.dola) As costo,
		\Form, cant * k.Prec As Impo, If(mone = 'S', cant * k.Prec, cant * k.Prec * r.dolar) As impo1, p.nruc, ndni,Dire,ciud,g.nomv,k.idart,r.vigv  From fe_rcom r
		\inner Join fe_kar k On k.idauto = r.idauto
		\inner Join fe_clie p On p.idcliE = r.Idcliente
		\inner Join fe_usua u On u.Idusua = r.Idusua
		\inner Join fe_art a On a.idart = k.idart
		\inner Join fe_vend As g On g.idven=r.rcom_vend, fe_gene As v
	    \Where  r.fech  Between '<<dfi>>' And '<<dff>>'
	If This.codt > 0 Then
		\ And r.codt=<<This.codt>>
	Endif
	Set Textmerge To
	Set Textmerge To Memvar lC Noshow  Additive
		\And k.Acti = 'A' And r.Acti = 'A' Order By r.fech,r.Tdoc, r.ndoc
	Set Textmerge To
	Set Textmerge Off
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaresumen(Ccursor)
	f1 = cfechas(This.fechai)
	f2 = cfechas(This.fechaf)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
	\Select  ndoc As dcto,a.fech,b.nruc,b.Razo,If(a.mone='S','Soles','Dólares') As moneda,a.valor,a.rcom_exon,a.rcom_inaf,rcom_otro,
	\	    a.igv,a.Impo,rcom_hash,rcom_mens,mone,a.Tdoc,a.ndoc,idauto,rcom_arch,b.clie_corr,tcom
	\	    From fe_rcom As a Join fe_clie As b On (a.Idcliente=b.idcliE)
	\	    Where a.fech Between '<<f1>>' And '<<f2>>'  And  a.Acti<>'I'  And Left(ndoc,1) In("F","B")
	If This.codt > 0 Then
		   \ And a.codt=<<This.codt>>
	Endif
	If Len(Alltrim(This.Tdoc)) > 0 Then
	\ And a.Tdoc='<<this.Tdoc>>'
	Endif
	\Order By fech,ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarvtasparareimprimir(np2, np3, Ccursor)
	cpropiedad = "cdatos"
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("cdatos", "")
	Endif
	Do Case
	Case np2 = '01' Or np2 = '03' Or np2 = '20'
		If np3 = 'S' Or np3 = 'T' Then
			Set Textmerge On
			Set Textmerge To Memvar lC Noshow  Textmerge
			\Select 4 As codv, c.idauto, Cast(0  As Decimal(4, 2)) As idart, Cast(If(detv_item = 1, detv_cant, 0) As Decimal(12, 2)) As cant,
			\Cast(If(detv_item = 1, detv_prec, 0) As Decimal(12, 4)) As Prec, c.codt As alma,
			\c.Tdoc As Tdoc1, c.rcom_arch, "" As duni, "" As unid, "" As Codigo1, c.Idcliente As Codigo, ifnull(p.fevto, c.fech) As fvto,
			\c.ndoc As dcto, c.fech As fech1, c.vigv, '' As nlote, Curdate() As Fechavto,
			\c.fech, c.fecr, c.Form, c.rcom_exon, c.Ndo2, c.Idcliente, d.Razo, d.nruc, d.Dire, d.ciud, d.ndni, c.igv,
			\c.pimpo, u.nomb As Usuario, c.Deta, Cast(0 As Decimal(12, 2)) As costo,
			\c.Tdoc, c.ndoc, c.dolar As dola, c.mone, m.detv_desc As Descri, '' As unid,
			\c.rcom_hash, 'Oficina' As nomv, c.Impo, c.valor, c.rcom_dsct As dscto,
			\"" As ptop, "" As ptollegada, c.fech As fect, "" As Placa, "" As razont, "" As ruct, "" As conductor,
			\"" As direcciont, "" As brevete, "" As Constancia, "" As marca, rcom_porc, c.tcom As Tipovta,
			\c.rcom_inaf, Cast(0 As Decimal(8, 2)) As Pagocon, Cast(0 As Decimal(8, 2)) As vto,
			If goApp.Cdatos <> 'S' Then
			   \vv.nruc as rucempresa,vv.empresa,vv.ptop As direccionemp
			Else
			   \vv.nruc As rucempresa,vv.nomb As empresa,Concat(Trim(vv.Dire),'',Trim(vv.ciud)) As direccionemp
			Endif
			\From fe_rcom As c
			\inner Join fe_clie As d On(d.idcliE = c.Idcliente)
			\inner Join fe_usua As u On u.Idusua = c.Idusua
			\inner Join fe_detallevta As m On m.detv_idau = c.idauto
			\Left Join (Select rcre_idau, Min(c.fevto) As fevto From fe_rcred As r
			\inner Join fe_cred As c On c.cred_idrc = r.rcre_idrc
			\Where rcre_Acti = 'A' And Acti = 'A' Group By rcre_idau) As p On p.rcre_idau = c.idauto
			If goApp.Cdatos <> 'S' Then
			   \,fe_gene As vv
			Else
			   \ inner Join fe_sucu As vv On vv.idalma=c.codt
			Endif
			\Where c.idauto =<<This.idauto>> Group By Descri Order By detv_ite1
			Set Textmerge Off
			Set Textmerge To
		Else
			Set Textmerge On
			Set Textmerge To Memvar lC Noshow  Textmerge
			\Select a.codv, a.idauto, a.alma, a.idkar, a.idauto, a.idart, a.cant, a.Prec, a.alma, c.Tdoc As Tdoc1, c.Idcliente As Codigo, ifnull(p.fevto, c.fech) As fvto,
			\c.ndoc As dcto, c.fech As fech1, c.vigv, c.rcom_arch, b.prod_cod1 As Codigo1, kar_fvto As Fechavto, kar_lote As nlote, kar_cost As costo,
			\c.fech, c.fecr, c.Form, c.Deta, c.rcom_exon, c.Ndo2, c.igv, c.Idcliente, d.Razo, d.nruc, d.Dire, d.ciud, d.ndni, c.pimpo, u.nomb As Usuario, c.tcom As Tipovta,
			\c.Tdoc, c.ndoc, c.dolar As dola, c.mone, b.Descri, a.kar_unid As unid, a.kar_unid As duni, c.rcom_hash, v.nomv, c.valor, c.Impo, c.rcom_dsct As dscto,
			\ifnull(g.guia_ptop, "") As ptop, ifnull(guia_ptoll, '') As ptollegada, c.fech As fect, ifnull(T.Placa, "") As Placa,
			\ifnull(T.razon, "") As razont, ifnull(T.ructr, "") As ruct, ifnull(T.nombr, "") As conductor, ifnull(T.dirtr, "") As direcciont, ifnull(T.breve, "") As brevete,
			\ifnull(T.Cons, "") As Constancia, ifnull(T.marca, "") As marca, rcom_porc, c.rcom_inaf,
			If goApp.Imprimevuelto = 'S' Then
				\rcom_pagc As Pagocon, rcom_vuel As vto,
			Else
				\Cast(0 As Decimal(8, 2)) As Pagocon, Cast(0 As Decimal(8, 2)) As vto,
			Endif
			If goApp.Cdatos <> 'S' Then
			   \vv.nruc as rucempresa,vv.empresa,vv.ptop As direccionemp
			Else
			   \vv.nruc As rucempresa,vv.nomb As empresa,Concat(Trim(vv.Dire),'',Trim(vv.ciud)) As direccionemp
			Endif
			\From fe_rcom As c
			\inner Join fe_kar As a On(a.idauto = c.idauto)
			\inner Join fe_art As b On(b.idart = a.idart)
			\inner Join fe_vend As v On v.idven = a.codv
			\inner Join fe_clie As d On(c.Idcliente = d.idcliE)
			\inner Join fe_usua As u On u.Idusua = c.Idusua
			\Left Join (Select guia_ptop, guia_ptoll, guia_idau, guia_idtr From fe_guias
			\Where guia_acti = 'A' And guia_idau =<<This.idauto>> Group By guia_idau, guia_ptop, guia_ptoll, guia_idtr Limit 1 )As g On g.guia_idau = c.idauto
			\Left Join fe_tra T On T.idtra = g.guia_idtr
			\Left Join (Select rcre_idau, Min(c.fevto) As fevto From fe_rcred As r inner Join fe_cred As c On c.cred_idrc = r.rcre_idrc
			\Where rcre_Acti = 'A' And Acti = 'A' And rcre_idau =<<This.idauto>>  Group By rcre_idau) As p On p.rcre_idau = c.idauto
			If goApp.Cdatos <> 'S' Then
			   \,fe_gene As vv
			Else
			   \ inner Join fe_sucu As vv On vv.idalma=c.codt
			Endif
			\Where c.idauto =<<This.idauto>> And a.Acti = 'A';
				Set Textmerge Off
			Set Textmerge To
		Endif
	Case np2 = '08'
		Set Textmerge On
		Set Textmerge To Memvar lC Noshow  Textmerge
		\Select r.idauto, r.ndoc, r.Tdoc, r.fech, r.mone, Abs(r.valor) As valor, r.Ndo2,
		\r.vigv, c.nruc, c.Razo, c.Dire, c.ciud, c.ndni, ' ' As nomv, r.Form, "" As Codigo1, r.Idcliente As Codigo, r.fech As fvto,
		\Abs(r.igv) As igv, Abs(r.Impo) As Impo, ifnull(k.cant, Cast(1 As Decimal(12, 2))) As cant,
		\ifnull(k.kar_lote, '') As nlote, k.kar_fvto As Fechavto, Cast(0 As Decimal(12, 2)) As costo, r.tcom As Tipovta,
		\ifnull(k.Prec, Abs(r.Impo)) As Prec, Left(r.ndoc, 4) As Serie, Substr(r.ndoc, 5) As numero,
		\ifnull(kar_unid, '') As unid, ifnull(kar_unid, '') As duni, ifnull(a.Descri, r.Deta) As Descri, r.Deta,
		\ifnull(k.idart, Cast(0 As Decimal(8))) As idart, w.ndoc As dcto, Abs(r.rcom_porc) As rcom_porc, r.rcom_inaf,
		\w.fech As fech1, w.Tdoc As Tdoc1, r.rcom_hash, u.nomb As Usuario, r.rcom_arch, Abs(r.rcom_dsct) As dscto,
		\"" As ptop, "" As ptollegada, r.fech As fect, "" As Placa, "" As razont, "" As ruct, "" As conductor, "" As direcciont,
		\"" As brevete, "" As Constancia, "" As marca, Cast(0 As Decimal(8, 2)) As Pagocon, Cast(0 As Decimal(8, 2)) As vto,
		If goApp.Cdatos <> 'S' Then
			   \vv.nruc as rucempresa,vv.empresa,vv.ptop As direccionemp
		Else
			   \vv.nruc as rucempresa,vv.nomb As empresa,Concat(Trim(vv.Dire),'',Trim(vv.ciud)) As direccionemp
		Endif
		\From fe_rcom r
		\inner Join fe_clie c On c.idcliE = r.Idcliente
		\Left Join fe_kar k On k.idauto = r.idauto
		\Left Join fe_art a On a.idart = k.idart
		\inner Join fe_ncven F On F.ncre_idan = r.idauto
		\inner Join fe_rcom As w On w.idauto = F.ncre_idau
		\inner Join fe_usua As u On u.Idusua = r.Idusua
		If goApp.Cdatos <> 'S' Then
			   \,fe_gene As vv
		Else
			   \ inner Join fe_sucu As vv On vv.idalma=c.codt
		Endif
		\Where r.idauto =<<This.idauto>> And r.Acti = 'A' And r.Tdoc = '08'
		Set Textmerge Off
		Set Textmerge To
	Case np2 = '07'
		Set Textmerge On
		Set Textmerge To Memvar lC Noshow  Textmerge
		\Select r.idauto, r.ndoc, r.Tdoc, r.fech, r.mone, Abs(r.valor) As valor, r.Ndo2,
		\r.vigv, c.nruc, c.Razo, c.Dire, c.ciud, c.ndni, ' ' As nomv, r.Form, u.nomb As Usuario, "" As Codigo1, r.Idcliente As Codigo, r.fech As fvto,
		\Abs(r.igv) As igv, Abs(r.Impo) As Impo, ifnull(k.cant, Cast(1 As Decimal(12, 2))) As cant, Cast(0 As Decimal(12, 2)) As costo,
		\ifnull(k.kar_lote, '') As nlote, k.kar_fvto As Fechavto,
		\ifnull(k.Prec, Abs(r.Impo)) As Prec, Left(r.ndoc, 4) As Serie, Substr(r.ndoc, 5) As numero,
		\ifnull(kar_unid, '') As unid, ifnull(kar_unid, '') As duni, ifnull(a.Descri, r.Deta) As Descri, r.Deta,
		\ifnull(k.idart, Cast(0 As Decimal(8))) As idart, w.ndoc As dcto,
		\w.fech As fech1, w.Tdoc As Tdoc1, r.rcom_hash, r.rcom_arch, Abs(r.rcom_dsct) As dscto, Abs(r.rcom_porc) As rcom_porc, r.rcom_inaf,
		\"" As ptop, "" As ptollegada, r.fech As fect, "" As Placa, "" As razont, "" As ruct, "" As conductor,
		\"" As direcciont, "" As brevete, "" As Constancia, "" As marca, r.tcom As Tipovta, Cast(0 As Decimal(8, 2)) As Pagocon, Cast(0 As Decimal(8, 2)) As vto,
		If goApp.Cdatos <> 'S' Then
			   \vv.nruc as rucempresa,vv.empresa,vv.ptop As direccionemp
		Else
			   \vv.nruc As rucempresa,vv.nomb As empresa,Concat(Trim(vv.Dire),'',Trim(vv.ciud)) As direccionemp
		Endif
		\From fe_rcom r
		\inner Join fe_clie c On c.idcliE = r.Idcliente
		\Left Join fe_kar k On k.idauto = r.idauto
		\Left Join fe_art a On a.idart = k.idart
		\inner Join fe_ncven F On F.ncre_idan = r.idauto
		\inner Join fe_rcom As w On w.idauto = F.ncre_idau
		\inner Join fe_usua As u On u.Idusua = r.Idusua
		If goApp.Cdatos <> 'S' Then
			   \,fe_gene As vv
		Else
			   \ inner Join fe_sucu As vv On vv.idalma=r.codt
		Endif
		\Where r.idauto =<<This.idauto>> And r.Acti = 'A' And r.Tdoc = '07'
		Set Textmerge Off
		Set Textmerge To
	Endcase
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine