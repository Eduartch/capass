CLEAR
PUBLIC tmrCheck
tmrCheck = NEWOBJECT("DetectActivity")
RETURN

DEFINE CLASS DetectActivity as Timer
  * Sólo detecta inactividad mientras está en este programa?
  JustInThisApp = .T.
  * Intervalo de inactividad tras el cual dispara OnInactivity (en segundos)
  InactivityInterval = 5
  * Intervalo cada el que chequea actividad
  Interval = 1000
  LastCursorPos = ""
  LastKeybState = ""
  LastActivity = DATETIME()
  CursorPos = ""
  KeybState = ""
  IgnoreNext = .T.

  PROCEDURE Init
    DECLARE INTEGER GetKeyboardState IN WIN32API STRING @ sStatus
    DECLARE INTEGER GetCursorPos IN WIN32API STRING @ sPos
    DECLARE INTEGER GetForegroundWindow IN WIN32API
  ENDPROC

  PROCEDURE Destroy
    CLEAR DLLS GetKeyboardState, GetCursorPos, GetForegroundWindow
  ENDPROC

  PROCEDURE Timer
    WITH This
      IF ! .CheckActivity()
        * Si no hubo actividad veo si es tiempo de disparar OnInactivity
        IF ! ISNULL(.LastActivity) AND ;
            DATETIME() - .LastActivity > .InactivityInterval
          .LastActivity = NULL && Prevengo disparo múltiple de OnInactivity
          .OnInactivity()
        ENDIF
      ENDIF
    ENDWITH
  ENDPROC

  * Chequeo si hay actividad
  PROCEDURE CheckActivity
    LOCAL lRet
    WITH This
      IF .JustInThisApp
        IF GetForegroundWindow() <> _VFP.hWnd
          * Estoy en otro programa
          RETURN lRet
        ENDIF
      ENDIF
      .GetCurState()
      IF (!.CursorPos == .LastCursorPos OR !.KeybState == .LastKeybState)
        IF ! .IgnoreNext && La 1ra vez no ejecuto
          lRet = .T. && Hubo actividad
          .OnActivity()
          .LastActivity = DATETIME()
        ELSE
          .IgnoreNext = .F.
        ENDIF
        .LastCursorPos = .CursorPos
        .LastKeybState = .KeybState
      ENDIF
    ENDWITH
    RETURN lRet
  ENDPROC

  * Devuelve el estado actual
  PROCEDURE GetCurState
    LOCAL sPos, sState
    WITH This
      sPos = SPACE(8)
      sState = SPACE(256)
      GetCursorPos (@sPos)
      GetKeyboardState (@sState)
      .CursorPos = sPos
      .KeybState = sState
    ENDWITH
  ENDPROC

  PROCEDURE OnInactivity
    WAIT WINDOW "Inactividad a las " + TIME() NOWAIT
  ENDPROC

  * Hubo actividad
  PROCEDURE OnActivity
    WAIT WINDOW "Actividad a las " + TIME() NOWAIT
  ENDPROC
ENDDEFINE





return

WITH NEWOBJECT("frmCheck")
    .Show(1)
ENDWITH

RETURN 


DEFINE CLASS frmCheck AS Form
    ADD OBJECT cmdOpenNewFormCheck AS CommandButton WITH Top = 180, Left = 50, Height = 60,;
        Caption = "Nuevo Form CON Chequeo de Inactividad", WordWrap = .T.
    ADD OBJECT cmdOpenNewFormNoCheck AS CommandButton WITH Top = 180, Left = 150, Height = 60,;
        Caption = "Nuevo Form SIN Chequeo de Inactividad", WordWrap = .T.
    ADD OBJECT cmdCloseForm AS CommandButton WITH Top = 180, Left = 250, Height = 60, Caption = "Cancelar", Cancel = .T.
    oSubForms = NULL


    PROCEDURE Init (lInactivityCheck)
    
    LOCAL nForms
    
    WITH ThisForm
        nForms = _Screen.FormCount
        .oSubForms = CREATEOBJECT("Collection")
        IF lInactivityCheck
            .AddObject("tmrActivity", "DetectActivity")        && Agrego el objeto de inactividad
        ENDIF
        .Caption = "Form " + TRANSFORM(nForms) + IIF(lInactivityCheck, " CON ", " SIN ") + "chequeo de inactividad"
        .Move (nForms * 20, nForms * 20)
    ENDWITH
    RETURN 
    
    
    * Abre un nuevo form con chequeo de inactividad
    PROCEDURE cmdOpenNewFormCheck.Click
    WITH ThisForm.oSubForms
        .Add(NEWOBJECT("frmCheck", "", "", .T.))
        .Item(.Count).Show()
    ENDWITH
    ENDPROC 


    * Abre un nuevo form sin chequeo de inactividad
    PROCEDURE cmdOpenNewFormNoCheck.Click
    WITH ThisForm.oSubForms
        .Add(NEWOBJECT("frmCheck"))
        .Item(.Count).Show()
    ENDWITH
    ENDPROC 


    PROCEDURE cmdCloseForm.Click
    ThisForm.Hide()
    ENDPROC 
ENDDEFINE 
EFINE CLASS DetectActivity as Timer
    JustInThisApp = .T.            && Sólo detecta inactividad mientras está en este programa?
    InactivityInterval = 5        && Intervalo de inactividad tras el cual dispara OnInactivity (en segundos)
    Interval = 1000                && Intervalo cada el que chequea actividad
    * Devuelve el estado actual
    PROCEDURE GetCurState
    
    LOCAL sPos, sState
    
    WITH This
        sPos = SPACE(8)
        sState = SPACE(256)
    
        GetCursorPos (@sPos)
        GetKeyboardState (@sState)
        
        .CursorPos = sPos
        .KeybState = sState
    ENDWITH
    ENDPROC 


    * Hubo InactivityInterval segundos de inactividad
    PROCEDURE OnInactivity
    
    WITH ThisForm
        .Cls()
        .Print("Inactividad a las " + TIME())
    ENDWITH

    
    ENDPROC 


    * Hubo actividad
    PROCEDURE OnActivity

    WITH ThisForm
        .Cls()
        .Print("Actividad a las " + TIME())
    ENDWITH

    ENDPROC 
ENDDEFINE 