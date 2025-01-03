Define Class ctasbancos As OData Of  'd:\capass\database\data.prg'
	cta = ""
	idb1 = 0
	cmone = ""
	cdeta = ""
	nidctap = 0
	ncodt = 0
	Function CreaCtasBancos()
	cur = "Creacta"
	lC = 'FUNCREACTASBANCOS'
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If goApp.Cdatos = 'S' Then
		Text To lp Noshow Textmerge
        ('<<this.cta>>',<<this.idb1>>,<<this.cmone>>',<<this.cdeta>>',<<this.nidctap>>,<<this.ncodt>>)
		Endtext
	Else
		Text To lp Noshow Textmerge
        ('<<this.cta>>',<<this.idb1>>,<<this.cmone>>',<<this.cdeta>>',<<this.nidctap>>)
		Endtext
	Endif
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1  Then
		Return 0
	Endif
	Return nid
	Endfunc
Enddefine