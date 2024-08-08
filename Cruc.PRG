Clear
*////////////////////////////////////////////////////////////////////////////
*/////////////////////Desarrollado por LisandroFox///////////////////////////
*---------------------------Fecha 12 de Abril 2015---------------------------
*////////////////////////////////////////////////////////////////////////////
Note: Debes descargar tesseract.Exe (el cual permitira la lectura de la imagen del captcha);
	*y colocarla en la ruta adecuada.;
	*el conocimiento debe ser compartido
*---------------------------Descargar captcha Sunat---------------------------
Set Default To c:\
*----------------Declarando la API para la dll urlmon.dll
Declare Integer URLDownloadToFile In urlmon.Dll ;
	INTEGER pCaller, ;
	STRING szURL, ;
	STRING szFileName, ;
	INTEGER dwReserved, Integer lpfnCB

Local lcRemoteFile, lcLocalFile, lcResult
*--------------Indicando el URL del generador captcha
lcRemoteFile = "http://www.sunat.gob.pe/cl-ti-itmrconsruc/captcha?accion=image"

*--------------Indicando la ruta y nombre del captcha a crear
lcLocalFile  = "c:\captcha.gif"

Wait Windows "Descargando archivo …" Nowait
lcResult = URLDownloadToFile(0, lcRemoteFile, lcLocalFile, 0, 0)
Wait Clear

If lcResult = 0 Then
	Local lcCaptcha
*---------------------------Creando Archivo txt de captcha---------------------
	oShell = Createobject("WScript.Shell")
	oShell.Run("c:\tesseract.exe c:\captcha.gif c:\captcha -psm 7", 2, .T.)

	Declare Long URLDownloadToFile In "urlmon";
		LONG pCaller,;
		STRING szURL,;
		STRING szFileName,;
		LONG dwReserved,;
		LONG lpfnCB

	xruc='10401553202'
	xcodigo=LeerCadenaCaptcha()

	If Empty(Alltrim(xcodigo))
		Messagebox("Codigo Captcha no pudo ser leido, intente de nuevo por favor", 48, "Captcha")
		Return
	Endif

	lcUrl="http://www.sunat.gob.pe/cl-ti-itmrconsruc/jcrS00Alias?accion=consPorRuc&nroRuc="+xruc +"&codigo="+xcodigo+"&tipdoc=1"
	lcFile="c:\RucSunat.txt"
	If URLDownloadToFile(0, lcUrl, lcFile, 0, 0)  = 0
		Create Cursor tmpTabla (linea v(254))
		Append From (lcFile) Delimited With Tab
		Go Top
		Select tmpTabla
		Locate For Alltrim(linea) == '<td width="18%" colspan=1  class="bgn">N&uacute;mero de RUC: </td>'
		If Found()
*-------------------Tomando Ruc y Razon Social
			Skip
			lcRuc = Alltrim(Substr(Alltrim(linea),Len('<td  class="bg" colspan=3>')+1,11))
			?lcRuc

			lxPos 	=	Len('<td  class="bg" colspan=3>')+14
			lzPos 	=	At('</td>',Alltrim(linea))-lxPos
			lcRazon = Alltrim(Substr(Alltrim(linea),lxPos,lzPos))

			?lcRazon
*-------------------Tomando Tipo de Contribuyente
			Locate For Alltrim(linea) =='<td class="bgn" colspan=1>Tipo Contribuyente: </td>'
			Skip
			lxPos 	=	Len('<td class="bg" colspan=3>')+1
			lzPos 	=	At('</td>',Alltrim(linea))-lxPos
			lcTipo = Alltrim(Substr(Alltrim(linea),lxPos,lzPos))

			?lcTipo

*-------------------Tomando Tipo de Documento del Contribuyente
			Locate For Alltrim(linea) =='<td class="bgn" colspan=1>Tipo de Documento: </td>'
			Skip
			lxPos 	=	Len('<td class="bg" colspan=3>')+1
			lzPos 	=	Len(Alltrim(linea))
			lcTipoDoc = Alltrim(Substr(Alltrim(linea),lxPos,lzPos))

			?lcTipoDoc
*-------------------Tomando Nombre Comercial
			Locate For Alltrim(linea) =='<td class="bgn" colspan=1 >Nombre Comercial: </td>'
			Skip
			lxPos 	=	Len('<td class="bg" colspan=1>')+1
			lzPos 	=	At('</td>',Alltrim(linea))-lxPos
			lcNcomercial = Alltrim(Substr(Alltrim(linea),lxPos,lzPos))
			?lcNcomercial

*-------------------Tomando Fecha de Inscripción
			Locate For Alltrim(linea) =='<td class="bgn" colspan=1>Fecha de Inscripci&oacute;n: </td>'
			Skip
			lxPos 	=	Len('<td class="bg" colspan=1>')+1
			lzPos 	=	At('</td>',Alltrim(linea))-lxPos
			lcFincri = Alltrim(Substr(Alltrim(linea),lxPos,lzPos))
			?lcFincri

*-------------------Tomando Fecha de Inicio de Actividades
			Locate For Alltrim(linea) =='<td width="27%" colspan=1 class="bgn">Fecha de Inicio de Actividades:</td>'
			Skip
			lxPos 	=	Len('<td class="bg" colspan=1>')+1
			lzPos 	=	At('</td>',Alltrim(linea))-lxPos
			lcFinact = Alltrim(Substr(Alltrim(linea),lxPos,lzPos))
			?lcFinact

*-------------------Tomando Estado del Contribuyente
			Locate For Alltrim(linea) =='<td class="bgn" colspan=1>Estado del Contribuyente: </td>'
			Skip
			lxPos 	=	Len('<td class="bg" colspan=1>')+1
			lzPos 	=	At('</td>',Alltrim(linea))-lxPos
			lcEstado = Alltrim(Substr(Alltrim(linea),lxPos,lzPos))
			?lcEstado

*-------------------Tomando Condicion del Contribuyente
			Locate For Alltrim(linea) =='<td class="bgn"colspan=1>Condici&oacute;n del Contribuyente:</td>'
			Skip
			Skip
			Skip
			lcCondicion = Alltrim(linea)
			?lcCondicion

*-------------------Tomando Direccion del Domicilio Fiscal
			Locate For Alltrim(linea) =='<td class="bgn" colspan=1>Direcci&oacute;n del Domicilio Fiscal:</td>'
			Skip
			lxPos 	=	Len('<td class="bg" colspan=3>')+1
			lzPos 	=	At('</td>',Alltrim(linea))-lxPos
			lcDireccion = Alltrim(Substr(Alltrim(linea),lxPos,lzPos))
			?lcDireccion
		Else
			Messagebox("Datos del Ruc no Pudieron ser descargados, Intente de Nuevo", 48, "Fallo en la conexion")
		Endif
	Else
		Messagebox("Datos del Ruc no Pudieron ser descargados, Intente de Nuevo", 48, "Fallo en la conexion")
	Endif
Else
	Messagebox("Falló la descarga del archivo",16 , "Descarga no realizada")
Endif
*----------------Funcion que leera el archivo de texto creado con los digitos de Captcha
Function LeerCadenaCaptcha
Local gnFileHandle,nSize,cString
cString=''
If File('captcha.txt')  && existe el Archivo?
	gnFileHandle = Fopen('captcha.txt',12)  && if lol abre la leer y escribir
*///////////////////////////////////////////////////////////////////////////
	If gnFileHandle < 0  && Cheque si hay error al abrir el archivo
		Wait 'No puede abrir o crear el archivo' Window Nowait
	Else  && si no hay error, escribe en el archivo
*---------------Lee el archivo y lo envia a una variable
		nSize =  Fseek(gnFileHandle, 0, 2)     && Mueve el puntero al final
		If nSize > 0
			= Fseek(gnFileHandle, 0, 0)      && Mueve el puntero al principio del registro
			cString = Fread(gnFileHandle, nSize)
		Endif
	Endif
*///////////////////////////////////////////////////////////////////////////
	=Fclose(gnFileHandle)  && Cierra el archivo
Endif
Return cString
Endfunc
