Define Class ccostos As OData Of 'd:\capass\database\Data.prg'
	idcosto = 0
	cdesccosto = ""
	cacti = ''
	Cestado = 'A'
	Function Listar(cvalor,Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select cent_idco,cent_desc,cent_acti From fe_centcostos  Where cent_desc like concat('%','<<TRIM(m.cvalor)>>','%')
	If This.Cestado = 'A' Then
     \  and cent_acti='A'
	Else
     \  and cent_acti='I'
	Endif
    \ Order By cent_desc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Crear()
	If This.VAlidar() < 1 Then
		Return 0
	Endif
	Text To lC Noshow Textmerge
    INSERT INTO fe_centcostos(cent_desc)values('<<this.cdesccosto>>')
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'ok'
	Return 1
	Endfunc
	Function Actualizar()
	If This.idcosto < 1 Then
		This.Cmensaje = 'Seleccione Una Descripción'
		Return 0
	Endif
	If This.VAlidar() < 1 Then
		Return 0
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
    \ Update fe_centcostos
	If This.cacti = 'I' Then
        \ Set cent_acti='I'
	Else
       \ Set cent_desc='<<this.cdesccosto>>'
	Endif
    \ Where cent_idco=<<This.idcosto>>
	Set Textmerge Off
	Set Textmerge To
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'ok'
	Return 1
	Endfunc
	Function VAlidar()
	Ccursor = 'c_' + Sys(2015)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\ Select cent_idco From fe_centcostos Where Trim(cent_desc) = '<<TRIM(this.cdesccosto)>>'
	If This.idcosto > 0 Then
	   \ And cent_idco<><<This.idcosto>>
	Endif
	\ Limit 1
	Set Textmerge Off
	Set Textmerge To
	Do Case
	Case Len(Alltrim(This.cdesccosto)) = 0 
		This.Cmensaje = 'Ingrese Una Descripción Válida'
		Return 0
	Case Len(Alltrim(This.cdesccosto)) > 0
		If This.EJECutaconsulta(lC, Ccursor) < 1 Then
			Return 0
		Endif
		Select (Ccursor)
		If cent_idco > 0 Then
			This.Cmensaje = 'Descripción Ya Registrada!'
			Return 0
		Endif
		Return 1
	Endcase
	Endfunc
Enddefine