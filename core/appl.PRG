Define Class Appl As Custom
	Function crearobjeto
	Lparameters pcItemList,p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19
	Local oBuff,i,cProp
	oBuff=Createobject("Custom")

	Local cPropName,uPropValue,nCount
	Local Array aProps[1]
	nCount = Alines(aProps,Strt(pcItemList,",",Chr(13)+Chr(10)))
	For i=1 To Min(nCount,20)
		cPropName = aProps[i]
		uPropValue = Evaluate("P" + Alltrim(Str(i - 1)))
		oBuff.AddProperty(cPropName, uPropValue)
	Endfor

	Return oBuff
	Endfunc
Enddefine
