#Define cdoSendPassword "http://schemas.microsoft.com/cdo/configuration/sendpassword"
#Define cdoSendUserName "http://schemas.microsoft.com/cdo/configuration/sendusername"
#Define cdoSendUsingMethod "http://schemas.microsoft.com/cdo/configuration/sendusing"
#Define cdoSMTPAuthenticate "http://schemas.microsoft.com/cdo/configuration/smtpauthenticate"
#Define cdoSMTPConnectionTimeout "http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout"
#Define cdoSMTPServer "http://schemas.microsoft.com/cdo/configuration/smtpserver"
#Define cdoSMTPServerPort "http://schemas.microsoft.com/cdo/configuration/smtpserverport"
#Define cdoSMTPUseSSL "http://schemas.microsoft.com/cdo/configuration/smtpusessl"
#Define cdoURLGetLatestVersion "http://schemas.microsoft.com/cdo/configuration/urlgetlatestversion"
#Define cdoAnonymous 0	&& Perform no authentication (anonymous)
#Define cdoBasic 1	&& Use the basic (clear text) authentication mechanism.
#Define cdoSendUsingPort 2	&& Send the message using the SMTP protocol over the network.
#Define cdoXMailer "urn:schemas:mailheader:x-mailer"


Define Class cdo2000 As Custom

	Protected aErrors[1], nErrorCount, oMsg, oCfg, cXMailer

	nErrorCount = 0

* Message attributes
	oMsg = Null

	cFrom = ""
	cReplyTo = ""
	cTo = ""
	cCC = ""
	cBCC = ""
	cAttachment = ""

	cSubject = ""
	cHtmlBody = ""
	cTextBody = ""
	cHtmlBodyUrl = ""

	cCharset = ""

* Priority: Normal, High, Low or empty value (Default)
	cPriority = ""

* Configuration object fields values
	oCfg = Null
	cServer = ""
	nServerPort = 25
* Use SSL connection
	lUseSSL = .F.
	nConnectionTimeout = 30			&& Default 30 sec's
	nAuthenticate = cdoAnonymous
	cUserName = ""
	cPassword = ""
* Do not use cache for cHtmlBodyUrl
	lURLGetLatestVersion = .T.

* Optional. Creates your own X-MAILER field in the header
	cXMailer = "VFP CDO 2000 mailer Ver 1.1.100 2010"

	Protected Procedure Init
		This.ClearErrors()
		Endproc

* Send message
	Procedure Send

	If This.GetErrorCount() > 0
		Return This.GetErrorCount()
	Endif

	With This
		.ClearErrors()
		.oCfg = Createobject("CDO.Configuration")
		.oMsg = Createobject("CDO.Message")
		.oMsg.Configuration = This.oCfg
	Endwith

* Fill message attributes
	Local lnind, laList[1], loHeader, laDummy[1], lcMailHeader

	If This.SetConfiguration() > 0
		Return This.GetErrorCount()
	Endif

	If Empty(This.cFrom)
		This.AddError("ERROR : From is empty.")
	Endif
	If Empty(This.cSubject)
		This.AddError("ERROR : Subject is empty.")
	Endif

	If Empty(This.cTo) And Empty(This.cCC) And Empty(This.cBCC)
		This.AddError("ERROR : To, CC and BCC are all empty.")
	Endif

	If This.GetErrorCount() > 0
		Return This.GetErrorCount()
	Endif

	This.SetHeader()

	With This.oMsg

		.From     = This.cFrom
		.ReplyTo  = This.cReplyTo

		.To       = This.cTo
		.CC       = This.cCC
		.BCC      = This.cBCC
		.Subject  = This.cSubject

* Create HTML body from external HTML (file, URL)
		If Not Empty(This.cHtmlBodyUrl)
			.CreateMHTMLBody(This.cHtmlBodyUrl)
		Endif

* Send HTML body. Creates TextBody as well
		If Not Empty(This.cHtmlBody)
			.HtmlBody = This.cHtmlBody
		Endif

* Send Text body. Could be different from HtmlBody, if any
		If Not Empty(This.cTextBody)
			.TextBody = This.cTextBody
		Endif

		If Not Empty(This.cCharset)
			If Not Empty(.HtmlBody)
				.HtmlBodyPart.Charset = This.cCharset
			Endif

			If Not Empty(.TextBody)
				.TextBodyPart.Charset = This.cCharset
			Endif
		Endif

* Process attachments
		If Not Empty(This.cAttachment)
* Accepts comma or semicolon
* VFP 7.0 and later
*FOR lnind=1 TO ALINES(laList, This.cAttachment, [,], [;])
* VFP 6.0 and later compatible
			For lnind=1 To Alines(laList, Chrtran(This.cAttachment, [,;], Chr(13) + Chr(13)))
				lcAttachment = Alltrim(laList[lnind])
* Ignore empty values
				If Empty(laList[lnind])
					Loop
				Endif

* Make sure that attachment exists
				If Adir(laDummy, lcAttachment) = 0
					This.AddError("ERROR: Attacment not Found - " + lcAttachment)
				Else
* The full path is required.
					If 	Upper(lcAttachment) <> Upper(Fullpath(lcAttachment))
						lcAttachment = Fullpath(lcAttachment)
					Endif
					.AddAttachment(lcAttachment)
				Endif
			Endfor
		Endif

		If Not Empty(This.cCharset)
			.BodyPart.Charset = This.cCharset
		Endif

* Priority
		If Not Empty(This.cPriority)
			lcMailHeader = "urn:schemas:mailheader:"
			.Fields(lcMailHeader + "Priority")   = Lower(This.cPriority)
			.Fields(lcMailHeader + "Importance") = Lower(This.cPriority)
			Do Case
			Case This.cPriority = "High"
				.Fields(lcMailHeader + "X-Priority") = 1 && 5=Low, 3=Normal, 1=High
			Case This.cPriority = "Normal"
				.Fields(lcMailHeader + "X-Priority") = 3 && 5=Low, 3=Normal, 1=High
			Case This.cPriority = "Low"
				.Fields(lcMailHeader + "X-Priority") = 5 && 5=Low, 3=Normal, 1=High
			Endcase
			.Fields.Update()
		Endif
	Endwith

	If This.GetErrorCount() > 0
		Return This.GetErrorCount()
	Endif

	This.oMsg.Send()

	Return This.GetErrorCount()

	Endproc

* Clear errors collection
	Procedure ClearErrors()
	This.nErrorCount = 0
	Dimension This.aErrors[1]
	This.aErrors[1] = Null
	Return This.nErrorCount
	Endproc

* Return # of errors in the error collection
	Procedure GetErrorCount
	Return This.nErrorCount
	Endproc

* Return error by index
	Procedure Geterror
	Lparameters tnErrorno
	If	tnErrorno <= This.GetErrorCount()
		Return This.aErrors[tnErrorno]
	Else
		Return Null
	Endif
	Endproc

* Populate configuration object
	Protected Procedure SetConfiguration

* Validate supplied configuration values
		If Empty(This.cServer)
			This.AddError("ERROR: SMTP Server isn't specified.")
		Endif
		If Not Inlist(This.nAuthenticate, cdoAnonymous, cdoBasic)
			This.AddError("ERROR: Invalid Authentication protocol ")
		Endif
		If This.nAuthenticate = cdoBasic ;
				AND (Empty(This.cUserName) Or Empty(This.cPassword))
			This.AddError("ERROR: User name/Password is required for basic authentication")
		Endif

		If 	This.GetErrorCount() > 0
			Return This.GetErrorCount()
		Endif

		With This.oCfg.Fields

* Send using SMTP server
			.Item(cdoSendUsingMethod) = cdoSendUsingPort
			.Item(cdoSMTPServer) = This.cServer
			.Item(cdoSMTPServerPort) = This.nServerPort
			.Item(cdoSMTPConnectionTimeout) = This.nConnectionTimeout

			.Item(cdoSMTPAuthenticate) = This.nAuthenticate
			If This.nAuthenticate = cdoBasic
				.Item(cdoSendUserName) = This.cUserName
				.Item(cdoSendPassword) = This.cPassword
			Endif
			.Item(cdoURLGetLatestVersion) = This.lURLGetLatestVersion
			.Item(cdoSMTPUseSSL) = This.lUseSSL

			.Update()
		Endwith

		Return This.GetErrorCount()

		Endproc

*----------------------------------------------------
* Add message to the error collection
	Protected Procedure AddError
		Lparameters tcErrorMsg
		This.nErrorCount = This.nErrorCount + 1
		Dimension This.aErrors[This.nErrorCount]
		This.aErrors[This.nErrorCount] = tcErrorMsg
		Return This.nErrorCount
		Endproc

*----------------------------------------------------
* Format an error message and add to the error collection
	Protected Procedure AddOneError
		Lparameters tcPrefix, tnError, tcMethod, tnLine
		Local lcErrorMsg, laList[1]
		If Inlist(tnError, 1427,1429)
			Aerror(laList)
			lcErrorMsg = Transform(laList[7], "@0") + "  " + laList[3]
		Else
			lcErrorMsg = Message()
		Endif
		This.AddError(tcPrefix + ":" + Transform(tnError) + " # " + ;
			tcMethod + " # " + Transform(tnLine) + " # " + lcErrorMsg)
		Return This.nErrorCount
		Endproc

*----------------------------------------------------
* Simple Error handler. Adds VFP error to the objects error collection
	Protected Procedure Error
		Lparameters tnError, tcMethod, tnLine
		This.AddOneError("ERROR: ", tnError, tcMethod, tnLine )
		Return This.nErrorCount
		Endproc

*-------------------------------------------------------
* Set mail header fields, if necessary. For now sets X-MAILER, if specified
	Protected Procedure SetHeader
		Local loHeader
		If Not Empty(This.cXMailer)
			loHeader = This.oMsg.Fields
			With loHeader
				.Item(cdoXMailer) =  This.cXMailer
				.Update()
			Endwith
		Endif
		Endproc

*----------------------------------------------------
*
	Protected Procedure cPriority_assign(tvVal)
* Check for incorrect values
		If Inlist("~" + Proper(tvVal) + "~", "~High~", "~Normal~", "~Low~") Or Empty(tvVal)
			This.cPriority = Proper(Alltrim(tvVal))
		Else
			This.AddError("ERROR: Invalid value for cPriority property.")
		Endif
		Endproc

Enddefine
