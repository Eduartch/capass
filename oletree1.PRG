#Define tvwFirst 0
#Define tvwLast 1
#Define tvwNext 2
#Define tvwPrevious 3
#Define tvwChild 4

oForm = Createobject('myForm')
With oForm
	.AddObject('Tree','myTreeView')
	.AddObject('Lister','Lister')
	With .Tree
		.Nodes.Add(,0,"root1",'Main node 2')
		.Nodes.Add(,0,"root2",'Main node 3')
		.Nodes.Add('root1',4,"child11",'Child11')
		.Nodes.Add('root1',4,"child12",'Child12')
		.Nodes.Add('root2',4,"child21",'Child22')
		.Nodes.Add('child21',3,"child20",'Child21')
		.Nodes.Add('child11',4,"child111",'child113')
		.Nodes.Add('child111',3,"child112",'child112')
		.Nodes.Add('child112',3,"child113",'child111')
		.Nodes.Add('root1',3,"root0",'Main node 1')
		.Visible = .T.
	Endwith
	.Lister.Left = .Width - .Lister.Width
	.Lister.Visible = .T.
	.Show()
Endwith
Read Events

Define Class myForm As Form
	AutoCenter = .T.
	Height = 640
	Width = 800
	Procedure QueryUnload
	Clear Events
	Endproc
Enddefine

Define Class myTreeView As OleControl
	OLEDragMode = 1
	OLEDropMode = 1
	Name = "OleTreeView"
	OleClass = 'MSComCtlLib.TreeCtrl.2'
	Height = 600
	Width = 700

	Procedure Init
	With This
		.linestyle =1
		.labeledit =1
		.indentation = 5
		.PathSeparator = '\'
	Endwith
	Endproc

	Procedure NodeClick
*** ActiveX Control Event ***
	Lparameters Node
	Node.ensurevisible
	Messagebox(Node.Fullpath,Trans(Node.Index))
	Endproc

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
Enddefine

Define Class Lister As CommandButton
	Caption = 'Listado'
	Height = 32
	Width = 100

	Procedure Click
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
