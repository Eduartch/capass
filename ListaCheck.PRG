PUBLIC oForm

oForm = CREATEOBJECT("clsListCheckBox")

oForm.VISIBLE = .T.

READ EVENTS

DEFINE CLASS clsListCheckBox AS FORM

    TOP = 1
    LEFT = 0
    HEIGHT = 473
    WIDTH = 287
    DOCREATE = .T.
    CAPTION = "Listbox With Checkboxes"
    WINDOWSTATE = 0
    NAME = "clsListCheckBox"
    AlwaysOnTop = .T.
    CheckIcon = HOME() + "Graphics\Icons\Misc\MISC15.ICO"
    Uncheckicon = HOME() + "Graphics\Icons\Misc\MISC13.ICO"
    SHOWWINDOW = 2

    ADD OBJECT list1 AS LISTBOX WITH ;
        HEIGHT = 408, ;
        LEFT = 12, ;
        SORTED = .T., ;
        TOP = 48, ;
        WIDTH = 264, ;
        NAME = "List1", ;
        ROWSOURCETYPE = 2, ;
        ROWSOURCE = "ListCheck"
        
    PROCEDURE LOAD
        LOCAL nCount, nCount2, nWordLength, sItem, nUpper, nLower
        nUpper = 90 &&ASCII
        nLower = 65 &&ASCII
        CREATE CURSOR ListCheck (MyEntry c(35), Checked L)
        FOR nCount = 1 TO 250
            sItem = ""
            nWordLength = INT((35) * RAND( ) + 1)
            FOR nCount2 = 1 TO nWordLength
                sItem = sItem + CHR(INT((nUpper - nLower + 1) * RAND( ) + nLower))
            ENDFOR
            INSERT INTO ListCheck (MyEntry, Checked) VALUES(sItem, .F.)
        NEXT
    ENDPROC
        
    PROCEDURE Unload
        USE IN SELECT("ListCheck")
        CLEAR EVENTS
    ENDPROC

    PROCEDURE ListSetup
        THISFORM.LOCKSCREEN = .T.
        LOCAL nListCount
        nListCount = 1
        SELECT ListCheck
        SCAN ALL
            IF ListCheck.Checked
                THIS.list1.PICTURE(nListCount) = THISFORM.CheckIcon
            ELSE
                THIS.list1.PICTURE(nListCount) = THISFORM.Uncheckicon
            ENDIF
            nListCount = nListCount + 1
        ENDSCAN
        THISFORM.LOCKSCREEN = .F.
    ENDPROC

    PROCEDURE SetCheck
        LOCAL nListIndex
        nListIndex = THIS.list1.LISTINDEX
        IF nListIndex > 0
            GO nListIndex IN "ListCheck"
            IF ListCheck.Checked
                THIS.list1.PICTURE(nListIndex) = THISFORM.Uncheckicon
            ELSE
                THIS.list1.PICTURE(nListIndex) = THISFORM.CheckIcon
            ENDIF
            REPLACE ListCheck.Checked WITH !ListCheck.Checked
        ENDIF
    ENDPROC

    PROCEDURE list1.GOTFOCUS()
        IF DODEFAULT()
            THISFORM.ListSetup()
        ENDIF
    ENDPROC
    
    PROCEDURE list1.CLICK()
        IF LASTKEY() = 13
            THISFORM.SetCheck()
        ENDIF
    ENDPROC

    PROCEDURE list1.KEYPRESS(nKeyCode, nShiftAltCtrl)
        IF nKeyCode = 13 OR nKeyCode = 32
            THISFORM.SetCheck()
        ENDIF
    ENDPROC

ENDDEFINE