Define Class clscompra As App Of d:\capass\api\App.prg
	objcompra=Null
	cmensaje=""
	Function insertar()
	Set Procedure To d:\capass\modelos\compras Additive
	objcompra=Createobject("compras")
	If objcompra.Guardar()<1 Then
		This.cmensaje=objcompra.cmensaje
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
