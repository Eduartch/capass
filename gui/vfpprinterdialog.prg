Define Class VFPPrinterDialog As Form

	BorderStyle = 2
	Height = 295
	Width = 472
	Desktop = .T.
	DoCreate = .T.
	AutoCenter = .T.
	Caption = "Impresoras"
	ControlBox = .F.
	Closable = .F.
	MaxButton = .F.
	MinButton = .F.
	WindowType = 1
	numerodeimpresora = 1
	returnvalue = .Null.
	oldprinterdefault = ""
	Name = "impresoras"

*!*	*-- En ésta propiedad se almacenarán las Impresoras Instaladas. El vector
*!*		está formado por Dos columnas, la primera almacena el Nombre de la Impresora
*!*		Y la seguna el Puerto de Impresión de la misma.
	Dimension gaprinters[1,2]


	Add Object seleccionarimpresora As Shape With ;
		Top = 18, ;
		Left = 9, ;
		Height = 106, ;
		Width = 455, ;
		BackStyle = 1, ;
		Curvature = 6, ;
		Style = 3, ;
		Name = "SeleccionarImpresora"


	Add Object lblseleccionarimpresora As Label With ;
		AutoSize = .F., ;
		FontName = "Microsoft Sans Serif", ;
		FontSize = 8, ;
		Caption = "Seleccionar Impresora", ;
		Height = 17, ;
		Left = 30, ;
		Top = 11, ;
		Width = 104, ;
		TabIndex = 1, ;
		Name = "lblSeleccionarImpresora"


	Add Object lblpuerto As Label With ;
		AutoSize = .T., ;
		FontName = "Microsoft Sans Serif", ;
		FontSize = 8, ;
		Caption = "Puerto:", ;
		Height = 15, ;
		Left = 22, ;
		Top = 62, ;
		Width = 36, ;
		TabIndex = 4, ;
		Name = "lblPuerto"


	Add Object txtpuerto As TextBox With ;
		FontName = "Microsoft Sans Serif", ;
		FontSize = 8, ;
		BackStyle = 0, ;
		BorderStyle = 0, ;
		ControlSource = "ThisForm.gaPrinters[ThisForm.NumerodeImpresora,2]", ;
		Height = 17, ;
		Left = 88, ;
		TabIndex = 5, ;
		Top = 60, ;
		Width = 259, ;
		Name = "txtPuerto"


	Add Object lblubicacion As Label With ;
		AutoSize = .T., ;
		FontName = "Microsoft Sans Serif", ;
		FontSize = 8, ;
		Caption = "Ubicación", ;
		Height = 15, ;
		Left = 22, ;
		Top = 80, ;
		Width = 50, ;
		TabIndex = 6, ;
		Name = "lblUbicacion"


	Add Object txtubicacion As TextBox With ;
		FontName = "Microsoft Sans Serif", ;
		FontSize = 8, ;
		BackStyle = 0, ;
		BorderStyle = 0, ;
		ControlSource = "ThisForm.gaPrinters[ThisForm.NumerodeImpresora,5]", ;
		Height = 17, ;
		Left = 88, ;
		TabIndex = 7, ;
		Top = 78, ;
		Width = 259, ;
		Name = "txtUbicacion"


	Add Object lblcomentario As Label With ;
		AutoSize = .T., ;
		FontName = "Microsoft Sans Serif", ;
		FontSize = 8, ;
		Caption = "Comentario:", ;
		Height = 15, ;
		Left = 22, ;
		Top = 98, ;
		Width = 58, ;
		TabIndex = 8, ;
		Name = "lblComentario"


	Add Object txtcomentario As TextBox With ;
		FontName = "Microsoft Sans Serif", ;
		FontSize = 8, ;
		BackStyle = 0, ;
		BorderStyle = 0, ;
		ControlSource = "ThisForm.gaPrinters[ThisForm.NumerodeImpresora,4]", ;
		Height = 17, ;
		Left = 88, ;
		TabIndex = 9, ;
		Top = 96, ;
		Width = 259, ;
		Name = "txtComentario"


	Add Object cboimpresoras As ComboBox With ;
		FontName = "Microsoft Sans Serif", ;
		FontSize = 8, ;
		RowSourceType = 5, ;
		RowSource = "ThisForm.gaPrinters", ;
		Value = ( 1), ;
		ControlSource = "ThisForm.NumerodeImpresora", ;
		Height = 22, ;
		Left = 23, ;
		Style = 2, ;
		TabIndex = 2, ;
		Top = 29, ;
		Width = 428, ;
		Name = "cboImpresoras"


	Add Object cmdadvanced As CommandButton With ;
		Top = 73, ;
		Left = 368, ;
		Height = 27, ;
		Width = 84, ;
		FontName = "Microsoft Sans Serif", ;
		FontSize = 8, ;
		Caption = "\<Avanzadas", ;
		TabIndex = 3, ;
		Name = "cmdAdvanced"


	Add Object paginas As Shape With ;
		Top = 150, ;
		Left = 9, ;
		Height = 93, ;
		Width = 221, ;
		BackStyle = 1, ;
		Curvature = 6, ;
		Style = 3, ;
		Name = "Paginas"


	Add Object lblintervalos As Label With ;
		AutoSize = .F., ;
		FontName = "Microsoft Sans Serif", ;
		FontSize = 8, ;
		Caption = "Páginas - Intérvalo", ;
		Height = 17, ;
		Left = 22, ;
		Top = 143, ;
		Width = 104, ;
		TabIndex = 10, ;
		Name = "lblIntervalos"


	Add Object optionpages As OptionGroup With ;
		AutoSize = .T., ;
		ButtonCount = 2, ;
		BackStyle = 0, ;
		BorderStyle = 0, ;
		Value = 1, ;
		Height = 46, ;
		Left = 18, ;
		Top = 160, ;
		Width = 71, ;
		TabIndex = 11, ;
		Name = "OptionPages", ;
		Option1.FontName = "Microsoft Sans Serif", ;
		Option1.FontSize = 8, ;
		Option1.Caption = "Todo", ;
		Option1.Value = 1, ;
		Option1.Height = 15, ;
		Option1.Left = 5, ;
		Option1.Top = 5, ;
		Option1.Width = 43, ;
		Option1.AutoSize = .T., ;
		Option1.Name = "Option1", ;
		Option2.FontName = "Microsoft Sans Serif", ;
		Option2.FontSize = 8, ;
		Option2.Caption = "Páginas", ;
		Option2.Height = 17, ;
		Option2.Left = 5, ;
		Option2.Top = 24, ;
		Option2.Width = 61, ;
		Option2.Name = "Option2"


	Add Object txtpages As TextBox With ;
		FontName = "Microsoft Sans Serif", ;
		FontSize = 8, ;
		Height = 22, ;
		Left = 101, ;
		TabIndex = 12, ;
		Top = 182, ;
		Width = 112, ;
		Name = "txtPages"


	Add Object lbltypeintervalo As Label With ;
		AutoSize = .T., ;
		FontName = "Microsoft Sans Serif", ;
		FontSize = 8, ;
		WordWrap = .T., ;
		Caption = "Ingrese lo que desea imprimir, o bien una pagina sola o un	intérvalo. Ejemplo 4 - 6", ;
Height = 28, ;
Left = 22, ;
Top = 206, ;
Width = 194, ;
TabIndex = 13, ;
Name = "lbltypeintervalo"


	Add Object copias As Shape With ;
		Top = 151, ;
		Left = 243, ;
		Height = 93, ;
		Width = 221, ;
		BackStyle = 0, ;
		Curvature = 6, ;
		SpecialEffect = 0, ;
		Style = 3, ;
		Name = "Copias"


	Add Object lbltitlecopias As Label With ;
		AutoSize = .T., ;
		FontName = "Microsoft Sans Serif", ;
		FontSize = 8, ;
		Caption = "Copias", ;
		Height = 15, ;
		Left = 251, ;
		Top = 143, ;
		Width = 34, ;
		TabIndex = 14, ;
		Name = "lblTitleCopias"


	Add Object lblspncopies As Label With ;
		AutoSize = .T., ;
		FontName = "Microsoft Sans Serif", ;
		FontSize = 8, ;
		Caption = "Número de co\<pias", ;
		Height = 15, ;
		Left = 256, ;
		Top = 188, ;
		Width = 88, ;
		TabIndex = 15, ;
		Name = "lblspnCopies"


	Add Object spncopies As Spinner With ;
		FontName = "Microsoft Sans Serif", ;
		FontSize = 8, ;
		Height = 22, ;
		Left = 354, ;
		SpinnerLowValue = 1.00, ;
		TabIndex = 16, ;
		Top = 184, ;
		Width = 97, ;
		Value = 1, ;
		Name = "spnCopies"


	Add Object cmdaceptar As CommandButton With ;
		Top = 258, ;
		Left = 276, ;
		Height = 27, ;
		Width = 84, ;
		FontName = "Microsoft Sans Serif", ;
		FontSize = 8, ;
		Caption = "\<Aceptar", ;
		TabIndex = 17, ;
		Name = "cmdAceptar"


	Add Object cmdcancelar As CommandButton With ;
		Top = 258, ;
		Left = 368, ;
		Height = 27, ;
		Width = 84, ;
		Cancel = .T., ;
		FontName = "Microsoft Sans Serif", ;
		FontSize = 8, ;
		Caption = "\<Cancelar", ;
		TabIndex = 18, ;
		Name = "cmdCancelar"

	Procedure Load
	If File("PrnSetup.mem") = .F.
		Messagebox("El archivo de memoria PrnSetup.mem necesario para ejecutar la función no está o es inválido.")
		Return .F.
	Endif

	This.oldprinterdefault = Set("PRINTER", 3)

	Local nNroPrn, nCountPrns, nCurrArea, gaprinters[1,5], nCol

	nCurrArea = Select()

	Restore From PrnSetup.mem Additive

	Create Cursor FRXSetings From Array aPrnSetup

	Append Blank

	nCountPrns = Aprinters(gaprinters, 1)

	With This
		.numerodeimpresora = -1

		For nNroPrn = 1 To nCountPrns
			Declare .gaprinters[nNroPrn, 5]

			For nCol = 1 To 5
				.gaprinters[nNroPrn, nCol] = gaprinters[nNroPrn, nCol]
			Endfor

			If Upper(gaprinters[nNroPrn,1]) == Upper(.oldprinterdefault)
				.numerodeimpresora = nNroPrn
			Endif
		Endfor

		If .numerodeimpresora <> -1
			oData = SetVFPDefaultPrinter(gaprinters[.NumerodeImpresora,1])

			Replace Expr With oData.Expr Tag With oData.Tag TAG2 With oData.TAG2

			Sys(1037, 2)

			Set Printer To Name (gaprinters[.NumerodeImpresora,1])
		Else
			Messagebox("No hay impresoras Instaladas")
		Endif
	Endwith

	Select(nCurrArea)

	Return This.numerodeimpresora <> -1
	Endproc


	Procedure Destroy
	Set Printer To Name (This.oldprinterdefault)

	SetVFPDefaultPrinter(This.oldprinterdefault)

	Use In "FRXSetings"
	Endproc


	Procedure optionpages.Init
	This.Value = 1
	Endproc


	Procedure optionpages.ProgrammaticChange
	This.Valid()
	Endproc


	Procedure optionpages.Valid
	With Thisform.txtpages
		.Enabled = This.Value = 2
	Endwith
	Endproc


	Procedure cboimpresoras.ProgrammaticChange
	This.Valid()
	Endproc


	Procedure cboimpresoras.Valid
	Local cNamePrn

	cNamePrn = Thisform.gaprinters[This.Value,1]

	Set Printer To Name (cNamePrn)

	oDataPrn = SetVFPDefaultPrinter(cNamePrn)

	With oDataPrn
		Replace Expr With .Expr Tag With .Tag TAG2 With .TAG2 In "FRXSetings"
	Endwith

	Thisform.txtpuerto.Refresh()
	Thisform.txtubicacion.Refresh()
	Thisform.txtcomentario.Refresh()
	Endproc


	Procedure cboimpresoras.Init
	This.Value = Thisform.numerodeimpresora
	Endproc


	Procedure txtpuerto.When
	Return .F.
	Endproc


	Procedure txtubicacion.When
	Return .F.
	Endproc


	Procedure txtcomentario.When
	Return .F.
	Endproc


	Procedure cmdadvanced.Valid
	Local nCurrArea

	nCurrArea = Select()

	Select FRXSetings

	nResult = Val(Sys(1037, 1))

	If nResult = 1
		Sys(1037, 3)
	Endif

	Select(nCurrArea)
	Endproc


	Procedure cmdcancelar.Valid
	With Thisform
		.returnvalue = .Null.
		.Hide()
	Endwith
	Endproc


	Procedure cmdaceptar.Valid
	Local oFRXEnvironment, nCurrArea

	nCurrArea = Select()

	Select FRXSetings

	Scatter Name oFRXEnvironment Memo Fields Expr, Tag, TAG2

	AddProperty(oFRXEnvironment, "NamePrinter",
	Thisform.gaprinters[ThisForm.cboImpresoras.Value,1])
	AddProperty(oFRXEnvironment, "PageRange", Thisform.txtpages.Value)
	AddProperty(oFRXEnvironment, "Copies", Thisform.spncopies.Value)

	With Thisform
		.returnvalue = oFRXEnvironment
		.Hide()
	Endwith

	Select(nCurrArea)
	Endproc


Enddefine
*
