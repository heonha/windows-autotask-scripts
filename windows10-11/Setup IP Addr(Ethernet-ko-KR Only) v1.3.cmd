@echo off
::Get ADMIN start
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
::Get ADMIN end


:: Setup Base
set subnet=192.168.
set subnetMask=255.255.255.0
set dns1=168.126.63.1
set dns2=8.8.8.8

:setmenu
echo 1. 192.168.x.x
echo 2. CUSTOM

set /p menu=Select Number:

if %menu%==1 (
goto external
) else if %menu%==2 (
goto internal) else (
echo Input Retry
clear
goto setmenu
)

:external
echo #SETUP 192.168.x.x
echo DNS / Subnet Mask
echo DNS 1 : %dns2%
echo DNS 2 : %internetdns%
echo Subnet Mask : %subnetMask%

:: User Set
set /p setIpv4=IPAddr: 192.168.
set /p setGateway=Gateway: 192.168.

:: Apply Configure
netsh interface ipv4 set address name="이더넷" static %subnet%%setIpv4% %subnetMask% %subnet%%setGateway%
netsh interface ipv4 set dnsservers "이더넷" static %dns1% primary
netsh interface ipv4 add dnsservers "이더넷" %dns2% index=2

ipconfig /all
pause>nul
goto exit

:internal
echo #CUSTOM IP SET
echo DNS / Subnet Mask
echo DNS 1 : %dns1%
echo DNS 2 : %dns2%
echo Subnet Mask : %subnetMask%

:: User Set
set /p setIpv4=IPAddr: 
set /p setGateway=Gateway: 

:: Apply Configure
netsh interface ipv4 set address name="이더넷" static %setIpv4% 255.255.255.0 %setGateway%
netsh interface ipv4 set dnsservers "이더넷" static %dns1% primary
netsh interface ipv4 add dnsservers "이더넷" %dns2% index=2

ipconfig /all
pause>nul
goto exit

:exit
exit