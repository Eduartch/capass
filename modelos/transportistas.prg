Define Class Transportista As OData Of 'd:\capass\database\data.prg'
	Placa = ""
	nombre = ""
	Direccion = ""
	Ruc = ""
	chofer = ""
	brevete = ""
	marca = ""
	registromtc = ""
	idtr = 0
	placa1 = ""
	Constancia = ""
	TipoT = ""
	npropio = 0
	activofijo = ""
	dni = ""
	cmodo = ""
	Yaregistrado = ""
	ccontacto=""
	cfono=""
	Function listarTransportistax(np1, np2, ccur)
	Local lC, lp
	m.lC		 = 'ProMuestraTransportista'
	goApp.npara1 = m.np1
	goApp.npara2 = m.np2
	TEXT To m.lp Noshow
     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(m.lC, m.lp, m.ccur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function VAlidar()
	If Type('oempresa') = 'U' Then
		m.cnruc='fe_gene.nruc'
	Else
		m.cnruc=oempresa.nruc
	Endif
	Do Case
	Case Len(Alltrim(This.nombre)) = 0
		This.Cmensaje = "Ingrese Nombre de Transportista"
		Return 0
	Case !ValidaRuc(This.Ruc)
		This.Cmensaje = "Ruc NO Válido"
		Return 0
	Case !Empty(This.Placa) And Len(Alltrim(This.Placa)) < 5
		This.Cmensaje = 'Número de Placa NO Válida'
		Return 0
	Case Empty(This.Placa) And !Empty(This.placa1)
		This.Cmensaje = 'Se debe registrar la Placa del vehiculo como Principal '
		Return 0
	Case This.Ruc=m.cnruc And This.TipoT='01'
		This.Cmensaje='El Transportista debe ser Privado'
		Return 0
*!*		Case This.cmodo = 'N' And !Empty(This.Placa)
*!*			If This.buscarplaca() < 1 Then
*!*				Return 0
*!*			Endif
*!*			Return 1
	Otherwise
		Return 1
	Endcase
	Endfunc
************
	Function  crear()
	If This.VAlidar() < 1 Then
		Return 0
	Endif
	m.lC		 = 'FUNCREATRANSPORTISTA'
	If This.activofijo = 'S' Then
		TEXT To lp Noshow Textmerge
    ('<<this.placa>>','<<this.nombre>>','<<this.direccion>>','<<this.ruc>>','<<this.chofer>>','<<this.brevete>>','<<this.marca>>','<<this.registromtc>>',<<goapp.nidusua>>,'<<this.placa1>>','<<this.tipot>>','<<this.constancia>>',<<this.npropio>>)
		ENDTEXT
	Else
		TEXT To lp Noshow Textmerge
    ('<<this.placa>>','<<this.nombre>>','<<this.direccion>>','<<this.ruc>>','<<this.chofer>>','<<this.brevete>>','<<this.marca>>','<<this.registromtc>>',<<goapp.nidusua>>,'<<this.placa1>>','<<this.tipot>>','<<this.constancia>>')
		ENDTEXT
	Endif
	nidt = This.EJECUTARf(lC, lp, 'trax')
	If nidt < 1 Then
		Return 0
	Endif
	Return nidt
	Endfunc
	Function Actualizar()
	If This.VAlidar() < 1 Then
		Return 0
	Endif
	m.lC		 = 'PROACTUALIZATRANSPORTISTA'
	If This.activofijo = 'S' Then
		TEXT To lp Noshow Textmerge
    ('<<this.placa>>','<<this.nombre>>','<<this.direccion>>','<<this.ruc>>','<<this.chofer>>','<<this.brevete>>','<<this.marca>>','<<this.registromtc>>',<<this.idtr>>,'<<this.placa1>>','<<this.tipot>>','<<this.constancia>>',<<this.npropio>>)
		ENDTEXT
	Else
		TEXT To lp Noshow Textmerge
    ('<<this.placa>>','<<this.nombre>>','<<this.direccion>>','<<this.ruc>>','<<this.chofer>>','<<this.brevete>>','<<this.marca>>','<<this.registromtc>>',<<this.idtr>>,'<<this.placa1>>','<<this.tipot>>','<<this.constancia>>')
		ENDTEXT
	Endif
	If This.EJECUTARP(lC, lp) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Actualizar10()
	If This.VAlidar() < 1 Then
		Return 0
	Endif
    goApp.npara1=this.Placa
	goApp.npara2=this.nombre
	goApp.npara3=this.Direccion
	goApp.npara4=this.chofer
	goApp.npara5=this.brevete
	goApp.npara6=this.marca
	goApp.npara7=this.registromtc
	goApp.npara8=this.idtr
	goApp.npara9=this.placa1
	goApp.npara10=this.TipoT
	goApp.npara11=this.Constancia
	goApp.npara12=this.ccontacto
	goApp.npara13=this.cfono
	TEXT To lc NOSHOW 
      UPDATE fe_tra SET placa=?goapp.npara1,razon=?goapp.npara2,dirtr=?goapp.npara3,nombr=?goapp.npara4,breve=?goapp.npara5,
      marca=?goapp.npara6,cons=?goapp.npara7,placa1=?goapp.npara9,tran_tipo=?goapp.npara10,tran_cons1=?goapp.npara11,
      tran_cont=?goapp.npara12,tran_fono=?goapp.npara13 where idtra=?goapp.npara8
	ENDTEXT
	If This.EJECUTARsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ProcesaTransportista(Cruc, crazo, cdire, cbreve, ccons, cmarca, cplaca, idtr, optt, cchofer, nidus, cplaca1)
	If optt = 0 Then
		If SQLExec(goApp.bdConn, "SELECT FUNCREATRANSPORTISTA(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?nidus,?cplaca1) as nid", "yy") < 1 Then
			Errorbd(ERRORPROC + 'Ingresando Transportista')
			Return 0
		Else
			Return yy.nid
		Endif
	Else
		If SQLExec(goApp.bdConn, "CALL PROACTUALIZATRANSPORTISTA(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?idtr,?cplaca1)") < 1 Then
			Errorbd(ERRORPROC + 'Actualizando Transportista')
			Return 0
		Else
			Return idtr
		Endif
	Endif
	Endfunc
************************************
	Function ProcesaTransportista1(Cruc, crazo, cdire, cbreve, ccons, cmarca, cplaca, idtr, optt, cchofer, nidus, cplaca1, Cfono, cContacto)
	If optt = 0 Then
		If SQLExec(goApp.bdConn, "SELECT FUNCREATRANSPORTISTA1(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?nidus,?cplaca1,?cfono,?ccontacto) as nid", "yy") < 1 Then
			Errorbd(ERRORPROC + ' Ingresando Transportista')
			Return 0
		Else
			Return yy.nid
		Endif
	Else
		If SQLExec(goApp.bdConn, "CALL PROACTUALIZATRANSPORTISTA1(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?idtr,?cplaca1,?cfono,?ccontacto)") < 1 Then
			Errorbd(ERRORPROC + ' Actualizando Transportista')
			Return 0
		Else
			Return 1
		Endif
	Endif
	Endfunc
	Function quitar(Idtran, opt)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\ Update fe_tra
	If opt = 0 Then
	    \Set tran_acti='I'
	Else
	    \Set tran_acti='A'
	Endif
	\Where idtra=<<Idtran>>
	Set Textmerge Off
	Set Textmerge To
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarplaca()
	Ccursor = 'c_' + Sys(2015)
	TEXT To lC Noshow Textmerge
        select placa FROM fe_tra WHERE placa='<<This.Placa>>' AND ructr='<<this.ruc>>' limit 1
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Select (Ccursor)
	If Reccount() > 0
		This.Cmensaje = "NÚMERO  de Placa Ya Registrada"
		This.Yaregistrado = 'S'
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscaruc(cmodo, Cruc, nidtra)
	If Len(Alltrim(Cruc)) <> 11 Or  !ValidaRuc(Cruc) Then
		This.Cmensaje = 'RUC NO Válido'
		Return 0
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC  Noshow
	\Select ructr As nruc From fe_tra Where ructr='<<cruc>>'
	If cmodo <> "N"
	 \ And idtra<><<nidtra>>
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, "ya") < 1
		Return 0
	Endif
	If ya.nruc = Cruc
		This.Cmensaje = "Nº de Ruc Ya Registrado"
		This.Yaregistrado = 'S'
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine


















