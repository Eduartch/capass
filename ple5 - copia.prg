#Define ERRORPROC "NO SE EJECUTO CORRECTAMENTE EL PROCEDIMIENTO"
#Define MSGTITULO "Sisven"
#Define MENSAJE1 "NO Se envío el comprobante Por las siguientes razones"+Chr(13)+Chr(10)+" NO Hay Conexión a Internet "+Chr(13)+Chr(10)
#Define MENSAJE2 "NO Hay Respuesta desde la WEB SERVICE DE SUNAT"+Chr(13)+Chr(10)
#Define MENSAJE3 " Ya se envio correctamente pero la respuesta no se recibio Correctamente-(Consultar con Clave Sol en www.sunat.gob.pe)"
***********************
Function GeneraPlE5Compras(np1,np2,nmes,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select;
	Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'00' As Integer) As periodo,;
	Auto As nrolote,;
	Trim('M'+Alltrim(Str(Recno()))) As esta,;
	fech As fechae,;
	fech As fvto,;
	tdoc As tipocomp,;
	IIF(tdoc="10",'1683',Iif(tdoc='50',Left(Alltrim(Str(Val(serie))),3),Iif(Len(Alltrim(serie))<=3,'0','')+serie)) As serie,;
	Iif(tdoc='50',na,0000) As fdua,;
	ndoc As nrocomp,;
	'' As n1,;
	6 As tipodocp,;
	nruc As nruc,;
	razo As proveedor,;
	valorg As Base,;
	igvg As igv,;
	0 As Exon1,;
	0.00 As igvng,;
	0.00  As inafecta,;
	0.00 As igv1,;
	Exon,;
	0.00 As isc,;
	0 As otros,;
	importe As Total,;
	IIF(Mone='S','PEN','USD') As Mone,;
	dola As tipocambio,;
	Iif(Empty(fechn),Ctod("01/01/0001"),fechn) As fechn,;
	tref As tipon,;
	Iif(Empty(Left(Refe,4)),'-'+Space(4),Left(Refe,4)) As serien,;
	'   ' As dadu,;
	IIF(Empty(Refe),'-'+Space(8),Substr(Refe,5)) As ndocn,;
	IIF(Isnull(fechad),Ctod("01/01/0001"),Iif(Empty(fechad),Ctod("01/01/0001"),fechad)) As fechad,;
	IIF(Empty(detra),'0'+Space(20),detra) As nrod,;
	' ' As reten,;
	tipo As tipobien,;
	'   ' As proy,;
	'1' As errtc,;
	'1' As errpro1,;
	'1' As errpro2,;
	'1' As errpro3,;
	IIF(importe>3500,'1',' ') As Mpago,;
	Icase(tdoc='01',Iif(Month(fech)=nmes,'1','6'),;
	tdoc='02',Iif(Month(fech)=nmes,'0','0'),;
	tdoc='03',Iif(Month(fech)=nmes,'0','0'),;
	tdoc='05',Iif(Month(fech)=nmes,'1','6'),;
	tdoc='06',Iif(Month(fech)=nmes,'1','6'),;
	tdoc='07',Iif(Month(fech)=nmes,'1','6'),;
	tdoc='08',Iif(Month(fech)=nmes,'1','6'),;
	tdoc='10','0',;
	tdoc='12',Iif(Month(fech)=nmes,'1','6'),;
	tdoc='13',Iif(Month(fech)=nmes,'1','6'),;
	tdoc='14',Iif(Month(fech)=nmes,'1','6'),;
	tdoc='16','0',;
	tdoc='50',Iif(Month(fech)=nmes,'1','6'),;
	Iif(Month(fech)=nmes,'1','9')) As estado;
	From registro Where Left(razo,5)<>'-----'  Into Cursor lreg
*Iif(Empty(fechad),Ctod("01/01/0001"),fechad) As fechad
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	nlote=nrolote

	If nl=0 Then
    \\<<periodo>>|<<nrolote>>|<<esta>>|<<fechae>>|<<fvto>>|<<tipocomp>>|<<serie>>|<<fdua>>|<<nrocomp>>|<<n1>>|<<tipodocp>>|<<nruc>>|<<alltrim(proveedor)>>|<<base>>|<<igv>>|<<exon1>>|<<igvng>>|<<inafecta>>|<<igv1>>|<<exon>>|<<isc>>|<<otros>>|<<total>>|<<mone>>|<<tipocambio>>|<<fechn>>|<<tipon>>|<<serien>>|<<dadu>>|<<ndocn>>|<<fechad>>|<<nrod>>|<<reten>>|<<tipobien>>|<<proy>>|<<errtc>>|<<errpro1>>|<<errpro2>>|<<errpro3>>|<<mpago>>|<<estado>>|
	Else
     \<<periodo>>|<<nrolote>>|<<esta>>|<<fechae>>|<<fvto>>|<<tipocomp>>|<<serie>>|<<fdua>>|<<nrocomp>>|<<n1>>|<<tipodocp>>|<<nruc>>|<<alltrim(proveedor)>>|<<base>>|<<igv>>|<<exon1>>|<<igvng>>|<<inafecta>>|<<igv1>>|<<exon>>|<<isc>>|<<otros>>|<<total>>|<<mone>>|<<tipocambio>>|<<fechn>>|<<tipon>>|<<serien>>|<<dadu>>|<<ndocn>>|<<fechad>>|<<nrod>>|<<reten>>|<<tipobien>>|<<proy>>|<<errtc>>|<<errpro1>>|<<errpro2>>|<<errpro3>>|<<mpago>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************************
Function GeneraPLE5VENTAS(np1,np2)
*	*IIF(tdoc='01',Iif(Left(nruc,1)='*','0','6'),Iif(Len(Alltrim(ndni))<=8,'0',IIF(LEN(ALLTRIM(nruc))=11,'6','1'))) As tipodocc,
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select;
	Cast(Alltrim(Str(Year(fech)))+Iif(Month(fech)<=9,'0'+Alltrim(Str(Month(fech))),Alltrim(Str(Month(fech))))+'00' As Integer) As periodo,;
	Auto As nrolote,;
	Trim('M'+Alltrim(Str(Recno()))) As esta,;
	fech As fecha,;
	fech As fvto,;
	tdoc As tipocomp,;
	IIF(Len(Alltrim(serie))<=3,'0'+Trim(serie),Trim(serie)) As serie,;
	Round(Val(ndoc),0) As nrocomp,;
	' ' As consolidado,;
	ICASE(tdoc='01',Iif(Left(nruc,1)='*','0','6'),;
	tdoc='03',Iif(Len(Alltrim(ndni))<8,'0','1'),;
	tdoc='07',Iif(Len(Alltrim(nruc))=11,'6','1'),;
	tdoc='08',Iif(Len(Alltrim(nruc))=11,'6','1'),'1') As tipodocc,;
	ICASE(tdoc='03',Iif(Empty(ndni),'0'+Space(11),ndni+Space(3)),tdoc='01',Iif(Left(nruc,1)='*','0'+Space(11),nruc),Iif(Empty(nruc),ndni+Space(3),Iif(Left(nruc,1)='*','-'+Space(11),nruc))) As nruc,;
	IIF(tdoc='03',Iif(Empty(ndni),'-'+Space(40),razo),Iif(Left(nruc,1)='*','-'+Space(40),razo)) As cliente,;
	0.00 As exporta,;
	valorg As Base,;
	0.00 As dsctoigv,;
	igvg As igv,;
	0.00 As dsctoigv1,;
	Exon As Exon,;
	0.00 As inafecta,;
	0.00 As isc,;
	0.00 As pilado,;
	0.00 As igvp,;
	0.00 As otros,;
	importe As Total,;
	IIF(Mone='S','PEN','USD') As Mone,;
	IIF(dola>0,dola,3.305) As tipocambio,;
	Iif(Empty(fechn),Ctod("01/01/0001"),fechn) As fechn,;
	Iif(Empty(tref),'00',tref) As tipon,;
	Iif(Empty(Left(Refe,4)),'-'+Space(3),Iif(Len(Alltrim(Refe))<3,'0'+Left(Refe,3),Left(Refe,4))) As serien,;
	IIF(Empty(Refe),'-'+Space(10),Iif(Len(Alltrim(Refe))<3,Substr(Refe,4),Substr(Refe,5))) As ndocn,;
	' ' As contrato,;
	'1' As errtc,;
	IIF(importe>3500,'1',' ') As Mpago,;
	Iif(Left(nruc,1)='*','2','1') As estado From registro Where Left(razo,5)<>'-----'  Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
   \\<<periodo>>|<<nrolote>>|<<esta>>|<<fecha>>|<<fvto>>|<<tipocomp>>|<<serie>>|<<nrocomp>>|<<consolidado>>|<<tipodocc>>|<<nruc>>|<<ALLTRIM(cliente)>>|<<exporta>>|<<base>>|<<dsctoigv>>|<<igv>>|<<dsctoigv1>>|<<exon>>|<<inafecta>>|<<isc>>|<<pilado>>|<<igvp>>|<<otros>>|<<total>>|<<mone>>|<<tipocambio>>|<<fechn>>|<<tipon>>|<<serien>>|<<ndocn>>|<<contrato>>|<<errtc>>|<<mpago>>|<<estado>>|
	Else
    \<<periodo>>|<<nrolote>>|<<esta>>|<<fecha>>|<<fvto>>|<<tipocomp>>|<<serie>>|<<nrocomp>>|<<consolidado>>|<<tipodocc>>|<<nruc>>|<<ALLTRIM(cliente)>>|<<exporta>>|<<base>>|<<dsctoigv>>|<<igv>>|<<dsctoigv1>>|<<exon>>|<<inafecta>>|<<isc>>|<<pilado>>|<<igvp>>|<<otros>>|<<total>>|<<mone>>|<<tipocambio>>|<<fechn>>|<<tipon>>|<<serien>>|<<ndocn>>|<<contrato>>|<<errtc>>|<<mpago>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
***********************
Function GeneraPlE5Compras1(np1,np2,nmes,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select;
	Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'00' As Integer) As c1,;
	Auto As c2,;
	Trim('M'+Alltrim(Str(Recno()))) As c3,;
	com1_fech As c4,;
	com1_tdoc As c5,;
	com1_ser1 As c6,;
	com1_ndoc As c7,;
	com1_valo As c8,;
	com1_otro As c9,;
	com1_impo As c10,;
	com1_tdoc1 As c11,;
	com1_serie1 As c12,;
	com1_año As c13,;
	com1_ndoc1 As c14,;
	com1_rete As c15,;
	com1_mone As c16,;
	com1_dola As c17,;
	com1_pais As c18,;
	razo As c19,;
	dire As c20,;
	nruc As c21,;
	ndni As c22,;
	razo1 As c23,;
	com1_pais1 As c24,;
	com1_vinc As c25,;
	com1_renta As c26,;
	com1_cost As c27,;
	com1_rneta As c28,;
	com1_vrenta As c29,;
	com1_irete As c30,;
	com1_conv As c31,;
	com1_exon As c32,;
	com1_trta As c33,;
	com1_modo As c34,;
	com1_aplica As c35,;
	IIF(Month(com1_fech)=nmes,'1','6') As c36;
	From lnd Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
    \\<<c1>>|<<c2>>|<<c3>>|<<c4>>|<<c5>>|<<c6>>|<<c7>>|<<c8>>|<<c9>>|<<c10>>|<<c11>>|<<c12>>|<<c13>>|<<c14>>|<<c15>>|<<c16>>|<<c17>>|<<c18>>|<<TRIM(c19)>>|<<TRIM(c20)>>|<<c21>>|<<c22>>|<<TRIM(c23)>>|<<c24>>|<<c25>>|<<c26>>|<<c27>>|<<c28>>|<<c29>>|<<c30>>|<<c30>>|<<c31>>|<<c32>>|<<c33>>|<<c34>>|<<c35>>|<<c36>>|

	Else
     \<<c1>>|<<c2>>|<<c3>>|<<c4>>|<<c5>>|<<c6>>|<<c7>>|<<c8>>|<<c9>>|<<c10>>|<<c11>>|<<c12>>|<<c13>>|<<c14>>|<<c15>>|<<c16>>|<<c17>>|<<c18>>|<<TRIM(c19)>>|<<TRIM(c20)>>|<<c21>>|<<c22>>|<<TRIM(c23)>>|<<c24>>|<<c25>>|<<c26>>|<<c27>>|<<c28>>|<<c29>>|<<c30>>|<<c30>>|<<c31>>|<<c32>>|<<c33>>|<<c34>>|<<c35>>|<<c36>>|
	Endif
	nl=nl+1
Endscan
*<<c21>>|<<c22>>|<<TRIM(c23)>>|<<c24>>|<<c25>>|<<c26>>|<<c27>>|<<c28>>|<<c29>>|<<c30>>|<<c30>>|<<c31>>|<<c32>>|<<c33>>|<<c34>>|<<c35>>|<<c36>>|
Set Textmerge To
Set Textmerge Off
Endfunc
****************************************
Function GeneraDiarioPle5(np1,np2,mes,na)
Select;
	Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'00' As Integer) As periodo,;
	TRIM(Auto)+Alltrim(Str(Recno())) As nrolote,;
	AllTrim(Iif(rdiario.estado='I','A','M')+Alltrim(Str(ldia_idld))) As esta,;
	Left(ncta,2)+Substr(ncta,4,2)+Substr(ncta,7,2) As ncta,;
	' ' As Codigo1,;
	' ' As Ccostos,;
	'PEN' As Moneda,;
	'6' As tipodcto,;
	ALLTRIM(fe_gene.nruc)+Space(4) As nruc,;
	'00' As tdoc,;
	'     ' As  serie,;
	auto As ndoc,;
	Ttod(fech) As fecha,;
	Ttod(fech) As fechavto,;
	Ttod(fech) As fechar,;
	Iif(Empty(detalle),Left(nomb,100),Left(detalle,100)) As detalle,;
	' ' As desc1,;
	debe,;
	haber,;
	'' As estructura,;
	1 As estado From rdiario Into Cursor lreg
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
        \\<<periodo>>|<<nrolote>>|<<esta>>|<<ncta>>|<<codigo1>>|<<ccostos>>|<<moneda>>|<<tipodcto>>|<<nruc>>|<<tdoc>>|<<serie>>|<<ndoc>>|<<fecha>>|<<fechavto>>|<<fechar>>|<<detalle>>|<<desc1>>|<<debe>>|<<haber>>|<<estructura>>|<<estado>>|
	Else
         \<<periodo>>|<<nrolote>>|<<esta>>|<<ncta>>|<<codigo1>>|<<ccostos>>|<<moneda>>|<<tipodcto>>|<<nruc>>|<<tdoc>>|<<serie>>|<<ndoc>>|<<fecha>>|<<fechavto>>|<<fechar>>|<<detalle>>|<<desc1>>|<<debe>>|<<haber>>|<<estructura>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
****************************************
Function GeneraPlanCuentasPle5(np1,np2)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select;
	Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'01' As Integer) As periodo,;
	Left(ncta,2)+Substr(ncta,4,2)+Substr(ncta,7,2) As ncta,;
	nomb As nombrecta,;
	'01' As tplan,;
	'       ' As descPlan,;
	' ' As Codigo1,;
	' ' As desc1,;
	1 As estado;
	From rdiario Into Cursor lreg Group By ncta
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<ncta>>|<<nombrecta>>|<<tplan>>|<<descPlan>>|<<codigo1>>|<<desc1>>|<<estado>>|
	Else
           \<<periodo>>|<<ncta>>|<<nombrecta>>|<<tplan>>|<<descPlan>>|<<codigo1>>|<<desc1>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
****************************************
Function GeneraMayorPle5(np1,np2,nmes,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select;
	Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'00' As Integer) As periodo,;
	ldia_nume As nrolote,;
	Trim(Iif(rld.estado='I','A','M')+Alltrim(Str(Recno()))) As esta,;
	Left(ncta,2)+Substr(ncta,4,2)+Substr(ncta,7,2) As ncta,;
	' ' As Codigo1,;
	' ' As Ccostos,;
	'PEN' As Moneda,;
	'6' As tipodcto,;
	fe_gene.nruc As nruc,;
	'00' As tdoc,;
	'      ' As serie,;
	ldia_nume As ndoc,;
	ldia_fech As fecha,;
	ldia_fech As fechavto,;
	ldia_fech As fechar,;
	Left(nomb,100) As detalle,;
	'  ' As detalle1,;
	deudor,;
	acreedor,;
	'' As estructura,;
	1 As estado;
	From rld  Where deudor >0 Or acreedor>0 Into Cursor lreg Order By ldia_fech
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<nrolote>>|<<esta>>|<<ncta>>|<<codigo1>>|<<ccostos>>|<<moneda>>|<<tipodcto>>|<<nruc>>|<<tdoc>>|<<serie>>|<<ndoc>>|<<fecha>>|<<fechavto>>|<<fechar>>|<<detalle>>|<<detalle1>>|<<deudor>>|<<acreedor>>|<<estructura>>|<<estado>>|
	Else
           \<<periodo>>|<<nrolote>>|<<esta>>|<<ncta>>|<<codigo1>>|<<ccostos>>|<<moneda>>|<<tipodcto>>|<<nruc>>|<<tdoc>>|<<serie>>|<<ndoc>>|<<fecha>>|<<fechavto>>|<<fechar>>|<<detalle>>|<<detalle1>>|<<deudor>>|<<acreedor>>|<<estructura>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
****************************************
Function GeneraLCajaEPle5(np1,np2,nmes,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'00' As Integer) As periodo,;
	'M'+Alltrim(Str(Recno())) As esta,Trim(Auto)+Alltrim(Str(Recno())) As nrolote,Left(ncta,2)+Substr(ncta,4,2)+Substr(ncta,7,2) As ncta,' ' As Codigo1,' ' As Ccostos,'PEN' As Moneda,;
	'00' As tdoc,Iif(Empty(Auto),'SD  ','0'+Left(rcaja.Auto,3)) As serie,Iif(Empty(Auto),'SD         ',Substr(rcaja.Auto,4)) As ndoc,;
	rcaja.fech As fechar,rcaja.fech As fechavto,rcaja.fech As fecha,Left(detalle,100) As detalle,'  ' As detalle1,;
	Iif(debe<0,Abs(debe),debe) As debe,Iif(haber<0,Abs(haber),haber) As haber,' ' As estructura,;
	1 As estado From rcaja  Where xtipo<>'.' Into Cursor lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Select lreg
Scan
	If nl=0 Then
          \\<<periodo>>|<<nrolote>>|<<esta>>|<<ncta>>|<<codigo1>>|<<ccostos>>|<<moneda>>|<<tdoc>>|<<serie>>|<<ndoc>>|<<fecha>>|<<fechavto>>|<<fechar>>|<<detalle>>|<<detalle1>>|<<debe>>|<<haber>>|<<estructura>>|<<estado>>|
	Else
           \<<periodo>>|<<nrolote>>|<<esta>>|<<ncta>>|<<codigo1>>|<<ccostos>>|<<moneda>>|<<tdoc>>|<<serie>>|<<ndoc>>|<<fecha>>|<<fechavto>>|<<fechar>>|<<detalle>>|<<detalle1>>|<<debe>>|<<haber>>|<<estructura>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
****************************************
Function MuesTraTiposBienes(lista)
Dimension lista[4]
lista[0]="1	Mercaderia,Materia Prima,Suministro,Envases y Embalajes"
lista[1]="2	Activo Fijo"
lista[2]="3	Otros Gastos No Considerados en 1 y 2"
lista[3]="4	Gastos de Educación,Recreación, Salud, Culturales Representación,Capacitación,De Viaje,Mantenimiento de Vehiculo Y de Premios"
lista[4]="5	Otros Gastos No Incluidos en el Numeral 4"
Return
Endfunc
*****************************************
Function IngresaDatosDiarioPle5(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17)
cur="l"
lc="FunIngresaDatosLibroDiarioPLe5"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
goapp.npara11=np11
goapp.npara12=np12
goapp.npara13=np13
goapp.npara14=np14
goapp.npara15=np15
goapp.npara16=np16
goapp.npara17=np17
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' '+' Ingresando Asientos  a Libro Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
******************
Function AnularComprasLibroDiario(np1,np2,np3)
cur=""
lc="ProAnulaDatosLibroDiarioPLe5"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' '+' Ingresando Asientos  a Libro Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************************
Function GeneraTxtRetenciones(np1,np2)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select '6' As motivo,Left(rete_ndoc,4) As serie,;
	SUBSTR(rete_ndoc,5) As ndoc,rete_fech As fecha,nruc,'6' As tipodoc,rete_impo,;
	razo,'01' As codret,dret_valor,tpagado,tdoc,Iif(Len(Alltrim(ndoc))<10,Left(ndoc,3),Left(ndoc,4)) As seried,;
	IIF(Len(Alltrim(ndoc))<10,Substr(ndoc,4),Substr(ndoc,5)) As ndocd,fech,dret_impo,'PEN' As Moneda,Impo,rete_dola,dret_iddr As numerop,;
	impo-dret_impo As neto From lr Into Cursor lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Select lreg
Scan
	If nl=0 Then
          \\<<motivo>>|<<serie>>|<<ndoc>>|<<fech>>|<<nruc>>|<<tipodoc>>|<<razo>>|<<codret>>|<<dret_valor>>|<<rete_impo>>|<<tpagado>>|<<tdoc>>|<<seried>>|<<ndocd>>|<<fech>>|<<dret_impo>>|<<moneda>>|<<fecha>>|<<numerop>>|<<impo>>|<<moneda>>|<<impo>>|<<dret_impo>>|<<fech>>|<<neto>>|<<moneda>>|<<rete_dola>>|<<fecha>>|
	Else
           \<<motivo>>|<<serie>>|<<ndoc>>|<<fech>>|<<nruc>>|<<tipodoc>>|<<razo>>|<<codret>>|<<dret_valor>>|<<rete_impo>>|<<tpagado>>|<<tdoc>>|<<seried>>|<<ndocd>>|<<fech>>|<<dret_impo>>|<<moneda>>|<<fecha>>|<<numerop>>|<<impo>>|<<moneda>>|<<impo>>|<<dret_impo>>|<<fech>>|<<neto>>|<<moneda>>|<<rete_dola>>|<<fecha>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*******************************************
Function MuestraTabla4(cur)
lc="ProMuestraTabla4"
lp=""
If EJECUTARP(lc,lp,cur)<1 Then
	errorbd(ERRORPROC+ ' '+' Mostrando el Contenido de Tabla 4')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function MuestraTabla35(cur)
lc="ProMuestraTabla35"
lp=""
If EJECUTARP(lc,lp,cur)<1 Then
	errorbd(ERRORPROC+ ' '+' Mostrando el Contenido de Tabla 35')
	Return 0
Else
	Return 1
Endif
Endfunc
***************************
Function RegistraComprasNOdomicilado(oret)
cur="Uy"
lc="FunIngresaND"
goapp.npara1=oret.np1
goapp.npara2=oret.np2
goapp.npara3=oret.np3
goapp.npara4=oret.np4
goapp.npara5=oret.np5
goapp.npara6=oret.np6
goapp.npara7=oret.np7
goapp.npara8=oret.np8
goapp.npara9=oret.np9
goapp.npara10=oret.np10
goapp.npara11=oret.np11
goapp.npara12=oret.np12
goapp.npara13=oret.np13
goapp.npara14=oret.np14
goapp.npara15=oret.np15
goapp.npara16=oret.np16
goapp.npara17=oret.np17
goapp.npara18=oret.np18
goapp.npara19=oret.np19
goapp.npara20=oret.np20
goapp.npara21=oret.np21
goapp.npara22=oret.np22
goapp.npara23=oret.np23
goapp.npara24=oret.np24
goapp.npara25=oret.np25
goapp.npara26=oret.np26
goapp.npara27=oret.np27
goapp.npara28=oret.np28
goapp.npara29=oret.np29
goapp.npara30=oret.np30
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,
      ?goapp.npara26,?goapp.npara27,?goapp.npara28,?goapp.npara29,?goapp.npara30)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' '+' Ingresando Documentos a Registros de No Domicilados')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************************
Function  ActualizaComprasNOdomicilado(oret)
cur=""
lc="ActualizaND"
goapp.npara1=oret.np1
goapp.npara2=oret.np2
goapp.npara3=oret.np3
goapp.npara4=oret.np4
goapp.npara5=oret.np5
goapp.npara6=oret.np6
goapp.npara7=oret.np7
goapp.npara8=oret.np8
goapp.npara9=oret.np9
goapp.npara10=oret.np10
goapp.npara11=oret.np11
goapp.npara12=oret.np12
goapp.npara13=oret.np13
goapp.npara14=oret.np14
goapp.npara15=oret.np15
goapp.npara16=oret.np16
goapp.npara17=oret.np17
goapp.npara18=oret.np18
goapp.npara19=oret.np19
goapp.npara20=oret.np20
goapp.npara21=oret.np21
goapp.npara22=oret.np22
goapp.npara23=oret.np23
goapp.npara24=oret.np24
goapp.npara25=oret.np25
goapp.npara26=oret.np26
goapp.npara27=oret.np27
goapp.npara28=oret.np28
goapp.npara29=oret.np29
goapp.npara30=oret.np30
goapp.npara31=oret.np31
goapp.npara32=oret.np32
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,
      ?goapp.npara26,?goapp.npara27,?goapp.npara28,?goapp.npara29,?goapp.npara30,?goapp.npara31,?goapp.npara32)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' '+' Ingresando Documentos a Registros de No Domicilados')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************************
Function GeneraPlE5IPV(np1,np2,nmes,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select;
	Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'00' As Integer) As periodo,;
	nreg As nrolote,;
	Trim('M'+Alltrim(Str(nreg))) As esta,;
	fe_gene.ubigeo As codest,;
	'9' As codcatalogo,;
	'01' As tipoexistencia,;
	coda,;
	'' As coda1,;
	fech As fechae,;
	ICASE(tdoc='II','00',tdoc='GI','00',tdoc='TT','00',tdoc) As tipocomp,;
	iif(tdoc='50',Substr(serie,2,3),Right("0000"+Alltrim(serie),4)) As serie,;
	IIF(tdoc='50',Right(ndoc,6),ndoc) As ndoc,;
	iif(ingr>0,Iif(tdoc='50','18',Iif(tdoc='00','16','02')),'01') As TipoOperacion,;
	DESC As Descripcion,;
	'NIU' As UnidadMedida,;
	'1' As tipovaluacion,;
	ingr,;
	prei,;
	impi,;
	egre,;
	pree,;
	impe,;
	stock,;
	IIF(cost<0,0000000.00,cost) As costo,;
	saldo,;
	'1' As estado;
	From k Where nreg>0 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	nlote=nrolote
	If nl=0 Then
    \\<<periodo>>|<<nrolote>>|<<esta>>|<<codest>>|<<codcatalogo>>|<<tipoexistencia>>|<<coda>>|<<coda1>>|<<fechae>>|<<tipocomp>>|<<serie>>|<<ndoc>>|<<tipooperacion>>|<<descripcion>>|<<unidadmedida>>|<<tipovaluacion>>|<<ingr>>|<<prei>>|<<impi>>|<<egre>>|<<pree>>|<<impe>>|<<stock>>|<<costo>>|<<saldo>>|<<estado>>|
	Else
     \<<periodo>>|<<nrolote>>|<<esta>>|<<codest>>|<<codcatalogo>>|<<tipoexistencia>>|<<coda>>|<<coda1>>|<<fechae>>|<<tipocomp>>|<<serie>>|<<ndoc>>|<<tipooperacion>>|<<descripcion>>|<<unidadmedida>>|<<tipovaluacion>>|<<ingr>>|<<prei>>|<<impi>>|<<egre>>|<<pree>>|<<impe>>|<<stock>>|<<costo>>|<<saldo>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
***************************************
Procedure EnviarSunat(pk,crptahash)
Declare Integer CryptBinaryToString In Crypt32;
	STRING @pbBinary, Long cbBinary, Long dwFlags,;
	STRING @pszString, Long @pcchString

Declare Integer CryptStringToBinary In crypt32;
	STRING @pszString, Long cchString, Long dwFlags,;
	STRING @pbBinary, Long @pcbBinary,;
	LONG pdwSkip, Long pdwFlags

#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056
Set Library To Locfile("vfpcompression.fll")
ZipfileQuick(goapp.carchivo)
zipclose()
cpropiedad="ose"
If !Pemstatus(goapp,cpropiedad,5)
	goapp.AddProperty("ose","")
Endif

cpropiedad="Grabarxmlbd"
If !Pemstatus(goapp,cpropiedad,5)
	goapp.AddProperty("Grabarxmlbd","")
Endif


If !Empty(goapp.ose) Then
	Do Case
	Case goapp.ose="nubefact"
		Do Case
		Case goapp.tipoh=='B'
			lsURL   = "https://demo-ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor=fe_gene.nruc
			ls_pwd_sol = 'moddatos'
			ls_user = ls_ruc_emisor + 'MODDATOS'
		Case goapp.tipoh='P'
			lsURL  =  "https://ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
			ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
			ls_user = ls_ruc_emisor + Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
		Endcase
	Case goapp.ose="bizlinks"
		Do Case
		Case goapp.tipoh=='B'
			lsURL   = "https://osetesting.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=fe_gene.nruc
			ls_pwd_sol = 'TESTBIZLINKS'
			ls_user = Alltrim(fe_gene.nruc)+'BIZLINKS'
		Case goapp.tipoh='P'
			lsURL  =  "https://ose.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
			ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
			ls_user = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
		Endcase
	Case goapp.ose="conastec"
		Do Case
		Case goapp.tipoh=='B'
			lsURL   = "https://test.conose.pe:443/ol-ti-itcpe/billService"
			lsURL   = "https://test.conose.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=fe_gene.nruc
			ls_pwd_sol = 'moddatos'
			ls_user = ls_ruc_emisor + 'MODDATOS'
		Case goapp.tipoh='P'
			lsURL  =  "https://prod.conose.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
			ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
			ls_user = ls_ruc_emisor + Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
		Endcase
	Case goapp.ose="efact"
		Do Case
		Case goapp.tipoh=='B'
			lsURL   = "https://ose-gw1.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=fe_gene.nruc
			ls_pwd_sol = 'iGje3Ei9GN'
			ls_user = ls_ruc_emisor
		Case goapp.tipoh='P'
			lsURL  =  "https://ose.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
			ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
			ls_user = ls_ruc_emisor + Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
		Endcase
	Endcase
Else
	Do Case
	Case goapp.tipoh=='B'
		lsURL   = "https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService"
		ls_ruc_emisor=fe_gene.nruc
		ls_pwd_sol = 'moddatos'
		ls_user = ls_ruc_emisor + 'MODDATOS'
	Case goapp.tipoh=='H'
		lsURL   = "https://www.sunat.gob.pe/ol-ti-itcpgem-sqa/billService"
		ls_ruc_emisor=fe_gene.nruc
		ls_pwd_sol = Alltrim(fe_gene.gene_csol)
		ls_user = ls_ruc_emisor + Alltrim(fe_gene.gene_usol)
	Case goapp.tipoh='P'
		lsURL   = "https://www.sunat.gob.pe/ol-ti-itcpfegem/billService"
		lsURL  =  "https://e-factura.sunat.gob.pe/ol-ti-itcpfegem/billService"
		ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
		ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
		ls_user = ls_ruc_emisor + Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
	Otherwise
		lsURL   = "https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService"
		ls_ruc_emisor=Iif(Type("oempresa")="U",fe_gene.nruc,oempresa.nruc)
		ls_pwd_sol = Iif(Type("oempresa")="U",Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
		ls_user = ls_ruc_emisor + Iif(Type("oempresa")="U",Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
	Endcase
Endif
npos=At('.',goapp.carchivo)
carchivozip=Substr(goapp.carchivo,1,npos-1)
ps_fileZip = carchivozip+'.zip'
ls_fileName = Justfname(ps_fileZip)
ls_contentFile = Filetostr(ps_fileZip)
crespuesta=ls_fileName
ls_base64 = Strconv(ls_contentFile, 13) && Encoding base 64
Do Case
Case  goapp.ose='conastec'
	TEXT TO ls_envioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
	ENDTEXT
Case  goapp.ose='bizlinks'
	TEXT TO ls_envioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
	ENDTEXT


Case goapp.ose="efact"
	TEXT TO ls_envioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
	ENDTEXT
Otherwise
	TEXT TO ls_envioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
	ENDTEXT
Endcase
If goapp.ose='bizlinks' Then
	oXMLHttp=Createobject("MSXML2.XMLHTTP.6.0")
Else
	oXMLHttp=Createobject("MSXML2.ServerXMLHTTP.6.0")
Endif
oXMLBody=Createobject('MSXML2.DOMDocument.6.0')
If !(oXMLBody.LoadXML(ls_envioXML)) Then
	oResp.mensaje = "No se cargo XML: " + oXMLBody.parseError.reason
	Return 0
Endif
oXMLHttp.Open('POST', lsURL, .F.)
oXMLHttp.setRequestHeader( "Content-Type", "text/xml" )
If goapp.ose='conastec' Or goapp.ose='efact' Or goapp.ose='bizlinks' Then
	oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8" )
Else
	oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" )
Endif
oXMLHttp.setRequestHeader( "Content-Length", Len(ls_envioXML))
If goapp.ose='bizlinks' Or  goapp.ose='conastec' Or goapp.ose='efact' Then
	oXMLHttp.setRequestHeader( "SOAPAction" , "urn:sendBill" )
Else
	oXMLHttp.setRequestHeader( "SOAPAction" , "sendBill" )
Endif
If goapp.ose<>'bizlinks' Then
	oXMLHttp.setOption(2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS)
Endif
oXMLHttp.Send(oXMLBody.documentElement.XML)
If (oXMLHttp.Status <> 200) Then
	Messagebox('Estado ' + Alltrim(Str(oXMLHttp.Status)) + '-' + Nvl(oXMLHttp.responseText,''),16,MSGTITULO)
	Return 0
Endif
loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
loXMLResp.LoadXML(oXMLHttp.responseText)
CmensajeError=leerXMl(Alltrim(oXMLHttp.responseText),"<faultcode>","</faultcode>")
CMensajeMensaje=leerXMl(Alltrim(oXMLHttp.responseText),"<faultstring>","</faultstring>")
CMensajeMensaje=leerXMl(Alltrim(oXMLHttp.responseText),"<faultstring>","</faultstring>")
CMensajedetalle=leerXMl(Alltrim(oXMLHttp.responseText),"<detail>","</detail>")
If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Then
	Messagebox((Alltrim(CmensajeError)+' '+Alltrim(CMensajeMensaje)+' '+Alltrim(CMensajedetalle)),16,'Sisven')
	Return 0
Endif
*Messagebox(oXMLHttp.responseText,16,'Sisven')
ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
ArchivoRespuestaSunat.LoadXML(oXMLHttp.responseText)			&&Llenamos el archivo de respuesta
TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//applicationResponse")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
If Type('oempresa')='U' Then
	cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+crespuesta
	cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'
Else
	cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+Alltrim(oempresa.nruc)+"\"+crespuesta
	cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"
Endif
decodefile(TxtB64.Text,cnombre)
oShell = Createobject("Shell.Application")
cfilerpta="R"
For Each oArchi In oShell.NameSpace(cnombre).Items
	If Left(oArchi.Name,1)='R' Then
		oShell.NameSpace(cDirDesti).CopyHere(oArchi)
		cfilerpta=Juststem(oArchi.Name)+'.XML'
	Endif
Endfor
If Type('oempresa')='U' Then
	cfilecdr=Sys(5)+Sys(2003)+'\SunatXML\'+cfilerpta
	rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+cfilerpta)
Else
	cfilecdr=Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"+cfilerpta
	rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"+cfilerpta)
Endif
If Len(Alltrim(rptaSunat))<=100 Then
	GuardaPk(pk,crptahash,cfilecdr)
Else
	Messagebox(rptaSunat,64,'Sisven')
	Return 0
Endif
Do Case
Case Left(rptaSunat,1)='0'
	mensaje(rptaSunat)
	Return 1
Case Empty(rptaSunat)
	Messagebox(rptaSunat,64,'Sisven')
	Return 5000
Otherwise
	Messagebox(rptaSunat,64,'Sisven')
	Return 0
Endcase
Endproc
&&Rutina para decodificar el base64 a zip este codigo lo obtuve de la pagina de Victor Espina el link directo esta aca(http://victorespina.com.ve/wiki/index.php?title=Parser_Base64_para_VFP_usando_CryptoAPI)
******************************
Function decodeString(pcB64)
Local nFlags, nBufsize, cDst
nFlags=1  && base64
nBufsize=0
pcB64 = Strt(Strt(Strt(pcB64,"\/","/"),"\u000d",Chr(13)),"\u000a",Chr(10))
CryptStringToBinary(@pcB64, Len(m.pcB64),nFlags, Null, @nBufsize, 0,0)
cDst = Replicate(Chr(0), m.nBufsize)
If CryptStringToBinary(@pcB64, Len(m.pcB64),nFlags, @cDst, @nBufsize, 0,0) = 0
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

If Not File(lCfileName)
	Return []
Endif
lcXML = Filetostr(lCfileName)
If "<DigestValue>" $ lcXML
	lnCount = 1
Else
	lnCount = 2
Endif
chash=""
For lnI = 1 To Occurs('<DigestValue>', lcXML)
	chash = Strextract(lcXML, '<DigestValue>','</DigestValue>',lnI)
Next lnI
Return chash
Endfunc
************************************
Function LeerRespuestaSunat(cfilerpta)
Local lnCount As Integer, ;
	lcXML As String, ;
	lcString As String
If Not File(cfilerpta) Then
	Return []
Endif
lcXML = Filetostr(cfilerpta)
If "<cbc:Description>" $ lcXML
	lnCount = 1
Else
	lnCount = 2
Endif
cresp=""
If goapp.ose='efac' Then
	For lnI = 1 To Occurs('<Description>', lcXML)
		cresp = Strextract(lcXML, '<Description>', '</Description>',lnI)
	Next lnI
Else
	For lnI = 1 To Occurs('<cbc:Description>', lcXML)
		cresp = Strextract(lcXML, '<cbc:Description>', '</cbc:Description>',lnI)
	Next lnI
Endif
*Leer Codigo de Respuesta*
If "<cbc:ResponseCode>" $ lcXML
	lnCount = 1
Else
	lnCount = 2
Endif
resp1=""
If !Empty(goapp.ose) Then
	If goapp.ose='efact' Then
		For lnI = 1 To Occurs('<ResponseCode listAgencyName="PE:SUNAT">', lcXML)
			resp1 = Strextract(lcXML, '<ResponseCode listAgencyName="PE:SUNAT">', '</ResponseCode>',lnI)
		Next lnI
	Else
		For lnI = 1 To Occurs('<cbc:ResponseCode listAgencyName="PE:SUNAT">', lcXML)
			resp1 = Strextract(lcXML, '<cbc:ResponseCode listAgencyName="PE:SUNAT">', '</cbc:ResponseCode>',lnI)
		Next lnI
	Endif
Else
	For lnI = 1 To Occurs('<cbc:ResponseCode>', lcXML)
		resp1 = Strextract(lcXML, '<cbc:ResponseCode>', '</cbc:ResponseCode>',lnI)
	Next lnI
Endif
Return resp1+' '+cresp
Endfunc
******************************
Procedure EnviarSunat1(pk,crhash)
#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056
Set Library To Locfile("vfpcompression.fll")
ZipfileQuick(goapp.carchivo)
zipclose()


cpropiedad="ose"
If !Pemstatus(goapp,cpropiedad,5)
	goapp.AddProperty("ose","")
Endif

cpropiedad="urlsunat"
If !Pemstatus(goapp,cpropiedad,5)
	goapp.AddProperty("urlsunat","")
Endif


cpropiedad="Grabarxmlbd"
If !Pemstatus(goapp,cpropiedad,5)
	goapp.AddProperty("Grabarxmlbd","")
Endif



If !Empty(goapp.ose) Then
	Do Case
	Case goapp.ose="nubefact"
		Do Case
		Case goapp.tipoh=='B'
			lsURL   = "https://demo-ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor=fe_gene.nruc
			ls_pwd_sol = 'moddatos'
			ls_user = ls_ruc_emisor + 'MODDATOS'
		Case goapp.tipoh='P'
			lsURL  =  "https://ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
			ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
			ls_user = ls_ruc_emisor + Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
		Endcase
	Case goapp.ose="efact"
		Do Case
		Case goapp.tipoh=='B'
			lsURL   ="https://ose-gw1.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=fe_gene.nruc
			ls_pwd_sol = 'iGje3Ei9GN'
			ls_user = ls_ruc_emisor
		Case goapp.tipoh='P'
			lsURL  =  "https://ose.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
			ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
			ls_user = ls_ruc_emisor + Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
		Endcase
	Case goapp.ose="bizlinks"
		Do Case
		Case goapp.tipoh=='B'
			lsURL   = "https://osetesting.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=fe_gene.nruc
			ls_pwd_sol = 'TESTBIZLINKS'
			ls_user = Alltrim(fe_gene.nruc)+'BIZLINKS'
		Case goapp.tipoh='P'
			lsURL  =  "https://ose.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
			ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
			ls_user = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
		Endcase
	Case goapp.ose="conastec"
		Do Case
		Case goapp.tipoh='B'
			lsURL   = "https://test.conose.pe:443/ol-ti-itcpe/billService"
			ls_ruc_emisor=fe_gene.nruc
			ls_pwd_sol = 'moddatos'
			ls_user = ls_ruc_emisor + 'MODDATOS'
		Case goapp.tipoh='P'
			lsURL  =  "https://prod.conose.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
			ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
			ls_user = ls_ruc_emisor + Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
		Endcase

	Endcase
Else
	Do Case
	Case goapp.tipoh=='B'
		lsURL   = "https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService"
		ls_ruc_emisor=fe_gene.nruc
		ls_pwd_sol = 'moddatos'
		ls_user = ls_ruc_emisor + 'MODDATOS'
	Case goapp.tipoh=='H'
		lsURL   = "https://www.sunat.gob.pe/ol-ti-itcpgem-sqa/billService"
		ls_ruc_emisor=fe_gene.nruc
		ls_pwd_sol = Alltrim(fe_gene.gene_csol)
		ls_user = ls_ruc_emisor + Alltrim(fe_gene.gene_usol)
	Case goapp.tipoh=='P'
		If Empty(goapp.urlsunat) Then
			lsURL   = "https://www.sunat.gob.pe/ol-ti-itcpfegem/billService"
* lsURL   = "https://e-factura.sunat.gob.pe/ol-ti-itcpfegem/billService"
		Else
			lsURL=Alltrim(goapp.urlsunat)
		Endif
*	lsURL   = "https://www.sunat.gob.pe/ol-ti-itcpfegem/billService"
*	    lsURL   = "https://e-factura.sunat.gob.pe/ol-ti-itcpfegem/billService"
		ls_ruc_emisor=Iif(Type("oempresa")="U",fe_gene.nruc,oempresa.nruc)
		ls_pwd_sol = Iif(Type("oempresa")="U",Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
		ls_user = ls_ruc_emisor + Iif(Type("oempresa")="U",Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
	Otherwise
		lsURL   = "https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService"
		ls_ruc_emisor=fe_gene.nruc
		ls_pwd_sol = Alltrim(fe_gene.gene_csol)
		ls_user = ls_ruc_emisor + Alltrim(fe_gene.gene_usol)
	Endcase
Endif
npos=At('.',goapp.carchivo)
ctipoarchivo=Justfname(goapp.carchivo)
carchivozip=Substr(goapp.carchivo,1,npos-1)
ps_fileZip = carchivozip+'.zip'
ls_fileName = Justfname(ps_fileZip)
ls_contentFile = Filetostr(ps_fileZip)
crespuesta=ls_fileName
ls_base64 = Strconv(ls_contentFile, 13) && Encoding base 64
Do Case
Case  goapp.ose='conastec'
	TEXT TO ls_envioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
	ENDTEXT
Case goapp.ose="efact"
	TEXT TO ls_envioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
	ENDTEXT
Case goapp.ose='bizlinks'
	TEXT TO ls_envioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
	ENDTEXT
Otherwise
	TEXT TO ls_envioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
	ENDTEXT
Endcase

If goapp.ose='bizlinks' Then
	oXMLHttp=Createobject("MSXML2.XMLHTTP.6.0")
Else
	oXMLHttp=Createobject("MSXML2.ServerXMLHTTP.6.0")
Endif
*oXMLHttp=Createobject("MSXML2.ServerXMLHTTP.6.0")
oXMLBody=Createobject('MSXML2.DOMDocument.6.0')
If !(oXMLBody.LoadXML(ls_envioXML)) Then
	oResp.mensaje = "No se cargo XML: " + oXMLBody.parseError.reason
	Return 0
Endif
oXMLHttp.Open('POST', lsURL, .F.)

If goapp.ose='conastec' Or goapp.ose='efact' Or goapp.ose='bizlinks'  Then
	oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8" )
Else
	oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" )
Endif


*oXMLHttp.setRequestHeader( "Content-Type", "text/xml" )
*oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" )
oXMLHttp.setRequestHeader( "Content-Length", Len(ls_envioXML) )
If goapp.ose='bizlinks'  Or goapp.ose='conastec' Or goapp.ose='efact'  Then
	oXMLHttp.setRequestHeader( "SOAPAction" , "urn:sendSummary" )
Else
	oXMLHttp.setRequestHeader( "SOAPAction" , "sendSummary" )
Endif
If goapp.ose<>'bizlinks'  Then
	oXMLHttp.setOption(2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS)
Endif
oXMLHttp.Send(oXMLBody.documentElement.XML)
If (oXMLHttp.Status <> 200) Then
	Messagebox('ESTADO: ' + Alltrim(Str(oXMLHttp.Status)) + '-' + Nvl(oXMLHttp.responseText,''),16,'Sisven')
	Return 0
Endif
loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
loXMLResp.LoadXML(oXMLHttp.responseText)
lcXML=oXMLHttp.responseText
If "<ticket>" $ lcXML
	lnCount = 1
Else
	lnCount = 2
Endif
cresp=""
For lnI = 1 To Occurs('<ticket>', lcXML)
	cresp = Strextract(lcXML, '<ticket>', '</ticket>',lnI)
Next lnI
mensaje(cresp)
goapp.ticket=Alltrim(cresp)
Select curb
Scan All
	If Substr(ctipoarchivo,13,2)='RA' Then
		If goapp.Grabarxmlbd='S' Then
			carxml=Filetostr(goapp.carchivo)
		Else
			carxml=""
		Endif
		If RegistraResumenBajas(curb.fech,curb.tdoc,curb.serie,curb.numero,curb.motivo,carxml,cresp,goapp.carchivo,crhash,curb.idauto)=0 Then
			Messagebox("NO se Registro EL Informe de BAJA en Base de Datos",16,MSGTITULO)
			Exit
		Endif
	Else
		If goapp.Grabarxmlbd='S' Then
			carxml=Filetostr(goapp.carchivo)
		Else
			carxml=""
		Endif
		If RegistraResumenBoletas(curb.fech,curb.tdoc,curb.serie,curb.desde,curb.hasta,curb.Impo,curb.valor,curb.Exon,curb.inafectas,curb.igv,curb.gratificaciones,;
				carxml,crhash,goapp.carchivo,cresp)=0 Then
			Messagebox("NO se Registro el Informe de Envío de Boletas en Base de Datos",16,MSGTITULO)
			Exit
		Endif
	Endif
Endscan
Return 1
Endproc
************************************
Procedure ConsultaTicket(cticket,carchivo)
Declare Integer CryptBinaryToString In Crypt32;
	STRING @pbBinary, Long cbBinary, Long dwFlags,;
	STRING @pszString, Long @pcchString

Declare Integer CryptStringToBinary In crypt32;
	STRING @pszString, Long cchString, Long dwFlags,;
	STRING @pbBinary, Long @pcbBinary,;
	LONG pdwSkip, Long pdwFlags

#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056

cpropiedad="ose"
If !Pemstatus(goapp,cpropiedad,5)
	goapp.AddProperty("ose","")
Endif
cpropiedad="urlsunat"
If !Pemstatus(goapp,cpropiedad,5)
	goapp.AddProperty("urlsunat","")
Endif

cpropiedad="Grabarxmlbd"
If !Pemstatus(goapp,cpropiedad,5)
	goapp.AddProperty("Grabarxmlbd","")
Endif




If !Empty(goapp.ose) Then
	Do Case
	Case goapp.ose="nubefact"
		Do Case
		Case goapp.tipoh=='B'
			lsURL   = "https://demo-ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor=fe_gene.nruc
			ls_pwd_sol = 'moddatos'
			ls_user = ls_ruc_emisor + 'MODDATOS'
		Case goapp.tipoh='P'
			lsURL  =  "https://ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
			ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
			ls_user = ls_ruc_emisor + Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
		Endcase
	Case goapp.ose="efact"
		Do Case
		Case goapp.tipoh=='B'
			lsURL   = "https://ose-gw1.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=fe_gene.nruc
			ls_pwd_sol = 'iGje3Ei9GN'
			ls_user = ls_ruc_emisor
		Case goapp.tipoh='P'
			lsURL  =  "https://ose.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
			ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
			ls_user = ls_ruc_emisor + Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
		Endcase
	Case goapp.ose="bizlinks"
		Do Case
		Case goapp.tipoh=='B'
			lsURL   = "https://osetesting.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=fe_gene.nruc
			ls_pwd_sol = 'TESTBIZLINKS'
			ls_user = Alltrim(fe_gene.nruc)+'BIZLINKS'
		Case goapp.tipoh='P'
			lsURL  =  "https://ose.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
			ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
			ls_user = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
		Endcase
	Case goapp.ose="conastec"
		Do Case
		Case goapp.tipoh=='B'
			lsURL   = "https://test.conose.pe:443/ol-ti-itcpe/billService"
			ls_ruc_emisor=fe_gene.nruc
			ls_pwd_sol = 'moddatos'
			ls_user = ls_ruc_emisor + 'MODDATOS'
		Case goapp.tipoh='P'
			lsURL  =  "https://prod.conose.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
			ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
			ls_user = ls_ruc_emisor + Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
		Endcase

	Endcase
Else
	Do Case
	Case goapp.tipoh=='B'
		lsURL   = "https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService"
		ls_ruc_emisor=fe_gene.nruc
		ls_pwd_sol = 'moddatos'
		ls_user = ls_ruc_emisor + 'MODDATOS'
	Case goapp.tipoh=='H'
		lsURL   = "https://www.sunat.gob.pe/ol-ti-itcpgem-sqa/billService"
		ls_ruc_emisor=fe_gene.nruc
		ls_pwd_sol = Alltrim(fe_gene.gene_csol)
		ls_user = ls_ruc_emisor + Alltrim(fe_gene.gene_usol)
	Case goapp.tipoh='P'
		If Empty(goapp.urlsunat) Then
			lsURL   = "https://www.sunat.gob.pe/ol-ti-itcpfegem/billService"
* lsURL   = "https://e-factura.sunat.gob.pe/ol-ti-itcpfegem/billService"
		Else
			lsURL=Alltrim(goapp.urlsunat)
		Endif
		ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
		ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
		ls_user = ls_ruc_emisor + Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
	Otherwise
		lsURL   = "https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService"
		ls_ruc_emisor=fe_gene.nruc
		ls_pwd_sol = Alltrim(fe_gene.gene_csol)
		ls_user = ls_ruc_emisor + Alltrim(fe_gene.gene_usol)
	Endcase
Endif
npos=At('.',carchivo)
carchivozip=Substr(carchivo,1,npos-1)
ps_fileZip = carchivozip+'.zip'
ls_fileName = Justfname(ps_fileZip)
ctipoarchivo=Justfname(carchivo)
crespuesta=ls_fileName
Do Case
Case  goapp.ose='conastec'
	TEXT TO ls_envioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
	ENDTEXT
Case goapp.ose="efact"
	TEXT TO ls_envioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
	ENDTEXT
Case  goapp.ose='bizlinks'
	TEXT TO ls_envioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
	ENDTEXT
Otherwise
	TEXT TO ls_envioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
	ENDTEXT
Endcase
If goapp.ose='bizlinks' Then
	oXMLHttp=Createobject("MSXML2.XMLHTTP.6.0")
Else
	oXMLHttp=Createobject("MSXML2.ServerXMLHTTP.6.0")
Endif

*oXMLHttp=Createobject("MSXML2.ServerXMLHTTP.6.0")
oXMLBody=Createobject('MSXML2.DOMDocument.6.0')
If !(oXMLBody.LoadXML(ls_envioXML)) Then
	oResp.mensaje = "No se cargo XML: " + oXMLBody.parseError.reason
	Return 0
Endif
oXMLHttp.Open('POST', lsURL, .F.)

If goapp.ose='conastec' Or goapp.ose='efact' Or goapp.ose='bizlinks' Then
	oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8" )
Else
	oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" )
Endif

*oXMLHttp.setRequestHeader( "Content-Type", "text/xml" )
*oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" )
oXMLHttp.setRequestHeader( "Content-Length", Len(ls_envioXML) )
If goapp.ose='bizlinks' Or goapp.ose='conastec' Or goapp.ose='efact'  Then
	oXMLHttp.setRequestHeader( "SOAPAction" , "urn:getStatus" )
Else
	oXMLHttp.setRequestHeader( "SOAPAction" , "getStatus" )
Endif
If goapp.ose<>'bizlinks' Then
	oXMLHttp.setOption(2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS)
Endif
oXMLHttp.Send(oXMLBody.documentElement.XML)
If (oXMLHttp.Status <> 200) Then
	Messagebox('STATUS: ' + Alltrim(Str(oXMLHttp.Status)) + '-' + Nvl(oXMLHttp.responseText,''),16,'Sisven')
	Return 0
Endif
loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
loXMLResp.LoadXML(oXMLHttp.responseText)
CmensajeError=leerXMl(Alltrim(oXMLHttp.responseText),"<faultcode>","</faultcode>")
CMensajeMensaje=leerXMl(Alltrim(oXMLHttp.responseText),"<faultstring>","</faultstring>")
If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Then
	Messagebox((Alltrim(CmensajeError)+' '+Alltrim(CMensajeMensaje)),16,'Sisven')
	Return 0
Endif

lcXML=oXMLHttp.responseText
If "<statusCode>" $ lcXML
	lnCount = 1
Else
	lnCount = 2
Endif
cresp=""
For lnI = 1 To Occurs('<statusCode>', lcXML)
	cresp = Strextract(lcXML, '<statusCode>', '</statusCode>',lnI)
Next lnI
ArchivoRespuestaSunat =Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
ArchivoRespuestaSunat.LoadXML(oXMLHttp.responseText)			&&Llenamos el archivo de respuesta
*Messagebox(oXMLHttp.responseText,16,'Sisven')
TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//content")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
If Type('oempresa')='U' Then
	cnombre=VerificaArchivoRespuesta(Sys(5)+Sys(2003)+'\SunatXml\'+crespuesta,crespuesta,cticket)
	cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'
Else
	cnombre=VerificaArchivoRespuesta(Sys(5)+Sys(2003)+'\SunatXml\'+Alltrim(oempresa.nruc)+"\"+crespuesta,crespuesta,cticket)
*cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+Alltrim(oempresa.nruc)+"\"+crespuesta
	cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"
Endif
decodefile(TxtB64.Text,cnombre)

oShell = Createobject("Shell.Application")
cfilerpta="R"
For Each oArchi In oShell.NameSpace(cnombre).Items
	If Left(oArchi.Name,1)='R' Then
		oShell.NameSpace(cDirDesti).CopyHere(oArchi)
		cfilerpta=Juststem(oArchi.Name)+'.XML'
	Endif
Endfor
If Type('oempresa')='U' Then
	rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+cfilerpta)
	cfilecdr=Sys(5)+Sys(2003)+'\SunatXML\'+cfilerpta
Else
	rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"+cfilerpta)
	cfilecdr=Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"+cfilerpta
Endif
If !Empty(rptaSunat)
	If Len(Alltrim(rptaSunat))<=100 Then
		mensaje(rptaSunat)
	Else
		Messagebox(Left(rptaSunat,240),'Sysven')
		Return 0
	Endif
Endif
If !Empty(rptaSunat) Then
	If Substr(ctipoarchivo,13,2)='RA' Then
		If ActualizaResumenBajas(cticket,cfilecdr)=0 Then
			Messagebox("NO se Grabo la Respuesta de SUNAT en Base de Datos",16,MSGTITULO)
		Endif
	Else
		If ActualizaResumenBoletas(cticket,cfilecdr)=0 Then
			Messagebox("NO se Grabo la Respuesta de SUNAT en Base de Datos",16,MSGTITULO)
		Endif
	Endif
	If Left(rptaSunat,1)=='0' Then
		Return 1
	Else
		Return 0
	Endif
Else
	Return -1
Endif
Endproc
***********************************
Procedure CrearPdf(np1,np2,np3)
Private oFbc
Obj=Createobject("custom")
Obj.AddProperty("ArchivoXml")
Obj.ArchivoXml=""
Set Procedure To capadatos,foxbarcodeqr Additive
m.oFbc = Createobject("FoxBarcodeQR")
Do "FoxyPreviewer.App"
lcStrings = np2
crutapdf1=Left(Substr(lcStrings, Rat("pdf", lcStrings)),3)
crutapdf2=Left(Substr(lcStrings, Rat("PDF", lcStrings)),3)
Do Case
Case !Empty(crutapdf1) Or !Empty(crutapdf2)
	carch=np2
Case Empty(crutapdf1)
	If Type('oempresa')='U' Then
		carch = Addbs(Sys(5)+Sys(2003)+'\PDF\')+np2
	Else
		carch = Addbs(Sys(5)+Sys(2003)+'\PDF\'+Alltrim(oempresa.nruc)+"\")+np2
	Endif
*	cpdf=Addbs(Sys(5)+Sys(2003)+'\PDF\')+np2
Case Empty(crutapdf2)
	If Type('oempresa')='U' Then
		carch = Addbs(Sys(5)+Sys(2003)+'\PDF\')+np2
	Else
		carch = Addbs(Sys(5)+Sys(2003)+'\PDF\'+Alltrim(oempresa.nruc)+"\")+np2
	Endif
*cpdf=Addbs(Sys(5)+Sys(2003)+'\PDF\')+np2
Endcase
Report Form (np1) Object Type 10 To File (carch)
Do foxypreviewer.App With "Release"
If np3='S' Then
	Set Procedure To capadatos,abrirpdf Additive
	abrirpdf(carch)
Endif
m.oFbc=Null
Release Obj
Endproc
***********************************
Procedure Reimprimir(np1,np2)
If verificaAlias("tmpv")=0 Then
	Create Cursor tmpv(coda N(8),Desc c(120),unid c(6),Prec N(13,8),cant N(10,2),ndoc c(12),alma N(10,2),peso N(10,2),;
		Impo N(10,2),tipro c(1),ptoll c(50),fect d,perc N(5,2),cletras c(120),;
		nruc c(11),razon c(120),direccion c(190),fech d,fechav d,ndo2 c(12),vendedor c(50),Form c(20),;
		referencia c(150),hash c(30),dni c(8),Mone c(1),tdoc1 c(2),dcto c(12),fech1 d,detalle c(120),contacto c(120),archivo c(120),costoref N(12,5))
Else
	Zap In tmpv
Endif
Do Case
Case np2='01' Or np2='03'
	TEXT TO lc noshow
			    SELECT a.codv,a.idauto,a.alma,a.idkar,a.idauto,a.idart,a.cant,ifnull(a.prec,CAST(0 as decimal(12,5))) as prec,a.alma,c.tdoc as tdoc1,
			    c.ndoc as dcto,c.fech as fech1,rcom_arch,a.kar_cost as costo,ifnull(p.fevto,c.fech) as fvto,
			    c.fech,c.fecr,c.form,c.deta,c.exon,c.ndo2,c.igv,a.idclie,d.razo,d.nruc,d.dire,d.ciud,d.ndni,
			    c.pimpo,ifnull(x.dpto_nomb,'') as dpto,d.clie_dist as distrito,
			    c.tdoc,c.ndoc,a.dola,c.mone,b.descri,b.unid,c.rcom_hash,v.nomv,c.impo FROM fe_art as b join fe_kar as a on(b.idart=a.idart)
			    inner join fe_vend as v on v.idven=a.codv  inner JOIN fe_rcom as c on(a.idauto=c.idauto) inner join fe_clie as d on(c.idcliente=d.idclie)
			    left join fe_dpto as x on x.dpto_idpt=d.clie_idpt
			    left join (select idauto,min(c.fevto) as fevto from fe_cred as c where acti='A' group by idauto) as p on p.idauto=c.idauto
			    where c.idauto=?np1 and a.acti='A';
	ENDTEXT
Case np2='08'
	TEXT TO lc noshow
			   SELECT r.idauto,r.ndoc,r.tdoc,r.fech,r.mone,abs(r.valor) as valor,r.ndo2,
		       r.vigv,c.nruc,c.razo,c.dire,c.ciud,c.ndni,' ' as nomv,r.form,ifnull(x.dpto_nomb,'') as dpto,c.clie_dist as distrito,
		       abs(r.igv) as igv,abs(r.impo) as impo,ifnull(k.cant,CAST(0 as decimal(12,2))) as cant,ifnull(kar_cost,CAST(0 as decimal(12,5))) as costo,
		       ifnull(k.prec,ABS(r.impo)) as prec,LEFT(r.ndoc,4) as serie,SUBSTR(r.ndoc,5) as numero,
		       ifnull(a.unid,'') as unid,ifnull(a.descri,r.deta) as descri,r.deta,ifnull(k.idart,CAST(0 as decimal(8))) as idart,f.ndoc as dcto,
		       f.fech as fech1,w.tdoc as tdoc1,rcom_hash,rcom_arch,r.fech as fvto
		       from fe_rcom r inner join fe_clie c on c.idclie=r.idcliente
		       left join fe_kar k on k.idauto=r.idauto left join fe_art a on a.idart=k.idart
		       inner join fe_rven as rv on rv.idauto=r.idauto inner join fe_refe f on f.idrven=rv.idrven inner join fe_tdoc as w on w.idtdoc=f.idtdoc
		       left join fe_dpto as x on x.dpto_idpt=c.clie_idpt
		       where r.idauto=?np1 and r.acti='A' and r.tdoc='08'
	ENDTEXT
Case np2='07'
	TEXT TO lc noshow
			   SELECT r.idauto,r.ndoc,r.tdoc,r.fech,r.mone,abs(r.valor) as valor,r.ndo2,
		       r.vigv,c.nruc,c.razo,c.dire,c.ciud,c.ndni,' ' as nomv,r.form,ifnull(x.dpto_nomb,'') as dpto,c.clie_dist as distrito,
		       abs(r.igv) as igv,abs(r.impo) as impo,ifnull(k.cant,CAST(0 as decimal(12,2))) as cant,ifnull(kar_cost,CAST(0 as decimal(12,5))) as costo,
		       ifnull(k.prec,ABS(r.impo)) as prec,LEFT(r.ndoc,4) as serie,SUBSTR(r.ndoc,5) as numero,
		       ifnull(a.unid,'') as unid,ifnull(a.descri,r.deta) as descri,r.deta,ifnull(k.idart,CAST(0 as decimal(8))) as idart,f.ndoc as dcto,
		       f.fech as fech1,w.tdoc as tdoc1,rcom_hash,rcom_arch,r.fech as fvto
		       from fe_rcom r inner join fe_clie c on c.idclie=r.idcliente
		       left join fe_kar k on k.idauto=r.idauto left join fe_art a on a.idart=k.idart
		       inner join fe_rven as rv on rv.idauto=r.idauto inner join fe_refe f on f.idrven=rv.idrven inner join fe_tdoc as w on w.idtdoc=f.idtdoc
		       left join fe_dpto as x on x.dpto_idpt=c.clie_idpt
		       where r.idauto=?np1 and r.acti='A' and r.tdoc='07'
	ENDTEXT
Endcase
ncon=Abreconexion()
If SQLExec(ncon,lc,'kardex')<0 Then
	errorbd(lc)
	Return
Endif
CierraConexion(ncon)
nimpo=kardex.Impo
cndoc=kardex.ndoc
cmone=kardex.Mone
ctdoc=kardex.tdoc
chash=kardex.rcom_hash
carchivo=Sys(5)+Sys(2003)+'\'+Justfname(kardex.rcom_arch)
dfvto=kardex.fvto
nf=0
Select kardex
Scan All
	nf=nf+1
	cciud=Iif(!Empty(kardex.distrito),"-"+Alltrim(kardex.distrito),"")+"-"+Alltrim(kardex.ciud)+""+Iif(!Empty(kardex.dpto),"-"+kardex.dpto,"")
	Insert Into tmpv(coda,Desc,unid,cant,Prec,ndoc,hash,nruc,razon,direccion,fech,fechav,ndo2,vendedor,Form,referencia,dni,Mone,dcto,tdoc1,fech1,costoref);
		values(kardex.idart,kardex.Descri,kardex.unid,Iif(kardex.cant=0,1,kardex.cant),kardex.Prec,;
		kardex.ndoc,kardex.rcom_hash,kardex.nruc,kardex.razo,Alltrim(kardex.Dire)+' '+Alltrim(cciud),kardex.fech,kardex.fvto,;
		kardex.ndo2,kardex.nomv,;
		Icase(kardex.Form='E','Efectivo',kardex.Form='C','Crédito',kardex.Form='T','Tarjeta',kardex.Form='D','Depósito',kardex.Form='H','Cheque','Factoring'),;
		kardex.Deta,kardex.ndni,kardex.Mone,kardex.dcto,kardex.tdoc1,kardex.fech1,kardex.costo)
Endscan
Local cimporte
cimporte=Diletras(nimpo,cmone)
ni=nf
Private oFbc
Set Procedure To capadatos,foxbarcodeqr Additive
m.oFbc = Createobject("FoxBarcodeQR")
Select tmpv
For x=1 To fe_gene.Items-nf
	ni=ni+1
	Insert Into tmpv(ndoc)Values(cndoc)
Next
Select tmpv
Replace All ndoc With cndoc,cletras With cimporte,Mone With cmone,hash With chash,archivo With carchivo,fechav With dfvto
Go Top In tmpv
Endproc
*******************************
Function  generaCorrelativoEnvioResumenBoletas()
TEXT TO lc noshow
	UPDATE fe_gene  as f SET gene_nres=f.gene_nres+1 WHERE idgene=1
ENDTEXT
ncon=Abreconexion()
If SQLExec(ncon,lc,'up')<0 Then
	errorbd(lc)
	Return 0
Endif
CierraConexion(ncon)
Return 1
Endfunc
*****************************
Function  generaCorrelativoEnvioResumenBajas()
TEXT TO lc noshow
	   UPDATE fe_gene  as f SET gene_nbaj=f.gene_nbaj+1 WHERE idgene=1
ENDTEXT
ncon=Abreconexion()
If SQLExec(ncon,lc,'up')<0 Then
	errorbd(lc)
	Return 0
Endif
CierraConexion(ncon)
Return 1
Endfunc
*********************************
Function RegistraResumenBajas(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10)
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
lc="proIngresaRbajas"
cur=[]
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' '+' Registrando el Informe de Bajas')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************************
Function RegistraResumenBoletas(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15)
cur=[]
lc="proIngresaResumenBoletas"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
goapp.npara11=np11
goapp.npara12=np12
goapp.npara13=np13
goapp.npara14=np14
goapp.npara15=np15
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Registrando Resumen de Boletas')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************
Function ActualizaResumenBoletas(np1,np2)
cur=[]
lc="ProactualizaResumenBoletas"
goapp.npara1=np1
goapp.npara2=np2
crptaSunat=LeerRespuestaSunat(np2)
cdrxml=Filetostr(np2)
If goapp.Grabarxmlbd='S' Then
	TEXT to lp noshow
     (?goapp.npara1,?crptaSunat,?cdrxml)
	ENDTEXT
Else
	TEXT to lp noshow
     (?goapp.npara1,?crptaSunat)
	ENDTEXT
Endif
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Actualizando Respuesta de Sunat')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************
Function ActualizaResumenBajas(np1,np2)
cur=[]
crptaSunat=LeerRespuestaSunat(np2)
lc="ProactualizaRBajas"
goapp.npara1=np1
goapp.npara2=np2
cdrxml=Filetostr(np2)
If goapp.Grabarxmlbd='S' Then
	TEXT to lp noshow
     (?goapp.npara1,?crptaSunat,?cdrxml)
	ENDTEXT
Else
	TEXT to lp noshow
     (?goapp.npara1,?crptaSunat)
	ENDTEXT
Endif
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Actualizando Respuesta de Sunat')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Procedure GuardaPk(np1,np2,np3)

cpropiedad="Grabarxmlbd"
If !Pemstatus(goapp,cpropiedad,5)
	goapp.AddProperty("Grabarxmlbd","")
Endif
carchivo=goapp.carchivo
dfenvio=fe_gene.fech
crptaSunat=LeerRespuestaSunat(np3)
ncon=Abreconexion()
If goapp.Grabarxmlbd='S' Then
	cxml=Filetostr(carchivo)
	cdrxml=Filetostr(np3)
	TEXT  TO lc noshow
       UPDATE fe_rcom SET rcom_hash=?np2,rcom_mens=?crptaSunat,rcom_arch=?carchivo,rcom_fecd=?dfenvio,rcom_xml=?cxml,rcom_cdr=?cdrxml WHERE idauto=?np1
	ENDTEXT
Else
	TEXT  TO lc noshow
       UPDATE fe_rcom SET rcom_hash=?np2,rcom_mens=?crptaSunat,rcom_arch=?carchivo,rcom_fecd=?dfenvio WHERE idauto=?np1
	ENDTEXT
Endif
If SQLExec(ncon,lc)<0 Then
	errorbd(lc)
	Return 0
Endif
CierraConexion(ncon)
Return 1
Endproc
***************************
Procedure GuardaPkXML(np1,np2,np3)


cpropiedad="Grabarxmlbd"
If !Pemstatus(goapp,cpropiedad,5)
	goapp.AddProperty("Grabarxmlbd","")
Endif


ncon=Abreconexion()
carchivo=goapp.carchivo
If goapp.Grabarxmlbd='S' Then
	cxml=Filetostr(carchivo)
	TEXT  TO lc noshow
       UPDATE fe_rcom SET rcom_hash=?np2,rcom_arch=?carchivo,rcom_xml=?cxml WHERE idauto=?np1
	ENDTEXT
Else
	TEXT  TO lc noshow
       UPDATE fe_rcom SET rcom_hash=?np2,rcom_arch=?carchivo WHERE idauto=?np1
	ENDTEXT
Endif
If SQLExec(ncon,lc)<0 Then
	errorbd(lc)
	Return 0
Endif
CierraConexion(ncon)
Return 1
Endproc
***************************
Procedure ReimprimirStandar(np1,np2,np3)
If verificaAlias("tmpv")=0 Then
	Create Cursor tmpv(coda N(8),Desc c(120),unid c(15),Prec N(13,8),cant N(10,2),ndoc c(12),alma N(10,2),peso N(10,2),;
		Impo N(10,2),tipro c(1),ptoll c(50),fect d,perc N(5,2),cletras c(120),tdoc c(2),;
		nruc c(11),razon c(120),direccion c(190),fech d,fechav d,ndo2 c(12),vendedor c(50),Forma c(20),Form c(20),guia c(15),duni c(15),;
		referencia c(120),hash c(30),dni c(8),Mone c(1),tdoc1 c(2),dcto c(12),fech1 d,usuario c(30),tigv N(5,3),detalle c(120),contacto c(120),archivo c(120))
Else
	Zap In tmpv
Endif

Do Case
Case np2='01' Or np2='03'
	cx=""
	If  Vartype(np3)='C' Then
		cx=np3
	Endif
	If cx='S' Then
		TEXT TO lc NOSHOW
			  	SELECT 4 as codv,c.idauto,1 as idart,ifnull(a.cant,1) as cant,ifnull(a.prec,0) as prec,c.codt as alma,
          		c.tdoc as tdoc1,
			    c.ndoc as dcto,c.fech as fech1,c.vigv,
			    c.fech,c.fecr,c.form,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,
          		c.pimpo,u.nomb as usuario,c.deta,
			    c.tdoc,c.ndoc,c.dolar as dola,c.mone,"" as descri,'' as Unid,
          		c.rcom_hash,'Oficina' as nomv,c.impo
          		FROM fe_rcom as c left join fe_kar as a on(a.idauto=c.idauto)
			    inner join fe_clie as d on(d.idclie=c.idcliente)
			    inner join fe_usua as u on u.idusua=c.idusua where c.idauto=?np1
			    union all
			  	SELECT 4 as codv,c.idauto,0 as idart,1 as cant,impo as prec,c.codt as alma,
          		c.tdoc as tdoc1,
			    c.ndoc as dcto,c.fech as fech1,c.vigv,
			    c.fech,c.fecr,c.form,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,
          		c.pimpo,u.nomb as usuario,c.deta,
			    c.tdoc,c.ndoc,c.dolar as dola,c.mone,m.detv_desc as descri,'' as Unid,
          		c.rcom_hash,'Oficina' as nomv,c.impo
          		FROM fe_rcom as c inner join fe_clie as d on(d.idclie=c.idcliente)
			    inner join fe_usua as u on u.idusua=c.idusua   inner join fe_detallevta as m on m.detv_idau=c.idauto
          		where c.idauto=?np1
		ENDTEXT
****

		TEXT TO lc NOSHOW
			  	SELECT 4 as codv,c.idauto,0 as idart,
                CAST(ifnull(m.detv_cant,1)  as decimal(12,2))as cant,CAST(ifnull(m.detv_prec,c.impo) as decimal(12,4)) as prec,c.codt as alma,
          		c.tdoc as tdoc1,
			    c.ndoc as dcto,c.fech as fech1,c.vigv,
			    c.fech,c.fecr,c.form,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,
          		c.pimpo,u.nomb as usuario,c.deta,
			    c.tdoc,c.ndoc,c.dolar as dola,c.mone,m.detv_desc as descri,'' as Unid,
          		c.rcom_hash,'Oficina' as nomv,c.impo
          		FROM fe_rcom as c inner join fe_clie as d on(d.idclie=c.idcliente)
			    inner join fe_usua as u on u.idusua=c.idusua   inner join fe_detallevta as m on m.detv_idau=c.idauto
          		where c.idauto=?np1 group by descri order by detv_ite1



		ENDTEXT
*	SELECT 4 as codv,c.idauto,0 as idart,CAST(1  as decimal(12,2)) as cant,if(detv_item=1,impo,0) as prec,c.codt as alma,
*	c.tdoc as tdoc1,
*  c.ndoc as dcto,c.fech as fech1,c.vigv,
*  c.fech,c.fecr,c.form,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,
*	c.pimpo,u.nomb as usuario,c.deta,
*  c.tdoc,c.ndoc,c.dolar as dola,c.mone,m.detv_desc as descri,'' as Unid,
*	c.rcom_hash,'Oficina' as nomv,c.impo
*FROM fe_rcom as c inner join fe_clie as d on(d.idclie=c.idcliente)
*  inner join fe_usua as u on u.idusua=c.idusua   inner join fe_detallevta as m on m.detv_idau=c.idauto
*where c.idauto=?np1 group by descri order by detv_ite1
	Else
		TEXT TO lc noshow
			    SELECT a.codv,a.idauto,a.alma,a.idkar,a.idauto,a.idart,a.cant,a.prec,a.alma,c.tdoc as tdoc1,
			    c.ndoc as dcto,c.fech as fech1,c.vigv,
			    c.fech,c.fecr,c.form,c.deta,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,c.pimpo,u.nomb as usuario,
			    c.tdoc,c.ndoc,c.dolar as dola,c.mone,b.descri,b.unid,c.rcom_hash,v.nomv,c.impo FROM fe_art as b join fe_kar as a on(b.idart=a.idart)
			    inner join fe_vend as v on v.idven=a.codv  inner JOIN fe_rcom as c on(a.idauto=c.idauto) inner join fe_clie as d on(c.idcliente=d.idclie)
			    inner join fe_usua as u on u.idusua=c.idusua
			    where c.idauto=?np1 and a.acti='A';
		ENDTEXT
	Endif
Case np2='08'
	TEXT TO lc noshow
			   SELECT r.idauto,r.ndoc,r.tdoc,r.fech,r.mone,abs(r.valor) as valor,r.ndo2,
		       r.vigv,c.nruc,c.razo,c.dire,c.ciud,c.ndni,' ' as nomv,r.form,
		       abs(r.igv) as igv,abs(r.impo) as impo,ifnull(k.cant,CAST(0 as decimal(12,2))) as cant,
		       ifnull(k.prec,ABS(r.impo)) as prec,LEFT(r.ndoc,4) as serie,SUBSTR(r.ndoc,5) as numero,
		       ifnull(a.unid,'') as unid,ifnull(a.descri,r.deta) as descri,r.deta,ifnull(k.idart,CAST(0 as decimal(8))) as idart,w.ndoc as dcto,
		       w.fech as fech1,w.tdoc as tdoc1,r.rcom_hash,u.nomb as usuario
		       from fe_rcom r inner join fe_clie c on c.idclie=r.idcliente
		       left join fe_kar k on k.idauto=r.idauto left join fe_art a on a.idart=k.idart
		       inner join fe_ncven f on f.ncre_idan=r.idauto inner join fe_rcom as w on w.idauto=f.ncre_idau
		        inner join fe_usua as u on u.idusua=r.idusua
		       where r.idauto=?np1 and r.acti='A' and r.tdoc='08'
	ENDTEXT
Case np2='07'
	TEXT TO lc noshow
			   SELECT r.idauto,r.ndoc,r.tdoc,r.fech,r.mone,abs(r.valor) as valor,r.ndo2,
		       r.vigv,c.nruc,c.razo,c.dire,c.ciud,c.ndni,' ' as nomv,r.form,u.nomb as usuario,
		       abs(r.igv) as igv,abs(r.impo) as impo,ifnull(k.cant,CAST(0 as decimal(12,2))) as cant,
		       ifnull(k.prec,ABS(r.impo)) as prec,LEFT(r.ndoc,4) as serie,SUBSTR(r.ndoc,5) as numero,
		       ifnull(a.unid,'') as unid,ifnull(a.descri,r.deta) as descri,r.deta,ifnull(k.idart,CAST(0 as decimal(8))) as idart,w.ndoc as dcto,
		       w.fech as fech1,w.tdoc as tdoc1,r.rcom_hash
		       from fe_rcom r inner join fe_clie c on c.idclie=r.idcliente
		       left join fe_kar k on k.idauto=r.idauto left join fe_art a on a.idart=k.idart
		       inner join fe_ncven f on f.ncre_idan=r.idauto inner join fe_rcom as w on w.idauto=f.ncre_idau
		        inner join fe_usua as u on u.idusua=r.idusua
		       where r.idauto=?np1 and r.acti='A' and r.tdoc='07'
	ENDTEXT
Endcase
ncon=Abreconexion()
If SQLExec(ncon,lc,'kardex')<0 Then
	errorbd(lc)
	Return
Endif
CierraConexion(ncon)
nimpo=kardex.Impo
cndoc=kardex.ndoc
cmone=kardex.Mone
ctdoc=kardex.tdoc
chash=kardex.rcom_hash
cdeta1=kardex.Deta
vvigv=kardex.vigv
nf=0
Select kardex
Scan All
	nf=nf+1
	Insert Into tmpv(coda,Desc,unid,cant,Prec,ndoc,hash,nruc,razon,direccion,fech,fechav,ndo2,vendedor,Form,;
		referencia,dni,Mone,dcto,tdoc1,fech1,usuario,guia,Forma,tigv,tdoc);
		values(Iif(Vartype(kardex.idart)='N',kardex.idart,Val(kardex.idart)),kardex.Descri,kardex.unid,Iif(kardex.cant=0,1,kardex.cant),kardex.Prec,;
		kardex.ndoc,kardex.rcom_hash,kardex.nruc,kardex.razo,Alltrim(kardex.Dire)+' '+Alltrim(kardex.ciud),kardex.fech,kardex.fech,;
		kardex.ndo2,kardex.nomv,Icase(kardex.Form='E','Efectivo',kardex.Form='C','Crédito',kardex.Form='T','Tarjeta',kardex.Form='D','Depósito','Cheque'),;
		kardex.Deta,kardex.ndni,kardex.Mone,kardex.dcto,kardex.tdoc1,kardex.fech1,kardex.usuario,kardex.ndo2,;
		Icase(kardex.Form='E','Efectivo',kardex.Form='C','Crédito',kardex.Form='T','Tarjeta',kardex.Form='D','Depósito','Cheque'),kardex.vigv,ctdoc)
Endscan
Local cimporte
cimporte=Diletras(nimpo,cmone)
ni=nf
Select tmpv
For x=1 To fe_gene.Items-nf
	ni=ni+1
	Insert Into tmpv(ndoc)Values(cndoc)
Next
Select tmpv
Replace All ndoc With cndoc,cletras With cimporte,Mone With cmone,hash With chash,referencia With cdeta1,tigv With vvigv
Go Top In tmpv
Endproc
********************************
Function GeneraPLE5Contingencia(np1,np2)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select * From cont1;
	Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
        \\<<motivo>>|<<tipoop>>|<<fech>>|<<tdoc>>|<<serie>>|<<numero>>|<<ctik>>|<<tipodocc>>|<<nruc>>|<<ALLTRIM(razo)>>|<<mone>>|<<valor>>|<<exon>>|<<inafecto>>|<<expo>>|<<isc>>|<<igv>>|<<otros>>|<<impo>>|<<tref>>|<<serierefe>>|<<numerorefe>>|<<Regper>>|<<Bper>>|<<Mper>>|<<Tper>>|
	Else
         \<<motivo>>|<<tipoop>>|<<fech>>|<<tdoc>>|<<serie>>|<<numero>>|<<ctik>>|<<tipodocc>>|<<nruc>>|<<ALLTRIM(razo)>>|<<mone>>|<<valor>>|<<exon>>|<<inafecto>>|<<expo>>|<<isc>>|<<igv>>|<<otros>>|<<impo>>|<<tref>>|<<serierefe>>|<<numerorefe>>|<<Regper>>|<<Bper>>|<<Mper>>|<<Tper>>|
	Endif
	nl=nl+1
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
tcRuta = Iif(Not Empty(tcRuta) And Directory(tcRuta,1),tcRuta,"")
tcExtension = Iif(Empty(tcExtension), "", tcExtension)
tcLeyenda = Iif(Empty(tcLeyenda), "", tcLeyenda)
tcBoton = Iif(Empty(tcBoton), "", tcBoton)
tnBoton = Iif(Empty(tnBoton), 0, tnBoton)
tcTitulo = Iif(Empty(tcTitulo), "", tcTitulo)
lcDirAnt = Fullpath("")
Set Default To (tcRuta)
lcGetPict = Getfile(tcExtension, tcLeyenda, tcBoton, tnBoton, tcTitulo)
Set Default To (lcDirAnt)
Return lcGetPict
Endfunc

********************************************************************************
Function GetPictX(tcRuta, tcExtension, tcLeyenda, tcBoton)
Local lcDirAnt, lcGetPict
tcRuta = Iif(Not Empty(tcRuta) And Directory(tcRuta,1),tcRuta,"")
tcExtension = Iif(Empty(tcExtension), "", tcExtension)
tcLeyenda = Iif(Empty(tcLeyenda), "", tcLeyenda)
tcBoton = Iif(Empty(tcBoton), "", tcBoton)
lcDirAnt = Fullpath("")
Set Default To (tcRuta)
lcGetPict = Getpict(tcExtension, tcLeyenda, tcBoton)
Set Default To (lcDirAnt)
Return lcGetPict
Endfunc
*****************************
Procedure mensaje
Lparameters lcMess
If Type("lcMess") = "L"
	Return .F.
Endif
Wait Window lcMess At Srows()/2,(Scols()/2 - (Len(lcMess)/2)) Timeout 1
Endproc
************************************
Function MuestraTabla34(np1,np2,cur)
lc="ProMuestratabla34"
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Mostrando Tabla 34')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************************
Function GrabaTabla34PlanCuentas(np1,np2)
lc="ProGrabatabla34PlanCuentas"
cur=""
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Actualizando Plan de Cuentas con  Tabla 34')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************************
Function GeneraCta10Ple5(np1,np2,nmes,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select;
	Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'00' As Integer) As periodo,;
	ncta,;
	banc_idco,;
	ctas_ctas,;
	ctas_mone,;
	deudor,;
	acreedor,;
	1 As estado;
	From cta10 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<ncta>>|<<banc_idco>>|<<TRIM(ctas_ctas)>>|<<ctas_mone>>|<<deudor>>|<<acreedor>>|<<estado>>|
	Else
		  \<<periodo>>|<<ncta>>|<<banc_idco>>|<<TRIM(ctas_ctas)>>|<<ctas_mone>>|<<deudor>>|<<acreedor>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCta12Ple5(np1,np2,nmes,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select;
	Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'00' As Integer) As periodo,;
	idauto,;
	Trim('M'+Alltrim(Str(ncontrol))) As  ncontrol,;
	tipodcto,;
	ndcto,;
	razo,;
	fech,;
	saldo,;
	1 As estado;
	From cta12 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<idauto>>|<<ALLTRIM(ncontrol)>>|<<tipodcto>>|<<ndcto>>|<<razo>>|<<fech>>|<<saldo>>|<<estado>>|
	Else
		  \<<periodo>>|<<idauto>>|<<ALLTRIM(ncontrol)>>|<<tipodcto>>|<<ndcto>>|<<razo>>|<<fech>>|<<saldo>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCtaIBPle5(np1,np2,nmes,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select;
	Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'00' As Integer) As periodo,;
	tabla22,;
	idcta34,;
	saldo,;
	1 As estado;
	From rld Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<tabla22>>|<<idcta34>>|<<saldo>>|<<estado>>|
	Else
		   \<<periodo>>|<<tabla22>>|<<idcta34>>|<<saldo>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCta19Ple5(np1,np2,nmes,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select;
	Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'00' As Integer) As periodo,;
	idauto,;
	ncontrol,;
	tipodcto,;
	ndcto,;
	razo,;
	tdoc,;
	serie,;
	fech,;
	dcto,;
	saldo,;
	1 As estado;
	From cta19 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<idauto>>|<<ALLTRIM(ncontrol)>>|<<tipodcto>>|<<ndcto>>|<<razo>>|<<tdoc>>|<<serie>>|<<dcto>>|<<fech>>|<<saldo>>|<<estado>>|
	Else
		   \<<periodo>>|<<idauto>>|<<ALLTRIM(ncontrol)>>|<<tipodcto>>|<<ndcto>>|<<razo>>|<<tdoc>>|<<serie>>|<<dcto>>|<<fech>>|<<saldo>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCta20Ple5(np1,np2,nmes,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select;
	Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'00' As Integer) As periodo,;
	codic,;
	tipo,;
	idart,;
	codosce,;
	descr,;
	unid,;
	metodo,;
	stock,;
	costo,;
	importe,;
	1 As estado;
	From cta12 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<idauto>>|<<codic>>|<<tipo>>|<<idart>>|<<codosce>>|<<descr>>|<<unid>>|<<metodo>>|<<stock>>|<<costo>>|<<importe>>|<<estado>>|
	Else
		   \<<periodo>>|<<idauto>>|<<codic>>|<<tipo>>|<<idart>>|<<codosce>>|<<descr>>|<<unid>>|<<metodo>>|<<stock>>|<<costo>>|<<importe>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCta34Ple5(np1,np2,nmes,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select;
	Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'00' As Integer) As periodo,;
	RECNO() As idauto,;
	TRIM('M'+Alltrim(Str(Recno()))) As ncontrol,;
	fech,;
	ncta,;
	deta,;
	valor,;
	amor,;
	1 As estado;
	From cta34 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<idauto>>|<<ALLTRIM(ncontrol)>>|<<fech>>|<<ncta>>|<<deta>>|<<valor>>|<<amor>>|<<estado>>|
	Else
		  \<<periodo>>|<<idauto>>|<<ALLTRIM(ncontrol)>>|<<fech>>|<<ncta>>|<<deta>>|<<valor>>|<<amor>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCta37Ple5(np1,np2,nmes,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select;
	Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'00' As Integer) As periodo,;
	RECNO() As idauto,;
	TRIM('M'+Alltrim(Str(Recno()))) As ncontrol,;
	tdoc,;
	serie,;
	ndoc,;
	ncta,;
	Deta,;
	saldo,;
	adicional,;
	deduccion,;
	1 As estado;
	From cta37 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<idauto>>|<<ALLTRIM(ncontrol)>>|<<tdoc>>|<<serie>>|<<ndoc>>|<<ncta>>|<<deta>>|<<saldo>>|<<adicional>>|<<deduccion>>|<<estado>>|
	Else
		  \<<periodo>>|<<idauto>>|<<ALLTRIM(ncontrol)>>|<<tdoc>>|<<serie>>|<<ndoc>>|<<ncta>>|<<deta>>|<<saldo>>|<<adicional>>|<<deduccion>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCta41Ple5(np1,np2,nmes,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select;
	Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'00' As Integer) As periodo,;
	codigo  As idauto,;
	TRIM('M'+Alltrim(Str(codigo))) As ncontrol,;
	'41.11.00' As ncta,;
	tipo,;
	ndni,;
	codigo,;
	nombre,;
	saldo,;
	1 As estado;
	From cta41 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
		    \\<<periodo>>|<<idauto>>|<<ALLTRIM(ncontrol)>>|<<ncta>>|<<tipo>>|<<ndni>>|<<codigo>>|<<nombre>>|<<saldo>>|<<estado>>|
	Else
			 \<<periodo>>|<<idauto>>|<<ALLTRIM(ncontrol)>>|<<ncta>>|<<tipo>>|<<ndni>>|<<codigo>>|<<nombre>>|<<saldo>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCta42Ple5(np1,np2,nmes,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select;
	Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'00' As Integer) As periodo,;
	idauto,;
	ncontrol,;
	tipodcto,;
	ndcto,;
	razo,;
	fech,;
	saldo,;
	1 As estado;
	From cta42 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<idauto>>|<<ALLTRIM(ncontrol)>>|<<tipodcto>>|<<ndcto>>|<<razo>>|<<fech>>|<<saldo>>|<<estado>>|
	Else
		  \<<periodo>>|<<idauto>>|<<ALLTRIM(ncontrol)>>|<<tipodcto>>|<<ndcto>>|<<razo>>|<<fech>>|<<saldo>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCta46Ple5(np1,np2,nmes,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select;
	Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'00' As Integer) As periodo,;
	idauto,;
	ncontrol,;
	tipodcto,;
	ndcto,;
	fech,;
	razo,;
	Left(ncta,2)+Substr(ncta,4,2)+Substr(ncta,7,2) As ncta,;
	saldo,;
	1 As estado;
	From cta46 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<idauto>>|<<ALLTRIM(ncontrol)>>|<<tipodcto>>|<<ndcto>>|<<fech>>|<<ncta>>|<<razo>>|<<saldo>>|<<estado>>|
	Else
		   \<<periodo>>|<<idauto>>|<<ALLTRIM(ncontrol)>>|<<tipodcto>>|<<ndcto>>|<<fech>>|<<ncta>>|<<razo>>|<<saldo>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCta50Ple5(np1,np2,nmes,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select;
	Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'00' As Integer) As periodo,;
	importe,;
	valor,;
	accs,;
	accp,;
	1 As estado;
	From cta50 Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<importe>>|<<valor>>|<<accs>>|<<accp>>|<<estado>>|
	Else
		   \<<periodo>>|<<importe>>|<<valor>>|<<accs>>|<<accp>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraCtaBalancePle5(np1,np2,nmes,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select;
	Cast(Alltrim(Str(na))+Iif(nmes<=9,'0'+Alltrim(Str(nmes)),Alltrim(Str(nmes)))+'00' As Integer) As periodo,;
	ncta,;
	adeudor,;
	aacreedor,;
	debe,;
	haber,;
	deudor,;
	acreedor,;
	deudor As saldofd,;
	acreedor As saldofh,;
	debet,;
	habert,;
	activo,;
	pasivo,;
	rpnperdida,;
	rpnganancia,;
	0 As adicionales,;
	0 As deducciones,;
	1 As estado;
	From rldbalance  Where estilo='S' Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<ncta>>|<<adeudor>>|<<aacreedor>>|<<debe>>|<<haber>>|<<deudor>>|<<acreedor>>|<<saldofd>>|<<saldofh>>|<<debet>>|<<habert>><<activo>>|<<pasivo>>|<<rpnperdida>>|<<rpnganancia>>|<<adicionales>>|<<deducciones>>|<<estado>>|
	Else
		   \<<periodo>>|<<ncta>>|<<adeudor>>|<<aacreedor>>|<<debe>>|<<haber>>|<<deudor>>|<<acreedor>>|<<saldofd>>|<<saldofh>>|<<debet>>|<<habert>><<activo>>|<<pasivo>>|<<rpnperdida>>|<<rpnganancia>>|<<adicionales>>|<<deducciones>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GrabaDetalleCta37(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10)
cur=[]
lc="ProIngresaDcta37"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Registrando Detalle de Cta.37')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function GrabaDetalleCta12(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10)
cur=[]
lc="ProIngresaDcta12"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Registrando Detalle de Cta.12')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function AnulaDetalleCta12(np1)
cur=[]
lc="ProAnulaDcta12"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Anulando Detalle de Cta.12')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function AnulaDetalleCta37(np1)
cur=[]
lc="ProAnulaDcta37"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Anulando Detalle de Cta.37')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************
Function GrabaDetalleCta34(np1,np2,np3,np4,np5,np6)
cur=[]
lc="ProIngresaDcta34"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Registrando Detalle de Cta.34')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************
Function AnulaDetalleCta34(np1)
cur=[]
lc="ProAnulaDcta34"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Anulando Detalle de Cta.34')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************
Procedure CrearQR(np1,np2)
Set Procedure To foxbarcodeqr Additive
loFbc = Createobject("FoxBarcodeQR")
lcQRImage = loFbc.QRBarcodeImage(np1,np2,6,2)
Endproc
**************************
Function GrabaDetalleCta41(np1,np2,np3,np4,np5)
cur=[]
lc="ProIngresaDcta41"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Registrando Detalle de Cta.41')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function AnulaDetalleCta41(np1)
cur=[]
lc="ProAnulaDcta41"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Anulando Detalle de Cta.41')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************
**************************
Function GrabaDetalleCta42(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10)
cur=[]
lc="ProIngresaDcta42"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Registrando Detalle de Cta.42')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function AnulaDetalleCta42(np1)
cur=[]
lc="ProAnulaDcta42"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Anulando Detalle de Cta.42')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************
Function GrabaDetalleCta46(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10)
cur=[]
lc="ProIngresaDcta46"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Registrando Detalle de Cta.46')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function GrabaDetalleCta50(np1,np2,np3,np4,np5,np6)
cur=[]
lc="ProIngresaDcta50"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Registrando Detalle de Cta.50')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function AnulaDetalleCta46(np1)
cur=[]
lc="ProAnulaDcta46"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Anulando Detalle de Cta.46')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function AnulaDetalleCta50(np1)
cur=[]
lc="ProAnulaDcta50"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Anulando Detalle de Cta.50')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function GrabaDetalleCta19(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11)
cur=[]
lc="ProIngresaDcta19"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
goapp.npara11=np11
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Registrando Detalle de Cta.19')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function AnulaDetalleCta19(np1)
cur=[]
lc="ProAnulaDcta19"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Anulando Detalle de Cta.19')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function GrabaBalanceComprobacion(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19)
cur=[]
lc="ProIngresaBalanceComprobacion"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
goapp.npara11=np11
goapp.npara12=np12
goapp.npara13=np13
goapp.npara14=np14
goapp.npara15=np15
goapp.npara16=np16
goapp.npara17=np17
goapp.npara18=np18
goapp.npara19=np19
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,
     ?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Registrando Balance de Comprobación')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function AnulaBalanceComprobacion(np1)
cur=[]
lc="ProAnulaBalanceComprobacion"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Anulando Balance de Comprobación')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function Mayoriza(dfinicio,dff)
If Vartype(dfinicio)<>'D' Then
	dfi=Ctod(dfinicio)
Else
	dfi=dfinicio
Endif
df=dfi-1
TEXT to lc noshow
       select z.ncta,z.nomb,if(z.debe>z.haber,z.debe-z.haber,0) as adeudor,
	   if(z.haber>z.debe,z.haber-z.debe,0) as aacreedor,idcta  from
	   (select b.ncta,b.nomb,SUM(a.ldia_debe-a.ldia_itrd) as debe,
	   SUM(a.ldia_haber-a.ldia_itrh) as haber,b.idcta,MAX(a.ldia_nume) as ldia_nume
	   from fe_ldiario as a inner join fe_plan as b on b.idcta=a.ldia_idcta
	   where a.ldia_acti='A' and ldia_fech<=?df and ldia_tran<>'T' group by a.ldia_idcta) as z
ENDTEXT
ncon=Abreconexion()
If SQLExec(ncon,lc,'mayora')<0 Then
	errorbd(lc)
	Return
Endif
CierraConexion(ncon)
Create Cursor mayor(ncta c(15),nomb c(60),adeudor N(12,2),aacreedor N(12,2),debe N(12,2),haber N(12,2),idcta N(10))
Select * From mayora Where (adeudor+aacreedor)>0 Into Cursor rlmayora
Select mayor
Append From Dbf("rlmayora")
TEXT to lc noshow
       select z.ncta,z.nomb,z.debe,z.haber,idcta  from
	   (select b.ncta,b.nomb,SUM(a.ldia_debe-a.ldia_itrd) as debe,
	   SUM(a.ldia_haber-a.ldia_itrh) as haber,b.idcta
	   from fe_ldiario as a inner join fe_plan as b on b.idcta=a.ldia_idcta
	   where a.ldia_acti='A' and ldia_fech between ?dfi and ?dff and ldia_tran<>'T' group by a.ldia_idcta) as z
ENDTEXT
ncon=Abreconexion()
If SQLExec(ncon,lc,'rlmayor')<0 Then
	errorbd(lc)
	Return
Endif
CierraConexion(ncon)
Select rlmayor
Do While !Eof()
	Select mayor
	Locate For idcta=rlmayor.idcta
	If Found()
		Replace debe With rlmayor.debe,haber With rlmayor.haber In mayor
	Else
		Insert Into mayor(ncta,nomb,debe,haber,idcta)Values(rlmayor.ncta,rlmayor.nomb,rlmayor.debe,rlmayor.haber,rlmayor.idcta)
	Endif
	Select rlmayor
	Skip
Enddo
Select z.ncta,z.nomb,z.adeudor,z.aacreedor,z.debe,z.haber,;
	Iif((z.debe+z.adeudor)>(z.haber+z.aacreedor),(z.debe+z.adeudor)-(z.haber+z.aacreedor),000000000.00) As deudor,;
	iif((z.haber+z.aacreedor)>(z.debe+z.adeudor),(z.haber+z.aacreedor)-(z.debe+z.adeudor),000000000.00) As acreedor,idcta From mayor As z Into Cursor mayor Order By z.ncta
Select * From mayor Into Cursor xdctas
Return
Endfunc
***************************************************
Procedure GeneraBalanceComprobacionPLE5(np1,np2,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select ctasunat As nctas,Round(Sum(adeudor),0) As adeudor,Round(Sum(aacreedor),0) As aacreedor,Round(Sum(debe),0) As debe,Round(Sum(haber),0) As haber,Round(debet,0) As debet,;
	ROUND(habert,0) As habert,0 As rpnperdida,0 As rpnganancia;
	From rld Where !Empty(ctasunat) And Left(ctasunat,1)<>'9' And  Left(ctasunat,2)<>'79' Into Cursor lreg Group By ctasunat
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If Left(nctas,1)='6' Or Left(nctas,1)='7'
		sid=""
		sih=""
	Else
		sid=Alltrim(Str(adeudor))
		sih=Alltrim(Str(aacreedor))
	Endif
	If nl=0 Then

          \\<<nctas>>|<<sid>>|<<sih>>|<<debe>>|<<haber>>|<<debet>>|<<habert>>|<<rpnperdida>>|<<rpnganancia>>|
	Else
           \<<nctas>>|<<sid>>|<<sih>>|<<debe>>|<<haber>>|<<debet>>|<<habert>>|<<rpnperdida>>|<<rpnganancia>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endproc
****************************************************
Procedure ConsultarCPE
Lparameters LcRucEmisor,lcUser_Sol,lcPswd_Sol,ctipodcto,cserie,cnumero

Declare Integer CryptBinaryToString In Crypt32;
	STRING @pbBinary, Long cbBinary, Long dwFlags,;
	STRING @pszString, Long @pcchString

Declare Integer CryptStringToBinary In crypt32;
	STRING @pszString, Long cchString, Long dwFlags,;
	STRING @pbBinary, Long @pcbBinary,;
	LONG pdwSkip, Long pdwFlags

#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056
cpropiedad="ose"
If !Pemstatus(goapp,cpropiedad,5)
	goapp.AddProperty("ose","")
Endif
loXmlHttp = Createobject("MSXML2.ServerXMLHTTP.6.0")
loXMLBody = Createobject("MSXML2.DOMDocument.6.0")
crespuesta=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)+'-'+ctipodcto+'-'+cserie+'-'+cnumero+'.zip'
If !Empty(goapp.ose) Then
	Do Case
	Case goapp.ose="nubefact"
		Do Case
		Case goapp.tipoh=='B'
			lsURL   = "https://demo-ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor=fe_gene.nruc
			ls_pwd_sol = 'moddatos'
			ls_user = ls_ruc_emisor + 'MODDATOS'
		Case goapp.tipoh='P'
			lsURL  =  "https://ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
			ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
			ls_user = ls_ruc_emisor + Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
		Endcase
		TEXT TO lcEnvioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
		ENDTEXT
		If Not loXMLBody.LoadXML( lcEnvioXML )
			Error loXMLBody.parseError.reason
			Return -1
		Endif
		loXmlHttp.Open( "POST", lsURL, .F. )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
		loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
		loXmlHttp.setRequestHeader( "SOAPAction" , "getStatusCdr" )
		loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
		loXmlHttp.Send(loXMLBody.documentElement.XML)
		If loXmlHttp.Status # 200 Then
			cerror=Nvl(loXmlHttp.responseText,'')
			crpta=Strextract(cerror, '<faultstring>', '</faultstring>',1)
			CMensaje1=Strextract(cerror, "<message>","</message>",1)
			Messagebox(crpta+' '+Alltrim(CMensaje1),16,MSGTITULO)
			Return -1
		Endif
		loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
		loXMLResp.LoadXML(loXmlHttp.responseText)
		CmensajeError=leerXMl(Alltrim(loXmlHttp.responseText),"<faultcode>","</faultcode>")
		CMensajeMensaje=leerXMl(Alltrim(loXmlHttp.responseText),"<faultstring>","</faultstring>")
		CMensajedetalle=leerXMl(Alltrim(loXmlHttp.responseText),"<detail>","</detail>")
		Cnumeromensaje=leerXMl(Alltrim(loXmlHttp.responseText),"<statusCode>","</statusCode>")
		CMensaje1=leerXMl(Alltrim(loXmlHttp.responseText),"<message>","</message>")
		If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Or Cnumeromensaje<>'0' Then
			Messagebox((Alltrim(CmensajeError)+' '+Alltrim(CMensajeMensaje)+' '+Alltrim(CMensajedetalle)+' '+Alltrim(CMensaje1)),16,'Sisven')
			Return 0
		Endif
		ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
		ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
		TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//content")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
		If Type('oempresa')='U' Then
			cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+crespuesta
			cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'
		Else
			cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+Alltrim(oempresa.nruc)+"\"+crespuesta
			cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"
		Endif
		decodefile(TxtB64.Text,cnombre)
		oShell = Createobject("Shell.Application")
		cfilerpta="R"
		For Each oArchi In oShell.NameSpace(cnombre).Items
			If Left(oArchi.Name,1)='R' Then
				oShell.NameSpace(cDirDesti).CopyHere(oArchi)
				cfilerpta=Juststem(oArchi.Name)+'.XML'
			Endif
		Endfor
		If Type('oempresa')='U' Then
			rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+cfilerpta)
		Else
			rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"+cfilerpta)
		Endif
		If Len(Alltrim(rptaSunat))>100 Then
			Messagebox(rptaSunat,64,'Sisven')
			Return 0
		Endif
		Do Case
		Case Left(rptaSunat,1)='0'
			mensaje(rptaSunat)
			Return 1
		Case Empty(rptaSunat)
			Messagebox(rptaSunat,64,'Sisven')
			Return 0
		Otherwise
			Messagebox(rptaSunat,64,'Sisven')
			Return 0
		Endcase
	Case goapp.ose="bizlinks"
		loXmlHttp = Createobject("MSXML2.XMLHTTP.6.0")
		loXMLBody = Createobject("MSXML2.DOMDocument.6.0")
		Do Case
		Case goapp.tipoh=='B'
			lsURL   = "https://osetesting.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=fe_gene.nruc
			ls_pwd_sol = 'TESTBIZLINKS'
			ls_user = Alltrim(fe_gene.nruc)+'BIZLINKS'
		Case goapp.tipoh='P'
			lsURL  =  "https://ose.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
			ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
			ls_user = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
		Endcase
		cnum=Right("00000000"+Alltrim(cnumero),8)
		TEXT TO lcEnvioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
		ENDTEXT
		If Not loXMLBody.LoadXML( lcEnvioXML )
			Error loXMLBody.parseError.reason
			Return -1
		Endif

		loXmlHttp.Open( "POST", lsURL, .F. )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
		loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
		loXmlHttp.setRequestHeader( "SOAPAction" , "urn:getStatusCdr" )
*loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
		loXmlHttp.Send(loXMLBody.documentElement.XML)
		If loXmlHttp.Status # 200 Then
			cerror=Nvl(loXmlHttp.responseText,'')
			crpta=Strextract(cerror, '<faultstring>', '</faultstring>',1)
			CMensaje1=Strextract(cerror, "<detail>","</detail>",1)
			Messagebox(crpta+' '+Alltrim(CMensaje1),16,MSGTITULO)
			Return -1
		Endif
		loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
		loXMLResp.LoadXML(loXmlHttp.responseText)
		CmensajeError=leerXMl(Alltrim(loXmlHttp.responseText),"<faultcode>","</faultcode>")
		CMensajeMensaje=leerXMl(Alltrim(loXmlHttp.responseText),"<faultstring>","</faultstring>")
		CMensajedetalle=leerXMl(Alltrim(loXmlHttp.responseText),"<detail>","</detail>")
		Cnumeromensaje=leerXMl(Alltrim(loXmlHttp.responseText),"<statusCode>","</statusCode>")
		CMensaje1=leerXMl(Alltrim(loXmlHttp.responseText),"<statusMessage>","</statusMessage>")
		If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Then
			Messagebox((Alltrim(CmensajeError)+' '+Alltrim(CMensajeMensaje)+' '+Alltrim(CMensajedetalle)+' '+Alltrim(CMensaje1)),16,'Sisven')
			Return 0
		Endif
		ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
		ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
		TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//document")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
		If Type('oempresa')='U' Then
			cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+crespuesta
			cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'
		Else
			cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+Alltrim(oempresa.nruc)+"\"+crespuesta
			cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"
		Endif
		decodefile(TxtB64.Text,cnombre)
		oShell = Createobject("Shell.Application")
		cfilerpta="R"
		For Each oArchi In oShell.NameSpace(cnombre).Items
			If Left(oArchi.Name,1)='R' Then
				oShell.NameSpace(cDirDesti).CopyHere(oArchi)
				cfilerpta=Juststem(oArchi.Name)+'.XML'
			Endif
		Endfor
		If Type('oempresa')='U' Then
			rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+cfilerpta)
		Else
			rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"+cfilerpta)
		Endif
		If Len(Alltrim(rptaSunat))>100 Then
			Messagebox(rptaSunat,64,'Sisven')
			Return 0
		Endif
		Do Case
		Case Left(rptaSunat,1)='0'
			mensaje(rptaSunat)
			Return 1
		Case Empty(rptaSunat)
			Messagebox(rptaSunat,64,'Sisven')
			Return 0
		Otherwise
			Messagebox(rptaSunat,64,'Sisven')
			Return 0
		Endcase
	Case goapp.ose="efact"
		Do Case
		Case goapp.tipoh=='B'
			lsURL   ="https://ose-gw1.efact.pe/ol-ti-itcpe/billService"
* "https://ose.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=fe_gene.nruc
			ls_pwd_sol = 'iGje3Ei9GN'
			ls_user = ls_ruc_emisor
		Case goapp.tipoh='P'
			lsURL  =  "https://ose.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
			ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
			ls_user = ls_ruc_emisor + Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
		Endcase
		TEXT TO lcEnvioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
		ENDTEXT
		If Not loXMLBody.LoadXML( lcEnvioXML )
			Error loXMLBody.parseError.reason
			Return -1
		Endif

		loXmlHttp.Open( "POST", lsURL, .F. )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
		loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
		loXmlHttp.setRequestHeader( "SOAPAction" , "urn:getStatusCdr" )
		loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
		loXmlHttp.Send(loXMLBody.documentElement.XML)
		If loXmlHttp.Status # 200 Then
			cerror=Nvl(loXmlHttp.responseText,'')
			crpta=Strextract(cerror, '<faultstring>', '</faultstring>',1)
			CMensaje1=Strextract(cerror, "<detail>","</detail>",1)
			Messagebox(crpta+' '+Alltrim(CMensaje1),16,MSGTITULO)
			Return -1
		Endif
		loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
		loXMLResp.LoadXML(loXmlHttp.responseText)
		CmensajeError=leerXMl(Alltrim(loXmlHttp.responseText),"<faultcode>","</faultcode>")
		CMensajeMensaje=leerXMl(Alltrim(loXmlHttp.responseText),"<faultstring>","</faultstring>")
		CMensajedetalle=leerXMl(Alltrim(loXmlHttp.responseText),"<detail>","</detail>")
		Cnumeromensaje=leerXMl(Alltrim(loXmlHttp.responseText),"<statusCode>","</statusCode>")
		CMensaje1=leerXMl(Alltrim(loXmlHttp.responseText),"<statusMessage>","</statusMessage>")
		If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Then
			Messagebox((Alltrim(CmensajeError)+' '+Alltrim(CMensajeMensaje)+' '+Alltrim(CMensajedetalle)+' '+Alltrim(CMensaje1)),16,'Sisven')
			Return 0
		Endif
		ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
		ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
		TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//document")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
		If Type('oempresa')='U' Then
			cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+crespuesta
			cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'
		Else
			cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+Alltrim(oempresa.nruc)+"\"+crespuesta
			cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"
		Endif
		decodefile(TxtB64.Text,cnombre)
		oShell = Createobject("Shell.Application")
		cfilerpta="R"
		For Each oArchi In oShell.NameSpace(cnombre).Items
			If Left(oArchi.Name,1)='R' Then
				oShell.NameSpace(cDirDesti).CopyHere(oArchi)
				cfilerpta=Juststem(oArchi.Name)+'.XML'
			Endif
		Endfor
		If Type('oempresa')='U' Then
			rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+cfilerpta)
		Else
			rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"+cfilerpta)
		Endif
		If Len(Alltrim(rptaSunat))>100 Then
			Messagebox(rptaSunat,64,'Sisven')
			Return 0
		Endif
		Do Case
		Case Left(rptaSunat,1)='0'
			mensaje(rptaSunat)
			Return 1
		Case Empty(rptaSunat)
			Messagebox(rptaSunat,64,'Sisven')
			Return 0
		Otherwise
			Messagebox(rptaSunat,64,'Sisven')
			Return 0
		Endcase
	Case goapp.ose="conastec"
		Do Case
		Case goapp.tipoh=='B'
			lsURL   = "https://test.conose.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=fe_gene.nruc
			ls_pwd_sol = 'moddatos'
			ls_user = ls_ruc_emisor + 'MODDATOS'
		Case goapp.tipoh='P'
			lsURL  =  "https://prod.conose.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
			ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
			ls_user = ls_ruc_emisor + Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
		Endcase
		TEXT TO lcEnvioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
		ENDTEXT
		If Not loXMLBody.LoadXML( lcEnvioXML )
			Error loXMLBody.parseError.reason
			Return -1
		Endif
		loXmlHttp.Open( "POST", lsURL, .F. )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
		loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
		loXmlHttp.setRequestHeader( "SOAPAction" , "urn:getStatusCdr" )
		loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )

		loXmlHttp.Send(loXMLBody.documentElement.XML)
		If loXmlHttp.Status # 200 Then
			cerror=Nvl(loXmlHttp.responseText,'')
			crpta=Strextract(cerror, '<faultstring>', '</faultstring>',1)
			Messagebox(crpta,16,MSGTITULO)
			Return -1
		Endif
		loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
		loXMLResp.LoadXML(loXmlHttp.responseText)
		CmensajeError=leerXMl(Alltrim(loXmlHttp.responseText),"<faultcode>","</faultcode>")
		CMensajeMensaje=leerXMl(Alltrim(loXmlHttp.responseText),"<faultstring>","</faultstring>")
		CMensajedetalle=leerXMl(Alltrim(loXmlHttp.responseText),"<detail>","</detail>")
		Cnumeromensaje=leerXMl(Alltrim(loXmlHttp.responseText),"<statusCode>","</statusCode>")
		CMensaje1=leerXMl(Alltrim(loXmlHttp.responseText),"<statusMessage>","</statusMessage>")
		If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Or Cnumeromensaje<>'0004' Then
			Messagebox((Alltrim(CmensajeError)+' '+Alltrim(CMensajeMensaje)+' '+Alltrim(CMensajedetalle)+' '+Alltrim(CMensaje1)),16,'Sisven')
			Return 0
		Endif
		ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
		ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta

		TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//content")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
		If Type('oempresa')='U' Then
			cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+crespuesta
			cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'
		Else
			cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+Alltrim(oempresa.nruc)+"\"+crespuesta
			cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"
		Endif
		decodefile(TxtB64.Text,cnombre)
		oShell = Createobject("Shell.Application")
		cfilerpta="R"
		For Each oArchi In oShell.NameSpace(cnombre).Items
			If Left(oArchi.Name,1)='R' Then
				oShell.NameSpace(cDirDesti).CopyHere(oArchi)
				cfilerpta=Juststem(oArchi.Name)+'.XML'
			Endif
		Endfor
		If Type('oempresa')='U' Then
			rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+cfilerpta)
		Else
			rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"+cfilerpta)
		Endif
		If Len(Alltrim(rptaSunat))>100 Then
			Messagebox(rptaSunat,64,'Sisven')
			Return 0
		Endif
		Do Case
		Case Left(rptaSunat,1)='0'
			mensaje(rptaSunat)
			Return 1
		Case Empty(rptaSunat)
			Messagebox(rptaSunat,64,'Sisven')
			Return 0
		Otherwise
			Messagebox(rptaSunat,64,'Sisven')
			Return 0
		Endcase
	Endcase
Else
	lcUserName = LcRucEmisor + lcUser_Sol
	lcURL   = "https://www.sunat.gob.pe/ol-it-wsconscpegem/billConsultService"
	TEXT TO lcEnvioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
	ENDTEXT

	If Not loXMLBody.LoadXML( lcEnvioXML )
		Error loXMLBody.parseError.reason
		Return -1
	Endif

	loXmlHttp.Open( "POST", lcURL, .F. )
	loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
	loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" )
	loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
	loXmlHttp.setRequestHeader( "SOAPAction" , "getStatus" )
	loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )

	loXmlHttp.Send(loXMLBody.documentElement.XML)
*?loXmlHttp.Status
	If loXmlHttp.Status # 200 Then
		cerror=Nvl(loXmlHttp.responseText,'')
		crpta=Strextract(cerror, '<faultstring>', '</faultstring>',1)
		Messagebox(crpta,16,MSGTITULO)
		Return -1
	Endif
	res = Createobject("MSXML2.DOMDocument.6.0")
	res.LoadXML(loXmlHttp.responseText)
	txtCod = res.selectSingleNode("//statusCode")  &&Return
	txtMsg = res.selectSingleNode("//statusMessage")  &&Return
	If txtCod.Text="0001"  Then
		mensaje(txtMsg.Text)
		Return  1
	Else
		mensaje(txtMsg.Text)
		Return  -1
	Endif
Endif
Endproc
*************************************
Function GeneraPle5Activos(np1,np2,na)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
cp=Alltrim(na)+'0000'
Select cp As p,;
	ALLTRIM(Str(ID0)) As IDx,;
	AllTrim('M'+Alltrim(Str(ID0))) As esta,;
	tabla13 As t13,;
	AllTrim(Alltrim(Str(ID1))) As cod1,;
	codigo As cod,;
	tabla18 As t18,;
	Left(cuenta,2)+Substr(cuenta,4,2)+Substr(cuenta,7,2) As cta,;
	tabla19 As t19,;
	ALLTRIM(Descripcion) As Descr,;
	IIF(Empty(marca),'-',marca) As marca,;
	IIF(Empty(modelo),'-',modelo) As modelo,;
	IIF(Empty(placa),'-',placa) As placa,;
	Saldo_inicial As Ini,;
	Valor_Adquirido As Vadq,;
	Mejoras As Mej,;
	Retiros As Ret,;
	Ajustes As Aju,;
	ValorRevaluacion As VRR,;
	RevaluacionRS As RRS,;
	OtrasRevaluaciones As Oreval,;
	AjusteInflacion As Ainf,;
	FechaAdquisicion As Fadq,;
	FechaUso As Fuso,;
	Tabla20 As t20,;
	dcto,;
	PorcentajeDep As PorDep,;
	DepreacicionAcumulada As DAc,;
	valorDepreciacion As Vdep,;
	DepreciacionRetiros As DRet,;
	DepreciacionOtrosAjustes As dj,;
	DepreciacionVoluntaria As DVol,;
	DepreciacionPorSociedades As DSoc,;
	DepreciacionOtrasRevaluaciones As DOReval,;
	DepreciacionPorInflacion As di,;
	1 As e From LdaPLe Into Cursor lreg
Select lreg
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
      \\<<p>>|<<idx>>|<<ALLTRIM(esta)>>|<<t13>>|<<ALLTRIM(cod1)>>|<<ALLTRIM(cod)>>|<<ALLTRIM(t18)>>|<<cta>>|<<ALLTRIM(t19)>>|<<descr>>|<<marca>>|<<modelo>>|<<placa>>|<<Ini>>|<<Vadq>>|<<mej>>|<<Ret>>|<<Aju>>|<<vrr>>|<<rrs>>|<<oreval>>|<<ainf>>|<<fadq>>|<<fuso>>|<<ALLTRIM(t20)>>|<<dcto>>|<<pordep>>|<<dac>>|<<vdep>>|<<dret>>|<<dj>>|<<dvol>>|<<dsoc>>|<<doreval>>|<<di>>|<<e>>|
	Else
       \<<p>>|<<idx>>|<<ALLTRIM(esta)>>|<<t13>>|<<ALLTRIM(cod1)>>|<<ALLTRIM(cod)>>|<<ALLTRIM(t18)>>|<<cta>>|<<ALLTRIM(t19)>>|<<descr>>|<<marca>>|<<modelo>>|<<placa>>|<<Ini>>|<<Vadq>>|<<mej>>|<<Ret>>|<<Aju>>|<<vrr>>|<<rrs>>|<<oreval>>|<<ainf>>|<<fadq>>|<<fuso>>|<<ALLTRIM(t20)>>|<<dcto>>|<<pordep>>|<<dac>>|<<vdep>>|<<dret>>|<<dj>>|<<dvol>>|<<dsoc>>|<<doreval>>|<<di>>|<<e>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*************************************
Function IngresaDatosDiarioPle55(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
cur="l"
lc="FunIngresaDatosLibroDiarioPle55"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
goapp.npara11=np11
goapp.npara12=np12
goapp.npara13=np13
goapp.npara14=np14
goapp.npara15=np15
goapp.npara16=np16
goapp.npara17=np17
goapp.npara18=np18
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' '+' Ingresando Asientos  a Libro Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************
Function Adjuntar(np1,np2,np3)
car=Sys(5)+Sys(2003)+"\FirmaXML\"+Alltrim(fe_gene.nruc)+"-"+Alltrim(np3)+"-"+Left(np2,4)+'-'+Alltrim(Substr(np2,5))+".xml"
*car=Sys(5)+Sys(2003)+"\FirmaXML\"+"-"+Alltrim(np3)+"-"+Left(np2,4)+'-'+Alltrim(Substr(np2,5))+".xml"
If File((car)) Then
	TEXT TO lc noshow
      UPDATE fe_rcom SET rcom_arch=?car WHERE idauto=?np1
	ENDTEXT
	ncon=Abreconexion()
	If SQLExec(ncon,lc)<=0 Then
		errorbd(lc)
		Return
	Endif
	CierraConexion(ncon)
	mensaje("Adjuntado")
	Return Justfname(car)
Else
	mensaje("NO Adjuntado")
	Return ""
Endif
Endfunc
*******************************
Function AdjuntarM(np1,np2,np3)
car1=Sys(5)+Sys(2003)+"\FirmaXML\"+Alltrim(fe_gene.nruc)+"-"+Alltrim(np3)+"-"+Left(np2,4)+'-'+Alltrim(Substr(np2,5))+".xml"
If File(car1) Then
	car=car1
Else
	car=Sys(5)+Sys(2003)+"\FirmaXML\"+Alltrim(oempresa.nruc)+"\"+Alltrim(fe_gene.nruc)+"-"+Alltrim(np3)+"-"+Left(np2,4)+'-'+Alltrim(Substr(np2,5))+".xml"
Endif
If File((car)) Then
	TEXT TO lc noshow
     UPDATE fe_rcom SET rcom_arch=?car WHERE idauto=?np1
	ENDTEXT
	ncon=Abreconexion()
	If SQLExec(ncon,lc)<=0 Then
		errorbd(lc)
		Return
	Endif
	CierraConexion(ncon)
	mensaje("Adjuntado")
	Return Justfname(car)
Else
	mensaje("NO Adjuntado")
	Return ""
Endif
Endfunc
***********************
********************************************************************
********************************************************************
*!* FUNCTION Exp2Excel( [cCursor, [cFileSave, [cTitulo]]] )
*!*
*!* Exporta un Cursor de Visual FoxPro a Excel, utilizando la
*!* técnica de importación de datos externos en modo texto.
*!*
*!* PARAMETROS OPCIONALES:
*!* - cCursor  Alias del cursor que se va a exportar.
*!*            Si no se informa, utiliza el alias
*!*            en que se encuentra.
*!*
*!* - cFileName  Nombre del archivo que se va a grabar.
*!*              Si no se informa, muestra el libro generado
*!*              una vez concluída la exportación.
*!*
*!* - cTitulo  Titulo del informe. Si se informa, este
*!*            ocuparía la primera file de cada hoja del libro.
********************************************************************
********************************************************************
Function Exp3Excel(ccursor, cfilesave, ctitulo)
Local cwarning
If Empty(ccursor)
	ccursor = Alias()
Endif
If Type('cCursor') # 'C' Or !Used(ccursor)
	Messagebox("Parámetros Inválidos",16,_vfp.msgbox_error)
	Return .F.
Endif
*********************************
*** Creación del Objeto Excel ***
*********************************
Wait Window 'Abriendo aplicación Excel.' Nowait Noclear
oexcel = Createobject("Excel.Application")
Wait Clear

If Type('oExcel') # 'O'
	Messagebox("No se puede procesar el archivo porque no tiene la aplicación" ;
		+ Chr(13) + "Microsoft Excel instalada en su computadora.", 16, _vfp.msgbox_error)
	Return .F.
Endif

oexcel.workbooks.Add

Local lnrecno, lnpos, lnpag, lncuantos, lnrowtit, lnrowpos, i, lnhojas, cdefault

cdefault = Addbs(Sys(5)  + Sys(2003))

Select (ccursor)
If Eof()
	lnrecno = 0
Else
	lnrecno = Recno(ccursor)
Endif
Go Top

*************************************************
*** Verifica la cantidad de hojas necesarias  ***
*** en el libro para la cantidad de datos     ***
*************************************************
lnhojas = Round(Reccount(ccursor)/65000,0)
Do While oexcel.sheets.Count < lnhojas
	oexcel.sheets.Add
Enddo

lnpos = 0
lnpag = 0

Do While lnpos < Reccount(ccursor)

	lnpag = lnpag + 1 && Hoja que se está procesando

	Wait Windows 'Exportando datos a Excel...' Noclear Nowait

	If File(cdefault  + ccursor  + ".txt")
		Delete File (cdefault  + ccursor  + ".txt")
	Endif

	Copy  Next 65000 To (cdefault  + ccursor  + ".txt") Delimited With Character ";"
	lnpos = Recno(ccursor)

	oexcel.sheets(lnpag).Select

	xlsheet = oexcel.activesheet
	xlsheet.Name = ccursor + '_' + Alltrim(Str(lnpag))

	lncuantos = Afields(acampos,ccursor)

********************************************************
*** Coloca título del informe (si este es informado) ***
********************************************************
	If !Empty(ctitulo)
		xlsheet.cells(1,1).Font.Name = "Arial"
		xlsheet.cells(1,1).Font.Size = 12
		xlsheet.cells(1,1).Font.bold = .T.
		xlsheet.cells(1,1).Value = ctitulo
		xlsheet.Range(xlsheet.cells(1,1),xlsheet.cells(1,lncuantos)).mergecells = .T.
		xlsheet.Range(xlsheet.cells(1,1),xlsheet.cells(1,lncuantos)).merge
		xlsheet.Range(xlsheet.cells(1,1),xlsheet.cells(1,lncuantos)).horizontalalignment = 3
		lnrowpos = 3
	Else
		lnrowpos = 2
	Endif

	lnrowtit = lnrowpos - 1
**********************************
*** Coloca títulos de Columnas ***
**********************************
	For i = 1 To lncuantos
		lcname  = acampos(i,1)
		lccampo = Alltrim(ccursor) + '.' + acampos(i,1)
		xlsheet.cells(lnrowtit,i).Value=lcname
		xlsheet.cells(lnrowtit,i).Font.bold = .T.
		xlsheet.cells(lnrowtit,i).interior.colorindex = 15
		xlsheet.cells(lnrowtit,i).interior.Pattern = 1
		xlsheet.Range(xlsheet.cells(lnrowtit,i),xlsheet.cells(lnrowtit,i)).borderaround(7)
	Next

	xlsheet.Range(xlsheet.cells(lnrowtit,1),xlsheet.cells(lnrowtit,lncuantos)).horizontalalignment = 3

*************************
*** Cuerpo de la hoja ***
*************************
	oconnection = xlsheet.querytables.Add("TEXT;"  + cdefault  + ccursor  + ".txt", ;
		xlsheet.Range("A"  + Alltrim(Str(lnrowpos))))

	With oconnection
		.Name = ccursor
		.fieldnames = .T.
		.rownumbers = .F.
		.filladjacentformulas = .F.
		.preserveformatting = .T.
		.refreshonfileopen = .F.
		.refreshstyle = 1 && xlInsertDeleteCells
		.savepassword = .F.
		.savedata = .T.
		.adjustcolumnwidth = .T.
		.refreshperiod = 0
		.textfilepromptonrefresh = .F.
		.textfileplatform = 850
		.textfilestartrow = 1
		.textfileparsetype = 1 && xlDelimited
		.textfiletextqualifier = 1 && xlTextQualifierDoubleQuote
		.textfileconsecutivedelimiter = .F.
		.textfiletabdelimiter = .F.
		.textfilesemicolondelimiter = .T.
		.textfilecommadelimiter = .F.
		.textfilespacedelimiter = .F.
		.textfiletrailingminusnumbers = .T.
		.Refresh
	Endwith

	xlsheet.Range(xlsheet.cells(lnrowtit,1),xlsheet.cells(xlsheet.Rows.Count,lncuantos)).Font.Name = "Arial"
	xlsheet.Range(xlsheet.cells(lnrowtit,1),xlsheet.cells(xlsheet.Rows.Count,lncuantos)).Font.Size = 10

	xlsheet.Columns.AutoFit
	xlsheet.cells(lnrowpos,1).Select
	oexcel.activewindow.freezepanes = .T.

	Wait Clear

Enddo
*********************************
Function leerXMl(lcXML,ctagi,ctagf)
Local lnCount As Integer
cvalor=""
For lnI = 1 To Occurs(ctagi, lcXML)
	cvalor = Strextract(lcXML, ctagi,ctagf,lnI)
Next lnI
Return cvalor
Endfunc
***************************************
Function VerificaArchivoRespuesta(cfile,crpta,cticket)
If !File(cfile) Then
	Return cfile
Endif
Return cfile
car=""
npos=At("-",crpta,3)
cruta=Justpath(cfile)
car=Substr(crpta,1,At('.',crpta)-1)
Do While .T.
	generaCorrelativoEnvioResumenBoletas()
	datosGlobales()
	car1=Stuff(car, npos+1, 3,Alltrim(Str(fe_gene.gene_nres)))
	cfile=Addbs(Alltrim(cruta))+Alltrim(car1)+'.zip'
	If !File(cfile)
		ActualizarArchivoEnvio(cticket)
		Exit
	Endif
Enddo
Return cfile
Endfunc
************************
Procedure ActualizarArchivoEnvio(cfile,cticket)
TEXT TO lc NOSHOW
   UPDATE fe_resboletas SET resu_arch=?cfile WHERE resu_tick=?cticket
ENDTEXT
If SQLExec(goapp.bdconn,lc)<0 Then
	errorbd(lc)
Endif
Endproc
************************
Function  ActualizaBxb
Lparameters ndesde,nhasta
TEXT TO lc noshow
			select idauto,numero from(
			SELECT idauto,ndoc,cast(mid(ndoc,5) as unsigned) as numero FROM fe_rcom f where acti='A' and idcliente>0) as x
			where numero between ?ndesde and ?nhasta
ENDTEXT
If SQLExec(goapp.bdconn,lc,'crb')<0 Then
	errorbd(lc)
	Return
Endif
np3="0 El Resumen de Boletas ha sido aceptado"
sw=1
Select crb
Go Top
Scan All
	np1=crb.idauto
	TEXT  TO lc noshow
           UPDATE fe_rcom SET rcom_mens=?np3 WHERE idauto=?np1
	ENDTEXT
	If SQLExec(goapp.bdconn,lc)<0 Then
		errorbd(lc)
		sw=0
	Endif
Endscan
Return sw
Endproc
********************************
Procedure ReimprimirStandarComoTicket(np1,np2,np3)
If verificaAlias("tmpv")=0 Then
	Create Cursor tmpv(coda N(8),Desc c(120),unid c(15),Prec N(13,8),cant N(10,2),ndoc c(12),alma N(10,2),peso N(10,2),;
		Impo N(10,2),tipro c(1),ptoll c(50),fect d,perc N(5,2),cletras c(120),tdoc c(2),;
		nruc c(11),razon c(120),direccion c(190),fech d,fechav d,ndo2 c(12),vendedor c(50),Forma c(20),Form c(20),guia c(15),duni c(15),;
		referencia c(120),hash c(30),dni c(8),Mone c(1),tdoc1 c(2),dcto c(12),fech1 d,usuario c(30),tigv N(5,3),detalle c(120),contacto c(120),archivo c(120))
Else
	Zap In tmpv
Endif

Do Case
Case np2='01' Or np2='03'
	cx=""
	If  Vartype(np3)='C' Then
		cx=np3
	Endif
	If cx='S' Then
		TEXT TO lc NOSHOW
			  	SELECT 4 as codv,c.idauto,1 as idart,ifnull(a.cant,1) as cant,ifnull(a.prec,0) as prec,c.codt as alma,
          		c.tdoc as tdoc1,
			    c.ndoc as dcto,c.fech as fech1,c.vigv,
			    c.fech,c.fecr,c.form,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,
          		c.pimpo,u.nomb as usuario,c.deta,
			    c.tdoc,c.ndoc,c.dolar as dola,c.mone,"" as descri,'' as Unid,
          		c.rcom_hash,'Oficina' as nomv,c.impo
          		FROM fe_rcom as c left join fe_kar as a on(a.idauto=c.idauto)
			    inner join fe_clie as d on(d.idclie=c.idcliente)
			    inner join fe_usua as u on u.idusua=c.idusua where c.idauto=?np1
			    union all
			  	SELECT 4 as codv,c.idauto,0 as idart,1 as cant,impo as prec,c.codt as alma,
          		c.tdoc as tdoc1,
			    c.ndoc as dcto,c.fech as fech1,c.vigv,
			    c.fech,c.fecr,c.form,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,
          		c.pimpo,u.nomb as usuario,c.deta,
			    c.tdoc,c.ndoc,c.dolar as dola,c.mone,m.detv_desc as descri,'' as Unid,
          		c.rcom_hash,'Oficina' as nomv,c.impo
          		FROM fe_rcom as c inner join fe_clie as d on(d.idclie=c.idcliente)
			    inner join fe_usua as u on u.idusua=c.idusua   inner join fe_detallevta as m on m.detv_idau=c.idauto
          		where c.idauto=?np1
		ENDTEXT
****

		TEXT TO lc NOSHOW
			  	SELECT 4 as codv,c.idauto,0 as idart,CAST(1  as decimal(12,2)) as cant,if(detv_item=1,impo,0) as prec,c.codt as alma,
          		c.tdoc as tdoc1,
			    c.ndoc as dcto,c.fech as fech1,c.vigv,
			    c.fech,c.fecr,c.form,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,
          		c.pimpo,u.nomb as usuario,c.deta,
			    c.tdoc,c.ndoc,c.dolar as dola,c.mone,m.detv_desc as descri,'' as Unid,
          		c.rcom_hash,'Oficina' as nomv,c.impo
          		FROM fe_rcom as c inner join fe_clie as d on(d.idclie=c.idcliente)
			    inner join fe_usua as u on u.idusua=c.idusua   inner join fe_detallevta as m on m.detv_idau=c.idauto
          		where c.idauto=?np1 group by descri order by detv_ite1
		ENDTEXT
	Else
		TEXT TO lc noshow
			    SELECT a.codv,a.idauto,a.alma,a.idkar,a.idauto,a.idart,a.cant,a.prec,a.alma,c.tdoc as tdoc1,
			    c.ndoc as dcto,c.fech as fech1,c.vigv,
			    c.fech,c.fecr,c.form,c.deta,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,c.pimpo,u.nomb as usuario,
			    c.tdoc,c.ndoc,c.dolar as dola,c.mone,b.descri,b.unid,c.rcom_hash,v.nomv,c.impo FROM fe_art as b join fe_kar as a on(b.idart=a.idart)
			    inner join fe_vend as v on v.idven=a.codv  inner JOIN fe_rcom as c on(a.idauto=c.idauto) inner join fe_clie as d on(c.idcliente=d.idclie)
			    inner join fe_usua as u on u.idusua=c.idusua
			    where c.idauto=?np1 and a.acti='A';
		ENDTEXT
	Endif
Case np2='08'
	TEXT TO lc noshow
			   SELECT r.idauto,r.ndoc,r.tdoc,r.fech,r.mone,abs(r.valor) as valor,r.ndo2,
		       r.vigv,c.nruc,c.razo,c.dire,c.ciud,c.ndni,' ' as nomv,r.form,
		       abs(r.igv) as igv,abs(r.impo) as impo,ifnull(k.cant,CAST(0 as decimal(12,2))) as cant,
		       ifnull(k.prec,ABS(r.impo)) as prec,LEFT(r.ndoc,4) as serie,SUBSTR(r.ndoc,5) as numero,
		       ifnull(a.unid,'') as unid,ifnull(a.descri,r.deta) as descri,r.deta,ifnull(k.idart,CAST(0 as decimal(8))) as idart,w.ndoc as dcto,
		       w.fech as fech1,w.tdoc as tdoc1,r.rcom_hash,u.nomb as usuario
		       from fe_rcom r inner join fe_clie c on c.idclie=r.idcliente
		       left join fe_kar k on k.idauto=r.idauto left join fe_art a on a.idart=k.idart
		       inner join fe_ncven f on f.ncre_idan=r.idauto inner join fe_rcom as w on w.idauto=f.ncre_idau
		        inner join fe_usua as u on u.idusua=r.idusua
		       where r.idauto=?np1 and r.acti='A' and r.tdoc='08'
	ENDTEXT
Case np2='07'
	TEXT TO lc noshow
			   SELECT r.idauto,r.ndoc,r.tdoc,r.fech,r.mone,abs(r.valor) as valor,r.ndo2,
		       r.vigv,c.nruc,c.razo,c.dire,c.ciud,c.ndni,' ' as nomv,r.form,u.nomb as usuario,
		       abs(r.igv) as igv,abs(r.impo) as impo,ifnull(k.cant,CAST(0 as decimal(12,2))) as cant,
		       ifnull(k.prec,ABS(r.impo)) as prec,LEFT(r.ndoc,4) as serie,SUBSTR(r.ndoc,5) as numero,
		       ifnull(a.unid,'') as unid,ifnull(a.descri,r.deta) as descri,r.deta,ifnull(k.idart,CAST(0 as decimal(8))) as idart,w.ndoc as dcto,
		       w.fech as fech1,w.tdoc as tdoc1,r.rcom_hash
		       from fe_rcom r inner join fe_clie c on c.idclie=r.idcliente
		       left join fe_kar k on k.idauto=r.idauto left join fe_art a on a.idart=k.idart
		       inner join fe_ncven f on f.ncre_idan=r.idauto inner join fe_rcom as w on w.idauto=f.ncre_idau
		        inner join fe_usua as u on u.idusua=r.idusua
		       where r.idauto=?np1 and r.acti='A' and r.tdoc='07'
	ENDTEXT
Endcase
ncon=Abreconexion()
If SQLExec(ncon,lc,'kardex')<0 Then
	errorbd(lc)
	Return
Endif
CierraConexion(ncon)
nimpo=kardex.Impo
cndoc=kardex.ndoc
cmone=kardex.Mone
ctdoc=kardex.tdoc
chash=kardex.rcom_hash
cdeta1=kardex.Deta
vvigv=kardex.vigv
nf=0
Select kardex
Scan All
	nf=nf+1
	Insert Into tmpv(coda,Desc,unid,cant,Prec,ndoc,hash,nruc,razon,direccion,fech,fechav,ndo2,vendedor,Form,;
		referencia,dni,Mone,dcto,tdoc1,fech1,usuario,guia,Forma,tigv,tdoc);
		values(Iif(Vartype(kardex.idart)='N',kardex.idart,Val(kardex.idart)),kardex.Descri,kardex.unid,Iif(kardex.cant=0,1,kardex.cant),kardex.Prec,;
		kardex.ndoc,kardex.rcom_hash,kardex.nruc,kardex.razo,Alltrim(kardex.Dire)+' '+Alltrim(kardex.ciud),kardex.fech,kardex.fech,;
		kardex.ndo2,kardex.nomv,Icase(kardex.Form='E','Efectivo',kardex.Form='C','Crédito',kardex.Form='T','Tarjeta',kardex.Form='D','Depósito','Cheque'),;
		kardex.Deta,kardex.ndni,kardex.Mone,kardex.dcto,kardex.tdoc1,kardex.fech1,kardex.usuario,kardex.ndo2,;
		Icase(kardex.Form='E','Efectivo',kardex.Form='C','Crédito',kardex.Form='T','Tarjeta',kardex.Form='D','Depósito','Cheque'),kardex.vigv,ctdoc)
Endscan
Local cimporte
cimporte=Diletras(nimpo,cmone)
Select tmpv
Replace All ndoc With cndoc,cletras With cimporte,Mone With cmone,hash With chash,referencia With cdeta1,tigv With vvigv
Go Top In tmpv
Endproc
*************************
Function DevuelveServidorCorreo
Local ccorreo,clavecorreo
If Type('oempresa')='U' Then
	ccorreo=fe_gene.correo
	clavecorreo=fe_gene.gene_ccor
Else
	ccorreo=oempresa.correo
	clavecorreo=oempresa.gene_ccor
Endif
If Empty(ccorreo) Or Empty(clavecorreo) Then
	Return ' '
Endif
npos=At("@",ccorreo)
sc1=Substr(ccorreo,npos+1)
npos1=At(".",sc1)
Return Substr(sc1,1,npos1-1)
Endfunc
****************************
Function EnviaFacturasNotasAutomatico(calias,cmulti1,cfracciones,cversion,ctipovtacosta)
Set Classlib To ("fe") Additive
cvtacosta=Iif(Type(ctipovtacosta)='L','',ctipovtacosta)
ocomp=Createobject("comprobante")
Select * From (calias) Into Cursor envx
Select envx
Go Top
Do While !Eof()
	ocomp.cmulti=cmulti1
	ocomp.fracciones=cfracciones
	ocomp.Version=cversion
	ocomp.VentaCosta=cvtacosta
	Select envx
	Try
		Do Case
		Case envx.tdoc='01'
			If envx.tcom='S' Then
				If envx.vigv=1 Then
					vdne=ocomp.obtenerdatosfacturaexoneradaotros(envx.idauto)
				Else
					vdne=ocomp.obtenerdatosfacturaotros(envx.idauto)
				Endif
			Else
				If envx.vigv=1 Then
					vdne=ocomp.obtenerdatosfacturaexonerada(envx.idauto)
				Else
					vdne=ocomp.obtenerdatosfactura(envx.idauto)
				Endif
			Endif
		Case envx.tdoc='07'
			If envx.tcom='S' Then
				ocomp.tipoventanotacredito='S'
			Else
				ocomp.tipoventanotacredito=""
			Endif
			If envx.vigv=1 Then
				vdne=ocomp.obtenerdatosnotecreditoexonerada(envx.idauto,'E')
			Else
				vdne=ocomp.obtenerdatosnotascredito(envx.idauto,'E')
			Endif
		Case envx.tdoc='08'
			If envx.vigv=1 Then
				vdne=ocomp.obtenernotasdebitoexonerada(envx.idauto,'E')
			Else
				vdne=ocomp.obtenerdatosnotasDebito(envx.idauto,'E')
			Endif
		Endcase
	Catch To oerr When oerr.ErrorNo=1429
		Messagebox(MENSAJE1+MENSAJE2+MENSAJE3,16,MSGTITULO)
	Catch To oerr When oerr.ErrorNo=1924
		Messagebox(MENSAJE1+MENSAJE2+MENSAJE3,16,MSGTITULO)
	Finally
	Endtry
	Select envx
	Skip
Enddo
Endfunc
**************************************
Function IngresaResumenDctoGratuito(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24)
lc='FUNingresaCabeceraGratuito'
cur="Xn"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
goapp.npara11=np11
goapp.npara12=np12
goapp.npara13=np13
goapp.npara14=np14
goapp.npara15=np15
goapp.npara16=np16
goapp.npara17=np17
goapp.npara18=np18
goapp.npara19=np19
goapp.npara20=np20
goapp.npara21=np21
goapp.npara22=np22
goapp.npara23=np23
goapp.npara24=np24
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Ingresando Cabecera de Documento')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
*******************************
Function IngresakardexGratuito(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11)
*nid,cc,ct,npr,nct,cincl,tmvto,ccodv,nidalmacen,nidcosto1,xcomision)
lc='FuningresakardexGratuito'
cur="nidk"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
goapp.npara11=np11
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Ingresando Salidas de Productos por Transferencia Gratuita')
	Return 0
Else
	Return nidk.Id
Endif
Endfunc
*********************************
Function verificarCorreocliente(email)
If Vartype(email) # "C"
	vd=0
Else
	loRegExp = Createobject("VBScript.RegExp")
	loRegExp.IgnoreCase = .T.
	loRegExp.Pattern =  '^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)­*)\.([A-Za-z]{2,})$'
	m.valid = loRegExp.Test(Alltrim(m.email))
	Release loRegExp
	vd=Iif(m.valid,1,0)
Endif
Do Case
Case vd>0
	ncolor=Rgb(128,255,128)
Otherwise
	ncolor=Rgb(234,234,234)
Endcase
Return vd
Endfunc
****************************
Function EnviaFacturasNotasAutomatico1(calias,cmulti1,cfracciones,cversion)
Set Classlib To ("fe") Additive
ocomp=Createobject("comprobante")
Select (calias)
Go Top
Do While !Eof()
	ocomp.cmulti=cmulti1
	ocomp.fracciones=cfracciones
	ocomp.Version=cversion
	Select (calias)
	nid=idauto
	ctdoc=tdoc
	ctcom=tcom
	Try
		Do Case
		Case ctdoc='01'
			If rcom_otro>0 Then
				vdne=ocomp.obtenerdatosfacturatransferenciagratuita(nid)
			Else
				If ctcom='S' Then
					vdne=ocomp.obtenerdatosfacturaotros(nid)
				Else
					vdne=ocomp.obtenerdatosfactura(nid)
				Endif
			Endif
		Case ctdoc='07'
			vdne=ocomp.obtenerdatosnotascredito(nid)
		Case ctdoc='08'
			vdne=ocomp.obtenerdatosnotasDebito(nid)
		Endcase
	Catch To oerr When oerr.ErrorNo=1429
		Messagebox(MENSAJE1+MENSAJE2+MENSAJE3,16,MSGTITULO)
	Catch To oerr When oerr.ErrorNo=1924
		Messagebox(MENSAJE1+MENSAJE2+MENSAJE3,16,MSGTITULO)
	Finally
	Endtry
	Select (calias)
	Skip
Enddo
****************************
Function EnviaFacturasGuiasNotasAutomatico1(calias,cmulti1,cfracciones,cversion)
Set Classlib To ("fe") Additive
ocomp=Createobject("comprobante")
Select (calias)
Go Top
Do While !Eof()
	ocomp.cmulti=cmulti1
	ocomp.fracciones=cfracciones
	ocomp.Version=cversion
	Select (calias)
	nid=idauto
	ctdoc=tdoc
	ctcom=tcom
	Try
		Do Case
		Case ctdoc='01'
			If ctcom='S' Then
				vdne=ocomp.obtenerdatosfacturaotros(nid)
			Else
				vdne=ocomp.obtenerdatosfacturaguia(nid)
			Endif
		Case ctdoc='07'
			vdne=ocomp.obtenerdatosnotascredito(nid)
		Case ctdoc='08'
			vdne=ocomp.obtenerdatosnotasDebito(nid)
		Endcase
	Catch To oerr When oerr.ErrorNo=1429
		Messagebox(MENSAJE1+MENSAJE2+MENSAJE3,16,MSGTITULO)
	Catch To oerr When oerr.ErrorNo=1924
		Messagebox(MENSAJE1+MENSAJE2+MENSAJE3,16,MSGTITULO)
	Finally
	Endtry
	Select (calias)
	Skip
Enddo
*********************************
Function IngresaDatosDiarioPle55M(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19)
cur="l"
lc="FunIngresaDatosLibroDiarioPle55"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
goapp.npara11=np11
goapp.npara12=np12
goapp.npara13=np13
goapp.npara14=np14
goapp.npara15=np15
goapp.npara16=np16
goapp.npara17=np17
goapp.npara18=np18
goapp.npara19=np19
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' '+' Ingresando Asientos  a Libro Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
************************************
Function DesactivaCreditoAutorizado(np)
Set Procedure To clientes Additive
Local Obj As cliente
Obj=Createobject("clientex")
Obj.codigo=np
Obj.AutorizadoCredito=0
Obj.Autorizacreditocliente()
Endfunc
**************************************
Function IngresaDatosDiarioPle51(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17)
cur="l"
lc="ProIngresaDatosLibroDiarioPLe5"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
goapp.npara11=np11
goapp.npara12=np12
goapp.npara13=np13
goapp.npara14=np14
goapp.npara15=np15
goapp.npara16=np16
goapp.npara17=np17
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' '+' Ingresando Asientos  a Libro Diario')
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
		STRING @pbBinary, Long cbBinary, Long dwFlags,;
		STRING @pszString, Long @pcchString

	Declare Integer CryptStringToBinary In crypt32;
		STRING @pszString, Long cchString, Long dwFlags,;
		STRING @pbBinary, Long @pcbBinary,;
		LONG pdwSkip, Long pdwFlags
*
	Endproc


* encodeString
* Toma un string y lo convierte en base64
*
	Procedure encodeString(pcString)
	Local nFlags, nBufsize, cDst
	nFlags=1  && base64
	nBufsize=0
	CryptBinaryToString(@pcString, Len(pcString),m.nFlags, Null, @nBufsize)
	cDst = Replicate(Chr(0), m.nBufsize)
	If CryptBinaryToString(@pcString, Len(pcString), m.nFlags,@cDst, @nBufsize) = 0
		Return ""
	Endif
	Return cDst
	Endproc


* decodeString
* Toma una cadena en BAse64 y devuelve la cadena original
*
	Function decodeString(pcB64)
	Local nFlags, nBufsize, cDst
	nFlags=1  && base64
	nBufsize=0
	pcB64 = Strt(Strt(Strt(pcB64,"\/","/"),"\u000d",Chr(13)),"\u000a",Chr(10))
	CryptStringToBinary(@pcB64, Len(m.pcB64),nFlags, Null, @nBufsize, 0,0)
	cDst = Replicate(Chr(0), m.nBufsize)
	If CryptStringToBinary(@pcB64, Len(m.pcB64),nFlags, @cDst, @nBufsize, 0,0) = 0
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
	curl=""
	correocliente=""
	nidauto=0
	ArchivoXml=""
	archivopdf=""
	ccruc=""
	dfecha=Ctod("  /  /    ")
	ccndoc=""
	importe=0
	ctdoc1=""
	Function subirHosting()
	pURL_WSDL=This.curl
	cruc =This.ccruc
	nidauto = This.nidauto
	df1 = This.dfecha
	cdoc =This.ccndoc
	c1=This.ArchivoXml
	nimpo=Abs(This.importe)
	ctdocx=This.ctdoc1
	nombrexml=Justfname(c1)
	ls_contentFile = Filetostr(c1)
	contxml =Strconv(ls_contentFile,13)
	c2=This.archivopdf
	ls_contentFile = Filetostr(c2)
	contpdf = Strconv(ls_contentFile, 13)
	nombrepdf=Justfname(c2)
	ctabla="r_"+Alltrim(cruc)
	TEXT TO cdata NOSHOW TEXTMERGE
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
	"ctdoc":"<<ctdocx>>"
	}
	ENDTEXT
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", pURL_WSDL,.F.)
	oHTTP.setRequestHeader("Content-Type", "application/json;utf-8")
	oHTTP.Send(cdata)
	Endfunc
	Function enviarcorreo()
	Set Classlib To c:\librerias\fe Additive
	ocomp=Createobject("comprobante")
	ocomp.correo=This.correocliente
	ocomp.ArchivoXml=This.ArchivoXml
	ocomp.archivopdf=This.archivopdf
	ocomp.enviarcorreoclientegmail(This.correocliente)
	Endfunc
	Function VerificaAceptado()
	nid=This.nidauto
	TEXT TO lc NOSHOW
           SELECT idauto,rcom_arch FROM fe_rcom WHERE LEFT(rcom_mens,1)='0'  AND idauto=?nid
	ENDTEXT
	If SQLExec(goapp.bdconn,lc,'lr')<=0 Then
		errorbd(lc)
		Return 0
	Else
		Return lr.idauto
	Endif
	Endfunc
Enddefine
*************************
Function  EnviaCorreoHosting()
Set Procedure To capadatos,ple5,imprimir Additive
ocomx=Createobject("comprobantex")
ocomx.curl='http://facturacionsysven.com/p2.php'
Set Classlib To c:\librerias\fe Additive
ocomp=Createobject("comprobante")
obji=Createobject("Imprimir")
Select renvia
Scan All
	ocomx.nidauto=renvia.idauto
	If ocomx.VerificaAceptado()>0 Then
		df=renvia.fech
		df1 = Alltrim(Str(Year(df)))+'-'+Alltrim(Str(Month(df)))+'-'+Alltrim(Str(Day(df)))
		ocomx.dfecha=df1
		ocomx.ccndoc=renvia.ndoc
		If Type('oempresa')='U' Then
			ocomx.ccruc=fe_gene.nruc
			ocomx.ArchivoXml=Addbs(Sys(5)+Sys(2003)+'\FirmaXML\')+Justfname(lr.rcom_arch)
			carfile=Justfname(lr.rcom_arch)
			npos=At(".",carfile)
			carpdf=Left(carfile,npos-1)+'.Pdf'
			cpdf=Addbs(Sys(5)+Sys(2003)+'\PDF\')+carpdf
		Else
			ocomx.ccruc=oempresa.nruc
			ocomx.ArchivoXml=Addbs(Sys(5)+Sys(2003)+'\FirmaXML\'+Alltrim(oempresa.nruc)+"\")+Justfname(lr.rcom_arch)
			carfile=Justfname(lr.rcom_arch)
			npos=At(".",carfile)
			carpdf=Left(carfile,npos-1)+'.Pdf'
			cpdf=Addbs(Sys(5)+Sys(2003))+oempresa.nruc+'\PDF\'+carpdf
		Endif
		If !File(cpdf) Then
			ReimprimirStandar(renvia.idauto,renvia.tdoc,renvia.tcom)
			obji.tdoc=renvia.tdoc
			obji.ImprimeComprobante('N')
			obji.archivopdf=cpdf
			obji.GeneraPDF('N')
		Endif
		ocomx.archivopdf=cpdf
		ocomx.correocliente=renvia.clie_corr
		If Len(Alltrim(ocomx.correocliente))>1 Then
			ocomp.correo=renvia.clie_corr
			ocomp.ArchivoXml=ocomx.ArchivoXml
			ocomp.archivopdf=ocomx.archivopdf
			ocomp.ndoc=renvia.ndoc
			ocomp.fechaemision=renvia.fech
			ocomp.ruccliente=renvia.nruc
			ocomp.tdoc=renvia.tdoc
			ocomp.enviarcorreoClientex(renvia.clie_corr)
		Endif
		If File(ocomx.ArchivoXml) And File(ocomx.archivopdf) Then
			ocomx.subirHosting()
		Endif
	Endif
Endscan
*************************
Function verificaSiestaAnulada(cndoc,ctdoc)
TEXT TO lc NOSHOW
      SELECT idauto from fe_rcom where ndoc=?cndoc and tdoc=?ctdoc and impo=0 and idcliente>0 and acti='A' group by ndoc
ENDTEXT
If SQLExec(goapp.bdconn,lc,'anulada')<0 Then
	errorbd(lc)
	Return 0
Else
	Select anulada
	If idauto>0 Then
		Return  0
	Else
		Return  1
	Endif
Endif
Endfunc
***************************
Function verificancventas(nidauto)

TEXT TO lc NOSHOW
     SELECT ncre_idau as idauto FROM fe_ncven WHERE ncre_idau=?nidauto AND ncre_acti='A'
ENDTEXT
If SQLExec(goapp.bdconn,lc,'yanc')<0 Then
	errorbd(lc)
	Return 0
Else
	Select yanc
	If idauto>0 Then
		Return  0
	Else
		Return  1
	Endif
Endif
Endfunc
***************************
Procedure EnviarSunatGuia(pk,crptahash)
Declare Integer CryptBinaryToString In Crypt32;
	STRING @pbBinary, Long cbBinary, Long dwFlags,;
	STRING @pszString, Long @pcchString

Declare Integer CryptStringToBinary In crypt32;
	STRING @pszString, Long cchString, Long dwFlags,;
	STRING @pbBinary, Long @pcbBinary,;
	LONG pdwSkip, Long pdwFlags

#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056
Set Library To Locfile("vfpcompression.fll")
ZipfileQuick(goapp.carchivo)
zipclose()
cpropiedad="ose"
If !Pemstatus(goapp,cpropiedad,5)
	goapp.AddProperty("ose","")
Endif

If !Empty(goapp.ose) Then
Else
	Do Case
	Case goapp.tipoh=='B'
		lsURL   = "https://e-beta.sunat.gob.pe/ol-ti-itemision-guia-gem-beta/billService"
		ls_ruc_emisor=fe_gene.nruc
		ls_pwd_sol = 'moddatos'
		ls_user = ls_ruc_emisor + 'MODDATOS'
	Case goapp.tipoh=='H'
		lsURL   = "https://e-guiaremision.sunat.gob.pe/ol-ti-itemision-guia-gem/billService"
		ls_ruc_emisor=fe_gene.nruc
		ls_pwd_sol = Alltrim(fe_gene.gene_csol)
		ls_user = ls_ruc_emisor + Alltrim(fe_gene.gene_usol)
	Case goapp.tipoh='P'
		lsURL  =  "https://e-guiaremision.sunat.gob.pe/ol-ti-itemision-guia-gem/billService"
		lsURL  =  "https://e-guiaremision.sunat.gob.pe/ol-ti-itemision-guia-gem/billService?wsdl"
		ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
		ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
		ls_user = ls_ruc_emisor + Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
	Otherwise
		lsURL   = "https://e-guiaremision.sunat.gob.pe/ol-ti-itemision-guia-gem/billService"
		ls_ruc_emisor=Iif(Type("oempresa")="U",fe_gene.nruc,oempresa.nruc)
		ls_pwd_sol = Iif(Type("oempresa")="U",Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
		ls_user = ls_ruc_emisor + Iif(Type("oempresa")="U",Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
	Endcase
Endif
npos=At('.',goapp.carchivo)
carchivozip=Substr(goapp.carchivo,1,npos-1)
ps_fileZip = carchivozip+'.zip'
ls_fileName = Justfname(ps_fileZip)
ls_contentFile = Filetostr(ps_fileZip)
crespuesta=ls_fileName
ls_base64 = Strconv(ls_contentFile, 13) && Encoding base 64
TEXT TO ls_envioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
ENDTEXT
oXMLHttp=Createobject("MSXML2.ServerXMLHTTP.6.0")
oXMLBody=Createobject('MSXML2.DOMDocument.6.0')
If !(oXMLBody.LoadXML(ls_envioXML)) Then
	oResp.mensaje = "No se cargo XML: " + oXMLBody.parseError.reason
	Return 0
Endif
oXMLHttp.Open('POST', lsURL, .F.)
oXMLHttp.setRequestHeader( "Content-Type", "text/xml" )
oXMLHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8" )
oXMLHttp.setRequestHeader( "Content-Length", Len(ls_envioXML))
oXMLHttp.setRequestHeader( "SOAPAction" , "sendBill" )
oXMLHttp.setOption(2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS)
oXMLHttp.Send(oXMLBody.documentElement.XML)
If (oXMLHttp.Status <> 200) Then
	Messagebox('Estado ' + Alltrim(Str(oXMLHttp.Status)) + '-' + Nvl(oXMLHttp.responseText,''),16,MSGTITULO)
	Return 0
Endif
loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
loXMLResp.LoadXML(oXMLHttp.responseText)
CmensajeError=leerXMl(Alltrim(oXMLHttp.responseText),"<faultcode>","</faultcode>")
CMensajeMensaje=leerXMl(Alltrim(oXMLHttp.responseText),"<faultstring>","</faultstring>")
CMensajeMensaje=leerXMl(Alltrim(oXMLHttp.responseText),"<faultstring>","</faultstring>")
CMensajedetalle=leerXMl(Alltrim(oXMLHttp.responseText),"<detail>","</detail>")
If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Then
	Messagebox((Alltrim(CmensajeError)+' '+Alltrim(CMensajeMensaje)+' '+Alltrim(CMensajedetalle)),16,'Sisven')
	Return 0
Endif
*Messagebox(oXMLHttp.responseText,16,'Sisven')
ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
ArchivoRespuestaSunat.LoadXML(oXMLHttp.responseText)			&&Llenamos el archivo de respuesta
TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//applicationResponse")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
If Type('oempresa')='U' Then
	cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+crespuesta
	cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'
Else
	cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+Alltrim(oempresa.nruc)+"\"+crespuesta
	cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"
Endif
decodefile(TxtB64.Text,cnombre)
oShell = Createobject("Shell.Application")
cfilerpta="R"
For Each oArchi In oShell.NameSpace(cnombre).Items
	If Left(oArchi.Name,1)='R' Then
		oShell.NameSpace(cDirDesti).CopyHere(oArchi)
		cfilerpta=Juststem(oArchi.Name)+'.XML'
	Endif
Endfor
If Type('oempresa')='U' Then
	rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+cfilerpta)
	cfilecdr=Sys(5)+Sys(2003)+'\SunatXML\'+cfilerpta
Else
	rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"+cfilerpta)
	cfilecdr=Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"+cfilerpta
Endif
If Len(Alltrim(rptaSunat))<=100 Then
	GuardaPkGuia(pk,crptahash,cfilecdr)
Else
	Messagebox(rptaSunat,64,'Sisven')
	Return 0
Endif
Do Case
Case Left(rptaSunat,1)='0'
	mensaje(rptaSunat)
	Return 1
Case Empty(rptaSunat)
	Messagebox(rptaSunat,64,'Sisven')
	Return 5000
Otherwise
	Messagebox(rptaSunat,64,'Sisven')
	Return 0
Endcase
Endproc
**************************
Procedure GuardaPkGuia(np1,np2,np3)
cpropiedad="Grabarxmlbd"
If !Pemstatus(goapp,cpropiedad,5)
	goapp.AddProperty("Grabarxmlbd","")
Endif
ncon=Abreconexion()
dfenvio=Datetime()
carchivo=goapp.carchivo
crptaSunat=LeerRespuestaSunat(np3)
If goapp.Grabarxmlbd='S' Then
	cxml=Filetostr(carchivo)
	cdrxml=Filetostr(np3)
	TEXT  TO lc noshow
       UPDATE fe_guias SET guia_hash=?np2,guia_mens=?crptaSunat,guia_arch=?carchivo,guia_feen=?dfenvio,guia_xml=?cxml,guia_cdr=?cdrxml WHERE guia_idgui=?np1
	ENDTEXT
Else
	TEXT  TO lc noshow
       UPDATE fe_guias SET guia_hash=?np2,guia_mens=?crptaSunat,guia_arch=?carchivo,guia_feen=?dfenvio WHERE guia_idgui=?np1
	ENDTEXT
Endif
If SQLExec(ncon,lc)<0 Then
	errorbd(lc)
	Return 0
Endif
CierraConexion(ncon)
Return 1
Endproc
***************************
Procedure GuardaPkXMLGuia(np1,np2,np3)
cpropiedad="Grabarxmlbd"
If !Pemstatus(goapp,cpropiedad,5)
	goapp.AddProperty("Grabarxmlbd","")
Endif
ncon=Abreconexion()
carchivo=goapp.carchivo
cxml=Filetostr(carchivo)
If goapp.Grabarxmlbd='S' Then
	TEXT  TO lc noshow
         UPDATE fe_guias SET guia_hash=?np2,guia_arch=?carchivo,guia_xml=?cxml WHERE guia_idgui=?np1
	ENDTEXT
Else
	TEXT  TO lc noshow
         UPDATE fe_guias SET guia_hash=?np2,guia_arch=?carchivo WHERE guia_idgui=?np1
	ENDTEXT
Endif
If SQLExec(ncon,lc)<0 Then
	errorbd(lc)
	Return 0
Endif
CierraConexion(ncon)
Return 1
Endproc
*********************************************
Function INGRESAKARDEXIcbper(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11)
cur="nidk"
lc="FunIngresaKardexIcbper"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
goapp.npara11=np11
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' '+' Ingresando KARDEX  con ICBPER')
	Return 0
Else
	Return nidk.Id
Endif
Endfunc
*******************************************
Function IngresaResumenDctoVtasIcbper(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23)
lc='FunIngresaCabeceravtasicbper'
cur="Xn"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
goapp.npara11=np11
goapp.npara12=np12
goapp.npara13=np13
goapp.npara14=np14
goapp.npara15=np15
goapp.npara16=np16
goapp.npara17=np17
goapp.npara18=np18
goapp.npara19=np19
goapp.npara20=np20
goapp.npara21=np21
goapp.npara22=np22
goapp.npara23=np23
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Ingresando Cabecera de Documento')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
******************************************
Function ActualizaResumenDctovtasIcbper(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24)
lc='ProActualizaCabeceraCVtasicbper'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
goapp.npara11=np11
goapp.npara12=np12
goapp.npara13=np13
goapp.npara14=np14
goapp.npara15=np15
goapp.npara16=np16
goapp.npara17=np17
goapp.npara18=np18
goapp.npara19=np19
goapp.npara20=np20
goapp.npara21=np21
goapp.npara22=np22
goapp.npara23=np23
goapp.npara24=np24
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Actualizando Cabecera de Documento de Ventas ICBPER')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function INGRESAKARDEXUMICBPER(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17)
Local cur As String
lc='FunIngresaKardexICBPERUM'
cur="kardexu"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
goapp.npara11=np11
goapp.npara12=np12
goapp.npara13=np13
goapp.npara14=np14
goapp.npara15=np15
goapp.npara16=np16
goapp.npara17=np17
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Kardex x Unidades')
	Return 0
Else
	Return kardexu.Id
Endif
Endfunc
********************************
Function ActualizaKardexICBPER(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13)
Local cur As String
lc='ProActualizaKardexICBPER'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
goapp.npara11=np11
goapp.npara12=np12
goapp.npara13=np13
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Kardex x Unidades')
	Return 0
Else
	Return 1
Endif
Endfunc
************************************
Function ActualizaKardexICBPERUM(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19)
Local cur As String
lc='ProActualizaKardexICBPERUM'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
goapp.npara10=np10
goapp.npara11=np11
goapp.npara12=np12
goapp.npara13=np13
goapp.npara14=np14
goapp.npara15=np15
goapp.npara16=np16
goapp.npara17=np17
goapp.npara18=np18
goapp.npara19=np19
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Actualizando Kardex ')
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
Case np1=1
	goapp.Form("ka_rxf1")
Case np1=2
	goapp.Form("ka_rxguias")
Endcase
Endproc
*********************************
Function ObtenerCDRSUNAT()
Lparameters LcRucEmisor,lcUser_Sol,lcPswd_Sol,ctipodcto,cserie,cnumero,pk

Declare Integer CryptBinaryToString In Crypt32;
	STRING @pbBinary, Long cbBinary, Long dwFlags,;
	STRING @pszString, Long @pcchString

Declare Integer CryptStringToBinary In crypt32;
	STRING @pszString, Long cchString, Long dwFlags,;
	STRING @pbBinary, Long @pcbBinary,;
	LONG pdwSkip, Long pdwFlags

#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056


lcUserName = LcRucEmisor + lcUser_Sol
lcURL   = "https://e-factura.sunat.gob.pe/ol-it-wsconscpegem/billConsultService"
TEXT TO lcEnvioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
ENDTEXT

If Not loXMLBody.LoadXML( lcEnvioXML )
	Error loXMLBody.parseError.reason
	Return -1
Endif

loXmlHttp.Open( "POST", lcURL, .F. )
loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=utf-8" )
loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
loXmlHttp.setRequestHeader( "SOAPAction" , "getStatusCdr" )
loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )

loXmlHttp.Send(loXMLBody.documentElement.XML)
*?loXmlHttp.Status
If loXmlHttp.Status # 200 Then
	cerror=Nvl(loXmlHttp.responseText,'')
	crpta=Strextract(cerror, '<faultstring>', '</faultstring>',1)
	Messagebox(crpta,16,MSGTITULO)
	Return -1
Endif
res = Createobject("MSXML2.DOMDocument.6.0")
res.LoadXML(loXmlHttp.responseText)
CmensajeError=leerXMl(Alltrim(res.responseText),"<faultcode>","</faultcode>")
CMensajeMensaje=leerXMl(Alltrim(res.responseText),"<faultstring>","</faultstring>")
CMensajeMensaje=leerXMl(Alltrim(res.responseText),"<faultstring>","</faultstring>")
CMensajedetalle=leerXMl(Alltrim(res.responseText),"<detail>","</detail>")
If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Then
	Messagebox((Alltrim(CmensajeError)+' '+Alltrim(CMensajeMensaje)+' '+Alltrim(CMensajedetalle)),16,'Sisven')
	Return 0
Endif
txtCod = res.selectSingleNode("//statusCode")  &&Return
txtMsg = res.selectSingleNode("//statusMessage")  &&Return
If txtCod.Text<>"0004"  Then
	mensaje(txtMsg.Text)
	Return  -1
Endif
ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
ArchivoRespuestaSunat.LoadXML(oXMLHttp.responseText)			&&Llenamos el archivo de respuesta
TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//content")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
If Type('oempresa')='U' Then
	cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+crespuesta
	cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'
Else
	cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+Alltrim(oempresa.nruc)+"\"+crespuesta
	cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"
Endif
decodefile(TxtB64.Text,cnombre)
oShell = Createobject("Shell.Application")
cfilerpta="R"
For Each oArchi In oShell.NameSpace(cnombre).Items
	If Left(oArchi.Name,1)='R' Then
		oShell.NameSpace(cDirDesti).CopyHere(oArchi)
		cfilerpta=Juststem(oArchi.Name)+'.XML'
	Endif
Endfor
If Type('oempresa')='U' Then
	rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+cfilerpta)
	cfilecdr=Sys(5)+Sys(2003)+'\SunatXML\'+cfilerpta
Else
	rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"+cfilerpta)
	cfilecdr=Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"+cfilerpta
Endif
Do Case
Case Left(rptaSunat,1)='0'
	If goapp.Grabarxmlbd='S' Then
		cdrxml=Filetostr(cfilecdr)
		TEXT  TO lc noshow
         UPDATE fe_rcom SET rcom_mens=?rptaSunat,rcom_fecd=?dfenvio,rcom_cdr=?cdrxml WHERE idauto=?pk
		ENDTEXT
	Else
		TEXT  TO lc noshow
         UPDATE fe_rcom SET rcom_mens=?rptaSunat,rcom_fecd=?dfenvio WHERE idauto=?pk
		ENDTEXT
	Endif
	If SQLExec(goapp.bdconn,lc)<0 Then
		errorbd(lc)
		Return 0
	Endif
	mensaje(rptaSunat)
	Return 1
Case Empty(rptaSunat)
	Messagebox(rptaSunat,64,'Sisven')
	Return 5000
Otherwise
	Messagebox(rptaSunat,64,'Sisven')
	Return 0
Endcase
Endproc
******************************************
Function  EnviarBoletasyNotas
Lparameters df
datosGlobales()
Set Classlib To c:\librerias\fe.vcx Additive
ocomp=Createobject("comprobante")
TEXT TO lc NOSHOW
		select fech,tdoc,
		left(ndoc,4) as serie,substr(ndoc,5) as numero,If(Length(trim(c.ndni))<8,'0','1') as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,"" as trefe,"" as serieref,"" as numerorefe,f.idauto
		fROM fe_rcom f inner join fe_clie c on c.idclie=f.idcliente where tdoc="03" and fech=?df and acti='A' and idcliente>0 and LEFT(ndoc,1)='B'
		union all
		select f.fech,f.tdoc,
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto inner join fe_rcom as w on w.idauto=g.ncre_idau
        inner join fe_clie c on c.idclie=f.idcliente
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech=?df
		union all
		select f.fech,f.tdoc,
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',ndni) as ndni,
        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto inner join fe_rcom as w on w.idauto=g.ncre_idau
        inner join fe_clie c on c.idclie=f.idcliente
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech=?df
ENDTEXT
dfecha=Date()
If SQLExec(goapp.bdconn,lc,"rboletas")<0 Then
	errorbd(lc)
	Return 0
Endif
TEXT TO lcx NOSHOW
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo
		from(select
		left(ndoc,4) as serie,substr(ndoc,5) as numero,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,tdoc
		fROM fe_rcom f where tdoc="03" and fech=?df and acti='A' and idcliente>0 order by ndoc) as x  group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo from(select
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto inner join fe_rcom as w on w.idauto=g.ncre_idau
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech=?df order by f.ndoc) as x group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo  from(select
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto inner join fe_rcom as w on w.idauto=g.ncre_idau
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech=?df order by f.ndoc) as x group by serie
ENDTEXT
If SQLExec(goapp.bdconn,lcx,"rb1")<0 Then
	errorbd(lc)
	Return 0
Endif

Select tdoc,serie,desde,hasta,valor,Exon,;
	000000.00 As inafectas,igv,Impo,0.00 As gratificaciones,df As fech;
	FROM rb1 Into Cursor curb


Select fech,tdoc,serie,numero,tipodoc,ndni,valor,rcom_exon As Exon,;
	000000.00 As inafectas,igv,Impo,0.00 As gratificaciones,trefe,serieref,numerorefe,idauto;
	FROM rboletas Into Cursor crb


Select crb
ocomp.itemsdocumentos=Reccount()
tr=ocomp.itemsdocumentos
If tr=0 Then
	Return 0
Endif
ocomp.fechadocumentos=Alltrim(Str(Year(df)))+'-'+Iif(Month(df)<=9,'0'+Alltrim(Str(Month(df))),Alltrim(Str(Month(df))))+'-'+Iif(Day(df)<=9,'0'+Alltrim(Str(Day(df))),Alltrim(Str(Day(df))))
cnombreArchivo=Alltrim(Str(Year(dfecha)))+Iif(Month(dfecha)<=9,'0'+Alltrim(Str(Month(dfecha))),Alltrim(Str(Month(dfecha))))+Iif(Day(dfecha)<=9,'0'+Alltrim(Str(Day(dfecha))),Alltrim(Str(Day(dfecha))))
ocomp.Moneda='PEN'
ocomp.tigv='10'
ocomp.vigv='18'
ocomp.fechaemision=Alltrim(Str(Year(dfecha)))+'-'+Iif(Month(dfecha)<=9,'0'+Alltrim(Str(Month(dfecha))),Alltrim(Str(Month(dfecha))))+'-'+Iif(Day(dfecha)<=9,'0'+Alltrim(Str(Day(dfecha))),Alltrim(Str(Day(dfecha))))
ocomp.rucfirma=fe_gene.rucfirmad
ocomp.nombrefirmadigital=fe_gene.razonfirmad
ocomp.rucemisor=fe_gene.nruc
ocomp.razonsocialempresa=fe_gene.empresa
ocomp.ubigeo=fe_gene.ubigeo
ocomp.direccionempresa=fe_gene.ptop
ocomp.ciudademisor=fe_gene.ciudad
ocomp.distritoemisor=fe_gene.distrito
ocomp.pais='PE'
Dimension ocomp.itemsfacturas[tr,16]
i=0
ta=1
Select crb
Scan All
	i=i+1
	ocomp.itemsfacturas[i,1]=crb.tdoc
	ocomp.itemsfacturas[i,2]=Alltrim(crb.serie)+'-'+Alltrim(Str(Val(crb.numero)))
	ocomp.itemsfacturas[i,3]=Alltrim(crb.ndni)
	ocomp.itemsfacturas[i,4]=crb.tipodoc
	ocomp.itemsfacturas[i,5]=crb.trefe
	ocomp.itemsfacturas[i,6]=Alltrim(crb.serieref)+'-'+Alltrim(crb.numerorefe)
	ocomp.itemsfacturas[i,7]=Alltrim(Str(crb.Impo,12,2))
	ocomp.itemsfacturas[i,8]=Alltrim(Str(crb.valor,12,2))
	ocomp.itemsfacturas[i,9]=Alltrim(Str(crb.Exon,12,2))
	ocomp.itemsfacturas[i,10]=Alltrim(Str(crb.inafectas,12,2))
	ocomp.itemsfacturas[i,11]="0.00"
	ocomp.itemsfacturas[i,12]="0.00"
	ocomp.itemsfacturas[i,13]=Alltrim(Str(crb.igv,12,2))
	ocomp.itemsfacturas[i,14]="0.00"
	ocomp.itemsfacturas[i,15]="0.00"
	ocomp.itemsfacturas[i,16]=Alltrim(Str(crb.gratificaciones,12,2))
Endscan

cpropiedad="Firmarcondll"
If !Pemstatus(goapp,cpropiedad,5)
	goapp.AddProperty("Firmarcondll","")
Endif
ocomp.FirmarconDLL=goapp.FirmarconDLL
cserie=cnombreArchivo+"-"+Alltrim(Str(fe_gene.gene_nres))
If ocomp.generaxmlrboletas(fe_gene.nruc,cserie)=1 Then
	generaCorrelativoEnvioResumenBoletas()
Else
	Return 0
Endif
If !Empty(goapp.ticket) Then
	Do While .T.
		nr=ConsultaTicket(Alltrim(goapp.ticket),goapp.carchivo)
		If nr>=0 Then
			Exit
		Endif
	Enddo
	v=1
	If nr=1 Then
		Select crb
		Go Top
		Scan All
			np1=crb.idauto
			dfenvio=fe_gene.fech
			np3="0 El Resumen de Boletas ha sido aceptada"
			TEXT TO lc noshow
                    UPDATE fe_rcom SET rcom_mens=?np3,rcom_fecd=?dfenvio WHERE idauto=?np1
			ENDTEXT
			If SQLExec(goapp.bdconn,lc)<0 Then
				errorbd(lc)
				v=0
				Exit
			Endif
		Endscan
	Endif
Else
	v=0
Endif
Return v
Endfunc
*****************************************
Function Enviarboletasynotasautomatico(ccursor)
Try
	Select (ccursor)
	Scan All
		EnviarBoletasyNotas(rbxe.resu_fech)
	Endscan
Catch To oerr When oerr.ErrorNo=1429
	Messagebox(MENSAJE1+MENSAJE2+MENSAJE3,16,MSGTITULO)
Catch To oerr When oerr.ErrorNo=1924
	Messagebox(MENSAJE1+MENSAJE2+MENSAJE3,16,MSGTITULO)
Finally
Endtry
Endfunc
************************************
Function ActualizaResumenBoletasCDR(np1,np2,np3)
cur=[]
lc="ProactualizaResumenBoletas"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Actualizando Respuesta de Sunat')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************
Function ActualizaResumenBajasCDR(np1,np2,np3)
cur=[]
lc="ProactualizaRBajas"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' '+' Actualizando Respuesta de Sunat')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************************
Procedure ObtenerCDRGuia
Lparameters LcRucEmisor,lcUser_Sol,lcPswd_Sol,ctipodcto,cserie,cnumero,pk

Declare Integer CryptBinaryToString In Crypt32;
	STRING @pbBinary, Long cbBinary, Long dwFlags,;
	STRING @pszString, Long @pcchString

Declare Integer CryptStringToBinary In crypt32;
	STRING @pszString, Long cchString, Long dwFlags,;
	STRING @pbBinary, Long @pcbBinary,;
	LONG pdwSkip, Long pdwFlags

#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056
cpropiedad="ose"
If !Pemstatus(goapp,cpropiedad,5)
	goapp.AddProperty("ose","")
Endif
loXmlHttp = Createobject("MSXML2.ServerXMLHTTP.6.0")
loXMLBody = Createobject("MSXML2.DOMDocument.6.0")
crespuesta=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)+'-'+ctipodcto+'-'+cserie+'-'+cnumero+'.zip'
lsURL  =  "https://e-factura.sunat.gob.pe/ol-it-wsconscpegem/billConsultService"
ls_ruc_emisor=Iif(Type('oempresa')='U',fe_gene.nruc,oempresa.nruc)
ls_pwd_sol = Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_csol),Alltrim(oempresa.gene_csol))
ls_user = ls_ruc_emisor + Iif(Type('oempresa')='U',Alltrim(fe_gene.gene_usol),Alltrim(oempresa.gene_usol))
TEXT TO lcEnvioXML TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
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
ENDTEXT
If Not loXMLBody.LoadXML( lcEnvioXML )
	Error loXMLBody.parseError.reason
	Return -1
Endif
loXmlHttp.Open( "POST", lsURL, .F. )
loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
loXmlHttp.setRequestHeader( "SOAPAction" , "getStatusCdr" )
loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
loXmlHttp.Send(loXMLBody.documentElement.XML)
If loXmlHttp.Status # 200 Then
	cerror=Nvl(loXmlHttp.responseText,'')
	crpta=Strextract(cerror, '<faultstring>', '</faultstring>',1)
	CMensaje1=Strextract(cerror, "<message>","</message>",1)
	Messagebox(crpta+' '+Alltrim(CMensaje1),16,MSGTITULO)
	Return -1
Endif
loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
loXMLResp.LoadXML(loXmlHttp.responseText)
CmensajeError=leerXMl(Alltrim(loXmlHttp.responseText),"<faultcode>","</faultcode>")
CMensajeMensaje=leerXMl(Alltrim(loXmlHttp.responseText),"<faultstring>","</faultstring>")
CMensajedetalle=leerXMl(Alltrim(loXmlHttp.responseText),"<detail>","</detail>")
Cnumeromensaje=leerXMl(Alltrim(loXmlHttp.responseText),"<statusCode>","</statusCode>")
CMensaje1=leerXMl(Alltrim(loXmlHttp.responseText),"<message>","</message>")
If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Or Cnumeromensaje<>'0' Then
	Messagebox((Alltrim(CmensajeError)+' '+Alltrim(CMensajeMensaje)+' '+Alltrim(CMensajedetalle)+' '+Alltrim(CMensaje1)),16,'Sisven')
	Return 0
Endif
ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
txtCod = loXMLResp.selectSingleNode("//statusCode")  &&Return
txtMsg = loXMLResp.selectSingleNode("//statusMessage")  &&Return
If txtCod.Text<>"0004"  Then
	mensaje(txtMsg.Text)
	Return  -1
Endif
TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//content")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
If Type('oempresa')='U' Then
	cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+crespuesta
	cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'
Else
	cnombre=Sys(5)+Sys(2003)+'\SunatXml\'+Alltrim(oempresa.nruc)+"\"+crespuesta
	cDirDesti = Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"
Endif
decodefile(TxtB64.Text,cnombre)
oShell = Createobject("Shell.Application")
cfilerpta="R"
For Each oArchi In oShell.NameSpace(cnombre).Items
	If Left(oArchi.Name,1)='R' Then
		oShell.NameSpace(cDirDesti).CopyHere(oArchi)
		cfilerpta=Juststem(oArchi.Name)+'.XML'
	Endif
Endfor
If Type('oempresa')='U' Then
	rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+cfilerpta)
	cfilecdr=Sys(5)+Sys(2003)+'\SunatXML\'+cfilerpta
Else
	rptaSunat=LeerRespuestaSunat(Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"+cfilerpta)
	cfilecdr=Sys(5)+Sys(2003)+'\SunatXML\'+Alltrim(oempresa.nruc)+"\"+cfilerpta
Endif
Do Case
Case Left(rptaSunat,1)='0'
	mensaje(rptaSunat)
   If goapp.Grabarxmlbd='S' Then
		cdrxml=Filetostr(cfilecdr)
		TEXT  TO lc noshow
           UPDATE fe_guias SET guia_mens=?rptaSunat,guia_cdr=?cdrxml WHERE guia_idgui=?pk
		ENDTEXT
	Else
		TEXT  TO lc noshow
          UPDATE fe_guias SET guia_mens=?rptaSunat WHERE guia_idgui=?pk
		ENDTEXT
	Endif
	If SQLExec(goapp.bdconn,lc)<0 Then
		errorbd(lc)
		Return 0
	Endif
	Return 1
Case Empty(rptaSunat)
	Messagebox(rptaSunat,64,'Sisven')
	Return 0
Otherwise
	Messagebox(rptaSunat,64,'Sisven')
	Return 0
Endcase
Endproc




