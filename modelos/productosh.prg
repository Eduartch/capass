Define Class productosh As Producto Of 'd:\capass\modelos\productos'
	Function MuestraProductosHx(np1,np2,np3,ccursor)
	lc='PROMUESTRAPRODUCTOSx1'
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listar(np1,np2,np3,ccursor)
	lc='PROMUESTRAPRODUCTOSx1'
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	TEXT to lp NOSHOW TEXTMERGE
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaritems(np1,ccursor)
	lc='PromuestraProductosY'
	goapp.npara1=np1
	TEXT to lp NOSHOW TEXTMERGE
     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP10(lc,lp,ccursor)<1
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraProductoskyacompra(np1,np2,np3,ccursor)
	lc='PROMUESTRAPRODUCTOSx1'
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	TEXT to lp NOSHOW TEXTMERGE
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraStockCon(np1,ccur)
	lc='ProMuestraStockC'
	goapp.npara1=np1
	TEXT TO lp NOSHOW TEXTMERGE
   (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccur)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarcompleto(np1,np2,np3,ccursor)
	lc='PROMUESTRAPRODUCTOS2'
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	TEXT to lp NOSHOW TEXTMERGE
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraProductosHu(np1,ccursor)
	lc='PromuestraProductosY'
	goapp.npara1=np1
	TEXT to lp NOSHOW TEXTMERGE
     (?goapp.npara1)
	ENDTEXT
	If this.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function rotacioncompras(dfi,dff,ccursor)
	If dff-dfi>360 Then
		This.cmensaje="Máximo 360 Días"
		Return 0
	Endif
	f1=cfechas(dfi)
	f2=cfechas(dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\    Select a.idart as coda,z.descri,prod_unid1,z.unid,a.cant*kar_equi as cant,if(b.mone="S",cant*a.Prec*b.vigv,cant*a.Prec*b.dolar*b.vigv) As importe,
	\    e.razo as referencia,a.alma,w.dcat,a.kar_unid,a.cant as cant1,a.prec*b.vigv as prec1,b.ndoc,b.tdoc,b.fech,u.nomb as usuario,a.kar_equi as equi,prod_equi1 From
	\    fe_kar as a
	\	inner join fe_art as z on z.idart=a.idart
	\	inner join fe_cat as w on w.idcat=z.idcat
	\	inner join fe_rcom as b on b.idauto=a.idauto
	\	inner join fe_prov as e on e.idprov=b.idprov
	\	inner join fe_usua as u on u.idusua=b.idusua
	\	where a.acti='A' and b.acti='A' and b.fech between '<<f1>>' and '<<f2>>'
	If This.codt>0 Then
	   \ and b.codt=<<this.codt>>
	Endif
	Set Textmerge To
	Set Textmerge Off
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function rotacionventas(dfi,dff,ccursor)
	If dff-dfi>360 Then
		This.cmensaje="Máximo 360 Días"
		Return 0
	Endif
	f1=cfechas(dfi)
	f2=cfechas(dff)
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	\    Select a.idart as coda,z.descri,prod_unid1,z.unid,a.cant*kar_equi as cant,if(b.mone="S",cant*a.Prec,cant*a.Prec*b.dolar) As importe,
	\    e.razo as referencia,a.alma,w.dcat,a.kar_unid,a.cant as cant1,a.prec as prec1,b.ndoc,b.tdoc,b.fech,u.nomb as usuario,a.kar_equi as equi,prod_equi1 From fe_kar as a
	\	inner join fe_art as z on z.idart=a.idart
	\	inner join fe_cat as w on w.idcat=z.idcat
	\	inner join fe_rcom as b on b.idauto=a.idauto
	\	inner join fe_clie as e on e.idclie=b.idcliente
	\	inner join fe_usua as u on u.idusua=b.idusua
	\	where a.acti='A' and b.acti='A' and b.fech between '<<f1>>' and '<<f2>>' and a.alma>0
	If This.codt>0 Then
	   \ and b.codt=<<this.codt>>
	Endif
	Set Textmerge To
	Set Textmerge Off
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function CrearProductospsysu()
	Set Procedure To d:\capass\modelos\presentaciones Additive
	oprese=Createobject("presentaciones")
	objdetalle=Createobject("empty")
	AddProperty(objdetalle,'idart',0)
	AddProperty(objdetalle,'idpres',"")
	AddProperty(objdetalle,'nprec',0)
	AddProperty(objdetalle,'ncant',0)
	AddProperty(objdetalle,'ncosto',0)
	AddProperty(objdetalle,'nmargen',0)
	AddProperty(objdetalle,'cmoneda',"")
	AddProperty(objdetalle,'cestilo',"")
	lc = 'FUNCREAPRODUCTOS'
	cur = "Xn"
	goapp.npara1 = This.cdesc
	goapp.npara2 = This.cunid
	goapp.npara3 = This.nprec
	goapp.npara4 = This.ncosto
	goapp.npara5 = This.npeso
	goapp.npara6 = This.ccat
	goapp.npara7 = This.cmar
	goapp.npara8 =This.ctipro
	goapp.npara9 =  This.nflete
	goapp.npara10 =This.Moneda
	goapp.npara11 = Id()
	goapp.npara12 = This.ncome
	goapp.npara13 = This.ncomc
	goapp.npara14 = goapp.nidusua
	goapp.npara15 =This.nsmax
	goapp.npara16 =  This.nsmin
	goapp.npara17 = This.nidcosto
	goapp.npara18 = This.ndolar
	goapp.npara19 =This.cunid1
	goapp.npara20 = This.nequi1
	goapp.npara21 = This.nequi2
	goapp.npara22 =This.ntigv
	goapp.npara23=this.nidprov
	If This.iniciaTransaccion()<1 Then
		Return 0
	Endif
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23)
	ENDTEXT
	nidpro=This.EJECUTARf(lc, lp, cur)
	If m.nidpro <1 Then
		This.deshacerCambios()
		Return 0
	ENDIF
	objdetalle.idart=m.nidpro
	Select lpta
	Go Top
	Y=1
	Do While !Eof()
		objdetalle.idpres=lpta.epta_pres
		objdetalle.nprec=lpta.epta_prec
		objdetalle.ncant=lpta.epta_cant
		objdetalle.ncosto=lpta.epta_cost
		objdetalle.cmoneda=lpta.epta_mone
		objdetalle.nmargen=lpta.epta_marg
		objdetalle.cestilo=lpta.epta_esti
		If oprese.registrarunidadesvta(objdetalle)<1 Then
			Y=0
			Exit
		Endif
		Select lpta
		Skip
	Enddo
	If Y=0 Then
		This.deshacerCambios()
		Return 0
	Endif
	If This.GrabarCambios()<1 Then
		Return 0
	Endif
	Return  m.nidpro
	Endfunc
	Function ModificarProductospsysu()
*np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24)
	Set Procedure To d:\capass\modelos\presentaciones Additive
	oprese=Createobject("presentaciones")
	objdetalle=Createobject("empty")
	AddProperty(objdetalle,'idep',0)
	AddProperty(objdetalle,'idart',0)
	AddProperty(objdetalle,'idpres',"")
	AddProperty(objdetalle,'nprec',0)
	AddProperty(objdetalle,'ncant',0)
	AddProperty(objdetalle,'ncosto',0)
	AddProperty(objdetalle,'nmargen',0)
	AddProperty(objdetalle,'cmoneda',"")
	AddProperty(objdetalle,'cestilo',"")
	lc = 'PROACTUALIZAPRODUCTOS'
	goapp.npara1 = This.cdesc
	goapp.npara2 = This.cunid
	goapp.npara3 = This.nprec
	goapp.npara4 = This.ncosto
	goapp.npara5 = This.npeso
	goapp.npara6 = This.ccat
	goapp.npara7 = This.cmar
	goapp.npara8 =This.ctipro
	goapp.npara9 =  This.nflete
	goapp.npara10 =This.Moneda
	goapp.npara11 = Id()
	goapp.npara12 = This.ncome
	goapp.npara13 = This.ncomc
	goapp.npara14 = goapp.nidusua
	goapp.npara15 =This.nsmax
	goapp.npara16 =  This.nsmin
	goapp.npara17 = This.nidcosto
	goapp.npara18 = This.ndolar
	goapp.npara19 =This.cunid1
	goapp.npara20 = This.nequi1
	goapp.npara21 = This.nequi2
	goapp.npara22 =This.ntigv
	goapp.npara23 = this.ncoda
	goapp.npara24 = this.cestado
	goapp.npara25=this.nidprov
	TEXT To lp NOSHOW
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
	ENDTEXT
	If This.EJECUTARP(lc, lp, '') <1  Then
		Return 0
	ENDIF
	objdetalle.idart= this.ncoda
	Select lpta
	Set Deleted Off
	Go Top
	Y=1
	Do While !Eof()
		objdetalle.idpres=lpta.epta_pres
		objdetalle.nprec=lpta.epta_prec
		objdetalle.ncant=lpta.epta_cant
		objdetalle.ncosto=lpta.epta_cost
		objdetalle.cmoneda=lpta.epta_mone
		objdetalle.nmargen=lpta.epta_marg
		objdetalle.cestilo=lpta.epta_esti
		Do Case
		Case  Deleted() And lpta.epta_idep>0 
			If oprese.desactivarunidadesvta(lpta.epta_idep)=0 Then
				Y=0
				Exit
			Endif
		Case lpta.epta_idep>0 And !Deleted()
			   objdetalle.idep=lpta.epta_idep
			If oprese.Actualizarunidadesvta(objdetalle)<1 then
		
			*ncoda,lpta.epta_pres,lpta.epta_prec,lpta.epta_cant,lpta.epta_idep,1,lpta.epta_cost,lpta.epta_marg,lpta.epta_mone,lpta.epta_esti)=0 Then
				Y=0
				Exit
			Endif
		Case lpta.epta_idep=0 And !Deleted()
			If oprese.registrarunidadesvta(objdetalle)<1 Then
				Y=0
				Exit
			Endif
		Endcase
		Select lpta
		Skip
	Enddo
	Set Deleted On
	If Y=0 Then
		This.deshacerCambios()
		Return 0
	Endif
	If This.GrabarCambios()<1 Then
		Return 0
	ENDIF
	Return 1
	Endfunc
Enddefine
