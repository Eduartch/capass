? OcxRegistrado("mscomctl2.monthview.2") && MontView
? OcxRegistrado("mscomctl2.dtpicker.2") && Date Time Picker
? OcxRegistrado("mscomctllib.treectrl.2") && Treeview
? OcxRegistrado("mschart20lib.mschart.2") && Ms Chart
? OcxRegistrado("mscommlib.mscomm.1") && MsComm
FUNCTION OcxRegistrado(cClase)
    Declare Integer RegOpenKey In Win32API ;
        Integer nHKey, String @cSubKey, Integer @nResult
    Declare Integer RegCloseKey In Win32API ;
        Integer nHKey
    nPos = 0
    lEsta = RegOpenKey(-2147483648, cClase, @nPos) = 0
 
    If lEsta
        RegCloseKey(nPos)
    Endif

    Return lEsta
Endfunc