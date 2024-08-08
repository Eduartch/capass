************************************
* DESCOMPRIMIR
************************************
cMiZip = "C:MiArchivo.Zip"
cDirDesti = "c:Directorio"
oShell = Createobject("Shell.Application")
For Each oArchi In oShell.NameSpace(cMiZip).Items
oShell.NameSpace(cDirDesti).CopyHere(oArchi)
EndFor