Define Class presentaciones As Odata Of 'd:\capass\database\data'
*************************
	Function MuestratPresentaciones(np1, cur)
	lC = 'PROMUESTRAPRESENTACIONESP'
	goApp.npara1 = np1
	Text To lp Noshow Textmerge
     (?goapp.npara1)
	Endtext
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
*************************
	Function MuestraPresentacion(np1, cur)
	Text To lp Noshow Textmerge
	    SELECT a.pres_desc,CAST(IF(p.tmon='S',(((p.prec*g.igv)+prod_flet)*epta_cant),(((p.prec*g.igv*g.dola)+prod_flet)*epta_cant)) AS DECIMAL(10,4)) AS epta_cost,b.epta_marg,
		CAST(CEILING((IF(p.tmon='S',(((p.prec*g.igv)+prod_flet)*epta_cant),(((p.prec*g.igv*g.dola)+prod_flet)*epta_cant)))*(1+(epta_marg/100))*10)/10 AS DECIMAL(10,2)) AS epta_prec,
		epta_mcor,
		CAST(CEILING((IF(p.tmon='S',(((p.prec*g.igv)+prod_flet)*epta_cant),(((p.prec*g.igv*g.dola)+prod_flet)*epta_cant)))*(1+(epta_mcor/100))*10)/10 AS DECIMAL(10,2)) AS epta_pcor,
		ROUND(epta_comi*100,3) AS epta_comi,epta_list,
		IF(b.epta_mone='S',ROUND(b.epta_cost/((100-g.pmvtas)/100),2),ROUND((b.epta_cost*g.dola)/((100-g.pmvtas)/100),2)) AS precio1,
		IF(b.epta_mone='S',b.epta_cost,ROUND(b.epta_cost*g.dola,2)) AS costo,
		b.epta_cant,b.epta_pres,b.epta_idar,b.epta_idep,b.epta_mone,b.epta_esti,b.epta_comi
		FROM fe_epta AS b
		INNER JOIN fe_presentaciones AS a  ON b.epta_pres=a.pres_idpr
		INNER JOIN (SELECT idart,prec,tmon,prod_flet FROM fe_art WHERE idart=<<np1>> LIMIT 1) AS p ON p.idart=b.epta_idar,fe_gene AS g
		WHERE b.epta_acti='A' AND a.pres_acti='A' AND epta_idar=<<np1>> ORDER BY b.epta_cant;
	Endtext
	If This.EjecutaConsulta(lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function muestrapresentacionkya(np1, cur)
*IF(b.epta_cost>0,IF(b.epta_mone='S',IF(b.epta_esti='M',ROUND(b.epta_cost*((b.epta_marg/100)+1),2),ROUND(b.epta_cost*((b.epta_marg/100)+1),2)),IF(b.epta_esti='M',ROUND(b.epta_cost*g.dola*((b.epta_marg/100)+1),2),ROUND(b.epta_cost*g.dola*((b.epta_marg/100)+1),2))),b.epta_prec) AS epta_prec,
	Text To lC Noshow Textmerge
		SELECT a.pres_desc,b.epta_cant,b.epta_cost,b.epta_marg,epta_prec,
		IF(b.epta_mone='S',ROUND(b.epta_cost/((100-g.pmvtas)/100),2),ROUND((b.epta_cost*g.dola)/((100-g.pmvtas)/100),2)) AS precio1,
		IF(b.epta_mone='S',b.epta_cost,ROUND(b.epta_cost*g.dola,2)) AS costo,
		b.epta_pres,b.epta_idar,b.epta_idep,b.epta_mone,b.epta_esti 
		FROM fe_epta AS b
		INNER JOIN fe_presentaciones AS a  ON b.epta_pres=a.pres_idpr,fe_gene AS g
		WHERE b.epta_acti='A' AND a.pres_acti='A' AND epta_idar=<<np1>> ORDER BY b.epta_cant;
	Endtext
	If This.EjecutaConsulta(lC, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraPresentacionespsysg(npara1, npara2, npara3, cur)
	goApp.npara1 = npara1
	goApp.npara2 = npara2
	goApp.npara3 = npara3
	lC = 'PROMUESTRAPRESENTACIONES'
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	Endtext
	If This.EJECUTARP(lC, lp, cur) < 1  Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine


