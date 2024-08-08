************************************************************************************************
Fontes com espaço fixo:


Andale Mono (True Type)
Arial Alternative (True Type)
Courier (W1)
Courier New (True Type)
Dixon Mono Thin (True Type)
Docu (True Type)
Fixedsys
FoxPro Window Font
Lucida Console (True Type)
Lucida Sans Typewriter (True Type)
Manuscript (True Type)
MS Mincho (True Type)
OCR A Extended (True Type)
Script12 BT (True Type)
SimSun (True Type)
Terminal
************************************************************************************************
************************************************************************************************
************************************************************************************************
************************************************************************************************
************************************************************************************************
************************************************************************************************
************************************************************************************************
************************************************************************************************
************************************************************************************************
************************************************************************************************
************************************************************************************************
************************************************************************************************
************************************************************************************************
* Un pequeño ejemplo de como utilizar la API de Google para generar códigos de barras de dos dimensiones de tipo QR:

lcDato =[?re=XAXX010101000%26rr=XAXX010101000%26tt=1234567890.123456] + ;
  [%26id=ad662d33-6934-459c-a128-BDf0393f0f44]
** Ancho x Alto
lcDimensiones = '300x300'
** Donde quieren guardar la imagen, ojo, es PNG
lcImagen = PUTFILE('QRCode','QRCode','png')

IF EMPTY(lcImagen)
  RETURN
ENDIF

IF GoogleQR(lcDato,lcDimensiones,lcImagen) == 0
  MESSAGEBOX('Descarga Exitosa',0+64,'GoogleQR')
ELSE
  MESSAGEBOX('Error en la generacion del Codigo QR',0+16,'GoogleQR')
ENDIF

FUNCTION GoogleQR(pDato,pDimensiones,pImagen)
  WAIT WINDOW "Generando y descargando Código QR, espere por favor..." NOWAIT
  DECLARE LONG URLDownloadToFile IN "urlmon";
    LONG pCaller,;
    STRING szURL,;
    STRING szFileName,;
    LONG dwReserved,;
    LONG lpfnCB
  sURL ="https://chart.googleapis.com/chart?cht=qr&chs=" + ;
    pDimensiones + "&chld=Q&chl=" + STRTRAN(pDato,'&','%26')
  nRetVal = URLDownloadToFile (0, sURL, pImagen, 0, 0)
  WAIT CLEAR
  RETURN nRetVal
ENDFUNC


************************************************************************************************
* Recuperar o nome do executavel associado a extensão do arquivo
#DEFINE MAX_PATH   260

DECLARE INTEGER FindExecutable IN Shell32 ;
  STRING lpFile, STRING lpDirectory, STRING @lpResult

* Extensión de archivo para buscar el programa asociado
lcFileExt = ".doc"

* Un archivo con la extensión especificada es necesario.
* Creamos un archivo temporal.
lcTempFile = ADDBS(SYS(2023)) + SYS(2015) + lcFileExt
STRTOFILE("*", lcTempFile )
lcBuffer = SPACE(MAX_PATH)
lnExeHandle= FindExecutable(lcTempFile, "", @lcBuffer)
DO CASE
  CASE lnExeHandle > 32
    lcExeName =  LEFT(lcBuffer, AT(CHR(0), lcBuffer)-1)
  CASE lnExeHandle= 31
    * No hay un programa asociado a esta extensión
    lcExeName = ""
    ? "No hay ninguna aplicación asociada para el tipo de archivo especificado"
  OTHERWISE
    * Algún otro error
    lcExeName = ""
    ? lnResult
ENDCASE

? lcExeName
ERASE (lcTempFile)
************************************************************************************************

*****SCRIPT DE BACKUP PARA POSTGRE
*--- Aquivo: BKP.BAT
@ echo off
for /f "tokens=1-4 delims=/ " %%i in ("%date%") do (
set dow=%%i
set day=%%j
set month=%%k
set year=%%l
)
set datestr=%year%_%month%_%day%_%dow%
echo Data de processamento do backip %datestr%

set BACKUP_FILE=C:\prov\SERGIO_%datestr%.backup
echo Nome do arquivo de backup %BACKUP_FILE%

SET PGPASSWORD=Maker@1
echo on
C:\"Program Files (x86)\Softwell Solutions\Maker 2.5\PostgreSQL\bin"\pg_dump -i -h localhost -p 5432 -U postgres -F c -b -v -f %BACKUP_FILE% carnabeirao

************************************************************************************************

Wait Window IsProcess("FireFox.exe")

CLEAR

Function IsProcess( lcProcess )
   If Pcount() = 0
      Messagebox("Falta Parâmetros...", 48, "Erro IsProcess()")
      Return .F.
   ENDIF

   oManager = Getobject("winmgmts:\\.\root\cimv2")
   oStuff = oManager.InstancesOf("Win32_process")
   isRunning = .F.
   For Each Process In oStuff
      If Upper( Process.Name ) = Upper( lcProcess )
         isRunning = .T.
         SET STEP ON 
         Process.Terminate
      ENDIF
      
   Next

   Return isRunning
Endfunc
************************************************************************************************
************************************************************************************************
* 3 formas de conexao com SQLSERVER





*------------------------------ 1a ADO (com record set)
oConn  = createobject('ADODB.Connection')
cConnString="Provider=SQLOLEDB.1;Persist Security Info=False;User ID="+ALLTRIM(lc_usuario_)+";Pwd="+ALLTRIM(lc_password)+";Initial Catalog="+ALLTRIM(lc_nombre)+";Data Source="+ALLTRIM(lc_sname)
oConn.Open(cConnString)
oRS = CREATEOBJECT("ADODB.Recordset")
oRS.ActiveConnection = oConn
oCA=CREATEOBJECT("CursorAdapter")
oCA.DataSourceType = "ADO"
oCA.DataSource = oRS
oCA.MapBinary = .T.
oCA.MapVarchar = .T.
oCA.SelectCmd = "select * from empleados"  && ejemplo
IF !oCA.CursorFill()
  LOCAL laError
  DIMENSION laError[1]
  AERROR(laError)
  MESSAGEBOX(laError[2])
ELSE
  ********** lo "capturo" en un cursor para manipularlo en modo local
  loAlias=ALIAS()
  cMacro1="SELECT * FROM "+loAlias+" INTO CURSOR "+ loCursor +" readwrite"
  &cMacro1
  WAIT windows "Procesado "+loCursor NOWAIT
ENDIF 



*------------------------------ 2a ODBC

lc_sql=SQLCONNECT("localdb","simio","fantasiA") && localdb tiene que estar creado en odbc solapa usuarios
if m.lc_con < 0
  nopc=MESSAGEBOX("No se pudo conectar , talvez ODBC no este configurado",0+48,"Error")
  RETURN .f.
endif 


*---------------------------------

lcStringConn="Driver={SQL Server}"+";Server="+lc_IPSQL+";Database="+lc_nombre+";Uid="+lc_usuario_+";Pwd="+lc_password
***Evitar que aparezca  la ventana de login 
SQLSETPROP(0,"DispLogin",3)
SQLSETPROP(0,"IdleTimeout",0)

lc_con=SQLSTRINGCONNECT(lcStringConn)
if m.lc_con < 0  &&  nose pudo conectar
  wait windows "no conecta"
endif 


************************************************************************************************
* Report a partir de um cursor

Close Databases All
Close Tables All
Select * From c:\desenv\win\vfp9\sca_new\banco Into Cursor CXXX
Use In (Select('TipoAtend'))
Select CXXX

cCursor = 'CXXX'
cTitulo = 'TESTE TESTE'


**************************************************************
* Autogeneracion de un listado (report rapido) partiendo de un
* cursor o tabla.
* Se autoajusta fuente, tamaño y nº de columnas a mostrar
*
* Parametros: cCursor --> Nombre del cursor/tabla origen
*                    cTitulo --> Titulo para el listado
*
* Ej: do autorepo with "micursor", "Titulo del Listado"
*
****************************************************************
* LPARAMETERS cCursor, cTitulo
*
Local cRepo, nLong, sFont, cFont, cCampos, nMaxCol, sExtra

cRepo = Sys(2015) + '.frx'
*
If Vartype(cCursor) # 'C'
   Wait Window "Faltan Datos"
Endif
If Vartype(cTitulo) # 'C'
   cTitulo = ''
Endif

cFont = 'Calibri'  && Fuente de letra a usar
nMaxCol = 225      && Nº máximo de columnas (depende de fuente)
nLong = 0
cCampos = ''

* Establecer anchura, limites y tamaño fuente
nCampos = Afields(aCampos, cCursor)
For xx = 1 To nCampos
   nLong = nLong + aCampos(xx, 3)
   If nLong > nMaxCol
      cTitulo = cTitulo + '    ***'
      Exit
   Else
      If Empty(cCampos)
         cCampos = cCampos + aCampos(xx,1)
      Else
         cCampos = cCampos + ', ' +aCampos(xx,1)
      Endif
   Endif
Endfor

* Ajusto tamaño de fuente depende long. datos
* 'sExtra' para ajustar campos (depende de ver. VFP)
Do Case
   Case nLong > 190
      sFont = 7
      sExtra = Iif(Version(5) / 100 = 9, 120, -320)

   Case nLong > 160
      sFont = 8
      sExtra = Iif(Version(5) / 100 = 9, 200, -170)

   Case nLong > 135
      sFont = 9
      sExtra = Iif(Version(5) / 100 = 9, 360, -110)

   Otherwise
      sFont = 10
      sExtra = Iif(Version(5) / 100 = 9, 450, 180)
Endcase

* Crear un report y pasar a realizar ajustes
Create Report (cRepo) From Dbf(cCursor) Fields &cCampos Column Width 256
*
Use (cRepo) In 0 Alias mirepor Excl
Select mirepor
*
* Cambiar texto 'Page' por 'Página' en caso de runtime en ingles
Replace Expr With ["Página "] For Alltrim(Expr) = ["Page "] In mirepor
*
* Cambiar la fuente para todos 'labels' y 'campos'
Replace All fontface With cFont For Inlist(objtype, 5, 8)

* Cambiar tamaño fuente y estilo para 'labels' encabezado columnas
Replace All FontSize With sFont, fontstyle With 3  For objtype=5 And Vpos=0 In mirepor

* Reducir tamaño fuente para todos 'campos'
Replace All FontSize With sFont - 1  For objtype = 8

* Cambiar tamaño fuente y estilo para 'labels' y 'campos' del pie de pagina
Replace FontSize With sFont - 1, fontstyle With 2 For Alltrim(Expr) = [DATE()] In mirepor
Replace FontSize With sFont - 1, fontstyle With 2 For Alltrim(Expr) = ["Página "] In mirepor
Replace FontSize With sFont - 1, fontstyle With 2 For Alltrim(Expr) = [_PAGENO] In mirepor
*
* Añadir línea separación en pie de pagina
Goto Top
Locate For Alltrim(mirepor.Expr) = [_PAGENO]
miW = mirepor.hpos + mirepor.Width + 100
miV = mirepor.Vpos -100
*
Append Blank In mirepor
Replace mirepor.objtype With 6
Replace mirepor.Vpos With miV
Replace mirepor.Width With miW
Replace mirepor.Height With 105
Replace mirepor.penpat With 8
Replace mirepor.supalways With .T.
Replace mirepor.platform With 'WINDOWS'
*
* Añadir línea separación en encabezado
Goto Top
Locate For mirepor.objtype=5 And mirepor.Vpos=0
*
miV = mirepor.Vpos + mirepor.Height
*
Append Blank In mirepor
Replace mirepor.objtype With 6
Replace mirepor.Vpos With miV
Replace mirepor.Width With miW
Replace mirepor.Height With 105
Replace mirepor.penpat With 8
Replace mirepor.supalways With .T.
Replace mirepor.platform With 'WINDOWS'
*
* Mover todo hacia abajo, para colocar titulo
If !Empty(cTitulo)
   *
   extra = 4000   && Altura para el titulo
   Goto Top
   Replace All Vpos With Vpos + extra For Inlist(objtype, 5, 6, 8) In mirepor
   Replace All Height With Height + extra For objcode = 1 In mirepor
   *
   * Añadir Titulo
   Append Blank In mirepor
   Replace mirepor.platform With 'WINDOWS'
   Replace mirepor.objtype With 5
   Replace mirepor.hpos With 100
   Replace mirepor.fontface With cFont
   Replace mirepor.fontstyle With 4
   Replace mirepor.FontSize With 16
   Replace mirepor.Width With 70000
   Replace mirepor.Height With 2800
   Replace mirepor.supalways With .T.
   Replace mirepor.Expr With ["&cTitulo"]
   Replace mirepor.mode With 1
   *
Endif
*
* Ajustar 'labels' columnas segun version VFP
Replace All mirepor.Vpos With mirepor.Vpos - sExtra For mirepor.objtype=5 And mirepor.Vpos = extra
*
Delete All For objtype = 26 In mirepor
Pack
*
Use In mirepor
*
* Mandar impresion
oForm = Createobject("Form")
With oForm
   .Caption = "Vista Previa "
   .WindowType = 1
   .Width = _Screen.Width - 16
   .Height = _Screen.Height - 16
   *
   Select &cCursor
   Goto Top
   Report Form (cRepo) Preview Window (.Name)
   Report Form (cRepo) To Printer Prompt Noconsole Noeject
   *
   .Release()
Endwith
*
* Borrar Report autogenerado
Delete File (Juststem(cRepo) + '.frx')
Delete File (Juststem(cRepo) + '.frt')
*
Return

************************************************************************************************
SABER SE PROGRAMA ESTA SENDO EXECUTADO A PARTIR DO EXE OU NO PROJETO

Código:
CODE
Código:
IF VERSION(2) = 0 && RunTime
   MESSAGEBOX("EXECUTÁVEL")
ELSE
   MESSAGEBOX("DESENVOLVIMENTO")
ENDIF
************************************************************************************************
*!*    Objet : Implémention en VisualFoxPro de l'algorithme de hachage SHA1
*!*    Auteur : C.Chenavier
*!*    Version : 1.00 - 15/11/2004
*!*    Les tests ont été réalisés avec le programme HashCalc : http://www.slavasoft.com

*!*    SHA signifie Secure Hash Algorithme et on utilise souvent le terme SHA-1,
*!*    pour noter la version.
*!*    SHA est une fonction de hachage qui produit des empreintes de 160 bits,
*!*    contrairement à MD5 qui produit des empreintes de 128 bits.
*!*    Cette fonction de hachage a été développée conjointement par la NSA et le NIST
*!*    pour être le standard des fonctions de hachage (FIPS PUB 180-1).
*!*    SHA est basé sur MD4 et est réputé plus sûr que MD5.
*!*    SHA fonctionne sur des messages dont la taille est inférieure à 2^64 bits
*!*    et travaille sur des blocs de 512 bits.

*!*    ---------- SHA-1 TEST SUITE ----------
*!*    SHA-1("")                    = da39a3ee5e6b4b0d3255bfef95601890afd80709, ok
*!*    SHA-1("a")                   = 86f7e437faa5a7fce15d1ddcb9eaeaea377667b8, ok
*!*    SHA-1("abc")                 = a9993e364706816aba3e25717850c26c9cd0d89d, ok
*!*    SHA-1("message digest")      = c12252ceda8be8994d5fa0290a47231c1d16aae3, ok
*!*    SHA-1(a..z)                  = 32d10c7b8cf96570ca04ce37f2a19d84240d3a89, ok
*!*    SHA-1(A..Za..z0..9)          = 761c457bf73b14d27e9e9265c46f4b4dda11f940, ok
*!*    SHA-1(8 times "1234567890")  = 50abf5706a150990a08b2c5ea40fa0e585554732, ok

*!*    Exemples de test :
*!*    MessageBox(SHA1("")="da39a3ee5e6b4b0d3255bfef95601890afd80709")
*!*    MessageBox(SHA1("a")="86f7e437faa5a7fce15d1ddcb9eaeaea377667b8")
*!*    MessageBox(SHA1("abc")="a9993e364706816aba3e25717850c26c9cd0d89d")
*!*    MessageBox(SHA1("message digest")="c12252ceda8be8994d5fa0290a47231c1d16aae3")
*!*    MessageBox(SHA1("abcdefghijklmnopqrstuvwxyz")="32d10c7b8cf96570ca04ce37f2a19d84240d3a89")
*!*    MessageBox(SHA1("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")="761c457bf73b14d27e9e9265c46f4b4dda11f940")
*!*    MessageBox(SHA1(REPLICATE("1234567890",8))="50abf5706a150990a08b2c5ea40fa0e585554732")
*!*    MessageBox(SHA1("ceci est un test")="71438dc237b45f04759c41e1b2d34f42a46318f3")

FUNCTION SHA1
LPARAMETERS cMessage

PRIVATE HO, H1, H2, H3, H4
LOCAL nNbBlocs, nHigh, nLow

H0 = 0x67452301
H1 = 0xEFCDAB89
H2 = 0x98BADCFE
H3 = 0x10325476
H4 = 0xC3D2E1F0

M.nNbBlocs = LEN(M.cMessage) / 64

** Si au départ, la taille du message n'est pas un multiple de 512,
** alors l'algorithme complète le message en ajoutant un 1 et
** autant de 0 que nécessaires et les 8 derniers octets servent
** à stocker la longueur du message.

M.nLen = LEN(M.cMessage)
M.nReste = MOD(M.nLen, 64)
IF M.nReste > 0 OR M.nLen = 0
   M.nNbBlocs = M.nNbBlocs + 1
   IF M.nReste > 55
      M.cMessage = M.cMessage + CHR(2^7) + REPLICATE(CHR(0), (64 - M.nReste) + 55)
      M.nNbBlocs = M.nNbBlocs + 1
   ELSE
      M.cMessage = M.cMessage + CHR(2^7) + REPLICATE(CHR(0), (55 - M.nReste))
   ENDIF
   M.nHigh = (M.nLen*8) / 2^32
   M.nLow = MOD(M.nLen*8, 2^32)
   M.cMessage = M.cMessage + CHR(BITAND(BITRSHIFT(M.nHigh, 24), 0xFF)) ;    && 56
                           + CHR(BITAND(BITRSHIFT(M.nHigh, 16), 0xFF)) ;    && 57
                           + CHR(BITAND(BITRSHIFT(M.nHigh, 8), 0xFF))  ;    && 58
                           + CHR(BITAND(M.nHigh, 0xFF)) ;                   && 59
                           + CHR(BITAND(BITRSHIFT(M.nLow, 24), 0xFF)) ;     && 60
                           + CHR(BITAND(BITRSHIFT(M.nLow, 16), 0xFF)) ;     && 61
                           + CHR(BITAND(BITRSHIFT(M.nLow, 8), 0xFF))  ;     && 62
                           + CHR(BITAND(M.nLow, 0xFF))                      && 63
ENDIF

FOR I = 1 TO M.nNbBlocs
    DO SHA1_ProcessBloc WITH SUBSTR(M.cMessage, 1 + 64*(I-1), 64)
ENDFOR

RETURN SUBSTR(TRANSFORM(H0,"@0"),3) + ;
       SUBSTR(TRANSFORM(H1,"@0"),3) + ;
       SUBSTR(TRANSFORM(H2,"@0"),3) + ;
       SUBSTR(TRANSFORM(H3,"@0"),3) + ;
       SUBSTR(TRANSFORM(H4,"@0"),3)




PROCEDURE SHA1_ProcessBloc
LPARAMETERS cBloc
LOCAL I, A, B, C, D, E, nTemp
LOCAL ARRAY W(80)


** Pour chaque bloc de 512 bits, on divise le bloc en 16 mots de 32 bits
** et on les affecte respectivement à W1, W2...W16.

FOR I = 1 TO 16
    W(I) = BITLSHIFT(ASC(SUBSTR(M.cBloc, (I-1) * 4 + 1, 1)), 24) + ;
           BITLSHIFT(ASC(SUBSTR(M.cBloc, (I-1) * 4 + 2, 1)), 16) + ;
           BITLSHIFT(ASC(SUBSTR(M.cBloc, (I-1) * 4 + 3, 1)), 8) + ;
           ASC(SUBSTR(M.cBloc, (I-1) * 4 + 4, 1))
ENDFOR

** Pour I variant de 17 à 80, on affecte les mots Wi de la manière suivante :
** Wi = Wi-3 XOR Wi-8 XOR Wi-14 XOR Wi-16

FOR I = 17 TO 80
    W(i) = BitLRotate(1, BITXOR(W(i-3), W(i-8), W(i-14), W(i-16)))
ENDFOR

A = H0
B = H1
C = H2
D = H3
E = H4

** Pour I variant de 1 à 80 et avec Sn un décalage circulaire gauche de n bits,
** on effectue les calculs suivants :

FOR I = 1 TO 20
    M.nTemp = BitLRotate(5,A) + BITOR(BITAND(B,C), BITAND(BITNOT(B), D)) + ;
              E + W(i) + 0x5A827999
    E = D
    D = C
    C = BitLRotate(30,B)
    B = A
    A = M.nTemp
ENDFOR

FOR I = 21 TO 40
    M.nTemp = BitLRotate(5,A) + BITXOR(B, C, D) + E + W(i) + 0x6ED9EBA1
    E = D
    D = C
    C = BitLRotate(30,B)
    B = A
    A = M.nTemp
ENDFOR

FOR I = 41 TO 60
    M.nTemp = BitLRotate(5,A) + BITOR(BITAND(B,C), BITAND(B,D), BITAND(C,D)) + ;
              E + W(i) + 0x8F1BBCDC
    E = D
    D = C
    C = BitLRotate(30,B)
    B = A
    A = M.nTemp
ENDFOR

FOR I = 61 TO 80
    M.nTemp = BitLRotate(5,A) + BITXOR(B, C, D) + E + W(i) + 0xCA62C1D6
    E = D
    D = C
    C = BitLRotate(30,B)
    B = A
    A = M.nTemp
ENDFOR

H0 = H0 + A
H1 = H1 + B
H2 = H2 + C
H3 = H3 + D
H4 = H4 + E

RETURN


FUNCTION BitLRotate
LPARAMETERS nBits, nWord
RETURN BITLSHIFT(M.nWord, M.nBits) + BITRSHIFT(M.nWord, (32-(M.nBits)))

************************************************************************************************
** Metodo para valida se determinados objertos estaao sem preencher
** Colocar um "*" na propriedade COMMENT dos objetos que deseja validar

LOCAL lnObjecto,lcContenido,lcNombre,lcFoco
FOR lnObjecto = 1 TO THISFORM.OBJECTS.COUNT
  IF THISFORM.OBJECTS(lnObjecto).COMMENT = "*"
    lcNombre = THISFORM.OBJECTS(lnObjecto).NAME
    lcContenido = "ThisForm." + lcNombre + ".Value"
    IF EMPTY(&lcContenido)
      MESSAGEBOX("Es necesario capturar el dato " + ;
        SUBSTR(lcNombre,4), 16, "No es posible")
      lcFoco = "ThisForm." + lcNombre + ".SetFocus"
      &lcFoco
      RETURN
    ENDIF
  ENDIF
ENDFOR

************************************************************************************************
* --- menu no botao...

* Menú en commandbutton
WITH NEWOBJECT("xForm")
  .SHOW(1)
ENDWITH
RETURN

DEFINE CLASS xForm AS FORM
  ADD OBJECT cmdMenu1 AS xCommandButton WITH ;
    CAPTION = "Menu 1", TOP = 10, LEFT = 10,;
    MenuOptions = "Opcion 1 . \<1,Opcion 1 . \<2,Opcion 1 . \<3"

  ADD OBJECT cmdMenu2 AS xCommandButton WITH ;
    CAPTION = "Menu 2", TOP = 10, LEFT = 120,;
    MenuOptions = "Opcion 2 . \<1,Opcion 2 . \<2"

  ADD OBJECT cmdClose AS xCommandButton WITH ;
    CANCEL = .T., CAPTION = "Cerrar", TOP = 10, LEFT = 240

  PROCEDURE cmdClose.CLICK
    THISFORM.HIDE()
  ENDPROC
ENDDEFINE

DEFINE CLASS xCommandButton AS COMMANDBUTTON
  HEIGHT = 25

  MenuOptions = ""

  PROCEDURE MOUSEMOVE (nButton, nShift, nXCoord, nYCoord)
    IF nButton==1 AND ! EMPTY(THIS.MenuOptions)
      THIS.ShowPopupMenu()
      NODEFAULT
    ENDIF
  ENDPROC

  PROCEDURE KEYPRESS(nKeyCode, nShiftCtrlAlt)
    #DEFINE K_DOWN   160
    #DEFINE K_ALT   4
    #DEFINE K_F4   -3

    * WAIT WINDOW TRANSFORM(nKeyCode) + " " + TRANSFORM(nShiftCtrlAlt) NOWAIT

    DO CASE
      CASE nKeyCode==K_DOWN AND nShiftCtrlAlt==K_ALT
        NODEFAULT
        THIS.ShowPopupMenu()
      CASE nKeyCode==K_F4
        NODEFAULT
        THIS.ShowPopupMenu()
    ENDCASE
  ENDPROC

  PROCEDURE CLICK
    NODEFAULT
    THIS.ShowPopupMenu()
  ENDPROC

  * Armo y muestro el menú
  PROCEDURE ShowPopupMenu()
    LOCAL nOp, sOp, nY, nX, nRatio

    TRY
      RELEASE POPUP _Popup_Menu
    CATCH
    ENDTRY

    WITH THIS
      THISFORM.ADDPROPERTY("ActivePopupMenu", THIS)

      * Convierto de pixels a foxels
      nRatio = FONTMETRIC(1)
      nY = (.TOP + .HEIGHT) / nRatio

      nRatio = FONTMETRIC(6)
      nX = .LEFT / nRatio

      DEFINE POPUP _Popup_Menu FROM nY, nX SHORTCUT

      FOR nOp = 1 TO GETWORDCOUNT(.MenuOptions, ",")
        sOp = GETWORDNUM(.MenuOptions, nOp, ",")
        DEFINE BAR (nOp) OF _Popup_Menu PROMPT (sOp)
        sOp = TRANSFORM(nOp)
        ON SELECTION BAR (nOp) OF _Popup_Menu _SCREEN.ACTIVEFORM.ActivePopupMenu.AfterClick( &sOp )
      NEXT
    ENDWITH

    ACTIVATE POPUP _Popup_Menu
  ENDPROC

  * Borro el menú luego del click y llamo al handler
  PROCEDURE AfterClick(nOption)
    THISFORM.ActivePopupMenu = NULL
    * RELEASE POPUP _Popup_Menu
    THIS.OnMenu (nOption)
    THISFORM.REFRESH()
  ENDPROC

  PROCEDURE OnMenu (nOption)
    WAIT WINDOW "Seleccionó opcion " + TRANSFORM(nOption) + " del botón " + PROPER(THIS.NAME) NOWAIT
  ENDPROC
ENDDEFINE

************************************************************************************************
*Autocompletar
PUBLIC oFrm

oFrm=NEWOBJECT("frm_autocompletar")

oFrm.SHOW

RETURN

DEFINE CLASS frm_autocompletar AS FORM
  AUTOSIZE = .T.
  HEIGHT = 236
  WIDTH = 447
  DOCREATE = .T.
  CAPTION = "Usando Autocompletar"
  MAXBUTTON = .F.
  MINBUTTON = .F.
  NAME = "frm_autoCompletar"

  ADD OBJECT txt1 AS Txt WITH ;
    TOP = 30, ;
    AutoComplete = 1, ;
    AutoCompSource = "txtDemo"



  ADD OBJECT txt2 AS Txt WITH ;
    TOP = 80, ;
    AutoComplete = 2, ;
    AutoCompSource = "txtDemo"



  ADD OBJECT txt3 AS Txt WITH ;
    TOP = 133, ;
    AutoComplete = 3, ;
    AutoCompSource = "txtDemo"



  ADD OBJECT txt4 AS Txt WITH ;
    LEFT = 23, ;
    TOP = 192, ;
    WIDTH = 169, ;
    AutoComplete = 4



  ADD OBJECT txt5 AS Txt WITH ;
    LEFT = 203, ;
    TOP = 190, ;
    WIDTH = 169, ;
    AutoComplete = 4



  ADD OBJECT lbl4 AS Lbl WITH ;
    CAPTION = "Ordenamiento Por codigo (AutoComplete = 4)", ;
    TOP = 170



  ADD OBJECT lbl3 AS Lbl WITH ;
    CAPTION = "Ordenamiento Por ultima vez usado (AutoComplete = 3)", ;
    TOP = 114



  ADD OBJECT lbl2 AS Lbl WITH ;
    CAPTION = "Ordenamiento Por mas usado (AutoComplete = 2)", ;
    TOP = 61



  ADD OBJECT lbl1 AS Lbl WITH ;
    CAPTION = "Ordenamiento Alfabetico (AutoComplete = 1)", ;
    TOP = 10



  PROCEDURE txt4.VALID

    IF DODEFAULT()

      UPDATE (THIS.AutocompTable) SET weight = 1 WHERE ALLTRIM(UPPER(SOURCE)) = ;

        IIF(EMPTY(THIS.AutocompSource),ALLTRIM(UPPER(THIS.NAME)),ALLTRIM(UPPER(THIS.AutocompSource)))

      UPDATE (THIS.AutocompTable) SET weight = 0 WHERE ALLTRIM(UPPER(DATA)) = ;

        ALLTRIM(UPPER(THIS.VALUE)) AND ALLTRIM(UPPER(SOURCE)) = ;

        IIF(EMPTY(THIS.AutocompSource),ALLTRIM(UPPER(THIS.NAME)),ALLTRIM(UPPER(THIS.AutocompSource)))

      USE IN (THIS.AutocompTable)

    ENDIF

  ENDPROC



  PROCEDURE txt5.VALID

    IF DODEFAULT()

      UPDATE (THIS.AutocompTable) SET weight = 0 WHERE ALLTRIM(UPPER(SOURCE)) = ;

        IIF(EMPTY(THIS.AutocompSource),ALLTRIM(UPPER(THIS.NAME)),ALLTRIM(UPPER(THIS.AutocompSource)))

      UPDATE (THIS.AutocompTable) SET weight = 1 WHERE ALLTRIM(UPPER(DATA)) = ;

        ALLTRIM(UPPER(THIS.VALUE)) AND ALLTRIM(UPPER(SOURCE)) = ;

        IIF(EMPTY(THIS.AutocompSource),ALLTRIM(UPPER(THIS.NAME)),ALLTRIM(UPPER(THIS.AutocompSource)))

      USE IN (THIS.AutocompTable)

    ENDIF

  ENDPROC

ENDDEFINE



DEFINE CLASS Lbl AS LABEL
  AUTOSIZE = .T.
  BACKSTYLE = 0
  LEFT = 24
ENDDEFINE



DEFINE CLASS Txt AS TEXTBOX
  HEIGHT = 25
  LEFT = 24
  WIDTH = 265
  AutocompTable = "AutoCompletar"
ENDDEFINE
************************************************************************************************
API Código para leer y/o escribir mediante WSH (Windows Script Host) la ruta de la carpeta de descarga del Internet Explorer.

*-- Para leer el nombre de la carpeta de descarga de Internet Explorer
loWsh = CreateObject("wscript.shell")
lcDir = loWsh.RegRead("HKCU\Software\Microsoft\Internet Explorer\Download directory")
loWsh = Null
? lcDir

*-- Para escribir el nombre de la carpeta de descarga de Internet Explorer
loWsh = CreateObject("wscript.shell")
lcDir = "C:\Windows"
loWsh.RegWrite("HKCU\Software\Microsoft\Internet Explorer\Download directory", lcDir)
loWsh = Null
************************************************************************************************

*** Pano de Fundo = ao papel de parede
LOCAL loForm, loWsh, lcWallpaper

loWsh = CreateObject("wscript.shell")
lcWallpaper = loWsh.RegRead("HKCU\Control Panel\Desktop\Wallpaper")
loWsh = Null

loForm = CREATEOBJECT("Form")
loForm.WIDTH = 800
loForm.HEIGHT = 600
loForm.AUTOCENTER = .T.
loForm.PICTURE = lcWallpaper
loForm.SHOW(1)
loForm = Null

RETURN

************************************************************************************************
Buscar incremental em COMBO
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
    CAPSLOCK(.F.)	&& simulo trabajar con minusculas
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
      CAPSLOCK(.T.)	&& Fuerzo a mayúsculas
    ENDIF
    _INCSEEK = 5.5	&& Tiempo busqueda incremental al maximo
    LOCAL cFile, cCampo
    cFile='customers'	&& Tabla de la que tomar los datos
    cCampo='upper(ltrim(companyname))'	&& campo a mostrar
    SELECT &cCampo AS cDato FROM &cFile DISTINCT WHERE !EMPTY(&cCampo) ;
      ORDER BY cDato INTO CURSOR curcombo nofilter
    THIS.ROWSOURCE = 'curcombo'	&& Establecemos origen de datos
    KEYBOARD '{ALT+DNARROW}'	&& Desplegamos lista
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

************************************************************************************************
TORPEDO:

Para OI:
ddd+numero@oitorpedo.com.br
Exemplo: 01692621212@oitorpedo.com.br

Para Claro:
ddd+numero@clarotorpedo.com.br


************************************************************************************************
http://www.xfrx.net/vfpWinsock/SendMailexemples_e.asp
http://www.4shared.com/file/123451622/832b7cac/VFPwinsock.html

Esta rotina funcionará em máquina que não têm o fox instalado, apenas se a seguinte chave estiver incluída no registro:

[HKEY_CLASSES_ROOT\Licenses\2c49f800-c2dd-11cf-9ad6-0080c7e7b78d]
@="mlrljgrlhltlngjlthrligklpkrhllglqlrk"

Send Mail : Examples
Sending email with Visual Foxpro

(in the downloaded version you can find a complete example as well: exemple.prg.)

Hello World with default mailer values and Dump file if problem

SET PROCEDURE TO VFPwinsock
o=CREATEOBJECT("VFP_Winsock_Send_Mail")
o.TO = "your_email@server.com"
o.Subject = "Hello World"
IF NOT o.send()
  ? "Erreur : " + o.Erreur
  MODIFY FILE o.Dump("c:\temp\dump.txt")
ENDIF
o=Null

Hello World

SET PROCEDURE TO VFPwinsock
o=CREATEOBJECT("VFP_Winsock_Send_Mail")
o.SMTP_HOST = "smtp.server.com"
o.FROM = "my_email@server.com"
o.TO = "your_email@server.com"
o.Subject = "Hello World"
o.Message = "Hello World..."
IF NOT o.send()
  ? "Error : " + o.Erreur
ENDIF
o=Null

Hello World 2

SET PROCEDURE TO VFPwinsock
o=CREATEOBJECT("VFP_Winsock_Send_Mail")
o.SMTP_HOST = "smtp.Server.com"
o.FROM = "my_email@server.com"
o.FROM_NAME = "My Name"
o.TO = "your_email@server.com, other_email@server.com"
o.cc = "copy_email@server.com"
o.cc_name = "Copye Name"
o.Subject = "Hello World"
o.Message = "Hello World..."
IF NOT o.send()
  ? "Error : " + o.Erreur
ENDIF
o=Null

Message with attachment

SET PROCEDURE TO VFPwinsock
o=CREATEOBJECT("VFP_Winsock_Send_Mail")
o.SMTP_HOST = "smtp.Server.com"
o.FROM = "my_email@server.com"
o.FROM_NAME = "My Name"
o.TO = "your_email@server.com"
o.Subject = "Hello World"
o.Message = "Attached..."
o.attachment = "c:\temp\fichier1.jpg, c:\temp\fichier2.jpg"
IF NOT o.send()
  ? "Error : " + o.Erreur
ENDIF
o=Null

Use of ESMTP (authentification for the sending email)
If the email server is not in open relay, an authentication is required: 

SET PROCEDURE TO VFPwinsock
o=CREATEOBJECT("VFP_Winsock_Send_Mail")
o.SMTP_HOST = "smtp.mail.yahoo.fr"
o.FROM = "my_email@domaine.com"
o.TO = "your_email@domaine.com"
o.Subject = "Hello World"
o.Message = "Test..."
o.Auth_Login = "login"
o.Auth_password = "password"
IF NOT o.send()
  ? "Error : " + o.Erreur
ENDIF
o=Null

Sending Email with a message body resulting from MHTML file generated by XFRX

SET PROCEDURE TO VFPwinsock
o=CREATEOBJECT("VFP_Winsock_Send_Mail")
o.SMTP_HOST = "smtp.Server.com"
o.FROM = "my_email@server.com"
o.TO = "your_email@server.com"
o.Subject = "MHTML"
o.data_mhtml = "c:\temp\myfile.mht"
IF NOT o.send()
? "Error : " + o.Erreur
ENDIF
o=Null

Combining the above examples: ESMTP + body MHTML generated by XFRX + Attachments

SET PROCEDURE TO VFPwinsock
o=CREATEOBJECT("VFP_Winsock_Send_Mail")
o.SMTP_HOST = "smtp.mail.yahoo.fr"
o.FROM = "my_email@yahoo.fr"
o.TO = "your_email@server.com"
o.Subject = "Great"
o.data_mhtml = "c:\temp\myfile.mht"
o.Auth_Login = "login"
o.Auth_password = "password"
o.attachment = "c:\temp\file1.jpg, c:\temp\file2.jpg"
IF NOT o.send()
? "Error : " + o.Erreur
ENDIF
o=Null

Authentificiation sur un serveur Radius

SET PROCEDURE TO VFPwinsock
loRadius_Access_Request = CREATEOBJECT("Radius_Access_Request")
WITH loRadius_Access_Request
  .RemoteHost = "192.168.6.70"
  .SharedSecret = "default"
  .Username = "test"
  .Password = "test"
   ? "Access_Request=", .Access_Request() && 2 = Acces-Accept
ENDWITH
loRadius_Access_Request=null
************************************************************************************************
*** Abrir, Modificar, Guardar e Imprimir archivos .doc usando OpenOffice Writer


local array laNoArgs[1]
local loSManager, loSDesktop, loStarDoc, loReflection, loPropertyValue, loOpenDoc, loCursor, loFandR

loSManager = createobject( "Com.Sun.Star.ServiceManager.1" )

loSDesktop = loSManager.createInstance( "com.sun.star.frame.Desktop" )
comarray( loSDesktop, 10 )

loReflection = loSManager.createInstance( "com.sun.star.reflection.CoreReflection" )
comarray( loReflection, 10 )

loPropertyValue = THISFORM.createStruct( @loReflection, "com.sun.star.beans.PropertyValue" )

laNoArgs[1] = loPropertyValue
laNoArgs[1].name = "ReadOnly"
laNoArgs[1].value = .F.

* crea un archivo nuevo ...
* url = "private:factory/swriter"

* Datos que vienen de la base de datos ...

lcTmp = "nombre del origen de datos"

lcNro_infor = PADL(&lcTmp..nro_infor, 8, '0')
lcDetalle   = &lcTmp..detalle
lcFecha     = DTOC(&lcTmp..fecha)

* Puede usar archivos en los 2 formatos: .odt y .doc
lcArchivoOrigen  = "C:/temp/modelo1.odt"
lcArchivoDestino = "C:/temp/eco" + lcNro_infor + " - " + ALLTRIM(lcDetalle) + ".odt"
*                   c:\temp\eco00112638 - 53565 diaz de rodriguez claudia.odt

lcArchivoOrigen  = "C:/temp/modelo1.doc"
lcArchivoDestino = "C:/temp/eco" + lcNro_infor + " - " + ALLTRIM(lcDetalle) + ".doc"
*                   c:\temp\eco00112638 - 53565 diaz de rodriguez claudia.doc

COPY FILE (lcArchivoOrigen) TO (lcArchivoDestino)

url = "file:///" + lcArchivoDestino

loOpenDoc = loSDesktop.LoadComponentFromUrl(url, "_blank", 0, @laNoargs)

* escribir texto en el documento ...
loCursor = loOpenDoc.text.CreateTextCursor()
loOpenDoc.text.InsertString(loCursor, "HELLO FROM VFP", .f. )

* Objeto para buscar las Marcas en el Documento
* si las marcas son encontradas, son remplazadas
* si alguna marca no existiera, no hay mayor problema, simplemente no se remplaza

loFandR = loOpenDoc.createReplaceDescriptor
loFandR.searchRegularExpression = .T.

loFandR.setSearchString("«nro_infor»")
loFandR.setReplaceString(lcNro_infor)
loOpenDoc.ReplaceAll(loFandR)

loFandR.setSearchString("«fecha»")
loFandR.setReplaceString(lcFecha)
loOpenDoc.ReplaceAll(loFandR)

loFandR.setSearchString("«detalle»")
loFandR.setReplaceString(lcDetalle)
loOpenDoc.ReplaceAll(loFandR)

* imprime el documento
* loOpenDoc.printer()

* graba el documento ...
* loOpenDoc.store()

* grabar con otro nombre ...
* Url = "file:///C:/temp/test3.odt"
* loStarDoc.storeAsURL(URL, @laNoargs)

RETURN

*--------- CreateStruct -----------*
PARAMETERS toReflection, tcTypeName

	local loPropertyValue, loTemp

	loPropertyValue = createobject( "relation" )

	toReflection.forName( tcTypeName ).createobject( @loPropertyValue )
    	
return ( loPropertyValue )

El CreateStruct, yo lo uso como un metodo del formulario ...

Marcelo ARDUSSO
Rafaela, Santa Fe. Argentina

* http://wiki.services.openoffice.org/wiki/Documentation/BASIC_Guide/StarDesktop
* http://user.services.openoffice.org/es/forum/viewtopic.php?f=50&t=1306

* vb_oo2.zip <- ejemplo en visual basic 
* Archivo descargado de La Web del Programador
* http://www.lawebdelprogramador.com

El siguiente es el archivo Modelo 1

Modelo 1
----------------------------------------------
Protocolo Nº «nro_infor»
Fecha «fecha»

Paciente: «detalle»

Estimado/a «detalle»

Esta es una prueba para generar informes en 
WRITER desde un programa de Visual Foxpro 9.0

Sin otro particular lo saludamos atte.

powered by: Visual Foxpro 9.0
************************************************************************************************
**** Importar  desde Excel
* Poner en Primera Fila los Nombres de Campo, los que se 
* chequearan que coincidan en la tabla
* Modificado por Ludwig Corales M.
* 28/08/2009
CLEAR
xArchivo="C:\temp\santa_maría.xls"
xTabla="Planos"  &&Tabla destino
IF USED("&xTabla")  &&Verifica que no este en uso la tabla
  SELECT("&xTabla")
  USE
ENDIF
USE &xTabla IN 0

*-- Creo el objeto Excel
loExcel = CREATEOBJECT("Excel.Application")
WITH loExcel.APPLICATION
  .VISIBLE = .F.
  *-- Abro la planilla con datos
  .Workbooks.OPEN("&xArchivo")
  *-- Cantidad de columnas
  lnCol = .ActiveSheet.UsedRange.COLUMNS.COUNT
  *-- Cantidad de filas
  * Se resta la Fila 1 donde estan los campos
  lnFil = .ActiveSheet.UsedRange.ROWS.COUNT-1
  *-- Recorro todas las celdas
  ** el Recorrido es columnas y luego filas
  FOR lnJ = 2 TO lnFil
    SELECT("&xTabla")
    APPEND BLANK   && se inserta el nuevo registro
    FOR lnI = 1 TO lnCol
      xCampo=.activesheet.cells(1,lnI).VALUE  && Nombre del campo destino
      xTipoCampo=TYPE(xCampo)  && se obtiene de la tabla el tipo de campo
      xValor=.activesheet.cells(lnJ,lnI).VALUE  && Recupera el valor de la Celda en Excel
      *? xcampo+": "  && Muestra el nombre de campo
      *?? xValor         && Muestra el valor
      DO CASE
        CASE xTipoCampo="D"  && si el campo es de fecha
          IF ISNULL(xValor)  &&Es fecha en blanco o nulo
            REPLACE &xCampo WITH CTOD("  /  /  ") IN &xTabla
          ELSE
            REPLACE &xCampo WITH TTOD(xValor) IN &xTabla
          ENDIF
        CASE xTipoCampo="C"
          IF VARTYPE(xValor)="N"  && por si en excel el valor no es TEXT
            REPLACE &xCampo WITH ALLTRIM(UPPER(STR(xValor))) IN &xTabla
          ELSE
            REPLACE &xCampo WITH xValor IN &xTabla
          ENDIF
        CASE xTipoCampo="N"
          IF ISNULL(xValor)
            REPLACE &xCampo WITH 0 IN &xTabla
          ELSE
            REPLACE &xCampo WITH xValor IN &xTabla
          ENDIF

      ENDCASE
    ENDFOR
  ENDFOR
  *-- Cierro la planilla
  .Workbooks.CLOSE
  *-- Salgo de Excel
  .QUIT
ENDWITH
RELEASE loExcel
SELECT("&xTabla")
BROWSE
**** Fin del Codigo
************************************************************************************************
* WAIT WINDOWS CENTRALIZADO
lcTexto = "Espere un momento ..." + CHR(13) + ;
  "generando el informe del día " + TRANSFORM(DATE()) + CHR(13) + ;
  "NADA CORRE COMO UN ZORRO"

? WaitWindowsCentrado(lcTexto,5)

FUNCTION WaitWindowsCentrado(tcTexto, tnTimeout)
  LOCAL lnMaxLen, lnNroLin, lnPorAncho, lnPorAlto, lnFila, lnColumna, lcRet

  *-- Convierto a texto si es necesario
  IF VARTYPE(tcTexto) <> "C"
    tcTexto = TRANSFORM(tcTexto)
  ENDIF

  *-- Tomo la linea mas larga si es multilinea
  lnMaxLen = 0
  lnNroLin = ALINES(la,tcTexto)
  FOR ln = 1 TO lnNroLin
    lnMaxLen = MAX(lnMaxLen,LEN(la(ln)))
  ENDFOR

  *-- Porcentaje entre el tamaño de las fuentes
  *-- del WAIT WINDOWS y _SCREEN
  lnPorAncho = FONTMETRIC(6,'Arial',9) / FONTMETRIC(6,_SCREEN.FONTNAME,_SCREEN.FONTSIZE)
  lnPorAlto = FONTMETRIC(1,'Arial',9) / FONTMETRIC(1,_SCREEN.FONTNAME,_SCREEN.FONTSIZE)
  lnFila = WLROW(_SCREEN.NAME) + 2 + (WROWS(_SCREEN.NAME) - lnNroLin * lnPorAlto) / 2
  lnColumna = WLCOL(_SCREEN.NAME) + (WCOLS(_SCREEN.NAME) - lnMaxLen * lnPorAncho) / 2

  IF VARTYPE(tnTimeout) <> "N"
    WAIT WINDOW tcTexto TO lcRet AT lnFila,lnColumna
  ELSE
    WAIT WINDOW tcTexto TO lcRet AT lnFila,lnColumna TIMEOUT tnTimeOut
  ENDIF
  RETURN lcRet
ENDFUNC
************************************************************************************************
Atualização de um campo de uma tabela com compos de outra tabela

update b  set CAMPO  =  a.CAMPO from TABELA_A a join TABELA_B b on a.chave=b.chave



************************************************************************************************
*-- correção automatica do MSWORD
PUBLIC oForm
oForm = createobject("claseCorrector")
oForm.show()

DEFINE CLASS claseCorrector AS form
    Autocenter = .T.
    Top = 0
    Left = 0
    Height = 220
    Width = 377
    DoCreate = .T.
    Caption = "Corrector ortográfico de WORD"
    Name = "Form1"

ADD OBJECT edit1 AS editbox WITH ;
    Height = 170, ;
    Left = 10, ;
    TabIndex = 2, ;
    Top = 10, ;
    Width = 358, ;
    ControlSource = "", ;
    Name = "Edit1"

ADD OBJECT command1 AS commandbutton WITH ;
    Top = 185, ;
    Left = 285, ;
    Height = 27, ;
    Width = 84, ;
    Caption = "Ortografía", ;
    TabIndex = 1, ;
    Name = "Command1"

PROCEDURE Init
  LOCAL cString
   cString = "La gran mayoria de programadores Visual FoxPro se recisten a dejar " + ;
             "de programar en este lenguaje porque consideran que es una herramienta " + ;
             "muy poderosa, versátil y robusta que les permite crear aplicaciones " + ;
             "tan poderosas y hasta más estables que las creadas por otros lenguajes. " + ;
             "Incluso programadores que han tenido la oportunidad de desarrollar tanto " + ;
             "en Visual Basic.NET y Visual FoxPro 9.0 coinciden que FoxPro es largamente " + ;
             "superior en cuanto a practicidad y flexibilidad al momento de programar."
   thisform.edit1.Value = cString
ENDPROC

**********************************************************************************
* para incluír en los fuentes de cualquier programa, solo copiar el código       *
* del siguiente procedimiento en el evento "Click" del boton llame al corrector. *
* IMPORTANTE: cambiar el nombre del control que tiene el texto a corregir!       *
**********************************************************************************
PROCEDURE command1.Click
   LOCAL loWord, lnOldMousePointer, loControl
   loControl = Thisform.Edit1    && control que tiene el texto a corregir.
   lnOldMousePointer = loControl.Mousepointer
   loControl.Mousepointer = 11
      WAIT WINDOW NOWAIT "Iniciando la Corrección Ortográfica..."+CHR(13)+;
                         " Espere por favor" TIMEOUT 3
      IF VARTYPE( loWord ) <> 'O'
         loWord = CREATEOBJECT('word.application')
      ENDIF
      IF VARTYPE ( loWord ) = "O"
         loWord.documents.ADD()
         WITH loWord
            .documents(1).content = loControl.VALUE
            .windowstate = 2    && ventana minimizada
            .visible = .T.
            .documents(1).CheckSpelling()  &&Comenzando Corrección Ortográfica...
            .SELECTION.WholeStory
            IF .selection.text <> loControl.VALUE
               loControl.VALUE = .SELECTION.TEXT  
               WAIT WINDOW NOWAIT "Corrección Ortográfica Finalizada..."+CHR(13)+;
                                  " El texto fue reemplazado" TIMEOUT 3             
            ELSE
               WAIT WINDOW NOWAIT "Corrección Ortográfica Finalizada..."+CHR(13)+;
                                  " No se encontraron errores" TIMEOUT 3
            ENDIF
            .documents(1).CLOSE(.F.)
            .QUIT
         ENDWITH
         loWord = .NULL.
         RELEASE loWord
      ELSE
         MESSAGEBOX("Lo siento, no se puedo iniciar Word",48,_SCREEN.CAPTION)
         loControl.Mousepointer = lnOldMousePointer
         RETURN .F.
      ENDIF
   loControl.Mousepointer = lnOldMousePointer
ENDPROC

ENDDEFINE


************************************************************************************************
* Rotina que determina se o usuario atual do windows é administradorador.

#DEFINE NO_ERROR 0
DECLARE INTEGER IsUserAnAdmin IN shell32
DECLARE INTEGER WNetGetUser IN mpr    INTEGER lpName, STRING @lpUserName, INTEGER @lpnLength

LOCAL lcUser, lnBufsize
lnBufsize = 250
lcUser = Repli(Chr(0), lnBufsize)

IF WNetGetUser(0, @lcUser, @lnBufsize) = NO_ERROR
    ? "Nome do Usuario:"+ SUBSTR(lcUser, 1, AT(Chr(0),lcUser)-1)
    ? "É administrador:"+ Iif(IsUserAnAdmin()=0, "Nao", "Sim")
ENDIF
************************************************************************************************
*---- EXEMPLO SYSTRAY
#DEFINE ccIcon  "C:\Desenv\Win\Icons\ATOM1.ICO"  && replace with valid ICO file name
 
PUBLIC objForm
objForm = CreateObject("Tform")
objForm.Visible = .T.
 
DEFINE CLASS Tform As Form
    Width=400
    Height=240
    MaxButton=.F.
    MinButton=.F.
    Autocenter=.T.
    Caption = " Using Systray icon and menu"
 
    ADD OBJECT cmdShowIcon As CommandButton WITH;
    Caption="Show Icon", Width=100, Height=27,;
    Left=20, Top=20
 
    ADD OBJECT cmdHideIcon As CommandButton WITH;
    Caption="Hide Icon", Width=100, Height=27,;
    Left=20, Top=56
 
    ADD OBJECT chPopup As CheckBox WITH;
    Caption=" Popup enabled", Value=.T.,;
    Left=240, Top=20, Autosize=.T., BackStyle=1
 
PROCEDURE Init
    THIS.AddTrayCtrl
 
PROCEDURE AddTrayCtrl
    LOCAL lErr
    ON ERROR lErr = .T.
    THIS.AddObject("FoxTray", "TFoxTray")
    ON ERROR
    IF lErr
        = MessageB("ActiveX control not registered   " + Chr(13) +;
            "or VB support not available.            " + Chr(13) + Chr(13) +;
            "Class: FoxTrayCtl.cFoxTray              " + Chr(13) +;
            "File: FoxTray.ocx   " + Chr(13) +;
            "VB support: msvbvm60.dll   ", 48, " FoxTray Control")
    ENDIF
 
PROCEDURE cmdShowIcon.Click
    WITH ThisForm.FoxTray
        .IconSource = ccIcon
        .ShowIcon
    ENDWITH
 
PROCEDURE cmdHideIcon.Click
    ThisForm.FoxTray.HideIcon
ENDDEFINE
 
DEFINE CLASS TFoxTray As OLEControl
    OleClass="FoxTrayCtl.cFoxTray"
 
PROCEDURE Init
    WITH THIS
        .IconSource = ccIcon
        .IconTip = "FoxPro App"
        .ShowIcon
 
        * setting popup items, max number = 5
        .GetPopupItem(1).Caption = "Settings"
        .GetPopupItem(2).Caption = "About"
        .GetPopupItem(3).Caption = "-"  && separator
        .GetPopupItem(4).Caption = "Close form"
        .GetPopupItem(5).Caption = "\Exit"  && item disabled
    ENDWITH
 
PROCEDURE BeforePopupActivate
PARAMETERS lResult
    lResult = ThisForm.chPopup.Value && .F. cancels popup activation
 
PROCEDURE OnPopupItemSelected
LPARAMETERS lnItem, lcCaption
    DO CASE
    CASE lnItem = 2
        = MessageB("System Tray Icon and Menu Control   ", 64, " About")
    CASE lnItem = 4
        ThisForm.Release
    CASE lnItem = 5
        IF MessageB("Exit FoxPro?   ", 32+4, " FoxTray Control") = 6
            QUIT
        ENDIF
    OTHER
        = MessageB("Popup item selected: " + LTRIM(STR(lnItem)) +;
            ", [" + lcCaption + "]")
    ENDCASE
ENDDEFINE

************************************************************************************************
* Gravar CD
declare integer GetUserName in advapi32 String@, Integer@
lcnomeusuario = replicate(chr(0),255) 
lres = getusername(@lcnomeusuario,255) 
if lres # 0 then 
userwin=left(lcnomeusuario,at(chr(0),lcnomeusuario)-1) 
endif 
DELETE FILE "c:\Documents and Settings\"+userwin+"\Configurações locais\Application Data\Microsoft\CD Burning\*.*" 
COPY FILE "c:\sistema\*.*" TO "c:\Documents and Settings\"+userwin+"\Configurações locais\Application Data\Microsoft\CD Burning" 
lcParam="c:\Documents and Settings\"+userwin+"\Configurações locais\Application Data\Microsoft\CD Burning\*.*" 
oShell = Createobject("wscript.shell") 
lnRet = oShell.Run(FULLPATH("CreateCD.exe") + " " + lcParam ,1, .T.) 

************************************************************************************************
 BuscarTag("Customers", "City")

*---------------------------------------------------
* FUNCTION BuscarTag(tcAlias, tcTag)
*---------------------------------------------------
* Busca el nombre de un tag en el alias de 
* una tabla abierta en un area de trabajo
* RETORNO: Lógico
*   .T. = Si el tag existe en la tabla
*   .F. = Si el tag no existe o el alias no existe 
*---------------------------------------------------
FUNCTION BuscarTag(tcAlias, tcTag)
  RETURN SELECT(tcAlias) > 0 AND ;
    ATAGINFO(laTag,"",SELECT(tcAlias)) > 0 AND ;
    ASCAN(laTag,tcTag,-1,-1,1,1) > 0
ENDFUNC
*---------------------------------------------------

************************************************************************************************
DEFINE NRO_COLUMNAS 10
#DEFINE NRO_CARTONES 1000

LOCAL lcLinea, lnCarton, lnNro, lnI
DIMENSION laLista(NRO_COLUMNAS)
RAND(-1)

*-- Creo la tabla para los cartones y lineas
CREATE CURSOR Bingo (Carton I, Linea c(NRO_COLUMNAS*3))
INDEX ON Linea TAG Linea ADDITIVE

lnCarton = 0
DO WHILE lnCarton < NRO_CARTONES
  *-- Inicio vector linea
  laLista = 0
  FOR lnI = 1 TO NRO_COLUMNAS
    DO WHILE .T.
      lnNro = CEILING(RAND()*90)
      *-- compruebo que no exista el Nro
      IF ASCAN(laLista, lnNro) = 0
        EXIT
      ENDIF
    ENDDO
    laLista(lnI) = lnNro
  ENDFOR
  *-- Ordeno el vector
  ASORT(laLista)
  lcLinea = ""
  FOR lnI = 1 TO 10
    lcLinea = lcLinea + TRANSFORM(laLista(lnI), "@L 99") + IIF(lnI = 10, "", "-")
  ENDFOR
  *-- Inserto el carton si la linea no existe
  IF NOT SEEK(lcLinea, "Bingo", "Linea")
    lnCarton = lnCarton + 1
    INSERT INTO Bingo (Carton, Linea) VALUES (lnCarton, lcLinea)
  ENDIF
ENDDO

*-- Miro los resultados
SELECT "Bingo"
SET ORDER TO
GO TOP
BROWSE

************************************************************************************************
 *** Define Special Folder Constants
   #define CSIDL_PROGRAMS                 2   &&Program Groups Folder
   #define CSIDL_PERSONAL                 5   &&Personal Documents Folder
   #define CSIDL_FAVORITES                6   &&Favorites Folder
   #define CSIDL_STARTUP                  7   &&Startup Group Folder
   #define CSIDL_RECENT                   8   &&Recently Used Documents
                                              &&Folder
   #define CSIDL_SENDTO                   9   &&Send To Folder
   #define CSIDL_STARTMENU                11  &&Start Menu Folder
   #define CSIDL_DESKTOPDIRECTORY         16  &&Desktop Folder
   #define CSIDL_NETHOOD                  19  &&Network Neighborhood Folder
   #define CSIDL_TEMPLATES                21  &&Document Templates Folder
   #define CSIDL_COMMON_STARTMENU         22  &&Common Start Menu Folder
   #define CSIDL_COMMON_PROGRAMS          23  &&Common Program Groups
                                              &&Folder
   #define CSIDL_COMMON_STARTUP           24  &&Common Startup Group Folder
   #define CSIDL_COMMON_DESKTOPDIRECTORY  25  &&Common Desktop Folder
   #define CSIDL_APPDATA                  26  &&Application Data Folder
   #define CSIDL_PRINTHOOD                27  &&Printers Folder
   #define CSIDL_COMMON_FAVORITES         31  &&Common Favorites Folder
   #define CSIDL_INTERNET_CACHE           32  &&Temp. Internet Files Folder
   #define CSIDL_COOKIES                  33  &&Cookies Folder
   #define CSIDL_HISTORY                  34  &&History Folder

   *** Initialize variables
   cSpecialFolderPath = space(255)

   *** Declare API's
   DECLARE SHGetSpecialFolderPath IN SHELL32.DLL ;
      LONG hwndOwner, ;
      STRING @cSpecialFolderPath, ;
      LONG  nWhichFolder

   *** Get Special Folder Path
   SHGetSpecialFolderPath(0, @cSpecialFolderPath, CSIDL_DESKTOPDIRECTORY)

   *** Format Special Folder Path
   cSpecialFolderPath=SubStr(RTrim(cSpecialFolderPath),1, ;
                      Len(RTrim(cSpecialFolderPath))-1)

   *** Display Special Folder Path
   WAIT WINDOW cSpecialFolderPath
						
************************************************************************************************
Com estas funcoes podemos controlar um SERVICO se esta sendo executado no windows
Tomamos como ejemplo el servicio Themes de Windows XP.

*** 1. Consultar si el servicio Themes se esta ejecutando:
oShell = CREATEOBJECT("Shell.Application") 
? oShell.IsServiceRunning("Themes") 
oShell = Null

*** 2. Consultar si se puede iniciar o detener el servicio Themes:
oShell = CREATEOBJECT("Shell.Application") 
? oShell.CanStartStopService("Themes")
oShell = Null

*** 3. Iniciar el servicio Themes:
oShell = CREATEOBJECT("Shell.Application") 
? oShell.ServiceStart("Themes", .F.) 
oShell = Null

*** 4. Detener el servicio Themes:
oShell = CREATEOBJECT("Shell.Application") 
? oShell.ServiceStop("Themes", .T.) 
oShell = Null

************************************************************************************************
*Criando ZIP com o SHELL do windows XP & VISTA
***************************************************************
* COMPRIMIRENZIP.PRG
* Se encarga de comprimir en un archivo zip varias extensiones de Archivos
* utilizando el Shell de Windows - probado en XP
* FECHA : 19 MARZO 2008
* HECHO POR : ROTEROL (Rubén V. Otero L.)
* La Coruña, España
****************************************************************

LOCAL lcExtension, lcZip && Variables locales tipo Caracter
LOCAL lnArchivos, lnContArray, lnContArrayDef && Variables locales tipo Numérico
LOCAL loZip, loShell, loFolder && Variables locales tipo Objeto
LOCAL ARRAY laArchivos[1,1], laArcDef[1], laExtensiones[6] && Variables locales tipo Array

*!* Verifico todos los ficheros a comprimir y los guardo en un array único laArcDef
*!* No puedo hacer una sola instrucción adir con todas las extensiones de archivos, con lo cual,
*!* ejecuto tantos adir como sea necesario para almacenar los
*!* *.dbc, *.dct, *.dcx, *.dbf, *.fpt y *.cdx
laExtensiones[1] = "*.dbc"
laExtensiones[2] = "*.dcx"
laExtensiones[3] = "*.dct"
laExtensiones[4] = "*.dbf"
laExtensiones[5] = "*.fpt"
laExtensiones[6] = "*.cdx"
FOR EACH lcExtension IN laExtensiones
  lnArchivos = ADIR(laArchivos,lcExtension)
  *!* Dependiendo si es la primera vez que paso por el For Each, declaro el array laArcDef con el
  *!* número de Archivos resultantes del Adir, Si no es la primera vez que paso por el For Each,
  *!* incremento el número de elementos de laArcDef en la longitud que tiene actualmente
  *!* mas el número de archivos resultantes del adir
  IF lcExtension=laExtensiones[1]
    lnContArrayDef = 0
    DECLARE laArcDef[lnArchivos]
  ELSE
    lnContArrayDef = ALEN(laArcDef)
    DECLARE laArcDef[ALEN(laArcDef)+lnArchivos]
  ENDIF
  FOR lnContArray = 1 TO lnArchivos
    lnContArrayDef = lnContArrayDef + 1
    laArcDef[lnContArrayDef] = ADDBS(FULLPATH(CURDIR()))+laArchivos[lnContArray,1]
  NEXT
NEXT

lcZip = ADDBS(FULLPATH(CURDIR()))+'ArchivoComprimido.zip'
IF FILE(lcZip) && Borro Zip si existe
  ERASE lcZip
ENDIF

*!* Creo Fichero Encabezado de zip
STRTOFILE(CHR(0x50)+CHR(0x4B)+CHR(0x05)+CHR(0x06)+REPLICATE(CHR(0),18),lcZip)

oShell = CREATEOBJECT("Shell.Application")

IF TYPE('oShell')='O'
  *!* Según Investigué, Microsoft recomienda crear el Objeto oFolder y trabajar con ese objeto
  *!* para hacer la instrucción copyHere intenté hacerlo directamente
  *!* -oShell.NameSpace("&lcZip").copyHere(laArcDef[lnContArray])-, pero recibía contínuos errores de
  *!* fallo de aplicación VFP. asimismo, tuve que crear el objeto oFolder con la macrosubstitución
  *!* -oShell.NameSpace("&lcZip")- por que tambien, depurando el programa, detecté que no se
  *!* creaba el objeto oFolder colocando la instrucción -oShell.NameSpace("&lcZip")- directamente
  oFolder = oShell.NameSpace("&lcZip")
  IF TYPE('oFolder')='O'
    FOR lnContArray = 1 TO lnContArrayDef && ALEN(laArcDef)
      WAIT 'Procesando Archivo '+LOWER(laArcDef[lnContArray])+', '+;
        ALLTRIM(STR(lnContArray*100/lncontArrayDef))+'%' WINDOW NOWAIT
      oFolder.CopyHere(laArcDef[lnContArray])
      *!* Me veo obligado tambien a colocarle un inkey por que si no se pone y por ejemplo
      *!* tenemos 48 archivos para comprimir (como es mi caso), el proceso lo efectúa muy rapido,
      *!* y aún cuando sale del for...next, se crean tantos shell de Fox
      *!* como archivos haya, con el dialogbox de "Comprimiendo..."
      INKEY(0.5)
    NEXT
    WAIT CLEAR
    oFolder = .F.
  ELSE
    MESSAGEBOX('No pudo crearse el Objeto oFolder',16)
  ENDIF
  oShell = .F.
ELSE
  MESSAGEBOX('No pudo crearse el Objeto Shell',16)
ENDIF
************************************************************************************************
Declare Long GetParent in Win32API Long
Declare Long EnableWindow in Win32API Long, Long
EnableWindow(GetParent(oleControl.Hwnd), 1)
************************************************************************************************
Resultado de um REPORT em .BMP


Local oListener As ReportListener, nPageIndex
oListener = Createobject("ReportListener")
oListener.ListenerType = 3

cRutaReporte = Home(2)+"Solution:\Reports:\invoice.frx"

Report Form (cRutaReporte) Preview Object oListener

For nPageIndex=1 To oListener.PageTotal
    cOutputFile = "c:\tmp"+Trans(nPageIndex)+".bmp"
    oListener.OutputPage(nPageIndex,;
    cOutputFile, 105, 0,0,768,1024) && 105=bitmap
NextSaludos.

************************************************************************************************
* Gera chave GUID

? GUIDGen(2)
FUNCTION GUIDGen
   LPARAMETERS tn_mode as Integer

   LOCAL ;
      lc_guid_return as String, ;
      lc_buffer as String, ;
      ln_result as Integer, ;
      lc_GUID as String

   DECLARE Integer CoCreateGuid ;
      IN ole32.dll ;
      String@ pguid

   lc_GUID = SPACE(16) && 16 Byte = 128 Bit
   ln_result = CoCreateGuid(@lc_GUID)

   IF tn_mode = 0
      lc_guid_return = lc_GUID
   ELSE
      lc_buffer = SPACE(78)

      DECLARE Integer StringFromGUID2 ;
          IN ole32.dll ;
          String  pguid, ;
          String  @lpszBuffer, ;
          Integer cbBuffer

      ln_result = StringFromGUID2(lc_GUID,@lc_buffer,LEN(lc_buffer)/2)
      lc_guid_return = STRCONV((LEFT(lc_buffer,(ln_result-1)*2)),6)
   ENDIF


   RETURN lc_guid_return
ENDFUNC

************************************************************************************************
*Validacao de Cartao de Credito
LPARAMETERS tcCCnumber, tcCCtype, tcError
LOCAL lcCCnumber, lnCClen, llCCok, lcCCtype, lcError, lnSum, lnTemp, lvRet

lcCCnumber = ALLTRIM(tcCCnumber)
lnCClen = LEN(lcCCnumber)

llCCok = EMPTY( CHRTRAN(lcCCNumber, "0123456789", "") )

lcCCtype = "UNKNOWN"
lcError = ""

DO CASE
CASE NOT llCCok
	* CC # is already invalid
	lcError = "NON-DIGIT"
CASE lnCClen = 16
	DO CASE
	CASE BETWEEN( LEFT(lcCCnumber,2) , "51", "55")
		lcCCtype = "MASTERCARD"
	CASE lcCCnumber = "4"
		lcCCtype = "VISA"
	CASE lcCCnumber = "6011"
		lcCCtype = "DISCOVER"
	CASE lcCCnumber = "3"
		lcCCtype = "JCB"
	OTHERWISE	
		llCCok = .F.
		lcError = "INCORRECT LEN"
	ENDCASE	
CASE lnCClen = 15
	DO CASE
	CASE INLIST( LEFT(lcCCnumber,2) , "34", "37")
		lcCCtype = "AMEX"
	CASE INLIST( LEFT(lcCCnumber,4) , "2131", "1800")
		lcCCtype = "JCB"
	OTHERWISE	
		llCCok = .F.
		lcError = "INCORRECT LEN"
	ENDCASE	
CASE lnCClen = 14
	DO CASE
	CASE BETWEEN( LEFT(lcCCnumber,3) , "300", "305") OR ;
		INLIST( LEFT(lcCCnumber,2) , "36", "38")
		lcCCtype = "DINERS CLUB"
	OTHERWISE	
		llCCok = .F.
		lcError = "INCORRECT LEN"
	ENDCASE	
CASE lnCClen = 13
	DO CASE
	CASE lcCCnumber = "4"
		lcCCtype = "VISA"
	OTHERWISE	
		llCCok = .F.
		lcError = "INCORRECT LEN"
	ENDCASE	
OTHERWISE	
	llCCok = .F.
	lcError = "INCORRECT TYPE"
ENDCASE

* Now verify control digits

IF llCCok
	lnSum = 0

	FOR lnI =  1 TO lnCClen
		lnTemp = VAL( SUBSTR( lcCCnumber, lnCClen - lnI + 1,1)) 
		IF (lnI % 2) = 0
			lnTemp = lnTemp * 2
		ENDIF
		IF lnTemp > 9
			lnTemp = lnTemp - 9
		ENDIF
	*? lnI, "temp", lntemp
		lnSum = lnSum + lnTemp
	ENDFOR
	llCCok = ( lnSum % 10 = 0)	
	IF NOT llCCok
		lcError = "CONTROL DIGIT"	
	ENDIF
	*? lnSum
ENDIF

DO CASE
CASE PCOUNT() = 1
	lvRet = llCCok
CASE tcCCtype = "TYPE"
	lvRet = lcCCtype 
CASE tcCCtype = "ERROR"
	lvRet = lcError
CASE tcCCtype = "CD"
	lvRet = lnSum
OTHERWISE
	lvRet = llCCok
ENDCASE

IF PCOUNT() > 1
	tcCCtype = lcCCtype
ENDIF	

IF PCOUNT() > 2
	tcError  = lcError
ENDIF	

RETURN lvRet 
********************************************************

#IF .F.

Tabela dos cartões de crédito:

CARD TYPE	Prefixo	Tamanho
MASTERCARD 	51-55 	16  
VISA 		4 	13, 16  
AMEX 		34,37 	15  
Diners Club	300-305	14
		36, 38 	14 
Discover 	6011 	16  
JCB 		3 	16 
    		2131	15
		1800 	15  

2. Formula LUHN (Mod 10) para validação:

Passo 1: Dobre o valor alternando os dígitos começando a partir do segundo da direita
Passo 2: Adicione cada dígito individual incluindo os resultados obtidos no passo 1
Passo 3: O total obtido no passo 2 deve ser um número com final 0 (30, 40, 50, etc.)

Por exemplo, para validar o número 49927398716:

	Step 1: 

    4 9 9 2 7 3 9 8 7 1 6
      x2  x2  x2  x2  x2 
    ------------------------------
      18   4   6  16   2

Step 2: 4 +(1+8)+ 9 + (4) + 7 + (6) + 9 +(1+6) + 7 + (2) + 6 

Passo 3: Soma = 70 : Número do cartão de crédito é válido.

#ENDIF
Não me lembro de qual website eu peguei esta informação, mas existe uma página similar em http://www.beachnet.com/~hstiles/cardtype.html 


************************************************************************************************

Estou utilizando o SQL Server 2005. É possível começar a mostrar um cursor na grade enquanto o restante dele ainda está sendo recuperado do SQL Server?
=SQLSETPROP(g_connection,'BatchMode', .T.)
=SQLSETPROP(g_connection,'Asynchronous', .t.)
USE IN gridRecordSource

LOCAL nresult
nresult= SQLEXEC(g_connection,"select * from cases ","gridRecordSource")

DO WHILE nresult=0 AND ! USED("gridRecordSource")
        nresult= SQLEXEC(g_connection)
enddo
IF nresult<0
	MESSAGEBOX("Error in SQLEXEC",48,"Jaguar Alert")
	RETURN .f.
ENDIF
RELEASE nresult
=CursorSetProp("FetchSize",50,"gridRecordSource")

************************************************************************************************
* Abrir PDF com o VFP 

PUBLIC oform1

oForm1=NEWOBJECT("form1")
oForm1.Show()
RETURN

DEFINE CLASS form1 AS form

  Autocenter = .T.
  Height = 520
  Width = 741
  Caption = "Visualisation de PDF"
  ShowWindow = 2
  Name = "Form1"
  cPdfFileName = "=SPACE(0)"

  ADD OBJECT txtpdfname AS textbox WITH ;
    Top = 471, Left = 108, Height = 23, Width = 492, anchor = 14, ;
    ReadOnly = .T., Name = "txtPdfName"

  ADD OBJECT command1 AS commandbutton WITH ;
    Top = 469, Left = 623, Height = 27, Width = 84,anchor = 12, ;
    Caption = "PDF ...", Name = "Command1"

  ADD OBJECT owb AS olecontrol WITH ;
    Top = 24, Left = 12, Height = 433, Width = 709, Anchor = 15, ;
    OleClass = "Shell.Explorer.2", Name = "oWB"

  ADD OBJECT label1 AS label WITH ;
    Height = 17, Left = 36, Top = 474, Width = 63, anchor= 6,;
    Caption = "Nom PDF :", Name = "Label1"

  PROCEDURE Refresh
    && Requis pour VFP8 et permet de contourner une erreur
    NODEFAULT
  ENDPROC

  PROCEDURE ShowPdf
    && Affichage de page blanche dans le WebControl
    Thisform.oWB.OBJECT.Navigate2("About:Blank")
    && Attendre que le chargement soit complet
    lnSeconds = SECONDS()
    DO WHILE Thisform.oWB.OBJECT.Busy AND SECONDS() - lnSeconds < 60
      DOEVENTS
    ENDDO

    && Charger PDF
    Thisform.oWB.OBJECT.Navigate2(Thisform.cPdfFileName)
    && Attendre que le chargement soit complet
    lnSeconds = SECONDS()
    DO WHILE Thisform.oWB.OBJECT.Busy AND SECONDS() - lnSeconds < 60
      DOEVENTS
    ENDDO
  ENDPROC

  PROCEDURE command1.Click
    && Ouvrir PDF
    Thisform.cPdfFileName = GETFILE("pdf")
    && Afficher le nom du PDF
    Thisform.txtPdfName.Value = Thisform.cPdfFileName
    IF NOT EMPTY(Thisform.cPdfFileName)
      && Afficher PDF
      Thisform.ShowPdf()
    ENDIF
  ENDPROC

ENDDEFINE


************************************************************************************************
Imprimir un objeto RTF (Rich Text Format) conservando el formato.



PUBLIC loMiForm
loMiForm = NEWOBJECT("MiForm")
loMiForm.SHOW
RETURN

DEFINE CLASS MiForm AS FORM
  HEIGHT = 260
  WIDTH = 500
  AUTOCENTER = .T.
  CAPTION = "Ejemplo de impresion RTF"
  NAME = "MiForm"

  ADD OBJECT oleRTF AS OLECONTROL WITH ;
    TOP = 24, LEFT = 24, HEIGHT = 216, WIDTH = 372, ;
    NAME = "oleRTF", OLECLASS = "RICHTEXT.RichtextCtrl.1"

  ADD OBJECT cmdPrint AS COMMANDBUTTON WITH ;
    TOP = 24, LEFT = 408, HEIGHT = 37, WIDTH = 72, ;
    CAPTION = "Imprimir", NAME = "cmdPrint"

  PROCEDURE INIT
    TEXT TO lcRTF NOSHOW PRETEXT 2
{\rtf1\ansi\ansicpg1252\deff0\deflang11274{\fonttbl{\f0\fswiss\fcharset0 Arial;}
{\f1\fswiss\fprq2\fcharset0 Arial Black;}{\f2\fswiss\fprq2\fcharset0 Arial Narrow;}}
{\colortbl ;\red255\green0\blue0;\red0\green0\blue255;}
{\*\generator Msftedit 5.41.21.2507;}
\viewkind4\uc1\pard\ul\b\f0\fs40 Ejemplo de \cf1 RTF\cf0\ulnone\b0\fs20\par
\par
\cf2\i\f1\fs72 PortalFox\cf0\f0\fs20\par
\b\f2\fs36 Nada corre como un zorro\b0\i0\f0\fs20\par
\par
}
    ENDTEXT
    ERASE "RTF.RTF"
    STRTOFILE(lcRTF, "RTF.RTF")
    THISFORM.oleRTF.FileName = "RTF.RTF"
  ENDPROC

  PROCEDURE cmdPrint.CLICK
    *-- Respuesta de Anders
    DECLARE INTEGER CreateDC IN Win32Api ;
      STRING, STRING, INTEGER, INTEGER
    DECLARE INTEGER DeleteDC IN Win32Api INTEGER
    cPrinter = SET("PRINTER",3)
    hDC = CreateDC("WINSPOOL",cPrinter,0,0)
    THISFORM.oleRTF.SelPrint(hDC)
    DeleteDC(hDC)
  ENDPROC

ENDDEFINE



************************************************************************************************
Crear un Zip usando los recursos estandard de Windows lecturas 62 
 
 Enviado por moby en Lunes, 21 Enero, 2008  
 Estuve buscando por mucho tiempo la manera de usar la funcionalidad standard de Windows "carpetas comprimidas" pero fue hasta ahora que encontre la manera.


Como se que muchos de ustedes posiblemente han estado buscando rutinas para empacar y desempacar archivos .zip de manera automatica y sin instalar librerias de terceros (winzip, .dlls, etc) aqui les envio una copia del .prg que cree para hacer esto sin necesidad de instalar nada mas que VFP.

********************************************
*
* CREADO: Moby
*         Guatemala
*         Enero 2008
*
* Crear un zip con las funciones del sistema operativo Windows
* Este programa deberia funcionar en windows 95/98/Me/XP/2000/2003/Vista
* Lo he probado en Windows Me/XP/y demas y funciona bien.
*
* Para usarlo en Windows Pre-XP instale primero la funcionalidad 
* "carpetas comprimidas"
* en Inicio > Panel de control > Agregar y quitar programas > Componentes Windows
*
* Lo que hay que entender en este programa
* es que para Windows, un archivo .zip no es mas
* que un objeto Folder (es decir una carpeta cualquiera)
*
* Si quieren saber mas sobre Shell.Application
* pueden buscar la documentacion completa en:
*
* +MSDN - Library 2001 o posterior
* ++Platform SDK Documentation
* +++User interface services
* ++++Windows shell
* 
* La informacion especifica de como tratar un objeto folter
* la pueden encontrar en:
*
* +MSDN - Library 2001 o posterior
* ++Platform SDK Documentation
* +++User interface services
* ++++Windows shell
* +++++Shell Reference
* 
* y denle una ojeada a:
* 
*      +++Shell Objects for scripting an Visual Basic
*      ++++Shell Object
*      +++++Methods
*      ++++++NameSpace
*
* Y Tambien a:
*
*      ++Shell Objects for scripting an Visual Basic
*      +++Folder Object
*      ++++Methods
*      +++++CopyHere
*      ++++++Items
*
* El argumento de CopyHere 
* PUEDE ser:
*
* Una cadena conteniendo la ruta completa y el nombre del archivo a copiar
* o Una referencia al Objeto FolderItems
* o Una referencia al objeto FolderItem
*
* FolderItems referencia el contenido completo del folder
* folderItem  referencia solo un archivo en el folder
*
********************************************

&& Secuencia para empacar un archivo:

&& obtener el nombre del zip
cArchivoZip = GetFile("zip:zip","archivo:","Crear",0)

&& obtener un nombre de directorio para empacar
cDirectorioFuente = GetDir("","FUENTE","¿Que empacar?",80)

&& Si se tiene un nombre de archivo
If .not. (Empty(cArchivoZip) .or. Empty(cDirectorioFuente))
  && Borra el archivo si ya existe y lo envia a la papelera
  If File(cArchivoZip)
    Delete File (cArchivoZip) RECYCLE
  EndIf
  && Crear el nuevo zip
  If CreaZip(cArchivoZip)
    && empacalo
    Empaca(cArchivoZip,cDirectorioFuente)
  EndIf
EndIf

&& Secuencia para desempacar un archivo

&& obtener el nombre del zip
cArchivoZip = GetFile("zip:zip","Archivo:","Desempacalo",0)

&& obtener un nombre de directorio destino
cDirectorioDestino = GetDir("","DESTINO","¿A donde desempacar?",80)

&& Desempacalo
If File(cArchivoZip) .and. !Empty(cDirectorioDestino)
  Desempaca(cArchivoZip,cDirectorioDestino) 
EndIf

***********************************************************************************
PROCEDURE CreaZip
PARAMETERS cNombre     && recibe como parametro el nombre del zip
PRIVATE lRetorno
  lRetorno = .f.

  && Crea un archivo zip y le adiciona el primer encabezado

  && Crear el archivo en blanco
  nHandle = fCreate(cNombre)
  
  && si se pudo crear
  If nHandle > 0
     && Escribirle el encabezado .zip
    nEscritos = fWrite(nHandle,"PK"+Chr(5)+Chr(6)+Replicate(Chr(0),18),22)
    && cerrar el archivo
    =fClose(nHandle)
    
    && reportar OK.
    lRetorno = .t.
  EndIf

  && para determinar el encabezado se creo un archivo .zip
  && vacio (click derecho > nuevo > carpeta comprimida en zip). 
  && Y despues se leyo con la funcion leezip que aparece al final
  && de este prg 

RETURN lRetorno
***********************************************************************************
PROCEDURE Empaca
PARAMETERS cFileName,cDirectorio
PRIVATE oShell,oFolder

  && Crear un shell
  oShell = CREATEOBJECT("Shell.Application")
   
  && obtener el objeto Folder del archivo zip
  oFolder = oShell.NameSpace(cFileName)
  
  If IsNull(oFolder)
    =MessageBox("No se puede abrir el zip.",48,"Advertencia:")
  Else
    && si se pudo obtener el objeto folder

    && copiar el directorio al zip
    oFolder.CopyHere(cDirectorio)

    && la sintaxis: oShell.NameSpace(cFileName).CopyHere(cDirectorio)
    && es valida.
    && pero Microsoft sugiere primero hacer oFolder = NameSpace
    && y despues usar oFolder. 
    
    && se puede verificar si el zip empaco todo 
    && usando la propiedad Count del objeto Items 
    && pero les queda de tarea 
  EndIf
  
  && se liberan los recursos 
  Release oShell,oFolder
  
ENDPROC
***********************************************************************************
PROCEDURE Desempaca 
PARAMETERS cFileName,cDirectorio
PRIVATE oShell,;
        oFS,;             && oFolderSource
        oFD,;             && oFolderDest
        oFSI              && oFolderItems 

  && Se crea un shell
  oShell = CREATEOBJECT("Shell.Application")
  
  && Se obtiene el objeto folder del zip
  oFS = oShell.NameSpace(cFilename)
  
  && Se obtien el objeto folder del directorio destino
  oFD = oShell.NameSpace(cDirectorio)

  && Se obtiene el objeto items del zip
  oFSI = oFS.Items 

  If IsNull(oFS) .or. IsNull(oFD)
    =MessageBox("No se puede abrir el zip.",48,"Advertencia:")
  Else
    && Si se pudieron obtener todos los objetos

    && Verifica si el zip contiene archivos dentro
    If oFSI.Count > 0
      && Metodo para desempacar de uno en uno
      && si necesita usarlo comente el otro metodo y des-comente este
      && note que J empieza en 0 y no en 1
*      For J = 0 To (oFSI.Count-1)
*        oFD.CopyHere(oFSI.Item(J))
*      Next

      && Metodo para desempacar todo de una sola vez
      oFD.CopyHere(oFSI)
    Else
      =MessageBox("El zip de origen esta vacio.",48,"Advertencia")
    EndIf
  EndIf
  
  && libera los recursos
  Release oShell,oFS,oFD,oFSI
  
ENDPROC
***********************************************************************************
PROCEDURE LeeZip
PARAMETERS cArchivo
PRIVATE I,J,k
  && abre un archivo (cualquiera) y lo lee byte por byte
  
  && limpia la pantalla
  clear
  
  && abre el archivo a bajo nivel (read-write unbuffered = 12)
  nHandle = fOpen(cArchivo,12)
  
  && si lo pudo abrir
  If nHandle > 0
    && obtiene el tamaño del archivo
    j=fseek(nHandle,0,2)
    
    && ubica el puntero en el inicio
    =fSeek(nHandle,0,0)

    && lee el archivo byte por byte
    && y despliega los resultados en pantalla
    For i=1 to j
      k=fRead(nHandle,1) 
      ? k 
      ?? " = " 
      ?? Asc(k) 
    EndFor
    
    && cierra el archivo    
    =fClose(nHandle)
  EndIf

ENDPROC
*********************************************************************************** 
 

************************************************************************************************
* Adicionar um campo autoincremental a uma tabela com registros
FUNCTION NewIncrem
   LPARAMETERS lcTabla, lcNombreCampo, lnError, lnUltInc
   * abre la tabla
   TRY
      USE (lcTabla) IN 0 EXCLUSIVE
      lnError = 0
   CATCH
      MESSAGEBOX("Error al abrir tabla", 48, "Error")
      lnError = 1
   ENDTRY
   IF lnError = 1
      RETURN 0
   ENDIF
   * crea el campo, si ya existe el nombre o es inválido cancela la operación
   * crea el campo como numérico para poder actualizar los valores
   TRY
      SELECT (lcTabla)
      ALTER TABLE (lcTabla) ADD COLUMN (lcNombreCampo) N(10)
   CATCH
      MESSAGEBOX("Error al crear el campo", 48, "Error")
      lnError = 1
   ENDTRY
   IF lnError = 1
      RETURN 0
   ENDIF
   * actualiza los valores del campo
   REPLACE (lcNombreCampo) WITH RECNO() ALL
   * actualiza el tipo de campo a incremental y el siguiente valor del autoincremental
   ALTER TABLE (lcTabla) ALTER COLUMN (lcNombreCampo) I
   GO BOTTOM
   lnUltInc = &lcNombreCampo
   ALTER TABLE (lcTabla) ALTER COLUMN (lcNombreCampo) INT AUTOINC NEXTVALUE iUltReg+1 STEP 1
   RETURN 1
ENDFUNC
************************************************************************************************
* tratamento de erro
 Program-ID.. ..: ERRTRAP
* Purpose.. .. ..: General purpose error trap
PARAMETERS ErrNum, Msg, Code
* Called with: ON ERROR DO ERRTRAP WITH ERROR(),MESSAGE(),MESSAGE(1)
ON ERROR
SaveAlias = ALIAS()
SaveDB = SET("DATABASE")
SET DATABASE TO
SET MEMOWIDTH TO 80
IF NOT FILE ( "ERRORS.DBF")
   CREATE TABLE ERRORS FREE ;
   ( Date D(8), Time C(5), Program C(50),;
     ErrorNum N(4), Message C(240), BadCodeC (240))
ENDIF
IF NOT USED ( "ERRORS" )
   SELECT 0
   USE ERRORS
ENDIF
DIMENSION pROGnAME[10]
FOR i = 1 TO 10
    ProgName[I] = SYS (16, I)
ENDFOR

Name = IIF ( m.Name = "PROCEDURE ", SUBSTR ( m.Name, 11 ), m.Name )
INSERT INTO ERRORS VALUES ( DATE(), TIME(), m.Name, ERRNUM, Msg, m.Code )

IF NOT EMPTY ( SaveAlias )
   SELECT ( SaveAlias )
ENDIF
SET MEMOWIDTH TO 90
Msg1 = MLINE ( Msg, 1 )
Msg2 = MLINE ( Msg, 2 )
Code1 = MLINE ( m.Code, 1 )
Code2 = MLINE ( m.Code, 2 )
Code3 = MLINE ( m.Code, 3 )
Code4 = MLINE ( m.Code, 4 )
msg = [Error in ] + Name + CHR(13);
    + Msg1 + CHR(13) + Msg2 + CHR(13);
    + "Code was ;"+CHR(13) + Code3 + CHR(13) + Code4
=MessageBox ( msg, 64, AppName )
WAIT WINDOW "<C>ancel, <R>esume, <D>ebug: " TO Result
* There are three valid responses:
DO CASE
CASE Result $ [Cc]
     SET SYSMENU TO DEFAULT
     * Clear open transactions
     DO WHILE TXNLEVEL() > 0
        ROLLBACK
     ENDDO
     IF CursorGetProp ("Buffering") = 3
        IF "2" $ GetFldState(-1)
           =TableRevert(.T.)
        ENDIF
     ENDIF
     CLEAR EVENTS
     CLEAR WINDOW
     CANCEL
CASE Result $ [Dd]
     IF NOT EMPTY ( SaveDB )
        SET DATABASE TO ( SaveDB )
     ENDIF
     SET SYSMENU TO DEFAULT
     ACTIVATE WINDOW DEBUG
     SET STEP ON
OTHERWISE  &&default to "Resume"
IF NOT EMPTY ( SaveDB )
   SET DATABASE TO &SaveDB
ENDIF
ON ERROR DO ERRTRAP WITH ERROR(), MESSAGE(), MESSAGE(1)
ENDCASE
************************************************************************************************
Rutina de Hector Urrutia para exportar un cursor a OpenOffice Calc.


*-------------------------------------------------------------*
*!*- FUNCTION ExporToCalc([cCursor], [cDestino], [cFileSave])
*!*- cCursor:  Alias del cursor que se va a exportar.
*!*- cDestino:  Nombre de la carpeta donde se va a grabar.
*!*- cFileName:  Nombre del archivo con el que se va a grabar.
*-------------------------------------------------------------*
FUNCTION ExporToCalc(cCursor, cDestino, cFileSave)
  LOCAL oManager, oDesktop, oDoc, oSheet, oCell, oRow, FileURL
  LOCAL ARRAY laPropertyValue[1]

  cWarning = "Exportar a OpenOffice.org Calc"

  IF EMPTY(cCursor)
    cCursor = ALIAS()
  ENDIF

  IF TYPE('cCursor') # 'C' OR !USED(cCursor)
    MESSAGEBOX("Parametros Invalidos",16,cWarning)
    RETURN .F.
  ENDIF

  lColNum = AFIELDS(lColName,cCursor)

  EXPORT TO (cDestino + cFileSave + [.ods]) TYPE XL5

  oManager = CREATEOBJECT("com.sun.star.ServiceManager.1")

  IF VARTYPE(oManager, .T.) # "O"
    MESSAGEBOX("OpenOffice.org Calc no esta instalado en su computador.",64,cWarning)
    RETURN .F.
  ENDIF

  oDesktop = oManager.createInstance("com.sun.star.frame.Desktop")

  COMARRAY(oDesktop, 10)

  oReflection = oManager.createInstance("com.sun.star.reflection.CoreReflection")

  COMARRAY(oReflection, 10)

  laPropertyValue[1] = createStruct(@oReflection, "com.sun.star.beans.PropertyValue")
  laPropertyValue[1].NAME = "ReadOnly"
  laPropertyValue[1].VALUE= .F.

  FileURL = ConvertToURL(cDestino + cFileSave + [.ods])

  oDoc = oDesktop.loadComponentFromURL(FileURL , "_blank", 0, @laPropertyValue)

  oSheet = oDoc.getSheets.getByIndex(0)

  FOR i = 1 TO lColNum
    oColumn = oSheet.getColumns.getByIndex(i)
    oColumn.setPropertyValue("OptimalWidth", .T.)

    oCell = oSheet.getCellByPosition( i-1, 0 )
    oDoc.CurrentController.SELECT(oCell)

    WITH oDoc.CurrentSelection
      .CellBackColor = RGB(200,200,200)
      .Cell
      .CharColor = RGB(255,0,0)
      .CharHeight = 10
      .CharPosture = 0
      .CharShadowed = .F.
      .FormulaLocal = lColName[i,1]
      .HoriJustify = 2
      .ParaAdjust = 3
      .ParaLastLineAdjust = 3
    ENDWITH
  ENDFOR

  oCell = oSheet.getCellByPosition( 0, 0 )
  oDoc.CurrentController.SELECT(oCell)

  laPropertyValue[1] = createStruct(@oReflection, "com.sun.star.beans.PropertyValue")
  laPropertyValue[1].NAME = "Overwrite"
  laPropertyValue[1].VALUE = .T.

  oDoc.STORE()
ENDFUNC

FUNCTION createStruct(toReflection, tcTypeName)
  LOCAL loPropertyValue, loTemp
  loPropertyValue = CREATEOBJECT("relation")
  toReflection.forName(tcTypeName).CREATEOBJECT(@loPropertyValue)
  RETURN (loPropertyValue)
ENDFUNC

FUNCTION ConvertToURL(tcFile AS STRING)
  IF(TYPE( "tcFile" ) == "C") AND (!EMPTY( tcFile ))
    tcFile = [file:///] + CHRTRAN(tcFile, "\", "/" )
  ELSE
    tcFile = [file:///C:/] + ALIAS() + [.ods]
  ENDIF
  RETURN tcFile
ENDFUNC
************************************************************************************************

A seguinte rotina calcula o numero maximo de registros que contem a tabela e comapra com o
conteudo do cabeçalho da mesmo e ser necessario reapara

*-----------------
*- Reparar tabla -
*-----------------
FUNCTION _ReparaEncabezado(cTabla)

  LOCAL nArea,nTamañoTabla,nRegistros,nTamañoencabezado,;
    nTamañoRegistro,nRegistrosCalculados

  nArea=FOPEN(cTabla,12)
  nTamañoTabla=FSEEK(nArea,0,2)

  nRegistros=_Lee(nArea, 4,4)
  nTamañoEncabezado=_Lee(nArea, 8,2)
  nTamañoRegistro=_Lee(nArea,10,2)

  nRegistrosCalculados=FLOOR((nTamañoTabla-nTamañoEncabezado)/;
    nTamañoRegistro)
  IF nRegistrosCalculados#nRegistros
    _Escribe(nArea,4,4,nRegistrosCalculados)
  ENDIF

  =FCLOSE(nArea)

ENDFUNC

*------------------
*- Lee encabezado -
*------------------
FUNCTION _Lee(nArea,nPosicion,nTamaño)

  LOCAL cCadena,nValor,nSubInd

  =FSEEK(nArea,nPosicion,0)
  cCadena=FREAD(nArea, nTamaño)
  nValor = 0
  FOR nSubInd=0 TO nTamaño-1
    nValor=nValor+ASC(SUBSTR(cCadena,nSubInd+1))*256^nSubInd
  ENDFOR

  RETURN INT(nValor)

ENDFUNC

*------------------------
*- Reescribe encabezado -
*------------------------
FUNCTION _Escribe(nArea,nPosicion,nTamaño,nNumero)

  LOCAL cCadena,nSubInd

  cCadena=''
  FOR nSubInd=0 TO nTamaño-1
    cCadena=cCadena+CHR(nNumero/256^nSubInd%256)
  ENDFOR

  =FSEEK(nArea, nPosicion,0)

  RETURN FWRITE(nArea,cCadena)

ENDFUN




************************************************************************************************
Permite actualizar la Aplicacion tanto en el equipo local como actualizar el servidor donde esta la aplicacion a distribuir.


Poner este codigo en archivo de inicio principal (prg).

Luego de Generar nuestro ejecutable, el instalador ademas de todos los archivos necesarios, tiene que instalar en cada maquina el Archivo ACTUALIZA.BAT y/o UPLOAD.BAT

El Archivo Upload.bat es identico al Actualiza solo cambia la direccion de la copia.

***** Comprueba Nueva Version  *******

AGETFILEVERSION(ServerApp,"\\miservidor")
Version_Mayor = VAL(SUBSTR(ServerApp(4),1,1))
Version_Menor = VAL(SUBSTR(ServerApp(4),3,AT(ServerApp(4),".",1) + 1))
Version_Mantension = VAL(SUBSTR(ServerApp(4),5,2) )

AGETFILEVERSION(MiApp,"C:\Archivos de programa\CDP\CDP.exe")
MiVersion_Mayor = VAL(SUBSTR(miapp(4),1,1))
MiVersion_Menor = VAL(SUBSTR(miapp(4),3,AT(miapp(4),".",1) + 1))
MiVersion_Mantension = VAL(SUBSTR(miapp(4),5,2) )
*
IF !(MiVersion_Mayor = Version_Mayor.AND.MiVersion_Menor = Version_Menor ;
.AND.MiVersion_Mantension = Version_Mantension)
  **** Actualizar
  ** Si soy yo copia al servidor
  IF UPPER(ALLTRIM(SUBSTR(SYS(0),AT("#",SYS(0),1) + 1,LEN(SYS(0))))) = "miUsername"
    MESSAGEBOX("Las Versiones Son: ServerApp -> " + ServerApp(4) + CHR(13) + ;
      "Local App. ->" + miApp(4) + CHR(13) + "Actualizando el Servidor")

    RUN /N "C:\Archivos de programa\CDP\UPLOAD.BAT"
  ELSE

    SET DEFAULT TO "C:\Archivos de programa\CDP"
    RUN /N "ACTUALIZA.BAT"
    QUIT
  ENDIF
ENDIF

***** Fin Comprobacion de Actualizacion

Contenido del archivo ACTUALIZA.BAT

@ECHO OFF
@ECHO Actualizando Sistema xxxxxxx
@ECHO AUTOR.: Ludwig Corales M.
@ECHO Actualizado al : %DATE%
@xCopy \\soft\CDP.EXE "C:\Archivos de programa\CDP" /C /R /Y

***** Fin Contenido **********

***** Contenido del archivo UPLOAD.BAT ******

@ECHO OFF
@ECHO Actualizando Sistema xxxxxxx
@ECHO AUTOR.: Ludwig Corales M.
@ECHO Actualizado al Servidor : %DATE%
@xCopy "C:\Archivos de programa\CDP\CDP.exe" \\soft\  /C /R /Y

***** Fin Contenido **********Notar que se comparan siempre tanto las versiones mayores, menores y sub versiones, para ver si se actualiza o no.


************************************************************************************************
Función para grabar CDs mediante WSH

* Ejemplo de uso:
=GrabarCD('D:\',.T.)

***************************************************************
* Esta función graba los datos que hay pendientes de
* grabar en la unidad de CD de Windows, mediante llamadas
* a funciones internas del SO, con la posibilidad de
* eliminar los datos después de realizar la grabación
*
* PARAMETROS:
*  unidad(String) - Letra de la unidad donde está la grabadora
*                   (debe acabar con el carácter ':\' ).
*  vaciar(Boolean) - Si es .T., borra los datos pendientes
*                    de la unidad de grabación.
* RETORNO: Esta función no devuelve nada.
***************************************************************
FUNCTION GrabarCD(MyCD,vaciar)
  ** Objecto APPLICATION
  sApp = CREATEOBJECT("Shell.Application")
  ** Objecto SHELL
  sh = CREATEOBJECT("WScript.Shell")

  ** Abrimos Mi PC
  ns = sApp.NameSpace(17)
  ** Abrimos unidad de grabación
  np = ns.ParseName(MyCD)
  ** Damos la orden de grabar el CD
  np.InvokeVerbEx("Grabar estos arc&hivos en un CD")

  ** Esperamos mientras se activa el asistente
  DO WHILE NOT sh.appactivate("Asistente para grabación de CD")
    * WAIT "" TIMEOUT 2
  ENDDO

  ** Insertamos la fecha actual
  MyDateCode = TTOC(DATETIME(),1)
  sh.appactivate("Asistente para grabación de CD")
  sh.SendKeys(MyDateCode)

  ** Iniciamos grabación
  sh.appactivate("Asistente para grabación de CD")
  sh.SendKeys("{Enter}")

  ** Esperamos mientras se cierra el asistente
  DO WHILE sh.appactivate("Asistente para grabación de CD")
    WAIT "" TIMEOUT 5
  ENDDO

  IF vaciar == .T.
    ** Borramos los archivos del directorio temporal de grabación de CD's
    MyTarget = sh.regread("HKCU\Software\Microsoft\Windows\" + ;
      "CurrentVersion\Explorer\Shell Folders\CD Burning")
    deltree(MyTarget,.F.)
    ** Liberamos el objecto SHELL
    RELEASE sh
  ENDIF
ENDFUNC


************************************************************************************************
** Creo un Cursor con los datos del Menu,
** puede ser una tabla ya predefinida

CREATE CURSOR cMiMenu (Nivel C(20),Nombre C(50), DoWhat C(90))

** nivel = ####_ (separo con "_" cada 4 digitos
**         para identificar a que nivel pertenece

** nombre = el nombre que quiero asignar a ese nodo en el menu

** dowhath = que comando quiero ejecutar con el dobleclick, lo ideal
**           es que solo los hijos finales tengan algo, pero ...

** se pueden agregar mas campos, como por ej: imagen, parametros, usuarios, etc
INSERT INTO  cMiMenu (Nivel, Nombre, DoWhat) ;
  VALUES ('0001_', 'Padre 1', ' ')
INSERT INTO  cMiMenu (Nivel, Nombre, DoWhat) ;
  VALUES ('0002_', 'Padre 2', ' ')
INSERT INTO  cMiMenu (Nivel, Nombre, DoWhat) ;
  VALUES ('0001_0001_', 'Hijo 1', 'DO FORM \FRM\Hijo1.scx')
INSERT INTO  cMiMenu (Nivel, Nombre, DoWhat) ;
  VALUES ('0002_0001_','Hijo 2',' ')
INSERT INTO  cMiMenu (Nivel, Nombre, DoWhat) ;
  VALUES ('0002_0001_0001_', 'Hijo de Hijo 2', 'DO \PRG\hijo_de_hijo2.prg')


PUBLIC oForm
oForm = NEWOBJECT("Form1")
oForm.SHOW

DEFINE CLASS Form1 AS FORM

  TOP = 10
  LEFT = 100
  HEIGHT = 360
  WIDTH = 360
  DOCREATE = .T.
  CAPTION = "Menu con TreeView y DobleClick"
  NAME = "Form1"
  MINWIDTH = 100
  MINHEIGHT = 100

  ADD OBJECT Olecontrol1 AS OLECONTROL WITH ;
    TOP = 10, LEFT = 10, HEIGHT = 340, WIDTH = 340, ;
    NAME = "Olecontrol1", OLECLASS = "MSComctlLib.TreeCtrl.2"

  PROCEDURE Olecontrol1.DBLCLICK
    SELECT cMiMenu
    LOCATE FOR cMiMenu.Nivel = THIS.SELECTEDITEM.KEY
    IF FOUND()
      IF LEN(ALLTRIM(cMiMenu.DoWhat)) > 1
        WAIT WINDOW + cMiMenu.DoWhat
      ENDIF
    ENDIF
  ENDPROC

  PROCEDURE RESIZE
    THIS.Olecontrol1.WIDTH = THIS.WIDTH - 20
    THIS.Olecontrol1.HEIGHT = THIS.HEIGHT - 20
  ENDPROC

  PROCEDURE Olecontrol1.INIT
    LOCAL lcNivel,lcTexto,lnTipo,lnResta
    THISFORM.Olecontrol1.LineStyle = 1
    THISFORM.Olecontrol1.LabelEdit = 1
    THISFORM.Olecontrol1.FullRowSelect = .T.
    THISFORM.Olecontrol1.HotTracking = .T.
    SELECT cMiMenu
    GO TOP
    DO WHILE !EOF()
      lcNivel = ALLTRIM(cMiMenu.Nivel)
      lcTexto = ALLTRIM(cMiMenu.Nombre)
      IF LEN(ALLTRIM(lcNivel)) = 5
        ** Cuando el valor del LEN() = 5 asumo que es un nodo raiz
        lnTipo = 0
        THISFORM.Olecontrol1.Nodes.ADD(, lnTipo, lcNivel, lcTexto,,)
      ELSE
        ** si LEN() > 5 es un hijo, siempre multiplos de 5
        lnTipo=4
        lnResta = LEN(ALLTRIM(Nivel)) - 5
        lcKey = SUBSTR(ALLTRIM(lcNivel), 1, lnResta)
        THISFORM.Olecontrol1.Nodes.ADD(lcKey, lnTipo, lcNivel, lcTexto,,)
      ENDIF
      SKIP
    ENDDO
  ENDPROC

ENDDEFINE
************************************************************************************************
* Fechar o PENDRIVE
lo = CREATEOBJECT("Shell.Application")
lo.ControlPanelItem("hotplug.dll")
lo = NULL

************************************************************************************************
* Interromper um processo

oForm = CREATEOBJECT([Form1]) 
oForm.SHOW(1) 

DEFINE CLASS form1 AS FORM 

  DOCREATE = .T. 
  bcancelloop = .F. 
  NAME = "form1" 
  ADD OBJECT command1 AS COMMANDBUTTON WITH ; 
    TOP = 125, ; 
    LEFT = 8, ; 
    HEIGHT = 27, ; 
    WIDTH = 111, ; 
    CAPTION = "Start Loop", ; 
    NAME = "Command1" 

  ADD OBJECT command2 AS COMMANDBUTTON WITH ; 
    TOP = 125, ; 
    LEFT = 130, ; 
    HEIGHT = 27, ; 
    WIDTH = 111, ; 
    CAPTION = "Cancel Loop", ; 
    NAME = "Command2" 

  ADD OBJECT label1 AS LABEL WITH ; 
    AUTOSIZE = .T., ; 
    CAPTION = "Press START", ; 
    HEIGHT = 17, ; 
    LEFT = 31, ; 
    TOP = 45, ; 
    WIDTH = 40, ; 
    NAME = "Label1" 

  PROCEDURE command1.CLICK 
  THISFORM.bcancelloop = .F. 
  lnCounter = 0 
  DO WHILE .T. 
    lnCounter = lnCounter + 1 
    THISFORM.label1.CAPTION = TRANSFORM(lnCounter) 
    DOEVENTS 
    IF THISFORM.bcancelloop 
      THISFORM.label1.CAPTION = [Loop is canceled] 
      EXIT 
    ENDIF 
  ENDDO 

  ENDPROC 

  PROCEDURE command2.CLICK 
  THISFORM.bcancelloop = .T. 
  ENDPROC 

ENDDEFINE
************************************************************************************************
* Colunas do EXCEL
FUNCTION Num2ExcelColumn(tn)
  RETURN IIF(tn > 26, ;
    CHR(64 + FLOOR((tn - 1) / 26)), "") + ;
    CHR(64 + MOD(tn - 1, 26) + 1)
ENDFUNC

************************************************************************************************
* Mostrar termometro de progresso utilizando SQLEXEC
*****
LOCAL loTherm, lcTask, lnPercent, lnSeconds
cRuta="clases\_therm"
**_thermometer es la clase ejemplo que se encuentra en Samples
loTherm = NEWOBJECT("_thermometer",cRuta,"","Creando Tabla")
lcTask = "Consultando..."
loTherm.SHOW()
lc_time=0
SQLSETPROP(lc_con,"Asynchronous",.T.)
m.nresult= SQLEXEC(m.lc_con,"SELECT * FROM Repuesto","repuesto")

DO WHILE SQLEXEC(m.lc_con) = 0
  lc_time=lc_time+1
  loTherm.UPDATE(lc_time, lcTask+" "+TRANS(lc_time))
ENDDO
lotherm.COMPLETE()
SQLSETPROP(lc_con,"Asynchronous",.F.)
************************************************************************************************
*Indexar arquivos

Close Databases All
Close Tables All

Use DBCAIS.Dbc Alias DBCAIS

Select * From DBCAIS ;
   WHERE OBJECTTYPE = 'Table' ;
   INTO Cursor TABLAS

Use In ( Select( 'DBCAIS' )  )

SET SAFETY OFF
*
* SET STEP ON
Select TABLAS
Scan
   TABLA1 = Alltrim(TABLAS.OBJECTNAME)
   Use &TABLA1 In 0 Exclusive
   Select &TABLA1
   Wait Windows 'Tabla ' + Alltrim(TABLA1) + ' (' + Transform(Recno('TABLAS')) + ;
      '/' + Transform(Reccount('TABLAS')) + ')' Nowait
   For I=1 To Tagcount()
      If !Empty(Tag(I))
         INDICE = Sys(14,I)
         NOMBRE = Tag(I)
         PRINCI = Primary(I)
         If PRINCI
            Alter Table &TABLA1 Drop Primary Key
            Alter Table &TABLA1 Add Primary Key &INDICE Tag &NOMBRE
         Else
            Index On &INDICE Tag &NOMBRE Additive
         Endif
      Else
         Reindex
         Exit
      Endif
      Reindex
   Endfor
   Pack
   Select TABLAS
Endscan

************************************************************************************************
*==========================================================
* Demarrer une application Windows ou Dos à partir de VFP
* et attendre la fin de l'application pour redonner la main de VFP.
* On peut attendre le thread ou pas.
* Auteur : Hamou Olivier
*==========================================================

&& Constante pour le choix de la fenetre
#define SW_SHOW_HIDE 0
#define SW_SHOW_NORMAL 1
#define SW_SHOW_MINIMIZED 2
#define SW_SHOW_MAXIMIZED 3

oShell = createobject("WScript.Shell")
* Paramètres
* 1- m.cCheminDeMonAppli && le Chemin de votre appli
* 2- Le mode de fenetrage
* 3- Boolean pour .T. on attend le thread , .F. on attend pas le thread le code passe à la suite.
* Renvoi 0 si c'est Ok
ExecOk = oShell.Run(m.cCheminDeMonAppli, 0,.T.) 
oShell = Null

************************************************************************************************
* Mover o Grid Vertical com ENTER
IF LASTKEY() = 13
  CLEAR TYPEAHEAD
  KEYBOARD '#' CLEAR
  SKIP
  Thisform.Grid1.Refresh()
  Thisform.Grid1.ColumnX.SetFocus()
ENDIF
************************************************************************************************
Criando um campo memo em uma selacao com VFP9


SELECT Company, CAST("" as Memo) AS CampoMemo ;
  FROM Customer ;
  INTO CURSOR curVFP9


************************************************************************************************
Matando um processo

FUNCTION KillProcess(lcExe)

oWMI = GETOBJECT("winmgmts://")
loProcesses = oWMI.InstancesOf("Win32_Process")
lcExe = LOWER(lcEXE)

FOR EACH loProcess in loProcesses
  ? loProcess.Name      && Affiche le nom du process (à supprimer pour mode silencieux)
  IF LOWER(loProcess.Name) = lcExe
    IF loProcess.Terminate() = 0      && Termine l'application
      RETURN .T.
    ENDIF
  ENDIF
ENDFOR

RETURN .F.



************************************************************************************************
LINK PARA BAIXAR O WSH 

http://msdn.microsoft.com/library/default.asp?url=/downloads/list/webdev.asp 

Windows NT/98/ME: 
http://download.microsoft.com/download/4/c/9/4c9e63f1-617f-4c6d-8faf-c2868f670c1c/scr56en.exe 

Windows 2000/XP: 
http://download.microsoft.com/download/2/8/a/28a5a346-1be1-4049-b554-3bc5f3174353/scripten.exe

************************************************************************************************
SABER SE O WSH - WINDOWS SCRIPTING HOST ESTÁ INSTALADO NA MÁQUINA 

Código: 
oShell = CREATEOBJECT('Shell.Application') 
IF TYPE('oShell') = 'O' AND NOT ISNULL(oShell) 
   MESSAGEBOX("WSH Instalado !!!") 
ENDIF 

************************************************************************************************
ABRIR / FECHAR UNIDADE DE CD 

Código: 
DECLARE integer mciSendString IN WINMM.DLL string, string, integer, integer 
**Para abrir 
? mciSendString('set cdaudio door open wait',"",0,0) 
**Para Fechar 
? mciSendString("set cdaudio door closed","",0,0) 

************************************************************************************************
VERIFICAR DE DISQUETE ESTA NO DRIVE A: 

Código: 
oFSO = CREATEOBJECT("Scripting.FileSystemObject") 
? oFSO.FolderExists("A:\") 


ESPAÇO LIVRE NO DISCO 

Código: 
oFSO = CREATEOBJ('Scripting.FileSystemObject') 
oDrive = oFSO.GetDrive("C:") 
? TRANSFORM(oDrive.AvailableSpace,"999,999,999,999") 

************************************************************************************************
SABER NOME DO USUÁRIO LOGADO NO WINDOWS 

Código: 
declare integer GetUserName in advapi32 String@, Integer@ 
lcnomeusuario = replicate(chr(0),255) 
lres = getusername(@lcnomeusuario,255) 
if lres # 0 then 
  messagebox(left(lcnomeusuario,at(chr(0),lcnomeusuario)-1)) 
endif 


SABER SE UMA FONTE ESTA INSTALADA 

Código: 
FUNCTION _ExistFont(tcFont) 
LOCAL laArray(1), lnI, llRet 
llRet = .F. 
IF AFONT(laArray) 
   tcFont = UPPER(tcFont) 
   FOR lnI = 1 TO ALEN(laArray) 
      IF UPPER(laArray(lnI)) == tcFont 
         llRet = .T. 
         EXIT 
      ENDIF 
   ENDFOR 
ELSE 
   MESSAGEBOX('Fonte não instalada') 
ENDIF 
RETURN llRet 
ENDFUNC 



AUTOREGISTRAR OCX E DLLS 

Código: 
DECLARE LONG DllRegisterServer IN [arquivo.ocx] 
IF DllRegisterServer() = 0 
    messagebox('REGISTRADO !!!') 
ELSE 
    messagebox('NÃO REGISTRADO !!!') 
ENDIF 

************************************************************************************************
CRIAR UMA CONEXÃO COM IMPRESSORA DA REDE 
Código: 
oNet =   createobject('WScript.Network') 
oNet.AddWindowsPrinterConnection('\\Servidor\nomeimpressora') 



ALTERAR A IMPRESSORA DEFAULT 
Código: 
oNet =   CreateObject('WScript.Network')    oNet.SetDefaultPrinter('Servidor\nomeimpressora') 



ABRIR AUTOMATICAMENTE O ASSISTENTE PARA ADICIONAR IMPRESSORA 
Código: 
oShell =   CreateObject("WScript.Shell") 
oShell.Run("rundll32.exe   shell32.dll,SHHelpShortcuts_RunDLL AddPrinter") 

************************************************************************************************
MUDAR DATA E HORA DO COMPUTADOR 

Código: 
DECLARE INTEGER ShellExecute IN shell32.dll ; 
   INTEGER hndWin, STRING cAction, STRING cFileName, ; 
   STRING cParams, STRING cDir, INTEGER nShowWin 

lcComm = "date" 
lcParams = "21-07-2007" 
ShellExecute(0,"open",lcComm,lcParams,"",1) 

************************************************************************************************
DESMAPEANDO OU DESCONECTANDO UNIDADE DE REDE 

Código: 
** parâmetros : 
** 1 - "drive" a desmapear 
** 2 - Forçar ou não a desconexão mesmo que esteja em uso 
** 3 - .T. para que o sistema "lembre" do mapeamento ao reinicializar 

oNet = CREATEOBJECT("WScript.Network") 
oNet.RemoveNetworkDrive('J:',.T.,.T.) 
RELEASE oNet 

************************************************************************************************
MAPEANDO UNIDADES DE REDE 

Código: 
** parâmetros : 
** 1 - "drive" a mapear 
** 2 - caminho da rede 
** 3 - .T. para que o sistema "lembre" do mapeamento ao reinicializar 
** 4 - nome do usuário (opcional) 
** 5 - senha do usuário (opcional) 

oNet = CREATEOBJECT('Wscript.Network') 
oNet.MapNetworkDrive('J:','\\Servidor\pastadocumentos\',.t.) 
RELEASE oNet 

************************************************************************************************
MOVER UMA PASTA (OU RENOMEAR) 

Código: 
** parâmetros : 
** 1 - origem 
** 2 - destino 

IF DIRECTORY('c:\diretorioteste\teste') 
    fso = CREATEOBJECT('Scripting.FileSystemObject') 
    fso.MoveFolder("C:\\diretorioteste\\teste", "C:\\novodiretorio\\zzz") 
    RELEASE fso 
ENDIF 



APAGAR UMA PASTA 

Código: 
** parâmetros : 
** 1 - origem 

IF DIRECTORY('c:\diretorioteste\teste') 
    fso = CREATEOBJECT('Scripting.FileSystemObject') 
    fso.DeleteFolder("C:\\diretorioteste\\teste") 
    RELEASE fso 
ENDIF 



COPIAR UMA PASTA 

Código: 
** parâmetros : 
** 1 - origem 
** 2 - destino 
** 3 - sobreescrever - default = .T. 

IF DIRECTORY('c:\diretorioteste\teste') 
    fso = CREATEOBJECT('Scripting.FileSystemObject') 
    fso.CopyFolder("C:\\diretorioteste\\teste", "C:\\novodiretorio\\zzz", .T.) 
    RELEASE fso 
ENDIF 

************************************************************************************************
COMO CRIAR UM ATALHO 

Os comandos abaixo criam um atalho e o salvam no diretório corrente. 

Código: 
WshShell = CreateObject("WScript.Shell") 
oShortCut= WshShell.CreateShortcut("MeuAtalho.lnk") 
oShortCut.TargetPath = 'c:\arquivo.bat' 
oShortCut.WorkingDirectory = 'c:' 
oShortCut.Save  

************************************************************************************************
CRIAR UM ATALHO NA ÁREA DE TRABALHO 
Código: 
oShell =   CreateObject('WScript.Shell') 
  DesktopPath = oShell.SpecialFolders('Desktop') 
  oURL = oShell.CreateShortcut(DesktopPath + 'MSDN Scripting.URL') 
  oURL.TargetPath =   'HTTP://MSDN.Microsoft.com/scripting/' 
  oURL.Save 

************************************************************************************************
--------------------------------------------------------------------------------
 
NUMERO DE SÉRIE DA PLACA DE REDE 

Código: 
Declare Integer CoCreateGuid In 'OLE32.dll' ; 
   string @pguid 
Declare Integer StringFromGUID2 In 'OLE32.dll' ; 
   string rguid, String @lpsz, Integer cchMax 
Declare Integer UuidCreateSequential In 'RPCRT4.dll'  String @ Uuid 

pGUID=Replicate(Chr(0),16) 
rGUID=Replicate(Chr(0),80) 
lcOldError = On('error') 
On Error lnResult = CoCreateGuid(@pGUID) 
lnResult = UuidCreateSequential(@pGUID) 
On Error &lcOldError 
lcMacAddress = Substr( Iif( lnResult = 0 And ; 
   StringFromGUID2(pGUID,@rGUID,40) # 0, ; 
   StrConv(Left(rGUID,76),6), "" ), 26,12) 

? m.lcMacAddress 
 

************************************************************************************************
OBTER POSIÇÃO DO MOUSE NA TELA 

Código: 
 DECLARE INTEGER GetCursorPos IN user32 STRING @ lpPoint 
 LOCAL lcBuffer 
 lcBuffer = REPLI(CHR(0), 8) 
 = GetCursorPos (@lcBuffer) 
 x = CTOBIN(SUBSTR(lcBuffer, 1,4),"4rs") 
 y = CTOBIN(SUBSTR(lcBuffer, 5,4),"4rs") 

************************************************************************************************
* Mostrando imagem de satelite

PUBLIC oMiForm
oMiForm = CREATEOBJECT("MiForm")
oMiForm.SHOW
RETURN

DEFINE CLASS MiForm AS FORM
  HEIGHT = 365
  WIDTH = 475
  AUTOCENTER = .T.
  CAPTION = "Ejemplo con Google Maps"
  NAME = "MiForm"
  SetPoint = ""
  SHOWWINDOW = 2

  ADD OBJECT cboDescrip AS COMBOBOX WITH ;
    ROWSOURCETYPE = 6, ROWSOURCE = "MisLugares.descri", ;
    HEIGHT = 24, LEFT = 12, TOP = 12, WIDTH = 330, ;
    STYLE = 2, NAME = "cboDescrip"

  ADD OBJECT cmdMostrar AS COMMANDBUTTON WITH ;
    TOP = 10, LEFT = 350, HEIGHT = 27, WIDTH = 112, ;
    CAPTION = "Mostrar mapa", NAME = "cmdMostrar"

  ADD OBJECT oleIE AS OLECONTROL WITH ;
    TOP = 48, LEFT = 12, HEIGHT = 300, WIDTH = 450, ;
    NAME = "oleIE", OLECLASS = "Shell.Explorer.2"

  PROCEDURE LOAD
    SYS(2333,1)
    THIS.SetPoint = SET("Point")
    SET POINT TO .
    SET SAFETY OFF
    *-- Creo el cursor con los datos
    CREATE CURSOR MisLugares (Descri C(40), Lat N(12,6), Lon N(12,6), Zoom I(4))
    INSERT INTO MisLugares VALUES ("Torre Eiffel (Francia)", 48.858333, 2.295000, 20)
    INSERT INTO MisLugares VALUES ("Basílica de San Pedro (Vaticano)", 41.902102, 12.456400, 16)
    INSERT INTO MisLugares VALUES ("Estatua de la  Libertad (EEUU)", 40.689360, -74.044400, 20)
    INSERT INTO MisLugares VALUES ("Estadio Monumental (Argentina)", -34.545277, -58.449722, 20)
    INSERT INTO MisLugares VALUES ("Estadio Azteca (Mexico)", 19.302900, -99.150400, 20)
    INSERT INTO MisLugares VALUES ("Estadio Camp Nou (España)", 41.380906, 2.123330, 20)
    INSERT INTO MisLugares VALUES ("Cementerio de aviones (EEUU)", 32.174247, -110.855874, 17)
  ENDPROC

  PROCEDURE DESTROY
    SET POINT TO (THIS.SetPoint)
  ENDPROC

  PROCEDURE cboDescrip.INIT
    THIS.LISTINDEX = 1
  ENDPROC

  PROCEDURE cmdMostrar.CLICK
    TEXT TO lcHtml NOSHOW TEXTMERGE
    <html> <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>Google Maps</title>
    <script src="http://maps.google.com/maps?file=api&v=2&key=123" type="text/javascript"></script>
    <script type="text/javascript">
    //<![CDATA[
    function load()
    { if (GBrowserIsCompatible())
      { var map = new GMap2(document.getElementById("map"),G_SATELLITE_TYPE);
      map.addControl(new GLargeMapControl());
      map.addControl(new GMapTypeControl());
      map.addControl(new GOverviewMapControl());
      map.setCenter(new GLatLng(<<ALLTRIM(STR(MisLugares.Lat,12,6))>>,
      <<ALLTRIM(STR(MisLugares.Lon,12,6))>>),<<TRANSFORM(MisLugares.Zoom)>>);
      map.setMapType(G_HYBRID_TYPE);
    } }
    //]]> </script> </head>
    <body scroll="no" bgcolor="#CCCCCC" topmargin="0" leftmargin="0"
    onload="load()" onunload="GUnload()">
    <div id="map" style="width:450px;height:300px"></div>
    </body> </html>
    ENDTEXT
    STRTOFILE(lcHtml,"MiHtml.htm")
    THISFORM.oleIE.Navigate2(FULLPATH("MiHtml.htm"))
  ENDPROC

ENDDEFINE
************************************************************************************************
* Busca por arquivos graficos em codrefence
(\.ani)|(\.bmp)|(\.cur)|(\.dib)|(\.emf)|(\.exif)|
(\.gif)|(\.gfa)|(\.ico)|(\.jpg)|(\.jpeg)|(\.jpe)|
(\.jfif)|(\.png)|(\.tif)|(\.tiff)|(\.wmf)


************************************************************************************************
*Importacao de dados para EXCEL
********************************************************************
********************************************************************
*!* FUNCTION Exp2Excel( [cCursor, [cFileSave, [cTitulo]]] )
*!*
*!* Exporta un Cursor de Visual FoxPro a Excel, utilizando la
*!* técnica de importación de datos externos en modo texto.
*!*
*!* PARAMETROS OPCIONALES:
*!* - cCursor  Alias del cursor que se va a exportar.
*!*            Si no se informa, utiliza el alias
*!*            en que se encuentra.
*!*
*!* - cFileName  Nombre del archivo que se va a grabar.
*!*              Si no se informa, muestra el libro generado
*!*              una vez concluída la exportación.
*!*
*!* - cTitulo  Titulo del informe. Si se informa, este
*!*            ocuparía la primera file de cada hoja del libro.
********************************************************************
********************************************************************
FUNCTION Exp2Excel( cCursor, cFileSave, cTitulo )
  LOCAL cWarning
  cWarning = "Exportar a EXCEL"
  IF EMPTY(cCursor)
    cCursor = ALIAS()
  ENDIF
  IF TYPE('cCursor') # 'C' OR !USED(cCursor)
    MESSAGEBOX("Parámetros Inválidos",16,cWarning)
    RETURN .F.
  ENDIF
  *********************************
  *** Creación del Objeto Excel ***
  *********************************
  WAIT WINDOW 'Abriendo aplicación Excel.' NOWAIT NOCLEAR
  oExcel = CREATEOBJECT("Excel.Application")
  WAIT CLEAR

  IF TYPE('oExcel') # 'O'
    MESSAGEBOX("No se puede procesar el archivo porque no tiene la aplicación" ;
      + CHR(13) + "Microsoft Excel instalada en su computador.",16,cWarning)
    RETURN .F.
  ENDIF

  oExcel.workbooks.ADD

  LOCAL lnRecno, lnPos, lnPag, lnCuantos, lnRowTit, lnRowPos, i, lnHojas, cDefault

  cDefault = ADDBS(SYS(5)  + SYS(2003))

  SELECT (cCursor)
  lnRecno = RECNO(cCursor)
  GO TOP

  *************************************************
  *** Verifica la cantidad de hojas necesarias  ***
  *** en el libro para la cantidad de datos     ***
  *************************************************
  lnHojas = ROUND(RECCOUNT(cCursor)/65000,0)
  DO WHILE oExcel.Sheets.COUNT < lnHojas
    oExcel.Sheets.ADD
  ENDDO

  lnPos = 0
  lnPag = 0

  DO WHILE lnPos < RECCOUNT(cCursor)

    lnPag = lnPag + 1 && Hoja que se está procesando

    WAIT WINDOWS 'Exportando cursor '  + UPPER(cCursor)  + ' a Microsoft Excel...' ;
      + CHR(13) + '(Hoja '  + ALLTRIM(STR(lnPag))  + ' de '  + ALLTRIM(STR(lnHojas)) ;
      + ')' NOCLEAR NOWAIT

    IF FILE(cDefault  + cCursor  + ".txt")
      DELETE FILE (cDefault  + cCursor  + ".txt")
    ENDIF

    COPY  NEXT 65000 TO (cDefault  + cCursor  + ".txt") DELIMITED WITH CHARACTER ";"
    lnPos = RECNO(cCursor)

    oExcel.Sheets(lnPag).SELECT

    XLSheet = oExcel.ActiveSheet
    XLSheet.NAME = cCursor + '_' + ALLTRIM(STR(lnPag))

    lnCuantos = AFIELDS(aCampos,cCursor)

    ********************************************************
    *** Coloca título del informe (si este es informado) ***
    ********************************************************
    IF !EMPTY(cTitulo)
      XLSheet.Cells(1,1).FONT.NAME = "Arial"
      XLSheet.Cells(1,1).FONT.SIZE = 12
      XLSheet.Cells(1,1).FONT.BOLD = .T.
      XLSheet.Cells(1,1).VALUE = cTitulo
      XLSheet.RANGE(XLSheet.Cells(1,1),XLSheet.Cells(1,lnCuantos)).MergeCells = .T.
      XLSheet.RANGE(XLSheet.Cells(1,1),XLSheet.Cells(1,lnCuantos)).Merge
      XLSheet.RANGE(XLSheet.Cells(1,1),XLSheet.Cells(1,lnCuantos)).HorizontalAlignment = 3
      lnRowPos = 3
    ELSE
      lnRowPos = 2
    ENDIF

    lnRowTit = lnRowPos - 1
    **********************************
    *** Coloca títulos de Columnas ***
    **********************************
    FOR i = 1 TO lnCuantos
      lcName  = aCampos(i,1)
      lcCampo = ALLTRIM(cCursor) + '.' + aCampos(i,1)
      XLSheet.Cells(lnRowTit,i).VALUE=lcname
      XLSheet.Cells(lnRowTit,i).FONT.bold = .T.
      XLSheet.Cells(lnRowTit,i).Interior.ColorIndex = 15
      XLSheet.Cells(lnRowTit,i).Interior.PATTERN = 1
      XLSheet.RANGE(XLSheet.Cells(lnRowTit,i),XLSheet.Cells(lnRowTit,i)).BorderAround(7)
    NEXT

    XLSheet.RANGE(XLSheet.Cells(lnRowTit,1),XLSheet.Cells(lnRowTit,lnCuantos)).HorizontalAlignment = 3

    *************************
    *** Cuerpo de la hoja ***
    *************************
    oConnection = XLSheet.QueryTables.ADD("TEXT;"  + cDefault  + cCursor  + ".txt", ;
      XLSheet.RANGE("A"  + ALLTRIM(STR(lnRowPos))))

    WITH oConnection
      .NAME = cCursor
      .FieldNames = .T.
      .RowNumbers = .F.
      .FillAdjacentFormulas = .F.
      .PreserveFormatting = .T.
      .RefreshOnFileOpen = .F.
      .RefreshStyle = 1 && xlInsertDeleteCells
      .SavePassword = .F.
      .SaveData = .T.
      .AdjustColumnWidth = .T.
      .RefreshPeriod = 0
      .TextFilePromptOnRefresh = .F.
      .TextFilePlatform = 850
      .TextFileStartRow = 1
      .TextFileParseType = 1 && xlDelimited
      .TextFileTextQualifier = 1 && xlTextQualifierDoubleQuote
      .TextFileConsecutiveDelimiter = .F.
      .TextFileTabDelimiter = .F.
      .TextFileSemicolonDelimiter = .T.
      .TextFileCommaDelimiter = .F.
      .TextFileSpaceDelimiter = .F.
      .TextFileTrailingMinusNumbers = .T.
      .REFRESH
    ENDWITH

    XLSheet.RANGE(XLSheet.Cells(lnRowTit,1),XLSheet.Cells(XLSheet.ROWS.COUNT,lnCuantos)).FONT.NAME = "Arial"
    XLSheet.RANGE(XLSheet.Cells(lnRowTit,1),XLSheet.Cells(XLSheet.ROWS.COUNT,lnCuantos)).FONT.SIZE = 8

    XLSheet.COLUMNS.AUTOFIT
    XLSheet.Cells(lnRowPos,1).SELECT
    oExcel.ActiveWindow.FreezePanes = .T.

    WAIT CLEAR

  ENDDO

  oExcel.Sheets(1).SELECT
  oExcel.Cells(lnRowPos,1).SELECT

  IF !EMPTY(cFileSave)
    oExcel.DisplayAlerts = .F.
    oExcel.ActiveWorkbook.SAVEAS(cFileSave)
    oExcel.QUIT
  ELSE
    oExcel.VISIBLE = .T.
  ENDIF

  GO lnRecno

  RELEASE oExcel,XLSheet,oConnection

  IF FILE(cDefault + cCursor + ".txt")
    DELETE FILE (cDefault + cCursor + ".txt")
  ENDIF

  RETURN .T.

ENDFUNC

***
***

************************************************************************************************
**** Como detectar uma impressora matricial
#DEFINE DC_BINS             6
#DEFINE DMBIN_TRACTOR       8

CLEAR
DIMENSION asPrn[1]
FOR nPrn = 1 TO APRINTERS(asPrn)
  sPrn = asPrn[nPrn, 1]
  ? PADR(sPrn,25), " ", IIF(IsDotPrinter (sPrn), "Matriz", "")
NEXT
RETURN

FUNCTION IsDotPrinter (sPrn)
  LOCAL nBins, sBuff
  DECLARE LONG DeviceCapabilities IN WinSpool.drv ;
    STRING @ sPrinter, STRING @ sPort, ;
    INTEGER nCapability, STRING @ sReturn, STRING @ pDevMode
  sBuff = SPACE(512)
  * Lista de words de bandejas
  nBins = DeviceCapabilities (sPrn, NULL, DC_BINS, @sBuff, NULL)
  IF nBins > 0
    sBuff = PADR(sBuff, nBins)
  ENDIF
  CLEAR DLLS DeviceCapabilities
  RETURN CHR(DMBIN_TRACTOR) $ sBuff
ENDFUNC



************************************************************************************************
* INATIVIDADE DO WINDOWS
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
************************************************************************************************
* Chaves possiveis para um cadeia de caracteres

CLEAR
nn=0

permute("abcd",0)



Procedure permute(cstr,nLev)
Local nTrylen,i
nTrylen= Len(cstr)-nLev
If nTrylen = 0
   nn=nn+1
   ? nn ,cstr
Else
   For i = 1 To nTrylen
      If i>1      && swap nlev+1 and nlev+i chars
         cstr= Left(cstr,nLev) + Substr(cstr,nLev+i,1) +;
               Substr(cstr,nLev+2, i-2)+Substr(cstr,nLev+1,1)+Substr(cstr,nLev+i+1)
      Endif
      permute(cstr,nLev+1)
   Endfor
Endif

Return




************************************************************************************************

Como configurar uma entrada de campo numerico (get) de forma que se alguem digitar 187,89 ou 187.89 ele aceitar ambos os formatos


se o SET POINT TO estiver com ponto coloque no keypress do text o seguinte codigo 

LPARAMETERS nKeyCode, nShiftAltCtrl 
If nkeycode = 44 
NODEFAULT 
KEYBOARD CHR(46) 
endif 

*OBS: se o SET POINT TO estiver virgula inverta o 44 com o 46 



************************************************************************************************
Indexar uma tabela SHARED

Caros Colegas, 

Existe sim forma de ser organizar tabelas mesmo em ums sitema multiusuario, mesmo com a tabela estando aberta em outro terminal basta usar da seguinte forma. 
Código: 

INDEX ON "campo" TO "nomedoarquivodeindice" ADDITIVE 

exemplo 

INDEX ON CODCLIE TO GETENV("TMP")+"\CLIENTES" 


no caso ele ira criar no na pasta TEMP o arquivo Clientes.idx usando o campo CodClie. 

Normalmente eu verifico se o arquivo existe, apago se existir. No Final ao fechar a tela eu mato o arquivo, para evitar que a pasta fique com varios arquivos. Lembrando que o arquivo deve ser criado no terminal que esta usando, mesmo se gravar no servidor, bastaria mudar um pouco o codigo e criar um nome pra tabela usando um codigo randomico. Basta usar a Imaginação. 

************************************************************************************************
** PLAY AVI

** Para USAR
SET PROCEDURE TO ClasseAvi additive
ThisForm.addobject("OAvi1", "AVI")
ThisForm.oAvi1.PlayAvi(Thisform.ShapeAvi1, "filecopy.avi")

 
Code source : 
*----------------------------------------------------------------------
* ClasseAvi
* PayAvi : But afficher un AVI dans un formulaire avec gestion de la couleur de fond (Transparence)
* sans utiliser (Directement) le MMcontrol
* Francis FAURE 6/2006
*----------------------------------------------------------------------
* 1.0 : Publication
* 1.1 : Ajout Méthode "StopAvi", Correction pb chargement dll dans le init,
*       Stop AVI et suppression de la fenétre au destroy() de l'objet
*----------------------------------------------------------------------
DEFINE CLASS AVI as Session
  version = 1.1
  x = 0
  y = 0
  w = 0
  h = 0
  FormHwnd = 0
  AviHwnd = 0
  BackColor = 0
  BackStyle = 1
  Shape = null
  AviFileName = ""

  PROCEDURE Init
  Endproc

  Procedure Destroy
    This.StopAvi() && v 1.1
    DODEFAULT()
  endproc

  PROCEDURE PlayAvi(AviShape as object, AviFileName as String)
    * test 2 paramétres
    IF pcount()<>2
      =MESSAGEBOX("Il faut 2 paramétres pour .PlayAvi(oShape, sAviFileName)")
      return
    endif
    * Fichier Avi
    IF EMPTY(AviFileName)
      =MESSAGEBOX("Veuillez préciser le nom du fichier AVI en paramétre")
      return
    endif
    This.AviFileName = FULLPATH(ALLTRIM(AviFileName))
    IF NOT FILE(This.AviFileName)
      =MESSAGEBOX("Le fichier :"+This.AviFileName+" est introuvable.")
      This.AviFileName=""
      return
    ENDIF
    * Récupération des informations du shape
    IF TYPE("AviShape")<>"O" OR AviShape.BaseClass<>"Shape"
      =MESSAGEBOX("Le premier paramétre de .PlayAvi est une référence a un object Shape (celui sert a positionner l'AVI)")
      RETURN
    ENDIF
    This.FormHwnd = AviShape.Parent.hwnd  && lhwnd
    This.x = AviShape.left
    This.y = AviShape.top
    This.w = AviShape.width
    This.h = AviShape.height
    This.BackColor = AviShape.BackColor
    This.BackStyle = AviShape.BackStyle
    This.Shape = AviShape

    * Création d'une fenêtre sur informations du shape
    *ACS_CENTER              0x0001
    *ACS_TRANSPARENT         0x0002
    *ACS_AUTOPLAY            0x0004
    *ACS_TIMER               0x0008
    #DEFINE WS_EX_TRANSPARENT 0x20
    #define ANIMATE_CLASS "SysAnimate32"
    Declare Long CreateWindowEx IN user32 Long, String, String, Long, Long, Long, Long, Long, Long, Long, Long, Long
This.AviHwnd = CreateWindowEx(WS_EX_TRANSPARENT, ANIMATE_CLASS, "", 0x50000007, this.x, this.y, this.w, this.h, this.FormHwnd, 0, 0, 0)
    CLEAR DLLS CreateWindowEx

    * Utilisation de BindEvent pour récupérer le CallBack (hook) du message WM_CTLCOLORSTATIC de l'avi
    #define WM_CTLCOLORSTATIC 0x0138
    BINDEVENT(This.FormHwnd, WM_CTLCOLORSTATIC, This, "MyCTLCOLORSTATIC")

    * Message d'ouverture de l'avi
    #define WM_USER 0x400
    #define ACM_OPEN WM_USER + 100
    #define ACM_PLAY WM_USER + 101
    Declare LONG SendMessage IN user32 Long, Long, Long, String
    =SendMessage(This.AviHwnd, ACM_OPEN, 0, This.AviFileName)  && OPEN suffit car la fenetre est définie en autoplay
    This.Shape.Refresh()
    CLEAR DLLS SendMessage
  endproc

  * Methode déclanchée par la réception du message WM_CTLCOLORSTATIC (BindEvent+haut)
  PROCEDURE MyCTLCOLORSTATIC(whwnd as Long, uMSG as Long, HDC as Long, HWNDcontrol as long)
    IF This.AviHwnd=0
      RETURN
    endif
    IF This.AviHwnd <> HWNDcontrol
      RETURN
    ENDIF
    Declare long SetBkColor IN Win32API Long, Long
    =SetBkColor(HDC, This.BackColor)
    CLEAR DLLS SetBkColor
    * Suppression du Bind (changement du backcolor une fois suffit)
    unBINDEVENT(This.FormHwnd, WM_CTLCOLORSTATIC)
  ENDPROC

  * v 1.1
  PROCEDURE StopAvi
    IF This.AviHwnd<>0
      Declare LONG SendMessage IN user32 Long, Long, Long, String
      Declare long DestroyWindow IN user32 Long
      #define ACM_STOP WM_USER + 102
      =SendMessage(This.AviHwnd, ACM_STOP, 0, "")
      =DestroyWindow(this.AviHwnd)
      This.AviHwnd=0  && permet de savoir si un avi est en cours
      This.AviFileName=""
      CLEAR DLLS DestroyWindow
      CLEAR DLLS SendMessage
    endif
  endproc
ENDDEFINE
*----------------------------------------------------------------------


 

************************************************************************************************
* RunDll32.exe para acessar funcoes do WINDOWS

&& Faire appel à 'ajout/suppression de programmes'

oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe shell32.dll,Control_RunDLL appwiz.cpl,,0")

&& Faire appel à l'affichage

oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe shell32.dll,Control_RunDLL access.cpl,,3")

&& Faire appel au réglage de la carte de son

oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe shell32.dll,Control_RunDLL access.cpl,,2")

&& Faire appel au panneau de configuration

oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe shell32.dll,Control_RunDLL")

&& Faire appel pour copier une disquette

oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe DISKCOPY.DLL,DiskCopyRunDll")

&& Faire appel au formattage du disque dur.

oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe SHELL32.DLL,SHFormatDrive")

&& Ouvrir le répertoire de polices

oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe SHELL32.DLL,SHHelpShortcuts_RunDLL FontsFolder")

&& Faire appel au controleur de jeux

oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe shell32.dll,Control_RunDLL joy.cpl")

&& Faire appel à l'ajout de matériel

oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe shell32.dll,Control_RunDLL hdwwiz.cpl")

&& Faire appel aux propriétés de la sourie

oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe shell32.dll,Control_RunDLL main.cpl @0")

&& Ajouter une connexion réseau

oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe netplwiz.dll,AddNetPlaceRunDll")

&& Connecter un lecteur de réseau


oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe shell32.dll,SHHelpShortcuts_RunDLL Connect")

&& Ouvrir le panneau d'admninistration des connexions ODBC

oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe shell32.dll,Control_RunDLL odbccp32.cpl")

&& Oublié votre mot de passe?

oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe keymgr.dll,PRShowSaveWizardExW")

&& Changer de mot de passe

oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe keymgr.dll,PRShowRestoreWizardExW")

&& Connecter une imprimante

oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe WINSPOOL.DRV,ConnectToPrinterDlg")

&& Ouvrir le répertoire des imprimantes

oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe SHELL32.DLL,SHHelpShortcuts_RunDLL PrintersFolder")

&& Ouvrir les propriétés du modem

oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe shell32.dll,Control_RunDLL telephon.cpl")

&& Faire appel aux comptes des utilisateurs

oShell =   CreateObject("WScript.Shell")
oShell.run("rundll32.exe %SystemRoot%\System32\netplwiz.dll,UsersRunDll")

&& Ouvrir l'interface du FireWall de Windows

oShell =   CreateObject("WScript.Shell")
oShell.run("RunDll32.exe shell32.dll,Control_RunDLL firewall.cpl")



************************************************************************************************
Picture em LISTBOX e COMBOBOX
****
PUBLIC goMiForm
goMiForm = CREATEOBJECT("MiForm")
goMiForm.SHOW(1)
RETURN

DEFINE CLASS MiForm AS FORM
  HEIGHT = 232
  WIDTH = 496
  AUTOCENTER = .T.
  SHOWWINDOW = 2
  CAPTION = "Imágenes en controles ListBox y ComboBox"
  NAME = "MiForm"
  ICON = HOME(1) + "Graphics\Icons\Misc\face02.ico"
  ADD OBJECT lstLista1 AS LISTBOX WITH ;
    HEIGHT = 208, LEFT = 12, TOP = 12, WIDTH = 150, ;
    INTEGRALHEIGHT = .T., NAME = "lstLista1"
  ADD OBJECT lstLista2 AS LISTBOX WITH ;
    HEIGHT = 208, LEFT = 170, TOP = 12, WIDTH = 150, ;
    INTEGRALHEIGHT = .T., NAME = "lstLista2"
  ADD OBJECT cmbCombo AS COMBOBOX WITH ;
    HEIGHT = 24, LEFT = 330, TOP = 12, WIDTH = 150, ;
    STYLE = 2, NAME = "cmbCombo"
  *--
  PROCEDURE INIT
    LOCAL lcDir, ln, lnItems
    lcDirBmp = HOME(1) + "Graphics\Bitmaps\Outline\Nomask\"
    WITH THISFORM
      .ADDPROPERTY("la(1)")
      lnItems = ADIR(.la,lcDirBmp + "*.bmp")
      *-- Items e imagen igual para todos los elementos
      .lstLista1.ROWSOURCETYPE = 5 && Matriz
      .lstLista1.ROWSOURCE = "ThisForm.la"
      .lstLista1.PICTURE = lcDirBmp + "Bmp.Bmp"
      FOR ln = 1 TO lnItems
        *-- Items e imágenes para cada elemento del ListBox
        .lstLista2.ADDITEM(.la(ln,1),ln)
        .lstLista2.PICTURE(ln) = lcDirBmp + .la(ln,1)
        *-- Items e imágenes para cada elemento del ComboBox
        .cmbCombo.ADDITEM(.la(ln,1),ln)
        .cmbCombo.PICTURE(ln) = lcDirBmp + .la(ln,1)
      ENDFOR
      .lstLista1.LISTINDEX = 1
      .lstLista2.LISTINDEX = 1
      .cmbCombo.LISTINDEX = 1
    ENDWITH
  ENDPROC
ENDDEFINE

************************************************************************************************
*
*  IsAPIFunction.PRG
*  RETURN un valor lógico indicando si el nombre de la función pasada 
*  como parámetro en una función API de Windows (en una Windows .DLL)
*  que está actualmente cargada por el comando DECLARE
*
*  Author:  Drew Speedie
*
*  Esta función usa:
*  1- La función ADLLS() introducida en VFP 7.0
*  2- El sexto parámetro opcional agregado a la 
*     función ASCAN() en VFP 7.0
*
*  Ejemplos:
*!*  IF NOT X7ISAPIF("MessageBeep")
*!*    DECLARE Long MessageBeep IN USER32.DLL Long uType
*!*  ENDIF
*!*  MessageBeep(0)
*
*!*  IF NOT X7ISAPIF("MessageBeepWithAlias")
*!*    DECLARE Long MessageBeep IN USER32.DLL AS MessageBeepWithAlias Long uType
*!*  ENDIF
*!*  MessageBeep(0)
*
*!*  IF NOT X7ISAPIF("MessageBeepWithAlias","MessageBeep")
*!*    DECLARE Long MessageBeep IN USER32.DLL AS MessageBeepWithAlias Long uType
*!*  ENDIF
*!*  MessageBeep(0)
*
*
*  lParameters
*    tcFunctionAlias: El alias de la función API
*                     Por omisión, el alias es el mismo que el
*                     nombre de la función pero se puede hacer:
*                     DECLARE DLL .. AS 
*    tcFunctionName:  Si pasa tcFunctionAlias y necesita estar seguro
*                     que esta función solo retorna .T. cuando
*                     tcFunctionAlias es el alias para una declaración
*                     para un nombre de función específico, pase el 
*                     nombre de la fucnción en este parámetro
*
LPARAMETERS tcFunctionAlias, tcFunctionName
LOCAL laDLLs[1], lnRow
IF ADLLS(m.laDLLs) = 0
  RETURN .F.
ENDIF
lnRow = ASCAN(laDLLs,m.tcFunctionAlias,1,-1,2,15)
IF m.lnRow = 0
  RETURN .F.
ENDIF
IF PCOUNT() = 1 ;
    OR NOT VARTYPE(m.tcFunctionName) = "C" ;
    OR EMPTY(m.tcFunctionName)
  RETURN .T.
ENDIF
*
*  tcFunctionName fue pasado
*
RETURN UPPER(ALLTRIM(m.laDLLs[m.lnRow,1])) == UPPER(ALLTRIM(m.tcFunctionName))
************************************************************************************************
* SETAR HORARIO DO SERVIDOR NA ESTACAO

SetTime("\\ServerName\SharedDIsk")

FUNCTION SetTime(l_path)
   LOCAL c_creatf, m1, cDate, cTime
   c_creatf = ADDBS(l_path) + SYS(2015) + ".TIM"
   m1 = FCREATE(c_creatf)
   IF m1 > 0
      FCLOSE(m1)
      m1 = ADIR(cTim, c_creatf)
      ERASE (c_creatf)
      cDate = cTim[1,3]
      cTime = cTim[1,4]
      cBuff =         Num2WORD(YEAR(cDate))
      cBuff = cBuff + Num2WORD(MONTH(cDate))
      cBuff = cBuff + Num2WORD(1)                   && Day of week, ignored
      cBuff = cBuff + Num2WORD(DAY(cDate))
      cBuff = cBuff + Num2WORD(VAL(LEFT(cTime,2)))
      cBuff = cBuff + Num2WORD(VAL(SUBSTR(cTime,4,2)))
      cBuff = cBuff + Num2WORD(VAL(RIGHT(cTime,2)))
      cBuff = cBuff + Num2WORD(0)+CHR(0)
      DECLARE INTEGER  SetLocalTime IN WIN32API STRING @cBuff
      SetLocalTime(@cBuff)
   ENDIF
RETURN

FUNCTION Num2WORD
   LPARAMETER tnNum
   LOCAL x
   x=INT(tnNum)
RETURN CHR(MOD(x,256))+CHR(INT(x/256))




************************************************************************************************
*TRAMENTO DE DATAS API
*
CLEAR
? CDATEEX(DATE(),1)
? CDATEEX(DATE(),2)
?
FOR i = 1 TO 12
  ? CDATEEX(DATE(2007,i,1),2)
ENDFOR
?
? CDOWEX(DATE(2007,1,1),1), CDOWEX(1,2)
? CDOWEX(DATE(2007,1,2),1), CDOWEX(2,2)
? CDOWEX(DATE(2007,1,3),1), CDOWEX(3,2)
? CDOWEX(DATE(2007,1,4),1), CDOWEX(4,2)
? CDOWEX(DATE(2007,1,5),1), CDOWEX(5,2)
? CDOWEX(DATE(2007,1,6),1), CDOWEX(6,2)
? CDOWEX(DATE(2007,1,7),1), CDOWEX(7,2)
?
FOR i = 1 TO 12
  ? CMONTHEX(i,1), CMONTHEX(i,2)
ENDFOR
?
? CMONTHEX(DATE(2007,12,7),1), CMONTHEX(12,2)
?
? TRANSFORM(DAY(DATE())) + [/] + CMONTHEX(DATE(),1) + ;
  [/] + TRANSFORM((YEAR(DATE())))
RETURN
*
*****
* CDOWEX(dDate, nFormat)
* dDate: expresión de fecha/fechahora/dia de la semana
* nFormat: 1/S/C = nombre de dia abreviado,
* 2/L = nombre de dia completo (Default)
*****
FUNCTION CDOWEX
  PARAMETERS tdDate, tnFormat
  DeclareDlls()
  LOCAL lnType, lcBuffer, lnBufferLen, lnRetVal
  IF VARTYPE(m.tnFormat) = [C] AND UPPER(m.tnFormat) $ "SC" THEN
    m.tnFormat = 1
  ENDIF
  IF NOT VARTYPE(m.tnFormat) = [N] THEN
    m.tnFormat = 2
  ENDIF
  IF NOT BETWEEN(m.tnFormat, 1, 2) THEN
    m.tnFormat = 2
  ENDIF
  IF VARTYPE(m.tdDate) = [N] AND BETWEEN(m.tdDate, 1, 7)
    m.lnType = m.tdDate + IIF(m.tnFormat = 1, 48, 41)
  ELSE
    IF NOT VARTYPE(m.tdDate) $ [DT] THEN
      m.tdDate = DATE()
    ENDIF
    m.lnType = DOW(m.tdDate,2) + IIF(m.tnFormat = 1, 48, 41)
  ENDIF
  m.lcBuffer = SPACE(254)
  lnRetVal = GetLocaleInfo(1024, m.lnType, @m.lcBuffer, 254)
  m.lcBuffer = LEFT(m.lcBuffer, m.lnRetVal - 1)
  RETURN m.lcBuffer
ENDFUNC
*****
* CMONTHEX(dDate, nFormat)
* dDate: expresión de fecha/fechahora/numero de mes
* nFormat: 1/S/C = nombre de mes abreviado,
* 2/L = nombre de mes completo (Default)
*****
FUNCTION CMONTHEX
  PARAMETERS tdDate, tnFormat
  DeclareDlls()
  LOCAL lnType, lcBuffer, lnBufferLen, lnRetVal
  IF VARTYPE(m.tnFormat) = [C] AND UPPER(m.tnFormat) $ "SC" THEN
    m.tnFormat = 1
  ENDIF
  IF NOT VARTYPE(m.tnFormat) = [N] THEN
    m.tnFormat = 2
  ENDIF
  IF NOT BETWEEN(m.tnFormat, 1, 2) THEN
    m.tnFormat = 2
  ENDIF
  IF VARTYPE(m.tdDate) = [N] AND BETWEEN(m.tdDate, 1, 12)
    m.lnType = m.tdDate + IIF(m.tnFormat = 1, 67, 55)
  ELSE
    IF NOT VARTYPE(m.tdDate) $ [DT] THEN
      m.tdDate = DATE()
    ENDIF
    m.lnType = MONTH(m.tdDate) + IIF(m.tnFormat = 1, 67, 55)
  ENDIF
  m.lcBuffer = SPACE(254)
  lnRetVal = GetLocaleInfo(1024, m.lnType, @m.lcBuffer, 254)
  m.lcBuffer = LEFT(m.lcBuffer, m.lnRetVal - 1)
  RETURN m.lcBuffer
ENDFUNC
*****
* CDATEEX(dDate, nFormat)
* dDate: expresión de fecha/fechahora
* nFormat: 1/S/C = formato de fecha corta,
* 2/L = formato de fecha larga (Default)
*****
FUNCTION CDATEEX
  PARAMETERS tdDate, tnFormat
  DeclareDlls()
  LOCAL lcDate, lcBuffer, lnBufferLen, lnRetVal
  IF NOT VARTYPE(m.tdDate) $ [DT] THEN
    m.tdDate = DATE()
  ENDIF
  IF VARTYPE(m.tnFormat) = [C] AND UPPER(m.tnFormat) $ "SC" THEN
    m.tnFormat = 1
  ENDIF
  IF NOT VARTYPE(m.tnFormat) = [N] THEN
    m.tnFormat = 2
  ENDIF
  IF NOT BETWEEN(m.tnFormat,1,2) THEN
    m.tnFormat = 2
  ENDIF
  m.lcDate = ShortToBin(YEAR(m.tdDate)) + ;
    ShortToBin(MONTH(m.tdDate)) + ;
    ShortToBin(DOW(m.tdDate,2)) + ;
    ShortToBin(DAY(m.tdDate)) + ;
    REPLICATE(CHR(0),8)
  m.lcBuffer = SPACE(254)
  m.lnBufferLen = 254
  m.lnRetVal = GetDateFormat_CDATEEX(1024, m.tnFormat, ;
    @m.lcDate, 0, @m.lcBuffer, m.lnBufferLen)
  m.lcBuffer = LEFT(m.lcBuffer, m.lnRetVal - 1)
  RETURN m.lcBuffer
ENDFUNC
*****
* DeclareDlls
* Declara las funciones API usadas por CDOWEX, CMONTHEX, CDATEEX
*****
PROCEDURE DeclareDlls
  LOCAL laDlls(1,3), lnLen AS NUMBER
  m.lnLen = ADLLS(laDlls )
  IF ASCAN(laDlls, "GetDateFormat_CDATEEX", 1, m.lnLen , 2, 15) = 0
    DECLARE INTEGER GetDateFormat ;
      IN kernel32 AS GetDateFormat_CDATEEX ;
      INTEGER Locale, ;
      INTEGER dwFlags, ;
      STRING @lpDate, ;
      INTEGER lpFormat, ;
      STRING @lpDateStr, ;
      INTEGER cchDate
  ENDIF
  IF ASCAN(laDlls, "GetLocaleInfo", 1, m.lnLen , 2, 15) = 0
    DECLARE INTEGER GetLocaleInfo ;
      IN kernel32 ;
      INTEGER Locale, ;
      INTEGER LCType, ;
      STRING lpLCData, ;
      INTEGER cchData, ;
      ENDIF
  ENDIF
  RETURN
ENDFUNC
*****
* ShortToBin
* Convierte un numero en una cadena binaria de 2 bytes
*****
FUNCTION ShortToBin
  PARAMETERS tnLongVal
  PRIVATE i, lcRetstr
  IF VERSION(5) < 900 THEN
    m.lcRetstr = ""
      FOR i = 8 TO 0 STEP -8
        m.lcRetstr = CHR(INT(m.tnLongVal/(2^i))) + m.lcRetstr
        m.tnLongVal = MOD(m.tnLongVal, (2^i))
      NEXT
  ELSE
    m.lcRetstr = BINTOC(m.tnLongVal,[2RS])
  ENDIF
  RETURN m.lcRetstr
ENDFUNC
************************************************************************************************

************************************************************
* Funcion: Is_Run
* Indica si un programa está en ejecución
* Parametros:
*    tcprograma - Nombre del programa a comprobar
* Ejemplos:
*    llret = Is_Run("GESTION.EXE")
*    llret = Is_Run("GESTION")
* Retorno:
*     .F. - El programa no está en ejecución
*     .T. - El programa está en ejecución
* Notas:
*    Si no se pone extensión, se asume EXE por defecto.
*
* Adaptación de código realizado por Carlos Salina
* http://www.portalfox.com/article.php?sid=329
* Creación           : 14/02/2006 Pablo Roca
* Ultima Modificacion: 14/02/2006 Pablo Roca
************************************************************
FUNCTION IS_RUN(tcprograma)

#DEFINE PROCESS_VM_READ               16 
#DEFINE PROCESS_QUERY_INFORMATION   1024 
#DEFINE DWORD                          4 

*--------------------------------------------------
*  Declaración de Funciones API
*--------------------------------------------------
DECLARE INTEGER GetLastError IN kernel32 
DECLARE INTEGER CloseHandle IN kernel32 INTEGER Handle 
DECLARE INTEGER OpenProcess IN kernel32; 
   INTEGER dwDesiredAccessas, INTEGER bInheritHandle,; 
   INTEGER dwProcId 
DECLARE INTEGER EnumProcesses IN psapi; 
   STRING @ lpidProcess, INTEGER cb,; 
   INTEGER @ cbNeeded 
DECLARE INTEGER GetModuleBaseName IN psapi; 
   INTEGER hProcess, INTEGER hModule,; 
   STRING @ lpBaseName, INTEGER nSize 
DECLARE INTEGER EnumProcessModules IN psapi; 
   INTEGER hProcess, STRING @ lphModule,; 
   INTEGER cb, INTEGER @ cbNeeded 

LOCAL lcProcBuf, lnBufSize, lnProcessBufRet, lnProcNo, lnProcId,; 
    hProcess, lcModBuf, lnModBufRet, lcBasename, lcst, llret

tcprograma = UPPER(tcprograma)
IF EMPTY(JUSTEXT(tcprograma))
  tcprograma = tcprograma + ".EXE"
ENDIF

lnBufSize = 4096   
lcProcBuf = Repli(Chr(0), lnBufSize) 
lnProcessBufRet = 0 

IF EnumProcesses (@lcProcBuf, lnBufSize, @lnProcessBufRet) = 0 
    ? "Error code:", GetLastError() 
    RETURN 
ENDIF 

lcst = ""
FOR lnProcNo=1 TO lnProcessBufRet/DWORD 
  lnProcId = buf2dword(SUBSTR(lcProcBuf, (lnProcNo-1)*DWORD+1, DWORD)) 

  hProcess = OpenProcess (PROCESS_QUERY_INFORMATION +; 
    PROCESS_VM_READ, 0, lnProcId) 

  IF hProcess  > 0 

    lnBufSize = 4096
    lcModBuf = Repli(Chr(0), lnBufSize) 
    lnModBufRet = 0 

    IF EnumProcessModules(hProcess,@lcModBuf,lnBufSize,@lnModBufRet)  > 0 

      hModule = buf2dword(SUBSTR(lcModBuf,1, DWORD)) 
                  
      lcBasename = SPACE(250) 
      lnBufSize = GetModuleBaseName (hProcess, hModule,; 
        @lcBasename, Len(lcBasename)) 
      lcBasename = UPPER(Left (lcBasename, lnBufSize))

      IF AT(lcBasename,lcst)=0
        lcst = lcst + "," + lcBasename
      ENDIF
    ENDIF 
    = CloseHandle (hProcess) 
    ENDIF 
ENDFOR

IF AT(tcprograma,lcst)>0
  llret = .T.
ELSE
  llret = .F.
ENDIF

RETURN llret
ENDFUNC

FUNCTION  buf2dword (lcBuffer) 
RETURN Asc(SUBSTR(lcBuffer, 1,1)) + ; 
    Asc(SUBSTR(lcBuffer, 2,1)) * 256 +; 
    Asc(SUBSTR(lcBuffer, 3,1)) * 65536 +; 
    Asc(SUBSTR(lcBuffer, 4,1)) * 16777216 
ENDFUNC

************************************************************************************************
FUNCAO PARA MULT_TAREFA


* Adaptado por Eddy Maue
* Decembre le 23,2004
* = execprocess("c:\MonExecutable.exe","1","2")
* possibilidad de hasta 17 parametros
*
* retourne -1 si la tâche est exécutée
* retourne 0 si la tache n'est pas  exécutée

Function ExecProcess
   Lparameters cFile,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p17
   Local ;
      i As Integer

   For i = 2 To Parameters()
      cTransform = "transform(p"+Transform(i)+")"
      m.cFile = m.cFile + " '"+&cTransform+"' "

   Endfor


   #Define NORMAL_PRIORITY_CLASS 32
   #Define IDLE_PRIORITY_CLASS 64
   #Define HIGH_PRIORITY_CLASS 128
   #Define REALTIME_PRIORITY_CLASS 1600

   * Return code from WaitForSingleObject() if
   * it timed out.
   #Define WAIT_TIMEOUT 0x00000102

   * This controls how long, in milli secconds, WaitForSingleObject()
   * waits before it times out. Change this to suit your preferences.
   #Define WAIT_INTERVAL 200

   Declare Integer CreateProcess In kernel32.Dll ;
      INTEGER lpApplicationName, ;
      STRING lpCommandLine, ;
      INTEGER lpProcessAttributes, ;
      INTEGER lpThreadAttributes, ;
      INTEGER bInheritHandles, ;
      INTEGER dwCreationFlags, ;
      INTEGER lpEnvironment, ;
      INTEGER lpCurrentDirectory, ;
      STRING @lpStartupInfo, ;
      STRING @lpProcessInformation

   Declare Integer WaitForSingleObject In kernel32.Dll ;
      INTEGER hHandle, Integer dwMilliseconds

   Declare Integer CloseHandle In kernel32.Dll ;
      INTEGER hObject

   Declare Integer GetLastError In kernel32.Dll


   * STARTUPINFO is 68 bytes, of which we need to
   * initially populate the 'cb' or Count of Bytes member
   * with the overall length of the structure.
   * The remainder should be 0-filled
   Start = long2str(68) + Replicate(Chr(0), 64)

   * PROCESS_INFORMATION structure is 4 longs,
   * or 4*4 bytes = 16 bytes, which we'll fill with nulls.
   process_info = Replicate(Chr(0), 16)


   * Call CreateProcess, obtain a process handle. Treat the
   * application to run as the 'command line' argument, accept
   * all other defaults. Important to pass the start and
   * process_info by reference.
   RetCode = CreateProcess(0, m.cFile+Chr(0), 0, 0, 1, ;
      NORMAL_PRIORITY_CLASS, 0, 0, @Start, @process_info)

   * Unable to run, exit now.
   If RetCode = 0
      =Messagebox("Error occurred. Error code: ", GetLastError())
      Return 0
   Endif

   Local lTerminer
   Do While !lTerminer
      * Use timeout of TIMEOUT_INTERVAL msec so the display
      * will be updated. Otherwise, the VFP window never repaints until
      * the loop is exited.
      If !WaitForSingleObject(RetCode, WAIT_INTERVAL) != WAIT_TIMEOUT
         DoEvents
      Else
         lTerminer = .T.
         * Show a message box when we're done.
         * Close the process handle afterwards.
         RetCode = CloseHandle(RetCode)
         return -1
      Endif
   Enddo


   ********************
Function long2str
   ********************
   * Passed : 32-bit non-negative numeric value (m.longval)
   * Returns : ASCII character representation of passed
   *           value in low-high format (m.retstr)
   * Example :
   *    m.long = 999999
   *    m.longstr = long2str(m.long)

   Parameters m.longval

   Private i, m.retstr

   m.retstr = ""
   For i = 24 To 0 Step -8
      m.retstr = Chr(Int(m.longval/(2^i))) + m.retstr
      m.longval = Mod(m.longval, (2^i))
   Next



   Return m.retstr


   *******************
Function str2long
   *******************
   * Passed:  4-byte character string (m.longstr)
   *   in low-high ASCII format
   * returns:  long integer value
   * example:
   *   m.longstr = "1111"
   *   m.longval = str2long(m.longstr)

   Parameters m.longstr
   Private i, m.retval

   m.retval = 0
   For i = 0 To 24 Step 8
      m.retval = m.retval + (Asc(m.longstr) * (2^i))
      m.longstr = Right(m.longstr, Len(m.longstr) - 1)
   Next
   

Return m.retval




************************************************************************************************
&& CAPTURAR QUALQUER IMAGEM E TAMANHO 

PUBLIC oCapturaImg 
oCapturaImg = CREATEOBJECT("CapturaImagem") 
oCapturaImg.Show() 

DEFINE CLASS CapturaImagem AS Form 
   Height = 147 
   Width = 115 
   Desktop = .T. 
   ShowWindow = 2 
   DoCreate = .T. 
   ShowTips = .T. 
   AutoCenter = .T. 
   Caption = "Captura" 
   HalfHeightCaption = .T. 
   MaxButton = .F. 
   MinButton = .F. 
   MinHeight = 80 
   AlwaysOnTop = .T. 
   Name = "CAPTURA" 

   ADD OBJECT Command1 AS myCmdButton 

   PROCEDURE Init 
      WITH THIS 
         .DeclareFunctions() 
         .Resize() 
      ENDWITH 
   ENDPROC 

   PROCEDURE SetTransparent 
      LOCAL lnControlBottom, lnControlRight, lnControlLeft, lnControlTop, lnBorderWidth, ; 
      lnTitleHeight, lnFormHeight, lnFormWidth, lnInnerRgn, lnOuterRgn, lnCombinedRgn, ; 
      lnControlRgn, lnControl, lnRgnDiff, lnRgnOr, llTrue 

      lnRgnDiff = 4 
      lnRgnOr = 2 
      llTrue = -1 

      WITH THIS 
         lnBorderWidth = SYSMETRIC(3) 
         lnTitleHeight = SYSMETRIC(9)-SYSMETRIC(4) 
         lnFormWidth = .Width + (lnBorderWidth * 2) 
         lnFormHeight = .Height + lnTitleHeight + lnBorderWidth 
         lnOuterRgn = CreateRectRgn(0, 0, lnFormWidth, lnFormHeight) 
         lnInnerRgn = CreateRectRgn(lnBorderWidth, lnTitleHeight, ; 
         lnFormWidth - lnBorderWidth, lnFormHeight - lnBorderWidth) 
         lnCombinedRgn = CreateRectRgn(0, 0, 0, 0) 
         CombineRgn(lnCombinedRgn, lnOuterRgn, lnInnerRgn, lnRgnDiff) 
         FOR EACH Control in .Controls 
            lnControlLeft = Control.Left + lnBorderWidth 
            lnControlTop = Control.Top + lnTitleHeight 
            lnControlRight = Control.Width + lnControlLeft 
            lnControlBottom = Control.Height + lnControlTop 
            lnControlRgn = CreateRectRgn(lnControlLeft, lnControlTop, lnControlRight, lnControlBottom) 
            CombineRgn(lnCombinedRgn, lnCombinedRgn, lnControlRgn, lnRgnOr) 
         ENDFOR 
         SetWindowRgn(.HWnd , lnCombinedRgn, llTrue) 
      ENDWITH 
   ENDPROC 
    
   PROCEDURE num2dword 
      LPARAMETERS lnValue 

      #DEFINE m0       256 
      #DEFINE m1     65536 
      #DEFINE m2  16777216 

      LOCAL b0, b1, b2, b3 

      b3 = INT(lnValue/m2) 
      b2 = INT((lnValue - b3*m2)/m1) 
      b1 = INT((lnValue - b3*m2 - b2*m1)/m0) 
      b0 = MOD(lnValue, m0) 

      RETURN(CHR(b0)+CHR(b1)+CHR(b2)+CHR(b3)) 
   ENDPROC 

   PROCEDURE declarefunctions 
      DECLARE INTEGER CombineRgn in "gdi32" integer hDestRgn, integer hRgn1, integer hRgn2, integer nMode 
      DECLARE INTEGER CreateRectRgn in "gdi32" integer X1, integer Y1, integer X2, integer Y2 
      DECLARE INTEGER SetWindowRgn in "user32" integer hwnd, integer hRgn, integer nRedraw 

      DECLARE INTEGER SelectObject IN gdi32 INTEGER hdc, INTEGER hObject 
      DECLARE INTEGER ReleaseDC IN user32 INTEGER hwnd, INTEGER hdc  
      DECLARE INTEGER CreateCompatibleDC IN gdi32 INTEGER hdc 
      DECLARE INTEGER DeleteObject IN gdi32 INTEGER hObject 
      DECLARE INTEGER DeleteDC IN gdi32 INTEGER hdc 
      DECLARE INTEGER CloseClipboard IN user32  
      DECLARE INTEGER GetFocus IN user32  
      DECLARE INTEGER EmptyClipboard  IN user32  
      DECLARE INTEGER GetWindowDC IN user32 INTEGER hwnd  
      DECLARE INTEGER OpenClipboard IN user32 INTEGER hwnd  
      DECLARE INTEGER SetClipboardData IN user32 INTEGER wFormat, INTEGER hMem 
      DECLARE INTEGER CreateCompatibleBitmap IN gdi32; 
            INTEGER hdc, INTEGER nWidth, INTEGER nHeight 
      DECLARE INTEGER BitBlt IN gdi32; 
            INTEGER hDestDC, INTEGER x, INTEGER y,; 
            INTEGER nWidth, INTEGER nHeight, INTEGER hSrcDC,; 
            INTEGER xSrc, INTEGER ySrc, INTEGER dwRop 

      DECLARE INTEGER GetActiveWindow IN user32 
      DECLARE INTEGER GetClipboardData IN user32 INTEGER uFormat 
      DECLARE INTEGER GlobalAlloc IN kernel32 INTEGER wFlags, INTEGER dwBytes  
      DECLARE INTEGER GlobalFree IN kernel32 INTEGER hMem 

      DECLARE INTEGER GetObject IN gdi32 AS GetObjectA; 
          INTEGER hgdiobj, INTEGER cbBuffer, STRING @lpvObject 

      DECLARE INTEGER GetObjectType IN gdi32 INTEGER h 

      DECLARE RtlZeroMemory IN kernel32 As ZeroMemory; 
          INTEGER dest, INTEGER numBytes 

      DECLARE INTEGER GetDIBits IN gdi32; 
          INTEGER hdc, INTEGER hbmp, INTEGER uStartScan,; 
          INTEGER cScanLines, INTEGER lpvBits, STRING @lpbi,; 
          INTEGER uUsage 

      DECLARE INTEGER CreateFile IN kernel32; 
          STRING lpFileName, INTEGER dwDesiredAccess,; 
          INTEGER dwShareMode, INTEGER lpSecurityAttr,; 
          INTEGER dwCreationDisp, INTEGER dwFlagsAndAttrs,; 
          INTEGER hTemplateFile 

      DECLARE INTEGER CloseHandle IN kernel32 INTEGER hObject 

      DECLARE Sleep IN kernel32 INTEGER dwMilliseconds 
   ENDPROC 

   PROCEDURE CopyToClipBoard 
      WITH THIS 
         .Caption = "Capturando" 
         .Command1.Left = .Width+.Command1.Width 
         .Cls() 
         .SetTransparent() 
         =Sleep(100) 

         #DEFINE CF_BITMAP   2 
         #DEFINE SRCCOPY      13369376 
          
         lnLeft = SYSMETRIC(3) 
         lnTop = SYSMETRIC(4)+(SYSMETRIC(20)-SYSMETRIC(11)) 
         lnRight = 0 
         lnBottom = 0 
         lnWidth = .Width 
         lnHeight = .Height-1 

         *hwnd = GetFocus() 
         hdc = GetWindowDC(.HWnd)    
         hVdc = CreateCompatibleDC(hdc) 
         hBitmap = CreateCompatibleBitmap(hdc, lnWidth, lnHeight) 

         = SelectObject(hVdc, hBitmap) 
         = BitBlt(hVdc, 0, 0, lnWidth, lnHeight, hdc, lnLeft, lnTop, SRCCOPY) 
         = OpenClipboard(.HWnd) 
         = EmptyClipboard() 
         = SetClipboardData(CF_BITMAP, hBitmap) 
         = CloseClipboard() 
         = DeleteObject(hBitmap) 
         = DeleteDC(hVdc) 
         = ReleaseDC(.HWnd, hdc) 
          
         .Command1.Left = VAL(.Command1.Tag) 
         .SetTransparent() 
         .Caption = "Captura" 
      ENDWITH 
   ENDPROC 
    
   PROCEDURE CopyToFile 
      #DEFINE CF_BITMAP   2 
      #DEFINE SRCCOPY     13369376 
      #DEFINE OBJ_BITMAP    7 
      #DEFINE DIB_RGB_COLORS   0 
      #DEFINE BFHDR_SIZE      14 
      #DEFINE BHDR_SIZE       40 
      #DEFINE GENERIC_WRITE          1073741824 
      #DEFINE FILE_SHARE_WRITE                2 
      #DEFINE CREATE_ALWAYS                   2 
      #DEFINE FILE_ATTRIBUTE_NORMAL         128 
      #DEFINE INVALID_HANDLE_VALUE           -1 
      #DEFINE BITMAP_STRU_SIZE   24 
      #DEFINE BI_RGB         0 
      #DEFINE RGBQUAD_SIZE   4 
      #DEFINE BHDR_SIZE     40 
      #DEFINE GMEM_FIXED   0 

      LOCAL cDefault, cNameFile, hClipBmp 
      LOCAL pnWidth, pnHeight, pnBitsSize, pnRgbQuadSize, pnBytesPerScan 
      LOCAL hFile, lnFileSize, lnOffBits, lcBFileHdr 
      LOCAL lnBitsPerPixel, lcBIHdr, lcRgbQuad 
      LOCAL lpBitsArray, lcBInfo 
      LOCAL hdc, hMemDC, lcBuffer 

      cDefault = FULLPATH(SYS(5)) 
      cNameFile = GETPICT("BMP") 
      SET DEFAULT TO (cDefault) 
      IF EMPTY(cNameFile) 
         RETURN 
      ENDIF 

      IF FILE(cNameFile) 
         IF MESSAGEBOX("Esta pasta já contém um arquivo chamado '"+PROPER(JUSTFNAME(cNameFile))+"'"+CHR(13)+"Deseja substituir o arquivo existente?",36+256,"Confirmar substituição de arquivo") = 7 
            RETURN 
         ENDIF 
      ENDIF 
      ERASE (cNameFile) 

      WITH THIS 
         .CopyToClipBoard() 
          
         = OpenClipboard (0)  
         hClipBmp = GetClipboardData (CF_BITMAP) 
         = CloseClipboard() 

         IF hClipBmp = 0 Or GetObjectType(hClipBmp) # OBJ_BITMAP 
            =MESSAGEBOX("Não há imagem armazenada na área de transferência.",48,"Falha ao criar arquivo") 
            RETURN 
         ENDIF 
               
         STORE 0 TO pnWidth, pnHeight, pnBytesPerScan, pnBitsSize, pnRgbQuadSize 
         lcBuffer = REPLI(CHR(0), BITMAP_STRU_SIZE) 
         IF GetObjectA (hClipBmp, BITMAP_STRU_SIZE, @lcBuffer) # 0 
            pnWidth  = ASC(SUBSTR(lcBuffer, 5,1)) + ; 
                      ASC(SUBSTR(lcBuffer, 6,1)) * 256 +; 
                      ASC(SUBSTR(lcBuffer, 7,1)) * 65536 +; 
                      ASC(SUBSTR(lcBuffer, 8,1)) * 16777216 
             
            pnHeight = ASC(SUBSTR(lcBuffer, 9,1)) + ; 
                      ASC(SUBSTR(lcBuffer, 10,1)) * 256 +; 
                      ASC(SUBSTR(lcBuffer, 11,1)) * 65536 +; 
                      ASC(SUBSTR(lcBuffer, 12,1)) * 16777216 
         ENDIF 

         lnBitsPerPixel = 24 
         pnBytesPerScan = INT((pnWidth * lnBitsPerPixel)/8) 
         IF MOD(pnBytesPerScan, 4) # 0 
            pnBytesPerScan = pnBytesPerScan + 4 - MOD(pnBytesPerScan, 4) 
         ENDIF 

         lcBIHdr = .num2dword(BHDR_SIZE) + .num2dword(pnWidth) +; 
                 .num2dword(pnHeight) + (CHR(MOD(1,256))+CHR(INT(1/256))) + (CHR(MOD(lnBitsPerPixel,256))+CHR(INT(lnBitsPerPixel/256))) +; 
                 .num2dword(BI_RGB) + REPLI(CHR(0), 20) 

         IF lnBitsPerPixel <= 8 
            pnRgbQuadSize = (2^lnBitsPerPixel) * RGBQUAD_SIZE 
            lcRgbQuad = REPLI(CHR(0), pnRgbQuadSize) 
         ELSE 
            lcRgbQuad = "" 
         ENDIF 
         lcBInfo = lcBIHdr + lcRgbQuad 
         pnBitsSize = pnHeight * pnBytesPerScan 
         lpBitsArray = GlobalAlloc (GMEM_FIXED, pnBitsSize) 
         = ZeroMemory (lpBitsArray, pnBitsSize) 

         *hwnd = GetActiveWindow() 
         hdc = GetWindowDC(.HWnd) 
         hMemDC = CreateCompatibleDC (hdc) 
         = ReleaseDC (.HWnd, hdc) 
         = GetDIBits (hMemDC, hClipBmp, 0, pnHeight, lpBitsArray, @lcBInfo, DIB_RGB_COLORS) 

         lnFileSize = BFHDR_SIZE + BHDR_SIZE + pnRgbQuadSize + pnBitsSize 
         lnOffBits = BFHDR_SIZE + BHDR_SIZE + pnRgbQuadSize 
         lcBFileHdr = "BM" + .num2dword(lnFileSize) + .num2dword(0) + .num2dword(lnOffBits) 

         hFile = CreateFile (cNameFile, GENERIC_WRITE, FILE_SHARE_WRITE, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0) 

         IF hFile # INVALID_HANDLE_VALUE 
            DECLARE INTEGER WriteFile IN kernel32; 
               INTEGER hFile, STRING @lpBuffer, INTEGER nBt2Write,; 
               INTEGER @lpBtWritten, INTEGER lpOverlapped 
            = WriteFile (hFile, @lcBFileHdr, Len(lcBFileHdr), 0, 0) 
            = WriteFile (hFile, @lcBInfo, Len(lcBInfo), 0, 0) 

            DECLARE INTEGER WriteFile IN kernel32; 
               INTEGER hFile, INTEGER lpBuffer, INTEGER nBt2Write,; 
               INTEGER @lpBtWritten, INTEGER lpOverlapped 
            = WriteFile (hFile, lpBitsArray, pnBitsSize, 0, 0) 
            = CloseHandle (hFile) 
         ELSE 
            = MESSAGEBOX("Falha ao criar o arquivo: " + cNameFile, "Operação não concluída") 
         ENDIF 

         = GlobalFree(lpBitsArray) 
         = DeleteDC (hMemDC) 
         = DeleteObject (hClipBmp) 
      ENDWITH 
   ENDPROC 

   PROCEDURE Resize 
      WITH THIS 
         .Command1.Left = .Width-.Command1.Width 
         .Command1.Top = .Height-.Command1.Height 
         .Command1.Tag = ALLT(STR(.Command1.Left)) 

         .SetTransparent() 
      ENDWITH 
   ENDPROC 
    
   PROCEDURE Destroy 
      oCapturaImg = .F. 
      RELEASE oCapturaImg    
   ENDPROC 
ENDDEFINE 

DEFINE CLASS myCmdButton AS Commandbutton 
   Top = 126 
   Left = 97 
   Height = 21 
   Width = 18 
   FontName = "Webdings" 
   Caption = "6" 
   ToolTipText = "Opções" 
   Name = "Command1" 

   PROCEDURE Click 
      cOptMenu = "" 
      DEFINE POPUP _menu_clip SHORTCUT RELATIVE FROM MROW(), MCOL() 
      DEFINE BAR       CNTBAR("_menu_clip")+1 OF _menu_clip PROMPT "Copiar para a área de transferência" 
      ON SELECTION BAR CNTBAR("_menu_clip")   OF _menu_clip        cOptMenu = "CLIPBOARD" 
      DEFINE BAR       CNTBAR("_menu_clip")+1 OF _menu_clip PROMPT "Copiar para um arquivo" 
      ON SELECTION BAR CNTBAR("_menu_clip")   OF _menu_clip        cOptMenu = "FILE" 
      ACTIVATE POPUP _menu_clip 
      RELEASE POPUPS _menu_clip 

      DO CASE 
         CASE cOptMenu == "CLIPBOARD" 
            THISFORM.CopyToClipBoard() 

         CASE cOptMenu == "FILE" 
            THISFORM.CopyToFile() 
      ENDCASE 
   ENDPROC 
ENDDEFINE
************************************************************************************************
&& Mover e ajustar tamanho de um botao


PUBLIC loForm1
loForm1 = CREATEOBJECT("Form1")
loForm1.SHOW(1)

DEFINE CLASS Form1 AS FORM
  TOP = 0
  LEFT = 0
  HEIGHT = 225
  WIDTH = 276
  AUTOCENTER = .T.
  CAPTION = "Mover y ajustar controles"
  xoffset = 0
  yoffset = 0
  NAME = "Form1"
  ADD OBJECT command10 AS COMMANDBUTTON WITH ;
    TOP = 68, LEFT = 84, ;
    HEIGHT = 49, WIDTH = 84, ;
    CAPTION = "Mi botón", NAME = "Command10"
  ADD OBJECT check1 AS CHECKBOX WITH ;
    TOP = 20, LEFT = 54, ;
    HEIGHT = 17, WIDTH = 60, ;
    CAPTION = "Mover", NAME = "Check1"
  ADD OBJECT check2 AS CHECKBOX WITH ;
    TOP = 20, LEFT = 161, ;
    HEIGHT = 17, WIDTH = 60, ;
    CAPTION = "Ajustar", NAME = "Check2"
  ADD OBJECT label1 AS LABEL WITH ;
    CAPTION = [Para mover el botón deberá activar la ] + ;
    [casilla "Mover", y para ajustar su Height y ] + ;
    [Width, active la casilla "Ajustar"], ;
    HEIGHT = 60, LEFT = 6, ;
    TOP = 161, WIDTH = 267, ;
    NAME = "Label1", WORDWRAP = .T.
  PROCEDURE ajustar
    LPARAMETERS oSource, nXCoord, nYCoord, nPosicion
    IF nPosicion = 1
      oSource.WIDTH = nXCoord - oSource.LEFT
    ELSE
      oSource.HEIGHT = nYCoord - oSource.TOP
    ENDIF
  ENDPROC
  PROCEDURE DRAGDROP
    LPARAMETERS oSource, nXCoord, nYCoord
    oSource.LEFT = nXCoord - THISFORM.XOffset
    oSource.TOP = nYCoord - THISFORM.YOffset
  ENDPROC
  PROCEDURE command10.DRAGDROP
    LPARAMETERS oSource, nXCoord, nYCoord
    THIS.PARENT.DRAGDROP(oSource, nXCoord, nYCoord)
  ENDPROC
  PROCEDURE command10.CLICK
    MESSAGEBOX("Left: "+TRANSFORM(THIS.LEFT)+CHR(13)+;
      "Top: "+TRANSFORM(THIS.TOP)+CHR(13)+;
      "Width: "+TRANSFORM(THIS.WIDTH)+CHR(13)+;
      "height: "+TRANSFORM(THIS.HEIGHT))
  ENDPROC
  PROCEDURE command10.MOUSEMOVE
    LPARAMETERS nButton, nShift, nXCoord, nYCoord
    IF THISFORM.Check1.VALUE = 1
      IF nButton = 1 && Left button
        THISFORM.XOffset = nXCoord - THIS.LEFT
        THISFORM.YOffset = nYCoord - THIS.TOP
        THIS.DRAG
      ENDIF
    ENDIF
    IF THISFORM.check2.VALUE = 1
      THISFORM.XOffset = nXCoord - THIS.LEFT
      THISFORM.YOffset = nYCoord - THIS.TOP
      DO CASE
        CASE BETWEEN(THISFORM.XOffSet,THIS.WIDTH - 8,THIS.WIDTH + 8)
          THIS.MOUSEPOINTER = 9
          IF nButton = 1
            THISFORM.Ajustar(THIS,nXCoord,nYCoord,1)
          ENDIF
        CASE BETWEEN(THISFORM.YOffSet,THIS.HEIGHT - 8,THIS.HEIGHT + 8)
          THIS.MOUSEPOINTER = 7
          IF nButton = 1
            THISFORM.Ajustar(THIS,nXCoord,nYCoord,2)
          ENDIF
        OTHERWISE
          THIS.MOUSEPOINTER = 0
      ENDCASE
    ENDIF
  ENDPROC
  PROCEDURE check1.CLICK
    IF THIS.VALUE = 1
      THIS.PARENT.check2.VALUE = 0
    ENDIF
  ENDPROC
  PROCEDURE check2.CLICK
    IF THIS.VALUE = 1
      THIS.PARENT.check1.VALUE = 0
    ENDIF
  ENDPROC
ENDDEFINE
************************************************************************************************
CONECTAR A INTERNET

DECLARE INTEGER InternetGetConnectedState IN WinInet INTEGER @ , INTEGER 
? PruebaLinea () 
FUNCTION PruebaLinea 
IF InternetGetConnectedState(0,0) <> 0 
RETURN .T. 
ELSE 
RETURN .F. 
ENDIF 
ENDFUNC 

************************************************************************************************
pessoal estou quebrando a cabeça e naun consigo achar a formula para o seguinte calculo 

tenho um cheque no valor de 3600 e quero descontar no banco 106 dias antes do vencimento e o banco cobra uma taxa de juros e 2,03 ao mes, quanto o banco ira me pagar ? 

o valor que o banco me pagou foi de R$ 3350,82 

mais qual a formula que eles usaram para chegar a este valor ?

*****
A fórmula é a seguinte: 
Pega a taxa do banco, divida por 100 e some 1: fica 

1+ 0,0203 = 1,0203 

Para se saber o total de juros, utilize a fórmula: 

J=C((1+1)^N-1) 

onde N é o prazo (106/30, no caso) 

Logo: 

J=3600((1,0203)^(106/30)-1) 
J=264,93 

3600-264,93 = 3335,07 

Geralmente, essa é a fórmula que eles usam para Juros Compostos; pode dar uma diferença por causa do arrendondamento.

****

Outra opção seria: 
Valor nominal ---------- 3600 
(-) desconto (capital*juros*tempo) -> 3600*2,03%*106/30=258,3 
(-) IOF (3600*106*0,000041) = 15,70 
valor a receber -> 3.326,00

 

*****
Com o criador de menus aberto, encontre View no menu principal do seu FoxPro e clique em General Options. Marque a opção Top-Level Form do seu menu. 

No método Load do seu form coloque o seguinte código: 
DO nome_menu.MPR WITH THISFORM, "apelido_menu" 

Nota. Não utilize THISFORM de dentro do menu. Lance seu form utilizando a cláusula NAME. 

Exemplo: DO FORM form.scx NAME "CADASTRO" 

e dentro do seu menu utilize: CADASTRO.Command1.Click() 

Compreendeu?


************************************************************************************************
Manter uma IMAGEM centralizada na _SCREENN

_SCREEN.ADDOBJECT("oImagen","MiImagen")
WITH _Screen.oImagen
  .PICTURE = "C:\MiImagen.jpg"
  .LEFT = INT(_SCREEN.WIDTH  - .WIDTH)/ 2
  .TOP = INT(_SCREEN.HEIGHT - .HEIGHT)/ 2
  .VISIBLE = .T.
ENDWITH

BINDEVENT(_SCREEN,"Resize",_SCREEN.oImagen,"MiMetodo")

DEFINE CLASS MiImagen AS IMAGE
  PROCEDURE MiMetodo
    WITH THIS
      .LEFT = INT(_SCREEN.WIDTH  - .WIDTH)/ 2
      .TOP = INT(_SCREEN.HEIGHT - .HEIGHT)/ 2
    ENDWITH
  ENDPROC
  PROCEDURE DESTROY
    UNBINDEVENT(THIS)
  ENDPROC
ENDDEFINE

************************************************************************************************
*******************************
*!* Ejemplo de utilización de SendViaMAPI
*******************************
DIMENSION aryAttach(2)
aryAttach(1) = "C:\attachment1.txt" && cambie a un archivo real que existe en su PC
aryAttach(2) = "C:\attachment2.zip" && cambie a un archivo real que existe en su PC
LOCAL lcTo, lcSubject, lcBody, lnCount, lcCC, lcBCC, lcUserName, lcPassword, llOpenEmail, lcErrReturn
lcTo = "alguien@algundominio.com"
lcSubject = "¿Ha intentado enviar un email con VFP?"
lcBody = "Quiero hacerle saber que VFP es muy versátil" + CHR(13) + "y hay muchas formas de enviar un email."
lcCC = "otro@otrodominio.com"
lcBCC = "mijefe@dominiodeljefe.com"
lcUserName = "yo@midominio.com" && mi nombre de usuario SMTP 
lcPassword = "Mi_PaSsWoRd" && mi contraseña SMTP 
*!* para enviar correo automáticamente haga llOpenEmail igual a .F.
llOpenEmail = .T. && Si el correo se abrió o no, en el cliente de correo MAPI
SendViaMAPI(@lcErrReturn, lcTo, lcSubject, lcBody, @aryAttach, lcCC, lcBCC, lcUserName, lcPassword, llOpenEmail)
IF EMPTY(lcErrReturn)
  MESSAGEBOX("'" + lcSubject + "'  se envió satisfactoriamente.", 64, "Envía email via MAPI")
ELSE
  MESSAGEBOX("'" + lcSubject + "' falló al enviar. Causa:" + CHR(13) + lcErrReturn, 64, "Envía email via MAPI")
ENDIF

*******************************************
PROCEDURE SendViaMAPI(tcReturn, tcTo, tcSubject, tcBody, taFiles, tcCC, tcBCC, tcUserName, tcPassword, tlOpenEmail)
*******************************************
  #DEFINE PRIMARY 1
  #DEFINE CARBON_COPY 2
  #DEFINE BLIND_CARBON_COPY 3
  LOCAL loSession, loMessages, lnAttachments, loError AS EXCEPTION, loErrorSend AS EXCEPTION
  tcReturn = ""
  TRY
    loSession = CREATEOBJECT( "MSMAPI.MAPISession" )
    IF TYPE("tcUserName") = "C"
      loSession.UserName = tcUserName
    ENDIF
    IF TYPE("tcPassword") = "C"
      loSession.PASSWORD = tcPassword
    ENDIF
    loSession.Signon()
    IF (loSession.SessionID > 0)
      loMessages = CREATEOBJECT( "MSMAPI.MAPIMessages" )
      loMessages.SessionID = loSession.SessionID
    ENDIF
    WITH loMessages
      .Compose()
      .RecipDisplayName = tcTo
      .RecipType = PRIMARY
      .ResolveName()
      IF TYPE("tcCC") = "C"
        .RecipIndex = .RecipCount
        .RecipDisplayName = tcCC
        .RecipType = CARBON_COPY
        .ResolveName()
      ENDIF
      IF TYPE("tcBCC") = "C"
        .RecipIndex = .RecipCount
        .RecipDisplayName = tcBCC
        .RecipType = BLIND_CARBON_COPY
        .ResolveName()
      ENDIF
      .MsgSubject = tcSubject
      .MsgNoteText = tcBody
      IF TYPE("taFiles", 1) = "A"
        lnAttachments = ALEN(taFiles)
        IF LEN(tcBody) < lnAttachments && Se asegura que el cuerpo es suficientemente grande para los adjuntos
          tcBody = PADR(tcBody, lnAttachments, " ")
        ENDIF
        FOR lnCountAttachments = 1 TO lnAttachments
          .AttachmentIndex = .AttachmentCount
          .AttachmentPosition = .AttachmentIndex
          .AttachmentName = JUSTFNAME(taFiles(lnCountAttachments))
          .AttachmentPathName = taFiles(lnCountAttachments)
        ENDFOR
      ENDIF
      TRY
        .SEND(tlOpenEmail)
      CATCH TO loErrorSend
        IF tlOpenEmail && El usuario canceló la operación desde su cliente de correo?
          tcReturn = "El usuario canceló el envío de correo."
        ELSE
          THROW loErrorSend
        ENDIF
      ENDTRY
    ENDWITH
    loSession.Signoff()
  CATCH TO loError
    tcReturn = [Error: ] + STR(loError.ERRORNO) + CHR(13) + ;
      [LineNo: ] + STR(loError.LINENO) + CHR(13) + ;
      [Message: ] + loError.MESSAGE + CHR(13) + ;
      [Procedure: ] + loError.PROCEDURE + CHR(13) + ;
      [Details: ] + loError.DETAILS + CHR(13) + ;
      [StackLevel: ] + STR(loError.STACKLEVEL) + CHR(13) + ;
      [LineContents: ] + loError.LINECONTENTS
  FINALLY
    STORE .NULL. TO loSession, loMessages
    RELEASE loSession, loMessages
  ENDTRY
ENDPROC
************************************************************************************************

Criar um atalho 

&&ATALHOS 

WshShell = CreateObject("WScript.Shell") 

atalhoLnk = WshShell.CreateShortcut("caminho\arquivo.lnk") &&Caminho de saída do arquivo 

atalhoLnk.TargetPath = "caminho\arquivo.ext" &&local do arquivo / para pasta só o caminho 

atalhoLnk.Save && salvar atalho
************************************************************************************************

HTM como texto no Microsot Outlook:

ctexto = vpdefaulte+"\TEMP\EMAIL.HTM"

oMSG.htmlbody = (cTexto) && o corpo do e-mail em HTML

oMSG.Attachments.Add(ctexto)

Até mais ver...


************************************************************************************************
*** Guardar posicao do FORM
PUBLIC oMiForm
oMiForm = CREATEOBJECT("MiForm")
oMiForm.SHOW(1)
RETURN

DEFINE CLASS MiForm AS FORM
  TOP = 10
  LEFT = 10
  HEIGHT = 180
  WIDTH = 324
  CAPTION = "Guardar posición, tamaño y color de fondo"
  BACKCOLOR = RGB(200,220,255)
  NAME = "frmMiForm"

  ADD OBJECT cmdColor AS COMMANDBUTTON WITH ;
    TOP = 12, LEFT = 12, HEIGHT = 27, WIDTH = 132, ;
    CAPTION = "Cambiar BackColor", NAME = "cmdColor"

  ADD OBJECT cmdSalir AS COMMANDBUTTON WITH ;
    TOP = 48, LEFT = 12, HEIGHT = 27, WIDTH = 132, ;
    CAPTION = "Salir", NAME = "cmdSalir"

  ADD OBJECT lblAyuda AS LABEL WITH ;
    AUTOSIZE = .T., WORDWRAP = .T., BACKSTYLE = 0, ;
    CAPTION = "Cambie la posición, tamaño y color del " + ;
    "formulario. Salga del formulario y ejecutelo nuevamente.", ;
    FONTSIZE = 12, LEFT = 12, TOP = 96, NAME = "lblAyuda"

  PROCEDURE INIT
    THISFORM.InicializarPropiedades()
    THISFORM.TomarPropiedades()
    THISFORM.RESIZE
  ENDPROC

  PROCEDURE DESTROY
    THISFORM.GuardarPropiedades()
  ENDPROC

  PROCEDURE RESIZE
    THISFORM.lblAyuda.WIDTH = THISFORM.WIDTH - 24
  ENDPROC

  PROCEDURE InicializarPropiedades
    LOCAL lcScx
    *-- Creo propiedades
    THISFORM.ADDPROPERTY("Prop_Alias")
    THISFORM.ADDPROPERTY("Prop_Tabla")
    *-- Nombre de la tabla de propiedades
    lcScx = SYS(1271,THISFORM)
    THISFORM.Prop_Alias = "_Prop_" + IIF(EMPTY(lcScx),"Form",JUSTSTEM(lcForm))
    THISFORM.Prop_Tabla = FORCEEXT(FULLPATH("")+ THISFORM.Prop_Alias, "DBF")
    *-- Si no existe la tabla la creo
    IF NOT FILE(THISFORM.Prop_Tabla)
      CREATE TABLE (THISFORM.Prop_Tabla) FREE ;
        (TOP I, LEFT I, WIDTH I, HEIGHT I, BACKCOLOR I)
      APPEND BLANK
      GATHER NAME THISFORM
      USE IN SELECT(THISFORM.Prop_Alias)
    ENDIF
  ENDPROC

  PROCEDURE TomarPropiedades
    *-- Tomo las propiedades de la tabla
    SELECT 0
    USE (THISFORM.Prop_Tabla)
    SCATTER NAME THISFORM ADDITIVE
    USE IN SELECT(THISFORM.Prop_Alias)
  ENDPROC

  PROCEDURE GuardarPropiedades
    *-- Guardo las propiedades en la tabla
    SELECT 0
    USE (THISFORM.Prop_Tabla)
    GATHER NAME THISFORM
    USE IN SELECT(THISFORM.Prop_Alias)
  ENDPROC

  PROCEDURE cmdColor.CLICK
    THISFORM.BACKCOLOR = GETCOLOR(THISFORM.BACKCOLOR)
  ENDPROC

  PROCEDURE cmdSalir.CLICK
    THISFORM.RELEASE
  ENDPROC

ENDDEFINE


************************************************************************************************
Itamar,
exite uma forma de desabilitar a tecla da jenalinha que vc esta mencionando.
Esta janelinha esta associada ao botão INICIAR de windows.
Vc tem como desabilitar o botão e retornar, não isto não impede o teclado.
Vc tem que APAGAR o botão INICIAR, pois o usuário pode usar o mouse para
ativar o mesmo menu.
O problema deste comando é que quando vc apaga o botão INICIAR que é uma
tarefa do windows, vc só pode reexibir o botão novamente se der um reboot no
SO.
Ao mesmo tempo, se vc usar a instrução para apagar o botão INICIAR, o
usuário do windows só podera fechar/sair do SO se der um CTRL + Alt + Del e
escolher finalizar ou reboot.
Não conheço outra forma e a MS é contra este tipo de solução.

Somente o segundo código faz o que vc deseja.....

* 1) Desabilitar o botão START da barra de tarefas...
Declare INTEGER FindWindowEx IN user32.dll ;
Long, Long, string, String

Declare INTEGER EnableWindow IN user32.dll Long, Long

=EnableStartMenuButton(0)
=INKEY(15)
=EnableStartMenuButton(1)

PROCEDURE EnableStartMenuButton(liEnable)
* Não esquecer de reativar
LOCAL lHwnd
lHwnd = FindWindowEx(0, 0, "Shell_TrayWnd", .NULL.)
lHwnd = FindWindowEx(lHwnd, 0, "Button", .NULL.)
=EnableWindow(lHwnd, liEnable)

****
* 2) Apagar o botão start ( só retorna se de boot )
DECLARE LONG FindWindow IN "user32" STRING lpClassName, STRING lpWindowName
DECLARE LONG SendMessage IN "user32" LONG hWnd, LONG wMsg, LONG wParam, LONG
lParam
DECLARE LONG FindWindowEx IN "user32" LONG hWnd1, LONG hWnd2, STRING lpsz1,
STRING lpsz2
#DEFINE WM_CLOSE 0x10
SendMessage(FindWindowEx(FindWindow("Shell_TrayWnd", ""), 0x0, "Button",
.NULL.), WM_CLOSE, 0, 0)

[ ]´s
Peter

************************************************************************************************

O codigo abaixo visualiza um report em janela propria com caption e icone, alem
de maximar e ajustar o toolbar, coloca tambem o numero total de paginas do
relatorio.

Espero que seja util a alguem:

DEFINE WINDOW rptview FROM 2,1 TO 30,80 ;
SYSTEM TITLE 'Minha Impressão' ;
NOCLOSE FLOAT GROW ZOOM ICON FILE 'printer.ico'
KEYBOARD '{CTRL+F10}' && Optional to force window full screen
nTotalPages = 0
REPORT FORM meureport NOCONSOLE
nTotalPages = _pageno
REPORT ForM meureport preview NOCONSOLE WINDOW rptview
RELEASE WINDOW rptview

obs.: No textbox que vai a numeracao de pagina coloque o seguinte na expressao:

"Pagina " + ALLTRIM(STR(_pageno)) + " de " + ALLTRIM(STR(nTotalPages))



************************************************************************************************
AUTOREGISTRAR OCX E DLLS 

Código: 
DECLARE LONG DllRegisterServer IN [arquivo.ocx] 
IF DllRegisterServer() = 0 
    messagebox('REGISTRADO !!!') 
ELSE 
    messagebox('NÃO REGISTRADO !!!') 
ENDIF 

************************************************************************************************
Somar arquivos texto com FileSystemObject


ofs = createobject("scripting.filesystemobject")
ob1 = ofs.OpenTextFile("Fichero1")
ob2 = ofs.OpenTextFile("Fichero2")
ob3 = ofs.CreateTextFile("NuevoFichero")
ob3.Write(ob1.ReadAll)
ob3.Write(ob2.ReadAll)
ob1.Close
ob2.Close
ob3.Close
release ofs,ob1,ob2,ob3
 

************************************************************************************************
CAPTURAR QUALQUER IMAGEM E TAMANHO 

Este pequeno, mas poderoso exemplo utiliza somente APIs de acesso a memória e conversão de dados para a área de transferência do Windows. Não utiliza OCX e pode funcionar desde a versão 5 até a 9 do FoxPro. Desenvolvi este algoritmo porque percebi que muitas pessoas vem procurado recursos para WebCams e outros acessórios de imagem conectados ao programa. Este exemplo demonstra mais uma vez que podemos fazer misérias com o Visual FoxPro. Veja o que eu fiz com um simples form! 

Código: 
PUBLIC oCapturaImg 
oCapturaImg = CREATEOBJECT("CapturaImagem") 
oCapturaImg.Show() 

DEFINE CLASS CapturaImagem AS Form 
   Height = 147 
   Width = 115 
   Desktop = .T. 
   ShowWindow = 2 
   DoCreate = .T. 
   ShowTips = .T. 
   AutoCenter = .T. 
   Caption = "Captura" 
   HalfHeightCaption = .T. 
   MaxButton = .F. 
   MinButton = .F. 
   MinHeight = 80 
   AlwaysOnTop = .T. 
   Name = "CAPTURA" 

   ADD OBJECT Command1 AS myCmdButton 

   PROCEDURE Init 
      WITH THIS 
         .DeclareFunctions() 
         .Resize() 
      ENDWITH 
   ENDPROC 

   PROCEDURE SetTransparent 
      LOCAL lnControlBottom, lnControlRight, lnControlLeft, lnControlTop, lnBorderWidth, ; 
      lnTitleHeight, lnFormHeight, lnFormWidth, lnInnerRgn, lnOuterRgn, lnCombinedRgn, ; 
      lnControlRgn, lnControl, lnRgnDiff, lnRgnOr, llTrue 

      lnRgnDiff = 4 
      lnRgnOr = 2 
      llTrue = -1 

      WITH THIS 
         lnBorderWidth = SYSMETRIC(3) 
         lnTitleHeight = SYSMETRIC(9)-SYSMETRIC(4) 
         lnFormWidth = .Width + (lnBorderWidth * 2) 
         lnFormHeight = .Height + lnTitleHeight + lnBorderWidth 
         lnOuterRgn = CreateRectRgn(0, 0, lnFormWidth, lnFormHeight) 
         lnInnerRgn = CreateRectRgn(lnBorderWidth, lnTitleHeight, ; 
         lnFormWidth - lnBorderWidth, lnFormHeight - lnBorderWidth) 
         lnCombinedRgn = CreateRectRgn(0, 0, 0, 0) 
         CombineRgn(lnCombinedRgn, lnOuterRgn, lnInnerRgn, lnRgnDiff) 
         FOR EACH Control in .Controls 
            lnControlLeft = Control.Left + lnBorderWidth 
            lnControlTop = Control.Top + lnTitleHeight 
            lnControlRight = Control.Width + lnControlLeft 
            lnControlBottom = Control.Height + lnControlTop 
            lnControlRgn = CreateRectRgn(lnControlLeft, lnControlTop, lnControlRight, lnControlBottom) 
            CombineRgn(lnCombinedRgn, lnCombinedRgn, lnControlRgn, lnRgnOr) 
         ENDFOR 
         SetWindowRgn(.HWnd , lnCombinedRgn, llTrue) 
      ENDWITH 
   ENDPROC 
    
   PROCEDURE num2dword 
      LPARAMETERS lnValue 

      #DEFINE m0       256 
      #DEFINE m1     65536 
      #DEFINE m2  16777216 

      LOCAL b0, b1, b2, b3 

      b3 = INT(lnValue/m2) 
      b2 = INT((lnValue - b3*m2)/m1) 
      b1 = INT((lnValue - b3*m2 - b2*m1)/m0) 
      b0 = MOD(lnValue, m0) 

      RETURN(CHR(b0)+CHR(b1)+CHR(b2)+CHR(b3)) 
   ENDPROC 

   PROCEDURE declarefunctions 
      DECLARE INTEGER CombineRgn in "gdi32" integer hDestRgn, integer hRgn1, integer hRgn2, integer nMode 
      DECLARE INTEGER CreateRectRgn in "gdi32" integer X1, integer Y1, integer X2, integer Y2 
      DECLARE INTEGER SetWindowRgn in "user32" integer hwnd, integer hRgn, integer nRedraw 

      DECLARE INTEGER SelectObject IN gdi32 INTEGER hdc, INTEGER hObject 
      DECLARE INTEGER ReleaseDC IN user32 INTEGER hwnd, INTEGER hdc  
      DECLARE INTEGER CreateCompatibleDC IN gdi32 INTEGER hdc 
      DECLARE INTEGER DeleteObject IN gdi32 INTEGER hObject 
      DECLARE INTEGER DeleteDC IN gdi32 INTEGER hdc 
      DECLARE INTEGER CloseClipboard IN user32  
      DECLARE INTEGER GetFocus IN user32  
      DECLARE INTEGER EmptyClipboard  IN user32  
      DECLARE INTEGER GetWindowDC IN user32 INTEGER hwnd  
      DECLARE INTEGER OpenClipboard IN user32 INTEGER hwnd  
      DECLARE INTEGER SetClipboardData IN user32 INTEGER wFormat, INTEGER hMem 
      DECLARE INTEGER CreateCompatibleBitmap IN gdi32; 
            INTEGER hdc, INTEGER nWidth, INTEGER nHeight 
      DECLARE INTEGER BitBlt IN gdi32; 
            INTEGER hDestDC, INTEGER x, INTEGER y,; 
            INTEGER nWidth, INTEGER nHeight, INTEGER hSrcDC,; 
            INTEGER xSrc, INTEGER ySrc, INTEGER dwRop 

      DECLARE INTEGER GetActiveWindow IN user32 
      DECLARE INTEGER GetClipboardData IN user32 INTEGER uFormat 
      DECLARE INTEGER GlobalAlloc IN kernel32 INTEGER wFlags, INTEGER dwBytes  
      DECLARE INTEGER GlobalFree IN kernel32 INTEGER hMem 

      DECLARE INTEGER GetObject IN gdi32 AS GetObjectA; 
          INTEGER hgdiobj, INTEGER cbBuffer, STRING @lpvObject 

      DECLARE INTEGER GetObjectType IN gdi32 INTEGER h 

      DECLARE RtlZeroMemory IN kernel32 As ZeroMemory; 
          INTEGER dest, INTEGER numBytes 

      DECLARE INTEGER GetDIBits IN gdi32; 
          INTEGER hdc, INTEGER hbmp, INTEGER uStartScan,; 
          INTEGER cScanLines, INTEGER lpvBits, STRING @lpbi,; 
          INTEGER uUsage 

      DECLARE INTEGER CreateFile IN kernel32; 
          STRING lpFileName, INTEGER dwDesiredAccess,; 
          INTEGER dwShareMode, INTEGER lpSecurityAttr,; 
          INTEGER dwCreationDisp, INTEGER dwFlagsAndAttrs,; 
          INTEGER hTemplateFile 

      DECLARE INTEGER CloseHandle IN kernel32 INTEGER hObject 

      DECLARE Sleep IN kernel32 INTEGER dwMilliseconds 
   ENDPROC 

   PROCEDURE CopyToClipBoard 
      WITH THIS 
         .Caption = "Capturando" 
         .Command1.Left = .Width+.Command1.Width 
         .Cls() 
         .SetTransparent() 
         =Sleep(100) 

         #DEFINE CF_BITMAP   2 
         #DEFINE SRCCOPY      13369376 
          
         lnLeft = SYSMETRIC(3) 
         lnTop = SYSMETRIC(4)+(SYSMETRIC(20)-SYSMETRIC(11)) 
         lnRight = 0 
         lnBottom = 0 
         lnWidth = .Width 
         lnHeight = .Height-1 

         *hwnd = GetFocus() 
         hdc = GetWindowDC(.HWnd)    
         hVdc = CreateCompatibleDC(hdc) 
         hBitmap = CreateCompatibleBitmap(hdc, lnWidth, lnHeight) 

         = SelectObject(hVdc, hBitmap) 
         = BitBlt(hVdc, 0, 0, lnWidth, lnHeight, hdc, lnLeft, lnTop, SRCCOPY) 
         = OpenClipboard(.HWnd) 
         = EmptyClipboard() 
         = SetClipboardData(CF_BITMAP, hBitmap) 
         = CloseClipboard() 
         = DeleteObject(hBitmap) 
         = DeleteDC(hVdc) 
         = ReleaseDC(.HWnd, hdc) 
          
         .Command1.Left = VAL(.Command1.Tag) 
         .SetTransparent() 
         .Caption = "Captura" 
      ENDWITH 
   ENDPROC 
    
   PROCEDURE CopyToFile 
      #DEFINE CF_BITMAP   2 
      #DEFINE SRCCOPY     13369376 
      #DEFINE OBJ_BITMAP    7 
      #DEFINE DIB_RGB_COLORS   0 
      #DEFINE BFHDR_SIZE      14 
      #DEFINE BHDR_SIZE       40 
      #DEFINE GENERIC_WRITE          1073741824 
      #DEFINE FILE_SHARE_WRITE                2 
      #DEFINE CREATE_ALWAYS                   2 
      #DEFINE FILE_ATTRIBUTE_NORMAL         128 
      #DEFINE INVALID_HANDLE_VALUE           -1 
      #DEFINE BITMAP_STRU_SIZE   24 
      #DEFINE BI_RGB         0 
      #DEFINE RGBQUAD_SIZE   4 
      #DEFINE BHDR_SIZE     40 
      #DEFINE GMEM_FIXED   0 

      LOCAL cDefault, cNameFile, hClipBmp 
      LOCAL pnWidth, pnHeight, pnBitsSize, pnRgbQuadSize, pnBytesPerScan 
      LOCAL hFile, lnFileSize, lnOffBits, lcBFileHdr 
      LOCAL lnBitsPerPixel, lcBIHdr, lcRgbQuad 
      LOCAL lpBitsArray, lcBInfo 
      LOCAL hdc, hMemDC, lcBuffer 

      cDefault = FULLPATH(SYS(5)) 
      cNameFile = GETPICT("BMP") 
      SET DEFAULT TO (cDefault) 
      IF EMPTY(cNameFile) 
         RETURN 
      ENDIF 

      IF FILE(cNameFile) 
         IF MESSAGEBOX("Esta pasta já contém um arquivo chamado '"+PROPER(JUSTFNAME(cNameFile))+"'"+CHR(13)+"Deseja substituir o arquivo existente?",36+256,"Confirmar substituição de arquivo") = 7 
            RETURN 
         ENDIF 
      ENDIF 
      ERASE (cNameFile) 

      WITH THIS 
         .CopyToClipBoard() 
          
         = OpenClipboard (0)  
         hClipBmp = GetClipboardData (CF_BITMAP) 
         = CloseClipboard() 

         IF hClipBmp = 0 Or GetObjectType(hClipBmp) # OBJ_BITMAP 
            =MESSAGEBOX("Não há imagem armazenada na área de transferência.",48,"Falha ao criar arquivo") 
            RETURN 
         ENDIF 
               
         STORE 0 TO pnWidth, pnHeight, pnBytesPerScan, pnBitsSize, pnRgbQuadSize 
         lcBuffer = REPLI(CHR(0), BITMAP_STRU_SIZE) 
         IF GetObjectA (hClipBmp, BITMAP_STRU_SIZE, @lcBuffer) # 0 
            pnWidth  = ASC(SUBSTR(lcBuffer, 5,1)) + ; 
                      ASC(SUBSTR(lcBuffer, 6,1)) * 256 +; 
                      ASC(SUBSTR(lcBuffer, 7,1)) * 65536 +; 
                      ASC(SUBSTR(lcBuffer, 8,1)) * 16777216 
             
            pnHeight = ASC(SUBSTR(lcBuffer, 9,1)) + ; 
                      ASC(SUBSTR(lcBuffer, 10,1)) * 256 +; 
                      ASC(SUBSTR(lcBuffer, 11,1)) * 65536 +; 
                      ASC(SUBSTR(lcBuffer, 12,1)) * 16777216 
         ENDIF 

         lnBitsPerPixel = 24 
         pnBytesPerScan = INT((pnWidth * lnBitsPerPixel)/8) 
         IF MOD(pnBytesPerScan, 4) # 0 
            pnBytesPerScan = pnBytesPerScan + 4 - MOD(pnBytesPerScan, 4) 
         ENDIF 

         lcBIHdr = .num2dword(BHDR_SIZE) + .num2dword(pnWidth) +; 
                 .num2dword(pnHeight) + (CHR(MOD(1,256))+CHR(INT(1/256))) + (CHR(MOD(lnBitsPerPixel,256))+CHR(INT(lnBitsPerPixel/256))) +; 
                 .num2dword(BI_RGB) + REPLI(CHR(0), 20) 

         IF lnBitsPerPixel <= 8 
            pnRgbQuadSize = (2^lnBitsPerPixel) * RGBQUAD_SIZE 
            lcRgbQuad = REPLI(CHR(0), pnRgbQuadSize) 
         ELSE 
            lcRgbQuad = "" 
         ENDIF 
         lcBInfo = lcBIHdr + lcRgbQuad 
         pnBitsSize = pnHeight * pnBytesPerScan 
         lpBitsArray = GlobalAlloc (GMEM_FIXED, pnBitsSize) 
         = ZeroMemory (lpBitsArray, pnBitsSize) 

         *hwnd = GetActiveWindow() 
         hdc = GetWindowDC(.HWnd) 
         hMemDC = CreateCompatibleDC (hdc) 
         = ReleaseDC (.HWnd, hdc) 
         = GetDIBits (hMemDC, hClipBmp, 0, pnHeight, lpBitsArray, @lcBInfo, DIB_RGB_COLORS) 

         lnFileSize = BFHDR_SIZE + BHDR_SIZE + pnRgbQuadSize + pnBitsSize 
         lnOffBits = BFHDR_SIZE + BHDR_SIZE + pnRgbQuadSize 
         lcBFileHdr = "BM" + .num2dword(lnFileSize) + .num2dword(0) + .num2dword(lnOffBits) 

         hFile = CreateFile (cNameFile, GENERIC_WRITE, FILE_SHARE_WRITE, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0) 

         IF hFile # INVALID_HANDLE_VALUE 
            DECLARE INTEGER WriteFile IN kernel32; 
               INTEGER hFile, STRING @lpBuffer, INTEGER nBt2Write,; 
               INTEGER @lpBtWritten, INTEGER lpOverlapped 
            = WriteFile (hFile, @lcBFileHdr, Len(lcBFileHdr), 0, 0) 
            = WriteFile (hFile, @lcBInfo, Len(lcBInfo), 0, 0) 

            DECLARE INTEGER WriteFile IN kernel32; 
               INTEGER hFile, INTEGER lpBuffer, INTEGER nBt2Write,; 
               INTEGER @lpBtWritten, INTEGER lpOverlapped 
            = WriteFile (hFile, lpBitsArray, pnBitsSize, 0, 0) 
            = CloseHandle (hFile) 
         ELSE 
            = MESSAGEBOX("Falha ao criar o arquivo: " + cNameFile, "Operação não concluída") 
         ENDIF 

         = GlobalFree(lpBitsArray) 
         = DeleteDC (hMemDC) 
         = DeleteObject (hClipBmp) 
      ENDWITH 
   ENDPROC 

   PROCEDURE Resize 
      WITH THIS 
         .Command1.Left = .Width-.Command1.Width 
         .Command1.Top = .Height-.Command1.Height 
         .Command1.Tag = ALLT(STR(.Command1.Left)) 

         .SetTransparent() 
      ENDWITH 
   ENDPROC 
    
   PROCEDURE Destroy 
      oCapturaImg = .F. 
      RELEASE oCapturaImg    
   ENDPROC 
ENDDEFINE 

DEFINE CLASS myCmdButton AS Commandbutton 
   Top = 126 
   Left = 97 
   Height = 21 
   Width = 18 
   FontName = "Webdings" 
   Caption = "6" 
   ToolTipText = "Opções" 
   Name = "Command1" 

   PROCEDURE Click 
      cOptMenu = "" 
      DEFINE POPUP _menu_clip SHORTCUT RELATIVE FROM MROW(), MCOL() 
      DEFINE BAR       CNTBAR("_menu_clip")+1 OF _menu_clip PROMPT "Copiar para a área de transferência" 
      ON SELECTION BAR CNTBAR("_menu_clip")   OF _menu_clip        cOptMenu = "CLIPBOARD" 
      DEFINE BAR       CNTBAR("_menu_clip")+1 OF _menu_clip PROMPT "Copiar para um arquivo" 
      ON SELECTION BAR CNTBAR("_menu_clip")   OF _menu_clip        cOptMenu = "FILE" 
      ACTIVATE POPUP _menu_clip 
      RELEASE POPUPS _menu_clip 

      DO CASE 
         CASE cOptMenu == "CLIPBOARD" 
            THISFORM.CopyToClipBoard() 

         CASE cOptMenu == "FILE" 
            THISFORM.CopyToFile() 
      ENDCASE 
   ENDPROC 
ENDDEFINE 

************************************************************************************************
ADICIONAR UM ODBC DATA SOURCE POR API 
Autor : desconhecido 

Código: 
DECLARE Integer SQLConfigDataSource IN odbccp32.dll ; 
Integer, Short, String @, String @ 
ODBC_ADD_SYS_DSN = 1 
&& Add data source de sistema 
lc_driver = "Microsoft Visual FoxPro Driver" + CHR(0) 
lc_dsn = "dsn=Bases Bodega1" + CHR(0) + ; 
"BackgroundFetch=Yes" + CHR(0) + ; 
"Description=Conexion Para Agencias" + CHR(0) + "Exclusive=No" + CHR(0) +; 
"SourceDb=\\Sttacasant2\basesbo\bodega1.dbc" + CHR(0) +; 
"Sourcetype=DBC" 
IF SQLConfigDataSource(0, ODBC_ADD_SYS_DSN, @lc_driver, @lc_dsn) = 1 
RETURN .T. && se configuró OK 
ENDIF 
RETURN .F. && falló 
*.- lc_driver = Drive de Visual FoxPro 
*.- lc_dsn = dsn = Nombre de la Conexion 
*.- BackgroudFetch = Busqueda de datos secundarios Valores Yes o No 
*.- Description = Descripcion de de la conexion 
*.- SourceDb = Mapeo o direccion de la tabla o base de datos a conectar 
*.- SourceType = tipo de conexion valores DBC o DBF si fuera tabla libre 

************************************************************************************************
SABER SE PROGRAMA ESTA SENDO EXECUTADO A PARTIR DO EXE OU NO PROJETO 

Código: 
IF VERSION(2) = 0 && RunTime 
   MESSAGEBOX("EXECUTÁVEL") 
ELSE 
   MESSAGEBOX("DESENVOLVIMENTO") 
ENDIF 

************************************************************************************************
Ola pessoal

Setei a propriedade ScrollBars de uma form para 2 (Vertical), pois
tenho um form com varios controles. Gostarai que ao focar um controle
fora da area de visão o scroll fosse automatico, alguem sabe como fazer
isso ?

Coloque nos objetos no metodo gotfocus
Thisform.SetViewPort(0, posicao)

Luis Fernando Basso
fernando@...
www.engersoft.com.br

************************************************************************************************
Comparar 2 registros
TRY
  USE (_Samples+"Northwind\Customers") IN 0
CATCH
ENDTRY
IF NOT USED("Customers")
  MESSAGEBOX("No se pudo abrir la tabla Customers en _Samples",16,"Aviso")
  RETURN
ENDIF

******************************************
*  Comparar objetos
******************************************
LOCAL loFirstRecord, loSecondRecord
SELECT Customers
LOCATE 
SCATTER MEMO NAME loFirstRecord
SKIP
SCATTER MEMO NAME loSecondRecord
IF COMPOBJ(loFirstRecord,loSecondRecord)
  MESSAGEBOX("Los registros son iguales",48,"Aviso")
 ELSE
  MESSAGEBOX("Los registros son distintos",48,"Aviso")
ENDIF

******************************************
*  Comparar XML
******************************************
ERASE FirstRecord.XML
ERASE SecondRecord.XML
SELECT Customers
LOCATE 
CURSORTOXML("Customers","FirstRecord.XML",1,512,1)
SKIP
CURSORTOXML("Customers","SecondRecord.XML",1,512,1)
IF FILETOSTR("FirstRecord.XML") == FILETOSTR("SecondRecord.XML")
  MESSAGEBOX("Los registros son iguales",48,"Aviso")
 ELSE
  MESSAGEBOX("Los registros son distintos",48,"Aviso")
ENDIF
ERASE FirstRecord.XML
ERASE SecondRecord.XML

******************************************
*  Comparar SYS(2017)
******************************************
LOCAL lnFirstRecord, lnSecondRecord
SELECT Customers
LOCATE 
lnFirstRecord = SYS(2017,"",0,3)
SKIP 
lnSecondRecord = SYS(2017,"",0,3)
IF lnFirstRecord = lnSecondRecord
  MESSAGEBOX("Los registros son iguales",48,"Aviso")
 ELSE
  MESSAGEBOX("Los registros son distintos",48,"Aviso")
ENDIF

USE IN Customers
RETURN

************************************************************************************************
POSICIONAR O REGISTRO EM CERTA LINHA DA GRADE 

Código: 
local lnGridHeight 
thisform.lockscreen=.T. 
lnGridHeight=yourgrid.height 
yourgrid.height=xx && Where xx is the height necessary to show only two lines 
yourgrid.height=lnGridHeight 
thisform.lockscreen=.F. 

************************************************************************************************
MOSTRAR IMAGEM EM UMA GRADE 

Criar um método mostra_imagem no form 
Código: 
** mostra_imagem 
WITH THISFORM.objeto_seugrid.suacoluna.objeto_seucontainner 
.objeto_imagem.PICTUREVAL = tabela.campoole 
ENDWITH 


Na sua coluna incluir a linha abaixo no DynamicBackColor 
Código: 
Thisform.mostra_imagem() 


Para um exemplo mais detalhado dá uma olhada no blog do emerson mr.Grid!! 
http://br.thespoke.net/MyBlog/EmersonReed/RssFeed.aspx 
http://br.thespoke.net/MyBlog/EmersonReed/MyBlog_Comments.aspx?ID=21091 


************************************************************************************************
CONFIGURAR GRID PROGRAMATICAMENTE 

Embora seja muito fácil se ajustar uma grade visualmente, em certas situações podemos optar por definir programaticamente as propriedades de uma grade, como largura de colunas, fontes, estilos etc... o que se torna um pouco trabalhoso. 

Para facilitar as coisas, é possível se definir "visualmente" uma grade e "puxar" as configurações para o modo programado. 

Configure sua grade no "visual" 
Feche seu form 
Abra seu form como uma tabela, ex use meuform.scx 
browse for "Grid"$class 
clique na coluna Properties 
Copie tudo para o clipboard (CTRL+C) 
Feche o form com USE 

MODIFY FORM seuform 
Em seu método, ex: INIT, ou set_grid 
"COLE" (CTRL+V) do clipboard 

Assim você terá todas as propriedades, medidas, etc... 
Só lhe faltará completar a sintaxe e pronto ! 

Dica enviada por RAFAEL COPQUIN no forum PROFOX em www.leafe.com
************************************************************************************************
CONGELAR A 1ª COLUNA DE UMA GRADE 

No VFP 8 já ha condições de fazê-lo usando funções nativas. 
Para quem ainda está na versão 7, aí vai o macete : 

Coloque o código abaixo nos eventos AfterRowColChange Event e em Scrolled Event: 

Código: 
if this.Column1.ColumnOrder <> this.LeftColumn 
    this.Column1.ColumnOrder = this.LeftColumn 
endif   


dica encontrada em www.foxite.com


************************************************************************************************
cConnectString = "Driver=SQL Server;Server=Y;Database=Y;UID=usuario;PWD=clave"
hConn = sqlstringconnect(cConnectString)
SQLExec(hConn, "select count(*) AS rcount from tu_gran_archivo","rcuenta")
nTotalRecordsToFetch=rcuenta.rcount
use

lSQLResult=SQLSETPROP(hConn,"Asynchronous",.t.)
llCancel = .f.
lnResult = 0

on escape llCancel = .t.
do while (!llCancel and lnResult = 0)
   lnResult = SQLExec(hConn, "select * from tu_gran_archivo","getrec")
   doevents
   *- La Barra de Progreso deberás codificarla
   =used("getrec") and MuestraProgressBar(cursorgetprop("RecordsFetched","getrec"), m.nTotalRecordsToFetch)
enddo

SQLCancel(hConn)
SQLDisconnect(hConn)

************************************************************************************************
Cómo escribir en el registro de la aplicación en Windows NT, Windows 2000 o Windows XP que utiliza el Windows Script Host

#DEFINE SUCCESS 0
#DEFINE ERROR 1
#DEFINE WARNING 2
#DEFINE INFORMATION 4
#DEFINE AUDIT_SUCCESS 8
#DEFINE AUDIT_FAILURE 16
WshShell = CreateObject("WScript.Shell")
*!* Logevent returns .t. for SUCCESS for .f. for FAILURE
?WshShell.LogEvent(SUCCESS, "Logon Script Completed Successfully")
WshShell.LogEvent(ERROR, "Logon Script Completed Successfully")
WshShell.LogEvent(WARNING, "We are getting low on disk space!!")
WshShell.LogEvent(INFORMATION, "Start nightly backup")
WshShell.LogEvent(AUDIT_SUCCESS, "Checksum Success!!")
WshShell.LogEvent(AUDIT_FAILURE, "Checksum Failure")

WshShell=.NULL.

************************************************************************************************
Conectar a una Unidad de Red
Contribución de maoh el Lunes, 31 octubre a las 14:31:06 
 
#DEFINE RESOURCETYPE_DISK 1 
#DEFINE RESOURCETYPE_PRINT 2 
DO decl 



LOCAL hWindow 
hWindow = GetActiveWindow() 

* Map Network Drive dialog box 
= WNetConnectionDialog(hWindow, RESOURCETYPE_DISK) 

* Disconnect Network Drives dialog box 
* only RESOURCETYPE_DISK flag is allowed 
= WNetDisconnectDialog(hWindow, RESOURCETYPE_DISK) 

PROCEDURE decl 
DECLARE INTEGER GetActiveWindow IN user32 

DECLARE INTEGER WNetConnectionDialog IN mpr; 
INTEGER hwnd, INTEGER dwType 

DECLARE INTEGER WNetDisconnectDialog IN mpr; 
INTEGER hwnd, INTEGER dwType 

 

************************************************************************************************
Visibilidade do FORM CHAMADOR

IF TYPE( "_Screen.ActiveForm" ) = "O"
  *** OK, tenemos realmente un formulario activo
  loForm = _Screen.ActiveForm
ELSE
  *** Ooops! ¿No debía existir un formulario activo?
ENDIF

In Parent Form, Active Form is currently [FrmParent]
*** Call child form here ***
STARTING Child Form LOAD, Active Form is currently [FrmParent]
STARTING Child Form INIT, Active Form is currently [FrmParent]
STARTING Child Form SHOW, Active Form is currently [FrmParent]  

STARTING Child Form ACTIVATE, Active Form is currently [FrmChild]
*** Release Child Form here ***
STARTING Child Form DESTROY, Active Form is currently [FrmChild]
STARTING Child Form UNLOAD, Active Form is currently [FrmChild]
STARTING Parent Form ACTIVATE, Active Form is currently [FrmParent]




************************************************************************************************
Imprimir en JPG
http://www.news2news.com/vfp 

Sólo VFP 9.0

 

LOCAL oListener As ReportListener, nPageIndex

oListener = CREATEOBJECT("ReportListener")

oListener.ListenerType=3 && renders all pages at once



* make sure the report can load and run

REPORT FORM MyReport PREVIEW OBJECT oListener

 

FOR nPageIndex=1 TO oListener.PageTotal

        cOutputFile = "tmp"+TRANS(nPageIndex)+".jpg"

        oListener.OutputPage(nPageIndex,;

                cOutputFile, 102, 0,0,768,1024) && 102=jpeg

NEXT


************************************************************************************************
* Endereco de um OBJETO
ON KEY LABEL 'F2' MESSAGEBOX("tecla F2 o seu objeto é:"+CHR(13)+sys(1272,sys(1270)),0+48,"Mensagem do sistema")

************************************************************************************************
* Mapear uma unidade de rede
oNet = CREATEOBJECT("wscript.network")
* oNet.MapNetworkDrive('<drive>','<caminho>')
oNet.MapNetworkDrive('S:','\\Andre\cd')


************************************************************************************************
Como Setar Impressora padrao no Windowns.   
 
* A 'Zebra Stripe-S600' é apenas para ilustrar o valor recebido da variavel.
local oNet
oNet = CreateObject('WScript.Network')
oNet.SetDefaultPrinter('Zebra Stripe-S600')
 

************************************************************************************************
SQLSERVER
Ver se a tabela existe (ou qualquer outro tipo de objeto - views, sps, etc):
select count(*) c from sysobjects where id = object_id('nome_da_tabela')

Ver se um campo existe:
select count(*) c from syscolumns where name = 'nome_do_campo'
and id = (select id from sysobjects where id = object_id('nome_da_tabela'))

Ver se um índice existe:
select count(*) c from sysindexes i, sysobjects o where i.id = o.id and i.name =
'nome_do_indice' and o.name =
'nome_da_tabela'

Pegar o conteúdo de uma stored procedure:
select c.text from syscomments c, sysobjects o
where o.id = c.id and c.id = object_id('NOME_DA_PROCEDURE')

Esses comandos podem estar dentro de um IF pra rodar um comando de alteração
depois se necessário (ex.: ALTER TABLE).
Outros comandos, como CREATE TABLE, não podem vir depois de um IF, tem que pegar
o valor no Fox e rodar o comando em
seguida.

Nota importante: pra alterar ou criar qualquer coisa no SQL Server o usuário do
SQL tem que ter o direito pra tal. Pra
garantir essa flexibilidade em meus sistemas o logon ao SQL Server é sempre com
usuário único, com direito de
administrador.



************************************************************************************************
* Colocando imagem no combo BOX
ThisForm.cboMeuCombo.AddItem( 'NOVO'   )
ThisForm.cboMeuCombo.AddItem( 'ALTERA' )
ThisForm.cboMeuCombo.AddItem( 'EXCLUI' )
ThisForm.cboMeuCombo.Picture[1] = 'NOVO.ico'
ThisForm.cboMeuCombo.Picture[2] = 'ALTERA.ico'
ThisForm.cboMeuCombo.Picture[3] = 'EXCLUI.ico'
ThisForm.cboMeuCombo.PictureSelectionDisplay = 1
************************************************************************************************
Como descobrir um código vago em uma tabela DBF

select distinct BBB.Codigo from BBB.DBF Where BBB.Codigo Not in (Select
AAA.Codigo From AAA) into cursor novo_codigo 
ou
select min(BBB.Codigo) from BBB.DBF Where BBB.Codigo Not in (Select
AAA.Codigo From AAA) into cursor novo_codigo 
ou
select max(BBB.Codigo) from BBB.DBF Where BBB.Codigo Not in (Select
AAA.Codigo From AAA) into cursor novo_codigo 
************************************************************************************************
Como criar um HEADER/FOOTER em WORD
#Define wdHeaderFooterPrimary   1
#Define wdHeaderFooterFirstPage 2
#Define wdHeaderFooterEvenPages 3 
oWord = Createobject('Word.Application')
With oWord
   .Documents.Add
   With .ActiveDocument.Sections(1)
     .Headers(wdHeaderFooterPrimary).Range.Text = "This is header"
     .Footers(wdHeaderFooterPrimary).Range.Text = "This is footer"
     .Footers(wdHeaderFooterPrimary).PageNumbers.Add
   Endwith
   .Visible = .T.
   .Activate
Endwith

************************************************************************************************
* Maximiza o relatório no preview
if wexist("Report Designer")
   zoom wind "Report Designer" max
endif

************************************************************************************************
* MOSTRA DRIVERS INSTALDO NO COMPUTADOR

CLEAR

Declare Integer SQLGetInstalledDrivers In odbccp32 String @lpszBuf, Integer cbBufMax, Integer @pcbBufOut

Local cBuffer, nBufsize, ii, ch, cName
nBufsize = 16384
cBuffer = Repli(Chr(0), nBufsize)

If SQLGetInstalledDrivers(@cBuffer, nBufsize, @nBufsize) = 0
   Return
Endif

cBuffer = Substr(cBuffer,1,nBufsize)
cName = ""
N = 1
For ii=1 To nBufsize
   ch = Substr(cBuffer, ii,1)
   If ch = Chr(0)
      Dimension aM(N,1)
      aM(N) = m.cName
      N = N + 1
      cName = ""
   Else
      cName = cName + ch
   Endif
Endfor
* Exibe matriz
Display Memory Like aM

************************************************************************************************
* Jogo de PINGPONG
PUBLIC oForm1
oForm1 = NEWOBJECT("Form1")
oForm1.SHOW(1)
RETURN

DEFINE CLASS Form1 AS FORM
  HEIGHT = 307
  WIDTH = 447
  DOCREATE = .T.
  AUTOCENTER = .T.
  CAPTION = "Ping-Pong"
  BACKCOLOR = RGB(0,128,255)
  NAME = "Form1"
  ADD OBJECT bola AS SHAPE WITH ;
    TOP = 0, ;
    LEFT = 0, ;
    HEIGHT = 23, ;
    WIDTH = 26, ;
    CURVATURE = 75, ;
    BACKCOLOR = RGB(255,255,0), ;
    NAME = "bola"
  ADD OBJECT timer1 AS TIMER WITH ;
    TOP = 0, ;
    LEFT = 420, ;
    HEIGHT = 23, ;
    WIDTH = 23, ;
    NAME = "Timer1"
  ADD OBJECT barra AS COMMANDBUTTON WITH ;
    TOP = 200, ;
    LEFT = 171, ;
    HEIGHT = 13, ;
    WIDTH = 108, ;
    CAPTION = "", ;
    BACKCOLOR = RGB(0,0,160), ;
    NAME = "barra"
  ADD OBJECT lblb2 AS COMMANDBUTTON WITH ;
    TOP = 200, ;
    LEFT = 171, ;
    HEIGHT = 13, ;
    WIDTH = 4, ;
    CAPTION = "", ;
    BACKCOLOR = RGB(128,0,0), ;
    NAME = "LblB2"

  PROCEDURE INIT
    THISFORM.timer1.INTERVAL = 5
    PUBLIC x AS INTEGER, Y AS INTEGER, vCont AS INTEGER
    STORE 1 TO x, Y
    vCont = 0
  ENDPROC

  PROCEDURE MOUSEMOVE
    LPARAMETERS nButton, nShift, nXCoord, nYCoord
    THISFORM.barra.LEFT = nXCoord
    THISFORM.lblb2.LEFT = nXCoord
  ENDPROC

  PROCEDURE timer1.TIMER
    THISFORM.bola.LEFT = THISFORM.bola.LEFT + x
    THISFORM.bola.TOP = THISFORM.bola.TOP + Y
    vcol1 = INT(RAND()*256)
    vcol2 = INT(RAND()*256)
    vcol3 = INT(RAND()*256)
    IF THISFORM.bola.LEFT + THISFORM.bola.WIDTH => THISFORM.WIDTH
      x = -1
    ELSE
      IF THISFORM.bola.LEFT = 0
        x = 1
      ENDIF
    ENDIF
    IF THISFORM.bola.TOP + THISFORM.bola.HEIGHT => THISFORM.HEIGHT
      Y = -1
    ELSE
      IF THISFORM.bola.TOP = 0
        Y = 1
      ENDIF
    ENDIF
    IF THISFORM.bola.TOP + THISFORM.bola.HEIGHT = THISFORM.barra.TOP ;
        AND THISFORM.bola.LEFT + THISFORM.bola.WIDTH >= THISFORM.barra.LEFT ;
        AND THISFORM.bola.LEFT <= THISFORM.barra.LEFT + THISFORM.barra.WIDTH
      THISFORM.bola.BACKCOLOR = RGB(vcol1,vcol2,vcol3)
      Y = -1
      IF THISFORM.lblB2.WIDTH < THISFORM.barra.WIDTH
        THISFORM.lblB2.WIDTH = THISFORM.lblB2.WIDTH + 10
      ELSE
        MESSAGEBOX("Finalizado")
        THISFORM.RELEASE
      ENDIF
    ENDIF
    IF THISFORM.bola.TOP = THISFORM.barra.TOP + THISFORM.barra.HEIGHT ;
        AND THISFORM.bola.LEFT + THISFORM.bola.WIDTH >= THISFORM.barra.LEFT ;
        AND THISFORM.bola.LEFT <= THISFORM.barra.LEFT + THISFORM.barra.WIDTH
      THISFORM.bola.BACKCOLOR=RGB(vcol1,vcol2,vcol3)
      Y = 1
      IF THISFORM.lblB2.WIDTH >10
        THISFORM.lblB2.WIDTH = THISFORM.lblB2.WIDTH - 10
      ENDIF
    ENDIF
  ENDPROC
ENDDEFINE

************************************************************************************************
INDEXAR/ORDENAR COLUNAS DO GRID

NO INICIO DO RELATORIO
* click's para el grid de la consultas
for lnCols = 1 to this.Grid1.columncount
   lcCol = 'This.Grid1.Column'+transform(lnCols)+'.Header1'
   bindevent(&lcCol,"MouseUp",thisform,"ClickMHeader")
endfor

* Crear el Metodo ClickMHeader
* Codigo En ClickMHeader
lparameters nButton, nShift, nXCoord, nYCoord
do case
   case nButton = 1 && Izquierdo
      if aevents(laObjeto,0) > 0
         lcField = laObjeto[1].parent.controlsource
         try
            select Empleados
            index on &lcField to ( sys(2023)+""+sys(2015)+".IDX" )
            go top
         catch
         endtry
         thisform.Grid1.refresh
      endif
   case nButton = 2 && Derecho
      if aevents(laObjeto,0) > 0
         lcField = laObjeto[1].parent.controlsource
         try
            select Empleados
            lcIdxFile = sys(2023)+""+sys(2015)+".IDX"
            index on &lcField to ( lcIdxFile )
            lcIdxFile = juststem( lcIdxFile )
            set order to (lcIdxFile) descending
            go top
         catch
         endtry
         thisform.Grid1.refresh
      endif
endcase



************************************************************************************************
Não permitir abrir o programa mais de uma vez na mesma estação  
 
Boa noite!
Aqui eu utilizo essa rotina
onde o parametro eh a instancia

PARAMETERS lcSmp
#DEFINE WAIT_OBJECT_0 0
#DEFINE STATUS_TIMEOUT 258
#DEFINE STANDARD_RIGHTS_REQUIRED 983040 && 0xF0000
#DEFINE SYNCHRONIZE 1048576 && 0x100000
#DEFINE SEMAPHORE_ALL_ACCESS 2031619 && 0x1F0003
#DEFINE SW_SHOWMAXIMIZED 3
DECLARE INTEGER CreateSemaphore IN kernel32 ;
INTEGER lcSmAttr, INTEGER lInitialCount, ;
INTEGER lMaximumCount, STRING lpName
DECLARE INTEGER OpenSemaphore IN kernel32 ;
INTEGER dwDesiredAccess, ;
INTEGER bInheritHandle, STRING lpName
LOCAL hSmp
hSmp = OpenSemaphore (STANDARD_RIGHTS_REQUIRED, 0, lcSmp)
IF hSmp = 0
hSmp = CreateSemaphore (0, 1, 1, lcSmp)
CLEAR DLLS
RETURN
ELSE
LOCAL mHandle, mResult
mHandle = FindWindowLike(lcSmp)
DECLARE INTEGER SetForegroundWindow IN User32 ;
INTEGER HWND
mResult = SetForegroundWindow(mHandle)
DECLARE INTEGER ShowWindow IN WIN32API INTEGER, INTEGER
= ShowWindow (mHandle, SW_SHOWMAXIMIZED)
ENDIF
DECLARE INTEGER CloseHandle IN kernel32 INTEGER hObject
= CloseHandle (hSmp)
CLEAR DLLS
QUIT

FUNCTION FindWindowLike(lcSmp)
#DEFINE GW_HWNDFIRST 0
#DEFINE GW_HWNDLAST 1
#DEFINE GW_HWNDNEXT 2
#DEFINE GW_HWNDPREV 3
#DEFINE GW_OWNER 4
#DEFINE GW_CHILD 5
DECLARE INTEGER GetDesktopWindow IN user32
DECLARE INTEGER GetWindow IN user32 ;
INTEGER HWND, ;
INTEGER wCmd
DECLARE INTEGER GetWindowText IN user32 AS GetWindowTextA ;
INTEGER HWND, ;
STRING @lpString, ;
INTEGER cch
LOCAL mCaption, mDeskWin, mHwnd
mCaption = SPACE(255)
mDeskWin = GetDesktopWindow()
mHwnd = GetWindow(mDeskWin, GW_CHILD)
DO WHILE mHwnd<>0
= GetWindowTextA(mHwnd, @mCaption, 255)
IF lcSmp$mCaption
EXIT
ENDIF
mHwnd = GetWindow(mHwnd, GW_HWNDNEXT)
ENDDO
CLEAR DLLS
RETURN mHwnd
ENDFUNC



************************************************************************************************
Una forma de obtener la misma funcionalidad de SQLColumns, pero a traves de OLEDB/ADO. Cortesía de Çetin Basöz, MVP de VFP.


Usando las funciones SQLColumns() y SQLTables() podemos obtener esos datos, pero si no fuera posible hacerlo via ODBC (y por lo tanto hacerlo con dicha función), puedes optar por hacerlo con ADO/OLEDB.

#Define adSchemaCatalogs 1
#Define adSchemaColumns 4
#Define adSchemaTables 20

Local oConn As 'ADODB.Connection'
oConn = Createobject('ADODB.Connection')
oConn.Open( "Provider=sqloledb;Data Source=(local);"+;
  "Initial Catalog=Pubs;Integrated Security=SSPI" )
rstSchema = oConn.OpenSchema(adSchemaColumns)
ShowMe(rstSchema)
rstSchema.Close
oConn.Close

Function ShowMe
  Lparameters toRecordset
  oForm = Createobject('myForm', toRecordset)
  oForm.Show
  Read Events
Endfunc

Define Class myform As Form
  Height = 450
  Width = 750
  Name = "Form1"

  Add Object hflex As OleControl With ;
    Top = 10, Left = 10, Height = 430, Width = 730, Name = "Hflex", ;
    OleClass = 'MSHierarchicalFlexGridLib.MSHFlexGrid'

  Procedure Init
    Lparameters toRecordset
    This.Caption = "Recordset"
    This.hflex.Datasource = toRecordset
    This.hflex.AllowUSerResizing = 3
  Endproc
  Procedure QueryUnload
    Clear Events
  Endproc
Enddefine

************************************************************************************************
Select * From Information_Schema.Columns Where Table_name = 'CLIENTE'

************************************************************************************************
 Cansado de codificar largas y tediosas instrucciones INSERT para utilizarlas via SPT?, aquí te decimos como hacerlo un poco mas fácil.


En dias pasado se comentaba en los foros de noticias de Microsoft, si se podría utilizar la cláusula FROM MEMVAR dentro de sentencias enviadas via SQL Pass Through (SPT):

Select MiCursor
SCATTER MEMVAR
SQLExec(lnConnHandle,"INSERT INTO miTablaSQL FROM MEMVAR")


Esto no es posible, ya que nisiquiera el controlador ODBC de VFP da la posibilidad de hacerlo, ni hablar de cualquier otro cómo puede ser MS-SQL Server.
Claro está, la vistas remotas podría ser la solución, pero puede que el requisito para resolver cierto problemas (como el tener cientos de tablas, lo que nos tendría cientos de vistas creadas y quizás despues no se usaran) no nos permite hacerlo. 
Por tal motivo propongo una idea para crear sentencias INSERT para ser enviadas via SPT. TextMerge puede ser una solución viable:

FUNCTION CrearInsert(tcCursor, tcTabla)
   LOCAL lnFields,; && Numero de campos del cursor
         laFields,; && Arreglo con la estructura del cursor
         lcInsertQuery && Cadena que contendrá el INSERT
   DIMENSION laFields[1]
   lcInsertQuery=SPACE(0)
   **** Hacemos algunas validaciones ****
   **** Si no se incluye el nombre del cursor o de la tabla
   **** Se utilizará el ALIAS() en ambos casos

   tcCursor = IIF(TYPE('tcCursor')#'C' OR EMPTY(tcCursor),ALIAS(), tcCursor)
   tcTabla  = IIF(TYPE('tcTabla') #'C' OR EMPTY(tcTabla),tcCursor,tcTabla)
   
   **** Obtenemos la información del cursor 
   lnFields = AFIELDS(laFields,tcCursor)
   IF lnFields > 0 
      **** Creamos la instrucción INSERT(Campo,Campo2...CampoN) ****
      SET TEXTMERGE ON
      SET TEXTMERGE TO MEMVAR lcInsertQuery NOSHOW 
    \  INSERT INTO << tcTabla >>(
      FOR I=1 TO lnFields
      \   << laFields[i,1] >>,
      ENDFOR
      SET TEXTMERGE TO
      lcInsertQuery=SUBSTR(lcInsertQuery,1,LEN(lcInsertQuery)-1) + ')'

      **** Agregamos la cláusula VALUES(?Campo1, ?Campo2... ?CampoN) ****
      SET TEXTMERGE TO MEMVAR lcInsertQuery NOSHOW ADDITIVE
     \  VALUES (
      FOR I=1 TO lnFields
       \  ?<< tcCursor >>.<< laFields[i,1] >>,
      ENDFOR
      SET TEXTMERGE TO
      SET TEXTMERGE OFF
      lcInsertQuery=SUBSTR(lcInsertQuery,1,LEN(lcInsertQuery)-1)+ ')'
   ENDIF
   RETURN lcInsertQuery
ENDFUNC


Muy bien, ya tenemos la función ahora veremos un caso práctico en el cual utilizarlo. 
Supongamos que tenemos un numero indeterminado de tablas VFP cuyos registros serán insertadas al servidor de base de datos via SPT. Donde la tabla tiene la siguiente estructura:

MiTabla (iID int, dFecha date, iClienteID int, iSeccionID int, yImporte Y)


USE miTabla IN 0
lcInsert = CrearInsert("Mitabla","Ventas")


La cadena lcInsert contendrá lo siguiente:

INSERT INTO Ventas( IID, DFECHA, ICLIENTEID, ISECCIONID, YIMPORTE) VALUES(?MiTabla.IID,?MiTabla.DFECHA,?MiTabla.ICLIENTEID,?MiTabla.ISECCION,?MiTabla.YIMPORTE)

Ahora podemos utilizar esta instrucción para mandarla via SPT:


USE MiTabla IN 0
lcInsert = CrearInsert("Mitabla","Ventas")
lcRegistros = trans( RECCOUNT("MiTabla"))
llError = .F.
IF SQLPrepare(lnConnHandle,lcInsert) > 0
   SCAN FOR NOT llError
       WAIT WINDOW "Insertando registro " + TRANS(recno())+ "/"+lcRegistros NOWAIT
       llError = SQLExec(lnConnHandle) < 0
   ENDSCAN
    IF llError 
         Messagebox(laError[2],"Error al insertar")
    ELSE
      WAIT WINDOW "Proceso Finalizado"
    ENDIF
ENDIF


Lo anterior es un ejemplo sencillo donde quizas pueda hacerse manualmente, pero imaginate si dicha tabla(s) tienen 50 campos, o incluso, se tienen 100 tablas? ,
aquí es donde este proceso de crear Insert via TEXTMERGE ayudará en demasía. Espero que este tip les sea de utilidad.



************************************************************************************************
 Con el siguiente código y utilizando Automation, podemos crear una hoja Excel con SubTotales. Cortesía de Çetin Basöz, MVP de VFP.


OPEN DATABASE (HOME(2) + "Northwind\Northwind.dbc")
SELECT o.CustomerId, o.OrderId, ProductId, UnitPrice, Quantity ;
  FROM Orders o inner JOIN OrderDetails od ON o.OrderId = od.OrderId ;
  ORDER BY o.CustomerId, o.OrderId ;
  INTO CURSOR crsTemp
lcXLSFile = SYS(5) + CURDIR() + "myOrders1.xls"
COPY TO (lcXLSFile) TYPE XLS
CLOSE DATABASES ALL
DIMENSION laSubtotal[3]
laSubtotal[1] = 4 && Unit_price
laSubtotal[2] = 5 && Quantity
laSubtotal[3] = 6 && Will use later
#DEFINE xlSum -4157
oExcel = CREATEOBJECT("excel.application")
WITH oExcel
  .Workbooks.OPEN(lcXLSFile)
  WITH .ActiveWorkbook.ActiveSheet
    lnRows = .UsedRange.ROWS.COUNT && Get current row count
    lcFirstUnusedColumn = _GetChar(laSubtotal[3]) && Get column in Excel A1 notation
    * Instead of orders order_net field use Excel calculation for net prices
    .RANGE(lcFirstUnusedColumn + '2:' + ;
      lcFirstUnusedColumn + TRANSFORM(lnRows)).FormulaR1C1 = ;
      "=RC[-2]*RC[-1]"
    .RANGE(lcFirstUnusedColumn+'1').VALUE = 'Extended Price' && Place header
    .RANGE('D:'+lcFirstUnusedColumn).NumberFormat = "$#,##0.0000" && Format columns
    * Subtotal grouping by customer then by order
    .UsedRange.Subtotal(1, xlSum, @laSubtotal)
    .UsedRange.Subtotal(2, xlSum, @laSubtotal,.F.,.F.,.F.)
    .UsedRange.COLUMNS.AUTOFIT && Autofit columns
  ENDWITH
  .VISIBLE = .T.
ENDWITH
* Return A, AA, BC etc notation for nth column
FUNCTION _GetChar
  LPARAMETERS tnColumn && Convert tnValue to Excel alpha notation
  IF tnColumn = 0
    RETURN ""
  ENDIF
  IF tnColumn <= 26
    RETURN CHR(ASC("A") - 1 + tnColumn)
  ELSE
    RETURN  _GetChar(INT(IIF(tnColumn % 26 = 0, tnColumn - 1, tnColumn) / 26)) + ;
      _GetChar((tnColumn-1) % 26 + 1)
  ENDIF
ENDFUNC

************************************************************************************************
 continuación un código para automatizar el cambio de nombre de los archivos contenedores de bases de datos (DBC) de Visual FoxPro. Cortesía de Çetin Basöz, MVP de VFP.


RenDBC('testnew','testdata')

Function RenDbc
lparameters OldName, NewName
Open data (oldName)
lnTables=adbobject(arrTables,'TABLE')
For ix=1 to lnTables
  lcTable = arrTables[ix]+'.DBF'
  handle=fopen(lcTable,12)
  =fseek(handle,8,0)
  lnLowByte = asc(fread(handle,1))
  lnHighByte = asc(fread(handle,1))*256
  lnBackLinkstart = lnHighByte + lnLowByte - 263
  =fseek(handle,lnBackLinkstart,0)
  Fwrite(handle,forceext(newName,'dbc')+replicate(chr(0),263),263)
  =fclose(handle)
Endfor
Close data all
Rename (forceext(oldName,'dbc')) to (forceext(newName,'dbc'))
Rename (forceext(oldName,'dcx')) to (forceext(newName,'dcx'))
Rename (forceext(oldName,'dct')) to (forceext(newName,'dct'))


************************************************************************************************

Basandome en un artículo de Les Pinter publicado en Universal Thead de agosto de 2003 basado en la utilización de los Header de las columnas de una grilla para ordenar los datos visualizados en la misma y en un artículo mas reciente de José Samper publicado en FoxyNet, es que decidí ir un poco mas allá y aplicar el Bindevent que aplica José Samper también a los controles que forman parte de la grilla.


**************************************************
*-- Class:        powergrid
*-- ParentClass:  grid
*-- BaseClass:    grid
*-- Time Stamp:   04/24/05 01:50:08 AM
*
DEFINE CLASS powergrid AS GRID
  DELETEMARK = .F.
  HEIGHT = 200
  READONLY = .T.
  WIDTH = 320
  HIGHLIGHTSTYLE = 2
  ALLOWAUTOCOLUMNFIT = 0
  NAME = "ordergrid"
  lcorden = .F.
  *-- Metodo que crea dinamicamente los indices de los campos
  *-- Integer, fecha, fechahora y caracter ( podria utilizarse
  *-- una vista y realizar un order by de los registros al
  *-- momento de hacer el click en el columnheader en lugar
  *-- de indexar por todos los campos)
  HIDDEN PROCEDURE indexar
    LOCAL lSet AS STRING
    LOCAL lncuantos AS INTEGER,iii AS INTEGER,lcIndice AS STRING,lcTag AS STRING
    LOCAL ARRAY Lacampos[1]
    LOCAL LcIndiceAsc
    LOCAL lcIndiceDes
    IF !EMPTY(THIS.RECORDSOURCE)
      lSet=SET("Safety")
      SET SAFETY OFF
      SELECT (THIS.RECORDSOURCE)
      lncuantos= AFIELDS(lacampos,THIS.RECORDSOURCE)
      FOR iii=1 TO lncuantos
        IF INLIST(lacampos[iii,2],"C","D","T","I")
          LcTag=IIF(INLIST(lacampos[iii,2],'D','T'),"DTOS("+lacampos[iii,1]+")", ;
            IIF(lacampos[iii,2]='C',"upper("+IIF(lacampos[iii,3]>100, ;
            "SUBSTR("+lacampos[iii,1]+",1,100)", ;
            lacampos[iii,1])+")",lacampos[iii,1]))
          lcIndice=LEFT(lacampos[iii,1],9)
          LcIndiceAsc = 'Index On ' + lctag+ ' Tag '+ "A"+lcIndice+' Additive'
          &LcIndiceAsc
          LcIndiceDes = 'Index On ' + lctag+ ' Tag '+ "D"+lcIndice+' Descending Additive'
          &LcIndiceDes
        ENDIF
      NEXT
      SET SAFETY &lSet
      THIS.lcorden=''
    ENDIF
  ENDPROC
  *-- Selecciona el orden correcto
  HIDDEN PROCEDURE ordenar
    LOCAL lCorden AS STRING,lCcampo AS STRING
    AEVENTS(laEventos,0)
    lCorden = laEventos[1].PARENT.CONTROLSOURCE
    IF !EMPTY(lCorden) AND VARTYPE(EVALUATE(lCorden))$"CDTN"
      THIS.pordefecto
      lCcampo=SUBSTR(lCorden,AT('.',lCorden)+1)
      lCorden="A"+LEFT(lCcampo,9)
      WITH laEventos[1]
        .PICTURE="UP.bmp"
        IF UPPER(ALLTRIM(THIS.lCorden))==UPPER(ALLTRIM(lCorden))
          lCorden="D"+LEFT(lCcampo,9)
          .PICTURE="Down.bmp"
        ENDIF
        .BACKCOLOR=RGB(255,0,0)
      ENDWITH
      THIS.lCorden=lCorden
      SET ORDER TO lCorden
      GO TOP IN (THIS.RECORDSOURCE)
      THIS.REFRESH()
    ENDIF
  ENDPROC
  HIDDEN PROCEDURE pordefecto
    ***************************************
    * lcinit determina si es el init de la
    * grilla ( .t.) o no( .f.)
    ***************************************
    LPARAMETERS lcinit
    LOCAL LCClaseBase
    FOR EACH loObjects IN THIS.OBJECTS
      FOR EACH loControls IN loObjects.CONTROLS
        LCClaseBase=LOWER(loControls.BASECLASS)
        DO CASE
          CASE LCClaseBase ="header"
            loControls.PICTURE=''
            loControls.BACKCOLOR=RGB(0,128,192)
            IF lcInit
              ****************************************
              * intercepto el click y llamo al proceso ordenar
              * que esta en esta misma clase
              ****************************************
              BINDEVENT(loControls,"Click",THIS,"Ordenar")
            ENDIF
          CASE LCClaseBase="textbox"
            IF lcInit
              ****************************************
              * intercepto el gotfocus y llamo al proceso
              * gorecno  que esta en esta misma clase
              ****************************************
              BINDEVENT(loControls,"gotfocus",THIS,"gorecno")
            ENDIF
        ENDCASE
      ENDFOR
    ENDFOR
  ENDPROC
  HIDDEN PROCEDURE gorecno
    **************************************
    * el proceso gorecno llama a otra clase
    * contenida en el form que se encarga de
    * mostrar los datos en pantalla
    ****************************************
    * thisform.ohaceboton.qhacer("M")
  ENDPROC
  PROCEDURE INIT
    IF DODEFAULT()
      THIS.pordefecto(.T.)
      THIS.indexar()
    ENDIF
  ENDPROC
ENDDEFINE
*
*-- EndDefine: ordergrid
**************************************************

************************************************************************************************
 Esta es una rutina que nos permitira saber el tiempo que el PC tiene encendido.


DECLARE INTEGER GetTickCount IN kernel32.DLL
lnSeconds = GetTickCount() / 1000
lnHours = INT (lnSeconds/3600)
lnSeconds = lnSeconds - lnHours * 3600
lnMinutes = INT (lnSeconds/60)
lnSeconds = lnSeconds - lnMinutes * 60
? "Encendido desde hace: " + ;
   STRTRAN(STR(lnHours,2) + ":" ;
   + STR(lnMinutes,2) + ":" ;
   + STR(lnSeconds,2), " ","0")

************************************************************************************************
************************************************************************************************
Con esta función podemos tomar la fecha y hora de un servidor Windows NT o superior, desde Visual FoxPro, con funciones de la API de Windows.


? ServerTime("\\MiServidor")

*----------------------------------------------------
* FUNCTION ServerTime(tcServerName, tlUtcTime)
* Retorna la hora del servidor pasado como parametro
* PARAMETROS:
*    tcServerName = Nombre del servidor
*    tlUtcTime = .T. FH UTC - .F. FH Local
* RETORNO: FechaHora ó .Null. si hubo error
* USO: ? ServerTime("\\MiServidor")
*----------------------------------------------------
FUNCTION ServerTime(tcServerName, tlUtcTime)
  IF PARAMETERS() < 2
    tlUtcTime = .F.
  ENDIF
  DECLARE INTEGER NetRemoteTOD IN netapi32 ;
    STRING @,  INTEGER @
  DECLARE INTEGER RtlMoveMemory IN win32api ;
    STRING @outbuffer, ;
    INTEGER inbuffer, ;
    INTEGER bytes2copy
  tdbuffout = REPLICATE(CHR(0), 48)
  tdbuffin = 0
  lcTryServerName = STRCONV(tcServerName, 5)
  rc = NetRemoteTOD(@lcTryServerName, @tdbuffin)
  IF rc = 0
    =RtlMoveMemory(@tdbuffout, tdbuffin, 48)
  ELSE
    lcTryServerName = STRCONV("\\" + tcServerName, 5)
    rc = NetRemoteTOD(@lcTryServerName, @tdbuffin)
    IF rc = 0
      =RtlMoveMemory(@tdbuffout, tdbuffin, 48)
    ELSE
      *-- Error con NetRemoteTOD()
      RETURN .Null.
    ENDIF
  ENDIF
  tod_month = str2long(SUBSTR(tdbuffout, 37, 4))
  tod_day = str2long(SUBSTR(tdbuffout, 33, 4))
  tod_year = str2long(SUBSTR(tdbuffout, 41, 4))
  tod_hours = str2long(SUBSTR(tdbuffout, 9, 4))
  tod_mins = str2long(SUBSTR(tdbuffout, 13, 4))
  tod_secs = str2long(SUBSTR(tdbuffout, 17, 4))
  tod_timezone = str2long(SUBSTR(tdbuffout, 25, 4)) * 60
  serverdatetime = DATETIME(tod_year, tod_month, tod_day, ;
    tod_hours, tod_mins, tod_secs)
  IF tlUtcTime
    tdServerTime = serverdatetime
  ELSE
    tdServerTime = serverdatetime - tod_timezone
  ENDIF
  RETURN tdServerTime
ENDFUNC

*----------------------------------------------------
FUNCTION str2long(tcLongStr)
  LOCAL ln, lnRetVal
  lnRetVal = 0
  FOR ln = 0 TO 24 STEP 8
    lnRetVal = lnRetVal + (ASC(tcLongStr) * (2^ln))
    tcLongStr = RIGHT(tcLongStr, LEN(tcLongStr) - 1)
  ENDFOR
  RETURN lnRetVal
ENDFUNC
*----------------------------------------------------

************************************************************************************************
 código abaixo cria um texto e armazena no campo do tipo general. No relatório, adicione um objeto OLE que aponte para o campo gText. 

CLEAR ALL
CLOSE DATABASES all
LOCAL lcStr
lcstr = "Note that there is a limit of 32 characters total for the sum of text"+;
 "before and text after for simple numbering. Multilevel numbering has a limit"+;
  "of 64 characters total for the sum of all levels.NOTE: The file must have a"+;
   ".RTF extension to work properly."+;
   "Note that there is a limit of 32 characters total for the sum of text"+;
 "before and text after for simple numbering. Multilevel numbering has a limit"+;
  "of 64 characters total for the sum of all levels.NOTE: The file must have a"+;
   ".RTF extension to work properly."
CREATE cursor ctext (lctext m,gText g) 
INSERT INTO ctext (lctext) VALUES (lcStr)
_rtfFile = "c:\"+SYS(3)+".rtf" 
SCAN 
   SET TEXTMERGE TO &_rtfFile NOSHOW
   SET TEXTMERGE ON
   \\{\rtf1\ansi\qj <>}
   SET TEXTMERGE TO
   APPEND GENERAL gText FROM &_rtfFile CLASS "RICHTEXT.RICHTEXTCTRL.1"
ENDSCAN
REPORT FORM rtfdemo PREVIEW NOCONSOLE


************************************************************************************************
Como saber la ruta de las carpetas Mis Documentos y Archivos de Programa
Con la Foundation Class que trae VFP podemos saber la ruta de la carpetas 
Mis Documentos y Archivos de programa.

Ejemplo:

lo = NEWOBJECT("_CommonFolder",HOME(1)+"FFC\_System")
lcMD = lo.GetFolder(5)
lcAP = lo.GetFolder(38)
lo = .Null.
MESSAGEBOX(lcMD,64,"Mis Documentos")
MESSAGEBOX(lcAP,64,"Archivos de programa")

************************************************************************************************
* Ajustar o volume

lcHex = GetVolume()
*-- % volumen altavoz izquierdo
lnIzq = CEILING(BITAND(EVALUATE(lcHex),0xFFFF)*100/0xFFFF)
*-- % volumen altavoz derecho
lnDer = CEILING((BITAND(EVALUATE(lcHex),0xFFFF0000)/0x10000)*100/0xFFFF)

? lcHex    && cadena hexadecimal
? lnIzq    && porcentaje volumen altavoz izquierdo
? lnDer    && porcentaje volumen altavoz derecho

*---------------------------------------------------
* FUNCTION GetVolume()
*---------------------------------------------------
* Toma el valor de volumen de los altavoces de la PC
* RETORNO: Caracter (cadena de caracteres hexadecimal)
* USO: GetVolume()
*---------------------------------------------------
FUNCTION GetVolume()
LOCAL ln
  DECLARE INTEGER waveOutGetVolume IN Winmm ;
    INTEGER wDeviceID, ;
    INTEGER @ dwVolume
    ln = 0x0000
    =waveOutGetVolume(0,@ln)
    RETURN TRANSFORM(ln,";@0")
ENDFUNC
*---------------------------------------------------



SetVolume(75,75)

*---------------------------------------------------
* FUNCTION SetVolume(tnIzq, tnDer)
*---------------------------------------------------
* Configura el volumen de los altavoces de la PC
* PARAMETROS:
*   tnIzq = Porcentaje de volumen altavoz izquierdo
*   tnDer = Porcentaje de volumen altavoz derecho
* RETORNO: Logico .T. si pudo configurar
* USO: SetVolume(50,50)
*---------------------------------------------------
FUNCTION SetVolume(tnIzq, tnDer)
  LOCAL lnVol
  DECLARE INTEGER waveOutSetVolume IN Winmm ;
    INTEGER wDeviceID, ;
    INTEGER dwVolume
  tnIzq = MAX(0,MIN(tnIzq,100))
  tnDer = MAX(0,MIN(tnDer,100))
  lnVol = EVALUATE("0x" + ;
    RIGHT(TRANSFORM(tnDer*0xFFFF/100,";@0"),4) + ;
    RIGHT(TRANSFORM(tnIzq*0xFFFF/100,";@0"),4))
  RETURN 0 = waveOutSetVolume(0,lnVol)
ENDFUNC
*---------------------------------------------------






************************************************************************************************
** Listbox com CheckBox
PUBLIC oForm

oForm = CREATEOBJECT("clsListCheckBox")

oForm.VISIBLE = .T.

READ EVENTS

DEFINE CLASS clsListCheckBox AS FORM

    TOP = 1
    LEFT = 0
    HEIGHT = 473
    WIDTH = 287
    DOCREATE = .T.
    CAPTION = "Listbox With Checkboxes"
    WINDOWSTATE = 0
    NAME = "clsListCheckBox"
    AlwaysOnTop = .T.
    CheckIcon = HOME() + "Graphics\Icons\Misc\MISC15.ICO"
    Uncheckicon = HOME() + "Graphics\Icons\Misc\MISC13.ICO"
    SHOWWINDOW = 2

    ADD OBJECT list1 AS LISTBOX WITH ;
        HEIGHT = 408, ;
        LEFT = 12, ;
        SORTED = .T., ;
        TOP = 48, ;
        WIDTH = 264, ;
        NAME = "List1", ;
        ROWSOURCETYPE = 2, ;
        ROWSOURCE = "ListCheck"
        
    PROCEDURE LOAD
        LOCAL nCount, nCount2, nWordLength, sItem, nUpper, nLower
        nUpper = 90 &&ASCII
        nLower = 65 &&ASCII
        CREATE CURSOR ListCheck (MyEntry c(35), Checked L)
        FOR nCount = 1 TO 250
            sItem = ""
            nWordLength = INT((35) * RAND( ) + 1)
            FOR nCount2 = 1 TO nWordLength
                sItem = sItem + CHR(INT((nUpper - nLower + 1) * RAND( ) + nLower))
            ENDFOR
            INSERT INTO ListCheck (MyEntry, Checked) VALUES(sItem, .F.)
        NEXT
    ENDPROC
        
    PROCEDURE Unload
        USE IN SELECT("ListCheck")
        CLEAR EVENTS
    ENDPROC

    PROCEDURE ListSetup
        THISFORM.LOCKSCREEN = .T.
        LOCAL nListCount
        nListCount = 1
        SELECT ListCheck
        SCAN ALL
            IF ListCheck.Checked
                THIS.list1.PICTURE(nListCount) = THISFORM.CheckIcon
            ELSE
                THIS.list1.PICTURE(nListCount) = THISFORM.Uncheckicon
            ENDIF
            nListCount = nListCount + 1
        ENDSCAN
        THISFORM.LOCKSCREEN = .F.
    ENDPROC

    PROCEDURE SetCheck
        LOCAL nListIndex
        nListIndex = THIS.list1.LISTINDEX
        IF nListIndex > 0
            GO nListIndex IN "ListCheck"
            IF ListCheck.Checked
                THIS.list1.PICTURE(nListIndex) = THISFORM.Uncheckicon
            ELSE
                THIS.list1.PICTURE(nListIndex) = THISFORM.CheckIcon
            ENDIF
            REPLACE ListCheck.Checked WITH !ListCheck.Checked
        ENDIF
    ENDPROC

    PROCEDURE list1.GOTFOCUS()
        IF DODEFAULT()
            THISFORM.ListSetup()
        ENDIF
    ENDPROC
    
    PROCEDURE list1.CLICK()
        IF LASTKEY() = 13
            THISFORM.SetCheck()
        ENDIF
    ENDPROC

    PROCEDURE list1.KEYPRESS(nKeyCode, nShiftAltCtrl)
        IF nKeyCode = 13 OR nKeyCode = 32
            THISFORM.SetCheck()
        ENDIF
    ENDPROC

ENDDEFINE

************************************************************************************************
Utilizando o código abaixo, é possível determinar o endereço IP e outras informações sobre o computador: 
PUBLIC IPSocket
crlf=CHR(13)+CHR(10)
IPSocket = CREATEOBJECT("MSWinsock.Winsock")
IF TYPE('IPSocket')='O'
   IPAddress = IPSocket.LocalIP
   localhostname=IPSocket.localhostname
   remotehost=IPSocket.remotehost
   remotehostip=IPSocket.remotehostip
   MESSAGEBOX ("Local IP = " + IPAddress+crlf+"local host = "+localhostname;
    +crlf+"Remotehost = "+remotehost+crlf+"Remotehostip = "+remotehostip)
ELSE
   MESSAGEBOX('Unable to determine IP Address')
ENDIF


************************************************************************************************

Como fazer para simular a tecla PRTSC do windows, ou seja, capturar a tela
do windows com todas janelas, etc. e salvar como imagem JPG


DECLARE INTEGER keybd_event IN Win32API INTEGER, INTEGER, INTEGER, INTEGER

*Capturar somente a tela atual = PRINTSCREEN
=keybd_event(44,1,0,0)
return

*Capturar somente a janela ativa = ALT+PRINTSCREEN
=keybd_event(44,0,0,0)

Agora vc só precisa salvar como JPG...
Sugiro dar uma olhada na UT...pois tem código de exemplo por lá na area de
Download...


************************************************************************************************
ENTER NO BROWSE
 
 
Faça o seguinte:


*/ Tranforma a tecla ENTER em CTRL+Q para sair
*
ON KEY LABEL ENTER KEYBOARD '{CTRL+Q}'

BROWSE

*/ Retorna o ENTER a situação original
*
ON KEY LABEL ENTER
 

************************************************************************************************
 Código simple que agrega un registro en blanco y repara la tabla.


*!* Antes de ejecutar este código realiza un respaldo de las tablas

Wait Window 'Si obtienes un "Not a database file", haz clic en Ignore' NoWait
Use MiTabla                  && Reemplazar con el nombre de la tabla
Wait Window 'ESC para cancelar o cualquier tecla para continuar'
*-
fh = FOpen('MiTabla.dbf', 2) && Reemplazar con el nombre de la tabla
=FSeek(fh, 0, 2)             && se mueve el puntero al EOF
=FWrite(fh, Space(123))      && al final agrega un registro en blanco
=FClose(fh)                  && Cierra la tabla
Wait Window 'Si puedes ver los datos, entonces se arregló satisfactoriamente'
Use MiTabla Exclusive        && Reemplazar con el nombre de la tabla
Go Bottom
Browse Last Nowait
ReIndex




************************************************************************************************
Es muy facil de manejar. Me funciona perfecto. La descompresion no esta, porque no la utilizo, pero al crear un zip, se puede abrir con cualquier compresor externo.


No recuerdo de donde lo baje, el código es el siguente: 

PROCEDURE creazip
  PARAMETER nomarch, incluye && archivo de destino, archivo a incluir
  PRIVATE ozip, nres
  ozip = NEWOBJECT('zip')
  nRes = ozip.zip(nomarch,incluye,.F.) && destino, origen, si mando .T., mueve los archivos
  RETURN nRes

DEFINE CLASS zip AS CUSTOM
  oZip = .NULL.
  PROCEDURE INIT
    =SYS(2333,0)
    DECLARE INTEGER DllRegisterServer IN 'ZipM2X.OCX' AS __DllRegisterServer__
    THIS.oZip = CREATEOBJECT( "ZipMastr2XControl1.ZipMastr2X" )
    WITH THIS.ozip
      .Verbose    = .F.       && habilita todos los posibles mensajes durante la compresion/descompresion
      .Unattended = .F.       && no muestra los mensajes durante la compresion/descompresion
      .Tempdir    = SYS(2023) && directorio temporal de trabajo
    ENDWITH
  ENDPROC

  PROCEDURE ZIP
    LPARAMETERS cDestFile, cSourceFiles, lAddMove
    WITH THIS.oZip
      .ZipFilename      = cDestFile && nomche archivo zip destino
      .AddMove          = lAddMove  && .T., mueve - .F. suma
      .AddCompLevel     = 9         && maximo nivel de compresion
      .AddDirNames      = .F.       && incluye el path en la compresion
      .AddRecurseDirs   = .F.
      .AddDiskSpan      = .F.
      .AddDiskSpanErase = .F.
      .FSpecArgs.ADD(cSourceFiles)  && lista de archivos a comprimir
      .ADD                          && agrega los archivos especificados en .fspecargs en .zipfilename
      * .GetAddPassword             && abre ventana de ingreso de password para .ADD
      * .GetExtrPassword            && abre ventana de ingreso de password para .Extract
    ENDWITH
    RETURN THIS.oZip.ErrCode
  ENDPROC
ENDDEFINE


************************************************************************************************
Como criar uma classe vazia


*---------------------------------------------------------------------
* EmptyObject(fieldsList)
* Receives a list of fields separated by comma
* Returns an empty object with empty properties
* Recibe una lista de campos sepados por comas
* Retorna un objeto Empty con propiedades basadas 
* en objetos empty
*---------------------------------------------------------------------

* Test:
Customer = EmptyObject("Name,Address,Phone,Contacts[5]")
Customer.Address = EmptyObject("Street,City,State,Zip,Country")
Customer.Name  = "John Doe"
Customer.Phone = "555-1234"
Customer.Address.City  = "Sunny Beach"
Customer.Address.State = "FL"
Customer.Address.Zip   = "12345"
Customer.Contacts[1]   = "Jane Doe"
Customer.Contacts[2]   = "Jim Doe"
*** Revise el objeto Customer
Set Step On && Check out Customer object
Return Customer

*---------------------------------------------------------------------
Function EmptyObject
    LParameters fieldsList As String

    If Empty(fieldsList) Then
        Return Null
    Endif

    Local Array fieldsArray[1]
    Alines(fieldsArray,fieldsList,.T.,",")

    Local oEmpty
    oEmpty = NewObject("Empty")

    Try
        For Each item In fieldsArray
            AddProperty(oEmpty,item,"")
        Endfor
    Catch
        oEmpty = Null
    Endtry

    Return oEmpty
EndFunc
*--------------------------------------------------------------------- 

************************************************************************************************
  
Saber si un cursor ha sido modificado
Enviado por: Esparta Palma 
 
 
 La función devolverá un valor booleano si hubo algún cambio en cualquiera de los registros, ya sea que borraron, modificaron, si agregaron.


 FUNCTION IsCursorChanged
    LPARAMTERS tcCursor

    LOCAL lnRecno,;
          lnRetValue
    lcOldAlias = SELECT(0) && SET COMPATIBLE debe estar en OFF
    SELECT (tcCursor)
    lnRecno = RECNO(tcCursor)  && Guardamos el num de reg. donde estaba
    LOCATE  && Ir al primer registro del cursor
    lnRetValue = GETNEXTMODIFIED(0,tcCursor)
    GO TOP
    IF NOT(EOF(tcCursor)) && ¿Es un cursor vacio?
       GO lnRecno && Regresamos el puntero a donde se quedó
     ENDIF
    SELECT (lcOldAlias) && Regresamos al área donde se encontraba
    RETURN lnRetValue # 0
 ENDFUNC 


Notas adicionales: El cursor debe tener Buffering en Modo de Tabla (optimista o pesimista, 5 o 4), SET MULTILOCKS debe estar en ON 
 
 
************************************************************************************************
Grafico EXCEL a partir do VFP
*************************************************************
*** Grafica de Pastel en MS Excel con formateo de datos   ***
*** Proceso de Envio a MS EXCEL                           ***
*************************************************************

oExcel = CREATEOBJECT("Excel.Application")
WITH oExcel
	.Visible = .T.
	.Workbooks.Add
	.Worksheets(1).Activate
	.Worksheets(1).Name = "GRAFICA"
	.Columns("A:A").ColumnWidth = 45
	.Columns("B:B").Select
	.Selection.NumberFormat = "#,##0.00"
	.Columns("E:E").ColumnWidth = 14.31
	.Columns("E:E").Select
	.Selection.NumberFormat = "#,##0.00"
	.Selection.Font.Bold = .T.
	
	.Range("A1:E1").Select
	WITH .Selection.Font
         .Bold=.T.
         .Size = 14
         .Name = "TAHOMA"
    ENDWITH 
    WITH .Worksheets(1)
         .Cells(1,1).Value = "MI EMPRESA"
         .Cells(3,1).Value = "Fecha de Impresión: " + ALLTRIM(DTOC(DATE()))
    ENDWITH      
    .Range("A3:E3").Select
    WITH .Selection
		 .Merge
		 .MergeCells = .T.
		 .HorizontalAlignment  = 1
		 .VerticalAlignment    = 1
		 .Font.Bold = .T.
	ENDWITH 	 
    .Worksheets(1).Cells(4,1).Value = "Fecha de Anásilis: " + ALLTRIM(DTOC(DATE())) && loFecha
    .Range("A4:E4").Select
    WITH .Selection
		 .Merge
		 .MergeCells = .T.
		 .HorizontalAlignment  = 1
		 .VerticalAlignment    = 1
		 .Font.Bold = .T.
	ENDWITH 	 
    .Range("A3:E4").Select

** Borders(1) = Linea vertical interior
** Borders(2) = Linea vertical exterior
** LineStyle = 1,7    && Línea delgada continua
** LineStyle = 2      && Línea delgada discontinua
** LineStyle = 3,8    && Línea delgada discontinua de puntos
** LineStyle = 4      && Línea delgada discontinua linea-punto
** LineStyle = 5      && Línea delgada discontinua de puntos dobles
** LineStyle = 6      && Línea gruesa continua
** LineStyle = 9,12   && Línea doble fija delgada
** LineStyle = 10,11  && Línea punto_line delgada
    WITH .Selection
		 .Borders(2).LineStyle = 1
		 .Borders(2).Weight = 3
		 .Borders(3).LineStyle = 1
		 .Borders(3).Weight = 3
		 .Borders(4).LineStyle = 1
		 .Borders(4).Weight = 3  && propiedad del de ancho de linea 1-4; 3 Optimo
	ENDWITH 	 
    .Range("A4:E4").Select
    WITH .Selection
		 .Borders(3).LineStyle = 1
		 .Borders(4).LineStyle = 1
	ENDWITH 	 
    && Titulo de ESQUEMACIÖN
    .Range("A6:E6").Select
    .Worksheets(1).Cells(6,1).Value = "PUBLICIDAD ESQUEMADA"
	WITH .Selection.Font
         .Bold=.T.
         .Size = 12
         .Name = "TAHOMA"
    ENDWITH 
    WITH .Selection
		 .Merge
		 .MergeCells = .T.
		 .HorizontalAlignment  = 1
		 .VerticalAlignment    = 1
		 .Font.Bold = .T.
	ENDWITH 	 
    WITH .Selection
		 .Borders(2).LineStyle = 1
		 .Borders(2).Weight = 3
		 .Borders(3).LineStyle = 1
		 .Borders(3).Weight = 3
		 .Borders(4).LineStyle = 1
		 .Borders(4).Weight = 3  && propiedad del de ancho de linea 1-4; 3 Optimo
	ENDWITH 	
	DIMENSION titulo(6)	 
	DIMENSION valor(6)	 
	titulo(1) = " TOTAL DE PAGINAS "
	titulo(2) = " TOTAL DE CMS COLUMNARIO POR PAGINA "
	titulo(3) = " TOTAL DE CMS COLUMNARIO POR EJEMPLAR "
	titulo(4) = " TOTAL PUBLICIDAD PAGADA "
	titulo(5) = " TOTAL PUBLICIDAD CORTESIA "
	titulo(6) = " TOTAL NOTICIAS "

	valor(1) = 32
	valor(2) = 234
	valor(3) = 7488
	valor(4) = 3256
	valor(5) = 1256
**	valor(6) = crGraph.TTCCSINUSAR - (Thisform.Cant_norm+Thisform.Cant_cort)
	valor(6) = valor(3) - (valor(4)+valor(5))
	FOR I = 1 TO 6
	    && Titulo de " TOTAL DE PAGINAS "
	    lc = 7+I
        loK = "A"+ALLTRIM(STR(lc))+":A"+ALLTRIM(STR(lc))
	    .Range(loK).Select
	    .Worksheets(1).Cells(lc,1).Value = titulo(i)
	    .Worksheets(1).Cells(lc,2).Value = valor(i)
		WITH .Selection.Font
	         .Bold=.T.
	         .Size = 10
	         .Name = "TAHOMA"
	    ENDWITH 
	    WITH .Selection
			 .Merge
			 .MergeCells = .T.
			 .HorizontalAlignment  = 1
			 .VerticalAlignment    = 1
			 .Font.Bold = .T.
		ENDWITH 	 
	NEXT
	
    && Realizamos la GRAFICA 	
    
    .Charts.Add
	.ActiveChart.ChartType = 70 && Tipo Pastel
	.ActiveChart.SetSourceData(.Sheets("GRAFICA").Range("A11:B13"),2) && Rango de Datos
	.ActiveChart.Location(2,"GRAFICA")
    .ActiveChart.HasTitle = .T.
    .ActiveChart.ChartTitle.Characters.Text = "MI EMPRESA"
    .ActiveChart.SeriesCollection(1).ApplyDataLabels(3)  && Tipo de Aplicación de Leyendas A LA IZQUIERDA
    .ActiveSheet.Shapes("Gráfico 1").IncrementLeft(-173.25) && Posicionamiento de la Grafica a la Izquierda
    .ActiveSheet.Shapes("Gráfico 1").IncrementTop(68.75) && Posicionamiento de la Grafica hacia Arriba
    .ActiveSheet.Shapes("Gráfico 1").ScaleWidth(1.28,.F.,0) && Escala de Ancho de la Gráfica
    .ActiveSheet.Shapes("Gráfico 1").ScaleHeight(1.15,.F.,0)&& Escala de Largo de la Gráfica
    
    && Escribimos las leyendas col letras mas chicas
    .ActiveSheet.ChartObjects("Gráfico 1").Activate && "Grafico 1" = Título del Gráfico
    .ActiveChart.ChartArea.Select
    .ActiveChart.Legend.Select
    loCont = .ActiveChart.Legend.LegendEntries.Count && Cantidades de Leyendas a Formatear, en este caso 3
    FOR I = 1 TO loCont
	    .ActiveChart.Legend.LegendEntries(I).AutoScaleFont = .T.
	    With .ActiveChart.Legend.LegendEntries(I).Font
	        .Name = "Tahoma"
	        .Size = 8
	        .Strikethrough = .F.
	        .Superscript = .F.
	        .Subscript = .F.
	        .OutlineFont = .F.
	        .Shadow = .F.
	        .Underline = .F.
	        .ColorIndex = 0
	    ENDWITH 
    NEXT 
    
    && Personalizamos Las leyedendas de Porcentajes
    
    .ActiveSheet.ChartObjects("Gráfico 1").Activate
    .ActiveChart.ChartArea.Select
    loCont = .ActiveChart.SeriesCollection.Count
    FOR I = 1 TO loCont
	    .ActiveChart.SeriesCollection(I).DataLabels.AutoScaleFont = .T.
	    With .ActiveChart.SeriesCollection(I).DataLabels.Font
	        .Name = "Verdana"
	        .Size = 8
	        .Bold = .T.
	        .Strikethrough = .F.
	        .Superscript = .F.
	        .Subscript = .F.
	        .OutlineFont = .F.
	        .Shadow = .F.
	        .Underline = .F.
	        .ColorIndex = 0
	    EndWith
    NEXT
    
    && Guardamos la grafica

    .ActiveWorkbook.SaveAs((CURDIR()+"Graph_Esquemacion.xls"), -4143, "", "", .F., .F.)
    .WorkBooks.Close
ENDWITH 

oExcel = .NULL.
RELEASE oExcel

************************************
*** FIN ***
************************************

************************************************************************************************
**************************************************
* Funcion: GetFoxEXEVersion
* Obter a versao em que foi compilado o EXE 
* Autor: Rick Bean rgbean@unrealmelange-inc.com
* Ejemplo: ?GetFoxEXEVersion(GETFILE("EXE"))
**************************************************

* GetFoxEXEVersion.prg
LPARAMETERS p_cEXEName
DIMENSION VersionInfo[8,3]
VersionInfo[1,1] = "FPW 2.5"
VersionInfo[2,1] = "FPW 2.6"
VersionInfo[3,1] = "VFP 3.0"
VersionInfo[4,1] = "VFP 5.0"
VersionInfo[5,1] = "VFP 6.0"
VersionInfo[6,1] = "VFP 7.0"
VersionInfo[7,1] = "VFP 8.0"
VersionInfo[8,1] = "VFP 9.0"
VersionInfo[1,2] = "foxw"
VersionInfo[2,2] = "foxw"
VersionInfo[3,2] = "VisualFoxProRuntime.3"
VersionInfo[4,2] = "VisualFoxProRuntime.5"
VersionInfo[5,2] = "VisualFoxProRuntime.6"
VersionInfo[6,2] = "VisualFoxProRuntime.7"
VersionInfo[7,2] = "VisualFoxProRuntime.8"
VersionInfo[8,2] = "VisualFoxProRuntime.9"
VersionInfo[1,3] = "00D1"
VersionInfo[2,3] = "0111"
VersionInfo[3,3] = ""
VersionInfo[4,3] = "3228"
VersionInfo[5,3] = "1418"
VersionInfo[6,3] = "162C"
VersionInfo[7,3] = "1638"
VersionInfo[8,3] = "10EC" && beta 1
LOCAL lnii, lcVersion, lnHandle, lcKeyName

lnHandle = FOPEN(p_cEXEName, 0)
IF lnHandle < 0
 RETURN "Unable to Open file"
ENDIF

lcVersion = "(unknown)"
FOR lnii = 1 TO 8
 IF !EMPTY(VersionInfo[lnii,3])
  = FSEEK(lnHandle, EVALUATE("0x"+VersionInfo[lnii,3]))
  lcKeyName = VersionInfo[lnii,2]
  IF FGETS(lnHandle, LEN(lcKeyName)) == lcKeyName
     lcVersion = VersionInfo[lnii, 1]
     EXIT
  ENDIF
 ENDIF
ENDFOR
=FCLOSE(lnHandle)

RETURN lcVersion
************************************************************************************************
Insertar Tablas en Microsoft Word usando Automation. 
Enviado por: Esparta Palma  el Miércoles, 22 de Diciembre de 2004 - 12:03 AM GMT 

A continuación, un codigo de ejemplo de como insertar tablas en un documento de Microsoft Word, como un agregado más, también se ve una pequeña interacciòn con el Asistente del producto. Cortesia de Çetin Basöz, MS-MVP de Visual FoxPro.

Clear All
OPEN DATABASE (HOME(2)+"Data\testdata.dbc")

Select Top 10 cust_id, company, contact ;
  from "customer" ;
  into Cursor mmCursor ;
  order By cust_id

* Assuming VFP7 and later 'As ...' added to get help from IntelliSense
Local oWord As 'Word.application', ;
  oDocument As "Word.Document", ;
  loTable As 'Word.Table', ;
  loRow As 'Word.Row'

oWord = Createobject("Word.Application")
oWord.Visible = .T.
oWord.Activate
oDocument = oWord.Documents.Add

* Create a balloon object for feedback
Local loBalloon
loBalloon = oWord.Assistant.NewBalloon

With oDocument.MailMerge
  * Attach the data to the document
  .CreateDataSource("dummyfilename.doc",,,;
      "Customer_ID, Company, Contact_name")
  .EditDataSource

  * CreateDataSource inserted the table with an extra blank row
  loTable = oWord.ActiveDocument.Tables(1)
  * Now open the data source and put the data into the document
  With loBalloon
  	.Heading = 'Starting scan....'
  	.Show
  endwith
  Scan
    loRow = loTable.Rows.Add() && Add as if we had no extra at top

    For Ix = 1 To Fcount()
      loRow.Cells[ Ix ].Range.InsertAfter(;
        Trim(Eval(Fields(Ix)))) && Trans if not all char
    Endfor
  Endscan
  With loBalloon
  	.Heading = 'Scan ended. OK to delete row 2.'
  	.Show
	loTable.Rows(2).Delete()
	.Heading = 'Activating main doc.'
	.Show
  endwith
  .EditMainDocument
Endwith

************************************************************************************************
Proteger con contraseña documentos de Microsoft Excel (usando Automation) 
Enviado por: Esparta Palma  el Martes, 21 de Diciembre de 2004 - 12:04 AM GMT 

Un pequeño ejemplo de cómo proteger documentos XLS usando Microsoft Office Automation, cortesia de Çetin Basöz, MS-MVP de Visual FoxPro...

OPEN DATABASE (HOME(2)+"Data\testdata.dbc")

Use orders
lcXLS = Sys(5)+Curdir()+'orders.xls'
Copy To (lcXLS) Type Xls
lcLastColumn = Chr(Asc('A')-1+Fcount()) && Last col not locked

oExcel = Createobject('Excel.application')
With oExcel
  .Workbooks.Open(lcXLS)
  With .ActiveWorkbook.ActiveSheet
    .UsedRange.Locked = .T.
    .Range(lcLastColumn+':'+lcLastColumn).Locked = .F.
    .Protect('mypassword')
  Endwith
  .Visible = .T.
Endwith

************************************************************************************************
RECUPERAR REGISTROS DE UMA TABELA APÓS O ZAP 

Função permite recuperar N registros de uma tabela que não foi ainda manipulada após o comando ZAP. 

Uso: 
ZAP 
=UNZAP(47) && recupera 47 registros 

Código: 
FUNCTION UNZAP 
PARAMETER Y 
IF Y>0 .AND. USED() 
   IF RECCOUNT()=0 
      FILENAME=DBF() 
      USE 
      HANDLE=FOPEN(FILENAME,2) 
      IF HANDLE>0 
         BYTE=FREAD(HANDLE,32) 
         BKUP_BYTE=BYTE 
         FIELD_SIZE=ASC(SUBSTR(BYTE,11,1))+(ASC(SUBSTR(BYTE,12,1))*256) 
         FILE_SIZE=FSEEK(HANDLE,0,2) 
         BYTE8=CHR(INT(Y/(256*256*256))) 
         BYTE7=CHR(INT(Y/(256*256))) 
         BYTE6=CHR(INT(Y/256)) 
         BYTE5=CHR(MOD(Y,256)) 
         BYTE=SUBSTR(BYTE,1,4)+BYTE5+BYTE6+BYTE7+BYTE8+SUBSTR(BYTE,9) 
         =FSEEK(HANDLE,0) 
         =FWRITE(HANDLE,BYTE) 
         =FCHSIZE(HANDLE,FILE_SIZE+(FIELD_SIZE*Y)) 
         =FCLOSE(HANDLE) 
      ENDIF 
      USE &FILENAME 
   ENDIF 
ENDIF 

************************************************************************************************
  
Función para convertir un arreglo en un cursor.
Enviado por: Esparta Palma 
 
 
 Esta interesante rutina permite crear un cursor VFP basandose en los contenidos de un arreglo.

La siguiente función fue enviada a los foros públicos de VFP en inglés:

*****************************************
* Subject: Re: data from array into cursor
* Sender: George
* Date: 06/12/2004
* newsgroups: microsoft.public.fox.programmer.exchange
*****************************************

Espero les sea de utilidad...


***************************************************************
* Function: Abrowse
* Convierte un arreglo en un cursor VFP, basandose en los tipos 
*    de datos que contiene el arreglo
* Parametros:
*        anyArray: El arreglo en cuestión, debe pasarse por referencia
*        cursorName: Nombre del cursor a crear
*        isTraversed: Identifica si se va a crear un cursor transversal
*            mente, para su uso con arreglos unidimensionales
* Ejemplo de uso:
*     IF AGetFileVersion(testArray,Home()+'vfp8.exe') > 0
*        IF ABROWSE(@testArray,"myTest",.T.)
*            BROWSE LAST NOWAIT
*         ELSE
*            Messagebox("No se pudo crear el cursor")
*         ENDIF
*     ELSE
*       Messagebox("Error al obtener datos de VFP8.exe")
*     ENDIF
* 
************************************************************+


FUNCTION ABROWSE
*-- Pre conditions
    LPARAMETERS anyArray, cursorName, isTraversed
    isArray = ( TYPE("ALEN(anyArray,1)") == "N" )
    IF NOT isArray THEN
        Return .F.
    ENDIF
    IF Vartype(cursorName)<>"C" OR Empty(cursorName) THEN
        cursorName = "tempArray"
    ENDIF

*-- Guess Field Types
    If isTraversed Then
        colCount = ALEN(anyArray,1)
        rowCount = ALEN(anyArray,2)
        IF rowCount = 0 THEN    && One dimension ?
            rowCount = 1
        EndIf
    Else
        rowCount = ALEN(anyArray,1)
        colCount = ALEN(anyArray,2)
        IF colCount = 0 THEN    && One dimension ?
            colCount = 1
        EndIf
    Endif


    DIMENSION fieldTypes[colCount,3]
    * First get types
    FOR I = 1 TO colCount
        fieldTypes[I,1] = IIF(colCount=1,VARTYPE(anyArray[I]),VARTYPE(anyArray[1,I]))
    ENDFOR
    * Then get maxWidth
    FOR I = 1 TO colCount
        fieldTypes[I,2] = 1        && Length
        fieldTypes[I,3] = 0        && Decimals
        FOR J = 1 TO rowCount
            anyValue = IIF(colCount=1,TRANSFORM(anyArray[J]),TRANSFORM(anyArray[J,I]))
            isMemoField = ( AT(CHR(13),anyValue)>0 )
            IF isMemoField THEN
                fieldTypes[I,1] = "M"
            ENDIF
            fieldTypes[I,2] = MAX(fieldTypes[I,2],LEN(anyValue))
            IF fieldTypes[I,1] == "N" THEN
                hasDecimals = ( AT(".",anyValue) > 0 )
                IF hasDecimals THEN
                    fieldTypes[I,3] = MAX( fieldTypes[I,3], LEN(anyValue) - AT(".",anyValue) )
                ENDIF
            ENDIF
        ENDFOR
    ENDFOR

*-- Create Cursor
    cursorScript = "CREATE CURSOR <>(<>)"
    cursorFields = ""
    FOR I = 1 TO colCount
        fieldName = "column" + ALLTRIM(STR(I))
        fieldType = fieldTypes[I,1]
        fieldLen  = fieldTypes[I,2]
        fieldDec  = fieldTypes[I,3]
        DO CASE
            CASE fieldTypes[I,1] == "C"
                newField = Textmerge("<> C(<>) NULL")
            CASE fieldTypes[I,1] == "N"
                newField = Textmerge("<> N(<>,<>) NULL")
            CASE INLIST(fieldTypes[I,1],'M','I','D','T','L','Y')
                newField = Textmerge("<> <> NULL")
            OTHERWISE
                newField = Textmerge("<> C(120) NULL")
        ENDCASE
        cursorFields = cursorFields + newField + IIF(I
    ENDFOR
    cursorScript = Textmerge(cursorScript)

*-- Run the script
    scriptError = .F.
    Try
        OK = ExecScript(cursorScript)
    Catch To oError
        scriptError = .T.
        MessageBox(oError.Message,16,"Error")
    EndTry

*-- Fill the cursor
    IF NOT scriptError THEN
        Select(cursorName)
        INSERT INTO (cursorName) FROM ARRAY anyArray
        LOCATE
    ENDIF

    response = NOT scriptError
    RETURN response
ENDFUNC 
 
 
 
************************************************************************************************
El Script Control de Microsoft nos da la posibilidad de ejecutar código JavaScript o VBScript desde nuestras rutinas escritas en Visual FoxPro.


Usando la potencia de Script Control

El Script Control de Microsoft nos da la posibilidad de ejecutar código JavaScript o VBScript desde nuestras rutinas escritas en Visual FoxPro. Además nos permite hacer referencia a objetos propios para invocar métodos o setear propiedades desde el script.

Veamos un ejemplo

Local loScript, lcCode
* Instancio el Microsoft Script Control
loScript = CreateObject("MSScriptControl.ScriptControl.1")
* Indico que el script a ejecutar será en Javascript
loScript.Language = "Javascript"
* Agrego la referencia al desktop de VFP (objeto _Screen)
loScript.AddObject("VFPDesktop", _Screen)
* Escribo el código JScript en una variable
Text To lcCode Textmerge NoShow
    var i, cCaption = "Esto lo hizo Javascript";
    VFPDesktop.Caption = cCaption;
    VFPDesktop.Cls();
    for(i=1;i<=10;i++)
        VFPDesktop.Print( "Iteración FOR en Java Nº" + i + "\n\r" );
EndText
* Finalmente, ejecuto el script
loScript.ExecuteStatement(lcCode)


Sugerencia

Cuando desarrollamos aplicaciones web, normalmente tenemos que codificar ciertas rutinas en JS o VBS para resolver funcionalidad del lado del cliente. Una práctica muy habitual es agrupar nuestro código en un archivo .js o .vbs que luego lo incluímos en nuestras páginas.

De esta forma, para no tener que transcribir código de otro lenguaje en nuestras rutinas VFP, podemos codificar en un archivo externo y usar FileToStr() como argumento en la invocación del método .ExecuteStatement.

Acerca del autor

Esteban Bruno nació el 25 de marzo de 1973 en Buenos Aires, Argentina. En el año 1992 se recibió de Analista Programado en la Comisión Argentina de Informática, y en 1998 egresó de la Universidad CAECE con el título de Licenciado en Sistemas. Desde el año 1990 ha trabajado en el área de desarrollo en diferentes empresas y utilizando una amplia gama de lenguanjes (Cobol, C, Clipper, FoxBase, FoxPro desde 2.5 para DOS hasta Visual FoxPro 9, Visual Basic, ASP, Java, etc.) y tecnologías. Es socio del MUG Argentina (Microsoft User Group) y actualmente se desempeña como Analista Funcional en IMR S.A. y dirige el Dpto. de Sistemas de TASSO S.R.L.
Contacto: bruno@tasso.com.ar

************************************************************************************************
Lenguaje del Sistema Operativo
Enviado por: Luis María Guayán 
 
 
 Con esta API podemos saber el lenguaje por defecto del Sistema Operativo o del Usuario.


Ejemplo:

? DefaultLanguage("SYSTEM")
? DefaultLanguage("USER")

*----------------------------------------------------
* FUNCTION DefaultLanguage(tc)
*----------------------------------------------------
* Retorna el lenguaje por defecto del SO
* USO: ? DefaultLanguage()
* PARAMETROS:
*      "SYSTEM" = Retorna el lenguaje del sistema
*      "USER" = Retorna el lenguaje del usuario
* RETORNA: Caracter
*----------------------------------------------------
FUNCTION DefaultLanguage(tc)
  LOCAL lnIdLeng, lcLeng
  IF EMPTY(tc)
    tc = "SYSTEM"
  ENDIF
  DO CASE
    CASE UPPER(tc) = "SYSTEM"
      DECLARE SHORT GetSystemDefaultLangID IN kernel32
      lnIdLeng = GetSystemDefaultLangID()
    CASE UPPER(tc) = "USER"
      DECLARE SHORT GetUserDefaultLangID IN kernel32
      lnIdLeng = GetUserDefaultLangID()
    OTHERWISE
      RETURN ""
  ENDCASE
  DO CASE
    CASE lnIdLeng % 256 = 0 && Neutral
      lcLeng = "Neutral"
    CASE lnIdLeng % 256 = 1 && Arabe
      lcLeng = "Arabe"
    CASE lnIdLeng % 256 = 3 && Catalán
      lcLeng = "Catalán"
    CASE lnIdLeng % 256 = 4 && Chino
      lcLeng = "Chino"
    CASE lnIdLeng % 256 = 7 && Alemán
      lcLeng = "Alemán"
    CASE lnIdLeng % 256 = 8 && Griego
      lcLeng = "Griego"
    CASE lnIdLeng % 256 = 9 && Inglés
      lcLeng = "Inglés"
    CASE lnIdLeng % 256 = 10 && Español
      lcLeng = "Español"
    CASE lnIdLeng % 256 = 12 && Francés
      lcLeng = "Francés"
    CASE lnIdLeng % 256 = 16 && Italiano
      lcLeng = "Italiano"
    CASE lnIdLeng % 256 = 17 && Japonés
      lcLeng = "Japonés"
    CASE lnIdLeng % 256 = 18 && Coreano
      lcLeng = "Coreano"
    CASE lnIdLeng % 256 = 22 && Portugues
      lcLeng = "Portugués"
    CASE lnIdLeng % 256 = 29 && Sueco
      lcLeng = "Sueco"
    CASE lnIdLeng % 256 = 86 && Gallego
      lcLeng = "Gallego"
    CASE lnIdLeng % 256 = 107 && Quechua
      lcLeng = "Quechua"
    OTHERWISE
      lcLeng = "Otro lenguaje"
  ENDCASE
  RETURN lcLeng
ENDFUNC
*----------------------------------------------------
 
	
************************************************************************************************
 Este código funciona perfectamente para enviar mensajes en una red 98 o 2k es para utilizarlo en lugar del net send o el winpopup.


*========================================================
* ENVIAR MENSAJES COMO SI FUERA NET SEND
*========================================================
LParameter tcTarget, tcSender, tcReceipient, tcMessage
  *------------------------------------------------------
  * Open the mailslot that is used by NET SEND
  *------------------------------------------------------
  #DEFINE GENERIC_WRITE                        0x40000000
  #DEFINE FILE_SHARE_READ                      0x00000001
  #DEFINE OPEN_EXISTING                                 3
  #DEFINE FILE_ATTRIBUTE_NORMAL                0x00000080
  #DEFINE INVALID_HANDLE_VALUE                         -1
  Local lnHandle, llOK
  Declare Long CreateFile in Win32API ;
    String, Long, Long, Long, Long, Long, Long 
  lnHandle = CreateFile( ;
    "\\"+m.tcTarget+"\mailslot\messngr", ;
    GENERIC_WRITE, ;
    FILE_SHARE_READ, ;
    0, ;
    OPEN_EXISTING, ;
    FILE_ATTRIBUTE_NORMAL, ;
    0 ;
  )
  llOK = (m.lnHandle#INVALID_HANDLE_VALUE)
  *------------------------------------------------------
  * Write the message into the mailslot.
  *------------------------------------------------------
  Local lcMessage, lnBytes
  If m.llOK
    lcMessage = m.tcSender + Chr(0) + m.tcReceipient + ;
      Chr(0) + m.tcMessage + Chr(0)
    Declare Long WriteFile in Win32API ;
      Long, String, Long, Long@, Long
    lnBytesWritten = 0
    llOK = WriteFile( m.lnHandle, ;
    	m.lcMessage, ;
      Len(m.lcMessage), ;
      @lnBytes, ;
      0 ;
    ) # 0
  Endif
  *------------------------------------------------------
  * Close mailslot
  *------------------------------------------------------
  If m.lnHandle # INVALID_HANDLE_VALUE
    Declare CloseHandle in Win32API Long
    CloseHandle( m.lnHandle )
  Endif 
Return m.llOK

************************************************************************************************
**********************************************************
** Form param mostrar PDF
**********************************************************
** Author      : Ramani (Subramanian.G)
**               FoxAcc Software / Winners Software
** Type        : Freeware with reservation to Copyrights
** Warranty    : Nothing implied or explicit
**********************************************************
** I used PDF reader ver 6.0.
** Should work with earlier versions also
** If necessary change suitably in the line ...
**	ADD OBJECT olecontrol1 AS olecontrol WITH ;
**      OLEClass = "PDF.PdfCtrl.5"
**********************************************************
PUBLIC oform1

oform1=NEWOBJECT("form1")
oform1.Show
RETURN
**********************************************************
DEFINE CLASS form1 AS form

   DoCreate = .T.
   Caption = "pdfForm"
   Name = "Form1"

   ADD OBJECT cmdfile AS commandbutton WITH ;
      Top = 12, ;
      Left = 12, ;
      Height = 27, ;
      Width = 144, ;
      Caption = "Select File", ;
      Name = "cmdFile"

   ADD OBJECT cmdexit AS commandbutton WITH ;
      Top = 12, ;
      Left = 168, ;
      Height = 27, ;
      Width = 84, ;
      Caption = "E\<xit", ;
      Name = "cmdExit"

   ADD OBJECT olecontrol1 AS olecontrol WITH ;
      OLEClass = "PDF.PdfCtrl.5", ;
      Top = 48, ;
      Left = 12, ;
      Height = 192, ;
      Width = 348, ;
      Name = "Olecontrol1"

   PROCEDURE Init
      ThisForm.ReSize()
   ENDPROC

   PROCEDURE Resize
      ThisForm.Olecontrol1.Height = ThisForm.Height - 60
      ThisForm.Olecontrol1.Width = ThisForm.Width - 24
      ThisForm.Olecontrol1.Refresh()
   ENDPROC

   PROCEDURE cmdfile.Click
      LOCAL cFile
      cFile = GETFILE([PDF])
      IF !EMPTY(cFile)
         THISFORM.oleControl1.LoadFile([&cFile])
      ENDIF
   ENDPROC

   PROCEDURE cmdexit.Click
      ThisForm.Release()
   ENDPROC

ENDDEFINE
**********************************************************
** EOF
**********************************************************
************************************************************************************************
** A simple function to do backup.
**********************************************************
** Author   : Ramani (Subramanian.G)
**            FoxAcc Software / Winners Software
**            ramani_g@yahoo.com
** Type     : Freeware with reservation to Copyrights
** Warranty : Nothing implied or explicit
**********************************************************
** You need CabArc tools for the following.
** You can download CabArc tools from...
** http://support.microsoft.com/default.aspx?scid=kb%3Ben-us%3B310618
**
** How to use ....
**    lcSource = "c:\myDirectory\*.*"
**    lcDestination = "c:\myBack\myBack1.CAB"
**    =gsCabBack(mySource,myDestination)
**********************************************************
** Instead of CAB, you can use WinZips's
** command line utility also, in which case
** change the code 'lcCmd' suitably.
**********************************************************
FUNCTION gsCabBack
LPARAMETERS lcSource, lcDestination
LOCAL lcCmd, lnSuccess, loShell
IF !EMPTY(lcDestination) OR !EMPTY(lcSource)
   lcCmd = "CABARC -r -p N " + ;
           lcDestination + SPACE(1) + lcSource
   loShell = CREATEOBJECT("wscript.shell")
   lnSuccess = loShell.Run(lcCmd,1,.t.)
   IF lnSuccess = 0
      =MESSAGEBOX("BackUp successful.",0+64,"Backup OK!")
   ELSE
      =MESSAGEBOX("BackUp failed",0+16,"Caution")
   ENDIF
ENDIF
RETURN lnSuccess
**********************************************************
** EOF
**********************************************************



************************************************************************************************
Sincronizar data/hora do servidor

*********************************************************
** Author   : Ramani (Subramanian.G)
**            FoxAcc Software / Winners Software
** Type     : Freeware with reservation to Copyrights
** Warranty : Nothing implied or explicit
*********************************************************
** You can incorporate this code suitably.
** Replace 'myServer' with server name suitably
**   and can be done with a function as well.

myServerName = "myServer"
lcCmd = GETENV("ComSpec") + " /C NET TIME \\"+ ;
        myServerName+" /SET /YES"
loShell = CREATEOBJECT("wscript.shell")
loShell.Run(lcCmd,0,.t.)
*********************************************************

************************************************************************************************
Enviar tecla para um software esterno


Listado Completo 
Local lnHWND, loWSH

* Declaramos funciones de las API de Windows
DECLARE LONG FindWindow IN WIN32API AS FindWindow STRING @a, STRING @b
DECLARE LONG SetForegroundWindow IN WIN32API LONG 

* Buscamos una instancia de la aplicación para obtener su Handler
lnHWND = FindWindow(0, "Calculator")
If lnHWND = 0
    * Si no se está ejecutando, la ejecutamos
    Run /N Calc.EXE
    * Y obtenemos su Handler
    lnHWND = FindWindow(0, "Calculator")
Endif 

* Instanciamos el Windows Scripting Host
loWSH = CreateObject("WScript.Shell")

* Enviamos la aplicación a primer plano
SetForegroundWindow(lnHWND)

* Por último enviamos la secuencia de teclas
loWSH.SendKeys("140{+}200") 
loWSH.SendKeys("{enter}")  


Secuencias de Escape
En la siguiente línea loWSH.SendKeys("140{+}200") vemos que el signo de suma está encerrado entre llaves. Esto se debe a que está definiendo una secuencia de escape, indicándole al WSH que debe enviar el caracter "+", y debe hacerse de esta forma ya que un signo "+" sin llaves estaría indicando que se debe enviar la pulsación de la tecla SHIFT (por ejemplo: "+casa", enviaría "Casa"). Vea Material Adicional para obtener la lista completa de secuencias de escape. 

Conclusión
Si bien el ejemplo es muy sencillo y probablemente nunca se nos va a ocurrir automatizar la calculadora para hacer una suma, vale la pena analizarlo ya que muestra claramente el uso del método SendKeys del WSH. 


Material Adicional

Refiérase a http://msdn.microsoft.com/library/default.asp?url=/library/en-us/script56/html/wsmthsendkeys.asp para consultar las secuencias de escape definidas para el método SendKeys del WSH.


************************************************************************************************
Necesitaba una rutina que me permitiera desvincular una tabla respecto de su base de datos asociada...

Lamentablemente el comando REMOVE TABLE lo que hace es desvincular la tabla desde la DBC y lo que yo precisaba era hacerlo desde la tabla, estuve investigando la estructura del HEader del las DBF y encontre que dentro del mismo existe la informacion de la DBC asociada a la tabla, entonces escribi el siguiente codigo para borrar ese nexo a la dbc., en una tabla no vinculada en las posiciones correspondientes esta el caracter (0). Al desvincular la tabla de esta forma se pueden presentar errores respecto de los nombres largos de los campos, relaciones, desencadenantes y demas caracteristicas que aporta la DBC, asi que tenemos que estar bien seguros de evitar esos errores antes de desvincular la tabla de esta forma.


LPARAMETERS tcNombreTabla
LOCAL LnManejador, lnArea,LnPrincipio,Lnpospr,lncampos,Lccadena
*!* Abro el archivo
lnManejador = FOPEN(tcNombreTabla,2)
IF lnManejador > 0
    *:* Obtengo la cadena COMPLETA con el nombre de la DBC incluido
    lcCadena = FREAD(lnManejador, 32)
    *!*  Obtengo la cantidad de campos
	Lnpospr=val(ALLTRIM ( STR (;
				 val(str ( ASC ( Substr ( lcCadena , 10 , 1 ) )*256 )) +;
				 val(str( ASC ( Substr ( lcCadena , 9 , 1 ) ) ) ) ;
				 )))
	lnCampos=((LnposPr-296)/32)
    *:* Calcuo la posicion del principio de la cadena con el nombre de la dbc
	LNPrincipio= 32 + 1 + lnCampos * 32
    FSEEK(lnManejador,LnPrincipio)
    *:* Obtengo la cadena COMPLETA con el nombre de la DBC
    lcCadena = FREAD(lnManejador, 263)
    if left(lcCadena,1) == CHR(0)
        lcCadena = ""
    ELSE
       *:* Corto la cadena hasta el primer CHR(0)
        lcCadena = LEFT(lcCadena, AT(CHR(0), lcCadena) - 1)
        *:*  Vuelvo a posicionarme en el principio de la cadena con el nombre de la dbc
        FSEEK(lnManejador,LnPrincipio)
        *:* Reemplazo el nombre de la cadena con Chr(0)
        if fwrite(lnManejador,replicate(chr(0),len(lccadena)),10) < 0
        	messagebox("No puede desVincular la tabla")
        endif	
    ENDIF
    FCLOSE(lnManejador)
ENDIF
*************************************


************************************************************************************************
 Muchas veces nos encontramos que tenemos mas de 10 tablas en nuestra base de datos y queremos Respaldarlas todas la cual tenemos que escribir un extenso codigo.


Aquí tienes un truco para Respaldar todas las tablas en unas cortas lineas:

PROCEDURE Respaldo
  LOCAL lcLugar
  *!*-------------------------------------------------------*!*
  *!* Aqui se busca el lugar en donde se hara el respaldo   *!*
  *!* y crea la carpeta en caso de no existir               *!*
  *!*-------------------------------------------------------*!*
  lcLugar = GETDIR()+ 'Respaldo\'
  IF !DIRECTORY("&lclugar")
    MD &lcLugar  && Si el directorio no existe lo crea
  ENDIF
  *!*-------------------------------------------------------*!*
  *!* De existir la carpeta elimina todas las tablas que    *!*
  *!* se encuentren dentro de esta...                       *!*
  *!*-------------------------------------------------------*!*
  DELETE FILE &lcLugar*.DBF
  SET DEFAULT TO  "C:\miprograma\Tablas"
  CLOSE DATABASE
  gndbcnumber = ADIR(gabasedatos, '*.dbf') && crea la matriz.
  FOR ncount = 1 TO gndbcnumber
    WAIT WINDOWS "Respaldando la tabla: " + ALLTRIM(gabasedatos(ncount,1)) NOWAIT
    USE ALLTRIM(gabasedatos(ncount,1)) IN 0 && EXCLUSIVE
    COPY ALL TO '&lcLugar\' + ALLTRIM(gabasedatos(ncount,1))
    USE
  ENDFOR
  SET DEFAULT TO  "C:\miprograma\"
  CLOSE DATABASE
  OPEN DATABASE  "D:\miprograma\tablas\mibd.DBC"
ENDPROC


Fijate que con este codigo si son mil tablas, las mil se respaldan. Y tu no tienes que sino solo correr el prg.

Saludos,



************************************************************************************************
 Un WAIT WINDOW centrado.


? WaitWindowCentrado("Microsoft Visual FoxPro...",0)

FUNCTION WaitWindowCentrado
  LPARAMETERS pcmensaje, pnmodo, pnsegundos, lcarea
  IF pcount()  = 0 OR TYPE("pcmensaje") # "C"
    RETURN("")
  ENDIF
  IF TYPE("pnmodo") # "N"
    pnmodo = 0
  ENDIF
  IF TYPE("pnsegundos") # "N"
    pnsegundos = 1
  ENDIF
  IF TYPE("lcarea") # "C"
    lcarea = "_SCREEN"
  ENDIF
  LOCAL lnfila AS INTEGER, lncolumna AS INTEGER
  LOCAL lnold_scale, lcmodo AS CHARACTER, lcresp AS CHARACTER

  DO CASE
    CASE pnmodo = 0
      lcmodo = ""
    CASE pnmodo = 1
      lcmodo = "NOWAIT"
    CASE pnmodo = 2
      lcmodo = "TIMEOUT pnsegundos"
    OTHERWISE
      lcmodo = ""
  ENDCASE
  lnold_scale = &lcarea..SCALEMODE
  &lcarea..SCALEMODE = 0
  lnfila = &lcarea..HEIGHT / 2
  lncolumna = ( &lcarea..WIDTH / 2 ) - LEN(pcmensaje) / 2
  WAIT WINDOW pcmensaje TO lcresp AT lnfila, lncolumna &lcmodo
  &lcarea..SCALEMODE = lnold_scale
  RETURN(lcresp)
ENDFUNC

************************************************************************************************
Rutina para obtener la configuracion regional de Windows mediante API.


DIMENSION aDatos(1)
? GetConfiRegi( @aDatos )
DISPLAY MEMORY LIKE aDatos

*-------------------------------------------------------
* Retorna en una array pasado por referencia, algunos
* valores de la configuración regional
* PARAMETROS: aDatos
* USO:  DIMENSION aDatos(1)
*       GetConfiRegi( @aDatos )
* DEVUELVE: aDatos(1) = Símbolo decimal
*    aDatos(2) = Símbolo separador de miles
*    aDatos(3) = Número de dígitos decimales
*    aDatos(4) = Símbolo de signo negativo
*    aDatos(5) = Formato de números negativos
*-------------------------------------------------------
FUNCTION GetConfiRegi(aDatos)
  #DEFINE LOCALE_USER_DEFAULT  0x400 &&1024
  #DEFINE LOCALE_SDECIMAL  0xE
  #DEFINE LOCALE_STHOUSAND  0xF
  #DEFINE LOCALE_IDIGITS 0x11
  #DEFINE LOCALE_SNEGATIVESIGN  0x51
  #DEFINE LOCALE_INEGNUMBER  0x1010
  LOCAL sRetval AS STRING, nRET AS LONG
  IF PCOUNT() < 1 THEN
    RETURN .F.
  ENDIF
  DECLARE LONG GetLocaleInfo IN WIN32API  LONG LOCALE, ;
    LONG LCTYPE, STRING LPLCDATA, LONG CCHDATA
  DIMENSION aDatos(5)
  FOR nRET = 1 TO 5
    m.aDatos(nRET) = ""
  NEXT
  m.sRetval = REPLICATE(CHR(0),256)
  * Símbolo decimal
  m.nRET = GetLocaleInfo(LOCALE_USER_DEFAULT, ;
    LOCALE_SDECIMAL, @sRetval, LEN(m.sRetval))
  IF m.nRET > 0 THEN
    m.aDatos(1) = LEFT(m.sRetval,m.nRET-1)
  ENDIF
  m.sRetval = REPLICATE(CHR(0),256)
  * Símbolo separador de miles
  m.nRET = GetLocaleInfo(LOCALE_USER_DEFAULT, ;
    LOCALE_STHOUSAND, @sRetval,LEN(m.sRetval))
  IF m.nRET > 0 THEN
    m.aDatos(2) = LEFT(m.sRetval,m.nRET-1)
  ENDIF
  m.sRetval = REPLICATE(CHR(0),256)
  * Número de dígitos decimales
  m.nRET = GetLocaleInfo(LOCALE_USER_DEFAULT, ;
    LOCALE_IDIGITS, @sRetval,LEN(m.sRetval))
  IF m.nRET > 0 THEN
    m.aDatos(3) = LEFT(m.sRetval,m.nRET-1)
  ENDIF
  m.sRetval = REPLICATE(CHR(0),256)
  * Símbolo de signo negativo
  m.nRET = GetLocaleInfo(LOCALE_USER_DEFAULT, ;
    LOCALE_SNEGATIVESIGN, @sRetval,LEN(m.sRetval))
  IF m.nRET > 0 THEN
    m.aDatos(4) = LEFT(m.sRetval,m.nRET-1)
  ENDIF
  m.sRetval = REPLICATE(CHR(0),256)
  * Formato de números negativos
  m.nRET = GetLocaleInfo(LOCALE_USER_DEFAULT, ;
    LOCALE_SNEGATIVESIGN, @sRetval,LEN(m.sRetval))
  IF m.nRET > 0 THEN
    m.aDatos(5) = LEFT(m.sRetval,m.nRET-1)
    DO CASE
      CASE m.aDatos(5) = "0"
        m.aDatos(5) = "(1.1)"
      CASE m.aDatos(5) = "1"
        m.aDatos(5)= " -1.1"
      CASE m.aDatos(5) = "2"
        m.aDatos(5) = "- 1.1"
      CASE m.aDatos(5) = "3"
        m.aDatos(5) = "1.1-"
      CASE m.aDatos(5) = "4"
        m.aDatos(5) = "1.1 -"
    ENDCASE
  ENDIF
ENDFUNC


************************************************************************************************
Esta simple rutina determina si existe el método "primero" en un formulario.


Útil por ejemplo en un tool bar que funcione con varios formularios:

IF TYPE('_SCREEN.activeform.name') = 'C' AND pemstatus(_SCREEN.ACTIVEFORM, 'primero', 5)
    _SCREEN.ACTIVEFORM.primero()
ELSE
     WAIT WINDOW "FUNCION NO IMPLEMENTADA"
ENDIF

************************************************************************************************
 Una forma facil de enviar un mensaje a usuarios de la red es por medio del servicio mensajero, aqui tienes el codigo para hacerlo...

netsend('ip_maquina_destino','Mensaje de prueba')
Function NetSend 
   Lparameters lcMaquina as String,lcMensaje as String
   Local loWshShell as Object
   loWshShell = CREATEOBJECT("WScript.shell")
   loWshShell.Run("%COMSPEC% /C %SystemRoot%\system32\net send "+lcMaquina+" "+lcMensaje, 0, .F.)
   loWshShell = Null
   Release loWshShell
EndFunc

************************************************************************************************
Función recursiva que retorna el nombre de todos los subdirectorios de un directorio pasado como parámetro.



*-----------------------------------------------------------------
* FUNCTION ASubdirectorios(taArray, tcRoot)
*-----------------------------------------------------------------
* Devuelve en un array pasado por referencia todos los nombres de
* subdirectorios del directorio "tcRoot".
* Los nombres son de la forma: [Unidad]:[\Directorio][\Subdirectorio]
* RETORNO: Cantidad de subdirectorios en el array. Si no encontró ningún
*    subdirectorio o el directorio "tcRoot" no existe, retorna 0 (cero)
* EJEMPLO DE USO:
*    DIMENSION laMiArray[1]
*    lnC = ASubdirectorios(@laMiArray, "C:\Mis Documentos\")
*    ? "Cantidad de subdirectorios:", lnC
*    FOR lnI = 1 to lnC
*       ? laMiArray[lnI]
*    ENDFOR
*-----------------------------------------------------------------
FUNCTION ASubdirectorios(taArray, tcRoot)
  IF EMPTY(tcRoot)
    tcRoot = SYS(5) + CURDIR()
  ENDIF
  DIMENSION taArray[1]
  =ARecur(@taArray, tcRoot)
  IF ALEN(taArray) > 1
    DIMENSION taArray[ALEN(taArray) - 1]
    RETURN ALEN(taArray)
  ELSE
    RETURN 0
  ENDIF
ENDFUNC
*-----------------------------------------------------------------
* FUNCTION ARecur(taArray, tcRoot)
*-----------------------------------------------------------------
* Funcion recursiva llamada por ASubdirectorios
*-----------------------------------------------------------------
FUNCTION ARecur(taArray, tcRoot)
  PRIVATE lnI, lnCant, laAux
  tcRoot = ADDBS(tcRoot)
  lnCant = ADIR(laAux, tcRoot + "*.", "D")
  FOR lnI = 1 TO lnCant
    IF "D" $ laAux[lnI, 5]
      IF laAux[lnI, 1] == "." OR laAux[lnI, 1] == ".."
        LOOP
      ELSE
        lcSubDir = tcRoot + laAux[lnI, 1]
        =ARecur(@taArray, lcSubDir)
        taArray[ALEN(taArray)] = ADDBS(tcRoot + laAux[lnI, 1])
        DIMENSION taArray[ALEN(taArray) + 1]
        LOOP
      ENDIF
    ENDIF
  ENDFOR
  RETURN
ENDFUNC
*-----------------------------------------------------------------

************************************************************************************************
 Esta clase permite reindexar las tablas contenidas en una carpeta. Para ello releva información de los índices actuales de cada tabla, los elimina y reconstruye nuevamente, y el tiempo que consume es muy poco. 


El código (en VFP8) es el siguiente:


******************************************************************
DEFINE CLASS IndexManager AS SESSION
******************************************************************
  *==============================================================
  FUNCTION Reindexa(tcTablesPath AS STRING) AS VOID
  * regenera los índices de las tablas
  *- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    LOCAL laInfo[1],;
      laTagInfo[1],;
      lnFiles,;
      lnCounter,;
      lnTagCount,;
      lnTag,;
      lcTable,;
      lcAlias,;
      lcIndexExpr,;
      lcOrden,;
      lOk
    TRY
      lOk = .T.
      *** levanta info de las tablas
      lnFiles = ADIR(laInfo,ADDBS(tcTablesPath) + '*.dbf')
      IF EMPTY(lnFiles)
        RETURN .F.
      ENDIF
      *** regenera
      FOR lnCounter = 1 TO lnFiles
        lcAlias = JUSTSTEM(laInfo[lnCounter,1])
        lcTabla = ADDBS(tcTablesPath)+ laInfo[lnCounter,1]
        lcDbf   = ADDBS(tcTablesPath) + lcAlias
        WAIT WINDOW "Procesando " + lcAlias NOWAIT
        USE (lcTabla) IN 0 ALIAS (lcAlias) EXCLUSIVE
        SELECT (lcAlias)
        *** info sobre los índices
        lnTagCount = ATAGINFO(laTagInfo)
        *!*      1 Index tag name in a .cdx file
        *!*      2 Index tag type
        *!*      3 Index key expression
        *!*      4 Filter expression
        *!*      5 Index order as created (Ascending or Descending)
        *!*      6 Collate sequence
        IF !EMPTY(lnTagCount)
          *** elimina los índices existentes
          DELETE TAG ALL
          FOR lnTag = 1 TO lnTagCount
            cNomIndice = laTagInfo(lnTag,1)
            cExpresion = laTagInfo(lnTag,3)
            lcTipo = laTagInfo(lnTag,2)
            lcOrden = laTagInfo(lnTag,5)
            lPrimario = .F.
            lCandidato = .F.
            IF VERSION(3) = "34"
              *--- Español
              DO CASE
                CASE lcTipo = "PRINCIPAL"
                  lPrimario = .T.
                CASE lcTipo = "CANDIDATO"
                  lCandidato = .T.
                OTHERWISE
                  lPrimario = .F.
                  lCandidato = .F.
              ENDCASE
              IF lcOrden = "ASCENDENTE"
                lDescending = .F.
              ELSE
                lDescending = .T.
              ENDIF
            ELSE
              *--- suponemos que es la versión en Inglés
              DO CASE
                CASE lcTipo = "PRIMARY"
                  lPrimario = .T.
                CASE lcTipo = "CANDIDATE"
                  lCandidato = .T.
                OTHERWISE
                  lPrimario = .F.
                  lCandidato = .F.
              ENDCASE
              IF lcOrden = "ASCENDING"
                lDescending = .F.
              ELSE
                lDescending = .T.
              ENDIF
            ENDIF
            cFiltro = laTagInfo(lnTag,4)
            DO CASE
              CASE lPrimario
                cIndex = "alter table " + lcDbf + " add primary key " + ALLTRIM(cExpresion) ;
                  + IIF(!EMPTY(cFiltro)," for "+ALLTRIM(cFiltro),"") + " tag " + ALLTRIM(cNomIndice)
                &cIndex
              CASE lCandidato
                cIndex = "index on " + ALLTRIM(cExpresion) + " tag " + ALLTRIM(cNomIndice) ;
                  + IIF(!EMPTY(cFiltro)," for "+ALLTRIM(cFiltro),"") + " candidate"
                &cIndex
              OTHERWISE
                cIndex = "index on " + ALLTRIM(cExpresion) + " tag " + ALLTRIM(cNomIndice) + ;
                  IIF(!EMPTY(cFiltro)," for "+ALLTRIM(cFiltro),"") + IIF(lDescending," descending","")
                &cIndex
            ENDCASE
          ENDFOR
        ENDIF
        USE IN (lcAlias)
      ENDFOR
    CATCH TO oErr
      * SUSPEND
      lOk = .F.
      cMensaje = "Error Nº : " + STR(oErr.ErrorNo) + CHR(13) +;
        "Línea : " + STR(oErr.LINENO) + CHR(13) +;
        "Mensaje : " + oErr.MESSAGE + CHR(13) +;
        "Procedimiento : " + oErr.PROCEDURE + CHR(13) +;
        "Detalles : " + oErr.Details + CHR(13) +;
        "Instrucciones : " + oErr.LineContents
      MESSAGEBOX(cMensaje, 64, "Error en Datos ")
    FINALLY
      IF lOk
        MESSAGEBOX("La reindexación de archivos ha finalizado con éxito", 64, "¡Atención!")
      ELSE
        MESSAGEBOX("Ha ocurrido algún problema en el proceso de reindexación", 64, "¡Atención")
      ENDIF
    ENDTRY
  ENDFUNC
  *==============================================================
ENDDEFINE
******************************************************************


Un ejemplo de su uso sería:


oIndex = NEWOBJECT("IndexManager","indexa.prg")
oIndex.reindexa("c:\miprograma\misbases")

************************************************************************************************
Obtener la dirección IP local de la maquina.


loSock = CREATEOBJECT('MSWinsock.Winsock.1')
? loSock.LocalIP
loSock = .NULL

************************************************************************************************
Función que trunca un número en "n" posiciones decimales.


Ejemplo:


? Truncar(123.456789,2)
-> 123.45
*-------------------------------------------
* FUNCTION Truncar(tnNro, tnDec)
*-------------------------------------------
* Trunca un número en "n" posiciones decimales
* USO: Truncar(nNumero, nDecimales)
* PARAMETROS: 
*   tnNro = Número a truncar
*   tnDec = Número de cifras decimales a truncar
* RETORNO: Numérico
*-------------------------------------------
FUNCTION Truncar(tnNro, tnDec)
  LOCAL ln
  IF EMPTY(tnDec)
    tnDec = 0
  ENDIF
  ln = 10 ^ tnDec
  RETURN ROUND(INT(tnNro * ln) / ln, tnDec)
ENDFUNC
*-------------------------------------------


************************************************************************************************
Alguna vez te ha tocado la necesidad de agregar una tabla extra a tus formularios ya creados? Puede ser algo tedioso si se tienen muchos formularios, tener que abrirlos uno por uno y agregar la tabla y despues guardar.
Çetin Basöz, nuestro compañero MVP de VFP nos muestra como podemos realizarlo programáticamente desde tu mismo IDE de VFP.


El truco consiste en obtener la referencia a tu formulario a travéz de la función ASelObj() pasando el parámetro 2. Esto puede ser muy util a la hora de querer agregar una tabla X a muchos formularios. 


Modify Form myDETest NoWait
aselobj(aObj,2)
With aObj[1]
  .AddObject('myEmployee','cursor')
  .AddObject('myOrders','cursor')
  With .myEmployee
    .Database =  HOME(2)+'data\testdata.dbc'
    .CursorSource = 'employee'
  endwith 
  With .myOrders
    .Database =  HOME(2)+'data\testdata.dbc'
    .CursorSource = 'orders'
    .Order = 'emp_id'
  EndWith
EndWith

************************************************************************************************
Deseas conocer la dirección IP con la que se está saliendo a internet, aquí te mostramos un sencillo código, cortesía de Hugo M. Ranea en los foros públicos de microsoft:




declare Sleep in win32api integer
loIE    = Createobject('InternetExplorer.Application')
loIE.Navigate2('http://whatismyip.org')
lnStart = Seconds()
do while loIE.ReadyState # 4 and ((Seconds() - lnStart < 5) or (Seconds() + 86395 - lnStart < 5))
    Sleep(100)
enddo
if loIE.Busy
    ? 'Timeout'
else
    ? loIE.Document.Body.InnerText
endif


************************************************************************************************
En alguna ocasión puede que obtengamos un nombre de archivo en formato corto, por ejemplo: 
c:\Docum~1\epalma\Misdoc~1\ 

y convertirlo a 

c:\Documents and Settings\epalma\Mis documentos

a continuación una función API para llegar a ello, contesía una vez más, del MVP Çetin Basöz.




DECLARE integer GetLongPathName IN WIN32API ;
	string @ lpszShortPath, string @ lpszLongPath, integer cchBuffer

#define MAXPATH 267
STORE SPACE(MAXPATH) TO lpszLongPath
lcPath = "C:\DOCUME~1\epalma\Misdoc~1\"
lnLen = GetLongPathName(m.lcPath,@lpszLongPath,MAXPATH)
if lnLen > 0
 ? SUBSTR(lpszLongPath,1,lnLen)
else
 ? Ruta Inválida'
endif

************************************************************************************************
Una manera más para saber si una aplicación ya está activa, esto para evitar cargar dos veces la misma. Cortesía del MVP turco: Çetin Basöz



*** En el PRG inicial de tu aplicación***
If AppAlreadyRunning()
  Messagebox('Another instance is already running.')
...

Function AppAlreadyRunning
Local hsem, lpszSemName
#Define ERROR_ALREADY_EXISTS 183
Declare Integer GetLastError In win32API
Declare Integer CreateSemaphore In WIN32API ;
	string @ lpSemaphoreAttributes, ;
	LONG lInitialCount, ;
	LONG lMaximumCount, ;
	string @ lpName
lpszSemName = "CadenaUnicadetuAplicacion"
hsem = CreateSemaphore(0,0,1,lpszSemName)
Return (hsem # 0 And GetLastError() == ERROR_ALREADY_EXISTS)


************************************************************************************************
Con esta rutina puedes simular el efecto de la función "Guardar cómo ... Archivo de Texto", de los navegadores web (IE o Netscape..). Cortesía del MVP de VFP Cetín Bazos



Local m.myHTML,m.parsed
myHTML=[This< br> is an < font color="red">< b>example< /b >< /font >< Hr>x2 < x3]
*myHTML= FileToStr(GetFile('HTM'))
parsed = ''
oParser = Createobject('myParser',m.myHTML,@m.parsed)
? m.Parsed
*StrToFile(m.Parsed,'ParseResult.txt')

Define Class myParser As Form
  Add Object oWB As OleControl With ;
    OleClass = 'Shell.Explorer'

  Procedure Init
  Lparameters tcHTML, tcParse
  lcTemp = Sys(2015)+'.htm'
  Strtofile(tcHTML,lcTemp)
  With This.oWB
    .Navigate2('file://'+Fullpath(lcTemp))
    Wait window 'Parsing...' nowait
    Do While .ReadyState # 4 && Wait for ready state
    EndDo
  Endwith
  Erase (lcTemp)
  tcParse = This.oWB.Document.body.innerText
  Wait clear
  Return .f.
Endproc
Enddefine


************************************************************************************************
Un código para llevarlo a cabo. Bastante sencillo (y gratis).

Un código cortesía de Pepe Llopis, extraido de los newsgroup de microsoft:

Necesitas un XP profesional o superior (2000, 2003, etc) y tener configurado el servicio SMTP 



    iMsg = CreateObject("CDO.Message")
    iMsg.From   = ALLTRIM(Thisform.txtEmail.Value)
    iMsg.Subject  = ALLTRIM(Thisform.txtAsunto.Value)
    iMsg.To   = ALLTRIM(lcMailAddress)
    IF !EMPTY(Thisform.txtAdjunto1.Value)
          iMsg.AddAttachment(ALLTRIM(Thisform.txtAdjunto1.Value))
    ENDIF
    WaitWCtr("Dando formato al mensaje ....",.T.)
    lcMessage = ALLTRIM(Thisform.txtPlantilla.Value)
    lcMessage = "file://"+FULLPATH(ALLTRIM(lcMessage))
    iMsg.CreateMHTMLBody( lcMessage,0)
    WaitWCtr("Enviando mensaje....",.T.)
    iMsg.Send
    RELEASE iMsg



************************************************************************************************
Función para validar un número de tarjeta de crédito.

Esta función es válida para casi todos los tipos de tarjetas de crédito. La función solo comprueba que el número sea válido, no así de que tipo de tarjeta se trata, ni la entidad que la emitió.


? Val_TC("1234 1234 1234 1238")

FUNCTION Val_TC(tcTC)
  LOCAL ln, lnSuma, lnDigito
  tcTC = ALLTRIM(CHRTRAN(tcTC,"- ",""))
  lnSuma = 0
  FOR ln = 1 TO LEN(tcTC)
    lnDigito = VAL(SUBSTR(tcTC,ln,1))
    IF MOD(ln,2)=0
      lnSuma = lnSuma + lnDigito
    ELSE
      lnDigito = lnDigito * 2
      lnSuma = lnSuma + IIF(lnDigito > 9, lnDigito - 9, lnDigito)
    ENDIF
  ENDFOR
  RETURN MOD(lnSuma,10) = 0 AND lnSuma < 150
ENDFUNC


************************************************************************************************
 Respuesta de Alex Feldstein en el Grupo de Noticias de Microsoft en Español, a la pregunta de como ejecutar Outlook Express desde Visual FoxPro.



DECLARE INTEGER ShellExecute ;
    IN SHELL32.DLL ;
    INTEGER nWinHandle,;
    STRING cOperation,;
    STRING cFileName,;
    STRING cParameters,;
    STRING cDirectory,;
    INTEGER nShowWindow

ShellExecute(0, "Open", "msimn.exe", "", "C:\Program Files\Outlook Express", 1)


************************************************************************************************
 Ejemplo de una pantalla de bienvenida (splash screen) en un formulario de nivel superior que no se muestra en la barra de tareas de Windows.


El código de este ejemplo fue ligeramente modificado del Artículo 190350 de la Base de Conocimientos de Microsoft:

-- How To Create Top-Level Splash Screen with No TaskBar Icon --
http://support.microsoft.com/?kbid=190350

El siguiente código genera automaticamente el archivo ejecutable "C:\MiApp\MiApp.exe"


LOCAL lc
SET SAFETY OFF
*-- Creo una carpeta para MiApp
IF NOT DIRECTORY("C:\MiApp")
  MD "C:\MiApp"
ENDIF
*-- Creo el archivo MiApp.PRG
TEXT TO lc NOSHOW
*-- Inicio del programa MiApp.prg
LOCAL loPresenta, loPrincipal
loPresenta = NEWOBJECT("FormPresenta")
loPresenta.SHOW()
*-- Demora para mostrar el formulario Presenta
*-- En este lugar preparo mi aplicación,
*-- configuro lo necesario, etc.
FOR ln = 1 TO 30
  INKEY(.1)
ENDFOR
loPrincipal = NEWOBJECT("FormPrincipal")
loPrincipal.SHOW()
RELEASE loPresenta
loPresenta = NULL
READ EVENTS
loPrincipal = NULL
CLOSE ALL
CLEAR ALL
QUIT
*-- Formulario Presenta
DEFINE CLASS FormPresenta AS FORM
  ALWAYSONTOP = .T.
  AUTOCENTER = .T.
  WIDTH = 468
  HEIGHT = 319
  NAME = "Presenta"
  SHOWWINDOW = 2
  DESKTOP = .T.
  TITLEBAR = 0
  BORDERSTYLE = 1
  MOUSEPOINTER = 11
  ADD OBJECT imgLogo AS IMAGE WITH ;
    PICTURE = HOME(2)+"Tastrade\Bitmaps\splash.bmp", ;
    TOP = 0, ;
    LEFT = 0
  ADD OBJECT lblEspere AS LABEL WITH ;
    TOP = 250, ;
    LEFT = 10, ;
    CAPTION = "Espere un momento...", ;
    FONTSIZE = 14, ;
    FONTBOLD = .T., ;
    FONTNAME = "Arial", ;
    AUTOSIZE = .T., ;
    BACKSTYLE = 0
  PROCEDURE INIT
    SET CURSOR OFF
    THIS.SETALL("MOUSEPOINTER", THIS.MOUSEPOINTER)
  ENDPROC
  PROCEDURE DESTROY
    SET CURSOR ON
  ENDPROC
ENDDEFINE
*-- Formulario Principal
DEFINE CLASS FormPrincipal AS FORM
  CAPTION = "Formulario Principal"
  SHOWWINDOW = 2
  AUTOCENTER = .T.
  WIDTH = 640
  HEIGHT = 480
  ADD OBJECT cmdSalir AS BotonSalir WITH ;
    TOP = 10, ;
    LEFT = 500
  PROCEDURE DESTROY
    CLEAR EVENTS
  ENDPROC
ENDDEFINE
*-- Boton Salir
DEFINE CLASS BotonSalir AS COMMANDBUTTON
  HEIGHT = 30
  WIDTH = 130
  CAPTION = "Salir"
  PROCEDURE CLICK
    THISFORM.RELEASE
  ENDPROC
ENDDEFINE
*-- Fin de MiApp.prg
ENDTEXT
STRTOFILE(lc,"C:\MiApp\MiApp.prg")
*-- Creo el archivo Config.fpw
TEXT TO lc NOSHOW
SCREEN = OFF
RESOURCE = OFF
ENDTEXT
STRTOFILE(lc,"C:\MiApp\Config.fpw")
*-- Genero el PJX y EXE
BUILD PROJECT "C:\MiApp\MiApp.pjx" FROM "C:\MiApp\MiApp.prg", "C:\MiApp\Config.fpw"
BUILD EXE "C:\MiApp\MiApp.EXE" FROM "C:\MiApp\MiApp.pjx"
MESSAGEBOX("Ahora ejecute C:\MiApp\MiApp.EXE",64,"Aviso")

************************************************************************************************
 Un codigo bastante sencillo para llevar a cabo este cálculo...

Hace algunos dias lei en una respuesta del compañero Hugo M. Ranea, la solución a este misterio "¿Cómo calcular la raiz cúbica?"...

Raiz Cúbica = N ^ (1/3)

Por lo tanto, queda igualmente traducido en código Fox:

Function RaizCubica
LParameters tnNumero
    RETURN (tnNumero ^ (1/3))
EndFunction



************************************************************************************************
 Función que transforma un número hexadecimal en binaro.



? Hex2Bin("123ABC")

FUNCTION Hex2Bin(tcHex)
  LOCAL lcRet, lnDec, lnI
  lcRet = ""
  FOR lnI = 1 TO LEN(ALLTRIM(tcHex))
    lnDec = EVALUATE("0x"+SUBSTR(tcHex,lnI,1))
    lcRet = lcRet + ;
      IIF(BITTEST(lnDec,3),"1","0") + IIF(BITTEST(lnDec,2),"1","0") + ;
      IIF(BITTEST(lnDec,1),"1","0") + IIF(BITTEST(lnDec,0),"1","0")
  ENDFOR
  RETURN lcRet
ENDFUNC

************************************************************************************************
IMAGEM VIA XML



Set Talk off
Set Safety off

* Create a temporary table in memory to hold our sample
Create cursor test (nID i, mImages m)
cImage = GetFile("JPG")
If Empty(cImage)
Return .F.
EndIf

* Add a record
Append blank
Replace nID with Recno()
Append memo mImages from (cImage)

* convert binary to Base64 to send it as text
Replace mImages with Strconv(mObs,13)

Local oXA as XMLAdapter
oXA=CREATEOBJECT("XMLAdapter")
oXA.ADDTABLESCHEMA("test")
oXA.IsDiffgram=.F.
oXA.TOXML("c:temptest.xml","",.T.)
oXA.ReleaseXML(.F.)

* close the temporary file
Use in Test

* open XML with the associated program
DECLARE INTEGER ShellExecute ;
IN SHELL32.DLL ;
INTEGER nWinHandle,;
STRING cOperation,;
STRING cFileName,;
STRING cParameters,;
STRING cDirectory,;
INTEGER nShowWindow
ShellExecute(0, "Open", "test.xml", "", "c:temp", 1)

* receive XML
oXA.LoadXML("c:temptest.xml",.T.,.T.)
oXA.Tables.Item(1).ToCursor()
oXA.ReleaseXML(.F.)

* decode image from Base64 and copy to disk
StrToFile(Strconv(mObs,14),"c:tempimage.jpg")

*show received image
ShellExecute(0, "Open", "image.jpg", "", "c:temp", 1)

* clean up
Release oXA

* EOF 

************************************************************************************************
Función que añade un caracter de Retorno de Carro [CHR(13)] en un párrafo para separarlo en líneas de "n" caracteres sin cortar ninguna palabra.


La función recursiva CortarParrafo() prepara una cadena para luego separarla con la función ALINES() en varias lineas de "n" o menos caracteres.

Ejemplo:


lcCadena = "SON PESOS: NOVECIENTOS CINCUENTA Y CUATRO MIL " + ;
  "TRESCIENTOS OCHENTA Y NUEVE CON SETENTA Y CINCO CENTAVOS."

FOR ln = 1 TO ALINES(la,CortarParrafo(lcCadena,40))
  ? la(ln)
ENDFOR

FUNCTION CortarParrafo(tc,tn)
  LOCAL lc, ln
  tc = ALLTRIM(tc) + " "
  lc = SUBSTR(tc,1,tn)
  ln = RAT(" ",lc)
  lc = SUBSTR(lc,1,ln-1)
  RETURN IIF(EMPTY(lc),lc, ;
    lc + CHR(13) + CortarParrafo(SUBSTR(tc,ln+1),tn))
ENDFUNC


************************************************************************************************
Con Visual FoxPro 8.0 se introdujeron los campos AutoIncrementales, veremos una forma de reiniciarlos.

El caso puede llegar en el momento en que se desea borrar todo el contenido de una tabla con autoincrementales, pero tambien deseas que dichos incrementos inicien como si la tabla fuera "nueva".
Está claro que lo puedes hacer mediante el diseñador de tablas, pero esta opción no estará disponible en tiempo de ejecución ("Runtime"), lo mismo pasará en el caso de que desees hacerlo con cursores creados con el comando CREATE CURSOR.
A continuación un código que mandé como respuesta a esta duda en el newsgroup de microsoft, el cual ayudará a realizar esta tarea programáticamente.



****************************************************
* Procedure: ResetTables
* Author: Esparta Palma   Date: 17/Mayo/2004
* Purpose: Reinicia los contadores de AutoIncrementales en un cursor
****************************************************
PROCEDURE ResetTables
LPARAMETERS tcCursor
LOCAL llError 
llError = .F.
IF VARTYPE(tcCursor)="C" AND NOT EMPTY(tcCursor)
    IF NOT USED(tcCursor)
        TRY
            USE (tcCursor) IN 0 EXCLUSIVE
        CATCH TO loErrorUsing
            llError = .T.
            DO CASE
                CASE loErrorUsing.ErrorNo = 1
                    lnReturnValue = -2 && The Table doesn't exists
                CASE loErrorUsing.ErrorNo = 1705
                    lnReturnValue = -3 && Acess denied, used by another user
                OTHERWISE
                    lnReturnValue = -4 &&Unknow Error
            ENDCASE
        ENDTRY
        IF llError 
          RETURN lnReturnValue
        ENDIF
    ELSE
        IF NOT ISEXCLUSIVE(tcCursor)
            RETURN -5 && Used by this user, but not Exclusive
        ENDIF
    ENDIF
    llError = .F.
    lnChangedFields = 0
    FOR lnFields=1 TO AFIELDS(laFields,tcCursor)
        IF laFields[lnFields,18] # 0 &&This Field has AutoInc
           TRY
             ALTER TABLE (tcCursor) ALTER COLUMN (laFields[lnFields,1]);
                   INT AUTOINC NEXTVALUE 1 STEP (laFields[lnFields,18])
               lnChangedFields = lnChangedFields + 1
           CATCH TO loError
              llError = .T.
               ?[  Error: ] + STR(loError.ErrorNo)
               ?[  Message: ] + loError.MESSAGE
               lnReturnValue =  -6 &&Error Altering the Table
           ENDTRY
           IF llError 
             RETURN lnReturnValue
           ENDIF
        ENDIF
    ENDFOR
ELSE
    RETURN -1 && Wrong parameters...
ENDIF
RETURN lnChangedFields

ENDPROC



************************************************************************************************
 Esta función es muy útil para establecimientos donde las monedas de centavos ya no se usan tan frecuentemente y/o por comodidad se cobra 5 centavos arriba, es decir: $145.02 se convierte en $145.05, $145.07 se convierte en $145.10.



function redondeoacincocentimos
  lparameters m.nValor
  return ceiling(m.nvalor * 20) / 20
endfunc

************************************************************************************************
 Muchas veces necesitamos cerrar las tablas temporales que creamos en algunos de nuestros formularios para que no nos provoque un error cuando intentemos crearlas con el mismo nombre en otro formulario. 


La siguiente rutina evalúa qué tablas se encuentran abiertas y las cierra automáticamente. Podríamos crear un método en nuestra clase Entorno y llamarlo cuando lo necesitemos. La rutina es la siguiente:


   DIMENSION aTablas(1)
   nTablas = AUSED(aTablas)

   IF nTablas > 0 
      FOR EACH oTabla IN aTablas
         SELECT (oTabla)
         USE 
      ENDFOR 
   ENDIF

Espero les sea de utilidad
************************************************************************************************

* COLOCAR FIGURA COMO PAPEL DE PAREDE (WALLPAPER)
Declare integer SystemParametersInfo in "user32";
  Long uAction,;
  Long uParam,; 
  string lpvParam,;
  Long fuWinIni
lfFile = getpict()
IF !empty(lfFile)
  = SystemParametersInfo(20, 0,lfFile, 1)
ENDIF

************************************************************************************************
Esta clase nos permite generar una cadena única de caracteres a partir de otra cadena. Se hizo tomando como base una rutina similar enviada por Luis María, a quien le agradezco inmensamente. Es muy util a la hora de generar claves de acceso y/o cadenas de licencias, etc.

Los cambios efectuados están básicamente en la semilla que se le pasa a la función RAND, evitando así que en cadenas similares de caracteres se generen claves similares.

En esta clase, el RAND se inicializa con el valor de la suma de chequeo (función SYS(2007)) divido por la longitud de la cadena deseada.

La clase es la siguiente.


DEFINE CLASS GenKey AS CUSTOM
  HIDDEN Caracteres
  HIDDEN LenCarac
  Caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  LenCarac = LEN( THIS.Caracteres )
  PROCEDURE GenKey( lsString AS STRING, lnLong AS INT ) AS STRING
    LOCAL lnLenString
    LOCAL lnInt
    LOCAL lsReturn
    lsReturn = ""
    IF TYPE( "lnLong" ) != "N"
      lnLong = 8
    ENDIF
    IF TYPE( "lsString" ) != "C"
      RETURN lsReturn
    ELSE
      lnLong = IIF( lnLong >= 10, 10, lnLong )
      RAND( INT( VAL( SYS( 2007, lsString ) ) / lnLong ) )
      FOR lnCont = 1 TO lnLong
        lsReturn = lsReturn + SUBSTR( THIS.Caracteres, RAND() * THIS.LenCarac + 1, 1 )
      ENDFOR
    ENDIF
    RETURN lsReturn
  ENDPROC
ENDDEFINE


Actualmente está diseñada para generar llaves de 8 caracteres por defecto, y hasta 10 máximo. Se puede extender a cualquier límite.

La forma de utilizarla es..


oKey = CREATEOBJECT("GenKey")
? oKey.GenKey("MiTexto", 8)
RELEASE oKey


************************************************************************************************
 Otra pregunta frecuente es cómo terminar los programas que están corriendo, por ejemplo Word, Excel, etc. Y aprovecho la respuesta que le pasé a William Moreno en el newsgroup para ponerla aquí, ya que tiene mayor persistencia.



KillProcessByName('wordpad.exe')
KillProcessByName('excel.exe')
KillProcessByName('winword.exe')
KillProcessByName('notepad.exe')

Procedure KillProcessByName(tcProcessID)
  If Vartype(tcProcessID) = 'C' And Not Empty(tcProcessID)
    loService = Getobject("winmgmts://./root/cimv2")
    loProcesses = loService.ExecQuery([SELECT * FROM Win32_Process WHERE Name = '] ;
      + Alltrim(tcProcessID) + ['])
    For Each loProcess In loProcesses
      loProcess.Terminate(0)
    Next
  Endif
  Return
Endproc

************************************************************************************************
 En muchas oportunidades me han preguntado que si el CursorAdapter es similar al DataAdapter de .Net se deberia poder trabajar con el de forma desconectada. Siempre he respondido que si, pero las personas quedan algo dudosas y en muchas ocaciones me dicen que no es posible que lo digo por promocionar el producto. Les envio este pequeño ejemplo de como hacerlo.



*!* Program: Desconectado.prg
*!* Author: José G. SAmper
*!* Date: 05/11/04 08:31:33 PM
*!* Copyright: NetBuzo's
*!* Description: Programa ejemplo de como usar el cursor adapter de forma desconectada
*!* Revision Information: 1.0

Local loTabla As OCursorAdapter
Try
 loTabla=Createobject('OCursorAdapter')
 If loTabla.Cargar("Customer","CUSTOMERS","CUSTOMERID","Select * From Customers where CUSTOMERID='ALFKI'")
  Select Customer
  Update Customer Set companyName=Alltrim(companyName)+' PortalFox '
  If loTabla.grabar('Customer',.F.)
   =Messagebox('Tabla Actualizada',0+64,'PortalFox')
  Else
   =Messagebox('La Tabla no pudo ser Actualizada',0+16,'PortalFox')
  Endif
 Endif
Catch  To loExc
 Local lcMessage As String
 If Vartype(loExc.UserValue)="C" And !Empty(loExc.UserValue)
  lcMessage = loExc.UserValue
 Else
  lcMessage = loExc.Message
 Endif
 =Messagebox(lcMessage,16,'PortalFox')
Finally
 Close Tables All
Endtry
loTabla=Null




******************************************************
Define Class OCursorAdapter As CursorAdapter
 *Clase que hereda de Cursor adapter para hacer el Entorno de Trabajo
 ******************************************************
 Protected DataSourceType	, ;
  Tables			, ;
  SendUpdates 	, ;
  AllowDelete		, ;
  AllowInsert		, ;
  AllowUpdate		, ;
  WhereType		, ;
  KeyFieldList	, ;
  UpdateType		, ;
  BufferModeOverride

 Alias 					= ""
 Name					= "OCursorAdapter"
 BreakOnError			= .F.
 DataSourceType			= ""
 Tables 					= ""
 SendUpdates 			= .T.
 AllowDelete				= .T.
 AllowInsert				= .T.
 AllowUpdate				= .T.
 UpdateType				= 1
 WhereType				= 1
 KeyFieldList			= ""
 BufferModeOverride		= 3
 oADOConnection 			= .Null.
 oADORecordset			= .Null.
 DataSourceType			= "ADO"
 updatetabla				= .F.

 *-------------------------------------------
 Function Destroy()
  *-------------------------------------------
  This.Desconectar()
  This.oADORecordset = Null
  This.oADOConnection = Null
 Endfunc

 Function Cargar(lalias As String,ltabla As String,lkey As String,lselect As String,noasig As Boolean)
  *************************************
  ** Metodo que se utiliza para cargar los datos, se conecta, hace el Fill y se desconecta
  *************************************
  Local lreturn As Boolean
  lreturn=.F.
  This.updatetabla=.F.
  This.Alias	= lalias
  This.Tables	= ltabla
  This.KeyFieldList= lkey
  This.SelectCmd = lselect
  If This.AsignaCursor()
   lreturn=.T.
  Endif
  Return lreturn
 Endfunc

 Function grabar(lalias As String,forzar As Boolean)
  ***************************
  ** Se conecta arma las cadenas necesarias, hace el tableupdate y cierra la conexión
  ***************************
  Local lreturn As Boolean,loExc As Exception
  lreturn=.T.
  Try
   lreturn=Tableupdate(.T.,forzar,lalias)
   Go (Recno()) &&&& coloco esto aca porque el cursor adapter siempre devuelve .T. (BUG de VFP) pero si
   ** falla la actualización dispara una excepción al moverse
  Catch To loExc
   lreturn=.F.
   Throw
  Finally
   This.Desconectar()
  Endtry
  Return lreturn
 Endfunc


 *-------------------------------------------
 Protected Function AsignaCursor()
  * Se conecta, y hace el Fill si Hay error al cargar los datos devuelve la excepción, se desconecta
  *-------------------------------------------

  Local llRetVal As Boolean
  Local loExc As Exception
  llRetVal = .F.
  Try
   Do Case
    Case This.Conectar() = .F.
    Case This.CursorFill() = .F.
     =Aerror(laerror)
     Throw laerror[1,2]
    Otherwise
     llRetVal = .T.
   Endcase

  Catch To loExc
   Throw
  Finally
   This.Desconectar()
  Endtry
  Return llRetVal
 Endfunc

 *--------------------------------------------------------------------------------------
 Protected Procedure BeforeCursorUpdate(nRows, lForce)
  *--------------------------------------------------------------------------------------
  Local llRetVal As Boolean
  Local loExc As Exception
  llRetVal = .F.
  This.updatetabla=.T.
  Try
   Do Case
    Case This.Conectar() = .F.
    Case This.CamposAct() 	= .F.
    Otherwise
     llRetVal = .T.
   Endcase
  Catch To loExc
   Throw
  Endtry
  Return llRetVal
 Endproc


 *------------------------------------
 Hidde Function Conectar()
  **Función para Abrir la conexión ADO
  *------------------------------------

  Local llRetVal As Boolean
  Local loExc As Exception
  llRetVal = .T.
  Try

   If Vartype(This.oADOConnection) <> "O"
    This.oADOConnection= Createobject("ADODB.Connection")
   Endif

   If This.oADOConnection.State = 0
    This.oADOConnection.ConnectionString = ;
       "Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=Northwind;Data Source=(local)"
    This.oADOConnection.Open()
   Endif
   If Vartype(This.oADORecordset) <> "O"
    This.oADORecordset = Createobject("ADODB.Recordset")
   Endif
   With This.oADORecordset
    .CursorLocation 	= 3
    .LockType 			= 3
    .ActiveConnection 	= This.oADOConnection
    If .State=0 And This.updatetabla
     .Open()
    Endif
   Endwith
   This.Datasource = This.oADORecordset
  Catch  To loExc
   llRetVal = .F.
   Throw
  Endtry
  Return llRetVal
 Endfunc


 *-----------------------------------------
 Hidden Function Desconectar()
  **Función para cerrar la conexión
  *-----------------------------------------
  Local llRetVal As Boolean
  Local loExc As Exception
  llRetVal = .T.
  Try
   If Vartype(This.oADOConnection) = "O" And This.oADOConnection.State = 1
    This.oADOConnection.Close()
   Endif
  Catch  To loExc
   llRetVal = .F.
   Throw
  Endtry
  This.oADOConnection=Null
  Return llRetVal
 Endfunc

 *-------------------------------------
 Protected Function CamposAct()
  *--------------------------------------------------------------------------
  *Función para crear la lista de campos actualizables
  *--------------------------------------------------------------------------
  Local llRetVal As Boolean,lnArea As Integer,lcCampos As String
  Local lcNombre As String,lnCampos As Integer,loExc As Exception
  Local Array laFields[1]
  lcNombre = ""
  lcCampos = ""
  llRetVal = .F.

  If Empty(This.UpdatableFieldList) And Empty(This.UpdateNameList)
   Try
    lnArea = Select()
    If Used(This.Alias)
     Select(This.Alias)
     lnCampos=Afields(laFields)
     For i = 1 To lnCampos
      If !Empty(lcCampos )
       lcCampos= lcCampos  + ", "
      Endif
      If !Empty(lcNombre)
       lcNombre	= lcNombre + ", "
      Endif
      lcCampos	= lcCampos + Alltrim(laFields[i,1])
      lcNombre 	= lcNombre + Alltrim(laFields[i,1]) + " " + Upper(This.Tables) + "." + Alltrim(laFields[i,1])
     Endfor
     If !Empty(lcCampos) And !Empty(lcNombre)
      This.UpdateNameList 	= lcNombre
      This.UpdatableFieldList = lcCampos
      llRetVal = .T.
     Endif
    Endif
   Catch  To loExc
    llRetVal = .F.
    Throw
   Finally
    Select(lnArea)
   Endtry
  Else
   llRetVal = .T.
  Endif
  Return llRetVal
 Endfunc
Enddefine



************************************************************************************************
Nunca les pasó de querer convertir toda una selección de texto a mayúsculas o minúsculas pulsando una tecla?

A mí ya se me dió varias veces este caso, pero nunca le pude encontrar la solución, hasta ahora. ¡Lo que hace la necesidad!


Bueno, esta sencilla rutina es útil para llamar desde una tecla rápida (HotKey) como F2, Ctrl+U o lo que quieran, y sirve tanto en modo de desarrollo como en ejecución. La única condición es que esté habilitado el menú de edición de VFP.


*-- ToUpper.PRG
*-- Convierte el texto seleccionado a mayúsculas
*-- Fernando D. Bozzo
*-- Abril 2004
KEYBOARD '{CTRL+C}' PLAIN
DO WHILE CHRSAW()
   DOEVENTS
ENDDO
_CLIPTEXT = UPPER(_CLIPTEXT)
KEYBOARD '{CTRL+V}' PLAIN


Luego de guardar el código anterior, se puede asignar a una tecla, como sigue:


ON KEY LABEL F2 DO ToUpper


Ahora sólo queda marcar un texto y pulsar F2 para que sea convertido a mayúsculas.

Espero que les sea útil como a mí!

Saludos,

************************************************************************************************
Calculo de idade


dBirth = DATE(1961,1,19)
oAge = Createobject("age")
*oAge.CalcAge(dBirth, dTarget)
oAge.CalcAge(dBirth)
? oAge.Years, oAge.Months, oAge.Days
? Gomonth(tdBirth, oAge.Years * 12 + oAge.Months) + oAge.Days

DEFINE CLASS age As Relation
  Years = 0
  Months = 0
  Days = 0
  Procedure CalcAge
  Lparameters tdBirth, tdTarget
  Local ldTemp, ldBirth, lnDrop
  tdTarget = iif(empty(tdTarget), date(), tdTarget)
  If tdBirth > tdTarget
    ldTemp = tdTarget
    tdTarget = tdBirth
    tdBirth = ldTemp
  Endif
  ldBirth = Date(Year(tdTarget), Month(tdBirth), Day(tdBirth))
  lnDrop = 0
  If Empty(ldBirth) && leap case
    ldBirth = Date(Year(tdTarget), 3, 1)
    lnDrop = Iif(Month(tdTarget) < = 2, 0, 1)
  Endif
  With This
    .Years = Year(tdTarget) - Year(tdBirth) - (Iif(ldBirth > tdTarget, 1, 0))
    .Months = (Month(tdTarget) - Month(tdBirth) + 12 -  ;
      (Iif(Day(tdBirth) > Day(tdTarget), 1, 0))) % 12
    .Days = tdTarget - Gomonth(tdBirth, .Years * 12 + .Months) - lnDrop
  Endwith
Endproc
Enddefine
************************************************************************************************
Esto pertenece al PortalSql, y me tome el atrevimiento de modificarlo para usarlo desde un cursor de VFP y unirlo a otro cursor existente:


USE IN (SELECT("crsnp"))
CREATE CURSOR crsnp ( fecha d(8), metodo c(15) ,titulo c(100), cantidad N(10) NULL,lugarentrega c(30),;
  distribuidor c(50),moneda c(10),dto N(6,2)NULL,precio N(12,2)NULL,;
  cotizacion N(10,2) NULL,;
  origen N(10), codigotipostock c(10), iddistrib N(10),;
  codigolibro N(10),codigo c(20), nropedido N(10) NULL,;
  nrorenglon N(10) NULL, otros N(1),;
  seleccion L,Marca L)
SELECT * FROM  crsnp ORDER BY LugarEntrega, Metodo, DISTRIBUIDOR,titulo INTO CURSOR crsnp READWRITE
TEXT TO lcSQL NOSHOW
SELECT codigolibro as coda,
   SUM(CASE codigotipostock WHEN 'FI' THEN cantidad ELSE 0 END) AS Firme,
   SUM(CASE codigotipostock WHEN 'CO' THEN cantidad ELSE 0 END) AS Consig,
   SUM(CASE codigotipostock WHEN 'SV' THEN cantidad ELSE 0 END) AS Vendido,
   SUM(CASE codigotipostock WHEN 'RF' THEN cantidad ELSE 0 END) AS RepFirme,
   SUM(CASE codigotipostock WHEN 'RC' THEN cantidad ELSE 0 END) AS RepConsig
FROM cantidadportipodestock
     WHERE codigolibro in (SELECT librosporpedido.codigolibro FROM librosporpedido WHERE  dbo.LibrosPorPedido.remanente = 1 AND
 dbo.LibrosPorPedido.cantidad > 0)
     GROUP BY codigolibro   
ENDTEXT
qhandle = SQLCONNECT( .aconsultor(2,22))
SQLEXEC(qhandle, lcsql, "csql")
SELECT * FROM crsnp  INNER JOIN csql ON crsnp.codigolibro = csql.coda ;
  INTO CURSOR crsnp READWRITE
RELEASE qhandle

************************************************************************************************
 Este es un requisito común y muchas veces muy útil....



#DEFINE CRLF CHR(13)+CHR(10)
lcArchivo = "C:Mis DocumentosBalance.xls"
lcMacro = "CuadrarBalance"
TRY 

    LOCAL loExcel
    loExcel = CREATEOBJECT("Excel.Application")
    loExcel.Open(lcArchivo)
    loExcel.Visible = .T.
    loExcel.Run(lcMacro)
CATCH To loError
    MESSAGEBOX("No es posible terminar la Automatización"+;
               "Error Extendido:"+loError.Message +CRLF +;
               "Número de Error:" +TRANSFORM(loError.ErrorNo) ,16,"Error en la Automatización")
FINALLY
    loExcel = .NULL.
    RELEASE loExcel
ENDTRY



Espero les sea de utilidad.

Nota: El ejemplo utiliza los bloques TRY.. ENDTRY de Visual FoxPro 8, si tiene una versión previa, quite esas instrucciones y utilice los métodos ya conocidos: ON ERROR lError=.T. , etc etc


************************************************************************************************

Trabajar con Información Importada desde MS-Excel, conteniendo datos tipo Fecha
Enviado por: Esparta Palma 
 
 
 Realmente desconozco el por qué sucede, pero cuando he importado archivos desde Excel que contienen tipos de datos Fecha, estos se presentan de la siguiente manera: 38007!!, cuando en realidad debería poner 24/01/2004. Veamos cómo darle la vuelta al asunto.


A mi gusto, al poner en Excel un formato de tipo fecha, al ejecutar la función IMPORT FROM ... TYPE XL5, VFP debería poder importarlos como eso, como un dato de tipo fecha, no?.

Resulta que esos datos que se importan es la forma en realmente se guarda el dato de tipo fecha, que significan esos números?, se refieren a los días transcurridos desde el primer segundo del día primero de enero de 1900.

Por lo tanto, la solución sencilla resulta en sumarle a dicho número (resultante de la importación de Excel), un tipo de datos fecha con los datos requeridos:



lcFile = GETFILE("XLS")
IF NOT EMPTY(lcFile)
   IMPORT FROM (lcFile)  TYPE XL5
   Select *,DATETIME(1900,01,01)+TuCampodeTipoFecha-2 as NuevaFecha  FROM (lcFile)
ENDIF



En el código anterior lo que realizo es una importación de un archivo de Excel, y para demostrar la teoría antes mencionada, hago un query con el cálculo requerido.

Notará que en la formula hay un -2, el "por qué" es sencillo o complicado según se vea, en realidad debería ser -1, esto debido a los factores suizos de compensaciones de formulas, pero por el hecho de que no se debe tomar en cuenta el primer día de 1900 como ya transcurrido, pues se le restan 2, haga sus propias pruebas, si me equivoco, podemos comentarlo.
 


************************************************************************************************

 Hace unas semanas tuve la necesidad de imprimir texto justificado en un informe de VFP, el cual venia desde un campo memo, al no recibir una solución, decidi hacerlo yo mismo y ya he terminado. Coloco aqui la clase que realice y como la utilizo en mi aplicación.

Espero que le puedan dar uso y si es posible que la mejoraran.

Saludos...

Oscar Gonzalez Hernandez
Mexico D.F


Uso de la Clase:


LOCAL loJustify
loJustify = CREATEOBJECT("justify")
loJustify.cSalidaTexto = "salida.txt"
loJustify.set_textmerge_on
loJustify.dojustify(cTexto,nLong)
loJustify.set_textmerge_off


Donde:
cTexto = Texto que se quiere justificar
nLong = Longitud en caracteres a justificar
Despues Revisar el archivo salida.txt


**************************************************
*-- Class:        justify
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Author: Oscar Gonzalez Hernandez
*
DEFINE CLASS justify AS CUSTOM
  HEIGHT = 15
  WIDTH = 16
  *-- Contiene el texto ya justificado y se va acumulando
  *-- hasta contener todo el texto justificado.
  ctextoacumulado = ""
  NAME = "justify"
  *-- Contiene el nombre del archivo que se
  *-- creará con el texto justificado.
  csalidatexto = .F.
  *-- Separa el texto pasado como parámetro en diferentes
  *-- bloques si ses que se encuentran retornos de carro,
  *-- sino regresa el texto completo.
  PROCEDURE SEPARA
    LPARAMETERS tcParrafo,taBloques,tbBloques
    lnDimension = 0
    FOR i = 1 TO LEN(tcParrafo)
      IF ASC(SUBSTR(tcParrafo,i,1)) = 13
        lnDimension = lnDimension + 1
        DIMENSION laRetornos(lnDimension)
        laRetornos(lnDimension) = i
      ENDIF
    ENDFOR
    IF VARTYPE(laRetornos) = "U"
      tbBloques = .F.
      taBloques = tcParrafo
      RETURN @taBloques
    ENDIF
    lnInicio = 1
    FOR k = 1 TO ALEN(laRetornos)
      DIMENSION taBloques(k)
      taBloques(k) = SUBSTR(tcParrafo,lnInicio,laRetornos(k)-lnInicio)
      lnInicio = laRetornos(k)+1
    ENDFOR
    DIMENSION taBloques(k)
    taBloques(k) = SUBSTR(tcParrafo,lnInicio,LEN(tcParrafo)+1-lnInicio)
    tbBloques = .T.
    RETURN @taBloques
  ENDPROC
  *-- Ejecuta el proceso de justificado del texto separado
  *-- en bloques o texto único regresado por el método separa().
  PROCEDURE dojustify
    LPARAMETERS tcTextoJustificar,tnLongJustificado
    LOCAL lgBloques,lbBloques
    THIS.SEPARA(tcTextoJustificar,@lgBloques,@lbBloques)
    IF lbBloques && Se ha partido el exto en bloques
      FOR lnCont = 1 TO ALEN(lgBloques)
        THIS.ctextoacumulado = ""
        THIS.Justificar(lgBloques(lnCont),tnLongJustificado)
         TEXT
           <<This.ctextoacumulado>>
         ENDTEXT
      ENDFOR
    ELSE
      THIS.ctextoacumulado = ""
      THIS.Justificar(lgBloques,tnLongJustificado)
      TEXT
        <<This.ctextoacumulado>>
      ENDTEXT
    ENDIF
    RETURN
  ENDPROC
  *-- Método recursivo que justifica párrafo por párrafo
  *-- según la longitud de caracteres que se le indique.
  PROCEDURE justificar
    LPARAMETERS tcTexto,tnTamaño
    IF EMPTY(SUBSTR(tcTexto,tnTamaño,1))
      lcTextoJ = ALLTRIM(SUBSTR(tcTexto,1,tnTamaño-1))
      IF EMPTY(lcTextoJ)
        RETURN
      ENDIF
      tcTextoAlterno = SUBSTR(tcTexto,tnTamaño+1,LEN(tcTexto))
      IF !EMPTY(tcTextoAlterno)
        lcTextoAcumular = THIS.rellena(lcTextoJ,tnTamaño)
        THIS.ctextoacumulado = THIS.ctextoacumulado + lcTextoAcumular + CHR(13)
        tcTexto = SUBSTR(tcTexto,tnTamaño+1,LEN(tcTexto))
        THIS.justificar(tcTexto,tnTamaño)
      ELSE
        lcTextoAcumular = lcTextoJ
        THIS.ctextoacumulado = THIS.ctextoacumulado + lcTextoAcumular + CHR(13)
        tcTexto = SUBSTR(tcTexto,tnTamaño+1,LEN(tcTexto))
        THIS.justificar(tcTexto,tnTamaño)
      ENDIF
    ELSE
      lcChar = SUBSTR(tcTexto,tnTamaño,1)
      lnContador = tnTamaño
      DO WHILE !EMPTY(lcChar)
        lnContador = lnContador - 1
        lcChar = SUBSTR(tcTexto,lnContador,1)
      ENDDO
      lcTextoJ = ALLTRIM(SUBSTR(tcTexto,1,lnContador))
      tcTextoAlterno = SUBSTR(tcTexto,tnTamaño+1,LEN(tcTexto))
      IF !EMPTY(tcTextoAlterno)
        lcTextoAcumular = THIS.rellena(lcTextoJ,tnTamaño)
        THIS.ctextoacumulado = THIS.ctextoacumulado  + lcTextoAcumular + CHR(13)
        tcTexto = SUBSTR(tcTexto,lnContador+1,LEN(tcTexto))
        THIS.justificar(tcTexto,tnTamaño)
      ELSE
        lcTextoAcumular = lcTextoJ
        THIS.ctextoacumulado = THIS.ctextoacumulado + lcTextoAcumular + CHR(13)
        tcTexto = SUBSTR(tcTexto,lnContador+1,LEN(tcTexto))
        THIS.justificar(tcTexto,tnTamaño)
      ENDIF
    ENDIF
  ENDPROC
  *-- Rellena el párrafo cortado por el método justificar()
  *-- con el número de espacios correspondientes para crear
  *-- un parrafo de la longitud deseada.
  PROCEDURE rellena
    LPARAMETERS tcParrafo,tnLong
    IF LEN(tcParrafo) = tnLong
      RETURN tcParrafo
    ENDIF
    lnDimension = 0
    lcPalabra = ""
    FOR i = 1 TO LEN(tcParrafo)
      IF ASC(SUBSTR(tcParrafo,i,1)) = 32
        lnDimension = lnDimension + 1
        DIMENSION laEspacios(lnDimension)
        laEspacios(lnDimension) = i
      ENDIF
    ENDFOR
    IF VARTYPE(laEspacios) = "U"
      RETURN tcParrafo
    ENDIF
    lnInicio = 1
    FOR k = 1 TO ALEN(laEspacios)
      DIMENSION laPalabras(k)
      laPalabras(k) = SUBSTR(tcParrafo,lnInicio,laEspacios(k)-lnInicio)
      lnInicio = laEspacios(k)+1
    ENDFOR
    DIMENSION laPalabras(k)
    laPalabras(k) = SUBSTR(tcParrafo,lnInicio,LEN(tcParrafo)+1-lnInicio)
    lnTotalEspacios = tnLong - LEN(tcParrafo)
    lnEspaciosContados = 0
    DO WHILE !EMPTY(lnTotalEspacios)
      FOR l = 1 TO ALEN(laPalabras)-1
        laPalabras(l) = laPalabras(l) + " "
        lnTotalEspacios = lnTotalEspacios - 1
        IF EMPTY(lnTotalEspacios)
          EXIT
        ENDIF
      ENDFOR
    ENDDO
    lcParrafoFormateado = ""
    lcParrafoFormateado = laPalabras(1)
    FOR j = 2 TO ALEN(laPalabras)
      lcParrafoFormateado = lcParrafoFormateado + " " + laPalabras(j)
    ENDFOR
    RETURN lcParrafoFormateado
  ENDPROC
  *-- Activa la configuración de salida del texto justificado.
  PROCEDURE set_textmerge_on
    SET TEXTMERGE TO (THIS.csalidatexto) NOSHOW
    SET TEXTMERGE ON
  ENDPROC
  *-- Desactiva la configuración de salida del texto justificado.
  PROCEDURE set_textmerge_off
    SET TEXTMERGE TO
    SET TEXTMERGE OFF
  ENDPROC
ENDDEFINE



************************************************************************************************

Enviar datos en formato de tabla dinámica desde cualquier formulario VFP   
 Discussão anterior  Próxima discussão  Enviar Respostas para a minha Caixa de Entrada   
 
Responder
 Recomendar   Mensagem 1 de 2 em Discussão   
 
De: CarlosAMiranda  (Mensagem original) Enviado: 3/2/2004 00:11 
Hola a Todos
 
Muchas veces ustedes habran querido enviar datos de su aplicación a excel, pero muchas veces a un cliente final no le interesa mucho una tabla estática de excel, pero cuando tiene una tabla dinámica, el puede agrupar los datos a su gusto, poner o quitar columnas con solo arrastrar y general consultas dinámicas, con el siguiente código que es parte de una clase que adjunto en este artículo, ustedes podran pegarla en cualquier formulario y con solo ajustar tres propiedades podran enviar a excel en forma de tabla dinamica cualquier tabla o consulta ya sea de tablas nativas o de cliente servidor, y además si quieen se puede generar la gráfica inmediatamente. La ventaja de todo esto es que esta diseñado con office automation, por lo que les será muy fácil agregarle más funcionalidad de excel si así lo requieren.Para que  lo entiendan mejor voy a explicar algunas partes del código. 
 
*******/ Nombre del Cursor que quieren graficar /********** 
m.lcCursorName= ALLTRIM(THIS.PARENT.cursor_name)
******/ Título que quieren que tenga el gráfico si es que quieren gráfico /*******
m.lcTituloChart=ALLTRIM(THIS.PARENT.chart_tittle)
*****/ Dirección para guardar los archivos temporales /*************
m.lcTemporal=ALLTRIM(THIS.PARENT.temporal)
SELECT &lcCursorName
SELECT * FROM  &lcCursorName;
 INTO TABLE &direccion_temporal\pt_consulta.DBF
***************/ Nombre del archivo dbf final en formato fox2x /*********
COPY TO &lcTemporal\consulta.DBF TYPE FOX2X
***********/ Crear el objeto Excel /********************
oExcel = CREATEOBJECT("excel.application")
**********/ Crear un nuevo libro en excel. /***********************
oWorkbook = oExcel.Workbooks.ADD()
***********/Rango inicial para enviar los resultados. /***************
oTargetSheet = oWorkbook.Sheets.ADD()
oTargetRange = oTargetSheet.RANGE("A2")
**********/ Crear un objeto pivot cache para recibir datos externos /********
oPivotCache = oWorkbook.PivotCaches.ADD( 2 ) && external data
***********/conectar el objeto pivot cache al OLE-DB provider /*************
**********/ y la sentencia SQL que Excel usará para leer los datos/*********
oPivotCache.CONNECTION = "OLEDB;Provider=vfpoledb.1;data source=" + ALLTRIM(m.lcTemporal)
oPivotCache.Commandtext = "select * from consulta"
*********/Crear el objeto pivottable para crear la tabla dinámica con los datos./********
oPivotTable = oPivotCache.CreatePivotTable( oTargetRange, "PivotTable" )
*********/Organizar la presentacion de datos de la tabla dinámica. /************
*********/ Esto lo pueden organizar a su gusto, yo he decido hacerlo de forma automática /******
*******/Para esto averiguo el número de columnas del cursor con la función afields() /********
m.lnTotal_columns= AFIELDS(A_CAMPOS,m.lcCursorName)
FOR i=1 TO m.lnTotal_columns
*********/Los nombres de los campos solo aceptan 10 caracteres en formato de tabla libre /********
 m.lcCampo=LEFT(ALLTRIM(A_CAMPOS(i,1)),10)
*********/ Determinar el tipo de dato de cada columna /*****************
 m.lcTipo=ALLTRIM(A_CAMPOS(i,2))
********/ Todo campo que se llame YEAR o QUARTER o MONTH se convertira en campo de pagina /************
********/ Esto también es a mi gusto he decidido que la columnas  que se llamen YEAR, QUARTER o MONTH /********
*******/Vayan a la sección de datos de página, ustedes podrían poner AÑO, MES o no poner nada  /****************
 IF ALLTRIM(A_CAMPOS(i,1))='YEAR' OR ALLTRIM(A_CAMPOS(i,1))='QUARTER' OR ALLTRIM(A_CAMPOS(i,1))='MONTH'
  oPivotTable.PivotFields(m.lcCampo).ORIENTATION = 3 && dato de pagina
 ENDIF
********/ Todo campo tipo 'C' o 'T' se convertira en campo de fila /************
 IF m.lcTipo='C' OR m.lcTipo='T'
  oPivotTable.PivotFields(m.lcCampo).ORIENTATION = 1 && fila
 ENDIF
ENDFOR
FOR i=1 TO m.lnTotal_columns
 m.lcCampo=LEFT(ALLTRIM(A_CAMPOS(i,1)),10)
 m.lcTipo=ALLTRIM(A_CAMPOS(i,2))
********/ Todo campo tipo 'N' o 'I' excepto 'YEAR' o QUARTER o MONTH se convertira en campo de datos /************
 IF m.lcTipo='N' OR m.lcTipo='I'
  IF m.lcCampo='YEAR' OR m.lcCampo='QUARTER' OR m.lcCampo='MONTH'
 
  ELSE
   oPivotTable.PivotFields(m.lcCampo).ORIENTATION = 4 && datos
  ENDIF
 ENDIF
ENDFOR
***********/ Activar el rango seleccionado importante /****************
oTargetRange.ACTIVATE
IF THIS.PARENT.chart.VALUE=.T.
***********/ Crear el objeto gráfico /****************
 ochart=oWorkbook.Charts.ADD()
***********/ Título del gráfico /****************
 ochart.ChartTitle.CAPTION=ALLTRIM(vr_sp_procedures.sp_tittle)
ENDIF
**********/ Hacer visible la aplicación excel /*************
oExcel.APPLICATION.VISIBLE = .T.
**********/ Poner la ocpión de generar gráficos en falso /*************
THIS.PARENT.chart.VALUE=.F.
 
Les adjunto el archivo con la clase, lo único que tienen que hacer es pegarlo en cualquier formulario y ajustar las tres propiedades y estan listos para enviar tablas dinámicas a excel, una vez en excel solo tienen que ocultar las columnas que no deseen en la tabla dinámica o cambiar la disposición de columnas a filas o lo que ustedes quieran.  
 
Ejemplo de como ajustar las propiedades desde un formulario en el que este pegada esta clase:  
THISFORM.Excel_dinamic_tables1.temporal=m.direccion_temporal
THISFORM.Excel_dinamic_tables1.chart_tittle="Cuentas por pagar Proveedores"
THISFORM.Excel_dinamic_tables1.cursor_name="Proveedores"
 
 
 

************************************************************************************************
 Esta rutina la utlizo para crear un código o identificador único de cualquier longitud.



*** Codigos.prg ***
CLOSE ALL
CREATE CURSOR Temporal ( codigo c(15) )
INDEX ON codigo TAG codigo UNIQUE
FOR I = 1 TO 5000
    INSERT INTO Temporal ( codigo ) VALUES (GEN_ID(15) )
ENDFOR
BROWSE
CLOSE ALL
RETURN

*** Generar Identificador Unico ***
PROCEDURE Gen_id
LPARAMETERS lnLargo
LOCAL lcCodigo, lnNumero
lcCodigo = ""
DO WHILE LEN(lcCodigo) < lnLargo
   lnNumero = INT(RAND()*255)
   IF BETWEEN(lnNumero,48,57) OR BETWEEN(lnNumero,65,90)
       lcCodigo = lcCodigo + CHR(lnNumero)
   ENDIF
ENDDO
RETURN lcCodigo


************************************************************************************************
Como crear una vista parametrizada con condicion variable (E) 


¿Estas harto de crearte un monton de vistas innecesarias para todas las consultas que quieren hacer tus clientes? 

¿Quieres abandonar el SET FILTER en vistas? 

El problema viene dado de que se tenga la necesidad de permitir a los usuarios el realizar consultas variables (clientes de una provincia, o con un importe vendido mayor de una cantidad). Estas necesidades pueden variar de momento a momento, y hacerlo con cursores tiene el problema de que habria que hacer la actualización a la tabla a mano. 

El truco está en crear en la condicion del where algo al estilo de &?cWhere, me explico: 


CREATE SQL VIEW "LV_CLIENTES" ; 
AS SELECT * FROM empresa!clientes ;
WHERE &?cWhere ORDER BY Clientes.clicod

en cWhere se pone la condicion deseada, 

se abre la vista con NODATA 
y despues se cambias cWhere por lo que se quiera: 


cWhere = "VAL(clicod)<25 AND clixusu='EVA'" 
REQUERY()

otro usuario le puede interesar: 


cWhere = "cliventas>500000" 
REQUERY()

¡Y ambos estan trabajando con la misma vista! 

Es importante decir que esta vista no se puede modificar con el generador de vistas, aunque a mi no me preocupa eso, el uso del GENDBC es muy util, sino imprescindible para esto. Por otra parte la mala noticia es que no funciona para vistas remotas. 

Espero le sirva de algo 

Saludos !!!

************************************************************************************************
Si utilizas Grids para captura en linea, quizás quieras limitar que ciertas filas no puedan ser modificadas, es decir, dejarlas como de sólo lectura....

Quizas te resulte algo truculento, pero en realidad sirve... Puedes hacer a TODO el grid de sólo lectura, y cuando se cambie de registro, poner en .T. o .F. el valor de la propiedad ReadOnly (del Grid) según sea tu condición...
Veamos un ejemplo:


public oForm
oForm = CREATEOBJECT("MyForm")
oForm.Show()
DEFINE CLASS MyForm AS Form
   ADD OBJECT MyGrid AS Grid
   PROCEDURE LOAD
       CREATE CURSOR Temp (nMes int,cMes c(15))
       RAND(-1)
       FOR lnCounter=1 TO 20
         lnMes = RAND()*11+1
        INSERT INTO temp VALUES(lnMes,cMONTH(DATE(2003,lnMes,01)))
       ENDFOR
   ENDPROC
   PROCEDURE INIT
      WITH This.MyGrid 
         .SetAll("DynamicBackColor", ;
                 "IIF(RECNO()%2 =0,RGB(255,255,255), ;
                                   RGB(0,255,0))",;
                 "Column")
      EndWith
   ENDPROC
   PROCEDURE UNLOAD
      USE IN SELECT("Temp")
   ENDPROC
   PROCEDURE MyGrid.AfterRowColChange
   LPARAMETERS nColIndex
      This.ReadOnly=(RECNO()%2 # 0)
   ENDPROC   
ENDDEFINE   


Copia y Pega el codigo anterior en tu Command Window, seleccionalo y presiona ENTER, se ejecutará un formulario con un grid conteniendo valores obtenidos de una tabla llenada aleatoriamente, dicho grid le he pintado las filas impares (según el RECNO()), estas mismas líneas serán las que permanezcan de modo solo lectura, ¿Cómo realizaremos esto?, sencillo, en el método AfterRowColChange, si la fila actual es impar o no, pongo el valor de la propiedad ReadOnly a verdadero (.T.) o falso (.F.) según sea el caso.
Si, puede que sea muy "chapucero", pero funciona ;-), el chiste está en que debes establecer correctamente tu condicion de "Solo lectura" y hacerlo por medio del evento AfterRowColChange.

Espero les sea de utilidad.


************************************************************************************************
Aqui te proporcionamos una rutina de encriptado simple:

Te servira para encriptar un campo caracter, podras usar una llave de encriptación que es un número entre el rango de 128 y 255 inclusive, esta misma sirve descriptar lo que encriptaste, deberas usar la misma llave de encriptado con que encriptaste para desencriptar.



FUNCTION encrip
LPARAMETERS tccodigo, tnclave
PRIVATE lnlong AS INTEGER, ;
    lnii AS INTEGER, ;
    lcvalor AS STRING, ;
    lcletra AS CHARACTER, ;
    lnnumero AS INTEGER


tnclave = IIF(TYPE("tnclave")="N",IIF(tnclave>=128 AND tnclave <=255,tnclave,255),255)
lnlong  = LEN(tccodigo)
lcvalor = ""

FOR lnii=1 TO lnlong
    lnnumero = ASC(SUBS(tccodigo,lnii,1))
    lnnumero = tnclave - lnnumero + 1
    lnnumero = IIF(lnnumero<0,lnnumero*-1,lnnumero)
    lcletra  = CHR(lnnumero)
    lcvalor  = lcvalor + lcletra
NEXT lnii

RETURN lcvalor
ENDFUNC

Prueba este ejemplo:

FOR i=128 TO 255
    y="MICROSOFT VISUAL FOXPRO"
    x=encrip(y,i)
    ? x
    x=encrip(x,i)
    ? x
    IF x<>y
        WAIT WINDOW STR(i)
    ENDIF

ENDFOR

FOR i=128 TO 255
    y=SYS(2015) && GENERA UN NOMBRE ALEATORIO
    x=encrip(y,i)
    ? x
    x=encrip(x,i)
    ? x
    IF x<>y
        WAIT WINDOW STR(i)
    ENDIF

ENDFOR


************************************************************************************************
Esto nos ayudara a no tener mas de 2 veces nuestra aplicación activa en el mismo computador.



LOCAL lcold_caption
lcold_caption=_screen.Caption
IF VALIDAR_PANTALLA("MI APLICACION", .T.)=.T.
   _SCREEN.Caption="MI APLICACION"
   =MESSAGEBOX("OK")
ENDIF
_screen.Caption=lcold_caption

FUNCTION validar_pantalla
    LPARAMETERS pccaption, plmax
    LOCAL lnhwnd
    DECLARE INTEGER FindWindow IN Win32API STRING lpClassName, STRING lpWindowName
    DECLARE INTEGER BringWindowToTop IN Win32API INTEGER HWND
    DECLARE INTEGER SendMessage IN Win32API INTEGER HWND, INTEGER Msg, INTEGER WParam, INTEGER LPARAM
    lnhwnd = findwindow( 0, pccaption )
    IF lnhwnd > 0
        bringwindowtotop(lnhwnd)           && Mandar la ventana de la aplicación al frente
        IF plmax = .T.
            sendmessage(lnhwnd, 274, 61488, 0) && Maximizar la ventana de la aplicación
        ENDIF
        RETURN .F.
    ENDIF
    RETURN .T.
ENDFUNC


Para probar generen un exe con esta rutina, coloquen un acceso directo en el escritorio, y estando la pantalla activa vuelvan a ejecutar el programa. Veran que no se carga nuevamente la aplicación, sino que se activa.

Nota: Pueden hacer esta secuencia de comandos en una aplicación:


LOCAL lcold_caption
lcold_caption=_screen.Caption
IF VALIDAR_PANTALLA("MI APLICACION", .T.)=.T.
   _SCREEN.Caption="MI APLICACION"  && OJO AQUI VA EL CAPTION DE SU APLICACION.
   *AQUI VA COMANDOS DE SU SISTEMA.
   *ETC
   *READ EVENTS
ENDIF
_screen.Caption=lcold_caption
*OTROS COMANDOS
*ETC.

************************************************************************************************
Cuando diseñamos nuestra aplicacion tenemos como base una resolucion para nuestra aplicacion, normalmente yo la diseño en 800 x 600, para garantizar el buen funcionamiento yo le indico a los usuarios si estan usando la configuración básica aceptable.



Espero les pueda ayudar:


IF dimensiones()=.T.
    =cambiar_resolucion(800,600)
ENDIF
FUNCTION dimensiones
    #DEFINE h_screenwidth         0 && Screen width
    #DEFINE h_screenheight        1 && Screen HEIGHT
    LOCAL lnalto_screen, lnancho_screen
    DECLARE INTEGER GetSystemMetrics IN Win32API;
        INTEGER nIndex
    lnalto_screen        = getsystemmetrics(h_screenheight)
    lnancho_screen       = getsystemmetrics(h_screenwidth)
    IF ( lnalto_screen < 600 OR lnancho_screen < 800 )
        IF MESSAGEBOX("Es recomendable que la resolución "+CHR(13)+;
          "de su monitor sea de 800 x 600"+CHR(13)+"Para que el sistema se ejecute adecuadamente"+CHR(13)+CHR(13)+;
          "¿ Desea cambiarla ?",4+32+0,"Verifique pregunta" ) = 6
            RETURN .T.
        ELSE
            RETURN .F.
        ENDIF
    ELSE
        RETURN .F.
    ENDIF
    #undefine h_screenwidth
    #undefine h_screenheight
ENDFUNC
FUNCTION cambiar_resolucion
    LPARAMETERS tnwidth, tnheight
    LOCAL lnwidth, lnheight, lnmodenum, lcdevmode, lnresp
    lnmodenum  = 0
    lcdevmode  = REPLICATE(CHR(0), 156)
    lnwidth    = IIF(EMPTY(tnwidth), 800, tnwidth)
    lnheight   = IIF(EMPTY(tnheight), 600, tnheight)
    DECLARE INTEGER EnumDisplaySettings   IN Win32API STRING lpszDeviceName, INTEGER iModeNum, STRING @lpDevMode
    DECLARE INTEGER ChangeDisplaySettings IN Win32API STRING @lpDevMode , INTEGER dwFlags
    *!* Se usa obtener todos los modos disponibles
    DO WHILE enumdisplaysettings(NULL, lnmodenum, @lcdevmode) <> 0
        lnmodenum = lnmodenum + 1
    ENDDO
    lcdevmode = STUFF(lcdevmode,  41, 4, long2str(1572864))
    lcdevmode = STUFF(lcdevmode, 109, 4, long2str(tnwidth))  && Ancho
    lcdevmode = STUFF(lcdevmode, 113, 4, long2str(tnheight))  && Alto
    lnresp = changedisplaysettings(@lcdevmode, 1)
    IF lnresp = 0
        MESSAGEBOX("La resolución de su monitor ha sido cambiada"+CHR(13)+;
         "Ahora podra trabajar adecuamente",0+48+0,"atención" )
    ELSE
        MESSAGEBOX("No se pudo cambiar la resolución de su monitor",0+48+0,"atención" )
    ENDIF
ENDFUNC

FUNCTION long2str
    LPARAMETERS lnlongval
    *!* Convierte un long integer a un 4-byte character string
    *!* Sintaxis: LongToStr(lnLongVal)
    *!* Valor devuelto: lcRetStr
    *!* Argumentos: lnLongVal
    *!* lnLongVal especifica el long integer a convertir
    LOCAL lncnt, lcretstr
    lcretstr = ''
    FOR lncnt = 24 TO 0 STEP -8
        lcretstr = CHR(INT(lnlongval/(2^lncnt))) + lcretstr
        lnlongval = MOD(lnlongval, (2^lncnt))
    NEXT
    RETURN lcretstr
ENDFUNC
*****

************************************************************************************************
No me culpen a mí, pero a veces los requerimentos así lo exigen... Veamos una manera sencilla...

Supongamos el escenario, los requerimentos de sistemas auxiliares (o por ordenes de tus superiores) exigen exportar la información del sistema a una base de datos de Access, todo bien, pero imaginemos que dicha información debe guardarse en una base de datos distinta cada mes. Es entonces cuando debemos de crear una Base de Datos en tiempo de ejecución.
Para poder solventarlo haremos uso de los ADO Extensions, a travez de la clase Catalog. De esta manera, no será necesario crear manualmente las bases de datos, por lo mismo, tampoco necesitamos instalar el paquete Microsoft Access.




lcAccessDB =LEFT( DTOS(DATE()),6)
lcFolder = GETDIR()
IF !EMPTY(lcFolder)
   TRY
     loCatalog = CreateObject("ADOX.Catalog")
     loCatalog.Create("Provider=Microsoft.Jet.OLEDB.4.0;"+;
                      "Data Source="+lcFolder+lcAccessDB+".mdb;" +;
                      "Jet OLEDB:Engine Type=5")
     Messagebox("Base de Datos creada con Exito",64,"Información")
    CATCH TO loError
        DO CASE
            CASE loError.ErrorNo=1733
                lcMensaje = "Error al Crear Objeto Catalogo"+CHR(13)
            CASE loError.ErrorNo=1429
                lcMensaje = "Error al Crear Base de Datos"+CHR(13)
            OTHERWISE
                lcMensaje = "Error no documentado"+CHR(13)
        ENDCASE
        Messagebox(lcMensaje+ loError.MESSAGE+CHR(13)+;
                   "Numero de Error:"+STR(loError.ErrorNo),48,"Error ADO")
    FINALLY
        loCatalog = NULL
        RELEASE loCatalog
    ENDTRY
ELSE
   Messagebox("Debe seleccionar un directorio",64,"Seleccione Directorio")    
ENDIF

************************************************************************************************
 Hay veces que deseamos que al salir del Form no se active el evento Valid de cierto control....

Resulta que en ocasiones queremos que al presionar CTRL+F4 o haciendo click en el boton Cerrar, no se active el evento Valid, imaginandonos que tal vez, dicho evento manda a llamar a algun proceso que consume tiempo, mismo que nuestros usuarios ven (y yo tambien) innecesario. 
La forma "facil" es forzar a que los usuarios vacien el valor en el control y solo entonces, dejar que salga del Formulario, esto tambien es algo engorroso.
Veamos entonces la forma mas cómoda para evitar la validacion cuando en realidad deseamos salirnos....



public oForm
oForm=CREATEOBJECT("MyForm")
oForm.Show()
DEFINE CLASS MyForm AS FORM 
  Caption="Ejemplo para evitar Validación"
  ADD OBJECT MyTextBox AS TextBox WITH Height=25
  ADD OBJECT MyText2 AS TExtBox WITH Height=25, Top=60
  ADD OBJECT cmdCancelar AS CommandButton WITH Top=90, Caption="Cancelar", Height=30
PROCEDURE MyTextbox.Valid
   DO CASE
     CASE !Wontop(Thisform.Name)
        ** Activando desde otro Form, no validar
        Return .T.
     CASE Thisform.ReleaseType>0
        ** Saliendo de VFP, o haciendo clik en Cerrar. No validar
        Return .T.
     OTHERWISE
       DO CASE
         CASE Mdown()
            *** Si es que esta haciendo Click en el boton Cancelar....
            *** No validar, cambia el nombre de cmdCancelar si no se llamara así
            loobj=Sys(1270)
            IF Vartype(loObj)='O' AND lower(loObj.Name)='cmdcancelar'
               loObj = NULL
               Return .T.
            ENDIF
         CASE Lastkey()=27
            *** Presionando la tecla Escape, no validar
            Return .T.
         ENDCASE

      ENDCASE 
      ****** Aqui se pondria el proceso normal de Validacion *******    
      Messagebox("Validando")        
    ENDPROC
    PROCEDURE cmdCancelar.Click
      Thisform.Release()
    ENDPROC
ENDDEFINE


************************************************************************************************
Es una manera de evitar las ordenes insert, update, y delete y utilizar tableUpdate() y tableRevert() 


Suponemos que ya tenemos hecha la conexión SQL

.....
m.lcSQL = "SELECT CLienteID, Nombre, Apell1, Apell2 FROM Clientes WHERE Nombre LIKE 'A%'"
m.llRetorno = (SQLEXEC(m.lnHnd, m.lcSQL, "L_Clientes") > -1)
IF m.llRetorno
  CrearCursorActualizable("L_Clientes", "Clientes", "ClienteId")
  BROWSE
  TABLEUPDATE(1, .T., "L_Clentes")
ENDIF
RETURN
FUNCTION CrearCursorActualizable
  LPARAMETERS tcAlias, tcTabla, tcKeyList
  LOCAL llRetorno, i, lcCampos, lcCamposUp
  LOCAL ARRAY laEstruct(1)

  m.tcAlias = IIF(EMPTY(m.tcAlias), "", ALLTRIM(TRANSFORM(m.tcAlias)))
  m.llRetorno = !EMPTY(m.tcAlias) AND USED(m.tcAlias)
  IF !m.llRetorno
    RETURN .F.
  ENDIF
  m.tcTabla = IIF(EMPTY(m.tcTabla), "", ALLTRIM(TRANSFORM(m.tcTabla)))
  m.tcKeyList = IIF(EMPTY(m.tcKeyList), "", ALLTRIM(TRANSFORM(m.tcKeyList)))

  m.llRetorno = m.llRetorno AND CURSORSETPROP("Buffering", 5)
  m.llRetorno = m.llRetorno AND CURSORSETPROP("SendUpdates", .T.)
  m.llRetorno = m.llRetorno AND CURSORSETPROP("CompareMemo", .F.)
  m.llRetorno = m.llRetorno AND CURSORSETPROP("FetchAsNeeded" ,.T.)
  m.llRetorno = m.llRetorno AND CURSORSETPROP("UpdateType" ,1)
  m.llRetorno = m.llRetorno AND CURSORSETPROP("Tables" , "Tasa." + m.tcTabla)
  m.llRetorno = m.llRetorno AND CURSORSETPROP("WhereType",1)

  IF m.llRetorno
    STORE "" TO m.lcCampos, m.lcCamposUp
    FOR m.i = 1 TO AFIELDS(m.laEstruct, m.tcAlias)
      m.lcCampos = m.lcCampos - m.laEstruct(m.i, 1) - ","
      m.lcCamposUp = m.lcCamposUp - m.laEstruct(m.i, 1) + " TASA." - ;
        m.tcTabla - "." - m.laEstruct(m.i, 1) - ","
    ENDFOR
    m.lcCampos = LEFT(m.lcCampos, LEN(m.lcCampos) - 1)
    m.lcCamposUp = LEFT(m.lcCamposUp, LEN(m.lcCamposUp) - 1)
  ENDIF
  m.llRetorno = m.llRetorno AND CURSORSETPROP("UpdatableFieldList", m.lcCampos)
  m.llRetorno = m.llRetorno AND CURSORSETPROP("UpdateNameList", m.lcCamposUp)
  IF EMPTY(m.tcKeyList)
    m.llRetorno = m.llRetorno AND CURSORSETPROP("WhereType",3)
  ELSE
    m.llRetorno = m.llRetorno AND CURSORSETPROP("KeyFieldList", m.tcKeyList)
  ENDIF

  IF m.lError	&& Control de Error
    m.llRetorno = .F.
    m.lError = .F.
  ENDIF
  RETURN m.llRetorno
ENDFUNC

************************************************************************************************
Una forma de evitar que un error se produzca si tu DLL o Servidor COM no estuviara registrado en la PC de producción....

Suele suceder que si algún componente externo de tu aplicación no este registrado y al momento de querer instanciarlo via CREATEOBJECT(), arrojandonos el Error #1733 "No se encuentra la definición de clase ..."
El codigo para evitarlo es relativamente sencillo. Utilizando la clase Registry que está incluido en Visual FoxPro.



loRegistry = NEWOBJECT("Registry",HOME(1)+"ffcregistry.vcx")
IF loRegistry.Iskey("zipit.cgzipfiles")
   *** Hacer lo propio...
ELSE
    Messagebox("No está registrado el componente de Compresión")
END

************************************************************************************************
Esta función te permite obtener la ruta donde se encuentra el directorio windows.


Cuando usas windows nt es winntsystem32 
Con window 98 y sus similares es windowssystem


? system_dir()

FUNCTION system_dir
    LOCAL lccar AS STRING, lnlongitud AS INTEGER
    LOCAL lccamino AS STRING, lces AS STRING
    DECLARE INTEGER GetSystemDirectory  IN WIN32API STRING , INTEGER
    lccar      = SPACE(128)
    lnlongitud = 128
    lces = getsystemdirectory(@lccar, lnlongitud)
    lccamino = RTRIM(LOWER(LEFT(lccar, lces )))
    RETURN lccamino
ENDFUNC


************************************************************************************************
 GETFONT() retorna el nombre, tamaño y estilo de la fuente que se elije como una cadena de caracteres separados por comas.



Podemos separar esta cadena con el siguiente código:

lc = GETFONT()
IF NOT EMPTY(lc)
  ALINES(la,lc,",")
  lcMsg = "Nombre: " + la(1) + CHR(13) + ;
    "Tamaño: " + la(2) + CHR(13) + ;
    "Estilo: " + la(3)
ELSE
  lcMsg = "No selecciono ninguna fuente"
ENDIF
MESSAGEBOX(lcMsg,64)


************************************************************************************************
A partir de la salida del Service Pack 1 de Visual FoxPro8 hubo un cambio que podria afectar a tu sistema, revisa los detalles a continuacion...

Se ha reportado que los Hooks (enganches) hacia _SCREEN ya no funcionan, por ejemplo, en la ayuda de VFP8 bajo el tema "_SCREEN System Variable Properties, Methods and Events" esta este codigo:


The following example demonstrates how to hook into _SCREEN methods.
*
* Use the following to modify _SCREEN methods:
*
* For VFP6 & 7:
*
     _SCREEN.NewObject("oSH","ScreenHook","screenmethods.prg")
*
* For VFP3 & 5:
*
*     SET PROCEDURE TO screenmethods ADDITIVE
*     _SCREEN.AddObject("oSH","ScreenHook")
*
* Any of the main VFP screen methods can be hooked into in this manner.
*
DEFINE CLASS ScreenHook AS CUSTOM
 oScr = _SCREEN
 PROCEDURE oScr.RESIZE()
  *
  * Code to handle the main VFP screen being resized
  *
  WAIT WINDOW NOWAIT TRANSFORM(THIS.WIDTH)+" "+TRANSFORM(THIS.HEIGHT)
 ENDPROC
 PROCEDURE oScr.moved()
  *
  * Code to handle the main VFP screen being resized
  *
  WAIT WINDOW NOWAIT "moved"
 ENDPROC
 PROCEDURE oScr.RIGHTCLICK
  *
  * Code to do a "shortcut" menu on main VFP screen RightClick
  *
  * DO ..menustestmenu.mpr
 ENDPROC
 *
 * Custom methods work, too.
 *
 PROCEDURE oScr.MyMethod
  WAIT WINDOW "my method fired!"
 ENDPROC
ENDDEFINE


El codigo anterior serviria para agregar metodos personalizados a la variable de Sistema _SCREEN. Pues bien, esto ya no funcionara a partir de VFP8 SP1 

Para tener la misma funcionalidad ahora se debería utilizar BINDEVENT(). La explicacion que se ha dado (de parte de los Gurus en lengua inglesa) es que este tipo de Hooks no era soportado por VFP, y ahora, en esta version el FoxTeam ha decidio quitarlo definitivamente.

Espero les sea de utilidad.

************************************************************************************************
Imprimindo com velocidade em impressoras matriciais usando o Report Designer 
  
Para imprimir em uma impressora matricial com velocidade a partir de qualquer programa em Windows é uma tarefa bastante simples. Para isso, basta selecionarmos uma das fontes nativas da impressora, que, como num passe de mágica, seus relatórios passarão a imprimir como na época do DOS.

Inicialmente, é importante que a impressora esteja instalada com o driver correto. O próprio Windows já nos oferece uma gama bastante ampla durante a configuração. Evite utilizar o driver "Genérico / Somente Texto", pois ele não aproveita todas as fontes nativas da impressora.

No Construtor de relatórios, para que essas fontes se apresentem, basta selecionar a impressora matricial em :

File - Page Setup - Print Setup - então selecione a sua impressora

Recomendo selecionar também "Printable Page"

Pronto !

Da próxima vez que você tentar alterar a fonte de qualquer ítem do relatório, as fontes da impressora se apresentarão. As mais comuns são : DRAFT, SANS SERIF e ROMAN, cada uma delas disponibilizada para varios tamanhos.

Selecione qualquer caixa de texto do report e altere a fonte para qualquer uma que aparecer uma impressora pequena ao lado esquerdo. Teste cada uma delas, pois cada uma exibe em uma tamanho diferente dependendo da quantidade de Cpis (5 CPIs = grande , 18 = condensado). Na tela, aparecerá uma fonte que o Windows julgar parecida, mas cuidado ! O tamanho verdadeiro você só saberá ao imprimir cada fonte no papel.

Obviamente, para configurar este relatório e acessar as fontes, é preciso ter uma matricial tambem, ou então simule a impressora pelo windows.

Recomendo tambem a tradicional limpeza dentro do frx dos campos tag, tag2 e expr.

Porque? Caso utilize duas matriciais de modelos diferentes, as mesmas podem possuir drivers distintos o que pode fazer com que uma delas não imprima como desejado.

Abaixo, uma funçãozinha para limpar o FRX ; Use assim :

LIMPAFRX('c:\seudiretorio\seurelatorio.frx')

Essa rotina pode ser adaptada a sua necessidade, inclusive pode ser usada em modo de execução, caso seu sistema permita aos usuários alterarem os seus relatórios.

*-------------------------------------------------------------------------
Rotina : LIMPAFRX()
* Função : Limpar os campos EXPR, TAG e TAG2 do arquivo FRX
* Parâmetros : - Caracter
* Retorna : Nada
* Notas : Nenhuma
*-------------------------------------------------------------------------

PROCEDURE LIMPAFRX
  PARAMETERS ARQUIVO
  LOCAL lcARQ 

  IF RIGHT(UPPER(ARQUIVO),4) <> '.FRX'
    ARQUIVO = ARQUIVO + '.FRX'
  ENDIF 

  IF NOT FILE(arquivo)
    =MESSAGEBOX('ARQUIVO NÃO EXISTE !')
    RETURN
  ENDIF

  lcAR1 = LEFT(ARQUIVO,LEN(ARQUIVO)-4)

  IF USED(lcARQ)
    SELECT &lcARQ
  ELSE
    SELECT 0
    USE &ARQUIVO
  ENDIF

  LOCATE FOR (ObjType = 1) .AND. (ObjCode = 53)
  REPLACE expr WITH ""
  REPLACE tag  WITH ""
  REPLACE tag2 WITH ""

  USE
  WAIT WINDOW 'ARQUIVO : ' + UPPER(ARQUIVO) + ' Foi atualizado com êxito !!!'

RETURN

 

************************************************************************************************
 Pues eso, aqui teneis un ejemplo de como obtener nuevos codigos (disponibles) en una tabla cuyo indice principal sea numerico. P.E. Clientes, proveedores, etc.


Nos permite decidir el valor minimo por el que realizar la busqueda de un 'hueco'


PARAMETERS pcTabla, pcCampo, pnCodigo
* pcTabla : Tabla en la que buscar
* pcCampo : Campo en el que buscar
* pnCodigo : Opcional, indica el minimo para buscar

* AHORA VARIABLES LOCALES
LOCAL lnCodigoMin
IF PCOUNT()>2
 * se ha pasado codigo minimo
  lnCodigoMin = pnCodigo
ELSE
 * No se ha pasado
  lnCodigoMin = 0
ENDIF

* a) Nos aseguramos de tener la tabla abierta
IF !USED(pcTabla)
  USE (pcTabla) IN 0 SHARED
ENDIF

* ahora montamos la consulta
SELECT MIN(&pcCampo+1) AS NuevoCod ;
FROM &pcTabla ;
WHERE &pcCampo>lnCodigoMin .and.;
 !deleted() .and. ;
!&pcCampo+1 IN ;
(SELECT DISTINC &pcCampo FROM &pcTabla) ;
INTO CURSOR oNew

* Comentar las dos siguientes lineas,
* es solo para chequeo.

? 'Valor Obtenido : '
?? oNew.NuevoCod
* devolvemos nuevo codigo
return oNew.NuevoCod

***********  FIN  *******

************************************************************************************************
 Muy simple y lo codifica en base 64 binario. Para VFP 7/8




tupass = "PEPE"
pass_encoded = STRCONV(tupass,13) 
? pass_encoded
pass_decoded = STRCONV(pass_encoded,14)
? pass_decoded

************************************************************************************************
 A veces necesitamos que nuestra aplicación aparezca encima de cualquier otra aplicación existente, aquí un modo de hacerlo....

*******************************************************
* Newsgroups: microsoft.public.es.vfoxpro
* Date: 25/04/2003
* Subject: Re: Que VFP no se ponga en primer plano
* From. Pepe Llopis
*******************************************************


******************************************
*** Coloca un form por encima de todo lo que hay en windows
FUNCTION PrimerPlano
 LPARAMETER nHwnd

   DECLARE Integer SetForegroundWindow ;
      IN WIN32API ;
      Integer nHwnd

 SetForegroundWindow(nHwnd)    && Esto para abrir boca

&& Y ahora para rematar la faena
 DECLARE SHORT SetWindowPos IN USER32 ;
    INTEGER hWnd, ;
    INTEGER hWndInsertAfter, ;
    INTEGER x, ;
    INTEGER y, ;
    INTEGER cx, ;
    INTEGER cy, ;
    INTEGER uFlags
 #DEFINE HWND_TOPMOST_WINDOW -1
 #DEFINE SWP_NOMOVE 2
 #DEFINE SWP_NOSIZE 1
 #DEFINE SWP_SHOWWINDOW 0x40
 #DEFINE SWP_BRINGTOTOP SWP_NOSIZE + SWP_NOMOVE + SWP_SHOWWINDOW
 DECLARE INTEGER GetLastError IN WIN32API
&& Se asume que nHwnd es el hWnd del form que hay que poner encima
 IF SetWindowPos(nHwnd,HWND_TOPMOST_WINDOW,0,0,0,0,SWP_BRINGTOTOP) # 0
    RETURN .T.  &&  Funciona
 ELSE
    RETURN .F.  &&  Oooops
 ENDIF

ENDFUNC
**

Un poco bestiajo, pero te coloca un form en primer plano en XP.

Saludos

************************************************************************************************
 El objetivo de esta clase es obtener algunos cálculos estadísticos a partir de una muestra (tabla o cursor) y de un nombre de campo a analizar. En el caso de Media Ponderada se describe el ejemplo con la media de población de una provincia y municipio, y es aplicable para otra situación.


Se puede complementar con otras funciones que no se calculan. El código fue escrito y depurado con la participación de Fernando Puyuelo Ossorio, Juan Carlos Sanchez, Jorge Mota y Ana María Bisbé.

Esperamos que sea de utilidad. Agradecemos sugerencias.

* Ejemplo de llamada

* En cada Procedure se describen los parámetros

oEst = CREATEOBJECT("oEstadisticas")

oEst.CalculosEstadisticos(100, 10, 'curEstadisticas', 'Ventas',   'España', 'Madrid',;

  &tnmedia, &tnDesviacionTipica, &tnModa, &tnMediana, &tnPercentil25,;

  &tnPercentil75, &tnMaximo, &tnMinimo)



* Donde:

*   tnMuestras - Cantidad de muestras que cumplieron las condicones. Por ej. 100

*   tnPorcientoExtremo - Indica el porciento a eliminar en ambos extremos. Por ej. 10

*   tcCursorMuestras - Nombre del cursor en el que se encuentra la muestra. Por ej. 'curEstadisticas'

*   tcCampoValor - Campo por el que se realizarán los cálculos. Por ej. 'Ventas'

*   tcPais - pais que se recibe como parámetro. Por ej. 'España'

*   tcProvincia - provincia que se recibe como parámetro. Por ej. 'Madrid'



**************************************************

*-- Class:        oestadisticas ()

*-- ParentClass:  custom

*-- BaseClass:    custom

*-- Time Stamp:   09/01/03 06:19:10 PM

*   Programador:  Ana María Bisbé York



DEFINE CLASS oestadisticas AS SESSION

  HEIGHT = 23

  WIDTH = 145

  NAME = "oestadisticas"



  PROCEDURE CalculosEstadisticos

    *---------------------------------------------------------

    *   Método:

    *      OESTADISTICAS.CALCULOSESTADISTICOS

    *   Parameters:

    *      tnMuestras - Cantidad de muestras que cumplieron las condicones

    *      tcCampoValor - Campo por el que se realizarán los cálculos

    *      tnPorcientoExtremo - Indica el porciento a eliminar en ambos extremos

    *      tcCursorMuestras - Nombre del cursor en el que se encuentra la muestra

    *      tcPais - pais que se recibe como parámetro

    *      tcProvincia - provincia que se recibe como parámetro

    *   Valores que retorna

    *      Resultantes de los cálculos que son:

    *      lnMedia, lnDesviacionTipica, lnModa, lnMediana, lnPercentil25, lnPercentil75, lnMaximo, lnMinimo

    *   Objetivo:

    *      Obtener las estadísticas de los valores para la zona actual. Para ello es necesario

    *         - Descartar valores extremos

    *          - Calcular Media / Media Ponderada

    *          - Calcular Desviación Típica

    *          - Calcular Moda

    *          - Calcular Mediana

    *          - Calcular Percentil25

    *          - Calcular Percentil75

    *          - Calcular Máximo

    *          - Calcular Mínimo

    *---------------------------------------------------------

    PARAMETERS tnMuestras, tnPorcientoExtremo, tcCursorMuestras, tcCampoValor, tcPais, tcProvincia,;

      tnmedia, tnDesviacionTipica, tnModa, tnMediana, tnPercentil25, tnPercentil75, tnMaximo, tnMinimo



    * Descartar extremos

    THIS.descartaextremos(tnMuestras, tnPorcientoExtremo, tcCursorMuestras)



    * Calcular Media

    tnmedia = THIS.calcularmedia(tcCursorMuestras, tcCampoValor)



    * Calcular Media Ponderada

    tnMediaPonderada = THIS.calcularmediaponderada(tcCursorMuestras, tcCampoValor, tcPais, tcProvincia)



    * Calcular Desviación Típica

    tnDesviacionTipica = THIS.calculardesviaciontipica(tcCursorMuestras, tcCampoValor)



    * Calcular Moda

    tnModa = THIS.calcularmoda(tcCursorMuestras, tcCampoValor)



    * Calcular Mediana * idem fórmula para los percentiles 25, 75 y 50(mediana) se emplea el mismo método

    tnMediana = THIS.calcularpercentil(tcCursorMuestras, 50, tcCampoValor)



    * Calcular Percentil25

    tnPercentil25 = THIS.calcularpercentil(tcCursorMuestras, 25, tcCampoValor)



    * Calcular Percentil75

    tnPercentil75 = THIS.calcularpercentil(tcCursorMuestras, 75, tcCampoValor)



    * Calcular Máximo

    SELE (tcCursorMuestras)

    CALCULATE MAX(valor) TO tnMaximo



    * Calcular Mínimo

    SELE (tcCursorMuestras)

    CALCULATE MIN(valor) TO tnMinimo



  ENDPROC



  PROTECTED PROCEDURE descartaextremos

    *---------------------------------------------------------

    *   Método:

    *      OESTADISTICAS.DESCARTAEXTREMOS

    *   Parameters:

    *      tnMuestras - cantidad de muestras

    *      tnPorcientoExtremo - porciento a descartar

    *      tcCursorMuestras - nombre del cursor que contiene la muestra

    *   Objetivo:

    *      Descartar los valores extremos de la muestra.

    *      La cantidad de valores a descartar se determina por el porciento a descartar (tnPorcientoExtremo) y

    *      la cantidad de elementos de la muestra (tnMuestra)que es devuelto por THIS.DeterminaMinimoMuestras)

    *---------------------------------------------------------

    PARAMETERS tnMuestras, tnPorcientoExtremo, tcCursorMuestras



    LOCAL lnExtremos



    lnExtremos = 0 && Cantidad de elementos a descartar por cada extremo

    lnExtremos = INT( tnMuestras * tnPorcientoExtremo / 100)



    IF lnExtremos <> 0

      IF USED(tcCursorMuestras)

        SELE (tcCursorMuestras)

        GO TOP

        IF !EOF()

          DELETE NEXT lnExtremos && elimino los valores extremos en el inicio del cursor

        ENDIF

        GO BOTT

        IF !EOF()

          SKIP - (lnExtremos - 1)

          DELETE REST && elimino los valores extremos en el final del cursor

        ENDIF

      ENDIF

    ENDIF



  ENDPROC



  PROCEDURE calcularmedia

    *---------------------------------------------------------

    *   Método:

    *      OESTADISTICAS.CALCULARMEDIA

    *   Parameters:

    *      tcCursorMuestras - nombre del cursor que contiene la muestra

    *      tcCampoValor - nombre del campo

    *   Valor que retorna

    *      lnMedia - Valor de la media artimética

    *   Objetivo:

    *       Calcular media aritmética

    *       La media aritmética es la suma de todos los valores de la variable

    *       dividido por el número total de observaciones

    *---------------------------------------------------------

    PARAMETERS tcCursorMuestras, tcCampoValor



    LOCAL lnMedia



    lnMedia = 0  && Valor de la media artimética que se retorna



    SELE (tcCursorMuestras)

    CALCULATE AVG(&tcCampoValor) TO lnMedia



    RETURN lnMedia



  ENDPROC



  PROCEDURE calculardesviaciontipica

    *---------------------------------------------------------

    *   Método:

    *      OESTADISTICAS.CALCULARDESVIACIONTIPICA

    *   Parameters:

    *      tcCursorMuestras - nombre del cursor que contiene la muestra

    *      tcCampoValor - nombre del campo

    *   Valor que retorna

    *      lnDesviacionTipica - Valor calculado de Desviación Típica

    *   Objetivo:

    *       Calcular Desviación Típica - Raiz cuadrada de la varianza, hay función nativa de VFP para ello

    *---------------------------------------------------------

    PARAMETERS tcCursorMuestras, tcCampoValor, tnDesviacionTipica



    LOCAL lnDesviacionTipica



    lnDesviacionTipica = 0      && valor calculado de Desviación Típica



    SELE (tcCursorMuestras)

    CALCULATE STD(&tcCampoValor) TO lnDesviacionTipica



    RETURN lnDesviacionTipica



  ENDPROC





  PROCEDURE calcularmoda

    *---------------------------------------------------------

    *   Método:

    *      OESTADISTICAS.CALCULARMODA

    *   Parameters:

    *      tcCursorMuestras - nombre del cursor que contiene la muestra

    *      tcCampoValor - nombre del campo

    *   Valor que retorna

    *      lnModa - Valor de la Moda

    *   Objetivo:

    *       Calcular moda - es el valor que se repite más veces, es decir, aquel que tiene mayor frecuencia absoluta

    *       para variables con muchos valores posibles, tiene sentido considerar intervalos de valores

    *       y definir la moda como el intervalo que acumula mayor observaciones

    *       Se divide el recorrido de la variable en intervalos y se calcula cual es el intervalo o intervalos

    *       con mayor número de observaciones. Se toma el primer intervalo con mayor número de muestras.

    *---------------------------------------------------------

    PARAMETERS  tcCursorMuestras, tcCampoValor



    LOCAL lnModa, lccampo, lnRedondeo



    lnModa = 0         && valor de Moda que se calcula

    lccampo = ''      && temporal para concatenar el campo del select

    lnRedondeo = 100   && determina el valor al que se debe redondear (se puede pasar como parámetro)

    lccampo= 'cursorMuestras.' + tcCampoValor



    SELECT ROUND(&lccampo / lnRedondeo,0) * lnRedondeo AS valor, COUNT(*) AS cuenta;

      FROM (tcCursorMuestras) AS CursorMuestras GROUP BY valor ORDER BY cuenta DESC;

      INTO CURSOR TempModa



    IF _TALLY <> 0

      GO TOP

      lnModa = valor

    ENDIF



    USE IN SELECT ('TempModa')



    RETURN lnModa

  ENDPROC



  PROCEDURE calcularpercentil

    *---------------------------------------------------------

    *   Método:

    *      OESTADISTICAS.CALCULARPERCENTIL

    *   Parameters:

    *      tcCursorMuestras - nombre del cursor que contiene la muestra

    *      tcCampoValor - nombre del campo

    *      tnPercentil - 25 / 50 / 75

    *   Valor que retorna

    *      lnPercentil - Valor del percentil calculado

    *   Objetivo:

    *      Calcular el Valor de la muestra en la posición que ocupa el 25 - 50 - 75 porciento

    *      Se denomina Mediana al valor de la variable que, tras ordenar los datos de menor a mayor

    *       deja a su izquierda y a su derecha igual cantidad de datos, o sea es el que esta en el medio

    *       es igual que sacar el Percentil del 50%

    *---------------------------------------------------------

    PARAMETERS tcCursorMuestras,  tnpercentil, tcCampoValor



    LOCAL lnPercentil, lnrecno, lccampo, lnValor



    STORE 0 TO lnValor, lnrecno, lnPercentil

    lccampo = tcCursorMuestras+'.'+tcCampoValor



    SELECT &lccampo AS valor FROM (tcCursorMuestras) ORDER BY valor INTO CURSOR curPercentil



    IF _TALLY <> 0

      COUNT TO lnrecno                && cantidad total de elementos de la muestra

      lnValor = INT((lnrecno * tnpercentil) / 100)

      IF lnValor = 0

        GO TOP

      ELSE

        GO lnValor

      ENDIF                        && voy al recno que se corresponde con la posición

      lnPercentil = curPercentil.valor   && toma el valor en el recno

      USE IN SELECT ('curPercentil')      && cierro el cursor, que no hace falta que permanezca abierto

    ENDIF



    RETURN lnPercentil



  ENDPROC



  PROCEDURE calcularmediaponderada

    *---------------------------------------------------------

    *   Método:

    *      OESTADISTICAS.CALCULARMEDIAPONDERADA

    *   Parameters:

    *      tcCursorMuestras - nombre del cursor que contiene la muestra

    *      tcCampoValor - nombre del campo

    *      tcPais - pais que se recibe como parámetro

    *      tcProvincia - provincia que se recibe como parámetro

    *   Valor que retorna

    *      lnMediaPonderada - Valor de la media artimética ponderada para la provincia

    *   Objetivo:

    *       Calcular media ponderada a nivel de provicia

    *       La media aritmética es la suma de todos los valores ordenados de la variable

    *             dividido por el número total de observaciones

    *       A la media calculada para el campo valor a nivel de cada municipio se le asigna un peso que queda determinado

    *       por el porcentaje de habitantes que tiene respecto al total provincial. Para ello:

    *         - Obtener las poblaciones de los municipios de la provincia seleccionada y la media AVG(valor)

    *         - Se obtiene la cantidad total de poblacion para la provincia

    *         - Para cada municipio

    *         - Media ponderada = MediaPonderada + MediaMunicipio * (PoblacionMunicipio / PoblacionProvincia)

    *---------------------------------------------------------

    PARAMETERS tcCursorMuestras, tcCampoValor, tcPais, tcProvincia



    LOCAL lnMediaPonderada, lnPoblacion, lcMunicipi



    lnMediaPonderada = 0    && Valor calcularo de Media Aritmética Ponderada que se calcula

    lnPoblacion = 0       && Población de un municipio

    lnPobTotal = 0          && Población total de la provncia

    lcMunicipi = ''         && var. temporal para buscar



    * De la tabla municipi se seleccionan los datos de población para cada municipiid que tengo

    * en la muestra estadistica CursorMuestras.municipiid

    SELECT curMuestraEstadis.municipiid, municipi.derecho AS poblacion, ;

      AVG(curMuestraEstadis.valor) AS MediaMuni ;

      FROM curMuestraEstadis, municipi ;

      WHERE curMuestraEstadis.municipiid = municipi.municipiid AND ;

      municipi.provinciid = tcProvincia AND municipi.paisid = tcPais;

      GROUP BY municipi.municipiid ;

      INTO CURSOR tempMedia



    IF _TALLY <> 0

      USE DBF('tempMedia') IN 0 SHARE AGAIN ALIAS ('curPoblacion')

    ENDIF

    USE IN SELECT('tempMedia')

    USE IN SELECT ('municipi')



    * Se obtiene la cantidad total de poblacion para la provincia

    SELECT curPoblacion

    SUM curPoblacion.poblacion TO lnPobTotal

    GO TOP

    SCAN

      lnMediaPonderada = lnMediaPonderada + MediaMuni * IIF(lnPobTotal = 0, 0 , poblacion / lnPobTotal)

    ENDSCAN

    USE IN SELECT ('curPoblacion')

  ENDIF



  RETURN lnMediaPonderada



ENDPROC



ENDDEFINE

*

*-- EndDefine: oestadisticas
************************************************************************************************
Clases Una de las maneras de evitar la recursión es el uso de Pilas (Stacks), aquí expongo el cómo manejar está tecnica en clases nativas de VFP.

Curiosamente, el Framework Microsoft .NET tiene una clase nativa para el manejo de pilas (Stacks), a partir de esa idea me di a la labor de tener una clase que manejara este concepto, es perfectible, así que podrían usarla según sus necesidades. Se aceptan tambien críticas y sugerencias....
Esta versión fue desarrollada tomando en cuenta la compatibilidad con versiones 6,7 y 8. En breve habrá una versión exclusiva de VFP8, donde se hará uso de varias características que harán más efectivo el trabajo y practicamente ilimitado (esta versión solo puede manejar 65,000 elementos en la pila).

Metodos:


    * Push -- Guarda un elemento en la pila. Retorna el número de elementos que tiene actualmente la pila.
    * Pop -- Extrae el ultimo elemeno de la pila. Si ya no hay elementos en la pila retorna un NULL.
    * PopAsString -- Extrae el último elemento de la pila como cadena. Como parámetro puede utilizar los mismos usados por la función TRANSFORM de VFP.
    * IsEmpty -- Retorna .T. si la pila está vacia, .F. de lo contrario.
    * CountElements -- Retorna el número de elementos almacenados en la pila.


Propiedades:


    * Counter -- Numero de elementos en la pila.


Ejemplo de uso...



     loStack = CREATEOBJECT("Stack")

     loStack.Push(10)

     loStack.Push($50)

     loStack.Push("hola Mundo")

     loStack.Push(.T.)

     DO while !loStack.IsEmpty()

          ?loStack.Pop()

     ENDDO


*******************************************
* Clase Stack
* Autor: Espartaco Palma
* Fecha: Acapulco, Guerrero, México 10/08/2003
*******************************************



DEFINE CLASS Stack AS eBaseClass 

   PROCEDURE Pop

     LOCAL luRetValue 

     IF This.nElements > 0

        luRetValue = This.aElements[This.nElements]

        This.nElements = This.nElements - 1 

        this.Counter = this.nElements 

        DIMENSION this.aElements[IIF(This.nElements==0,1,This.nElements)]

     ELSE

        luRetValue = NULL   

     ENDIF

     RETURN luRetValue

   ENDPROC

   PROCEDURE Push

   LPARAMETERS  tuValue

      This.nElements = This.nElements + 1 

      this.Counter = this.nElements

      DIMENSION this.aElements[This.nElements]

      this.aElements[this.nElements]=tuValue

      RETURN this.Counter 

   ENDPROC 

   PROCEDURE PopAsString

   LPARAMETERS tcFormatCodes 

       RETURN This.ReturnAsString(This.Pop(),tcFormatCodes)

   ENDPROC

ENDDEFINE



DEFINE CLASS eBaseClass as Relation

   PROTECTED aElements[1]

   PROTECTED nElements

   Counter = 0

   PROCEDURE Init

      this.nElements = 0

      this.aElements[1] = NULL

   ENDPROC

   PROCEDURE Counter_Assing

   LPARAMETERS tuNewValue

        NODEFAULT     

   ENDPROC

   PROCEDURE ReturnAsString 

   LPARAMETERS tuValue,tcFormatCodes

     IF VARTYPE(tcFormatCodes)="C" AND !EMPTY(tcFormatCodes)

        RETURN TRANSFORM(tuValue,tcFormatCodes)

     ELSE

        RETURN TRANSFORM(tuValue)

     ENDIF      

   ENDPROC

   PROCEDURE IsEmpty

         Return (this.Counter==0)

   ENDPROC

   PROCEDURE CountElements

      RETURN this.Counter

   ENDPROC

ENDDEFINE



************************************************************************************************
oForm=CREATEOBJECT("MyTextEditor",GETFILE(),"Editando Archivo",2)

oForm.SHow(1)

DEFINE CLASS myTextEditor as _showtext OF (HOME(1)+"ffc_reports.vcx")

  PROCEDURE INIT

    LPARAMETERS tcSourceFile,; && Path del archivo a Mostrar

                      tcCaption,;  Título de la Venta 

                      tnWindowState && Estado de la ventana, Normal = 0, Minimizado = 1 , Maximizado =2

    DODEFAULT(tcSourceFile)

    WITH This

      .Caption = IIF(VARTYPE(tcCaption)='C' AND !EMPTY(tcCaption),tcCaption,"Visor de Texto")

      .WindowState=IIF(VARTYPE(tnWindowState)='N' AND INLIST(tnWindowState,0,1,2),tnWindowState,0)

      .cmdClose.Caption="Cerrar"

      .cmdSave.Caption="Guardar como"

      .cmdFonts.Caption="Fuentes"

      .chkReadOnly.Caption="Sólo lectura"

    ENDWITH  

  ENDPROC  

   PROCEDURE Activate

       This.Resize() 

       DODEFAULT()

   ENDPROC  

ENDDEFINE 





Como idea adicional, podrías utilizar tu propio método para generar un reporte o mandar tu reporte a ASCII (REPORT FORM < TuReporte > TO FILE ASCII ) , pasarlo a archivo y mostrarlo....



lcFile = SYS(2015)+".txt"

OPEN DATABASE HOME(2)+"datatestdata.dbc"

SET TEXTMERGE ON

SET TEXTMERGE TO (lcFile) NOSHOW

lcTitle="Reporte de Clientes"

IF !USED("Customer")

  USE Customer IN 0

ENDIF  

SELECT Customer

< < PADC(lcTitle,80," ") > >





Clave < < PADC("Compañia",40," ") > >               Contacto

SCAN

  < < Cust_id > >   < < Company > >         < < Contact > >    

ENDSCAN

SET TEXTMERGE TO

SET TEXTMERGE OFF

oForm=CREATEOBJECT("MyTextEditor",lcFile,lcTitle,2)

oForm.Show(1)

DELETE FILE (lcFile)

CLOSE TABLES all

CLOSE DATABASES all


************************************************************************************************
Obtiene un identificador único de 38 caracteres.


CREATE CURSOR Temporal (Clave CHAR(38) UNIQUE)



FOR i = 1 TO 10000

   INSERT INTO Temporal VALUES (GetUniqueID())

ENDFOR



PROCEDURE GetUniqueID() AS STRING

   RETURN ;

      [{] +;

      CHR(INT((90-65+1) * RAND()+ 65)) +;

      RIGHT(SYS(2015),7) + [-] +;

      RIGHT(SYS(2015),4) + [-] +;

      RIGHT(SYS(2015),4) + [-] +;

      RIGHT(SYS(2015),4) + [-] +;

      ALLTRIM(STR(INT((9-0+0) * RAND()+ 0))) + ;

      ALLTRIM(STR(INT((9-0+0) * RAND()+ 0))) + ;

      ALLTRIM(STR(INT((9-0+0) * RAND()+ 0))) + ;

      ALLTRIM(STR(INT((9-0+0) * RAND()+ 0))) + ;

      ALLTRIM(STR(INT((9-0+0) * RAND()+ 0))) + ;

      ALLTRIM(STR(INT((9-0+0) * RAND()+ 0))) + ;

      ALLTRIM(STR(INT((9-0+0) * RAND()+ 0))) + ;

      ALLTRIM(STR(INT((9-0+0) * RAND()+ 0))) + ;

      ALLTRIM(STR(INT((9-0+0) * RAND()+ 0))) + ;

      ALLTRIM(STR(INT((9-0+0) * RAND()+ 0))) + ;

      ALLTRIM(STR(INT((9-0+0) * RAND()+ 0))) + ;

      ALLTRIM(STR(INT((9-0+0) * RAND()+ 0))) + ;

      [}]

ENDPROC
************************************************************************************************
Este es un Ejemplo de Como Aprovechar la Nueva Clase "Empty" que nos proporciona VFP8.



Esta Rutina, nos permite Leer Los Nombres de las variables que usaremos en Nuestro Programa,
en una Tabla y su Respectivo Valor, para No Tener que recompilar el programa cada vez que
tengamos que cambiar el valor de una variable.

En Lugar de Variables Publicas, podemos tener un Objeto Global, que contendra una propiedad
por cada Registro que encuentre en la tabla, y su valor correspondiente.

La Ventaja es que el objeto solo contendra
propiedades, ningun metodo o evento, por lo
tanto sera mas que liviano. y pueden ser facilmente pasado como parametro a otras aplicaciones nuestras variables.

El Codigo Es Este:

Define Class oEntorno As Session

	Procedure LeerConf

	Lparameters cArchivo, cCampo, cValor

	If Type('cArchivo')<>'C' Or Type('cCampo')<>'C' Or Type('cValor')<>'C' Or Len(Alltrim(cArchivo))= 0 Or Len(Alltrim(cCampo))= 0 Or Len(Alltrim(cValor))= 0

		Wait Window 'Error del Programador!'

		Return .F.

	Endif

	Local uValor, cCad, nCiclo, oProp, cAlias

	Use In Select('Origen')

	Use (cArchivo) Alias Origen Again In 0 Shared

	cCad=',.*+/- =()[]{}<>^&%$#"!@)(¿?'+"'"

	Select Distinct (&cCampo) As cOpcion, (&cValor) As uValor From Origen Into Cursor CurProp Readwrite

	If Reccount('CurProp')>0

		Update CurProp Set cOpcion =Chrtran(Alltrim(CurProp.cOpcion), cCad, Replicate('_',Len(cCad)))

		oProp = Createobject("Empty")

		Select CurProp

		Scan

			AddProperty(oProp, Alltrim(CurProp.cOpcion),'')

			Do Case

			Case Alltrim(Upper(transform(curprop.uValor)))='.NULL'

				cCad = [Store .Null. to Oprop.]+Alltrim(CurProp.cOpcion)

			Case Type(Evaluate("curprop.uValor"))='L'

				cCad = [Store ]+ Upper(Transform(CurProp.uValor))+[ to Oprop.]+Alltrim(CurProp.cOpcion)

			Case Getwordcount(CurProp.uValor,'/-')=3 And Len(Alltrim(CurProp.uValor))=10

				cCad = [Store {^] +Alltrim(CurProp.uValor)+ [} to Oprop.]+Alltrim(CurProp.cOpcion)

			Case Type(Evaluate([curprop.uValor]))='N'

				cCad = [Store ]+ Upper(Transform(CurProp.uValor))+[ to Oprop.]+Alltrim(CurProp.cOpcion)

			Otherwise

				cCad = [Store "]+ Upper(Transform(CurProp.uValor))+[" to Oprop.]+Alltrim(CurProp.cOpcion)

			Endcase

			&cCad

		Endscan

	Endif

	Use In Select('CurProp')

	Use In Select('Origen')

	Return oProp

	Endproc

Enddefine


Los parametros que deben pasarse son :
La ruta al Archivo que leeremos
El Nombre del Campo que contendra los nombres de las propiedades
el Nombre del Campo que contendra los valores


Para Usarlo, suponiendo que Nuestra Tabla es:
"C:configuravariables.dbf"
y la estructura es:
Id Numeric(2), Nombre char(16), Valor Char(200)

Hariamos
Set Library to oEntorno.prg &&donde oEntorno.prg es el nombre con que grabaron esta rutina
Local oEnt
Public oGlobal
oEnt = CreateObject("oEntorno")
oGlobal = oEnt.LeerConf("C:configuravariables.dbf","Nombre","Valor")

y a partir de este momento, oGlobal ya tiene tantas propiedades como registros en la tabla.

NOTA: Ambos campos tienen que ser Caracter. La rutina intenta detectar el tipo de dato que es, para las variables de tipo Date, debe ir almacenada en el formato
AAAA/MM/DD. Acepta registros con campo =Null para los valores.

Saludos desde Guatemala.
************************************************************************************************
Rutinas Con estas funciones podemos saber si una cadena contiene dígitos numéricos.

Esta son dos respuestas que se publicaron en el grupo de noticias para contestar la pregunta:

EJ:
? TieneNumeros("VFP")
? TieneNumeros("VFP8")

por Carlos Yohn Zubiria
FUNCTION TieneNumeros
lparameters m.cadena
RETURN isdigit(m.cadena) or iif(len(m.cadena) < 2, .f.,TieneNumeros(substr(m.cadena, 2)))


por Luis María Guayán
FUNCTION TieneNumeros(tcCadena)
RETURN tcCadena # CHRTRAN(tcCadena,"0123456789","")


************************************************************************************************
 Cuando necesitemos saber que usuarios estan conectados a una base de datos de MS SQL Server 2000 podemos usar este procedmiento almacenado.



create procedure @base_de_datos nchar(128) as 

begin 

set nocount on 

if exists (select name from sysobjects 

where name = 'tbl_usuarios_conectados') 

drop table tbl_usuarios_conectados 



create table tbl_usuarios_conectados (spid smallint, 

/* esta columna se puede borrar si se desea utilizar en SQL Server 7*/ 

ecid smallint, status nchar(30), loginname nchar(128), 

hostname nchar(128), blk char(5), dbname nchar(128), cmd nchar(16)) 



INSERT tbl_usuarios_conectados 

exec sp_who 



select distinct loginname, hostname 

from tbl_usuarios_conectados 

where dbname = @base_de_datos and hostname <> ' ' 

return 

end 
************************************************************************************************
Proceso para encriptar datos.



FUNCTION  Encriptar

  PARAMETER vtexto

  LOCAL vlong,vcadena,vconlet,vencrip

  IF TYPE('vtexto')<>'C' OR TYPE('vtexto')='U'

    MESSAGEBOX('VARIABLE NO VALIDA, DEBE SER CARACTER',64,'Mensaje del Sistema')

    RETURN ''

  ENDIF

  vencrip=''

  vcadena=''

  vconlet=0

  vlong=LEN(vtexto)

  FOR i=1 TO vlong

    vcadena=vcadena+PADL(ALLTRIM(STR(ASC(SUBSTR(vtexto,i,1))+3)),3,'0')

    vconlet=vconlet+1

    IF vconlet=3 OR i=vlong

      vencrip=vencrip+BINTOC(VAL(vcadena))

      vcadena=''

      vconlet=0

    ENDIF

  ENDFOR

  vencrip=STUFF(vencrip,1,0,BINTOC(064051048))

  RETURN vencrip

ENDFUNC
************************************************************************************************
Una fácil manera de hacer una barra de progreso con código puro de Visual FoxPro.

Esta es la definición de la clase termometro y un simple ejemplo de como utilizarla. Una vez creado el objeto, debemos llamar al método Actualizar() con el procentaje de ejecución del proceso. [0..100]

*-- Ejemplo

lo = CREATEOBJECT("Termometro", "Barra de progreso 100% VFP...")

lo.SHOW(2)

*-- Simulo un proceso

FOR ln = 1 TO 100

  lo.Actualizar(ln)

  INKEY(.05)

ENDFOR

MESSAGEBOX("Proceso terminado",64)

lo = .NULL.



*--------------------------------------

* Definición de la clase termometro

*--------------------------------------

DEFINE CLASS termometro AS FORM

  DOCREATE = .T.

  HEIGHT = 72

  WIDTH = 375

  BORDERSTYLE = 2

  TITLEBAR = 0

  WINDOWTYPE = 0

  AUTOCENTER = .T.

  NAME = "Termometro"

  AnchoAux = 0

  *--

  PROCEDURE INIT

    LPARAMETERS tcTitulo

    SYS(2002)

    THIS.CrearObjetos(tcTitulo)

    THIS.AnchoAux = THIS.CNT.CNT.WIDTH

    THIS.Actualizar(0)

  ENDPROC

  *--

  PROCEDURE DESTROY

    SYS(2002,1)

  ENDPROC

  *--

  PROCEDURE actualizar

    LPARAMETERS tnPorc

    tnPorc = MAX(MIN(tnPorc,100),0)

    THIS.CNT.CNT.WIDTH = THIS.AnchoAux * tnPorc /100

    STORE TRANSFORM(tnPorc,"999")+"%" TO ;

      THIS.CNT.lbl.CAPTION, ;

      THIS.CNT.CNT.lbl.CAPTION

      THIS.DRAW 

  ENDPROC

  *--

  PROCEDURE CrearObjetos

    LPARAMETERS tcTitulo

    THIS.ADDOBJECT("lblTitulo","label")

    WITH THIS.lblTitulo

      .FONTBOLD = .T.

      .ALIGNMENT = 2

      .CAPTION = IIF(EMPTY(tcTitulo),;

        "En progreso ...",tcTitulo)

      .LEFT = 0

      .TOP = 10

      .WIDTH = 375

      .VISIBLE = .T.

    ENDWITH

    THIS.ADDOBJECT("cnt","container")

    WITH THIS.CNT

      .TOP = 36

      .LEFT = 9

      .WIDTH = 360

      .HEIGHT = 26

      .SPECIALEFFECT = 1

      .BACKCOLOR = RGB(255,255,255)

      .VISIBLE = .T.

      .ADDOBJECT("lbl","label")

      WITH .lbl

        .FONTBOLD = .T.

        .ALIGNMENT = 2

        .BACKSTYLE = 0

        .CAPTION = "100%"

        .HEIGHT = 20

        .LEFT = 0

        .TOP = 6

        .WIDTH = 360

        .VISIBLE = .T.

      ENDWITH

      .ADDOBJECT("cnt","container")

      WITH .CNT

        .TOP = 2

        .LEFT = 2

        .WIDTH = 356

        .HEIGHT = 22

        .BORDERWIDTH = 0

        .BACKCOLOR = RGB(0,0,255)

        .ADDOBJECT("lbl","label")

        .VISIBLE = .T.

        WITH .lbl

          .FONTBOLD = .T.

          .ALIGNMENT = 2

          .BACKSTYLE = 0

          .CAPTION = "100%"

          .HEIGHT = 20

          .LEFT = 0

          .TOP = 4

          .WIDTH = 356

          .FORECOLOR = RGB(255,255,255)

          .VISIBLE = .T.

        ENDWITH

      ENDWITH

    ENDWITH

  ENDPROC

ENDDEFINE

*--------------------------------------
************************************************************************************************
as colecciones comúnmente almacenan instancias de cosas, en su mayoría objetos. VFP8 nos ha entregado una clase nativa llamada Collection, la cual contiene unas pocas propiedades, métodos y eventos. A través de esta nueva clase, podemos crear poderosos objetos que a la larga reemplazaran las matrices que hemos venido utilizando en versiones anteriores.


Como muestra vamos a Coleccionar la función ADIR()

Local loDirCollection As Object, lcDirectory As String, loItem As Object

*Selección de la carpeta a examinar

lcDirectory =  Getdir([],[Seleccione la carpeta a listar], [Seleccionar carpeta],64)

If Empty(lcDirectory) Then

  Return .F.

Endif

If !Directory(lcDirectory) Then

  Return .F.

Endif

*Creación del objeto collection

loDirCollection  = Createobject([DirCollection], lcDirectory, [*.*], [AD])

*Recorrer el objeto para verificar que devolvio

For Each loItem In loDirCollection

  ? loItem.FileName

  ? loItem.FileSize

  ? loItem.DateLastModified

  ? loItem.TimeLastModified

  ? loItem.Fullpath

  ? loItem.Extension

  ? loItem.Drive

  ? loItem.Stem

  ? loItem.Fname

  ? loItem.ShortPath

  ? loItem.ShortName

  ? loItem.IsHidden

  ? loItem.IsReadOnly

  ? loItem.IsSystem

  ? loItem.IsFolder

  ? [==========================] + Chr(13)

Endfor

*Definición de la clase DirCollection

Define Class DirCollection As Collection

  Procedure Init (cDirectory As String, cExt As String, cAttribute As String)

    *Variables locales

    Local i As Integer, loProperties As Object, j As Integer

    Local cPathDirectory As String, lcFullPath As String

    Local Array laDir[1,1]

    Local Array laDlls[1,1]

    Local lcFullPath  As String, lnBufferSize As Integer, lnShortPathLen As Double

    Local lcShortPath  As String, nDlls As Integer

    Local lcAttribute As String

    nDlls = Adlls(laDlls)

    If nDlls = 0 Then

      This.LoadGetShortPathName()

    Else

      If Ascan(laDlls, [GetShortPathName]) = 0 Then

        This.LoadGetShortPathName()

      Endif

    Endif

    cPathDirectory = Addbs(cDirectory) + cExt

    j = Adir(laDir, cPathDirectory ,cAttribute,1)

    For i = 1 To j

      lcFullPath 	= cDirectory + laDir[i,1]

      lcBuffer 	= Space(511)

      lnBufferSize 	= 511

      lnShortPathLen 	= GetShortPathName(lcFullPath, @lcBuffer, @lnBufferSize)

      lcShortPath 	= Alltrim(Strtran(Left(lcBuffer, lnBufferSize), Chr(0), []))

      loProperties 	= Createobject([Properties])

      *Propiedades del objeto

      With loProperties

        .FileName   		= laDir[i,1]

        .FileSize    		= laDir[i,2]

        .DateLastModified  	= laDir[i,3]

        .TimeLastModified 	= laDir[i,4]

        .Fullpath		= lcFullPath

        .Extension		= Justext(lcFullPath)

        .Drive			= Justdrive(lcFullPath)

        .Stem			= Juststem(lcFullPath)

        .Fname			= Justfname(lcFullPath)

        .ShortPath		= lcShortPath

        .ShortName		= Justfname(lcShortPath)

        .IsHidden 		= Iif(At([H], laDir[i,5])>0,.T., .F.)

        .IsReadOnly		= Iif(At([R], laDir[i,5])>0,.T., .F.)

        .IsSystem		= Iif(At([S], laDir[i,5])>0,.T., .F.)

        .IsFolder		= Iif(At([D], laDir[i,5])>0,.T., .F.)

      Endwith

      This.Add(loProperties ,laDir[i,1])

    Endfor

  Endproc



  Procedure LoadGetShortPathName

    *API para obtener el nombre corto de un archivo

    Declare Integer GetShortPathName In Win32API ;

      string  @cLongPath, ;

      string  @cShortPathBuff, ;

      integer nBuffSize

  Endproc

Enddefine



*Objeto propiedades

Define Class Properties As Session

  FileName  		= []

  FileSize  		= 0

  DateLastModified  	= {}

  TimeLastModified 	= []

  Fullpath		= []

  Extension		= []

  Drive			= []

  Stem			= []

  Fname			= []

  ShortPath		= []

  ShortName		= []

  IsHidden 		= .F.

  IsReadOnly		= .F.

  IsSystem		= .F.

  IsFolder		= .F.

Enddefine
************************************************************************************************
Formularios Esta funcion permite controlar la apertura de formularios en una sola instancia.



****************

Function OpenForm

LPARAMETER cForm

LOCAL i, lOk



lOk = .F.



* recorro todos los forms abiertos...

FOR i = 1 TO _SCREEN.FormCount

  * consulto por la propiedad 'cFormName'...

  IF  PEMSTATUS(_SCREEN.Forms[m.i],'cFormName',5)

    IF _SCREEN.Forms[m.i].cFormName == cForm

      _SCREEN.Forms[m.i].Show()

      lOk = .T.

    ENDIF

  ENDIF

NEXT i

IF !lOk

  DO FORM (cForm) NAME _Form NOSHOW

  * si no tiene la propiedad 'cFormName' la creo

  IF  !PEMSTATUS(_SCREEN.Forms[m.i],'cFormName',5)

    _SCREEN.Forms[m.i].AddProperty('cFormName')

  ENDIF

  _Form.cFormName = cForm

  _Form.Show()

ENDIF



**
************************************************************************************************
 Amigos, humildemente, propongo una rutinita recursiva para recorrer un Arbol Treeview, no es gran cosa, pero por ahí a alguien le puede venir bien.

Serán bienvenidas las mejoras del caso.

*-------------------------------------------------------*

*- CASO 1 - Le paso como NODO el primer Hijo del Nodo en el que estoy

posicionado.

*- En este caso la rutina NO procesa el Nodo sobre el que estoy (LO

EXCLUYE).

o=thisform.otree

o.selecteditem

primerhijo=o.selecteditem.child)

ver_rama(primerhijo)

*-------------------------------------------------------*

*- CASO 2 - Le paso como NODO áquel en el que estoy posicionado.

*- En este caso la rutina SI procesa el Nodo sobre el que estoy (LO

INCLUYE).

o=thisform.otree

o.selecteditem

ver_rama2(o.selecteditem)

*-------------------------------------------------------*

PROCEDURE ver_rama(onodo)

*--- Pasandole el Primer Hijo del Nodo que me Interesa

LOCAL hnodo,next_nodo,t,nhijos



IF ISNULL(onodo)

   RETURN

ENDIF

MESSAGEBOX(onodo.text)

nhijos=onodo.children

IF nhijos>0

 hnodo=onodo.child

 ver_rama(hnodo)

endif

next_nodo=onodo.next

IF ISNULL(next_nodo)

   RETURN

ELSE

   ver_rama(next_nodo)

ENDIF

RETURN

*-------------------------------------------------------*

PROCEDURE ver_rama2(onodo)

*--- Pasandole el NODO, lo muestra a él y todo lo que cuelga de él

LOCAL hnodo,next_nodo,t,nhijos



IF ISNULL(onodo)

   RETURN

ENDIF

MESSAGEBOX(onodo.text)

nhijos=onodo.children

IF nhijos>0

 hnodo=onodo.child

 ver_rama(hnodo)

endif

RETURN

*-------------------------------------------------------*
************************************************************************************************
Averigua el estado de SET PRINTER TO, el dispositivo de salida de la impresora...


Esto puede ser hacia un fichero o hacia una impresora. La siguiente rutina devuelve el tipo de salida(Fichero o Impresora), el nombre de la impresora o del Fichero y el Puerto o Ruta.



******************************************************************************

* Obtener información sobre el dispositivo de impresión como la impresora y puerto o fichero y ruta.

*

* Función: 		INFO_IMPRE

* Propósito:		Averigua el estado de  SET PRINTER TO, el dispositivo de salida de la impresora, que

*				puede ser hacia un fichero o hacia una impresora. Devuelve el tipo de salida(Fichero o

*				Impresora), el nombre de la impresora o del Fichero y el Puerto o Ruta.

* Parámetros:	Necesita recibir un Array(Arreglo) pasado por referencia.

* Autor:		Víctor Brasó - alias: Balmes

* Fecha:		28/07/2003

*

******************************************************************************



* Ejemplo:

LOCAL aPTR



DIMENSION aPTR(1)



=INFO_IMPRE(@aPTR)

?aPTR(1)

?aPTR(2)

?aPTR(3)



**********************

FUNCTION INFO_IMPRE(aTMP)

LOCAL sDevice, sName, sPuerto_Ruta, aPRS, nH



	* Se inicializan las variables

	STORE "" TO sDevice, sName, sPuerto_Ruta	

	

	* Se comprueba si la salida de impresora es hacia un archivo...

	sDevice=SET("PRINTER",1)



	* Si NO es un fichero...

	IF EMPTY(sDevice) OR sDevice$".LPT1.LPT2.LPT3.LPT4" THEN

		sDevice="Impresora"	

		sName=SET( 'PRINTER',3 )		&& Nombre de la impresora predeterminada de VFP, si

										&& se desea la predeterminada de Windows, cambiar

										&& por SET( 'PRINTER',2 ).

		DIMENSION aPRS(1)

		* Se recoge la información de las impresoras instaladas y de los puertos a los que están conectadas...

		=APRINTERS(aPRS)

		*Se busca la impresora obtenida anteriormente...

		FOR nH=1 TO ALEN(aPRS,1)

			IF UPPER(aPRS(nH,1))==sName THEN

				sPuerto_Ruta="Puerto: "+aPRS(nH,2)

				EXIT

			ENDIF

		NEXT

	ELSE

		sName=JUSTFNAME( sDevice )					&& Nombre del Fichero

		sPuerto_Ruta="Ruta: "+JUSTPATH(  sDevice )	&& Ruta del Fichero

		sDevice="Fichero"

	ENDIF

	

	DIMENSION aTMP(3)

	aTMP(1)="Dispositivo: "+sDevice

	aTMP(2)="Nombre: "+sName

	aTMP(3)=sPuerto_Ruta

ENDFUNC
************************************************************************************************
API Para forzar la salida de Windows desde Visual FoxPro


FUNCTION APAGA( tlShutdownRequested, tlInteractiveShutdown )

*  Por defecto - Cierra todas las aplicaciones y reinicia Windows sin preguntar.

* Obtenida de UniversalThread

*  Parámetros:

*

*  tlShutdownRequested -   .T. Cierra Windows, .F. (default) Reinicia Windows

*  tlInteractiveShutdown - .T. Muestra el cuadro de diálogo para preguntar si cerramos Windows, .F. (default) No pregunta nada y cierra Windows



* Esta función permite cerrar o reiniciar Windows desde VFP;  hace las llamadas necesarias 

* a funciones API de Windows para ajustar los privilegios necesarios en las plataformas Windows NT 4.0 o Windows 2000

* si se puede. La función devuelve .F. si no puede hacer los ajustes necesarios para garantizar que el privilegio

* llamado SE_SHUTDOWN_NAME sea establecido. En Windows 9x no es necesario establecer este privilegio.

* Probado en las plataformas WinNT 4.0 SP6, Win2K Pro, Win98 y WinME.  

* Probado en  VFP 5.0, VFP 6.0 y VFP 7.0 SP1.

*



	*  Definición de constantes



	#DEFINE SE_SHUTDOWN_NAME "SeShutdownPrivilege"   && Nombre del privilegio de Windows NT y 2000

	#DEFINE SE_PRIVILEGE_ENABLED 2                   && Flag para activar privilegios

	#DEFINE TOKEN_QUERY 2                            && Token para consultar el estado

	#DEFINE TOKEN_ADJUST_PRIVILEGE 0x20              && Token para ajustar privilegios

	#DEFINE EWX_SHUTDOWN 1				&& Apagar Windows

	#DEFINE EWX_REBOOT 2                             && Reiniciar Windows

	#DEFINE EWX_FORCE 4                              && Forzar el cierre de las aplicaciones

	#DEFINE SIZEOFTOKENPRIVILEGE 16



	*  API de Windows para ejecutar ShutDown - Todas las versiones

	DECLARE ExitWindowsEx IN WIN32API INTEGER uFlags, INTEGER dwReserved && API call to shut down Windows



	*  Comprobamos la versión de Windows para saber si hay que establecer privilegios

	IF  ('4.0' $ OS() OR '5.0' $ OS() OR 'NT' $ OS())

	   *  APIs necesarias para manipular los permisos de los procesos

	   

	   *  Devuelve el LUID privilegio específico - changes each time Windows restarts

	   DECLARE SHORT LookupPrivilegeValue IN ADVAPI32 ;

	      INTEGER lpSystemName, ;

	      STRING @ lpPrivilegeName, ;

	      STRING @ pluid



	   *  Obtiene el hToken con los permisos de un proceso

	   DECLARE SHORT OpenProcessToken IN Win32API ;

	      INTEGER hProcess, ;

	      INTEGER dwDesiredAccess, ;

	      INTEGER @ TokenHandle

	   

	   *  Ajusta otros privilegios de un proceso vía un hToken específico

	   DECLARE INTEGER AdjustTokenPrivileges IN ADVAPI32 ;

	      INTEGER hToken, ;

	      INTEGER bDisableAllPrivileges, ;

	      STRING @ NewState, ;

	      INTEGER dwBufferLen, ;

	      INTEGER PreviousState, ;

	      INTEGER @ pReturnLength

	   

	   *  Obtiene el Handle de un proceso

	   DECLARE INTEGER GetCurrentProcess IN WIN32API



	   LOCAL cLUID, nhToken, cTokenPrivs, nFlag



	   cLUID = REPL(CHR(0),8)  && Identificador Unico Local de 64 bits de un privilegio



	   IF LookupPrivilegeValue(0, SE_SHUTDOWN_NAME, @cLUID) = 0

	      RETURN .F.  &&  Privilegio No definido en el proceso

	   ENDIF



	   nhToken = 0  &&  Token de un proceso usado para manipular los privilegios del mismo



	   IF OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY + TOKEN_ADJUST_PRIVILEGE , @nhToken) = 0

	      RETURN .F.  &&  El sistema operativo no puede garantizar los privilegios necesarios

	   ENDIF



	   *  Se crea la estructura TOKEN_PRIVILEGES , los 4 primeros bytes DWORD indican permisos,

	   *  seguidos de un  array(arreglo) de 8 bytes con los LUIDs y los últimos 4 bytes son los atributos

	   *  de los permisos.  

	   cTokenPrivs = CHR(1) + REPL(CHR(0),3) + cLUID + CHR(SE_PRIVILEGE_ENABLED) + REPL(CHR(0), 3)

	   IF AdjustTokenPrivileges(nhToken, 0, @cTokenPrivs, SIZEOFTOKENPRIVILEGE, 0, 0) = 0

	      RETURN .F.  && Privilegio denegado o no permitido

	   ENDIF

	ENDIF



	CLOSE ALL    &&  Cierra todas las tablas de VFP

	FLUSH        &&  Fuerza la escritura en disco de los Buffers

	CLEAR EVENTS &&  Cancela eventos pendientes

	ON SHUTDOWN  &&  Reestablece el proceso SHUTDOWN

	*  Se comprueban los parámetros pasados

	DO CASE

	CASE tlShutdownRequested AND tlInteractiveShutdown

	   nFlag = EWX_SHUTDOWN

	CASE tlShutdownRequested

	   nFlag = EWX_SHUTDOWN + EWX_FORCE

	CASE tlInteractiveShutdown

	   nFlag = EWX_REBOOT

	OTHERWISE

	   nFlag = EWX_REBOOT + EWX_FORCE

	ENDCASE

	=ExitWindowsEx(nFlag, 0)  && Fuerza el Cierre o Reinicio de Windows

	QUIT  &&  Sale de VFP

ENDFUNC
************************************************************************************************
Otra forma muy sencilla de enviar Email desde VFP es una el componente ASPEMAIL (www.aspemail.com).



Este te permite enviar correo de forma sencilla via SMTP y sin mayor inconvenientes.. y con muchas posibilidades (imagenes embebidas en los emails, encriptación, autenticación, muchos adjuntos)

El Host es dependiente del proveedor de Internet

Mail = CreateObject("Persits.MailSender")

Mail.ResetAll

Mail.Host = "prepago.celcaribe.net.co"

Mail.Port = 25

Mail.isHTML = .F.

Mail.From = "dav_amador@celcaribe.net.co"

Mail.AddAddress("davphantom@hotmail.com" , "Dpto de Software")

Mail.Subject = "Asunto del e-mail"

Mail.Body = 'Es es el mensaje que ha sido enviado'

Mail.AddAttachment(Getfile())

Mail.Send
************************************************************************************************
Artículos A partir de VFP8 ya puedes enlazar eventos en tiempo de ejecución, de que nos servirá esto?... Exploraremos algunos ejemplos prácticos.



PUBLIC oForm

oHandler = CREATEOBJECT("myHandler")

oForm = CREATEOBJECT("MyForm",oHandler)

oForm.Show()

DEFINE CLASS myForm as Form 

  Width = 400

  Height = 225

  ADD OBJECT myGrid as Grid WITH Width=400, HEIGHT=180, TOP=5

  ADD OBJECT myCmdButton AS CommandButton ;

          WITH Top=190, Left=40,Caption="Bind",;

               Height=30              

  PROCEDURE INIT

  LPARAMETERS toHandler

     This.AddProperty("oHandler",toHandler)

  ENDPROC                

  PROCEDURE LOAD

     OPEN DATABASE (HOME(2)+"DataTestData")

     USE customer 

  ENDPROC

  PROCEDURE UNLOAD

     USE IN "Customer"

     CLOSE DATABASES ALL

  ENDPROC

  PROCEDURE myCmdButton.Click

     Thisform.EnlazaEvento() 

  ENDPROC

  PROCEDURE EnlazaEvento      

  * Recorremos los Objetos contenidos en el Grid

  FOR EACH loObjects IN Thisform.myGrid.Objects       

    FOR EACH loControls IN loObjects.Controls

      DO CASE 

       CASE UPPER(loControls.BaseClass)="HEADER"

       ** Enlazamos el evento Doble Click de los Headers

       ** Hacia un metodo del objeto Handler                                  

          BINDEVENT(loControls,"DblClick",this.oHandler,"DobleClick")

       CASE UPPER(loControls.BaseClass)="TEXTBOX"

       ** Enlazamos el evento Doble Click de los textbox

       ** Hacia otro metodo del objeto Handler                                                                                              

          BINDEVENT(loControls,"DblClick",this.oHandler,"MuestraValor")   

       ENDCASE

    ENDFOR   

  ENDFOR      

  ENDPROC

ENDDEFINE

DEFINE CLASS myHandler as Custom

   PROCEDURE DobleClick

       AEVENTS(laEventos,0)

       MESSAGEBOX("Lllamado desde:"+laEventos[1].Parent.ControlSource)

   ENDPROC

   PROCEDURE MuestraValor

      AEVENTS(laEventos,0)

      MESSAGEBOX(EVALUATE(laEventos[1].ControlSource))

   ENDPROC

ENDDEFINE
************************************************************************************************
i deseas que se seleccione el Formulario para inicar a moverlo, puedes utilizar esta API



Declare integer SendMessage in "user32" ;

   Long hWnd,  Long wMsg, Long wParam, string lParam

#define SC_MOVE  61456

#define WM_SYSCOMMAND 274

=SendMessage(thisform.hWnd, WM_SYSCOMMAND, SC_MOVE, 0)
************************************************************************************************
Este código nos permite nos pover formulario agarrandolo por cualuier parte.


#define WM_LBUTTONUP 514

#define WM_SYSCOMMAND  274

#define SC_MOVE 61456

#define MOUSE_MOVE 61458

Declare integer SendMessage in "User32";

Long  hwnd, Long wMsg, Long wParam, Long lParam 

* Este código se pondrá en el control_MouseDown ...

PUBLIC lngRet As Long

* Envía un MouseUp al Control

=SendMessage(thisform.hWnd, WM_LBUTTONUP, 0, 0)

* Envía la orden de mover el form

= SendMessage(thisform.hWnd, WM_SYSCOMMAND, MOUSE_MOVE, 0)
************************************************************************************************
 Esta funcion permite seleccionar un valor desde una lista de valores indicando la posicion en que se encuentra.

Hace tiempo programaba en lenguajes (basic, cobol, pascal, etc) y hay ahi una funcion que hace esto y como creo que es muy util pues me hice la mia, a mi me ha ayudado mucho y ademas la uso en otras funciones que tengo creadas.


* Funcion .......:	SelOp
* Creada ........:	Junio 22, 2000 By Sukos
* Uso ...........:	Selecciona y devuelve un valor de acuerdo a un indice
* Llamada .......:	SelOp(,)
* Donde .........:		  = Valor del indice de busqueda
*						 = Lista de valores a buscar, Maximo 25, pueden ser de diversos tipos
* Ejemplo .......:	SelOp(4,1,"A",.T.,Date()) ----->  Regresa la fecha actual
*					SelOp(5,"Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic") ----->  Regresa "May"
* Notas .........:	Si se usa en un metodo de formularios, solamente convierte a comentario
*					la primera linea agregandole un "*" al inicio y la llamas con "Objeto.SelOp(,)"
* --------------------------------------------------------------------------------------------------------------------------
Function SelOP(Opcion,Pr1,Pr2,Pr3,Pr4,Pr5,Pr6,Pr7,Pr8,Pr9,Pr10,Pr11,Pr12,Pr13,Pr14,Pr15,Pr16,Pr17,Pr18,Pr19,Pr20,Pr22,Pr22,Pr23,Pr24,Pr25)
Local Resp,TipResp
TipResp=VarType(Pr1)
If Opcion>(PCount()-1).Or.Opcion>25.Or.Opcion<1
	If TipResp="C"
		Retu ""
	Else
		If TipResp="N"
			Retu 0
		Else
			Retu .F.
		EndIF
	EndIf
Else
	Resp="Pr"+Allt(Str(Opcion))
	Retu &Resp
EndIf


************************************************************************************************
ROTINA PARA BUSCA NO GOOGLE

clear
#DEFINE READYSTATE_COMPLETE 4
oIE = CreateObject("InternetExplorer.Application")

lcphone="(251) 602-5611"

lcURL="http://www.google.com/search?hl=en&lr=&ie=ISO-8859-1&q="+;
lcphone+;
"&btnG=Google+Search"

oIE.Navigate(lcURL)

do while oIE.Readystate <> READYSTATE_COMPLETE
wait wind time 1.0 ""
enddo

lcInnerText = oIE.Document.Body.InnerText
ln=occur(lcphone,lcInnerText)
if ln>=1
   =alines(aa,lcInnerText)
   for ia=1 to alen(aa)
      if lcphone$aa[ia] and aa[ia]#"Searched the web"
         ?aa[ia]
      endif
   endfor
else
   *NOT FOUND
endif


oIE.Quit
oIE=.NULL.
release oIE

************************************************************************************************
Deleting a Directory And SubDirectories How can you get the same functionality of DOS's DELTREE command in VFP?

oFSO = CREATEOBJECT('Scripting.FileSystemObject')
lcdir = GETDIR()
oFolder = oFSO.GetFolder(lcdir)
oFolder.Delete(.T.)

************************************************************************************************
Getting Data from Microsoft Access in VFP

How can I get data from an Access MDB in VFP?

store SQLSTRINGCONNECT(;
 'DBQ='+fullpath('accessfile.mdb')+';'+;
 'DefaultDir=c:\;'+;
 'Driver={Microsoft Access Driver (*.mdb)}');
 to gnConnHandle

? SQLEXEC( gnConnHandle, ;
 "SELECT * from Access_table_name","tempcurs")
=sqldisc(0)

************************************************************************************************
Determining a computer's IP Address

How can you get the IP address for the local computer?

loSock = CREATEOBJECT('MSWinsock.Winsock.1')
? loSock.LocalIP

************************************************************************************************
Este es un Ejemplo sencillo de como podemos inhabilitar el teclado y el mouse de una pc.



El ejemplo utiliza la API BlockInput, la cual al recibir como parametro un 1, bloqueara el teclado y al recibir 0 (cero) lo des-bloqueara.

en el ejemplo utilizo un timer para alternar cada 3 segundos, lo que habilitara 3 segundos el teclado y mouse, y lo dejara inactivo otros 3 segundos.

Puede Adaptarse para que busque en una tabla digamos y vea si tiene que activar/desactivar el teclado y el mouse. y tener en otra pc, un modulo que habilite/deshabilite por pc, en la tabla.


Public oFrm

oFrm=Newobject("Form_blk")

oFrm.Show

Return

Define Class Form_blk As Form

	Top = 0

	Left = 0

	Height = 96

	Width = 375

	DoCreate = .T.

	Caption = "Deshabilitando El Teclado y el Mouse."

	Name = "Form1"

	Add Object timer1 As Timer With ;

		Top = 48, ;

		Left = 324, ;

		autosize = .T.,;

		Interval = 3000, ;

		Name = "Timer1"

	Add Object label1 As Label With ;

		Caption = "Label1", ;

		Left = 204, ;

		Top = 60, ;

		autosize = .T.,;

		TabIndex = 2, ;

		Name = "Label1"

	Add Object text1 As TextBox With ;

		Height = 23, ;

		Left = 24, ;

		TabIndex = 1, ;

		Top = 12, ;

		Width = 336, ;

		Name = "Text1"

	Add Object label2 As Label With ;

		Caption = "Valor Pasado:", ;

		Left = 96, ;

		Top = 60, ;

		autosize = .T.,;

		Name = "Label2"

	Procedure Init

		Thisform.AddProperty('valor',0)

		Declare Long BlockInput In "user32" Integer nOpcion

	Endproc

	Procedure timer1.Timer

		With Thisform

			If .valor = 0

				.valor = 1

			Else

				.valor = 0

			Endif

			.label1.Caption = Alltrim(Str(.valor))

			BlockInput(.valor)

		Endwith

	Endproc

Enddefine
************************************************************************************************
uve que escribir una funcion similar a displaypath para usar en VFP6. Aunque formatea distinto, puede servir.


Function DisplayPath
*- JARSoft
*- Prg. Alberto Rodriguez (jarargentina@hotmail.com)
*- DisplayPath
*- Mostrar un path con un largo determinado (emulación de la funcion DisplayPath de
*- VFP7 (aunque esta función, siempre envia el largo deseado por la llamada, no así
*- la funcion original de vfp7 cuyo largo es incalculable porque formatea de modo
*- diferente.

Lparameters tcFilename, tnMaxLength
Local nCaraQuitar
tcFilename = lower(tcFilename)
If len(tcFilename) <= tnMaxLength
Return tcFilename
Endif
*- es mayor...
If len(tcFilename) < 7 or tnMaxLength < 6
Return left(tcFilename, tnMaxLength)
Endif
nCaraQuitar = len(tcFilename) - tnMaxLength + 3
Return ;
STUFF(tcFilename, 4, nCaraQuitar, '...') && Reemplazar, eliminar el resto.
Endfunc
************************************************************************************************
 ¿Quieres conocer toda la información de todas las unidades o drives instalados en tu sistema?

Bueno pues esta función relizada con WSH lo hace para ti.



Function WSHListDrives
	LOCAL loFSO, loDrivesCol, loDrive, ;
		llIsReadyDrive, lnDriveType, lcDriveType, lnWait
	loFSO = CREATEOBJECT('Scripting.FileSystemObject')

	loDrivesCol = loFSO.Drives

	? "El numero de drives en el sistema son: " + ALLTRIM(STR(loDrivesCol.Count))

	FOR EACH loDrive IN loDrivesCol
		? "Drive : " + loDrive.DriveLetter
		lnDriveType = loDrive.DriveType
		DO CASE
			CASE lnDriveType=1
				lcDriveType = [removible]
			CASE lnDriveType=2
				lcDriveType = [fijo]
			CASE lnDriveType=3
				lcDriveType = [network]
			CASE lnDriveType=4
				lcDriveType = [CD-ROM]
			CASE lnDriveType=5
				lcDriveType = [RAM-disk]
		ENDCASE
		? "El tipo de drive es: " + lcDriveType

		llIsReadyDrive = loDrive.IsReady
		? IIF( llIsReadyDrive=.T., [El Drive esta listo.],[El drive no esta listo.])

		IF llIsReadyDrive
			? "Espacio disponible: " + ALLTRIM(STR(loDrive.AvailableSpace)) + [ bytes.]
			? "Espacio Libre: "      + ALLTRIM(STR(loDrive.FreeSpace)) + [ bytes.]
			? "Tamaño total: "		 + ALLTRIM(STR(loDrive.TotalSize)) + [ bytes.]
			? "Ruta: "				 + loDrive.Path
			? "Nombre del volumen: " + loDrive.VolumeName
		ENDIF

		IF INLIST(lnDriveType,1,2,4) AND llIsReadyDrive
			? "Número de serie: "   + ALLTRIM(STR(loDrive.SerialNumber))
		ENDIF

		IF lnDriveType=3
			? "Nombre compartido: "   + loDrive.ShareName
		ELSE
			IF lnDriveType=2
				? "Nombre compartido: "   + RTRIM(LEFT(SYS(0),15))
			ENDIF
		ENDIF
		WAIT
		CLEAR
	NEXT
Endfunc


************************************************************************************************
 
Método para apagar servidores de Terminal Services
Enviado por: drogdon 
 
 
 El método normal para apagar un servidor no se recomienda para los servidores que están corriendo Terminal Services.

El método normal para apagar un servidor (el cual es Inicio | Apagar y hacer clic en la opción Apagar del menú) no se recomienda para los servidores que están corriendo Terminal Services (TS). 

Microsoft recomienda el usar la utilidad de línea-de-comando tsshutdn para apagar el servidor de TS. La utilidad tsshutdn te permite apagar TS de una manera controlada. Cuando inicias un apagado, notificas a todas las sesiones conectadas. Si tienes sesiones con archivos abiertos, el servidor les incitará a guardar los archivos. 

Para apagar un servidor de TS, teclea tsshutdn en la ventana de comandos. Esto iniciará una cuenta regresiva de 30 segundos para su cierre. Si necesitas cancelar el cierre, simplemente presiona [Ctrl]C. 
 

************************************************************************************************
Volver a unir las partes en el archivo original dividido con el programa partir.prg. enviado en el articulo anterior.


*- IMPORTANTE: compile y verifique este archivo antes de correr. Algunos caracteres
*- se pierden en el envio al portal. (no se porque causa) y el slash (alt 92)
*- desaparece. Eso ocasiona que el programa no funcione.

*- UnirArchivo_01.prg
*- JARSoft Argentina
*- Prog. Alberto Rodiriguez - jarargentina@hotmail.com
*- Ultima modificacion: Abr. 2003
*-
*- Unir las piezas de n bytes creados con partirarchivo_01.prg
*- Unir Devuelve .t. si tubo exito.
*-
*- ej. de uso:
*- lExito = unirarchivo_01('c:tmp', 'c:tmpRespaldos.zip', .t.)
*-
Lparameters tcOrigen, tcDestino, tlBorrarPartes

*- tcOrigen = es el directorio donde estan todas las partes, .001, .00n
*- tcDestino = archivos final con su path ej. c:final.zip (no puede ser 00n)
*- tlBorrarPartes = eliminar las partes luego de unir.

If PCOUNT() # 3 Or Vartype(tcDestino) # 'C' Or Vartype(tcOrigen) # 'C' Or ;
EMPTY(tcDestino) Or File(tcDestino) Or ;
!Directory(Justpath(tcDestino)) Or !Directory(tcOrigen)
Messagebox('Error de llamada. El directorio debe ser válido y el '+;
'archivo final no debe existir.',16,'')
Return .F.
Endif
If Val(Left(Version(4),2)) < 7
Messagebox('Debe modificar (y verificar) este programa para que corra en esta '+;
'version',16,'Version no soportada')
Return .F.
Endif

tcOrigen = Lower(Addbs(tcOrigen))

Local x, nAux1, nManFinal, nManAux, nBytesEscritos As Integer
Local cCadenaleida, cAux As String
Local lOk, lError As Boolean

*--------------------------------------------------------------------------
*- como el programa parte en extenciones de 00n no se permiten unir en
*- archivos con estas extenciones.
cAux = Justext(tcDestino)
If Len(cAux) = 3 && si es # 3 no hay problema, pueden convivir.
For x = 1 To Len(cAux)
If !Isdigit(Substr(cAux, x, 1))
lOk = .T.
Exit
Endif
NEXT
ELSE
lOk = .T.
Endif
*- continuar si la extencion no tiene solo numeros.
If !lOk
Messagebox('No se permiten unir archivos con extenciones que puedan ser iguales '+;
'a las partes.',16,'Excepción')
Return .f.
Endif
*--------------------------------------------------------------------------

*- buscar todos los archivos
nAux1 = 0 && nro de archivo extencion
cAux = Sys(2000, tcOrigen+Juststem(tcDestino)+'.'+Transform(nAux1+1,@L 999'))
Do While !Empty(cAux)
nAux1 = nAux1 + 1
Dimension aFilesPartes[nAux1]
aFilesPartes[nAux1] = Lower(cAux)
cAux = Sys(2000, tcOrigen+Juststem(tcDestino)+'.'+Transform(nAux1+1,@L 999'))
Enddo
If nAux1 < 2 && no pueden ser menos de dos
Messagebox('No se pueden encontrar los archivos',16,'')
Return .F.
Endif

*- crear destino
nManFinal = Fcreate(tcDestino,0)
If nManFinal < 0
Messagebox('No se puede crear '+tcDestino,16,'')
Return .F.
Endif

For x=1 To Alen(aFilesPartes,1)
If Empty(aFilesPartes[x]) Or !File(tcOrigen + aFilesPartes[x])
lError = .T.
Exit
Endif
nManAux = Fopen(tcOrigen + aFilesPartes[x],0)
If nManAux < 0
Messagebox('No se puede abrir '+tcOrigen + aFilesPartes[x],16,'')
lError = .T.
Exit
Endif
Do While !Feof(nManAux)
cCadenaleida = Fread(nManAux, 10240)
nBytesEscritos = Fwrite(nManFinal, cCadenaleida) && escribir lo real leido
Enddo
=Fclose(nManAux)
If tlBorrarPartes
Erase (tcOrigen + aFilesPartes[x]) recycle
Endif
Next
=Fclose(nManFinal)
Release aFilesPartes
*- JARSoft _ Argentina
Return !lError
*- Este programa vuelve a unir las partes creando el archivo original,
*- partido con el programa: partirarchivo_01.prg
************************************************************************************************
La siguiente función permite copiar un archivo a una carpeta específica vía WSH:

*-- Forma de uso:
*-- WSHCopyFile( "A:/magno319.pdf", "d:/pdfs/" )

*--Copiar archivos a una carpeta específica con WSH



Function WSHCopyFile(FilePath,FolderPath)

	Local loFSO as object

	Local lcDrive as object

	Local loDrive as object

	Local ldFSO as object

	Local ldDrive as object

	Local ldDrive as object

	Local oldError as String

	Local lError as Bool

	*-- Preservamos rutina de errores

	OldError=ON("ERROR")



	loFSO = CREATEOBJECT('Scripting.FileSystemObject')

	lcDrive = loFSO.GetDriveName(FilePath)

	loDrive = loFSO.GetDrive(lcDrive)

	If loDrive.IsReady

		*-- Comprobamos el destino

		ldDrive = loFSO.GetDriveName(FolderPath)

		ldDrive = loFSO.GetDrive(ldDrive)

		if ldDrive.IsReady

			lError=.F.

			on error lError=.T.

			loFSO.CopyFile( FilePath, FolderPath )

			if lError Then

				Messagebox('Error al copiar el archivo, revise sus parámetros'0+32,'error')

			endif

			*--Restauro rutina de errores

			On error &OldError

		Endif

	Endif

	RELEASE loFSO

Endfunc
************************************************************************************************
Bases de Datos No sabes que Versión de MS-SQLServer está ejecutandose?, deseas saber que Service Pack está instalado? aqui te decimos cómo saberlo.



Ha habido y considero seguirá habiendo una serie de virus que se aprovechan de las vulnerabilidades de este software de Microsoft, el último virus fue corregido por el SP3, tambien a veces algunas mejoras en el producto son introducidos (y quizás removidos) en diferentes versiones y service Packs, así que a veces es necesiario saber a que versión de SQLServer se está conectado para saber de la misma manera cuál fué su ultimo Service Pack instalado.

lcServerName = "MiServidor"

lnHandle =SQLStringConnect([server=]+lcServerName+[;driver={SQL Server};Trusted_Connection=Yes])

IF lnHandle > 0



lcQueryVersion=[SELECT 'SQL Server ' ]+;

                              [+ CAST(SERVERPROPERTY('productversion') AS VARCHAR) + ' - ' ]+;

                              [+ CAST(SERVERPROPERTY('productlevel') AS VARCHAR) + ' ('  ]+;

                              [+ CAST(SERVERPROPERTY('edition') AS VARCHAR) + ')']

   IF SQLEXEC(lnHandle,lcQueryVersion,"cRes") > 0

       Brow

   ELSE

       IF AERROR(laError) > 0

           Messagebox("No se pudo ejecutar la consulta"+chr(13)+;

                                "Causa:"+laError[2],16,"Error Msg")

       ENDIF

   ENDIF

   SQLDISCONNECT(lnHandle)

ELSE

   IF AERROR(laError) > 0

       Messagebox("No se pudo ejecutar la consulta"+chr(13)+;

                            "Causa:"+laError[2],16,"Error Msg")

   ENDIF

ENDIF



Las difentes cadenas resultantes pueden ser algunas de las siguientes :




Producto Versión
RTM (Ready To Manufacture). 2000.80.194
SQL Server 2000 SP1 2000.80.384
SQL Server 2000 SP2 2000.80.534
SQL Server 2000 SP3 2000.80.760


************************************************************************************************
Este ejemplo nos Permite Ver como Limitar el area en la que se puede mover el mouse.

En este caso solo el Area de La Ventana, Podemos especificar el Caption de Otra ventana (Sea o no
de VFP) y limitar al area de esa ventana el movimiento del mouse.

La Funcion que Se Encarga de eso es "Encerrar", la cual necesita 3 Parametros El Titulo de la Ventana de la que se tomara el Area para limitar, el Segundo parametro es Si Quiere Usar La Barra de titulo (si es .f., no podra mover el mouse sobre la barra de titulo)
El 3er. Parametro indica Si la Ventana Tiene Menu, Aplica igual que la Barra de Titulo.

Numd2Word
Este Procedimiento Permite emular una Estructura, (necesaria para "Encerrar").

nRepEstru
Nos Permite Obtener el Valor de un elemento de la estructura, devuelta por alguna API,
o bien creada con Numd2Word (necesaria para "Encerrar").

Public oFrm_Limitar

oFrm_Limitar=Newobject("Frm_Limitar")

oFrm_Limitar.Show

Return



Define Class Frm_Limitar As Form

	Height = 144

	Width = 456

	ShowWindow = 2

	DoCreate = .T.

	AutoCenter = .T.

	Caption = "Limitando el Mouse"

	Name = "Frm_Limitar"

	Add Object chkbarra As Checkbox With ;

		Top = 48, ;

		Left = 127, ;

		AutoSize = .T., ;

		BackStyle = 0, ;

		Caption = "Agregar Barra de Titulo", ;

		Value = .F., ;

		Name = "chkBarra"

	Add Object Liberar As CommandButton With ;

		Autosize=.T.,;

		Top = 74, ;

		Left = 250, ;

		Caption = "Liberar", ;

		Name = "Liberar"

	Add Object ctitulo As TextBox With ;

		Height = 23, ;

		Left = 129, ;

		Top = 22, ;

		Width = 294, ;

		Name = "cTitulo"

	Add Object label1 As Label With ;

		AutoSize = .T., ;

		BackStyle = 0, ;

		Caption = "Titulo de la Ventana", ;

		Left = 12, ;

		Top = 24, ;

		Name = "Label1"

	Add Object Limitar As CommandButton With ;

		autosize = .T.,;

		Top = 74, ;

		Left = 130, ;

		Caption = "Limitar", ;

		Name = "Limitar"

	Add Object chkmenu As Checkbox With ;

		Top = 48, ;

		Left = 312, ;

		AutoSize = .T., ;

		BackStyle = 0, ;

		Caption = "Tiene Menu", ;

		Value = .F., ;

		Name = "chkMenu"



	Procedure nRepEstru

	Lparameters cEstructura, nValor

		Local cCadena, nEmp

		nEmp=((nValor-1)*4)+1

		cCadena = Substr(cEstructura,nEmp,4)

		Return  (Asc(Substr(cCadena, 1,1)) +;

			BitLShift(Asc(Substr(cCadena, 2,1)),  8)+;

			BitLShift(Asc(Substr(cCadena, 3,1)), 16)+;

			BitLShift(Asc(Substr(cCadena, 4,1)), 24))

	Endproc

	Procedure Numd2Word

	Lparameter nNumero

		Local c0,c1,c2,c3

		cResultado= Chr(0)+Chr(0)+Chr(0)+Chr(0)

		If nNumero < (2^31 - 1) then

			c3 = Chr(Int(nNumero/(256^3)))

			nNumero = Mod(nNumero,256^3)

			c2 = Chr(Int(nNumero/(256^2)))

			nNumero = Mod(nNumero,256^2)

			c1 = Chr(Int(nNumero/256))

			c0 = Chr(Mod(nNumero,256))

			cResultado= c0+c1+c2+c3

		Endif

		Return cResultado

	Endproc

	Procedure Encerrar

	Lparameters ctitulo,lBarra, lMenu

		Local cRect, cArea, nEspacio, nHandle

		nHandle=FindWindow(.Null.,ctitulo)

		If nHandle =0

			Return .F.

		Endif

		nEspacio=0

		BringWindowToTop(nHandle)

		cRect = Replicate(Chr(0),16)

		With This

			GetClientRect(nHandle, @cRect)

			If lBarra

				nEspacio=Sysmetric(9)+Iif(lMenu,Sysmetric(20),0)

				cRect=.Numd2Word(.nRepEstru(cRect,1))+.Numd2Word(.nRepEstru(cRect,2))+;

					.Numd2Word(.nRepEstru(cRect,3))+.Numd2Word(.nRepEstru(cRect,4)+nEspacio)

			Else

				nEspacio =Iif(lMenu,Sysmetric(20),0)

			Endif

			cArea= Substr(cRect,1,8)

			ClientToScreen(nHandle, @cArea)

			OffsetRect(@cRect, .nRepEstru(cArea,1), .nRepEstru(cArea,2)-nEspacio)

			ClipCursor(cRect)

		Endwith

		Return .T.

	Endproc

	Procedure Unload

		ClipCursor(0)

	Endproc

	Procedure Moved

		Thisform.Encerrar(Alltrim(Thisform.Caption),Thisform.chkbarra.Value, Thisform.chkmenu.Value)

	Endproc

	Procedure Resize

		Thisform.Encerrar(Alltrim(Thisform.Caption),Thisform.chkbarra.Value, Thisform.chkmenu.Value)

	Endproc

	Procedure Init

		Declare ClipCursor In User32 String @cRect

		Declare GetClientRect In user32 Long nHand, String @cRect

		Declare ClientToScreen In user32 Long nHand, String @cPuntero

		Declare OffsetRect In User32 String @cRect, Long nX, Long nY

		Declare Long FindWindow In User32 String cClase, String cCaption

		Declare Long BringWindowToTop In User32 Long nHandle

	Endproc

	Procedure Liberar.Click

		ClipCursor(0)

	Endproc

	Procedure ctitulo.Init

		This.Value= Thisform.Caption

	Endproc

	Procedure Limitar.Click

		Thisform.Encerrar(Alltrim(Thisform.ctitulo.Value),Thisform.chkbarra.Value, Thisform.chkmenu.Value)

	Endproc

Enddefine
************************************************************************************************
Con el FileSystem es posible crear archivos de texto de una manera fácil.



En la siguiente función muestro la manera de hacerlo



Function CreaArchivoTexto()

	Local fso, tf

	fso = CreateObject("Scripting.FileSystemObject")

	tf = fso.CreateTextFile("c:mitexto.txt", .T.)

	*'Escribir una nueva línea.

	tf.WriteLine("Probando 1, 2, 3.")

	* Escribir tres líneas en blanco.

	tf.WriteBlankLines(3)

	* Escribir una nueva línea.

	tf.Write ("Esto es una prueba.")

	tf.Close

Endfunc
************************************************************************************************
 Por Medio de este codigo podemos saber el Handle de la ventana que estamos usando, y su titulo, muy util, si queremos loguear los nombres de las aplicaciones que el usuario uso. o bloquear el acceso a alguna Aplicacion en Especifico.



Public oForm

oForm=Newobject("Info_Ventana")

oForm.Show

Return



Define Class Info_Ventana As Form

	Top = 0

	Left = 0

	Height = 110

	Width = 460

	ShowWindow = 2

	DoCreate = .T.

	BorderStyle = 1

	Caption = "Obteniendo Informacion de otras ventanas"

	HalfHeightCaption = .T.

	MaxButton = .F.

	MinButton = .F.

	AlwaysOnTop = .T.

	Name = "Form1"



	Add Object timer1 As Timer With ;

		Top = 0, ;

		Left = 0, ;

		Interval = 500, ;

		Name = "Timer1"

	Add Object nhandle As TextBox With ;

		Left = 68, ;

		Top = 2, ;

		Width = 388, ;

		Name = "nHandle"

	Add Object ctitulo As TextBox With ;

		Left = 68, ;

		Top = 24, ;

		Width = 388, ;

		Name = "cTitulo"

	Add Object label1 As Label With ;

		Caption = "Handle", ;

		Left = 12, ;

		Top = 4, ;

		Name = "Label1"

	Add Object label2 As Label With ;

		Caption = "Caption", ;

		Left = 12, ;

		Top = 27, ;

		Name = "Label2"

	Add Object mas As CommandButton With ;

		Top = 48, ;

		Left = 432, ;

		Height = 12, ;

		Width = 24, ;

		Caption = ">>", ;

		Name = "Mas"

	FontBold = .T.

	Add Object nizquierda As TextBox With ;

		Left = 66, ;

		Top = 60, ;

		Width = 120, ;

		Name = "nIzquierda"

	Add Object nderecha As TextBox With ;

		Left = 66, ;

		Top = 82, ;

		Width = 120, ;

		Name = "nDerecha"

	Add Object narriba As TextBox With ;

		Left = 284, ;

		Top = 61, ;

		Width = 120, ;

		Name = "nArriba"

	Add Object nabajo As TextBox With ;

		Left = 284, ;

		Top = 83, ;

		Width = 120, ;

		Name = "nAbajo"

	Add Object label3 As Label With ;

		Caption = "Izquierda", ;

		Left = 7, ;

		Top = 66, ;

		Name = "Label3"

	Add Object label4 As Label With ;

		Caption = "Derecha", ;

		Left = 6, ;

		Top = 84, ;

		Name = "Label4"

	Add Object label5 As Label With ;

		Caption = "Arriba", ;

		Left = 204, ;

		Top = 65, ;

		Name = "Label5"

	Add Object label6 As Label With ;

		Caption = "Abajo", ;

		Left = 204, ;

		Top = 86, ;

		Name = "Label6"



	Procedure obt_valor

	Lparameters cEstructura, nValor

		Local cCadena, nEmp

		nEmp=((nValor-1)*4)+1

		cCadena = Substr(cEstructura,nEmp,4)

		Return  (Asc(Substr(cCadena, 1,1)) +;

			BitLShift(Asc(Substr(cCadena, 2,1)),  8)+;

			BitLShift(Asc(Substr(cCadena, 3,1)), 16)+;

			BitLShift(Asc(Substr(cCadena, 4,1)), 24))

	Endproc



	Procedure Load

		Declare Long GetForegroundWindow In "user32"

		Declare Long GetWindowText In "user32" Long handle, String @lpString, Long cch

		Declare Long GetWindowRect In "user32" Long nHand, String @cEstructura

		This.Height = 60

	Endproc



	Procedure timer1.Timer

		Local ctitulo, nhandle, cRect

		ctitulo =Space(255)

		cRect = Space(17)

		nhandle = GetForegroundWindow()

		GetWindowText(nhandle, @ctitulo, Len(ctitulo))

		GetWindowRect(nhandle,@cRect)

		With Thisform

			.ctitulo.Value = ctitulo

			.nhandle.Value = nhandle

			.nizquierda.Value = .obt_valor(cRect,1)

			.narriba.Value = .obt_valor(cRect,2)

			.nderecha.Value = .obt_valor(cRect,3)

			.nabajo.Value = .obt_valor(cRect,4)

		Endwith

	Endproc



	Procedure mas.Click

		If Thisform.Height = 60

			Thisform.Height = 110

			this.Caption = '<<'

		Else

			Thisform.Height = 60

			this.Caption = '>>'

		Endif

	Endproc

	

	Procedure Init

		this.SetAll('Autosize',.t.,'label')

		this.SetAll('backstyle',0,'label')

		this.SetAll('height',22,'textbox')

		this.BackColor =16441261

	EndProc 

Enddefine
************************************************************************************************
La rutina que a continuación les presento nos da la facilidad de saber si es que nuestra unidad existe, pasando como argumento la unidad como una sola letra o como prompt:

Ejemplos:

? "El drive especificado " + IIF(DriverExist('c'), "","no")+" existe."
? "La ruta especificada " + IIF(DriverExist('c:'), "","no")+" existe."



Function DriverExist(lcDriveOrPathExist)

	Local Result as logic



	loFSO = CREATEOBJECT('Scripting.FileSystemObject')

	Result=loFSO.DriveExists(lcDriveOrPathExist)

	RELEASE loFSO

	Return Result



Endfunc
************************************************************************************************
Este es un ejemplo de como podemos obtener por medio de apis estadistica de los paquetes icmp
enviados y recibidos en la maquina.




Public oFrm

oFrm=Newobject("ICMP_Data")

oFrm.Show

Return



Define Class ICMP_Data As Form

	Height = 280

	Width = 500

	Desktop = .T.

	DoCreate = .T.

	AutoCenter = .T.

	BorderStyle = 0

	Caption = "Estadisticas ICMP"

	ControlBox = .T.

	Closable = .T.

	MaxButton = .F.

	MinButton = .F.

	ClipControls = .F.

	AlwaysOnTop = .F.

	BackColor = Rgb(203,230,241)

	Name = "ICMP_Data"



	Add Object lst_datos As ListBox With ;

		ColumnCount = 3, ;

		ColumnWidths = "250,100,100", ;

		Height = 271, ;

		Left = 6, ;

		Sorted = .F., ;

		Top = 2, ;

		Width = 483, ;

		DisabledItemBackColor = Rgb(102,130,200), ;

		DisabledItemForeColor = Rgb(255,255,0), ;

		DisabledForeColor = Rgb(255,0,0), ;

		Name = "lst_datos"

	Add Object timer1 As Timer With ;

		Top = 36, ;

		Left = 408, ;

		Height = 23, ;

		Width = 23, ;

		Interval = 560, ;

		Name = "Timer1"



	Procedure Estadisticas()

		Local ICMP, nCiclo

		ICMP = Space((13*4*2)+1)

		If GetIcmpStatistics(@ICMP) = 0

			With Thisform.lst_datos

				For nCiclo = 1 To 13

					.AddListItem(Alltrim(Str(.Parent.nRepStruct(ICMP,nCiclo))),nCiclo+1,2)

					.AddListItem(Alltrim(Str(.Parent.nRepStruct(ICMP,nCiclo+13))),nCiclo+1,3)

				Endfor

			Endwith

		Else

			Wait Window "Error al Obtener las Estadisticas"

		Endif

	Endproc



	Procedure nRepStruct

		Lparameters cEstructura, nValor

		Local cCadena, nEmp

		nEmp=((nValor-1)*4)+1

		cCadena = Substr(cEstructura,nEmp,4)

		Return  (Asc(Substr(cCadena, 1,1)) +;

			BitLShift(Asc(Substr(cCadena, 2,1)),  8)+;

			BitLShift(Asc(Substr(cCadena, 3,1)), 16)+;

			BitLShift(Asc(Substr(cCadena, 4,1)), 24))

	Endproc



	Procedure Load

		Declare Long GetIcmpStatistics In "iphlpapi" String @cEstructura

	Endproc



	Procedure lst_datos.Init

		With This

			.Clear()

			.AddListItem('Parametros',1,1)

			.AddListItem('Recibidos',1,2)

			.AddListItem('Enviados',1,3)

			.AddListItem('Mensajes',2,1)

			.AddListItem('Errores',3,1)

			.AddListItem('Destino inaccesible',4,1)

			.AddListItem('Tiempo agotado',5,1)

			.AddListItem('Problema de Parametros',6,1)

			.AddListItem('Paquetes de control de flujo',7,1)

			.AddListItem('Redirecciones',8,1)

			.AddListItem('Echos',9,1)

			.AddListItem('Respuestas de Eco',10,1)

			.AddListItem('Fechas',11,1)

			.AddListItem('Respuestas de fecha',12,1)

			.AddListItem('Máscaras de direcciones',13,1)

			.AddListItem('Máscaras de direcciones respondidas',14,1)

		Endwith

		Thisform.Estadisticas()

	Endproc



	Procedure timer1.Timer

		Thisform.Estadisticas()

	Endproc

Enddefine
************************************************************************************************
 Partir un archivo en n bytes con fox. Esto es parte de utilidades de backups. (Les envio el programa para volver a unir las piezas en la proxima noticia)


*- JARSoft Argentina
*- Prog. Alberto Rodiriguez - jarargentina@hotmail.com
*- Ultima modificacion: Abr. 2003
*-
*- Partir el archivo en piezas de n bytes
*- ADVERTENCIA.!! todos los archivos de extencion nnn de tcDestino se eliminan.!!
*-
Lparameters tcArchivo, tnBytes, tcDestino
*- Devuelve el nro de pedazos en que se partio el archivo o cero
*- si no se pudo completar la operacion o -1 si hubo algun error.

*- Ej. de uso:
*- nPedazos = partirarchivo_01('c:tmpRespaldos.zip', 1457664, 'c:tmp')
*- Este ejemplo divide respaldos.zip en 1.40 Mg para que las partes quepan en
*- disquetes y las pone en c:tmp



If PCOUNT() # 3 Or Vartype(tcArchivo) # 'C' Or Vartype(tnBytes) # 'N' Or ;

		tnBytes < 1 Or Vartype(tcDestino) # 'C' Or !Directory(tcDestino)

	Messagebox('Error de llamada.',16,'')

	Return -1

Endif



If Val(Left(Version(4),2)) < 7

	Messagebox('Debe modificar (y verificar) este programa para que corra en esta '+;

		'version',16,'Version no soportada')

	Return -1

Endif



tcDestino = Lower(Addbs(tcDestino))



Local x, nDevolver, nTamanio, nBytesEscritos, nMan, nManParte, nNroDisco As Integer

Local cAux, cCadenaleida, cAntesSafe, cFlog As String

Local lOk As Boolean



*--------------------------------------------------------------------------

*- como el programa parte en extenciones de 00n no se permiten partir

*- archivos con estas extenciones.

cAux = Justext(tcArchivo)

If Len(cAux) = 3		&& si es # 3 no hay problema, pueden convivir.

	For x = 1 To Len(cAux)

		If !Isdigit(Substr(cAux, x, 1))

			lOk = .T.

			Exit

		Endif

	NEXT

ELSE

	lOk = .T.

Endif

*- continuar si la extencion no tiene solo numeros.

If !lOk

	Messagebox('No se permiten partir archivos con extenciones iguales a las '+;

		'que se usará en las partes.',16,'Excepción')

	Return -1

Endif

*--------------------------------------------------------------------------



cFlog = Sys(3)+'.log'



cAntesSafe = Set("Safety")

nDevolver = 0

If !File(tcArchivo)

	Messagebox(tcArchivo+' no existe.',16,'No existe el archivo')

	Return -1

Endif

tcArchivo = Lower(Locfile(tcArchivo))

*- verificar que el tamaño sea mayor que tnBytes

If Adir(aInfoFilePartir1, tcArchivo)#1

	Return -1

Endif

nTamanio = aInfoFilePartir1[1,2]		&& tamaño total del archivo a partir

If nTamanio <= tnBytes

	Messagebox('No se puede partir en menos de 2 partes',16,'Parámetros incorrectos')

	Return -1

Endif



Set Safety Off

If !Empty(Sys(2000, tcDestino + Juststem(tcArchivo)+'.*'))

	*- hay que consultar asi y no erase dir*.*, porque el archivo original

	*- (de igual nombre y con otra extencion podria encontrarse en el mismo

	*- directorio destino)

	For x=0 To 999

		cAux = tcDestino + Juststem(tcArchivo)+'.'+Transform(x,@L 999')

		If File(cAux)

			Erase (cAux) recycle

		Endif

	Next

Endif



*- partir el archivo original:

nNroDisco = 1

nMan = Fopen(tcArchivo)

If nMan < 0

	Messagebox('No se puede abrir '+tcArchivo,16,'Operación cancelada')

	Return -1

Endif



Do While nTamanio > 0

	If nNroDisco > 999

		nDevolver = -1

		Messagebox('Demasiados archivos',16,'')

		Exit

	Endif



	cFileDestino = tcDestino + ;

		Forceext(Justfname(tcArchivo), Transform(nNroDisco, @L 999'))

	nManParte = Fcreate(cFileDestino)

	If nManParte < 0

		nDevolver = -1

		Messagebox('No se puede crear '+cFileDestino,16,'Operación cancelada')

		Exit

	Endif



	nEspacio = tnBytes

	Do While nEspacio > 0 And nTamanio > 0

		cCadenaleida = Fread(nMan, Min(10240, nEspacio))

		nBytesEscritos = Fwrite(nManParte, cCadenaleida)	&& escribir lo real leido

		If nBytesEscritos = 0

			nDevolver = -1

			Messagebox('No se puede escribir',16,'Operación cancelada')

			Exit

		Endif



		nEspacio = nEspacio - nBytesEscritos

		nTamanio = nTamanio - nBytesEscritos

	Enddo



	Fclose(nManParte)

	nDevolver = nNroDisco

	If nTamanio <= 0

		Exit

	Endif

	nNroDisco = nNroDisco + 1

Enddo

Fclose(nMan)

*- fin partir



Release aInfoFilePartir1

Set Safety &cAntesSafe



Return nDevolver

*- Par volver a unir las partes en el archivo original,

*- usar: unirarchivo_01.prg

*- JARSoft Argentina


************************************************************************************************
Este codigo nos permitira mostrar las dll's que han sido cargadas por nuestro programa, ya sea
directa o indirectamente, por ejemplo si declaramos una funcion contenida en una Dll
esta dll sera cargada por nuestro programa,



Public oForm

oForm=Newobject("Lst_Dep")

oForm.Show

Return



Define Class Lst_Dep As Form

	Autocenter = .t.

	Height = 204

	Width = 702

	DoCreate = .T.

	Caption = "Dependecias"

	Name = "Frm_Lst_Dep"



	Add Object command1 As CommandButton With ;

		Top = 173, ;

		Left = 554, ;

		Height = 27, ;

		Width = 144, ;

		Caption = "Listar Dependencias", ;

		Name = "Command1"

	Add Object list1 As ListBox With ;

		ColumnCount = 2, ;

		ColumnWidths = "120,510", ;

		RowSourceType = 1, ;

		RowSource = "", ;

		FirstElement = 1, ;

		Height = 169, ;

		Left = 0, ;

		NumberOfElements = 0, ;

		Top = 1, ;

		Width = 696, ;

		Name = "List1"



	Procedure num2dword

		Lparameter tnNum

		Local c0,c1,c2,c3

		lcresult = Chr(0)+Chr(0)+Chr(0)+Chr(0)

		If tnNum < (2^31 - 1) then

			c3 = Chr(Int(tnNum/(256^3)))

			tnNum = Mod(tnNum,256^3)

			c2 = Chr(Int(tnNum/(256^2)))

			tnNum = Mod(tnNum,256^2)

			c1 = Chr(Int(tnNum/256))

			c0 = Chr(Mod(tnNum,256))

			lcresult = c0+c1+c2+c3

		Endif

		Return lcresult

	Endproc

	Procedure Load

		Declare Long GetCurrentProcessId In "kernel32"

		Declare Long CreateToolhelp32Snapshot In "kernel32" Long lFlags, Long lProcessID

		Declare Long Module32First In "kernel32" Long hSnapshot, String @cProc

		Declare Long Module32Next In "kernel32" Long hSnapshot, String @cProc

	Endproc

	Procedure command1.Click

		Local cProc As String, nLogico As Long, cCadena As String

		cProc =Space(549)

		lProcessID = GetCurrentProcessId()

		hSnapshot = CreateToolhelp32Snapshot(8, 0)

		With Thisform

			.LockScreen = .t. 

			.list1.Clear()

			cProc = .num2dword(548)+.num2dword(0)+.num2dword(0)+;

				+.num2dword(0)+.num2dword(0)+.num2dword(0)+.num2dword(0)+;

				+.num2dword(0)+Space(256)+Space(260)

			nLogico = Module32First(hSnapshot, @cProc)

			cCadena =Space(255)

			nCiclo =0

			Do While nLogico <>0

				nCiclo = nCiclo +1

				cCadena=Substr(cProc,33,255)

				.list1.AddListItem(Substr(cCadena,1,At(Chr(0),cCadena)-1),nCiclo,1)

				cCadena=Substr(cProc,290,259)

				.list1.AddListItem(Substr(cCadena,1,At(Chr(0),cCadena)-1),nCiclo,2)

				nLogico = Module32Next(hSnapshot, @cProc)

			Enddo

			.Caption = "Total Encontrados: " +Alltrim(Str(nCiclo))

			.LockScreen = .F. 

		Endwith

	Endproc

Enddefine
************************************************************************************************
API Este ejemplo nos muestra como podemos saber por medio del handle de una ventana, obtenido
por API, si aun existe.


Pdriamos ejecutar la calculadora de Windows y hacer:

Declare Long  FindWindow in User32 String cClass, String cTitulo

nHandle=FindWindow(.null.,"Calculadora")

?ExisteV(nHandle)


Luego cerrar la ventana de la Calculadora de Windows, y ejecutar

?ExisteV(nHandle)



********************

*Ejemplos:

?ExisteV(_screen.HWnd )

?ExisteV(_vfp.HWnd )

?ExisteV(456464)

********************

Function ExisteV(nHandle)

Declare long IsWindow in "user32" long nHandle

	Return isWindow(nHandle) = 1

EndFunc 
************************************************************************************************
Este ejemplo muestra como averiguar si la maquina esta conectada a alguna red.



NETWORK_ALIVE_AOL = 0x4

NETWORK_ALIVE_LAN = 0x1

NETWORK_ALIVE_WAN = 0x2

Declare Long IsNetworkAlive In "SENSAPI.DLL" Long @lpdwFlags

Local nRet As Long

nRet = 0

IsNetworkAlive(@nRet)



If nRet = 0 Then

	Wait Window 'La Computadora no esta conectada a ninguna Red!'

	Return

Endif

If nRet =NETWORK_ALIVE_WAN

	Wait Window 'La Pc esta conectada a una Red Wan'

Endif

If nRet =NETWORK_ALIVE_AOL

	Wait Window 'La Pc esta conectada a una Red AOL'

Endif

If nRet =NETWORK_ALIVE_LAN

	Wait Window 'La Pc esta conectada a una Red Lan'

Endif
************************************************************************************************
 Este codigo permite Poner el texto que querramos en El Beton Inicio (en realidad se crea un boton con el texto indicado, sobre el boton del menu inicio)


WS_CHILD = 0x40000000

WM_LBUTTONDOWN = 0x201

WM_LBUTTONUP = 0x202

SW_HIDE = 0

SW_NORMAL = 1

Declare Long FindWindowEx in "user32" Long Handle, Long hWnd2, String lpsz1, String lpsz2 

Declare Long FindWindow in "user32" String lpClassName, String lpWindowName 

Declare Long ShowWindow in "user32" Long Handle, Long nCmdShow 

Declare Long GetWindowRect in "user32" Long Handle, String @lpRect 

Declare Long CreateWindowEx in "user32" Long dwExStyle, String lpClassName, String lpWindowName, Long dwStyle, Long x, ;

	Long y, Long nWidth, Long nHeight, Long hWndParent, Long  hMenu, Long hInstance, Integer lpParam 

Declare Long DestroyWindow in "user32" Long Handle

Declare Long GetWindowWord In "user32" Long HWnd, Long nIndex

Local tWnd As Long, bWnd As Long, ncWnd As Long

    Local cRect As String

    cRect= Space(40)

    tWnd = FindWindow("Shell_TrayWnd", .null.)

    bWnd = FindWindowEx(tWnd, 0, "BUTTON", .null.)

    GetWindowRect(bWnd, @cRect)

    hInst =GetWindowWord(_screen.HWnd,-6)

    ncWnd = CreateWindowEx(0, "BUTTON", "Salud!", WS_CHILD, 0, 0,;

    	(buf2dword(Substr(cRect,9,4)))-(buf2dword(Substr(cRect,1,4))),;

		(buf2dword(Substr(cRect,13,4)))-(buf2dword(Substr(cRect,5,4))),;

    	tWnd, 0, hInst , 0)

    ShowWindow(ncWnd, SW_NORMAL)

    ShowWindow(bWnd, SW_HIDE)

	local cMsg

	cMsg = Space(40)

	MessageBox("Click Aca Para Regresar el Boton Inicio")

    ShowWindow(bWnd, SW_NORMAL)

	?buf2dword(Substr(cmsg,5,4))

	DestroyWindow(ncWnd)



Function  buf2dword (lcBuffer)

Return Asc(Substr(lcBuffer, 1,1)) + ;

	Asc(Substr(lcBuffer, 2,1)) * 256 +;

	Asc(Substr(lcBuffer, 3,1)) * 65536 +;

	Asc(Substr(lcBuffer, 4,1)) * 16777216

Endfunc


************************************************************************************************
Este Ejemplo muestra como por medio de API como podemos obtener la Estadistica de los
datagramas UDP. 



Estas estadisticas las podemos obtener desde DOS de la siguiente manera:

netstat -e -p udp -s 5

Aca el codigo en VFP


Public oFrm_UDP
oFrm_UDP=Newobject("frm_udp")
oFrm_UDP.Show
Return

Define Class frm_udp As Form
	Top = 67
	Left = 286
	Height = 116
	Width = 276
	DoCreate = .T.
	Caption = "Estadistica de Datagramas UDP"
	Name = "Frm_UDP"

	Add Object timer1 As Timer With ;
		Top = 12, ;
		Left = 186, ;
		Height = 23, ;
		Width = 36, ;
		Interval = 500, ;
		Name = "Timer1"
	Add Object nrecibidos As TextBox With ;
		Alignment = 3, ;
		Value = 0, ;
		Height = 23, ;
		Left = 173, ;
		Top = 8, ;
		Width = 85, ;
		Name = "nRecibidos"
	Add Object label1 As Label With ;
		AutoSize = .T., ;
		BackStyle = 0, ;
		Caption = "Datagramas Recibidos", ;
		Height = 17, ;
		Left = 14, ;
		Top = 11, ;
		Width = 130, ;
		Name = "Label1"
	Add Object nenviados As TextBox With ;
		Alignment = 3, ;
		Value = 0, ;
		Height = 23, ;
		Left = 173, ;
		Top = 33, ;
		Width = 85, ;
		Name = "nEnviados"
	Add Object label2 As Label With ;
		AutoSize = .T., ;
		BackStyle = 0, ;
		Caption = "Datagramas Enviados", ;
		Height = 17, ;
		Left = 15, ;
		Top = 36, ;
		Width = 125, ;
		Name = "Label2"
	Add Object label3 As Label With ;
		AutoSize = .T., ;
		BackStyle = 0, ;
		Caption = "Errores", ;
		Height = 17, ;
		Left = 14, ;
		Top = 89, ;
		Width = 43, ;
		Name = "Label3"
	Add Object nerror As TextBox With ;
		Alignment = 3, ;
		Value = 0, ;
		Height = 23, ;
		Left = 173, ;
		Top = 83, ;
		Width = 85, ;
		Name = "nError"
	Add Object nsinpuerto As TextBox With ;
		Alignment = 3, ;
		Value = 0, ;
		Height = 23, ;
		Left = 173, ;
		Top = 58, ;
		Width = 85, ;
		Name = "nSinPuerto"
	Add Object label4 As Label With ;
		AutoSize = .T., ;
		BackStyle = 0, ;
		Caption = "Datagramas Sin Puerto", ;
		Height = 17, ;
		Left = 15, ;
		Top = 61, ;
		Width = 131, ;
		Name = "Label4"
	Procedure buf2dword
		Lparameters cBuffer
		Return Asc(Substr(cBuffer, 1,1)) +;
			BitLShift(Asc(Substr(cBuffer, 2,1)),  8)+;
			BitLShift(Asc(Substr(cBuffer, 3,1)), 16)+;
			BitLShift(Asc(Substr(cBuffer, 4,1)), 24)
		Endproc
	Procedure Load
		Declare Long GetUdpStatistics In "iphlpapi" String @cStats
	Endproc

	Procedure timer1.Timer
		cUDP =Space(21)
		If GetUdpStatistics(@cUDP) = 0
			With Thisform
				.nrecibidos.Value = .buf2dword(Substr(cUDP,1,4))
				.nenviados.Value  = .buf2dword(Substr(cUDP,13,4))
				.nerror.Value = .buf2dword(Substr(cUDP,9,4))
				.nsinpuerto.Value = .buf2dword(Substr(cUDP,5,4))
			Endwith
		Else
			Wait Window "No es Posible obtener Estadisticas UDP!"
		Endif
	Endproc
Enddefine

************************************************************************************************
 Con esta función, podrás conocer los datos de la unidad pasada como parámetro de texto, tales como espacio disponible, espacio libre y tamaño total.





Su forma de uso:



GetDrive([cunidad])



Ejemplo:



=GetDrive("c:")



Procedure GetDriver(cGetDriver)


	Local loFSO as object


	Local loDrive as object


	Local lnAvailableSpace as float


	Local lnFreeSpace as float


	Local lnTotalSize as float


	


	loFSO = CREATEOBJECT('Scripting.FileSystemObject')


	loDrive =loFSO.GetDrive(cGetDriver)


	


	lcDriveLetter = loDrive.DriveLetter


	lnAvailableSpace  = loDrive.AvailableSpace


	lnFreeSpace  = loDrive.FreeSpace


	lnTotalSize  = loDrive.TotalSize


	? "Drive "+IIF(!EMPTY(lcDriveLetter),lcDriveLetter," no es un recurso compatido")


	? lnAvailableSpace


	? lnFreeSpace


	? lnTotalSize


	RELEASE loFSO


Endfunc
************************************************************************************************
 Una función simple para generar contraseñas aleatorias.




*------------------------------------------------
* FUNCTION GenPass(tnLargo)
*------------------------------------------------
* Genera una contraseña aleatoria de longitud
* 'tnLargo' y conteniendo mayusculas, minusculas, 
* numeros y simbolos especiales
* PARAMETROS: tnLargo: largo de la contraseña
* RETORNA: Caracter
* USO: ? GenPass(15)
*------------------------------------------------
FUNCTION GenPass(tnLargo)

   IF EMPTY(tnLargo)
      tnLargo = 10
   ENDIF

   LOCAL ln, lc, lnI
   *-- Caracteres que contendra la clave generada
   #DEFINE CARACTERES "_0123456789ABCDEFGHYJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

   RAND(-1)
   ln = LEN(CARACTERES)
   lc = ""
   FOR lnI = 1 TO tnLargo
      lc = lc + SUBSTR(CARACTERES, INT(RAND() * ln ) + 1, 1)
   ENDFOR
   RETURN lc
ENDFUNC

*------------------------------------------------

************************************************************************************************
Siguiendo con los filesystem, aqui tienes la forma de crear un archivo de texto.

Function crearArchivo()
	Local fso, fldr
	fso = CreateObject("Scripting.FileSystemObject")
	fldr = fso.CreateTextFile("C:prueba.txt")
Endfunc

************************************************************************************************
Siguiendo con el tema de filesystem, aqui les presento la rutina para escribir en el registro.




Function EntradaReg
	loWSH = CREATEOBJECT("wscript.shell")
	loWSH.RegWrite("HKEY_CURRENT_USERSoftwarecesa","Autorizado")
	loWSH.RegWrite("HKEY_CURRENT_USERSoftwarecesadata","ESAPAH")
endfunc

************************************************************************************************
FUNCTION TiraAcento
Parameters cExpressao

cProcurarPor  = "ÁÉÍÓÚáéíóúÀÈÌÒÙàèìòùÂÊÎÔÛâêîôûÄËÏÖÜäëïöüÃÕãõÇçÑñº"
cSubstituirPor = "AEIOUaeiouAEIOUaeiouAEIOUaeiouAEIOUaeiouAOaoCcNno"

cExpressaoRetorno = CHRTRAN(cExpressao,cProcurarPor,cSubstituirPor)

RETURN(cExpressaoRetorno)

************************************************************************************************
Desabilitar item do combo/listbox

Coloque o caracter "\" antes dos valores da combo

************************************************************************************************
 Bueno, ya se ha visto en este foro como se hacen algunas tareas con las APIS, así que para no redundar yo colaboraré con algunas funciones para los filesystem.
La presente función borra una carpeta de la unidad especificada.



Function Borrarcarpeta()
	Local fso as object
	fso = CreateObject("Scripting.FileSystemObject")
	fldr = fso.DeleteFolder("C:borrame")
Endfunc

************************************************************************************************
 Esta función permite abrir el cuadro de diálogo conectar a unidad de red o impresora 


#DEFINE RESOURCETYPE_DISK 1
#DEFINE RESOURCETYPE_PRINT 2

Declare Integer WNetConnectionDialog In Win32Api;
Integer Handle, Integer ResourceType

Declare Integer FindWindow In Win32Api;
Integer Handle, String cTitle

*-- Para conectar a una unidad de red
WNetConnectionDialog(FindWindow(0,_Screen.Caption), RESOURCETYPE_DISK)

*-- Para conectar a una impresora
WNetConnectionDialog(FindWindow(0,_Screen.Caption), RESOURCETYPE_PRINT)


************************************************************************************************
Después de que un cliente me pidió crear una notificación de los eventos importantes del aplicativo decidí hacerla tipo Messenger incluyendo el sonido característico que este utiliza pues bien aquí les deje el código espero que les sea útil.

Antes de comenzar cambiamos la propiedad ShowWindow A 2 (Formulario de nivel superior)

Ahora declaramos la API que vamos a utilizar la colocamos en el evento Load del formulario:

DECLARE integer SetWindowPos IN "user32";
  integer hwnd, integer hWndInsertAfter,;  
  integer x,integer y,integer cx,integer cy,integer wFlags 

Si queremos darle un grado de transparencia declaramos estas.

Declare Integer SetWindowLong In "user32" ;
  Integer HWnd, Integer nIndex, Integer dwNewLong

Declare Integer SetLayeredWindowAttributes In "user32" ;
  Integer HWnd, Integer crey, ;
  Integer bAlpha, Integer dwFlags

Bueno ahora en el evento Init colocamos lo siguiente.

*- esto nos permitira abrir el formulario sin que nos afecte otra ventana.
=SetWindowPos(this.HWnd, -1, 0, 0, 0, 0, 1 + 2 )

*-- Con estas define el grado de transparencia del formulario
SetWindowLong(THISFORM.hWnd, -20, 0x00080000)
*-- Cambia el valor (200) para ajustar el nivel de transparencia. 
SetLayeredWindowAttributes(THISFORM.hWnd, 0, 200, 2) 

Bien ahora vamos a darle una pequeña animación.

En el evento Active del form colocamos lo siguiente.

*-- Ubico el formulario 
tleft = (_screen.Width -this.Width)
ttlef = (tleft + this.Width)
this.Move (ttlef,ttop,this.Width,this.Height)
FOR i = 1 TO tleft  && muevo el form 
  ttlef = ttlef - 1
  this.Move (ttlef,ttop,this.Width,this.Height)
  IF ttlef = tleft 
    EXIT 
  ENDIF  
ENDFOR

Ahora el sonido en el mismo evento.

lcWaveFile =""
*-- defino la ruta del sonido a emitir  
lcWaveFile = ruta + "Librerias\newemail.wav" 

DECLARE INTEGER PlaySound ;
  IN WINMM.dll  ;
  STRING cWave, ;
  INTEGER nModule, ;
  INTEGER nType

PlaySound(lcWaveFile,0,1)

Y listo ya tenemos nuestro mensaje tipo Messenger el diseño corre por cuenta de ustedes.
************************************************************************************************




 Este Ejemplo permite hacer Parpadear un Form de la misma manera que lo hace 
el Microsoft Messenger, cuando llega un nuevo mensaje, y no esta activa la ventana
en ese momento, y que para cuando se Activa.



*** Opciones De Parpadeo
#Define FlashW_Stop  0 &&Para el Parpadeo de una ventana.
#Define FlashW_Caption 0x1 &&Hace Parpadear El Titulo de Una Ventana
#Define FlashW_Tray  0x2 &&Hace Parpadear la Ventana en la TaskBar
#Define FlashW_All  3&&Parpadea El Titulo de la ventana y en la Taskbar
#Define FlashW_Timer  0x4 &&Parpadea Infinitamente, o hasta Enviar Un FlashW_Stop
#Define FlashW_TimerNoFg  0xC &&Parpadea hasta que Se Active la Ventana
*** Declaracion de Las Apis
Declare Long FlashWindowEx In "user32" String @CFlashWInfo
Declare Long FindWindow In User32 String cClass, String cCaption
*** Inicia El Codigo
Local cFlashInfo
cFlashInfo =Space(20)
*** Creamos La Estructura
cFlashInfo = Num2dWord(20)+; &&Longitud de la Estructura 
	Num2dWord(FindWindow(.Null.,'Calculadora'))+; &&Handle de la Ventana a "Flashear"
	Num2dWord(FlashW_All+FlashW_TimerNoFg)+; &&Opciones
	Num2dWord(5)+;  && Cantidad de Veces que Parpadeara (0 =Infinito)
	Num2dWord(0)  && Tiempo entre Parpadeo (en Milisegundos, 0=Default)
*** Hacemos Parpadear la Ventana. 
FlashWindowEx(@cFlashInfo)

Procedure Num2dWord
Lparameter tnNum
Local c0,c1,c2,c3
lcresult = Chr(0)+Chr(0)+Chr(0)+Chr(0)
If tnNum < (2^31 - 1) then
	c3 = Chr(Int(tnNum/(256^3)))
	tnNum = Mod(tnNum,256^3)
	c2 = Chr(Int(tnNum/(256^2)))
	tnNum = Mod(tnNum,256^2)
	c1 = Chr(Int(tnNum/256))
	c0 = Chr(Mod(tnNum,256))
	lcresult = c0+c1+c2+c3
Endif
Return lcresult
Endproc


************************************************************************************************
 Muchas veces desde el menu de nuestra aplicacion tenemos una instruccion como esta:

do Form Nombre_DelForm

con lo cual, si el usuario da 2 o 3 veces click en esa opcion, pues tenemos 2 o 3 forms iguales abiertos ...


... Esta función, permite evitar eso, si el form ya ha sido cargado lo mostrara, en lugar de cargarlo de nuevo. su uso es sencillo:

_form= Carga_Form("nombre_del_archivo")

Donde nombre_Del_archivo, es el nombre con el que hemos guardado nuestro form, no debe llevar ruta ni extension.
A su vez, tambien regresa una referencia al form, para poder modificarlo o establecer una propiedad al form una vez a sido cargado, luego de ejecutar _form= Carga_Form("nombre_del_archivo")
podriamos hacer _Form.caption='Prueba'

Aca esta el Codigo.


Function Carga_Form(cNombre)
	Local oForm
	Activate Screen
	If Type('&cNombre')<>'U' And Isnull(&cNombre)
		Release (cNombre)
	Endif
	If Type(cNombre)<>'O'
		Public (cNombre)
		Do Form (cNombre) Name (cNombre) Linked
	EndIf 
	oForm =Evaluate(cNombre)
	oForm.WindowState =0
	oForm.Show
	Return oForm
Endfunc

************************************************************************************************
Este Ejemplo nos muestra como podemos usar el fondo de windows, para fondo de nuestro Form, o bien, del _Screen.


Solo hay que indicar que cada vez que se cambie de tamaño o se redibuje, hay que decirle que vuelva a colocar el fondo.
esto podria hacerce desde el evento Resize.

Este es El Form de Muestra:

Public oFrm_Fondo
oFrm_Fondo=Newobject("oFrm_Fondo")
oFrm_Fondo.Show
Return

Define Class oFrm_Fondo As Form
	Top = 0
	Left = 0
	Height = 360
	Width = 606
	DoCreate = .T.
	Caption = "Usando el Fondo de Windows"
	Name = "oFrm_Fondo"
	Add Object command1 As CommandButton With ;
		Top = 144, ;
		Left = 84, ;
		Height = 27, ;
		Width = 84, ;
		Caption = "Command1", ;
		Name = "Command1"

	Procedure command1.Click
		Declare Long PaintDesktop In "user32" Long hdc
		Declare Long GetDC In "user32" Long Handle
		Local nRet As Long
		nRet= GetDC(Thisform.HWnd)
		=PaintDesktop(nRet)
		Thisform.SetAll("Visible",.T.)
	Endproc
Enddefine


y Este Ejemplo, es para el _Screen


Declare Long PaintDesktop in "user32" Long hdc 
Declare Long GetDC in "user32" Long Handle 
Local nRet as Long 
nRet= GetDC(_screen.HWnd)
=PaintDesktop(nRet)

************************************************************************************************
 Cuantas veces no hemos querido ingresar un registro en blanco en alguna posicion especifica de una tabla ?



Esta es una manera muy simple de hacerlo:


GO 3
INSERT BLANK BEFORE

************************************************************************************************
 Siempre nos ha inquietado las vistas preliminares de los informes en VFP, ya que estas tienen muy poco control con el teclado y se debe de recurrir al mouse (a la gran mayoria no nos gusta). 



Dando alguna que otra vueltas, ha salido la siguiente rutina. No es que sea la panacea universal, pero algo de control dá. 
A ver si entre todo la mejoramos un poco: 


SET RESOURCE OFF 
PUSH KEY 

DEFINE WINDOW wPreview FROM 0,0 TO 1,1; 
TITLE 'Vista preliminar' CLOSE SYSTEM NAME oPreview 
ZOOM WINDOW wPreview MAX 

ON KEY LABEL UPARROW; 
MOUSE CLICK AT 5,oPreview.Width-8; 
PIXELS WINDOW wPreview 

ON KEY LABEL DNARROW; 
MOUSE CLICK AT oPreview.Height-22,oPreview.Width-8; 
PIXELS WINDOW wPreview 

ON KEY LABEL LEFTARROW; 
MOUSE CLICK AT oPreview.Height-10,6; 
PIXELS WINDOW wPreview 

ON KEY LABEL RIGHTARROW; 
MOUSE CLICK AT oPreview.Height-10,oPreview.Width-22; 
PIXELS WINDOW wPreview 

ON KEY LABEL HOME; 
MOUSE DBLCLICK AT 18,oPreview.Width-8; 
PIXELS WINDOW wPreview 

ON KEY LABEL END; 
MOUSE DBLCLICK AT oPreview.Height-35,oPreview.Width-8; 
PIXELS WINDOW wPreview 

REPORT FORM (NombreInforme); 
TO PRINTER PROMPT PREVIEW WINDOW wPreview 

POP KEY 
SET RESOURCE ON 

************************************************************************************************
Esta funcion permite saber el tamaño de un archivo en especifico (en bytes), por medio de api.




#Define OF_READ  0x0
?GetInfoF("c:config.sys")
?? " Bytes"

Function GetInfoF(cFile)
	Declare Long _lopen In "kernel32" As lOpen String lpPathName, Long iReadWrite
	Declare Long _lclose In "kernel32" As lclose Long hFile
	Declare Long GetFileSize In "kernel32" Long hFile, Long @lpFileSizeHigh
	Local nArchivo As Long, nLongitud As Long
	Local lpMax As Long
	lpMax =1
	nArchivo= lOpen(cFile, OF_READ)
	nLongitud = GetFileSize(nArchivo, @lpMax )
	lclose(nArchivo)
	Return nLongitud
Endfunc

************************************************************************************************
Esta API NO documentada nos permite preguntar al usuario si desea cerrar la sesion
si el usuario responde si, se cerrara la sesion.



Declare Long FreeLibrary In "kernel32" Long hLibModule
Declare Long LoadLibrary In  "kernel32"  String lpLibFileName
Declare Long GetProcAddress In "kernel32" Long hModule, Long lpProcName
Declare Long CallWindowProc In "user32" Long lpPrevWndFunc, Long handle, String Msg , Long wParam, String Lparam
On Error ?''
Local lb As Long
Local pa As Long
lb = LoadLibrary("Shell32")
pa = GetProcAddress(lb, 60)
?CallWindowProc(pa+2, _Screen.HWnd, "Cerrar Sesion", 1, "0")
FreeLibrary(lb)
On Error 

************************************************************************************************
No todas las instalaciones del sistema operativo se hacen sobre la ruta C:/Windows, algunas veces cambia, ¿Necesita saber donde se instalo?, aqui mencionamos cómo hacerlo.

En mi caso particular yo tengo instalado mi Win2K en el directorio C:/WINNT, así pues, dicha ruta puede cambiar, por lo que a veces resulta necesario saber a ciencia cierta donde se instaló:


LOCAL oFso, oSpecialFolder
oFso = CREATEOBJECT("Scripting.FileSystemObject")
oSpecialFolder = oFso.GetSpecialFolder(0)
?oSpecialFolder.Path

************************************************************************************************
 Este ejemplo nos permite saber cuando cambia el valor de una clave dada en el registry.



Podemos ver de una clave en especifico y ver subclaves (como por ejemplo de HKEY_CURRENT_USER) 
o bien de una clave abierta con la api OpenKey

Ejecuten este codigo: (y luego de ejecutarlo, cambien el valor de la clave
HKEY_CURRENT_USERpaginaDireccion, una vez que cambie el valor de alguna clave alli,
el programa continuara y mostrara un msgbox, y el titulo del form se establecera al valor que
hallamos asignado a la clave en el registro. )


Public oForm
oForm=Newobject("Frm_Reg")
oForm.Show
Return

Define Class Frm_Reg As Form
	Top = 221
	Left = 60
	Height = 167
	Width = 465
	DoCreate = .T.
	Caption = "Frm_Reg"
	Name = "Frm_Reg"

	Procedure Load
		oWsh = Createobject("WScript.shell")
		owhs = oWsh.RegWrite("HKEY_CURRENT_USERpaginaDireccion","www.portalfox.com")
		Wait Window "Valor en: HKEY_CURRENT_USERpaginaDireccion "+oWsh.REGREAD("HKEY_CURRENT_USERpaginaDireccion") Nowait
		HKEY_CLASSES_ROOT = 0x80000000
		HKEY_CURRENT_USER = 0x80000001
		HKEY_LOCAL_MACHINE = 0x80000002
		HKEY_CURRENT_CONFIG = 0x80000005
		REG_NOTIFY_CHANGE_NAME = 0x1
		REG_NOTIFY_CHANGE_ATTRIBUTES = 0x2
		REG_NOTIFY_CHANGE_LAST_SET = 0x4
		REG_NOTIFY_CHANGE_SECURITY = 0x8
		REG_NOTIFY_ALL = (REG_NOTIFY_CHANGE_NAME +REG_NOTIFY_CHANGE_ATTRIBUTES +REG_NOTIFY_CHANGE_LAST_SET +REG_NOTIFY_CHANGE_SECURITY)
		Declare Long RegNotifyChangeKeyValue In "advapi32" Long hKey,Long bWatchSubtree, Long dwNotifyFilter, Long hEvent , Long fAsynchronous
		Declare Long RegOpenKey In "advapi32.dll" Long hKey, String lpSubKey, Long @phkResult
		Declare Long RegCloseKey In "advapi32.dll" Long hKey
		Local nClave As Long, otro As Long, nRet As Long
		nClave = 0
		nRet =RegOpenKey(HKEY_CURRENT_USER, "pagina",@nClave)
		RegNotifyChangeKeyValue(@nClave, 1, REG_NOTIFY_ALL , 0,0 )
		Messagebox("Registry changed")
		RegCloseKey(nClave)
		This.Caption = oWsh.REGREAD("HKEY_CURRENT_USERpaginaDireccion")
	Endproc
Enddefine


************************************************************************************************
 Cuantas veces usted a necesitado cambiar el código escrito en los métodos del dataenviroment de un reporte en tiempo de ejecución y el comando MODIFY REPORT no se lo permite.


Este es un pequeño ejemplo de cómo hacerlo en tiempo de Ejecución.


**JGS:21/03/2003
**Programa que permite la modificación del código interno de un reporte
**en tiempo de ejecución
Local ltemp_rep As String
ltemp_rep=Getfile('frx')
Use (ltemp_rep) Alias rep_temp In 0 Exclusive
Select rep_temp
Goto Top In rep_temp
Locate For objtype=25
If Found('rep_temp')
	Modify Memo rep_temp.Tag
	Use In rep_temp
	Compile Report <emp_rep
Endif
If Used('rep_temp')
	Use In rep_temp
Endif

************************************************************************************************
 Cansado de codificar largas y tediosas instrucciones INSERT para utilizarlas via SPT?, aquí te decimos como hacerlo un poco mas fácil. 


En dias pasado se comentaba en los foros de noticias de Microsoft, si se podría utilizar la cláusula FROM MEMVAR dentro de sentencias enviadas via SQL Pass Through (SPT): 

Select MiCursor
SCATTER MEMVAR
SQLExec(lnConnHandle,"INSERT INTO miTablaSQL FROM MEMVAR")




Esto no es posible, ya que nisiquiera el controlador ODBC de VFP da la posibilidad de hacerlo, ni hablar de cualquier otro cómo puede ser MS-SQL Server. 
Claro está, la vistas remotas podría ser la solución, pero puede que el requisito para resolver cierto problemas (como el tener cientos de tablas, lo que nos tendría cientos de vistas creadas y quizás despues no se usaran) no nos permite hacerlo. 
Por tal motivo propongo una idea para crear sentencias INSERT para ser enviadas via SPT. TextMerge puede ser una solución viable: 

FUNCTION CrearInsert(tcCursor, tcTabla)
   LOCAL lnFields,; && Numero de campos del cursor
         laFields,; && Arreglo con la estructura del cursor
         lcInsertQuery && Cadena que contendrá el INSERT
   DIMENSION laFields[1]
   lcInsertQuery=SPACE(0)
   **** Hacemos algunas validaciones ****
   **** Si no se incluye el nombre del cursor o de la tabla
   **** Se utilizará el ALIAS() en ambos casos

   tcCursor = IIF(TYPE('tcCursor')#'C' OR EMPTY(tcCursor),ALIAS(), tcCursor)
   tcTabla  = IIF(TYPE('tcTabla') #'C' OR EMPTY(tcTabla),tcCursor,tcTabla)
   
   **** Obtenemos la información del cursor 
   lnFields = AFIELDS(laFields,tcCursor)
   IF lnFields > 0 
      **** Creamos la instrucción INSERT(Campo,Campo2...CampoN) ****
      SET TEXTMERGE ON
      SET TEXTMERGE TO MEMVAR lcInsertQuery NOSHOW 
      INSERT INTO << tcTabla >>(
      FOR I=1 TO lnFields
         << laFields[i,1] >>,
      ENDFOR
      SET TEXTMERGE TO
      lcInsertQuery=SUBSTR(lcInsertQuery,1,LEN(lcInsertQuery)-1) + ')'

      **** Agregamos la cláusula VALUES(?Campo1, ?Campo2... ?CampoN) ****
      SET TEXTMERGE TO MEMVAR lcInsertQuery NOSHOW ADDITIVE
       VALUES (
      FOR I=1 TO lnFields
         ?<< tcCursor >>.<< laFields[i,1] >>,
      ENDFOR
      SET TEXTMERGE TO
      SET TEXTMERGE OFF
      lcInsertQuery=SUBSTR(lcInsertQuery,1,LEN(lcInsertQuery)-1)+ ')'
   ENDIF
   RETURN lcInsertQuery
ENDFUNC




Muy bien, ya tenemos la función ahora veremos un caso práctico en el cual utilizarlo. 
Supongamos que tenemos un numero indeterminado de tablas VFP cuyos registros serán insertadas al servidor de base de datos via SPT. Donde la tabla tiene la siguiente estructura: 

MiTabla (iID int, dFecha date, iClienteID int, iSeccionID int, yImporte Y) 


USE miTabla IN 0
lcInsert = CrearInsert("Mitabla","Ventas")




La cadena lcInsert contendrá lo siguiente: 

INSERT INTO Ventas( IID, DFECHA, ICLIENTEID, ISECCIONID, YIMPORTE) VALUES(?MiTabla.IID,?MiTabla.DFECHA,?MiTabla.ICLIENTEID,?MiTabla.ISECCION,?MiTabla.YIMPORTE) 

Ahora podemos utilizar esta instrucción para mandarla via SPT: 


USE MiTabla IN 0
lcInsert = CrearInsert("Mitabla","Ventas")
lcRegistros = trans( RECCOUNT("MiTabla"))
SCAN
    WAIT WINDOW "Insertando registro " + TRANS(recno())+ "/"+lcRegistros NOWAIT
    =SQLExec(lnConnHandle,lcInsert)
ENDSCAN
WAIT WINDOW "Proceso Finalizado"




Lo anterior es un ejemplo sencillo donde quizas pueda hacerse manualmente, pero imaginate si dicha tabla(s) tienen 50 campos, o incluso, se tienen 100 tablas? , 
aquí es donde este proceso de crear Insert via TEXTMERGE ayudará en demasía. Espero que este tip les sea de utilidad. 


************************************************************************************************
A veces puede resultarnos necesario una lista de servidores MS-SQLServer, igual a la que aparece cuando damos de alta un nuevo ODBC basado en este producto....

A continuación un código de cómo hacerlo.


LOCAL loSQLApp,; && Objeto SQLDMO
        loServer,     && Objeto con los servidores 
       lnCounter
loSQLApp = CreateObject('SQLDMO.Application')
loServers = loSQLApp.ListAvailableSQLServers()
For lnCounter = 1 TO loServers.Count
	? lnCounter, loServers.Item(lnCounter)
EndFor

************************************************************************************************
Esta Api, permite crear una propiedad a un form o al _screen por medio de su Handle (disponible a partir de VFP 7.0 +) y tambien podemos leer su valor, por otra api, o bien removerla.





Un dato interesante es que no es vista por el intellisense. y podemos crear una propiedad que ya exista,
y tener datos diferentes en cada propiedad



Declare Long GetProp In "user32" Long HWnd, String lpString
Declare Long SetProp In "user32" Long HWnd, String lpString, Long hData
Declare Long RemoveProp In "user32" Long HWnd, String lpString
SetProp(_Screen.HWnd, "Prueba", 123)
SetProp(_Screen.HWnd, "Hwnd", 111111)
_Screen.AddProperty('Prueba',321)
Wait Window  "Propiedad API:" + Str(GetProp(_Screen.HWnd, "Prueba"))
Wait Window  "Propiedad VFP:" + Str(_Screen.Prueba)
Wait Window  "Propiedad API (Handle):" + Str(GetProp(_Screen.HWnd, "Hwnd"))
Wait Window  "Propiedad VFP (Handle):" + Str(_Screen.HWnd)
RemoveProp(_Screen.HWnd, "Prueba")

************************************************************************************************
Si necesitas saber en que fecha fué creado un archivo o directorio, aquí explicamos cómo hacerlo.

VFP tiene incorporados algunas funciones sobre archivos, lamentablemente no posee internamente una manera de saber en que fecha fué creado un archivo (FDATE() nos devuelve la fecha de última modificación), por lo que usaremos el FileSystemObject para resolver este pequeño inconveniente. 


******************************************************************
* ---- Creation DateTime ----- Fecha y Hora de Creación
* ---- Author: Espartaco Palma Martinez esparta@NO_SPAMportalfox.com
* ---- FUNCTION: CreationDate
* ---- RETURNS: File or Directory Creation DateTime, if error returns:
* ----          -1 If no parameter of file or directory
* ----          -2 If the file doesn't exist
* ----          -3 If the Directory doesn't exist
* ---- RETORNA: Fecha y Hora de creación del archivo, en caso de error
* ----          -1 Si no se especifico el archivo o directorio (tcFileorDir)
* ----          -2 Si el archivo no existe
* ----          -3 Si el directorio no existe
* ---- PARAMETERS: tcFileOrDir - TYPE: Character, the File or Directory to 
* ----           get the creation Date.
* ----             tlIsDir - TYPE: Logical, .T. is parameter tcFileorDir is a directory
* ---- PARAMETROS: tcFileOrDir - TYPE: Caracter, ruta completa del archivo o directorio
* ----              a obtener la fecha
* ----             tlIsDir - TYPE: Logico, .T. si el parametro tcFileorDir es directorio
* ---- DATE: 16/Mar/2004 For Use in Visual FoxPro.
* ---- Sample/Ejemplo:
* ---- ltFecha = creationDate("C:/Windows/Win.ini")
* ---- ltFecha = creationDate("C:/Windows",.t.)
******************************************************************

FUNCTION CreationDate
LPARAMETER tcFileorDir,;
           tlIsDir

LOCAL loFso, ; 
      loFileorDir 

tlIsDir = IIF(VARTYPE(tlIsDir)#"L", .F.,tlIsDir)
IF VARTYPE(tcFileorDir)#"C" OR EMPTY(tcFileorDir)
   *** Falta Parámetro de Archivo o Directorio
   *** Needs File or Directory Parameter
   RETURN -1 
ENDIF   
loFso = CREATEOBJECT("Scripting.FileSystemObject")
IF !tlIsDir
   IF !FILE(tcFileorDir)
     *** Archivo no existe/File doesn't exist
     RETURN -2
   ENDIF
   loFileorDir = loFso.GetFile(tcFileorDir)
ELSE
   IF !DIRECTORY(tcFileorDir)
     *** No existe el directorio/Directory doesn't exist
     Return -3
   ENDIF
   loFileorDir = loFso.GetFolder(tcFileorDir)
ENDIF
  RETURN loFileorDir.DateCreated

************************************************************************************************
Otra forma de llamar la ventana de seleccion de colores mediante API.


DO DECL

#DEFINE CC_RGBINIT            1
#DEFINE CC_FULLOPEN           2
#DEFINE CC_PREVENTFULLOPEN    4
#DEFINE CC_SHOWHELP           8
#DEFINE CC_SOLIDCOLOR       128
#DEFINE CC_ANYCOLOR         256
#DEFINE CC_WIDE              32
#DEFINE CHOOSECOLOR_SIZE     36
#DEFINE COLORREF_ARRAY_SIZE  64

LOCAL hWindow, lcBuffer, lnInitColor, lnFlags, ;
   lnCustColors, lcCustColors, ii

hWindow = GetActiveWindow()
lnInitColor = RGB(128,0,0)

#DEFINE GMEM_FIXED  0
lnCustColors = GlobalAlloc(GMEM_FIXED, COLORREF_ARRAY_SIZE)
= ZeroMemory(lnCustColors, COLORREF_ARRAY_SIZE)
lnFlags = CC_FULLOPEN + CC_RGBINIT

lcBuffer = num2dword(CHOOSECOLOR_SIZE) +;
   num2dword(hWindow) +;
   num2dword(0) +;
   num2dword(lnInitColor) +;
   num2dword(lnCustColors) +;
   num2dword(lnFlags) +;
   num2dword(0) +;
   num2dword(0) +;
   num2dword(0)

IF ChooseColor(@lcBuffer) <> 0
   ? "Color selected:", buf2dword(SUBSTR(lcBuffer, 13,4))
   ? "Custom colors stored:"
   lcCustColors = REPLI(CHR(0), COLORREF_ARRAY_SIZE)
   = Heap2Str(@lcCustColors, lnCustColors, COLORREF_ARRAY_SIZE)
   FOR ii=1 TO 16
      ? ii, buf2dword(SUBSTR(lcCustColors, (ii-1)*4+1, 4))
   ENDFOR
ENDIF
=GlobalFree(lnCustColors)

FUNCTION num2dword(lnValue)
   #DEFINE m0       256
   #DEFINE m1     65536
   #DEFINE m2  16777216
   LOCAL b0, b1, b2, b3
   b3 = INT(lnValue/m2)
   b2 = INT((lnValue - b3*m2)/m1)
   b1 = INT((lnValue - b3*m2 - b2*m1)/m0)
   b0 = MOD(lnValue, m0)
   RETURN CHR(b0)+CHR(b1)+CHR(b2)+CHR(b3)
ENDFUNC

FUNCTION  buf2dword (lcBuffer)
   #DEFINE MAX_DWORD  4294967295  && 0xffffffff
   #DEFINE MAX_LONG   2147483647  && 0x7FFFFFFF
   LOCAL lnResult
   lnResult = ASC(SUBSTR(lcBuffer, 1,1)) + ;
      ASC(SUBSTR(lcBuffer, 2,1)) * 256 +;
      ASC(SUBSTR(lcBuffer, 3,1)) * 65536 +;
      ASC(SUBSTR(lcBuffer, 4,1)) * 16777216
   RETURN  IIF(lnResult>MAX_LONG, lnResult-MAX_DWORD, lnResult)
ENDFUNC

PROCEDURE  DECL
   DECLARE INTEGER ChooseColor IN comdlg32 STRING @lpcc
   DECLARE INTEGER GetActiveWindow IN user32
   DECLARE INTEGER GlobalFree IN kernel32 INTEGER HMEM
   DECLARE RtlZeroMemory IN kernel32 AS ZeroMemory;
      INTEGER DEST, INTEGER numBytes

   DECLARE INTEGER GlobalAlloc IN kernel32;
      INTEGER wFlags, INTEGER dwBytes

   DECLARE RtlMoveMemory IN kernel32 AS Heap2Str;
      STRING @, INTEGER, INTEGER
ENDFUNC

************************************************************************************************
 Bueno, esta API nos permite saber si 2 rutas de archivos estan en el mismo disco.



Declare Long PathIsSameRoot In "shlwapi.dll" String pszPath1, String pszPath2
?PathIsSameRoot('c:Prueba.txt','d:Otro_Disco.doc')
?PathIsSameRoot('c:listadosarchivos.txt','c:winnttestprueba.arj')


Si devuelve 1 es que estan en el mismo disco, si no no lo estan.


************************************************************************************************
 Bueno aqui os envio un ejemplo de como iniciar una sesión en OpenOffice, crear un documento 
en el Writer, guardar el documento y terminar la sesión.



Para terminar la sesión es posible que haya una forma mejor pero yo solo he encontrado esa, si alguien sabe de alguna mejor y no le importa :) q la comente.


LOCAL ARRAY laPropertyValue[1]
LOCAL loManager, loDesktop, loDocument, loCursor
loManager = CREATEOBJECT( "com.sun.star.ServiceManager" )
loDesktop = loManager.createInstance( "com.sun.star.frame.Desktop" )
comarray( loDesktop, 10 )
loReflection = loManager.createInstance( "com.sun.star.reflection.CoreReflection" )
comarray( loReflection, 10 )
laPropertyValue[1] = createStruct( @loReflection, "com.sun.star.beans.PropertyValue" )
laPropertyValue[1].NAME = "ReadOnly"
laPropertyValue[1].VALUE = .F.

*!*
*!* Creamos un nuevo documento
*!*
loDocument = loDesktop.LoadComponentFromUrl( "private:factory/swriter", "_blank", 0, @laPropertyValue )
comarray( loDocument, 10 )
loCursor 	= loDocument.TEXT.CreateTextCursor()
loDocument.TEXT.InsertString( loCursor, "Hola desde VFP" , .F. )

*!*
*!* Salvamos el documento
*!*
laPropertyValue[1]			= createStruct( @loReflection, "com.sun.star.beans.PropertyValue" )
laPropertyValue[1].NAME 	= "Overwrite"
laPropertyValue[1].VALUE 	= .T.
loDocument.storeAsURL( "file:///c:/test.sxw", @laPropertyValue )

*!*
*!* Terminamos la sesión en OpenOffice
*!*
loDesktop.TERMINATE()

FUNCTION createStruct( toReflection, tcTypeName )
   LOCAL loPropertyValue, loTemp
   loPropertyValue = CREATEOBJECT( "relation" )
   toReflection.forName( tcTypeName ).CREATEOBJECT( @loPropertyValue )
   RETURN ( loPropertyValue )
ENDFUNC

PROCEDURE SAVEAS( toDocument, tcFile, tlOverWrite )
   LOCAL ARRAY laPropertyValue[1]
   LOCAL lcURL
   IF ( TYPE( "tcFile" ) == "C" AND !EMPTY( tcFile ) )
      *!*
      *!* Comprobamos el nombre del fichero
      *!*
      lcURL = SUBSTR( tcFile, 1, AT( ":", tcFile ) )
      IF ( ! ( lcURL $ THIS.listURL ) )
         tcFile = STRTRAN( tcFile, "", "/" )
         tcFile = "file:///" + tcFile
      ENDIF
      *!*
      *!* Creamos las propiedades necesarias para salvar el documento
      *!*
      laPropertyValue[1] = createStruct( toReflection, tcTypeName )
      THIS.createType( ";@PropertyValue" )
      laPropertyValue[1].NAME  = "Overwrite"
      laPropertyValue[1].VALUE = tlOverWrite
      *!*
      *!* Grabamos el fichero si es necesario
      *!*
      IF ( toDocument.isModified )
         IF ( toDocument.hasLocation AND ( !toDocument.ISREADONLY ) )
            toDocument.STORE()
         ELSE
            toDocument.storeAsURL( tcFile, @laPropertyValue )
         ENDIF
      ENDIF
   ENDIF
ENDPROC

************************************************************************************************
 Una forma bonita de darle un fondo a nuestras aplicaciones es por medio de esta Api.

La imagen se torma muy clara dando la apariencia de Marca de Agua.


DO decl 
#DEFINE LR_LOADFROMFILE       16 

    LOCAL lcBitmap 
    lcBitmap = "C:Windowsbosque.bmp" 

    = LoadAndShowBitmap (lcBitmap, LR_LOADFROMFILE, 20,100) 

PROCEDURE  LoadAndShowBitmap (lcBitmap, lnLoadOptions, lnX,lnY) 
#DEFINE IMAGE_BITMAP  0 
    LOCAL hBitmap 
    hBitmap = LoadImage (0, lcBitmap, IMAGE_BITMAP,; 
        0,0, lnLoadOptions) 

    IF hBitmap <> 0 
        = ShowBitmap (hBitmap, lnX,lnY) 
        = DeleteObject (hBitmap) 
    ELSE 
        = MessageB (lcBitmap + Chr(13) + Chr(13) +; 
            "Check if this is a valid BMP file.",; 
            32, " Unable to load an image from file") 
    ENDIF 

PROCEDURE  ShowBitmap (hBitmap, lnX, lnY) 


#DEFINE AC_SRC_OVER      0 
#DEFINE AC_SRC_ALPHA     1 
#DEFINE AC_SRC_NO_ALPHA  2 
#DEFINE SRCCOPY          13369376 

    LOCAL hWnd, hDC, hMemDC, lnWidth, lnHeight 

    STORE 0 TO lnWidth, lnHeight 
    = GetBitmapSize (hBitmap, @lnWidth, @lnHeight) 

    hWnd = GetActiveWindow() 
    hDC = GetWindowDC (hWnd) 
     
    hMemDC = CreateCompatibleDC(hDC) 
    = SelectObject (hMemDC, hBitmap) 

    LOCAL lnAlphaBlend, lnResult,; 
        lnBlendOp, lnBlendFlags, lnSrcConstAlpha, lnAlphaFormat 

    lnBlendOp = AC_SRC_OVER  && always 
    lnBlendFlags = 0         && always 
    lnSrcConstAlpha = 48     && intensity, up to 255 
    lnAlphaFormat = 0        && try AC_SRC_ALPHA on non-white background 


    lnAlphaBlend = lnBlendOp +; 
        BitLShift(lnBlendFlags, 8) +; 
        BitLShift(lnSrcConstAlpha, 16) +; 
        BitLShift(lnAlphaFormat, 24) 

    lnResult = AlphaBlend (hDC, lnX,lnY, lnWidth,lnHeight,; 
        hMemDC, 0,0, lnWidth,lnHeight,; 
        lnAlphaBlend) 

    IF lnResult = 0 

        ? "Error:", GetLastError() 
    ENDIF 

    = DeleteDC(hMemDC) 
    = ReleaseDC (hWnd, hDc) 
RETURN .T. 

FUNCTION  GetBitmapSize (hBitmap, lnWidth, lnHeight) 
#DEFINE BITMAP_STRU_SIZE   24 
    LOCAL lcBuffer 
    lcBuffer = Repli(Chr(0), BITMAP_STRU_SIZE) 

    IF GetObjectA(hBitmap, BITMAP_STRU_SIZE, @lcBuffer) <> 0 
        lnWidth  = buf2dword (SUBSTR(lcBuffer, 5,4)) 
        lnHeight = buf2dword (SUBSTR(lcBuffer, 9,4)) 
       ENDIF 

FUNCTION  buf2dword (lcBuffer) 
RETURN Asc(SUBSTR(lcBuffer, 1,1)) + ; 
    BitLShift(Asc(SUBSTR(lcBuffer, 2,1)),  8) +; 
    BitLShift(Asc(SUBSTR(lcBuffer, 3,1)), 16) +; 
    BitLShift(Asc(SUBSTR(lcBuffer, 4,1)), 24) 

PROCEDURE  decl 
    DECLARE INTEGER CreateCompatibleDC IN gdi32 INTEGER hdc 
    DECLARE INTEGER DeleteDC IN gdi32 INTEGER hdc 
    DECLARE INTEGER GetActiveWindow IN user32 
    DECLARE INTEGER GetWindowDC IN user32 INTEGER hwnd 
    DECLARE INTEGER ReleaseDC IN user32 INTEGER hwnd, INTEGER dc 
    DECLARE INTEGER DeleteObject IN gdi32 INTEGER hObject 
    DECLARE INTEGER SelectObject IN gdi32 INTEGER hdc, INTEGER hObject 

    DECLARE INTEGER LoadImage IN user32; 
        INTEGER hinst, STRING lpszName, INTEGER uType,; 
        INTEGER cxDesired, INTEGER cyDesired, INTEGER fuLoad 

    DECLARE INTEGER GetObject IN gdi32 AS GetObjectA; 
        INTEGER hgdiobj, INTEGER cbBuffer, STRING @lpvObject 

    DECLARE INTEGER AlphaBlend IN Msimg32; 
        INTEGER hDestDC, INTEGER x, INTEGER y,; 
        INTEGER nWidth, INTEGER nHeight, INTEGER hSrcDC,; 
        INTEGER xSrc, INTEGER ySrc, INTEGER nWidthSrc,; 
        INTEGER nHeightSrc, INTEGER blendFunction 

    DECLARE INTEGER GetLastError IN kernel32

************************************************************************************************
 Algunas veces necesitamos crear un arbol de directorio completo, pero a veces existe hasta cierto nivel el arbol, y necesitamos ir viendo si el primer nivel existe, si no existe lo creamos, si no creamos el del siguiente nivel...



con esta api podemos crear un directorio de un solo, si existe no da error, si no existe lo creara.


Declare long MakeSureDirectoryPathExists in "imagehlp.dll" string lpPath 
?MakeSureDirectoryPathExists("c:esteesunarboldedirectodirectorio")
?MakeSureDirectoryPathExists("c:esteesunarboldepruebaconhijos1")

************************************************************************************************
 Una forma diferente de realizar un formulario con Scroll.






PUBLIC oForm 
oForm = CreateObject("Tform") 
oForm.Visible = .T. 

DEFINE CLASS Tform As Form 
    Width=540 
    Height=250 
    Caption=" Scrolling text horizontally" 
    Autocenter=.T. 
     
    SrcLen=3000  && width of the source memory device context 
    TrgLen=400   && target width 
    TrgHeight=20 && target height 
    StepLen=1    && incrementing offset by 
    SrcOffs=0    && initial offset 
     
    * sample long string to be scrolled 
    content = "cadena de texto  " +; 
        "texto  " +; 
        "texto  " +; 
        "texto  " +; 
        "texto  " +; 
        "texto  " +; 
        "texto  " +; 
        "texto  " +; 
        "texto" 

    hMemDC=0   && memory device context 
    hMemBmp=0  && memory bitmap 
    hForm=0    && form"s window handle 
    hFormDC=0  && form"s device context 

    ADD OBJECT lbl1 As Tlbl WITH Left=120, Top=70, Caption="Output:" 
    ADD OBJECT lbl2 As Tlbl WITH Left=220, Top=70, Caption="Speed:" 
    ADD OBJECT tm As Timer WITH interval=0 
    ADD OBJECT ogOutput As Toutput WITH Left=120, Top=90 
    ADD OBJECT ogSpeed As Tspeed WITH Left=220, Top=90 

PROCEDURE Init 
    THIS.decl 
    THIS.CreateSource 

PROCEDURE Destroy 
* releasing system resources 
    = ReleaseDC(THIS.hForm, THIS.hFormDC) 
    = DeleteObject(THIS.hMemBmp) 
    = DeleteDC(THIS.hMemDC) 

PROCEDURE Activate 
    IF ThisForm.hForm = 0 
    * retrieving window handle and device context for the form 
        ThisForm.hForm = GetFocus() 
        ThisForm.hFormDC = GetWindowDC(ThisForm.hForm) 
    ENDIF 
     
PROCEDURE tm.timer 
    ThisForm.CopyToTarget  && refreshing display window 

PROCEDURE ogSpeed.InteractiveChange 
* changing scroll speed 
    DO CASE 
    CASE THIS.Value = 1 
        ThisForm.tm.interval = 0 
    CASE THIS.Value = 2 
        ThisForm.tm.interval = 100 
    CASE THIS.Value = 3 
        ThisForm.tm.interval = 50 
    CASE THIS.Value = 4 
        ThisForm.tm.interval = 20 
    CASE THIS.Value = 5 
        ThisForm.tm.interval = 10 
    CASE THIS.Value = 6 
        ThisForm.tm.interval = 5 
    ENDCASE 

PROCEDURE CreateSource 
* creating compatible device context and placing text on it 
    DECLARE INTEGER GetDesktopWindow IN user32 
    DECLARE INTEGER CreateCompatibleDC IN gdi32 INTEGER hdc 
    DECLARE INTEGER CreateCompatibleBitmap IN gdi32;   
        INTEGER hdc, INTEGER nWidth, INTEGER nHeight 

    LOCAL hDsk, hDskDC, hBr, rect 
    hDsk = GetDesktopWindow() 
    hDskDC = GetWindowDC(hDsk) 
     
    * creating memory device context 
    * the whole string will be printed on it 
    THIS.hMemDC = CreateCompatibleDC(hDskDC) 
    THIS.hMemBmp = CreateCompatibleBitmap(hDskDC,; 
        THIS.SrcLen, THIS.TrgHeight) 

    = DeleteObject(SelectObject(THIS.hMemDC, THIS.hMemBmp)) 

    * setting background color 
    hBr = CreateSolidBrush(ThisForm.BackColor) 
    rect = num2dword(0) + num2dword(0) +; 
        num2dword(THIS.SrcLen) + num2dword(THIS.TrgHeight) 
    = FillRect(THIS.hMemDC, @rect, hBr) 
    = DeleteObject(hBr) 

    * setting text parameters 
*    = SetBkColor(THIS.hMemDC, Rgb(0,0,128)) 
    = SetBkMode(THIS.hMemDC, 1)  && transparent 
    = SetTextColor(THIS.hMemDC, ThisForm.ForeColor) 

    * default font is used for this device context 
    * use CreateFont+SelectObject functions to select another font 
    = TextOut(THIS.hMemDC, 0,0, THIS.content, Len(THIS.content)) 
    = ReleaseDC(hDsk, hDskDC) 
     
PROCEDURE CopyToTarget 
* copying smaller portions from memory device context to the target 
#DEFINE SRCCOPY     13369376 
    LOCAL hTarget, hTargetDC, x,y 
     
    * the target either main FoxPro window or the form 
    IF THIS.ogOutput.Value = 1 
        hTarget = GetActiveWindow() 
        hTargetDC = GetWindowDC(hTarget) 
        x = 100 
        y = 100 
    ELSE 
        hTarget = 0 
        hTargetDC = ThisForm.hFormDC 
        x = 10 
        y = 30 
        THIS.TrgLen = ThisForm.Width - 10 
    ENDIF 
     
    = BitBlt(hTargetDC, x,y, THIS.TrgLen, THIS.TrgHeight,; 
        THIS.hMemDC, THIS.SrcOffs, 0, SRCCOPY) 

    * incrementing offset for the following copying steps 
    THIS.SrcOffs = THIS.SrcOffs + THIS.StepLen 
    IF THIS.SrcOffs + THIS.TrgLen > THIS.SrcLen 
        THIS.SrcOffs = 0 
    ENDIF 
     
    IF hTarget <> 0 
        = ReleaseDC(hTarget, hTargetDC) 
    ENDIF 

PROCEDURE decl 
    DECLARE INTEGER GetFocus IN user32 
    DECLARE INTEGER GetActiveWindow IN user32 
    DECLARE INTEGER DeleteDC IN gdi32 INTEGER hdc 
    DECLARE INTEGER DeleteObject IN gdi32 INTEGER hObj 
    DECLARE INTEGER GetWindowDC IN user32 INTEGER hwnd 
    DECLARE INTEGER CreateSolidBrush IN gdi32 LONG crColor 
    DECLARE INTEGER ReleaseDC IN user32 INTEGER hwnd, INTEGER hdc 
    DECLARE INTEGER SetBkColor IN gdi32 INTEGER hdc, LONG crColor 
    DECLARE INTEGER SelectObject IN gdi32 INTEGER hdc, INTEGER hObj 
    DECLARE INTEGER SetBkMode IN gdi32 INTEGER hdc, INTEGER iBkMode 
    DECLARE INTEGER SetTextColor IN gdi32 INTEGER hdc, INTEGER crColor 

    DECLARE INTEGER FillRect IN user32; 
        INTEGER hDC, STRING @RECT, INTEGER hBrush 

    DECLARE INTEGER TextOut IN gdi32; 
        INTEGER hdc, INTEGER x, INTEGER y,;   
        STRING lpString, INTEGER nCount 

    DECLARE INTEGER BitBlt IN gdi32 INTEGER hDestDC,; 
        INTEGER x, INTEGER y, INTEGER nWidth, INTEGER nHeight,; 
        INTEGER hSrcDC, INTEGER xSrc, INTEGER ySrc, INTEGER dwRop 
ENDDEFINE 

DEFINE CLASS Tlbl As Label 
    Autosize=.T. 
    Backstyle=0 
ENDDEFINE 

DEFINE CLASS Toutput As OptionGroup 
    ButtonCount=2 
    Autosize=.T. 
    Option1.Caption="Screen" 
    Option1.Top=5 
    Option1.Autosize=.T. 
    Option2.Caption="Form" 
    Option2.Top=30 
    Option2.Autosize=.T. 
ENDDEFINE 

DEFINE CLASS Tspeed As OptionGroup 
    ButtonCount=6 
    Autosize=.T. 
    Option1.Caption="Stop" 
    Option2.Caption="Slow" 
    Option3.Caption="..." 
    Option4.Caption="Recommended" 
    Option5.Caption="..." 
    Option6.Caption="Fast" 

PROCEDURE Init 
    LOCAL ii, obj, nTop 
    nTop = 5 
    FOR ii=1 To 6 
        obj = Eval("THIS.Option" + LTRIM(STR(ii))) 
        WITH obj 
            .Top=nTop 
            .Autosize=.T. 
            nTop = nTop + 20 
        ENDWITH 
    ENDFOR 
ENDDEFINE 

FUNCTION  num2dword (lnValue) 
#DEFINE m0       256 
#DEFINE m1     65536 
#DEFINE m2  16777216 
    LOCAL b0, b1, b2, b3 
    b3 = Int(lnValue/m2) 
    b2 = Int((lnValue - b3*m2)/m1) 
    b1 = Int((lnValue - b3*m2 - b2*m1)/m0) 
    b0 = Mod(lnValue, m0) 
RETURN Chr(b0)+Chr(b1)+Chr(b2)+Chr(b3)


************************************************************************************************
 Si necesitan buscar parte de un código dentro de un procedimiento almacenado en SQL SERVERS, aqui la solución.




select so.id, so.name 
   from sysobjects so 
   inner join syscomments sc 
   on so.id = sc.id AND sc.encrypted= 0 
   where so.xtype = 'P' and charindex ( 'PON AQUI EL CÓDIGO A BUSCAR', sc.text ) > 0


************************************************************************************************
 Con Este codigo, podemos Ver Modificar la configuracion de colores de Windows. al estilo del plus! de Microsoft o bien cuando damos Click derecho sobre el Escritorio Propiedades/Apariencia




Public oForm
oForm=Newobject("Colores_Windows")
oForm.Show
Return
Define Class Colores_Windows As Form
	Top = 41
	Left = 37
	Height = 452
	Width = 527
	DoCreate = .T.
	Caption = "Jugando con los colores de Windows"
	TitleBar = 1
	Name = "FrmColores_Windows"
	Add Object cmdmostrar As CommandButton With ;
		Top = 24, ;
		Left = 396, ;
		Height = 49, ;
		Width = 126, ;
		WordWrap = .T., ;
		Caption = "
		Name = "cmdMostrar"
	Add Object cmdaplicar As CommandButton With ;
		Top = 72, ;
		Left = 396, ;
		Height = 49, ;
		Width = 126, ;
		WordWrap = .T., ;
		Caption = "
		Enabled = .F., ;
		Name = "cmdAplicar"

	Procedure ver_colores
		Local nCiclo, oBarra, oEtiqueta, nX, cNombre, aListado
		Dimension aListado [19,2]
		nX = 20
		aListado[1,2] = 'Barra de Desplazamiento'
		aListado[2,2] = 'Fondo'
		aListado[3,2] = 'Barra de Titulo Ventana Activa'
		aListado[4,2] = 'Barra de Titulo Ventana Inactiva'
		aListado[5,2] = 'Menú'
		aListado[6,2] = 'Ventana'
		aListado[7,2] = 'Marco de la Ventana'
		aListado[8,2] = 'Texto de Menú'
		aListado[9,2] = 'Texto de Ventana'
		aListado[10,2] = 'Texto de Barra de Titulo'
		aListado[11,2] = 'Borde Ventana Activa'
		aListado[12,2] = 'Borde Ventana Inactiva'
		aListado[13,2] = 'Area de Trabajo de la Aplicacion'
		aListado[14,2] = 'Seleccion'
		aListado[15,2] = 'Texto Seleccionado'
		aListado[16,2] = 'Color Objeto 3D'
		aListado[17,2] = 'Sombra Objeto 3D'
		aListado[18,2] = 'Texto Gris'
		aListado[19,2] = 'Texto del Objeto 3D'
		For nCiclo = 1 To 19
			aListado[nciclo,1]=nCiclo-1
			cNombre ="Barra_"+Alltrim(Str(nCiclo))
			If Type('thisform.'+cNombre)<>'O'
				Thisform.AddObject(cNombre,'Barra_color')
			EndIf 
			oBarra = Evaluate("thisform."+cNombre)
			cNombre ="lbl_barra_"+Alltrim(Str(nCiclo))
			If Type('thisform.'+cNombre)<>'O'
				Thisform.AddObject('lbl_barra_'+Alltrim(Str(nCiclo)),'Label')
			EndIf 
			oEtiqueta = Evaluate('Thisform.'+cNombre)
			oBarra.BackColor = getsyscolor(aListado[nciclo,1])
			oBarra.Left = 50
			oBarra.Top = nX
			oEtiqueta.BackStyle = 0
			oEtiqueta.AutoSize = .T.
			oEtiqueta.Caption =Alltrim(aListado[nciclo,2])
			oEtiqueta.Top = nX
			oEtiqueta.Left = oBarra.Left + oBarra.Width +15
			oEtiqueta.Visible = .T.
			oBarra.Visible= .T.
			nX= nX +oBarra.Height +3
		EndFor 
		Thisform.cmdaplicar.Enabled = .T.
	EndProc 

	Procedure establecer_colores
		Local nCiclo, oBarra, nNumero, nValor
		For nCiclo = 1 To 19
			oBarra = Evaluate("thisform.Barra_"+Alltrim(Str(nCiclo)))
			nNumero= nCiclo -1
			nValor = oBarra.BackColor
			If nValor <> getsyscolor(nNumero)
				SetSysColors(1,@nNumero,@nValor)
			EndIf 
		EndFor 
	EndProc 

	Procedure Load
		Declare Long GetSysColor In "user32" Long nIndex
		Declare Long SetSysColors In  "user32" Long nChanges, Long @lpSysColor, Long @lpColorValues
	EndProc 
	Procedure cmdmostrar.Click
		Thisform.ver_colores
	EndProc 
	Procedure cmdaplicar.Click 
		Thisform.establecer_colores
	EndProc 
EndDefine 

Define Class Barra_color As Shape
	Procedure Click
		This.BackColor =Getcolor(This.BackColor)
	Endproc
EndDefine 

************************************************************************************************
 Algunas veces en las aplicaciones multiusuario se requiere limpiar o modificar ciertas tablas (dbf) en tiempo de ejecución. El problema es como determinar si esta tabla esta siendo ocupada por algún usuario en otra estación en ese momento???...

ya que para realizar estas operaciones es necesario tomar en forma exclusiva estos archivos. Aqui les entrego una función muy sencilla y para determinar si el archivo esta siendo utilizado o no.
Ojala les sirva !!!
Saludos


*********************************************************************
* FUNCION : Determinar si una tabla esta en uso
* PARAMETROS : Nombre Archivo  (expresion caracter)
*                            Ej1:  "x:tablastabla1.dbf"
*                            Ej2:  "tabla1.dbf"
* VALORES DEVUELTOS : 0 = El archivo no esta en uso
*                                         1 = El archivo esta en uso
*                                         2 = ERROR
* AUTOR : romovi
*********************************************************************
Parameters cArchivo

Store 0 to ValRet
SetTalk = Set("Talk")
Set Talk Off
IF TYPE("cArchivo")#"C"
	Wait wind "Parametro mal definido"
	ValRet = 2
ELSE
	IF !FILE(cArchivo)
		Wait wind "El archivo indicado no existe!!!"
		ValRet = 2
	ENDIF
ENDIF
IF ValRet=0
	idFile = fopen(cArchivo,12)
	=fclose(idFile)
	ValRet = Iif(idFile<>-1,0,1)
ENDIF
SET TALK &SetTalk
Return ValRet


************************************************************************************************
 Necesita renombrar directorios?, aqui le mencionamos cómo hacerlo.

Utilizaremos el FileSystemObject para renombrar el archivo, a continuación una función para hacerlo.


******************************************************************
* ---- Renombrar Directorio ----- Rename Directory
* ---- Author: Espartaco Palma Martinez esparta@NO_SPAMportalfox.com
* ---- FUNCTION: renamedir
* ---- RETURNS:  1 If Directory rename sucess
* ----          -1 If no Source Directory parameter 
* ----          -2 If no Target Directory parameter 
* ----          -3 If the Directory doesn't exist
* ----          -4 If source directory is Current Directory
* ---- RETORNA: -1 Renombrado de directorio con exito
* ----          -1 Si no se especifico parametro de Directorio fuente
* ----          -2 Si no se especifico parametro de Directorio Destino
* ----          -3 Si el directorio no existe
* ----          -4 Si el directorio actual es el directorio fuente
* ---- PARAMETERS: tcSource - TYPE: Character, Source Directory
* ----             tcTarget - TYPE: Character, Target Directory
* ---- PARAMETROS: tcSource - TIPO: Caracter, ruta completa del directorio fuente
* ----             tcTarget - TIPO: Caracter, ruta completa del directorio Destino
* ---- DATE: 16/Mar/2004 For Use in Visual FoxPro.
* ---- Sample/Ejemplo:
* ---- ltFecha = creationDate("C:/prueba","C:/prueba2")
******************************************************************

FUNCTION RenameDir
LPARAMETERS tcSource, tcTarget
LOCAL lfso &&FileSystem Object

DO CASE
   CASE (VARTYPE(tcSource)#"C" or EMPTY(tcSource))
      **** Falta Parametro Directorio Origen
      **** Needs Source Parameter
      RETURN -1
   CASE (VARTYPE(tcTarget)#"C" or EMPTY(tcTarget))
      **** Falta Parametro Directorio Destino
      **** Needs Target Parameter
      RETURN -2
   CASE !DIRECTORY(tcSource)
      **** No se encuentra el directorio Origen
      **** Source Directory no found
      RETURN -3
   CASE SYS(5)+SYS(2003)==UPPER(tcSource)
      **** El directorio Actual no puede ser renombrado
      **** Current Dir cannot be renamed
      RETURN -4      
ENDCASE

lfso = CREATEOBJECT("Scripting.FileSystemObject")
lfso.MoveFolder(tcSource,tcTarget)
RETURN 1


Espero le sea de utilidad.



************************************************************************************************
 Para que puedan verificar si un correo electrónico fue escrito correctamente.




***************************************************************************
***************************************************************************
*** Sintaxis:
*** DireccionEmail("tumail@elservidor.com")
*** 
*** Valores Devueltos tipo Lógicos .T. o .F.
*** .T. = el nombre es correcto y .F. si tuvo algun problema con el nombre.
***
*** Autor: J. Enrique Ramos Menchaca.
*** E-Mail: jermmx@NOSPAMhotmail.com
*** Fecha: 19 de febrero del 2003.
***************************************************************************
***************************************************************************

FUNCTION DireccionEmail(cemail)
	lcMail  = cemail
	lcNombre = SPACE(0)
	lcHost = SPACE(0)
	nTAMAÑO = LEN(lcMail)
	set library to SYS(2003)+''+'foxtools'
	local lnPalabras, lapalabras(1), i, sep
	sep=@
	lnPalabras=words(lcMail, sep) 
	dimension lapalabras(lnPalabras)
	for i=1 to lnPalabras
		lapalabras[i]=wordnum(lcMail, i, sep)
	next i
	lcNombre = laPalabras[1]
	lcHost = laPalabras[2]
	*** Verifico el Nombre del mail ***
	llNombreCorrecto = VerificarNombreMail(lcNombre)
	llHostCorrecto = VerificarHostMail(lcHost)
	IF llNombreCorrecto = .F.
		MESSAGEBOX("El Nombre del usuario de correo electrónico es incorrecto.")
	ENDIF
	IF llHostCorrecto = .F.
		MESSAGEBOX("El Nombre del servidor de correo electrónico es incorrecto.")
	ENDIF
	RETURN IIF(llNombreCorrecto = .T. .AND. llHostCorrecto = .T., .T., .F.)
ENDFUNC

FUNCTION VerificarNombreMail(lcPalabra)
	llVerificado = .T.
	lnPalabra = LEN(lcPalabra)
	I = 1
	FOR I = 1 TO lnPalabra
		lcCaracter = SUBSTR(lcPalabra, I,1)
		llVerificado = IIF(BETWEEN(lcCaracter,'0','9'), .T., ;
			IIF(BETWEEN(lcCaracter,'a','z'), .T., ;
			IIF(BETWEEN(lcCaracter,'A','Z'), .T., .F.)))
		IF llVerificado = .F.
			EXIT
		ENDIF
	ENDFOR
	DO CASE
		CASE INLIST(lcPalabra,'..', '.-', '-.', '._', '_.')
			llVerificado = .F.
		CASE INLIST(lcPalabra,'--', '-_', '_-')
			llVerificado = .F.
		CASE INLIST(lcPalabra,'__', ' ')
			llVerificado = .F.
	ENDCASE
	IF llVerificado = .T.
		lcCaracter = SUBSTR(lcPalabra,1,1)
		llVerificado = IIF(BETWEEN(lcCaracter,'0','9'), .T., ;
			IIF(BETWEEN(lcCaracter,'a','z'), .T., ;
			IIF(BETWEEN(lcCaracter,'A','Z'), .T., .F.)))
		lcCaracter = SUBSTR(lcPalabra,lnPalabra,1)
		llVerificado = IIF(BETWEEN(lcCaracter,'0','9'), .T., ;
			IIF(BETWEEN(lcCaracter,'a','z'), .T., ;
			IIF(BETWEEN(lcCaracter,'A','Z'), .T., .F.)))
	ENDIF
	RETURN llVerificado
ENDFUNC

FUNCTION VerificarHostMail(lcPalabra)
	llVerificado = .T.
	lnPalabra = LEN(lcPalabra)
	I = 1
	FOR I = 1 TO lnPalabra
		lcCaracter = SUBSTR(lcPalabra, I,1)
		llVerificado = IIF(BETWEEN(lcCaracter,'0','9'), .T., ;
			IIF(BETWEEN(lcCaracter,'a','z'), .T., ;
			IIF(BETWEEN(lcCaracter,'A','Z'), .T., ;
			IIF( '.' $ lcCaracter, .T., .F.))))
		IF llVerificado = .F.
			EXIT
		ENDIF
	ENDFOR
	DO CASE
		CASE INLIST(lcPalabra,'..', '.-', '-.', '._', '_.')
			llVerificado = .F.
		CASE INLIST(lcPalabra,'--', '-_', '_-')
			llVerificado = .F.
		CASE INLIST(lcPalabra,'__', ' ')
			llVerificado = .F.
	ENDCASE
	IF llVerificado = .T.
		lcCaracter = SUBSTR(lcPalabra,1,1)
		llVerificado = IIF(BETWEEN(lcCaracter,'0','9'), .T., ;
			IIF(BETWEEN(lcCaracter,'a','z'), .T., ;
			IIF(BETWEEN(lcCaracter,'A','Z'), .T., .F.)))
		lcCaracter = SUBSTR(lcPalabra,lnPalabra,1)
		llVerificado = IIF(BETWEEN(lcCaracter,'0','9'), .T., ;
			IIF(BETWEEN(lcCaracter,'a','z'), .T., ;
			IIF(BETWEEN(lcCaracter,'A','Z'), .T., .F.)))
		x = SUBSTR(lcPalabra,lnPalabra-2,1)
		y = SUBSTR(lcPalabra,lnPalabra-3,1)
		llVerificado = IIF(SUBSTR(lcPalabra,lnPalabra-3,1) = '.' .OR. SUBSTR(lcPalabra,lnPalabra-2,1) = '.', .T., .F.)
	ENDIF
	RETURN llVerificado
ENDFUNC



************************************************************************************************
 Listado de DSN con sus parametros


DECLARE INTEGER SQLGetPrivateProfileString IN odbccp32; 
STRING lpszSection, STRING lpszEntry, STRING lpszDefault,; 
STRING @RetBuffer, INTEGER cbRetBuffer, STRING lpszFilename 

CREATE CURSOR csResult (odbcsource C(30), prmname C(20), prmvalue C(200)) 

LOCAL cSources, cSource, cParamNames, cParam, ii, jj 
cSources = Chr(0) + GetPS("ODBC Data Sources", Null) + Chr(0)
ii=1
DO WHILE .T. 
cSource = GetSubstr(cSources, ii, Chr(0)) 
IF EMPTY(cSource) 
EXIT 
ENDIF 

cParamNames = GetPS(cSource, Null)
INSERT INTO csResult VALUES (cSource, "All parameters",; 
STRTRAN(cParamNames, Chr(0), " ")) 

cParamNames = Chr(0) + GetPS(cSource, Null) + Chr(0) 
jj = 1 
DO WHILE .T. 
cParam = GetSubstr(cParamNames, jj, Chr(0)) 
IF EMPTY(cParam) 
EXIT 
ENDIF 
= AddParam(cSource, cParam)
jj = jj + 1 
ENDDO
ii = ii + 1 
ENDDO 
GO TOP 
BROWSE NORMAL NOWAIT 
* end of main 

PROCEDURE AddParam(cKey, pname) 
LOCAL pvalue 
pvalue = GetPS(cKey, m.pname)
pvalue = STRTRAN(pvalue, Chr(0),"")
IF Not EMPTY(pvalue) 
INSERT INTO csResult VALUES (m.cKey,; 
m.pname, m.pvalue) 
ENDIF 

FUNCTION GetPS(section, entry) 
LOCAL cBuffer, nLen
cBuffer = Repli(Chr(0), 250)
nLen = SQLGetPrivateProfileString(section, entry, "",; 
@cBuffer, Len(cBuffer), "ODBC.INI") 
RETURN Iif(nLen=0, "", SUBSTR(cBuffer, 1, nLen)) 
FUNCTION GetSubstr(cSource, nIndex, cChar) 
LOCAL nPos1, nPos2 
nPos1 = AT(cChar, cSource, nIndex) 
nPos2 = AT(cChar, cSource, nIndex+1)
IF MIN(nPos1, nPos2) <> 0 
RETURN SUBSTR(cSource, nPos1+1, nPos2-nPos1-1) 
ENDIF 
RETURN "" 
************************************************************************************************

 Que tal un About To con esto :






#DEFINE ANSI_CHARSET          0 
#DEFINE OUT_DEFAULT_PRECIS    0 
#DEFINE OUT_DEVICE_PRECIS     5 
#DEFINE OUT_OUTLINE_PRECIS    8 

#DEFINE CLIP_DEFAULT_PRECIS   0 
#DEFINE CLIP_STROKE_PRECIS    2 

#DEFINE DEFAULT_QUALITY       0 
#DEFINE PROOF_QUALITY         2 

#DEFINE DEFAULT_PITCH         0 
#DEFINE FW_BOLD             700 

#DEFINE TRANSPARENT           1 
#DEFINE OPAQUE                2 

    DO decl 
     
    lcText = "Printing Text" 
    FOR ii=200 TO 1 STEP-1 
        lnColor = Rgb(Max(0,255-ii), Max(0,128-ii*5), Min(255,128+ii*10)) 
        = _print (lcText, lnColor, -ii) 

        ii = ii - 30 
        = _print (lcText, Rgb(80,80,80), -ii) 
    ENDFOR 
    = _print (lcText, Rgb(164,0,0), 0) 

PROCEDURE  _print (lcText, lnColor, lnAngle) 
    hFont = CreateFont (; 
        100,0, lnAngle,lnAngle, FW_BOLD, 0,0,0, ANSI_CHARSET,; 
        OUT_OUTLINE_PRECIS, CLIP_STROKE_PRECIS,; 
        PROOF_QUALITY, DEFAULT_PITCH, "Times New Roman") 

    hwnd = GetActiveWindow() 
    hdc = GetWindowDC (hwnd) 

    * select new font into the device context 
    * and delete the old one 
    = DeleteObject (SelectObject (hdc, hFont)) 

    * set text color on a transparent background 
    = SetTextColor (hdc, lnColor) 
    = SetBkMode (hdc, TRANSPARENT) 

    * the printing 
    = TextOut (hdc, 50, 100, lcText, Len(lcText)) 

    * release system resources 
    = DeleteObject (hFont) 
    = ReleaseDC (hwnd, hdc) 

PROCEDURE  decl 
    DECLARE INTEGER GetActiveWindow IN user32 
    DECLARE INTEGER GetWindowDC IN user32 INTEGER hwnd    

    DECLARE INTEGER DeleteObject IN gdi32 INTEGER hObject 
    DECLARE INTEGER ReleaseDC IN user32; 
        INTEGER hwnd, INTEGER hdc 

    DECLARE INTEGER SetTextColor IN gdi32; 
        INTEGER hdc, INTEGER crColor 

    DECLARE INTEGER SelectObject IN gdi32; 
        INTEGER hdc, INTEGER hObject 
  
    DECLARE INTEGER TextOut IN gdi32; 
        INTEGER hdc, INTEGER x, INTEGER y,; 
        STRING  lpString, INTEGER nCount 

    DECLARE INTEGER SetBkMode IN gdi32; 
        INTEGER hdc, INTEGER iBkMode 

    DECLARE INTEGER CreateFont IN gdi32; 
        INTEGER nHeight, INTEGER nWidth,; 
        INTEGER nEscapement, INTEGER nOrientation,; 
        INTEGER fnWeight, INTEGER fdwItalic,; 
        INTEGER fdwUnderline, INTEGER fdwStrikeOut,; 
        INTEGER fdwCharSet,; 
        INTEGER fdwOutputPrecision,; 
        INTEGER fdwClipPrecision,; 
        INTEGER fdwQuality,; 
        INTEGER fdwPitchAndFamily,; 
        STRING  lpszFace 


************************************************************************************************
 Es algo diferente, no ?

PUBLIC obj 
obj = CreateObject("Tform") 
obj.Visible = .T. 

DEFINE CLASS Tform As Form 
    Width=500 
    Height=300 
    Autocenter=.T. 
    Caption=" Using Header control" 
     
    ADD OBJECT hdr As Theader WITH; 
    hdrLeft=2, hdrTop=2, hdrWidth=495, hdrHeight=21 
     
    ADD OBJECT lst As listBox WITH; 
    Left=2, Top=25, Width=495, Height=240 

PROCEDURE Activate 
    IF THIS.hdr.hWindow = 0 
        THIS.CreateHeader 
    ENDIF 

PROCEDURE CreateHeader 
    THIS.hdr.CreateHeader 
    THIS.hdr.AddItem ("Id", 50, 0) 
    THIS.hdr.AddItem ("First name", 150, 1) 
    THIS.hdr.AddItem ("Last name", 150, 2) 
    THIS.hdr.AddItem ("Dept.", 150, 3) 
     
    CREATE CURSOR csList (personid N(5),; 
        firstname C(20), lastname C(30), dept C(50)) 
    INSERT INTO csList VALUES ( 1, "Alan","Morice","Management") 
    INSERT INTO csList VALUES ( 2, "Andrew","Bruce","Management") 
    INSERT INTO csList VALUES ( 3, "Crysta","Corera","Management") 
    INSERT INTO csList VALUES ( 4, "Annie","Collins","Human Resources") 
    INSERT INTO csList VALUES ( 5, "Nancy","Nagel","Human Resources") 
    INSERT INTO csList VALUES ( 6, "Roy","Saine","Human Resources") 
    INSERT INTO csList VALUES ( 7, "Sandy","Tamburro","Human Resources") 
    INSERT INTO csList VALUES ( 8, "Dora","Hu","Business Analysts") 
    INSERT INTO csList VALUES ( 9, "Emily","Bell","Business Analysts") 
    INSERT INTO csList VALUES (10, "Rino","Henry","Business Analysts") 
    INSERT INTO csList VALUES (11, "Tanya","Harding","Business Analysts") 
    INSERT INTO csList VALUES (12, "Tracy","Clarke","Business Analysts") 

    WITH THIS.lst 
        .RowsourceType=2 
        .RowSource="csList" 
        .ColumnCount=4 
        .ColumnWidths="47,147,147,147" 
        .ListIndex = 1 
    ENDWITH 
ENDDEFINE 

DEFINE CLASS Theader As Custom 
    hParent=0 
    hWindow=0 
    hFont=0 
    hdrLeft=0 
    hdrTop=0 
    hdrWidth=0 
    hdrHeight=0 
    ItemsCount=0 

PROCEDURE Destroy 
    THIS.ReleaseHeader 

PROCEDURE CreateHeader 
#DEFINE WS_CHILD            1073741824  && 0x40000000 
#DEFINE WS_BORDER           8388608     && 0x00800000L 
#DEFINE HDS_BUTTONS         2 
#DEFINE GWL_HINSTANCE      -6 
#DEFINE HWND_BOTTOM         1 
#DEFINE SWP_SHOWWINDOW      64 
#DEFINE ANSI_CHARSET        0 
#DEFINE OUT_OUTLINE_PRECIS  8 
#DEFINE CLIP_STROKE_PRECIS  2 
#DEFINE PROOF_QUALITY       2 
#DEFINE DEFAULT_PITCH       0 
#DEFINE WM_SETFONT          48 

    THIS.ReleaseHeader 
     
    DECLARE INTEGER GetFocus IN user32 
    THIS.hParent = GetFocus() 

    * initializing access to Common Controls 
    DECLARE INTEGER InitCommonControlsEx IN comctl32 STRING @lpInitCtrls 
    = InitCommonControlsEx (PADR(Chr(8), 4,Chr(0)) + PADR(Chr(255), 4,Chr(0))) 

    DECLARE INTEGER CreateWindowEx IN user32 AS CreateWindow; 
        INTEGER dwExStyle, STRING lpClassName, STRING lpWndName,; 
        INTEGER dwStyle, INTEGER x, INTEGER y, INTEGER nWidth, INTEGER nHeight,; 
        INTEGER hWndParent, INTEGER hMenu, INTEGER hInst, INTEGER lpParam 

    DECLARE INTEGER GetWindowLong IN user32 INTEGER hWnd, INTEGER nIndex 

    LOCAL lcWindowName, lnStyle, lnStyleX, lnId, hApp 
    lnStyle = WS_CHILD + WS_BORDER + HDS_BUTTONS 
    lnStyleX = 0 
    lnId = Val(SYS(3)) 
    lcWindowName = "hdr" + SYS(3) 
    hApp = GetWindowLong (THIS.hWindow, GWL_HINSTANCE) 

    THIS.hWindow = CreateWindow (lnStyleX, "SysHeader32",; 
        lcWindowName, lnStyle, 0, 0, 0, 0, THIS.hParent, lnId, hApp, 0) 

    * changing font to Arial, semi-bold, 16 pixels height 
    DECLARE INTEGER CreateFont IN gdi32; 
        INTEGER nHeight, INTEGER nWidth, INTEGER nEscapement,; 
        INTEGER nOrientation, INTEGER fnWeight, INTEGER fdwItalic,; 
        INTEGER fdwUnderline, INTEGER fdwStrikeOut,; 
        INTEGER fdwCharSet, INTEGER fdwOutputPrecision,; 
        INTEGER fdwClipPrecision, INTEGER fdwQuality,; 
        INTEGER fdwPitchAndFamily, STRING lpszFace 

    THIS.hFont = CreateFont (16, 0, 0, 0, 600, 0,0,0,; 
        ANSI_CHARSET, OUT_OUTLINE_PRECIS, CLIP_STROKE_PRECIS,; 
        PROOF_QUALITY, DEFAULT_PITCH, "Arial") 

    DECLARE INTEGER SendMessage IN user32; 
        INTEGER hWnd, INTEGER Msg, INTEGER wParam, INTEGER lParam 
    = SendMessage (THIS.hWindow, WM_SETFONT, THIS.hFont, 0) 

    * positioning 
    DECLARE INTEGER SetWindowPos IN user32; 
        INTEGER hwnd, INTEGER hWndInsertAfter,; 
        INTEGER x, INTEGER y, INTEGER cx, INTEGER cy,; 
        INTEGER wFlags 

    = SetWindowPos(THIS.hWindow, HWND_BOTTOM,; 
        THIS.hdrLeft, THIS.hdrTop,; 
        THIS.hdrLeft+THIS.hdrWidth-1, THIS.hdrTop+THIS.hdrHeight-1,; 
        SWP_SHOWWINDOW) 

PROCEDURE ReleaseHeader 
    IF THIS.hWindow <> 0 
        THIS.RemoveItems 

        DECLARE INTEGER DeleteObject IN gdi32 INTEGER hObject 
        = DeleteObject(THIS.hFont) 
     
        DECLARE INTEGER DestroyWindow IN user32 INTEGER hWnd 
        = DestroyWindow(THIS.hWindow) 
        THIS.hWindow = 0 
    ENDIF 

PROCEDURE SendItemMsg (lnMessage, lcItem, lnWidth, lnOrder) 
#DEFINE HDI_WIDTH       1 
#DEFINE HDI_TEXT        2 
#DEFINE HDI_ORDER       128 
#DEFINE HDF_LEFT        0 
#DEFINE HDM_INSERTITEM  4609 

    DECLARE INTEGER StrDup IN shlwapi STRING @lpsz 
    DECLARE INTEGER LocalFree IN kernel32 INTEGER hMem 

    LOCAL lnItemPtr, lcBuffer 
    lcItem = STRTRAN(lcItem, Chr(0),"") + Chr(0) 
    lnItemPtr = StrDup(@lcItem) 

    lcBuffer = num2dword(HDI_TEXT+HDI_WIDTH+HDI_ORDER) +; 
        num2dword(lnWidth) + num2dword(lnItemPtr) +; 
        num2dword(0) + num2dword(Len(lcItem)) +; 
        num2dword(0) + num2dword(0) + num2dword(0) +; 
        num2dword(lnOrder) 

    DECLARE INTEGER SendMessage IN user32; 
        INTEGER hWnd, INTEGER Msg, INTEGER wParam, STRING @lParam 

    = SendMessage (THIS.hWindow, lnMessage, 0, @lcBuffer) 
    = LocalFree(lnItemPtr) 

PROCEDURE RemoveItems (lcItem) 
#DEFINE HDM_DELETEITEM  4610 
    LOCAL lnIndex 
    FOR lnIndex=1 TO THIS.ItemsCount 
        THIS.SendItemMsg (HDM_DELETEITEM, "", 0, 0) 
    ENDFOR 

PROCEDURE AddItem (lcItem, lnWidth, lnOrder) 
#DEFINE HDM_INSERTITEM  4609 
    THIS.ItemsCount = THIS.ItemsCount + 1 
    THIS.SendItemMsg (HDM_INSERTITEM, lcItem, lnWidth, lnOrder) 
ENDDEFINE 

FUNCTION  num2dword (lnValue) 
#DEFINE m0       256 
#DEFINE m1     65536 
#DEFINE m2  16777216 
    LOCAL b0, b1, b2, b3 
    b3 = Int(lnValue/m2) 
    b2 = Int((lnValue - b3*m2)/m1) 
    b1 = Int((lnValue - b3*m2 - b2*m1)/m0) 
    b0 = Mod(lnValue, m0) 
RETURN Chr(b0)+Chr(b1)+Chr(b2)+Chr(b3)

************************************************************************************************
 No se si les pasó a ustedes el tener que repetir una y otra vez el alta de las mismas tablas en el entorno de datos para similares ABM de datos, al crear un form de datos fijos repetitivos como clientes, proveedores, localidades, etc.

Si hacia una clase para cada una de estas tablas para luego crear el form de nuestro cliente derivado de la clase escrita, siempre me faltaba algo. Trabajar en los campos. (agregarlos en el form, o editar su controlsource) y crear el entorno de datos en el formulario.

Todos los proveedores tienen campos similares, nombre, domicilio, etc. Y todas esas tablas se llaman igual. ¿Por qué no crear entonces un entorno de datos en la clase?

Lo que consideré al hacer esto fue:

-Tablas similares deben usarse con un mismo nombre (aunque pertenezcan a bases de datos distintas) Ej. articulos.dbf, rubros.dbf, etc.
-Estas tablas tienen siempre similares estructuras. (en algunos casos se agregan o quitan campos)
-Ubicaciones en directroios diferentes y nombre de bases de datos diferentes.


1 - Cree una clase no visual visible para todos los formularios:


Define Class Cursores_01 As Cursor	Name = "Cursores_01"
	Exclusive = .F.
	ReadOnly = .F.
	*- esta propiedad que sigue, es de lectura y escritura en modo de ejecucion:
	*-  _oSis.cDbc nombre de la base de datos de la aplicación del framework.
	Database = Juststem(_oSis.cDbc)+".DBC"	
	Procedure Init
		Lparameters tcTabla
		Set Exclusive Off
		Set Multilocks On
		tcTabla = Juststem(tcTabla)
		If !File(This.Database)
			Messagebox(This.Database+" no existe.",48,This.Name)
			Return .F.
		Endif
		If !File(tcTabla+'.dbf')
			Messagebox("No se puede encontrar: "+tcTabla+".dbf",16,This.Name)
			Return .F.
		Endif
		This.Alias = tcTabla
		This.CursorSource = tcTabla		&& nombre largo de la tabla
		This.Comment = 'Cursor '+tcTabla
	Endproc
Enddefine


2 - En el método LOAD de la clase form escribí;


*- Ej. Abm de datos para proveedores:
If This.DataSession # 2
	Messagebox('No ha especificado sesion privada de datos',16,This.Name)
	Return .F.
Endif
If !"CLASES_01"$Set("Procedure")
	Set Procedure To Clases_01 Additive
Endif
Set Deleted On

With Thisform.DataEnvironment
	.CloseTables()	&& libera el entorno de datos cargado
	.AddObject("CurProveedores", "Cursores_01", ‘proveedores’)
	.AddObject("CurLocalidades", "Cursores_01", ‘Localidades’)
	*- ... etc. y todas las tablas que se necesitan en el form.
	.OpenTables()
Endwith
Return This.nError = 0
*- Fin Load.


(a partir de aqui esta clase ya puede tener todos los campos y sus controlsource establecidos en tiempo de diseño y funcionará sin ninguna modificacion adicional en el formulario que, de entrada no tendrá ni una linea de codigo y funcionará.)

3 - Crear el form derivado de esta clase de abm y establecer datasession = 2

Guardar el formulario en el directorio del cliente (o aplicación) para modificar en el futuro las especificaciones exclusivas del cliente en el. (como agregar campos, cambiar Valid, etc.)

Los problemas del futuros podrían ser:

Agregar campos a la tabla:
Siempre se puede sobreescribir el metodo load del form, copiando y pegando el de la clase y agregando el o los cursores adicionales.

Quitar campos:
No implica problema en los pocos casos en que esto suscede se puede usar la prop. Visible del campo. La tabla no hay porque modificarla.


Espero que les sirva como me sirvio a mi.

Saludos.

************************************************************************************************
API Aqui hay una bonita forma de escribir en el screen un texto de entrada o salida de una aplicacion, dara una impresion muy profesional.



PUBLIC frm 

frm = CreateObject("Tform") 

frm.Visible = .T. 



DEFINE CLASS Tform As Form 

    Width=700 

    Height=250 

    Caption="Trabajando con GDI" 

    mouseX=0 

    mouseY=0 

    BorderStyle=2 

    Backcolor = Rgb (192,192,192) 

    hFontHeader=0 

    hFontMemo=0 

     

    ADD OBJECT txt As TextBox WITH; 

        Left=10, Top=THIS.Height-35, Width=140,; 

        Height=25, Value="Su texto Aqui" 



    ADD OBJECT cmdClip As CommandButton WITH; 

        Top=THIS.txt.Top, Left=THIS.txt.Left+THIS.txt.Width+5,; 

        Height=THIS.txt.Height, Width=50,; 

        Default=.T., Caption="Click" 



    ADD OBJECT chkMode As CheckBox WITH; 

        Top=THIS.txt.Top, Left=THIS.cmdClip.Left+THIS.cmdClip.Width+15,; 

        Backstyle=0, Autosize=.T., Caption="Invert", Value=.F. 



PROCEDURE  Load 

    DO decl 



PROCEDURE  Init 

    THIS.createFont 



PROCEDURE  Destroy 

    THIS.releaseFont 

     

PROCEDURE  DblClick 

    THIS.removeRegion 



PROCEDURE MouseDown 

LPARAMETERS nButton, nShift, nXCoord, nYCoord 

* stores cursor absolute position 

    IF nButton = 1 

        LOCAL lnX, lnY 

        = getMousePos (@lnX, @lnY) 

        ThisForm.mouseX = lnX 

        ThisForm.mouseY = lnY 

    ENDIF 



PROCEDURE MouseMove 

LPARAMETERS nButton, nShift, nXCoord, nYCoord 

    IF nButton = 1 

        ThisForm._move && moves the form 

    ENDIF 



PROCEDURE  cmdClip.Click 

    ThisForm.clipText 



PROCEDURE  createFont 

#DEFINE FW_BOLD             700 

#DEFINE FW_NORMAL           400 

#DEFINE ANSI_CHARSET          0 

#DEFINE OUT_OUTLINE_PRECIS    8 

#DEFINE CLIP_STROKE_PRECIS    2 

#DEFINE PROOF_QUALITY         2 

#DEFINE DEFAULT_PITCH         0 



    THIS.hFontHeader = CreateFont (; 

        100,0, 0,0, FW_BOLD, 0,0,0, ANSI_CHARSET,; 

        OUT_OUTLINE_PRECIS, CLIP_STROKE_PRECIS,; 

        PROOF_QUALITY, DEFAULT_PITCH, "Times New Roman") 



    THIS.hFontMemo = CreateFont (; 

        32,0, 0,0, FW_NORMAL, 0,0,0, ANSI_CHARSET,; 

        OUT_OUTLINE_PRECIS, CLIP_STROKE_PRECIS,; 

        PROOF_QUALITY, DEFAULT_PITCH, "Arial") 



PROCEDURE  releaseFont 

    = DeleteObject (THIS.hFontMemo) 

    = DeleteObject (THIS.hFontHeader) 



PROCEDURE  clipText 

#DEFINE TRANSPARENT  1 

#DEFINE OPAQUE       2 

#DEFINE RGN_COPY     5 

    LOCAL lcText, hwnd, hdc, hStoredFont 

    hwnd = GetFocus() 

    hdc = GetWindowDC (hwnd) 

     

    = BeginPath (hdc) 

        hStoredFont = SelectObject (hdc, THIS.hFontHeader) 

        = SetBkMode (hdc, Iif(ThisForm.chkMode.Value, OPAQUE,TRANSPARENT)) 

        THIS._print (hdc, 15,25, " "+ALLTRIM(THIS.txt.Value)+" ") 



        = SelectObject (hdc, THIS.hFontMemo) 

        = SetBkMode (hdc, OPAQUE) 

        THIS._print (hdc, 15,125, " Double click to restore the original view ") 

        THIS._print (hdc, 15,160, " The form is still movable ") 

    = EndPath (hdc) 



    hRgn = PathToRegion (hdc) 

    = SetWindowRgn (hwnd, hRgn, 1) 



    = SelectObject (hdc, hStoredFont) 

    = ReleaseDC (hwnd, hdc) 



PROCEDURE  _print (hdc, X,Y, lcText) 

    = TextOut (hdc, X,Y, lcText, Len(lcText)) 



PROCEDURE  removeRegion 

    LOCAL hwnd 

    hwnd = GetFocus() 

    = SetWindowRgn (hwnd, 0, 1) 



PROCEDURE _move 

    LOCAL lnX, lnY, lnPosX, lnPosY 

    = getMousePos (@lnX, @lnY) && gets cursor absolute position 



    IF Not (ThisForm.mouseX = lnX And ThisForm.mouseY = lnY) 

    * moves the form only if cursor absolute position changed 

        lnPosX = ThisForm.Left + (lnX - ThisForm.mouseX) 

        lnPosY = ThisForm.Top + (lnY - ThisForm.mouseY) 

        ThisForm.Move (lnPosX, lnPosY) 

         

        * stores the current 

        ThisForm.mouseX = lnX 

        ThisForm.mouseY = lnY 

    ENDIF 



ENDDEFINE 



PROCEDURE  decl 

    DECLARE INTEGER GetWindowDC IN user32 INTEGER hwnd    

    DECLARE INTEGER GetFocus IN user32 

    DECLARE INTEGER ReleaseDC IN user32; 

        INTEGER hwnd, INTEGER hdc 



    DECLARE INTEGER SelectObject IN gdi32; 

            INTEGER hdc, INTEGER hObject 



     DECLARE INTEGER DeleteObject IN gdi32 INTEGER hObject 



    DECLARE INTEGER SetBkMode IN gdi32; 

        INTEGER hdc, INTEGER iBkMode 



    DECLARE INTEGER TextOut IN gdi32; 

        INTEGER hdc, INTEGER x, INTEGER y,; 

        STRING  lpString, INTEGER nCount 



    DECLARE INTEGER CreateFont IN gdi32; 

        INTEGER nHeight, INTEGER nWidth,; 

        INTEGER nEscapement, INTEGER nOrientation,; 

        INTEGER fnWeight, INTEGER fdwItalic,; 

        INTEGER fdwUnderline, INTEGER fdwStrikeOut,; 

        INTEGER fdwCharSet,; 

        INTEGER fdwOutputPrecision,; 

        INTEGER fdwClipPrecision,; 

        INTEGER fdwQuality,; 

        INTEGER fdwPitchAndFamily,; 

        STRING  lpszFace 



    DECLARE INTEGER BeginPath IN gdi32 INTEGER hdc 

    DECLARE INTEGER EndPath IN gdi32 INTEGER hdc 

    DECLARE INTEGER PathToRegion IN gdi32 INTEGER hdc 



    DECLARE SetWindowRgn IN user32; 

        INTEGER hWnd, INTEGER hRgn, INTEGER bRedraw 



    DECLARE INTEGER GetCursorPos IN user32 STRING @ lpPoint 



PROCEDURE getMousePos (x, y) 

    LOCAL lcBuffer 

    lcBuffer = Repli(Chr(0), 8) 

    = GetCursorPos (@lcBuffer) 

    x = buf2dword(SUBSTR(lcBuffer, 1,4)) 

    y = buf2dword(SUBSTR(lcBuffer, 5,4)) 



FUNCTION buf2dword (lcBuffer) 

RETURN Asc(SUBSTR(lcBuffer, 1,1)) + ; 

       Asc(SUBSTR(lcBuffer, 2,1)) * 256 +; 

       Asc(SUBSTR(lcBuffer, 3,1)) * 65536 +; 

       Asc(SUBSTR(lcBuffer, 4,1)) * 16777216

************************************************************************************************
 Otra manera de ver las fuentes del PC


DO decl  

#DEFINE GMEM_FIXED                 0 
#DEFINE LF_FACESIZE               32 
#DEFINE FW_NORMAL                400 
#DEFINE DEFAULT_CHARSET            1 
#DEFINE OUT_DEFAULT_PRECIS         0 
#DEFINE CLIP_DEFAULT_PRECIS        0 
#DEFINE DEFAULT_QUALITY            0 
#DEFINE DEFAULT_PITCH              0 
#DEFINE CF_SCREENFONTS             1 
#DEFINE CF_INITTOLOGFONTSTRUCT    64 
#DEFINE CF_EFFECTS               256 
#DEFINE CF_FORCEFONTEXIST      65536 


    LOCAL lcChooseFont, lcLogFont, hLogFont, lcFontFace 


    lcLogFont = num2dword(16) +; 
        num2dword(0)  +; 
        num2dword(0)  +; 
        num2dword(0)  +; 
        num2dword(FW_NORMAL) +; 
        Chr(1) +; 
        Chr(0) +; 
        Chr(0) +; 
        Chr(DEFAULT_CHARSET)     +; 
        Chr(OUT_DEFAULT_PRECIS)  +; 
        Chr(CLIP_DEFAULT_PRECIS) +; 
        Chr(DEFAULT_QUALITY)     +; 
        Chr(DEFAULT_PITCH)       +; 
        PADR("Times New Roman"+Chr(0),32) 

    lnLogFontSize = 60 
    hLogFont = GlobalAlloc(GMEM_FIXED, lnLogFontSize) 

    DECLARE RtlMoveMemory IN kernel32 As String2Heap; 
        INTEGER Destination, STRING @ Source,; 
        INTEGER nLength 
    = String2Heap (hLogFont, @lcLogFont, lnLogFontSize) 


    lcChooseFont = num2dword(60) +; 
        num2dword(0) +; 
        num2dword(0) +; 
        num2dword(hLogFont) +; 
        num2dword(0) +; 
        num2dword(CF_SCREENFONTS + CF_EFFECTS +; 
            CF_INITTOLOGFONTSTRUCT + CF_FORCEFONTEXIST) +; 
        num2dword(0) +; 
        num2dword(0) +; 
        num2dword(0) +; 
        num2dword(0) +; 
        num2dword(0) +; 
        num2dword(0) +; 
        num2dword(0) +; 
        num2dword(0) +; 
        num2dword(0) 

    IF ChooseFont (@lcChooseFont) <> 0 

        DECLARE RtlMoveMemory IN kernel32 As Heap2String; 
            STRING @Dest, INTEGER Source, INTEGER nLength 


        = Heap2String (@lcLogFont, hLogFont, lnLogFontSize) 

        ? "*** CHOOSEFONT Structure:" 
        ? "Point size:", buf2dword(SUBSTR(lcChooseFont, 17,4)) 
        ? "RGB color: ", buf2dword(SUBSTR(lcChooseFont, 25,4)) 
         
        ? 
        ? "*** LOGFONT Structure:" 
        ? "Font Weight:", buf2dword(SUBSTR(lcLogFont, 17,4)) 
        ? "Italic:     ", Iif(Asc(SUBSTR(lcLogFont, 21,1))=0, "No","Yes") 
        ? "Underline:  ", Iif(Asc(SUBSTR(lcLogFont, 22,1))=0, "No","Yes") 
        ? "Strikeout:  ", Iif(Asc(SUBSTR(lcLogFont, 23,1))=0, "No","Yes") 
         
        lcFontFace = SUBSTR(lcLogFont, 29) 
        lcFontFace = SUBSTR(lcFontFace, 1, AT(Chr(0),lcFontFace)-1) 
        ? "Font Face:  ", lcFontFace 
    ENDIF 

    = GlobalFree (hLogFont) 
RETURN 

PROCEDURE  decl 
    DECLARE INTEGER ChooseFont IN comdlg32 STRING @lpcf 
    DECLARE INTEGER GlobalFree IN kernel32 INTEGER hMem 
    DECLARE INTEGER GlobalAlloc IN kernel32; 
        INTEGER wFlags,; 
        INTEGER dwBytes 

FUNCTION  num2dword (lnValue) 
#DEFINE m0       256 
#DEFINE m1     65536 
#DEFINE m2  16777216 
    LOCAL b0, b1, b2, b3 
    b3 = Int(lnValue/m2) 
    b2 = Int((lnValue - b3*m2)/m1) 
    b1 = Int((lnValue - b3*m2 - b2*m1)/m0) 
    b0 = Mod(lnValue, m0) 
RETURN Chr(b0)+Chr(b1)+Chr(b2)+Chr(b3) 

FUNCTION  buf2dword (lcBuffer) 
RETURN Asc(SUBSTR(lcBuffer, 1,1)) + ; 
    Asc(SUBSTR(lcBuffer, 2,1)) * 256 +; 
    Asc(SUBSTR(lcBuffer, 3,1)) * 65536 +; 
    Asc(SUBSTR(lcBuffer, 4,1)) * 16777216 


************************************************************************************************
* 2 dicas para obter o diretorio do window
1.)  GETENV("SystemRoot") 

2.)
WshShell = CreateObject( "WScript.Shell" )
Dir_Win = WshShell.ExpandEnvironmentStrings("%WINDIR%")

************************************************************************************************
Remove Buttons from the Print Preview Toolbar

LOCAL lcResourceFileStem
IF '05.'$VERSION()  && 	Foxtools required in VFP5
	SET LIBRARY TO HOME()+'foxtools.fll'
ENDIF
SET SAFETY OFF

lcResourceFileStem = ADDBS(JUSTPATH(SYS(2005)))+JUSTSTEM(SYS(2005))
SET RESOURCE OFF
* Copy the current resource file to NoPrint which is
* used to store changes to the Print Preview toolbar.
COPY FILE (lcResourceFileStem + ".dbf") ;
	TO noprint.DBF
COPY FILE (lcResourceFileStem + ".fpt") ;
	TO noprint.fpt

* Remove current settings by deleting all records in the table.
USE noprint.DBF EXCLUSIVE
ZAP
USE
CLOSE ALL

* Create a table to use for a simple report and put some data in it.
DELETE FILE PrintTest.DBF
CREATE TABLE PrintTest (NAME C(30), Address C(20), City C(20), State C(2))
INSERT INTO PrintTest VALUES ("Jodie Garber", "1234 Jones St", "Phoenix", "AZ")
INSERT INTO PrintTest VALUES ("Holly Johnson", "675 Smith St", "Chicago", "IL")
INSERT INTO PrintTest VALUES ("Jack Reacher", "968 Duvall Street", "Key West", "FL")
INSERT INTO PrintTest VALUES ("Beau Borken", "1515 Main St", "York", "MT")

* Create a report and preview it.
CREATE REPORT PrintTest FROM PrintTest COLUMN<BR/>
USE IN PrintTest
SET RESOURCE TO noprint.DBF
REPORT FORM PrintTest PREVIEW NOWAIT
IF '05.'$VERSION()  && 	Turn off Foxtools in VFP5
	SET LIBRARY TO
ENDIF
RETURN
					
Right-click the Title bar of the Print Preview toolbar, and then click Customize. If the Print Preview toolbar is docked, you can right-click between the buttons of the toolbar.
Under Categories, click Print Preview, and then click the Print button and drag it off the toolbar.
Click the Close button to close the Customize Toolbar dialog box.
Click the Close button on the Print Preview toolbar to close the Print Preview toolbar.
Type the following command in the Command window:
SET RESOURCE OFF




************************************************************************************************
Algunas veces nos puede interesar Saber el Estado que Tiene Alguna ventana, como por ejemplo, si es visible, Minimizada, maximizada. 


Este es un ejemplo de como obtener dicha informacion: 


Public oForm
oForm=Newobject("form1")
oForm.Show(1)
Return

Define Class form1 As Form
	Height = 157
	Width = 374
	DoCreate = .T.
	AutoCenter = .T.
	Caption = "Verificando El Estado de las Ventanas"
	TitleBar = 0
	Name = "Form1"
	Add Object command1 As CommandButton With ;
		Top = 85, ;
		Left = 48, ;
		Height = 27, ;
		Width = 84, ;
		Caption = "Verificar", ;
		TabIndex = 4, ;
		Name = "Command1"
	Add Object label1 As Label With ;
		FontBold = .T., ;
		BackStyle = 0, ;
		Caption = "Texto", ;
		Height = 17, ;
		Left = 12, ;
		Top = 51, ;
		Width = 36, ;
		TabIndex = 2, ;
		Name = "Label1"
	Add Object cTexto As TextBox With ;
		Height = 23, ;
		Left = 49, ;
		TabIndex = 3, ;
		Top = 48, ;
		Width = 311, ;
		Name = "cTexto"
	Add Object cVis As Checkbox With ;
		Top = 83, ;
		Left = 229, ;
		Height = 17, ;
		Width = 73, ;
		FontBold = .T., ;
		AutoSize = .T., ;
		BackStyle = 0, ;
		Caption = "Es Visible", ;
		Value = 0, ;
		TabIndex = 6, ;
		ReadOnly = .T., ;
		Name = "cVis"
	Add Object cMax As Checkbox With ;
		Top = 104, ;
		Left = 229, ;
		Height = 17, ;
		Width = 114, ;
		FontBold = .T., ;
		AutoSize = .T., ;
		BackStyle = 0, ;
		Caption = "Esta Maximizada", ;
		Value = 0, ;
		TabIndex = 7, ;
		ReadOnly = .T., ;
		Name = "cMax"
	Add Object cMin As Checkbox With ;
		Top = 128, ;
		Left = 228, ;
		Height = 17, ;
		Width = 110, ;
		FontBold = .T., ;
		AutoSize = .T., ;
		BackStyle = 0, ;
		Caption = "Esta Minimizada", ;
		Value = 0, ;
		TabIndex = 8, ;
		ReadOnly = .T., ;
		Name = "cMin"
	Add Object command2 As CommandButton With ;
		Top = 120, ;
		Left = 48, ;
		Height = 27, ;
		Width = 84, ;
		Caption = "Salir", ;
		TabIndex = 5, ;
		Name = "Command2"
	Add Object label2 As Label With ;
		FontBold = .T., ;
		FontSize = 12, ;
		BackStyle = 0, ;
		Caption = (Thisform.Caption), ;
		Height = 22, ;
		Left = 41, ;
		Top = 12, ;
		Width = 291, ;
		TabIndex = 1, ;
		ForeColor = Rgb(63,134,220), ;
		Name = "Label2"
	Procedure command1.Click
		Declare Long IsZoomed In "user32" Long handle
		Declare Long IsIconic In "user32" Long handle
		Declare Long FindWindow In "User32" String Clase, String texto
		Declare Long IsWindowVisible In "user32" Long Handle
		Local nHandle
		With Thisform
			nHandle = FindWindow(.Null.,Alltrim(.cTexto.Value))
			If nHandle = 0
				Wait Window "Ventana No Encontrada..."
				Return
			Endif
			.cVis.Value = IsWindowVisible(nHandle)
			.cMax.Value = IsZoomed(nHandle)
			.cMin.Value = IsIconic(nHandle)
		Endwith
	Endproc
	Procedure cTexto.LostFocus
		If Len(Alltrim(This.Text))=0
			Thisform.SetAll("Value",-1,"CheckBox")
		Endif
	Endproc
	Procedure command2.Click
		Clear Dlls
		Thisform.Release
	Endproc
Enddefine

************************************************************************************************
Cansado de codificar largas y tediosas instrucciones INSERT para utilizarlas via SPT?, 
aquí te decimos como hacerlo un poco mas fácil. 


En dias pasado se comentaba en los foros de noticias de Microsoft, si se podría utilizar la 
cláusula FROM MEMVAR dentro de sentencias enviadas via SQL Pass Through (SPT): 

Select MiCursor
SCATTER MEMVAR
SQLExec(lnConnHandle,"INSERT INTO miTablaSQL FROM MEMVAR")




Esto no es posible, ya que nisiquiera el controlador ODBC de VFP da la posibilidad de hacerlo, ni hablar de cualquier otro cómo puede ser MS-SQL Server. 
Claro está, la vistas remotas podría ser la solución, pero puede que el requisito para resolver cierto problemas (como el tener cientos de tablas, lo que nos tendría cientos de vistas creadas y quizás despues no se usaran) no nos permite hacerlo. 
Por tal motivo propongo una idea para crear sentencias INSERT para ser enviadas via SPT. TextMerge puede ser una solución viable: 

FUNCTION CrearInsert(tcCursor, tcTabla)
   LOCAL lnFields,; && Numero de campos del cursor
         laFields,; && Arreglo con la estructura del cursor
         lcInsertQuery && Cadena que contendrá el INSERT
   DIMENSION laFields[1]
   lcInsertQuery=SPACE(0)
   **** Hacemos algunas validaciones ****
   **** Si no se incluye el nombre del cursor o de la tabla
   **** Se utilizará el ALIAS() en ambos casos

   tcCursor = IIF(TYPE('tcCursor')#'C' OR EMPTY(tcCursor),ALIAS(), tcCursor)
   tcTabla  = IIF(TYPE('tcTabla') #'C' OR EMPTY(tcTabla),tcCursor,tcTabla)
   
   **** Obtenemos la información del cursor 
   lnFields = AFIELDS(laFields,tcCursor)
   IF lnFields > 0 
      **** Creamos la instrucción INSERT(Campo,Campo2...CampoN) ****
      SET TEXTMERGE ON
      SET TEXTMERGE TO MEMVAR lcInsertQuery NOSHOW 
      INSERT INTO << tcTabla >>(
      FOR I=1 TO lnFields
         << laFields[i,1] >>,
      ENDFOR
      SET TEXTMERGE TO
      lcInsertQuery=SUBSTR(lcInsertQuery,1,LEN(lcInsertQuery)-1) + ')'

      **** Agregamos la cláusula VALUES(?Campo1, ?Campo2... ?CampoN) ****
      SET TEXTMERGE TO MEMVAR lcInsertQuery NOSHOW ADDITIVE
       VALUES (
      FOR I=1 TO lnFields
         ?<< tcCursor >>.<< laFields[i,1] >>,
      ENDFOR
      SET TEXTMERGE TO
      SET TEXTMERGE OFF
      lcInsertQuery=SUBSTR(lcInsertQuery,1,LEN(lcInsertQuery)-1)+ ')'
   ENDIF
   RETURN lcInsertQuery
ENDFUNC




Muy bien, ya tenemos la función ahora veremos un caso práctico en el cual utilizarlo. 
Supongamos que tenemos un numero indeterminado de tablas VFP cuyos registros serán insertadas al servidor de base de datos via SPT. Donde la tabla tiene la siguiente estructura: 

MiTabla (iID int, dFecha date, iClienteID int, iSeccionID int, yImporte Y) 


USE miTabla IN 0
lcInsert = CrearInsert("Mitabla","Ventas")




La cadena lcInsert contendrá lo siguiente: 

INSERT INTO Ventas( IID, DFECHA, ICLIENTEID, ISECCIONID, YIMPORTE) VALUES(?MiTabla.IID,?MiTabla.DFECHA,?MiTabla.ICLIENTEID,?MiTabla.ISECCION,?MiTabla.YIMPORTE) 

Ahora podemos utilizar esta instrucción para mandarla via SPT: 


USE MiTabla IN 0
lcInsert = CrearInsert("Mitabla","Ventas")
lcRegistros = trans( RECCOUNT("MiTabla"))
SCAN
    WAIT WINDOW "Insertando registro " + TRANS(recno())+ "/"+lcRegistros NOWAIT
    =SQLExec(lnConnHandle,lcInsert)
ENDSCAN
WAIT WINDOW "Proceso Finalizado"




Lo anterior es un ejemplo sencillo donde quizas pueda hacerse manualmente, pero imaginate si dicha tabla(s) tienen 50 campos, o incluso, se tienen 100 tablas? , 
aquí es donde este proceso de crear Insert via TEXTMERGE ayudará en demasía. Espero que este tip les sea de utilidad. 


************************************************************************************************
Public oForm
oForm=Createobject("form1")
oForm.Show
Return

Define Class Form1 As Form
	Height = 147
	Width = 351
	AutoCenter = .T.
	BorderStyle = 2
	Caption = "Cambiando El Estado de las Ventanas"
	TitleBar = 0
	DoCreate = .T.
	Name = "Form1"
	Add Object Command1 As CommandButton With ;
		Top = 72, ;
		Left = 252, ;
		Height = 27, ;
		Width = 84, ;
		Caption = "Cambiar", ;
		TabIndex = 3, ;
		Name = "Command1"
	Add Object label1 As Label With ;
		FontBold = .T., ;
		BackStyle = 0, ;
		Caption = "Texto", ;
		Height = 17, ;
		Left = 12, ;
		Top = 39, ;
		Width = 36, ;
		TabIndex = 1, ;
		Name = "Label1"
	Add Object cTexto As TextBox With ;
		Height = 23, ;
		Left = 49, ;
		TabIndex = 2, ;
		Top = 36, ;
		Width = 287, ;
		Name = "cTexto"
	Add Object cVis As Checkbox With ;
		Top = 72, ;
		Left = 48, ;
		Height = 17, ;
		Width = 114, ;
		FontBold = .T., ;
		AutoSize = .T., ;
		BackStyle = 0, ;
		Caption = "Ocultar/Mostrar", ;
		Value = 0, ;
		TabIndex = 6, ;
		Name = "cVis"
	Add Object cMax As Checkbox With ;
		Top = 96, ;
		Left = 48, ;
		Height = 17, ;
		Width = 143, ;
		FontBold = .T., ;
		FontName = "Arial", ;
		AutoSize = .T., ;
		BackStyle = 0, ;
		Caption = "Restaurar/Maximizar", ;
		Value = 0, ;
		TabIndex = 7, ;
		Name = "cMax"
	Add Object cMin As Checkbox With ;
		Top = 120, ;
		Left = 48, ;
		Height = 17, ;
		Width = 176, ;
		FontBold = .T., ;
		AutoSize = .T., ;
		BackStyle = 0, ;
		Caption = "Minimizar (Barra de Tareas)", ;
		Value = 0, ;
		TabIndex = 8, ;
		Name = "cMin"
	Add Object command2 As CommandButton With ;
		Top = 107, ;
		Left = 252, ;
		Height = 27, ;
		Width = 84, ;
		Caption = "Salir", ;
		TabIndex = 4, ;
		Name = "Command2"
	Add Object label2 As Label With ;
		FontBold = .T., ;
		FontSize = 12, ;
		BackStyle = 0, ;
		Caption = (Thisform.Caption), ;
		Height = 22, ;
		Left = 30, ;
		Top = 12, ;
		Width = 291, ;
		TabIndex = 5, ;
		ForeColor = Rgb(63,134,220), ;
		Name = "Label2"
	Procedure Command1.Click
		Declare Long FindWindow In "user32"  ;
		String lpClassName, String lpWindowName
		Declare Long PostMessage In "user32" ;
		Long Handle, Long  wMsg, Long wParam, Long Lparam
		Declare Long ShowWindow In "user32" ;
		Long Handle, Long nCmdShow
		Declare Long IsZoomed In "user32" ;
		Long handle
		Declare Long IsWindowVisible In "user32" ;
		Long Handle
		Local nHandle
		With Thisform
			nHandle = FindWindow(.Null.,Alltrim(.cTexto.Value))
			If nHandle = 0
				Wait Window "Ventana No Encontrada..."
				Return
			Endif
			If .cMax.Value=1 Or .cMin.Value=1
				.cVis.Value = 1
			Endif
			If .cMax.Value =0 And .cMin.Value=0
				ShowWindow(nHandle,.cVis.Value) &&visible o invisible segun la opcion
			Endif
			If .cMax.Value =1
				ShowWindow(nHandle,3)
			Endif
			If .cMin.Value =1
				ShowWindow(nHandle,2)
			Endif
		Endwith
	Endproc
	Procedure command2.Click
		Clear Dlls
		Thisform.Release
	Endproc
Enddefine


************************************************************************************************
 Funcion de Extraccion de Caracteres. Maneja una Cadena como si fuera un arreglo 
de elementos separados por un separador. 

Espero les ayude.


** 
** Libreria de Desarrollo:  lmLIBRE.  Enero de 1997.
** AUTHOR: Lucindo Mora. lucindom@yahoo.com
** Lenguaje: CLIPPER 5.01, Foxpro 2.6. - Visual Foxpro6 y 7.
** Rutina: Funcion de Extraccion de Caracteres.
** Maneja una Cadena como si fuera un arreglo 
** de elementos separados por un separador.
**     Ejemplo: lmStrExt("UNO,DOS,TRES,CUATRO", ",", 3) devolvera la cadena "TRES".

FUNCTION lmStrExt
      PARA lmmsg, lmsrc, lmpos
      LOCAL lmex0, lmex1, lmex2
         lmpos = Max(floor(lmpos),1)
         lmex0 = IIF(lmpos>1,ATC(lmsrc, lmmsg, lmpos-1)+lenc(lmsrc),1)
         lmex1 = ATC(lmsrc, lmmsg, lmpos) -1
         IF lmex1 < 0 .AND. (lmex0 > 1 .OR. lmpos = 1)
            lmex1 = LEN(lmmsg)
         ENDIF
   RETURN SUBS( lmmsg, MIN(lmex0,LEN(lmmsg)), MAX(lmex1-lmex0+1,0))	
ENDFUNC

************************************************************************************************
Hace unos dias vi una pregunta que me llamo la atencion en el foro de 
SQL Server, alguien pregunto como podia hacer para buscar fragmentos de codigo 
dentro de todos los procedimientos almacenados de una base de datos, 
bueno, escribi este codigo que hace eso, espero les ayude, a mi ya me sirvio mucho, jeje. 




Declare @objname nvarchar(776)
Create table ##Listado (Objname nvarchar(776))
declare Lista cursor for
 Select name from sysobjects
 where xtype='P'
 open lista
 Fetch lista into @objname
  while @@fetch_status=0
   Begin
   if exists(Select 1 from syscomments
    where id = object_id(@objname) and encrypted= 0
    and Patindex('%COLOCA AQUI LO QUE QUIERES BUSCAR%',text)<>0)
    begin
     insert ##listado select @objname
    end
   Fetch lista into @objname
   End

 Close Lista
 Deallocate Lista

Select * from ##listado
drop table ##listado

************************************************************************************************
 Cuando estamos trabajando en C/S y queremos enviar una sentencia SQL al servidor debemos disponer de una conexión. Esta rutina intenta obtenerla desde las áreas ya abiertas. 



function GetConnHandle()
   local lnConn
   lnConn = -1
   for i = 1 to aused( laOpenView )
      if cursorgetprop('SourceType', laOpenView[i,1]) = 2		&& vista remota
         lnConn = cursorgetprop('ConnectHandle', laOpenView[i,1])
         exit
     endif
   endfor	
   return m.lnConn
endfunc

************************************************************************************************
 Recientemente me tope con un Caso, en el que necesitaba extraer el Ciertas Partes de una Pagina HTML de un servidor web. 



Mi Primer Problema era como poder obtener el codigo dicho archivo, como hago para guardarlo Con Formato HTML y como Hago Para Quitar todo el formato HTML y obtener una version Solo Texto. 

Asi que utilizando Internet Explorer logre el Objetivo. 

Aca Pongo una Funcion que pasandole como Primer Parametro La url y dependiendo de lo que necesitemos, 1 para el html y 2 version solo texto, nos ayudara en esta tarea. 

Como Ejemplo Grabo las pagina Principal de Portalfox en el C: en Formato HTML y en Formato TXT 


Strtofile(Verhtml('www.portalfox.com',1), "c:portalfox.htm",0)
*Strtofile(Verhtml('www.portalfox.com',2), "c:portalfox.txt",0)

Function Verhtml
   Lparameters cUrl, nOpcion
   Local Texto, oIE, cResul, oDoc
   If Type("oIE")<>'O'
      oIE = Createobject("internetexplorer.application")
   Endif
   oIE.Navigate("about:blank")
   oIE.navigate(cUrl)
   Texto ='Cargando Pagina'
   Do While oIE.busy
      Wait Window Texto Time(0.1)
   Enddo
   oDoc = oIE.Document
   Texto = Type('oDoc.body')
   If nOpcion=1
      cResul = oDoc.body.innerHTML()
   Else
      cResul = oDoc.body.innerText()
   ENDIF
   oDoc = .null.
   Release oDoc
   oIE.Quit
   Release oIE
   Return cResul


************************************************************************************************
 Con esta API sabremos como inicio Windows. 





DECLARE INTEGER GetSystemMetrics IN "user32";
   LONG nIndex

#DEFINE SM_CLEANBOOT 67

INIWIN = GetSystemMetrics(SM_CLEANBOOT)
IF INIWIN=1
   MESSAGEBOX("No se puede ejecutar el        sistema bajo Modo a Prueba de Fallos",48,"ERROR")
   QUIT
ELSE
   IF INIWIN=2
      MESSAGEBOX("No se puede ejecutar el     sistema bajo Modo a Prueba de Fallos",48,"ERROR")
      QUIT
   ENDIF
ENDIF


************************************************************************************************
 Esta es una manera simple de hacer que tu aplicación se actualice a si misma. No requiere de un lanzador o "laucher".

El problema principal es salirse del sistema, actualizarlo y volver a entrar 
en él mismo... bueno, así lo solucioné: 


* Chequea si hay nueva versión --- este es
* cuento aparte, desde un servidor local,
* o lejano (FTP), si hay devuelve
* un ejecutable con el
*nombre nuevo.exe en el directorio del sistema.

IF oSistema.HayNuevaVersion()  
* El ejecutable (actual) del sistema
    cParams = Sistema.DirectorioSistema+"EPF.exe" 

* Ejecuto un actualizador
 RUN /N Actualizador.exe "&cParams"

 Quit && Salgo del sistema, para que pueda actualizarlo.
ENDIF


EL programa actualizador.exe no es más que esto: 


LPARAMETERS ExeSistema
Local ExeRespaldo, Exenuevo
ExeNuevo = JUSTPATH(ExeSistema)+"nuevo.exe"
WAIT WINDOW "Actualizando la versión "+exesistema + "/"+exenuevo
INKEY(2) && Espero un tiempo para que el sistema que lo llamó se haya
terminado.

exeRespaldo = JUSTPATH(ExeSistema)+"Old.exe"

IF !FILE(ExeSistema) OR !FILE(Exenuevo)
    *Aqui hay que enviar error
 QUIT
ENDIF

**** Renombro las actualizaciones y respaldos respectivos
IF FILE(exeRespaldo)
 DELETE FILE "&exeRespaldo"
ENDIF

RENAME "&ExeSistema" TO "&exeRespaldo"
RENAME "&Exenuevo" TO "&ExeSistema"

* Ejecuto nuevamente el sistema, ahora en la nueva versión
RUn /N "&ExeSistema"
WAIT CLEAR
QUIT && Abandono

************************************************************************************************
Aqui esta el código para hacerlo mediante API.


DECLARE Integer SQLConfigDataSource IN odbccp32.dll ; 
Integer, Short, String @, String @ 

ODBC_ADD_SYS_DSN = 1

lc_driver = "Microsoft Visual FoxPro Driver" + CHR(0) 
lc_dsn = "dsn=Bases Bodega1" + CHR(0) + ; 
"BackgroundFetch=Yes" + CHR(0) + ; 
"Description=descripcion de la conexion" + CHR(0) + "Exclusive=No" + CHR(0) +;
"SourceDb=
uta.dbc" + CHR(0) +;
"Sourcetype=DBC" 
IF SQLConfigDataSource(0, ODBC_ADD_SYS_DSN, @lc_driver, @lc_dsn) = 1 
RETURN .T. && OK 
ENDIF 
RETURN .F. && error

************************************************************************************************
 Algunos Softwares escriben en el Archivo de configuraciones del Win.ini que es el archivo de configuraciones de windows. Este archivo contiene mucha informacion importante en el sistema, este se encuentra en c:/windows/win.ini en Win9x y en c:/Winnt/win.ini en windows NT+ 


Las APIs que usaremos para esta tarea son: 


Declare long WriteProfileString IN "kernel32" ;
   string Seccion, String Clave , String Valor

Declare long GetProfileInt IN "kernel32" ;
   String Seccion, string Clave, long nDefault


el codigo para usarlas es: 

Para Escribir 

?WriteProfileString("PortalFox", "Pagina", "http://www.portalfox.com")


Para Leer el Valor 

?GetProfileInt("PortalFox", "Pagina", 0)

************************************************************************************************
Algunas veces necesitamos saber si por ejemplo el nombre del archivo que nos da el usuario cumple con algun criterio para nombres que deseamos mantener.

Digamos: 

Usuario="2002_123.Ext" 
y nuestro criterio es: 
Criterio ="????-???.*" 
como saber si se cumple ? 


Declare long PathMatchSpec IN "shlwapi.dll" string pszFile, string pszSpec

?PathMatchSpec("C:/dir/archivo.txt","*.t?t")
?PathMatchSpec("C:/dir/archivo.tft","*.t?t")
?PathMatchSpec("archivo.tft","*.t?t")
?PathMatchSpec("C:/dir/archivo.txr","*.t?t")
?PathMatchSpec("archivo.txr","*.t?t")


El Primer Parametro es la cadena que queremos comprobar con el criterio, que es el segundo parametro, en este caso puede tener cualquier cosa de nombre pero la extension debe empezar con t, la segunda letra no importa, la tercera debe ser t. 

El archivo, puede o no existir, lo que esta api hace es realizar una busqueda como la que se hace en DOS con el dir, digamos DIR ???_*.txt 

Lo cual nos devolveria todos los archivos que empiezen con 3 caracteres cualquiera, que el cuarto sea un "_", el resto no importaria, pero de extension TXT. 
 
 
 

************************************************************************************************
 Esta API nos permite saber si un directorio esta vacio o no. 



Si se le pasa como parametro un directorio que no esta vacio, o que no existe devolvera Cero (por ello el uso de Directory()), si esta vacio, devolvera 1 


Declare long PathIsDirectoryEmpty IN "shlwapi.dll" String pszPath

Variable="c:/uno"
if Directory(variable)
  ? PathIsDirectoryEmpty(Variable)
else
 mkdir &variable
 ? PathIsDirectoryEmpty(Variable)
endif


************************************************************************************************
Esta Función sirve para encriptar. 
Posee dos parametros 
1º cadena a encriptar 
2º Es la opción para encriptar o desencriptar se maneja con un 1 (uno) o un 2 (dos)


*****************************
FUNCTION CRYPT(ORIGEN,OPCION)
*****************************
DECLARE A[10]

IF OPCION=1
   A[1]=CHR(ASC(SUBSTR(ORIGEN,1,1))+100)
   A[2]=CHR(ASC(SUBSTR(ORIGEN,2,1))+101)
   A[3]=CHR(ASC(SUBSTR(ORIGEN,3,1))+103)
   A[4]=CHR(ASC(SUBSTR(ORIGEN,4,1))+109)
   A[5]=CHR(ASC(SUBSTR(ORIGEN,5,1))+111)
   A[6]=CHR(ASC(SUBSTR(ORIGEN,6,1))+112)
   A[7]=CHR(ASC(SUBSTR(ORIGEN,7,1))+102)
   A[8]=CHR(ASC(SUBSTR(ORIGEN,8,1))+105)
   A[9]=CHR(ASC(SUBSTR(ORIGEN,9,1))+116)
   A[10]=CHR(ASC(SUBSTR(ORIGEN,10,1))+104)
ELSE
   A[1]=CHR(ASC(SUBSTR(ORIGEN,1,1))-100)
   A[2]=CHR(ASC(SUBSTR(ORIGEN,2,1))-101)
   A[3]=CHR(ASC(SUBSTR(ORIGEN,3,1))-103)
   A[4]=CHR(ASC(SUBSTR(ORIGEN,4,1))-109)
   A[5]=CHR(ASC(SUBSTR(ORIGEN,5,1))-111)
   A[6]=CHR(ASC(SUBSTR(ORIGEN,6,1))-112)
   A[7]=CHR(ASC(SUBSTR(ORIGEN,7,1))-102)
   A[8]=CHR(ASC(SUBSTR(ORIGEN,8,1))-105)
   A[9]=CHR(ASC(SUBSTR(ORIGEN,9,1))-116)
   A[10]=CHR(ASC(SUBSTR(ORIGEN,10,1))-104)
ENDIF

************************************************************************************************
Oi Pedro,

A função ALINES() pode fazer o parsing da string para você. Ela provê inclusive a facilidade de definir o caractere delimitador dos valores. O código abaixo coloca os valores de "lcString" em um array chamado "laValores":


lcString = "18,21,33,45,150,999"
ALINES(laValores, lcString, .T., ",")

LIST MEMORY LIKE laValores

************************************************************************************************
Deseas saber que puertos tienes disponibles en tu Pc ? 

DO decl 
? "Testing port COM1:", TestPort("COM1") 
? "Testing port COM2:", TestPort("COM2") 
? "Testing port COM3:", TestPort("COM3") 
? "Testing port COM4:", TestPort("COM4") 

FUNCTION TestPort (lcPort) 
#DEFINE OPEN_EXISTING 3 
#DEFINE GENERIC_READ 2147483648 && 0x80000000 
#DEFINE FILE_FLAG_OVERLAPPED 1073741824 && 0x40000000 
#DEFINE INVALID_HANDLE_VALUE -1 

LOCAL hPort 
hPort = CreateFile (lcPort, GENERIC_READ, 0,0,; 
OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0) 

= CloseHandle(hPort) 
RETURN (hPort <> INVALID_HANDLE_VALUE) 

PROCEDURE decl 
DECLARE INTEGER CreateFile IN kernel32; 
STRING lpFileName, INTEGER dwAccess, INTEGER dwShareMode,; 
INTEGER lpSecurityAttr, INTEGER dwCreationDisp,; 
INTEGER dwFlagsAndAttr, INTEGER hTemplateFile 

DECLARE INTEGER CloseHandle IN kernel32 INTEGER hObject 

************************************************************************************************
 Este Ejemplo Demuestra Lo Facil que es por medio de api saber cuantos Milisegundos tomo llevar a cabo X Accion. Util para mostrar tiempos al usuario. 



Declare CopyMemory In "kernel32"  String pDst, String pSrc, Long ByteLen
Declare Long GetTickCount In "kernel32"
Local sSave As String, Cnt As Long, T As Long, Pos As Long, Length As Long
mStr = "Cadena"
Length = Len(mStr)
sSave = Space(5000 * Length)
T = GetTickCount()
Pos = 1
sSave = Space(5000 * Length)
For Cnt = 1 To 500
	mStr = "Cadena"+mstr
	Pos = Pos + Length*(1.10002311222648999+cnt-(pos*cnt/cnt*(pos*.51000009)))
Endfor
Wait Window "Tiempo tomado Para El Primer Proceso: " + Str(GetTickCount() - T) + " Milisegundos"
T = GetTickCount()
Pos = 0
For Cnt = 1 To 5000
	Pos = Pos + Len(mStr)
	pos = pos * 300 +cnt
	pos = val(STR((((pos*1.00112354)+10*cnt)/pos)))
	pos = (pos *cnt / (cnt/pos+1)-Pos *1230.115645894634)
	sSave = Space(cnt*2)
Endfor
Wait Window "Tiempo Tomado Para El Segundo Proceso: "+ Str(GetTickCount() - T) + " Milisegundos"


************************************************************************************************
 Con estas sencillas lineas podremos obtener la IP de una URL mediante uan instancia del control ActiveX Winsock


olSocket = CREATEOBJECT('MSWinsock.Winsock')
olSocket.LocalPort = 80
olSocket.RemotePort = 80
olSocket.RemoteHost = 'www.portalfox.com'
olSocket.Connect


Luego de que la conexion este establecida, puedes obtener la IP del server 
remoto preguntando por la propiedad olSocket.RemoteHostIP. El estado de la 
conexion puedes saberlo medante la propiedad State del objeto Winsock 
(oSocket.State), la cual tiene los siguientes estados: 

0 = Cerrado (Predeterminado) 
1 = Abierto 
2 = Escuchando 
3 = Conexion Pendiente 
4 = Resolviendo Host 
5 = Host Resuelto 
6 = Conectando 
7 = Conectado 
8 = Cerrando la Conexion 
9 = Error 

Puedes leer mas en la ayuda del control Winsock, que seguramente esta 
instalado con tu VFP. 


************************************************************************************************
Cuantas veces no hemos querido ir a una pagina web desde un boton, imagen o cualquier otro objeto ? 
Cuantas veces no hemos querido mostrar nuestra pagina web despues de realizar la instalacion del programa ? 

Aqui se expone una manera simple de hacerlo: 


DECLARE INTEGER ShellExecute IN shell32.dll ; 
INTEGER hndWin, STRING cAction, STRING cFileName, ; 
STRING cParams, STRING cDir, INTEGER nShowWin 

ShellExecute(0,"open","http://www.misitio.com","","",1) 

************************************************************************************************
 Esto es una parte del código, de mucha ayuda para calcular el número de meses entre dos fechas:


ldDate1 = DATE(2002,12,01)
ldDate2 = DATE(2003,05,15)
? (YEAR(ldDate2) + MONTH(ldDate2) / 12 ;
  - YEAR(ldDate1) - MONTH(ldDate1) / 12) * 12

************************************************************************************************
 Cuando hacemos aplicaciones que envian Emails de notificacion, nuestra carpeta de elementos enviados se llena y es dificil de los mensajes salgan con el tiempo. 



Aqui hay una manera de evitar eso. 


#DECLARE O_INBOXFOLDER
#DECLARE O_DELETEDITEMS
LOCAL loOutlook, loSpace, loInbox, loDeletedItems
loOutlook= CREATEOBJECT("Outlook.Application")
loSpace = loOutlook.GetNameSpace("MAPI")
loInbox = loSpace.GetDefaultFolder(O_INBOXFOLDER)
The default Inbox folder
loDeletedItems = loSpace.GetDefaultFolder(O_DELETEDITEMS)
FOR EACH loMsg IN loInbox.Items
   * poner aqui las condiciones que se deseen
   loMsg.Move(loDeletedItems)
ENDFOR


************************************************************************************************
 Una manera de ver los contactos de OutLook (Por Alex Feldstein) 




#define olFoldersContacts 10
#define olContactItem 2


oOutlook = CreateObject("Outlook.Application")
oNameSpace = oOutlook.GetNameSpace("MAPI")
oContacts = oNameSpace.GetDefaultFolder(olFoldersContacts)


CREATE CURSOR ContactInfo ;
(Nombre C(15), Apellido C(20), ;
Direccion M, Tel C(20)) 

* ver los nombres de contactos
FOR EACH oContact IN oContacts.Items
  WITH oContact
    cNombre = .FirstName
    cApellido = .LastName
    cTel = .PrimaryTelephoneNumber
    cDireccion = .HomeAddress


    * o seguir mirando las lista de posibles
    * multiples direcciones y teléfonos para
    * este contacto

    INSERT INTO ContactInfo ;
      (Nombre, Apellido, ;
      Direccion, Tel) ;
    VALUES (cNombre, cApellido, ;
      cDireccion, cTel)
  ENDWITH
NEXT

* ver los resultados
BROWSE

************************************************************************************************
 En esta ocasion envio un pequeño programa que nos permite habilitar /deshabilitar cualquier ventana buscandola por medio de su Caption, y tambien podemos cambiar el Caption de cualquier ventana!!! 



Al Deshabilitar una ventana no podremos dar Click ni escribir nada en esa ventana, ni siquiera restaurarla o maximizarla, cerrarla, moverla, minimizarla, etc. (útil si queremos que no puedan cerrar X ventana mientras corremos un proceso) 

Solo hay que tener cuidado cuando busquen la ventana, tiene que ir exactamente igual que como aparece en el título de la misma, mayúsculas y minúsculas. 

Aquí el código: 


Public oFormulario
oFormulario=Newobject("Ventanas")
oFormulario.Show
Return

Define Class Ventanas As Form
	Top = 118
	Left = 121
	Height = 177
	Width = 465
	DoCreate = .T.
	Caption = "Manipulando Ventanas desde VFP"
	Name = "Manipula_Ventanas"

	Add Object deshabilita As CommandButton With ;
		Top = 136, ;
		Left = 24, ;
		Height = 27, ;
		Width = 84, ;
		Caption = "Deshabilitar", ;
		TabIndex = 5, ;
		Name = "deshabilita"

	Add Object Titulo_ventana As TextBox With ;
		BackStyle = 1, ;
		Height = 23, ;
		Left = 24, ;
		TabIndex = 2, ;
		Top = 30, ;
		Width = 420, ;
		Name = "Titulo_ventana"

	Add Object Habilitar As CommandButton With ;
		Top = 136, ;
		Left = 108, ;
		Height = 27, ;
		Width = 84, ;
		Caption = "Habilitar", ;
		TabIndex = 6, ;
		Name = "Habilitar"

	Add Object label1 As Label With ;
		AutoSize = .T., ;
		FontBold = .T., ;
		BackStyle = 0, ;
		Caption = "Titulo de La Ventana ", ;
		Height = 17, ;
		Left = 24, ;
		Top = 6, ;
		Width = 120, ;
		TabIndex = 1, ;
		Name = "Label1"

	Add Object Nuevo_Titulo As TextBox With ;
		BackStyle = 1, ;
		Height = 23, ;
		Left = 24, ;
		TabIndex = 3, ;
		Top = 77, ;
		Width = 420, ;
		Name = "Nuevo_Titulo"

	Add Object Cambiar As CommandButton With ;
		Top = 136, ;
		Left = 192, ;
		Height = 27, ;
		Width = 84, ;
		Caption = "Cambiar", ;
		TabIndex = 7, ;
		Name = "Cambiar"

	Add Object Estado As Label With ;
		AutoSize = .T., ;
		BackStyle = 0, ;
		Caption = "Estado de la Ventana:", ;
		Height = 17, ;
		Left = 24, ;
		Top = 112, ;
		Width = 122, ;
		TabIndex = 4, ;
		Name = "Estado",;
		Tag ="Estado de la Ventana:"

	Add Object label3 As Label With ;
		AutoSize = .T., ;
		FontBold = .T., ;
		BackStyle = 0, ;
		Caption = "Nuevo Titulo para la Ventana ", ;
		Height = 17, ;
		Left = 24, ;
		Top = 58, ;
		Width = 166, ;
		TabIndex = 1, ;
		Name = "Label3"

	Procedure Load
		Declare Long IsWindowEnabled In "user32" Long handle
		Declare Long EnableWindow In "user32" Long handle, Long fEnable
		Declare Integer FindWindow In WIN32API String cNULL, String cWinName
		Declare Long SetWindowText In "user32" Long handel, String lpString
	Endproc

	Procedure deshabilita.Click
		Local Estado, retval As Long, handle As Long
		handle = FindWindow(.Null.,Alltrim(Thisform.Titulo_ventana.Value))
		If handle=0 Or Empty(Thisform.Titulo_ventana.Text)
			Wait Window 'Ventana no Encontrada'
			Return
		Endif
		retval = EnableWindow(handle, 0)
		Estado= IsWindowEnabled(handle)
		If Estado=0
			Thisform.Estado.Caption =Alltrim(Thisform.Estado.Tag)+' Deshabilitada'
		Else
			Thisform.Estado.Caption =Alltrim(Thisform.Estado.Tag)+' Habilitada'
		Endif
	Endproc

	Procedure Habilitar.Click
		Local Estado, retval As Long, handle As Long
		handle = FindWindow(.Null.,Alltrim(Thisform.Titulo_ventana.Value))
		If handle=0 Or Empty(Thisform.Titulo_ventana.Text)
			Wait Window 'Ventana no Encontrada'
			Return
		Endif
		retval = EnableWindow(handle, 1)
		Estado= IsWindowEnabled(handle)
		If Estado=0
			Thisform.Estado.Caption =Alltrim(Thisform.Estado.Tag)+' Deshabilitada'
		Else
			Thisform.Estado.Caption =Alltrim(Thisform.Estado.Tag)+' Habilitada'
		Endif
	Endproc

	Procedure Cambiar.Click
		Local Estado, retval As Long, handle As Long
		handle = FindWindow(.Null.,Alltrim(Thisform.Titulo_ventana.Value))
		If handle=0
			Wait Window 'Ventana no Encontrada'
			Return
		Endif
		If Empty(Thisform.Nuevo_Titulo.Text) Or Empty(Thisform.Titulo_ventana.Text)
			Wait Window 'Debe escribir un Caption valido'
			Return
		Endif
		SetWindowText(handle, Alltrim(Thisform.Nuevo_Titulo.Text))
		Estado= IsWindowEnabled(handle)
		If Estado=0
			Thisform.Estado.Caption =Alltrim(Thisform.Estado.Tag)+' Deshabilitada'
		Else
			Thisform.Estado.Caption =Alltrim(Thisform.Estado.Tag)+' Habilitada'
		Endif
	Endproc
Enddefine

************************************************************************************************
 Con esta API, podemos saber si una determinada PC esta activa en la red y ver si es accesible. 




Declare long IsDestinationReachable IN "SENSAPI.DLL"  ;
   string lpszDestination, ;
   long lpQOCInfo

? IsDestinationReachable("Nombre_Maquina", 0 )


************************************************************************************************
 Para variar más de APIS como dice uno de nuestros colegas. Aquí les presento una función que es capáz de detectar si existe tarjeta de sonido instalada en nuestro sistema.


*-- Declaramos la api correspondiente
Declare Integer waveOutGetNumDevs in winmm.dll

Resultado = waveOutGetNumDevs()
If Resultado > 0 Then
	Messagebox( "Posee tarjeta de sonido" )
Else
	Messagebox( "No Posee tarjeta de sonido" )
Endif

************************************************************************************************
 Muchos de nosotros estamos cansados de los tipicos pormularios rectangulares, SIEMPRE LO MISMO!! 

Ahora podemos hacer un formulario triangular de una maera simple ... 



Coloca un formulario y escribe en el INIT: 


#DEFINE C_ALTERNATE	1
#DEFINE C_WINDING	2

declare integer CreatePolygonRgn in gdi32 ;
   string@ ppoints, integer npoints, integer nfillmode
declare integer SetWindowRgn in user32 ;
   integer hWnd, integer hRgn , integer bRedraw

cPoints = num2dword(0)+num2dword(0);
   +num2dword(THIS.Width+(sysmetric(13)*1));
   +num2dword(THIS.Height+sysmetric(9)+(sysmetric(12)*2));
   +num2dword(0)+num2dword(THIS.Height+sysmetric(9)+(sysmetric(12)*2))

set library to foxtools.fll

lnw = _WFindTitl(THIS.Caption)
lnh = _WhToHWnd(lnw)
lnr = CreatePolygonRgn(@cPoints, 3, C_WINDING)

SetWindowRgn(lnh, lnr, 1)
return


Luego, crea un .PRG llamado num2dword y coloca lo siguiente: 


procedure Num2dword
lparameter tnNum
local c0,c1,c2,c3
lcresult = chr(0)+chr(0)+chr(0)+chr(0)
if tnNum < (2^31 - 1) then
   c3 = chr(int(tnNum/(256^3)))
   tnNum = mod(tnNum,256^3)
   c2 = chr(int(tnNum/(256^2)))
   tnNum = mod(tnNum,256^2)
   c1 = chr(int(tnNum/256))
   c0 = chr(mod(tnNum,256))
   lcresult = c0+c1+c2+c3
else
   * no es un numero valido para DWORD
endif
return lcresult


************************************************************************************************
Preciso baixar da Net uns arquivos. Precisa ser via http.
Que componente devo usar ?
WebBrowser ?
ITP ?

Como fazer ? 

***
LOCAL loXMLHTTP as "MSXML2.XMLHTTP"
loXMLHTTP = CREATEOBJECT("MSXML2.XMLHTTP")
loXMLHTTP.open("GET", "http://www.intranet.com.br/arquivo.zip",.F.)
loXMLHTTP.Send()
strtofile(loXMLHTTP.responseBody,"arquivo.zip")
***
Oi, Fabiano.

Desculpe pela intromissão, é que achei muito interessante.

Fiz um teste aqui aqui e deu o erro:
OLE error code 0x800c0005: Unknown COM code.
Creio que esse erro se deu porque o arquivo não http://www.intranet.com.br/arquivo.zip existe.

Mudei então a linha 

loXMLHTTP.open("GET", "http://www.intranet.com.br/arquivo.zip",.F.)
para um arquivo existente e funcionou que foi uma maravilha.

Fiz outro teste mudando para um arquivo cujo site exige senha de acesso e ficou simplesmente travado.

PERGUNTO:
Há um meio de passar o login e senha para o método OPEN ?

************************************************************************************************
 Esta API nos permite saber si el Internet Explorer esta trabajando con conexion a Internet 
o el usuario marco la casilla que indica "Trabajar sin conexion" lo que impide que una pagina web cargue. 



Si nos devuelve 0, es que el Internet Explorer esta trabajando con conexion, si nos devuelve 1 o mas, es que NO tiene conexion. 


Declare long InetIsOffline IN url.dll long dwFlags

? InetIsOffline(0)



************************************************************************************************
Muchas veces requerimos realizara cálculos estadísticos dentro de FOX, aqui les remito unas formulas que implemente, espero les sean de apoyo. 

Como por todos es sabido, se requiere que pasen como parametro un arreglo con los datos.


Function Media(Datos)
	Local T, Num, Med
	T=0, Num=Len(Datos)
	Med=0.0
	For t=1 to Num
		Med=Med+Datos[t]
	Next
	Med=Med/Num
	Return Med

Function Desv_est(Datos)
	Local Num, t, Dest, Med, Temp

	Num=Len(Datos)
	t=0
	Dest=0
	Med=0.0
	Temp=0
	Med=Media(Datos)
	For t=1 to Num
		Dest=Dest+((Datos[t]-Med)*(Datos[t]-Med))
	Next
	Dest=Dest/num
	Dest=Sqrt(Dest)
	Return Dest

Function Mediana(Datos)
	Local Num, dtemp
	Num=Len(Datos)
	*-- Clonamos los datos
	=ACOPY(datos, dTemp)
	Rapido(dTemp)
	** Aqui utiliza tu método favorito para ordenar
	** Si quieres implemetarlo la fórmula es
	** n + 2 * (n / 2) + 4 * (n / 4) + 8 * (n / 8) + ... + n * (n / n)
	Return dtemp[Num/2]

Function Encontrar_Moda(Datos)
	Local AntModa, AntCont, Num, t
	AntModa=0
	AntCont=0
	Num=Len(Datos)
	cont=1
	For t=1 to Num
		md=Datos[t]
		cont=1
		For w=t+1 to num
			if (md==datos[w]) Then
				cont=Cont+1
			endif
		Next
		if (Cont > Antcont)
			antmoda=md
			antcont=cont
		endif
	Next
	Return AntModa


************************************************************************************************
Existe una manera facil y practica de mostrar las ventanas de Windows, asi nos es muy util trabajar con configuraciones personalizadas y atajos interesantes. 




loComDialog = newobject( "mscomdlg.commondialog" )
 

locomdialog.ShowFont     && Mostrar Fuente
locomdialog.ShowPrinter()   && Mostrar Impresora
locomdialog.ShowColor()  && Mostrar Colores
locomdialog.ShowSave()  && Mostrar Guardar 
loComDialog.ShowOpen  && Mostrar Abrir

************************************************************************************************


Este codigo nos permite modificar el menu que aparece cuando damos click sobre el icono que aparece en la izquierda de la barra de titulo, o bien cuando damos click derecho en la barra de tareas sobre nuestra aplicacion. 

Este ejemplo quita las opciones Cerrar y Restaurar de dicho menu, adicional a ello agrega unas opciones y separadores 

Tambien, hago uso de una API, que sirve para mostrar el menu contextual de alguna ventana 
TrackPopupMenuex en la posicion que le indiquemos. Tal como se ve ese menu, aparecera en el menu de control. 

Por cierto, para restaurar el menu a su estado normal deberemos hacer 


HSYSMENU = GETSYSTEMMENU(APPLICATION.HWND, 1)


El 1 significa "Restaurar" y devuelve una cadena vacia, el 0, por el contrario, obtiene el handle hacia el menu, de la ventana que le pidamos. 


DECLARE LONG GetSystemMenu IN "user32" LONG handle, LONG bRevert
DECLARE LONG GetMenuItemCount IN "user32" LONG hMenu
DECLARE LONG DrawMenuBar IN "user32" LONG handle
DECLARE LONG RemoveMenu IN "user32" LONG HMENU, LONG NPOSITION, LONG WFLAGS
DECLARE LONG AppendMenu IN "user32" LONG hMenu, LONG wFlags, LONG wIDNewItemm, STRING lpNewItem
Declare long TrackPopupMenuEx IN "user32" long hMenu , long wFlags , long x ,long y , long handle, long lptpm 
CLEAR 
MF_CHECKED = 0X8
MF_APPEND = 0X100
TPM_LEFTALIGN = 0X0
MF_DISABLED = 0X2
MF_GRAYED = 0X1
MF_SEPARATOR = 0X800
MF_STRING = 0X0
MF_BYPOSITION = 0X400
MF_REMOVE = 0X1000
TPM_RETURNCMD = 0x100
TPM_RIGHTBUTTON = 0x2
LOCAL HSYSMENU AS LONG
LOCAL  NCNT AS LONG
HSYSMENU = GETSYSTEMMENU(APPLICATION.HWND, 1)
HSYSMENU = GETSYSTEMMENU(APPLICATION.HWND, 0)
IF HSYSMENU <>0 THEN
	NCNT = GETMENUITEMCOUNT(HSYSMENU)
	a = 0
	IF NCNT <>0 THEN
		REMOVEMENU (HSYSMENU, NCNT - 1, MF_BYPOSITION +MF_REMOVE )
		REMOVEMENU (HSYSMENU, NCNT - 2, MF_BYPOSITION +MF_REMOVE )
		REMOVEMENU (HSYSMENU, NCNT - 5, MF_BYPOSITION +MF_REMOVE )
		REMOVEMENU (HSYSMENU, NCNT - 7, MF_BYPOSITION +MF_REMOVE )
		APPENDMENU (HSYSMENU, MF_STRING, 0, "Jorge Mota")
		APPENDMENU (HSYSMENU, MF_SEPARATOR, 0, 0)
		APPENDMENU (HSYSMENU, MF_GRAYED +MF_DISABLED, 0, "Prueba ...")
		APPENDMENU (HSYSMENU, MF_SEPARATOR, 0, 0)
		APPENDMENU (HSYSMENU, MF_CHECKED, 0, "www.portalfox.com")
		APPENDMENU (HSYSMENU, MF_SEPARATOR, 0, 0)
		DRAWMENUBAR(APPLICATION.HWND)
		ret = TrackPopupMenuex(HSYSMENU, TPM_LEFTALIGN +TPM_RETURNCMD +TPM_RIGHTBUTTON, 50, 50, application.HWnd, 0)
	ENDIF
ENDIF


************************************************************************************************
 Este programita nos demuestra lo facil que es poner scrollbars planas en nuestros Forms, tal como el WinAce o el Office XP. 



El codigo que interesa para aplicar a un Form creado visualmente, es el del Activate. 

Y crear la propiedad Ultimo para el Form. 


ALGO = CREATEOBJECT("BARRAS_PLANAS")
ALGO.VISIBLE = .T.
READ EVENTS 
DEFINE CLASS BARRAS_PLANAS AS form
	showwindow = 2
	autocenter = .t.
	Top = 0
	Left = 0
	Height = 192
	Width = 289
	ScrollBars = 3
	Caption = "BARRAS PLANAS"
	Name = "BARRAS_PLANAS"
	ALTOB= 25
	ANCHO = 50
	ULTIMO = 20
	ADD OBJECT IZQUIERDA AS COMMANDBUTTON WITH ;
		Top = 105, ;
		Left = 920, ;
		Height = 31, ;
		Width = 133, ;
		Caption = "A LA IZQUIERDA: 920", ;
		Name = "IZQUIERDA"
		PROCEDURE IZQUIERDA.CLICK()
			CLEAR EVENTS
			THISFORM.Release 
		ENDPROC

	PROCEDURE INIT
	LOCAL CICLO
	FOR CICLO = 1 TO 10
			THIS.ADDOBJECT("COMMAND"+ALLTRIM(STR(CICLO)),"BOTON")
	ENDFOR
	THISFORM.SETALL('VISIBLE', .T.)
		this.SetViewPort(this.Width, this.Height) 
	ENDPROC

	PROCEDURE activate
		WS_VSCROLL = 0X200000
		WS_HSCROLL = 0X100000
		GWL_STYLE = (-16)
		WSB_PROP_CYVSCROLL = 0X1
		WSB_PROP_CXHSCROLL = 0X2
		WSB_PROP_CYHSCROLL = 0X4
		WSB_PROP_CXVSCROLL = 0X8
		WSB_PROP_CXHTHUMB = 0X10
		WSB_PROP_CYVTHUMB = 0X20
		WSB_PROP_VBKGCOLOR = 0X40
		WSB_PROP_HBKGCOLOR = 0X80
		WSB_PROP_VSTYLE = 0X100
		WSB_PROP_HSTYLE = 0X200
		WSB_PROP_WINSTYLE = 0X400
		WSB_PROP_PALETTE = 0X800
		WSB_PROP_MASK = 0XFFF
		FSB_FLAT_MODE = 2
		FSB_ENCARTA_MODE = 1
		FSB_REGULAR_MODE = 0
		SB_HORZ = 0
		SB_VERT = 1
		SB_BOTH = 3
		FALSE = 0
		TRUE = 1
		ESB_ENABLE_BOTH = 0X0
		ESB_DISABLE_BOTH = 0X3
		ESB_DISABLE_LEFT = 0X1
		ESB_DISABLE_RIGHT = 0X2
		ESB_DISABLE_UP = 0X1
		ESB_DISABLE_DOWN = 0X2
		ESB_DISABLE_LTUP = ESB_DISABLE_LEFT
		ESB_DISABLE_RTDN = ESB_DISABLE_RIGHT
		SIF_RANGE = 0X1
		SIF_PAGE = 0X2
		SIF_POS = 0X4
		SIF_ALL = (SIF_RANGE + SIF_PAGE + SIF_POS)
		Declare LONG GetWindowLong IN "user32" long handle, LONG nIndex 
		Declare LONG SetWindowLong IN "user32" LONG HANDLE, LONG nIndex, LONG dwNewLong 
		Declare LONG InitializeFlatSB IN "comctl32" LONG HANDLE
		Declare LONG UninitializeFlatSB IN "comctl32" LONG HANDLE
		Declare LONG FlatSB_SetScrollProp IN "comctl32" LONG HANDLE, LONG Nindex, LONG newValue, INTEGER fRedraw 
		Declare LONG FlatSB_EnableScrollBar IN "comctl32" LONG HANDLE, LONG wSBflags, LONG wArrows 
		Declare LONG FlatSB_SetScrollPos IN "comctl32"  LONG HANDLE, LONG codIGO, LONG nPos, LONG fRedraw
		Declare LONG FlatSB_SetScrollRange IN "comctl32" LONG HANDLE, LONG CODIGO,LONG nMinPos, LONG nMaxPos, LONG fRedraw 
		Declare FlatSB_ShowScrollBar IN "comctl32" LONG HANDLE,LONG CODIGO,LONG fShow 
		InitializeFlatSB(this.hWnd)
		FlatSB_SetScrollProp(this.hWnd, WSB_PROP_VSTYLE, FSB_FLAT_MODE, False)
		FlatSB_EnableScrollBar(THIS.hWnd, SB_VERT, ESB_ENABLE_BOTH )
		FlatSB_SetScrollRange(THIS.hWnd, SB_VERT, 20, 80, False)
		FlatSB_SetScrollPos(THIS.hWnd, SB_VERT, 60, FALSE)
		FlatSB_ShowScrollBar(THIS.hWnd, SB_HORZ, TRUE)
		LOCAL Ret As Long
		Ret = GetWindowLong(THIS.hWnd, GWL_STYLE)
		Ret = Ret +WS_VSCROLL +WS_HSCROLL
		SetWindowLong(THIS.hWnd, GWL_STYLE-1, Ret)
		IF this.ShowWindow = 2
			this.ScrollBars = 0
		endif
		this.VScrollSmallChange =10
		IF this.ultimo <>20
			this.SetViewPort(this.Width, this.Height) 
			this.ultimo = 20
		endif
	ENDPROC

	PROCEDURE Scrolled
		LPARAMETERS nDirection
		THISFORM.Refresh 
	ENDPROC

	PROCEDURE UNLOAD
		CLEAR EVENTS 
	ENDPROC
ENDDEFINE
DEFINE CLASS 'BOTON' AS CommandButton 
	PROCEDURE Click
		CLEAR EVENTS 
		THISFORM.Release 
	ENDPROC
	PROCEDURE Init
		THIS.Height = THIS.PARENT.ALTOB
		THIS.Width  = THIS.PARENT.ANCHO 
		THIS.Left = 58
		THIS.Top = THIS.Parent.ULTIMO
		THIS.Parent.ULTIMO = THIS.Parent.ULTIMO+THIS.Parent.ALTOB+5
		THIS.Caption = ALLTRIM(STR(THIS.TOP))
		THIS.Visible = .T.
	ENDPROC
ENDDEFINE


Las variables definidas alli, son las propiedades que podemos modificar por ejemplo el color de la barra horizontal, usaremos esta variable 

WSB_PROP_HBKGCOLOR 
en el segundo parametro en FlatSB_SetScrollProp 

Este codigo esta en VFP 7, si quereis usarlo en VFP 6 o anterior, necesitaran la funcion findwindow de la api, para obtener el handle de la ventana a la que le quieran aplicar el formato. 

Saludos desde Guatemala. Sigan disfrutando de las APIs, que aun no me aburro de buscar novedades jeje ;) 


************************************************************************************************
 Usando la API de Windows es así ... 




DECLARE LONG WinExec IN kernel32 ;
   STRING lpCmdLine , ;
   LONG nCmdShow

cComando=" regsvr32.exe micontrol.ocx"

WinExec(cComando, 0)


0 - no se muestra (se ejecuta, pero no se hace visible) 
1 - la Ventana se Muestra Normal 
2 - minimizado 
3 - Maximizado 
4 - Tamaño Normal, pero no le entrega el Foco al Programa/Comando que se ejecuta 

Esto se puede implementar mejor, colocando este código en una función y pasando por parámetros el comando a ejecutar y el forma de visualización. 
Los comandos a ejecutar pueden ser de DOS o WINDOWS. 

************************************************************************************************
 Mostrar la ventana Acerca de... propia de Windows pero con el icono personalizado. 



Para mostrar el icono de nuestro ejecutable utiliza sys(16,1). 


Acerca_De( home(1)+"Vfp7.exe", "Nombre del programa", "Texto adicional")

procedure Acerca_De(cfileexe as string, ctitulo as string, ccaption as string) as void

	local tnHWnd as integer, nicon as integer, cruta as string

	cruta = cfileexe+chr(0)

	declare integer ExtractIcon in shell32 ;
		integer hInst ,;
		string lpszExeFileName ,;
		integer nIconIndex

	declare long ShellAbout in Shell32 ;
		long nHwnd,;
		string cTitulo,;
		string cCaption,;
		long nIcon

	tnHWnd = _screen.hwnd
	nicon = ExtractIcon(@tnHWnd, @cruta, 0)

	ShellAbout(@tnHWnd ,@ctitulo,@ccaption, @nicon)

endproc

************************************************************************************************
Esta es una Funcion que busca una ventana en base a su Caption, y la hace parpadear.

Escrito para VFP6 (me imagino que correra con VFP5). Escribi esto, ya que hasta VFP7 se da soporte al handle de los forms.

Adapte la rutina de Luis María Guayán que servia para evitar que una aplicacion se cargara mas de una vez, para poder obtener el handle de la ventana.

Declare FlashWindow IN user32.dll ;


   LONG handle,;


   Long bInvert




DECLARE INTEGER FindWindow IN WIN32API ;


  STRING cNULL, ;


  STRING cWinName




if !F_ActivaWin("Calculadora")


    MESSAGEBOX("No se encontro la aplicacion")


ENDIF




FUNCTION F_ActivaWin(cCaption)


LOCAL nHWD


nHWD = FindWindow(0, cCaption)


IF nHWD > 0


    FlashWindow(nHWD, .t.)


    RETURN .T.


ELSE


    RETURN .F.


ENDIF
************************************************************************************************
 Dos formas de abrir archivos de Excel desde Visual FoxPro.

1. Mediante el objeto Shell.Application 


lcFile = GETFILE("XLS")
loShell = CREATEOBJECT("Shell.Application")
loShell.ShellExecute(lcFile)
RELEASE loShell


2. Mediante Automation 


lcFile = GETFILE("XLS")
loExcel = CREATEOBJECT("Excel.Application")
loExcel.Workbooks.Open(lcFile)
loExcel.Application.Visible = .T.
RELEASE loExcel

************************************************************************************************
Quien no ha visto esas animaciones que tienen algunas aplicaciones cuando inician o terminan? 

Como transparencia, que se van deslizando ... 

Bueno es posible hacerlo con esta API ... 




Declare AnimateWindow IN user32.DLL LONG HANDLE, LONG dwTime,  LONG dwFlags


Aca un prg de ejemplo: 

Es posible crear animaciones combinadas segun las tablas, digamos, deslize, de izquierda a derecha desde abajo hacia arriba (en diagonal) 
para ello el tercer parametro de la API deberia ser Izq_Der_H+Abajo_Arriba es posible hacer varias combinaciones. 


objeto = CREATEOBJECT("ANIMACIONES")
objeto.visible =.t.
READ EVENTS

DEFINE CLASS ANIMACIONES AS form
	Height = 320
	Width = 481
	ShowWindow = 2
	DoCreate = .T.
	AutoCenter = .T.
	Caption = "MUESTRA DE ANIMACIONES"
	Name = "ANIMACIONES"
	ADD OBJECT command1 AS commandbutton WITH ;
		Top = 113, ;
		Left = 131, ;
		Height = 27, ;
		Width = 84, ;
		Caption = "animar", ;
		Name = "Command1"
	PROCEDURE Load
		_SCREEN.WindowState = 1
		Izq_Der_H			= 0x1  		&&Animacion de izquierda hacia derecha (Horizontal). 
		Der_Izq_H			= 0x2  		&&Animacion de derecha hacia Izquierda (Horizontal).
		Arriba_Abajo      	= 0x4  		&&Animacion de Arriba hacia abajo (Vertical).
		Abajo_arriba      	= 0x8  		&&Animacion de abajo hacia Arriba (Vertical).
		centro				= 0x10 		&&Aparece desde el centro la ventana.
		Ocultar				= 0x10000   &&oculta la ventana.
		Activar				= 0x20000 	&&Activa la ventana.
		Deslizar 			= 0x40000   &&Usa un efecto de Deslice.
		transparente		= 0x80000   &&Efecto de Transparencia.
		Declare AnimateWindow IN user32.DLL LONG HANDLE, LONG dwTime,  LONG dwFlags 
		AnimateWindow(THIS.hwnd, 1000,deslizar+izq_der_h+arriba_abajo)
	ENDPROC
	PROCEDURE Unload
		CLEAR EVENTS 
	ENDPROC
	PROCEDURE command1.Click
		THISFORM.Visible =.F. 
		Izq_Der_H			= 0x1  		&&Animacion de izquierda hacia derecha (Horizontal). 
		Der_Izq_H			= 0x2  		&&Animacion de derecha hacia Izquierda (Horizontal).
		Arriba_Abajo      	= 0x4  		&&Animacion de Arriba hacia abajo (Vertical).
		Abajo_arriba      	= 0x8  		&&Animacion de abajo hacia Arriba (Vertical).
		centro				= 0x10 		&&Aparece desde el centro la ventana.
		Ocultar				= 0x10000   &&oculta la ventana.
		Activar				= 0x20000 	&&Activa la ventana.
		Deslizar 			= 0x40000   &&Usa un efecto de Deslice.
		transparente		= 0x80000   &&Efecto de Transparencia.
		Declare AnimateWindow IN user32.DLL LONG HANDLE, LONG dwTime,  LONG dwFlags 
		AnimateWindow(THISFORM.hwnd, 3000,deslizar +1+8)
		THISFORM.Visible =.T.
		THISFORM.LOCKSCREEN =.F.
	ENDPROC

ENDDEFINE


************************************************************************************************
Esta API nos permite bajarnos un archivo cualquiera de Internet de una manera facil sin complicarnos. 



La URL que le pasemos, debe ir en formato Unicode, por eso se le pasa el parametro 12 al STRCONV. 


Declare DoFileDownload IN shdocvw.dll STRING lpszFile 

DoFileDownload(STRCONV("http://guatemala.portalfox.com/PortalFoxGuate.gif",12))

************************************************************************************************
 Recientemente encontré un inconveniente trabajando con un form de nivel superior que contenía una barra de herramientas. Si se quería cerrar el form desde la barra de herramientas se colgaba el Fox. Con este método se soluciona el problema (Tips Por Jorge Mota, y uso de funciones API por Pablo Almunia Sanz )

Para solucionar el problema usamos lo siguiente:

Creamos un Form de nivel superior (propiedad ShowWindow=2)
Le creamos una propiedad cToolBar

En el método Activate del Form:

----------------------------------------------------


_screen.Tag=ThisForm.Caption


If Type("ThisForm.cToolbar")!="O"


   ThisForm.cToolBar=CREATEOBJECT("MiToolBar",ThisForm)


   ThisForm.cToolBar.Dock(0)


   ThisForm.cToolBar.Show


Endif


----------------------------------------------------



Creamos ahora una nueva clase toolbar llamada "MiToolBar", con la propiedad ShowWindow establecida en "1" (En Formulario de nivel superioor)

Le agregamos una propiedad oFormRef, y le agregamos un botón.

En el método init de MiToolbar ponemos

-----------------------------------------------


Parameters oForm


ThisForm.oFormRef=oForm


----------------------------------------------



En el método Click del botón es donde usamos las API
Si en el método click del botón pusiéramos simplemente ThisForm.oFormRef.Release es donde se producía el problema. El Fox se cuelga. Compruébenlo.

En lugar de eso, en el método Click del botón ponemos:

--------------------------------------------------------


 #DEFINE WM_CLOSE  16


 DECLARE ;


      INTEGER FindWindow ;


      IN WIN32API ;


      STRING   cClassName, ;


      STRING   cWindName




    DECLARE ;


      Integer PostMessage ;


      IN WIN32API ;


      Integer  nWnd, ;


      Integer  nMsg, ;


      Integer  nParam, ;


      Integer  nParam




    nHwndNote = FindHwnd( ThisForm.oFormRef.Caption)


    =PostMessage( nHwndNote, WM_CLOSE, 0, 0 )


----------------------------------------------------------



Y necesitamos las siguientes 2 funciones:

------------------------------------------------------


PROCEDURE FindHwnd


LPARAMETER cTitle


*** Llama a aTask.PRG


FOR nCont = 1 TO aTask( "aFindHwnd" )


  *** Busca dentro de la cadena


  IF UPPER( cTitle ) $ UPPER( aFindHwnd[nCont,1] )


    RELEASE MEMORY aFindHwnd


    RETURN aFindHwnd[nCont,2]


  ENDIF


NEXT




RELEASE MEMORY aFindHwnd


RETURN 0


    

*** Constantes


#define GW_HWNDFIRST        0


#define GW_HWNDNEXT         2


#define GW_OWNER            4


#define GW_CHILD            5




PROCEDURE ATask


LPARAMETER cMatriz, lOcultos


*** Declaraciones de la funciones del API


DECLARE ;


  Integer GetWindow ;


  IN WIN32API ;


  Integer  nHwnd, ;


  Integer  nCmd


DECLARE ;


  Integer GetWindowText ;


  IN WIN32API ;


  Integer  nHwnd, ;


  String  @cString, ;


  Integer  nMaxCount


DECLARE ;


  Integer GetWindowTextLength ;


  IN WIN32API ;


  Integer  nWnd


DECLARE ;


  Integer IsWindowVisible ;


  IN WIN32API ;


  Integer  nWnd


DECLARE ;


  Integer GetDesktopWindow ;


  IN WIN32API




*** Declaración de variables


PRIVATE nFoxHwnd, nCont, nCurrWnd


PRIVATE nLength, cTmp


RELEASE MEMORY &cMatriz


PUBLIC (cMatriz)




  *** Obtención del handle del DeskTop


nHwnd = GetDesktopWindow()


nInitHwnd = GetWindow( nHwnd, GW_CHILD )




*** Esta será la primera ventana


nCurrWnd = GetWindow( nInitHwnd, GW_HWNDFIRST )


*** Inicializar contador


nCont = 0




*** Recorrer todas las ventanas


DO WHILE nCurrWnd # 0




    *** Comprobar si no tiene padre


    IF GetWindow(nCurrWnd, GW_OWNER) = 0




      *** Si debemos las ventanas ocultas


      IF IsWindowVisible( nCurrWnd ) = 1 OR lOcultos 




        *** Tamaño del título


        nLength=GetWindowTextLength(nCurrWnd)


        IF nLength > 0




          nCont = nCont + 1




          *** Obtener el título


          cTmp=REPLICATE( CHR(0), nLength+1 )


          =GetWindowText( nCurrWnd, @cTmp, nLength + 1 )


          *** Insertar un nuevo elemento


          DIMENSION &cMatriz.[nCont,2]


          &cMatriz.[nCont,1] = SUBSTR( cTmp, 1, nLength )


          &cMatriz.[nCont,2] = nCurrWnd


        ENDIF


      ENDIF


    ENDIF


    *** Obtener la siguiente ventana


	nCurrWnd = GetWindow( nCurrWnd, GW_HWNDNEXT )


ENDDO && (nCurrWnd # 0)




*** Retornar el número de procesos


RETURN nCont


----------------------------------------------------



Y listo, así funciona sin problemas

El Tip de usar el _screen.tag se lo debo a Jorge Mota, y el manejo de las funciones API se lo debo a un artículo publicado por Pablo Almunia Sanz que encontré en algún lugar de la web.

Espero que les sirva
Saludos

Ah, me olvidaba. Así como está les puede traer conflictos si hay más de una instancia del mismo form, o 2 forms con el mismo caption. Si existe esa posibilidad, deberán ver la manera de ponerle un "contador" en el caption de cada form (desde el método init). Hay un artículo reciente de Jorge Mota de donde se deduce la manera de hacer esto último.

************************************************************************************************
Con esta API podemos bloquear la estación de trabajo.


Válido solo para Windows NT4 y superior.

Declare LockWorkStation IN user32.dll




LockWorkStation()


************************************************************************************************
Esta API nos permite simular un "Crasheo" de nuestra aplicación. 




Declare FatalAppExit IN kernel32 long uAction , string lpMessageText 

FatalAppExit(0, "Lo siento, ha efectuado una operacion no valida...")


Luego de ejecutarse esta última instrucción se mostrará un MessageBox, con el título de la aplicación y el mensaje, al darle a "Ok" la aplicación se cerrará inapropiadamente .... como cuando le damos ALT+CTRL+DEL ... Finalizar tarea.... 

Util si detectamos que nuestro sistema no ha sido instalado legalmente 

Usarlo con cuidado, puede causar corrupción en datos, ya que se cierra abruptamente
************************************************************************************************
 Para saber si el usuario logueado actualmente tiene permisos admistrativos en la pc. 



Declare IsNTAdmin IN advpack.dll ;
   LONG dwReserved, ;
   LONG lpdwReserved

?IsNTAdmin(0,0)


************************************************************************************************
Cuantas veces hemos visto luego de instalar algún programa que Windows pregunta si deseamos reiniciar para que los cambios surtan efecto? ¿o luego de instalar se nos reinicia la PC, sin preguntar ? 

Bueno, la forma de hacerlo es ... 




Declare SetupPromptReboot IN setupapi.dll  long FileQueue, Long Owner, long ScanOnly


para reiniciar, preguntando si se desea proceder 


SetupPromptReboot (0, _screen.hWnd, 0)


para reiniciar sin preguntar: 


SetupPromptReboot(0, _screen.hWnd, 0)


************************************************************************************************
 Con la introduccion del Active Directory en Windows 2000 se nos abre una puerta de oportunidades como: validar usuario y contraseña contra el servidor de dominio, ver el listado de los usuarios, crear usuarios... 


Bueno para ver todos los usuarios de un dominio basta con: 


DOMINIO = GETOBJECT("WinNT://atisa")
DIMENSION LISTADO[1]
DOMINIO.FILTER = LISTADO
FOR EACH ELEMENTO IN DOMINIO
   IF UPPER(ELEMENTO.CLASS) = "USER" THEN
      ? ELEMENTO.NAME
   ENDIF
NEXT

en la parte de 


DOMINIO = GETOBJECT("WinNT://Dominio_O_MaquinaW2k")

Deberemos escribir el nombre del dominio al que queremos accesar o el nombre de la maquina de la cual queremos obtener informacion. 

En este ejemplo listamos los Usuarios, para listar los servicios basta con reemplazar la linea 


IF UPPER(GROUPOBJ.CLASS) = "USER" THEN

por 


IF UPPER(GROUPOBJ.CLASS) = "SERVICE" THEN

PARA VER LOS GRUPOS DE USUARIOS DEFINIDOS: 


IF UPPER(GROUPOBJ.CLASS) = "GROUP" THEN

Este Codigo lo probe desde Windows 2000 Professional, y me logre conectar con exito a un 

NT 4 Server SP 6, un XP SP1 y un Windows 2000 Server. 


************************************************************************************************
 Este efecto es muy comun en las aplicaciones hoy en dia tal, como MSN. que cuando nos escriben un mensaje, parpadea el titulo de una ventana en la barra de tareas. 

Desde VFP podemos hacerlo. La función que nos permite hacerlo la declaramos asi: 


Declare FlashWindow IN user32.dll ;
LONG hwnd,;
Long bInvert


Cuando querramos que nuestra aplicacion parpadee ejecutamos lo siguiente: 

Si queremos que el _screen Parpadee 

FlashWindow(application.hWnd,.t.)


Si queremos que el form lo haga 

FlashWindow(thisform.HWnd,.t.)


NOTA: FlashWindow solo hará que la ventana parpadee una sola vez, si queremos que el parpadeo persista, deberemos colocar el código en un Timer, y en el evento Activate del Form, desactivar el Timer, o que el Timer lo ejecute X veces. 

El segundo parámetro nos permite decirle si queremos que parpadee si esta activada o no. Al pasarle .T. la ventana parpadeara una sola vez, este o no activada, si le pasamos .F. parpadeara solo si la ventana esta inactiva y quedara de otro color el boton en la barra de tareas. 

Este código esta en VFP 7. Si quieren ejecutarla desde VFP 6 deberan obtener el handle de la ventana a la que le quieran aplicar el efecto. En PortalFox esta la función para hacerlo. Creo que son estas APIs: 


GetWindow
FindWindow

************************************************************************************************
 Este codigo nos muestra cada uno de los archivos que componen un proyecto. para saber que tipo es el archivo, basta con consultar la tabla que esta al final. 




_SCREEN.ADDPROPERTY('NUMERO',1)
LOCAL NUMERO, CADENA, CICLO, SELECCION
CLEAR
CADENA = ''
NUMERO = APPLICATION.PROJECTS.COUNT
SELECCION = 0
IF NUMERO = 0
	WAIT WINDOW "NO HAY NINGUN PROJECTO ABIERTO"
	RETURN
ENDIF
IF NUMERO > 1
	OBJETO = CREATEOBJECT('FORM')
	OBJETO.WINDOWTYPE = 1
	OBJETO.AUTOCENTER = .T.
	OBJETO.HEIGHT  = 135
	OBJETO.WIDTH = 380
	OBJETO.CAPTION = 'Proyectos Activos'
	OBJETO.ADDOBJECT('ETIQUETA','LABEL')
	OBJETO.ADDOBJECT('COMBO1','COMBOBOX')
	OBJETO.ADDOBJECT('aceptar','aceptar')
	OBJETO.ETIQUETA.CAPTION = 'Por Favor Seleccione el Proyecto que desea mostrar'
	OBJETO.ETIQUETA.AUTOSIZE = .T.
	OBJETO.COMBO1.WIDTH = OBJETO.WIDTH-15
	OBJETO.COMBO1.TOP = 50
	FOR CICLO = 1 TO NUMERO
		OBJETO.COMBO1.ADDITEM(ALLTRIM(APPLICATION.PROJECTS(CICLO).NAME),CICLO)
	ENDFOR
	OBJETO.SETALL('visible',.T.)
	OBJETO.COMBO1.VALUE = 1
	OBJETO.SHOW
	SELECCION = _SCREEN.NUMERO 
ENDIF

WITH APPLICATION.PROJECTS(SELECCION)
	? "NOMBRE DEL PROYECTO: " + .NAME
	CANTIDAD = .FILES.COUNT
	FOR CICLO = 1 TO CANTIDAD
		? 'Tipo: ' + ALLTRIM(.FILES(CICLO).TYPE) + ' Nombre: ' + ALLTRIM(.FILES(CICLO).NAME)
		IF INT(ciclo/30) =(ciclo/30)
			WAIT WINDOW 'PRESIONE UNA TECLA PARA CONTINUAR'
		ENDIF
	ENDFOR
ENDWITH

DEFINE CLASS ACEPTAR AS COMMANDBUTTON
	CAPTION = 'ACEPTAR'
	TOP    = 80
	LEFT   = 30
	HEIGHT = 35

	PROCEDURE CLICK
		_SCREEN.NUMERO =THIS.PARENT.COMBO1.VALUE
		THISFORM.RELEASE
	ENDPROC
ENDDEFINE


Valor Constante FoxPro.H Tipo de Archivo Y Extension 
d FILETYPE_DATABASE Base de datos, .dbc 
D FILETYPE_FREETABLE Tabla libre, .dbf 
Q FILETYPE_QUERY Consulta, .qpr 
K FILETYPE_FORM Formulario, .scx 
R FILETYPE_REPORT Informe, .frx 
B FILETYPE_LABEL Etiqueta, .lbx 
V FILETYPE_CLASSLIB Biblioteca de clases visuales, .vcx 
P FILETYPE_PROGRAM Programa, .prg 
L FILETYPE_APILIB Biblioteca de vínculos dinámicos de Visual FoxPro, .fll 
Z FILETYPE_APPLICATION Aplicación, .app 
M FILETYPE_MENU Menú, .mnx 
T FILETYPE_TEXT Archivo de texto, varias extensiones 
x FILETYPE_OTHER Otros, varias extensiones 



************************************************************************************************
 Este codigo nos muestra el caption de cada uno de los forms que actualmente esten abiertos, se puede usar para ver si lo queremos cerrar o no, dependiendo del caption del form. 



Espero os sirva... 


Local Caption_F, Ciclo
if _screen.formcount=0
    ? 'Ningun Formulario Abierto.'
    RETURN 
endif
dimension CAPTION_F [ _SCREEN.FORMCOUNT]
**Obtenemos los captions, y los metemos a la matriz
for Ciclo = 1 to _SCREEN.FORMCOUNT 
    caption_F[ciclo]=ALLTRIM(_screen.forms(ciclo).caption)
endfor

***mostramos los captions encontrados.
for Ciclo = 1 to _SCREEN.FORMCOUNT
    ? 'Numero ' +STR(CICLO)+ +' Caption: ' +caption_F[ciclo]
endfor

************************************************************************************************
Dos formas de abrir archivos de Word desde Visual FoxPro.

1. Mediante el objeto Shell.Application 


lcFile = GETFILE("DOC")
loShell = CREATEOBJECT("Shell.Application")
loShell.ShellExecute(lcFile)
RELEASE loShell


2. Mediante Automation 


lcFile = GETFILE("DOC")
loWord = CREATEOBJECT("Word.Application")
loWord.Documents.Open(lcFile)
loWord.Application.Visible = .T.
RELEASE loWord

************************************************************************************************
 Con esta sencilla utilidad, podrán subir sus archivos a su sitio WEB desde Foxpro vía FTP 

Espero les sea de utilidad. 



** 
** Como subir archivoS a un sitio via FTP  con VFP. 
**  

#DEFINE GENERIC_READ    2147483648   && &H80000000 
#DEFINE GENERIC_WRITE   1073741824   && &H40000000 

PUBLIC hOpen, hFtpSession  
DECLARE INTEGER InternetOpen IN wininet.dll;   
    STRING  sAgent,;   
    INTEGER lAccessType,;   
    STRING  sProxyName,;   
    STRING  sProxyBypass,;
    STRING  lFlags    

DECLARE INTEGER InternetCloseHandle IN wininet.dll; 
    INTEGER hInet   

DECLARE INTEGER InternetConnect IN wininet.dll;   
    INTEGER hInternetSession,;   
    STRING  sServerName,;   
    INTEGER nServerPort,;   
    STRING  sUsername,;   
    STRING  sPassword,;   
    INTEGER lService,;   
    INTEGER lFlags,;   
    INTEGER lContext   

DECLARE INTEGER FtpOpenFile IN wininet.dll; 
    INTEGER hFtpSession,; 
    STRING  sFileName,; 
    INTEGER lAccess,; 
    INTEGER lFlags,; 
    INTEGER lContext 

DECLARE INTEGER InternetWriteFile IN wininet.dll; 
    INTEGER   hFile,; 
    STRING  @ sBuffer,; 
    INTEGER   lNumBytesToWrite,; 
    INTEGER @ dwNumberOfBytesWritten 
  
** Seleccionamos el servidor FTP, con un nivel de acceso apropiado. 
** No usar un acceso anónimo. 
IF connect2ftp ("fpt.???.???", "Usuario", "Password") 
    lcSourcePath = "C:Temp"       && Directorio local 
    lcTargetPath = "archivos/"      && directorio de ftp destino 
    lnFiles = ADIR (arr, lcSourcePath + "*.htm") 

    FOR lnCnt=1 TO lnFiles 
        lcSource = lcSourcePath + LOWER (arr [lnCnt, 1]) 
        lcTarget = lcTargetPath + LOWER (arr [lnCnt, 1]) 
        ? lcSource + " -> " + lcTarget 
        ?? local2ftp (hFtpSession, lcSource, lcTarget) 
    ENDFOR 

    = InternetCloseHandle (hFtpSession)   
    = InternetCloseHandle (hOpen)  
ENDIF  

**-------------------------------------------- 
** Establecemos la conexión 
**-------------------------------------------- 
FUNCTION  connect2ftp (strHost, strUser, strPwd)  
   ** Abrimos el acceso.   
    hOpen = InternetOpen ("vfp", 1, 0, 0, 0)   

    IF hOpen = 0   
        ? "No tiene acceso a WinInet.Dll"  
        RETURN .F.  
   ENDIF  

    ** Conectando al FTP. 
    hFtpSession = InternetConnect (hOpen, strHost, 0, strUser, strPwd, 1, 0, 0)   
 
    IF hFtpSession = 0   
        ** Cerrando acceso y saliendo.   
        = InternetCloseHandle (hOpen)   
        ? "FTP " + strHost + " no está disponible"  
        RETURN .F.  
     ELSE   
         ? "Conectado a " + strHost + " como: [" + strUser + ", *****]"   
   ENDIF   
RETURN .T.  


**-------------------------------------------- 
** Copia del/los archivos 
**-------------------------------------------- 
FUNCTION local2ftp (hConnect, lcSource, lcTarget) 
    ** Copiando el archivo local al directorio remoto ftp. 
    hSource = FOPEN (lcSource) 
    IF (hSource = -1)  
        RETURN -1 
    ENDIF 

    ** Creamos el nuevo archivo 
    hTarget = FtpOpenFile(hConnect, lcTarget, GENERIC_WRITE, 2, 0) 
    IF hTarget = 0 
       = FCLOSE (hSource) 
       RETURN -2 
    ENDIF 
    lnBytesWritten = 0 
    lnChunkSize = 256    && 128, 512 
    DO WHILE Not FEOF(hSource) 
        lcBuffer = FREAD (hSource, lnChunkSize) 
        lnLength = Len(lcBuffer) 
        IF lnLength > 0 
           IF InternetWriteFile (hTarget, @lcBuffer, lnLength, @lnLength) = 1 
                lnBytesWritten = lnBytesWritten + lnLength 
                ** Podemos mostrar aquí el progreso de la operación 
           ELSE 
                EXIT 
           ENDIF 
        ELSE 
            EXIT 
        ENDIF 
   ENDDO 

   = InternetCloseHandle (hTarget) 
   = FCLOSE (hSource) 

RETURN  lnBytesWritten


************************************************************************************************
 Ante algunas consultas sobre la forma de conectarse y acceder a SQL Server utilizando ADO, acá va un ejemplo básico de su uso...


* EjemploADO.prg
* Algunos ejemplos de uso de ADO desde VFP
* Jose M. Marcenaro - 2001/11/12
* -------------------------------------------

* Para tener intellisense de estos objetos (VFP 7)
* agregué previamente la Type Library de ActiveX Data Objects
* al Intellisense Manager (Solapa Types / Type Libraries)
LOCAL loConn AS ADODB.CONNECTION
LOCAL loCmd AS ADODB.COMMAND
LOCAL loRs AS ADODB.Recordset
LOCAL lcConnString AS STRING

* conexion por seguridad integrada de Windows
lcConnString = "Provider=SQLOLEDB;Data Source=(local);Initial Catalog=Northwind;Integrated Security=SSPI"

* conexion por usuario / password de SQL Server
* lcConnString = "Provider=SQLOLEDB;Data Source=MSSQL;Initial Catalog=Northwind;User Id=sa;Password=pass;"

* abro la conexion
loConn = CREATEOBJECT("ADODB.Connection")
loConn.CursorLocation= 3 && adUseClient
loConn.OPEN(lcConnString)

* realizo un select simple
loRs = loConn.Execute("SELECT * From Products")
MostrarRecordset( loRs)
loRs.CLOSE

* creo un stored procedure para poder invocarlo despues
ON ERROR xx=0  && ignorar si ya existe el SP
loConn.Execute( "";
  +"create procedure Probar (@Inicial varchar(10)) as ";
  +"    select * from Products where ProductName like @Inicial+'%'")
ON ERROR

* invoco al SP recien creado
loRs = loConn.Execute("exec Probar 'M'")
MostrarRecordset( loRs)
loRs.CLOSE

* lo invoco mediante un objeto Command (acceso a coleccion parámetros)
loCmd = CREATEOBJECT("ADODB.Command")
loCmd.ActiveConnection = loConn
loCmd.CommandText = "Probar"
loCmd.CommandType = 4 && adCmdStoredProc
loCmd.PARAMETERS.REFRESH && obtiene parametros del SP
loCmd.PARAMETERS.ITEM(";@Inicial") = 'L'
loRs = loCmd.Execute()
MostrarRecordset( loRs)
loRs.CLOSE

RETURN

********************************************************
PROCEDURE MostrarRecordset( loRs AS ADODB.Recordset)

  LOCAL ln, li, lcStr
  lcStr = ""

  FOR ln = 1 TO 10  && primeros 10 registros como máximo
    IF loRs.EOF then
      EXIT FOR
    ENDIF
    FOR li=1 TO MIN(loRs.FIELDS.COUNT, 3) && primeros 3 campos como máximo
      lcStr = lcStr+TRANSFORM(loRs.FIELDS.ITEM(li).VALUE)+","
    NEXT
    lcStr = lcStr+CHR(13)
    loRs.MoveNext
  NEXT
  MESSAGEBOX(lcStr)

ENDPROC

************************************************************************************************
Una opción para obtener las constantes de Microsoft Office y generar en archivo de encabezado (.h) 

El siguiente código de Trevor Hancock está en el Artículo Q285396 de la Base de Conocimientos de Microsoft. 

Las constantes de MS Office están en los siguientes archivos: 


Microsoft Word 2000......: MSWord9.olb 
Microsoft Excel 2000.....: Excel9.olb 
Microsoft Access 2000....: MSAcc9.olb 
Microsoft PowerPoint 2000: MSPPT9.olb 
Microsoft Outlook 2000...: MSOutl9.olb 
Microsoft Graph 2000.....: Graph9.olb 
Microsoft Binder 2000....: MSBdr9.olb


El código en VFP es el siguiente: 


****************START CODE****************
PUBLIC oform1

oform1=NEWOBJECT("form1")
oform1.SHOW
RETURN


****************FORM CODE****************
DEFINE CLASS form1 AS FORM

  HEIGHT = 445
  WIDTH = 567
  DOCREATE = .T.
  AUTOCENTER = .T.
  BORDERSTYLE = 1
  CAPTION = ".OLB Constants Extractor"
  MAXBUTTON = .F.
  MINBUTTON = .F.
  NAME = "Form1"

  ADD OBJECT txtolbfile AS TEXTBOX WITH ;
    HEIGHT = 27, ;
    LEFT = 65, ;
    READONLY = .T., ;
    TABINDEX = 2, ;
    TOP = 6, ;
    WIDTH = 458, ;
    NAME = "txtOLBFILE"

  ADD OBJECT label1 AS LABEL WITH ;
    AUTOSIZE = .T., ;
    CAPTION = ".
    HEIGHT = 17, ;
    LEFT = 4, ;
    TOP = 11, ;
    WIDTH = 55, ;
    TABINDEX = 1, ;
    NAME = "Label1"

  ADD OBJECT cmdsave AS COMMANDBUTTON WITH ;
    TOP = 411, ;
    LEFT = 394, ;
    HEIGHT = 27, ;
    WIDTH = 84, ;
    CAPTION = "
    ENABLED = .F., ;
    TABINDEX = 6, ;
    NAME = "cmdSAVE"

  ADD OBJECT cmdquit AS COMMANDBUTTON WITH ;
    TOP = 411, ;
    LEFT = 480, ;
    HEIGHT = 27, ;
    WIDTH = 84, ;
    CAPTION = "
    TABINDEX = 7, ;
    NAME = "cmdQUIT"

  ADD OBJECT edtconstants AS EDITBOX WITH ;
    HEIGHT = 347, ;
    LEFT = 6, ;
    READONLY = .T., ;
    TABINDEX = 4, ;
    TOP = 52, ;
    WIDTH = 558, ;
    NAME = "edtConstants"

  ADD OBJECT cmdgetfile AS COMMANDBUTTON WITH ;
    TOP = 6, ;
    LEFT = 533, ;
    HEIGHT = 27, ;
    WIDTH = 26, ;
    CAPTION = "...", ;
    TABINDEX = 3, ;
    NAME = "cmdGETFILE"

  ADD OBJECT cmdextract AS COMMANDBUTTON WITH ;
    TOP = 411, ;
    LEFT = 280, ;
    HEIGHT = 27, ;
    WIDTH = 110, ;
    CAPTION = "
    ENABLED = .F., ;
    TABINDEX = 5, ;
    NAME = "cmdEXTRACT"


  PROCEDURE cmdsave.CLICK
    STRTOFILE(THISFORM.edtconstants.VALUE,PUTFILE([Header File], ;
      JUSTSTEM(THISFORM.txtolbfile.VALUE) + [.h],[.h]))
  ENDPROC


  PROCEDURE cmdquit.CLICK
    THISFORM.RELEASE
  ENDPROC


  PROCEDURE cmdgetfile.CLICK
    LOCAL lcOLBFile

    lcOLBFile = GETFILE([OLB],[OLB File],[Open])
    IF EMPTY(lcOLBFile)
      RETURN .F.
    ENDIF

    IF UPPER(RIGHT(lcOLBFile,3)) # [OLB]
      MESSAGEBOX([Invalid File],0,[])
      RETURN .F.
    ENDIF

    THISFORM.txtolbfile.VALUE = lcOLBFile
    THISFORM.cmdextract.ENABLED= .T.
  ENDPROC


  PROCEDURE cmdextract.CLICK
    WAIT WINDOW [Processing...] NOCLEAR NOWAIT
    LOCAL oTLB_INFO, oConstants, lcConstantsStr, Obj, member
    #DEFINE CRLF CHR(13) + CHR(10)

    oTLB_INFO = CREATEOBJECT([tli.typelibinfo])
    oTLB_INFO.ContainingFile = (THISFORM.txtolbfile.VALUE)

    oConstants = oTLB_INFO.Constants

    lcConstantsStr = []
    FOR EACH Obj IN oTLB_INFO.Constants
      lcConstantsStr = lcConstantsStr + CRLF + "* " + Obj.NAME + CRLF
      FOR EACH member IN Obj.Members
        lcConstantsStr = lcConstantsStr + [#DEFINE ] + ;
          member.NAME + [ ] + ;
          TRANSFORM(member.VALUE) + CRLF
      NEXT member
    NEXT Obj

    THISFORM.edtconstants.VALUE=lcConstantsStr
    THISFORM.cmdsave.ENABLED= .T.
    WAIT CLEAR
    WAIT WINDOW [Complete!] TIMEOUT 2
  ENDPROC

ENDDEFINE
****************END CODE****************

************************************************************************************************
 Con el siguiente código podemos verificar la ortografía de cualquier texto en VFP usando el corrector ortográfico de MS Word.

El siguiente código de Trevor Hancock está en el Artículo Q271819 de la Base de Conocimientos de Microsoft. 

Para probarlo, solo hay que pegar el código en un nuevo .PRG y ejecutarlo desde VFP. 


*!*********** START CODE ***********
PUBLIC oform1

oform1=CREATEOBJECT("form1")
oform1.SHOW
RETURN

**************************************
*
DEFINE CLASS form1 AS FORM

  HEIGHT = 250
  WIDTH = 375
  SHOWWINDOW = 2
  AUTOCENTER = .T.
  BORDERSTYLE = 2
  CAPTION = "VFP/Word Spell Checking"
  MAXBUTTON = .F.
  NAME = "Form1"

  ADD OBJECT edttexttocheck AS EDITBOX WITH ;
    HEIGHT = 163, ;
    LEFT = 23, ;
    TOP = 21, ;
    WIDTH = 332, ;
    NAME = "edtTextToCheck"

  ADD OBJECT cmdcheckspelling AS COMMANDBUTTON WITH ;
    TOP = 207, ;
    LEFT = 115, ;
    HEIGHT = 27, ;
    WIDTH = 149, ;
    CAPTION = "
    NAME = "cmdCheckSpelling"

  PROCEDURE findword
    *~~~~~~~~~~~~~~~~~~~~~
    * PROCEDURE FindWord
    *
    * AUTHOR: Trevor Hancock, , Microsoft Corporation
    * CREATED : 08/22/00 11:50:32 AM
    *
    * ABSTRACT: Locates an installation of MS Word using the FindExecutable API
    *           Creates a file with a .doc extension, checks the association on that
    *           file using FindExecutable, then deletes the file. FindExecutable returns
    *           the full, null terminated path to the application associated with
    *           .doc files (in this case).
    * ACCEPTS: Nothing
    * RETURNS: Full path to the application associated with .doc files on this machine.
    *~~~~~~~~~~~~~~~~~~~~~

    LOCAL lcPath, lcResult, lcFileName, llRetVal, ;
      lcCurDir, lnFileHand, lcWordPath

    lcPath = SPACE(0)
    lcResult = SPACE(128)
    llRetVal = .F.
    *!* Determine the DIR this form is running from. JUSTPATH() and ADDBS()
    *!* could be used here instead (if using VFP6), but this code will work 
    *!* in any VFP version.
    lcCurDir = SUBSTR(SYS(16,0),ATC([ ],SYS(16,0),2)+1)
    lcCurDir = SUBSTR(lcCurDir,1,RAT([],lcCurDir))

    lcFileName = lcCurDir + SYS(3) + [.doc]

    *!* Create a file with a .doc extension.
    *!* Could use STRTOFILE() here in VFP6.
    lnFileHand = FCREATE(lcFileName,0)
    = FCLOSE(lnFileHand)

    DECLARE INTEGER FindExecutable IN shell32 STRING @lcFilename, ;
      STRING @lcPath , STRING @lcResult

    *!* Determine the file association on .DOC files
    IF FindExecutable(@lcFileName, @lcPath, @lcResult) > 32
      *!* Strip off trailing chr(0)
      lcWordPath = UPPER(SUBSTR(lcResult,1,LEN(ALLTR(lcResult))-1))
      IF [WINWORD] $ lcWordPath
        llRetVal = .T.
      ENDIF
    ENDIF
    *!* Clean up after ourselves
    ERASE (lcFileName)
    RETURN llRetVal
  ENDPROC

  PROCEDURE DESTROY
    IF TYPE([goWord]) = [O]
      IF TYPE([goWordDoc]) = [O]
        goWordDoc.SAVED = .T.
        goWordDoc.CLOSE
      ENDIF
      goWord.QUIT
    ENDIF
    RELEASE goWord, goWordDoc
  ENDPROC

  PROCEDURE INIT
    *--- English
    * THIS.edtTextToCheck.VALUE = "Thhis text has mistakees in it. We will seend " +  ;
    * "it to Word and have it cheked."

    *-- Español
    THIS.edtTextToCheck.VALUE = "Ezte tecto esta escrito kon herrores ppara " +  ;
      "que Word lo chequee."

  ENDPROC

  PROCEDURE cmdcheckspelling.CLICK
    *~~~~~~~~~~~~~~~~~~~~~
    * PROCEDURE cmdcheckspelling.CheckSpelling
    *
    * AUTHOR: Trevor Hancock, Microsoft Corporation
    * CREATED : 08/22/00 12:03:46 PM
    *
    * ABSTRACT: Automates MS Word to check the spelling of text in
    *                 THISFORM.edtTextToCheck
    * ACCEPTS: Nothing
    * RETURNS: Nothing
    *~~~~~~~~~~~~~~~~~~~~~

    IF TYPE([goWord]) # [O]	&& Check if you have already instantiated Word

      IF !THISFORM.FindWord()	&& You don't have Word up, so let's locate it.
        MESSAGEBOX([Microsoft Word is either not installed or is incorrectly registered.], + ;
          0,[Word Start-Up Failed])
        RETURN .F.
      ENDIF

      *!* Change the mouse pointer for all form controls to indicate processing (opening Word)
      WITH THISFORM
        .cmdCheckSpelling.MOUSEPOINTER = 11
        .edtTextToCheck.MOUSEPOINTER = 11
        .MOUSEPOINTER = 11
      ENDWITH

      PUBLIC goWord, goWordDoc	&& Public vars for Word and Document1 in Word.
      goWord = CREATEOBJECT([WORD.APPLICATION])	&& Create Word
      WITH goWord
        .WINDOWSTATE= 0  && wdWindowStateNormal (needs to be Normal before you can move it)
        .MOVE(1000,1000)	&& Move the window out of view
        goWordDoc = .Documents.ADD
      ENDWITH

      *!* Change mouse pointers back
      WITH THISFORM
        .cmdCheckSpelling.MOUSEPOINTER = 0
        .edtTextToCheck.MOUSEPOINTER = 0
        .MOUSEPOINTER = 0
      ENDWITH

    ENDIF

    WITH goWordDoc
      .Content.TEXT = ALLTRIM(THISFORM.edtTextToCheck.VALUE)
      .ACTIVATE
      IF .SpellingErrors.COUNT > 0
        .CHECKSPELLING
      ELSE
        =MESSAGEBOX([Spell check complete. No errors found],0,[Spell Check])
      ENDIF
      *!* For some reason, Word likes to make itself visible here. Keep it hidden...
      goWord.VISIBLE = .F.
      THISFORM.edtTextToCheck.VALUE = .Content.TEXT
    ENDWITH
  ENDPROC

ENDDEFINE
*
**********************************
*!*********** END CODE ***********

************************************************************************************************
API Este ejemplo es muy util para las instalaciones.

DECLARE LONG CopyFile IN "kernel32" ;
  STRING lpExistingFileName,;
  STRING lpNewFileName,;
  LONG bFailIfExists,;


DECLARE LONG MoveFile IN "kernel32" ;
  STRING lpExistingFileName,;
  STRING lpNewFileName



*-- Subrutina Copiar

strSource = "C:/windows/escritorio/archivo1.txt"
strTarget = "d:/sistemas/archivo1.txt"
lngRetVal = CopyFile(ALLTRIM(strSource), ALLTRIM(strTarget), .F.)

IF lngRetVal=1
  MESSAGEBOX ("Archivo copiado!" )
ELSE
  MESSAGEBOX ("Error- Archivo No Copiado!" )
ENDIF



*-- Subrutina Mover

lngRetVal = MoveFile(ALLTRIM(strSource), ALLTRIM(strTarget))

IF lngRetVal=1
  MESSAGEBOX ("Archivo Movido!" )
ELSE
  MESSAGEBOX ("Error- Archivo No Movido!" )
ENDIF
************************************************************************************************
* SELECIONA o registro de controle 9 e o registro de MAIOR NUMERO de controle antes do 9 e o de meno numero apos o 9
SELECT * from EVENTO ;
WHERE  EVENTO.controle = 9 OR ;
       controle IN( SELECT MAX(controle) FROM EVENTO WHERE controle <  9) OR ;
       controle IN( SELECT MIN(controle) FROM EVENTO WHERE controle > 9 )

************************************************************************************************
Marca directamente el telefono indicado usando el dialer de WINDOWS.


DECLARE LONG tapiRequestMakeCall IN "TAPI32.DLL";
  STRING DestAddress,;
  STRING AppName,;
  STRING CalledParty,;
  STRING COMMENT

Numero = "475-730"
NombreProg = "c:/windows/dialer.exe"
Quien = "Orlando"
ValDev = tapiRequestMakeCall(Numero, NombreProg, Quien ,"hola ?")

************************************************************************************************
API Ejecuta cualquier archivo .EXE mediante API

DECLARE INTEGER WinExec IN WIN32API ;


  STRING cCmdLine, ;


  INTEGER nCmdShow




FILE=GETFILE('exe') && Esto abre el cuadro de dialogo Abrir




=WinExec( FILE, 1 )
************************************************************************************************
 Excelente cuando no quieres inscrustar objetos en formularios.


DECLARE LONG mciSendString IN "winmm.dll";
  STRING lpstrCommand,;
  STRING lpstrReturnString,;
  LONG uReturnLength,;
  LONG hwndCallback

DECLARE LONG mciGetErrorString IN "winmm.dll" ;
  LONG dwError ,;
  STRING lpstrBuffer,;
  LONG uLength

* En esta API tenemos que poner una línea de código,
* que tiene este aspecto:
* open "C:/Ruta/del/archivo.avi" type Tipo alias Alias
* El Alias debe ser una palabra cualquiera con la que nos
* referiremos al archivo, debe ser única, no puede haber dos iguales
* El Tipo dependerá del tipo de archivo que quieras ejecutar.
* Esta tabla te ayudará:
*   AVIVideo = Video digital (avi)
*   CDAudio = CD audio
*   MMMovie = Película multimedia
*   Sequencer = Secuenciador MIDI (mid)
*   WaveAudio = Audio digital (wav)

comillas = CHR(34)
respuesta = SPACE(250)

Comando = "open .avi type AVIVideo alias hola"

*-- Enviamos el comando
=mciSendString(Comando,respuesta, 255, 0)

Comando = "play hola"
=mciSendString(Comando, Respuesta, 255, 0)

************************************************************************************************
 La función GETCOLOR() nos retorna el número del color seleccionado. Podemos convertir ese "número" a un formato válido para páginas HTML.

La función _Col2HTML() recibe como parámetro un valor númerico (este valor numérico lo obtenemos de la funciónGETCOLOR() de VFP) y lo convierte a un formato válido para poder usar en una página HTML.

Ejemplo:

? _Col2HTML(GETCOLOR())


? _Col2HTML(12632256)




*------------------------------------------------


FUNCTION _Col2HTML(tnColor)


*------------------------------------------------


* Pasa un número de color a un formato 


*   válido para HTML


* USO: _Col2HTML(12632256)


* RETORNA: Caracter - "#RRGGBB" 


*------------------------------------------------


  LOCAL lcHTML, ln 


  lcHTML = "#" 


  FOR ln = 1 TO 3


    lcHTML = lcHTML + RIGHT(TRANS(tnColor%256,";@0"),2)


    tnColor = INT(tnColor/256)


  ENDFOR


  RETURN lcHTML


ENDFUNC
************************************************************************************************
 Este ejemplo es muy util para los usuarios newbies.


DECLARE LONG SystemParametersInfo IN "user32" ;
  LONG uAction,;
  LONG uParam,;
  LONG lpvParam,;
  LONG fuWinIni

SPI_SETSCREENSAVETIMEOUT = 15
SPIF_UPDATEINIFILE = 1
SPIF_SENDWININICHANGE = 2

minutos = 5
lSeconds = minutos * 60

lRet = SystemParametersInfo(SPI_SETSCREENSAVETIMEOUT, lSeconds, 0, ;
  SPIF_UPDATEINIFILE + SPIF_SENDWININICHANGE)


************************************************************************************************
 APAGAR Y ENCENDER EL MONITOR


*-- Este ejemplo lo puse como esta para que sigas trabajando,
*-- ya que realmente si le quitas la energia al monitor no
*-- podras prenderlo con el swicht.

DECLARE LONG SendMessage IN "user32";
  LONG HWND,;
  LONG wMsg,;
  LONG wParam,;
  LONG LPARAM

WM_SYSCOMMAND = 274
SC_MONITORPOWER = -3728

*-- Prende Monitor
=SendMessage (0, WM_SYSCOMMAND, SC_MONITORPOWER, 0)

*-- Apaga Monitor
=SendMessage (0, WM_SYSCOMMAND, SC_MONITORPOWER, -1)

*-- Prende Monitor
=SendMessage (0, WM_SYSCOMMAND, SC_MONITORPOWER, 0)

************************************************************************************************
Dataenvironment.Init     
Dataenvironment.OpenTables        If the AutoOpenTables property is set to .T.   
Dataenvironment.BeforeOpenTables  If the AutoOpenTables property is set to .T.   
Form.Load     
Controls are created     
Form.Init  
************************************************************************************************
Um truque para que cada vez que um textBox receber o foco o cursor 
e posicionado no final do texto
Un truco para que cada vez que un TextBox recibe el foco, el cursor se ubique al 

Colocar em GotFocus o sequinte codigo:

This.SelStart = LEN(RTRIM(This.Value))



************************************************************************************************
API Este ejemplo es muy util en ciertas ocasiones.

DECLARE INTEGER FindWindow IN WIN32API ;
  STRING cClassName, ;
  STRING cWindName


nHwnd = FindWindow( 0, "Program Manager" ) && Nombre ventana escritorio
*nHwnd = FindWindow( 0, _Screen.caption ) && Nombre ventana en VFP


DECLARE LONG SHOWWINDOW IN "user32";
  LONG HWND,;
  LONG nCmdShow


*-- Constantes para ShowWindow()

SW_HIDE = 0
SW_NORMAL = 1
SW_SHOWMINIMIZED = 2
SW_SHOWMAXIMIZED = 3
SW_SHOWNOACTIVATE = 4
SW_SHOW = 5
SW_MINIMIZE = 6
SW_SHOWMINNOACTIVE = 7
SW_SHOWNA = 8
SW_RESTORE = 9
SW_SHOWDEFAULT = 10


*-- Jugando con el escritorio

=SHOWWINDOW(nHwnd, SW_HIDE) &&oculta escritorio
*=ShowWindow(nHwnd, SW_SHOW) &&& muestra escritorio

************************************************************************************************

>Tenho um botão onde o usuário clica e o sistema apresenta a tela GetColor.
>Alí o usuário escolhe a cor, o sistema pega a cor escolhida e abre o FRX
>para atribuir a cor escolhida aos campos que dão cor aos textos que serão impressos.
>
>O problema é que GetColor retorna um número como: 16744576, por exemplo,
>e, no FRX, tenho os campos PENRED, PENGREEN, PENBLU - como posso
>distribuir o número retornado por GetColor aos campos no FRX ?

m.lnColor = GETCOLOR()
m.lnRed   = BITAND( m.lnColor,0xFF)
m.lnGreen = BITAND(BITRSHIFT(m.lncolor,8),0xFF)
m.lnBlue   = BITRSHIFT(m.lncolor,16)

************************************************************************************************
Percorrer uma planilha Excel com o VFP e ver o conteudo de todas sus celulas.

*-- Cria o objeto Excel
loExcel = CREATEOBJECT("Excel.Application")

WITH loExcel.APPLICATION

  .VISIBLE = .F.

  *-- Abrir a planilha de dados
  .Workbooks.OPEN("C:MiPlanilla.xls")


  *-- Quantidade de Colunas
  lnCol = .ActiveSheet.UsedRange.COLUMNS.COUNT


  *-- Quantidade de linhas
  lnFil = .ActiveSheet.UsedRange.ROWS.COUNT


  *-- Percorrendo todasm as celulas
  FOR lnI = 1 TO lnCol

    FOR lnJ = 1 TO lnFil
      ? CHR(lnI+64) + ALLTRIM(STR(lnJ)) + ': '
      ?? .activesheet.cells(lnJ,lnI).VALUE
    ENDFOR

  ENDFOR

  *-- Encerra a planilha
  .Workbooks.CLOSE

ENDWITH

RELEASE loExcel


*__ Ao percorrer podemos alterar valores das celulas,se fizermos isto antes de fechar a planilha
*__ devemos salvar as akteracoes utilisando:

loExcel.APPLICATION.activeworkbook.SAVE

************************************************************************************************
 Necesario cuando el usuario bloquea el teclado numerico y llaman que no funciona el teclado. 


DECLARE INTEGER GetKeyState IN "user32" LONG nVirtKey

*Key=144 && BloqNum
KEY=20 && BloqMayus

A = GetKeyState(KEY)

IF A = 1
  ? "Bloq Mayus Encendido"
ENDIF

IF A = 0
  ? "Bloq Mayus Apagado"
ENDIF

************************************************************************************************
 Esta rutina es util para saber si existe una etiqueta de indice en un archivo CDX. 

Pasando como parametro el nombre de la etiqueta a buscar, SeekTag() devuelve verdadero (.T.) si la etiqueta existe, de lo contrario devolvera falso (.F.). 


? SeekTag('etiqueta')

********************
Function SeekTag(TagBuscado)
    For nCount = 1 To 254
       If Tag(nCount) = Upper(tagbuscado)
           Return .t.
           Exit
       EndIf
       Return .f.
    EndFor
EndFunc


************************************************************************************************

 Muchos colegas me han preguntado sobre como hacer la degradación de colores sobre VFP. 

Así que aqui espongo, tanto el codigo para hacerlo en VFP como en VB. 


*!*	Rutina para generar degradados en Visual FoxPro
*!*	-----------------------------------------------

*!*	Para probar este ejemplo, pegue el código
*!*	en el método init de un formulario y
*!*	presione CTRL+D.

*!*	Autor: L.C.C. Ramón Rodríguez martínez
*!*	Pais de procedencia: México.
*!*	Actualizacion: 7 de agosto de 2002
*!*	Version 1.0


Local i,color1, R, G, B
With Thisform
	.scalemode = 3 &&pixeles 
	.drawstyle = 0 && sólido 
	.drawwidth = 2 
	R=0
	G=255
	B=0
	FOR i = 1 to 255 
		*-- Disminuimos valor de colores
		If r > 0 then 
			r = r - 1 
		endif 
		IF g > 0 then 
			g = g - 1 
		endif 
		IF b > 0 Then 
			b = b - 1 
		endif 
		color1 = RGB(R,G,B) 
		
		*Establesco el color
		.forecolor=Color1
		
		*- Dibujo linea sobre el fomulario
		.line (0,.ViewPortHeight * (i - 1) / 255, .ViewPortwidth, .ViewPortheight * i / 255)
	NEXT i 
EndWith

Y esta es la forma de hacerlo en VB 


'Rutina para generar degradados en Visual Basic
'----------------------------------------------

'Para probar este ejemplo, pegue el código
'en la sección Declaraciones de un formulario y
'presione F5.

'Autor: L.C.C. Ramón Rodríguez martínez
'Pais de procedencia: México.
'Actualizacion: 7 de agosto de 2002
'Version 1.0

Option Explicit

Private Sub Form_Load()
'Se rquiere que los valores pasen en formato R,G,B
Call Degradado(Me, 0, 255, 0)
End Sub

Private Sub Degradado(F As Form, r, g, b)
Dim i As Integer
Dim color As Long

F.ScaleMode = vbPixels
F.DrawStyle = vbInsideSolid
F.DrawWidth = 2
F.AutoRedraw = True

For i = 1 To 255
    ' Disminuimos valor de colores
    If r > 0 Then r = r - 1
    If g > 0 Then g = g - 1
    If b > 0 Then b = b - 1

    color = RGB(r, g, b)
    
    'Dibujo línea sobre el fomulario
    F.Line (0, F.ScaleHeight * (i - 1) / 255)-(F.ScaleWidth, F.ScaleHeight * i / 255), color, BF
Next i
F.Refresh
End Sub


************************************************************************************************
 ¿Cómo saber si el equipo está conectado a Internet?, una simple llamada a esta función puede resolverlo. 

Compatible con VFP 5 y superiores. 

Tomado del news de microsoft en ingles 


? IsInternetActive()

***********************************
Function IsInterNetActive (tcURL)
***********************************
* PARAMETERS: URL, no olvidar pasar la URL completa, con http:// al inicio
* Retorna .T. si hay una conexion a internet activa
*Tekno
*Wireless Toyz
*Ypsilanti, Michigan
***********************************
tcURL = IIF(TYPE("tcURL")="C" AND !EMPTY(tcURL),tcURL,"http://www.yahoo.com")

  DECLARE INTEGER InternetCheckConnection in wininet;
                    STRING lpszUrl,;
                    INTEGER dwFlags,;
                    INTEGER dwReserved

    RETURN ( InternetCheckConnection(tcURL, 1, 0) == 1)
ENDFUNC
***********************************

************************************************************************************************
 Solucion OOP del problema de la ventana Preview Maximizada. 


Cómo ya muchos sabran, las ventanas de Preview del reporteador no están maximizadas, por lo que para remediarlo se ha utilizado la instrucción define window, pero a continuación les comparto algo que para no variar encontré en los foros en ingles del news de microsoft. 



oForm = CREATEOBJECT("Form")
WITH oForm
   .Caption = "Tu Titulo del Preview"
   .WindowState = 2    && Maximized
   .Show()

   REPORT FORM tureporte PREVIEW WINDOW (.Name)
   .Release()
ENDWITH

************************************************************************************************
 Excelente cuando distribuimos aplicaciones.


DECLARE INTEGER DLLSelfRegister IN "Vb6stkit.DLL" ;
  STRING lpDllName

*-- Esta es la ruta donde esta el archivo
nombredll="s:/sistemas/ocx/hwnd.ocx"

liRet = DLLSelfRegister(NombreDll)

IF liRet = 0 Then
  SelfRegisterDLL = .T.
  MESSAGEBOX ("Registrado ocx")
ELSE
  SelfRegisterDLL = .F.
  MESSAGEBOX ("Error- No Registrado ocx")
ENDIF

************************************************************************************************
FOR i = 1 TO THISFORM.Grid1.COLUMNCOUNT

   WITH THISFORM.Grid1.COLUMNS(i)
   
      cFontName = .FONTNAME
      cFontSize = .FONTSIZE
      cFontBold = IIF( .FONTBOLD, "B", "" )

      cCont = TRAN(EVAL(.CONTROLSOURCE))
      nLenC = LENC( TRAN(EVAL(.CONTROLSOURCE)) ) 
      nFont = FONTMETRIC(6, cFontName, cFontSize, cFontBold )
      
      .WIDTH = ( TXTWIDTH( cCont, cFontName, cFontSize )* nFont ) + 4
      
   ENDW
   
NEXT

************************************************************************************************
Util cuando no queramos que el protector se active cuando estamos programando.

DECLARE LONG SystemParametersInfo IN "user32";
LONG uAction,;
LONG UParam,;
LONG lpvParam,;
LONG fuWinIni


SPI_SETSCREENSAVEACTIVE = 17
SPIF_SENDWININICHANGE = 2


*-- para impedir que se active :
=SystemParametersInfo (SPI_SETSCREENSAVEACTIVE, .F., 0, SPIF_SENDWININICHANGE)


*-- Para volver a restaurarlo como estaba antes de nuestra intervención :
=SystemParametersInfo (SPI_SETSCREENSAVEACTIVE, .T., 0, SPIF_SENDWININICHANGE)



************************************************************************************************
Determinar si estas conectado a Internet 
#Define FORCE_CONNECTION  1

Declare Integer InternetCheckConnection in Wininet.dll; 
String Url, Long dwFlags, Long Reserved

If InternetCheckConnection("http://www.hotmail.com", FORCE_CONNECTION, 0) != 0
         Msg = "Estas Conectado a Internet"
Else
         Msg = "Lo siento, no estas Conectado a Internet"
EndIf
=MessageBox(msg) 

************************************************************************************************


Ejecutar el Asistente para crear una conexión a Internet 
RUN /N Rundll Rnaui.dll,RnaWizard 


--------------------------------------------------------------------------------

Tipo de fuente personalizada en los menús 

Existe un truco poco documentado acerca de como cambiar el estilo y la fuente de los menús, a continuación lo describo: Creemos un menú y luego nos vamos a las propiedades del elemento del menu que queremos personalizar, en la opción "Saltar Por" (SkipFor) agregamos la siguiente línea de código que produce el estilo de la fuente a mostrar en ese elemento.


.F. FONT "Arial", 14 Style "BI"


Puede colocarle cualquier tipo de letra a los menús y tamaño. Los estilos que podemos aplicar son los siguientes


Carácter  Estilo de fuente 
B   Negrita 
I Cursiva  
N Normal 
O Contorno 
Q Opaco 
S Sombra 
- Tachado 
T Transparente 
U Subrayado 


--------------------------------------------------------------------------------

Impresión personalizada de Texto 
?  'Texto a imprimir' FONT "ARIAL,12" STYLE "B"


--------------------------------------------------------------------------------

Generando fechas al Azar (Aún lo tengo en prueba) 
? INT(RAND() * 365) + DATE()


--------------------------------------------------------------------------------

Devolver la resolución actual 
? TRANSFORM(SYSMETRIC(1))+" x "+TRANSFORM(SYSMETRIC(2))


--------------------------------------------------------------------------------

Proteger las clases visuales (VCX) 
USE cNombreClase.VCX
REPLACE ALL Methods WITH ""
USE


--------------------------------------------------------------------------------

Buscar cadena dentro del proyecto actual 
FOR EACH  oBj  IN _VFP.ActiveProject.Files
          IF "usuario" $ oBj.name
                  ? oBj.name
          EndIf
NEXT 


--------------------------------------------------------------------------------

Generar colores al azar para controles o el _Screen 
_SCREEN.BackColor = RAND() * 255 ^ 3


--------------------------------------------------------------------------------

Actualizar todos los formularios ejecutados 
For Each oForm In _Screen.Forms
       If Vartype(oForm) = 'O'
             oForm.Refresh()
       Endif
Next


--------------------------------------------------------------------------------

Colocar el cursor al final del texto dentro de un control 
En el evento GotFocus control 
KEYBOARD '{END}'  



************************************************************************************************
Como autoregistrar OCX y DLLs. 


Tomado del news de microsoft en inglés. 


------------------------------------------
DECLARE LONG DllRegisterServer IN [archivo.ocx]
IF DllRegisterServer() = 0
    * OK
ELSE
    * Not OK
ENDIF


Este método también puede ser usado con archivos COM DLL. 


************************************************************************************************
Existe una forma sencilla de invocar cuadros de dialogo de Windows, tales como: Guardar, Abrir, Fuentes, Color, Impresoras, Ayuda.

loComDialog = newobject( "mscomdlg.commondialog" )
 

locomdialog.ShowFont     && Mostrar Fuente
  
locomdialog.ShowPrinter()   && Mostrar Impresora
  
locomdialog.ShowColor()  && Mostrar Colores
  
locomdialog.ShowSave()  && Mostrar Guardar 
loComDialog.ShowOpen  && Mostrar Abrir

************************************************************************************************
Olá!

Tente utilizar:

DEFINE WINDOWS MinhaJanela FROM 0, 0 TO SROWS(), SCOLS() IN SCREEN TITLE "Relatório de Teste" SYSTEM CLOSE
Report Form MeuRelatorio Preview Window MinhaJanela

Fiz testes no VFP6 e funciona, não sei lhe dizer se no VFP7 vai funcionar.
Até mais.

Erick
Força Sempre! 
************************************************************************************************
 Util cuando quiere instalar fuentes sin abrir ventanas.


DECLARE LONG AddFontResource IN "gdi32";
  STRING lpFileName

DECLARE LONG RemoveFontResource IN "gdi32";
  STRING lpFileName

filename = GETFILE('ttf')

resultado = AddFontResource(FileName) # 0
*resultado = RemoveFontResource(FileName) # 0

? resultado

************************************************************************************************


Cuando necesitemos saber que usuarios estan conectados a una base de datos de MS SQL Server 2000 podemos usar este procedmiento almacenado.


create procedure @base_de_datos nchar(128) as
begin
set nocount on
if exists (select name from sysobjects
   where name = 'tbl_usuarios_conectados')
   drop table tbl_usuarios_conectados
   
create table tbl_usuarios_conectados (spid smallint,
   /* esta columna se puede borrar si se desea utilizar en SQL Server 7*/
   ecid smallint, status nchar(30), loginname nchar(128),
   hostname nchar(128), blk char(5), dbname nchar(128), cmd nchar(16))

INSERT tbl_usuarios_conectados
exec sp_who

select distinct loginname, hostname
   from tbl_usuarios_conectados
   where dbname = @base_de_datos and hostname <> ' '
return
end



************************************************************************************************



Saber la ruta y nombre completo de la aplicación asociada a al extensión de un archivo. 



*-- Ejemplos
? AplicAsoc("XLS")
? AplicAsoc("ZIP")
? AplicAsoc("DOC")
? AplicAsoc("JPG")
? AplicAsoc("PRG")
? AplicAsoc("DBF")
? AplicAsoc("HTML")


*------------------------------------------------
* FUNCTION AplicAsoc(tcExt)
*------------------------------------------------
* Retorna la ruta y nombre completo de la
* aplicación asociada a al extensión del
* archivo pasado como parámetro
*------------------------------------------------
FUNCTION AplicAsoc(tcExt)
  LOCAL lcArc, lcApp, ln, ll, lc
  DECLARE LONG FindExecutable ;
    IN SHELL32.DLL ;
    STRING lpfile, ;
    STRING lpdirectory, ;
    STRING lpresult
  lcArc = FORCEEXT(SYS(5)+CURDIR()+SYS(2015),tcExt)
  ln = FCREATE(lcArc)
  ll = FCLOSE(ln)
  lc = SPACE(255)
  lcApp = ""
  IF FindExecutable(lcArc,"",@lc) >= 32
    lcApp = SUBSTR(lc,1,AT(CHR(0),lc)-1)
  ENDIF
  IF FILE(lcArc)
    DELETE FILE (lcArc)
  ENDIF
  RETURN lcApp
ENDFUNC
*------------------------------------------------



************************************************************************************************


 Has visto las aplicaciones que se pone un formulario de entrada y te pide la empresa a trabajar y el usuario, pues bueno, he aqui un truco de como seleccionarlas ya que cada una esta en un directorio diferente y es una base de datos distinta. 


Nota: La fórmula correcta es base de datos por empresa y en diferente subdirectorio utilizados con la misma aplicación sin necesidad de salir de ella. 

Las aplicaciones de cualquier tipo (administrativas, etc.) que tienen un sistema multi-empresa o multiusuarios son en la actualidad una útil herramienta, por esa razón doy aquí los pasos para crearlas adecuadamente 

1. Debes crear el objeto aplicación con la rutina de : 


PUBLIC oApp
  oApp = CREATEOBJECT("Aplica")


en tu programa principal de enlace Main.prg 

2. Creas una clase aplicación, que es una clase de tipo "Custom" llamada aplica y la guardas en un contenedor de clases 

3. Debes crear varias propiedades de las cuales van a contener los valores fijos que se van a selecionar: 

Ejemplo: objeto Init de la clase Custom 


This.Contador = 0
This.Ruta = "aplicabases"
This.Nombre = "Sistema Administrativo"
This.diraiz = "C:aplica"
This.dbn = "sistema.dbc"
This.user = 1
This.userNombre = "Ing. Noe A. --- Programando ---"
This.Empresa = 1
This.Logo = "c:aplicadibustecnog.jpg"
This.nombreempresa = "EMPRESA DE PROGRAMACION"
This.dir = "Direccion"
This.pob = "Poblacion"
This.codigo = "C.P."
This.rfc = "SU RFC"
This.telefono = "SU TELEFONO"
This.Fax = "SU FAX"


Estas propiedades son asignadas en los controles de selección de un ListBox que ya hayas diseñado con anterioridad y se pondrán al mismo tiempo que seleccione la empresa o empresas a trabajar 
por lo cual 

4. Se deben crear las sigientes tablas 
Empre.dbf que contenedrá la información necesaria de la o las empresas y las bases de datos con las rutas especificadas. 

Por ejemplo si tiene la tabla: 

empresa1-etc.-ruta1 
empresa2-etc.-ruta2 

Al selecionar con el ListBox el código de la Empresa1 se obtendrán los datos de la misma leída por la tabla empresa y asignados al objeto aplicación. 

5. Y último, cada formulario de tu aplicación debe tener el código de entorno de datos llamado "Open Tables" el siguiente código 


This.Cursor1.Database = oApp.Ruta + oApp.dbn
This.Cursor2.Database = oApp.Ruta + oApp.dbn
This.Cursor3.Database = oApp.Ruta + oApp.dbn
This.Cursor4.Database = oApp.Ruta + oApp.dbn
This.Cursor5.Database = oApp.Ruta + oApp.dbn
This.Cursor6.Database = oApp.Ruta + oApp.dbn
This.Cursor7.Database = oApp.Ruta + oApp.dbn
This.Cursor8.Database = oApp.Ruta + oApp.dbn


Una por cada cursor que contenga el entorno de datos, en este ejemplo contiene 8. 

La parte de asignación "oApp.ruta" es igual a el texto en caracteres que nos indica la ruta de la base de datos y el "oApp.dcn" es la base de datos (abierta en el momento de la seleccion de la empresa) 

¿Por qué hacer esto? 

Si no estuviera este código nos daría como resultado que la información que procese tu aplicación sería la de la base de datos por default asignada en tiempo de programación. 

Si tienen alguna duda, poner sus comentarios o sugerencias a: 
anoevi@hotmail.com o anoevi@uolmail.com 

Gracias... 




************************************************************************************************

 Minimizar todas las ventanas activas. Un buen ejemplo para simular las pulsaciones delas teclas 'Windows + M'.


DECLARE LONG keybd_event IN "user32" INTEGER bVk, INTEGER bScan, LONG dwFlags, LONG dwExtraInfo

KEYEVENTF_KEYUP = 2
VK_LWIN = 91

*-- 77 Este es el codigo de caracter de la letra 'M'
=keybd_event(VK_LWIN, 0, 0, 0)

=keybd_event(77, 0, 0, 0)

=keybd_event(VK_LWIN, 0, KEYEVENTF_KEYUP, 0)



*SQL***********************************************************************************************

Cuando necesitamos desplegar información podemos utilizar un CASE dentro de un WHERE

Esto no se si alguien lo hizo antes, pero recientemente se me dio la necesidad de hacer un procedimiento almacenado en SQL Server con la opción de poder seleccionar los datos de uno o todos los clientes en una misma consulta. 

Encontre una forma fácil de realizarlo. Espero les sirva. 

Ejemplo: Tenemos una tabla de datos de clientes, y necesitamos desplegar la informacion de uno o todos los clientes. Este es el código de ejemplo: 


Declare @id_cliente char(13) -- Declaracion de la variable que nos servira de parametro

Set @id_cliente='Todos' -- Establecer el Valor

Select a.id_cliente,a.nombre
  From tbl_clientes a
  where a.id_cliente= case when @id_cliente='Todos' then
  a.id_cliente else @id_cliente end
  -- En esta parte es donde usamos el case dentro 
  del where para hacer la comparacion de datos,
  si deseamos todos los clientes, unicamente
  debemos compararlo con el codigo dentro de la
  misma tabla, de lo contrario lo comparamos con
  el valor de la variable o parametro que utilizemos.


************************************************************************************************




 Muy util para reconocer unidades en red mas que todo.


DECLARE LONG GetDriveType IN "kernel32" ;
  STRING nDrive

disco=GetDriveType("H:")

? disco

*-- Parametros devueltos por GetDriveType
* DESCONOCIDO = 1
* DISCO REMOVIBLE = 2
* DISCO DURO = 3
* DISCO EN RED = 4
* CDROM = 5
* DISCO RAM = 6

************************************************************************************************


Ruy Rolando Amaral 645 4996

Una de las funciones más robustas e importantes que han sido agregadas a VFP 7 es Execscript. En VFP 6 se puede utilizar Compile (service Pack 3 creo). Permite compilar código desde campos memos, texto, etc y compilarlo.

lcNombreArchivo = Sys(2015) + ".prg"
Strtofile(CampoMemo, lcNombreArchivo )
Compile (lcNombreArchivo)    && en VFP 6 SP 3 o superior 
DO (lcNombreArchivo) 

ExecScript(CampoMemo)  &&   En VFP 7


************************************************************************************************



[API] Cambiar el papel tapiz del escritorio, para personalizar una aplicacion cuando la instalamos.

DECLARE LONG SystemParametersInfo IN "user32";
LONG uAction,;
LONG uParam,;
STRING lpvParam,;
LONG fuWinIni

filename = GETFILE('bmp')

=SystemParametersInfo(20, 0, filename, 1)


************************************************************************************************

[Internet]  En este artículo, se describe un acercamiento mucho más simple - uno que trabaje con cualquier cliente MAPI del email (incluyendo OUTLOOK y Netscape).

No es tan flexible como el método de la automatización de ActiveX, sino que tiene la ventaja de requerir solamente un par de líneas del código.

El truco es " registrar" el mailto con la función de ShellExecute() antes. ShellExecute() no es una función de VFP, sino es parte del shell de Windows. Antes de que usted pueda utilizarlo, usted debe declararlo, como tan:

DECLARE INTEGER ShellExecute IN shell32.dll ;


INTEGER hndWin, STRING cAction, STRING cFileName, ; 


STRING cParams, STRING cDir, INTEGER nShowWin


Usted puede poner este código dondequiera en su programa, con tal que se ejecute antes de que usted cree el mensaje del email. (nota que ShellExecute es sensible a las mayusculas)

¿Qué hace?

Esencialmente, ShellExecute() le deja " ejecutar " cualquier pogram, documento o atajo. En su más simple, puede ser utilizado para lanzar un programa externo. Por ejemplo, este comando lanzará la libreta:

ShellExecute(0, " open ", " Notepad.Exe ", "", "",1)


Alternativamente, usted podría utilizar el código siguiente para lanzar la libreta y hacer que abra un archivo llamó a Readme.txt:

ShellExecute(0, " open ", " Readme.txt ", "", "",1)


Y esto lanzará Word y abrirá Disclaimer.RTF:

ShellExecute(0, " open ", " Disclaimer.RTF ", "", "",1)


La belleza de esto es que usted no tiene que saber qué programa se coloca para abrir un tipo específico del documento en el sistema del usuario. Si el usuario posee Word, el código antedicho lanzaría Wordpad en lugar de otro, como éste puede también procesar archivos del rtf. Por supuesto, si el usuario no tuviera ningún programa asociado con RTFs, el comando fallaría.

El segundo parámetro a ShellExecute() le deja especificar la acción que usted desea ejecutar. Cambiándolo " print ", por ejemplo, usted puede imprimir el documento más bien que lo abre para corregir. Semejantemente, el código siguiente reproducirá un archivo de sonidos (que usa o al reproductor de medios de Windows o lo que el usuario use asociado a la extensión de WAV):

ShellExecute(0, " play ", " ringin.wav ", "", "",1)


Otra posibilidad:

ShellExecute(0, " open ", " www.microsoft.com ", "", "",1)


Esto lanzará el web browser del defecto del usuario y navegará al sitio especificado.

¿Qué sobre el email?

Así pues, de nuevo a nuestro requisito original. Crear un mensaje del email, todo lo que usted tiene que hacer es ShellExecute al link del mailto. Más simple, el link sería algo como esto:

mailto:john@mycompany.com


El código siguiente abrirá una ventana que compone del mensaje en el cliente del correo del defecto del usuario, con en la línea completada ya:

lcMail = " mailto:john@mycompany.com " ShellExecute(0, " open ", lcMail, "", "",1)


Yendo más lejos, usted puede especificar los parámetros siguientes al acoplamiento del mailto:

Cc =     Copia a carbón  


BCC =  Copia a carbón oculta  


Subject =  Encabezado


Body =  Texto del cuerpo


Ponga un signo de interrogación antes del primer de estos parámetros (derechos después de la direccion de correo). 
Utilice los signos "&"para separar otros parámetros, como en este ejemplo:

lcMail = "mailto:john@mycompany.com"+ ;


"?CC= boss@mycompany.com&Subject= Meet for lunch"+ ;


"&Body= Please join me for a sandwich at noon." 


ShellExecute(0, " open ", lcMail, "", "",1)


Esto producirá la ventana que compone del mensaje demostrada en el cuadro 1. Como usted puede ver, a, se completan 
los cc y las líneas sujetas ya, al igual que el texto del mensaje. Todo que el usuario tiene que hacer debe es 
hacer click en el botón del enviar.

Limitaciones:

Esta técnica tiene un par de la limitación obvia. Primero, no es conveniente para crear mensajes muy largos o 
mensajes con el texto ajustado a formato. Ni es posible agregar "Attachments" al mensaje. Más seriamente, usted 
tiene que confiar en el usuario para enviar realmente el mensaje. Usted no puede hacer eso mediante programa, ni 
puede usted evitar que el usuario cancele el mensaje más bien que lo envíe.

Por otra parte, si todos lo que usted necesita es una manera simple de ayudar al usuario a componer y a enviar un 
mensaje sin formato sin los accesorios, la técnica trabajará extremadamente bien. Usted podría utilizarla, por 
ejemplo, para crear un mensaje que confirma una orden o uno que persigue a cliente para el pago. Es especialmente útil 
si usted desea deja a usuario corregir el texto antes de hacer click en el botón de enviar.

Mike Lewis Consultants Ltd. February 2002

© Mike Lewis Consultants Ltd. Sientase libre para dar copias de este artículo a sus colegas, pero no 
quitar por favor este aviso y negación de copyright. La información dada aquí se cree 
para estar correcta, pero no se acepta ninguna responsabilidad legal por su uso. 








*************************************************************************

















[Varios] Como hacer que VFP retorne automáticamente a primer plano después de un proceso largo


El MESSAGEBOX() de VFP tiene dos parámetros no documentados para:

SYSTEMMODAL = 4096
TASKMODAL = 8192

*-- Ejemplo:


INKEY(10)


*-- Cambiar a cualquier otra ventana antes de 10 segundos !!!


MESSAGEBOX("Proceso Terminado", 32 + 16 + 4096, "Aviso de VFP!")




*****************************************************************************

















Ejecutar una aplicación y esperar que termine
Enviado por: Luis María Guayán
[API] Pablo Pioli escribió: "Recientemente tuve que realizar una rutina que ejecute una aplicacion y esperar a que terminara para obtener los resultados. Si a alguien le interesa aqui se las envio."



* Ejemplo:
ShellWait("C:WINNTNOTEPAD.EXE", " C:ARCHIVO.TXT")
* Notar el espacio al comienzo del parametro

* defines
#DEFINE STARTF_USESHOWWINDOW    1
#DEFINE SW_SHOWMAXIMIZED        3
#DEFINE m0                    256
#DEFINE m1                  65536
#DEFINE m2               16777216

***
* Function ShellWait
***

FUNCTION ShellWait(cEXEFile, cCommandLine)
LOCAL cStartupInfo, cProcInfo, nProcess

* Declare WinAPI Functions

DECLARE INTEGER CreateProcess IN kernel32 ;


STRING lpApplicationName, ;


STRING lpCommandLine, ;


INTEGER lpProcessAttributes, ;


INTEGER lpThreadAttributes, ;


INTEGER bInheritHandles, ;


INTEGER dwCreationFlags, ;


INTEGER @lpEnvironment, ;


STRING lpCurrentDirectory, ;


STRING lpStartupInfo, ;


STRING @lpProcessInformation




DECLARE INTEGER WaitForSingleObject IN kernel32 ;


INTEGER hHandle,;


INTEGER dwMilliseconds




DECLARE INTEGER CloseHandle IN kernel32 ;


INTEGER hObject




DECLARE INTEGER GetLastError IN kernel32






* Incializar estructuras


cStartupInfo = num2dword(68) + ;


num2dword(0) + num2dword(0) + num2dword(0) + ;


num2dword(0) + num2dword(0) + num2dword(0) + num2dword(0) + ;


num2dword(0) + num2dword(0) + num2dword(0) + ;


num2dword(STARTF_USESHOWWINDOW) + ;


num2word(SW_SHOWMAXIMIZED) + ;


num2word(0) + num2dword(0) + ;


num2dword(0) + num2dword(0) + num2dword(0)




cProcInfo = REPLICATE(CHR(0), 16)




* Ejecutar comando


IF CreateProcess(cEXEFile, cCommandLine, 0, 0, 1, 32, 0, SYS(2003), ;


cStartupInfo, @cProcInfo) == 0




* Posibles errores


*  2 = The system cannot find the file specified


*  3 = The system cannot find the path specified


* 87 = ERROR_INVALID_PARAMETER


MESSAGEBOX("Error número: " + LTRIM(STR(GetLastError())), 64, "Error")




ELSE


* Esperar a que termine


nProcess = buf2dword(SUBSTR(cProcInfo, 1, 4))


WaitForSingleObject(nProcess, -1)


CloseHandle(nProcess)


ENDIF


ENDFUNC




***


* Function num2dword


***


FUNCTION num2dword(nValue)


LOCAL b0, b1, b2, b3




b3 = INT(nValue/m2)


b2 = INT((nValue - b3 * m2)/m1)


b1 = INT((nValue - b3*m2 - b2*m1)/m0)


b0 = MOD(nValue, m0)


RETURN(CHR(b0) + CHR(b1) + CHR(b2) + CHR(b3))


ENDFUNC




***


* Function num2word


***


FUNCTION num2word(nValue)


RETURN(CHR(MOD(nValue, 256)) + CHR(INT(nValue / 256)))


ENDFUNC




***


* Function buf2dword


***


FUNCTION buf2dword(cBuffer)


RETURN(ASC(SUBSTR(cBuffer, 1, 1)) + ;


ASC(SUBSTR(cBuffer, 2, 1)) * 256 + ;


ASC(SUBSTR(cBuffer, 3, 1)) * 65536 + ;


ASC(SUBSTR(cBuffer, 4, 1)) * 16777216)


ENDFUNC




****************************************************************************************
oShell = CREATEOBJECT("Shell.Application")
oShell.open(16)   && ESCRITORIO
oShell.open(14)   && MIS VIDEOS
oShell.open(11)   && MIS MUSICA
oShell.open(10)   && CAPETRA DE MENU INICIO
oShell.open(9)     && ENVIAR A
oShell.open(8)     && RECIENTE
oShell.open(6)     && FAVORITOS
oShell.open(5)     && MIS DOCUMENTOS
oShell.open(4)     && IMPRESORAS
oShell.open(3)     && PANEL DE CONTROL
oShell.open(2)     && PROGRAMAS
oShell.open(1)     && INTERNET EXPLORER
oShell.open(17)   && MI PC
oShell.open(18)   && MIS SITIOS DE RED
oShell.open(19)   && ENTORNO DE RED
oShell.open(20)   && FUENTES
*****************************************************************************************
Un ejemplo como podemos crear tablas en Word con datos de tablas de VFP, a través de Automatización.

USE employee
lcTemp = SYS(2015)+'.txt'

COPY fields empl_id, last_name TO (lcTemp) TYPE csv
 
lnFields = 2
 
_ClipText = chrtran(FileToStr(lcTemp),'"','')
 
erase (lcTemp)
 
#define wdSeparateByCommas 2

oWordDocument=createobject("word.application") && Create word object
 
WITH oWordDocument
               .documents.add
        
                WITH .ActiveDocument
                        .Range.Paste
                        .Range.ConvertToTable(wdSeparateByCommas,,lnFields)
                ENDWITH
     
              .visible = .t.
              .Activate
ENDWITH
**********************************************************************************************
Uno de los temas más solicitados a mi correo son los gráficos; este es un BUEN ejemplo de como hacerlo, y además agregándole un gran efecto.

LOCAL objXL, objXLchart, intRotate

objXL = CreateObject("Excel.Application")
objXL.Workbooks.Add
objXL.Cells(1,1).Value = 50
objXL.Cells(1,2).Value = 10
objXL.Cells(1,3).Value = 15
objXL.Range("A1:C1").Select

objXLchart = objXL.Charts.Add()
objXL.Visible = .t.
objXLchart.Type = -4100

For intRotate = 5 To 180 Step 5
      objXLchart.Rotation = intRotate
Next

For intRotate = 175 To 0 Step -5
      objXLchart.Rotation = intRotate
Next
