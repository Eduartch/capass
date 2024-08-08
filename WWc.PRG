lcTexto = "Espere un momento ..." + CHR(13) + ;
  "generando el informe del día " + TRANSFORM(DATE()) + CHR(13) + ;
  "NADA CORRE COMO UN ZORRO"

? WaitWindowsCentrado()

? WaitWindowsCentrado(lcTexto,,5)

? WaitWindowsCentrado(lcTexto,"NOWAIT")

*------------------------------------------------------
* FUNCTION WaitWindowsCentrado(tcTexto, tcOpc, tnTimeout)
* - - - - - - - - - - - - - - - - - - - - - - - - - - -
* Muestra la ventana de WAIT WINDOWS centrada
* USO: WaitWindowsCentrado(tcTexto, tcOpc, tnTimeOut)
* EJEMPLO: WaitWindowsCentrado("Espere un momento...", "NOWAIT", 0)
* RETORNA: Caracter
* AUTOR: LMG
*------------------------------------------------------
FUNCTION WaitWindowsCentrado(tcTexto, tcOpc, tnTimeOut)

  LOCAL lnMaxLen, lnNroLin, lnRelFil, lnRelCol, ;
    lnRows_VFP, lnFil, lnCol, lcRet, lcCmd, ln, la(1)

  *-- Texto del mensaje
  IF EMPTY(tcTexto)
    tcTexto = "Presione una tecla para continuar..."
  ENDIF

  *-- Linea mas larga de tcTexto (si es multilinea)
  lnMaxLen = 0
  lnNroLin = ALINES(la, tcTexto)
  FOR ln = 1 TO lnNroLin
    lnMaxLen = MAX(lnMaxLen,LEN(la(ln)))
  ENDFOR

  *-- Filas de ventana completa _VFP, distinto a WROWS(_SCREEN.NAME)
  lnRows_VFP = _VFP.HEIGHT / FONTMETRIC(1,_SCREEN.FONTNAME,_SCREEN.FONTSIZE)

  *-- Relación entre el tamaño de las
  *-- fuentes de WAIT WINDOWS y _SCREEN
  lnRelFil = FONTMETRIC(1,'Arial',9) / FONTMETRIC(1,_SCREEN.FONTNAME,_SCREEN.FONTSIZE)
  lnRelCol = FONTMETRIC(6,'Arial',9) / FONTMETRIC(6,_SCREEN.FONTNAME,_SCREEN.FONTSIZE)
  lnFil = WLROW(_SCREEN.NAME) + (lnRows_VFP - lnNroLin * lnRelFil) / 2
  lnCol = WLCOL(_SCREEN.NAME) + (WCOLS(_SCREEN.NAME) - lnMaxLen * lnRelCol) / 2

  *-- Armo el Comando
  lcCmd = [WAIT WINDOWS tcTexto TO lcRet AT lnFil,lnCol]

  *-- Cláusulas NOWAIT y NOCLEAR
  IF NOT EMPTY(tcOpc) AND VARTYPE(tcOpc) = "C"
    IF "NOWA" $ UPPER(tcOpc)
      lcCmd = lcCmd + [ NOWAIT]
    ENDIF
    IF "NOCL" $ UPPER(tcOpc)
      lcCmd = lcCmd + [ NOCLEAR]
    ENDIF
  ENDIF

  *-- Cláusula TIMEOUT
  IF NOT EMPTY(tnTimeOut) AND VARTYPE(tnTimeOut) = "N"
    lcCmd = lcCmd + [ TIMEOUT tnTimeOut]
  ENDIF

  *-- Ejecuto el comando
  &lcCmd

  RETURN lcRet
ENDFUNC