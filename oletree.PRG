#Define tvwFirst     0
#Define tvwLast      1
#Define tvwNext      2
#Define tvwPrevious  3
#Define tvwChild     4
#Define cnLOG_PIXELS_X 88
#Define cnLOG_PIXELS_Y 90
* 1440 twips por pulgadas
#Define cnTWIPS_PER_INCH 1440

oForm = Createobject('myForm')
oForm.Show
Read Events

Define Class myForm As Form
	Height = 640
	Width = 800
	AutoCenter = .T.
	Caption = "TreeView - TestPad"
	Name = "myForm"

*-- Node object reference
	nodx = .F.
	nxtwips = .F.
	nytwips = .F.

	Add Object oletreeview As OleControl With ;
		TOP = 0, Left = 0, Height = 600, Width = 750, ;
		ANCHOR = 15, Name = "OleTreeView", ;
		OLECLASS = 'MSComCtlLib.TreeCtrl'

	Add Object oleimageslist As OleControl With ;
		TOP = 0, Left = 0, Height = 100, Width = 100, ;
		NAME = "oleImagesList",;
		OLECLASS = 'MSComCtlLib.ImageListCtrl'

*-- Fill the tree values
	Procedure filltree
	Lparameters tcDirectory, tcImage
	This.Show
	Create Cursor crsNodes (NodeKey c(15), ParentKey c(15), NodeText m, NewParent c(15))
	Local oNode
	With This.oletreeview.nodes
		oNode=.Add(,tvwFirst,"root"+Padl(.Count,3,'0'),tcDirectory,tcImage)
	Endwith
	Insert Into crsNodes (NodeKey, ParentKey, NodeText) Values (oNode.Key, '',oNode.Text)
	This._SubFolders(oNode)

	Endproc

	Procedure pixeltotwips

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
	Thisform.nxtwips = ( cnTWIPS_PER_INCH / liPixelsPerInchX )
	Thisform.nytwips = ( cnTWIPS_PER_INCH / liPixelsPerInchY )
	Return

	Endproc

*-- Collect subfolders
	Procedure _SubFolders
	Lparameters oNode
	Local nChild, oNodex
	lcFolder = oNode.Fullpath
	lcFolder = Strtran(lcFolder,":\\",":\")
	oFS = Createobject('Scripting.FileSystemObject')
	oFolder = oFS.GetFolder(lcFolder)
	With Thisform.oletreeview
		lnIndent = 0
		lnIndex = oNode.Index
		Do While lnIndex # oNode.Root.Index ;
				AND Type('.nodes(lnIndex).Parent')='O' ;
				AND !Isnull(.nodes(lnIndex).Parent)
			lnIndex = .nodes(lnIndex).Parent.Index
			lnIndent = lnIndent + 1
		Enddo
		lcChildKeyPrefix = 'L'+Padl(lnIndent,3,'0')+'_'
	Endwith
	With Thisform.oletreeview.nodes
		If oNode.Children > 0
			If oNode.Child.Key = oNode.Key+"dummy"
				.Remove(oNode.Child.Index)
				For Each oSubFolder In oFolder.Subfolders
					Insert Into crsNodes ;
						(NodeKey, ParentKey, NodeText) ;
						VALUES ;
						(lcChildKeyPrefix+' '+Padl(Reccount('crsNodes')+1,5,'0'), ;
						oNode.Key, oSubFolder.Path)
					oNodex = .Add(oNode.Key, tvwChild, ;
						crsNodes.NodeKey, oSubFolder.Name, "ClosedFolder","OpenFolder" )
					oNodex.ExpandedImage = "OpenFolder"
					If oSubFolder.Name # "System Volume Information" And oSubFolder.Subfolders.Count > 0
						oNodex = .Add(crsNodes.NodeKey, tvwChild, ;
							crsNodes.NodeKey+"dummy", "dummy", "ClosedFolder","OpenFolder" )
					Endif
				Endfor
			Endif
		Else
			If oFolder.Subfolders.Count > 0
				oNodex = .Add(oNode.Key, tvwChild, ;
					oNode.Key+"dummy", "dummy", "ClosedFolder","OpenFolder" )
			Endif
		Endif
	Endwith
	Endproc

	Procedure QueryUnload
	Thisform.nodx = .Null.
	Clear Events
	Endproc

	Procedure Init
	This.pixeltotwips()
	Set Talk Off
* Check to see if OCX installed and loaded.
	If Type("THIS.oleTreeView") # "O" Or Isnull(This.oletreeview)
		Return .F.
	Endif
	If Type("THIS.oleImagesList") # "O" Or Isnull(This.oleimageslist)
		Return .F.
	Endif
	lcIconPath = Home(0) + "Graphics\Icons\"
	With This.oleimageslist
		.ImageHeight = 32
		.ImageWidth = 32
		.ListImages.Add(,"OpenFolder",LoadPicture(lcIconPath+"Win95\openfold.ico"))
		.ListImages.Add(,"ClosedFolder",LoadPicture(lcIconPath+"Win95\clsdfold.ico"))
		.ListImages.Add(,"Drive",LoadPicture(lcIconPath+"Computer\drive01.ico"))
		.ListImages.Add(,"Floppy",LoadPicture(lcIconPath+"Win95\35floppy.ico"))
		.ListImages.Add(,"NetDrive",LoadPicture(lcIconPath+"Win95\drivenet.ico"))
		.ListImages.Add(,"CDDrive",LoadPicture(lcIconPath+"Win95\CDdrive.ico"))
		.ListImages.Add(,"RAMDrive",LoadPicture(lcIconPath+"Win95\desktop.ico"))
		.ListImages.Add(,"Unknown",LoadPicture(lcIconPath+"Misc\question.ico"))
	Endwith

	With This.oletreeview
		.linestyle =1
		.labeledit =1
		.indentation = 5
		.imagelist = This.oleimageslist.Object
		.PathSeparator = '\'
		.OLEDragMode = 1
		.OLEDropMode = 1
	Endwith

	oFS = Createobject('Scripting.FileSystemObject')
	Local Array aDrvTypes[7]
	aDrvTypes[1]="Unknown"
	aDrvTypes[2]="Floppy"
	aDrvTypes[3]="Drive"
	aDrvTypes[4]="NetDrive"
	aDrvTypes[5]="CDDrive"
	aDrvTypes[6]="RAMDrive"

	For Each oDrive In oFS.Drives
		If oDrive.IsReady
			This.filltree(oDrive.Rootfolder.Path, aDrvTypes[oDrive.DriveType+1])
		Endif
	Endfor
	Endproc

	Procedure oletreeview.Expand
*** ActiveX Control Event ***
	Lparameters Node
	Thisform._SubFolders(Node)
	Node.ensurevisible
	Endproc

	Procedure oletreeview.NodeClick
*** ActiveX Control Event ***
	Lparameters Node
	Node.ensurevisible
	This.DropHighlight = .Null.
	Endproc

	Procedure oletreeview.MouseDown
*** ActiveX Control Event ***
	Lparameters Button, Shift, x, Y
	With Thisform
		oHitTest = This.HitTest( x * .nxtwips, Y * .nytwips )
		If Type("oHitTest")= "O" And !Isnull(oHitTest)
			This.SelectedItem = oHitTest
		Endif
		.nodx = This.SelectedItem
	Endwith
	oHitTest = .Null.
	Endproc

	Procedure oletreeview.OLEDragOver
*** ActiveX Control Event ***
	Lparameters Data, effect, Button, Shift, x, Y, state
	oHitTest = This.HitTest( x * Thisform.nxtwips, Y * Thisform.nytwips )
	If Type("oHitTest")= "O"
		This.DropHighlight = oHitTest
	Endif
	Endproc

	Procedure oletreeview.OLEDragDrop
*** ActiveX Control Event ***
	Lparameters Data, effect, Button, Shift, x, Y
	If Data.GetFormat(1)     &&CF_TEXT
		With This
			If !Isnull(Thisform.nodx) And Type(".DropHighLight") = "O" And !Isnull(.DropHighlight)
				loSource = Thisform.nodx
				loTarget = .DropHighlight
				If loSource.Key # loTarget.Key And Type('loSource.Parent') = 'O'
					lcSourceParentKey = loSource.Parent.Key
					lcTargetParentKey = loTarget.Parent.Key
					If Substr(lcSourceParentKey,1,At('_',lcSourceParentKey)-1) == ;
							SUBSTR(lcTargetParentKey,1,At('_',lcTargetParentKey)-1)
						lcSourceKey = Iif(lcSourceParentKey == lcTargetParentKey,'',;
							IIF(Shift=1,'mv','cp'))+loSource.Key
						lcSourceText = loSource.Text
						llRemoveSource = (lcSourceParentKey == lcTargetParentKey Or Shift=1)

* Check here for children repopulation since we're simulating with existing directories
* llGetChildren should be false for copy-move from another parent dir
						llGetChildren  = (lcSourceParentKey == lcTargetParentKey)

						If llRemoveSource
							.nodes.Remove(loSource.Index)
						Endif
* Check if node exists already
						If Type('.Nodes(lcSourceKey)') # 'O'
							oNode=.nodes.Add(loTarget.Key,tvwPrevious,lcSourceKey,lcSourceText,;
								"ClosedFolder","OpenFolder")
							.SelectedItem = oNode
							If llGetChildren
								Thisform._SubFolders(oNode)
							Endif
						Endif
					Endif
				Endif
			Endif
		Endwith
	Endif
	This.DropHighlight = .Null.
	Endproc

Enddefine
