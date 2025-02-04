Define Class Ventasxmsys As Ventas Of 'd:\capass\modelos\Ventas'
	Function buscarxid(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To  This.Idsesion
	Endif
	Text To lC Noshow Textmerge
		SELECT  `c`.`idusua`    AS `idusua`,  `a`.`kar_comi`  AS `kar_comi`,
	  `a`.`codv`      AS `codv`,  `a`.`idauto`    AS `idauto`,
	  `a`.`alma`      AS `alma`,  `a`.`kar_idco`  AS `idcosto`,
	  `a`.`idkar`     AS `idkar`,  `a`.`idart`,  `a`.`cant`      AS `cant`,
	  `a`.`prec`      AS `prec`,  `c`.`valor`     AS `valor`,  `c`.`igv`       AS `igv`,  `c`.`impo`      AS `impo`,
	  `c`.`fech`      AS `fech`,  `c`.`fecr`      AS `fecr`,  `c`.`form`      AS `form`,
	  `c`.`deta`      AS `deta`,  `c`.`exon`      AS `exon`,  `c`.`ndo2`      AS `ndo2`,
	  `c`.`rcom_entr` AS `rcom_entr`,  `c`.`idcliente` AS `idclie`,  `d`.`razo`      AS `razo`,
	  `d`.`nruc`      AS `nruc`,  `c`.`rcom_dsct` AS `rcom_dsct`,  `d`.`dire`      AS `dire`,
	  `d`.`ciud`      AS `ciud`,  `d`.`ndni`      AS `ndni`,  `a`.`tipo`      AS `tipo`,
	  `c`.`tdoc`      AS `tdoc`,  `c`.`ndoc`      AS `ndoc`,  `c`.`dolar`     AS `dolar`,
	  `c`.`mone`      AS `mone`,  `b`.`descri`    AS `descri`,  CAST(0 AS UNSIGNED) AS `idcaja`,
	  `b`.`unid`      AS `unid`,  `b`.`prod_coda` AS `prod_coda`,  `b`.`dmar`      AS `dmar`,
	  `b`.`pre1`      AS `pre1`,  `b`.`peso`      AS `peso`,  `b`.`pre2`      AS `pre2`,
	  IFNULL(`z`.`vend_idrv`,0) AS `nidrv`,  `c`.`vigv`      AS `vigv`,
	  `a`.`dsnc`      AS `dsnc`,  `a`.`dsnd`      AS `dsnd`,  `a`.`gast`      AS `gast`,
	  `c`.`idcliente` AS `idcliente`,  `c`.`codt`      AS `codt`,
	  `b`.`pre3`      AS `pre3`,  `b`.`cost`      AS `costo`,
	  `b`.`uno`       AS `uno`,  `b`.`dos`       AS `dos`,  (`b`.`uno` + `b`.`dos`) AS `TAlma`,
	  `c`.`fusua`     AS `fusua`,  `p`.`nomv`      AS `Vendedor`,  `q`.`nomb`      AS `Usuario`,
	  `c`.`rcom_idtr` AS `rcom_idtr`,  `c`.`rcom_tipo` AS `rcom_tipo`,  `a`.`kar_cant`  AS `kar_cant`,
	  `a`.`kar_tpro`  AS `kar_tpro`,  `a`.`kar_pre1`  AS `kar_pre1`,  `a`.`kar_esti`  AS `kar_esti`,
	  `a`.`kar_code`  AS `kar_code`,  `c`.`rcom_mens` AS `rcom_mens`,  `c`.`rcom_carg` AS `rcom_carg`,
	  `a`.`kar_refe`  AS `kar_refe`,  `c`.`rcom_exon` AS `rcom_exon`,  `d`.`clie_rete` AS `clie_rete`,
	  `c`.`rcom_mret` AS `rcom_mret`
	  FROM       `fe_rcom` `c`
	     JOIN `fe_kar` `a`       ON   `a`.`idauto` = `c`.`idauto`   
	     JOIN `vlistaprecios` `b`   ON   `b`.`idart` = `a`.`idart`   
	     JOIN `fe_clie` `d`      ON   `d`.`idclie` = `c`.`idcliente`   
	     JOIN `fe_vend` `p`     ON   `p`.`idven` = `a`.`codv`   
	     JOIN `fe_usua` `q`    ON   `q`.`idusua` = `c`.`idusua`   
	     LEFT JOIN (select vend_idau,vend_idrv from`fe_rvendedor`  as z where vend_acti='A') `z`    ON   `z`.`vend_idau` = `c`.`idauto`   
	     WHERE   `c`.`idcliente` > 0  AND  `c`.`acti` <> 'I'   AND  `a`.`acti` <> 'I'  and a.idauto=<<this.idauto>> 
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine