Define Class pedidoskya As cotizacion Of 'd:\capass\modelos\cotizacion'
	Function Listar(dfi, dff, Ccursor)
	Text To lC Noshow Textmerge
              SELECT ndoc,fech,b.razo,mone,valor,igv,impo,idauto,tdoc,a.idcliente as cod FROM fe_rcom as a
              INNER JOIN fe_clie as b ON b.idclie=a.idcliente
              WHERE tdoc="20"  AND a.acti='A' and a.tipom='V' and a.fech between '<<dfi>>' and '<<dff>>' ORDER BY ndoc,fech
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarparacanje(Ccursor)
	Text To lC NOSHOW TEXTMERGE 
		   SELECT v.idart,a.descri,v.kar_unid as unid,v.cant,v.prec,v.codv as idven,s.nomv as vendedor,v.kar_posi as pos,v.kar_epta as idepta,
		   v.kar_equi as equi,r.dcat,a.cost as costo,v.idauto as idautop,w.igv as tigv,prod_stoc1,prod_stoc2,v.cant*v.kar_equi as tcant FROM
		   fe_kar as v
		   inner join fe_art as a on a.idart=v.idart
		   inner join fe_cat as r ON r.idcat=a.idcat
		   inner join fe_vend as s on s.idven=v.codv, fe_gene as w
		   where v.idauto=<<this.nidautop>> and v.acti='A'  order by v.idkar
	Endtext
	If This.ejecutaconsulta( lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine


