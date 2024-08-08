
*2* A simple web accordion menu with all tools to run from any vfp app.
*this is built with css & jquery (the code link to the js file ....can download it and make it in sme folder)
*internet must be connected to link to this library and to the background image.
*can customize menu as convenience with personal itemps (in div).can set dynamically the accordion color.can change the picture background also.
*its more simple that any vfp class building an accordion.
*a similar sample was already posted in http://yousfi.over-blog.com/2016/11/css-menus-built-from-vfp.html

_screen.windowstate=1
publi yform
yform=newObject("yaccordion")
yform.show
read events
retu
*
DEFINE CLASS yaccordion AS form
BorderStyle = 3
Top = 0
Left = 0
Height = 600
Width = 264
ShowWindow = 2
ShowTips = .T.
Caption = "Accordion menu dropDown with css+jQuery"
BackColor = RGB(0,0,0)
ycolor = .F.
Name = "Form1"

ADD OBJECT olecontrol1 AS olecontrol WITH ;
oleclass="shell.explorer.2",;
Top = 0, ;
Left = 0, ;
Height = 564, ;
Width = 264, ;
Anchor = 15, ;
Name = "Olecontrol1"

ADD OBJECT shape1 AS shape WITH ;
Top = 576, ;
Left = 24, ;
Height = 15, ;
Width = 15, ;
Anchor = 768, ;
Curvature = 99, ;
MousePointer = 15, ;
ToolTipText = "Accordion color", ;
BackColor = RGB(0,255,0), ;
Name = "Shape1"

ADD OBJECT image1 AS image WITH ;
Anchor = 768, ;
Picture = home(1)+"graphics\icons\arrows\arw06rt.ico", ;
BackStyle = 0, ;
Height = 32, ;
Left = 222, ;
MousePointer = 15, ;
Top = 564, ;
Width = 32, ;
ToolTipText = "Enlarge", ;
Name = "Image1"

PROCEDURE ybuild
*adapted from:https://codepen.io/fainder/pen/AydHJ
local m.myvar
text to m.myvar  textmerge noshow
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1.0" />
<title>Smooth Accordion Dropdown Menu Demo</title>

<style>
* {
margin: 0;
padding: 0;
-webkit-box-sizing: border-box;
-moz-box-sizing: border-box;
box-sizing: border-box;
}

body {
background: #2d2c41 url('http://www.algerie-focus.com/wp-content/uploads/2014/12/B%C3%A9char-Taghit_20-d%C3%A9cembre-2014.jpg');
font-family: 'Open Sans', Arial, Helvetica, Sans-serif, Verdana, Tahoma;
}

ul { list-style-type: none; }

a {
color: #b63b4d;
text-decoration: none;
}

/** =======================
* Contenedor Principal
===========================*/

h1 {
color: #FFF;
font-size: 24px;
font-weight: 400;
text-align: center;
margin-top: 10px;
}

h1 a {
color: #c12c42;
font-size: 16px;
}
.accordion {
width: 100%;
max-width: 230px;
margin-left:15px;
margin-top:15px;
background: << thisform.ycolor >> ;  //
-webkit-border-radius: 4px;
-moz-border-radius: 4px;
border-radius: 4px;
}

.accordion .link {
cursor: pointer;
display: block;
padding: 15px 15px 15px 42px;
color: #4D4D4D;
font-size: 14px;
font-weight: 700;
border-bottom: 1px solid #CCC;
position: relative;
-webkit-transition: all 0.4s ease;
-o-transition: all 0.4s ease;
transition: all 0.4s ease;
}
.accordion li:last-child .link { border-bottom: 0; }
.accordion li i {
position: absolute;
top: 16px;
left: 12px;
font-size: 18px;
color: #595959;
-webkit-transition: all 0.4s ease;
-o-transition: all 0.4s ease;
transition: all 0.4s ease;
}

.accordion li i.fa-chevron-down {
right: 12px;
left: auto;
font-size: 16px;
}
.accordion li.open .link { color: #b63b4d; }
.accordion li.open i { color: #b63b4d; }
.accordion li.open i.fa-chevron-down {
-webkit-transform: rotate(180deg);
-ms-transform: rotate(180deg);
-o-transform: rotate(180deg);
transform: rotate(180deg);
}
/**
* Submenu
-----------------------------*/
.submenu {
display: none;
background: #444359;
font-size: 14px;
}
.submenu li { border-bottom: 1px solid #4b4a5e; }
.submenu a {
display: block;
text-decoration: none;
color: #d9d9d9;
padding: 12px;
padding-left: 42px;
-webkit-transition: all 0.25s ease;
-o-transition: all 0.25s ease;
transition: all 0.25s ease;
}
.submenu a:hover {
background: #b63b4d;
color: #FFF;
}
</style>
</head>
<body topmargin=0>
<!-- Contenedor -->
<ul id="accordion" class="accordion">
<li>
<div class="link"><i class="fa fa-database"></i>Applications<i class="fa fa-chevron-down"><img src="plus.png"></i></div>
<ul class="submenu">
<li><a href="#01">MSPaint</a></li>
<li><a href="#02">Notepad</a></li>
<li><a href="#03">Firefox</a></li>
<li><a href="#04">Visual Foxpro</a></li>
</ul>
</li>
<li>
<div class="link"><i class="fa fa-code" ></i>Coding<i class="fa fa-chevron-down" ><img src="plus.png"></i></div>
<ul class="submenu">
<li><a href="#05">VFP9</a></li>
<li><a href="#06">Javascript</a></li>
<li><a href="#07">jQuery</a></li>
<li><a href="#08">Ruby</a></li>
</ul>
</li>
<li>
<div class="link"><i class="fa fa-mobile"></i>Devices<i class="fa fa-chevron-down"><img src="plus.png"></i></div>
<ul class="submenu">
<li><a href="#09">Tablet</a></li>
<li><a href="#10">Mobile</a></li>
<li><a href="#11">Desktop</a></li>
</ul>
</li>
<li>
<div class="link"><i class="fa fa-globe"></i>Search<i class="fa fa-chevron-down"><img src="plus.png"></i></div>
<ul class="submenu">
<li><a href="#12">Google</a></li>
<li><a href="#13">Bing</a></li>
<li><a href="#14">Yahoo</a></li>
<li><a href="#15">Internet Explorer</a></li>
<li><a href="#16">Edge</a></li>
</ul>
</li>
<li>
<div class="link"><i class="fa fa-globe"></i>Visual foxpro<i class="fa fa-chevron-down"><img src="plus.png"></i></div>
<ul class="submenu">
<li><a href="#17">Classes</a></li>
<li><a href="#18">Forms</a></li>
<li><a href="#19">Controls</a></li>
<li><a href="#20">Reports</a></li>
<li><a href="#21">Help</a></li>
</ul>
</li>

</ul>
<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
<script>
$(function() {
var Accordion = function(el, multiple) {
this.el = el || {};
this.multiple = multiple || false;

// Variables privadas
var links = this.el.find('.link');
// Evento
links.on('click', {el: this.el, multiple: this.multiple}, this.dropdown)
}
Accordion.prototype.dropdown = function(e) {
var $el = e.data.el;
	$this = $(this),
	$next = $this.next();

$next.slideToggle();
$this.parent().toggleClass('open');

if (!e.data.multiple) {
	$el.find('.submenu').not($next).slideUp().parent().removeClass('open');
};
}
var accordion = new Accordion($('#accordion'), false);
});
</script>

</body>
</html>
endtext

local m.lcdest
m.lcdest=addbs(sys(2023))+"ytemp.html"
strtofile(m.myvar,m.lcdest)
with thisform.olecontrol1
.navigate(m.lcdest)
.refresh
endwith
ENDPROC

PROCEDURE yactions
lparameters url
url=right(allt(url),2)
if !int(val(url))>0
return .f.
endi

messagebox("Submenu item:"+url+" from yactions:   do something from here !",0+32+4096,'',1500)

do case
case right(allt(url),3)=="01"
*run/n mspaint
case right(allt(url),3)=="02"
*run/n notepad
case right(allt(url),3)=="03"
*****
case right(allt(url),3)=="04"
case right(allt(url),3)=="05"
case right(allt(url),3)=="06"
case right(allt(url),3)=="07"
case right(allt(url),3)=="08"
case right(allt(url),3)=="09"
case right(allt(url),3)=="10"
case right(allt(url),3)=="11"
case right(allt(url),3)=="12"
endcase
ENDPROC

PROCEDURE yrgb
lparameters xcol
Local RGBChr
m.RGBChr=left(BINTOC(xcol,'R'),3)
R=asc(substr(m.RGBChr,1,1)) && RED
G=asc(substr(m.RGBChr,2,1)) && GREEN
B=asc(substr(m.RGBChr,3,1)) && BLUE
return "rgba("+trans(r,"999")+","+trans(g,"999")+","+trans(b,"999")+",0.8 )"
ENDPROC

PROCEDURE Load
set safe off
declare integer Sleep in kernel32 integer
try
erase addbs(sys(2023))+"ytemp.html"
catch
endtry
ENDPROC


PROCEDURE Init
local m.myvar
text to m.myvar noshow
iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAA+SURBVDhPY2Rg+P+fgQLABKXJBrQ1AOQ5Qh4c5F4gBqBEI7ERygjUBQPUdQE6gMkg24gOhlsskAMG2gsMDABNtxARy7JDXQAAAABJRU5ErkJggg==
endtext
=strtofile(strconv(m.myvar,14),addbs(sys(2023))+"plus.png")
thisform.ycolor=thisform.yrgb( rgb(255,255,0))       &&yellow
thisform.ybuild()
ENDPROC

PROCEDURE Destroy
erase addbs(sys(2023))+"ytemp.html"
erase addbs(sys(2023))+"plus.png"
clea events
ENDPROC

PROCEDURE olecontrol1.BeforeNavigate2
*** Événement de contrôle ActiveX  ***
LPARAMETERS pdisp, url, flags, targetframename, postdata, headers, cancel
cancel=.t.
*messagebox("url="+url+chr(13)+"Do some vfp commands from here",0+32+4096,'',1000)
thisform.yactions(url)
return .f.
ENDPROC

PROCEDURE olecontrol1.Init
this.silent=.t.
ENDPROC

PROCEDURE shape1.Click
local m.xcolor
m.xcolor=getcolor()
if m.xcolor=-1
return .f.
endi
thisform.ycolor=thisform.yrgb(m.xcolor)      &&thisform.yrgb2html(m.xcolor)
thisform.ybuild()
ENDPROC

PROCEDURE image1.Click
thisform.windowstate=2
ENDPROC

ENDDEFINE
*
*-- EndDefine: yaccordion
