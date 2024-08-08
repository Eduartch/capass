Local lcFileName,lcXMLFile,lcFilter

lcDBFName = Home(2) + "data\orders.dbf"
lcXMLFile = Lower(Sys(2023)) + "\orders.xml"
lcFilter = "FOR To_Region='WA'"

Strtofile(DBF2XML(lcDBFName, lcFilter, .T.), ;
	lcXMLFile)
Modify File (lcXMLFile) Nowait

Return
Procedure DBF2XML
Lparameters tcTable, tcScope, tnTabIndents
*-- ASCII codes
#Define Tab     Chr(9)
#Define LF      Chr(10)
#Define CR      Chr(13)
#Define CR_LF   CR+LF


Local lcTable, lcAlias, lcScope, lcDBFName, lcIndentText, lcDBF, lcRootName
Local lcValue, lcField, lnFieldCount, lnCount, lnLastSelect, lnLastRecNo
Local lcXMLText
Dimension laFields[1]

If Not Inlist(Vartype(tcTable), "C", "L") Or Not ;
		INLIST(Vartype(tcScope), "C", "L")
	Return ""
Endif

lcIndentText = Iif(Vartype(tnTabIndents) == "N", ;
	REPLICATE(Tab, tnTabIndents), "")
lcTable = Lower(Iif(Empty(tcTable), Alias(), Alltrim(tcTable)))
lnLastSelect=Select()

If "." $ lcTable
	lcDBF = lcTable
	If Not File(lcDBF)
		Return ""
	Endif

	Select 0
	lcAlias = Lower(Sys(2015))
	Use (lcDBF) Alias (lcAlias) Again Shared
	lcDBFName = Lower(Forceext(Justfname(Dbf()), ""))
Else
	lcDBF = ""
	lcAlias = lcTable
	lcDBFName = lcAlias
Endif

If Not Used(lcAlias)
	Select (lnLastSelect)
	Return ""
Endif

lcScope = Iif(Empty(tcScope), "ALL", Alltrim(tcScope))

Select (lcAlias)

lnLastRecNo = Iif(Eof(), 0, Recno())
lcXMLText = "<"+ lcDBFName + "_table>" + CR_LF

lnFieldCount = Afields(laFields)
If lnFieldCount = 0
	Select (lnLastSelect)
	Return ""
Endif

lcRootName = lcDBFName
Do While Type(lcRootName) != "U"
	lcRootName = lcRootName + "1"
Enddo

Scan &lcScope
	lcXMLText = lcXMLText + lcIndentText + ;
		"<" + lcRootName + ">" + CR_LF

	For lnCount = 1 To lnFieldCount
		lcField = Lower(laFields[lnCount, 1])
		lcValue = Alltrim(Transform(Evaluate(lcField)))
		If Empty(lcValue)
			Loop
		Endif

		lcXMLText=lcXMLText + lcIndentText + Tab + ;
			"<" + lcField + ">" + lcValue + "</" + lcField + ">" + CR_LF
	Endfor

	lcXMLText = lcXMLText + lcIndentText + ;
		"</" + lcRootName + ">" + CR_LF
Endscan

If Empty(lcDBF)
	If lnLastRecNo > 0
		Go lnLastRecNo
	Endif
Else
	Use
Endif

Select (lnLastSelect)

lcXMLText = lcXMLText + CR_LF + "</"+ lcDBFName + "_table>"

Return lcXMLText
