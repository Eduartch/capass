#Define ERRORPROC "Inconevientes"
#Define MSGTITULO "Sisven"
#Define MENSAJE1 "NO Se env�o el comprobante Por las siguientes razones"+Chr(13)+Chr(10)+" NO Hay Conexi�n a Internet "+Chr(13)+Chr(10)
#Define MENSAJE2 "NO Hay Respuesta desde la WEB SERVICE DE SUNAT"+Chr(13)+Chr(10)
#Define MENSAJE3 " Ya se envio correctamente pero la respuesta no se recibio Correctamente-(Consultar con Clave Sol en www.sunat.gob.pe)"
#Define WEB   'http://compania-sysven.com/'
*DO e:\foxbin2prg-master\foxbin2prg.exe WITH  "d:\psysn\forms\ka_pedidos.sc2"
***********************
*PostgreSQL
Procedure Settear()
Set Talk Off
Set Delete On
Set Century To 19
Set Exclusive Off
Set Safety Off
Set Optimize On
Set Date To Dmy
Set Century On
Set Reprocess To 30 Seconds
Set Escape Off
Set Multilocks On
Set Bell  Off
*Set Resource Off
*	Set Resource To
Set ENGINEBEHAVIOR 70
Endproc
**************
Function conectarPostgress()
Local laError[1], lcDatabase, lcPassword, lcServer, lcStringConn, lcUser, lnHandle
lcServer   = "10.67.28.7" && ip del servidor o "localhost" si postgresql esta en la misma PC
lcDatabase = "nombre_database"
lcUser	   = "postgres"

lcPassword = "clave_user"

*A continuaci�n construimos la cadena de conexi�n
*Ver el nombre del Driver en el administrador de conexiones ODBC
*A veces hay que probar con ANSI � UNICODE para ver que Driver funciona mejor
*El puerto es el predeterminado, pero se puede cambiar

*lcStringConn="Driver={PostgreSQL ODBC Driver(ANSI)};Port=5432;Server="+lcServer+";Database="+lcDatabase+";Uid="+lcUser+";Pwd="+lcPassWord

lcStringConn = "Driver={PostgreSQL ODBC Driver(UNICODE)};Port=5432;Server=" + lcServer + ";Database=" + lcDatabase + ";Uid=" + lcUser + ";Pwd=" + lcPassword

*Conecta
lnHandle = Sqlstringconnect(lcStringConn)

*si se conecta, operar
If lnHandle >= 0

*Select a una tabla de la bbdd
	SQLExec(lnHandle, "SELECT * FROM nombre_tabla")
	Select sqlresult
*muestra el contenido recuperado
	Browse

*cierra conexion
	SQLDisconnect(lnHandle)
Else
	= Aerror(laError)
	Messagebox("Error al conectarse" + Chr(13) + "Description:" + laError[2])
Endif

= Messagebox("Listo!")

Return
***********************
Function GeneraPlE5Compras(np1, np2, nmes, Na)
cpropiedad = "RegimenContribuyente"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("RegimenContribuyente", "")
Endif
If goApp.RegimenContribuyente = 'R' Then
	ccuo = "M-RER"
Else
	ccuo = 'M002'
Endif
Cruta = Addbs(Justpath(np1)) + np2
Select registro
If Fsize("otros") = 0
	notros = 0
Else
	notros = 1
Endif
*SELECT registro
*GO top
*WAIT WINDOW 'aca'
*WAIT WINDOW registro.fechad
*WAIT WINDOW VARTYPE(registro.fechad)
*wait WINDOW SUBSTR(registro.fechad,9,2)+'/'+SUBSTR(registro.fechad,6,2)+'/'+LEFT(registro.fechad,4)
*Trim(ccuo+Alltrim(Str(Recno()))) As esta,
cr1 = Cruta + '.txt'
Select;
	Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As Periodo, ;
	Auto As nrolote, ;
	Trim(ccuo) As esta, ;
	fech As fechae, ;
	fech As fvto, ;
	Tdoc As tipocomp, ;
	Iif(Tdoc = "10", '1683', Iif(Tdoc = '50', Left(Alltrim(Str(Val(Serie))), 3), Iif(Len(Alltrim(Serie)) <= 3, '0', '') + Serie)) As Serie, ;
	Iif(Tdoc = '50', Na, 0000) As fdua, ;
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
	Iif(Mone = 'S', 1.000, dola) As Tipocambio, ;
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
*Iif(Empty(fechad),Ctod("01/01/0001"),fechad) As fechad

**
Select lreg
*return
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	nlote = nrolote
	If nl = 0 Then
    \\<<Periodo>>|<<nrolote>>|<<esta>>|<<fechae>>|<<fvto>>|<<tipocomp>>|<<Serie>>|<<fdua>>|<<nrocomp>>|<<n1>>|<<tipodocp>>|<<nruc>>|<<Alltrim(proveedor)>>|<<Base>>|<<igv>>|<<Exon1>>|<<igvng>>|<<inafecta>>|<<igv1>>|<<Exon>>|<<isc>>|<<icbper>>|<<otros>>|<<Total>>|<<Mone>>|<<tipocambio>>|<<fechn>>|<<tipon>>|<<serien>>|<<dadu>>|<<ndocn>>|<<fechad>>|<<nrod>>|<<reten>>|<<tipobien>>|<<proy>>|<<errtc>>|<<errpro1>>|<<errpro2>>|<<errpro3>>|<<Mpago>>|<<estado>>|
	Else
     \<<Periodo>>|<<nrolote>>|<<esta>>|<<fechae>>|<<fvto>>|<<tipocomp>>|<<Serie>>|<<fdua>>|<<nrocomp>>|<<n1>>|<<tipodocp>>|<<nruc>>|<<Alltrim(proveedor)>>|<<Base>>|<<igv>>|<<Exon1>>|<<igvng>>|<<inafecta>>|<<igv1>>|<<Exon>>|<<isc>>|<<icbper>>|<<otros>>|<<Total>>|<<Mone>>|<<tipocambio>>|<<fechn>>|<<tipon>>|<<serien>>|<<dadu>>|<<ndocn>>|<<fechad>>|<<nrod>>|<<reten>>|<<tipobien>>|<<proy>>|<<errtc>>|<<errpro1>>|<<errpro2>>|<<errpro3>>|<<Mpago>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************************
Function GeneraPLE5VENTAS(np1, np2)
cpropiedad = "RegimenContribuyente"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("RegimenContribuyente", "")
Endif
If goApp.RegimenContribuyente = 'R' Then
	ccuo = "M-RER"
Else
	ccuo = 'M001'
Endif
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select;
	Cast(Alltrim(Str(Year(fech))) + Iif(Month(fech) <= 9, '0' + Alltrim(Str(Month(fech))), Alltrim(Str(Month(fech)))) + '00' As Integer) As Periodo, ;
	Auto As nrolote, ;
	Trim(ccuo + Alltrim(Str(Recno()))) As esta, ;
	fech As Fecha, ;
	fech As fvto, ;
	Tdoc As tipocomp, ;
	Iif(Len(Alltrim(Serie)) <= 3, '0' + Trim(Serie), Trim(Serie)) As Serie, ;
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
	Iif(Mone = 'S', 1.000, Iif(dola > 0, dola, fe_gene.dola)) As Tipocambio, ;
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
   \\<<Periodo>>|<<nrolote>>|<<esta>>|<<Fecha>>|<<fvto>>|<<tipocomp>>|<<Serie>>|<<nrocomp>>|<<consolidado>>|<<tipodocc>>|<<nruc>>|<<Alltrim(cliente)>>|<<exporta>>|<<Base>>|<<dsctoigv>>|<<igv>>|<<dsctoigv1>>|<<Exon>>|<<inafecta>>|<<isc>>|<<pilado>>|<<igvp>>|<<icbper>>|<<otros>>|<<Total>>|<<Mone>>|<<tipocambio>>|<<fechn>>|<<tipon>>|<<serien>>|<<ndocn>>|<<contrato>>|<<errtc>>|<<Mpago>>|<<estado>>|
	Else
    \<<Periodo>>|<<nrolote>>|<<esta>>|<<Fecha>>|<<fvto>>|<<tipocomp>>|<<Serie>>|<<nrocomp>>|<<consolidado>>|<<tipodocc>>|<<nruc>>|<<Alltrim(cliente)>>|<<exporta>>|<<Base>>|<<dsctoigv>>|<<igv>>|<<dsctoigv1>>|<<Exon>>|<<inafecta>>|<<isc>>|<<pilado>>|<<igvp>>|<<icbper>>|<<otros>>|<<Total>>|<<Mone>>|<<tipocambio>>|<<fechn>>|<<tipon>>|<<serien>>|<<ndocn>>|<<contrato>>|<<errtc>>|<<Mpago>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
***********************
Function GeneraPlE5Compras1(np1, np2, nmes, Na)
*:Global cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select;
	Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As c1, ;
	Auto As c2, ;
	Trim('M' + Alltrim(Str(Recno()))) As c3, ;
	com1_fech As c4, ;
	com1_tdoc As c5, ;
	com1_ser1 As c6, ;
	com1_ndoc As c7, ;
	com1_valo As c8, ;
	com1_otro As c9, ;
	com1_impo As c10, ;
	com1_tdoc1 As c11, ;
	com1_serie1 As c12, ;
	com1_a�o As c13, ;
	com1_ndoc1 As c14, ;
	com1_rete As c15, ;
	com1_mone As c16, ;
	com1_dola As c17, ;
	com1_pais As c18, ;
	Razo As c19, ;
	Dire As c20, ;
	nruc As c21, ;
	ndni As c22, ;
	razo1 As c23, ;
	com1_pais1 As c24, ;
	com1_vinc As c25, ;
	com1_renta As c26, ;
	com1_cost As c27, ;
	com1_rneta As c28, ;
	com1_vrenta As c29, ;
	com1_irete As c30, ;
	com1_conv As c31, ;
	com1_exon As c32, ;
	com1_trta As c33, ;
	com1_modo As c34, ;
	com1_aplica As c35, ;
	Iif(Month(com1_fech) = nmes, '1', '6') As c36;
	From lnd Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If nl = 0 Then
    \\<<c1>>|<<c2>>|<<c3>>|<<c4>>|<<c5>>|<<c6>>|<<c7>>|<<c8>>|<<c9>>|<<c10>>|<<c11>>|<<c12>>|<<c13>>|<<c14>>|<<c15>>|<<c16>>|<<c17>>|<<c18>>|<<Trim(c19)>>|<<Trim(c20)>>|<<c21>>|<<c22>>|<<Trim(c23)>>|<<c24>>|<<c25>>|<<c26>>|<<c27>>|<<c28>>|<<c29>>|<<c30>>|<<c30>>|<<c31>>|<<c32>>|<<c33>>|<<c34>>|<<c35>>|<<c36>>|

	Else
     \<<c1>>|<<c2>>|<<c3>>|<<c4>>|<<c5>>|<<c6>>|<<c7>>|<<c8>>|<<c9>>|<<c10>>|<<c11>>|<<c12>>|<<c13>>|<<c14>>|<<c15>>|<<c16>>|<<c17>>|<<c18>>|<<Trim(c19)>>|<<Trim(c20)>>|<<c21>>|<<c22>>|<<Trim(c23)>>|<<c24>>|<<c25>>|<<c26>>|<<c27>>|<<c28>>|<<c29>>|<<c30>>|<<c30>>|<<c31>>|<<c32>>|<<c33>>|<<c34>>|<<c35>>|<<c36>>|
	Endif
	nl = nl + 1
Endscan
*<<c21>>|<<c22>>|<<TRIM(c23)>>|<<c24>>|<<c25>>|<<c26>>|<<c27>>|<<c28>>|<<c29>>|<<c30>>|<<c30>>|<<c31>>|<<c32>>|<<c33>>|<<c34>>|<<c35>>|<<c36>>|
Set Textmerge To
Set Textmerge Off
Endfunc
****************************************
Function GeneraDiarioPle5(np1, np2, mes, Na)
*:Global cr1, cruta, nl
Select;
	Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As Periodo, ;
	Trim(Auto) + Alltrim(Str(Recno())) As nrolote, ;
	Alltrim(Iif(rdiario.estado = 'I', 'A', 'M') + Alltrim(Str(ldia_idld))) As esta, ;
	Left(ncta, 2) + Substr(ncta, 4, 2) + Substr(ncta, 7, 2) As ncta, ;
	' ' As Codigo1, ;
	' ' As Ccostos, ;
	'PEN' As Moneda, ;
	'6' As tipodcto, ;
	Alltrim(fe_gene.nruc) + Space(4) As nruc, ;
	'00' As Tdoc, ;
	'     ' As  Serie, ;
	Auto As Ndoc, ;
	Iif(Vartype(fech) = 'T', Ttod(fech), fech) As Fecha, ;
	Iif(Vartype(fech) = 'T', Ttod(fech), fech) As Fechavto, ;
	Iif(Vartype(fech) = 'T', Ttod(fech), fech) As fechar, ;
	Iif(Empty(Detalle), Left(nomb, 100), Left(Detalle, 100)) As Detalle, ;
	' ' As desc1, ;
	debe, ;
	haber, ;
	'' As estructura, ;
	1 As estado From rdiario Into Cursor lreg
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If nl = 0 Then
        \\<<Periodo>>|<<nrolote>>|<<esta>>|<<ncta>>|<<Codigo1>>|<<Ccostos>>|<<Moneda>>|<<tipodcto>>|<<nruc>>|<<Tdoc>>|<<Serie>>|<<Ndoc>>|<<Fecha>>|<<fechavto>>|<<fechar>>|<<detalle>>|<<desc1>>|<<debe>>|<<haber>>|<<estructura>>|<<estado>>|
	Else
         \<<Periodo>>|<<nrolote>>|<<esta>>|<<ncta>>|<<Codigo1>>|<<Ccostos>>|<<Moneda>>|<<tipodcto>>|<<nruc>>|<<Tdoc>>|<<Serie>>|<<Ndoc>>|<<Fecha>>|<<fechavto>>|<<fechar>>|<<detalle>>|<<desc1>>|<<debe>>|<<haber>>|<<estructura>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
****************************************
Function GeneraPlanCuentasPle5(np1, np2)
*:Global cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select;
	Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '01' As Integer) As Periodo, ;
	Left(ncta, 2) + Substr(ncta, 4, 2) + Substr(ncta, 7, 2) As ncta, ;
	nomb As nombrecta, ;
	'01' As tplan, ;
	'       ' As descPlan, ;
	' ' As Codigo1, ;
	' ' As desc1, ;
	1 As estado;
	From rdiario Into Cursor lreg Group By ncta
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If nl = 0 Then
          \\<<Periodo>>|<<ncta>>|<<nombrecta>>|<<tplan>>|<<descPlan>>|<<Codigo1>>|<<desc1>>|<<estado>>|
	Else
           \<<Periodo>>|<<ncta>>|<<nombrecta>>|<<tplan>>|<<descPlan>>|<<Codigo1>>|<<desc1>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
****************************************
Function GeneraMayorPle5(np1, np2, nmes, Na)
*:Global cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select;
	Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As Periodo, ;
	ldia_nume As nrolote, ;
	Trim(Iif(rld.estado = 'I', 'A', 'M') + Alltrim(Str(Recno()))) As esta, ;
	Left(ncta, 2) + Substr(ncta, 4, 2) + Substr(ncta, 7, 2) As ncta, ;
	' ' As Codigo1, ;
	' ' As Ccostos, ;
	'PEN' As Moneda, ;
	'6' As tipodcto, ;
	fe_gene.nruc As nruc, ;
	'00' As Tdoc, ;
	'      ' As Serie, ;
	ldia_nume As Ndoc, ;
	ldia_fech As Fecha, ;
	ldia_fech As Fechavto, ;
	ldia_fech As fechar, ;
	Left(nomb, 100) As Detalle, ;
	'  ' As detalle1, ;
	deudor, ;
	acreedor, ;
	'' As estructura, ;
	1 As estado;
	From rld  Where deudor > 0 Or acreedor > 0 Into Cursor lreg Order By ldia_fech
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If nl = 0 Then
          \\<<Periodo>>|<<nrolote>>|<<esta>>|<<ncta>>|<<Codigo1>>|<<Ccostos>>|<<Moneda>>|<<tipodcto>>|<<nruc>>|<<Tdoc>>|<<Serie>>|<<Ndoc>>|<<Fecha>>|<<fechavto>>|<<fechar>>|<<detalle>>|<<detalle1>>|<<deudor>>|<<acreedor>>|<<estructura>>|<<estado>>|
	Else
           \<<Periodo>>|<<nrolote>>|<<esta>>|<<ncta>>|<<Codigo1>>|<<Ccostos>>|<<Moneda>>|<<tipodcto>>|<<nruc>>|<<Tdoc>>|<<Serie>>|<<Ndoc>>|<<Fecha>>|<<fechavto>>|<<fechar>>|<<detalle>>|<<detalle1>>|<<deudor>>|<<acreedor>>|<<estructura>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
****************************************
Function GeneraLCajaEPle5(np1, np2, nmes, Na)
*:Global cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As Periodo, ;
	'M' + Alltrim(Str(Recno())) As esta, Trim(Auto) + Alltrim(Str(Recno())) As nrolote, Left(ncta, 2) + Substr(ncta, 4, 2) + Substr(ncta, 7, 2) As ncta, ' ' As Codigo1, ' ' As Ccostos, 'PEN' As Moneda, ;
	'00' As Tdoc, Iif(Empty(Auto), 'SD  ', '0' + Left(rcaja.Auto, 3)) As Serie, Iif(Empty(Auto), 'SD         ', Substr(rcaja.Auto, 4)) As Ndoc, ;
	rcaja.fech As fechar, rcaja.fech As Fechavto, rcaja.fech As Fecha, Left(Detalle, 100) As Detalle, '  ' As detalle1, ;
	Iif(debe < 0, Abs(debe), debe) As debe, Iif(haber < 0, Abs(haber), haber) As haber, ' ' As estructura, ;
	1 As estado From rcaja  Where Xtipo <> '.' Into Cursor lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Select lreg
Scan
	If nl = 0 Then
          \\<<Periodo>>|<<nrolote>>|<<esta>>|<<ncta>>|<<Codigo1>>|<<Ccostos>>|<<Moneda>>|<<Tdoc>>|<<Serie>>|<<Ndoc>>|<<Fecha>>|<<fechavto>>|<<fechar>>|<<detalle>>|<<detalle1>>|<<debe>>|<<haber>>|<<estructura>>|<<estado>>|
	Else
           \<<Periodo>>|<<nrolote>>|<<esta>>|<<ncta>>|<<Codigo1>>|<<Ccostos>>|<<Moneda>>|<<Tdoc>>|<<Serie>>|<<Ndoc>>|<<Fecha>>|<<fechavto>>|<<fechar>>|<<detalle>>|<<detalle1>>|<<debe>>|<<haber>>|<<estructura>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
****************************************
Function MuesTraTiposBienes(lista)
Dimension lista[4]
lista[0] = "1	Mercaderia,Materia Prima,Suministro,Envases y Embalajes"
lista[1] = "2	Activo Fijo"
lista[2] = "3	Otros Gastos No Considerados en 1 y 2"
lista[3] = "4	Gastos de Educaci�n,Recreaci�n, Salud, Culturales Representaci�n,Capacitaci�n,De Viaje,Mantenimiento de Vehiculo Y de Premios"
lista[4] = "5	Otros Gastos No Incluidos en el Numeral 4"
Return
Endfunc
*****************************************
Function IngresaDatosDiarioPle5(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17)
Local lC, lp
*:Global cur
cur			  = "l"
lC			  = "FunIngresaDatosLibroDiarioPLe5"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Ingresando Asientos  a Libro Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
******************
Function AnularComprasLibroDiario(np1, np2, np3)
Local lC, lp
*:Global cur
cur			 = ""
lC			 = "ProAnulaDatosLibroDiarioPLe5"
goApp.npara1 = np1
goApp.npara2 = np2
goApp.npara3 = np3
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Ingresando Asientos  a Libro Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************************
Function GeneraTxtRetenciones(np1, np2)
*:Global cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select '6' As Motivo, Left(rete_ndoc, 4) As Serie, ;
	Substr(rete_ndoc, 5) As Ndoc, rete_fech As Fecha, nruc, '6' As tipodoc, rete_impo, ;
	Razo, '01' As codret, dret_valor, tpagado, Tdoc, Iif(Len(Alltrim(Ndoc)) < 10, Left(Ndoc, 3), Left(Ndoc, 4)) As seried, ;
	Iif(Len(Alltrim(Ndoc)) < 10, Substr(Ndoc, 4), Substr(Ndoc, 5)) As ndocd, fech, dret_impo, 'PEN' As Moneda, Impo, rete_dola, dret_iddr As numerop, ;
	Impo - dret_impo As neto From lR Into Cursor lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Select lreg
Scan
	If nl = 0 Then
          \\<<Motivo>>|<<Serie>>|<<Ndoc>>|<<fech>>|<<nruc>>|<<tipodoc>>|<<Razo>>|<<codret>>|<<dret_valor>>|<<rete_impo>>|<<tpagado>>|<<Tdoc>>|<<seried>>|<<ndocd>>|<<fech>>|<<dret_impo>>|<<Moneda>>|<<Fecha>>|<<numerop>>|<<Impo>>|<<Moneda>>|<<Impo>>|<<dret_impo>>|<<fech>>|<<neto>>|<<Moneda>>|<<rete_dola>>|<<Fecha>>|
	Else
           \<<Motivo>>|<<Serie>>|<<Ndoc>>|<<fech>>|<<nruc>>|<<tipodoc>>|<<Razo>>|<<codret>>|<<dret_valor>>|<<rete_impo>>|<<tpagado>>|<<Tdoc>>|<<seried>>|<<ndocd>>|<<fech>>|<<dret_impo>>|<<Moneda>>|<<Fecha>>|<<numerop>>|<<Impo>>|<<Moneda>>|<<Impo>>|<<dret_impo>>|<<fech>>|<<neto>>|<<Moneda>>|<<rete_dola>>|<<Fecha>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*******************************************
Function MuestraTabla4(cur)
Local lC, lp
lC = "ProMuestraTabla4"
lp = ""
If EJECUTARP(lC, lp, cur) < 1 Then
	Errorbd(ERRORPROC + ' ' + ' Mostrando el Contenido de Tabla 4')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function MuestraTabla35(cur)
Local lC, lp
lC = "ProMuestraTabla35"
lp = ""
If EJECUTARP(lC, lp, cur) < 1 Then
	Errorbd(ERRORPROC + ' ' + ' Mostrando el Contenido de Tabla 35')
	Return 0
Else
	Return 1
Endif
Endfunc
***************************
Function RegistraComprasNOdomicilado(oret)
Local lC, lp
*:Global cur
cur			  = "Uy"
lC			  = "FunIngresaND"
goApp.npara1  = oret.np1
goApp.npara2  = oret.np2
goApp.npara3  = oret.np3
goApp.npara4  = oret.np4
goApp.npara5  = oret.np5
goApp.npara6  = oret.np6
goApp.npara7  = oret.np7
goApp.npara8  = oret.np8
goApp.npara9  = oret.np9
goApp.npara10 = oret.np10
goApp.npara11 = oret.np11
goApp.npara12 = oret.np12
goApp.npara13 = oret.np13
goApp.npara14 = oret.np14
goApp.npara15 = oret.np15
goApp.npara16 = oret.np16
goApp.npara17 = oret.np17
goApp.npara18 = oret.np18
goApp.npara19 = oret.np19
goApp.npara20 = oret.np20
goApp.npara21 = oret.np21
goApp.npara22 = oret.np22
goApp.npara23 = oret.np23
goApp.npara24 = oret.np24
goApp.npara25 = oret.np25
goApp.npara26 = oret.np26
goApp.npara27 = oret.np27
goApp.npara28 = oret.np28
goApp.npara29 = oret.np29
goApp.npara30 = oret.np30
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,
      ?goapp.npara26,?goapp.npara27,?goapp.npara28,?goapp.npara29,?goapp.npara30)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Ingresando Documentos a Registros de No Domicilados')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************************
Function  ActualizaComprasNOdomicilado(oret)
Local lC, lp
*:Global cur
cur			  = ""
lC			  = "ActualizaND"
goApp.npara1  = oret.np1
goApp.npara2  = oret.np2
goApp.npara3  = oret.np3
goApp.npara4  = oret.np4
goApp.npara5  = oret.np5
goApp.npara6  = oret.np6
goApp.npara7  = oret.np7
goApp.npara8  = oret.np8
goApp.npara9  = oret.np9
goApp.npara10 = oret.np10
goApp.npara11 = oret.np11
goApp.npara12 = oret.np12
goApp.npara13 = oret.np13
goApp.npara14 = oret.np14
goApp.npara15 = oret.np15
goApp.npara16 = oret.np16
goApp.npara17 = oret.np17
goApp.npara18 = oret.np18
goApp.npara19 = oret.np19
goApp.npara20 = oret.np20
goApp.npara21 = oret.np21
goApp.npara22 = oret.np22
goApp.npara23 = oret.np23
goApp.npara24 = oret.np24
goApp.npara25 = oret.np25
goApp.npara26 = oret.np26
goApp.npara27 = oret.np27
goApp.npara28 = oret.np28
goApp.npara29 = oret.np29
goApp.npara30 = oret.np30
goApp.npara31 = oret.np31
goApp.npara32 = oret.np32
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,
      ?goapp.npara26,?goapp.npara27,?goapp.npara28,?goapp.npara29,?goapp.npara30,?goapp.npara31,?goapp.npara32)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Ingresando Documentos a Registros de No Domicilados')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************************
Function GeneraPlE5IPV(np1, np2, nmes, Na)
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select;
	Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As Periodo, ;
	Nreg As nrolote, ;
	Trim('M' + Alltrim(Str(Nreg))) As esta, ;
	fe_gene.ubigeo As codest, ;
	'9' As codcatalogo, ;
	'01' As tipoexistencia, ;
	coda, ;
	'' As coda1, ;
	'' As  codexistencia, ;
	fech As fechae, ;
	Icase(Tdoc = 'II', '00', Tdoc = 'GI', '00', Tdoc = 'TT', '00', Tdoc) As tipocomp, ;
	Iif(Tdoc = '50', Substr(Serie, 2, 3), Right("0000" + Alltrim(Serie), 4)) As Serie, ;
	Iif(Tdoc = '50', Right(Ndoc, 6), Ndoc) As Ndoc, ;
	Iif(ingr > 0, Iif(Tdoc = '50', '18', Iif(Tdoc = '00', '16', '02')), Iif(Tdoc = '00', '12', '01')) As TipoOperacion, ;
	Desc As Descripcion, ;
	'NIU' As UnidadMedida, ;
	'1' As tipovaluacion, ;
	ingr, ;
	prei, ;
	impi, ;
	egre, ;
	pree, ;
	impe, ;
	stock, ;
	Iif(cost < 0, 0000000.00, cost) As costo, ;
	saldo, ;
	'1' As estado;
	From k Where Nreg > 0 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	nlote = nrolote
	If nl = 0 Then
    \\<<Periodo>>|<<nrolote>>|<<esta>>|<<codest>>|<<codcatalogo>>|<<tipoexistencia>>|<<coda>>|<<coda1>>|<<codexistencia>>|<<fechae>>|<<tipocomp>>|<<Serie>>|<<Ndoc>>|<<TipoOperacion>>|<<Descripcion>>|<<UnidadMedida>>|<<tipovaluacion>>|<<ingr>>|<<prei>>|<<impi>>|<<egre>>|<<pree>>|<<impe>>|<<stock>>|<<costo>>|<<saldo>>|<<estado>>|
	Else
     \<<Periodo>>|<<nrolote>>|<<esta>>|<<codest>>|<<codcatalogo>>|<<tipoexistencia>>|<<coda>>|<<coda1>>|<<codexistencia>>|<<fechae>>|<<tipocomp>>|<<Serie>>|<<Ndoc>>|<<TipoOperacion>>|<<Descripcion>>|<<UnidadMedida>>|<<tipovaluacion>>|<<ingr>>|<<prei>>|<<impi>>|<<egre>>|<<pree>>|<<impe>>|<<stock>>|<<costo>>|<<saldo>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
***************************************
Procedure EnviarSunat(pk, crptahash, cTdoc)
Local ArchivoRespuestaSunat As "MSXML2.DOMDocument.6.0"
Local loXMLResp As "MSXML2.DOMDocument.6.0"
Local oShell As "Shell.Application"
Local oXMLBody As 'MSXML2.DOMDocument.6.0'
Local oXMLHttp As "MSXML2.XMLHTTP.6.0"
Local lsURL, ls_base64, ls_contentFile, ls_envioXML, ls_fileName, ls_pwd_sol, ls_ruc_emisor, ls_user
*:Global CMensajeMensaje, CMensajedetalle, CmensajeError, TxtB64, cDirDesti, carchivozip, cfilecdr
*:Global cfilerpta, cnombre, cpropiedad, crespuesta, npos, oArchi, ps_fileZip, rptaSunat
Declare Integer CryptBinaryToString In Crypt32;
	String @pbBinary, Long cbBinary, Long dwFlags, ;
	String @pszString, Long @pcchString

Declare Integer CryptStringToBinary In Crypt32;
	String @pszString, Long cchString, Long dwFlags, ;
	String @pbBinary, Long @pcbBinary, ;
	Long pdwSkip, Long pdwFlags

#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056
Set Library To Locfile("vfpcompression.fll")
ZipfileQuick(goApp.cArchivo)
zipclose()
cpropiedad = "ose"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("ose", "")
Endif

cpropiedad = "Grabarxmlbd"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("Grabarxmlbd", "")
Endif
If !Empty(goApp.ose) Then
	Do Case
	Case goApp.ose = "nubefact"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://demo-ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'moddatos'
			ls_user		  = ls_ruc_emisor + 'MODDATOS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
	Case goApp.ose = "efact"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://ose-gw1.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'iGje3Ei9GN'
			ls_user		  = ls_ruc_emisor
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
	Case goApp.ose = "bizlinks"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://osetesting.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'TESTBIZLINKS'
			ls_user		  = Alltrim(fe_gene.nruc) + 'BIZLINKS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
	Case goApp.ose = "conastec"
		Do Case
		Case goApp.tipoh = 'B'
			lsURL		  = "https://test.conose.pe:443/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'moddatos'
			ls_user		  = ls_ruc_emisor + 'MODDATOS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://prod.conose.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
	Endcase
Else
	Do Case
	Case goApp.tipoh == 'B'
		lsURL		  = "https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService"
		ls_ruc_emisor = fe_gene.nruc
		ls_pwd_sol	  = 'moddatos'
		ls_user		  = ls_ruc_emisor + 'MODDATOS'
	Case goApp.tipoh == 'H'
		lsURL		  = "https://www.sunat.gob.pe/ol-ti-itcpgem-sqa/billService"
		ls_ruc_emisor = fe_gene.nruc
		ls_pwd_sol	  = Alltrim(fe_gene.gene_csol)
		ls_user		  = ls_ruc_emisor + Alltrim(fe_gene.Gene_usol)
	Case goApp.tipoh = 'P'
		If !Pemstatus(goApp, 'urlsunat', 5) Then
			AddProperty(goApp, 'urlsunat', "https://e-factura.sunat.gob.pe/ol-ti-itcpfegem/billService")
		Else
			goApp.urlsunat =  "https://e-factura.sunat.gob.pe/ol-ti-itcpfegem/billService"
		Endif
		lsURL		  =  Alltrim(goApp.urlsunat)
		ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
		ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
		ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
	Otherwise
		lsURL		  = "https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService"
		ls_ruc_emisor = Iif(Type("oempresa") = "U", fe_gene.nruc, Oempresa.nruc)
		ls_pwd_sol	  = Iif(Type("oempresa") = "U", Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
		ls_user		  = ls_ruc_emisor + Iif(Type("oempresa") = "U", Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
	Endcase
Endif
npos		   = At('.', goApp.cArchivo)
carchivozip	   = Substr(goApp.cArchivo, 1, npos - 1)
ps_fileZip	   = carchivozip + '.zip'
ls_fileName	   = Justfname(ps_fileZip)
ls_contentFile = Filetostr(ps_fileZip)
crespuesta	   = ls_fileName
ls_base64	   = Strconv(ls_contentFile, 13) && Encoding base 64
Do Case
Case  goApp.ose = 'conastec'
	Text To ls_envioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe">
	<soapenv:Header>
	<wsse:Security   xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
	<wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
	<wsse:Username><<ls_user>></wsse:Username>
	<wsse:Password><<ls_pwd_sol>></wsse:Password>
	</wsse:UsernameToken>
	</wsse:Security>
	</soapenv:Header>
	<soapenv:Body>
	<ser:sendBill>
	<!--Optional:-->
	<fileName><<ls_fileName>></fileName>
	<!--Optional:-->
	<contentFile><<ls_base64>></contentFile>
	</ser:sendBill>
	</soapenv:Body>
	</soapenv:Envelope>
	Endtext
Case  goApp.ose = 'bizlinks'
	Text To ls_envioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
		<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
		<SOAP-ENV:Header xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
		<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" soap:mustUnderstand="1">
		<wsse:UsernameToken wsu:Id="UsernameToken-c175cdb9-9a32-4291-b8c7-85dff8107561">
		<wsse:Username><<ls_user>></wsse:Username>
		<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText"><<ls_pwd_sol>></wsse:Password>
		</wsse:UsernameToken>
		</wsse:Security>
		</SOAP-ENV:Header>
		<soap:Body>
		<ns2:sendBill xmlns:ns2="http://service.sunat.gob.pe">
		<fileName><<ls_fileName>></fileName>
		<contentFile><<ls_base64>></contentFile>
		</ns2:sendBill>
		</soap:Body>
		</soap:Envelope>
	Endtext


Case goApp.ose = "efact"
	Text To ls_envioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
     <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe" xmlns:wsse="http://docs.oasisopen.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
	   <soapenv:Header>
	   <wsse:Security soapenv:mustUnderstand="0" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
	      <wsse:UsernameToken>
	        <wsse:Username><<ls_user>></wsse:Username>
	         <wsse:Password><<ls_pwd_sol>></wsse:Password>
	      </wsse:UsernameToken>
	   </wsse:Security>
	   </soapenv:Header>
	   <soapenv:Body>
	      <ser:sendBill>
	        	<fileName><<ls_fileName>></fileName>
		        <contentFile><<ls_base64>></contentFile>
	      </ser:sendBill>
	   </soapenv:Body>
	</soapenv:Envelope>
	Endtext
Otherwise
	Text To ls_envioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
			<soapenv:Envelope xmlns:ser="http://service.sunat.gob.pe" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
					xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
				<soapenv:Header>
					<wsse:Security>
						<wsse:UsernameToken>
							<wsse:Username><<ls_user>></wsse:Username>
							<wsse:Password><<ls_pwd_sol>></wsse:Password>
						</wsse:UsernameToken>
					</wsse:Security>
				</soapenv:Header>
				<soapenv:Body>
					<ser:sendBill>
						<fileName><<ls_fileName>></fileName>
						<contentFile><<ls_base64>></contentFile>
					</ser:sendBill>
				</soapenv:Body>
			</soapenv:Envelope>
	Endtext
Endcase
If goApp.ose = 'bizlinks' Then
	oXMLHttp = Createobject("MSXML2.XMLHTTP.6.0")
Else
	oXMLHttp = Createobject("MSXML2.ServerXMLHTTP.6.0")
Endif
oXMLBody = Createobject('MSXML2.DOMDocument.6.0')
If !(oXMLBody.LoadXML(ls_envioXML)) Then
	oResp.Mensaje = "No se cargo XML: " + oXMLBody.parseError.reason
	Return 0
Endif
oXMLHttp.Open('POST', lsURL, .F.)
oXMLHttp.setRequestHeader( "Content-Type", "text/xml" )
If goApp.ose = 'conastec' Or goApp.ose = 'efact' Or goApp.ose = 'bizlinks' Then
	oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8" )
Else
	oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" )
Endif
oXMLHttp.setRequestHeader( "Content-Length", Len(ls_envioXML))
If goApp.ose = 'bizlinks' Or  goApp.ose = 'conastec' Or goApp.ose = 'efact' Then
	oXMLHttp.setRequestHeader( "SOAPAction", "urn:sendBill" )
Else
	oXMLHttp.setRequestHeader( "SOAPAction", "sendBill" )
Endif
If goApp.ose <> 'bizlinks' Then
	oXMLHttp.setOption(2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS)
Endif
oXMLHttp.Send(oXMLBody.documentElement.XML)
If (oXMLHttp.Status <> 200) Then
	CmensajeError	= leerXMl(Alltrim(oXMLHttp.responseText), "<faultcode>", "</faultcode>")
	CMensajeMensaje	= leerXMl(Alltrim(oXMLHttp.responseText), "<faultstring>", "</faultstring>")
	CMensajeMensaje	= leerXMl(Alltrim(oXMLHttp.responseText), "<faultstring>", "</faultstring>")
	CMensajedetalle	= leerXMl(Alltrim(oXMLHttp.responseText), "<detail>", "</detail>")
	CMensajeM	= leerXMl(Alltrim(oXMLHttp.responseText), "<message>", "</message>")
	If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Or !Empty(CMensajeM) Then
		Messagebox(('Estado ' + Alltrim(Str(oXMLHttp.Status)) + '-' + Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle) + ' ' + Alltrim(CMensajeM)), 16, MSGTITULO)
	Else
		Messagebox('Estado ' + Alltrim(Str(oXMLHttp.Status)) + '-' + Nvl(oXMLHttp.responseText, ''), 16, MSGTITULO)
	Endif
	Return 0
Endif
loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
loXMLResp.LoadXML(oXMLHttp.responseText)
CmensajeError	= leerXMl(Alltrim(oXMLHttp.responseText), "<faultcode>", "</faultcode>")
CMensajeMensaje	= leerXMl(Alltrim(oXMLHttp.responseText), "<faultstring>", "</faultstring>")
CMensajeMensaje	= leerXMl(Alltrim(oXMLHttp.responseText), "<faultstring>", "</faultstring>")
CMensajedetalle	= leerXMl(Alltrim(oXMLHttp.responseText), "<detail>", "</detail>")
If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Then
	Messagebox((Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle)), 16, 'Sisven')
	Return 0
Endif
*Messagebox(oXMLHttp.responseText,16,'Sisven')
ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
ArchivoRespuestaSunat.LoadXML(oXMLHttp.responseText)			&&Llenamos el archivo de respuesta
TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//applicationResponse")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
If Vartype(TxtB64) <> 'O' Then
	Aviso(' No se Puede Obtener La Respuesta desde SUNAT ')
	Return 0
Endif
If Type('oempresa') = 'U' Then
	cnombre	  = Addbs(Sys(5) + Sys(2003) + '\SunatXml') + crespuesta
	cDirDesti = Addbs( Sys(5) + Sys(2003) + '\SunatXML')
	cfilerpta = Addbs( Sys(5) + Sys(2003) + '\SunatXML') + 'R-' + carchivozip + '.XML'
Else
	cnombre	  = Addbs(Sys(5) + Sys(2003) + '\SunatXml\' + Alltrim(Oempresa.nruc)) + crespuesta
	cDirDesti = Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc))
	cfilerpta = Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc)) + 'R-' + carchivozip + '.XML'
Endif
If !Directory(cDirDesti) Then
	Md (cDirDesti)
Endif
If File(cfilerpta) Then
	Delete File cfilerpta
Endif
decodefile(TxtB64.Text, cnombre)
oShell	  = Createobject("Shell.Application")
cfilerpta = "R"
For Each oArchi In oShell.NameSpace(cnombre).Items
	If Left(oArchi.Name, 1) = 'R' Then
		oShell.NameSpace(cDirDesti).CopyHere(oArchi)
		cfilerpta = Juststem(oArchi.Name) + '.XML'
	Endif
Endfor
If Type('oempresa') = 'U' Then
	If !Directory(Sys(5) + Sys(2003) + "\sunatxml") Then
		ccarpeta = Sys(5) + Sys(2003) + "\sunatxml"
		Mkdir (ccarpeta)
	Endif
	cfilecdr  = Sys(5) + Sys(2003) + '\SunatXML\' + cfilerpta
	rptaSunat = LeerRespuestaSunat(Sys(5) + Sys(2003) + '\SunatXML\' + cfilerpta)
Else
	If !Directory(Sys(5) + Sys(2003) + "\sunatxml\" + Alltrim(Oempresa.nruc)) Then
		ccarpeta = Sys(5) + Sys(2003) + "\sunatxml\" + Alltrim(Oempresa.nruc)
		Mkdir (ccarpeta)
	Endif
	cfilecdr  = Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\" + cfilerpta
	rptaSunat = LeerRespuestaSunat(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\" + cfilerpta)
Endif
If Len(Alltrim(rptaSunat)) <= 100 Then
	GuardaPk(pk, crptahash, cfilecdr, cTdoc)
Else
	Messagebox(rptaSunat, 64, MSGTITULO)
	Return 0
Endif
Do Case
Case Left(rptaSunat, 1) = '0'
	Mensaje(rptaSunat)
	Return 1
Case Empty(rptaSunat)
	Messagebox(rptaSunat, 64, 'Sisven')
	Return 5000
Otherwise
	Messagebox(rptaSunat, 64, 'Sisven')
	Return 0
Endcase
Endproc
&&Rutina para decodificar el base64 a zip este codigo lo obtuve de la pagina de Victor Espina el link directo esta aca(http://victorespina.com.ve/wiki/index.php?title=Parser_Base64_para_VFP_usando_CryptoAPI)
******************************
Function decodeString(pcB64)
Local nFlags, nBufsize, cDst
nFlags	 = 1  && base64
nBufsize = 0
pcB64	 = Strt(Strt(Strt(pcB64, "\/", "/"), "\u000d", Chr(13)), "\u000a", Chr(10))
CryptStringToBinary(@pcB64, Len(m.pcB64), nFlags, Null, @nBufsize, 0, 0)
cDst = Replicate(Chr(0), m.nBufsize)
If CryptStringToBinary(@pcB64, Len(m.pcB64), nFlags, @cDst, @nBufsize, 0, 0) = 0
	Return ""
Endif
Return m.cDst
Endproc
*****************************
Procedure decodefile(pcB64, pcFile)
Local cBuff
cBuff = decodeString(pcB64)
Strtofile(cBuff, pcFile)
Endproc
**************************
Function LeerCodigoHash(lCfileName)
Local lnCount As Integer, ;
	lcXML As String, ;
	lcString As String
Local lnI
*:Global chash

If Not File(lCfileName)
	Return []
Endif
lcXML = Filetostr(lCfileName)
If "<DigestValue>" $ lcXML
	lnCount = 1
Else
	lnCount = 2
Endif
chash = ""
For lnI = 1 To Occurs('<DigestValue>', lcXML)
	chash = Strextract(lcXML, '<DigestValue>', '</DigestValue>', lnI)
Next lnI
Return chash
Endfunc
************************************
Function LeerRespuestaSunat(cfilerpta)
Local lnCount As Integer, ;
	lcXML As String, ;
	lcString As String
Local lnI
*:Global cresp, resp1
*wait WINDOW 'aca'+cfilerpta
If Not File(cfilerpta) Then
	Return []
Endif

lcXML = Filetostr(cfilerpta)
If "<cbc:Description>" $ lcXML
	lnCount = 1
Else
	lnCount = 2
Endif
cresp = ""
If goApp.ose = 'efact' Then
	For lnI = 1 To Occurs('<Description>', lcXML)
		cresp = Strextract(lcXML, '<Description>', '</Description>', lnI)
	Next lnI
Else
	For lnI = 1 To Occurs('<cbc:Description>', lcXML)
		cresp = Strextract(lcXML, '<cbc:Description>', '</cbc:Description>', lnI)
	Next lnI
Endif
*Leer Codigo de Respuesta*
If "<cbc:ResponseCode>" $ lcXML
	lnCount = 1
Else
	lnCount = 2
Endif
resp1 = ""
If !Empty(goApp.ose) Then
	If goApp.ose = 'efact' Then
		For lnI = 1 To Occurs('<ResponseCode listAgencyName="PE:SUNAT">', lcXML)
			resp1 = Strextract(lcXML, '<ResponseCode listAgencyName="PE:SUNAT">', '</ResponseCode>', lnI)
		Next lnI
	Else
		For lnI = 1 To Occurs('<cbc:ResponseCode listAgencyName="PE:SUNAT">', lcXML)
			resp1 = Strextract(lcXML, '<cbc:ResponseCode listAgencyName="PE:SUNAT">', '</cbc:ResponseCode>', lnI)
		Next lnI
	Endif
Else
	For lnI = 1 To Occurs('<cbc:ResponseCode>', lcXML)
		resp1 = Strextract(lcXML, '<cbc:ResponseCode>', '</cbc:ResponseCode>', lnI)
	Next lnI
Endif
Return resp1 + ' ' + cresp
Endfunc
******************************
Procedure EnviarSunat1(pk, crhash, EstadoBoleta)
#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056
Local loXMLResp As "MSXML2.DOMDocument.6.0"
Local oXMLBody As 'MSXML2.DOMDocument.6.0'
Local oXMLHttp As "MSXML2.XMLHTTP.6.0"
Local lcXML, lnCount, lnI, lsURL, ls_base64, ls_contentFile, ls_envioXML, ls_fileName, ls_pwd_sol
Local ls_ruc_emisor, ls_user
*:Global carchivozip, carxml, cpropiedad, cresp, crespuesta, ctipoarchivo, npos, ps_fileZip
Set Library To Locfile("vfpcompression.fll")
ZipfileQuick(goApp.cArchivo)
zipclose()


cpropiedad = "ose"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("ose", "")
Endif

cpropiedad = "urlsunat"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("urlsunat", "")
Endif


cpropiedad = "Grabarxmlbd"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("Grabarxmlbd", "")
Endif



If !Empty(goApp.ose) Then
	Do Case
	Case goApp.ose = "nubefact"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://demo-ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'moddatos'
			ls_user		  = ls_ruc_emisor + 'MODDATOS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
	Case goApp.ose = "efact"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://ose-gw1.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'iGje3Ei9GN'
			ls_user		  = ls_ruc_emisor
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
	Case goApp.ose = "bizlinks"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://osetesting.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'TESTBIZLINKS'
			ls_user		  = Alltrim(fe_gene.nruc) + 'BIZLINKS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
	Case goApp.ose = "conastec"
		Do Case
		Case goApp.tipoh = 'B'
			lsURL		  = "https://test.conose.pe:443/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'moddatos'
			ls_user		  = ls_ruc_emisor + 'MODDATOS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://prod.conose.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
	Endcase
Else
	Do Case
	Case goApp.tipoh == 'B'
		lsURL		  = "https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService"
		ls_ruc_emisor = fe_gene.nruc
		ls_pwd_sol	  = 'moddatos'
		ls_user		  = ls_ruc_emisor + 'MODDATOS'
	Case goApp.tipoh == 'H'
		lsURL		  = "https://www.sunat.gob.pe/ol-ti-itcpgem-sqa/billService"
		ls_ruc_emisor = fe_gene.nruc
		ls_pwd_sol	  = Alltrim(fe_gene.gene_csol)
		ls_user		  = ls_ruc_emisor + Alltrim(fe_gene.Gene_usol)
	Case goApp.tipoh == 'P'
		If Empty(goApp.urlsunat) Then
			lsURL   = "https://e-factura.sunat.gob.pe/ol-ti-itcpfegem/billService"
		Else
			lsURL = Alltrim(goApp.urlsunat)
		Endif
		ls_ruc_emisor = Iif(Type("oempresa") = "U", fe_gene.nruc, Oempresa.nruc)
		ls_pwd_sol	  = Iif(Type("oempresa") = "U", Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
		ls_user		  = ls_ruc_emisor + Iif(Type("oempresa") = "U", Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
	Otherwise
		lsURL		  = "https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService"
		ls_ruc_emisor = fe_gene.nruc
		ls_pwd_sol	  = Alltrim(fe_gene.gene_csol)
		ls_user		  = ls_ruc_emisor + Alltrim(fe_gene.Gene_usol)
	Endcase
Endif
npos		   = At('.', goApp.cArchivo)
ctipoarchivo   = Justfname(goApp.cArchivo)
carchivozip	   = Substr(goApp.cArchivo, 1, npos - 1)
ps_fileZip	   = carchivozip + '.zip'
ls_fileName	   = Justfname(ps_fileZip)
ls_contentFile = Filetostr(ps_fileZip)
crespuesta	   = ls_fileName
ls_base64	   = Strconv(ls_contentFile, 13) && Encoding base 64
Do Case
Case  goApp.ose = 'conastec'
	Text To ls_envioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe">
	<soapenv:Header>
	<wsse:Security   xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
	<wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
	<wsse:Username><<ls_user>></wsse:Username>
	<wsse:Password><<ls_pwd_sol>></wsse:Password>
	</wsse:UsernameToken>
	</wsse:Security>
	</soapenv:Header>
	<soapenv:Body>
    <ser:sendSummary>
	<!--Optional:-->
	<fileName><<ls_fileName>></fileName>
	<!--Optional:-->
	<contentFile><<ls_base64>></contentFile>
	</ser:sendSummary>
	</soapenv:Body>
	</soapenv:Envelope>
	Endtext
Case goApp.ose = "efact"
	Text To ls_envioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
     <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe" xmlns:wsse="http://docs.oasisopen.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
	   <soapenv:Header>
	   <wsse:Security soapenv:mustUnderstand="0" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
	      <wsse:UsernameToken>
	        <wsse:Username><<ls_user>></wsse:Username>
	         <wsse:Password><<ls_pwd_sol>></wsse:Password>
	      </wsse:UsernameToken>
	   </wsse:Security>
	   </soapenv:Header>
	   <soapenv:Body>
	      <ser:sendSummary>
	        	<fileName><<ls_fileName>></fileName>
		        <contentFile><<ls_base64>></contentFile>
	    </ser:sendSummary>
	   </soapenv:Body>
	</soapenv:Envelope>
	Endtext
Case goApp.ose = 'bizlinks'
	Text To ls_envioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe">
	<soapenv:Header xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
	<wsse:Security soap:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" xmlns:soap="soap">
	<wsse:UsernameToken>
	<wsse:Username><<ls_user>></wsse:Username>
	<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText"><<ls_pwd_sol>></wsse:Password></wsse:UsernameToken>
	</wsse:Security></soapenv:Header>
	   <soapenv:Body>
	      <ser:sendSummary>
	         <!--Optional:-->
	         <fileName><<ls_fileName>></fileName>
	         <!--Optional:-->
	      	 <contentFile><<ls_base64>></contentFile>
	      </ser:sendSummary>
	   </soapenv:Body>
	</soapenv:Envelope>
	Endtext
Otherwise
	Text To ls_envioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
				<soapenv:Envelope xmlns:ser="http://service.sunat.gob.pe" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
					xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
					<soapenv:Header>
						<wsse:Security>
							<wsse:UsernameToken>
								<wsse:Username><<ls_user>></wsse:Username>
								<wsse:Password><<ls_pwd_sol>></wsse:Password>
							</wsse:UsernameToken>
						</wsse:Security>
					</soapenv:Header>
					<soapenv:Body>
						<ser:sendSummary>
							<fileName><<ls_fileName>></fileName>
							<contentFile><<ls_base64>></contentFile>
						</ser:sendSummary>
					</soapenv:Body>
				</soapenv:Envelope>
	Endtext
Endcase
******************
If goApp.ose = 'bizlinks' Then
	oXMLHttp = Createobject("MSXML2.XMLHTTP.6.0")
Else
	oXMLHttp = Createobject("MSXML2.ServerXMLHTTP.6.0")
Endif
*oXMLHttp=Createobject("MSXML2.ServerXMLHTTP.6.0")
oXMLBody = Createobject('MSXML2.DOMDocument.6.0')
If !(oXMLBody.LoadXML(ls_envioXML)) Then
	oResp.Mensaje = "No se cargo XML: " + oXMLBody.parseError.reason
	Return 0
Endif
oXMLHttp.Open('POST', lsURL, .F.)

If goApp.ose = 'conastec' Or goApp.ose = 'efact' Or goApp.ose = 'bizlinks'  Then
	oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8" )
Else
	oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" )
Endif


*oXMLHttp.setRequestHeader( "Content-Type", "text/xml" )
*oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" )
oXMLHttp.setRequestHeader( "Content-Length", Len(ls_envioXML) )
If goApp.ose = 'bizlinks'  Or goApp.ose = 'conastec' Or goApp.ose = 'efact'  Then
	oXMLHttp.setRequestHeader( "SOAPAction", "urn:sendSummary" )
Else
	oXMLHttp.setRequestHeader( "SOAPAction", "sendSummary" )
Endif
If goApp.ose <> 'bizlinks'  Then
	oXMLHttp.setOption(2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS)
Endif
oXMLHttp.Send(oXMLBody.documentElement.XML)
If (oXMLHttp.Status <> 200) Then
	CmensajeError	= leerXMl(Alltrim(oXMLHttp.responseText), "<faultcode>", "</faultcode>")
	CMensajeMensaje	= leerXMl(Alltrim(oXMLHttp.responseText), "<faultstring>", "</faultstring>")
	CMensajeMensaje	= leerXMl(Alltrim(oXMLHttp.responseText), "<faultstring>", "</faultstring>")
	CMensajedetalle	= leerXMl(Alltrim(oXMLHttp.responseText), "<detail>", "</detail>")
	CMensajeM	= leerXMl(Alltrim(oXMLHttp.responseText), "<message>", "</message>")
	If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Or !Empty(CMensajeM) Then
		Messagebox(('Estado ' + Alltrim(Str(oXMLHttp.Status)) + '-' + Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle) + ' ' + Alltrim(CMensajeM)), 16, 'Sisven')
	Else
		Messagebox('Estado ' + Alltrim(Str(oXMLHttp.Status)) + '-' + Nvl(oXMLHttp.responseText, ''), 16, MSGTITULO)
	Endif
*!*		Return 0
*!*		Messagebox('ESTADO: ' + Alltrim(Str(oXMLHttp.Status)) + '-' + Nvl(oXMLHttp.responseText, ''), 16, MSGTITULO)
	Return 0
Endif
loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
loXMLResp.LoadXML(oXMLHttp.responseText)
lcXML = oXMLHttp.responseText
If  goApp.ose = 'conastec' Then
	If '<ticket xmlns="">' $ lcXML
		lnCount = 1
	Else
		lnCount = 2
	Endif
	cresp = ""
	For lnI = 1 To Occurs('<ticket xmlns="">', lcXML)
		cresp = Strextract(lcXML, '<ticket xmlns="">', '</ticket>', lnI)
	Next lnI
Else
	If "<ticket>" $ lcXML
		lnCount = 1
	Else
		lnCount = 2
	Endif
	cresp = ""
	For lnI = 1 To Occurs('<ticket>', lcXML)
		cresp = Strextract(lcXML, '<ticket>', '</ticket>', lnI)
	Next lnI
Endif
Mensaje(cresp)
goApp.ticket = Alltrim(cresp)
Select curb
Scan All
	If Substr(ctipoarchivo, 13, 2) = 'RA' Then
		If goApp.Grabarxmlbd = 'S' Then
			carxml = Filetostr(goApp.cArchivo)
		Else
			carxml = ""
		Endif
		If RegistraResumenBajas(curb.fech, curb.Tdoc, curb.Serie, curb.numero, curb.Motivo, carxml, cresp, goApp.cArchivo, crhash, curb.Idauto) = 0 Then
			Messagebox("NO se Registro EL Informe de BAJA en Base de Datos", 16, MSGTITULO)
			Exit
		Endif
	Else
		If goApp.Grabarxmlbd = 'S' Then
			carxml = Filetostr(goApp.cArchivo)
		Else
			carxml = ""
		Endif
		If EstadoBoleta = '3' Then
			If _Screen.orboletas.RegistraResumenBoletasConbaja(curb.fech, curb.Tdoc, curb.Serie, curb.desde, curb.hasta, curb.Impo, curb.valor, curb.Exon, curb.inafectas, curb.igv, curb.gratificaciones,   carxml, crhash, goApp.cArchivo, cresp) < 1 Then
				Aviso(_Screen.orboletas.Cmensaje)
				Exit
			Endif
		Else
			If RegistraResumenBoletas(curb.fech, curb.Tdoc, curb.Serie, curb.desde, curb.hasta, curb.Impo, curb.valor, curb.Exon, curb.inafectas, curb.igv, curb.gratificaciones,  carxml, crhash, goApp.cArchivo, cresp) = 0 Then
				Messagebox("NO se Registro el Informe de Env�o de Boletas en Base de Datos", 16, MSGTITULO)
				Exit
			Endif
		Endif
	Endif
Endscan
Return 1
Endproc
************************************
Procedure ConsultaTicket(cticket, cArchivo)
Local ArchivoRespuestaSunat As "MSXML2.DOMDocument.6.0"
Local loXMLResp As "MSXML2.DOMDocument.6.0"
Local oShell As "Shell.Application"
Local oXMLBody As 'MSXML2.DOMDocument.6.0'
Local oXMLHttp As "MSXML2.XMLHTTP.6.0"
Local lcXML, lnCount, lnI, lsURL, ls_envioXML, ls_fileName, ls_pwd_sol, ls_ruc_emisor, ls_user
*:Global CMensajeMensaje, CmensajeError, TxtB64, cDirDesti, carchivozip, cfilecdr, cfilerpta
*:Global cnombre, cpropiedad, cresp, crespuesta, ctipoarchivo, npos, oArchi, ps_fileZip, rptaSunat
Declare Integer CryptBinaryToString In Crypt32;
	String @pbBinary, Long cbBinary, Long dwFlags, ;
	String @pszString, Long @pcchString

Declare Integer CryptStringToBinary In Crypt32;
	String @pszString, Long cchString, Long dwFlags, ;
	String @pbBinary, Long @pcbBinary, ;
	Long pdwSkip, Long pdwFlags

#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056

cpropiedad = "ose"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("ose", "")
Endif
cpropiedad = "urlsunat"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("urlsunat", "")
Endif

cpropiedad = "Grabarxmlbd"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("Grabarxmlbd", "")
Endif
If !Empty(goApp.ose) Then
	Do Case
	Case goApp.ose = "nubefact"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://demo-ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'moddatos'
			ls_user		  = ls_ruc_emisor + 'MODDATOS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
	Case goApp.ose = "efact"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://ose-gw1.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'iGje3Ei9GN'
			ls_user		  = ls_ruc_emisor
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
	Case goApp.ose = "bizlinks"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://osetesting.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'TESTBIZLINKS'
			ls_user		  = Alltrim(fe_gene.nruc) + 'BIZLINKS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
	Case goApp.ose = "conastec"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://test.conose.pe:443/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'moddatos'
			ls_user		  = ls_ruc_emisor + 'MODDATOS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://prod.conose.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase

	Endcase
Else
	Do Case
	Case goApp.tipoh == 'B'
		lsURL		  = "https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService"
		ls_ruc_emisor = fe_gene.nruc
		ls_pwd_sol	  = 'moddatos'
		ls_user		  = ls_ruc_emisor + 'MODDATOS'
	Case goApp.tipoh == 'H'
		lsURL		  = "https://www.sunat.gob.pe/ol-ti-itcpgem-sqa/billService"
		ls_ruc_emisor = fe_gene.nruc
		ls_pwd_sol	  = Alltrim(fe_gene.gene_csol)
		ls_user		  = ls_ruc_emisor + Alltrim(fe_gene.Gene_usol)
	Case goApp.tipoh = 'P'
		If Empty(goApp.urlsunat) Then
			lsURL   = "https://e-factura.sunat.gob.pe/ol-ti-itcpfegem/billService"
		Else
			lsURL = Alltrim(goApp.urlsunat)
		Endif
		ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
		ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
		ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
	Otherwise
		lsURL		  = "https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService"
		ls_ruc_emisor = fe_gene.nruc
		ls_pwd_sol	  = Alltrim(fe_gene.gene_csol)
		ls_user		  = ls_ruc_emisor + Alltrim(fe_gene.Gene_usol)
	Endcase
Endif
npos		 = At('.', cArchivo)
carchivozip	 = Substr(cArchivo, 1, npos - 1)
ps_fileZip	 = carchivozip + '.zip'
ls_fileName	 = Justfname(ps_fileZip)
ctipoarchivo = Justfname(cArchivo)
crespuesta	 = ls_fileName
Do Case
Case  goApp.ose = 'conastec'
	Text To ls_envioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe">
		<soapenv:Header>
		<wsse:Security   xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
		<wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
		<wsse:Username><<ls_user>></wsse:Username>
		<wsse:Password><<ls_pwd_sol>></wsse:Password>
		</wsse:UsernameToken>
		</wsse:Security>
		</soapenv:Header>
		<soapenv:Body>
	     <ser:getStatus>
		<!--Optional:-->
		   <ticket><<cticket>></ticket>
		</ser:getStatus>
		</soapenv:Body>
		</soapenv:Envelope>
	Endtext
Case goApp.ose = "efact"
	Text To ls_envioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
     <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe" xmlns:wsse="http://docs.oasisopen.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
	   <soapenv:Header>
	   <wsse:Security soapenv:mustUnderstand="0" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
	      <wsse:UsernameToken>
	        <wsse:Username><<ls_user>></wsse:Username>
	         <wsse:Password><<ls_pwd_sol>></wsse:Password>
	      </wsse:UsernameToken>
	   </wsse:Security>
	   </soapenv:Header>
	   <soapenv:Body>
	        <ser:getStatus>
	          <ticket><<cticket>></ticket>
	     </ser:getStatus>
	   </soapenv:Body>
	</soapenv:Envelope>
	Endtext
Case  goApp.ose = 'bizlinks'
	Text To ls_envioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
			<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe">
			<soapenv:Header xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
			<wsse:Security soap:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" xmlns:soap="soap">
			<wsse:UsernameToken>
			<wsse:Username><<ls_user>></wsse:Username>
			<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText"><<ls_pwd_sol>></wsse:Password></wsse:UsernameToken>
			</wsse:Security>
			</soapenv:Header>
			   <soapenv:Body>
			      <ser:getStatus>
			         <!--Optional:-->
			        <ticket><<cticket>></ticket>
			      </ser:getStatus>
			   </soapenv:Body>
			</soapenv:Envelope>
	Endtext
Otherwise
	Text To ls_envioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
			<soapenv:Envelope xmlns:ser="http://service.sunat.gob.pe" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
					xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
				<soapenv:Header>
					<wsse:Security>
						<wsse:UsernameToken>
							<wsse:Username><<ls_user>></wsse:Username>
							<wsse:Password><<ls_pwd_sol>></wsse:Password>
						</wsse:UsernameToken>
					</wsse:Security>
				</soapenv:Header>
				<soapenv:Body>
					<ser:getStatus>
						<ticket><<cticket>></ticket>
					</ser:getStatus>
				</soapenv:Body>
			</soapenv:Envelope>
	Endtext
Endcase
If goApp.ose = 'bizlinks' Then
	oXMLHttp = Createobject("MSXML2.XMLHTTP.6.0")
Else
	oXMLHttp = Createobject("MSXML2.ServerXMLHTTP.6.0")
Endif

*oXMLHttp=Createobject("MSXML2.ServerXMLHTTP.6.0")
oXMLBody = Createobject('MSXML2.DOMDocument.6.0')
If !(oXMLBody.LoadXML(ls_envioXML)) Then
	oResp.Mensaje = "No se cargo XML: " + oXMLBody.parseError.reason
	Return - 1
Endif
oXMLHttp.Open('POST', lsURL, .F.)

If goApp.ose = 'conastec' Or goApp.ose = 'efact' Or goApp.ose = 'bizlinks' Then
	oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8" )
Else
	oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" )
Endif
*oXMLHttp.setRequestHeader( "Content-Type", "text/xml" )
*oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" )
oXMLHttp.setRequestHeader( "Content-Length", Len(ls_envioXML) )
If goApp.ose = 'bizlinks' Or goApp.ose = 'conastec' Or goApp.ose = 'efact'  Then
	oXMLHttp.setRequestHeader( "SOAPAction", "urn:getStatus" )
Else
	oXMLHttp.setRequestHeader( "SOAPAction", "getStatus" )
Endif
If goApp.ose <> 'bizlinks' Then
	oXMLHttp.setOption(2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS)
Endif
oXMLHttp.Send(oXMLBody.documentElement.XML)
If (oXMLHttp.Status <> 200) Then
	Messagebox('STATUS: ' + Alltrim(Str(oXMLHttp.Status)) + '-' + Nvl(oXMLHttp.responseText, ''), 16, MSGTITULO)
	Return 0
Endif
loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
loXMLResp.LoadXML(oXMLHttp.responseText)
CmensajeError	= leerXMl(Alltrim(oXMLHttp.responseText), "<faultcode>", "</faultcode>")
CMensajeMensaje	= leerXMl(Alltrim(oXMLHttp.responseText), "<faultstring>", "</faultstring>")
If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Then
	Messagebox((Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje)), 16, MSGTITULO)
	Return 0
Endif
lcXML = oXMLHttp.responseText
If "<statusCode>" $ lcXML
	lnCount = 1
Else
	lnCount = 2
Endif
cresp = ""
For lnI = 1 To Occurs('<statusCode>', lcXML)
	cresp = Strextract(lcXML, '<statusCode>', '</statusCode>', lnI)
Next lnI
ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
ArchivoRespuestaSunat.LoadXML(oXMLHttp.responseText)			&&Llenamos el archivo de respuesta
*Messagebox(oXMLHttp.responseText,16,'Sisven')

TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//content")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
If Vartype(TxtB64) <> 'O' Then
	Messagebox('A�n No Hay Respuesta de los Servidores de SUNAT C�digo de Respuesta ' + Alltrim(cresp), 16, MSGTITULO)
	Return  0
Endif
If Type('oempresa') = 'U' Then
	cnombre	  = VerificaArchivoRespuesta(Addbs(Sys(5) + Sys(2003) + '\SunatXml') + crespuesta, crespuesta, cticket)
	cfilerpta = Addbs( Sys(5) + Sys(2003) + '\SunatXML') + 'R-' + carchivozip + '.XML'
	cDirDesti = Addbs(Sys(5) + Sys(2003) + '\SunatXML')
Else
	cnombre = VerificaArchivoRespuesta(Addbs(Sys(5) + Sys(2003) + '\SunatXml\' + Alltrim(Oempresa.nruc)) + crespuesta, crespuesta, cticket)
*cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+Alltrim(oempresa.nruc)+"\"+crespuesta
	cfilerpta = Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc)) + 'R-' + carchivozip + '.XML'
	cDirDesti = Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc))
Endif
If !Directory(cDirDesti)
	Md (cDirDesti)
Endif
If File(cfilerpta) Then
	Delete File (cfilerpta)
Endif
decodefile(TxtB64.Text, cnombre)
oShell	  = Createobject("Shell.Application")
cfilerpta = "R"
For Each oArchi In oShell.NameSpace(cnombre).Items
	If Left(oArchi.Name, 1) = 'R' Then
		oShell.NameSpace(cDirDesti).CopyHere(oArchi)
		cfilerpta = Juststem(oArchi.Name) + '.XML'
	Endif
Endfor
If Type('oempresa') = 'U' Then
	rptaSunat = LeerRespuestaSunat(Sys(5) + Sys(2003) + '\SunatXML\' + cfilerpta)
	cfilecdr  = Sys(5) + Sys(2003) + '\SunatXML\' + cfilerpta
Else
	rptaSunat = LeerRespuestaSunat(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\" + cfilerpta)
	cfilecdr  = Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\" + cfilerpta
Endif
If !Empty(rptaSunat)
	If Len(Alltrim(rptaSunat)) <= 100 Then
		Mensaje(rptaSunat)
	Else
		Messagebox(Left(rptaSunat, 240), 0, MSGTITULO)
		Return 0
	Endif
Endif
If !Empty(rptaSunat) Then
	If Substr(ctipoarchivo, 13, 2) = 'RA' Then
		If ActualizaResumenBajas(cticket, cfilecdr) = 0 Then
			Messagebox("NO se Grabo la Respuesta de SUNAT en Base de Datos", 16, MSGTITULO)
		Endif
	Else
		If ActualizaResumenBoletas(cticket, cfilecdr) = 0 Then
			Messagebox("NO se Grabo la Respuesta de SUNAT en Base de Datos", 16, MSGTITULO)
		Endif
	Endif
	If Left(rptaSunat, 1) == '0' Then
		Return 1
	Else
		Return 0
	Endif
Else
	Return 0
Endif
Endproc
***********************************
Procedure CrearPdf(np1, np2, np3)
Private oFbc
Local lcImpresora, lcImpresoraActual, lcStrings, lnResultado
Do "Foxypreviewer.App" With "Release"
Set Procedure To CapaDatos, abrirpdf, FoxbarcodeQR Additive
m.oFbc = Createobject("FoxBarcodeQR")
If !Pemstatus(goApp, 'archivoqr', 5) Then
	goApp.AddProperty("archivoqr", "")
Endif
If !Pemstatus(goApp, 'proyecto', 5) Then
	goApp.AddProperty("proyecto", "")
Endif
goApp.archivoqr = Addbs(Sys(5) + Sys(2003)) + "codigoqr.png"
Do "FoxyPreviewer.App"
lcStrings = np2
crutapdf1 = Left(Substr(lcStrings, Rat("pdf", lcStrings)), 3)
crutapdf2 = Left(Substr(lcStrings, Rat("PDF", lcStrings)), 3)
filepdf	  = Justfname(np2)
Cruta = Addbs(Sys(5) + Sys(2003))
If Type('oempresa') = 'U' Then
	If !Directory( Cruta + "pdf") Then
		ccarpeta = Cruta + "pdf"
		Mkdir (ccarpeta)
	Endif
	carchivopdf = Addbs(Addbs(Sys(5) + Sys(2003)) + 'PDF') + filepdf
Else
	If !Directory(Addbs(Cruta + 'pdf') + Alltrim(Oempresa.nruc)) Then
		ccarpeta = Addbs(Cruta + "pdf") + Alltrim(Oempresa.nruc)
		Mkdir (ccarpeta)
	Endif
	carchivopdf  = Addbs(Addbs(Addbs(Sys(5) + Sys(2003)) + 'PDF') + Alltrim(Oempresa.nruc)) + filepdf
Endif
cpropiedad = "Impresoranormal"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("Impresoranormal", "")
Else
	lcImpresora = goApp.Impresoranormal
Endif
cpropiedad = "Impresionticket"

If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("Impresionticket", "")
Else
	lcImpresora = goApp.Impresoranormal
Endif
If !Empty(goApp.Impresoranormal) Then
	Declare Integer SetDefaultPrinter In WINSPOOL.DRV ;
		String pszPrinter
	lcImpresoraActual = ObtenerImpresoraActual()
	lcImpresora		  = goApp.Impresoranormal
	lnResultado		  = SetDefaultPrinter(lcImpresora)
	Set Printer To Name (lcImpresora)
	Report Form (np1) Object Type 10 To File (carchivopdf)
	Do Foxypreviewer.App With "Release"
	lnResultado = SetDefaultPrinter(lcImpresoraActual)
	Set Printer To Name (lcImpresoraActual)
Else
	If goApp.ImpresionTicket = 'S' And np3 = 'S'  Then
		Declare Integer SetDefaultPrinter In WINSPOOL.DRV ;
			String pszPrinter
		lcImpresoraActual = ObtenerImpresoraActual()
		lcImpresora		  = Getprinter()
		If !Empty(lcImpresora) Then
			Set Printer To Name (lcImpresora)
			Report Form (np1) Object Type 10 To File (carchivopdf)
			Do Foxypreviewer.App With "Release"
			lnResultado = SetDefaultPrinter(lcImpresoraActual)
			Set Printer To Name (lcImpresoraActual)
		Endif
	Else
*!*	aca ERROR
*!*		    Wait Window 'hola1'+carchivopdf
*!*	        wait WINDOW np1
		Report Form (np1) Object Type 10 To File (carchivopdf)
*!*			Wait Window 'hola2'+carchivopdf
	Endif
Endif
If np3 = 'S' Then
	abrirpdf(carchivopdf )
Endif
m.oFbc = Null
Release Obj
Do Foxypreviewer.App With "Release"
Endproc
***********************************
Procedure Reimprimir(np1, np2)
Local lC
*:Global carchivo, cciud, chash, cmone, cndoc, ctdoc, dfvto, ncon, nf, ni, nimpo, x
If VerificaAlias("tmpv") = 0 Then
	Create Cursor tmpv(coda N(8), Desc c(120), Unid c(6), Prec N(13, 8), cant N(10, 2), Ndoc c(12), alma N(10, 2), Peso N(10, 2), ;
		  Impo N(10, 2), tipro c(1), ptoll c(50), fect d, perc N(5, 2), cletras c(120), ;
		  nruc c(11), razon c(120), Direccion c(190), fech d, fechav d, Ndo2 c(12), Vendedor c(50), Form c(20), ;
		  Referencia c(150), hash c(30), dni c(8), Mone c(1), Tdoc1 c(2), dcto c(12), fech1 d, Detalle c(120), contacto c(120), Archivo c(120), costoRef N(12, 5))
Else
	Zap In tmpv
Endif
Do Case
Case np2 = '01' Or np2 = '03'
	Text To lC Noshow
				Select  A.codv,	A.idauto,A.alma,A.idkar,						A.idart,A.cant,
						ifnull(A.Prec, Cast(0 As Decimal(12, 5))) As Prec,
						A.alma,c.tdoc As tdoc1,						c.ndoc As dcto,
						c.fech As fech1,						rcom_arch,
						A.kar_cost As costo,						ifnull(p.fevto, c.fech) As fvto,
						c.fech,						c.fecr,						c.
						  Form, c.Deta,
						c.Exon,						c.ndo2,						c.igv,
						A.idclie,						d.razo,
						d.nruc,						d.Dire,						d.ciud,
						d.ndni,						c.pimpo,
						ifnull(x.dpto_nomb, '') As dpto,
						d.clie_dist As distrito,						c.tdoc,
						c.ndoc,						A.dola,
						c.Mone,						b.Descri,						b.unid,
						c.rcom_hash,						v.nomv,
						c.Impo
					From fe_art As b
					Join fe_kar As A
						On(b.idart = A.idart)
					inner Join fe_vend As v
						On v.idven = A.codv
					inner Join fe_rcom As c
						On(A.idauto = c.idauto)
					inner Join fe_clie As d
						On(c.idcliente = d.idclie)
					Left Join fe_dpto As x
						On x.dpto_idpt = d.clie_idpt
					Left Join (Select  idauto,
									   Min(c.fevto) As fevto
								   From fe_cred As c
								   Where Acti = 'A'
								   Group By idauto) As p
						On p.idauto = c.idauto
					Where c.idauto = ?np1
						And A.Acti = 'A';
	Endtext
Case np2 = '08'
	Text To lC Noshow
			   Select  r.idauto,
					   r.ndoc,
					   r.tdoc,
					   r.fech,
					   r.Mone,
					   Abs(r.valor) As valor,
					   r.ndo2,
					   r.vigv,
					   c.nruc,
					   c.razo,
					   c.Dire,
					   c.ciud,
					   c.ndni,
					   ' ' As nomv,
					   r.
						 Form, ifnull(x.dpto_nomb, '') As dpto,
					   c.clie_dist As distrito,
					   Abs(r.igv) As igv,
					   Abs(r.Impo) As Impo,
					   ifnull(k.cant, Cast(0 As Decimal(12, 2))) As cant,
					   ifnull(kar_cost, Cast(0 As Decimal(12, 5))) As costo,
					   ifnull(k.Prec, Abs(r.Impo)) As Prec,
					   Left(r.ndoc, 4) As serie,
					   Substr(r.ndoc, 5) As numero,
					   ifnull(A.unid, '') As unid,
					   ifnull(A.Descri, r.Deta) As Descri,
					   r.Deta,
					   ifnull(k.idart, Cast(0 As Decimal(8))) As idart,
					   F.ndoc As dcto,
					   F.fech As fech1,
					   w.tdoc As tdoc1,
					   rcom_hash,
					   rcom_arch,
					   r.fech As fvto
				   From fe_rcom r
				   inner Join fe_clie c
					   On c.idclie = r.idcliente
				   Left Join fe_kar k
					   On k.idauto = r.idauto
				   Left Join fe_art A
					   On A.idart = k.idart
				   inner Join fe_rven As rv
					   On rv.idauto = r.idauto
				   inner Join fe_refe F
					   On F.idrven = rv.idrven
				   inner Join fe_tdoc As w
					   On w.idtdoc = F.idtdoc
				   Left Join fe_dpto As x
					   On x.dpto_idpt = c.clie_idpt
				   Where r.idauto = ?np1
					   And r.Acti = 'A'
					   And r.tdoc = '08'
	Endtext
Case np2 = '07'
	Text To lC Noshow
			   Select  r.idauto,
					   r.ndoc,
					   r.tdoc,
					   r.fech,
					   r.Mone,
					   Abs(r.valor) As valor,
					   r.ndo2,
					   r.vigv,
					   c.nruc,
					   c.razo,
					   c.Dire,
					   c.ciud,
					   c.ndni,
					   ' ' As nomv,
					   r.
						 Form, ifnull(x.dpto_nomb, '') As dpto,
					   c.clie_dist As distrito,
					   Abs(r.igv) As igv,
					   Abs(r.Impo) As Impo,
					   ifnull(k.cant, Cast(0 As Decimal(12, 2))) As cant,
					   ifnull(kar_cost, Cast(0 As Decimal(12, 5))) As costo,
					   ifnull(k.Prec, Abs(r.Impo)) As Prec,
					   Left(r.ndoc, 4) As serie,
					   Substr(r.ndoc, 5) As numero,
					   ifnull(A.unid, '') As unid,
					   ifnull(A.Descri, r.Deta) As Descri,
					   r.Deta,
					   ifnull(k.idart, Cast(0 As Decimal(8))) As idart,
					   F.ndoc As dcto,
					   F.fech As fech1,
					   w.tdoc As tdoc1,
					   rcom_hash,
					   rcom_arch,
					   r.fech As fvto
				   From fe_rcom r
				   inner Join fe_clie c
					   On c.idclie = r.idcliente
				   Left Join fe_kar k
					   On k.idauto = r.idauto
				   Left Join fe_art A
					   On A.idart = k.idart
				   inner Join fe_rven As rv
					   On rv.idauto = r.idauto
				   inner Join fe_refe F
					   On F.idrven = rv.idrven
				   inner Join fe_tdoc As w
					   On w.idtdoc = F.idtdoc
				   Left Join fe_dpto As x
					   On x.dpto_idpt = c.clie_idpt
				   Where r.idauto = ?np1
					   And r.Acti = 'A'
					   And r.tdoc = '07'
	Endtext
Endcase
ncon = AbreConexion()
If SQLExec(ncon, lC, 'kardex') < 0 Then
	Errorbd(lC)
	Return
Endif
CierraConexion(ncon)
nimpo	 = Kardex.Impo
cndoc	 = Kardex.Ndoc
cmone	 = Kardex.Mone
cTdoc	 = Kardex.Tdoc
chash	 = Kardex.rcom_hash
cArchivo = Sys(5) + Sys(2003) + '\' + Justfname(Kardex.rcom_arch)
dfvto	 = Kardex.fvto
nf		 = 0
Select Kardex
Scan All
	nf	  = nf + 1
	cciud = Iif(!Empty(Kardex.distrito), "-" + Alltrim(Kardex.distrito), "") + "-" + Alltrim(Kardex.ciud) + "" + Iif(!Empty(Kardex.dpto), "-" + Kardex.dpto, "")
	Insert Into tmpv(coda, Desc, Unid, cant, Prec, Ndoc, hash, nruc, razon, Direccion, fech, fechav, Ndo2, Vendedor, Form, Referencia, dni, Mone, dcto, Tdoc1, fech1, costoRef);
		Values(Kardex.idart, Kardex.Descri, Kardex.Unid, Iif(Kardex.cant = 0, 1, Kardex.cant), Kardex.Prec, ;
		  Kardex.Ndoc, Kardex.rcom_hash, Kardex.nruc, Kardex.Razo, Alltrim(Kardex.Dire) + ' ' + Alltrim(cciud), Kardex.fech, Kardex.fvto, ;
		  Kardex.Ndo2, Kardex.nomv, ;
		  Icase(Kardex.Form = 'E', 'Efectivo', Kardex.Form = 'C', 'Cr�dito', Kardex.Form = 'T', 'Tarjeta', Kardex.Form = 'D', 'Dep�sito', Kardex.Form = 'H', 'Cheque', 'Factoring'), ;
		  Kardex.Deta, Kardex.ndni, Kardex.Mone, Kardex.dcto, Kardex.Tdoc1, Kardex.fech1, Kardex.costo)
Endscan
Local Cimporte
Cimporte = Diletras(nimpo, cmone)
ni		 = nf
Private oFbc
Set Procedure To CapaDatos, FoxbarcodeQR Additive
m.oFbc = Createobject("FoxBarcodeQR")
Select tmpv
For x = 1 To fe_gene.Items - nf
	ni = ni + 1
	Insert Into tmpv(Ndoc)Values(cndoc)
Next
Select tmpv
Replace All Ndoc With cndoc, cletras With Cimporte, Mone With cmone, hash With chash, Archivo With cArchivo, fechav With dfvto
Go Top In tmpv
Endproc
*******************************
Function  generaCorrelativoEnvioResumenBoletas()
Local lC
Text To lC Noshow Textmerge
	UPDATE fe_gene  as f SET gene_nres=f.gene_nres+1 WHERE idgene=1
Endtext
If Ejecutarsql(lC) < 0 Then
	Return 0
Endif
Return 1
Endfunc
*****************************
Function  generaCorrelativoEnvioResumenBajas()
Local lC
Text To lC Noshow Textmerge
	   UPDATE fe_gene  as f SET gene_nbaj=f.gene_nbaj+1 WHERE idgene=1
Endtext
If Ejecutarsql(lC) < 0 Then
	Return 0
Endif
Return 1
Endfunc
*********************************
Function RegistraResumenBajas(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10)
Local lC, lp
*:Global cur
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
lC			  = "proIngresaRbajas"
cur			  = []
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Registrando el Informe de Bajas')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************************
Function RegistraResumenBoletas(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15)
Local lC, lp
*:Global cur
cur			  = []
lC			  = "proIngresaResumenBoletas"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Registrando Resumen de Boletas')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************
Function ActualizaResumenBoletas(np1, np2)
Local lC, lp
*:Global cdrxml, crptaSunat, cur
cur			 = []
lC			 = "ProactualizaResumenBoletas"
goApp.npara1 = np1
goApp.npara2 = np2
crptaSunat	 = LeerRespuestaSunat(np2)
cdrxml		 = Filetostr(np2)
If goApp.Grabarxmlbd = 'S' Then
	Text To lp Noshow
     (?goapp.npara1,?crptaSunat,?cdrxml)
	Endtext
Else
	Text To lp Noshow
     (?goapp.npara1,?crptaSunat)
	Endtext
Endif
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Actualizando Respuesta de Sunat')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************
Function ActualizaResumenBajas(np1, np2)
Local lC, lp
*:Global cdrxml, crptaSunat, cur
cur			 = []
crptaSunat	 = LeerRespuestaSunat(np2)
lC			 = "ProactualizaRBajas"
goApp.npara1 = np1
goApp.npara2 = np2
cdrxml		 = Filetostr(np2)
If goApp.Grabarxmlbd = 'S' Then
	Text To lp Noshow
     (?goapp.npara1,?crptaSunat,?cdrxml)
	Endtext
Else
	Text To lp Noshow
     (?goapp.npara1,?crptaSunat)
	Endtext
Endif
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Actualizando Respuesta de Sunat')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Procedure GuardaPk(np1, np2, np3, cTdoc)
Local lcpk
*:Global carchivo, cdrxml, cpropiedad, crptaSunat, cxml, dfenvio
cpropiedad = "Grabarxmlbd"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("Grabarxmlbd", "")
Endif
cArchivo   = goApp.cArchivo
dfenvio	   = cfechas(fe_gene.fech)
dfenvio	   = fe_gene.fech
crptaSunat = LeerRespuestaSunat(np3)
If goApp.Grabarxmlbd = 'S' Then
	If cTdoc = '03' Then
		cxml   = ""
		cdrxml = ""
	Else
		cxml   = Filetostr(cArchivo)
		cdrxml = Filetostr(np3)
*!*			cxml   = ""
*!*			cdrxml = ""
	Endif
	If File(cArchivo) And File(np3) Then
		Text To lcpk Noshow
          UPDATE fe_rcom SET rcom_mens=?crptaSunat,rcom_arch=?carchivo,rcom_fecd=?dfenvio,rcom_xml=?cxml,rcom_cdr=?cdrxml WHERE idauto=?np1
		Endtext
	Else
		If File(cArchivo) And !File(np3)
			Text To lcpk Noshow
              UPDATE fe_rcom SET rcom_mens=?crptaSunat,rcom_arch=?carchivo,rcom_fecd=?dfenvio,rcom_xml=?cxml WHERE idauto=?np1
			Endtext
		Endif
	Endif
Else
	Text To lcpk Noshow
       UPDATE fe_rcom SET rcom_hash=?np2,rcom_mens=?crptaSunat,rcom_arch=?carchivo,rcom_fecd=?dfenvio WHERE idauto=?np1
	Endtext
Endif
If SQLExec(goApp.bdConn, lcpk) < 1 Then
	Errorbd(lcpk)
	Return 0
Endif
Return 1
Endproc
***************************
Procedure GuardaPkXML(np1, np2, np3, cTdoc)
*:Global carchivo, cpropiedad, cxml
cpropiedad = "Grabarxmlbd"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("Grabarxmlbd", "")
Endif
cArchivo = goApp.cArchivo
If goApp.Grabarxmlbd = 'S' Then
	If cTdoc = '03' Then
		cxml = ""
	Else
		cxml = Filetostr(cArchivo)
*!*			cxml=""
	Endif
	Text  To lC Noshow
       UPDATE fe_rcom SET rcom_arch=?carchivo,rcom_xml=?cxml WHERE idauto=?np1
	Endtext
Else
	Text  To lC Noshow
       UPDATE fe_rcom SET rcom_arch=?carchivo WHERE idauto=?np1
	Endtext
Endif
If SQLExec(goApp.bdConn, lC) < 1 Then
	Errorbd(lC)
	Return 0
Endif
Return 1
Endproc
***************************
Procedure ReimprimirStandar(np1, np2, np3)
Local lC
If VerificaAlias("tmpv") = 0 Then
	Create Cursor tmpv(coda N(8), Desc c(120), Unid c(15), Prec N(13, 8), cant N(10, 2), Ndoc c(12), alma N(10, 2), Peso N(10, 2), ;
		  Impo N(10, 2), tipro c(1), ptoll c(50), fect d, perc N(5, 2), cletras c(120), Tdoc c(2), dias N(4), ;
		  nruc c(11), razon c(150), Direccion c(190), fech d, fechav d, Ndo2 c(12), Vendedor c(50), Forma c(20), Form c(20), Guia c(15), duni c(15), ;
		  Referencia c(120), hash c(30), dni c(11), Mone c(1), Tdoc1 c(2), dcto c(12), fech1 d, Usuario c(30), Tigv N(5, 3), Detalle c(120), contacto c(120), Archivo c(120), ;
		  valor N(12, 2), igv N(12, 2), Total N(12, 2), gratuitas N(12, 2), Exon N(12, 2), Importe N(12, 2), ;
		  copia c(1), detraccion N(10, 2), coddetrac c(10), anticipo N(12, 2), refanticipo c(60))
Else
	Zap In tmpv
Endif

Do Case
Case np2 = '01' Or np2 = '03' Or np2 = '20'
	cx = ""
	If  Vartype(np3) = 'C' Then
		cx = np3
	Endif
	If cx = 'S' Then
		If goApp.vtascondetraccion = 'S' Then
			If goApp.Vtasconanticipo = 'S' Then
				If fe_gene.nruc = "20439488736" Then
					Text To lC Noshow Textmerge
				  	4 as codv,c.idauto,0 as idart,m.detv_cant as cant,m.detv_prec as prec,c.codt as alma,
	          		c.tdoc as tdoc1,c.ndoc as dcto,c.fech as fech1,c.vigv,
				    c.fech,c.fecr,c.form,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,
	          		c.pimpo,u.nomb as usuario,c.deta,c.valor,c.igv,c.impo,
				    c.tdoc,c.ndoc,c.dolar as dola,c.mone,m.detv_desc as descri,detv_unid as Unid,
	          		c.rcom_hash,'Oficina' as nomv,c.impo,ifnull(p.fevto,c.fech) as fvto,c.rcom_mdet,c.rcom_detr,
	          		IFNULL(z.Ndoc,'') As dctoanticipo,IFNULL(z.Impo,Cast(0 As Decimal(10,2))) As totalanticipo,
			        IFNULL(If(z.rcom_exon>0,z.rcom_exon,z.valor),Cast(0 As Decimal(10,2))) As valorganticipo,IFNULL(z.fech,c.fech) As fechanti,
			        IFNULL(w.Ndoc,'') As dctoanticipo2,IFNULL(w.Impo,Cast(0 As Decimal(10,2))) As totalanticipo2,
			        IFNULL(If(w.rcom_exon>0,w.rcom_exon,w.valor),Cast(0 As Decimal(10,2))) As valorganticipo2,IFNULL(w.fech,c.fech) As fechanti2
	          		FROM fe_rcom as c
	          		inner join fe_clie as d on(d.idclie=c.idcliente)
				    inner join fe_usua as u on u.idusua=c.idusua
				    inner join (select detv_cant,detv_prec,detv_desc,detv_idau,detv_unid from fe_detallevta  where detv_idau=<<np1>> and detv_acti='A' order by detv_ite1) as m on m.detv_idau=c.idauto
				    left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r inner join fe_cred as c on c.cred_idrc=r.rcre_idrc
				    where rcre_acti='A' and acti='A' and rcre_idau=<<np1>> group by rcre_idau) as p on p.rcre_idau=c.idauto
				    Left Join fe_rcom As z On z.Idauto=c.rcom_idan
				    left join fe_rcom as w on w.idauto=c.rcom_idan2
	          		where c.idauto=<<np1>>
					Endtext
				Else
					Text To lC Noshow Textmerge
			  	4 as codv,c.idauto,0 as idart,m.detv_cant as cant,m.detv_prec as prec,c.codt as alma,
          		c.tdoc as tdoc1,c.ndoc as dcto,c.fech as fech1,c.vigv,
			    c.fech,c.fecr,c.form,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,
          		c.pimpo,u.nomb as usuario,c.deta,c.valor,c.igv,c.impo,
			    c.tdoc,c.ndoc,c.dolar as dola,c.mone,m.detv_desc as descri,detv_unid as Unid,
          		c.rcom_hash,'Oficina' as nomv,c.impo,ifnull(p.fevto,c.fech) as fvto,c.rcom_mdet,c.rcom_detr,
          		IFNULL(z.Ndoc,'') As dctoanticipo,IFNULL(z.Impo,Cast(0 As Decimal(10,2))) As totalanticipo,
		        IFNULL(If(z.rcom_exon>0,z.rcom_exon,z.valor),Cast(0 As Decimal(10,2))) As valorganticipo,IFNULL(z.fech,c.fech) As fechanti,
          		FROM fe_rcom as c
          		inner join fe_clie as d on(d.idclie=c.idcliente)
			    inner join fe_usua as u on u.idusua=c.idusua
			    inner join (select detv_cant,detv_prec,detv_desc,detv_idau,detv_unid from fe_detallevta  where detv_idau=<<np1>> and detv_acti='A' order by detv_ite1) as m on m.detv_idau=c.idauto
			    left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r inner join fe_cred as c on c.cred_idrc=r.rcre_idrc
			    where rcre_acti='A' and acti='A' and rcre_idau=<<np1>> group by rcre_idau) as p on p.rcre_idau=c.idauto
			    Left Join fe_rcom As z On z.Idauto=c.rcom_idan
          		where c.idauto=<<np1>>
					Endtext
				Endif
			Else
				Text To lC Noshow Textmerge
			  	4 as codv,c.idauto,0 as idart,
                CAST(ifnull(m.detv_cant,1)  as decimal(12,2))as cant,CAST(ifnull(m.detv_prec,c.impo) as decimal(12,4)) as prec,c.codt as alma,
          		c.tdoc as tdoc1,c.ndoc as dcto,c.fech as fech1,c.vigv,
			    c.fech,c.fecr,c.form,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,
          		c.pimpo,u.nomb as usuario,c.deta,c.valor,c.igv,c.impo,
			    c.tdoc,c.ndoc,c.dolar as dola,c.mone,m.detv_desc as descri,detv_unid as Unid,
          		c.rcom_hash,'Oficina' as nomv,c.impo,ifnull(p.fevto,c.fech) as fvto,rcom_mdet,rcom_detr,
          		Cast(0 As Decimal(10,2)) As totalanticipo,Cast(0 As Decimal(10,2)) As valorganticipo,c.fech As fechanti,c.Ndoc As dctoanticipo
          		FROM fe_rcom as c
          		inner join fe_clie as d on(d.idclie=c.idcliente)
			    inner join fe_usua as u on u.idusua=c.idusua
			    inner join (select detv_cant,detv_prec,detv_desc,detv_idau,detv_unid from fe_detallevta  where detv_idau=<<np1>> and detv_acti='A' order by detv_ite1) as m on m.detv_idau=c.idauto
			    left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r inner join fe_cred as c on c.cred_idrc=r.rcre_idrc
                where rcre_acti='A' and acti='A' and rcre_idau=<<np1>> group by rcre_idau) as p on p.rcre_idau=c.idauto
          		where c.idauto=<<np1>>
				Endtext
			Endif
		Else
			Text To lC Noshow Textmerge
			  	4 as codv,c.idauto,0 as idart,
                CAST(ifnull(m.detv_cant,1)  as decimal(12,2))as cant,CAST(ifnull(m.detv_prec,c.impo) as decimal(12,4)) as prec,c.codt as alma,
          		c.tdoc as tdoc1,c.ndoc as dcto,c.fech as fech1,c.vigv,
			    c.fech,c.fecr,c.form,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,
          		c.pimpo,u.nomb as usuario,c.deta,c.valor,c.igv,c.impo,
			    c.tdoc,c.ndoc,c.dolar as dola,c.mone,m.detv_desc as descri,detv_unid as Unid,
          		c.rcom_hash,'Oficina' as nomv,c.impo,ifnull(p.fevto,c.fech) as fvto,CAST(0 as decimal(10,2)) as rcom_mdet,rcom_detr,
          		Cast(0 As Decimal(10,2)) As totalanticipo,Cast(0 As Decimal(10,2)) As valorganticipo,c.fech As fechanti,c.Ndoc As dctoanticipo
          		FROM fe_rcom as c
          		inner join fe_clie as d on(d.idclie=c.idcliente)
			    inner join fe_usua as u on u.idusua=c.idusua
			    inner join (select detv_cant,detv_prec,detv_desc,detv_idau,detv_unid from fe_detallevta  where detv_idau=<<np1>> and detv_acti='A' order by detv_ite1) as m on m.detv_idau=c.idauto
			    left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r inner join fe_cred as c on c.cred_idrc=r.rcre_idrc
                where rcre_acti='A' and acti='A' and rcre_idau=<<np1>> group by rcre_idau) as p on p.rcre_idau=c.idauto
          		where c.idauto=<<np1>>
			Endtext
		Endif
	Else
		Text To lC Noshow Textmerge
			    a.codv,a.idauto,a.alma,a.idkar,a.idauto,a.idart,a.cant,a.prec,a.alma,c.tdoc as tdoc1,
			    c.ndoc as dcto,c.fech as fech1,c.vigv,c.valor,c.igv,c.impo,
			    c.fech,c.fecr,c.form,c.deta,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,c.pimpo,u.nomb as usuario,
			    c.tdoc,c.ndoc,c.dolar as dola,c.mone,b.descri,b.unid,c.rcom_hash,v.nomv,c.impo,ifnull(p.fevto,c.fech) as fvto,
			    CAST(0 as decimal(10,2)) as rcom_mdet,rcom_detr,Cast(0 As Decimal(10,2)) As totalanticipo,Cast(0 As Decimal(10,2)) As valorganticipo,c.fech As fechanti,c.Ndoc As dctoanticipo
			    FROM fe_rcom as c
			    inner join fe_kar as a on a.idauto=c.idauto
			    inner join fe_art as b on b.idart=a.idart
			    inner join fe_vend as v on v.idven=a.codv
			    inner join fe_clie as d on(c.idcliente=d.idclie)
			    inner join fe_usua as u on u.idusua=c.idusua
			    left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r inner join fe_cred as c on c.cred_idrc=r.rcre_idrc
                where rcre_acti='A' and acti='A' and rcre_idau=<<np1>> group by rcre_idau) as p on p.rcre_idau=c.idauto
			    where c.idauto=<<np1>> and a.acti='A';
		Endtext
	Endif
Case np2 = '08'
	Text To lC Noshow Textmerge
			   r.idauto,r.ndoc,r.tdoc,r.fech,r.mone,abs(r.valor) as valor,r.ndo2,
		       r.vigv,c.nruc,c.razo,c.dire,c.ciud,c.ndni,' ' as nomv,r.form,
		       abs(r.igv) as igv,abs(r.impo) as impo,ifnull(k.cant,CAST(0 as decimal(12,2))) as cant,
		       ifnull(k.prec,ABS(r.impo)) as prec,LEFT(r.ndoc,4) as serie,SUBSTR(r.ndoc,5) as numero,
		       ifnull(a.unid,'') as unid,ifnull(a.descri,r.deta) as descri,r.deta,ifnull(k.idart,CAST(0 as decimal(8))) as idart,w.ndoc as dcto,
		       w.fech as fech1,w.tdoc as tdoc1,r.rcom_hash,u.nomb as usuario,r.fech as fvto,ABS(r.rcom_exon) as rcom_exon,
		       CAST(0 as decimal(10,2)) as rcom_mdet,r.rcom_detr,Cast(0 As Decimal(10,2)) As totalanticipo,
		       Cast(0 As Decimal(10,2)) As valorganticipo,r.fech As fechanti,r.Ndoc As dctoanticipo
		       from fe_rcom r
		       inner join fe_clie c on c.idclie=r.idcliente
		       left join fe_kar k on k.idauto=r.idauto
		       left join fe_art a on a.idart=k.idart
		       inner join fe_ncven f on f.ncre_idan=r.idauto
		       inner join fe_rcom as w on w.idauto=f.ncre_idau
		       inner join fe_usua as u on u.idusua=r.idusua
		       where r.idauto=<<np1>> and r.acti='A' and r.tdoc='08'
	Endtext
Case np2 = '07'
	Text To lC Noshow Textmerge
			   r.idauto,r.ndoc,r.tdoc,r.fech,r.mone,abs(r.valor) as valor,r.ndo2,
		       r.vigv,c.nruc,c.razo,c.dire,c.ciud,c.ndni,' ' as nomv,r.form,u.nomb as usuario,
		       abs(r.igv) as igv,abs(r.impo) as impo,ifnull(k.cant,CAST(0 as decimal(12,2))) as cant,
		       ifnull(k.prec,ABS(r.impo)) as prec,LEFT(r.ndoc,4) as serie,SUBSTR(r.ndoc,5) as numero,
		       ifnull(a.unid,'') as unid,ifnull(a.descri,r.deta) as descri,r.deta,ifnull(k.idart,CAST(0 as decimal(8))) as idart,w.ndoc as dcto,
		       w.fech as fech1,w.tdoc as tdoc1,r.rcom_hash,r.fech as fvto,ABS(r.rcom_exon) as rcom_exon,
		       CAST(0 as decimal(10,2)) as rcom_mdet,r.rcom_detr,Cast(0 As Decimal(10,2)) As totalanticipo,Cast(0 As Decimal(10,2)) As valorganticipo,
		       r.fech As fechanti,r.Ndoc As dctoanticipo
		       from fe_rcom r
		       inner join fe_clie c on c.idclie=r.idcliente
		       left join fe_kar k on k.idauto=r.idauto
		       left join fe_art a on a.idart=k.idart
		       inner join fe_ncven f on f.ncre_idan=r.idauto
		       inner join fe_rcom as w on w.idauto=f.ncre_idau
		       inner join fe_usua as u on u.idusua=r.idusua
		       where r.idauto=<<np1>> and r.acti='A' and r.tdoc='07'
	Endtext
Endcase
If EjecutaConsulta(lC, 'kardex') < 1 Then
	Return
Endif
Select Kardex
nimpo  = Kardex.Impo
cndoc  = Kardex.Ndoc
cmone  = Kardex.Mone
cTdoc  = Kardex.Tdoc
chash  = Kardex.rcom_hash
cdeta1 = Kardex.Deta
vvigv  = Kardex.vigv
ndias  = Kardex.fvto - Kardex.fech
dfvto  = Kardex.fvto
nvalor = Kardex.valor
nigv   = Kardex.igv
nTotal = Kardex.Impo
nexon = Kardex.rcom_exon
Cruc = Kardex.nruc
dFecha = Kardex.fech
ndetra = Kardex.rcom_mdet
cforma = Kardex.Form
ccoddetra = Kardex.rcom_detr
nanti = Kardex.Totalanticipo
crefan = ""
If nanti > 0 Then
	If Fsize("totalanticipo2") > 0 Then
		nanti = nanti + Kardex.totalanticipo2
	Else
		crefan = 'Referencia Anrticipo ' + Kardex.dctoanticipo + ' ' + Dtoc(Kardex.fechanti)
	Endif
Endif
nf	   = 0
Select Kardex
Scan All
	nf = nf + 1
	Insert Into tmpv(coda, Desc, Unid, cant, Prec, Ndoc, hash, nruc, razon, Direccion, fech, fechav, Ndo2, Vendedor, Form, ;
		  Referencia, dni, Mone, dcto, Tdoc1, fech1, Usuario, Guia, Forma, Tigv, Tdoc);
		Values(Iif(Vartype(Kardex.idart) = 'N', Kardex.idart, Val(Kardex.idart)), Kardex.Descri, Kardex.Unid, Iif(Kardex.cant = 0, 1, Kardex.cant), Kardex.Prec, ;
		  Kardex.Ndoc, Kardex.rcom_hash, Kardex.nruc, Kardex.Razo, Alltrim(Kardex.Dire) + ' ' + Alltrim(Kardex.ciud), Kardex.fech, Kardex.fvto, ;
		  Kardex.Ndo2, Kardex.nomv, Icase(Kardex.Form = 'E', 'Efectivo', Kardex.Form = 'C', 'Cr�dito', Kardex.Form = 'T', 'Tarjeta', Kardex.Form = 'D', 'Dep�sito', 'Cheque'), ;
		  Kardex.Deta, Kardex.ndni, Kardex.Mone, Kardex.dcto, Kardex.Tdoc1, Kardex.fech1, Kardex.Usuario, Kardex.Ndo2, ;
		  Icase(Kardex.Form = 'E', 'Efectivo', Kardex.Form = 'C', 'Cr�dito', Kardex.Form = 'T', 'Tarjeta', Kardex.Form = 'D', 'Dep�sito', 'Cheque'), Kardex.vigv, cTdoc)
Endscan
Local Cimporte
Cimporte = Diletras(nimpo, cmone)
ni		 = nf
Select tmpv
For x = 1 To fe_gene.Items - nf
	ni = ni + 1
	Insert Into tmpv(Ndoc)Values(cndoc)
Next
Select tmpv
Replace All Ndoc With cndoc, cletras With Cimporte, Mone With cmone, hash With chash, Referencia With cdeta1, ;
	Tigv With vvigv, dias With ndias, fechav With dfvto, valor With nvalor, igv With nigv, Exon With nexon, Total With nimpo, Tdoc With cTdoc, nruc With Cruc, fech With dFecha, ;
	Importe With nimpo, detraccion With ndetra, Forma With cforma, coddetrac With ccoddetra, anticipo With nanti, refanticipo With crefan
Go Top In tmpv
Endproc
********************************
Function GeneraPLE5Contingencia(np1, np2)
*:Global cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select * From cont1;
	Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If nl = 0 Then
        \\<<Motivo>>|<<tipoop>>|<<fech>>|<<Tdoc>>|<<Serie>>|<<numero>>|<<ctik>>|<<tipodocc>>|<<nruc>>|<<Alltrim(Razo)>>|<<Mone>>|<<valor>>|<<Exon>>|<<inafecto>>|<<Expo>>|<<isc>>|<<igv>>|<<otros>>|<<Impo>>|<<tref>>|<<serierefe>>|<<numerorefe>>|<<Regper>>|<<Bper>>|<<Mper>>|<<Tper>>|
	Else
         \<<Motivo>>|<<tipoop>>|<<fech>>|<<Tdoc>>|<<Serie>>|<<numero>>|<<ctik>>|<<tipodocc>>|<<nruc>>|<<Alltrim(Razo)>>|<<Mone>>|<<valor>>|<<Exon>>|<<inafecto>>|<<Expo>>|<<isc>>|<<igv>>|<<otros>>|<<Impo>>|<<tref>>|<<serierefe>>|<<numerorefe>>|<<Regper>>|<<Bper>>|<<Mper>>|<<Tper>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Set Library To Locfile("vfpcompression.fll")
ZipfileQuick(cr1)
zipclose()
Endfunc
***********************************
Function GetFileX(tcRuta, tcExtension, tcLeyenda, tcBoton, tnBoton, tcTitulo)
Local lcDirAnt, lcGetPict
tcRuta		= Iif(Not Empty(tcRuta) And Directory(tcRuta, 1), tcRuta, "")
tcExtension	= Iif(Empty(tcExtension), "", tcExtension)
tcLeyenda	= Iif(Empty(tcLeyenda), "", tcLeyenda)
tcBoton		= Iif(Empty(tcBoton), "", tcBoton)
tnBoton		= Iif(Empty(tnBoton), 0, tnBoton)
tcTitulo	= Iif(Empty(tcTitulo), "", tcTitulo)
lcDirAnt	= Fullpath("")
Set Default To (tcRuta)
lcGetPict = Getfile(tcExtension, tcLeyenda, tcBoton, tnBoton, tcTitulo)
Set Default To (lcDirAnt)
Return lcGetPict
Endfunc

********************************************************************************
Function GetPictX(tcRuta, tcExtension, tcLeyenda, tcBoton)
Local lcDirAnt, lcGetPict
tcRuta		= Iif(Not Empty(tcRuta) And Directory(tcRuta, 1), tcRuta, "")
tcExtension	= Iif(Empty(tcExtension), "", tcExtension)
tcLeyenda	= Iif(Empty(tcLeyenda), "", tcLeyenda)
tcBoton		= Iif(Empty(tcBoton), "", tcBoton)
lcDirAnt	= Fullpath("")
Set Default To (tcRuta)
lcGetPict = Getpict(tcExtension, tcLeyenda, tcBoton)
Set Default To (lcDirAnt)
Return lcGetPict
Endfunc
*****************************
Procedure Mensaje
Lparameters lcMess
If Type("lcMess") = "L"
	Return .F.
Endif
Wait Window lcMess At Srows() / 2, (Scols() / 2 - (Len(lcMess) / 2)) Timeout 1
Endproc
************************************
Function MuestraTabla34(np1, np2, cur)
Local lC, lp
lC			 = "ProMuestratabla34"
goApp.npara1 = np1
goApp.npara2 = np2
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Mostrando Tabla 34')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************************
Function GrabaTabla34PlanCuentas(np1, np2)
Local lC, lp
*:Global cur
lC			 = "ProGrabatabla34PlanCuentas"
cur			 = ""
goApp.npara1 = np1
goApp.npara2 = np2
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Actualizando Plan de Cuentas con  Tabla 34')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************************
Function GeneraCta10Ple5(np1, np2, nmes, Na)
*:Global cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select;
	Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As Periodo, ;
	ncta, ;
	banc_idco, ;
	ctas_ctas, ;
	ctas_mone, ;
	deudor, ;
	acreedor, ;
	1 As estado;
	From cta10 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If nl = 0 Then
          \\<<Periodo>>|<<ncta>>|<<banc_idco>>|<<Trim(ctas_ctas)>>|<<ctas_mone>>|<<deudor>>|<<acreedor>>|<<estado>>|
	Else
		  \<<Periodo>>|<<ncta>>|<<banc_idco>>|<<Trim(ctas_ctas)>>|<<ctas_mone>>|<<deudor>>|<<acreedor>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCta12Ple5(np1, np2, nmes, Na)
*:Global cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select;
	Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As Periodo, ;
	Idauto, ;
	Trim('M' + Alltrim(Str(Ncontrol))) As  Ncontrol, ;
	tipodcto, ;
	ndcto, ;
	Razo, ;
	fech, ;
	saldo, ;
	1 As estado;
	From cta12 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If nl = 0 Then
          \\<<Periodo>>|<<Idauto>>|<<Alltrim(Ncontrol)>>|<<tipodcto>>|<<ndcto>>|<<Razo>>|<<fech>>|<<saldo>>|<<estado>>|
	Else
		  \<<Periodo>>|<<Idauto>>|<<Alltrim(Ncontrol)>>|<<tipodcto>>|<<ndcto>>|<<Razo>>|<<fech>>|<<saldo>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCtaIBPle5(np1, np2, nmes, Na)
*:Global cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select;
	Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As Periodo, ;
	tabla22, ;
	idcta34, ;
	saldo, ;
	1 As estado;
	From rld Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If nl = 0 Then
          \\<<Periodo>>|<<tabla22>>|<<idcta34>>|<<saldo>>|<<estado>>|
	Else
		   \<<Periodo>>|<<tabla22>>|<<idcta34>>|<<saldo>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCta19Ple5(np1, np2, nmes, Na)
*:Global cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select;
	Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As Periodo, ;
	Idauto, ;
	Ncontrol, ;
	tipodcto, ;
	ndcto, ;
	Razo, ;
	Tdoc, ;
	Serie, ;
	fech, ;
	dcto, ;
	saldo, ;
	1 As estado;
	From cta19 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If nl = 0 Then
          \\<<Periodo>>|<<Idauto>>|<<Alltrim(Ncontrol)>>|<<tipodcto>>|<<ndcto>>|<<Razo>>|<<Tdoc>>|<<Serie>>|<<dcto>>|<<fech>>|<<saldo>>|<<estado>>|
	Else
		   \<<Periodo>>|<<Idauto>>|<<Alltrim(Ncontrol)>>|<<tipodcto>>|<<ndcto>>|<<Razo>>|<<Tdoc>>|<<Serie>>|<<dcto>>|<<fech>>|<<saldo>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCta20Ple5(np1, np2, nmes, Na)
*:Global cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select;
	Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As Periodo, ;
	codic, ;
	Tipo, ;
	idart, ;
	codosce, ;
	Descr, ;
	Unid, ;
	metodo, ;
	stock, ;
	costo, ;
	Importe, ;
	1 As estado;
	From cta12 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If nl = 0 Then
          \\<<Periodo>>|<<Idauto>>|<<codic>>|<<Tipo>>|<<idart>>|<<codosce>>|<<Descr>>|<<Unid>>|<<metodo>>|<<stock>>|<<costo>>|<<Importe>>|<<estado>>|
	Else
		   \<<Periodo>>|<<Idauto>>|<<codic>>|<<Tipo>>|<<idart>>|<<codosce>>|<<Descr>>|<<Unid>>|<<metodo>>|<<stock>>|<<costo>>|<<Importe>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCta34Ple5(np1, np2, nmes, Na)
*:Global cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select;
	Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As Periodo, ;
	Recno() As Idauto, ;
	Trim('M' + Alltrim(Str(Recno()))) As Ncontrol, ;
	fech, ;
	ncta, ;
	Deta, ;
	valor, ;
	amor, ;
	1 As estado;
	From cta34 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If nl = 0 Then
          \\<<Periodo>>|<<Idauto>>|<<Alltrim(Ncontrol)>>|<<fech>>|<<ncta>>|<<Deta>>|<<valor>>|<<amor>>|<<estado>>|
	Else
		  \<<Periodo>>|<<Idauto>>|<<Alltrim(Ncontrol)>>|<<fech>>|<<ncta>>|<<Deta>>|<<valor>>|<<amor>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCta37Ple5(np1, np2, nmes, Na)
*:Global cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select;
	Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As Periodo, ;
	Recno() As Idauto, ;
	Trim('M' + Alltrim(Str(Recno()))) As Ncontrol, ;
	Tdoc, ;
	Serie, ;
	Ndoc, ;
	ncta, ;
	Deta, ;
	saldo, ;
	adicional, ;
	deduccion, ;
	1 As estado;
	From cta37 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If nl = 0 Then
          \\<<Periodo>>|<<Idauto>>|<<Alltrim(Ncontrol)>>|<<Tdoc>>|<<Serie>>|<<Ndoc>>|<<ncta>>|<<Deta>>|<<saldo>>|<<adicional>>|<<deduccion>>|<<estado>>|
	Else
		  \<<Periodo>>|<<Idauto>>|<<Alltrim(Ncontrol)>>|<<Tdoc>>|<<Serie>>|<<Ndoc>>|<<ncta>>|<<Deta>>|<<saldo>>|<<adicional>>|<<deduccion>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCta41Ple5(np1, np2, nmes, Na)
*:Global cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select;
	Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As Periodo, ;
	Codigo  As Idauto, ;
	Trim('M' + Alltrim(Str(Codigo))) As Ncontrol, ;
	'41.11.00' As ncta, ;
	Tipo, ;
	ndni, ;
	Codigo, ;
	nombre, ;
	saldo, ;
	1 As estado;
	From cta41 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If nl = 0 Then
		    \\<<Periodo>>|<<Idauto>>|<<Alltrim(Ncontrol)>>|<<ncta>>|<<Tipo>>|<<ndni>>|<<Codigo>>|<<nombre>>|<<saldo>>|<<estado>>|
	Else
			 \<<Periodo>>|<<Idauto>>|<<Alltrim(Ncontrol)>>|<<ncta>>|<<Tipo>>|<<ndni>>|<<Codigo>>|<<nombre>>|<<saldo>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCta42Ple5(np1, np2, nmes, Na)
*:Global cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select;
	Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As Periodo, ;
	Idauto, ;
	Ncontrol, ;
	tipodcto, ;
	ndcto, ;
	Razo, ;
	fech, ;
	saldo, ;
	1 As estado;
	From cta42 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If nl = 0 Then
          \\<<Periodo>>|<<Idauto>>|<<Alltrim(Ncontrol)>>|<<tipodcto>>|<<ndcto>>|<<Razo>>|<<fech>>|<<saldo>>|<<estado>>|
	Else
		  \<<Periodo>>|<<Idauto>>|<<Alltrim(Ncontrol)>>|<<tipodcto>>|<<ndcto>>|<<Razo>>|<<fech>>|<<saldo>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCta46Ple5(np1, np2, nmes, Na)
*:Global cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select;
	Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As Periodo, ;
	Idauto, ;
	Ncontrol, ;
	tipodcto, ;
	ndcto, ;
	fech, ;
	Razo, ;
	Left(ncta, 2) + Substr(ncta, 4, 2) + Substr(ncta, 7, 2) As ncta, ;
	saldo, ;
	1 As estado;
	From cta46 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If nl = 0 Then
          \\<<Periodo>>|<<Idauto>>|<<Alltrim(Ncontrol)>>|<<tipodcto>>|<<ndcto>>|<<fech>>|<<ncta>>|<<Razo>>|<<saldo>>|<<estado>>|
	Else
		   \<<Periodo>>|<<Idauto>>|<<Alltrim(Ncontrol)>>|<<tipodcto>>|<<ndcto>>|<<fech>>|<<ncta>>|<<Razo>>|<<saldo>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCta50Ple5(np1, np2, nmes, Na)
*:Global cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select;
	Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As Periodo, ;
	Importe, ;
	valor, ;
	accs, ;
	accp, ;
	1 As estado;
	From cta50 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If nl = 0 Then
          \\<<Periodo>>|<<Importe>>|<<valor>>|<<accs>>|<<accp>>|<<estado>>|
	Else
		   \<<Periodo>>|<<Importe>>|<<valor>>|<<accs>>|<<accp>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCtaBalancePle5(np1, np2, nmes, Na)
*:Global cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select;
	Cast(Alltrim(Str(Na)) + Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes))) + '00' As Integer) As Periodo, ;
	ncta, ;
	adeudor, ;
	aacreedor, ;
	debe, ;
	haber, ;
	deudor, ;
	acreedor, ;
	deudor As saldofd, ;
	acreedor As saldofh, ;
	debet, ;
	habert, ;
	activo, ;
	pasivo, ;
	rpnperdida, ;
	rpnganancia, ;
	0 As adicionales, ;
	0 As deducciones, ;
	1 As estado;
	From rldbalance  Where estilo = 'S' Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If nl = 0 Then
          \\<<Periodo>>|<<ncta>>|<<adeudor>>|<<aacreedor>>|<<debe>>|<<haber>>|<<deudor>>|<<acreedor>>|<<saldofd>>|<<saldofh>>|<<debet>>|<<habert>><<activo>>|<<pasivo>>|<<rpnperdida>>|<<rpnganancia>>|<<adicionales>>|<<deducciones>>|<<estado>>|
	Else
		   \<<Periodo>>|<<ncta>>|<<adeudor>>|<<aacreedor>>|<<debe>>|<<haber>>|<<deudor>>|<<acreedor>>|<<saldofd>>|<<saldofh>>|<<debet>>|<<habert>><<activo>>|<<pasivo>>|<<rpnperdida>>|<<rpnganancia>>|<<adicionales>>|<<deducciones>>|<<estado>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GrabaDetalleCta37(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10)
Local lC, lp
*:Global cur
cur			  = []
lC			  = "ProIngresaDcta37"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Registrando Detalle de Cta.37')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function GrabaDetalleCta12(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10)
Local lC, lp
*:Global cur
cur			  = []
lC			  = "ProIngresaDcta12"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Registrando Detalle de Cta.12')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function AnulaDetalleCta12(np1)
Local lC, lp
*:Global cur
cur			 = []
lC			 = "ProAnulaDcta12"
goApp.npara1 = np1
Text To lp Noshow
     (?goapp.npara1)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Anulando Detalle de Cta.12')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function AnulaDetalleCta37(np1)
Local lC, lp
*:Global cur
cur			 = []
lC			 = "ProAnulaDcta37"
goApp.npara1 = np1
Text To lp Noshow
     (?goapp.npara1)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Anulando Detalle de Cta.37')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************
Function GrabaDetalleCta34(np1, np2, np3, np4, np5, np6)
Local lC, lp
*:Global cur
cur			 = []
lC			 = "ProIngresaDcta34"
goApp.npara1 = np1
goApp.npara2 = np2
goApp.npara3 = np3
goApp.npara4 = np4
goApp.npara5 = np5
goApp.npara6 = np6
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Registrando Detalle de Cta.34')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************
Function AnulaDetalleCta34(np1)
Local lC, lp
*:Global cur
cur			 = []
lC			 = "ProAnulaDcta34"
goApp.npara1 = np1
Text To lp Noshow
     (?goapp.npara1)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Anulando Detalle de Cta.34')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************
Procedure CrearQR(np1, np2)
Local loFbc As "FoxBarcodeQR"
Local lcQRImage
Set Procedure To FoxbarcodeQR Additive
loFbc	  = Createobject("FoxBarcodeQR")
lcQRImage = loFbc.QRBarcodeImage(np1, np2, 6, 2)
Endproc
**************************
Function GrabaDetalleCta41(np1, np2, np3, np4, np5)
Local lC, lp
*:Global cur
cur			 = []
lC			 = "ProIngresaDcta41"
goApp.npara1 = np1
goApp.npara2 = np2
goApp.npara3 = np3
goApp.npara4 = np4
goApp.npara5 = np5
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Registrando Detalle de Cta.41')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function AnulaDetalleCta41(np1)
Local lC, lp
*:Global cur
cur			 = []
lC			 = "ProAnulaDcta41"
goApp.npara1 = np1
Text To lp Noshow
     (?goapp.npara1)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Anulando Detalle de Cta.41')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************
**************************
Function GrabaDetalleCta42(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10)
Local lC, lp
*:Global cur
cur			  = []
lC			  = "ProIngresaDcta42"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Registrando Detalle de Cta.42')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function AnulaDetalleCta42(np1)
Local lC, lp
*:Global cur
cur			 = []
lC			 = "ProAnulaDcta42"
goApp.npara1 = np1
Text To lp Noshow
     (?goapp.npara1)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Anulando Detalle de Cta.42')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************
Function GrabaDetalleCta46(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10)
Local lC, lp
*:Global cur
cur			  = []
lC			  = "ProIngresaDcta46"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Registrando Detalle de Cta.46')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function GrabaDetalleCta50(np1, np2, np3, np4, np5, np6)
Local lC, lp
*:Global cur
cur			 = []
lC			 = "ProIngresaDcta50"
goApp.npara1 = np1
goApp.npara2 = np2
goApp.npara3 = np3
goApp.npara4 = np4
goApp.npara5 = np5
goApp.npara6 = np6
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Registrando Detalle de Cta.50')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function AnulaDetalleCta46(np1)
Local lC, lp
*:Global cur
cur			 = []
lC			 = "ProAnulaDcta46"
goApp.npara1 = np1
Text To lp Noshow
     (?goapp.npara1)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Anulando Detalle de Cta.46')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function AnulaDetalleCta50(np1)
Local lC, lp
*:Global cur
cur			 = []
lC			 = "ProAnulaDcta50"
goApp.npara1 = np1
Text To lp Noshow
     (?goapp.npara1)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Anulando Detalle de Cta.50')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function GrabaDetalleCta19(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11)
Local lC, lp
*:Global cur
cur			  = []
lC			  = "ProIngresaDcta19"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Registrando Detalle de Cta.19')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function AnulaDetalleCta19(np1)
Local lC, lp
*:Global cur
cur			 = []
lC			 = "ProAnulaDcta19"
goApp.npara1 = np1
Text To lp Noshow
     (?goapp.npara1)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Anulando Detalle de Cta.19')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function GrabaBalanceComprobacion(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19)
Local lC, lp
*:Global cur
cur			  = []
lC			  = "ProIngresaBalanceComprobacion"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
goApp.npara18 = np18
goApp.npara19 = np19
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,
     ?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Registrando Balance de Comprobaci�n')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function AnulaBalanceComprobacion(np1)
Local lC, lp
*:Global cur
cur			 = []
lC			 = "ProAnulaBalanceComprobacion"
goApp.npara1 = np1
Text To lp Noshow
     (?goapp.npara1)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Anulando Balance de Comprobaci�n')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function Mayoriza(dfinicio, dff)
Local lC
*:Global df, dfi
If Vartype(dfinicio) <> 'D' Then
	dfi = Ctod(dfinicio)
Else
	dfi = dfinicio
Endif
Df = dfi - 1
Text To lC Noshow
	   Select  z.ncta, z.nomb, If(z.debe > z.haber, z.debe - z.haber, 0) As adeudor, If(z.haber > z.debe, z.haber - z.debe, 0) As aacreedor,
			   idcta  From
				 (Select  b.ncta, b.nomb, Sum(A.ldia_debe - A.ldia_itrd) As debe, Sum(A.ldia_haber - A.ldia_itrh) As haber,
						  b.idcta,  Max(A.ldia_nume) As ldia_nume From fe_ldiario As A
					  inner Join fe_plan As b	  On b.idcta = A.ldia_idcta
					  Where A.ldia_acti = 'A'	  And ldia_fech <= ?df  And ldia_tran <> 'T'  Group By A.ldia_idcta) As z
Endtext
ncon = AbreConexion()
If SQLExec(ncon, lC, 'mayora') < 0 Then
	Errorbd(lC)
	Return
Endif
CierraConexion(ncon)
Create Cursor mayor(ncta c(15), nomb c(60), adeudor N(12, 2), aacreedor N(12, 2), debe N(12, 2), haber N(12, 2), idcta N(10))
Select * From mayora Where (adeudor + aacreedor) > 0 Into Cursor rlmayora
Select mayor
Append From Dbf("rlmayora")
Text To lC Noshow
	   Select  z.ncta,z.nomb,z.debe,z.haber,idcta  From (Select  b.ncta,
						  b.nomb,Sum(A.ldia_debe - A.ldia_itrd) As debe,Sum(A.ldia_haber - A.ldia_itrh) As haber,b.idcta
					  From fe_ldiario As A
					  inner Join fe_plan As b  On b.idcta = A.ldia_idcta
					  Where A.ldia_acti = 'A'  And ldia_fech Between ?dfi And ?dff  And ldia_tran <> 'T' Group By A.ldia_idcta) As z
Endtext
ncon = AbreConexion()
If SQLExec(ncon, lC, 'rlmayor') < 0 Then
	Errorbd(lC)
	Return
Endif
CierraConexion(ncon)
Select rlmayor
Do While !Eof()
	Select mayor
	Locate For idcta = rlmayor.idcta
	If Found()
		Replace debe With rlmayor.debe, haber With rlmayor.haber In mayor
	Else
		Insert Into mayor(ncta, nomb, debe, haber, idcta)Values(rlmayor.ncta, rlmayor.nomb, rlmayor.debe, rlmayor.haber, rlmayor.idcta)
	Endif
	Select rlmayor
	Skip
Enddo
Select z.ncta, z.nomb, z.adeudor, z.aacreedor, z.debe, z.haber, ;
	Iif((z.debe + z.adeudor) > (z.haber + z.aacreedor), (z.debe + z.adeudor) - (z.haber + z.aacreedor), 000000000.00) As deudor, ;
	Iif((z.haber + z.aacreedor) > (z.debe + z.adeudor), (z.haber + z.aacreedor) - (z.debe + z.adeudor), 000000000.00) As acreedor, idcta From mayor As z Into Cursor mayor Order By z.ncta
Select * From mayor Into Cursor xdctas
Return
Endfunc
***************************************************
Procedure GeneraBalanceComprobacionPLE5(np1, np2, Na)
*:Global cr1, cruta, nl, sid, sih
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
Select ctasunat As nctas, Round(Sum(adeudor), 0) As adeudor, Round(Sum(aacreedor), 0) As aacreedor, Round(Sum(debe), 0) As debe, Round(Sum(haber), 0) As haber, Round(debet, 0) As debet, ;
	Round(habert, 0) As habert, 0 As rpnperdida, 0 As rpnganancia;
	From rld Where !Empty(ctasunat) And Left(ctasunat, 1) <> '9' And  Left(ctasunat, 2) <> '79' Into Cursor lreg Group By ctasunat
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If Left(nctas, 1) = '6' Or Left(nctas, 1) = '7'
		sid	= ""
		sih	= ""
	Else
		sid	= Alltrim(Str(adeudor))
		sih	= Alltrim(Str(aacreedor))
	Endif
	If nl = 0 Then

          \\<<nctas>>|<<sid>>|<<sih>>|<<debe>>|<<haber>>|<<debet>>|<<habert>>|<<rpnperdida>>|<<rpnganancia>>|
	Else
           \<<nctas>>|<<sid>>|<<sih>>|<<debe>>|<<haber>>|<<debet>>|<<habert>>|<<rpnperdida>>|<<rpnganancia>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endproc
****************************************************
Procedure ConsultarCPE
Lparameters LcRucEmisor, lcUser_Sol, lcPswd_Sol, ctipodcto, Cserie, cnumero, pk, mostramensaje

Local ArchivoRespuestaSunat As "MSXML2.DOMDocument.6.0"
Local loXMLBody As "MSXML2.DOMDocument.6.0"
Local loXMLResp As "MSXML2.DOMDocument.6.0"
Local loXmlHttp As "MSXML2.ServerXMLHTTP.6.0"
Local oShell As "Shell.Application"
Local res As "MSXML2.DOMDocument.6.0"
Local lcEnvioXML, lcURL, lcUserName, lsURL, ls_pwd_sol, ls_ruc_emisor, ls_user
*:Global CMensaje1, CMensajeMensaje, CMensajedetalle, CmensajeError, Cnumeromensaje, TxtB64
*:Global cDirDesti, cdrxml, cerror, cfilecdr, cfilerpta, cnombre, cnum, cpropiedad, crespuesta
*:Global crpta, oArchi, rptaSunat, txtCod, txtMsg
Declare Integer CryptBinaryToString In Crypt32;
	String @pbBinary, Long cbBinary, Long dwFlags, ;
	String @pszString, Long @pcchString

Declare Integer CryptStringToBinary In Crypt32;
	String @pszString, Long cchString, Long dwFlags, ;
	String @pbBinary, Long @pcbBinary, ;
	Long pdwSkip, Long pdwFlags

#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056
cpropiedad = "ose"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("ose", "")
Endif

cpropiedad = "Grabarxmlbd"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("Grabarxmlbd", "")
Endif



loXmlHttp  = Createobject("MSXML2.ServerXMLHTTP.6.0")
loXMLBody  = Createobject("MSXML2.DOMDocument.6.0")
crespuesta = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc) + '-' + ctipodcto + '-' + Cserie + '-' + cnumero + '.zip'
If !Empty(goApp.ose) Then
	Do Case
	Case goApp.ose = "nubefact"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://demo-ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'moddatos'
			ls_user		  = ls_ruc_emisor + 'MODDATOS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
		Text To lcEnvioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
		   <soapenv:Envelope xmlns:ser="http://service.sunat.gob.pe" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
					xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
		   <soapenv:Header>
				<wsse:Security>
					<wsse:UsernameToken>
							<wsse:Username><<ls_user>></wsse:Username>
			                <wsse:Password><<ls_pwd_sol>></wsse:Password>
					</wsse:UsernameToken>
				</wsse:Security>
			</soapenv:Header>
		   <soapenv:Body>
		      <ser:getStatusCdr>
		         <rucComprobante><<LcRucEmisor>></rucComprobante>
		         <tipoComprobante><<ctipodcto>></tipoComprobante>
		         <serieComprobante><<cserie>></serieComprobante>
				 <numeroComprobante><<cnumero>></numeroComprobante>
		      </ser:getStatusCdr>
		   </soapenv:Body>
		</soapenv:Envelope>
		Endtext
		If Not loXMLBody.LoadXML( lcEnvioXML )
			Error loXMLBody.parseError.reason
			Return - 1
		Endif
		loXmlHttp.Open( "POST", lsURL, .F. )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
		loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
		loXmlHttp.setRequestHeader( "SOAPAction", "getStatusCdr" )
		loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
		loXmlHttp.Send(loXMLBody.documentElement.XML)
		If loXmlHttp.Status # 200 Then
			cerror	  = Nvl(loXmlHttp.responseText, '')
			crpta	  = Strextract(cerror, '<faultstring>', '</faultstring>', 1)
			CMensaje1 = Strextract(cerror, "<message>", "</message>", 1)
			If Vartype(mostramensaje) = 'L'
				Messagebox(crpta + ' ' + Alltrim(CMensaje1), 16, MSGTITULO)
			Endif
			Return - 1
		Endif
		loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
		loXMLResp.LoadXML(loXmlHttp.responseText)
		CmensajeError	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultcode>", "</faultcode>")
		CMensajeMensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultstring>", "</faultstring>")
		CMensajedetalle	= leerXMl(Alltrim(loXmlHttp.responseText), "<detail>", "</detail>")
		Cnumeromensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<statusCode>", "</statusCode>")
		CMensaje1		= leerXMl(Alltrim(loXmlHttp.responseText), "<message>", "</message>")
		If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Or Cnumeromensaje <> '0' Then
			If Vartype(mostramensaje) = 'L'
				Messagebox((Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle) + ' ' + Alltrim(CMensaje1)), 16, MSGTITULO)
			Endif
			Return 0
		Endif
		ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
		ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
		TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//content")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
	Case goApp.ose = "bizlinks"
		loXmlHttp = Createobject("MSXML2.XMLHTTP.6.0")
		loXMLBody = Createobject("MSXML2.DOMDocument.6.0")
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://osetesting.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'TESTBIZLINKS'
			ls_user		  = Alltrim(fe_gene.nruc) + 'BIZLINKS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
		cnum = Right("00000000" + Alltrim(cnumero), 8)
		Text To lcEnvioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe">
		<SOAP-ENV:Header xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
		<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
		<wsse:UsernameToken>
	    <wsse:Username><<ls_user>></wsse:Username>
		<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText"><<ls_pwd_sol>></wsse:Password></wsse:UsernameToken>
		</wsse:Security>
		</SOAP-ENV:Header>
		   <soapenv:Body>
		      <ser:getStatusCdr>
		         <!--Optional:-->
		         <statusCdr>
		            <!--Optional:-->
		             <numeroComprobante><<cnum>></numeroComprobante>
		            <!--Optional:-->
		             <rucComprobante><<LcRucEmisor>></rucComprobante>
		            <!--Optional:-->
		             <serieComprobante><<cserie>></serieComprobante>
		            <!--Optional:-->
		            	 <tipoComprobante><<ctipodcto>></tipoComprobante>
		         </statusCdr>
		      </ser:getStatusCdr>
		   </soapenv:Body>
		</soapenv:Envelope>
		Endtext
		If Not loXMLBody.LoadXML( lcEnvioXML )
			Error loXMLBody.parseError.reason
			Return - 1
		Endif

		loXmlHttp.Open( "POST", lsURL, .F. )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
		loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
		loXmlHttp.setRequestHeader( "SOAPAction", "urn:getStatusCdr" )
*loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
		loXmlHttp.Send(loXMLBody.documentElement.XML)
		If loXmlHttp.Status # 200 Then
			cerror	  = Nvl(loXmlHttp.responseText, '')
			crpta	  = Strextract(cerror, '<faultstring>', '</faultstring>', 1)
			CMensaje1 = Strextract(cerror, "<detail>", "</detail>", 1)
			Messagebox(crpta + ' ' + Alltrim(CMensaje1), 16, MSGTITULO)
			Return - 1
		Endif
		loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
		loXMLResp.LoadXML(loXmlHttp.responseText)
		CmensajeError	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultcode>", "</faultcode>")
		CMensajeMensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultstring>", "</faultstring>")
		CMensajedetalle	= leerXMl(Alltrim(loXmlHttp.responseText), "<detail>", "</detail>")
		Cnumeromensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<statusCode>", "</statusCode>")
		CMensaje1		= leerXMl(Alltrim(loXmlHttp.responseText), "<statusMessage>", "</statusMessage>")
		If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Then
			If Vartype(mostramensaje) = 'L'
				Messagebox((Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle) + ' ' + Alltrim(CMensaje1)), 16, 'Sisven')
			Endif
			Return 0
		Endif
		ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
		ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
		TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//document")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
	Case goApp.ose = "efact"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL   = "https://ose-gw1.efact.pe/ol-ti-itcpe/billService"
* "https://ose.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'iGje3Ei9GN'
			ls_user		  = ls_ruc_emisor
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
		Text To lcEnvioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe">
		  <soapenv:Header>
		   <wsse:Security soapenv:mustUnderstand="0" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
		      <wsse:UsernameToken>
		       <wsse:Username><<ls_user>></wsse:Username>
			   <wsse:Password><<ls_pwd_sol>></wsse:Password>
		      </wsse:UsernameToken>
		   </wsse:Security>
		   </soapenv:Header>
		   <soapenv:Body>
		      <ser:getStatusCdr>
		             <rucComprobante><<LcRucEmisor>></rucComprobante>
			       	 <tipoComprobante><<ctipodcto>></tipoComprobante>
			      	 <serieComprobante><<cserie>></serieComprobante>
			         <numeroComprobante><<cnumero>></numeroComprobante>
		      </ser:getStatusCdr>
		   </soapenv:Body>
		</soapenv:Envelope>
		Endtext
		If Not loXMLBody.LoadXML( lcEnvioXML )
			Error loXMLBody.parseError.reason
			Return - 1
		Endif

		loXmlHttp.Open( "POST", lsURL, .F. )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
		loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
		loXmlHttp.setRequestHeader( "SOAPAction", "urn:getStatusCdr" )
		loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
		loXmlHttp.Send(loXMLBody.documentElement.XML)
		If loXmlHttp.Status # 200 Then
			cerror	  = Nvl(loXmlHttp.responseText, '')
			crpta	  = Strextract(cerror, '<faultstring>', '</faultstring>', 1)
			CMensaje1 = Strextract(cerror, "<detail>", "</detail>", 1)
			Messagebox(crpta + ' ' + Alltrim(CMensaje1), 16, MSGTITULO)
			Return - 1
		Endif
		loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
		loXMLResp.LoadXML(loXmlHttp.responseText)
		CmensajeError	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultcode>", "</faultcode>")
		CMensajeMensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultstring>", "</faultstring>")
		CMensajedetalle	= leerXMl(Alltrim(loXmlHttp.responseText), "<detail>", "</detail>")
		Cnumeromensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<statusCode>", "</statusCode>")
		CMensaje1		= leerXMl(Alltrim(loXmlHttp.responseText), "<statusMessage>", "</statusMessage>")
		If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Then
			If Vartype(mostramensaje) = 'L'
				Messagebox((Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle) + ' ' + Alltrim(CMensaje1)), 16, 'Sisven')
			Endif
			Return 0
		Endif
		ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
		ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
		TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//document")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
	Case goApp.ose = "conastec"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://test.conose.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'moddatos'
			ls_user		  = ls_ruc_emisor + 'MODDATOS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://prod.conose.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
		Text To lcEnvioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe">
		  <soapenv:Header>
			<wsse:Security   xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
			<wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
			<wsse:Username><<ls_user>></wsse:Username>
			<wsse:Password><<ls_pwd_sol>></wsse:Password>
			</wsse:UsernameToken>
			</wsse:Security>
			</soapenv:Header>
			   <soapenv:Body>
			      <ser:getStatusCdr>
			         <!--Optional:-->
			         <rucComprobante><<LcRucEmisor>></rucComprobante>
			         <!--Optional:-->
			       	 <tipoComprobante><<ctipodcto>></tipoComprobante>
			         <!--Optional:-->
			      	 <serieComprobante><<cserie>></serieComprobante>
			         <numeroComprobante><<cnumero>></numeroComprobante>
			      </ser:getStatusCdr>
			   </soapenv:Body>
			</soapenv:Envelope>
		Endtext
		If Not loXMLBody.LoadXML( lcEnvioXML )
			Error loXMLBody.parseError.reason
			Return - 1
		Endif
		loXmlHttp.Open( "POST", lsURL, .F. )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
		loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
		loXmlHttp.setRequestHeader( "SOAPAction", "urn:getStatusCdr" )
		loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )

		loXmlHttp.Send(loXMLBody.documentElement.XML)
		If loXmlHttp.Status # 200 Then
			cerror = Nvl(loXmlHttp.responseText, '')
			crpta  = Strextract(cerror, '<faultstring>', '</faultstring>', 1)
			Messagebox(crpta, 16, MSGTITULO)
			Return - 1
		Endif
		loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
		loXMLResp.LoadXML(loXmlHttp.responseText)
		CmensajeError	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultcode>", "</faultcode>")
		CMensajeMensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultstring>", "</faultstring>")
		CMensajedetalle	= leerXMl(Alltrim(loXmlHttp.responseText), "<detail>", "</detail>")
		Cnumeromensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<statusCode>", "</statusCode>")
		CMensaje1		= leerXMl(Alltrim(loXmlHttp.responseText), "<statusMessage>", "</statusMessage>")
		If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Or Cnumeromensaje <> '0004' Then
			If Vartype(mostramensaje) = 'L'
				Messagebox((Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle) + ' ' + Alltrim(CMensaje1)), 16, 'Sisven')
			Endif
			Return 0
		Endif
		ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
		ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
		TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//content")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
	Endcase
	crptaxmlcdr = 'R-' + Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc) + '-' + ctipodcto + '-' + Cserie + '-' + cnumero + '.XML'
	If Type('oempresa') = 'U' Then
		cnombre	  = Addbs(Sys(5) + Sys(2003) + '\SunatXml') + crespuesta
		cDirDesti = Addbs( Sys(5) + Sys(2003) + '\SunatXML')
		cfilerpta = Addbs( Sys(5) + Sys(2003) + '\SunatXML') + crptaxmlcdr
	Else
		cnombre	  = Addbs(Sys(5) + Sys(2003) + '\SunatXml\' + Alltrim(Oempresa.nruc)) + crespuesta
		cDirDesti = Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc))
		cfilerpta = Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc)) + crptaxmlcdr
	Endif
	If !Directory(cDirDesti) Then
		Md (cDirDesti)
	Endif
	If File(cfilerpta) Then
		Delete File(cfilerpta)
	Endif
	If Vartype(TxtB64) <> 'O' Then
		Aviso('No se Puede leer la Respuesta de Env�o')
		Return 0
	Endif
	decodefile(TxtB64.Text, cnombre)
	oShell	  = Createobject("Shell.Application")
	cfilerpta = "R"
	For Each oArchi In oShell.NameSpace(cnombre).Items
		If Left(oArchi.Name, 1) = 'R' Then
			oShell.NameSpace(cDirDesti).CopyHere(oArchi)
			cfilerpta = Juststem(oArchi.Name) + '.XML'
		Endif
	Endfor
	If Type('oempresa') = 'U' Then
		rptaSunat = LeerRespuestaSunat(Sys(5) + Sys(2003) + '\SunatXML\' + cfilerpta)
		cfilecdr  = Sys(5) + Sys(2003) + '\SunatXML\' + cfilerpta
	Else
		rptaSunat = LeerRespuestaSunat(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\" + cfilerpta)
		cfilecdr  = Sys(5) + Sys(2003) + '\SunatXML\' + + Alltrim(Oempresa.nruc) + "\" + cfilerpta
	Endif
	If Len(Alltrim(rptaSunat)) > 100 Then
		Messagebox(rptaSunat, 64, MSGTITULO)
		Return 0
	Endif
	Do Case
	Case Left(rptaSunat, 1) = '0'
		cpropiedad = "Grabarxmlbd"
		If !Pemstatus(goApp, cpropiedad, 5)
			goApp.AddProperty("Grabarxmlbd", "")
		Endif
		If goApp.Grabarxmlbd = 'S' Then
			cdrxml = Filetostr(cfilecdr)
			cdrxml  =  ""
			Text  To lC Noshow
            UPDATE fe_rcom SET rcom_mens=?rptaSunat,rcom_cdr=?cdrxml WHERE idauto=?pk
			Endtext
		Else
			Text  To lC Noshow
            UPDATE fe_rcom SET rcom_mens=?rptaSunat WHERE idauto=?pk
			Endtext
		Endif
		If SQLExec(goApp.bdConn, lC) < 0 Then
			Errorbd(lC)
			Return 0
		Endif
		Mensaje(rptaSunat)
		Return 1
	Case Empty(rptaSunat)
		If Vartype(mostramensaje) = 'L' Then
			Messagebox(rptaSunat, 64, 'Sisven')
		Endif
		Return 0
	Otherwise
		If Vartype(mostramensaje) = 'L' Then
			Messagebox(rptaSunat, 64, 'Sisven')
		Endif
		Return 0
	Endcase
Else
	lcUserName = LcRucEmisor + lcUser_Sol
	lcURL	   = "https://www.sunat.gob.pe/ol-it-wsconscpegem/billConsultService"

	Text To lcEnvioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
	<soapenv:Envelope xmlns:ser="http://service.sunat.gob.pe"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
	<soapenv:Header>
	<wsse:Security>
	<wsse:UsernameToken>
	<wsse:Username><<lcUsername>></wsse:Username>
	<wsse:Password><<lcPswd_Sol>></wsse:Password>
	</wsse:UsernameToken>
	</wsse:Security>
	</soapenv:Header>
	<soapenv:Body>
	<ser:getStatus>
	<rucComprobante><<LcRucEmisor>></rucComprobante>
	<tipoComprobante><<ctipodcto>></tipoComprobante>
	<serieComprobante><<cserie>></serieComprobante>
	<numeroComprobante><<cnumero>></numeroComprobante>
	</ser:getStatus>
	</soapenv:Body>
	</soapenv:Envelope>
	Endtext

	If Not loXMLBody.LoadXML( lcEnvioXML )
		Error loXMLBody.parseError.reason
		Return - 1
	Endif

	loXmlHttp.Open( "POST", lcURL, .F. )
	loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
	loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" )
	loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
	loXmlHttp.setRequestHeader( "SOAPAction", "getStatus" )
	loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )

	loXmlHttp.Send(loXMLBody.documentElement.XML)
*?loXmlHttp.Status
	If loXmlHttp.Status # 200 Then
		cerror = Nvl(loXmlHttp.responseText, '')
		crpta  = Strextract(cerror, '<faultstring>', '</faultstring>', 1)
		Messagebox(crpta, 16, MSGTITULO)
		Return - 1
	Endif
	res = Createobject("MSXML2.DOMDocument.6.0")
	res.LoadXML(loXmlHttp.responseText)
	txtCod = res.selectSingleNode("//statusCode")  &&Return
	txtMsg = res.selectSingleNode("//statusMessage")  &&Return
	If txtCod.Text = "0001"  Then
		Mensaje(txtMsg.Text)
		Return  1
	Else
		Mensaje(txtMsg.Text)
		Return  - 1
	Endif
Endif
Endproc
*************************************
Function GeneraPle5Activos(np1, np2, Na)
*:Global cp, cr1, cruta, nl
Cruta = Addbs(Justpath(np1)) + np2
cr1	  = Cruta + '.txt'
cp	  = Alltrim(Na) + '0000'
Select cp As p, ;
	Alltrim(Str(ID0)) As IDx, ;
	Alltrim('M' + Alltrim(Str(ID0))) As esta, ;
	tabla13 As t13, ;
	Alltrim(Alltrim(Str(ID1))) As cod1, ;
	Codigo As Cod, ;
	tabla18 As t18, ;
	Left(cuenta, 2) + Substr(cuenta, 4, 2) + Substr(cuenta, 7, 2) As cta, ;
	tabla19 As t19, ;
	Alltrim(Descripcion) As Descr, ;
	Iif(Empty(marca), '-', marca) As marca, ;
	Iif(Empty(Modelo), '-', Modelo) As Modelo, ;
	Iif(Empty(Placa), '-', Placa) As Placa, ;
	Saldo_inicial As Ini, ;
	Valor_Adquirido As Vadq, ;
	Mejoras As Mej, ;
	Retiros As Ret, ;
	Ajustes As Aju, ;
	ValorRevaluacion As VRR, ;
	RevaluacionRS As RRS, ;
	OtrasRevaluaciones As Oreval, ;
	AjusteInflacion As Ainf, ;
	FechaAdquisicion As Fadq, ;
	FechaUso As Fuso, ;
	Tabla20 As t20, ;
	dcto, ;
	PorcentajeDep As PorDep, ;
	DepreacicionAcumulada As DAc, ;
	valorDepreciacion As Vdep, ;
	DepreciacionRetiros As DRet, ;
	DepreciacionOtrosAjustes As dj, ;
	DepreciacionVoluntaria As DVol, ;
	DepreciacionPorSociedades As DSoc, ;
	DepreciacionOtrasRevaluaciones As DOReval, ;
	DepreciacionPorInflacion As di, ;
	1 As e From LdaPLe Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl = 0
Scan
	If nl = 0 Then
      \\<<p>>|<<IDx>>|<<Alltrim(esta)>>|<<t13>>|<<Alltrim(cod1)>>|<<Alltrim(Cod)>>|<<Alltrim(t18)>>|<<cta>>|<<Alltrim(t19)>>|<<Descr>>|<<marca>>|<<Modelo>>|<<Placa>>|<<Ini>>|<<Vadq>>|<<Mej>>|<<Ret>>|<<Aju>>|<<VRR>>|<<RRS>>|<<Oreval>>|<<Ainf>>|<<Fadq>>|<<Fuso>>|<<Alltrim(t20)>>|<<dcto>>|<<PorDep>>|<<DAc>>|<<Vdep>>|<<DRet>>|<<dj>>|<<DVol>>|<<DSoc>>|<<DOReval>>|<<di>>|<<e>>|
	Else
       \<<p>>|<<IDx>>|<<Alltrim(esta)>>|<<t13>>|<<Alltrim(cod1)>>|<<Alltrim(Cod)>>|<<Alltrim(t18)>>|<<cta>>|<<Alltrim(t19)>>|<<Descr>>|<<marca>>|<<Modelo>>|<<Placa>>|<<Ini>>|<<Vadq>>|<<Mej>>|<<Ret>>|<<Aju>>|<<VRR>>|<<RRS>>|<<Oreval>>|<<Ainf>>|<<Fadq>>|<<Fuso>>|<<Alltrim(t20)>>|<<dcto>>|<<PorDep>>|<<DAc>>|<<Vdep>>|<<DRet>>|<<dj>>|<<DVol>>|<<DSoc>>|<<DOReval>>|<<di>>|<<e>>|
	Endif
	nl = nl + 1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*************************************
Function IngresaDatosDiarioPle55(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18)
Local lC, lp
*:Global cur
cur			  = "l"
lC			  = "FunIngresaDatosLibroDiarioPle55"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
goApp.npara18 = np18
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Ingresando Asientos  a Libro Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************
Function Adjuntar(np1, np2, np3)
Local lC
*:Global car
car = Sys(5) + Sys(2003) + "\FirmaXML\" + Alltrim(fe_gene.nruc) + "-" + Alltrim(np3) + "-" + Left(np2, 4) + '-' + Alltrim(Substr(np2, 5)) + ".xml"
If File((car)) Then
	Text To lC Noshow Textmerge
      UPDATE fe_rcom SET rcom_arch='<<car>>' WHERE idauto=<<np1>>
	Endtext
	If Ejecutarsql(lC) < 1 Then
		Return
	Endif
	Mensaje("Adjuntado")
	Return Justfname(car)
Else
	Mensaje("NO Adjuntado")
	Return ""
Endif
Endfunc
*******************************
Function AdjuntarM(np1, np2, np3)
Local lC
*:Global car, car1
car1 = Sys(5) + Sys(2003) + "\FirmaXML\" + Alltrim(fe_gene.nruc) + "-" + Alltrim(np3) + "-" + Left(np2, 4) + '-' + Alltrim(Substr(np2, 5)) + ".xml"
If File(car1) Then
	car = car1
Else
	car = Sys(5) + Sys(2003) + "\FirmaXML\" + Alltrim(Oempresa.nruc) + "\" + Alltrim(fe_gene.nruc) + "-" + Alltrim(np3) + "-" + Left(np2, 4) + '-' + Alltrim(Substr(np2, 5)) + ".xml"
Endif
If File((car)) Then
	Text To lC Noshow Textmerge
     UPDATE fe_rcom SET rcom_arch='<<car>>' WHERE idauto=<<np1>>
	Endtext
	If Ejecutarsql(lC) < 1 Then
		Return
	Endif
	Mensaje("Adjuntado")
	Return Justfname(car)
Else
	Mensaje("NO Adjuntado")
	Return ""
Endif
Endfunc
***********************
********************************************************************
********************************************************************
*!* FUNCTION Exp2Excel( [cCursor, [cFileSave, [cTitulo]]] )
*!*
*!* Exporta un Cursor de Visual FoxPro a Excel, utilizando la
*!* t�cnica de importaci�n de datos externos en modo texto.
*!*
*!* PARAMETROS OPCIONALES:
*!* - cCursor  Alias del cursor que se va a exportar.
*!*            Si no se informa, utiliza el alias
*!*            en que se encuentra.
*!*
*!* - cFileName  Nombre del archivo que se va a grabar.
*!*              Si no se informa, muestra el libro generado
*!*              una vez conclu�da la exportaci�n.
*!*
*!* - cTitulo  Titulo del informe. Si se informa, este
*!*            ocupar�a la primera file de cada hoja del libro.
********************************************************************
********************************************************************
Function Exp3Excel( Ccursor, cFileSave, cTitulo )

Local cwarning
Local oExcel As "Excel.Application"
Local lcCampo, lcName
*:Global acampos[1], oconnection, xlsheet
If Empty(Ccursor)
	Ccursor = Alias()
Endif
If Type('cCursor') # 'C' Or !Used(Ccursor)
	Messagebox("Par�metros Inv�lidos", 16, _vfp.msgbox_error)
	Return .F.
Endif
*********************************
*** Creaci�n del Objeto Excel ***
*********************************
*Wait Window 'Abriendo aplicaci�n Excel.' Nowait Noclear
Mensaje('Abriendo aplicaci�n Excel.')
oExcel = Createobject("Excel.Application")
Wait Clear

If Type('oExcel') # 'O'
	Messagebox("No se puede procesar el archivo porque no tiene la aplicaci�n" ;
		  + Chr(13) + "Microsoft Excel instalada en su computadora.", 16, _vfp.msgbox_error)
	Return .F.
Endif

oExcel.WorkBooks.Add

Local lnRecno, lnPos, lnPag, lnCuantos, lnRowTit, lnRowPos, i, lnHojas, cDefault

cDefault = Addbs(Sys(5)  + Sys(2003))

Select (Ccursor)
If Eof()
	lnRecno = 0
Else
	lnRecno = Recno(Ccursor)
Endif
Go Top

*************************************************
*** Verifica la cantidad de hojas necesarias  ***
*** en el libro para la cantidad de datos     ***
*************************************************
lnHojas = Round(Reccount(Ccursor) / 65000, 0)
Do While oExcel.Sheets.Count < lnHojas
	oExcel.Sheets.Add
Enddo

lnPos = 0
lnPag = 0

Do While lnPos < Reccount(Ccursor)

	lnPag = lnPag + 1 && Hoja que se est� procesando

*Wait Windows 'Exportando datos a Excel...' Noclear Nowait
	Mensaje("Exportando datos a Excel...")
	If File(cDefault  + Ccursor  + ".txt")
		Delete File (cDefault  + Ccursor  + ".txt")
	Endif

	Copy  Next 65000 To (cDefault  + Ccursor  + ".txt") Delimited With Character ";"
	lnPos = Recno(Ccursor)

	oExcel.Sheets(lnPag).Select

	XLSheet		 = oExcel.ActiveSheet
	XLSheet.Name = Ccursor + '_' + Alltrim(Str(lnPag))

	lnCuantos = Afields(aCampos, Ccursor)

********************************************************
*** Coloca t�tulo del informe (si este es informado) ***
********************************************************
	If !Empty(cTitulo)
		XLSheet.Cells(1, 1).Font.Name = "Arial"
		XLSheet.Cells(1, 1).Font.Size = 12
		XLSheet.Cells(1, 1).Font.Bold = .T.
		XLSheet.Cells(1, 1).Value = cTitulo
		XLSheet.Range(XLSheet.Cells(1, 1), XLSheet.Cells(1, lnCuantos)).MergeCells = .T.
		XLSheet.Range(XLSheet.Cells(1, 1), XLSheet.Cells(1, lnCuantos)).Merge
		XLSheet.Range(XLSheet.Cells(1, 1), XLSheet.Cells(1, lnCuantos)).HorizontalAlignment = 3
		lnRowPos = 3
	Else
		lnRowPos = 2
	Endif

	lnRowTit = lnRowPos - 1
**********************************
*** Coloca t�tulos de Columnas ***
**********************************
	For i = 1 To lnCuantos
		lcName	= aCampos(i, 1)
		lcCampo	= Alltrim(Ccursor) + '.' + aCampos(i, 1)
		XLSheet.Cells(lnRowTit, i).Value = lcName
		XLSheet.Cells(lnRowTit, i).Font.Bold = .T.
		XLSheet.Cells(lnRowTit, i).Interior.ColorIndex = 15
		XLSheet.Cells(lnRowTit, i).Interior.Pattern = 1
		XLSheet.Range(XLSheet.Cells(lnRowTit, i), XLSheet.Cells(lnRowTit, i)).BorderAround(7)
	Next

	XLSheet.Range(XLSheet.Cells(lnRowTit, 1), XLSheet.Cells(lnRowTit, lnCuantos)).HorizontalAlignment = 3

*************************
*** Cuerpo de la hoja ***
*************************
	oConnection = XLSheet.QueryTables.Add("TEXT;"  + cDefault  + Ccursor  + ".txt", ;
		  XLSheet.Range("A"  + Alltrim(Str(lnRowPos))))

	With oConnection
		.Name						  = Ccursor
		.FieldNames					  = .T.
		.RowNumbers					  = .F.
		.FillAdjacentFormulas		  = .F.
		.PreserveFormatting			  = .T.
		.RefreshOnFileOpen			  = .F.
		.RefreshStyle				  = 1 && xlInsertDeleteCells
		.SavePassword				  = .F.
		.SaveData					  = .T.
		.AdjustColumnWidth			  = .T.
		.RefreshPeriod				  = 0
		.TextFilePromptOnRefresh	  = .F.
		.TextFilePlatform			  = 850
		.TextFileStartRow			  = 1
		.TextFileParseType			  = 1 && xlDelimited
		.TextFileTextQualifier		  = 1 && xlTextQualifierDoubleQuote
		.TextFileConsecutiveDelimiter = .F.
		.TextFileTabDelimiter		  = .F.
		.TextFileSemicolonDelimiter	  = .T.
		.TextFileCommaDelimiter		  = .F.
		.TextFileSpaceDelimiter		  = .F.
		.TextFileTrailingMinusNumbers = .T.
		.Refresh
	Endwith

	XLSheet.Range(XLSheet.Cells(lnRowTit, 1), XLSheet.Cells(XLSheet.Rows.Count, lnCuantos)).Font.Name = "Arial"
	XLSheet.Range(XLSheet.Cells(lnRowTit, 1), XLSheet.Cells(XLSheet.Rows.Count, lnCuantos)).Font.Size = 10

	XLSheet.Columns.AutoFit
	XLSheet.Cells(lnRowPos, 1).Select
	oExcel.ActiveWindow.FreezePanes = .T.

	Wait Clear

Enddo
*********************************
Function leerXMl(lcXML, ctagi, ctagf)
Local lnCount As Integer
Local lnI
*:Global cvalor
cvalor = ""
For lnI = 1 To Occurs(ctagi, lcXML)
	cvalor = Strextract(lcXML, ctagi, ctagf, lnI)
Next lnI
Return cvalor
Endfunc
***************************************
Function VerificaArchivoRespuesta(cFile, crpta, cticket)
*:Global car, car1, cruta, npos
If !File(cFile) Then
	Return cFile
Endif
Return cFile
car	  = ""
npos  = At("-", crpta, 3)
Cruta = Justpath(cFile)
car	  = Substr(crpta, 1, At('.', crpta) - 1)
Do While .T.
	generaCorrelativoEnvioResumenBoletas()
	goApp.datosg = ''
	dATOSGLOBALES()
	car1  = Stuff(car, npos + 1, 3, Alltrim(Str(fe_gene.gene_nres)))
	cFile = Addbs(Alltrim(Cruta)) + Alltrim(car1) + '.zip'
	If !File(cFile)
		ActualizarArchivoEnvio(cticket)
		Exit
	Endif
Enddo
Return cFile
Endfunc
************************
Procedure ActualizarArchivoEnvio(cFile, cticket)
Local lC
Text To lC Noshow
   UPDATE fe_resboletas SET resu_arch=?cfile WHERE resu_tick=?cticket
Endtext
If SQLExec(goApp.bdConn, lC) < 0 Then
	Errorbd(lC)
Endif
Endproc
************************
Function  ActualizaBxb
Lparameters ndesde, nhasta
Local lC
*:Global np1, np3, sw
Text To lC Noshow
	Select  idauto,	numero From(Select  idauto,	ndoc,Cast(mid(ndoc, 5) As unsigned) As numero
	From fe_rcom f Where Acti = 'A'	And idcliente > 0) As x Where numero Between ?ndesde And ?nhasta
Endtext
If SQLExec(goApp.bdConn, lC, 'crb') < 0 Then
	Errorbd(lC)
	Return
Endif
np3	= "0 El Resumen de Boletas ha sido aceptado"
Sw	= 1
Select crb
Go Top
Scan All
	np1 = crb.Idauto
	Text  To lC Noshow
           UPDATE fe_rcom SET rcom_mens=?np3 WHERE idauto=?np1
	Endtext
	If SQLExec(goApp.bdConn, lC) < 0 Then
		Errorbd(lC)
		Sw = 0
	Endif
Endscan
Return Sw
Endproc
********************************
Procedure ReimprimirStandarComoTicket(np1, np2, np3)
Local lC
*:Global cdeta1, chash, cmone, cndoc, ctdoc, cx, ncon, nf, nimpo, vvigv
If VerificaAlias("tmpv") = 0 Then
	Create Cursor tmpv(coda N(8), Desc c(120), Unid c(15), Prec N(13, 8), cant N(10, 2), Ndoc c(12), alma N(10, 2), Peso N(10, 2), ;
		  Impo N(10, 2), tipro c(1), ptoll c(50), fect d, perc N(5, 2), cletras c(120), Tdoc c(2), ;
		  nruc c(11), razon c(120), Direccion c(190), fech d, fechav d, Ndo2 c(12), Vendedor c(50), Forma c(20), Form c(20), Guia c(15), duni c(15), ;
		  Referencia c(120), hash c(30), dni c(8), Mone c(1), Tdoc1 c(2), dcto c(12), fech1 d, Usuario c(30), Tigv N(5, 3), Detalle c(120), contacto c(120), Archivo c(120))
Else
	Zap In tmpv
Endif

Do Case
Case np2 = '01' Or np2 = '03'
	cx = ""
	If  Vartype(np3) = 'C' Then
		cx = np3
	Endif
	If cx = 'S' Then
		Text To lC Noshow
				  Select  4 As codv, c.idauto, 1 As idart,
						  ifnull(A.cant, 1) As cant,
						  ifnull(A.Prec, 0) As Prec,
						  c.codt As alma,
						  c.tdoc As tdoc1,
						  c.ndoc As dcto,
						  c.fech As fech1,
						  c.vigv,
						  c.fech,
						  c.fecr,
						  c.
							Form, c.rcom_exon,
						  c.ndo2,
						  c.igv,
						  c.idcliente,
						  d.razo,
						  d.nruc,
						  d.Dire,
						  d.ciud,
						  d.ndni,
						  c.pimpo,
						  u.nomb As usuario,
						  c.Deta,
						  c.tdoc,
						  c.ndoc,
						  c.dolar As dola,
						  c.Mone,
						  "" As Descri,
						  '' As unid,
						  c.rcom_hash,
						  'Oficina' As nomv,
						  c.Impo
					  From fe_rcom As c
					  Left Join fe_kar As A
						  On(A.idauto = c.idauto)
					  inner Join fe_clie As d
						  On(d.idclie = c.idcliente)
					  inner Join fe_usua As u
						  On u.idusua = c.idusua
					  Where c.idauto = ?np1
					  Union All
					  Select  4 As codv,
						  c.idauto,
						  0 As idart,
						  1 As cant,
						  Impo As Prec,
						  c.codt As alma,
						  c.tdoc As tdoc1,
						  c.ndoc As dcto,
						  c.fech As fech1,
						  c.vigv,
						  c.fech,
						  c.fecr,
						  c.
							Form, c.rcom_exon,
						  c.ndo2,
						  c.igv,
						  c.idcliente,
						  d.razo,
						  d.nruc,
						  d.Dire,
						  d.ciud,
						  d.ndni,
						  c.pimpo,
						  u.nomb As usuario,
						  c.Deta,
						  c.tdoc,
						  c.ndoc,
						  c.dolar As dola,
						  c.Mone,
						  m.detv_desc As Descri,
						  '' As unid,
						  c.rcom_hash,
						  'Oficina' As nomv,
						  c.Impo
					  From fe_rcom As c
					  inner Join fe_clie As d
						  On(d.idclie = c.idcliente)
					  inner Join fe_usua As u
						  On u.idusua = c.idusua
					  inner Join fe_detallevta As m
						  On m.detv_idau = c.idauto
					  Where c.idauto = ?np1
		Endtext
****

		Text To lC Noshow
				  Select  4 As codv,
						  c.idauto,
						  0 As idart,
						  Cast(1  As Decimal(12, 2)) As cant,
						  If(detv_item = 1, Impo, 0) As Prec,
						  c.codt As alma,
						  c.tdoc As tdoc1,
						  c.ndoc As dcto,
						  c.fech As fech1,
						  c.vigv,
						  c.fech,
						  c.fecr,
						  c.
							Form, c.rcom_exon,
						  c.ndo2,
						  c.igv,
						  c.idcliente,
						  d.razo,
						  d.nruc,
						  d.Dire,
						  d.ciud,
						  d.ndni,
						  c.pimpo,
						  u.nomb As usuario,
						  c.Deta,
						  c.tdoc,
						  c.ndoc,
						  c.dolar As dola,
						  c.Mone,
						  m.detv_desc As Descri,
						  '' As unid,
						  c.rcom_hash,
						  'Oficina' As nomv,
						  c.Impo
					  From fe_rcom As c
					  inner Join fe_clie As d
						  On(d.idclie = c.idcliente)
					  inner Join fe_usua As u
						  On u.idusua = c.idusua
					  inner Join fe_detallevta As m
						  On m.detv_idau = c.idauto
					  Where c.idauto = ?np1
					  Group By Descri
					  Order By detv_ite1
		Endtext
	Else
		Text To lC Noshow
				Select  A.codv,
						A.idauto,
						A.alma,
						A.idkar,
						A.idauto,
						A.idart,
						A.cant,
						A.Prec,
						A.alma,
						c.tdoc As tdoc1,
						c.ndoc As dcto,
						c.fech As fech1,
						c.vigv,
						c.fech,
						c.fecr,
						c.
						  Form, c.Deta,
						c.rcom_exon,
						c.ndo2,
						c.igv,
						c.idcliente,
						d.razo,
						d.nruc,
						d.Dire,
						d.ciud,
						d.ndni,
						c.pimpo,
						u.nomb As usuario,
						c.tdoc,
						c.ndoc,
						c.dolar As dola,
						c.Mone,
						b.Descri,
						b.unid,
						c.rcom_hash,
						v.nomv,
						c.Impo
					From fe_art As b
					Join fe_kar As A
						On(b.idart = A.idart)
					inner Join fe_vend As v
						On v.idven = A.codv
					inner Join fe_rcom As c
						On(A.idauto = c.idauto)
					inner Join fe_clie As d
						On(c.idcliente = d.idclie)
					inner Join fe_usua As u
						On u.idusua = c.idusua
					Where c.idauto = ?np1
						And A.Acti = 'A';
		Endtext
	Endif
Case np2 = '08'
	Text To lC Noshow
			   Select  r.idauto,
					   r.ndoc,
					   r.tdoc,
					   r.fech,
					   r.Mone,
					   Abs(r.valor) As valor,
					   r.ndo2,
					   r.vigv,
					   c.nruc,
					   c.razo,
					   c.Dire,
					   c.ciud,
					   c.ndni,
					   ' ' As nomv,
					   r.Form,
					   Abs(r.igv) As igv,
					   Abs(r.Impo) As Impo,
					   ifnull(k.cant, Cast(0 As Decimal(12, 2))) As cant,
					   ifnull(k.Prec, Abs(r.Impo)) As Prec,
					   Left(r.ndoc, 4) As serie,
					   Substr(r.ndoc, 5) As numero,
					   ifnull(A.unid, '') As unid,
					   ifnull(A.Descri, r.Deta) As Descri,
					   r.Deta,
					   ifnull(k.idart, Cast(0 As Decimal(8))) As idart,
					   w.ndoc As dcto,
					   w.fech As fech1,
					   w.tdoc As tdoc1,
					   r.rcom_hash,
					   u.nomb As usuario
				   From fe_rcom r
				   inner Join fe_clie c
					   On c.idclie = r.idcliente
				   Left Join fe_kar k
					   On k.idauto = r.idauto
				   Left Join fe_art A
					   On A.idart = k.idart
				   inner Join fe_ncven F
					   On F.ncre_idan = r.idauto
				   inner Join fe_rcom As w
					   On w.idauto = F.ncre_idau
				   inner Join fe_usua As u
					   On u.idusua = r.idusua
				   Where r.idauto = ?np1
					   And r.Acti = 'A'
					   And r.tdoc = '08'
	Endtext
Case np2 = '07'
	Text To lC Noshow
			   Select  r.idauto,
					   r.ndoc,
					   r.tdoc,
					   r.fech,
					   r.Mone,
					   Abs(r.valor) As valor,
					   r.ndo2,
					   r.vigv,
					   c.nruc,
					   c.razo,
					   c.Dire,
					   c.ciud,
					   c.ndni,
					   ' ' As nomv,
					   r.
						 Form, u.nomb As usuario,
					   Abs(r.igv) As igv,
					   Abs(r.Impo) As Impo,
					   ifnull(k.cant, Cast(0 As Decimal(12, 2))) As cant,
					   ifnull(k.Prec, Abs(r.Impo)) As Prec,
					   Left(r.ndoc, 4) As serie,
					   Substr(r.ndoc, 5) As numero,
					   ifnull(A.unid, '') As unid,
					   ifnull(A.Descri, r.Deta) As Descri,
					   r.Deta,
					   ifnull(k.idart, Cast(0 As Decimal(8))) As idart,
					   w.ndoc As dcto,
					   w.fech As fech1,
					   w.tdoc As tdoc1,
					   r.rcom_hash
				   From fe_rcom r
				   inner Join fe_clie c
					   On c.idclie = r.idcliente
				   Left Join fe_kar k
					   On k.idauto = r.idauto
				   Left Join fe_art A
					   On A.idart = k.idart
				   inner Join fe_ncven F
					   On F.ncre_idan = r.idauto
				   inner Join fe_rcom As w
					   On w.idauto = F.ncre_idau
				   inner Join fe_usua As u
					   On u.idusua = r.idusua
				   Where r.idauto = ?np1
					   And r.Acti = 'A'
					   And r.tdoc = '07'
	Endtext
Endcase
ncon = AbreConexion()
If SQLExec(ncon, lC, 'kardex') < 0 Then
	Errorbd(lC)
	Return
Endif
CierraConexion(ncon)
nimpo  = Kardex.Impo
cndoc  = Kardex.Ndoc
cmone  = Kardex.Mone
cTdoc  = Kardex.Tdoc
chash  = Kardex.rcom_hash
cdeta1 = Kardex.Deta
vvigv  = Kardex.vigv
nf	   = 0
Select Kardex
Scan All
	nf = nf + 1
	Insert Into tmpv(coda, Desc, Unid, cant, Prec, Ndoc, hash, nruc, razon, Direccion, fech, fechav, Ndo2, Vendedor, Form, ;
		  Referencia, dni, Mone, dcto, Tdoc1, fech1, Usuario, Guia, Forma, Tigv, Tdoc);
		Values(Iif(Vartype(Kardex.idart) = 'N', Kardex.idart, Val(Kardex.idart)), Kardex.Descri, Kardex.Unid, Iif(Kardex.cant = 0, 1, Kardex.cant), Kardex.Prec, ;
		  Kardex.Ndoc, Kardex.rcom_hash, Kardex.nruc, Kardex.Razo, Alltrim(Kardex.Dire) + ' ' + Alltrim(Kardex.ciud), Kardex.fech, Kardex.fech, ;
		  Kardex.Ndo2, Kardex.nomv, Icase(Kardex.Form = 'E', 'Efectivo', Kardex.Form = 'C', 'Cr�dito', Kardex.Form = 'T', 'Tarjeta', Kardex.Form = 'D', 'Dep�sito', 'Cheque'), ;
		  Kardex.Deta, Kardex.ndni, Kardex.Mone, Kardex.dcto, Kardex.Tdoc1, Kardex.fech1, Kardex.Usuario, Kardex.Ndo2, ;
		  Icase(Kardex.Form = 'E', 'Efectivo', Kardex.Form = 'C', 'Cr�dito', Kardex.Form = 'T', 'Tarjeta', Kardex.Form = 'D', 'Dep�sito', 'Cheque'), Kardex.vigv, cTdoc)
Endscan
Local Cimporte
Cimporte = Diletras(nimpo, cmone)
Select tmpv
Replace All Ndoc With cndoc, cletras With Cimporte, Mone With cmone, hash With chash, Referencia With cdeta1, Tigv With vvigv
Go Top In tmpv
Endproc
*************************
Function DevuelveServidorCorreo
Local Ccorreo, clavecorreo
*:Global npos, npos1, sc1
*WAIT WINDOW 'hola'

If Type('oempresa') = 'U' Then
	Ccorreo		= Alltrim(fe_gene.correo)
	clavecorreo	= fe_gene.gene_ccor
Else
	Ccorreo		= Alltrim(Oempresa.correo)
	clavecorreo	= Oempresa.gene_ccor
Endif
If Empty(Ccorreo)  Then
	Return ' '
Endif
npos  = At("@", Ccorreo)
sc1	  = Substr(Ccorreo, npos + 1)
npos1 = At(".", sc1)
Return Substr(sc1, 1, npos1 - 1)
Endfunc
****************************
Function EnviaFacturasNotasAutomatico(Calias, cmulti1, cfracciones, cversion, ctipovtacosta)
Local ocomp As "comprobante"
*:Global cpropiedad, cvtacosta, oerr, vdne
Set Classlib To ("fe") Additive
cvtacosta  = Iif(Type(ctipovtacosta) = 'L', '', ctipovtacosta)
ocomp	   = Createobject("comprobante")
cpropiedad = "Firmarcondll"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("Firmarcondll", "")
Endif
ocomp.FirmarconDLL = goApp.FirmarconDLL
Select * From (Calias) Into Cursor envx
Select envx
Go Top
Do While !Eof()
	ocomp.Cmulti	 = cmulti1
	ocomp.Fracciones = cfracciones
	ocomp.Version	 = cversion
	ocomp.VentaCosta = cvtacosta
	Select envx
	Try
		Do Case
		Case envx.Tdoc = '01'
			If envx.tcom = 'S' Then
				If envx.vigv = 1 Then
					vdne = ocomp.obtenerdatosfacturaexoneradaotros(envx.Idauto)
				Else
					vdne = ocomp.obtenerdatosfacturaotros(envx.Idauto)
				Endif
			Else
				If envx.vigv = 1 Then
					vdne = ocomp.obtenerdatosfacturaexonerada(envx.Idauto)
				Else
					Select envx
					If Fsize("rcom_dsct") > 0
						If envx.rcom_dsct > 0 Then
							vdne = ocomp.obtenerdatosfacturacdescuentosRodi(envx.Idauto)
						Else
							vdne = ocomp.obtenerdatosfactura(envx.Idauto)
						Endif
					Else
						vdne = ocomp.obtenerdatosfactura(envx.Idauto)
					Endif
				Endif
			Endif
		Case envx.Tdoc = '07'
			If envx.tcom = 'S' Then
				ocomp.tipoventanotacredito = 'S'
			Else
				ocomp.tipoventanotacredito = ""
			Endif
			If envx.vigv = 1 Then
				vdne = ocomp.Obtenerdatosnotecreditoexonerada(envx.Idauto, 'E')
			Else
				vdne = ocomp.obtenerdatosnotascredito(envx.Idauto, 'E')
			Endif
		Case envx.Tdoc = '08'
			If envx.vigv = 1 Then
				vdne = ocomp.obtenernotasdebitoexonerada(envx.Idauto, 'E')
			Else
				vdne = ocomp.obtenerdatosnotasDebito(envx.Idauto, 'E')
			Endif
		Endcase
	Catch To oErr When oErr.ErrorNo = 1429
		Messagebox(MENSAJE1 + MENSAJE2 + MENSAJE3, 16, MSGTITULO)
	Catch To oErr When oErr.ErrorNo = 1924
		Messagebox(MENSAJE1 + MENSAJE2 + MENSAJE3, 16, MSGTITULO)
	Finally
	Endtry
	Select envx
	Skip
Enddo
Endfunc
**************************************
Function IngresaResumenDctoGratuito(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24)
Local lC, lp
*:Global cur
lC			  = 'FUNingresaCabeceraGratuito'
cur			  = "Xn"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
goApp.npara18 = np18
goApp.npara19 = np19
goApp.npara20 = np20
goApp.npara21 = np21
goApp.npara22 = np22
goApp.npara23 = np23
goApp.npara24 = np24
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Ingresando Cabecera de Documento')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
*******************************
Function IngresakardexGratuito(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11)
*nid,cc,ct,npr,nct,cincl,tmvto,ccodv,nidalmacen,nidcosto1,xcomision)
Local lC, lp
*:Global cur
lC			  = 'FuningresakardexGratuito'
cur			  = "nidk"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Ingresando Salidas de Productos por Transferencia Gratuita')
	Return 0
Else
	Return nidk.Id
Endif
Endfunc
*********************************
Function verificarCorreocliente(email)
Local loRegExp As "VBScript.RegExp"
*:Global ncolor, valid, vd
If Vartype(email) # "C"
	vd = 0
Else
	loRegExp			= Createobject("VBScript.RegExp")
	loRegExp.IgnoreCase	= .T.
	loRegExp.Pattern	=  '^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)�*)\.([A-Za-z]{2,})$'
	m.valid				= loRegExp.Test(Alltrim(m.email))
	Release loRegExp
	vd = Iif(m.valid, 1, 0)
Endif
Do Case
Case vd > 0
	ncolor = Rgb(128, 255, 128)
Otherwise
	ncolor = Rgb(234, 234, 234)
Endcase
Return vd
Endfunc
****************************
Function EnviaFacturasNotasAutomatico1(Calias, cmulti1, cfracciones, cversion)
Local ocomp As "comprobante"
*:Global ctcom, ctdoc, nid, oerr, vdne
Set Classlib To ("fe") Additive
ocomp = Createobject("comprobante")
Select (Calias)
Go Top
Do While !Eof()
	ocomp.Cmulti	 = cmulti1
	ocomp.Fracciones = cfracciones
	ocomp.Version	 = cversion
	Select (Calias)
	nid	  = Idauto
	cTdoc = Tdoc
	ctcom = tcom
	Try
		Do Case
		Case cTdoc = '01'
			If rcom_otro > 0 Then
				vdne = ocomp.obtenerdatosfacturatransferenciagratuita(nid)
			Else
				If ctcom = 'S' Then
					vdne = ocomp.obtenerdatosfacturaotros(nid)
				Else
					vdne = ocomp.obtenerdatosfactura(nid)
				Endif
			Endif
		Case cTdoc = '07'
			vdne = ocomp.obtenerdatosnotascredito(nid)
		Case cTdoc = '08'
			vdne = ocomp.obtenerdatosnotasDebito(nid)
		Endcase
	Catch To oErr When oErr.ErrorNo = 1429
		Messagebox(MENSAJE1 + MENSAJE2 + MENSAJE3, 16, MSGTITULO)
	Catch To oErr When oErr.ErrorNo = 1924
		Messagebox(MENSAJE1 + MENSAJE2 + MENSAJE3, 16, MSGTITULO)
	Finally
	Endtry
	Select (Calias)
	Skip
Enddo
****************************
Function EnviaFacturasGuiasNotasAutomatico1(Calias, cmulti1, cfracciones, cversion)
Local ocomp As "comprobante"
*:Global ctcom, ctdoc, nid, oerr, tinaf, vdne
Set Classlib To ("fe") Additive
ocomp = Createobject("comprobante")
Select (Calias)
Go Top
Do While !Eof()
	ocomp.Cmulti	 = cmulti1
	ocomp.Fracciones = cfracciones
	ocomp.Version	 = cversion
	Select (Calias)
	nid	  = Idauto
	cTdoc = Tdoc
	ctcom = tcom
	tinaf = inafecto
	Try
		Do Case
		Case cTdoc = '01'
			If ctcom = 'S' Then
				vdne = ocomp.obtenerdatosfacturaotros(nid)
			Else
				If tinaf > 0 Then
					vdne = ocomp.Obtenerdatosfacturaguiainafecta(nid)
				Else
					vdne = ocomp.obtenerdatosfacturaguia(nid)
				Endif
			Endif
		Case cTdoc = '07'
			vdne = ocomp.obtenerdatosnotascredito(nid, 'E')
		Case cTdoc = '08'
			vdne = ocomp.obtenerdatosnotasDebito(nid, 'E')
		Endcase
	Catch To oErr When oErr.ErrorNo = 1429
		Messagebox(MENSAJE1 + MENSAJE2 + MENSAJE3, 16, MSGTITULO)
	Catch To oErr When oErr.ErrorNo = 1924
		Messagebox(MENSAJE1 + MENSAJE2 + MENSAJE3, 16, MSGTITULO)
	Finally
	Endtry
	Select (Calias)
	Skip
Enddo
*********************************
Function IngresaDatosDiarioPle55M(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19)
Local lC, lp
*:Global cur
cur			  = "l"
lC			  = "FunIngresaDatosLibroDiarioPle55"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
goApp.npara18 = np18
goApp.npara19 = np19
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Ingresando Asientos  a Libro Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
************************************
Function DesactivaCreditoAutorizado(np)
Set Procedure To clientes Additive
Local Obj As cliente
Obj					  = Createobject("clientex")
Obj.Codigo			  = np
Obj.AutorizadoCredito = 0
Obj.Autorizacreditocliente()
Endfunc
**************************************
Function IngresaDatosDiarioPle51(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17)
Local lC, lp
*:Global cur
cur			  = "l"
lC			  = "ProIngresaDatosLibroDiarioPLe5"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Ingresando Asientos  a Libro Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
************************************
Define Class base64Helper As Custom
*

*-- COnstructor
	Procedure Init
*
	Declare Integer CryptBinaryToString In Crypt32;
		String @pbBinary, Long cbBinary, Long dwFlags, ;
		String @pszString, Long @pcchString

	Declare Integer CryptStringToBinary In Crypt32;
		String @pszString, Long cchString, Long dwFlags, ;
		String @pbBinary, Long @pcbBinary, ;
		Long pdwSkip, Long pdwFlags
*
	Endproc


* encodeString
* Toma un string y lo convierte en base64
*
	Procedure encodeString(pcString)
	Local nFlags, nBufsize, cDst
	nFlags	 = 1  && base64
	nBufsize = 0
	CryptBinaryToString(@pcString, Len(pcString), m.nFlags, Null, @nBufsize)
	cDst = Replicate(Chr(0), m.nBufsize)
	If CryptBinaryToString(@pcString, Len(pcString), m.nFlags, @cDst, @nBufsize) = 0
		Return ""
	Endif
	Return cDst
	Endproc


* decodeString
* Toma una cadena en BAse64 y devuelve la cadena original
*
	Function decodeString(pcB64)
	Local nFlags, nBufsize, cDst
	nFlags	 = 1  && base64
	nBufsize = 0
	pcB64	 = Strt(Strt(Strt(pcB64, "\/", "/"), "\u000d", Chr(13)), "\u000a", Chr(10))
	CryptStringToBinary(@pcB64, Len(m.pcB64), nFlags, Null, @nBufsize, 0, 0)
	cDst = Replicate(Chr(0), m.nBufsize)
	If CryptStringToBinary(@pcB64, Len(m.pcB64), nFlags, @cDst, @nBufsize, 0, 0) = 0
		Return ""
	Endif
	Return m.cDst
	Endproc


* encodeFile
* Toma un archivo y lo codifica en base64
*
	Procedure encodeFile(pcFile)
	If Not File(pcFile)
		Return ""
	Endif
	Return This.encodeString(Filetostr(pcFile))
	Endproc


* decodeFile
* Toma una cadena base64, la decodifica y crea un archivo con el contenido
*
	Procedure decodefile(pcB64, pcFile)
	Local cBuff
	cBuff = This.decodeString(pcB64)
	Strtofile(cBuff, pcFile)
	Endproc
*
Enddefine
**************************
Define Class comprobantex As Custom
	curl		  = ""
	correocliente = ""
	nidauto		  = 0
	ArchivoXml	  = ""
	ArchivoPdf	  = ""
	Archivoxmlcdr = ""
	ccruc		  = ""
	dFecha		  = Ctod("  /  /    ")
	ccndoc		  = ""
	Importe		  = 0
	ctdoc1		  = ""
	Function subirHosting()
	Local ls_contentFile
*:Global c1, c2, c3, cdata, cdoc, contcdr, contpdf, contxml, cruc, ctabla, ctdocx, df1, nidauto
*:Global nimpo, nombrecdr, nombrepdf, nombrexml, pURL_WSDL
	pURL_WSDL = This.curl
	Cruc	  = This.ccruc
	nidauto	  = This.nidauto
	df1		  = This.dFecha
	cdoc	  = This.ccndoc

	nimpo  = Abs(This.Importe)
	ctdocx = This.ctdoc1


	c1			   = This.ArchivoXml
	nombrexml	   = Justfname(c1)
	ls_contentFile = Filetostr(c1)
	contxml		   = Strconv(ls_contentFile, 13)
**********
	c2			   = This.ArchivoPdf
	nombrepdf	   = Justfname(c2)
	ls_contentFile = Filetostr(c2)
	contpdf		   = Strconv(ls_contentFile, 13)

****************
	c3		  = This.Archivoxmlcdr
	nombrecdr = Justfname(c3)
*cdr=this.archivoxmlcdr
	ls_contentFile = Filetostr(c3)
	contcdr		   = Strconv(ls_contentFile, 13)

	ctabla = "r_" + Alltrim(Cruc)



	Text To cdata Noshow Textmerge
	{
	"ctabla":"<<ctabla>>",
	"nidauto":"<<nidauto>>",
	"dfecha":"<<df1>>",
	"cndoc":"<<cdoc>>",
	"cxml":"<<contxml>>",
	"cpdf":"<<contpdf>>",
	"nombrexml":"<<nombrexml>>",
	"nombrepdf":"<<nombrepdf>>",
	"importe":"<<nimpo>>",
	"ctdoc":"<<ctdocx>>",
	"cdrxml":"<<contcdr>>",
	"nombrecdr":"<<nombrecdr>>"
	}
	Endtext
*!*		oHTTP = Createobject("MSXML2.XMLHTTP")
*!*		oHTTP.Open("post", pURL_WSDL, .F.)
*!*		oHTTP.setRequestHeader("Content-Type", "application/json")
*!*		oHTTP.Send(cdata)
	Endfunc
******************
	Function EnviarCorreo()
	Local ocomp As "comprobante"
	Set Classlib To d:\Librerias\fe Additive
	ocomp				= Createobject("comprobante")
	ocomp.correo		= This.correocliente
	ocomp.ArchivoXml	= This.ArchivoXml
	ocomp.ArchivoPdf	= This.ArchivoPdf
	ocomp.Archivoxmlcdr	= This.Archivoxmlcdr
	ocomp.enviarcorreocliente(This.correocliente)
	Endfunc
	Function VerificaAceptado()
	Local lC
*:Global nid
	nid = This.nidauto
	Text To lC Noshow Textmerge
           idauto,rcom_arch FROM fe_rcom WHERE LEFT(rcom_mens,1)='0'  AND idauto=<<nid>>
	Endtext
	If EjecutaConsulta(lC, 'lr') < 1 Then
		Return 0
	Else
		Return lR.Idauto
	Endif
	Endfunc
Enddefine
*************************
Function Actualizarcontrase�aUsuariosHosting(Cruc)
curl = "http://compania-sysven.com/pass.php"
Text To cdata Noshow Textmerge
	{
	"nruc":"<<cruc>>"
	}
Endtext
oHTTP = Createobject("MSXML2.XMLHTTP")
oHTTP.Open("post", curl, .F.)
oHTTP.setRequestHeader("Content-Type", "application/json")
oHTTP.Send(cdata)
Endfunc
*************************
Function  EnviaCorreoHosting()
Local obji As "Imprimir"
Local objxml As "cpe"
Local ocomp As "comprobante"
Local ocomx As "comprobantex"
*:Global carfile, carpdf, cdr, cpdf, cpropiedad, df, df1, npos
Set Procedure To CapaDatos, ple5, Imprimir Additive
ocomx = Createobject("comprobantex")

cpropiedad = "url"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("url", "")
Endif
goApp.Url = goApp.Url + "p2.php"
goApp.Url = "http://compania-sysven.com/p2.php"
ocomx.curl = goApp.Url




*ocomx.curl='http://facturacionsysven.com/p2.php'
Set Classlib To d:\Librerias\fe Additive
ocomp  = Createobject("comprobante")
obji   = Createobject("Imprimir")
objxml = Createobject("cpe")

Select renvia
Scan All
	ocomx.nidauto = renvia.Idauto
	If ocomx.VerificaAceptado() > 0 Then
		Df			  = renvia.fech
		df1			  = Alltrim(Str(Year(Df))) + '-' + Alltrim(Str(Month(Df))) + '-' + Alltrim(Str(Day(Df)))
		ocomx.dFecha  = df1
		ocomx.ccndoc  = renvia.Ndoc
		ocomx.ctdoc1  = renvia.Tdoc
		ocomx.Importe = renvia.Impo
		If goApp.Grabarxmlbd = 'S' Then
			objxml.descargarxmldesdedata(Justfname(lR.rcom_arch), renvia.Idauto)
		Endif

		If Type('oempresa') = 'U' Then
			ocomx.ccruc			= fe_gene.nruc
			ocomx.ArchivoXml	= Addbs(Sys(5) + Sys(2003) + '\FirmaXML') + Justfname(lR.rcom_arch)
			cdr					= "R-" + Justfname(lR.rcom_arch)
			ocomx.Archivoxmlcdr	= Addbs(Sys(5) + Sys(2003) + '\SunatXML') + cdr
			carfile				= Justfname(lR.rcom_arch)
			npos				= At(".", carfile)
			carpdf				= Left(carfile, npos - 1) + '.Pdf'
			Cpdf				= Addbs(Sys(5) + Sys(2003) + '\PDF') + carpdf
		Else
			ocomx.ccruc			= Oempresa.nruc
			ocomx.ArchivoXml	= Addbs(Sys(5) + Sys(2003) + '\FirmaXML\' + Alltrim(Oempresa.nruc)) + Justfname(lR.rcom_arch)
			cdr					= "R-" + Justfname(lR.rcom_arch)
			ocomx.Archivoxmlcdr	= Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc)) + cdr
			carfile				= Justfname(lR.rcom_arch)
			npos				= At(".", carfile)
			carpdf				= Left(carfile, npos - 1) + '.Pdf'
			Cpdf				= Addbs(Sys(5) + Sys(2003)) + Oempresa.nruc + '\PDF\' + carpdf
		Endif

		If Len(Alltrim(ocomx.correocliente)) > 1 Then
*If !File(cpdf) Then
			ReimprimirStandar(renvia.Idauto, renvia.Tdoc, renvia.tcom)
			obji.Tdoc = renvia.Tdoc
			obji.ImprimeComprobanteM('N')
			obji.ArchivoPdf = Cpdf
			obji.GeneraPDF('N')
*Endif
			ocomx.ArchivoPdf	= Cpdf
			ocomx.correocliente	= renvia.clie_corr
			ocomp.correo		= renvia.clie_corr
			ocomp.ArchivoXml	= ocomx.ArchivoXml
			ocomp.ArchivoPdf	= ocomx.ArchivoPdf
			ocomp.Archivoxmlcdr	= ocomx.Archivoxmlcdr
			ocomp.Ndoc			= renvia.Ndoc
			ocomp.fechaemision	= renvia.fech
			ocomp.ruccliente	= renvia.nruc
			ocomp.Tdoc			= renvia.Tdoc
			ocomp.enviarcorreoClientex(renvia.clie_corr)
		Endif
		If File(ocomx.ArchivoXml) And File(ocomx.ArchivoPdf) And File(ocomx.Archivoxmlcdr) Then
*ocomx.subirHosting()
		Endif
	Endif
Endscan
*************************
Function verificaSiestaAnulada(cndoc, cTdoc)
Local lC
*:Global nid, nidauto
nid = 0
Text To lC Noshow Textmerge
      COUNT(*) as idauto from fe_rcom where ndoc='<<cndoc>>' and tdoc='<<ctdoc>>' and impo=0 and idcliente>0 and acti='A' group by ndoc
Endtext
If EjecutaConsulta(lC, 'anulada') < 1 Then
	Return 0
Else
	Select anulada
	nidauto = Iif(Vartype(anulada.Idauto) = 'C', Val(anulada.Idauto), Idauto)
	If nidauto > 0 Then
		Return  0
	Else
		Return  1
	Endif
Endif
Endfunc
***************************
Function verificancventas(nidauto)
Local lC
Text To lC Noshow Textmerge Pretext 7
     ncre_idau as idauto FROM fe_ncven WHERE ncre_idau=<<nidauto>> AND ncre_acti='A'
Endtext
If EjecutaConsulta(lC, 'yanc') < 1 Then
	Return 0
Else
	Select yanc
	If Idauto > 0 Then
		Return  0
	Else
		Return  1
	Endif
Endif
Endfunc
***************************
Procedure EnviarSunatGuia(pk, crptahash)
Local ArchivoRespuestaSunat As "MSXML2.DOMDocument.6.0"
Local loXMLResp As "MSXML2.DOMDocument.6.0"
Local oShell As "Shell.Application"
Local oXMLBody As 'MSXML2.DOMDocument.6.0'
Local lsURL, ls_base64, ls_contentFile, ls_envioXML, ls_fileName, ls_pwd_sol, ls_ruc_emisor, ls_user
*:Global CMensajeMensaje, CMensajedetalle, CmensajeError, TxtB64, cDirDesti, carchivozip, cfilecdr
*:Global cfilerpta, cnombre, cpropiedad, crespuesta, npos, oArchi, ps_fileZip, rptaSunat
Declare Integer CryptBinaryToString In Crypt32;
	String @pbBinary, Long cbBinary, Long dwFlags, ;
	String @pszString, Long @pcchString

Declare Integer CryptStringToBinary In Crypt32;
	String @pszString, Long cchString, Long dwFlags, ;
	String @pbBinary, Long @pcbBinary, ;
	Long pdwSkip, Long pdwFlags

#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056
Set Library To Locfile("vfpcompression.fll")
ZipfileQuick(goApp.cArchivo)
zipclose()
cpropiedad = "ose"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("ose", "")
Endif


If !Empty(goApp.ose) Then
	Do Case
	Case goApp.ose = "nubefact"
		Do Case
		Case goApp.tipoh = 'B'
			lsURL		  = "https://demo-ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'moddatos'
			ls_user		  = ls_ruc_emisor + 'MODDATOS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
	Case goApp.ose = "bizlinks"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://osetesting.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'TESTBIZLINKS'
			ls_user		  = Alltrim(fe_gene.nruc) + 'BIZLINKS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
	Case goApp.ose = "conastec"
		Do Case
		Case goApp.tipoh = 'B'
			lsURL		  = "https://test.conose.pe:443/ol-ti-itcpe/billService"
			lsURL		  = "https://test.conose.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'moddatos'
			ls_user		  = ls_ruc_emisor + 'MODDATOS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://prod.conose.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
	Case goApp.ose = "efact"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://ose-gw1.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'iGje3Ei9GN'
			ls_user		  = ls_ruc_emisor
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.efact.pe/ol-ti-itcpe/billService"
			lsURL		  =  "https://e-guiaremision.sunat.gob.pe/ol-ti-itemision-guia-gem/billService?wsdl"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
			lsURL		  =  "https://e-guiaremision.sunat.gob.pe/ol-ti-itemision-guia-gem/billService?wsdl"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol2), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_usol2), Alltrim(Oempresa.Gene_usol))

		Endcase
	Endcase
Else
	Do Case
	Case goApp.tipoh = 'B'
		lsURL		  = "https://e-beta.sunat.gob.pe/ol-ti-itemision-guia-gem-beta/billService"
		ls_ruc_emisor = fe_gene.nruc
		ls_pwd_sol	  = 'moddatos'
		ls_user		  = ls_ruc_emisor + 'MODDATOS'
	Case goApp.tipoh = 'H'
		lsURL		  = "https://e-guiaremision.sunat.gob.pe/ol-ti-itemision-guia-gem/billService"
		ls_ruc_emisor = fe_gene.nruc
		ls_pwd_sol	  = Alltrim(fe_gene.gene_csol)
		ls_user		  = ls_ruc_emisor + Alltrim(fe_gene.Gene_usol)
	Case goApp.tipoh = 'P'
		lsURL		  =  "https://e-guiaremision.sunat.gob.pe/ol-ti-itemision-guia-gem/billService"
		lsURL		  =  "https://e-guiaremision.sunat.gob.pe/ol-ti-itemision-guia-gem/billService?wsdl"
		ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
		ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
		ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
	Otherwise
		lsURL		  = "https://e-guiaremision.sunat.gob.pe/ol-ti-itemision-guia-gem/billService"
		ls_ruc_emisor = Iif(Type("oempresa") = "U", fe_gene.nruc, Oempresa.nruc)
		ls_pwd_sol	  = Iif(Type("oempresa") = "U", Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
		ls_user		  = ls_ruc_emisor + Iif(Type("oempresa") = "U", Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
	Endcase
Endif
*wait WINDOW 'aca'+ goapp.tipoh

npos		   = At('.', goApp.cArchivo)
carchivozip	   = Substr(goApp.cArchivo, 1, npos - 1)
ps_fileZip	   = carchivozip + '.zip'
ls_fileName	   = Justfname(ps_fileZip)
ls_contentFile = Filetostr(ps_fileZip)
crespuesta	   = ls_fileName
ls_base64	   = Strconv(ls_contentFile, 13) && Encoding base 64
Text To ls_envioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
		xmlns:ser="http://service.sunat.gob.pe"
		xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
		<soapenv:Header>
				<wsse:Security>
								<wsse:UsernameToken>
									<wsse:Username><<ls_user>></wsse:Username>
									<wsse:Password><<ls_pwd_sol>></wsse:Password>
								</wsse:UsernameToken>
							</wsse:Security>
		  </soapenv:Header>
		  <soapenv:Body>
					<ser:sendBill>
						<fileName><<ls_fileName>></fileName>
						<contentFile><<ls_base64>></contentFile>
					</ser:sendBill>
		 </soapenv:Body>
	</soapenv:Envelope>
Endtext
oXMLHttp = Createobject("MSXML2.ServerXMLHTTP.6.0")
oXMLBody = Createobject('MSXML2.DOMDocument.6.0')
If !(oXMLBody.LoadXML(ls_envioXML)) Then
	oResp.Mensaje = "No se cargo XML: " + oXMLBody.parseError.reason
	Return 0
Endif
oXMLHttp.Open('POST', lsURL, .F.)
oXMLHttp.setRequestHeader( "Content-Type", "text/xml" )
oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8" )
oXMLHttp.setRequestHeader( "Content-Length", Len(ls_envioXML))
oXMLHttp.setRequestHeader( "SOAPAction", "sendBill" )
oXMLHttp.setOption(2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS)
oXMLHttp.Send(oXMLBody.documentElement.XML)
If (oXMLHttp.Status <> 200) Then
	Messagebox('Estado ' + Alltrim(Str(oXMLHttp.Status)) + '-' + Nvl(oXMLHttp.responseText, ''), 16, MSGTITULO)
	Return 0
Endif
loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
loXMLResp.LoadXML(oXMLHttp.responseText)
CmensajeError	= leerXMl(Alltrim(oXMLHttp.responseText), "<faultcode>", "</faultcode>")
CMensajeMensaje	= leerXMl(Alltrim(oXMLHttp.responseText), "<faultstring>", "</faultstring>")
CMensajeMensaje	= leerXMl(Alltrim(oXMLHttp.responseText), "<faultstring>", "</faultstring>")
CMensajedetalle	= leerXMl(Alltrim(oXMLHttp.responseText), "<detail>", "</detail>")
If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Then
	Messagebox((Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle)), 16, 'Sisven')
	Return 0
Endif
*Messagebox(oXMLHttp.responseText,16,'Sisven')
ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
ArchivoRespuestaSunat.LoadXML(oXMLHttp.responseText)			&&Llenamos el archivo de respuesta
TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//applicationResponse")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
If Type('oempresa') = 'U' Then
	cnombre	  = Sys(5) + Sys(2003) + '\SunatXml\' + crespuesta
	cDirDesti = Sys(5) + Sys(2003) + '\SunatXML\'
Else
	cnombre	  = Sys(5) + Sys(2003) + '\SunatXml\' + Alltrim(Oempresa.nruc) + "\" + crespuesta
	cDirDesti = Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\"
Endif
decodefile(TxtB64.Text, cnombre)
oShell	  = Createobject("Shell.Application")
cfilerpta = "R"
For Each oArchi In oShell.NameSpace(cnombre).Items
	If Left(oArchi.Name, 1) = 'R' Then
		oShell.NameSpace(cDirDesti).CopyHere(oArchi)
		cfilerpta = Juststem(oArchi.Name) + '.XML'
	Endif
Endfor
If Type('oempresa') = 'U' Then
	rptaSunat = LeerRespuestaSunat(Sys(5) + Sys(2003) + '\SunatXML\' + cfilerpta)
	cfilecdr  = Sys(5) + Sys(2003) + '\SunatXML\' + cfilerpta
Else
	rptaSunat = LeerRespuestaSunat(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\" + cfilerpta)
	cfilecdr  = Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\" + cfilerpta
Endif
If Len(Alltrim(rptaSunat)) <= 100 Then
	GuardaPkGuia(pk, crptahash, cfilecdr)
Else
	Messagebox(rptaSunat, 64, 'Sisven')
	Return 0
Endif
Do Case
Case Left(rptaSunat, 1) = '0'
	Mensaje(rptaSunat)
	Return 1
Case Empty(rptaSunat)
	Messagebox(rptaSunat, 64, MSGTITULO)
	Return 5000
Otherwise
	Messagebox(rptaSunat, 64, MSGTITULO)
	Return 0
Endcase
Endproc
**************************
Procedure GuardaPkGuia(np1, np2, np3)
*:Global carchivo, cdrxml, cpropiedad, crptaSunat, cxml, dfenvio
cpropiedad = "Grabarxmlbd"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("Grabarxmlbd", "")
Endif
dfenvio	   = cfechast(Datetime())
cArchivo   = goApp.cArchivo
crptaSunat = LeerRespuestaSunat(np3)
If goApp.Grabarxmlbd = 'S' Then
	cxml   = Filetostr(cArchivo)
	cdrxml = Filetostr(np3)
	Text  To lC Noshow
       UPDATE fe_guias SET guia_hash=?np2,guia_mens=?crptaSunat,guia_arch=?carchivo,guia_feen=?dfenvio,guia_xml=?cxml,guia_cdr=?cdrxml WHERE guia_idgui=?np1
	Endtext
Else
	Text  To lC Noshow
       UPDATE fe_guias SET guia_hash=?np2,guia_mens=?rptaSunat,guia_arch=?carchivo,guia_feen=?dfenvio WHERE guia_idgui=?np1
	Endtext
Endif
If SQLExec(goApp.bdConn, lC) < 1 Then
	Errorbd(lC)
	Return 0
Endif
Return 1
Endproc
***************************
Procedure GuardaPkXMLGuia(np1, np2, np3)
*:Global carchivo, cpropiedad, cxml
cpropiedad = "Grabarxmlbd"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("Grabarxmlbd", "")
Endif
cArchivo = goApp.cArchivo
cxml	 = Filetostr(cArchivo)
If goApp.Grabarxmlbd = 'S' Then
	Text  To lC Noshow
         UPDATE fe_guias SET guia_hash=?np2,guia_arch=?carchivo,guia_xml=?cxml WHERE guia_idgui=?np1
	Endtext
Else
	Text  To lC Noshow Textmerge
         UPDATE fe_guias SET guia_hash=?np2,guia_arch=?carchivo WHERE guia_idgui=?np1
	Endtext
Endif
If SQLExec(goApp.bdConn, lC) < 1 Then
	Errorbd(lC)
	Return 0
Endif
Return 1
Endproc
*********************************************
Function INGRESAKARDEXIcbper(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11)
Local lC, lp
*:Global cur
cur			  = "nidk"
lC			  = "FunIngresaKardexIcbper"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Ingresando KARDEX  con ICBPER')
	Return 0
Else
	Return nidk.Id
Endif
Endfunc
*******************************************
Function IngresaResumenDctoVtasIcbper(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23)
Local lC, lp
*:Global cur
lC			  = 'FunIngresaCabeceravtasicbper'
cur			  = "Xn"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
goApp.npara18 = np18
goApp.npara19 = np19
goApp.npara20 = np20
goApp.npara21 = np21
goApp.npara22 = np22
goApp.npara23 = np23
Text To lp Noshow
(?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23)
Endtext
If EJECUTARf(lC, lp, cur) <  1  Then
	Mensaje(' Ingresando Cabecera de Documento')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
******************************************
Function ActualizaResumenDctovtasIcbper(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24)
Local lC, lp
*:Global cur
lC			  = 'ProActualizaCabeceraCVtasicbper'
cur			  = ""
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
goApp.npara18 = np18
goApp.npara19 = np19
goApp.npara20 = np20
goApp.npara21 = np21
goApp.npara22 = np22
goApp.npara23 = np23
goApp.npara24 = np24
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Actualizando Cabecera de Documento de Ventas ICBPER')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function INGRESAKARDEXUMICBPER(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17)
Local cur As String
Local lC, lp
lC			  = 'FunIngresaKardexICBPERUM'
cur			  = "kardexu"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + 'Ingresando Kardex x Unidades')
	Return 0
Else
	Return kardexu.Id
Endif
Endfunc
********************************
Function ActualizaKardexICBPER(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13)
Local cur As String
Local lC, lp
lC			  = 'ProActualizaKardexICBPER'
cur			  = ""
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + 'Ingresando Kardex x Unidades')
	Return 0
Else
	Return 1
Endif
Endfunc
************************************
Function ActualizaKardexICBPERUM(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19)
Local cur As String
Local lC, lp
lC			  = 'ProActualizaKardexICBPERUM'
cur			  = ""
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
goApp.npara18 = np18
goApp.npara19 = np19
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + 'Actualizando Kardex ')
	Return 0
Else
	Return 1
Endif
Endfunc
*****************************
Function monedadecimal
Lparameter tnAmount
Local lnAmount
If Vartype(tnAmount) = "Y"
	lnAmount = Val(Strtran(Transform(tnAmount), "$", ""))
Else
	lnAmount = tnAmount
Endif
Return lnAmount
Endfunc
**********************************
Function opcionesreimpresion(np1)
Do Case
Case np1 = 1
	goApp.Form("ka_rxf1")
Case np1 = 2
	goApp.Form("ka_rxguias")
Endcase
Endproc
*********************************
Function ObtenerCDRSUNAT()
Lparameters LcRucEmisor, lcUser_Sol, lcPswd_Sol, ctipodcto, Cserie, cnumero, pk, mostrarmensaje

Local ArchivoRespuestaSunat As "MSXML2.DOMDocument.6.0"
Local loXMLBody As "MSXML2.DOMDocument.6.0"
Local loXMLResp As "MSXML2.DOMDocument.6.0"
Local loXmlHttp As "MSXML2.ServerXMLHTTP.6.0"
Local oShell As "Shell.Application"
Local lC, lcEnvioXML, lcURL, lcUserName
*:Global CMensaje1, CMensajeMensaje, CMensajedetalle, CmensajeError, Cnumeromensaje, TxtB64
*:Global cDirDesti, cdrxml, cerror, cfilecdr, cfilerpta, cnombre, cpropiedad, crespuesta, crpta
*:Global dfenvio, oArchi, rptaSunat, txtCod, txtMsg
Declare Integer CryptBinaryToString In Crypt32;
	String @pbBinary, Long cbBinary, Long dwFlags, ;
	String @pszString, Long @pcchString

Declare Integer CryptStringToBinary In Crypt32;
	String @pszString, Long cchString, Long dwFlags, ;
	String @pbBinary, Long @pcbBinary, ;
	Long pdwSkip, Long pdwFlags

#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056


loXmlHttp = Createobject("MSXML2.ServerXMLHTTP.6.0")
loXMLBody = Createobject("MSXML2.DOMDocument.6.0")


lcUserName = LcRucEmisor + lcUser_Sol
lcURL	   = "https://e-factura.sunat.gob.pe/ol-it-wsconscpegem/billConsultService"
cpropiedad = "ose"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("ose", "")
Endif

cpropiedad = "Grabarxmlbd"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("Grabarxmlbd", "")
Endif


crespuesta = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc) + '-' + ctipodcto + '-' + Cserie + '-' + cnumero + '.zip'


*lsURL  =  "https://e-factura.sunat.gob.pe/ol-it-wsconscpegem/billConsultService"
Text To lcEnvioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
	<soapenv:Envelope xmlns:ser="http://service.sunat.gob.pe"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
	<soapenv:Header>
	<wsse:Security>
	<wsse:UsernameToken>
	<wsse:Username><<lcUsername>></wsse:Username>
	<wsse:Password><<lcPswd_Sol>></wsse:Password>
	</wsse:UsernameToken>
	</wsse:Security>
	</soapenv:Header>
	<soapenv:Body>
	<ser:getStatusCdr>
	<rucComprobante><<LcRucEmisor>></rucComprobante>
	<tipoComprobante><<ctipodcto>></tipoComprobante>
	<serieComprobante><<cserie>></serieComprobante>
	<numeroComprobante><<cnumero>></numeroComprobante>
	</ser:getStatusCdr>
	</soapenv:Body>
	</soapenv:Envelope>
Endtext

If Not loXMLBody.LoadXML( lcEnvioXML )
	Error loXMLBody.parseError.reason
	Return - 1
Endif

loXmlHttp.Open( "POST", lcURL, .F. )
loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=utf-8" )
loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
loXmlHttp.setRequestHeader( "SOAPAction", "getStatusCdr" )
loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
loXmlHttp.Send(loXMLBody.documentElement.XML)
*?loXmlHttp.Status
If loXmlHttp.Status # 200 Then
	cerror = Nvl(loXmlHttp.responseText, '')
	crpta  = Strextract(cerror, '<faultstring>', '</faultstring>', 1)
	Messagebox(crpta, 16, MSGTITULO)
	Return - 1
Endif
loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
loXMLResp.LoadXML(loXmlHttp.responseText)
CmensajeError	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultcode>", "</faultcode>")
CMensajeMensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultstring>", "</faultstring>")
CMensajedetalle	= leerXMl(Alltrim(loXmlHttp.responseText), "<detail>", "</detail>")
Cnumeromensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<statusCode>", "</statusCode>")
CMensaje1		= leerXMl(Alltrim(loXmlHttp.responseText), "<message>", "</message>")
If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Or Cnumeromensaje <> '0' Then
	If Vartype(mostrarmensaje) = 'L' Then
		Messagebox((Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle) + ' ' + Alltrim(CMensaje1)), 16, 'Sisven')
	Endif
	Return 0
Endif
ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
txtCod = loXMLResp.selectSingleNode("//statusCode")  &&Return
txtMsg = loXMLResp.selectSingleNode("//statusMessage")  &&Return

If txtCod.Text <> "0004"  Then
	If Vartype(mostrarmensaje) = 'L' Then
		Mensaje(Alltrim(txtCod.Text) + ' ' + Alltrim(txtMsg.Text))
	Endif
	Return - 1
Endif

TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//content")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
If Vartype(TxtB64) <> 'O' Then
	Aviso("No se puede LEER el Contenido del Archivo XML de SUNAT")
	Return 0
Endif
crptaxmlcdr = 'R-' + Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc) + '-' + ctipodcto + '-' + Cserie + '-' + cnumero + '.XML'
If Type('oempresa') = 'U' Then
	cnombre	  = Addbs(Sys(5) + Sys(2003) + '\SunatXml') + crespuesta
	cDirDesti = Addbs( Sys(5) + Sys(2003) + '\SunatXML')
	cfilerpta = Addbs( Sys(5) + Sys(2003) + '\SunatXML') + crptaxmlcdr
Else
	cnombre	  = Addbs(Sys(5) + Sys(2003) + '\SunatXml\' + Alltrim(Oempresa.nruc)) + crespuesta
	cDirDesti = Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc))
	cfilerpta = Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc)) + crptaxmlcdr
Endif
If !Directory(cDirDesti) Then
	Md (cDirDesti)
Endif
*Wait Window 'Buscando '+cfilerpta
If File(cfilerpta) Then
*	Wait Window 'Encontrado '+cfilerpta
	Delete File (cfilerpta)
*    Wait Window 'Eliminado '+cfilerpta
Endif

*Wait Window 'Verificar si se anulo'
decodefile(TxtB64.Text, cnombre)
oShell	  = Createobject("Shell.Application")
cfilerpta = "R"
For Each oArchi In oShell.NameSpace(cnombre).Items
	If Left(oArchi.Name, 1) = 'R' Then
		oShell.NameSpace(cDirDesti).CopyHere(oArchi)
		cfilerpta = Juststem(oArchi.Name) + '.XML'
	Endif
Endfor
If Type('oempresa') = 'U' Then
	rptaSunat = LeerRespuestaSunat(Sys(5) + Sys(2003) + '\SunatXML\' + cfilerpta)
	cfilecdr  = Sys(5) + Sys(2003) + '\SunatXML\' + cfilerpta
Else
	rptaSunat = LeerRespuestaSunat(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\" + cfilerpta)
	cfilecdr  = Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\" + cfilerpta
Endif
*MESSAGEBOX(rptaSunat,16,'SISVEN')
Do Case
Case Left(rptaSunat, 1) = '0'
	dfenvio = fe_gene.fech
	If goApp.Grabarxmlbd = 'S' Then
*!*			cdrxml = Filetostr(cfilecdr)
		cdrxml = ""
		Text To lC Noshow
         UPDATE fe_rcom SET rcom_mens=?rptaSunat,rcom_fecd=?dfenvio,rcom_cdr=?cdrxml WHERE idauto=?pk
		Endtext
	Else
		Text  To lC Noshow
         UPDATE fe_rcom SET rcom_mens=?rptaSunat,rcom_fecd=?dfenvio WHERE idauto=?pk
		Endtext
	Endif
	If SQLExec(goApp.bdConn, lC) < 0 Then
		Errorbd(lC)
		Return - 1
	Endif
	Mensaje(rptaSunat)
	Return 1
Case Empty(rptaSunat)
	If Vartype(mostrarmensaje) = 'L' Then
		Messagebox(rptaSunat, 64, MSGTITULO)
	Endif
	Return 5000
Otherwise
	If Vartype(mostrarmensaje) = 'L' Then
		Messagebox(rptaSunat, 64, MSGTITULO)
	Endif
	Return 0
Endcase
Endproc
******************************************
Function  EnviarBoletasyNotas
Lparameters Df

Local ocomp As "comprobante"
*:Global cpropiedad
cpropiedad = "cdatos"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("cdatos", "")
Endif

dATOSGLOBALES()
Set Classlib To d:\Librerias\fe.vcx Additive
ocomp = Createobject("comprobante")
F	  = cfechas(Df)
dFecha = Date()
If goApp.Cdatos = 'S' Then
	nidt = goApp.Tienda
	Text To lC Noshow Textmerge
		fech,tdoc,
		left(ndoc,4) as serie,substr(ndoc,5) as numero,If(Length(trim(c.ndni))<8,'0','1') as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,"" as trefe,"" as serieref,"" as numerorefe,f.idauto
		fROM fe_rcom f inner join fe_clie c on c.idclie=f.idcliente
		where tdoc="03" and fech='<<f>>' and acti='A' and idcliente>0 and LEFT(ndoc,1)='B' and f.codt=<<nidt>> and f.impo<>0
		union all
		select f.fech,f.tdoc,
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
        inner join fe_clie c on c.idclie=f.idcliente
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' and f.codt=<<nidt>> and f.impo<>0
		union all
		select f.fech,f.tdoc,
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',ndni) as ndni,
        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
        inner join fe_clie c on c.idclie=f.idcliente
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' and f.codt=<<nidt>> and f.impo<>0
	Endtext

	If EjecutaConsulta(lC, "rboletas") < 1 Then
		Return 0
	Endif
	Text To lcx Noshow Textmerge
		serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo
		from(select
		left(ndoc,4) as serie,substr(ndoc,5) as numero,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,tdoc
		fROM fe_rcom f where tdoc="03" and fech='<<f>>' and acti='A' and idcliente>0 and f.codt=<<nidt>> order by ndoc) as x  group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo from(select
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto inner join fe_rcom as w on w.idauto=g.ncre_idau
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>'  and f.codt=<<nidt>> order by f.ndoc) as x group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo  from(select
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto inner join fe_rcom as w on w.idauto=g.ncre_idau
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' and f.codt=<<nidt>> order by f.ndoc) as x group by serie
	Endtext

Else
	Text To lC Noshow Textmerge
		fech,tdoc,
		left(ndoc,4) as serie,substr(ndoc,5) as numero,If(Length(trim(c.ndni))<8,'0','1') as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,"" as trefe,"" as serieref,"" as numerorefe,f.idauto
		fROM fe_rcom f
		inner join fe_clie c on c.idclie=f.idcliente
		where tdoc="03" and fech='<<f>>' and acti='A' and idcliente>0 and LEFT(ndoc,1)='B' and f.impo<>0
		union all
		select f.fech,f.tdoc,
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
        inner join fe_clie c on c.idclie=f.idcliente
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' and f.impo<>0
		union all
		select f.fech,f.tdoc,
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',ndni) as ndni,
        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
        inner join fe_clie c on c.idclie=f.idcliente
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' and  f.impo<>0
	Endtext
	If EjecutaConsulta(lC, "rboletas") < 1 Then
		Return 0
	Endif
	Text To lcx Noshow Textmerge
		serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo
		from(select
		left(ndoc,4) as serie,substr(ndoc,5) as numero,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,tdoc
		fROM fe_rcom f where tdoc="03" and fech='<<f>>' and acti='A' and idcliente>0 order by ndoc) as x  group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo from(select
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' order by f.ndoc) as x group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo  from(select
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' order by f.ndoc) as x group by serie
	Endtext
Endif
If EjecutaConsulta(lcx, "rb1") < 1 Then
	Return 0
Endif

Select Tdoc, Serie, desde, hasta, valor, Exon, 000000.00 As inafectas, igv, Impo, 0.00 As gratificaciones, Df As fech;
	From rb1 Into Cursor curb


Select fech, Tdoc, Serie, numero, tipodoc, ndni, valor, rcom_exon As Exon, 000000.00 As inafectas, igv, Impo, 0.00 As gratificaciones, trefe, serieref, numerorefe, Idauto;
	From Rboletas Into Cursor crb


Select crb
ocomp.itemsdocumentos = Reccount()
tr					  = ocomp.itemsdocumentos
If tr = 0 Then
	Return 0
Endif
ocomp.FechaDocumentos = Alltrim(Str(Year(Df))) + '-' + Iif(Month(Df) <= 9, '0' + Alltrim(Str(Month(Df))), Alltrim(Str(Month(Df)))) + '-' + Iif(Day(Df) <= 9, '0' + Alltrim(Str(Day(Df))), Alltrim(Str(Day(Df))))
cnombreArchivo		  = Alltrim(Str(Year(dFecha))) + Iif(Month(dFecha) <= 9, '0' + Alltrim(Str(Month(dFecha))), Alltrim(Str(Month(dFecha)))) + Iif(Day(dFecha) <= 9, '0' + Alltrim(Str(Day(dFecha))), Alltrim(Str(Day(dFecha))))
ocomp.Moneda		  = 'PEN'
ocomp.Tigv			  = '10'
ocomp.vigv			  = '18'
ocomp.fechaemision	  = Alltrim(Str(Year(dFecha))) + '-' + Iif(Month(dFecha) <= 9, '0' + Alltrim(Str(Month(dFecha))), Alltrim(Str(Month(dFecha)))) + '-' + Iif(Day(dFecha) <= 9, '0' + Alltrim(Str(Day(dFecha))), Alltrim(Str(Day(dFecha))))
If Type('oempresa') = 'U' Then
	ocomp.rucfirma			 = fe_gene.rucfirmad
	ocomp.nombrefirmadigital = fe_gene.razonfirmad
	ocomp.rucemisor			 = fe_gene.nruc
	ocomp.razonsocialempresa = fe_gene.empresa
	ocomp.ubigeo			 = fe_gene.ubigeo
	ocomp.direccionempresa	 = fe_gene.ptop
	ocomp.ciudademisor		 = fe_gene.ciudad
	ocomp.distritoemisor	 = fe_gene.distrito
	Cnruc					 = fe_gene.nruc
Else
	ocomp.rucfirma			 = Oempresa.rucfirmad
	ocomp.nombrefirmadigital = Oempresa.razonfirmad
	ocomp.rucemisor			 = Oempresa.nruc
	ocomp.razonsocialempresa = Oempresa.empresa
	ocomp.ubigeo			 = Oempresa.ubigeo
	ocomp.direccionempresa	 = Oempresa.ptop
	ocomp.ciudademisor		 = Oempresa.ciudad
	ocomp.distritoemisor	 = Oempresa.distrito
	Cnruc					 = Oempresa.nruc
Endif

nrbol = _Screen.orboletas.generaserieboletas()
If nrbol < 1 Then
	Messagebox(_Screen.orboletas.Cmensaje, 16, MSGTITULO)
	Return 0
Endif

nres					 = nrbol
ocomp.pais = 'PE'
Dimension ocomp.ItemsFacturas[tr, 16]
i  = 0
ta = 1
Select crb
Scan All
	i						   = i + 1
	ocomp.ItemsFacturas[i, 1]  = crb.Tdoc
	ocomp.ItemsFacturas[i, 2]  = Alltrim(crb.Serie) + '-' + Alltrim(Str(Val(crb.numero)))
	ocomp.ItemsFacturas[i, 3]  = Alltrim(crb.ndni)
	ocomp.ItemsFacturas[i, 4]  = crb.tipodoc
	ocomp.ItemsFacturas[i, 5]  = crb.trefe
	ocomp.ItemsFacturas[i, 6]  = Alltrim(crb.serieref) + '-' + Alltrim(crb.numerorefe)
	ocomp.ItemsFacturas[i, 7]  = Alltrim(Str(crb.Impo, 12, 2))
	ocomp.ItemsFacturas[i, 8]  = Alltrim(Str(crb.valor, 12, 2))
	ocomp.ItemsFacturas[i, 9]  = Alltrim(Str(crb.Exon, 12, 2))
	ocomp.ItemsFacturas[i, 10] = Alltrim(Str(crb.inafectas, 12, 2))
	ocomp.ItemsFacturas[i, 11] = "0.00"
	ocomp.ItemsFacturas[i, 12] = "0.00"
	ocomp.ItemsFacturas[i, 13] = Alltrim(Str(crb.igv, 12, 2))
	ocomp.ItemsFacturas[i, 14] = "0.00"
	ocomp.ItemsFacturas[i, 15] = "0.00"
	ocomp.ItemsFacturas[i, 16] = Alltrim(Str(crb.gratificaciones, 12, 2))
Endscan

cpropiedad = "Firmarcondll"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("Firmarcondll", "")
Endif


cpropiedad = "multiempresa"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("multiempresa", "")
Endif

ocomp.Cmulti = goApp.Multiempresa
ocomp.FirmarconDLL = goApp.FirmarconDLL
If nres = 0 Then
	If generaCorrelativoEnvioResumenBoletas() = 0 Then
		Messagebox("No se Grabo el Corretalivo de Envio de Resumen de Boletas", 64, MSGTITULO)
		Return 0
	Endif
	dATOSGLOBALES()
	nres = fe_gene.gene_nres
Endif
Cserie = cnombreArchivo + "-" + Alltrim(Str(nres))
If ocomp.generaxmlrboletas(Cnruc, Cserie) = 1 Then
	generaCorrelativoEnvioResumenBoletas()
Else
	Return 0
Endif
If !Empty(goApp.ticket) Then
	Do While .T.
		nr = ConsultaTicket(Alltrim(goApp.ticket), goApp.cArchivo)
		If nr >= 0 Or nr < 0 Then
			Exit
		Endif
	Enddo
	v = 1
	If nr = 1 Then
		Select crb
		Go Top
		Scan All
			np1		= crb.Idauto
			dfenvio	= fe_gene.fech
			np3		= "0 El Resumen de Boletas ha sido aceptada " + goApp.ticket
			dfenvio	= cfechas(fe_gene.fech)
			Text To lC Noshow
                    UPDATE fe_rcom SET rcom_mens=?np3,rcom_fecd=?dfenvio WHERE idauto=?np1
			Endtext
			If SQLExec(goApp.bdConn, lC) < 0 Then
				Errorbd(lC)
				v = 0
				Exit
			Endif
		Endscan
	Endif
Else
	v = 0
Endif
Return v
Endfunc
*****************************************
Function Enviarboletasynotasautomatico(Ccursor)
*:Global oerr
Try
	Select (Ccursor)
	Scan All
		EnviarBoletasyNotas(rbxe.resu_fech)
	Endscan
Catch To oErr When oErr.ErrorNo = 1429
	Messagebox(MENSAJE1 + MENSAJE2 + MENSAJE3, 16, MSGTITULO)
Catch To oErr When oErr.ErrorNo = 1924
	Messagebox(MENSAJE1 + MENSAJE2 + MENSAJE3, 16, MSGTITULO)
Finally
Endtry
Endfunc
************************************
Function ActualizaResumenBoletasCDR(np1, np2, np3)
Local lC, lp
*:Global cur
cur			 = []
lC			 = "ProactualizaResumenBoletas"
goApp.npara1 = np1
goApp.npara2 = np2
goApp.npara3 = np3
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Actualizando Respuesta de Sunat')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************
Function ActualizaResumenBajasCDR(np1, np2, np3)
Local lC, lp
*:Global cur
cur			 = []
lC			 = "ProactualizaRBajas"
goApp.npara1 = np1
goApp.npara2 = np2
goApp.npara3 = np3
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Actualizando Respuesta de Sunat')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************************
Procedure ObtenerCDRGuia
Lparameters LcRucEmisor, lcUser_Sol, lcPswd_Sol, ctipodcto, Cserie, cnumero, pk

Local ArchivoRespuestaSunat As "MSXML2.DOMDocument.6.0"
Local loXMLBody As "MSXML2.DOMDocument.6.0"
Local loXMLResp As "MSXML2.DOMDocument.6.0"
Local loXmlHttp As "MSXML2.ServerXMLHTTP.6.0"
Local oShell As "Shell.Application"
Local lcEnvioXML, lsURL, ls_pwd_sol, ls_ruc_emisor, ls_user
*:Global CMensaje1, CMensajeMensaje, CMensajedetalle, CmensajeError, Cnumeromensaje, TxtB64
*:Global cDirDesti, cdrxml, cerror, cfilecdr, cfilerpta, cnombre, cpropiedad, crespuesta, crpta
*:Global oArchi, rptaSunat, txtCod, txtMsg
Declare Integer CryptBinaryToString In Crypt32;
	String @pbBinary, Long cbBinary, Long dwFlags, ;
	String @pszString, Long @pcchString

Declare Integer CryptStringToBinary In Crypt32;
	String @pszString, Long cchString, Long dwFlags, ;
	String @pbBinary, Long @pcbBinary, ;
	Long pdwSkip, Long pdwFlags

#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056
cpropiedad = "ose"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("ose", "")
Endif

cpropiedad = "Grabarxmlbd"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("Grabarxmlbd", "")
Endif



loXmlHttp	  = Createobject("MSXML2.ServerXMLHTTP.6.0")
loXMLBody	  = Createobject("MSXML2.DOMDocument.6.0")
crespuesta	  = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc) + '-' + ctipodcto + '-' + Cserie + '-' + cnumero + '.zip'
lsURL		  =  "https://e-factura.sunat.gob.pe/ol-it-wsconscpegem/billConsultService"
ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
Text To lcEnvioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
		   <soapenv:Envelope xmlns:ser="http://service.sunat.gob.pe" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
					xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
		   <soapenv:Header>
				<wsse:Security>
					<wsse:UsernameToken>
							<wsse:Username><<ls_user>></wsse:Username>
			                <wsse:Password><<ls_pwd_sol>></wsse:Password>
					</wsse:UsernameToken>
				</wsse:Security>
			</soapenv:Header>
		   <soapenv:Body>
		      <ser:getStatusCdr>
		         <rucComprobante><<LcRucEmisor>></rucComprobante>
		         <tipoComprobante><<ctipodcto>></tipoComprobante>
		         <serieComprobante><<cserie>></serieComprobante>
				 <numeroComprobante><<cnumero>></numeroComprobante>
		      </ser:getStatusCdr>
		   </soapenv:Body>
		</soapenv:Envelope>
Endtext
If Not loXMLBody.LoadXML( lcEnvioXML )
	Error loXMLBody.parseError.reason
	Return - 1
Endif
loXmlHttp.Open( "POST", lsURL, .F. )
loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
loXmlHttp.setRequestHeader( "SOAPAction", "getStatusCdr" )
loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
loXmlHttp.Send(loXMLBody.documentElement.XML)
If loXmlHttp.Status # 200 Then
	cerror	  = Nvl(loXmlHttp.responseText, '')
	crpta	  = Strextract(cerror, '<faultstring>', '</faultstring>', 1)
	CMensaje1 = Strextract(cerror, "<message>", "</message>", 1)
	Messagebox(crpta + ' ' + Alltrim(CMensaje1), 16, MSGTITULO)
	Return - 1
Endif
loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
loXMLResp.LoadXML(loXmlHttp.responseText)
CmensajeError	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultcode>", "</faultcode>")
CMensajeMensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultstring>", "</faultstring>")
CMensajedetalle	= leerXMl(Alltrim(loXmlHttp.responseText), "<detail>", "</detail>")
Cnumeromensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<statusCode>", "</statusCode>")
CMensaje1		= leerXMl(Alltrim(loXmlHttp.responseText), "<message>", "</message>")
If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Or Cnumeromensaje <> '0' Then
	Messagebox((Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle) + ' ' + Alltrim(CMensaje1)), 16, 'Sisven')
	Return 0
Endif
ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
txtCod = loXMLResp.selectSingleNode("//statusCode")  &&Return
txtMsg = loXMLResp.selectSingleNode("//statusMessage")  &&Return
If txtCod.Text <> "0004"  Then
	Mensaje(txtMsg.Text)
	Return  - 1
Endif
TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//content")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
If Type('oempresa') = 'U' Then
	cnombre	  = Sys(5) + Sys(2003) + '\SunatXml\' + crespuesta
	cDirDesti = Sys(5) + Sys(2003) + '\SunatXML\'
Else
	cnombre	  = Sys(5) + Sys(2003) + '\SunatXml\' + Alltrim(Oempresa.nruc) + "\" + crespuesta
	cDirDesti = Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\"
Endif
decodefile(TxtB64.Text, cnombre)
oShell	  = Createobject("Shell.Application")
cfilerpta = "R"
For Each oArchi In oShell.NameSpace(cnombre).Items
	If Left(oArchi.Name, 1) = 'R' Then
		oShell.NameSpace(cDirDesti).CopyHere(oArchi)
		cfilerpta = Juststem(oArchi.Name) + '.XML'
	Endif
Endfor
If Type('oempresa') = 'U' Then
	rptaSunat = LeerRespuestaSunat(Sys(5) + Sys(2003) + '\SunatXML\' + cfilerpta)
	cfilecdr  = Sys(5) + Sys(2003) + '\SunatXML\' + cfilerpta
Else
	rptaSunat = LeerRespuestaSunat(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\" + cfilerpta)
	cfilecdr  = Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\" + cfilerpta
Endif
Do Case
Case Left(rptaSunat, 1) = '0'
	Mensaje(rptaSunat)
	If goApp.Grabarxmlbd = 'S' Then
		cdrxml = Filetostr(cfilecdr)
		Text  To lC Noshow
           UPDATE fe_guias SET guia_mens=?rptaSunat,guia_cdr=?cdrxml WHERE guia_idgui=?pk
		Endtext
	Else
		Text  To lC Noshow
          UPDATE fe_guias SET guia_mens=?rptaSunat WHERE guia_idgui=?pk
		Endtext
	Endif
	If SQLExec(goApp.bdConn, lC) < 0 Then
		Errorbd(lC)
		Return 0
	Endif
	Return 1
Case Empty(rptaSunat)
	Messagebox(rptaSunat, 64, 'Sisven')
	Return 0
Otherwise
	Messagebox(rptaSunat, 64, 'Sisven')
	Return 0
Endcase
Endproc
********************************
Function ProIngresaDatosDiarioPle55(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18)
Local lC, lp
*:Global cur
cur			  = ""
lC			  = "ProIngresaDatosLibroDiarioPLE55"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
goApp.npara18 = np18
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' ' + ' Ingresando Asientos  a Libro Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************************
Function opcionesreimpresion1(np1)
Do Case
Case np1 = 1
	goApp.Form("ka_rxf")
Case np1 = 2
	goApp.Form("ka_rxguias")
Endcase
Endproc
*****************************
Function Ejecutarsql(tcComando As String, lp As String, NCursor As String )
Local lR As Integer
NCursor = Iif(Vartype(NCursor) <> "C", "", NCursor)
If Empty(NCursor) Then
	lR = SQLExec(goApp.bdConn, tcComando)
Else
	lR = SQLExec(goApp.bdConn, tcComando, NCursor)
Endif
If lR > 0 Then
	Return 1
Else
	Errorbd(tcComando)
	Return 0
Endif
Endfunc
******************************
Function cfechast(Df)
Return Alltrim(Str(Year(Df))) + '-' + Alltrim(Str(Month(Df))) + '-' + Alltrim(Str(Day(Df))) + ' ' + Time()
****************************************
Function GrabaDetalleGuiasRCompras(np1, np2, np3, np4)
Local lC, lp
*:Global cur
lC			 = "ProIngresaDetalleGuiaRCompras"
cur			 = ""
goApp.npara1 = np1
goApp.npara2 = np2
goApp.npara3 = np3
goApp.npara4 = np4
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
Endtext
If EJECUTARP(lC, lp, cur) < 1 Then
	Errorbd(ERRORPROC + ' Ingresando Detalles Guias de Ventas')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************************
Function IngresaGuiasXComprasRemitente(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12)
Local lC, lp
*:Global cur
lC			  = "FunIngresaGuiasxComprasRemitente"
cur			  = "YY"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,
     ?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12)
Endtext
If EJECUTARf(lC, lp, cur) < 1 Then
	Errorbd(ERRORPROC + ' Ingresando Guias de Remisi�n Por Compras')
	Return 0
Else
	Return yy.Id
Endif
Endfunc
*********************************
Function CreaTemporalGuiasElectronicas(Calias)
Create Cursor (Calias)(coda N(8), duni c(20), Descri c(120), Unid c(20), cant N(10, 2), Prec N(10, 8), uno N(10, 2), Dos N(10, 2), lote c(15), ;
	  Peso N(8, 4), alma N(10, 2), Ndoc c(12), Nreg N(10), codc c(5), tref c(2), Refe c(20), fecr d, Detalle c(120), fechafactura d, costo N(10, 3), ;
	  calma c(3), Valida c, Nitem N(3), saldo N(10, 2), idin N(8), nidkar N(10), coda1 c(15), fech d, fect d, ptop c(150), ;
	  ptoll c(120), Archivo c(120), valida1 c(1), valido c(1), stock N(10, 2), ;
	  razon c(120), nruc c(11), ndni c(8), conductor c(120), marca c(100), Placa c(15), ;
	  placa1 c(15), Constancia c(30), equi N(8, 4), prem N(10, 4), pos N(3), idepta N(5), ;
	  brevete c(20), razont c(120), ructr c(11), Motivo c(1), Codigo c(30), comi N(5, 3), idem N(8), ;
	  Tigv N(5, 3), caant N(12, 2), nlote c(20), Fechavto d, tipotra c(15), Tp c(1) Default 'N', estilo c(1) Default 'N', porc N(5, 2), ;
	  tipro c(1) Default 'K', ctramos c(1), htramos c(1), cant1 N(10, 2), codigoe N(8), precio1 N(13, 5), Item N(8), Codigo1 c(30))
Select (Calias)
Index On Descri Tag Descri
Index On Nitem Tag Items
Endfunc
****************************
Function ActualizaTipoCambioSunat(nm, Na)
Local Sw As Integer
*:Global df, tcc, tcv
tcc	= 0
tcv	= 0
Sw	= 1
Df	= Ctod("01/" + Alltrim(Str(nm)) + "/" + Alltrim(Str(Na))) - 1
F	= cfechas(Df)
Text To lC Noshow Textmerge
    valor,venta FROM fe_mon WHERE fech='<<f>>'
Endtext
If EjecutaConsulta(lC, 'tca') < 1 Then
	Return  0
Endif
attca = tca.valor
attcv = tca.venta
Text To lC Noshow Textmerge
         fech,valor,venta,idmon FROM fe_mon WHERE MONTH(fech)=<<nm>> AND YEAR(fech)=<<na>> ORDER BY fech
Endtext
If EjecutaConsulta(lC, 'atca') < 1 Then
	Return 0
Endif
ImportaTCSunat(nm, Na)
If VerificaAlias("curTcambio") = 1 Then
	If IniciaTransaccion() = 0 Then
		DEshacerCambios()
		Return 0
	Endif
	Select atca
	Go Top
	Do While !Eof()
		x	   = Day(atca.fech)
		nidmon = atca.idmon
		Select CurTCambio
		Locate For DIA = x
		If Found()
			tcc	  = CurTCambio.TC_COMPRA
			tcv	  = CurTCambio.TC_VENTA
			attca = CurTCambio.TC_COMPRA
			attcv = CurTCambio.TC_VENTA
		Else
			tcc	= attca
			tcv	= attcv
		Endif
		Text To lC Noshow
            UPDATE fe_mon SET valor=?tcc,venta=?tcv WHERE idmon=?nidmon
		Endtext
		If SQLExec(goApp.bdConn, lC) < 0 Then
			Sw = 0
			Exit
		Endif
		Select atca
		Skip
	Enddo
	If Sw = 0 Then
		DEshacerCambios()
		Errorbd(lC + ' Actualizando Tipo Cambio desde  www.Sunat.gob.pe')
		Return 0
	Else
		GRabarCambios()
* tcv > fe_gene.dola
		If   nm = Month(fe_gene.fech) And Na = Year(fe_gene.fech) Then
			Text To lC Noshow
               UPDATE fe_gene SET dola=?tcv WHERE idgene=1
			Endtext
			If SQLExec(goApp.bdConn, lC) < 0 Then
				Return  0
			Endif
		Endif
		Mensaje("Tipo de Cambio Actualizado Correctamente")
		Return 1
	Endif
Endif
Endfunc
*******************************
Procedure ImportaTCSunat(nmes, nanio)
Set Procedure To  d:\capass\modelos\importadatos Additive
Obj = Createobject("importadatos")
If Obj.ImportaTCSunat(nmes, nanio) < 1 Then
	Messagebox(Obj.Cmensaje, 16, MSGTITULO)
Endif
*!*	Local loXmlHttp As "Microsoft.XMLHTTP"
*!*	Local lcHTML, lcURL, ls_compra, ls_venta
*!*	*:Global = Val[1], cdata, dfecha2, fecha, ff, fi, i, na, nm, otc, ovalor, x
*!*	mensaje("Consultando Tipo de Cambio")
*!*	Set Procedure To d:\librerias\json Additive
*!*	nm	  = Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes)))
*!*	na	  = Alltrim(Str(nanio))
*!*	lcURL = Textmerge("http://compania-sysven.com/tc.php")
*!*	fi	  = na + '-' + nm + '-01'
*!*	*DTOS(Ctod('01/'+Trim(Str(nm))+'/'+Trim(Str(na))))

*!*	dfecha2	= Dtos(Ctod('01/' + Trim(Str(Iif(nmes < 12, nmes + 1, 1))) + '/' + Trim(Str(Iif(nmes < 12, nanio, nanio + 1)))))
*!*	ff		= Left(dfecha2, 4) + '-' + Substr(dfecha2, 5, 2) + '-' + Right(dfecha2, 2)




*!*	loXmlHttp = Createobject("Microsoft.XMLHTTP")
*!*	*fi="2021-04-01"
*!*	*ff="2021-04-30"

*!*	TEXT To cdata Noshow Textmerge
*!*		{
*!*		"dfi":"<<fi>>",
*!*		"dff":"<<ff>>"
*!*		}
*!*	ENDTEXT
*!*	loXmlHttp.Open('POST', lcURL, .F.)
*!*	loXmlHttp.setRequestHeader("Content-Type", "application/json")
*!*	loXmlHttp.Send(cdata)
*!*	If loXmlHttp.Status <> 200 Then
*!*		Messagebox("Servicio WEB NO Disponible....." + Alltrim(Str(loXmlHttp.Status)), 16, MSGTITULO)
*!*		Return
*!*	Endif
*!*	lcHTML = Chrtran(loXmlHttp.responseText, '-', '')

*!*	If 	(Atc("precio_compra", lcHTML) > 0) && si tiene la palabra compra es v�lido
*!*		Create Cursor CurTCambio(DIA N(2), TC_COMPRA N(5, 3), TC_VENTA N(5, 3))
*!*		otc = json_decode(lcHTML)
*!*		If Not Empty(json_getErrorMsg())
*!*			Messagebox("No se Pudo Obtener la Informaci�n " + json_getErrorMsg(), 16,  MSGTITULO)
*!*			Return
*!*		Endif
*!*		x = 0
*!*		For i = 1 To otc._Data.getSize()
*!*			x	   = x + 1
*!*			ovalor = otc._Data.Get(x)
*!*			If (Vartype(ovalor) = 'O') Then
*!*				fecha	  = ovalor.Get("fecha")
*!*				ls_compra = ovalor.Get("precio_compra")
*!*				ls_venta  = ovalor.Get('precio_venta')
*!*				d		  = Val(Right(fecha, 2))
*!*				Insert Into CurTCambio(DIA, TC_COMPRA, TC_VENTA)Values(d, Val(ls_compra), Val(ls_venta))
*!*			Endif
*!*		Next
*!*	Else
*!*		mensaje('No se encontro informaci�n para Tipo de Cambio' )
*!*	Endif




*loIE=Createobject("InternetExplorer.Application")
*loIE.Visible=.F.
*https://e-consulta.sunat.gob.pe/cl-at-ittipcam/tcS01Alias?mesElegido=06&anioElegido=2019&mes=06&anho=2019&accion=init&email=
*https://e-consulta.sunat.gob.pe/cl-at-ittipcam/tcS01Alias?mesElegido=07&anioElegido=2020&mes=07&anho=2020&accion=init&email=



*loIE.Navigate("http://www.sunat.gob.pe/cl-at-ittipcam/tcS01Alias?mes="+(nm)+"&anho="+(na))
*cad=("https://e-consulta.sunat.gob.pe/cl-at-ittipcam/tcS01Alias?mesElegido="+(nm)+"&anioElegido="+(na)+"&mes="+(nm)+"&anho="+(na)+"&accion=init&email="
*https://e-consulta.sunat.gob.pe/cl-at-ittipcam/tcS01Alias?mesElegido=%2211%22&anioElegido=%222020%22&mes=%2211%22&anho=%222020%22&accion=init&email=
*https://e-consulta.sunat.gob.pe/cl-at-ittipcam/tcS01Alias?mesElegido=%2212%22&anioElegido=%222020%22&mes=%2212%22&anho=%222020%22&accion=init&email=
*https://e-consulta.sunat.gob.pe/cl-at-ittipcam/tcS01Alias
*loIE.Navigate("https://e-consulta.sunat.gob.pe/cl-at-ittipcam/tcS01Alias?mesElegido="+(nm)+"&anioElegido="+(na)+"&mes="+(nm)+"&anho="+(na)+"&accion=init&email=")
*https://e-consulta.sunat.gob.pe/cl-at-ittipcam/tcS01Alias?mesElegido=07&anioElegido=2020&mes=07&anho=2020&accion=init&email=



*Do While loIE.readystate<>4
*	Wait Window "Esperando Respuesta desde https://e-consulta.sunat.gob.pe/cl-at-ittipcam/tcS01Alias " Nowait
*Enddo
*lcHTML=loIE.Document.body.innerText
*ln_PosIni = At("D�a",lcHTML)
*ln_PosFin = At("Para efectos",lcHTML)
*lc_Texto = Substr(lcHTML,ln_PosIni,ln_PosFin - ln_PosIni)
*ln_PosIni = Rat("Venta",lc_Texto)
*lc_Texto = Chrtran(Alltrim(Substr(lc_Texto,ln_PosIni + 6)) + " ",Chr(10),"")
*Wait Clear
*loIE.Quit()
*Release loIE
*Push Key Clear
*Create Cursor CurTCambio(DIA N(2),TC_COMPRA N(5,3),TC_VENTA N(5,3))
*ln_Contador = 0
*lc_Cadena = ""
*If Left(lc_Texto,9)<> "No existe" Then
*	For k = 1 To Len(lc_Texto)
*		If Substr(lc_Texto,k,1) = " " Then
*			ln_Contador = ln_Contador + 1
*			If ln_Contador = 1 And k <> Len(lc_Texto) Then
*				If  Val(Alltrim(lc_Cadena))=0 Then
*					If Len(Alltrim(lc_Cadena))=2 Then
*						lc_Cadena=Alltrim(Substr(lc_Cadena,2,1))
*					Else
*						lc_Cadena=Alltrim(Substr(lc_Cadena,2,2))
*					Endif
*				Endif
*				Select CurTCambio
*				Append Blank
*				Replace CurTCambio.DIA With Val(lc_Cadena)
*			Endif
*			If ln_Contador = 2 Then
*				Select CurTCambio
*				Replace CurTCambio.TC_COMPRA With Val(lc_Cadena)
*			Endif
*			If ln_Contador = 3 Then
*				Select CurTCambio
*				Replace CurTCambio.TC_VENTA With Val(lc_Cadena)
*				ln_Contador = 0
*			Endif
*			lc_Cadena =""
*		Else
*			lc_Cadena = lc_Cadena + Substr(lc_Texto,k,1)
*		Endif
*	Next
*Endif
Endproc
********************************************
Function RegistraTipoCambioSunat(nm, Na)
Local dias, Sw As Integer
*:Global df, tcc, tcv
Df	= Ctod("01/" + Alltrim(Str(nm)) + "/" + Alltrim(Str(Na))) - 1
tcc	= 0
tcv	= 0
Sw	= 1
Do Case
Case nm = 1 Or nm = 3 Or nm = 5 Or nm = 7 Or nm = 8 Or nm = 10 Or nm = 12
	dias = 31
Case nm = 4 Or nm = 6 Or nm = 9 Or nm = 11
	dias = 30
Otherwise
	If ((Na % 4 = 0 And Na % 100 # 0) Or (Na % 400 = 0)) Then
		dias = 29
	Else
		dias = 28
	Endif
Endcase
F = cfechas(Df)
Text To lC Noshow Textmerge
     valor,venta FROM fe_mon WHERE fech='<<f>>'
Endtext
If EjecutaConsulta(lC, 'tca') < 1 Then
	Return  0
Endif
attca = tca.valor
attcv = tca.venta
ImportaTCSunat(nm, Na)
If VerificaAlias("curTcambio") = 1 Then
	If IniciaTransaccion() = 0 Then
		DEshacerCambios()
		Return 0
	Endif
	For x = 1 To dias
		Df = Ctod(Alltrim(Str(x)) + '/' + Alltrim(Str(nm)) + '/' + Alltrim(Str(Na)))
		Select CurTCambio
		Locate For DIA = x
		If Found()
			tcc	  = CurTCambio.TC_COMPRA
			tcv	  = CurTCambio.TC_VENTA
			attca = tcc
			attcv = tcv
		Else
			tcc	= attca
			tcv	= attcv
		Endif
		Text To lC Noshow
           INSERT INTO fe_mon(fech,valor,venta)values(?df,?tcc,?tcv)
		Endtext
		If SQLExec(goApp.bdConn, lC) < 0 Then
			Sw = 0
			Exit
		Endif
	Next
	If Sw = 0 Then
		DEshacerCambios()
		Errorbd(lC + 'Al Registrar Tipo de Cambio')
		Return 0
	Else
		GRabarCambios()
		If tcv > fe_gene.dola  And nm = Month(fe_gene.fech) And Na = Year(fe_gene.fech) Then
			Text To lC Noshow Textmerge
                 UPDATE fe_gene SET dola=<<tcv>> where idgene=1
			Endtext
			If Ejecutarsql(lC) < 1 Then
				Return  0
			Endif
		Endif
		Mensaje("Tipo de Cambio Actualizado Correctamente")
		Return 1
	Endif
Endif
Endfunc
*****************************
Procedure ActualizaFechaSistema
Local oWSH As "WScript.Shell"
Local lC, lk
Text To lk Noshow Textmerge
   curdate() as fechaservidor
Endtext
If EjecutaConsulta(lk, "ff") < 1
	Return
Endif
cpropiedad = "Otrodia"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("Otrodia", "")
Endif
cpropiedad = "inicioenvios"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("inicioenvios", 1)
	ninicioenvios = 1
Else
	ninicioenvios = goApp.InicioEnvios
Endif
If ff.fechaservidor <= fe_gene.fech Then
	nmes = Month(fe_gene.fech)
Else
	oWSH  = Createobject("WScript.Shell")
	cFile = Addbs(Sys(5) + Sys(2003)) + 'Copia.exe'
	If File(cFile) Then
		Copianube = Addbs(Sys(5) + Sys(2003)) + 'Copia.exe'
		oWSH.Run(Copianube, 0, .F.)
	Endif
	nmes   = Month(ff.fechaservidor)
	dFecha = ff.fechaservidor
	nanio  = Year(ff.fechaservidor)
	fe	   = cfechas(dFecha)
	Text To cupdate Noshow Textmerge
       UPDATE fe_gene SET fech='<<fe>>',a�o=<<nanio>>,gene_nbaj=1,gene_nres=<<ninicioenvios>>,mes=<<nmes>> WHERE idgene=1
	Endtext
	If Ejecutarsql(cupdate) < 1
		Return
	Endif
	nm = nmes
	goApp.datosg = ""
	dATOSGLOBALES()
	Text To lC Noshow Textmerge
         fech FROM fe_mon WHERE MONTH(feCh)=<<nmes>> anD YEAR(fech)=<<nanio>>
	Endtext
	If EjecutaConsulta(lC, "Ya") < 1
		Return
	Endif
	If REgdvto("ya") = 0 Then
		If Dow(dFecha) = 1 Then
			ndia = Day(dFecha)
			dfan = dFecha - ndia
			nma	 = Month(dfan)
			naan = Year(dfan)
			If nma <> nm Then
				ActualizaTipoCambioSunat(nma, naan)
			Endif
		Endif
		RegistraTipoCambioSunat(nmes, nanio)
	Else
		ActualizaTipoCambioSunat(nmes, nanio)
	Endif
	If SQLExec(goApp.bdConn, "call calcularstock()") < 1
		Errorbd("No Se puede Conectar con la Base de Datos")
		Return
	Endif
	goApp.Otrodia = 'S'
Endif
Endproc
*****************************
Procedure ActualizaFechaSistemax
Local oWSH As "WScript.Shell"
Local lC, lk
*:Global Copianube, cfile, cupdate, dfan, dfecha, na, naan, ndia, ninicioenvios, nm, nma, nmes
Text To lk Noshow  Textmerge
   curdate() as fechaservidor
Endtext
If EjecutaConsulta(lk, "ff") < 1
	Return
Endif
If ff.fechaservidor <= fe_gene.fech Then
	nmes = Month(fe_gene.fech)
Else

	oWSH  = Createobject("WScript.Shell")
	cFile = Addbs(Sys(5) + Sys(2003)) + 'Copia.exe'
	If File(cFile) Then
		Copianube = Addbs(Sys(5) + Sys(2003)) + 'Copia.exe'
		oWSH.Run(Copianube, 0, .F.)
	Endif
	nmes   = Month(ff.fechaservidor)
	dFecha = ff.fechaservidor
	Na	   = Year(ff.fechaservidor)
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("inicioenvios", 1)
		ninicioenvios = 1
	Else
		ninicioenvios = goApp.InicioEnvios
	Endif
	Text To cupdate Noshow
       UPDATE fe_gene SET fech=?dfecha,a�o=?na,gene_nbaj=1,gene_nres=<<ninicioenvios>>,mes=?nmes WHERE idgene=1
	Endtext
	If SQLExec(goApp.bdConn, cupdate) < 1
		Errorbd(cupdate)
		Return
	Endif
	goApp.datosg = ""
	dATOSGLOBALES()
	nm = nmes
	Text To lC Noshow Textmerge
		 Select  fech  From fe_mon  Where Month(fech) = <<nm>> And Year(fech) = <<na>>
	Endtext
	If EjecutaConsulta( lC, "Ya") < 1
		Errorbd(lC)
		Return
	Endif
	If REgdvto("ya") = 0 Then
		If Dow(fe_gene.fech) = 1 Then
			ndia = Day(fe_gene.fech)
			dfan = fe_gene.fech - ndia
			nma	 = Month(dfan)
			naan = Year(dfan)
			If nma <> nm Then
				ActualizaTipoCambioSunat(nma, naan)
			Endif
		Endif
		RegistraTipoCambioSunat(nmes, Na)
	Else
		ActualizaTipoCambioSunat(nmes, Na)
	Endif
	If SQLExec(goApp.bdConn, "call calcularstock()") < 1
		Errorbd("No Se puede Conectar con la Base de Datos")
		Return
	Endif
Endif
Endproc
*****************************
Procedure CalCularStock()
Set Procedure To d:\capass\modelos\productos Additive
Obj = Createobject("producto")
If Obj.CalCularStock() < 1 Then
	Messagebox(Obj.Cmensaje, 16, MSGTITULO)
	Return
Endif
Mensaje(Obj.Cmensaje)
Endproc
*******************************
Function MuestraMediosPago()
Local lC, lp
*:Global cur
lC	= "PROmuestraMediosPago"
cur	= "MPago"
lp	= ""
If EJECUTARP(lC, lp, cur) < 1 Then
	Errorbd(ERRORPROC + ' Mostrando Tabla de Medios de Pago')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************************************************************
Function AnulaTransaccion(np1, np2, np3, np4, np5, np6, np7, np8)
Local cur As String
Local lC, lp
lC			 = 'proAnulaTransacciones'
cur			 = ""
goApp.npara1 = np1
goApp.npara2 = np2
goApp.npara3 = np3
goApp.npara4 = np4
goApp.npara5 = np5
goApp.npara6 = np6
goApp.npara7 = np7
goApp.npara8 = np8
Text To lp Noshow
	     (@estado,?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Anulando Transacciones ')
	Return 0
Else
	Return 1
Endif
Endfunc
******************************************
Function BuscaSoloproducto(np1, Ccursor)
Local lC
Text To lC Noshow Textmerge
     * FROM fe_art WHERE idart=<<np1>>
Endtext
If EjecutaConsulta(lC, Ccursor) < 1 Then
	Return 0
Else
	Return 1
Endif
Endfunc
*********************************************
Procedure Shell_Exec
*--------------------------------------------
Lparameters tcFileName, tcAction, tcParams, tlChangeDir

* tcFileName="\\ruta\nombreArchivo.extensi�n
* tcAction: "open", "find","print"   (por defecto es "open")
* tcParams: lista de par�metros separados por CHR(32) (unicamente para archivos exe)
* Sample Shell_Exec(m.lcFileName)

Local lcPath
Try
	Local lcExt, ;
		lcMessage, ;
		lDoit, ;
		lcFolder, ;
		loFso As Object, ;
		loex As Exception, ;
		loResp As Object

	lcFolder = Fullpath("")
	loFso	 = Newobject("Scripting.FileSystemObject")

	loResp = Newobject("Empty")
	AddProperty(loResp, "nResponse", 0)
	AddProperty(loResp, "failure", .F.)
	AddProperty(loResp, "FileExist", loFso.FileExists(m.tcFileName) )

	If loResp.FileExist

		tcAction = Evl(m.tcAction, "Open")
		tcParams = Evl(m.tcParams, "")
		lcExt	 = Justext(m.tcFileName)
		If m.tlChangeDir
			lcPath = Justpath(m.tcFileName)
			If !Empty(m.lcPath) And loFso.FolderExists(Addbs(m.lcPath))

				Cd &lcPath
			Endif
		Endif

		Declare Integer ShellExecute In SHELL32.Dll Integer nWinHandle, ;
			String cOperation, ;
			String cFileName, ;
			String cParameters, ;
			String cDirectory, ;
			Integer nShowWindow
		Declare Integer FindWindow In WIN32API String cNull, ;
			String cWinName


		loResp.nResponse = ShellExecute(FindWindow(0, _Screen.Caption), tcAction, tcFileName, tcParams, Sys(2023), 1)
		Do Case
		Case loResp.nResponse = 2
			lcMessage = "Invalid path or filename. No existe el archivo"
		Case loResp.nResponse = 8
			lcMessage = "No hay suficiente memoria para realizar la acci�n solicitada"
		Case loResp.nResponse = 11
			lcMessage = "El archivo no es ejecutable o est� corrompido"
		Case loResp.nResponse = 31
* Aparentemente ocurre cuando no encuentra
* una aplicaci�n asociada
			lcMessage = "No se encuentra una aplicaci�n para " + m.lcExt

		Case loResp.nResponse = 33
* VErificado para XLS,DOC,JPG,BMP
		Case loResp.nResponse = 42
* Verificado para PDF,GIF,0MDI,MIP,NRI
		Otherwise

		Endcase
	Endif
Catch To loex
	loex.UserValue = Program()
	ShowError(loex)
Finally
	loFso = Null
	If m.tlChangeDir
		Cd &lcFolder
	Endif
	If !Empty(m.lcMessage)
		loResp.Failure = .T.
		Messagebox(m.lcMessage, 0, Program())
	Endif
Endtry
Return loResp
Endproc

Procedure ShowError
Lparameters toExcep, tlNotShow, tcCaption
*--------------------------------------
tcCaption = Evl(tcCaption, MENSAJE_DE)
Local lcMens
lcMens = "Fecha " + Transform(Datetime());
	+ Chr(13) + "Mensaje: " + toExcep.Message;
	+ Chr(13) + "ErrorNo: " + Transform(toExcep.ErrorNo);
	+ Chr(13) + "Llamada: " + toExcep.UserValue
If Pemstatus(toExcep, "lineno", 5) And Vartype(toExcep.Lineno) = "N"
	lcMens = lcMens + Chr(13) + "linea " + Transform(toExcep.Lineno)
Endif

Strtofile(m.lcMens + Chr(13) + Replicate("=", 80) + Chr(13), "TheoCall_Error.log", 1)

If !tlNotShow
	Messagebox("Se ha producido un error:" + Chr(13) + lcMens, 0, m.tcCaption)
Endif

Endproc
***************************************
Function CreatemporalVtasgratuitas(Calias)
Create Cursor precios(Precio N(8, 2), coda N(8), iden N(1), Nitem N(2))
Create Cursor Autorizado(coda N(8), cant N(12, 2), Prec N(12, 2), Prea N(12, 2), Unid c(15), Nitem N(5), Idusua N(5), idusuaa N(5))
Create Cursor (Calias)(coda N(8), Desc c(80), Unid c(4), Prec N(13, 5), cant N(10, 3), ;
	  Ndoc c(12), Nreg N(8), alma N(10, 2), pmayor N(8, 2), pmenor N(8, 2), pre1 N(8, 2), pre2 N(8, 2), Pre3 N(8, 2), ;
	  pos N(2), comi N(7, 3), prem N(8, 2), premax N(8, 2), costo N(10, 2), tras c(1), calma c(60), uno N(10, 2), Dos N(10, 2), ;
	  Nitem N(3), Valida c(1), Impo N(10, 2), Acti c(1), tipro c(1), idcosto N(10), valido c(1), Precio N(10, 2), ;
	  aprecios c(1), Modi c(1), cletras c(120), hash c(30), fech d, codc N(5), Guia c(10), Direccion c(120), dni c(8), Forma c(30), fono c(15), ;
	  Vendedor c(60), dias N(3), razon c(120), nruc c(11), Mone c(1) Default 'S', Tdoc c(2), Archivo c(120), valida1 c(1), Peso N(10, 2))
Endfunc
**************************
Function CreaTemporalvtasporservicios(Calias)
Create Cursor (Calias)(Nitem N(2), Desc c(120), Unid c(15), cant N(10, 4), Prec N(16, 7), nitem1 N(2), nitem2 N(2), Tipovta c(1), ;
	  Ndoc c(12), hash c(30), fech d, codc N(5), Guia c(12), Direccion c(120), dni c(8), Forma c(30), fono c(15), Archivo c(120), Detalle c(120), ;
	  Vendedor c(60), dias N(3), razon c(120), nruc c(11), Mone c(1) Default 'S', Form c(30), Referencia c(120), Ndo2 c(12), fechav d, ;
	  cletras c(150), Tigv N(5, 3), valor N(12, 2), igv N(12, 2), Total N(12, 2), Exon N(12, 2), Tdoc c(2), valida1 c(1), detraccion N(10, 2), ;
	  coddetrac c(10), Impo N(12, 2), anticipo N(12, 2), refanticipo  c(60), idanticipo N(8))
Endfunc
*********************************
Function CREATEMPORALVTASPORSERVICIOS1(Calias)
Create Cursor (Calias)(Nitem N(2), Desc c(120), Unid c(5), cant N(8, 2), Prec N(13, 7), nitem1 N(2), nitem2 N(2), ;
	  Ndoc c(12), hash c(30), fech d, codc N(5), Guia c(12), Direccion c(120), dni c(8), Forma c(30), fono c(15), ;
	  Vendedor c(60), dias N(3), razon c(120), nruc c(11), Mone c(1) Default 'S', Form c(30), Referencia c(120), ticbper N(6, 2), icbper N(6, 2), ;
	  Ndo2 c(12), fechav d, cletras c(150), Tigv N(5, 3), Archivo c(120), coda1 c(15), valor N(12, 2), igv N(12, 2), Impo N(12, 2), ;
	  detraccion N(8, 2), Tdoc c(2), coddetrac c(10), Total N(12, 2), contacto c(100), Detalle c(120), tipoletra c(1) Default '', ;
	  gratuita N(10, 2), costoRef N(6, 2), perc N(10, 2), anticipo N(12, 2))
Endfunc
*********************************
Function creaTemporalGuiasTransportista(Calias)
Create Cursor (Calias)(Nitem N(2), Desc c(120), Unid c(5), cant N(10, 4), Peso N(16, 7), nitem1 N(2), nitem2 N(2), ;
	  Ndoc c(12), hash c(30), fech d, fect d, Direccion c(120), dni c(8), Archivo c(120), Detalle c(120), ;
	  remitente c(120), nrucr c(11), Referencia c(120), Ndo2 c(12), destinatario c(120), nrucd c(11), razont c(100), ruct c(11), ;
	  marca c(100), Placa c(20), placa1 c(11), Constancia c(20), brevete c(20), configuracion c(20), ptop c(120), ptoll c(120))
Endfunc
*********************************
Function Createmporalpreventacunidades(Calias)
Create Cursor unidades(uequi N(7, 4), ucoda N(8), uunid c(15), uitem N(4), uprecio N(12, 6), uidepta N(8), ucosto N(10, 2), ucomi N(6, 3))
Create Cursor (Calias)(Descri c(120), Unid c(15), cant N(10, 2), Prec N(13, 8), Impo N(12, 2), Nreg N(8), pmayor N(8, 2), pmenor N(8, 2), Nitem N(4), ;
	  Ndoc c(10), costo N(13, 8), pos N(1), Tdoc c(2), Form c(1), tipro c(1), alma N(10, 2), Item N(4), coda N(8), Valida c(1), perc N(8, 2), ;
	  calma c(3), idco N(8), codc N(8), aprecios c(1), comi N(7, 4), npagina N(4), equi N(8, 2) Default 1, duni c(15), idepta N(8), valida1 c(1), Fecha d, cliente c(120), Vendedor c(100))
Select (Calias)
Index On Descri Tag Descri
Index On Nitem Tag Items
Set Order To
Endfunc
*********************************
Function IsInterNetActive (tcURL)
***********************************
* PARAMETERS: URL, no olvidar pasar la URL completa, con http:// al inicio
* Retorna .T. si hay una conexion a internet activa
*Tekno
*Wireless Toyz
*Ypsilanti, Michigan
***********************************
tcURL = Iif(Type("tcURL") = "C" And !Empty(tcURL), tcURL, "http://www.google.com")

Declare Integer InternetCheckConnection In wininet;
	String lpszUrl, ;
	Integer dwFlags, ;
	Integer dwReserved

Return ( InternetCheckConnection(tcURL, 1, 0) == 1)
Endfunc
***********************************
Function EjecutaConsulta(tcComando As String, NCursor As String )
Local r As Integer
Local laError[1], lcError
*:Global csql
NCursor = Iif(Vartype(NCursor) <> "C", "", NCursor)
Dimension laError(1)
If Upper(Left(Alltrim(tcComando), 6)) = 'SELECT' Then
	csql = Alltrim(tcComando)
Else
	csql = 'SELECT ' + Alltrim(tcComando)
Endif

If Empty(NCursor) Then
	r = SQLExec(goApp.bdConn, csql)
Else
	r = SQLExec(goApp.bdConn, csql, NCursor)
Endif
If r > 0 Then
	Return 1
Else
	Aviso(csql)
	If Aerror(laError) > 0
		lcMsg = ""
		For ln = 1 To Alen(laError, 2)
			lcMsg = lcMsg + Transform(laError(1, ln)) + Chr(13)
		Endfor
		Aviso(lcMsg)
	Endif
	Return 0
Endif
Endfunc
*************************************
Function  Verificapreciosantesvtas(Calias)
*:Global tprec
Select Sum(coda) As Prec From (Calias) Where Prec = 0 Into Cursor sinprec
If _Tally > 0  Then
	tprec = 0
Else
	tprec = 1
Endif
Return tprec
Endfunc
**************************************
Function  Verificacantidadantesvtas(Calias)
If Empty(Calias) Or !Used(Calias) Then
	goApp.mensajeApp = 'No  esta  Activo el Temporal de Guias'
	Return 0
Endif
Select Sum(coda)  As cant From (Calias) Where cant = 0 Into Cursor sincant
*!*	wait WINDOW sincant.cant
If _Tally > 0 Then
	tcant = 0
Else
	tcant = 1
Endif
Return tcant
Endfunc
*****************************************
Function  Verificacostosantesvtas(Calias)
*:Global tprec
Select Sum(coda) As Prec From (Calias) Where costo = 0 Into Cursor sinprec
If _Tally > 0 Then
	tprec = 0
Else
	tprec = 1
Endif
Return tprec
Endfunc

*****************************************
Procedure Mostrardatoscliente
*:Global ccorreo
With _Screen.ActiveForm
	.txtruC.Value		= lp.nruc
	.txtraZON.Value		= lp.Razo
	.txtdIRECCION.Value	= lp.Dire
	.txtciudad.Value	= lp.ciud
	.txtfono.Value		= lp.fono
	.txtfax.Value		= lp.fax
	.txtCodigo.Value	= lp.idcliE
	.txtdnI.Value		= lp.ndni
	.txtlcredito.Value	= lp.clie_lcre
	.cliente			= lp.idcliE
	Select lp
	If Fsize("clie_auto") <> 0 Then
		If lp.clie_auto = 1 Then
			This.CreditoAutorizado = 1
		Else
			This.CreditoAutorizado = 0
		Endif
	Endif
	If Empty(lp.clie_corr) Or Alltrim(lp.clie_corr) = "@" Or Len(Alltrim(lp.clie_corr)) <= 1 Then
		Ccorreo = ""
	Else
		Ccorreo = lp.clie_corr
	Endif
Endwith
****************************
Function HayInternet()
Declare Long InternetGetConnectedState In "wininet.dll" Long lpdwFlags, Long dwReserved
If InternetGetConnectedState(0, 0) <> 1
	Messagebox("Sin conexi�n a Internet.", 16, MSGTITULO)
	Return  0
Else
	Return 1
Endif
Endfunc
******************************
Function  Verificadetalleotrasventas(Calias)
*:Global tcant
Select Len(Alltrim(Desc)) As longitud From (Calias) Where Nitem > 0 And Len(Alltrim(Desc)) = 0 Into Cursor sindesc
If  _Tally > 0 Then
	tcant = 0
Else
	tcant = 1
Endif
Return tcant
Endfunc
********************************************************************
Function  Verificapreciosntesovtas(Calias)
*:Global tprec
Select Sum(Nitem) As Prec From (Calias) Where Prec = 0 And Nitem > 0 Into Cursor sinprec
If _Tally > 0 Then
	tprec = 0
Else
	tprec = 1
Endif
Return tprec
Endfunc
**************************************
Function  Verificacantidadantesovtas(Calias)
*:Global tcant
Select Sum(Nitem) As cant From (Calias) Where cant = 0 And Nitem > 0 Into Cursor sincant
If _Tally > 0 Then
	tcant = 0
Else
	tcant = 1
Endif
Return tcant
Endfunc
***************************************
Function IngresaGuiasConsignacionx3(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12)
Local lC, lp
*:Global cur
lC			  = "FUNINGRESAGUIASCons"
cur			  = "yy"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Ingresando Guias Por Consignaci�n')
	Return 0
Else
	Return yy.Id
Endif
Endfunc
**************************
Function ActualizaGuiasx3(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11)
Local lC, lp
*:Global cur
lC			  = "ProActualizaGuiasCons"
cur			  = ""
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Actualizando Guias Por Consignaci�n')
	Return 0
Else
	Return 1
Endif
Endfunc
*****************************
Function verificasiyatieneoferta(np1)
Local lC
*:Global codigopro
codigopro = Val(goApp.Codigopromocion)
Text To lC Noshow Textmerge Pretext 7
  CAST(IFNULL(SUM(cant),0) AS DECIMAL(6,2)) AS cant,idart FROM
  fe_rcom AS r
  INNER JOIN fe_kar AS k ON k.idauto=r.idauto
  INNER JOIN fe_clie AS c ON c.idclie=r.`idcliente`
  WHERE idart=<<codigopro>> AND k.acti='A' AND r.acti='A' AND TRIM(deta)='<<np1>>'  GROUP BY idart
Endtext
If EjecutaConsulta(lC, 'ofertas') < 1 Then
	Return 0
Endif
If ofertas.cant > 0 Then
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************
Function ObtenerImpresoraActual
Local lcImpresora, lnBuffer, lnResultado

lnBuffer = 250

lcImpresora = Replicate(Chr(0), lnBuffer)

Try
	Declare Integer GetDefaultPrinter In WINSPOOL.DRV As GetDefaultPrinterAPI ;
		String @pszBuffer, ;
		Integer @pcchBuffer

	If GetDefaultPrinterAPI(@lcImpresora, @lnBuffer) <> 0
		lcImpresora = Substr(lcImpresora, 1, At(Chr(0), lcImpresora) - 1)
	Else
		lcImpresora = ""
	Endif
Catch
	lcImpresora = ""
Endtry

Return(lcImpresora)
*
********************************
Procedure DECLARAR_API

Declare Integer GetDefaultPrinter In WINSPOOL.DRV As GetDefaultPrinterAPI ;
	String @pszBuffer, ;
	Integer @pcchBuffer

Return
****************************
Function BuscarSeries1(ns, cTdoc)
Local cser As String
If SQLExec(goApp.bdConn, "CALL PROBUSCASERIES(?ns,?ctdoc)", "series") < 1
	Errorbd(ERRORPROC + ' Mostrando Series 1')
	Return 0
Else
	If SERIES.Idserie <= 0
		Messagebox("Serie No Registrada", 48, MSGTITULO)
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
*******************
Function UCES2Chr(tcTexto As String) As String

Local lcBSu As String, ;
	lcChr As String, ;
	lcHex As String, ;
	lcTexto As String, ;
	lnPos As Number

lcTexto = m.tcTexto
Do While "\u" $ m.lcTexto
	lnPos	= At("\u", m.lcTexto)
	lcBSu	= Substr(m.lcTexto, m.lnPos, 6)
	lcHex	= "0x" + Right(m.lcBSu, 4)
	lcChr	= Chr(Evaluate(m.lcHex))
	lcTexto	= Strtran(m.lcTexto, m.lcBSu, m.lcChr)
Enddo

Return m.lcTexto
****************************
Procedure Register()
If !IsRegistred("RICHTEXT.RichtextCtrl.1")
	DllRegister("richtx32.ocx")
Endif
If !IsRegistred("MSComctlLib.TreeCtrl.2")
	DllRegister("mscomctl.ocx")
Endif
If !IsRegistred("COMCTL.ProgCtrl.1")
	DllRegister("comctl32.ocx")
Endif
Endproc
***********************************
Procedure IsRegistred(tcClassName)
Local luResult
luResult = RegReadKey("HKEY_CLASSES_ROOT\" + tcClassName + "\", Null)
Return !Isnull(luResult)
Endproc

Procedure DllRegister(tcFileName)
Declare Integer DllRegisterServer In (tcFileName)
DllRegisterServer()
Clear Dlls "DllRegisterServer"
Endproc
*****************************************
Function REGISTRAR_OCX
Lparameters tcNombreOCX
Local lnNumError
lnNumError = 0
Try
	Declare Long DllRegisterServer In (tcNombreOCX)
Catch
	lnNumError = 1
Endtry

If lnNumError = 0
	Try
		lnNumError = DllRegisterServer()
	Catch
		lnNumError = 2
	Endtry
Endif
Return (lnNumError)
Endfunc
*****************************************
Function AbreConexion(nopcion)
If Len(Alltrim(_Screen.conector)) = 0 Then
	lcC1 = "Driver={MySQL ODBC 5.1 Driver};Port=3306;Server=" + Alltrim(_Screen.Server) + ";Database=" + Alltrim(_Screen.Database) + ";Uid=" + Alltrim(_Screen.User) + ";Pwd=" + Alltrim(_Screen.pwd) + ";OPTION=131329;"
*!*	    lcC1 = "Driver={MySQL ODBC 5.1 Driver};Port=10001;Server=" + Alltrim(_Screen.Server) + ";Database=" + Alltrim(_Screen.Database) + ";Uid=" + Alltrim(_Screen.User) + ";Pwd=" + Alltrim(_Screen.pwd) + ";OPTION=131329;"
Else
	lcC1 = "Driver={" + Alltrim(_Screen.conector) + "};Port=3306;Server=" + Alltrim(_Screen.Server)  + ";Database=" + Alltrim(_Screen.Database) + ";Uid=" + Alltrim(_Screen.User) + ";Pwd=" + Alltrim(_Screen.pwd) + ";OPTION=131329;"
Endif
= SQLSetprop(0, "DispLogin", 3)
idconecta = Sqlstringconnect(lcC1) && ESTABLECER LA CONEXION
If idconecta < 1 Then
	= Aerror(laError)
	Messagebox(laError[2], 16, MSGTITULO)
	Return - 1
Else
	= SQLSetprop(idconecta, 'PacketSize', 5000)
	Return idconecta
Endif
Endfunc
***************************
Function CierraConexion(np1)
= SQLDisconnect(np1)
Endfunc
*****************************
Procedure controlerrores(toExc As Exception)
#Define CR Chr(13)
Do Case
CASE m.toExc.ErrorNo=1
    Cmensaje=" El Archivo No existe "
	Do Form ka_error With Cmensaje
Case m.toExc.ErrorNo = 1426
	Cmensaje = "El Programa que intenta Ejecutar no responde"
	Do Form ka_error With Cmensaje
Case m.toExc.ErrorNo = 1429
	Cmensaje = "No Hay respuesta desde donde se Obtiene Informaci�n"
	Do Form ka_error With Cmensaje
Case m.toExc.ErrorNo = 1466
	Cmensaje = "Se ha perdido la Conexi�n con la  Base de Datos"
	Do Form ka_error With Cmensaje
	VERIFICACONEXION()
Otherwise
	Local lcErrorInfo
	cproyecto = Sys(2003)
	m.lcErrorInfo = "Error N�..........: " + Transform(m.toExc.ErrorNo)  + CR + ;
		"Linea No....: " + Transform(m.toExc.Lineno) + CR + ;
		"Mensaje.....: " + m.toExc.Message + CR + ;
		"Programa.. .: " + m.toExc.Procedure + CR + ;
		"Detalle.....: " + m.toExc.Details + CR + ;
		"StackLevel..: " + Transform(m.toExc.StackLevel) + CR + ;
		"Linea.......: " + m.toExc.LineContents + CR + ;
		"Comentario..: " + m.toExc.Comment + CR + ;
		"Proyecto....: " + cproyecto
	Do Form ka_error With m.lcErrorInfo
Endcase
Endproc
*********************
Function ProcesaTransportistax(Cruc, crazo, cdire, cbreve, ccons, cmarca, cplaca, idtr, optt, cchofer, nidus, cplaca1, ctipot)
If optt = 0 Then
	If SQLExec(goApp.bdConn, "SELECT FUNCREATRANSPORTISTA(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?nidus,?cplaca1,?ctipot) as nid", "yy") < 1 Then
		Errorbd(ERRORPROC + '  Registrando Nuevo Transportista')
		Return 0
	Else
		Return yy.nid
	Endif
Else
	If SQLExec(goApp.bdConn, "CALL PROACTUALIZATRANSPORTISTA(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?idtr,?cplaca1,?ctipot)") < 1 Then
		Errorbd(ERRORPROC + ' Actualizando Transportista')
		Return 0
	Else
		Return idtr
	Endif
Endif
Endfunc
**********************
Function CreaTemporalAlmacenes()
Create Cursor precios(Precio N(8, 2), coda N(8), iden N(1), Nitem N(2))
Create Cursor tmpv(coda N(8), Descri c(150), Unid c(4), Prec N(13, 5), cant N(10, 3), ;
	  Ndoc c(12), Nreg N(8), alma N(10, 2), pre1 N(8, 2), pre2 N(8, 2), Pre3 N(8, 2), Impo N(12, 2), ;
	  pos N(2), comi N(7, 3), prem N(8, 2), premax N(8, 2), costo N(10, 2), uno N(10, 2), Dos N(10, 2), tre N(10, 2), cua N(10, 2), ;
	  Valida c(1), Acti c(1), tipro c(1), idcosto N(10), hash c(30), fech d, codc N(5), Guia c(10), Direccion c(120), ;
	  dni c(8), Forma c(30), fono c(15), Vendedor c(60), dias N(3), razon c(120), nruc c(11), Mone c(1) Default 'S', Ndo2 c(12), Form c(30), ;
	  aprecios c(1), Modi c(1), cletras c(120), SerieProducto c(60), Idseriep N(5), valida1 c(1), Codigo1 c(30), ;
	  Referencia c(120), fechav d, codigof c(40), Idseriex N(5), fect d, ;
	  tref c(2), Refe c(20), fecr d, Detalle c(120), fechafactura d, ;
	  calma c(3), Nitem N(3), saldo N(10, 2), idin N(8), nidkar N(10), coda1 c(15), ptop c(150), ptoll c(120), Archivo c(120), ;
	  ndni c(8), conductor c(120), marca c(100), Placa c(15), placa1 c(15), Constancia c(30), ;
	  brevete c(20), razont c(120), ructr c(11), Motivo c(1), Codigo c(30), equi N(8, 3), Peso N(8, 2), origen c(50), destino c(50))
Create Cursor Seriesp(SerieProducto c(60), Idseriep N(5), coda N(5), Nitem N(10))
Endfunc
***********************
Function IngresaDtraspasosU(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13)
Local lC, lp
*:Global cur
lC			  = 'FunIngresaKardex'
cur			  = "Xt"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' No Es Posible Registrar el Detalle del Traspaso')
	Return 0
Else
	Return Xt.Id
Endif
Endfunc
**********************************
Function IngresaResumenTraspasos(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24)
Local lC, lp
*:Global cur
lC			  = 'FUNINGRESACABECERACV'
cur			  = "yy"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
goApp.npara18 = np18
goApp.npara19 = np19
goApp.npara20 = np20
goApp.npara21 = np21
goApp.npara22 = np22
goApp.npara23 = np23
goApp.npara24 = np24
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(Errorbd + ' Registrando Traspasos')
	Return 0
Else
	Return yy.Id
Endif
Endfunc
********************************
Function IngresaGuiasX(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10)
Local lC, lp
*:Global cur
lC			  = "FUNINGRESAGUIAS"
cur			  = "YY"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Ingresando Guias de Remisi�n Por Ventas')
	Return 0
Else
	Return yy.Id
Endif
Endfunc
***********************
Function IngresaGuiasXTraspaso(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10)
Local lC, lp
*:Global cur
lC			  = "FUNINGRESAGUIAST"
cur			  = "YY"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Ingresando Guias de Remisi�n Traspaso')
	Return 0
Else
	Return yy.Id
Endif
Endfunc
***********************
Function IngresaGuiasxDcompras(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10)
Local lC, lp
*:Global cur
lC			  = "FUNINGRESAGUIASxdCompras"
cur			  = "YY"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Ingresando Guias de Remisi�n Por Ventas')
	Return 0
Else
	Return yy.Id
Endif
Endfunc
***************************
Function VerificaSiguiaVtaEstaIngresada(np1)
Local lC
Text To lC Noshow Textmerge
     guia_idgui as idauto FROM fe_guias WHERE guia_ndoc='<<np1>>' AND guia_acti='A'
Endtext
If EjecutaConsulta(lC, 'Ig') < 1 Then
	Return 0
Else
	If ig.Idauto > 0 Then
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
***************************
Function VerificaSiguiaVtaEstaIngresadavtas(np1)
Local lC
Text To lC Noshow Textmerge
     guia_idgui as idauto FROM fe_guias WHERE guia_ndoc='<<np1>>' AND guia_acti='A' and guia_moti='V'
Endtext
If EjecutaConsulta(lC, 'Ig') < 1 Then
	Return 0
Else
	If ig.Idauto > 0 Then
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
*****************************
Procedure Errorbd(ccomando As String)
Local laError
Local lcError
Dimension laError(1)
= Aerror(laError)
If Type("laError") = "A"
	lcError = laError(1, 3)
Else
	lcError = 'Hubo Un error de Conexi�n a la Base de Datos'
Endif
Cmensaje = Alltrim(ccomando) + Chr(13) + Chr(13) + 	lcError
Do Form ka_error With Cmensaje
Endproc
*******************************
Function  CreatmpLetras(Calias)
Create Cursor (Calias)(Ndoc c(20), dias N(3), fevto d, Detalle c(25), impc N(10, 2), Sw N(1) Default 0, mrete N(10, 2), ;
	  Impo N(10, 2), Razo c(100), nruc c(11), fono c(10)Null, Dire c(100), dni c(10), Cimporte c(80), ciud c(80), ;
	  anombre c(100), adire c(100), afono c(10)Null, anruc c(11), fech d, Tipo c(1), situa c(10), ;
	  inic N(10, 2), impoo N(10, 2), impresion N(1), codc N(15), dscto N(10, 2), nmonto N(12, 2), ide N(8), Mensaje c(30), chkdni N(1), Moneda c(1))
Endfunc
*******************************
Function  GeneraCorrelativoBancos(np1)
Local lC
Text To lC Noshow Textmerge
     UPDATE fe_sucu SET empr_banc=empr_banc+1 WHERE idalma=<<np1>>
Endtext
If SQLExec(goApp.bdConn, lC) < 1 Then
	Errorbd(lC)
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function BuscarSeriesBancos(np1)
Local lC
Text To lC Noshow Textmerge
	Select  empr_banc
		From  fe_sucu
		Where idalma =<<np1>>
Endtext
If EjecutaConsulta(lC, 'correlativo') < 1 Then
	Return 0
Else
	Return Correlativo.empr_banc
Endif
Endfunc
*********************************
Function MuestraClientes10(np1, Ccursor)
Local lC, lp
lC			 = 'PROMUESTRACLIENTES10'
goApp.npara1 = np1
Text To lp Noshow
     (?goapp.npara1)
Endtext
If EJECUTARP(lC, lp, Ccursor) = 0 Then
	Errorbd(ERRORPROC + 'Mostrando Clientes')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************
Function IngresaCreditosNormal10(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18)
Local lC, lp
*:Global cur
lC			  = 'FUNREGISTRACREDITOS'
cur			  = "Xn"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
goApp.npara18 = np18
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC +  '   Ingresando Cr�ditos con sucursal')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
**********************
Function IngresaResumenDctosT(cTdoc, cndoc, dFecha, Nv, nigv, Nt, cmvto, cdeta, cndo2, nidtda, nidusua, Nitem)
Local nigv1
*:Global nd
nigv1 = fe_gene.igv
nd	  = fe_gene.dola
If SQLExec(goApp.bdConn, "SELECT FUNINGRESACABECERACV(?ctdoc,'E',?cndoc,?dfecha,?dfecha,?cdeta,?nv,?nigv,?nt,?cndo2,'S',?nd,?nigv1,'T',0,?cmvto,?nidusua,1,?nidtda,0,0,0,?nitem,0) AS NID", "NIDT") < 1
	Errorbd(ERRORPROC + ' CABECERA')
	Return 0
Else
	Return nidt.nid
Endif
Endfunc
***************************

*	        resu_fech,sum(enviados) as enviados,sum(resumen) as resumen from(
*			select resu_fech,case tipo when 1 then resu_impo else 0 end as enviados,
*			case tipo when 2 then resu_impo else 0 end as Resumen,resu_mens,tipo from (
*			SELECT resu_fech,resu_impo as resu_impo,resu_mens,1 as Tipo FROM fe_resboletas f
*			where resu_fech between '<<f1>>' and '<<f2>>' and f.resu_acti='A' and left(resu_mens,1)='0'
*			union all
*			SELECT fech as resu_fech,if(mone='S',impo,impo*dolar) as resu_impo,' ' as resu_mens,2 as Tipo FROM fe_rcom f
*			where fech between '<<f1>>' and '<<f2>>' and f.acti='A' and tdoc='03' and left(ndoc,1)='B' and f.idcliente>0
*			union all
*			SELECT f.fech as resu_fech,if(f.mone='S',abs(f.impo),abs(f.impo*f.dolar)) as resu_impo,' ' as resu_mens,2 as Tipo FROM fe_rcom f
*			inner join fe_ncven g on g.ncre_idan=f.idauto
**			inner join fe_rcom as w on w.idauto=g.ncre_idau
*			where f.fech between '<<f1>>' and '<<f2>>' and f.acti='A' and f.tdoc in ('07','08') and left(f.ndoc,1)='F' and w.tdoc='03' ) as x)
*			as y group by resu_fech order by resu_fech


Define Class Resumenboletas As Custom
	Function ConsultaBoletasyNotasporenviar(f1, f2)
	Local lC
	Text To lC Noshow Textmerge
	    resu_fech,enviados,resumen,resumen-enviados,enviados-resumen
		FROM(SELECT resu_fech,CAST(SUM(enviados) AS DECIMAL(12,2)) AS enviados,CAST(SUM(resumen) AS DECIMAL(12,2))AS resumen FROM(
		SELECT resu_fech,CASE tipo WHEN 1 THEN resu_impo ELSE 0 END AS enviados,
		CASE tipo WHEN 2 THEN resu_impo ELSE 0 END AS Resumen,resu_mens,tipo FROM (
		SELECT resu_fech,resu_impo AS resu_impo,resu_mens,1 AS Tipo FROM fe_resboletas f
		WHERE  resu_fech between '<<f1>>' and '<<f2>>' and f.resu_acti='A' AND LEFT(resu_mens,1)='0'
		UNION ALL
		SELECT fech AS resu_fech,IF(mone='S',impo,impo*dolar) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		WHERE  f.fech between '<<f1>>' and '<<f2>>' and f.acti='A' AND tdoc='03' AND LEFT(ndoc,1)='B' AND f.idcliente>0
		UNION ALL
		SELECT f.fech AS resu_fech,IF(f.mone='S',ABS(f.impo),ABS(f.impo*f.dolar)) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		INNER JOIN fe_ncven g ON g.ncre_idan=f.idauto
		INNER JOIN fe_rcom AS w ON w.idauto=g.ncre_idau
		WHERE  f.fech between '<<f1>>' and '<<f2>>' and f.acti='A' AND f.tdoc IN ('07','08') AND LEFT(f.ndoc,1)='F' AND w.tdoc='03' AND f.idcliente>0 ) AS x)
		AS y GROUP BY resu_fech ORDER BY resu_fech) AS zz  WHERE resumen-enviados>=1
	Endtext
	If EjecutaConsulta(lC, 'rbolne') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarticket10(np1)

	Endfunc
	Function ConsultaBoletasyNotasporenviarsinfechas()
	Local lC
*:Global cpropiedad
	cpropiedad = "cdatos"
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("cdatos", "")
	Endif
	If goApp.Cdatos = 'S' Then
		Text To lC Noshow Textmerge
	    resu_fech,enviados,resumen,resumen-enviados,enviados-resumen
		FROM(SELECT resu_fech,CAST(SUM(enviados) AS DECIMAL(12,2)) AS enviados,CAST(SUM(resumen) AS DECIMAL(12,2))AS resumen FROM(
		SELECT resu_fech,CASE tipo WHEN 1 THEN resu_impo ELSE 0 END AS enviados,
		CASE tipo WHEN 2 THEN resu_impo ELSE 0 END AS Resumen,resu_mens,tipo FROM (
		SELECT resu_fech,resu_impo AS resu_impo,resu_mens,1 AS Tipo FROM fe_resboletas f
		WHERE  f.resu_acti='A' AND LEFT(resu_mens,1)='0' and resu_codt=<<goapp.tienda>>
		UNION ALL
		SELECT fech AS resu_fech,IF(mone='S',impo,impo*dolar) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		WHERE   f.acti='A' AND tdoc='03' AND LEFT(ndoc,1)='B' AND f.idcliente>0 and f.codt=<<goapp.tienda>>
		UNION ALL
		SELECT f.fech AS resu_fech,IF(f.mone='S',ABS(f.impo),ABS(f.impo*f.dolar)) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		INNER JOIN fe_ncven g ON g.ncre_idan=f.idauto
		INNER JOIN fe_rcom AS w ON w.idauto=g.ncre_idau
		WHERE f.acti='A' AND f.tdoc IN ('07','08') AND LEFT(f.ndoc,1) in('F','B') AND w.tdoc='03' AND f.idcliente>0 and f.codt=<<goapp.tienda>>) AS x)
		AS y GROUP BY resu_fech ORDER BY resu_fech) AS zz  WHERE resumen-enviados>=1
		Endtext
	Else

		Text To lC Noshow Textmerge
	    resu_fech,enviados,resumen,resumen-enviados,enviados-resumen
		FROM(SELECT resu_fech,CAST(SUM(enviados) AS DECIMAL(12,2)) AS enviados,CAST(SUM(resumen) AS DECIMAL(12,2))AS resumen FROM(
		SELECT resu_fech,CASE tipo WHEN 1 THEN resu_impo ELSE 0 END AS enviados,
		CASE tipo WHEN 2 THEN resu_impo ELSE 0 END AS Resumen,resu_mens,tipo FROM (
		SELECT resu_fech,resu_impo AS resu_impo,resu_mens,1 AS Tipo FROM fe_resboletas f
		WHERE  f.resu_acti='A' AND LEFT(resu_mens,1)='0'
		UNION ALL
		SELECT fech AS resu_fech,IF(mone='S',impo,impo*dolar) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		WHERE   f.acti='A' AND tdoc='03' AND LEFT(ndoc,1)='B' AND f.idcliente>0
		UNION ALL
		SELECT f.fech AS resu_fech,IF(f.mone='S',ABS(f.impo),ABS(f.impo*f.dolar)) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		INNER JOIN fe_ncven g ON g.ncre_idan=f.idauto
		INNER JOIN fe_rcom AS w ON w.idauto=g.ncre_idau
		WHERE f.acti='A' AND f.tdoc IN ('07','08') AND LEFT(f.ndoc,1)in('F','B') AND w.tdoc='03' AND f.idcliente>0 ) AS x)
		AS y GROUP BY resu_fech ORDER BY resu_fech) AS zz  WHERE resumen-enviados>=1
		Endtext
	Endif
	If EjecutaConsulta(lC, 'rbolne') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
*************************
Define Class cpe As Custom
	Function descargarxmldesdedata(carfile, nid)
	Local lC
*:Global cdr, cdrxml, crutaxml, crutaxmlcdr, cxml
	Text To lC Noshow Textmerge
      CAST(rcom_xml as char) as rcom_xml,CAST(rcom_cdr as char) as rcom_cdr FROM fe_rcom WHERE idauto=<<nid>>
	Endtext
	If EjecutaConsulta(lC, 'filess') < 1 Then
		Return
	Endif
	cdr = "R-" + carfile
	If Type('oempresa') = 'U' Then
		crutaxml	= Addbs(Sys(5) + Sys(2003) + '\Firmaxml') + carfile
		crutaxmlcdr	= Addbs(Sys(5) + Sys(2003) + '\SunatXML') + cdr
	Else
		crutaxml	= Addbs(Sys(5) + Sys(2003) + '\Firmaxml\' + Alltrim(Oempresa.nruc)) + carfile
		crutaxmlcdr	= Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc)) + cdr
	Endif
	If File(crutaxml) Then
*ocomx.ArchivoXml=Addbs(Sys(5)+Sys(2003)+'\FirmaXML\')+carfile
	Else
		If !Isnull(filess.rcom_xml) Then
*	cruta=Addbs(Sys(5)+Sys(2003))+'Firmaxml\'+carfile
			cxml = filess.rcom_xml
			Strtofile(cxml, crutaxml)
*	ocomx.ArchivoXml=cruta
		Else
			Messagebox("No se puede Obtener el Archivo XML de Env�o " + carfile, 16, MSGTITULO)
*	Return
		Endif
	Endif
	cdr = "R-" + carfile
	If File(crutaxmlcdr) Then
*ocomx.archivoxmlcdr=Addbs(Sys(5)+Sys(2003)+'\SunatXML\')+cdr
	Else
		If !Isnull(filess.rcom_cdr) Then
*cruta=Addbs(Sys(5)+Sys(2003))+'Sunatxml\'+cdr
			cdrxml = filess.rcom_cdr
			Strtofile(cdrxml, crutaxmlcdr)
*	ocomx.archivoxmlcdr=cruta
		Else
*Messagebox("No se puede Obtener el Archivo XML de Respuesta " + carfile, 16, MSGTITULO)
			Mensaje("No se puede Obtener el Archivo CDR")
		Endif
	Endif

	Endfunc
******
	Function descargarxmlguiadesdedata(carfile, nid)
	Local lC
*:Global cdr, cdrxml, crutaxml, crutaxmlcdr, cxml
	Text To lC Noshow Textmerge
       CAST(guia_xml AS CHAR) AS guia_xml,CAST(guia_cdr AS CHAR) AS guia_cdr FROM fe_guias WHERE guia_idgui=<<nid>>
	Endtext
	If EjecutaConsulta(lC, 'filess') < 1 Then
		Return
	Endif
	cdr = "R-" + carfile
	If Type('oempresa') = 'U' Then
		crutaxml	= Addbs(Sys(5) + Sys(2003)) + 'Firmaxml\' + carfile
		crutaxmlcdr	= Addbs(Sys(5) + Sys(2003) + '\SunatXML\') + cdr
	Else
		crutaxml	= Addbs(Sys(5) + Sys(2003)) + 'Firmaxml\' + Alltrim(Oempresa.nruc) + "\" + carfile
		crutaxmlcdr	= Addbs(Sys(5) + Sys(2003)) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\" + cdr
	Endif

	If File(crutaxml) Then
*ocomx.ArchivoXml=Addbs(Sys(5)+Sys(2003)+'\FirmaXML\')+carfile
	Else
		If !Isnull(filess.guia_xml) Then
*	cruta=Addbs(Sys(5)+Sys(2003))+'Firmaxml\'+carfile
			cxml = filess.guia_xml
			Strtofile(cxml, crutaxml)
*	ocomx.ArchivoXml=cruta
		Else
			Messagebox("No se puede Obtener el Archivo XML de Env�o", 16, MSGTITULO)
*	Return
		Endif
	Endif
	cdr = "R-" + carfile
	If File(crutaxmlcdr) Then

	Else
		If !Isnull(filess.guia_cdr) Then

			cdrxml = filess.guia_cdr
			Strtofile(cdrxml, crutaxmlcdr)
		Else
			Messagebox("No se puede Obtener el Archivo XML de Respuesta", 16, MSGTITULO)
		Endif
	Endif

	Endfunc
Enddefine
**************************
Function CreatemporalVentasPsys3(Calias)
Create Cursor precios(Precio N(8, 2), coda N(8), iden N(1), Nitem N(2))
Create Cursor (Calias)(coda N(8), Desc c(120), Unid c(4), Prec N(13, 8), cant N(10, 4), ;
	  Ndoc c(12), Nreg N(8), alma N(10, 2), pre1 N(8, 2), pre2 N(8, 2), Pre3 N(8, 2), ;
	  pos N(2), come N(7, 3), Comc N(7, 3), prem N(8, 2), premax N(8, 2), costo N(10, 2), calma c(3), uno N(10, 2), Dos N(10, 2), costoRef N(12, 4), ;
	  Nitem N(3), Valida c(1), Impo N(10, 2), Acti c(1), tipro c(1), idcosto N(10), aprecios c(1), Modi c(1), cletras c(120), ;
	  perc N(5, 2), Precio N(13, 8), perc1 N(5, 2), hash c(30), fech d, codc N(5), Guia c(10), Direccion c(120), dni c(8), Forma c(30), fono c(15), ;
	  dias N(3), razon c(120), nruc c(11), Mone c(1) Default 'S', Ndo2 c(12), Form c(30), nint N(2), caant N(10, 2), comi N(8, 4), ;
	  Referencia c(120), Vendedor c(50), fechav d, copia c(1), Archivo c(120), Tigv N(5, 2), Idauto N(12), IDautoP N(12), Tdoc c(2), ;
	  valida1 c(1), ticbper N(6, 2), coda1 c(15), icbper N(6, 2), precio1 N(13, 8), valor N(12, 2), igv N(12, 2), saldo N(12, 2), Total N(12, 2), ;
	  coddetrac c(10), detraccion N(10, 2), idalma N(3), anticipo N(10, 2), refanticipo c(60), Tienda c(10), ctda c(10), Codigo1 c(15), tda N(2))



*!*	Create Cursor (calias)(coda N(8),Desc c(150),unid c(4),Prec N(14,8),cant N(10,3),;
*!*		ndoc c(12),nreg N(8),alma N(10,2),pre1 N(8,2),pre2 N(8,2),pre3 N(8,2),Impo N(12,2),;
*!*		pos N(2),comi N(7,3),prem N(8,2),premax N(8,2),costo N(10,2),calma c(3),uno N(10,2),Dos N(10,2),tre N(12,2),cua N(12,2),;
*!*		nitem N(3),Valida c(1),Acti c(1),tipro c(1),idcosto N(10),hash c(30),fech d,codc N(5),guia c(10),direccion c(120),;
*!*		dni c(8),Forma c(30),fono c(15),vendedor c(60),dias N(3),razon c(120),nruc c(11),Mone c(1) Default 'S',ndo2 c(12),Form c(30),;
*!*		aprecios c(1),Modi c(1),cletras c(120),SerieProducto c(60),idseriep N(5),valida1 c(1),codigo1 c(20),;
*!*		referencia c(120),fechav d,codigof c(40),idseriex N(5),fect d,valor N(12,2),igv N(12,2),Total N(12,2),gratuita N(12,2),;
*!*		exon N(12,2),grati c(1),costoref N(10,2),tienda c(10),ctda c(10),ticbper N(6,2),icbper N(6,2),retencion N(10,2),tda n(2),coda1 c(20),caant N(10,2))

*!*		

Select (Calias)
Index On Desc Tag Descri
Index On Nitem Tag Items
Endfunc
*************************
Function inactividad()
Clear
Public tmrCheck
tmrCheck = Newobject("DetectActivity")
Return


Define Class DetectActivity As Timer
* S�lo detecta inactividad mientras est� en este programa?
	JustInThisApp = .T.
* Intervalo de inactividad tras el cual dispara OnInactivity (en segundos)
	InactivityInterval = 5
* Intervalo cada el que chequea actividad
	Interval	  = 1000
	LastCursorPos = ""
	LastKeybState = ""
	LastActivity  = Datetime()
	CursorPos	  = ""
	KeybState	  = ""
	IgnoreNext	  = .T.

	Procedure Init
	Declare Integer GetKeyboardState In WIN32API String @ sStatus
	Declare Integer GetCursorPos In WIN32API String @ sPos
	Declare Integer GetForegroundWindow In WIN32API
	Endproc

	Procedure Destroy
	Clear Dlls GetKeyboardState, GetCursorPos, GetForegroundWindow
	Endproc

	Procedure Timer
	With This
		If ! .CheckActivity()
* Si no hubo actividad veo si es tiempo de disparar OnInactivity
			If ! Isnull(.LastActivity) And ;
					Datetime() - .LastActivity > .InactivityInterval
				.LastActivity = Null && Prevengo disparo m�ltiple de OnInactivity
				.OnInactivity()
			Endif
		Endif
	Endwith
	Endproc

* Chequeo si hay actividad
	Procedure CheckActivity
	Local lRet
	With This
		If .JustInThisApp
			If GetForegroundWindow() <> _vfp.HWnd
* Estoy en otro programa
				Return lRet
			Endif
		Endif
		.GetCurState()
		If (!.CursorPos == .LastCursorPos Or !.KeybState == .LastKeybState)
			If ! .IgnoreNext && La 1ra vez no ejecuto
				lRet = .T. && Hubo actividad
				.OnActivity()
				.LastActivity = Datetime()
			Else
				.IgnoreNext = .F.
			Endif
			.LastCursorPos = .CursorPos
			.LastKeybState = .KeybState
		Endif
	Endwith
	Return lRet
	Endproc

* Devuelve el estado actual
	Procedure GetCurState
	Local sPos, sState
	With This
		sPos   = Space(8)
		sState = Space(256)
		GetCursorPos (@sPos)
		GetKeyboardState (@sState)
		.CursorPos = sPos
		.KeybState = sState
	Endwith
	Endproc

	Procedure OnInactivity
	Wait Window "Inactividad a las " + Time() Nowait
	Endproc

* Hubo actividad
	Procedure OnActivity
	Wait Window "Actividad a las " + Time() Nowait
	Endproc
Enddefine



**********************************
Function Cmes(dFecha)
*:Global aMeses[1]
If Type('dFecha') # 'D'	Or Empty(dFecha)
	Return ''
Endif
Local cDevuelve
Store '' To cDevuelve
Dimension aMeses(12)
aMeses(1)  = 'Enero'
aMeses(2)  = 'Febrero'
aMeses(3)  = 'Marzo'
aMeses(4)  = 'Abril'
aMeses(5)  = 'Mayo'
aMeses(6)  = 'Junio'
aMeses(7)  = 'Julio'
aMeses(8)  = 'Agosto'
aMeses(9)  = 'Septiembre'
aMeses(10) = 'Octubre'
aMeses(11) = 'Noviembre'
aMeses(12) = 'Diciembre'
cDevuelve  = aMeses(Month(dFecha))
Return cDevuelve
Endfunc
***********************************
Function Cdia(dFecha)
*:Global adias[1]
If Type('dFecha') # 'D'	Or Empty(dFecha)
	Return ''
Endif
Local cDevuelve
Store '' To cDevuelve
Dimension adias(7)
adias(1)  = 'Domingo'
adias(2)  = 'Lunes'
adias(3)  = 'Martes'
adias(4)  = 'Miercoles'
adias(5)  = 'Jueves'
adias(6)  = 'Viernes'
adias(7)  = 'S�bado'
cDevuelve = adias(Dow(dFecha))
Return cDevuelve
Endfunc
*****************************
Function PermiteIngresox(np1)
Local lC, lp
*:Global ccursor
lC			 = "FUnVerificaBloqueo"
goApp.npara1 = np1
Ccursor		 = 'v'
Text To lp Noshow
     (?goapp.npara1)
Endtext
If EJECUTARf(lC, lp, Ccursor) = 0 Then
	Errorbd(ERRORPROC + ' No Se Puede Obtener el estado del Bloqueo para este Registro')
	Return 0
Else
	Return v.Id
Endif
Endfunc
*****************************
*!*	Function PermiteIngresox(np1)
*!*	lc="FUnVerificaBloqueo"
*!*	goapp.npara1=np1
*!*	ccursor='v'
*!*	TEXT to lp noshow
*!*	     (?goapp.npara1)
*!*	ENDTEXT
*!*	If EJECUTARF(lc,lp,ccursor)<1 Then
*!*		errorbd(ERRORPROC+ ' No Se Puede Obtener el estado del Bloqueo para este Registro')
*!*		Return 0
*!*	Else
*!*		Return v.Id
*!*	Endif
*!*	Endfunc


*****************************
Function  ObtieneCtasPrincipales()
Local lp
*:Global cur, na
cur	= "Ctaspr"
Na	= Val(goApp.a�o)
If Na >= 2020 Then
	Text To lp Noshow Textmerge
     pcta as ctap,GROUP_CONCAT(TRIM(nomb)) AS nomb FROM (
     SELECT LEFT(ncta,2) AS pcta,nomb FROM fe_plan WHERE plan_acti='A' AND RIGHT(ncta,2)='00' ORDER BY pcta) AS p GROUP BY pcta
	Endtext
* SELECT ctap,ctasunat,nomb,idcta from(
*    select plan_ncta as ncta,left(plan_ncta,2) as ctap,ctasunat,nomb,idcta from fe_plan where right(plan_ncta,2)="00" order by ncta) as x group by ctap
Else
	Text To lp Noshow Textmerge
      pcta as ctap,GROUP_CONCAT(TRIM(nomb)) AS nomb FROM (
      SELECT LEFT(ncta,2) AS pcta,nomb FROM fe_plan WHERE plan_acti='A' AND RIGHT(ncta,2)='00' ORDER BY pcta) AS p GROUP BY pcta
	Endtext
Endif
If EjecutaConsulta(lp, cur) <= 0 Then
	Return 0
Else
	Return 1
Endif
Endproc
************************
Define Class DetectActivity As Timer
* S�lo detecta inactividad mientras est� en este programa?
	JustInThisApp = .T.
* Intervalo de inactividad tras el cual dispara OnInactivity (en segundos)
	InactivityInterval = 5
* Intervalo cada el que chequea actividad
	Interval	  = 1000
	LastCursorPos = ""
	LastKeybState = ""
	LastActivity  = Datetime()
	CursorPos	  = ""
	KeybState	  = ""
	IgnoreNext	  = .T.

	Procedure Init
	Declare Integer GetKeyboardState In WIN32API String @ sStatus
	Declare Integer GetCursorPos In WIN32API String @ sPos
	Declare Integer GetForegroundWindow In WIN32API
	Endproc

	Procedure Destroy
	Clear Dlls GetKeyboardState, GetCursorPos, GetForegroundWindow
	Endproc

	Procedure Timer
	With This
		If ! .CheckActivity()
* Si no hubo actividad veo si es tiempo de disparar OnInactivity
			If ! Isnull(.LastActivity) And ;
					Datetime() - .LastActivity > .InactivityInterval
				.LastActivity = Null && Prevengo disparo m�ltiple de OnInactivity
				.OnInactivity()
			Endif
		Endif
	Endwith
	Endproc

* Chequeo si hay actividad
	Procedure CheckActivity
	Local lRet
	With This
		If .JustInThisApp
			If GetForegroundWindow() <> _vfp.HWnd
* Estoy en otro programa
				Return lRet
			Endif
		Endif
		.GetCurState()
		If (!.CursorPos == .LastCursorPos Or !.KeybState == .LastKeybState)
			If ! .IgnoreNext && La 1ra vez no ejecuto
				lRet = .T. && Hubo actividad
				.OnActivity()
				.LastActivity = Datetime()
			Else
				.IgnoreNext = .F.
			Endif
			.LastCursorPos = .CursorPos
			.LastKeybState = .KeybState
		Endif
	Endwith
	Return lRet
	Endproc

* Devuelve el estado actual
	Procedure GetCurState
	Local sPos, sState
	With This
		sPos   = Space(8)
		sState = Space(256)
		GetCursorPos (@sPos)
		GetKeyboardState (@sState)
		.CursorPos = sPos
		.KeybState = sState
	Endwith
	Endproc

	Procedure OnInactivity
	Wait Window "Inactividad a las " + Time()
	Endproc

* Hubo actividad
	Procedure OnActivity
	Wait Window "Actividad a las " + Time()
	Endproc
Enddefine
*============================================================
* Detects user activity and fires an event after the
* specified period of inactivity.
*============================================================
Define Class InactivityTimer As Timer

*----------------------------------------------------------
* API constants
*----------------------------------------------------------

	#Define WM_KEYUP                        0x0101

	#Define WM_SYSKEYUP                     0x0105

	#Define WM_MOUSEMOVE                    0x0200

	#Define GWL_WNDPROC         (-4)

*----------------------------------------------------------
* internal properties
*----------------------------------------------------------
	nTimeOutInMinutes = 0
	tLastActivity	  = {/:}
	nOldProc		  = 0

*----------------------------------------------------------
* Timer configuration
*----------------------------------------------------------
	Interval = 30000
	Enabled	 = .T.

*------------------------------------------------------------
* Listen to API events when the form starts. You can pass
* the timeout as a parameter.
*------------------------------------------------------------
	Procedure Init(tnTimeOutInMinutes)
	Declare Integer GetWindowLong In WIN32API ;
		Integer HWnd, ;
		Integer nIndex
	Declare Integer CallWindowProc In WIN32API ;
		Integer lpPrevWndFunc, ;
		Integer HWnd, Integer Msg, ;
		Integer wParam, ;
		Integer Lparam
	This.nOldProc = GetWindowLong(_vfp.HWnd, GWL_WNDPROC)
	If Vartype(m.tnTimeOutInMinutes) == "N"
		This.nTimeOutInMinutes = m.tnTimeOutInMinutes
	Endif
	This.tLastActivity = Datetime()
	Bindevent(0, WM_KEYUP, This, "WndProc")
	Bindevent(0, WM_MOUSEMOVE, This, "WndProc")
	Endproc

*------------------------------------------------------------
* Stop listening
*------------------------------------------------------------
	Procedure Unload
	Unbindevents(0, WM_KEYUP)
	Unbindevents(0, WM_MOUSEMOVE)
	Endproc

*------------------------------------------------------------
* Every event counts as activity
*------------------------------------------------------------
	Procedure WndProc( ;
		  HWnd As Long, Msg As Long, wParam As Long, Lparam As Long )
	This.tLastActivity = Datetime()
	_Screen.Caption	   = Str(Val(_Screen.Caption) + 1)
	Return CallWindowProc(This.nOldProc, HWnd, Msg, wParam, Lparam)

*------------------------------------------------------------
* Check last activity against time out
*------------------------------------------------------------
	Procedure Timer
	Local ltFireEvent
	ltFireEvent = This.tLastActivity + 60 * This.nTimeOutInMinutes
	If Datetime() > m.ltFireEvent
		This.eventTimeout()
	Endif
	Endproc

*------------------------------------------------------------
* Override this event or bind to it to respond to user
* inactivity. You can change the nTimeOutInMinutes to offer
* multiple stages of timeouts.
*------------------------------------------------------------
	Procedure eventTimeout

Enddefine
****************************
*Public goForm
*goForm = CreateObject("InactivityDemo")

Define Class InactivityDemo As InactivityTimer
	Procedure Init
	DoDefault(1)
	Procedure eventTimeout
	Messagebox("Timeout!")
Enddefine
******************************
Function Color2RGBpair
* Returns color pair as "RGB(cRed,cGreen,cBlue,cRed,cGreen,cBlue)" from the numeric value of the color.
* Based on function Color2RGB_1 by ???
Lparameters tnColorFore, tnColorBack
Return Strtran("RGB(" + ;
	  Str(tnColorFore % 256, 3) + "," + ;
	  Str(Floor(tnColorFore % 256^2 / 256), 3) + "," + ;
	  Str(Floor(tnColorFore / 256^2), 3) + "," + ;
	  Str(tnColorBack % 256, 3) + "," + ;
	  Str(Floor(tnColorBack % 256^2 / 256), 3) + "," + ;
	  Str(Floor(tnColorBack / 256^2), 3) + ;
	  ")", " ", "")
Endfunc
***************************
Function  ValidarSerie(Cserie)
Local Vdvto
*:Global cvalor, x
Vdvto = 1
For x = 1 To Len(Cserie)
	cvalor = Substr(Cserie, x, 1)
	If Asc(cvalor) <= 47 Or (Asc(cvalor) >= 58 And Asc(cvalor) <= 64) Or (Asc(cvalor) >= 91 And Asc(cvalor) <= 96) Or  Asc(cvalor) >= 122  Then
		Vdvto = 0
		Exit
	Endif
Next
Return Vdvto
Endfunc
*****************************
Function MuestraAlmacenesx(Ccursor)
Set Procedure To d:\capass\modelos\tiendas Additive
obt = Createobject("tienda")
If obt.Muestratiendas(Ccursor) < 1 Then
	goApp.mensjeApp = obt.Cmensaje
	Return 0
Endif
Return 1
Endfunc
*******************************
Function MuestraAlmacenes()
If MuestraAlmacenesx('almacenes') < 1 Then
	Return 0
Endif
Return 1
Endfunc
*******************************
Function ConsultaApisunat
Lparameters cTdoc, Cserie, cnumero, dFecha, nimpo

Local Obj As "empty"
Local oHTTP As "MSXML2.XMLHTTP"
Local lcHTML
Obj		  = Createobject("empty")
pURL_WSDL = "http://companiasysven.com/ccpe.php"
If Type('oempresa') = 'U' Then
	Cruc = fe_gene.nruc
Else
	Cruc = Oempresa.nruc
Endif
*MESSAGEBOX(cruc,16,'Hola')
Text To cdata Noshow Textmerge
	{
	"ruc":"<<cruc>>",
	"tdoc":"<<ctdoc>>",
	"serie":"<<cserie>>",
	"cndoc":"<<cnumero>>",
	"cfecha":"<<dfecha>>",
	"cimporte":"<<nimpo>>"
	}
Endtext
*!*	wait WINDOW cserie
*!*	wait WINDOW cnumero
*!*	MESSAGEBOX(cdata)
oHTTP = Createobject("MSXML2.XMLHTTP")
oHTTP.Open("post", pURL_WSDL, .F.)
oHTTP.setRequestHeader("Content-Type", "application/json")
oHTTP.Send(cdata)
If oHTTP.Status <> 200 Then
	AddProperty(Obj, "vdvto", '-1')
	AddProperty(Obj, "mensaje", "Servicio WEB NO Disponible....." + Alltrim(Str(oHTTP.Status)))
	Return Obj
Endif
lcHTML = oHTTP.responseText
*MESSAGEBOX(lcHTML)
If Left(Alltrim(lcHTML), 1) <> '{' Then
	AddProperty(Obj, "vdvto", -1)
	AddProperty(Obj, "estadoruc", "")
	AddProperty(Obj, "estadodom", "")
	AddProperty(Obj, "mensaje", "No hay Respuesta de SUNAT")
Else
	Set Procedure To d:\Librerias\nfJsonRead.prg Additive
	ocomp = nfJsonRead(lcHTML)
	AddProperty(Obj, "vdvto", ocomp.estadocomprobante)
	AddProperty(Obj, "estadoruc", ocomp.estadoruc)
	AddProperty(Obj, "estadodom", ocomp.condomicilio)
	AddProperty(Obj, "mensaje", ocomp.Mensaje)
Endif
Return Obj
Endfunc
*******************************
Function ConsultaApisunat1
Local Obj As "empty"
Local oHTTP As "MSXML2.XMLHTTP"
Local lcHTML
*:Global cdata, cruc, cvalor, ocomp, pURL_WSDL
Obj		  = Createobject("empty")
pURL_WSDL = "http://companiasysven.com/apisunat1.php"
If Type('oempresa') = 'U' Then
	Cruc = fe_gene.nruc
Else
	Cruc = Oempresa.nruc
Endif
*MESSAGEBOX(cruc,16,'Hola')
Text To cdata Noshow Textmerge
	{
	"ruc":"<<cruc>>",
	"ndoc":"<<cndoc>>",
	"tdoc":"<<ctdoc>>",
	"fech":"<<dfehae>>",
	"impo":"<<nimpo>>",
	"ticket":"<<cticket>",
	"idauto":"<<nidauto>>"
	}
Endtext

oHTTP = Createobject("MSXML2.XMLHTTP")
oHTTP.Open("post", pURL_WSDL, .F.)
oHTTP.setRequestHeader("Content-Type", "application/json")
oHTTP.Send(cdata)
If oHTTP.Status <> 200 Then
	Messagebox("Servicio WEB NO Disponible....." + Alltrim(Str(oHTTP.Status)), 16, MSGTITULO)
	AddProperty(Obj, "vdvto", '-1')
	Return Obj
Endif
lcHTML = oHTTP.responseText
*MESSAGEBOX(lcHTML,16,'hola')
Set Procedure To d:\Librerias\json Additive
ocomp = json_decode(lcHTML)
If Not Empty(json_getErrorMsg())
	Messagebox("No se Pudo Obtener la Informaci�n " + json_getErrorMsg(), 16, MSGTITULO)
	AddProperty(Obj, "vdvto", '-1')
	Return Obj
Endif
*Wait Window 'hola 1'
cvalor = Iif(Isnull(ocomp.Get("rpta")), '-1', ocomp.Get("rpta"))
AddProperty(Obj, "vdvto", cvalor)
*Wait Window 'hola 2'
AddProperty(Obj, "token", ocomp.Get("token"))
AddProperty(Obj, "mensaje", ocomp.Get("mensaje"))
Return Obj
Endfunc
*******************************
Function ConsultaApisunat2
Lparameters cTdoc, Cserie, cnumero, dFecha, nimpo, token
Local Obj As "empty"
Local oHTTP As "MSXML2.XMLHTTP"
Local lcHTML
*:Global cdata, cruc, cvalor, ocomp, pURL_WSDL
Obj		  = Createobject("empty")
pURL_WSDL = "http://companiasysven.com/apisunat2.php"
If Type('oempresa') = 'U' Then
	Cruc = fe_gene.nruc
Else
	Cruc = Oempresa.nruc
Endif
*MESSAGEBOX(cruc,16,'Hola')
Text To cdata Noshow Textmerge
	{
	"ruc":"<<cruc>>",
	"tdoc":"<<ctdoc>>",
	"serie":"<<cserie>>",
	"cndoc":"<<cnumero>>",
	"cfecha":"<<dfecha>>",
	"cimporte":"<<nimpo>>",
	"ctoken":"<<token>>"
	}
Endtext
oHTTP = Createobject("MSXML2.XMLHTTP")
oHTTP.Open("post", pURL_WSDL, .F.)
oHTTP.setRequestHeader("Content-Type", "application/json")
oHTTP.Send(cdata)
If oHTTP.Status <> 200 Then
	Messagebox("Servicio WEB NO Disponible....." + Alltrim(Str(oHTTP.Status)), 16, MSGTITULO)
	AddProperty(Obj, "vdvto", '-1')
	AddProperty(Obj, "mensaje", "Servicio WEB NO Disponible....." + Alltrim(Str(oHTTP.Status)))
	Return Obj
Endif
lcHTML = oHTTP.responseText
Set Procedure To d:\Librerias\json Additive
ocomp = json_decode(lcHTML)
If Not Empty(json_getErrorMsg())
	Messagebox("No se Pudo Obtener la Informaci�n " + json_getErrorMsg(), 16, MSGTITULO)
	AddProperty(Obj, "vdvto", '-1')
	AddProperty(Obj, "mensaje", "No se Puede leer la respuesta")
	Return Obj
Endif
cvalor = Iif(Isnull(ocomp.Get("estadocomprobante")), '-1', ocomp.Get("estadocomprobante"))
AddProperty(Obj, "vdvto", cvalor)
AddProperty(Obj, "estadoruc", ocomp.Get("estadoruc"))
AddProperty(Obj, "estadodom", ocomp.Get("condomicilio"))
AddProperty(Obj, "mensaje", ocomp.Get("mensaje"))

*MESSAGEBOX(Obj.vdvto,16,'hola 1')
*MESSAGEBOX(ocomp.Get("estadocomprobante"),16,'hola 2')
Return Obj
Endfunc
*******************************
Function consultarticket2000(cticket)
odvto = ConsultaApisunat1()
If odvto.Vdvto = '0' Then
	np3		= "0 El Resumen de Boletas ha sido aceptado desde APISUNAT"
	ctoken = ovdvto.token
	dfenvio	= cfechas(fe_gene.fech)
	Text To lcr Noshow Textmerge
     UPDATE fe_resboletas SET resu_mens='<<np3>>',resu_feen=CURDATE() WHERE resu_tick='<<cticket>>';
	Endtext
	ncon = AbreConexion()
	Sw	 = 1
	Select * From rmvtos Where Alltrim(rmvtos.resu_tick) = cticket Into Cursor ax
	Select ax
	Go Top
	Scan All
		ndesde = ax.resu_desd
		nhasta = ax.resu_hast
		cTdoc  = ax.resu_tdoc
		Cserie = ax.resu_serie
		Text To lC Noshow
			Select  idauto,numero,tdoc,fech,Impo,ndoc From(Select  idauto,ndoc,Cast(mid(ndoc, 5) As unsigned) As numero,tdoc,fech,Impo
							From fe_rcom F 	Where tdoc = ?ctdoc And Acti = 'A' 	And idcliente > 0) As x Where numero Between ?ndesde
					And ?nhasta  and Left(ndoc, 4) = ?cserie
		Endtext
		If SQLExec(ncon, lC, 'crb') < 0 Then
			Errorbd(lC)
			Sw = 0
			Exit
		Endif
		Select crb
		Go Top
		Scan All
			np1	  = crb.Idauto
			od = ConsultaApisunat2(crb.Tdoc, Left(crb.Ndoc, 4), Substr(crb.Ndoc, 5), Dtoc(crb.fech), Alltrim(Str(crb.Impo, 12, 2)), ctoken)
			If od.Vdvto = '1' Then
				Mensaje(od.Mensaje)
				crpta = od.Mensaje
				Text  To lC Noshow Textmerge Pretext 7
                     UPDATE fe_rcom SET rcom_mens='<<crpta>>',rcom_fecd='<<dfenvio>>' WHERE idauto=<<np1>>
				Endtext
				If Ejecutarsql(lC) < 1 Then
					Sw = 0
					Exit
				Endif
			Else
				If od.Vdvto = '7' Then
					Mensaje("No se puede Obtener Respuesta desde el Servidor...no Existen las Credenciales de API SUNAT")
				Else
					Mensaje(" Respuesta del Servidor " + Alltrim(od.Mensaje))
				Endif
				Sw = 0
				Exit
			Endif
		Endscan
		Select ax
	Endscan
	If Sw = 1 Then
		If Ejecutarsql(lcr) < 1 Then
			Return 0
		Endif
		CierraConexion(ncon)
		Mensaje("Proceso Culminado Correctamente")
		Return 1
	Else
		Return 0
	Endif
Else
	Mensaje(odvto.Mensaje)
Endif
Endfunc
*****************************
Function consultarticket1000(cticket)
Local lC, lcr
*:Global cserie, ctdoc, dfenvio, ndesde, nhasta, np1, np3, odvto, sw
np3		= "0 El Resumen de Boletas ha sido aceptado desde API-SUNAT"
dfenvio	= cfechas(fe_gene.fech)
Text To lcr Noshow Textmerge
   UPDATE fe_resboletas SET resu_mens='<<np3>>',resu_feen=CURDATE() WHERE resu_tick='<<cticket>>';
Endtext
Sw	 = 1
Select * From rmvtos Where Alltrim(rmvtos.resu_tick) = cticket Into Cursor ax
Select ax
Go Top
Scan All
	ndesde = ax.resu_desd
	nhasta = ax.resu_hast
	cTdoc  = ax.resu_tdoc
	If cTdoc = '07' Or cTdoc = '08' Then
		Cserie = Iif(cTdoc = '07', 'FN', 'FD') + Substr(ax.resu_serie, 3, 2)
	Else
		Cserie = ax.resu_serie
	Endif
	Text To lC Noshow
			Select  idauto,	numero,tdoc,fech,Impo,ndoc FROM (Select  idauto,	ndoc,Cast(mid(ndoc, 5) As unsigned) As numero,tdoc,	fech,Impo From fe_rcom F
			Where tdoc = ?ctdoc And Acti = 'A'  And idcliente > 0 and impo<>0) As x where numero Between ?ndesde And ?nhasta And Left(ndoc, 4) = ?cserie order by ndoc
	Endtext
	If SQLExec(goApp.bdConn, lC, 'crb') < 1 Then
		Errorbd(lC)
		Sw = 0
		Exit
	Endif
	Select crb
	Go Top
	Scan All
		np1	  = crb.Idauto
		If (crb.Tdoc = '07' Or crb.Tdoc = '08') Then
			If Left(crb.Ndoc, 1) = 'F' Then
				cseriedcto = Iif(crb.Tdoc = '07', 'BC', 'BD') + Substr(crb.Ndoc, 3, 2)
			Else
				cseriedcto = Left(crb.Ndoc, 4)
			Endif
		Else
			cseriedcto = Left(crb.Ndoc, 4)
		Endif
		odvto = ConsultaApisunat(crb.Tdoc, cseriedcto, Trim(Substr(crb.Ndoc, 5)), Dtoc(crb.fech), Alltrim(Str(Abs(crb.Impo), 12, 2)))
		If odvto.Vdvto = '1' Then
			Mensaje(odvto.Mensaje + ' ' + crb.Ndoc)
			Text  To lC Noshow Textmerge Pretext 7
               UPDATE fe_rcom SET rcom_mens='<<np3>>',rcom_fecd='<<dfenvio>>' WHERE idauto=<<np1>>
			Endtext
			If Ejecutarsql(lC) < 1 Then
				Sw = 0
				Exit
			Endif
		Else
			Messagebox(Alltrim(odvto.Mensaje) + ' ' + crb.Ndoc, 16, MSGTITULO)
			Sw = 0
			Exit
		Endif
	Endscan
	Select ax
Endscan
If Sw = 1 Then
	If Ejecutarsql(lcr) < 1 Then
		Return 0
	Endif
*CierraConexion(ncon)
	Mensaje("Proceso Culminado Correctamente")
	Return 1
Else
	Return 0
Endif
Endfunc
*****************************
Procedure DEshacerCambios(Cmensaje)
*:Global cmensaje10
If SQLExec(goApp.bdConn, "ROLLBACK") < 1
	Errorbd("Error al Deshacer Cambios")
Else
	If Vartype(Cmensaje) = 'L'
		cmensaje10 = "Inconvenientes al Grabar datos"
	Else
		cmensaje10 = Cmensaje
	Endif
	Messagebox(cmensaje10, 16, 'SISVEN')
Endif
Endproc
***************************************
Procedure GRabarCambios()
If SQLExec(goApp.bdConn, "COMMIT") < 1
	Errorbd("Error al Confirmar Grabaci�n de Datos")
	Return 0
Else
	Return 1
Endif
Endproc
******************************************
Function IniciaTransaccion
If VERIFICACONEXION() = 0 Then
	Return 0
Endif
If SQLExec(goApp.bdConn, "SET TRANSACTION ISOLATION LEVEL READ COMMITTED") < 0 Then
	Errorbd("No se Pudo Iniciar Las Transacciones")
	Return 0
Else
	If SQLExec(goApp.bdConn, "START TRANSACTION") < 0 Then
		Errorbd("No se Pudo Iniciar Las Transacciones")
		Return 0
	Endif
Endif
Return 1
Endfunc
*******************************************
Function ActualizaMargenesVtasyfletes(np1, np2, np3, np4, np5)
Local lC, lp
*:Global ccur
lC			 = "ProActualizaMargenesVta"
goApp.npara1 = np1
goApp.npara2 = np2
goApp.npara3 = np3
goApp.npara4 = np4
goApp.npara5 = np5
ccur		 = ""
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
Endtext
If EJECUTARP(lC, lp, ccur) = 0 Then
	Errorbd(ERRORPROC + ' No Se Puede Actualizar Margenes de Ventas')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************************
Function CreaTemporalOcompra(Calias)
Create Cursor (Calias)(coda N(8), Descri c(150), Unid c(4), cant N(10, 3), Prec N(13, 3), d1 N(7, 4), Nreg N(8), Ndoc c(10), Nitem N(5), uno N(10, 2), Dos N(10, 2), ;
	  Incluido c(1), Razo c(120), aten c(120), Moneda c(20), facturar c(200), despacho c(200), Forma c(100), observa c(200), fech d, ;
	  tipro c(1), come N(8, 2), Comc N(8, 2), tre N(10, 2), cua N(10, 2), cin N(10, 2), sei N(10, 2), Codigo c(20), Peso N(10, 5))
Select (Calias)
Index On Descri Tag Descri
Index On Nitem Tag Items
Endfunc
******************************
Function ValidarTemporalVtas(Calias)
Local Sw As Integer
*:Global cmensaje
Sw		 = 1
Cmensaje = ""
Select (Calias)
Scan All
	Do Case
	Case costo <= 0 And tipro = 'K' And grati <> 'S'
		Sw		 = 0
		Cmensaje = "No hay Costo del Producto: " + Rtrim(Desc)
		Exit
	Case (cant * Prec) <= 0 And tipro = 'K' And grati <> 'S'
		Sw		 = 0
		Cmensaje = "Ingrese Cantidad O Precio para El Producto: " + Rtrim(Desc)
		Exit
	Case Prec < costo And aprecios <> 'A' And grati <> 'S'
		Sw		 = 0
		Cmensaje = "El Producto: " + Rtrim(Desc) + " Tiene Un precio Por Debajo del Costo y No esta Autorizado para hacer esta Venta"
		Exit
	Case cant * costo <= 0 And grati = 'S' And Prec = 0
		Cmensaje = "El Item: " + Alltrim(Desc) + " No Tiene Cantidad o Costo para la Transferencia Gratuita"
		Sw		 = 0
	Endcase
Endscan
If Sw = 0 Then
	Messagebox(Cmensaje, 16, MSGTITULO)
	Return 0
Else
	Return 1
Endif
Endfunc
******************************
Function AgregaCuotasCredito()
*:Global cpropiedad1, cpropiedad2, cpropiedad3, i
For i = 1 To 5 Next
	cpropiedad1	= "cuota" + Alltrim(Str(i))
	cpropiedad2	= "fvto" + Alltrim(Str(i))
	cpropiedad3	= "monto" + Alltrim(Str(i))
	goApp.AddProperty(cpropiedad1, "")
	goApp.AddProperty(cpropiedad2, '')
	goApp.AddProperty(cpropiedad3, '')
Endfor
Endfunc
******************************
Function LimpiarCuotasCredito()
Local valorpropiedad As String
*:Global cpropiedad1, cpropiedad2, cpropiedad3, i
valorpropiedad = ""
For i = 1 To 5 Next
	cpropiedad1	   = "cuota" + Alltrim(Str(i))
	cpropiedad2	   = "fvto" + Alltrim(Str(i))
	cpropiedad3	   = "monto" + Alltrim(Str(i))
	valorpropiedad = "goapp." + cpropiedad1 + '=' + ['']
*	wait WINDOW valor
	Execscript(valorpropiedad)
	valorpropiedad = "goapp." + cpropiedad2 + '=' + ['']
*	wait WINDOW valor
	Execscript(valorpropiedad)
	valorpropiedad = "goapp." + cpropiedad3 + '=' + ['']
*    wait WINDOW valor
	Execscript(valorpropiedad)
Endfor
Endfunc
******************************
Function Asignavalorpropiedad(cpropiedad, cvalor)
*	ccuota="cuota"+Alltrim(Str(x))
*			cvalor=Right('0000'+Alltrim(Str(x)),3)
*			cpropiedad="goapp."+ccuota+'='+[']+cvalor+[']
*			Execscript(cpropiedad)
***************
*			cfvto="fvto"+Alltrim(Str(x))
*			cvalor=DTOC(tmpd.fvto)
*			cpropiedad="goapp."+ccuota+'='+[']+cvalor+[']
*			Execscript(cpropiedad)
***************
*			ccuota="monto"+Alltrim(Str(x))
*			cvalor=altrim(STR(tmpc.impo,12,2))
*			cpropiedad="goapp."+ccuota+'='+[']+cvalor+[']
*			Execscript(cpropiedad)

*:Global propiedad
propiedad = "goapp." + cpropiedad + '=' + ['] + cvalor + [']
Execscript(propiedad)
Endfunc
*****************************
Function Obtenercuotascredito(pkid)
Local lC
*:Global cpropiedad, cvalor, x
Text To lC Noshow  Textmerge
     ndoc,impo,fevto FROM fe_cred AS c
     INNER JOIN fe_rcred AS r
     ON r.`rcre_idrc`=c.`cred_idrc`
     WHERE rcre_idau=<<pkid>> and impo>0 AND acti='A'
Endtext
If EjecutaConsulta(lC, 'cuotascredito') < 1 Then
	Return 0
Endif
x = 1
Select cuotascredito
Scan All
	If x <= 5 Then
		cpropiedad = "cuota" + Alltrim(Str(x))
		cvalor	   = Right('0000' + Alltrim(Str(x)), 3)
		Asignavalorpropiedad(cpropiedad, cvalor)
		cpropiedad = "fvto" + Alltrim(Str(x))
		cvalor	   = Dtoc(cuotascredito.fevto)
		Asignavalorpropiedad(cpropiedad, cvalor)
		cpropiedad = "monto" + Alltrim(Str(x))
		cvalor	   = Alltrim(Str(cuotascredito.Impo, 12, 2))
		Asignavalorpropiedad(cpropiedad, cvalor)
	Endif
	x = x + 1
Endscan
Endfunc
***************************************
Function  ActualizaClienteRetenedor(np1, np2)
Local lC
Text To lC Noshow Textmerge
    UPDATE fe_clie SET clie_rete='<<np2>>' where idclie=<<np1>>
Endtext
If Ejecutarsql(lC) >= 1 Then
	Mensaje("Gurdado Ok")
	Return 1
Else
	Mensaje("No se pudo Grabar")
	Return 0
Endif
Endfunc
**************************************
Function IngresaDetalleVTaCunidad(np1, np2, np3, np4, np5, np6, np7, np8)
Local cur As String
Local lC, lp
lC			 = 'ProIngresaDetalleVta'
cur			 = ""
goApp.npara1 = np1
goApp.npara2 = np2
goApp.npara3 = np3
goApp.npara4 = np4
goApp.npara5 = np5
goApp.npara6 = np6
goApp.npara7 = np7
goApp.npara8 = np8
Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Ingresando Detalle de la Venta Por Servicios  ')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************************
Function CreatemporalCotizaciones(Calias)
Create Cursor precios(Precio N(14, 8), coda N(8), iden N(1), Nitem N(3))
Create  Cursor (Calias) (Descri c(120), Unid c(4), cant N(10, 3), Prec N(14, 8), Nreg N(8), idco N(8), ;
	  Ndoc c(10), prevta N(13, 5), Nitem N(5), alma N(10, 2), coda N(8), Valida c(1), pos N(5), costo N(13, 8), pre1 N(8, 2), pre2 N(8, 2), Pre3 N(8, 2), ;
	  uno N(10, 2), Dos N(10, 2), tre N(10, 2), cua N(10, 2), calma c(5), aprecios c(1), come N(7), a1 c(15), idped N(10), valida1 c (1), permitido N(1), ;
	  Direccion c(180), fono c(15), atencion c(100), vigv N(6, 4), Forma c(100), validez c(100), plazo c(100), entrega c(100), Detalle c(180), ;
	  nTotal N(12, 2), Mone c(1), garantia c(100), nruc c(11), nfax c(15), Comc N(7, 4), pmenor N(8, 2), pmayor N(8, 2), ;
	  contacto c(120), Transportista c(120), dire1 c(120), fono1 c(20), dias N(2), Vendedor c(100), tipro c(1), Item N(4), ;
	  codc N(6), razon c(120), fech d, Cod c(20), orden N(3), coda1 c(15), pre0 N(13, 8), cantoferta N(10, 2), precio1 N(13, 8), Tdoc c(2), swd N(1) Default 0, como N(7, 3), ;
	  Importe N(10, 2), idproy N(5), valor N(12, 2), igv N(12, 2), foco c(1) Default 'N', Form c(1), cantmayor N(8, 2))
Select  (Calias)
Index On Descri Tag Descri
Index On Nitem Tag Items
Endfunc
******************************************
Define Class W_CLASE_E_MAIL As Custom

	cAdjuntos		= ""                   && Archivos adjuntos que se enviar�n con el e-mail. Deben separarse con punto y coma (;)
	cContrasena		= ""                   && La contrase�a de quien env�a el e-mail. Requerido.
	cConCopia		= ""                   && Este e-mail se enviar� a varios destinatarios, cada uno de ellos ve los e-mails de los dem�s destinatarios
	cConCopiaOculta	= ""                   && Este e-mail se enviar� a varios destinatarios, ninguno de ellos ve los e-mails de los dem�s destinatarios
	cDestinatario	= ""                   && La direcci�n de e-mail a donde se env�a. Requerido.
	CmensajeError	= ""                   && Mensaje de error si no se pudo enviar el e-mail
	cPaginaHTML		= ""                   && Enlace a una p�gina web (puede ser una p�gina .HTML o solamente una imagen o un v�deo, etc.)
	cRemitente		= ""                       && La direcci�n de e-mail de quien lo env�a. Requerido.
	cSMTPServidor	= "mail.companysysven.com"     && El Servidor SMTP que se usar� para enviar el e-mail
	cTexto			= ""                   && Texto del e-mail que se enviar�. Requerido.
	cTitulo			= ""                   && T�tulo que tendr� el e-mail que se enviar�. Requerido.
	lConfirmacion	= .F.                  && Si se quiere recibir confirmaci�n de lectura
	lMostrarAviso	= .T.                  && Si se quiere que dentro de la clase se muestren mensajes de aviso al usuario, o no
	lSMTPAutenticar	= .T.                  && Si se requiere autenticaci�n o no
	lSMTPUsarSSL	= .T.                  && Si se necesita usar SSL. Se puede poner en .F. y This.nSMTPPuerto = 587
	nImportancia	= 1                    && Importancia de este e-mail       :  0 (baja)      , 1 (normal), 2 (alta)
	nPrioridad		= 0                    && Prioridad para enviar este e-mail: -1 (no urgente), 0 (normal), 1 (urgente)
	nSMTPPuerto		= 465                  && Se pueden usar: 465, 587, 25 (en este caso poner: This.lSMTPUsarSSL = .F.)
	nSMTPUsando		= 2                    && 1 = Se enviar� usando un directorio. 2 = Se enviar� usando un puerto. 3 = Se enviar� usando Exchange
*
*
	Function ENVIAR
	Local lcEsquema, loCDO, loMsg, loError, lnI, lcArchivo
	#Define KEY_ENTER Chr(13)


*WAIT WINDOW  'Hola Clave'+this.cContrasena
	If !Pemstatus(goApp, 'clavecorreo', 5)
		AddProperty(goApp, 'clavecorreo', '')
	Endif

	If  'companysysven.com' $  This.cRemitente  Then
		If Empty(goApp.clavecorreo)
			cPassword = SolicitaContrase�a(This.cRemitente)
			goApp.clavecorreo = cPassword
			If Empty(cPassword) Or Left(cPassword, 1) = 'N' Then
				This.CmensajeError = 'Correo No Encontrado'
				Return (.F.)
			Endif
			This.cContrasena = cPassword
		Else
			This.cContrasena = goApp.clavecorreo
		Endif
*WAIT WINDOW 'Hola '+cpassword
	Endif
*WAIT WINDOW  'Hola Clave'+this.cContrasena
	With This
		.VAlidar()
		If !Empty(.CmensajeError) Then
			Return (.F.)
		Endif
	Endwith
	Try
		lcEsquema = "http://schemas.microsoft.com/cdo/configuration/"
		loCDO	  = Createobject("CDO.Configuration")
		With loCDO.Fields
			.Item(lcEsquema + "smtpserver")		  = This.cSMTPServidor
			.Item(lcEsquema + "smtpserverport")	  = This.nSMTPPuerto
			.Item(lcEsquema + "sendusing")		  = This.nSMTPUsando
			.Item(lcEsquema + "smtpauthenticate") = This.lSMTPAutenticar
			.Item(lcEsquema + "smtpusessl")		  = This.lSMTPUsarSSL
			.Item(lcEsquema + "sendusername")	  = This.cRemitente
			.Item(lcEsquema + "sendpassword")	  = This.cContrasena
			.Update()
		Endwith
		loMsg = Createobject("CDO.Message")
		With loMsg
			.Configuration = loCDO
			.From		   = This.cRemitente          && Requerido
			.To			   = This.cDestinatario       && Requerido
			.Cc			   = This.cConCopia           && Los e-mails de los dem�s destinatarios (si los hubiera), separados con punto y coma
			.Bcc		   = This.cConCopiaOculta     && Los e-mails de los dem�s destinatarios (si los hubiera), separados con punto y coma
			.Subject	   = This.cTitulo             && Requerido
			.TextBody	   = This.cTexto              && Requerido


*WAIT WINDOW This.cRemitente
*WAIT WINDOW This.cContrasena
*WAIT WINDOW This.cDestinatario
*WAIT WINDOW This.cConCopia
*WAIT WINDOW This.cSMTPServidor




*--- Si hay archivos adjuntos, se los agrega al e-mail
			If !Empty(This.cAdjuntos) Then
				For lnI = 1 To Alines(aAdjuntos, This.cAdjuntos, 5, ";")     && 5 = remueve espacios y no incluye elementos vac�os en el array
					lcArchivo = aAdjuntos[lnI]
*	WAIT WINDOW lcArchivo
					.AddAttachment(lcArchivo)
				Endfor
			Endif
*--- Si se quiere usar HTML, se agrega el contenido HTML
			If !Empty(This.cPaginaHTML) Then
				.CreateMHTMLBody(This.cPaginaHTML, 0)
			Endif
*--- Se determina a quien se debe notificar
			If This.lConfirmacion Then
				.Fields("urn:schemas:mailheader:disposition-notification-to") = .From
				.Fields("urn:schemas:mailheader:return-receipt-to")			  = .From
				.Fields.Update()
			Endif
*--- Se coloca la importancia (algunos servidores solamente reconocen la importancia, no la prioridad)
			.Fields.Item("urn:schemas:httpmail:importance")	  = This.nImportancia
			.Fields.Item("urn:schemas:mailheader:importance") = Icase(This.nImportancia = 0, "Low", This.nImportancia = 1, "Normal", "High")
*--- Se coloca la prioridad (algunos servidores solamente reconocen la importancia, no la prioridad)
			.Fields.Item("urn:schemas:httpmail:priority")	= This.nPrioridad
			.Fields.Item("urn:schemas:mailheader:priority")	= This.nPrioridad
*--- Se actualizan la importancia y la prioridad
			.Fields.Update()
*--- Se muestran mensajes al usuario, si se especific� la opci�n de avisarle
			With This
				If Empty(.cAdjuntos) .And. .lMostrarAviso Then
					Mensaje("Enviando  a: " + Alltrim(.cDestinatario))
				Endif
				If !Empty(.cAdjuntos) .And. .lMostrarAviso Then
					Mensaje("Enviando el e-mail a: " + Alltrim(.cDestinatario))
				Endif
			Endwith
*--- Los CharSet deben estar inmediatamente antes que el m�todo SEND(). Se usan para mostrar vocales acentuadas y letras e�e
			.BodyPart.Charset	  = "UTF-8"
			.TextBodyPart.Charset = "UTF-8"
			If !Empty(This.cPaginaHTML) Then
				.HTMLBodyPart.Charset = "UTF-8"
			Endif
*--- Se trata de enviar el e-mail
			.Send()
*--- Se le avisa al usuario que el e-mail fue enviado, si se especific� la opci�n de avisarle
			If This.lMostrarAviso Then
				Mensaje("Enviado exitosamente." )
			Endif
		Endwith
	Catch To loError
*--- Ocurri� un error, se guardan en un string los datos del error ocurrido
		This.CmensajeError = "No pudo enviarse el e-mail" + KEY_ENTER ;
			+ "Error N�: " + Transform(loError.ErrorNo) + KEY_ENTER ;
			+ "Mensaje: " + loError.Message
	Finally
		loCDO = .Null.           && Hay que ponerle .NULL. para que el objeto ya no pueda ser usado
		loMsg = .Null.           && Hay que ponerle .NULL. para que el objeto ya no pueda ser usado
		Release loCDO, loMsg     && Despu�s de usar un objeto hay que liberarlo de la memoria. Y desaparece totalmente.
	Endtry
	Return (Empty(This.CmensajeError))
	Endfunc
*
	Hidden Function VAlidar

		#Define KEY_ENTER Chr(13)
		With This
			Do Case
			Case Vartype(.cRemitente) <> "C" .Or. !"companysysven.com" $ .cRemitente
				.CmensajeError = "La cuenta de correo del remitente" + KEY_ENTER + "debe ser una cuenta de Corporativa"
			Case !"@" $ .cRemitente
				.CmensajeError = "No puedo enviar este e-mail" + KEY_ENTER + "La cuenta de correo del remitente" + KEY_ENTER + "no es v�lida"
*	Case !".com" $ .cRemitente .And. !".org" $ .cRemitente .And. !".net" $ .cRemitente .And. !".gov" $ .cRemitente .And. !".edu" $ .cRemitente .And. !".gob" $ .cRemitente
*		.CmensajeError = "No puedo enviar este e-mail" + KEY_ENTER + "El dominio del remitente" + KEY_ENTER + "no es v�lido"
			Case Empty(.cRemitente)
				.CmensajeError = "Necesito conocer cual es la cuenta de correo" + KEY_ENTER + "que est� enviando este e-mail"
			Case Vartype(.cDestinatario) <> "C" .Or. !"@" $ .cDestinatario
				.CmensajeError = "No puedo enviar este e-mail" + KEY_ENTER + "La cuenta de correo del destinatario" + KEY_ENTER + "no es v�lida"
*Case !".com" $ .cDestinatario .And. !".org" $ .cDestinatario .And. !".net" $ .cDestinatario .And. !".gov" $ .cDestinatario .And. !".edu" $ .cDestinatario .And. !".gob" $ .cDestinatario
*	.CmensajeError = "No puedo enviar este e-mail" + KEY_ENTER + "El dominio del destinatario" + KEY_ENTER + "no es v�lido"
			Case Empty(.cDestinatario)
				.CmensajeError = "Necesito conocer la cuenta de correo" + KEY_ENTER + "a la cual se enviar� este e-mail"
			Case Vartype(.cContrasena) <> "C" .Or. Empty(.cContrasena)
				.CmensajeError = "Necesito conocer la contrase�a" + KEY_ENTER + "de la cuenta de correo que env�a este e-mail"
			Case Vartype(.cTexto) <> "C" .Or. Empty(.cTexto)
				.CmensajeError = "No puedo enviar este e-mail" + KEY_ENTER + "porque no tiene texto"
			Case Vartype(.cTitulo) <> "C" .Or. Empty(.cTitulo)
				.CmensajeError = "No puedo enviar este e-mail" + KEY_ENTER + "porque no tiene T�tulo"
			Case Vartype(.lConfirmacion) <> "L"
				.CmensajeError = "lConfirmacion debe ser .F. o .T."
			Case Vartype(.nImportancia) <> "N" .Or. .nImportancia < 0 .Or. .nImportancia > 2
				.CmensajeError = "La importancia del e-mail es incorrecta" + KEY_ENTER + "Debe ser uno de estos valores: 0, 1, 2"
			Case Vartype(.nPrioridad) <> "N" .Or. .nPrioridad < -1 .Or. .nPrioridad > 1
				.CmensajeError = "La prioridad del e-mail es incorrecta" + KEY_ENTER + "Debe ser uno de estos valores: -1, 0, 1"
			Endcase
		Endwith
		Endfunc



	Function Solicitaemail(cemail)
	Url = 'http://companysysven.com/dcorreo.php'
	Text To cdata Noshow Textmerge
	{
	"nombre":"<<cemail>>"
	}
	Endtext
	oHTTP = Createobject("Microsoft.XMLHTTP")
	oHTTP.Open("post", Url, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	cvalor = ""
*!*	    Wait Window URL
	If oHTTP.Status <> 200 Then
		Messagebox("Servicio WEB NO Disponible....." + Alltrim(Str(oHTTP.Status)), 16, MSGTITULO)
		Return cvalor
	Endif

	lcHTML = oHTTP.responseText
	Set Procedure To  d:\Librerias\json Additive
	ovalor = json_decode(lcHTML)
	If Not Empty(json_getErrorMsg())
		Messagebox("No se Pudo Obtener la Informaci�n desde la WEB " + WEB + ' ' + json_getErrorMsg(), 16, MSGTITULO)
		Return cvalor
	Endif
	objcorreo = Createobject("empty")
	If !Pemstatus(goApp, 'clavecorreo', 5)
		AddProperty(goApp, 'clavecorreo', '')
	Endif
	If Len(Alltrim(ovalor.Get('correo'))) > 0 Then
		AddProperty(objcorreo, 'correo', ovalor.Get('correo'))
		AddProperty(objcorreo, 'password', ovalor.Get('password'))
		goApp.clavecorreo = ovalor.Get('password')
	Endif
	Return objcorreo
	Endfunc

*
*
Enddefine
*
***********************************
Define Class guiaTrasnportista As Custom
	fech			 = Date()
	ptop			 = ""
	ptoll			 = ""
	fect			 = Date()
	Detalle			 = ""
	Idtransportista	 = 0
	idtransportista1 = 0
	Ndoc			 = ""
	idremitente		 = 0
	iddestinatario	 = 0
	ructr			 = ""
	razont			 = ""
	Constancia		 = ""
	marca			 = ""
	Placa			 = ""
	configuracion	 = ""
	remitente		 = ""
	destinatario	 = ""
	rucr			 = ""
	rucd			 = ""
	idguia			 = 0
	brevete			 = ""
	Function registra()
*:Global cmensaje, nidg, nidkar, s
	Cmensaje = ""
	If IniciaTransaccion() = 0 Then
		DEshacerCambios()
		Return 0
	Endif
	nidg = IngresaGuiasTransportista(This.fech, This.ptop, This.ptoll, 0, This.fect, ;
		  goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda, This.idremitente, This.iddestinatario, This.idtransportista1)
	If nidg = 0 Then
		DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s	   = 1
	nidkar = 0
	Do While !Eof()
		If GrabaDetalleGuiasTransportista(tmpvg.Desc, tmpvg.Nitem, tmpvg.nitem1, tmpvg.nitem2, nidg, tmpvg.Peso, tmpvg.cant, tmpvg.Unid) = 0 Then
			s		 = 0
			Cmensaje = 'Al Grabar Detalle de Guia Transportista'
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If s = 0 Then
		Messagebox(Cmensaje, 16, MSGTITULO)
		DEshacerCambios()
		Return 0
	Else
		If GRabarCambios() = 1 Then
			This.Imprimir()
			Return  1
		Endif
	Endif
	Endfunc
	Function Imprimir()
*:Global cinforme, cndoc, ni, x
	Select Count(*) As Titems From tmpvg Into Cursor tot
	ni	  = tot.Titems
	cndoc = This.Ndoc
	Select tmpvg
	Go Top
	For x = 1 To 30 - .Nitemx
		ni = ni + 1
		Insert Into tmpvg(Ndoc, nitem1)Values(This.Ndoc, ni)
	Next
	Select tmpvg
	Replace All Ndoc With This.Ndoc, ;
		ruct With This.ructr, razont With This.razont, fech With This.fech, ;
		ptoll With This.ptoll, ptop With This.ptop, fect With This.fect, ;
		marca With This.marca, configuracion With This.configuracion, ;
		remitente With This.remitente, destinatario With This.destinatario, nrucr With This.rucr, ;
		nrucd With This.rucd, Constancia With This.Constancia, brevete With This.brevete  In tmpvg
	cinforme = Addbs(Sys(5) + Sys(2003)) + Alltrim(fe_gene.nruc) + '\guiatransportista.frx'
	Report Form (cinforme) To Printer Prompt Noconsole
	Endfunc
	Function Limpiar()
	This.Fecha			 = Date()
	This.ptop			 = ""
	This.ptoll			 = ""
	This.fechat			 = Date()
	This.Detalle		 = ""
	This.Idtransportista = 0
	This.Ndoc			 = ""
	This.idremitente	 = 0
	This.iddestinatario	 = 0
	Endfunc
	Function Actualiza()
*:Global cmensaje, nidkar, s
	Cmensaje = ""
	If IniciaTransaccion() = 0 Then
		DEshacerCambios()
		Return 0
	Endif
	If ActualizaGuiasTransportista(This.fech, This.ptop, This.ptoll, 0, This.fect, ;
			  goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda, This.idremitente, This.iddestinatario, This.idtransportista1, This.idguia) = 0 Then
		DEshacerCambios()
		Return 0
	Endif
	If Actualizadetalleguiatransporte(This.idguia) = 0 Then
		DEshacerCambios()
		Return
	Endif
	Select tmpvg
	Go Top
	s	   = 1
	nidkar = 0
	Do While !Eof()
		If GrabaDetalleGuiasTransportista(tmpvg.Desc, tmpvg.Nitem, tmpvg.nitem1, tmpvg.nitem2, This.idguia, tmpvg.Peso, tmpvg.cant, tmpvg.Unid) = 0 Then
			s		 = 0
			Cmensaje = 'Al Grabar Detalle de Guia Transportista'
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If s = 0 Then
		Messagebox(Cmensaje, 16, MSGTITULO)
		DEshacerCambios()
		Return 0
	Else
		If GRabarCambios() = 1 Then
			This.Imprimir()
			Return  1
		Endif
	Endif
	Endfunc
	Function validarGuiaTransportista()
	Do Case
	Case Len(Alltrim(_Screen.ActiveForm.TXTSErie.Value)) < 3 Or Len(Alltrim(_Screen.ActiveForm.TXTNUmero.Value)) < 7 Or Val(_Screen.ActiveForm.TXTNUmero.Value) < 1
		_Screen.ActiveForm.Mensaje = "Ingrese un N� de Documento V�lido"
		Return .F.
	Case Year(_Screen.ActiveForm.txtfeCHA.Value) <> Val(goApp.a�o) Or !esFechaValidafvto(_Screen.ActiveForm.txtfeCHAt.Value)
		_Screen.ActiveForm.Mensaje = "Fecha No V�lida No permitida por el Sistema"
		Return .F.
	Case Empty(_Screen.ActiveForm.txtcodigor.Value)
		_Screen.ActiveForm.Mensaje = "Seleccione Un Remitente"
		Return .F.
	Case Empty(_Screen.ActiveForm.txtCodigo.Value)
		_Screen.ActiveForm.Mensaje = "Seleccione Un Destinatario"
		Return .F.
	Case _Screen.ActiveForm.txtfeCHAt.Value < _Screen.ActiveForm.txtfeCHA.Value
		_Screen.ActiveForm.Mensaje = "La Fecha de Traslado No Puede Ser Antes que la Fecha de Emisi�n"
		Return .F.
	Case Len(Alltrim(_Screen.ActiveForm.txtllegada.Value)) = 0
		_Screen.ActiveFormmensaje = "Ingrese La direcci�n de LLegada"
		Return .F.
	Otherwise
		Return .T.
	Endcase
	Endfunc
Enddefine
*****************************
Function IngresaGuiasTransportista(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13)
Local lC, lp
*:Global cur
lC			  = "FunIngresaGuiasTransportista"
cur			  = "YY"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,
     ?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Ingresando Guias de Remisi�n Transportista')
	Return 0
Else
	Return yy.Id
Endif
Endfunc
*********************************
Function GrabaDetalleGuiasTransportista(np1, np2, np3, np4, np5, np6, np7, np8)
Local lC, lp
*:Global cur
lC			 = "ProIngresaDetalleguiaTransportista"
cur			 = ""
goApp.npara1 = np1
goApp.npara2 = np2
goApp.npara3 = np3
goApp.npara4 = np4
goApp.npara5 = np5
goApp.npara6 = np6
goApp.npara7 = np7
goApp.npara8 = np8
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8)
Endtext
If EJECUTARP(lC, lp, cur) < 1 Then
	Errorbd(ERRORPROC + ' Ingresando Detalles Guias Transportista')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************
Function ActualizaGuiasTransportista(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14)
Local lC, lp
*:Global cur
lC			  = "ProActualizaGuiasTransportista"
cur			  = ""
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,
     ?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Ingresando Guias de Remisi�n Transportista')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************************
Function Actualizadetalleguiatransporte(np1)
Local lC, lp
*:Global cur
lC			 = "ProActualizadetalleGuiasTransportista"
cur			 = ""
goApp.npara1 = np1
Text To lp Noshow
     (?goapp.npara1)
Endtext
If EJECUTARP(lC, lp, cur) < 1 Then
	Errorbd(ERRORPROC + ' Desactivando Detalles Guias Transportista')
	Return 0
Else
	Return 1
Endif
Endfunc
************************************
Function IngresaDocumentoElectronicoconretencion(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25)
Local lC, lp
*:Global cur
lC			  = 'FuningresaDocumentoElectronico'
cur			  = "Xn"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
goApp.npara18 = np18
goApp.npara19 = np19
goApp.npara20 = np20
goApp.npara21 = np21
goApp.npara22 = np22
goApp.npara23 = np23
goApp.npara24 = np24
goApp.npara25 = np25
*FOR x=1 TO 25
*   WAIT WINDOW 'hola'
*  cpara='np'+ALLTRIM(STR(x))
*   WAIT WINDOW EVALUATE(cpara)
*NEXT



*cad=goapp.npara1,goapp.npara2,goapp.npara3,goapp.npara4,goapp.npara5,goapp.npara6,goapp.npara7,goapp.npara8,goapp.npara9,goapp.npara10,goapp.npara11,goapp.npara12,goapp.npara13,goapp.npara14,goapp.npara15,goapp.npara16,goapp.npara17,goapp.npara18,goapp.npara19,goapp.npara20,goapp.npara21,goapp.npara22,goapp.npara23,goapp.npara24,goapp.npara25
Text To lp Noshow
(?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
Endtext
If EJECUTARf(lC, lp, cur) < 1 Then
	Errorbd(' Ingresando Cabecera de Documento CPE Con RETENCION' )
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
*******************************
Function IngresaDocumentoElectronicocondetraccion(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25)
Local lC, lp
*:Global cur
lC			  = 'FuningresaDocumentoElectronicocondetraccion'
cur			  = "Xn"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
goApp.npara18 = np18
goApp.npara19 = np19
goApp.npara20 = np20
goApp.npara21 = np21
goApp.npara22 = np22
goApp.npara23 = np23
goApp.npara24 = np24
goApp.npara25 = np25
Text To lp Noshow
(?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Ingresando Cabecera de Documento CPE Con DETRACCION' )
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
*******************************
Function validarvtas()
*:Global x
x = validacaja(_Screen.ActiveForm.txtfeCHA.Value)
If x = "C"
	Messagebox("La caja de Esta Fecha Esta Cerrada", 16, MSGTITULO)
	Return .F.
Endif
Select (_Screen.ActiveForm.Grivta.RecordSource)
Locate For Valida = "N"
Do Case
Case _Screen.ActiveForm.txtCodigo.Value = 0 Or Empty(_Screen.ActiveForm.txtCodigo.Value)
	_Screen.ActiveForm.Mensaje = "Seleccione un Cliente Para Esta Venta"
	Return .F.
Case _Screen.ActiveForm.Serie = "N"
	_Screen.ActiveForm.Mensaje = "Serie NO Permitida"
	Return .F.
Case Found()
	_Screen.ActiveForm.Mensaje = "Hay Un Prducto que Falta Cantidad o Precio"
	Return .F.
Case _Screen.ActiveForm.txtruC.Value = "***********"
	_Screen.ActiveForm.Mensaje = "Seleccione Otro Cliente"
	Return .F.
Case _Screen.ActiveForm.Tdoc = "01" And !ValidaRuc(_Screen.ActiveForm.txtruC.Value)
	_Screen.ActiveFor.Mensaje = "Ingrese RUC del Cliente"
	Return .F.
Case _Screen.ActiveForm.Tdoc = "03" And _Screen.ActiveForm.txttOTAL.Value > 700 And Len(Alltrim(_Screen.ActiveForm.txtdnI.Value)) < 8
	_Screen.ActiveForm.Mensaje = "Ingrese DNI del Cliente "
	Return .F.
Case _Screen.ActiveForm.txtencontrado.Value = "V"
	_Screen.ActiveForm.Mensaje = "NO Es Posible Actualizar Este Documento El Numero del Comprobante Pertenece a uno ya Registrado"
	Return .F.
Case _Screen.ActiveForm.txttOTAL.Value = 0
	_Screen.ActiveForm.Mensaje = "Ingrese Cantidad y Precio"
	Return .F.
Case _Screen.ActiveForm.TXTSErie.Value = "0000" Or Val(_Screen.ActiveForm.TXTNUmero.Value) = 0 Or Len(Alltrim(_Screen.ActiveForm.TXTSErie.Value)) < 3;
		Or Len(Alltrim(_Screen.ActiveForm.TXTNUmero.Value)) < 8
	_Screen.ActiveForm.Mensaje = "Ingrese Un N�mero de Documento V�lido"
	Return .F.
Case Empty(_Screen.ActiveForm.Calmacen)
	_Screen.ActiveForm.Mensaje = "Seleccione Un Almacen"
	Return .F.
Case Month(_Screen.ActiveForm.txtfeCHA.Value) <> goApp.mes Or Year(_Screen.ActiveForm.txtfeCHA.Value) <> Val(goApp.a�o) Or !esfechaValida(_Screen.ActiveForm.txtfeCHA.Value)
	_Screen.ActiveForm.Mensaje = "Fecha NO Permitida Por el Sistema y/o Fecha no V�lida"
	Return .F.
Case  !esFechaValidafvto(_Screen.ActiveForm.txtfechavto.Value)
	_Screen.ActiveForm.Mensaje = "Fecha de Vencimiento no V�lida"
	Return .F.
Case _Screen.ActiveForm.txtfechavto.Value <= _Screen.ActiveForm.txtfeCHA.Value And _Screen.ActiveForm.cmbFORMA.ListIndex = 2
	_Screen.ActiveForm.Mensaje = "La Fecha de Vencimiento debe ser diferente de le fecha de Emisi�n "
	Return .F.
Case PermiteIngresoVentas1(_Screen.ActiveForm.TXTSErie.Value + _Screen.ActiveForm.TXTNUmero.Value, _Screen.ActiveForm.Tdoc, 0, _Screen.ActiveForm.txtfeCHA.Value) = 0
	_Screen.ActiveForm.Mensaje = "N�mero de Documento de Venta Ya Registrado"
	Return .F.
Otherwise
	Return .T.
Endcase
Endfunc
******************************
Function validarGuiaTransportista()
Do Case
Case Len(Alltrim(_Screen.ActiveForm.TXTSErie.Value)) < 3 Or Len(Alltrim(_Screen.ActiveForm.TXTNUmero.Value)) < 7 Or Val(_Screen.ActiveForm.TXTNUmero.Value) < 1
	_Screen.ActiveForm.Mensaje = "Ingrese un N� de Documento V�lido"
	Return .F.
Case Year(_Screen.ActiveForm.txtfeCHA.Value) <> Val(goApp.a�o) Or !esFechaValidafvto(_Screen.ActiveForm.txtfeCHAt.Value)
	_Screen.ActiveForm.Mensaje = "Fecha No V�lida No permitida por el Sistema"
	Return .F.
Case Empty(_Screen.ActiveForm.txtcodigor.Value)
	_Screen.ActiveForm.Mensaje = "Seleccione Un Remitente"
	Return .F.
Case Empty(_Screen.ActiveForm.txtCodigo.Value)
	_Screen.ActiveForm.Mensaje = "Seleccione Un Destinatario"
	Return .F.
Case _Screen.ActiveForm.txtfeCHAt.Value < _Screen.ActiveForm.txtfeCHA.Value
	_Screen.ActiveForm.Mensaje = "La Fecha de Traslado No Puede Ser Antes que la Fecha de Emisi�n"
	Return .F.
Case Len(Alltrim(_Screen.ActiveForm.txtllegada.Value)) = 0
	_Screen.ActiveFormmensaje = "Ingrese La direcci�n de LLegada"
	Return .F.
Otherwise
	Return .T.
Endcase
Endfunc
******************************
Function ValidarNotaCreditoVentas()
Do Case
Case _Screen.ActiveForm.txttOTAL.Value = 0 And Left(_Screen.ActiveForm.Cmbtiponotacredito1.Value, 2) <> '13'
	_Screen.ActiveForm.Mensaje = "Importes Deben de Ser Diferente de Cero"
	Return .F.
Case Len(Alltrim(_Screen.ActiveForm.TXTSErie.Value)) < 4 Or Len(Alltrim(_Screen.ActiveForm.TXTNUmero.Value)) < 8;
		Or _Screen.ActiveForm.TXTSErie.Value = "0000" Or Val(_Screen.ActiveForm.TXTNUmero.Value) = 0
	_Screen.ActiveForm.Mensaje = "Falta Ingresar Correctamente el N�mero del  Documento"
	Return .F.
Case _Screen.ActiveForm.tdocref = '01' And  !'FN' $ Left(_Screen.ActiveForm.TXTSErie.Value, 2)
	_Screen.ActiveForm.Mensaje = "N�mero del  Documento NO V�lido"
	Return .F.
Case Empty(_Screen.ActiveForm.txtCodigo.Value)
	_Screen.ActiveForm.Mensaje = "Ingrese Un Cliente"
	Return .F.
Case (Len(Alltrim(_Screen.ActiveForm.lblRAZON.Text)) < 5 Or !ValidaRuc(_Screen.ActiveForm.txtruC.Value)) And _Screen.ActiveForm.tdocref = '01'
	_Screen.ActiveForm.Mensaje = "Es Necesario Ingresar el Nombre Completo de Cliente, RUC V�lido"
	Return .F.
Case (Len(Alltrim(_Screen.ActiveForm.lblRAZON.Text)) < 5 Or Len(Alltrim(_Screen.ActiveForm.txtdnI.Value)) <> 8) And _Screen.ActiveForm.tdocref = '03'
	_Screen.ActiveForm.Mensaje = "Es Necesario Ingresar el Nombre Completo de Cliente, DNI V�lidos"
	Return .F.
Case Year(_Screen.ActiveForm.txtfeCHA.Value) <> Val(goApp.a�o)
	_Screen.ActiveForm.Mensaje = "La Fecha No es V�lida"
	Return .F.
Case  PermiteIngresox(_Screen.ActiveForm.txtfeCHA.Value) = 0
	_Screen.ActiveForm.Mensaje = "No Es posible Registrar en esta Fecha estan bloqueados Los Ingresos"
	Return .F.
Case PermiteIngresoVentas1(_Screen.ActiveForm.TXTSErie.Value + _Screen.ActiveForm.TXTNUmero.Value, _Screen.ActiveForm.Tdoc, 0, _Screen.ActiveForm.txtfeCHA.Value) = 0
	_Screen.ActiveForm.Mensaje = "N� de Documento de Venta Ya Registrado"
	Return .F.
Case Left(_Screen.ActiveForm.Cmbtiponotacredito1.Value, 2) = '13' And _Screen.ActiveForm.Optdetalles.optagrupada.Value = 0
	_Screen.ActiveForm.Mensaje = "Tiene que seleccionar la opci�n  Agrupada para este documento"
	Return .F.
Case Left(_Screen.ActiveForm.Cmbtiponotacredito1.Value, 2) = '13' And _Screen.ActiveForm.txttOTAL.Value > 0
	_Screen.ActiveForm.Mensaje = "Los Importes Deben de ser 0"
	Return .F.
Case Left(_Screen.ActiveForm.Cmbtiponotacredito1.Value, 2) = '13' And _Screen.ActiveForm.txttotalnc.Value = 0
	_Screen.ActiveForm.Mensaje = "Ingrese Importe para Nota Cr�dito Tipo 13"
	Return .F.
Case _Screen.ActiveForm.cmbdcto.ListIndex = 1
	If _Screen.ActiveForm.txttOTAL.Value > _Screen.ActiveForm.txtfimporte.Value
		_Screen.ActiveForm.Mensaje = "El Importe No Puede Ser Mayor al del Documento"
		Return .F.
	Endif

Otherwise
	Return .T.
Endcase
Endfunc
*********************************
Function CalculaIGV()
Local m.Nt As Decimal
If Lower(_Screen.ActiveForm.Name) = "co_compras"
	m.Nt							  = _Screen.ActiveForm.txtvalor1.Value +  _Screen.ActiveForm.txtvalor2.Value +  _Screen.ActiveForm.txtvalor3.Value +  _Screen.ActiveForm.txtvalor4.Value
	m.ntigv							  = (Val( _Screen.ActiveForm.Cmbigv1.Value) / 100) + 1
	_Screen.ActiveForm.Txtigv.Value	  = Round(m.Nt * (ntigv - 1), 2)
	_Screen.ActiveForm.txttOTAL.Value = Round(m.Nt + _Screen.ActiveForm.Txtigv.Value + _Screen.ActiveForm.Txtexonerado.Value + _Screen.ActiveForm.Txtotros.Value, 2)
Endif
Endfunc
*********************************
*=caracteresEspeciales('string a enviar')

Function quitarcaracteresEspeciales()
Lparameters lstring
*:Global i
For i = 1 To Len(lstring)
	If !Betw(Asc(Substr(lstring, i, 1)), 65, 90) And ;
			!Betw(Asc(Substr(lstring, i, 1)), 97, 122) And ;
			!Betw(Asc(Substr(lstring, i, 1)), 48, 57) And ;
			Asc(Substr(lstring, i, 1)) <> 32
		lstring = Stuff(lstring, At(Substr(lstring, i, 1), lstring), 1, '')

	Endif
Endfor
Return lstring
Endfunc
************************
Function IngresarNotasCreditoVentas10(np1, np2, np3, np4)
Local cur As String
Local lC, lp
lC			 = 'FUNINGRESANOTASCREDITOventas1'
cur			 = "xi"
goApp.npara1 = np1
goApp.npara2 = np2
goApp.npara3 = np3
goApp.npara4 = np4
Text To lp Noshow
(?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Ingresando Notas Credito de Ventas 1 ')
	Return 0
Else
	Return xi.Id
Endif
Endfunc
*****************************
Function IngresaResumenDctovtascondetraccion(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25)
Local lC, lp
*:Global cur
lC			  = 'FunIngresaCabeceraVtascdetraccion'
cur			  = "Xn"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
goApp.npara18 = np18
goApp.npara19 = np19
goApp.npara20 = np20
goApp.npara21 = np21
goApp.npara22 = np22
goApp.npara23 = np23
goApp.npara24 = np24
goApp.npara25 = np25
Text To lp Noshow
(?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Ingresando Cabecera de Documento con Detracci�n')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
***************************************
Function ActualizaResumenDctovtascondetraccion(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25, np26, np27)
Local lC, lp
*:Global cur
lC			  = 'ProActualizaCabeceraVentascdetraccion'
cur			  = ""
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
goApp.npara18 = np18
goApp.npara19 = np19
goApp.npara20 = np20
goApp.npara21 = np21
goApp.npara22 = np22
goApp.npara23 = np23
goApp.npara24 = np24
goApp.npara25 = np25
goApp.npara26 = np26
goApp.npara27 = np27
Text To lp Noshow
(?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26,?goapp.npara27)
Endtext
If EJECUTARP(lC, lp, cur) < 1 Then
	Errorbd(ERRORPROC + ' Actualizando Cabecera de Documento de Compras/Ventas')
	Return 0
Else
	Return 1
Endif
Endfunc
***************************************
Function IngresaDatosLCajaECreditosx(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14)
lC = "FunIngresaDatosLcajaECreditos"
cur = "Cred"
goApp.npara1 = np1
goApp.npara2 = np2
goApp.npara3 = np3
goApp.npara4 = np4
goApp.npara5 = np5
goApp.npara6 = np6
goApp.npara7 = np7
goApp.npara8 = np8
goApp.npara9 = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,
     ?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Ingresando Cancelaciones de Cliente A Caja Efectivo')
	Return 0
Else
	Return cred.Id
Endif
Endfunc
************************************
Function IngresaDatosLCajaEFectivo121(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15)
lC = "FunIngresaDatosLcajaEfectivo12"
cur = "icaja"
goApp.npara1 = np1
goApp.npara2 = np2
goApp.npara3 = np3
goApp.npara4 = np4
goApp.npara5 = np5
goApp.npara6 = np6
goApp.npara7 = np7
goApp.npara8 = np8
goApp.npara9 = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,
      ?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Ingresando Datos A Libro Caja Efectivo Con Cuentas Contable')
	Return 0
Else
	Return icaja.Id
Endif
Endfunc
**********************
Function createmporalcotizacionesU(Calias)
Create Cursor unidades(uequi N(7, 4), ucoda N(8), uunid c(15), uitem N(4), uprecio N(12, 6), uidepta N(8), ucosto N(10, 2))
Create  Cursor (Calias)(Descri c(100), Unid c(15), duni c(15), cant N(10, 3), Prec N(13, 5), Nreg N(8), pos N(5), pmayor N(8, 2), pmenor N(8, 2), ;
	  Ndoc c(10), prevta N(13, 5), Nitem N(5), alma N(10, 2), Valida c(1), idepta N(8), idco N(8), tipro c(1), calma c(3), aprecios c(1), ;
	  equi N(12, 8), prem N(12, 8), uno N(12, 2), Dos N(12, 2), costo N(12, 2), Item N(8), coda N(8), ;
	  Direccion c(180), fono c(15), atencion c(100), vigv N(6, 4), Forma c(100), validez c(100), plazo c(100), entrega c(100), Detalle c(180), ;
	  nTotal N(12, 2), Mone c(1), garantia c(100), nruc c(11), nfax c(15), Comc N(7, 4), ;
	  codc N(6), razon c(120), fech d, Cod c(20), orden N(3), valida1 c(1))

Select (Calias)
Index On Descri Tag Descri
Index On Nitem Tag Items
Endfunc
************************************
Function BuscarSeries(ns, cTdoc)
Local cser As String
If SQLExec(goApp.bdConn, "CALL PROBUSCASERIES(?ns,?ctdoc)", "series") < 1
	Return 0
Else
	Do Case
	Case SERIES.Idserie > 0
		If cTdoc = '01' Or cTdoc = '03' Or cTdoc = '20' Or cTdoc = '09' Or cTdoc = "07" Or cTdoc = "08"  Or cTdoc = "12" Or cTdoc = "SC"  Then
			Try
				Do Case
				Case cTdoc = "01" Or cTdoc = '12'
					cArchivo = Addbs(Sys(5) + Sys(2003) + '\comp') + 'factura' + Alltrim(Str(ns)) + '.frx'
				Case cTdoc = "03"
					cArchivo = Addbs(Sys(5) + Sys(2003) + '\comp') + 'boleta' + Alltrim(Str(ns)) + '.frx'
				Case cTdoc = "20" Or cTdoc = "SC"
					cArchivo = Addbs(Sys(5) + Sys(2003) + '\comp') + 'notasp.frx'
				Case cTdoc = "09"
					cArchivo = Addbs(Sys(5) + Sys(2003) + '\comp') + 'guia' + Alltrim(Str(ns)) + '.frx'
				Case cTdoc = "07" Or cTdoc = "08"
					cArchivo = Addbs(Sys(5) + Sys(2003) + '\comp') + 'notasc1.frx'
				Endcase
*wait WINDOW 'hola '+carchivo
				goApp.reporte = cArchivo
				If !File(cArchivo)
*	mensaje("No hay  formato para esta Serie " +Alltrim(Str(ns)))
				Endif
			Catch To oerror
				Messagebox("No es Posible Imprimir este Comprobante", 16, MSGTITULO)
			Finally
			Endtry
		Else
			Return 1
		Endif
		Return 1
	Case SERIES.Idserie <= 0
		Messagebox("Serie NO Registrada", 48, MSGTITULO)
		Return 0
	Endcase
	Return 1
Endif
Endfunc
*****************************
Function Mostrarsegmentoscliente(Ccursor)
Text To lC Noshow Textmerge
      segm_segm,segm_idse FROM fe_segmento ORDER BY segm_idse
Endtext
If EjecutaConsulta(lC, Ccursor) < 1 Then
	Return 0
Endif
Return 1
Endfunc
*****************************
Function consultarbaja(cticket, odcto)
Local lC, lcr
*:Global cserie, ctdoc, dfenvio, ndesde, nhasta, np1, np3, odvto, sw
np3		= "0 La Comunicaci�n de Baja  ha sido aceptado desde APISUNAT"
Text To lcr Noshow Textmerge
   UPDATE fe_bajas SET baja_mens='<<np3>>' WHERE baja_tick='<<cticket>>';
Endtext
Sw	 = 1
np1	  = odcto.Idauto
odvto = ConsultaApisunat(odcto.Tdoc, odcto.Serie, Alltrim(odcto.nume), odcto.fech, Alltrim(Str(odcto.Impo, 12, 2)))
Do Case
Case  odvto.Vdvto = '2'
	Do Case
	Case Lower(odcto.Proc) = 'rnnorplast'
		Set Procedure To (odcto.Proc) Additive
		If AnulaTransaccionN('', '', 'V', odcto.Idauto, odcto.Idusua, "", Ctod(odcto.fech), goApp.uauto, 0) = 0 Then
			Messagebox("NO Se Anulo Correctamente de la Base de Datos", 16, MSGTITULO)
			Return 0
		Endif
	Case Lower(odcto.Proc) = 'rnftr'
		Set Procedure To (odcto.Proc) Additive
		If AnulaTransaccionN('', '', 'V', odcto.Idauto, odcto.Idusua, "", Ctod(odcto.fech), goApp.idcajero, 0) = 0 Then
			Messagebox("NO Se Anulo Correctamente de la Base de Datos", 16, MSGTITULO)
			Return 0
		Endif
	Case Lower(odcto.Proc) = 'rnxm'
		Set Procedure To (odcto.Proc) Additive
		If AnulaTransaccionN('', '', 'V', odcto.Idauto, odcto.Idusua, "", Ctod(odcto.fech), goApp.idcajero, 0) = 0 Then
			Messagebox("NO Se Anulo Correctamente de la Base de Datos", 16, MSGTITULO)
			Return 0
		Endif
	Otherwise
		If AnulaTransaccionConMotivo('', '', 'V', odcto.Idauto, odcto.Idusua, 'S', Ctod(odcto.fech), goApp.uauto, odcto.Detalle) = 0 Then
			Messagebox("NO Se Anulo Correctamente de la Base de Datos", 16, MSGTITULO)
			Return 0
		Endif
	Endcase
	If odcto.Tdoc = '03' Then
	Else
		If Ejecutarsql(lcr) < 1 Then
			Return 0
		Endif
	Endif
	Mensaje("Proceso Culminado Correctamente")
	Return 1
Case  odvto.Vdvto = '7'
	Mensaje("No se puede Obtener Respuesta desde el Servidor...no Existen las Credenciales de API SUNAT")
Otherwise
	Mensaje(" Respuesta del Servidor " + Alltrim(odvto.Vdvto))
Endcase
Return 0
Endfunc
********************************
Function MuestraPlanCuentas(cb)
lC = "PROMUESTRAPLANCUENTAS"
goApp.npara1 = cb
goApp.npara2 = Val(goApp.a�o)
Text To lp Noshow
       (?goapp.npara1,?goapp.npara2)
Endtext
If EJECUTARP(lC, lp, 'lctas') = 0 Then
	Errorbd(ERRORPROC + 'Mostrando Plan de Cuentas ')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************************


***************************************
Function wafoxpdf
*
* Creada por Manish Swami
* https://www.facebook.com/groups/118032825529669/user/1398167165/
* Ejemplo:
* https://www.facebook.com/groups/118032825529669/permalink/916852342314376/
* SendKeys de Microsoft
* https://docs.microsoft.com/en-us/office/vba/language/reference/user-interface-help/sendkeys-statement
* ShellExecute
* https://docs.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-shellexecutea
* Publicaci�n 19/03/2022
* Ajustes 19/03/2022
*
Parameters pcPhone, pcText, pcDocument
Local lhwnd, llResult, pcOldValue
pcOldValue = _Cliptext
_Cliptext = pcDocument
Declare Sleep In kernel32 Integer
Declare Integer FindWindow In WIN32API String, String
Declare Integer ShowWindow In WIN32API Integer, Integer
Declare Integer ShellExecute In SHELL32.Dll Integer hndWin, String cAction, String cFileName, String cParams, String cDir, Integer nShowWin

lhwnd = FindWindow(0, "WhatsApp")                                 && Busca la ventana WhatsApp y devulve su puntero
If lhwnd # 0                                                         && 0 si no fue hallada
	oKey = Createobject("Wscript.Shell" )                         && Crea el objeto para usar el metodo SENDKEYS
	lcCommand = "whatsapp://send?phone=" + pcPhone             && Abro el canal de CHAT
	= ShellExecute(0, "open", lcCommand, "", "", 0)
	Sleep(5000)
*!*                Como no siempre se abre la ventana con el foco en la caja de texto
*!*                le envio un texto para poner el cursor en dicho objeto
	lcCommand = lcCommand + "&text=" + pcText
	= ShellExecute(0, "open", lcCommand, "", "", 0)                 && Env�o el nuevo comando con el texto
	Sleep(500)
	oKey.sendKeys ("{ENTER}")
	Sleep(3000)
	oKey.sendKeys ("+{TAB}")                                        && Shift+TAB
	Sleep(500)
	oKey.sendKeys ("{ENTER}")
	Sleep(500)
*   oKey.sendkeys ("{UP 2}")
	oKey.sendKeys ("{DOWN 4}")
	Sleep(500)
	oKey.sendKeys ("{ENTER}")
	Sleep(500)
	oKey.sendKeys ("^{v}")
	Sleep(3000)
	oKey.sendKeys ("{ENTER}")
	Sleep(3000)
	oKey.sendKeys ("{ENTER}")
	Sleep(2000)
	ShowWindow (lhwnd, 11)                                && Fuerza al minimizado de la ventana
	oKey = Null
	llResult = .T.
Else
	Messagebox ("Whatsapp no est� disponible, abralo o intalelo", 64, MSGTITULO)
	llResult = .F.
Endif
Clear Dlls "Sleep", "FindWindow", "ShowWindow", "ShellExecute"
_Cliptext  = pcOldValue
Return llResult
Endfunc
**************************************
Function fechasporsemana(fi, ff, ndias)
ofechas = Createobject("custom")
Cmes = Alltrim(Str(Month(fi)))
ca�o = Alltrim(Str(Year(fi)))
p = 1
cprop = 'f' + Alltrim(Str(p))
AddProperty(ofechas, (cprop), fi)
*?fi
x = 1
For x = 1 To ndias
	p = p + 1
	cprop = 'f' + Alltrim(Str(p))
	If x = 1 Then
		ds = Dow(fi)
		fdf = 8 - ds
		f11 = fi + fdf
		AddProperty(ofechas, (cprop), f11)
		x = ds + 1
		fa = Ctod(Alltrim(Str(Day(f11) + 1)) + '/' + Cmes + '/' + ca�o)
	Else
		f11 = fa
		If fa + 6 > ff Then
			f22 = ff
			x = ndias
		Else
			f22 = fa + 6
			x = x + 6
		Endif
		AddProperty(ofechas, (cprop), f11)
		p = p + 1
		cprop = 'f' + Alltrim(Str(p))
		AddProperty(ofechas, (cprop), f22)
		If f22 + 1 = ff Then
			p = p + 1
			cprop = 'f' + Alltrim(Str(p))
			AddProperty(ofechas, (cprop), f22 + 1)
			p = p + 1
			cprop = 'f' + Alltrim(Str(p))
			AddProperty(ofechas, (cprop), f22 + 1)
			Exit
		Endif
		fa = Ctod(Alltrim(Str(Day(f22) + 1)) + '/' + Cmes + '/' + ca�o)
	Endif
Next
AddProperty(ofechas, 'nro', p)
Return ofechas
Endfunc
******************************
Function MostrarCargotarjeta(Calias)
Select fe_gene
If Fsize("cargovtastarjeta")>0 Then
	npor = (fe_gene.cargovtastarjeta / 100) + 1
	Select Sum(cant * Prec * npor) As tvtast From (Calias) Into Cursor ttvtast
	Return ttvtast.tvtast
Else
	Return 0
Endif
Endfunc
****************************
Function MostrarCargoVtasOtros(Calias)
tcargo=0
Select fe_gene
If Fsize("cargovtasniubiz")>0 Then
	npor = (fe_gene.cargovtasniubiz / 100) + 1
	Select Sum(cant * Prec * npor) As tvtast from (Calias) Into Cursor ttvtast
	tcargo= ttvtast.tvtast+fe_gene.importevtasniubiz
	Return tcargo
Else
	Return 0
Endif
Endfunc
****************************
Function creaobjetocompras(cobjeto)
Set Procedure  To d:\capass\modelos\compras Additive
cobjeto = Createobject("compras")
Return cobjeto
Endfunc
*****************************
Function DesactivaDtraspaso(np1)
lC = 'ProDesactivaDtraspaso'
goApp.npara1 = np1
ccur = ""
Text To lp Noshow
   (?goapp.npara1)
Endtext
If EJECUTARP(lC, lp, ccur) = 0 Then
	Errorbd(ERRORPROC + ' Desactivando Detalle del Traspaso ')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function ActualizaResumenDctoVtasdetraccion(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25)
lC = 'ProActualizaCabeceracvtasdetraccion'
cur = ""
goApp.npara1 = np1
goApp.npara2 = np2
goApp.npara3 = np3
goApp.npara4 = np4
goApp.npara5 = np5
goApp.npara6 = np6
goApp.npara7 = np7
goApp.npara8 = np8
goApp.npara9 = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
goApp.npara18 = np18
goApp.npara19 = np19
goApp.npara20 = np20
goApp.npara21 = np21
goApp.npara22 = np22
goApp.npara23 = np23
goApp.npara24 = np24
goApp.npara25 = np25
Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
Endtext
If EJECUTARP(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Actualizando Cabecera de Documento')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************
Function cambiarimpresoranormalpdf(creporte)
cpropiedad = "Impresoranormal"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("Impresoranormal", "")
Else
	lcImpresora = goApp.Impresoranormal
Endif
Do "FoxyPreviewer.App"
If !Empty(goApp.Impresoranormal) Then
	Declare Integer SetDefaultPrinter In WINSPOOL.DRV ;
		String pszPrinter
	lcImpresoraActual = ObtenerImpresoraActual()
	lcImpresora		  = goApp.Impresoranormal
	lnResultado		  = SetDefaultPrinter(lcImpresora)
	Set Printer To Name (lcImpresora)
	Report Form (creporte) Preview
	lnResultado = SetDefaultPrinter(lcImpresoraActual)
	Set Printer To Name (lcImpresoraActual)
Else
	Report Form (creporte) Preview
Endif
Do Foxypreviewer.App With "Release"
Endfunc
***********************************
Function dATOSGLOBALES()
cFile = Addbs(Sys(5) + Sys(2003)) + 'envio.exe'
If File(cFile)
	oWSH = Createobject("WScript.Shell")
	oWSH.Run(cFile, 0, .F.)
Endif
Set Procedure To d:\Librerias\nfcursortojson, d:\Librerias\nfcursortoobject, d:\Librerias\nfJsonRead.prg, d:\Librerias\nfjsontocursor, ;
	d:\capass\modelos\appsysven Additive
oapp = Createobject("appsysven")
If Alltrim(goApp.datosg) <> 'S' Then
	If oapp.dATOSGLOBALES("fe_gene") < 1 Then
		Return 0
	Endif
*!*		mensaje('consultando data')
	Public cfieldsfegene(1)
	nCount = Afields(cfieldsfegene)
	Select fe_gene
	Select * From fe_gene Into Cursor confsetup
	cdata = nfcursortojson(.T.)
	goApp.rucempresa = fe_gene.nruc
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'config' + Alltrim(Str(goApp.Xopcion)) + '.json'
	Strtofile (cdata, rutajson)
	goApp.datosg = 'S'
*!*		wait WINDOW 'hola consultando '+goApp.datosg
Else
*!*		mensaje('Sin consultar data')
	If Type("cfieldsfegene") <> 'U' Then
*!*	       wait WINDOW cfieldsfegene[2,1]
	Endif
*!*		If VerificaAlias("config") = 0 Then
*!*			Use Addbs(Sys(5) + Sys(2003)) + 'config' In 0 Exclusive
*!*		Endif
*!*		Zap In config
	Create Cursor config From Array cfieldsfegene
	responseType1 = Addbs(Sys(5) + Sys(2003)) + 'config' + Alltrim(Str(goApp.Xopcion)) + '.json'
	oResponse = nfJsonRead( m.responseType1 )
	For Each oRow In  oResponse.Array
		Insert Into config From Name oRow
	Endfor
	Select * From config Into Cursor fe_gene
	CierraCursor("config")
Endif
Select fe_gene
Return 1
Endfunc
*****************************************
Function VERIFICACONEXION()
ncon = 0
If SQLExec(goApp.bdConn, "SET @ZXC:=00") < 1 Then
	ncon = AbreConexion()
	If ncon > 0 Then
		goApp.bdConn = ncon
		Return 1
	Else
		aviso("No Hay Conexi�n con la Base de Datos")
		Return 0
	Endif
Else
	Return 1
Endif
Endfunc
*********************************
Function EjecutaOpcionesMenu(Url)
Do Case
Case Right(Allt(Url), 3) == "01"
*run/n mspaint
Case Right(Allt(Url), 3) == "02"
*!*		Run/N notepad
Case Right(Allt(Url), 3) == "03"
Case Right(Allt(Url), 3) == "04"
Case Right(Allt(Url), 3) == "05"
*	goapp.Form("ka_ventas","")
Case Right(Allt(Url), 3) == "06"
*	goapp.Form("co_oventas1",0,0)
Case Right(Allt(Url), 3) == "07"
*	goapp.Form("ka_guiasventas",0,0)
Case Right(Allt(Url), 3) == "08"
Case Right(Allt(Url), 3) == "09"
Case Right(Allt(Url), 3) == "10"
Case Right(Allt(Url), 3) == "11"
Case Right(Allt(Url), 3) == "12"
Endcase
Endfunc
*************************************
Function IngresaDocumentoElectronicoconretencionAnticipo(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25, np26)
Local lC, lp
*:Global cur
lC			  = 'FuningresaDocumentoElectronico'
cur			  = "Xn"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
goApp.npara18 = np18
goApp.npara19 = np19
goApp.npara20 = np20
goApp.npara21 = np21
goApp.npara22 = np22
goApp.npara23 = np23
goApp.npara24 = np24
goApp.npara25 = np25
goApp.npara26 = np26
*FOR x=1 TO 25
*   WAIT WINDOW 'hola'
*  cpara='np'+ALLTRIM(STR(x))
*   WAIT WINDOW EVALUATE(cpara)
*NEXT
*cad=goapp.npara1,goapp.npara2,goapp.npara3,goapp.npara4,goapp.npara5,goapp.npara6,goapp.npara7,goapp.npara8,goapp.npara9,goapp.npara10,goapp.npara11,goapp.npara12,goapp.npara13,goapp.npara14,goapp.npara15,goapp.npara16,goapp.npara17,goapp.npara18,goapp.npara19,goapp.npara20,goapp.npara21,goapp.npara22,goapp.npara23,goapp.npara24,goapp.npara25
Text To lp Noshow
(?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(' Ingresando Cabecera de Documento CPE Con RETENCION' )
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
************************
Function EJECUTARP(tcComando As String, clparametros As String, NombCursor As String )
Local lResultado As Integer
NCursor = Iif(Vartype(NombCursor) <> "C", "", NombCursor)
Local laError[1], lcError
lR = 0
If Empty(NombCursor) Then
	lR = SQLExec(goApp.bdConn, 'CALL ' + tcComando + clparametros)
Else
	lR = SQLExec(goApp.bdConn, 'CALL ' + tcComando + clparametros, NombCursor)
Endif
If lR > 0 Then
	Return 1
Else
	csql = 'CALL ' + tcComando + clparametros + ' Ha- ' + Alltrim(Str(goApp.bdConn))
*!*		Messagebox(csql, 16, MSGTITULO)
	If Aerror(laError) > 0 Then
		lcMsg = ""
		For ln = 1 To Alen(laError, 2)
			lcMsg = lcMsg + Transform(laError(1, ln)) + Chr(13)
		Endfor
		Aviso(lcMsg)
	Endif
	Return 0
Endif
Endfunc
***************
Function EJECUTARf(tcComando As String, lp As String, NCursor As String )
Local lResultado As Integer
NCursor = Iif(Vartype(NCursor) <> "C", "", NCursor)
Local laError[1], lcError
If Empty(NCursor) Then
	lR = SQLExec(goApp.bdConn, 'Select ' + Alltrim(tcComando) + Alltrim(lp))
Else
	lR = SQLExec(goApp.bdConn, 'Select ' + Alltrim(tcComando) + Alltrim(lp) + ' as Id ', NCursor)
Endif
*WAIT WINDOW 'hola'
*WAIT WINDOW lR
If lR > 0 Then
	Return 1
Else
	csql = 'Select ' + tcComando + Alltrim((lp)) + ' as Id '
	Strtofile(csql, Addbs(Sys(5) + Sys(2003)) + 'error0.txt')
*	Messagebox(csql, 16, MSGTITULO)
	If Aerror(laError) > 0
		lcMsg = ""
		For ln = 1 To Alen(laError, 2)
			lcMsg = lcMsg + Transform(laError(1, ln)) + Chr(13)
		Endfor
		Aviso(lcMsg)
	Endif
*!*		= Aerror(laError)
*!*	*conerror='N'
*!*	*For N = 1 To 7  && Display all elements of the array
*!*	*	conerror='S'
*!*	*	Wait Window laError(N)
*!*	*Endfor
*!*	*	cmerror = AErrorbd[2]
*!*	*	nroerror=laError(1)
*!*	*  WAIT WINDOW 'hola'
*!*	*    WAIT WINDOW nroerror

*!*		If Vartype(laError(2))='U' Or Isnull(Vartype(laError(2)))
*!*			cmensaje=Alltrim(laError(2))+' '+Alltrim(laError(3))
*!*		Else
*!*			cmensaje='No Especificado'
*!*		Endif
*!*	* lcError = IIF(vartype(laError(2)),laError(2),'no Especificado')
*!*	*	Strtofile(cmerror,'d:\psysl\error.txt')
*!*		Messagebox("Inconveniente " + Chr(13) + cmensaje, 16, MSGTITULO)
	Return 0
Endif
Endfunc
***************
Function EJECUTARS(tcComando As String, lp As String, NCursor As String )
Local lResultado As Integer
NCursor = Iif(Vartype(NCursor) <> "C", "", NCursor)
If Empty(NCursor) Then
	lR = SQLExec(goApp.bdConn, 'SELECT ' + tcComando + lp)
Else
	lR = SQLExec(goApp.bdConn, 'SELECT ' + tcComando + lp, NCursor)
Endif
If lR > 0 Then
	Return 1
Else
	Return 0
Endif
Endfunc
***************************
Function IngresaDocumentoElectronicocondetraccionconanticipo(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25, np26)
Local lC, lp
*:Global cur
lC			  = 'FuningresaDocumentoElectronicocondetraccion'
cur			  = "Xn"
goApp.npara1  = np1
goApp.npara2  = np2
goApp.npara3  = np3
goApp.npara4  = np4
goApp.npara5  = np5
goApp.npara6  = np6
goApp.npara7  = np7
goApp.npara8  = np8
goApp.npara9  = np9
goApp.npara10 = np10
goApp.npara11 = np11
goApp.npara12 = np12
goApp.npara13 = np13
goApp.npara14 = np14
goApp.npara15 = np15
goApp.npara16 = np16
goApp.npara17 = np17
goApp.npara18 = np18
goApp.npara19 = np19
goApp.npara20 = np20
goApp.npara21 = np21
goApp.npara22 = np22
goApp.npara23 = np23
goApp.npara24 = np24
goApp.npara25 = np25
goApp.npara26 = np26
Text To lp Noshow
(?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Ingresando Cabecera de Documento CPE Con DETRACCION' )
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
********************
Function Salir()
If Vartype(goApp.bdConn) = 'N' And goApp.bdConn > 0 Then
	CierraConexion(goApp.bdConn)
	goApp.bdConn = 0
Endif
Close All
Clear Events
On Shutdown
c1 = Addbs(Sys(5) + Sys(2003)) + 'a.json'
c2 = Addbs(Sys(5) + Sys(2003)) + 'config.json'
c3 = Addbs(Sys(5) + Sys(2003)) + 'v.json'
c4 = Addbs(Sys(5) + Sys(2003)) + 'd.json'
Delete File (c1)
Delete File (c2)
Delete File (c3)
Delete File (c4)
Quit
Endfunc
********************
*-- crearBuffer
*   Funcion para crear un buffer de datos e inicializarlo. Compatible con VFP 5 o superior
*
*   Autor: V Espina
*
*   Ejemplo:
*   oBuff = CFDBuffer("Nombre,Apellido","Victor","Espina")
*   ?oBuff.Nombre -> "Victor"
*   ?oBuff.Apellido -> "Espina"
*
Procedure crearBuffer
Lparameters pcItemList, p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19
*
Local oBuff, i, cprop
oBuff = Createobject("Custom")

Local cPropname, uPropValue, nCount
Local Array aProps[1]
nCount = Alines(aProps, Strt(pcItemList, ",", Chr(13) + Chr(10)))
For i = 1 To Min(nCount, 20)
	cPropname = aProps[i]
	uPropValue = Evaluate("P" + Alltrim(Str(i - 1)))
	oBuff.AddProperty(cPropname, uPropValue)
Endfor

Return oBuff
*
Endproc
*************************
Procedure prLimpiaObjEmpty(oEmpty)
Local laProps, nCount, A, lcProp, uValue, cValueType, uEmptyValue
Dimension laProps[1]
nCount = Amembers(laProps, oEmpty)
For A = 1 To nCount
	lcProp = laProps[A]
	uValue = Getpem(oEmpty, lcProp)
	cValueType = Vartype(uValue)
	uEmptyValue = ""
	Do Case
	Case cValueType = "C"
		uEmptyValue = ""
	Case cValueType $ "NFIY"
		uEmptyValue = 0
	Case cValueType = "D"
		uEmptyValue = {}
	Case cValueType = "T"
		uEmptyValue = {//::}
	Case cValueType = "L"
		uEmptyValue = .F.
	Endcase
	Store uEmptyValue To ("oEmpty." + lcProp)
Endfor
Endproc
**********************************
Function IngresarNotasCreditoVentas1(np1, np2, np3)
Local cur As String
lC = 'FUNINGRESANOTASCREDITOventas1'
cur = "xi"
goApp.npara1 = np1
goApp.npara2 = np2
goApp.npara3 = np3
Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
Endtext
If EJECUTARf(lC, lp, cur) = 0 Then
	Errorbd(ERRORPROC + ' Ingresando Notas Credito de Ventas 1 ')
	Return 0
Else
	Return xi.Id
Endif
Endfunc
*********************
Function VerificaCorrelativo(np1, np2, np3)
*!*	TEXT TO lc TEXTMERGE NOSHOW FLAGS 2 PRETEXT 1+2+4
*!*	        r.cl,minimo,maximo,fechaminima,fechamaxima FROM (SELECT 1 AS cl,MAX(ndoc) AS minimo,MAX(fech) AS fechaminima FROM fe_rcom f WHERE
*!*			idcliente>0 AND acti='A' AND tdoc='<<np3>>'  AND  ndoc < '<<np1>>') AS p
*!*			INNER JOIN
*!*	        (SELECT 1 AS cl,MIN(ndoc) AS maximo,MIN(fech) AS fechamaxima FROM fe_rcom f WHERE
*!*			idcliente>0 AND acti='A' AND tdoc='<<np3>>'  AND ndoc > '<<np1>>') AS r ON r.cl=p.cl
*!*	ENDTEXT
Text To lC Textmerge Noshow Flags 2 Pretext 1 + 2 + 4
        cl,max(minimo) as minimo,cast(max(fechaminima) as date) as fechaminima,
        max(maximo) as maximo,cast(max(fechamaxima) as date) as fechamaxima from(
		select 1 as cl,max(numero) as minimo,MAX(fech) as fechaminima,0 as maximo,'0000-00-00' as fechamaxima  from(
		SELECT cast(mid(ndoc,5,8) as unsigned) as numero,fech FROM fe_rcom f where
		idcliente>0 and acti='A' and tdoc='<<np3>>'  and left(ndoc,4)='<<np1>>'  order by ndoc desc ) as x
		where numero < <<np2>>
		union all
		select 1 as cl,0 as minimo,'0000-00-00' as fechaminima,min(numero) as maximo,MIN(fech) as fechamaxima from(
		SELECT cast(mid(ndoc,5,8) as unsigned) as numero,fech FROM fe_rcom f where
		idcliente>0 and acti='A' and tdoc='<<np3>>'  and left(ndoc,4)='<<np1>>' and acti='A' order by ndoc desc) as x
		where numero><<np2>>) as y  group by cl;
Endtext
If EjecutaConsulta(lC, "ut") < 1
	Return 0
Endif
Return 1
Endfunc
****************
Function settingsclass()
Set Procedure To d:\capass\modelos\otrascompras, ;
	d:\capass\modelos\guiasremision, ;
	d:\capass\modelos\Rboletas, ;
	d:\capass\modelos\guiasremisionxvtas, ;
	d:\capass\modelos\guiasremisionxcompras, ;
	d:\capass\modelos\guiasremisionxdevolucion, ;
	d:\capass\modelos\guiasremisionxtraspaso, ;
	d:\capass\modelos\guiasremisionxconsignacion, ;
	d:\capass\modelos\dctos, ;
	d:\capass\modelos\tiendas.prg, ;
	d:\capass\modelos\ctasxcobrar, ;
	d:\capass\modelos\ctasxpagar, ;
	d:\capass\modelos\marcas, ;
	d:\capass\modelos\lineas, ;
	d:\capass\modelos\productos, ;
	d:\capass\modelos\vendedores, ;
	d:\capass\modelos\usuarios, ;
	d:\capass\modelos\ordenCompra, ;
	d:\capass\modelos\Ventas, ;
	d:\capass\modelos\cpesisven, ;
	d:\capass\modelos\correlativos, ;
	d:\capass\api\sire, ;
	d:\capass\modelos\compras, ;
	d:\capass\Excel\exportar, ;
	d:\capass\modelos\bancos Additive
AddProperty(_Screen, 'ordcompra', Createobject("OrdendeCompra"))
AddProperty(_Screen, 'otrascompras', Createobject("otrascompras"))
AddProperty(_Screen, 'oguia', Createobject('guiaremision'))
AddProperty(_Screen, 'orboletas', Createobject("rboletas"))
AddProperty(_Screen, 'oguiac', Createobject("guiaremisionxcompras"))
AddProperty(_Screen, 'oguiad', Createobject("guiaremisionxdevolucion"))
AddProperty(_Screen, 'oguiat', Createobject("guiaremisionxtraspaso"))
AddProperty(_Screen, 'oguiav', Createobject("guiaremisionxvtas"))
AddProperty(_Screen, 'oguiacon', Createobject("guiaremisionxconsignacion"))
AddProperty(_Screen, 'odctos', Createobject("dctos"))
AddProperty(_Screen, 'otda', Createobject("tienda"))
AddProperty(_Screen, 'octasxcobrar', Createobject("ctasporcobrar"))
AddProperty(_Screen, 'omarcas', Createobject("marcas"))
AddProperty(_Screen, 'olineas', Createobject("lineas"))
AddProperty(_Screen, 'oproductos', Createobject("producto"))
AddProperty(_Screen, 'octasxpagar', Createobject("ctasporpagar"))
AddProperty(_Screen, 'oventas', Createobject("ventas"))
AddProperty(_Screen, 'ovendedores', Createobject("vendedores"))
AddProperty(_Screen, 'ousuarios', Createobject("usuarios"))
AddProperty(_Screen, 'ocpe', Createobject("cpesisven"))
AddProperty(_Screen, 'ocorrelativo', Createobject("correlativo"))
AddProperty(_Screen, 'osire', Createobject("sire"))
AddProperty(_Screen, 'obcos', Createobject("bancos"))
AddProperty(_Screen, 'ocompras', Createobject("compras"))
AddProperty(_Screen, 'oexcel', Createobject("exportar"))
Endfunc
*****************************
Function ActualizaCursorStockx(nidtda, Calias)
Do Case
Case nidtda = 1
	Replace alma With lproductos.uno In (Calias)
Case nidtda = 2
	Replace alma With lproductos.Dos In (Calias)
Case nidtda = 3
	Replace alma With lproductos.tre In (Calias)
Case nidtda = 4
	Replace alma With lproductos.cua In (Calias)
Case nidtda = 5
	Replace alma With lproductos.cin In (Calias)
Case nidtda = 6
	Replace alma With lproductos.sei In (Calias)
Case nidtda = 7
	Replace alma With lproductos.sie In (Calias)
Case nidtda = 8
	Replace alma With lproductos.och In (Calias)
Case nidtda = 9
	Replace alma With lproductos.nue In (Calias)
Case nidtda = 10
	Replace alma With lproductos.die In (Calias)
Case nidtda = 11
	Replace alma With lproductos.onc In (Calias)
Case nidtda = 12
	Replace alma With lproductos.doce In (Calias)
Case nidtda = 13
	Replace alma With lproductos.trece In (Calias)
Case nidtda = 14
	Replace alma With lproductos.catorce In (Calias)
Case nidtda = 15
	Replace alma With lproductos.quince In (Calias)
Endcase
Endfunc
*********************
Function Aviso(tcMensaje As String)
Messagebox(m.tcMensaje, 64, MSGTITULO)
Endfunc
**********************
Function esFechaValidaftraslado(dFecha)
Local tnAnio, tnMes, tnDia
tnAnio = Year(dFecha)
tnMes = Month(dFecha)
tnDia = Day(dFecha)
Return ;
	Vartype(tnAnio) = "N" And ;
	Vartype(tnMes) = "N" And ;
	Vartype(tnDia) = "N" And ;
	Between(tnAnio, 2000, 9999) And ;
	Between(tnMes, 1, 12) And ;
	Between(tnDia, 1, 31) And ;
	Not Empty(Date(tnAnio, tnMes, tnDia));
	And (dFecha - fe_gene.fech) <= 1
Endfunc
***********************
Function Menuexportar()
Define Popup GridPopup ;
	From Mrow(), Mcol() ;
	Margin ;
	SHORTCUT
Define Bar 1 Of GridPopup Prompt "PDF        "
Define Bar 2 Of GridPopup Prompt "WhatsApp   "
Define Bar 3 Of GridPopup Prompt "Excel      "
On Selection Popup GridPopup opcionesexportar(Bar())
Activate Popup GridPopup
Release Popup GridPopup
********************
Function opcionesexportar(opt)
Calias = Alltrim(_Screen.cursorActivo)
cinforme = Alltrim(_Screen.cinforme)
Cpdf = Alltrim(_Screen.Cpdf)
cexcel = Alltrim(_Screen.cexcel)
Select (Calias)
Go Top
Do Case
Case opt = 1
	cambiarimpresoranormalpdf(cinforme)
Case opt = 2
	If !Empty(Cpdf) Then
		Do Foxypreviewer.App
		Report Form (cinforme)  Object Type 10 To File (Cpdf)
		Do Foxypreviewer.App With "Release"
		Do Form ka_messagew With Cpdf, _Screen.fonoenvio
	Endif
Case opt = 3
*!*		If !Empty(cexcel) Then
*!*			Do Foxypreviewer.App
*!*			Report Form (cinforme)  Object Type 13 To File (cexcel)
*!*			Do Foxypreviewer.App With "Release"
*!*		Endif
	Do Case
	Case _Screen.opcionexportar = '21'
*!*			_Screen.ActiveForm.Cmdaexcel1.Click()
	Case _Screen.opcionexportar = 'OC'
		_Screen.ActiveForm.Cmdaexcel1.Click()
	Case _Screen.opcionexportar = 'listatraspasos'
		_Screen.ActiveForm.Cmdaexcel1.Click()
	Endcase
Endcase
Endfunc
************************
Function MuestratVendedoresX(np1, Ccursor)
lC = 'PROMUESTRAtVENDEDORES'
goApp.npara1 = np1
Text To lp Noshow
     (?goapp.npara1)
Endtext
If EJECUTARP(lC, lp, Ccursor) = 0 Then
	Errorbd(ERRORPROC + ' Mostrando Lista Vendedores')
	Return 0
Else
	Return 1
Endif
Endfunc
******************************
Function MuestraVendedores(cb)
Set Procedure To d:\capass\modelos\vendedores Additive
oven = Createobject("vendedores")
If oven.MuestraVendedores('', 'lv') < 1 Then
	goApp.mensajeApp = oven.Cmensaje
	Return 0
Endif
Return 1
Endfunc
*********************************
Function MuestraVendedoresX(cb, Ccursor)
Set Procedure To d:\capass\modelos\vendedores Additive
oven = Createobject("vendedores")
If oven.MuestraVendedores('', Ccursor) < 1 Then
	goApp.mensajeApp = oven.Cmensaje
	Return 0
Endif
Return 1
Endfunc
*******************
*!*	Function MuestraVendedoresX(np1,ccursor)
*!*	lc='PROMUESTRAVENDEDORES'
*!*	goapp.npara1=np1
*!*	TEXT to lp noshow
*!*	     (?goapp.npara1)
*!*	ENDTEXT
*!*	If EJECUTARP(lc,lp,ccursor)<1  Then
*!*		errorbd(ERRORPROC + ' Mostrando Lista Vendedores')
*!*		Return 0
*!*	Else
*!*		Return 1
*!*	Endif
*!*	Endfunc
Function cambiarimpresoranormal(creporte)
If This.Idsesion > 1 Then
	Set DataSession To This.Idsesion
Endif
cpropiedad = "Impresoranormal"
If !Pemstatus(goApp, cpropiedad, 5)
	goApp.AddProperty("Impresoranormal", "")
Else
	lcImpresora = goApp.Impresoranormal
Endif
If !Empty(goApp.Impresoranormal) Then
	Declare Integer SetDefaultPrinter In WINSPOOL.DRV ;
		String pszPrinter
	lcImpresoraActual = ObtenerImpresoraActual()
	lcImpresora		  = goApp.Impresoranormal
	lnResultado		  = SetDefaultPrinter(lcImpresora)
	Set Printer To Name (lcImpresora)
	Report Form (creporte) Preview
	lnResultado = SetDefaultPrinter(lcImpresoraActual)
	Set Printer To Name (lcImpresoraActual)
Else
	Report Form (creporte) Preview
Endif
Endfunc
******************************************
Function ActualizaCursorStockxxsys3(nidtda, Calias)
Do Case
Case nidtda = 1
	Replace alma With 1, TAlma With lproductos.uno In (Calias)
Case nidtda = 2
	Replace alma With 2, TAlma With lproductos.Dos In (Calias)
Case nidtda = 3
	Replace alma With 3, TAlma With lproductos.tre In (Calias)
Case nidtda = 4
	Replace alma With 4, TAlma With lproductos.cua In (Calias)
Endcase
Endfunc



