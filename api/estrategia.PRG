Define Class MsgServer As MsgInterface
	Function Init
*-- Load an interface object with implementations.
*-- Exercise for the reader: Imagine delaying
*-- the AddObject calls until actually needed.
	This.AddObject( "msgWaitWindow","WaitMsg")
	This.AddObject( "msgRegular", "RegularMsg")
	This.AddObject( "msgInfo", "InfoMsg")
	This.AddObject( "msgWarning", "WarningMsg")
	This.AddObject( "msgError", "ErrorMsg")
	Endfunc

	Function Execute( tnPassed, tcMessage)
*? I don't recommend doing it quite like this --
*? This simple example assumes you know the number of the
*? implementation object. In a perfect but (less concise)
*? example, .Execute(x,y) could accept an x of type "C", as in
*? <whatever_message_server>.Execute("Warning", <Message>)
*?
	This.Controls(tnPassed).Execute(tcMessage)
	Endfunc
Enddefine

Define Class WaitMsg As MsgImplementation
	Function Show( txPara1)
	Wait Window This.cMessage
	Endfunc
Enddefine

Define Class RegularMsg As MsgBoxImplementation
	cTitle= "My Application"
Enddefine

Define Class InfoMsg As RegularMsg
	nIcon= 64
Enddefine

Define Class WarningMsg As InfoMsg
	nIcon= 48
Enddefine

Define Class ErrorMsg As WarningMsg
	nIcon= 16
	nButtons= 5
Enddefine
Define Class MsgInterface As Container
*-- Abstract message interface class
*? Hardcoded dimension
	Dimension aImp[4]
	aImp[1]= .Null.
	aImp[2]= .Null.
	aImp[3]= .Null.
	aImp[4]= .Null.
	Function Execute( txPassed)
*-- Abstract method
	Return 0
	Endfunc
Enddefine

Define Class MsgImplementation As Custom
*-- Abstract message implementation class
	cMessage= ''

	Function Execute( tcPassed)
	This.cMessage=tcPassed
	This.Show()
	Endfunc

	Function Show
*-- Abstract method
	Return 0
	Endfunc
Enddefine

Define Class MsgBoxImplementation As MsgImplementation
	nIcon= 0
	nButtons= 0
	Function Show
	=Messagebox( This.ctext, This.nIcon+This.nButtons, This.cTitle)
	Endfunc
Enddefine
