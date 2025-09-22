Define Class Producto As OData Of 'd:\capass\database\data'
	cdesc	   = ""
	cUnid	   = ""
	cunid1 =   ""
	nprec	   = 0
	ncosto   = 0
	np1	   = 0
	np2	   = 0
	np3	   = 0
	npeso	   = 0
	ccat	   = 0
	cmar	   = 0
	ctipro   = ""
	nflete   = 0
	cm	   = ""
	ce	   = ""
	cidpc	   = ""
	dFecha   = Datetime()
	nidusua  = 0
	nutil1   = 0
	nutil2   = 0
	nutil3   = 0
	nutil0    = 0
	ncantoferta = 0
	ncome	   = 0
	ncomc	   = 0
	nsmax	   = 0
	nsmin	   = 0
	nidcosto = 0
	nidgrupo = 0
	ndolar   = 0
	ccodigo1 = ""
	ncoda	   = 0
	mflete  = 0
	costoneto = 0
	costosflete = 0
	Moneda = ""
	cusua = ""
	nper = 0
	cmodelo = ""
	ccai = ""
	tipovista = ""
	constock =  ""
	Cestado = ""
	codt = 0
	cdetalle = ""
	duti1 = 0
	duti2 = 0
	duti3 = 0
	duti0 = 0
	nidart = 0
	nidtda = 0
	ncant = 0
	Ctipo = ""
	cTdoc = ""
	ncaant = 0
	nequi = 0
	ntigv = 0
	nirta = 0
	nsmin1 = 0
	nsmax1 = 0
	nsmin2 = 0
	nsmax2 = 0
	nsmin3 = 0
	nsmax3 = 0
	ccoda = ""
	ndetraccion = 0
	Coddetra = ""
	cubi1 = ""
	imagen=""
	nequi1=0
	nequi2=0
	nidprov=0  && Proveedor del producto
	Function MuestraProductosJ1(np1, np2, np3, np4, Ccursor)
	lC = 'PROMUESTRAPRODUCTOSJx'
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	ENDTEXT
	If  This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listapreciosporlineaunidades(nidcat, Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow  Textmerge
	\ Select idart,Descri,unid,prod_unid1,
	\	 Cast(If(uno>0,If(Mod(uno,prod_equi2)=0,uno/prod_equi2,If(Mod(uno,prod_equi2)=0,uno DIV prod_equi2,Truncate(uno/prod_equi2,0))),0.00) As Decimal(12,2)) As prod_unim,
	\	 Cast(If(uno>0,If(Mod(uno,prod_equi2)=0,0.00,Mod(uno,prod_equi2)),uno) As Decimal(12,2)) As prod_unin,
	\	 Cast(If(Dos>0,If(Mod(Dos,prod_equi2)=0,Dos/prod_equi2,If(Mod(Dos,prod_equi2)=0,Dos DIV prod_equi2,Truncate(Dos/prod_equi2,0))),0.00) As Decimal(12,2)) As prod_dunim,
	\	 Cast(If(Dos>0,If(Mod(Dos,prod_equi2)=0,0.00,Mod(Dos,prod_equi2)),Dos) As Decimal(12,2)) As prod_dunin,
	\	 Cast(If(tre>0,If(Mod(tre,prod_equi1)=0,tre/prod_equi1,If(Mod(tre,prod_equi1)=0,tre DIV prod_equi1,Truncate(tre/prod_equi1,0))),0.00) As Decimal(12,2)) As prod_tunim,
	\	 Cast(If(tre>0,If(Mod(tre,prod_equi1)=0,0.00,Mod(tre,prod_equi1)),tre) As Decimal(12,2)) As prod_tunin,
	\	 Cast(If(cua>0,If(Mod(cua,prod_equi1)=0,cua/prod_equi1,If(Mod(cua,prod_equi1)=0,cua DIV prod_equi1,Truncate(cua/prod_equi1,0))),0.00) As  Decimal(12,2)) As prod_cunim,
	\	 Cast(If(cua>0,If(Mod(cua,prod_equi1)=0,0.00,Mod(cua,prod_equi1)),cua) As Decimal(12,2)) As prod_cunin,
	\	 Round(If(tmon='S',(a.Prec*prod_tigv)+b.Prec,(a.Prec*prod_tigv*v.dola)+b.Prec),2) As costo,c.idgrupo,c.dcat,
	\	 IFNULL(Round(If(tmon='S',premay,((a.Prec*prod_tigv*v.dola)+b.Prec)*prod_uti3),2),0) As pre1,
	\	 IFNULL(Round(If(tmon='S',premen,((a.Prec*prod_tigv*v.dola)+b.Prec)*prod_uti2),2),0) As pre2,
	\	 IFNULL(Round(If(tmon='S',pre3,((a.Prec*prod_tigv*v.dola)+b.Prec)*prod_uti1),2),0) As pre3,prod_tigv,
	\	 Round(If(tmon='S',(a.Prec*prod_tigv),(a.Prec*prod_tigv*v.dola)),2) As costosf,b.Prec As flete,ulfc,uno,Dos,tre,cua,
	\	 Cast(0 As Decimal(12,2)) As costor,Cast(0 As Decimal(10,2)) As precr,''  As moner,
	\    Cast(0 As UNSIGNED) As cost_idco,Cast(0 As Decimal(5,2))  As fleter,Cast(0 As Decimal(5,2)) As dolar,
	\    peso,a.Prec,tipro,idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,prod_idus,prod_equi1,prod_equi2,
	\     prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin,IFNULL(o.razo,'') As proveedor,
	\     IFNULL(yy.ndoc,'') As ndoc,IFNULL(yy.fech,'') As fech, prod_idpc,prod_idpm,prod_cod1,prod_acti,prod_alma  From fe_art  As a
	\     INNER Join fe_fletes As b On(b.idflete=a.idflete)
	\     INNER Join fe_cat As c On(c.idcat=a.idcat)
	\     Left Join fe_rcom As yy On (yy.idauto=a.prod_idau)
	\     Left Join fe_prov As o On (o.idprov=yy.idprov) ,fe_gene As v
	\     Where prod_acti<>'I'
	If nidcat > 0 Then
	  \ And a.idcat=<<nidcat>>
	Endif
	\Order By Descri;
	Set Textmerge Off
	Set Textmerge To
	If  This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraProductosDescCod(np1, np2, np3, np4, Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Local lC, lp
	m.lC		 = 'PROMUESTRAPRODUCTOS1'
	goApp.npara1 = Chrtran(m.np1, ' ', '%')
	goApp.npara2 = m.np2
	goApp.npara3 = m.np3
	goApp.npara4 = m.np4
	TEXT To m.lp Noshow
   (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	ENDTEXT
	If This.EJECUTARP10(m.lC, m.lp, m.Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function CreaProducto()
	If !Pemstatus(goApp, 'prodconubicacion', 5) Then
		AddProperty(goApp, 'prodconubicacion', '')
	Endif
	If !Pemstatus(goApp, 'prodconimagenes', 5) Then
		AddProperty(goApp, 'prodconimagenes', '')
	Endif
	lC = 'FUNCREAPRODUCTOS'
	cur = "Xn"
	goApp.npara1 = This.cdesc
	goApp.npara2 = This.cUnid
	goApp.npara3 = This.nprec
	goApp.npara4 = This.ncosto
	goApp.npara5 = This.np1
	goApp.npara6 = This.np2
	goApp.npara7 = This.np3
	goApp.npara8 = This.npeso
	goApp.npara9 = This.ccat
	goApp.npara10 = This.cmar
	goApp.npara11 = This.ctipro
	goApp.npara12 = This.nflete
	goApp.npara13 = This.cm
	goApp.npara14 = This.cidpc
	goApp.npara15 = This.ncome
	goApp.npara16 = This.ntigv
	goApp.npara17 = This.nutil1
	goApp.npara18 = This.nutil2
	goApp.npara19 = This.nutil3
	goApp.npara20 = This.nidusua
	goApp.npara21 = This.nsmax
	goApp.npara22 = This.nsmin
	goApp.npara23 = This.ccodigo1
	goApp.npara24 = This.ndolar
	Do Case
	Case goApp.prodconubicacion = 'S'
		goApp.npara25 = _Screen.oProductos.cubi1
		TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
	      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
		ENDTEXT
	Case goApp.prodConimagenes='S'
		goApp.npara25 =This.imagen
		TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
	      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
		ENDTEXT
	Otherwise
		TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
	      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24)
		ENDTEXT
	Endcase
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1
		Return 0
	Endif
	Return nid
	Endfunc
	Function Creaproducto4()
	lC = 'FUNCREAPRODUCTOS'
	cur = "Xn"
	goApp.npara1 = This.cdesc
	goApp.npara2 = This.cUnid
	goApp.npara3 = This.nprec
	goApp.npara4 = This.ncosto
	goApp.npara5 = This.np1
	goApp.npara6 = This.np2
	goApp.npara7 = This.np3
	goApp.npara8 = This.npeso
	goApp.npara9 = This.ccat
	goApp.npara10 = This.cmar
	goApp.npara11 = This.ctipro
	goApp.npara12 = This.nflete
	goApp.npara13 = This.Moneda
	goApp.npara14 = Id()
	goApp.npara15 = This.ncome
	goApp.npara16 = This.ncomc
	goApp.npara17 = This.nutil1
	goApp.npara18 = This.nutil2
	goApp.npara19 = This.nutil3
	goApp.npara20 = goApp.nidusua
	goApp.npara21 = This.nsmax
	goApp.npara22 = This.nsmin
	goApp.npara23 = This.ccodigo1
	goApp.npara24 = This.ndolar
	goApp.npara25 = This.nutil0
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function editarproducto4()
	Local cur As String
	lC = 'PROACTUALIZAPRODUCTOS'
	goApp.npara1 = This.cdesc
	goApp.npara2 = This.cUnid
	goApp.npara3 = This.ncosto
	goApp.npara4 = This.np1
	goApp.npara5 = This.np2
	goApp.npara6 = This.np3
	goApp.npara7 = This.npeso
	goApp.npara8 = This.ccat
	goApp.npara9 = This.cmar
	goApp.npara10 = This.ctipro
	goApp.npara11 = This.nflete
	goApp.npara12 = This.Moneda
	goApp.npara13 = This.nprec
	goApp.npara14 = This.ccodigo1
	goApp.npara15 = This.nutil1
	goApp.npara16 = This.nutil2
	goApp.npara17 = This.nutil3
	goApp.npara18 = This.ncome
	goApp.npara19 = This.ncomc
	goApp.npara20 = This.nidusua
	goApp.npara21 = This.nidart
	goApp.npara22 = This.nsmax
	goApp.npara23 = This.nsmin
	goApp.npara24 = This.ccodigo1
	goApp.npara25 = This.ndolar
	goApp.npara26 = This.Cestado
	goApp.npara27 = This.nutil0
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26,?goapp.npara27)
	ENDTEXT
	If  This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.Actualizacostos1() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Actualizacostos1()
	lC = 'PROACTUALIZACOSTOS'
	goApp.npara1 = This.nidcosto
	goApp.npara2 = This.costosflete
	goApp.npara3 = This.mflete
	goApp.npara4 = This.costoneto
	goApp.npara5 = This.Moneda
	goApp.npara6 = This.ndolar
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
	ENDTEXT
	If This.EJECUTARP(lC, lp, '') < 1 Then
		Return  0
	Endif
	Return 1
	Endfunc
	Function EditarProducto()
*np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25, np26)
*	cdesc, cunid, ncosto, np1, np2, np3, npeso, ccat, cmar, ctipro, nflete, cm, Nprecio, ccoda1, nutil1, nutil2, nutil3, ncome, ncomc, nidus, ncoda, nsmax, nsmin, Tigv, ndolar, ce) < 1 Then
	If !Pemstatus(goApp, 'prodconubicacion', 5) Then
		AddProperty(goApp, 'prodconubicacion', '')
	Endif
	If !Pemstatus(goApp, 'prodconimagenes', 5) Then
		AddProperty(goApp, 'prodconimagenes', '')
	Endif
	Local cur As String
	lC = 'PROACTUALIZAPRODUCTOS'
	goApp.npara1 = This.cdesc
	goApp.npara2 = This.cUnid
	goApp.npara3 = This.ncosto
	goApp.npara4 = This.np1
	goApp.npara5 = This.np2
	goApp.npara6 = This.np3
	goApp.npara7 = This.npeso
	goApp.npara8 = This.ccat
	goApp.npara9 = This.cmar
	goApp.npara10 = This.ctipro
	goApp.npara11 = This.nflete
	goApp.npara12 = This.cm
	goApp.npara13 = This.nprec
	goApp.npara14 = This.ccodigo1
	goApp.npara15 = This.nutil1
	goApp.npara16 = This.nutil2
	goApp.npara17 = This.nutil3
	goApp.npara18 = This.ncome
	goApp.npara19 = This.ncomc
	goApp.npara20 = This.nidusua
	goApp.npara21 = This.nidart
	goApp.npara22 = This.nsmax
	goApp.npara23 = This.nsmin
	goApp.npara24 = This.ntigv
	goApp.npara25 = This.ndolar
	goApp.npara26 = This.Cestado
*!*
*!*		goApp.npara1 = np1
*!*		goApp.npara2 = np2
*!*		goApp.npara3 = np3
*!*		goApp.npara4 = np4
*!*		goApp.npara5 = np5
*!*		goApp.npara6 = np6
*!*		goApp.npara7 = np7
*!*		goApp.npara8 = np8
*!*		goApp.npara9 = np9
*!*		goApp.npara10 = np10
*!*		goApp.npara11 = np11
*!*		goApp.npara12 = np12
*!*		goApp.npara13 = np13
*!*		goApp.npara14 = np14
*!*		goApp.npara15 = np15
*!*		goApp.npara16 = np16
*!*		goApp.npara17 = np17
*!*		goApp.npara18 = np18
*!*		goApp.npara19 = np19
*!*		goApp.npara20 = np20
*!*		goApp.npara21 = np21
*!*		goApp.npara22 = np22
*!*		goApp.npara23 = np23
*!*		goApp.npara24 = np24
*!*		goApp.npara25 = np25
*!*		goApp.npara26 = np26
	Do Case
	Case  goApp.prodconubicacion = 'S'
		goApp.npara27 = _Screen.oProductos.cubi1
		TEXT To lp Noshow
    (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26,?goapp.npara27)
		ENDTEXT
	Case goApp.prodConimagenes='S'
		goApp.npara27 = This.imagen
		TEXT To lp Noshow
    (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26,?goapp.npara27)
		ENDTEXT
	Otherwise
		TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26)
		ENDTEXT
	Endcase
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ListarPrecios()
	Endfunc
	Function MostrarSolounproducto(np1, Calias)
	Local lC, lp
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	m.lC		 = "PROMUESTRAP1"
	goApp.npara1 = m.np1
	goApp.npara2 = fe_gene.dola
	TEXT To m.lp Noshow
     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(m.lC, m.lp, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function CreaProductosXm1(opr)
	Local lC, lp
*:Global cur
	m.lC		  = 'FUNCREAPRODUCTOS'
	cur			  = "Xn"
	goApp.npara1  = opr.cdesc
	goApp.npara2  = opr.cUnid
	goApp.npara3  = opr.nprec
	goApp.npara4  = opr.ncosto
	goApp.npara5  = opr.np1
	goApp.npara6  = opr.np2
	goApp.npara7  = opr.np3
	goApp.npara8  = opr.npeso
	goApp.npara9  = opr.ccat
	goApp.npara10 = opr.cmar
	goApp.npara11 = opr.ctipro
	goApp.npara12 = 1
	goApp.npara13 = opr.cm
	goApp.npara14 = opr.cidpc
	goApp.npara15 = opr.ncome
	goApp.npara16 = opr.ncomc
	goApp.npara17 = opr.nutil1
	goApp.npara18 = opr.nutil2
	goApp.npara19 = opr.nutil3
	goApp.npara20 = opr.nidusua
	goApp.npara21 = opr.nsmax
	goApp.npara22 = opr.nsmin
	goApp.npara23 = opr.nidcosto
	goApp.npara24 = opr.ndolar
	goApp.npara25 = opr.ccoda
	goApp.npara26 = opr.crefe
	goApp.npara27 = opr.nflete
	goApp.npara28 = opr.nutil4
	goApp.npara29 = opr.nutil5
	TEXT To m.lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,
      ?goapp.npara26,?goapp.npara27,?goapp.npara28,?goapp.npara29)
	ENDTEXT
	nidproducto = This.EJECUTARf(m.lC, m.lp, cur)
	If nidproducto < 1 Then
		Return 0
	Endif
	Return nidproducto
	Endfunc
	Function ModificaProductosXM1(opr)
	Local cur As String
	lC = 'PROACTUALIZAPRODUCTOS'
	cur = ""
	goApp.npara1  = opr.cdesc
	goApp.npara2  = opr.cUnid
	goApp.npara3  = opr.ncosto
	goApp.npara4  = opr.np1
	goApp.npara5  = opr.np2
	goApp.npara6  = opr.np3
	goApp.npara7  = opr.npeso
	goApp.npara8 = opr.ccat
	goApp.npara9 = opr.cmar
	goApp.npara10 = opr.ctipro
	goApp.npara11 = 1
	goApp.npara12 = opr.cm
	goApp.npara13 = opr.nprec
	goApp.npara14 = opr.nflete
	goApp.npara15 = opr.nutil1
	goApp.npara16 = opr.nutil2
	goApp.npara17 = opr.nutil3
	goApp.npara18 = opr.ncome
	goApp.npara19 = opr.ncomc
	goApp.npara20 = opr.nidusua
	goApp.npara21 = opr.ncoda
	goApp.npara22 = opr.nsmax
	goApp.npara23 = opr.nsmin
	goApp.npara24 = opr.crefe
	goApp.npara25 = opr.ndolar
	goApp.npara26 = opr.ce
	goApp.npara27 = opr.ccoda
	goApp.npara28 = opr.nutil4
	goApp.npara29 = opr.nutil5
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26,?goapp.npara27,?goapp.npara28,?goapp.npara29)
	ENDTEXT
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
*************************
	Function MuestraCostosParaVenta(np1, Ccursor)
	Local lC, lp
	m.lC		 = 'ProMuestraCostosParaVenta'
	goApp.npara1 = m.np1
	TEXT To m.lp Noshow
     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(m.lC, m.lp, m.Ccursor) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function MuestraStockcontable(np1, ccur)
	lC = 'ProMuestraStockC'
	goApp.npara1 = np1
	TEXT To lp Noshow
   (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(lC, lp, ccur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizaCodigoFabricantebloque(Ccursor)
	Ab = 1
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	This.contransaccion = 'S'
	Select (Ccursor)
	Go Top
	Do While !Eof()
		nidart = xlpr.idart
		cdeta = xlpr.prod_cod1
		TEXT To lC Noshow Textmerge
		    UPDATE fe_art SET prod_cod1='<<cdeta>>' WHERE idart=<<nidart>>
		ENDTEXT
		If This.Ejecutarsql(lC) < 1 Then
			Ab = 0
			Exit
		Endif
		Select xlpr
		Skip
	Enddo
	If Ab = 0 Then
		If This.DEshacerCambios() >= 1 Then
			This.Cmensaje = "Se Deshacieron los Cambios Ok"
			Return 0
		Else
			This.Cmensaje = "No Se Deshacieron los Cambios Ok"
			Return 0
		Endif
	Else
		If This.GRabarCambios() < 1 Then
			Return 0
		Else
			Return 1
		Endif
	Endif
	Endfunc
	Function listarofertas(Calias)
	TEXT To lC Noshow Textmerge
	     SELECT idart as codigo,descri as producto,unid as unidad,uno,dos,tre,cua,cin,sei,
	     IFNULL(ROUND(IF(tmon='S',((a.prec*v.igv)+b.prec)*prod_uti0,((a.prec*v.igv*IF(prod_dola>v.dola,prod_dola,v.dola)))*prod_uti0)+b.prec,2),0) AS precioferta,prod_ocan as cantidad
	     fROM fe_art  as a
	     inner join fe_fletes as b  on b.idflete=a.idflete,
	     fe_gene as v
	     WHERE prod_acti='A' AND prod_uti0>0 ORDER BY descri
	ENDTEXT
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarofertas1(Calias)
	TEXT To lC Noshow Textmerge
	     SELECT idart as codigo,descri as producto,unid as unidad,uno,dos,tre,
	     IFNULL(ROUND(IF(tmon='S',((a.prec*v.igv)+b.prec)*prod_uti0,((a.prec*v.igv*IF(prod_dola>v.dola,prod_dola,v.dola))+b.prec)*prod_uti0),2),0) AS precioferta,prod_ocan as cantidad
	     fROM fe_art  as a
	     inner join fe_fletes as b  on b.idflete=a.idflete,
	     fe_gene as v
	     WHERE prod_acti='A' AND prod_uti0>0 ORDER BY descri
	ENDTEXT
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function GrabarOfertascontidadyprecio(np1, np2, np3, np4)
	TEXT To lC Noshow  Textmerge
	UPDATE fe_art SET prod_uti0=<<np2>>,prod_ocan=<<np3>>,prod_ocom=<<np4>> where idart=<<np1>>
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizaStock(ncoda, nalma, ncant, Ctipo)
	lC = "astock"
	TEXT To lpstock Noshow Textmerge
     (<<ncoda>>,<<nalma>>,<<ncant>>,'<<ctipo>>')
	ENDTEXT
	If This.EJECUTARP(lC, lpstock) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Actualizastock1()
	lC = "PROACTUALIZASTOCK"
	TEXT To Lp Noshow Textmerge
	(<<this.ncoda>>,<<this.codt>>,<<this.ncant>>,'<<this.Ctipo>>',<<this.ncaant>>)
	ENDTEXT
	If This.EJECUTARP(lC, lp) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Actualizastockunidades()
	lC = "ASTOCK"
	TEXT To Lp Noshow Textmerge
	(<<this.ncoda>>,<<this.codt>>,<<this.ncant>>,'<<this.Ctipo>>',<<this.nequi>>)
	ENDTEXT
	If This.EJECUTARP(lC, lp) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarkardexproducto(ccoda, dfechaI, dfechaf, Calmacen, Ccursor)
	TEXT To lC Noshow Textmerge
	   SELECT ifnull(e.ndoc,'')  as nped,d.ndo2,d.fech,d.ndoc,d.tdoc,a.tipo,d.mone as cmoneda,a.cant,d.fusua,ifnull(g.nomb,'') as usua1,
	   a.prec,d.vigv as igv,d.dolar,f.nomb as usua,d.idcliente as codc,b.razo AS cliente,d.idprov as codp,c.razo AS proveedor,d.deta,a.alma
	   FROM fe_kar as a
	   inner JOIN fe_rcom as d on (d.idauto=a.idauto)
	   left join fe_prov as c ON(d.idprov=c.idprov)
	   left JOIN fe_clie as b ON(d.idcliente=b.idclie)
	   LEFT JOIN fe_rped as e ON(e.idautop=d.idautop)
	   inner join fe_usua as f ON(f.idusua=d.idusua)
	   left join fe_usua as g ON (g.idusua=d.idusua1)
	   WHERE a.idart=<<ccoda>> and d.acti<>'I' and d.fech between '<<dfechai>>' and  '<<dfechaf>>' and a.acti<>'I' AND a.alma=<<calmacen>> ORDER BY d.fech,d.tipom,a.idkar
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return  0
	Endif
	Return 1
	Endfunc
	Function MuestraProductos1(np1, np2, Ccursor)
	lC = 'PROMUESTRAPRODUCTOS'
	goApp.npara1 = np1
	goApp.npara2 = np2
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function CalCularStock()
	lC = 'calcularstock()'
	If This.EJECUTARP(lC, "", "") < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'Stock Calculado'
	Return 1
	Endfunc
	Function MuestraProductosDescCod2(np1, np2, np3, np4, Ccursor)
	Local lC, lp
	If goApp.nube = 'S' Then
		m.lC		 = 'PROMUESTRAPRODUCTOS2'
	Else
		m.lC		 = 'PROMUESTRAPRODUCTOS1'
	Endif
	goApp.npara1 = m.np1
	goApp.npara2 = m.np2
	goApp.npara3 = m.np3
	goApp.npara4 = m.np4
	TEXT To m.lp Noshow
   (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	ENDTEXT
	If This.EJECUTARP10(m.lC, m.lp, m.Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function VAlidar()
	Do Case
	Case  Empty(This.cdesc)
		This.Cmensaje = 'Ingrese Nombre de producto'
		Return 0
	Case  Empty(This.cUnid)
		This.Cmensaje = 'Ingrese Unidad'
		Return 0
	Case  This.ccat = 0
		This.Cmensaje = 'Ingrese Linea de Producto'
		Return 0
	Case  This.cmar = 0
		This.Cmensaje = 'Ingrese Marca de Producto'
		Return 0
	Case This.nflete = 0
		This.Cmensaje = 'Ingrese Costo de Flete de Producto'
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function agratuito(opt)
	If opt = 1 Then
		If This.ncosto = 0 Then
			This.Cmensaje = 'Ingrese Costo del producto'
			Return 0
		Endif
		TEXT To lC Noshow Textmerge
	    UPDATE fe_art SET prod_grat='S' WHERE idart=<<this.ncoda>>
		ENDTEXT
	Else
		TEXT To lC Noshow Textmerge
	     UPDATE fe_art SET prod_grat='N' WHERE idart=<<this.ncoda>>
		ENDTEXT
	Endif
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ultimaventa(ncoda, Ccursor)
	TEXT To lC Noshow Textmerge
	SELECT c.razo,fech,ndoc,prec FROM fe_kar AS k
	INNER JOIN fe_rcom AS r ON r.idauto=k.idauto
	INNER JOIN fe_clie AS c ON c.idclie=r.idcliente
	WHERE idart=<<ncoda>> AND k.acti='A' AND r.acti='A' order by fech desc LIMIT 1
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ultimacompra(ncoda, Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select c.razo,r.fech,ndoc,IFNULL(k.Prec*z.igv,0) As Prec,r.mone From fe_kar As k
	\INNER Join fe_rcom As r On r.idauto=k.idauto
	\INNER Join fe_prov As c On c.idprov=r.idprov,fe_gene As z
	\ Where
	If Vartype(cnoda) = 'N' Then
	\ idart=<<ncoda>>
	Else
	\ idart='<<ncoda>>'
	Endif
	\ And k.Acti='A' And r.Acti='A' And k.tipo='C' And tdoc='01' Order By r.fech Desc  LIMIT 1
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarpormarcaylinea(Calias)
	Set DataSession To This.Idsesion
	Do Case
	Case This.cmar = 0 And This.ccat = 0
		TEXT To lC Noshow Textmerge
	     select idart,descri,unid,uno as tienda,dos as almacen,tre as interno,idmar,idcat FROM fe_art where prod_acti<>'I' order by idart
		ENDTEXT
	Case This.ccat > 0 And This.cmar > 0
		TEXT To lC Noshow Textmerge
        select idart,descri,unid,uno as tienda,dos as almacen,tre as interno,idmar,idcat FROM fe_art where prod_acti<>'I' and idcat=<<this.ccat>> and idmar=<<this.cmar>> order by idart
		ENDTEXT
	Case This.ccat > 0 And This.cmar = 0
		TEXT To lC Noshow Textmerge
        select idart,descri,unid,uno as tienda,dos as almacen,tre as interno,idmar,idcat FROM fe_art  where prod_acti<>'I' and idcat=<<this.ccat>> order by idart
		ENDTEXT
	Case This.ccat = 0 And This.cmar > 0
		TEXT To lC Noshow Textmerge
        select idart,descri,unid,uno as tienda,dos as almacen,tre as interno,idmar,idcat FROM fe_art  where prod_acti<>'I' and idmar=<<this.cmar>> order by idart
		ENDTEXT
	Endcase
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function calcularstockproducto(nidart, nalma, Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lC Noshow Textmerge
	 SELECT a.tcompras- a.tventas as stock
	 FROM (SELECT b.idart,SUM(IF(b.tipo='C',b.cant,0)) AS tcompras,SUM(IF(b.tipo='V',b.cant,0)) AS tventas,b.alma
	 FROM fe_kar AS b WHERE b.acti<>'I' and b.alma=<<nalma>> and b.idart=<<nidart>> GROUP BY  idart) AS a;
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraTProductosDescCod(np1, np2, np3, np4, Ccursor)
	lC = 'PromuestraTodoslosproductos'
	goApp.npara1 = Chrtran(m.np1, ' ', '%')
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	ENDTEXT
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarmvtos(Ccursor)
	dfi = Cfechas(fe_gene.fech - 90)
	dff = Cfechas(fe_gene.fech)
	TEXT To lC Noshow Textmerge
	    SELECT  b.razo,c.fech,cant,ROUND(prec*c.vigv,2) AS prec,c.mone,c.tdoc,c.ndoc,a.tipo,a.idart,a.tipo
		FROM fe_rcom  AS c
		INNER JOIN fe_prov AS b ON (b.idprov=c.idprov)
		INNER JOIN fe_kar AS a   ON(a.idauto=c.idauto)
		WHERE  c.acti='A' AND a.acti='A' AND fech BETWEEN '<<dfi>>' AND '<<dff>>'
		UNION ALL
		SELECT b.razo,c.fech,cant,prec,c.mone,c.tdoc,c.ndoc,a.tipo,a.idart,a.tipo FROM fe_rcom AS c
	    INNER JOIN fe_clie AS b ON (b.idclie=c.idcliente)
	    INNER JOIN  fe_kar AS a   ON(a.idauto=c.idauto)
	  	WHERE c.acti='A' AND a.acti='A' AND fech BETWEEN '<<dfi>>' AND '<<dff>>'
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function MuestraTProductos(np1, np2, Ccursor)
	lC = 'PROMUESTRATPRODUCTOS'
	goApp.npara1 = np1
	goApp.npara2 = np2
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function condetraccionunidades(dfi, dff, nmonto, ntienda, Calias)
	fi = Cfechas(dfi)
	ff = Cfechas(dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	    \Select ndoc,fech,iden,referencia,Sum(importe) As importe,prod_detr,Sum(Round((importe*prod_detr)/100,2)) As montod,alma,Impo,idauto
	    \From(Select a.idart As coda,z.Descri,a.kar_unid As unid,a.cant,If(b.mone="S",a.Prec,a.Prec*b.dolar) As Prec,
	    \If(b.mone="S",cant*a.Prec,cant*a.Prec*b.dolar) As importe,b.ndoc,b.fech,If(tdoc='03',e.ndni,e.nruc) As iden,b.Impo,b.idauto,
	    \e.razo As referencia,a.alma,z.prod_detr From fe_kar As a
		\INNER Join fe_art As z On z.idart=a.idart
		\INNER Join fe_rcom As b On b.idauto=a.idauto
		\INNER Join fe_clie As e On e.idclie=b.idcliente
		\Where a.Acti='A' And b.Acti='A' And b.fech Between '<<fi>>' And '<<ff>>' And z.prod_detr>0 And b.tdoc='01') As x
	If ntienda > 0 Then
		  \ And b.codt=<<ntienda>>)
	Endif
		\Where Impo><<nm>> Group By idauto,ndoc,iden,referencia,alma,Impo,prod_detr Order By fech
	Set Textmerge To
	Set Textmerge Off
	This.conconexion = 1
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		This.conconexion = 0
		Return 0
	Endif
	This.conconexion = 0
	Return 1
	Endfunc
	Function Condetraccion(dfi, dff, nmonto, ntienda, Calias)
	fi = Cfechas(dfi)
	ff = Cfechas(dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	    \Select ndoc,fech,iden,referencia,Sum(importe) As importe,prod_detr,Sum(Round((importe*prod_detr)/100,2)) As montod,alma,Impo,idauto
	    \From(Select a.idart As coda,z.Descri,z.unid,a.cant,If(b.mone="S",a.Prec,a.Prec*b.dolar) As Prec,
	    \If(b.mone="S",cant*a.Prec,cant*a.Prec*b.dolar) As importe,b.ndoc,b.fech,If(tdoc='03',e.ndni,e.nruc) As iden,b.Impo,b.idauto,
	    \e.razo As referencia,a.alma,z.prod_detr From fe_kar As a
		\INNER Join fe_art As z On z.idart=a.idart
		\INNER Join fe_rcom As b On b.idauto=a.idauto
		\INNER Join fe_clie As e On e.idclie=b.idcliente
		\Where a.Acti='A' And b.Acti='A' And b.fech Between '<<fi>>' And '<<ff>>' And z.prod_detr>0 And b.tdoc='01'
	If ntienda > 0 Then
		  \ And b.codt=<<ntienda>>
	Endif
		\) As x
		\Where Impo><<nm>> Group By idauto,ndoc,iden,referencia,alma,Impo,prod_detr Order By fech
	Set Textmerge Off
	Set Textmerge To
	This.conconexion = 1
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		This.conconexion = 0
		Return 0
	Endif
	This.conconexion = 0
	Return 1
	Endfunc
	Function activar(nidart)
	TEXT To lC Noshow Textmerge
		UPDATE fe_art SET prod_acti='A' WHERE idart=<<nidart>>
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function DesactivaProductos(np1)
	Ccursor = 'c_' + Sys(2015)
	TEXT To lC Noshow Textmerge
     SELECT SUM(IF(tipo='C',cant,-cant)) as stock FROM fe_kar WHERE acti='A' AND idart=<<np1>> GROUP BY idart
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If stock <> 0 Then
		This.Cmensaje = "Tiene Stock NO es Posible Desactivar " + Alltrim(Str(stock, 12, 2))
		Return 0
	Endif
	TEXT To lp Noshow Textmerge
         UPDATE fe_art SET prod_acti='I' WHERE idart=<<np1>>
	ENDTEXT
	If This.Ejecutarsql(lp) < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'Desactivado Ok'
	Return 1
	Endfunc
	Function listarinactivos(np1, opt, Calias)
	cbuscar = '%' + Alltrim(np1) + '%'
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\   Select idart,Descri,unid,uno,Dos,tre,cua,cero,c.idgrupo,c.dcat,prod_dola,m.dmar,
	\	prod_cod1, peso,a.Prec,tipro,a.idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,
    \	prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin,
	\	ulfc,prod_ent1,prod_ent2,prod_icbper,g.idgrupo,g.desgrupo As grupo,prod_acti
	\	From fe_art  As a
	\	INNER Join fe_fletes As b On(b.idflete=a.idflete)
	\	INNER Join fe_mar As m On m.idmar=a.idmar
	\	INNER Join fe_cat As c On(c.idcat=a.idcat)
	\	INNER Join fe_grupo As g On g.idgrupo=c.idgrupo,fe_gene As v
	\   Where prod_acti='I'
	If opt = 1 Then
		\	And Descri Like '<<cbuscar>>'
	Else
		\   And prod_cod1 Like '<<cbuscar>>'
	Endif
	\	Order By Descri;
	Set Textmerge Off
	Set Textmerge To
	This.conconexion = 1
	If This.EJECutaconsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraProductosconstock(np1, np2, Ccursor)
	If !Pemstatus(goApp, 'soloconstock', 5) Then
		AddProperty(goApp, 'soloconstock', '')
	Endif
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	If goApp.Soloconstock = 'S' Then
		lC = 'ProMuestraProductosconstock'
		goApp.npara1 = np1
		goApp.npara2 = np2
		goApp.npara3  = This.constock
		TEXT To lp Noshow
        (?goapp.npara1,?goapp.npara2,?goapp.npara3)
		ENDTEXT
	Else
		lC = 'ProMuestraProductos'
		goApp.npara1 = np1
		goApp.npara2 = np2
		TEXT To lp Noshow
        (?goapp.npara1,?goapp.npara2)
		ENDTEXT
	Endif
	This.conconexion = 1
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarCostosYprecios(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	cwhere = ""
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
    \Select prod_cod1,g.desgrupo As grupo,l.dcat As linea,Descri,m.dmar As marca,unid,
	If goApp.Productoscp = 'S' Then
      \uno+Dos+tre+cua+cin As Tstock,a.tmon,
	Else
       \uno+Dos+tre+cua As Tstock,a.tmon,
	Endif
    \If(tmon='S',a.Prec*b.igv,Cast(0 As Decimal(12,2))) As costosoles,If(tmon='D',a.Prec*b.igv,Cast(0 As Decimal(12,2))) As costodolares,
    \Round(If(tmon='S',(a.Prec*b.igv),(a.Prec*b.igv*b.dola)),2) As costosf,
    \Round(If(tmon='S',(a.Prec*b.igv)+c.Prec,(a.Prec*b.igv*b.dola)+c.Prec),2) As costo,
    \If(a.prod_uti1>0,(a.prod_uti1*100)-100,Cast(0 As Decimal(10,6))) As uti1,
    \IFNULL(Round(If(tmon='S',((a.Prec*b.igv)+c.Prec)*prod_uti1,((a.Prec*b.igv*b.dola)+c.Prec)*prod_uti1),2),0) As pre1,
    \If(a.prod_uti2>0,(a.prod_uti2*100)-100,Cast(0 As Decimal(10,6))) As uti2,
    \IFNULL(Round(If(tmon='S',((a.Prec*b.igv)+c.Prec)*prod_uti2,((a.Prec*b.igv*b.dola)+c.Prec)*prod_uti2),2),0) As pre2,
    \If(a.prod_uti3>0,(a.prod_uti3*100)-100,Cast(0 As Decimal(10,6))) As uti3,
    \IFNULL(Round(If(tmon='S',Round(a.Prec*b.igv+c.Prec,2)*prod_uti3,((a.Prec*b.igv*b.dola)+c.Prec)*prod_uti3),2),0) As pre3,
    \ulfc,a.idmar,a.idcat,'N' As Modi,idart
    \From fe_art  As a
    \INNER Join fe_fletes As c On c.idflete=a.idflete
    \INNER Join fe_cat As l On l.idcat=a.idcat
    \INNER Join fe_grupo As g On g.idgrupo=l.idgrupo
    \INNER Join fe_mar As m On m.idmar=a.idmar,  fe_gene As b
	If This.Cestado = 'A' Then
		\Where prod_acti <> 'I'
		cwhere = 'S'
	Endif
	If This.cmar > 0 Then
		If cwhere = 'S' Then
	       \ And a.idmar=<<This.cmar>>
		Else
	        \ Where  a.idmar=<<This.cmar>>
			cwhere = 'S'
		Endif
	Endif
	If This.ccat > 0 Then
		If cwhere = 'S' Then
	       \ And a.idcat=<<This.ccat>>
		Else
	        \ Where  a.idcat=<<This.ccat>>
		Endif
	Endif
	\ Order By a.Descri
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function rotacion()
	Set Textmerge On
	Set Textmerge To lC Memvar Noshow
	\Select	prod_cod1,z.idart As coda,z.Descri,z.unid,IFNULL(cant,Cast(0 As Decimal(10,2))) As cant,IFNULL(importe,Cast(0 As Decimal(12,2))) As importe,IFNULL(mes,0) As mes,
	\m.dmar As marca,Cast(0 As Decimal(2)) As alma,c.dcat As linea,g.desgrupo As grupo
	\From fe_art As z
	\Left Join (Select  idart,Sum(a.cant) As cant,If(b.mone="S",Sum(cant*a.Prec),Sum(cant*a.Prec*b.dolar)) As importe,
	\Cast(Month(b.fech) As Decimal(2))  As mes From fe_kar As a
	\INNER Join fe_rcom As b On b.idauto=a.idauto
	\Where  a.Acti='A' And b.Acti='A' And b.fech Between '<<dfi>>' And '<<dff>>'   And tdoc Not In("AJ","II")
	If This.cmarca > 0 Then
	  \ And
	Endif
	If This.clinea > 0 Then

	Endif
	If This.ncodt > 0 Then

	Endif
	\ Group By idart) As a
	\On a.idart=z.idart
	\INNER Join fe_mar As m On m.`idmar`=z.`idmar`
	\INNER Join fe_cat As c On c.idcat=z.idcat
	\ INNER Join fe_grupo As g On g.idgrupo=c.idgrupo
	\Where  z.prod_acti='A'
	Endfunc
	Function ActualizaProveedorxsys3(nidproveedor)
	TEXT To lC Noshow  Textmerge
	  UPDATE fe_art SET ulpc=<<nidproveedor>> where idart=<<This.ncoda>>
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizaProveedor(nidproveedor)
	TEXT To lC Noshow  Textmerge
	  UPDATE fe_art SET idprov=<<nidproveedor>> where idart=<<This.ncoda>>
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarstockminmax(Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow  Textmerge
	\Select  idart, prod_cod1 As codigo, Descri, unid, m.dmar As marca, c.dcat As categoria,
	\g.desgrupo As grupo, uno, Dos, tre, cua, uno + Dos + tre + cua As Tstock
	If 	This.nsmin	   = 1 Then
	    \,prod_smin, prod_smin - (uno + Dos + tre + cua) As Dife1
	Endif
	If This.nsmax = 1  Then
	   \,prod_smax, prod_smax - (uno + Dos + tre + cua) As Dife2
	Endif
	If This.cdetalle = 'S' Then
	  \ ,prod_deta,prod_ubi1,prod_ubi2,prod_ubi3,prod_ubi4,prod_ubi5,prod_codb
	Endif
	\ From fe_art As a
	\INNER Join fe_mar As m On m.idmar = a.idmar
	\INNER Join fe_cat As c On c.idcat = a.idcat
	\INNER Join fe_grupo As g On g.idgrupo = c.idgrupo
	\Where prod_acti <> 'I'
	If This.cmar > 0 Then
	    \ And a.idmar=<<This.cmar>>
	Endif
	If This.ccat > 0 Then
	    \ And a.idcat=<<This.ccat>>
	Endif
	If 	This.nsmin	   = 1 Then
	    \ And prod_smin - (uno + Dos + tre + cua)>0
	Endif
	If This.nsmax = 1  Then
	    \ And prod_smax - (uno + Dos + tre + cua)>0
	Endif
	\ Order By Descri
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Actualizadetalleyotros(Ccursor)
	Ab = 1
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	Go Top
	Do While !Eof()
		nidart = xlpr.idart
		cdeta = xlpr.prod_deta
		TEXT To lC Noshow Textmerge
		    UPDATE fe_art SET prod_deta='<<cdeta>>',prod_ubi1='<<xlpr.prod_ubi1>>',prod_ubi2='<<xlpr.prod_ubi2>>',prod_ubi3='<<xlpr.prod_ubi3>>',
		    prod_ubi4='<<xlpr.prod_ubi4>>',prod_ubi5='<<xlpr.prod_ubi5>>',prod_codb='<<xlpr.prod_codb>>',
		    prod_umin=<<xlpr.prod_umin>>,prod_umax=<<xlpr.prod_umax>>,prod_dmin=<<xlpr.prod_dmin>>,prod_dmax=<<xlpr.prod_dmax>>,
		    prod_tmin=<<xlpr.prod_tmin>>,prod_tmax=<<xlpr.prod_tmax>>  WHERE idart=<<nidart>>
		ENDTEXT
		If This.Ejecutarsql(lC) < 1 Then
			Ab = 0
			Exit
		Endif
		Select xlpr
		Skip
	Enddo
	If Ab = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function Actualizadetalleyotrosxproducto(nidart)
	cdeta = lpr.prod_deta
	TEXT To lC Noshow Textmerge
    UPDATE fe_art SET prod_deta='<<cdeta>>',prod_ubi1='<<lpr.prod_ubi1>>',prod_ubi2='<<lpr.prod_ubi2>>',prod_ubi3='<<lpr.prod_ubi3>>',
	prod_ubi4='<<lpr.prod_ubi4>>',prod_ubi5='<<lpr.prod_ubi5>>',prod_codb='<<lpr.prod_codb>>',
	prod_umin=<<lpr.prod_umin>>,prod_umax=<<lpr.prod_umax>>,prod_dmin=<<lpr.prod_dmin>>,prod_dmax=<<lpr.prod_dmax>>,
	prod_tmin=<<lpr.prod_tmin>>,prod_tmax=<<lpr.prod_tmax>>  WHERE idart=<<nidart>>
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function MuestraProductospsysr(np1, np2, np3, Ccursor)
	lC = 'PROMUESTRAPRODUCTOS'
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	If  This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarCostosYpreciosconofertas(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	cwhere = ""

*!*		 ROUND(prod_uti1*ROUND(IF(tmon='S',(a.prec*v.igv)+b.prec,(a.prec*v.igv*IF(prod_dola>nd,prod_dola,nd))+b.prec),2),0.5) AS pre1,
*!*		 ROUND(prod_uti2*ROUND(IF(tmon='S',(a.prec*v.igv)+b.prec,(a.prec*v.igv*IF(prod_dola>nd,prod_dola,nd))+b.prec),2),0.5) AS pre2,
*!*		 ROUND(prod_uti3*ROUND(IF(tmon='S',(a.prec*v.igv)+b.prec,(a.prec*v.igv*IF(prod_dola>nd,prod_dola,nd))+b.prec),2),0.5) AS pre3,
*!*
*!*		 ROUND(IF(tmon='S',(a.prec*v.igv)+b.prec,(a.prec*v.igv*IF(prod_dola>nd,prod_dola,nd))+b.prec),2) AS costo
*****
*  \IFNULL(Round(If(tmon='S',((a.Prec*b.igv)+c.Prec)*prod_uti1,((a.Prec*b.igv*b.dola)+c.Prec)*prod_uti1),2),0) As pre1,
*      \IFNULL(Round(If(tmon='S',((a.Prec*b.igv)+c.Prec)*prod_uti2,((a.Prec*b.igv*b.dola)+c.Prec)*prod_uti2),2),0) As pre2,
*        \IFNULL(Round(If(tmon='S',Round(a.Prec*b.igv+c.Prec,2)*prod_uti3,((a.Prec*b.igv*b.dola)+c.Prec)*prod_uti3),2),0) As pre3,
*   \IF(a.prod_uti0>1,ROUND(IF(tmon='S',((a.Prec*v.igv)+b.Prec)*prod_uti0,((a.prec*v.igv*nd)+b.prec)*prod_uti0),0.5),0) AS pre0,
*    \Round(If(tmon='S',(a.Prec*b.igv)+c.Prec,(a.Prec*b.igv*b.dola)+c.Prec),2) As costo,
*****
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
    \Select prod_cod1,g.desgrupo As grupo,l.dcat As linea,Descri,m.dmar As marca,unid,uno+Dos+tre+cua+cin As Tstock,a.tmon,
    \If(tmon='S',a.Prec*b.igv,Cast(0 As Decimal(12,2))) As costosoles,If(tmon='D',a.Prec*b.igv,Cast(0 As Decimal(12,2))) As costodolares,
    \Round(If(tmon='S',(a.Prec*b.igv),(a.Prec*b.igv*b.dola)),2) As costosf,
    \ROUND(IF(tmon='S',(a.prec*b.igv)+c.prec,(a.prec*b.igv*IF(prod_dola>b.dola,prod_dola,b.dola))+c.prec),2) AS costo,
    \If(a.prod_uti1>0,(a.prod_uti1*100)-100,Cast(0 As Decimal(10,6))) As uti1,
    \ROUND(prod_uti1*ROUND(IF(tmon='S',(a.prec*b.igv)+c.prec,(a.prec*b.igv*IF(prod_dola>b.dola,prod_dola,b.dola))+c.prec),2),0.5) AS pre1,
    \If(a.prod_uti2>0,(a.prod_uti2*100)-100,Cast(0 As Decimal(10,6))) As uti2,
    \ROUND(prod_uti2*ROUND(IF(tmon='S',(a.prec*b.igv)+c.prec,(a.prec*b.igv*IF(prod_dola>b.dola,prod_dola,b.dola))+c.prec),2),0.5) AS pre2,
    \If(a.prod_uti3>0,(a.prod_uti3*100)-100,Cast(0 As Decimal(10,6))) As uti3,
    \ROUND(prod_uti3*ROUND(IF(tmon='S',(a.prec*b.igv)+c.prec,(a.prec*b.igv*IF(prod_dola>b.dola,prod_dola,b.dola))+c.prec),2),0.5) AS pre3,
    \If(a.prod_uti0>0,(a.prod_uti0*100)-100,Cast(0 As Decimal(10,6))) As uti0,
    \IF(a.prod_uti0>1,ROUND(IF(tmon='S',((a.Prec*b.igv)+c.Prec)*prod_uti0,((a.prec*b.igv*b.dola)+c.prec)*prod_uti0),0.5),0) AS pre0,
    \ulfc,a.idmar,a.idcat,'N' As Modi,idart,prod_ocan,prod_cmay
    \From fe_art  As a
    \INNER Join fe_fletes As c On c.idflete=a.idflete
    \INNER Join fe_cat As l On l.idcat=a.idcat
    \INNER Join fe_grupo As g On g.idgrupo=l.idgrupo
    \INNER Join fe_mar As m On m.idmar=a.idmar,  fe_gene As b
	If This.Cestado = 'A' Then
		\Where prod_acti <> 'I'
		cwhere = 'S'
	Endif
	If This.cmar > 0 Then
		If cwhere = 'S' Then
	       \ And a.idmar=<<This.cmar>>
		Else
	        \ Where  a.idmar=<<This.cmar>>
			cwhere = 'S'
		Endif
	Endif
	If This.ccat > 0 Then
		If cwhere = 'S' Then
	       \ And a.idcat=<<This.ccat>>
		Else
	        \ Where  a.idcat=<<This.ccat>>
		Endif
	Endif
	\ Order By a.Descri
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function actualizapreciosventabloquelyg()
	If This.IniciaTransaccion() < 1
		Return 0
	Endif
	Ab = 1
	Select xlpr
	Scan All
		nu1 = (xlpr.uti1 / 100) + 1
		nu3 = (xlpr.uti3 / 100) + 1
		nu0 = (xlpr.uti0 / 100) + 1
		TEXT To lC Noshow Textmerge
		  UPDATE fe_art SET prod_uti1=<<nu1>>,prod_uti3=<<nu3>>,prod_uti0=<<nu0>>,prod_ocan=<<xlpr.prod_ocan>>,prod_cmay=<<xlpr.prod_cmay>> WHERE idart=<<xlpr.idart>>;
		ENDTEXT
		If This.Ejecutarsql(lC) < 1 Then
			Ab = 0
			Exit
		Endif
	Endscan
	If Ab = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If 	GRabarCambios() = 0 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function Creaproductolopez()
	lC = 'FUNCREAPRODUCTOS'
	cur = "Xn"
	goApp.npara1 = This.cdesc
	goApp.npara2 = This.cUnid
	goApp.npara3 = This.nprec
	goApp.npara4 = This.ncosto
	goApp.npara5 = This.np1
	goApp.npara6 = This.np2
	goApp.npara7 = This.np3
	goApp.npara8 = This.npeso
	goApp.npara9 = This.ccat
	goApp.npara10 = This.cmar
	goApp.npara11 = This.ctipro
	goApp.npara12 = This.nflete
	goApp.npara13 = This.Moneda
	goApp.npara14 = Id()
	goApp.npara15 = This.ncome
	goApp.npara16 = This.ncomc
	goApp.npara17 = This.nutil1
	goApp.npara18 = This.nutil2
	goApp.npara19 = This.nutil3
	goApp.npara20 = goApp.nidusua
	goApp.npara21 = This.nsmax
	goApp.npara22 = This.nsmin
	goApp.npara23 = This.nidcosto
	goApp.npara24 = This.ndolar
	goApp.npara25 = This.nutil0
	goApp.npara26 = This.duti1
	goApp.npara27 = This.duti2
	goApp.npara28 = This.duti3
	goApp.npara29 = This.duti0
	goApp.npara30 = This.ccodigo1
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,
      ?goapp.npara26,?goapp.7,?goapp.npara28,?goapp.npara29,?goapp.npara30)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function editarproductolopez()
*!*		cdesc, cunid, ncosto, np1, np2, np3, npeso, ccat, cmar,
*!*		 ctipro, nflete, cm, nprec, nidgrupo, nutil1, nutil2, nutil3, ncome, ncomc, goApp.nidusua, ncoda, nsmax, nsmin, nidcosto, ndolar, ce, nutil0
	Local cur As String
	lC = 'PROACTUALIZAPRODUCTOS'
	cur = ""
	goApp.npara1 = This.cdesc
	goApp.npara2 = This.cUnid
	goApp.npara3 = This.ncosto
	goApp.npara4 = This.np1
	goApp.npara5 = This.np2
	goApp.npara6 = This.np3
	goApp.npara7 = This.npeso
	goApp.npara8 = This.ccat
	goApp.npara9 = This.cmar
	goApp.npara10 = This.ctipro
	goApp.npara11 = This.nflete
	goApp.npara12 = This.Moneda
	goApp.npara13 = This.nprec
	goApp.npara14 = 0
	goApp.npara15 = This.nutil1
	goApp.npara16 = This.nutil2
	goApp.npara17 = This.nutil3
	goApp.npara18 = This.ncome
	goApp.npara19 = This.ncomc
	goApp.npara20 = goApp.nidusua
	goApp.npara21 = This.nidart
	goApp.npara22 = This.nsmax
	goApp.npara23 = This.nsmin
	goApp.npara24 = This.nidcosto
	goApp.npara25 = This.ndolar
	goApp.npara26 = This.Cestado
	goApp.npara27 = This.nutil0
	goApp.npara28 = This.duti1
	goApp.npara29 = This.duti2
	goApp.npara30 = This.duti3
	goApp.npara31 = This.duti0
	goApp.npara32 = This.ccodigo1
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,
      ?goapp.npara26,?goapp.npara27,?goapp.npara28,?goapp.npara29,?goapp.npara30,?goapp.npara31,?goapp.npara32)
	ENDTEXT
	If  This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.Actualizacostos1() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarStocks(nidart, Ccursor)
	If This.Idsesion>0 Then
		Set DataSession To This.Idsesion
	Endif
	lC = "PRODSTOCKS"
	TEXT To lp Noshow Textmerge
	(<<nidart>>)
	ENDTEXT
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizaStockfisicocontable()
	lC = "proactualizastock10"
	TEXT To lp Noshow Textmerge
     (<<this.nidart>>,<<this.nidtda>>,<<this.ncant>>,'<<this.ctipo>>',<<this.ncaant>>,'<<this.ctdoc>>')
	ENDTEXT
	If This.EJECUTARP(lC, lp) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Logsprecios(Ccursor)
	TEXT To lC Noshow Textmerge
	SELECT prod_fope as fecha,u.nomb as Usuario,prod_deta as Detalle FROM fe_aproductos a
	INNER JOIN fe_usua u ON u.idusua=a.prod_idus
	where prod_idar=<<this.nidart>> order by prod_fope desc
	ENDTEXT
	If This.EJECutaconsulta(lC, Ccursor) < 1
		Return  0
	Endif
	Return  1
	Endfunc
	Function ActualizaStockfisicocontablepsysu()
	lC = "proactualizastock10"
	TEXT To lp Noshow Textmerge
     (<<this.nidart>>,<<this.nidtda>>,<<this.ncant>>,'<<this.ctipo>>',<<this.nequi>>,<<this.ncaant>>,'<<this.ctdoc>>')
	ENDTEXT
*MESSAGEBOX(lp)
	If This.EJECUTARP(lC, lp) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarStockcontable(nidtda)
	Ccursor = 'C_' + Sys(2015)
	This.conerror = 0
	Do Case
	Case nidtda = 1
		TEXT To lp Noshow Textmerge
	    select prod_stoc1 as stock FROM fe_art WHERE idart=<<this.nidart>>
		ENDTEXT
	Case nidtda = 2
		TEXT To lp Noshow Textmerge
	    select prod_stoc2  as stock FROM fe_art WHERE idart=<<this.nidart>>
		ENDTEXT
	Endcase
	If This.EJECutaconsulta(lp, Ccursor) < 1 Then
		This.conerror = 1
		Return 0
	Endif
	Select (Ccursor)
	Return stock
	Endfunc
	Function consultastockpsysm(ntda, Ncantidad)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lC Noshow Textmerge
	SELECT IF(tipro='S',3500,uno) AS uno,IF(tipro='S',3500,dos) AS dos,
	IF(tipro='S',3500,tre) AS tre,IF(tipro='S',3500,cua) AS cua,IF(tipro='S',3500,cin) AS cin,
	IF(tipro='S',3500,sei) AS sei  FROM fe_art WHERE idart=<<this.nidart>>
	ENDTEXT
	Ccursor = 'c_' + Sys(2015)
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		This.conerror = 1
		Return 0
	Endif
	This.conerror = 0
	Select (Ccursor)
	Do Case
	Case ntda = 1
		Ts = uno
	Case ntda = 2
		Ts = Dos
	Case ntda = 3
		Ts = tre
	Case ntda = 4
		Ts = cua
	Case ntda = 5
		Ts = cin
	Case ntda = 6
		Ts = sei
	Endcase
	If Ncantidad > Ts Then
		Return 0
	Else
		Return  1
	Endif
	Endfunc
	Function Creaproductopsystr()
	lC = 'FUNCREAPRODUCTOS'
	cur = "Xn"
	TEXT To lp Noshow Textmerge
	  ('<<This.cdesc>>','<<This.cUnid>>',<<This.nprec>>,<<This.ncosto>>,<<This.np1>>,<<This.np2>>,<<This.np3>>,<<This.npeso>>,<<This.ccat>>,
      <<This.cmar>>,'<<This.ctipro>>',<<This.nflete>>,'<<This.Moneda>>','<<id()>>',<<This.ncome>>,<<This.ncomc>>,<<This.nutil1>>,
      <<This.nutil2>>,<<This.nutil3>>,<<This.nidusua>>,<<This.nsmax>>,<<This.nsmin>>,'<<This.ccodigo1>>',<<This.ndolar>>)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function editarproducto44()
	Local cur As String
	lC = 'PROACTUALIZAPRODUCTOS'
	goApp.npara1 = This.cdesc
	goApp.npara2 = This.cUnid
	goApp.npara3 = This.ncosto
	goApp.npara4 = This.np1
	goApp.npara5 = This.np2
	goApp.npara6 = This.np3
	goApp.npara7 = This.npeso
	goApp.npara8 = This.ccat
	goApp.npara9 = This.cmar
	goApp.npara10 = This.ctipro
	goApp.npara11 = This.nflete
	goApp.npara12 = This.Moneda
	goApp.npara13 = This.nprec
	goApp.npara14 = 0
	goApp.npara15 = This.nutil1
	goApp.npara16 = This.nutil2
	goApp.npara17 = This.nutil3
	goApp.npara18 = This.ncome
	goApp.npara19 = This.ncomc
	goApp.npara20 = This.nidusua
	goApp.npara21 = This.nidart
	goApp.npara22 = This.nsmax
	goApp.npara23 = This.nsmin
	goApp.npara24 = This.ccodigo1
	goApp.npara25 = This.ndolar
	goApp.npara26 = This.Cestado
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26)
	ENDTEXT
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Creaproducto5()
	lC = 'FUNCREAPRODUCTOS'
	cur = "Xn"
	goApp.npara1 = This.cdesc
	goApp.npara2 = This.cUnid
	goApp.npara3 = This.nprec
	goApp.npara4 = This.ncosto
	goApp.npara5 = This.np1
	goApp.npara6 = This.np2
	goApp.npara7 = This.np3
	goApp.npara8 = This.npeso
	goApp.npara9 = This.ccat
	goApp.npara10 = This.cmar
	goApp.npara11 = This.ctipro
	goApp.npara12 = This.nflete
	goApp.npara13 = This.Moneda
	goApp.npara14 = Id()
	goApp.npara15 = This.ncome
	goApp.npara16 = This.ncomc
	goApp.npara17 = This.nutil1
	goApp.npara18 = This.nutil2
	goApp.npara19 = This.nutil3
	goApp.npara20 = This.nidusua
	goApp.npara21 = This.nsmax
	goApp.npara22 = This.nsmin
	goApp.npara23 = This.ccodigo1
	goApp.npara24 = This.ndolar
	goApp.npara25 = This.nutil0
	goApp.npara26 = This.ntigv
	goApp.npara27 = This.nirta
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26,?goapp.npara27)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function editarproducto5()
	Local cur As String
	lC = 'PROACTUALIZAPRODUCTOS'
	goApp.npara1 = This.cdesc
	goApp.npara2 = This.cUnid
	goApp.npara3 = This.ncosto
	goApp.npara4 = This.np1
	goApp.npara5 = This.np2
	goApp.npara6 = This.np3
	goApp.npara7 = This.npeso
	goApp.npara8 = This.ccat
	goApp.npara9 = This.cmar
	goApp.npara10 = This.ctipro
	goApp.npara11 = This.nflete
	goApp.npara12 = This.Moneda
	goApp.npara13 = This.nprec
	goApp.npara14 = 0
	goApp.npara15 = This.nutil1
	goApp.npara16 = This.nutil2
	goApp.npara17 = This.nutil3
	goApp.npara18 = This.ncome
	goApp.npara19 = This.ncomc
	goApp.npara20 = This.nidusua
	goApp.npara21 = This.nidart
	goApp.npara22 = This.nsmax
	goApp.npara23 = This.nsmin
	goApp.npara24 = This.ccodigo1
	goApp.npara25 = This.ndolar
	goApp.npara26 = This.Cestado
	goApp.npara27 = This.nutil0
	goApp.npara28 = This.ntigv
	goApp.npara29 = This.nirta
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26,?goapp.npara27,?goapp.npara28,?goapp.npara29)
	ENDTEXT
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function PermitirVentasProductosconpreciobajo(np1, np2)
	TEXT To lp Noshow Textmerge
	  update fe_art SET prod_perx=<<np2>> WHERE idart=<<np1>>
	ENDTEXT
	If This.Ejecutarsql(lp) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function perimitirventasconporcentajeminimo(nid, opt)
	TEXT To lC Noshow Textmerge
	   UPDATE fe_art SET prod_perm=<<opt>> WHERE idart=<<nid>>
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarmenosrotados(dfi, df1, df2, Ccursor)
	f1 = Cfechas(df1)
	ff = Cfechas(df2)
	fi = Cfechas(dfi)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select prod_cod1,Descri,unid,dmar,sfinal,ulfecha,stocki,tingresos,tegresos,coda From(
	\Select b.stocki,b.tingresos,b.tegresos,(b.stocki+b.tingresos-b.tegresos) As sfinal,
	\0 As reposicion,b.idart As coda,ulfecha
    \From (Select Sum(If(d.fech<'<<fi>>',If(tipo='C',cant,-cant),0)) As stocki,
    \Sum(If(d.fech Between '<<f1>>' And '<<ff>>',If(tipo='C',cant,0),0)) As tingresos,
    \Sum(If(d.fech Between '<<f1>>' And '<<ff>>',If(tipo='V',cant,0),0)) As tegresos,c.idart,Max(fech)As ulfecha From
    \fe_rcom As d
    \INNER Join fe_kar As c On(c.idauto=d.idauto)
    \Where c.Acti='A' And d.Acti='A' And c.alma=<<This.nidtda>>
	If This.cmar > 0 Then
	 \And a.idmar=<<This.cmar>>
	Endif
	If This.ccat > 0 Then
     \And a.idcat=<<This.ccat>>
	Endif
	\Group By c.idart) As b ) As x
	\INNER Join fe_art As a On a.idart=x.coda
	\INNER Join fe_mar As m On m.idmar=a.idmar
	\Where tegresos=0 And sfinal>0 And tingresos=0 Order By Descri;
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarstockminmaxlyg(Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow  Textmerge
	\Select  idart, prod_cod1 As codigo, Descri, unid, m.dmar As marca, c.dcat As categoria,
	\g.desgrupo As grupo, uno, Dos, tre, cua, uno + Dos + tre + cua As Tstock,prod_umin,prod_umax,prod_dmin,prod_dmax,prod_tmin,prod_tmax
	If 	This.nsmin	   = 1 Then
	    \,prod_smin, prod_smin - (uno + Dos + tre + cua) As Dife1
	Endif
	If This.nsmax = 1  Then
	   \,prod_smax, prod_smax - (uno + Dos + tre + cua) As Dife2
	Endif
	If This.cdetalle = 'S' Then
	  \ ,prod_deta,prod_ubi1,prod_ubi2,prod_ubi3,prod_ubi4,prod_ubi5,prod_codb
	Endif
	\ From fe_art As a
	\INNER Join fe_mar As m On m.idmar = a.idmar
	\INNER Join fe_cat As c On c.idcat = a.idcat
	\INNER Join fe_grupo As g On g.idgrupo = c.idgrupo
	\Where prod_acti <> 'I'
	If This.cmar > 0 Then
	    \ And a.idmar=<<This.cmar>>
	Endif
	If This.ccat > 0 Then
	    \ And a.idcat=<<This.ccat>>
	Endif
	If 	This.nsmin	   = 1 Then
	    \ And prod_smin - (uno + Dos + tre + cua)>0
	Endif
	If This.nsmax = 1  Then
	    \ And prod_smax - (uno + Dos + tre + cua)>0
	Endif
	\ Order By Descri
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Creaproductopsystrlyg()
	lC = 'FUNCREAPRODUCTOS'
	cur = "Xn"
	TEXT To lp Noshow Textmerge
	  ('<<This.cdesc>>','<<This.cUnid>>',<<This.nprec>>,<<This.ncosto>>,<<This.np1>>,<<This.np2>>,<<This.np3>>,<<This.npeso>>,<<This.ccat>>,
      <<This.cmar>>,'<<This.ctipro>>',<<This.nflete>>,'<<This.Moneda>>','<<id()>>',<<This.ncome>>,<<This.ncomc>>,<<This.nutil1>>,
      <<This.nutil2>>,<<This.nutil3>>,<<goapp.nidusua>>,<<This.nsmax>>,<<This.nsmin>>,'<<This.ccodigo1>>',<<This.ndolar>>,<<this.nutil0>>,<<this.ncantoferta>>,
      <<this.nsmin1>>,<<this.nsmax1>>,<<this.nsmin2>>,<<this.nsmax2>>,<<this.nsmin3>>,<<this.nsmax3>>)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function editarproductolyg()
	Local cur As String
	lC = 'PROACTUALIZAPRODUCTOS'
	TEXT To lp Noshow Textmerge
	  ('<<This.cdesc>>','<<This.cUnid>>',<<This.ncosto>>,<<This.np1>>,<<This.np2>>,<<This.np3>>,<<This.npeso>>,<<This.ccat>>,<<This.cmar>>,'<<This.ctipro>>',
	  <<This.nflete>>,'<<This.Moneda>>',<<This.nprec>>,0,<<This.nutil1>>,<<This.nutil2>>,<<This.nutil3>>,<<This.ncome>>,<<This.ncomc>>,<<goapp.nidusua>>,<<This.nidart>>,
	  <<This.nsmax>>,<<This.nsmin>>,'<<This.ccodigo1>>',<<This.ndolar>>,'<<This.Cestado>>',<<this.nutil0>>,<<this.ncantoferta>>,
      <<this.nsmin1>>,<<this.nsmax1>>,<<this.nsmin2>>,<<this.nsmax2>>,<<this.nsmin3>>,<<this.nsmax3>>)
	ENDTEXT
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function devStocks(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Local cur As String
	lC = 'PRODSTOCKS'
	TEXT To lp Noshow Textmerge
	(<<this.nidart>>)
	ENDTEXT
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function calculastocktienda(Ccursor)
	If This.Idsesion>0 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT TO lc NOSHOW TEXTMERGE
	SELECT a.idart,a.tcompras-a.tventas AS saldo FROM
	(SELECT b.idart,SUM(IF(b.tipo='C',b.cant,0)) AS tcompras,SUM(IF(b.tipo='V',b.cant,0)) AS tventas,b.alma FROM fe_kar AS b
	WHERE b.acti<>'I'  AND idart=<<this.nidart>> AND alma=<<this.nidtda>> GROUP BY  idart,alma) AS a
	ENDTEXT
	If This.EJECutaconsulta(lC,Ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function verificaStocks(Ncantidad, ntda)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Local cur As String
	cur = 'st'
	lC = 'PRODSTOCKS'
	TEXT To lp Noshow Textmerge
	(<<this.nidart>>)
	ENDTEXT
	If This.EJECUTARP(lC, lp, ccur) < 1 Then
		Return 0
	Endif
	Do Case
	Case ntda = 1
		Ts = st.uno
	Case ntda = 2
		Ts = stock.Dos
	Case ntda = 3
		Ts = stock.tre
	Case ntda = 4
		Ts = stock.cua
	Case ntda = 5
		Ts = stock.cin
	Case ntda = 6
		Ts = stock.sei
	Endcase
	If Ncantidad > Ts Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registradetraccion()
	Do Case
	Case This.nidart < 1
		This.Cmensaje = "Seleccione Un Producto"
		Return 0
	Case Len(Alltrim(This.Coddetra)) = 0
		This.Cmensaje = "Ingrese Código de Detracción"
		Return 0
	Case This.ndetraccion = 0
		This.Cmensaje = "Ingrese Porcentaje  Detracción"
		Return 0
	Endcase
	TEXT To lC Noshow Textmerge
        UPDATE fe_art SET prod_detr=<<this.ndetraccion>>,prod_cdtr='<<this.coddetra>>' WHERE idart=<<this.nidart>>
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	This.Cmensaje = "Registrado Ok."
	Return 1
	Endfunc
	Function  rotacioncompras(fi, ff, Ccursor)
	dfi = Cfechas(fi)
	dff = Cfechas(ff)
	Set Textmerge On
	Set  Textmerge To Memvar lC Noshow Textmerge
	   \Select a.prod_cod1,a.idart As coda,a.Descri,a.unid,IFNULL(z.cant,0) As cant,IFNULL(importe,0) As importe,IFNULL(mes,0) As mes,
	   \m.dmar As marca,c.dcat As linea,g.desgrupo As grupo From fe_art As a
	   \INNER Join fe_mar As m On m.idmar=a.idmar
	   \INNER Join fe_cat As c On c.idcat=a.idcat
	   \INNER Join fe_grupo As g On g.idgrupo=c.idgrupo
       \Left Join  (
	   \ Select a.idart As coda,SUM(a.cant) as cant,SUM(If(b.mone="S",cant*a.Prec*b.vigv,cant*a.Prec*b.dolar*b.vigv)) As importe,
	   \ a.alma,Month(b.fech) As mes From fe_kar As a
	   \INNER Join fe_art As z On z.idart=a.idart
	   \INNER Join fe_rcom As b On b.idauto=a.idauto
	   \Where a.Acti='A' And b.Acti='A' And b.fech Between '<<dfi>>' And '<<dff>>'  And tdoc Not In("AJ","II") and idprov>0
	If This.ccat > 0 Then
	       \ And z.idcat=<<This.ccat>>
	Endif
	If This.cmar > 0 Then
		       \ And z.idmar=<<This.cmar>>
	Endif
	If This.codt > 0 Then
		   \ And b.codt=<<This.codt>>
	Endif
	   \group by a.idart) As z On a.idart=z.coda Where prod_acti='A'
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function rotacionventas(fi, ff, Ccursor)
	dfi = Cfechas(fi)
	dff = Cfechas(ff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
   \Select a.prod_cod1,a.idart As coda,a.Descri,a.unid,IFNULL(z.cant,0) As cant,IFNULL(importe,0) As importe,
   \IFNULL(mes,0) As mes,m.dmar As marca,c.dcat As linea,g.desgrupo As grupo,z.alma  From fe_art As a
   \INNER Join fe_mar As m On m.idmar=a.idmar
   \INNER Join fe_cat As c On c.idcat=a.idcat
   \INNER Join fe_grupo As g On g.idgrupo=c.idgrupo
   \Left Join  (
   \ Select a.idart As coda,SUM(a.cant) as cant,SUM(If(b.mone="S",cant*a.Prec,cant*a.Prec*b.dolar)) As importe,
   \ a.alma,Month(b.fech) As mes From fe_kar As a
   \INNER Join fe_art As z On z.idart=a.idart
   \INNER Join fe_rcom As b On b.idauto=a.idauto
   \Where a.Acti='A' And b.Acti='A' And b.fech Between '<<dfi>>' And '<<dff>>' and idcliente>0  And tdoc Not In("AJ","II")
	If This.ccat > 0 Then
	   \ And z.idcat=<<This.ccat>>
	Endif
	If This.cmar > 0 Then
	   \ And z.idmar=<<This.cmar>>
	Endif
	If This.codt > 0 Then
	   \ And b.codt=<<This.codt>>
	Endif
	   \group by a.idart,a.alma) As z On a.idart=z.coda Where prod_acti='A' ORDER BY alma,idart
	Set Textmerge Off
	Set Textmerge To
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarpornombre(cnombre, nid)
	cb = Chrtran(Chrtran(cnombre, '"', ''), "'", '')
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select idart as Vdvto From fe_art Where Trim(Descri) = '<<cb>>' And prod_acti <> 'I'
	If nid > 0 Then
		   \And idart <> <<nid>>
	Endif
	\ LIMIT 1
	Set Textmerge To
	Set Textmerge Off
	Ccursor = 'c_' + Sys(2015)
	If This.EJECutaconsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If REgdvto(Ccursor) > 0 Then
		This.Cmensaje = "Nombre de Producto Ya Registrado"
		Return 0
	Endif
	Return 1
	Endfunc
	Function operacionesgratuito(opt)
	If This.ncoda<1 Then
		This.Cmensaje='Seleccione Un Producto'
		Return 0
	Endif
	If opt=1 Then
		cgrati='S'
	Else
		cgrati=''
	Endif
	TEXT TO Lc NOSHOW TEXTMERGE
	UPDATE fe_art SET prod_grat='<<m.cgrati>>' WHERE idart=<<this.ncoda>>
	ENDTEXT
	If This.Ejecutarsql(lC)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listargratuitos(Ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
	select idart,descri,unid,prod_grat FROM fe_art WHERE prod_grat='S' AND prod_acti='A' ORDER BY descri
	ENDTEXT
	If This.EJECutaconsulta(lC,Ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarlogs(Ccursor)
	If This.Idsesion>1 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT TO lc NOSHOW TEXTMERGE
	SELECT prod_fope as fecha,u.nomb as Usuario,prod_deta as Detalle FROM fe_aproductos a
	INNER JOIN fe_usua u ON u.idusua=a.prod_idus
	where prod_idar=<<this.nidart>> order by prod_fope desc
	ENDTEXT
	If This.EJECutaconsulta(lC,Ccursor)<1
		Return 0
	Endif
	Return 1
	Endfunc
	Function colocarStockok(nidart,nvalor)
	TEXT TO lc NOSHOW TEXTMERGE
      UPDATE fe_art SET prod_ent1=<<nvalor>> WHERE idart=<<nidart>>
	ENDTEXT
	If This.Ejecutarsql(lC)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function colocarcostook(nidart,nvalor)
	TEXT TO lc NOSHOW TEXTMERGE
       UPDATE fe_art SET prod_ent2=<<nvalor>>  WHERE idart=<<nidart>>
	ENDTEXT
	If This.Ejecutarsql(lC)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function AfectaICBPER(nvalor)
	TEXT TO lc NOSHOW TEXTMERGE
       UPDATE fe_art SET prod_icbper=<<nvalor>> WHERE idart=<<this.nidart>>
	ENDTEXT
	If This.Ejecutarsql(lC)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function quitarICBPER()
	TEXT TO lc NOSHOW TEXTMERGE
       UPDATE fe_art SET prod_icbper=0 WHERE idart=<<this.nidart>>
	ENDTEXT
	If This.Ejecutarsql(lC)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarmenosrotadosxsysz(f1,f2,Ccursor)
	fi=Cfechas(f1)
	ff=Cfechas(f2)
	If This.Idsesion>0 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT TO lc NOSHOW TEXTMERGE
	    SELECT descri,c.`colr_desc` AS color,stocki,fechacompra,CAST(IFNULL(fechavta,'0001-01-01') AS DATE) AS fechavta,w.idart FROM(
		SELECT i.idart,descri,codcolor,prod_des1,i.stocki,IFNULL(v.ventas,0) AS ventas,c.fechacompra,b.fechavta FROM
		(SELECT c.idart,p.descri,SUBSTR(p.prod_coda,6,3) AS codcolor,prod_des1,SUM(IF(tipo='C',cant,-cant)) AS stocki FROM fe_rcom AS d
		INNER JOIN fe_kar AS c ON(c.idauto=d.idauto)
		INNER JOIN fe_art AS p ON p.idart=c.idart
		WHERE c.ACTI='A' AND d.acti='A'  AND c.alma>0  GROUP BY c.idart HAVING  stocki>0) AS i
		LEFT JOIN (
		SELECT idart,MAX(fech) AS fechavta FROM fe_rcom AS r INNER JOIN fe_kar AS k
		ON k.idauto=r.idauto  WHERE idcliente>0 AND r.`acti`='A' AND k.`acti`='A' AND fech<'<<fi>>' GROUP BY idart) AS b ON b.idart=i.idart
		INNER JOIN (
		SELECT idart,MAX(fech) AS fechacompra FROM fe_rcom AS r INNER JOIN fe_kar AS k
		ON k.idauto=r.idauto  WHERE idprov>0 AND r.`acti`='A' AND k.`acti`='A'AND  r.fech<'<<fi>>' GROUP BY idart) AS c  ON c.idart=i.idart
		LEFT JOIN
		(SELECT c.idart,SUM(cant) AS  ventas FROM  fe_rcom AS d INNER JOIN fe_kar AS c ON(c.idauto=d.idauto)
		WHERE idcliente>0 GROUP BY c.idart) AS v ON v.idart=i.idart) AS w
		INNER JOIN fe_colores AS c ON c.`colr_coda` = w.codcolor
		WHERE ventas=0  ORDER BY prod_des1,color,stocki DESC,fechavta
	ENDTEXT
*!*		    select descri,c.`colr_desc` AS color,stocki,fechacompra,CAST(IFNULL(fechavta,'0001-01-01') AS DATE) AS fechavta,w.idart FROM(
*!*			SELECT i.idart,descri,codcolor,prod_des1,i.stocki,IFNULL(v.ventas,0) AS ventas,c.fechacompra,b.fechavta FROM
*!*			(SELECT c.idart,p.descri,SUBSTR(p.prod_coda,6,3) AS codcolor,prod_des1,SUM(IF(tipo='C',cant,-cant)) AS stocki FROM fe_rcom AS d
*!*			INNER JOIN fe_kar AS c ON(c.idauto=d.idauto)
*!*			INNER JOIN fe_art AS p ON p.idart=c.idart
*!*			WHERE c.ACTI='A' AND d.acti='A'  AND c.alma>0  GROUP BY c.idart HAVING  stocki>0) AS i
*!*			LEFT JOIN (
*!*			SELECT idart,MAX(fech) AS fechavta FROM fe_rcom AS r INNER JOIN fe_kar AS k
*!*			ON k.idauto=r.idauto  WHERE idcliente>0 AND r.`acti`='A' AND k.`acti`='A' GROUP BY idart) AS b ON b.idart=i.idart
*!*			INNER JOIN (
*!*			SELECT idart,MAX(fech) AS fechacompra FROM fe_rcom AS r INNER JOIN fe_kar AS k
*!*			ON k.idauto=r.idauto  WHERE idprov>0 AND r.`acti`='A' AND k.`acti`='A'  GROUP BY idart) AS c  ON c.idart=i.idart
*!*			LEFT JOIN
*!*			(SELECT c.idart,SUM(cant) AS  ventas FROM  fe_rcom AS d INNER JOIN fe_kar AS c ON(c.idauto=d.idauto)
*!*			WHERE d.fech BETWEEN '<<fi>>' AND '<<ff>>' AND idcliente>0 GROUP BY c.idart) AS v ON v.idart=i.idart) AS w
*!*			INNER JOIN fe_colores AS c ON c.`colr_coda` = w.codcolor
*!*			WHERE ventas=0  ORDER BY prod_des1,color,stocki DESC,fechavta
	If This.EJECutaconsulta(lC,Ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine














































