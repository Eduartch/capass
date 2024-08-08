#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056

lcRuc_emisor = '20481499284'
lcUser_Sol = "UISTICAL"
lcPswd_Sol = "inserpeac"
*-
lcUserName = lcRuc_emisor + lcUser_Sol
*-
lcTip_Documento = "01"
lcSerie_Doc = "F001"
lcNumeroDoc = "9419"
*-

loXmlHttp = Createobject("MSXML2.ServerXMLHTTP.6.0")
loXMLBody = Createobject("MSXML2.DOMDocument.6.0")
?loXmlHttp, loXMLBody

lcURL   = "https://www.sunat.gob.pe/ol-it-wsconscpegem/billConsultService"
           

*lcURL   = "https://www.sunat.gob.pe:443/ol-it-wsconscpegem/billConsultService"
*lcURL   = "https://"+"190.108.95.72"+"/ol-it-wsconscpegem/billConsultService"
*lcURL    = "https://www.sunat.gob.pe:443/ol-it-wsconscpegem/billConsultService?wsdl"
*	<rucComprobante>10166772040</rucComprobante>
TEXT TO lcEnvioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
	<soapenv:Envelope xmlns:ser="http://service.sunat.gob.pe"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
	<soapenv:Header>
	<wsse:Security>
	<wsse:UsernameToken>
	<wsse:Username><<lcUsername>></wsse:Username>
	<wsse:Password><<lcPswd_Sol>></wsse:Password>
	</wsse:UsernameToken>
	</wsse:Security>
	</soapenv:Header>
	<soapenv:Body>
	<ser:getStatus>
	<rucComprobante>20481499284</rucComprobante>
	<tipoComprobante>01</tipoComprobante>
	<serieComprobante>F001</serieComprobante>
	<numeroComprobante>9444</numeroComprobante>
	</ser:getStatus>
	</soapenv:Body>
	</soapenv:Envelope>
ENDTEXT


?lcEnvioXML

If Not loXMLBody.LoadXML( lcEnvioXML )
	Error loXMLBody.parseError.reason
	Return
Endif

loXmlHttp.Open( "POST", lcURL, .F. )
loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" )
loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
loXmlHttp.setRequestHeader( "SOAPAction" , "getStatus" )
loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )

loXmlHttp.Send(loXMLBody.documentElement.XML)
?loXmlHttp.Status
If loXmlHttp.Status # 200 Then
    cerror=Nvl(loXmlHttp.responseText,'')
    crpta=Strextract(cerror, '<faultstring>', '</faultstring>',1)
    * cerror
    ?"Rpta:"+crpta
   * Error (Nvl(loXmlHttp.responseText,''))
	Return
Endif

*-- Aquí se lee el contenido del XML de la propiedad "loXmlHttp.responseText"
*res = CreateObject("MSXML2.DOMDocument")
res = Createobject("MSXML2.DOMDocument.6.0")
res.LoadXML(loXmlHttp.responseText)
txtCod = res.selectSingleNode("//statusCode")  &&Return
WAIT WINDOW "Codigo Respuesta : "+txtCod.Text
txtMsg = res.selectSingleNode("//statusMessage")  &&Return
WAIT WINDOW txtMsg.Text
