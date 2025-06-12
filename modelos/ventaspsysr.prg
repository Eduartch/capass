Define Class ventaspsysr As Ventas Of 'd:\capass\modelos\ventas'
	Function buscarxid(Ccursor)
	Text To lC Noshow Textmerge
	  select a.kar_comi,a.codv,a.idauto,  c.codt    AS alma,  a.kar_idco  AS idcosto,
	  a.idkar,  a.idart,  a.cant,a.prec prec,  c.valor,  c.igv igv,c.rcom_exon,
	  c.impo      AS impo,  c.fech      AS fech,  c.fecr      AS fecr,
	  c.form      AS form,  c.deta      AS deta,  c.exon      AS exon,
	  c.ndo2      AS ndo2,  c.rcom_entr AS rcom_entr,  c.idcliente AS idclie,
	  d.razo      AS razo,  d.nruc      AS nruc,  d.dire      AS dire,
	  d.ciud      AS ciud,  d.ndni      AS ndni,  a.tipo      AS tipo,
	  c.tdoc      AS tdoc,  c.ndoc      AS ndoc,  c.dolar     AS dolar,
	  c.mone      AS mone,  b.descri    AS descri,  IFNULL(xx.idcaja,0) AS idcaja,  b.unid      AS unid,
	  b.premay    AS pre1,  b.peso      AS peso,  b.premen    AS pre2,
	  IFNULL(z.vend_idrv,0) AS nidrv,  c.vigv      AS vigv,
	  a.dsnc,a.dsnd,  a.gast,c.idcliente AS idcliente,c.codt,
	  IFNULL(b.pre3,0)      AS pre3,  b.cost      AS costo,b.uno,  b.dos,
	  (((b.uno + b.dos) + b.tre) + b.cin) AS TAlma, b.tre,b.cua, b.cin       AS cin,  a.kar_codi  AS kar_codi,
	  c.fusua     AS fusua,  p.nomv      AS Vendedor,  q.nomb      AS Usuario,  b.tipro     AS tipro,
	  IFNULL(p.fevto,c.fech) AS fvto,rcom_nitem,rcom_mens,
	  d.Razo, d.Dire, d.ciud, d.nruc, d.ndni, d.clie_lcre, d.fono, d.clie_codv, d.clie_tipo, d.idcliE, IFNULL(dpto_nomb,'') AS dpto, d.clie_dist as distrito
	FROM fe_art b
	    JOIN fe_kar a  ON b.idart = a.idart
	    JOIN fe_rcom c  ON a.idauto = c.idauto
	    LEFT JOIN fe_caja xx  ON xx.idauto = c.idauto
	    JOIN fe_clie d  ON c.idcliente = d.idclie
	    JOIN fe_vend p  ON p.idven = a.codv
	    JOIN fe_usua q   ON q.idusua = c.idusua
	    LEFT JOIN fe_rvendedor z ON z.vend_idau = c.idauto
	    LEFT JOIN (SELECT rcre_idau,MIN(c.fevto) AS fevto FROM fe_rcred AS r INNER JOIN fe_cred AS c ON c.cred_idrc=r.rcre_idrc
	    WHERE rcre_acti='A' AND acti='A' AND rcre_idau=<<this.idauto>> GROUP BY rcre_idau) AS p ON p.rcre_idau=a.idauto
	    LEFT JOIN fe_dpto bb ON bb.dpto_idpt=d.clie_idpt 
	    WHERE c.tipom = 'V'   AND c.acti <> 'I'  AND a.acti <> 'I' AND c.idauto=<<this.idauto>>
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
Enddefine