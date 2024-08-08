*!*	FUNCTION FechaFestiva(tnOrdinal,tnDiaSem,tnMes,tnAnio)
*!*	  RETURN DATE(tnAnio,tnMes,1)+tnOrdinal*7- ;
*!*	  DOW(DATE(tnAnio,tnMes,1)+tnOrdinal*7-1,tnDiaSem)
*!*	ENDFUNC
Clear
Set Date To French
Set Century On
ofechas=Createobject("custom")
fi=Ctod('01/05/2022')
ff=Ctod('31/05/2022')
cmes=Alltrim(Str(Month(fi)))
caño=Alltrim(Str(Year(fi)))
p=1
cprop='f'+Alltrim(Str(p))
AddProperty(ofechas,(cprop),fi)
*?fi
ndias=31
x=1
For x=1 To ndias
	p=p+1
	cprop='f'+Alltrim(Str(p))
	If x=1 Then
		ds=Dow(fi)
		fdf=8-ds
		f1=fi+fdf
*?f1
		AddProperty(ofechas,(cprop),f1)
		x=ds+1
		fa=Ctod(Alltrim(Str(Day(f1)+1))+'/'+cmes+'/'+caño)
	Else
		f1=fa
		If fa+6>ff Then
			f2=ff
			x=ndias
		Else
			f2=fa+6
			x=x+6
		Endif
		AddProperty(ofechas,(cprop),f1)
		p=p+1
		cprop='f'+Alltrim(Str(p))
**	?cprop
		AddProperty(ofechas,(cprop),f2)
*	?f1
*	?f2
		If f2+1=ff Then
*	?f2+1
*	?f2+1
			p=p+1
			cprop='f'+Alltrim(Str(p))
*	?cprop
			AddProperty(ofechas,(cprop),f2+1)
			p=p+1
			cprop='f'+Alltrim(Str(p))
*	?cprop
			AddProperty(ofechas,(cprop),f2+1)
			Exit
		Endif
		fa=Ctod(Alltrim(Str(Day(f2)+1))+'/'+cmes+'/'+caño)
	Endif
Next

AddProperty(ofechas,'nro',p)
If ofechas.nro<12 Then
	?ofechas.f1
	?ofechas.f2
	?ofechas.f3
	?ofechas.f4
	?ofechas.f5
	?ofechas.f6
	?ofechas.f7
	?ofechas.f8
	?ofechas.f9
	?ofechas.f10
Else
	?ofechas.f1
	?ofechas.f2
	?ofechas.f3
	?ofechas.f4
	?ofechas.f5
	?ofechas.f6
	?ofechas.f7
	?ofechas.f8
	?ofechas.f9
	?ofechas.f10
	?ofechas.f11
	?ofechas.f12
Endif


