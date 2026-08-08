Define Class ventaskya As ventas Of 'd:\capass\modelos\ventas.prg'
	Function createmporalpedidos(calias)
	Create Cursor unidades(uequi N(7, 4), ucoda N(8), uunid c(15), uitem N(4), uprecio N(12, 6), uidepta N(8), ucosto N(10, 2))
	Create Cursor (calias)(Descri c(150), unid c(15), cant N(10, 2), Prec N(13, 8), nreg N(8), pmayor N(8, 2), pmenor N(8, 2), nitem N(4),;
		  importe N(12, 2), ndoc c(12), costo N(13, 8), pos N(3), tdoc c(2), Form c(1), tipro c(1), alma N(10, 2), Item N(4), coda N(8), Valida c(1), uno N(12, 2), Dos N(12, 2),;
		  tre N(12, 2), cua N(12, 2), calma c(3), idco N(8), codc N(8), aprecios c(1), come N(7, 4), Comc N(7, 4), equi N(12, 8), prem N(12, 8), idepta N(8),;
		  duni c(4), tigv N(6, 4), npagina N(3), caant N(10, 2), cletras c(150), validas c(1), valida1 c(1), fech d, direccion c(180), razon c(150),;
		  copia c(1), Impo N(12, 2), ndni c(8), vendedor c(100), zona c(100), forma c(50))
	Select (calias)
	Index On Descri Tag Descri
	Index On nitem Tag items
	Endfunc
	Function imprimirenbloque(calias)
	This.createmporalpedidos('tmpv')
	Select rid
	Go Top
	sw = 1
	Do While !Eof()
		cimporte = ""
		cimporte = Diletras(rid.Impo, 'S')
		xid = rid.idauto
		nimporte = rid.Impo
		Text To lc Noshow Textmerge
		    SELECT a.ndoc,a.fech,a.tdoc,a.impo,b.idart,
		    left(concat(trim(f.dcat),' ',substr(c.descri,instr(c.descri,',')+1),' ',substr(c.descri,1,instr(c.descri,',')-1)),150) as descri,
		    b.kar_unid as unid,b.cant,b.prec,e.razo,e.dire,e.ciud,e.ndni,v.nomv as vendedor,ifnull(z.zona_nomb,'') as zona,
		    a.form  FROM fe_rcom as a
			inner join fe_kar as b on b.idauto=a.idauto
			inner join fe_clie as e on e.idclie=a.idcliente
			inner join fe_art as c on c.idart=b.idart
			inner join fe_cat as f on f.idcat=c.idcat
			inner join fe_vend As v on v.idven=b.codv 
			left join fe_zona as z on z.zona_idzo=e.clie_idzo
			where a.acti='A' and b.acti='A' and  a.idauto=<<rid.idauto>> order by b.idkar
		Endtext
		If This.EjecutaConsulta(lc, 'xtmpv') < 1 Then
			sw = 0
			Exit
		Endif
		Select ndoc, fech, tdoc, Impo, Descri As Desc, unid As duni, cant, Prec, razo, Dire, ciud, ndni, cimporte As cletras, Recno() As nitem, unid, idart As coda,;
			vendedor, form, zona From xtmpv Into Cursor xtmpv
		ni = 0
		Select xtmpv
		cformapago = Icase(xtmpv.form = 'E', 'EFECTIVO', 'CREDITO')
		Scan All
			cndoc = xtmpv.ndoc
			ni = ni + 1
			Insert Into tmpv(ndoc, nitem, cletras, tdoc, fech, Descri, duni, cant, Prec, razon, direccion, ndni, unid, Impo, coda, vendedor, zona, forma);
				Values(cndoc, ni, cimporte, xtmpv.tdoc, xtmpv.fech, xtmpv.Desc, xtmpv.duni, xtmpv.cant, xtmpv.Prec, xtmpv.razo, Alltrim(xtmpv.Dire) + ' ' + Alltrim(xtmpv.ciud),;
				  xtmpv.ndni, xtmpv.unid, nimporte, xtmpv.coda, xtmpv.vendedor, xtmpv.zona, m.cformapago)
		Endscan
		Select tmpv
		For x = 1 To 17 - ni
			ni = ni + 1
			Insert Into tmpv(ndoc, nitem, cletras, Impo)Values(cndoc, ni, cimporte, nimporte)
		Next
		Select rid
		Skip
	Enddo
	If sw = 0 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function mostrardctoparanotascredito(np1, ccursor)
	Text To lc Noshow Textmerge
	   SELECT a.idart,a.descri,k.kar_unid as unid,k.cant,k.prec,k.codv,
	   ROUND(k.cant*k.prec,2) as importe,r.idauto,r.mone,r.valor,r.igv,r.impo,kar_comi as comi,k.alma,kar_equi,
	   r.fech,r.ndoc,r.tdoc,r.dolar as dola,kar_cost FROM fe_rcom as r
	   inner join fe_kar as k on k.idauto=r.idauto
	   inner join fe_art as a on a.idart=k.idart
	   WHERE r.idauto=<<np1>> order By  idkar
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function packingkya(ccursor)
	dfi = cfechas(This.fechai)
	dff = cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select b.Descri,a.kar_unid As unid,Sum(a.cant) As cant,Sum(Round(a.cant*a.Prec,2)) As timporte,kar_equi,a.idart From fe_rcom As e
	\inner Join  fe_clie As d On d.idclie=e.idcliente
	\inner Join fe_kar As a On a.idauto=e.idauto
	\inner Join fe_art As  b On b.idart=a.idart
	\Where e.Acti<>'I' And a.Acti<>'I'  And e.fech  Between '<<dfi>>' And '<<dff>>'
	If This.vendedor > 0 Then
	\ And a.codv=<<This.vendedor>>
	Endif
	If This.agrupada = 1
	\Group By a.idart,a.kar_unid
	Else
	\ Group By a.idart
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lc, ccursor) < 1  Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function porlineaH(ccursor)
	If This.fechaf - This.fechai > 31 Then
		This.cmensaje = 'Maximo 31 días'
		Return 0
	Endif
	fi = cfechas(This.fechai)
	ff = cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
    \   Select x.fech,b.idcat,Sum(a.cant) As cant,Sum(a.cant*a.Prec) As importe,c.dcat
    \   From fe_kar As a
    \   inner Join fe_rcom As x On x.idauto=a.idauto
    \   inner Join fe_art As b On a.idart=b.idart
    \   inner Join fe_cat As c On c.idcat=b.idcat
    \   Where  a.idart>0 And a.Acti='A' And x.Acti='A' And fech Between '<<fi>>' And '<<ff>>' And a.alma>0
	If This.codt > 0 Then
       \ And a.alma=<<This.codt>>
	Endif
	If This.nmarca > 0 Then
       \ And b.idmar=<<This.nmarca>>
	Endif
	If This.nlinea > 0 Then
	    \ And b.idcat=<<This.nlinea>>
	Endif
	\ Group By x.fech,b.idcat,c.dcat Order By fech,dcat
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lc, ccursor) < 1  Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarxid(ccursor)
	Text To lc Noshow Textmerge
	  SELECT  `c`.`rcom_mens`,`c`.`rcom_idtr`,  `a`.`codv` ,  `a`.`idauto`,  `a`.`kar_cost`, `a`.`kar_tigv` as tigv, `a`.`kar_posi` ,
	  `a`.`kar_equi`,  `a`.`kar_epta`,  `a`.`kar_comi`,  `a`.`alma`,  `a`.`kar_idco`  AS `idcosto`,  `a`.`idkar`,  `a`.`idart`,  `a`.`cant`,  `a`.`prec`,  `c`.`valor`,  `c`.`igv`,
	  `c`.`impo`,  `c`.`fech`,  `c`.`fecr`,  `c`.`form`,  `c`.`deta`, `c`.`ndo2`,  `c`.`rcom_entr`,
	  `c`.`idcliente` AS `idclie`,  `d`.`razo`,  `d`.`nruc`,  `d`.`dire`,  `d`.`ciud`,
	  `d`.`ndni`,  `a`.`tipo`,  `c`.`tdoc`,  `c`.`ndoc`,  `c`.`dolar`,`c`.`mone`,kar_cost,
	  LEFT(CONCAT(TRIM(`t`.`dcat`),' ',SUBSTR(`b`.`descri`,(LOCATE(',',`b`.`descri`) + 1)),' ',SUBSTR(`b`.`descri`,1,(LOCATE(',',`b`.`descri`) - 1))),150) AS `descri`,
	  IFNULL(`x`.`idcaja`,0) AS `idcaja`,  `a`.`kar_unid`  AS `unid`,  `b`.`premay`    AS `pre1`,
	  `b`.`peso`,  `b`.`premen`    AS `pre2`,  IFNULL(`z`.`vend_idrv`,0) AS `nidrv`,  `c`.`vigv`      AS `vigv`,
	  `c`.`idcliente` ,`c`.`codt`,  `b`.`pre3` AS `pre3`, `b`.`cost`      AS `costo`,  `b`.`uno`,  `b`.`dos`,  `b`.`tre`,  `b`.`cua`,  (`b`.`uno` + `b`.`dos`) AS `TAlma`,  `c`.`fusua` ,  `p`.`nomv`  AS `Vendedor`,  `q`.`nomb`      AS `Usuario`
	  FROM  `fe_rcom` `c`
	  JOIN `fe_kar` `a`     ON   `c`.`idauto` = `a`.`idauto`
	  JOIN `fe_art` `b`    ON   `a`.`idart` = `b`.`idart`
	  JOIN `fe_cat` `t`     ON   `t`.`idcat` = `b`.`idcat`
	  LEFT JOIN `fe_caja` `x` ON   `x`.`idauto` = `c`.`idauto`
	  JOIN `fe_clie` `d`      ON   `c`.`idcliente` = `d`.`idclie`
	  JOIN `fe_vend` `p`      ON   `p`.`idven` = `a`.`codv`
	  JOIN `fe_usua` `q`      ON   `q`.`idusua` = `c`.`idusua`
	  LEFT JOIN `fe_rvendedor` `z`     ON   `z`.`vend_idau` = `c`.`idauto`
	WHERE   `c`.`idauto` = <<this.idauto>>  AND  `c`.`acti` <> 'I'   AND  `a`.`acti` <> 'I'
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaResumenDctoCanjeadopsysu()
	lc = 'FunIngresaCabeceraVtaCanjeado'
	goapp.npara1 = This.tdoc
	goapp.npara2 = This.formapago
	goapp.npara3 = This.serie + This.numero
	goapp.npara4 = This.fecha
	goapp.npara5 = ""
	goapp.npara6 = This.valor
	goapp.npara7 = This.igv
	goapp.npara8 = This.monto
	goapp.npara9 = ""
	goapp.npara10 = This.moneda
	goapp.npara11 = This.ndolar
	goapp.npara12 = fe_gene.igv
	goapp.npara13 = 'k'
	goapp.npara14 = This.codigo
	goapp.npara15 = 'V'
	goapp.npara16 = goapp.nidusua
	goapp.npara17 = 1
	goapp.npara18 = This.Almacen
	goapp.npara19 = This.cta1
	goapp.npara20 = This.cta2
	goapp.npara21 = This.cta3
	goapp.npara22 = 0
	goapp.npara23 = 0
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23)
	Endtext
	nid = This.EJECUTARF(lc, lp, 'xn')
	If m.nid < 1 Then
		Return 0
	Endif
	Return m.nid
	Endfunc
	Function mostrarventasxzonaspsysu(nidzona, ccursor)
	dfi = cfechas(This.fechai)
	dff = cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\    Select Descri As producto,p.unid,Cast(T.importe As Decimal(12,2)) As importe,z.`zona_nomb` As zona,c.razo As cliente From
	\	(Select Sum(k.cant*k.Prec) As importe,idart,idcliente From fe_rcom  As r
	\	inner Join fe_kar As k On k.idauto=r.idauto
	\	Where fech='<<dfi>>' And '<<dff>>'  And r.Acti='A' And k.Acti='A' And k.alma>0
	If nidzona > 0 Then
		   \ And clie_idzo=<<nidzona>>
	Endif
	If This.codt > 0 Then
	    \ And codt=<<This.codt>>
	Endif
	\Group By k.idart,r.`idcliente` ) As T
	\	inner Join fe_clie As c On c.idclie=T.`idcliente`
	\	inner Join fe_art As p  On p.`idart`=T.`idart`
	\	inner Join fe_zona As z On z.`zona_idzo`=c.`clie_idzo` Order By zona_nomb
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function resumenporcliente(ccursor)
	If This.fechaf - This.fechai > 60 Then
		This.cmensaje = "Máximo 60 Días"
		Return 0
	Endif
	f1 = cfechas(This.fechai)
	f2 = cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\   Select a.idart,z.Descri,kar_unid,a.cant,If(b.mone="S",cant*a.Prec,cant*a.Prec*b.dolar) As importe,
	\   e.razo As cliente,a.alma,w.dcat,a.Prec,b.idcliente,kar_equi From fe_kar As a
	\	inner Join fe_art As z On z.idart=a.idart
	\	inner Join fe_cat As w On w.idcat=z.idcat
	\	inner Join fe_rcom As b On b.idauto=a.idauto
	\	inner Join fe_clie As e On e.idclie=b.idcliente
	\	Where a.Acti='A' And b.Acti='A' And b.fech Between '<<f1>>' And '<<f2>>' And a.alma>0
	If This.codt > 0 Then
	   \ And b.codt=<<This.codt>>
	Endif
	Set Textmerge To
	Set Textmerge Off
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function porProveedorpsysu(nid, ccursor)
	If (This.fechaf - This.fechai) > 60 Then
		This.cmensaje = 'Maximo 60 días'
		Return 0
	Endif
	dfi = cfechas(This.fechai)
	dff = cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select producto,p.razo  As proveedor,kar_unid As unidad,tcant As cantidad,timporte As importe,yy.idprov,v.nomv As vendedor,v.idven
    \From(Select Round(Sum(a.cant*a.Prec),2) As timporte,Sum(a.`cant`) As tcant,a.`codv`,p.Descri As producto,p.idprov,kar_unid From fe_rcom As e
	\inner Join fe_kar As a On a.idauto=e.idauto
	\inner Join fe_art As p On p.idart=a.idart
    \Where e.Acti<>'I' And a.Acti<>'I'  And e.fech  Between '<<dfi>>' And '<<dff>>' And a.alma>0
	If m.nid > 0 Then
	 \ And p.idprov=<<m.nid>>
	Endif
	\Group By a.idart,kar_unid,p.idprov,a.codv) As yy
	\inner Join fe_prov As p On p.`idprov`=yy.idprov
	\inner Join fe_vend As v On v.idven=yy.codv
	\Order By importe Desc ,producto
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarpornrodcto(cndoc, ccursor)
	Text To lc Noshow Textmerge
	select  a.idart as coda,left(concat(trim(c.dcat),' ',substr(a.descri,instr(a.descri,',') +1),' ',substr(a.descri,1,instr(a.descri,',' )-1)),150)  as  descri,
	x.pres_desc as unid,cant,k.Prec,Round(cant*k.Prec,2) As  importe,premay,premen,r.fech,r.idauto,r.Impo,r.ndoc,idkar  as  nreg, idcliente as idclie,
	codv  as idven,nomv as vendedor,kar_posi As  pos,a.cost as costo,kar_equi as equi,razo,Dire,ciud,r.deta as detalle,' S ' As Valida,vigv,
	kar_epta  As idepta,uno+dos+tre+cua As alma,uno,Dos,tre,cua,Form,j.idcaja,clie_lcre
	from fe_rcom as r
	inner join fe_clie as e on e.idclie=r.idcliente
	inner join fe_kar as k on k.idauto=r.idauto
	inner join fe_art as a on a.idart=k.idart
	inner join fe_cat as c on c.idcat=a.idcat
	inner join fe_vend as v on v.idven=k.codv
	inner join fe_epta as f on f.epta_idep=k.kar_epta
	inner join fe_presentaciones as x on x.pres_idpr=f.epta_pres
	inner join fe_caja as j on j.idauto=r.idauto
    where k.acti='A' and r.ndoc='<<cndoc>>' and r.acti='A' order by idkar
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function rentabilidad(ccursor)
	If (This.fechaf - This.fechai) > 31 Then
		This.cmensaje = 'Maximo 60 días'
		Return 0
	Endif
	dfi = cfechas(This.fechai)
	dff = cfechas(This.fechaf)
	Text To lc Noshow Textmerge
	SELECT b.Descri,b.Unid,cant,kar_cost AS costounitario,
	CAST(IF(c.Mone='S',k.Prec,k.Prec*c.dolar)  AS DECIMAL(12,4))AS PrecioVenta,
	CAST(cant*kar_cost AS DECIMAL(12,2)) AS costototal,
	CAST(cant*IF(c.Mone='S',k.Prec,k.Prec*c.dolar)  AS DECIMAL(12,2)) AS ventatotal,
	IF(Tdoc='07',CAST(0 AS DECIMAL(12,2)),CAST((cant*IF(c.Mone='S',k.Prec,k.Prec*c.dolar))-(cant*k.kar_cost) AS DECIMAL(12,2))) AS Utilidad,
	IF(Tdoc='07',CAST(0 AS DECIMAL(12,2)),CAST((((cant*IF(c.Mone='S',k.Prec,k.Prec*c.dolar))-(cant*k.kar_cost))*100)/(cant*kar_cost) AS DECIMAL(6,2))) AS porcentaje,
	cc.Razo AS cliente,v.`nomv` AS Vendedor,Ndoc,fech,c.Idauto,k.idart AS Coda,c.impo as importe
	FROM fe_rcom AS c
	INNER JOIN fe_kar AS k ON k.Idauto=c.Idauto
    INNER JOIN fe_art AS b ON b.idart=k.idart
    INNER JOIN fe_clie AS cc ON cc.idclie=c.idcliente
    INNER JOIN fe_vend AS v ON v.idven=k.Codv
    WHERE k.Acti='A' AND c.Acti='A' AND c.fech BETWEEN  '<<dfi>>' AND '<<dff>>'   AND c.tcom<>'T'  AND k.alma>0
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarvtasparagraficos(ccursor)
	If This.idsesion > 0 Then
		Set DataSession To This.idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
    \Select Month(a.fech) As Mes,Year(a.fech) As Año,a.Form,If(a.mone='S',a.Impo,a.Impo*a.dolar) As Impo,Day(fech) As dia,fech From fe_rcom As a
    \inner Join fe_clie As b On b.idclie=a.idcliente
    \Where a.Acti='A' And Year(fech)=<<This.naño>>
	If This.codt > 0 Then
     \And a.codt=<<This.codt>>
	Endif
    \Order By fech
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return  0
	Endif
	Return 1
	Endfunc
	Function resumenporvendedor(ccursor)
	f1 = cfechas(This.fechai)
	f2 = cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
    \Select Sum(a.kar_comi*((a.cant*a.Prec)/e.vigv)) As comision,a.kar_comi As comi,a.idauto,e.tdoc,e.ndoc,e.fech,e.Impo As importe,e.mone,a.alma,a.idart,c.nomv As nomb,e.Form,
    \e.vigv As igv,a.codv,e.dolar As dola,d.razo From fe_rcom As e
    \inner Join  fe_clie As d  On d.idclie=e.idcliente
    \inner Join fe_kar As a On a.idauto=e.idauto
    \inner Join fe_vend As c On c.idven=a.codv
    \Where e.Acti<>'I'  And e.fech Between '<<f1>>' And '<<f2>>' And a.Acti<>'I'
	If This.vendedor > 0 Then
     \And a.codv=<<This.vendedor>>
	Endif
    \Group  By a.idauto Order By c.nomv,a.idauto,e.mone
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine

