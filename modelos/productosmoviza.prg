Define Class productosmoviza As Producto  Of 'd:\capass\modelos\productos.prg'
	Function MuestraTodos(np1,np2,Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	lC = 'ProMuestraProductos'
	goApp.npara1 = np1
	goApp.npara2 = np2
    Text To lp Noshow
     (?goapp.npara1,?goapp.npara2)
	Endtext
	If This.EJECUTARP(lC, lp, Ccursor) = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function calcularstockproductogmoviza(nidart, nalma, Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lC Noshow Textmerge
	 SELECT a.tcompras-a.tventas as saldo
	 FROM (SELECT b.idart,SUM(IF(b.tipo='C',b.cant*b.kar_equi,0)) AS tcompras,
	 SUM(IF(b.tipo='V',b.cant*b.kar_equi,0)) AS tventas,b.alma
	 FROM fe_kar AS b
	 INNER JOIN fe_rcom AS e ON e.idauto=b.idauto
	 WHERE b.acti<>'I'  AND e.acti='A' and b.alma=<<nalma>> and b.idart=<<nidart>>
	 GROUP BY  idart,alma) AS a
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraProductosCstock(np1, np2, np3, Ccursor)
	lC = 'ProMuestraProductosConStock'
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	Endtext
	If This.EJECUTARP(lC, lp, Ccursor) = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function conStockminimopsysg(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lC Noshow Textmerge
	    SELECT   descri AS producto,unid,stock,Prod_smin AS minimo,diferencia
		FROM(SELECT descri,unid,uno+dos+tre+cua+cin+sei AS stock,prod_smin,prod_smax,
		prod_smin-(uno+dos+tre+cua+cin) AS diferencia  FROM fe_art AS a
		WHERE prod_acti<>'I' AND prod_smin>0) AS x WHERE diferencia>0
		ORDER BY descri
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MostrarStockparaAjustes(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select b.idart As nreg,b.idart,b.Descri As Descr,b.unid,
	Do Case
	Case This.nidtda = 1
		\b.uno As alma
	Case This.nidtda = 2
		\b.Dos As alma
	Case This.nidtda = 1
		\''
	Case This.nidtda = 4
		\b.cua As alma
	Case This.nidtda = 5
		 \b.cin As alma
	Case This.nidtda = 6
		\b.sei As alma
	Endcase
	\,Cast(0 As Decimal(8,2)) As ajuste,Cast(0 As Decimal(8,2)) As ajustado From fe_art  As b Where prod_acti='A'
	If This.ccat > 0 Then
		\And  b.idcat=<<This.ccat>>
	Endif
	\ Order By b.Descri;
		Set Textmerge Off
	Set Textmerge To
	If  This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraPresentacionesXProducto1(np1, np2, cur)
	Local lC, lp
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	lC			 = 'ProMuestraPresentacionesXProducto'
	goApp.npara1 = np1
	goApp.npara2 = np2
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2)
	Endtext
	If This.EJECUTARP(lC, lp, cur) = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaPreciosEpta(np1, np2, np3, np4, np5, np6, np7, np8, np9)
	Local lC, lp
	If !Pemstatus(goApp, 'ListaPreciosPorTienda', 5) Then
		AddProperty(goApp, 'ListaPreciosPorTienda', '')
	Endif
	lC			 = 'FUNCREAEPTA'
	cur			 = "XEpta"
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara8 = np9
	If goApp.ListaPreciosPorTienda = 'S' Then
		Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9)
		Endtext
	Else
		Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8)
		Endtext
	Endif
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function ActualizapreciosEpta(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11)
	Local lC, lp
	Local lC, lp
	If !Pemstatus(goApp, 'ListaPreciosPorTienda', 5) Then
		AddProperty(goApp, 'ListaPreciosPorTienda', '')
	Endif
	lC			  = 'PROACTUALIZAEPTA'
	goApp.npara1  = np1
	goApp.npara2  = np2
	goApp.npara3  = np3
	goApp.npara4  = np4
	goApp.npara5  = np5
	goApp.npara6  = np6
	goApp.npara7  = np7
	goApp.npara8  = np8
	goApp.npara9  = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	If goApp.ListaPreciosPorTienda = 'S' Then
		Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11)
		Endtext
	Else
		Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
		Endtext
	Endif
	If This.EJECUTARP(lC, lp, '') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraProductosconstock(np1, np2, Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	lC = 'ProMuestraProductosConStockmas'
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3  = This.constock
	Text To lp Noshow
        (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	Endtext
	This.conconexion = 1
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Actualizarcostospsysg()
	Text To lC Noshow
          UPDATE fe_art SET prod_cost=<<this.ncosto>>,tmon='S',prec=<<this.nprec>> WHERE idart=<<this.nidart>>
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine









