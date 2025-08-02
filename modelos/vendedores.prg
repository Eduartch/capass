Define Class vendedores As Odata Of 'd:\capass\database\data.prg'
	nidv = 0
	dfi = Date()
	dff = Date()
	cnombre=""
	cfono=""
	nmeta=0
	cmodo=""
	Todos=""
	Function validar()
	Do Case
	Case Len(Alltrim(This.cnombre))=0
		This.cmensaje='Ingrese Nombre del Vendedor'
		Return 0
	Case This.buscanombre()=0
		This.cmensaje='Nombre de Vendedor Ya Registrado'
		Return 0
	Case This.cmodo='M' And This.nidv<1
		This.cmensaje='Seleccione un Vendedor'
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function crear()
	If This.validar()<1 Then
		Return 0
	Endif
	goapp.npara1=This.cnombre
	goapp.npara2=This.cfono
	goapp.npara3=This.nmeta
	TEXT TO lc NOSHOW TEXTMERGE
	INSERT INTO fe_vend(nomv,vend_cuot,vend_fono)values(?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	If This.ejecutarsql(lc)<1 Then
		Return 0
	Endif
	This.cmensaje='Ok'
	Return 1
	Endfunc
	Function editar()
	If This.validar()<1 Then
		Return 0
	Endif
	goapp.npara1=This.cnombre
	goapp.npara2=This.cfono
	goapp.npara3=This.nmeta
	TEXT TO lc NOSHOW TEXTMERGE
	UPDATE fe_vend SET nomv=?goapp.npara1,vend_fono=?goapp.npara2,vend_cuot=?goapp.npara3 WHERE idven=<<this.nidv>>
	ENDTEXT
	If This.ejecutarsql(lc)<1 Then
		Return 0
	Endif
	This.cmensaje='Ok'
	Return 1
	Endfunc
	Function buscanombre()
	Ccursor = 'c_' + Sys(2015)
	If Len(Alltrim(This.cnombre)) <= 3 Then
		This.cmensaje = 'Nombre NO Válido'
		Return 0
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lc  Noshow Textmerge
	\Select nomv From fe_vend Where Trim(nomv)="<<TRIM(this.cnombre)>>" And vend_acti<>'I'
	If This.cmodo <> "N"
	 \ And idven<><<this.nidv>>
	Endif
	\ limit 1
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Ccursor) < 1
		Return 0
	Endif
	Select (Ccursor)
	If Len(Alltrim(nomv)) > 0
		This.cmensaje = "Nombre Ya Registrado"
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraVendedores(np1, Ccursor)
	Local lc, lp
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	If Alltrim(goapp.datosvend) <> 'S' Then
		If This.consultardata(np1, Ccursor) < 1 Then
			Return 0
		Endif
	Else
		Create Cursor b_vend From Array cfieldsfevend
		cfilejson = Addbs(Sys(5) + Sys(2003)) +  'v' + Alltrim(Str(goapp.Xopcion)) + '.json'
		If File(m.cfilejson) Then
			responseType1 = Addbs(Sys(5) + Sys(2003)) +  'v' + Alltrim(Str(goapp.Xopcion)) + '.json'
			oResponse = nfJsonRead( m.responseType1 )
			If Vartype(m.oResponse) = 'O' Then
				For Each oRow In  oResponse.Array
					Insert Into b_vend From Name oRow
				Endfor
				Select * From b_vend Into Cursor (Ccursor)
			Else
				If This.consultardata(np1, Ccursor) < 1 Then
					Return 0
				Endif
			Endif
		Else
			If This.consultardata(np1, Ccursor) < 1 Then
				Return 0
			Endif
		Endif
	Endif
	Select (Ccursor)
	Return 1
	Endfunc
	Function Mostrarclientesxvendedor(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\    Select a.Razo as cliente,a.nruc,a.Dire as direccion,a.ciud as ciudad,a.fono,a.fax,a.clie_rpm,ifnull(x.zona_nomb,'') As zona,a.Refe As Referencia,ifnull(v.nomv,'') As vendedor
    \    From fe_clie As a
    \    Left Join fe_zona As x On x.zona_idzo=a.clie_idzo
    \    Left Join fe_vend As v On v.idven=a.clie_codv
    \    Where a.clie_acti='A'
	If This.nidv > 0 Then
        \ And a.clie_codv=<<This.nidv>>
	Endif
        \ Order By zona,a.Razo
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaventaspsysl(nmarca, Ccursor)
	If (This.dff-This.dfi)>120 Then
		This.cmensaje='Máximo 120 Dias'
		Return 0
	Endif
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	 \ Select a.kar_comi*((a.cant*a.Prec)/e.vigv) As comi,a.Idauto,e.Tdoc,e.Ndoc,e.fech,a.cant,a.Prec,
     \ Round(a.cant*a.Prec,2) As timporte,ifnull(b.idmar,Cast(0 As unsigned)) As idmar,e.Mone,a.alma,c.nomv As nomb,e.Form,
     \ e.vigv As igv,Cast(a.Codv As unsigned) As Codv,e.dolar As dola,d.Razo,'v' As Tipo,e.Idcliente,e.Impo From
     \ fe_clie As d
     \ inner Join fe_rcom As e On e.Idcliente=d.idclie
     \ Left Join fe_kar As a On a.Idauto=e.Idauto
     \ Left Join (select idart,idmar from fe_art
	If nmarca>0 Then
        \ where  idmar=<<nmarca>>
	Endif
     \ ) As  b On b.idart=a.idart
     \ Left Join fe_vend As c On c.idven=a.Codv
     \ Where e.Acti<>'I' And a.Acti<>'I'  And e.fech  Between '<<f1>>' And '<<f2>>' And Form='E' And Impo<>0 And e.Tdoc Not In("07","08")
	If This.nidv > 0 Then
     \ And a.Codv=<<This.nidv>>
	Endif
     \ Union All
     \ Select a.kar_comi*((a.cant*a.Prec)/e.vigv) As comi,a.Idauto,e.Tdoc,e.Ndoc,w.fech,a.cant,a.Prec,
	 \ Round(a.cant*a.Prec,2) As timporte,b.idmar,e.Mone,a.alma,c.nomv As nomb,e.Form,
	 \ e.vigv As igv,a.Codv,e.dolar As dola,Razo,'c' As Tipo,rcre_idcl As Idcliente,e.Impo From
	 \ fe_rcred As r
	 \ inner Join fe_cred As w On w.cred_idrc=r.rcre_idrc
	 \ inner Join fe_rcom As e On e.Idauto=r.rcre_idau
	 \ inner Join fe_clie As d On d.idclie=e.Idcliente
	 \ Left Join fe_kar As a On a.Idauto=e.Idauto
	 \ Left Join (select idart,idmar from fe_art
	If nmarca>0 Then
        \ where  idmar=<<nmarca>>
	Endif
     \ ) As  b On b.idart=a.idart
	 \ Left Join fe_vend As c On c.idven=a.Codv
	 \ Where w.fech  Between '<<f1>>' And '<<f2>>' And w.Acti='A' And w.acta>0 And e.Acti='A' And a.Acti='A' And Left(w.Ndoc,2)<>'FN' And Round(e.Impo, 2) = Round(w.acta, 2)
	If This.nidv > 0 Then
     \ And a.Codv=<<This.nidv>>
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Select comi, Idauto, Tdoc, Ndoc, fech, cant, Prec, ;
		timporte, Iif(Vartype(idmar) = 'C', Val(idmar), idmar) As idmar, Mone, alma, nomb, Form, ;
		igv, Iif(Vartype(Codv) = 'C', Val(Codv), Codv) As Codv, dola, Razo, Tipo, Idcliente, Impo From (Ccursor) Into Cursor  (Ccursor)  Readwrite
	Set Textmerge On
	Set Textmerge To Memvar lc1 Noshow Textmerge
	\  Select (0.01*w.acta)/e.vigv As comi,e.Idauto,e.Tdoc,e.Ndoc,w.fech,a.cant,a.Prec,
	\  Round(a.cant*a.Prec,2) As timporte,b.idmar,e.Mone,a.alma,c.nomv As nomb,e.Form,
	\  e.vigv As igv,rcre_codv As Codv,e.dolar As dola,d.Razo,'c' As Tipo,rcre_idcl As Idcliente,w.acta As Impo From
	\  fe_rcred As r
	\  inner Join fe_cred As w On w.cred_idrc=r.rcre_idrc
	\  inner Join fe_rcom As e On e.Idauto=r.rcre_idau
	\  inner Join fe_clie As d On d.idclie=e.Idcliente
	\  inner Join fe_kar As a On a.Idauto=e.Idauto
	\  inner Join (select idart,idmar from fe_art
	If nmarca>0 Then
        \ where idmar=<<nmarca>>
	Endif
     \ ) As  b On b.idart=a.idart
	\  inner Join fe_vend As c On c.idven=r.rcre_codv
	\  Where w.fech  Between '<<f1>>' And '<<f2>>'  And w.Acti='A' And w.acta>0 And e.Acti='A' And Left(w.Ndoc,2)<>'FN' And Round(e.Impo,2)>Round(w.acta,2)
	If This.nidv > 0 Then
     \ And a.Codv=<<This.nidv>>
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc1, 'com') < 1 Then
		Return 0
	Endif
	Select com
	Go Top
	Do While !Eof()
		niDAUTO = com.Idauto
		tacta = 0
		ncomi = 0
		Do While !Eof() And com.Idauto = niDAUTO
			If tacta >= com.Impo Then
				Select com
				Skip
				Loop
			Endif
			If com.timporte < com.Impo Then
				tacta = tacta + com.timporte
				ncomi = com.timporte
			Else
				ncomi = com.Impo
				tacta = tacta + com.Impo
			Endif
			Insert Into (Ccursor)(comi, Idauto, Tdoc, Ndoc, fech, cant, Prec, timporte, Mone, alma, nomb, Form, igv, dola, Razo, Tipo,  Impo, Codv);
				Values((0.01 * ncomi) / com.igv, com.Idauto, com.Tdoc, com.Ndoc, com.fech, com.cant, com.Prec, com.timporte, com.Mone, com.alma, com.nomb, com.Form, ;
				com.igv, com.dola, com.Razo, com.Tipo,  com.Impo, Iif(Vartype(com.Codv) = 'N', com.Codv, Val(com.Codv)))
			Select com
			Skip
		Enddo
		Select com
	Enddo
	Select  * From (Ccursor) Into Cursor (Ccursor)  Order By Codv, fech, Ndoc
	Return 1
	Endfunc
	Function listarcorreosvendedores(Ccursor)
	TEXT To lC Noshow
     select vend_corr from fe_vend where vend_acti='A' and length(trim(vend_corr))>0
	ENDTEXT
	If  This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultardata(np1, Ccursor)
	m.lc		 = 'PROMUESTRAVENDEDORES'
	goapp.npara1 = m.np1
	TEXT To m.lp Noshow Textmerge
       (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, m.Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	nCount = Afields(cfieldsfevend)
	Select * From (Ccursor) Into Cursor a_vend
	cdata = nfcursortojson(.T.)
	cfilejson = Addbs(Sys(5) + Sys(2003)) + 'v' + Alltrim(Str(goapp.Xopcion)) + '.json'
	If File(cfilejson) Then
		Delete File (cfilejson)
	Endif
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'v' + Alltrim(Str(goapp.Xopcion)) + '.json'
	Strtofile (cdata, rutajson)
	goapp.datosvend = 'S'
	Return 1
	Endfunc
	Function listaventas(nmarca, Ccursor)
	If (This.dff-This.dfi)>120 Then
		This.cmensaje='Máximo 120 Dias'
		Return 0
	Endif
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	 \ Select a.kar_comi*((a.cant*a.Prec)/e.vigv) As comi,a.Idauto,e.Tdoc,e.Ndoc,e.fech,a.cant,a.Prec,
     \ Round(a.cant*a.Prec,2) As timporte,ifnull(b.idmar,Cast(0 As unsigned)) As idmar,e.Mone,a.alma,c.nomv As nomb,e.Form,
     \ e.vigv As igv,Cast(a.Codv As unsigned) As Codv,e.dolar As dola,d.Razo,'v' As Tipo,e.Idcliente,e.Impo,e.impo as importe From
     \ fe_clie As d
     \ inner Join fe_rcom As e On e.Idcliente=d.idclie
     \ Left Join fe_kar As a On a.Idauto=e.Idauto
     \ Left Join(select idart,idmar from fe_art
	If nmarca>0 Then
        \ where  idmar=<<nmarca>>
	Endif
     \ ) As  b On b.idart=a.idart
     \ Left Join fe_vend As c On c.idven=a.Codv
     \ Where e.Acti<>'I' And a.Acti<>'I'  And e.fech  Between '<<f1>>' And '<<f2>>' And Form='E' And Impo<>0 And e.Tdoc Not In("07","08")
	If This.nidv > 0 Then
     \ And a.Codv=<<This.nidv>>
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Select  * From (Ccursor) Into Cursor (Ccursor)  Order By Codv, fech, Ndoc
	Return 1
	Endfunc
	Function listatodalassventas(nmarca, Ccursor)
	If (This.dff-This.dfi)>120 Then
		This.cmensaje='Máximo 120 Dias'
		Return 0
	Endif
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select  comision As comi,a.Idauto,e.Tdoc,e.Ndoc,e.fech,e.Impo As importe,e.Mone,e.codt As alma,c.nomv As nomb,e.Form,
	\e.vigv As igv,a.Codv,e.dolar As dola,d.Razo,e.Idcliente From fe_rcom As e
	\INNER Join fe_clie As d On d.idclie=e.Idcliente
	\INNER Join (Select  Sum(k.kar_comi*((k.cant*k.Prec)/r.vigv)) As comision,k.Idauto,Codv From fe_kar As k
	\INNER Join fe_rcom As r On r.Idauto=k.Idauto
	\inner Join (select idart,idmar from fe_art
	If nmarca>0 Then
        \ where  idmar=<<nmarca>>
	Endif
     \ ) As  b On b.idart=k.idart
	\Where r.Idcliente>0 And k.Acti='A' And r.Acti='A' And r.fech Between  '<<f1>>' And '<<f2>>'  And r.Impo<>0
	If This.nidv > 0 Then
	\	And k.Codv=<<This.nidv>>
	Endif
	\Group  By r.Idauto,k.Codv) As a On a.Idauto=e.Idauto
	\Left Join fe_vend As c On c.idven=a.Codv
	\Order By a.Codv,a.Idauto,e.Mone
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaventaspsysu(nidm,Ccursor)
	If (This.dff-This.dfi)>60 Then
		This.cmensaje='Hasta 60 Días'
		Return 0
	Endif
	dfi=cfechas(This.dfi)
	dff=cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\	      SELECT a.kar_comi as comi,a.idauto,e.tdoc,e.ndoc,e.fech,b.idart,a.cant,a.prec,
	\	      ROUND(a.cant*a.prec,2) as timporte,e.mone,a.alma,a.idart,b.idmar,c.nomv as nomb,e.form,
	\	      e.vigv as igv,a.codv,e.dolar as dola,b.descri,b.unid,d.razo FROM fe_clie as d
	\	      inner JOIN fe_rcom as e  ON e.idcliente=d.idclie
	\	      inner join fe_kar as a on a.idauto=e.idauto
	\	      inner join fe_vend as c on c.idven=a.codv
	\	      inner JOIN fe_art as  b ON b.idart=a.idart
	\	      WHERE e.ACTI<>'I' and a.acti<>'I'  and e.fech  BETWEEN '<<dfi>>' and '<<dff>>' and a.alma>0
	If This.nidv>0 Then
		\ and a.codv=<<this.nidv>>
	Endif
	If m.nidm>0 Then
	 \ and b.idmar=<<m.nidm>>
	Endif
	\ ORDER BY a.codv,a.idauto,e.mone
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc,Ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaventaslineas(nidc,Ccursor)
	If (This.dff-This.dfi)>60 Then
		This.cmensaje='Hasta 60 Días'
		Return 0
	Endif
	dfi=cfechas(This.dfi)
	dff=cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\SELECT linea,v.nomv AS vendedor,tcant AS cantidad,timporte AS importe
    \FROM(SELECT ROUND(SUM(a.cant*a.prec),2) AS timporte,SUM(a.`cant`*a.`kar_equi`) AS tcant,a.`codv`,b.`idcat`,cc.`dcat` AS linea FROM fe_rcom AS e
	\INNER JOIN fe_kar AS a ON a.idauto=e.idauto
	\INNER JOIN fe_art AS  b ON b.idart=a.idart
    \INNER JOIN fe_cat AS cc ON cc.`idcat`=b.`idcat`
	\WHERE e.ACTI<>'I' AND a.acti<>'I'  AND e.fech  BETWEEN '<<dfi>>' and '<<dff>>' AND a.alma>0
	If This.nidv>0 Then
		\ and a.codv=<<this.nidv>>
	Endif
	If m.nidc>0 Then
	 \ and cc.idcat=<<m.nidc>>
	Endif
	\GROUP BY b.idcat,cc.`dcat`,a.codv) AS yy
	\INNER JOIN fe_vend AS v ON v.`idven`=yy.codv
	\ORDER BY vendedor,importe DESC
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc,Ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaventasmarcas(nidm,Ccursor)
	If (This.dff-This.dfi)>60 Then
		This.cmensaje='Hasta 60 Días'
		Return 0
	Endif
	dfi=cfechas(This.dfi)
	dff=cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\SELECT marca,v.nomv AS vendedor,tcant AS cantidad,timporte AS importe
    \FROM(SELECT ROUND(SUM(a.cant*a.prec),2) AS timporte,SUM(a.`cant`*a.`kar_equi`) AS tcant,a.`codv`,b.`idcat`,mm.`dmar` AS marca FROM fe_rcom AS e
	\INNER JOIN fe_kar AS a ON a.idauto=e.idauto
	\INNER JOIN fe_art AS  b ON b.idart=a.idart
    \INNER JOIN fe_mar AS mm ON mm.`idmar`=b.`idmar`
	\WHERE e.ACTI<>'I' AND a.acti<>'I'  AND e.fech  BETWEEN '<<dfi>>' and '<<dff>>' AND a.alma>0
	If This.nidv>0 Then
		\ and a.codv=<<this.nidv>>
	Endif
	If m.nidm>0 Then
	 \ and cc.idmar=<<m.nidm>>
	Endif
	\GROUP BY b.idmar,mm.`dmar`,a.codv) AS yy
	\INNER JOIN fe_vend AS v ON v.`idven`=yy.codv
	\ORDER BY vendedor,importe DESC
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc,Ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaventasproducto(Ccursor)
	If (This.dff-This.dfi)>60 Then
		This.cmensaje='Hasta 60 Días'
		Return 0
	Endif
	dfi=cfechas(This.dfi)
	dff=cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\SELECT producto,v.nomv AS vendedor,tcant AS cantidad,timporte AS importe
    \FROM(SELECT ROUND(SUM(a.cant*a.prec),2) AS timporte,SUM(a.`cant`*a.`kar_equi`) AS tcant,a.`codv`,b.`idcat`,b.`descri` AS producto FROM fe_rcom AS e
	\INNER JOIN fe_kar AS a ON a.idauto=e.idauto
	\INNER JOIN fe_art AS  b ON b.idart=a.idart
    \WHERE e.ACTI<>'I' AND a.acti<>'I'  AND e.fech  BETWEEN '<<dfi>>' and '<<dff>>' AND a.alma>0
	If This.nidv>0 Then
		\ and a.codv=<<this.nidv>>
	Endif
	\GROUP BY b.idart,b.`descri`,a.codv) AS yy
	\INNER JOIN fe_vend AS v ON v.`idven`=yy.codv
	\ORDER BY vendedor,importe DESC
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc,Ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaventasconmetas(nlinea,nmarca,Ccursor)
	If (This.dff-This.dfi)>60 Then
		This.cmensaje='Hasta 60 Días'
		Return 0
	Endif
	dfi=cfechas(This.dfi)
	dff=cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\select vendedor,importe,cuota,if(cuota>0,Round((importe*100)/cuota,2),0) As por1 from(
	\SELECT v.nomv AS vendedor,timporte AS importe,
	\IF(vend_cuot>0,IF(DATEDIFF('<<dff>>','<<dfi>>')=0,1,DATEDIFF('<<dff>>','<<dfi>>'))*(vend_cuot/30),0) AS cuota
    \FROM(SELECT ROUND(SUM(a.cant*a.prec),2) AS timporte,a.`codv` FROM fe_rcom AS e
	\INNER JOIN fe_kar AS a ON a.idauto=e.idauto
	\INNER JOIN fe_art AS  b ON b.idart=a.idart
    \WHERE e.ACTI<>'I' AND a.acti<>'I'  AND e.fech  BETWEEN '<<dfi>>' and '<<dff>>' AND a.alma>0
	If This.nidv>0 Then
		\ and a.codv=<<this.nidv>>
	Endif
	If m.nlinea>0 Then
	   \ and b.idcat=<<m.nlinea>>
	Endif
	If m.nmarca>0 Then
	  \ and b.idmar=<<m.nmarca>>
	Endif
	\GROUP BY a.codv) AS yy
	\INNER JOIN fe_vend AS v ON v.`idven`=yy.codv) as aa
	\ORDER BY importe DESC
	Set Textmerge Off
	Set Textmerge To
*	MESSAGEBOX(lc)
	If This.EJECutaconsulta(lc,Ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine






















