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

	SetEnv, title, IrFanFacebook
	SetEnv, mode, Compress an image to put on FaceBook
	SetEnv, version, Version 2017-03-14
	SetEnv, author, LostByteSoft

;;--- Softwares options ---

	SetWorkingDir, %A_ScriptDir%
	#SingleInstance Force
	SetTitleMatchMode, 2
	SysGet, Mon1, Monitor, 1

;;--- Tray options ---

	Menu, Tray, NoStandard
	Menu, tray, add, Exit %title%, GuiClose		; GuiClose exit program
	Menu, tray, add, Refresh, doReload		; Reload the script.
	Menu, tray, add,
	Menu, tray, add, About %author%, about		; Creates a new menu item.
	Menu, Tray, Icon, About %author%, ico_fb.ico
	Menu, tray, add, %Version%, version		; About version

;;--- Software start here ---

start:
	IfNotExist, C:\Program Files\IrfanView\i_view64.exe
		MsgBox, IrFanView64 is NOT installed... would'n work ! C:\Program Files\IrfanView\i_view64.exe must be exist !
	IfNotExist, C:\Windows\System32\mspaint.exe
		MsgBox, MsPaint is NOT installed... would'n work ! C:\Windows\System32\mspaint.exe must be exist !

	TrayTip, %title%, %mode%, 2, 1

Back:
	FileSelectFile, OutputVar,2 ,, Select an image to convert... (ESC to quit) %mode%, (*.jpg; *.gif; *.jpeg; *.bmp; *.png)
		if ErrorLevel
			goto, GuiClose
	IfEqual, OutputVar, , Goto, back

	Test := OutputVar
	SplitPath, Test,, Dir
	SplitPath, Dir, Folder
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	;;msgbox, OutputVar=%OutputVar% : dir=%dir% : ext=%ext% : drive=%drive% : name_no_ext=%name_no_ext% : name=%name% folder=%folder%
Gui:
	Gui, Add, Text, x10 y20 w425 h50 , Compress an image to put on FaceBook. Reseize value (in px. 100 to 2000) --->
	Gui, Add, Text, x10 y50 w800 h50 , Image = %OutputVar%
	Gui, Add, Text, x10 y80 w800 h50 , Output = C:\Users\Public\Desktop\FB_%name_no_ext%.jpg
	Gui, Add, Edit, x400 y18 w50 h20 vEdit, 750
	Gui, Add, Button, x50 y125 w100 h60, &Convert
	Gui, Add, Button, x350 y125 w100 h60 , GO_Back
	Height = -1							; "Keep aspect ratio" seems best.
	Gui, Add, Picture, x20 y200 w450 h%Height%, %OutputVar%
	Gui, Show, x400 y200 h700 w500, IrFanFaceBook
	Return

ButtonGO_Back:
	Gui, Destroy
	goto, back

ButtonConvert:
	GuiControlGet, Edit
	IfLess, Edit, 100, Goto, error_01
	IfGreater, Edit, 2000, Goto, error_01
	IfEqual, Edit,, Goto, error_01
	Gui, Destroy
	;;msgbox, Edit=%Edit%
	Run, "C:\Program Files\IrfanView\i_view64.exe" %OutputVar% /aspectratio /resample /resize_long=%Edit% /jpgq=90 /convert=C:\Users\Public\Desktop\FB_%name_no_ext%.jpg
	ExitApp

error_01:
	Gui, Destroy
	SetEnv, Edit, 750
	MsgBox, Px. Min. 750 Px. Max. 2000 and must by filled with a number.
	Goto, Gui

;;--- Quit (escape , esc) ---

GuiClose:
	ExitApp

Escape::
	ExitApp

;;--- Tray Bar (must be at end of file) ---

about:
	TrayTip, %title%, %mode% by %author%, 2, 1
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