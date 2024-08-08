Close All
Use d:\capass\listai In 0

Select listai
tr=Reccount()
=Afields(nlista)
_Screen.AddProperty("array10",nlista)
Select * From listai Into Array nlista1
_Screen.AddProperty("array20[1]")
Acopy(nlista1,_Screen.Array20)
Acopy(nlista,_Screen.Array10)
Select listai
Use
For i=0 To 5
	If Vartype(_Screen.Array20[1])='L' Then
		Wait Window 'No Creado'
	Else
		Wait Window 'creado'
		Create Cursor lista From Array _Screen.Array10
		Insert Into lista From Array _Screen.Array20
	Endif
Next
