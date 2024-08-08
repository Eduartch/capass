Select Padr('Customer_'+cust_id,20) As NodeID, ;
	PADR('',20) As ParentID, ;
	PADR(Company,100) As NodeText, ;
	0 As Level ;
	FROM (Home(2)+'data\customer') ;
	UNION ;
	SELECT Padr('Orders_'+order_id,20) As NodeID, ;
	PADR('Customer_'+c.cust_id,20) As ParentID, ;
	PADR(Alltrim(Transform(order_id))+":"+Transform(Order_Date),100) As NodeText, ;
	1 As Level ;
	FROM (Home(2)+'data\Orders') o ;
	INNER Join (Home(2)+'data\customer') c On o.cust_id == c.cust_id ;
	UNION ;
	SELECT 'OrdItems_'+oi.order_id+'_'+Padl(line_no,3,'0') As NodeID, ;
	'Orders_'+o.order_id As ParentID, ;
	TRANSFORM(oi.line_no)+':'+p.Prod_Name-(' ['+Transform(oi.Quantity)+']') As NodeText, ;
	2 As Level ;
	FROM (Home(2)+'data\OrdItems') oi ;
	INNER Join (Home(2)+'data\Orders') o On oi.order_id == o.order_id ;
	INNER Join (Home(2)+'data\customer') c On o.cust_id == c.cust_id ;
	INNER Join (Home(2)+'data\products') p On oi.product_id == p.product_id ;
	ORDER By Level ;
	INTO Cursor myTree ;
	nofilter

#Define tvwFirst 0
#Define tvwLast 1
#Define tvwNext 2
#Define tvwPrevious 3
#Define tvwChild 4

Public oForm
oForm = Createobject('myTreeForm','myTree')
oForm.Show

Define Class myTreeForm As Form
	Height = 640
	Width = 800
	AutoCenter = .T.
	Caption = "TreeView - TestPad"

	nxtwips = 0
	nytwips = 0
	cursorbehind = ''

	Add Object TreeView As OleControl With ;
		HEIGHT = 640, Width = 800, ;
		anchor = 15, OleClass = 'MSComCtlLib.TreeCtrl.2'

	Procedure Init
	Lparameters tcCursorName
	With This.TreeView
		.linestyle =1
		.labeledit =1
		.indentation = 5
		.PathSeparator = '\'
		.Scroll = .T.
		.OLEDragMode = 0
		.OLEDropMode = 0
	Endwith
	This.cursorbehind = m.tcCursorName
	This.PixelToTwips()
	This.Populate()
	Endproc

	Procedure Populate
	Select (This.cursorbehind)
	With This.TreeView.Nodes
		Scan
			If Empty(ParentID)
				oNode = .Add(,tvwFirst,Trim(NodeID),Trim(NodeText))
				oNode.Bold = .T.
			Else
				oNode = .Add(Trim(ParentID),tvwChild,Trim(NodeID) ,Trim(NodeText))
				If Occurs('\',oNode.Fullpath)=1
					oNode.BackColor = 0x00FFFF
					oNode.ForeColor = 0xFF0000
				Endif
				If Occurs('\',oNode.Fullpath)=2
					oNode.ForeColor = 0x0000FF
				Endif
			Endif
		Endscan
	Endwith
	Endproc

	Procedure PixelToTwips
	Local liHDC, liPixelsPerInchX, liPixelsPerInchY
	#Define cnLOG_PIXELS_X 88
	#Define cnLOG_PIXELS_Y 90
	#Define cnTWIPS_PER_INCH 1440

	Declare Integer GetActiveWindow In WIN32API
	Declare Integer GetDC In WIN32API Integer iHDC
	Declare Integer GetDeviceCaps In WIN32API Integer iHDC, Integer iIndex

	liHDC = GetDC(GetActiveWindow())

	liPixelsPerInchX = GetDeviceCaps(liHDC, cnLOG_PIXELS_X)
	liPixelsPerInchY = GetDeviceCaps(liHDC, cnLOG_PIXELS_Y)

	This.nxtwips = ( cnTWIPS_PER_INCH / liPixelsPerInchX )
	This.nytwips = ( cnTWIPS_PER_INCH / liPixelsPerInchY )
	Endproc

	Procedure TreeView.MouseMove
	Lparameters Button, Shift, x, Y
	With Thisform
		oHitTest = This.HitTest( x * .nxtwips, Y * .nytwips )
		If Type("oHitTest")= "O" And !Isnull(oHitTest)
			Wait Window Nowait oHitTest.Fullpath
		Endif
	Endwith
	oHitTest = .Null.
	Endproc

	Procedure TreeView.NodeClick
	Lparameters oNode
	Local aNodeInfo[1]
	If Alines(aNodeInfo,oNode.Key,1,'_') = 2 && Customer or orders
		If Lower(aNodeInfo[1]) == 'customer'
			Select * From customer Where cust_id = aNodeInfo[2]
		Else
			Select * From orders Where Val(order_id) = Val(aNodeInfo[2])
		Endif
	Else
		Select * From orditems ;
			WHERE Val(order_id) = Val(aNodeInfo[2]) And line_no = Val(aNodeInfo[3])
	Endif
	Endproc
Enddefine
