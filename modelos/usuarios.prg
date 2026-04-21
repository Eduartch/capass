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
	Text To lcINSERT Noshow Textmerge
    INSERT INTO fe_usua(nomb,tipo,clave,activo,fechusua,usuausua,idpcusua,idalma)
    VALUES ('<<this.cnombre>>','<<this.ctipo>>','<<this.cpassword>>','S',localtime,<<goapp.nidusua>>,'<<ID()>>',<<this.nidtda>>)
	Endtext
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
		Text To lm Noshow
        UPDATE fe_usua SET nomb=?cusua,activo=?cacti,tipo=?ctipo,idalma=?nidalma WHERE idusua=?nusua
		Endtext
	Else
		Text To lm Noshow
         UPDATE fe_usua SET nomb=?cusua,clave=?cpassword WHERE idusua=?nusua
		Endtext
	Endif
	If This.ejecutarsql(lm) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function cambiarTienda(nid, nidalma)
	Text To lC Noshow Textmerge
       UPDATE fe_usua SET idalma=<<nidalma>> WHERE idusua=<<nid>>
	Endtext
	If This.ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'Ok'
	Return 1
	Endfunc
	Function mostrarusuarios(Ccursor)
	Text To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo,idalma FROM fe_usua WHERE activo="S"  ORDER BY nomb
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuariospsysm(Ccursor)
	Text To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo,idalma,usua_super FROM fe_usua WHERE activo="S"  ORDER BY nomb
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuariospsystr(Ccursor)
	Text To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo,idalma,usua_idven FROM fe_usua WHERE activo="S"  ORDER BY nomb
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuariospsystrlyg(Ccursor)
	Text To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo,idalma,usua_idven,usua_serp FROM fe_usua WHERE activo="S"  ORDER BY nomb
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuariospsysl(Ccursor)
	Text To lC Noshow Textmerge
        select  nomb,tipo,activo,idusua,clave,idalma,usua_tran,usua_scre FROM fe_usua WHERE activo='S' ORDER BY nomb
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuariosxsysg(Ccursor)
	Text To lC Noshow Textmerge
        select idusua,nomb,clave,activo,tipo,idalma,usua_prin,usua_cont FROM fe_usua WHERE activo="S"  ORDER BY nomb
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuariosNuematicos(Ccursor)
	Text To lC Noshow Textmerge
      SELECT  idusua,nomb,clave,activo,tipo,idalma FROM fe_usua WHERE activo="S" ORDER BY nomb
	Endtext
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
	goapp.npara1 = np1
	goapp.npara2 = np2
	goapp.npara3 = np3
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	Endtext
	If This.EJECUTARP(lC, lp, ccur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function actualizarpassword(np1, np2)
	cpass = Alltrim(np2)
	Text To lC Noshow Textmerge
	  UPDATE fe_usua SET clave='<<cpass>>' WHERE idusua=<<np1>>
	Endtext
	If This.ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	This.Url = URLP + "/app88/enc.php"
	If  Type('oempresa') = 'U' Then
		Cruc = fe_gene.nruc
	Else
		Cruc = Oempresa.nruc
	Endif
	Text To cdata Noshow Textmerge
	{
    "nruc":"<<cruc>>",
    "idusua":<<np1>>,
    "valor":"<<cpass>>"
    }
	Endtext
*	MESSAGEBOX(cdata,16,'hola')
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", This.Url, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
*	MESSAGEBOX(oHttp.Responsebody)
	Return 1
	Endfunc
	Function obtenercontraseña(np1, Ccursor)
	Text To lC Noshow Textmerge
        SELECT idusua,nomb,clave FROM fe_usua WHERE idusua=<<np1>>  AND activo='S'
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Autorizarpsysw(ctipo, Ccursor)
	goapp.uauto = 0
	Do Case
	Case ctipo = "A"
		Text To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,2)='Ad' ORDER BY nomb
		Endtext
	Case ctipo = "C"
		Text To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_acre=1 ORDER BY nomb
		Endtext
	Case ctipo = "G"
		Text To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,2)='Ad') ORDER BY nomb
		Endtext
	Case ctipo = "D"
		Text To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='D'  ORDER BY nomb
		Endtext
	Case ctipo = "V"
		Text To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		Endtext
	Case ctipo = "p"
		Text To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_prec=1 ORDER BY nomb
		Endtext
	Case ctipo = "g"
		Text To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_guia=1 ORDER BY nomb
		Endtext
	Case ctipo = "t"
		Text To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_cont=1 ORDER BY nomb
		Endtext
	Case ctipo = "Z"
		Text To lC Noshow Textmerge
        select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_super=1 ORDER BY nomb
		Endtext
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function autorizarxsysl(ctipo, Ccursor)
	Do Case
	Case ctipo = "A"
		Text To lC Noshow
         SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='A' ORDER BY nomb
		Endtext
	Case ctipo = "G"
		Text To lC Noshow
          SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,1)='A') ORDER BY nomb
		Endtext
	Case ctipo = "D"
		Text To lC Noshow
                  SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='D'  ORDER BY nomb
		Endtext
	Case ctipo = "V"
		Text To lC Noshow
                 SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		Endtext
	Case ctipo = "a"
		Text To lC Noshow
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_apro=1 ORDER BY nomb
		Endtext
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Autorizarpsys(ctipo, Ccursor)
	Do Case
	Case ctipo = "A"
		Text To lC Noshow
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='A' ORDER BY nomb
		Endtext
	Case ctipo = "G"
		Text To lC Noshow
         SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,1)='A') ORDER BY nomb
		Endtext
	Case ctipo = "C"
		Text To lC Noshow
         SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='D'  ORDER BY nomb
		Endtext
	Case ctipo = "V"
		Text To lC Noshow
         SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		Endtext
	Case ctipo = "a"
		Text To lC Noshow
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_apro=1 ORDER BY nomb
		Endtext
	Case ctipo = "R"
		Text To lC Noshow
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_grat=1 ORDER BY nomb
		Endtext
	Case ctipo = "Z"
		Text To lC Noshow
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_super=1 ORDER BY nomb
		Endtext
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function autorizarxsysg(ctipo, Ccursor)
	Do Case
	Case ctipo = "A"
		Text To lC Noshow Textmerge
      select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,2)='Ad' ORDER BY nomb
		Endtext
	Case ctipo = "C"
		Text To lC Noshow Textmerge
       select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_acre=1 ORDER BY nomb
		Endtext
	Case ctipo = "G"
		Text To lC Noshow Textmerge
       select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,2)='Ad') ORDER BY nomb
		Endtext
	Case ctipo = "V"
		Text To lC Noshow Textmerge
      select   idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		Endtext
	Case ctipo = "p"
		Text To lC Noshow Textmerge
       select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_prec=1 ORDER BY nomb
		Endtext
	Case ctipo = "g"
		Text To lC Noshow Textmerge
     select   idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_guia=1 ORDER BY nomb
		Endtext
	Case ctipo = "t"
		Text To lC Noshow Textmerge
      select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_cont=1 ORDER BY nomb
		Endtext
	Case ctipo = "Z"
		Text To lC Noshow Textmerge
        select   idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_super=1 ORDER BY nomb
		Endtext
	Case ctipo = "D"
		Text To lC Noshow Textmerge
        select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_cont=2 ORDER BY nomb
		Endtext
	Case ctipo = "X"
		Text To lC Noshow Textmerge
         select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,2)='Ad'  and usua_cont>1 ORDER BY nomb
		Endtext
	Endcase
	If This.EJECutaconsulta( lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function Autorizarpsysrx(ctipo, Ccursor)
	Do Case
	Case ctipo = "A"
		Text To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,2)='Ad' ORDER BY nomb
		Endtext
	Case ctipo = "C"
		Text To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_acre=1 ORDER BY nomb
		Endtext
	Case ctipo = "G"
		Text To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,2)='Ad') ORDER BY nomb
		Endtext
	Case ctipo = "D"
		Text To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='D'  ORDER BY nomb
		Endtext
	Case ctipo = "V"
		Text To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		Endtext
	Case ctipo = "p"
		Text To lC Noshow
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_prec=1 ORDER BY nomb
		Endtext
	Case ctipo = "g"
		Text To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_guia=1 ORDER BY nomb
		Endtext
	Case ctipo = "t"
		Text To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_cont=1 ORDER BY nomb
		Endtext
	Case ctipo = "Z"
		Text To lC Noshow Textmerge
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_super=1 ORDER BY nomb
		Endtext
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function autorizarxsysr(ctipo, Ccursor)
	Do Case
	Case ctipo = "A"
		Text To lC Noshow
                  SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='A' ORDER BY nomb
		Endtext
	Case ctipo = "G"
		Text To lC Noshow
                  SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,1)='A') ORDER BY nomb
		Endtext
	Case ctipo = "D"
		Text To lC Noshow
                  SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='D'  ORDER BY nomb
		Endtext
	Case ctipo = "V"
		Text To lC Noshow
                 SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		Endtext
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
		Text To lC Noshow Textmerge
         select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='A' ORDER BY nomb
		Endtext
	Case ctipo = "G"
		Text To lC Noshow Textmerge
        select   idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,1)='A') ORDER BY nomb
		Endtext
	Case ctipo = "D"
		Text To lC Noshow Textmerge
        select   idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='D'  ORDER BY nomb
		Endtext
	Case ctipo = "V"
		Text To lC Noshow Textmerge
        select   idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		Endtext
	Case ctipo = "a"
		Text To lC Noshow Textmerge
        select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_apro=1 ORDER BY nomb
		Endtext
	Case ctipo = "Z"
		Text To lC Noshow Textmerge
        select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_super=1 ORDER BY nomb
		Endtext
	Endcase
	If This.EJECutaconsulta( lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function autorizarxsys5(ctipo, Ccursor)
	Do Case
	Case ctipo = "A"
		Text To lC Noshow Textmerge
        select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='A' ORDER BY nomb
		Endtext
	Case ctipo = "C"
		Text To lC Noshow Textmerge
       select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_acre=1 ORDER BY nomb
		Endtext
	Case ctipo = "G"
		Text To lC Noshow Textmerge
       select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,1)='A') ORDER BY nomb
		Endtext
	Case ctipo = "D"
		Text To lC Noshow Textmerge
      select idusua,nomb,clave ,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='D'  ORDER BY nomb
		Endtext
	Case ctipo = "V"
		Text To lC Noshow Textmerge
      select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		Endtext
	Case ctipo = "a"
		Text To lC Noshow Textmerge
      select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_apro=1 ORDER BY nomb
		Endtext
	Case ctipo = "c"
		Text To lC Noshow Textmerge
      select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_comi=1 ORDER BY nomb
		Endtext
	Case ctipo = "I"
		Text To lC Noshow Textmerge
        select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_reim=1 ORDER BY nomb
		Endtext
	Case ctipo = "1"
		Text To lC Noshow Textmerge
        select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_comi=1 ORDER BY nomb
		Endtext
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function autorizarpsysr(ctipo, Ccursor)
	Do Case
	Case ctipo = "A"
		Text To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,2)='Ad' ORDER BY nomb
		Endtext
	Case ctipo = "C"
		Text To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_acre=1 ORDER BY nomb
		Endtext
	Case ctipo = "G"
		Text To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,2)='Ad') ORDER BY nomb
		Endtext
	Case ctipo = "D"
		Text To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='D'  ORDER BY nomb
		Endtext
	Case ctipo = "V"
		Text To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		Endtext
	Case ctipo = "p"
		Text To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_prec=1 ORDER BY nomb
		Endtext
	Case ctipo = "g"
		Text To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_guia=1 ORDER BY nomb
		Endtext
	Case ctipo = "t"
		Text To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_cont=1 ORDER BY nomb
		Endtext
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function DesAutorizaprecios()
	Text To lC Noshow Textmerge
        UPDATE fe_usua SET usua_prec=0 WHERE idusua=<<this.idusuario>>
	Endtext
	If This.ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuarioslimitados(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To  This.Idsesion
	Endif
	Text To lC Noshow Textmerge Pretext 7
      select nomb,idusua FROM fe_usua WHERE activo='S' AND LEFT(tipo,1) NOT in('A','G') ORDER BY nomb
	Endtext
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function loginxuser()
	Text To lC Noshow Textmerge
       INSERT INTO fe_husua(hisu_idus,hisu_fechain) VALUES (<<goapp.nidusua>>,NOW())
	Endtext
	If This.ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function closexuser()
	Text To lC Noshow Textmerge
        INSERT INTO fe_husua(hisu_idus,hisu_fechault) VALUES (<<goapp.nidusua>>,NOW())
	Endtext
	If This.ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Autorizarprecios(opt, nidusua)
	Text To lC Noshow
     UPDATE fe_usua SET usua_prec=?opt WHERE idusua=?nidusua
	Endtext
	If This.ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'ok'
	Return 1
	Endfunc
	Function desactivar(nid)
	Text To lcc Noshow Textmerge
        UPDATE fe_usua SET activo='N' WHERE idusua=<<nid>>
	Endtext
	If This.ejecutarsql(lcc) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function obtenerdatosusuario(nid, Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lcc Noshow Textmerge
        SELECT * FROM fe_usua WHERE idusua=<<nid>> limit 1
	Endtext
	If This.EJECutaconsulta(lcc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function verificarclave(nidus, cclave)
	Ccursor = 'c_' + Sys(2015)
	Text To lcc Noshow Textmerge
    SELECT clave FROM fe_usua WHERE idusua=<<nidus>> limit 1
	Endtext
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
	Text To lC Noshow Textmerge
       UPDATE fe_usua SET tipo='<<ctipo>>' WHERE idusua=<<nidus>>
	Endtext
	If This.ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Autorizarpsysg(ctipo, Ccursor)
	Do Case
	Case ctipo = "A"
		Text To cusuarios Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='A' ORDER BY nomb
		Endtext
	Case ctipo = "B"
		Text To cusuarios Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_anul=1 ORDER BY nomb
		Endtext
	Case ctipo = "C"
		Text To cusuarios Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_acre=1 ORDER BY nomb
		Endtext
	Case ctipo = "G"
		Text To cusuarios Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,1)='A') ORDER BY nomb
		Endtext
	Case ctipo = "D"
		Text To cusuarios Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='D'  ORDER BY nomb
		Endtext
	Case ctipo = "V"
		Text To cusuarios Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		Endtext
	Case ctipo = "p"
		Text To cusuarios Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_prec=1 ORDER BY nomb
		Endtext
	Case ctipo = "t"
		Text To cusuarios Noshow Textmerge
       select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_cont=1 ORDER BY nomb
		Endtext
	Case ctipo = "Z"
		Text To cusuarios Noshow Textmerge
        select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_super=1 ORDER BY nomb
		Endtext
	Endcase
	If This.EJECutaconsulta(cusuarios, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
































