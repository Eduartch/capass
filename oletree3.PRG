#Define tvwFirst    0
#Define tvwLast    1
#Define tvwNext    2
#Define tvwPrevious    3
#Define tvwChild    4

#Define cnLOG_PIXELS_X 88
#Define cnLOG_PIXELS_Y 90
#Define cnTWIPS_PER_INCH 1440

TEXT to myMenu noshow
Lparameters toNode,toForm

DEFINE POPUP shortcut SHORTCUT RELATIVE FROM MROW(),MCOL()
DEFINE BAR 1 OF shortcut PROMPT "Key"
DEFINE BAR 2 OF shortcut PROMPT "Text"
DEFINE BAR 3 OF shortcut PROMPT "Fullpath"
DEFINE BAR 4 OF shortcut PROMPT "Index"
DEFINE BAR 5 OF shortcut PROMPT "New Item"
ON SELECTION BAR 1 OF shortcut ;
    wait window toNode.Key timeout 2
ON SELECTION BAR 2 OF shortcut  ;
    wait window toNode.Text timeout 2
ON SELECTION BAR 3 OF shortcut  ;
    wait window toNode.Fullpath timeout 2
ON SELECTION BAR 4 OF shortcut  ;
    wait window Transform(toNode.Index) timeout 2
ON SELECTION BAR 5 OF shortcut toForm.ShowIt(toNode)
ACTIVATE POPUP shortcut

ENDTEXT

*StrToFile(m.myMenu,'myTVShcut.mpr')

oForm = Createobject('myForm')
With oForm
	.AddObject('Tree','myTreeView')
	.AddObject('Lister','Lister')
	With .Tree
		.Width = 700
		.Height = 600
		.Nodes.Add(,0,"root0",'Main node 1')
		.Nodes.Add(,0,"root1",'Main node 2')
		.Nodes.Add(,0,"root2",'Main node 3')
		.Nodes.Add('root1',4,"child11",'Child11')
		.Nodes.Add('root1',4,"child12",'Child12')
		.Nodes.Add('root2',4,"child21",'Child22')
		.Nodes.Add('child21',3,"child20",'Child21')
		oNodx=.Nodes.Add('child11',4,"child111",'child113')
		oNodx.Bold=.T.
		.Nodes.Add('child111',3,"child112",'child112')
		.Nodes.Add('child112',3,"child113",'child111')

		.Nodes.Add('child12',4,"child121",'child121')
		.Nodes.Add('child12',4,"child122",'child122')

		.Nodes.Add('child112',4,"child1121",'child1121')
		.Nodes.Add('child112',4,"child1122",'child1122')
		.Nodes.Add('child112',4,"child1123",'child1123')
		.Nodes.Add('child112',4,"child1124",'child1124')
		.Nodes.Add('child112',4,"child1125",'child1125')

		.Nodes.Add('child1121',4,"child11211",'child11211')
		.Nodes.Add('child1121',4,"child11212",'child11212')

		.Nodes.Add('child11211',4,"child112111",'child112111')
		.Nodes.Add('child11212',4,"child112121",'child112121 last added')
		.Visible = .T.
		.Nodes(.Nodes.Count).Ensurevisible
		With .Font
			.Size = 12
			.Name = 'Times New Roman'
			.Bold = .F.
			.Italic = .T.
		Endwith
	Endwith
	.Lister.Left = .Width - .Lister.Width
	.Lister.Visible = .T.
	.Show()
Endwith
Read Events

Function TVLister
Lparameters toTV
Local lnIndex,lnLastIndex
With toTV
	lnIndex     = .Nodes(1).Root.FirstSibling.Index
	lnLastIndex = .Nodes(1).Root.LastSibling.Index
	_GetSubNodes(lnIndex,toTV,lnIndex)
	Do While lnIndex # lnLastIndex
		lnIndex = .Nodes(lnIndex).Next.Index
		_GetSubNodes(lnIndex,toTV,lnIndex)
	Enddo
Endwith

Function _GetSubNodes
Lparameters tnIndex, toTV, tnRootIndex
Local lnIndex, lnLastIndex
With toTV
	WriteNode(tnIndex,toTV, tnRootIndex)
	If .Nodes(tnIndex).Children > 0
		lnIndex  = .Nodes(tnIndex).Child.Index
		lnLastIndex = .Nodes(tnIndex).Child.LastSibling.Index
		_GetSubNodes(lnIndex,toTV,tnRootIndex)
		Do While lnIndex # lnLastIndex
			lnIndex = .Nodes(lnIndex).Next.Index
			_GetSubNodes(lnIndex,toTV,tnRootIndex)
		Enddo
	Endif
Endwith

Function WriteNode
Lparameters tnCurIndex, toTV,tnRootIndex
Local lnRootIndex, lnIndex, lcPrefix, lcKey, lnLevel
lnIndex = tnCurIndex

With toTV
	lcPrefix = '+-' + .Nodes(lnIndex).Text
	lnLevel = 0
	Do While lnIndex # tnRootIndex
		lnIndex = .Nodes(lnIndex).Parent.Index
		lcPrefix = Iif(.Nodes(lnIndex).LastSibling.Index = lnIndex,' ','|')+Space(3)+lcPrefix
		lnLevel = lnLevel + 1
	Enddo
	? lcPrefix
Endwith

Function WalkTree
Lparameters oNode,lnIndent,tlPlus
? Iif(tlPlus,'+','')+Replicate(Chr(9),lnIndent)+oNode.Text
If !Isnull(oNode.Child)
	WalkTree(oNode.Child,lnIndent+1,.T.)
Endif
If !Isnull(oNode.Next)
	WalkTree(oNode.Next,lnIndent,.F.)
Endif
Return
Endfunc

Define Class myForm As Form
	AutoCenter = .T.
	Height = 640
	Width = 800

	nxtwips = .F.
	nytwips = .F.

	Procedure QueryUnload
	Clear Events
	Endproc

	Procedure ShowIt
	Lparameters toNode
	Messagebox("Form method called with " + toNode.Fullpath)
	Endproc

	Procedure Init
*-- Code for PixelToTwips method
	Local liHWnd, liHDC, liPixelsPerInchX, liPixelsPerInchY

* Declare some Windows API functions.
	Declare Integer GetActiveWindow In WIN32API
	Declare Integer GetDC In WIN32API Integer iHDC
	Declare Integer GetDeviceCaps In WIN32API Integer iHDC, Integer iIndex

* Get a device context for VFP.
	liHWnd = GetActiveWindow()
	liHDC = GetDC(liHWnd)

* Get the pixels per inch.
	liPixelsPerInchX = GetDeviceCaps(liHDC, cnLOG_PIXELS_X)
	liPixelsPerInchY = GetDeviceCaps(liHDC, cnLOG_PIXELS_Y)

* Get the twips per pixel.
	This.nxtwips = ( cnTWIPS_PER_INCH / liPixelsPerInchX )
	This.nytwips = ( cnTWIPS_PER_INCH / liPixelsPerInchY )
	Return
	Endproc


	Procedure CheckRest
	Lparameters tnIndex, tlCheck, toTreeView
	Local lnIndex, lnLastIndex
	With toTreeView
		.Nodes(tnIndex).Checked = tlCheck
		If .Nodes(tnIndex).Children > 0
			lnIndex  = .Nodes(tnIndex).Child.Index
			lnLastIndex = .Nodes(tnIndex).Child.LastSibling.Index
			This.CheckRest(lnIndex, tlCheck, toTreeView)
			Do While lnIndex # lnLastIndex
				lnIndex = .Nodes(lnIndex).Next.Index
				This.CheckRest(lnIndex, tlCheck, toTreeView)
			Enddo
		Endif
	Endwith
	Endproc

Enddefine

Define Class myTreeView As OleControl
	OLEDragMode = 1
	OLEDropMode = 1
	Name = "OleTreeView"
	OleClass = 'MSComCtlLib.TreeCtrl'

	Procedure Init
	With This
		.Object.CheckBoxes = .T.
		.linestyle =1
		.labeledit =1
		.indentation = 5
		.PathSeparator = '\'
	Endwith
	Endproc
	Procedure NodeClick
*** ActiveX Control Event ***
	Lparameters Node
	Node.Ensurevisible
	Messagebox(Node.Fullpath + Chr(13) +Trans(Node.Index),0,"NodeClick",2000)
	Endproc

	Procedure MouseDown
	Lparameters Button, Shift, x, Y
	If Button=2
		lcWhere = ''
		oNode = This.HitTest( x * Thisform.nxtwips, Y * Thisform.nytwips )
		If Type("oNode")= "O" And !Isnull(oNode)
*        DO myTVShcut.mpr with oNode
			Execscript(m.MyMenu, oNode, Thisform)
		Endif
	Endif
	Endproc

	Procedure MouseUp
	Lparameters Button, Shift, x, Y
*!*      if button=2
*!*          nodefault
*!*          Wait window 'Right click occured in Mup' timeout 2
*!*      endif
	If Button=1
		oNode = This.HitTest( x * Thisform.nxtwips, Y * Thisform.nytwips )
		If Type("oNode")= "O" And !Isnull(oNode)
			If oNode.Key # 'root1'
				oNode.Checked = .F.
			Else
				Thisform.CheckRest(oNode.Index,oNode.Checked,This)
			Endif
		Endif
	Endif
	Endproc

*!*      Procedure NodeCheck
*!*    *** ActiveX Control Event ***
*!*    Lparameters node,dummy
*!*    IF node.Key = 'root1'
*!*    thisform.CheckRest(node.Index,node.Checked,this)
*!*    endif
*!*    endproc

	Procedure _SubNodes
	Lparameters tnIndex, tnLevel
	Local lnIndex
	lcFs = ''
	With This
		? Iif(tnLevel=0,'',Replicate(Chr(9),tnLevel))+.Nodes(tnIndex).Text, "[Actual index :"+Trans(tnIndex)+"]"
		If .Nodes(tnIndex).Children > 0
			lnIndex  = .Nodes(tnIndex).Child.Index
			._SubNodes(lnIndex,tnLevel+1)
			Do While lnIndex # .Nodes(tnIndex).Child.LastSibling.Index
				lnIndex = .Nodes(lnIndex).Next.Index
				._SubNodes(lnIndex,tnLevel+1)
			Enddo
		Endif
	Endwith
	Endproc

	Procedure ExpandAll
	Lparameters tnIndex
	Local lnIndex
	With This
		.Nodes(tnIndex).Expanded = .T.
		If .Nodes(tnIndex).Children > 0
			lnIndex  = .Nodes(tnIndex).Child.Index
			.ExpandAll(lnIndex)
			Do While lnIndex # .Nodes(tnIndex).Child.LastSibling.Index
				lnIndex = .Nodes(lnIndex).Next.Index
				.ExpandAll(lnIndex)
			Enddo
		Endif
	Endwith
	Endproc
Enddefine

Define Class Lister As CommandButton
	Caption = 'Listado'
	Height = 32
	Width = 100

	Procedure Click
	Activate Screen
	TVLister(Thisform.Tree)
	With Thisform.Tree
*  WalkTree(.Nodes(1),0)
*    .ExpandAll(.SelectedItem.Index)
	Endwith
	Endproc

	Procedure click1
	Activate Screen
	Clear
	Local lnIndex
	With Thisform.Tree
		lnIndex = .Nodes(1).Root.FirstSibling.Index
		._SubNodes(lnIndex,0)
		Do While lnIndex # .Nodes(1).Root.LastSibling.Index
			lnIndex = .Nodes(lnIndex).Next.Index
			._SubNodes(lnIndex,0)
		Enddo
	Endwith
	Endproc
Enddefine
