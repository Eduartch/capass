CLOSE ALL
Set Procedure To d:\librerias\nfcursortojson,d:\librerias\nfcursortoobject,d:\librerias\nfJsonRead.prg,d:\librerias\nfjsontocursor Additive
USE D:\Psysl\config IN 0 SHARED

responseType1 = 'd:\psysl\config.json'


oResponse = nfJsonRead( m.responseType1 ) 


For Each oRow In  oResponse.array
    Insert Into config From Name oRow
Endfor



* from unnamed array:

*!*	responseType2 = '[ { "id":1, "name":"John 2" , "secondName": "Doe 2" }, { "id":1, "name":"Jane 2" , "secondName": "Doe 2" } ] '


*!*	oResponse = nfJsonRead( m.responseType2 ) 

*!*	* nfjsonRead will always return an object, unnamed arrays get named as "Array"

*!*	For Each oRow In oResponse.array
*!*	    Insert Into response From Name oRow
*!*	Endfor

BROWSE