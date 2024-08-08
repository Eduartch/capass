Local oWSH
oWSH = Createobject("WScript.Shell")
cfile="C:\Psys\FirmaXML\20479597139-01-FF01-0048405.xml"
cexe="C:\Psys\FirmarXml.exe C:\Psys\FirmaXML\20479597139-01-FF01-0048405.xml C:\data0\facturador\CERT\Certificado_Sunat_PFX_NeumaticosChiclayo.pfx NBVCXZASDFG"
cert="C:\data0\facturador\CERT\Certificado_Sunat_PFX_NeumaticosChiclayo.pfx"
cpw="NBVCXZASDFG"
*WAIT WINDOW FULLPATH(cexe)
oWSH.Run(cexe,0,.F.) 
*20479597139-01-FF01-0048405.xml
*RUN /n C:\Psys\FirmarXml.exe "C:\Psys\FirmaXML\20479597139-01-FF01-0048404.xml"  "C:\data0\facturador\CERT\Certificado_Sunat_PFX_NeumaticosChiclayo.pfx"  "NBVCXZASDFG"