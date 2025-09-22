Define Class importabancos As Custom
	cfilejson = ""
	Cmensaje = ""
	Function tocursorfromjson()
	Set Procedure To d:\Librerias\nfjsoncreate, d:\Librerias\nfcursortojson.prg, ;
		d:\Librerias\nfcursortoobject, d:\Librerias\nfJsonRead.prg, ;
		d:\Librerias\_.prg, d:\Librerias\nfjsontocursor Additive
	If File(This.cfilejson) Then
		If !Pemstatus(_Screen, 'nctatavtas', 5) Then
			AddProperty(_Screen, 'nctatavtas', '')
		Endif
		Create Cursor ctas(nro N(2), idcta N(8), Fecha d,nrop c(12),Detalle c(100), Importe N(12, 2), ncta c(15), Moneda c(1), Ndoc c(12))
		oJson = nfJsonRead(This.cfilejson)
		If Vartype(oJson) = 'O' Then
			For z = 1 To Alen(oJson.Array)
				dFecha = Ctod(Right(oJson.Array(z).Date, 2) + '/' + Substr(oJson.Array(z).Date, 6, 2) + '/' + Alltrim(Str(Year(Date()))))
				cdetalle = oJson.Array(z).Name
				m.nidcta = 0
				m.cncta=""
				coperacion=IIF(VARTYPE(Ojson.Array(z).operation)='N',ALLTRIM(STR(Ojson.Array(z).operation)),ALLTRIM(Ojson.Array(z).operation))
				nimporte = oJson.Array(z).Amount
				If nimporte > 0 Then
					cdetalle = 'POR LA COBRANZA'
					m.nidcta = fe_gene.idctat
					m.cncta = _Screen.nctatavtas
				Endif
				cndoc = Right("000000000000" + Alltrim(Str(z)), 12)
				Insert Into ctas(Fecha, nrop,Detalle, Importe, Ndoc,idcta,ncta)Values(dFecha, m.coperacion,cdetalle, nimporte, cndoc,m.nidcta,m.cncta)
			Next
		Endif
	Endif
	Endfunc
Enddefine





