Local lcAlias     As String   ,;
	lcMessage   As String   ,;
	lcSetSafety As String   ,;
	llReturn    As BOOLEAN  ,;
	lcURL       As String   ,;
	lcFile      As String   ,;
	loXmlHttp   As Microsoft.XMLHTTP

lcAlias = Alias()
lcSetSafety = Set( "safety" )

Try
	loXmlHttp = Newobject( "Microsoft.XMLHTTP" )

	lcURL = "http://finance.yahoo.com/d/quotes.csv"
	loXmlHttp.Open( "POST" , lcURL, .F. )
	loXmlHttp.Send( "s=MSFT,^DJI&f=sl1d1t1c1ohgv&e=.csv" )

	If loXmlHttp.Status != 200
		lcMessage = Textmerge( ;
			"An error occurred - status = <<loXmlHttp.STATUS>><<loXmlHttp.statustext>>" )

		Messagebox( lcMessage, 16, Program() )
		Exit
	Endif

	lcFile = Sys( 2015 )
	Strtofile( loXmlHttp.responsetext, lcFile )

	If !Used( "stockquotes" )
		Create Cursor stockquotes ( ;
			Symbol c( 8 ), ;
			LAST Y, ;
			DATE D, ;
			TIME c( 8 ), ;
			CHANGE Y, ;
			OPEN Y, ;
			HIGH Y, ;
			Low Y, ;
			VOLUME B( 0 ))
	Endif

	Select stockquotes
	Append From ( lcFile ) Delimited
	Set Safety Off
	Erase ( lcFile )
	Browse
	llReturn = .T.

Catch To oException

	TEXT TO lcMessage TEXTMERGE NOSHOW PRETEXT 3
    Error # <<oException.ErrorNo>> occured on line: <<oException.LINENO>> of <<oException.PROCEDURE>>.

    Offending line of code:
    <<oException.LineContents>>

    Error Message:
    <<oException.Details>>
	ENDTEXT
	Messagebox( lcMessage, 16, Program())

Finally
	Set Safety &lcSetSafety
	Select ( Select( lcAlias ))
Endtry

Return m.llReturn
