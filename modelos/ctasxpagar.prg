Define Class ctasporpagar As OData Of 'd:\capass\database\data.prg'
	estado = ""
	cdcto = ""
	Ctipo = ""
	cdeta = ""
	dFech = Date()
	dfevto = Date()
	Nreg = 0
	Idcaja = 0
	nimpo = 0
	nacta = 0
	cnrou = ""
	codt = 0
	nidprov = 0
	NAuto = 0
	ccta = 0
	Cmoneda = ""
	ndolar = 0
	Calias = ""
	cmodo = ""
	cdetalle = ""
	Cestado = ""
	nidrd = 0
	Ncontrol = 0
	nidldiario = 0
	NidAnticipo = 0
	dfi = Date()
	dff = Date()
	Function buscardcto(cndoc)
	ccursor='c_'+Sys(2015)
	TEXT TO lc NOSHOW
    SELECT ndoc FROM fe_deu WHERE TRIM(ndoc)=?cndoc  AND acti='A'
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1
		Return 0
	Endif
	Select (ccursor)
	If Regdvto(ccursor)>0
		This.cmensaje="Documento de Referencia Ya Registrado"
		Return 0
	Endif
	Return 1
	Endfunc
	Function Registra
	Lparameters Calias, NAuto, Ncodigo, Cmoneda, dFecha, nTotal, ccta, ndolar
	Local Sw, r As Integer
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	If !Used((Calias))
		This.cmensaje = 'no usado'
		Return 0
	Endif
	r = IngresaCabeceraDeudasCctas(NAuto, Ncodigo, Cmoneda, dFecha, nTotal, goApp.nidusua, goApp.Tienda, Id(), ccta)
	If r < 1 Then
		Return 0
	Endif
	Sw = 1
	Select (Calias)
	Go Top
	Scan All
		If IngresaDetalleDeudas(r, tmpd.Ndoc, 'C', dFecha, tmpd.Fevto, tmpd.Tipo, ndolar, tmpd.Impo,  goApp.nidusua, Id(), goApp.Tienda, tmpd.Ndoc, tmpd.Detalle, 'CA') = 0 Then
			Sw = 0
			This.cmensaje = 'Al Registrar Detalle'
			Exit
		Endif
	Endscan
	If Sw = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registramasmas
	Local Sw, r As Integer
	objdetalle=Createobject("empty")
	AddProperty(objdetalle,'nidr',0)
	AddProperty(objdetalle,'cndoc',"")
	AddProperty(objdetalle,'ctipo',"")
	AddProperty(objdetalle,'dfecha',Date())
	AddProperty(objdetalle,'dfevto',Date())
	AddProperty(objdetalle,'ndolar',0)
	AddProperty(objdetalle,'nimpo',0)
	AddProperty(objdetalle,'nrou',"")
	AddProperty(objdetalle,'cdetalle',"")
	AddProperty(objdetalle,'csitua',"")
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	If !Used((This.Calias))
		This.cmensaje = 'Temporal de Registro NO usado'
		Return 0
	Endif
	r = IngresaCabeceraDeudasCctas(This.NAuto, This.nidprov, This.Cmoneda, This.dFech, This.nimpo, goApp.nidusua, This.codt, Id(), This.ccta)
	If r < 1 Then
		Return 0
	Endif
	Sw = 1
	objdetalle.nidr=r
	objdetalle.dFecha=This.dFech
	objdetalle.ndolar=This.ndolar
	Select (This.Calias)
	Go Top
	Scan All
		objdetalle.cndoc=tmpd.Ndoc
		objdetalle.Ctipo='C'
		objdetalle.dfevto= tmpd.Fevto
		objdetalle.nimpo=tmpd.Impo
		objdetalle.nrou= tmpd.Ndoc
		objdetalle.cdetalle=tmpd.Detalle
		objdetalle.csitua='CA'
		If This.IngresaDetalleDeudas(objdetalle)<1 Then
* IngresaDetalleDeudas(r, tmpd.Ndoc, 'C', ,, tmpd.Tipo, , , goApp.nidusua, Id(), This.codt,, , 'CA') = 0 Then
			Sw = 0
			Exit
		Endif
	Endscan
	If Sw = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Registra1
	Lparameters Calias, NAuto, Ncodigo, Cmoneda, dFecha, nTotal, ccta, ndolar
	Local Sw, r As Integer
	If !Used((Calias))
		Return 0
	Endif
	r = IngresaCabeceraDeudas(NAuto, Ncodigo, Cmoneda, dFecha, nTotal, goApp.nidusua, goApp.Tienda, Id())
	If r = 0 Then
		Return 0
	Endif
	Sw = 1
	Select (Calias)
	Go Top
	Scan All
		If IngresaDetalleDeudas(r, tmpd.Ndoc, 'C', dFecha, tmpd.Fevto, tmpd.Tipo, ndolar, tmpd.Impo, ;
				goApp.nidusua, Id(), goApp.Tienda, tmpd.Ndoc, tmpd.Detalle, 'CA') = 0 Then
			Sw = 0
			Exit
		Endif
	Endscan
	If Sw = 1
		Return 1
	Else
		Return 0
	Endif
	Endfunc
	Function RegistraTraspaso
	Lparameters Calias, NAuto, Ncodigo, Cmoneda, dFecha, nTotal, ccta, ndolar, cndoc, cdetalle
	Local Sw, r As Integer
	r = IngresaCabeceraDeudas(NAuto, Ncodigo, Cmoneda, dFecha, nTotal, goApp.nidusua, goApp.Tienda, Id())
	If r = 0 Then
		Return 0
	Endif
	If IngresaDetalleDeudas(r, cndoc, 'C', dFecha, dFecha, 'F', ndolar, nTotal, ;
			goApp.nidusua, Id(), goApp.Tienda, cndoc, cdetalle, 'CA') = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Obtenersaldosporproveedor(nid, ccursor)
	Local lc
	If !Pemstatus(goApp, "cdatos", 5)
		goApp.AddProperty("cdatos", "")
	Endif
	If !Pemstatus(goApp, 'tiendas', 5) Then
		AddProperty(goApp, 'tiendas', '')
	Endif
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Df = Cfechas(This.dFech)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select    `a`.`Ndoc` , `a`.`fech` ,`a`.`dola`,`a`.`nrou`,`a`.`banc` ,  `a`.`iddeu`,`s`.`Fevto` ,  `s`.`saldo` As importe,
    \`s`.`rdeu_idpr` As `Idpr`,  `b`.`rdeu_impc` As importeC,'C' As `situa`,  `b`.`rdeu_idau` As `Idauto`, `s`.`Ncontrol` ,  `a`.`Tipo`,
    \`a`.`banco`     As `banco`,  IFNULL(`c`.`Ndoc`,'0') As `docd`,IFNULL(`c`.`tdoc`,'0') As `tdoc`,  `b`.`rdeu_mone` As `Moneda`,IFNULL(u.nomb,'') As usuario,
    \`b`.`rdeu_codt` As `codt`,  `b`.`rdeu_idrd` As `Idrd`,  `b`.`rdeu_idct`
    \From (Select   Round(Sum((`d`.`Impo` - `d`.`acta`)),2) As `saldo`,
    \`d`.`Ncontrol` ,  Max(`d`.`Fevto`) As `Fevto`,  `r`.`rdeu_idpr` ,  `r`.`rdeu_mone`
    \From `fe_rdeu` `r`
    \Join `fe_deu` `d`   On `d`.`deud_idrd` = `r`.`rdeu_idrd`
    \Where `d`.`Acti` = 'A'  And `r`.`rdeu_Acti` = 'A'  And  rdeu_idpr=<<nid>> And d.fech<='<<df>>'
	If Len(Alltrim(This.Ctipo)) > 0 Then
      \ And d.Tipo='<<this.ctipo>>'
	Endif
	If Len(Alltrim(This.Cmoneda)) > 0 Then
     \ And rdeu_mone='<<this.cmoneda>>'
	Endif
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	     \And rdeu_codt=<<goApp.Tienda>>
		Else
	      \And rdeu_codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
    \Group By `r`.`rdeu_idpr`,`d`.`Ncontrol`,`r`.`rdeu_mone`
    \Having (Round(Sum(`d`.`Impo` - `d`.`acta`),2) > 0.15)) As s
    \Join `fe_prov` `z`   On `z`.`idprov` = `s`.`rdeu_idpr`
    \Join `fe_deu` `a`     On `a`.`iddeu` = `s`.`Ncontrol`
    \Join `fe_rdeu` `b`     On `b`.`rdeu_idrd` = `a`.`deud_idrd`
    \Left Join `fe_rcom` `c` On `c`.`Idauto` = `b`.`rdeu_idau`
    \Left Join fe_usua As u On u.idusua=b.rdeu_idus
    \Order By `s`.`Fevto`
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lc, ccursor) < 1  Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ObtenerVtos
	Lparameters dfi, dff, Calias
	Local lc
	TEXT To lC Noshow Textmerge Pretext 7
	    SELECT w.fech,fevto,nrou,
		CASE r.rdeu_mone WHEN 'S' THEN importe ELSE 0 END AS soles,
		CASE r.rdeu_mone WHEN 'D' THEN importe ELSE 0 END AS dolares,cta.ncta as ncta,
		ncontrol,deud_idrd,banc,tipo,p.razo,r.rdeu_mone  as mone,ndoc FROM
		(SELECT a.fech,a.nrou,a.fevto,b.importe,a.ncontrol,deud_idrd,a.banc,a.tipo,a.ndoc FROM
		(SELECT ROUND(SUM(a.impo-a.acta),2) AS importe,a.ncontrol FROM fe_rdeu AS x
		 INNER JOIN fe_deu AS a  ON a.deud_idrd=x.rdeu_idrd
	     WHERE a.acti<>'I' AND rdeu_acti<>'I' GROUP BY ncontrol HAVING importe<>0) AS b
	     INNER JOIN (SELECT fech,nrou,fevto,ncontrol,deud_idrd,banc,tipo,ndoc FROM fe_deu WHERE acti='A' AND estd='C') AS a
	     ON a.ncontrol=b.ncontrol) AS w INNER JOIN fe_rdeu AS r ON r.`rdeu_idrd`=w.deud_idrd INNER JOIN fe_prov
	    as p ON p.idprov=r.rdeu_idpr left join fe_plan as cta on cta.idcta=r.rdeu_idct
	ENDTEXT
	If  This.ejecutaconsulta(lc, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function estadodecuenta(opt, nidclie, cmx, Calias)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	    \ Select b.rdeu_idpr,a.fech As fepd,a.Fevto As fevd,a.Ndoc,b.rdeu_impc As impc,a.Impo As impd,a.acta As actd,a.dola,
	    \ a.Tipo,a.banc,IFNULL(c.Ndoc,'0000000000') As docd,b.rdeu_mone As mond,a.estd,a.iddeu As nr,
	    \ b.rdeu_idau As Idauto,IFNULL(c.tdoc,'00') As Refe,b.rdeu_idrd,deud_idcb,IFNULL(w.ctas_ctas,'') As bancos,
        \ IFNULL(w.cban_ndoc,'') As nban,IFNULL(T.nomb,'') As Tienda From fe_deu As a
	    \ INNER Join fe_rdeu As b On(b.rdeu_idrd=a.deud_idrd)
	    \ Left Join fe_rcom As c On(c.Idauto=b.rdeu_idau)
        \ Left Join (Select cban_nume,cban_ndoc,g.ctas_ctas,cban_idco From fe_cbancos F
        \ INNER Join fe_ctasb g On g.ctas_idct=F.cban_idba Where cban_acti='A') As w On w.cban_idco=a.deud_idcb
        \ Left Join fe_sucu As T On T.idalma=b.rdeu_codt
	    \ Where b.rdeu_idpr=<<nidclie>>  And b.rdeu_mone='<<cmx>>'  And a.Acti<>'I' And b.rdeu_Acti<>'I'
	If opt > 0 Then
	    \ And b.rdeu_codt=<<opt>>
	Endif
	    \ Order By a.Ncontrol,a.fech,c.Ndoc
	Set Textmerge Off
	Set Textmerge To
	If  This.ejecutaconsulta(lc, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function obtenersaldosTproveedores(ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\     Select a.Ndoc,a.fech,a.Fevto,a.saldo,a.importeC,x.razo, situa,Idauto,Ncontrol,a.Tipo,banco,docd,tdoc,a.Idpr,a.Moneda,codt,dola,
	\     Idrd,a.rdeu_idct,IFNULL(u.nomb,'') As usuario From vpdtespago As a
	\     INNER Join fe_prov As x On x.idprov=a.Idpr
	\     INNER Join fe_rdeu As r On r.rdeu_idrd=a.Idrd
	\     Left Join fe_usua As u On u.idusua=r.rdeu_idus
	If goApp.Cdatos = 'S' Then
	  \Where a.codt=<<goApp.Tienda>>
	Endif
	\ Order By Fevto
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function obtenersaldosTproveedoresx(Df, ccursor)
	F = Cfechas(Df)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
		\Select p.rdeu_idpr As codp,b.razo As proveedor,b.nruc,p.rdeu_idct As idcta,p.rdeu_mone As mone,tsoles,tdolar,
        \IFNULL(q.ncta,'') As ncta,IFNULL(T.Ndoc,'') As Ndoc,IFNULL(T.fech,p.rdeu_fech) As fech,d.iddeu
        \From
        \(Select a.Ncontrol,If(p.rdeu_mone='S',Sum(a.Impo-a.acta),0) As tsoles,
		\If(p.rdeu_mone='D',Sum(a.Impo-a.acta),0) As tdolar,rdeu_idpr
		\From fe_deu As a INNER Join fe_rdeu As p On p.rdeu_idrd=a.deud_idrd
		\Where a.Acti<>'I' And p.rdeu_Acti='A' And a.fech<='<<f>>'
	If  This.codt > 0 Then
	   \ And p.rdeu_codt=<<ltdas.idalma>>
	Endif
	If This.cmodo = 'C' Then
	\  And rdeu_idct>0
	Endif
		\Group By rdeu_idpr,a.Ncontrol,rdeu_mone Having tsoles<>0 Or tdolar<>0) As xx
		\INNER Join fe_prov As b On b.idprov=xx.rdeu_idpr
		\INNER Join fe_deu As d On d.iddeu=xx.Ncontrol
		\INNER Join fe_rdeu As p On p.rdeu_idrd=d.deud_idrd
		\Left Join fe_rcom As T On T.Idauto=p.rdeu_idau
		\Left Join fe_plan As q On q.idcta=p.rdeu_idct
		\Where tsoles>0.30 Or tdolar>0.30 Or tsoles<-0.50 Or tdolar<-0.50 Order By b.razo
	Set Textmerge Off
	Set Textmerge To
*******************
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select p.rdeu_idpr As codp,b.razo As proveedor,b.nruc,p.rdeu_idct As idcta,p.rdeu_mone As mone,tsoles,tdolar,
    \    IFNULL(q.ncta,'') As ncta,IFNULL(T.Ndoc,IFNULL(qq.Ndoc,'')) As Ndoc,IFNULL(T.fech,IFNULL(qq.fech,p.rdeu_fech)) As fech
    \    From
    \    (Select a.Ncontrol,If(p.rdeu_mone='S',Sum(a.Impo-a.acta),0) As tsoles,
	\	If(p.rdeu_mone='D',Sum(a.Impo-a.acta),0) As tdolar,rdeu_idpr
	\	From fe_deu As a INNER Join fe_rdeu As p On p.rdeu_idrd=a.deud_idrd
	\Where a.Acti<>'I' And p.rdeu_Acti='A' And a.fech<='<<f>>'
	If  This.codt > 0 Then
	   \ And p.rdeu_codt=<<This.codt>>
	Endif
	If This.cmodo = 'C' Then
	\  And rdeu_idct>0
	Endif
	\   Group By rdeu_idpr,a.Ncontrol,rdeu_mone Having tsoles<>0 Or tdolar<>0) As xx
	\	INNER Join fe_prov As b On b.idprov=xx.rdeu_idpr
	\	INNER Join fe_deu As d On d.iddeu=xx.Ncontrol
	\	INNER Join fe_rdeu As p On p.rdeu_idrd=d.deud_idrd
	\	Left Join fe_rcom As T On T.Idauto=p.rdeu_idau
	\	Left Join fe_plan As q On q.idcta=p.rdeu_idct
	\	Left Join fe_dcanjes As dd On dd.`canj_idac`=d.`iddeu`
	\	Left Join (Select nn.Ndoc,nn.fech,canj_idca From (Select Max(canj_idca) As canj_idca,Max(canj_idrc) As canj_idrc From fe_dcanjes As dc Where canj_acti='A'
    \   Group By canj_idca Order By canj_idca) As r
    \   INNER Join fe_rdeu As Rd On Rd.rdeu_idrd=r.canj_idrc
    \   INNER Join  fe_rcom As nn On nn.`Idauto`=Rd.rdeu_idau) As qq On qq.canj_idca=dd.`canj_idca`
    \   Where tsoles>0.30 Or tdolar>0.30 Or tsoles<-0.50 Or tdolar<-0.50 Order By b.razo
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ACtualizaDeudas(NAuto, nu)
	lc = "ProActualizaDeudas"
	TEXT To lp Noshow Textmerge
     (<<nauto>>,<<nu>>)
	ENDTEXT
	If  This.ejecutarp(lc, lp, '') < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraSaldosDctos(ccursor)
	F = Cfechas(This.dFech)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
			\Select  a.Ndoc,  a.fech  ,  a.dola ,  a.nrou ,  a.banc ,
			\a.iddeu ,  a.Fevto , s.saldo ,  s.rdeu_idpr As Idpr, b.rdeu_impc As importeC, 'C'  As situa,
			\b.rdeu_idau As Idauto, s.Ncontrol, a.Tipo ,  a.banco,  IFNULL(c.Ndoc,'0') As docd,
			\IFNULL(c.tdoc,'0') As tdoc,  b.rdeu_mone As Moneda,  b.rdeu_codt As codt,  b.rdeu_idrd As Idrd,  b.rdeu_idct As rdeu_idct
			\From  (Select a.Ncontrol,Sum(a.Impo-a.acta) As saldo,rdeu_idpr
			\From fe_deu As a INNER Join fe_rdeu As p On p.rdeu_idrd=a.deud_idrd
			\Where a.Acti<>'I' And p.rdeu_Acti='A' And a.fech<='<<f>>'
	If This.codt > 0 Then
			\ And  rdeu_codt=<<This.codt>>
	Endif
	If This.nidprov > 0 Then
			\ And  rdeu_idpr=<<This.nidprov>>
	Endif
			\Group By rdeu_idpr,a.Ncontrol,rdeu_mone Having saldo<>0) s
			\Join fe_prov z    On z.idprov = s.rdeu_idpr
			\Join fe_deu a      On a.iddeu = s.Ncontrol
			\Join fe_rdeu b      On b.rdeu_idrd = a.deud_idrd
			\Left Join fe_rcom c  On c.Idauto = b.rdeu_idau
			\Order By a.Fevto
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lc, ccursor) < 1  Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function editaregistro()
	If This.estado = "C"
		nimpo = This.nimpo
	Else
		nacta = This.nimpo
	Endif
	Df = Cfechas(This.dFech)
	dFv = Cfechas(This.dfevto)
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	TEXT To lC Noshow Textmerge Pretext 1 + 2 + 4
    UPDATE fe_deu SET ndoc='<<this.cdcto>>',tipo='<<this.ctipo>>',banc='<<this.cdeta>>',fech='<<df>>',fevto='<<dfv>>'  WHERE iddeu=<<this.nreg>>
	ENDTEXT
	If This.Ejecutarsql(lc) < 1
		This.DEshacerCambios()
		Return 0
	Endif
	TEXT To lC Noshow Textmerge
     UPDATE fe_lcaja SET lcaj_fech='<<df>>' WHERE lcaj_idde=<<this.nreg>>
	ENDTEXT
	If Ejecutarsql(lc) < 1
		This.deshacerCambos()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function quitarRegistro()
	If This.estado = 'C' Then
		If This.DesactivaDeudas(This.rdeud) < 1 Then
			Return 0
		Endif
	Else
		If This.DesactivaDDeudas(This.Nreg) < 1 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function DesactivaDDeudas(np1)
	Local cur As String
	Set Procedure To d:\capass\modelos\cajae Additive
	ocaja = Createobject("cajae")
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	lc = 'PRODESACTIVADEUDAS'
	goApp.npara1 = np1
	TEXT To lp Noshow
	     (?goapp.npara1)
	ENDTEXT
	If This.ejecutarp(lc, lp, "") < 1  Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.Idcaja > 0 Then
		If ocaja.DesactivaCajaEfectivoDe(This.Idcaja) < 1 Then
			This.cmensaje = ocaja.cmensaje
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If This.NidAnticipo > 0   Then
		TEXT To lC Noshow Textmerge
	       UPDATE fe_deu AS f SET f.acta=f.acta+<<this.nacta>> WHERE f.iddeu=<<this.NidAnticipo>> AND ncontrol=-1 AND acti='A'
		ENDTEXT
		If This.Ejecutarsql(lc) < 1 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function DesactivaDeudas(np1)
	lc = 'PRODESACTIVACDEUDAS'
	goApp.npara1 = np1
	TEXT To lp Noshow
	     (?goapp.npara1)
	ENDTEXT
	If This.ejecutarp(lc, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function editaregistro1()
	Df = Cfechas(This.dFech)
	dFv = Cfechas(This.dfevto)
	TEXT To lC Noshow Textmerge Pretext 7
         UPDATE fe_deu SET nrou='<<this.cnrou>>',banc='<<this.cdeta>>',fevto='<<dfv>>',fech='<<df>>' WHERE iddeu=<<this.nreg>>
	ENDTEXT
	If This.Ejecutarsql(lc) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function listardetalle(ccursor)
	Df = Cfechas(This.dFech)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\   Select razo,Ndoc,fech,tsoles,tdolar,mone,idprov From (
	\	Select p.rdeu_idpr As idprov,b.razo,p.rdeu_mone As mone,IFNULL(T.Ndoc,'') As Ndoc,IFNULL(T.fech,p.rdeu_fech) As fech,
	\	If(p.rdeu_mone='S',Sum(a.Impo-a.acta),0) As tsoles,If(p.rdeu_mone='D',Sum(a.Impo-a.acta),0) As tdolar
	\	From fe_deu As a
	\	INNER Join fe_rdeu As p On p.rdeu_idrd=a.deud_idrd
	\	INNER Join  fe_prov As b On b.idprov=p.rdeu_idpr
	\	Left Join fe_rcom As T On T.Idauto=p.rdeu_idau
	\	Where a.Acti<>'I' And p.rdeu_Acti='A'  And a.fech<='<<df>>'
	If This.cmodo = 'C' Then
	\  And p.rdeu_idct>0
	Endif
	\Group By p.rdeu_idrd,rdeu_mone)
	\	As T Where T.tsoles<>0 Or T.tdolar<>0 Order By razo
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarparacancelar(ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	cwhere = ''
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select a.Ndoc,a.fech,a.Fevto,a.saldo,a.Moneda,a.importeC,tdoc,a.Idpr,
	\situa,Idauto,Ncontrol,Tipo,banco,docd,tdoc,codt,dola,Idrd,x.razo,rdeu_idct,nrou From vpdtespago As a
	\INNER Join fe_prov As x On x.idprov=a.Idpr
	If goApp.Cdatos = 'S' Then
	  \Where a.codt=<<goApp.Tienda>>
		cwhere = 'S'
	Endif
	If This.nidprov > 0 Then
		If m.cwhere = 'S' Then
	      \ a.Idpr=<<This.nidprov>>
		Else
	      \Where  a.Idpr=<<This.nidprov>>
		Endif
	Endif
	\Order By Fevto
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lc, ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function CancelaDeudas()
	lc = 'FUNINGRESAPAGOSdeudas'
	cur = "dd"
	TEXT To lp Noshow Textmerge
     ('<<cfechas(this.dfech)>>','<<cfechas(this.dfevto)>>',<<this.nacta>>,'<<this.cdcto>>','<<this.cestado>>', '<<this.cmoneda>>','<<this.cdetalle>>','<<this.ctipo>>',<<this.nidrd>>,
      <<goapp.nidusua>>,<<this.ncontrol>>,'','<<ID()>>',<<this.ndolar>>)
	ENDTEXT
	nid = This.EJECUTARf(lc, lp, cur)
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function listaCanjesLetras(ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	dfi = Cfechas(This.dfi)
	dff = Cfechas(This.dff)
	TEXT To lC Noshow Textmerge
	    SELECT rdeu_fech,razo,fechadcto,tdoc,ndoc,Montooriginal,nletra,montocanjeado from(
        select a.rdeu_fech,ifnull(e.fech,w.fech) as fechaDcto,w.impo as montoOriginal,
		cast(0 as decimal(12,2)) as MontoCanjeado,v.razo,ifnull(e.ndoc,'') as ndoc,ifnull(e.tdoc,'') as tdoc,
		'' as nletra,canj_idan,canj_idac,canj_idrc,canj_idca
		from fe_dcanjes as q
		inner join fe_deu as w on w.iddeu=q.canj_idan
		inner join fe_rdeu as a on a.rdeu_idrd=w.deud_idrd
		inner join fe_prov as v on idprov=a.rdeu_idpr
		left join fe_rcom as e on e.idauto=a.rdeu_idau
		where  canj_idan>0 and w.impo>0 and canj_acti='A' and a.rdeu_acti='A' and w.acti='A'
		union all
		SELECT a.rdeu_fech,b.fech,cast(0 as decimal(12,2)) as montoOriginal,
		b.impo as MontoCanjeado,v.razo,'' as ndoc,'' as tdoc,b.ndoc as nletra,canj_idan,canj_idac,canj_idrc,canj_idca
		FROM fe_dcanjes f
		inner join fe_rdeu as a on a.rdeu_idrd=f.canj_idca
		inner join fe_deu as b on b.iddeu=f.canj_idac
		inner join fe_prov as v on v.idprov=a.rdeu_idpr
		where canj_idan=0 and b.impo>0 and canj_acti='A' and b.acti='A' and a.rdeu_acti='A' order by canj_idca,nletra) as x where x.rdeu_fech between '<<dfi>>' and '<<dff>>'
		order by  razo,canj_idca
	ENDTEXT
	If This.ejecutaconsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function calcularsaldosanticipos()
	ccursor = 'c' + Sys(2015)
	TEXT To lC Noshow Textmerge
	SELECT SUM(acta) as acta,deud_idant FROM fe_deu AS d
	INNER JOIN fe_rdeu AS r ON r.rdeu_idrd=d.`deud_idrd`
    WHERE acti='A' AND deud_idant>0 AND ncontrol<>-1 AND rdeu_idpr=<<this.nidprov>> GROUP BY deud_idant,ncontrol
	ENDTEXT
	If This.ejecutaconsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Sw = 1
	Select (ccursor)
	Scan All
		TEXT To lC Noshow Textmerge
	        UPDATE fe_deud as d SET acta=d.deud_mant-<<acta>> where idde=<<cred_idant>> and ncontrol=-1
		ENDTEXT
		If This.Ejecutarsql(lc) < 1 Then
			Sw = 0
			Exit
		Endif
	Endscan
	If Sw = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarpagosenbancos(nidb,ccursor)
	If This.Idsesion>1 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lC NOSHOW TEXTMERGE
    SELECT ifnull(x.ndoc,a.ndoc) as ndoc,acta,banc,ifnull(x.fech,a.fech) as fech
	from fe_deu as a
	inner join fe_rdeu as b on b.rdeu_idrd=a.deud_idrd
	left join fe_rcom as x on x.idauto=b.rdeu_idau
    where deud_idcb=<<nidb>> and a.acti='A'
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarPagodesdeBanco(nidb,ccursor)
	If This.Idsesion>0 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT TO lc NOSHOW TEXTMERGE
        SELECT ifnull(x.ndoc,a.ndoc) as ndoc,acta,banc,ifnull(x.fech,a.fech) as fech
		from fe_deu as a
		inner join fe_rdeu as b on b.rdeu_idrd=a.deud_idrd
		left join fe_rcom as x on x.idauto=b.rdeu_idau
		where deud_idcb=<<nidb>>
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function calcularSaldoproveedor(ccursor)
	If This.Idsesion>0 Then
		Set DataSession To This.Idsesion
	Endif
	lc = 'PROCALCULASALDOSPROVEEDOR'
	TEXT To lp NOSHOW TEXTMERGE
	     (<<this.nidprov>>)
	ENDTEXT
	If This.ejecutarp(lc, lp,ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function resumenctasxpagar(dFecha,ccursor)
	If !Pemstatus(goApp, 'cdatos', 5)
		AddProperty(goApp, 'cdatos', '')
	Endif
	If This.Idsesion>0 Then
		Set DataSession To This.Idsesion
	Endif
	Df=Cfechas(dFecha)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\SELECT c.nruc,c.razo AS proveedor,c.idprov AS codp,r.rdeu_mone,SUM(IF(r.rdeu_mone='S',saldo,0)) AS tsoles,SUM(IF(r.rdeu_mone='D',saldo,0)) AS tdolar,
	\s.nomb AS Tienda FROM
	\(SELECT a.Ncontrol,MIN(fevto) AS fech,ROUND(SUM(a.Impo-a.acta),2) AS saldo
	\FROM fe_deu AS a
	\INNER JOIN fe_rdeu AS xx  ON xx.rdeu_idrd=a.deud_idrd
	\WHERE a.fech<='<<df>>'  AND  a.Acti<>'I' AND xx.rdeu_Acti<>'I'
	If This.codt > 0 Then
	\ And rdeu_codt=<<This.codt>>
	Endif
	\GROUP BY a.Ncontrol HAVING saldo<>0) AS b
	\INNER JOIN fe_deu AS a ON a.iddeu=b.Ncontrol
	\INNER JOIN fe_rdeu AS r ON r.rdeu_idrd=a.deud_idrd
	\INNER JOIN fe_prov AS c ON c.idprov=r.rdeu_idpr
	\INNER JOIN fe_sucu AS s ON s.idalma=r.rdeu_codt
	\GROUP BY nruc,proveedor,codp,tienda ORDER BY proveedor
	Set Textmerge Off
	Set Textmerge To
	If This.ejecutaconsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaDetalleDeudas(objdetalle)
*nidr,cndoc,Ctipo,dFecha,dfevto,Ctipo,ndolar,nimpo,nidus,cpc,nidtda,cnrou,cdetalle,csitua
	lc='FUNINGRESADEUDAS'
	goApp.npara1=objdetalle.nidr
	goApp.npara2=objdetalle.cndoc
	goApp.npara3=objdetalle.Ctipo
	goApp.npara4=objdetalle.dFecha
	goApp.npara5=objdetalle.dfevto
	goApp.npara6=objdetalle.Ctipo
	goApp.npara7=objdetalle.ndolar
	goApp.npara8=objdetalle.nimpo
	goApp.npara9=goApp.nidusua
	goApp.npara10=Id()
	goApp.npara11=goApp.Tienda
	goApp.npara12=objdetalle.nrou
	goApp.npara13=objdetalle.cdetalle
	goApp.npara14=objdetalle.csitua
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
	ENDTEXT
	nid=This.EJECUTARf(lc,lp,'dd')
	If nid<1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function IngresaCabeceraDeudasCctasResumen()
	lc="FUNregistraDeudasCCtas"
	cur="Yr"
	goApp.npara1=This.NAuto
	goApp.npara2=This.nidprov
	goApp.npara3=This.Cmoneda
	goApp.npara4=This.dFech
	goApp.npara5=This.nimpo
	goApp.npara6=goApp.nidusua
	goApp.npara7=This.codt
	goApp.npara8=Id()
	goApp.npara9=This.ccta
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9)
	ENDTEXT
	If This.contransaccion<>'S' Then
		If This.IniciaTransaccion()<1 Then
			Return 0
		Endif
	Endif
	r= This.EJECUTARf(lc,lp,cur)
	If r<1 Then
		If This.contransaccion<>'S' Then
			This.DEshacerCambios()
		Endif
		Return 0
	Endif
	objdetalle=Createobject("empty")
	AddProperty(objdetalle,'nidr',0)
	AddProperty(objdetalle,'cndoc',"")
	AddProperty(objdetalle,'ctipo',"")
	AddProperty(objdetalle,'dfecha',Date())
	AddProperty(objdetalle,'dfevto',Date())
	AddProperty(objdetalle,'ndolar',0)
	AddProperty(objdetalle,'nimpo',0)
	AddProperty(objdetalle,'nrou',"")
	AddProperty(objdetalle,'cdetalle',"")
	AddProperty(objdetalle,'csitua',"")
	objdetalle.nidr=r
	objdetalle.dFecha=This.dFech
	objdetalle.ndolar=This.ndolar
	objdetalle.cndoc=This.cdcto
	objdetalle.Ctipo='C'
	objdetalle.dfevto= This.dFech
	objdetalle.nimpo=This.nimpo
	objdetalle.nrou= This.cdcto
	objdetalle.cdetalle=This.cdetalle
	objdetalle.csitua='CA'
	If This.IngresaDetalleDeudas(objdetalle)<1 Then
		If This.contransaccion<>'S' Then
			This.DEshacerCambios()
		Endif
		Return 0
	Endif
	If This.contransaccion<>'S' Then
		If This.GRabarCambios()<1 Then
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function listardetallepagos(nid,ccursor)
	If This.Idsesion>0 Then
		Set DataSession To This.Idsesion
	Endif
	Calias='c_'+Sys(2015)
	TEXT TO lc NOSHOW TEXTMERGE
		SELECT rdeu_impc,rdeu_fech,impo,acta,ndoc,deud_idrd,canj_idac,canj_idca FROM fe_rdeu AS r
		INNER JOIN fe_deu AS d ON d.`deud_idrd`=r.`rdeu_idrd`
		INNER JOIN fe_dcanjes  AS c ON c.`canj_idac`=d.`iddeu`
		WHERE rdeu_idau=<<nid>> AND LEFT(ndoc,6)='Canjes' AND d.acti='A'
	ENDTEXT
	If This.ejecutaconsulta(lc,Calias)<1 Then
		Return 0
	Endif
	Select (Calias)
	If canj_idca>0 Then
		TEXT TO lc NOSHOW TEXTMERGE
	      SELECT fevto,CAST(IFNULL(d.impo,0) AS DECIMAL(12,2))AS importe,CAST(IFNULL(p.pagos,0) AS DECIMAL(12,2)) AS pagos,x.nomb FROM fe_dcanjes AS b
	      INNER JOIN fe_rdeu AS a ON a.rdeu_idrd=b.canj_idca
	      INNER JOIN fe_usua AS x ON x.idusua=a.rdeu_idus
	      INNER JOIN (SELECT iddeu,impo,ncontrol,fevto FROM fe_deu WHERE acti='A') AS d ON d.`iddeu`=b.`canj_idac`
	      LEFT JOIN (SELECT  ncontrol,SUM(acta) AS pagos FROM fe_deu WHERE acti='A' AND deud_idrd=<<canj_idca>> AND acta>0 GROUP BY ncontrol) AS p ON p.ncontrol=d.ncontrol
	      WHERE b.canj_acti='A' AND canj_idca=<<canj_idca>>  ORDER BY rdeu_fech DESC
		ENDTEXT
		If This.ejecutaconsulta(lc,ccursor)<1 Then
			Return 0
		Endif
	Else
		TEXT TO lc NOSHOW TEXTMERGE
          SELECT fevto,impo AS importe,acta AS pagos,xx.nomb FROM
	      fe_rdeu AS a
	      INNER JOIN fe_deu AS d ON d.`deud_idrd`=a.`rdeu_idrd`
	      INNER JOIN fe_usua AS xx ON xx.idusua=a.rdeu_idus
	      WHERE rdeu_idau=<<nid>> AND rdeu_acti='A' ORDER BY rdeu_fech DESC
		ENDTEXT
	Endif
	If This.ejecutaconsulta(lc,ccursor)< 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine


































