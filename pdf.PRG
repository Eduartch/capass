This.AddObject("owb","oleControl","Shell.Explorer.2")

This.oWb.Top = 0

This.oWb.Left = 0

This.oWb.Width = Thisform.Width

This.oWb.Height = Thisform.Height

This.oWb.Visible = .T.

This.oWb.Anchor = 240

 

This.AddProperty("cPDFFileName","")

This.AddProperty("nPdfLoadTimeout",30)

 

* Get PDF file name

Thisform.cPdfFileName = Getfile("pdf")

 

* Display the name in the textbox

This.Caption = Thisform.cPdfFileName

If Not Empty(Thisform.cPdfFileName)

                * Display PDF

                Thisform.ShowPdf()

Endif

 

 

 

la función showpdf contiene:

 

Local lnSeconds

* Clear Web browser control by loading blank page

Thisform.oWB.Object.Navigate2("About:Blank")

* Wait for load to complete

lnSeconds = Seconds()

Do While (Thisform.oWB.Object.Busy Or Thisform.oWB.Object.ReadyState <> 4) ;

                               AND (Seconds() - lnSeconds) < This.nPdfLoadTimeout

                DoEvents

Enddo

 

* Load PDF

Wait Window Nowait "Cargando PDF ..."

Thisform.oWB.Object.Navigate2(Thisform.cPdfFileName)

* Wait for PDF to load

lnSeconds = Seconds()

Do While (Thisform.oWB.Object.Busy Or Thisform.oWB.Object.ReadyState <> 4) ;

                               AND (Seconds() - lnSeconds) < This.nPdfLoadTimeout

                DoEvents

Enddo

Wait Clear