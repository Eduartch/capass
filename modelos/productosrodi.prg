Define Class productosrodi As Producto Of 'd:\capass\modelos\productos'
	codigorodi = ""
	Function Crear(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25)
	lC = 'FUNCREAPRODUCTOS'
	cur = "Xn"
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara9 = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	goApp.npara12 = np12
	goApp.npara13 = np13
	goApp.npara14 = np14
	goApp.npara15 = np15
	goApp.npara16 = np16
	goApp.npara17 = np17
	goApp.npara18 = np18
	goApp.npara19 = np19
	goApp.npara20 = np20
	goApp.npara21 = np21
	goApp.npara22 = np22
	goApp.npara23 = np23
	goApp.npara24 = np24
	goApp.npara25 = np25
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
	ENDTEXT
	nid = This.EJECUTARf(lC, lp, cur)

	If Vartype(nid) = 'C' Then
		vd = 1
		This.codigorodi = nid
	Else
		vd = nid
	Endif
	If vd < 1 Then
		Return 0
	Endif
	Return vd
	Endfunc
	Function ActualizaProductosR(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25)
	lC = 'PROACTUALIZAPRODUCTOS'
	cur = ""
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara9 = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	goApp.npara12 = np12
	goApp.npara13 = np13
	goApp.npara14 = np14
	goApp.npara15 = np15
	goApp.npara16 = np16
	goApp.npara17 = np17
	goApp.npara18 = np18
	goApp.npara19 = np19
	goApp.npara20 = np20
	goApp.npara21 = np21
	goApp.npara22 = np22
	goApp.npara23 = np23
	goApp.npara24 = np24
	goApp.npara25 = np25
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
	ENDTEXT
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizaProductosRR(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25, np26)
	lC = 'PROACTUALIZAPRODUCTOsR'
	cur = ""
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara9 = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	goApp.npara12 = np12
	goApp.npara13 = np13
	goApp.npara14 = np14
	goApp.npara15 = np15
	goApp.npara16 = np16
	goApp.npara17 = np17
	goApp.npara18 = np18
	goApp.npara19 = np19
	goApp.npara20 = np20
	goApp.npara21 = np21
	goApp.npara22 = np22
	goApp.npara23 = np23
	goApp.npara24 = np24
	goApp.npara25 = np25
	goApp.npara26 = np26
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26)
	ENDTEXT
	If EJECUTARP(lC, lp, cur) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function Listar(np1, np2, np3, Ccursor)
	Set DataSession To This.Idsesion
	lC = 'PROMUESTRAPRODUCTOS'
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraProductosRR(np1, np2, np3, np4, Ccursor)
	Local cur As String
	lC = 'PROMUESTRAPRODUCTOSR'
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	ENDTEXT
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function CreaProductospsysrx()
	lC = 'FUNCREAPRODUCTOS'
	cur = 'c_' + Sys(2015)
	Set Textmerge On
	Set Textmerge To Memvar lp Noshow Textmerge
	\('<<this.ccoda>>', '<<this.cdesc>>', '<<this.cunid>>', << This.nprec >>, << This.ncosto >>,
	\<< This.np1 >>, << This.np2 >>, << This.np3 >>,
	\<< This.npeso >>, << This.ccat >>, << This.cmar >>, '<<this.ctipro>>', << This.nflete >>,
	\'<<this.cm>>', '<<this.cidpc>>', << This.ncome >>, << This.ncomc >>,
	\<< This.nutil1 >>, << This.nutil2 >>, << This.nutil3 >>, << goApp.nidusua >>,
	\<< This.nsmax >>, << This.nsmin >>, << This.nidcosto >>, << This.ndolar >>
	If goApp.Lectorcodigobarras = 'S' Then
	  \,'<<this.ccodigo1>>')
	Else
	\)
	Endif
	Set Textmerge Off
	Set Textmerge To
	nid = This.EJECUTARf(lC, lp, cur)
	If LEN(ALLTRIM(nid)) = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizaProductospsysrx(Cestado)
	lC = 'PROACTUALIZAPRODUCTOS'
	If Cestado = 'A' Then
		Set Textmerge On
		Set Textmerge To Memvar lp Noshow Textmerge
		\('<<this.cdesc>>', '<<this.cunid>>',<<This.ncosto>>,
		\<< This.np1 >>, << This.np2 >>, << This.np3 >>,
		\<< This.npeso >>, << This.ccat >>, << This.cmar >>, '<<this.ctipro>>', << This.nflete >>,
		\'<<this.cm>>',  << This.nprec >>, <<This.nidgrupo>>,
		\<< This.nutil1 >>, << This.nutil2 >>, << This.nutil3 >>,
		\<< This.ncome >>, << This.ncomc >>,<< goApp.nidusua >>,'<<this.ccoda>>',
		\<< This.nsmax >>, << This.nsmin >>, << This.nidcosto >>, << This.ndolar >>
		If goApp.Lectorcodigobarras = 'S' Then
		  \,'<<this.ccodigo1>>')
		Else
			\)
		Endif
		Set Textmerge Off
		Set Textmerge To
		If This.EJECUTARP(lC, lp, "") < 1 Then
			Return 0
		Endif
	Else
		TEXT To lcu Noshow Textmerge
	        UPDATE fe_art SET prod_acti='I',prod_uact=<<goapp.nidusua>> WHERE idart='<<this.ccoda>>'
		ENDTEXT
		If This.Ejecutarsql(lcu) < 1 Then
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
Enddefine









