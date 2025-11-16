Define Class Cliente As OData Of 'd:\capass\database\data.prg'
	Codigo	   = 0
	nruc	   = ""
	nombre	   = ""
	Direccion  = ""
	ciudad	   = ""
	fono	   = ""
	fax		   = ""
	ndni	   = ""
	Tipo	   = ""
	correo	   = ""
	Vendedor   = 0
	Usuario	   = 0
	pc		   = ""
	Celular	   = ""
	Refe	   = ""
	Linea	   = 0
	Rpm		   = ""
	zona	   = 0
	idsegmento = 0
	Cmensaje   = ""
	Encontrado = ""
	dias			  = 0
	Contacto		  = ""
	direccion1		  = ""
	Codigov			  = 0
	Usuario			  = 0
	AutorizadoCredito = 0
	Function ActualizaLineadeCredito(nid, nmonto)
	IF nid<1 then
	   this.Cmensaje='Selecciione un Cliente'
	   RETURN 0
	ENDIF 
	Text To lC Noshow Textmerge
	UPDATE fe_clie SET clie_lcre=<<nmonto>> WHERE idclie=<<nid>>
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function VAlidar()
	Do Case
	Case Empty(This.nombre)
		This.Cmensaje = "Ingrese Nombre del Cliente"
		Return .F.
	Case This.Encontrado = 'S'
		This.Cmensaje = "El RUC o El Nombre del Cliente Ya Estan Registrados"
		Return .F.
	Case Len(Alltrim(This.ndni)) > 1 And Len(Alltrim(This.ndni)) <> 8
		This.Cmensaje = "DNI es Inválido"
		Return .F.
	Case Len(Alltrim(This.nruc)) = 11 And !ValidaRuc(This.nruc)
		This.Cmensaje = "RUC NO Válido"
		Return .F.
	Otherwise
		Return .T.
	Endcase
	Endfunc
	Procedure AsignaValores
	Lparameters Codigo, Cnruc, crazo, cdire, cciud, Cfono, cfax, Cdni, Ctipo, cemail, nidven, cusua, cidpc, ccelu, crefe, Linea, crpm, nidz
	This.Codigo	   = m.Codigo
	This.nruc	   = m.Cnruc
	This.nombre	   = m.crazo
	This.Direccion = m.cdire
	This.ciudad	   = m.cciud
	This.fono	   = m.Cfono
	This.fax	   = m.cfax
	This.ndni	   = m.Cdni
	This.Tipo	   = m.Ctipo
	This.correo	   = m.cemail
	This.Vendedor  = m.nidven
	This.Usuario   = m.cusua
	This.pc		   = m.cidpc
	This.Celular   = m.ccelu
	This.Refe	   = m.crefe
	This.Linea	   = m.Linea
	This.Rpm	   = m.crpm
	This.zona	   = m.nidz
	Endproc
	Function CreaCliente
	Local lC, lp
	m.lC		  = 'FUNCREACLIENTE'
	cur			  = "xt"
	If !Pemstatus(goApp, 'clientesconsegmento', 5)
		goApp.AddProperty("clientesconsegmento", "")
	Endif
	goApp.npara1 = This.nruc
	goApp.npara2 = This.nombre
	goApp.npara3 = This.Direccion
	goApp.npara4 = This.ciudad
	goApp.npara5 = This.fono
	goApp.npara6 = This.fax
	goApp.npara7 = This.ndni
	goApp.npara8 = This.Tipo
	goApp.npara9 = This.correo
	goApp.npara10 = This.Vendedor
	goApp.npara11 = This.Usuario
	goApp.npara12 = This.pc
	goApp.npara13 = This.Celular
	goApp.npara14 = This.Refe
	goApp.npara15 = This.Linea
	goApp.npara16 = This.Rpm
	goApp.npara17 = This.zona
	If goApp.clientesconsegmento = 'S' Then
		goApp.npara18 = This.idsegmento
		Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
		Endtext
	Else
		Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
		Endtext
	Endif
	nidc = This.EJECUTARf(m.lC, m.lp, cur)
	If nidc < 1 Then
		Return 0
	Endif
	Return nidc
	Endfunc
	Procedure ActualizaCliente
	Local lC, lp
	m.lC		  = 'PROACTUALIZACLIENTE'
	cur			  = ""
	If !Pemstatus(goApp, 'clientesconsegmento', 5)
		goApp.AddProperty("clientesconsegmento", "")
	Endif
	goApp.npara1 = This.Codigo
	goApp.npara2 = This.nruc
	goApp.npara3 = This.nombre
	goApp.npara4 = This.Direccion
	goApp.npara5 = This.ciudad
	goApp.npara6 = This.fono
	goApp.npara7 = This.fax
	goApp.npara8 = This.ndni
	goApp.npara9 = This.Tipo
	goApp.npara10 = This.correo
	goApp.npara11 = This.Vendedor
	goApp.npara12 = This.Usuario
	goApp.npara13 = This.Celular
	goApp.npara14 = This.Refe
	goApp.npara15 = This.Linea
	goApp.npara16 = This.Rpm
	goApp.npara17 = This.zona
	If goApp.clientesconsegmento = 'S' Then
		goApp.npara18 = This.idsegmento
		Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
		Endtext
	Else
		Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
		Endtext
	Endif
*!*		cnombre=Chrtran(Chrtran(This.nombre,"'",""),'"',"")
*!*		cdireccion=Chrtran(Chrtran(This.Direccion,"'",""),'"',"")
*!*		Set Textmerge On
*!*		Set Textmerge To Memvar lp Noshow Textmerge
*!*			\(<<This.Codigo>>,'<<This.nruc>>','<<cnombre>>','<<cDireccion>>',
*!*			\'<<This.ciudad>>','<<This.fono>>','<<This.fax>>','<<This.ndni>>','<<This.Tipo>>',
*!*			\'<<This.correo>>',<<This.Vendedor>>,<<This.Usuario>>,'<<This.Celular>>',
*!*			\'<<This.Refe>>','<<This.linea>>','<<This.Rpm>>','<<This.zona>>'
*!*		If goApp.clientesconsegmento = 'S' Then
*!*				\,<<This.idsegmento>>)
*!*		Else
*!*				\)
*!*		Endif
*!*		Set Textmerge Off
*!*		Set Textmerge To
	If This.EJECUTARP(m.lC, m.lp, cur) < 1 Then
		Return 0
	Endif
	Return  1
	Endproc
	Procedure Listarclientes(np1, np2, np3, nombrecursor)
	cproc		 = 'PROMUESTRACLIENTES'
	If Vartype(np1) = 'C' Then
		goApp.npara1 = Chrtran(m.np1, ' ', '%')
	Else
		goApp.npara1 = m.np1
	Endif
	goApp.npara2 = m.np2
	goApp.npara3 = m.np3
	Text To m.lparametros Noshow
    (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	Endtext
	If This.EJECUTARP10(cproc, m.lparametros, m.nombrecursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endproc
	Function ActualizaClienteRetenedor(np1, np2)
	Local lC
	Text To m.lC Noshow Textmerge
         UPDATE fe_clie SET clie_rete='<<np2>>' where idclie=<<np1>>
	Endtext
	If This.Ejecutarsql(m.lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscardni(Cruc, nid, modo)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \ Select idcliE From fe_clie Where Trim(ndni)='<<cruc>>' And clie_acti<>'I'
	If modo <> "N" Then
		\ And idcliE<><<nid>>
	Endif
	\limit 1
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, "ya") < 1
		Return 0
	Endif
	If Ya.idcliE > 0 Then
		This.Cmensaje = 'DNI Ya está Registrado '
		This.Encontrado = 'S'
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscaruc(cmodo, Cruc, nidclie)
	If Len(Alltrim(Cruc)) <> 11 Or  !ValidaRuc(Cruc) Then
		This.Cmensaje = 'RUC NO Válido'
		Return 0
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC  Noshow
	\Select nruc From fe_clie Where nruc='<<cruc>>' And clie_acti<>'I'
	If cmodo <> "N"
	 \ And idcliE<><<nidclie>>
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, "ya") < 1
		Return 0
	Endif
	If Ya.nruc = Cruc
		This.Cmensaje = "Nº de Ruc Ya Registrado"
		This.Encontrado = 'S'
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscanombre(cmodo, Cruc, nidclie)
	Ccursor = 'c_' + Sys(2015)
	If Len(Alltrim(Cruc)) <= 3 Then
		This.Cmensaje = 'Nombre de Cliente NO Válido'
		Return 0
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC  Noshow
	\Select Razo From fe_clie Where Trim(Razo)="<<cruc>>" And clie_acti<>'I'
	If cmodo <> "N"
	 \ And idcliE<><<nidclie>>
	Endif
	\ limit 1
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Select (Ccursor)
	If Len(Alltrim(Razo)) > 0
		This.Cmensaje = "Nombre Ya Registrado"
		This.Encontrado = 'S'
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarClientesY(np1, np2, np3, Ccursor)
	lC = 'PROMUESTRACLIENTES1'
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	Endtext
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Autorizacreditocliente
	Local lC, lp
	m.lC		 = 'ProAutorizaCreditoCliente'
	cur			 = ""
	goApp.npara1 = This.Codigo
	goApp.npara2 = This.Usuario
	goApp.npara3 = This.AutorizadoCredito
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	Endtext
	If This.EJECUTARP(m.lC, m.lp, cur) < 1 Then
		Return 0
	Endif
	If This.AutorizadoCredito = 1 Then
		Mensaje("Autorizado")
	Endif
	Return  1
	Endfunc
Enddefine
***************************************
Define Class clientex As Cliente

	Procedure AsignaValores
	Lparameters Codigo, Cnruc, crazo, cdire, cciud, Cfono, cfax, Cdni, Ctipo, cemail, nidven, cusua, cidpc, ccelu, crefe, Linea, crpm, nidz, ndias, cContacto, cdireccion1, nidsegmento
	This.Codigo		= m.Codigo
	This.nruc		= m.Cnruc
	This.nombre		= m.crazo
	This.Direccion	= m.cdire
	This.ciudad		= m.cciud
	This.fono		= m.Cfono
	This.fax		= m.cfax
	This.ndni		= m.Cdni
	This.Tipo		= m.Ctipo
	This.correo		= m.cemail
	This.Vendedor	= m.nidven
	This.Usuario	= m.cusua
	This.pc			= m.cidpc
	This.Celular	= m.ccelu
	This.Refe		= m.crefe
	This.Linea		= m.Linea
	This.Rpm		= m.crpm
	This.zona		= m.nidz
	This.dias		= m.ndias
	This.Contacto	= m.cContacto
	This.direccion1	= m.cdireccion1
	This.idsegmento	= m.nidsegmento
	Endproc
	Function CreaCliente
	Local lC, lp
*:Global cur
	m.lC		  = 'FUNCREACLIENTE'
	cur			  = "xt"
	goApp.npara1  = This.nruc
	goApp.npara2  = This.nombre
	goApp.npara3  = This.Direccion
	goApp.npara4  = This.ciudad
	goApp.npara5  = This.fono
	goApp.npara6  = This.fax
	goApp.npara7  = This.ndni
	goApp.npara8  = This.Tipo
	goApp.npara9  = This.correo
	goApp.npara10 = This.Vendedor
	goApp.npara11 = This.Usuario
	goApp.npara12 = This.pc
	goApp.npara13 = This.Celular
	goApp.npara14 = This.Refe
	goApp.npara15 = This.Linea
	goApp.npara16 = This.Rpm
	goApp.npara17 = This.zona
	goApp.npara18 = This.dias
	goApp.npara19 = This.Contacto
	goApp.npara20 = This.direccion1
	goApp.npara21 = This.idsegmento
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
	      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21)
	Endtext
	nidcliente = This.EJECUTARf(m.lC, m.lp, cur)
	If  nidcliente < 1 Then
		Return 0
	Endif
	Return nidcliente
	Endfunc
	Procedure ActualizaCliente
	Local lC, lp
*:Global cur
	m.lC		  = 'PROACTUALIZACLIENTE'
	cur			  = ""
	goApp.npara1  = This.Codigo
	goApp.npara2  = This.nruc
	goApp.npara3  = This.nombre
	goApp.npara4  = This.Direccion
	goApp.npara5  = This.ciudad
	goApp.npara6  = This.fono
	goApp.npara7  = This.fax
	goApp.npara8  = This.ndni
	goApp.npara9  = This.Tipo
	goApp.npara10 = This.correo
	goApp.npara11 = This.Vendedor
	goApp.npara12 = This.Usuario
	goApp.npara13 = This.Celular
	goApp.npara14 = This.Refe
	goApp.npara15 = This.Linea
	goApp.npara16 = This.Rpm
	goApp.npara17 = This.zona
	goApp.npara18 = This.dias
	goApp.npara19 = This.Contacto
	goApp.npara20 = This.direccion1
	goApp.npara21 = This.idsegmento
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,
	      ?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21)
	Endtext
	If This.EJECUTARP(m.lC, m.lp, cur) < 1 Then
		Return 0
	Endif
	Return  1
	Endproc
	Procedure CreaVinculoCliente
	Local lC, lp
*:Global cur
	m.lC		 = 'ProCreaVinculoCliente'
	cur			 = ""
	goApp.npara1 = This.Codigo
	goApp.npara2 = This.Codigov
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2)
	Endtext
	If This.EJECUTARP(m.lC, m.lp, cur) = 0 Then
		Return 0
	Endif
	Return  1
	Endproc
	Procedure EditaVinculoCliente
	Local lC, lp
*:Global cur
	m.lC		 = 'ProEditaVinculoCliente'
	cur			 = ""
	goApp.npara1 = This.Codigo
	Text To m.lp Noshow
	     (?goapp.npara1)
	Endtext
	If EJECUTARP(m.lC, m.lp, cur) = 0 Then
		Return 0
	Endif
	Return  1
	Endproc
	Procedure MostrarVinculos
	Lparameters ccur
	Local lC
	m.lC		 = ''
	goApp.npara1 = This.Codigov
	Text To m.lC Noshow Textmerge Pretext 7
	 Select  c.razo,	ifnull(Sum(v.saldo), 0) As saldo,c.idclie,clie_idvi	From fe_clie c
     Left Join	(Select  Sum(Impo - acta) As saldo, rcre_idcl As idclie
	 From fe_cred x
	 inner Join fe_rcred Y  On Y.rcre_idrc=x.cred_idrc
	 inner Join fe_clie As c  On c.idclie=Y.rcre_idcl
	 Where x.Acti='A'  And Y.rcre_acti = 'A'  And clie_idvi =<<goapp.npara1>>  Group By idclie, x.ncontrol) As v On v.idclie = c.idclie
     Where c.clie_idvi= <<goapp.npara1>> Group By c.idclie 	Order By razo
	Endtext
	If This.EJECutaconsulta(m.lC, m.ccur) < 1  Then
		Return 0
	Else
		Return  1
	Endif
	Endproc

	Procedure CreditosAutorizados
	Lparameters ccur
	Local lC
	goApp.npara1 = This.Codigo
	Text To m.lC Noshow Textmerge
		   Select  nomb, logc_fope From fe_acrecli F   inner Join fe_usua u   On u.idusua=F.logc_idus   Where logc_idcl =<<goapp.npara1>>   Order By logc_fope Desc;
	Endtext
	If This.EJECutaconsulta(m.lC, m.ccur) < 1 Then
		Return 0
	Endif
	Return  1
	Endproc
	Procedure MostrarProyectosxcliente
	Lparameters ccur
	Local lC
	m.lC		 = ''
	goApp.npara1 = This.Codigo
	Text To m.lC Noshow Textmerge Pretext 7
		Select  proy_nomb,proy_idcl,proy_idpr From fe_proyectos Where proy_idcl= <<goapp.npara1>> 		And proy_acti = 'A'
	Endtext
	If This.EJECutaconsulta(m.lC, m.ccur) < 1  Then
		Return 0
	Endif
	Return  1
	Endproc
	Procedure MostrarSucursalesxcliente
	Lparameters ccur
	Local lC
	m.lC		 = ''
	goApp.npara1 = This.Codigo
	Text To m.lC Noshow Textmerge Pretext 7
		 Select  succ_nomb, succ_dire, succ_ciud, succ_idcl, succ_id From fe_succliente	 Where succ_idcl= <<goapp.npara1>>	 And succ_acti = 'A'
	Endtext
	If This.EJECutaconsulta(m.lC, m.ccur) < 1  Then
		Return 0
	Endif
	Return  1
	Endproc
	Function CreaSucursalcliente(np1, np2, np3, np4)
	Local lC
	Text To m.lC Noshow Textmerge Pretext 7
	   INSERT INTO fe_succliente(succ_nomb,succ_dire,succ_ciud,succ_idcl)values('<<np1>>','<<np2>>','<<np3>>',<<np4>>)
	Endtext
	If This.Ejecutarsql(m.lC) < 1 Then
		Return 0
	Endif
	Mensaje("Creado Ok")
	Return 1
	Endfunc
	Function EditaSucursalcliente(np1, np2, np3, np4, np5, np6)
	Local lC
	If m.np6 = 0 Then
		Text To m.lC Noshow Textmerge Pretext 7
	   		UPDATE  fe_succliente  SET succ_acti='I' WHERE succ_id=<<np5>>
		Endtext
	Else
		Text To m.lC Noshow Textmerge Pretext 7
	   		UPDATE  fe_succliente  SET succ_nomb='<<np1>>',succ_dire='<<np2>>',succ_ciud='<<np3>>' WHERE succ_id=<<np5>>
		Endtext
	Endif
	If This.Ejecutarsql(m.lC) < 1 Then
		Return 0
	Endif
	Mensaje("Actualizado Ok")
	Return 1
	Endfunc
	Function ActualizaSegmentoCliente(np1, np2)
	Local lC
	Text To m.lC Noshow Textmerge
	     UPDATE fe_clie SET clie_idse=<<np2>> WHERE idclie=<<np1>>
	Endtext
	If This.Ejecutarsql(m.lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
*****************************************









