Define Class Correlativo As OData Of 'd:\capass\database\data.prg'
	Ndoc = ""
	Nsgte = 0
	Idserie = 0
	nserie = 0
	cTdoc = ""
	Items = 0
	numero = 0
	conletras = ""
	letras = ""
	ncodt = 0
	Function Listar(Ccursor)
	Text To lC Noshow Textmerge
     select serie,t.nomb,nume,ifnull(a.nomb,'') as tienda,items,'' as letra,s.tdoc,seri_idal,idserie
     FROM fe_serie s
     INNER JOIN fe_tdoc t ON t.tdoc=s.tdoc
     left join fe_sucu a on a.sucuidserie=s.serie
     ORDER BY serie
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Listarx(Ccursor)
	Text To lC Noshow Textmerge
     select serie,t.nomb,serie,nume,ifnull(a.nomb,'') as nomb,items,letra,s.tdoc,seri_idal,idserie
     FROM fe_serie s
     INNER JOIN fe_tdoc t ON t.tdoc=s.tdoc
     left join fe_sucu a on a.sucuidserie=s.serie
     ORDER BY serie
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ValidarSerie(Cserie, nidtda, cTdoc)
	Local lC, Vdvto
	Vdvto = 1
	For x = 1 To Len(Cserie)
		cvalor = Substr(Cserie, x, 1)
		If Asc(cvalor) <= 47 Or (Asc(cvalor) >= 58 And Asc(cvalor) <= 64) Or (Asc(cvalor) >= 91 And Asc(cvalor) <= 96) Or  Asc(cvalor) >= 122  Then
			Vdvto = 0
			Exit
		Endif
	Next
	If Vdvto = 0 Then
		This.Cmensaje = 'Formato de Serie no Válido'
		Return 0
	Endif
	Ccursor = Sys(2015)
	This.nserie = Cserie
	lista = This.ObtenerSerie(Cserie)
	If This.conletras = 'S' Then
		Text To m.lC Noshow Textmerge
		Select  serie From fe_serie Where serie=<<lista.nserie>> And codt=<<m.nidtda>> And tdoc ='<<ctdoc>>' AND TRIM(letra)='<<lista.cletras>>'  limit 1
		Endtext
	Else
		Text To m.lC Noshow Textmerge
		Select  serie From fe_serie Where serie=<<lista.nserie>> And codt=<<m.nidtda>> And tdoc ='<<ctdoc>>' limit 1
		Endtext
	Endif
	If This.EJECutaconsulta(m.lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	numserie = Iif(Vartype(Serie) = 'C', Val(Serie), Serie)
	If numserie > 0 Then
		Return 1
	Else
		This.Cmensaje = 'La Serie ' + Alltrim(Str(lista.nserie)) + 'NO Pertenece a esta Punto de Venta ' + Alltrim(Str(m.nidtda))
		Return 0
	Endif
	Endfunc
	Function GeneraCorrelativo()
	If Len(Alltrim(This.Ndoc)) <= 8 Then
		nnumero = Val(This.Ndoc)
	Else
		nnumero = Val(Substr(This.Ndoc, 5))
	Endif
	If nnumero >= This.Nsgte Then
		lC = "ProGeneraCorrelativo"
		goApp.npara1 = This.Nsgte + 1
		goApp.npara2 = This.Idserie
		cur = ""
		Text To lp Noshow
        (?goapp.npara1,?goapp.npara2)
		Endtext
		If This.EJECUTARP(lC, lp, cur) < 1 Then
			Return 0
		Endif
		Return 1
	Else
		Return 1
	Endif
	Endfunc
	Function sgte()
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	lista = This.ObtenerSerie(Alltrim(Str(This.nserie)))
	Ccursor = 'c_' + Sys(2015)
	SET TEXTMERGE ON 
	SET TEXTMERGE TO memvar lc NOSHOW TEXTMERGE 
	\SELECT nume,items,idserie FROM fe_serie WHERE serie=<<lista.nserie>> AND tdoc='<<this.ctdoc>>'
	If This.conletras = 'S' Then
	  \AND TRIM(letra)='<<lista.cletras>>'
	ENDIF 
	\limit  1 
	SET TEXTMERGE off
	SET TEXTMERGE TO  
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		This.Ndoc = ""
		Return 0
	Endif
	Select (Ccursor)
	If nume < 1 Then
		This.Ndoc = ""
		This.Cmensaje = 'No hay Serie Registrada'
		Return 0
	Endif
	This.Ndoc = Alltrim(Str(nume))
	This.Idserie = Idserie
	This.Nsgte = nume
	This.Items = Items
	This.numero = nume
	Return 1
	Endfunc
	Function validarguia(cndoc)
	oRegExp = Create("VBScript.RegExp")
	oRegExp.IgnoreCase = .F.
	oRegExp.Global = .F.
	oRegExp.Pattern = "^[A-Z]{1,1}[0-9]{3,3}\-[0-9]{1,8}$"
	oMatchs = oRegExp.Execute(cndoc)
	If oMatchs.Count < 1 Then
		This.Cmensaje = "El Formato de Guia No es el correcto. Debe de ser T001-1 por ejemplo"
		Return 0
	Endif
	npos = At("-", cndoc)
	If Val(Substr(cndoc, 6)) < 1 Then
		This.Cmensaje = "El Correlativo debe ser Númerico"
		Return 0
	Endif
	Return 1
	Endfunc
	Function BuscarSeries(ns, cTdoc, Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	If This.conletras = 'S' Then
		Text To lC Noshow Textmerge
          SELECT nume,items,idserie FROM fe_serie WHERE serie=<<ns>> AND tdoc='<<ctdoc>>' AND TRIM(letra)='<<this.letras>>' limit 1
		Endtext
	Else
		Text To lC Noshow Textmerge
         SELECT nume,items,idserie FROM fe_serie WHERE serie=<<ns>> AND tdoc='<<ctdoc>>' limit 1
		Endtext
	Endif
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	Do Case
	Case Idserie > 0
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
				goApp.reporte = cArchivo
				If !File(cArchivo)
				Endif
			Catch To oerror
				This.Cmensaje = "No es Posible Imprimir este Comprobante"
			Finally
			Endtry
		Else
			Return 1
		Endif
		Return 1
	Case Idserie <= 0
		This.Cmensaje = "Serie NO Registrada"
		Return 0
	Endcase
	Return 1
	Endfunc
	Function ObtenerSerie(Cserie)
	nser = 0
	Clet = ""
	For x = 1 To Len(Alltrim(Cserie))
		cvalor = Substr(Cserie, x, 1)
		If Isdigit(cvalor) Then
			nser = Val(Substr(Cserie, x))
			Exit
		Endif
		If Isalpha(cvalor) Then
			Clet = Clet + Substr(Cserie, x, 1)
		Endif
	Next
	If nser = 0 Then
		This.Cmensaje = 'Formato de Serie no Válido'
		Obj = Createobject("empty")
		AddProperty(Obj, 'estado', 0)
		AddProperty(Obj, 'nserie', 0)
		AddProperty(Obj, "cletras", "")
		Return Obj
	Endif
	Obj = Createobject("empty")
	AddProperty(Obj, "estado", '1')
	AddProperty(Obj, "nserie", nser)
	AddProperty(Obj, "cletras", Alltrim(Clet))
	Return Obj
	Endfunc
	Function Dserie()
	If Vartype(This.nserie) <> 'N' Then
		If Val(This.nserie) = 0 Then
			Cserie = ''
			For i = 1 To Len(Alltrim(This.nserie))
				If Isdigit(Substr(This.nserie, i, 1)) Then
					Cserie = Cserie + Substr(This.nserie, i, 1)
				Endif
			Next
			nroserie = Val(Cserie)
		Else
			nroserie = Val(This.nserie)
		Endif
	Else
		nroserie = This.nserie
	Endif
	Return nroserie
	Endfunc
	Function correlativosirecompras()
	Text To lC Textmerge Noshow
	 UPDATE fe_gene SET gene_corc=gene_corc+1 WHERE idgene=1
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Ccursor = 'c' + Sys(2015)
	Text To lg Textmerge Noshow
	  select gene_corc FROM fe_gene WHERE idgene=1;
	Endtext
	If This.EJECutaconsulta(lg, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	Return gene_corc
	Endfunc
	Function GeneraCorrelativo1()
	lC = "ProGeneraCorrelativo"
	goApp.npara1 = This.Nsgte + 1
	goApp.npara2 = This.Idserie
	Text To lp Noshow
        (?goapp.npara1,?goapp.npara2)
	Endtext
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	This.Nsgte = This.Nsgte + 1
	Return 1
	Endfunc
	Function sgteguia()
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Ccursor = 'c_' + Sys(2015)
	Text To lC Noshow Textmerge
	    SELECT nume,items,idserie FROM fe_serie WHERE serie=<<this.nserie>> AND tdoc='<<this.ctdoc>>' limit  1;
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		This.Ndoc = ""
		Return 0
	Endif
	Select (Ccursor)
	If nume < 1 Then
		This.Ndoc = ""
		This.Cmensaje = 'No hay Serie Registrada'
		Return 0
	Endif
	This.Ndoc = Alltrim(Str(nume))
	This.Idserie = Idserie
	This.Nsgte = nume
	This.Items = Items
	This.numero = nume
	Return 1
	Endfunc
	Function MostrarSeries(Ccursor)
	lC = "PROMUESTRASERIES"
	If This.EJECUTARP(lC, "", Ccursor) < 1  Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Buscarsiestaregistrado(Cserie, cTdoc)
	Text To lsql Noshow Textmerge
       select serie FROM fe_serie WHERE serie='<<cserie>>' AND tdoc='<<ctdoc>>'
	Endtext
	Ccursor = 'c_' + Sys(2015)
	If This.EJECutaconsulta(lsql, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If Serie = m.Cserie
		This.Cmensaje = "Serie Ya Registrada"
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizarSeriesDctos()
	lC = "ProActulizaSeriesDctos"
	Text To lp Noshow Textmerge
        (<<this.nserie>>,<<this.numero>>,'<<this.ctdoc>>',<<this.Items>>,<<this.ncodt>>,<<this.Idserie>>)
	Endtext
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function RegistraSeriesDctos()
	lC = "FunCreaSeriesDctos"
	Text To lp Noshow Textmerge
        (<<this.nserie>>,<<this.numero>>,'<<this.ctdoc>>',<<this.Items>>,<<this.ncodt>>)
	Endtext
	Vdvto = This.EJECUTARf(lC, lp, "ids")
	If m.Vdvto < 1 Then
		Return 0
	Endif
	Return m.Vdvto
	Endfunc
	Function AnterioresdesdeCaja(Df, Ccursor)
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	dFecha = Cfechas(Df)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select  Max(a.Ndoc) As Ndoc,a.tdoc From fe_lcaja As b
	\INNER Join fe_rcom As a  On(a.idauto=b.lcaj_idau)
	\Where a.Acti<>'I' And b.lcaj_fech<'<<dfecha>>' And b.lcaj_acti='A' And idcliente>0
	If goApp.Cdatos = 'S' Then
	  \ And a.codt=<<goApp.tienda>>
	Endif
	\ Group By a.tdoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1  Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function BuscarSeries1(ns, cTdoc, Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	lC = "PROBUSCASERIES"
	Text To lp Noshow Textmerge
        (<<ns>>,'<<ctdoc>>')
	Endtext
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function GeneraCorrelativootraserie(nn, ns)
	Text To lp Noshow Textmerge
       UPDATE fe_serie  as f SET numebnotas=f.numebnotas+1 WHERE idserie=<<ns>>
	Endtext
	If This.Ejecutarsql(lp) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine






































































