#Define  cweb "http://companysysven.com/"
#Define  cenviourl "https://companysysven.com/app88/enviofacturasdesktop.php"
Define Class cpesisven As OData Of 'd:\capass\database\data'
	codt = 0
	curlenvio = ""
	curlconsulta = ""
	cose = ""
	urlcdr = ""
	urlcdr = cweb + 'app88/consultarcdrd.php'
	Centidad = ""
	nruc = ""
	usol = ""
	csol = ""
	mostrarmensaje = ""
	niDAUTO = 0
	dfenvio = Date()
	dfi = Date()
	dff = Date()
	confechas = 0
	cTdoc = ""
	Function HayInternet()
	Declare Long InternetGetConnectedState In "wininet.dll" Long lpdwFlags, Long dwReserved
	If InternetGetConnectedState(0, 0) <> 1
		This.Cmensaje = "Sin conexión a Internet"
		Return  0
	Endif
	Return 1
	Endfunc
	Function consultarcdrhost(cTdoc, cnumero, niDAUTO)
	Text To cdata Noshow Textmerge
	{
	 "entidad": "<<this.cose>>",
	 "ruc": "<<this.nruc>>",
	 "usol": "<<this.usol>>",
	 "csol": "<<this.csol>>",
	 "tdoc": "<<ctdoc>>",
	 "ndoc": "<<cnumero>>",
	 "idauto": 0
	 }
	Endtext
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", This.urlcdr, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	If oHTTP.Status <> 200 Then
		This.Cmensaje = "WEB " + Chr(13) + Alltrim(This.urlcdr) + ' No Disponible ' + Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	lcHTML = oHTTP.responseText
*!*		MESSAGEBOX(lcHtml)
	Set Procedure To d:\Librerias\nfJsonRead.prg Additive
	orpta = nfJsonRead(lcHTML)
	If  Vartype(orpta.estado) <> 'U'
		If Left(orpta.estado, 1) = '0' Then
			cdr = orpta.cdr
			crpta = orpta.Mensaje
			If goApp.Grabarxmlbd = 'S' Then
				Text To lC Noshow Textmerge
		         update fe_rcom set rcom_fecd=curdate(),rcom_cdr=?cdr,rcom_mens=?crpta where idauto=<<nidauto>>
				Endtext
			Else
				Text To lC Noshow Textmerge
		         update fe_rcom set rcom_fecd=curdate(),rcom_mens=?crpta where idauto=<<nidauto>>
				Endtext
			Endif
			If This.Ejecutarsql(lC) < 1 Then
				Return 0
			Endif
			If Type('oempresa') = 'U' Then
				crutaxmlcdr	= Addbs(Addbs(Sys(5) + Sys(2003)) + 'SunatXML') + "R-" + fe_gene.nruc + '-' + cTdoc + '-' + Left(cnumero, 4) + '-' + Substr(cnumero, 5, 8) + '.xml'
				carpetacdr = Addbs(Addbs(Sys(5) + Sys(2003)) + 'SunatXML')
			Else
				crutaxmlcdr	= Addbs(Addbs(Addbs(Sys(5) + Sys(2003)) + 'sunatXML') + Alltrim(Oempresa.nruc)) + "R-" + Oempresa.nruc + '-' + cTdoc + '-' + Left(cnumero, 4) + '-' + Substr(cnumero, 5, 8) + '.xml'
				carpetacdr = Addbs(Addbs(Addbs(Sys(5) + Sys(2003)) + 'sunatXML') + Alltrim(Oempresa.nruc))
			Endif
			If !Directory(carpetacdr) Then
				Md (carpetacdr)
			Endif
			Strtofile(cdr, crutaxmlcdr)
			This.Cmensaje = orpta.Mensaje
			Return 1
		Else
			This.Cmensaje = "Estado: " + orpta.estado + Chr(13) + "Mensaje: " + orpta.Mensaje
			Return 0
		Endif
	Else
		This.Cmensaje = lcHTML
		Return 0
	Endif
	Endfunc
	Function consultarcdr(cTdoc, cnumero, niDAUTO)
	Text To cdata Noshow Textmerge
	{
	 "entidad": "<<this.cose>>",
	 "ruc": "<<this.nruc>>",
	 "usol": "<<this.usol>>",
	 "csol": "<<this.csol>>",
	 "tdoc": "<<ctdoc>>",
	 "ndoc": "<<cnumero>>",
	 "idauto": 0
	 }
	Endtext
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", This.urlcdr, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	If oHTTP.Status <> 200 Then
		This.Cmensaje = "WEB " + Chr(13) + Alltrim(This.urlcdr) + ' No Disponible ' + Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	lcHTML = oHTTP.responseText
*!*		MESSAGEBOX(lcHtml)
	Set Procedure To d:\Librerias\nfJsonRead.prg Additive
	orpta = nfJsonRead(lcHTML)
	If  Vartype(orpta.estado) <> 'U'
		If Left(orpta.estado, 1) = '0' Then
			cdr = orpta.cdr
			crpta = orpta.Mensaje
			If goApp.Grabarxmlbd = 'S' Then
				Text To lC Noshow Textmerge
		         update fe_rcom set rcom_fecd=curdate(),rcom_cdr=?cdr,rcom_mens=?crpta where idauto=<<nidauto>>
				Endtext
			Else
				Text To lC Noshow Textmerge
		         update fe_rcom set rcom_fecd=curdate(),rcom_mens=?crpta where idauto=<<nidauto>>
				Endtext
			Endif
			If This.Ejecutarsql(lC) < 1 Then
				Return 0
			Endif
			If Type('oempresa') = 'U' Then
				crutaxmlcdr	= Addbs(Addbs(Sys(5) + Sys(2003)) + 'SunatXML') + "R-" + fe_gene.nruc + '-' + cTdoc + '-' + Left(cnumero, 4) + '-' + Substr(cnumero, 5, 8) + '.xml'
				carpetacdr = Addbs(Addbs(Sys(5) + Sys(2003)) + 'SunatXML')
			Else
				crutaxmlcdr	= Addbs(Addbs(Addbs(Sys(5) + Sys(2003)) + 'sunatXML') + Alltrim(Oempresa.nruc)) + "R-" + Oempresa.nruc + '-' + cTdoc + '-' + Left(cnumero, 4) + '-' + Substr(cnumero, 5, 8) + '.xml'
				carpetacdr = Addbs(Addbs(Addbs(Sys(5) + Sys(2003)) + 'sunatXML') + Alltrim(Oempresa.nruc))
			Endif
			If !Directory(carpetacdr) Then
				Md (carpetacdr)
			Endif
			Strtofile(cdr, crutaxmlcdr)
			This.Cmensaje = orpta.Mensaje
			Return 1
		Else
			This.Cmensaje = "Estado: " + orpta.estado + Chr(13) + "Mensaje: " + orpta.Mensaje
			Return 0
		Endif
	Else
		This.Cmensaje = lcHTML
		Return 0
	Endif
	Endfunc
	Function ConsultaBoletasyNotasporenviar(f1, f2)
	Local lC
	Text To lC Noshow Textmerge
	    SELECT resu_fech,enviados,resumen,resumen-enviados,enviados-resumen
		FROM(SELECT resu_fech,CAST(SUM(enviados) AS DECIMAL(12,2)) AS enviados,CAST(SUM(resumen) AS DECIMAL(12,2))AS resumen FROM(
		SELECT resu_fech,CASE tipo WHEN 1 THEN resu_impo ELSE 0 END AS enviados,
		CASE tipo WHEN 2 THEN resu_impo ELSE 0 END AS Resumen,resu_mens,tipo FROM (
		SELECT resu_fech,resu_impo AS resu_impo,resu_mens,1 AS Tipo FROM fe_resboletas f
		WHERE  resu_fech between '<<f1>>' and '<<f2>>' and f.resu_acti='A' AND LEFT(resu_mens,1)='0'
		UNION ALL
		SELECT fech AS resu_fech,IF(mone='S',impo,impo*dolar) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		WHERE  f.fech between '<<f1>>' and '<<f2>>' and f.acti='A' AND tdoc='03' AND LEFT(ndoc,1)='B' AND f.idcliente>0
		UNION ALL
		SELECT f.fech AS resu_fech,IF(f.mone='S',ABS(f.impo),ABS(f.impo*f.dolar)) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		INNER JOIN fe_ncven g ON g.ncre_idan=f.idauto
		INNER JOIN fe_rcom AS w ON w.idauto=g.ncre_idau
		WHERE  f.fech between '<<f1>>' and '<<f2>>' and f.acti='A' AND f.tdoc IN ('07','08') AND LEFT(f.ndoc,1)='F' AND w.tdoc='03' AND f.idcliente>0 ) AS x)
		AS y GROUP BY resu_fech ORDER BY resu_fech) AS zz  WHERE resumen-enviados>=1
	Endtext
	If This.EJECutaconsulta(lC, 'rbolne') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarticket10(np1)

	Endfunc
	Function ConsultaBoletasyNotasporenviarsinfechas()
	Local lC
	If !Pemstatus(goApp, "cdatos", 5)
		goApp.AddProperty("cdatos", "")
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\    Select resu_fech,enviados,resumen,resumen-enviados,enviados-resumen
	\	From(Select resu_fech,Cast(Sum(enviados) As Decimal(12,2)) As enviados,Cast(Sum(resumen) As Decimal(12,2))As resumen From(
	\	Select resu_fech,Case tipo When 1 Then resu_impo Else 0 End As enviados,
	\	Case tipo When 2 Then resu_impo Else 0 End As resumen,resu_mens,tipo From (
	\	Select resu_fech,resu_impo As resu_impo,resu_mens,1 As tipo From fe_resboletas F
	\	Where  F.resu_acti='A' And Left(resu_mens,1)='0'
	If goApp.Cdatos = 'S' Then
	   \ And resu_codt=<<goApp.tienda>>
	Endif
	\	Union All
	\	Select fech As resu_fech,If(mone='S',Impo,Impo*dolar) As resu_impo,' ' As resu_mens,2 As tipo From fe_rcom F
	\	Where   F.Acti='A' And Tdoc='03' And Left(Ndoc,1)='B' And F.idcliente>0
	If goApp.Cdatos = 'S' Then
	 \And F.codt=<<goApp.tienda>>
	Endif
	\	Union All
	\	Select F.fech As resu_fech,If(F.mone='S',Abs(F.Impo),Abs(F.Impo*F.dolar)) As resu_impo,' ' As resu_mens,2 As tipo From fe_rcom F
	\	INNER Join fe_ncven g On g.ncre_idan=F.Idauto
	\	INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
	\	Where F.Acti='A' And F.Tdoc In ('07','08') And Left(F.Ndoc,1)='F' And w.Tdoc='03' And F.idcliente>0
	If goApp.Cdatos = 'S' Then
	 \And F.codt=<<goApp.tienda>>
	Endif
	\) As x)
	\ As Y Group By resu_fech Order By resu_fech) As zz  Where resumen-enviados>=1
	Set Textmerge Off
	Set Textmerge  To
	If This.EJECutaconsulta(lC, 'rbolne') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarguiasxenviar(Ccursor)
	Text To lC Noshow Textmerge
	    SELECT guia_fech,guia_ndoc,"" AS cliente,razon,motivo,idauto as idguia,v.nruc,ticket FROM
        (SELECT guia_idgui AS idauto,guia_ndoc,'V' AS motivo,guia_fech,t.razon,guia_tick AS ticket  FROM  fe_guias AS g
         INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr
         WHERE LEFT(guia_mens,1)<>'0' AND LEFT(guia_ndoc,1)='T' AND guia_moti='V' AND guia_acti='A' AND LEFT(guia_deta,7)<>'Anulada'
         UNION ALL
         SELECT guia_idgui AS idauto,guia_ndoc,'D' AS motivo,guia_fech,t.razon,guia_tick AS ticket   FROM  fe_guias AS g
         INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr
         WHERE LEFT(guia_mens,1)<>'0' AND LEFT(guia_ndoc,1)='T' AND guia_moti='D' AND guia_acti='A'
         UNION ALL
         SELECT guia_idgui AS idauto,guia_ndoc,'C' AS motivo,guia_fech,t.razon,guia_tick AS ticket   FROM  fe_guias AS g
         INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr
         WHERE  LEFT(guia_mens,1)<>'0' AND LEFT(guia_ndoc,1)='T' AND guia_moti='C' AND guia_acti='A'
         UNION ALL
         SELECT guia_idgui AS idauto,guia_ndoc,'N' AS motivo,guia_fech,t.razon,guia_tick AS ticket   FROM  fe_guias AS g
         INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr
         WHERE  LEFT(guia_mens,1)<>'0' AND LEFT(guia_ndoc,1)='T' AND guia_moti='N' AND guia_acti='A'
         UNION ALL
         SELECT guia_idgui AS idauto,guia_ndoc,'T' AS Motivo,guia_fech,t.razon,guia_tick AS ticket   FROM fe_guias AS a
         INNER JOIN fe_tra AS t ON t.idtra=a.guia_idtr,fe_gene  AS g
         WHERE LEFT(guia_ndoc,1)='T' AND  LEFT(guia_mens,1)<>'0' AND guia_moti='T' AND guia_acti='A')AS w,fe_gene AS v
         ORDER BY guia_ndoc,guia_fech
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarguiasxenviaralpharmaco(Ccursor)
	Text To lC Noshow Textmerge
	   SELECT fech,ndoc,cliente,Transportista,idguia,motivo,ticket FROM
          (SELECT fech,ndoc,cliente,Transportista,idguia,'V' AS motivo,guia_tick AS ticket FROM  vguiasventas
           WHERE LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T'
           UNION ALL
           SELECT guia_fech AS guia_fech,guia_ndoc AS ndoc,c.razo AS cliente,t.razon AS transportista,guia_idgui AS idguia,guia_moti AS motivo,
           guia_tick AS ticket FROM fe_guias AS g
           INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr
           INNER JOIN fe_clie AS c ON c.idclie=g.`guia_idcl`
           WHERE  guia_acti='A' AND LEFT(guia_mens,1)<>'0' AND guia_moti='v'
           UNION ALL
           SELECT fech,ndoc,cliente,Transportista,idguia,'D' AS motivo,guia_tick AS ticket FROM  vguiasdevolucion
           WHERE LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T'
           UNION ALL
           SELECT fech,ndoc,cliente,Transportista,idguia,'C' AS motivo,guia_tick AS ticket FROM  vguiasrcompras
           WHERE  LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T'
           UNION ALL
           SELECT guia_fech AS fech,guia_ndoc AS ndoc,c.razo AS cliente,t.razon AS Transportista,guia_idgui AS idguia,'N' AS motivo,guia_tick FROM  fe_guias
            AS g
            INNER JOIN fe_clie AS c ON c.idclie=g.guia_idcl
            INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr
            WHERE  LEFT(guia_mens,1)<>'0' AND LEFT(guia_ndoc,1)='T' AND guia_moti='N' AND guia_acti='A'
           UNION ALL
           SELECT guia_fech AS fech,guia_ndoc AS ndoc,g.empresa AS cliente,t.razon AS Transportista,
           guia_idgui AS idguia,'T' AS Motivo,guia_tick  AS ticket FROM fe_guias AS a
           INNER JOIN fe_tra AS t ON t.idtra=a.guia_idtr,fe_gene  AS g
           WHERE LEFT(guia_ndoc,1)='T'  AND  LEFT(guia_mens,1)<>'0' AND guia_moti='T' AND guia_acti='A')AS w
           GROUP BY fech,ndoc,cliente,Transportista,idguia,motivo,ticket  ORDER BY fech,ndoc
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarguiasxenviarxtienda(Ccursor)
	Text To lC Noshow Textmerge
	       SELECT fech,ndoc,cliente,Transportista,idguia,motivo,ticket FROM
          (SELECT fech,ndoc,cliente,Transportista,idguia,'V' AS motivo,guia_tick as ticket FROM  vguiasventas
           WHERE LEFT(ndoc,1)<>'S' AND LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T' and guia_codt=<<this.codt>>
           UNION ALL
           SELECT fech,ndoc,cliente,Transportista,idguia,'D' AS motivo,guia_tick as ticket FROM  vguiasdevolucion
           WHERE LEFT(ndoc,1)<>'S' AND LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T'  and guia_codt=<<this.codt>>
           UNION ALL
           SELECT fech,ndoc,cliente,Transportista,idguia,'C' AS motivo,guia_tick as ticket FROM  vguiasrcompras
           WHERE LEFT(ndoc,1)<>'S' AND LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T'  and guia_codt=<<this.codt>>
           UNION ALL
           SELECT guia_fech AS fech,guia_ndoc AS ndoc,g.empresa AS cliente,IFNULL(t.razon,'') AS Transportista,
           guia_idgui AS idguia,'T' AS Motivo,guia_tick  as ticket FROM fe_guias AS a
           LEFT JOIN fe_tra AS t ON t.idtra=a.guia_idtr,fe_gene  AS g
           WHERE LEFT(guia_ndoc,1)='T'  AND  LEFT(guia_mens,1)<>'0' AND guia_moti='T' AND guia_acti='A'  and guia_codt=<<this.codt>>)AS w
           GROUP BY fech,ndoc,cliente,Transportista,idguia,motivo,ticket  ORDER BY fech,ndoc
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function descargarxmldesdedata(carfile, nid)
	Local lC
	Text To lC Noshow Textmerge
       CAST(rcom_xml as char) as rcom_xml,CAST(rcom_cdr as char) as rcom_cdr FROM fe_rcom WHERE idauto=<<nid>>
	Endtext
	If EJECutaconsulta(lC, 'filess') < 1 Then
		Return
	Endif
	cdr = "R-" + carfile
	If Type('oempresa') = 'U' Then
		crutaxml	= Addbs(Sys(5) + Sys(2003) + '\Firmaxml') + carfile
		crutaxmlcdr	= Addbs(Sys(5) + Sys(2003) + '\SunatXML') + cdr
	Else
		crutaxml	= Addbs(Sys(5) + Sys(2003) + '\Firmaxml\' + Alltrim(Oempresa.nruc)) + carfile
		crutaxmlcdr	= Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc)) + cdr
	Endif
	If File(crutaxml) Then
	Else
		If !Isnull(filess.rcom_xml) Then
			cxml = filess.rcom_xml
			Strtofile(cxml, crutaxml)
		Else
			This.Cmensaje = "No se puede Obtener el Archivo XML de Envío " + carfile
		Endif
	Endif
	cdr = "R-" + carfile
	If File(crutaxmlcdr) Then
	Else
		If !Isnull(filess.rcom_cdr) Then
			cdrxml = filess.rcom_cdr
			Strtofile(cdrxml, crutaxmlcdr)
		Else
			This.Cmensaje = "No se puede Obtener el Archivo CDR"
		Endif
	Endif

	Endfunc
	Function descargarxmlguiadesdedata(carfile, nid)
	Local lC
	Text To lC Noshow Textmerge
       CAST(guia_xml AS CHAR) AS guia_xml,CAST(guia_cdr AS CHAR) AS guia_cdr FROM fe_guias WHERE guia_idgui=<<nid>>
	Endtext
	If EJECutaconsulta(lC, 'filess') < 1 Then
		Return
	Endif
	cdr = "R-" + carfile
	If Type('oempresa') = 'U' Then
		crutaxml	= Addbs(Sys(5) + Sys(2003)) + 'Firmaxml\' + carfile
		crutaxmlcdr	= Addbs(Sys(5) + Sys(2003) + '\SunatXML\') + cdr
	Else
		crutaxml	= Addbs(Sys(5) + Sys(2003)) + 'Firmaxml\' + Alltrim(Oempresa.nruc) + "\" + carfile
		crutaxmlcdr	= Addbs(Sys(5) + Sys(2003)) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\" + cdr
	Endif
	If File(crutaxml) Then
	Else
		If !Isnull(filess.guia_xml) Then
			cxml = filess.guia_xml
			Strtofile(cxml, crutaxml)
		Else
			This.Cmensaje = "No se puede Obtener el Archivo XML de Envío"
		Endif
	Endif
	cdr = "R-" + carfile
	If File(crutaxmlcdr) Then
	Else
		If !Isnull(filess.guia_cdr) Then
			cdrxml = filess.guia_cdr
			Strtofile(cdrxml, crutaxmlcdr)
		Else
			This.Cmensaje = "No se puede Obtener el Archivo XML de Respuesta"
		Endif
	Endif
	Endfunc
	Function ConsultarCPE
	Lparameters LcRucEmisor, lcUser_Sol, lcPswd_Sol, ctipodcto, Cserie, cnumero, pk
	Local ArchivoRespuestaSunat As "MSXML2.DOMDocument.6.0"
	Local loXMLBody As "MSXML2.DOMDocument.6.0"
	Local loXMLResp As "MSXML2.DOMDocument.6.0"
	Local loXmlHttp As "MSXML2.ServerXMLHTTP.6.0"
	Local oShell As "Shell.Application"
	Local res As "MSXML2.DOMDocument.6.0"
	Local lcEnvioXML, lcURL, lcUserName, lsURL, ls_pwd_sol, ls_ruc_emisor, ls_user
	Declare Integer CryptBinaryToString In Crypt32;
		String @pbBinary, Long cbBinary, Long dwFlags, ;
		String @pszString, Long @pcchString

	Declare Integer CryptStringToBinary In Crypt32;
		String @pszString, Long cchString, Long dwFlags, ;
		String @pbBinary, Long @pcbBinary, ;
		Long pdwSkip, Long pdwFlags

	#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056
	If !Pemstatus(goApp, "ose", 5)
		goApp.AddProperty("ose", "")
	Endif
	If !Pemstatus(goApp, "Grabarxmlbd", 5)
		goApp.AddProperty("Grabarxmlbd", "")
	Endif
	loXmlHttp  = Createobject("MSXML2.ServerXMLHTTP.6.0")
	loXMLBody  = Createobject("MSXML2.DOMDocument.6.0")
	crespuesta = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc) + '-' + ctipodcto + '-' + Cserie + '-' + cnumero + '.zip'
	Do Case
	Case goApp.ose = "nubefact"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://demo-ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'moddatos'
			ls_user		  = ls_ruc_emisor + 'MODDATOS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor = LcRucEmisor
			ls_pwd_sol	  = lcPswd_Sol
*!*				ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
			ls_user		  = LcRucEmisor + lcUser_Sol

		Endcase
		Text To lcEnvioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
		   <soapenv:Envelope xmlns:ser="http://service.sunat.gob.pe" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
					xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
		   <soapenv:Header>
				<wsse:Security>
					<wsse:UsernameToken>
							<wsse:Username><<ls_user>></wsse:Username>
			                <wsse:Password><<ls_pwd_sol>></wsse:Password>
					</wsse:UsernameToken>
				</wsse:Security>
			</soapenv:Header>
		   <soapenv:Body>
		      <ser:getStatusCdr>
		         <rucComprobante><<LcRucEmisor>></rucComprobante>
		         <tipoComprobante><<ctipodcto>></tipoComprobante>
		         <serieComprobante><<cserie>></serieComprobante>
				 <numeroComprobante><<cnumero>></numeroComprobante>
		      </ser:getStatusCdr>
		   </soapenv:Body>
		</soapenv:Envelope>
		Endtext
		If Not loXMLBody.LoadXML( lcEnvioXML )
			Error loXMLBody.parseError.reason
			This.Cmensaje = loXMLBody.parseError.reason
			Return - 1
		Endif
		loXmlHttp.Open( "POST", lsURL, .F. )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
		loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
		loXmlHttp.setRequestHeader( "SOAPAction", "getStatusCdr" )
		loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
		loXmlHttp.Send(loXMLBody.documentElement.XML)
		If loXmlHttp.Status # 200 Then
			cerror	  = Nvl(loXmlHttp.responseText, '')
			crpta	  = Strextract(cerror, '<faultstring>', '</faultstring>', 1)
			CMensaje1 = Strextract(cerror, "<message>", "</message>", 1)
			If Vartype(mostramensaje) = 'L'
				This.Cmensaje = crpta + ' ' + Alltrim(CMensaje1)
			Endif
			Return - 1
		Endif
		loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
		loXMLResp.LoadXML(loXmlHttp.responseText)
		CmensajeError	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultcode>", "</faultcode>")
		CMensajeMensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultstring>", "</faultstring>")
		CMensajedetalle	= leerXMl(Alltrim(loXmlHttp.responseText), "<detail>", "</detail>")
		Cnumeromensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<statusCode>", "</statusCode>")
		CMensaje1		= leerXMl(Alltrim(loXmlHttp.responseText), "<message>", "</message>")
		If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Or Cnumeromensaje <> '0' Then
			If Vartype(mostramensaje) = 'L'
				This.Cmensaje = (Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle) + ' ' + Alltrim(CMensaje1))
			Endif
			Return 0
		Endif
		ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
		ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
		TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//content")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
	Case goApp.ose = "bizlinks"
		loXmlHttp = Createobject("MSXML2.XMLHTTP.6.0")
		loXMLBody = Createobject("MSXML2.DOMDocument.6.0")
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://osetesting.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'TESTBIZLINKS'
			ls_user		  = Alltrim(fe_gene.nruc) + 'BIZLINKS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
		cnum = Right("00000000" + Alltrim(cnumero), 8)
		Text To lcEnvioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe">
		<SOAP-ENV:Header xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
		<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
		<wsse:UsernameToken>
	    <wsse:Username><<ls_user>></wsse:Username>
		<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText"><<ls_pwd_sol>></wsse:Password></wsse:UsernameToken>
		</wsse:Security>
		</SOAP-ENV:Header>
		   <soapenv:Body>
		      <ser:getStatusCdr>
		         <!--Optional:-->
		         <statusCdr>
		            <!--Optional:-->
		             <numeroComprobante><<cnum>></numeroComprobante>
		            <!--Optional:-->
		             <rucComprobante><<LcRucEmisor>></rucComprobante>
		            <!--Optional:-->
		             <serieComprobante><<cserie>></serieComprobante>
		            <!--Optional:-->
		            	 <tipoComprobante><<ctipodcto>></tipoComprobante>
		         </statusCdr>
		      </ser:getStatusCdr>
		   </soapenv:Body>
		</soapenv:Envelope>
		Endtext
		If Not loXMLBody.LoadXML( lcEnvioXML )
			Error loXMLBody.parseError.reason
			Return - 1
		Endif

		loXmlHttp.Open( "POST", lsURL, .F. )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
		loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
		loXmlHttp.setRequestHeader( "SOAPAction", "urn:getStatusCdr" )
*loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
		loXmlHttp.Send(loXMLBody.documentElement.XML)
		If loXmlHttp.Status # 200 Then
			cerror	  = Nvl(loXmlHttp.responseText, '')
			crpta	  = Strextract(cerror, '<faultstring>', '</faultstring>', 1)
			CMensaje1 = Strextract(cerror, "<detail>", "</detail>", 1)
			This.Cmensaje = crpta + ' ' + Alltrim(CMensaje1)
			Return - 1
		Endif
		loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
		loXMLResp.LoadXML(loXmlHttp.responseText)
		CmensajeError	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultcode>", "</faultcode>")
		CMensajeMensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultstring>", "</faultstring>")
		CMensajedetalle	= leerXMl(Alltrim(loXmlHttp.responseText), "<detail>", "</detail>")
		Cnumeromensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<statusCode>", "</statusCode>")
		CMensaje1		= leerXMl(Alltrim(loXmlHttp.responseText), "<statusMessage>", "</statusMessage>")
		If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Then
			If Vartype(mostramensaje) = 'L'
				This.Cmensaje = Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle) + ' ' + Alltrim(CMensaje1)
			Endif
			Return 0
		Endif
		ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
		ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
		TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//document")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
	Case goApp.ose = "efact"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL   = "https://ose-gw1.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'iGje3Ei9GN'
			ls_user		  = ls_ruc_emisor
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
		Text To lcEnvioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe">
		  <soapenv:Header>
		   <wsse:Security soapenv:mustUnderstand="0" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
		      <wsse:UsernameToken>
		       <wsse:Username><<ls_user>></wsse:Username>
			   <wsse:Password><<ls_pwd_sol>></wsse:Password>
		      </wsse:UsernameToken>
		   </wsse:Security>
		   </soapenv:Header>
		   <soapenv:Body>
		      <ser:getStatusCdr>
		             <rucComprobante><<LcRucEmisor>></rucComprobante>
			       	 <tipoComprobante><<ctipodcto>></tipoComprobante>
			      	 <serieComprobante><<cserie>></serieComprobante>
			         <numeroComprobante><<cnumero>></numeroComprobante>
		      </ser:getStatusCdr>
		   </soapenv:Body>
		</soapenv:Envelope>
		Endtext
		If Not loXMLBody.LoadXML( lcEnvioXML )
			Error loXMLBody.parseError.reason
			Return - 1
		Endif

		loXmlHttp.Open( "POST", lsURL, .F. )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
		loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
		loXmlHttp.setRequestHeader( "SOAPAction", "urn:getStatusCdr" )
		loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
		loXmlHttp.Send(loXMLBody.documentElement.XML)
		If loXmlHttp.Status # 200 Then
			cerror	  = Nvl(loXmlHttp.responseText, '')
			crpta	  = Strextract(cerror, '<faultstring>', '</faultstring>', 1)
			CMensaje1 = Strextract(cerror, "<detail>", "</detail>", 1)
			This.Cmensaje = crpta + ' ' + Alltrim(CMensaje1)
			Return - 1
		Endif
		loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
		loXMLResp.LoadXML(loXmlHttp.responseText)
		CmensajeError	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultcode>", "</faultcode>")
		CMensajeMensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultstring>", "</faultstring>")
		CMensajedetalle	= leerXMl(Alltrim(loXmlHttp.responseText), "<detail>", "</detail>")
		Cnumeromensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<statusCode>", "</statusCode>")
		CMensaje1		= leerXMl(Alltrim(loXmlHttp.responseText), "<statusMessage>", "</statusMessage>")
		If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Then
			If Vartype(mostramensaje) = 'L'
				This.Cmensaje = (Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle) + ' ' + Alltrim(CMensaje1))
			Endif
			Return 0
		Endif
		ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
		ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
		TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//document")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
	Case goApp.ose = "conastec"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://test.conose.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'moddatos'
			ls_user		  = ls_ruc_emisor + 'MODDATOS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://prod.conose.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
		Text To lcEnvioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe">
		  <soapenv:Header>
			<wsse:Security   xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
			<wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
			<wsse:Username><<ls_user>></wsse:Username>
			<wsse:Password><<ls_pwd_sol>></wsse:Password>
			</wsse:UsernameToken>
			</wsse:Security>
			</soapenv:Header>
			   <soapenv:Body>
			      <ser:getStatusCdr>
			         <!--Optional:-->
			         <rucComprobante><<LcRucEmisor>></rucComprobante>
			         <!--Optional:-->
			       	 <tipoComprobante><<ctipodcto>></tipoComprobante>
			         <!--Optional:-->
			      	 <serieComprobante><<cserie>></serieComprobante>
			         <numeroComprobante><<cnumero>></numeroComprobante>
			      </ser:getStatusCdr>
			   </soapenv:Body>
			</soapenv:Envelope>
		Endtext
		If Not loXMLBody.LoadXML( lcEnvioXML )
			Error loXMLBody.parseError.reason
			Return - 1
		Endif
		loXmlHttp.Open( "POST", lsURL, .F. )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
		loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
		loXmlHttp.setRequestHeader( "SOAPAction", "urn:getStatusCdr" )
		loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )

		loXmlHttp.Send(loXMLBody.documentElement.XML)
		If loXmlHttp.Status # 200 Then
			cerror = Nvl(loXmlHttp.responseText, '')
			crpta  = Strextract(cerror, '<faultstring>', '</faultstring>', 1)
			This.Cmensaje = crpta
			Return - 1
		Endif
		loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
		loXMLResp.LoadXML(loXmlHttp.responseText)
		CmensajeError	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultcode>", "</faultcode>")
		CMensajeMensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultstring>", "</faultstring>")
		CMensajedetalle	= leerXMl(Alltrim(loXmlHttp.responseText), "<detail>", "</detail>")
		Cnumeromensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<statusCode>", "</statusCode>")
		CMensaje1		= leerXMl(Alltrim(loXmlHttp.responseText), "<statusMessage>", "</statusMessage>")
		If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Or Cnumeromensaje <> '0004' Then
			If Vartype(mostramensaje) = 'L'
				This.Cmensaje = Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle) + ' ' + Alltrim(CMensaje1)
			Endif
			Return 0
		Endif
		ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
		ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
		TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//content")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
	Case Empty(goApp.ose)
		Local ArchivoRespuestaSunat As "MSXML2.DOMDocument.6.0"
		Local loXMLBody As "MSXML2.DOMDocument.6.0"
		Local loXMLResp As "MSXML2.DOMDocument.6.0"
		Local loXmlHttp As "MSXML2.ServerXMLHTTP.6.0"
		Local oShell As "Shell.Application"
		Local lC, lcEnvioXML, lcURL, lcUserName
		Declare Integer CryptBinaryToString In Crypt32;
			String @pbBinary, Long cbBinary, Long dwFlags, ;
			String @pszString, Long @pcchString
		Declare Integer CryptStringToBinary In Crypt32;
			String @pszString, Long cchString, Long dwFlags, ;
			String @pbBinary, Long @pcbBinary, ;
			Long pdwSkip, Long pdwFlags

		#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056
		loXmlHttp = Createobject("MSXML2.ServerXMLHTTP.6.0")
		loXMLBody = Createobject("MSXML2.DOMDocument.6.0")
		lcUserName = LcRucEmisor + lcUser_Sol
		lcURL	   = "https://e-factura.sunat.gob.pe/ol-it-wsconscpegem/billConsultService"



		crespuesta = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc) + '-' + ctipodcto + '-' + Cserie + '-' + cnumero + '.zip'
		Text To lcEnvioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
	<soapenv:Envelope xmlns:ser="http://service.sunat.gob.pe"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
	<soapenv:Header>
	<wsse:Security>
	<wsse:UsernameToken>
	<wsse:Username><<lcUsername>></wsse:Username>
	<wsse:Password><<lcPswd_Sol>></wsse:Password>
	</wsse:UsernameToken>
	</wsse:Security>
	</soapenv:Header>
	<soapenv:Body>
	<ser:getStatusCdr>
	<rucComprobante><<LcRucEmisor>></rucComprobante>
	<tipoComprobante><<ctipodcto>></tipoComprobante>
	<serieComprobante><<cserie>></serieComprobante>
	<numeroComprobante><<cnumero>></numeroComprobante>
	</ser:getStatusCdr>
	</soapenv:Body>
	</soapenv:Envelope>
		Endtext

		If Not loXMLBody.LoadXML( lcEnvioXML )
			Error loXMLBody.parseError.reason
			Return - 1
		Endif

		loXmlHttp.Open( "POST", lcURL, .F. )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=utf-8" )
		loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
		loXmlHttp.setRequestHeader( "SOAPAction", "getStatusCdr" )
		loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
		loXmlHttp.Send(loXMLBody.documentElement.XML)
		If loXmlHttp.Status # 200 Then
			cerror = Nvl(loXmlHttp.responseText, '')
			crpta  = Strextract(cerror, '<faultstring>', '</faultstring>', 1)
			This.Cmensaje = crpta
			Return - 1
		Endif
		loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
		loXMLResp.LoadXML(loXmlHttp.responseText)
		CmensajeError	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultcode>", "</faultcode>")
		CMensajeMensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultstring>", "</faultstring>")
		CMensajedetalle	= leerXMl(Alltrim(loXmlHttp.responseText), "<detail>", "</detail>")
		Cnumeromensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<statusCode>", "</statusCode>")
		CMensaje1		= leerXMl(Alltrim(loXmlHttp.responseText), "<message>", "</message>")
		If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Or Cnumeromensaje <> '0' Then
			If Vartype(mostrarmensaje) = 'L' Then
				This.Cmensaje = (Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle) + ' ' + Alltrim(CMensaje1))
			Endif
			Return 0
		Endif
		ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
		ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
		txtCod = loXMLResp.selectSingleNode("//statusCode")  &&Return
		txtMsg = loXMLResp.selectSingleNode("//statusMessage")  &&Return

		If txtCod.Text <> "0004"  Then
			If Vartype(mostrarmensaje) = 'L' Then
				This.Cmensaje = Alltrim(txtCod.Text) + ' ' + Alltrim(txtMsg.Text)
			Endif
			Return - 1
		Endif
		TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//content")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
	Endcase
	If Vartype(TxtB64) <> 'O' Then
		This.Cmensaje = "No se puede LEER el Contenido del Archivo XML de SUNAT"
		Return 0
	Endif
	crptaxmlcdr = 'R-' + Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc) + '-' + ctipodcto + '-' + Cserie + '-' + cnumero + '.XML'
	If Type('oempresa') = 'U' Then
		cnombre	  = Addbs(Sys(5) + Sys(2003) + '\SunatXml') + crespuesta
		cDirDesti = Addbs( Sys(5) + Sys(2003) + '\SunatXML')
		cfilerpta = Addbs( Sys(5) + Sys(2003) + '\SunatXML') + crptaxmlcdr
	Else
		cnombre	  = Addbs(Sys(5) + Sys(2003) + '\SunatXml\' + Alltrim(Oempresa.nruc)) + crespuesta
		cDirDesti = Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc))
		cfilerpta = Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc)) + crptaxmlcdr
	Endif
	If !Directory(cDirDesti) Then
		Md (cDirDesti)
	Endif
	If File(cfilerpta) Then
		Delete File(cfilerpta)
	Endif
	decodefile(TxtB64.Text, cnombre)
	oShell	  = Createobject("Shell.Application")
	cfilerpta = "R"
	For Each oArchi In oShell.NameSpace(cnombre).Items
		If Left(oArchi.Name, 1) = 'R' Then
			oShell.NameSpace(cDirDesti).CopyHere(oArchi)
			cfilerpta = Juststem(oArchi.Name) + '.XML'
		Endif
	Endfor
	If Type('oempresa') = 'U' Then
		rptaSunat = LeerRespuestaSunat(Sys(5) + Sys(2003) + '\SunatXML\' + cfilerpta)
		cfilecdr  = Sys(5) + Sys(2003) + '\SunatXML\' + cfilerpta
	Else
		rptaSunat = LeerRespuestaSunat(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\" + cfilerpta)
		cfilecdr  = Sys(5) + Sys(2003) + '\SunatXML\' + + Alltrim(Oempresa.nruc) + "\" + cfilerpta
	Endif
	If Len(Alltrim(rptaSunat)) > 100 Then
		This.Cmensaje = rptaSunat
		Return 0
	Endif
	Do Case
	Case Left(rptaSunat, 1) = '0'
		If goApp.Grabarxmlbd = 'S' Then
			cdrxml = Filetostr(cfilecdr)
			cdrxml  =  ""
			Text  To lC Noshow Textmerge
                  UPDATE fe_rcom SET rcom_mens='<<rptaSunat>>',rcom_cdr='<<cdrxml>>' WHERE idauto=<<pk>>
			Endtext
		Else
			Text  To lC Noshow Textmerge
                  UPDATE fe_rcom SET rcom_mens='<<rptaSunat>>' WHERE idauto=<<pk>>
			Endtext
		Endif
		If  This.Ejecutarsql(lC) < 1 Then
			Return 0
		Endif
		This.Cmensaje = rptaSunat
		Return 1
	Case Empty(rptaSunat)
		If Vartype(mostramensaje) = 'L' Then
			This.Cmensaje = rptaSunat
		Endif
		Return 0
	Otherwise
		If Vartype(mostramensaje) = 'L' Then
			This.Cmensaje = rptaSunat
		Endif
		Return 0
	Endcase
	Endfunc
	Function Actualizarestadoenviocpe()
	fenvio = Cfechas(This.dfenvio)
	Text  To lC Noshow Textmerge
    UPDATE fe_rcom SET rcom_mens='<<this.cmensaje>>',rcom_fecd='<<fenvio>>' WHERE idauto=<<this.nidauto>>
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpeporenviar(Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\    Select a.Ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	\    a.igv,a.Impo,If(mone='S','Soles','Dólares') As Moneda,u.nomb,a.fusua,a.Tdoc,a.Ndoc,Idauto,a.idcliente,b.clie_corr,
	\    ndo2,b.fono,nruc,tcom,Tdoc,a.vigv,a.mone,a.rcom_arch,rcom_hash
	\    From fe_rcom As a
	\    Join fe_clie As b On (a.idcliente=b.idclie)
	\    Join fe_usua u On u.idusua=a.idusua
	\    Where a.Acti='A' And Left(Ndoc,1) In ('F') And Left(rcom_mens,1)<>'0' And  Impo<>0 And a.Tdoc='01'
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\    Union All
	\    Select a.Ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	\    a.igv,a.Impo,If(a.mone='S','Soles','Dólares') As Moneda,u.nomb,a.fusua,a.Tdoc,a.Ndoc,a.Idauto,a.idcliente,b.clie_corr,
	\    a.ndo2,b.fono,nruc,a.tcom,w.Tdoc,a.vigv,a.mone,a.rcom_arch,a.rcom_hash
	\    From fe_rcom As a
	\    Join fe_clie As b On (a.idcliente=b.idclie)
	\    Join fe_usua u On u.idusua=a.idusua
	\    INNER Join fe_ncven g On g.ncre_idan=a.Idauto
	\    INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
    \    Where a.Acti='A' And Left(a.Ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0'  And a.Impo<>0  And w.Tdoc='01' And a.Tdoc In("07","08")
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
    \Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	ENDFUNC
	Function consultarcpeporenviarlista(Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\    Select a.Ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	\    a.igv,a.Impo,If(mone='S','Soles','Dólares') As Moneda,u.nomb,a.fusua,a.Tdoc,a.Ndoc,Idauto,a.idcliente,b.clie_corr,
	\    ndo2,b.fono,nruc,tcom,Tdoc,a.vigv,a.mone,a.rcom_arch,rcom_hash
	\    From fe_rcom As a
	\    Join fe_clie As b On (a.idcliente=b.idclie)
	\    Join fe_usua u On u.idusua=a.idusua
	\    Where a.Acti='A' And Left(Ndoc,1) In ('F') And Left(rcom_mens,1)<>'0' And  Impo<>0 And a.Tdoc='01' and datediff(curdate(),a.fech)>=VAL(goapp.Diasenviocpe) and DATEDIFF(CURDATE(),a.fech)<=MAXDIASENVIO
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\    Union All
	\    Select a.Ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	\    a.igv,a.Impo,If(a.mone='S','Soles','Dólares') As Moneda,u.nomb,a.fusua,a.Tdoc,a.Ndoc,a.Idauto,a.idcliente,b.clie_corr,
	\    a.ndo2,b.fono,nruc,a.tcom,w.Tdoc,a.vigv,a.mone,a.rcom_arch,a.rcom_hash
	\    From fe_rcom As a
	\    Join fe_clie As b On (a.idcliente=b.idclie)
	\    Join fe_usua u On u.idusua=a.idusua
	\    INNER Join fe_ncven g On g.ncre_idan=a.Idauto
	\    INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
    \    Where a.Acti='A' And Left(a.Ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0'  And a.Impo<>0  And w.Tdoc='01' And a.Tdoc In("07","08")
    \   and datediff(curdate(),a.fech)>=VAL(goapp.Diasenviocpe) and DATEDIFF(CURDATE(),a.fech)<=MAXDIASENVIO
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
    \Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpexenviarxmsys(Ccursor)
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\    Select a.Ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	\    a.igv,a.Impo,rcom_hash,rcom_mens,rcom_arch,mone,a.Tdoc,Idauto,b.ndni,b.clie_corr,
	\    nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As Direccion,tcom,Tdoc,a.vigv,rcom_dsct,Ndoc,a.rcom_carg
	\    From fe_rcom As a
	\    Join fe_clie As b On (a.idcliente=b.idclie)
	\    Where a.Acti<>'I' And Left(Ndoc,1) In ('F') And Left(rcom_mens,1)<>'0'  And nruc<>"***********" And a.Tdoc='01'
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\    Union All
	\    Select a.Ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	\    a.igv,a.Impo,a.rcom_hash,a.rcom_mens,a.rcom_arch,a.mone,a.Tdoc,a.Idauto,b.ndni,b.clie_corr,
	\    nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As Direccion,a.tcom,w.Tdoc,a.vigv,a.rcom_dsct,a.Ndoc,a.rcom_carg
	\    From fe_rcom As a
	\    INNER Join fe_clie As b On (a.idcliente=b.idclie)
    \    INNER Join fe_ncven g On g.ncre_idan=a.Idauto
	\    INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
    \    Where a.Acti<>'I' And Left(a.Ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0'  And  nruc<>"***********" And w.Tdoc='01' And a.Tdoc In("07","08")
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
    \Order By fech,dcto
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpexenviarpsysw(Ccursor)
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select a.Ndoc As dcto, a.fech, b.razo,If(a.mone='S','Soles','Dólares') As Moneda, a.valor, a.rcom_exon, rcom_otro,
	\a.igv, a.Impo, rcom_hash, u.nomb, a.fusua, rcom_mens, rcom_arch, mone, a.Tdoc, a.Ndoc, dolar, Idauto, b.ndni, a.idcliente, b.clie_corr,
	\ndo2, b.fono, nruc, Concat(Trim(b.Dire), ' ', Trim(b.ciud)) As Direccion, tcom, Tdoc, a.vigv
	\From fe_rcom As a
	\Join fe_clie As b On (a.idcliente = b.idclie)
	\Join fe_usua u On u.idusua = a.idusua
	\Where a.Acti <> 'I' And Left(Ndoc, 1) In ('F') And Left(rcom_mens, 1) <> '0'   And a.Tdoc = '01' And b.nruc<>'***********' And (a.Impo <> 0 Or a.rcom_otro <> 0)
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\Union All
	\Select a.Ndoc As dcto, a.fech, b.razo,If(a.mone='S','Soles','Dólares') As Moneda, a.valor, a.rcom_exon, a.rcom_otro,
	\a.igv, a.Impo, a.rcom_hash, u.nomb, a.fusua, a.rcom_mens, a.rcom_arch, a.mone, a.Tdoc, a.Ndoc, a.dolar, a.Idauto, b.ndni, a.idcliente, b.clie_corr,
	\a.ndo2, b.fono, nruc, Concat(Trim(b.Dire), ' ', Trim(b.ciud)) As Direccion, a.tcom, w.Tdoc, a.vigv
	\From fe_rcom As a
	\INNER Join fe_clie As b On (a.idcliente = b.idclie)
	\INNER Join fe_usua u On u.idusua = a.idusua
	\INNER Join fe_ncven g On g.ncre_idan = a.Idauto
	\INNER Join fe_rcom As w On w.Idauto = g.ncre_idau
	\Where a.Acti <> 'I' And Left(a.Ndoc, 1) In ('F') And Left(a.rcom_mens, 1) <> '0' And (a.Impo <> 0 Or a.rcom_otro <> 0)  And w.Tdoc = '01' And a.Tdoc In("07", "08")
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\Order By fech, Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpexenviarpsysu(Ccursor)
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select a.Ndoc As dcto,a.fech,b.razo,If(a.mone='S','Soles','Dólares') As Moneda,a.valor,a.rcom_exon,rcom_otro,
    \a.igv,a.Impo,rcom_mens,rcom_arch,mone,a.Tdoc,a.Ndoc,dolar,Idauto,b.ndni,a.idcliente,b.clie_corr,
    \ndo2,nruc,tcom,Tdoc,rcom_hash
    \From fe_rcom As a
    \INNER Join fe_clie As b On (a.idcliente=b.idclie)
    \Where  a.Acti<>'I' And Left(Ndoc,1) In ('F') And Left(rcom_mens,1)<>'0' And (Impo<>0 Or rcom_otro>0)  And a.Tdoc='01'
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	If This.codt > 0 Then
	\  And a.codt=<<This.codt>>
	Endif
    \Union All
    \Select a.Ndoc As dcto,a.fech,b.razo,If(a.mone='S','Soles','Dólares') As Moneda,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
    \a.igv,a.Impo,a.rcom_mens,a.rcom_arch,a.mone,a.Tdoc,a.Ndoc,a.dolar,a.Idauto,b.ndni,a.idcliente,b.clie_corr,
    \a.ndo2,nruc,a.tcom,w.Tdoc,a.rcom_hash
    \From fe_rcom As a Join fe_clie As b On (a.idcliente=b.idclie)
    \INNER Join fe_ncven g On g.ncre_idan=a.Idauto
    \INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
    \Where a.Acti<>'I' And Left(a.Ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0'  And a.Impo<>0  And w.Tdoc='01' And a.Tdoc In("07","08")
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	If This.codt > 0 Then
	\  And a.codt=<<This.codt>>
	Endif
    \Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpexenviarpsys(Ccursor)
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\    Select a.Ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,rcom_otro,
	\    a.igv,a.Impo,If(mone='S','Soles','Dólares') As moneda,rcom_hash,rcom_mens,rcom_arch,mone,a.Tdoc,a.Ndoc,dolar,Idauto,b.ndni,a.idcliente,b.clie_corr,
	\    ndo2,b.fono,nruc,a.tcom
	\    From fe_rcom As a
	\    INNER Join fe_clie As b On (a.idcliente=b.idclie)
	\    Where  a.Acti<>'I' And Left(Ndoc,1) In ('F') And Left(rcom_mens,1)<>'0' And (Impo<>0 Or rcom_otro>0) And a.Tdoc='01' And  b.nruc<>"***********"
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\    Union All
	\    Select a.Ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,rcom_otro,
	\    a.igv,a.Impo,IF(a.mone='S','Soles','Dólares') As moneda,a.rcom_hash,a.rcom_mens,a.rcom_arch,a.mone,a.Tdoc,a.Ndoc,a.dolar,a.Idauto,b.ndni,a.idcliente,b.clie_corr,
	\    ndo2,b.fono,nruc,a.tcom
	\    From fe_rcom As a
	\    INNER Join fe_clie As b On (a.idcliente=b.idclie)
	\    INNER Join fe_rven As rv On rv.Idauto=a.Idauto
	\    INNER Join fe_refe F On F.idrven=rv.idrven
	\    INNER Join fe_tdoc As w On w.idtdoc=F.idtdoc
	\    Where  a.Acti<>'I'  And Left(a.Ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0' And  b.nruc<>"***********"   And w.Tdoc='01'
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\ Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpexenviarxsysg(Ccursor)
	If !Pemstatus(goApp, 'periodo', 5) Then
		AddProperty(goApp, 'periodo', 0)
	Endif
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\ Select a.Ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	\    a.igv,a.Impo,u.nomb,a.fusua,If(mone='S','Soles','Dólares') As Moneda,a.Ndoc,Idauto,a.idcliente,b.clie_corr,
	\    ndo2,b.fono,nruc,tcom,a.Tdoc,a.vigv,a.mone,a.rcom_arch,rcom_hash,a.Tdoc
	\    From fe_rcom As a
	\    Join fe_clie As b On (a.idcliente=b.idclie)
	\    Join fe_usua u On u.idusua=a.idusua
	\    Where a.Acti='A' And Left(Ndoc,1) In ('F') And Left(rcom_mens,1)<>'0' And  Impo<>0 And a.Tdoc='01'
	If goApp.Periodo > 0 Then
	   \ And Year(a.fech)>=<<goApp.Periodo>>
	Endif
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\    Union All
	\    Select a.Ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	\    a.igv,a.Impo,u.nomb,a.fusua,If(a.mone='S','Soles','Dólares') As Moneda,a.Ndoc,a.Idauto,a.idcliente,b.clie_corr,
	\    a.ndo2,b.fono,nruc,a.tcom,a.Tdoc,a.vigv,a.mone,a.rcom_arch,a.rcom_hash,w.Tdoc
	\    From fe_rcom As a
	\    Join fe_clie As b On (a.idcliente=b.idclie)
	\    Join fe_usua u On u.idusua=a.idusua
	\    INNER Join fe_ncven g On g.ncre_idan=a.Idauto
	\    INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
    \    Where a.Acti='A' And Left(a.Ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0' And a.Impo<>0  And w.Tdoc='01' And a.Tdoc In("07","08")
	If goApp.Periodo > 0 Then
	   \ And Year(a.fech)>=<<goApp.Periodo>>
	Endif
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
    \ Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpexenviarxsys3(Ccursor)
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select a.Ndoc As dcto,a.fech,b.razo,a.mone,a.valor,a.rcom_exon,rcom_otro,rcom_inaf As inafecto,
    \a.igv,a.Impo,rcom_arch,a.Tdoc,a.Ndoc,dolar,Idauto,b.ndni,a.idcliente,b.clie_corr,
    \ndo2,b.fono,nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As Direccion,tcom,Tdoc
    \From fe_rcom As a
    \INNER Join fe_clie As b On (a.idcliente=b.idclie)
    \Where  a.Acti<>'I' And Left(Ndoc,1) In ('F') And Left(rcom_mens,1)<>'0'  And (Impo<>0 Or rcom_otro>0)  And a.Tdoc='01'
	If This.confechas = 1 Then
	   \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
    \Union All
    \Select a.Ndoc As dcto,a.fech,b.razo,a.mone,a.valor,a.rcom_exon,a.rcom_otro,a.rcom_inaf As inafecto,
    \a.igv,a.Impo,a.rcom_arch,a.Tdoc,a.Ndoc,a.dolar,a.Idauto,b.ndni,a.idcliente,b.clie_corr,
    \a.ndo2,b.fono,nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As Direccion,a.tcom,w.Tdoc
    \From fe_rcom As a
    \INNER Join fe_clie As b On (a.idcliente=b.idclie)
    \INNER Join fe_ncven g On g.ncre_idan=a.Idauto
    \INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
    \Where a.Acti<>'I' And Left(a.Ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0'   And a.Impo<>0  And w.Tdoc In('01','07','08') And a.Tdoc In("07","08")
	If This.confechas = 1 Then
	   \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	    \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\ Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpexenviarxsys5(Ccursor)
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select  a.Ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	\	    a.igv,a.Impo,rcom_hash,rcom_mens,rcom_arch,mone,a.Tdoc,a.Ndoc,dolar,Idauto,b.ndni,a.idcliente,b.clie_corr,
	\	    ndo2,b.fono,nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As Direccion,tcom,Tdoc
	\	    From fe_rcom As a
	\	    INNER Join fe_clie As b On (a.idcliente=b.idclie)
	\	    Where  a.Acti<>'I' And Left(Ndoc,1) In ('F') And Left(rcom_mens,1)<>'0'
	\	    And valor<>0 And igv<>0 And Impo<>0 And a.Tdoc='01' And a.codt=<<This.codt>>
	\	    Union All
	\	    Select a.Ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	\	    a.igv,a.Impo,a.rcom_hash,a.rcom_mens,a.rcom_arch,a.mone,a.Tdoc,a.Ndoc,a.dolar,a.Idauto,b.ndni,a.idcliente,b.clie_corr,
	\	    a.ndo2,b.fono,nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As Direccion,a.tcom,w.Tdoc
	\	    From fe_rcom As a
	\	    INNER Join fe_clie As b On (a.idcliente=b.idclie)
	\	    INNER Join fe_ncven g On g.ncre_idan=a.Idauto
	\	    INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
	\       Where a.Acti<>'I' And Left(a.Ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0'
	\	    And a.Impo<>0  And w.Tdoc='01' And a.Tdoc In("07","08") And a.codt=<<This.codt>>
	If This.confechas = 1 Then
	   \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	    \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\ Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function EnviarSunat()
	If This.consultarcpeporenviarlista("rmvtos") < 1 Then
		Return 0
	Endif
	enviado = ""
	Set Classlib To d:\Envio\fe.vcx Additive
	ocomp = Createobject("comprobante")
	Select rmvtos
	Go Top
	Do While !Eof()
		If enviado <> 'S' Then
			ocomp.Version = "2.1"
			ocomp.Condetraccion = goApp.Vtascondetraccion
			Do Case
			Case rmvtos.Tdoc = '01'
				If rmvtos.vigv = 1 Then
					If rmvtos.tcom = 'S' Then
						vdne = ocomp.obtenerdatosfacturaexoneradaotros(rmvtos.Idauto)
					Else
						ocomp.Gironegocio = "Grifo"
						vdne = ocomp.obtenerdatosfacturaexonerada(rmvtos.Idauto)
					Endif
				Else
					If rmvtos.tcom = 'S' Then
						vdne = ocomp.obtenerdatosfacturaotros(rmvtos.Idauto)
					Else
						ocomp.Gironegocio = "Grifo"
						vdne = ocomp.obtenerdatosfactura(rmvtos.Idauto)
					Endif
				Endif
			Case rmvtos.Tdoc = '07'
				If rmvtos.vigv = 1 Then
					vdne = ocomp.Obtenerdatosnotecreditoexonerada(rmvtos.Idauto, 'E')
				Else
					vdne = ocomp.obtenerdatosnotascredito(rmvtos.Idauto, 'E')
				Endif
			Case rmvtos.Tdoc = '08'
				If rmvtos.vigv = 1 Then
					vdne = ocomp.obtenernotasdebitoexonerada(rmvtos.Idauto, 'E')
				Else
					vdne = ocomp.obtenerdatosnotasDebito(rmvtos.Idauto, 'E')
				Endif
			Endcase
		Endif
		Select rmvtos
		Skip
	Enddo
	Endfunc
	Function Test()
	Text To lC Noshow
	  select empresa FROM fe_gene WHERE idgene=1
	Endtext
	If This.EJECutaconsulta(lC, 'test') < 1 Then
		Return 0
	Endif
	This.Cmensaje = Test.Empresa
	Return 1
	Endfunc
	Function consultarcpexenviarpsysn(Ccursor)
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	 \   Select a.Ndoc As dcto,a.fech,b.razo,If(a.mone="S","Soles","Dólares") As Moneda,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	 \   a.igv,a.Impo,rcom_mens,rcom_arch,mone,a.Tdoc,a.Ndoc,dolar,Idauto,b.ndni,a.idcliente,b.clie_corr,
	 \   ndo2,b.fono,nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As Direccion,tcom,Tdoc,rcom_hash
	 \   From fe_rcom As a
	 \   INNER Join fe_clie As b On (a.idcliente=b.idclie)
	 \   Where Year(a.fech)>=2018  And
	 \   a.Acti<>'I' And Left(Ndoc,1) In ('F') And Left(rcom_mens,1)<>'0' And  Impo<>0 And a.Tdoc='01'
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	 \   Union All
	  \  Select a.Ndoc As dcto,a.fech,b.razo,If(a.mone="S","Soles","Dólares") As Moneda,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	  \  a.igv,a.Impo,a.rcom_mens,a.rcom_arch,a.mone,a.Tdoc,a.Ndoc,a.dolar,a.Idauto,b.ndni,a.idcliente,b.clie_corr,
	  \  a.ndo2,b.fono,nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As Direccion,a.tcom,w.Tdoc,a.rcom_hash
	  \  From fe_rcom As a
	  \  INNER Join fe_clie As b On (a.idcliente=b.idclie)
	  \  INNER Join fe_ncven g On g.ncre_idan=a.Idauto
	  \  INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
      \  Where a.Acti<>'I' And Left(a.Ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0'
      \  And a.Impo<>0  And w.Tdoc='01' And a.Tdoc In("07","08")
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\ Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpexenviarpsysg(Ccursor)
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select a.Ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	\    a.igv,a.Impo,a.fusua,rcom_mens,rcom_arch,mone,a.Tdoc,a.Ndoc,dolar,Idauto,b.ndni,a.idcliente,b.clie_corr,
	\    ndo2,b.fono,nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As Direccion,tcom,Tdoc,rcom_hash
	\    From fe_rcom As a Join fe_clie As b On (a.idcliente=b.idclie)
	\    Where a.Acti<>'I' And Left(Ndoc,1) In ('F') And Left(rcom_mens,1)<>'0'  And Impo<>0 And a.Tdoc='01'
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\    Union All
	\    Select a.Ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	\    a.igv,a.Impo,a.usua,a.rcom_mens,a.rcom_arch,a.mone,a.Tdoc,a.Ndoc,a.dolar,a.Idauto,b.ndni,a.idcliente,b.clie_corr,
	\    a.ndo2,b.fono,nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As Direccion,a.tcom,w.Tdoc,a.rcom_hash
	\    From fe_rcom As a
	\    Join fe_clie As b On (a.idcliente=b.idclie)
	\    INNER Join fe_ncven g On g.ncre_idan=a.Idauto
	\    INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
    \    Where a.Acti<>'I' And Left(a.Ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0'   And a.Impo<>0  And w.Tdoc='01' And a.Tdoc In("07","08")
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
    \Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpexenviarpsysl(Ccursor)
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\    Select a.Ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,rcom_otro,
	\    a.igv,a.Impo,rcom_hash,rcom_mens,rcom_arch,mone,a.Tdoc,a.Ndoc,dolar,Idauto,b.ndni,a.idcliente,b.clie_corr,
	\    ndo2,b.fono,nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As Direccion,tcom,Tdoc
	\    From fe_rcom As a
	\    INNER Join fe_clie As b On (a.idcliente=b.idclie)
	\    Where  a.Acti<>'I' And Left(Ndoc,1) In ('F') And Left(rcom_mens,1)<>'0'  And  (Impo<>0 Or rcom_otro>0)   And a.Tdoc='01'
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\    Union All
	\    Select a.Ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,a.rcom_otro,
	\    a.igv,a.Impo,a.rcom_hash,a.rcom_mens,a.rcom_arch,a.mone,a.Tdoc,a.Ndoc,a.dolar,a.Idauto,b.ndni,a.idcliente,b.clie_corr,
	\    a.ndo2,b.fono,nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As Direccion,a.tcom,w.Tdoc
	\    From fe_rcom As a
	\    INNER Join fe_clie As b On (a.idcliente=b.idclie)
	\    INNER Join fe_ncven g On g.ncre_idan=a.Idauto
	\    INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
    \   Where a.Acti<>'I' And Left(a.Ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0'
	\    And w.Tdoc='01' And a.Tdoc In("07","08")
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpexreimprimir()
	Endfunc
	Function consultarcpexenviarpsystr(Ccursor)
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select a.Ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,rcom_otro,
	\a.igv,a.Impo,rcom_mens,rcom_arch,mone,a.Tdoc,a.Ndoc,dolar,Idauto,b.ndni,a.idcliente,b.clie_corr,
    \ndo2,b.fono,nruc,tcom,a.vigv,Tdoc,rcom_hash
    \From fe_rcom As a
	\Join fe_clie As b On (a.idcliente=b.idclie)
	\Where  a.Acti<>'I' And Left(Ndoc,1) In ('F') And Left(rcom_mens,1)<>'0'   And a.Tdoc='01'  And  (Impo<>0 Or rcom_otro>0)
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And a.codt=<<goApp.tienda>>
		Else
	      \And a.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	If This.confechas = 1 Then
		\ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	   \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\Union All
	\Select a.Ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,a.rcom_otro,
	\a.igv,a.Impo,a.rcom_mens,a.rcom_arch,a.mone,a.Tdoc,a.Ndoc,a.dolar,a.Idauto,b.ndni,a.idcliente,b.clie_corr,
	\a.ndo2,b.fono,nruc,a.tcom,a.vigv,w.Tdoc,a.rcom_hash
	\From fe_rcom As a
	\Join fe_clie As b On (a.idcliente=b.idclie)
	\INNER Join fe_ncven g On g.ncre_idan=a.Idauto
	\INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
	\Where a.Acti<>'I' And Left(a.Ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0'  And w.Tdoc='01' And a.Tdoc In("07","08") And nruc<>'***********'
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      \And a.codt=<<goApp.tienda>>
		Else
	      \And a.codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
	If This.confechas = 1 Then
		\ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	   \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\ Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function descargarxmlguiadesdedata(carfile, nid)
	Text To lC Noshow Textmerge
       select CAST(guia_xml AS CHAR) AS guia_xml,CAST(guia_cdr AS CHAR) AS guia_cdr FROM fe_guias WHERE guia_idgui=<<nid>>
	Endtext
	If This.EJECutaconsulta(lC, 'filess') < 1 Then
		Return 0
	Endif
	cdr = "R-" + carfile
	If Type('oempresa') = 'U' Then
		crutaxml	= Addbs(Addbs(Sys(5) + Sys(2003)) + 'Firmaxml') + carfile
		crutaxmlcdr	= Addbs(Addbs(Sys(5) + Sys(2003)) + 'SunatXML') + cdr
	Else
		crutaxml	= Addbs(Addbs(Addbs(Sys(5) + Sys(2003)) + 'Firmaxml') + Alltrim(Oempresa.nruc)) + carfile
		crutaxmlcdr	= Addbs(Addbs(Addbs(Sys(5) + Sys(2003)) + 'SunatXML') + Alltrim(Oempresa.nruc)) + cdr
	Endif
	This.Cmensaje = ""
	If File(crutaxml) Then
*ocomx.ArchivoXml=Addbs(Sys(5)+Sys(2003)+'\FirmaXML\')+carfile
	Else
		If !Isnull(filess.guia_xml) Then
			cxml = filess.guia_xml
			Strtofile(cxml, crutaxml)
		Else
			This.Cmensaje = "No se puede Obtener el Archivo XML de Envío"
		Endif
	Endif
	cdr = "R-" + carfile
	If File(crutaxmlcdr) Then

	Else
		If !Isnull(filess.guia_cdr) Then
			cdrxml = filess.guia_cdr
			Strtofile(cdrxml, crutaxmlcdr)
		Else
			This.Cmensaje = "No se puede Obtener el Archivo XML de Envío"
		Endif
	Endif
	Return 1
	Endfunc
	Function verificarbajasxanular(Ccursor)
	Text To lC Noshow
         SELECT r.tdoc as Tipo_dcto,r.ndoc as Numero_Dcto,r.fech as fecha,f.baja_fech as fecha_Baja,
		 c.nruc as Ruc,c.ndni as DNI,c.razo as cliente,r.valor as valor_gravado,r.igv,r.impo as Importe,baja_idau FROM fe_bajas f
		 inner join fe_rcom r on r.idauto=f.baja_idau
		 inner join fe_clie as c on c.idclie=r.idcliente
		 where (r.acti='A' or  length(Trim(baja_mens))=0)  order by ndoc;
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function consultarfacturaxenviar(pkid, Ccursor)
	If !Pemstatus(goApp, 'proyecto', 5) Then
		AddProperty(goApp, 'proyecto', '')
	Endif
	Set Textmerge On
	Set  Textmerge To Memvar lC Noshow Textmerge
       \ Select  r.Idauto,r.Ndoc,r.Tdoc,r.fech As dFecha,r.mone,valor,Cast(0 As Decimal(12,2)) As inafectas,Cast(0 As Decimal(12,2)) As gratificaciones,
       \ Cast(0 As Decimal(12,2)) As exoneradas,'10' As Tigv,vigv,v.rucfirmad,v.razonfirmad,ndo2,v.nruc As rucempresa,v.Empresa,v.Ubigeo,
	   \ v.ptop,v.ciudad,v.distrito,c.nruc,'6' As tipodoc,c.razo,Concat(Trim(c.Dire),' ',Trim(c.ciud)) As Direccion,c.ndni,rcom_otro,kar_cost As costoRef,Deta,
	   \ 'PE' As pais,r.igv,Cast(0 As Decimal(12,2)) As tdscto,Cast(0 As Decimal(12,2)) As Tisc,Impo,Cast(0 As Decimal(12,2)) As montoper,k.Incl,
	   \ Cast(0 As Decimal(12,2)) As totalpercepcion,k.cant,k.Prec,Left(r.Ndoc,4) As Serie,Substr(r.Ndoc,5) As numero,a.Unid,a.Descri,k.idart As Coda,
	   \ IFNULL(unid_codu,'NIU')As unid1,s.codigoestab,r.Form,v.gene_cert,v.Clavecertificado As clavecerti,v.Gene_usol,v.gene_csol
	If Alltrim(Lower(goApp.Proyecto)) == 'psys' Then
	      \,r.rcom_ocom
	Endif
	   \ From fe_rcom r
	   \ INNER Join fe_clie c On c.idclie=r.idcliente
	   \ INNER Join fe_kar k On k.Idauto=r.Idauto
	   \ INNER Join fe_art a On a.idart=k.idart
	   \ INNER Join fe_sucu s On s.idalma=r.codt
	   \ Left Join fe_unidades As u On u.unid_codu=a.Unid, fe_gene As v
	   \ Where r.Idauto=<<pkid>> And r.Acti='A' And k.Acti='A'
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function generaCorrelativoEnvioResumenBoletas()
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If goApp.Cdatos = 'S' Then
		Text To lC Noshow Textmerge
	    UPDATE fe_sucu as f SET gene_nres=f.gene_nres+1 WHERE idalma=<<goapp.tienda>>
		Endtext
	Else
		Text To lC Noshow Textmerge
	     UPDATE fe_gene  as f SET gene_nres=f.gene_nres+1 WHERE idgene=1
		Endtext
	Endif
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpepsysg(np1, np2, np3, Ccursor)
	Do Case
	Case np2 = '01' Or np2 = '03' Or np2 = '20'
		If np3 = 'S' Then
			Text To lC Noshow Textmerge
			  	select 4 as codv,c.idauto,0 as idart,CAST(if(detv_item=1,detv_cant,0) as decimal(12,2)) as cant,if(detv_item=1,detv_prec,0) as prec,c.codt as alma,
          		c.tdoc as tdoc1,
			    c.ndoc as dcto,c.fech as fech1,c.vigv,c.valor,c.igv,
			    c.fech,c.fecr,c.form,c.rcom_exon,c.ndo2,c.igv,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,
          		c.pimpo,u.nomb as usuario,c.deta,
			    c.tdoc,c.ndoc,c.dolar as dola,c.mone,m.detv_desc as descri,'' as Unid,
          		c.rcom_hash,'Oficina' as nomv,c.impo,rcom_arch,c.rcom_icbper,CAST(0 as decimal(6,2)) as icbper,c.rcom_vimp
          		FROM fe_rcom as c 
          		inner join fe_clie as d on(d.idclie=c.idcliente)
			    inner join fe_usua as u on u.idusua=c.idusua   
			    inner join fe_detallevta as m on m.detv_idau=c.idauto
          		where c.idauto=<<np1>> group by descri order by detv_ite1
			Endtext
		Else
			Text To lC Noshow Textmerge
			    select  a.codv,a.idauto,a.alma,a.idkar,a.idauto,a.idart,a.cant,a.prec,a.alma,c.tdoc as tdoc1,
			    c.ndoc as dcto,c.fech as fech1,c.vigv,c.valor,c.igv,c.rcom_vimp,
			    c.fech,c.fecr,c.form,c.deta,c.rcom_exon,c.ndo2,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,c.pimpo,u.nomb as usuario,
			    c.tdoc,c.ndoc,c.dolar as dola,c.mone,b.descri,a.kar_unid as unid,c.rcom_hash,v.nomv,c.impo,c.rcom_arch,c.rcom_icbper,kar_icbper as icbper
			    FROM fe_art as b 
			    inner join fe_kar as a on(b.idart=a.idart)
			    inner join fe_vend as v on v.idven=a.codv  
			    inner JOIN fe_rcom as c on(a.idauto=c.idauto) 
			    inner join fe_clie as d on(c.idcliente=d.idclie)
			    inner join fe_usua as u on u.idusua=c.idusua
			    where c.idauto=<<np1>> and a.acti='A';
			Endtext
		Endif
	Case np2 = '08'
		Text To lC Noshow Textmerge
			   select r.idauto,r.ndoc,r.tdoc,r.fech,r.mone,abs(r.valor) as valor,r.ndo2,
		       r.vigv,c.nruc,c.razo,c.dire,c.ciud,c.ndni,' ' as nomv,r.form,r.rcom_vimp,
		       abs(r.igv) as igv,abs(r.impo) as impo,ifnull(k.cant,CAST(1 as decimal(12,2))) as cant,
		       ifnull(k.prec,ABS(r.impo)) as prec,LEFT(r.ndoc,4) as serie,SUBSTR(r.ndoc,5) as numero,
		       ifnull(k.kar_unid,'') as unid,ifnull(a.descri,r.deta) as descri,r.deta,ifnull(k.idart,CAST(0 as decimal(8))) as idart,w.ndoc as dcto,
		       w.fech as fech1,w.tdoc as tdoc1,r.rcom_hash,u.nomb as usuario,r.rcom_arch,r.rcom_icbper,kar_icbper as icbper
		       from fe_rcom r 
		       inner join fe_clie c on c.idclie=r.idcliente
		       left join fe_kar k on k.idauto=r.idauto 
		       left join fe_art a on a.idart=k.idart
		       inner join fe_ncven f on f.ncre_idan=r.idauto 
		       inner join fe_rcom as w on w.idauto=f.ncre_idau
		       inner join fe_usua as u on u.idusua=r.idusua
		       where r.idauto=<<np1>> and r.acti='A' and r.tdoc='08'
		Endtext
	Case np2 = '07'
		Text To lC Noshow Textmerge
			   select r.idauto,r.ndoc,r.tdoc,r.fech,r.mone,abs(r.valor) as valor,r.ndo2,r.rcom_vimp,
		       r.vigv,c.nruc,c.razo,c.dire,c.ciud,c.ndni,' ' as nomv,r.form,u.nomb as usuario,
		       abs(r.igv) as igv,abs(r.impo) as impo,ifnull(k.cant,CAST(1 as decimal(12,2))) as cant,
		       ifnull(k.prec,ABS(r.impo)) as prec,LEFT(r.ndoc,4) as serie,SUBSTR(r.ndoc,5) as numero,
		       ifnull(k.kar_unid,'') as unid,ifnull(a.descri,r.deta) as descri,r.deta,ifnull(k.idart,CAST(0 as decimal(8))) as idart,w.ndoc as dcto,
		       w.fech as fech1,w.tdoc as tdoc1,r.rcom_hash,r.rcom_arch,r.rcom_icbper,kar_icbper as icbper
		       from fe_rcom r 
		       inner join fe_clie c on c.idclie=r.idcliente
		       left join fe_kar k on k.idauto=r.idauto 
		       left join fe_art a on a.idart=k.idart
		       inner join fe_ncven f on f.ncre_idan=r.idauto 
		       inner join fe_rcom as w on w.idauto=f.ncre_idau
		       inner join fe_usua as u on u.idusua=r.idusua
		       where r.idauto=<<np1>> and r.acti='A' and r.tdoc='07'
		Endtext
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If rcom_vimp >= 2 Then
		Return 2
	Endif
	Return 1
	Endfunc
	Function nroimpresion(niDAUTO)
	Text To lC Noshow Textmerge
       UPDATE fe_rcom SET rcom_vimp=rcom_vimp+1 WHERE idauto=<<nidauto>>
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpexenviarpsysm(Ccursor)
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \    Select a.Ndoc As dcto,a.fech,b.razo,If(a.mone='S','Soles','Dólares') As Moneda,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	\    a.igv,a.Impo,rcom_mens,rcom_arch,mone,a.Tdoc,a.Ndoc,dolar,Idauto,b.ndni,a.idcliente,b.clie_corr,
	\    ndo2,b.fono,nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As Direccion,tcom,Tdoc,rcom_hash
	\    From fe_rcom As a
    \	 INNER Join fe_clie As b On (a.idcliente=b.idclie)
	\    Where a.Acti<>'I' And Left(Ndoc,1) In ('F') And Left(rcom_mens,1)<>'0'
	\    And valor<>0 And igv<>0 And Impo<>0 And a.Tdoc='01'
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\    Union All
	\    Select a.Ndoc As dcto,a.fech,b.razo,If(a.mone='S','Soles','Dólares') As Moneda,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	\    a.igv,a.Impo,a.rcom_mens,a.rcom_arch,a.mone,a.Tdoc,a.Ndoc,a.dolar,a.Idauto,b.ndni,a.idcliente,b.clie_corr,
    \    a.ndo2,b.fono,nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As Direccion,a.tcom,w.Tdoc,a.rcom_hash
	\    From fe_rcom As a
	\    INNER Join fe_clie As b On (a.idcliente=b.idclie)
    \	 INNER Join fe_ncven g On g.ncre_idan=a.Idauto
	\    INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
    \    Where a.Acti<>'I' And Left(a.Ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0'
	\    And a.valor<>0 And a.igv<>0 And a.Impo<>0  And w.Tdoc='01' And a.Tdoc In("07","08")
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\ Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpexenviarpsysr(Ccursor)
	f1 = Cfechas(This.dfi)
	f2 = Cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select a.Ndoc As dcto,a.fech,b.razo,If(a.mone='S','Soles','Dólares') As Moneda,a.valor,a.rcom_exon,rcom_otro,
    \a.igv,a.Impo,rcom_mens,rcom_arch,mone,a.Tdoc,a.Ndoc,dolar,Idauto,b.ndni,a.idcliente,b.clie_corr,
	\ndo2,tcom,Tdoc,rcom_dsct,vigv,a.rcom_hash,b.nruc
	\From fe_rcom As a
	\Join fe_clie As b On (a.idcliente=b.idclie)
	\Where  a.Acti<>'I' And Left(Ndoc,1) In ('F') And Left(rcom_mens,1)<>'0'
	\And (a.Impo<>0 Or a.rcom_otro>0) And a.Tdoc='01' And a.fech>="2018-01-01"
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\Union All
	\Select a.Ndoc As dcto,a.fech,b.razo,If(a.mone='S','Soles','Dólares') As Moneda,a.valor,a.rcom_exon,a.rcom_otro,
	\a.igv,a.Impo,a.rcom_mens,a.rcom_arch,a.mone,a.Tdoc,a.Ndoc,a.dolar,a.Idauto,b.ndni,a.idcliente,b.clie_corr,
	\a.ndo2,a.tcom,w.Tdoc,a.rcom_dsct,a.vigv,a.rcom_hash,b.nruc
	\From fe_rcom As a
	\Join fe_clie As b On (a.idcliente=b.idclie)
	\INNER Join fe_ncven g On g.ncre_idan=a.Idauto
	\INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
	\Where a.Acti<>'I' And Left(a.Ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0'
	\And (a.Impo<>0 Or a.rcom_otro>0) And w.Tdoc='01' And a.Tdoc In("07","08") And a.fech>="2018-01-01"
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\Order By fech,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function enviarfacturasunatdesdeservidor(Ccursor, objfe)

	If !Pemstatus(goApp, 'ose', 5) Then
		AddProperty(goApp, 'ose', '')
	Endif
	Select (Ccursor)
	nxml = rucempresa + '-01-' + Left(Ndoc, 4) + '-' + Substr(Ndoc, 5) + '.xml'
	Set Procedure To d:\Librerias\nfjsoncreate, d:\Librerias\nfcursortojson.prg, ;
		d:\Librerias\nfcursortoobject, d:\Librerias\nfJsonRead.prg, ;
		d:\Librerias\_.prg  Additive
*!*		cdata = nfcursortojson(.T.)
	Obj = Createobject("empty")
	With _(m.Obj)
		.Moneda = m.objfe.Moneda
		.tgratificaciones = Val(m.objfe.tgratificaciones)
		.tgrabadas = Val(m.objfe.tgrabadas)
		.Tinafectas = Val(m.objfe.Tinafectas)
		.texoneradas = Val(m.objfe.texoneradas)
		.codigolocal = m.objfe.codigolocal
		.tipotributo = m.objfe.tipotributo
		.tipoafectoigv = m.objfe.tipoafectoigv
		.Formadepago = m.objfe.Formadepago
		If m.objfe.Formadepago = 'C' Then
			.cuotas = .newList()
			For m.i = 1 To Alen(m.objfe.Nrocuotas, 1)
				With .newItemFor( 'cuotas' )
					.cuota = Val(m.objfe.Nrocuotas[m.i, 2])
					.Fechavto = m.objfe.Nrocuotas[m.i, 3]
				Endwith
			Next
		Endif
		.nporretencion = 0
		.Montoretencion = Val(m.objfe.Montoretencion)
		.Porcentajeretencion = Val(m.objfe.Porcentajeretencion)
		.Totalcredito = Val(m.objfe.Totalcredito)
		.icbper = Val(m.objfe.icbper)
		.Tdoc = m.objfe.Tdoc
		.Tigv = m.objfe.Tigv
		.vigv = 1 + (Val(m.objfe.vigv) / 100)
		.Importe = m.objfe.Importe
		.fechaemision = m.objfe.fechaemision
		.Ndoc = m.objfe.Ndoc
		.rucfirma = m.objfe.rucfirma
		.nombrefirmadigital = m.objfe.nombrefirmadigital
		.rucemisor = m.objfe.rucemisor
		.razonsocialempresa = m.objfe.razonsocialempresa
		.Ubigeo = m.objfe.Ubigeo
		.direccionempresa = m.objfe.direccionempresa
		.ciudademisor = m.objfe.ciudademisor
		.distritoemisor = m.objfe.distritoemisor
		.GuiaRemision = m.objfe.GuiaRemision
		.ruccliente = m.objfe.ruccliente
		.tipodctocliente = m.objfe.tipodctocliente
		.nombrecliente = m.objfe.nombrecliente
		.direccioncliente = m.objfe.direccioncliente
		.pais = m.objfe.pais
		.totalIgv = Val(m.objfe.totalIgv)
		.totaldscto = Val(m.objfe.totaldscto)
		.tdetraccion = 0
		.Tisc = Val(m.objfe.Tisc)
		.subtotal = Val(m.objfe.subtotal)
		.Totaldcto = Val(m.objfe.Totaldcto)
		.montopercepcion = Val(m.objfe.montopercepcion)
		.totaldocpercepcion = Val(m.objfe.totaldocpercepcion)
		.Gironegocio = m.objfe.Gironegocio
		.Entidad = Iif(Empty(goApp.ose), 'sunat', goApp.ose)
		.PlacaVehiculo = m.objfe.PlacaVehiculo
		.Certificado = m.objfe.Certificado
		.Clavecertificado = objfe.Clavecertificado
		.usol = m.objfe.usol
		.tdetraccion = 0
		.Clavesol = m.objfe.Clavesol
		.lista = .newList()
		Scan All
			With .newItemFor( 'lista' )
				.Unid = Unid
				.Precio = Prec
				.Descri = Descri
				.Coda = Coda
				.cant = cant
				.costo = costoRef
			Endwith
		Endscan
	Endwith
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'json.json'
	Strtofile(nfjsoncreate(m.Obj, .T.), rutajson)
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("POST", cenviourl, .F.)
	oHTTP.setRequestHeader("Content-Type ", "application/json")
	oHTTP.Send(nfjsoncreate(m.Obj, .T.))
	If oHTTP.Status <> 200 Then
		This.Cmensaje = "Servicio " + Alltrim(cenviourl) + " NO Disponible....." + Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	lcHTML = oHTTP.responseText
*!*		MESSAGEBOX(lcHTML)
	conerror = 0
	Try
		orpta = nfJsonRead(lcHTML)
	Catch To loException
		This.Cmensaje = lcHTML
		conerror = 1
	Endtry
	If conerror = 0 Then
		If  Vartype(orpta) <> 'U' Then
			This.Cmensaje = Alltrim(orpta.rpta)
*!*				wait WINDOW ALLTRIM(LEFT(this.cmensaje,200))
			If Left(orpta.rpta, 1) = '0' Then
*!*					XML = orpta.XML
*!*					cdr = orpta.cdr
				crpta = Alltrim(orpta.rpta)
				Text To lC Noshow Textmerge
		          update fe_rcom set rcom_fecd=curdate(),rcom_mens='<<crpta>>' where idauto=<<this.niDAUTO>>
				Endtext
				If This.Ejecutarsql(lC) < 1 Then
					Return 0
				Endif
				This.Cmensaje = orpta.rpta
				Return 1
			Else
				This.Cmensaje = Left(Alltrim(orpta.rpta), 200)
				Return 0
			Endif
		Else
			This.Cmensaje = Left(Alltrim(lcHTML), 200)
			Return 0
		Endif
		Return 1
	Else
		This.Cmensaje = Left(Alltrim(lcHTML), 200)
		Return 0
	Endif
	Endfunc
Enddefine


















































