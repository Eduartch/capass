set Procedure To d:\Librerias\qdfoxjson\qdfoxjson Additive
lcUrl = Textmerge("https://compania-sysven.com/ubigeos.php")
loXmlHttp = Createobject("Microsoft.XMLHTTP")
loXmlHttp.Open('GET', lcUrl, .F.)
loXmlHttp.setRequestHeader("Content-Type", "application/json")
loXmlHttp.Send()
If loXmlHttp.Status<>200 Then
	Messagebox("Servicio WEB NO Disponible....."+Alltrim(Str(loXmlHttp.Status)),16,'Sisven')
	Return
Endif
lcHTML = loXmlHttp.Responsetext
Create Cursor ubigeo(ubigeo c(8),distrito c(100),provincia c(100),departamento c(100))

Set Procedure  To d:\librerias\nfJsonRead.prg Additive
*otc = json_decode(lcHTML)
ubigeos = nfJsonRead(lcHTML)
For Each oub In ubigeos.array
    Insert Into ubigeo(ubigeo,distrito,provincia,departamento)Values(oub.ubigeo,oub.distrito,oub.provincia,oub.departamento)
ENDFOR 

*Set Procedure TO D:\Librerias\qdfoxjson\qdfoxjson ADDITIVE

* jsonString= loXMLHttp.responseText
*  jsonstart()
*  json.parseCursor(jsonString,'CursorTest')

*  BROWSE
* -- Add the other fields as appropriate.

*   Set Procedure To D:\Librerias\nfJson-master\nfJson\nfJsonRead additive
*   Create Cursor mydata (compra n(5,3),venta n(5,3))

*  loJson = nfjsonread(otc)

* For each loData in loJson.data

*     Insert into mydata values (loData.fecha, Val(loData.fine))

* EndFor


*?otc

Function UCES2Chr(tcTexto As String) As String

Local lcBSu As String, ;
	lcChr As String, ;
	lcHex As String, ;
	lcTexto As String, ;
	lnpos As Number

lcTexto = m.tcTexto
Do While "\u" $ m.lcTexto
	lnpos	= At("\u", m.lcTexto)
	lcBSu	= Substr(m.lcTexto, m.lnpos, 6)
	lcHex	= "0x" + Right(m.lcBSu, 4)
	lcChr	= Chr(Evaluate(m.lcHex))
	lcTexto	= Strtran(m.lcTexto, m.lcBSu, m.lcChr)
Enddo

Return m.lcTexto





Return
loIE=Createobject("InternetExplorer.Application")
loIE.Visible=.F.
dfecha="2020-11?fbclid=IwAR01lnc_1Etx44fkVCgzNyaFnNISQthk0UjkSY0q6pdVeqMxziJqh2drYLU"
loIE.Navigate("https://api.sunat.online/cambio/"+dfecha)
Do While loIE.readystate<>4
	Wait Window "Consultando Tipo de Cambio" Timeout 1
Enddo
*Do While Type("loIE.document.body.innerhtml")<>"C"
*loop till it's a character... sometimes it's just not quite ready
*Enddo
lcHTML=loIE.Document.body.innerhtml
otipoCambio = json_decode(lcHTML)
If Not Empty(json_getErrorMsg())
	Messagebox("No se Pudo Obtener la Información "+json_getErrorMsg(),16,'SISVEN')
	Return
Endif
?otipoCambio
