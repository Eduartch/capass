loIE=Createobject("InternetExplorer.Application")
loIE.Navigate("https://e-consulta.sunat.gob.pe/cl-at-ittipcam/tcS01Alias")

Do While loIE.readystate<>4
	Wait Window "Esperando Respuesta desde https://e-consulta.sunat.gob.pe/cl-at-ittipcam/tcS01Alias " Nowait
ENDDO





lcHTML=loIE.Document.body.innerText
MESSAGEBOX(lcHTML,16,'hola')
ln_PosIni = At("Sábado",lcHTML)
ln_PosFin = At("Notas",lcHTML)

lc_Texto = Substr(lcHTML,ln_PosIni+6,ln_PosFin - ln_PosIni)

Wait Clear
loIE.Quit()
Release loIE
Push Key Clear
*Create Cursor CurTCambio(DIA N(2),TC_COMPRA N(5,3),TC_VENTA N(5,3))
ln_Contador = 0
lc_Cadena = ""

*If Left(lc_Texto,5)<> "Notas" Then
	For k = 1 To Len(lc_Texto)
	    wait WINDOW  SUBSTR(lc_Texto,1,1)
	    IF SUBSTR(lc_Texto,1,1)<>'' then
	       ?lc_texto
	    ENDIF 
	Next
*Endif