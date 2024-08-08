Lparameters carchivo
Public oform1
oform1=Newobject("form1")
oform1.Show()
*oform1.showpdf("C:\Psys\Pdf\20479597139-08-FD01-00000090.Pdf")
oform1.showpdf(carchivo)
Return

Define Class form1 As Form

	AutoCenter = .T.
	Height = 520
	Width = 741
	Caption = "PDF Generado"
	Name = "Form1"
	Icon=Sys(5)+Sys(2003)+"\Graphics\Search.ico"
	BorderStyle=1
	Showwindow=1
    Maxbutton=.f.
	* PDF file name
	cPdfFileName = "=SPACE(0)"
	* How long to wait for PDF to load
	nPdfLoadTimeout = 30
	*Add Object txtpdfname As TextBox With ;
		Top = 471, Left = 108, Height = 23, Width = 492, ;
		ReadOnly = .T., Name = "txtPdfName"

	*Add Object command1 As CommandButton With ;
		Top = 469, Left = 623, Height = 27, Width = 84, ;
		Caption = "Abrir PDF", Name = "Command1"

	Add Object owb As OleControl With ;
		Top = 24, Left = 12, Height = 433, Width = 709, ;
		OleClass = "Shell.Explorer.2", Name = "oWB"

	*Add Object label1 As Label With ;
		Height = 17, Left = 15, Top = 474, Width = 75, ;
		Caption = "Nombre PDF", Name = "Label1"
	Procedure Refresh
		* Required in VFP8 and earlier to prevent an error
		Nodefault
	Endproc

	Procedure showpdf(carpdf)
		Local lnSeconds
		* Clear Web browser control by loading blank page
		Thisform.owb.Object.Navigate2("About:Blank")
		* Wait for load to complete
		lnSeconds = Seconds()
		Do While (Thisform.owb.Object.Busy Or Thisform.owb.Object.ReadyState <> 4) ;
				AND (Seconds() - lnSeconds) < This.nPdfLoadTimeout
			DoEvents
		Enddo

		* Load PDF
		Wait Window Nowait "Cargando PDF ..."
		Thisform.owb.Object.Navigate2(carpdf)
		* Wait for PDF to load
		lnSeconds = Seconds()
		Do While (Thisform.owb.Object.Busy Or Thisform.owb.Object.ReadyState <> 4) ;
				AND (Seconds() - lnSeconds) < This.nPdfLoadTimeout
			DoEvents
		Enddo
		Wait Clear

		* PDF display can be adjusted as shown in AdjustPdfView method
		*   Uncomment next line if you want to do that and add AdjustPdfView method to the form/class
		*This.AdjustPdfView()

	Endproc

	*Procedure command1.Click
		* Get PDF file name
	*	Thisform.cPdfFileName = Getfile("pdf")

		* Display the name in the textbox
	*	Thisform.txtpdfname.Value = "C:\Psys\Pdf\20479597139-08-FD01-00000090.Pdf"
	*	If Not Empty(Thisform.cPdfFileName)
			* Display PDF
	*		Thisform.showpdf()
	*	Endif
	*Endproc

Enddefine
Procedure AdjustPdfView
	* PDF control PEMs can only be accessed after it's loaded
	*  TRY...ENDTRY will prevent crash in case when it's not loaded
	Try
		loDoc = Thisform.owb.Object.Document
		With loDoc
			* PageMode:
			*	none — does not display bookmarks or thumbnails (default)
			* 	bookmarks — displays the document and bookmarks
			* 	thumbs — displays the document and thumbnails
			.setPageMode("none")

			* LayoutMode:
			*	DontCare — use the current user preference
			*	SinglePage — use single page mode (as it would have appeared in pre-Acrobat 3.0 viewers)
			*	OneColumn — use one-column continuous mode
			*	TwoColumnLeft — use two-column continuous mode with the first page on the left
			*	TwoColumnRight — use two-column continuous mode with the first page on the right
			.setLayoutMode("OneColumn")

			* ViewMode:
			*	Fit — Fits the entire page within the window both vertically and horizontally.
			*	FitH — Fits the entire width of the page within the window.
			.SetView("FitH")

			* Zoom %, overrides ViewMode and vise verse.
			.setZoom(50)

			* Toolbar On/Off
			.setShowToolbar(.F.)
			* Scrollbars On/Off
			.setShowScrollbars(.T.)
		Endwith
	Catch To oErr
	Finally
		loDoc = Null
	Endtry
Endproc
