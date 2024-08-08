Lparameters toExc As Exception
#Define MSGTITULO      "SISVEN"
#Define MENSAJE1 "NO Se envío el comprobante Por las siguientes razones"+Chr(13)+Chr(10)+" NO Hay Conexión a Internet "+Chr(13)+Chr(10)
#Define MENSAJE2 "NO Hay Respuesta desde la WEB SERVICE DE SUNAT"+Chr(13)+Chr(10)
#Define MENSAJE3 " Ya se envio correctamente pero la respuesta no se recibio Correctamente-(Consultar con Clave Sol en www.sunat.gob.pe)"
*Procedure controlerrores(toExc As Exception)
#Define CR Chr(13)
Do Case
Case m.toExc.ErrorNo=12
	Messagebox("No se Encuentra una Referencia de un Dato",16,MSGTITULO)
Case m.toExc.ErrorNo=1426
	Messagebox("La Web Service de SUNAT no responde Cierre el sistema y Vuelva a Ingresar",16,MSGTITULO)
Case m.toExc.ErrorNo=1429
	Messagebox(MENSAJE1+MENSAJE2+MENSAJE3,16,MSGTITULO)
Case m.toExc.ErrorNo=1924
	Messagebox(MENSAJE1+MENSAJE2+MENSAJE3,16,MSGTITULO)
Case m.toExc.ErrorNo=13
	Messagebox("Esta Ejecutando una Consulta Sin Haber Obtenido Datos Correctamente",16,MSGTITULO)
Otherwise
	Local lcErrorInfo
	m.lcErrorInfo = "Error N°..........: " + Transform(m.toExc.ErrorNo)  + CR + ;
		"Linea No..........: " + Transform(m.toExc.Lineno) + CR + ;
		"Mensaje ..........: " + m.toExc.Message + CR + ;
		"Programa..........: " + m.toExc.Procedure + CR + ;
		"Detalle...........: " + m.toExc.Details + CR + ;
		"StackLevel........: " + Transform(m.toExc.StackLevel) + CR + ;
		"Contenido Linea...: " + m.toExc.LineContents + CR + ;
		"Comentario........: " + m.toExc.Comment
	Do Form ka_error With m.lcErrorInfo
Endcase
On Shutdown
On Shutdown Clear Events

Read Events

