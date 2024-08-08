Declare Integer CryptBinaryToString In Crypt32;
	STRING @pbBinary, Long cbBinary, Long dwFlags,;
	STRING @pszString, Long @pcchString
Declare Integer CryptStringToBinary In crypt32;
	STRING @pszString, Long cchString, Long dwFlags,;
	STRING @pbBinary, Long @pcbBinary,;
	LONG pdwSkip, Long pdwFlags

#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056
SET DEFAULT TO c:\psysm\ 
loXmlHttp = Createobject("MSXML2.XMLHTTP.6.0")
loXMLBody = Createobject("MSXML2.DOMDocument.6.0")
lsURL  =  "https://ose.bizlinks.com.pe/ol-ti-itcpe/billService"
ls_pwd_sol = 'gUHdOKaw1TImYdD6'
ls_user = 'CMOVIZA_20440223622'
cnum=Right("00000000"+Alltrim("18532"),8)
LcRucEmisor="20440223622"
cserie="F001"
ctipodcto="01"
crespuesta='20440223622'+'-'+'01'+'-'+'F003'+'-'+'18532'+'.zip'
TEXT TO lcEnvioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe">
		<SOAP-ENV:Header xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
		<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
		<wsse:UsernameToken>
	    <wsse:Username><<ls_user>></wsse:Username>
		<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText"><<ls_pwd_sol>></wsse:Password></wsse:UsernameToken>
		</wsse:Security>
		</SOAP-ENV:Header>
		   <soapenv:Body>
		      <ser:getStatusCdr>
		         <!--Optional:-->
		         <statusCdr>
		            <!--Optional:-->
		             <numeroComprobante><<cnum>></numeroComprobante>
		            <!--Optional:-->
		             <rucComprobante><<LcRucEmisor>></rucComprobante>
		            <!--Optional:-->
		             <serieComprobante><<cserie>></serieComprobante>
		            <!--Optional:-->
		            	 <tipoComprobante><<ctipodcto>></tipoComprobante>
		         </statusCdr>
		      </ser:getStatusCdr>
		   </soapenv:Body>
		</soapenv:Envelope>
ENDTEXT
If Not loXMLBody.LoadXML( lcEnvioXML )
	Error loXMLBody.parseError.reason
	Return -1
Endif
loXmlHttp.Open( "POST", lsURL, .F. )
loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
loXmlHttp.setRequestHeader( "SOAPAction" , "urn:getStatusCdr" )

*SXH_OPTION_IGNORE_SERVER_SSL_CERT_ERROR_FLAGS 
*loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
*loXmlHttp.setOption( 2,SXH_OPTION_IGNORE_SERVER_SSL_CERT_ERROR_FLAGS )
loXmlHttp.Send(loXMLBody.documentElement.XML)
If loXmlHttp.Status # 200 Then
	cerror=Nvl(loXmlHttp.responseText,'')
	crpta=Strextract(cerror, '<faultstring>', '</faultstring>',1)
	CMensaje1=Strextract(cerror, "<detail>","</detail>",1)
	Messagebox(crpta+' '+Alltrim(CMensaje1),16,'Sisven')
	Return -1
Endif
loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
loXMLResp.LoadXML(loXmlHttp.responseText)
CmensajeError=leerXMl(Alltrim(loXmlHttp.responseText),"<faultcode>","</faultcode>")
CMensajeMensaje=leerXMl(Alltrim(loXmlHttp.responseText),"<faultstring>","</faultstring>")
CMensajedetalle=leerXMl(Alltrim(loXmlHttp.responseText),"<detail>","</detail>")
Cnumeromensaje=leerXMl(Alltrim(loXmlHttp.responseText),"<statusCode>","</statusCode>")
CMensaje1=leerXMl(Alltrim(loXmlHttp.responseText),"<statusMessage>","</statusMessage>")
If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Then
	Messagebox((Alltrim(CmensajeError)+' '+Alltrim(CMensajeMensaje)+' '+Alltrim(CMensajedetalle)+' '+Alltrim(CMensaje1)),16,'Sisven')
	Return 
Endif
ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//document")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
	cnombre='d:\psys\SunatXml\'+crespuesta
	cDirDesti = 'd:\psys\SunatXml\20440223622\'

decodefile(TxtB64.Text,cnombre)
oShell = Createobject("Shell.Application")
cfilerpta="R"
For Each oArchi In oShell.NameSpace(cnombre).Items
	If Left(oArchi.Name,1)='R' Then
		oShell.NameSpace(cDirDesti).CopyHere(oArchi)
		cfilerpta=Juststem(oArchi.Name)+'.XML'
	Endif
Endfor
*************************
Function leerXMl(lcXML,ctagi,ctagf)
Local lnCount As Integer
cvalor=""
For lnI = 1 To Occurs(ctagi, lcXML)
	cvalor = Strextract(lcXML, ctagi,ctagf,lnI)
Next lnI
Return cvalor
ENDFUNC
*******************
Procedure decodefile(pcB64, pcFile)
Local cBuff
cBuff = decodeString(pcB64)
Strtofile(cBuff, pcFile)
ENDPROC
********************
Function decodeString(pcB64)
Local nFlags, nBufsize, cDst
nFlags=1  && base64
nBufsize=0
pcB64 = Strt(Strt(Strt(pcB64,"\/","/"),"\u000d",Chr(13)),"\u000a",Chr(10))
CryptStringToBinary(@pcB64, Len(m.pcB64),nFlags, Null, @nBufsize, 0,0)
cDst = Replicate(Chr(0), m.nBufsize)
If CryptStringToBinary(@pcB64, Len(m.pcB64),nFlags, @cDst, @nBufsize, 0,0) = 0
	Return ""
Endif
Return m.cDst
Endproc