Define Class productosgrifos As producto  Of 'd:\capass\modelos\productos.prg'
	Function MuestraProductosDescCod(np1, np2, np3, np4, ccursor)
	Local lc, lp
	m.lc		 = 'PROMUESTRAPRODUCTOS1'
	goapp.npara1 = m.np1
	If goapp.Listapreciosportienda='S' Then
		goapp.npara2 = goapp.tienda
	Else
		goapp.npara2 = m.np2
	Endif
	goapp.npara3 = m.np3
	goapp.npara4 = m.np4
	TEXT To m.lp Noshow
        (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, m.ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarkardexproductogrifos(ccoda,dfechai,dfechaf,nalma,ccursor)
	SET TEXTMERGE on
	SET TEXTMERGE TO memvar lc NOSHOW TEXTMERGE 
	   \SELECT '' as nped,d.ndo2,d.fech,d.ndoc,d.tdoc,a.tipo,d.mone as cmoneda,a.cant,d.fusua,ifnull(g.nomb,'') as usua1,
	   \a.prec,d.vigv as igv,d.dolar,f.nomb as usua,d.idcliente as codc,b.razo AS cliente,d.idprov as codp,c.razo AS proveedor,d.deta,a.alma
	   \FROM fe_kar as a
	   \inner JOIN fe_rcom as d on (d.idauto=a.idauto)
	   \left join fe_prov as c ON(d.idprov=c.idprov)
	   \left JOIN fe_clie as b ON(d.idcliente=b.idclie)
	   \inner join fe_usua as f ON(f.idusua=d.idusua)
	   \left join fe_usua as g ON (g.idusua=d.idusua1)
	   \WHERE a.idart=<<ccoda>> and d.acti<>'I' and d.fech between '<<dfechai>>' and  '<<dfechaf>>' and a.acti<>'I' and d.rcom_ccaj<>'C' 
	   IF nalma>0 then
	     \ and a.alma=<<nalma>>
	   ENDIF 
	   \ ORDER BY d.fusua,d.fech,d.tipom,d.fusua
	SET TEXTMERGE off
	SET TEXTMERGE to
    If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return  0
	Endif
	Return 1
	Endfunc
Enddefine
