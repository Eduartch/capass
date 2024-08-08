loMiForm1 = CREATEOBJECT("MiForm1")
loMiForm1.SHOW(1)

DEFINE CLASS MiForm1 AS FORM
  AUTOCENTER = .T.
  CAPTION = "Ejemplo de botones Hot Tracking"
  NAME = "MiForm1"
  ICON =  HOME(4) + "icons\traffic\TRFFC05.ICO"

  ADD OBJECT cmd1 AS COMMANDBUTTON WITH ;
    TOP = 48, LEFT = 228, HEIGHT = 48, WIDTH = 48, ;
    PICTURE =  HOME(4) + "icons\traffic\TRFFC01.ICO", ;
    CAPTION = "", SPECIALEFFECT = 2, NAME = "cmd1"

  ADD OBJECT cmd2 AS COMMANDBUTTON WITH ;
    TOP = 48, LEFT = 84, HEIGHT = 48, WIDTH = 48, ;
    PICTURE =  HOME(4) + "icons\traffic\TRFFC02.ICO", ;
    CAPTION = "", SPECIALEFFECT = 2, NAME = "cmd2"

  ADD OBJECT cmd3 AS COMMANDBUTTON WITH ;
    TOP = 132, LEFT = 84, HEIGHT = 48, WIDTH = 48, ;
    PICTURE =  HOME(4) + "icons\traffic\TRFFC03.ICO", ;
    CAPTION = "", SPECIALEFFECT = 2, NAME = "cmd3"

  ADD OBJECT cmd4 AS COMMANDBUTTON WITH ;
    TOP = 132, LEFT = 228, HEIGHT = 48, WIDTH = 49, ;
    PICTURE =  HOME(4) + "icons\traffic\TRFFC04.ICO", ;
    CAPTION = "", SPECIALEFFECT = 2, NAME = "cmd4"

ENDDEFINE