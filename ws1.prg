oWS = CREATEOBJECT( "VFP_WebService","http://www.webservicex.net/globalweather.asmx?WSDL") 
lcRespuesta = oWS.GetWeather("Torreon, Coah.","Mexico")
IF oWS.iStatus != 0
	MESSAGEBOX(oWS.sError,16,"Error al ejecutar WS")
ELSE
	MESSAGEBOX(lcRespuesta,64,"EjecutandoWS desde VFP - PortalFOX")
ENDIF  



DEFINE CLASS VFP_WebService AS CUSTOM

	* --- Definimos las propiedades ---
	sError = ""
	iStatus = 0	
	sURL_WS = ""

	* --- Definimos la función del WebService ---
	FUNCTION GetWeather (tcCiudad, tcPais)

		* --- Paso 1. Creo el XML Request ---
		sXMLRequest = this.CreaRequest(tcCiudad, tcPais)
				
		pXMLResponse = ADDBS(SYS(2023)) + SYS(2015) + [.xml]
		
		* --- Paso 2. Ejecuto el WS | Paso 3. Obtengo el Response ---
		this.iStatus =  this.EjecutaWS( this.sURL_WS, sXMLRequest , pXMLResponse )

		IF this.iStatus != 0  && Ocurrió un error el cual está especificado en sError.
			RETURN ""
		ENDIF	

		sXMLResponse = FILETOSTR(pXMLResponse)
		* --- Parseamos el XML Response ---
		* --- Para el ejemplo está así, manejando texto, ustedes deben manejar XML (falta de tiempo, perdón) ---

		sRespuestaWS = "Location:"+CHR(9)+ STREXTRACT(sXMLResponse,'&lt;Location&gt;','&lt;/Location&gt;')+CHR(13)+CHR(10)
		sRespuestaWS = sRespuestaWS +"Time:"+CHR(9)+ STREXTRACT(sXMLResponse,'&lt;Time&gt;','&lt;/Time&gt;')+CHR(13)+CHR(10)
		sRespuestaWS = sRespuestaWS +"Wind:"+CHR(9)+ STREXTRACT(sXMLResponse,'&lt;Wind&gt;','&lt;/Wind&gt;')+CHR(13)+CHR(10)
		sRespuestaWS = sRespuestaWS +"Visibility:"+CHR(9)+ STREXTRACT(sXMLResponse,'&lt;Visibility&gt;','&lt;/Visibility&gt;')+CHR(13)+CHR(10)
		sRespuestaWS = sRespuestaWS +"SkyConditions:"+CHR(9)+ STREXTRACT(sXMLResponse,'&lt;SkyConditions&gt;','&lt;/SkyConditions&gt;')+CHR(13)+CHR(10)
		sRespuestaWS = sRespuestaWS +"Temperature:"+CHR(9)+ STREXTRACT(sXMLResponse,'&lt;Temperature&gt;','&lt;/Temperature&gt;')+CHR(13)+CHR(10)
		sRespuestaWS = sRespuestaWS +"DewPoint:"+CHR(9)+ STREXTRACT(sXMLResponse,'&lt;DewPoint&gt;','&lt;/DewPoint&gt;')+CHR(13)+CHR(10)
		sRespuestaWS = sRespuestaWS +"RelativeHumidity:"+CHR(9)+ STREXTRACT(sXMLResponse,'&lt;RelativeHumidity&gt;','&lt;/RelativeHumidity&gt;')+CHR(13)+CHR(10)
		sRespuestaWS = sRespuestaWS +"Pressure:"+CHR(9)+ STREXTRACT(sXMLResponse,'&lt;Pressure&gt;','&lt;/Pressure&gt;')
		
		this.borraArchivo(pXMLResponse)
		
		RETURN sRespuestaWS
	
	ENDFUNC 
	
	
	*---------------------------------------------------
	FUNCTION EjecutaWS(pURL_WSDL, pFileRequest , pFileResponse )
	*---------------------------------------------------
	   TRY 
	    oHTTP = CREATEOBJECT('Msxml2.ServerXMLHTTP.6.0')
	    oHTTP.OPEN("POST", pURL_WSDL, .F.)
	    oHTTP.setRequestHeader("User-Agent", "EjecutandoWS desde VFP - PortalFOX")
	    oHTTP.setRequestHeader("Content-Type", "text/xml;charset=utf-8")
	    oHTTP.SEND(pFileRequest)
	   CATCH TO loErr
	   		this.sError = "Error: " + TRANSFORM(loErr.ErrorNo) +  " Mensaje: " + loErr.Message
	   		this.iStatus = -1	   		
	   ENDTRY 
	   IF this.iStatus != 0
	   	RETURN -1
	   ENDIF 
	    * --- Si el status es diferente a 200, ocurrió algún error de conectividad con el WS ---
	    IF oHTTP.STATUS = 200
	        RespuestaWS = oHTTP.responseText
		    * --- Se genera el XML del response | Este es el paso 3!! ---
		    STRTOFILE(STRCONV(RespuestaWS,9),pXMLResponse)
		    this.iStatus = 0
		    this.sError = ""
		    RETURN 0
	    ELSE
	        this.sError = "Error: No se logró la conexión con el Web Service."
	        this.iStatus = -1
			RETURN -1
	    ENDIF
	ENDFUNC 
	*---------------------------------------------------

	*---------------------------------------------------
	FUNCTION CreaRequest(tcCiudad, tcPais)
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
		RETURN sXMLRequest
	ENDFUNC 	
	*---------------------------------------------------

	*---------------------------------------------------
	FUNCTION BorraArchivo(pFile)
	*---------------------------------------------------
		IF FILE(pFile)
			DELETE FILE (pFile)
		ENDIF 
	ENDFUNC 
	*---------------------------------------------------

	*---------------------------------------------------
	* Evento constructor
	PROCEDURE Init
	*---------------------------------------------------
		LPARAMETERS tcURLWS
        this.sURL_WS = tcURLWS
        this.iStatus = 0
        this.sError = ""
	ENDPROC
	*---------------------------------------------------

ENDDEFINE 





