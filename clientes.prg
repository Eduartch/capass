Define Class cliente As   Odata Of  'd:\capass\database\data.prg'
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
	linea	   = 0
	Rpm		   = ""
	zona	   = 0
	idsegmento = 0
	Cmensaje   = ""
	Procedure AsignaValores
	Lparameters Codigo, Cnruc, crazo, cdire, cciud, cfono, cfax, cdni, ctipo, cemail, nidven, cusua, cidpc, ccelu, crefe, linea, crpm, nidz
	This.Codigo	   = m.Codigo
	This.nruc	   = m.Cnruc
	This.nombre	   = m.crazo
	This.Direccion = m.cdire
	This.ciudad	   = m.cciud
	This.fono	   = m.cfono
	This.fax	   = m.cfax
	This.ndni	   = m.cdni
	This.Tipo	   = m.ctipo
	This.correo	   = m.cemail
	This.Vendedor  = m.nidven
	This.Usuario   = m.cusua
	This.pc		   = m.cidpc
	This.Celular   = m.ccelu
	This.Refe	   = m.crefe
	This.linea	   = m.linea
	This.Rpm	   = m.crpm
	This.zona	   = m.nidz
	Endproc
	Function CreaCliente
	Local lC, lp
*:Global Cmensaje, cur
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
	goApp.npara15 = This.linea
	goApp.npara16 = This.Rpm
	goApp.npara17 = This.zona
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
	Endtext
	nid = This.EJECUTARf(m.lC, m.lp, cur)
	If nid < 1 Then
		Return 0
	Endif
	Return nid
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
	goApp.npara15 = This.linea
	goApp.npara16 = This.Rpm
	goApp.npara17 = This.zona
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
	Endtext
	If this.EJECUTARP(m.lC, m.lp, cur)<1  Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure Listarclientes
	Lparameters	np1, np2, np3, nombrecursor
	Local lparametros
*:Global cproc
	cproc		 = ""
	cproc		 = 'PROMUESTRACLIENTES'
	goApp.npara1 = m.np1
	goApp.npara2 = m.np2
	goApp.npara3 = m.np3
	Text To m.lparametros Noshow
          (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	Endtext
	If this.EJECUTARP(cproc, m.lparametros, m.nombrecursor) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endproc
Enddefine
***************************************
Define Class clientex As cliente
	dias			  = 0
	contacto		  = ""
	direccion1		  = ""
	Codigov			  = 0
	Usuario			  = 0
	AutorizadoCredito = 0
	Procedure AsignaValores
	Lparameters Codigo, Cnruc, crazo, cdire, cciud, cfono, cfax, cdni, ctipo, cemail, nidven, cusua, cidpc, ccelu, crefe, linea, crpm, nidz, ndias, cContacto, cdireccion1, nidsegmento
	This.Codigo		= m.Codigo
	This.nruc		= m.Cnruc
	This.nombre		= m.crazo
	This.Direccion	= m.cdire
	This.ciudad		= m.cciud
	This.fono		= m.cfono
	This.fax		= m.cfax
	This.ndni		= m.cdni
	This.Tipo		= m.ctipo
	This.correo		= m.cemail
	This.Vendedor	= m.nidven
	This.Usuario	= m.cusua
	This.pc			= m.cidpc
	This.Celular	= m.ccelu
	This.Refe		= m.crefe
	This.linea		= m.linea
	This.Rpm		= m.crpm
	This.zona		= m.nidz
	This.dias		= m.ndias
	This.contacto	= m.cContacto
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
	goApp.npara15 = This.linea
	goApp.npara16 = This.Rpm
	goApp.npara17 = This.zona
	goApp.npara18 = This.dias
	goApp.npara19 = This.contacto
	goApp.npara20 = This.direccion1
	goApp.npara21 = This.idsegmento
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
	      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21)
	Endtext
	Nid=this.EJECUTARf(m.lC, m.lp, cur)
	IF nid <1  Then
		Return 0
	Else
		Return nid
	Endif
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
	goApp.npara15 = This.linea
	goApp.npara16 = This.Rpm
	goApp.npara17 = This.zona
	goApp.npara18 = This.dias
	goApp.npara19 = This.contacto
	goApp.npara20 = This.direccion1
	goApp.npara21 = This.idsegmento
*WAIT WINDOW this.linea
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,
	      ?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21)
	Endtext
	If this.EJECUTARP(m.lC, m.lp, cur) <1  Then
		Return 0
	Else
		Return  1
	Endif
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
	If this.EJECUTARP(m.lC, m.lp, cur) <1 Then
    	Return 0
	Else
		Return  1
	Endif
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
	If this.EJECUTARP(m.lC, m.lp, cur) < 1 Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure MostrarVinculos
	Lparameters ccur
	Local lC
	m.lC		 = ''
	goApp.npara1 = This.Codigov
	Text To m.lC Noshow Textmerge Pretext 7
	    c.razo,ifnull(sum(v.saldo),0) as saldo,c.idclie,clie_idvi from fe_clie c
	    left join
		(select sum(impo-acta) as saldo,rcre_idcl as idclie from fe_cred x
		inner join fe_rcred y on y.rcre_idrc=x.cred_idrc
		inner join fe_clie as c on c.idclie=y.rcre_idcl
		where x.acti='A' and y.rcre_acti='A' and clie_idvi=<<goapp.npara1>> group by idclie,x.ncontrol) as v on v.idclie=c.idclie
		where c.clie_idvi=<<goapp.npara1>>  group by c.idclie order by razo
	Endtext
	If this.EjecutaConsulta(m.lC, m.ccur) < 1  Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure Autorizacreditocliente
	Local lC, lp
	m.lC		 = 'ProAutorizaCreditoCliente'
	cur			 = ""
	goApp.npara1 = This.Codigo
	goApp.npara2 = This.Usuario
	goApp.npara3 = This.AutorizadoCredito
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	Endtext
	If this.EJECUTARP(m.lC, m.lp, cur) < 1  Then
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
   	    nomb,logc_fope FROM fe_acrecli f
   	    inner join fe_usua u on u.idusua=f.logc_idus WHERE logc_idcl=<<goapp.npara1>> order by logc_fope desc;
	Endtext
	If this.EjecutaConsulta(m.lC, m.ccur) < 1 Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure MostrarProyectosxcliente
	Lparameters ccur
	Local lC
	m.lC		 = ''
	goApp.npara1 = This.Codigo
	Text To m.lC Noshow Textmerge Pretext 7
	     proy_nomb,proy_idcl,proy_idpr FROM fe_proyectos WHERE proy_idcl=<<goapp.npara1>> and proy_acti='A'
	Endtext
	If this.EjecutaConsulta(m.lC, m.ccur) < 1  Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure MostrarSucursalesxcliente
	Lparameters ccur
	Local lC
	m.lC		 = ''
	goApp.npara1 = This.Codigo
	Text To m.lC Noshow Textmerge Pretext 7
	     succ_nomb,succ_dire,succ_ciud,succ_idcl,succ_id FROM fe_succliente WHERE succ_idcl=<<goapp.npara1>> and succ_acti='A'
	Endtext
	If this.EjecutaConsulta(m.lC, m.ccur) < 1  Then
		Return 0
	Else
		Return  1
	Endif
	Endproc

	Function CreaSucursalcliente(np1, np2, np3, np4)
	Local lC
	Text To m.lC Noshow Textmerge Pretext 7
	   INSERT INTO fe_succliente(succ_nomb,succ_dire,succ_ciud,succ_idcl)values('<<np1>>','<<np2>>','<<np3>>',<<np4>>)
	Endtext
	If this.Ejecutarsql(m.lC) < 1 Then
		Return 0
	Endif
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
	If Ejecutarsql(m.lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizaSegmentoCliente(np1, np2)
	Local lC
	Text To m.lC Noshow Textmerge
	      UPDATE fe_clie SET clie_idse=<<np2>> WHERE idclie=<<np1>>
	Endtext
	If this.Ejecutarsql(m.lC) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
Enddefine
*****************************************

