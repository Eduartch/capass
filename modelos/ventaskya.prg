Define Class ventaskya As ventas Of 'd:\capass\modelos\ventas.prg'
	Function createmporalpedidos(calias)
	Create Cursor unidades(uequi N(7,4),ucoda N(8),uunid c(15),uitem N(4),uprecio N(12,6),uidepta N(8),ucosto N(10,2))
	Create Cursor (calias)(Descri c(150),unid c(15),cant N(10,2),Prec N(13,8),nreg N(8),pmayor N(8,2),pmenor N(8,2),nitem N(4),;
		importe N(12,2),ndoc c(12),costo N(13,8),pos N(3),tdoc c(2),Form c(1),tipro c(1),alma N(10,2),Item N(4),coda N(8),Valida c(1),uno N(12,2),Dos N(12,2),;
		tre N(12,2),cua N(12,2),calma c(3),idco N(8),codc N(8),aprecios c(1),come N(7,4),Comc N(7,4),equi N(12,8),prem N(12,8),idepta N(8),;
		duni c(4),tigv N(6,4),npagina N(3),caant N(10,2),cletras c(150),validas c(1),valida1 c(1),fech d,direccion c(180),razon c(150),;
		copia c(1),Impo N(12,2),ndni c(8))
	Select (calias)
	Index On Descri Tag Descri
	Index On nitem Tag items
	Endfunc
	Function imprimirenbloque(calias)
	This.createmporalpedidos('tmpv')
	Select rid
	Go Top
	sw=1
	Do While !Eof()
		cimporte=""
		cimporte=Diletras(rid.Impo,'S')
		xid=rid.idauto
		nimporte=rid.Impo
		TEXT TO lc NOSHOW TEXTMERGE
		    SELECT a.ndoc,a.fech,a.tdoc,a.impo,b.idart,
		    left(concat(trim(f.dcat),' ',substr(c.descri,instr(c.descri,',')+1),' ',substr(c.descri,1,instr(c.descri,',')-1)),150) as descri,
		    b.kar_unid as unid,b.cant,b.prec,e.razo,e.dire,e.ciud,e.ndni FROM fe_rcom as a
			inner join fe_kar as b on b.idauto=a.idauto
			inner join fe_clie as e on e.idclie=a.idcliente
			inner join fe_art as c on c.idart=b.idart
			inner join fe_cat as f on f.idcat=c.idcat
			where a.acti='A' and b.acti='A' and  a.idauto=<<rid.idauto>> order by b.idkar
		ENDTEXT
		If This.EjecutaConsulta(lc,'xtmpv') <1 Then
			sw=0
			Exit
		Endif
		Select ndoc,fech,tdoc,Impo,Descri As Desc,unid As duni,cant,Prec,razo,Dire,ciud,ndni,cimporte As cletras,Recno() As nitem,unid,idart As coda From xtmpv Into Cursor xtmpv
		ni=0
		Select xtmpv
		Scan All
			cndoc=xtmpv.ndoc
			ni=ni+1
			Insert Into tmpv(ndoc,nitem,cletras,tdoc,fech,Descri,duni,cant,Prec,razon,direccion,ndni,unid,Impo,coda);
				Values(cndoc,ni,cimporte,xtmpv.tdoc,xtmpv.fech,xtmpv.Desc,xtmpv.duni,xtmpv.cant,xtmpv.Prec,xtmpv.razo,Alltrim(xtmpv.Dire)+' '+Alltrim(xtmpv.ciud),;
				xtmpv.ndni,xtmpv.unid,nimporte,xtmpv.coda)
		Endscan
		Select tmpv
		For x=1 To 17-ni
			ni=ni+1
			Insert Into tmpv(ndoc,nitem,cletras,Impo)Values(cndoc,ni,cimporte,nimporte)
		Next
		Select rid
		Skip
	Enddo
	If sw=0 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function mostrardctoparanotascredito(np1,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
	   SELECT a.idart,a.descri,k.kar_unid as unid,k.cant,k.prec,k.codv,
	   ROUND(k.cant*k.prec,2) as importe,r.idauto,r.mone,r.valor,r.igv,r.impo,kar_comi as comi,k.alma,kar_equi,
	   r.fech,r.ndoc,r.tdoc,r.dolar as dola,kar_cost FROM fe_rcom as r
	   inner join fe_kar as k on k.idauto=r.idauto
	   inner join fe_art as a on a.idart=k.idart
	   WHERE r.idauto=<<np1>> order By  idkar
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function packingkya(ccursor)
	dfi=cfechas(This.fechai)
	dff=cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\SELECT b.descri,a.kar_unid as unid,sum(a.cant) as cant,sum(ROUND(a.cant*a.prec,2)) as timporte,kar_equi,a.idart FROM fe_rcom as e
	\inner JOIN  fe_clie as d ON d.idclie=e.idcliente
	\inner join fe_kar as a on a.idauto=e.idauto
	\inner join fe_art as  b ON b.idart=a.idart
	\WHERE e.ACTI<>'I' and a.acti<>'I'  and e.fech  BETWEEN '<<dfi>>' and '<<dff>>'
	If This.vendedor>0 Then
	\ and a.codv=<<this.vendedor>>
	Endif
	If This.agrupada = 1
	\group by a.idart,a.kar_unid
	Else
	\ group by a.idart
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lc,ccursor)<1  Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function porlineaH(ccursor)
	If This.fechaf-This.fechai>31 Then
		This.cmensaje='Maximo 31 días'
		Return 0
	Endif
	fi=cfechas(This.fechai)
	ff=cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
    \   SELECT x.fech,b.idcat,SUM(a.cant) as cant,SUM(a.cant*a.prec) as importe,c.dcat
    \   FROM fe_kar as a
    \   inner join fe_rcom as x on x.idauto=a.idauto
    \   inner JOIN fe_art as b ON a.idart=b.idart
    \   inner join fe_cat as c on c.idcat=b.idcat
    \   WHERE  a.idart>0 AND a.ACTI='A' AND x.acti='A' and fech between '<<fi>>' and '<<ff>>' and a.alma>0
	If This.codt>0 Then
       \ and a.alma=<<this.codt>>
	Endif
	If This.nmarca > 0 Then
       \ and b.idmar=<<this.nmarca>>
	Endif
	If This.nlinea > 0 Then
	    \ and b.idcat=<<this.nlinea>>
	Endif
	\ group by x.fech,b.idcat,c.dcat ORDER BY fech,dcat
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lc,ccursor)<1  Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarxid(ccursor)
	TEXT TO Lc NOSHOW TEXTMERGE
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
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaResumenDctoCanjeadopsysu()
	lc='FunIngresaCabeceraVtaCanjeado'
	goapp.npara1=This.tdoc
	goapp.npara2=This.formapago
	goapp.npara3=This.serie+This.numero
	goapp.npara4=This.fecha
	goapp.npara5=""
	goapp.npara6=This.valor
	goapp.npara7=This.igv
	goapp.npara8=This.monto
	goapp.npara9=""
	goapp.npara10=This.moneda
	goapp.npara11=This.ndolar
	goapp.npara12=fe_gene.igv
	goapp.npara13='k'
	goapp.npara14=This.codigo
	goapp.npara15='V'
	goapp.npara16=goapp.nidusua
	goapp.npara17=1
	goapp.npara18=This.Almacen
	goapp.npara19=This.cta1
	goapp.npara20=This.cta2
	goapp.npara21=This.cta3
	goapp.npara22=0
	goapp.npara23=0
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23)
	ENDTEXT
	nid= This.EJECUTARF(lc,lp,'xn')
	If m.nid<1 Then
		Return 0
	Endif
	Return m.nid
	Endfunc
	Function mostrarventasxzonaspsysu(nidzona, ccursor)
	dfi=cfechas(This.fechai)
	dff=cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\    Select Descri As producto,p.Unid,Cast(T.Importe As Decimal(12,2)) As Importe,z.`zona_nomb` As zona,c.Razo As cliente From
	\	(Select Sum(k.cant*k.Prec) As Importe,idart,idcliente From fe_rcom  As r
	\	inner Join fe_kar As k On k.Idauto=r.Idauto
	\	Where fech='<<dfi>>' And '<<dff>>'  And r.Acti='A' And k.Acti='A' and k.alma>0
	If nidzona > 0 Then
		   \ And clie_idzo=<<nidzona>>
	Endif
	If This.codt>0 Then
	    \ and codt=<<this.codt>>
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
	If This.fechaf-This.fechai>60 Then
		This.cmensaje="Máximo 60 Días"
		Return 0
	Endif
	f1=cfechas(This.fechai)
	f2=cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\   Select a.idart,z.descri,kar_unid,a.cant,if(b.mone="S",cant*a.Prec,cant*a.Prec*b.dolar) As importe,
	\   e.razo as cliente,a.alma,w.dcat,a.prec,b.idcliente,kar_equi From fe_kar as a
	\	inner join fe_art as z on z.idart=a.idart
	\	inner join fe_cat as w on w.idcat=z.idcat
	\	inner join fe_rcom as b on b.idauto=a.idauto
	\	inner join fe_clie as e on e.idclie=b.idcliente
	\	where a.acti='A' and b.acti='A' and b.fech between '<<f1>>' and '<<f2>>' and a.alma>0
	If This.codt>0 Then
	   \ and b.codt=<<this.codt>>
	Endif
	Set Textmerge To
	Set Textmerge Off
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function porProveedorpsysu(nid,ccursor)
	If (This.fechaf-This.fechai)>60 Then
		This.cmensaje='Maximo 60 días'
		Return 0
	Endif
	dfi=cfechas(This.fechai)
	dff=cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\SELECT producto,p.razo  AS proveedor,kar_unid as unidad,tcant AS cantidad,timporte AS importe,yy.idprov,v.nomv as vendedor,v.idven
    \FROM(SELECT ROUND(SUM(a.cant*a.prec),2) AS timporte,SUM(a.`cant`) AS tcant,a.`codv`,p.descri AS producto,p.idprov,kar_unid FROM fe_rcom AS e
	\INNER JOIN fe_kar AS a ON a.idauto=e.idauto
	\INNER JOIN fe_art AS p ON p.idart=a.idart
    \WHERE e.ACTI<>'I' AND a.acti<>'I'  AND e.fech  BETWEEN '<<dfi>>' and '<<dff>>' AND a.alma>0
	If m.nid>0 Then
	 \ and p.idprov=<<m.nid>>
	Endif
	\GROUP BY a.idart,kar_unid,p.idprov,a.codv) AS yy
	\INNER JOIN fe_prov AS p ON p.`idprov`=yy.idprov
	\inner join fe_vend AS v ON v.idven=yy.Codv
	\ORDER BY importe DESC ,producto
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarpornrodcto(cndoc,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
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
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function rentabilidad(ccursor)
	If (This.fechaf-This.fechai)>31 Then
		This.cmensaje='Maximo 60 días'
		Return 0
	Endif
	dfi=cfechas(This.fechai)
	dff=cfechas(This.fechaf)
	TEXT TO lc NOSHOW TEXTMERGE
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
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarvtasparagraficos(ccursor)
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
    \select Month(a.fech) as Mes,Year(a.fech) as Año,a.form,if(a.mone='S',a.impo,a.impo*a.dolar) as impo,DAY(fech) As dia,fech FROM fe_rcom as a
    \inner join fe_clie as b on b.idclie=a.idcliente
    \where a.acti='A' and year(fech)=<<this.naño>>
	If This.codt>0 Then
     \and a.codt=<<this.codt>>
	Endif
    \order by fech
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return  0
	Endif
	Return 1
	ENDFUNC
	FUNCTION resumenporvendedor(ccursor)
	f1=cfechas(this.fechai)
	f2=cfechas(this.fechaf)
	SET TEXTMERGE on
	SET TEXTMERGE TO memvar lc NOSHOW TEXTMERGE 
    \SELECT Sum(a.kar_comi*((a.cant*a.prec)/e.vigv)) as comision,a.kar_comi as comi,a.idauto,e.tdoc,e.ndoc,e.fech,e.impo as importe,e.mone,a.alma,a.idart,c.nomv as nomb,e.form,
    \e.vigv as igv,a.codv,e.dolar as dola,d.razo FROM fe_rcom as e 
    \inner JOIN  fe_clie as d  ON d.idclie=e.idcliente 
    \inner join fe_kar as a on a.idauto=e.idauto  
    \inner join fe_vend as c on c.idven=a.codv
    \WHERE e.ACTI<>'I'  and e.fech BETWEEN '<<f1>>' and '<<f2>>' and a.acti<>'I' 
    IF this.vendedor>0 then
     \and a.codv=<<this.vendedor>>
    ENDIF 
    \group  by a.idauto ORDER BY c.nomv,a.idauto,e.mone
	SET TEXTMERGE off
	SET TEXTMERGE TO 
	If this.ejecutaconsulta(lc,ccursor)<1 then
		RETURN 0
	ENDIF
	RETURN 1
	ENDFUNC 
Enddefine
