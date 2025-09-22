* -- Ubicación de archivo
ocPDF = "d:\psysn\pdf\20604980225-09-T006-00000318.Pdf"
Local l1, HWnd

* -- Ubicación de archivo PDF
	If File(ocPDF) Then
		_clipboard(ocPDF)
	Endif
* -- Declaramos funciones de API de Windows
	ox = Createobject("Wscript.Shell")
	Declare Integer FindWindow In WIN32API String, String
	Declare Integer SetForegroundWindow In WIN32API Integer
	Declare Integer ShowWindow In WIN32API Integer, Integer
	Declare Integer ShellExecute In shell32.Dll Integer, String, String, String, String, Integer
* -- Cadena de envío de mensaje por WhatsApp
	cMensaje ='whatsapp://send?phone='+'+51952677319'+'&text='+"Hola Te envio el informe"
	= ShellExecute(0, 'open', cMensaje, '', '', 1)
* -- Pausa para envío de mensaje
	Wait Timeout 0.20
	ox = Createobject("Wscript.Shell")
	ox.SendKeys("^v")             && Pegar la ruta (Ctrl+V)
* -- Pausa para aceptar la copia de Clipboard a la interfaz de WhatsApp Escritorio
	Wait Timeout 0.50
	ox.SendKeys("{ENTER}")        && Enviar el archivo
* -- Declaramos funciones para minimizar WhatsApp
	Declare Integer ShowWindow In user32.Dll Integer HWnd, Integer nCmdShow
	Declare Integer GetForegroundWindow In user32.Dll
*-- Constante para minimizar la ventana
	#Define SW_MINIMIZE 6
** -- Obtener el identificador de la ventana activa
	HWnd = GetForegroundWindow()
** -- Minimizar la ventana activa
	ShowWindow(HWnd, SW_MINIMIZE)


******************************************
* ================================================================================================ *
* Send any file to windows clipboard
* Usage:
* 			1. Using array
*				dimension myFiles(3)
*				myFiles(1) = 'c:\my\first\file.ext'
*				myFiles(2) = 'c:\my\second\file.ext'
*				myFiles(3) = 'c:\my\third\file.ext'
*				CopyFiles2Clipboard(@myFiles)
*
* 			2. Using a string
*				CopyFiles2Clipboard('c:\my\first\file.ext')
*
* Original Source = https://www.berezniker.com/content/pages/visual-foxpro/copy-files-clipboard
* ================================================================================================ *

* Copy list of files into Clipboard
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
=LoadApiDlls()

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
=UnloadApiDlls()
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
