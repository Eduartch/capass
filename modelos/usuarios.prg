#Define URLP "http://companiasysven.com"
Define Class usuarios As OData Of 'd:\capass\database\data.prg'
	idusuario = 0
	cnombre = ""
	cpassword = ""
	nidtda = 0
	ctipo = ""
	cestado = ""
	cmodo = 0
	Function crear()
	This.cmodo = 'N'
	oser = Newobject("servicio", "d:\capass\services\service.prg")
	m.rpta = oser.Inicializar(This, 'usuarios')
	If m.rpta < 1 Then
		This.Cmensaje = oser.Cmensaje
		Return 0
	Endif
	oser = Null
	TEXT To lcINSERT Noshow Textmerge
    INSERT INTO fe_usua(nomb,tipo,clave,activo,fechusua,usuausua,idpcusua,idalma)
    VALUES ('<<this.cnombre>>','<<this.ctipo>>','<<this.cpassword>>','S',localtime,<<goapp.nidusua>>,'<<ID()>>',<<this.nidtda>>)
	ENDTEXT
	If This.ejecutarsql(lcINSERT) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function editar(cclave)
	This.cmodo = 'M'
	oser = Newobject("servicio", "d:\capass\services\service.prg")
	m.rpta = oser.Inicializar(This, 'usuarios')
	If m.rpta < 1 Then
		This.Cmensaje = oser.Cmensaje
		Return 0
	Endif
	oser = Null
	cusua = This.cnombre
	cacti = This.cestado
	ctipo = This.ctipo
	nidalma = This.nidtda
	cpassword = This.cpassword
	nusua = This.idusuario
	If m.cclave = 'N'
		TEXT To lm Noshow
        UPDATE fe_usua SET nomb=?cusua,activo=?cacti,tipo=?ctipo,idalma=?nidalma WHERE idusua=?nusua
		ENDTEXT
	Else
		TEXT To lm Noshow
         UPDATE fe_usua SET nomb=?cusua,clave=?cpassword WHERE idusua=?nusua
		ENDTEXT
	Endif
	If This.ejecutarsql(lm) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function cambiarTienda(nid, nidalma)
	TEXT To lC Noshow Textmerge
       UPDATE fe_usua SET idalma=<<nidalma>> WHERE idusua=<<nid>>
	ENDTEXT
	If This.ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'Ok'
	Return 1
	Endfunc
	Function mostrarusuarios(Ccursor)
	TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo,idalma FROM fe_usua WHERE activo='S'  ORDER BY nomb
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuariospsysg(Ccursor)
	TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo,idalma,usua_super,usua_prec,usua_anul FROM fe_usua WHERE activo='S'  ORDER BY nomb
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuariospsysm(Ccursor)
	TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo,idalma,usua_super FROM fe_usua WHERE activo='S'  ORDER BY nomb
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuariospsystr(Ccursor)
	TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo,idalma,usua_idven FROM fe_usua WHERE activo='S'  ORDER BY nomb
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuariospsystrlyg(Ccursor)
	TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo,idalma,usua_idven,usua_serp FROM fe_usua WHERE activo='S'  ORDER BY nomb
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuariospsysl(Ccursor)
	TEXT To lC Noshow Textmerge
        select  nomb,tipo,activo,idusua,clave,idalma,usua_tran,usua_scre FROM fe_usua WHERE activo='S' ORDER BY nomb
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuariosxsysg(Ccursor)
	TEXT To lC Noshow Textmerge
        select idusua,nomb,clave,activo,tipo,idalma,usua_prin,usua_cont FROM fe_usua WHERE activo='S'  ORDER BY nomb
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuariosNuematicos(Ccursor)
	TEXT To lC Noshow Textmerge
      SELECT  idusua,nomb,clave,activo,tipo,idalma FROM fe_usua WHERE activo='S' ORDER BY nomb
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscausuario(cmodo, nidus, cnombre)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select Idusua From fe_usua Where Trim(nomb)='<<cnombre>>'  And activo='S'
	If m.cmodo <> 'N' Then
        \ And Idusua<><<m.nidus>>
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, 'ya') < 1
		Return 0
	Endif
	If Ya.Idusua > 0 Then
		This.Cmensaje = "Nombre de Usuario Ya Registrado"
		Return 0
	Endif
	Return 1
	Endfunc
	Function MostrarUsuarios1(np1, np2, np3, ccur)
	lC = "ProMuestraUsuarios"
	npara1 = np1
	npara2 = np2
	npara3 = np3
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lp Noshow
    (?npara1,?npara2,?npara3)
	ENDTEXT
	If This.EJECUTARP(lC, lp, ccur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function actualizarpassword(np1, np2)
	cpass = Alltrim(np2)
	TEXT To lC Noshow Textmerge
	  UPDATE fe_usua SET clave='<<cpass>>' WHERE idusua=<<np1>>
	ENDTEXT
	If This.ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	This.Url = URLP + "/app88/enc.php"
	If  Type('oempresa') = 'U' Then
		Cruc = fe_gene.nruc
	Else
		Cruc = Oempresa.nruc
	Endif
	TEXT To cdata Noshow Textmerge
	{
    "nruc":"<<cruc>>",
    "idusua":<<np1>>,
    "valor":"<<cpass>>"
    }
	ENDTEXT
*	MESSAGEBOX(cdata,16,'hola')
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", This.Url, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
*	MESSAGEBOX(oHttp.Responsebody)
	Return 1
	Endfunc
	Function obtenercontraseña(np1, Ccursor)
	TEXT To lC Noshow Textmerge
        SELECT idusua,nomb,clave FROM fe_usua WHERE idusua=<<np1>>  AND activo='S'
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Autorizarpsysw(ctipo, Ccursor)
	goapp.uauto = 0
	Do Case
	Case ctipo = "A"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,2)='Ad' ORDER BY nomb
		ENDTEXT
	Case ctipo = "C"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_acre=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "G"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND (LEFT(tipo,1)='G' OR LEFT(tipo,2)='Ad') ORDER BY nomb
		ENDTEXT
	Case ctipo = "D"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,1)='D'  ORDER BY nomb
		ENDTEXT
	Case ctipo = "V"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S'  ORDER BY nomb
		ENDTEXT
	Case ctipo = "p"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_prec=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "g"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_guia=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "t"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_cont=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "Z"
		TEXT To lC Noshow Textmerge
        select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_super=1 ORDER BY nomb
		ENDTEXT
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function autorizarxsysl(ctipo, Ccursor)
	Do Case
	Case ctipo = "A"
		TEXT To lC Noshow
         SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,1)='A' ORDER BY nomb
		ENDTEXT
	Case ctipo = "G"
		TEXT To lC Noshow
          SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND (LEFT(tipo,1)='G' OR LEFT(tipo,1)='A') ORDER BY nomb
		ENDTEXT
	Case ctipo = "D"
		TEXT To lC Noshow
                  SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,1)='D'  ORDER BY nomb
		ENDTEXT
	Case ctipo = "V"
		TEXT To lC Noshow
                 SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S'  ORDER BY nomb
		ENDTEXT
	Case ctipo = "a"
		TEXT To lC Noshow
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_apro=1 ORDER BY nomb
		ENDTEXT
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Autorizarpsys(ctipo, Ccursor)
	Do Case
	Case ctipo = "A"
		TEXT To lC Noshow
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,1)='A' ORDER BY nomb
		ENDTEXT
	Case ctipo = "G"
		TEXT To lC Noshow
         SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND (LEFT(tipo,1)='G' OR LEFT(tipo,1)='A') ORDER BY nomb
		ENDTEXT
	Case ctipo = "C"
		TEXT To lC Noshow
         SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,1)='D'  ORDER BY nomb
		ENDTEXT
	Case ctipo = "V"
		TEXT To lC Noshow
         SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S'  ORDER BY nomb
		ENDTEXT
	Case ctipo = "a"
		TEXT To lC Noshow
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_apro=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "R"
		TEXT To lC Noshow
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_grat=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "Z"
		TEXT To lC Noshow
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_super=1 ORDER BY nomb
		ENDTEXT
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function autorizarxsysg(ctipo, Ccursor)
	Do Case
	Case ctipo = "A"
		TEXT To lC Noshow Textmerge
      select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,2)='Ad' ORDER BY nomb
		ENDTEXT
	Case ctipo = "C"
		TEXT To lC Noshow Textmerge
       select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_acre=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "G"
		TEXT To lC Noshow Textmerge
       select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND (LEFT(tipo,1)='G' OR LEFT(tipo,2)='Ad') ORDER BY nomb
		ENDTEXT
	Case ctipo = "V"
		TEXT To lC Noshow Textmerge
      select   idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S'  ORDER BY nomb
		ENDTEXT
	Case ctipo = "p"
		TEXT To lC Noshow Textmerge
       select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_prec=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "g"
		TEXT To lC Noshow Textmerge
     select   idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_guia=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "t"
		TEXT To lC Noshow Textmerge
      select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_cont=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "Z"
		TEXT To lC Noshow Textmerge
        select   idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_super=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "D"
		TEXT To lC Noshow Textmerge
        select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_cont=2 ORDER BY nomb
		ENDTEXT
	Case ctipo = "X"
		TEXT To lC Noshow Textmerge
         select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,2)='Ad'  and usua_cont>1 ORDER BY nomb
		ENDTEXT
	Endcase
	If This.EJECutaconsulta( lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function Autorizarpsysrx(ctipo, Ccursor)
	Do Case
	Case ctipo = "A"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,2)='Ad' ORDER BY nomb
		ENDTEXT
	Case ctipo = "C"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_acre=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "G"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND (LEFT(tipo,1)='G' OR LEFT(tipo,2)='Ad') ORDER BY nomb
		ENDTEXT
	Case ctipo = "D"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,1)='D'  ORDER BY nomb
		ENDTEXT
	Case ctipo = "V"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S'  ORDER BY nomb
		ENDTEXT
	Case ctipo = "p"
		TEXT To lC Noshow
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_prec=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "g"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_guia=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "t"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_cont=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "Z"
		TEXT To lC Noshow Textmerge
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_super=1 ORDER BY nomb
		ENDTEXT
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function autorizarxsysr(ctipo, Ccursor)
	Do Case
	Case ctipo = "A"
		TEXT To lC Noshow
                  SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,1)='A' ORDER BY nomb
		ENDTEXT
	Case ctipo = "G"
		TEXT To lC Noshow
                  SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND (LEFT(tipo,1)='G' OR LEFT(tipo,1)='A') ORDER BY nomb
		ENDTEXT
	Case ctipo = "D"
		TEXT To lC Noshow
                  SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,1)='D'  ORDER BY nomb
		ENDTEXT
	Case ctipo = "V"
		TEXT To lC Noshow
                 SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S'  ORDER BY nomb
		ENDTEXT
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Autorizarpsystr(ctipo, Ccursor)
	Do Case
	Case ctipo = "A"
		Select fe_gene
		TEXT To lC Noshow Textmerge
         select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,1)='A' ORDER BY nomb
		ENDTEXT
	Case ctipo = "G"
		TEXT To lC Noshow Textmerge
        select   idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND (LEFT(tipo,1)='G' OR LEFT(tipo,1)='A') ORDER BY nomb
		ENDTEXT
	Case ctipo = "D"
		TEXT To lC Noshow Textmerge
        select   idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,1)='D'  ORDER BY nomb
		ENDTEXT
	Case ctipo = "V"
		TEXT To lC Noshow Textmerge
        select   idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S'  ORDER BY nomb
		ENDTEXT
	Case ctipo = "a"
		TEXT To lC Noshow Textmerge
        select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_apro=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "Z"
		TEXT To lC Noshow Textmerge
        select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_super=1 ORDER BY nomb
		ENDTEXT
	Endcase
	If This.EJECutaconsulta( lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function autorizarxsys5(ctipo, Ccursor)
	Do Case
	Case ctipo = "A"
		TEXT To lC Noshow Textmerge
        select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,1)='A' ORDER BY nomb
		ENDTEXT
	Case ctipo = "C"
		TEXT To lC Noshow Textmerge
       select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_acre=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "G"
		TEXT To lC Noshow Textmerge
       select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND (LEFT(tipo,1)='G' OR LEFT(tipo,1)='A') ORDER BY nomb
		ENDTEXT
	Case ctipo = "D"
		TEXT To lC Noshow Textmerge
      select idusua,nomb,clave ,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,1)='D'  ORDER BY nomb
		ENDTEXT
	Case ctipo = "V"
		TEXT To lC Noshow Textmerge
      select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S'  ORDER BY nomb
		ENDTEXT
	Case ctipo = "a"
		TEXT To lC Noshow Textmerge
      select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_apro=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "c"
		TEXT To lC Noshow Textmerge
      select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_comi=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "I"
		TEXT To lC Noshow Textmerge
        select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_reim=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "1"
		TEXT To lC Noshow Textmerge
        select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_comi=1 ORDER BY nomb
		ENDTEXT
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function autorizarpsysr(ctipo, Ccursor)
	Do Case
	Case ctipo = "A"
		TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,2)='Ad' ORDER BY nomb
		ENDTEXT
	Case ctipo = "C"
		TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_acre=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "G"
		TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND (LEFT(tipo,1)='G' OR LEFT(tipo,2)='Ad') ORDER BY nomb
		ENDTEXT
	Case ctipo = "D"
		TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,1)='D'  ORDER BY nomb
		ENDTEXT
	Case ctipo = "V"
		TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S'  ORDER BY nomb
		ENDTEXT
	Case ctipo = "p"
		TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_prec=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "g"
		TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_guia=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "t"
		TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_cont=1 ORDER BY nomb
		ENDTEXT
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function DesAutorizaprecios()
	TEXT To lC Noshow Textmerge
        UPDATE fe_usua SET usua_prec=0 WHERE idusua=<<this.idusuario>>
	ENDTEXT
	If This.ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuarioslimitados(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To  This.Idsesion
	Endif
	TEXT To lC Noshow Textmerge Pretext 7
      select nomb,idusua FROM fe_usua WHERE activo='S' AND LEFT(tipo,2) NOT in('AD','GE') ORDER BY nomb
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function loginxuser()
	TEXT To lC Noshow Textmerge
       INSERT INTO fe_husua(hisu_idus,hisu_fechain) VALUES (<<goapp.nidusua>>,NOW())
	ENDTEXT
	If This.ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function closexuser()
	TEXT To lC Noshow Textmerge
        INSERT INTO fe_husua(hisu_idus,hisu_fechault) VALUES (<<goapp.nidusua>>,NOW())
	ENDTEXT
	If This.ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Autorizarprecios(opt, nidusua)
	TEXT To lC Noshow
     UPDATE fe_usua SET usua_prec=?opt WHERE idusua=?nidusua
	ENDTEXT
	If This.ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'ok'
	Return 1
	Endfunc
	Function desactivar(nid)
	TEXT To lcc Noshow Textmerge
        UPDATE fe_usua SET activo='N' WHERE idusua=<<nid>>
	ENDTEXT
	If This.ejecutarsql(lcc) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function obtenerdatosusuario(nid, Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lcc Noshow Textmerge
        SELECT * FROM fe_usua WHERE idusua=<<nid>> limit 1
	ENDTEXT
	If This.EJECutaconsulta(lcc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function verificarclave(nidus, cclave)
	Ccursor = 'c_' + Sys(2015)
	TEXT To lcc Noshow Textmerge
    SELECT clave FROM fe_usua WHERE idusua=<<nidus>> limit 1
	ENDTEXT
	If This.EJECutaconsulta(lcc, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If Alltrim(clave) <> Alltrim(m.cclave) Then
		This.Cmensaje = "Clave de Usuario Incorrecta"
		Return 0
	Endif
	Return 1
	Endfunc
	Function cambiarnivelusuario(nidus, ctipo)
	TEXT To lC Noshow Textmerge
       UPDATE fe_usua SET tipo='<<ctipo>>' WHERE idusua=<<nidus>>
	ENDTEXT
	If This.ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Autorizarpsysg(ctipo, Ccursor)
	Do Case
	Case ctipo = "A"
		TEXT To cusuarios Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,1)='A' ORDER BY nomb
		ENDTEXT
	Case ctipo = "B"
		TEXT To cusuarios Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_anul=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "C"
		TEXT To cusuarios Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_acre=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "G"
		TEXT To cusuarios Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND (LEFT(tipo,1)='G' OR LEFT(tipo,1)='A') ORDER BY nomb
		ENDTEXT
	Case ctipo = "D"
		TEXT To cusuarios Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND LEFT(tipo,1)='D'  ORDER BY nomb
		ENDTEXT
	Case ctipo = "V"
		TEXT To cusuarios Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S'  ORDER BY nomb
		ENDTEXT
	Case ctipo = "p"
		TEXT To cusuarios Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_prec=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "t"
		TEXT To cusuarios Noshow Textmerge
       select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_cont=1 ORDER BY nomb
		ENDTEXT
	Case ctipo = "Z"
		TEXT To cusuarios Noshow Textmerge
        select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo='S' AND usua_super=1 ORDER BY nomb
		ENDTEXT
	Endcase
	If This.EJECutaconsulta(cusuarios, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function autorizaAnular(nidus)
	TEXT TO lc noshow
     UPDATE fe_usua as l  SET usua_anula=if(l.usua_anula=1,0,1) WHERE idusua=?nidus
	ENDTEXT
	If  This.ejecutarsql(lC)<1
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
