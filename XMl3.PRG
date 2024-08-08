Close Databases All
Open Database (Home(2)) + "Northwind\northwind.dbc"

* Create XML
Select 0
Use northwind!OrderDetails
Set Order To ORDERID
Select 0
Use northwind!Orders
Set Relation To ORDERID Into OrderDetails
oXA = Createobject("XmlAdapter")
* The next setting is required to create nested XML
oXA.RespectNesting = .T.
oXA.AddTableSchema("Orders")
oXA.AddTableSchema("OrderDetails")
* Save XML in the current directory
oXA.ToXML("Orders.xml",,.T.)
* View created XML
Modify Command Orders.XML
*
* Now load created XML back
*
Close Databases All
* Load XML
oXA = Createobject("XmlAdapter")
oXA.RespectNesting = .T.
oXA.LoadXML("Orders.xml",.T.)
For i=1 To oXA.Tables.Count
	oXA.Tables(i).ToCursor()
Endfor
Set
