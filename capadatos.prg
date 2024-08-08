#Define ERRORPROC "Inconveniente "
#Define MSGTITULO "SISVEN"
*DO d:\librerias\crear_exe WITH 'sisven','d:\psysg\','psysg'

*Lparameters tcNombreSistema,cruta,crutaftp
*Para recordar: el orden de los métodos al iniciar el formulario son Load, Init, Show, Activate, GotFocus y para memorizarlo siempre: LISAG
*SET DEFAULT TO d:\thormaster\thor
*DO thor.app
Set Procedure To ple5 Additive
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
Function preguntaguardar(cmsje)
Local r As Integer
cmensaje=Iif(Parameters()=0,"¿Desea Guardar Los Datos Ingresados [SI/NO/Cancelar]?",cmsje)
r=Messagebox(cmensaje,32+3+0,"Sisven")
Return r
Endfunc
************************************
Function REGDVTO(CALIAS)
IF verificaAlias((calias))=0 then
  RETURN 0
ENDIF
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
	BETWEEN(tnAnio, 2000, 9999) And ;
	BETWEEN(tnMes, 1, 12) And ;
	BETWEEN(tnDia, 1, 31) And ;
	NOT Empty(Date(tnAnio, tnMes, tnDia));
	AND dFecha<=fe_gene.fech
Endfunc
*******************************************
Function esFechaValidafvto(dFecha)
Local tnAnio, tnMes, tnDia
tnAnio=Year(dFecha)
tnMes=Month(dFecha)
tnDia=Day(dFecha)
Return ;
	VARTYPE(tnAnio) = "N" And ;
	VARTYPE(tnMes) = "N" And ;
	VARTYPE(tnDia) = "N" And ;
	BETWEEN(tnAnio, 2000, 9999) And ;
	BETWEEN(tnMes, 1, 12) And ;
	BETWEEN(tnDia, 1, 31) And ;
	NOT Empty(Date(tnAnio, tnMes, tnDia))
Endfunc
**************************
Function VerificaAlias(CALIAS)
If Used((CALIAS)) Then
	Return 1
Else
	Return 0
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
*******************************
Function MuestraDctos(cb)
ccursor="dctosv"
Set Procedure To d:\capass\modelos\dctos Additive
odctos=Createobject("dctos")
If odctos.MuestraDctos(cb,ccursor)<1 Then
	goapp.mensajeapp=odctos.cmensaje
	Return 0
Endif
Return 1
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
	TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
          b.rdeu_idpr,a.fech as fepd,a.fevto as fevd,a.ndoc,b.rdeu_impc as impc,a.impo as impd,a.acta as actd,a.dola,
          a.tipo,a.banc,ifnull(c.ndoc,'0000000000') as docd,b.rdeu_mone as mond,a.estd,a.iddeu as nr,
          b.rdeu_idau as idauto,ifnull(c.tdoc,'00') as refe,b.rdeu_idrd,nrou FROM fe_deu as a
          inner join fe_rdeu as b ON(b.rdeu_idrd=a.deud_idrd)
          left join fe_rcom as c ON(c.idauto=b.rdeu_idau)
          WHERE b.rdeu_idpr=<<nidclie>> AND b.rdeu_mone='<<cmoneda>>' and a.acti<>'I' and b.rdeu_acti<>'I'
          ORDER BY c.ndoc,a.ncontrol,a.fech
	ENDTEXT
Else
	TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
	     b.rdeu_idpr,a.fech as fepd,a.fevto as fevd,a.ndoc,b.rdeu_impc as impc,a.impo as impd,a.acta as actd,a.dola,
	     a.tipo,a.banc,ifnull(c.ndoc,'0000000000') as docd,b.rdeu_mone as mond,a.estd,a.iddeu as nr,
	     b.rdeu_idau as idauto,ifnull(c.tdoc,'00') as refe,b.rdeu_idrd,nrou  FROM fe_deu as a
	     inner join fe_rdeu as b ON(b.rdeu_idrd=a.deud_idrd)
	     left join fe_rcom as c ON(c.idauto=b.rdeu_idau)
	     WHERE b.rdeu_idpr=<<nidclie>> AND b.rdeu_mone='<<cmoneda>>' and a.acti<>'I' and b.rdeu_acti<>'I'
	     and b.rdeu_codt=<<opt>> ORDER BY c.ndoc,a.ncontrol,a.fech
	ENDTEXT
Endif
If Ejecutaconsulta(lc,"estado")<1 Then
	Return 0
Else
	Return 1
Endif
Endfunc
**********************************************
Function MuestraSaldosDctosVtas()
TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
	    a.idclie,a.ndoc,a.importe,a.mone,a.banc,a.fech,
	    a.fevto,a.tipo,a.dola,a.docd,a.nrou,a.banco,a.idcred,a.idauto,a.nomv,a.ncontrol FROM vpdtespagoc as a
ENDTEXT
If Ejecutaconsulta(lc,"tmp")<0 Then
	Return 0
Else
	Return 1
Endif
Endfunc
************************************************
Function MuestraSaldosDctosCompras()
TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
      a.idpr as idprov,a.ndoc,a.saldo as importe,a.moneda as mone,a.banc,a.fech,a.fevto,a.tipo,
      a.dola,a.docd,a.nrou,a.banco,a.iddeu,a.idauto,a.ncontrol FROM vpdtespago as a order by a.fevto,a.ndoc
ENDTEXT
If Ejecutaconsulta(lc,"dtmp")<1  Then
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
Function PermiteIngresoACaja(df)
If SQLExec(goapp.bdconn,"SELECT FunVerificaCaja(?DF) AS SW","x")<1
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
	errorbd(ERRORPROC+ 'Verificando Si ya esta Registrado')
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
	errorbd(ERRORPROC+' '+" Ingresando Cabecera Créditos")
	Return 0
Else
	Return rcre.idc
Endif
Endfunc
*********************************
Function IngresaDcreditos(dFecha,dfevto,nimpo,cndoc,cest,Cmon,crefe,ctipo,id1,nidus)
If SQLExec(goapp.bdconn,"SELECT FUNINGRESAdCREDITOS(?dfecha,?dfevto,?nimpo,?cndoc,?cest,?cmon,?crefe,?ctipo,?id1,?nidus) AS IDC","RCRE")<0 Then
	errorbd(ERRORPROC+' '+" Ingresando el Detalle de Créditos")
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
Function ValidaCredito(np1)
If np1=0 Then
	Return 1
Endif
lc='FunVerificaPagos'
cur="lcreditos"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARF(lc,lp,cur)<1 Then
	errorbd(ERRORPROC+ ' Verificando Pagos a Cuenta '+lc)
	Return 0
ENDIF 
If lcreditos.Id>0
   Return 0
ENDIF 
Return 1
Endfunc
**************************
Function retcimporte(nimpo,m)
ci=N2L(nimpo)
cnuc=Alltrim(Str(nimpo,10,2))
npos=At(".",cnuc)
If m="S"
	cm="SOLES"
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
*****************************
Procedure CierraCursor(CALIAS)
Use In (Select((CALIAS)))
Endproc
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
ncon=Abreconexion()
If SQLExec(ncon,"SELECT FUNVERIFICALINEACREDITO(?ccodc,?nmonto,?nlinea) as sw","lcredito")<1 Then
	errorbd(ERRORPROC)
	Return 0
Else
	CierraConexion(ncon)
	If lcredito.SW=0 Then
		Return 0
	Else
		Return 1
	Endif
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
	errorbd(ERRORPROC+'  Actualizando Stock  ')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************************************
Function Actualizanrotraspaso(np1,np2,np3)
Local cu,cu1 As Integer
lc='ProActualizacabeceraporTraspasos'
cur=''
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=goapp.nidusua
goapp.npara5=goapp.nidusua
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Actualizando Pendientes de Entregas Probando')
	Return 0
Else
	Return 1
Endif
Endfunc
************************************************
Function IngresaPdtesEntrega(np1,np2,np3)
idpc=Id()
lc='ProIngresaPdtesEntrega'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=goapp.nidusua
goapp.npara5=Id()
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando  Lista de Productos Como Pendientes de Entrega')
	Return 0
Else
	Return 1
Endif
Endfunc
************************************************
Function ActualizaPdtesEntrega(np1,np2)
lc="ProAnulaPdtesEntrega"
goapp.npara1=np1
goapp.npara2=np2
cur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Actualizando Ingresos A Pendientes de Entrega')
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
	errorbd(ERRORPROC+' Ingresando Cabecera Deudas')
	Return 0
Else
	Return Y.nid
Endif
Endfunc
**************
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
	errorbd(ERRORPROC+'  Ingresando Guias de Compras')
	Return 0
Else
	Return gc.nid
Endif
Endfunc
**************************
Function ActualizaGuiasCompras(nidauto0,nidauto1)
If SQLExec(goapp.bdconn,"CALL PROACTUALIZAGUIASCOMPRAS(?nidauto0,?nidauto1)")<1 Then
	errorbd(ERRORPROC+'  Actualizando Guias Compras')
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
If ValidaCredito(nauto)=1 Then
	Return 1
Else
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
     Select * from vmuestracotizaciones where ndoc=?cd
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
lc="FunHayCompra"
goapp.npara1=cndoc
goapp.npara2=ctdoc
goapp.npara3=nidpr
goapp.npara4=nidauto
cur='xi'
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARF(lc,lp,cur)<1 Then
	errorbd(ERRORPROC+ ' Verificando si esta Registrado Documento de Compras')
	Return 0
Else
	If xi.Id>0 Then
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
************************
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
	DESHACERCAMBIOS()
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
		IF USED("fe_gene") then
*!*			If DatosGlobales()>0 Then
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
Function MuestraDiarioN(cndoc)
If SQLExec(goapp.bdconn,"CALL PROMUESTRADIARIO(?cndoc)","lld")<1
	errorbd(ERRORPROC+ 'Mostrando Libro Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************
Function MuestraDiarioN10(cndoc,ntienda)
If SQLExec(goapp.bdconn,"CALL PROMUESTRADIARIO(?cndoc,?ntienda)","lld")<1
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
lc="ProSoloDatoCuenta"
cur="destinos"
goapp.npara1=ccta
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)<1 Then
	errorbd(ERRORPROC+ ' Mostrando Solo Datos de Cuenta')
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
lc="FunDetalleGuiaVentas"
cur="idv"
goapp.npara1=nidk
goapp.npara2=ncant
goapp.npara3=nidg
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARF(lc,lp,cur)<1 Then
	errorbd(ERRORPROC+ ' Ingresando Detalles Guias de Ventas')
	Return 0
Else
	Return idv.Id
Endif
Endfunc
*******************
Function AnulaGuiasVentas(nauto,nu)
If SQLExec(goapp.bdconn,"CALL ProAnulaEntregaFisica(?nauto,?nu)")<1 Then
	errorbd(ERRORPROC+' Anulando Guias de Ventas')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************
Function ActualizaVendedorGeneral(nidv)
TEXT to lc NOSHOW TEXTMERGE
     Update fe_gene set irta=<<nidv>> where idgene=1
ENDTEXT
If Ejecutarsql(lc)<1 Then
	Return  0
Else
	Return 1
Endif
Endfunc
*******************
Function MostrarSeries()
lp=""
lc="PROMUESTRASERIES"
ccursor="lseries"
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' MostrarSeries')
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
	cm= "Soles"
Else
	cm="Dólares Americanos"
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
	errorbd(ERRORPROC+ ' Actualizando Cabecera Traspaso')
	Return 0
Else
	Return 1
Endif
Endfunc
*!*	**********************
*!*	Function EJECUTARP(tcComando As String ,clparametros As String ,NombCursor As String )
*!*	Local lResultado As Integer
*!*	NCursor = Iif(Vartype(NombCursor) <> "C", "", NombCursor)
*!*	Local laError[1], lcError
*!*	lR=0
*!*	If Empty(NombCursor) Then
*!*		lR = SQLExec(goapp.bdconn, 'CALL ' +tcComando + clparametros)
*!*	Else
*!*		lR = SQLExec(goapp.bdconn, 'CALL ' +tcComando + clparametros,NombCursor)
*!*	Endif
*!*	If lR>0 Then
*!*		Return 1
*!*	Else
*!*		csql='CALL ' +tcComando + clparametros
*!*		Messagebox(csql, 16, MSGTITULO)
*!*		= Aerror(laError)
*!*		lcError = laError(1, 2)
*!*		Messagebox("Inconveniente " + Chr(13) +	lcError, 16, MSGTITULO)
*!*		Return 0
*!*	Endif
*!*	Endfunc
*!*	***************
*!*	Function EJECUTARF(tcComando As String ,lp As String ,NCursor As String )
*!*	Local lResultado As Integer
*!*	NCursor = Iif(Vartype(NCursor) <> "C", "", NCursor)
*!*	Local laError[1], lcError
*!*	If Empty(NCursor) Then
*!*		lR = SQLExec(goapp.bdconn, 'Select ' +Alltrim(tcComando) + Alltrim(lp))
*!*	Else
*!*		lR = SQLExec(goapp.bdconn, 'Select ' +Alltrim(tcComando) + Alltrim(lp) +' as Id ',NCursor)
*!*	Endif
*!*	*WAIT WINDOW 'hola'
*!*	*WAIT WINDOW lR
*!*	If lR>0 Then
*!*		Return 1
*!*	Else
*!*		csql='Select ' +tcComando + Alltrim(lp) +' as Id '
*!*	*	Strtofile(csql,'d:\psystr\error0.txt')
*!*		Messagebox(csql, 16, MSGTITULO)
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
*!*		Return 0
*!*	Endif
*!*	Endfunc
*!*	***************
*!*	Function EJECUTARS(tcComando As String ,lp As String ,NCursor As String )
*!*	Local lResultado As Integer
*!*	NCursor = Iif(Vartype(NCursor) <> "C", "", NCursor)
*!*	If Empty(NCursor) Then
*!*		lR = SQLExec(goapp.bdconn, 'SELECT ' +tcComando + lp)
*!*	Else
*!*		lR = SQLExec(goapp.bdconn, 'SELECT ' +tcComando + lp,NCursor)
*!*	Endif
*!*	If lR>0 Then
*!*		Return 1
*!*	Else
*!*		Return 0
*!*	Endif
*!*	Endfunc
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
Function DultimoPrecio(npara1,npara2)
TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
   a.fech,IFNULL(b.prec,0) AS precio FROM
   fe_kar AS b INNER JOIN fe_rcom AS a ON a.idauto=b.idauto WHERE a.idcliente=<<npara1>>
   AND b.idart=<<npara2>> AND b.acti='A'  ORDER BY fech DESC LIMIT 1;
ENDTEXT
If Ejecutaconsulta(lc,'pr')<1 Then
	Return 0
Endif
Return pr.precio
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
Function MuestraCostosParaVenta(np1,ccursor)
lc='ProMuestraCostosParaVenta'
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
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
goapp.npara2=Val(goapp.año)
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
	errorbd(ERRORPROC+ ' Actualizando Otras Compras')
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
	errorbd(ERRORPROC+' Actualizando Stock')
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
	errorbd(ERRORPROC+ ' Actualizando el Ingreso de Créditos  ')
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
	errorbd(ERRORPROC+ ' Actualizando Stock')
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
Function Generanumero(numerox,nsgtex,idseriex)
If Val(numerox)>=nsgtex
	If GeneraCorrelativo(Val(numerox)+1,idseriex)=0 Then
		Return 0
	Else
		Return 1
	Endif
Else
	Return 1
Endif
Endfunc
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
	errorbd(ERRORPROC+ ' Registrando Nuevos Productos')
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
If EJECUTARP(lc,lp,ccursor)<1 Then
	errorbd(ERRORPROC+ ' Mostrando Proveedores')
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
If EJECUTARP(lc,lp,ccursor)<1 Then
	errorbd(ERRORPROC+ ' Mostrando Clientes')
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
lc='FunIngresaCabeceraCV'
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
*FOR x=1 TO 24
*   WAIT WINDOW 'hola'
*   cpara='np'+ALLTRIM(STR(x))
*    WAIT WINDOW EVALUATE(cpara)
*NEXT
TEXT to lparametros NOSHOW
(?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24)
ENDTEXT
*TEXT to lp NOSHOW
*(?np1,?np2,?np3,?np4,?np5,?np6,?np7,?np8,?np9,?np10,?np11,?np12,?np13,?np14,?np15,?np16,?np17,?np18,?np19,?np20,?np21,?np22,?np23,?np24)
*ENDTEXT
If EJECUTARF(lc,lparametros,cur)<1 Then
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
(?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
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
If BuscarSeries(1,'20')=0
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
Function MuestraLCajaE10(np1,ntienda,ccursor)
lc="PROMUESTRALCAJAE"
cur=ccursor
goapp.npara1=np1
goapp.npara2=ntienda
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Mostrando Datos del Libro Caja Efectivo')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************
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
	errorbd(ERRORPROC+ ' No Se Puede Obtener El Detalle del Número de Cuenta')
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
cur="rild"
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
	errorbd(ERRORPROC+ ' '+' Ingresando Asientos Diario')
	Return 0
Else
	Return rild.Id
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
Function ActualizaDatosDiarioInicial(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16)
Local cur As String
lc='PROACTUALIZADATOSDIARIOinicial'
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
**********************
Function BloqueaBcos(np1,np2,np3,np4)
lc="ProBloqueaBcos"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
ccur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARP(lc,lp,ccur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Bloquear El Ingreso a Caja y Bancos')
	Return 0
Else
	Return 1
Endif
Endfunc
************************
Function PermiteIngresobcos(np1,np2)
lc="FUnVerificaBloqueoBcos"
goapp.npara1=np1
goapp.npara2=np2
ccursor='v'
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARF(lc,lp,ccursor)<1 Then
	errorbd(ERRORPROC+ ' No Se Puede Obtener el estado del Bloqueo para este Registro')
	Return 0
Else
	Return v.Id
Endif
Endfunc
*****************************
Function DevuelveStocks1(np1,np2,ccursor)
lc='PRODSTOCKS1'
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)<1 Then
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
**************************************
Function DesactivaNotas(np1,np2)
lc="ProAnulaCanjesNotas"
goapp.npara1=np1
goapp.npara2=np2
cur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Anular el Registro de las Notas de Crédito/Debito')
	Return 0
Else
	Return 1
Endif
Endfunc
*****************************************
Function IngresaGuiascons(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10)
lc="FUNINGRESAGUIASCons"
cur="yy"
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
	errorbd(ERRORPROC+' Ingresando Guias Directas')
	Return 0
Else
	Return yy.Id
Endif
Endfunc
******************************************
Function GrabaDetalleGuiasCons(np1,np2,np3,np4)
cur="igc"
lc='FunDetalleGuiasCons'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Detalles Guias Directas')
	Return 0
Else
	Return igc.Id
Endif
Endfunc
***************************************
Function ActualizaGuias1(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10)
lc="ProActualizaGuiasCons"
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
	errorbd(ERRORPROC+' Actualizando Guias Por Consignación')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************
Function ActualizaDetalleGuiaCons(np1,np2,np3,np4)
cur=""
lc='ProActualizaDetalleGuiasCons'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Editando Detalles Guias Por Consignación')
	Return 0
Else
	Return 1
Endif
Endfunc
******************************
Function ActualizaEstadoGuia(np1,np2)
cur=""
lc='ProActualizaEstadoGuiaCons'
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Actualizando el estado de la Guia Por Consignación')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************
Function IngresaCanjesGuiasCons(np1,np2,np3,np4,np5)
cur=""
lc='ProIngresaCanjesGuiasCons'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando las Guias Canjeadas Por Facturas/Boletas')
	Return 0
Else
	Return 1
Endif
Endfunc
******************************
Function  AnulaCanjesGuiasCons(np1,np2)
lc='ProAnulaCanjesGuiasCons'
goapp.npara1=np1
goapp.npara2=np2
cur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Anulando Guias Canjeadas Por Consignación')
	Return 0
Else
	Return 1
Endif
Endfunc
************************************
Function ActualizaIdkarGuiasCons(np1,np2)
lc='ProActualizaIdkarGuiasCons'
goapp.npara1=np1
goapp.npara2=np2
cur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Actualizando el Id del Detalle las Guias Canjeadas Por Consignación')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************************
Function AnulaVentaCanjeada(np1,np2)
lc='ProAnulaVtaCanjeda'
goapp.npara1=np1
goapp.npara2=np2
cur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Anulando la Venta Canjeada ')
	Return 0
Else
	Return 1
Endif
Endfunc
************************************
Function ActualizaIdautoGuiaCons(np1,np2)
lc='ProActualizaIdautoGuiaCons'
cur=""
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Actualizando el Id de las Guias Canjeadas Por Consignación')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************************
Function INGRESAKARDEXPer(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12)
lc='FUNINGRESAkardex2'
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
goapp.npara12=np12
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando KARDEX 1')
	Return 0
Else
	Return nidk.Id
Endif
Endfunc
************************************
Function IngresaDPercepcion(np1,np2,np3,np4)
lc='ProIngresaDpercepcion'
ccur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARP(lc,lp,ccur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Detalle Percepción')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************************
Function AnulaTransaccion(ctdoc,cndoc,ctipo,nauto,cu,ga,df,cu1)
If SQLExec(goapp.bdconn,"call proAnulaTransacciones(@estado,?ctdoc,?cndoc,?ctipo,?nauto,?cu,?ga,?df,?cu1)") < 1
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
***************************
Function MuestraEmpleados(np1)
goapp.npara1=np1
ccursor="Empleados"
lc='ProMuestraEmpleados'
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ '  Mostrando Empleados')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function MuestraEmpleadosx(np1,ccursor)
goapp.npara1=np1
lc='ProMuestraEmpleados'
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ '  Mostrando Empleados')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function Validacaja1(np1,np2)
Local cur As String
s='C'
lc='FUNVERIFICACAJA1'
cur="X"
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' No se Puede Verificar Los Saldos de Caja '+Alltrim(lc))
	s='C'
Else
	If x.Id=0
		s='A'
	Else
		s='C'
	Endif
Endif
Return s
Endfunc
**************************
Function IngresaCajaE(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
lc='FUNINGRESACAJAE'
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
*********************************
Function CancelaDeudasCi(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15)
lc='FUNINGRESAPAGOSdeudas1'
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
goapp.npara15=np15
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Cancelando Ctas Por Pagar')
	Return 0
Else
	Return dd.Id
Endif
Endfunc
**********************************
Function MuestraDptos(ccursor)
lc='ProMuestraDptos'
lp=""
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Mostrando la Lista de Departamentos')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************************
Function CreaClienteCD(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21)
lc='FunCreaCLienteCd'
cur="Dc"
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
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,
      ?goapp.npara20,?goapp.npara21)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Creando Clientes ')
	Return 0
Else
	Return Dc.Id
Endif
Endfunc
***********************
Function  ActualizaClienteCD(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21)
lc='PROACTUALIZACLIENTECD'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,
      ?goapp.npara19,?goapp.npara20,?goapp.npara21)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ '  Editando Clientes')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function MuestraClientesY(np1,np2,np3,ccursor)
lc='PROMUESTRACLIENTES1'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Mostrando Clientes')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function ActualizarDsctoProductos(np1,np2)
lc='PROActualizaDsctoProductos'
goapp.npara1=np1
goapp.npara2=np2
ccursor=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Actualizando Dsctos en los Precios de Productos')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************************
Function IngresaDatosLCajaE1(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11)
lc="ProIngresaDatosLcajaE1"
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Datos A Libro Caja Efectivo 1')
	Return 0
Else
	Return 1
Endif
Endfunc
************************************
Function ActualizaDatosLcajaE1(np1)
lc="ProActualizaDatosLcajaE1"
cur=""
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Actualizando Datos A Libro Caja Efectivo 1')
	Return 0
Else
	Return 1
Endif
Endfunc
******************************************
Function IngresaResumenDctoC(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24,np25,np26)
lc='FunIngresaRCompras'
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
goapp.npara25=np25
goapp.npara26=np26
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Ingresando Cabecera de Documento')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
*************************
Function ActualizaResumenDctoC(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24,np25,np26,np27)
lc='ProActualizaRCompras'
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
goapp.npara27=np27
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26,?goapp.npara27)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Actualizando Cabecera de Documento de Compras/Gastos')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function IngresaDatosLCajaTrans(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13)
lc='FUNIngresaCajaBancosTran'
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
	errorbd(ERRORPROC+ ' Registrando EN Caja y Bancos Transferencias Entre Cuentas De Bancos ')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
*****************************
Function CancelaCreditosDIario(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
lc='FUNINGRESAPAGOSCREDITOSDiario'
cur="nik"
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
	errorbd(ERRORPROC+ '  Cancelando Clientes Desde el Libro Diario')
	Return 0
Else
	Return nik.Id
Endif
Endfunc
***************************
Function CancelaDeudasDiario(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15)
lc='FUNINGRESAPAGOSdeudasDiario'
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
goapp.npara15=np15
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Cancelando Ctas Por Pagar desde el Diario')
	Return 0
Else
	Return dd.Id
Endif
Endfunc
******************************
Function DesactivaEctasVtas(np1)
Local cur As String
lc='ProDesactivaEctasVtas'
cur=""
goapp.npara1=np1
TEXT to lp noshow
	     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Actualizando Los Registros de Cuentas ')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function DesactivaEctasCompras(np1)
Local cur As String
lc='ProDesactivaEctasCompras'
cur=""
goapp.npara1=np1
TEXT to lp noshow
	     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Actualizando Los Registros de Cuentas ')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************************
Function CancelaCreditosCCajaE(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
lc='FunIngresaPagosCreditosCe'
cur="ce"
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
	errorbd(ERRORPROC+ ' Cancelando Ctas Por Pagar desde Caja Efectivo')
	Return 0
Else
	Return ce.Id
Endif
Endfunc
******************************************
Function CancelaDeudasCCajae(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15)
lc='FUNINGRESAPAGOSdeudasCe'
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
goapp.npara15=np15
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Cancelando Ctas Por Pagar Por Caja Efectivo')
	Return 0
Else
	Return dd.Id
Endif
Endfunc
***********************************
Function CancelaCreditosCb(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
lc='FunIngresaPagosCreditosCb'
cur="ce"
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
	errorbd(ERRORPROC+ ' Cancelando Ctas Por Pagar desde Caja y Bancos')
	Return 0
Else
	Return ce.Id
Endif
Endfunc
******************************************
Function CancelaDeudasCb(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15)
lc='FUNINGRESAPAGOSdeudasCb'
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
goapp.npara15=np15
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Cancelando Ctas Por Pagar Por Caja y Bancos')
	Return 0
Else
	Return dd.Id
Endif
Endfunc
********************************************
Function IngresaDatosLCajaEe(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10)
lc="FunIngresaDatosLcajaEe"
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
	errorbd(ERRORPROC+ ' Ingresando Datos A Libro Caja Efectivo')
	Return 0
Else
	Return Ca.Id
Endif
Endfunc
************************
Function DesactivaCajaEfectivoCr(np1)
Local cur As String
lc='ProDesactivaCajaEfectivoCr'
cur=""
goapp.npara1=np1
TEXT to lp noshow
	     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Anulando Pagos de Creditos de Caja Efectivo ')
	Return 0
Else
	Return 1
Endif
Endfunc
*****************************
Function DesactivaCajaEfectivoDe(np1)
Local cur As String
lc='ProDesactivaCajaEfectivoDe'
cur=""
goapp.npara1=np1
TEXT to lp noshow
	     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Anulando Pagos de Creditos de Caja Efectivo ')
	Return 0
Else
	Return 1
Endif
Endfunc
***************************
Function ValidaRuc(lcNroRuc)
Local aArrayRuc
If Len(Alltrim(lcNroRuc)) <> 11 Then
	Return .F.
Endif
Dimension aArrayRuc(3,11)
For i = 1 To 11
	aArrayRuc(1,i)=Val(Subs(lcNroRuc,i,1))
Endfor
aArrayRuc(2,1)=5
aArrayRuc(2,2)=4
aArrayRuc(2,3)=3
aArrayRuc(2,4)=2
aArrayRuc(2,5)=7
aArrayRuc(2,6)=6
aArrayRuc(2,7)=5
aArrayRuc(2,8)=4
aArrayRuc(2,9)=3
aArrayRuc(2,10)=2
aArrayRuc(3,11)=0
For i=1 To 10
	aArrayRuc(3,i) = aArrayRuc(1,i) * aArrayRuc(2,i)
	aArrayRuc(3,11) = aArrayRuc(3,11) + aArrayRuc(3,i)
Endfor
lnResiduo = Mod(aArrayRuc(3,11),11)
lnUltDigito = 11 - lnResiduo
Do Case
Case lnUltDigito = 11 Or lnUltDigito=1
	lnUltDigito = 1
Case lnUltDigito = 10 Or lnUltDigito=0
	lnUltDigito = 0
Endcase
If lnUltDigito = aArrayRuc(1,11) Then
	Return .T.
Else
	Return .F.
Endif
Endfunc
**********************************************
Function GeneraArchivoPlanCuentas(np1,np2,np3)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select(np3)
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<ncta>>|<<nombrecta>>|<<tplan>>|<<descPlan>>|<<estado>>|
	Else
           \<<periodo>>|<<ncta>>|<<nombrecta>>|<<tplan>>|<<descPlan>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*******************************
Function GeneraArchivoVtas(np1,np2,np3)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select(np3)
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<nrolote>>|<<esta>>|<<fecha>>|<<fvto>>|<<tipocomp>>|<<serie>>|<<nrocomp>>|<<consolidado>>|<<tipodocc>>|<<nruc>>|<<ALLTRIM(cliente)>>|<<exporta>>|<<base>>|<<exon>>|<<inafecta>>|<<isc>>|<<igv>>|<<pilado>>|<<igvp>>|<<otros>>|<<total>>|<<tipocambio>>|<<fechn>>|<<tipon>>|<<serien>>|<<ndocn>>|<<fob>>|<<estado>>|
	Else
           \<<periodo>>|<<nrolote>>|<<esta>>|<<fecha>>|<<fvto>>|<<tipocomp>>|<<serie>>|<<nrocomp>>|<<consolidado>>|<<tipodocc>>|<<nruc>>|<<ALLTRIM(cliente)>>|<<exporta>>|<<base>>|<<exon>>|<<inafecta>>|<<isc>>|<<igv>>|<<pilado>>|<<igvp>>|<<otros>>|<<total>>|<<tipocambio>>|<<fechn>>|<<tipon>>|<<serien>>|<<ndocn>>|<<fob>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
***********************
Function GeneraArchivoCompras(np1,np2,np3)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select(np3)
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	nlote=nrolote
	If nl=0 Then
             \\<<periodo>>|<<nlote>>|<<esta>>|<<fechae>>|<<fvto>>|<<tipocomp>>|<<serie>>|<<fdua>>|<<nrocomp>>|<<consolidado>>|<<tipodocp>>|<<nruc>>|<<alltrim(proveedor)>>|<<base>>|<<igv>>|<<exon>>|<<igvng>>|<<inafecta>>|<<isc>>|<<isc>>|<<isc>>|<<otros>>|<<total>>|<<tipocambio>>|<<fechn>>|<<tipon>>|<<serien>>|<<dadu>>|<<ndocn>>|<<nod>>|<<fechad>>|<<nrod>>|<<reten>>|<<estado>>|
	Else
              \<<periodo>>|<<nlote>>|<<esta>>|<<fechae>>|<<fvto>>|<<tipocomp>>|<<serie>>|<<fdua>>|<<nrocomp>>|<<consolidado>>|<<tipodocp>>|<<nruc>>|<<alltrim(proveedor)>>|<<base>>|<<igv>>|<<exon>>|<<igvng>>|<<inafecta>>|<<isc>>|<<isc>>|<<isc>>|<<otros>>|<<total>>|<<tipocambio>>|<<fechn>>|<<tipon>>|<<serien>>|<<dadu>>|<<ndocn>>|<<nod>>|<<fechad>>|<<nrod>>|<<reten>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
***************************
Function GeneraArchivoPercepciones1(np1,np2,np3)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select(np3)
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
             \\<<tipodoc>>|<<nruc>>|<<juridica>>|<<paterno>>|<<materno>>|<<nombres>>|<<serie>>|<<ndoc>>|<<fech>>|<<df>>|<<f>>|<<pper>>|<<montop>>|<<tdoc>>|
	Else
             \<<tipodoc>>|<<nruc>>|<<juridica>>|<<paterno>>|<<materno>>|<<nombres>>|<<serie>>|<<ndoc>>|<<fech>>|<<df>>|<<f>>|<<pper>>|<<montop>>|<<tdoc>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*********************************
Function GeneraArchivoDiario(np1,np2,np3)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select(np3)
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<nrolote>>|<<esta>>|<<tplan>>|<<ncta>>|<<fecha>>|<<detalle>>|<<debe>>|<<haber>>|<<rv>>|<<rc>>|<<rcc>>|<<estado>>|
	Else
           \<<periodo>>|<<nrolote>>|<<esta>>|<<tplan>>|<<ncta>>|<<fecha>>|<<detalle>>|<<debe>>|<<haber>>|<<rv>>|<<rc>>|<<rcc>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
********************************
Function GeneraArchivoMayor(np1,np2,np3)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select(np3)
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<nrolote>>|<<esta>>|<<tplan>>|<<ncta>>|<<fecha>>|<<detalle>>|<<deudor>>|<<acreedor>>|<<rv>>|<<rc>>|<<rcc>>|<<estado>>|
	Else
           \<<periodo>>|<<nrolote>>|<<esta>>|<<tplan>>|<<ncta>>|<<fecha>>|<<detalle>>|<<deudor>>|<<acreedor>>|<<rv>>|<<rc>>|<<rcc>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
**********************************
Function GeneraBalanceComprobacion(np1,np2,np3)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select(np3)
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<nrolote>>|<<esta>>|<<tplan>>|<<ncta>>|<<fecha>>|<<detalle>>|<<deudor>>|<<acreedor>>|<<rv>>|<<rc>>|<<rcc>>|<<estado>>|
	Else
           \<<periodo>>|<<nrolote>>|<<esta>>|<<tplan>>|<<ncta>>|<<fecha>>|<<detalle>>|<<deudor>>|<<acreedor>>|<<rv>>|<<rc>>|<<rcc>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
**********************************
Procedure ImportaTCSunatx(nmes,nanio)
nm=Alltrim(Str(nmes))
na=Alltrim(Str(nanio))
loIE=Createobject("InternetExplorer.Application")
loIE.Visible=.F.
loIE.Navigate("http://www.sunat.gob.pe/cl-at-ittipcam/tcS01Alias?mes="+(nm)+"&anho="+(na))

Do While loIE.readystate<>4
	Wait Window "Esperando Respuesta desde www.sunat.gob.pe " Nowait
Enddo
lcHTML=loIE.Document.body.innerText
ln_PosIni = At("Día",lcHTML)
ln_PosFin = At("Para efectos",lcHTML)
lc_Texto = Substr(lcHTML,ln_PosIni,ln_PosFin - ln_PosIni)
ln_PosIni = Rat("Venta",lc_Texto)
lc_Texto = Chrtran(Alltrim(Substr(lc_Texto,ln_PosIni + 6)) + " ",Chr(10),"")
Wait Clear
loIE.Quit()
Release loIE
Push Key Clear
If Left(lc_Texto,9)<> "No existe" Then
	Create Cursor CurTCambio(DIA N(2),TC_COMPRA N(5,3),TC_VENTA N(5,3))
	ln_Contador = 0
	lc_Cadena = ""
	For K = 1 To Len(lc_Texto)
		If Substr(lc_Texto,K,1) = " " Then
			ln_Contador = ln_Contador + 1
			If ln_Contador = 1 And K <> Len(lc_Texto) Then
				If  Val(Alltrim(lc_Cadena))=0 Then
					If Len(Alltrim(lc_Cadena))=2 Then
						lc_Cadena=Alltrim(Substr(lc_Cadena,2,1))
					Else
						lc_Cadena=Alltrim(Substr(lc_Cadena,2,2))
					Endif
				Endif
				Select CurTCambio
				Append Blank
				Replace CurTCambio.DIA With Val(lc_Cadena)
			Endif
			If ln_Contador = 2 Then
				Select CurTCambio
				Replace CurTCambio.TC_COMPRA With Val(lc_Cadena)
			Endif
			If ln_Contador = 3 Then
				Select CurTCambio
				Replace CurTCambio.TC_VENTA With Val(lc_Cadena)
				ln_Contador = 0
			Endif
			lc_Cadena =""
		Else
			lc_Cadena = lc_Cadena + Substr(lc_Texto,K,1)
		Endif
	Next
Endif
Endproc
*********************************************
Function ImportaDatosdesdeSunat(nruc,codigo)
#Define CRLF Chr(13)+Chr(10)
Local oErr As Exception
Local cStr As Character
Local SW As Boolean
Create Cursor xmlclientes(nombre c(180),direccion c(220),agente c(100))
SW = .T.
Try
	Local loXmlHttp As Microsoft.XMLHTTP,;
		lcURL As String,;
		lcHTML As String,;
		lcTexto As String,;
		lcFile As String

	loXmlHttp = Createobject("Microsoft.XMLHTTP")
	lcURL = "http://www.sunat.gob.pe/w/wapS01Alias?ruc="+xruc
*lcURL = "http://ww1.sunat.gob.pe/cl-ti-itmrconsruc/jcrS00Alias?ruc="+XRUC
	loXmlHttp.Open("POST" , lcURL, .F.)
	loXmlHttp.Send

	Wait Window "Espere por favor, obteniendo datos desde www.sunat.gob.pe" Nowait
	Do While loXmlHttp.readystate<>4 Or loXmlHttp.Status <>200
	Enddo

	lcHTML = loXmlHttp.Responsetext
	lcTexto = Chrtran(Alltrim(lcHTML),Chr(10),"")
*/Para los delimitadores
	lcTexto  = Strtran(lcTexto, "N&#xFA;mero Ruc. </b> " + xruc + " - ","RazonSocial:")
	lcTexto  = Strtran(lcTexto, "Estado.</b>","Estado:")
	lcTexto  = Strtran(lcTexto, "Agente Retenci&#xF3;n IGV.</strong>","ARIGV:")
	lcTexto  = Strtran(lcTexto, "Direcci&#xF3;n.</b><br/>","Direccion:")
	lcTexto  = Strtran(lcTexto, "Situaci&#xF3;n.<b> ","Situacion:")
	lcTexto  = Strtran(lcTexto, "Tel&#xE9;fono(s).</b><br/>","Telefono:")
	lcTexto  = Strtran(lcTexto, "Dependencia.","Dependencia:")
	lcTexto  = Strtran(lcTexto, "Tipo.</b><br/> ","TipoPer:")
	lcTexto  = Strtran(lcTexto, "DNI</b> : ","DNI:")
	lcTexto  = Strtran(lcTexto, "Fecha Nacimiento.</b> ","FechNac:")
	lcTexto  = Strtran(lcTexto, Space(05),Space(01))
	lcTexto  = Strtran(lcTexto, Space(04),Space(01))
	lcTexto  = Strtran(lcTexto, Space(03),Space(01))
	lcTexto  = Strtran(lcTexto, Space(02),Space(01))
	lcTexto  = Strtran(lcTexto, Chr(09),"")

*** RAZON SOCIAL ***
	PosIni = At("RazonSocial:", lcTexto)+12
	PosFin = At("<br/></small>", lcTexto)-(At("RazonSocial:", lcTexto)+12)
	xRazSocial = Substr(lcTexto,PosIni,PosFin)

	xRazSocial  = Strtran(xRazSocial , "&amp;","&")
*xRazSocial  = Strtran(xRazSocial , "&#38;","&")
*&#38;#38
	xRazSocial  = Strtran(xRazSocial , "&#39;","'")
	xRazSocial  = Strtran(xRazSocial , "&#209;","Ñ")
	xRazSocial  = Strtran(xRazSocial , "&#xD1;", "Ñ")
	xRazSocial  = Strtran(xRazSocial , "&#193;", "Á")
	xRazSocial  = Strtran(xRazSocial , "&#201;", "É")
	xRazSocial  = Strtran(xRazSocial , "&#205;", "Í")
	xRazSocial  = Strtran(xRazSocial , "&#211;", "Ó")
	xRazSocial  = Strtran(xRazSocial , "&#218;", "Ú")
	xRazSocial  = Strtran(xRazSocial , "&#xC1;", "Á")
	xRazSocial  = Strtran(xRazSocial , "&#xC9;", "É")
	xRazSocial  = Strtran(xRazSocial , "&#xCD;", "Í")
	xRazSocial  = Strtran(xRazSocial , "&#xD3;", "Ó")
	xRazSocial  = Strtran(xRazSocial , "&#xDA;", "Ú")

	lcFile= "Datos_Contribuyente.txt"
	Strtofile(xRazSocial+Chr(13)+Chr(10), lcFile)
	cnombre=xRazSocial
*** ESTADO ***
	PosIni = At("Estado:", lcTexto)+7
	PosFin = (At("ARIGV", lcTexto)-32)-(At("Estado:", lcTexto)+7)
	xEst = Substr(lcTexto,PosIni,PosFin)

	Strtofile(xEst+Chr(13)+Chr(10) , lcFile,1)

*** AGENTE RETENEDOR IGV ***
	PosIni = At("ARIGV:", lcTexto)+18
	PosFin = At("ARIGV:", lcTexto)+20-(At("ARIGV:", lcTexto)+18)
	xAR = Substr(lcTexto,PosIni,PosFin)
	cagente=xAR

	Strtofile(xAR+Chr(13)+Chr(10), lcFile,1)

*** DIRECCION ***
	PosIni = At("Direccion:", lcTexto)+10
	PosFin = At("</b></small><br/>", lcTexto)-38-(At("Direccion:",lcTexto)+10)
	xDir = Substr(lcTexto,PosIni,PosFin)

	xDir = Strtran(xDir, "&#209;", "Ñ")
	xDir = Strtran(xDir, "&#xD1;", "Ñ")
	xDir = Strtran(xDir, "&#193;", "Á")
	xDir = Strtran(xDir, "&#201;", "É")
	xDir = Strtran(xDir, "&#205;", "Í")
	xDir = Strtran(xDir, "&#211;", "Ó")
	xDir = Strtran(xDir, "&#218;", "Ú")
	xDir = Strtran(xDir, "&#xC1;", "Á")
	xDir = Strtran(xDir, "&#xC9;", "É")
	xDir = Strtran(xDir, "&#xCD;", "Í")
	xDir = Strtran(xDir, "&#xD3;", "Ó")
	xDir = Strtran(xDir, "&#xDA;", "Ú")
	Strtofile(xDir+Chr(13)+Chr(10), lcFile,1)
	cdireccion=xDir

*** SITUACION ***
	PosIni = At("Situacion:", lcTexto)+10
	PosFin = At("</b></small><br/>", lcTexto)-(At("Situacion:", lcTexto)+10)
	xCond = Substr(lcTexto,PosIni,PosFin)
	Strtofile(xCond+Chr(13)+Chr(10), lcFile,1)

*** TELEFONO ***
	PosIni = At("Telefono:", lcTexto)+9
	PosFin = At("Dependencia:", lcTexto)-25-(At("Telefono:", lcTexto)+9)
	xTelef = Substr(lcTexto,PosIni,PosFin)
	Strtofile(xTelef+Chr(13)+Chr(10), lcFile,1)

*** TIPO DE PERSONA ***
	PosIni = At("TipoPer:", lcTexto)+8
	PosFin = At("DNI:", lcTexto)-29-(At("TipoPer:", lcTexto)+8)
	xTipoPer = Substr(lcTexto,PosIni,PosFin)
	Strtofile(xTipoPer+Chr(13)+Chr(10), lcFile,1)

*** DNI ***
	PosIni = At("DNI:", lcTexto)+4
	PosFin = At("FechNac:", lcTexto)-25-(At("DNI:", lcTexto)+4)
	xDNI = Substr(lcTexto,PosIni,PosFin)
	Strtofile(xDNI+Chr(13)+Chr(10), lcFile,1)

*** FECHA DE NACIMIENTO ***
	PosIni = At("FechNac:", lcTexto)+8
	PosFin = At("FechNac:", lcTexto)+18-(At("FechNac:", lcTexto)+8)
	xFechNac = Substr(lcTexto,PosIni,PosFin)
	Strtofile(xFechNac, lcFile,1)


	Insert Into xmlclientes(nombre,direccion,agente)Values(cnombre,cdireccion,cagente)

	Release loXmlHttp

Catch To oErr
	cStr = "Error:" + CRLF + CRLF + ;
		"[  Error: ] " + Str(oErr.ErrorNo) + CRLF + ;
		"[  Linea: ] " + Str(oErr.Lineno) + CRLF + ;
		"[  Mensaje: ] " + oErr.Message + CRLF + ;
		"[  Procedimiento: ] " + oErr.Procedure + CRLF + ;
		"[  Detalles: ] " + oErr.Details + CRLF + ;
		"[  StackLevel: ] " + Str(oErr.StackLevel) + CRLF + ;
		"[  Instrucción: ] " + oErr.LineContents
	Messagebox(cStr,4112,"Error...!!!")
	SW = .F.
Endtry
If SW = .F.
	Return .F.
Else
	Return .T.
Endif
Endfunc
****************************************
Function ActualizaCostoProductoBloque(np1,np2)
lc="ProActualizaCostoProducto"
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
*******************************************
Function VerificaBloqueoCajaEfectivo(np1)
lc="FunVerificaBloqueoCajaEfectivo"
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
******************************************
Function BloqueaCajaEfectivo(np1,np2,np3)
lc="ProBloqueaCajaEfectivo"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
ccur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,ccur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Bloquear El Ingreso a Caja Efectivo')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************************
Function AcutalizaResumenCreditosVendedoresKardex(np1,np2)
lc="ProAcutalizaResumenCreditosVendedoresKardex"
goapp.npara1=np1
goapp.npara2=np2
ccur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,ccur)=0 Then
	errorbd(ERRORPROC+ ' No se Actualizo Correctamente Los Resumenes de Creditos y Vendedores ')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************************************
Function BuscaClienteNombre(np1)
lc='PROMuestraclientesx'
cur="lp"
goapp.npara1=np1
goapp.npara2=0
goapp.npara3=0
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT

If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Buscando Cliente Por Nombre')
	Return 0
Else
	Return 1
Endif
Endfunc
******************************
Function BloqueaPagosClientes(np1,np2)
lc="ProBloqueoPagosClientes"
goapp.npara1=np1
goapp.npara2=np2
ccur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,ccur)=0 Then
	errorbd(ERRORPROC+ ' No se Realizao Correctamente Los Bloqueos/Desboqueos de Cuentas Por Cobrar ')
	Return 0
Else
	Return 1
Endif
Endfunc
******************************
Function estaBloqueadoIngresoPagos(np1)
lc="FUnVerificaBloqueoCreditos"
goapp.npara1=np1
ccursor='v'
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARF(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Obtener el estado del Bloqueo para esta Fecha')
	Return 0
Else
	Return v.Id
Endif
Endfunc
*************************************
Function BloqueaDComprasM(np1,np2,np3)
Local cur As String
lc='ProBloqueaDCompras'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Bloqueando Estado de los Documentos ')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************************
Function BloqueaDVentasM(np1,np2,np3)
Local cur As String
lc='ProBloqueaDVentas'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Bloqueando Estado de los Documentos ')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************************
Function BloqueaDGastos(np1,np2,np3)
Local cur As String
lc='ProBloqueaD1'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Bloqueando Estado de los Documentos ')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************************
Function PermiteIngresoxGastos(np1)
lc="FUnVerificaBloqueo1"
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
*********************************************
Function PermiteIngresoxCompras(np1)
lc="FUnVerificaBloqueoComprasM"
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
*********************************************
Function PermiteIngresoxVentas(np1)
lc="FUnVerificaBloqueoVentasM"
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
******************************************
Function IngresarNotasCreditoCompras(np1,np2,np3)
Local cur As String
lc='FUNINGRESANOTASCREDITOCOMPRAS'
cur="xi"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Notas Credito Compras ')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function IngresarNotasCreditoVentas(np1,np2,np3)
Local cur As String
lc='FUNINGRESANOTASCREDITOventas'
cur="xi"
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Notas Credito de Ventas ')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************
Function IngresaDatosLCaja1(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
lc='FUNIngresaCajaBancos1'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Registrando EN Caja y Bancos')
	Return 0
Else
	Return Xn.Id
Endif
ENDFUNC
**********************************
Function IngresaDatosLCajaYape(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
lc='FUNIngresaCajaBancosYape'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Registrando EN Caja y Bancos Con Yape')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
**********************************
Function AbrirCajaTda(np1,np2)
lc="AbrirCajaTda"
goapp.npara1=np1
goapp.npara2=np2
ccur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,ccur)=0 Then
	errorbd(ERRORPROC+ ' No se Realizo Correctamente Los Bloqueos de Caja ')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************************
Function CieraCajaTda(np1,np2)
lc="CierraCajaTda"
goapp.npara1=np1
goapp.npara2=np2
ccur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,ccur)=0 Then
	errorbd(ERRORPROC+ ' No se Realizo Correctamente Los DesBloqueos de Caja ')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function MuestraBancosx(np1,ccursor)
lc="ProMuestraBancos"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Mostrando Lista de Bancos ')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************************
Function MuestraBancostx(ccursor)
lc="PromuestraBancosT"
lp=""
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Mostrando Tabla Bancos ')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************************
Function MuestraCtasBancos()
lc="PROmuestraCtasBancos"
lp=""
ccursor="lctasb"
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Mostrando Lista de Cuentas Corrientes de Bancos ')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************
Function MuestraCtasBancosX(ccursor)
lc="PROmuestraCtasBancos"
lp=""
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Mostrando Lista de Cuentas Corrientes de Bancos ')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************************
Function GeneraArchivoCajaBancos(np1,np2,np3)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select(np3)
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<ALLTRIM(nrolote)>>|<<allTRIM(esta)>>|<<idco>>|<<ncta>>|<<fecha>>|<<nidmp>>|<<ALLTRIM(detalle)>>|<<tipodcto>>|<<ALLTRIM(nruc)>>|<<ALLTRIM(razo)>>|<<AllTRIM(dcto)>>|<<debe>>|<<haber>>|<<estado>>|
	Else
           \<<periodo>>|<<ALLTRIM(nrolote)>>|<<allTRIM(esta)>>|<<idco>>|<<ncta>>|<<fecha>>|<<nidmp>>|<<ALLTRIM(detalle)>>|<<tipodcto>>|<<ALLTRIM(nruc)>>|<<ALLTRIM(razo)>>|<<ALLTRIM(dcto)>>|<<debe>>|<<haber>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
*******************************************
Function GeneraArchivoCajaEfectivo(np1,np2,np3)
cruta=Addbs(Justpath(np1))+np2
cr1=cruta+'.txt'
Select(np3)
Set Textmerge On Noshow
Set Textmerge To ((cr1))
nl=0
Scan
	If nl=0 Then
          \\<<periodo>>|<<nrolote>>|<<esta>>|<<fecha>>|<<detalle>>|<<debe>>|<<haber>>|<<estado>>|
	Else
           \<<periodo>>|<<nrolote>>|<<esta>>|<<fecha>>|<<detalle>>|<<debe>>|<<haber>>|<<estado>>|
	Endif
	nl=nl+1
Endscan
Set Textmerge To
Set Textmerge Off
Endfunc
**************************************************
Function INGRESAKARDEXUMarca(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16)
Local cur As String
lc='FunIngresaKardexMarca'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Kardex x Unidades Marcado')
	Return 0
Else
	Return kardexu.Id
Endif
Endfunc
****************************************************
Function ActualizaKardexUMarca(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
Local cur As String
lc='PROACTUALIZAKARDEXMarca'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Actualizando Kardex Por Unidades Marcado')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************
Function IngresaCabeceraDeudasCCtas(np1,np2,np3,np4,np5,np6,np7,np8,np9)
lc="FUNregistraDeudasCCtas"
cur="Y"
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
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Ingresando Cabecera Deudas')
	Return 0
Else
	Return Y.Id
Endif
Endfunc
***********************************
Procedure MenuOP()
Set Shadow On
Define Popup GridPopup ;
	FROM Mrow(), Mcol() ;
	MARGIN ;
	SHORTCUT
Define Bar 1 Of GridPopup Prompt "Resumen   "
Define Bar 2 Of GridPopup Prompt "Detalle   "
On Selection Popup GridPopup _Screen.ActiveForm.opciones(Bar())
Activate Popup GridPopup
Release Popup GridPopup
Endproc
**************************************
Function validaFechaVto(CALIAS)
Local vdvto As Integer
If !Used((CALIAS)) Then
	Return 0
Endif
vdvto=1
Select (CALIAS)
Scan All
	If !esFechaValidafvto(fevto) Then
		vdvto=0
		Exit
	Endif
Endscan
Return vdvto
Endfunc
********************************************
Function EstadoCtaProveedorCtasPagos(opt,nidclie,cmoneda)
If opt=0 Then
	TEXT TO lc NOSHOW
            SELECT b.rdeu_idpr,a.fech as fepd,a.fevto as fevd,a.ndoc,b.rdeu_impc as impc,a.impo as impd,a.acta as actd,a.dola,
			a.tipo,a.banc,ifnull(c.ndoc,'0000000000') as docd,b.rdeu_mone as mond,a.estd,a.iddeu as nr,
			b.rdeu_idau as idauto,ifnull(c.tdoc,'00') as refe,b.rdeu_idrd,ifnull(w.ctasb,'') as ctasb,ifnull(u.ncta,'') as ctae FROM fe_deu as a
			inner join fe_rdeu as b ON(b.rdeu_idrd=a.deud_idrd) left join fe_rcom as c ON(c.idauto=b.rdeu_idau)
			left join Vpagosbancos as w on w.cban_clpr=a.iddeu left join (select lcaj_clpr,w.ncta from fe_lcaja, fe_gene as q inner join fe_plan as w
			ON w.idcta=q.gene_idca where lcaj_Acti='A' and lcaj_acre>0) as u on u.lcaj_clpr=a.iddeu
			WHERE b.rdeu_idpr=?nidclie AND b.rdeu_mone=?cmoneda and a.acti='A' and b.rdeu_acti='A'  ORDER BY a.ncontrol,a.estd,a.fech,c.ndoc
	ENDTEXT
Else
	TEXT TO lc NOSHOW
	       SELECT b.rdeu_idpr,a.fech as fepd,a.fevto as fevd,a.ndoc,b.rdeu_impc as impc,a.impo as impd,a.acta as actd,a.dola,
			a.tipo,a.banc,ifnull(c.ndoc,'0000000000') as docd,b.rdeu_mone as mond,a.estd,a.iddeu as nr,
			b.rdeu_idau as idauto,ifnull(c.tdoc,'00') as refe,b.rdeu_idrd,ifnull(w.ctasb,'') as ctasb,ifnull(u.ncta,'') as ctae,u.lcaj_clpr FROM fe_deu as a
			inner join fe_rdeu as b ON(b.rdeu_idrd=a.deud_idrd) left join fe_rcom as c ON(c.idauto=b.rdeu_idau)
			left join Vpagosbancos as w on w.cban_clpr=a.iddeu left join(select lcaj_clpr,w.ncta from fe_lcaja, fe_gene as q inner join fe_plan as w
			ON w.idcta=q.gene_idca where lcaj_Acti='A' and lcaj_acre>0) as u on u.lcaj_clpr=a.iddeu
	        WHERE b.rdeu_idpr=?nidclie AND b.rdeu_mone=?cmoneda and a.acti='A' and b.rdeu_acti='A' and b.rdeu_codt=?opt ORDER BY a.ncontrol,a.estd,a.fech,c.ndoc
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
Function MuestraProductosDescCod(np1,np2,np3,np4,ccursor)
lc='PROMUESTRAPRODUCTOS1'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
cpropiedad='ListaPreciosPorTienda'
TEXT to lp noshow
   (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Mostrando Lista de Productos')
	Return 0
Else
	Return 1
Endif
Endfunc
******************************************************
Function GrabaCanjesPedidos(np1,np2)
lc="ProIngresaCanjePedidosF"
goapp.npara1=np1
goapp.npara2=np2
cur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Registrar Los Canjes de Los Pedidos Facturados')
	Return 0
Else
	Return 1
Endif
Endfunc
***************************************
Function MuestraPresentacioneXProductox(np1,ccursor)
lc='ProMuestraPresentacionesXProducto'
cur=ccursor
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
*************
Function GeneraCorrelativo(np1,np2)
lc="ProGeneraCorrelativo"
goapp.npara1=np1
goapp.npara2=np2
cur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Generando Correlativo de Documentos Emitidos')
	Return 0
Else
	Return 1
Endif
Endfunc
************************************
Function GeneraCorrelativootraserie(np1,np2)
lc="ProGeneraCorrelativootraserie"
goapp.npara1=np1
goapp.npara2=np2
cur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Generando Correlativo de Documentos Emitidos')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************
Function IngresaDatosDiarioInicial(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16)
cur="l"
lc="FunIngresaDatosLibroDiarioInicial"
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
	errorbd(ERRORPROC+ ' '+' Ingresando Asientos Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
******************************************
Function MuestraPlanCuentasz(np1,np2,cur)
lc="PROMUESTRACUENTASx"
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
       (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Mostrando Plan de Cuentas ')
	Return 0
Else
	Return 1
Endif
Endfunc
******************************************
Function ActualizaCostos(np1,np2,np3,np4,np5,np6,np7,np8,np9)
cur=""
lc="ProActualizaPreciosProducto"
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
	errorbd(ERRORPROC+ ' Actualizando Precios al Producto ')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************************************
Function ActualizaCostosCdscto(np1,np2,np3,np4,np5)
cur=""
lc="ProActualizaPreciosProductoCdscto"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Aplicando Descuento de Notas de Crédito al costo del Producto ')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************************
Function IngresaResumenPedidos(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
lc='FUNINGRESACABECERACOTIZACION'
cur="idpedidos"
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
	errorbd(ERRORPROC+' Ingresando Resumen de Pedidos')
	Return 0
Else
	Return idpedidos.Id
Endif
Endfunc
***********
Function ActualizaResumenPedidos(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
lc='PROACTUALIZACotizacion'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Editando Resumen de Pedidos')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************************
Function  VerificaNoPedido(np1)
lc='FunVerificaNoPedido'
cur="vd"
goapp.npara1=np1
TEXT to lp noshow
	     (?goapp.npara1)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Buscando Si Existen Pedidos con este Nùmero ')
	Return 0
Else
	If vd.Id=0 Then
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
********************************
Function  VerificaNoPedido1(np1,np2)
lc='FunVerificaNoPedido1'
cur="vd"
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Buscando Si Existen Pedidos con este Nùmero ')
	Return 0
Else
	If vd.Id=0 Then
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
********************************
Function DesactivaCaja(np1)
lc='ProDesactivaCaja'
cur=""
goapp.npara1=np1
TEXT to lp noshow
	     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Anulando Movimiento de Caja ')
	Return 0
Else
	Return 1
Endif
Endfunc
*****************************
Function PermiteIngresoVentas1(np1,np2,np3,np4)
*!*	cur="idv"
*!*	lc="FUNVALIDADCTOS1"
*!*	goapp.npara1=np1
*!*	goapp.npara2=np2
*!*	goapp.npara3=np3
*!*	TEXT to lp noshow
*!*	(?goapp.npara1,?goapp.npara2,?goapp.npara3)
*!*	ENDTEXT
*!*	If EJECUTARF(lc,lp,cur)=0 Then
*!*		errorbd(ERRORPROC)
*!*		Return 0
*!*	Endif
*!*	If idv.Id>0 Then
*!*		Return 0
*!*	Else
*!*		Return 1
*!*	Endif
SET PROCEDURE TO d:\capass\modelos\ventas ADDITIVE 
ovtas=CREATEOBJECT("ventas")
ovtas.serie=LEFT(np1,4)
ovtas.numero=SUBSTR(np1,5)
ovtas.tdoc=np2
ovtas.idauto=np3
IF ovtas.verificarsiesta()<1 then
   RETURN 0
ENDIF 
RETURN 1   
Endfunc
*****************
Function RegistraCargos(np1,np2,np3,np4)
cur=""
lc="ProIngresaCargos"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
************************
Function ActualizaCargos(np1,np2,np3,np4)
cur=""
lc="ProActualizaCargos"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
*****************************
Function devuelveIdCtrlCredito(np1)
Local ccur As String
TEXT TO lc noshow
  SELECT cred_idrc as idrc FROM fe_cred WHERE ncontrol=?np1
ENDTEXT
ccur='idctrl'
If SQLExec(goapp.bdconn,lc,ccur)=0 Then
	errorbd(lc)
	Return 0
Else
	Return idctrl.idrc
Endif
Endfunc
*********************************
Function ActualizaResumenDcto(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24,np25)
lc='ProActualizaCabeceracv'
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
	errorbd(ERRORPROC+' Actualizando Cabecera de Documento')
	Return 0
Else
	Return 1
Endif
Endfunc
***************
Function TieneKardex(np)
TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
     idauto FROM fe_kar WHERE idauto=<<np>> AND acti='A' GROUP BY idauto
ENDTEXT
If Ejecutaconsulta(lc,'kl')<0 Then
	Return  0
Else
	If REGDVTO('kl')=0 Then
		Return 1
	Else
		Return 0
	Endif
Endif
Endfunc
**********************
Function MuestraClientesDBF(np1,np2,np3,ccursor)
Do Case
Case np2=0
	Select codc,nruc,razo,fono,nfax,Dire,ciud,dni From fe_clie Where razo Like '%'+Alltrim(np1)+'%' Into Cursor (ccursor) Order By razo
Case np2=1
	Select codc,nruc,razo,fono,nfax,Dire,ciud,dni From fe_clie Where nruc=np1 Into Cursor (ccursor)  Order By razo
Otherwise
	Select codc,nruc,razo,fono,nfax,Dire,ciud,dni From fe_clie Where codc=np1 Into Cursor (ccursor)  Order By razo
Endcase
Endfunc
**************************
Function MuestraLCaja(np1)
Local ccur As String
ccur='llc'
lc= 'PROMUESTRALCAJA'
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,ccur)=0 Then
	errorbd(ERRORPROC+' Mostrando Libro Caja')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************************
Function RegistraCabeceraCotizacion(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
lc='FunIngresaCabeceraCotizacion'
cur="cid"
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
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Ingresando Cabecera de Cotización')
	Return 0
Else
	Return cid.Id
Endif
Endfunc
********************************
Function IngresaDCotizacion(np1,np2,np3,np4)
lc='FuningresaDCotizacion'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Ingresando Detalle de Cotización ')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function CreaCliente(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17)
lc='FUNCREACLIENTE'
cur="xt"
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
If EJECUTARF(lc,lp,cur)<1 Then
	errorbd(ERRORPROC+ ' Creando Clientes')
	Return 0
Else
	Return xt.Id
Endif
Endfunc
******************
Function CreaCliente2D(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
lc='FUNCREACLIENTE'
cur="xt"
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
	errorbd(ERRORPROC+ 'Creando Clientes')
	Return 0
Else
	Return xt.Id
Endif
Endfunc
******************
Function ActualizaCliente(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17)
lc='PROACTUALIZACLIENTE'
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
If EJECUTARP(lc,lp,cur)<1 Then
	errorbd(ERRORPROC+ ' Editando Clientes')
	Return 0
Else
	Return  1
Endif
Endfunc
******************
Function ActualizaCliente2D(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
lc='PROACTUALIZACLIENTE'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Editando Clientes')
	Return 0
Else
	Return  1
Endif
Endfunc
*********************************
Function VerificaStockDocumento(CALIAS,np1,np2)
Local SW As Integer
CFECHAS=CFECHAS(np2)
SW=1
Select (CALIAS)
Scan All
	ccoda=coda
	TEXT to lp NOSHOW TEXTMERGE PRETEXT 7
     Sum(if(tipo='C',cant,-cant)) as ts from
     fe_kar  as q
     inner join fe_rcom as p on p.idauto=q.idauto
     where q.alma=<<np1>>
     and idart=<<ccoda>> and p.acti='A' and q.acti='A' and p.fech<='<<cfechas>>' group by idart
	ENDTEXT
	If Ejecutaconsulta(lp,'k1')<1 Then
		SW=0
		Exit
	Endif
	Tstock=Iif(Isnull(k1.ts),0,k1.ts)
	Select (CALIAS)
	If (Tstock-cant)<0 Then
		SW=0
		Exit
	Endif
Endscan
If SW=0 Then
	Return  0
Else
	Return 1
Endif
Endfunc
************************
Function VerificaStockProducto(np1,np2,np3)
Local SW As Integer
SW=1
Tstock=0
TEXT to lp noshow
     select Sum(if(tipo='C',cant,-cant)) as ts from
     fe_kar  as q inner join fe_rcom as p on p.idauto=q.idauto where q.alma=?np2
     and idart=?np1 and p.acti='A' and q.acti='A'  and p.fech<=?np3 group by idart
ENDTEXT
ncon=Abreconexion()
If SQLExec(ncon,lp,'k1')<0 Then
	errorbd(ERRORPROC+ ' Al Obtener Stock Actual del Producto')
	Return 0
Else
	CierraConexion(ncon)
	Tstock=Iif(Isnull(k1.ts),0,k1.ts)
Endif
Return Tstock
Endfunc
************************
Function ActualizaParteDcto(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
lc='ProActualizaCabeceracv1'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Actualizando Parte de la Cabecera de Un Documento de Compra')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************************
Function MuestraTransportistax(np1,np2,ccur)
lc='ProMuestraTransportista'
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,ccur)<1 Then
	errorbd(ERRORPROC+' Mostrando la Lista de Transportistas')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************************
Function ProcesaTransportista(cruc,crazo,cdire,cbreve,ccons,cmarca,cplaca,idtr,optt,cchofer,nidus,cplaca1)
If optt=0 Then
	If SQLExec(goapp.bdconn,"SELECT FUNCREATRANSPORTISTA(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?nidus,?cplaca1) as nid","yy")<1 Then
		errorbd(ERRORPROC+'Ingresando Transportista')
		Return 0
	Else
		Return yy.nid
	Endif
Else
	If SQLExec(goapp.bdconn,"CALL PROACTUALIZATRANSPORTISTA(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?idtr,?cplaca1)")<1 Then
		errorbd(ERRORPROC+'Actualizando Transportista')
		Return 0
	Else
		Return idtr
	Endif
Endif
Endfunc
************************************
Function ProcesaTransportista1(cruc,crazo,cdire,cbreve,ccons,cmarca,cplaca,idtr,optt,cchofer,nidus,cplaca1,cfono,ccontacto)
If optt=0 Then
	If SQLExec(goapp.bdconn,"SELECT FUNCREATRANSPORTISTA1(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?nidus,?cplaca1,?cfono,?ccontacto) as nid","yy")<1 Then
		errorbd(ERRORPROC+' Ingresando Transportista')
		Return 0
	Else
		Return yy.nid
	Endif
Else
	If SQLExec(goapp.bdconn,"CALL PROACTUALIZATRANSPORTISTA1(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?idtr,?cplaca1,?cfono,?ccontacto)")<1 Then
		errorbd(ERRORPROC+' Actualizando Transportista')
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
*************************************
Function CreaProveedorContacto(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
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
goapp.npara13=np13
goapp.npara14=np14
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Al Crear un Nuevo Proveedor')
	Return 0
Else
	Return idp.Id
Endif
Endfunc
**********************************
Function EditaProveedorContacto(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
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
goapp.npara13=np13
goapp.npara14=np14
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Al Editar un Proveedor')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************
Function muestramenu1(np1,np2,ccursor)
lc='PROMUESTRAMENU'
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Consultando Menus ')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function muestramenu(np1,np2)
ccursor="menus"
lc='PROMUESTRAMENU'
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
(?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)<1 Then
	errorbd(ERRORPROC+ ' Consultando Menus ')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************
Function OtorgaOpciones1(np1,np2,np3,np4)
lc="ProOtorgaOpciones"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
cur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Asignar Correctamente Los Permisos Especiales a los Usuarios')
	Return 0
Else
	Return 1
Endif
Endfunc
************************************
Function AsignaOpciones(np1,np2,np3,np4)
lc="ProAsignaOpciones"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
cur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Asignar Correctamente Los Permisos Especiales a los Usuarios')
	Return 0
Else
	Return 1
Endif
Endfunc
******************************
Function MostrarMenu11(np1,np2,np3,np4)
cur="menus"
lc='ProMostrarMenu1'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Mostrando Opciones del Menú Lateral')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************
Function CambiaEstadoTraspaso(np1)
lc='ProTraspasoRecibido'
goapp.npara1=np1
ccur=""
TEXT TO lp noshow
   (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,ccur)=0 Then
	errorbd(ERRORPROC+ ' Al Cammbiar Estado de Transferencia a Recibido  ')
	Return 0
Else
	Return 1
Endif
Endfunc
********************
Function IngresaDtraspasos(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12)
lc='FunIngresaKardex'
cur="Xt"
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
	errorbd(ERRORPROC+ ' No Es Posible Registrar el Detalle del Traspaso')
	Return 0
Else
	Return xt.Id
Endif
Endfunc
************************************
Function IngresaTraspasoAlmacenEnviado(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24,np25)
lc='FUNingresaCabeceraTraspaso'
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
goapp.npara25=np25
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Ingresando Cabecera de Documento')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
***************************************
Function  VerificaDescripcionProducto(np1,np2)
Local cur As String
lc='FunverificaNombredeProducto'
cur="Ynp"
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
	    (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Verificando Si Existe ya Un Nombre de Producto Registrado ')
	Return 0
Else
	Return ynp.Id
Endif
Endfunc
***************************************
Function CreaActivos(np1,np2,np3)
Local cur As String
lc='FunCreaActivos'
cur="Y"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
	    (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Registrando Activos en la Base de Datos')
	Return 0
Else
	Return Y.Id
Endif
Endfunc
****************************************
Function ActualizaActivos(np1,np2,np3,np4,np5)
Local cur As String
lc='ProActualizaActivos'
cur="Y"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
TEXT to lp noshow
	    (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Editando Activos en la Base de Datos')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************************************
Function MuestraActivos(ccursor)
lc='ProMuestraActivos'
lp=''
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Listando Activos en la Base de Datos')
	Return 0
Else
	Return 1
Endif
Endfunc
************************************************
Function IngresaOTrasCompras1(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17)
Local cur As String
lc='FunIngresaOtrasCompras1'
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
goapp.npara17=np17
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Otras Compras')
	Return 0
Else
	Return Otc.Id
Endif
Endfunc
*************************
Function ActualizaOtrasCompras1(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17)
Local cur As String
lc='ProActualizaOtrasCompras1'
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
goapp.npara17=np17
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Actualizando Otras Compras')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function IngresaCajaDepositos(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
lc='FUNINGRESACAJADep'
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
Function IngresaCajavtas(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
lc='FUNINGRESACAJAVtas'
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
*****************************
Function ActualizaResumenPedidosTvta(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
lc='PROACTUALIZACotizacion1'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Editando Resumen de Pedidos')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************************
Function IngresaResumenPedidostvta(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
lc='FUNINGRESACABECERACOTIZACION1'
cur="idpedidos"
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
	errorbd(ERRORPROC+' Ingresando Resumen de Pedidos')
	Return 0
Else
	Return idpedidos.Id
Endif
Endfunc
*****************************************
Function BuscaNombre(np1,np2,np3)
lc='FunBuscaNombre'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
ccur='xc'
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARF(lc,lp,ccur)<=0 Then
	errorbd(ERRORPROC+ ' Buscando si ya esta Registrado ')
	Return -1
Else
	Return xc.Id
Endif
Endfunc
***********************************************
Function IngresaRetencionIGV(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24)
lc='FUNingresaRetencion'
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
	errorbd(ERRORPROC+' Ingresando Retención IGV')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
**************************
Function PermiteIngresoRetencion(np1,np2)
lc='FunVerificaRetencion'
cur="Xn"
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Verificando Si Esta Registrado en la Base de Datos')
	Return 0
Else
	If Xn.Id>0 Then
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
*************************
Function RegistraPeriodoRetencion(np1,np2)
lc='ProRegistraPeridoRetencion'
cur=""
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Registrando Datos en las Retenciones')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************
Function CancelaCreditosConRetencion(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
lc='FUNINGRESAPAGOSCREDITOSRetencion'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Ingresando Retención IGV Como Pagos ')
	Return 0
Else
	Return 1
Endif
Endfunc
***************************
Function MuestraIdPlanCuentas(np1,cur)
lc="PromuestraIdCuentas"
goapp.npara1=np1
TEXT to lp noshow
       (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Mostrando Solo Una Cuenta de el Plan de Cuentas ')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************
Function YaIngresadoDiario(np1,np2,np3)
nidt=goapp.tienda
If goapp.cdatos<>'S' Then
	TEXT TO lc noshow
      SELECT ldia_idld FROM fe_ldiario WHERE ldia_acti='A' AND LEFT(ldia_comp,3)=?np1 AND MONTH(ldia_fech)=?np2 AND YEAR(ldia_fech)=?np3
	ENDTEXT
Else
	TEXT TO lc noshow
      SELECT ldia_idld FROM fe_ldiario WHERE ldia_acti='A' AND LEFT(ldia_comp,3)=?np1 AND MONTH(ldia_fech)=?np2 AND YEAR(ldia_fech)=?np3 AND ldia_codt=?nidt
	ENDTEXT
Endif
ncon=Abreconexion()
If SQLExec(ncon,lc,'Ya')<0 Then
	errorbd(lc)
	Return 0
Endif
CierraConexion(ncon)
If Empty(ya.ldia_idld) Then
	Return 1
Else
	Return 0
Endif
Endfunc
************************************
Function GrabaCanjesNotas(np1,np2)
lc="FunIngresaCanjePedidosF"
goapp.npara1=np1
goapp.npara2=np2
cur="Notasp"
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Registrar Los Canjes de Los Pedidos  de Venta Facturados')
	Return 0
Else
	Return notasp.Id
Endif
Endfunc
*****************************************************
Function IngresaResumenDctoCanjeado(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24)
lc='FUNingresaCabeceraCanjeado'
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
********************************
Function AnulaCanjesNotasVta(np1)
lc='ProActualizaCanjePedidosN'
goapp.npara1=np1
ccur=""
TEXT TO lp noshow
   (@estado,?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,ccur)=0 Then
	errorbd(ERRORPROC+ ' Al Cammbiar a Estado de Recibido  ')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************************
Function verificaNombreCliente(np1)
q=0
For x=1 To Len(Alltrim(np1))
	If q>=2 Then
		Exit
	Endif
	If Substr(np1,x,1)=' ' Then
		q=q+1
	Endif
Next
If q<2 Then
	Return 0
Else
	Return 1
Endif
Endfunc
****************************
Function VerificaDniCliente(np1)
If Len(Alltrim(np1))<>8 Or np1="00000000" Then
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function CancelaDeudasConNotasCredito(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15)
lc='FUNINGRESAPAGOSdeudasConNotasCredito'
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
goapp.npara15=np15
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Cancelando Ctas Por Pagar Con Notas de Crédito')
	Return 0
Else
	Return dd.Id
Endif
Endfunc
******************************
Function  VerificaSaldosDctosCobrar(CALIAS)
Local SW As Integer
SW=1
Select (CALIAS)
If Reccount()=0 Then
	Return 0
Else
	ncon=Abreconexion()
	Select (CALIAS)
	Scan All
		Select (CALIAS)
		x=ncontrol
		npagos=pagos
		TEXT TO lc noshow
           SELECT  ncontrol,ROUND(SUM(impo-acta),2) AS importe FROM fe_rcred AS b
           INNER JOIN fe_cred AS a ON a.cred_idrc=b.rcre_idrc
           WHERE a.acti='A' AND b.rcre_acti='A' AND ncontrol=?x GROUP BY a.ncontrol
		ENDTEXT
		If SQLExec(ncon,lc,'lv')<0 Then
			SW=0
			Exit
		Endif
		If Empty(lv.importe) Then
			SW=0
			Exit
		Else
			If Round(lv.importe-npagos,2)>=0 Then
				SW=1
				Exit
			Else
				SW=0
				Exit
			Endif
		Endif
	Endscan
	CierraConexion(ncon)
	Return SW
Endif
Endfunc
********************************
Function IngresaOGuiascons(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12)
lc="FUNINGRESAOGUIASCons"
cur="yy"
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
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Ingresando Otras Guias de Remisión')
	Return 0
Else
	Return yy.Id
Endif
Endfunc
*****************************
Function ActualizaOGuias1(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12)
lc="ProActualizaOGuiasCons"
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
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Actualizando Otras Guias de Remisión')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************
Function IngresaDatosLCajax(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
lc='FUNIngresaCajaBancos2'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Registrando EN Caja y Bancos')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
**********************
Function IngresaDatosLCajaxInteres(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15)
lc='FunIngresaCajaBancosInteres'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Registrando Intereses en Caja y Bancos')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
**********************
Function IngresaDatosLCajaTransx(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
lc='FUNIngresaCajaBancosTran1'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Registrando EN Caja y Bancos Transferencias Entre Cuentas De Bancos ')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
*****************************
Function IngresaDatosLCajaTx(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
lc='FUNIngresaCajaBancosTx'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Registrando EN Caja y Bancos Con Ingreso a Caja Efectivo')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
******************************
Function ActualizaDatosLCajax(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15)
lc='PROActualizaCajaBancos1'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Actualizando Libro Caja Y Bancos')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************
Function RegistraCabeceraCotizacionx(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np18,np19)
lc='FunIngresaCabeceraCotizacion'
cur="cid"
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
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Ingresando Cabecera de Cotización')
	Return 0
Else
	Return cid.Id
Endif
Endfunc
*****************************
Function ActualizaCotizacionx(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19)
lc='PROACTUALIZACOTIZACION'
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
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Actualizando Cotizaciones')
	Return 0
Else
	Return 1
Endif
Endfunc
******************************
Function CambiaCtasContables(np1,np2)
lc='ProCambiosCtas'
cur=""
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
     (@estado,?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Reemplazando Cuentas Contablese en Diario,Caja y Bancos')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************
Function IngresaDatosLCajaECreditos(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13)
lc="FunIngresaDatosLcajaECreditos"
cur="Cred"
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
(?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7, ?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Cancelaciones de Cliente A Caja Efectivo')
	Return 0
Else
	Return cred.Id
Endif
Endfunc
*************************
Function IngresaDatosLCajaEDEudas(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13)
lc="FunIngresaDatosLcajaEDeudas"
cur="Deud"
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
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,
     ?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Cancelaciones de Proveedores a Caja Efectivo')
	Return 0
Else
	Return Deud.Id
Endif
Endfunc
*************************************
Function CancelaCreditosCefectivo(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
lc="FUNINGRESAPAGOSCREDITOSCefectivo"
cur="nidcreditos"
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
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,
     ?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Cancelaciones de Caja Efectivo(Ctas por Cobrar)')
	Return 0
Else
	Return nidcreditos.Id
Endif
Endfunc
**************************************
Function IngresaDatosLCajaEFectivo11(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
lc="ProIngresaDatosLcajaEefectivo"
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
(?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,
?goapp.npara12,?goapp.npara13,?goapp.npara14)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Datos A Libro Caja Efectivo Con Cuenta Contable')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************************
Function IngresaDatosLCajaECreditostmp(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13)
lc="FunIngresaDatosLcajaECreditosTmp"
cur="Cred"
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
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,
     ?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Cancelaciones de Cliente A Caja Efectivo en forma Temporal')
	Return 0
Else
	Return cred.Id
Endif
Endfunc
*************************
Function EstadoCtaProveedorx(opt,nidclie,cmx)
If opt=0 Then
	TEXT TO lc NOSHOW
	     SELECT b.rdeu_idpr,a.fech as fepd,a.fevto as fevd,a.ndoc,b.rdeu_impc as impc,a.impo as impd,a.acta as actd,a.dola,
	     a.tipo,a.banc,ifnull(c.ndoc,'0000000000') as docd,b.rdeu_mone as mond,a.estd,a.iddeu as nr,
	     b.rdeu_idau as idauto,ifnull(c.tdoc,'00') as refe,b.rdeu_idrd,deud_idcb,ifnull(w.ctas_ctas,'') as bancos,
         ifnull(w.cban_ndoc,'') as nban FROM fe_deu as a
	     inner join fe_rdeu as b ON(b.rdeu_idrd=a.deud_idrd)
	     left join fe_rcom as c ON(c.idauto=b.rdeu_idau)
         left join (SELECT cban_nume,cban_ndoc,g.ctas_ctas,cban_idco FROM fe_cbancos f  inner join fe_ctasb g on g.ctas_idct=f.cban_idba where cban_acti='A') as w on w.cban_idco=a.deud_idcb
	     WHERE b.rdeu_idpr=?nidclie  AND b.rdeu_mone=?cmx  and a.acti<>'I' and b.rdeu_acti<>'I' ORDER BY a.ncontrol,a.fech
	ENDTEXT
Else
	TEXT TO lc NOSHOW
	     SELECT b.rdeu_idpr,a.fech as fepd,a.fevto as fevd,a.ndoc,b.rdeu_impc as impc,a.impo as impd,a.acta as actd,a.dola,
	     a.tipo,a.banc,ifnull(c.ndoc,'0000000000') as docd,b.rdeu_mone as mond,a.estd,a.iddeu as nr,
	     b.rdeu_idau as idauto,ifnull(c.tdoc,'00') as refe,b.rdeu_idrd,deud_idcb,ifnull(w.ctas_ctas,'') as bancos,
         ifnull(w.cban_ndoc,'') as nban FROM fe_deu as a
	     inner join fe_rdeu as b ON(b.rdeu_idrd=a.deud_idrd)
	     left join fe_rcom as c ON(c.idauto=b.rdeu_idau)
         left join (SELECT cban_nume,cban_ndoc,g.ctas_ctas,cban_idco FROM  fe_cbancos f  inner join fe_ctasb g on g.ctas_idct=f.cban_idba where cban_acti='A') as w on w.cban_idco=a.deud_idcb
	     WHERE b.rdeu_idpr=?nidclie   and a.acti<>'I' and b.rdeu_acti<>'I' and b.rdeu_codt=?opt  ORDER BY b.rdeu_mone,a.ncontrol,a.fech
	ENDTEXT
Endif
ncon=Abreconexion()
If SQLExec(ncon,lc,"estado")<=0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	CierraConexion(ncon)
	Return 1
Endif
Endfunc
****************************************
Function ActualizaResumenDctoC1(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24,np25,np26,np27)
lc='ProActualizaRCompras1'
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
goapp.npara27=np27
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26,?goapp.npara27)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Actualizando Cabecera de Documento de Compras/Gastos')
	Return 0
Else
	Return 1
Endif
Endfunc
*****************************
Function ActualizaSOLOResumenDcto(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24,np25)
lc='ProActualizaCabeceracv1'
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
	errorbd(ERRORPROC+' Actualizando Cabecera de Documento')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************
Function esFechaValidaAdelantada(dFecha)
Local tnAnio, tnMes, tnDia
tnAnio=Year(dFecha)
tnMes=Month(dFecha)
tnDia=Day(dFecha)
Return ;
	VARTYPE(tnAnio) = "N" And ;
	VARTYPE(tnMes) = "N" And ;
	VARTYPE(tnDia) = "N" And ;
	BETWEEN(tnAnio, 2000, 9999) And ;
	BETWEEN(tnMes, 1, 12) And ;
	BETWEEN(tnDia, 1, 31) And ;
	NOT Empty(Date(tnAnio, tnMes, tnDia))
Endfunc
***************************
Function IngresaDPedidosOrdenados(np1,np2,np3,np4,np5)
lc='FunIngresaDPedidos'
cur="idd"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Ingresando detalle de Pedidos')
	Return 0
Else
	Return idd.Id
Endif
Endfunc
*************
Function ActualizaDpedidosordenados(np1,np2,np3,np4,np5,np6)
lc='ProActualizaDetallePedidos'
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
	errorbd(ERRORPROC+' Actualizando Detalle de Pedidos')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Procedure IngresaInventarioInicial(np1,np2,np3,np4)
lc='ProIngresaInventarioInicial'
cur=""
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Registrando Inventario Inicial')
	Return 0
Else
	Return 1
Endif
Endproc
********************
Procedure GuardaMensajeRptaSunat(np1,np2)
If np1>0 Then
	ncon=Abreconexion()
	TEXT  TO lc noshow
          UPDATE fe_rcom SET rcom_mens=?np2 WHERE idauto=?np1
	ENDTEXT
	If SQLExec(ncon,lc)<0 Then
		errorbd(lc)
	Endif
	CierraConexion(ncon)
Endif
Endproc
***********************************
Function IngresaDocumentoElectronico(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24)
lc='FuningresaDocumentoElectronico'
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
	errorbd(ERRORPROC+' Ingresando Cabecera de Documento CPE')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
****************************************
Define Class MyGridOrd As Grid
*-- Puntero actual al objeto Header
	Header = .F.
	HeaderHeight = 25
	GridLineColor=Rgb(200,200,200)
	HighlightStyle=1
	HighlightForeColor=Rgb(0,0,0)
	FontName="Tahoma"
	RecordMark=.F.
*-- Habilita el orden de las columnas
	Order_Enabled = .F.
	Name = "MyGridOrd"
	Procedure Order_Column
	Lparameters toColumn, tcField
	Local tcCaption, tlWordWrap
	Do Case
	Case Pemstatus(toColumn,"Header1",5)
		tcCaption = toColumn.Header1.Caption
		tlWordWrap = toColumn.Header1.WordWrap
		toColumn.RemoveObject('Header1')
	Case Pemstatus(toColumn,"MyHeader",5)
		tcCaption = toColumn.MyHeader.Caption
		tlWordWrap = toColumn.MyHeader.WordWrap
		toColumn.RemoveObject('MyHeader')
	Endcase
	toColumn.AddObject('MyHeader', 'MyHeaderOrd', tcField)
	toColumn.MyHeader.Caption = tcCaption
	toColumn.MyHeader.WordWrap = tlWordWrap
	Endproc
	Procedure Order_All
	Local lo, lc
	For Each lo In This.Columns
*-- No ordena las columnas que tengan algun valor en la propiedad TAG
		If Empty(lo.Tag)
			lc =  Substr(lo.ControlSource,At(".", lo.ControlSource) + 1)
*-- Quita los caracteres especiales del ControlSource
			lc = Chrtran(lc, ["'+-/*().,;], [])
			This.Order_Column(lo, lc)
		Endif
	Endfor
	Endproc
	Procedure Init
	DoDefault()
	If This.Order_Enabled
		This.Order_All()
	Endif
	Endproc
Enddefine

*------------------------------------------------------
* Clase Column y Header para ordenar las columnas
* de una Grilla con un Click en el Header
*------------------------------------------------------
Define Class MyColumnOrd As Column
*-- Nada
Enddefine

Define Class MyHeaderOrd As Header
	FontSize = 8
	FontBold = .T.
	Alignment = 2
	nNoReg = 0
	cField = ""
	nOrder = 0
	cFieldType = "U"
	lCyclic = .F. && El orden pasa de ASC > DESC > NO ORDEN > ASC > Etc...
	Procedure Init(tcField)
	Local  ln1, ln2
	This.cField = Upper(tcField)
	ln1 = Afields(laFields, This.Parent.Parent.RecordSource)
	If ln1 > 0
		ln2 = Ascan(laFields, This.cField, -1, -1, 1, 11)
		If ln2 > 0
			This.cFieldType = laFields(ln2, 2)
		Endif
	Endif
	If Not Inlist(This.cFieldType, "U", "G", "M", "W")
		This.Picture = Locfile(Home(4) + "Bitmaps\Tlbr_w95\DELETE.BMP", "BMP")
		This.MousePointer = 15 && Mano
	Endif
	Endproc
	Procedure Click
	If Inlist(This.cFieldType, "U", "G", "M", "W")
*- No se puede ordenar estos tipos de campos
		Return
	Endif
	This.nNoReg = Min(Reccount(This.Parent.Parent.RecordSource), ;
		RECNO(This.Parent.Parent.RecordSource))
	If Vartype(This.Parent.Parent.Header) == "O" And !Isnull(This.Parent.Parent.Header)
		This.Parent.Parent.Header.Picture = Locfile(Home(4) + "Bitmaps\Tlbr_w95\DELETE.BMP", "BMP")
		If This.Parent.Parent.Header.cField <> This.cField
			This.Parent.Parent.Header.nOrder = 0
		Endif
	Endif
	Do Case
	Case This.nOrder = 0
*-- Sin Orden, pasa a ASCending
		If Ataginfo(laTag,"",This.Parent.Parent.RecordSource) > 0 And Ascan(laTag,This.cField,-1,-1,1,1) > 0
*-- Existe el TAG
		Else
			Local lcSetSafety
			lcSetSafety = Set("Safety")
			Set Safety Off
			Select (This.Parent.Parent.RecordSource)
			Execscript( "INDEX ON " + This.cField + " TO " + This.cField + " ADDITIVE")
			Set Safety &lcSetSafety
		Endif
		Execscript("SET ORDER TO " + This.cField + " IN " + This.Parent.Parent.RecordSource + " ASCENDING")
		This.Parent.Parent.Header = This
		This.Picture = Locfile(Home(4) + "Bitmaps\Tlbr_w95\SORTASC.BMP", "BMP")
	Case This.nOrder = 1
*-- Orden ASC, pasa a DESCending
		If Ataginfo(laTag,"",This.Parent.Parent.RecordSource) > 0 And Ascan(laTag,This.cField,-1,-1,1,1) > 0
*-- Existe el TAG
		Else
			Local lcSetSafety
			lcSetSafety = Set("Safety")
			Set Safety Off
			Select (This.Parent.Parent.RecordSource)
			Execscript( "INDEX ON " + tcField + " TO " + This.cField + " ADDITIVE")
			Set Safety &lcSetSafety
		Endif
		Execscript("SET ORDER TO " + This.cField + " IN " + This.Parent.Parent.RecordSource + " DESCENDING")
		This.Parent.Parent.Header = This
		This.Picture = Locfile(Home(4) + "Bitmaps\Tlbr_w95\SORTDES.BMP", "BMP")
	Case This.nOrder = 2 And This.lCyclic
*-- Orden DESC, pasa a Sin Orden
		Execscript("SET ORDER TO 0 IN " + This.Parent.Parent.RecordSource)
		This.Parent.Parent.Header = This
		This.Picture = Locfile(Home(4) + "Bitmaps\Tlbr_w95\DELETE.BMP", "BMP")
	Endcase
	This.nOrder = Mod(This.nOrder + 1, Iif(This.lCyclic,3,2))
	This.Parent.Parent.Refresh()
	If This.nNoReg > 0
		Go (This.nNoReg) In (This.Parent.Parent.RecordSource)
	Endif
	Endproc
	Procedure RightClick
	If Vartype(This.Parent.Parent.Header) <> "O"
*-- Sin orden
		Return
	Endif
*-- Con RightClick (Clic Derecho) quito cualquier orden
	This.nNoReg = Min(Reccount(This.Parent.Parent.RecordSource), ;
		RECNO(This.Parent.Parent.RecordSource))
	Execscript("SET ORDER TO 0 IN " + This.Parent.Parent.RecordSource)
	This.Parent.Parent.Header.nOrder = 0
	This.Parent.Parent.Header.Picture = Locfile(Home(4) + "Bitmaps\Tlbr_w95\DELETE.BMP", "BMP")
	This.Parent.Parent.Header = This
	This.Parent.Parent.Refresh()
	If This.nNoReg > 0
		Go (This.nNoReg) In (This.Parent.Parent.RecordSource)
	Endif
	Endproc
Enddefine

***************************************
Procedure ReduceMemory()

Declare Integer SetProcessWorkingSetSize In kernel32 As SetProcessWorkingSetSize  ;
	Integer hProcess , ;
	Integer dwMinimumWorkingSetSize , ;
	Integer dwMaximumWorkingSetSize
Declare Integer GetCurrentProcess In kernel32 As GetCurrentProcess
nProc = GetCurrentProcess()
bb = SetProcessWorkingSetSize(nProc,-1,-1)
Endproc
******************************************
Function ActualizaPrecioKardexGuias12(np1,np2,np3,np4)
cur=""
lc='PROACTUALIZAPRECIOGUIAS'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Actualizando los Precios de Items de la Guia de Compras')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function ActualizaSoloVendedoresVtas(np1,np2)
cur=""
lc='ProActualizaSoloVendedorVtas'
goapp.npara1=np1
goapp.npara2=np2
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Actualizando Cambio de Vendedor')
	Return 0
Else
	Return 1
Endif
Endfunc
********************************
Function CreaEmpleado(np1,np2,np3,np4,np5,np6,np7,np8)
lc='FUNCREAEmpleado'
cur="xt"
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
	errorbd(ERRORPROC+ ' Creando Empleados')
	Return 0
Else
	Return xt.Id
Endif
Endfunc
***********************************
Function ColoresFondoAlmacen
Lparameters stock
Do Case
Case stock>0
	lnColor =Rgb(255,255,50)
Case stock<0
	lnColor =Rgb(255,0,0)
Otherwise
	lnColor=Rgb(234,234,234)
Endcase
Return lnColor
ENDFUNC
***********************************
Function ColoresFondooferta
Lparameters oferta
IF oferta>0 then
	lnColor =Rgb(0,255,0)
ELSE 
	lnColor=Rgb(234,234,234)
ENDIF 
Return lnColor
Endfunc
**************************************
Function IngresaDatosLCajaEFectivo12(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15)
lc="ProIngresaDatosLcajaEefectivo11"
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
TEXT to lp NOSHOW 
(?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Datos A Libro Caja Efectivo Con Cuentas Contable')
	Return 0
Else
	Return 1
Endif
Endfunc
**********************************
Function IngresaDatosDiarioBProvision(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17)
cur="rild"
lc="FunIngresaDatosLibroDiarioBP"
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
	errorbd(ERRORPROC+ ' '+' Ingresando Asientos Diario Provisionando desde Bancos')
	Return 0
Else
	Return rild.Id
Endif
Endfunc
*************************************
Function IngresaDatosDiarioCProvision(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17)
cur="rild"
lc="FunIngresaDatosLibroDiarioCP"
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
	errorbd(ERRORPROC+ ' '+' Ingresando Asientos Diario Provisionando desde Bancos')
	Return 0
Else
	Return rild.Id
Endif
Endfunc
*********************************
Function ColoresnegritaBalance
Lparameters cestilo
If cestilo='N' Then
	lnColor = .T.
Else
	lnColor=.F.
Endif
Return lnColor
Endfunc
************************************
Function ColoresTitulo
Lparameters cestilo
If cestilo='N' Then
	lnColor = Rgb(210,210,210)
Else
	lnColor=Rgb(233,233,233)
Endif
Return lnColor
Endfunc
******************************
Function ValidarCorreo
Lparameters email && la cuenta
If Vartype(email) # "C"
	Return .F.
Endif
loRegExp = Createobject("VBScript.RegExp")
loRegExp.IgnoreCase = .T.
loRegExp.Pattern =  '^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)­*)\.([A-Za-z]{2,})$'
m.valid = loRegExp.Test(Alltrim(m.email))
Release loRegExp
Return m.valid
Endfunc
**************************
Function  CreaVendedor(np1,np2,np3,np4,np5,np6)
cur="VV"
lc="FunCreaVendedor"
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
	errorbd(ERRORPROC+ ' '+' Registrando Nuevos Vendedores')
	Return 0
Else
	Return vv.Id
Endif
Endfunc
******************************
Function MuestraSaldosDctosVtasPorCliente(ccursor,np1)
TEXT TO lc NOSHOW
	    SELECT a.idclie,a.ndoc,a.importe,a.mone,a.banc,a.fech,
	    a.fevto,a.tipo,a.dola,a.docd,a.nrou,a.banco,a.idcred,a.idauto,a.nomv,a.ncontrol FROM
	    vpdtespagoc as a where idclie=?np1
ENDTEXT
ncon=Abreconexion()
If SQLExec(ncon,lc,ccursor)<0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	CierraConexion(ncon)
	Return 1
Endif
Endfunc
*****************************
Function IngresaCreditosNormalFormaPago(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
lc='FUNREGISTRACREDITOSFormaPago'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Créditos')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
****************************
Function IngresaResumenPedidos1(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
lc='FUNINGRESACABECERAPedido'
cur="idpedidos"
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
	errorbd(ERRORPROC+' Ingresando Resumen de Pedidos')
	Return 0
Else
	Return idpedidos.Id
Endif
Endfunc
***********
Function ActualizaResumenPedidos1(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
lc='PROACTUALIZAPedido1'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Editando Resumen de Pedidos')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************************
Function IngresaDatosLCajaEDEudasX(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
lc="FunIngresaDatosLcajaEDeudas"
cur="Deud"
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
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,
     ?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Cancelaciones de Proveedores a Caja Efectivo')
	Return 0
Else
	Return Deud.Id
Endif
Endfunc
*************************************
Function IngresaDpedidosCflete(np1,np2,np3,np4,np5)
lc='FunIngresaDPedidos'
cur="DP1"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Detalle de Pedidos')
	Return 0
Else
	Return Dp1.Id
Endif
Endfunc
*************************
Function ActualizaDpedidosCflete(np1,np2,np3,np4,np5,np6)
lc='ProActualizaDetallePedidos'
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
	errorbd(ERRORPROC+ 'Actualizando Detalle de Pedidos')
	Return 0
Else
	Return 1
Endif
Endfunc
************************
Function IngresaDatosLCajaEFectivoCturnos(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16)
lc="ProIngresaDatosLcajaEfectivoCturnos"
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
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,
      ?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Datos A Libro Caja Efectivo Con Cuentas Contable')
	Return 0
Else
	Return 1
Endif
ENDFUNC
*******************************
Function IngresaDatosLCajaEFectivoCturnos31(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17)
lc="ProIngresaDatosLcajaEfectivoCturnos10"
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
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,
      ?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Datos A Libro Caja Efectivo Con Cuentas Contable')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************************
Function MOstrarCrossVentas(np1,np2,np3,ccursor)
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
lc="Crosstab"
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd('Mostrando Ventas Por Volumen')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************
Function MOstrarCrossVentasLineas(np1,np2,np3,ccursor)
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
lc="CrosstabVtasLIneas"
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd('Mostrando Ventas Por Volumen')
	Return 0
Else
	Return 1
Endif
Endfunc
******************************
Procedure OpcionesGrid
Lparameters opt,CALIAS,citulo,cinforme
Try
	Go Top In (CALIAS)
	If VerificaAlias(CALIAS)=1 Then
		Do Case
		Case opt=1
			Report Form (cinforme) To Printer Prompt Noconsole
		Case opt=2
			Exp2Excel(CALIAS, "", cTitulo)
		Endcase
	Endif
Catch To oerror
	Messagebox("No se Genero el Informe",16,'Sisven')
Endtry
Endproc
*************************************
Function ActualizaCostos10(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10)
cur=""
lc="ProActualizaPreciosProducto1"
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
If EJECUTARP(lc,lp,cur)<1 Then
	errorbd(ERRORPROC+ ' Actualizando Precios al Producto Con Usuario')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************
Function ActualizaMargenesVtas1(np1,np2,np3,np4,np5)
lc="ProActualizaMargenesVta1"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
ccur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
ENDTEXT
If EJECUTARP(lc,lp,ccur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Actualizar Margenes de Ventas')
	Return 0
Else
	Return 1
Endif
Endfunc
*****************************
Function ActualizaMargenesVtas10(np1,np2,np3,np4,np5,np6)
lc="ProActualizaMargenesVta1"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
goapp.npara6=np6
ccur=""
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
ENDTEXT
If EJECUTARP(lc,lp,ccur)=0 Then
	errorbd(ERRORPROC+ ' No Se Puede Actualizar Margenes de Ventas')
	Return 0
Else
	Return 1
Endif
Endfunc
*****************************
Function Coloresnegrita1
Lparameters stock
If stock<0 Then
	lnColor = .T.
Else
	lnColor=.F.
Endif
Return lnColor
Endfunc
**********************
Function coloresNegrita2
Lparameters stock
If stock>0 Then
	lnColor = .T.
Else
	lnColor=.F.
Endif
Return lnColor
Endfunc
*********************
Function colorestexto
Lparameters stock
If stock>0 Then
	lnColor = Rgb(255,0,0)
Else
	lnColor=Rgb(0,0,0)
Endif
Return lnColor
Endfunc
*******************
Function colorestiendanorplast
Lparameters ctienda
If LEFT(ctienda,5)='PIURA' Then
	lnColor =Rgb(128,255,128)
Else
	lnColor=Rgb(234,234,234)
Endif
Return lnColor
ENDFUNC
*******************
Function coloresmoneda
Lparameters cmone
If cmone='D' Then
	lnColor =Rgb(128,255,128)
Else
	lnColor=Rgb(234,234,234)
Endif
Return lnColor
Endfunc
*****************
Function colorestado
Lparameters cestado
If cestado='I' Then
	lnColor =Rgb(255,128,128)
Else
	lnColor=Rgb(234,234,234)
Endif
Return lnColor
Endfunc
*****************
Function ColoresFondoTienda
Lparameters stock
If stock>0 Then
	lnColor =Rgb(255,255,128)
Else
	lnColor=Rgb(234,234,234)
Endif
Return lnColor
Endfunc
*****************
Function ColoresFondoInterno
Lparameters stock
If stock>0 Then
	lnColor =Rgb(255,0,0)
Else
	lnColor=Rgb(234,234,234)
Endif
Return lnColor
Endfunc
*************************
Function  ColoresFondoTotalStock
Lparameters stock
If stock>=0 Then
	lnColor =Rgb(234,234,234)
Else
	lnColor=Rgb(128,0,0)
Endif
Return lnColor
Endfunc
**********************
Function Coloresformapago
Lparameters cformap
If cformap='C' Then
	lnColor =Rgb(255,0,0)
Else
	lnColor=Rgb(0,0,0)
Endif
Return lnColor
Endfunc
********************
Function Coloresnegritaformapago
Lparameters cformap
If cformap='C' Then
	lnColor = .T.
Else
	lnColor=.F.
Endif
Return lnColor
Endfunc
********************
Function Colorcosto
Lparameters ncostosf,ncostoneto
If ncostosf=ncostoneto Then
	lnColor =Rgb(234,234,234)
Else
	lnColor=Rgb(255,128,192)
Endif
Return lnColor
Endfunc
********************
Function ColoresFondox
Lparameters nuno,ndos,ntres
Do Case
Case nuno>0
	lnColor =Rgb(255,255,128)
Case ndos>0

Case ntres>0

Endcase

Return lnColor
Endfunc
****************************
Function IngresaDatosLCajaEFectivoTransferencia(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
lc="ProIngresaDatosLcajaEefectivoTransferencia"
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
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,
      ?goapp.npara12,?goapp.npara13,?goapp.npara14)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Datos A Libro Caja Efectivo Sin Cuentas Contable')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************************************
Function AnulaTransaccionConMotivo(ctdoc,cndoc,ctipo,nauto,cu,ga,df,cu1,cglosa)
If SQLExec(goapp.bdconn,"call proAnulaTransacciones(@estado,?ctdoc,?cndoc,?ctipo,?nauto,?cu,?ga,?df,?cu1,?cglosa)") < 1
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
************************************************
Function IngresaDetalleVTa(np1,np2,np3,np4,np5,np6,np7)
Local cur As String
lc='ProIngresaDetalleVta'
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
	errorbd(ERRORPROC+ ' Ingresando Detalle de la Venta Por Servicios  ')
	Return 0
Else
	Return 1
Endif
Endfunc
******************************
Function ActualizaDetalleVTa(np1)
Local cur As String
lc='ProActualizaDetalleVta'
cur=""
goapp.npara1=np1
TEXT to lp noshow
	     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ '  Actualizando detalle de la Venta Por Servicios  ')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************************
Function IngresaDatosLCajaEDEudasConInteres(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
lc="FunIngresaDatosLcajaEDeudasInteres"
cur="Deud"
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
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,
     ?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Interes a Caja Efectivo')
	Return 0
Else
	Return Deud.Id
Endif
Endfunc
****************************************
Function IngresaResumenDctoVtas(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24,np25)
lc='FUNingresaCabeceracvtas'
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
goapp.npara25=np25
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Ingresando Cabecera de Documento de VENTAS')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
******************************
Function IngresaDocumentoElectronicoVtas(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23)
lc='FuningresaDocumentoElectronicoVtas'
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
	errorbd(ERRORPROC+' Ingresando Cabecera de Documento Electrónico de Ventas ')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
*************************************
Function IngresaDocumentoElectronicoVtas10(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24)
lc='FuningresaDocumentoElectronicoVtas'
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
	errorbd(ERRORPROC+' Ingresando Cabecera de Documento Electrónico de Ventas ')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
*************************************
Function ActualizaSoloVendedoresVtasx(np1,np2,np3)
cur=""
lc='ProActualizaSoloVendedorVtas'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Actualizando Cambio de Vendedor')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************************
Function PermiteIngresoCajaYBancos(np1,np2)
If np2='B' Then
	TEXT TO lc NOSHOW TEXTMERGE
         cban_idco FROM fe_cbancos a WHERE a.cban_acti='A' AND trim(a.cban_ndoc)=<<trim(np1)>>
	ENDTEXT
Else
	TEXT TO lc NOSHOW TEXTMERGE
         lcaj_idca FROM fe_lcaja a WHERE a.lcaj_acti='A' AND trim(a.lcaj_ndoc)=<<trim(np1)>>
	ENDTEXT
Endif
If Ejecutaconsulta(lc,'YaRe')<0 Then
	Return 0
Else
	If REGDVTO("Yare")>0 Then
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
****************************************
Function CFECHAS(df)
Return Alltrim(Str(Year(df)))+'-'+Alltrim(Str(Month(df)))+'-'+Alltrim(Str(Day(df)))
ENDFUNC 
****************************************
Define Class Empresa As Custom
	Empresa=""
	nruc=""
	fono=""
	Correo=""
	RazonFirmad=""
	RucFirmaD=""
	Gene_cert=""
	Gene_usol=""
	Gene_usol1=""
	Gene_csol1=""
	Ubigeo=""
	Ciudad=""
	Distrito=""
	claveCertificado=""
	gene_ccor=""
	gene_csol=""
	gene_nres=1
	gene_nbaj=1
	ptop=""
	gene_rsol=""
	correo1=""
	Impresionticket=""
Enddefine
***************************
Function ActualizaResumenDctoVtas(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24,np25)
lc='ProActualizaCabeceracvtas'
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
	errorbd(ERRORPROC+' Actualizando Cabecera de Documento')
	Return 0
Else
	Return 1
Endif
Endfunc
*************************
Function SiDocumentoYaRegistrado(np1,np2,np3)
lc="FUNVALIDADCTOS"
cur="idventas"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Verificando si Ya Existe Un Documento Ya Registrado con este Número')
	Return 0
Else
	If idventas.Id>0 Then
		Return 0
	Else
		Return 1
	Endif
Endif
Endfunc
*****************************
Function RegistraUnidadesPR(np1,np2)
TEXT TO lc NOSHOW
        UPDATE fe_presentaciones SET pres_unid=?np2 WHERE pres_idpr=?np1
ENDTEXT
ncon=Abreconexion()
If SQLExec(ncon,lc)<0 Then
	errorbd(lc)
	Return 0
Else
	CierraConexion(ncon)
	Return 1
Endif
Endfunc
*************************
Function Colorprecio
Lparameters nprecio
If nprecio=0 Then
	lnColor =Rgb(234,234,234)
Else
	lnColor=Rgb(128,255,128)
Endif
Return lnColor
Endfunc
****************************
Function IngresaDatosLCajaE13(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11)
lc="FunIngresaDatosLcajaE13"
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
goapp.npara11=np11
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Datos A Libro Caja Efectivo')
	Return 0
Else
	Return Ca.Id
Endif
Endfunc
************************
Function IngresaDatosLCajaE12(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10)
lc="FunIngresaDatosLcajaE12"
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
********************************
Function IngresaDatosDiarioM(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17)
cur="rild"
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
goapp.npara17=np17
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' '+' Ingresando Asientos Diario')
	Return 0
Else
	Return rild.Id
Endif
Endfunc
***********************************
Function IngresaDatosDiarioInicialM(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17)
cur="l"
lc="FunIngresaDatosLibroDiarioInicial"
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
	errorbd(ERRORPROC+ ' '+' Ingresando Asientos Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************************
Function ActualizaDatosDiarioM(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17)
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
goapp.npara17=np17
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Actualizando Asientos del Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************************
Function ActualizaDatosDiarioInicialM(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17)
Local cur As String
lc='PROACTUALIZADATOSDIARIOInicial'
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
	errorbd(ERRORPROC+ ' Actualizando Asientos del Diario')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************************
Function IngresaDatosLCajaEDEudas11(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
lc="FunIngresaDatosLcajaEDeudas"
cur="Deud"
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
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,
     ?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Cancelaciones de Proveedores a Caja Efectivo')
	Return 0
Else
	Return Deud.Id
Endif
Endfunc
*********************************
Function IngresaDatosLCajaEDEudasConInteres11(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15)
lc="FunIngresaDatosLcajaEDeudasInteres"
cur="Deud"
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
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,
     ?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Interes a Caja Efectivo')
	Return 0
Else
	Return Deud.Id
Endif
Endfunc
****************************************
Function IngresaDatosLCajaEFectivoCturnos1(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16)
lc="ProIngresaDatosLcajaEfectivoCturnos1"
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
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,
      ?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Datos A Libro Caja Efectivo Con Cuentas Contable')
	Return 0
Else
	Return 1
Endif
*******************************************
Function IngresaDocumentoElectronicoCturno(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24)
lc='FuningresaDocumentoElectronicoCt'
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
***************************
Function colorcostook
Lparameters stock
If stock=1 Then
	lnColor = Rgb(0,255,0)
Else
	lnColor=Rgb(224,224,224)
Endif
Return lnColor
ENDFUNC
************
Function colorStockok
Lparameters stock
If stock=1 Then
	lnColor = Rgb(0,255,0)
Else
	lnColor=Rgb(224,224,224)
Endif
Return lnColor
Endfunc
****************
Function colorstockfaltante
Lparameters stock,stockmin
If stock<0 OR stock<stockmin Then
	lnColor = Rgb(255,0,0)
Else
	lnColor=Rgb(224,224,224)
Endif
Return lnColor
Endfunc
*******************************
Function IngresaDocumentoElectronicoCanjeado(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24)
lc='FuningresaDocumentoElectronicoCanjeado'
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
************************
Function IngresaDatosLCajaEFectivoCturnosDvto(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16)
lc="funIngresaDatosLcajaEfectivoCturnos"
cur="ft"
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
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,
      ?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Datos A Libro Caja Efectivo Con Cuentas Contable')
	Return 0
Else
	Return ft.Id
Endif
Endfunc
***************************
Function ActualizaPedidoVtasFacturado(np1)
lc="PROActualizaPedidoVtasFacturado"
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
**********************************
Function ActualizaKardex1(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13)
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Actualizando Kardex 1')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function AbreconexionSqlserver(opcion)
Local idconecta As Integer
camino = Fullpath('conexionsqlserver.txt')
cxml=Fullpath('conexionsqlserver.xml')
cusuario=""
cpw=""
If File(camino)  && verificar si el archivo existe?
	gnErrFile = Fopen(camino,12)&&si es así,abrir para leer y   escribir
	cservidor = Fgets(gnErrFile)
	cdatabase = Fgets(gnErrFile)
	cusuario = Fgets(gnErrFile)
	cpw = Fgets(gnErrFile)
	=Fclose(gnErrFile)
Else
	Return -1
Endif
Set Procedure To capadatos,ple5 Additive
If File(cxml) Then
	cxml2=Filetostr(cxml)
	cservidor=leerxml(cxml2,'<Servidor>','</Servidor>')
	cdatabase=leerxml(cxml2,'<BD>','</BD>')
	cuid=leerxml(cxml2,'<Usuario>','</Usuario')
	cpwd=leerxml(cxml2,'<clave>','</clave')
Endif

*	nHandle = Sqlstringconnect("Driver={SQL Server};Server=EDUARTCH1\SQLEXPRESS;Database=XPUMP_DB;Uid=Eduar;Pwd=12345;")

lcC1 = "Driver={SQL Server};Server=" + cservidor  + ";Database=" + Alltrim(cdatabase) + ";Uid=" + cuid + ";Pwd=" + cpwd + ";"
=SQLSetprop(0,"DispLogin",3)
idconecta = Sqlstringconnect(lcC1) && ESTABLECER LA CONEXION
If idconecta < 1 Then
	errorbd("No se Puede Conectar con la Base de Datos")
	Return -1
Else
	=SQLSetprop(idconecta, 'PacketSize', 5000)
	Return idconecta
Endif
Endfunc
********************************
Function IngresaDatosLCajaEFectivoCturnos20(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20)
lc="ProIngresaDatosLcajaEfectivoCturnos20"
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,
      ?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Datos A Libro Caja Efectivo Con Cuentas Contable')
	Return 0
Else
	Return 1
Endif
ENDFUNC
****************************
Function IngresaDatosLCajaEFectivoCturnos30(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21)
lc="ProIngresaDatosLcajaEfectivoCturnos30"
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,
      ?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Datos A Libro Caja Efectivo Con Cuentas Contable')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************
Function IngresaDatosLCajaEFectivoCturnosTarjetas(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19)
lc="ProIngresaDatosLcajaEfectivoCturnosTarjetas"
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
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,
      ?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Datos A Libro Caja Efectivo Con Cuentas Contable')
	Return 0
Else
	Return 1
Endif
ENDFUNC
***************************
Function IngresaDatosLCajaEFectivoCturnosTarjetas30(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20)
lc="ProIngresaDatosLcajaEfectivoCturnosTarjetas10"
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,
      ?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Datos A Libro Caja Efectivo Con Cuentas Contable')
	Return 0
Else
	Return 1
Endif
Endfunc
**************************
Function IngresaDatosLCajaEFectivoCturnos20Transferencia(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
lc="FunIngresaDatosLcajaEfectivoCturnos20Transferencia"
cur="vtra"
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
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,
      ?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Ingresando Datos A Libro Caja Efectivo Transferencias')
	Return 0
Else
	Return vtra.Id
Endif
Endfunc
****************************
Function ActualizaDatosLCajaETransferencia(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10)
lc="ProActualizaDatosLcajaETransferencia"
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
***************************
Function ActualizaIdTransferenciaCaja(np1)
lc="ProActualizaIDTransferencia"
cur=""
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Actualizando ID de Transferencia')
	Return 0
Else
	Return 1
Endif

Endfunc
***************************************
Function IngresaBancosDiferenciasCambio(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15)
lc='funingresacajaBancosdifCambio'
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
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Registrando EN Caja y Bancos')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc
*********************
Function DesactivaProductos(np1)
TEXT TO lc NOSHOW
   SELECT SUM(IF(tipo='C',cant,-cant)) as stock FROM fe_kar WHERE acti='A' AND idart=?np1 GROUP BY idart
ENDTEXT
If SQLExec(goapp.bdconn,lc,'vs')<1 Then
	errorbd(lc)
	Return 0
Endif
If vs.stock<>0 Then
	Messagebox("Tiene Stock NO es Posible Desactivar",16,MSGTITULO)
	Return 0
Endif
If SQLExec(goapp.bdconn,"CALL PRODESACTIVAPRODUCTOS(?np1)")<1 Then
	errorbd(ERRORPROC)
	Return 0
Endif
Return 1
Endfunc
*************************
Function CuentaRegistros(CALIAS)
If VerificaAlias(CALIAS)=1 Then
	Select (CALIAS)
	Return Reccount()
Else
	Return 0
Endif
Endfunc
****************************
Function VERIFICASALDOCLIENTE(ccodc,nmonto)
Set Classlib To clasesvisuales Additive
osaldos=Createobject("calcularasaldos")
osaldos.ejecutar(ccodc,'C')
ndisponible=Iif(saldos.tsoles<0,Abs(saldos.tsoles),saldos.tsoles)
If nmonto<=ndisponible
	Return 1
Else
	Return 0
Endif
Endfunc
**********************************
*Function MuestraPlanCuentasX(np1,cur)
*lc='PROMUESTRAPLANCUENTAS'
*goapp.npara1=np1
*goapp.npara2=Val(goapp.año)
*TEXT to lp noshow
*     (?goapp.npara1,?goapp.npara2)
*ENDTEXT
*If EJECUTARP(lc,lp,cur)=0 Then
*	errorbd(ERRORPROC+ ' Mostrando Plan Cuentas')
*	Return 0
*Else
*	Return 1
*Endif
*Endfunc
********************************
Function MuestraPlanCuentasX(np1,cur)
lc="PROMUESTRAPLANCUENTAS"
goapp.npara1=np1
goapp.npara2=Val(goapp.año)
TEXT to lp noshow
       (?goapp.npara1,?goapp.npara2)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Mostrando Plan de Cuentas Contables ')
	Return 0
Else
	Return 1
Endif
Endfunc
********************
Function MuestraTProductosDescCod(np1,np2,np3,np4,ccursor)
lc='PromuestraTodoslosproductos'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Mostrando Toda la Lista de Productos')
	Return 0
Else
	Return 1
Endif
Endfunc
*******************
Function coloregresosRojo
Lparameters cestado
If cestado='S' Then
	lnColor =Rgb(255,0,0)
Else
	lnColor=Rgb(234,234,234)
Endif
Return lnColor
Endfunc
*************************
Function MuestraCtasBancosXx(np1,ccursor)
lc="PROmuestraCtasBancos"
goapp.npara1=np1
TEXT to lp noshow
     (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Mostrando Lista de Cuentas Corrientes de Bancos ')
	Return 0
Else
	Return 1
Endif
Endfunc
****************************
Function CreaCtasBancosx(np1,np2,np3,np4,np5,np6)
cur="Creacta"
lc='FUNCREACTASBANCOS'
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
	errorbd(ERRORPROC+ ' Creando Cuentas de Bancos')
	Return 0
Else
	Return creacta.Id
Endif
Endfunc
********************
Function ActualizaCtasBancosx(np1,np2,np3,np4,np5,np6,np7,np8)
lc='PROACTUALIZACTASBANCOS'
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
	errorbd(ERRORPROC+ 'Actualizando Cuentas de Bancos')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************
Function CancelaCreditos(cndoc,nacta,cesta,cmone,cb1,dfech,dfevto,ctipo,nctrl,cnrou,nidrc,cpc,nidus)
If SQLExec(goapp.bdconn,"SELECT FUNINGRESAPAGOSCREDITOS(?cndoc,?nacta,?cesta,?cmone,?cb1,?dfech,?dfevto,?ctipo,?nctrl,?cnrou,?nidrc,?cpc,?nidus) AS NIDC","nidcreditos")<1
	errorbd(ERRORPROC+' Cancelando Creditos')
	Return 0
Else
	Return nidcreditos.nidc
Endif
Endfunc
************
Function AnulaCompras(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10)
Local cur As String
lc='ProAnulaCompras'
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
	     (@estado,?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,
	     ?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ ' Anulando Compras ')
	Return 0
Else
	Return 1
Endif
Endfunc
***************************
Function IngresaDatosLCajaE20(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12)
lc="ProIngresaDatosLcajaE1"
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
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Datos A Libro Caja Efectivo 1')
	Return 0
Else
	Return 1
Endif
Endfunc
***********************
Function TraspasoDatosLCajaE20(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11)
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
goapp.npara11=np11
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+ 'Ingresando Datos A Libro Caja Efectivo Por Transferencia')
	Return 0
Else
	Return Ca.Id
Endif
Endfunc
************************
Function CreaCostoFletes2(np1,np2,np3,np4,np5)
lc="FUNCREAFLETES"
cur="Nidfletes"
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
ENDTEXT
If EJECUTARF(lc,lp,cur)<1 Then
	errorbd(ERRORPROC+ ' Registrando Nuevos costos por Transporte')
	Return 0
Else
	Return Nidfletes.Id
Endif
Endfunc
****************************
Function MuestraProductosDescCod10(np1,np2,np3,np4,np5,ccursor)
lc='PROMUESTRAPRODUCTOS1'
goapp.npara1=np1
goapp.npara2=np2
goapp.npara3=np3
goapp.npara4=np4
goapp.npara5=np5
cpropiedad='ListaPreciosPorTienda'
If !Pemstatus(goapp,cpropiedad,5)
	goapp.AddProperty("ListaPreciosPorTienda","")
Endif
If goapp.ListaPreciosPorTienda='S' Then
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
	ENDTEXT
Else
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	ENDTEXT
Endif
If EJECUTARP(lc,lp,ccursor)=0 Then
	errorbd(ERRORPROC+ ' Mostrando Lista de Productos')
	Return 0
Else
	Return 1
Endif
Endfunc
*****************************
Function DesactivaDtraspaso(np1)
lc='ProDesactivaDtraspaso'
goapp.npara1=np1
ccur=""
TEXT TO lp noshow
   (?goapp.npara1)
ENDTEXT
If EJECUTARP(lc,lp,ccur)=0 Then
	errorbd(ERRORPROC+ ' Desactivando Detalle del Traspaso ')
	Return 0
Else
	Return 1
Endif
Endfunc
*********************************
Function Exp2Excel( ccursor, cFileSave, cTitulo )
If Empty(ccursor)
	ccursor = Alias()
Endif
If Type('cCursor') # 'C' Or !Used(ccursor)
	Messagebox("Parámetros Inválidos",16,MSGTITULO)
	Return .F.
Endif
*********************************
*** Creación del Objeto Excel ***
*********************************
mensaje('Generando')
oExcel = Createobject("Excel.Application")
Wait Clear

If Type('oExcel') # 'O'
	Messagebox("No se puede procesar el archivo porque no tiene la aplicación" ;
		+ Chr(13) + "Microsoft Excel instalada en su computador.",16,MSGTITULO)
	Return .F.
Endif

oExcel.workbooks.Add

Local lnRecno, lnPos, lnPag, lnCuantos, lnRowTit, lnRowPos, i, lnHojas, cDefault

cDefault = Addbs(Sys(5)  + Sys(2003))

Select (ccursor)
lnRecno = Recno(ccursor)
Go Top

*************************************************
*** Verifica la cantidad de hojas necesarias  ***
*** en el libro para la cantidad de datos     ***
*************************************************
lnHojas = Round(Reccount(ccursor)/65000,0)
Do While oExcel.Sheets.Count < lnHojas
	oExcel.Sheets.Add
Enddo

lnPos = 0
lnPag = 0

Do While lnPos < Reccount(ccursor)

	lnPag = lnPag + 1 && Hoja que se está procesando

	mensaje('Exportando   Microsoft Excel...' ;
		+ Chr(13) + '(Hoja '  + Alltrim(Str(lnPag))  + ' de '  + Alltrim(Str(lnHojas)) + ')')

	If File(cDefault  + ccursor  + ".txt")
		Delete File (cDefault  + ccursor  + ".txt")
	Endif

	Copy  Next 65000 To (cDefault  + ccursor  + ".txt") Delimited With Character ";"
	lnPos = Recno(ccursor)

	oExcel.Sheets(lnPag).Select

	XLSheet = oExcel.ActiveSheet
	XLSheet.Name = ccursor + '_' + Alltrim(Str(lnPag))

	lnCuantos = Afields(aCampos,ccursor)

********************************************************
*** Coloca título del informe (si este es informado) ***
********************************************************
	If !Empty(cTitulo)
		XLSheet.Cells(1,1).Font.Name = "Arial"
		XLSheet.Cells(1,1).Font.Size = 12
		XLSheet.Cells(1,1).Font.BOLD = .T.
		XLSheet.Cells(1,1).Value = cTitulo
		XLSheet.Range(XLSheet.Cells(1,1),XLSheet.Cells(1,lnCuantos)).MergeCells = .T.
		XLSheet.Range(XLSheet.Cells(1,1),XLSheet.Cells(1,lnCuantos)).Merge
		XLSheet.Range(XLSheet.Cells(1,1),XLSheet.Cells(1,lnCuantos)).HorizontalAlignment = 3
		lnRowPos = 3
	Else
		lnRowPos = 2
	Endif

	lnRowTit = lnRowPos - 1
**********************************
*** Coloca títulos de Columnas ***
**********************************
	For i = 1 To lnCuantos
		lcName  = aCampos(i,1)
		lcCampo = Alltrim(ccursor) + '.' + aCampos(i,1)
		XLSheet.Cells(lnRowTit,i).Value=lcName
		XLSheet.Cells(lnRowTit,i).Font.BOLD = .T.
		XLSheet.Cells(lnRowTit,i).Interior.ColorIndex = 15
		XLSheet.Cells(lnRowTit,i).Interior.Pattern = 1
		XLSheet.Range(XLSheet.Cells(lnRowTit,i),XLSheet.Cells(lnRowTit,i)).BorderAround(7)
	Next

	XLSheet.Range(XLSheet.Cells(lnRowTit,1),XLSheet.Cells(lnRowTit,lnCuantos)).HorizontalAlignment = 3

*************************
*** Cuerpo de la hoja ***
*************************
	oConnection = XLSheet.QueryTables.Add("TEXT;"  + cDefault  + ccursor  + ".txt", ;
		XLSheet.Range("A"  + Alltrim(Str(lnRowPos))))

	With oConnection
		.Name = ccursor
		.FieldNames = .T.
		.RowNumbers = .F.
		.FillAdjacentFormulas = .F.
		.PreserveFormatting = .T.
		.RefreshOnFileOpen = .F.
		.RefreshStyle = 1 && xlInsertDeleteCells
		.SavePassword = .F.
		.SaveData = .T.
		.AdjustColumnWidth = .T.
		.RefreshPeriod = 0
		.TextFilePromptOnRefresh = .F.
		.TextFilePlatform = 850
		.TextFileStartRow = 1
		.TextFileParseType = 1 && xlDelimited
		.TextFileTextQualifier = 1 && xlTextQualifierDoubleQuote
		.TextFileConsecutiveDelimiter = .F.
		.TextFileTabDelimiter = .F.
		.TextFileSemicolonDelimiter = .T.
		.TextFileCommaDelimiter = .F.
		.TextFileSpaceDelimiter = .F.
		.TextFileTrailingMinusNumbers = .T.
		.Refresh
	Endwith

	XLSheet.Range(XLSheet.Cells(lnRowTit,1),XLSheet.Cells(XLSheet.Rows.Count,lnCuantos)).Font.Name = "Arial"
	XLSheet.Range(XLSheet.Cells(lnRowTit,1),XLSheet.Cells(XLSheet.Rows.Count,lnCuantos)).Font.Size = 8

	XLSheet.Columns.AutoFit
	XLSheet.Cells(lnRowPos,1).Select
	oExcel.ActiveWindow.FreezePanes = .T.

	Wait Clear

Enddo

oExcel.Sheets(1).Select
oExcel.Cells(lnRowPos,1).Select

If !Empty(cFileSave)
	oExcel.DisplayAlerts = .F.
	oExcel.ActiveWorkbook.SaveAs(cFileSave)
	oExcel.Quit
Else
	oExcel.Visible = .T.
Endif

Go lnRecno

Release oExcel,XLSheet,oConnection

If File(cDefault + ccursor + ".txt")
	Delete File (cDefault + ccursor + ".txt")
Endif

Return .T.

Endfunc


***********
Function IngresaDPedidospos(ncoda,ncant,nprec,nidauto,npos)
lc="FunIngresaDPedidos"
goapp.npara1=ncoda
goapp.npara2=ncant
goapp.npara3=nprec
goapp.npara4=nidauto
goapp.npara5=npos
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
ENDTEXT
If EJECUTARF(lc,lp,"IDd")<1 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return idd.Id
Endif
Endfunc
*************
Function ActualizaDpedidospos(ncoda,ncant,nprec,nr,ctipoa,npos)
lc="ProActualizaDetallePedidos"
cur=""
goapp.npara1=ncoda
goapp.npara2=ncant
goapp.npara3=nprec
goapp.npara4=nr
goapp.npara5=ctipoa
goapp.npara6=npos
TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
ENDTEXT
If EJECUTARP(lc,lp,cur)=0 Then
	errorbd(ERRORPROC)
	Return 0
Else
	Return 1
Endif
Endfunc
**************
Function IngresaDocumentoElectronicoconretencion10(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24,np25)
lc='FuningresaDocumentoElectronicoretencion'
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
goapp.npara25=np25
TEXT to lp noshow
 (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
ENDTEXT
If EJECUTARF(lc,lp,cur)=0 Then
	errorbd(ERRORPROC+' Ingresando Cabecera de Documento CPE')
	Return 0
Else
	Return Xn.Id
Endif
Endfunc