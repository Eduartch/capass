*dfecha="2020-11?fbclid=IwAR01lnc_1Etx44fkVCgzNyaFnNISQthk0UjkSY0q6pdVeqMxziJqh2drYLU"
*lcUrl = Textmerge("https://api.sunat.online/cambio/<<dfecha>>>")

Local loXmlHttp As "Microsoft.XMLHTTP"
Local lcHTML, lcURL, ls_compra, ls_venta
*:Global cmensaje, cndoc, cticket, dfecha, nidauto
*:Global cdata, d, fecha, ff, fi, i, otc, ovalor, x
Close All
Clear All
Set Procedure To d:\librerias\json Additive
m.lcURL		= "http://app88.test:8080/apisunat20.php"
m.loXmlHttp	= Createobject("Microsoft.XMLHTTP")
fi			= "2018-01-01"
ff			= "2022-07-07"
TEXT To cdata Noshow Textmerge
	{
	"fi":"<<fi>>",
	"ff":"<<ff>>",
	"ruc":"10410527362"
	}
ENDTEXT
m.loXmlHttp.Open('POST', m.lcURL, .F.)
m.loXmlHttp.setRequestHeader("Content-Type", "application/json;utf-8")
m.loXmlHttp.Send(cdata)
If m.loXmlHttp.Status <> 200 Then
	Messagebox("Servicio WEB NO Disponible....." + Alltrim(Str(m.loXmlHttp.Status)), 16, 'Sisven')
	Return
Endif
m.lcHTML = m.loXmlHttp.responseText
*MESSAGEBOX(lcHTML)
*RETURN
If Atc('idauto', m.lcHTML) > 0 Then
	otc = json_decode(m.lcHTML)
	If Not Empty(json_getErrorMsg())
		Messagebox("No se Pudo Obtener la Información " + json_getErrorMsg(), 16, 'SISVEN')
		Return
	Endif
	x=1
	CREATE CURSOR boletas(idauto n(10),ndoc c(12),fech d,mensaje c(50),ticket c(30))
	For i = 1 To otc._Data.getSize()
		ovalor=otc._Data.Get(x)
		If (Vartype(ovalor) = 'O') Then
			nidauto	 = VAL(ovalor.Get("idauto"))
			dFecha	 = ovalor.Get("fech")
			cndoc	 = ovalor.Get('ndoc')
			Cmensaje = ovalor.Get("mensaje")
			cticket	 = ovalor.Get("ticket")
			df=CTOD(right(dfecha,2)+'/'+SUBSTR(dfecha,6,2)+'/'+LEFT(dfecha,4))
		    INSERT INTO boletas(idauto,ndoc,fech,mensaje,ticket)values(nidauto,cndoc,df,cmensaje,cticket)
		Endif
		x=x+1
	Next
Else
	Messagebox("Noa hay Infornacíon Para Consultar ", 16, 'SISVEN')
Endif
