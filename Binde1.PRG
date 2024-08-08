Public oForm1
oForm1 = Newobject("Form1")
Return
Define Class Form1 As Form
	Height = 90
	Width = 330
	Caption = "¿Puede Ud. mantener la ansiedad?"
	Name = "Form1"
	Add Object Command1 As CommandButton With ;
		TOP = 30, ;
		LEFT = 120, ;
		HEIGHT = 27, ;
		WIDTH = 80, ;
		CAPTION = "No!!!", ;
		NAME = "Command1"
	Procedure Init
* Cuando el usuario hace clic en el botón, se
* dispara el método QueryUnload() del formulario
	Bindevent(Thisform.Command1, 'Click', Thisform, 'QueryUnload')
	This.Show()
	Endproc
	Procedure QueryUnload
	Thisform.Release()
	Endproc
Enddefine
