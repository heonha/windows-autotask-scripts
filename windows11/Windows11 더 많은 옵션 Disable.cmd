@echo off
::�����ڱ�ȯ ȹ�� start
:GotAdmin
 ::-------------------------------------
 REM  --> Check for permissions
 >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
 
REM --> If error flag set, we do not have admin.
 if '%errorlevel%' NEQ '0' (
     echo Requesting administrative privileges...
     goto UACPrompt
 ) else ( goto gotAdmin )
 
:UACPrompt
     echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
     echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
 
    "%temp%\getadmin.vbs"
     exit /B
 
:gotAdmin
     if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
     pushd "%CD%"
     CD /D "%~dp0"
 :--------------------------------------
::�����ڱ�ȯ ȹ�� end

:: �� ��ũ��Ʈ�� ������11�� ��Ŭ�� �޴��� windows10�� ���� �����մϴ�.
:: This script changes right-click menu in Windows 11 to Windows 10.


echo processing... If it takes too long, press enter. 

:: add registry
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

:: Windows explorer restart
taskkill /f /im explorer.exe
explorer 

echo success press any key.
pause > nul