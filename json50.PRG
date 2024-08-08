*!*	set path to "\vfpx\nfxml\nfxml;\vfpx\nfjson\nfjson"
Set Procedure To d:\librerias\nfjsoncreate,d:\librerias\nfcursortojson.prg,;
	d:\librerias\nfcursortoobject, d:\librerias\nfJsonRead.prg,;
	d:\librerias\_.prg  Additive
Close Tables All
Clear All


Use d:\xsysr\guias In  0
obj=Createobject("empty")
With _(m.obj)
	.brevete=brevete
	.ciud=ciud
	.ciudad=ciudad
	.conductor=conductor
	.clavecerti=clavecerti
	.constancia=constancia
	.Dire=Dire
	.direcciont=direcciont
	.distrito=distrito
	.empresa=empresa
	.fech=fech
	.fechat=fechat
	.gene_cert=gene_cert
	.gene_csol=gene_csol
	.gene_usol=gene_usol
	.guia_idtr=guia_idtr
	.guia_moti=guia_moti
	.guia_ubig=guia_ubig
	.idgui=idgui
	.idprov=idprov
	.marca=marca
	.ndni=ndni
	.ndoc=ndoc
	.nruc=nruc
	.numero=numero
	.placa=placa
	.placa1=placa1
	.ptollegada=ptollegada
	.ptop=ptop
	.razo=razo
	.razonfirma=razonfirma
	.razont=razont
	.rucempresa=rucempresa
	.rucfirmad=rucfirmad
	.ructr=ructr
	.serie=serie
	.tdoc=tdoc
	.tdoc1=tdoc1
	.tran_tipo=tran_tipo
	.ubigeo=ubigeo
	.lista = .newList()
	Scan All
		With .newItemFor( 'lista' )
			.unid = unid
			.peso = peso
			.Descri=Descri
			.coda=coda
			.cant=cant
		Endwith
	Endscan
Endwith
Strtofile(nfjsoncreate(m.obj,.T.),'d:\xsysr\json25.json')
Return

AddProperty(obj,"brevete",Textmerge("<<brevete>>"))
AddProperty(obj,"ciud",Textmerge("<<ciud>>"))
AddProperty(obj,"ciudad",Textmerge("<<ciudad>>"))
AddProperty(obj,"clavecerti",Textmerge("<<clavecerti>>"))
AddProperty(obj,"constancia",Textmerge("<<constancia>>"))
AddProperty(obj,"dire",Textmerge("<<dire>>"))
AddProperty(obj,"direcciont",Textmerge("<<direcciont>>"))
AddProperty(obj,"distrito",Textmerge("<<distrito>>"))
AddProperty(obj,"empresa",Textmerge("<<empresa>>"))
AddProperty(obj,"fech",Textmerge("<<fech>>"))
AddProperty(obj,"fechat",Textmerge("<<fechat>>"))
AddProperty(obj,"gene_cert",Textmerge("<<gene_cert>>"))
AddProperty(obj,"gene_csol",Textmerge("<<gene_csol>>"))
AddProperty(obj,"gene_usol",Textmerge("<<gene_usol>>"))
AddProperty(obj,"guia_idtr",guia_idtr)
AddProperty(obj,"guia_moti",Textmerge("<<guia_moti>>"))
AddProperty(obj,"guia_ubig",Textmerge("<<guia_ubig>>"))
AddProperty(obj,"idgui",idgui)
AddProperty(obj,"idprov",idprov)
AddProperty(obj,"marca",Textmerge("<<marca>>"))
AddProperty(obj,"ndni",Textmerge("<<ndni>>"))
AddProperty(obj,"ndoc",Textmerge("<<ndoc>>"))
AddProperty(obj,"nruc",Textmerge("<<nruc>>"))
AddProperty(obj,"numero",Textmerge("<<numero>>"))
AddProperty(obj,"placa",Textmerge("<<placa>>"))
AddProperty(obj,"placa1",Textmerge("<<placa1>>"))
AddProperty(obj,"ptollegada",Textmerge("<<ptollegada>>"))
AddProperty(obj,"ptop",Textmerge("<<ptop>>"))
AddProperty(obj,"razo",Textmerge("<<razo>>"))
AddProperty(obj,"razonfirma",Textmerge("<<razonfirma>>"))
AddProperty(obj,"razont",Textmerge("<<razont>>"))
AddProperty(obj,"rucempresa",Textmerge("<<rucempresa>>"))
AddProperty(obj,"rucfirmad",Textmerge("<<rucfirmad>>"))
AddProperty(obj,"ructr",Textmerge("<<ructr>>"))
AddProperty(obj,"serie",Textmerge("<<serie>>"))
AddProperty(obj,"tdoc",Textmerge("<<tdoc>>"))
AddProperty(obj,"tdoc1",Textmerge("<<tdoc1>>"))
AddProperty(obj,"tran_tipo",Textmerge("<<tran_tipo>>"))
AddProperty(obj,"ubigeo",Textmerge("<<ubigeo>>"))
Select guias
Scan All

Endscan

Strtofile(nfjsoncreate(obj,.T.),'d:\xsysr\json20.json')
Return

Select guias
TEXT To cdata Noshow Textmerge
	{
	"brevete": "<<brevete>>",
	"ciud": "<<ciud>>",
	"ciudad": "<<ciudad>>",
	"clavecerti": "<<clavecerti>>",
	"constancia": "<<constancia>>",
	"dire": "<<dire>>",
	"direcciont": "<<direcciont>>",
	"distrito": "<<distrito>>",
	"empresa": "<<empresa>>",
	"fech": "<<fech>>",
	"fechat": "<<fechat>>",
	"gene_cert": "<<gene_cert>>",
	"gene_csol": "<<gene_csol>>",
	"gene_usol": "<<gene_usol>>",
	"guia_idtr": <<guia_idtr>>,
	"guia_moti": "<<guia_moti>>",
	"guia_ubig": "<<guia_ubig>>",
	"idgui": <<idgui>>,
	"idprov": <<idprov>>,
	"marca": "<<marca>>",
	"ndni": "<<ndni>>",
	"ndoc": "<<ndoc>>",
	"nruc": "<<nruc>>",
	"numero": "<<numero>>",
	"placa": "<<placa>>",
	"placa1": "<<placa1>>"
	"ptollegada": "<<ptollegada>>"
	"ptop": "<<ptop>>",
	"razo": "<<razo>>",
	"razonfirma": "<<razonfirma>>",
	"razont": "<<razont>>",
	"rucempresa": "<<rucempresa>>",
	"rucfirmad": "<<rucfirmad>>",
	"ructr": "<<ructr>>",
	"serie": "<<serie>>",
	"tdoc": "<<tdoc>>",
	"tdoc1": "<<tdoc1>>",
	"tran_tipo": "<<tran_tipo>>",
	"ubigeo": "<<ubigeo>>"
	}
ENDTEXT
Strtofile(nfjsoncreate(cdata,.T.),'d:\xsysr\json20.json')




Return

Set Procedure To d:\librerias\nfjsoncreate,d:\librerias\nfcursortojson,d:librerias\nfcursortojson, d:\librerias\nfcursortoobject, d:\librerias\nfJsonRead.prg Additive
Close Tables All
Clear
Create Cursor Library ( Library c(15), shelf N(6), Version c(10), hash c(10),author c(30), Name c(20), category c(20),Pages N(4),publication c(60))

Insert Into Library Values("Books",5,"LIB3.1.2","hash","Anderson","Legends","Drama",120,"Happer Collins")
Insert Into Library Values("Books",5,"LIB3.1.2","hash","Anderson","Ths Blooms","Fiction",450,"Penguin")
Insert Into Library Values("Books",5,"LIB3.1.2","hash","Sofie Jia","RRR","Fiction",120,"Blue Dart")
Insert Into Library Values("Books",5,"LIB3.1.2","hash","Sofie Jia","Heavy Hearts","Documentary",100,"Mcgrath")


Scatter Fields hash,Library,shelf,Version Name root

Select Distinct author From Library Into Cursor cauthors

AddProperty(root,Textmerge('details(<<_tally>>)'))
Scan

	oDetail = Createobject('empty')

	AddProperty(oDetail,'name',author)

	Select * From Library Where author = oDetail.Name Into Cursor books

	AddProperty(oDetail,Textmerge('books(<<_tally>>)'))

	Scan

		Scatter Fields Name Name book
		Scatter Fields category,Pages,publication Name bookdtl
		AddProperty(book,'bookdtl',m.bookdtl)
		oDetail.books(Recno()) = m.book

	Endscan

	oAuthor = Createobject('empty') && edit / added missing node!

	AddProperty(oAuthor,'author',m.oDetail)

	m.root.Details(Recno('cauthors')) = m.oDetail

Endscan
Strtofile(nfjsoncreate(m.root,.T.),'d:\capass\tek-tips.json')
Modify File tek-tips.json Nowait
