* Walter Valle
* v1.0 - 13-SEP-2023
* NOTA: Probado en VFP9
*
* pcCursor   : Nombre del cursor a exportar.
* pcFile     : Nombre del archivo de Excel a generar.
* pcColTotals: Listado de columnas numéricas a totalizar, separado por comas.
*
* RETORNA un valor lógico (.T. / .F.)


SET PROCEDURE TO C2E ADDITIVE
RETURN


PROCEDURE _Copy2Excel
LPARAMETERS pcCursor, pcFile, pcColTotals
*
IF PCOUNT() < 2
  MESSAGEBOX('Error: Faltan al menos 2 de 3 parametros', 16, 'WV: _Copy2Excel')
  RETURN .F.
ENDIF
IF !USED(pcCursor)
  RETURN .F.
ENDIF
*
pcColTotals = IIF(EMPTY(pcColTotals) OR VARTYPE(pcColTotals) # 'C', '', UPPER(pcColTotals))
WAIT WINDOW NOCLEAR NOWAIT 'Espere, preparando Excel ...'
LOCAL oExcel, oMasterWorkBook, oSourceWorkBook, nTotal, nFields, nMaxRows, nNeededSheets, nCurrentSheetCount, ix, iy, ;
      cTempDBF, cTempFPT, cTMPDir, cFontName, nFontSize, cPage, nColTotals, lError
LOCAL ARRAY aFieldsList(1), aRangos(1)
*
cTMPDir   = 'C:\WV_TMPDir\'
cFontName = 'Calibri'
nFontSize = 9
*
TRY
  MD (cTMPDir)
CATCH
ENDTRY
IF !DIRECTORY(cTMPDir)
  MESSAGEBOX('Error: No se creó la carpeta temporal: ' + cTMPDir, 16, 'WV: _Copy2Excel')
  RETURN .F.
ENDIF
*
lError = .F.
TRY
  oExcel = CREATEOBJECT('Excel.application')
  nTotal = RECCOUNT(pcCursor)
  nFields = AFIELDS(aFieldsList, pcCursor)
CATCH TO oErr
  MESSAGEBOX('Error: ' + oErr.Message, 16, 'WV: _Copy2Excel')
  lError = .T.
ENDTRY
IF lError
  RETURN .F.
ENDIF
*
WITH oExcel
  .Visible = .F.
  oMasterWorkBook = .WorkBooks.Add
  nMaxRows = .ActiveWorkBook.ActiveSheet.Rows.Count
  nNeededSheets = CEILING(nTotal / (nMaxRows - 1))
  nCurrentSheetCount = .Sheets.Count
  IF nNeededSheets > nCurrentSheetCount
    .Sheets.Add(,.Sheets(nCurrentSheetCount), nNeededSheets - nCurrentSheetCount)
  ENDIF
ENDWITH
*
nColTotals = GETWORDCOUNT(pcColTotals, ',')
DIMENSION aRangos(nNeededSheets, 3)
*
WITH oMasterWorkBook
  FOR ix = 1 TO nNeededSheets
    cPage = 'H' + TRANSFORM(ix)
    .Sheets.Item(ix).Name = cPage
    aRangos(ix, 1) = cPage
  ENDFOR
  FOR ix = 1 TO nNeededSheets
    cTempDBF = cTMPDir + SYS(2015)
    cTempFPT = cTempDBF + '.FPT'
    cTempDBF = cTempDBF + '.DBF'
    WAIT WINDOW NOCLEAR NOWAIT 'Espere, enviando datos a Excel: H' + TRANSFORM(ix) + ' de ' + TRANSFORM(nNeededSheets)
    lnStart = (ix - 1) * (nMaxRows - 1) + 1
    COPY TO (cTempDBF) FOR BETWEEN(RECNO(), lnStart, lnStart + nMaxRows - 2) TYPE FOX2X AS 437
    aRangos(ix, 2) = lnStart
    aRangos(ix, 3) = _TALLY
    oSourceWorkBook = oExcel.WorkBooks.Open(cTempDBF)
    .WorkSheets(ix).Activate
    oSourceWorkBook.WorkSheets(1).UsedRange.Copy(.WorkSheets(ix).Range('A1'))
    oSourceWorkBook.Close(.F.)
    *
    ERASE (cTempDBF)
    IF FILE(cTempFPT)
      ERASE (cTempFPT)
    ENDIF
  ENDFOR
ENDWITH
*
WAIT WINDOW NOCLEAR NOWAIT 'Datos enviados a Excel. Dando formato y totalizando ...'
LOCAL ARRAY aFormulas(1)
LOCAL cCol, cCellFormula, cRangeFormula
STORE '' TO cCol, cCellFormula, cRangeFormula
IF nColTotals > 0
  DIMENSION aFormulas(nColTotals, 2)
ENDIF
*
WITH oExcel
  FOR ix = 1 TO nNeededSheets
    nColx = 1
    FOR iy = 1 TO nFields
      .Sheets(ix).Cells(1, iy).Value = aFieldsList(iy, 1)
      * Formulas para totales
      IF !EMPTY(pcColTotals) AND OCCURS('|' + aFieldsList(iy, 1) + '|', '|' + CHRTRAN(pcColTotals, ', ', '|') + '|') > 0
        cCol = _Columna(iy)
        aFormulas(nColx, 1) = cCol + TRANSFORM(aRangos(ix, 3) + 2)
        aFormulas(nColx, 2) = IIF(VARTYPE(aFormulas(nColx, 2)) # 'C', '', aFormulas(nColx, 2)) + ;
        .Sheets(ix).Name + '!' + cCol + '2:' + cCol + TRANSFORM(aRangos(ix, 3) + 1) + ','
        nColx = nColx + 1
      ENDIF
    ENDFOR
    * Todas las filas y columnas
    .Sheets(ix).Range(.Sheets(ix).Cells(1,1), .Sheets(ix).Cells(nMaxRows, nFields)).Font.Name = cFontName
    .Sheets(ix).Range(.Sheets(ix).Cells(1,1), .Sheets(ix).Cells(nMaxRows, nFields)).Font.Size = nFontSize
    * Estilo de los encabezados (Campos)
    .Sheets(ix).Range(.Sheets(ix).Cells(1,1), .Sheets(ix).Cells(1, nFields)).Font.Bold = .T.
    .Sheets(ix).Range(.Sheets(ix).Cells(1,1), .Sheets(ix).Cells(1, nFields)).Interior.ColorIndex = 45
    .Sheets(ix).Range(.Sheets(ix).Cells(1,1), .Sheets(ix).Cells(1, nFields)).Interior.Pattern = 1
    * Fijar encabezados
    oMasterWorkBook.WorkSheets(ix).Activate
    .Sheets(ix).Cells(2,1).Select
    .ActiveWindow.FreezePanes = .T.
    *
    .Sheets(ix).Columns.AutoFit
  ENDFOR
  * Totalizar
  IF nColTotals > 0
    FOR ix = 1 TO ALEN(aFormulas, 1)
      cCellFormula = aFormulas(ix, 1)
      cRangeFormula = aFormulas(ix, 2)
      cRangeFormula = SUBSTR(cRangeFormula, 1, LEN(cRangeFormula) - 1)
      .Sheets(nNeededSheets).Range(cCellFormula).Font.Bold = .T.
      .Sheets(nNeededSheets).Range(cCellFormula).Interior.ColorIndex = 15
      .Sheets(nNeededSheets).Range(cCellFormula).Interior.Pattern = 1
      .Sheets(nNeededSheets).Range(cCellFormula).Formula = "=SUM(&cRangeFormula.)"
      .Sheets(nNeededSheets).Columns.AutoFit
    ENDFOR
  ENDIF
  *
  WAIT WINDOW NOCLEAR NOWAIT 'Libro de Excel completo'
  oMasterWorkBook.WorkSheets(1).Activate
  .DisplayAlerts = .F.
  .ActiveWorkbook.SaveAs(pcFile)
  .QUIT
ENDWITH
*
oMasterWorkBook = NULL
oExcel = NULL
RELEASE oExcel, oMasterWorkBook
*
WAIT CLEAR
RETURN .T.


PROCEDURE _Columna
LPARAMETERS tn
*
LOCAL lc
lc = ""
DO WHILE tn > 26
  lc = CHR(IIF(MOD(tn, 26) = 0, 26, MOD(tn, 26)) + 64) + lc
  tn = INT((tn - 1) / 26)
ENDDO
lc = CHR(IIF(MOD(tn, 26) = 0, tn, MOD(tn, 26)) + 64) + lc
*
RETURN lc


PROCEDURE _OpenExcel
LPARAMETERS pcFile
*
DECLARE INTEGER ShellExecute IN Shell32.DLL INTEGER pcWin,STRING pcAction,STRING pcFileName,STRING pcPars,STRING pcDir,INTEGER pnShowWin
ShellExecute(0, 'Open', pcFile, '', '', 1)
*
CLEAR DLLS ShellExecute
