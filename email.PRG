



Declare Integer URLDownloadToFile In urlmon.Dll;
	INTEGER pCaller, String szURL, String szFileName,;
	INTEGER dwReserved, Integer lpfnCB

Local lcRemoteFile, lcLocalFile, lcResult

lcRemoteFile = 'http://www.companiasysven.com/app88/sendmail.zip'
*‘http://www.microsoft.com/presspass/images/gallery/boxshots/web/vfp9.jpg&#8217;

lcLocalFile = 'd:\sendmail.zip'

Wait Windows 'Descargando archivo …' Nowait
lcResult = URLDownloadToFile(0,lcRemoteFile,lcLocalFile,0,0)
Wait Clear

If lcResult = 0 Then
	Messagebox("Se ha descaragdo el archivo.",64,"Descargar arvchivo")
Else
	Messagebox("Falló la descarga del archivo, código de error",64,"Descargar arvchivo")
Endif
CLEAR
SET LIBRARY TO d:\psystr\vfpcompression.fll
LOCAL lcFileName AS String, lcFolderName AS String, llUnZipOk AS Logical
m.lcFileName   = FULLPATH('d:\' + "sendmail.zip")
m.lcFolderName = FULLPATH('d:\')
**
m.llUnZipOk = UnZipOpen(m.lcFileName)
m.llUnZipOk = (m.llUnZipOk AND UnZipGotoFileByName(FORCEEXT(JUSTFNAME(m.lcFileName),"exe")))
m.llUnZipOk = (m.llUnZipOk AND UnZipFile(m.lcFolderName))
m.llUnZipOk = (UnzipClose())
**
? m.llUnZipOk
RELEASE m.lcFileName,m.lcFolderName,m.llUnZipOk
SET LIBRARY TO
RETURN 
