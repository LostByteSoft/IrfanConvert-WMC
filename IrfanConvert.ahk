;;--- Head --- AHK ---

;;	Need irfanview64 , convert image to folder.jpg for wmc.
;;	Conversion tool, use with irfan x64 to auto-adjust an image to work with WMC.
;;	Irfan NOT creating jpg compatible with WMC.
;;	Irfan 64 bit http://www.irfanview.com/
;;	http://download.cnet.com/IrfanView-64-bit/3000-2192_4-76444710.html?part=dl-&subj=dl&tag=button
;;	Compatibility: Windows
;;	All files must be in same folder. Where you want.
;;	64 bit AHK version : 1.1.24.2 64 bit Unicode
;;	Use mspaint for compatibility jpg with WMC

;;--- Softwares Var ---

	SetWorkingDir, %A_ScriptDir%
	#SingleInstance Force
	#NoEnv
	SetTitleMatchMode, 2

	SetEnv, title, IrFanConvert WMC
	SetEnv, mode, Convert ????.jpg (an image) for WMC (Folder.jpg) or FB : ESC to quit !
	SetEnv, version, Version 2017-11-03-0814
	SetEnv, author, LostByteSoft
	SetEnv, logoicon, ico_convert.ico
	SetEnv, debug, 0

	SysGet, Mon1, MonitorWorkArea						; used to resize paint

	FileInstall, ico_convert.ico, ico_convert.ico, 0
	FileInstall, ico_about.ico, ico_about.ico, 0
	FileInstall, ico_fb.ico, ico_fb.ico, 0
	FileInstall, ico_wmc.ico, ico_wmc.ico, 0
	FileInstall, ico_lock.ico, ico_lock.ico, 0
	FileInstall, ico_reboot.ico, ico_reboot.ico, 0
	FileInstall, ico_shut.ico, ico_shut.ico, 0
	FileInstall, ico_reboot.ico, ico_reboot.ico, 0
	FileInstall, ico_options.ico, ico_options.ico, 0
	FileInstall, ico_debug.ico, ico_debug.ico, 0
	;FileInstall, ico_pause.ico, ico_pause.ico, 0

;;--- Tray options ---

	Menu, Tray, NoStandard
	Menu, tray, add, ---=== %title% ===---, about
	Menu, Tray, Icon, ---=== %title% ===---, %logoicon%
	Menu, tray, add, Show logo, GuiLogo
	Menu, tray, add, Secret MsgBox, secret					; Secret MsgBox, just show all options and variables of the program
	Menu, Tray, Icon, Secret MsgBox, ico_lock.ico
	Menu, tray, add, About && ReadMe, author
	Menu, Tray, Icon, About && ReadMe, ico_about.ico
	Menu, tray, add, Author %author%, about
	menu, tray, disable, Author %author%
	Menu, tray, add, %version%, about
	menu, tray, disable, %version%
	Menu, tray, add,
	Menu, tray, add, --== Control ==--, about
	Menu, Tray, Icon, --== Control ==--, ico_options.ico
	Menu, tray, add, Exit %title%, Close					; Close exit program
	Menu, Tray, Icon, Exit %title%, ico_shut.ico
	Menu, tray, add, Refresh (ini mod), doReload 				; Reload the script.
	Menu, Tray, Icon, Refresh (ini mod), ico_reboot.ico
	Menu, tray, add, Set Debug (Toggle), debug
	Menu, Tray, Icon, Set Debug (Toggle), ico_debug.ico
	;Menu, tray, add, Pause (Toggle), pause					; pause is useless on not continious/persistant software
	;Menu, Tray, Icon, Pause (Toggle), ico_pause.ico
	Menu, tray, add,
	Menu, Tray, Tip, %title%

;;--- Software start here ---

	TrayTip, %title%, %mode%, 2, 1

start:
	IfNotExist, C:\Program Files\IrfanView\i_view64.exe
		MsgBox, IrFanView64 is NOT installed... would'n work ! C:\Program Files\IrfanView\i_view64.exe must be exist !
	IfNotExist, C:\Windows\System32\mspaint.exe
		MsgBox, MsPaint is NOT installed... would'n work ! C:\Windows\System32\mspaint.exe must be exist !

Back:
	Menu, Tray, Icon, %logoicon%
	IniRead, reimage, i_view64.ini, Resize, reimage
	IfEqual, reimage, 1, SetEnv, checked, checked
	IfEqual, reimage, 0, SetEnv, checked,
	FileSelectFile, OutputVar,2 ,, Select an image to convert... (ESC to quit) IrFan Convert an image, (*.jpg; *.gif; *.jpeg; *.bmp; *.png)
		if ErrorLevel
			goto, Close
	DebugStart:
	IfEqual, OutputVar, , Goto, back
	Test := OutputVar
	SplitPath, Test,, Dir
	SplitPath, Dir, Folder
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1, msgbox, BACK : OutputVar=%OutputVar% : dir=%dir% : ext=%ext% : drive=%drive% : name_no_ext=%name_no_ext% : name=%name% : (if in) Folder=%folder%
	Gui:
	Gui, Destroy
	Gui, Add, Text, x50 y20 w425 h50 , Convert (Need Irfan64 && MsPaint) for "Movie" or "Music" Folder.jpg ? Music 500px Movie 1000px.
	Gui, Add, Text, x50 y60 w425 h50 , Conversion tool auto-adjust an image to work with WMC (Music & Movie). What is this ? Music poster or Movie poster. Or compress picture for FaceBook.
	Gui, Add, Checkbox, x100 y90 w300 h20 vReImage %checked%, Checkbox On/Off - ReImage for multiples conversions.
	Gui, Add, Button, x25 y110 w100 h60 , Music
	Gui, Add, Button, x135 y110 w100 h60 , Movie
	Gui, Add, Button, x245 y110 w100 h60 , Facebook
	Gui, Add, Button, x355 y110 w100 h60 , GO_Back
	Gui, Add, Picture, x20 y200 w450 h-1 , %OutputVar%
	Gui, Show, w500, IrFanConvert Convert an image to folder.jpg WMC compatible.
	Return

ButtonGO_Back:
	GuiControlGet, ReImage,, Reimage
	IfEqual, reimage, 1, IniWrite, 1, i_view64.ini, Resize, ReImage
	IfEqual, reimage, 0, IniWrite, 0, i_view64.ini, Resize, ReImage
	IfEqual, reimage, 1, SetEnv, checked, checked
	IfEqual, reimage, 0, SetEnv, checked,
	Gui, Destroy
	goto, back

ButtonMusic:
	Menu, Tray, Icon, ico_wmc.ico
	IfEqual, Debug, 1, msgbox, dir=%dir% : folder=%folder% : dir=\dir\folder=\%dir%\%folder%.jpg
	GuiControlGet, ReImage,, Reimage
	IfEqual, reimage, 1, IniWrite, 1, i_view64.ini, Resize, ReImage
	IfEqual, reimage, 0, IniWrite, 0, i_view64.ini, Resize, ReImage
	IfEqual, reimage, 1, SetEnv, checked, checked
	IfEqual, reimage, 0, SetEnv, checked,
	IfEqual, Debug, 0, TrayTip, IrFanConvert, Convert ????.jpg (an image) for WMC, 2, 1
	Gui, Destroy
	;;ifExist, %dir%\Folder(Copy).jpg, MsgBox, File already exist %dir%\Folder(Copy).jpg. This software do not delete a file. It can be try to overwrite and maybe not work.
	;;ifExist, %dir%\Folder.jpg, MsgBox, File already exist %dir%\Folder.jpg. This software do not delete a file. It can be try to overwrite and maybe not work.
	Sleep, 250
	Hotkey, LButton, nothing, On					; block mouse input
	IfEqual, Debug, 1, Goto, skipmusic
	Hotkey, MButton, nothing, On
	Hotkey, RButton, nothing, On
	Hotkey, XButton1, nothing, On
	Hotkey, XButton2, nothing, On
	Hotkey, WheelUp, nothing, On
	Hotkey, WheelDown, nothing, On
	skipmusic:
	Run, "C:\Program Files\IrfanView\i_view64.exe" %OutputVar% /resize_long=500 /aspectratio /resample /convert=Folder(Copy).jpg /jpgq=100	;; jpg
	MusicCopy:
	sleep, 500
		IfEqual, Debug, 1, msgbox, waitfile : "%dir%\Folder(Copy).jpg"
		if FileExist("%dir%\Folder(Copy).jpg"), goto, nextmusic
		goto, MusicCopy
	nextmusic:
	Run, "mspaint.exe" "%dir%\Folder(Copy).jpg"
	sleep, 500
	SetEnv, x, %Mon1Right%
	x /= 2
	x -=350
	WinWaitActive, - Paint
	WinActivate, - Paint
	WinMove, - Paint,, %x%, 150 , 700, 700
	sleep, 250
	Send {Ctrl Down}s{Ctrl Up}
	sleep, 250
	WinClose, - Paint
	FileCopy, %dir%\Folder(Copy).jpg, %dir%\Folder.jpg
	Hotkey, LButton, nothing, Off
	Hotkey, MButton, nothing, Off
	Hotkey, RButton, nothing, Off
	Hotkey, XButton1, nothing, Off
	Hotkey, XButton2, nothing, Off
	Hotkey, WheelUp, nothing, Off
	Hotkey, WheelDown, nothing, Off
	IfEqual, ReImage, 1, goto, ButtonGO_Back
	Goto, Close

	nothing:
	return

ButtonMovie:
	Menu, Tray, Icon, ico_wmc.ico
	IfEqual, Debug, 1, msgbox, ButtonMovie : dir=%dir% : (if in) folder=%folder% : dir=\dir\folder dir=\%dir%\%folder%.jpg
	GuiControlGet, ReImage,, Reimage
	IfEqual, reimage, 1, IniWrite, 1, i_view64.ini, Resize, ReImage
	IfEqual, reimage, 0, IniWrite, 0, i_view64.ini, Resize, ReImage
	IfEqual, reimage, 1, SetEnv, checked, checked
	IfEqual, reimage, 0, SetEnv, checked,
	IfEqual, Debug, 0, TrayTip, IrFanConvert, Convert ????.jpg (an image) for WMC, 2, 1
	Gui, Destroy
	;;ifExist, %dir%\Folder(Copy).jpg, MsgBox, File already exist %dir%\Folder(Copy).jpg. This software do not delete a file. It can be try to overwrite and maybe not work.
	;;ifExist, %dir%\Folder.jpg, MsgBox, File already exist %dir%\Folder.jpg. This software do not delete a file. It can be try to overwrite and maybe not work.
	;;ifExist, %dir%\%name_no_ext1%.jpg, MsgBox, File already exist %dir%\%name_no_ext1%.jpg. This software do not delete a file. It can be try to overwrite and maybe not work.
	Sleep, 250
	IfEqual, Debug, 1, Goto, skipmovie
	Hotkey, LButton, nothing, On					; block mouse input
	Hotkey, MButton, nothing, On
	Hotkey, RButton, nothing, On
	Hotkey, XButton1, nothing, On
	Hotkey, XButton2, nothing, On
	Hotkey, WheelUp, nothing, On
	Hotkey, WheelDown, nothing, On
	SkipMovie:
	Run, "C:\Program Files\IrfanView\i_view64.exe" %OutputVar% /resize_long=1000 /aspectratio /resample /convert=Folder(Copy).jpg /jpgq=100 ;; jpg
	MovieCopy:
	sleep, 500
		IfEqual, Debug, 1, msgbox, waitfile : "%dir%\Folder(Copy).jpg"
		if FileExist("%dir%\Folder(Copy).jpg"), goto, nextmovie
		goto, MovieCopy
	nextmovie:
	Run, "mspaint.exe" "%dir%\Folder(Copy).jpg"
	sleep, 500
	SetEnv, x, %Mon1Right%
	x /= 2
	x -=500
	WinWaitActive, - Paint
	WinActivate, - Paint
	WinMove, - Paint,, %x%, 0 , 1000, %Mon1Bottom%
	sleep, 250
	Send {Ctrl Down}s{Ctrl Up}
	sleep, 250
	WinClose, - Paint
	FileCopy, %dir%\Folder(Copy).jpg, %dir%\Folder.jpg
	;Loop, %dir%\*.mkv, 0 							;; if a video file is find it create a image with the same name. Useful for videoclips in Video folder.
	;Video := A_LoopFileName
	;SplitPath, Video, name1, dir1, ext1, name_no_ext1, drive1
	;Ifequal, debug, 1, msgbox, VideoName : video=%video% : dir1=%dir1% : ext1=%ext1% : drive1=%drive1% : name_no_ext1=%name_no_ext1% : name1=%name1% folder1=%folder1%
	;FileCopy, %dir%\Folder(copy).jpg, %dir%\%name_no_ext1%.jpg 		;; if a video file is find it create a image with the same name.
	Hotkey, LButton, nothing, Off
	Hotkey, MButton, nothing, Off
	Hotkey, RButton, nothing, Off
	Hotkey, XButton1, nothing, Off
	Hotkey, XButton2, nothing, Off
	Hotkey, WheelUp, nothing, Off
	Hotkey, WheelDown, nothing, Off
	IfEqual, ReImage, 1, goto, ButtonGO_Back
	Goto, Close

ButtonFacebook:
	GuiControlGet, ReImage,, Reimage
	IfEqual, reimage, 1, IniWrite, 1, i_view64.ini, Resize, ReImage
	IfEqual, reimage, 0, IniWrite, 0, i_view64.ini, Resize, ReImage
	IfEqual, reimage, 1, SetEnv, checked, checked
	IfEqual, reimage, 0, SetEnv, checked,
	Menu, Tray, Icon, ico_fb.ico
	TrayTip, IrFanFacebook, Compress an image to put on FaceBook, 2, 1
	Gui2:
	Gui, Destroy
	Gui, Add, Text, x10 y20 w425 h50 , Compress an image to put on FaceBook. Reseize value (in px. 100 to 2000) Def. 600 --->
	Gui, Add, Text, x10 y50 w800 h50 , Image =`n%OutputVar%
	Gui, Add, Text, x10 y80 w800 h50 , Output =`nC:\Users\%A_UserName%\Desktop\FB_%name_no_ext%.jpg
	Gui, Add, Edit, x435 y18 w50 h20 vEdit, 600
	Gui, Add, Button, x50 y125 w100 h60, &Convert
	Gui, Add, Button, x350 y125 w100 h60 , GO_Back_fb
	Gui, Add, Picture, x20 y200 w450 h-1, %OutputVar%		;; -1 "Keep aspect ratio" seems best.
	Gui, Show, w500, IrFanFaceBook
	Return

ButtonConvert:
	GuiControlGet, Edit
	IfLess, Edit, 100, Goto, error_01
	IfGreater, Edit, 2000, Goto, error_01
	IfEqual, Edit,, Goto, error_01
	Gui, Destroy
	Sleep, 250
	BlockInput, on
	Run, "C:\Program Files\IrfanView\i_view64.exe" %OutputVar% /aspectratio /resample /resize_long=%Edit% /jpgq=100 /convert=C:\Users\%A_UserName%\Desktop\FB_%name_no_ext%.jpg
	BlockInput, Off
	IfEqual, ReImage, 1, goto, ButtonGO_Back
	Goto, Close

ButtonGO_Back_fb:
	Gui, Destroy
	goto, gui

error_01:
	Gui, Destroy
	SetEnv, Edit, 750
	MsgBox, Px. Min. 100 Px. Max. 2000 and must by filled with a number. Default value 750.
	Goto, Gui2

;;--- Debug Pause ---

debug:
	IfEqual, debug, 0, goto, debug1
	IfEqual, debug, 1, goto, debug0

	debug0:
	SetEnv, debug, 0
	Goto, Start

	debug1:
	SetEnv, debug, 1
	TrayTip, %title%, DEBUG mode., 2, 1
	Goto, DebugStart

pause:
	Ifequal, pause, 0, goto, paused
	Ifequal, pause, 1, goto, unpaused

	paused:
	Menu, Tray, Icon, ico_pause.ico
	SetEnv, pause, 1
	goto, sleep

	unpaused:	
	SetEnv, pause, 0
	Goto, start

	sleep:
	sleep, 24000
	goto, sleep

;;--- Quit (escape , esc) ---

Close:
	TrayTip, %title%, WMC convert close...., 2, 1
	Sleep, 750
	ExitApp

Escape::
	ExitApp

doReload:
	Reload
	Return

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

author:
	MsgBox, 64, %title%, %title% %mode% %version% %author%. This software is usefull to modify an poster movie for WMC recognise & reseize it.`n`n`tGo to https://github.com/LostByteSoft
	Return

GuiLogo:
	Gui, Destroy
	Gui, Add, Picture, x25 y25 w400 h400 , %logoicon%
	Gui, Show, w450 h450, %title% Logo
	Gui, Color, 000000
	Sleep, 500
	;MsgBox, WinWaitClose %title% Logo
	WinWaitClose, %title% Logo
	Goto, gui

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
;      LostByteSoft no copyright or copyleft, we are CopyMiddle.
;
;	If you are unhappy with this software i do not care.
;
;;--- End of file ---