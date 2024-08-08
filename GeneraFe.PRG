loXmlHttp = Createobject("MSXML2.ServerXMLHTTP.6.0")
loXMLBody = Createobject("MSXML2.DOMDocument.6.0")
*?loXmlHttp, loXMLBody

lcURL   ="https://www.sunat.gob.pe:443/ol-ti-itcpgem-sqa/billService"

lcuserName=[20100000000USUARIOSOL]
lcPswd_Sol=[clavesol]
lcnamefilezip=[20100000000-01-F001-1.ZIP]
lcContZip=Filetostr(lcnamefilezip)
lcZipbase64=Strconv(lcContZip,13)

TEXT TO lcEnvioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
<soapenv:Envelope xmlns:ser="http://service.sunat.gob.pe"
xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
<soapenv:Header>
<wsse:Security>
<wsse:UsernameToken>
<wsse:Username><<lcUserName>></wsse:Username>
<wsse:Password><<lcPswd_Sol>></wsse:Password>
</wsse:UsernameToken>
</wsse:Security>
</soapenv:Header>
<soapenv:Body>
<ser:sendBill>
<fileName><<lcnamefilezip>></fileName>
<contentFile><<lczipbase64>></contentFile>
</ser:sendBill>
</soapenv:Body>
</soapenv:Envelope></soapenv:Envelope>
ENDTEXT

If Not loXMLBody.LoadXML( lcEnvioXML )
	Error loXMLBody.parseError.reason
Endif

loXmlHttp.Open( "POST", lcURL, .F. )
loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" )
loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
loXmlHttp.setRequestHeader( "SOAPAction" , "sendBill" )

loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )

loXmlHttp.Send(loXMLBody.documentElement.XML)

If loXmlHttp.Status # 200
	Error (Nvl(loXmlHttp.responseText,''))
Endif
