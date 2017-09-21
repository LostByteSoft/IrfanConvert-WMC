@echo --- Start ---
@taskkill /f /im "IrfanConvert.exe"
if exist "C:\Program Files\IrfanView\i_view64.exe" goto skip
"iview442_x64_setup.exe" /silent /desktop=0 /thumbs=0 /group=0 /allusers=0 /assoc=0 /assocallusers
:skip
copy "IrfanConvert.exe" "C:\Program Files\IrfanView\"
copy "*.ico" "C:\Program Files\IrfanView\"
if exist "%appdata%\Microsoft\Windows\Start Menu\Programs\WMC\" goto skip2
md "%appdata%\Microsoft\Windows\Start Menu\Programs\WMC\"
:skip2
copy "Irfan Convert.lnk" "%appdata%\Microsoft\Windows\Start Menu\Programs\WMC\"
copy "Irfan Convert.lnk" "%appdata%\Microsoft\Windows\Start Menu\Programs\"
@echo --- Finish ---
"C:\Program Files\IrfanView\IrfanConvert.exe"
@pause
@exit