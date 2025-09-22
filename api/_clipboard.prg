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
FUNCTION _clipboard(taFileList)
	LOCAL lnDataLen, lcDropFiles, llOk, i, lhMem, lnPtr, lCurData
	#DEFINE CF_HDROP 15

	IF TYPE(taFileList,1) != 'A'
		lCurData = taFileList
		DIMENSION taFileList(1)
		taFileList[1] = lCurData
	ENDIF

	*  Global Memory Variables with Compile Time Constants
	#DEFINE GMEM_MOVABLE 	0x0002
	#DEFINE GMEM_ZEROINIT	0x0040
	#DEFINE GMEM_SHARE		0x2000

	* Load required Windows API functions
	=LoadApiDlls()

	llOk = .T.
	* Build DROPFILES structure
	lcDropFiles = ;
		CHR(20) + REPLICATE(CHR(0),3) + ; 	&& pFiles
	REPLICATE(CHR(0),8) + ; 		&& pt
	REPLICATE(CHR(0),8)  			&& fNC + fWide
	* Add zero delimited file list
	FOR i= 1 TO ALEN(taFileList,1)
		* 1-D and 2-D (1st column) arrays
		lcDropFiles = lcDropFiles + IIF(ALEN(taFileList,2)=0, taFileList[i], taFileList[i,1]) + CHR(0)
	ENDFOR
	* Final CHR(0)
	lcDropFiles = lcDropFiles + CHR(0)
	lnDataLen = LEN(lcDropFiles)
	* Copy DROPFILES structure into the allocated memory
	lhMem = GlobalAlloc(GMEM_MOVABLE+GMEM_ZEROINIT+GMEM_SHARE, lnDataLen)
	lnPtr = GlobalLock(lhMem)
	=CopyFromStr(lnPtr, @lcDropFiles, lnDataLen)
	=GlobalUnlock(lhMem)
	* Open clipboard and store DROPFILES into it
	llOk = (OpenClipboard(0) <> 0)
	IF llOk
		=EmptyClipboard()
		llOk = (SetClipboardData(CF_HDROP, lhMem) <> 0)
		IF NOT llOk
			=GlobalFree(lhMem)
		ENDIF
		* Close clipboard
		=CloseClipboard()
	ENDIF
	=UnloadApiDlls()
	RETURN llOk
ENDFUNC

FUNCTION LoadApiDlls
	*  Clipboard Functions
	DECLARE LONG OpenClipboard IN WIN32API LONG HWND
	DECLARE LONG CloseClipboard IN WIN32API
	DECLARE LONG EmptyClipboard IN WIN32API
	DECLARE LONG SetClipboardData IN WIN32API LONG uFormat, LONG HMEM
	*  Memory Management Functions
	DECLARE LONG GlobalAlloc 	IN WIN32API LONG wFlags, LONG dwBytes
	DECLARE LONG GlobalFree 	IN WIN32API LONG HMEM
	DECLARE LONG GlobalLock 	IN WIN32API LONG HMEM
	DECLARE LONG GlobalUnlock 	IN WIN32API LONG HMEM
	DECLARE LONG RtlMoveMemory 	IN WIN32API AS CopyFromStr LONG lpDest, STRING @lpSrc, LONG iLen
	RETURN
ENDFUNC

FUNCTION UnloadApiDlls
	CLEAR DLLS OpenClipboard, ;
		CloseClipboard, ;
		EmptyClipboard, ;
		SetClipboardData, ;
		GlobalAlloc, ;
		GlobalFree, ;
		GlobalLock, ;
		GlobalUnlock, ;
		CopyFromStr
	RETURN
ENDFUNC