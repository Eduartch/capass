 Select    `a`.`Ndoc` , `a`.`fech` ,`a`.`dola`,`a`.`nrou`,`a`.`banc` ,  `a`.`iddeu`,`s`.`Fevto` ,  `s`.`saldo` As importe,
    `s`.`rdeu_idpr` As `Idpr`,  `b`.`rdeu_impc` As importeC,'C' As `situa`,  `b`.`rdeu_idau` As `Idauto`, `s`.`Ncontrol` ,  `a`.`Tipo`,
    `a`.`banco`     As `banco`,  IFNULL(`c`.`Ndoc`,'0') As `docd`,IFNULL(`c`.`tdoc`,'0') As `tdoc`,  `b`.`rdeu_mone` As `Moneda`,IFNULL(u.nomb,'') As usuario,
    `b`.`rdeu_codt` As `codt`,  `b`.`rdeu_idrd` As `Idrd`,  `b`.`rdeu_idct`
     From (Select   Round(Sum((`d`.`Impo` - `d`.`acta`)),2) As `saldo`,
    `d`.`Ncontrol` ,  Max(`d`.`Fevto`) As `Fevto`,  `r`.`rdeu_idpr` ,  `r`.`rdeu_mone`
     From `fe_rdeu` `r`
     Join `fe_deu` `d`   On `d`.`deud_idrd` = `r`.`rdeu_idrd`
     Where `d`.`Acti` = 'A'  And `r`.`rdeu_Acti` = 'A'  And  rdeu_idpr=<<nid>> And d.fech<='<<df>>'
	If Len(Alltrim(This.Ctipo)) > 0 Then
        And d.Tipo='<<this.ctipo>>'
	Endif
	If Len(Alltrim(This.Cmoneda)) > 0 Then
       And rdeu_mone='<<this.cmoneda>>'
	Endif
	If goApp.Cdatos = 'S' Then
		If Empty(goApp.Tiendas) Then
	      And rdeu_codt=<<goApp.Tienda>>
		Else
	       And rdeu_codt In ('<<LEFT(goapp.Tiendas,1)>>','<<SUBSTR(goapp.Tiendas,2,1)>>')
		Endif
	Endif
     Group By `r`.`rdeu_idpr`,`d`.`Ncontrol`,`r`.`rdeu_mone`
     Having (Round(Sum(`d`.`Impo` - `d`.`acta`),2) > 0.15)) As s
     Join `fe_prov` `z`   On `z`.`idprov` = `s`.`rdeu_idpr`
     Join `fe_deu` `a`     On `a`.`iddeu` = `s`.`Ncontrol`
     Join `fe_rdeu` `b`     On `b`.`rdeu_idrd` = `a`.`deud_idrd`
     Left Join `fe_rcom` `c` On `c`.`Idauto` = `b`.`rdeu_idau`
     Left Join fe_usua As u On u.idusua=b.rdeu_idus
     Order By `s`.`Fevto`