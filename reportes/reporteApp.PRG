Define Class reporteApp As ReportListener
	nFila = 0
	Procedure BeforeBand(tnBandObjCode, tnFRXRecno)
	This.nFila = This.nFila + 1
	Endproc
**
	Procedure EvaluateContents(tnFRXRecno, toProps)
*-- tnFRXRecno: número del registro en el archivo .FRX
*-- toProps   : propiedades del objeto
	With toProps
		.Reload = .T.
		If This.nFila % 2 = 0 Then     && Si es una fila par
			.FillRed   =   0
			.FillGreen = 255
			.FillBlue  =   0
			.FillAlpha = 128
		Endif
	Endwith
	Endproc
*
*
Enddefine
