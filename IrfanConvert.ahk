;;--- Head --- AHK ---

;;	Need irfanview64 , convert image to folder.jpg for wmc.
;;	Conversion tool, use with irfan x64 to auto-adjust an image to work with WMC.
;;	Irfan NOT creating jpg compatible with WMC.
;;	Irfan 64 bit http://www.irfanview.com/
;;	http://download.cnet.com/IrfanView-64-bit/3000-2192_4-76444710.html?part=dl-&subj=dl&tag=button
;;	Compatibility: Windows
;;	All files must be in same folder. Where you want.
;;	64 bit AHK version : 1.1.24.2 64 bit Unicode

;;--- Softwares Var ---

	SetEnv, title, IrFanConvert
	SetEnv, mode, Convert ????.jpg (an image) for WMC or FB
	SetEnv, version, Version 2017-03-14
	SetEnv, author, LostByteSoft

;;--- Softwares options ---

	SetWorkingDir, %A_ScriptDir%
	#SingleInstance Force
	SetTitleMatchMode, 2
	SysGet, Mon1, Monitor, 1
	FileInstall, ico_convert.ico, ico_convert.ico, 0
	FileInstall, ico_fb.ico, ico_fb.ico, 0
	FileInstall, ico_wmc.ico, ico_wmc.ico, 0
	IniRead, reimage, i_view64.ini, Resize, reimage

;;--- Tray options ---

	Menu, Tray, NoStandard
	Menu, tray, add, Exit %title%, GuiClose		; GuiClose exit program
	Menu, tray, add, Refresh, doReload		; Reload the script.
	Menu, tray, add,
	Menu, tray, add, Secret MsgBox, secret
	Menu, Tray, Icon, Secret MsgBox, ico_convert.ico
	Menu, tray, add,
	Menu, tray, add, About %author%, about		; Creates a new menu item.
	Menu, Tray, Icon, About %author%, ico_fb.ico
	Menu, tray, add, %Version%, version		; About version
	Menu, Tray, Icon, %Version%, ico_wmc.ico

;;--- Software start here ---

	IfNotExist, C:\Program Files\IrfanView\i_view64.exe
		MsgBox, IrFanView64 is NOT installed... would'n work ! C:\Program Files\IrfanView\i_view64.exe must be exist !
	IfNotExist, C:\Windows\System32\mspaint.exe
		MsgBox, MsPaint is NOT installed... would'n work ! C:\Windows\System32\mspaint.exe must be exist !
	TrayTip, %title%, %mode%, 2, 1

Back:
	IniRead, reimage, i_view64.ini, Resize, reimage
	IfEqual, reimage, 1, SetEnv, checked, checked
	IfEqual, reimage, 0, SetEnv, checked,
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
	Gui, Add, Checkbox, x100 y90 w300 h20 vReImage %checked%, Checkbox On/Off - ReImage for multiples conversions.
	Gui, Add, Button, x25 y110 w100 h60 , Music
	Gui, Add, Button, x135 y110 w100 h60 , Movie
	Gui, Add, Button, x245 y110 w100 h60 , Facebook
	Gui, Add, Button, x355 y110 w100 h60 , GO_Back
	Height = -1							; "Keep aspect ratio" seems best.
	Gui, Add, Picture, x20 y200 w450 h%Height% , %OutputVar%
	Gui, Show, h900 w500, IrFanConvert Convert an image to folder.jpg WMC compatible.
	Return

ButtonGO_Back:
	GuiControlGet, ReImage,, Reimage
	IfEqual, 1, %reimage%, IniWrite, 1, i_view64.ini, Resize, ReImage
	IfEqual, 0, %reimage%, IniWrite, 0, i_view64.ini, Resize, ReImage
	IfEqual, reimage, 1, SetEnv, checked, checked
	IfEqual, reimage, 0, SetEnv, checked,
	Gui, Destroy
	goto, back

ButtonMusic:
	Menu, Tray, Icon, ico_wmc.ico
	GuiControlGet, ReImage,, Reimage
	IfEqual, 1, %reimage%, IniWrite, 1, i_view64.ini, Resize, ReImage
	IfEqual, 0, %reimage%, IniWrite, 0, i_view64.ini, Resize, ReImage
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
	IfEqual, ReImage, 1, goto, ButtonGO_Back
	ExitApp

ButtonMovie:
	Menu, Tray, Icon, ico_wmc.ico
	GuiControlGet, ReImage,, Reimage
	IfEqual, 1, %reimage%, IniWrite, 1, i_view64.ini, Resize, ReImage
	IfEqual, 0, %reimage%, IniWrite, 0, i_view64.ini, Resize, ReImage
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
	IfEqual, ReImage, 1, goto, ButtonGO_Back
	ExitApp

ButtonFacebook:
	GuiControlGet, ReImage,, Reimage
	IfEqual, reimage, 1, SetEnv, checked, checked
	IfEqual, reimage, 0, SetEnv, checked,
	IfEqual, 1, %reimage%, IniWrite, 1, i_view64.ini, Resize, ReImage
	IfEqual, 0, %reimage%, IniWrite, 0, i_view64.ini, Resize, ReImage
	Menu, Tray, Icon, ico_fb.ico
	TrayTip, IrFanFacebook, Compress an image to put on FaceBook, 2, 1
	Gui2:
	Gui, Destroy
	Gui, Add, Text, x10 y20 w425 h50 , Compress an image to put on FaceBook. Reseize value (in px. 100 to 2000) --->
	Gui, Add, Text, x10 y50 w800 h50 , Image = %OutputVar%
	Gui, Add, Text, x10 y80 w800 h50 , Output = C:\Users\Public\Desktop\FB_%name_no_ext%.jpg
	Gui, Add, Edit, x400 y18 w50 h20 vEdit, 750
	Gui, Add, Button, x50 y125 w100 h60, &Convert
	Gui, Add, Button, x350 y125 w100 h60 , GO_Back_fb
	Height = -1							; "Keep aspect ratio" seems best.
	Gui, Add, Picture, x20 y200 w450 h%Height%, %OutputVar%
	Gui, Show, h900 w500, h700 w500, IrFanFaceBook
	Return

ButtonConvert:
	GuiControlGet, Edit
	IfLess, Edit, 100, Goto, error_01
	IfGreater, Edit, 2000, Goto, error_01
	IfEqual, Edit,, Goto, error_01
	Gui, Destroy
	Run, "C:\Program Files\IrfanView\i_view64.exe" %OutputVar% /aspectratio /resample /resize_long=%Edit% /jpgq=90 /convert=C:\Users\Public\Desktop\FB_%name_no_ext%.jpg
	ExitApp

ButtonGO_Back_fb:
	IniRead, reimage, i_view64.ini, Resize, reimage
	IfEqual, reimage, 1, SetEnv, checked, checked
	IfEqual, reimage, 0, SetEnv, checked,
	Gui, Destroy
	goto, back

error_01:
	Gui, Destroy
	SetEnv, Edit, 750
	MsgBox, Px. Min. 100 Px. Max. 2000 and must by filled with a number. Default value 750.
	Goto, Gui2

;;--- Quit (escape , esc)

GuiClose:
	ExitApp

Escape::
	ExitApp

;;--- Tray Bar (must be at end of file)

about:
	TrayTip, %title%, %mode% by %author%, 2, 1
	Return

secret:
	MsgBox, title=%title% mode=%mode% author=%author% Edit=%Edit% dir=%dir% folder=%folder% version=%version% A_WorkingDir=%A_WorkingDir% RetrunAfterWork=%reimage%
	Return

version:
	TrayTip, %title%, %version% by %author%, 2, 2
	Return

doReload:
	Reload
	Return

;;--- End of script ---
;
;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;   Version 3.14159265358979323846264338327950288419716939937510582
;                          March 2017
;
; Everyone is permitted to copy and distribute verbatim or modified
; copies of this license document, and changing it is allowed as long
; as the name is changed.
;
;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
;
;              You just DO WHAT THE FUCK YOU WANT TO.
;
;		     NO FUCKING WARRANTY AT ALL
;
;      The warranty is included in your anus. Look carefully you
;             might miss all theses small characters.
;
;	As is customary and in compliance with current global and
;	interplanetary regulations, the author of these pages disclaims
;	all liability for the consequences of the advice given here,
;	in particular in the event of partial or total destruction of
;	the material, Loss of rights to the manufacturer's warranty,
;	electrocution, drowning, divorce, civil war, the effects of
;	radiation due to atomic fission, unexpected tax recalls or
;	    encounters with extraterrestrial beings 'elsewhere.
;
;              LostByteSoft no copyright or copyleft.
;
;	If you are unhappy with this software i do not care.
;
;;--- End of file ---