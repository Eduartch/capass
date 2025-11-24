Define Class whatsapp As  Custom 
	cfono=""
	ctexto=""
	cdcto=""
	cmensaje=""
	Function _clipboard(taFileList)
	Local lnDataLen, lcDropFiles, llOk, i, lhMem, lnPtr, lCurData
	#Define CF_HDROP 15
	If Type(taFileList,1) != 'A'
		lCurData = taFileList
		Dimension taFileList(1)
		taFileList[1] = lCurData
	Endif

*  Global Memory Variables with Compile Time Constants
	#Define GMEM_MOVABLE 	0x0002
	#Define GMEM_ZEROINIT	0x0040
	#Define GMEM_SHARE		0x2000

* Load required Windows API functions
	this.LoadApiDlls()

	llOk = .T.
* Build DROPFILES structure
	lcDropFiles = ;
		CHR(20) + Replicate(Chr(0),3) + ; 	&& pFiles
	Replicate(Chr(0),8) + ; 		&& pt
	Replicate(Chr(0),8)  			&& fNC + fWide
* Add zero delimited file list
	For i= 1 To Alen(taFileList,1)
* 1-D and 2-D (1st column) arrays
		lcDropFiles = lcDropFiles + Iif(Alen(taFileList,2)=0, taFileList[i], taFileList[i,1]) + Chr(0)
	Endfor
* Final CHR(0)
	lcDropFiles = lcDropFiles + Chr(0)
	lnDataLen = Len(lcDropFiles)
* Copy DROPFILES structure into the allocated memory
	lhMem = GlobalAlloc(GMEM_MOVABLE+GMEM_ZEROINIT+GMEM_SHARE, lnDataLen)
	lnPtr = GlobalLock(lhMem)
	=CopyFromStr(lnPtr, @lcDropFiles, lnDataLen)
	=GlobalUnlock(lhMem)
* Open clipboard and store DROPFILES into it
	llOk = (OpenClipboard(0) <> 0)
	If llOk
		=EmptyClipboard()
		llOk = (SetClipboardData(CF_HDROP, lhMem) <> 0)
		If Not llOk
			=GlobalFree(lhMem)
		Endif
* Close clipboard
		=CloseClipboard()
	Endif
	this.UnloadApiDlls()
	Return llOk
	Endfunc

	Function LoadApiDlls
*  Clipboard Functions
	Declare Long OpenClipboard In WIN32API Long HWnd
	Declare Long CloseClipboard In WIN32API
	Declare Long EmptyClipboard In WIN32API
	Declare Long SetClipboardData In WIN32API Long uFormat, Long Hmem
*  Memory Management Functions
	Declare Long GlobalAlloc 	In WIN32API Long wFlags, Long dwBytes
	Declare Long GlobalFree 	In WIN32API Long Hmem
	Declare Long GlobalLock 	In WIN32API Long Hmem
	Declare Long GlobalUnlock 	In WIN32API Long Hmem
	Declare Long RtlMoveMemory 	In WIN32API As CopyFromStr Long lpDest, String @lpSrc, Long iLen
	Return
	Endfunc

	Function UnloadApiDlls
	Clear Dlls OpenClipboard, ;
		CloseClipboard, ;
		EmptyClipboard, ;
		SetClipboardData, ;
		GlobalAlloc, ;
		GlobalFree, ;
		GlobalLock, ;
		GlobalUnlock, ;
		CopyFromStr
	Return
	Endfunc
	Function enviarmensaje()
*
* Creada por Manish Swami
* https://www.facebook.com/groups/118032825529669/user/1398167165/
* Ejemplo:
* https://www.facebook.com/groups/118032825529669/permalink/916852342314376/
* SendKeys de Microsoft
* https://docs.microsoft.com/en-us/office/vba/language/reference/user-interface-help/sendkeys-statement
* ShellExecute
* https://docs.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-shellexecutea
* Publicación 19/03/2022
* Ajustes 19/03/2022
*
*!*		Parameters pcPhone, pcText, pcDocument
	Local lhwnd, llResult, pcOldValue
	pcOldValue = _Cliptext
	_Cliptext = This.cdcto
	Declare Sleep In kernel32 Integer
	Declare Integer FindWindow In WIN32API String, String
	Declare Integer ShowWindow In WIN32API Integer, Integer
	Declare Integer ShellExecute In SHELL32.Dll Integer hndWin, String cAction, String cFileName, String cParams, String cDir, Integer nShowWin

	lhwnd = FindWindow(0, "WhatsApp")                                 && Busca la ventana WhatsApp y devulve su puntero
	If lhwnd # 0                                                         && 0 si no fue hallada
		oKey = Createobject("Wscript.Shell" )                         && Crea el objeto para usar el metodo SENDKEYS
		lcCommand = "whatsapp://send?phone=" + This.cfono            && Abro el canal de CHAT
		= ShellExecute(0, "open", lcCommand, "", "", 0)
		Sleep(5000)
*!*                Como no siempre se abre la ventana con el foco en la caja de texto
*!*                le envio un texto para poner el cursor en dicho objeto
		lcCommand = lcCommand + "&text=" + This.ctexto
		= ShellExecute(0, "open", lcCommand, "", "", 0)                 && Envío el nuevo comando con el texto
		Sleep(300)&& 600
		oKey.sendKeys ("{ENTER}")
		Sleep(1000)
		oKey.sendKeys ("+{TAB}")                                        && Shift+TAB
		Sleep(200) && 600
		oKey.sendKeys ("{ENTER}")
		Sleep(320) && 600
*   oKey.sendkeys ("{UP 2}")
		oKey.sendKeys ("{DOWN 2}")
		Sleep(300)
		oKey.sendKeys ("{ENTER}")
		Sleep(700)
		oKey.sendKeys ("^{v}")
		Sleep(600)
		oKey.sendKeys ("{ENTER}")
		Sleep(800)
		oKey.sendKeys ("{ENTER}")
		Sleep(1000)
		oKey.sendKeys ("{TAB}")
		Sleep(700)
*!*ShowWindow (lhwnd, 11)                                && Fuerza al minimizado de la ventana
		oKey = Null
		This.cmensaje="Enviado Ok"
		llResult = .T.
	Else
		This.cmensaje="Whatsapp no está disponible, abralo o instalelo"
		llResult = .F.
	Endif
	Clear Dlls "Sleep", "FindWindow", "ShowWindow", "ShellExecute"
	_Cliptext  = pcOldValue
	Return llResult
	Endfunc
Enddefine
*!*	Declare  Integer FindWindow In WIN32API String, String
*!*	Declare  Integer SetForegroundWindow In WIN32API Integer
*!*	Declare  Integer  ShowWindow  In WIN32API Integer, Integer
*!*	Declare Integer ShellExecute In shell32.Dll ;
*!*		Integer hndWin, ;
*!*		String cAction, ;
*!*		String cFileName, ;
*!*		String cParams, ;
*!*		String cDir, ;
*!*		Integer nShowWin

*!*	Local lt, lhwnd
*!*	cPhone = [+51994592115]
*!*	ccMessage = [Hola]
*!*	cmd = 'whatsapp://send?phone=&cPhone&text=' + ccMessage
*!*	= ShellExecute(0, 'open', cmd, '', '', 1)
*!*	Wait "" Timeout 3
*!*	lt = "Whatsapp"
*!*	lhwnd = FindWindow (0, lt)
*!*	If lhwnd!= 0
*!*		SetForegroundWindow (lhwnd)
*!*		ShowWindow (lhwnd, 1)
*!*		ox = Createobject ( "Wscript.Shell" )
*!*		ox.sendKeys ( '{ENTER}' )
*!*		ox.sendKeys ( '{ENTER}' )
*!*	Else
*!*		Messagebox ( "Whatsapp is not activated!" )
*!*	Endif


*--------------------------------------------------
*!*	Method:2 - How To Send an Image File
*--------------------------------------------------

*!*	Do image_to_clip
*!*	** Declare Sleep
*!*	Declare Sleep In kernel32 Integer

*!*	Declare  Integer FindWindow In WIN32API String, String
*!*	Declare  Integer SetForegroundWindow In WIN32API Integer
*!*	Declare  Integer  ShowWindow  In WIN32API Integer, Integer
*!*	Declare Integer ShellExecute In shell32.Dll ;
*!*		Integer hndWin, ;
*!*		String cAction, ;
*!*		String cFileName, ;
*!*		String cParams, ;
*!*		String cDir, ;
*!*		Integer nShowWin

*!*	Local lt, lhwnd
*!*	cPhone = [923000000000]
*!*	cmd = 'whatsapp://send?phone=&cPhone'
*!*	= ShellExecute(0, 'open', cmd, '', '', 1)
*!*	Wait "" Timeout 3
*!*	lt = "Whatsapp"
*!*	lhwnd = FindWindow (0, lt)
*!*	If lhwnd!= 0
*!*		SetForegroundWindow (lhwnd)
*!*		ShowWindow (lhwnd, 1)
*!*		ox = Createobject ( "Wscript.Shell" )
*!*		ox.sendKeys ("^{v}")
*!*		Sleep(2000)
*!*		ox.sendKeys ( '{ENTER}' )

*!*	Else
*!*		Messagebox ("Whatsapp is not activated!" )
*!*	Endif

*!*	Procedure image_to_clip
*!*	Declare Integer Sleep In kernel32 Integer
*!*	Declare Integer OpenClipboard In User32 Integer
*!*	Declare Integer CloseClipboard In User32
*!*	Declare Integer EmptyClipboard In User32
*!*	Declare Integer SetClipboardData In User32 Integer, Integer
*!*	Declare Integer LoadImage In WIN32API Integer, String, Integer, Integer, Integer, Integer
*!*	Declare Integer GetClipboardData In User32 Integer
*!*	Declare Integer GdipCreateBitmapFromHBITMAP In GDIPlus.Dll Integer, Integer, Integer @
*!*	Declare Integer GdipSaveImageToFile In GDIPlus.Dll Integer, String, String @, String @
*!*	Declare Long GdipCreateHBITMAPFromBitmap In GDIPlus.Dll Long nativeImage, Long @, Long
*!*	Declare Long GdipCreateBitmapFromFile In GDIPlus.Dll String FileName, Long @nBitmap
*!*	Declare Long    GdipCreateBitmapFromFile    In GDIPlus.Dll String FileName, Long @nBitmap
*!*	Declare Long CopyImage In WIN32API Long hImage, Long, Long, Long, Long

*!*	#Define CF_BITMAP 2
*!*	#Define CF_DIB 8
*!*	#Define IMAGE_BITMAP 0
*!*	#Define LR_LOADFROMFILE 16
*!*	#Define LR_MONOCHROME 0x00000001

*!*	Local xpict
*!*	m.xpict = Getpict()
*!*	If !Empty(m.xpict)
*!*		m.ext = Proper(Justext(m.xpict))
*!*		If !Inlist(m.ext, "Png", "Jpg", "Bmp", "Gif", "Tif")
*!*			Messagebox('Please select only images', 0 + 16, 'Whatsapp', 3000)
*!*			Return
*!*		Endif
*!*	Else
*!*		Messagebox('Image not selected', 0 + 64, 'Whatsapp', 3000)
*!*		Return
*!*	Endif

*!*	Local m.oo
*!*	m.oo = Newobject("image")
*!*	m.oo.Picture = m.xpict
*!*	Local lnWidth, lnHeight
*!*	lnWidth = m.oo.Width
*!*	lnHeight = m.oo.Height

*!*	nBitmap = 0
*!*	hbm = 0
*!*	GdipCreateBitmapFromFile(Strconv(m.xpict + 0h00, 5), @nBitmap)
*!*	GdipCreateHBITMAPFromBitmap(nBitmap, @hbm, 0)
*!*	lhBmp = CopyImage(hbm, 0, m.lnWidth, m.lnHeight, 0)
*!*	If OpenClipboard(0)!= 0
*!*		EmptyClipboard()
*!*		SetClipboardData(CF_BITMAP, lhBmp)
*!*		CloseClipboard()
*!*	Endif
*!*	Endproc


*!*	*--------------------------------------------------
*!*	Method:3 - How To Send Excel File As Image
*!*	*--------------------------------------------------

*!*	Suppose I have This Excel File
*!*	C:\Xls\daily.xlsx
*!*	https: // www.foxite.com / uploads / a1d81361 - fc21 - 44fc - af7f - dae4e3ddc4a2.zip

*!*	I shall convert This File Into Image without loosing Format First Then later Send To whatsapp
*!*	You must have following 3 File In Same folder
*!*	gpimage.FXP, gpimage.h, gpimage.prg
*!*	https: // www.foxite.com / uploads / 72917469 - c72e - 489e - 95f6 - 2b9b263a5b0b.zip
*!*	The following codes will generate a bmp File Like This



*!*	Do excel2image

*!*	Function excel2image
*!*	xflname = "" && Get image file name
*!*	xflname = Alltrim("Tailor_") + Dtoc(Date(), 1) + [_] + Chrtran(Time(), [:], [])

*!*	lcXLS = [C:\xls\daily.xlsx]
*!*	If Empty(lcXLS)
*!*		Messagebox('Excel file not found', 0 + 16, 'System')
*!*		Return
*!*	Endif

*!*	Local oForm
*!*	oForm = Createobject("Form")

*!*	With oForm
*!*		.Height = 550
*!*		.Width = 360
*!*		.AutoCenter = .T.
*!*		.Caption = m.xflname
*!*		.MinButton = .F.
*!*		.MaxButton = .F.
*!*		.AlwaysOnTop = .T.
*!*		.Newobject("ExcelObject", "oleExcelObject")
*!*		With .ExcelObject
*!*			.Left = 0
*!*			.Top = 0
*!*			.Width = .Parent.Width - 10
*!*			.Height = .Parent.Height - 10
*!*			.Visible = .T.
*!*		Endwith
*!*		.Newobject("Timer1", "oTimer")
*!*	Endwith

*!*	oForm.Show(1)
*!*	Define Class oleExcelObject As OleControl
*!*		OleClass = "Excel.Sheet"  && Server name
*!*		OLETypeAllowed = 0      && Linked
*!*		DocumentFile = lcXLS && This file should exist
*!*	Enddefine

*!*	Define Class oTimer As Timer
*!*		Interval = 8000
*!*		Procedure Timer
*!*		This.Enabled = .F.
*!*		Do ScreenShot With This.Parent
*!*		This.Enabled = .T.
*!*	Enddefine

*!*	Procedure ScreenShot
*!*	Lparameters oForm

*!*	#Include gpimage.h

*!*	If Not "gpImage" $ Set("Procedure")
*!*		Set Procedure To gpimage Additive
*!*	Endif

*!*	GDIP = Createobject("gpInit")
*!*	img = Createobject("gpImage")
*!*	img.Capture(oForm.HWnd)
*!*	Local lnTitleHeight, lnLeftBorder, lnTopBorder
*!*	lnTitleHeight = Sysmetric(9)
*!*	lnLeftBorder = Sysmetric(3)
*!*	lnTopBorder = Sysmetric(4)
*!*	img.Crop(lnLeftBorder, lnTitleHeight + lnTopBorder, ;
*!*		  img.ImageWidth - (lnLeftBorder * 2), ;
*!*		  img.ImageHeight - (lnTitleHeight + (lnTopBorder * 2)))
*!*	img.SaveasBMP('C:\Xls' + '\' + m.xflname)
*!*	img = Null
*!*	oForm.Release

*!*	Do image2Clip
*!*	Do send2whatsapp

*!*	Endfunc

*!*	Function image2Clip
*!*	Declare Integer Sleep In kernel32 Integer
*!*	Declare Integer OpenClipboard In User32 Integer
*!*	Declare Integer CloseClipboard In User32
*!*	Declare Integer EmptyClipboard In User32
*!*	Declare Integer SetClipboardData In User32 Integer, Integer
*!*	Declare Integer LoadImage In WIN32API Integer, String, Integer, Integer, Integer, Integer
*!*	Declare Integer GetClipboardData In User32 Integer
*!*	Declare Integer GdipCreateBitmapFromHBITMAP In GDIPlus.Dll Integer, Integer, Integer @
*!*	Declare Integer GdipSaveImageToFile In GDIPlus.Dll Integer, String, String @, String @
*!*	Declare Long GdipCreateHBITMAPFromBitmap In GDIPlus.Dll Long nativeImage, Long @, Long
*!*	Declare Long GdipCreateBitmapFromFile In GDIPlus.Dll String FileName, Long @nBitmap
*!*	Declare Long  GdipCreateBitmapFromFile    In GDIPlus.Dll String FileName, Long @nBitmap
*!*	Declare Long CopyImage In WIN32API Long hImage, Long, Long, Long, Long

*!*	#Define CF_BITMAP 2
*!*	#Define CF_DIB 8
*!*	#Define IMAGE_BITMAP 0
*!*	#Define LR_LOADFROMFILE 16
*!*	#Define LR_MONOCHROME 0x00000001 && Creates a new monochrome image. if used
*!*	Local m.xpict

*!*	m.xpict = 'C:\XLS' + '\' + m.xflname + '.bmp'
*!*	Messagebox(m.xpict)

*!*	If !Empty(m.xpict)
*!*		m.ext = Proper(Justext(m.xpict))
*!*		If !Inlist(m.ext, "Png", "Jpg", "Bmp", "Gif", "Tif")
*!*			Messagebox('Please select only images')
*!*			Return
*!*		Endif
*!*	Else
*!*		Messagebox('Image not selected')
*!*		Return
*!*	Endif

*!*	Local m.oo
*!*	m.oo = Newobject("image")
*!*	m.oo.Picture = m.xpict
*!*	Local lnWidth, lnHeight
*!*	lnWidth = m.oo.Width
*!*	lnHeight = m.oo.Height

*!*	*Save the bitmap file to the clipboard
*!*	nBitmap = 0
*!*	hbm = 0
*!*	GdipCreateBitmapFromFile(Strconv(m.xpict + 0h00, 5), @nBitmap)
*!*	GdipCreateHBITMAPFromBitmap(nBitmap, @hbm, 0)
*!*	lhBmp = CopyImage(hbm, 0, m.lnWidth, m.lnHeight, 0)
*!*	If OpenClipboard(0)!= 0
*!*		EmptyClipboard()
*!*		SetClipboardData(CF_BITMAP, lhBmp)
*!*		CloseClipboard()
*!*	Endif
*!*	Endfunc

*!*	Function send2whatsapp
*!*	* Finally send this newly created image to whatsapp
*!*	Declare  Integer FindWindow In WIN32API String, String
*!*	Declare  Integer SetForegroundWindow In WIN32API Integer
*!*	Declare  Integer  ShowWindow  In WIN32API Integer, Integer
*!*	Declare Integer ShellExecute In shell32.Dll ;
*!*		Integer hndWin, ;
*!*		String cAction, ;
*!*		String cFileName, ;
*!*		String cParams, ;
*!*		String cDir, ;
*!*		Integer nShowWin

*!*	Local lt, lhwnd
*!*	cPhone = [923000000000]
*!*	cmd = 'whatsapp://send?phone=&cPhone'
*!*	= ShellExecute(0, 'open', cmd, '', '', 1)
*!*	Wait "" Timeout 3
*!*	lt = "Whatsapp"
*!*	lhwnd = FindWindow (0, lt)
*!*	If lhwnd!= 0
*!*		SetForegroundWindow (lhwnd)
*!*		ShowWindow (lhwnd, 1)
*!*		ox = Createobject ( "Wscript.Shell" )
*!*		ox.sendKeys ("^{v}")
*!*		Sleep(2000)
*!*		ox.sendKeys ( '{ENTER}' )
*!*	Else
*!*		Messagebox ( "Whatsapp is not activated!" )
*!*	Endif
*!*	Endfunc


*!*	*--------------------------------------------------
*!*	Method:4 - How To Send Bulk Messages
*!*	*--------------------------------------------------
*!*	We shall Create Some Data First

*!*	Create Cursor clients(mobile C(12))
*!*	Insert Into clients Values('923000000000')
*!*	Insert Into clients Values('923000000000')
*!*	Insert Into clients Values('923000000000')
*!*	Go Top
*!*	Scan
*!*		Scatter Memv
*!*		cPhone = Alltrim(m.mobile)
*!*		cMessage = Alltrim('This is sales promotion message')

*!*		Declare  Integer FindWindow In WIN32API String, String
*!*		Declare  Integer SetForegroundWindow In WIN32API Integer
*!*		Declare  Integer  ShowWindow  In WIN32API Integer, Integer
*!*		Declare Integer ShellExecute In shell32.Dll ;
*!*			Integer hndWin, ;
*!*			String cAction, ;
*!*			String cFileName, ;
*!*			String cParams, ;
*!*			String cDir, ;
*!*			Integer nShowWin
*!*		Local lt, lhwnd
*!*		cmd = 'whatsapp://send?phone=&cPhone&text=' + cMessage
*!*		= ShellExecute(0, 'open', cmd, '', '', 1)
*!*		Wait "" Timeout 8 && 8 seconds internal in every message
*!*		lt = "Whatsapp"
*!*		lhwnd = FindWindow (0, lt)
*!*		If lhwnd!= 0
*!*			SetForegroundWindow (lhwnd)
*!*			ShowWindow (lhwnd, 1)
*!*			ox = Createobject ( "Wscript.Shell" )
*!*			ox.sendKeys ( '{ENTER}' )
*!*		Else
*!*			Messagebox ( "Whatsapp is not activated!" )
*!*		Endif
*!*	Endscan


*!*	*--------------------------------------------------
*!*	Method:5 - How To Send contents Of Text File
*!*	*--------------------------------------------------

*!*	cFile = Getfile('txt')
*!*	_Cliptext = Filetostr(cFile)

*!*	Declare  Integer FindWindow In WIN32API String, String
*!*	Declare  Integer SetForegroundWindow In WIN32API Integer
*!*	Declare  Integer  ShowWindow  In WIN32API Integer, Integer
*!*	Declare Integer ShellExecute In shell32.Dll ;
*!*		Integer hndWin, ;
*!*		String cAction, ;
*!*		String cFileName, ;
*!*		String cParams, ;
*!*		String cDir, ;
*!*		Integer nShowWin

*!*	Local lt, lhwnd
*!*	cPhone = [923000000000]
*!*	cmd = 'whatsapp://send?phone=&cPhone'
*!*	= ShellExecute(0, 'open', cmd, '', '', 1)
*!*	Wait "" Timeout 3
*!*	lt = "Whatsapp"
*!*	lhwnd = FindWindow (0, lt)
*!*	If lhwnd!= 0
*!*		SetForegroundWindow (lhwnd)
*!*		ShowWindow (lhwnd, 1)
*!*		ox = Createobject ( "Wscript.Shell" )
*!*		ox.sendKeys ("^{v}")
*!*		Sleep(2000)
*!*		ox.sendKeys ( '{ENTER}' )
*!*	Else
*!*		Messagebox ( "Whatsapp is not activated!" )
*!*	Endif


*!*	*--------------------------------------------------
*!*	Method:6 - How To Send Result Cards
*!*	*--------------------------------------------------
*!*	Suppose You are a principal Of a school And want To Send customized Result card To parents.


*!*	Create Cursor Result(rollno N(3), student C(15), Chem N(3), phy N(3), bio N(3), ;
*!*		  eng N(3), math N(3), t_marks N(3), o_marks N(3), rem C(10), mobile C(13))
*!*	Insert Into Result Values(1, 'Ahmad Ali', 78, 25, 33, 85, 50, 500, 271, 'Pass', '923000000000')
*!*	Insert Into Result Values(1, 'Zahid Mahmood', 36, 74, 66, 55, 80, 500, 311, 'Pass', '92345000000')


*!*	Go Top
*!*	Scan
*!*		Scatter Memv
*!*		cPhone = Alltrim(m.mobile)

*!*		cMessage = '*Result Card*';
*!*			+ '%0A' + '%0A';
*!*			+ m.student;
*!*			+ '%0A' + '%0A' + 'Chem=' + Transform(m.Chem);
*!*			+ '%0A' + 'Bio=' + Transform(m.bio);
*!*			+ '%0A' + 'Phy=' + Transform(m.phy);
*!*			+ '%0A' + 'Eng=' + Transform(m.eng);
*!*			+ '%0A' + 'Math=' + Transform(m.math);
*!*			+ '%0A' + '%0A' + 'Total=' + Transform(m.t_marks);
*!*			+ '%0A' + 'Obtained=' + Alltrim(Str(m.o_marks));
*!*			+  '%0A' + '%0A' + 'Remarks=' + '*' + Alltrim(m.rem) + '*';
*!*			+ '%0A' ;
*!*			+ Replicate('-', 20);
*!*			+ '%0A' + 'Principal:';
*!*			+ '%0A' + 'Allied Public School'

*!*		Declare Sleep In kernel32 Integer
*!*		Declare  Integer FindWindow In WIN32API String, String
*!*		Declare  Integer SetForegroundWindow In WIN32API Integer
*!*		Declare  Integer  ShowWindow  In WIN32API Integer, Integer
*!*		Declare Integer ShellExecute In shell32.Dll ;
*!*			Integer hndWin, ;
*!*			String cAction, ;
*!*			String cFileName, ;
*!*			String cParams, ;
*!*			String cDir, ;
*!*			Integer nShowWin
*!*		Local lt, lhwnd
*!*		cmd = 'whatsapp://send?phone=&cPhone&text=' + cMessage
*!*		= ShellExecute(0, 'open', cmd, '', '', 1)
*!*		Sleep(2000)
*!*		lt = "Whatsapp"
*!*		lhwnd = FindWindow (0, lt)
*!*		If lhwnd!= 0
*!*			SetForegroundWindow (lhwnd)
*!*			ShowWindow (lhwnd, 1)
*!*			ox = Createobject ( "Wscript.Shell" )
*!*			ox.sendKeys ( '{ENTER}' )
*!*		Else
*!*			Messagebox ("Whatsapp is not activated!" )
*!*		Endif
*!*	Endscan



*!*	parents will receive This Message On their whatsapp.



*!*	Same Like This, While using an accounting System You can Send Ledger To your customers also.

*!*	If You want To be more intelligent, don't want to use columns name and values in message then play like this

*!*		For lnCnt = 1 To Fcount()
*!*	*** Get the Field Name
*!*			lcField = Field( lnCnt )
*!*	*** Get the field Value
*!*			luFVal = &lcField
*!*	*** Check the type
*!*			lcType = Vartype( luFVal )

*!*	*** Now do whatever you want with it
*!*			? lcField, lcType, luFVal
*!*		Next



*!*		see Result




*!*	*---------------------------------------------------
*!*	* Method:7- How to send unicode message from text file
*!*	*--------------------------------------------------

*!*		Some Users asked me they want To Send Unicode Message To whatsapp.
*!*		they have Text File that contains Data In their Local Language.

*!*		Suppose I have Text File written our national lanugage URDU.
*!*		If I Copy Data From This File To VFP Then Data will be appear Like This
*!*			?? ???? ??? ????? ???? ???? ??? ?? ???? ?????. ?? ?? ???? ????? ??

*!*			In This Case I could Not Send This Data To Whats App With VFP codes

*!*			To Make This Data readable, I Used my codes With This Link

*!*			https: // www.berezniker.com / content / Pages / Visual - FoxPro / Copy - Unicode - Text - clipboard

*!*			Here Is Complete routine

*!*			aa = Fullpath(Getfile('txt'))
*!*			tcUnicodeText = Strconv(Filetostr(aa), 5, 1256, 1)
*!*	*-------------------------------------------------
*!*			Do CopyUnicodeText2Clipboard With tcUnicodeText

*!*			Declare Sleep In kernel32 Integer

*!*			Declare  Integer FindWindow In WIN32API String, String
*!*			Declare  Integer SetForegroundWindow In WIN32API Integer
*!*			Declare  Integer  ShowWindow  In WIN32API Integer, Integer
*!*			Declare Integer ShellExecute In shell32.Dll ;
*!*				Integer hndWin, ;
*!*				String cAction, ;
*!*				String cFileName, ;
*!*				String cParams, ;
*!*				String cDir, ;
*!*				Integer nShowWin

*!*			Local lt, lhwnd
*!*			cPhone = [923226857062]
*!*			cmd = 'whatsapp://send?phone=&cPhone'
*!*			= ShellExecute(0, 'open', cmd, '', '', 1)
*!*			Wait "" Timeout 3
*!*			lt = "Whatsapp"
*!*			lhwnd = FindWindow (0, lt)
*!*			If lhwnd!= 0
*!*				SetForegroundWindow (lhwnd)
*!*				ShowWindow (lhwnd, 1)
*!*				ox = Createobject ( "Wscript.Shell" )
*!*				ox.sendKeys ("^{v}")
*!*				Sleep(2000)
*!*				ox.sendKeys ( '{ENTER}' )
*!*			Else
*!*				Messagebox ("Whatsapp is not activated!" )
*!*			Endif


*!*	&& Copy Unicode text into Clipboard
*!*	Function CopyUnicodeText2Clipboard(tcUnicodeText)
*!*	Local lnDataLen, lcDropFiles, llOk, I, lhMem, lnPtr, lcUnicodeText

*!*	#Define CF_UNICODETEXT      13
*!*	&&  Global Memory Variables with Compile Time Constants
*!*	#Define GMEM_MOVABLE 	0x0002
*!*	#Define GMEM_ZEROINIT	0x0040
*!*	#Define GMEM_SHARE		0x2000

*!*	&& Load required Windows API functions
*!*	= LoadApiDlls()

*!*	llOk = .T.
*!*	lcUnicodeText = tcUnicodeText + Chr(0) + Chr(0)
*!*	lnDataLen = Len(lcUnicodeText)
*!*	&& Copy Unicode text into the allocated memory
*!*	lhMem = GlobalAlloc(GMEM_MOVABLE + GMEM_ZEROINIT + GMEM_SHARE, lnDataLen)
*!*	lnPtr = GlobalLock(lhMem)
*!*	= CopyFromStr(lnPtr, @lcUnicodeText, lnDataLen)
*!*	= GlobalUnlock(lhMem)
*!*	&& Open clipboard and store Unicode text into it
*!*	llOk = (OpenClipboard(0) <> 0)
*!*	If llOk
*!*		= EmptyClipboard()
*!*		llOk = (SetClipboardData(CF_UNICODETEXT, lhMem) <> 0)
*!*	&& If call to SetClipboardData() is successful, the system will take ownership of the memory
*!*	&&   otherwise we have to free it
*!*		If Not llOk
*!*			= GlobalFree(lhMem)
*!*		Endif
*!*	&& Close clipboard
*!*		= CloseClipboard()
*!*	Endif
*!*	Return llOk

*!*	Function LoadApiDlls
*!*	&&  Clipboard Functions
*!*	Declare Long OpenClipboard In WIN32API Long HWnd
*!*	Declare Long CloseClipboard In WIN32API
*!*	Declare Long EmptyClipboard In WIN32API
*!*	Declare Long SetClipboardData In WIN32API Long uFormat, Long Hmem
*!*	&&  Memory Management Functions
*!*	Declare Long GlobalAlloc In WIN32API Long wFlags, Long dwBytes
*!*	Declare Long GlobalFree In WIN32API Long Hmem
*!*	Declare Long GlobalLock In WIN32API Long Hmem
*!*	Declare Long GlobalUnlock In WIN32API Long Hmem
*!*	Declare Long RtlMoveMemory In WIN32API As CopyFromStr Long lpDest, String @lpSrc, Long iLen
*!*	Return



*!*	The Result Of above codes On whatsapp Is As follows



*!*	You can Read more about Unicode And Locale
*!*	http: // Unicode.org / Main.html

*!*	*---------------------------------------------------
*!*	Method:8 - How To Send POS Invoice
*!*	*--------------------------------------------------

*!*	Today a User asked How To Send POS Invoice / bill To customer On The spot.
*!*	It was good idea To Get customers focus.
*!*	There are many issues To Use Custom Page In VFP reports.
*!*	So There was need To Send Report On whatsapp With a small Size To fit On mobile Screen.

*!*	You Mast have following Files In Same folder Before executing codes
*!*	https: // www.foxite.com / uploads / b6eae531 - c53f - 456d - a14b - 2f72812d1fc7.zip

*!*	Suppose I want To Send This Invoice To customer.



*!*	To achieve This goal please give a Try To following codes:


*!*	Create Cursor POS(Items C(25), qty N(3), price N(3), Total N(4))

*!*	Insert Into POS Values('KAJU SADA 50G', 1, 150, 150)
*!*	Insert Into POS Values('Kaju Roasted 50G', 1, 170, 170)
*!*	Insert Into POS Values('AKHROT MAGAZ 50G', 2, 90, 180)
*!*	Insert Into POS Values('Pista Namkeen 100G', 1, 250, 250)
*!*	Insert Into POS Values('SANGARI NISRI 100G', 1, 30, 30)
*!*	Insert Into POS Values('GANDAM DALYA 500G', 1, 50, 50)
*!*	Insert Into POS Values('PODINA TIKI 50G', 1, 25, 25)
*!*	Insert Into POS Values('CHAR MAGAZ 100G', 1, 65, 65)
*!*	Insert Into POS Values('HARMONY LEMON 150G', 1, 65, 65)
*!*	Insert Into POS Values('L C KA BEEG 100G', 1, 40,	40)
*!*	Insert Into POS Values('SERVING CUP BACHA', 1, 150, 150)

*!*	#Include Excel.h
*!*	#Define xlA1 1
*!*	#Define xlR1C1 -4150
*!*	#Define xlLastCell 11

*!*	bError = .F.
*!*	On Error bError = .T.
*!*	loExcel = Createobj("excel.application")
*!*	If bError
*!*		Messagebox("Error")
*!*		Return
*!*	Endif
*!*	*MessageBox("Version: " + loExcel.Version) && version number
*!*	On Error

*!*	xflname = "" && Get Excel file name
*!*	ahour = Padl(Alltrim(Str(Hour(Datetime()))), 2, '0')
*!*	amin = Padl(Alltrim(Str(Minute(Datetime()))), 2, '0')
*!*	xflname = Alltrim("Tailor_") + Alltrim(Dtos(Date())) + "_" + ahour + amin
*!*	xflname = Alltrim("Tailor_") + Alltrim(Dtos(Date())) + "_" + ahour + amin


*!*	Select POS
*!*	Copy To 'C:\Xls\' + Alltrim(xflname) + Alltrim('.xls') Type Xl5
*!*	rec1 = Reccount()
*!*	rec2 = Reccount() + 6

*!*	loExcel = Createobject("Excel.Application")
*!*	loworkbook = loExcel.WorkBooks.Open('C:\Xls\' + Alltrim(xflname))
*!*	losheet = loworkbook.Sheets(1)

*!*	* insert 4 empty rows before data
*!*	With loExcel.ActiveWorkBook.ActiveSheet
*!*		.UsedRange.RowHeight = 15
*!*		.Rows("1:4").Insert()
*!*	Endwith

*!*	&& First Line
*!*	losheet.Range("A1").Value = [Ehsas Mart]
*!*	With loExcel.Range("A1:D1")
*!*		.HorizontalAlignment = xlcenter
*!*		.verticalalignment = xlcenter
*!*		.wraptext = false
*!*		.Orientation = 0
*!*		.shrinktofit = false
*!*		.MergeCells = true

*!*		.Font.Color = Rgb(128, 64, 64)
*!*		.Font.Name = 'Verdana'
*!*		.Font.Bold = .T.
*!*		.Font.Size = 16
*!*		.RowHeight = 22
*!*	Endwith

*!*	&& Second Line
*!*	losheet.Range("A2").Value = [Opp. Government Printing Press]
*!*	With loExcel.Range("A2:D2")
*!*		.HorizontalAlignment = xlcenter
*!*		.verticalalignment = xlcenter
*!*		.wraptext = false
*!*		.Orientation = 0
*!*		.shrinktofit = false
*!*		.MergeCells = true

*!*		.Font.Color = Rgb(0, 0, 0)
*!*		.Font.Name = 'Verdana'
*!*	*  .FONT.Bold = .T.
*!*		.Font.Size = 10
*!*		.RowHeight = 15
*!*	Endwith

*!*	&& Third line
*!*	losheet.Range("A3").Value = [Bahawalpur, Ph.062-2504438]
*!*	With loExcel.Range("A3:D3")
*!*		.HorizontalAlignment = xlcenter
*!*		.verticalalignment = xlcenter
*!*		.wraptext = false
*!*		.Orientation = 0
*!*		.shrinktofit = false
*!*		.MergeCells = true

*!*		.Font.Color = Rgb(0, 0, 0)
*!*		.Font.Name = 'Verdana'
*!*	*	.Font.bold = .T.
*!*		.Font.Size = 10
*!*		.RowHeight = 15
*!*	Endwith

*!*	&& Fourth line
*!*	losheet.Range("A4").Value = [21-Nov-2020 5:33pm        Invoice No. 166]
*!*	With loExcel.Range("A4:D4")
*!*		.HorizontalAlignment = xlleft
*!*		.verticalalignment = xlcenter
*!*		.wraptext = false
*!*		.Orientation = 0
*!*		.shrinktofit = false
*!*		.MergeCells = true

*!*		.Font.Color = Rgb(50, 50, 150)
*!*		.Font.Name = 'Verdana'
*!*		.Font.Size = 8
*!*		.Font.Bold = .T.
*!*		.Font.Italic = 1
*!*		.RowHeight = 15

*!*	Endwith

*!*	* Body Font name
*!*	rec5 = 5
*!*	With losheet.Range("A" + Alltrim(Str(rec5)) + ":" + "D" + Alltrim(Str(rec2)))
*!*		.Font.Name = "Verdana"
*!*	Endwith

*!*	&& Foramt
*!*	rec4 = 4
*!*	losheet.Range("D" + Alltrim(Str(rec4)) + ":" + "D" + Alltrim(Str(rec2))).numberformat = "#[=0];###,###"

*!*	&& Headings
*!*	losheet.Range("A5").Value = "Name"
*!*	losheet.Range("B5").Value = "Qty"
*!*	losheet.Range("C5").Value = "Price"
*!*	losheet.Range("D5").Value = "Total"
*!*	losheet.Columns(1).AutoFit()

*!*	* Border of heading row
*!*	With loExcel.Sheets(1).Range("A5:D5")
*!*		.BorderS(xlEdgeLeft).LineStyle = xlContinuous
*!*		.BorderS(xlEdgeTop).LineStyle = xlContinuous
*!*		.BorderS(xlEdgeBottom).LineStyle = xlContinuous
*!*		.BorderS(xlEdgeRight).LineStyle = xlContinuous
*!*	Endwith

*!*	* Heading Row
*!*	With loExcel.Sheets(1).Range("A5:D5")
*!*		.Font.Name = 'Verdana'
*!*		.Font.Bold = .T.
*!*		.RowHeight = 20
*!*		.Font.Color = Rgb(10, 25, 245)
*!*	*	.interior.Color = Rgb(10,235,245)
*!*		.Interior.Color = 0x00FFFF
*!*		.HorizontalAlignment = -4108
*!*		.verticalalignment = -4108
*!*	Endwith

*!*	&& Summary Row
*!*	With losheet.Range("A" + Alltrim(Str(rec2)) + ":" + "D" + Alltrim(Str(rec2)))
*!*		.RowHeight = 20
*!*		.Font.Color = Rgb(0, 0, 255)
*!*		.Interior.Color = Rgb(204, 255, 204)
*!*		.Font.Name = 'Verdana'
*!*		.Font.Bold = .T.
*!*		.HorizontalAlignment = -4108
*!*		.verticalalignment = -4108
*!*	Endwith

*!*	rec3 = rec2 - 1
*!*	&& Summary with Formula
*!*	losheet.Range("A" + Alltrim(Str(rec2))).Value = "TOTAL"
*!*	losheet.Range("b" + Alltrim(Str(rec2))).Formula = "=SUM(b2:b" + Alltrim(Str(rec3)) + ")"
*!*	losheet.Range("d" + Alltrim(Str(rec2))).Formula = "=SUM(d2:d" + Alltrim(Str(rec3)) + ")"

*!*	* column data autofit
*!*	For lnI = 1 To Fcount("pos")
*!*		lccolumn = Chr(lnI + 96) + ":" + Chr(lnI + 96)
*!*		loExcel.Columns(lccolumn).entirecolumn.AutoFit
*!*	Endfor

*!*	* Last Row/Column
*!*	lnLastRow = losheet.UsedRange.Rows.Count
*!*	lnLastCol = losheet.UsedRange.Columns.Count
*!*	thanks = lnLastRow + 3
*!*	losheet.Range("A" + Alltrim(Str(thanks))).Value = "Thanks for visiting"

*!*	* Borders
*!*	loExcel.ActiveWindow.displaygridlines = .F.

*!*	&& page margin
*!*	Local plportrait, pctitlerange, pllegal, pcprintarea, lnmargin
*!*	plportrait = .T.
*!*	pctitlerange = "L"

*!*	With losheet.pagesetup
*!*		If plportrait = .T.
*!*			.Orientation = 1
*!*		Else
*!*			.Orientation = 2
*!*		Endif

*!*		If pllegal = .T.
*!*			.Papersize = 5
*!*		Else
*!*			.Papersize = 1
*!*		Endif
*!*	*	.PaperSize = 5 && 5 for legal 1 for landscap
*!*	*	.Orientation = 1  && 1 for portrati 2 for landscap
*!*		.topmargin     = loExcel.inchestopoints(0.6)
*!*		.bottommargin     = loExcel.inchestopoints(0.8)
*!*		.leftmargin     = loExcel.inchestopoints(1)
*!*		.rightmargin     = loExcel.inchestopoints(0.6)

*!*		.headermargin     = loExcel.inchestopoints(0.1)
*!*		.footermargin     = loExcel.inchestopoints(0.1)

*!*		.centerhorizontally = .T.
*!*		.Zoom = .F.
*!*		.fittopageswide = 1
*!*		.fittopagestall = .F.
*!*		If Type('pcTitleRange') <> 'L'
*!*			.printtitlerows = losheet.Range("A5:d5").address
*!*		Endif
*!*		If Type('pcPrintArea') <> 'L'
*!*			.printarea = pcprintarea
*!*		Endif
*!*	Endwith

*!*	&& Page Footer
*!*	losheet.pagesetup.rightfooter = "Page &P of &N"

*!*	*loExcel.Range("b6").Select
*!*	*loExcel.activewindow.freezepanes = .T. && freeze the panes
*!*	loExcel.Range("a1").Select

*!*	loExcel.ActiveWorkBook.Save
*!*	loExcel.DisplayAlerts = .F.
*!*	*loExcel.Visible = .T. && display Excel
*!*	*losheet.printpreview()
*!*	loExcel.Quit()
*!*	Release loExcel
*!*	Release All Like lo*
*!*	loExcel = .Null.

*!*	Do excel2image
*!*	Function excel2image

*!*	lcXLS = 'C:\Xls\' + Alltrim(xflname) + '.xls'

*!*	If Empty(lcXLS)
*!*		Messagebox('Excel file not found', 0 + 16, 'System')
*!*		Return
*!*	Endif

*!*	Local oForm
*!*	oForm = Createobject("Form")

*!*	With oForm
*!*		.Height = 550
*!*		.Width = 360
*!*		.AutoCenter = .T.
*!*		.Caption = m.xflname
*!*		.MinButton = .F.
*!*		.MaxButton = .F.
*!*		.AlwaysOnTop = .T.
*!*		.BackColor = Rgb(255, 255, 255)
*!*		.Newobject("ExcelObject", "oleExcelObject")

*!*		With .ExcelObject
*!*			.Left = 10
*!*			.Top = 10
*!*			.Width = .Parent.Width - 30
*!*			.Height = .Parent.Height - 30
*!*			.Visible = .T.
*!*		Endwith

*!*		.Newobject("Timer1", "oTimer")

*!*	Endwith

*!*	oForm.Show(1)
*!*	Define Class oleExcelObject As OleControl
*!*		OleClass = "Excel.Sheet"
*!*		OLETypeAllowed = 0
*!*		DocumentFile = lcXLS
*!*	Enddefine

*!*	Define Class oTimer As Timer
*!*		Interval = 3000
*!*		Procedure Timer
*!*		This.Enabled = .F.
*!*		Do ScreenShot With This.Parent
*!*		This.Enabled = .T.
*!*	Enddefine

*!*	Procedure ScreenShot
*!*	Lparameters oForm

*!*	#Include gpimage.h

*!*	If Not "gpImage" $ Set("Procedure")
*!*		Set Procedure To gpimage Additive
*!*	Endif

*!*	GDIP = Createobject("gpInit")
*!*	img = Createobject("gpImage")
*!*	img.Capture(oForm.HWnd)
*!*	Local lnTitleHeight, lnLeftBorder, lnTopBorder
*!*	lnTitleHeight = Sysmetric(9)
*!*	lnLeftBorder = Sysmetric(3)
*!*	lnTopBorder = Sysmetric(4)
*!*	img.Crop(lnLeftBorder, lnTitleHeight + lnTopBorder, ;
*!*		  img.ImageWidth - (lnLeftBorder * 2), ;
*!*		  img.ImageHeight - (lnTitleHeight + (lnTopBorder * 2)))
*!*	img.SaveasBMP('C:\Xls' + '\' + m.xflname)
*!*	img = Null
*!*	oForm.Release

*!*	Do image2Clip
*!*	Do send2whatsapp

*!*	Endfunc

*!*	Function image2Clip
*!*	Declare Integer Sleep In kernel32 Integer
*!*	Declare Integer OpenClipboard In User32 Integer
*!*	Declare Integer CloseClipboard In User32
*!*	Declare Integer EmptyClipboard In User32
*!*	Declare Integer SetClipboardData In User32 Integer, Integer
*!*	Declare Integer LoadImage In WIN32API Integer, String, Integer, Integer, Integer, Integer
*!*	Declare Integer GetClipboardData In User32 Integer
*!*	Declare Integer GdipCreateBitmapFromHBITMAP In GDIPlus.Dll Integer, Integer, Integer @
*!*	Declare Integer GdipSaveImageToFile In GDIPlus.Dll Integer, String, String @, String @
*!*	Declare Long GdipCreateHBITMAPFromBitmap In GDIPlus.Dll Long nativeImage, Long @, Long
*!*	Declare Long GdipCreateBitmapFromFile In GDIPlus.Dll String FileName, Long @nBitmap
*!*	Declare Long  GdipCreateBitmapFromFile    In GDIPlus.Dll String FileName, Long @nBitmap
*!*	Declare Long CopyImage In WIN32API Long hImage, Long, Long, Long, Long

*!*	#Define CF_BITMAP 2
*!*	#Define CF_DIB 8
*!*	#Define IMAGE_BITMAP 0
*!*	#Define LR_LOADFROMFILE 16
*!*	#Define LR_MONOCHROME 0x00000001 && Creates a new monochrome image. if used
*!*	Local m.xpict

*!*	m.xpict = 'C:\XLS' + '\' + m.xflname + '.bmp'


*!*	If !Empty(m.xpict)
*!*		m.ext = Proper(Justext(m.xpict))
*!*		If !Inlist(m.ext, "Png", "Jpg", "Bmp", "Gif", "Tif")
*!*			Messagebox('Please select only images')
*!*			Return
*!*		Endif
*!*	Else
*!*		Messagebox('Image not selected')
*!*		Return
*!*	Endif

*!*	Local m.oo
*!*	m.oo = Newobject("image")
*!*	m.oo.Picture = m.xpict
*!*	Local lnWidth, lnHeight
*!*	lnWidth = m.oo.Width
*!*	lnHeight = m.oo.Height

*!*	*Save the bitmap file to the clipboard
*!*	nBitmap = 0
*!*	hbm = 0
*!*	GdipCreateBitmapFromFile(Strconv(m.xpict + 0h00, 5), @nBitmap)
*!*	GdipCreateHBITMAPFromBitmap(nBitmap, @hbm, 0)
*!*	lhBmp = CopyImage(hbm, 0, m.lnWidth, m.lnHeight, 0)
*!*	If OpenClipboard(0)!= 0
*!*		EmptyClipboard()
*!*		SetClipboardData(CF_BITMAP, lhBmp)
*!*		CloseClipboard()
*!*	Endif
*!*	Endfunc

*!*	Function send2whatsapp
*!*	* Finally send this newly created image to whatsapp
*!*	Declare  Integer FindWindow In WIN32API String, String
*!*	Declare  Integer SetForegroundWindow In WIN32API Integer
*!*	Declare  Integer  ShowWindow  In WIN32API Integer, Integer
*!*	Declare Integer ShellExecute In shell32.Dll ;
*!*		Integer hndWin, ;
*!*		String cAction, ;
*!*		String cFileName, ;
*!*		String cParams, ;
*!*		String cDir, ;
*!*		Integer nShowWin

*!*	Local lt, lhwnd
*!*	cPhone = [92300000000]
*!*	cmd = 'whatsapp://send?phone=&cPhone'
*!*	= ShellExecute(0, 'open', cmd, '', '', 1)
*!*	Wait "" Timeout 3
*!*	lt = "Whatsapp"
*!*	lhwnd = FindWindow (0, lt)
*!*	If lhwnd!= 0
*!*		SetForegroundWindow (lhwnd)
*!*		ShowWindow (lhwnd, 1)
*!*		ox = Createobject ( "Wscript.Shell" )
*!*		ox.sendKeys ("^{v}")
*!*		Sleep(2000)
*!*		ox.sendKeys ( '{ENTER}' )
*!*	Else
*!*		Messagebox ( "Whatsapp is not activated!" )
*!*	Endif
*!*	Endfunc
