Define Class notascreditocompras As ODATA Of 'd:\capass\database\data'
	Function listarparaaplicarunudades(nid,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
		   SELECT  `c`.`idusua`    AS `idusua`,
		  `a`.`idauto`    AS `idauto`,  `a`.`alma`      AS `alma`, ROUND(a.cant*a.prec*c.vigv,2) as importe,
		  `a`.`idkar`     AS `idkar`,  `a`.`kar_equi`  AS `kar_equi`,  `b`.`descri`    AS `descri`,
		  `b`.`peso`      AS `peso`,  `b`.`prod_idco` AS `prod_idco`,  `a`.`kar_unid`  AS `unid`,
		  `b`.`tipro`     AS `tipro`,  `a`.`idart`     AS `idart`,  `a`.`incl`      AS `incl`,
		  `c`.`ndoc`      AS `ndoc`,  `c`.`valor`     AS `valor`,  `c`.`igv`       AS `igv`,
		  `c`.`impo`      AS `impo`,  `c`.`pimpo`     AS `pimpo`,  `a`.`cant`      AS `cant`, ROUND(a.prec*c.vigv,6) as prec ,  `c`.`fech`      AS `fech`,  `c`.`fecr`      AS `fecr`,
		  `c`.`form`      AS `form`,  `c`.`exon`      AS `exon`,  `c`.`ndo2`      AS `ndo2`,
		  `c`.`vigv`      AS `vigv`,  `c`.`idprov`    AS `idprov`,  `a`.`tipo`      AS `tipo`,
		  `c`.`tdoc`      AS `tdoc`,  `c`.`dolar`     AS `dolar`,  `c`.`mone`      AS `mone`,  `p`.`razo`      AS `razo`,
		  `p`.`dire`      AS `dire`,  `p`.`ciud`      AS `ciud`,  `p`.`nruc`      AS `nruc`,
		  `a`.`kar_posi`  AS `kar_posi`,  `a`.`kar_epta`  AS `kar_epta`,  `c`.`codt`      AS `codt`,
		  `c`.`fusua`     AS `fusua`,  `w`.`nomb`      AS `Usuario`
		  FROM `fe_rcom` `c`
		       LEFT JOIN `fe_kar` `a`     ON `c`.`idauto` = `a`.`idauto`
		       LEFT JOIN `fe_art` `b`      ON `b`.`idart` = `a`.`idart`
		       JOIN `fe_prov` `p`    ON `p`.`idprov` = `c`.`idprov`
		       JOIN `fe_usua` `w`   ON `w`.`idusua` = `c`.`idusua`
		WHERE `c`.`acti` <> 'I'    AND `a`.`acti` <> 'I'  AND c.idauto=<<nid>>
	ENDTEXT
	IF this.ejecutaconsulta(lc,ccursor)<1 then
	   RETURN 0
	ENDIF 
	RETURN 1   
	Endfunc
Enddefine
