TEXT To cdata Noshow Textmerge
	{
	"ruc":"10452244549",
	"idauto":647,
	"motivo":"V"
	}
ENDTEXT
url="https://compania-sysven.com/app88/envioguia.php"
oHTTP = Createobject("MSXML2.XMLHTTP")
oHTTP.Open("post", url, .F.)
oHTTP.setRequestHeader("Content-Type", "application/json")
oHTTP.Send(cdata)
If oHTTP.Status<>200 Then
	?"Servicio WEB NO Disponible....."+Alltrim(Str(oHTTP.Status))
	Return 
Endif

lcHTML = oHTTP.Responsetext
Set Procedure  To d:\librerias\nfJsonRead.prg Additive
orpta = nfJsonRead(lcHTML)
If  Vartype(orpta.rpta)<>'U' Then
	?orpta.rpta
Else
	?Alltrim(lcHTML)
Endif

