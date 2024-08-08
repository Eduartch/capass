#DEFINE FLAG_ICC_FORCE_CONNECTION   1
#DEFINE CRLF		  CHR(13) + CHR(10)
#DEFINE URL_TEST "http://www.ceslyweb.com/servicio/cpe/test_php.php"

*********************************
*////CLASE:  'CPE_RBV' 	////////*
* Genera el XML                 *
*********************************
DEFINE CLASS CPE_RBV AS CUSTOM	
	mensaje     	= ''
	mensaje_CDR 	= ''
	&&oRp         	= null	
	&& EMISOR
	es_emisor 				= 'N'
	emi_ruc 				= ''
	emi_ubigeo  			= ''
	emi_nombre_comercial 	= '' 
	emi_ruc 			    = ''
	emi_razon_social		= ''
	emi_direccion			= ''
	emi_urbanizacion		= ''
	emi_ubigeo				= ''
	&& RUTAS y SESION SUNAT
	ruta_firma_xml			= ''
	ruta_sunat_xml			= ''
	ruta_main				= ''
	ruta_contingencia       = ''
	sol_usuario				= ''
	sol_pwd					= ''
	estado 					= ''
	
	is_beta 	  = .f.
		
	nitems 		  = 0
	fecha_emision = CTOD("")
	fecha_envio   = CTOD("")
	correlativo   = 0
	
	ticket		  = ""
	is_qy_ticket  = .f. && Es consulta de ticket o incluye envio (envio y consulta de ticket)
	
	omiscela = .f.
	
	PROCEDURE Init  	
		TEXT TO ls_sql NOSHOW TEXTMERGE
			SELECT 
				(select nomb from dpto where coddpto=substring(emi_ubigeo from 1 for 2))::varchar(98) as midpto,
				(select nomb from provincia where codprovi=substring(emi_ubigeo from 1 for 4))::varchar(98) as provi,
				(select nomb from distrito where coddistri=substring(emi_ubigeo from 1 for 6))::varchar(98) as distri,
				es_emisor, emi_ruc, emi_razon_social, emi_nombre_comercial, emi_direccion, emi_ubigeo, 
				ruta_firma_xml, sol_usuario, sol_pwd, ruta_sunat_xml,				
				emi_urbanizacion, is_beta,
				url_web, ruta_main, ruta_contingencia, sfs_timer_ms 
			FROM confi_ce;
		ENDTEXT
		
		*generar nombre de cursor aleatorio
		cur_confi = "c" + right(SYS(2015),5)
		*IF ! EjectSql(CONFIRMAR_TRANS, ls_sql, cur_confi, _screen.nconn) THEN 
		IF ! EjectSql(ls_sql, cur_confi) THEN 
			RETURN 
		ENDIF 

		SELECT &cur_confi  &&Abre cursor
			GO TOP
			this.es_emisor  			= ALLTRIM(es_emisor)					
			this.is_beta				= ALLTRIM(is_beta) && Servidor Beta				 			 		
			this.emi_nombre_comercial 	= ALLTRIM(emi_nombre_comercial)			
			this.emi_ruc 			    = ALLTRIM(emi_ruc)			
			this.emi_razon_social		= ALLTRIM(emi_razon_social)
			this.emi_direccion			= ALLTRIM(emi_direccion)
			this.emi_urbanizacion		= ALLTRIM(emi_urbanizacion)		
			this.emi_ubigeo				= ALLTRIM(emi_ubigeo)									
			
			this.sol_usuario			= ALLTRIM(sol_usuario)
			this.sol_pwd				= ALLTRIM(sol_pwd)						
			this.ruta_sunat_xml			= ALLTRIM(ruta_sunat_xml)			
			this.ruta_firma_xml			= ALLTRIM(ruta_firma_xml)												
			this.ruta_main				= ADDBS(ALLTRIM(ruta_main))			
			this.ruta_contingencia      = ALLTRIM(ruta_contingencia) 
			
			&&this.sfs_timer_ms           = sfs_timer_ms
			*MESSAGEBOX(this.emi_provincia)						
			close_cursor(cur_confi)
		
		this.omiscela = CREATEOBJECT('MISCELA_CPE')	
	ENDPROC && Fin-Init()	
	
	PROCEDURE Destroy
		this.omiscela = null
	ENDPROC &&Fin-Destroy()	
	
	PROCEDURE validar()
		LOCAL exito, msg, n, lo_re
		exito = .f.
		msg = ''		
		
		DO CASE 
		CASE EMPTY(this.fecha_emision) .OR. VARTYPE(this.fecha_emision) <> 'D'  
			msg = 'fecha_emision'			
		CASE EMPTY(this.fecha_envio) .OR. VARTYPE(this.fecha_envio) <> 'D'  
			msg = 'fecha_envio'	
		*CASE ((this.fecha_emision + 7) <	this.fecha_envio)
		*	msg = 'La fecha de envio es superior a 7 dias a la fecha en que se emitieron los documentos!'	
		CASE (this.fecha_envio < this.fecha_emision)
			msg = 'La fecha de envio es menor a la fecha en que se emitieron los documentos!'		
		CASE (this.nitems <= 0) && Si no tiene Detalle
			msg = 'ingrese al menos un detalle del resumen!'		
		OTHERWISE			
			exito = .T.	
		ENDCASE	
		
		IF !exito then
			IF msg<>''		 
				msg = "No se ha ingresado correctamente el dato '" + msg + "'"  
				IF !empty(msg) THEN
					this.mensaje= msg		
				ENDIF
			ENDIF
		ENDIF	
		
		RETURN exito
	ENDPROC 
	
	******************************************
	*//////////////Genera JSON (R.B.V.)      *
	******************************************
	FUNCTION genJson(cAccion) 
		LOCAL cRuc, cCurCfg, cSol_usuario, cSol_pwd, cTicket	
		
		cCurCfg = 'C' + SYS(2015)
		TEXT TO  cSql NOSHOW TEXTMERGE
			SELECT 
				emi_ruc 
				,sol_usuario
				,sol_pwd
			FROM confi_ce
		ENDTEXT 
		
		IF !EjectSql(cSql, cCurCfg) THEN 
			this.mensaje="Ocurrió un error al obtener datos de Emisor!"
			RETURN .f.
		ENDIF 
		
		SELECT (cCurCfg)
		GO TOP
		IF RECNO()=0 THEN
			this.mensaje="No existe registro de Emisor de Facturación electrónica!"
			close_cursor(cCurEmi)
			RETURN .f.
		ENDIF 
		cRuc = emi_ruc
		cSol_usuario = ALLTRIM(sol_usuario)
		cSol_pwd = ALLTRIM(sol_pwd)
		close_cursor(cCurCfg)
		
		cCab = this.getcabecera() && OJO: ver Exporta en cabecera
		
		**---------------------------------------------------------------
		** 27-11-2018 12:25 pm - WVA - validar que se ha generado bien el json de la cabecera
		**---------------------------------------------------------------
		IF (ATC("ERROR parsing JSON",cCab) > 0) .OR.  (LEN(cCab)=0) THEN 
			this.mensaje="Error al generar JSON de la cabecera del documento!"
			RETURN .f.
		ENDIF 
		**---------------------------------------------------------------		

		*cDet = this.getdetalle(this.fecha_emision , this.fecha_envio , this.correlativo)
		**---------------------------------------------------------------
		** 27-11-2018 12:25 pm - WVA - validar que se ha generado bien el json de la cabecera
		**---------------------------------------------------------------
		*IF ATC("ERROR parsing JSON", cDet) > 0 THEN 
		*	this.mensaje = "Error al generar JSON del detalle del documento!"
		*	RETURN .f.
		*ENDIF 

		cWS = IIF(this.is_beta = "1", "beta", "produccion")
						
		cAccion = LOWER(cAccion)
		*IF !INLIST(cAccion, "xml", "envio") THEN 
		*	mb("Accion a realizar '&cAccion' no es valida!")
		*	RETURN ''
		*ENDIF 
		cTicket = ALLTRIM(this.ticket)
		TEXT TO cJson NOSHOW TEXTMERGE
			{
				"ws"	:"<<cWS>>",
				"accion":"<<cAccion>>",
				"ruc"	:"<<cRuc>>",
				"sol_usuario": "<<cSol_usuario>>",	
				"sol_pwd": "<<cSol_pwd>>",
				"summary": <<cCab>>,
				"ticket": "<<cTicket>>"				
			}
		ENDTEXT
		
		RETURN cJson
	ENDFUNC && genJson()		
	
	FUNCTION getUrl(ls_script)
		IF VARTYPE(ls_script)="L" THEN
			MESSAGEBOX("Falta Script de la URL!", 16, gs_app_name)
		ENDIF 
		
		LOCAL cUrl, curl_local
		cUrl = f_get_data_select("select urlcpe as dato from confi_ce") + ls_script + ".php"
		
		IF VARTYPE(gURL_CPE_HOST)="C" THEN 
			RETURN gURL_CPE_HOST
		ENDIF
		
		DECLARE INTEGER InternetCheckConnection IN wininet.dll; 
    		STRING lpszUrl, LONG dwFlags, LONG dwReserved
		
		curl_local = f_get_data_select("select urlcpelocal as dato from confi_ce")+ ls_script + ".php"
    	
    	IF (InternetCheckConnection(cUrl, FLAG_ICC_FORCE_CONNECTION, 0)!=1) THEN
			cUrl = curl_local
	    ELSE && Si Hay Conexión de Internet
	    	*IF !this.isWebActivo() THEN 
			*	MESSAGEBOX("CESLYWEB no funciona!", 16, gs_app_name)
			*	cUrl = curl_local
			*ENDIF
		ENDIF
		
		gURL_CPE_HOST = cUrl
		
		RETURN cUrl
	ENDFUNC 				
	
	*******************************************
	*//////////////Genera Send_SUNAT (R.B.V.) *
	*******************************************
	FUNCTION Send_SUNAT(pd_fecha_emision, pd_fecha_envio, pi_correlativo, ps_ticket)
		LOCAL ls_sql, ls_fecha_emision, ls_fechaEnvio, i 	
		LOCAL ls_cur_fill as String, lbOk as Boolean 	
		
		IF VARTYPE(ps_ticket)!= "C"  THEN 			
			ps_ticket=""			
		ENDIF 		
		this.is_qy_ticket = (!EMPTY(ps_ticket)) && Es consulta de ticket o no
		
		IF !BETWEEN(pi_correlativo, 1, 9999) THEN  	
			this.mensaje = "Correlativo debe estar entre 1 y 9999!"
			WAIT window this.mensaje
			RETURN .F.
		ENDIF  
						
		this.fecha_emision = pd_fecha_emision
		this.fecha_envio   = pd_fecha_envio
		this.correlativo   = pi_correlativo
		this.ticket        = ps_ticket
		ls_fecha_emision = this.fmt_fecha(this.fecha_emision)	
		ls_fechaEnvio    = this.fmt_fecha(this.fecha_envio)			
	   	
	   	TEXT TO cSql NOSHOW TEXTMERGE
			SELECT COUNT(r_d.nfila) as dato
			FROM resumen_bv_detalle r_d
			WHERE 
				(fecha_envio = '<<ls_fechaEnvio>>')
				AND (correlativo = <<ALLTRIM(STR(this.correlativo,4))>>)			
		ENDTEXT 
		this.nitems = VAL(f_get_data_select(cSql))		
		*IF ! EjectSql(CONFIRMAR_TRANS, ls_sql, ls_cur_fill, _screen.nconn )	THEN 				
		
		lbOk = this.validar()
		IF !lbOk THEN  	
			WAIT window this.mensaje
			RETURN .F.
		ENDIF              
		
		IF !this.Envio_CPE()	
			WAIT WINDOW this.mensaje &&MESSAGEBOX(this.mensaje)   	
			RETURN .F.
		ENDIF  
		*MESSAGEBOX("Enviado ZIP RES_BV y esperando respuesta Asincronica de WS!!!!")      	  	
		
		RETURN .t.
	ENDFUNC  && fin - Send_SUNAT() de 'Resumen de Boletas'
	
	****************************************TEMPILLO**************************************
	FUNCTION Envio_CPE()	   
		LOCAL ls_estado_cpe, lbOk, ls_msg, ls_msgCDR			
		LOCAL lsruta_xml, lcSerieNum, lo_cdr, ls_zipCDR
		LOCAL lbOk
		&& lo_Resp,mensaje <> '' ==> entonces
		&& 			lo_Resp.Status_Server = 0    :  No se envio la peticion al web service
		&& 			lo_Resp.Status_Server <> 200 :  No se acepto la peticion por el servidor de web service o esta fuera de linea
		&& 			lo_Resp.Status_Server = 200  :  El servidor acepto la peticion, ver siguiente
		&& 			lo_Resp.IsCDR = .T.  :  El servidor acepto la peticion y genero el CDR pero no logro validar CDR				
		lo_json    = this.enviaXML()		&& ENVIAR ZIP NO XML		
		IF  VARTYPE(lo_json) = 'L' THEN 
			RETURN .f.
		ENDIF 
		
		*MESSAGEBOX("regreso de sendSummary ==> " + crlf + " Code: " + lo_Resp.Status_Code + ", Status: " + lo_Resp.Status_Msg + ", Document :" + ;
		*	lo_Resp.Document + ", Estado Svr :" + ALLTRIM(STR(lo_Resp.Status_Server)) +;		
		*	", IsCDR: " +  iif(lo_Resp.IsCDR, "SI", "NO" ) + ", Mensaje: " + lo_Resp.mensaje + "Nº Ticket: " + lo_Resp.ticket, 48, gs_app_name)		
		IF !EMPTY(this.mensaje) THEN 
			RETURN .f.
		ENDIF 

		lo_cdr      = lo_json.get("CDR")
		this.ticket	= lo_json.get("ticket") && v 1.1			
		
		MESSAGEBOX("TICKET: '" + this.ticket + "'", 64, gs_app_name)					
		IF (!this.is_qy_ticket) THEN	  && Si ENVIO COMPLETO (is_qy_ticket=FALSE) - Grabar Ticket						
			IF (!empty(this.ticket)) THEN && Si tiene ticket 				
				IF ! this.saveTicketCPE_rbv() THEN 				
					RETURN .F.
				ENDIF
			ELSE && Consultando Ticket, Sin ticket (Error)
				ls_msg = ALLTRIM(lo_json.get('codesunat')) + " " + ALLTRIM(lo_json.get('estado') + " " + lo_json.get('nota'))
				IF (!EMPTY(ls_msg )) THEN 
					this.mensaje = ls_msg
					RETURN .F.
				ENDIF 
			ENDIF 
		ENDIF && Fin-Si ENVIO COMPLETO 		
		
		mb("Consulta Ticket " + this.ticket)			
		ls_msgCDR = ALLTRIM(lo_cdr.get('Msg') + " " + lo_cdr.get('notes'))		
		ls_msg    = ALLTRIM(lo_json.get('estado') + " " + lo_cdr.get('nota'))		
		
		this.mensaje = ls_msg
		ls_estado_cpe     = this.getEstado_cpe_rbv(lo_json)		
		this.estado       = ls_estado_cpe		
		*mb(ls_estado_cpe)			
		lbOk = this.saveEstadoCPE_rbv(ls_estado_cpe, lo_json, .T.)	&& CGR 20180316 ---------------------------			 
		IF (!lbOk) THEN 
			RETURN .F.
		ENDIF 
		
		*this.mensaje = lo_Resp.mensaje		
		
		IF 	!INLIST(ls_estado_cpe,"A", "O") THEN 		
			RETURN .F.
		ENDIF 
		
		RETURN .T.       
	ENDPROC &&Fin - Envio_CPE (Resumen_Boletas_CPE)
	
	********************************************************************************************************
	* Funcion 'getEstado_cpe_rbv'                                                                          *
	*   devuelve estado del CPE de Resumen de Boletas y Comunicación de Baja: 'A', 'O', 'E', 'R', 'I'	   *
	*      'A' : codigo_cdr = 0 y mensaje ='' 		                                                       *
	*      'R' : codigo_cdr entre 2000 y 3999 y mensaje = '' 		                                       *
	*      'O' : codigo_cdr entre 4000 a mas y mensaje = ''		                                           *
	*      'E' : codigo_cdr entre 0100 a 1999 y mensaje <> '' 		                                       *
	*      'I' : Error al leer el CDR devuelto            		                                           *
	*  Solo ingres cuando se recupera CDR
	*    Parametros:                                                                                       *
	*	      lo_Resp    :	Objeto con la respuesta del Web Service                                        *
	********************************************************************************************************
	PROCEDURE getEstado_cpe_rbv(lo_json)
		IF VARTYPE(lo_json)<>'O' THEN
			MESSAGEBOX("Se esperaba parametro oJson!")
			RETURN ""
		ENDIF
		
		LOCAL res
		res = ALLTRIM(lo_json.get('rpta'))
		
		IF  res = "" THEN && NO Se obtuvo estado de Rpta
			res = 'E'						
		ENDIF	
		
		RETURN res
	ENDPROC &&Fin-getEstado_cpe_rbv()
	

	**************************************************************************************************
	* Funcion 'saveEstadoCPE_RBV'   (CLASE CPE_RBV)            (R.B.V.)                              *
	*   Graba en la BD el estado de respuesta del CDR o La excepción del Web Service                 *
	*   Solo Resumen de Boletas 	                                                                 *
	*    Parametros:                                                                                 *
	*		  ls_estado_cpe:  estado cpe                                                             *
	*	      lo_docCPE    :	Documento a Procesar                                                 *
	*	      lo_Resp      :	Objeto con la respuesta de Web Service                               *
	* NOTA: CADA ENVIO COMPLEMENTA AL ANTERIOR                                                       *
	**************************************************************************************************
	PROCEDURE saveEstadoCPE_rbv(ls_estado_cpe, lo_json, lbCheckTicket as Boolean)
		IF (VARTYPE(lo_json)<> 'O') THEN
			this.mensaje  = "Función necesita 1 parametro de Objeto JSON!"
			RETURN .f.
		ENDIF
		
		LOCAL lbOk as boolean, li_nreg as Integer 
		LOCAL ls_fechaEnvio as string, ls_fecha_emision as String, ls_correlativo, lsTbResumen
				 
		LOCAL ls_descri_cpe, ls_sql_st, lsTick && CGR 20180316 -------------------		
		
		LOCAL ls_cod_rpta_cpe, ls_sqlAnu, ls_sqlUp, ls_code64CDR && CGR-101		
		LOCAL ls_msg, ls_msgCDR, lo_cdr, ln_code, ln_codeCDR
		
		lo_cdr    = lo_json.get('CDR') 
		ls_msg    = ALLTRIM(lo_json.get('estado') + ' ' + lo_json.get('nota'))
		ls_msgCDR = ALLTRIM(lo_cdr.get('Msg') + ' ' + lo_cdr.get('notes'))
		
		ln_code   	= VAL(lo_json.get('codesunat'))
		ln_codeCDR  = lo_cdr.get('Code')
		
		ls_sql_st       = "" && CGR 20180316 -------------------		
		ls_descri_cpe	= IIF(ls_msg!="", ls_msg, ls_msgCDR)
		ls_descri_cpe	= STRTRAN(ls_descri_cpe,['],["])
		ls_cod_rpta_cpe	= ALLTRIM(STR(IIF(ln_code=0, ln_codeCDR, ln_code)))  && Resp.Status_Code
		
		ls_correlativo	= ALLTRIM(STR(this.correlativo,4))		
		ls_fechaEnvio	= this.omiscela.fmt_fecha(this.fecha_envio)
		ls_fecha_emision= this.omiscela.fmt_fecha(this.fecha_emision)	
		
		lo_cdr  		= lo_json.get('CDR')
		ls_code64CDR    = lo_cdr.get('zip') && CGR-101		
		
		*-------------------------------------------------------
		*14-10-2016 11:40 am - WVA
		*-------------------------------------------------------
		IF ISNULL(ls_cod_rpta_cpe) OR EMPTY(ls_cod_rpta_cpe) THEN 
			ls_cod_rpta_cpe = '0'
		ENDIF 
		*-------------------------------------------------------		
		
		li_nreg = VAL(this.omiscela.getFld_WKStr("resumen_bv", 'count(fecha_emision)', '', '', ;
			"(fecha_emision = '&ls_fecha_emision') AND (correlativo = &ls_correlativo)",-1))
		lsTbResumen = "resumen_bv"			
		&& ---------- CGR 20180316 ---------------------------
		lsTick = ALLTRIM(NVL(lo_json.get('ticket'),''))
		IF lbCheckTicket AND EMPTY(lsTick) THEN				  
			ls_sql_st = ", sinticket=1"
		ENDIF 			
		&& ----------------------------------------------------
		
		
		IF li_nreg < 1 THEN 
			this.mensaje = "No existen resúmenes a actualizar para fecha emisión: '&ls_fecha_emision' y correlativo Nº &ls_correlativo !!"
	  		RETURN .f.
		ENDIF 			
		**Modificado 23-01-2018 CGR
		*******************************
		TEXT TO ls_sqlUp TEXTMERGE NOSHOW 
			UPDATE <<lsTbResumen>>
			SET 
				estado_cpe = '<<ls_estado_cpe>>', 
				cod_rpta_cpe = <<ls_cod_rpta_cpe>>, 
				descri_estado_cpe = '<<ls_descri_cpe>>',
				codeCDR = 'ls_code64CDR',  
				estado = CASE 
						WHEN accion=3 THEN 0 ELSE 1
					END,
				estado_baja_cpe = CASE 
						WHEN accion=3 THEN '<<ls_estado_cpe>>' ELSE NULL
					END				
				<<ls_sql_st>>	
			WHERE 
				fecha_envio = '<<ls_fechaEnvio>>' 
				AND correlativo = <<ls_correlativo>>
		ENDTEXT 		
		*_cliptext=ls_sqlUp
		ls_sqlUp = STRTRAN(ls_sqlUp, "ls_code64CDR", ls_code64CDR) && CGR 101
		
		*lbOk = EjectSql(CONFIRMAR_TRANS, ls_sqlUp, _screen.nconn)
		lbOk = EjectSql(ls_sqlUp)		
		IF (!lbOk)			
			this.mensaje = "NO se pudo 'grabar' confirmación o rechazo de Envío!"
			RETURN .f.
		ENDIF 		
		
		RETURN lbOk
	ENDPROC
	
	
	*************************************************************************************************
	* Funcion 'saveTicketCPE_rbv'   (CLASE CE) (R.B.V.)                                                         *
	*   Graba en la BD el Nro. de Ticket de la respuesta del Web Service por el Envío del Resumen BV *
	*   Solo Resumen de Boletas 	                                                                 *
	*    Parametros:                                                                                 *
	*	      lo_docCPE    :	Documento a Procesar                                                 *
	**************************************************************************************************
	PROCEDURE saveTicketCPE_rbv()
		*IF (VARTYPE(lo_docCPE)<> 'O') THEN
		*	this.mensaje  = "Función necesita 1 parámetro de Objeto ('saveTicketCPE_rbv')!"
		*	RETURN .f.
		*ENDIF
		
		LOCAL lbOk as boolean, li_nreg as Integer 
		LOCAL ls_fechaEnvio as string, ls_fecha_emision as String 
		LOCAL ls_descri_cpe, ls_correlativo
		LOCAL ls_sqlUp, lsTbResumen, lsTicket
		
		ls_correlativo	= ALLTRIM(STR(this.correlativo,4))
		
		ls_fechaEnvio	= this.omiscela.fmt_fecha(this.fecha_envio)
		ls_fecha_emision= this.omiscela.fmt_fecha(this.fecha_emision)	
		lsTicket		= ALLTRIM(this.ticket)	
		
		lsTbResumen = "resumen_bv"		
		
		TEXT TO ls_sqlUp TEXTMERGE NOSHOW 
			UPDATE <<lsTbResumen>>
			SET 
				ticket = '<<lsTicket>>'
			WHERE 
				fecha_envio = '<<ls_fechaEnvio>>' 
				AND correlativo = <<ls_correlativo>>
		ENDTEXT 
		*lbOk = EjectSql(CONFIRMAR_TRANS, ls_sqlUp, _screen.nconn)
		lbOk = EjectSql(ls_sqlUp)
		
		IF (!lbOk)
			this.mensaje = "NO se pudo 'grabar' Nro. Ticket del Resumen de Boletas!"
			RETURN .f.
		ENDIF 
		
		RETURN lbOk
	ENDPROC	
	
	********************************************************
	*//////////////////// Genera y Envia el XML (R.B.V.)
	* Envia al servidor WEB y recibe la Rpta
	* Genera los XML's y el CDR de respuesta si existe
	********************************************************
	FUNCTION enviaXML()
		LOCAL cUrl, cMsg, cMsg_CDR, oJson, ls_base64, ls_cdr
		LOCAL ls_ruta, ls_xml, ls_zip, ls_file, ls_ruta_Sunat
		LOCAL ls_fecEnvio, lbErr 
		cUrl = this.getUrl("envio")				
		
		ls_ruta       = ADDBS(this.ruta_main + this.ruta_firma_xml)
		ls_ruta_Sunat = ADDBS(this.ruta_main + this.ruta_sunat_xml) && Ruta de la SUNAT						

		cDoc = this.fmt_fecha(this.fecha_envio) + "-" + ALLTRIM(STR(this.correlativo))
		*TRY
			cData = this.genJson("envio")
			STRTOFILE(cData, "d:\_gorbv_envi.json")
			oHttp = CREATEOBJECT("MSXML2.XMLHTTP")
			oHttp.open("POST", cUrl, .f.)
			oHttp.setRequestHeader("Content-Type", "application/json;utf-8")
			TRY 
				oHttp.Send(cData)			
			CATCH TO oEx							
				cMsg = "Fallo la conexion con el Servidor Web!" + CRLF  
				IF oEx.ErrorNo = 1429 THEN 
					cMsg = cMsg + IIF(oEx.ErrorNo = 1429,  "Verifique que el servidor Web esta funcionando!", + STR(oEx.ErrorNo) + ": "+ oEx.message)	
				ENDIF 				
				this.mensaje = cMsg								
				lbErr = .t.
			ENDTRY 
			IF lbErr THEN 
				RETURN .f.
			ENDIF 						
			
			*mb(oHttp.status)
			IF oHttp.status=200 THEN				
				cRpta = oHttp.ResponseText				
				STRTOFILE(cData, "d:\_gorbv_envi.json")
				STRTOFILE(cRpta, "d:\_gorbv_rpta.json")
				oJson = json_decode(cRpta)				
				
				ls_base64 = oJson.get('base')
			
				ls_file               = ls_ruta + this.emi_ruc + "-RC-" + DTOS(this.fecha_envio) + "-" + ALLTRIM(STR(this.correlativo))
				ls_zip                = ls_file + ".zip"				
				
				IF oJson.get('statusCode') != 200 THEN	&& ERROR en el "CDR"					
					cMsg_CDR = "CDR ==> Error Code: " + ALLTRIM(STR(oJson.get('code'))) + " - Mensaje:" + oJson.get('Estado') + CRLF + oJson.get('Note')
					oJson.set('msgCdr',cMsg_CDR)
					
					IF !(EMPTY(ls_base64) .or. ISNULL(ls_base64)) THEN
						&& XML Zip file
						IF STRTOFILE(STRCONV(ls_base64, 14), ls_zip) = 0 &&Si se escribio 0 Bytes, No se creo zip del xml
							cMsg = "No se pudo crear el archivo XML. Verificar!!"
						ENDIF
						IF !this.omiscela.unzippear(ls_zip, ls_ruta) THEN	&& Descomprimir XML Comprobante
							cMsg =  this.omiscela.mensaje
						ENDIF
					ENDIF
				ELSE && EXITO *** ENVIO XML ***
					ls_xml = ls_file + ".xml"
					
					oCdr          = oJson.get('cdr')
					ls_cdrFileZip = ls_ruta_Sunat + oCdr.get('nombre')
					ls_cdrzip64   = oCdr.get('zip')
					
					*lo_fac_ce.fileEsquema = ls_xml
					&&------------XML-----------------
					&& Crea XML Zip file
					IF STRTOFILE(STRCONV(ls_base64, 14), ls_zip) = 0 &&Si se escribio 0 Bytes, No se creo zip del xml
						cMsg = "No se pudo crear el archivo XML. Verificar!!"
					ENDIF					
					
					&& UnZip XML file					
					IF !this.omiscela.unzippear(ls_zip, ls_ruta) THEN	&& Descomprimir XML Comprobante
						cMsg =  this.omiscela.mensaje
					ENDIF					
					
					&&------------CDR ZIP-----------------
					IF (!EMPTY(ls_cdrzip64)) THEN 					
						&& Crea CDR Zip file
						IF STRTOFILE(STRCONV(ls_cdrzip64, 14), ls_cdrFileZip) = 0 &&Si se escribio 0 Bytes, No se creo zip del CDR
							cMsg = "No se pudo crear el archivo CDR. Verificar!!"
						ENDIF
						
						&& UnZip CDR file					
						IF !this.omiscela.unzippear(ls_cdrFileZip, ls_ruta_Sunat) THEN	&& Descomprimir CDR Sunat
							cMsg =  this.omiscela.mensaje
						ENDIF
					ENDIF 					
				ENDIF
			ELSE				
				cMsg = '----No se pudo conectar al Servidor WEB ' +CRLF+;
					'Verifique el URL de conexion Servidor web este configurado correctamente!'
			ENDIF
		*CATCH TO oEx
		*	cMsg = '***No se puede Generar archivo XML de "«' + cDoc +"»!" + CRLF  + oEx.message
		*FINALLY
			oHttp = null
		*ENDTRY 
		
		IF EMPTY(cMsg) THEN
			this.mensaje_CDR = cMsg_CDR
			RETURN oJson
		ELSE
			this.mensaje = cmsg
			RETURN oJson
		ENDIF 
	ENDFUNC &&Fin-enviaXML()
	
	********************************************************
	*//////////////////// getDetalle (R.B.V.)
	********************************************************
	FUNCTION getDetalle(pd_fecha_emision, pd_fecha_envio, pi_correlativo)
		LOCAL cCurName, cJson
		
		cCurName = this.obt_detalle_comprobante(pd_fecha_emision, pd_fecha_envio, pi_correlativo)
		IF !EMPTY(cCurName)
			cJson = ''
			SELECT &cCurName
			GO TOP 
			DO WHILE !EOF()
				TEXT TO  cJson NOSHOW TEXTMERGE ADDITIVE 
					<<IIF(RECNO()==1, "", ",")>>
					<<this.detaToJson()>>
				ENDTEXT
				
				SELECT &cCurName
				SKIP
			ENDDO
			
			RETURN "[" + cJson + "]"
		ELSE
			RETURN ''
		ENDIF
	ENDFUNC && genDetalle()
	
	FUNCTION detaToJson()
		LOCAL nRecno,i, oDeta, oDoc_Modi, cRetVal
		LOCAL campo_modi , campo
		LOCAL campo
		if alias()==''
			return ''
		ENDIF
		oDoc_Modi = newObject('myObj')
		oDeta = newObject('myObj')
		for i=1 to fcount()
			campo = ALLTRIM(Field(i))
			IF INLIST(campo, "TIPODOC_MODI", "NRODOC_MODI") THEN && Doc Referencia				
				campo_modi = SUBSTR(campo,1, AT("_MODI", campo)-1)				
				oDoc_Modi.set(campo_modi, eval(campo))
			ELSE
				oDeta.set(campo,eval(campo))
			ENDIF 					
		NEXT
		oDeta.set("docreferencia", oDoc_Modi)
		
		cRetVal = json_encode(oDeta) 
		if not empty(json_getErrorMsg())
			cRetVal = 'ERROR:'+json_getErrorMsg()
		endif
	RETURN cRetVal

	********************************************************
	*//////////////////// getDetalle (R.B.V.)
	*// Genera Cursor detallado para el R. B. V.
	********************************************************
	FUNCTION obt_detalle_comprobante(pd_fecha_emision, pd_fecha_envio, pi_correlativo)		
		LOCAL cCurName, cJson, cSql, ls_fechaEnvio
		cCurName = 'D' + SYS(2015)				
		
		ls_fechaEnvio = this.fmt_fecha(pd_fecha_envio)
		*--r_d.nfila
		*, coalesce(r_d.ndoc_modi, 0) as ndoc_modi
		*, coalesce(r_d.nser_modi)    as tipodoc_modi
		TEXT TO cSql NOSHOW TEXTMERGE
			SELECT 				
				coalesce(r_d.docide, '')::varchar(10)      as clienumdoc
				, coalesce(r_d.tipodocide, '')::varchar(2) as clietipodoc
				, r_d.tipodoc
				, r_d.nser || '-' || r_d.ndoc  as ndoc
				, coalesce(r_d.tipodoc_modi)   as tipodoc_modi								
				, CASE WHEN coalesce(r_d.tipodoc_modi, '') = '' THEN '' ELSE 
					coalesce(r_d.nser_modi) || '-' || coalesce(r_d.ndoc_modi, 0) END::varchar(10)  as nrodoc_modi								
				, r_d.estado
				, r_d.total_vv_grav 		   as mtoopergravadas
				, r_d.total_vv_exo			   as mtooperexoneradas
				, r_d.total_vv_ina 			   as mtooperinafectas
				, r_d.total_vv_grat			   as mtoopergratuitas
				, r_d.importe_otros			   as mtootroscargos	
				, total_isc 				   as mtoisc	
				, total_igv					   as mtoigv
				, total_otros_trib			   as mtootrostributos
				, total_general 			   as total
			FROM 
				resumen_bv_detalle r_d
			WHERE 
				(fecha_envio = '<<ls_fechaEnvio>>')
				AND (correlativo = <<ALLTRIM(STR(pi_correlativo,4))>>)
			ORDER BY 
				nfila
		ENDTEXT 
		*_cliptext=cSql				
				
		IF EjectSql(cSql, cCurName)
			RETURN cCurName
		ELSE
			mb("Error detalle")
			RETURN ''
		ENDIF 		
	ENDFUNC && obt_detalle_comprobante
	
	&& getCabecera()
	
	**********************************************************
	*/////////////////////getCabecera (R.B.V.)  *
	**********************************************************
	FUNCTION getCabecera() &&cTipoDoc, cNser, cNdoc
		LOCAL cSql, cCurName, cCurEmi
		LOCAL ls_emirazsoc, ls_eminomcomer
		LOCAL cJson, oEmi, oDirEmi, oResumen, lon
		
		cCurEmi = 'C' + SYS(2015)
		TEXT TO  cSql NOSHOW TEXTMERGE
			SELECT 
				emi_ubigeo 
				,emi_razon_social
				,emi_direccion
				,emi_urbanizacion
				,emi_nombre_comercial
			FROM confi_ce
		ENDTEXT 	
		
		
		IF .NOT. EjectSql(cSql, cCurEmi)
			MESSAGEBOX("ERROR al consultar datos de Emisor!!!",gs_app_name)
			RETURN .F.
		ENDIF
		
		SELECT (cCurEmi)
		GO TOP	
		IF RECNO()=0 THEN 
			this.mensaje="No existe registro de Emisor de Facturación electrónica!"
			close_cursor(cCurEmi)
			RETURN .f.
		ENDIF 
		
		oDirEmi = CREATEOBJECT('myObj')				
		oDirEmi.set("ubigueo"     , emi_ubigeo )
		oDirEmi.set("direccion"   , f_escapar_apostrofes(ALLTRIM(emi_direccion)) )
		oDirEmi.set("urbanizacion", f_escapar_apostrofes(ALLTRIM(emi_urbanizacion)) )		
		oDirEmi.set("departamento", null)
		oDirEmi.set("provincia"   , null)
		oDirEmi.set("distrito"    , null)				
		oDirEmi.set("codigoPais"  , 'PE')			
		
		oEmi = CREATEOBJECT('myObj')				
		oEmi.set("razonsocial"    , f_escapar_apostrofes(ALLTRIM(emi_razon_social)) )		
		oEmi.set("nombrecomercial", f_escapar_apostrofes(ALLTRIM(emi_nombre_comercial)))
		oEmi.set("ruc", this.emi_ruc)
		 				= ''
		oEmi.set("address"    , oDirEmi )	
				
		close_cursor(cCurEmi)		
		*///////////
		
		ls_correlativo = ALLTRIM(STR(this.correlativo))		
		ls_FecEmi      = DTOS(this.fecha_emision)
		ls_FecEnvio    = DTOS(this.fecha_envio)						
		
		oResumen = CREATEOBJECT('myObj')				
		oResumen.set("correlativo"   , ls_correlativo)		
		oResumen.set("fecgeneracion" , ls_FecEmi     )		
		oResumen.set("fecresumen"    , ls_FecEnvio   )				
		oResumen.set("company"       , oEmi   )							
		
		cJson = ALLTRIM(json_encode(oResumen))		
		lon = LEN(cJson)
		IF lon > 0 THEN 			
			cDeta = this.getDetalle(this.fecha_emision, this.fecha_envio , this.correlativo)
			IF ATC("ERROR parsing JSON", cDeta) > 0 THEN 
				this.mensaje = "Error al generar JSON del detalle del documento!"
				RETURN ''
			ENDIF 			
			cJson = SUBSTR(cJson, 1, lon-1) + [, "details": ] + cDeta + SUBSTR(cJson, lon, 1)
		ENDIF 		
		oEmi     = null
		DirEmi   = null
		oResumen = null	
		
		RETURN cJson		
	ENDFUNC && fin-getCabecera()
	
	PROCEDURE fmt_fecha(mifecha)
		LOCAL fmt
		
		IF PCOUNT() <> 1 THEN
			mensaje = 'Parametro de fecha a formatear es obligatorio'
			RETURN .f.
		ENDIF
		
		fmt = DTOS(mifecha)
		fmt = LEFT(fmt,4) + '-' + SUBSTR(fmt,5,2) + '-' + right(fmt,2)
		RETURN fmt
	ENDPROC &&Fin - fmt_fecha()	

ENDDEFINE &&Fin Clase CPE_R.B.V


********************************************************************
* Utilidad de CPE
********************************************************************
DEFINE CLASS CPE_UTIL AS CUSTOM	
	mensaje     = ''
	mensaje_CDR = ''
	oRp  = null
	
	FUNCTION genJson(cAccion, cTipoDoc, cNser, cNdoc )
		LOCAL cIsBeta, cRuc, cCurCfg, cSol_usuario, cSol_pwd
		cIsBeta = f_get_data_select("select is_beta as dato from confi_ce")
		
		cCurCfg = 'C' + SYS(2015)
		TEXT TO  cSql NOSHOW TEXTMERGE
			SELECT 
				emi_ruc 
				,sol_usuario
				,sol_pwd
			FROM confi_ce
		ENDTEXT 
		
		IF !EjectSql(cSql, cCurCfg) THEN 
			this.mensaje="Ocurrió un error al obtener datos de Emisor!"
			RETURN .f.
		ENDIF 
		
		SELECT (cCurCfg)
		GO TOP
		IF RECNO()=0 THEN
			this.mensaje="No existe registro de Emisor de Facturación electrónica!"
			close_cursor(cCurEmi)
			RETURN .f.
		ENDIF 
		cRuc = emi_ruc
		cSol_usuario = ALLTRIM(sol_usuario)
		cSol_pwd = ALLTRIM(sol_pwd)
		close_cursor(cCurCfg)
		
		cCab = this.getcabecera(cTipoDoc, cNser, cNdoc) && OJO: ver Exporta en cabecera
		
		**---------------------------------------------------------------
		** 27-11-2018 12:25 pm - WVA - validar que se ha generado bien el json de la cabecera
		**---------------------------------------------------------------
		IF ATC("ERROR parsing JSON",cCab) > 0 THEN 
			this.mensaje="Error al generar JSON de la cabecera del documento!"
			RETURN .f.
		ENDIF 
		**---------------------------------------------------------------
		
		cDet = this.getdetalle(cTipoDoc, cNser, cNdoc)
		
		**---------------------------------------------------------------
		** 27-11-2018 12:25 pm - WVA - validar que se ha generado bien el json de la cabecera
		**---------------------------------------------------------------
		IF ATC("ERROR parsing JSON",cDet) > 0 THEN 
			this.mensaje="Error al generar JSON del detalle del documento!"
			RETURN .f.
		ENDIF 
		**---------------------------------------------------------------
		
		cWS = IIF(cIsBeta = "1", "beta", "produccion")
		
		cAccion = LOWER(cAccion)
		*IF !INLIST(cAccion, "xml", "envio") THEN 
		*	mb("Accion a realizar '&cAccion' no es valida!")
		*	RETURN ''
		*ENDIF 
		
		TEXT TO cJson NOSHOW TEXTMERGE
			{
				"ws":"<<cWS>>",
				"accion":"<<cAccion>>",
				"ruc": "<<cRuc>>",
				"sol_usuario": "<<cSol_usuario>>",	
				"sol_pwd": "<<cSol_pwd>>",
				"cabezera": <<cCab>>,
				"detalle": [
					<<cDet>> 
				]
			}
		ENDTEXT
		
		*_cliptext = cJson 
		RETURN cJson
	ENDFUNC && genJson()		
	
	FUNCTION getUrl(ls_script)
		IF VARTYPE(ls_script)="L" THEN
			MESSAGEBOX("Falta Script de la URL!", 16, gs_app_name)
		ENDIF 
		
		LOCAL cUrl, curl_local
		cUrl = f_get_data_select("select urlcpe as dato from confi_ce") + ls_script + ".php"
		
		IF VARTYPE(gURL_CPE_HOST)="C" THEN 
			RETURN gURL_CPE_HOST
		ENDIF
		
		DECLARE INTEGER InternetCheckConnection IN wininet.dll; 
    		STRING lpszUrl, LONG dwFlags, LONG dwReserved
		
		curl_local = f_get_data_select("select urlcpelocal as dato from confi_ce")+ ls_script + ".php"
    	
    	IF (InternetCheckConnection(cUrl, FLAG_ICC_FORCE_CONNECTION, 0)!=1) THEN
			cUrl = curl_local
	    ELSE && Si Hay Conexión de Internet
	    	*IF !this.isWebActivo() THEN 
			*	MESSAGEBOX("CESLYWEB no funciona!", 16, gs_app_name)
			*	cUrl = curl_local
			*ENDIF
		ENDIF
		
		gURL_CPE_HOST = cUrl
		
		RETURN cUrl
	ENDFUNC 
	
	
	********************************************************
	* Identifica si el URL del web es activo
	********************************************************
	FUNCTION isWebActivo()
		LOCAL cRpta, oHt, isActivo as Boolean, cversion
		isActivo = .F.		
		oHt = CREATEOBJECT("MSXML2.XMLHTTP")														  		
		oHt.open("GET", URL_TEST, .f.)
		oHt.setRequestHeader("Content-Type", "text/html;utf-8")
		oHt.Send()
		DO CASE
		CASE oHt.status=200 	
			*cRpta = oHt.ResponseText
			cversion = STRTRAN(oHt.ResponseText, CHR(10))
			cversion = STRTRAN(cversion, CHR(13))
			cversion = LEFT(cversion, 1)
			IF INLIST(cversion, '5','7') THEN 
				isActivo = .T.
			ENDIF 
		CASE oHt.status=404 
			cRpta = "404 No se encontró"
			isActivo = .F.
		OTHERWISE
			cRpta = "Otro mensaje"
			isActivo = .F.
		ENDCASE 				
		*MESSAGEBOX(cversion)
		*MESSAGEBOX(IIF(isActivo, "**ACTIVO**", "Inactivo")) 
		*MESSAGEBOX(oHt.status)
		*oHt = null
		RETURN isActivo
	ENDFUNC	
	
	********************************************************
	* Genera el XML
	********************************************************
	FUNCTION genXml(ps_tipodoc, ps_nser, ps_ndoc, lo_fac_ce)
		LOCAL cUrl, cMsg, oJson, ls_base64
		LOCAL ls_ruta, ls_xml, ls_zip, ls_file
		cUrl = this.getUrl("envio")
		
		WITH lo_fac_ce.lo_config_ce
			ls_ruta = ADDBS(.ruta_main + .ruta_firma_xml)
		ENDWITH 
		
		**---------------------------------------------------------
		** 26-11-2018 05:10 pm - WVA -- Validar si existe la ruta
		**---------------------------------------------------------
		LOCAL vDirectorio
		
		vDirectorio = LEFT(ls_ruta,LEN(ls_ruta) - 1)
		IF !DIRECTORY(vDirectorio) THEN  &&Si no existe el Directorio, lo crea
			this.mensaje = "No existe el Directorio: " + vDirectorio
			RETURN .F.
		ENDIF
		**---------------------------------------------------------
		
		cDoc = ps_nser + "-" + ps_ndoc
		TRY
			cData = this.genJson("xml", ps_tipodoc, ps_nser, ps_ndoc)
			oHttp = CREATEOBJECT("MSXML2.XMLHTTP")
			oHttp.open("POST", cUrl, .f.)
			oHttp.setRequestHeader("Content-Type", "application/json;utf-8")
			oHttp.Send(cData)
			
			IF oHttp.status=200 THEN
				cRpta = oHttp.ResponseText
				STRTOFILE(cData, "d:\_envi.json")
				STRTOFILE(cRpta, "d:\_rpta.json")
				oJson = json_decode(cRpta)
				
				**---------------------------------------------------------
				** 26-11-2018 05:10 pm - WVA -- Validar si se generó el json
				**---------------------------------------------------------
				IF VARTYPE(oJson) <> 'O' THEN
					cMsg = "No se pudo decodificar el JSON de la Respuesta"
				ENDIF
				**---------------------------------------------------------
				
				IF oJson.get('statusCode') != 200 THEN
					cMsg = oJson.get('Estado')
				ELSE && EXITO !!
					ls_file = ls_ruta + lo_fac_ce.lo_config_ce.emi_ruc + "-" + lo_fac_ce.tipodoc + "-" + lo_fac_ce.ndocumento
					ls_zip = ls_file + ".zip"
					ls_xml = ls_file + ".xml"
					ls_base64 = oJson.get('base')
					ls_hash = oJson.get('hash')
					lo_fac_ce.fileEsquema = ls_xml
					lo_fac_ce.hash        = ls_hash
					lo_fac_ce.zipCode64   = ls_base64
					this.oRp = oJson
					IF STRTOFILE(STRCONV(ls_base64, 14), ls_zip) = 0 &&Si se escribio 0 Bytes, No se creo xml
						cMsg = "No se pudo crear el archivo XML. Verificar!!"
					ENDIF
					
					IF !lo_fac_ce.omiscela.unzippear(ls_zip, ls_ruta) THEN	&& Descomprimir CDR Sunat
						cMsg =  this.omiscela.mensaje
					ENDIF
				ENDIF
			ELSE
				MESSAGEBOX(oHttp.status)
				cMsg = '----No se puede Generar archivo XML de "«' + cDoc +"»!"
			ENDIF
		CATCH TO oEx
			*cMsg = '***No se puede Generar archivo XML de "«' + cDoc +"»!" + CRLF  + oEx.message
			
			**---------------------------------------------------------
			** 26-11-2018 05:10 pm - WVA -- Validar si se generó el json
			**---------------------------------------------------------
			IF EMPTY(cMsg) OR ISNULL(cMsg) THEN 
				cMsg = '***No se puede Generar archivo XML de "«' + cDoc +"»!" + CRLF  + oEx.message
			ELSE
				cMsg = '***No se puede Generar archivo XML de "«' + cDoc +"»!" + CRLF + cMsg + CRLF + oEx.message
			ENDIF
			**---------------------------------------------------------
		FINALLY
			oHttp = null
		ENDTRY 
		
		IF EMPTY(cMsg) THEN 
			RETURN .T.
		ELSE
			this.mensaje=  cmsg
			RETURN .F.
		ENDIF 
	ENDFUNC &&Fin-genXml()
	
	********************************************************
	* Genera y Envia el XML
	********************************************************
	FUNCTION enviaXML(ps_tipodoc, ps_nser, ps_ndoc, lo_fac_ce)
		LOCAL cUrl, cMsg, cMsg_CDR, oJson, ls_base64, ls_cdr
		LOCAL ls_ruta, ls_xml, ls_zip, ls_file, ls_ruta_Sunat
		cUrl = this.getUrl("envio")
		
		WITH lo_fac_ce.lo_config_ce
			ls_ruta = ADDBS(.ruta_main + .ruta_firma_xml)
			ls_ruta_Sunat = ADDBS(.ruta_main + .ruta_sunat_xml) && Ruta de la SUNAT
		ENDWITH
		
		cDoc = ps_nser + "-" + ps_ndoc
		TRY
			&& Generamos el Json "cData"
			cData = this.genJson("envio", ps_tipodoc, ps_nser, ps_ndoc) 
			&& Enviamos el JSON con el metodo "POST"
			oHttp = CREATEOBJECT("MSXML2.XMLHTTP")
			oHttp.open("POST", cUrl, .f.)
			oHttp.setRequestHeader("Content-Type", "application/json;utf-8")
			oHttp.Send(cData)  && envio JSON
			
			IF oHttp.status=200 THEN
				cRpta = oHttp.ResponseText
				*STRTOFILE(cData, "d:\_envi.json")
				*STRTOFILE(cRpta, "d:\_rpta.json")
				oJson = json_decode(cRpta)
				
				ls_base64 = oJson.get('base')
				ls_hash = oJson.get('hash')
				
				lo_fac_ce.hash        = ls_hash
				lo_fac_ce.zipCode64   = ls_base64
				ls_file = ls_ruta + lo_fac_ce.lo_config_ce.emi_ruc + "-" + lo_fac_ce.tipodoc + "-" + lo_fac_ce.ndocumento
				ls_zip = ls_file + ".zip"
				
				IF oJson.get('statusCode') != 200 THEN	&& ERROR en el "CDR"
					cMsg_CDR = "CDR ==> Error Code: " + ALLTRIM(STR(oJson.get('code'))) + " - Mensaje:" + oJson.get('Estado') + CRLF + oJson.get('Note')
					oJson.set('msgCdr',cMsg_CDR)
					
					IF !(EMPTY(ls_base64) .or. ISNULL(ls_base64)) THEN
						&& XML Zip file
						IF STRTOFILE(STRCONV(ls_base64, 14), ls_zip) = 0 &&Si se escribio 0 Bytes, No se creo zip del xml
							cMsg = "No se pudo crear el archivo XML. Verificar!!"
						ENDIF
						IF !lo_fac_ce.omiscela.unzippear(ls_zip, ls_ruta) THEN	&& Descomprimir XML Comprobante
							cMsg =  this.omiscela.mensaje
						ENDIF
					ENDIF
				ELSE && EXITO *** ENVIO XML ***
					ls_xml = ls_file + ".xml"
					
					oCdr = oJson.get('cdr')
					ls_cdrFileZip = ls_ruta_Sunat + oCdr.get('nombre')
					ls_cdrzip64 = oCdr.get('zip')
					
					lo_fac_ce.fileEsquema = ls_xml
					
					&& XML Zip file
					IF STRTOFILE(STRCONV(ls_base64, 14), ls_zip) = 0 &&Si se escribio 0 Bytes, No se creo zip del xml
						cMsg = "No se pudo crear el archivo XML. Verificar!!"
					ENDIF
					&& CDR Zip file
					IF STRTOFILE(STRCONV(ls_cdrzip64, 14), ls_cdrFileZip) = 0 &&Si se escribio 0 Bytes, No se creo zip del CDR
						cMsg = "No se pudo crear el archivo CDR. Verificar!!"
					ENDIF
					
					IF !lo_fac_ce.omiscela.unzippear(ls_zip, ls_ruta) THEN	&& Descomprimir XML Comprobante
						cMsg =  this.omiscela.mensaje
					ENDIF
					&& UnZip CDR file
					
					IF !lo_fac_ce.omiscela.unzippear(ls_cdrFileZip, ls_ruta_Sunat) THEN	&& Descomprimir CDR Sunat
						cMsg =  this.omiscela.mensaje
					ENDIF
					
				ENDIF
			ELSE
				cMsg = '----No se puede Generar archivo XML de "«' + cDoc +"»!"
			ENDIF
		CATCH TO oEx
			cMsg = '***No se puede Generar archivo XML de "«' + cDoc +"»!" + CRLF  + oEx.message
		FINALLY
			oHttp = null
		ENDTRY 
		
		this.oRp = oJson
		
		IF EMPTY(cMsg) THEN
			this.mensaje_CDR = cMsg_CDR
			RETURN .T.
		ELSE
			this.mensaje = cmsg
			RETURN .F.
		ENDIF 
	ENDFUNC &&Fin-enviaXML()
	
	FUNCTION getDetalle(cTipoDoc, cNser, cNdoc)
		LOCAL cCurName, cJson
		
		cCurName = this.obt_detalle_comprobante(cTipoDoc, cNser, RIGHT(cNdoc, 7))
		IF !EMPTY(cCurName)
			cJson = ''
			SELECT &cCurName
			GO TOP 
			DO WHILE !EOF()
				TEXT TO  cJson NOSHOW TEXTMERGE ADDITIVE 
					<<IIF(RECNO()==1, "", ",")>>
					<<recordToJson()>>
				ENDTEXT
				
				SELECT &cCurName
				SKIP
			ENDDO
			
			RETURN cJson
		ELSE
			RETURN ''
		ENDIF
	ENDFUNC && genDetalle()
	
	FUNCTION obt_detalle_comprobante(cTipoDoc, cNser, cNdoc)		
		LOCAL cCurName, cJson, cSql
		cCurName = 'D' + SYS(2015)				
		
		TEXT TO cSql NOSHOW TEXTMERGE
			select 
				(vta_det.codarti::varchar(6)) as codProducto
				/*,ar.codsunat as codSunat*/
				,(case when vta_det.codarti='ZZZZZZ' then vta_det.codsunat else ar.codsunat end)::varchar(10) as codSunat
				,(case when vta_det.tipodoc in('07', '08') or vta_det.codarti = 'ZZZZZZ' then coalesce(nullif(vta_det.detalle, ''), ar.nomb) else ar.nomb end)::varchar(200) as descripcion
				,vta_det.cod_unid1 as unidad
				,vta_det.cant as cantidad 
				,(case when nullif(vta_det.bonificacion, '') is null then usp_calcular_dcto_linea(CASE WHEN vta_det.tipoimpu in('E','I', '2', '3') THEN prec ELSE prec / (1+(vta_det.impuesto/100)) END * (vta_det.cant), vta_det.dsct1, vta_det.dsct2, 0.00) else 0 end)::numeric(14,4) as descuento
				/*,(case when nullif(vta_det.bonificacion, '') is null then coalesce(vta_det.dsct1, vta_det.dsct2, 0.00) else 0 end)::numeric(14,4) as factorDescuento*/
				,(case when nullif(vta_det.bonificacion, '') is null then ( (vta_det.dsct1 + vta_det.dsct2) - (vta_det.dsct1 * vta_det.dsct2 / 100)) else 0 end)::numeric(14,4) as factorDescuento
				,(case when vta_det.tipoimpu in ('I', 'E', '2', '3') then 0 else (vta_det.importe - ROUND(vta_det.importe / (1+(vta_det.impuesto/100)),2)) end) as igv
				,vta_det.impuesto as pigv	
				,0::numeric(12,2) as isc
				,0::numeric(5,2) as pisc	
				,null::varchar(10) as tipSisIsc
				,CASE
					WHEN vta.afecto_ivap='S' then 17
					WHEN vta.exportacion='S' then 40
					WHEN vta_det.tipoimpu IN('G','1')  THEN
						CASE coalesce(vta_det.bonificacion, '')
							WHEN 'B' THEN 15 --&&Gravado - Bonificaciones
							WHEN 'T' THEN 12 --&&Gravado – Retiro por donación
							ELSE 10
						END
					WHEN vta_det.tipoimpu IN('E','2') THEN
						CASE coalesce(vta_det.bonificacion, '')
							WHEN 'B' THEN 21 --&&Exonerado – Transferencia Gratuita
							WHEN 'T' THEN 21 --&&Exonerado – Transferencia Gratuita
							ELSE 20
						END
					WHEN vta_det.tipoimpu IN('I','3') THEN
						CASE coalesce(vta_det.bonificacion, '')
							WHEN 'B' THEN 31 --&&Inafecto – Retiro por Bonificación
							WHEN 'T' THEN 32 --&&Inafecto - Retiro
							ELSE 30
						END
					ELSE 0
				END as tipAfeIgv
				,vta_det.item
				,vta_det.prec as mtoPrecioUnitario
				,CASE WHEN coalesce(vta_det.bonificacion, '') in ('T','B') THEN 0.00 ELSE
					CASE
						WHEN vta_det.tipoimpu IN('E','I', '2', '3') THEN (vta_det.prec)
						ELSE ROUND((vta_det.prec) / (1+(vta_det.impuesto/100)),2)
					END
				END as mtoValorUnitario
				,vta_det.precio_ref as mtoValorGratuito
				,vta_det.importe
				,ROUND(vta_det.importe / (1+(vta_det.impuesto/100)),2) as mtoValorVenta
				,''::varchar(16)  as numPlacaVehi
				,vta_det.monto_ivap::numeric(14,2) as ivap
				,vta_det.porc_ivap::numeric(14,2) as pivap
				,null::varchar(6) as detracOriUbigeo
				,null::varchar(6) as detracDestUbigeo
				,''::varchar(50)  as detracOriDir
				,''::varchar(50)  as detracDestDir
				,''::varchar(50)  as detracDetalleViaje
				,0::numeric(12,2) as VR
				,0::numeric(12,2) as VRCE
				,0::numeric(12,2) as VRCN
				,0::numeric(12,2) as CE
				,0::numeric(12,2) as CN
				,False::boolean   as esFR
				,0::numeric(12, 2) as peso
				,''::varchar(20)   as orden_compra
				,0::numeric(14, 6) as prec2
				,0::numeric(14, 4) as cant2
				,ar.unidadm as um_vta
			from 
				venta_detalle as vta_det
				inner join articulo as ar on vta_det.codarti = ar.codarti
				inner join venta as vta ON vta.tipodoc = vta_det.tipodoc AND vta.nser = vta_det.nser
				AND vta.ndoc = vta_det.ndoc AND vta.alma=vta_det.alma
			where
				vta_det.tipodoc = '<<cTipoDoc>>'
				and vta_det.nser = '<<cNser>>'
				and vta_det.ndoc = '<<cNdoc>>'	
		ENDTEXT		
		*_cliptext=cSql
		
		IF EjectSql(cSql, cCurName)
			RETURN cCurName
		ELSE
			RETURN ''
		ENDIF 
	ENDFUNC && obt_detalle_comprobante
	
	FUNCTION getCabecera(cTipoDoc, cNser, cNdoc)
		LOCAL cSql, cCurName
		LOCAL cJson
		
		cCurName = this.obt_cabecera_comprobante(cTipoDoc, cNser, RIGHT(cNdoc, 7))
		IF !EMPTY(cCurName)
			SELECT &cCurName
			RETURN recordToJson()
		ELSE 
			RETURN ''
		ENDIF
	ENDFUNC && getCabecera()
	
	FUNCTION obt_cabecera_comprobante(cTipoDoc, cNser, cNdoc)
		LOCAL cSql, cCurName, cCurEmi
		LOCAL ls_emiubigeo, ls_emidir, ls_emiurbaniza, ls_emiubigeo, ls_emirazsoc, ls_eminomcomer
		LOCAL cJson
		
		cCurEmi = 'C' + SYS(2015)
		TEXT TO  cSql NOSHOW TEXTMERGE
			SELECT 
				emi_ubigeo 
				,emi_razon_social
				,emi_direccion
				,emi_urbanizacion
				,emi_nombre_comercial
			FROM confi_ce
		ENDTEXT 
		
		IF .NOT. EjectSql(cSql, cCurEmi)
			MESSAGEBOX("ERROR al consultar datos de Emisor!!!",gs_app_name)
			RETURN .F.
		ENDIF
		
		SELECT (cCurEmi)
		GO TOP	
		IF RECNO()=0 THEN 
			this.mensaje="No existe registro de Emisor de Facturación electrónica!"
			close_cursor(cCurEmi)
			RETURN .f.
		ENDIF 
		ls_emiubigeo = emi_ubigeo 
		ls_emidir = f_escapar_apostrofes(ALLTRIM(emi_direccion))
		ls_emiurbaniza = f_escapar_apostrofes(ALLTRIM(emi_urbanizacion))
		ls_emirazsoc = f_escapar_apostrofes(ALLTRIM(emi_razon_social))
		ls_eminomcomer = f_escapar_apostrofes(ALLTRIM(emi_nombre_comercial))
		close_cursor(cCurEmi)
		
		cCurName = 'C' + SYS(2015)
		
		TEXT TO  cSql NOSHOW TEXTMERGE
			select 
				vta.tipodoc
				,vta.nser
				,lpad(vta.ndoc, 8, '0')::char(8) as correlativo
				,to_char(vta.fecha, 'YYYYMMDD')::varchar(8) as fechaEmision
				,to_char(vta.fecha + vta.dias::int, 'YYYYMMDD')::varchar(8) as  fecVencimiento
				,(CASE vta.mone WHEN 'S' THEN 'PEN' ELSE 'USD' end)::char(3) as tipoMoneda
				,vta.tipo_vta as tipoVta
				,substring(cl.cod_tipo_doc_ide from 2) as clieTipoDoc
				,cl.num_doc_ident as clieNumDoc
				,cl.nomb as clieRznSocial
				,cl.direccion as clieDireccion
				,cl.email_cpe as clieEmail
				,cl.telefono as clieTelefono	--Ojo
				,cl.codpais::char(2) as clieCodigoPais
				,'<<ls_emiubigeo>>'::varchar(6) as emiUbigeo
				,'<<ls_emidir>>'::varchar(150) as emiDir
				,al.codanexo
				,null::varchar(20) as emiDepartamento
				,null::varchar(20) as emiProvincia
				,null::varchar(20) as emiDistrito
				,'<<ls_emiurbaniza>>'::varchar(80) as emiUrbanizacion
				,'PE'::varchar(2) as emiCodigoPais
				,'<<ls_emirazsoc>>'::varchar(150) as emiRazSocial
				,'<<ls_eminomcomer>>'::varchar(150) as emiNombreComercial
				,(nullif(vta.serg, '') || '-' || nullif(vta.guia, ''))::varchar(15) as nguia
				,vta.total - (vta.mtoexonerado + vta.mtoinafecto + vta.mtoigv) as mtoOperGravadas
				,vta.mtogratuito as mtoOperGratuitas
				,vta.mtoexonerado as mtoOperExoneradas
				,vta.mtoinafecto as mtoOperInafectas
				,vta.mtoigv as mtoIGV
				,vta.total as mtoImpVenta
				,(vta.total - vta.mtoigv)::numeric(12,2) as mtoValVenta
				,vta.vta_amaz
				/* Anticipos */
				,(vta.nsera || '-' || vta.ndoca)::varchar(12) as antiNroDocRel
				,vta.tipodoca as antiTipoDocRel
				,vta.mtoanti as antiTotal
				/*Detracciones */
				,vta.tipo_servicio::varchar(3) as detracCodeBS
				,vta.num_cta_empre::varchar(25) as detracCtaBN
				,vta.porc_detrac::numeric(6,2) as detracPorc
				,vta.monto_detraccion::numeric(14,2) as detracMonto
				,vta.codmedpago::varchar(3) as detracMedioPago
				/*Percepción*/ 
				,vta.reg_perc as PercepRegimen
				,vta.porc_perc as percepFactor
				,vta.total_afecto_perc::numeric(14,2) as percepMtoBase
				,vta.total_perc::numeric(14,2) as percepMto
				/*Factura-Guia*/
				,null::varchar(3) 	as undPesoBruto
				,0::numeric(14,2) 	as pesoBruto
				,null::varchar(2)   as modTraslado
				,null::varchar(8)   as fechaIniTras
				,null::varchar(2) 	as transpTipoDoc
				,null::varchar(11) 	as transpNumDoc
				,null::varchar(100) as transpRznSocial
				,null::varchar(20) 	as transpPlaca
				,null::varchar(2) 	as condTipoDoc
				,null::varchar(20) 	as condNumDoc
				,null::varchar(100) as nomConductor
				,null::varchar(20) 	as transpCodeAuth
				,null::varchar(15) 	as nroLicencia
				,null::varchar(6)   as partidaUbigeo
				,null::varchar(250) as partidaDir
				,null::varchar(6)   as llegadaUbigeo
				,null::varchar(250) as llegadaDir
				,vta.dcto_global as sumDsctoGlobal
				,(CASE WHEN vta.opci='1' THEN 'CREDITO' ELSE 'CONTADO' END)::varchar(10) as condicion
				,vta.codvend
				,ven.nomb as vendedor
				,vta.codzona
				,zo.nomb as zona
				,vta.detalle as obs
				,'S'::char(1) as  imp_con_igv
				,vta.orden_compra
				,''::varchar(15) as pedido
				,''::varchar(10) as reparto
				,''::varchar(6) as secuencia
				,''::char(1) as sello_ivap
				,vta.alma as codsuc
				,al.dire as dir_suc
				,''::varchar(150) as desc_ubig_suc
				,vta.tipodoc2 as tipDocAfectado --20181014 &CGR
				,vta.nser2 as nserAfectado      --20181014 &CGR
				,vta.ndoc2 as ndocAfectado      --20181014 &CGR
				,case vta.tipodoc when '07' then vta.codmoti when '08' then vta.cod_moti_nde else ''end::varchar(80) as  codMotivo	--20181014 &CGR
				,case vta.tipodoc when '07' then nc.nomb when '08' then nd.nomb else ''end::varchar(80) as  desMotivo		--20181014 &CGR
				,usp_numero_letras(total, (select nomb from moneda where codmone = vta.mone))::varchar(250) as importeletras --20181014 &CGR
			from
				venta as vta
				left join motinc nc ON vta.codmoti = nc.codmoti
				left join motind nd ON vta.cod_moti_nde = nd.codmoti
				inner join cliente cl on cl.codclie = vta.codclie
				left join almacen al on al.codalma = vta.alma
				left join condicion co on co.opci = vta.opci
				left join vendedor ven on ven.codvend = vta.codvend
				left join zona zo on zo.codzona = vta.codzona
				left join transportista tra on vta.codtransp=tra.codtransp
				left join conductor cond on vta.codcond=cond.codcond
			where 
				vta.tipodoc = '<<cTipoDoc>>'
				and vta.nser = '<<cNser>>'
				and vta.ndoc = '<<cNdoc>>'
		ENDTEXT
		*_cliptext = cSql
		
		IF EjectSql(cSql, cCurName)
			RETURN cCurName
		ELSE
			RETURN ''
		ENDIF 
	ENDFUNC && obt_cabecera_comprobante

ENDDEFINE 