Define Class presentaciones As OData Of 'd:\capass\database\data'
	Function MuestratPresentaciones(np1, cur)
	lC = 'PROMUESTRAPRESENTACIONESP'
	goApp.npara1 = np1
	TEXT To lp Noshow Textmerge
     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraPresentacion(np1, cur)
	TEXT To lp Noshow Textmerge
	    SELECT a.pres_desc,CAST(IF(p.tmon='S',(((p.prec*g.igv)+prod_flet)*epta_cant),(((p.prec*g.igv*g.dola)+prod_flet)*epta_cant)) AS DECIMAL(10,4)) AS epta_cost,b.epta_marg,
		CAST(ROUND(IF(p.tmon='S',(((p.prec*g.igv)+prod_flet)*epta_cant),(((p.prec*g.igv*g.dola)+prod_flet)*epta_cant))*(1+(epta_marg/100)),0.5) AS DECIMAL(10,2)) AS epta_prec,
		epta_mcor,
		CAST(CEILING((IF(p.tmon='S',(((p.prec*g.igv)+prod_flet)*epta_cant),(((p.prec*g.igv*g.dola)+prod_flet)*epta_cant)))*(1+(epta_mcor/100))*10)/10 AS DECIMAL(10,2)) AS epta_pcor,
		CAST(CEILING((IF(p.tmon='S',(((p.prec*g.igv)+prod_flet)*epta_cant),(((p.prec*g.igv*g.dola)+prod_flet)*epta_cant)))*(1+(epta_marg/100))*10)/10 AS DECIMAL(10,2)) AS epta_preciox,
		ROUND(epta_comi*100,3) AS epta_comi,epta_list,
		IF(b.epta_mone='S',ROUND(b.epta_cost/((100-g.pmvtas)/100),2),ROUND((b.epta_cost*g.dola)/((100-g.pmvtas)/100),2)) AS precio1,
		IF(b.epta_mone='S',b.epta_cost,ROUND(b.epta_cost*g.dola,2)) AS costo,
		b.epta_cant,b.epta_pres,b.epta_idar,b.epta_idep,b.epta_mone,b.epta_esti,b.epta_comi
		FROM fe_epta AS b
		INNER JOIN fe_presentaciones AS a  ON b.epta_pres=a.pres_idpr
		INNER JOIN (SELECT idart,prec,tmon,prod_flet FROM fe_art WHERE idart=<<np1>> LIMIT 1) AS p ON p.idart=b.epta_idar,fe_gene AS g
		WHERE b.epta_acti='A' AND a.pres_acti='A' AND epta_idar=<<np1>> ORDER BY b.epta_cant;
	ENDTEXT
	If This.EJECutaconsulta(lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function muestrapresentacionkya(np1, cur)
*IF(b.epta_cost>0,IF(b.epta_mone='S',IF(b.epta_esti='M',ROUND(b.epta_cost*((b.epta_marg/100)+1),2),ROUND(b.epta_cost*((b.epta_marg/100)+1),2)),IF(b.epta_esti='M',ROUND(b.epta_cost*g.dola*((b.epta_marg/100)+1),2),ROUND(b.epta_cost*g.dola*((b.epta_marg/100)+1),2))),b.epta_prec) AS epta_prec,
	TEXT To lC Noshow Textmerge
		SELECT a.pres_desc,b.epta_cant,b.epta_cost,b.epta_marg,epta_prec,
		IF(b.epta_mone='S',ROUND(b.epta_cost/((100-g.pmvtas)/100),2),ROUND((b.epta_cost*g.dola)/((100-g.pmvtas)/100),2)) AS precio1,
		IF(b.epta_mone='S',b.epta_cost,ROUND(b.epta_cost*g.dola,2)) AS costo,
		b.epta_pres,b.epta_idar,b.epta_idep,b.epta_mone,b.epta_esti
		FROM fe_epta AS b
		INNER JOIN fe_presentaciones AS a  ON b.epta_pres=a.pres_idpr,fe_gene AS g
		WHERE b.epta_acti='A' AND a.pres_acti='A' AND epta_idar=<<np1>> ORDER BY b.epta_cant;
	ENDTEXT
	If This.EJECutaconsulta(lC, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraPresentacionespsysg(npara1, npara2, npara3, cur)
	goApp.npara1 = npara1
	goApp.npara2 = npara2
	goApp.npara3 = npara3
	lC = 'PROMUESTRAPRESENTACIONES'
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	If This.EJECUTARP(lC, lp, cur) < 1  Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraPresentacioneXProductox(np1, Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	lC = 'ProMuestraPresentacionesXProducto'
	goApp.npara1 = np1
	TEXT To lp Noshow
     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraPresentacionesXProducto1(np1, np2, Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	lC = 'ProMuestraPresentacionesXProducto'
	goApp.npara1 = np1
	goApp.npara2 = np2
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registrarunidadesvta(objdetalle)
	lC = 'FUNCREAEPTA'
	cur = "XEpta"
*  *  idp,lpta.epta_pres,lpta.epta_prec,lpta.epta_cant,lpta.epta_cost,lpta.epta_marg,lpta.epta_mone,lpta.epta_esti
	goApp.npara1 = objdetalle.idart
	goApp.npara2 = objdetalle.idpres
	goApp.npara3 = objdetalle.nprec
	goApp.npara4 = objdetalle.ncant
	goApp.npara5 = objdetalle.ncosto
	goApp.npara6 =  objdetalle.nmargen
	goApp.npara7 = objdetalle.cmoneda
	goApp.npara8 = objdetalle.cestilo
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8)
	ENDTEXT
	nidp=This.EJECUTARf(lC, lp, cur)
	If nidp <1  Then
		Return 0
	Endif
	Return nidp
	Endfunc
	Function actualizarunidadesvta(objdetalle)
	lC = 'PROACTUALIZAEPTA'
*ncoda,lpta.epta_pres,lpta.epta_prec,lpta.epta_cant,lpta.epta_idep,1,lpta.epta_cost,lpta.epta_marg,lpta.epta_mone,lpta.epta_esti
	goApp.npara1 = objdetalle.idart
	goApp.npara2 = objdetalle.idpres
	goApp.npara3 = objdetalle.nprec
	goApp.npara4 = objdetalle.ncant
	goApp.npara5 = objdetalle.idep
	goApp.npara6 = 1
	goApp.npara7 =  objdetalle.ncosto
	goApp.npara8 =objdetalle.nmargen
	goApp.npara9= objdetalle.cmoneda
	goApp.npara10=objdetalle.cestilo
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
	ENDTEXT
	If This.EJECUTARP(lC, lp, '') <1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function desactivarunidadesvta(nid)
	TEXT TO lc NOSHOW TEXTMERGE
	UPDATE fe_epta SET epta_acti='I' WHERE epta_idep=<<nid>>
	ENDTEXT
	If This.ejecutarsql(lC)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function RegistraUnidadesPR(cparam1,cparam2)
	np1=cparam1
	np2=cparam2
	TEXT TO lc NOSHOW
        UPDATE fe_presentaciones SET pres_unid=?np2 WHERE pres_idpr=?np1
	ENDTEXT
	If This.ejecutarsql(lC)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
*!*	*************************
*!*		Function MuestraPresentacionesXProducto1(np1, np2, cur)
*!*		lC = 'ProMuestraPresentacionesXProducto'
*!*		goApp.npara1 = np1
*!*		goApp.npara2 = np2
*!*		TEXT To lp Noshow
*!*	     (?goapp.npara1,?goapp.npara2)
*!*		ENDTEXT
*!*		If EJECUTARP(lC, lp, cur) = 0 Then
*!*			Errorbd(ERRORPROC + 'Mostrando Presentaciones de Productos')
*!*			Return 0
*!*		Else
*!*			Return 1
*!*		Endif
*!*		Endfunc
Enddefine


