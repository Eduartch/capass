Define Class lecturas As OData Of 'd:\capass\database\data.prg'
	nturno = 0
	nisla = 0
	motivocierre = ""
	nidlectura = 0
	Function ConsultarLecturas(Calias)
	Df = Cfechas(fe_gene.fech - 2)
	lC = 'ProlistarDespachos'
	Text To lp Noshow Textmerge
	     ('<<df>>',<<goapp.isla>>)
	Endtext
	This.conconexion = 1
	If EJECUTARP(lC, lp, Calias ) < 1 Then
		Return 0
	Endif
	This.conconexion = 0
	Return 1
	Endfunc
	Function IngresalecturasContometros20(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10)
	Local cur As String
	lC = 'PROINGRESALECTURA'
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara9 = np9
	goApp.npara10 = np10
	Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
	Endtext
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registralecturas(Calias)
	nsgtelectura = goApp.Idlecturas + 1
	Do Case
	Case goApp.Isla = 1
		Text To lC Noshow Textmerge
          UPDATE fe_gene  SET idle1=nsgtelectura
		Endtext
	Case goApp.Isla = 2
		Text To lC Noshow Textmerge
          UPDATE fe_gene  SET idle2=nsgtelectura
		Endtext
	Case goApp.Isla = 3
		Text To lC Noshow Textmerge
          UPDATE fe_gene   SET idle3=nsgtelectura
		Endtext
	Case goApp.Isla = 4
		Text To lC Noshow Textmerge
          UPDATE fe_gene SET idle4=nsgtelectura
		Endtext
	Endcase
	q = 1
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	This.contransaccion = 'S'
	Select listaci
	Scan All
		If This.IngresalecturasContometros20(listaci.Surtidor, goApp.IDturno, listaci.lectura, listaci.Monto, fe_gene.fech, goApp.nidusua, listaci.Codigo, listaci.lado, listaci.Precio, nsgtelectura) < 1 Then
			q = 0
			Exit
		Endif
	Endscan
	If q = 1 Then
		If This.GRabarCambios() < 1 Then
			Return 0
		Endif
		Return 1
	Else
		This.DEshacerCambios()
		Return 0
	Endif
	Endfunc
	Function consultarxislaturno(Calias, nisla, nturno)
	lC = 'ProListarlecturasrealesxisla'
	goApp.npara1 = nisla
	Text To lp Noshow
	     (?goapp.npara1)
	Endtext
	If This.EJECUTARP10(lC, lp, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ConsultarLecturasxfechas(dfi, dff, nisla, Calias)
	If (dff - dfi) > 31 Then
		This.Cmensaje = 'Máximo a consultar es 30 Días'
		Return 0
	Endif
	fi = Cfechas(dfi)
	ff = Cfechas(dff)
	This.conconexion = 1
	lC = "ProListarDespachosh"
	Text To lp Noshow  Textmerge
	('<<fi>>','<<ff>>',<<nisla>>)
	Endtext
	If This.EJECUTARP10(lC, lp, Calias) < 1 Then
		Return 0
	Endif
	This.conconexion = 0
	Return 1
	Endfunc
	Function listarlecturasincio(Df, nturno, Calias)
	F = Cfechas(Df)
	Text To lC Noshow Textmerge
	SELECT lect_inic AS lectura_galon,lect_inim as montoi,descri AS producto,lect_mang AS manguera,lect_idco AS surtidor,
	lect_prec as Precio,lect_idar AS codigo,u.nomb as Cajero,lect_idtu as turno,lect_idle as Idlecturas,lect_fope as InicioTurno,
	lect_fope1 as FinTurno FROM fe_lecturas AS l
	INNER JOIN fe_art AS a ON a.idart=l.lect_idar
	inner join fe_usua as u on u.idusua=l.lect_idus
	WHERE lect_acti='A' and lect_esta='A' and lect_fech='<<f>>'
	Endtext
	This.conconexion = 1
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		This.conconexion = 0
		Return 0
	Endif
	This.conconexion = 0
	Return 1
	Endfunc
	Function consultarlecturasreales(Calias)
	lC = 'ProListarlecturasreales'
	lp = ""
	If This.EJECUTARP10(lC, lp, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function cierrelecturas(nidt, Df)
	xq = 1
	If goApp.IDturno = 1 Then
		Nsgte = 2
	Else
		Nsgte = 1
	Endif
	nsgtelectura = goApp.Idlecturas + 1
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	Do Case
	Case goApp.Isla = 1
		Text To lcx Noshow Textmerge
          UPDATE fe_gene  SET idle1=<<nsgtelectura>>
		Endtext
	Case goApp.Isla = 2
		Text To lcx Noshow Textmerge
          UPDATE fe_gene  SET idle2=<<nsgtelectura>>
		Endtext
	Case goApp.Isla = 3
		Text To lcx Noshow Textmerge
          UPDATE fe_gene   SET idle3=<<nsgtelectura>>
		Endtext
	Case goApp.Isla = 4
		Text To lcx Noshow Textmerge
          UPDATE fe_gene SET idle4=<<nsgtelectura>>
		Endtext
	Endcase
	If  This.Ejecutarsql(lcx) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select liq
	Go Top
	Scan All
		If This.IngresalecturasFinalContometros20(liq.Idlecturas, liq.Final, liq.montofinal, goApp.nidusua, 0) < 1 Then
			xq = 0
			Exit
		Endif
		If fe_gene.nruc = '20609310902' Then
			Do Case
			Case liq.Surtidor = 1 Or  liq.Surtidor = 2 Or liq.Surtidor = 3 Or  liq.Surtidor = 4
				nislax = 1
			Case liq.Surtidor = 5 Or  liq.Surtidor = 6 Or liq.Surtidor = 7 Or  liq.Surtidor = 8
				nislax = 2
			Endcase
		Else
			Do Case
			Case liq.Surtidor = 1 Or  liq.Surtidor = 2
				nislax = 1
			Case liq.Surtidor = 3 Or  liq.Surtidor = 4
				nislax = 2
			Case liq.Surtidor = 5 Or  liq.Surtidor = 6 Or liq.Surtidor = 7 Or  liq.Surtidor = 8
				nislax = 3
			Endcase
		Endif
		Select islas
		Locate For Isla = nislax
		nidux = islas.Idusua
		If  This.IngresalecturasContometros20(liq.Surtidor, Nsgte, liq.Final, liq.montofinal, Df, nidux, liq.Codigo, liq.Manguera, liq.Precio, nsgtelectura) < 1 Then
			xq = 0
			Exit
		Endif
		Select liq
	Endscan
	If xq = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.motivocierre = 'C' Then
		Do Case
		Case goApp.Isla = 1
			Text To lC Noshow Textmerge
          UPDATE fe_gene SET idtu1=<<nsgte>>
			Endtext
		Case goApp.Isla = 2
			Text To lC Noshow Textmerge
          UPDATE fe_gene SET idtu2=<<nsgte>>
			Endtext
		Case goApp.Isla = 3
			Text To lC Noshow Textmerge
          UPDATE fe_gene SET idtu3=<<nsgte>>
			Endtext
		Endcase
		If  This.Ejecutarsql(lC) < 1 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If This.GRabarCambios() = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresalecturasFinalContometros20(np1, np2, np3, np4, np5)
	lC = 'PROINGRESALECTURAFINAL'
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
	Endtext
	If EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ConsultarCierreslecturas(dfi, dff, Calias)
	If (dff - dfi) > 31 Then
		This.Cmensaje = 'Máximo a consultar es 30 Días'
		Return 0
	Endif
	fi = Cfechas(dfi)
	ff = Cfechas(dff)
	Text To lC Noshow Textmerge
	SELECT descri AS producto,lect_cfinal as final,lect_inic AS inicial,lect_cfinal-lect_inic as cantidad,lect_prec as Precio,
	Round((lect_cFinal-lect_inic)*lect_prec,2) As Ventas,
	lect_mfinal as montofinal,lect_inim as montoinicial,lect_mfinal-lect_inim as monto,lect_mang AS manguera,lect_idco AS surtidor,
	u.nomb as Cajero,lect_fope as InicioTurno,lect_fope1 as FinTurno,lect_idtu as turno,lect_idle as Idlecturas,lect_idar AS codigo
	FROM fe_lecturas AS l
	INNER JOIN fe_art AS a ON a.idart=l.lect_idar
	inner join fe_usua as u on u.idusua=l.lect_idus
	WHERE lect_acti='A'  and lect_idin=<<this.nidlectura>>  and lect_fech='<<fi>>'  order by u.nomb,descri,lect_idco
	Endtext
	This.conconexion = 1
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		This.conconexion = 0
		Return 0
	Endif
	This.conconexion = 0
	Return 1
	Endfunc
	Function obteneractiva(dFecha, nturno, nisla)
	Df = Cfechas(dFecha)
	Ccursor = 'c_' + Sys(2015)
	Do Case
	Case nisla = 1
		If fe_gene.nruc = '20609310902' Then
			Text To lC Noshow Textmerge
	          SELECT lect_idin as idin FROM fe_lecturas WHERE lect_fech='<<df>>' AND lect_esta='A' AND lect_idco IN(1,2,3,4) GROUP BY lect_idin limit 1
			Endtext
		Else
			Text To lC Noshow Textmerge
	         SELECT lect_idin as idin FROM fe_lecturas WHERE lect_fech='<<df>>' AND lect_esta='A' AND lect_idco IN(1,2) GROUP BY lect_idin limit 1
			Endtext
		Endif
	Case nisla = 2
		If fe_gene.nruc = '20609310902' Then
			Text To lC Noshow Textmerge
	         SELECT lect_idin as idin FROM fe_lecturas WHERE lect_fech='<<df>>' AND lect_esta='A' AND lect_idco IN(5,6,7,8) GROUP BY lect_idin limit 1
			Endtext
		Else
			Text To lC Noshow Textmerge
	          SELECT lect_idin as idin FROM fe_lecturas WHERE lect_fech='<<df>>' AND lect_esta='A' AND lect_idco IN(3,4) GROUP BY lect_idin limit 1
			Endtext
		Endif
	Case nisla = 3
		Text To lC Noshow Textmerge
	    SELECT lect_idin as idin FROM fe_lecturas WHERE lect_fech='<<df>>' AND lect_esta='A' AND lect_idco IN(5,6,7,8) GROUP BY lect_idin limit 1
		Endtext
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return - 1
	Endif
	Select (Ccursor)
	If idin > 0 Then
		Return idin
	Else
		This.Cmensaje = "No hay Lecturas Registradas"
		Return 0
	Endif
	Endfunc
	Function obtenerlecturas(dFecha, nturno, nisla, Ccursor)
	Df = Cfechas(dFecha)
	Do Case
	Case nisla = 1
		If fe_gene.nruc = '20609310902' Then
			Text To lC Noshow Textmerge
	          SELECT  CONCAT(CAST(lect_idtu AS CHAR),'-',CAST(lect_idin AS CHAR)) as lectura,lect_idin as idin FROM fe_lecturas WHERE lect_fech='<<df>>' AND lect_acti='A' AND lect_idco IN(1,2,3,4) GROUP BY lect_idin,lect_idtu
			Endtext
		Else
			Text To lC Noshow Textmerge
	        SELECT  CONCAT(CAST(lect_idtu AS CHAR),'-',CAST(lect_idin AS CHAR)) as lectura,lect_idin as idin FROM fe_lecturas WHERE lect_fech='<<df>>' AND lect_acti='A' AND lect_idco IN(1,2) GROUP BY lect_idin,lect_idtu
			Endtext
		Endif
	Case nisla = 2
		If fe_gene.nruc = '20609310902' Then
			Text To lC Noshow Textmerge
	         SELECT  CONCAT(CAST(lect_idtu AS CHAR),'-',CAST(lect_idin AS CHAR)) as lectura,lect_idin as idin FROM fe_lecturas WHERE lect_fech='<<df>>' AND lect_acti='A' AND lect_idco IN(3,4,5,6) GROUP BY lect_idin,lect_idtu
			Endtext
		Else
			Text To lC Noshow Textmerge
	    SELECT  CONCAT(CAST(lect_idtu AS CHAR),'-',CAST(lect_idin AS CHAR)) as lectura,lect_idin as idin FROM fe_lecturas WHERE lect_fech='<<df>>' AND lect_acti='A' AND lect_idco IN(3,4) GROUP BY lect_idin,lect_idtu
			Endtext
		Endif
	Case nisla = 3
		Text To lC Noshow Textmerge
	    SELECT  CONCAT(CAST(lect_idtu AS CHAR),'-',CAST(lect_idin AS CHAR)) as lectura,lect_idin as idin FROM fe_lecturas WHERE lect_fech='<<df>>' AND lect_acti='A' AND lect_idco IN(5,6,7,8) GROUP BY lect_idin,lect_idtu
		Endtext
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	Return 1
	Endfunc
Enddefine









