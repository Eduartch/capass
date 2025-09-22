WITH NEWOBJECT("xForm")
    .Show(1)
ENDWITH 

RETURN 


DEFINE CLASS xForm as Form
    ADD OBJECT cmdMenu1 as xCommandButton WITH Caption = "Menu 1", Top = 10, Left = 10,;
        MenuOptions = "Opcion 1 . \<1,Opcion 1 . \<2,Opcion 1 . \<3"
        
    ADD OBJECT cmdMenu2 as xCommandButton WITH Caption = "Menu 2", Top = 10, Left = 120,;
        MenuOptions = "Opcion 2 . \<1,Opcion 2 . \<2"
        
    ADD OBJECT cmdClose as xCommandButton WITH Cancel = .T., Caption = "Cerrar", Top = 10, Left = 240
    
    PROCEDURE cmdClose.Click
    ThisForm.Hide()
    ENDPROC 
ENDDEFINE 
    

DEFINE CLASS xCommandButton as CommandButton
    Height = 25
    
    MenuOptions = ""
    

    PROCEDURE MouseMove (nButton, nShift, nXCoord, nYCoord)
    
    IF nButton==1 AND ! EMPTY(This.MenuOptions)
        This.ShowPopupMenu()
        NODEFAULT 
    ENDIF
    
    ENDPROC 
    
    
    
    PROCEDURE KeyPress(nKeyCode, nShiftCtrlAlt)
        
    #define K_DOWN    160
    #define K_ALT    4
    #define K_F4    -3
        
    * WAIT WINDOW TRANSFORM(nKeyCode) + " " + TRANSFORM(nShiftCtrlAlt) NOWAIT 
    
    DO CASE
    CASE nKeyCode==K_DOWN AND nShiftCtrlAlt==K_ALT
        NODEFAULT 
        This.ShowPopupMenu()
    CASE nKeyCode==K_F4
        NODEFAULT 
        This.ShowPopupMenu()
    ENDCASE 
    
    ENDPROC 
    

    PROCEDURE Click
    NODEFAULT 
    This.ShowPopupMenu()
    ENDPROC 
    
    

    * Armo y muestro el menú
    PROCEDURE ShowPopupMenu()
    
    LOCAL nOp, sOp, nY, nX, nRatio

    TRY 
        RELEASE POPUP _Popup_Menu 
    CATCH 
    ENDTRY 

    WITH This
        ThisForm.AddProperty("ActivePopupMenu", This)

        * Convierto de pixels a foxels        
        nRatio = FONTMETRIC(1)
        nY = (.Top + .Height) / nRatio

        nRatio = FONTMETRIC(6)
        nX = .Left / nRatio
        
        DEFINE POPUP _Popup_Menu FROM nY, nX SHORTCUT
        
        FOR nOp = 1 TO GETWORDCOUNT(.MenuOptions, ",")
            sOp = GETWORDNUM(.MenuOptions, nOp, ",")
            DEFINE BAR (nOp) OF _Popup_Menu PROMPT (sOp)
            sOp = TRANSFORM(nOp)
            ON SELECTION BAR (nOp) OF _Popup_Menu _Screen.ActiveForm.ActivePopupMenu.AfterClick( &sOp )
        NEXT
    ENDWITH
    
    ACTIVATE POPUP _Popup_Menu
    
    ENDPROC 
    
    

    * Borro el menú luego del click y llamo al handler
    PROCEDURE AfterClick(nOption)

    ThisForm.ActivePopupMenu = NULL
    * RELEASE POPUP _Popup_Menu 
    This.OnMenu (nOption)
    ThisForm.Refresh()
    
    ENDPROC 
    
    
    PROCEDURE OnMenu (nOption)
    WAIT WINDOW "Seleccionó opcion " + TRANSFORM(nOption) + " del botón " + PROPER(This.Name) NOWAIT 
    ENDPROC 
ENDDEFINE 