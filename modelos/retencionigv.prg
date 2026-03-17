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
	cserie=""
	ctiporetencion=""
	Function IngresaRetencion()
	lC = 'FunIngresaRRetencion'
	cur = "Nid"
	TEXT To lp Noshow Textmerge
     ('<<cfechas(this.dfecha)>>',<<this.ncodigo>>,<<this.nimpo>>,'<<this.cndoc>>','<<this.cmoneda>>',<<this.ndolar>>,<<this.nidusua>>)
	ENDTEXT
	xid = This.EJECUTARf(lC, lp, cur)
	If  xid < 1 Then
		Return 0
	Endif
	Return xid
	Endfunc
	Function AnulaRetencion()
	If This.nidr < 1 Then
		This.Cmensaje = 'Seleccione Un Documento'
		Return 0
	Endif
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	TEXT To lC Noshow Textmerge
	UPDATE fe_dret SET dret_acti='I' WHERE dret_idre=<<this.nidr>>;
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	TEXT To lC Noshow Textmerge
	   UPDATE fe_rret SET rete_acti='I' WHERE rete_idre=<<this.nidr>>;
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	TEXT To lC Noshow Textmerge
	   UPDATE fe_ldiario SET ldia_acti='I' WHERE ldia_idre=<<this.nidr>>;
	ENDTEXT
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
	TEXT To lp Noshow Textmerge
     (<<this.nidr>>,<<this.niDAUTO>>,<<this.nimpor>>,<<this.nvalor>>,<<this.nidd>>,'<<this.ctdoc>>','<<this.cndocd>>',<<this.nimpo1>>,'<<cfechas(this.dfechad)>>')
	ENDTEXT
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Registra()
	Set Procedure To d:\capass\modelos\ctasxpagar, d:\capass\modelos\Ldiario,d:\capass\modelos\correlativos Additive
	If This.ctiporetencion='SEEC' Then
		ocorr=Createobject("correlativo")
		If ocorr.BuscarSeriesRetencion(1, 'series')<1 Then
			This.Cmensaje=ocorr.Cmensaje
			Return 0
		Endif
		This.cndoc="R"+Right("0000"+goapp.serief,3)+Right("000000000"+Alltrim(Str(series.nume)),8)
		nsgte=series.nume
		nidserie=series.idserie
	Endif
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
			This.Cmensaje=oxpagar.Cmensaje
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
		This.nimpo1=  lt.montomn
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
	If This.ctiporetencion='SEEC' Then
		ocorr.Ndoc = This.cndoc
		ocorr.nsgte = m.nsgte
		ocorr.idserie = m.nidserie
		If ocorr.GeneraCorrelativo() < 1 Then
			This.Cmensaje = ocorr.Cmensaje
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	This.imprimir()
	Return 1
	Endfunc
	Function VAlidar()
	Do Case
	Case This.Ncodigo < 1
		Thi.Cmensaje = "Seleccione Un Proveedor"
		Return 0
	Case This.nimpo = 0
		This.Cmensaje = "Seleccione Documentos Válidos a Realizar la Retención del IGV"
		Return 0
	Case !esfechaValida(This.dFecha)
		This.Cmensaje = "Ingrese Una Fecha Válida"
		Return 0
	Case Len(Alltrim(Left(This.cndoc, 4))) < 4 Or Len(Alltrim(Substr(This.cndoc, 4))) < 8
		This.Cmensaje = "Ingrese Serie(debe contener 4 Caracteres) y Número Válidos(Debe contener 8 caracteres) "
		Return 0
	Otherwise
		Return  1
	Endcase
	Endfunc
	Function Listar(Ccursor)
	TEXT To lC Noshow Textmerge
	select a.rete_fech,a.rete_impo,a.rete_dola,a.rete_ndoc,a.rete_mone,f.nomb,a.rete_fope,a.rete_mone as mone,a.rete_dola as dolar,a.rete_idpr,
	b.dret_impo,x.razo,x.nruc,b.dret_imp1 as impo,b.dret_ndoc as ndoc,b.dret_tdoc as tdoc,b.dret_fech as fech,a.rete_idre from fe_rret as a
	inner join fe_dret as b on b.dret_idre=a.rete_idre
	inner join fe_prov as x on x.idprov=a.rete_idpr
	inner join fe_usua as f on f.idusua=a.rete_idus
	where a.rete_acti='A' and b.dret_acti='A' and  YEAR(rete_fech)=<<this.Naño>>
	order by rete_fech desc
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function verificasiestaRegistradacomoPago(idp,cndoc)
	Ccursor = 'c_' + Sys(2015)
	TEXT To lC Noshow Textmerge
	SELECT idauto as idre FROM fe_rcom WHERE ndoc='<<cndoc>>' AND tdoc='20' AND idcliente=<<idp>> AND tipom='C' AND  acti<>'I' limit 1;
	ENDTEXT
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
	Function verificaSiestaRegistrada(cndoc)
	Ccursor = 'c_' + Sys(2015)
	TEXT To lC Noshow Textmerge
    SELECT rete_idre as idre FROM fe_rret  WHERE rete_ndoc='<<cndoc>>' AND rete_Acti='A' GROUP BY rete_idre;
	ENDTEXT
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
	TEXT To lC Noshow Textmerge
	        select a.rete_fech,a.rete_impo,a.rete_dola,a.rete_ndoc,a.rete_mone,f.nomb,a.rete_fope,a.rete_idpr,x.tpagado,
			b.dret_impo,x.razo,x.nruc,b.dret_imp1 as impo,b.dret_ndoc as ndoc,b.dret_tdoc as tdoc,b.dret_fech as fech,a.rete_idre,b.dret_valor,dret_iddr
			from fe_rret as a
			inner join fe_dret as b on b.dret_idre=a.rete_idre
			inner join fe_prov as x on x.idprov=a.rete_idpr
            inner join (select dret_idre,sum(dret_imp1) as tpagado from fe_dret as x where dret_acti='A' group by dret_idre) as x on x.dret_idre=a.rete_idre
			inner join fe_usua as f on f.idusua=a.rete_idus
			where a.rete_acti='A' and b.dret_acti='A' AND a.rete_fech between '<<dfi>>' AND '<<dff>>' order by rete_fech
	ENDTEXT
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
	Select Y
	Scan All
		TEXT To lC Noshow Textmerge
	     UPDATE fe_rcom SET rcom_pert='<<cperiodo>>' WHERE idauto=<<y.idauto>>
		ENDTEXT
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
	Return 1
	Endfunc
	Function imprimir()
	Create Cursor tmpr(Tdoc c(2), Serie c(4), numero c(8), Fecha d, monto N(12, 2), rete N(12, 2), Ndoc c(12), nruc c(11), Razon c(100), fech d, copia c(1),cletras c(120))
	If This.nidr>0 Then
		If This.consultarporid('listar')<1 Then
			Return 0
		Endif
		ccletras=diletras(Listar.rete_impo,'S')
		Select Listar
		Scan All
			Insert Into tmpr(Tdoc,Serie,numero,Fecha,monto,rete,Ndoc,nruc,Razon,fech,cletras);
				values(Listar.Tdoc,Left(Listar.Ndoc,4),Substr(Listar.Ndoc,5),Listar.Fecha,;
				Listar.Impo,Listar.dret_impo,Listar.rete_ndoc,Listar.nruc,Listar.Razo,Listar.rete_fech,m.ccletras)
		Endscan
	Else
		ccletras=diletras(This.nimpo,'S')
		Select lt
		Scan All
			Insert Into tmpr(Tdoc,Serie,numero,Fecha,monto,rete,Ndoc,nruc,Razon,fech,cletras);
				values(lt.Tdoc,lt.Serie,lt.numero,lt.Fecha,lt.montomn,lt.rete,This.cndoc,lt.nruc,lt.Razo,lt.fech,m.ccletras)
		Endscan
	Endif
	Set Procedure To  d:\capass\imprimir Additive
	oimp=Createobject("imprimir")
	Select tmpr
	oimp.Tdoc='RR'
	oimp.ImprimeComprobanteM('S')
	Return 1
	Endfunc
	Function consultarporid(Ccursor)
	TEXT To lC Noshow Textmerge
	select a.rete_fech,a.rete_impo,a.rete_dola,a.rete_ndoc,a.rete_mone,f.nomb,a.rete_fope,a.rete_mone as mone,a.rete_dola as dolar,a.rete_idpr,
	b.dret_impo,x.razo,x.nruc,b.dret_imp1 as impo,b.dret_ndoc as ndoc,b.dret_tdoc as tdoc,b.dret_fech as fecha,a.rete_idre,rete_porc from fe_rret as a
	inner join fe_dret as b on b.dret_idre=a.rete_idre
	inner join fe_prov as x on x.idprov=a.rete_idpr
	inner join fe_usua as f on f.idusua=a.rete_idus
	where a.rete_acti='A' and b.dret_acti='A' and rete_idre=<<this.nidr>>
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarxinformar(Ccursor)
	TEXT To lC Noshow Textmerge
	select a.rete_fech,a.rete_ndoc,x.razo,a.rete_impo,rete_fope,a.rete_idre,x.nruc from fe_rret as a
	inner join fe_prov as x on x.idprov=a.rete_idpr
	where a.rete_acti='A' and LEFT(rete_ndoc,1)='R' and LEFT(rete_mens,1)<>'0' order by rete_ndoc,rete_fech
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine






