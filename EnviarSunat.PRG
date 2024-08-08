Declare Integer CryptBinaryToString In Crypt32;
	STRING @pbBinary, Long cbBinary, Long dwFlags,;
	STRING @pszString, Long @pcchString

Declare Integer CryptStringToBinary In crypt32;
	STRING @pszString, Long cchString, Long dwFlags,;
	STRING @pbBinary, Long @pcbBinary,;
	LONG pdwSkip, Long pdwFlags


#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056
ls_ruc_emisor="20479597139"
ls_pwd_sol = 'moddatos'
ls_user = ls_ruc_emisor + 'MODDATOS'
ps_fileZip = 'C:\Psys\FirmaXML\20479597139-01-F001-0048429.zip'
ls_fileName = Justfname(ps_fileZip)
ls_contentFile = Filetostr(ps_fileZip)
crespuesta='20479597139-01-F001-0048429'
ls_base64 = Strconv(ls_contentFile, 13) && Encoding base 64

TEXT TO ls_envioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
			<soapenv:Envelope xmlns:ser="http://service.sunat.gob.pe" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
					xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
				<soapenv:Header>
					<wsse:Security>
						<wsse:UsernameToken>
							<wsse:Username><<ls_user>></wsse:Username>
							<wsse:Password><<ls_pwd_sol>></wsse:Password>
						</wsse:UsernameToken>
					</wsse:Security>
				</soapenv:Header>
				<soapenv:Body>
					<ser:sendBill>
						<fileName><<ls_fileName>></fileName>
						<contentFile><<ls_base64>></contentFile>
					</ser:sendBill>
				</soapenv:Body>
			</soapenv:Envelope>
ENDTEXT

oXMLHttp=Createobject("MSXML2.ServerXMLHTTP.6.0")
oXMLBody=Createobject('MSXML2.DOMDocument.6.0')

If !(oXMLBody.LoadXML(ls_envioXML)) Then
	oResp.mensaje = "No se cargo XML: " + oXMLBody.parseError.reason
	Return .F.
Endif

lsURL   = "https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService"
oXMLHttp.Open('POST', lsURL, .F.)
oXMLHttp.setRequestHeader( "Content-Type", "text/xml" )
oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" )
oXMLHttp.setRequestHeader( "Content-Length", Len(ls_envioXML) )
oXMLHttp.setRequestHeader( "SOAPAction" , "sendBill" )

oXMLHttp.setOption(2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS)
oXMLHttp.Send(oXMLBody.documentElement.XML)

If (oXMLHttp.Status <> 200) Then
	Messagebox('STATUS: ' + Alltrim(Str(oXMLHttp.Status)) + '-' + Nvl(oXMLHttp.responseText,''))
	Return
Endif

loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
loXMLResp.LoadXML(oXMLHttp.responseText)
Messagebox(oXMLHttp.responseText)

ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
ArchivoRespuestaSunat.LoadXML(oXMLHttp.responseText)			&&Llenamos el archivo de respuesta
TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//applicationResponse")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+crespuesta+'.zip'
decodefile(TxtB64.Text,cnombre)

&&Rutina para decodificar el base64 a zip este codigo lo obtuve de la pagina de Victor Espina el link directo esta aca(http://victorespina.com.ve/wiki/index.php?title=Parser_Base64_para_VFP_usando_CryptoAPI)
******************************
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
*****************************
Procedure decodefile(pcB64, pcFile)
Local cBuff
cBuff = decodeString(pcB64)
Strtofile(cBuff, pcFile)
Endproc
**************************
