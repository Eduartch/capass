 *1*
publi yform
yform=newObject("ycss_menu")
yform.show
read events
retu
*
DEFINE CLASS ycss_menu AS form
Height = 662
Width = 900
ShowWindow = 2
ShowTips = .T.
AutoCenter = .T.
Caption = "CSS3 menus prototypes"
BackColor = RGB(0,0,0)
ybkg = .F.
yurl = .F.
Name = "Form1"

ADD OBJECT olecontrol1 AS olecontrol WITH ;
Oleclass="shell.explorer.2",;
Top = 32, ;
Left = -12, ;
Height = 592, ;
Width = 912, ;
Anchor = 15, ;
Name = "Olecontrol1"

ADD OBJECT optiongroup1 AS optiongroup WITH ;
AutoSize = .T., ;
ButtonCount = 8, ;
Anchor = 768, ;
BackStyle = 0, ;
Value = 1, ;
Height = 27, ;
Left = 312, ;
Top = 0, ;
Width = 215, ;
Name = "Optiongroup1", ;
Option1.Caption = "", ;
Option1.Value = 1, ;
Option1.Height = 17, ;
Option1.Left = 5, ;
Option1.Style = 0, ;
Option1.Top = 5, ;
Option1.Width = 18, ;
Option1.AutoSize = .T., ;
Option1.Name = "Option1", ;
Option2.Caption = "", ;
Option2.Height = 17, ;
Option2.Left = 31, ;
Option2.Style = 0, ;
Option2.Top = 5, ;
Option2.Width = 18, ;
Option2.AutoSize = .T., ;
Option2.Name = "Option2", ;
Option3.Caption = "", ;
Option3.Height = 17, ;
Option3.Left = 57, ;
Option3.Style = 0, ;
Option3.Top = 5, ;
Option3.Width = 18, ;
Option3.AutoSize = .T., ;
Option3.Name = "Option3", ;
Option4.Caption = "", ;
Option4.Height = 17, ;
Option4.Left = 84, ;
Option4.Style = 0, ;
Option4.Top = 5, ;
Option4.Width = 18, ;
Option4.AutoSize = .T., ;
Option4.Name = "Option4", ;
Option5.Caption = "", ;
Option5.Height = 17, ;
Option5.Left = 110, ;
Option5.Style = 0, ;
Option5.Top = 5, ;
Option5.Width = 18, ;
Option5.AutoSize = .T., ;
Option5.Name = "Option5", ;
Option6.Caption = "", ;
Option6.Height = 17, ;
Option6.Left = 135, ;
Option6.Top = 5, ;
Option6.Width = 18, ;
Option6.AutoSize = .T., ;
Option6.Name = "Option6", ;
Option7.Caption = "", ;
Option7.Height = 17, ;
Option7.Left = 163, ;
Option7.Top = 5, ;
Option7.Width = 18, ;
Option7.AutoSize = .T., ;
Option7.Name = "Option7", ;
Option8.Caption = "", ;
Option8.Height = 17, ;
Option8.Left = 192, ;
Option8.Top = 5, ;
Option8.Width = 18, ;
Option8.AutoSize = .T., ;
Option8.Name = "Option8"

ADD OBJECT label1 AS label WITH ;
AutoSize = .T., ;
FontBold = .T., ;
FontSize = 12, ;
Anchor = 768, ;
BackStyle = 0, ;
Caption = "Backgrounds", ;
Height = 22, ;
Left = 196, ;
Top = 6, ;
Width = 106, ;
ForeColor = RGB(255,255,255), ;
Name = "Label1"

ADD OBJECT combo1 AS combobox WITH ;
FontBold = .T., ;
FontSize = 10, ;
Anchor = 768, ;
Height = 24, ;
Left = 19, ;
Top = 5, ;
Width = 100, ;
ForeColor = RGB(128,0,64), ;
Name = "Combo1"

PROCEDURE ybuild
*adapted from source: https://www.script-tutorials.com/creating-css3-dropdown-menu-3/
local m.myvar
text to m.myvar  textmerge noshow
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
	<meta charset="utf-8" />
	<meta name="author" content="Script Tutorials" />
	 <title>CSS3 drop down menu </title>
 <style>
/* demo page styles */
body {
	background:#000 url(<<thisform.ybkg>>) no-repeat   ;
	background-size: 100%, auto ;
	margin:0;
	padding:0;
}
.example {
	position:relative;
   // background: black  url(<<thisform.ybkg>>) no-repeat   ;
   //background-size: 100%, auto ;
	width:<<thisform.width-100)>>px;
	height:<<thisform.height-140>>px ;
	border:3px  gold  solid ;
	margin:20px auto;
	padding:15px;
	border-radius:3px;
	-moz-border-radius:3px;
	-webkit-border-radius:3px;
}

/* main menu styles */
.menuholder {
	float:left;
	font:normal bold 11px/35px verdana, sans-serif;
	overflow:hidden;
	position:relative;
}
.menuholder .shadow {
	-moz-box-shadow:0 0 20px rgba(0, 0, 0, 1);
	-o-box-shadow:0 0 20px rgba(0, 0, 0, 1);
	-webkit-box-shadow:0 0 20px rgba(0, 0, 0, 1);
	background:#888;
	box-shadow:0 0 20px rgba(0, 0, 0, 1);
	height:10px;
	left:5%;
	position:absolute;
	top:-9px;
	width:90%;
	z-index:100;
}
.menuholder .back {
	-moz-transition-duration:.4s;
	-o-transition-duration:.4s;
	-webkit-transition-duration:.4s;
	background-color:rgba(0, 0, 0, 0.5);
	height:0;
	width:100%;
}
.menuholder:hover div.back {
	height:250px;
}
ul.menu {
	display:block;
	float:left;
	list-style:none;
	margin:0;
	padding:0 125px;
	position:relative;
}
ul.menu li {
	float:left;
	margin:0 5px 0 0;
}
ul.menu li > a {
	-moz-border-radius:0 0 10px 10px;
	-moz-box-shadow:2px 2px 4px rgba(0, 0, 0, 0.9);
	-moz-transition:all 0.2s ease-in-out;
	-o-border-radius:0 0 10px 10px;
	-o-box-shadow:2px 2px 4px rgba(0, 0, 0, 0.9);
	-o-transition:all 0.2s ease-in-out;
	-webkit-border-bottom-left-radius:10px;
	-webkit-border-bottom-right-radius:10px;
	-webkit-box-shadow:2px 2px 4px rgba(0, 0, 0, 0.9);
	-webkit-transition:all 0.2s ease-in-out;
	border-radius:0 0 10px 10px;
	box-shadow:2px 2px 4px rgba(0, 0, 0, 0.9);
	color:#eee;
	display:block;
	padding:0 10px;
	text-decoration:none;
	transition:all 0.2s ease-in-out;
}
ul.menu li a.red {
	background:#a00;
}
ul.menu li a.orange {
	background:#da0;
}
ul.menu li a.yellow {
	background:#aa0;
}
ul.menu li a.green {
	background:#060;
}
ul.menu li a.blue {
	background:#00a;
}

ul.menu li a.tomato {
	background:#682bc2;
}

ul.menu li a.maroon {
	background:#682bc2;
}
ul.menu li a.violet {
	background:#682bc2;
}
.menu li div.subs {
	left:0;
	overflow:hidden;
	position:absolute;
	top:35px;
	width:0;
}
.menu li div.subs dl {
	-moz-transition-duration:.2s;
	-o-transition-duration:.2s;
	-webkit-transition-duration:.2s;
	float:left;
	margin:0 130px 0 0;
	overflow:hidden;
	padding:40px 0 5% 2%;
	width:0;
}
.menu dt {
	color:#fc0;
	font-family:arial, sans-serif;
	font-size:12px;
	font-weight:700;
	height:20px;
	line-height:20px;
	margin:0;
	padding:0 0 0 10px;
	white-space:nowrap;
}
.menu dd {
	margin:0;
	padding:0;
	text-align:left;
}
.menu dd a {
	background:transparent;
	color:#fff;
	font-size:12px;
	height:20px;
	line-height:20px;
	padding:0 0 0 10px;
	text-align:left;
	white-space:nowrap;
	width:80px;
}
.menu dd a:hover {
	color:#fc0;
}
.menu li:hover div.subs dl {
	-moz-transition-delay:0.2s;
	-o-transition-delay:0.2s;
	-webkit-transition-delay:0.2s;
	margin-right:2%;
	width:21%;
}
ul.menu li:hover > a,ul.menu li > a:hover {
	background:#aaa;
	color:#fff;
	padding:10px 10px 0;
}
ul.menu li a.red:hover,ul.menu li:hover a.red {
	background:#c00;
}
ul.menu li a.orange:hover,ul.menu li:hover a.orange {
	background:#fc0;
}
ul.menu li a.yellow:hover,ul.menu li:hover a.yellow {
	background:#cc0;
}
ul.menu li a.green:hover,ul.menu li:hover a.green {
	background:#080;
}
ul.menu li a.blue:hover,ul.menu li:hover a.blue {
	background:#00c;
}

ul.menu li a.tomato:hover,ul.menu li:hover a.tomato {
background:tomato;
}

ul.menu li a.maroon:hover,ul.menu li:hover a.maroon {
background:maroon;
}

ul.menu li a.violet:hover,ul.menu li:hover a.violet {
background:#8a2be2;
}


.menu li:hover div.subs,.menu li a:hover div.subs {
	width:100%;
}
</style>
</head>
<body  bgcolor=black  oncontextmenu="return false;"  scroll="no">
<div class="example">
	<div class="menuholder">
		<ul class="menu slide">
			<li><a href="yvfp://action1" class="red">Home</a></li>
			<li><a href="#" class="orange">Tutorials</a>
				<div class="subs">
					<dl>
						<dt>Links #1</dt>
						<dd><a href="yvfp://action3">HTML / CSS</a></dd>
						<dd><a href="yvfp://action4">JS / jQuery</a></dd>
						<dd><a href="yvfp://action5">PHP</a></dd>
					</dl>
					<dl>
						<dt>Links #2</dt>
						<dd><a href="yvfp://action6">MySQL</a></dd>
						<dd><a href="yvfp://action7">XSLT</a></dd>
						<dd><a href="yvfp://action8">Ajax</a></dd>
					</dl>
					<dl>
						<dt>Links #3</dt>
						<dd><a href="yvfp://action9">HTML / CSS</a></dd>
						<dd><a href="yvfp://action10">JS / jQuery</a></dd>
						<dd><a href="yvfp://action11">PHP</a></dd>
					</dl>
					<dl>
						<dt>Links #4</dt>
						<dd><a href="yvfp://action12">MySQL</a></dd>
						<dd><a href="yvfp://action13">XSLT</a></dd>
						<dd><a href="yvfp://action14">Ajax</a></dd>
					</dl>
				</div>
			</li>
			<li><a href="#" class="yellow">Resources</a>
				<div class="subs">
					<dl>
						<dt>Links #5</dt>
						<dd><a href="yvfp://action15">PHP</a></dd>
						<dd><a href="yvfp://action16">MySQL</a></dd>
					</dl>
					<dl>
						<dt>Links #6</dt>
						<dd><a href="yvfp://action17">XSLT</a></dd>
						<dd><a href="yvfp://action18">Ajax</a></dd>
					</dl>
					<dl>
						<dt>Links #7</dt>
						<dd><a href="yvfp://action19">HTML / CSS</a></dd>
						<dd><a href="yvfp://action20">JS / jQuery</a></dd>
					</dl>
					<dl>
						<dt>Links #8</dt>
						<dd><a href="yvfp://action21">MySQL</a></dd>
						<dd><a href="yvfp://action22">Ajax</a></dd>
					</dl>
				</div>
			</li>
			<li><a href="yvfp://action23" class="green">Other</a></li>
			<li><a href="yvfp://action24" class="blue">About</a></li>
			 <li><a href="yvfp://action25" class="tomato">Help</a></li>
			 <li><a href="yvfp://action26" class="maroon">Back</a></li>
			 <li><a href="yvfp://action27" class="violet">Exit</a></li>
		</ul>
		<div class="back"></div>
		<div class="shadow"></div>
	</div>
	<div style="clear:both"></div>
</div>
</body>
</html>
endtext

local m.lcdest
m.lcdest=addbs(sys(2023))+"ytemp.html"
strtofile(m.myvar,m.lcdest)
thisform.olecontrol1.navigate(m.lcdest)
thisform.olecontrol1.refresh
ENDPROC

PROCEDURE yactions
*code actions to do from each menu here
lparameters xurl
_cliptext=xurl
messagebox("Yactions method: "+ xurl,0+32+4096,"",800)
do case
case xurl="yvfp://action1/"
messagebox("xurl=yvfp://action1........"+ xurl,0+32+4096,"",800)
run/n notepad

case xurl="yvfp://action2/"
run/n mspaint

case xurl="yvfp://action3/"
run/n explorer

case xurl="yvfp://action4/"
case xurl="yvfp://action5/"
case xurl="yvfp://action6/"
case xurl="yvfp://action7/"
case xurl="yvfp://action8/"
case xurl="yvfp://action9/"
case xurl="yvfp://action10/"
case xurl="yvfp://action11/"
case xurl="yvfp://action12/"
case xurl="yvfp://action13/"
case xurl="yvfp://action14/"
case xurl="yvfp://action15/"
case xurl="yvfp://action16/"
case xurl="yvfp://action17/"
case xurl="yvfp://action18/"
case xurl="yvfp://action19/"
case xurl="yvfp://action20/"
case xurl="yvfp://action21/"
case xurl="yvfp://action22/"
case xurl="yvfp://action23/"
case xurl="yvfp://action24/"
case xurl="yvfp://action25/"
case xurl="yvfp://action26/"

case xurl="yvfp://action27/"
thisform.release

endcase
ENDPROC

PROCEDURE ybuild1
*adapted from source:
local m.myvar
text to m.myvar textmerge noshow
<html>
<head>
	<meta charset="utf-8" />
	<title>CSS3 dropdown menu demo</title>
	<meta name="author" content="Script Tutorials" />
<style>
/* demo page styles */
body {
	background:black;   //#eee;
	margin:0;
	padding:0;
}
.example {
	background:black  url(<<thisform.ybkg>>)  no-repeat  ;
	background-size: 100%, auto ;
	width:770px;
	height:500px;
	border:1px #000 solid;
	margin:20px auto;
	padding:15px;
	border-radius:3px;
	-moz-border-radius:3px;
	-webkit-border-radius:3px;
}

/* main menu styles */
#nav {
	display:inline-block;
	width:100%;
	margin:0px auto;
	padding:0;
 background:#335599 url(bg.png) repeat-x 0 -110px;

	border-radius:10px; /*some css3*/
	-moz-border-radius:10px;
	-webkit-border-radius:10px;
	box-shadow:0 2px 2px rgba(0,0,0, .5);
	-moz-box-shadow:0 2px 2px rgba(0,0,0, .5);
	-webkit-box-shadow:0 2px 2px rgba(0,0,0, .5);
}
#nav li {
	margin:10px;
	float:left;
	position:relative;
	list-style:none;
}
#nav a {
	font-weight:bold;
	color:#e7e5e5;
	text-decoration:none;
	display:block;
	padding:8px 20px;

	border-radius:10px; /*some css3*/
	-moz-border-radius:10px;
	-webkit-border-radius:10px;
	text-shadow:0 2px 2px rgba(0,0,0, .7);
}

/* selected menu element */
#nav .current a, #nav li:hover > a {
	background:#7788aa url(bg.png) repeat-x 0 -20px;
	color:#000;
	border-top:1px solid #f8f8f8;

	box-shadow:0 2px 2px rgba(0,0,0, .7); /*some css3*/
	-moz-box-shadow:0 2px 2px rgba(0,0,0, .7);
	-webkit-box-shadow:0 2px 2px rgba(0,0,0, .7);
	text-shadow:0 2px 2px rgba(255,255,255, 0.7);
}

/* sublevels */
#nav ul li:hover a, #nav li:hover li a {
	background:none;
	border:none;
	color:#000;
}
#nav ul li a:hover {
	background:#335599 url(bg.png) repeat-x 0 -100px;
	color:#fff;
	border-radius:10px; /*some css3*/
	-moz-border-radius:10px;
	-webkit-border-radius:10px;
	text-shadow:0 2px 2px rgba(0,0,0, 0.7);
}

#nav ul li:first-child > a {
	-moz-border-radius-topleft:10px; /*some css3*/
	-moz-border-radius-topright:10px;
	-webkit-border-top-left-radius:10px;
	-webkit-border-top-right-radius:10px;
}
#nav ul li:last-child > a {
	-moz-border-radius-bottomleft:10px; /*some css3*/
	-moz-border-radius-bottomright:10px;
	-webkit-border-bottom-left-radius:10px;
	-webkit-border-bottom-right-radius:10px;
}

/* drop down */
#nav li:hover > ul {
	opacity:1;
	visibility:visible;
}
#nav ul {
	opacity:0;
	visibility:hidden;
	padding:0;
	width:175px;
	position:absolute;
	background:#aabbcc url(bg.png) repeat-x 0 0;
	border:1px solid #7788aa;
	border-radius:10px; /*some css3*/
	-moz-border-radius:10px;
	-webkit-border-radius:10px;
	box-shadow:0 2px 2px rgba(0,0,0, .5);
	-moz-box-shadow:0 2px 2px rgba(0,0,0, .5);
	-webkit-box-shadow:0 2px 2px rgba(0,0,0, .5);
	-moz-transition:opacity .25s linear, visibility .1s linear .1s;
	-webkit-transition:opacity .25s linear, visibility .1s linear .1s;
	-o-transition:opacity .25s linear, visibility .1s linear .1s;
	transition:opacity .25s linear, visibility .1s linear .1s;
}
#nav ul li {
	float:none;
	margin:0;
}
#nav ul a {
	font-weight:normal;
	text-shadow:0 2px 2px rgba(255,255,255, 0.7);
}
#nav ul ul {
	left:160px;
	top:0px;
}
</style>
</head>
<body  bgcolor=black  oncontextmenu="return false;"  scroll="no">
<div class="example">
	<ul id="nav">
		<li class="current"><a href="#">Home</a></li>
		<li><a href="#">Tutorials</a>
			<ul>
				<li><a href="#">HTML / CSS</a></li>
				<li><a href="#">JS / jQuery</a>
					<ul>
						<li><a href="#>jQuery</a></li>
						<li><a href="#">JS</a></li>
					</ul>
				</li>
				<li><a href="#">PHP</a></li>
				<li><a href="#">MySQL</a></li>
				<li><a href="#">XSLT</a></li>
				<li><a href="#">Ajax</a></li>
			</ul>
		</li>
		<li><a href="#">Resources</a>
			<ul>
				<li><a href="#">By category</a>
					<ul>
						<li><a href="#">PHP</a></li>
						<li><a href="#">MySQL</a></li>
						<li><a href="#">XSLT</a></li>
						<li><a href="#">Ajax</a></li>
					</ul>
				</li>
				<li><a href="#">By tag name</a>
					<ul>
						<li><a href="#"">captcha</a></li>
						<li><a href="#'">gallery</a></li>
						<li><a href="#">animation</a></li>
					</ul>
				</li>
			</ul>
		</li>
		<li><a href="#">About</a></li>
		<li><a href="#">Go Back To The Tutorial</a></li>
	</ul>
	<center><p style="color:white;font-family:Georgia;font-bold;font-size:28px;margin-top:<<thisform.olecontrol1.height-140>>px;">Urls/actions are not coded here...its same as first  menu !</p><center>

</div>
	 </body>
</html>
endtext
local m.lcdest
m.lcdest=addbs(sys(2023))+"ytemp.html"
strtofile(m.myvar,m.lcdest)
thisform.olecontrol1.navigate(m.lcdest)
thisform.olecontrol1.refresh
ENDPROC

PROCEDURE ybuild2
*adapted from source:https://designmodo.com/demo/css3dropdownmenu/
local m.myvar
text to m.myvar textmerge noshow
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>CSS3 Menu - Impressionist UI - by Valeriu Timbuc for Design Modo</title>
<style>

/* Reset */
.menu,
.menu ul,
.menu li,
.menu a {
	margin: 0;
	padding: 0;
	border: none;
	outline: none;
}

/* Menu */
.menu {
	height: 40px;
	width: 620px;

	background: #4c4e5a;
	background: -webkit-linear-gradient(top, #4c4e5a 0%,#2c2d33 100%);
	background: -moz-linear-gradient(top, #4c4e5a 0%,#2c2d33 100%);
	background: -o-linear-gradient(top, #4c4e5a 0%,#2c2d33 100%);
	background: -ms-linear-gradient(top, #4c4e5a 0%,#2c2d33 100%);
	background: linear-gradient(top, #4c4e5a 0%,#2c2d33 100%);

	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	border-radius: 5px;
}

.menu li {
	position: relative;
	list-style: none;
	float: left;
	display: block;
	height: 40px;
}

/* Links */

.menu li a {
	display: block;
	padding: 0 14px;
	margin: 6px 0;
	line-height: 28px;
	text-decoration: none;

	border-left: 1px solid #393942;
	border-right: 1px solid #4f5058;

	font-family: Helvetica, Arial, sans-serif;
	font-weight: bold;
	font-size: 13px;

	color: #f3f3f3;
	text-shadow: 1px 1px 1px rgba(0,0,0,.6);

	-webkit-transition: color .2s ease-in-out;
	-moz-transition: color .2s ease-in-out;
	-o-transition: color .2s ease-in-out;
	-ms-transition: color .2s ease-in-out;
	transition: color .2s ease-in-out;
}

.menu li:first-child a { border-left: none; }
.menu li:last-child a{ border-right: none; }

.menu li:hover > a { color: #8fde62; }

/* Sub Menu */

.menu ul {
	position: absolute;
	top: 40px;
	left: 0;
	opacity: 0;
	background: #1f2024;
	-webkit-border-radius: 0 0 5px 5px;
	-moz-border-radius: 0 0 5px 5px;
	border-radius: 0 0 5px 5px;
	-webkit-transition: opacity .25s ease .1s;
	-moz-transition: opacity .25s ease .1s;
	-o-transition: opacity .25s ease .1s;
	-ms-transition: opacity .25s ease .1s;
	transition: opacity .25s ease .1s;
}

.menu li:hover > ul { opacity: 1; }
.menu ul li {
	height: 0;
	overflow: hidden;
	padding: 0;
	-webkit-transition: height .25s ease .1s;
	-moz-transition: height .25s ease .1s;
	-o-transition: height .25s ease .1s;
	-ms-transition: height .25s ease .1s;
	transition: height .25s ease .1s;
}

.menu li:hover > ul li {
	height: 36px;
	overflow: visible;
	padding: 0;
}
.menu ul li a {
	width: 100px;
	padding: 4px 0 4px 40px;
	margin: 0;

	border: none;
	border-bottom: 1px solid #353539;
}
.menu ul li:last-child a { border: none; }

/* Icons */
.menu a.documents { background: url(https://designmodo.com/demo/css3dropdownmenu/img/docs.png) no-repeat 6px center; }
.menu a.messages { background: url(https://designmodo.com/demo/css3dropdownmenu/img/bubble.png) no-repeat 6px center; }
.menu a.signout { background: url(https://designmodo.com/demo/css3dropdownmenu/img/arrow.png) no-repeat 6px center; }
</style>
	<style type="text/css">
		html, body { margin: 0;	padding: 0; }
		body { margin:0px; background: black  url(<<thisform.ybkg>>) no-repeat top center ; background-size: 100%, auto ;}
		ul.menu { margin: 20px auto 0 auto; }

	</style>
<meta name="robots" content="noindex,follow" />
</head>
<body  bgcolor=black  oncontextmenu="return false;"  scroll="no">
<ul class="menu">
	<li><a href="#">My dashboard</a></li>
	<li><a href="#">Likes</a></li>
	<li><a href="#">Views</a>
		<ul>
			<li><a href="#" class="documents">Documents</a></li>
			<li><a href="#" class="messages">Messages</a></li>
			<li><a href="#" class="signout">Sign Out</a></li>
		</ul>

	</li>
	<li><a href="#">Uploads</a></li>
	<li><a href="#">Videos</a></li>
	<li><a href="#">Documents</a></li>
	<li><a href="#">Help</a></li>
   <li><a href="#">Exit</a></li>
</ul> <!-- end .menu -->
<center><p style="color:white;font-family:Georgia;font-bold;font-size:28px;margin-top:<<thisform.olecontrol1.height-100>>px;">Urls/actions are not coded here...its same as first menu!</p><center>
</body>
</html>
endtext
local m.lcdest
m.lcdest=addbs(sys(2023))+"ytemp.html"
strtofile(m.myvar,m.lcdest)
thisform.olecontrol1.navigate(m.lcdest)
thisform.olecontrol1.refresh
ENDPROC

PROCEDURE ybuild3
local m.img
text to m.img noshow
iVBORw0KGgoAAAANSUhEUgAAABIAAAAPCAMAAADeWG8gAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyBpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMC1jMDYwIDYxLjEzNDc3NywgMjAxMC8wMi8xMi0xNzozMjowMCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNSBXaW5kb3dzIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjE2QjAxNjRDOUNEOTExRTE4RTNFRkI1RDQ2MUYxOTQ3IiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOjE2QjAxNjREOUNEOTExRTE4RTNFRkI1RDQ2MUYxOTQ3Ij4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MTZCMDE2NEE5Q0Q5MTFFMThFM0VGQjVENDYxRjE5NDciIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6MTZCMDE2NEI5Q0Q5MTFFMThFM0VGQjVENDYxRjE5NDciLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz42AEtnAAAABlBMVEX///////9VfPVsAAAAAnRSTlP/AOW3MEoAAAAWSURBVHjaYmAgFzBiACKFho6NAAEGAD07AG1pn932AAAAAElFTkSuQmCC) no-repeat 10px center, -moz-linear-gradient(#444, #111)
endtext

local m.myvar
text to m.myvar textmerge noshow
<!DOCTYPE html>
<html>
<head>
	<title>CSS3 animated dropdown menu *- demo</title>
	<meta name="viewport" content="width=device-width" />
	<style>
	body{
		background: black  url(<<thisform.ybkg>>) no-repeat   ;
		background-size: 100%, auto ;
		font: 13px 'trebuchet MS', Arial, Helvetica;
	}

	h2, p {
		text-align: center;
		color: #444;
		text-shadow: 0 1px 0 #fff;
	}

	a {
		color: #2A679F;
	}
	/* You don't need the above styles, they are demo-specific ----------- */

	#menu, #menu ul {
		margin: 0;
		padding: 0;
		list-style: none;
	}

	#menu {
		width: 100%;
		margin: 0px auto;
		border: 1px solid #222;
		background-color: #111;
		background-image: -moz-linear-gradient(#444, #111);
		background-image: -webkit-gradient(linear, left top, left bottom, from(#444), to(#111));
		background-image: -webkit-linear-gradient(#444, #111);
		background-image: -o-linear-gradient(#444, #111);
		background-image: -ms-linear-gradient(#444, #111);
		background-image: linear-gradient(#444, #111);
		-moz-border-radius: 6px;
		-webkit-border-radius: 6px;
		border-radius: 6px;
		-moz-box-shadow: 0 1px 1px #777, 0 1px 0 #666 inset;
		-webkit-box-shadow: 0 1px 1px #777, 0 1px 0 #666 inset;
		box-shadow: 0 1px 1px #777, 0 1px 0 #666 inset;
	}
	#menu:before,
	#menu:after {
		content: "";
		display: table;
	}

	#menu:after {
		clear: both;
	}

	#menu {
		zoom:1;
	}

	#menu li {
		float: left;
		border-right: 1px solid #222;
		-moz-box-shadow: 1px 0 0 #444;
		-webkit-box-shadow: 1px 0 0 #444;
		box-shadow: 1px 0 0 #444;
		position: relative;
	}
	#menu a {
		float: left;
		padding: 12px 30px;
		color: #999;
		text-transform: uppercase;
		font: bold 12px Arial, Helvetica;
		text-decoration: none;
		text-shadow: 0 1px 0 #000;
	}

	#menu li:hover > a {
		color: #fafafa;
	}

	*html #menu li a:hover { /* IE6 only */
		color: #fafafa;
	}
	#menu ul {
		margin: 20px 0 0 0;
		_margin: 0; /*IE6 only*/
		opacity: 0;
		visibility: hidden;
		position: absolute;
		top: 38px;
		left: 0;
		z-index: 1;
		background: #444;
		background: -moz-linear-gradient(#444, #111);
		background-image: -webkit-gradient(linear, left top, left bottom, from(#444), to(#111));
		background: -webkit-linear-gradient(#444, #111);
		background: -o-linear-gradient(#444, #111);
		background: -ms-linear-gradient(#444, #111);
		background: linear-gradient(#444, #111);
		-moz-box-shadow: 0 -1px rgba(255,255,255,.3);
		-webkit-box-shadow: 0 -1px 0 rgba(255,255,255,.3);
		box-shadow: 0 -1px 0 rgba(255,255,255,.3);
		-moz-border-radius: 3px;
		-webkit-border-radius: 3px;
		border-radius: 3px;
		-webkit-transition: all .2s ease-in-out;
		-moz-transition: all .2s ease-in-out;
		-ms-transition: all .2s ease-in-out;
		-o-transition: all .2s ease-in-out;
		transition: all .2s ease-in-out;
	}
	#menu li:hover > ul {
		opacity: 1;
		visibility: visible;
		margin: 0;
	}

	#menu ul ul {
		top: 0;
		left: 150px;
		margin: 0 0 0 20px;
		_margin: 0; /*IE6 only*/
		-moz-box-shadow: -1px 0 0 rgba(255,255,255,.3);
		-webkit-box-shadow: -1px 0 0 rgba(255,255,255,.3);
		box-shadow: -1px 0 0 rgba(255,255,255,.3);
	}
	#menu ul li {
		float: none;
		display: block;
		border: 0;
		_line-height: 0; /*IE6 only*/
		-moz-box-shadow: 0 1px 0 #111, 0 2px 0 #666;
		-webkit-box-shadow: 0 1px 0 #111, 0 2px 0 #666;
		box-shadow: 0 1px 0 #111, 0 2px 0 #666;
	}

	#menu ul li:last-child {
		-moz-box-shadow: none;
		-webkit-box-shadow: none;
		box-shadow: none;
	}
	#menu ul a {
		padding: 10px;
		width: 130px;
		_height: 10px; /*IE6 only*/
		display: block;
		white-space: nowrap;
		float: none;
		text-transform: none;
	}
	#menu ul a:hover {
		background-color: #0186ba;
		background-image: -moz-linear-gradient(#04acec,  #0186ba);
		background-image: -webkit-gradient(linear, left top, left bottom, from(#04acec), to(#0186ba));
		background-image: -webkit-linear-gradient(#04acec, #0186ba);
		background-image: -o-linear-gradient(#04acec, #0186ba);
		background-image: -ms-linear-gradient(#04acec, #0186ba);
		background-image: linear-gradient(#04acec, #0186ba);
	}
	#menu ul li:first-child > a {
		-moz-border-radius: 3px 3px 0 0;
		-webkit-border-radius: 3px 3px 0 0;
		border-radius: 3px 3px 0 0;
	}
	#menu ul li:first-child > a:after {
		content: '';
		position: absolute;
		left: 40px;
		top: -6px;
		border-left: 6px solid transparent;
		border-right: 6px solid transparent;
		border-bottom: 6px solid #444;
	}
	#menu ul ul li:first-child a:after {
		left: -6px;
		top: 50%;
		margin-top: -6px;
		border-left: 0;
		border-bottom: 6px solid transparent;
		border-top: 6px solid transparent;
		border-right: 6px solid #3b3b3b;
	}
	#menu ul li:first-child a:hover:after {
		border-bottom-color: #04acec;
	}
	#menu ul ul li:first-child a:hover:after {
		border-right-color: #0299d3;
		border-bottom-color: transparent;
	}
	#menu ul li:last-child > a {
		-moz-border-radius: 0 0 3px 3px;
		-webkit-border-radius: 0 0 3px 3px;
		border-radius: 0 0 3px 3px;
	}
	/* Mobile */
	#menu-trigger {
		display: none;
	}

	@media screen and (max-width: 600px) {

		/* nav-wrap */
		#menu-wrap {
			position: relative;
		}

		#menu-wrap * {
			-moz-box-sizing: border-box;
			-webkit-box-sizing: border-box;
			box-sizing: border-box;
		}

		/* menu icon */
		#menu-trigger {
			display: block; /* show menu icon */
			height: 40px;
			line-height: 40px;
			cursor: pointer;
			padding: 0 0 0 35px;
			border: 1px solid #222;
			color: #fafafa;
			font-weight: bold;
			background-color: #111;
			background: url(data:image/png;base64,<<m.img>>) no-repeat 10px center, -moz-linear-gradient(#444, #111);
			background: url(data:image/png;base64,<<m.img>>) no-repeat 10px center, -webkit-linear-gradient(#444, #111);
			background: url(data:image/png;base64,<<m.img>>) no-repeat 10px center, -o-linear-gradient(#444, #111);
			background: url(data:image/png;base64,<<m.img>>) no-repeat 10px center, -ms-linear-gradient(#444, #111);
			background: url(data:image/png;base64,<<m.img>>) no-repeat 10px center, linear-gradient(#444, #111);
			-moz-border-radius: 6px;
			-webkit-border-radius: 6px;
			border-radius: 6px;
			-moz-box-shadow: 0 1px 1px #777, 0 1px 0 #666 inset;
			-webkit-box-shadow: 0 1px 1px #777, 0 1px 0 #666 inset;
			box-shadow: 0 1px 1px #777, 0 1px 0 #666 inset;
		}
		/* main nav */
		#menu {
			margin: 0; padding: 10px;
			position: absolute;
			top: 40px;
			width: 100%;
			z-index: 1;
			background-color: #444;
			display: none;
			-moz-box-shadow: none;
			-webkit-box-shadow: none;
			box-shadow: none;
		}
		#menu:after {
			content: '';
			position: absolute;
			left: 25px;
			top: -8px;
			border-left: 8px solid transparent;
			border-right: 8px solid transparent;
			border-bottom: 8px solid #444;
		}
		#menu ul {
			position: static;
			visibility: visible;
			opacity: 1;
			margin: 0;
			background: none;
			-moz-box-shadow: none;
			-webkit-box-shadow: none;
			box-shadow: none;
		}
		#menu ul ul {
			margin: 0 0 0 20px !important;
			-moz-box-shadow: none;
			-webkit-box-shadow: none;
			box-shadow: none;
		}
		#menu li {
			position: static;
			display: block;
			float: none;
			border: 0;
			margin: 5px;
			-moz-box-shadow: none;
			-webkit-box-shadow: none;
			box-shadow: none;
		}

		#menu ul li{
			margin-left: 20px;
			-moz-box-shadow: none;
			-webkit-box-shadow: none;
			box-shadow: none;
		}
		#menu a{
			display: block;
			float: none;
			padding: 0;
			color: #999;
		}
		#menu a:hover{
			color: #fafafa;
		}
		#menu ul a{
			padding: 0;
			width: auto;
		}
		#menu ul a:hover{
			background: none;
		}
		#menu ul li:first-child a:after,
		#menu ul ul li:first-child a:after {
			border: 0;
		}
	}
	@media screen and (min-width: 600px) {
		#menu {
			display: block !important;
		}
	}
	/* iPad */
	.no-transition {
		-webkit-transition: none;
		-moz-transition: none;
		-ms-transition: none;
		-o-transition: none;
		transition: none;
		opacity: 1;
		visibility: visible;
		display: none;
	}
	#menu li:hover > .no-transition {
		display: block;
	}
	</style>
</head>
<body  bgcolor=black  oncontextmenu="return false;"  scroll="no">
<nav id="menu-wrap">
	<ul id="menu">
		<li><a href="#">Home</a></li>
		<li>
			<a href="#">Categories</a>
			<ul>
				<li>
					<a href="#">CSS</a>
					<ul>
						<li><a href="#">Item 11</a></li>

						<li><a href="#">Item 12</a></li>
						<li><a href="#">Item 13</a></li>
						<li><a href="#">Item 14</a></li>
					</ul>
				</li>
				<li>
					<a href="#">Graphic design</a>

					<ul>
						<li><a href="#">Item 21</a></li>
						<li><a href="#">Item 22</a></li>
						<li><a href="#">Item 23</a></li>
						<li><a href="#">Item 24</a></li>
					</ul>
				</li>

				<li>
					<a href="#">Development tools</a>
					<ul>
						<li><a href="#">Item 31</a></li>
						<li><a href="#">Item 32</a></li>
						<li><a href="#">Item 33</a></li>
						<li><a href="#">Item 34</a></li>

					</ul>
				</li>
				<li>
					<a href="#">Web design</a>
					<ul>
						<li><a href="#">Item 41</a></li>
						<li><a href="#">Item 42</a></li>
						<li><a href="#">Item 43</a></li>

						<li><a href="#">Item 44</a></li>
					</ul>
				</li>
			</ul>
		</li>
		<li>
			<a href="#">Work</a>
			<ul>

				<li>
					<a href="#">Work 1</a>
					<ul>
						<li>
							<a href="#">Work 11</a>
							<ul>
								<li><a href="#">Work 111</a></li>
								<li><a href="#">Work 112</a></li>

								<li><a href="#">Work 113</a></li>
							</ul>
						</li>
						<li>
							<a href="#">Work 12</a>
							<ul>
								<li><a href="#">Work 121</a></li>
								<li><a href="#">Work 122</a></li>

								<li><a href="#">Work 123</a></li>
							</ul>
						</li>
						<li>
							<a href="#">Work 13</a>
							<ul>
								<li><a href="#">Work 131</a></li>
								<li><a href="#">Work 132</a></li>

								<li><a href="#">Work 133</a></li>
							</ul>
						</li>
					</ul>
				</li>
				<li>
					<a href="#">Work 2</a>
					<ul>
						<li>

							<a href="#">Work 21</a>
							<ul>
								<li><a href="#">Work 211</a></li>
								<li><a href="#">Work 212</a></li>
								<li><a href="#">Work 213</a></li>
							</ul>
						</li>

						<li>
							<a href="#">Work 22</a>
							<ul>
								<li><a href="#">Work 221</a></li>
								<li><a href="#">Work 222</a></li>
								<li><a href="#">Work 223</a></li>
							</ul>
						</li>

						<li>
							<a href="#">Work 23</a>
							<ul>
								<li><a href="#">Work 231</a></li>
								<li><a href="#">Work 232</a></li>
								<li><a href="#">Work 233</a></li>
							</ul>
						</li>

					</ul>
				</li>
				<li>
					<a href="#">Work 3</a>
					<ul>
						<li>
							<a href="#">Work 31</a>
							<ul>

								<li><a href="#">Work 311</a></li>
								<li><a href="#">Work 312</a></li>
								<li><a href="#">Work 313</a></li>
							</ul>
						</li>
						<li>
							<a href="#">Work 32</a>

							<ul>
								<li><a href="#">Work 321</a></li>
								<li><a href="#">Work 322</a></li>
								<li><a href="#">Work 323</a></li>
							</ul>
						</li>
						<li>
							<a href="#">Work 33</a>

							<ul>
								<li><a href="#">Work 331</a></li>
								<li><a href="#">Work 332</a></li>
								<li><a href="#">Work 333</a></li>
							</ul>
						</li>
					</ul>
				</li>

			</ul>
		</li>
		<li><a href="#">Help </a></li>
		<li><a href="#">To DO </a></li>
		<li><a href="#">About</a></li>
		<li><a href="#">Contacts</a></li>
		<li><a href="#">Exit</a></li>
	</ul>
</nav>
<center><p style="color:white;font-family:Georgia;font-bold;font-size:28px;margin-top:<<thisform.olecontrol1.height-90>>px;">Urls/Actions are not coded here...its same as first menu !</p><center>
</body>
</html>
endtext
local m.lcdest
m.lcdest=addbs(sys(2023))+"ytemp.html"
strtofile(m.myvar,m.lcdest)
thisform.olecontrol1.navigate(m.lcdest)
thisform.olecontrol1.refresh
ENDPROC

PROCEDURE Load
set safe off
_screen.windowstate=1
ENDPROC

PROCEDURE Init

publi m.yrep
m.yrep=addbs(justpath(sys(16,1)))
set defa to (yrep)
thisform.optionGroup1.interactiveChange()
thisform.combo1.interactiveChange()
ENDPROC

PROCEDURE Destroy
clea events
ENDPROC

PROCEDURE olecontrol1.Refresh
*** Méthode de contrôle ActiveX ***
nodefault
ENDPROC

PROCEDURE olecontrol1.BeforeNavigate2
	  *** Événement de contrôle ActiveX  ***
Lparameters pdisp, url, Flags, targetframename, postdata, headers, Cancel
		Nodefault
	 *  wait window url nowait
		If Lower(Substr(allt(url),1,7))== "yvfp://"
			Thisform.yurl=allt(url)
			Thisform.yactions(thisform.yurl)
			Cancel=.T. &&this prevent the browser to do the default action .
			Return .F.
		Endi
ENDPROC

PROCEDURE olecontrol1.Init
this .silent=.t.
ENDPROC

PROCEDURE optiongroup1.InteractiveChange
*Internet must be connected from grabbing web images urls
*can replace these urls with disc images as well

do case
case this.value=1
*thisform.ybkg=m.yrep+"background.jpg"
thisform.ybkg="http://www.tazmaltvoyages.com/medias/album/181512-uladlk3srvujtaaxtnbr1bvns514rf-012-h213958-l.jpg"

case this.value=2
*thisform.ybkg=m.yrep+"clouds-in-blue-sky.jpg"
thisform.ybkg="http://p5.storage.canalblog.com/56/30/67822/29333135.jpg"

case this.value=3
*thisform.ybkg=m.yrep+"background.jpg"
thisform.ybkg="http://p2.storage.canalblog.com/25/29/67822/29333134.jpg"

case this.value=4
*thisform.ybkg=m.yrep+"background1.jpg"
thisform.ybkg="http://www.tazmaltvoyages.com/medias/album/img-0135-atakor-taessa-raw.jpg"
case this.value=5
*thisform.ybkg=m.yrep+"background.jpg"
thisform.ybkg="http://www.tazmaltvoyages.com/medias/album/079-79.jpg"

case this.value=6
*thisform.ybkg=m.yrep+"background.jpg"
thisform.ybkg="http://blog.uniterre.com/uploads/t/tassili/1113207.jpg"

case this.value=7
*thisform.ybkg=m.yrep+"background.jpg"
thisform.ybkg="http://whc.unesco.org/uploads/thumbs/site_0179_0002-500-375-19700101010000.jpg"

case this.value=8
*thisform.ybkg=m.yrep+"background.jpg"
thisform.ybkg="http://whc.unesco.org/uploads/thumbs/site_0179_0004-500-375-19700101010000.jpg"

endcase
thisform.ybkg=strtran(thisform.ybkg,"\","/")

thisform.combo1.interactiveChange()
ENDPROC

PROCEDURE optiongroup1.Init
with this
.setall("backstyle",0,"optionButton")
.setall("mousepointer",15,"optionButton")
.setall("caption","","optionButton")
.setall("autosize",.t.,"optionButton")
.autosize=.t.
.borderstyle=0
endwith
ENDPROC

PROCEDURE combo1.InteractiveChange
do case
case thisform.combo1.value=1
thisform.ybuild()

case thisform.combo1.value=2
thisform.ybuild1()

case thisform.combo1.value=3
thisform.ybuild2()

case thisform.combo1.value=4
thisform.ybuild3()
endcase

ENDPROC

PROCEDURE combo1.Init
with this
.additem("menu 1")
.additem("menu 2")
.additem("menu 3")
.additem("menu 4")
.listindex=1
.value=1
.style=2
endwith
ENDPROC

ENDDEFINE
*
*-- EndDefine:ycss_menu
