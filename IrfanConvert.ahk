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
	SetEnv, version, Version 2017-11-23-1446
	SetEnv, author, LostByteSoft
	SetEnv, icofolder, C:\Program Files\Common Files
	SetEnv, logoicon, ico_convert.ico

	SysGet, Mon1, MonitorWorkArea						; used to resize paint

	;; specific files

	FileInstall, IrfanConvert.ini, IrfanConvert.ini, 0
	FileInstall, ico_convert.ico, %icofolder%\ico_convert.ico, 0
	FileInstall, ico_fb.ico, %icofolder%\ico_fb.ico, 0
	FileInstall, ico_wmc.ico, %icofolder%\ico_wmc.ico, 0

	;; Common ico

	FileInstall, ico_about.ico, %icofolder%\ico_about.ico, 0
	FileInstall, ico_lock.ico, %icofolder%\ico_lock.ico, 0
	FileInstall, ico_shut.ico, %icofolder%\ico_shut.ico, 0
	FileInstall, ico_options.ico, %icofolder%\ico_options.ico, 0
	FileInstall, ico_reboot.ico, %icofolder%\ico_reboot.ico, 0
	FileInstall, ico_shut.ico, %icofolder%\ico_shut.ico, 0

	IniRead, reimage, IrfanConvert.ini, Options, reimage
	;;IniRead, rename, IrfanConvert.ini, Options, rename
	IniRead, refilename, IrfanConvert.ini, Options, refilename
	IniRead, debug, IrfanConvert.ini, Options, debug

;;--- Tray options ---

	Menu, Tray, NoStandard
	Menu, tray, add, ---=== %title% ===---, about
	Menu, Tray, Icon, ---=== %title% ===---, %icofolder%\%logoicon%
	Menu, tray, add, Show logo, GuiLogo
	Menu, tray, add, Secret MsgBox, secret					; Secret MsgBox, just show all options and variables of the program
	Menu, Tray, Icon, Secret MsgBox, %icofolder%\ico_lock.ico
	Menu, tray, add, About && ReadMe, author
	Menu, Tray, Icon, About && ReadMe, %icofolder%\ico_about.ico
	Menu, tray, add, Author %author%, about
	menu, tray, disable, Author %author%
	Menu, tray, add, %version%, about
	menu, tray, disable, %version%
	Menu, tray, add,
	Menu, tray, add, --== Control ==--, about
	Menu, Tray, Icon, --== Control ==--, %icofolder%\ico_options.ico
	Menu, tray, add, Exit %title%, Close					; Close exit program
	Menu, Tray, Icon, Exit %title%, %icofolder%\ico_shut.ico
	Menu, tray, add, Refresh (ini mod), doReload 				; Reload the script.
	Menu, Tray, Icon, Refresh (ini mod), %icofolder%\ico_reboot.ico
	Menu, tray, add, Set Debug (Toggle), debug
	Menu, Tray, Icon, Set Debug (Toggle), %icofolder%\ico_debug.ico
	Menu, tray, add, Pause (Toggle), pause					; pause is useless on not continious/persistant software
	Menu, Tray, Icon, Pause (Toggle), %icofolder%\ico_pause.ico
	Menu, Tray, Disable, Pause (Toggle)
	menu, tray, add, --== Options ==--, about
	Menu, Tray, Icon, --== Options ==--, %icofolder%\ico_options.ico
	Menu, tray, add, Open IrfanConvert.ini, openini
	Menu, Tray, Icon, Open IrfanConvert.ini, %icofolder%\ico_options.ico
	Menu, tray, add,
	Menu, tray, add, Select image, Start
	Menu, Tray, Tip, %title%

;;--- Software start here ---

	;;IfEqual, debug, 0, TrayTip, %title%, %mode%, 2, 1
	IfEqual, debug, 1, TrayTip, %title%, DEBUG mode., 2, 1

start:
	IfNotExist, C:\Program Files\IrfanView\i_view64.exe
		MsgBox, IrFanView64 is NOT installed... would'n work ! C:\Program Files\IrfanView\i_view64.exe must be exist !
	IfNotExist, C:\Windows\System32\mspaint.exe
		MsgBox, MsPaint is NOT installed... would'n work ! C:\Windows\System32\mspaint.exe must be exist !

Back:
	Menu, Tray, Icon, %icofolder%\ico_convert.ico
	FileSelectFile, OutputVar,2 ,, Select an image to convert... (ESC to quit) IrFan Convert an image, (*.jpg; *.gif; *.jpeg; *.bmp; *.png)
		if ErrorLevel
			goto, Close
	DebugStart:
	IfEqual, OutputVar, , Goto, back
	Test := OutputVar
	SplitPath, Test,, Dir
	SplitPath, Dir, Folder
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1, msgbox, BACK :`n`nOutputVar=%OutputVar%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	Goto, skipguides1
	Gui:
	Gui, Destroy
	skipguides1:
	Menu, Tray, Icon, %icofolder%\ico_convert.ico
	IniRead, reimage, IrfanConvert.ini, Options, reimage
	IniRead, rename, IrfanConvert.ini, Options, rename
	IniRead, refilename, IrfanConvert.ini, Options, refilename
	IfEqual, reimage, 1, SetEnv, checked, checked
	IfEqual, reimage, 0, SetEnv, checked,
	;;IfEqual, Rename, 1, SetEnv, checked1, checked
	;;IfEqual, Rename, 0, SetEnv, checked1,
	IfEqual, Refilename, 1, SetEnv, checked2, checked
	IfEqual, Refilename, 0, SetEnv, checked2,
	Gui, Add, Text, x25 y20 w425 h50 , Convert (Need Irfan64 && MsPaint) for "Movie" or "Music" Folder.jpg
	Gui, Add, Text, x25 y40 w425 h50 , Conversion tool auto-adjust an image to work with WMC (Music & Movie). What is this ? Music poster or Movie poster. Music 500px Movie 1000px Or compress picture 600px for FaceBook.
	Gui, Add, Checkbox, x50 y80 w400 h20 vReImage %checked%, Reimage On/Off - For multiples conversions. Music && movies && Facebook.
	;;Gui, Add, Checkbox, x50 y100 w450 h20 vReName %checked1%, Rename On/Off - Original file to name of the folder (If in folder). Music && Movies.
	Gui, Add, Checkbox, x50 y120 w400 h20 vReFilename %checked2%, Filename On/Off - Create an jpg with the same name as video. Movies only.
	Gui, Add, Button, x25 y160 w100 h60 , Music
	Gui, Add, Button, x135 y160 w100 h60 , Movie
	Gui, Add, Button, x245 y160 w100 h60 , Facebook
	Gui, Add, Button, x355 y160 w100 h60 , GO_Back
	IfEqual, debug, 1, Gui, Add, Button, x360 y10 w100 h20, DEBUG MODE
	Gui, Add, Picture, x20 y250 w450 h-1 , %OutputVar%
	Gui, Show, w500, IrFanConvert Convert an image to folder.jpg WMC compatible.
	Return

ButtonGO_Back:
	GuiControlGet, ReImage,, Reimage
	;;GuiControlGet, Rename,, Rename
	GuiControlGet, ReFilename,, ReFilename
	IfEqual, reimage, 1, IniWrite, 1, IrfanConvert.ini, Options, ReImage
	IfEqual, reimage, 0, IniWrite, 0, IrfanConvert.ini, Options, ReImage
	;;IfEqual, rename, 1, IniWrite, 1, IrfanConvert.ini, Options, Rename
	;;IfEqual, rename, 0, IniWrite, 0, IrfanConvert.ini, Options, Rename
	IfEqual, refilename, 1, IniWrite, 1, IrfanConvert.ini, Options, Refilename
	IfEqual, refilename, 0, IniWrite, 0, IrfanConvert.ini, Options, Refilename
	IfEqual, reimage, 1, SetEnv, checked, checked
	IfEqual, reimage, 0, SetEnv, checked,
	;;IfEqual, Rename, 1, SetEnv, checked1, checked
	;;IfEqual, Rename, 0, SetEnv, checked1,
	IfEqual, Refilename, 1, SetEnv, checked2, checked
	IfEqual, Refilename, 0, SetEnv, checked2,
	Gui, Destroy
	goto, back

ButtonMusic:
	Menu, Tray, Icon, %icofolder%\ico_wmc.ico
	GuiControlGet, ReImage,, Reimage
	;;GuiControlGet, Rename,, Rename
	GuiControlGet, ReFilename,, ReFilename
	IfEqual, reimage, 1, IniWrite, 1, IrfanConvert.ini, Options, ReImage
	IfEqual, reimage, 0, IniWrite, 0, IrfanConvert.ini, Options, ReImage
	;;IfEqual, rename, 1, IniWrite, 1, IrfanConvert.ini, Options, Rename
	;;IfEqual, rename, 0, IniWrite, 0, IrfanConvert.ini, Options, Rename
	IfEqual, refilename, 1, IniWrite, 1, IrfanConvert.ini, Options, Refilename
	IfEqual, refilename, 0, IniWrite, 0, IrfanConvert.ini, Options, Refilename
	IfEqual, reimage, 1, SetEnv, checked, checked
	IfEqual, reimage, 0, SetEnv, checked,
	;;IfEqual, Rename, 1, SetEnv, checked1, checked
	;;IfEqual, Rename, 0, SetEnv, checked1,
	IfEqual, Refilename, 1, SetEnv, checked2, checked
	IfEqual, Refilename, 0, SetEnv, checked2,
	IfEqual, Debug, 0, TrayTip, IrFanConvert, Convert ????.jpg (an image) for WMC, 2, 1
	Gui, Destroy
	Sleep, 250
	IfEqual, Debug, 1, msgbox, ButtonMusic : Reimage=%Reimage% rename=%rename% ReFilename=%ReFilename%`n`ndir=%dir%`n`nfolder=%folder%`n`ndir=\dir\folder=\%dir%\%folder%.jpg
	Hotkey, LButton, nothing, On					; block mouse input
	IfEqual, Debug, 1, Goto, skipmusic
	Hotkey, MButton, nothing, On
	Hotkey, RButton, nothing, On
	Hotkey, XButton1, nothing, On
	Hotkey, XButton2, nothing, On
	Hotkey, WheelUp, nothing, On
	Hotkey, WheelDown, nothing, On
	skipmusic:
	Run, "C:\Program Files\IrfanView\i_view64.exe" %OutputVar% /resize_long=500 /aspectratio /resample /convert=Folder (Copy).jpg /jpgq=100	;; jpg

	MusicCopy:			;; wait for the file exist
		sleep, 500
		IfEqual, Debug, 1, msgbox, WAITFILE : "%dir%\Folder (Copy).jpg"
		if FileExist("%dir%\Folder (Copy).jpg"), goto, nextmusic
		goto, MusicCopy

	nextmusic:
	Run, "mspaint.exe" "%dir%\Folder (Copy).jpg"
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
	sleep, 250
	FileCopy, %dir%\Folder (Copy).jpg, %dir%\Folder.jpg, 1

	IfEqual, folder,, Goto, skipfoldermusic
	;;IfEqual, rename, 1, FileCopy, %dir%\%name%, %dir%\%folder%.jpg, 1

	skipfoldermusic:
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
	Menu, Tray, Icon, %icofolder%\ico_wmc.ico
	GuiControlGet, ReImage,, Reimage
	;;GuiControlGet, Rename,, Rename
	GuiControlGet, ReFilename,, ReFilename
	IfEqual, reimage, 1, IniWrite, 1, IrfanConvert.ini, Options, ReImage
	IfEqual, reimage, 0, IniWrite, 0, IrfanConvert.ini, Options, ReImage
	;;IfEqual, rename, 1, IniWrite, 1, IrfanConvert.ini, Options, Rename
	;;IfEqual, rename, 0, IniWrite, 0, IrfanConvert.ini, Options, Rename
	IfEqual, refilename, 1, IniWrite, 1, IrfanConvert.ini, Options, Refilename
	IfEqual, refilename, 0, IniWrite, 0, IrfanConvert.ini, Options, Refilename
	IfEqual, reimage, 1, SetEnv, checked, checked
	IfEqual, reimage, 0, SetEnv, checked,
	;;IfEqual, Rename, 1, SetEnv, checked1, checked
	;;IfEqual, Rename, 0, SetEnv, checked1,
	IfEqual, Refilename, 1, SetEnv, checked2, checked
	IfEqual, Refilename, 0, SetEnv, checked2,
	IfEqual, Debug, 0, TrayTip, IrFanConvert, Convert ????.jpg (an image) for WMC, 2, 1
	Loop, %dir%\*.mkv
	Gui, Destroy
	Sleep, 250
	IfEqual, Debug, 1, msgbox, BUTTONMOVIE :`n`nReimage=%Reimage% rename=%rename% ReFilename=%ReFilename%`n`ndir=%dir%`n`nIf in folder=%folder%`n`nComplete dir=%dir%\%folder%.jpg`n`nA_LoopFileName (only mkv) =%A_LoopFileName%
	IfEqual, Debug, 1, Goto, skipmovie
	Hotkey, LButton, nothing, On						;; block mouse input
	Hotkey, MButton, nothing, On
	Hotkey, RButton, nothing, On
	Hotkey, XButton1, nothing, On
	Hotkey, XButton2, nothing, On
	Hotkey, WheelUp, nothing, On
	Hotkey, WheelDown, nothing, On
	SkipMovie:
	Run, "C:\Program Files\IrfanView\i_view64.exe" %OutputVar% /resize_long=1000 /aspectratio /resample /convert=Folder (Copy).jpg /jpgq=100 ;; jpg

	MovieCopy:
		sleep, 500
		IfEqual, Debug, 1, msgbox, WAITFILE : "%dir%\Folder (Copy).jpg"
		if FileExist("%dir%\Folder (Copy).jpg"), goto, nextmovie
		goto, MovieCopy

	nextmovie:
	Run, "mspaint.exe" "%dir%\Folder (Copy).jpg"
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
	sleep, 250
	FileCopy, %dir%\Folder (Copy).jpg, %dir%\Folder.jpg, 1

	IfEqual, folder,, Goto, skipfoldermovie
	IfEqual, debug, 1 , MsgBox, FOLDERMOVIE :`n`n%dir%\%name%`n`n%dir%\%folder%.jpg
	;;IfEqual, rename, 1, FileCopy, %dir%\%name%, %dir%\"%folder%".jpg, 1

	skipfoldermovie:
	IfEqual, Refilename, 0, Goto, skiprefilename
	Loop, %dir%\*.mkv
	SplitPath, A_LoopFileName , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	IfEqual, OutNameNoExt,, Goto, skiprefilename
	FileCopy, %dir%\Folder (Copy).jpg, %dir%\%OutNameNoExt%.jpg, 1		;; Used in video folder of WMC, when an image with the same name of the file show the poster

	Loop, %dir%\*.mp4
	SplitPath, A_LoopFileName , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	IfEqual, OutNameNoExt,, Goto, skiprefilename
	FileCopy, %dir%\Folder (Copy).jpg, %dir%\%OutNameNoExt%.jpg, 1		;; Used in video folder of WMC, when an image with the same name of the file show the poster

	Loop, %dir%\*.avi
	SplitPath, A_LoopFileName , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	IfEqual, OutNameNoExt,, Goto, skiprefilename
	FileCopy, %dir%\Folder (Copy).jpg, %dir%\%OutNameNoExt%.jpg, 1		;; Used in video folder of WMC, when an image with the same name of the file show the poster

	skiprefilename:
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
	Menu, Tray, Icon, %icofolder%\ico_fb.ico
	GuiControlGet, ReImage,, Reimage
	;;GuiControlGet, Rename,, Rename
	GuiControlGet, ReFilename,, ReFilename
	IfEqual, reimage, 1, IniWrite, 1, IrfanConvert.ini, Options, ReImage
	IfEqual, reimage, 0, IniWrite, 0, IrfanConvert.ini, Options, ReImage
	;;IfEqual, rename, 1, IniWrite, 1, IrfanConvert.ini, Options, Rename
	;;IfEqual, rename, 0, IniWrite, 0, IrfanConvert.ini, Options, Rename
	IfEqual, refilename, 1, IniWrite, 1, IrfanConvert.ini, Options, Refilename
	IfEqual, refilename, 0, IniWrite, 0, IrfanConvert.ini, Options, Refilename
	IfEqual, reimage, 1, SetEnv, checked, checked
	IfEqual, reimage, 0, SetEnv, checked,
	;;IfEqual, Rename, 1, SetEnv, checked, checked
	;;IfEqual, Rename, 0, SetEnv, checked,
	IfEqual, Refilename, 1, SetEnv, checked, checked
	IfEqual, Refilename, 0, SetEnv, checked,
	TrayTip, IrFanFacebook, Compress an image to put on FaceBook, 2, 1
	Gui, destroy
	Gui2:
	Menu, Tray, Icon, %icofolder%\ico_fb.ico
	Gui, Destroy
	IfEqual, debug, 1, Gui, Add, Button, x350 y45 w100 h20, DEBUG MODE
	Gui, Add, Text, x10 y20 w425 h50 , Compress an image to put on FaceBook. Reseize value (in px. 100 to 2000) Def. 600 --->
	Gui, Add, Text, x10 y50 w800 h50 , Image =`n%OutputVar%
	IfEqual, folder,, goto, skipfbfolder
	Gui, Add, Text, x10 y80 w800 h50 , Output Folder =`nC:\Users\%A_UserName%\Desktop\FB_%folder%.jpg
	SkipFbfolder:
	Gui, Add, Text, x10 y110 w800 h50 , Output Name =`nC:\Users\%A_UserName%\Desktop\FB_%name_no_ext%.jpg
	Gui, Add, Edit, x435 y18 w50 h20 vEdit, 600
	IfEqual, folder,, goto, skipfbfolder2
	Gui, Add, Button, x50 y150 w100 h60, &ConvertFolder
	SkipFbfolder2:
	Gui, Add, Button, x175 y150 w100 h60, &ConvertName
	Gui, Add, Button, x350 y150 w100 h60 , GO_Back_fb
	Gui, Add, Picture, x20 y225 w450 h-1, %OutputVar%			;; -1 "Keep aspect ratio" seems best.
	Gui, Show, w500, IrFanFaceBook
	Return

ButtonConvertFolder:
	GuiControlGet, Edit
	IfLess, Edit, 100, Goto, error_01
	IfGreater, Edit, 2000, Goto, error_01
	IfEqual, Edit,, Goto, error_01
	Gui, Destroy
	Sleep, 250
	Run, "C:\Program Files\IrfanView\i_view64.exe" %OutputVar% /aspectratio /resample /resize_long=%Edit% /jpgq=100 /convert=C:\Users\%A_UserName%\Desktop\FB_%folder%.jpg
	BlockInput, Off
	IfEqual, ReImage, 1, goto, ButtonGO_Back
	Goto, Close

ButtonConvertName:
	GuiControlGet, Edit
	IfLess, Edit, 100, Goto, error_01
	IfGreater, Edit, 2000, Goto, error_01
	IfEqual, Edit,, Goto, error_01
	Gui, Destroy
	Sleep, 250
	Run, "C:\Program Files\IrfanView\i_view64.exe" %OutputVar% /aspectratio /resample /resize_long=%Edit% /jpgq=100 /convert=C:\Users\%A_UserName%\Desktop\FB_%name_no_ext%.jpg
	BlockInput, Off
	IfEqual, ReImage, 1, goto, ButtonGO_Back
	Goto, Close

ButtonGO_Back_fb:
	Gui, Destroy
	goto, gui

error_01:
	Gui, Destroy
	SetEnv, Edit, 600
	MsgBox, Px. Min. 100 Px. Max. 2000 and must by filled with a number. Default value 600.
	Goto, Gui2

;;--- Debug Pause ---

debug:
	IfEqual, debug, 0, goto, debug1
	IfEqual, debug, 1, goto, debug0

	debug0:
	IniWrite, 0, IrfanConvert.ini, Options, debug
	SetEnv, debug, 0
	Goto, Start

	debug1:
	IniWrite, 1, IrfanConvert.ini, Options, debug
	SetEnv, debug, 1
	TrayTip, %title%, DEBUG mode., 2, 1
	Goto, DebugStart

pause:
	Ifequal, pause, 0, goto, paused
	Ifequal, pause, 1, goto, unpaused

	paused:
	Menu, Tray, Icon, %icofolder%\ico_pause.ico
	SetEnv, pause, 1
	goto, sleep

	unpaused:	
	SetEnv, pause, 0
	Goto, start

	sleep:
	sleep, 24000
	goto, sleep

;;--- Quit (escape , esc) ---

GuiClose:
Close:
	GuiControlGet, ReImage,, Reimage
	;;GuiControlGet, Rename,, Rename
	GuiControlGet, ReFilename,, ReFilename
	IfEqual, reimage, 1, IniWrite, 1, IrfanConvert.ini, Options, ReImage
	IfEqual, reimage, 0, IniWrite, 0, IrfanConvert.ini, Options, ReImage
	;;IfEqual, rename, 1, IniWrite, 1, IrfanConvert.ini, Options, Rename
	;;IfEqual, rename, 0, IniWrite, 0, IrfanConvert.ini, Options, Rename
	IfEqual, refilename, 1, IniWrite, 1, IrfanConvert.ini, Options, Refilename
	IfEqual, refilename, 0, IniWrite, 0, IrfanConvert.ini, Options, Refilename
	Gui, destroy
	TrayTip, %title%, WMC convert close...., 2, 1
	ExitApp

Escape::
	ExitApp

doReload:
	Reload
	Return

;;--- Tray Bar (must be at end of file)


openini:
	run, notepad.exe "IrfanConvert.ini"
	Sleep, 1000
	Return

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
	Gui, 4:Add, Picture, x25 y25 w400 h400, %icofolder%\%logoicon%
	Gui, 4:Show, w450 h450, %title% Logo
	;;Gui, 4:Color, 000000
	Sleep, 500
	Return

	4GuiClose:
	Gui 4:Cancel
	return

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