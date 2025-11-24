Define Class alerta As Form
	Height = 120
	Width = 375
	ShowWindow = 2
	BorderStyle = 0
	Caption = ""
	TitleBar = 0
	AlwaysOnTop = .T.
	BackColor = Rgb(14, 173, 241)
	Name = "Aviso"

	Add Object edtmensagem As EditBox With ;
		FontSize = 20, ;
		Alignment = 2, ;
		BackStyle = 0, ;
		BorderStyle = 0, ;
		Height = 103, ;
		Left = 2, ;
		ScrollBars = 0, ;
		Top = 3, ;
		Width = 370, ;
		IntegralHeight = .T., ;
		Name = "edtmensagem"


	Procedure visualizar
	Parameters m.lnA As Integer
	Local m.lnInicio As Integer, m.lnFim As Integer, m.lnStep As Integer
	m.lnInicio = Iif(m.lnA = 1, 10, 255)
	m.lnFim = Iif(m.lnA = 1, 255, 0)
	m.lnStep = Iif(m.lnA = 1, 10, -10)
	For m.loop1 = m.lnInicio To m.lnFim Step m.lnStep
		Inkey(.01, "H")
		_Sol_SetLayeredWindowAttributes(Thisform.HWnd, 0, m.loop1, 2)
	Endfor
	Endproc


	Procedure mensagem
	Parameters m.lcmensagem
	Thisform.edtmensagem.Value = m.lcmensagem
	Thisform.Visible = .T.
	_Sol_SetLayeredWindowAttributes(Thisform.HWnd, 0, 10, 2)
	Thisform.visualizar(1)
	Inkey(2)
	Thisform.visualizar(0)
	_Sol_SetLayeredWindowAttributes(Thisform.HWnd, 0, 0, 2)
	Thisform.Visible = .F.
	Endproc


	Procedure Init
	Zoom Window alerta Max
	m.lnHeight = This.Height
	m.lnWitdh = This.Width
	Zoom Window alerta Normal
	This.Left = m.lnWitdh - 375 - 10
	This.Top = m.lnHeight - 120 + 20
	Declare SetWindowLong In Win32Api As _Sol_SetWindowLong	Integer, Integer, Integer
	Declare SetLayeredWindowAttributes In Win32Api As _Sol_SetLayeredWindowAttributes Integer, String, Integer, Integer
	_Sol_SetWindowLong(Thisform.HWnd, -20, 0x00080000)
	_Sol_SetLayeredWindowAttributes(Thisform.HWnd, 0, 0, 2)
	Endproc
Enddefine