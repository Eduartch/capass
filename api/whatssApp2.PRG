Do image_to_clip
** Declare Sleep
Declare Sleep In kernel32 Integer

Declare  Integer FindWindow In WIN32API String, String
Declare  Integer SetForegroundWindow In WIN32API Integer
Declare  Integer  ShowWindow  In WIN32API Integer, Integer
Declare Integer ShellExecute In shell32.Dll ;
	Integer hndWin, ;
	String cAction, ;
	String cFileName, ;
	String cParams, ;
	String cDir, ;
	Integer nShowWin

Local lt, lhwnd
cPhone = [51994592115]
cmd = 'whatsapp://send?phone=&cPhone'
= ShellExecute(0, 'open', cmd, '', '', 1)
Wait "" Timeout 3
lt = "Whatsapp"
lhwnd = FindWindow (0, lt)
If lhwnd!= 0
	SetForegroundWindow (lhwnd)
	ShowWindow (lhwnd, 1)
	ox = Createobject ( "Wscript.Shell" )
	ox.sendKeys ("^{v}")
	Sleep(2000)
	ox.sendKeys ( '{ENTER}' )
	ox.sendKeys ( '{ENTER}' )

Else
	Messagebox ("Whatsapp is not activated!" )
Endif

Procedure image_to_clip
Declare Integer Sleep In kernel32 Integer
Declare Integer OpenClipboard In User32 Integer
Declare Integer CloseClipboard In User32
Declare Integer EmptyClipboard In User32
Declare Integer SetClipboardData In User32 Integer, Integer
Declare Integer LoadImage In WIN32API Integer, String, Integer, Integer, Integer, Integer
Declare Integer GetClipboardData In User32 Integer
Declare Integer GdipCreateBitmapFromHBITMAP In GDIPlus.Dll Integer, Integer, Integer @
Declare Integer GdipSaveImageToFile In GDIPlus.Dll Integer, String, String @, String @
Declare Long GdipCreateHBITMAPFromBitmap In GDIPlus.Dll Long nativeImage, Long @, Long
Declare Long GdipCreateBitmapFromFile In GDIPlus.Dll String FileName, Long @nBitmap
Declare Long    GdipCreateBitmapFromFile    In GDIPlus.Dll String FileName, Long @nBitmap
Declare Long CopyImage In WIN32API Long hImage, Long, Long, Long, Long

#Define CF_BITMAP 2
#Define CF_DIB 8
#Define IMAGE_BITMAP 0
#Define LR_LOADFROMFILE 16
#Define LR_MONOCHROME 0x00000001

Local xpict
m.xpict = Getpict()
If !Empty(m.xpict)
	m.ext = Proper(Justext(m.xpict))
	If !Inlist(m.ext, "Png", "Jpg", "Bmp", "Gif", "Tif")
		Messagebox('Please select only images', 0 + 16, 'Whatsapp', 3000)
		Return
	Endif
Else
	Messagebox('Image not selected', 0 + 64, 'Whatsapp', 3000)
	Return
Endif

Local m.oo
m.oo = Newobject("image")
m.oo.Picture = m.xpict
Local lnWidth, lnHeight
lnWidth = m.oo.Width
lnHeight = m.oo.Height

nBitmap = 0
hbm = 0
GdipCreateBitmapFromFile(Strconv(m.xpict + 0h00, 5), @nBitmap)
GdipCreateHBITMAPFromBitmap(nBitmap, @hbm, 0)
lhBmp = CopyImage(hbm, 0, m.lnWidth, m.lnHeight, 0)
If OpenClipboard(0)!= 0
	EmptyClipboard()
	SetClipboardData(CF_BITMAP, lhBmp)
	CloseClipboard()
Endif
Endproc