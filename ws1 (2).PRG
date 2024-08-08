loXmlHttp = Createobject("MSXML2.ServerXMLHTTP.6.0")
loXMLBody = Createobject("MSXML2.DOMDocument.6.0")
lsURL  =  "https://ose.bizlinks.com.pe/ol-ti-itcpe/billService"
ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
ls_user = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
Endcase
cnum=Right("00000000"+Alltrim(cnumero),8)
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
loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
loXmlHttp.setRequestHeader( "SOAPAction" , "urn:getStatusCdr" )
loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
loXmlHttp.Send(loXMLBody.documentElement.XML)
If loXmlHttp.Status # 200 Then
	cerror=Nvl(loXmlHttp.responseText,'')
	crpta=Strextract(cerror, '<faultstring>', '</faultstring>',1)
	CMensaje1=Strextract(cerror, "<detail>","</detail>",1)
	Messagebox(crpta+' '+Alltrim(CMensaje1),16,MSGTITULO)
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
	Return 0
Endif
ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//document")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
If Type('oempresa')='U' Then
	cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+crespuesta
	cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'
Else
	cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+Alltrim(oempresa.nruc)+"\"+crespuesta
	cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"
Endif
decodefile(TxtB64.Text,cnombre)
oShell = Createobject("Shell.Application")
cfilerpta="R"
For Each oArchi In oShell.NameSpace(cnombre).Items
	If Left(oArchi.Name,1)='R' Then
		oShell.NameSpace(cDirDesti).CopyHere(oArchi)
		cfilerpta=Juststem(oArchi.Name)+'.XML'
	Endif
Endfor
If Type('oempresa')='U' Then
	rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+cfilerpta)
Else
	rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"+cfilerpta)
Endif
If Len(Alltrim(rptaSunat))>100 Then
	Messagebox(rptaSunat,64,'Sisven')
	Return 0
Endif
Do Case
Case Left(rptaSunat,1)='0'
	mensaje(rptaSunat)
	Return 1
Case Empty(rptaSunat)
	Messagebox(rptaSunat,64,'Sisven')
	Return 0
Otherwise
	Messagebox(rptaSunat,64,'Sisven')
	Return 0
Endcase
