m.cTalk=SET("TALK")

SET TALK OFF



PUBLIC oTlb

oTlb = NEWOBJECT("tlbDemo")

oTlb.SHOW



PUBLIC oFrmDemo

oFrmDemo=NEWOBJECT("frmDemo")

oFrmDemo.SHOW



READ EVENTS



RELEASE oTlb

RELEASE oFrmDemo

SET TALK &cTalk



RETURN





DEFINE CLASS tlbDemo AS TOOLBAR



    HEIGHT = 31

    LEFT = 30

    TOP = 30

    WIDTH = 149

    NAME = "tlbDemo"

    CAPTION = "Example"

    CONTROLBOX = .F.



    ADD OBJECT cmdShowColumn AS COMMANDBUTTON  WITH ;

        TOP = 5, ;

        LEFT = 5, ;

        HEIGHT = 22, ;

        WIDTH = 100, ;

        CAPTION = "ActiveColumn?", ;

        NAME = "cmdShowColumn"





    ADD OBJECT sepSeparator1 AS SEPARATOR WITH ;

        TOP = 5, ;

        LEFT = 80, ;

        HEIGHT = 0, ;

        WIDTH = 0, ;

        NAME = "sepSeparator1"





    ADD OBJECT cmdExit AS COMMANDBUTTON WITH ;

        TOP = 5, ;

        LEFT = 80, ;

        HEIGHT = 22, ;

        WIDTH = 34, ;

        CAPTION = "Exit", ;

        NAME = "cmdExit"





    PROCEDURE cmdShowColumn.CLICK

        DO ShowColumn

    ENDPROC



    PROCEDURE cmdExit.CLICK

        CLEAR EVENTS

    ENDPROC



ENDDEFINE



DEFINE CLASS frmDemo AS FORM





    CLOSABLE = .F.

    CAPTION = "ActiveColumn Example"

    NAME = "frmDemo"

    LEFT = 60

    TOP = 100





    ADD OBJECT grdNames AS GRID WITH ;

        COLUMNCOUNT = 3, ;

        DELETEMARK = .F., ;

        HEIGHT = 128, ;

        LEFT = 12, ;

        PANEL = 1, ;

        RECORDSOURCE = "names", ;

        SPLITBAR = .F., ;

        TABINDEX = 3, ;

        TOP = 48, ;

        WIDTH = 340, ;

        NAME = "grdNames", ;

        Column1.CONTROLSOURCE = "names.cname", ;

        Column1.WIDTH = 122, ;

        Column1.NAME = "Column1", ;

        Column2.CONTROLSOURCE = "names.nvalue", ;

        Column2.WIDTH = 100, ;

        Column2.NAME = "Column2", ;

        Column3.CONTROLSOURCE = "names.dbirth", ;

        Column3.WIDTH = 122, ;

        Column3.NAME = "Column3"





    PROCEDURE LOAD

        CREATE CURSOR names (cname C(40), nvalue N(19,2), dbirth D)

        INSERT INTO names VALUES('Thomas',12.5,{^1990-5-11})

        INSERT INTO names VALUES('Jerry',18.2,{^1993-1-28})

        INSERT INTO names VALUES('Andrew',9.2,{^1986-1-23})

        GO TOP

    ENDPROC



    PROCEDURE INIT

        THIS.grdNames.Column1.Header1.CAPTION = "Name"



        WITH THIS.grdNames.Column1.Text1

            .BORDERSTYLE = 0

            .MARGIN = 0

        ENDWITH



        THIS.grdNames.Column2.Header1.CAPTION = "Value"



        WITH THIS.grdNames.Column2.Text1

            .BORDERSTYLE = 0

            .MARGIN = 0

        ENDWITH



        THIS.grdNames.Column3.Header1.CAPTION = "Birthdate"



        WITH THIS.grdNames.Column3.Text1

            .BORDERSTYLE = 0

            .MARGIN = 0

        ENDWITH





    ENDPROC



    

ENDDEFINE



PROCEDURE ShowColumn

    WAIT WINDOW AT 4,30 "_SCREEN.ActiveForm.ActiveControl.ActiveColumn = "+TRANSFORM(_SCREEN.ActiveForm.ActiveControl.ActiveColumn) NOWAIT

ENDPROC
