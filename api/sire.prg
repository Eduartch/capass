#Define MSGTITULO 'SISVEN'
Define Class sire As Custom
	Cmensaje = ""
	nmonto = 0
	na = 0
	nmes = 0
	nruc = ""
	cempresa = ""
	Idsesion = 0
	Tipo = ""
	ncorrcompras = 0
	tipog = ""
	Function  generarvtas(np1, np2)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	cnruc = This.nruc
	cempresa = This.cempresa
	Cruta = Addbs(Justpath(np1)) + np2
	cr1	  = Cruta + '.txt'
	Select cnruc As rucemisor, ;
		cempresa As empresa, ;
		Cast(Alltrim(Str(Year(fech))) + Iif(Month(fech) <= 9, '0' + Alltrim(Str(Month(fech))), Alltrim(Str(Month(fech))))  As Integer) As periodo, ;
		'' As car, ;
		fech As fech, ;
		''  As fvto, ;
		Tdoc As tipocomp, ;
		Iif(Len(Alltrim(serie)) <= 3, '0' + Trim(serie), Trim(serie)) As serie, ;
		Round(Val(Ndoc), 0) As nrocomp, ;
		'' As pagofinal, ;
		Icase(Tdoc = '01', Iif(Left(nruc, 1) = '*', '0', '6'), ;
		Tdoc = '03', Iif(Len(Alltrim(ndni)) < 8, '0', '1'), ;
		Tdoc = '07', Iif(Len(Alltrim(nruc)) = 11, '6', '1'), ;
		Tdoc = '08', Iif(Len(Alltrim(nruc)) = 11, '6', '1'), '1') As tipodocc, ;
		Icase(Tdoc = '03', Iif(Empty(ndni), '' + Space(11), ndni + Space(3)), Tdoc = '01', Iif(Left(nruc, 1) = '*', '' + Space(11), nruc), Iif(Empty(nruc), ndni + Space(3), Iif(Left(nruc, 1) = '*', '' + Space(11), nruc))) As nruc, ;
		Iif(Tdoc = '03', Iif(Empty(ndni), '' + Space(40), Razo), Iif(Left(nruc, 1) = '*', '' + Space(40), Razo)) As cliente, ;
		0 As exporta, ;
		Icase(Tdoc = '07', Iif(Month(fechn) <> Month(fech), 000000.00, valorg), Tdoc = '08', Iif(Month(fechn) <> Month(fech), 000000.00, valorg), valorg)  As Base, ;
		Icase(Tdoc = '07', Iif(Month(fechn) <> Month(fech), valorg, 000000.00), Tdoc = '08', Iif(Month(fechn) <> Month(fech), valorg, 0000000.00), 0000000.00)  As dsctoigv, ;
		Icase(Tdoc = '07', Iif(Month(fechn) <> Month(fech), 000000.00, igvg), Tdoc = '08', Iif(Month(fechn) <> Month(fech), 000000.00, igvg), igvg)  As igv, ;
		Icase(Tdoc = '07', Iif(Month(fechn) <> Month(fech), igvg, 000000.00), Tdoc = '08', Iif(Month(fechn) <> Month(fech), igvg, 0000000.00), 0000000.00)  dsctoigv1, ;
		Exon As Exon, ;
		inafecta As inafecta, ;
		0 As isc, ;
		0 As BaseIvap, ;
		0 As ivap, ;
		icbper, ;
		0 As otros, ;
		Importe As Total, ;
		Iif(Mone = 'S', 'PEN', 'USD') As Mone, ;
		Iif(dola > 0, dola, fe_gene.dola) As tipocambio, ;
		Iif(Empty(fechn), Ctod("01/01/0001"), fechn) As fechn, ;
		Iif(Empty(tref), '00', tref) As tipon, ;
		Iif(Empty(Left(Refe, 4)), '-' + Space(3), Iif(Len(Alltrim(Refe)) < 3, '0' + Left(Refe, 3), Left(Refe, 4))) As serien, ;
		Iif(Empty(Refe), '-' + Space(10), Iif(Len(Alltrim(Refe)) < 3, Substr(Refe, 4), Substr(Refe, 5))) As ndocn, ;
		'' As contrato, Mone As Moneda;
		From registro Where Left(Razo, 5) <> '-----'   And Importe <> 0 Into Cursor lreg
	Select lreg
	Set Textmerge On Noshow
	Set Textmerge To ((cr1))
	nl = 0
	Scan
		If nl = 0 Then
       \\<<rucemisor>>|<<Trim(empresa)>>|<<periodo>>|<<''>>|<<fech>>|<<fvto>>|<<tipocomp>>|<<serie>>|<<nrocomp>>|<<''>>|<<Trim(tipodocc)>>|<<Trim(nruc)>>|<<Alltrim(cliente)>>|<<exporta>>|<<Base>>|<<dsctoigv>>|<<igv>>|<<dsctoigv1>>|<<Exon>>|<<inafecta>>|<<isc>>|<<BaseIvap>>|<<ivap>>|<<icbper>>|<<otros>>|<<Total>>|<<Mone>>|<<Iif(Moneda='S','',tipocambio)>>|<<Iif(fechn=Ctod('01/01/0001'),'',fechn)>>|<<Iif(tipon='00','',tipon)>>|<<Iif(Left(serien,1)='-','',Trim(serien))>>|<<Iif(Left(ndocn,1)='-','',Round(Val(ndocn),0))>>|<<''>>|
		Else
       \<<rucemisor>>|<<Trim(empresa)>>|<<periodo>>|<<''>>|<<fech>>|<<fvto>>|<<tipocomp>>|<<serie>>|<<nrocomp>>|<<''>>|<<Trim(tipodocc)>>|<<Trim(nruc)>>|<<Alltrim(cliente)>>|<<exporta>>|<<Base>>|<<dsctoigv>>|<<igv>>|<<dsctoigv1>>|<<Exon>>|<<inafecta>>|<<isc>>|<<BaseIvap>>|<<ivap>>|<<icbper>>|<<otros>>|<<Total>>|<<Mone>>|<<Iif(Moneda='S','',tipocambio)>>|<<Iif(fechn=Ctod('01/01/0001'),'',fechn)>>|<<Iif(tipon='00','',tipon)>>|<<Iif(Left(serien,1)='-','',Trim(serien))>>|<<Iif(Left(ndocn,1)='-','',Round(Val(ndocn),0))>>|<<''>>|
		Endif
		nl = nl + 1
	Endscan
	Set Textmerge To
	Set Textmerge Off
	Set Library To Locfile("vfpcompression.fll")
	ZipfileQuick(cr1)
	zipclose()
	Endfunc
	Function generacompras(np1, np2)
	If This.tipog = 'C' Then
		ncor = This.correlativocompras()
		If ncor < 1 Then
			Return 0
		Endif
		Cruta = Addbs(Justpath(np1)) + np2 + '-' +	Iif(ncor <= 9, '0' + Alltrim(Str(ncor)), Alltrim(Str(ncor)))
	Else
		Cruta = Addbs(Justpath(np1)) + np2
	Endif
	cnruc = This.nruc
	cempresa = This.cempresa
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Select registro
	If Fsize("otros") = 0
		notros = 0
	Else
		notros = 1
	Endif
	ccuo = 'M002'
	cr1 = Cruta + '.txt'
	Select;
		cnruc As rucempresa, ;
		cempresa As empresa, ;
		Cast(Alltrim(This.na) + Iif(This.nmes <= 9, '0' + Alltrim(Str(This.nmes)), Alltrim(Str(This.nmes)))  As Integer) As periodo, ;
		'' As car, ;
		fech As fechae, ;
		'' As fvto, ;
		Tdoc As tipocomp, ;
		Iif(Tdoc = "10", '1683', Iif(Tdoc = '50', Left(Alltrim(Str(Val(serie))), 3), Iif(Len(Alltrim(serie)) <= 3, '0', '') + serie)) As serie, ;
		Iif(Tdoc = '50', Val(This.na), 0000) As fdua, ;
		Round(Val(Ndoc), 0) As nrocomp, ;
		'' As n1, ;
		6 As tipodocp, ;
		nruc As nruc, ;
		Razo As proveedor, ;
		valorg As Base, ;
		igvg As igv, ;
		0 As exporta, ;
		0 As igvex, ;
		0  As inafecta, ;
		0 As igvng, ;
		Exon, ;
		0 As isc, ;
		icbper, ;
		Iif(notros = 1, otros, notros) As otros, ;
		Importe As Total, ;
		Iif(Mone = 'S', 'PEN', 'USD') As Mone, ;
		Iif(Mone = 'S', 1.000, dola) As tipocambio, ;
		Iif(Empty(fechn), Ctod("01/01/0001"), fechn) As fechn, ;
		Iif(Empty(tref), '00', tref) As tipon, ;
		Iif(Empty(Left(Refe, 4)), '-' + Space(4), Left(Refe, 4)) As serien, ;
		'' As dadu, ;
		Iif(Empty(Refe), '-' + Space(8), Substr(Refe, 5))As ndocn, ;
		'' As pasados, ;
		'' As contrato, ;
		'' As particip, ;
		'' As impptomp, ;
		'' As cargomod, ;
		Iif(Empty(detra), '-' + Space(20), detra) As nrod, ;
		'' As notadetra, ;
		'' As estado, ;
		'' As incon, ;
		Alltrim(ccuo) As ccuo, ;
		Round((vigv * 100) - 100, 0) As porcigv, ;
		Tipo,mone as moneda, ;
		IIF(VARTYPE(Auto)='N',Alltrim(Str(Auto)),ALLTRIM(Auto)) As Auto;
		From registro Where Left(Razo, 5) <> '-----'  Into Cursor lreg
**
	Select lreg
*return
	Set Textmerge On Noshow
	Set Textmerge To ((cr1))
	nl = 0
	Scan
		If nl = 0 Then
    \\<<Trim(rucempresa)>>|<<Trim(empresa)>>|<<periodo>>|<<car>>|<<fechae>>|<<IIF(tipocomp='14',fechae,fvto)>>|<<tipocomp>>|<<serie>>|<<Iif(fdua=0,'',fdua)>>|<<nrocomp>>|<<''>>|<<tipodocp>>|<<nruc>>|<<Alltrim(proveedor)>>|<<Base>>|<<igv>>|<<exporta>>|<<igvex>>|<<inafecta>>|<<igvng>>|<<Exon>>|<<isc>>|<<icbper>>|<<otros>>|<<Total>>|<<Mone>>|<<Iif(Moneda='S','',tipocambio)>>|<<Iif(fechn=Ctod("01/01/0001"),'',fechn)>>|<<Iif(tipon='00','',tipon)>>|<<Iif(Left(serien,1)='-','',Trim(serien))>>|<<''>>|<<Iif(Left(ndocn,1)='-','',Round(Val(ndocn),0))>>|<<tipo>>|<<''>>|<<''>>|<<''>>|<<''>>|<<''>>|<<''>>|<<''>>|<<''>>|<<''>>|<<Alltrim(Auto)>>|<<porcigv>>|
		Else
     \<<Trim(rucempresa)>>|<<Trim(empresa)>>|<<periodo>>|<<car>>|<<fechae>>|<<IIF(tipocomp='14',fechae,fvto)>>|<<tipocomp>>|<<serie>>|<<Iif(fdua=0,'',fdua)>>|<<nrocomp>>|<<''>>|<<tipodocp>>|<<nruc>>|<<Alltrim(proveedor)>>|<<Base>>|<<igv>>|<<exporta>>|<<igvex>>|<<inafecta>>|<<igvng>>|<<Exon>>|<<isc>>|<<icbper>>|<<otros>>|<<Total>>|<<Mone>>|<<Iif(Moneda='S','',tipocambio)>>|<<Iif(fechn=Ctod("01/01/0001"),'',fechn)>>|<<Iif(tipon='00','',tipon)>>|<<Iif(Left(serien,1)='-','',Trim(serien))>>|<<''>>|<<Iif(Left(ndocn,1)='-','',Round(Val(ndocn),0)))>>|<<tipo>>|<<''>>|<<''>>|<<''>>|<<''>>|<<''>>|<<''>>|<<''>>|<<''>>|<<''>>|<<Alltrim(Auto)>>|<<porcigv>>|
		Endif
		nl = nl + 1
	Endscan
	Set Textmerge To
	Set Textmerge Off
	Set Library To Locfile("vfpcompression.fll")
	ZipfileQuick(cr1)
	zipclose()
	Return 1
	Endfunc
	Function opcionesvtas(opt)
	Do Case
	Case  opt = 1
		_Screen.ActiveForm.cmdaexcel.Click()
		vdvto = 1
	Case opt = 2
		Try
			Set Procedure To CapaDatos, ple5 Additive
			cf = Getfile('TXT', "Nombre:", 'Nombre', 1, "Elija Una Ubicaci�n Para Guardar el Archivo")
			If This.nmonto > 0 Then
				cr = Upper("LE" + Alltrim(This.nruc) + Alltrim(This.na) + Iif(This.nmes <= 9, '0' + Alltrim(Str(This.nmes)), Alltrim(Str(This.nmes)))) + "00140100001111"
			Else
				cr = Upper("LE" + Alltrim(This.nruc) + Alltrim(This.na) + Iif(This.nmes <= 9, '0' + Alltrim(Str(This.nmes)), Alltrim(Str(This.nmes)))) + "00140100001011"
			Endif
			This.GeneraPLE5VENTAS(cf, cr)
			Cruta = Addbs(Justpath(cf)) + cr
			This.Cmensaje = "Se Genero el Archivo:" + Cruta + " Correctamente"
			vdvto = 1
		Catch To oerror
			This.Cmensaje = "No se Genero El Archivo de Envio Correspondiente"
			vdvto = 0
		Endtry
	Case opt = 3
*!*			Try
		cf = Getfile('TXT', "Nombre:", 'Nombre', 1, "Elija Una Ubicaci�n Para Guardar el Archivo")
		If This.nmonto > 0 Then
			cr = Upper("LE" + Alltrim(This.nruc) + Alltrim(This.na) + Iif(This.nmes <= 9, '0' + Alltrim(Str(This.nmes)), Alltrim(Str(This.nmes)))) + "00140400021112"
		Else
			cr = Upper("LE" + Alltrim(This.nruc) + Alltrim(This.na) + Iif(This.nmes <= 9, '0' + Alltrim(Str(This.nmes)), Alltrim(Str(This.nmes)))) + "00140400021012"
		Endif
		This.generarvtas(cf, cr)
		Cruta = Addbs(Justpath(cf)) + cr
		This.Cmensaje = "Se Genero el Archivo:" + Cruta + " Correctamente"
		vdvto = 1
*!*			Catch To oerror
*!*				This.Cmensaje = "No se Genero El Archivo de Envio Correspondiente"
*!*				vdvto = 0
*!*			Endtry
	Endcase
	Return vdvto
	Endfunc
	Function opcioncompras(opt)
	Do Case
	Case opt = 1
		_Screen.ActiveForm.cmdaexcel.Click()
	Case opt = 2
*Try
		Set Procedure To CapaDatos, ple5 Additive
		cf = Getfile('TXT', "Nombre:", 'Nombre', 1, "Elija Una Ubicaci�n Para Guardar el Archivo")
		If This.nmonto > 0 Then
			cr = Upper("LE" + Alltrim(This.nruc) + Alltrim(This.na) + Iif(This.nmes <= 9, '0' + Alltrim(Str(This.nmes)), Alltrim(Str(This.nmes)))) + "00080100001111"
		Else
			cr = Upper("LE" + Alltrim(This.nruc) + Alltrim(This.na) + Iif(This.nmes <= 9, '0' + Alltrim(Str(This.nmes)), Alltrim(Str(This.nmes)))) + "00080100001011"
		Endif
		This.GeneraPlE5Compras(cf, cr, This.nmes, This.na)
		Cruta = Addbs(Justpath(cf)) + cr
		Messagebox("Se Genero el Archivo 1 de 2:" + Cruta + " Correctamente", 64, MSGTITULO)
		Cruta = Addbs(Justpath(cf)) + cr
		TEXT  To lC Noshow Textmerge
            SELECT com1_fech,com1_tdoc,com1_ser1,com1_ndoc,com1_valo,com1_otro,com1_impo,
			com1_tdoc1,com1_serie1,com1_a�o,com1_ndoc1,com1_rete,com1_mone,com1_dola,' ' as pais1,c.razo,concat(trim(c.dire),' ',trim(c.ciud)) as dire,
			c.nruc,ifnull(e.nruc,' ') as ndni,ifnull(e.razo,'') as razo1,' ' as pais2,
			com1_renta,com1_cost,com1_rneta,com1_vrenta,com1_irete,com1_conv,com1_exon,com1_trta,com1_modo,com1_aplica,com1_idau  as auto,com1_pais,com1_codp,
			com1_codp1,com1_pais1,com1_vinc
			FROM fe_rcom11 as a
			inner join fe_prov as c on c.idprov=a.com1_codp
			left join fe_prov as e on e.idprov=a.com1_codp1
			where com1_ActI='A' and MONTH(com1_fecr)=<<this.nmes>> and YEAR(com1_fecr)=<<this.na>>
		ENDTEXT
		ncon = AbreConexion()
		If SQLExec(ncon, lC, 'lnd') < 0 Then
			Errorbd(lC)
			Return
		Endif
		CierraConexion(ncon)
		If REgdvto("lnd") > 0 Then
			cnombre = "00080200001111"
		Else
			cnombre = "00080200001011"
		Endif
		cr = Upper("LE" + Alltrim(This.nruc) + Alltrim(This.na) + Iif(This.nmes <= 9, '0' + Alltrim(Str(This.nmes)), Alltrim(Str(This.nmes)))) + cnombre
		GeneraPlE5Compras1(cf, cr, This.nmes, Val(This.na))
		Messagebox("Se Genero el Archivo 2 de 2:" + Cruta + " Correctamente", 64, MSGTITULO)
*Catch To oerror
*	Messagebox("No se Genero El Archivo de Envio Correspondiente",16,MSGTITULO)
*Endtry
	Case opt = 3
*!*			Try
		cf = Getfile('TXT', "Nombre:", 'Nombre', 1, "Elija Una Ubicaci�n Para Guardar el Archivo")
		If This.nmonto > 0 Then
			cr = Upper("LE" + Alltrim(This.nruc) + Alltrim(This.na) + Iif(This.nmes <= 9, '0' + Alltrim(Str(This.nmes)), Alltrim(Str(This.nmes)))) + "00080400021112"
		Else
			cr = Upper("LE" + Alltrim(This.nruc) + Alltrim(This.na) + Iif(This.nmes <= 9, '0' + Alltrim(Str(This.nmes)), Alltrim(Str(This.nmes)))) + "00080400021112"
		Endif
		This.tipog = 'R'
		This.generacompras(cf, cr)
		Cruta = Addbs(Justpath(cf)) + cr
		This.Cmensaje = "Se Genero el Archivo:" + Cruta + " Correctamente"
		vdvto = 1
*!*			Catch To oerror
*!*				This.Cmensaje = "No se Genero El Archivo de Envio Correspondiente"
*!*				vdvto = 0
*!*			Endtry
	Case opt = 4
*!*			Try
		cf = Getfile('TXT', "Nombre:", 'Nombre', 1, "Elija Una Ubicaci�n Para Guardar el Archivo")
		cr = Alltrim(This.nruc) + '-CP-' + Alltrim(This.na) + Iif(This.nmes <= 9, '0' + Alltrim(Str(This.nmes)), Alltrim(Str(This.nmes)))
		This.tipog = 'C'
		This.generacompras(cf, cr)
		Cruta = Addbs(Justpath(cf)) + cr
		This.Cmensaje = "Se Genero el Archivo:" + Cruta + " Correctamente"
		vdvto = 1
*!*			Catch To oerror
*!*				This.Cmensaje = "No se Genero El Archivo de Envio Correspondiente"
*!*				vdvto = 0
*!*			Endtry
	Endcase
	Endfunc
	Function correlativocompras()
	Set Procedure To d:\capass\modelos\correlativos Additive
	ocorr = Createobject("Correlativo")
	vdvto = ocorr.correlativosirecompras()
	If vdvto < 1 Then
		This.Cmensaje = ocorr.Cmensaje
		Return 0
	Endif
	This.ncorrcompras = vdvto
	Return This.ncorrcompras
	Endfunc
	Function GeneraPlE5Compras(np1, np2, nmes, Na�o)
*:Global ccuo, cpropiedad, cr1, cruta, nl, nlote, notros
	cpropiedad = "RegimenContribuyente"
	na = Val(Na�o)
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("RegimenContribuyente", "")
	Endif
	If goApp.regimencontribuyente = 'R' Then
		ccuo = "M-RER"
	Else
		ccuo = 'M002'
	Endif
	Cruta = Addbs(Justpath(np1)) + np2
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Select registro
	If Fsize("otros") = 0
		notros = 0
	Else
		notros = 1
	Endif
	cr1 = Cruta + '.txt'
	Select;
		Cast(Alltrim(Str(na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As periodo, ;
		Auto As nrolote, ;
		Trim(ccuo) As esta, ;
		fech As fechae, ;
		fech As fvto, ;
		Tdoc As tipocomp, ;
		Iif(Tdoc = "10", '1683', Iif(Tdoc = '50', Left(Alltrim(Str(Val(serie))), 3), Iif(Len(Alltrim(serie)) <= 3, '0', '') + serie)) As serie, ;
		Iif(Tdoc = '50', na, 0000) As fdua, ;
		Ndoc As nrocomp, ;
		'' As n1, ;
		6 As tipodocp, ;
		nruc As nruc, ;
		Razo As proveedor, ;
		valorg As Base, ;
		igvg As igv, ;
		0 As Exon1, ;
		0.00 As igvng, ;
		0.00  As inafecta, ;
		0.00 As igv1, ;
		Exon, ;
		0.00 As isc, ;
		Iif(notros = 1, otros, notros) As otros, ;
		icbper, ;
		Importe As Total, ;
		Iif(Mone = 'S', 'PEN', 'USD') As Mone, ;
		Iif(Mone = 'S', 1.000, dola) As tipocambio, ;
		Iif(Empty(fechn), Ctod("01/01/0001"), fechn) As fechn, ;
		tref As tipon, ;
		Iif(Empty(Left(Refe, 4)), '-' + Space(4), Left(Refe, 4)) As serien, ;
		'   ' As dadu, ;
		Iif(Empty(Refe), '-' + Space(8), Substr(Refe, 5)) As ndocn, ;
		Iif(Empty(detra), '0' + Space(20), detra) As nrod, ;
		Iif(Isnull(fechad), Ctod("01/01/0001"), Iif(Empty(fechad), Ctod("01/01/0001"), Iif(Vartype(fechad) = 'C', Ctod(Substr(registro.fechad, 9, 2) + '/' + Substr(registro.fechad, 6, 2) + '/' + Left(registro.fechad, 4)), fechad))) As fechad, ;
		' ' As reten, ;
		Tipo As tipobien, ;
		'   ' As proy, ;
		'' As errtc, ;
		'' As errpro1, ;
		'' As errpro2, ;
		'' As errpro3, ;
		Iif(Importe > 3500, '1', ' ') As Mpago, ;
		Icase(Tdoc = '01', Iif(Month(fech) = nmes, '1', '6'), ;
		Tdoc = '02', Iif(Month(fech) = nmes, '0', '0'), ;
		Tdoc = '03', Iif(Month(fech) = nmes, '0', '0'), ;
		Tdoc = '05', Iif(Month(fech) = nmes, '1', '6'), ;
		Tdoc = '06', Iif(Month(fech) = nmes, '1', '6'), ;
		Tdoc = '07', Iif(Month(fech) = nmes, '1', '6'), ;
		Tdoc = '08', Iif(Month(fech) = nmes, '1', '6'), ;
		Tdoc = '10', '0', ;
		Tdoc = '12', Iif(Month(fech) = nmes, '1', '6'), ;
		Tdoc = '13', Iif(Month(fech) = nmes, '1', '6'), ;
		Tdoc = '14', Iif(Month(fech) = nmes, '1', '6'), ;
		Tdoc = '16', '0', ;
		Tdoc = '50', Iif(Month(fech) = nmes, '1', '6'), ;
		Iif(Month(fech) = nmes, '1', '9')) As estado;
		From registro Where Left(Razo, 5) <> '-----'  Into Cursor lreg
	Select lreg
	Set Textmerge On Noshow
	Set Textmerge To ((cr1))
	nl = 0
	Scan
		nlote = nrolote
		If nl = 0 Then
    \\<<periodo>>|<<nrolote>>|<<esta>>|<<fechae>>|<<fvto>>|<<tipocomp>>|<<serie>>|<<fdua>>|<<nrocomp>>|<<n1>>|<<tipodocp>>|<<nruc>>|<<Alltrim(proveedor)>>|<<Base>>|<<igv>>|<<Exon1>>|<<igvng>>|<<inafecta>>|<<igv1>>|<<Exon>>|<<isc>>|<<icbper>>|<<otros>>|<<Total>>|<<Mone>>|<<tipocambio>>|<<fechn>>|<<tipon>>|<<serien>>|<<dadu>>|<<ndocn>>|<<fechad>>|<<nrod>>|<<reten>>|<<tipobien>>|<<proy>>|<<errtc>>|<<errpro1>>|<<errpro2>>|<<errpro3>>|<<Mpago>>|<<estado>>|
		Else
     \<<periodo>>|<<nrolote>>|<<esta>>|<<fechae>>|<<fvto>>|<<tipocomp>>|<<serie>>|<<fdua>>|<<nrocomp>>|<<n1>>|<<tipodocp>>|<<nruc>>|<<Alltrim(proveedor)>>|<<Base>>|<<igv>>|<<Exon1>>|<<igvng>>|<<inafecta>>|<<igv1>>|<<Exon>>|<<isc>>|<<icbper>>|<<otros>>|<<Total>>|<<Mone>>|<<tipocambio>>|<<fechn>>|<<tipon>>|<<serien>>|<<dadu>>|<<ndocn>>|<<fechad>>|<<nrod>>|<<reten>>|<<tipobien>>|<<proy>>|<<errtc>>|<<errpro1>>|<<errpro2>>|<<errpro3>>|<<Mpago>>|<<estado>>|
		Endif
		nl = nl + 1
	Endscan
	Set Textmerge To
	Set Textmerge Off
	Endfunc
	Function GeneraPLE5VENTAS(np1, np2)
	cpropiedad = "RegimenContribuyente"
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("RegimenContribuyente", "")
	Endif
	If goApp.regimencontribuyente = 'R' Then
		ccuo = "M-RER"
	Else
		ccuo = 'M001'
	Endif
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Cruta = Addbs(Justpath(np1)) + np2
	cr1	  = Cruta + '.txt'
	Select;
		Cast(Alltrim(Str(Year(fech))) + Iif(Month(fech) <= 9, '0' + Alltrim(Str(Month(fech))), Alltrim(Str(Month(fech)))) + '00' As Integer) As periodo, ;
		Auto As nrolote, ;
		Trim(ccuo + Alltrim(Str(Recno()))) As esta, ;
		fech As Fecha, ;
		fech As fvto, ;
		Tdoc As tipocomp, ;
		Iif(Len(Alltrim(serie)) <= 3, '0' + Trim(serie), Trim(serie)) As serie, ;
		Round(Val(Ndoc), 0) As nrocomp, ;
		' ' As consolidado, ;
		Icase(Tdoc = '01', Iif(Left(nruc, 1) = '*', '0', '6'), ;
		Tdoc = '03', Iif(Len(Alltrim(ndni)) < 8, '0', '1'), ;
		Tdoc = '07', Iif(Len(Alltrim(nruc)) = 11, '6', '1'), ;
		Tdoc = '08', Iif(Len(Alltrim(nruc)) = 11, '6', '1'), '1') As tipodocc, ;
		Icase(Tdoc = '03', Iif(Empty(ndni), '0' + Space(11), ndni + Space(3)), Tdoc = '01', Iif(Left(nruc, 1) = '*', '0' + Space(11), nruc), Iif(Empty(nruc), ndni + Space(3), Iif(Left(nruc, 1) = '*', '-' + Space(11), nruc))) As nruc, ;
		Iif(Tdoc = '03', Iif(Empty(ndni), '-' + Space(40), Razo), Iif(Left(nruc, 1) = '*', '-' + Space(40), Razo)) As cliente, ;
		0.00 As exporta, ;
		valorg As Base, ;
		0.00 As dsctoigv, ;
		igvg As igv, ;
		0.00 As dsctoigv1, ;
		Exon As Exon, ;
		inafecta As inafecta, ;
		0.00 As isc, ;
		0.00 As pilado, ;
		0.00 As igvp, ;
		0.00 As otros, ;
		icbper, ;
		Importe As Total, ;
		Iif(Mone = 'S', 'PEN', 'USD') As Mone, ;
		Iif(Mone = 'S', 1.000, Iif(dola > 0, dola, fe_gene.dola)) As tipocambio, ;
		Iif(Empty(fechn), Ctod("01/01/0001"), fechn) As fechn, ;
		Iif(Empty(tref), '00', tref) As tipon, ;
		Iif(Empty(Left(Refe, 4)), '-' + Space(3), Iif(Len(Alltrim(Refe)) < 3, '0' + Left(Refe, 3), Left(Refe, 4))) As serien, ;
		Iif(Empty(Refe), '-' + Space(10), Iif(Len(Alltrim(Refe)) < 3, Substr(Refe, 4), Substr(Refe, 5))) As ndocn, ;
		' ' As contrato, ;
		'1' As errtc, ;
		Iif(Importe > 3500, '1', ' ') As Mpago, ;
		Iif(Left(nruc, 1) = '*', '2', '1') As estado From registro Where Left(Razo, 5) <> '-----'  Into Cursor lreg
	Select lreg
	Set Textmerge On Noshow
	Set Textmerge To ((cr1))
	nl = 0
	Scan
		If nl = 0 Then
   \\<<periodo>>|<<nrolote>>|<<esta>>|<<fecha>>|<<fvto>>|<<tipocomp>>|<<serie>>|<<nrocomp>>|<<consolidado>>|<<tipodocc>>|<<nruc>>|<<Alltrim(cliente)>>|<<exporta>>|<<Base>>|<<dsctoigv>>|<<igv>>|<<dsctoigv1>>|<<Exon>>|<<inafecta>>|<<isc>>|<<pilado>>|<<igvp>>|<<icbper>>|<<otros>>|<<Total>>|<<Mone>>|<<tipocambio>>|<<fechn>>|<<tipon>>|<<serien>>|<<ndocn>>|<<contrato>>|<<errtc>>|<<Mpago>>|<<estado>>|
		Else
    \<<periodo>>|<<nrolote>>|<<esta>>|<<fecha>>|<<fvto>>|<<tipocomp>>|<<serie>>|<<nrocomp>>|<<consolidado>>|<<tipodocc>>|<<nruc>>|<<Alltrim(cliente)>>|<<exporta>>|<<Base>>|<<dsctoigv>>|<<igv>>|<<dsctoigv1>>|<<Exon>>|<<inafecta>>|<<isc>>|<<pilado>>|<<igvp>>|<<icbper>>|<<otros>>|<<Total>>|<<Mone>>|<<tipocambio>>|<<fechn>>|<<tipon>>|<<serien>>|<<ndocn>>|<<contrato>>|<<errtc>>|<<Mpago>>|<<estado>>|
		Endif
		nl = nl + 1
	Endscan
	Set Textmerge To
	Set Textmerge Off
	Endfunc
Enddefine























