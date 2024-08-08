msgtitulo  'sisven'
Define Class ventas As Custom
	Function validar()
	x='C'
	Select tmpv
	Go Top In (This.grivta.RecordSource) Then
	If Len(Alltrim(tmpv.Desc))=0 And Thisform.txtitem.Value=1 Then
		Thisform.mensaje="Ingrese Items para este Documento"
		Return .F.
	Endif
	Local nb As Integer
	If goapp.vtasg=0 Then
		Select tmpv
		Locate For Valida="N"
		nb=1
	Else
		nb=0
	Endif
	Do Case
	Case Thisform.txttotal.Value=0 And goapp.vtasg=0
		cmensaje="El Documento no tiene Importe de Ventas"
		lo=0
	Case Thisform.txtcodigo.Value=0 Or Empty(Thisform.txtcodigo.Value)
		cmensaje="Seleccione un Cliente Para Esta Venta"
		lo=0
	Case !esfechavalida(Thisform.txtfecha.Value)
		cmensaje="Fecha de Ingreso No Válida"
		lo=0
	Case  !esfechavalidafvto(Thisform.txtfechavto.Value)
		cmensaje="Fecha de Vencimoento No Válida"
		lo=0
	Case Month(Thisform.txtfecha.Value)<>goapp.mes Or Year(Thisform.txtfecha.Value)<>Val(goapp.año)
		cmensaje="Fecha No Permitida Por el Sistema"
		lo=0
	Case Len(Alltrim(Thisform.txtserie.Value))<4 Or Len(Alltrim(Thisform.txtnumero.Value))<8
		cmensaje="El nº de Documento No es Válido"
		lo=0
	Case Left(Thisform.txtruc.Value,1)="*"
		cmensaje="Debe Utilizar la Opción Anular"
		lo=0
	Case Thisform.sinstock="S"
		cmensaje="Hay Un Item que No tiene Sotok Disponible"
		lo=0
	Case nb=1 And Found()
		cmensaje="El producto :"+Alltrim(tmpv.coda)+" No Tiene Cantidad o Precio"
		lo=0
	Case PermiteIngresoVentas(Thisform.txtserie.Value+Thisform.txtnumero.Value,Thisform.tdoc,0,Thisform.txtfecha.Value)=0
		cmensaje="NUMERO de Documento de Venta Ya Registrado"
		lo=0
	Case Thisform.tdoc="01" And Len(Alltrim(Thisform.txtruc.Value))<11
		cmensaje="Ingrese RUC del Cliente"
		lo=0
	Case Thisform.tdoc="03" And Thisform.txttotal.Value>700 And Len(Alltrim(Thisform.txtdni.Value))<8
		cmensaje="Ingrese DNI del Cliente"
		lo=0
	Case Thisform.txtencontrado.Value="V"
		cmensaje="No es Posible Actualizar este Documento"
		lo=0
	Case This.txtdias.Value=0 And This.cmbforma.ListIndex=2
		cmensaje="Ingrese Los días de Crédito"
		lo=0
	Case PermiteIngresoaCaja(Thisform.txtfecha.Value)=0
		Messagebox("Ya se La Liquido Caja en esta Fecha",16,msgtitulo)
		Do Form v_verifica With 'A' To verdad
		If !verdad Then
			lo=0
		Else
			lo=1
		Endif
	Otherwise
		lo=1
	Endcase
	If lo=0 Then
		Return .F.
	Else
		Return .T.
	Endif

	Endfunc
Enddefine
