Define Class appsysven As Odata Of 'd:\capass\database\data.prg'
	Function dATOSGLOBALES(Ccursor)
	Text To lC Noshow
      SELECT * FROM fe_gene WHERE idgene=1 limit 1
	Endtext
	If This.EjecutaConsulta( lC, (Ccursor) ) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultardata()
	If  This.dATOSGLOBALES("fe_gene") < 1 Then
		Return 0
	Endif
	Public cfieldsfegene(1)
	nCount = Afields(cfieldsfegene)
	Select fe_gene
	Select * From fe_gene Into Cursor confsetup
	cdata = nfcursortojson(.T.)
	goApp.rucempresa = fe_gene.nruc
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'config' + Alltrim(Str(goApp.Xopcion)) + '.json'
	If File(m.rutajson)
		Delete File m.rutajson
	Endif
	Strtofile (cdata, rutajson)
	goApp.datosg = 'S'
	Return 1
	Endfunc
Enddefine