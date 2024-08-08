
Local lcRetorno	 As String	;
	, luConexion As Variant ;
	, lcAlias	 As String

Private pnConexion, pnRegsOK

pnConexion = 0
pnRegsOK   = 0

Set Procedure To vheCaGeneric.prg Additive

luConexion = ConectarBD()
If m.luConexion <> "OK"
	Cancel
Endif

Select 0
Use monedas	&& .dbf con ID autoinc
lcAlias = Alias()

lcRetorno = MigrarTabla(m.lcAlias, .T.)
If m.lcRetorno == "OK"
	Messagebox(Transform(m.pnRegsOK) + " registros migrados OK!", 64)
	Use in Select(m.lcAlias)
Else
	Messagebox(m.lcRetorno, 16 + 48, "ATENCIÓN!")
Endif
*
*---------------------------------------------------------------------------------------------------------
*
Procedure ConectarBD

Local lCDatabase As String		;
	, laError[1]				;
	, lcConexion As String		;
	, lcDriver	 As String		;
	, lcError	 As String		;
	, lcOptions  As String		;
	, lcPort	 As String		;
	, lcPwd		 As String		;
	, lcRetorno  As String		;
	, lcServer	 As String		;
	, lcUid		 As String		;
	, lnError	 As Number

*:Global pnConexion

lcDriver   = "{PostgreSQL ANSI};"
lcServer   = "192.168.1.4;"
lcPort	   = "5433;"
lCDatabase = "la_empresa;"
lcUid	   = "vhe;"
lcPwd	   = "vhe153;"
lcOptions  = "C7=1;C9=1;"

Text To m.lcConexion Textmerge Noshow Flags 1 Pretext 15
			
	Driver=<<m.lcDriver>>
	Server=<<m.lcServer>>
	Port=<<m.lcPort>>
	Database=<<m.lcDatabase>>
	Uid=<<m.lcUid>>
	Pwd=<<m.lcPwd>>
	<<m.lcOptions>>"
		
Endtext

pnConexion = Sqlstringconnect(m.lcConexion)

If pnConexion > 0
	Sys(987, .T.)
	Set VarcharMapping Off
	CursorSetProp("MapVarChar", .T., 0)
	CursorSetProp("MapBinary",  .T., 0)
	lcRetorno = "OK"
Else
	= Aerror(laError)
	lnError	= m.laError[1]
	lcError	= m.laError[2]

	lcRetorno = "ERROR: " + Transform(lnError) + Chr(13) + lcError

	Messagebox("ERROR: " + lcError)
Endif

Return lcRetorno
*
*---------------------------------------------------------------------------------------------------------
*
Procedure MigrarTabla(tcTabla As String, tlAutoInc As Boolean)

Local laError[1]						 ;
	, lcClavePrimaria As String			 ;
	, lcError		  As String			 ;
	, lcInsert		  As String			 ;
	, lcRetorno		  As String			 ;
	, llOK			  As Boolean		 ;
	, lnError		  As Number			 ;
	, loCurAdapter	  As "vheCaGeneric"

Wait Window Nowait "Copiando registros a " + m.tcTabla

lcClavePrimaria	= Lower(Alltrim(ClavePrimaria(m.tcTabla)))

loCurAdapter = Createobject("vheCaGeneric", pnConexion)
With m.loCurAdapter
	.Alias	   = "cur" + m.tcTabla
	.SelectCmd = "select * from " + m.tcTabla
	.Nodata	   = .T.
	.QueryFill()
	.MakeUpdatable(m.tcTabla, m.lcClavePrimaria, m.tlAutoInc)
	lcInsert = "INSERT INTO " + .Alias + Iif(m.tlAutoInc, " Select 0, ", " Select ") ;
		+ .UpdatableFieldList + " From " + m.tcTabla

	ExecScript(m.lcInsert)
pnRegsOK  = _Tally
	llOK = Tableupdate(1, .T., .Alias)
EndWith

If m.llOK
	lcRetorno = "OK"
Else
	Aerror(laError)
	lnError	  = m.laError[1]
	lcError	  = m.laError[2]
	lcRetorno = "ERROR: " + Transform(m.lnError) + Chr(13) + m.lcError
Endif

loCurAdapter = Null
Release m.loCurAdapter

Wait Clear

Return m.lcRetorno
*
*---------------------------------------------------------------------------------------------------------
*
Function ClavePrimaria(tcAlias As String)

Local laInfoClaves[1]			 ;
	, lcClavePrimaria As String	 ;
	, lnFilPK As Number			 ;
	, lnKntClaves As Number

lcClavePrimaria	= ""
lnKntClaves		= Ataginfo(laInfoClaves, "", m.tcAlias)
If m.lnKntClaves > 0
	lnFilPK = Ascan(m.laInfoClaves, "PRIMARY", 1, m.lnKntClaves, 2, 8)
	If m.lnFilPK > 0
		lcClavePrimaria = m.laInfoClaves[m.lnFilPK, 3]
	Endif
Endif

Return (m.lcClavePrimaria)

Endfunc
*
*---------------------------------------------------------------------------------------------------------
*
