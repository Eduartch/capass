*******************************
Public oform1
oform1 = Newobject("form1")
oform1.Show
Return

Define Class form1 As Form
	Top = 0
	Left = 0
	Height = 190
	Width = 480
	DoCreate = .T.
	Caption = "Form1"
	Name = "Form1"

	Add Object combo1 As ComboBox With ;
		COMMENT = "", ;
		ROWSOURCETYPE = 2, ;
		HEIGHT = 25, ;
		INCREMENTALSEARCH = .T., ;
		LEFT = 30, ;
		SELECTONENTRY = .T., ;
		TABINDEX = 2, ;
		TOP = 28, ;
		WIDTH = 350, ;
		INPUTMASK = "", ;
		NAME = "Combo1"

	Add Object label4 As Label With ;
		AUTOSIZE = .T., ;
		FONTBOLD = .T., ;
		BACKSTYLE = 0, ;
		CAPTION = "Uno de la lista o nuevo, desplegado", ;
		HEIGHT = 17, ;
		LEFT = 30, ;
		TOP = 12, ;
		WIDTH = 207, ;
		TABINDEX = 4, ;
		FORECOLOR = Rgb(88,99,124), ;
		NAME = "Label4"

	Add Object command1 As CommandButton With ;
		TOP = 12, ;
		LEFT = 408, ;
		HEIGHT = 36, ;
		WIDTH = 49, ;
		CAPTION = "Salir", ;
		TABINDEX = 3, ;
		NAME = "Command1"

	Procedure Load
	Capslock(.F.) && simulo trabajar con minusculas
	Public mf
	mf = Sys(2015)
	Open Database (Home(2) + "Northwind\Northwind.dbc")
	Select 0
	Use Customers
	Endproc

	Procedure combo1.Init
* Creo propiedad para almacenar configuracion CapsLock
	If Pemstatus(This,'lCaps',5) = .F.
		With This
			.AddProperty('lCaps',.F.)
		Endwith
	Endif
	This.Comment = ''
	Endproc

	Procedure combo1.KeyPress
	Lparameters nKeyCode, nShiftAltCtrl
	If Between(nKeyCode, 32, 122)
* Primero comprueba la lista
		For X=1 To This.ListCount
			If Upper(Substr(This.List(X), 1, This.SelStart+1)) == ;
					UPPER(Substr(This.Text, 1, This.SelStart)+Chr(nKeyCode))
				NCURPOS = This.SelStart + 1
				This.Value = This.List(X)
				This.SelStart = NCURPOS
				This.SelLength = Len(Ltrim(This.List(X))) - NCURPOS
				This.Comment = Substr(This.List(X),1,NCURPOS)
				Nodefault
				Exit
			Endif
		Next X
* Si no está en la lista
		If X > This.ListCount
			NCURPOS = Len(This.Comment) + 1
			This.Comment = This.Comment + Chr(nKeyCode)
			This.DisplayValue = This.Comment
			This.SelStart = NCURPOS
			Nodefault
		Endif
	Endif
* Si pulsamos Retroceso o flecha izda.
	If nKeyCode = 127 Or nKeyCode = 19
		NCURPOS = Len(This.Comment) -1
		This.Comment = Left(This.Comment, NCURPOS)
		This.DisplayValue = This.Comment
		This.SelStart = NCURPOS
		Nodefault
	Endif
	If nKeyCode = 13
		This.LostFocus
	Endif
	Endproc

	Procedure combo1.LostFocus
	This.RowSource = ''
	Use In Select('curcombo')
* Devolvemos config. inicial CapsLock
	Capslock(This.lcaps)
* Tiempo busqueda incremental predeterminado
	_Incseek = 0.5
*
*  El dato introducido / seleccionado, se encuentra
*  en la propiedad 'DisplayValue'.
*
	Endproc

	Procedure combo1.GotFocus
	This.lcaps = Capslock()
	If Capslock() = .F.
		Capslock(.T.) && Fuerzo a mayúsculas
	Endif
	_Incseek = 5.5 && Tiempo busqueda incremental al maximo
	Local cFile, cCampo
	cFile='customers' && Tabla de la que tomar los datos
	cCampo='upper(ltrim(companyname))' && campo a mostrar
	Select &cCampo As cDato From &cFile Distinct Where !Empty(&cCampo) ;
		ORDER By cDato Into Cursor curcombo nofilter
	This.RowSource = 'curcombo' && Establecemos origen de datos
	Keyboard '{ALT+DNARROW}' && Desplegamos lista
*
*  Si le pasamos un valor previo (en la propiedad 'DisplayValue'),
*  simulamos haberlo tecleado para que se situe en la lista.
*
	If !Empty(This.DisplayValue)
		cTexto = This.DisplayValue
		For yy = 1 To Len(cTexto)
			cLetra = Substr(cTexto, yy, 1)
			Keyboard cLetra
		Endfor
	Endif
	Endproc

	Procedure command1.Click
* El dato lo obtenemos de la propiedad 'DisplayValue'
	If !Empty(Alltrim(Thisform.combo1.DisplayValue))
		=Messagebox(Thisform.combo1.DisplayValue)
	Endif
	Use In Select('customers')
	Close All
	Release mf
	Thisform.Release
	Endproc

Enddefine
