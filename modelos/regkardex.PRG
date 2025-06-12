Define Class regkardex As OData Of  'd:\capass\database\data.prg'
	niDAUTO = 0
	ncoda = 0
	ncant = 0
	nprec = 0
	ncomi = 0
	nidtda = 0
	nidtda1=0
	nidv = 0
	Ctipo = ""
	ncosto = 0
	nidcosto = 0
	nidicpber = 0
	ndetraccion = 0
	ctmvto = ""
	cdetalle=""
	cTdoc = ""
	cincl = ""
	ntigv = 0
	nidkar = 0
	nopcion = 0
	nirta = 0
	dfi = Date()
	dff = Date()
	cfechaanulacion = ''
	Function registrakardexcompras()
	lC = "FunIngresaKardexcompras"
	Text To lp Noshow Textmerge
	 (<<this.nidauto>>,<<this.ncoda>>,'<<this.ctipo>>',<<this.nprec>>,<<this.ncant>>,'<<this.cincl>>','<<this.ctmvto>>',<<this.ntigv>>,<<this.nidtda>>,<<this.ncosto>>,<<this.nirta>>)
	Endtext
	m.nid = This.EJECUTARf(lC, lp, 'kk')
	If m.nid < 1 Then
		Return 0
	Endif
	Return m.nid
	Endfunc
	Function registrakardex5()
	lC = "proregistraKardex"
	Text To lp Noshow Textmerge
	 (<<this.nidauto>>,<<this.ncoda>>,'<<this.ctipo>>',<<this.nprec>>,<<this.ncant>>,'<<this.cincl>>','<<this.ctmvto>>',<<this.nidv>>,<<this.nidtda>>,<<this.ncosto>>,<<this.ncomi>>,<<this.ntigv>>)
	Endtext
	If This.ejecutarp(lC, lp, '') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registrakardexventas()
	lC = "proregistraKardexventas"
	Text To lp Noshow Textmerge
    (<<this.nidauto>>,<<this.ncoda>>,'<<this.ctipo>>',<<this.nprec>>,<<this.ncant>>,'<<this.cincl>>','<<this.ctmvto>>',<<this.nidv>>,<<this.nidtda>>,<<this.ncosto>>,<<this.ncomi>>,'<<this.ctdoc>>')
	Endtext
	If This.ejecutarp(lC, lp, '') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarlogskardex(Ccursor)
	F1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \ Select a.lres_fech As fechahora,b.nomb As Usuario,c.ndoc,d.nomb As Autorizo,
    \ e.razo As referencia,c.fech,c.Impo,p.Descri As producto,p.unid,k.cant As cantidad,k.Prec As precio,
    \If(lres_tipo='A','Actualización','Eliminación') As estadoa,lres_idau From fe_aresumen As a
    \ inner Join fe_usua As b On b.idusua=a.lres_idus
    \ inner Join fe_rcom As c On c.idauto=a.lres_idau
    \ inner Join fe_kar As k On k.idauto=a.lres_idau
    \ inner Join fe_art As p On p.idart=k.idart
    \ Left Join fe_usua As d On d.idusua=c.rcom_idus
	If This.Ctipo = 'C' Then
	   \ inner Join fe_prov As e On e.idprov = c.idprov
	Else
	 \  inner Join fe_clie As e On e.idclie=c.idcliente
	Endif
	\Where
	If This.cfechaanulacion = 'S' Then
	     \ a.lres_fech Between '<<f1>>' And '<<f2>>'
	Else
	     \  c.fech    Between '<<f1>>' And '<<f2>>'
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizaKardexcompras5()
	lC = "ProActualizaKardex5"
	Text To lp Noshow Textmerge
	 (<<this.nidauto>>,<<this.ncoda>>,'<<this.ctipo>>',<<this.nprec>>,<<this.ncant>>,'<<this.cincl>>','<<this.ctmvto>>',<<this.nidv>>,<<this.nidtda>>,<<this.ncosto>>,<<this.nidkar>>,<<this.nopcion>>,<<this.nirta>>,<<this.ntigv>>)
	Endtext
	If This.ejecutarp(lC, lp, '') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function INGRESAKARDEX1()
	lC = "FUNINGRESAkardex1"
	Text To lp Noshow Textmerge
	 (<<this.nidauto>>,<<this.ncoda>>,'<<this.ctipo>>',<<this.nprec>>,<<this.ncant>>,'<<this.cincl>>','<<this.ctmvto>>',<<this.nidv>>,<<this.nidtda>>,<<this.ncosto>>,<<this.ncomi>>)
	Endtext
	m.nid = This.EJECUTARf(lC, lp, 'kk')
	If m.nid < 1 Then
		Return 0
	Endif
	Return m.nid
	Endfunc
	Function ingresakardexdetraccion()
	Local lC, lp
	cur			  = "nidk"
	lC			  = "FunIngresaKardexdetraccion"
	Text To lp Noshow Textmerge
     (<<this.niDAUTO>>,<<this.ncoda>>,<<this.nidicpber>>,<<this.nprec>>,<<this.ncant>>,'<<this.cincl>>','<<this.ctmvto>>',<<this.nidv>>,<<this.nidtda>>,<<this.ncosto>>,<<this.ncomi>>,<<this.ndetraccion>>)
	Endtext
	nidk = This.EJECUTARf(lC, lp, cur)
	If nidk < 1 Then
		Return 0
	Endif
	Return nidk
	Endfunc
	Function Actualizakardexdetraccion()
	Local lC, lp
	cur			  = ""
	lC			  = "ProActualizaKardexdetraccion"
	Text To lp Noshow Textmerge
     (<<this.niDAUTO>>,<<this.ncoda>>,<<this.nidicpber>>,<<this.nprec>>,<<this.ncant>>,'<<this.cincl>>','<<this.ctmvto>>',<<this.nidv>>,<<this.nidtda>>,<<this.ncosto>>,<<this.nidkar>>,1,<<this.ncomi>>,<<this.ndetraccion>>)
	Endtext
	If This.ejecutarp(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaDtraspasos()
	lC = 'FunIngresaKardex'
	cur = "Xt"
	*Na, ed.Coda, m.Ctipo, ed.Prec, ed.cant, 'I', 0, 'T', 'Devolución', nidtda, nidtda1, 0
	*np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12
	goApp.npara1 = this.niDAUTO
	goApp.npara2 = this.ncoda
	goApp.npara3 = this.Ctipo
	goApp.npara4 = this.nprec
	goApp.npara5 = this.ncant
	goApp.npara6 = this.cincl
	goApp.npara7 = 0
	goApp.npara8 = this.ctmvto
	goApp.npara9 = this.cdetalle
	goApp.npara10 = this.nidtda
	goApp.npara11 = this.nidtda1
	goApp.npara12 = 0
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12)
	Endtext
	nidk = This.EJECUTARf(lC, lp, cur)
	If m.nidk < 1 Then
		Return 0
	Endif
	Return m.nidk
	Endfunc
Enddefine





