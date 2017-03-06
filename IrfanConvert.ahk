;;--- Head --- AHK
;; Need irfanview64 , convert image to folder.jpg for wmc.
;; Conversion tool, use with irfan x64 to auto-adjust an image to wor with WMC.
;; Irfan NOT creating jpg compatible with WMC.
;; Irfan 64 bit http://www.irfanview.com/
;; http://download.cnet.com/IrfanView-64-bit/3000-2192_4-76444710.html?part=dl-&subj=dl&tag=button

	SetEnv, title, IrFanConvert
	SetEnv, mode, Convert ????.jpg (an image) for WMC or FB
	SetEnv, version, Version 2017-03-06
	SetEnv, author, LostByteSoft

;;--- Softwares options

	#SingleInstance Force
	SetTitleMatchMode, 2
	SysGet, Mon1, Monitor, 1

;;--- Tray options

	Menu, tray, add, Refresh, doReload		; Reload the script.
	Menu, tray, add, --------, secret		; empty space
	Menu, tray, add, About, about			; Creates a new menu item.
	Menu, tray, add, Version, version		; About version

;;--- Software start here

	IfNotExist, C:\Program Files\IrfanView\i_view64.exe
		MsgBox, IrFanView64 is NOT installed... would'n work ! C:\Program Files\IrfanView\i_view64.exe must be exist !
	IfNotExist, C:\Windows\System32\mspaint.exe
		MsgBox, MsPaint is NOT installed... would'n work ! C:\Windows\System32\mspaint.exe must be exist !

	TrayTip, %title%, %mode%, 2, 1

Back:
	Menu, Tray, Icon, ico_convert.ico
	FileSelectFile, OutputVar,2 ,, Select an image to convert... (ESC to quit) IrFan Convert an image, (*.jpg; *.gif; *.jpeg; *.bmp; *.png)
		if ErrorLevel
		goto, GuiClose
	IfEqual, OutputVar, , Goto, back
	Test := OutputVar
	SplitPath, Test,, Dir
	SplitPath, Dir, Folder
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	;;msgbox, OutputVar=%OutputVar% : dir=%dir% : ext=%ext% : drive=%drive% : name_no_ext=%name_no_ext% : name=%name% folder=%folder%
	Gui:
	Gui, Add, Text, x50 y20 w425 h50 , Convert (Need Irfan64 && MsPaint) for "Movie" or "Music" Folder.jpg ? Music 400px Movie 800px.
	Gui, Add, Text, x50 y60 w425 h50 , Conversion tool auto-adjust an image to work with WMC (Music & Movie). What is this ? Music poster or Movie poster. Or compress picture for FaceBook.
	Gui, Add, Button, x25 y110 w100 h60 , Music
	Gui, Add, Button, x135 y110 w100 h60 , Movie
	Gui, Add, Button, x245 y110 w100 h60 , Facebook
	Gui, Add, Button, x355 y110 w100 h60 , GO_Back
	Height = -1							; "Keep aspect ratio" seems best.
	Gui, Add, Picture, x20 y200 w450 h%Height% , %OutputVar%
	Gui, Show, h900 w500, IrFanConvert Convert an image to folder.jpg WMC compatible.
	Return

ButtonGO_Back:
	Gui, Destroy
	goto, back

ButtonMusic:
	Menu, Tray, Icon, ico_wmc.ico
	TrayTip, IrFanConvert, Convert ????.jpg (an image) for WMC, 2, 1
	Gui, Destroy
	Run, "C:\Program Files\IrfanView\i_view64.exe" %OutputVar% /resize_long=400 /aspectratio /resample /convert=Folder.jpg /jpgq=100
	sleep, 500
	Run, "mspaint.exe" "%dir%\Folder.jpg" ;;,,min
	sleep, 500
	WinWaitActive, - Paint
	WinActivate, - Paint
	SetEnv, x, %Mon1Right%
	x /= 2
	x -=300
	WinMove, - Paint,, %x%, 50 , 600, 600
	sleep, 250
	Send {Ctrl Down}s{Ctrl Up}
	sleep, 250
	WinClose, - Paint
	;;msgbox, dir=%dir% : folder=%folder% : dir=\dir\folder=\%dir%\%folder%.jpg
	FileCopy, %dir%\Folder.jpg, %dir%\%folder%.jpg
	FileCopy, %dir%\Folder.jpg, %dir%\folder(Copy).jpg
	ExitApp

ButtonMovie:
	Menu, Tray, Icon, ico_wmc.ico
	TrayTip, IrFanConvert, Convert ????.jpg (an image) for WMC, 2, 1
	Gui, Destroy
	Run, "C:\Program Files\IrfanView\i_view64.exe" %OutputVar% /resize_long=800 /aspectratio /resample /convert=Folder.jpg /jpgq=100
	sleep, 500
	Run, "mspaint.exe" "%dir%\Folder.jpg" ;;,,min
	sleep, 500
	WinWaitActive, - Paint
	WinActivate, - Paint
	SetEnv, x, %Mon1Right%
	x /= 2
	x -=350
	WinMove, - Paint,, %x%, 0 , 700, 1010
	sleep, 250
	Send {Ctrl Down}s{Ctrl Up}
	sleep, 250
	WinClose, - Paint
	;;msgbox, dir=%dir% : folder=%folder% : dir=\dir\folder=\%dir%\%folder%.jpg
	FileCopy, %dir%\Folder.jpg, %dir%\%folder%.jpg
	FileCopy, %dir%\Folder.jpg, %dir%\folder(Copy).jpg
	ExitApp

ButtonFacebook:
	Menu, Tray, Icon, ico_fb.ico
	TrayTip, IrFanFacebook, Compress an image to put on FaceBook, 2, 1
	Gui2:
	Gui, Destroy
	Gui, Add, Text, x10 y20 w425 h50 , Compress an image to put on FaceBook. Reseize value (in px. 100 to 2000) --->
	Gui, Add, Text, x10 y50 w800 h50 , Image = %OutputVar%
	Gui, Add, Text, x10 y80 w800 h50 , Output = C:\Users\Public\Desktop\FB_%name_no_ext%.jpg
	Gui, Add, Edit, x400 y18 w50 h20 vEdit, 750
	Gui, Add, Button, x50 y125 w100 h60, &Convert
	Gui, Add, Button, x350 y125 w100 h60 , GO_Back
	Height = -1							; "Keep aspect ratio" seems best.
	Gui, Add, Picture, x20 y200 w450 h%Height%, %OutputVar%
	Gui, Show, h900 w500, h700 w500, IrFanFaceBook
	Return

ButtonConvert:
	GuiControlGet, Edit
	IfLess, Edit, 100, Goto, error_01
	IfGreater, Edit, 2000, Goto, error_01
	;;IfEqual, Edit,, Goto, error_01
	Gui, Destroy
	;;msgbox, Edit=%Edit%
	Run, "C:\Program Files\IrfanView\i_view64.exe" %OutputVar% /aspectratio /resample /resize_long=%Edit% /jpgq=90 /convert=C:\Users\Public\Desktop\FB_%name_no_ext%.jpg
	ExitApp

error_01:
	SetEnv, Edit, 750
	Gui, Destroy
	MsgBox, Px. Min. 100 Px. Max. 2000 and must by filled with a number. Default value 750.
	Goto, Gui2

;;--- Quit (escape , esc)

GuiClose:
	ExitApp

Escape::
	ExitApp

;;--- Tray Bar (must be at end of file)

about:
	TrayTip, %title%, %mode%, 2, 1
	Return

secret:
	MsgBox, title=%title% mode=%mode% author=%author% Edit=%Edit% dir=%dir% folder=%folder% version=%version% A_WorkingDir=%A_WorkingDir%
	Return

version:
	TrayTip, %title%, %version% by %author%, 2, 2
	Return

doReload:
	Reload
	Return

;;--- End of script ---

;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;                    Version 2, December 2004
 
; Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
 
; Everyone is permitted to copy and distribute verbatim or modified
; copies of this license document, and changing it is allowed as long
; as the name is changed.
 
;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 
;              You just DO WHAT THE FUCK YOU WANT TO.

;;--- End of file ---