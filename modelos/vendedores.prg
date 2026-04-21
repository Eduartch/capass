Define Class vendedores As Odata Of 'd:\capass\database\data.prg'
	nidv = 0
	dfi = Date()
	dff = Date()
	cnombre = ""
	cfono = ""
	nmeta = 0
	cmodo = ""
	Todos = ""
	ctipo = ""
	conmeta = ""
	ncomision = 0
	soloefectivo = ""
	Function validar()
	Do Case
	Case Len(Alltrim(This.cnombre)) = 0
		This.cmensaje = 'Ingrese Nombre del Vendedor'
		Return 0
	Case This.buscanombre() = 0
		This.cmensaje = 'Nombre de Vendedor Ya Registrado'
		Return 0
	Case This.cmodo = 'M' And This.nidv < 1
		This.cmensaje = 'Seleccione un Vendedor'
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function crear()
	oser = Newobject("servicio", " d:\capass\services\service.prg")
	oser.oobjeto = This
	oser.centidad = "vendedores"
	rpta = oser.Inicializar(This, 'vendedores')
	If m.rpta < 1 Then
		This.cmensaje = oser.cmensaje
		Return 0
	Endif
	oser = Null
	goapp.npara1 = This.cnombre
	goapp.npara2 = This.cfono
	goapp.npara3 = This.nmeta
	pc = Id()
	If Lower(Sys(2003)) = '\psysl' Then
		Text To lc Noshow Textmerge
	    INSERT INTO fe_vend(nomv,fechvend,idpcvend)values(?goapp.npara1,localtime,?pc)
		Endtext
	Else
		Text To lc Noshow Textmerge
		INSERT INTO fe_vend(nomv,vend_cuot,vend_fono)values(?goapp.npara1,?goapp.npara2,?goapp.npara3)
		Endtext
	Endif
	If This.ejecutarsql(lc) < 1 Then
		Return 0
	Endif
	This.cmensaje = 'Ok'
	Return 1
	Endfunc
	Function editar()
	oser = Newobject("servicio", " d:\capass\services\service.prg")
	oser.oobjeto = This
	oser.centidad = "vendedores"
	rpta = oser.Inicializar(This, 'vendedores')
	If m.rpta < 1 Then
		This.cmensaje = oser.cmensaje
		Return 0
	Endif
	goapp.npara1 = This.cnombre
	goapp.npara2 = This.cfono
	goapp.npara3 = This.nmeta
	If Lower(Sys(2003)) = '\psysl' Then
		Text To lc Noshow Textmerge
		UPDATE fe_vend SET nomv=?goapp.npara1,cuota=?goapp.npara3 WHERE idven=<<this.nidv>>
		Endtext
	Else
		Text To lc Noshow Textmerge
		UPDATE fe_vend SET nomv=?goapp.npara1,vend_fono=?goapp.npara2,vend_cuot=?goapp.npara3 WHERE idven=<<this.nidv>>
		Endtext
	Endif
	If This.ejecutarsql(lc) < 1 Then
		Return 0
	Endif
	This.cmensaje = 'Ok'
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
	 \ And idven<><<This.nidv>>
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
		cfilejson = Addbs(Sys(5) + Sys(2003)) +  'v' + Alltrim(Str(goapp.xopcion)) + '.json'
		If File(m.cfilejson) Then
			oResponse = nfJsonRead(m.cfilejson)
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
	\    Select a.Razo As cliente,a.nruc,a.Dire As direccion,a.ciud As ciudad,a.fono,a.fax,a.clie_rpm,ifnull(x.zona_nomb,'') As zona,a.Refe As Referencia,ifnull(v.nomv,'') As vendedor
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
	If (This.dff - This.dfi) > 365 Then
		This.cmensaje = 'Máximo 365 Dias'
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
     \ Left Join (Select idart,idmar From fe_art) As  b On b.idart=a.idart
     \ Left Join fe_vend As c On c.idven=a.Codv
     \ Where e.Acti<>'I' And a.Acti<>'I'  And e.fech  Between '<<f1>>' And '<<f2>>' And Form='E' And Impo<>0 And e.Tdoc Not In("07","08")
	If This.nidv > 0 Then
     \ And a.Codv=<<This.nidv>>
	ENDIF
	If nmarca > 0 Then
        \  and  b.idmar=<<nmarca>>
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
	 \ Left Join (Select idart,idmar From fe_art) As  b On b.idart=a.idart
	 \ Left Join fe_vend As c On c.idven=a.Codv
	 \ Where w.fech  Between '<<f1>>' And '<<f2>>' And w.Acti='A' And w.acta>0 And e.Acti='A' And a.Acti='A' And Left(w.Ndoc,2)<>'FN' And Round(e.Impo, 2) = Round(w.acta, 2)
	If This.nidv > 0 Then
     \ And a.Codv=<<This.nidv>>
	ENDIF
	If nmarca > 0 Then
        \ and   b.idmar=<<nmarca>>
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
	\  inner Join (Select idart,idmar From fe_art) As  b On b.idart=a.idart
	\  inner Join fe_vend As c On c.idven=r.rcre_codv
	\  Where w.fech  Between '<<f1>>' And '<<f2>>'  And w.Acti='A' And w.acta>0 And e.Acti='A' And Left(w.Ndoc,2)<>'FN' And Round(e.Impo,2)>Round(w.acta,2)
	If This.nidv > 0 Then
     \ And a.Codv=<<This.nidv>>
	ENDIF
		If nmarca > 0 Then
        \  and  b.idmar=<<nmarca>>
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
	Text To lc Noshow
     select vend_corr from fe_vend where vend_acti='A' and length(trim(vend_corr))>0
	Endtext
	If  This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultardata(np1, Ccursor)
	m.lc		 = 'PROMUESTRAVENDEDORES'
	goapp.npara1 = m.np1
	Text To m.lp Noshow Textmerge
       (?goapp.npara1)
	Endtext
	If This.EJECUTARP(m.lc, m.lp, m.Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	nCount = Afields(cfieldsfevend)
	Select * From (Ccursor) Into Cursor a_vend
	cdata = nfcursortojson(.T.)
	cfilejson = Addbs(Sys(5) + Sys(2003)) + 'v' + Alltrim(Str(goapp.xopcion)) + '.json'
	If File(cfilejson) Then
		Delete File (cfilejson)
	Endif
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'v' + Alltrim(Str(goapp.xopcion)) + '.json'
	Strtofile (cdata, rutajson)
	goapp.datosvend = 'S'
	Return 1
	Endfunc
	Function listaventas(nmarca, Ccursor)
	If (This.dff - This.dfi) > 365 Then
		This.cmensaje = 'Máximo 365 Dias'
		Return 0
	Endif
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	 \ Select a.kar_comi*((a.cant*a.Prec)/e.vigv) As comi,a.Idauto,e.Tdoc,e.Ndoc,e.fech,a.cant,a.Prec,
     \ Round(a.cant*a.Prec,2) As timporte,ifnull(b.idmar,Cast(0 As unsigned)) As idmar,e.Mone,a.alma,c.nomv As nomb,e.Form,Descri,unid,
     \ e.vigv As igv,Cast(a.Codv As unsigned) As Codv,e.dolar As dola,d.Razo,'v' As Tipo,e.Idcliente,e.Impo,e.Impo As importe,ifnull(nomv,'') As nomv From
     \ fe_clie As d
     \ inner Join fe_rcom As e On e.Idcliente=d.idclie
     \ inner Join fe_kar As a On a.Idauto=e.Idauto
     \ inner Join(Select idart,idmar,descri,unid From fe_art) As  b On b.idart=a.idart
     \ inner Join fe_vend As c On c.idven=a.Codv
     \ Where e.Acti<>'I' And a.Acti<>'I'  And e.fech  Between '<<f1>>' And '<<f2>>'  And Impo<>0 And e.Tdoc Not In("07","08")
	If This.soloefectivo = 'E' Then
        \ And Form='E'
	Endif
	If This.nidv > 0 Then
     \ And a.Codv=<<This.nidv>>
	ENDIF
	If nmarca > 0 Then
        \ and b.idmar=<<nmarca>>
	Endif
    \ Order By c.nomv
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Select  * From (Ccursor) Into Cursor (Ccursor)  Order By nomv, fech, Ndoc
	Return 1
	Endfunc
	Function listatodalassventas(nmarca, Ccursor)
	If (This.dff - This.dfi) > 240 Then
		This.cmensaje = 'Máximo 240 Dias'
		Return 0
	Endif
	If !Pemstatus(goapp, 'proyecto', 5) Then
		AddProperty(goapp, 'proyecto', '')
	Endif
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select  comision As comi,a.Idauto,e.Tdoc,e.Ndoc,e.fech,e.Impo As importe,e.Mone,e.codt As alma,c.nomv As nomb,e.Form,
	\e.vigv As igv,a.Codv,e.dolar As dola,d.Razo,e.Idcliente From fe_rcom As e
	\inner Join fe_clie As d On d.idclie=e.Idcliente
	\inner Join (Select  Sum(k.kar_comi*((k.cant*k.Prec)/r.vigv)) As comision,k.Idauto,Codv From fe_kar As k
	\inner Join fe_rcom As r On r.Idauto=k.Idauto
	\inner Join (Select idart,idmar From fe_art) As  b On b.idart=k.idart
	\Where r.Idcliente>0 And k.Acti='A' And r.Acti='A' And r.fech Between  '<<f1>>' And '<<f2>>'  And r.Impo<>0
	If This.nidv > 0 Then
	\	And k.Codv=<<This.nidv>>
	ENDIF
	If nmarca > 0 Then
        \  and   b.idmar=<<nmarca>>
	Endif
	If goapp.proyecto = 'psysg' Then
	  \ And exon<>'S'
	Endif
	\Group  By r.Idauto,k.Codv) As a On a.Idauto=e.Idauto
	\Left Join fe_vend As c On c.idven=a.Codv
	\Order By c.nomv,a.Idauto,e.Mone
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaventaspsysu(nidm, Ccursor)
	If (This.dff - This.dfi) > 365 Then
		This.cmensaje = 'Hasta 365 Días'
		Return 0
	Endif
	dfi = cfechas(This.dfi)
	dff = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\	      Select a.kar_comi As comi,a.Idauto,e.Tdoc,e.Ndoc,e.fech,b.idart,a.cant,a.Prec,
	\	      Round(a.cant*a.Prec,2) As timporte,e.Mone,a.alma,a.idart,b.idmar,c.nomv As nomb,e.Form,
	\	      e.vigv As igv,a.Codv,e.dolar As dola,b.Descri,b.unid,d.Razo From fe_clie As d
	\	      inner Join fe_rcom As e  On e.Idcliente=d.idclie
	\	      inner Join fe_kar As a On a.Idauto=e.Idauto
	\	      inner Join fe_vend As c On c.idven=a.Codv
	\	      inner Join fe_art As  b On b.idart=a.idart
	\	      Where e.Acti<>'I' And a.Acti<>'I'  And e.fech  Between '<<dfi>>' And '<<dff>>' And a.alma>0
	If This.nidv > 0 Then
		\ And a.Codv=<<This.nidv>>
	Endif
	If m.nidm > 0 Then
	 \ And b.idmar=<<m.nidm>>
	Endif
	\ Order By a.Codv,a.Idauto,e.Mone
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaventaslineas(nidc, Ccursor)
	If (This.dff - This.dfi) > 365 Then
		This.cmensaje = 'Hasta 365 Días'
		Return 0
	Endif
	dfi = cfechas(This.dfi)
	dff = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select idcat,linea,v.nomv As vendedor,tcant As cantidad,timporte As importe
    \From(Select Round(Sum(a.cant*a.Prec),2) As timporte,Sum(a.`cant`*a.`kar_equi`) As tcant,a.`Codv`,b.`idcat`,cc.`dcat` As linea From fe_rcom As e
	\inner Join fe_kar As a On a.Idauto=e.Idauto
	\inner Join fe_art As  b On b.idart=a.idart
    \inner Join fe_cat As cc On cc.`idcat`=b.`idcat`
	\Where e.Acti<>'I' And a.Acti<>'I'  And e.fech  Between '<<dfi>>' And '<<dff>>' And a.alma>0 And Idcliente>0
	If This.nidv > 0 Then
		\ And a.Codv=<<This.nidv>>
	Endif
	If m.nidc > 0 Then
	 \ And cc.idcat=<<m.nidc>>
	Endif
	\Group By b.idcat,cc.`dcat`,a.Codv) As yy
	\inner Join fe_vend As v On v.`idven`=yy.Codv
	\Order By vendedor,importe Desc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaventasmarcas(nidm, Ccursor)
	If (This.dff - This.dfi) > 365 Then
		This.cmensaje = 'Hasta 365 Días'
		Return 0
	Endif
	dfi = cfechas(This.dfi)
	dff = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select idmar,marca,v.nomv As vendedor,tcant As cantidad,timporte As importe,Codv
    \From(Select Round(Sum(a.cant*a.Prec),2) As timporte,Sum(a.`cant`*a.`kar_equi`) As tcant,a.`Codv`,b.`idmar`,mm.`dmar` As marca From fe_rcom As e
	\inner Join fe_kar As a On a.Idauto=e.Idauto
	\inner Join fe_art As  b On b.idart=a.idart
    \inner Join fe_mar As mm On mm.`idmar`=b.`idmar`
	\Where e.Acti<>'I' And a.Acti<>'I'  And e.fech  Between '<<dfi>>' And '<<dff>>' And a.alma>0 And Idcliente>0
	If This.nidv > 0 Then
		\ And a.Codv=<<This.nidv>>
	Endif
	If m.nidm > 0 Then
	 \ And b.idmar=<<m.nidm>>
	Endif
	\Group By b.idmar,mm.`dmar`,a.Codv) As yy
	\inner Join fe_vend As v On v.`idven`=yy.Codv
	\Order By vendedor,importe Desc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaventasproducto(Ccursor)
	If (This.dff - This.dfi) > 365 Then
		This.cmensaje = 'Hasta 365 Días'
		Return 0
	Endif
	dfi = cfechas(This.dfi)
	dff = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select producto,v.nomv As vendedor,kar_unid As unidad,tcant As cantidad,timporte As importe
    \From(Select Round(Sum(a.cant*a.Prec),2) As timporte,Sum(a.`cant`) As tcant,a.`Codv`,b.`idcat`,b.`Descri` As producto,kar_unid From fe_rcom As e
	\inner Join fe_kar As a On a.Idauto=e.Idauto
	\inner Join fe_art As  b On b.idart=a.idart
    \Where e.Acti<>'I' And a.Acti<>'I'  And e.fech  Between '<<dfi>>' And '<<dff>>' And a.alma>0
	If This.nidv > 0 Then
		\ And a.Codv=<<This.nidv>>
	Endif
	\Group By b.idart,b.`Descri`,kar_unid,a.Codv) As yy
	\inner Join fe_vend As v On v.`idven`=yy.Codv
	\Order By vendedor,importe Desc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaventasconmetas(nlinea, nmarca, Ccursor)
	If (This.dff - This.dfi) > 365 Then
		This.cmensaje = 'Hasta 365 Días'
		Return 0
	Endif
	dfi = cfechas(This.dfi)
	dff = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select vendedor,importe,cuota,If(cuota>0,Round((importe*100)/cuota,2),0) As por1 From(
	\Select v.nomv As vendedor,timporte As importe,
	\If(vend_cuot>0,If(DATEDIFF('<<dff>>','<<dfi>>')=0,1,DATEDIFF('<<dff>>','<<dfi>>'))*(vend_cuot/30),0) As cuota
    \From(Select Round(Sum(a.cant*a.Prec),2) As timporte,a.`Codv` From fe_rcom As e
	\inner Join fe_kar As a On a.Idauto=e.Idauto
	\inner Join fe_art As  b On b.idart=a.idart
    \Where e.Acti<>'I' And a.Acti<>'I'  And e.fech  Between '<<dfi>>' And '<<dff>>' And a.alma>0
	If This.nidv > 0 Then
		\ And a.Codv=<<This.nidv>>
	Endif
	If m.nlinea > 0 Then
	   \ And b.idcat=<<m.nlinea>>
	Endif
	If m.nmarca > 0 Then
	  \ And b.idmar=<<m.nmarca>>
	Endif
	\Group By a.Codv) As yy
	\inner Join fe_vend As v On v.`idven`=yy.Codv) As aa
	\Order By importe Desc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaventasconmetaspsysl(nlinea, nmarca, Ccursor)
	If (This.dff - This.dfi) > 365 Then
		This.cmensaje = 'Hasta 365 Días'
		Return 0
	Endif
	dfi = cfechas(This.dfi)
	dff = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select vendedor,importe,cuota,If(cuota>0,Round((importe*100)/cuota,2),0) As por1 From(
	\Select v.nomv As vendedor,timporte As importe,
	\If(cuota>0,If(DATEDIFF('<<dff>>','<<dfi>>')=0,1,DATEDIFF('<<dff>>','<<dfi>>'))*(cuota/30),0) As cuota
    \From(Select Round(Sum(a.cant*a.Prec),2) As timporte,a.`Codv` From fe_rcom As e
	\inner Join fe_kar As a On a.Idauto=e.Idauto
	\inner Join fe_art As  b On b.idart=a.idart
    \Where e.Acti<>'I' And a.Acti<>'I'  And e.fech  Between '<<dfi>>' And '<<dff>>' And a.alma>0
	If This.nidv > 0 Then
		\ And a.Codv=<<This.nidv>>
	Endif
	If m.nlinea > 0 Then
	   \ And b.idcat=<<m.nlinea>>
	Endif
	If m.nmarca > 0 Then
	  \ And b.idmar=<<m.nmarca>>
	Endif
	\Group By a.Codv) As yy
	\inner Join fe_vend As v On v.`idven`=yy.Codv) As aa
	\Order By importe Desc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function crearpsystr()
	If This.validar() < 1 Then
		Return 0
	Endif
	goapp.npara1 = This.cnombre
	goapp.npara2 = Datetime()
	goapp.npara3 = goapp.usuario
	goapp.npara4 = This.ncomision
	goapp.npara5 = This.ctipo
	goapp.npara6 = This.nmeta
	If This.conmeta = 'N' Then
		Text To lc Noshow Textmerge
		INSERT INTO fe_vend(nomv,fechvend,usuavend,idpcvend,vend_comi,vend_tipo)values(?goapp.npara1,?goapp.npara2,?goapp.npara3,"",?goapp.npara4,?goapp.npara5)
		Endtext
	Else
		Text To lc Noshow Textmerge
		INSERT INTO fe_vend(nomv,fechvend,usuavend,idpcvend,vend_comi,vend_tipo,vend_cuot)values(?goapp.npara1,?goapp.npara2,?goapp.npara3,"",?goapp.npara4,?goapp.npara5,?goapp.npara6)
		Endtext
	Endif
	If This.ejecutarsql(lc) < 1 Then
		Return 0
	Endif
	This.cmensaje = 'Ok'
	Return 1
	Endfunc
	Function editarpsystr()
	If This.validar() < 1 Then
		Return 0
	Endif
	goapp.npara1 = This.cnombre
	goapp.npara2 = This.ncomision
	goapp.npara3 = This.ctipo
	goapp.npara4 = This.nmeta
	If This.conmeta = 'N' Then
		Text To lc Noshow Textmerge
		UPDATE fe_vend SET nomv=?goapp.npara1,vend_comi=?goapp.npara2,vend_tipo=?goapp.npara3 WHERE idven=<<this.nidv>>
		Endtext
	Else
		Text To lc Noshow Textmerge
		UPDATE fe_vend SET nomv=?goapp.npara1,vend_comi=?goapp.npara2,vend_tipo=?goapp.npara3,vend_cuot=?goapp.npara4 WHERE idven=<<this.nidv>>
		Endtext
	Endif
	If This.ejecutarsql(lc) < 1 Then
		Return 0
	Endif
	This.cmensaje = 'Ok'
	Return 1
	Endfunc
	Function listaventasconmetaspsystr(Ccursor)
	If (This.dff - This.dfi) > 365 Then
		This.cmensaje = 'Hasta 365 Días'
		Return 0
	Endif
	dfi = cfechas(This.dfi)
	dff = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select vendedor,importe,Cast(cuota As Decimal(12,2)) As cuota,If(cuota>0,Round((importe*100)/cuota,2),0) As por1,Round(((importe-costo)/importe *100),2)As por2 From(
	\Select v.nomv As vendedor,timporte As importe,costo,
	\vend_cuot As cuota
    \From(Select Round(Sum(a.cant*a.Prec),2) As timporte,a.`Codv`,Sum(cant*kar_cost) As costo From fe_rcom As e
	\inner Join fe_kar As a On a.Idauto=e.Idauto
    \Where e.Acti<>'I' And a.Acti<>'I'  And e.fech  Between '<<dfi>>' And '<<dff>>' And a.alma>0
	If This.nidv > 0 Then
		\ And a.Codv=<<This.nidv>>
	Endif
	\Group By a.Codv) As yy
	\inner Join fe_vend As v On v.`idven`=yy.Codv) As aa
	\Order By importe Desc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function detallemarcas(nidm, Ccursor)
	If (This.dff - This.dfi) > 365 Then
		This.cmensaje = 'Hasta 365 Días'
		Return 0
	Endif
	dfi = cfechas(This.dfi)
	dff = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select Descri As producto,kar_unid As unidad,Sum(a.`cant`) As cantidad,Round(Sum(a.cant*a.Prec),2) As importe From fe_rcom As e
	\inner Join fe_kar As a On a.Idauto=e.Idauto
	\inner Join fe_art As b On b.idart=a.idart
 	\Where e.Acti<>'I' And a.Acti<>'I'  And e.fech  Between '<<dfi>>' And '<<dff>>' And a.alma>0 And Idcliente>0
	If This.nidv > 0 Then
		\ And a.Codv=<<This.nidv>>
	Endif
	If m.nidm > 0 Then
	 \ And b.idmar=<<m.nidm>>
	Endif
	\Group By a.idart,kar_unid
	\Order By importe Desc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function detallelineas(nidc, Ccursor)
	If (This.dff - This.dfi) > 365 Then
		This.cmensaje = 'Hasta 365 Días'
		Return 0
	Endif
	dfi = cfechas(This.dfi)
	dff = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\Select Descri As producto,kar_unid As  unidad,Sum(a.`cant`) As cantidad,Round(Sum(a.cant*a.Prec),2) As importe From fe_rcom As e
	\inner Join fe_kar As a On a.Idauto=e.Idauto
	\inner Join fe_art As  b On b.idart=a.idart
 	\Where e.Acti<>'I' And a.Acti<>'I'  And e.fech  Between '<<dfi>>' And '<<dff>>' And a.alma>0 And Idcliente>0
	If This.nidv > 0 Then
		\ And a.Codv=<<This.nidv>>
	Endif
	If m.nidc > 0 Then
	 \ And b.idcat=<<m.nidc>>
	Endif
	\Group By a.idart,kar_unid
	\Order By importe Desc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizarCuotapsysl(nvalor)
	Text To lc Noshow Textmerge
        UPDATE fe_vend SET cuota=<<nvalor>> WHERE idven=<<this.nidv>>
	Endtext
	If This.ejecutarsql(lc) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function desactiva(np1)
	Ccursor = 'c_' + Sys(2015)
	Text To lc Noshow
	SELECT codv  FROM fe_kar WHERE codv=?nid AND acti='A'  limit 1
	Endtext
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return  0
	Endif
	Select (Ccursor)
	If Codv > 0 Then
		This.cmensaje = 'Tiene Ventas Activas'
		Return 0
	Endif
	Ccursor = 'o_' + Sys(2015)
	Text To lc Noshow
	SELECT rcre_codv  as codv  FROM fe_rcred WHERE rcre_codv=?nid  AND rcre_Acti='A' limit 1
	Endtext
	If This.EJECutaconsulta(lc, Ccursor) < 1 Then
		Return  0
	Endif
	Select (Ccursor)
	If Codv > 0 Then
		This.cmensaje = 'Tiene Ventas Activas en Los Registros de Cuentas Por Cobrar'
		Return 0
	Endif
	Text To lc Noshow
	UPDATE fe_vend SET vend_acti='I' WHERE idven=?nid
	Endtext
	If This.ejecutarsql(lc) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
























