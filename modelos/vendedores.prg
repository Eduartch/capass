Define Class vendedores As Odata Of 'd:\capass\database\data.prg'
	nidv = 0
	dfi = Date()
	dff = Date()
	Function MuestraVendedores(np1, Ccursor)
	Local lC, lp
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	If Alltrim(goApp.datosvend) <> 'S' Then
		If This.consultardata(np1, Ccursor) < 1 Then
			Return 0
		Endif
	Else
		Create Cursor b_vend From Array cfieldsfevend
		cfilejson = Addbs(Sys(5) + Sys(2003)) +  'v' + Alltrim(Str(goApp.Xopcion)) + '.json'
		If File(m.cfilejson) Then
			responseType1 = Addbs(Sys(5) + Sys(2003)) +  'v' + Alltrim(Str(goApp.Xopcion)) + '.json'
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
	Set Textmerge To Memvar lC Noshow Textmerge
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
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaventaspsysl(nmarca, Ccursor)
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	 \ Select a.kar_comi*((a.cant*a.Prec)/e.vigv) As comi,a.Idauto,e.Tdoc,e.Ndoc,e.fech,a.cant,a.Prec,
     \ Round(a.cant*a.Prec,2) As timporte,ifnull(b.idmar,Cast(0 As unsigned)) As idmar,e.Mone,a.alma,c.nomv As nomb,e.Form,
     \ e.vigv As igv,Cast(a.Codv As unsigned) As Codv,e.dolar As dola,d.Razo,'v' As Tipo,e.Idcliente,e.Impo From
     \ fe_clie As d
     \ inner Join fe_rcom As e On e.Idcliente=d.idclie
     \ Left Join fe_kar As a On a.Idauto=e.Idauto
     \ Left Join fe_art As  b On b.idart=a.idart
     \ Left Join fe_vend As c On c.idven=a.Codv
     \ Where e.Acti<>'I' And a.Acti<>'I'  And e.fech  Between '<<f1>>' And '<<f2>>' And Form='E' And Impo<>0 And e.Tdoc Not In("07","08")
	If This.nidv > 0 Then
     \ And a.Codv=<<This.nidv>>
	Endif
	If nmarca > 0 Then
	 \ And b.idmar=<<nmarca>>
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
	 \ Left Join fe_art As  b On b.idart=a.idart
	 \ Left Join fe_vend As c On c.idven=a.Codv
	 \ Where w.fech  Between '<<f1>>' And '<<f2>>' And w.Acti='A' And w.acta>0 And e.Acti='A' And a.Acti='A' And Left(w.Ndoc,2)<>'FN' And Round(e.Impo, 2) = Round(w.acta, 2)
	If This.nidv > 0 Then
     \ And a.Codv=<<This.nidv>>
	Endif
	If nmarca > 0 Then
	 \ And b.idmar=<<nmarca>>
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
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
	\  inner Join fe_art As  b On b.idart=a.idart
	\  inner Join fe_vend As c On c.idven=r.rcre_codv
	\  Where w.fech  Between '<<f1>>' And '<<f2>>'  And w.Acti='A' And w.acta>0 And e.Acti='A' And Left(w.Ndoc,2)<>'FN' And Round(e.Impo,2)>Round(w.acta,2)
	If This.nidv > 0 Then
     \ And a.Codv=<<This.nidv>>
	Endif
	If nmarca > 0 Then
	 \ And b.idmar=<<nmarca>>
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lc1, 'com') < 1 Then
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
	Text To lC Noshow
     select vend_corr from fe_vend where vend_acti='A' and length(trim(vend_corr))>0
	Endtext
	If  This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultardata(np1, Ccursor)
	m.lC		 = 'PROMUESTRAVENDEDORES'
	goApp.npara1 = m.np1
	Text To m.lp Noshow Textmerge
       (?goapp.npara1)
	Endtext
	If This.EJECUTARP(m.lC, m.lp, m.Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	nCount = Afields(cfieldsfevend)
	Select * From (Ccursor) Into Cursor a_vend
	cdata = nfcursortojson(.T.)
	cfilejson = Addbs(Sys(5) + Sys(2003)) + 'v' + Alltrim(Str(goApp.Xopcion)) + '.json'
	If File(cfilejson) Then
		Delete File (cfilejson)
	Endif
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'v' + Alltrim(Str(goApp.Xopcion)) + '.json'
	Strtofile (cdata, rutajson)
	goApp.datosvend = 'S'
	Return 1
	Endfunc
Enddefine






















