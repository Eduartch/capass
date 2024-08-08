Local loForm As Form
Use (Home(2) + "Northwind\Customers")
loForm = Createobject("Form")
loForm.Caption = "Ejemplo de grid con orden por columna"
loForm.AddObject("MyGrid","MyGridOrd")
loForm.MyGrid.Order_Enabled = .T.
loForm.MyGrid.Order_All()
loForm.MyGrid.RecordSource = "Customers"
loForm.MyGrid.ReadOnly = .T.
loForm.MyGrid.Width = loForm.Width
loForm.MyGrid.Height = loForm.Height
loForm.MyGrid.Anchor = 15
loForm.MyGrid.Visible = .T.
loForm.WindowState = 2
loForm.MyGrid.AutoFit()
loForm.Show(1)


Define Class MyGridOrd As Grid
*-- Puntero actual al objeto Header
	Header = .F.
	HeaderHeight = 25
	GridLineColor=RGB(200,200,200)
	HighlightStyle=1
	HighlightForecolor=RGB(0,0,0)
	Fontname="Tahoma"
*-- Habilita el orden de las columnas
	Order_Enabled = .F.
	Name = "MyGridOrd"
	Procedure Order_Column
	Lparameters toColumn, tcField
	Local tcCaption, tlWordWrap
	Do Case
	Case Pemstatus(toColumn,"Header1",5)
		tcCaption = toColumn.Header1.Caption
		tlWordWrap = toColumn.Header1.WordWrap
		toColumn.RemoveObject('Header1')
	Case Pemstatus(toColumn,"MyHeader",5)
		tcCaption = toColumn.MyHeader.Caption
		tlWordWrap = toColumn.MyHeader.WordWrap
		toColumn.RemoveObject('MyHeader')
	Endcase
	toColumn.AddObject('MyHeader', 'MyHeaderOrd', tcField)
	toColumn.MyHeader.Caption = tcCaption
	toColumn.MyHeader.WordWrap = tlWordWrap
	Endproc
	Procedure Order_All
	Local lo, lc
	For Each lo In This.Columns
*-- No ordena las columnas que tengan algun valor en la propiedad TAG
		If Empty(lo.Tag)
			lc =  Substr(lo.ControlSource,At(".", lo.ControlSource) + 1)
*-- Quita los caracteres especiales del ControlSource
			lc = Chrtran(lc, ["'+-/*().,;], [])
			This.Order_Column(lo, lc)
		Endif
	Endfor
	Endproc
	Procedure Init
	DoDefault()
	If This.Order_Enabled
		This.Order_All()
	Endif
	Endproc
Enddefine

*------------------------------------------------------
* Clase Column y Header para ordenar las columnas
* de una Grilla con un Click en el Header
*------------------------------------------------------
Define Class MyColumnOrd As Column
*-- Nada
Enddefine

Define Class MyHeaderOrd As Header
	FontSize = 8
	FontBold = .T.
	Alignment = 2
	FontNAme="tahoma"
	nNoReg = 0
	cField = ""
	nOrder = 0
	cFieldType = "U"
	lCyclic = .F. && El orden pasa de ASC > DESC > NO ORDEN > ASC > Etc...
	Procedure Init(tcField)
	Local  ln1, ln2
	This.cField = Upper(tcField)
	ln1 = Afields(laFields, This.Parent.Parent.RecordSource)
	If ln1 > 0
		ln2 = Ascan(laFields, This.cField, -1, -1, 1, 11)
		If ln2 > 0
			This.cFieldType = laFields(ln2, 2)
		Endif
	Endif
	If Not Inlist(This.cFieldType, "U", "G", "M", "W")
		This.Picture = Locfile(Home(4) + "Bitmaps\Tlbr_w95\DELETE.BMP", "BMP")
		This.MousePointer = 15 && Mano
	Endif
	Endproc
	Procedure Click
	If Inlist(This.cFieldType, "U", "G", "M", "W")
*- No se puede ordenar estos tipos de campos
		Return
	Endif
	This.nNoReg = Min(Reccount(This.Parent.Parent.RecordSource), ;
		RECNO(This.Parent.Parent.RecordSource))
	If Vartype(This.Parent.Parent.Header) == "O" And !Isnull(This.Parent.Parent.Header)
		This.Parent.Parent.Header.Picture = Locfile(Home(4) + "Bitmaps\Tlbr_w95\DELETE.BMP", "BMP")
		If This.Parent.Parent.Header.cField <> This.cField
			This.Parent.Parent.Header.nOrder = 0
		Endif
	Endif
	Do Case
	Case This.nOrder = 0
*-- Sin Orden, pasa a ASCending
		If Ataginfo(laTag,"",This.Parent.Parent.RecordSource) > 0 And Ascan(laTag,This.cField,-1,-1,1,1) > 0
*-- Existe el TAG
		Else
			Local lcSetSafety
			lcSetSafety = Set("Safety")
			Set Safety Off
			Select (This.Parent.Parent.RecordSource)
			Execscript( "INDEX ON " + This.cField + " TO " + This.cField + " ADDITIVE")
			Set Safety &lcSetSafety
		Endif
		Execscript("SET ORDER TO " + This.cField + " IN " + This.Parent.Parent.RecordSource + " ASCENDING")
		This.Parent.Parent.Header = This
		This.Picture = Locfile(Home(4) + "Bitmaps\Tlbr_w95\SORTASC.BMP", "BMP")
	Case This.nOrder = 1
*-- Orden ASC, pasa a DESCending
		If Ataginfo(laTag,"",This.Parent.Parent.RecordSource) > 0 And Ascan(laTag,This.cField,-1,-1,1,1) > 0
*-- Existe el TAG
		Else
			Local lcSetSafety
			lcSetSafety = Set("Safety")
			Set Safety Off
			Select (This.Parent.Parent.RecordSource)
			Execscript( "INDEX ON " + tcField + " TO " + This.cField + " ADDITIVE")
			Set Safety &lcSetSafety
		Endif
		Execscript("SET ORDER TO " + This.cField + " IN " + This.Parent.Parent.RecordSource + " DESCENDING")
		This.Parent.Parent.Header = This
		This.Picture = Locfile(Home(4) + "Bitmaps\Tlbr_w95\SORTDES.BMP", "BMP")
	Case This.nOrder = 2 And This.lCyclic
*-- Orden DESC, pasa a Sin Orden
		Execscript("SET ORDER TO 0 IN " + This.Parent.Parent.RecordSource)
		This.Parent.Parent.Header = This
		This.Picture = Locfile(Home(4) + "Bitmaps\Tlbr_w95\DELETE.BMP", "BMP")
	Endcase
	This.nOrder = Mod(This.nOrder + 1, Iif(This.lCyclic,3,2))
	This.Parent.Parent.Refresh()
	If This.nNoReg > 0
		Go (This.nNoReg) In (This.Parent.Parent.RecordSource)
	Endif
	Endproc
	Procedure RightClick
	If Vartype(This.Parent.Parent.Header) <> "O"
*-- Sin orden
		Return
	Endif
*-- Con RightClick (Clic Derecho) quito cualquier orden
	This.nNoReg = Min(Reccount(This.Parent.Parent.RecordSource), ;
		RECNO(This.Parent.Parent.RecordSource))
	Execscript("SET ORDER TO 0 IN " + This.Parent.Parent.RecordSource)
	This.Parent.Parent.Header.nOrder = 0
	This.Parent.Parent.Header.Picture = Locfile(Home(4) + "Bitmaps\Tlbr_w95\DELETE.BMP", "BMP")
	This.Parent.Parent.Header = This
	This.Parent.Parent.Refresh()
	If This.nNoReg > 0
		Go (This.nNoReg) In (This.Parent.Parent.RecordSource)
	Endif
	Endproc
Enddefine
