Public oCal

oCal = CreateObject("Calculator")
oCal.Show


#DEFINE CRLF            CHR(13)+CHR(10)
#DEFINE BUTTONBACKCOLOR RGB(245,245,245)

**************************************************
*-- Class:        calc (d:\all_zapl\lib\mc_win95.vcx)
*-- ParentClass:  form
*-- BaseClass:    form
*-- Time Stamp:   10/19/05 02:26:04 PM
*
DEFINE CLASS Calculator AS form


	Height                 = 340
	Width                  = 245
	DoCreate               = .T.
	ShowTips               = .T.
	Caption                = "Calculadora"
	ControlBox             = .T.
	Closable               = .T.
	FontSize               = 8
	MaxButton              = .F.
	MinButton              = .F.
	MaxWidth               = 245
	MinHeight              = 340
	MinWidth               = 245
	KeyPreview             = .T.
	BackColor              = RGB(116,116,116)
	BorderStyle            = 1 
	ShowWindow             = 1 
	AutoCenter             = .T. 
	icon                   ="d:\psysn\graphics\Anular.ico"   
	memoval                = 0
	result                 = 0
	znak                   = []
	br_rows                = 0
	nbracketsopened        = 0
	AddEnterValueToHistory = .T.
	frmActiveControl       = NULL
	ActiveFormDatasession  = ""
	Name                   = "calc"
	blockade               = .F.
	fl_znak                = .F.
	memoclick              = .F.
	old_num                = .F.

	ADD OBJECT memorecall AS commandbutton WITH ;
		Top = 205, ;
		Left = 38, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "MR", ;
		TabIndex = 23, ;
		ToolTipText = ['ShortCut Key - "R"'], ;
		SpecialEffect = 2, ;
		Name = "MEMORECALL"

	ADD OBJECT b7 AS commandbutton WITH ;
		Top = 231, ;
		Left = 38, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "7", ;
		TabIndex = 10, ;
		ToolTipText = ['ShortCut Key - "7"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(0,0,255), ;
		Name = "B7"

	ADD OBJECT b4 AS commandbutton WITH ;
		Top = 257, ;
		Left = 38, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "4", ;
		TabIndex = 7, ;
		ToolTipText = ['ShortCut Key - "4"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(0,0,255), ;
		Name = "B4"

	ADD OBJECT b1 AS commandbutton WITH ;
		Top = 283, ;
		Left = 38, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "1", ;
		TabIndex = 4, ;
		ToolTipText = ['ShortCut Key - "1"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(0,0,255), ;
		Name = "B1"

	ADD OBJECT b0 AS commandbutton WITH ;
		Top = 309, ;
		Left = 38, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "0", ;
		TabIndex = 1, ;
		ToolTipText = ['ShortCut Key - "0"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(0,0,255), ;
		Name = "B0"

***Aqui comienza la tercera linea de botones

	ADD OBJECT leftbracket AS commandbutton WITH ;
		Top = 179, ;
		Left = 75, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "(", ;
		TabIndex = 20, ;
		ToolTipText = ['ShortCut Key - "("'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(255,0,255), ;
		Name = "LeftBracket"

	ADD OBJECT memominus AS commandbutton WITH ;
		Top = 205, ;
		Left = 75, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "M-", ;
		TabIndex = 21, ;
		ToolTipText = ['ShortCut Key - "M"'], ;
		SpecialEffect = 2, ;
		Name = "MEMOMINUS"


	ADD OBJECT b8 AS commandbutton WITH ;
		Top = 231, ;
		Left = 75, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "8", ;
		TabIndex = 11, ;
		ToolTipText = ['ShortCut Key - "8"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(0,0,255), ;
		Name = "B8"

	ADD OBJECT b5 AS commandbutton WITH ;
		Top = 257, ;
		Left = 75, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "5", ;
		TabIndex = 8, ;
		ToolTipText = ['ShortCut Key - "5"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(0,0,255), ;
		Name = "B5"

	ADD OBJECT b2 AS commandbutton WITH ;
		Top = 283, ;
		Left = 75, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "2", ;
		TabIndex = 5, ;
		ToolTipText = ['ShortCut Key - "2"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(0,0,255), ;
		Name = "B2"

	ADD OBJECT b00 AS commandbutton WITH ;
		Top = 309, ;
		Left = 75, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "00", ;
		TabIndex = 2, ;
		ToolTipText = ['ShortCut Key - Shift+"0"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(0,0,255), ;
		Name = "B00"

***Aqui comienza la cuarta linea de botones

	ADD OBJECT rightbracket AS commandbutton WITH ;
		Top = 179, ;
		Left = 112, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = ")", ;
		TabIndex = 19, ;
		ToolTipText = ['ShortCut Key - ")"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(255,0,255), ;
		Name = "RightBracket"

	ADD OBJECT memoplus AS commandbutton WITH ;
		Top = 205, ;
		Left = 112, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "M+", ;
		TabIndex = 22, ;
		ToolTipText = ['ShortCut Key - "P"'], ;
		SpecialEffect = 2, ;
		Name = "MEMOPLUS"

	ADD OBJECT b9 AS commandbutton WITH ;
		Top = 231, ;
		Left = 112, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "9", ;
		TabIndex = 12, ;
		ToolTipText = ['ShortCut Key - "9"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(0,0,255), ;
		Name = "B9"

	ADD OBJECT b6 AS commandbutton WITH ;
		Top = 257, ;
		Left = 112, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "6", ;
		TabIndex = 9, ;
		ToolTipText = ['ShortCut Key - "6"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(0,0,255), ;
		Name = "B6"

	ADD OBJECT b3 AS commandbutton WITH ;
		Top = 283, ;
		Left = 112, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "3", ;
		TabIndex = 6, ;
		ToolTipText = ['ShortCut Key - "3"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(0,0,255), ;
		Name = "B3"

	ADD OBJECT bpoint AS commandbutton WITH ;
		Top = 309, ;
		Left = 112, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = ".", ;
		TabIndex = 3, ;
		ToolTipText = ['ShortCut Key - "." or ","'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(0,0,255), ;
		Name = "BPOINT"


***Aqui comienza la quinta linea de botones

	ADD OBJECT power2 AS commandbutton WITH ;
		Top = 179, ;
		Left = 149, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "x^2", ;
		TabIndex = 20, ;
		ToolTipText = ['ShortCut Key - "X"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(255,0,255), ;
		Name = "Power2"

	ADD OBJECT plusminus AS commandbutton WITH ;
		Top = 205, ;
		Left = 149, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "+/-", ;
		TabIndex = 20, ;
		ToolTipText = ['ShortCut Key - "S"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(255,0,255), ;
		Name = "PLUSMINUS"

	ADD OBJECT multi AS commandbutton WITH ;
		Top = 231, ;
		Left = 149, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "*", ;
		TabIndex = 17, ;
		ToolTipText = ['ShortCut Key - "*"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(255,0,255), ;
		Name = "MULTI"

	ADD OBJECT minus AS commandbutton WITH ;
		Top = 257, ;
		Left = 149, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "-", ;
		TabIndex = 15, ;
		ToolTipText = ['ShortCut Key - "-"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(255,0,255), ;
		Name = "MINUS"

	ADD OBJECT plus AS commandbutton WITH ;
		Top = 283, ;
		Left = 149, ;
		Height = 51, ;
		Width = 35, ;
		Caption = "+", ;
		TabIndex = 13, ;
		ToolTipText = ['ShortCut Key - "+"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(255,0,255), ;
		Name = "PLUS"

***Aqui comienza la sexta linea de botones



	ADD OBJECT percent AS commandbutton WITH ;
		Top = 205, ;
		Left = 186, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "%", ;
		TabIndex = 19, ;
		ToolTipText = ['ShortCut Key - "%"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(255,0,255), ;
		Name = "PERCENT"

	ADD OBJECT sqrt AS commandbutton WITH ;
		Top = 231, ;
		Left = 186, ;
		Height = 25, ;
		Width = 35, ;
		FontName = "Symbol", ;
		FontSize = 8, ;
		Caption = "Ö", ;
		TabIndex = 18, ;
		ToolTipText = ['ShortCut Key - "\"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(255,0,255), ;
		Name = "SQRT"

	ADD OBJECT divide AS commandbutton WITH ;
		Top = 257, ;
		Left = 186, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "/", ;
		TabIndex = 16, ;
		ToolTipText = ['ShortCut Key - "/"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(255,0,255), ;
		Name = "DIVIDE"

	ADD OBJECT equal AS commandbutton WITH ;
		Top = 283, ;
		Left = 186, ;
		Height = 51, ;
		Width = 35, ;
		Caption = (ALLTRIM("=")), ;
		TabIndex = 14, ;
		ToolTipText = ['ShortCut Key - "=" or Enter'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(255,0,255), ;
		Name = "EQUAL"

	ADD OBJECT command3 AS commandbutton WITH ;
		Top = 179, ;
		Left = 186, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "x^y", ;
		TabIndex = 19, ;
		ToolTipText = ['ShortCut Key - "^"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(255,0,255), ;
		Name = "Command3"

***Aqui comienza la primera linea de botones

	ADD OBJECT ac AS commandbutton WITH ;
		Top = 205, ;
		Left = 1, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "AC", ;
		TabIndex = 27, ;
		ToolTipText = ['ShortCut Key - "A"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(255,0,0), ;
		Name = "AC"


	ADD OBJECT off AS commandbutton WITH ;
		Top = 231, ;
		Left = 1, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "OFF", ;
		TabIndex = 26, ;
		ToolTipText = ['ShortCut Key - "O"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(255,0,0), ;
		Name = "OFF"

	ADD OBJECT back AS commandbutton WITH ;
		Top = 257, ;
		Left = 1, ;
		Height = 25, ;
		Width = 35, ;
		FontName = "Symbol", ;
		FontSize = 8, ;
		Caption = "<-", ;
		TabIndex = 25, ;
		ToolTipText = "ShortCut Key - BackSpace", ;
		SpecialEffect = 2, ;
		ForeColor = RGB(255,0,0), ;
		Name = "BACK"

	ADD OBJECT bc AS commandbutton WITH ;
		Top = 283, ;
		Left = 1, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "C", ;
		TabIndex = 24, ;
		ToolTipText = ['ShortCut Key - "C"'], ;
		SpecialEffect = 2, ;
		ForeColor = RGB(255,0,0), ;
		Name = "BC"

	ADD OBJECT fillbutt AS commandbutton WITH ;
		Top = 309, ;
		Left = 1, ;
		Height = 25, ;
		Width = 35, ;
		FontSize = 8, ;
		Caption = "F", ;
		TabIndex = 24, ;
		ToolTipText = "", ;
		SpecialEffect = 2, ;
		ForeColor = RGB(255,0,0), ;
		Name = "FILLBUTT"


***Aqui comienza los textbox

	ADD OBJECT enter AS textbox WITH ;
		Alignment = 1, ;
		Enabled = .F., ;
		Height = 22, ;
		Left = 40, ;
		TabIndex = 29, ;
		Top = 154, ;
		Width = 180, ;
		DisabledBackColor = RGB(170,170,255), ;
		DisabledForeColor = RGB(0,0,0), ;
		Name = "Enter"

	ADD OBJECT text1 AS textbox WITH ;
		FontSize = 8, ;
		Alignment = 2, ;
		Enabled = .F., ;
		Height = 22, ;
		Left = 6, ;
		TabIndex = 30, ;
		Top = 154, ;
		Width = 27, ;
		DisabledBackColor = RGB(192,192,192), ;
		DisabledForeColor = RGB(0,0,0), ;
		Name = "Text1"

	ADD OBJECT text2 AS textbox WITH ;
		FontSize = 8, ;
		Alignment = 2, ;
		Enabled = .F., ;
		Height = 25, ;
		Left = 6, ;
		TabIndex = 30, ;
		Top = 179, ;
		Width = 59, ;
		DisabledBackColor = RGB(192,192,192), ;
		DisabledForeColor = RGB(0,0,0), ;
		Name = "Text2"


***Aqui comienza el Editbox

	ADD OBJECT lenta AS editbox WITH ;
		Alignment = 1, ;
		Height = 136, ;
		Left = 6, ;
		ReadOnly = .T., ;
		ScrollBars = 0, ;
		TabStop = .F., ;
		Top = 11, ;
		Width = 213, ;
		DisabledBackColor = RGB(170,170,255), ;
		DisabledForeColor = RGB(0,0,0), ;
		Name = "Lenta"


	PROCEDURE calculate
		DO CASE
		   CASE thisform.Znak == "*"
		        thisform.Result = thisform.Result * VAL(thisform.Enter.Value)
		   CASE thisform.Znak == "^"
		        thisform.Result = thisform.Result ^ VAL(thisform.Enter.Value)
		   CASE thisform.Znak == "+"
		        thisform.Result = thisform.Result + VAL(thisform.Enter.Value)
		   CASE thisform.Znak == "-"
		        thisform.Result = thisform.Result - VAL(thisform.Enter.Value)
		   CASE thisform.Znak == "/"
		        thisform.Result = thisform.Result / VAL(thisform.Enter.Value)
		   CASE thisform.Znak == "*%"
		        thisform.Result = thisform.Result * VAL(thisform.Enter.Value) / 100
		   CASE thisform.Znak == "+%"
		        thisform.Result = thisform.Result + (thisform.Result*VAL(thisform.Enter.Value) / 100)
		   CASE thisform.Znak == "-%"
		        thisform.Result = thisform.Result - (thisform.Result*VAL(thisform.Enter.Value) / 100)
		   CASE thisform.Znak == "/%"
		        thisform.Result = thisform.Result / VAL(thisform.Enter.Value) / 100
		ENDCASE
		thisform.Enter.Value = TRANSFORM(thisform.Result)
		thisform.fl_znak     = .f.
	ENDPROC


	PROCEDURE makelenta
		LPARAMETERS lcZnak

		IF this.br_rows = 0
		   this.Lenta.Value = ALLTRIM(this.Enter.Value) + " " + m.lcZnak
		ELSE
		   IF thisform.AddEntervalueToHistory
		      this.Lenta.Value = this.Lenta.Value + CRLF + ALLTRIM(this.Enter.Value) + " " + m.lcZnak
		   ELSE
		      this.Lenta.Value = this.Lenta.Value + " " + m.lcZnak
		   ENDIF
		ENDIF
		thisform.AddEntervalueToHistory = .t.
		this.br_rows                    = this.br_rows + 1
		this.ControlScroll(this.Lenta)
	ENDPROC


	PROCEDURE pressdidit
		LPARAMETERS lcDigit
		thisform.MemoClick = .f.
		IF .NOT. thisform.Blockade
		   IF .NOT. thisform.fl_znak
		      thisform.Enter.Value = lcDigit
		      thisform.fl_znak     = .t.
		   ELSE
		      IF (LEN(thisform.Enter.Value) < 16 AND thisform.nbracketsopened == 0) OR;
		         thisform.nbracketsopened # 0
		         thisform.Enter.Value = thisform.Enter.Value + m.lcDigit
		      ENDIF
		   ENDIF
		ENDIF
	ENDPROC


	PROCEDURE signpress
		LPARAMETERS lcSign
		IF .NOT. thisform.Blockade
		   IF thisform.nBracketsopened # 0
		      IF NOT thisform.Checkentervalue()
		         thisform.Enter.Value = thisform.Enter.Value + m.lcSign
		      ENDIF
		   ELSE
		      thisform.MemoClick = .f.
		      thisform.MakeLenta(m.lcSign)
		      IF EMPTY(thisform.Znak)
		         thisform.Result = VAL(thisform.Enter.Value)
		      ELSE
		         ThisForm.Calculate()
		      ENDIF
		      thisform.Znak    = m.lcSign
		      thisform.fl_znak = .f.
		   ENDIF
		ENDIF
	ENDPROC


	PROCEDURE controlscroll
		LPARAMETERS oControl
		LOCAL lnLen, lnSels
		IF INT(oControl.Height/17) < this.br_rows
		   oControl.ScrollBars = 2
		   m.lnLen  = LEN(oControl.Value)
		   m.lnSels = RAT(CHR(10),oControl.Value)
		ELSE
		   oControl.ScrollBars = 0
		   m.lnLen             = 0
		   m.lnSels            = 0
		ENDIF
		oControl.SelStart  = m.lnSels + 1
		oControl.SelLength = m.lnLen  - m.lnSels
	ENDPROC


	PROCEDURE nbracketsopened_assign
		LPARAMETERS vNewVal
		LOCAL lnEval
		*To do: Modify this routine for the Assign method
		THIS.nbracketsopened = m.vNewVal
		IF m.vNewVal == 0
		   IF NOT EMPTY(thisform.Enter.Value)
		      TRY
		          m.lnEval = thisform.Enter.Value
		          m.lnEval = EVALUATE(m.lnEval)
		          thisform.Enter.Value = thisform.Enter.Value + " = " +TRANSFORM(m.lnEval)
		          IF NOT EMPTY(thisform.Znak)
		             Thisform.Makelenta("=")
		             thisform.Enter.Value = TRANSFORM(m.lnEval)
		             thisform.Calculate()
		          ELSE
		             thisform.Result      = thisform.Result      + m.lnEval
		             thisform.Znak        = "x"
		          ENDIF
		      CATCH
		          thisform.Enter.Value = "ERROR"
		      ENDTRY
		      thisform.MakeLenta("")
		      thisform.AddEntervalueToHistory = .f.
		   ENDIF
		   thisform.Text2.Value = ""
		ELSE
		   thisform.Text2.Value = "(="+TRANSFORM(m.vNewVal)
		ENDIF
	ENDPROC


	PROCEDURE checkentervalue
		RETURN (RIGHT(thisform.Enter.Value,1) $ "+-*/^" OR RIGHT(thisform.Enter.Value,5) == "SQRT(")
	ENDPROC


	PROCEDURE fillresulttocontrol
		LPARAMETERS lnWhatClassToFill, lbonlyEditBox

		IF TYPE("this.frmActiveControl") = [O] AND;
		   NOT ISNULL(this.frmActiveControl)
		   m.lnDataSession = SET("Datasession")
		   SET DATASESSION TO this.ActiveFormDataSession
		   DO CASE
		      CASE NOT this.frmActiveControl.Enabled  OR;
		               this.frmActiveControl.ReadOnly
		           *** Control is ReadOnly or Disabled (I doubt the ActiveControl can be disabled, but just for insurance)
		           *** So we don't suppose change the value

		      CASE VARTYPE(this.frmActiveControl.Value) == "N" AND NOT m.lbonlyEditBox
		           DO CASE
		              CASE PEMSTATUS(this.frmActiveControl,"InputMask",5) AND;
		                   NOT EMPTY(this.frmActiveControl.InputMask)     AND;
		                   "*" $ TRANSFORM(m.lnWhatClassToFill,this.frmActiveControl.InputMask)
		                   *** Do Nothing, Result overflow inputmask 

		              CASE NOT EMPTY(this.frmActiveControl.ControlSource) AND;
		                   LEN(TRANSFORM(EVALUATE(this.frmActiveControl.ControlSource))) < LEN(m.lnWhatClassToFill)
		                   *** Again do nothing, Result oveflow the length of the field assosiated with the textbox
		           OTHERWISE
		                   this.frmActiveControl.Value = VAL(m.lnWhatClassToFill)
		           ENDCASE
		      CASE VARTYPE(this.frmActiveControl.Value) == "C"

		           m.lnSelStart  = this.frmActiveControl.SelStart
		           m.lnSelLength = this.frmActiveControl.SelLength
		           STORE "" TO m.lcBeginControlSourceValue, m.lcEndControlSourceValue
		           IF NOT EMPTY(this.frmActiveControl.ControlSource)
		              m.lcBeginControlSourceValue = EVALUATE(this.frmActiveControl.ControlSource)
		              m.lcEndControlSourceValue   = SUBSTR(m.lcBeginControlSourceValue,m.lnSelStart + m.lnSelLength + 1)
		              m.lcBeginControlSourceValue = LEFT(m.lcBeginControlSourceValue,m.lnSelStart)
		           ENDIF
		         
		           DO CASE
		              CASE PEMSTATUS(this.frmActiveControl,"InputMask",5) AND;
		                   NOT EMPTY(this.frmActiveControl.InputMask)     AND;
		                   "*" $ TRANSFORM(VAL(m.lnWhatClassToFill),this.frmActiveControl.InputMask)
		                   *** Do Nothing, Result overflow inputmask 

		              CASE NOT EMPTY(this.frmActiveControl.ControlSource)                                 AND;
		                   LEN(lcBeginControlSourceValue+lcEndControlSourceValue+m.lnWhatClassToFill) > LEN(EVALUATE(this.frmActiveControl.ControlSource)) AND;
		                   TYPE(this.frmActiveControl.ControlSource) == "C" && Otherwise is Memo and we can store the result there
		                   *** Again do nothing, Result oveflow the length of the field assosiated with the textbox

		              CASE this.frmActiveControl.MaxLength # 0            AND;
		                   this.frmActiveControl.MaxLength  < LEN(m.lnWhatClassToFill)
		                   *** Again do nothing, Result oveflow the MaxLength of the control
		           OTHERWISE
		                   IF PEMSTATUS(this.frmActiveControl,"InputMask",5) AND;
		                      NOT EMPTY(this.frmActiveControl.InputMask)
		                      m.lcInputMask = this.frmActiveControl.InputMask
		                      IF NOT EMPTY(this.frmActiveControl.Format)
		                         m.lcInputMask = [@]+this.frmActiveControl.Format+[ ]+this.frmActiveControl.InputMask
		                      ENDIF
		                      m.lcValueOfresult = TRANSFORM(VAL(m.lnWhatClassToFill),m.lcInputMask)
		                   ELSE
		                      m.lcValueOfresult = m.lnWhatClassToFill
		                   ENDIF
		                   IF NOT m.lbonlyEditBox OR (m.lbonlyEditBox AND UPPER(this.frmActiveControl.BaseClass)=="EDITBOX")
		                      this.frmActiveControl.Value    = m.lcBeginControlSourceValue + m.lcValueOfresult + m.lcEndControlSourceValue
		                      this.frmActiveControl.Refresh()
		                      this.frmActiveControl.SelStart = m.lnSelStart
		                      IF NOT EMPTY(m.lnSelLength)
		                        this.frmActiveControl.SelLength = LEN(m.lcValueOfresult)
		                      ENDIF
		                   ENDIF
		           ENDCASE
		   ENDCASE
		   this.frmActiveControl = NULL
		   SET DATASESSION TO lnDataSession
		ENDIF
	ENDPROC


	PROCEDURE Show
		LPARAMETERS nStyle
		IF TYPE("_SCREEN.ActiveForm")                =="O"  AND;
		   NOT ISNULL(_SCREEN.ActiveForm)                   AND;
		   TYPE("_SCREEN.ActiveForm.ActiveControl") == "O"  AND;
		   NOT ISNULL(_SCREEN.ActiveForm.ActiveControl)     AND;
		   UPPER(_SCREEN.ActiveForm.ActiveControl.BaseClass) $ "TEXTBOX EDITBOX"
		   this.ActiveFormDataSession = _SCREEN.ActiveForm.DataSessionID
		   this.frmActiveControl      = _SCREEN.ActiveForm.ActiveControl
		ENDIF
	ENDPROC


	PROCEDURE Init
		LPARAMETERS m_top,m_left

*!*			If Version(2) = 2
*!*			  *-- Estoy ejecutando en tiempo de diseño (o desde VFP)
*!*				Set Classlib To C:\municipio\clases\vfpskin.vcx Additive
*!*				Set Classlib To C:\municipio\clases\vfpskintools.vcx Additive
*!*		*		Set Path To C:\municipio\clases Additive
*!*			else
*!*				*-- Declaro la clase
*!*				Set Classlib To vfpskin.vcx ADDITIVE
*!*				Set Classlib To VFPSkinTools.VCX ADDITIVE 
*!*			ENDIF
*!*			thisform.AddObject("VFPSkin1", "VFPSkin")
*!*			thisform.VFPSkin1.SetSkinname(gcSkin)

		LOCAL oControl, lnControl
		this.Top                        = IIF(TYPE("m_top") # "N" ,0,m_top)
		this.Left                       = IIF(TYPE("m_left") # "N",0,m_left)
		thisform.SetAll("BackColor", BUTTONBACKCOLOR, "CommandButton")
		FOR EACH oControl IN this.Controls
		    IF NOT UPPER(oControl.Name) == "LENTA"
		       oControl.Tag = TRANSFORM(oControl.Top)
		    ELSE
		       oControl.Tag = TRANSFORM(oControl.Height)
		    ENDIF
		NEXT
		thisform.FillBUTT.ToolTipText = "ShortCut Keys" + CRLF +;
		                                          ["F"       or LeftClick  - copy only  Resul to memory] + CRLF + ;
		                                          [Shift+"F" or RigthClick - copy whole history to memory]
	ENDPROC


	PROCEDURE KeyPress
		LPARAMETERS nKeyCode, nShift
		LOCAL oButton, llisRigthclick
		m.oButton = ""
		DO CASE
		   CASE nKeyCode < 0
		   CASE (nKeyCode = 27 .OR. UPPER(CHR(nKeyCode)) == "O") .AND. nShift = 0  &&  Esc or O (off)
		        m.oButton = "this.OFF"
		   CASE nKeyCode == 40                             && press "("
		        m.oButton = "this.LeftBracket"
		   CASE nKeyCode == 41                             && press ")"
		        m.oButton = "this.RightBracket"
		   CASE nKeyCode == 48            .AND. nShift = 2 && Ctrl+0    press "00"
		        m.oButton = "this.B00"
		   CASE BETWEEN(nKeyCode, 48, 57) .AND. nShift = 0 && press some digit
		        m.oButton = "this.B"+CHR(nKeyCode)
		   CASE INLIST(nKeyCode, 44, 46) .AND. nShift = 0 && Decimal point (no matter if it is point or comma
		        m.oButton = "this.BPOINT"
		   CASE nKeyCode = 127  .AND. nShift = 0 && BackSpace
		        m.oButton = "this.BACK"
		   CASE nKeyCode = 42  .AND. INLIST(nShift,0,1) &&  *
		        m.oButton = "this.Multi"
		   CASE nKeyCode = 47  .AND. nShift = 0 &&  /
		        m.oButton = "this.DIVIDE"
		   CASE nKeyCode = 45  .AND. nShift = 0 &&  -
		        m.oButton = "this.Minus"
		   CASE nKeyCode = 43  .AND. INLIST(nShift,0,1)       &&  +
		        m.oButton = "this.PLUS"
		   CASE INLIST(nKeyCode, 13, 61)  .AND. nShift = 0    &&  Enter or =
		        NODEFAULT
		        m.oButton = "this.EQUAL"
		   CASE UPPER(CHR(nKeyCode)) == "C"  .AND. nShift = 0 &&  C (Clear)
		        m.oButton = "this.BC"
		   CASE UPPER(CHR(nKeyCode)) == "A" .AND. nShift = 0  &&  A (ll Clear)
		        m.oButton = "this.AC"
		   CASE UPPER(CHR(nKeyCode)) == "F" .AND. nShift = 0  &&  F (Copy to Clipboard only result7)
		        m.oButton = "this.FILLBUTT"
		   CASE UPPER(CHR(nKeyCode)) == "F" .AND. nShift = 1  &&  Shift+F (Copy to Clipboard whole History)
		        m.llisRigthclick = .t.
		        m.oButton        = "this.FILLBUTT"
		   CASE nKeyCode = 37                                 &&  % (Percent pressed)
		        m.oButton = "this.Percent"
		   CASE nKeyCode = 92  .AND. nShift = 0               &&  \ (SQRT)
		        m.oButton = "this.SQRT"
		   CASE UPPER(CHR(nKeyCode)) = "S"  .AND. nShift = 0  &&  S (Sign change)
		        m.oButton = "this.PLUSMINUS"
		   CASE UPPER(CHR(nKeyCode)) = "R"  .AND. nShift = 0  &&  R (Memory recall)
		        m.oButton = "this.MEMORECALL"
		   CASE UPPER(CHR(nKeyCode)) = "M"  .AND. nShift = 0  &&  M (Memory minus)
		        m.oButton = "this.MEMOMINUS"
		   CASE UPPER(CHR(nKeyCode)) = "P"  .AND. nShift = 0  &&  P (Memory plus)
		        m.oButton = "this.MEMOPLUS"
		ENDCASE
		IF NOT EMPTY(m.oButton)
		   EVALUATE(m.oButton+[.SetFocus()])
		   EVALUATE(m.oButton+[.] + IIF(m.llisRigthclick,[Right],[]) + [Click()])
		ENDIF
	ENDPROC


	PROCEDURE Resize
		LOCAL lnTag
		this.LockScreen = .t.
		FOR EACH oControl IN this.Controls
		    lnTag = VAL(oControl.Tag)
		    IF NOT UPPER(oControl.Name) == "LENTA"
		       IF this.Height == this.MinHeight 
		          oControl.Top = m.lnTag
		       ELSE
		          oControl.Top = m.lnTag + (this.Height - this.MinHeight)
		       ENDIF
		    ELSE
		       IF this.Height == this.MinHeight 
		          oControl.Height = m.lnTag
		       ELSE
		          oControl.Height = m.lnTag + (this.Height - this.MinHeight)
		       ENDIF
		       this.ControlScroll(oControl)
		    ENDIF
		ENDFOR
		this.LockScreen = .f.
	ENDPROC


	PROCEDURE Hide
		this.frmActiveControl = NULL
	ENDPROC


	PROCEDURE b7.Click
		thisform.PressDidit("7")
	ENDPROC


	PROCEDURE b8.Click
		thisform.PressDidit("8")
	ENDPROC


	PROCEDURE b9.Click
		thisform.PressDidit("9")
	ENDPROC


	PROCEDURE b4.Click
		thisform.PressDidit("4")
	ENDPROC


	PROCEDURE b5.Click
		thisform.PressDidit("5")
	ENDPROC


	PROCEDURE b6.Click
		thisform.PressDidit("6")
	ENDPROC


	PROCEDURE b1.Click
		thisform.PressDidit("1")
	ENDPROC


	PROCEDURE b2.Click
		thisform.PressDidit("2")
	ENDPROC


	PROCEDURE b3.Click
		thisform.PressDidit("3")
	ENDPROC


	PROCEDURE b0.Click
		thisform.PressDidit("0")
	ENDPROC


	PROCEDURE b00.Click
		thisform.PressDidit("00")
	ENDPROC


	PROCEDURE plus.Click
		thisform.SignPress("+") 
	ENDPROC


	PROCEDURE minus.Click
		thisform.SignPress("-") 
	ENDPROC


	PROCEDURE multi.Click
		thisform.SignPress("*") 
	ENDPROC


	PROCEDURE divide.Click
		thisform.SignPress("/") 
	ENDPROC


	PROCEDURE memorecall.Click
		LOCAL asd, m_point
		IF .NOT. thisform.Blockade
		   IF thisform.MemoClick
		      thisform.Text1.Value =""
		      thisform.MemoVal = 0
		      thisform.MemoClick = .f.
		    ELSE
		       IF ROUND(thisform.MemoVal,14) = INT(thisform.MemoVal)
		          m_point = 0
		       ELSE
		         asd     = ALLTRIM(STRTRAN(STR(thisform.MemoVal,16,7),"0"," "))
		         m_point = AT(".",asd)
		         m_point = IIF(m_point=LEN(asd),0,LEN(asd)-m_point)
		       ENDIF
		       thisform.Enter.Value =  ALLTRIM(STR(thisform.MemoVal,16,m_point))
		       thisform.MemoClick = .t.
		    ENDIF
		    thisform.fl_znak = .f.
		ENDIF
	ENDPROC


	PROCEDURE memominus.Click
		IF .NOT. thisform.Blockade
		   IF .NOT. EMPTY(thisform.Znak)
		      thisform.Calculate()
		      thisform.MemoVal = thisform.MemoVal - thisform.Result
		   ELSE
		      thisform.MemoVal = thisform.MemoVal - thisform.Result
		   ENDIF
		   thisform.Text1.Value = "M"
		   thisform.MemoClick = .f.
		   thisform.fl_znak = .f.
		ENDIF
	ENDPROC


	PROCEDURE memoplus.Click
		IF .NOT. thisform.Blockade
		   IF .NOT. EMPTY(thisform.Znak)
		      thisform.Calculate()
		      thisform.MemoVal = thisform.MemoVal + thisform.Result
		   ELSE
		      thisform.MemoVal = thisform.MemoVal + thisform.Result
		   ENDIF
		   thisform.Text1.Value = "M"
		   thisform.MemoClick = .f.
		   thisform.fl_znak = .f.
		ENDIF
	ENDPROC


	PROCEDURE percent.Click
		IF .NOT. thisform.Blockade
		   thisform.MemoClick = .f.
		   thisform.MakeLenta("%")
		   IF .NOT. EMPTY(Thisform.Znak)
		      thisform.Znak = thisform.Znak + "%"
		      ThisForm.Calculate()
		   ENDIF
		   thisform.MakeLenta("=")
		   thisform.Znak = ""
		   thisform.fl_znak = .f.
		ENDIF
	ENDPROC


	PROCEDURE bpoint.Click
		thisform.MemoClick = .f.
		IF EMPTY(AT(".",thisform.Enter.Value)) .OR.;
		   .NOT. thisform.fl_znak
		   IF EMPTY(thisform.Enter.Value) .OR.;
		      .NOT. thisform.fl_znak
		      thisform.Enter.Value = "0."
		      thisform.fl_znak     = .t.
		   ELSE
		     thisform.Enter.Value  = thisform.Enter.Value + "."
		   ENDIF
		ENDIF
	ENDPROC


	PROCEDURE ac.Click
		thisform.Enter.Value             = ""
		thisform.Result                  = 0
		thisform.Blockade                = .f.
		thisform.fl_znak                 = .f.
		thisform.Znak                    = .f.
		thisform.Text1.DisabledForeColor = RGB(0,0,0)
		thisform.Text1.Value             = ""
		thisform.Lenta.Value             = ""
		thisform.br_rows                 = 0
		thisform.MemoVal                 = 0
		thisform.nBracketsopened         = 0
		thisform.Lenta.ScrollBars        = 0
		thisform.MemoClick               = .f.
	ENDPROC


	PROCEDURE off.Click
		thisform.Hide()
	ENDPROC


	PROCEDURE back.Click
		LOCAL m_len
		LOCAL lcRightChar, lnLen
		lnLen = LEN(thisform.Enter.Value)
		thisform.MemoClick = .f.
		DO CASE
		   CASE lnLen == 0
		   CASE lnLen = 1
		        thisform.Enter.Value     = ""
		        thisform.nBracketsopened = 0
		OTHERWISE
		        lcRightChar = RIGHT(thisform.Enter.Value,1)
		        DO CASE
		           CASE RIGHT(thisform.Enter.Value,5) == "SQRT("
		                thisform.nBracketsopened = thisform.nBracketsopened - 1
		                thisform.Enter.Value = LEFT(thisform.Enter.Value,LEN(thisform.Enter.Value)-4) && ;o)
		           CASE lcRightChar == ")"
		                thisform.nBracketsopened = thisform.nBracketsopened + 1
		           CASE lcRightChar == "("
		                thisform.nBracketsopened = thisform.nBracketsopened - 1
		        ENDCASE
		        thisform.Enter.Value = LEFT(thisform.Enter.Value,LEN(thisform.Enter.Value)-1)
		ENDCASE
	ENDPROC


	PROCEDURE bc.Click
		thisform.Enter.Value     = ""
		thisform.Blockade        = .f.
		thisform.fl_znak         = .f.
		thisform.MemoClick       = .f.
		thisform.nBracketsopened = 0
		IF thisform.Text1.Value = "E"
		   thisform.Text1.DisabledForeColor = RGB(0,0,0)
		   thisform.Text1.Value = IIF(EMPTY(thisform.MemoVal),"","M")
		ENDIF
	ENDPROC


	PROCEDURE equal.Click
		IF .NOT. EMPTY(thisform.Znak) .AND. .NOT. thisform.Blockade
		   thisform.MemoClick = .f.
		   thisform.MakeLenta("=")
		   IF thisform.fl_znak .OR. .NOT. EMPTY(thisform.Znak)
		      ThisForm.Calculate()
		   ENDIF
		   thisform.MakeLenta("T"+CRLF)
		   thisform.Znak = ""
		ENDIF
	ENDPROC


	PROCEDURE plusminus.Click
		LOCAL lnPointPosition,lnLen
		m.lnLen            = LEN(thisform.Enter.Value) 
		m.lnPointPosition  = AT(".",thisform.Enter.Value)
		m.lnPointPosition  = IIF(m.lnPointPosition#0,m.lnLen - m.lnPointPosition + IIF(VAL(thisform.Enter.Value)<0,0,1),0)
		thisform.MemoClick = .f.
		IF .NOT. EMPTY(VAL(thisform.Enter.Value))
		   thisform.Enter.Value = ALLTRIM(STR(VAL(thisform.Enter.Value) * (-1),m.lnLen + 1,m.lnPointPosition))
		ENDIF
	ENDPROC


	PROCEDURE sqrt.Click
		IF thisform.nBracketsopened # 0
		   IF thisform.CheckEntervalue()
		      thisform.nBracketsopened = thisform.nBracketsopened + 1
		      thisform.Enter.Value     = thisform.Enter.Value + "SQRT("
		   ENDIF
		ELSE
		   thisform.MemoClick = .f.
		   thisform.MakeLenta("SQRT")
		   thisform.Result = SQRT(VAL(thisform.Enter.Value))
		   thisform.Enter.Value = ALLTRIM(STR(thisform.Result,19,2))
		   thisform.fl_znak = .f.
		   thisform.MakeLenta("T")
		ENDIF
	ENDPROC


	PROCEDURE fillbutt.Click
		LOCAL lnPointPosition,lcResult
		IF .NOT. thisform.Blockade
		   thisform.MemoClick = .f.
		   IF EMPTY(thisform.Znak)
		      thisform.Result = VAL(thisform.Enter.Value)
		   ELSE
		      ThisForm.Calculate()
		   ENDIF
		   thisform.Znak     = ""
		   thisform.fl_znak  = .f.
		   m.lcResult        = ALLTRIM(STRTRAN(STR(thisform.Result,16,7),"0"," "))
		   m.lnPointPosition = AT(".",m.lcResult)
		   m.lnPointPosition = IIF(m.lnPointPosition=LEN(m.lcResult),0,LEN(m.lcResult)-m.lnPointPosition)
		   
		   _CLIPTEXT = ALLTRIM(STR(thisform.Result,16,m.lnPointPosition))
		   this.Parent.FillResultToControl(_CLIPTEXT)
		ENDIF
		thisform.Off.Click()
	ENDPROC


	PROCEDURE fillbutt.RightClick
		IF .NOT. thisform.Blockade
		   thisform.MemoClick = .f.
		   thisform.EquAL.Click()
		   thisform.Znak      = ""
		   thisform.fl_znak   = .f.
		   _CLIPTEXT          = thisform.Lenta.Value
		   this.Parent.FillResultToControl(_CLIPTEXT, .t.)
		ENDIF
		thisform.Off.Click()
	ENDPROC


	PROCEDURE rightbracket.Click
		IF thisform.nBracketsopened > 0 AND NOT thisform.Checkentervalue()
		   thisform.Enter.Value     = thisform.Enter.Value + ")"
		   thisform.nBracketsopened = thisform.nBracketsopened - 1
		ENDIF
	ENDPROC


	PROCEDURE leftbracket.Click
		IF NOT EMPTY(thisform.Enter.Value) AND EMPTY(thisform.Znak) AND thisform.nBracketsopened == 0
		   RETURN
		ENDIF

		IF thisform.nBracketsopened == 0
		    thisform.nBracketsopened = thisform.nBracketsopened + 1
		    thisform.Enter.Value = "("
		ELSE
		   IF thisform.CheckEnterValue()
		      thisform.nBracketsopened = thisform.nBracketsopened + 1
		      thisform.Enter.Value     = thisform.Enter.Value + "("
		   ENDIF
		ENDIF
		thisform.fl_znak = .t.
	ENDPROC


	PROCEDURE command3.Click
		thisform.SignPress("^") 
	ENDPROC


	PROCEDURE power2.Click
		thisform.MemoClick = .f.
		IF thisform.nBracketsopened # 0
		   IF NOT thisform.Checkentervalue()
		      thisform.Enter.Value = thisform.Enter.Value + "^2"
		   ENDIF
		ELSE
		   thisform.MakeLenta("^2")
		   thisform.Result      = (VAL(thisform.Enter.Value)^2)
		   thisform.Enter.Value = ALLTRIM(STR(thisform.Result,19,2))
		   thisform.fl_znak     = .f.
		   thisform.MakeLenta("T")
		ENDIF
	ENDPROC

ENDDEFINE
*
*-- EndDefine: calc
**************************************************


*!*	lnHwnd = fiNdwindow(0,'calculadora')
*!*	IF lnHwnd>0
*!*	     brIngwindowtotop(lnHwnd)
*!*	     seNdmessage(lnHwnd,274,61488,0)
*!*	ELSE
*!*	     DO FORM calculo1
*!*	ENDIF
