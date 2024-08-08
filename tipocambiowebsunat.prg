loIE=Createobject("InternetExplorer.Application")
nm='5'
na='2014'
loIE.Visible=.F.
loIE.Navigate("http://www.sunat.gob.pe/cl-at-ittipcam/tcS01Alias?mes="+(nm)+"&anho="+(na))
*loIE.Navigate("http://www.sunat.gob.pe/cl-at-ittipcam/tcS01Alias?mes=05&anho=2014")
Do While loIE.readystate<>4
	Wait Window "Waiting for web page..." Nowait
Enddo
lcHTML=loIE.Document.body.innerText
ln_PosIni = At("Día",lcHTML)
ln_PosFin = At("Para efectos",lcHTML)
lc_Texto = Substr(lcHTML,ln_PosIni,ln_PosFin - ln_PosIni)
ln_PosIni = Rat("Venta",lc_Texto)
lc_Texto = Chrtran(Alltrim(Substr(lc_Texto,ln_PosIni + 6)) + " ",Chr(10),"")
Wait Clear
loIE.Quit()
Release loIE
Push Key Clear
Create Cursor CurTCambio(DIA N(2),TC_COMPRA N(5,3),TC_VENTA N(5,3))
ln_Contador = 0
lc_Cadena = ""
For K = 1 To Len(lc_Texto)
	If Substr(lc_Texto,K,1) = " " Then
		ln_Contador = ln_Contador + 1
		If ln_Contador = 1 And K <> Len(lc_Texto) Then
			If  Val(Alltrim(lc_Cadena))=0 Then
				If Len(Alltrim(lc_Cadena))=2 Then
					lc_Cadena=Alltrim(Substr(lc_Cadena,2,1))
				Else
					lc_Cadena=Alltrim(Substr(lc_Cadena,2,2))
				Endif
			Endif
			Select CurTCambio
			Append Blank
			Replace CurTCambio.DIA With Val(Alltrim(lc_Cadena))
		Endif
		If ln_Contador = 2 Then
			Select CurTCambio
			Replace CurTCambio.TC_COMPRA With Val(lc_Cadena)
		Endif
		If ln_Contador = 3 Then
			Select CurTCambio
			Replace CurTCambio.TC_VENTA With Val(lc_Cadena)
			ln_Contador = 0
		Endif
		lc_Cadena =""
	Else
		lc_Cadena = lc_Cadena + Substr(lc_Texto,K,1)
	Endif
Next

Select  CurTCambio
Browse
