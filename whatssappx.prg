Declare Sleep In kernel32 Integer

Declare Integer FindWindow In WIN32API String , String

Declare Integer SetForegroundWindow In WIN32API Integer

Declare Integer ShowWindow In WIN32API Integer , Integer

Declare Integer ShellExecute In shell32.Dll ;

INTEGER hndWin, ;

STRING cAction, ;

STRING cFileName, ;

STRING cParams, ;

STRING cDir, ;

INTEGER nShowWin


Local lt, lhwnd

cPhone=[923000000000] &&Cambiar el número incluyendo el código del país pero sin el +

ccMessage=[Salduos, prueba de Whatsapp desde VFP.]

cmd='whatsapp://send?phone=&cPhone&text='+ccMessage

=ShellExecute(0, 'open', cmd,'', '', 1)

Wait "" Timeout 3

lt = "Whatsapp"

lhwnd = FindWindow (0, lt)

If lhwnd!= 0

SetForegroundWindow (lhwnd)

ShowWindow (lhwnd, 1)

ox = Createobject ( "Wscript.Shell" )

Sleep(2000)

ox.sendKeys ( '{ENTER}' )

Else

Messagebox ( "Whatsapp no esta activado" )

Endif


*------------------------------------------------------------

* 2- Como enviar un archivo de imagen

*------------------------------------------------------------

Do image_to_clip

** Declare Sleep

Declare Sleep In kernel32 Integer

Declare Integer FindWindow In WIN32API String , String

Declare Integer SetForegroundWindow In WIN32API Integer

Declare Integer ShowWindow In WIN32API Integer , Integer

Declare Integer ShellExecute In shell32.Dll ;

INTEGER hndWin, ;

STRING cAction, ;

STRING cFileName, ;

STRING cParams, ;

STRING cDir, ;

INTEGER nShowWin


Local lt, lhwnd

cPhone=[923000000000] &&Cambiar el número incluyendo el código del país pero sin el +

cmd='whatsapp://send?phone=&cPhone'

=ShellExecute(0, 'open', cmd,'', '', 1)

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

Else

Messagebox ("Whatsapp no esta activado" )

Endif


Procedure image_to_clip

Declare Integer Sleep In kernel32 Integer

Declare Integer OpenClipboard In User32 Integer

Declare Integer CloseClipboard In User32

Declare Integer EmptyClipboard In User32

Declare Integer SetClipboardData In User32 Integer,Integer

Declare Integer LoadImage In WIN32API Integer,String,Integer,Integer,Integer,Integer

Declare Integer GetClipboardData In User32 Integer

Declare Integer GdipCreateBitmapFromHBITMAP In GDIPlus.Dll Integer, Integer, Integer @

Declare Integer GdipSaveImageToFile In GDIPlus.Dll Integer,String,String @,String @

Declare Long GdipCreateHBITMAPFromBitmap In GDIPlus.Dll Long nativeImage, Long @, Long

Declare Long GdipCreateBitmapFromFile In GDIPlus.Dll String FileName, Long @nBitmap

Declare Long GdipCreateBitmapFromFile In GDIPlus.Dll String FileName, Long @nBitmap

Declare Long CopyImage In WIN32API Long hImage, Long, Long, Long , Long


#Define CF_BITMAP 2

#Define CF_DIB 8

#Define IMAGE_BITMAP 0

#Define LR_LOADFROMFILE 16

#Define LR_MONOCHROME 0x00000001


Local xpict

m.xpict=Getpict()

If !Empty(m.xpict)

m.ext=Proper(Justext(m.xpict))

If !Inlist(m.ext,"Png","Jpg","Bmp","Gif","Tif")

Messagebox('Por favor, seleccione solo imagenes.',0+16,'Whatsapp',3000)

Return

Endif

Else

Messagebox('Imagen no seleccionada.',0+64,'Whatsapp',3000)

Return

Endif


Local m.oo

m.oo=Newobject("image")

m.oo.Picture=m.xpict

Local lnWidth,lnHeight

lnWidth=m.oo.Width

lnHeight=m.oo.Height


nBitmap=0

hbm=0

GdipCreateBitmapFromFile(Strconv(m.xpict+0h00,5),@nBitmap)

GdipCreateHBITMAPFromBitmap(nBitmap,@hbm,0)

lhBmp = CopyImage(hbm, 0, m.lnWidth, m.lnHeight,0)

If OpenClipboard(0)!= 0

EmptyClipboard()

SetClipboardData(CF_BITMAP, lhBmp)

CloseClipboard()

Endif

Endproc


*------------------------------------------------------------

* 4- Como enviar mensajes masivos

*------------------------------------------------------------

* Primero crearemos algunos datos

** Declare Sleep

Declare Sleep In kernel32 Integer


Create Cursor clients(mobile c(12))

Insert Into clients Values('923000000000') &&Cambiar el número incluyendo el código del país pero sin el +

Insert Into clients Values('923000000000') &&Cambiar el número incluyendo el código del país pero sin el +

Insert Into clients Values('923000000000') &&Cambiar el número incluyendo el código del país pero sin el +

Go Top

lnMessNum = 0

Scan

Scatter Memv

cPhone=Alltrim(m.mobile)

cMessage=Alltrim('Este es un mensaje de promoción de ventas ') + Alltrim(Str(lnMessNum))

lnMessNum = lnMessNum + 1


Declare Integer FindWindow In WIN32API String , String

Declare Integer SetForegroundWindow In WIN32API Integer

Declare Integer ShowWindow In WIN32API Integer , Integer

Declare Integer ShellExecute In shell32.Dll ;

INTEGER hndWin, ;

STRING cAction, ;

STRING cFileName, ;

STRING cParams, ;

STRING cDir, ;

INTEGER nShowWin

Local lt, lhwnd

cmd='whatsapp://send?phone=&cPhone&text=' + cMessage

=ShellExecute(0, 'open', cmd,'', '', 1)

Sleep(2000) && 2 segundo de intervalo en cada mensaje.

lt = "Whatsapp"

lhwnd = FindWindow (0, lt)

If lhwnd!= 0

SetForegroundWindow (lhwnd)

ShowWindow (lhwnd, 1)

ox = Createobject ( "Wscript.Shell" )

Sleep(2000)

ox.sendKeys ( '{ENTER}' )

Else

Messagebox ( "Whatsapp is not activated!" )

Endif

Endscan


*------------------------------------------------------------

* 5- Como enviar el contenido de un archivo de texto

*------------------------------------------------------------

cFile=Getfile('txt')

_Cliptext=Filetostr(cFile)


** Declare Sleep

Declare Sleep In kernel32 Integer


Declare Integer FindWindow In WIN32API String , String

Declare Integer SetForegroundWindow In WIN32API Integer

Declare Integer ShowWindow In WIN32API Integer , Integer

Declare Integer ShellExecute In shell32.Dll ;

INTEGER hndWin, ;

STRING cAction, ;

STRING cFileName, ;

STRING cParams, ;

STRING cDir, ;

INTEGER nShowWin


Local lt, lhwnd

cPhone=[923000000000] &&Cambiar el número incluyendo el código del país pero sin el +

cmd='whatsapp://send?phone=&cPhone'

=ShellExecute(0, 'open', cmd,'', '', 1)

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

Else

Messagebox ( "Whatsapp no esta activado." )

Endif