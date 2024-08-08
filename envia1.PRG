Declare Integer CryptBinaryToString In Crypt32;
	STRING @pbBinary, Long cbBinary, Long dwFlags,;
	STRING @pszString, Long @pcchString

Declare Integer CryptStringToBinary In crypt32;
	STRING @pszString, Long cchString, Long dwFlags,;
	STRING @pbBinary, Long @pcbBinary,;
	LONG pdwSkip, Long pdwFlags


#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056
*Set Library To Locfile("vfpcompression.fll")
*ZipfileQuick(goapp.carchivo)
*zipclose()
ls_ruc_emisor='20479597139'
ls_pwd_sol = '20479597139'
ls_user = ls_ruc_emisor + '20479597139'
*npos=At('.',goapp.carchivo)
carchivozip='C:\Psys\FirmaXML\20479597139-RA-20161105-1'
ps_fileZip = carchivozip+'.zip'
ls_fileName = Justfname(ps_fileZip)
ls_contentFile = Filetostr(ps_fileZip)
crespuesta=ls_fileName
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
					<ser:sendSummary>
						<fileName><<ls_fileName>></fileName>
						<contentFile><<ls_base64>></contentFile>
					</ser:sendSummary>
				</soapenv:Body>
			</soapenv:Envelope>
ENDTEXT

oXMLHttp=Createobject("MSXML2.ServerXMLHTTP.6.0")
oXMLBody=Createobject('MSXML2.DOMDocument.6.0')

If !(oXMLBody.LoadXML(ls_envioXML)) Then
	oResp.mensaje = "No se cargo XML: " + oXMLBody.parseError.reason
	Return .F.
Endif
*Do Case
*Case goapp.tipoh=='B'
*	lsURL   = "https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService"
*Case goapp.tipoh=='H'
	lsURL   = "https://www.sunat.gob.pe/ol-ti-itcpgem-sqa/billService"
*Otherwise
*	lsURL   = "https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService"
*ENDCASE
oXMLHttp.Open('POST', lsURL, .F.)
oXMLHttp.setRequestHeader( "Content-Type", "text/xml" )
oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" )
oXMLHttp.setRequestHeader( "Content-Length", Len(ls_envioXML) )
oXMLHttp.setRequestHeader( "SOAPAction" , "sendSummary" )
oXMLHttp.setOption(2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS)
oXMLHttp.Send(oXMLBody.documentElement.XML)
WAIT WINDOW 'aca xx'
If (oXMLHttp.Status <> 200) Then
	Messagebox('STATUS: ' + Alltrim(Str(oXMLHttp.Status)) + '-' + Nvl(oXMLHttp.responseText,''))
	Return
Endif
WAIT WINDOW  'aca xxx'
loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
loXMLResp.LoadXML(oXMLHttp.responseText)
Messagebox(oXMLHttp.responseText)
ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
ArchivoRespuestaSunat.LoadXML(oXMLHttp.responseText)			&&Llenamos el archivo de respuesta
TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//applicationResponse")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+crespuesta
decodefile(TxtB64.Text,cnombre)
cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'
oShell = Createobject("Shell.Application")
For Each oArchi In oShell.NameSpace(cnombre).Items
	If Left(oArchi.Name,1)='R' Then
		oShell.NameSpace(cDirDesti).CopyHere(oArchi)
		cfilerpta=Juststem(oArchi.Name)+'.'+Justext(oArchi.Name)
	Endif
Endfor
rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+cfilerpta)
Messagebox(rptaSunat,64,'Sisven')