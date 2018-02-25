@echo --- Start ---
@taskkill /f /im "IrfanConvert.exe"
if exist "C:\Program Files\IrfanView\i_view64.exe" goto skip
"iview450_x64_setup.exe" /silent /desktop=0 /thumbs=0 /group=0 /allusers=0 /assoc=0 /assocallusers
:skip
copy "IrfanConvert.exe" "C:\Program Files\IrfanView\"
copy "IrfanConvert.ini" "C:\Program Files\IrfanView\"
copy "Irfan Convert WMC.lnk" "%appdata%\Microsoft\Windows\Start Menu\Programs\"
copy "Irfan Convert WMC.lnk" "%appdata%\Microsoft\Windows\Start Menu\Programs\WMC\"
@echo --- Finish ---
@Echo You can clost this windows !
"C:\Program Files\IrfanView\IrfanConvert.exe"
@exit