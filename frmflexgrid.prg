**************************************************
*-- Author:       Michael Drozdov
*-- Description:  Demonstrate:
*--				  using MS MSFlexGrid control
*--				  ... and OLE control from code
*-- Used:         Msflxgrd.ocx (MSFlexGridLib.MSFlexGrid),
*--               Setup.dbf from D:\Program Files\Microsoft Visual Studio\MSDN\99OCT\1033\SAMPLES\VFP98\data\Testdata.dbc
*-- Time Stamp:   09/19/00 04:25:12 PM
**************************************************

#DEFINE vbWindowBackground		2147483653 	&& H80000005
#DEFINE vbApplicationWorkspace	2147483660	&& H8000000C
#DEFINE vbMenuBar				2147483652	&& H80000004
#DEFINE N_MAXFLDLEN				30
#DEFINE N_TWIPSTOPIXEL			120

RELEASE goForm
PUBLIC goForm
goForm = CreateObject("form1")
IF TYPE('goForm') = 'O' AND !ISNULL(goForm)
	goForm.Show()
ELSE
	??CHR(7)
	MessageBox("Can not create form", 16, _SCREEN.Caption)	
ENDIF

**************************************************
*-- Form:         form1 (d:\myapp\vfp\frmflexgrid.scx)
*-- ParentClass:  form
*-- BaseClass:    form
*-- Time Stamp:   02/14/01 07:59:02 PM
*
DEFINE CLASS form1 AS form

	Height = 196
	Width = 262
	DoCreate = .T.
	AutoCenter = .T.
	BorderStyle = 2
	Caption = "Form1"
	MaxButton = .F.
	Name = "Form1"


	ADD OBJECT olecontrol1 AS olecontrol WITH ;
		Top = 12, ;
		Left = 12, ;
		Height = 151, ;
		Width = 231, ;
		Name = "Olecontrol1", ;
		OleClass = 'MSFlexGridLib.MSFlexGrid.1'


	ADD OBJECT cmdexit AS commandbutton WITH ;
		Top = 168, ;
		Left = 192, ;
		Height = 25, ;
		Width = 61, ;
		FontSize = 8, ;
		Cancel = .T., ;
		Caption = "Cancel", ;
		Name = "cmdExit"


	PROCEDURE initcolumns
		IF EMPTY(ALIAS())
			RETURN .F.
		ENDIF

		*
		*-- Fill headers columns
		LOCAL nCols, nCntCol, nLenCol
		LOCAL ARRAY laFields[1,16]
		nCols = AFIELDS(laFields)
		LOCAL nMaxFldLen, nTwipsToPixel, nMaxFldLen

		nMaxFldLen = N_MAXFLDLEN
		nTwipsToPixel = N_TWIPSTOPIXEL

		WITH ThisForm.Olecontrol1.Object
			.Cols = nCols+1
			.Rows = 2
			.FixedRows = 1
			.BackColor = vbWindowBackground
			.BackColorBkg = vbApplicationWorkspace
			.BackColorFixed = vbMenuBar
			.TextMatrix(0, 0) = ''
			.ColWidth(0) = 2 * nTwipsToPixel
			FOR nCntCol = 1 TO nCols
				.TextMatrix(0, nCntCol) = PROPER(FIELD(nCntCol))
				nLenCol = laFields[nCntCol,3]
				IF nLenCol > nMaxFldLen
					nLenCol = nMaxFldLen
				ENDIF
				.ColWidth(nCntCol) = nLenCol * nTwipsToPixel
			NEXT nCntCol
			.Rows = 1
		ENDWITH
	ENDPROC


	PROCEDURE refreshgrid
		LOCAL nCols, nRecordCount, nCntCol, nCntRow
		IF EMPTY(ALIAS())
			RETURN .F.
		ENDIF

		nCols = FCOUNT()
		nRecordCount = RECCOUNT()

		WITH ThisForm.Olecontrol1.Object
			.Cols = nCols+1
			.Rows = nRecordCount + 1
			nCntRow = 0
			.Refresh
			SCAN
				nCntRow = nCntRow + 1
				.TextMatrix(nCntRow, 0) = ''
				FOR nCntCol = 1 TO nCols
					.TextMatrix(nCntRow, nCntCol) = EVALUATE(FIELD(nCntCol))
				NEXT nCntCol
			ENDSCAN
			.Rows = nCntRow + 1
		ENDWITH
	ENDPROC


	PROCEDURE Init
		IF EMPTY(ALIAS())
			RETURN .F.
		ENDIF
		IF !This.InitColumns()
			RETURN .F.
		ENDIF
		IF !This.RefreshGrid()
			RETURN .F.
		ENDIF
	ENDPROC


	PROCEDURE Load
		LOCAL lcFile, lcAlias
		lcFile = HOME(2)+'Tastrade\Data\setup.dbf'
		IF !FILE(lcFile)
			ACTIVATE SCREEN
			??CHR(7)
			MessageBox('Not found file: '+lcFile)
			RETURN .F.
		ENDIF
		lcAlias = JUSTSTEM(lcFile)
		IF !USED(lcAlias)
			USE (lcFile) IN 0 SHARED
			IF !USED(lcAlias)
				ACTIVATE SCREEN
				??CHR(7)
				MessageBox('Can not open file: '+lcFile)
				RETURN .F.
			ENDIF
		ENDIF
		SELECT (lcAlias)
	ENDPROC
	
	PROCEDURE Destroy
		IF !EMPTY(ALIAS())
			USE IN (ALIAS())
		ENDIF
	ENDPROC

	PROCEDURE cmdexit.Click
		ThisForm.Release()
	ENDPROC

ENDDEFINE
*
*-- EndDefine: form1
**************************************************
