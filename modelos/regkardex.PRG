Define Class regkardex As OData Of  'd:\capass\database\data.prg'
	niDAUTO = 0
	ncoda = 0
	ncant = 0
	nprec = 0
	ncomi = 0
	nidtda = 0
	nidv = 0
	Ctipo = ""
	ncosto = 0
	nidcosto = 0
	ctmvto = ""
	cTdoc = ""
	cincl = ""
	ntigv = 0
	dfi = Date()
	dff = Date()
	cfechaanulacion = ''
	Function registrakardex5()
	lC = "proregistraKardex"
	TEXT TO lp NOSHOW TEXTMERGE 
	 (<<this.nidauto>>,<<this.ncoda>>,'<<this.ctipo>>',<<this.nprec>>,<<this.ncant>>,'<<this.cincl>>','<<this.ctmvto>>',<<this.nidv>>,<<this.nidtda>>,<<this.ncosto>>,<<this.ncomi>>,<<this.ntigv>>)
	ENDTEXT 
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
    \ e.razo As referencia,c.fech,c.Impo,p.Descri As producto,p.unid,k.cant As cantidad,k.Prec As precio,a.lres_idau From fe_aresumen As a
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
	     \ Where c.fech    Between '<<f1>>' And '<<f2>>'
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine

