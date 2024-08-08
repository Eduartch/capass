*******do \trabajo\repara with "sueldos.dbf",3,"",64,0,.t.

*****************************************************************************
*!*                                                                       *!*
*!* ATFixDbfFpt 1.6 repairs invalid                                       *!*
*!* dbc, dbf, frx, lbx, mnx, pjx, scx, vcx (or user defined xBase)        *!*
*!* and memo file headers                                                 *!*
*!*                                                                       *!*
*!* FoxBASE, FoxBASE+, dBASE III PLUS, FoxPro, dBaseIV and                *!*
*!* Visual FoxPro  version 3.0 - 8.x type table and memo files supported. *!*
*!*                                                                       *!*
*!* This version can't fix table / memo if table field block is           *!*
*!* corrupted!                                                            *!*
*!*                                                                       *!*
*!* This version is also limited to the 10 MB file size                   *!*
*!*                                                                       *!*
*!* Copyright (C) 2003 GNC Finland, Arto Toikka                           *!*
*!*                                                                       *!*
*!* This is free software; it may be used under the terms of license in   *!*
*!* license.txt (License version 1.0)                                     *!*
*!*                                                                       *!*
*!* When downloading and/or using this software you accept license terms  *!*
*!* as shown in license.txt otherwise you must delete                     *!*
*!* all copies of this software you have and remove all links to this     *!*
*!* software.                                                             *!*
*!*                                                                       *!*
*!* This software is distributed in the hope that it will be useful,      *!*
*!* but WITHOUT ANY WARRANTY; without even the implied warranty of        *!*
*!* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                  *!*
*!* See license terms for more details.                                   *!*
*!*                                                                       *!*
*!* You should have received a copy of the license with this software     *!*
*!* (license.txt); if not, Email or write to the copuright owner          *!*
*!* for a license terms.                                                  *!*
*!*                                                                       *!*
*!* Even this version (1.6) is a freeware (except the source),            *!*
*!* you can send USD $35 /EUR 35€ payment to the copyright owner for a    *!*
*!* future development of this tool and get (through Email)               *!*
*!* upcoming version where corrupted field block can be fixes,            *!*
*!* manual with examples, the source + source upgrades for a year.        *!*
*!*                                                                       *!*
*!* GNC Finland Ltd                                                       *!*
*!* Arto Toikka                                                           *!*
*!* Reviisorinkatu 3 B 16                                                 *!*
*!* 02770 Espoo                                                           *!*
*!* Finland                                                               *!*
*!* gnc_nospam@mp.utu.net                                                 *!*
*!* tel. +358 400 665566                                                  *!*
*!* fax +358 9 8552367                                                    *!*
*!*                                                                       *!*
*****************************************************************************
*!* The Manual
*!*
*!* Syntax (Program) 
*!*
*!* DO ATFixDbfFpt WITH tcWhatDbf, tnRepairMode, tcContainer, tnMemoBlockSice, tnInfo, tlNoBackups, tnLang, lUseTMpDbf
*!*
*!* Syntax (Function)
*!*
*!* ATFixDbfFpt(tcWhatDbf, tnRepairMode, tcContainer, tnMemoBlockSice, tlNoInfo, tlNoBackups, tnLang, lUseTMpDbf)
*!*
*!* tcWhatDbf             Name (with .ext) of the table to repair
*!*                       dbc, dbf, frx, lbx, mnx, pjx, scx, vcx or user defined
*!* tnRepairMode          0 (Default) Only report generated
*!*                       1 table header checked and fixed.
*!*                       2 memo header checked and fixed.
*!*                       3 table and memo header checked and fixed.
*!*                       ** values 4 and greater are for data-anlysis.
*!*                       4 All scannable data readed per record from old table file
*!*                         and written to the new table file, new header written,
*!*                         new field block written form template file (if exist)
*!*                       5 All scannable data readed per record from old memo file
*!*                         and written to the new memo file, new header written,
*!*                         new field block written form template file (if exist)
*!*                       6 All scannable data readed per record from old table and memo files
*!*                         and written to the new table and memo files file, new headers written,
*!*                         new field blocks written form template files (if exist)
*!*                       ** values 5 / 6 see last NOTES:
*!* 
*!* tcContainer           Relative path and name of the container (+ .EXT). Give it if there is
*!*                       a problem with table / container link and you like to refresh it.
*!*                       (Default empty i.e. no container link refreshed)
*!*                       NOTE!!!! If there isn't container block in the file header
*!*                       tcContainer value shoud be logical .F. (all VFP data files have a 263 
*!*                       character long container block)
*!* tnMemoBlockSice		  Memo block size (Default 64)
*!* tnInfo          	  0 (or not numeric value) no info
*!*                       1 Info to the screen
*!*                       2 Info to the file
*!*                       3 Info to the screen and file
*!* tlNoBackups     	  .T. = do not make backups from corrupted? files (Default make backups)
*!* tnLang          	  Language, 1 = finnish, others are english (Default english)
*!*                       If you add languages please email your addition to me
*!* lUseTMpDbf            TMP dbf is used to save data from / write data to
*!*                       Default .F. -> low level functions is used to
*!*                       write file. This parameter is used only in tnRepairMode > 3
*!*
*!*
*!* NOTE:  (Backup)
*!*        If make backup is selected following files are generated
*!*        (to the same directory where table is lovated)
*!*        Table: table name (with .EXT) + nn (nn = 1 to 99)
*!*        Memo:  memo name (with .EXT) + nn (nn = 1 to 99)
*!*
*!*
*!* NOTE:  (RETURN VALUE)
*!*        positive value (including zero) - > event succesful (refer tnRepairMode)
*!*        negative values - > event not succesful (refer Int(m.tnMessage) = 104 in FixMessage())
*!'  -10 = Only report generated, not succesful
*!*  -50 = Invalid parameters
*!*  -60 = No room fo a backup
*!*  -61 = No room for a tnRepairMode = 4 or 6
*!*  -62 = Nor Room for a Info
*!*
*!* NOTE:  (REPORT)
*!*        ATFixDbfFpt writes info file to the same direcory where table file is located.
*!*        Name of the info file is:
*!*        "ATFix_" + name of the table file (without .EXT) + ".TXT"
*!*
*!*        IF RETURN VALUE <> 0 AND <> 1, report is not generated
*!*
*!* Last modified:
*!* 07/01/2001  Started
*!* 07/03/2001  Version 1.0
*!* 07/04/2001  - possibility to rewrite container block added
*!*             -
*!* 07/10/2001  Sorry 1.1b was VFP7 version, VFP5 - 6 support added
*!* 07/11/2001  Reporting bugs fixed
*!* 07/20/2001  Forgotten SET STEP ON line removed
*!*
*!*
*!* Version 1.3
*!* 07/24/2001  All messages (except info) moved to the FixMessage function
*!* 07/24/2001  Parameter tcContainer changed.
*!*             If type of the tcContainer is Character -> container block exist 
*!*             (VFP data file)
*!*             - if length of tcContainer is zero, container block isn't overwritten
*!*             - if length of tcContainer is greater than zero, 
*!*               container block is overwritten with the value in tcContainer
*!*             If type of the tcContainer is not Character -> container block 
*!*             doesn't exist (no VFP data file)
*!* 07/24/2001  tnRepairMode = 1 generated an error, FIXED
*!* 07/24/2001  error when fixing free table without container block, FIXED
*!*             NOTE: in the above case DO NOT GIVE a character value to the tcContainer
*!* 07/24/2001  tnRepairMode = 4 ADDED. If tnRepairMode 1 or 3 (table), 
*!*             new fixed header is overwritten to the old data file
*!*             If tnRepairmode = 4 new file is generated first and old data file
*!*             is overwritten with the new one. (this is the next step to the 
*!*             next version where user can input field block if it is corrupted.
*!* 07/25/2001  Windir changed to the Temp dir
*!* Version 1.3b
*!* 08/03/2001  Table and memo backup doesn't have same serial number in extension. FIXED
*!* 08/05/2001  tlNoInfo changed to tnInfo for better info support
*!* tnInfo      0 (or not numeric value) no info
*!*             1 Info to the screen
*!*             2 Info to the file
*!*             3 Info to the screen and file
*!*             
*!* 08/05/2001  Check for the file extension added
*!* 08/05/2001  Error return value is now much more meaningful
*!* Version 1.4a
*!* 08/08/2001  If container block is lesser than 263 bytes and contains EOF mark
*!*             it can be fixed now (at least try to fix).
*!* 08/08/2001  If file type (first byte of the header) is corrupted, it can be fixed now
*!* 08/08/2001  check for not allowed characters in container block added
*!* 08/08/2001  Default language is now english
*!* 08/08/2001  If first byte of the data (record) is not 0x20 or 0x2A and tnRepairMode = 4 or 6
*!*             it is fixed (to 0x20)
*!* 08/08/2001  Bug with m.tnInfo = 1 or 2. FIXED
*!* Version 1.5b
*!* 08/09/2001  Info window is now automaticly row adjusted
*!* 08/09/2001  Error if not enough disk space for a backup. FIXED
*!* 08/09/2001  Error if not enough disk space for a tnRepairMode = 4 or 6. FIXED
*!* 08/09/2001  Error if not enough disk space for a info TEMP file. FIXED
*!*             In this case info can be printed.
*!* 08/09/2001  Added characters in "not allowed characters check" in container block
*!* 08/09/2001  Bug related to the situation when EOF mark is in the header fixed.
*!* 08/09/2001  Running Software in VFP5 added (VFP6 and VFP7 already)
*!* 09/09/2001  File size check for demos
*!* 11/22/2001  lcFptFixedHdr and lcFptHeader variable not found errors fixed
*!* Version 1.6
*!* 05/24/2003  All Messages Translated to Protuguese ( Brazil ) - Fernando Borges 
*!*             Next messages added after translation 98,99,110,111,112,113,114,115,300,301
*!*             and are in Finnish and English only.
*!* 08/07/2003  DO not use TMPDBF to save/write data but use FWRITE to write
*!*             temporary binary file instead. See parameter lUseTmpDbf
*!* 08/07/2003  Added Autoincrement support 
*!*             Fix garbage after last record IN VFP8 added (tnRepairMode = 4)
*!* 08/07/2003  Variable 'LNFPTBLOCKSIZE' is not found fixed.
*!*             Variable 'tWhatFpt' is not found fixed.
*!*
*!* NOTES:      Please if you have any wishes or improvements (or bugs??), e-mail me.
*!*
*!* 08/07/2003  tnRepairMode = 5 / 6 is still same than tnRepairMode = 2 / 3
*!*             I may update AtFixDbfFpt to read Memo files byte by byte and
*!*             use that to write repaired data (tnRepairMode = 5 / 6). But
*!*             when I haven't needed it and because this hasn't been any commercial
*!"             success to cover any expenses...
*!*              
*!*             email without _nospam is valid
*!****************************************************************************
 LPARAMETER tcWhatdbf, tnRepairmode, tcContainer, tnMemoblocksice, tnInfo,  ;
            tlNobackups, tnLang, luSetmpdbf
 LOCAL lnRetforcopy, lnMaxfilesize
 IF TYPE("m.tnLang")<>"N" .OR. M.tnLang<1
      M.tnLang = 2
 ENDIF
 M.lnRetforcopy = fiXmessage(300, , ,M.tnLang)
 M.tcWhatdbf = FULLPATH(M.tcWhatdbf)
 IF EMPTY(JUSTEXT(M.tcWhatdbf))
      fiXmessage(98,M.tcWhatdbf, ,M.tnLang)
      RETURN -50
 ENDIF
 IF  .NOT. FILE(M.tcWhatdbf)
      fiXmessage(100,M.tcWhatdbf, ,M.tnLang)
      RETURN -50
 ELSE
      M.lnMaxfilesize = 10485760000
      IF ADIR(afIleinfo, M.tcWhatdbf)=1
           IF .f. &&afIleinfo(1,2)>M.lnMaxfilesize
                fiXmessage(301,JUSTFNAME(M.tcWhatdbf)+"????"+ ;
                          ALLTRIM(STR(afIleinfo(1,2))),M.lnMaxfilesize, ;
                          M.tnLang)
                RETURN -50
           ENDIF
      ELSE
           fiXmessage(100,M.tcWhatdbf, ,M.tnLang)
           RETURN -50
      ENDIF
 ENDIF
 IF TYPE("m.tnRepairMode")<>"N"
      M.tnRepairmode = 0
 ELSE
      M.tnRepairmode = ABS(M.tnRepairmode)
 ENDIF
 IF TYPE("m.tcContainer")="C"
      M.tcContainer = LOWER(ALLTRIM(M.tcContainer))
      IF  .NOT. EMPTY(M.tcContainer)
           IF EMPTY(JUSTEXT(M.tcContainer))
                fiXmessage(99,M.tcContainer, ,M.tnLang)
                RETURN -50
           ENDIF
           IF  .NOT. FILE(M.tcContainer)
                fiXmessage(101,M.tcContainer, ,M.tnLang)
                RETURN -50
           ENDIF
      ENDIF
 ELSE
      M.tcContainer = .F.
 ENDIF
 IF TYPE("m.tnMemoBlockSice")<>"N" .OR. M.tnMemoblocksice<0
      M.tnMemoblocksice = SET("BLOCKSIZE")
 ELSE
      M.tnMemoblocksice = INT(M.tnMemoblocksice)
 ENDIF
 IF TYPE("m.tnInfo")<>"N"
      M.tnInfo = 0
 ELSE
      IF M.tnInfo<0 .OR. M.tnInfo>3
           M.tnInfo = 0
      ENDIF
 ENDIF
 IF TYPE("m.tlNoBackups")<>"L"
      M.tlNobackups = .F.
 ENDIF
 LOCAL lnSelect, lcTmpdbf, lnDisksizer, lcTmpbinfile
 M.lnDisksizer = 1+VAL(SET("POINT")+"3")
 M.lnSelect = SELECT()
 M.lcTmpdbf = ""
 M.lcTmpbinfile = ""
 IF M.tnRepairmode>3 .AND. M.luSetmpdbf .OR.  ;
    VAL(ALLTRIM(STRTRAN(UPPER(VERSION()), 'VISUAL FOXPRO', '')))<7
      LOCAL lcMytempdir, lcExclusive
      M.lcExclusive = SET("EXCLUSIVE")
      SELECT 0
      M.lcMytempdir = IIF(LEN(GETENV('TEMP'))=0, SYS(5)+CURDIR()+IIF(  ;
                      .NOT. RIGHT(CURDIR(), 1)=='\', '\', ''),  ;
                      GETENV('TEMP')+IIF( .NOT. RIGHT(GETENV('TEMP'), 1)== ;
                      '\', '\', ''))
      M.lcTmpdbf = M.lcMytempdir+SYS(2015)
      DO WHILE FILE(M.lcTmpdbf+".DBF") .OR. FILE(M.lcTmpdbf+".FPT")
           M.lcTmpdbf = M.lcMytempdir+SYS(2015)
      ENDDO
      SET EXCLUSIVE ON
      CREATE TABLE (M.lcTmpdbf) FREE (atFix M NOCPTRANS)
      SET EXCLUSIVE &lcExclusive
      APPEND BLANK
 ENDIF
 LOCAL lcMytempdir, lnTmphandler, lnSeekprefixlen
 M.lnHandlertmp = 0
 M.lnSeekprefixlen = 0
 M.lcMytempdir = IIF(LEN(GETENV('TEMP'))=0, SYS(5)+CURDIR()+IIF( .NOT.  ;
                 RIGHT(CURDIR(), 1)=='\', '\', ''), GETENV('TEMP')+IIF(  ;
                 .NOT. RIGHT(GETENV('TEMP'), 1)=='\', '\', ''))
 M.lcTmpbinfile = M.lcMytempdir+SYS(2015)+".BIN"
 DO WHILE FILE(M.lcTmpbinfile)
      M.lcTmpbinfile = M.lcMytempdir+SYS(2015)+".BIN"
 ENDDO
 IF TYPE("m.lnRetForCopy")<>"N"
      M.lnRetforcopy = fiXmessage(300, , ,M.tnLang)
 ENDIF
 LOCAL lnError, lnHandler, lcReason, lnI, lcBackfile, lcInfo, lcInfofile,  ;
       laFilesize[1]
 M.lnHandler = 0
 IF TYPE("m.lnRetForCopy")<>"N"
      M.lnRetforcopy = fiXmessage(300, , ,M.tnLang)
 ENDIF
 IF  .NOT. M.tlNobackups .AND. INLIST(M.tnRepairmode, 1, 3, 4, 6)
      ADIR(laFilesize, M.tcWhatdbf)
      IF TYPE("m.laFileSize[1,2]")<>"N" .OR. M.laFilesize(1,2)* ;
         M.lnDisksizer<DISKSPACE(SYS(5))
           M.lcBackfile = M.tcWhatdbf+"00"
           IF FILE(M.lcBackfile)
                FOR M.lnI = 1 TO 99
                     M.lcBackfile = M.tcWhatdbf+PADL(ALLTRIM(STR(M.lnI)),  ;
                                    2, "0")
                     IF  .NOT. FILE(M.lcBackfile)
                          EXIT
                     ELSE
                          IF M.lnI=99 .AND. FILE(M.lcBackfile)
                               ERASE (M.lcBackfile)
                               EXIT
                          ENDIF
                     ENDIF
                ENDFOR
           ENDIF
           WAIT CLEAR
           fiXmessage(102,M.tcWhatdbf,M.lcBackfile,tnLang)
           COPY FILE (M.tcWhatdbf) TO (M.lcBackfile)
           WAIT CLEAR
           fiXmessage(103,M.lcBackfile, ,tnLang)
      ELSE
           IF fiXmessage(113,M.tcWhatdbf, ,tnLang)<>6
                RETURN fiXexit(-60,M.lcTmpdbf,M.lcTmpbinfile,M.lnSelect, ;
                       M.lnHandler,M.tnLang)
           ENDIF
      ENDIF
 ENDIF
 M.lnHandler = FOPEN(M.tcWhatdbf, 12)
 IF M.lnHandler<0
      M.lnError = FERROR()
      fiXmessage(104+VAL(SET("POINT")+ALLTRIM(STR(M.lnError))), ;
                M.tcWhatdbf, ,tnLang)
      RETURN fiXexit(-1*M.lnError,M.lcTmpdbf,M.lcTmpbinfile,M.lnSelect, ;
             M.lnHandler,M.tnLang)
 ENDIF
 LOCAL llTableisalreadyok, lnFilesize, lnHeaderblocksize, lcTableheader,  ;
       lcTblheaderbyteone, lcTablefixedhdr, lcMemobyte, lcTablecontainer1,  ;
       lcTablecontainer2, lcFixedcontainer1, lcFixedcontainer2,  ;
       lnOnefieldblocksize, lcHeaderrecterminator, lnContainerblocksize,  ;
       lcFileterminator, lnDatastart1, lnRecsize1, lnReccount1,  ;
       lnDatastart2, lnRecsize2, lnReccount2, lnDatastart3, lnRecsize3,  ;
       lnReccount3, lnFieldco3, lnRecsize4, lnNullflaglen,  ;
       lnAllfieldblocksize, llIsmemo1, llIsmemo2, llIsmemo3, lcCodepage,  ;
       lcFixerror, lcFielderror, lcMemoerror, lcWhatfpt, lcFieldinfo,  ;
       lcAllfieldinfo, llFieldnameok, llFieldtypeok, llFielddecok,  ;
       lnFieldlen, lnI, lnK, lcSafety, llTablerepaired, llMemorepaired,  ;
       lnTooslowtohandle, lcFileorigin, lnRetval
 M.llTableisalreadyok = .F.
 M.lnFilesize = 0
 M.lcTableheader = ""
 M.lcTblheaderbyteone = ""
 M.lcTablefixedhdr = ""
 M.lcMemobyte = ""
 M.lcTablecontainer1 = ""
 M.lcTablecontainer2 = ""
 M.lcFixedcontainer1 = ""
 M.lcFixedcontainer2 = ""
 M.lnDatastart1 = 0
 M.lnRecsize1 = 0
 M.lnReccount1 = 0
 M.lnDatastart2 = 0
 M.lnRecsize2 = 0
 M.lnReccount2 = 0
 M.lnReccount3 = 0
 M.lnAllfieldblocksize = 0
 M.llIsmemo1 = .F.
 M.llIsmemo2 = .F.
 M.llIsmemo3 = .F.
 M.lcCodepage = CHR(0)
 M.lcFixerror = "0000000000"
 M.lcFielderror = "000000"
 M.lcMemoerror = "000000"
 M.lcWhatfpt = ""
 M.lcFieldinfo = ""
 M.lcAllfieldinfo = ""
 M.llFieldnameok = .F.
 M.llFieldtypeok = .F.
 M.llFielddecok = .F.
 M.lnFieldlen = 0
 M.lnI = 0
 M.lnK = 0
 M.llTablerepaired = .F.
 M.llMemorepaired = .F.
 M.lcFileorigin = ""
 M.lnRetval = 0
 M.lnNullflaglen = 0
 M.lnDatastart3 = 0
 M.lnRecsize3 = 0
 M.lnRecsize4 = 0
 M.lnFieldco3 = 0
 M.lnHeaderblocksize = 32
 M.lcHeaderrecterminator = CHR(013)
 M.lnOnefieldblocksize = 32
 M.lcFileterminator = CHR(026)
 M.lnTooslowtohandle = 3000
 M.lcWhatfpt = ADDBS(JUSTPATH(M.tcWhatdbf))+JUSTSTEM(M.tcWhatdbf)
 DO CASE
      CASE UPPER(JUSTEXT(M.tcWhatdbf))="DBC"
           M.lcWhatfpt = M.lcWhatfpt+".DCT"
      CASE UPPER(JUSTEXT(M.tcWhatdbf))="DBF"
           M.lcWhatfpt = M.lcWhatfpt+".FPT"
      CASE UPPER(JUSTEXT(M.tcWhatdbf))="FRX"
           M.lcWhatfpt = M.lcWhatfpt+".FRT"
      CASE UPPER(JUSTEXT(M.tcWhatdbf))="LBX"
           M.lcWhatfpt = M.lcWhatfpt+".LBT"
      CASE UPPER(JUSTEXT(M.tcWhatdbf))="MNX"
           M.lcWhatfpt = M.lcWhatfpt+".MNT"
      CASE UPPER(JUSTEXT(M.tcWhatdbf))="PJX"
           M.lcWhatfpt = M.lcWhatfpt+".PJT"
      CASE UPPER(JUSTEXT(M.tcWhatdbf))="SCX"
           M.lcWhatfpt = M.lcWhatfpt+".SCT"
      CASE UPPER(JUSTEXT(M.tcWhatdbf))="VCX"
           M.lcWhatfpt = M.lcWhatfpt+".VCT"
      OTHERWISE
 ENDCASE
 M.lnFilesize = FSEEK(M.lnHandler, 0, 2)
 FSEEK(M.lnHandler, 0, 0)
 M.lcTableheader = FREAD(M.lnHandler, M.lnHeaderblocksize)
 M.lnError = FERROR()
 IF M.lnError<>0
      fiXmessage(105,M.tcWhatdbf, ,tnLang)
      RETURN fiXexit(-1*M.lnError,M.lcTmpdbf,M.lcTmpbinfile,M.lnSelect, ;
             M.lnHandler,M.tnLang)
 ENDIF
 M.llIsmemo1 = FILE(M.lcWhatfpt)
 M.lcTblheaderbyteone = LEFT(M.lcTableheader, 1)
 DO CASE
      CASE LEFT(M.lcTableheader, 1)=CHR(002)
           M.lcFileorigin = "FoxBASE"
           M.llIsmemo2 = .F.
           M.tcContainer = .F.
      CASE LEFT(M.lcTableheader, 1)=CHR(003)
           M.lcFileorigin = "FoxBASE+ / dBASE III PLUS, FoxPro, dBaseIV, no memo"
           M.llIsmemo2 = .F.
           M.tcContainer = .F.
      CASE LEFT(M.lcTableheader, 1)=CHR(048)
           M.lcFileorigin = "Visual FoxPro"
           M.llIsmemo2 = (SUBSTR(deCtobin(ASC(SUBSTR(M.lcTableheader, 29,  ;
                         1))), 7, 1)="1")
           IF  .NOT. TYPE("m.tcContainer")=="C"
                M.tcContainer = ""
           ENDIF
      CASE LEFT(M.lcTableheader, 1)=CHR(049)
           M.lcFileorigin = "Visual FoxPro, Autoincrement"
           M.llIsmemo2 = (SUBSTR(deCtobin(ASC(SUBSTR(M.lcTableheader, 29,  ;
                         1))), 7, 1)="1")
           IF  .NOT. TYPE("m.tcContainer")=="C"
                M.tcContainer = ""
           ENDIF
      CASE LEFT(M.lcTableheader, 1)=CHR(067)
           M.lcFileorigin = "dBASE IV SQL table files, no memo"
           M.llIsmemo2 = .F.
           M.tcContainer = .F.
      CASE LEFT(M.lcTableheader, 1)=CHR(099)
           M.lcFileorigin = "dBASE IV SQL system files, no memo"
           M.llIsmemo2 = .F.
           M.tcContainer = .F.
      CASE LEFT(M.lcTableheader, 1)=CHR(131)
           M.lcFileorigin = "FoxBASE+ / dBASE III PLUS, with memo"
           M.llIsmemo2 = .T.
           M.tcContainer = .F.
      CASE LEFT(M.lcTableheader, 1)=CHR(139)
           M.lcFileorigin = "dBASE IV with memo"
           M.llIsmemo2 = .T.
           M.tcContainer = .F.
      CASE LEFT(M.lcTableheader, 1)=CHR(203)
           M.lcFileorigin = "dBASE IV SQL table files, with memo"
           M.llIsmemo2 = .T.
           M.tcContainer = .F.
      CASE LEFT(M.lcTableheader, 1)=CHR(245)
           M.lcFileorigin = "FoxPro(D/W) 2.x (or earlier) with memo"
           M.llIsmemo2 = .T.
           M.tcContainer = .F.
      CASE LEFT(M.lcTableheader, 1)=CHR(251)
           M.lcFileorigin = "FoxBASE with memo"
           M.llIsmemo2 = .F.
           M.tcContainer = .F.
      OTHERWISE
           M.lnRetval = fiXmessage(110, , ,tnLang)
           M.lcFixerror = STUFF(M.lcFixerror, 10, 1, "1")
           DO CASE
                CASE M.lnRetval=1
                     M.lcTableheader = STUFF(M.lcTableheader, 1, 1, CHR(002))
                     M.lcFileorigin = "FoxBASE"
                     M.llIsmemo2 = .F.
                     M.tcContainer = .F.
                CASE M.lnRetval=2
                     M.lcTableheader = STUFF(M.lcTableheader, 1, 1, CHR(003))
                     M.lcFileorigin = "FoxBASE+ / dBASE III PLUS, FoxPro, dBaseIV, no memo"
                     M.llIsmemo2 = .F.
                     M.tcContainer = .F.
                CASE M.lnRetval=3
                     M.lcTableheader = STUFF(M.lcTableheader, 1, 1, CHR(048))
                     M.lcFileorigin = "Visual FoxPro"
                     M.llIsmemo2 = (SUBSTR(deCtobin(ASC(SUBSTR(M.lcTableheader,  ;
                                   29, 1))), 7, 1)="1")
                     IF  .NOT. TYPE("m.tcContainer")=="C"
                          M.tcContainer = ""
                     ENDIF
                CASE M.lnRetval=4
                     M.lcTableheader = STUFF(M.lcTableheader, 1, 1, CHR(049))
                     M.lcFileorigin = "Visual FoxPro, Autoincrement"
                     M.llIsmemo2 = (SUBSTR(deCtobin(ASC(SUBSTR(M.lcTableheader,  ;
                                   29, 1))), 7, 1)="1")
                     IF  .NOT. TYPE("m.tcContainer")=="C"
                          M.tcContainer = ""
                     ENDIF
                CASE M.lnRetval=5
                     M.lcTableheader = STUFF(M.lcTableheader, 1, 1, CHR(067))
                     M.lcFileorigin = "dBASE IV SQL table files, no memo"
                     M.llIsmemo2 = .F.
                     M.tcContainer = .F.
                CASE M.lnRetval=6
                     M.lcTableheader = STUFF(M.lcTableheader, 1, 1, CHR(099))
                     M.lcFileorigin = "dBASE IV SQL system files, no memo"
                     M.llIsmemo2 = .F.
                     M.tcContainer = .F.
                CASE M.lnRetval=7
                     M.lcTableheader = STUFF(M.lcTableheader, 1, 1, CHR(131))
                     M.lcFileorigin = "FoxBASE+ / dBASE III PLUS, with memo"
                     M.llIsmemo2 = .T.
                     M.tcContainer = .F.
                CASE M.lnRetval=8
                     M.lcTableheader = STUFF(M.lcTableheader, 1, 1, CHR(139))
                     M.lcFileorigin = "dBASE IV with memo"
                     M.llIsmemo2 = .T.
                     M.tcContainer = .F.
                CASE M.lnRetval=9
                     M.lcTableheader = STUFF(M.lcTableheader, 1, 1, CHR(203))
                     M.lcFileorigin = "dBASE IV SQL table files, with memo"
                     M.llIsmemo2 = .T.
                     M.tcContainer = .F.
                CASE M.lnRetval=10
                     M.lcTableheader = STUFF(M.lcTableheader, 1, 1, CHR(245))
                     M.lcFileorigin = "FoxPro 2.x (or earlier) with memo"
                     M.llIsmemo2 = .T.
                     M.tcContainer = .F.
                CASE M.lnRetval=11
                     M.lcTableheader = STUFF(M.lcTableheader, 1, 1, CHR(251))
                     M.lcFileorigin = "FoxBASE with memo"
                     M.llIsmemo2 = .F.
                     M.tcContainer = .F.
           ENDCASE
 ENDCASE
 M.lnContainerblocksize = IIF(TYPE("m.tcContainer")=="C", 263, 0)
 M.llIsmemo3 = .F.
 M.lcCodepage = CHR(001)+CHR(105)+CHR(106)+CHR(002)+CHR(100)+CHR(107)+ ;
                CHR(103)+CHR(102)+CHR(101)+CHR(104)+CHR(200)+CHR(201)+ ;
                CHR(003)+CHR(203)+CHR(202)+CHR(004)+CHR(152)+CHR(150)+CHR(151)
 M.lcCodepage = IIF(SUBSTR(M.lcTableheader, 30, 1)$M.lcCodepage,  ;
                SUBSTR(M.lcTableheader, 30, 1), CHR(0))
 M.lnDatastart2 = unLsbmsb(SUBSTR(M.lcTableheader, 9, 2))
 M.lnRecsize2 = unLsbmsb(SUBSTR(M.lcTableheader, 11, 2))
 IF TYPE("m.lnRetForCopy")<>"N"
      M.lnRetforcopy = fiXmessage(300, , ,M.tnLang)
 ENDIF
 FSEEK(M.lnHandler, M.lnHeaderblocksize, 0)
 DO WHILE .T.
      M.lcFieldinfo = FREAD(M.lnHandler, M.lnOnefieldblocksize)
      M.lnError = FERROR()
      IF M.lnError<>0
           fiXmessage(105,M.tcWhatdbf, ,tnLang)
           RETURN fiXexit(-1*M.lnError,M.lcTmpdbf,M.lcTmpbinfile, ;
                  M.lnSelect,M.lnHandler,M.tnLang)
      ENDIF
      IF  .NOT. LEFT(M.lcFieldinfo, 1)==M.lcHeaderrecterminator .AND.   ;
          .NOT. FEOF(M.lnHandler)
           M.lcAllfieldinfo = M.lcAllfieldinfo+M.lcFieldinfo
           M.llFieldnameok = .T.
           M.llFieldtypeok = .T.
           M.llFielddecok = .T.
           IF LEFT(M.lcFieldinfo, 10)<>"_NullFlags"
                M.lnFieldco3 = M.lnFieldco3+1
                M.lnFieldlen = ASC(SUBSTR(M.lcFieldinfo, 17, 1))
                M.llFieldnameok = ISALPHA(LEFT(M.lcFieldinfo, 1))
                IF  .NOT. M.llFieldnameok
                     M.lcFielderror = STUFF(M.lcFielderror, 1, 1, "1")
                ENDIF
                M.lnI = AT(CHR(0), SUBSTR(M.lcFieldinfo, 1, 10))
                IF M.lnI=1
                     M.lcFielderror = STUFF(M.lcFielderror, 2, 1, "1")
                ENDIF
                M.lnI = IIF(M.lnI=0, 10, M.lnI-1)
                FOR M.lnK = 2 TO M.lnI
                     M.llFieldnameok = IIF( .NOT.  ;
                                       (ISALPHA(SUBSTR(M.lcFieldinfo,  ;
                                       M.lnK, 1)) .OR.  ;
                                       ISDIGIT(SUBSTR(M.lcFieldinfo,  ;
                                       M.lnK, 1)) .OR.  ;
                                       SUBSTR(M.lcFieldinfo, M.lnK, 1)= ;
                                       CHR(95)), .F., M.llFieldnameok)
                ENDFOR
                IF  .NOT. M.llFieldnameok
                     M.lcFielderror = STUFF(M.lcFielderror, 3, 1, "1")
                ENDIF
                IF LEFT(M.lcTableheader, 1)="0"
                     M.llFieldtypeok = (SUBSTR(M.lcFieldinfo, 12, 1)$ ;
                                       "BCDFGILMNPTY")
                ELSE
                     M.llFieldtypeok = (SUBSTR(M.lcFieldinfo, 12, 1)$"CNFDLMG")
                ENDIF
                IF  .NOT. M.llFieldtypeok
                     M.lcFielderror = STUFF(M.lcFielderror, 4, 1, "1")
                ENDIF
                IF SUBSTR(M.lcFieldinfo, 12, 1)<>"B"
                     M.llFielddecok = (ASC(SUBSTR(M.lcFieldinfo, 18, 1))< ;
                                      M.lnFieldlen)
                ELSE
                     M.llFielddecok = .T.
                ENDIF
                IF  .NOT. M.llFielddecok
                     M.lcFielderror = STUFF(M.lcFielderror, 5, 1, "1")
                ENDIF
                IF M.llFieldtypeok
                     M.llIsmemo3 = IIF(SUBSTR(M.lcFieldinfo, 12, 1)$"GM",  ;
                                   .T., M.llIsmemo3)
                ENDIF
                IF AT("1", M.lcFielderror)>0
                     EXIT
                ELSE
                     M.lnRecsize3 = IIF(M.lnRecsize3=0, 1, 0)+ ;
                                    M.lnRecsize3+ ;
                                    unLsbmsb(SUBSTR(M.lcFieldinfo, 17, 1))
                ENDIF
                M.lnRecsize4 = MAX(M.lnRecsize4,  ;
                               unLsbmsb(SUBSTR(M.lcFieldinfo, 13, 2))+ ;
                               M.lnFieldlen)
           ELSE
                M.lnNullflaglen = unLsbmsb(SUBSTR(M.lcFieldinfo, 17, 1))
           ENDIF
      ELSE
           M.lnAllfieldblocksize = M.lnFieldco3*M.lnOnefieldblocksize
           IF  .NOT. LEFT(M.lcFieldinfo, 1)==M.lcHeaderrecterminator .OR.  ;
               OCCURS(M.lcHeaderrecterminator, M.lcFieldinfo)>1
                M.lcFixerror = STUFF(M.lcFixerror, 3, 1, "1")
           ELSE
                IF TYPE("m.tcContainer")="C"
                     FSEEK(M.lnHandler, M.lnHeaderblocksize+ ;
                          M.lnAllfieldblocksize+SIGN(M.lnNullflaglen)* ;
                          M.lnOnefieldblocksize+ ;
                          LEN(M.lcHeaderrecterminator), 0)
                     M.lcTablecontainer1 = FREAD(M.lnHandler,  ;
                      M.lnContainerblocksize)
                     M.lcTablecontainer2 = STRTRAN(M.lcTablecontainer1,  ;
                      CHR(000), "")
                     M.lnError = FERROR()
                     IF M.lnError<>0 .AND. M.tnRepairmode<>0
                          fiXmessage(105,M.tcWhatdbf, ,tnLang)
                          RETURN fiXexit(-1*M.lnError,M.lcTmpdbf, ;
                                 M.lcTmpbinfile,M.lnSelect,M.lnHandler, ;
                                 M.tnLang)
                     ENDIF
                ENDIF
                IF INLIST(M.tnRepairmode, 1, 3, 4, 6)
                     IF LEFT(M.lcTableheader, 1)=CHR(048)
                          IF EMPTY(M.tcContainer) .AND. (AT('/',  ;
                             M.lcTablecontainer1)>0 .OR. AT('?',  ;
                             M.lcTablecontainer1)>0 .OR. AT('*',  ;
                             M.lcTablecontainer1)>0 .OR. AT('#',  ;
                             M.lcTablecontainer1)>0 .OR. AT('>',  ;
                             M.lcTablecontainer1)>0 .OR. AT('<',  ;
                             M.lcTablecontainer1)>0 .OR. AT('|',  ;
                             M.lcTablecontainer1)>0 .OR. AT('"',  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(1),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(2),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(3),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(4),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(5),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(6),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(7),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(8),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(9),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(10),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(11),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(12),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(13),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(14),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(15),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(16),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(17),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(18),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(19),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(20),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(21),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(22),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(23),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(24),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(25),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(26),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(27),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(28),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(29),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(30),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(31),  ;
                             M.lcTablecontainer1)>0 .OR. AT(CHR(127),  ;
                             M.lcTablecontainer1)>0 .OR.  ;
                             LEFT(M.lcTablecontainer1, 1)=" ")
                               M.lcFixerror = STUFF(M.lcFixerror, 6, 1, "1")
                          ENDIF
                     ENDIF
                ENDIF
           ENDIF
           EXIT
      ENDIF
 ENDDO
 IF FEOF(M.lnHandler)
      DO CASE
           CASE M.lnFieldco3=0
                M.lcFixerror = STUFF(M.lcFixerror, 1, 1, "1")
           CASE M.lnAllfieldblocksize=0
                M.lcFixerror = STUFF(M.lcFixerror, 2, 1, "1")
           CASE MOD((M.lnAllfieldblocksize-1), 32)<>0
                M.lcFixerror = STUFF(M.lcFixerror, 3, 1, "1")
           CASE LEFT(M.lcTableheader, 1)="0"
                M.lcFixerror = STUFF(M.lcFixerror, 4, 1, "1")
           CASE LEFT(M.lcTableheader, 1)<>"0"
                IF LEN(M.lcFieldinfo)=1
                ELSE
                     IF M.lnRecsize3>=M.lnOnefieldblocksize
                          M.lcFixerror = STUFF(M.lcFixerror, 7, 1, "1")
                     ENDIF
                ENDIF
           OTHERWISE
                WAIT WINDOW TIMEOUT 3  ;
                     "It should not come ever here. Press a key to debug"
                IF LASTKEY()=65 .OR. LASTKEY()=97
                     SET STEP ON
                ENDIF
      ENDCASE
 ELSE
 ENDIF
 M.lnDatastart3 = M.lnHeaderblocksize+M.lnAllfieldblocksize+ ;
                  SIGN(M.lnNullflaglen)*M.lnOnefieldblocksize+ ;
                  LEN(M.lcHeaderrecterminator)+IIF(LEFT(M.lcTableheader,  ;
                  1)="0", M.lnContainerblocksize, 0)
 IF M.lnRecsize4<>M.lnRecsize3
      M.lcFixerror = STUFF(M.lcFixerror, 8, 1, "1")
 ENDIF
 M.lnRecsize3 = M.lnRecsize3+M.lnNullflaglen
 M.lnRecsize4 = M.lnRecsize4+M.lnNullflaglen
 M.lnReccount1 = INT((M.lnFilesize-M.lnDatastart2)/M.lnRecsize2)
 M.lnReccount2 = unLsbmsb(SUBSTR(M.lcTableheader, 5, 4))
 M.lnReccount3 = INT((M.lnFilesize-M.lnDatastart3)/M.lnRecsize3)
 IF M.lnReccount3<>M.lnReccount2 .OR. M.lnReccount3<>M.lnReccount1 .OR.  ;
    M.lnReccount2<>M.lnReccount1
      M.lcFixerror = STUFF(M.lcFixerror, 9, 1, "1")
 ENDIF
 IF TYPE("m.lnRetForCopy")<>"N"
      M.lnRetforcopy = fiXmessage(300, , ,M.tnLang)
 ENDIF
 IF M.lnFilesize>M.lnDatastart3+M.lnReccount3*M.lnRecsize3+ ;
    LEN(M.lcFileterminator)
      M.lcFixerror = STUFF(M.lcFixerror, 5, 1, "1")
 ENDIF
 IF INLIST(M.tnRepairmode, 0, 1, 2, 3, 4, 5, 6)
      IF INLIST(M.tnRepairmode, 4, 6)
           ADIR(laFilesize, M.tcWhatdbf)
           IF TYPE("m.laFileSize[1,2]")<>"N" .OR. M.laFilesize(1,2)* ;
              M.lnDisksizer>DISKSPACE(SYS(5))
                IF fiXmessage(114,M.tnRepairmode, ,tnLang)<>6
                     RETURN fiXexit(-61,M.lcTmpdbf,M.lcTmpbinfile, ;
                            M.lnSelect,M.lnHandler,M.tnLang)
                ELSE
                     M.tnRepairmode = M.tnRepairmode-3
                ENDIF
           ENDIF
      ENDIF
      DO CASE
           CASE (AT("1", M.lcFixerror)>0 .AND. AT("1", M.lcFixerror)<5)  ;
                .OR. AT("1", M.lcFielderror)>0
                fiXmessage(106,M.tcWhatdbf,"R"+M.lcFixerror+" F"+ ;
                          M.lcFielderror,tnLang)
           CASE AT("1", M.lcFixerror)=6 .AND.  .NOT.  ;
                INLIST(M.tnRepairmode, 0, 2, 5)
                fiXmessage(111, , ,tnLang)
           CASE AT("1", M.lcFixerror)=7 .AND.  .NOT.  ;
                INLIST(M.tnRepairmode, 0, 4, 6)
                fiXmessage(112, , ,tnLang)
           CASE AT("1", M.lcFixerror)>7 .OR. AT("1", M.lcFixerror)=5 .OR.  ;
                M.lnDatastart2<>M.lnDatastart3 .OR. M.tnRepairmode=0
                M.lcFixedcontainer1 = ""
                IF TYPE("m.tcContainer")="C" .AND.  .NOT. EMPTY(M.tcContainer)
                     M.lcFixedcontainer1 = PADR(M.tcContainer,  ;
                      M.lnContainerblocksize, CHR(000))
                     M.lcFixedcontainer2 = STRTRAN(M.lcFixedcontainer1,  ;
                      CHR(000), "")
                ENDIF
                IF LEFT(M.lcTableheader, 1)="0"
                     IF M.llIsmemo3
                          M.lcMemobyte =  ;
                           STUFF(deCtobin(ASC(SUBSTR(M.lcTableheader, 29,  ;
                           1))), 7, 1, "1")
                     ELSE
                          M.lcMemobyte =  ;
                           STUFF(deCtobin(ASC(SUBSTR(M.lcTableheader, 29,  ;
                           1))), 7, 1, "0")
                     ENDIF
                     M.lcTablefixedhdr = "0"+ ;
                      CHR(VAL(RIGHT(STR(YEAR(DATE())), 2)))+ ;
                      CHR(MONTH(DATE()))+CHR(DAY(DATE()))+ ;
                      toLsbmsb(M.lnReccount3,4)+toLsbmsb(M.lnDatastart3, ;
                      2)+toLsbmsb(M.lnRecsize3,2)+SUBSTR(M.lcTableheader,  ;
                      13, 16)+CHR(biNtodec(M.lcMemobyte))+M.lcCodepage+ ;
                      SUBSTR(M.lcTableheader, 31, 2)
                ELSE
                     IF M.llIsmemo3
                          DO CASE
                               CASE LEFT(M.lcTableheader, 1)=CHR(002)  ;
                                    .OR. LEFT(M.lcTableheader, 1)=CHR(251)
                                    M.lcMemobyte = CHR(251)
                               CASE LEFT(M.lcTableheader, 1)=CHR(003)
                                    M.lcMemobyte = CHR(245)
                               CASE LEFT(M.lcTableheader, 1)=CHR(067)
                                    M.lcMemobyte = CHR(203)
                               CASE LEFT(M.lcTableheader, 1)=CHR(131)
                                    M.lcMemobyte = CHR(131)
                               CASE LEFT(M.lcTableheader, 1)=CHR(139)
                                    M.lcMemobyte = CHR(139)
                               CASE LEFT(M.lcTableheader, 1)=CHR(245)
                                    M.lcMemobyte = CHR(245)
                               CASE LEFT(M.lcTableheader, 1)=CHR(099)
                                    M.lcMemobyte = CHR(203)
                               OTHERWISE
                                    M.lcMemobyte = CHR(139)
                          ENDCASE
                     ELSE
                          M.lcMemobyte = CHR(003)
                     ENDIF
                     M.lcTablefixedhdr = M.lcMemobyte+ ;
                      CHR(VAL(RIGHT(STR(YEAR(DATE())), 2)))+ ;
                      CHR(MONTH(DATE()))+CHR(DAY(DATE()))+ ;
                      toLsbmsb(M.lnReccount3,4)+toLsbmsb(M.lnDatastart3, ;
                      2)+toLsbmsb(M.lnRecsize3,2)+SUBSTR(M.lcTableheader,  ;
                      13, 17)+M.lcCodepage+SUBSTR(M.lcTableheader, 31, 2)
                ENDIF
                DO CASE
                     CASE INLIST(M.tnRepairmode, 1, 3)
                          FSEEK(M.lnHandler, 0, 0)
                          FWRITE(M.lnHandler, M.lcTablefixedhdr)
                          M.lnError = FERROR()
                          IF M.lnError<>0
                               fiXmessage(105,M.tcWhatdbf, ,tnLang)
                               RETURN fiXexit(-1*M.lnError,M.lcTmpdbf, ;
                                      M.lcTmpbinfile,M.lnSelect, ;
                                      M.lnHandler,M.tnLang)
                          ENDIF
                          IF TYPE("m.tcContainer")="C" .AND.  .NOT.  ;
                             EMPTY(M.lcFixedcontainer1)
                               FSEEK(M.lnHandler, M.lnHeaderblocksize+ ;
                                    M.lnAllfieldblocksize+ ;
                                    SIGN(M.lnNullflaglen)* ;
                                    M.lnOnefieldblocksize, 0)
                               FWRITE(M.lnHandler,  ;
                                     M.lcHeaderrecterminator+ ;
                                     M.lcFixedcontainer1)
                               M.lnError = FERROR()
                               IF M.lnError<>0
                                    fiXmessage(105,M.tcWhatdbf, ,tnLang)
                                    RETURN fiXexit(-1*M.lnError, ;
                                     M.lcTmpdbf,M.lcTmpbinfile,M.lnSelect, ;
                                     M.lnHandler,M.tnLang)
                               ENDIF
                          ENDIF
                          M.llTablerepaired = .T.
                     CASE INLIST(M.tnRepairmode, 4, 6)
                          LOCAL lcTotalheader, lcRecorddata, lnReccounter,  ;
                                lnProceed
                          M.lcTotalheader = M.lcTablefixedhdr+ ;
                           M.lcAllfieldinfo+M.lcHeaderrecterminator
                          DO CASE
                               CASE  .NOT. EMPTY(M.lcFixedcontainer1)
                                    M.lcTotalheader = M.lcTotalheader+ ;
                                     M.lcFixedcontainer1
                               CASE  .NOT. EMPTY(M.lcTablecontainer1)
                                    M.lcTotalheader = M.lcTotalheader+ ;
                                     M.lcTablecontainer1
                          ENDCASE
                          IF M.luSetmpdbf
                               REPLACE atFix WITH M.lcTotalheader IN  ;
                                       (JUSTSTEM(M.lcTmpdbf))
                          ELSE
                               M.lnTmphandler = FCREATE(M.lcTmpbinfile, 0)
                               IF M.lnTmphandler<0
                                    M.lnError = FERROR()
                                    fiXmessage(104+VAL(SET("POINT")+ ;
                                     ALLTRIM(STR(M.lnError))), ;
                                     M.lcTmpbinfile, ,tnLang)
                                    RETURN fiXexit(-1*M.lnError, ;
                                     M.lcTmpdbf,M.lcTmpbinfile,M.lnSelect, ;
                                     M.lnTmphandler,M.tnLang)
                               ENDIF
                               FSEEK(M.lnTmphandler, 0, 0)
                               FWRITE(M.lnTmphandler, M.lcTotalheader)
                               M.lnError = FERROR()
                               IF M.lnError<>0
                                    fiXmessage(105,M.tcWhatdbf, ,tnLang)
                                    RETURN fiXexit(-1*M.lnError, ;
                                     M.lcTmpdbf,M.lcTmpbinfile,M.lnSelect, ;
                                     M.lnTmphandler,M.tnLang)
                               ENDIF
                               M.lnSeekprefixlen = LEN(M.lcTotalheader)
                          ENDIF
                          FSEEK(M.lnHandler, M.lnHeaderblocksize+ ;
                               M.lnAllfieldblocksize+ ;
                               SIGN(M.lnNullflaglen)* ;
                               M.lnOnefieldblocksize+ ;
                               LEN(M.lcHeaderrecterminator)+ ;
                               M.lnContainerblocksize, 0)
                          IF  .NOT. FEOF(M.lnHandler)
                               M.lnReccounter = 1
                               M.lnProceed = 600
                               IF M.lnReccount3>M.lnTooslowtohandle
                                    M.lnProceed = fiXmessage(108, ;
                                     M.lnReccount3,M.tnRepairmode,tnLang)*100
                               ENDIF
                               IF M.lnProceed=600 .OR. M.lnProceed=-100
                                    DO WHILE .T.
                                         M.lcRecorddata =  ;
                                          FREAD(M.lnHandler, M.lnRecsize3)
                                         M.lnError = FERROR()
                                         IF M.lnError<>0
                                              fiXmessage(105,M.tcWhatdbf, , ;
                                               tnLang)
                                              RETURN fiXexit(-1*M.lnError, ;
                                               M.lcTmpdbf,M.lcTmpbinfile, ;
                                               M.lnSelect,M.lnHandler,M.tnLang)
                                         ENDIF
                                         fiXmessage(109,M.lnReccounter, ;
                                          M.lnReccount3,tnLang)
                                         IF  .NOT. LEFT(M.lcRecorddata,  ;
                                          1)==CHR(032) .AND.  .NOT.  ;
                                          LEFT(M.lcRecorddata, 1)==CHR(042)
                                              M.lcRecorddata =  ;
                                               STUFF(M.lcRecorddata, 1, 1,  ;
                                               CHR(032))
                                         ENDIF
                                         IF M.luSetmpdbf
                                              REPLACE atFix WITH atFix+ ;
                                               M.lcRecorddata IN  ;
                                               (JUSTSTEM(M.lcTmpdbf))
                                              PACK IN (JUSTSTEM(M.lcTmpdbf))
                                         ELSE
                                              FSEEK(M.lnTmphandler,  ;
                                               M.lnSeekprefixlen, 0)
                                              FWRITE(M.lnTmphandler,  ;
                                               M.lcRecorddata)
                                              M.lnError = FERROR()
                                              IF M.lnError<>0
                                                   fiXmessage(105, ;
                                                    M.tcWhatdbf, ,tnLang)
                                                   RETURN fiXexit(-1* ;
                                                    M.lnError,M.lcTmpdbf, ;
                                                    M.lcTmpbinfile, ;
                                                    M.lnSelect, ;
                                                    M.lnTmphandler,M.tnLang)
                                              ENDIF
                                              M.lnSeekprefixlen =  ;
                                               M.lnSeekprefixlen+ ;
                                               LEN(M.lcRecorddata)
                                         ENDIF
                                         M.lnReccounter = M.lnReccounter+1
                                         IF FEOF(M.lnHandler)
                                              EXIT
                                         ENDIF
                                         IF M.lnReccounter>M.lnReccount3
                                              IF M.luSetmpdbf
                                                   REPLACE atFix WITH  ;
                                                    atFix+ ;
                                                    M.lcFileterminator IN  ;
                                                    (JUSTSTEM(M.lcTmpdbf))
                                                   PACK IN  ;
                                                    (JUSTSTEM(M.lcTmpdbf))
                                              ELSE
                                                   FSEEK(M.lnTmphandler,  ;
                                                    M.lnSeekprefixlen, 0)
                                                   FWRITE(M.lnTmphandler,  ;
                                                    M.lcFileterminator)
                                                   M.lnError = FERROR()
                                                   IF M.lnError<>0
                                                        fiXmessage(105, ;
                                                         M.tcWhatdbf, ,tnLang)
                                                        RETURN fiXexit(-1* ;
                                                         M.lnError, ;
                                                         M.lcTmpdbf, ;
                                                         M.lcTmpbinfile, ;
                                                         M.lnSelect, ;
                                                         M.lnTmphandler, ;
                                                         M.tnLang)
                                                   ENDIF
                                              ENDIF
                                              EXIT
                                         ENDIF
                                    ENDDO
                                    INKEY(0.5)
                                    WAIT CLEAR
                               ELSE
                                    RETURN fiXexit(M.lnProceed,M.lcTmpdbf, ;
                                     M.lcTmpbinfile,M.lnSelect, ;
                                     M.lnHandler,M.tnLang)
                               ENDIF
                          ENDIF
                          FCLOSE(M.lnHandler)
                          M.lcSafety = SET("SAFETY")
                          SET SAFETY OFF
                          IF M.luSetmpdbf
                               COPY MEMO atFix TO (M.tcWhatdbf)
                          ELSE
                               FCLOSE(M.lnTmphandler)
                               COPY FILE (M.lcTmpbinfile) TO (M.tcWhatdbf)
                          ENDIF
                          Set Safety &lcSafety
                          M.llTablerepaired = .T.
                ENDCASE
           OTHERWISE
                M.llTableisalreadyok = .T.
                M.lcTablefixedhdr = M.lcTableheader
      ENDCASE
 ELSE
 ENDIF
 FCLOSE(M.lnHandler)
 IF M.llIsmemo3
      LOCAL lnFptblocksize
      IF  .NOT. M.llIsmemo1
           IF INLIST(M.tnRepairmode, 2, 3, 5, 6)
                LOCAL lcTmptable, lnTmpsele, cmYtempdir
                M.lnTmpsele = SELECT()
                SELECT 0
                M.cmYtempdir = IIF(LEN(GETENV('TEMP'))=0, SYS(5)+CURDIR()+ ;
                               IIF( .NOT. RIGHT(CURDIR(), 1)=='\', '\',  ;
                               ''), GETENV('TEMP')+IIF( .NOT.  ;
                               RIGHT(GETENV('TEMP'), 1)=='\', '\', ''))
                M.lcTmptable = M.cmYtempdir+SYS(2015)
                DO WHILE FILE(M.lcTmptable+".DBF") .OR. FILE(M.lcTmptable+ ;
                   ".FPT")
                     M.lcTmptable = M.cmYtempdir+SYS(2015)
                ENDDO
                SELECT 0
                CREATE TABLE (M.lcTmptable) (teMp M)
                USE
                COPY FILE (M.lcTmptable+".FPT") TO (M.lcWhatfpt)
                ERASE (M.ctMptable+".FPT")
                ERASE (M.ctMptable+".DBF")
           ENDIF
           M.lcMemoerror = STUFF(M.lcFielderror, 1, 1, "1")
           M.lnFptblocksize = SET("blocksize")
      ELSE
           IF  .NOT. M.tlNobackups .AND. INLIST(M.tnRepairmode, 2, 3, 5,  ;
               6) .AND. FILE(M.lcWhatfpt)
                ADIR(laFilesize, M.lcWhatfpt)
                IF TYPE("m.laFileSize[1,2]")<>"N" .OR. M.laFilesize(1,2)* ;
                   M.lnDisksizer<DISKSPACE(SYS(5))
                     M.lcBackfile = M.lcWhatfpt+"00"
                     IF FILE(M.lcBackfile)
                          FOR M.lnI = 1 TO 99
                               M.lcBackfile = M.lcWhatfpt+ ;
                                PADL(ALLTRIM(STR(M.lnI)), 2, "0")
                               IF  .NOT. FILE(M.lcBackfile)
                                    EXIT
                               ELSE
                                    IF M.lnI=99 .AND. FILE(M.lcBackfile)
                                         ERASE (M.lcBackfile)
                                         EXIT
                                    ENDIF
                               ENDIF
                          ENDFOR
                     ENDIF
                     WAIT CLEAR
                     fiXmessage(102,M.lcWhatfpt,M.lcBackfile,tnLang)
                     COPY FILE (M.lcWhatfpt) TO (M.lcBackfile)
                     WAIT CLEAR
                     fiXmessage(103,M.lcBackfile, ,tnLang)
                ELSE
                     IF fiXmessage(113,M.lcWhatfpt, ,tnLang)<>6
                          RETURN fiXexit(-60,M.lcTmpdbf,M.lcTmpbinfile, ;
                                 M.lnSelect,M.lnHandler,M.tnLang)
                     ENDIF
                ENDIF
           ENDIF
           M.lnHandler = FOPEN(M.lcWhatfpt, 12)
           IF M.lnHandler<0
                M.lnError = FERROR()
                fiXmessage(104+VAL(SET("POINT")+ALLTRIM(STR(M.lnError))), ;
                          M.lcWhatfpt, ,tnLang)
                RETURN fiXexit(-1*M.lnError,M.lcTmpdbf,M.lcTmpbinfile, ;
                       M.lnSelect,M.lnHandler,M.tnLang)
           ENDIF
           LOCAL lcFptheader, lnFptsize, lnFptnfb, lcFptfixedhdr
           M.lcFptheader = FREAD(M.lnHandler, 8)
           M.lnError = FERROR()
           IF M.lnError<>0
                fiXmessage(105,M.lcWhatfpt, ,tnLang)
                RETURN fiXexit(-1*M.lnError,M.lcTmpdbf,M.lcTmpbinfile, ;
                       M.lnSelect,M.lnHandler,M.tnLang)
           ENDIF
           M.lnFptsize = FSEEK(M.lnHandler, 0, 2)
           M.lnFptnfb = unMsblsb(SUBSTR(M.lcFptheader, 1, 4))
           M.lnFptblocksize = unMsblsb(SUBSTR(M.lcFptheader, 7, 2))
           IF M.lnFptnfb<>INT(M.lnFptsize/M.lnFptblocksize)
                M.lnFptblocksize = M.tnMemoblocksice
                M.lcMemoerror = STUFF(M.lcFielderror, 2, 1, "1")
           ENDIF
           DO CASE
                CASE M.lnFptblocksize=0
                     M.lnFptblocksize = 1
                CASE M.lnFptblocksize=33
                     M.lnFptblocksize = 512*M.lnFptblocksize
                OTHERWISE
                     M.lnFptblocksize = M.lnFptblocksize
           ENDCASE
           M.lcFptfixedhdr = toMsblsb(INT(M.lnFptsize/M.lnFptblocksize), ;
                             4)+CHR(0)+CHR(0)+toMsblsb(M.lnFptblocksize,2)
           IF  .NOT. M.lcFptheader==M.lcFptfixedhdr
                M.lcMemoerror = STUFF(M.lcFielderror, 3, 1, "1")
                IF INLIST(M.tnRepairmode, 2, 3, 5, 6)
                     FSEEK(M.lnHandler, 0, 0)
                     FWRITE(M.lnHandler, M.lcFptfixedhdr)
                     M.lnError = FERROR()
                     IF M.lnError<>0
                          fiXmessage(105,M.lcWhatfpt, ,tnLang)
                          RETURN fiXexit(-1*M.lnError,M.lcTmpdbf, ;
                                 M.lcTmpbinfile,M.lnSelect,M.lnHandler, ;
                                 M.tnLang)
                     ENDIF
                     M.llMemorepaired = .T.
                ENDIF
           ENDIF
      ENDIF
      FCLOSE(M.lnHandler)
 ENDIF
 LOCAL lcTmpwin1, llChr7exist, lcInfo, lcInfofile, lcNot1, lcNot2,  ;
       lcLinefeed, lnInfolines
 M.lcInfo = ""
 M.lcNot1 = ""
 M.lcNot2 = ""
 M.lcLinefeed = CHR(13)+CHR(10)
 M.lnInfolines = 0
 M.lcInfo = M.lcInfo+"AtFixDbfFpt version 1.6"+M.lcLinefeed+M.lcLinefeed
 M.lnInfolines = M.lnInfolines+3
 IF  .NOT. EMPTY(M.lcTablecontainer2)
      M.lcInfo = M.lcInfo+M.lcFileorigin+" file: "+ ;
                 JUSTFNAME(M.lcTablecontainer2)+"!"+JUSTFNAME(M.tcWhatdbf)
 ELSE
      M.lcInfo = M.lcInfo+M.lcFileorigin+" file: "+JUSTFNAME(M.tcWhatdbf)
 ENDIF
 IF LEN(M.lcInfo)<45
      M.lcInfo = M.lcInfo+" | Size "+ALLTRIM(STR(M.lnFilesize, 10, 0))+ ;
                 " Bytes.   "+M.lcLinefeed+M.lcLinefeed
 ELSE
      M.lcInfo = M.lcInfo+M.lcLinefeed+"Size "+ALLTRIM(STR(M.lnFilesize,  ;
                 10, 0))+" Bytes.   "+M.lcLinefeed+M.lcLinefeed
 ENDIF
 M.lnInfolines = M.lnInfolines+2
 M.lcInfo = M.lcInfo+ ;
            "From          Data Start, Total RecSize,  Reccount, FieldCount"+ ;
            M.lcLinefeed
 M.lnInfolines = M.lnInfolines+1
 M.lcInfo = M.lcInfo+"Filesize"+SPACE(32)+STR(M.lnReccount1, 10, 0)+ ;
            M.lcLinefeed
 M.lnInfolines = M.lnInfolines+1
 M.lcInfo = M.lcInfo+"Header Block  "+STR(M.lnDatastart2, 10, 0)+SPACE(5)+ ;
            STR(M.lnRecsize2, 10, 0)+" "+STR(M.lnReccount2, 10, 0)+M.lcLinefeed
 M.lnInfolines = M.lnInfolines+1
 M.lcInfo = M.lcInfo+"Data Block    "+STR(M.lnDatastart3, 10, 0)+SPACE(5)+ ;
            STR(M.lnRecsize3, 10, 0)+" "+STR(M.lnReccount3, 10, 0)+"  "+ ;
            STR(M.lnFieldco3, 10, 0)+M.lcLinefeed
 M.lnInfolines = M.lnInfolines+1
 M.lcInfo = M.lcInfo+"Data offset"+SPACE(18)+STR(M.lnRecsize4, 10, 0)+ ;
            M.lcLinefeed
 M.lnInfolines = M.lnInfolines+1
 M.lcInfo = M.lcInfo+M.lcLinefeed
 M.lnInfolines = M.lnInfolines+1
 IF SUBSTR(M.lcFixerror, 1, 1)="1"
      M.lcInfo = M.lcInfo+"- There isn't any info for the fields."+M.lcLinefeed
 ELSE
      M.lcInfo = M.lcInfo+"- Field info Ok."+M.lcLinefeed
 ENDIF
 M.lnInfolines = M.lnInfolines+1
 IF SUBSTR(M.lcFixerror, 2, 1)="1"
      M.lcInfo = M.lcInfo+"- There is some info about first field"+M.lcLinefeed
      M.lcInfo = M.lcInfo+"  but the info is only partial."+M.lcLinefeed
      M.lnInfolines = M.lnInfolines+1
 ELSE
      M.lcInfo = M.lcInfo+"- First field info Ok."+M.lcLinefeed
 ENDIF
 M.lnInfolines = M.lnInfolines+1
 IF SUBSTR(M.lcFixerror, 3, 1)="1"
      M.lcInfo = M.lcInfo+"- There is info about more than one field but"+ ;
                 M.lcLinefeed
      M.lcInfo = M.lcInfo+ ;
                 "  the info about the last field is only partial."+ ;
                 M.lcLinefeed
      M.lnInfolines = M.lnInfolines+1
 ELSE
      M.lcInfo = M.lcInfo+ ;
                 "- There are more than one field and the last field info is Ok."+ ;
                 M.lcLinefeed
 ENDIF
 M.lnInfolines = M.lnInfolines+1
 IF SUBSTR(M.lcFixerror, 4, 1)="1"
      M.lcInfo = M.lcInfo+"- "+ALLTRIM(STR(M.lnContainerblocksize))+ ;
                 " bytes for container info are missing."+M.lcLinefeed
 ELSE
      IF LEFT(M.lcTableheader, 1)="0"
           IF AT("1", M.lcFixerror)=6
                M.lcInfo = M.lcInfo+"- DBC conatiner block is corrupted."+ ;
                           M.lcLinefeed
           ELSE
                M.lcInfo = M.lcInfo+"- Space for DBC info Ok."+M.lcLinefeed
           ENDIF
      ELSE
      ENDIF
 ENDIF
 M.lnInfolines = M.lnInfolines+1
 IF SUBSTR(M.lcFixerror, 7, 1)="1"
      M.lcInfo = M.lcInfo+ ;
                 "- Record size from the field info is more than "+ ;
                 ALLTRIM(STR(M.lnOnefieldblocksize))+"."+M.lcLinefeed
      M.lnInfolines = M.lnInfolines+1
 ELSE
 ENDIF
 IF SUBSTR(M.lcFixerror, 8, 1)="1"
      M.lcInfo = M.lcInfo+ ;
                 "- Record size from the field info and offset differs."+ ;
                 M.lcLinefeed
 ELSE
      M.lcInfo = M.lcInfo+ ;
                 "- Record size from the field info and offset are Ok."+ ;
                 M.lcLinefeed
 ENDIF
 M.lnInfolines = M.lnInfolines+1
 IF SUBSTR(M.lcFixerror, 9, 1)="1"
      M.lcInfo = M.lcInfo+"- Record count differs."+M.lcLinefeed
 ELSE
      M.lcInfo = M.lcInfo+ ;
                 "- Record count from file size, header and actual data are same (Ok)."+ ;
                 M.lcLinefeed
 ENDIF
 M.lnInfolines = M.lnInfolines+1
 IF SUBSTR(M.lcFixerror, 5, 1)="1"
      M.lcInfo = M.lcInfo+ ;
                 "- Wrong file size. There is some garbage after the last record."+ ;
                 M.lcLinefeed
      M.lcInfo = M.lcInfo+"  Original size "+ALLTRIM(STR(M.lnFilesize, 10,  ;
                 0))+" Bytes  Fixed size "+ALLTRIM(STR(M.lnDatastart3+ ;
                 M.lnReccount3*M.lnRecsize3+LEN(M.lcFileterminator), 10,  ;
                 0))+" Bytes"+M.lcLinefeed
      M.lnInfolines = M.lnInfolines+1
 ELSE
      M.lcInfo = M.lcInfo+ ;
                 "- File size is same than record count * record size (Ok)."+ ;
                 M.lcLinefeed
 ENDIF
 M.lnInfolines = M.lnInfolines+1
 IF SUBSTR(M.lcFixerror, 10, 1)="1"
      M.lcInfo = M.lcInfo+"- Header file type byte is corrupted."+M.lcLinefeed
      M.lnInfolines = M.lnInfolines+1
 ELSE
 ENDIF
 M.lcInfo = M.lcInfo+M.lcLinefeed
 M.lnInfolines = M.lnInfolines+1
 M.lcInfo = M.lcInfo+ ;
            "- First letter of the field's Name, Rest Of the Name, Type, Length"+ ;
            M.lcLinefeed
 M.lnInfolines = M.lnInfolines+1
 M.lcInfo = M.lcInfo+"  Ok?"+SPACE(26)+IIF(SUBSTR(M.lcFielderror, 1, 1)= ;
            "1" .OR. SUBSTR(M.lcFielderror, 2, 1)="1", " No", "Yes")+ ;
            SPACE(15)+IIF(SUBSTR(M.lcFielderror, 3, 1)="1", " No", "Yes")+ ;
            SPACE(3)+IIF(SUBSTR(M.lcFielderror, 4, 1)="1", " No", "Yes")+ ;
            SPACE(5)+IIF(SUBSTR(M.lcFielderror, 5, 1)="1", " No", "Yes")+ ;
            M.lcLinefeed
 M.lnInfolines = M.lnInfolines+1
 IF AT("1", M.lcFielderror)>0
      M.lcInfo = M.lcInfo+M.lcLinefeed
      M.lcInfo = M.lcInfo+ ;
                 "- Because of the error in field, no automatic fix can be done."+ ;
                 M.lcLinefeed
      M.lnInfolines = M.lnInfolines+2
 ENDIF
 M.lcInfo = M.lcInfo+M.lcLinefeed
 M.lnInfolines = M.lnInfolines+1
 M.lcInfo = M.lcInfo+"Table 0riginal Hdr.....:"
 M.lcInfo = M.lcInfo+STUFF(M.lcTableheader, 1, 1, M.lcTblheaderbyteone)
 M.lcInfo = M.lcInfo+M.lcLinefeed
 M.lnInfolines = M.lnInfolines+1
 M.lcInfo = M.lcInfo+"Table Fixed Hdr........:"
 M.lcInfo = M.lcInfo+M.lcTablefixedhdr
 M.lcInfo = M.lcInfo+M.lcLinefeed
 M.lnInfolines = M.lnInfolines+1
 IF  .NOT. EMPTY(M.lcFixedcontainer2)
      M.lcInfo = M.lcInfo+"- Original container    "
      FOR M.lnI = 1 TO LEN(M.lcTablecontainer2)
           IF SUBSTR(M.lcTablecontainer2, M.lnI, 1)=CHR(7)
                M.lcInfo = M.lcInfo+"7"
                M.llChr7exist = .T.
           ELSE
                M.lcInfo = M.lcInfo+SUBSTR(M.lcTablecontainer2, M.lnI, 1)
           ENDIF
      ENDFOR
      M.lcInfo = M.lcInfo+M.lcLinefeed
      M.lnInfolines = M.lnInfolines+1
      M.lcInfo = M.lcInfo+"- New container         "
      FOR M.lnI = 1 TO LEN(M.lcFixedcontainer2)
           IF SUBSTR(M.lcFixedcontainer2, M.lnI, 1)=CHR(7)
                M.lcInfo = M.lcInfo+"7"
                M.llChr7exist = .T.
           ELSE
                M.lcInfo = M.lcInfo+SUBSTR(M.lcFixedcontainer2, M.lnI, 1)
           ENDIF
      ENDFOR
      M.lcInfo = M.lcInfo+M.lcLinefeed
      M.lnInfolines = M.lnInfolines+1
 ENDIF
 M.lcInfo = M.lcInfo+M.lcLinefeed
 M.lnInfolines = M.lnInfolines+1
 M.lcInfo = M.lcInfo+"- FPT file, Memo flag, Memo field"
 IF M.llIsmemo1 .OR. M.llIsmemo3
      M.lcInfo = M.lcInfo+", Size (Now), Size (True), Block size"
 ENDIF
 M.lcInfo = M.lcInfo+M.lcLinefeed+SPACE(7)+IIF(M.llIsmemo1, "Yes", " No")+ ;
            SPACE(8)+IIF(M.llIsmemo2, "Yes", " No")+SPACE(9)+ ;
            IIF(M.llIsmemo3, "Yes", " No")
 M.lnInfolines = M.lnInfolines+1
 IF M.llIsmemo1 .OR. M.llIsmemo3
      LOCAL laMemofileinfo[1], lnMemofilesize1, lnMemofilesize2
      DO CASE
           CASE M.llIsmemo1 .AND. M.llIsmemo3
                ADIR(laMemofileinfo, M.lcWhatfpt)
                M.lnMemofilesize1 = IIF(TYPE("m.laMemoFileInfo[1,2]")="N",  ;
                                    M.laMemofileinfo(1,2), "Undefined")
                M.lnMemofilesize2 = M.lnFptsize
                M.lcInfo = M.lcInfo+"  "+ ;
                           PADL(ALLTRIM(STR(M.lnMemofilesize1)), 10, " ")+ ;
                           "   "+PADL(ALLTRIM(STR(M.lnMemofilesize2)), 10, " ")
           CASE M.llIsmemo1 .AND.  .NOT. M.llIsmemo3
                ADIR(laMemofileinfo, M.lcWhatfpt)
                M.lnMemofilesize1 = IIF(TYPE("m.laMemoFileInfo[1,2]")="N",  ;
                                    M.laMemofileinfo(1,2), "Undefined")
                M.lnMemofilesize2 = 0
                M.lcInfo = M.lcInfo+"  "+ ;
                           PADL(ALLTRIM(STR(M.lnMemofilesize1)), 10, " ")+ ;
                           "   "+PADL(ALLTRIM(STR(M.lnMemofilesize2)), 10, " ")
           CASE  .NOT. M.llIsmemo1 .AND. M.llIsmemo3
                M.lnMemofilesize1 = 0
                M.lnMemofilesize2 = "Undefined"
                M.lcInfo = M.lcInfo+"  "+ ;
                           PADL(ALLTRIM(STR(M.lnMemofilesize1)), 10, " ")+ ;
                           "   "+PADL(M.lnMemofilesize1, 10, " ")
      ENDCASE
      IF M.llIsmemo3
           M.lcInfo = M.lcInfo+PADL(ALLTRIM(STR(M.lnFptblocksize)), 12,  ;
                      " ")+M.lcLinefeed
           M.lnInfolines = M.lnInfolines+1
      ENDIF
      M.lcInfo = M.lcInfo+M.lcLinefeed
      M.lnInfolines = M.lnInfolines+1
      M.lcInfo = M.lcInfo+"Memo 0riginal Hdr......:"
      IF M.llIsmemo3
           M.lcInfo = M.lcInfo+M.lcFptheader
      ELSE
           M.lcInfo = M.lcInfo+"Not defined"
      ENDIF
      M.lcInfo = M.lcInfo+M.lcLinefeed
      M.lnInfolines = M.lnInfolines+1
      M.lcInfo = M.lcInfo+"Memo Fixed Hdr.........:"
      IF M.llIsmemo3
           M.lcInfo = M.lcInfo+M.lcFptfixedhdr
      ELSE
           M.lcInfo = M.lcInfo+"Not defined"
      ENDIF
 ENDIF
 M.lcInfo = M.lcInfo+M.lcLinefeed+M.lcLinefeed
 M.lnInfolines = M.lnInfolines+2
 M.lcInfo = M.lcInfo+"RESULTS (Repair mode "+ALLTRIM(STR(M.tnRepairmode))+ ;
            "):"+M.lcLinefeed
 M.lnInfolines = M.lnInfolines+1
 M.lcInfo = M.lcInfo+"- "+JUSTFNAME(M.tcWhatdbf)+" is"
 IF AT("1", M.lcFixerror)=0 .AND. AT("1", M.lcFielderror)=0
      M.lcInfo = M.lcInfo+" not"
 ENDIF
 M.lcInfo = M.lcInfo+" corrupted and"+IIF( .NOT. M.llTablerepaired,  ;
            " NOT", "")+" REPAIRED!"
 M.lcInfo = M.lcInfo+M.lcLinefeed
 M.lnInfolines = M.lnInfolines+1
 IF M.llIsmemo1 .OR. M.llIsmemo3
      M.lcInfo = M.lcInfo+"- "+JUSTFNAME(M.lcWhatfpt)+" is"
      IF AT("1", M.lcMemoerror)=0
           M.lcInfo = M.lcInfo+" not"
      ENDIF
      M.lcInfo = M.lcInfo+" corrupted and"+IIF( .NOT. M.llMemorepaired,  ;
                 " NOT", "")+" REPAIRED!"
 ENDIF
 M.lcInfo = M.lcInfo+M.lcLinefeed
 M.lnInfolines = M.lnInfolines+1
 M.lcInfo = M.lcInfo+"- "+IIF( .NOT. M.tlNobackups .AND. M.tnRepairmode=0,  ;
            "", "No ")+"Backups done."
 M.lcInfo = M.lcInfo+M.lcLinefeed+M.lcLinefeed
 M.lnInfolines = M.lnInfolines+2
 DO CASE
      CASE M.tnLang=1
           M.lcInfo = M.lcInfo+"Kopiosuojattu (C) 2003  Arto Toikka."+ ;
                      M.lcLinefeed+M.lcLinefeed+ ;
                      "Vaikka AtFixDbfFpt on ilmaisversio"+M.lcLinefeed+ ;
                      "(lukuunottamatta lähdekoodia), voit lähettää"+ ;
                      M.lcLinefeed+ ;
                      "kopiosuojan haltijalle EUR 35€ työkalun tulevaa"+ ;
                      M.lcLinefeed+ ;
                      "kehitystä varten ja saadaksesi (sähköpostitse)"+ ;
                      M.lcLinefeed+ ;
                      "päivitykset, manuaalin, lähdekoodin sekä yhden "+ ;
                      M.lcLinefeed+ ;
                      "vuoden ajaksi ilmaiset lähdekoodin päivitykset."
           M.lnInfolines = M.lnInfolines+9
      CASE M.tnLang>1
           M.lcInfo = M.lcInfo+"Copyright (C) 2003  Arto Toikka."+ ;
                      M.lcLinefeed+M.lcLinefeed+ ;
                      "Even AtFixDbfFpt a freeware (except the source),"+ ;
                      M.lcLinefeed+ ;
                      "you can send USD $35 payment to the copyright owner for a"+ ;
                      M.lcLinefeed+ ;
                      "future development of this tool and get (through Email)"+ ;
                      M.lcLinefeed+ ;
                      "updates, manual with examples and the source + "+ ;
                      M.lcLinefeed+"source upgrades for a year."
           M.lnInfolines = M.lnInfolines+8
 ENDCASE
 M.lcInfo = M.lcInfo+M.lcLinefeed
 M.lnInfolines = M.lnInfolines+1
 M.lcInfofile = ADDBS(JUSTPATH(M.tcWhatdbf))+"ATFix_"+ ;
                JUSTSTEM(M.tcWhatdbf)+".TXT"
 LOCAL llNoroomforinfo
 IF INLIST(M.tnInfo, 1, 2, 3)
      IF LEN(M.lcInfo)*8*M.lnDisksizer<DISKSPACE(SYS(5))
           M.lcSafety = SET("SAFETY")
           SET SAFETY OFF
           STRTOFILE(M.lcInfo, M.lcInfofile, 0)
           Set Safety &lcSafety
      ELSE
           M.llNoroomforinfo = .T.
           IF fiXmessage(115, , ,tnLang)=6
                LOCAL lcPrinter0, lcPrinter1, lcPrnoff, lcConsole
                M.lcPrinter0 = SET("PRINTER", 3)
                M.lcPrnoff = SET("PRINTER")
                M.lcConsole = SET("CONSOLE")
                M.lcPrinter1 = GETPRINTER()
                SET PRINTER TO NAME (M.lcPrinter1)
                SET CONSOLE OFF
                SET PRINTER ON
                ? M.lcInfo FUNCTION "V77"
                IF  .NOT. M.lcPrnoff==SET("PRINTER")
                     SET PRINTER &lcPrnOff
                ENDIF
                SET CONSOLE &lcConsole
                IF  .NOT. M.lcPrinter0==M.lcPrinter1
                     SET PRINTER TO NAME (M.lcPrinter0)
                ENDIF
           ENDIF
      ENDIF
 ENDIF
 IF INLIST(M.tnInfo, 1, 3) .AND.  .NOT. M.llNoroomforinfo
      M.lcTmpwin1 = "A"+SYS(3)
      DO CASE
           CASE M.tnLang=1
                DEFINE WINDOW (M.lcTmpwin1) AT 1, 3 SIZE M.lnInfolines+3,  ;
                       78 FONT "Courier New", 10 GROW FLOAT CLOSE ZOOM  ;
                       TITLE " Statistics for the "+ALLTRIM(M.tcWhatdbf)  ;
                       IN deSktop MINIMIZE SYSTEM
           CASE M.tnLang>1
                DEFINE WINDOW (M.lcTmpwin1) AT 1, 3 SIZE M.lnInfolines+3,  ;
                       78 FONT "Courier New", 10 GROW FLOAT CLOSE ZOOM  ;
                       TITLE " Statistics for the "+ALLTRIM(M.tcWhatdbf)  ;
                       IN deSktop MINIMIZE SYSTEM
      ENDCASE
      MODIFY COMMAND (M.lcInfofile) WINDOW (M.lcTmpwin1)
      RELEASE WINDOW (M.lcTmpwin1)
 ENDIF
 IF M.tnInfo=1
      ERASE (M.lcInfofile)
 ENDIF
 RETURN fiXexit(M.tnRepairmode,M.lcTmpdbf,M.lcTmpbinfile,M.lnSelect, ;
        M.lnHandler,M.tnLang)
ENDFUNC
*
FUNCTION UnLSBMSB
 LPARAMETER tcSomebytes
 LOCAL lnRetval, lnI
 M.lnRetval = 0
 FOR M.lnI = LEN(tcSomebytes) TO 1 STEP -1
      M.lnRetval = M.lnRetval*256+ASC(SUBSTR(tcSomebytes, M.lnI, 1))
 ENDFOR
 RETURN M.lnRetval
ENDFUNC
*
FUNCTION ToLSBMSB
 LPARAMETER tnSomenum, tnCount
 LOCAL lcRetval, lnI
 M.lcRetval = ""
 IF TYPE("m.tnCount")<>"N"
      M.tnCount = 1
 ELSE
      M.tnCount = INT(M.tnCount)
 ENDIF
 FOR M.lnI = 1 TO M.tnCount
      M.lcRetval = M.lcRetval+CHR(MOD(M.tnSomenum, 256))
      M.tnSomenum = INT(M.tnSomenum/256)
 ENDFOR
 RETURN M.lcRetval
ENDFUNC
*
FUNCTION UnMSBLSB
 LPARAMETER tcSomebytes
 LOCAL lnRetval, lnI
 M.lnRetval = 0
 FOR M.lnI = 1 TO LEN(M.tcSomebytes)
      M.lnRetval = M.lnRetval*256+ASC(SUBSTR(M.tcSomebytes, M.lnI, 1))
 ENDFOR
 RETURN M.lnRetval
ENDFUNC
*
FUNCTION ToMSBLSB
 LPARAMETER tnSomenum, tnCount
 LOCAL lcRetval, lnI
 M.lcRetval = ""
 IF TYPE("m.tnCount")<>"N"
      M.tnCount = 1
 ELSE
      M.tnCount = INT(M.tnCount)
 ENDIF
 FOR M.lnI = 1 TO M.tnCount
      M.lcRetval = CHR(MOD(M.tnSomenum, 256))+M.lcRetval
      M.tnSomenum = INT(M.tnSomenum/256)
 ENDFOR
 RETURN M.lcRetval
ENDFUNC
*
FUNCTION dectohex
 LPARAMETER tdN1
 PRIVATE lcPrefix, lnI, laDntohex, lcHexnum, ldN0
 M.lcPrefix = IIF(M.tdN1<0, "-", "")
 M.tdN1 = ABS(M.tdN1)
 M.lnI = 0
 IF M.tdN1>15
      DO WHILE M.tdN1>15
           M.lnI = M.lnI+1
           DIMENSION laDntohex(i)
           M.ldN0 = M.tdN1-INT(M.tdN1/16)*16
           M.laDntohex(i) = IIF(M.ldN0=10, "A", IIF(M.ldN0=11, "B",  ;
                      IIF(M.ldN0=12, "C", IIF(M.ldN0=13, "D", IIF(M.ldN0= ;
                      14, "E", IIF(M.ldN0=15, "F", STR(M.ldN0, 1)))))))
           M.tdN1 = INT(M.tdN1/16)
      ENDDO
      DIMENSION laDntohex(M.lnI+1)
      M.laDntohex(M.lnI+1) = IIF(M.tdN1=10, "A", IIF(M.tdN1=11, "B",  ;
                 IIF(M.tdN1=12, "C", IIF(M.tdN1=13, "D", IIF(M.tdN1=14,  ;
                 "E", IIF(M.tdN1=15, "F", STR(M.ldN1, 1)))))))
      M.lcHexnum = ""
      FOR M.lnI = ALEN(M.laDntohex) TO 1 STEP -1
           M.lcHexnum = M.lcHexnum+M.laDntohex(M.lnI)
      ENDFOR
      M.lcHexnum = IIF(MOD(LEN(M.lcHexnum), 2)<>0, "0"+M.lcHexnum, M.lcHexnum)
 ELSE
      M.lcHexnum = IIF(M.tdN1=10, "0A", IIF(M.tdN1=11, "0B", IIF(M.tdN1= ;
                   12, "0C", IIF(M.tdN1=13, "0D", IIF(M.tdN1=14, "0E",  ;
                   IIF(M.tdN1=15, "0F", "0"+STR(M.tdN1, 1)))))))
 ENDIF
 RETURN M.lcHexnum
ENDFUNC
*
FUNCTION hextodec
 LPARAMETER thN1
 LOCAL lcPrefix, lnI, lnDecnum, lcHn0
 M.lcPrefix = IIF(LEFT(M.thN1, 1)="-", "-", "")
 M.lnDecnum = 0
 M.thN1 = STRTRAN(M.thN1, "-", "")
 M.thN1 = UPPER(STRTRAN(M.thN1, " ", ""))
 FOR M.lnI = LEN(M.thN1) TO 1 STEP -1
      M.lcHn0 = SUBSTR(M.thN1, i, 1)
      M.lnDecnum = M.lnDecnum+(16^(LEN(M.thN1)-M.lnI))*IIF(ASC(M.lcHn0)> ;
                   64, ASC(M.lcHn0)-55, VAL(M.lcHn0))
 ENDFOR
 RETURN INT(M.lnDecnum)
ENDFUNC
*
FUNCTION DECTOBIN
 LPARAMETER tdN1
 LOCAL lnI, lnDectobin, lcBinnum
 DO CASE
      CASE TYPE("m.tDn1")<>"N"
           RETURN "00000000"
      CASE M.tdN1=0
           RETURN "00000000"
 ENDCASE
 M.lnDectobin = M.tdN1
 M.lcBinnum = ""
 DO WHILE .T.
      M.lcBinnum = STR(MOD(M.lnDectobin, 2), 1, 0)+M.lcBinnum
      M.lnDectobin = INT(M.lnDectobin/2)
      IF M.lnDectobin<=1
           M.lcBinnum = STR(M.lnDectobin, 1, 0)+M.lcBinnum
           EXIT
      ENDIF
 ENDDO
 IF MOD(LEN(M.lcBinnum), 8)<>0
      M.lcBinnum = REPLICATE("0", 8-MOD(LEN(M.lcBinnum), 8))+M.lcBinnum
 ENDIF
 RETURN M.lcBinnum
ENDFUNC
*
FUNCTION BINTODEC
 LPARAMETER tbN1
 LOCAL lnI, lnDecnum
 M.lnDecnum = 0
 IF TYPE("m.tBn1")="N"
      M.tbN1 = ALLTRIM(STR(INT(M.tbN1)))
 ENDIF
 FOR M.lnI = 1 TO LEN(M.tbN1)
      IF  .NOT. INLIST(SUBSTR(M.tbN1, M.lnI, 1), "0", "1")
           fiXmessage(107, , ,tnLang)
      ENDIF
 ENDFOR
 FOR M.lnI = LEN(M.tbN1) TO 1 STEP -1
      M.lnDecnum = M.lnDecnum+VAL(SUBSTR(M.tbN1, M.lnI, 1))* ;
                   2^(LEN(M.tbN1)-M.lnI)
 ENDFOR
 RETURN M.lnDecnum
ENDFUNC
*
FUNCTION FixMessage
 LPARAMETER tnMessage, tcVariable1, tcVariable2, tnLang, tnHandler
 LOCAL lnRetval
 M.lnRetval = 0
 DO CASE
      CASE INT(M.tnMessage)=98
           DO CASE
                CASE M.tnLang=1
                     M.lnRetval = MESSAGEBOX("Tiedostotunnus puuttuu", 16,  ;
                                  "ATFixDbfFpt virhe 98", 3000)
                CASE M.tnLang>1
                     M.lnRetval = MESSAGEBOX("There is no file extension",  ;
                                  16, "ATFixDbfFpt error 98", 3000)
           ENDCASE
      CASE INT(M.tnMessage)=99
           DO CASE
                CASE M.tnLang=1
                     M.lnRetval = MESSAGEBOX("Tiedostotunnus puuttuu", 16,  ;
                                  "ATFixDbfFpt virhe 99", 3000)
                CASE M.tnLang>1
                     M.lnRetval = MESSAGEBOX( ;
                                  "There is no container extension ", 16,  ;
                                  "ATFixDbfFpt error 99", 3000)
           ENDCASE
      CASE INT(M.tnMessage)=100
           DO CASE
                CASE M.tnLang=1
                     M.lnRetval = MESSAGEBOX("Tiedostoa "+CHR(13)+ ;
                                  M.tcVariable1+" ei löydy!", 16,  ;
                                  "ATFixDbfFpt virhe 100", 3000)
                CASE M.tnLang=3
                     M.lnRetval = MESSAGEBOX( ;
                                  "Não posso achar o Arquivo de dados: "+ ;
                                  CHR(13)+M.tcVariable1, 16,  ;
                                  "ATFixDbfFpt erro", 3000)
                OTHERWISE
                     M.lnRetval = MESSAGEBOX("Can't find data file: "+ ;
                                  CHR(13)+M.tcVariable1, 16,  ;
                                  "ATFixDbfFpt error 100", 3000)
           ENDCASE
      CASE INT(M.tnMessage)=101
           DO CASE
                CASE M.tnLang=1
                     M.lnRetval = MESSAGEBOX("Tiedostoa "+CHR(13)+ ;
                                  M.tcVariable1+" ei löydy!", 16,  ;
                                  "ATFixDbfFpt virhe 101", 3000)
                CASE M.tnLang=3
                     M.lnRetval = MESSAGEBOX( ;
                                  "Não posso achar o Container "+CHR(13)+ ;
                                  M.tcVariable1, 16, "ATFixDbfFpt erro", 3000)
                OTHERWISE
                     M.lnRetval = MESSAGEBOX("Can't find container "+ ;
                                  CHR(13)+M.tcVariable1, 16,  ;
                                  "ATFixDbfFpt error 101", 3000)
           ENDCASE
      CASE INT(M.tnMessage)=102
           DO CASE
                CASE M.tnLang=1
                     WAIT WINDOW AT WROWS()/2, WCOLS()/2-20 NOWAIT  ;
                          "Odottele teen varmuuskopioa: "+M.tcVariable2
                CASE M.tnLang=3
                     WAIT WINDOW AT WROWS()/2, WCOLS()/2-30 NOWAIT  ;
                          "Aguarde copiando de "+JUSTFNAME(M.tcVariable1)+ ;
                          " para "+JUSTFNAME(M.tcVariable2)
                OTHERWISE
                     WAIT WINDOW AT WROWS()/2, WCOLS()/2-30 NOWAIT  ;
                          "Wait for backing up "+JUSTFNAME(M.tcVariable1)+ ;
                          " to "+JUSTFNAME(M.tcVariable2)
           ENDCASE
      CASE INT(M.tnMessage)=103
           DO CASE
                CASE M.tnLang=1
                     M.lnRetval = MESSAGEBOX("Varmuuskopio:"+CHR(13)+ ;
                                  M.tcVariable1+" valmis!", 64,  ;
                                  "ATFixDbfFpt", 1500)
                CASE M.tnLang=3
                     M.lnRetval = MESSAGEBOX("Cópia de arquivo :"+CHR(13)+ ;
                                  M.tcVariable1+" terminada!", 64,  ;
                                  "ATFixDbfFpt", 1500)
                OTHERWISE
                     M.lnRetval = MESSAGEBOX("Backup file :"+CHR(13)+ ;
                                  M.tcVariable1+" is done!", 64,  ;
                                  "ATFixDbfFpt", 1500)
           ENDCASE
      CASE INT(M.tnMessage)=104
           LOCAL lcReason
           DO CASE
                CASE M.tnLang=1
                     DO CASE
                          CASE M.tnMessage-INT(M.tnMessage)=(0.2)
                               M.lcReason = "Tiedostoa ei löydy (2)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.4)
                               M.lcReason =  ;
                                "Liian monta tiedostoa auki (tiedosto kahvat loppu) (4)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.5)
                               M.lcReason = "Tiedostoon pääsy kielletty (5)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.6)
                               M.lcReason = "Väärä tiedosto kahva (6)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.8)
                               M.lcReason = "Muisti loppu (8)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.25)
                               M.lcReason =  ;
                                "Haku ei saa kohdistua paikkaan ennen tiedoston alkua (25)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.29)
                               M.lcReason = "Levy täynnä (29)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.31)
                               M.lcReason = "Tiedoston avaus ei onnistu (31)"
                          OTHERWISE
                               M.lcReason = "Virhe ("+ ;
                                ALLTRIM(STR((M.tnMessage- ;
                                INT(M.tnMessage))*100))+")"
                     ENDCASE
                CASE M.tnLang=3
                     DO CASE
                          CASE M.tnMessage-INT(M.tnMessage)=(0.2)
                               M.lcReason = "Arquivo não encontrado (2)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.4)
                               M.lcReason =  ;
                                "Muitos arquivos abertos ( estouro do handle ) (4)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.5)
                               M.lcReason = "Acesso negado (5)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.6)
                               M.lcReason =  ;
                                "O handle do arquivo informado é inválido (6)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.8)
                               M.lcReason = "Falta de memória (8)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.25)
                               M.lcReason =  ;
                                "Erro de Busca (Não posso pesquisar antes do começo do arquivo ) (25)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.29)
                               M.lcReason = "Disco cheio (29)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.31)
                               M.lcReason = "Erro na abertura do arquivo (31)"
                          OTHERWISE
                               M.lcReason = "Erro ("+ ;
                                ALLTRIM(STR((M.tnMessage- ;
                                INT(M.tnMessage))*100))+")"
                     ENDCASE
                OTHERWISE
                     DO CASE
                          CASE M.tnMessage-INT(M.tnMessage)=(0.2)
                               M.lcReason = "File not found (2)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.4)
                               M.lcReason =  ;
                                "Too many files open (out of file handles) (4)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.5)
                               M.lcReason = "Access denied (5)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.6)
                               M.lcReason = "Invalid file handle given (6)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.8)
                               M.lcReason = "Out of memory (8)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.25)
                               M.lcReason =  ;
                                "Seek error (can't seek before the start of a file) (25)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.29)
                               M.lcReason = "Disk full (29)"
                          CASE M.tnMessage-INT(M.tnMessage)=(0.31)
                               M.lcReason = "Error opening file (31)"
                          OTHERWISE
                               M.lcReason = "Error ("+ ;
                                ALLTRIM(STR((M.tnMessage- ;
                                INT(M.tnMessage))*100))+")"
                     ENDCASE
           ENDCASE
           DO CASE
                CASE M.tnLang=1
                     M.lnRetval = MESSAGEBOX("Tiedostoa "+M.tcVariable1+ ;
                                  CHR(13)+"Ei voi avata, koska:"+CHR(13)+ ;
                                  M.lcReason+CHR(13)+ ;
                                  "Ota virhe muistiin.", 16,  ;
                                  "ATFixDbfFpt virhe 104", 0)
                CASE M.tnLang=3
                     M.lnRetval = MESSAGEBOX("Não posso abrir o arquivo "+ ;
                                  M.tcVariable1+CHR(13)+ ;
                                  "por causa do erro:"+CHR(13)+M.lcReason+ ;
                                  CHR(13)+"Anote este erro.", 16,  ;
                                  "ATFixDbfFpt erro", 0)
                OTHERWISE
                     M.lnRetval = MESSAGEBOX("Can't open file "+ ;
                                  M.tcVariable1+CHR(13)+ ;
                                  "because of error:"+CHR(13)+M.lcReason+ ;
                                  CHR(13)+"Write this error down.", 16,  ;
                                  "ATFixDbfFpt error 104", 0)
           ENDCASE
      CASE INT(M.tnMessage)=105
           DO CASE
                CASE M.tnLang=1
                     M.lnRetval = MESSAGEBOX("Tiedostoa "+M.tcVariable1+ ;
                                  CHR(13)+ ;
                                  "ei voi avata. Sulje mahdolliset muut"+ ;
                                  CHR(13)+ ;
                                  "ohjelmat, jotka käyttävät tätä tiedostoa"+ ;
                                  CHR(13)+"ja yritä uudelleen.", 16,  ;
                                  "ATFixDbfFpt virhe 105", 5000)
                CASE M.tnLang=3
                     M.lnRetval = MESSAGEBOX("Não posso abrir o arquivo "+ ;
                                  M.tcVariable1+CHR(13)+ ;
                                  "Feche outras aplicações que estão usando este arquivo"+ ;
                                  CHR(13)+"e tente novamente...", 16,  ;
                                  "ATFixDbfFpt error", 5000)
                OTHERWISE
                     M.lnRetval = MESSAGEBOX("Can't open file "+ ;
                                  M.tcVariable1+CHR(13)+ ;
                                  "Close other applications using this file"+ ;
                                  CHR(13)+"and try again...", 16,  ;
                                  "ATFixDbfFpt error 105", 5000)
           ENDCASE
      CASE INT(M.tnMessage)=106
           DO CASE
                CASE M.tnLang=1
                     M.lnRetval = MESSAGEBOX("Virhe: "+M.tcVariable2+ ;
                                  CHR(13)+"Tiedosto "+M.tcVariable1+ ;
                                  CHR(13)+ ;
                                  "on korjauskelvoton, palauta nauhavarmistuskopio...",  ;
                                  16, "ATFixDbfFpt virhe 106", 5000)
                CASE M.tnLang=3
                     M.lnRetval = MESSAGEBOX("Erro Fatal: "+M.tcVariable2+ ;
                                  CHR(13)+"Arquivo "+M.tcVariable1+ ;
                                  CHR(13)+ ;
                                  "é irreparável, restaure o backup...",  ;
                                  16, "ATFixDbfFpt error", 5000)
                OTHERWISE
                     M.lnRetval = MESSAGEBOX("Fatal error: "+ ;
                                  M.tcVariable2+CHR(13)+"File "+ ;
                                  M.tcVariable1+CHR(13)+ ;
                                  "is unrepairable, restore tape backup...",  ;
                                  16, "ATFixDbfFpt error 106", 5000)
           ENDCASE
      CASE INT(M.tnMessage)=107
           DO CASE
                CASE M.tnLang=1
                     M.lnRetval = MESSAGEBOX("Ei binääri arvo", 48,  ;
                                  "ATFixDbfFpt virhe 107", 3000)
                CASE M.tnLang=3
                     M.lnRetval = MESSAGEBOX("Não é um valor binário", 48,  ;
                                  "ATFixDbfFpt", 3000)
                OTHERWISE
                     M.lnRetval = MESSAGEBOX("Not a binary value", 48,  ;
                                  "ATFixDbfFpt error 107", 3000)
           ENDCASE
      CASE INT(M.tnMessage)=108
           DO CASE
                CASE M.tnLang=1
                     M.lnRetval = MESSAGEBOX(ALLTRIM(STR(M.tcVariable1))+ ;
                                  " tiedostoa löytynyt. Niiden palauttaminen voi kestää kauan."+ ;
                                  CHR(13)+"Haluatko jatkaa?"+CHR(13)+ ;
                                  CHR(13)+"NOTE: tnRepairMode arvo "+ ;
                                  ALLTRIM(STR(M.tcVariable2-3))+ ;
                                  " on paljon nopeampi!", 292,  ;
                                  "Hidas prosessi?", 10000)
                CASE M.tnLang=3
                     M.lnRetval = MESSAGEBOX(ALLTRIM(STR(M.tcVariable1))+ ;
                                  " registros achados. Poderá demorar um pouco para repará-lo."+ ;
                                  CHR(13)+"Deseja continuar?"+CHR(13)+ ;
                                  CHR(13)+"OBS: Se tnRepairMode for "+ ;
                                  ALLTRIM(STR(M.tcVariable2-3))+ ;
                                  " poderá ser mais rápido!", 292,  ;
                                  "Processo Lento?", 10000)
                OTHERWISE
                     M.lnRetval = MESSAGEBOX(ALLTRIM(STR(M.tcVariable1))+ ;
                                  " records found. It could take a while to repair."+ ;
                                  CHR(13)+"Do you want to continue?"+ ;
                                  CHR(13)+CHR(13)+ ;
                                  "NOTE: tnRepairMode value "+ ;
                                  ALLTRIM(STR(M.tcVariable2-3))+ ;
                                  " would be much faster!", 292,  ;
                                  "Slow process?", 10000)
           ENDCASE
      CASE INT(M.tnMessage)=109
           DO CASE
                CASE M.tnLang=1
                     WAIT WINDOW AT WROWS()/2, WCOLS()/2-15 NOWAIT  ;
                          "Tietue  "+PADR(ALLTRIM(STR(M.tcVariable1))+"/"+ ;
                          ALLTRIM(STR(M.tcVariable2)), 21, " ")
                CASE M.tnLang=3
                     WAIT WINDOW AT WROWS()/2, WCOLS()/2-15 NOWAIT  ;
                          "Lendo registro  "+ ;
                          PADR(ALLTRIM(STR(M.tcVariable1))+"/"+ ;
                          ALLTRIM(STR(M.tcVariable2)), 21, " ")
                OTHERWISE
                     WAIT WINDOW AT WROWS()/2, WCOLS()/2-15 NOWAIT  ;
                          "Reading record  "+ ;
                          PADR(ALLTRIM(STR(M.tcVariable1))+"/"+ ;
                          ALLTRIM(STR(M.tcVariable2)), 21, " ")
           ENDCASE
      CASE INT(M.tnMessage)=110
           DO CASE
                CASE M.tnLang=1
                     DEFINE POPUP _aTwhattype FROM WROWS()/2-5, WCOLS()/2- ;
                            26 FONT "ARIAL", 10 TITLE  ;
                            "Tuntematon tiedostotyyppi. Valitse oikea:"  ;
                            IN scReen COLOR SCHEME 4
                     DEFINE BAR 1 OF _aTwhattype PROMPT 'FoxBase'
                     DEFINE BAR 2 OF _aTwhattype PROMPT  ;
                            'FoxBASE+ / dBASE III PLUS, FoxPro, dBaseIV, ei memoa'
                     DEFINE BAR 3 OF _aTwhattype PROMPT 'Visual FoxPro'
                     DEFINE BAR 4 OF _aTwhattype PROMPT  ;
                            'Visual FoxPro, Autoincrement päällä'
                     DEFINE BAR 5 OF _aTwhattype PROMPT  ;
                            'dBASE IV SQL taulu tiedosto, ei memoa'
                     DEFINE BAR 6 OF _aTwhattype PROMPT  ;
                            'dBASE IV SQL systeemi tiedosto, ei memoa'
                     DEFINE BAR 7 OF _aTwhattype PROMPT  ;
                            'FoxBASE+ / dBASE III PLUS, sekä memo'
                     DEFINE BAR 8 OF _aTwhattype PROMPT 'dBASE IV sekä memo'
                     DEFINE BAR 9 OF _aTwhattype PROMPT  ;
                            'dBASE IV SQL taulu tiedosto, sekä memo'
                     DEFINE BAR 10 OF _aTwhattype PROMPT  ;
                            'FoxPro 2.x (tai aikasempi) sekä memo'
                     DEFINE BAR 11 OF _aTwhattype PROMPT 'FoxBASE sekä memo'
                OTHERWISE
                     DEFINE POPUP _aTwhattype FROM WROWS()/2-5, WCOLS()/2- ;
                            26 FONT "ARIAL", 10 TITLE  ;
                            "Unknown file type. Select correct one:" IN  ;
                            scReen COLOR SCHEME 4
                     DEFINE BAR 1 OF _aTwhattype PROMPT 'FoxBase'
                     DEFINE BAR 2 OF _aTwhattype PROMPT  ;
                            'FoxBASE+ / dBASE III PLUS, FoxPro, dBaseIV, no memo'
                     DEFINE BAR 3 OF _aTwhattype PROMPT 'Visual FoxPro'
                     DEFINE BAR 4 OF _aTwhattype PROMPT  ;
                            'Visual FoxPro, Autoincrement enabled'
                     DEFINE BAR 5 OF _aTwhattype PROMPT  ;
                            'dBASE IV SQL table files, no memo'
                     DEFINE BAR 6 OF _aTwhattype PROMPT  ;
                            'dBASE IV SQL system files, no memo'
                     DEFINE BAR 7 OF _aTwhattype PROMPT  ;
                            'FoxBASE+ / dBASE III PLUS, with memo'
                     DEFINE BAR 8 OF _aTwhattype PROMPT 'dBASE IV with memo'
                     DEFINE BAR 9 OF _aTwhattype PROMPT  ;
                            'dBASE IV SQL table files, with memo'
                     DEFINE BAR 10 OF _aTwhattype PROMPT  ;
                            'FoxPro 2.x (or earlier) with memo'
                     DEFINE BAR 11 OF _aTwhattype PROMPT 'FoxBASE with memo'
           ENDCASE
           ON SELECTION POPUP _aTwhattype DEACTIVATE POPUP _ATWHATTYPE
           DO WHILE .T.
                ACTIVATE POPUP _aTwhattype
                IF LASTKEY()=27
                     LOOP
                ENDIF
                EXIT
           ENDDO
           RELEASE POPUPS _aTwhattype
           RETURN BAR()
      CASE INT(M.tnMessage)=111
           DO CASE
                CASE M.tnLang=1
                     M.lnRetval = MESSAGEBOX( ;
                                  "Tietokanta (container) blokki on korruptoitunut."+ ;
                                  CHR(13)+ ;
                                  "Anna ATFixDbfFpt:n kolmannelle parametrille "+ ;
                                  CHR(13)+ ;
                                  "tietokannan nimi relatiivisella polulla ja "+ ;
                                  CHR(13)+ ;
                                  "käynnistä ATFixDbfFpt uudelleen", 16,  ;
                                  "ATFixDbfFpt virhe 111", 10000)
                OTHERWISE
                     M.lnRetval = MESSAGEBOX( ;
                                  "Container block is corrupted."+CHR(13)+ ;
                                  "Write container name (with relative path)"+ ;
                                  CHR(13)+ ;
                                  "to the third parameter of ATFixDBfFpt"+ ;
                                  CHR(13)+"and start ATFixDbfFpt again",  ;
                                  16, "ATFixDbfFpt error 111", 10000)
           ENDCASE
      CASE INT(M.tnMessage)=112
           DO CASE
                CASE M.tnLang=1
                     M.lnRetval = MESSAGEBOX( ;
                                  "Tiedoston loppumerkki on samassa blokissa "+ ;
                                  CHR(13)+ ;
                                  "tietueen terminointimerkin kanssa JA tietueen"+ ;
                                  CHR(13)+ ;
                                  "koko on suurempi kuin kentän blokin koko."+ ;
                                  CHR(13)+ ;
                                  "Yritä uudelleen m.tnRepairMode arvolla 4 tai 6",  ;
                                  16, "ATFixDbfFpt virhe 112", 10000)
                OTHERWISE
                     M.lnRetval = MESSAGEBOX( ;
                                  "EOF file mark is in the same block with the "+ ;
                                  CHR(13)+ ;
                                  "header record terminator AND record size "+ ;
                                  CHR(13)+ ;
                                  "is more than field block size."+ ;
                                  CHR(13)+ ;
                                  "Try to run with m.tnRepairMode = 4 or 6",  ;
                                  16, "ATFixDbfFpt error 112", 10000)
           ENDCASE
      CASE INT(M.tnMessage)=113
           DO CASE
                CASE M.tnLang=1
                     M.lnRetval = MESSAGEBOX("Levyllä "+SYS(5)+ ;
                                  " ei ole tarpeeksi tilaa tiedoston:"+ ;
                                  CHR(13)+M.tcVariable1+ ;
                                  " varmuuskopiointiin."+CHR(13)+ ;
                                  "Haluatko jatkaa?", 36,  ;
                                  "ATFixDbfFpt virhe 113", 10000)
                OTHERWISE
                     M.lnRetval = MESSAGEBOX("Not enough room in "+SYS(5)+ ;
                                  " to backup file: "+CHR(13)+ ;
                                  M.tcVariable1+CHR(13)+ ;
                                  "Do you want to continue?", 36,  ;
                                  "ATFixDbfFpt error 113", 10000)
           ENDCASE
      CASE INT(M.tnMessage)=114
           DO CASE
                CASE M.tnLang=1
                     M.lnRetval = MESSAGEBOX("Levyllä "+SYS(5)+ ;
                                  " ei ole tarpeeksi tilaa parametrille:"+ ;
                                  CHR(13)+"tnRepairMode = "+ ;
                                  ALLTRIM(STR(M.tcVariable1))+CHR(13)+ ;
                                  "Haluatko jatkaa arvolla "+ ;
                                  ALLTRIM(STR(M.tcVariable1-3)), 36,  ;
                                  "ATFixDbfFpt virhe 114", 15000)
                OTHERWISE
                     M.lnRetval = MESSAGEBOX("Not enough room in "+SYS(5)+ ;
                                  " for a parameter value:"+CHR(13)+ ;
                                  "tnRepairMode = "+ ;
                                  ALLTRIM(STR(M.tcVariable1))+CHR(13)+ ;
                                  "Do you want to continue with value "+ ;
                                  ALLTRIM(STR(M.tcVariable1-3)), 36,  ;
                                  "ATFixDbfFpt error 114", 15000)
           ENDCASE
      CASE INT(M.tnMessage)=115
           DO CASE
                CASE M.tnLang=1
                     M.lnRetval = MESSAGEBOX("Levyllä "+SYS(5)+ ;
                                  " ei ole tarpeeksi tilaa infon näyttämiseen"+ ;
                                  CHR(13)+ ;
                                  "tarvittavaan väliaikaistiedostoon. Haluatko sen sijaan tulostaa infon?",  ;
                                  36, "ATFixDbfFpt virhe 115", 10000)
                OTHERWISE
                     M.lnRetval = MESSAGEBOX("Not enough room in "+SYS(5)+ ;
                                  " to make a temp file to show info."+ ;
                                  CHR(13)+ ;
                                  "Do you want to print it instead?", 36,  ;
                                  "ATFixDbfFpt error 115", 10000)
           ENDCASE
      CASE INT(M.tnMessage)=200
           DO CASE
                CASE M.tnLang=1
                     WAIT WINDOW AT WROWS()/2, WCOLS()/2-25 NOWAIT  ;
                          "ATFixDbfFpt käyttäjän keskeytys. Korjauksia ei suoritettu."
                CASE M.tnLang=3
                     WAIT WINDOW AT WROWS()/2, WCOLS()/2-25 NOWAIT  ;
                          "ATFixDbfFpt cancelado pelo usuário. Nenhuma correção feita."
                OTHERWISE
                     WAIT WINDOW AT WROWS()/2, WCOLS()/2-25 NOWAIT  ;
                          "ATFixDbfFpt cancelled by the user. No fixing done."
           ENDCASE
      CASE INT(M.tnMessage)=201
           DO CASE
                CASE M.tnLang=1
                     WAIT WINDOW AT WROWS()/2, WCOLS()/2-20 NOWAIT  ;
                          "ATFixDbfFpt keskeytetty virheen takia."
                CASE M.tnLang=3
                     WAIT WINDOW AT WROWS()/2, WCOLS()/2-20 NOWAIT  ;
                          "ATFixDbfFpt cancelado por causa do erro."
                OTHERWISE
                     WAIT WINDOW AT WROWS()/2, WCOLS()/2-20 NOWAIT  ;
                          "ATFixDbfFpt cancelled because of an error."
           ENDCASE
      CASE INT(M.tnMessage)=300
           return 1
           DO CASE
                CASE M.tnLang=1
                     M.lnRetval = MESSAGEBOX( ;
                                  "Copyright, Kopiosuojattu (C) 2003  Arto Toikka."+ ;
                                  CHR(13)+CHR(13)+ ;
                                  "Vaikka tämä ohjelma on ilmaisversio"+ ;
                                  CHR(13)+ ;
                                  "(lukuunottamatta lähdekoodia), voit lähettää"+ ;
                                  CHR(13)+ ;
                                  "kopiosuojan haltijalle EUR 35€ työkalun tulevaa"+ ;
                                  CHR(13)+ ;
                                  "kehitystä varten ja saadaksesi (sähköpostitse)"+ ;
                                  CHR(13)+ ;
                                  "uusimmat päivitykset, manuaalin, lähdekoodin sekä "+ ;
                                  CHR(13)+ ;
                                  "yhden vuoden ajaksi ilmaiset lähdekoodin päivitykset.",  ;
                                  64, "ATFixDbfFpt Kopiosuojailmoitus", 120000)
                OTHERWISE
                     M.lnRetval = MESSAGEBOX( ;
                                  "Copyright (C) 2003  Arto Toikka."+ ;
                                  CHR(13)+CHR(13)+ ;
                                  "Even this program is a freeware (except the source),"+ ;
                                  CHR(13)+ ;
                                  "you can send USD $35 payment to the copyright owner for a"+ ;
                                  CHR(13)+ ;
                                  "future development of this tool and get (through Email)"+ ;
                                  CHR(13)+ ;
                                  "upcoming versions manual with examples, the source + source "+ ;
                                  CHR(13)+"upgrades for a year.", 64,  ;
                                  "ATFixDbfFpt Copyright", 120000)
           ENDCASE
      CASE INT(M.tnMessage)=301
           DO CASE
                CASE M.tnLang=1
                     M.lnRetval = MESSAGEBOX("Tiedoston "+ ;
                                  STRTRAN(M.tcVariable1, "????",  ;
                                  " koko on ")+" tavua."+CHR(13)+ ;
                                  "Tämä versio ei tue yli "+ ;
                                  ALLTRIM(STR(M.tcVariable2))+ ;
                                  " tavun tiedostoja.", 16,  ;
                                  "ATFixDbfFpt virhe 301", 10000)
                OTHERWISE
                     M.lnRetval = MESSAGEBOX(STRTRAN(M.tcVariable1,  ;
                                  "????", " size is ")+" bytes."+CHR(13)+ ;
                                  "This version doesn't support file sizes over "+ ;
                                  ALLTRIM(STR(M.tcVariable2))+" bytes.",  ;
                                  16, "ATFixDbfFpt error 301", 10000)
           ENDCASE
 ENDCASE
 IF TYPE("m.tnHandler")="N"
      FCLOSE(M.tnHandler)
 ENDIF
 RETURN M.lnRetval
ENDFUNC
*
FUNCTION FixExit
 LPARAMETER lnRetval, lcTmpdbf, lcTmpbinfile, lnSelect, tnHandler, tnLang
 IF TYPE("m.tnHandler")="N"
      FCLOSE(M.tnHandler)
 ENDIF
 IF TYPE("m.lcTmpBinFile")="C" .AND.  .NOT. EMPTY(JUSTSTEM(M.lcTmpbinfile))
      ERASE (M.lcTmpbinfile)
 ENDIF
 IF TYPE("m.lcTmpDbf")="C" .AND.  .NOT. EMPTY(JUSTSTEM(M.lcTmpdbf))
      IF USED(JUSTSTEM(M.lcTmpdbf))
           USE IN (JUSTSTEM(M.lcTmpdbf))
      ENDIF
      ERASE (M.lcTmpdbf+".DBF")
      ERASE (M.lcTmpdbf+".FPT")
 ENDIF
 IF TYPE("m.lnSelect")="N" .AND. M.lnSelect>0
      SELECT (M.lnSelect)
 ENDIF
 DO CASE
      CASE INLIST(M.lnRetval, 200, 300, 700)
           fiXmessage(200, , ,tnLang)
      CASE M.lnRetval<0
           fiXmessage(201, , ,tnLang)
 ENDCASE
 RETURN M.lnRetval
ENDFUNC
*
