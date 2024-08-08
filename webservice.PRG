oWS = Createobject( "VFP_WebService","http://www.webservicex.net/globalweather.asmx?WSDL")
lcRespuesta = oWS.GetWeather("Torreon, Coah.","Mexico")
If oWS.iStatus != 0
	Messagebox(oWS.sError,16,"Error al ejecutar WS")
Else
	Messagebox(lcRespuesta,64,"EjecutandoWS desde VFP - PortalFOX")
Endif



Define Class VFP_WebService As Custom

* --- Definimos las propiedades ---
	sError = ""
	iStatus = 0
	sURL_WS = ""

* --- Definimos la función del WebService ---
	Function GetWeather (tcCiudad, tcPais)

* --- Paso 1. Creo el XML Request ---
	sXMLRequest = This.CreaRequest(tcCiudad, tcPais)

	pXMLResponse = Addbs(Sys(2023)) + Sys(2015) + [.xml]

* --- Paso 2. Ejecuto el WS | Paso 3. Obtengo el Response ---
	This.iStatus =  This.EjecutaWS( This.sURL_WS, sXMLRequest , pXMLResponse )

	If This.iStatus != 0  && Ocurrió un error el cual está especificado en sError.
		Return ""
	Endif

	sXMLResponse = Filetostr(pXMLResponse)
* --- Parseamos el XML Response ---
* --- Para el ejemplo está así, manejando texto, ustedes deben manejar XML (falta de tiempo, perdón) ---

	sRespuestaWS = "Location:"+Chr(9)+ Strextract(sXMLResponse,'&lt;Location&gt;','&lt;/Location&gt;')+Chr(13)+Chr(10)
	sRespuestaWS = sRespuestaWS +"Time:"+Chr(9)+ Strextract(sXMLResponse,'&lt;Time&gt;','&lt;/Time&gt;')+Chr(13)+Chr(10)
	sRespuestaWS = sRespuestaWS +"Wind:"+Chr(9)+ Strextract(sXMLResponse,'&lt;Wind&gt;','&lt;/Wind&gt;')+Chr(13)+Chr(10)
	sRespuestaWS = sRespuestaWS +"Visibility:"+Chr(9)+ Strextract(sXMLResponse,'&lt;Visibility&gt;','&lt;/Visibility&gt;')+Chr(13)+Chr(10)
	sRespuestaWS = sRespuestaWS +"SkyConditions:"+Chr(9)+ Strextract(sXMLResponse,'&lt;SkyConditions&gt;','&lt;/SkyConditions&gt;')+Chr(13)+Chr(10)
	sRespuestaWS = sRespuestaWS +"Temperature:"+Chr(9)+ Strextract(sXMLResponse,'&lt;Temperature&gt;','&lt;/Temperature&gt;')+Chr(13)+Chr(10)
	sRespuestaWS = sRespuestaWS +"DewPoint:"+Chr(9)+ Strextract(sXMLResponse,'&lt;DewPoint&gt;','&lt;/DewPoint&gt;')+Chr(13)+Chr(10)
	sRespuestaWS = sRespuestaWS +"RelativeHumidity:"+Chr(9)+ Strextract(sXMLResponse,'&lt;RelativeHumidity&gt;','&lt;/RelativeHumidity&gt;')+Chr(13)+Chr(10)
	sRespuestaWS = sRespuestaWS +"Pressure:"+Chr(9)+ Strextract(sXMLResponse,'&lt;Pressure&gt;','&lt;/Pressure&gt;')

	This.borraArchivo(pXMLResponse)

	Return sRespuestaWS

	Endfunc


*---------------------------------------------------
	Function EjecutaWS(pURL_WSDL, pFileRequest , pFileResponse )
*---------------------------------------------------
	Try
		oHTTP = Createobject('Msxml2.ServerXMLHTTP.6.0')
		oHTTP.Open("POST", pURL_WSDL, .F.)
		oHTTP.setRequestHeader("User-Agent", "EjecutandoWS desde VFP - PortalFOX")
		oHTTP.setRequestHeader("Content-Type", "text/xml;charset=utf-8")
		oHTTP.Send(pFileRequest)
	Catch To loErr
		This.sError = "Error: " + Transform(loErr.ErrorNo) +  " Mensaje: " + loErr.Message
		This.iStatus = -1
	Endtry
	If This.iStatus != 0
		Return -1
	Endif
* --- Si el status es diferente a 200, ocurrió algún error de conectividad con el WS ---
	If oHTTP.Status = 200
		RespuestaWS = oHTTP.responseText
* --- Se genera el XML del response | Este es el paso 3!! ---
		Strtofile(Strconv(RespuestaWS,9),pXMLResponse)
		This.iStatus = 0
		This.sError = ""
		Return 0
	Else
		This.sError = "Error: No se logró la conexión con el Web Service."
		This.iStatus = -1
		Return -1
	Endif
	Endfunc
*---------------------------------------------------

*---------------------------------------------------
	Function CreaRequest(tcCiudad, tcPais)
*---------------------------------------------------
	TEXT TO sXMLRequest TEXTMERGE NOSHOW
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.webserviceX.NET">
   <soapenv:Header/>
   <soapenv:Body>
      <web:GetWeather>
         <web:CityName><<tcCiudad>></web:CityName>
         <web:CountryName><<tcPais>></web:CountryName>
      </web:GetWeather>
   </soapenv:Body>
</soapenv:Envelope>
	ENDTEXT
	Return sXMLRequest
	Endfunc
*---------------------------------------------------

*---------------------------------------------------
	Function borraArchivo(pFile)
*---------------------------------------------------
	If File(pFile)
		Delete File (pFile)
	Endif
	Endfunc
*---------------------------------------------------

*---------------------------------------------------
* Evento constructor
	Procedure Init
*---------------------------------------------------
	Lparameters tcURLWS
	This.sURL_WS = tcURLWS
	This.iStatus = 0
	This.sError = ""
	Endproc
*---------------------------------------------------

Enddefine





