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
	Set Textmerge On
	Set Textmerge To Memvar lp Noshow Textmerge
        \('<<this.cta>>',<<This.idb1>>,'<<this.cmone>>','<<this.cdeta>>',<<This.nidctap>>
	If goApp.Cdatos = 'S' Then
           \,<<This.ncodt>>)
	Else
           \)
	Endif
	Set Textmerge Off
	Set Textmerge To
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1  Then
		Return 0
	Endif
	Return nid
	Endfunc
Enddefine