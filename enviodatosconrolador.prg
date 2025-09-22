Local oHTTP As "MSXML2.XMLHTTP"
Local lcHTML
url = "http://companysysven.com/registragrifovia.php"
*INSSQL7=SQLExec(NCONET,"INSERT INTO venta (transaction,codtienda,fecreg_inicio,volume,amount,price,TotalVolume,TotalAmount,fecreg_fin,TCVolume,estado,pump,nozzle,idgrade,gradename) VALUES
*('"+SQTRANSAC+"','"+SQSUCURSAL+"','"+SQFECINI+"','"+SQCANTGAL+"','"+SQIMPORTE+"','"+SQPUGAL+"','"+STCANTGAL+"','"+STIMPORTE+"','"+SQFECFIN+"','"+SQCONTOMETRO+"','"+SQESTADO+"','"+SQSURTIDOR+"','"+SQMANGUERA+"','"+SQCODIGO+"','"+SQPRODUCTO+"')")
TEXT To cdata Noshow Textmerge
	{
	"transaction":"<<SQTRANSAC>>",
	"codtienda":<<SQSUCURSAL>>,
	"fecreg_inicio":"<<SQFECINI>>",
	"volume":<<SQCANTGAL>>,
	"amount":<<SQIMPORTE>>,
	"price":<<SQPUGAL>>,
	"totalvolume":<<STCANTGAL>>,
	"totalamount":<<STIMPORTE>>,
	"fecreg_fin":"<<SQFECFIN>>",
	"tcvolume":<<SQCONTOMETRO>>,
	"estado":"<<SQESTADO>>",
	"pump":"<<SQSURTIDOR>>",
	"nozzle":"<<SQMANGUERA>>",
	"idgrade":"<<SQCODIGO>>",
	"gradename":"<<SQPRODUCTO>>"
	}
ENDTEXT
oHTTP = Createobject("MSXML2.XMLHTTP")
oHTTP.Open("post", url, .F.)
oHTTP.setRequestHeader("Content-Type", "application/json")
oHTTP.Send(cdata)
If oHTTP.Status <> 200 Then
	Return '0 Error'
Endif
lcHTML = oHTTP.responseText
Return '1 Ok'


