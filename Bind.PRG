Public oForm
oHandler = Createobject("myHandler")
oForm = Createobject("MyForm",oHandler)
oForm.Show()
Define Class myForm As Form
	Width = 400
	Height = 225
	Add Object myGrid As Grid With Width=400, Height=180, Top=5
	Add Object myCmdButton As CommandButton ;
		WITH Top=190, Left=40,Caption="Bind",;
		Height=30
	Procedure Init
	Lparameters toHandler
	This.AddProperty("oHandler",toHandler)
	Endproc
	Procedure Load
	Open Database (Home(2)+"\Data\TestData")
	Use customer
	Endproc
	Procedure Unload
	Use In "Customer"
	Close Databases All
	Endproc
	Procedure myCmdButton.Click
	Thisform.EnlazaEvento()
	Endproc
	Procedure EnlazaEvento
* Recorremos los Objetos contenidos en el Grid
	For Each loObjects In Thisform.myGrid.Objects
		For Each loControls In loObjects.Controls
			Do Case
			Case Upper(loControls.BaseClass)="HEADER"
** Enlazamos el evento Doble Click de los Headers
** Hacia un metodo del objeto Handler
				Bindevent(loControls,"DblClick",This.oHandler,"DobleClick")
			Case Upper(loControls.BaseClass)="TEXTBOX"
** Enlazamos el evento Doble Click de los textbox
** Hacia otro metodo del objeto Handler
				Bindevent(loControls,"DblClick",This.oHandler,"MuestraValor")
			Endcase
		Endfor
	Endfor
	Endproc
Enddefine
Define Class myHandler As Custom
	Procedure DobleClick
	Aevents(laEventos,0)
	Messagebox("Lllamado desde:"+laEventos[1].Parent.ControlSource)
	Endproc
	Procedure MuestraValor
	Aevents(laEventos,0)
	Messagebox(Evaluate(laEventos[1].ControlSource))
	Endproc
Enddefine
