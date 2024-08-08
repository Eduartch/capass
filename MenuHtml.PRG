ubli yform
yform=Newobject("ymenu_class")
yform.Show
Read Events
Return
*
Define Class ymenu_class As Form
    Height = 600
    Width = 874
    ShowWindow = 2
    DoCreate = .T.
    AutoCenter = .T.
    Caption = "Web CSS accordions Applied to vfp"
    KeyPreview = .T.
    BackColor = Rgb(0,0,0)
    yurl = .F.
    ycolorstyle = ""
    Name = "Form1"

    Add Object olecontrol1 As OleControl With ;
        Oleclass="shell.explorer.2", ;
        Top = 0, ;
        Left = 0, ;
        Height = 559, ;
        Width = 620, ;
        Name = "Olecontrol1"

    Add Object olecontrol2 As OleControl With ;
        Oleclass="MSComCtl2.MonthView.2",;
        Top = 48, ;
        Left = 348, ;
        Height = 216, ;
        Width = 215, ;
        Visible = .F., ;
        Name = "Olecontrol2"

    Add Object olecontrol3 As OleControl With ;
        oleclass="MSComCtl2.DTPicker.2",;
        Top = 84, ;
        Left = 570, ;
        Height = 73, ;
        Width = 229, ;
        Visible = .F., ;
        Name = "Olecontrol3"

    Add Object olecontrol4 As OleControl With ;
        oleclass="shell.explorer.2",;
        Top = 252, ;
        Left = 324, ;
        Height = 289, ;
        Width = 409, ;
        Visible = .F., ;
        Anchor = 15, ;
        Name = "Olecontrol4"

    Procedure yactions
        #Define yerror "An error was ccured"
        If !Thisform.yurl==[yvfp:/29]  &&Exit
            Try
                For i=1 To Thisform.ControlCount
                    If !( Lower(Thisform.Controls(i).Name)=="olecontrol1" Or Lower(Thisform.Controls(i).Name)=="olecontrol2" Or Lower(Thisform.Controls(i).Name)=="olecontrol3" Or Lower(Thisform.Controls(i).Name)=="olecontrol4")
                        Thisform.RemoveObject(Thisform.Controls(i).Name)
                        DoEvent
                    Endi
                Endfor
            Catch
            Endtry
            With Thisform
                .olecontrol2.Visible=.F.   &&iif(.olecontrol2.visible=.t.,.t.,.f.)
                .olecontrol3.Visible=.F.   &&iif(.olecontrol3.visible=.t.,.t.,.f.)
                .olecontrol4.Visible=.F.   &&iif(.olecontrol4.visible=.t.,.t.,.f.)
            Endwith
        Endi
        Thisform.Refresh


        Do Case

            Case Thisform.yurl==[yvfp:/1]
                Select * From (Home(1)+"samples\data\customer.dbf") Into Cursor ycurs
                Thisform.AddObject("grid1","grid")
                With Thisform.grid1
                    .RecordSource="ycurs"
                    .Left=Thisform.olecontrol1.Left+Thisform.olecontrol1.Width+5
                    .Top=10
                    .Width=630
                    .Height=400
                    .Themes=.F.
                    .Anchor=15
                    .GridLines=0
                    .DeleteMark=.F.
                    .HeaderHeight=22
                    .SetAll("DynamicBackColor", "IIF(MOD(RECNO( ), 2)=0, RGB(255,255,255), RGB(216,252,218))", "Column")
                    .SetAll("fontsize",12,"header")
                    For i=1 To .ColumnCount
                        .Columns(i).header1.BackColor=Rgb(255*Rand(),255*Rand(),255*Rand())
                    Endfor
                    .Visible=.T.
                    .Refresh
                    Locate
                Endwith

            Case Thisform.yurl==[yvfp:/2]
                Thisform.AddObject("edit1" ,'editbox')
                With Thisform.edit1
                    .Top=10
                    .Left=Thisform.olecontrol1.Left+Thisform.olecontrol1.Width+5
                    .Width=670
                    .Height=350
                    .ForeColor=Rgb(0,255,0)
                    .BackColor=Rgb(10,100,95)
                    .FontSize=11
                    .Alignment=0
                    .Anchor=15
                    TEXT to .value noshow
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vel risus eget lorem feugiat
        fermentum nec a turpis. Phasellus purus sem, mollis ac posuere eget, ornare vel orci. Sed ac rutrum
        nulla. Aenean ultrices eget lectus eu efficitur. In hac habitasse platea dictumst. Nulla in iaculis nisi.
        Nullam et pulvinar tellus. Donec arcu dui, efficitur a odio non, porta congue dolor. Aenean viverra
        auctor sagittis. Integer lobortis dignissim auctor. Proin et volutpat massa.
        Cras vitae felis venenatis, egestas sem quis, sodales neque. Donec venenatis hendrerit odio, non
        pellentesque metus scelerisque ac. Suspendisse aliquet rhoncus odio id viverra. Vestibulum feugiat
        lectus a nisl pulvinar, in tempor metus eleifend. Nunc id odio quam. Praesent egestas lorem ut
        sollicitudin consectetur. Vestibulum id bibendum est. Ut vel lacus sapien. Quisque eget molestie
        sem. Integer eget purus eu orci molestie aliquam quis in ante. Integer a magna eget lectus finibus
        porttitor. Donec fringilla sapien a quam aliquet, pellentesque blandit nisl placerat. Nam hendrerit
        velit vel ex aliquam, eget convallis ante mollis.
                    ENDTEXT
                    .Visible=.T.
                Endwith

            Case Thisform.yurl==[yvfp:/3]
                Thisform.AddObject("image1" ,'image')
                With Thisform.image1
                    .Picture=Getpict()
                    If Empty(.Picture)
                        Return .F.
                    Endi
                    .Stretch=2
                    .Left=Thisform.olecontrol1.Width+1
                    .Top=10
                    .Width=Thisform.Width-Thisform.olecontrol1.Width-20
                    .Height=Thisform.Height-20
                    .Anchor=15
                    .Visible=.T.
                Endwith

            Case Thisform.yurl==[yvfp:/4]
                Thisform.olecontrol2.Visible=.T.

            Case Thisform.yurl==[yvfp:/5]
                Thisform.olecontrol3.Visible=.T.
                Thisform.olecontrol3.SetFocus
                Local oshell
                oshell=Newobject("wscript.shell")
                oshell.sendkeys("%{DOWN}")

            Case Thisform.yurl==[yvfp:/6]
                With Thisform.olecontrol4
                    Try
                        .Navigate("www.foxite.com")
                        .Visible=.T.
                    Catch
                    Endtry
                Endwith

            Case Thisform.yurl==[yvfp:/7]
                With Thisform.olecontrol4
                    Try
                        .Navigate("http://yousfi.over-blog.com/")
                        .Visible=.T.
                    Catch
                    Endtry
                Endwith

            Case Thisform.yurl==[yvfp:/8]
                With Thisform.olecontrol4
                    Try
                        .Navigate("www.google.com")
                        .Visible=.T.
                    Catch
                    Endtry
                Endwith

            Case Thisform.yurl==[yvfp:/9]
                Run /N explorer

            Case Thisform.yurl==[yvfp:/10]
                Run /N mspaint


            Case Thisform.yurl==[yvfp:/11]

                If  ! ShellExecute(0, "open", "firefox.exe","","",1)>32
                    Messagebox(yerror,16+4096,1000)
                Endi

            Case Thisform.yurl==[yvfp:/12]
                If !ShellExecute(0, "open", "acroRd32.exe","","",1)>32
                    Messagebox(yerror,16+4096,1000)
                Endi

            Case Thisform.yurl==[yvfp:/13]
                Try
                    Run/N snippingtool
                Catch
                    Messagebox(yerror,16+4096,1000)
                Endtry


            Case Thisform.yurl==[yvfp:/28]
                TEXT to m.myvar textmerge noshow
        the web is full off new objects and can found accordions with beautiful
        designs and in very short code..
        these can be embed as html file on the classic vfp olecontrol  if compatible.
        this one  uses javascript/jQuerry/css and is compatible with the vfp browser and
        can be coupled usefully with vfp objects.
        the browser have the method "beforenavigate" to intercept the url linked,cancel
        its running action  and instead can run any vfp object with classic commands....
        can arrange menu items names and number as your convenience.
        these web objects can be menus,web treeview,menu images,accordions,videos,web pages ...
        the same method can be applied to.
        original web accordion  code is from :http://www.vandelaydesign.com/vertical-accordion/

        Yousfi Benameur  El Bayadh Algeria.
        Foxite 21 October 2014

                ENDTEXT
                Try
                    Set Bell To (Addbs(Getenv('windir')))+"MEDIA\notification.WAV"
                    ?? Chr(7)
                Catch
                Endtry
                Messagebox(m.myvar,0+32+4096,"Help")

                Try
                    Set Bell To (Addbs(Getenv('windir')))+"MEDIA\Windows Notify Email.WAV"
                    ?? Chr(7)
                Catch
                Endtry


            Case Thisform.yurl==[yvfp:/33]
                With Thisform
                    Do Case
                        Case  .TitleBar=1
                            .TitleBar=0
                            .Height=.Height+Sysmetric(9)+Sysmetric(4)
                        Case  .TitleBar=0
                            .TitleBar=1
                            .Height=.Height-Sysmetric(9)-Sysmetric(4)
                    Endcase
                Endwith

            Case Thisform.yurl==[yvfp:/34]
                Local m.xcolor
                m.xcolor=Getcolor()
                If m.xcolor=-1
                    Return  .F.
                Endi
                Thisform.ycolorstyle=m.xcolor

                Local m.ycolor
                If Empty(Thisform.ycolorstyle) Or Thisform.ycolorstyle=-1
                    Thisform.ycolorstyle=Rgb(0,230,0)
                Endi
                m.ycolor=Thisform.yhtmlcolor(Thisform.ycolorstyle)
                Thisform.yinit(m.ycolor)

            Case Thisform.yurl==[yvfp:/341]
                Local m.myvar
                TEXT to m.myvar noshow
 This is a demo how you can embed a web menu (made only with css, no javascript or other adds) on a vfp browser  and use it usefully as real menu, beautifying your application
This is a vertical accordion with bars and menu items (add as you want, change as you want).
 the navigation,instead to be oriented towards the web is trapped to redirect on the disc and used    with normal vfp commands.
 this menu can be customized and the buttons can be added or removed-the menu items  can added   or removed.
        The style of buttons (colors) can be changed at runtime.
        the title bar can cut/retored.
        the fullscreen is possible with maximize+cut titlebar

        Author Yousfi Benameur  El Bayadh Algeria
                    Tuesday 10 februrary 2015
                ENDTEXT
                Messagebox(m.myvar,"summary help",0+32+4096)


            Case Thisform.yurl==[yvfp:/35]
                Thisform.Release

            Otherwise

                Thisform.AddObject("command1" ,'commandbutton')
                With Thisform.command1
                    .Picture=Home()+"graphics\bitmaps\assorted\beany.bmp"
                    .PicturePosition=7
                    .SpecialEffect=0
                    .Width=320
                    .Height=200
                    .Caption="add some codes and some actions with "+Thisform.yurl +" in form.yactions method!"
                    .WordWrap=.T.
                    .FontSize=20
                    .ForeColor=Rgb(255*Rand(),255*Rand(),255*Rand())
                    .FontBold=.T.
                    .MousePointer=15
                    Local gnUpper,gnLower
                    gnUpper=Thisform.Width-Thisform.olecontrol1.Width
                    gnLower=Thisform.olecontrol1.Width+1
                    .Left=Int((gnUpper - gnLower + 1) * Rand( ) + gnLower)
                    gnUpper=Thisform.Height-.Height
                    gnLower=1
                    .Top=Int((gnUpper - gnLower + 1) * Rand( ) + gnLower)
                    .AutoSize=.T.
                    .Visible=.T.
                    .SetFocus
                    .Click()
                Endwith

        Endcase
    Endproc

    Procedure yhtmlcolor
        *convert RGB colot to HTML color
        Lparameters xcol
        If xcol=-1
            Return .F.
        Endi

        xhtml_color=Chrtran("123456","563412",Right(Trans(m.xcol  ,"@0"),6))
        Return "#"+xhtml_color
    Endproc

    Procedure yinit
        Lparameters ycolor

        Local m.myvar
        TEXT to m.myvar textmerge noshow
        <style>
        #menu-accordeon {
          padding:0;
          margin:0;
          list-style:none;
          text-align: center;
          width: 180px;
        }
        #menu-accordeon ul {
          padding:0;
          margin:0;
          list-style:none;
          text-align: center;
        }
        #menu-accordeon li {
           background-color:#729EBF;
           background-image:-webkit-linear-gradient(top, <<m.ycolor>> 0%, #333A40 100%);
           background-image: linear-gradient(to bottom,<<m.ycolor>> 0%, #333A40 100%);
           border-radius: 6px;
           margin-bottom:2px;
           box-shadow: 3px 3px 3px #999;
           border:solid 1px #333A40
        }
        #menu-accordeon li li {
           max-height:0;
           overflow: hidden;
           transition: all .5s;
           border-radius:0;
           background: #444;
           box-shadow: none;
           border:none;
           margin:0
        }
        #menu-accordeon a {
          display:block;
          text-decoration: none;
          color: #fff;
          padding: 8px 0;
          font-family: verdana;
          font-size:1em
        }
        #menu-accordeon ul li a, #menu-accordeon li:hover li a {
          font-size:0.8em
        }
        #menu-accordeon li:hover {
           background: #729EBF
        }
        #menu-accordeon li li:hover {
           background: #999;
        }
        #menu-accordeon ul li:last-child {
           border-radius: 0 0 6px 6px;
           border:none;
        }
        #menu-accordeon li:hover li {
          max-height: 15em;
        }
        </style>

        <body bgcolor=gold oncontextmenu="return false;" scroll="no" >

        <ul id="menu-accordeon">
           <li><a href="#">Run applications</a>
              <ul>
                 <li><a href="yvfp:/1">Run a grid sample</a></li>
                 <li><a href="yvfp:/2">Editbox</a></li>
                 <li><a href="yvfp:/3">get an image</a></li>
                 <li><a href="yvfp:/4">Calendar Olecontrol</a></li>
              </ul>
           </li>
            <li><a href="#">web links</a>
              <ul>
                 <li><a href="yvfp:/5">Datepicker olecontrol</a></li>
                 <li><a href="yvfp:/6">Foxite</a></li>
                 <li><a href="yvfp:/7">My Blog</a></li>
                 <li><a href="yvfp:/8">Google</a></li>
              </ul>
           </li>
           <li><a href="#">Common Applications</a>
              <ul>
                 <li><a href="yvfp:/9">Run explorer</a></li>
                 <li><a href="yvfp:/10">Run mspaint</a></li>
                 <li><a href="yvfp:/11">Run firefox</a></li>
                 <li><a href="yvfp:/12">Run acrobat</a></li>
              </ul>
           </li>
           <li><a href="#">Your bar menu here</a>
              <ul>
                 <li><a href="yvfp:/13">SnippingTool</a></li>
                 <li><a href="yvfp:/14">Lien sous menu 3</a></li>
                 <li><a href="yvfp:/15">Lien sous menu 3</a></li>
                 <li><a href="yvfp:/16">Lien sous menu 3</a></li>
              </ul>
           </li>

           <li><a href="#">Searches</a>
              <ul>
                 <li><a href="yvfp:/17">Lien sous menu 3</a></li>
                 <li><a href="yvfp:/18">Lien sous menu 3</a></li>
                 <li><a href="yvfp:/19">Lien sous menu 3</a></li>
                 <li><a href="yvfp:/20">Lien sous menu 3</a></li>
              </ul>
           </li>
           <li><a href="#">Classes</a>
              <ul>
                 <li><a href="yvfp:/21">Lien sous menu 4</a></li>
                 <li><a href="yvfp:/22">Lien sous menu 4</a></li>
                 <li><a href="yvfp:/23">Lien sous menu 4</a></li>
                 <li><a href="yvfp:/24">Lien sous menu 4</a></li>
              </ul>
           </li>
           <li><a href="#">prgs and forms</a>
              <ul>
                 <li><a href="yvfp:/25">Lien sous menu 5</a></li>
                 <li><a href="yvfp:/26">Lien sous menu 5</a></li>
                 <li><a href="yvfp:/27">Lien sous menu 5</a></li>
                 <li><a href="yvfp:/28">Lien sous menu 5</a></li>
              </ul>
           </li>
           <li><a href="#">Reports</a>
              <ul>
                 <li><a href="yvfp:/25">Lien sous menu 6</a></li>
                 <li><a href="yvfp:/26">Lien sous menu 6</a></li>
                 <li><a href="yvfp:/27">Lien sous menu 6</a></li>
                 <li><a href="yvfp:/28">Lien sous menu 6</a></li>
              </ul>
           </li>
           <li><a href="#">Misc</a>
              <ul>
                 <li><a href="yvfp:/29">lien sous menu 7</a></li>
                 <li><a href="yvfp:/30">Lien sous menu 7</a></li>
                 <li><a href="yvfp:/31">Lien sous menu 7</a></li>
                 <li><a href="yvfp:/32">Lien sous menu 7</a></li>
              </ul>
           </li>

           <li><a href="#">Others</a>
              <ul>
                 <li><a href="yvfp:/33">Form Titlebar on/off</a></li>
                 <li><a href="yvfp:/34">Change menu style</a></li>
                 <li><a href="yvfp:/341">Summary help</a></li>
              </ul>
           </li>

            <li><a href="#">Exiting...</a>
              <ul>
                 <li><a href="yvfp:/35">Close form</a></li>
              </ul>
           </li>


        </ul>
        </body>
        ENDTEXT
        Strtofile(m.myvar,m.yrep+"yindex1.html")

        Thisform.olecontrol1.Navigate(m.yrep+"yindex1.html")
    Endproc


    Procedure Load
        Declare Integer Sleep In kernel32 Integer

        Declare Integer ShellExecute In SHELL32.Dll Integer nWinHandle,;
            STRING cOperation,;
            STRING cFileName,;
            STRING cParameters,;
            STRING cDirectory,;
            INTEGER nShowWindow
    Endproc

    Procedure KeyPress
        Lparameters nKeyCode, nShiftAltCtrl
        If nKeyCode=27
            Thisform.Release
        Endi
        If nKeyCode=96
            Thisform.olecontrol1.Visible=.T.
        Endi
    Endproc


    Procedure Resize
        With This.olecontrol1
            .Left=-5
            .Height=.Parent.Height-1
            .Top=0
            .Width=200
        Endwith
    Endproc

    Procedure Init
        Close Data All
        Set Safe Off

        Publi  m.yrep
        m.yrep=Addbs(Justpath(Sys(16,1)))

        With Thisform.olecontrol2
            .monthbackcolor=65280
            .titlebackcolor=65535
            .titleforecolor=255
        Endwith

        With Thisform.olecontrol3
            .calendarBackColor=16711680
        Endwith

        Local m.ycolor
        If Empty(Thisform.ycolorstyle) Or Thisform.ycolorstyle=-1
            Thisform.ycolorstyle=Rgb(0,230,0)
        Endi
        m.ycolor=Thisform.yhtmlcolor(Thisform.ycolorstyle)
        Thisform.yinit(m.ycolor)
    Endproc


    Procedure Destroy
        Clea Events
    Endproc

    Procedure olecontrol1.BeforeNavigate2
        *** Événement de contrôle ActiveX  ***
        Lparameters pdisp, url, Flags, targetframename, postdata, headers, Cancel
        Nodefault
        Thisform.yurl=url

        If Lower(Substr(url,1,4))="yvfp"
            Thisform.yactions()
            Cancel=.T. &&this prevent the browser to do the default action .
            Return .F.
        Endi
    Endproc

    Procedure olecontrol1.Init
        With This
            .Left=-5
            .Height=.Parent.Height-1
            .Top=0    &&-55
            .Width=200
        Endwith
    Endproc

    Procedure olecontrol3.Init
        With This.Font
            .Size=12
            .bold=.T.
        Endwith
    Endproc

    Procedure olecontrol4.Init
        With This
            .Left=Thisform.olecontrol1.Width+1
            .Top=0
            .Width=Thisform.Width-Thisform.olecontrol1.Width-2
            .Height=Thisform.olecontrol1.Height
        Endwith
    Endproc

Enddefine