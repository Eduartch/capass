Define Class cajagrifos As Caja  Of 'd:\capass\modelos\caja'
	nturno = 0
	nisla = 0
	nidlectura = 0
	Function listarcaja(Calias)
	Df = Cfechas(This.dFecha)
	TEXT To lC Noshow  Textmerge
	        SELECT cajero,isla,efectivo+credito+deposito+tarjeta+dscto+centrega as Ingresos,dscto,efectivo+credito+deposito+tarjeta+centrega as ventasnetas,
	        tarjeta,credito,efectivo,centrega,egresos,efectivo-egresos as saldo,idusua from(
	        SELECT usua AS Cajero,SUM(ROUND(CASE forma WHEN 'E' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS efectivo,
			SUM(ROUND(CASE forma WHEN 'C' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS credito,
			SUM(ROUND(CASE forma WHEN 'D' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS deposito,
		    SUM(lcaj_dsct) AS dscto,
			SUM(ROUND(CASE forma WHEN 'T' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS tarjeta,
			SUM(ROUND(CASE forma WHEN 'A' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS Centrega,
			SUM(ROUND(CASE tipo WHEN 'S' THEN IF(forma='E',impo,0) ELSE 0 END,2)) AS egresos,
			lcaj_idtu,lcaj_codt as isla,lcaj_idus AS idusua
	    	FROM(
			SELECT a.lcaj_tdoc AS tdoc,a.lcaj_form AS forma,IF(lcaj_deud<>0,'I',IF(lcaj_acre=0,'I','S')) AS tipo,lcaj_dcto AS ndoc,
			IF(lcaj_deud<>0,lcaj_deud,IF(lcaj_acre=0,lcaj_deud,lcaj_acre)) AS impo,
            lcaj_deta AS deta,lcaj_mone AS  mone,lcaj_idcr AS idcredito,lcaj_idde AS iddeudas,lcaj_idau AS idauto,
			c.nomb AS usua,a.lcaj_fope AS fechao,a.lcaj_mone AS tmon1,lcaj_dola AS dola,
			IF(lcaj_deud<>0,lcaj_deud,IF(lcaj_acre=0,lcaj_deud,lcaj_acre)) AS nimpo,lcaj_idtu,lcaj_codt,lcaj_dsct,lcaj_idus FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>> AND lcaj_acti<>'I' AND lcaj_idau>0 and LEFT(c.tipo,1)="V"
			UNION ALL
			SELECT a.lcaj_tdoc,a.lcaj_form AS forma,IF(lcaj_deud<>0,'I','S') AS tipo,a.lcaj_ndoc AS ndoc,IF(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) AS impo,
            a.lcaj_deta AS deta,a.lcaj_mone AS mone,lcaj_idcr AS idcredito,lcaj_idde AS iddeudas,lcaj_idau AS idauto,
			c.nomb AS usua,a.lcaj_fope AS fechao,a.lcaj_mone AS tmon1,a.lcaj_dola AS dola,a.lcaj_deud AS nimpo,lcaj_idtu,lcaj_codt,lcaj_dsct,lcaj_idus FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON 	c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>> AND lcaj_acti<>'I' AND lcaj_idau=0 and LEFT(c.tipo,1)="V")
			AS b GROUP BY lcaj_idus,lcaj_codt,usua,lcaj_idtu) as x  ORDER BY isla,cajero
	ENDTEXT
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarcaja1(Calias)
	Df = Cfechas(This.dFecha)
	TEXT To lC Noshow Textmerge
		SELECT descri AS producto,u.nomb as Cajero,lect_idco AS surtidor,lect_mang AS manguera,lect_inic  as inicial,lect_cfinal as final,
		lect_cFinal-lect_inic As Cantidad,lect_prec as Precio,Round((lect_cFinal-lect_inic)*lect_prec,2) As Ventas,
		lect_mfinal AS montofinal,lect_inim AS montoinicial, lect_mfinal-lect_inim AS monto,
		lect_idtu as Turno,lect_fope as InicioTurno,lect_fope1 as FinTurno,lect_idar AS codigo,lect_idle as Idlecturas,lect_fech as fecha FROM fe_lecturas AS l
		INNER JOIN fe_art AS a ON a.idart=l.lect_idar
		inner join fe_usua as u on u.idusua=l.lect_idus
		WHERE lect_acti='A' and lect_idtu=<<this.nturno>> and lect_esta='C' and lect_idin=<<this.nidlectura>> order by lect_idco,lect_mang
	ENDTEXT
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarcajaparacierre(Calias)
	Df = Cfechas(This.dFecha)
	If This.nisla = 0 Then
		TEXT To lC Noshow Textmerge
	        SELECT cajero,isla,efectivo+credito+deposito+tarjeta+dscto as Ingresos,dscto,efectivo+credito+deposito+tarjeta as ventasnetas,
	        tarjeta,credito,efectivo,egresos,efectivo-egresos as saldo,idusua from(
	        SELECT usua AS Cajero,SUM(ROUND(CASE forma WHEN 'E' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS efectivo,
			SUM(ROUND(CASE forma WHEN 'C' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS credito,
			SUM(ROUND(CASE forma WHEN 'D' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS deposito,
		    SUM(lcaj_dsct) AS dscto,
			SUM(ROUND(CASE forma WHEN 'T' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS tarjeta,
			SUM(ROUND(CASE forma WHEN 'R' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS Centrega,
			SUM(ROUND(CASE tipo WHEN 'S' THEN IF(forma='E',impo,0) ELSE 0 END,2)) AS egresos,
			lcaj_idtu,lcaj_codt as isla,lcaj_idus AS idusua
	    	FROM(
			SELECT a.lcaj_tdoc AS tdoc,a.lcaj_form AS forma,IF(lcaj_deud<>0,'I',IF(lcaj_acre=0,'I','S')) AS tipo,lcaj_dcto AS ndoc,
			IF(lcaj_deud<>0,lcaj_deud,IF(lcaj_acre=0,lcaj_deud,lcaj_acre)) AS impo,
            lcaj_deta AS deta,lcaj_mone AS  mone,lcaj_idcr AS idcredito,lcaj_idde AS iddeudas,lcaj_idau AS idauto,
			c.nomb AS usua,a.lcaj_fope AS fechao,a.lcaj_mone AS tmon1,lcaj_dola AS dola,
			IF(lcaj_deud<>0,lcaj_deud,IF(lcaj_acre=0,lcaj_deud,lcaj_acre)) AS nimpo,lcaj_idtu,lcaj_codt,lcaj_dsct,lcaj_idus FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON 	c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>> AND lcaj_acti<>'I' AND lcaj_idau>0 and lcaj_idtu=<<this.nturno>>  and LEFT(c.tipo,1)="V"
			UNION ALL
			SELECT a.lcaj_tdoc,a.lcaj_form AS forma,IF(lcaj_deud<>0,'I','S') AS tipo,a.lcaj_ndoc AS ndoc,IF(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) AS impo,
            a.lcaj_deta AS deta,a.lcaj_mone AS mone,lcaj_idcr AS idcredito,lcaj_idde AS iddeudas,lcaj_idau AS idauto,
			c.nomb AS usua,a.lcaj_fope AS fechao,a.lcaj_mone AS tmon1,a.lcaj_dola AS dola,a.lcaj_deud AS nimpo,lcaj_idtu,lcaj_codt,lcaj_dsct,lcaj_idus FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON 	c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>>  AND lcaj_acti<>'I' AND lcaj_idau=0 and lcaj_idtu=<<this.nturno>> and LEFT(c.tipo,1)="V")
			AS b GROUP BY lcaj_idus,lcaj_codt) as x  ORDER BY isla,cajero
		ENDTEXT
	Else
		TEXT To lC Noshow Textmerge
	       SELECT cajero,isla,efectivo+credito+deposito+tarjeta+dscto as Ingresos,dscto,efectivo+credito+deposito+tarjeta as ventasnetas,
	       tarjeta,credito,efectivo,egresos,efectivo-egresos as saldo,idusua from(
	        SELECT usua AS Cajero,SUM(ROUND(CASE forma WHEN 'E' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS efectivo,
			SUM(ROUND(CASE forma WHEN 'C' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS credito,
			SUM(ROUND(CASE forma WHEN 'D' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS deposito,
		    SUM(lcaj_dsct) AS dscto,
			SUM(ROUND(CASE forma WHEN 'T' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS tarjeta,
			SUM(ROUND(CASE forma WHEN 'R' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS Centrega,
			SUM(ROUND(CASE tipo WHEN 'S' THEN IF(forma='E',impo,0) ELSE 0 END,2)) AS egresos,
			lcaj_idtu,lcaj_codt as isla,lcaj_idus AS idusua
	    	FROM(
			SELECT a.lcaj_tdoc AS tdoc,a.lcaj_form AS forma,IF(lcaj_deud<>0,'I',IF(lcaj_acre=0,'I','S')) AS tipo,lcaj_dcto AS ndoc,
			IF(lcaj_deud<>0,lcaj_deud,IF(lcaj_acre=0,lcaj_deud,lcaj_acre)) AS impo,
            lcaj_deta AS deta,lcaj_mone AS  mone,lcaj_idcr AS idcredito,lcaj_idde AS iddeudas,lcaj_idau AS idauto,
			c.nomb AS usua,a.lcaj_fope AS fechao,a.lcaj_mone AS tmon1,lcaj_dola AS dola,
			IF(lcaj_deud<>0,lcaj_deud,IF(lcaj_acre=0,lcaj_deud,lcaj_acre)) AS nimpo,lcaj_idtu,lcaj_codt,lcaj_dsct,lcaj_idus FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON 	c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>> AND lcaj_acti<>'I' AND lcaj_idau>0 and lcaj_idtu=<<this.nturno>>  and LEFT(c.tipo,1)="V" and lcaj_codt=<<this.nisla>>
			UNION ALL
			SELECT a.lcaj_tdoc,a.lcaj_form AS forma,IF(lcaj_deud<>0,'I','S') AS tipo,a.lcaj_ndoc AS ndoc,IF(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) AS impo,
            a.lcaj_deta AS deta,a.lcaj_mone AS mone,lcaj_idcr AS idcredito,lcaj_idde AS iddeudas,lcaj_idau AS idauto,
			c.nomb AS usua,a.lcaj_fope AS fechao,a.lcaj_mone AS tmon1,a.lcaj_dola AS dola,a.lcaj_deud AS nimpo,lcaj_idtu,lcaj_codt,lcaj_dsct,lcaj_idus FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON 	c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>>  AND lcaj_acti<>'I' AND lcaj_idau=0 and lcaj_idtu=<<this.nturno>> and LEFT(c.tipo,1)="V" and lcaj_codt=<<this.nisla>>)
			AS b GROUP BY lcaj_idus,lcaj_codt) as x  ORDER BY isla,cajero
		ENDTEXT
	Endif
	This.conconexion = 1
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		This.conconexion = 0
		Return 0
	Endif
	This.conconexion = 0
	Return 1
	Endfunc
	Function resumencajasipan(Calias)
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select "Total Ventas" As detalle, Sum(lect_mfinal-lect_inim) As Impo,'I' As tipo,'E' As lcaj_form,
	If This.nisla > 0 Then
	      \'' As isla
	Else
	      \'1' As isla
	Endif
	    \ From fe_lecturas
		\Where lect_idin=<<This.nidlectura>>  And lect_acti='A' And lect_mfinal>0
	If This.nisla > 0 Then
		Do Case
		Case  fe_gene.nruc = '20609310902'
			Do Case
			Case This.nisla = 1
		        \ And lect_idco In(1,2,3,4)
			Case This.nisla = 2
		        \ And lect_idco In(5,6,7,8)
			Endcase
		Case fe_gene.nruc = '20609681609'
              \  and lect_idco=<<this.nisla>>
		Otherwise
			Do Case
			Case This.nisla = 1
		        \ And lect_idco In(1,2)
			Case This.nisla = 2
		        \ And lect_idco In(3,4)
			Case This.nisla = 3
		        \ And lect_idco In(5,6,7,8)
			Endcase
		Endcase
	Endif
		\Union All
		\Select "Otras Ventas" As detalle,ifnull(Sum(lcaj_deud),0) As Impo,'I' As tipo,'E' As lcaj_form,'' As isla From
		\fe_lcaja As a
		\INNER Join fe_usua As c On c.idusua=a.lcaj_idus
		\Where lcaj_idle=<<This.nidlectura>>  And lcaj_acti<>'I' And lcaj_idau>0  And Left(lcaj_ndoc,5)='Otros'
	If This.nisla > 0 Then
		\ And lcaj_codt=<<This.nisla>>
	Endif
		\Union All
		\Select "Vtas al Crédito" As detalle,ifnull(Sum(lcaj_deud),0) As Impo,'E' As tipo,'C' As lcaj_form,'' As isla From
		\fe_lcaja As a
		\INNER Join fe_usua As c On c.idusua=a.lcaj_idus
		\Where lcaj_idle=<<This.nidlectura>>  And lcaj_acti<>'I' And lcaj_idau>0   And lcaj_form='C'
	If This.nisla > 0 Then
		\ And lcaj_codt=<<This.nisla>>
	Endif
		\Union All
		\Select "Vtas C/Tarjeta" As detalle,ifnull(Sum(lcaj_deud),0) As Impo,'E' As tipo,'T' As lcaj_form,'' As isla From
		\fe_lcaja As a
		\INNER Join fe_usua As c On c.idusua=a.lcaj_idus
		\Where lcaj_idle=<<This.nidlectura>>  And lcaj_acti<>'I' And lcaj_idau>0  And lcaj_form In('T')
	If This.nisla > 0 Then
		 \And lcaj_codt=<<This.nisla>>
	Endif
		\Union All
		\Select "Vtas C/Yape-Plin" As detalle,ifnull(Sum(lcaj_deud),0) As Impo,'E' As tipo,'Y' As lcaj_form,'' As isla From
		\fe_lcaja As a
		\INNER Join fe_usua As c On c.idusua=a.lcaj_idus
		\Where lcaj_idle=<<This.nidlectura>>  And lcaj_acti<>'I' And lcaj_idau>0  And lcaj_form In('Y','P')
	If This.nisla > 0 Then
		\ And lcaj_codt=<<This.nisla>>
	Endif
		\Union All
		\Select "Vtas C/Depósito" As detalle,ifnull(Sum(lcaj_deud),0) As Impo,'E' As tipo,'D' As lcaj_form,'' As isla  From
		\fe_lcaja As a
		\INNER Join fe_usua As c On c.idusua=a.lcaj_idus
		\Where  lcaj_idle=<<This.nidlectura>> And lcaj_acti<>'I' And lcaj_idau>0  And lcaj_form='D'
	If This.nisla > 0 Then
		\And lcaj_codt=<<This.nisla>>
	Endif
		\Union All
		\Select "Descuentos" As detalle,ifnull(Sum(lcaj_dsct),0) As Impo,'E' As tipo,'S' As lcaj_form,'' As isla  From
		\fe_lcaja As a
		\INNER Join fe_usua As c On c.idusua=a.lcaj_idus
		\Where  lcaj_idle=<<This.nidlectura>> And lcaj_acti<>'I' And lcaj_idau>0 And lcaj_dsct>0
	If This.nisla > 0 Then
		\ And lcaj_codt=<<This.nisla>>
	Endif
		\Union All
		\Select "Retiros" As detalle,ifnull(Sum(lcaj_acre),0) As Impo,'E' As tipo,'S' As lcaj_form,'' As isla  From
		\fe_lcaja As a
		\INNER Join fe_usua As c On c.idusua=a.lcaj_idus
		\Where  lcaj_idle=<<This.nidlectura>> And lcaj_acti<>'I' And lcaj_acre>0 and LEFT(lcaj_ndoc,6)<>'gastos'
	If This.nisla > 0 Then
		\ And lcaj_codt=<<This.nisla>>
	ENDIF
	\Union All
		\Select "Gastos" As detalle,ifnull(Sum(lcaj_acre),0) As Impo,'E' As tipo,'S' As lcaj_form,'' As isla  From
		\fe_lcaja As a
		\INNER Join fe_usua As c On c.idusua=a.lcaj_idus
		\Where  lcaj_idle=<<This.nidlectura>> And lcaj_acti<>'I' And lcaj_acre>0 and LEFT(lcaj_ndoc,6)='gastos'
	If This.nisla > 0 Then
		\ And lcaj_codt=<<This.nisla>>
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listatarjetas(nidus, Calias)
	fi = Cfechas(This.dfi)
	ff = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
		\	 Select lcaj_dcto As dcto,lcaj_deud As Importe,lcaj_btar As banco,lcaj_ttar As tipo,lcaj_rtar As referencia,lcaj_deta As detalle,u.nomb As cajero,
		\	 lcaj_fope
		\	 From fe_lcaja As l INNER Join fe_usua As u On u.idusua=lcaj_idus
		\	 Where lcaj_form='T' And lcaj_acti='A' And lcaj_idau>0
	If This.nisla > 0 Then
	\ And lcaj_codt=<<This.nisla>>
	Endif
	If nidus > 0 Then
	\ And lcaj_idus=<<nidus>>
	Endif
	If This.nidlectura > 0 Then
	   \ And lcaj_idle=<<This.nidlectura>>
	Endif
	\Order By u.nomb,lcaj_dcto
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function resumencaja(Ccursor)
	fi = Cfechas(This.dFecha)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\     Select "Total Ventas " As detalle,ifnull(Sum(a.lcaj_deud),Cast(0 As Decimal(12,2))) As Total_Ventas,'' As producto,'' As unid,
	\     Cast(0 As Decimal(12,2)) As Cantidad,
    \	  Cast(0 As Decimal(9,4)) As Precio,Cast(0 As Decimal(12,2)) As  venta,'I' As tipo From fe_lcaja  As a
	\	  Where a.lcaj_acti='A' And lcaj_idau>0 And lcaj_fech='<<fi>>' And lcaj_acti='A'  And lcaj_idus>0
	If goApp.conectasucursales = 'S' Then
	\ And lcaj_codt=<<goApp.tienda>>
	Endif
	\	  Union All
	\	  Select "Ventas Crédito" As detalle,ifnull(Sum(a.lcaj_deud),Cast(0 As Decimal(12,2))) As Total_Ventas,'' As producto,'' As unid,
	\	  Cast(0 As Decimal(12,2)) As Cantidad,
	\	  Cast(0 As Decimal(9,4)) As Precio,Cast(0 As Decimal(12,2)) As  venta,'S' As tipo From fe_lcaja  As a
	\	  Where a.lcaj_acti='A' And lcaj_form='C'  And lcaj_fech='<<fi>>' And lcaj_acti='A' And lcaj_deud>0 And lcaj_idau>0 And lcaj_idus>0
	If goApp.conectasucursales = 'S' Then
	\ And lcaj_codt=<<goApp.tienda>>
	Endif
	\	  Union All
	\	  Select "Ventas C/Tarjeta" As detalle,ifnull(Sum(a.lcaj_deud),Cast(0 As Decimal(12,2))) As Total_Ventas,'' As producto,'' As unid,
	\	  Cast(0 As Decimal(12,2)) As Cantidad,
	\	  Cast(0 As Decimal(9,4)) As Precio,Cast(0 As Decimal(12,2)) As  venta,'S' As tipo From fe_lcaja  As a
	\	  Where a.lcaj_acti='A' And lcaj_form='T'  And lcaj_fech='<<fi>>' And lcaj_acti='A' And lcaj_deud>0 And lcaj_idau>0  And lcaj_idus>0
	If goApp.conectasucursales = 'S' Then
	\ And lcaj_codt=<<goApp.tienda>>
	ENDIF
	\	  Union All
	\	  Select "Ventas C/Depósito-Yape" As detalle,ifnull(Sum(a.lcaj_deud),Cast(0 As Decimal(12,2))) As Total_Ventas,'' As producto,'' As unid,
	\	  Cast(0 As Decimal(12,2)) As Cantidad,
	\	  Cast(0 As Decimal(9,4)) As Precio,Cast(0 As Decimal(12,2)) As  venta,'S' As tipo From fe_lcaja  As a
	\	  Where a.lcaj_acti='A' And lcaj_form in ('D','Y','P')  And lcaj_fech='<<fi>>' And lcaj_acti='A' And lcaj_deud>0 And lcaj_idau>0  And lcaj_idus>0
	If goApp.conectasucursales = 'S' Then
	\ And lcaj_codt=<<goApp.tienda>>
	Endif
	\	  Union All
	\	  Select "Otros Ingresos" As detalle,ifnull(Sum(a.lcaj_deud),Cast(0 As Decimal(12,2))) As Total_Ventas,'' As producto,'' As unid,
	\	  Cast(0 As Decimal(12,2)) As Cantidad,
	\	  Cast(0 As Decimal(9,4)) As Precio,Cast(0 As Decimal(12,2)) As  venta,'I' As tipo From fe_lcaja  As a
	\	  Where a.lcaj_acti='A' And lcaj_form='E'  And lcaj_fech='<<fi>>' And lcaj_acti='A' And lcaj_idau=0 And lcaj_deud>0 And lcaj_idtra=0
	If goApp.conectasucursales = 'S' Then
	\ And lcaj_codt=<<goApp.tienda>>
	Endif
	\	  Union All
	\	  Select "Vales Consumo" As detalle,ifnull(Sum(a.lcaj_acre),Cast(0 As Decimal(12,2))) As  Total_Ventas,'' As producto,'' As unid,
	\	  Cast(0 As Decimal(12,2)) As Cantidad,
	\	  Cast(0 As Decimal(9,4)) As Precio,Cast(0 As Decimal(12,2)) As  venta,'S' As tipo From fe_lcaja  As a
	\	  Where a.lcaj_acti='A' And lcaj_form='E'  And lcaj_fech='<<fi>>' And lcaj_acti='A' And lcaj_idtra<=0  And lcaj_acre>0 And (lcaj_idau=0 Or lcaj_clpr=0)
*!*		If goApp.conectasucursales = 'S' Then
*!*		\ And lcaj_codt=<<goApp.tienda>>
*!*		Endif
	\	  Union All
	\	  Select '' As detalle,Cast(0 As Decimal(12,2)) As  Total_Ventas,Descri As producto,unid,Cast(Sum(k.cant) As Decimal(12,2)) As Cantidad,
	\	  Cast(Sum(k.cant*k.Prec)/Sum(k.cant) As Decimal(12,2)) As Precio,Cast(Sum(k.cant*k.Prec) As Decimal(12,2)) As venta,"" As tipo
	\	  From
	\	  (Select lcaj_idau From fe_lcaja Where lcaj_acti='A' And lcaj_fech='<<fi>>'  And lcaj_deud>0
	If goApp.conectasucursales = 'S' Then
	\ And lcaj_codt=<<goApp.tienda>>
	Endif
	\ Group By lcaj_idau) As  lC
	\	  INNER Join fe_rcom As r On r.idauto=lC.lcaj_idau
	\	  INNER Join fe_kar As k On  k.idauto=r.idauto
	\	  INNER Join fe_art As a On a.idart=k.idart
	\	  Where k.Acti='A' And r.Acti='A'   And idcliente>0 And r.rcom_ccaj<>'C'
	If goApp.conectasucursales = 'S' Then
	\ And r.codt=<<goApp.tienda>>
	Endif
	\ Group By k.idart
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Saldoinicialcajaefectivo()
	dfecha1 = Cfechas(This.dfi)
	dfecha2 = Cfechas(This.dff)
	Ccursor = 'c_' + Sys(2015)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\ Select Cast(Sum(If(a.lcaj_deud<>0,If(lcaj_mone='S',lcaj_deud,lcaj_deud*lcaj_dola),If(lcaj_mone='S',-lcaj_acre,-lcaj_acre*lcaj_dola)))  As Decimal(12,2)) As saldo
    \ From fe_lcaja  As a Where
	If goApp.ConectaControlador = 'S' And  Left(goApp.tipousuario, 1) <> 'A' Then
       \ a.lcaj_fech='<<dfecha2>>'
	Else
       \ a.lcaj_fech='<<dfecha2>>'
	Endif
    \ And a.lcaj_acti='A' And a.lcaj_form='E' And lcaj_idus=<<This.idusuario>> Group By lcaj_idus
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		This.conerror = 1
		Return 0
	Endif
	Select (Ccursor)
	nsaldo = Iif(Isnull(saldo), 0, saldo)
	Return nsaldo
	Endfunc
	Function ImprimeTransferenciaBoveda(nidx)
	TEXT To lC Noshow
	SELECT lcaj_fope AS fope,lcaj_fech AS fecha,lcaj_acre AS importe,lcaj_deta as refe FROM
    fe_lcaja AS l INNER JOIN fe_usua AS u ON u.idusua=l.lcaj_idus
    WHERE lcaj_idca=?nidx AND lcaj_acti='A' AND lcaj_form='E' AND lcaj_acre>0
	ENDTEXT
	If This.EJECutaconsulta(lC, 'tr') < 1 Then
		Return 0
	Endif
	Select tr
	Go Top
	Report Form Transfer To Printer Prompt Noconsole
	Return 1
	Endfunc
	Function reportecajaliq(Ccursor)
	F = Cfechas(This.dFecha)
	Set Textmerge On
	Set Textmerge To Memvar lC  Noshow Textmerge
	\ Select Deta,ndoc,
	\		Round(Case Forma When 'E' Then If(tipo='I',Impo,0) Else 0 End,2) As efectivo,
	\		Round(Case Forma When 'C' Then If(tipo='I',Impo,0) Else 0 End,2) As credito,
	\		Round(Case Forma When 'D' Then If(tipo='I',Impo,0) Else 0 End,2) As deposito,
	\	    lcaj_dsct As dscto,
	\		Round(Case Forma When 'T' Then If(tipo='I',Impo,0) Else 0 End,2) As tarjeta,
	\		Round(Case Forma When 'A' Then If(tipo='I',Impo,0) Else 0 End,2) As centrega,
	\      	Round(Case Forma When 'Y' Then If(tipo='I',Impo,0) Else 0 End,2) As yape,
	\		Round(Case tipo When 'S' Then If(Forma='E',Impo,0) Else 0 End,2) As egresos,Cast(0 As Decimal(12,2)) As saldo,
	\		usua,fechao,lcaj_idtu,lcaj_codt,lcaj_rtar As rtarjeta,usuavtas,Forma,mone,tmon1,dola,nimpo,tipo,tdoc,idcredito,iddeudas,idauto,Impo,
	\       0 As cheque
	\		From(
	\		Select a.lcaj_tdoc As tdoc,a.lcaj_form As Forma,If(lcaj_deud<>0,'I',If(lcaj_acre=0,'I','S')) As tipo,lcaj_dcto As ndoc,
	\		If(lcaj_deud<>0,lcaj_deud,If(lcaj_acre=0,lcaj_deud,lcaj_acre)) As Impo,
    \        lcaj_deta As Deta,lcaj_mone As  mone,lcaj_idcr As idcredito,lcaj_idde As iddeudas,lcaj_idau As idauto,
	\		c.nomb As usua,a.lcaj_fope As fechao,'' As usuavtas,a.lcaj_mone As tmon1,lcaj_dola As dola,
	\		If(lcaj_deud<>0,lcaj_deud,If(lcaj_acre=0,lcaj_deud,lcaj_acre)) As nimpo,lcaj_idtu,lcaj_codt,lcaj_dsct,lcaj_rtar From
	\		fe_lcaja As a
	\		INNER Join fe_usua As c On c.idusua=a.lcaj_idus Where lcaj_fech='<<f>>' And lcaj_acti<>'I' And lcaj_idau>0 And lcaj_idus=<<This.idusuario>>
	If This.nisla > 1 Then
	   \And lcaj_codt=<<This.nisla>>
	Endif
	\		Union All
	\		Select a.lcaj_tdoc,a.lcaj_form As Forma,If(lcaj_deud<>0,'I','S') As tipo,a.lcaj_ndoc As ndoc,If(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) As Impo,
    \        a.lcaj_deta As Deta,a.lcaj_mone As mone,lcaj_idcr As idcredito,lcaj_idde As iddeudas,lcaj_idau As idauto,
	\		c.nomb As usua,a.lcaj_fope As fechao,'' As usuavtas,a.lcaj_mone As tmon1,a.lcaj_dola As dola,a.lcaj_deud As nimpo,lcaj_idtu,lcaj_codt,lcaj_dsct,lcaj_rtar From
	\		fe_lcaja As a
	\		INNER Join fe_usua As c On c.idusua=a.lcaj_idus Where lcaj_fech='<<f>>' And lcaj_acti<>'I' And lcaj_idau=0 And lcaj_idus=<<This.idusuario>>
	If This.nisla > 1 Then
	   \And lcaj_codt=<<This.nisla>>
	Endif
	\)
    \		As b Order By fechao,lcaj_codt,ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return
	Endif
	Return 1
	Endfunc
	Function Saldoinicialcajaefectivoxdia()
	Ccursor = 'c_' + Sys(2015)
	F = Cfechas(This.dFecha)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\ Select Cast(Sum(If(a.lcaj_deud<>0,If(lcaj_mone='S',lcaj_deud,lcaj_deud*lcaj_dola),If(lcaj_mone='S',-lcaj_acre,-lcaj_acre*lcaj_dola)))  As Decimal(12,2)) As saldo
    \ From fe_lcaja  As a Where
	\ a.lcaj_fech='<<f>>'  And a.lcaj_acti='A' And a.lcaj_form='E' And lcaj_idus=<<This.idusuario>> Group By lcaj_idus
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		This.conerror = 1
		Return 0
	Endif
	Select (Ccursor)
	nsaldo = Iif(Isnull(saldo), 0, saldo)
	Return nsaldo
	ENDFUNC
	Function Saldoboveda()
	Ccursor = 'c_' + Sys(2015)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\ Select Cast(Sum(If(a.lcaj_deud<>0,If(lcaj_mone='S',lcaj_deud,lcaj_deud*lcaj_dola),If(lcaj_mone='S',-lcaj_acre,-lcaj_acre*lcaj_dola)))  As Decimal(12,2)) As saldo
    \ From fe_lcaja  As a Where  lcaj_acti='A' And a.lcaj_form='E' And lcaj_idus=<<This.idusuario>> Group By lcaj_idus
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		This.conerror = 1
		Return 0
	Endif
	Select (Ccursor)
	nsaldo = Iif(Isnull(saldo), 0, saldo)
	Return nsaldo
	Endfunc
Enddefine







