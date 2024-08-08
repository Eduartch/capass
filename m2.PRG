
*3* a web mega  menu can embed too links .i found this one interestings because its built only with css and easy to use from vfp.
*its adapted from this link:https://code.tutsplus.com/tutorials/how-to-build-a-kick-butt-css3-mega-drop-down-menu--net-15129
*all links can be coded to redirected to vfp codes and working in vfp namespace (see the beforeNavigate2 method).

Publi oform
oform=Newobject("ywebMenu")
oform.Show
Read Events
Retu
*
Define Class ywebMenu As Form
	Height = 515
	Width = 974
	ShowWindow = 2
	AutoCenter = .T.
	Caption = "A mega menu  demo (links are not coded)"
	Name = "Form1"

	Add Object olecontrol1 As OleControl With ;
		Oleclass="shell.explorer.2",;
		Top = 0, ;
		Left = 0, ;
		Height = 516, ;
		Width = 985, ;
		Anchor = 15, ;
		Name = "Olecontrol1"

	Procedure ybuild
	*code adapted from https://code.tutsplus.com/tutorials/how-to-build-a-kick-butt-css3-mega-drop-down-menu--net-15129
	Local m.myvar
	TEXT to m.myvar noshow
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<style>
		body{ background-color:black;
		background:url('https://s-media-cache-ak0.pinimg.com/originals/e1/a0/ef/e1a0ef685ab2c885a3b837db6f6ebd6d.gif') repeat;
		}
		body, ul, li {
			font-size:14px;
			font-family:Arial, Helvetica, sans-serif;
			line-height:21px;
			text-align:left;
		}

		h1 {
  margin: 0;
  margin-top:200px;
  font: bold 100px/1 "Helvetica Neue", Helvetica, Arial, sans-serif;
  color: #fff;
  text-shadow: 0 1px 0 #cccccc, 0 2px 0 #c9c9c9, 0 3px 0 #bbbbbb, 0 4px 0 #b9b9b9, 0 5px 0 #aaaaaa, 0 6px 1px rgba(0, 0, 0, 0.1), 0 0 5px rgba(0, 0, 0, 0.1), 0 1px 3px rgba(0, 0, 0, 0.3), 0 3px 5px rgba(0, 0, 0, 0.2), 0 5px 10px rgba(0, 0, 0, 0.25), 0 10px 10px rgba(0, 0, 0, 0.2), 0 20px 20px rgba(0, 0, 0, 0.15);
  -webkit-transition: .2s all linear;
}


		#menu {
			list-style:none;
			width:940px;
			margin:30px auto 0px auto;
			height:43px;
			padding:0px 20px 0px 20px;

			/* Rounded Corners */
			-moz-border-radius: 10px;
			-webkit-border-radius: 10px;
			border-radius: 10px;

			/* Background color and gradients */
			background: #014464;
			background: -moz-linear-gradient(top, #0272a7, #013953);
			background: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#0272a7), to(#013953));

			/* Borders */
			border: 1px solid #002232;
			-moz-box-shadow:inset 0px 0px 1px #edf9ff;
			-webkit-box-shadow:inset 0px 0px 1px #edf9ff;
			box-shadow:inset 0px 0px 1px #edf9ff;
		}

		#menu li {
			float:left;
			display:block;
			text-align:center;
			position:relative;
			padding: 4px 10px 4px 10px;
			margin-right:30px;
			margin-top:7px;
			border:none;
		}

		#menu li:hover {
			border: 1px solid #777777;
			padding: 4px 9px 4px 9px;

			/* Background color and gradients */
			background: #F4F4F4;
			background: -moz-linear-gradient(top, #F4F4F4, #EEEEEE);
			background: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#F4F4F4), to(#EEEEEE));

			/* Rounded corners */
			-moz-border-radius: 5px 5px 0px 0px;
			-webkit-border-radius: 5px 5px 0px 0px;
			border-radius: 5px 5px 0px 0px;
		}

		#menu li a {
			font-family:Arial, Helvetica, sans-serif;
			font-size:14px;
			color: #EEEEEE;
			display:block;
			outline:0;
			text-decoration:none;
			text-shadow: 1px 1px 1px #000;
		}

		#menu li:hover a {
			color:#161616;
			text-shadow: 1px 1px 1px #ffffff;
		}
		#menu li .drop {
			padding-right:21px;
			background:url("img/drop.png") no-repeat right 8px;
		}
		#menu li:hover .drop {
			background:url("img/drop.png") no-repeat right 7px;
		}

		.dropdown_1column,
		.dropdown_2columns,
		.dropdown_3columns,
		.dropdown_4columns,
		.dropdown_5columns {
			margin:4px auto;
			float:left;
			position:absolute;
			left:-999em; /* Hides the drop down */
			text-align:left;
			padding:10px 5px 10px 5px;
			border:1px solid #777777;
			border-top:none;

			/* Gradient background */
			background:#F4F4F4;
			background: -moz-linear-gradient(top, #EEEEEE, #BBBBBB);
			background: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#EEEEEE), to(#BBBBBB));

			/* Rounded Corners */
			-moz-border-radius: 0px 5px 5px 5px;
			-webkit-border-radius: 0px 5px 5px 5px;
			border-radius: 0px 5px 5px 5px;
		}
		.dropdown_1column {width: 140px;}
		.dropdown_2columns {width: 280px;}
		.dropdown_3columns {width: 420px;}
		.dropdown_4columns {width: 560px;}
		.dropdown_5columns {width: 700px;}

		#menu li:hover .dropdown_1column,
		#menu li:hover .dropdown_2columns,
		#menu li:hover .dropdown_3columns,
		#menu li:hover .dropdown_4columns,
		#menu li:hover .dropdown_5columns {
			left:-1px;
			top:auto;
		}

		.col_1,
		.col_2,
		.col_3,
		.col_4,
		.col_5 {
			display:inline;
			float: left;
			position: relative;
			margin-left: 5px;
			margin-right: 5px;
		}
		.col_1 {width:130px;}
		.col_2 {width:270px;}
		.col_3 {width:410px;}
		.col_4 {width:550px;}
		.col_5 {width:690px;}

		#menu .menu_right {
			float:right;
			margin-right:0px;
		}
		#menu li .align_right {
			/* Rounded Corners */
			-moz-border-radius: 5px 0px 5px 5px;
		    -webkit-border-radius: 5px 0px 5px 5px;
		    border-radius: 5px 0px 5px 5px;
		}

		#menu li:hover .align_right {
			left:auto;
			right:-1px;
			top:auto;
		}
		#menu p, #menu h2, #menu h3, #menu ul li {
			font-family:Arial, Helvetica, sans-serif;
			line-height:21px;
			font-size:12px;
			text-align:left;
			text-shadow: 1px 1px 1px #FFFFFF;
		}
		#menu h2 {
			font-size:21px;
			font-weight:400;
			letter-spacing:-1px;
			margin:7px 0 14px 0;
			padding-bottom:14px;
			border-bottom:1px solid #666666;
		}
		#menu h3 {
			font-size:14px;
			margin:7px 0 14px 0;
			padding-bottom:7px;
			border-bottom:1px solid #888888;
		}
		#menu p {
			line-height:18px;
			margin:0 0 10px 0;
		}
		#menu li:hover div a {
			font-size:12px;
			color:#015b86;
		}
		#menu li:hover div a:hover {
			color:#029feb;
		}

		.strong {
			font-weight:bold;
		}
		.italic {
			font-style:italic;
		}
		.imgshadow { /* Better style on light background */
			background:#FFFFFF;
			padding:4px;
			border:1px solid #777777;
			margin-top:5px;
			-moz-box-shadow:0px 0px 5px #666666;
			-webkit-box-shadow:0px 0px 5px #666666;
			box-shadow:0px 0px 5px #666666;
		}
		.img_left { /* Image sticks to the left */
			width:auto;
			float:left;
			margin:5px 15px 5px 5px;
		}
		#menu li .black_box {
			background-color:#333333;
			color: #eeeeee;
			text-shadow: 1px 1px 1px #000;
			padding:4px 6px 4px 6px;

			/* Rounded Corners */
			-moz-border-radius: 5px;
		    -webkit-border-radius: 5px;
		    border-radius: 5px;

			/* Shadow */
			-webkit-box-shadow:inset 0 0 3px #000000;
			-moz-box-shadow:inset 0 0 3px #000000;
			box-shadow:inset 0 0 3px #000000;
		}
		#menu li ul {
			list-style:none;
			padding:0;
			margin:0 0 12px 0;
		}
		#menu li ul li {
			font-size:12px;
			line-height:24px;
			position:relative;
			text-shadow: 1px 1px 1px #ffffff;
			padding:0;
			margin:0;
			float:none;
			text-align:left;
			width:130px;
		}
		#menu li ul li:hover {
			background:none;
			border:none;
			padding:0;
			margin:0;
		}

		#menu li .greybox li {
			background:#F4F4F4;
			border:1px solid #bbbbbb;
			margin:0px 0px 4px 0px;
			padding:4px 6px 4px 6px;
			width:116px;

			/* Rounded Corners */
			-moz-border-radius: 5px;
		    -webkit-border-radius: 5px;
		    -khtml-border-radius: 5px;
		    border-radius: 5px;
		}
		#menu li .greybox li:hover {
			background:#ffffff;
			border:1px solid #aaaaaa;
			padding:4px 6px 4px 6px;
			margin:0px 0px 4px 0px;
		}
		</style>
		<title>Mega Drop Down Menu</title>
		<!--[if IE 6]>
		<style>
		body {behavior: url("csshover3.htc");}
		#menu li .drop {background:url("img/drop.gif") no-repeat right 8px;
		</style>
		<![endif]-->
		</head>
		<body  oncontextmenu="return false;"  >

		<ul id="menu">
		    		    <li><a href="#" class="drop">Home</a><!-- Begin Home Item -->
		    		        <div class="dropdown_2columns"><!-- Begin 2 columns container -->
		            <div class="col_2">
		                <h2>Welcome !</h2>
		            </div>
		            <div class="col_2">
		            <p style="color:red;"><u> this is a demo of a mega menu handling too menus item in many ways.the links here are not coded but can use ths beforenavigate oBrowser method to redirects any action to vfp .</u></>
		             <center><img src="http://img.over-blog-kiwi.com/1/43/54/07/20160316/ob_6147b9_fox.png" width="80" height="80" alt="" /></center>
		                <p>Hi and welcome here ! This is a showcase of the possibilities of this awesome Mega Drop Down Menu.</p>
		                <p>This item comes with a large range of prepared typographic stylings such as headings, lists, etc.</p>
		            </div>

		            <div class="col_2">
		                <h2>Cross Browser Support</h2>
		            </div>

		            <div class="col_1">
		                <img src="https://cdn.tutsplus.com/net/uploads/legacy/819_megamenu/demo/img/browsers.png" width="125" height="48" alt="" />
		            </div>

		            <div class="col_1">
		                <p>This mega menu has been tested in all major browsers.</p>
		            </div>

		        </div><!-- End 2 columns container -->

		    </li><!-- End Home Item -->

		    <li><a href="#" class="drop">5 Columns</a><!-- Begin 5 columns Item -->

		        <div class="dropdown_5columns"><!-- Begin 5 columns container -->

		            <div class="col_5">
		                <h2>This is an example of a large container with 5 columns</h2>
		            </div>
		            <div class="col_1">
		                <p class="black_box">This is a dark grey box text. Fusce in metus at enim porta lacinia vitae a arcu. Sed sed lacus nulla mollis porta quis.</p>
		            </div>
		            <div class="col_1">
		                <p>Phasellus vitae sapien ac leo mollis porta quis sit amet nisi. Mauris hendrerit, metus cursus accumsan tincidunt.</p>
		            </div>
		            <div class="col_1">
		                <p class="italic">This is a sample of an italic text. Consequat scelerisque. Fusce sed lectus at arcu mollis accumsan at nec nisi porta quis sit amet.</p>
		            </div>
		            <div class="col_1">
		                <p>Curabitur euismod gravida ante nec commodo. Nunc dolor nulla, semper in ultricies vitae, vulputate porttitor neque.</p>
		            </div>
		            <div class="col_1">
		                <p class="strong">This is a sample of a bold text. Aliquam sodales nisi nec felis hendrerit ac eleifend lectus feugiat scelerisque.</p>
		            </div>
		            <div class="col_5">
		                <h2>Here is some content with side images</h2>
		            </div>
		            <div class="col_3">
		                <img src="https://lh3.googleusercontent.com/UA9TO-BnbRXfSLNvfDB--VRR6t9-zYukvIxXqwfs1tBdqO8jK4PKmZ9rwFhZdcsF6X05nq-6tPFF9rPhb59HPbeuJggW677s=w293-h220" width="70" height="70" class="img_left imgshadow" alt="" />
		                <p>Maecenas eget eros lorem, nec pellentesque lacus. Aenean dui orci, rhoncus sit amet tristique eu, tristique sed odio. Praesent ut interdum elit. Sed in sem mauris. Aenean a commodo mi. Praesent augue lacus.<a href="#">Read more...</a></p>
		                 <img src="https://lh3.googleusercontent.com/eWp1G7UtJLHkgAm4rRWKLCY3uPoa8S9L-UJ6GIrVdLcDld-SZSJc2LHwzJbHLGKNWzajV7OwQVffA9654DmhxMPy2aEeUBBK=w293-h220" width="70" height="70" class="img_left imgshadow" alt="" />
		                <p>Aliquam elementum felis quis felis consequat scelerisque. Fusce sed lectus at arcu mollis accumsan at nec nisi. Aliquam pretium mollis fringilla. Nunc in leo urna, eget varius metus. Aliquam sodales nisi.<a href="#">Read more...</a></p>
		            </div>
		            <div class="col_2">
		                <p class="black_box">This is a black box, you can use it to highligh some content. Sed sed lacus nulla, et lacinia risus. Phasellus vitae sapien ac leo mollis porta quis sit amet nisi. Mauris hendrerit, metus cursus accumsan tincidunt.Quisque vestibulum nisi non nunc blandit placerat. Mauris facilisis, risus ut lobortis posuere, diam lacus congue lorem, ut condimentum ligula est vel orci. Donec interdum lacus at velit varius gravida. Nulla ipsum risus.</p>
		            </div>

		        </div><!-- End 5 columns container -->
		    </li><!-- End 5 columns Item -->
    	    <li><a href="#" class="drop">4 Columns</a><!-- Begin 4 columns Item -->
		        <div class="dropdown_4columns"><!-- Begin 4 columns container -->
		            <div class="col_4">
		                <h2>This is a heading title</h2>
		            </div>
		            <div class="col_1">
		                <h3>Some Links</h3>
		                <ul>
		                    <li><a href="#">ThemeForest</a></li>
		                    <li><a href="#">GraphicRiver</a></li>
		                    <li><a href="#">ActiveDen</a></li>
		                    <li><a href="#">VideoHive</a></li>
		                    <li><a href="#">3DOcean</a></li>
		                </ul>
		            </div>
		            <div class="col_1">
		                <h3>Useful Links</h3>
		                <ul>
		                    <li><a href="#">NetTuts</a></li>
		                    <li><a href="#">VectorTuts</a></li>
		                    <li><a href="#">PsdTuts</a></li>
		                    <li><a href="#">PhotoTuts</a></li>
		                    <li><a href="#">ActiveTuts</a></li>
		                </ul>
		            </div>

		            <div class="col_1">
		                <h3>Other Stuff</h3>
		                <ul>
		                    <li><a href="#">FreelanceSwitch</a></li>
		                    <li><a href="#">Creattica</a></li>
		                    <li><a href="#">WorkAwesome</a></li>
		                    <li><a href="#">Mac Apps</a></li>
		                    <li><a href="#">Web Apps</a></li>
		                </ul>

		            </div>

		            <div class="col_1">

		                <h3>Misc</h3>
		                <ul>
		                    <li><a href="#">Design</a></li>
		                    <li><a href="#">Logo</a></li>
		                    <li><a href="#">Flash</a></li>
		                    <li><a href="#">Illustration</a></li>
		                    <li><a href="#">More...</a></li>
		                </ul>

		            </div>

		        </div><!-- End 4 columns container -->

		    </li><!-- End 4 columns Item -->

			<li class="menu_right"><a href="#" class="drop">1 Column</a>

				<div class="dropdown_1column align_right">

		                <div class="col_1">

		                    <ul class="simple">
		                        <li><a href="#">FreelanceSwitch</a></li>
		                        <li><a href="#">Creattica</a></li>
		                        <li><a href="#">WorkAwesome</a></li>
		                        <li><a href="#">Mac Apps</a></li>
		                        <li><a href="#">Web Apps</a></li>
		                        <li><a href="#">NetTuts</a></li>
		                        <li><a href="#">VectorTuts</a></li>
		                        <li><a href="#">PsdTuts</a></li>
		                        <li><a href="#">PhotoTuts</a></li>
		                        <li><a href="#">ActiveTuts</a></li>
		                        <li><a href="#">Design</a></li>
		                        <li><a href="#">Logo</a></li>
		                        <li><a href="#">Flash</a></li>
		                        <li><a href="#">Illustration</a></li>
		                        <li><a href="#">More...</a></li>
		                    </ul>
		                </div>
				</div>
			</li>
		    <li class="menu_right"><a href="#" class="drop">3 columns</a><!-- Begin 3 columns Item -->
		        <div class="dropdown_3columns align_right"><!-- Begin 3 columns container -->

		            <div class="col_3">
		                <h2>Lists in Boxes</h2>
		            </div>

		            <div class="col_1">

		                <ul class="greybox">
		                    <li><a href="#">FreelanceSwitch</a></li>
		                    <li><a href="#">Creattica</a></li>
		                    <li><a href="#">WorkAwesome</a></li>
		                    <li><a href="#">Mac Apps</a></li>
		                    <li><a href="#">Web Apps</a></li>
		                </ul>

		            </div>

		            <div class="col_1">

		                <ul class="greybox">
		                    <li><a href="#">ThemeForest</a></li>
		                    <li><a href="#">GraphicRiver</a></li>
		                    <li><a href="#">ActiveDen</a></li>
		                    <li><a href="#">VideoHive</a></li>
		                    <li><a href="#">3DOcean</a></li>
		                </ul>

		            </div>

		            <div class="col_1">

		                <ul class="greybox">
		                    <li><a href="#">Design</a></li>
		                    <li><a href="#">Logo</a></li>
		                    <li><a href="#">Flash</a></li>
		                    <li><a href="#">Illustration</a></li>
		                    <li><a href="#">More...</a></li>
		                </ul>

		            </div>

		            <div class="col_3">
		                <h2>Here are some image examples</h2>
		            </div>

		            <div class="col_3">
		                <img src="https://lh3.googleusercontent.com/F2wrS38HmZz5hmKl7fWKbgx5xnVmwbCj-8cNbOd3JqnKj2y9kKVwK3N4ncaHr7R4VXrAtzmqwFbA5FM4q1hG6_ClLOoMuhCq=w293-h220" width="70" height="70" class="img_left imgshadow" alt="" />
		                <p>Maecenas eget eros lorem, nec pellentesque lacus. Aenean dui orci, rhoncus sit amet tristique eu, tristique sed odio. Praesent ut interdum elit. Maecenas imperdiet, nibh vitae rutrum vulputate, lorem sem condimentum.<a href="#">Read more...</a></p>
			                <img src="https://lh3.googleusercontent.com/yvBTsFA9q2Ahxv6QT24CWzYuisyk_G9zAmzDH3Tv5WPKbL9WCyYPgmafl-pnP2Ccz8iLmGHSdrD_FWKIdZFqxHhIo1fwMujG=w293-h220" width="70" height="70" class="img_left imgshadow" alt="" />
		                <p>Aliquam elementum felis quis felis consequat scelerisque. Fusce sed lectus at arcu mollis accumsan at nec nisi. Aliquam pretium mollis fringilla. Vestibulum tempor facilisis malesuada. <a href="#">Read more...</a></p>
		            </div>

		        </div><!-- End 3 columns container -->
		    </li><!-- End 3 columns Item -->
           </ul>
           <br><br><br><center><h1 contenteditable="false">A mega Menu Demo<br></h1>
           <br><br>
           <p style="color:bisque;font-size:20px;">the links are not coded here but can be trapped in [beforeNavigate2] method and redirected to vfp</p>
          </center>

		</body>
		</html>
	ENDTEXT

	Local m.lcdest
	m.lcdest=Addbs(Sys(2023))+"ytemp.html"
	Strtofile(m.myvar,m.lcdest)
	Thisform.olecontrol1.Navigate(m.lcdest)
	Endproc

	Procedure Destroy
	Clea Events
	Endproc

	Procedure Init
	Thisform.WindowState=2
	Thisform.ybuild()
	Endproc

	Procedure Load
	Set Safe Off
	Endproc

	Procedure olecontrol1.BeforeNavigate2
	*** Événement de contrôle ActiveX  ***
	Lparameters pdisp, url, Flags, targetframename, postdata, headers, Cancel
	Messagebox("url: "+url+Chr(13)+" Can redirect to vfp code in beforenavigate2 method.",0+32+4096,'',2000)
	Cancel=.T.
	Return .F.
	Endproc

	Procedure olecontrol1.Init
	This.silent=.T.
	Endproc

Enddefine
*
*-- EndDefine: ywebmenu
