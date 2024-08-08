LOCAL oForm
oForm = NEWOBJECT("Form1")
oForm.SHOW
READ EVENTS
RETURN

DEFINE CLASS Form1 AS FORM
  HEIGHT = 390
  WIDTH = 500
  AUTOCENTER = .T.
  CAPTION = 'Reordenar las columnas y conservarlas'
  SHOWTIPS = .T.

  ADD OBJECT label1 AS LABEL WITH ;
    CAPTION = 'Arrastre y suelte para reordenar columnas. Luego cierre y ' + ;
    'vuelva a abrir formulario para ver si la disposición está guardada', ;
    TOP = 10, LEFT = 10, WIDTH = 480, HEIGHT = 40, WORDWRAP = .T.

  ADD OBJECT grid1 AS GRID WITH ;
    COLUMNCOUNT = 3,;
    HEIGHT = 328, LEFT = 10, TOP = 50, WIDTH = 480,;
    GRIDLINES = 3, DELETEMARK = .F.,;
    GRIDLINECOLOR = RGB(192,192,192),;
    GRIDLINES = 0, FONTNAME = 'Tahoma', FONTSIZE = 8,;
    ANCHOR = 15, ALLOWCELLSELECTION = .F.,;
    TOOLTIPTEXT = 'Drag Column to Rearrange'

  PROCEDURE LOAD
    SET TALK OFF
    SET SAFETY OFF
    CLOSE DATABASES ALL
    SELECT  company, contact, TITLE FROM (HOME(2)+"data\customer") WHERE RECNO() < 50 INTO CURSOR junk
    USE IN SELECT('customer')

    * Create/use a table to store grid column settings
    IF !FILE("gridcolumns.dbf")
      CREATE TABLE gridcolumns (ColName c(10), ColOrder I)
    ELSE
      USE gridcolumns IN 0 SHARED
    ENDIF
  ENDPROC

  PROCEDURE INIT
    IF RECCOUNT("gridcolumns") == 0
      * First run? Save the current order of the columns
      LOCAL lnloop
      WITH THISFORM.grid1
        FOR lnloop = 1 TO .COLUMNCOUNT
          lcColName =  .COLUMNS(m.lnloop).NAME
          lnOrder = .COLUMNS(m.lnloop).COLUMNORDER
          INSERT INTO gridcolumns VALUES (m.lcColName, m.lnOrder)
        NEXT
      ENDWITH
    ENDIF
    THIS._getorder()
  ENDPROC

  PROCEDURE grid1.INIT
    WITH THIS
      .RECORDSOURCETYPE = 6
      .RECORDSOURCE = 'junk'
      .Column1.Header1.CAPTION = 'Column1'
      .Column2.Header1.CAPTION = 'Column2'
      .Column3.Header1.CAPTION = 'Column3'
      .SETALL('Width',150,'Column')

      * Bind Move Events
      FOR lnloop = 1 TO .COLUMNCOUNT
        BINDEVENT(.COLUMNS(m.lnloop),'Moved',THISFORM,'_Moved')
      NEXT
    ENDWITH
  ENDPROC

  PROCEDURE _Moved
    * Save new column orders
    LOCAL lnloop
    WITH THISFORM.grid1
      FOR lnloop = 1 TO .COLUMNCOUNT
        lcColName =  ALLTRIM(.COLUMNS(m.lnloop).NAME)
        lnOrder = .COLUMNS(m.lnloop).COLUMNORDER
        REPLACE ColOrder WITH m.lnOrder FOR ALLTRIM(ColName) = m.lcColName IN gridcolumns
      NEXT
    ENDWITH
  ENDPROC

  PROCEDURE _getorder
    * Fetch Column Orderings
    SELECT gridcolumns
    LOCAL lnloop
    WITH THISFORM.grid1
      FOR lnloop = 1 TO .COLUMNCOUNT
        lcColName =  .COLUMNS(m.lnloop).NAME
        LOCATE FOR ColName = m.lcColName
        .COLUMNS(m.lnloop).COLUMNORDER = ColOrder
      NEXT
      .REFRESH
    ENDWITH
  ENDPROC

  PROCEDURE DESTROY
    CLOSE DATABASES ALL
    CLEAR EVENTS
  ENDPROC

ENDDEFINE