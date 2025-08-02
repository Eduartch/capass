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
	  `d`.`ndni`,  `a`.`tipo`,  `c`.`tdoc`,  `c`.`ndoc`,  `c`.`dolar`,`c`.`mone`,
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
Enddefine
