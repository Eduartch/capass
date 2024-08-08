Local lcCampo 	   As String	;
	, lcCols 	   As String	;
	, lcCreaCursor As String  	;
	, lcSelVtaMes  As String	;
	, lnMes 	   As Number	;
	, lnMesFin 	   As Number	;
	, lnMesIni 	   As Number

lnMesIni = 1996 * 12 + 07
lnMesFin = 1998 * 12 + 05

Set Procedure To TotComprasXCliente Additive

Open Database (_Samples + "Northwind\Northwind")

Text To m.lcSelVtaMes Textmerge Noshow Flags 1 Pretext 15

Select  txc.CustomerId
	  , txc.CompanyName
	  , txc.Importe
	  , Mes
From (
	  Select  ord.CustomerId
			, cli.CompanyName
			, Year(ord.OrderDate) * 12 + Month(ord.OrderDate)
	   											As Mes
			, Sum(det.UnitPrice * det.Quantity) As Importe
	  From OrderDetails   As det
	  Left Join Orders    As ord
		  On det.OrderId = ord.OrderId
	  Left Join Customers As cli
		  On ord.CustomerId = cli.CustomerId
	  Group By ord.CustomerId
			 , CompanyName
			 , Mes
	  ) As txc
Order By 1, 3
Having Mes Between m.lnMesIni
		And m.lnMesFin
Into Cursor curVtaCliMes

Endtext

&lcSelVtaMes
Browse

lcCols = [CustomerId C(5),CompanyName C(40),] + [_] + Transform(m.lnMesIni) + [ Y]
For lnMes = m.lnMesIni + 1 To m.lnMesFin
	Text To m.lcCols Additive Textmerge Noshow Flags 1 Pretext 15
		,<<[_] + Transform(lnMes) + [ Y]>>
	Endtext
Next m.lnMes

Messagebox(m.lcCols)

Text To m.lcCreaCursor Textmerge Noshow Flags 1 Pretext 15
	Create Cursor curVentasCliMes ( <<lcCols>> )
Endtext

&lcCreaCursor

Messagebox(m.lcCreaCursor)

Select curVtaCliMes
Scan
	Insert Into curVentasCliMes (CustomerId, CompanyName) Values (curVtaCliMes.CustomerId, curVtaCliMes.CompanyName)
	Scan While curVtaCliMes.CustomerId = curVentasCliMes.CustomerId
		lcCampo = [curVentasCliMes._] + Transform(Mes)
		Replace &lcCampo With curVtaCliMes.Importe
	EndScan
	Skip -1 In curVtaCliMes
Endscan

Select curVentasCliMes
Browse

Report Form TotComprasXCliente Preview

Release Procedure TotComprasXCliente
*
*---------------------------------------------------------------------------------------------------------------------------
*
Procedure MesAAAA(tc_AnoMes As String)

#Define _MESES_		[Ene,Feb,Mar,Abr,May,Jun,Jul,Ago,Set,Oct,Nov,Dic]

Local lcAAAA As String	  ;
	, lcMes As String	  ;
	, lnAAAA As Number	  ;
	, lnAnoMes As Number  ;
	, lnMes As Number

lnAnoMes = Val(Substr(m.tc_AnoMes, 2))
lnAAAA	 = Int(m.lnAnoMes / 12)
lnAAAA	 = Iif(m.lnAnoMes % 12 = 0, m.lnAAAA - 1, m.lnAAAA)
lcAAAA	 = Transform(m.lnAAAA)
lnMes	 = Round(m.lnAnoMes % 12, 0)
lnMes	 = Iif(m.lnMes = 0, 12, m.lnMes)
lcMes	 = Getwordnum(_MESES_, m.lnMes, [,])

Return m.lcMes + [ ] + m.lcAAAA
