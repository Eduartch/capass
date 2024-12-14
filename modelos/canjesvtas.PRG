Define Class canjesvtas As Ventas Of "d:\capass\modelos\ventas"
	Idcanje = 0
	Function AnularCanje()
	TEXT To lC Noshow Textmerge
	   select ndoc,idauto,tdoc FROM fe_rcom WHERE rcom_idtr=<<this.idcanje>> and LEFT(rcom_mens,1)<>'0'
	ENDTEXT
	If This.EJECutaconsulta(lC, 'lisanular') < 1 Then
		Return 0
	Endif
	Select lisanular
	If REgdvto("lisanular") = 0 Then
		This.Cmensaje = "Documentos Ya Informados a SUNAT"
		Return 0
	Endif
	Sw = 1
	Select lisanular
	Go Top
	Scan All
		If lisanular.tdoc='03' Then
			If AnulaTransaccionN('', '', 'V', lisanular.Idauto, goApp.nidusua, 'S', Date(), goApp.nidusua) = 0 Then
				Sw = 0
				This.Cmensaje = 'NO se pudo Anular'
				Exit
			Endif
		Else
			TEXT TO lc NOSHOW TEXTMERGE
			 UPDATE fe_rcom SET rcom_idtr=0 WHERE idauto=<<lisanular.idauto>>
			ENDTEXT
			If This.ejecutarsql(lC)<1 Then
				Sw=0
				Exit
			Endif
		Endif
	Endscan
	If Sw = 0 Then
    	Return 0
	Endif
	RETURN 1
	Endfunc
Enddefine
