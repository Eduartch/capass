LOCAL lcXLSBook AS STRING

lcXLSBook = GETFILE('xls, xlsx', 'Archivo:', 'Aceptar', 0, 'Seleccione una hoja de cálculo')
IF EMPTY(lcXLSBook)
  RETURN .F.
ENDIF

ExcelToCursor(m.lcXLSBook, "xlsResult")

SELECT xlsResult
BROWSE NOWAIT

*!------------------------------------------------------------------------------
*! Procedure : ExcelToCursor
*! Parametros: pcSrcFile -> Nombre del libro de excel
*!             pcCursorName -> Nombre del cursor
*!------------------------------------------------------------------------------
PROCEDURE ExcelToCursor(pcSrcFile AS STRING, pcCursorName AS STRING)
  IF PCOUNT() = 0
    RETURN .F.
  ELSE
    IF VARTYPE("pcSrcFile")#"C"
      RETURN .F.
    ENDIF

    IF !FILE(pcSrcFile)
      MESSAGEBOX("Archivo no encontrado", 16)
      RETURN .F.
    ENDIF

    IF VARTYPE("pcCursorName")#"C"
      RETURN .F.
    ENDIF
  ENDIF

  *** Instanciar MS Excel
  LOCAL oExcel AS Excel.APPLICATION
  m.oExcel = CREATEOBJECT("Excel.application")

  IF VARTYPE(oExcel,.T.)!='O'
    MESSAGEBOX("No se puede procesar el archivo." ;
      + CHR(13) + "Microsoft Excel no está instalado en su ordenador.", 16)
    m.oExcel = NULL
    RELEASE oExcel
    RETURN .F.
  ENDIF

  *** Abrir archivo de Excel
  m.oExcel.Workbooks.OPEN(pcSrcFile)
  m.oExcel.Worksheets(1).ACTIVATE
  m.oExcel.DisplayAlerts = .F.

  LOCAL oSheet AS OBJECT
  m.oSheet = m.oExcel.ActiveSheet

  LOCAL aExcel(1), laStructure(1)
  LOCAL lnCol, lnRow, lnSize, lcCol, lcRow, lcValue, lcCmd

  *** Redimensionar aExcel de acuerdo a las filas y columnas que
  *** contiene el libro de excel abierto
  IF EVALUATE("ALEN(aExcel)") # m.oSheet.UsedRange.COLUMNS.COUNT
    DIMENSION aExcel [1, m.oSheet.UsedRange.Columns.Count]
  ENDIF

  m.lnCol = m.oSheet.UsedRange.COLUMNS.COUNT
  m.lnRow = m.oSheet.UsedRange.ROWS.COUNT

  *** Pasar los valores del libro de excel
  *** a la matriz redimensionada aExcel
  TEXT TO lcCmd TEXTMERGE NOSHOW PRETEXT 1+2
  aExcel = m.oExcel.ActiveWorkbook.ActiveSheet.Range(m.oSheet.Cells(1,1), m.oSheet.Cells(<<m.lnRow>>,<<m.lnCol>>)).value
  ENDTEXT
  &lcCmd

  *** Cerrar la instancia MS Excel
  m.oExcel.QUIT()
  m.oExcel = NULL
  RELEASE oExcel, oSheet

  *** Procedimiento para determinar los tipo de datos por
  *** columnas y crear la estructura del cursor
  m.lnRow = ALEN(aExcel,1)
  m.lnCol = IIF(ALEN(aExcel,2)>0, ALEN(aExcel,2), 1)

  *** La matriz laStructure bidimensional
  *** almacena la estructura del cursor
  *** Columna 1 -> Nombre de la columna
  *** Columna 2 -> Tipo de datos
  *** Columna 3 -> Largo
  *** Columna 4 -> Decimal
  *** Columna 5 -> Acepta valores null
  DIMENSION laStructure(m.lnCol,5)

  FOR i = 1 TO m.lnCol
    m.lnSize = 1
    m.lcCol = LTRIM(STR(i))
    laStructure(i,1) = aExcel(1,i)
    laStructure(i,2) = VARTYPE(aExcel(2,i))
    DO CASE
      CASE laStructure(i,2) = "C" && Character, Memo, Varchar, Varchar (Binary)
        FOR j = 1 TO m.lnRow
          m.lcValue = IIF(m.lnCol = 1, TRANSFORM(aExcel(j)), TRANSFORM(aExcel(j,i)))
          m.lnSize = MAX(m.lnSize, LEN(TRANSFORM(aExcel(j,i))))
          IF AT(CHR(13), m.lcValue) > 0
            laStructure(i,2) = "M" && Memo
          ENDIF
        ENDFOR

        IF laStructure(i,2) = "C"  && Character, Varchar
          IF lnSize < 10
            laStructure(i,3) = 10
          ELSE
            laStructure(i,3) = lnSize
          ENDIF
          laStructure(i,4) = 0
        ELSE            && Memo, Blob
          laStructure(i,3) = 4
          laStructure(i,4) = 0
        ENDIF

      CASE laStructure(i,2) = "D" OR laStructure(i,2) = "T" && Date, DateTime
        laStructure(i,3) = 8
        laStructure(i,4) = 0

      CASE laStructure(i,2) = "L" && Logical
        laStructure(i,3) = 1
        laStructure(i,4) = 0

      CASE laStructure(i,2) = "N" && Numeric, Float, Double, o Integer
        laStructure(i,3) = 12
        laStructure(i,4) = 6

      OTHERWISE
    ENDCASE
    laStructure(i,5) = .T.
  ENDFOR

  *** Crear el cursor
  CREATE CURSOR &pcCursorName FROM ARRAY laStructure

  *** Insertar en el cursor los valores desde aExcel
  LOCAL lCellValue
  m.lcRow = ""

  FOR i = 1 TO m.lnRow
    FOR j = 1 TO m.lnCol
      IF !EMPTY(m.lcRow)
        m.lcRow = m.lcRow + ", "
      ENDIF

      lCellValue = EVALUATE([aExcel(i,j)])
      DO CASE
        CASE VARTYPE(lCellValue) = "C" && Character, Memo, Varchar, Varchar (Binary)
          IF !EMPTY(lCellValue) OR lCellValue # ""
            m.lcRow = m.lcRow + ['] + EVALUATE([aExcel(i,j)]) + [']
          ELSE
            m.lcRow = m.lcRow + [Null]
          ENDIF

        CASE VARTYPE(lCellValue) = "D" OR VARTYPE(lCellValue) = "T" && Date, DateTime
          m.lcRow = m.lcRow + [{] + EVALUATE([aExcel(i,j)]) + [}]

        CASE VARTYPE(lCellValue) = "N" && Numeric, Float, Double, o Integer
          m.lcRow = m.lcRow + ALLTRIM(STR(EVALUATE([aExcel(i,j)])))
        OTHERWISE
          m.lcRow = m.lcRow + EVALUATE([aExcel(i,j)])
      ENDCASE
    ENDFOR

    IF i > 1
      TEXT TO cSQL TEXTMERGE NOSHOW PRETEXT 1+2
       Insert Into <<pcCursorName>> Values (<<lcRow>>)
      ENDTEXT
      EXECSCRIPT(cSQL)
    ENDIF

    m.lcRow = ""
  ENDFOR

  *** Liberar variables
  RELEASE pcSrcFile, laStructure, lnSize, lcValue, lcCmd
  RELEASE lCellValue, aExcel, lnCol, lnRow, lcCol, lcRow, cSQL, i, j

  SELECT &pcCursorName
  GO TOP

  *** Retornar el cursor
  RETURN SETRESULTSET(pcCursorName)
ENDPROC