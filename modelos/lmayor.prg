Define Class lmayor As OData Of 'd:\capass\database\data.prg'
	dfi = Date()
	dff = Date()
	fi=Date()
	ncodt = 0
	dfp = Date()
	nmes = 0
	Na = 0
	cmultiempresa = ''
	nivel=0
	Function listarresumido(Ccursor)
	dfecha1 = Ctod('01/' + Trim(Str(This.nmes)) + '/' + Trim(Str(This.Na)))
	F = Cfechas(dfecha1)
	dfecha2 = Ctod('01/' + Trim(Str(Iif(This.nmes < 12, This.nmes + 1, 1))) + '/' + Trim(Str(Iif(This.nmes < 12, This.Na, This.Na + 1))))
	dfecha2 = dfecha2 - 1
	dfecha11 = dfecha1 + 1
	fi = Cfechas(dfecha1)
	ff = Cfechas(dfecha2)
	ff2 = Cfechas(dfecha1 - 1)
	dfi = Cfechas(Ctod('01/01/' + Trim(Str(Na))))
	If This.nmes = 1 Then
		Set Textmerge On
		Set Textmerge To  Memvar lC  Noshow
	       \Select z.ldia_fech,z.ncta,z.nomb,If(z.debe>z.haber,z.debe-z.haber,00000000.00) As adeudor,
		   \If(z.haber>z.debe,z.haber-z.debe,000000000.00) As aacreedor,idcta,ldia_nume,estado  From
		   \(Select Max(a.ldia_fech) As ldia_fech,b.ncta,b.nomb,Sum(a.ldia_debe-a.ldia_itrd) As debe,Sum(a.ldia_haber-a.ldia_itrh) As haber,b.idcta,Max(a.ldia_nume) As ldia_nume,'I' As estado
		   \From fe_ldiario As a
		   \inner Join fe_plan As b On b.idcta=a.ldia_idcta
		   \Where a.ldia_acti='A' And ldia_fech = '<<dfi>>' And ldia_tran<>'T'  And ldia_inic='I'
		If This.cmultiempresa = 'S' Then
		   \And ldia_codt=<<This.ncodt>>
		Endif
		   \ Group By a.ldia_idcta) As z
		Set Textmerge To
		Set Textmerge Off
	Else
		Set Textmerge On
		Set Textmerge To  Memvar lC  Noshow
		\Select z.ldia_fech,z.ncta,z.nomb,If(z.debe>z.haber,z.debe-z.haber,00000000.00) As adeudor,
		\If(z.haber>z.debe,z.haber-z.debe,000000000.00) As aacreedor,idcta,ldia_nume,estado  From
		\	(Select Max(a.ldia_fech) As ldia_fech,b.ncta,b.nomb,Sum(a.ldia_debe-a.ldia_itrd) As debe,Sum(a.ldia_haber-a.ldia_itrh) As haber,b.idcta,Max(a.ldia_nume) As ldia_nume,'M' As estado
		\	From fe_ldiario As a inner Join fe_plan As b On b.idcta=a.ldia_idcta
		\	Where a.ldia_acti='A' And ldia_fech Between '<<dfi>>' And '<<ff2>>' And ldia_tran<>'T'
		If This.cmultiempresa = 'S' Then
		   \And ldia_codt=<<This.ncodt>>
		Endif
		   \ Group By a.ldia_idcta) As z
		Set Textmerge To
		Set Textmerge Off
	Endif
	If This.EJECutaconsulta(lC, 'rlda') < 1 Then
		Return 0
	Endif
	Create Cursor (Ccursor)(ldia_fech d, ncta c(15), nomb c(60), adeudor N(12, 2), aacreedor N(12, 2), debe N(12, 2), haber N(12, 2), idcta N(10), ldia_nume c(10), estado c(1))
	Select * From rlda Where (adeudor + aacreedor) > 0 Into Cursor rlda
	Select rld
	Append From Dbf("rlda")
	If nm = 1 Then
		Set Textmerge On
		Set Textmerge To  Memvar lC  Noshow
		\Select z.ldia_fech, z.ncta, z.nomb, z.debe, z.haber, idcta, ldia_nume, estado  From
		\(Select Max(a.ldia_fech) As ldia_fech, b.ncta, b.nomb, Sum(a.ldia_debe - a.ldia_itrd) As debe, Sum(a.ldia_haber - a.ldia_itrh) As haber, b.idcta, Max(a.ldia_nume) As ldia_nume, 'M'  As estado
		\From fe_ldiario As a
		\inner Join fe_plan As b On b.idcta = a.ldia_idcta
		\Where a.ldia_acti = 'A' And ldia_fech Between '<<fi>>' And '<<ff>>' And ldia_tran <> 'T'  And ldia_inic <> 'I'
		If This.cmultiempresa = 'S' Then
		 \And ldia_codt =<< nidt >>
		Endif
		\ Group By a.ldia_idcta) As z
		Set Textmerge To
		Set Textmerge Off
	Else
		Set Textmerge On
		Set Textmerge To  Memvar lC  Noshow
		\Select  z.ldia_fech, z.ncta, z.nomb, z.debe, z.haber, idcta, ldia_nume, estado  From
		\(Select Max(a.ldia_fech) As ldia_fech, b.ncta, b.nomb, Sum(a.ldia_debe - a.ldia_itrd) As debe, Sum(a.ldia_haber - a.ldia_itrh) As haber, b.idcta, Max(a.ldia_nume) As ldia_nume, 'M'  As estado
		\From fe_ldiario As a
		\inner Join fe_plan As b On b.idcta = a.ldia_idcta
		\Where a.ldia_acti = 'A' And ldia_fech Between '<<fi>>' And '<<ff>>' And ldia_tran <> 'T' And ldia_inic <> 'I'
		If This.cmultiempresa = 'S' Then
		 \And ldia_codt =<< nidt >>
		Endif
		\ Group By a.ldia_idcta) As z
		Set Textmerge To
		Set Textmerge Off
	Endif
	If This.EJECutaconsulta(lC, 'rldn') < 1 Then
		Return 0
	Endif
	Select rldn
	Do While !Eof()
		Select rld
		Locate For idcta = rldn.idcta
		If Found()
			Replace debe With rldn.debe, haber With rldn.haber, ldia_nume With rldn.ldia_nume In rld
		Else
			Insert Into rld(ldia_fech, ncta, nomb, debe, haber, idcta, ldia_nume)Values(rldn.ldia_fech, rldn.ncta, rldn.nomb, rldn.debe, rldn.haber, rldn.idcta, rldn.ldia_nume)
		Endif
		Select rldn
		Skip
	Enddo
	Return 1
	Endfunc
	Function mayorizainiciales(Ccursor)
	If !Pemstatus(goapp,'cdatos',5) Then
		AddProperty(goapp,'cdatos','')
	Endif
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	fii=Cfechas(This.fi)
	Set Textmerge On
	Set  Textmerge To Memvar lC Noshow Textmerge
	\Select z.ncta, z.ctasunat, z.nomb, If(z.debe > z.haber, z.debe - z.haber, 0) As adeudor,
	\If(z.haber > z.debe, z.haber - z.debe, 0) As aacreedor, Left(z.ncta, 2) As ctap, idcta  From
	\	(Select b.ncta, ctasunat, b.nomb, Sum(a.ldia_debe - a.ldia_itrd) As debe, Sum(a.ldia_haber - a.ldia_itrh) As haber, ldia_idcta As idcta
	\	From fe_ldiario As a
	\	inner Join fe_plan As b On b.idcta = a.ldia_idcta
	\	Where a.ldia_acti = 'A' And ldia_inic = 'I' And ldia_fech = '<<fii>>' And ldia_tran <> 'T'
	If this.ncodt>0 Then
		\And ldia_codt=<<This.ncodt>>
	Endif
	\Group By a.ldia_idcta,ncta,ctasunat,nomb) As z GROUP BY z.ncta,z.ctasunat, z.nomb,ctap,idcta
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC,Ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mayorizaoperaciones(Ccursor)
	If !Pemstatus(goapp,'cdatos',5) Then
		AddProperty(goapp,'cdatos','')
	Endif
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	dfi=Cfechas(This.dfi)
	dff=Cfechas(This.dff)
	Set Textmerge On
	Set  Textmerge To Memvar lC Noshow Textmerge
	\select z.ncta,z.ctasunat,z.nomb,SUM(z.debe) as debe,SUM(z.haber) as haber,LEFT(z.ncta,2) as ctap,idcta  from
	\(select b.ncta,ctasunat,b.nomb,SUM(a.ldia_debe-a.ldia_itrd) as debe,SUM(a.ldia_haber-a.ldia_itrh) as haber,ldia_idcta as idcta
	\from fe_ldiario as a inner join fe_plan as b on b.idcta=a.ldia_idcta
	\where a.ldia_acti='A' and ldia_fech between '<<dfi>>' and '<<dff>>' and ldia_tran<>'T' and ldia_inic<>'I'
	If this.ncodt>0 Then
		\ And ldia_codt=<<This.ncodt>>
	Endif
	\ group by a.ldia_idcta,ncta,ctasunat,nomb) as z GROUP BY ncta,ctasunat,nomb,ctap,idcta
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC,Ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mayorizainicialesxniveles(Ccursor)
	If !Pemstatus(goapp,'cdatos',5) Then
		AddProperty(goapp,'cdatos','')
	Endif
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	fii=Cfechas(This.fi)
	dfi=Cfechas(This.dfi)
	dff=Cfechas(This.dff)
	Do Case
	Case This.nivel=1
		Set Textmerge On
		Set Textmerge To Memvar lC Noshow Textmerge
		\Select z.ncta,z.ctasunat,z.nomb,If(z.debe>z.haber,z.debe-z.haber,0) As adeudor,
		\If(z.haber>z.debe,z.haber-z.debe,0) As aacreedor,Left(z.ncta,2) As pcta,z.idcta  From
	    \		(Select b.ncta,ctasunat,b.nomb,Sum(a.ldia_debe-a.ldia_itrd) As debe,
		\	Sum(a.ldia_haber-a.ldia_itrh) As haber,ldia_idcta As idcta
		\	From fe_ldiario As a
		\	inner Join fe_plan As b On b.idcta=a.ldia_idcta
	    \   Where a.ldia_acti='A'  And ldia_tran<>'T'
		If This.nmes=1 Then
		    \and ldia_fech='<<fii>>' and ldia_inic='I'
		Else
	        \ and ldia_fech between '<<dfi>>' and '<<dff>>'
		Endif
		If this.ncodt>0  Then
	        \ and ldia_codt=<<this.ncodt>>
		Endif
		\	Group By a.ldia_idcta,ncta,ctasunat,nomb) As z GROUP BY z.ncta,z.ctasunat, z.nomb,idcta
		Set Textmerge Off
		Set Textmerge To
	Case This.nivel=2
		Set Textmerge On
		Set Textmerge To Memvar lC Noshow Textmerge
		\Select z.ncta,z.ctasunat,z.nomb,If(z.debe>z.haber,z.debe-z.haber,0) As adeudor,
		\If(z.haber>z.debe,z.haber-z.debe,0) As aacreedor,pcta,z.idcta,pcta
		\	From (Select ncta,ctasunat,nomb,Sum(debe) As debe,Sum(haber) As haber,Left(ncta,2) As pcta,idcta
		\	From (Select Left(b.ncta,2) As ncta,ctasunat,b.nomb,Sum(a.ldia_debe-a.ldia_itrd) As debe,Sum(a.ldia_haber-a.ldia_itrh) As haber,ldia_idcta As idcta
		\	From fe_ldiario As a inner Join fe_plan As b On b.idcta=a.ldia_idcta
		\	Where a.ldia_acti='A'  And ldia_tran<>'T'
		If This.nmes=1 Then
		    \ and ldia_fech='<<fii>>' and ldia_inic='I'
		Else
	        \ and ldia_fech between '<<dfi>>' and '<<dff>>'
		Endif
		If this.ncodt>0  Then
	        \ and ldia_codt=<<this.ncodt>>
		Endif
		\	Group By a.ldia_idcta,ncta,ctasunat,nomb) As Y Group By ncta,ctasunat,nomb,idcta) As z Group By z.ncta,z.ctasunat, z.nomb,pcta,idcta
		Set Textmerge Off
		Set Textmerge To
	Case This.nivel=3
		Set Textmerge On
		Set Textmerge To Memvar lC Noshow Textmerge
		\      select z.ncta,z.ctasunat,z.nomb,if(z.debe>z.haber,z.debe-z.haber,0) as adeudor,
		\	   if(z.haber>z.debe,z.haber-z.debe,0) as aacreedor,pcta,z.idcta,pcta
		\	   from (select ncta,ctasunat,nomb,SUM(debe) as debe,SUM(haber) as haber,LEFT(ncta,2) as pcta,idcta
		\	   from (select LEFT(b.ncta,4) as ncta,ctasunat,b.nomb,SUM(a.ldia_debe-a.ldia_itrd) as debe,
		\	   SUM(a.ldia_haber-a.ldia_itrh) as haber,ldia_idcta as idcta
		\	   from fe_ldiario as a inner join fe_plan as b on b.idcta=a.ldia_idcta
		\	   where a.ldia_acti='A'  and ldia_tran<>'T'
		If This.nmes=1 Then
		    \ and ldia_fech='<<fii>>' and ldia_inic='I'
		Else
	        \ and ldia_fech between '<<dfi>>' and '<<dff>>'
		Endif
		If this.ncodt>0  Then
	        \ and ldia_codt=<<this.ncodt>>
		Endif
		\ group by a.ldia_idcta,ncta,ctasunat,nomb)as y group by ncta,ctasunat,nomb,idcta) as z group by z.ncta,z.ctasunat, z.nomb,pcta,idcta
		Set Textmerge Off
		Set Textmerge To
	Case This.nivel=4
		Set Textmerge On
		Set Textmerge To Memvar lC Noshow Textmerge
		\Select z.ncta,z.nomb,If(z.debe>z.haber,z.debe-z.haber,0) As adeudor,
		\If(z.haber>z.debe,z.haber-z.debe,0) As aacreedor,pcta,z.idcta,pcta
		\	From (Select ncta,ctasunat,nomb,Sum(debe) As debe,Sum(haber) As haber,Left(ncta,2) As pcta,idcta
		\	From (Select Left(b.ncta,5) As ncta,ctasunat,b.nomb,Sum(a.ldia_debe-a.ldia_itrd) As debe,
		\	Sum(a.ldia_haber-a.ldia_itrh) As haber,ldia_idcta As idcta
		\	From fe_ldiario As a inner Join fe_plan As b On b.idcta=a.ldia_idcta
		\	Where a.ldia_acti='A' And ldia_tran<>'T'
		If This.nmes=1 Then
		    \ and ldia_fech='<<fii>>' and ldia_inic='I'
		Else
	        \ and ldia_fech between '<<dfi>>' and '<<dff>>'
		Endif
		If this.ncodt>0  Then
	        \ and ldia_codt=<<this.ncodt>>
		Endif
		\	Group By a.ldia_idcta,ncta,ctasunat,nomb)As Y Group By ncta,ctasunat,nomb,idcta) As z Group By z.ncta,z.ctasunat, z.nomb,pcta,idcta
		Set Textmerge Off
		Set Textmerge To
	Endcase
	If This.EJECutaconsulta(lC,Ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mayorizaoperacionesxniveles(Ccursor)
	If !Pemstatus(goapp,'cdatos',5) Then
		AddProperty(goapp,'cdatos','')
	Endif
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	dfi=Cfechas(This.dfi)
	dff=Cfechas(This.dff)
	Do Case
	Case This.nivel=1
		Set Textmerge On
		Set Textmerge To Memvar lC Noshow Textmerge
		\Select z.ncta,z.ctasunat,z.nomb,Sum(z.debe) As debe,Sum(z.haber) As haber,z.idcta From
		\(Select b.ncta,ctasunat,b.nomb,Sum(a.ldia_debe-a.ldia_itrd) As debe,Sum(a.ldia_haber-a.ldia_itrh) As haber,ldia_idcta As idcta
		\From fe_ldiario As a inner Join fe_plan As b On b.idcta=a.ldia_idcta
		\Where a.ldia_acti='A' And ldia_fech Between '<<dfi>>'  And  '<<dff>>' And ldia_tran<>'T' And ldia_inic<>'I'
		If this.ncodt>0  Then
	        \ and ldia_codt=<<this.ncodt>>
		Endif
		\Group By a.ldia_idcta,ncta,ctasunat,nomb) As z Group By z.ncta,z.ctasunat, z.nomb,idcta
		Set Textmerge Off
		Set Textmerge To
	Case This.nivel=2
		Set Textmerge On
		Set Textmerge To Memvar lC Noshow Textmerge
		\Select z.ncta,z.ctasunat,z.nomb,Sum(z.debe) As debe,Sum(z.haber) As haber,z.idcta From
		\(Select ncta,nomb,ctasunat,Sum(debe) As debe,Sum(haber) As haber,idcta From
		\(Select Left(b.ncta,2) As ncta,ctasunat,b.nomb,Sum(a.ldia_debe-a.ldia_itrd) As debe,Sum(a.ldia_haber-a.ldia_itrh) As haber,
		\ldia_idcta As idcta From fe_ldiario As a inner Join fe_plan As b On b.idcta=a.ldia_idcta
		\Where a.ldia_acti='A' And ldia_fech Between '<<dfi>>'  And  '<<dff>>' And ldia_tran<>'T' And ldia_inic<>'I' 
		If this.ncodt>0  Then
	        \ and ldia_codt=<<this.ncodt>>
		ENDIF
		\Group By a.ldia_idcta,ncta,ctasunat,nomb) As Y Group By ncta,ctasunat,nomb,idcta)
		\As z Group By z.ncta,z.ctasunat, z.nomb,idcta
		Set Textmerge Off
		Set Textmerge To
	Case This.nivel=3
		Set Textmerge On
		Set Textmerge To Memvar lC Noshow Textmerge
		\Select z.ncta,z.ctasunat,z.nomb,Sum(z.debe) As debe,Sum(z.haber) As haber,z.idcta From
		\(Select ncta,nomb,ctasunat,Sum(debe) As debe,Sum(haber) As haber,idcta From
		\(Select Left(b.ncta,4) As ncta,ctasunat,b.nomb,Sum(a.ldia_debe-a.ldia_itrd) As debe,Sum(a.ldia_haber-a.ldia_itrh) As haber,
		\ldia_idcta As idcta From fe_ldiario As a inner Join fe_plan As b On b.idcta=a.ldia_idcta
		\Where a.ldia_acti='A' And ldia_fech Between '<<dfi>>'  And  '<<dff>>' And ldia_tran<>'T' And ldia_inic<>'I'
		If this.ncodt>0  Then
	        \ and ldia_codt=<<this.ncodt>>
		ENDIF
		\ Group By a.ldia_idcta,ncta,ctasunat,nomb) As Y Group By ncta,ctasunat,nomb,idcta)
		\As z Group By z.ncta,z.ctasunat, z.nomb,idcta
		Set Textmerge Off
		Set Textmerge To
	Case This.nivel=4
		Set Textmerge On
		Set Textmerge To Memvar lC Noshow Textmerge
		\Select z.ncta,z.ctasunat,z.nomb,Sum(z.debe) As debe,Sum(z.haber) As haber,z.idcta  From
		\(Select ncta,nomb,ctasunat,Sum(debe) As debe,Sum(haber) As haber,idcta From
		\(Select Left(b.ncta,5) As ncta,ctasunat,b.nomb,Sum(a.ldia_debe-a.ldia_itrd) As debe,
		\Sum(a.ldia_haber-a.ldia_itrh) As haber,ldia_idcta As idcta
		\From fe_ldiario As a inner Join fe_plan As b On b.idcta=a.ldia_idcta
		\Where a.ldia_acti='A' And ldia_fech Between '<<dfi>>'  And  '<<dff>>'  And ldia_tran<>'T' And ldia_inic<>'I' 
		If this.ncodt>0  Then
	        \ and ldia_codt=<<this.ncodt>>
		ENDIF
		\Group By a.ldia_idcta,ncta,ctasunat,nomb) As Y Group By ncta,ctasunat,nomb,idcta)
		\As z Group By z.ncta,z.ctasunat,z.nomb,idcta
		Set Textmerge Off
		Set Textmerge To
	Endcase
	If This.EJECutaconsulta(lC,Ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine





