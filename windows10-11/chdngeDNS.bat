@echo off
SETLOCAL EnableDelayedExpansion

::관리자권환 획득 start
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
::관리자권환 획득 end



REM DNS 서버 주소 설정
SET "primaryDNS=119.205.195.70"
SET "secondaryDNS=119.205.195.85"

REM 192.168로 시작하는 IP 주소를 가진 첫 번째 네트워크 인터페이스 찾기
FOR /F "tokens=3" %%i IN ('netsh interface ip show config ^| findstr "IP Address"') DO (
    SET ipAddr=%%i
    IF "!ipAddr:~0,7!"=="192.168" (
        FOR /F "tokens=2 delims=:" %%a IN ('netsh interface ip show config ^| findstr /C:"!ipAddr!"') DO (
            SET "interfaceName=%%a"
            GOTO :found
        )
    )
)

:found
REM 네트워크 인터페이스 이름의 앞뒤 공백 제거
SET interfaceName=!interfaceName: =!

REM DNS 서버 주소 변경
IF DEFINED interfaceName (
    netsh interface ip set dns name="!interfaceName!" static !primaryDNS!
    netsh interface ip add dns name="!interfaceName!" addr=!secondaryDNS! index=2
    echo DNS 서버가 !interfaceName!에 대해 변경되었습니다.
) ELSE (
    echo 192.168로 시작하는 IP 주소를 가진 네트워크 인터페이스를 찾을 수 없습니다.
)

ENDLOCAL
