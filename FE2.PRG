Local loService As "XML Web Service"
Set Safety Off
Local loException, lcErrorMsg, loWSHandler
Local lcArgumento1,loRespuesta,lcRespuesta,lnParte
Try
	loWSHandler =
	Newobject("WSHandler",Iif(Version(2)=0,"",Home()+"FFC\")+"_ws3client.vcx")
	loService = loWSHandler.SetupClient(This.WebServiceWsfe, "Service",
	"ServiceSoap")

	TEXT TO lcPregunta NOSHOW TEXTMERGE PRETEXT 7
<?xml version="1.0" encoding="utf-8"?>
 <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance";
xmlns:xsd="http://www.w3.org/2001/XMLSchema"; xmlns:soap="
http://schemas.xmlsoap.org/soap/envelope/";>
   <soap:Body>
     <FERecuperaQTYRequest xmlns="http://ar.gov.afip.dif.facturaelectronica/
">
       <argAuth>
<Token><<This.Token>></Token>
<Sign><<This.Sign>></Sign>
 <cuit><<This.CuitCont>></cuit>
       </argAuth>
     </FERecuperaQTYRequest>
   </soap:Body>
</soap:Envelope>
	ENDTEXT

	lcNroArchLog=Sys(2015)
	If This.CreaLog
		lcArchLog=This.RutaTemporal+"P"+lcNroArchLog+".xml"
		Strtofile(lcPregunta,lcArchLog)
	Endif
*************-Creamos el Sobre - ************
** Direccion Web Services
	loHTTP = Createobject('MSXML2.XMLHTTP')
	loHTTP.Open("post", This.WebServiceWsfe, .F.)
	loHTTP.setRequestHeader("Content-Type", "text/xml;charset=utf-8")
*-Decimos qué objeto queremos instanciar y qué método y en qué lugar está

	lcOperacion=Getwordnum(This.WebServiceWsfe,1,"?")+"?op=FERecuperaQTYRequest"
	loHTTP.setRequestHeader("ServiceSoap", lcOperacion)
*- Enviamos el Request
	loHTTP.Send(lcPregunta)
	If loHTTP.Status = 200
*- La respuesta en formato Text
		lcRespuesta = loHTTP.responseText
	Else
		lcErrorMsg="Error: "+ Transform(loHTTP.Status,"999999")+" -
		"+loHTTP.statusText"
	Endif
*- Libera el objeto
	loHTTP = Null

Catch To loException
	lcErrorMsg="Error: "+Transform(loException.ErrorNo,"999999")+" -
	"+loException.Message"
	Do Case
	Case Vartype(loService)#"O"
* Handle SOAP error connecting to web service
		lcErrorMsg=lcErrorMsg+Chr(13)+"Verifique conexión de Internet"
	Case !Empty(loService.FaultCode)
* Handle SOAP error calling method
		lcErrorMsg=lcErrorMsg+Chr(13)+loService.Detail
	Otherwise
* Handle other error
		lcErrorMsg=loService.Detail
	Endcase
* Use for debugging purposes
	This.MsgError=lcErrorMsg
Finally
Endtry
If !Empty(lcErrorMsg)
	This.CantidadMaxOk=.F.
Else
	This.MaximoRegDet=1
	lnError=0
	lcMsgError=""
	If This.CreaLog
		lcArchLog=This.RutaTemporal+"R"+lcNroArchLog+".xml"
		Strtofile(lcRespuesta,lcArchLog)
	Endif
	For lnParte=1 To Getwordcount(lcRespuesta,'<')
		Do Case
		Case Getwordnum(Getwordnum(lcRespuesta,lnParte,'<'),1,'>')='value'

			This.MaximoRegDet=Val(Getwordnum(Getwordnum(lcRespuesta,lnParte,'<'),2,'>'))
		Case Getwordnum(Getwordnum(lcRespuesta,lnParte,'<'),1,'>')='percode'
			lnError=Val(Getwordnum(Getwordnum(lcRespuesta,lnParte,'<'),2,'>'))
		Case Getwordnum(Getwordnum(lcRespuesta,lnParte,'<'),1,'>')='perrmsg'
			lcMsgError=Getwordnum(Getwordnum(lcRespuesta,lnParte,'<'),2,'>')
		Endcase
	Next lnParte
	If lnError>0
		lcErrorMsg="Error: "+Transform(lnError,"999999")+" - "+lcMsgError
		This.CantidadMaxOk=.F.
		This.MsgError=lcErrorMsg
	Else
		This.CantidadMaxOk=.T.
	Endif
Endif
