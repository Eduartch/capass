********************************
PUBLIC oform1
oform1 = NEWOBJECT("form1")
oform1.SHOW
RETURN

DEFINE CLASS form1 AS FORM
  TOP = 0
  LEFT = 0
  HEIGHT = 190
  WIDTH = 480
  DOCREATE = .T.
  CAPTION = "Form1"
  NAME = "Form1"

  ADD OBJECT combo1 AS COMBOBOX WITH ;
    COMMENT = "", ;
    ROWSOURCETYPE = 2, ;
    HEIGHT = 25, ;
    INCREMENTALSEARCH = .T., ;
    LEFT = 30, ;
    SELECTONENTRY = .T., ;
    TABINDEX = 2, ;
    TOP = 28, ;
    WIDTH = 350, ;
    INPUTMASK = "", ;
    NAME = "Combo1"

  ADD OBJECT label4 AS LABEL WITH ;
    AUTOSIZE = .T., ;
    FONTBOLD = .T., ;
    BACKSTYLE = 0, ;
    CAPTION = "Uno de la lista o nuevo, desplegado", ;
    HEIGHT = 17, ;
    LEFT = 30, ;
    TOP = 12, ;
    WIDTH = 207, ;
    TABINDEX = 4, ;
    FORECOLOR = RGB(88,99,124), ;
    NAME = "Label4"

  ADD OBJECT command1 AS COMMANDBUTTON WITH ;
    TOP = 12, ;
    LEFT = 408, ;
    HEIGHT = 36, ;
    WIDTH = 49, ;
    CAPTION = "Salir", ;
    TABINDEX = 3, ;
    NAME = "Command1"

  PROCEDURE LOAD
    CAPSLOCK(.F.) && simulo trabajar con minusculas
    PUBLIC mf
    mf = SYS(2015)
    OPEN DATABASE (HOME(2) + "Northwind\Northwind.dbc")
    SELECT 0
    USE Customers
  ENDPROC

  PROCEDURE combo1.INIT
    * Creo propiedad para almacenar configuracion CapsLock
    IF PEMSTATUS(THIS,'lCaps',5) = .F.
      WITH THIS
        .ADDPROPERTY('lCaps',.F.)
      ENDWITH
    ENDIF
    THIS.COMMENT = ''
  ENDPROC

  PROCEDURE combo1.KEYPRESS
    LPARAMETERS nKeyCode, nShiftAltCtrl
    IF BETWEEN(nKeyCode, 32, 122)
      * Primero comprueba la lista
      FOR X=1 TO THIS.LISTCOUNT
        IF UPPER(SUBSTR(THIS.LIST(X), 1, THIS.SELSTART+1)) == ;
            UPPER(SUBSTR(THIS.TEXT, 1, THIS.SELSTART)+CHR(nKeyCode))
          NCURPOS = THIS.SELSTART + 1
          THIS.VALUE = THIS.LIST(X)
          THIS.SELSTART = NCURPOS
          THIS.SELLENGTH = LEN(LTRIM(THIS.LIST(X))) - NCURPOS
          THIS.COMMENT = SUBSTR(THIS.LIST(X),1,NCURPOS)
          NODEFAULT
          EXIT
        ENDIF
      NEXT X
      * Si no está en la lista
      IF X > THIS.LISTCOUNT
        NCURPOS = LEN(THIS.COMMENT) + 1
        THIS.COMMENT = THIS.COMMENT + CHR(nKeyCode)
        THIS.DISPLAYVALUE = THIS.COMMENT
        THIS.SELSTART = NCURPOS
        NODEFAULT
      ENDIF
    ENDIF
    * Si pulsamos Retroceso o flecha izda.
    IF nKeyCode = 127 OR nKeyCode = 19
      NCURPOS = LEN(THIS.COMMENT) -1
      THIS.COMMENT = LEFT(THIS.COMMENT, NCURPOS)
      THIS.DISPLAYVALUE = THIS.COMMENT
      THIS.SELSTART = NCURPOS
      NODEFAULT
    ENDIF
    IF nKeyCode = 13
      THIS.LOSTFOCUS
    ENDIF
  ENDPROC

  PROCEDURE combo1.LOSTFOCUS
    THIS.ROWSOURCE = ''
    USE IN SELECT('curcombo')
    * Devolvemos config. inicial CapsLock
    CAPSLOCK(THIS.lcaps)
    * Tiempo busqueda incremental predeterminado
    _INCSEEK = 0.5
    *
    *  El dato introducido / seleccionado, se encuentra
    *  en la propiedad 'DisplayValue'.
    *
  ENDPROC

  PROCEDURE combo1.GOTFOCUS
    THIS.lcaps = CAPSLOCK()
    IF CAPSLOCK() = .F.
      CAPSLOCK(.T.) && Fuerzo a mayúsculas
    ENDIF
    _INCSEEK = 5.5 && Tiempo busqueda incremental al maximo
    LOCAL cFile, cCampo
    cFile='customers' && Tabla de la que tomar los datos
    cCampo='upper(ltrim(companyname))' && campo a mostrar
    SELECT &cCampo AS cDato FROM &cFile DISTINCT WHERE !EMPTY(&cCampo) ;
      ORDER BY cDato INTO CURSOR curcombo nofilter
    THIS.ROWSOURCE = 'curcombo' && Establecemos origen de datos
    KEYBOARD '{ALT+DNARROW}' && Desplegamos lista
    *
    *  Si le pasamos un valor previo (en la propiedad 'DisplayValue'),
    *  simulamos haberlo tecleado para que se situe en la lista.
    *
    IF !EMPTY(THIS.DISPLAYVALUE)
      cTexto = THIS.DISPLAYVALUE
      FOR yy = 1 TO LEN(cTexto)
        cLetra = SUBSTR(cTexto, yy, 1)
        KEYBOARD cLetra
      ENDFOR
    ENDIF
  ENDPROC

  PROCEDURE command1.CLICK
    * El dato lo obtenemos de la propiedad 'DisplayValue'
    IF !EMPTY(ALLTRIM(THISFORM.combo1.DISPLAYVALUE))
      =MESSAGEBOX(THISFORM.combo1.DISPLAYVALUE)
    ENDIF
    USE IN SELECT('customers')
    CLOSE ALL
    RELEASE mf
    THISFORM.RELEASE
  ENDPROC

ENDDEFINE
*-- EndDefine: form1
**************************************************