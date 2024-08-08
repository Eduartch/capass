Local xdoc As MSXML2.DOMDocument
Clear
*!* Creamos un objeto basado en MSXML
xdoc=Createobject('MSXML2.DOMdocument')
*!* Cargamos el archivo XML a procesar
xdoc.Load("muestra.xml")
*!* Llamamos a la función LeerDatos pasándole el nodo raíz
LeerCDs(xdoc.documentElement.childNodes)

Function LeerDatos
Lparameters root As MSXML2.IXMLDOMNode

Local Child As MSXML2.IXMLDOMNode

*!* Aqui se procesan los nodos
For Each Child In root
	?Child.nodeName
	Do Case
	Case Child.nodeName=="Receptor"
		?Child.Attributes.Item(0).Text
		?Child.Attributes.Item(1).Text
	Case Child.nodeName=="Concepto"
		?Child.Attributes.Item(0).Text
		?Child.Attributes.Item(1).Text
		?Child.Attributes.Item(3).Text
	Case Child.nodeName=="Traslado"
		?Child.Attributes.Item(0).Text
		?Child.Attributes.Item(1).Text
		?Child.Attributes.Item(2).Text
	Endcase
*** Si el nodo que estamos procesando tiene descendencia volvemos a llamar a la función LeerCDs pasandole el nodo actual
*!* Esto sucede cuando se procesa el nodo (Traslados)
	If Child.hasChildNodes
		LeerCDs(Child.childNodes)
	Endif
Endfor
Endfunc
