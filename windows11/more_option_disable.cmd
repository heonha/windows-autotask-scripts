@echo off
chcp 1252

echo Bring back left-click Windows 10 right-click menu!
echo .
echo .
echo processing... If it takes too long time, close and get administrator auth.  


:: add registry
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

:: Windows explorer restart
taskkill /f /im explorer.exe
explorer 

echo success press any key.
pause > nul
exit
