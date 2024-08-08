SET SAFETY OFF
*!* LOCAL lc
*!* TEXT TO lc NOSHOW
*!* Este es un texto tomado de un archivo de
*!* texto, para buscar una palabra y remarcarla
*!* si la encuentra.

*!* Escriba en el cuadro de texto una palabra
*!* que se encuentre aquí y haga click en el
*!* botón Buscar.

*!* Visual FoxPro. Nada corre como un zorro.
*!* ENDTEXT
*!* STRTOFILE(lc,"MiTxt.txt")
*-- Creo el formulario
PUBLIC goForm
goForm = CREATEOBJECT("Form1")
goForm.SHOW

DEFINE CLASS Form1 AS FORM
  CAPTION = "Ejemplo de búsqueda en un EditBox"
  NAME = "Form1"
    WIDTH = 375+600
    HEIGHT= 250+300
  ADD OBJECT Text1 AS TEXTBOX WITH ;
    HEIGHT = 24, ;
    LEFT = 24, ;
    TOP = 12, ;
    NAME = "Text1"
  ADD OBJECT Command1 AS COMMANDBUTTON WITH ;
    HEIGHT = 24, ;
    TOP = 12, ;
    LEFT = 144, ;
    CAPTION = "Buscar", ;
    NAME = "Command1"
  ADD OBJECT Edit1 AS EDITBOX WITH ;
    HEIGHT = 180+400, ;
    LEFT = 24, ;
    TOP = 48, ;
    WIDTH = 300+600, ;
    NAME = "Edit1"
  PROCEDURE INIT
    *!* THISFORM.Edit1.VALUE = FILETOSTR("MiTxt.txt")
    THISFORM.Edit1.VALUE = FILETOSTR("d:\psysg\firmaxml\20531920504-RC-20211115-4.xml")
    *!* messageb(ThisForm.Width )
    *!* messageb(ThisForm.Height)
  ENDPROC
  PROCEDURE Command1.CLICK
    ** LOCAL lcBusca, lnPos, lnLen
    ** lcBusca = ALLTRIM(THISFORM.Text1.VALUE)
    ** lnLen = LEN(lcBusca)
    ** lnPos = AT(lcBusca,THISFORM.Edit1.VALUE)
    ** IF lnPos > 0
    **   THISFORM.Edit1.SELSTART = lnPos - 1
    **   THISFORM.Edit1.SELLENGTH = lnLen
    **   THISFORM.Edit1.SETFOCUS
    ** ELSE
    **   MESSAGEBOX("No se encuentra",64,"Aviso")
    ** ENDIF
    
    LOCAL lcBusca
    lcBusca = GetFile('XML')
    IF !empty(lcBusca)
       THISFORM.Edit1.VALUE = FILETOSTR(lcBusca)
    ENDIF
    
  ENDPROC
ENDDEFINE