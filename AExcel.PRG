Wait Window Nowait "Un momento por favor, exportando Resumen Compras ....!"
o_Excel=Createobject("excel")
*.- Intentamos crear el objeto Excel en la Clase y no lo consigue es que probablemente
*.- no esta el Excel instalado

If !o_Excel.crea_objeto()
	Messagebox("No se pudo crear el objeto Excel",16,"Error")
	Return .F.
Endif

*.- Creamos Libro
o_Excel.NuevoLibro()
*.- Cambiando Nombre a la Hoja
o_Excel.Nombre_Hoja("RES_REG_COMP")

*.- Cambiando el Ancho de cada Columna
o_Excel.ancho_columna("A:A",1.0)
o_Excel.ancho_columna("B:B",3.43)
o_Excel.ancho_columna("C:C",22.43)
o_Excel.ancho_columna("D:D",5.14)
o_Excel.ancho_columna("E:E",11.43)
o_Excel.ancho_columna("F:F",11.43)
o_Excel.ancho_columna("G:G",11.43)
o_Excel.ancho_columna("H:H",11.43)
o_Excel.ancho_columna("I:I",11.43)
o_Excel.ancho_columna("J:J",11.43)
o_Excel.ancho_columna("K:K",11.43)
o_Excel.ancho_columna("L:L",6.71)
o_Excel.ancho_columna("M:M",11.43)
o_Excel.ancho_columna("N:N",6.00)
o_Excel.ancho_columna("O:O",11.43)

*.- Tipo de Letra
o_Excel.cFontSize(8,"A1:U5")

*.- Colocado Titulo de Cabecera
o_Excel.iValor("Empresa: "+vp_Empresa,"B1")
o_Excel.iValor("Fecha: "+Dtoc(Date()),"N1")
o_Excel.iValor("Ruc: "+vp_NroRuc,"B2")
o_Excel.iValor("Hora: "+Time(),"N2")
o_Excel.iValor("RESUMEN REGISTRO COMPRAS","H1")
o_Excel.iValor(TIT001,"H2")
o_Excel.iValor(TIT002,"H3")
o_Excel.centro_varias(.T.,"H1:J1")
o_Excel.centro_varias(.T.,"H2:J2")
o_Excel.centro_varias(.T.,"H3:J3")
*.- Tipo de Letra
o_Excel.cFontSize(16,"H1:J1")
o_Excel.cFontSize(10,"H2:J2")
o_Excel.cFontSize(10,"H3:J3")
*.- Color Negrita
o_Excel.Negrita(.T.,"H1:J1")
o_Excel.Negrita(.T.,"H2:J2")
o_Excel.Negrita(.T.,"H3:J3")
*.- Colocando Titulos a las Columnas
o_Excel.iValor("Tipo Doc.","B4")
o_Excel.iValor("Descripción","C4")
o_Excel.iValor("% Igv","D4")
o_Excel.iValor("Adq.Grav.destinadas Ope.Grav. y/o Export.","E4")
o_Excel.iValor("B.Imponible","E5")
o_Excel.iValor("I.G.V","F5")
o_Excel.iValor("Adq.Grav.destinadas Ope.Grav.y/o Export. Ope.no Gravdas","G4")
o_Excel.iValor("B.Imponible","G5")
o_Excel.iValor("I.G.V","H5")
o_Excel.iValor("Adq.Grav.destinadas Ope. no Gravadas","I4")
o_Excel.iValor("B.Imponible","I5")
o_Excel.iValor("I.G.V","J5")
o_Excel.iValor("valor Adquisic. no Gravadas","K4")
o_Excel.iValor("I.S.C","L4")
o_Excel.iValor("Otros Tributos y Cragos que no forman la B.Imponible","M4")
o_Excel.iValor("Difer. Cambio","N4")
o_Excel.iValor("Importe Total","O4")

*.- Ancho de Fila
o_Excel.ancho_fila("4:4",26.25)
o_Excel.ancho_fila("5:5",29.25)
*.- Centra Titulos en cada Columna
o_Excel.Alinea("CENTRO","A4:U5")
*.-Color de la Fuenta
o_Excel.Color_Fuente(3,"A4:U5")
*.- Linea en Cabecera
o_Excel.Line_Frame("B4:O5")

*.- centra Varias celdas
o_Excel.centro_varias(.T.,"B4:B5") && Tipo Comprobante
o_Excel.centro_varias(.T.,"C4:C5") && Nombre Comporobante
o_Excel.centro_varias(.T.,"D4:D5") && % IGV
o_Excel.centro_varias(.T.,"E5:E5") && B.I (A)
o_Excel.centro_varias(.T.,"F5:F5") && IGV (A)
o_Excel.centro_varias(.T.,"G5:G5") && B.I (B)
o_Excel.centro_varias(.T.,"H5:H5") && IGV (B)
o_Excel.centro_varias(.T.,"I5:I5") && B.I (C)
o_Excel.centro_varias(.T.,"J5:J5") && IGV (C)
o_Excel.centro_varias(.T.,"E4:F4") && Op. Grabadas (A)
o_Excel.centro_varias(.T.,"G4:H4") && Op. Grabadas (B)
o_Excel.centro_varias(.T.,"I4:J4") && Op. Grabadas (C)

o_Excel.centro_varias(.T.,"K4:K5") && Valor no Grabadas
o_Excel.centro_varias(.T.,"L4:L5") && ISC
o_Excel.centro_varias(.T.,"M4:M5") && Otros Tributos
o_Excel.centro_varias(.T.,"N4:N5") && Diferencia Cambio
o_Excel.centro_varias(.T.,"O4:O5") && Total

*.- Linea en Cabecera
Store 0 To nBasImp_A, nBasImp_B, nBasImp_C, nImpexone, nRedond
Store 0 To nImpIgv_A, nImpIgv_B, nImpIgv_C, nImpISC, nOtrTrib, nTotDocu

Store 0 To tBasImp_A, tBasImp_B, tBasImp_C, tImpexone, tRedond
Store 0 To tImpIgv_A, tImpIgv_B, tImpIgv_C, tImpISC, tOtrTrib, tTotDocu

Select TMPRESUREGCOM
Go Top
nPorIgv = COM_PORIGV
nFila = 5
Do While !Eof()
	nFila= nFila + 1
	o_Excel.cFontSize(8,"A"+Alltrim(Str(nFila))+":"+"O"+Alltrim(Str(nFila)))
	o_Excel.Alinea("IZQUIERDA","B"+Alltrim(Str(nFila)))
	o_Excel.Tipo("Texto","B"+Alltrim(Str(nFila)))
	o_Excel.Tipo("Texto","C"+Alltrim(Str(nFila)))
	o_Excel.Tipo("Comma","D"+Alltrim(Str(nFila))+":"+"O"+Alltrim(Str(nFila)))
	If COM_PORIGV = nPorIgv
		o_Excel.iValor(COM_TIPDOC,"B"+Alltrim(Str(nFila)))
		o_Excel.iValor(COM_DESCRI,"C"+Alltrim(Str(nFila)))
		o_Excel.iValor(COM_PORIGV,"D"+Alltrim(Str(nFila)))
		o_Excel.iValor(COM_BIMP_A,"E"+Alltrim(Str(nFila)))
		o_Excel.iValor(COM_IIGV_A,"F"+Alltrim(Str(nFila)))
		o_Excel.iValor(COM_BIMP_B,"G"+Alltrim(Str(nFila)))
		o_Excel.iValor(COM_IIGV_B,"H"+Alltrim(Str(nFila)))
		o_Excel.iValor(COM_BIMP_C,"I"+Alltrim(Str(nFila)))
		o_Excel.iValor(COM_IIGV_C,"J"+Alltrim(Str(nFila)))
		o_Excel.iValor(COM_IMPEXO,"K"+Alltrim(Str(nFila)))
		o_Excel.iValor(COM_IMPSEL,"L"+Alltrim(Str(nFila)))
		o_Excel.iValor(COM_OTRTRI,"M"+Alltrim(Str(nFila)))
		o_Excel.iValor(COM_REDOND,"N"+Alltrim(Str(nFila)))
		o_Excel.iValor(COM_TOTDOC,"O"+Alltrim(Str(nFila)))
		nBasImp_A= nBasImp_A + COM_BIMP_A
		nBasImp_B= nBasImp_B + COM_BIMP_B
		nBasImp_C= nBasImp_C + COM_BIMP_C
		nImpexone= nImpexone + COM_IMPEXO
		nImpIgv_A= nImpIgv_A + COM_IIGV_A
		nImpIgv_B= nImpIgv_B + COM_IIGV_B
		nImpIgv_C= nImpIgv_C + COM_IIGV_C
		nImpISC = nImpISC + COM_IMPSEL
		nOtrTrib = nOtrTrib + COM_OTRTRI
		nRedond = nRedond + COM_REDOND
		nTotDocu = nTotDocu + COM_TOTDOC

		tBasImp_A= tBasImp_A + COM_BIMP_A
		tBasImp_B= tBasImp_B + COM_BIMP_B
		tBasImp_C= tBasImp_C + COM_BIMP_C
		tImpexone= tImpexone + COM_IMPEXO
		tImpIgv_A= tImpIgv_A + COM_IIGV_A
		tImpIgv_B= tImpIgv_B + COM_IIGV_B
		tImpIgv_C= tImpIgv_C + COM_IIGV_C
		tImpISC = tImpISC + COM_IMPSEL
		tOtrTrib = tOtrTrib + COM_OTRTRI
		tRedond = tRedond + COM_REDOND
		tTotDocu = tTotDocu + COM_TOTDOC
		Skip
	Else
		o_Excel.iValor("Sub Total: ","C"+Alltrim(Str(nFila)))
		o_Excel.iValor(nBasImp_A,"E"+Alltrim(Str(nFila)))
		o_Excel.iValor(nImpIgv_A,"F"+Alltrim(Str(nFila)))
		o_Excel.iValor(nBasImp_B,"G"+Alltrim(Str(nFila)))
		o_Excel.iValor(nImpIgv_B,"H"+Alltrim(Str(nFila)))
		o_Excel.iValor(nBasImp_C,"I"+Alltrim(Str(nFila)))
		o_Excel.iValor(nImpIgv_C,"J"+Alltrim(Str(nFila)))
		o_Excel.iValor(nImpexone,"K"+Alltrim(Str(nFila)))
		o_Excel.iValor(nImpISC,"L"+Alltrim(Str(nFila)))
		o_Excel.iValor(nOtrTrib ,"M"+Alltrim(Str(nFila)))
		o_Excel.iValor(nRedond,"N"+Alltrim(Str(nFila)))
		o_Excel.iValor(nTotDocu,"O"+Alltrim(Str(nFila)))

		o_Excel.Tipo("Comma","E"+Alltrim(Str(nFila))+":"+"O"+Alltrim(Str(nFila)))
		o_Excel.cFontSize(8,"A"+Alltrim(Str(nFila))+":"+"O"+Alltrim(Str(nFila+3)))
		o_Excel.Negrita(.T.,"A"+Alltrim(Str(nFila))+":"+"O"+Alltrim(Str(nFila)))
		Store 0 To nBasImp_A, nBasImp_B, nBasImp_C, nImpexone, nRedond
		Store 0 To nImpIgv_A, nImpIgv_B, nImpIgv_C, nImpISC, nOtrTrib, nTotDocu
		nFila = nFila + 1
		nPorIgv= COM_PORIGV
	Endi
Enddo
nFila= nFila + 1
If nTotDocu != tTotDocu
	o_Excel.iValor("Sub Total: ","B"+Alltrim(Str(nFila)))
Else
	o_Excel.iValor("Total General","B"+Alltrim(Str(nFila)))
Endi
o_Excel.iValor(nBasImp_A,"E"+Alltrim(Str(nFila)))
o_Excel.iValor(nImpIgv_A,"F"+Alltrim(Str(nFila)))
o_Excel.iValor(nBasImp_B,"G"+Alltrim(Str(nFila)))
o_Excel.iValor(nImpIgv_B,"H"+Alltrim(Str(nFila)))
o_Excel.iValor(nBasImp_C,"I"+Alltrim(Str(nFila)))
o_Excel.iValor(nImpIgv_C,"J"+Alltrim(Str(nFila)))
o_Excel.iValor(nImpexone,"K"+Alltrim(Str(nFila)))
o_Excel.iValor(nImpISC,"L"+Alltrim(Str(nFila)))
o_Excel.iValor(nOtrTrib ,"M"+Alltrim(Str(nFila)))
o_Excel.iValor(nRedond,"N"+Alltrim(Str(nFila)))
o_Excel.iValor(nTotDocu,"O"+Alltrim(Str(nFila)))

o_Excel.Tipo("Comma","E"+Alltrim(Str(nFila))+":"+"O"+Alltrim(Str(nFila+3)))
o_Excel.cFontSize(8,"A"+Alltrim(Str(nFila))+":"+"O"+Alltrim(Str(nFila+3)))
o_Excel.Negrita(.T.,"A"+Alltrim(Str(nFila))+":"+"O"+Alltrim(Str(nFila+3)))
If nTotDocu != tTotDocu
	nFila = nFila + 1
	o_Excel.iValor("Total General","K"+Alltrim(Str(nFila)))
	o_Excel.iValor(tBasImp_A,"E"+Alltrim(Str(nFila)))
	o_Excel.iValor(tImpIgv_A,"F"+Alltrim(Str(nFila)))
	o_Excel.iValor(tBasImp_B,"G"+Alltrim(Str(nFila)))
	o_Excel.iValor(tImpIgv_B,"H"+Alltrim(Str(nFila)))
	o_Excel.iValor(tBasImp_C,"I"+Alltrim(Str(nFila)))
	o_Excel.iValor(tImpIgv_C,"J"+Alltrim(Str(nFila)))
	o_Excel.iValor(tImpexone,"K"+Alltrim(Str(nFila)))
	o_Excel.iValor(tImpISC,"L"+Alltrim(Str(nFila)))
	o_Excel.iValor(tOtrTrib ,"M"+Alltrim(Str(nFila)))
	o_Excel.iValor(tRedond,"N"+Alltrim(Str(nFila)))
	o_Excel.iValor(tTotDocu,"O"+Alltrim(Str(nFila)))
	o_Excel.Line_Fill("E"+Alltrim(Str(nFila))+":"+"O"+Alltrim(Str(nFila)))
Endi
*.- Abrimos Archivo Excel
o_Excel.excel.Visible=.T.
Return
