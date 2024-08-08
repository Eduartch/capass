Do "FoxyPreviewer.App"
cArchivo = Addbs(Sys(5)+Sys(2003))+'Test.pdf'

Report Form Locfile(_Samples + "\Solution\Reports\Colors.frx") ;
	OBJECT Type 10 Nopageeject Noreset To File (cArchivo)

Report Form Locfile(_Samples + "\Solution\Reports\Wrapping.frx") ;
	OBJECT Type 10 Nopageeject

Report Form Locfile(_Samples + "\Solution\Reports\Percent.frx") ;
	OBJECT Type 10 &&  preview
