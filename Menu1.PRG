WITH NEWOBJECT("xForm")
  .SHOW(1)
ENDWITH
RETURN

DEFINE CLASS xForm AS FORM
  ADD OBJECT cmdMenu1 AS xCommandButton WITH ;
    CAPTION = "Menu 1", TOP = 10, LEFT = 10,;
    MenuOptions = "Opcion 1 . \<1,Opcion 1 . \<2,Opcion 1 . \<3"

  ADD OBJECT cmdMenu2 AS xCommandButton WITH ;
    CAPTION = "Menu 2", TOP = 10, LEFT = 120,;
    MenuOptions = "Opcion 2 . \<1,Opcion 2 . \<2"

  ADD OBJECT cmdClose AS xCommandButton WITH ;
    CANCEL = .T., CAPTION = "Cerrar", TOP = 10, LEFT = 240

  PROCEDURE cmdClose.CLICK
    THISFORM.HIDE()
  ENDPROC
ENDDEFINE

DEFINE CLASS xCommandButton AS COMMANDBUTTON
  HEIGHT = 25

  MenuOptions = ""

  PROCEDURE MOUSEMOVE (nButton, nShift, nXCoord, nYCoord)
    IF nButton==1 AND ! EMPTY(THIS.MenuOptions)
      THIS.ShowPopupMenu()
      NODEFAULT
    ENDIF
  ENDPROC

  PROCEDURE KEYPRESS(nKeyCode, nShiftCtrlAlt)
    #DEFINE K_DOWN 160
    #DEFINE K_ALT 4
    #DEFINE K_F4 -3

    * WAIT WINDOW TRANSFORM(nKeyCode) + " " + TRANSFORM(nShiftCtrlAlt) NOWAIT

    DO CASE
      CASE nKeyCode==K_DOWN AND nShiftCtrlAlt==K_ALT
        NODEFAULT
        THIS.ShowPopupMenu()
      CASE nKeyCode==K_F4
        NODEFAULT
        THIS.ShowPopupMenu()
    ENDCASE
  ENDPROC

  PROCEDURE CLICK
    NODEFAULT
    THIS.ShowPopupMenu()
  ENDPROC

  * Armo y muestro el menú
  PROCEDURE ShowPopupMenu()
    LOCAL nOp, sOp, nY, nX, nRatio

    TRY
      RELEASE POPUP _Popup_Menu
    CATCH
    ENDTRY

    WITH THIS
      THISFORM.ADDPROPERTY("ActivePopupMenu", THIS)

      * Convierto de pixels a foxels
      nRatio = FONTMETRIC(1)
      nY = (.TOP + .HEIGHT) / nRatio

      nRatio = FONTMETRIC(6)
      nX = .LEFT / nRatio

      DEFINE POPUP _Popup_Menu FROM nY, nX SHORTCUT

      FOR nOp = 1 TO GETWORDCOUNT(.MenuOptions, ",")
        sOp = GETWORDNUM(.MenuOptions, nOp, ",")
        DEFINE BAR (nOp) OF _Popup_Menu PROMPT (sOp)
        sOp = TRANSFORM(nOp)
        ON SELECTION BAR (nOp) OF _Popup_Menu _SCREEN.ACTIVEFORM.ActivePopupMenu.AfterClick( &sOp )
      NEXT
    ENDWITH

    ACTIVATE POPUP _Popup_Menu
  ENDPROC

  * Borro el menú luego del click y llamo al handler
  PROCEDURE AfterClick(nOption)
    THISFORM.ActivePopupMenu = NULL
    * RELEASE POPUP _Popup_Menu
    THIS.OnMenu (nOption)
    THISFORM.REFRESH()
  ENDPROC

  PROCEDURE OnMenu (nOption)
    WAIT WINDOW "Seleccionó opcion " + TRANSFORM(nOption) + " del botón " + PROPER(THIS.NAME) NOWAIT
  ENDPROC
ENDDEFINE