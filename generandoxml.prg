Create Cursor MyCursor (Id c(9),Nombre c(30),Apellido c(20),Sexo c(1),domicilio c(40),provincia c(35),cp c(9),fecha d,kilos N(5,1),altura N(5,1),Nota c(254))
Insert Into MyCursor Values ("123","DANIEL ROBERTO","GONZALEZ","M","Alvarado 15","Chubut","5454",{^2012-03-26},54.1,152.3,"PRIMER CONTROL")
Local cXml
Set Date Italian
TEXT TO cXML TEXTMERGE NOSHOW
<?xml version = "1.0" encoding="Windows-1252" standalone="yes"?>
<individuo>
  <codigo id="<<RTRIM(id)>>" Nombre="<<RTRIM(nombre)>>" Apellido="<<RTRIM(apellido)>>" Sexo="<<sexo>>">
    <Direccion domicilio="<<RTRIM(domicilio)>>" Provincia="<<RTRIM(provincia)>>" Cp="<<RTRIM(cp)>>" />
    <Visitas>
      <hoy fecha="<<TTOC(fecha)>>" kilos="<<ALLTRIM(STR(kilos,5,1))>>" altura="<<ALLTRIM(STR(altura,5,1))>>" Nota="<<RTRIM(nota)>>" />
    </Visitas>
  </codigo>
</individuo>
ENDTEXT
?cXml
