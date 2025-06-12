Define Class Retencion As OData Of "d:\capass\database\data.prg"
	dFecha = Date()
	Ncodigo = 0
	nimpo = 0
	cndoc = ""
	Cmoneda = ""
	ndolar = 0
	nidusua = 0
	nidr = 0
	niDAUTO = 0
	nimpor = 0
	nvalor = 0
	nidd = 0
	cTdoc = ""
	cndocd = ""
	nimpo1 = 0
	dfechad = Date()
	nmes = 0
	Naño = 0
	Function IngresaRetencion()
	lC = 'FunIngresaRRetencion'
	cur = "Nid"
	Text To lp Noshow Textmerge
     ('<<cfechas(this.dfecha)>>',<<this.ncodigo>>,<<this.nimpo>>,'<<this.cndoc>>','<<this.cmoneda>>',<<this.ndolar>>,<<this.nidusua>>)
	Endtext
	nid = This.EJECUTARf(lC, lp, cur)
	If  nid < 0 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function AnulaRetencion()
	If This.nidr < 1 Then
		This.Cmensaje = 'Seleccione Un Documento'
		Return 0
	Endif
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	Text To lC Noshow Textmerge
	UPDATE fe_dret SET dret_acti='I' WHERE dret_idre=<<this.nidr>>;
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Text To lC Noshow Textmerge
	   UPDATE fe_rret SET rete_acti='I' WHERE rete_idre=<<this.nidr>>;
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Text To lC Noshow Textmerge
	   UPDATE fe_ldiario SET ldia_acti='I' WHERE ldia_idre=<<this.nidr>>;
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaDretencion()
	lC = 'ProRegistraDretencion'
	cur = ""
	Text To lp Noshow Textmerge
     (<<this.nidr>>,<<this.niDAUTO>>,<<this.nimpor>>,<<this.nvalor>>,<<this.nidd>>,'<<this.ctdoc>>','<<this.cndocd>>',<<this.nimpo1>>,'<<cfechas(this.dfechad)>>')
	Endtext
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Registra()
	Set Procedure To d:\capass\modelos\ctasxpagar, d:\capass\modelos\Ldiario Additive
	cglosa = "Retención "
	cdctod = "Re-" + This.cndoc
	oxpagar = Createobject("ctasporpagar")
	If This.VAlidar() < 1 Then
		Return 0
	Endif
	odiario = Createobject("ldiario")
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	nidrete = This.IngresaRetencion()
	If m.nidrete < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	s = 1
	Select lt
	Go Top
	Do While !Eof()
		oxpagar.dFech = lt.fech
		oxpagar.dfevto = lt.Fevto
		oxpagar.Cmoneda = lt.Moneda
		oxpagar.ndolar = This.ndolar
		oxpagar.nacta = Iif(lt.Moneda = 'S', lt.rete, Round(lt.rete / oxpagar.ndolar, 2))
		oxpagar.cdcto = This.cndoc
		oxpagar.Cestado = 'P'
		oxpagar.cdetalle = "RETENCION"
		oxpagar.Ctipo = lt.Tipo
		oxpagar.nidrd = lt.Idrd
		oxpagar.Ncontrol = lt.ctrl
		nidd = oxpagar.CancelaDeudas()
		If nidd = 0 Then
			s = 0
			Exit
		Endif
		This.nidr = m.nidrete
		This.niDAUTO = Iif(lt.Tipo = 'L', 0, lt.Idauto)
		This.nimpor = lt.rete
		This.nvalor = fe_gene.Retencion
		This.nidd = m.nidd
		This.cTdoc = lt.Tdoc
		This.cndocd = lt.Serie + lt.numero
		This.dfechad = lt.Fecha
		If This.IngresaDretencion() < 1 Then
			s = 0
			Exit
		Endif
		Select lt
		Skip
	Enddo
	If s = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If odiario.IngresaDatosDiarioretencion(This.dFecha, This.nimpo, 0, cglosa, 'D', cdctod, Ctasdebe.idcta, 'A', 1, "", 0, 0, 'S', 'N', 0, nidrete) < 1 Then
		This.DEshacerCambios()
		This.Cmensaje = odiario.Cmensaje
		Return 0
	Endif
	If odiario.IngresaDatosDiarioretencion(This.dFecha, 0, This.nimpo, cglosa, 'H', cdctod, Ctashaber.idcta, 'A', 2, "", 0, 0, 'S', 'N', 0, nidrete) < 1 Then
		This.DEshacerCambios()
		This.Cmensaje = odiario.Cmensaje
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function VAlidar()
	Do Case
	Case This.Ncodigo = 0
		Thi.Cmensaje = "Seleccione Un Proveedor"
		Return 0
	Case This.nimpo = 0
		This.Cmensaje = "Seleccione Documentos Válidos a Realizar la Retención del IGV"
		Return 0
	Case !esfechaValida(This.dFecha)
		This.Cmensaje = "Ingrese Una Fecha Válida"
		Return 0
	Case Len(Alltrim(Left(This.cndoc, 4))) < 4 Or Len(Alltrim(Substr(This.cndoc, 4))) < 8
		This.Cmensaje = "Ingrese Serie y Número Válidos"
		Return 0
	Otherwise
		Return  1
	Endcase
	Endfunc
	Function Listar(Ccursor)
	Text To lC Noshow Textmerge
	select a.rete_fech,a.rete_impo,a.rete_dola,a.rete_ndoc,a.rete_mone,f.nomb,a.rete_fope,a.rete_mone as mone,a.rete_dola as dolar,a.rete_idpr,
	b.dret_impo,x.razo,x.nruc,b.dret_imp1 as impo,b.dret_ndoc as ndoc,b.dret_tdoc as tdoc,b.dret_fech as fech,a.rete_idre from fe_rret as a
	inner join fe_dret as b on b.dret_idre=a.rete_idre
	inner join fe_prov as x on x.idprov=a.rete_idpr
	inner join fe_usua as f on f.idusua=a.rete_idus
	where a.rete_acti='A' and b.dret_acti='A' and  YEAR(rete_fech)=<<this.Naño>>
	order by rete_fech desc
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	ENDFUNC
	FUNCTION verificasiestaRegistradacomoPago(idp,cndoc)
	Ccursor = 'c_' + Sys(2015)
	Text To lC Noshow Textmerge
	SELECT idauto as idre FROM fe_rcom WHERE ndoc='<<cndoc>>' AND tdoc='20' AND idcliente=<<idp>> AND tipom='C' AND  acti<>'I' limit 1;
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If idre > 0 Then
		This.Cmensaje = 'Ya Registrado'
		Return 0
	Endif
	Return 1
	ENDFUNC 
	Function verificaSiestaRegistrada(cndoc)
	Ccursor = 'c_' + Sys(2015)
	Text To lC Noshow Textmerge
    SELECT rete_idre as idre FROM fe_rret  WHERE rete_ndoc='<<cndoc>>' AND rete_Acti='A' GROUP BY rete_idre;
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If idre > 0 Then
		This.Cmensaje = 'Ya Registrado'
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarporfechas(fi, ff, Ccursor)
	dfi = Cfechas(fi)
	dff = Cfechas(ff)
	Text To lC Noshow Textmerge
	        select a.rete_fech,a.rete_impo,a.rete_dola,a.rete_ndoc,a.rete_mone,f.nomb,a.rete_fope,a.rete_idpr,x.tpagado,
			b.dret_impo,x.razo,x.nruc,b.dret_imp1 as impo,b.dret_ndoc as ndoc,b.dret_tdoc as tdoc,b.dret_fech as fech,a.rete_idre,b.dret_valor,dret_iddr
			from fe_rret as a 
			inner join fe_dret as b on b.dret_idre=a.rete_idre 
			inner join fe_prov as x on x.idprov=a.rete_idpr
            inner join (select dret_idre,sum(dret_imp1) as tpagado from fe_dret as x where dret_acti='A' group by dret_idre) as x on x.dret_idre=a.rete_idre
			inner join fe_usua as f on f.idusua=a.rete_idus 
			where a.rete_acti='A' and b.dret_acti='A' AND a.rete_fech between '<<dfi>>' AND '<<dff>>' order by rete_fech
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function registrarpagoretencionperiodo(cperiodo)
	s = 1
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	Select y
	Scan All
		Text To lC Noshow Textmerge
	  UPDATE fe_rcom SET rcom_pert='<<cperiodo>>' WHERE idauto=<<y.idauto>>
		Endtext
		If This.Ejecutarsql(lC) < 1 Then
			s = 0
			Exit
		Endif
	Endscan
	If s = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'ok'
	Return 1
	Endfunc
Enddefine






