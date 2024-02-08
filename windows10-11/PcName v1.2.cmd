@echo off
::관리자명령
@echo off

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

echo ################################################
echo ################################################
echo ######### 사용자이름 : %username% ###########
echo ################################################
echo ################################################
echo #PC이름을 설정합니다. 
echo 아래에 PC에 적힌 자산번호를 입력해주세요 예시: 1-20-001
set /p setPcName=자산번호 : 
wmic computersystem where caption="%computername%" call rename name="%setPcName%"
echo #데이터 확인 완료. 