#Define URLP "http://companiasysven.com"
Define Class usuarios As OData Of 'd:\capass\database\data.prg'
	idusuario = 0
	Function mostrarusuarios(Ccursor)
	TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo,idalma FROM fe_usua WHERE activo="S"  ORDER BY nomb
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuariospsysm(Ccursor)
	TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo,idalma,usua_super FROM fe_usua WHERE activo="S"  ORDER BY nomb
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuariospsystr(Ccursor)
	TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo,idalma,usua_idven FROM fe_usua WHERE activo="S"  ORDER BY nomb
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuariospsystrlyg(Ccursor)
	TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo,idalma,usua_idven,usua_serp FROM fe_usua WHERE activo="S"  ORDER BY nomb
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
        select idusua,nomb,clave,activo,tipo,idalma,usua_prin,usua_cont FROM fe_usua WHERE activo="S"  ORDER BY nomb
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuariosNuematicos(Ccursor)
	TEXT To lC Noshow Textmerge
      SELECT  idusua,nomb,clave,activo,tipo,idalma FROM fe_usua WHERE activo="S" ORDER BY nomb
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscausuario(cmodo, nidus, cnombre)
	If cmodo = "N"
		TEXT To lC Noshow Textmerge
        SELECT idusua FROM fe_usua WHERE tRIM(nomb)='<<cnombre>>'  AND activo='S'
		ENDTEXT
	Else
		TEXT To lC Noshow Textmerge
          SELECT idusua FROM fe_usua WHERE TRIM(nomb)='<<cnombre>>' AND idusua<><<nidsus>> AND activo<>'S'
		ENDTEXT
	Endif
	If This.EJECutaconsulta(lC, 'ya') < 1
		Return 0
	Endif
	If ya.Idusua > 0 Then
		This.Cmensaje = "Nombre de Usuario Ya Registrado"
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function MostrarUsuarios1(np1, np2, np3, ccur)
	lC = "ProMuestraUsuarios"
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
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
	If This.Ejecutarsql(lC) < 1 Then
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
	Function Autorizarpsysw(Ctipo, Ccursor)
	goApp.uauto = 0
	Do Case
	Case Ctipo = "A"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,2)='Ad' ORDER BY nomb
		ENDTEXT
	Case Ctipo = "C"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_acre=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "G"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,2)='Ad') ORDER BY nomb
		ENDTEXT
	Case Ctipo = "D"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='D'  ORDER BY nomb
		ENDTEXT
	Case Ctipo = "V"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		ENDTEXT
	Case Ctipo = "p"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_prec=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "g"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_guia=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "t"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_cont=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "Z"
		TEXT To lC Noshow Textmerge
        select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_super=1 ORDER BY nomb
		ENDTEXT
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function autorizarxsysl(Ctipo, Ccursor)
	Do Case
	Case Ctipo = "A"
		TEXT To lC Noshow
         SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='A' ORDER BY nomb
		ENDTEXT
	Case Ctipo = "G"
		TEXT To lC Noshow
          SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,1)='A') ORDER BY nomb
		ENDTEXT
	Case Ctipo = "D"
		TEXT To lC Noshow
                  SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='D'  ORDER BY nomb
		ENDTEXT
	Case Ctipo = "V"
		TEXT To lC Noshow
                 SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		ENDTEXT
	Case Ctipo = "a"
		TEXT To lC Noshow
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_apro=1 ORDER BY nomb
		ENDTEXT
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Autorizarpsys(Ctipo, Ccursor)
	Do Case
	Case Ctipo = "A"
		TEXT To lC Noshow
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='A' ORDER BY nomb
		ENDTEXT
	Case Ctipo = "G"
		TEXT To lC Noshow
         SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,1)='A') ORDER BY nomb
		ENDTEXT
	Case Ctipo = "C"
		TEXT To lC Noshow
         SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='D'  ORDER BY nomb
		ENDTEXT
	Case Ctipo = "V"
		TEXT To lC Noshow
         SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		ENDTEXT
	Case Ctipo = "a"
		TEXT To lC Noshow
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_apro=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "R"
		TEXT To lC Noshow
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_grat=1 ORDER BY nomb
		ENDTEXT
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function autorizarxsysg(Ctipo, Ccursor)
	Do Case
	Case Ctipo = "A"
		TEXT To lC Noshow Textmerge
      select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,2)='Ad' ORDER BY nomb
		ENDTEXT
	Case Ctipo = "C"
		TEXT To lC Noshow Textmerge
       select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_acre=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "G"
		TEXT To lC Noshow Textmerge
       select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,2)='Ad') ORDER BY nomb
		ENDTEXT
	Case Ctipo = "V"
		TEXT To lC Noshow Textmerge
      select   idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		ENDTEXT
	Case Ctipo = "p"
		TEXT To lC Noshow Textmerge
       select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_prec=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "g"
		TEXT To lC Noshow Textmerge
     select   idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_guia=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "t"
		TEXT To lC Noshow Textmerge
      select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_cont=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "Z"
		TEXT To lC Noshow Textmerge
        select   idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_super=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "D"
		TEXT To lC Noshow Textmerge
        select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_cont=2 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "X"
		TEXT To lC Noshow Textmerge
         select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,2)='Ad'  and usua_cont>1 ORDER BY nomb
		ENDTEXT
	Endcase
	If This.EJECutaconsulta( lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function Autorizarpsysrx(Ctipo, Ccursor)
	Do Case
	Case Ctipo = "A"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,2)='Ad' ORDER BY nomb
		ENDTEXT
	Case Ctipo = "C"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_acre=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "G"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,2)='Ad') ORDER BY nomb
		ENDTEXT
	Case Ctipo = "D"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='D'  ORDER BY nomb
		ENDTEXT
	Case Ctipo = "V"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		ENDTEXT
	Case Ctipo = "p"
		TEXT To lC Noshow
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_prec=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "g"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_guia=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "t"
		TEXT To lC Noshow
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_cont=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "Z"
		TEXT To lC Noshow Textmerge
        SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_super=1 ORDER BY nomb
		ENDTEXT
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function autorizarxsysr(Ctipo, Ccursor)
	Do Case
	Case Ctipo = "A"
		TEXT To lC Noshow
                  SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='A' ORDER BY nomb
		ENDTEXT
	Case Ctipo = "G"
		TEXT To lC Noshow
                  SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,1)='A') ORDER BY nomb
		ENDTEXT
	Case Ctipo = "D"
		TEXT To lC Noshow
                  SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='D'  ORDER BY nomb
		ENDTEXT
	Case Ctipo = "V"
		TEXT To lC Noshow
                 SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		ENDTEXT
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Autorizarpsystr(Ctipo, Ccursor)
	Do Case
	Case Ctipo = "A"
		Select fe_gene
		TEXT To lC Noshow Textmerge
         select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='A' ORDER BY nomb
		ENDTEXT
	Case Ctipo = "G"
		TEXT To lC Noshow Textmerge
        select   idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,1)='A') ORDER BY nomb
		ENDTEXT
	Case Ctipo = "D"
		TEXT To lC Noshow Textmerge
        select   idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='D'  ORDER BY nomb
		ENDTEXT
	Case Ctipo = "V"
		TEXT To lC Noshow Textmerge
        select   idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		ENDTEXT
	Case Ctipo = "a"
		TEXT To lC Noshow Textmerge
        select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_apro=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "Z"
		TEXT To lC Noshow Textmerge
        select  idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_super=1 ORDER BY nomb
		ENDTEXT
	Endcase
	If This.EJECutaconsulta( lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function autorizarxsys5(Ctipo, Ccursor)
	Do Case
	Case Ctipo = "A"
		TEXT To lC Noshow Textmerge
        select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='A' ORDER BY nomb
		ENDTEXT
	Case Ctipo = "C"
		TEXT To lC Noshow Textmerge
       select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_acre=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "G"
		TEXT To lC Noshow Textmerge
       select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,1)='A') ORDER BY nomb
		ENDTEXT
	Case Ctipo = "D"
		TEXT To lC Noshow Textmerge
      select idusua,nomb,clave ,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='D'  ORDER BY nomb
		ENDTEXT
	Case Ctipo = "V"
		TEXT To lC Noshow Textmerge
      select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		ENDTEXT
	Case Ctipo = "a"
		TEXT To lC Noshow Textmerge
      select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_apro=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "c"
		TEXT To lC Noshow Textmerge
      select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_comi=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "I"
		TEXT To lC Noshow Textmerge
        select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_reim=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "1"
		TEXT To lC Noshow Textmerge
        select idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_comi=1 ORDER BY nomb
		ENDTEXT
	Endcase
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function autorizarpsysr(Ctipo, Ccursor)
	Do Case
	Case Ctipo = "A"
		TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,2)='Ad' ORDER BY nomb
		ENDTEXT
	Case Ctipo = "C"
		TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_acre=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "G"
		TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND (LEFT(tipo,1)='G' OR LEFT(tipo,2)='Ad') ORDER BY nomb
		ENDTEXT
	Case Ctipo = "D"
		TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND LEFT(tipo,1)='D'  ORDER BY nomb
		ENDTEXT
	Case Ctipo = "V"
		TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
		ENDTEXT
	Case Ctipo = "p"
		TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_prec=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "g"
		TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_guia=1 ORDER BY nomb
		ENDTEXT
	Case Ctipo = "t"
		TEXT To lC Noshow Textmerge
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S" AND usua_cont=1 ORDER BY nomb
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
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarusuarioslimitados(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To  This.Idsesion
	Endif
	TEXT To lC Noshow Textmerge Pretext 7
      select nomb,idusua FROM fe_usua WHERE activo='S' AND LEFT(tipo,1) NOT in('A','G') ORDER BY nomb
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
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function closexuser()
	TEXT To lC Noshow Textmerge
        INSERT INTO fe_husua(hisu_idus,hisu_fechault) VALUES (<<goapp.nidusua>>,NOW())
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Autorizarprecios(opt,nidusua)
	TEXT TO lc noshow
     UPDATE fe_usua SET usua_prec=?opt WHERE idusua=?nidusua
	ENDTEXT
	If This.Ejecutarsql(lC)<1 Then
		Return 0
	Endif
	This.Cmensaje='ok'
	Return 1
	Endfunc
	Function desactivar(nid)
	TEXT TO lcc NOSHOW
        UPDATE fe_usua SET activo='N' WHERE idusua=?nid
	ENDTEXT
	If This.Ejecutarsql(lcc)<1 Then
		Return 0
	Endif
	This.Cmensaje='ok'
	Return 1
	Endfunc
Enddefine




















