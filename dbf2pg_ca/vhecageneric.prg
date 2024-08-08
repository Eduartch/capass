*
* It is a little coupled with my application object oApp. oApp has a datamode property, a connectionstring property.
* Just changing the connectionstring property I can switch to querying (insert/update/delete as well) different data sources.
* It is almost like an SPT connection where you change the ODBC handle. However, you should note the difference (could do with an SPT wrapper class).
* This class have some custom methods like MakeUpdatable, GetErrorExplanation, QueryFill. I can do this for example:
*
Local loMyCustomer As "vhecageneric"
Local lcCadenaConexion, lcRegBkPath, luConexion

lcCadenaConexion = "DRIVER={Firebird/Interbase(r) driver};" ;
	+ "USER=     " + "sysdba" + ";"				 ;
	+ "PASSWORD= " + "vhe153" + ";"				 ;
	+ "DATABASE= " + "C:\Archivos de programa\Firebird\Firebird_2_5\examples\empbuild\Employee.fdb" + ";" ;
	+ "OPTIONS= 131329;"
*
lcCadenaConexion  = "Provider=SQLOLEDB.1;Integrated Security=SSPI;" + ;
	"Persist Security Info=False;Initial Catalog=VheDat;" + ;
	"Data Source=NB-GATEWAY\SQLEXPRESS"

lcRegBkPath = ".\Datos\Customers.xls"
*loconn.Provider="Microsoft.Jet.OLEDB.4.0"
lcCadenaConexion  =  [Provider=Microsoft.Jet.OLEDB.4.0;Data Source="] + m.lcRegBkPath + ;
	[";Extended Properties="Excel 8.0;HDR=Yes;";]

*lcCadenaConexion  = "Provider=Microsoft.Jet.OLEDB.4.0;DataSource=.\Datos\Customers.xls;" + ;
*					"Extended Properties=Excel 8.0;Persist Security Info=False"
*lcCadenaConexion = [Driver=] +					 ;
[{Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};] + ;
[DBQ=.\Datos\Customers.xls]

*oApp = Createobject("Empty")
*AddProperty(m.oApp, "DataConnectionString")
*lcConnectionString = Filetostr( "..\Datos\Conexion.cnx" )
lcCadenaConexion = "Driver={SQL Server};Server=LocalHost\sqlexpress;Database=Northwind;Trusted_Connection=yes;"
*tcConnectionString = 'Provider=SQLNCLI;Server=.\sqlexpress;Trusted_connection=yes'
*tcConnectionString = lcCadenaConexion

*loMyCustomer = Newobject('cageneric','cageneric.prg')
*loMyCustomer = Newobject('cageneric', 'vheCaGeneric.prg', lcConnectionString)
*--lnHandle = Sqlstringconnect(m.lcConnectionString)

*!*	lcCadenaConexion = "Driver={SQL Server};Server=LocalHost\sqlexpress;Database=Northwind;Trusted_Connection=yes;"
*!*	luConexion = Sqlstringconnect(m.lcCadenaConexion)
*!*	If m.luConexion < 0
*!*		Messagebox("NO conectado :-(")
*!*	Endif

*luConexion = "MiBaseDatos"

*loMyCustomer = Createobject("vhecageneric", m.luConexion) && Dbf: nombre de la base de datos | nHandle de Sql
loMyCA = Createobject("vhecageneric", "Northwind") && Dbf: nombre de la base de datos | nHandle de Sql
With m.loMyCA
*  .SelectCmd = 'select * from Northwind..Customers'
	.Alias	   = "crsCustomers"
*	.Alias	   = "crsProductos"
	.SelectCmd = "select * from employees"
*	.SelectCmd = "select * from customers"
*	.SelectCmd = "select * from Productos"
	.Nodata	   = .F.
	.QueryFill()
	.MakeUpdatable("employees", "employeeID", .T.) && enable updating
*	.MakeUpdatable("Customers", "customerID", .T.) && enable updating
*	.MakeUpdatable("Clientes", "IdCliente", .F.) && enable updating
*	.MakeUpdatable("Productos", "IdProducto", .F.) && enable updating
*  .MakeUpdatable('Northwind..Customers','customerID',.F.) && enable updating
*  .MakeUpdatable('Customer','cust_no',.F.) && enable updating
	Messagebox(.UpdatableFieldList + Chr(13) + .UpdateNameList)
	Browse
MESSAGEBOX(ALIAS())
DISPLAY STRUCTURE 
COPY TO tmpemplo WITH cdx
*--	Tableupdate(1, .T., .Alias)
Endwith
*COPY TO .\Datos\Customers TYPE xl5
*loMyCustomer.SelectCmd = m.loMyCustomer.SelectCmd + [ where city='London']
*m.loMyCustomer.QueryFill()
*Browse

*
* PS: Note that unlike SPT cursors, CA cursors 'go out of scope' as soon as their variable goes out of scope
* (and that is a feature from my POV that I utilize to my benefit).
*
* Cetin Basoz
*
*----------------------------------------------------------------------------------
*
Define Class vheCaGeneric As CursorAdapter
	CompareMemo			   = .F.
	FetchAsNeeded		   = .T.
	FetchSize			   = 100
	FetchMemo			   = .T.
	BatchUpdateCount	   = 100
	WhereType			   = 1
	AllowSimultaneousFetch = .T.
	MapVarchar			   = .T.
	MapBinary			   = .T.
	BufferModeOverride	   = 5
	Nodata				   = .T.
	Handle				   = 0
	Dimension aInList[1]

	Procedure AutoOpen
		If Not Pemstatus(This, "__VFPSetup", 5)
			This.AddProperty("__VFPSetup", 1)
			This.Init()
		Endif
	Endproc

	Procedure Init(tuConexion)
*This.Tag = tuConexion
		Local loCommand As "ADODB.Command"
		Local llReturn, loConnDataSource
		Do Case
		Case Not Pemstatus(This, "__VFPSetup", 5)
			This.AddProperty("__VFPSetup", 0)
		Case This.__VFPSetup = 1
			This.__VFPSetup = 2
		Case This.__VFPSetup = 2
			This.__VFPSetup = 0
			Return
		Endcase
		Set Multilocks On
		llReturn = DoDefault()
*WAIT WINDOW tuConexion

*	This.DataSourceType =  ;
IIF(Lower(Trim(Getwordnum(tuConexion,1,'= ')))=='driver','ODBC','ADO')
*--vhe
		If Vartype(m.tuConexion) == "N" And m.tuConexion > 0
			This.DataSourceType = "ODBC"
		Else
			This.DataSourceType = "NATIVE"
		Endif
*--vhe
		Store This.DataSourceType To	   ;
			This.InsertCmdDataSourceType,  ;
			This.UpdateCmdDataSourceType,  ;
			This.DeleteCmdDataSourceType
***<DataSource>
		Do Case
		Case Upper(This.DataSourceType) == "ODBC"
*--		This.Handle = Sqlstringconnect(tuConexion)
			This.Handle = m.tuConexion
			Store This.Handle To		   ;
				This.Datasource,		   ;
				This.InsertCmdDataSource,  ;
				This.UpdateCmdDataSource,  ;
				This.DeleteCmdDataSource

		Case Upper(This.DataSourceType) == "ADO"
			loConnDataSource = Createobject("ADODB.Connection")
***<DataSource>
			loConnDataSource.ConnectionString = m.tuConexion
***</DataSource>
			m.loConnDataSource.Open()
			This.Datasource					 = Createobject("ADODB.RecordSet")
			This.Datasource.CursorLocation	 = 3  && adUseClient
			This.Datasource.LockType		 = 3  && adLockOptimistic
			This.Datasource.ActiveConnection = m.loConnDataSource
*** End of Select connection code: DO NOT REMOVE

			loCommand				   = Createobject("ADODB.Command")
			loCommand.ActiveConnection = m.loConnDataSource
			This.AddProperty("oCommand", m.loCommand)
			This.UpdateCmdDataSource = m.loCommand
			This.InsertCmdDataSource = m.loCommand
			This.DeleteCmdDataSource = m.loCommand
		Case Upper(This.DataSourceType) = "NATIVE" && Not implemented
			If Dbused(m.tuConexion)
			Else
				Open Database (m.tuConexion)
			Endif

			Store m.tuConexion	 To		   ;
				This.Datasource,		   ;
				This.InsertCmdDataSource,  ;
				This.UpdateCmdDataSource,  ;
				This.DeleteCmdDataSource

		Case Upper(This.DataSourceType) = "XML"  && Not implemented
		Endcase
***</DataSource>

		If This.__VFPSetup = 1
			This.__VFPSetup = 2
		Endif
		Return m.llReturn
	Endproc

	Procedure MakeUpdatable(tcTableName, tckeyField, tlDoNotIncludeKey)
		Local ix
		This.Tables		  = m.tcTableName
		This.KeyFieldList = m.tckeyField
*-----------------		For ix = 1 To Fcount(This.Alias) - 1 && last one is ADOBOOKMARK (vhe:???)
		For ix = 1 To Fcount(This.Alias)
			If Not m.tlDoNotIncludeKey Or Not (Upper(Field(m.ix, This.Alias, 0)) == Upper(m.tckeyField))
				This.UpdatableFieldList = This.UpdatableFieldList + ;
					Iif(Empty(This.UpdatableFieldList), "", ",") + ;
					Field(m.ix, This.Alias, 0)
			Endif
			This.UpdateNameList = This.UpdateNameList + ;
				Iif(Empty(This.UpdateNameList), "", ",") + ;
				Textmerge("<<FIELD(m.ix,this.Alias,0)>> <<m.tcTableName>>.<<FIELD(m.ix,this.Alias,0)>>")
		Endfor
	Endproc

	Procedure QueryFill(tuClavePrimaria As Variant)
*!*		Procedure QueryFill()
*!*		Lparameters tuClavePrimaria As Variant
	
	Local lcRetorno, llSuccess, luClavePrimaria
	
	If Vartype(m.tuClavePrimaria) <> "L"
		luClavePrimaria = m.tuClavePrimaria
	Endif
	
	If This.DataSourceType = "ADO"
		llSuccess = This.CursorFill(.F., .F., 0, This.oCommand)
	Else
		llSuccess = This.CursorFill()
	Endif
	lcRetorno = "OK"
	If Not m.llSuccess
	*--			Messagebox(This.GetErrorExplanation())
		lcRetorno = This.GetErrorExplanation()
	Endif
	*--		Return m.llSuccess
	
	Return m.lcRetorno
	
	Endproc
	
	Procedure GetErrorExplanation
		Local lcError
		Local aWhy[1], ix
		Aerror(aWhy)
		lcError = "ERROR:"
		For ix = 1 To 7
			lcError = m.lcError + Transform(m.aWhy[m.ix]) + Chr(13)
		Endfor
		Return m.lcError
	Endproc

Enddefine
