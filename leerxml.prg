Local lcFilename As String, ;
	lnCount As Integer, ;
	lcXML As String, ;
	lcString As String

lcFilename = Getfile()
If Not File(lcFilename)
	Return
Endif
lcXML = Filetostr(lcFilename)
If "<DigestValue>" $ lcXML
	lnCount = 1
Else
	lnCount = 2
ENDIF
resp=""
For lnI = 1 To Occurs('<DigestValue>', lcXML)
	resp = Strextract(lcXML, '<DigestValue>', '</DigestValue>',lnI)
Next lnI
WAIT WINDOW +resp
retur
************
If "<cbc:ResponseCode>" $ lcXML
	lnCount = 1
Else
	lnCount = 2
ENDIF
resp1=""
For lnI = 1 To Occurs('<cbc:ResponseCode>', lcXML)
	resp1 = Strextract(lcXML, '<cbc:ResponseCode>', '</cbc:ResponseCode>',lnI)
Next lnI

WAIT WINDOW resp1+' '+resp

RETURN 
lcString = Strextract(lcXML, "<ds:DigestValue>", "</ds:DigestValue>", lnCount)
Do While Not Empty(lcString)
	WAIT WINDOW 'aca'
	? Strextract(lcString, "<ds:DigestValue>", "</ds:DigestValue>")
	lnCount = lnCount + 1
	lcString = Strextract(lcXML, "<ds:DigestValue>", "</ds:DigestValue>", lnCount)
Enddo

Retur

<DigestValue>


Local xdoc As MSXML2.DOMDocument

Clear
*!* Creamos un objeto basado en MSXML
xdoc=Createobject('MSXML2.DOMdocument')
*!* Cargamos el archivo XML a procesar
xdoc.Load('C:\data0\facturador\RPTA\R-20479597139-01-F001-0048395.xml')
*!* Llamamos a la función LeerCDs pasándole el nodo raíz (DCs)
LeerXml(xdoc.documentElement.childNodes)

Function LeerXml
Lparameters root As MSXML2.IXMLDOMNode

Local Child As MSXML2.IXMLDOMNode
*?STREXTRACT("<ds:DigestValue>IeDxKJIiygW6Oqls/h0uGZWBc8Y=</ds:DigestValue>","<ds:DigestValue>","</ds:DigestValue>",1)
*!* Aqui se procesan los nodos (DC,Artista,Titulo,Temas y Tema)
For Each Child In root
	? "Nombre del Nodo : "+Child.nodeName
	If Child.nodeName="cac:Signature" Then
		cTagName = Strextract(x,"<",">")
	Endif

Endfor
Endfunc

For lnI = 1 To Occurs('<ds:DigestValue>', lcXML)
	lcCompany = Strextract(lcXML, '<ds:DigestValue>', '</ds:DigestValue>',lnI)
Next lnI
