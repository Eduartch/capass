#Define ERRORPROC "NO SE EJECUTO CORRECTAMENTE EL PROCEDIMIENTO"
#Define MSGTITULO "SISVEN-EtCh"
*******************************
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
Set ENGINEBEHAVIOR 70
Endproc
*******************************
Function N2L(tnNro, tnFlag)
If Empty(tnFlag)
	tnFlag = 0
Endif
Local lnEntero, lcRetorno, lnTerna, lcMiles, ;
	lcCadena, lnUnidades, lnDecenas, lnCentenas
lnEntero = Int(tnNro)
lcRetorno = ''
lnTerna = 1
Do While lnEntero > 0
	lcCadena = ''
	lnUnidades = Mod(lnEntero, 10)
	lnEntero = Int(lnEntero / 10)
	lnDecenas = Mod(lnEntero, 10)
	lnEntero = Int(lnEntero / 10)
	lnCentenas = Mod(lnEntero, 10)
	lnEntero = Int(lnEntero / 10)

*--- Analizo la terna
	Do Case
	Case lnTerna = 1
		lcMiles = ''
	Case lnTerna = 2 And (lnUnidades + lnDecenas + lnCentenas # 0)
		lcMiles = 'MIL '
	Case lnTerna = 3 And (lnUnidades + lnDecenas + lnCentenas # 0)
		lcMiles = Iif(lnUnidades = 1 And lnDecenas = 0 And ;
			lnCentenas = 0, 'MILLON ', 'MILLONES ')
	Case lnTerna = 4 And (lnUnidades + lnDecenas + lnCentenas # 0)
		lcMiles = 'MIL MILLONES '
	Case lnTerna = 5 And (lnUnidades + lnDecenas + lnCentenas # 0)
		lcMiles = Iif(lnUnidades = 1 And lnDecenas = 0 And ;
			lnCentenas = 0, 'BILLON ', 'BILLONES ')
	Case lnTerna > 5
		lcRetorno = ' ERROR: NUMERO DEMASIADO GRANDE '
		Exit
	Endcase

*--- Analizo las unidades
	Do Case
	Case lnUnidades = 1
		lcCadena = Iif(lnTerna = 1 And tnFlag = 0, 'UNO ', 'UN ')
	Case lnUnidades = 2
		lcCadena = 'DOS '
	Case lnUnidades = 3
		lcCadena = 'TRES '
	Case lnUnidades = 4
		lcCadena = 'CUATRO '
	Case lnUnidades = 5
		lcCadena = 'CINCO '
	Case lnUnidades = 6
		lcCadena = 'SEIS '
	Case lnUnidades = 7
		lcCadena = 'SIETE '
	Case lnUnidades = 8
		lcCadena = 'OCHO '
	Case lnUnidades = 9
		lcCadena = 'NUEVE '
	Endcase

*--- Analizo las decenas
	Do Case
	Case lnDecenas = 1
		Do Case
		Case lnUnidades = 0
			lcCadena = 'DIEZ '
		Case lnUnidades = 1
			lcCadena = 'ONCE '
		Case lnUnidades = 2
			lcCadena = 'DOCE '
		Case lnUnidades = 3
			lcCadena = 'TRECE '
		Case lnUnidades = 4
			lcCadena = 'CATORCE '
		Case lnUnidades = 5
			lcCadena = 'QUINCE '
		Other
			lcCadena = 'DIECI' + lcCadena
		Endcase
	Case lnDecenas = 2
		lcCadena = Iif(lnUnidades = 0, 'VEINTE ', 'VEINTI') + lcCadena
	Case lnDecenas = 3
		lcCadena = 'TREINTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Case lnDecenas = 4
		lcCadena = 'CUARENTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Case lnDecenas = 5
		lcCadena = 'CINCUENTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Case lnDecenas = 6
		lcCadena = 'SESENTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Case lnDecenas = 7
		lcCadena = 'SETENTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Case lnDecenas = 8
		lcCadena = 'OCHENTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Case lnDecenas = 9
		lcCadena = 'NOVENTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Endcase

*--- Analizo las centenas
	Do Case
	Case lnCentenas = 1
		lcCadena = Iif(lnUnidades = 0 And lnDecenas = 0, ;
			'CIEN ', 'CIENTO ') + lcCadena
	Case lnCentenas = 2
		lcCadena = 'DOSCIENTOS ' + lcCadena
	Case lnCentenas = 3
		lcCadena = 'TRESCIENTOS ' + lcCadena
	Case lnCentenas = 4
		lcCadena = 'CUATROCIENTOS ' + lcCadena
	Case lnCentenas = 5
		lcCadena = 'QUINIENTOS ' + lcCadena
	Case lnCentenas = 6
		lcCadena = 'SEISCIENTOS ' + lcCadena
	Case lnCentenas = 7
		lcCadena = 'SETECIENTOS ' + lcCadena
	Case lnCentenas = 8
		lcCadena = 'OCHOCIENTOS ' + lcCadena
	Case lnCentenas = 9
		lcCadena = 'NOVECIENTOS ' + lcCadena
	Endcase

*--- Armo el retorno terna a terna
	lcRetorno = lcCadena + lcMiles + lcRetorno
	lnTerna = lnTerna + 1
Enddo
If lnTerna = 1
	lcRetorno = 'CERO '
Endif
Return lcRetorno
Endfunc
*******************************
Procedure RemoteSPTCursor2RemoteView
Lparameters tcCursorAlias, tcTableName, tcPKFieldName, ;
	tnBuffering, tnWhereType, tlExcludePK
*
* propiedades de actualización - UpdateNameList y
* UpdatableFieldList, igual que una vista remota
*
Local lnSelect, lcUpdatableFieldList, lcUpdateNameList, ;
	lcField, xx, lnCount, llSuccess
lcUpdatableFieldList = Space(0)
lcUpdateNameList = Space(0)
lcField = Space(0)
lnSelect = Select(0)
lnCount = 0
Select (tcCursorAlias)
*
* añadir cada campo al UpdateNameList y
* las propiedades UpdatableFieldList
*
For xx = 1 To Fcount()
	lcField = Upper(Alltrim(Field(xx)))
	lnCount = lnCount + 1
	lcUpdatableFieldList = lcUpdatableFieldList + ;
		IIF(lnCount=1,Space(0),",") + lcField
	lcUpdateNameList = lcUpdateNameList + ;
		IIF(lnCount=1,Space(0),",") + lcField + ;
		SPACE(1) + tcTableName + "." + lcField
Endfor
If tlExcludePK
*
* Cuando las PKs no deben ser generadas a mano
* (como cuando el PK es una columna Identity),
* el campo PK tiene que ser quitado del
* UpdatableFieldList para prevenir un TableUpdate()
* e intentar actualizar el campo PK, que
* causaría un crash
*
*  ... por cualquier razón, el campo de PK
*  debe permanecer en el UpdateNameList...
*
	lcUpdatableFieldList = "," + Alltrim(lcUpdatableFieldList) + ","
	lcUpdatableFieldList = Strtran(lcUpdatableFieldList, ;
		"," + Upper(tcPKFieldName) + "," , ",")
*
* asegurar que no dejamos una coma durante
* el principio o el final de la cadena
*
	If Leftc(lcUpdatableFieldList,1) = ","
		lcUpdatableFieldList = Substrc(lcUpdatableFieldList,2)
	Endif
	If Rightc(lcUpdatableFieldList,1) = ","
		lcUpdatableFieldList = Leftc(lcUpdatableFieldList,Lenc(lcUpdatableFieldList)-1)
	Endif
Endif
llSuccess = .F.
Do Case
Case Not CursorSetProp("KeyFieldList",tcPKFieldName)
	Assert .F. Message Program() + " no se puede configurar KeyFieldList"
Case Not CursorSetProp("Tables",tcTableName)
	Assert .F. Message Program() + " no se puede configurar Tables"
Case Not CursorSetProp("UpdatableFieldList",lcUpdatableFieldList)
	Assert .F. Message Program() + " no se puede configurar UpdatableFieldList"
Case Not CursorSetProp("UpdateNameList",lcUpdateNameList)
	Assert .F. Message Program() + " no se puede configurar UpdateNameList"
Case Not CursorSetProp("WhereType", ;
		IIF(Vartype(tnWhereType)="N",tnWhereType,3))
	Assert .F. Message Program() + " no se puede configurar WhereType"
Case Not CursorSetProp("Buffering", ;
		IIF(Vartype(tnBuffering)="N",tnBuffering,3))
	Assert .F. Message Program() + " no se puede configurar Buffering"
Case Not CursorSetProp("SendUpdates",.T.)
	Assert .F. Message Program() + " no se puede configurar SendUpdates"
Otherwise
	llSuccess = .T.
Endcase
Select (lnSelect)
Return llSuccess
Endproc
*******************************
Function Cmes(dFecha)
If Type('dFecha') # 'D'	Or Empty(dFecha)
	Return ''
Endif
Local cDevuelve
Store '' To cDevuelve
Dimension aMeses(12)
aMeses(1) = 'Enero'
aMeses(2) = 'Febrero'
aMeses(3) = 'Marzo'
aMeses(4) = 'Abril'
aMeses(5) = 'Mayo'
aMeses(6) = 'Junio'
aMeses(7) = 'Julio'
aMeses(8) = 'Agosto'
aMeses(9) = 'Septiembre'
aMeses(10) = 'Octubre'
aMeses(11) = 'Noviembre'
aMeses(12) = 'Diciembre'
cDevuelve = aMeses(Month(dFecha))
Return cDevuelve
Endfunc
*******************************
Function Cmes1(nmes)
If Type('nmes') # 'N'	Or (nmes<1 And nmes>12)
	Return ''
Endif
Local cDevuelve
Store '' To cDevuelve
Dimension aMeses(12)
aMeses(1) = 'Enero       '
aMeses(2) = 'Febrero     '
aMeses(3) = 'Marzo       '
aMeses(4) = 'Abril       '
aMeses(5) = 'Mayo        '
aMeses(6) = 'Junio       '
aMeses(7) = 'Julio       '
aMeses(8) = 'Agosto      '
aMeses(9) = 'Septiembre  '
aMeses(10) = 'Octubre    '
aMeses(11) = 'Noviembre  '
aMeses(12) = 'Diciembre  '
cDevuelve = aMeses(nmes)
Return cDevuelve
Endfunc
**************************
Function preguntaguardar()
Local r As Integer
r=Messagebox("¿Datos Ok [S/N]?",32+3+0,"Sisven")
Return r
Endfunc
************************************
Function REGDVTO(CALIAS)
Select (CALIAS)
If Reccount()=0
	Return 0
Else
	Return 1
Endif
Endfunc
*************************************
Function esFechaValida(dFecha)
Local tnAnio, tnMes, tnDia
tnAnio=Year(dFecha)
tnMes=Month(dFecha)
tnDia=Day(dFecha)
Return ;
	VARTYPE(tnAnio) = "N" And ;
	VARTYPE(tnMes) = "N" And ;
	VARTYPE(tnDia) = "N" And ;
	BETWEEN(tnAnio, 100, 9999) And ;
	BETWEEN(tnMes, 1, 12) And ;
	BETWEEN(tnDia, 1, 31) And ;
	NOT Empty(Date(tnAnio, tnMes, tnDia))
Endfunc
*******************************************
Function VerificaAlias(CALIAS)
If Used((CALIAS)) Then
	Return 1
Else
	Return 0
Endif
Endfunc
*******************************************
Procedure CierraCursor(CALIAS)
Use In(Select((CALIAS)))
Endproc
*******************************
Function IngresarNotasCreditoCompras(nid0,nid1,ideu)
If SQLExec(goapp.bdconn,"SELECT FUNINGRESANOTASCREDITOCOMPRAS(?nid0,?nid1,?ideu) as nid","xi")< 1 Then
	errorbd(ERRORPROC+' Ingresando Notas Credito Compras')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function PermiteIngresoCompras(cndoc,ctdoc,nidpr,nidauto,dFecha)
Local vd1,vd2,vd3 As Integer
If SQLExec(goapp.bdconn,"SELECT FUNHAYCOMPRA(?cndoc,?ctdoc,?nidpr,?nidauto) as nid","xi")< 1 Then
	errorbd(ERRORPROC+' Verificando Compras')
	vd1=0
Else
	If xi.nid=0 Then
		vd1= 1
	Else
		vd1= 0
	Endif
Endif
If Validadeuda(nidauto)=1 Then
	vd2=1
Else
	vd2=0
Endif
If vd1=1 And vd2=1 Then
	Return 1
Else
	Return 0
Endif
Endfunc
********************************
Function muestramenu(nid,ct)
If SQLExec(goapp.bdconn,"CALL PROMUESTRAMENU(?nid,?ct)","menus")< 1 Then
	errorbd(ERRORPROC+' Consultando Menus')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function MuestraVendedores(cb)
If SQLExec(goapp.bdconn,"CALL PROMUESTRAVENDEDORES(?cb)","lv")< 1 Then
	errorbd(ERRORPROC+' Consultando Vendedores')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************
Function MuestraAlmacenes()
If SQLExec(goapp.bdconn,"CALL PROMUESTRAALMACENES()","Almacenes")< 1 Then
	errorbd(ERRORPROC+' Consultando Almacenes')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************
Function MuestraDctos(cb)
If SQLExec(goapp.bdconn,"CALL PROMUESTRADCTOS(?cb)","dctosv") < 1
	errorbd(ERRORPROC+' Consultando Documentos')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************************
Function MuestraProveedores(cb,opt,nid)
If SQLExec(goapp.bdconn,"CALL PROMUESTRAPROVEEDOR(?cb,?opt,?nid)","proveedores")<1
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
*************************************
Function MuestraClientes(lw,opt,nid)
If SQLExec(goapp.bdconn,"CALL PROMUESTRACLIENTES(?LW,?opt,?nid)","clientes") < 1
	errorbd(ERRORPROC)
	Return 0
Else
	Return  1
Endif
Endfunc
*************************************
Function MuestraProductos(lw,nd)
If SQLExec(goapp.bdconn," CALL PROMUESTRAPRODUCTOS(?lw,?ND)", "productos") < 1
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
**************************************
Function MuestraGrupos(lw)
If SQLExec(goapp.bdconn,"CALL PROMUESTRAGRUPOS(?LW)","lgrupo") < 1
	errorbd(ERRORPROC)
	Return 0
Else
	Return  1
Endif
Endfunc
*****************************************
Function AnulaTransaccion(ctdoc,cndoc,ctipo,nauto,cu,ga,df,cu1)
If SQLExec(goapp.bdconn,"call proAnulaTransacciones(@estado,?ctdoc,?cndoc,?ctipo,?nauto,?cu,?ga,?df,?cu1)") < 1
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
******************************************
Function ACtualizaDeudas(nauto,nu)
If SQLExec(goapp.bdconn,"Call ProActualizaDeudas(?nauto,?nu)") < 1
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************************
Function EstadoCtaProveedor(opt,nidclie,cmoneda)
If opt=0 Then
	TEXT TO lc NOSHOW
          SELECT b.rdeu_idpr,a.fech as fepd,a.fevto as fevd,a.ndoc,b.rdeu_impc as impc,a.impo as impd,a.acta as actd,a.dola,
          a.tipo,a.banc,ifnull(c.ndoc,'0000000000') as docd,b.rdeu_mone as mond,a.estd,a.iddeu as nr,
          b.rdeu_idau as idauto,ifnull(c.tdoc,'00') as refe FROM fe_deu as a
          inner join fe_rdeu as b ON(b.rdeu_idrd=a.deud_idrd) left join fe_rcom as c ON(c.idauto=b.rdeu_idau)
          WHERE b.rdeu_idpr=?nidclie AND b.rdeu_mone=?cmoneda and a.acti<>'I' and b.rdeu_acti<>'I'  ORDER BY c.ndoc,a.ncontrol,a.fech
	ENDTEXT
Else
	TEXT TO lc NOSHOW
	     SELECT b.rdeu_idpr,a.fech as fepd,a.fevto as fevd,a.ndoc,b.rdeu_impc as impc,a.impo as impd,a.acta as actd,a.dola,
	     a.tipo,a.banc,ifnull(c.ndoc,'0000000000') as docd,b.rdeu_mone as mond,a.estd,a.iddeu as nr,
	     b.rdeu_idau as idauto,ifnull(c.tdoc,'00') as refe FROM fe_deu as a
	     inner join fe_rdeu as b ON(b.rdeu_idrd=a.deud_idrd) left join fe_rcom as c ON(c.idauto=b.rdeu_idau)
	     WHERE b.rdeu_idpr=?nidclie AND b.rdeu_mone=?cmoneda and a.acti<>'I' and b.rdeu_acti<>'I' and b.rdeu_codt=?opt ORDER BY c.ndoc,a.ncontrol,a.fech
	ENDTEXT
Endif
If SQLExec(goapp.bdconn,lc,"estado")<0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
**********************************************
Function MuestraSaldosDctosVtas()
TEXT TO lc NOSHOW
	    SELECT a.idclie,a.ndoc,a.importe,a.mone,a.banc,a.fech,
	    a.fevto,a.tipo,a.dola,a.docd,a.nrou,a.banco,a.idcred,a.idauto,a.nomv,a.ncontrol FROM
	    vpdtespagoc as a
ENDTEXT
If SQLExec(goapp.bdconn,lc,"tmp")<0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
************************************************
Function MuestraSaldosDctosCompras()
TEXT TO lc NOSHOW
      SELECT a.idpr as idprov,a.ndoc,a.saldo as importe,a.moneda as mone,a.banc,a.fech,a.fevto,a.tipo,
      a.dola,a.docd,a.nrou,a.banco,a.iddeu,a.idauto,a.ncontrol FROM vpdtespago as a order by a.fevto,a.ndoc
ENDTEXT
If SQLExec(goapp.bdconn,lc,"dtmp")<0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
************************************************
Function Desactiva(centidad,nid)
Do Case
Case centidad="Dctos"
	If SQLExec(goapp.bdconn,"CALL PRODESACTIVADCTOS(?nid)")<0 Then
		errorbd(ERRORPROC)
		Return 0
	Else
		Return 1
	Endif
Endcase
Endfunc
********************************************
Function InsertaDctos(cdes,ctdoc)
If SQLExec(goapp.bdconn,"SELECT FUNCREADCTOS(?cdes,?ctdoc) as id")<0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
*********************************************
Function VerificaCodDcto(nid1,nid2)
If nid2=0 Then
	TEXT TO lc NOSHOW
        SELECT COUNT(*) as x FROM fe_tdoc WHERE tdoc=?nid1 AND dcto_acti<>'I' GROUP BY idtdoc
	ENDTEXT
	If SQLExec(goapp.bdconn,lc,"wd")<0 Then
		errorbd(ERRORPROC)
		Return 0
	Else
		If !Empty(wd.x) Then
			Messagebox("Ya Existe El Còdigo Registrado",16,"SISVEN")
			Return 0
		Else
			Return 1
		Endif
	Endif
Else
	TEXT TO lc NOSHOW
      	  SELECT COUNT(*) as x FROM fe_tdoc WHERE idtdoc<>?nid2 AND dcto_acti<>'I' AND tdoc=?nid1 GROUP BY idtdoc
	ENDTEXT
	If SQLExec(goapp.bdconn,lc,"wd")<0 Then
		errorbd(ERRORPROC)
		Return 0
	Else
		If !Empty(wd.x) Then
			Messagebox("Ya Existe El Còdigo Registrado",16,'SISVEN')
			Return 0
		Else
			Return 1
		Endif
	Endif
Endif
Endfunc
**************************************************
Function CreaGrupos(Cd,nidus,pc)
If SQLExec(goapp.bdconn,"select FuncreaGrupo(?cd,?nidus,?pc) as id")<0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
*****************************************************
Function CreaCostoFletes(Cd,np,nu,pc)
If SQLExec(goapp.bdconn,"SELECT FUNCREAFLETES(?cd,?np,?nu,?pc) AS NIDFLETES") < 1
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
****************************************************
Function BuscarSeries(ns,ctdoc)
Local cser As String
If SQLExec(goapp.bdconn,"CALL PROBUSCASERIES(?ns,?ctdoc)","series")<1
	Return 0
Else
	Do Case
	Case SERIES.idserie>0
		If ctdoc='01' Or ctdoc='03' Or ctdoc='20' Or ctdoc='09' Or ctdoc="07" Then
			cser=Right("000"+Alltrim(Str(ns)),3)
			Do Case
			Case cser="001"
				Do Case
				Case ctdoc="01"
					goapp.reporte=Locfile("comp\factura1.frx")
				Case ctdoc="03"
					goapp.reporte=Locfile("comp\boleta1.frx")
				Case ctdoc="20"
					goapp.reporte=Locfile("comp\notasp.frx")
				Case ctdoc="09"
					goapp.reporte=Locfile("comp\guia1.frx")
				Case ctdoc="07"
					goapp.reporte=Locfile("comp\notasc1.frx")
				Endcase
			Case cser="002"
				Do Case
				Case ctdoc="01"
					goapp.reporte=Locfile("comp\factura2.frx")
				Case ctdoc="03"
					goapp.reporte=Locfile("comp\boleta2.frx")
				Case ctdoc="20"
					goapp.reporte=Locfile("comp\notasp.frx")
				Case ctdoc="09"
					goapp.reporte=Locfile("comp\guia2.frx")
				Case ctdoc="07"
					goapp.reporte=Locfile("comp\notasc2.frx")
				Endcase
			Case cser="003"
				Do Case
				Case ctdoc="01"
					goapp.reporte=Locfile("comp\factura3.frx")
				Case ctdoc="03"
					goapp.reporte=Locfile("comp\boleta3.frx")
				Case ctdoc="20"
					goapp.reporte=Locfile("comp\notasp.frx")
				Case ctdoc="09"
					goapp.reporte=Locfile("comp\guia3.frx")
				Case ctdoc="07"
					goapp.reporte=Locfile("comp\notasc3.frx")
				Endcase
			Case cser="004"
				Do Case
				Case ctdoc="01"
					goapp.reporte=Locfile("comp\factura4.frx")
				Case ctdoc="03"
					goapp.reporte=Locfile("comp\boleta4.frx")
				Case ctdoc="20"
					goapp.reporte=Locfile("comp\notasp.frx")
				Case ctdoc="09"
					goapp.reporte=Locfile("comp\guia4.frx")
				Case ctdoc="07"
					goapp.reporte=Locfile("comp\notasc4.frx")
				Endcase
			Case cser="005"
				Do Case
				Case ctdoc="01"
					goapp.reporte=Locfile("comp\factura5.frx")
				Case ctdoc="03"
					goapp.reporte=Locfile("comp\boleta5.frx")
				Case ctdoc="20"
					goapp.reporte=Locfile("comp\notasp.frx")
				Case ctdoc="09"
					goapp.reporte=Locfile("comp\guia5.frx")
				Case ctdoc="07"
					goapp.reporte=Locfile("comp\notasc5.frx")
				Endcase
			Case cser="006"
				Do Case
				Case ctdoc="01"
					goapp.reporte=Locfile("comp\factura6.frx")
				Case ctdoc="03"
					goapp.reporte=Locfile("comp\boleta6.frx")
				Case ctdoc="20"
					goapp.reporte=Locfile("comp\notasp.frx")
				Case ctdoc="09"
					goapp.reporte=Locfile("comp\guia6.frx")
				Case ctdoc="07"
					goapp.reporte=Locfile("comp\notasc6.frx")
				Endcase
			Case cser="007"
				Do Case
				Case ctdoc="01"
					goapp.reporte=Locfile("comp\factura7.frx")
				Case ctdoc="03"
					goapp.reporte=Locfile("comp\boleta7.frx")
				Case ctdoc="20"
					goapp.reporte=Locfile("comp\notasp.frx")
				Case ctdoc="09"
					goapp.reporte=Locfile("comp\guia7.frx")
				Case ctdoc="07"
					goapp.reporte=Locfile("comp\notasc6.frx")
				Endcase
			Case cser="008"
				Do Case
				Case ctdoc="01"
					goapp.reporte=Locfile("comp\factura8.frx")
				Case ctdoc="03"
					goapp.reporte=Locfile("comp\boleta8.frx")
				Case ctdoc="20"
					goapp.reporte=Locfile("comp\notasp.frx")
				Case ctdoc="09"
					goapp.reporte=Locfile("comp\guia8.frx")
				Case ctdoc="07"
					goapp.reporte=Locfile("comp\notasc8.frx")
				Endcase
			Case cser="009"
				Do Case
				Case ctdoc="01"
					goapp.reporte=Locfile("comp\factura9.frx")
				Case ctdoc="03"
					goapp.reporte=Locfile("comp\boleta9.frx")
				Case ctdoc="20"
					goapp.reporte=Locfile("comp\notasp.frx")
				Case ctdoc="09"
					goapp.reporte=Locfile("comp\guia9.frx")
				Case ctdoc="07"
					goapp.reporte=Locfile("comp\notasc9.frx")
				Endcase
			Case cser="010"
				Do Case
				Case ctdoc="01"
					goapp.reporte=Locfile("comp\factura10.frx")
				Case ctdoc="03"
					goapp.reporte=Locfile("comp\boleta10.frx")
				Case ctdoc="20"
					goapp.reporte=Locfile("comp\notasp.frx")
				Case ctdoc="09"
					goapp.reporte=Locfile("comp\guia10.frx")
				Case ctdoc="07"
					goapp.reporte=Locfile("comp\notasc10.frx")
				Endcase
			Case cser="011"
				Do Case
				Case ctdoc="01"
					goapp.reporte=Locfile("comp\factura11.frx")
				Case ctdoc="03"
					goapp.reporte=Locfile("comp\boleta11.frx")
				Case ctdoc="20"
					goapp.reporte=Locfile("comp\notasp.frx")
				Case ctdoc="09"
					goapp.reporte=Locfile("comp\guia11.frx")
				Case ctdoc="07"
					goapp.reporte=Locfile("comp\notasc11.frx")
				Endcase
			Endcase
			If !File((goapp.reporte)) Then
				Messagebox("No es Posible Imprimir este Comprobante",16,MSGTITULO)
				Return 0
			Else
				Return 1
			Endif
		Else
			Return 1
		Endif
	Case SERIES.idserie<=0
		Messagebox("Serie No Registrada",48,MSGTITULO)
		Return 0
	Endcase
Endif
Endfunc
*****************************************************
Function PermiteIngresoACaja(df)
If SQLExec(goapp.bdconn,"SELECT FUNVERIFICACAJA(?DF) AS SW","x")<1
	errorbd(ERRORPROC)
	Return 0
Else
	If x.SW=0
		Return 1
	Else
		Return 0
	Endif
Endif
Endfunc
******************************************************
Function PermiteIngresoVentas(cndoc,ctdoc,id1,dFecha)
If SQLExec(goapp.bdconn,"SELECT FUNVALIDADCTOS('V',?cndoc,?ctdoc,?id1) as nid","idventas")<1 Then
	errorbd(ERROPROC)
	Return 0
Else
	If idventas.nid>0 Then
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
*****************************************************
Function MuestraConceptos(ctipo)
If SQLExec(goapp.bdconn,"call promuestraConceptos(?ctipo)","conceptos")<=0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function PermiteAnularCompra(nauto,dFecha)
Local vd,vd1,vd2 As Integer
vd=1
vd1=1
vd2=1
If SQLExec(goapp.bdconn,"SELECT FUNVALIDADCTOSCOMPRAS(?nauto) as sw","valida") <1 Then
	errorbd(ERRORPROC+' Validando Dctos Compras')
	vd=0
Else
	If Valida.SW>0 Then
		Messagebox('No Es Posible Anular Este Documento Tiene Relaciòn Con Compras al Crèdito o Tiene Costos en Documentos de Ventas',16,'SISVEN')
		vd=0
	Else
		vd=1
	Endif
Endif
If Validadeuda(nauto)=0 Then
	Messagebox("No es Posible Anular Este Documento Tiene Pagos Pendientes",16,'SISVEN')
	vd2=0
Else
	vd2=1
Endif
If PermiteIngresoACaja(dFecha)=0 Then
	Messagebox('La Caja de Esta Fecha Esta Liquidada',16,'SISVEN')
	vd1=0
Else
	vd1=1
Endif
If vd=1 And vd1=1  And vd2=1 Then
	Return 1
Else
	Return 0
Endif
Endfunc
******************************************************
Function PermiteAnularVenta(nauto,dFecha)
Local vd,vd1
If ValidaCredito(nauto)=0 Then
	Messagebox("No es Posible Actualizar Este Documento Tiene Pagos a Cuenta",16,'SISVEN')
	vd=0
Else
	vd=1
Endif
If PermiteIngresoACaja(dFecha)=0 Then
	Messagebox('La Caja de Esta Fecha Esta Liquidada',16,'SISVEN')
	vd1=0
Else
	vd1=1
Endif
If vd=1 And vd1=1 Then
	Return 1
Else
	Return 0
Endif
Endfunc
*******************************************************
Function IngresaCabeceraCreditos(nauto,nidcliente,dFecha,nidven,nimpoo,nidus,nidtda,ninic,cpc)
If SQLExec(goapp.bdconn,"SELECT FUNINGRESARCREDITOS(?nauto,?nidcliente,?dfecha,?nidven,?nimpoo,?nidus,?nidtda,?ninic,?cpc) AS IDC","RCRE")<0 Then
	errorbd(ERRORPROC+' '+"Ingresando Cabecera Créditos")
	Return 0
Else
	Return rcre.idc
Endif
Endfunc
*********************************
Function IngresaDcreditos(dFecha,dfevto,nimpo,cndoc,cest,Cmon,crefe,ctipo,id1,nidus)
If SQLExec(goapp.bdconn,"SELECT FUNINGRESAdCREDITOS(?dfecha,?dfevto,?nimpo,?cndoc,?cest,?cmon,?crefe,?ctipo,?id1,?nidus) AS IDC","RCRE")<0 Then
	errorbd(ERRORPROC+' '+"Ingresando el Detalle de Créditos")
	Return 0
Else
	Return rcre.idc
Endif
Endfunc
*********************************
Function DesactivaDeudas(idc)
If SQLExec(goapp.bdconn,"CALL PRODESACTIVACDEUDAS(?Idc)")<1 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************
Function validacaja(df)
s='C'
If SQLExec(goapp.bdconn,"SELECT FUNVERIFICACAJA(?DF) AS SW","x")<1
	errorbd(ERRORPROC)
	s='C'
Else
	If x.SW=0
		s='A'
	Else
		s='C'
	Endif
Endif
Return s
Endfunc
**************************
Function ValidaCredito(na)
If na=0 Then
	Return 1
Endif
If SQLExec(goapp.bdconn,"select FUNVERIFICAPAGOS(?na) as sw","lcreditos")<0
	errorbd(ERRORPROC)
	Return 0
Else
	If lcreditos.SW>0
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
**************************
Function retcimporte(nimpo,m)
ci=N2L(nimpo)
cnuc=Alltrim(Str(nimpo,10,2))
npos=At(".",cnuc)
If m="S"
	cm="NUEVOS SOLES"
Else
	cm="DOLARES AMERICANOS"
Endif
Do Case
Case npos=0
	ccadena='00'+'/100 '+cm
Case Len(Substr(cnuc,npos+1))=1
	ccadena=Substr(cnuc,npos+1,1)+'0'+'/100 ' +cm
Otherwise
	ccadena=Substr(cnuc,npos+1,2)+'/100 '+cm
Endcase
Return (ci+'  Con  '+ccadena)
Endfunc
*****************************
Function Validadeuda(na)
If SQLExec(goapp.bdconn,"SELECT ifnull(FunVerificaEstadoDeuda(?na),0) as nid ","IDEU")<0 Then
	Return 0
Else
	If Val(ideu.nid)=0 Then
		Return 1
	Else
		Return 0
	Endif
Endif
Endfunc
***********************************
Procedure errorbd(ccomando As String)
Local laerror
Dimension laerror(1)
=Aerror(laerror)
lcError = laerror(1,3)
Messagebox("No se Pudo Conectar con la Base de Datos..Detalles:" + Chr(13) + ;
	ALLTRIM(ccomando) + Chr(13) + Chr(13) + ;
	lcError,16+0+0,"SISVEN")
Endproc
*************************************
Procedure DESHACERCAMBIOS
If SQLExec(goapp.bdconn,"ROLLBACK")<1
	errorbd("Error al Deshacer Cambios")
Else
	Messagebox("No se Guardo la Información",16,'SISVEN')
Endif
Endproc
***************************************
Procedure GRABARCAMBIOS
If SQLExec(goapp.bdconn,"COMMIT")<1
	errorbd("Error al Confirmar Grabaciòn de Datos")
Endif
Endproc
******************************************
Procedure CierraCursor(CALIAS)
Use In (Select((CALIAS)))
Endproc
******************************************
Function IniciaTransaccion
If SQLExec(goapp.bdconn,"SET TRANSACTION ISOLATION LEVEL READ COMMITTED")<0 Then
	errorbd("No se Pudo Iniciar Las Transacciones")
	Return 0
Else
	If SQLExec(goapp.bdconn,"START TRANSACTION")<0 Then
		errorbd("No se Pudo Iniciar Las Transacciones")
		Return 0
	Endif
Endif
Return 1
Endfunc
*******************************************
Function REGDVTO(CALIAS)
Select (CALIAS)
If Reccount()=0
	Return 0
Else
	Return 1
Endif
Endfunc
******************************************
Function RetConcepto(cb,ctipo)
TEXT TO lc noshow
       SELECT idcon FROM fe_con WHERE tdoc=?cb AND tipo=?ctipo AND conc_acti<>'I'  GROUP BY idcon
ENDTEXT
If SQLExec(goapp.bdconn,lc,"conc")<1
	errorbd(lc)
	Return 0
Else
	Return Conc.idcon
Endif
Endfunc
******************************************
Function vlineacredito(ccodc,nmonto,nlinea)
If SQLExec(goapp.bdconn,"SELECT FUNVERIFICALINEACREDITO(?ccodc,?nmonto,?nlinea) as sw","lcredito")<1 Then
	errorbd(ERRORPROC)
	Return 0
Else
	If lcredito.SW=0 Then
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
*********************************************
Function IngresaResumenDctosT(ctdoc,cndoc,dFecha,nv,nigv,nt,cmvto,cdeta,cndo2,nidtda,nidusua,nitem)
Local nigv1
nigv1=fe_gene.igv
If SQLExec(goapp.bdconn,"SELECT FUNINGRESACABECERACV(?ctdoc,'E',?cndoc,?dfecha,?dfecha,?cdeta,?nv,?nigv,?nt,?cndo2,'S',2.80,nigv1,'T',0,?cmvto,?nidusua,1,?nidtda,0,0,0,?nitem,0) AS NID","NIDT") < 1
	errorbd(ERRORPROC+' CABECERA')
	Return 0
Else
	Return nidt.nid
Endif
Endfunc
*********************************************
Function IngresaDetalleTraspaso3(nid,cc,nct,cdeta,nalma1,nalma2,na1,cdeta1,nalma3,nalma4)
Local sw1,sw2 As Integer
sw1=1
sw2=1
If SQLExec(goapp.bdconn,"SELECT FUNINGRESAKARDEX(?nid,?cc,'C',0,?nct,'I',0,'T',?cdeta,?nalma1,?nalma2,?na1) AS nidkar") < 1
	errorbd(ERRORPROC)
	sw1=0
Endif
If SQLExec(goapp.bdconn,"SELECT FUNINGRESAKARDEX(?nid,?cc,'C',0,?nct,'I',0,'T',?cdeta1,?nalma3,?nalma4,?na1) AS nidkar") < 1
	errorbd(ERRORPROC)
	sw2=0
Endif
If sw1=1 And sw2=1
	Return 1
Else
	Return 0
Endif
Endfunc
************************************************
Function ActualizaStock(ncoda,nalma,ncant,ctipo)
If SQLExec(goapp.bdconn,"CALL ASTOCK(?ncoda,?nalma,?ncant,?ctipo)")<1 Then
	errorbd(ERRORPROC+'Actualizando Stock')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************************************
Function Actualizanrotraspaso(nid,nidt,opt)
Local cu,cu1 As Integer
cu=goapp.nidusua
cu1=goapp.uauto
If SQLExec(goapp.bdconn,"CALL ProActualizacabeceraporTraspasos(?nid,?nidt,?opt,?cu,?cu1)")<1 Then
	errorbd(ERRORPROC+'Actualizando Traspasos')
	Return 0
Else
	Return 1
Endif
Endfunc
************************************************
Function IngresaPdtesEntrega(nidart,ncant,nid1)
cu=goapp.nidusua
idpc=Id()
If SQLExec(goapp.bdconn,"CALL ProIngresaPdtesEntrega(?nidart,?ncant,?nid1,?cu,?idpc)")<1 Then
	errorbd(ERRORPROC+'Ingresando Pendientes')
	Return 0
Else
	Return 1
Endif
Endfunc
************************************************
Function ActualizaPdtesEntrega(nidauto,nu)
If SQLExec(goapp.bdconn,"CALL ProAnulaPdtesEntrega(?nidauto,?nu)")<1 Then
	errorbd(ERRORPROC+'Actualizando Ingresos A Pdtes de Entrega')
	Return 0
Else
	Return 1
Endif
Endfunc
************************************************
Function VerificaPdtesEntrega(nid)
If SQLExec(goapp.bdconn,"SELECT FUNVERIFICADPTESENTREGA(?NID) as nid","xx")<1 Then
	errorbd(ERRORPROC)
	Return 0
Else
	If xx.nid>0 Then
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
************************************************
Function IngresaKardex(nauto,ccoda,ctipo,nprec,ncant,cincl,nidven,cttip,nidtda)
If SQLExec(goapp.bdconn,"SELECT FUNINGRESADKARDEX(?nauto,?ccoda,?ctipo,?nprec,?ncant,?cincl,?nidven,?cttip,?nidtda) as nidtr","xx")<1 Then
	errorbd(ERRORPROC+' Ingresando Kardex ')
	Return 0
Else
	Return xx.nidtr
Endif
Endfunc
************************************************
Function IngresaGuias(dFecha,cptop,cptoll,nidauto,dfechat,nidus,cdeta,xidtr,cndoc)
If SQLExec(goapp.bdconn,"SELECT FUNINGRESAGUIAS(?dfecha,?cptop,?cptoll,?nidauto,?dfechat,?nidus,?cdeta,?xidtr,?cndoc) as nid","yy")<1 Then
	errorbd(ERRORPROC+'Ingresando Guias')
	Return 0
Else
	Return yy.nid
Endif
Endfunc
************************************************
Function IngresaEntregas(ncant,nidin,nidguia)
If SQLExec(goapp.bdconn,"CALL PROingresaentregas(?ncant,?nidin,?nidguia)")<1 Then
	errorbd(ERRORPROC+'Ingresando Entregas')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************************************
Function ActualizaCostos(cc,dfe,npr,nid,idp,cmda,ni,nd,nidcosto)
If SQLExec(goapp.bdconn,"CALL ProActualizaPreciosProducto(?cc,?dfe,?npr,?nid,?idp,?cmda,?ni,?nd,?nidcosto)")<1
	errorbd(ERRORPROC+' Actualiza Precios')
	Return 0
Else
	Return 1
Endif
***********************************************
Function IngresaCostos(ncostoact,nid,cc,nflete,npr,cmda,ndolar)
If SQLExec(goapp.bdconn,"SELECT FUNINGRESACOSTOS(?ncostoact,?nid,?cc,?nflete,?npr,?cmda,?ndolar) as nidcosto","costos")<1 Then
	errorbd(ERRORPROC+' Ingresando Costos')
	Return  0
Else
	Return costos.nidcosto
Endif
Endfunc
************************************************
Function INGRESAKARDEX1(nid,cc,ct,npr,nct,cincl,tmvto,ccodv,nidalmacen,nidcosto1,xcomision)
If SQLExec(goapp.bdconn,"SELECT FUNINGRESAkardex1(?nid,?cc,?ct,?npr,?nct,?cincl,?tmvto,?ccodv,?nidalmacen,?nidcosto1,?xcomision) as nidk","nidk")<1 Then
	errorbd(ERRORPROC+' Ingresando KARDEX 1')
	Return  0
Else
	Return nidk.nidk
Endif
Endfunc
************************************************
Function ProcesaTransportista(cruc,crazo,cdire,cbreve,ccons,cmarca,cplaca,nid,opt,cchofer,nidus,cplaca1)
If opt=0 Then
	If SQLExec(goapp.bdconn,"SELECT FUNCREATRANSPORTISTA(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?nidus,?cplaca1) as nid","yy")<1 Then
		errorbd(ERRORPROC+'Ingresando Transportista')
		Return 0
	Else
		Return yy.nid
	Endif
Else
	If SQLExec(goapp.bdconn,"CALL PROACTUALIZATRANSPORTISTA(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?nid,?cplaca1)")<1 Then
		errorbd(ERRORPROC+'Actualizando Transportista')
		Return 0
	Else
		Return nid
	Endif
Endif
Endfunc
************************************************
Function ingresaaval(anom,ad,af,ar,nidclie)
nidaval=0
TEXT TO lc noshow
     INSERT INTO fe_aval(anombre,adire,afono,anruc)values(?anom,?ad,?af,?ar)
ENDTEXT
If SQLExec(goapp.bdconn,lc)<1
	errorbd(lc)
	nidval=-1
	Return nidaval
Endif
If SQLExec(goapp.bdconn,"SELECT LAST_INSERT_ID() as u FROM fe_aval","ida") < 1
	errorbd("No Es Posible Obtener el Id de la Tabla Avales")
	Return -1
Else
	nidaval=Val(ida.u)
	Use In(Select("al"))
	TEXT TO lc NOSHOW
      UPDATE fe_clie SET idaval=?nidaval WHERE idclie=?nidclie
	ENDTEXT
	If SQLExec(goapp.bdconn,lc)<1
		errorbd(lc)
		Return -1
	Endif
Endif
Return nidaval
******************
Function buscassinaval()
nidaval=0
TEXT TO lc NOSHOW
      SELECT idaval FROM fe_aval WHERE LEFT(anombre,3)="SIN"
ENDTEXT
If SQLExec(goapp.bdconn,lc,"av")<1
	nidval=-1
Else
	nidaval=av.idaval
Endif
Return nidaval
*****************
Function IngresaCabeceraDeudas(nauto,nidpr,cmone,dFecha,ntotal,nidus,nidtda,cpc)
If SQLExec(goapp.bdconn,"SELECT FUNregistraDeudas(?nauto,?nidpr,?cmone,?dfecha,?ntotal,?nidus,?nidtda,?cpc) as nid","y")<1 Then
	errorbd(ERRORPROC+' Ingresando Cabecera Deudas')
	Return 0
Else
	Return Y.nid
Endif
Endfunc
*****************
Function IngresaDetalleDeudas(nidr,cndoc,ctipo,dFecha,dfevto,ctipo,ndolar,nimpo,nidus,cpc,nidtda,cnrou,cdetalle,csitua)
If SQLExec(goapp.bdconn,"SELECT FUNINGRESADEUDAS(?nidr,?cndoc,?ctipo,?dfecha,?dfevto,?ctipo,?ndolar,?nimpo,?nidus,?cpc,?nidtda,?cnrou,?cdetalle,?csitua) as nid","y")<1 Then
	errorbd(ERRORPROC+'Ingresando Cabcera Deudas')
	Return 0
Else
	Return Y.nid
Endif
Endfunc
**************
Function ActualizaResumenDcto(ctdoc,cforma,cndoc,dFecha,dfechar,cdetalle,nv,ni,nt,cguia,cmone,ndolar,nigv,cttip,nidcliente,cmvto,nidus,opt,nidtda,n1,n2,n3,nitem,np1,nidauto)
If SQLExec(goapp.bdconn,"CALL ProActualizaCabeceracv(?ctdoc,?cforma,?cndoc,?dfecha,?dfechar,?cdetalle,?nv,?ni,?nt,?cguia,?cmone,?ndolar,?nigv,?cttip,?nidcliente,?cmvto,?nidus,?opt,?nidtda,?n1,?n2,?n3,?nitem,?np1,?nidauto)")<1 Then
	errorbd(ERRORPROC+' Actualizando Cabecera de Documento')
	Return 0
Else
	Return 1
Endif
Endfunc
***************
Function ActualizaCaja(na,dFecha,nt,cmvtoc,cform,cm,cndoc,nidcon,nidusua,cdeta,cor,nt,cm,ndolar,nidcodt,nidcaja)
If SQLExec(goapp.bdconn,"CALL PROACTUALIZACAJA(?na,?dfecha,?nt,?cmvtoc,?cform,?cm,?cndoc,?nidcon,?nidusua,?cdeta,?cor,?nt,?cm,?ndolar,?nidcodt,?nidcaja)") < 1
	errorbd(ERRORPROC+' Actualizando Caja')
	Return 0
Else
	Return 1
Endif
Endfunc
*************
Function ActualizaCostos1(nidcosto,ncostoact,nflete,npr,cmda,ndolar)
If SQLExec(goapp.bdconn,"CALL PROACTUALIZACOSTOS(?nidcosto,?ncostoact,?nflete,?npr,?cmda,?ndolar)")<1 Then
	errorbd(ERRORPROC+' Actualizando Costos')
	Return  0
Else
	Return 1
Endif
Endfunc
***********
Function ActualizaKardex1(nid,cc,ct,npr,nct,cincl,tmvto,ccodv,idalma,nidcosto1,nidkar,op,vcomision)
If SQLExec(goapp.bdconn,"CALL PROACTUALIZAKARDEX1(?nid,?cc,?ct,?npr,?nct,?cincl,?tmvto,?ccodv,?idalma,?nidcosto1,?nidkar,?op,?vcomision)")<1 Then
	errorbd(ERRORPROC+' Actualizando Kardex 1')
	Return  0
Else
	Return 1
Endif
Endfunc
***********
Function ActualizaStock11(ncoda,nalma,ncant,ctipo,ncaant)
If SQLExec(goapp.bdconn,"CALL PROACTUALIZASTOCK(?ncoda,?nalma,?ncant,?ctipo,?ncaant)")<1 Then
	errorbd(ERRORPROC+'Actualizando Stock')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function IngresaGuiasCompras(nidau,nidkar)
If SQLExec(goapp.bdconn,"SELECT FUNINGRESAGUIASCOMPRAS(?nidau,?nidkar) as nid","gc")<1 Then
	errorbd(ERRORPROC+'Actualizando Stock')
	Return 0
Else
	Return gc.nid
Endif
Endfunc
**************************
Function ActualizaGuiasCompras(nidauto0,nidauto1)
If SQLExec(goapp.bdconn,"CALL PROACTUALIZAGUIASCOMPRAS(?nidauto0,?nidauto1)")<1 Then
	errorbd(ERRORPROC+'Actualizando Guias Compras')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function Veritraspasoautomatico(nauto)
If SQLExec(goapp.bdconn,"SELECT FunVerificaTraspasoAutomatico(?NAUTO) As ID","vt")<=0 Then
	Return 0
Else
	If vt.Id=0 Then
		Return 1
	Else
		errorbd(ERRORPROC)
		Return 0
	Endif
Endif
Endfunc
**************************
Function PermiteActualizar(nauto)
If ValidaCredito(nauto)=1 And Veritraspasoautomatico(nauto)=1 Then
	Return 1
Else
	errorbd(ERRORPROC)
	Return 0
Endif
Endfunc
************************
Function ACtualizaCreditos(nauto,nu)
If SQLExec(goapp.bdconn,"Call ProActualizaCreditos(?nauto,?nu)") < 1
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function IngresaRvendedores(idca,nidclie,ccodv,cform)
If SQLExec(goapp.bdconn,"CALL PROingresarvendedores(?idca,0,?nidclie,?cform,?ccodv)") <1 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
****************************
Function ActualizaRvendedores(nid,nidclie,ccodv,cform,nidrv)
If SQLExec(goapp.bdconn,"CALL PROACTUALIZARVENDEDORES(?nid,0,?nidclie,?ccodv,?cform,?nidrv)")<=0 Then
	errorbd(ERRORPROC+' Actualizando Resumen Vendedores')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function PermiteIngresoVentas1(cndoc,ctdoc,nidauto,dFecha)
If SQLExec(goapp.bdconn,"SELECT FUNVALIDADCTOS1(?cndoc,?ctdoc,?nidauto) as nid","idv")<1 Then
	errorbd(ERROPROC)
	Return 0
Else
	If idv.nid>0 Then
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
******************
Function IngresarNotasCreditoVentas(nid0,nid1)
If SQLExec(goapp.bdconn,"SELECT FUNINGRESANOTASCREDITOventas(?nid0,?nid1) as nid","xi")< 1 Then
	errorbd(ERRORPROC+' Ingresando Notas Credito Ventas')
	Return 0
Else
	Return 1
Endif
Endfunc
*****************
Function MuestraBancos(cb)
If SQLExec(goapp.bdconn,' Call ProMuestraBancos(?cb)','lban')<=0 Then
	errorbd(ERRORPROC+' Mostrando Bancos')
	Return 0
Else
	Return  1
Endif
Endfunc
*****************
Function MuestraCotizaciones(Cd)
TEXT to lc noshow
     Select * from VmuestraCotizaciones where ndoc=?cd
ENDTEXT
If SQLExec(goapp.bdconn,lc,'pedidos')<0 Then
	errorbd(ERRORPROC+' Mostrando Cotizaciones')
	Return 0
Else
	Return 1
Endif
Endfunc
*****************
Function ActualizaCotizacion(dfech,nidclie,cndoc,ctdoc,nimpo,cform,cusua,nidven,nidtienda,ctp,caten,cforma,cplazo,cvalidez,centrega,cdetalle,Cmon,nauto)
If SQLExec(goapp.bdconn,'CALL PROACTUALIZACOTIZACION(?dfech,?nidclie,?cndoc,?ctdoc,?nimpo,?cform,?cusua,?nidven,?nidtienda,?ctp,?caten,?cforma,?cplazo,?cvalidez,?centrega,?cdetalle,?cmon,?nauto)')<0 Then
	errorbd(ERRORPROC+' Actualizando Cotizaciones')
	Return 0
Else
	Return 1
Endif
Endfunc
***************
Function RegistraCabeceraCotizacion(dfech,nidclie,cndoc,ctdoc,nimpo,cform,cusua,cidpcped,nidven,nidtienda,ctp,caten,cforma,cplazo,cvalidez,centrega,cdetalle,Cmon)
If SQLExec(goapp.bdconn,'select FunIngresaCabeceraCotizacion(?dfech,?nidclie,?cndoc,?ctdoc,?nimpo,?cform,?cusua,?cidpcped,?nidven,?nidtienda,?ctp,?caten,?cforma,?cplazo,?cvalidez,?centrega,?cdetalle,?cmon) as id','cid')<0 Then
	errorbd(ERRORPROC+' Ingresando Cabecera de  Cotizaciones')
	Return 0
Else
	Return cid.Id
Endif
Endfunc
**************
Function IngresaDCotizacion(ncoda,ncant,nprec,nid)
If SQLExec(goapp.bdconn,'select FuningresaDCotizacion(?ncoda,?ncant,?nprec,?nid) as id')<0 Then
	errorbd(ERRORPROC+' Ingresando Detalle de  Cotizaciones')
	Return 0
Else
	Return 1
Endif
Endfunc
**************
Function ActualizaDcotizacion(ncoda,ncant,nprec,nid,opt)
If SQLExec(goapp.bdconn,'call ProActualizaDcotizacion(?ncoda,?ncant,?nprec,?nid,?opt) ')<0 Then
	errorbd(ERRORPROC+' Actualizando Detalle de  Cotizaciones')
	Return 0
Else
	Return 1
Endif
Endfunc
*************
Function ActualizaPrecioKardexGuias(nidk,nprec)
If SQLExec(goapp.bdconn,'CALL PROACTUALIZAPRECIOGUIAS(?nidk,?nprec)')<0 Then
	errorbd(ERRORPROC+' Actualizando Precios')
	Return 0
Else
	Return 1
Endif
Endfunc
**************
Function HayDctoenCompras(cndoc,ctdoc,nidpr,nidauto)
If SQLExec(goapp.bdconn,"SELECT FUNHAYCOMPRA(?cndoc,?ctdoc,?nidpr,?nidauto) as nid","xi")< 1 Then
	errorbd(ERRORPROC+' Verificando Compras')
	Return 0
Else
	If xi.nid=1 Then
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
*****************
Function ActualizaStockf(ncoda,nalma,ncant,ctipo)
If SQLExec(goapp.bdconn,"CALL proASTOCK1(?ncoda,?nalma,?ncant,?ctipo)")<1 Then
	errorbd(ERRORPROC+'Actualizando Stock Fisico')
	Return 0
Else
	Return 1
Endif
Endfunc
*****************
Function ActualizaStockfisico(ncoda,nalma,ncant,ctipo,ncaant)
If SQLExec(goapp.bdconn,"CALL PROACTUALIZASTOCKF(?ncoda,?nalma,?ncant,?ctipo,?ncaant)")<1 Then
	errorbd(ERRORPROC+'Actualizando Stock FIsico')
	Return 0
Else
	Return 1
Endif
Endfunc
*************
Function GrabaEntregaFisica(nidk,nalma,ncant,nidg)
If SQLExec(goapp.bdconn,"CALL ProIngresaEntregaFisica(?nidk,?nalma,?ncant,?nidg)")<1 Then
	errorbd(ERRORPROC+'Ingresando Entregas Fisico')
	Return 0
Else
	Return 1
Endif
Endfunc
**************
Function AnulaEntregasFisicas(na,nu)
If SQLExec(goapp.bdconn,"CALL ProAnulaEntregaFisica(?na,?nu)")<1 Then
	errorbd(ERRORPROC+'Anulando Entregas Fisico')
	Return 0
Else
	Return 1
Endif
Endfunc
*************
Function MuestraEmpleados(cb)
If SQLExec(goapp.bdconn,"Call ProMuestraEmpleados(?cb)","Empleados")<1 Then
	errorbd(ERRORPROC+' Mostrando Empleados')
	Return 0
Else
	Return 1
Endif
Endfunc
***********
Function CancelaCreditos(cndoc,nacta,cesta,cmone,cb1,dfech,dfevto,ctipo,nctrl,cnrou,nidrc,cpc,nidus)
If SQLExec(goapp.bdconn,"SELECT FUNINGRESAPAGOSCREDITOS(?cndoc,?nacta,?cesta,?cmone,?cb1,?dfech,?dfevto,?ctipo,?nctrl,?cnrou,?nidrc,?cpc,?nidus) AS NIDC","nidcreditos")<1
	errorbd(ERRORPROC+' Cancelando Creditos')
	Return 0
Else
	Return nidcreditos.nidc
Endif
Endfunc
************
Function LimpiaLetras()
With goapp
	.fvl1=""
	.fvl2=""
	.fvl3=""
	.fvl4=""
	.il1=0
	.il2=0
	.il3=0
	.il4=0
	.l1=""
	.l2=""
	.l3=""
	.l4=""
Endwith
Endfunc
******************
Function VerificaTraspaso(CALIAS)
Local ctraspaso As Byte
Select (CALIAS)
Scan For coda>0
	ncoda=coda
	If SQLExec(goapp.bdconn,"CALL PRODSTOCKS(?ncoda)","st")<1 Then
		errorbd(ERRORPROC)
		ctraspaso=[N]
		Exit
	Endif
	Select (CALIAS)
	If cant<=(st.uno+st.Dos)
		If cant<=st.uno And calma#"DOS"
			ctraspaso="N"
		Else
			If cant<=st.Dos And calma="DOS"
				ctraspaso="S"
				Exit
			Else
				If st.uno>0 And cant<=(st.Dos+st.uno)
					ctraspaso="S"
					Exit
				Endif
			Endif
		Endif
	Endif
	Select (CALIAS)
Endscan
Return ctraspaso
Endfunc
*****************
Function IngresaCambiosVtas(nida,nidac,nidart,ncant,nprec,nidus,cpc)
If SQLExec(goapp.bdconn,"Select FunIngresaCambiosVtas(?nida,?nidac,?nidart,?ncant,?nprec,?nidus,?cpc) AS ID",'CAMB')<1
	errorbd(ERRORPROC+' Actualizando Tipo Venta')
	Return 0
Else
	Return CAMB.Id
Endif
Endfunc
***************
Function DatosGlobales()
TEXT TO lc NOSHOW
      SELECT * FROM fe_gene WHERE idgene=1
ENDTEXT
If SQLExec(goapp.bdconn,lc,"fe_gene")<1
	errorbd(lc)
	Return 0
Else
	Return 1
Endif
Endfunc
*************
Function DatosGlobales1()
TEXT TO lc NOSHOW
       SELECT * FROM fe_gene WHERE idgene=1
ENDTEXT
If SQLExec(goapp.bdconn,lc,"fe_gene1")<1
	errorbd(lc)
	Return 0
Else
	Return 1
Endif
Endfunc
*************
Function GeneraCorrelativo(nsgte,idserie)
If SQLExec(goapp.bdconn,'call ProGeneraCorrelativo(?nsgte,?idserie)')<1 Then
	errorbd(ERRORPROC+' Generando Correlartivo')
	Return 0
Else
	Return 1
Endif
Endfunc
******************
Function Abrircaja(dFecha)
If SQLExec(goapp.bdconn,"CALL abrircaja(?dfecha)")<1
	errorbd("No se Puede Abrir Caja")
	Return 0
Else
	Messagebox("Se Abrio Caja con Exito",64,MSGTITULO)
	Return 1
Endif
Endfunc
*****************
Function CerrarCaja(dFecha)
If SQLExec(goapp.bdconn,"CALL cierracaja(?dfecha)")<1
	errorbd("No se Puede Cerrar Caja")
	Return 0
Else
	Messagebox("Se Cerro Caja con Exito",64,MSGTITULO)
	Return 1
Endif
Endfunc
***********
Function IngresaResumenPedidos(dfech,nidclie,cndoc,ctdoc,nimpo,cform,cusua,cidpcped,nidven,nidtienda,ctipop,c1,c2,c3,c4,c5,c6,cmoneda)
If SQLExec(goapp.bdconn,"SELECT FUNINGRESACABECERACOTIZACION(?dfech,?nidclie,?cndoc,?ctdoc,?nimpo,?cform,?cusua,?cidpcped,?nidven,?nidtienda,?ctipop,?c1,?c2,?c3,?c4,?c5,?c6,?cmoneda) AS NIDPEDIDO","IDPEDIDOS")<1 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return idpedidos.nidpedido
Endif
Endfunc
***********
Function ActualizaResumenPedidos(dfech,nidclie,cndoc,ctdoc,nimpo,cform,nidus,nidven,nidtienda,ctipop,c1,c2,c3,c4,c5,c6,cmoneda,nidauto)
If SQLExec(goapp.bdconn,"CALL PROACTUALIZACotizacion(?dfech,?nidclie,?cndoc,?ctdoc,?nimpo,?cform,?nidus,?nidven,?nidtienda,?ctipop,?c1,?c2,?c3,?c4,?c5,?c6,?cmoneda,?nidauto)")<1 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
***********
Function IngresaDPedidos(ncoda,ncant,nprec,nidauto)
If SQLExec(goapp.bdconn,"SELECT FunIngresaDPedidos(?ncoda,?ncant,?nprec,?nidauto) AS NID","IDd")<1 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return idd.nid
Endif
Endfunc
*************
Function ActualizaDpedidos(ncoda,ncant,nprec,nr,ctipoa)
If SQLExec(goapp.bdconn,"CALL ProActualizaDetallePedidos(?ncoda,?ncant,?nprec,?nr,?ctipoa)")<1 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
**************
Function RegistraCreditosDetallados1(nauto,cdocp,Cmon,dFecha,ndolar,idven,idcl,ctdoc,crazo1)
Local ctipoc
Local lsw As Integer
lsw=1
If !Used("tmpd") Or nauto=0
	Return 0
Endif
x=0
nidusua=goapp.nidusua
nidcodt=goapp.tienda
Select tmpd
Go Top In tmpd
ctipo=tmpd.tipo
ctipoc=Iif(ctipo="L","L","")
csitua=tmpd.situa
ninic=tmpd.inic
cest="C"
cusua=goapp.usuario
nimpoo=tmpd.impoo
ndscto=tmpd.dscto
Do Case
Case avales.tipo="N"
	nidaval=ingresaaval(avales.an,avales.ad,avales.af,avales.ar,nid)
Case avales.tipo="M"
	nidaval=avales.idval
Case avales.tipo="S"
	nidaval=buscassinaval()
Endcase
If nidaval=-1
	Return 0
Endif
If nidaval=1
	an=""
	ad=""
	af=""
	ar=""
Else
	an=avales.an
	ad=avales.ad
	af=avales.af
	ar=avales.ar
Endif
crazo=""
cnruc=""
cdire=""
cdni=""
If tmpd.codc<>idcl Then
	nid=tmpd.codc
Else
	nid=idcl
Endif
If MuestraClientes('',3,nid)=0 Then
	Return 0
Endif
crazo=clientes.razo
cnruc=Iif(ctdoc="01",clientes.nruc,clientes.ndni)
cdire=Alltrim(clientes.Dire)
cciud=Alltrim(clientes.ciud)
cfono=Alltrim(clientes.fono)
cdni=Alltrim(clientes.ndni)
cpc=Id()
Select tmpd
Go Top
Do While !Eof()
	ccimporte=retcimporte(tmpd.Impo,Cmon)
	crefe=Iif(Empty(goapp.referencia),tmpd.detalle,goapp.referencia)
	Replace cimporte With ccimporte,razo With crazo,nruc With cnruc,Dire With cdire,ciud With cciud,fono With cfono,;
		anombre With an,adire With ad,afono With af,anruc With ar,dni With cdni In tmpd
	x=x+1
	cndoc=tmpd.ndoc
	nimpo=tmpd.Impo
	anom=tmpd.anombre
	adire=tmpd.adire
	afono=tmpd.afono
	anruc=tmpd.anruc
	dfevto=tmpd.fevto
	If x=1
		ni=ninic
	Else
		ni=0
	Endif
	If SQLExec(goapp.bdconn,"SELECT FUNINGRESACREDITOS(?nauto,?nid,?cndoc,?cest,?cmon,?crefe,?dfecha,?dfevto,?ctipo,?cdocp,?ndolar,?csitua,?nimpo,?ni,?idven,?nimpoo,?nidusua,?nidaval,?ndscto,?cpc,?nidcodt,0,0) AS NID","NIDCR")<1
		errorbd(ERRORPROC+' INGRESAANDO CREDITOS')
		lsw=0
		Exit
	Endif
	If x=1 And tmpd.inic>0
		idcredito=nidcr.nid
		na=0
		cform="E"
		crefe="Pago Acta Cliente "+Alltrim(crazo1)
		If SQLExec(goapp.bdconn,"CALL PROingresacaja(?nauto,?cndoc,?dfecha,?na,?ninic,?crefe,?cusua,?cmon,?idcredito,?cform,0,?cmon,?ndolar,?nidcodt,?nidusua)")<1
			errorbd("Ingresando Inicia En caja")
			lsw=0
			Exit
		Endif
	Endif
	Select tmpd
	Skip
Enddo
If lsw=1
	goapp.imprimeletra="S"
Endif
If lsw=1
	Return 1
Else
	Return 0
Endif
Endfunc
********************
Function FacturaPedido(idautop)
If SQLExec(goapp.bdconn,"Call ProFacturaPedido(?idautop)")<1 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
********************
Function  MuestraZonasp(cb)
If SQLExec(goapp.bdconn,"CALL PROMUESTRAZONASP(?cb)","lzonasp")<0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
**********************
Function CreaZonasp(cnom,cpc,nidus)
If SQLExec(goapp.bdconn,"select FunCreaZonaP(?cnom,?cpc,?nidus) as id","zonap")<0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return zonap.Id
Endif
Endfunc
******************
Function ModificaZonasp(cnom,nid,opt)
If SQLExec(goapp.bdconn,"CALL ProActualizaZonap(?cnom,?nid,?opt)")<0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
******************
Function ValidaZonasp(Id)
If SQLExec(goapp.bdconn,"select funValidaZonasp(?id) as idzona","idz")<0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	If idz.idzona=0 Or Isnull(idz.idzona) Then
		Return 1
	Else
		Return 0
	Endif
Endif
Endfunc
******************
Function  MuestraZonas(cb)
If SQLExec(goapp.bdconn,"CALL PROMUESTRAZONAS(?cb)","lzonas")<0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
**********************
Function CreaZonas(cnom,cpc,nidus,nidz)
If SQLExec(goapp.bdconn,"select FunCreaZona(?cnom,?cpc,?nidus,?nidz) as id","zona")<0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return zona.Id
Endif
Endfunc
******************
Function ModificaZonas(cnom,nid,opt,nidz)
If SQLExec(goapp.bdconn,"CALL ProActualizaZona(?cnom,?nid,?opt,?nidz)")<0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
******************
Function ValidaZonas(Id)
If SQLExec(goapp.bdconn,"select funValidaZonas(?id) as id","idclz")<0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	If idclz.Id=0 Or Isnull(idclz.Id) Then
		Return 1
	Else
		Return 0
	Endif
Endif
Endfunc
******************
Function CreaCliente(cnruc,crazo,cdire,cciud,cfono,cfax,cdni,ctipo,cemail,nidven,cusua,cidpc,ccelu,crefe,linea,crpm,nidz)
If SQLExec(goapp.bdconn,"SELECT FUNCREACLIENTE(?cnruc,?crazo,?cdire,?cciud,?cfono,?cfax,?cdni,?ctipo,?cemail,?nidven,?cusua,?cidpc,?ccelu,?crefe,?linea,?crpm,?nidz) as nid","xt")<1 Then
	errorbd(ERRORPROC+ 'Creando Clientes')
	Return 0
Else
	Return xt.nid
Endif
Endfunc
******************
Function  ActualizaCliente(nid,cnruc,crazo,cdire,cciud,cfono,cfax,cdni,ctipo,cemail,nidven,cusua,ccelu,crefe,linea,crpm,nidz)
If SQLExec(goapp.bdconn,"CALL PROACTUALIZACLIENTE(?nid,?cnruc,?crazo,?cdire,?cciud,?cfono,?cfax,?cdni,?ctipo,?cemail,?nidven,?cusua,?ccelu,?crefe,?linea,?crpm,?nidz)")<1 Then
	errorbd(ERRORPROC+ 'Editando Clientes')
	Return 0
Else
	Return  1
Endif
Endfunc
******************
Function IngresaKardexCambios(nid,cc,ct,npr,nct,cin,ccodv,ctt,nidtda,nidcosto)
If SQLExec(goapp.bdconn,"SELECT FunIngresaKardexCambios (?nid,?cc,?ct,?npr,?nct,?cin,?ccodv,?ctt,?nidtda,?nidcosto) as id","idca" )<1 Then
	errorbd(ERRORPROC+ 'Creando Clientes')
	Return 0
Else
	Return idca.Id
Endif
Endfunc
******************
Function RegistraTipoCambio(nm,na)
Local dias,SW As Integer
SW=1
Do Case
Case nm=1 Or nm=3 Or nm=5 Or nm=7 Or nm=8 Or nm=10 Or nm=12
	dias=31
Case nm=4 Or nm=6 Or nm=9 Or nm=11
	dias=30
Otherwise
	If ((na%4 = 0 And na%100 # 0) Or (na%400 =0)) Then
		dias=29
	Else
		dias=28
	Endif
Endcase
If IniciaTransaccion()=0 Then
	Return 0
Endif
For x=1 To dias
	df=Ctod(Alltrim(Str(x))+'/'+Alltrim(Str(nm))+'/'+Alltrim(Str(na)))
	TEXT TO lc NOSHOW
               INSERT INTO fe_mon(fech,valor,venta)values(?df,0,0)
	ENDTEXT
	If SQLExec(goapp.bdconn,lc)<0 Then
		SW=0
		Exit
	Endif
Next
If SW=0 Then
	DESHACERCAMBIOS()
	errorbd(lc+ 'Ingresando Tipo Cambio')
	Return 0
Else
	GRABARCAMBIOS()
	Return 1
Endif
Endfunc
******************
Function DtipoCambio(df,ct)
If SQLExec(goapp.bdconn,"SELECT Fundtipocambio(?df,?ct) as vta","lmone")<0 Then
	errorbd("No es posible Obtener el Tipo de Cambio")
	Return 0
Else
	If lmone.vta>0 Then
		Return lmone.vta
	Else
		If DatosGlobales()>0 Then
			Return fe_gene.dola
		Else
			Return 0
		Endif
	Endif
Endif
Endfunc
******************
Function RetornaMes(df)
Local nm As Integer
Local cm As String(20)
nm=Month(df)
Do Case
Case nm=1
	cm="Enero"
Case nm=2
	cm="Febrero"
Case nm=3
	cm="Marzo"
Case nm=4
	cm="Abril"
Case nm=5
	cm="Mayo"
Case nm=6
	cm="Junio"
Case nm=7
	cm="Julio"
Case nm=8
	cm="Agosto"
Case nm=9
	cm="Septiembre"
Case nm=10
	cm="Octubre"
Case nm=11
	cm="Noviembre"
Case nm=12
	cm="Diciembre"
Endcase
Return cm
Endfunc
******************
Function RegistraSeriesDctos(cserie,cnume,ctdoc,nitems,ntda)
If SQLExec(goapp.bdconn,"select FunCreaSeriesDctos(?cserie,?cnume,?ctdoc,?nitems,?ntda) as ids","ids" ) < 1
	errorbd(ERRORPROC+ ' CREANDO SERIES')
	Return 0
Else
	Return ids.ids
Endif
Endfunc
******************
Function ActualizarSeriesDctos(cserie,cnume,ctdoc,nitems,ntda,nidserie)
If SQLExec(goapp.bdconn,"CALL ProActulizaSeriesDctos(?cserie,?cnume,?ctdoc,?nitems,?ntda,?nidserie)" ) < 1
	errorbd(ERRORPROC+ ' ACTUALIZANDO SERIES')
	Return 0
Else
	Return 1
Endif
Endfunc
******************
Function ActualizaValoresCtasV(nt1,nt2,nt3,nt4,nt5,nt6,nt7,nidcta1,nidcta2,nidcta3,nidcta4,nidctai,nidctae,nidctat,id1,id2,id3,id4,id5,id6,id7,ct1,ct2,ct3,ct4,ct5,ct6,ct7)
If SQLExec(goapp.bdconn,"call actualizacuentasc(?nt1,?nt2,?nt3,?nt4,?nt5,?nt6,?nt7,?nidcta1,?nidcta2,?nidcta3,?nidcta4,?nidctai,?nidctae,?nidctat,?id1,?id2,?id3,?id4,?id5,?id6,?id7)")<0
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
******************
Function MuestraMeses()
TEXT TO lc NOSHOW
     SELECT mess FROM fe_autos ORDER BY idautos
ENDTEXT
If SQLExec(goapp.bdconn,lc,"meses")<1
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
******************
Function CreaCliente1(cnruc,crazo,cdire,cciud,cfono,cfax,cdni,cusua,cidpc)
If SQLExec(goapp.bdconn,"SELECT FUNCREACLIENTE(?cnruc,?crazo,?cdire,?cciud,?cfono,?cfax,?cdni,?cusua,?cidpc) as nid","xt")<1 Then
	errorbd(ERRORPROC+ 'Creando Clientes')
	Return 0
Else
	Return xt.nid
Endif
Endfunc
******************
Function MuestraPlanCuentas(cb)
If SQLExec(goapp.bdconn,"CALL PROMUESTRAPLANCUENTAS(?cb)","lctas")<1
	errorbd(ERRORPROC+ 'Mostrando Plan Cuentas')
	Return 0
Else
	Return 1
Endif
Endfunc
******************
Function MuestraDiarioN(cndoc)
If SQLExec(goapp.bdconn,"CALL PROMUESTRADIARIO(?cndoc)","lld")<1
	errorbd(ERRORPROC+ 'Mostrando Libro Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************
Function AnulaAsientoDiario(nid)
If SQLExec(goapp.bdconn,"CALL PROANULASIENTODIARIO(?nid)")<0
	errorbd(ERRORPROC+ 'Anulando Asiento del Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
******************
Function MuestraSoloCuenta(ccta)
If SQLExec(goapp.bdconn,"CALL ProSoloDatoCuenta(?ccta)",'destinos')<0
	errorbd(ERRORPROC+ 'Mostrando Solo Datos de Cuenta')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************
Function CancelaDctosComprasPorCaja(nidauto,opt)
If SQLExec(goapp.bdconn,"CALL ProCancelaDctosComprasPorCaja(?nidauto,?opt)")<0
	errorbd(ERRORPROC+ 'Cancelando Documentos de Caja')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************
Function MostrarMarcas(cb)
If SQLExec(goapp.bdconn,"CALL PROMUESTRAMARCAS(?cb)","cmarcas")< 1 Then
	errorbd(ERRORPROC+ ' Consultando Marcas')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************
Function MostrarLineas(cb,nidg)
If SQLExec(goapp.bdconn,"CALL PROMUESTRALINEAS(?cb,?nidg)","clineas")< 1 Then
	errorbd(ERRORPROC+' Obteniendo Lineas')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************
Function CancelaDctosVendedor(idrv,opt,idr)
If SQLExec(goapp.bdconn,"CALL PROCANCELADCTOSVENDEDOR(?idrv,?opt,?idr)")< 1 Then
	errorbd(ERRORPROC+' Cancelando Documentos Por Vendedor')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************
Function GrabaDetalleGuias(nidk,ncant,nidg)
If SQLExec(goapp.bdconn,"SELECT FunDetalleGuiaVentas(?nidk,?ncant,?nidg) AS idgv",'idv')<1 Then
	errorbd(ERRORPROC+'Ingresando Detalles Guias de Ventas')
	Return 0
Else
	Return idv.idgv
Endif
Endfunc
*******************
Function AnulaGuiasVentas(nauto,nu)
If SQLExec(goapp.bdconn,"CALL ProAnulaEntregaFisica(?nauto,?nu)")<1 Then
	errorbd(ERRORPROC+'Anulando Guias de Ventas')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************
Function ActualizaVendedorGeneral(nidv)
TEXT to lc noshow
     Update fe_gene set irta=?nidv
ENDTEXT
If SQLExec(goapp.bdconn,lc)<1 Then
	errorbd(lc)
	Return  0
Else
	Return 1
Endif
Endfunc
*******************
Function MostrarSeries()
If SQLExec(goapp.bdconn, "CALL PROMUESTRASERIES()" ,"lseries") < 1
	errorbd(ERRORPROC+' Mostrando Series')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************
Function RedondearMas(tnNro, tnPos)
Return Ceiling(tnNro/10^tnPos)*10^tnPos
Endfunc
**********************
Function RedondearMenos(tnNro, tnPos)
Return Floor(tnNro/10^tnPos)*10^tnPos
Endfunc
**********************
Function PermiteAnularTraspaso(nato)
If SQLExec(goapp.bdconn,"select ifnull(FUNPERMITEANULARTRASPASO(?nato),0) as Ret","ret")<1 Then
	errorbd(ERRORPROC+ ' Verificando Traspasos')
	Return 0
Else
	If Val(ret.ret)=0 Then
		Return 1
	Else
		Return 0
	Endif
Endif
Endfunc
**********************
Function PermitemodificarGuiasCompras(nid)
If SQLExec(goapp.bdconn,"select ifnull(FUNPERMITEANULARGUIASCOMPRAS(?nid),0) as Retg","retg")<1 Then
	errorbd(ERRORPROC+ ' Verificando Canjes de Guias de Compras')
	Return 0
Else
	If Val(retg.retg)=0 Then
		Return 1
	Else
		Return 0
	Endif
Endif
Endfunc
**********************
Function TieneTraspasoAutomatico(xit)
If SQLExec(goapp.bdconn,"select ifnull(FunVerificaTraspasoAutomatico(?xit),0) as Rett","rett")<1 Then
	errorbd(ERRORPROC+ ' Verificando Trasposos Con este Documento')
	Return 0
Else
	If Val(rett.rett)=0 Then
		Return 1
	Else
		Return 0
	Endif
Endif
Endfunc
*******************
Function BuscarSeries1(ns,ctdoc)
Local cser As String
If SQLExec(goapp.bdconn,"CALL PROBUSCASERIES(?ns,?ctdoc)","series")<1
	errorbd(ERRORPROC+ ' Mostrando Series 1')
	Return 0
Else
	If SERIES.idserie<=0
		Messagebox("Serie No Registrada",48,MSGTITULO)
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
*******************
Function MuestraCostos(nidc)
If SQLExec(goapp.bdconn,"CALL PROmuestraCostos(?nidc)","lcostos")<1
	errorbd(ERRORPROC+ ' Mostrando Costos')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************
Function CambiaCostos(idcosto1,idcosto2)
If SQLExec(goapp.bdconn,"CALL PROCambiaCostos(?idcosto1,?idcosto2)")<1 Then
	errorbd(ERRORPROC+ ' Cambiando Id Costos')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************
Function LeerIpServidor(cSection, cEntry, cINIFile)
Local cDefault, cRetVal, nRetLen
cDefault = ""
cRetVal = Space(255)
nRetLen = Len(cRetVal)
Declare Integer GetPrivateProfileString In WIN32API ;
	STRING cSection, String cEntry, ;
	STRING cDefault, String @cRetVal, ;
	INTEGER nRetLen, String cINIFile
nRet = GetPrivateProfileString(cSection, cEntry, cDefault, ;
	@cRetVal, nRetLen, cINIFile)
Return Alltrim(Left(cRetVal, nRetLen))
Endfunc
*******************
Function DIletras(xt,tm)
Local cimporte
cimporte=N2L(xt)
cnuc=Alltrim(Str(xt,10,2))
npos=At(".",cnuc)
If tm='S' Then
	cm= "NUEVOS SOLES"
Else
	cm="DOLARES AMERICANOS"
Endif
Do Case
Case npos=0
	ccadena='00'+'/100 '+cm
Case Len(Substr(cnuc,npos+1))=1
	ccadena=Substr(cnuc,npos+1,1)+'0'+'/100 ' +cm
Otherwise
	ccadena=Substr(cnuc,npos+1,2)+'/100 '+cm
Endcase
cimporte=cimporte+' Con '+ccadena
Return cimporte
Endfunc
*******************
Function ActualizaZonaClientes(nidclie,nidz)
If SQLExec(goapp.bdconn,"CALL PROActualizaZonas(?nidclie,?nidz)")<1 Then
	errorbd(ERRORPROC+ ' Actualizando Zonas')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************
Function Dvendedor(nidv1,CALIAS)
Select (CALIAS)
Locate For idven=nidv1
If Found() Then
	Return 1
Else
	Return 0
Endif
Endfunc
*****************
Function DValorCostos(nidc1)
If SQLExec(goapp.bdconn,"CALL PROdcosto(?nidc1)","lcosto")<1 Then
	errorbd(ERRORPROC+ ' Mostrando Costos')
	Return 0
Else
	Return 1
Endif
Endfunc
*****************
Function AcCabecera(nau)
If SQLExec(goapp.bdconn,"CALL PROAcCabcera(?nau)")<1 Then
	errorbd(ERRORPROC+ ' Actualizando Cabecera Traspas')
	Return 0
Else
	Return 1
Endif
Endfunc
*****************
Function MuestraCtasBancos()
If SQLExec(goapp.bdconn,"CALL PROmuestraCtasBancos()","lctasb")<1 Then
	errorbd(ERRORPROC+ ' Mostrando Lista de Cuentas de Bancos')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************
Function MuestraMediosPago()
If SQLExec(goapp.bdconn,"CALL PROmuestraMediosPago()","MPago")<1 Then
	errorbd(ERRORPROC+ ' Mostrando Medios de Pago')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************
Function MuestraLCaja(cndoc)
If SQLExec(goapp.bdconn,"CALL PROMUESTRALCAJA(?cndoc)","llc")<1
	errorbd(ERRORPROC+ 'Mostrando Libro Caja')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************
Function EJECUTARP(tcComando As String ,lp As String ,NCursor As String )
Local lResultado As Integer
NCursor = Iif(Vartype(NCursor) <> "C", "", NCursor)
If Empty(NCursor) Then
	lR = SQLExec(goapp.bdconn, 'CALL ' +tcComando + lp)
Else
	lR = SQLExec(goapp.bdconn, 'CALL ' +tcComando + lp,NCursor)
Endif
If lR>0 Then
	Return 1
Else
	Return 0
Endif
Endfunc
***************
Function EJECUTARF(tcComando As String ,lp As String ,NCursor As String )
Local lResultado As Integer
NCursor = Iif(Vartype(NCursor) <> "C", "", NCursor)
If Empty(NCursor) Then
	lR = SQLExec(goapp.bdconn, 'Select  ' +tcComando + lp)
Else
	lR = SQLExec(goapp.bdconn, 'Select  ' +tcComando + lp +' as Id ',NCursor)
Endif
If lR>0 Then
	Return 1
Else
	Return 0
Endif
Endfunc
***************
Function EJECUTARS(tcComando As String ,lp As String ,NCursor As String )
Local lResultado As Integer
NCursor = Iif(Vartype(NCursor) <> "C", "", NCursor)
If Empty(NCursor) Then
	lR = SQLExec(goapp.bdconn, 'SELECT ' +tcComando + lp)
Else
	lR = SQLExec(goapp.bdconn, 'SELECT ' +tcComando + lp,NCursor)
Endif
If lR>0 Then
	Return 1
Else
	Return 0
Endif
Endfunc
***************
Function EJECUTACONSULTA(tcComando As String ,NCursor As String )
Local lResultado As Integer
NCursor = Iif(Vartype(NCursor) <> "C", "", NCursor)
If Empty(NCursor) Then
	lR = SQLExec(goapp.bdconn, 'SELECT ' +tcComando)
Else
	lR = SQLExec(goapp.bdconn, 'SELECT ' +tcComando,NCursor)
Endif
If lR>0 Then
	Return 1
Else
	Return 0
Endif
Endfunc
***************
Function MuestraPresentaciones(npara1,npara2,npara3,cur)
goapp.npara1=npara1
goapp.npara2=npara2
goapp.npara3=npara3
lc='PROMUESTRAPRESENTACIONES'
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Mostrando Presentaciones')
	Return 0
Else
	Return 1
Endif
Endfunc
******************
Function CreaPresentaciones(cdes1,nct1,cur)
goapp.npara1=cdes1
goapp.npara2=nct1
lc='FunCreaPresentaciones'
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Creando Presentaciones')
	Return 0
Else
	Return 1
Endif
Endfunc
******************
Function ActualizaPresentaciones(cdes1,nct1,nidpr,opt)
goapp.npara1=cdes1
goapp.npara2=nct1
goapp.npara3=nidpr
goapp.npara4=opt
lc='ProActualizaPresentaciones'
cur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Actualizando Presentaciones')
	Return 0
Else
	Return 1
Endif
Endfunc
******************
Function IngresaSueldosYPagos(nimpoe,nactae,dFecha,ctipo,nidus,nidcaja,nidem,cdeta)
If SQLExec(goapp.bdconn,"SELECT  FUNINGRESAPAGOSEMPLEADOS(?nimpoe,?nactae,?dfecha,?ctipo,?nidus,?nidcaja,?nidem,?cdeta) as ide","lpg")<1
	errorbd(ERRORPROC+ 'Ingresando Pagos')
	Return 0
Else
	Return lpg.ide
Endif
Endfunc
******************
Function AnulaSueldosYPagos(nidp)
If SQLExec(goapp.bdconn,"CALL PROANULAPAGOSEMPLEADOS(?nidp)")<1
	errorbd(ERRORPROC+ 'Anulando Pagos')
	Return 0
Else
	Return 1
Endif
Endfunc
****************
Function AnulaSueldosYPagos1(nidca)
If SQLExec(goapp.bdconn,"CALL PROANULAPAGOSEMPLEADOS1(?nidca)")<1
	errorbd(ERRORPROC+ 'Anulando Pagos Ingresados A Empleados Por Caja')
	Return 0
Else
	Return 1
Endif
Endfunc
****************
Function CancelaDeudas1(dfech,dfevto,nacta,cndoc,cesta,cmone,cb1,ctipo,nctrl,cnrou)
If SQLExec(goapp.bdconn,"SELECT FUNINGRESAPAGOSdeudas1(?dfech,?dfevto,?nacta,?cndoc,?cesta,?cmone,?cb1,?ctipo,?nctrl,?cnrou) as Nid","dd")<=0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return dd.nid
Endif
Endfunc
******************
Function DultimoPrecio(nidc,nidar)
If SQLExec(goapp.bdconn,"CALL PROULTIMOPRECIOVENTA(?nidc,?nidar)","pr")<=0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return pr.precio
Endif
Endfunc
******************
Function MuestraPresentaciones1(cur)
lc='PROMUESTRAPRESENTACIONESP'
If EJECUTARP(lc,'',cur)=0 Then
	errorbd(ERRORPROC+ 'Mostrando Presentaciones Por Producto')
	Return 0
Else
	Return 1
Endif
Endfunc
******************
Function CreaProductosE(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21)
lc='FUNCREAPRODUCTOS'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Creando Nuevos Productos')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
*************************
Function IngresaEpta(np1,np2,np3,np4)
lc='FUNCREAEPTA'
cur="XEpta"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Creando Nuevos Presentaciones de Productos')
	Return 0
Else
	Return Xepta.Id
Endif
Endfunc
*************************
Function ModificaProductosE(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22)
lc='PROACTUALIZAPRODUCTOS'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22)
ENDTEXT
If EJECUTARP(lc,lp,'')=0 Then
	errorbd(ERRORPROC+ 'Editando Productos')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function ActualizaEpta(np1,np2,np3,np4,np5,np6)
lc='PROACTUALIZAEPTA'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
ENDTEXT
If EJECUTARP(lc,lp,'')=0 Then
	errorbd(ERRORPROC+ 'Editando Presentacions de Productos')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function InsertaDetalleCompra(np1,np2,np3,np4,np5,np6,np7,np8,np9)
lc='ProIngresaDetalleCompra'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
goapp.npara9=np9
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9)
ENDTEXT
If EJECUTARP(lc,lp,'')=0 Then
	errorbd(ERRORPROC+ 'Editando Presentacions de Productos')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function ActualizaDetalleCompra(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10)
lc='ProEditaDetalleCompra'
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
If EJECUTARP(lc,lp,'')=0 Then
	errorbd(ERRORPROC+ 'Editando Presentaciones de Productos')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function MuestraPresentacioneXProducto(np1)
lc='ProMuestraPresentacionesXProducto'
cur='Listapr'
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Mostrando Presentacions de Productos')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function IngresaDpedidosE(np1,np2,np3,np4,np5,np6,np7)
lc='FunIngresaDPedidos'
cur="DP1"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Detalle de Pedidos')
	Return 0
Else
	Return Dp1.Id
Endif
Endfunc
*************************
Function ActualizaDpedidosE(np1,np2,np3,np4,np5,np6,np7,np8)
lc='ProActualizaDetallePedidos'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Actualizando Detalle de Pedidos')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function MuestraCostosParaVenta(np1)
lc='ProMuestraCostosParaVenta'
cur="listaprecios"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Mostrando Lista de Costos')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function FacturaPedidosXUnidades(np1)
lc='ProFacturaPedidos'
cur=""
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Facturando Pedidos')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function INGRESAKARDEXU(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15)
Local cur As String
lc='FunIngresaKardex1'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Kardex x Unidades')
	Return 0
Else
	Return kardexu.Id
Endif
Endfunc
*************************
Function MuestraPlanCuentas1(np1,cur)
lc="PROMUESTRAPLANCUENTAS"
goapp.npara1=np1
TEXT to lp noshow
       (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Mostrando Plan de Cuentas ')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function MuestraPlanCuentas0(np1,np2,cur)
lc="PROMUESTRACUENTAS"
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
       (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Mostrando Plan de Cuentas ')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function ActualizaPlanCuentas(np1,np2,np3,np4,np5,np6,np7)
Local cur As String
lc='ProActualizaPlanCuentas'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Actualizando Plan de Cuentas')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function IngresaPlanCuentas(np1,np2,np3,np4,np5,np6)
Local cur As String
lc='FunCreaPlanCuentas'
cur="Ct"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Plan de Cuentas')
	Return 0
Else
	Return ct.Id
Endif
Endfunc
*************************
Function IngresaCtasCtesV(np1,np2,np3,np4,np5,np6,np7)
Local cur As String
lc='FunIngresaCtasCtesV'
cur="Xt"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Cuentas Corrientes-Clientes')
	Return 0
Else
	Return xt.Id
Endif
Endfunc
*************************
Function IngresaCtasCtesC(np1,np2,np3,np4,np5,np6,np7)
Local cur As String
lc='FunIngresaCtasCtesC'
cur="Xt"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Cuentas Corrientes-Proveedores')
	Return 0
Else
	Return xt.Id
Endif
Endfunc
*************************
Function ActualizaCtasCtesV(np1,np2,np3,np4,np5,np6,np7,np8)
Local cur As String
lc='ProActualizaCtasCtesV'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Cuentas Corrientes-Clientes')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function ActualizaCtasCtesC(np1,np2,np3,np4,np5,np6,np7,np8)
Local cur As String
lc='ProActualizaCtasCtesC'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Cuentas Corrientes-Proveedores')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function  AnulaRetencion(np1)
Local cur As String
lc='ProAnulaIngresoCtaCteV'
cur=""
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Anulando Ingresos  a Ctas Ctes de Clientes')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function  AnulaPercepcion(np1)
Local cur As String
lc='ProAnulaIngresoCtaCteC'
cur=""
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Anulando Ingresos  a Ctas Ctes de Proveedores')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function IngresaOTrasCompras(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16)
Local cur As String
lc='FunIngresaOtrasCompras'
cur="OtC"
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Otras Compras')
	Return 0
Else
	Return Otc.Id
Endif
Endfunc
*************************
Function ActualizaOtrasCompras(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16)
Local cur As String
lc='ProActualizaOtrasCompras'
cur=" "
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Actualizando Otras Compras')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function VerificaSihayDctoVta(np1,np2)
Local cur As String
lc='ProVerificaVta'
cur="DV"
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Verificando Si Hay Nº Dcto De Venta')
	Return 0
Else
	If REGDVTO("DV")>0 Then
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
************************
Function ConsultarVentas(np1,np2)
Local cur As String
lc='ProConsultaVtas'
cur="DV1"
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Consultando Dcto De Venta')
	Return 0
Else
	If REGDVTO("DV1")>0 Then
		Return 1
	Else
		Return 0
	Endif
Endif
Endfunc
************************
Function ConsultaDetalles(np1)
Local cur As String
lc='ProConsultaDetalleVtas'
cur="Detvtas"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Consultando Detalle De Ventas')
	Return 0
Else
	Return 1
Endif
Endfunc
************************
Function IngresaMprN0(np1,np2,np3,np4)
Local cur As String
lc='FunCreaNivel0'
cur="Xo"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Nivel 0 ')
	Return 0
Else
	Return 1
Endif
Endfunc
************************
Function IngresaMprN1(np1,np2,np3,np4)
Local cur As String
lc='FunCreaNivel1'
cur="Xo"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Nivel 1 ')
	Return 0
Else
	Return 1
Endif
Endfunc
************************
Function EnlazaChequesCreditos(np1,np2)
Local cur As String
lc='FunCreaingresochequescr'
cur="X2"
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Cheques Con Facturas ')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function IngreSaCheques(np1,np2,np3,np4,np5,np6,np7,np8)
Local cur As String
lc='FUNINGRESACHEQUES'
cur="Xche"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Cheques  ')
	Return 0
Else
	Return xche.Id
Endif
Endfunc
*************************
Function ActualizaStock1(ncoda,nalma,ncant,ctipo,equi)
If SQLExec(goapp.bdconn,"CALL ASTOCK(?ncoda,?nalma,?ncant,?ctipo,?equi)")<1 Then
	errorbd(ERRORPROC+'Actualizando Stock')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function NuevoCosto(np1,np2,np3,np4,np5,np6,np7,np8)
Local cur As String
lc='FUNINGRESACOSTOS'
cur="XCostos"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
goapp.npara8=np8
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Costos  ')
	Return 0
Else
	Return xcostos.Id
Endif
Endfunc
**************************
Function ActualizaSoloCosto(np1,np2,np3,np4,np5,np6)
Local cur As String
lc='ProSoloCostosProductos'
cur="XCostos"
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
	errorbd(ERRORPROC+ 'Actualizando Solo Costos de Productos  ')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Procedure MuestramouseMove(Ctex)
With Ctex
	.ForeColor= Rgb(255,0,0)
	.FontUnderline= .T.
Endwith
Endproc
**************************
Procedure MuestramouseLeave(Ctex)
With Ctex
	.ForeColor= Rgb(0,0,0)
	.FontUnderline= .F.
Endwith
Endproc
**************************
Function RegistraCanjesC(np1,np2,np3,np4)
Local cur As String
lc='ProIngresaCanjesC'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Canjes de Créditos  ')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function ActualizaCanjesC(np1,np2,np3)
Local cur As String
lc='ProActualizaCanjesC'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Actualizando Canjes de Créditos  ')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************
Function DesactivaDCreditos(np1)
Local cur As String
lc='PRODESACTIVACREDITOS'
cur=""
goapp.npara1=np1
TEXT to lp noshow
	     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Actualizando el Ingreso de Créditos  ')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************
Function VerificaSiEstaCanjeado(np1)
Local cur As String
lc='FunVerificaSiestaCanjeado'
cur="IdCanje"
goapp.npara1=np1
TEXT to lp noshow
	     (?goapp.npara1)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Verificando Si Pertenece A Un Documeno Canjeado')
	Return 0
Else
	Return idcanje.Id
Endif
Endfunc
****************************
Function VerificaSiHayPagosCanjesC(np1)
Local cur As String
lc='FunVerificaSiestaPagadoC'
cur="IdCanjePagadoC"
goapp.npara1=np1
TEXT to lp noshow
	     (?goapp.npara1)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Verificando Si Tiene Pagos ACuenta')
	Return 0
Else
	Return idcanjepagadoC.Id
Endif
Endfunc
****************************
Function RegistraCanjesD(np1,np2,np3,np4)
Local cur As String
lc='ProIngresaCanjesD'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Canjes de Créditos  ')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function ActualizaCanjesD(np1,np2,np3)
Local cur As String
lc='ProActualizaCanjesD'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Actualizando Canjes de Créditos  ')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************
Function VerificaSiEstaCanjeadoD(np1)
Local cur As String
lc='FunVerificaSiestaCanjeadoD'
cur="IdCanje"
goapp.npara1=np1
TEXT to lp noshow
	     (?goapp.npara1)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Verificando Si Pertenece A Un Documeno Canjeado')
	Return 0
Else
	Return idcanje.Id
Endif
Endfunc
****************************
Function VerificaSiHayPagosCanjesD(np1)
Local cur As String
lc='FunVerificaSiestaPagadoD'
cur="IdCanjePagadoD"
goapp.npara1=np1
TEXT to lp noshow
	     (?goapp.npara1)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Verificando Si Tiene Pagos ACuenta')
	Return 0
Else
	Return idcanjepagadoD.Id
Endif
Endfunc
***************************
Function siestaregistradodctopago(np1)
Local cur As String
lc='FunSiestaRegistradoDctoPago'
cur="IdPago"
goapp.npara1=np1
TEXT to lp noshow
	     (?goapp.npara1)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Verificando Si Tiene Pagos ACuenta')
	Return 0
Else
	Return idpago.Id
Endif
Endfunc
***************************
Function DesactivaDDeudas(np1)
Local cur As String
lc='PRODESACTIVADEUDAS'
cur=""
goapp.npara1=np1
TEXT to lp noshow
	     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Actualizando el Ingreso de Deudas  ')
	Return 0
Else
	Return 1
Endif
Endfunc
***************************
Function DesactivaCreditos(np1)
Local cur As String
lc='PRODESACTIVARCREDITOS'
cur=""
goapp.npara1=np1
TEXT to lp noshow
	     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Actualizando el Ingreso de Créditos  ')
	Return 0
Else
	Return 1
Endif
Endfunc
***************************
Function CreaConceptosCaja(np1,np2,np3,np4,np5,np6,np7)
Local cur As String
lc='FUNCREACONCEPTOSCAJA'
cur="Conc"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Creando Conceptos De Caja  ')
	Return 0
Else
	Return Conc.Id
Endif
Endfunc
***************************
Function  ModificaConcetposCaja(np1,np2,np3,np4,np5)
Local cur As String
lc='PROEDITACONCEPTOSCAJA'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Editando Conceptos De Caja  ')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function ActualizaStock12(np1,np2,np3,np4,np5,np6)
Local cur As String
lc='PROACTUALIZASTOCK'
cur=""
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
	errorbd(ERRORPROC+ 'Actualizando Stock')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function ActualizaKardexU(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17)
Local cur As String
lc='PROACTUALIZAKARDEX1'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Actualizando Kardex ')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function BuscaClienteRuc(np1)
lc='PROMuestraclientes'
cur="lp"
goapp.npara1=np1
goapp.npara2=1
goapp.npara3=0
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+'Buscando Cliente Por RUC')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function ModificaProductos(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24,np25,np26)
Local cur As String
lc='PROACTUALIZAPRODUCTOS'
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
goapp.npara25=np25
goapp.npara26=np26
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Actualizando Productos ')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function MuestraTodosLosProductos(np1,np2)
Local cur As String
lc='PROMUESTRAtodoslosPRODUCTOS'
cur="Productos"
goapp.npara1=np1
goapp.npara2=np2
TEXT  to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Mostrando Todos Los Productos ')
	Return 0
Else
	Return 1
Endif
Endfunc
*****************************
Function RegistraCreditos(na,codc,dFecha,nidv,nimpoo,nidus,nidtda,nn,cpc,dfevto,nimpo,cdocp,crefe,ctipo)
Local vd As Integer
vd=1
idrc=IngresaCabeceraCreditos(na,codc,dFecha,nidv,nimpoo,nidus,nidtda,nn,cpc)
If idrc>0 Then
	If IngresaDcreditos(dFecha,dfevto,nimpo,cdocp,'C','S',crefe,ctipo,idrc,goapp.nidusua)=0 Then
		vd=0
	Endif
Else
	vd=0
Endif
Return  vd
Endfunc
**********************
Function Generanumero(numero,nsgte,idserie)
If Val(numero)>=nsgte
	If GeneraCorrelativo(Val(numero)+1,idserie)=0 Then
		Return 0
	Else
		Return 1
	Endif
Else
	Return 1
Endif
**********************
Function DesactivaCuentaPlanCuentas(np1)
Local cur As String
lc='PRODesactivaPlanCuentas'
cur=""
goapp.npara1=np1
TEXT  to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Desactivando Plan de Cuentas ')
	Return 0
Else
	Return 1
Endif
Endfunc
****************
Function MuestraPlanCuentasX(np1,np2,cur)
lc="PROMUESTRACUENTAS"
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
       (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Mostrando Plan de Cuentas ')
	Return 0
Else
	Return 1
Endif
Endfunc
********************
Function CuentaActiva(np1)
lc="PROCuentaActiva"
cur="Idcta"
goapp.npara1=np1
TEXT to lp noshow
       (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Or idcta.idcta=0  Then
	errorbd(ERRORPROC+ 'No Es posible Desactivar esta Cuenta ')
	Return 0
Else
	Return 1
Endif
Endfunc
******************
Function ActualizaValoresCtasC(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24)
Local cur As String
lc='ProActualizaCuentasc'
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
	errorbd(ERRORPROC+ 'Actualizando Valores de Cuentas ')
	Return 0
Else
	Return 1
Endif
Endfunc
******************
Function IngresaValoresCtasC(nt1,nt2,nt3,nt4,nt5,nt6,nt7,nt8,nidcta1,nidcta2,nidcta3,nidcta4,nidctai,nidctae,nidcta7,nidctat,ct1,ct2,ct3,ct4,ct5,ct6,ct7,ct8,nidc)
If SQLExec(goapp.bdconn,"CALL Ingresacuentas(?nt1,?nt2,?nt3,?nt4,?nt5,?nt6,?nt7,?nt8,?nidcta1,?nidcta2,?nidcta3,?nidcta4,?nidctai,?nidctae,?nidcta7,?nidctat,?ct1,?ct2,?ct3,?ct4,?ct5,?ct6,?ct7,?ct8,?nidc)")<0
	errorbd(ERRORPROC+' Ingresando Valores de Compras')
	Return 0
Else
	Return 1
Endif
Endfunc
******************
Function IngresaValoresCtasC1(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24,np25)
Local cur As String
lc='IngresaCuentas'
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
goapp.npara25=np25
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Cuentas ')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************
Function VerificaSiguiaVtaEstaIngresada(np1)
Local cur As String
lc='FunVerificaSiGuiaEstaIngresada'
cur="guia"
goapp.npara1=np1
TEXT  to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Al Verificar Guia de Venta')
	Return 0
Else
	If guia.Id>0 Then
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
*******************
Function AplicaTipoCambio(np1,np2,np3)
Local cur As String
lc='ProActualizaTipoCambio'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT  to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' No se Actualizo El Tipo de Cambio')
	Return 0
Else
	Return 1
Endif
Endfunc
***************************
Function Dcorrelativo(np1,np2)
lc='dcorrelativo'
cur="cco"
goapp.npara1=np1
goapp.npara2=np2
TEXT  to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' No se Obtuvo el Correlativo Para este Documento')
	Return 0
Else
	Return cco.Id
Endif
Endfunc
********************************
Function CreaProveedor(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12)
lc='FunCreaProveedor'
cur="idp"
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Al Crear un Nuevo Proveedor')
	Return 0
Else
	Return idp.Id
Endif
Endfunc
**********************************
Function EditaProveedor(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12)
lc='PROACTUALIZAPROVEEDOR'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Al Editar un Proveedor')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************
Function CreaMarcas(np1,np2,np3)
lc='FUNCREAMARCAS'
cur="idm"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Al Crear un Nueva Marca')
	Return 0
Else
	Return idm.Id
Endif
Endfunc
*********************
Function CreaLineas(np1,np2,np3,np4,np5,np6)
lc='FUNCREALINEA'
cur="idcat"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Al Crear un Nueva Linea')
	Return 0
Else
	Return idcat.Id
Endif
Endfunc
********************
Function CreaProductos(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24)
lc='FUNCREAPRODUCTOS'
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
	errorbd(ERRORPROC+ 'Creando Nuevos Productos')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
********************
Function MuestraDctos1(np1,ccursor)
lc='PROMUESTRADCTOS'
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ 'Mostrando Documentos')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************
Function MuestraProductos1(np1,np2,ccursor)
lc='PROMUESTRAPRODUCTOS'
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ 'Mostrando Una Lista de Productos')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************
Function MuestraProveedoresX(np1,np2,np3,ccursor)
lc='PROMUESTRAPROVEEDOR'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ 'Mostrando Proveedores')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************************
Function MuestraClientesX(np1,np2,np3,ccursor)
lc='PROMUESTRACLIENTES'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ 'Mostrando Clientes')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************************
* DOTHERM.PRG
* =DoTherm(90, "Texto label", "Titulo")
* =DoTherm(-1, "Teste2", "Titulo") && Continuo
* =DoTherm() && Desactiva
Function Dotherm(tnPercent, tcLabelText, tcTitleText)
If Not Pemstatus(_Screen , "oThermForm", 5)
	_Screen.AddProperty("oThermForm", "")
Endif
If Empty(tnPercent)
	Try
		_Screen.oThermForm.Release()
	Catch
	Endtry
	_Screen.oThermForm = Null
	Return
Endif
If Type("_Screen.oThermForm.Therm") <> "O"
	Do CreateTherm
Endif
Local loThermForm As Form
loThermForm = _Screen.oThermForm
If Not Empty(tcLabelText)
	loThermForm.ThermLabel.Caption = tcLabelText
Endif
If Not Empty(tcTitleText)
	loThermForm.Caption = tcTitleText
Endif
If tnPercent = -1
	loThermForm.Therm.Marquee = .T.
Else
	If loThermForm.Therm.Marquee = .T.
		loThermForm.Therm.Marquee = .F.
	Endif
	loThermForm.Therm.Value = tnPercent
Endif
loThermForm.Visible = .T.
Return
*****************************************
Procedure CreateTherm
Local loForm As Form
loForm = Createobject("FORM")
_Screen.oThermForm = loForm
Local lnBorder, liThermHeight, liThermWidth, liThermTop, liThermLeft
lnBorder = 7
With loForm As Form
	.ScaleMode = 3 && Pixels
	.Height = 48
	.HalfHeightCaption = .T.
	.Width = 300
	.AutoCenter = .T.
	.BorderStyle = 3 && Fixed dialog
	.ControlBox = .F.
	.Closable = .F.
	.MaxButton = .F.
	.MinButton = .F.
	.Movable = .F.
	.AlwaysOnTop = .T.
	.AllowOutput = .F.
	.ShowWindow= 1
	.Newobject("Therm","ctl32_progressbar", "PR_ctl32_progressbar.vcx", Locfile("FoxyPreviewer.app"))
	.Newobject("ThermLabel", "Label")
	.ThermLabel.Visible = .T.
	.ThermLabel.FontBold = .T.
	.ThermLabel.Top = 4
	.ThermLabel.Width = .Width - (lnBorder * 2)
	.ThermLabel.Alignment = 2 && Center
	liThermHeight = .Height - (lnBorder * 2) - .ThermLabel.Height
	liThermWidth = .Width - (lnBorder * 2)
	.Visible = .T.
Endwith
liThermTop = lnBorder + 20
liThermLeft = lnBorder
With loForm.Therm
	.Top = liThermTop
	.Left = liThermLeft
	.Height = liThermHeight
	.Width = liThermWidth
	.MarqueeSpeed = 30
	.MarqueeAnimationSpeed = 30
	.Visible = .T.
	.Caption = ""
Endwith
Endproc
************************************************
Function DevuelveStocks(np1,ccursor)
lc='PRODSTOCKS'
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Obteniendo Stocks')
	Return 0
Else
	Return 1
Endif
Endfunc
********************
Function MostrarMarcasX(np1,ccursor)
lc='PROMUESTRAMARCAS'
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Mostrando Marcas')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************
Function MostrarLineasX(np1,np2,ccursor)
lc='PROMUESTRALINEAS'
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Mostrando Lineas')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************
Function MuestraGruposX(np1,ccursor)
lc='PROMUESTRAGRUPOS'
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Mostrando Grupos')
	Return 0
Else
	Return 1
Endif
Endfunc
************************
Function MuestraFletesX(np1,ccursor)
lc='PROMUESTRAFLETES'
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Mostrando Fletes')
	Return 0
Else
	Return 1
Endif
Endfunc
***************************
Function RetornaNAlmacen(np1)
lc='ProdNAlmacen'
cur="Calmacen"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Retornando Nombre Almacen')
	Return 'x'
Else
	Return calmacen.nomb
Endif
Endfunc
******************************
Function MuestraPlanCuentasX(np1,cur)
lc='PROMUESTRAPLANCUENTAS'
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Mostrando Plan Cuentas')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function CreaCtasBancos(np1,np2,np3,np4,np5)
cur="Creacta"
lc='FUNCREACTASBANCOS'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Creando Cuentas de Bancos')
	Return 0
Else
	Return creacta.Id
Endif
Endfunc
**********************
Function ActualizaCtasBancos(np1,np2,np3,np4,np5,np6,np7)
lc='PROACTUALIZACTASBANCOS'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Actualizando Cuentas de Bancos')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************
Function MuestraAvalesX(np1,np2,np3,ccursor)
lc='PROMuestraAvales'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ 'Mostrando Lista Avales')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************
Function MuestraVendedoresX(np1,ccursor)
lc='PROMUESTRAVENDEDORES'
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC + ' Mostrando Lista Vendedores')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************
Function IngresaCreditosNormal(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17)
lc='FUNREGISTRACREDITOS'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Créditos')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
******************************
Function IngresaDatosLCaja(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13)
lc='FUNIngresaCajaBancos'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Registrando EN Caja y Bancos')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
**********************
Function ActualizaDatosLCaja(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
lc='PROActualizaCajaBancos'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Actualizando Libro Caja Y Bancos')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************
Function CancelaDeudas(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
lc='FUNINGRESAPAGOSdeudas'
cur="dd"
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Cancelando Ctas Por Pagar')
	Return 0
Else
	Return dd.Id
Endif
Endfunc
************************
Function AnulaIngresosLCaja(np1)
lc='PROANULALCAJA'
cur=""
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Anulando Datos de Libro Caja y Bancos')
	Return 0
Else
	Return 1
Endif
Endfunc
************************
Function VerificaSiestaRcajayBancos(np1)
lc='FunVerificaSiestaCajaB'
cur="Cb"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Al Verificar Si esta Cancelado Por Caja y Bancos')
	Return 0
Else
	If cb.Id>0 Then
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
**************************
Function IngresaResumenDcto(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24)
lc='FUNingresaCabeceracv'
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
*************************
Function IngresaCaja(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
lc='FUNINGRESACAJA'
cur="Nid"
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
	errorbd(ERRORPROC+' Ingresando a  Caja')
	Return 0
Else
	Return nid.Id
Endif
Endfunc
************************
Function IngresaRetencion(np1,np2,np3,np4,np5,np6,np7)
lc='FunIngresaRRetencion'
cur="Nid"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
goapp.npara7=np7
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Ingresando Resumen de Retenciones del IGV')
	Return 0
Else
	Return nid.Id
Endif
Endfunc
***************************
Function IngresaDretencion(np1,np2,np3,np4,np5,np6,np7,np8,np9)
lc='ProRegistraDretencion'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Ingresando Detalle de Retenciones del IGV')
	Return 0
Else
	Return 1
Endif
Endfunc
***************************
Function AnulaRetencion(np1)
lc='ProDesactivaRetenciones'
cur=""
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Anulando Retenciones del IGV')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function RetencionYaestaRegistrada(np1)
lc='FunVerificaRetencion'
cur="Rete"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Verificando si Ya esta Registrada el No de Retención')
	Return 0
Else
	If rete.Id>0 Then
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
*****************************
Function VerificaSiestaPagoenRetenciones(np1)
lc='FunVerificaSiPagoestaenRetenciones'
cur="PagoR"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Verificando si Ya esta Registrado Como  Retención')
	Return 0
Else
	If pagoR.Id>0 Then
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
**************************************
Function NumeroRetencion()
Local cndoc As String
cndoc=""
If BuscarSeries(1,'12')=0
	Return ""
Else
	i=SERIES.nume
	Do While .T.
		cndoc=Right("0000"+Alltrim(Str(1)),4)+Right("00000000"+Alltrim(Str(i)),8)
		If RetencionYaestaRegistrada(cndoc)=0
			i=i+1
			Loop
		Else
			Exit
		Endif
	Enddo
	Return cndoc
Endif
Endfunc
**********************************
Function RegistraCanjesDRetencion(np1,np2,np3,np4,np5)
Local cur As String
lc='ProIngresaCanjesDRetencion'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Canjes de Créditos  ')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************************
Function IngresaDatosLCajaE(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10)
lc="FunIngresaDatosLcajaE"
cur="Ca"
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
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Datos A Libro Caja Efectivo')
	Return 0
Else
	Return Ca.Id
Endif
Endfunc
**********************
Function ActualizaDatosLCajaE(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10)
lc="ProActualizaDatosLcajaE"
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Actualizando Datos A Libro Caja Efectivo')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************
Function MuestraLCajaE(np1,ccursor)
lc="PROMUESTRALCAJAE"
cur=ccursor
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Mostrando Datos del Libro Caja Efectivo')
	Return 0
Else
	Return 1
Endif
Endfunc
********************
Function AplicaTcCompras(np1,np2,np3)
lc='PROAplicaTcCompras'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,'')=0 Then
	errorbd(ERRORPROC+ ' Aplicando Tipo de Cambio a Documentos de Compras')
	Return 0
Else
	Return 1
Endif
Endfunc
**************
Function AplicaTcVentas(np1,np2,np3)
lc='PROAplicaTcVentas'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,'')=0 Then
	errorbd(ERRORPROC+ ' Aplicando Tipo de Cambio a Documentos de Ventas')
	Return 0
Else
	Return 1
Endif
Endfunc
********************
Function ActualizaPedidoFacturado(np1)
lc="PROActualizaPedidoFacturado"
cur=""
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Actualizando Pedidos Facturados')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************
Function IngresaKardexTraspasos(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12)
lc='FUNINGRESAKARDEX'
cur="dd"
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando el Detalle del Traspaso entre Almacenes')
	Return 0
Else
	Return dd.Id
Endif
Endfunc
************************
Function ActualizaResumenGuiasCompras(np1)
lc="ProCambiaEstadoGuiaCompra"
cur=""
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Actualizando Ingreso de Guias de Compras')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************
Function NoestaIngresadoRGuiaCompra(np1)
lc="FunVerificaIngresoGuiaCompra"
cur="ig"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Verificando Si ya esta Ingresado la Guia de Compra')
	Return 0
Else
	Return ig.Id
Endif
Endfunc
***********************
Function IngresaRGuiaCompra(np1,np2,np3,np4,np5)
cur=""
lc='ProIngresaGuiasCompras'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Guias de Compras')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function ActualizaPrecioKardexGuias11(np1,np2,np3)
cur=""
lc='PROACTUALIZAPRECIOGUIAS'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Actualizando los Items de la Guia de Compras')
	Return 0
Else
	Return 1
Endif
Endfunc
********************
Function VerificaSiestaEnlazadoGC(np1)
lc="FunVerificaSiEstaGC"
cur="ig"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Verificando Si ya esta Ingresado la Guia de Compra')
	Return 0
Else
	Return ig.Id
Endif
Endfunc
******************
Function IngresaGuiasCompras1(np1,np2,np3)
cur=""
lc='ProINGRESAGUIASGC1'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando los Items de la Guia de Compras')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function AplicaTcBancos(np1,np2)
lc="ProAplicaTCBancos"
goapp.npara1=np1
goapp.npara2=np2
cur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Aplicar Correctamente el Tipo de Cambio a las Operaciones en Moneda Extranjera')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************************
Function DDatoCta1(np1,ccursor)
lc="ProSoloDatoCuenta1"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Obtener El Detalle del No de Cuenta')
	Return 0
Else
	Return 1
Endif
Endfunc
******************************
Function  OtorgaOpciones(np1,np2)
lc="ProOtorgaOpciones"
goapp.npara1=np1
goapp.npara2=np2
cur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Asignar Correctamente Los Permisos Especiales a los Usuarios')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************************
Function MostrarMenu1(np1,np2,np3)
cur="menus"
lc='ProMostrarMenu1'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Mostrando Opciones del Menú Lateral')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************************
Function YaestaRegistradoTraspaso(np1,np2)
lc="FunHayTraspaso"
goapp.npara1=np1
goapp.npara2=np2
cur="Tr"
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Verificar si Ya existe este Traspaso')
	Return 0
Else
	If Tr.Id=0 Then
		Return 1
	Else
		Return 0
	Endif
Endif
Endfunc
****************************
Function OcxRegistrado(cClase)
Declare Integer RegOpenKey In Win32API ;
	Integer nHKey, String @cSubKey, Integer @nResult
Declare Integer RegCloseKey In Win32API ;
	Integer nHKey
npos = 0
lEsta = RegOpenKey(-2147483648, cClase, @npos) = 0

If lEsta
	RegCloseKey(npos)
Endif

Return lEsta
Endfunc
*******************************
Function MuestraUsuarios(np1,ccur)
lc="ProMuestraUsuarios"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,ccur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Mostrar los Usuarios del Sistema')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************************
Function MuestraZonaspx(np1,ccursor)
lc="PROMUESTRAZONASP"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Mostrar las Regiones')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************************
Function CreaAlmacenes(np1,np2,np3,np4)
Local cur As String
lc='FunCreaAlmacenes'
cur="Ia"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Creando Almacenes  ')
	Return 0
Else
	Return Ia.Id
Endif
Endfunc
**************************************
Function PermiteIngresox(np1)
lc="FUnVerificaBloqueo"
goapp.npara1=np1
ccursor='v'
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARF(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Obtener el estado del Bloqueo para este Registro')
	Return 0
Else
	Return v.Id
Endif
Endfunc
****************************************
Function BloqueaD(np1,np2,np3)
Local cur As String
lc='ProBloqueaD'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Bloqueando/Desbloqueando Estado de los Documentos ')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************************
Function CreaAlmacen(np1,np2,np3,np4,np5)
cur="Tda"
lc='FunCreaAlmacen'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Creando Almacen')
	Return 0
Else
	Return tda.Id
Endif
Endfunc
*******************************************
Function EditaAlmacen(np1,np2,np3,np4,np5,np6)
cur="Tda"
lc='ProEditaAlmacen'
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
	errorbd(ERRORPROC+ ' Editando Datos del Almacen')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************************************
Function MuestraUsuarios1(np1,np2,np3,ccur)
lc="ProMuestraUsuarios"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,ccur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Mostrar los Usuarios del Sistema')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************************************
Function ActualizaMargenesVtas(np1,np2,np3,np4)
lc="ProActualizaMargenesVta"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
ccur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARP(lc,lp,ccur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Actualizar Margenes de Ventas')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************************************
Function ActualizaComisiones(np1,np2,np3)
lc="ProActualizaComisiones"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
ccur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,ccur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Actualizar Comisiones de Ventas')
	Return 0
Else
	Return 1
Endif
Endfunc
************************************************
Function ActualizaTcProducto(np1,np2)
lc="ProActualizaTcproducto"
goapp.npara1=np1
goapp.npara2=np2
ccur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,ccur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Actualizar Tc A los Productos')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************************************
Function IngresaDatosLCajaT(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13)
lc='FUNIngresaCajaBancosT'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Registrando EN Caja y Bancos Con Ingreso a Caja Efectivo')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
**********************
Function TraspasoDatosLCajaE(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10)
lc="FunTraspasoDatosLcajaE"
cur="Ca"
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
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Datos A Libro Caja Efectivo Por Transferencia')
	Return 0
Else
	Return Ca.Id
Endif
Endfunc
*******************
Function IngresaDatosDiario(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16)
cur="l"
lc="FunIngresaDatosLibroDiario"
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' '+Ingresando Asientos Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
******************
Function ActualizaDatosDiario(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16)
Local cur As String
lc='PROACTUALIZADATOSDIARIO'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Actualizando Asientos del Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************
Function AplicaTcCaja(np1,np2)
lc="ProAplicaTCCaja"
goapp.npara1=np1
goapp.npara2=np2
cur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Aplicar Correctamente el Tipo de Cambio a las Operaciones en Moneda Extranjera')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************************
Function DevuelveStocks1(np1,np2,ccursor)
lc='PRODSTOCKS1'
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Obteniendo Stocks por Producto')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************************
Function YaestaRegistradoTraspaso1(np1,np2,np3)
lc="FunHayTraspaso"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
cur="Tr"
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Verificar si Ya existe este Traspaso')
	Return 0
Else
	If Tr.Id=0 Then
		Return 1
	Else
		Return 0
	Endif
Endif
Endfunc