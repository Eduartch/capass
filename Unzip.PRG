cMiZip 	  = 'C:\Psys\SunatXML\20479597139-01-F001-0048434.zip'
cDirDesti = 'C:\Psys\SunatXML\'

oShell = Createobject("Shell.Application")
For Each oArchi In oShell.NameSpace(cMiZip).Items
	WAIT WINDOW justfname(oArchi.Name)
	If Left(oArchi.Name,1)='R' Then
		oShell.NameSpace(cDirDesti).CopyHere(oArchi)
	Endif
Endfor
