loForm = CREATEOBJECT("MiForm")
loForm.SHOW(1)

DEFINE CLASS MiForm AS FORM
  DATASESSION = 2

  ADD OBJECT MiGrid AS GRID WITH ;
    RECORDSOURCE = "Orders",  HEIGHT = 400,  WIDTH = 400, ANCHOR = 15, ;
    READONLY = .T., FONTSIZE = 12, ROWHEIGHT = 24

  PROCEDURE LOAD
    USE (HOME(2) + "Data\Orders")
  ENDPROC

  PROCEDURE INIT
    THIS.MiGrid.SETALL("DynamicBackColor", "(ThisForm.ColorMe(Orders.Emp_Id, .F.))")
    THIS.MiGrid.SETALL("DynamicForeColor", "(ThisForm.ColorMe(Orders.Emp_Id, .T.))")
    THIS.WINDOWSTATE = 2
  ENDPROC

  PROCEDURE ColorMe(tcValue, tlForeColor)
    LOCAL lnBackColor, lnForeColor
    lnBackColor = BITAND(VAL(SYS(2007,m.tcValue,1,1)), 0x00FFFFFF)
    IF NOT m.tlForeColor
      RETURN m.lnBackColor
    ENDIF

    LOCAL lnRed, lnGreen, lnBlue,lnAlpha
    lnRed = BITAND(BITRSHIFT(m.lnBackColor,0), 0xFF)
    lnGreen = BITAND(BITRSHIFT(m.lnBackColor,8), 0xFF)
    lnBlue = BITAND(BITRSHIFT(m.lnBackColor,16), 0xFF)
    lnAlpha = (MAX(m.lnRed,m.lnGreen,m.lnBlue) + MIN(m.lnRed,m.lnGreen,m.lnBlue)) / 2

    RETURN IIF(m.lnAlpha < 0x80, 0xFFFFFF, 0)
  ENDPROC
ENDDEFINE