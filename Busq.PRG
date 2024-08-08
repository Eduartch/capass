Local oForm
oForm = Newobject("Form1")
oForm.Show
Read Events
Return

Define Class Form1 As Form
	Height = 390
	Width = 770
	AutoCenter = .T.
	Caption = "Resultados de búsquedas claros"
	ShowTips = .T.
	_cSearch = ""

	Add Object grid1 As Grid With ;
		GRIDLINES = 0, Height = 328, Left = 10, Top = 50, Width = 750, ;
		GRIDLINES = 3, DeleteMark = .F., GridLineColor = Rgb(192,192,192) ,;
		FONTNAME = "Tahoma", FontSize = 8, ReadOnly = .T., Anchor = 15

	Add Object label1 As Label With ;
		TOP = 15, Left = 10, ;
		CAPTION = "Buscar", BackStyle = 0

	Add Object Text1 As TextBox With ;
		TOP = 10,Left = 55, Height = 23,Width = 300, Value = "", ;
		TOOLTIPTEXT = "Comience a escribir para buscar los registros coincidentes. " + ;
		"Doble clic para borrar la búsqueda"

	Procedure Load
	Set Talk Off
	Set Safety Off
	Close Databases All
	Select company, contact, Title ;
		FROM (Home(2)+"data\customer") ;
		WHERE .F. ;
		INTO Cursor junk1 Readwrite
	Endproc

	Procedure grid1.Init
	With This
		.RecordSourceType = 6
		.RecordSource = "junk1"
		.Column1.DynamicForeColor = "IIF(thisform._cSearch $ UPPER(company),RGB(220,0,0),RGB(0,0,0))"
		.Column2.DynamicForeColor = "IIF(thisform._cSearch $ UPPER(contact),RGB(220,0,0),RGB(0,0,0))"
		.Column3.DynamicForeColor = "IIF(thisform._cSearch $ UPPER(title),RGB(220,0,0),RGB(0,0,0))"
		.Column1.DynamicFontBold = "IIF(thisform._cSearch $ UPPER(company),.T.,.F.)"
		.Column2.DynamicFontBold = "IIF(thisform._cSearch $ UPPER(contact),.T.,.F.)"
		.Column3.DynamicFontBold = "IIF(thisform._cSearch $ UPPER(title),.T.,.F.)"
	Endwith
	Endproc

	Procedure Text1.DblClick
	This.Value = ""
	Zap In junk1
	Thisform.grid1.Refresh
	Endproc

	Procedure Text1.InteractiveChange
	Local lcSearch
	lcSearch = Upper(Alltrim(This.Value))
	Thisform._cSearch = m.lcSearch
	
	Select company, contact, Title ;
		FROM Home(2)+"data\customer" ;
		WHERE Upper(cust_id+company+contact+Title) Like "%"+m.lcSearch+"%" ;
		INTO Cursor junk2 NOFILTER

	Select junk1
	Zap In junk1
	Append From Dbf("Junk2")
	Go Top
	Thisform.grid1.Refresh
	Endproc

	Procedure Destroy
	Clear Events
	Endproc
Enddefine
