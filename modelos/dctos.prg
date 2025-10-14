Define Class dctos As OData Of "d:\capass\database\data.prg"
	idcodigo=0
	descdcto=""
	codigosunat=""
	Function mostrarvtasf(Ccursor)
	Dimension dct[3, 3]
	dct[1, 1] = 'FACTURA     '
	dct[1, 2] = '01'
	dct[1, 3] = 1
	dct[2, 1] = 'BOLETA      '
	dct[2, 2] = '03'
	dct[2, 3] = 2
	dct[3, 1] = 'NOTAS-VENTAS'
	dct[3, 2] = '20'
	dct[3, 3] = 3
	Create Cursor (Ccursor) (nomb c(10), Tdoc c(2), idtdoc N(2))
	Insert Into (Ccursor) From Array dct
	Return 1
	Endfunc
	Function mostrarvtasf2(Ccursor)
	Dimension dct[3, 3]
	dct[1, 1] = 'FACTURA     '
	dct[1, 2] = '01'
	dct[1, 3] = 1
	dct[2, 1] = 'BOLETA      '
	dct[2, 2] = '03'
	dct[2, 3] = 2
	dct[3, 1] = 'OTROS'
	dct[3, 2] = '00'
	dct[3, 3] = 3
	Create Cursor (Ccursor) (nomb c(10), Tdoc c(2), idtdoc N(2))
	Insert Into (Ccursor) From Array dct
	Return 1
	Endfunc
	Function mostrarvtasregistro(Ccursor)
	Dimension dct[4, 4]
	dct[1, 1] = 'FACTURA     '
	dct[1, 2] = '01'
	dct[1, 3] = 1
	dct[2, 1] = 'BOLETA      '
	dct[2, 2] = '03'
	dct[2, 3] = 2
	dct[3, 1] = 'NOTAS CREDITO'
	dct[3, 2] = '07'
	dct[3, 3] = 3
	dct[4, 1] = 'NOTAS DEBITO'
	dct[4, 2] = '08'
	dct[4, 3] = 4
	Create Cursor (Ccursor) (nomb c(10), Tdoc c(2), idtdoc N(2))
	Insert Into (Ccursor) From Array dct
	Return 1
	Endfunc
	Function mostrartraspasos(Ccursor)
	Dimension dct[2, 3]
	dct[1, 1] = 'Guias Remision'
	dct[1, 2] = '09'
	dct[1, 3] = 1
	dct[2, 1] = 'Traspasos     '
	dct[2, 2] = 'TT'
	dct[2, 3] = 2
	Create Cursor (Ccursor) (nomb c(10), Tdoc c(2), idtdoc N(2))
	Insert Into (Ccursor) From Array dct
	Return 1
	Endfunc
	Function MuestraDctos(cb, Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	If Alltrim(goApp.datosdctos) <> 'S' Then
		If This.consultardata(cb, Ccursor) < 1 Then
			Return 0
		Endif
	Else
		cfilejson = Addbs(Sys(5) + Sys(2003)) + 'd' + Alltrim(Str(goApp.xopcion)) + '.json'
		Create Cursor b_dctos From Array cfieldsfetdoc
		If File(m.cfilejson) Then
			oResponse = nfJsonRead(m.cfilejson)
			If Vartype(m.oResponse) = 'O' Then
				For Each oRow In  oResponse.Array
					Insert Into b_dctos From Name oRow
				Endfor
				Select * From b_dctos Into Cursor (Ccursor)
			Else
				If This.consultardata(cb, Ccursor) < 1 Then
					Return 0
				Endif
			Endif
		Else
			If This.consultardata(cb, Ccursor) < 1 Then
				Return 0
			Endif
		Endif
	Endif
	Select (Ccursor)
	Return 1
	Endfunc
	Function mostrartvtas(Ccursor)
	Dimension dct[5, 4]
	dct[1, 1] = 'FACTURA     '
	dct[1, 2] = '01'
	dct[1, 3] = 1
	dct[2, 1] = 'BOLETA      '
	dct[2, 2] = '03'
	dct[2, 3] = 2
	dct[3, 1] = 'NOTAS CREDITO'
	dct[3, 2] = '07'
	dct[3, 3] = 3
	dct[4, 1] = 'NOTAS DEBITO'
	dct[4, 2] = '08'
	dct[4, 3] = 4
	dct[5, 1] = 'N/VENTAS'
	dct[5, 2] = '20'
	dct[5, 3] = 5
	Create Cursor (Ccursor) (nomb c(10), Tdoc c(2), idtdoc N(2))
	Insert Into (Ccursor) From Array dct
	Return 1
	Endfunc
	Function mostrarvtasf1(Ccursor)
	Dimension dct[4, 3]
	dct[1, 1] = 'FACTURA     '
	dct[1, 2] = '01'
	dct[1, 3] = 1
	dct[2, 1] = 'BOLETA      '
	dct[2, 2] = '03'
	dct[2, 3] = 2
	dct[3, 1] = 'NOTAS-VENTA'
	dct[3, 2] = '20'
	dct[3, 3] = 3
	dct[4, 1] = 'G.INTERNO'
	dct[4, 2] = 'GI'
	dct[4, 3] = 4
	Create Cursor (Ccursor) (nomb c(10), Tdoc c(2), idtdoc N(2))
	Insert Into (Ccursor) From Array dct
	Return 1
	Endfunc
	Function mostrarvtasinternas(Ccursor)
	Dimension dct[1, 3]
	dct[1, 1] = 'NOTAS-VENTA'
	dct[1, 2] = '20'
	dct[1, 3] = 1
	Create Cursor (Ccursor) (nomb c(10), Tdoc c(2), idtdoc N(2))
	Insert Into (Ccursor) From Array dct
	Return 1
	Endfunc
	Function consultardata(cb, Ccursor)
	lC = "PROMUESTRADCTOS"
	TEXT To lp Noshow Textmerge
       ('<<cb>>')
	ENDTEXT
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	nCount = Afields(cfieldsfetdoc)
	Select * From (Ccursor) Into Cursor a_dctos
	cdata = nfcursortojson(.T.)
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'd' + Alltrim(Str(goApp.xopcion)) + '.json'
	If File(m.rutajson) Then
		Delete File m.rutajson
	Endif
	Strtofile (cdata, rutajson)
	goApp.datosdctos = 'S'
	Return 1
	Endfunc
	Function InsertaDctos()
	If This.validar()<1 Then
		Return 0
	Endif
	lC="FUNCREADCTOS"
	goApp.npara1=This.descdcto
	goApp.npara2=This.codigosunat
	TEXT TO lp NOSHOW
	(?goapp.npara1,goapp.npara2)
	ENDTEXT
	nid=This.ejecutarf(lC,lp,'x')
	If nid<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function VerificaCodDcto(nid1,nid2)
	If nid2=0 Then
		TEXT TO lc NOSHOW
        SELECT COUNT(*) as x FROM fe_tdoc WHERE tdoc=?nid1 AND dcto_acti<>'I' GROUP BY idtdoc limit 1
		ENDTEXT
		If This.ejecutaconsulta(lC,'wd')<1 Then
			Return 0
		Endif
		If !Empty(wd.x) Then
			This.cmensaje="Ya Existe El Còdigo Registrado"
			Return 0
		Endif
	Else
		TEXT TO lc NOSHOW
      	  SELECT COUNT(*) as x FROM fe_tdoc WHERE idtdoc<>?nid2 AND dcto_acti<>'I' AND tdoc=?nid1 GROUP BY idtdoc limit 1
		ENDTEXT
		If This.ejecutaconsulta(lC,'wd')<1 Then
			Return 0
		Endif
		If !Empty(wd.x) Then
			This.cmensaje="Ya Existe El Còdigo Registrado"
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function validar()
	Do Case
	Case Empty(This.codigosunat)
		This.cmensaje="Ingrese Código de Documento"
		Return 0
	Case Len(Alltrim(This.descdcto))=0
		This.cmensaje="Ingrese Descripción de Documento"
		Return 0
	Case This.VerificaCodDcto(This.codigosunat,This.idcodigo)<1
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function EditarDctos()
	If This.validar()<1 Then
		Return 0
	Endif
	goApp.npara1=This.descdcto
	goApp.npara2=This.codigosunat
	goApp.npara3=This.idcodigo
	TEXT TO lp NOSHOW
	  UPDATE fe_tdoc SET tdoc=?gpapp.npara2,nomb=?goapp.npara1 WHERE idtdoc=?goapp.npara3
	ENDTEXT
	If This.ejecutarsql(lC)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine












