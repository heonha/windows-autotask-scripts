@echo off
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



:menu
cls
echo 1. Parallels 서비스 시작
echo 2. Parallels 서비스 중지
echo 3. 종료

set /p choice=원하는 작업을 선택하세요 (1, 2, 또는 3): 

if "%choice%"=="1" (
    goto start
) else if "%choice%"=="2" (
    goto stop
) else if "%choice%"=="3" (
    echo 프로그램을 종료합니다.
    exit /b
) else (
    echo 올바른 선택이 아닙니다. 다시 선택하세요.
    timeout /nobreak /t 2 > nul
    goto menu
)

:start
REM 서비스 목록

sc start "Parallels Coherence Service" 
sc start "Parallels Tools Service"

cls
echo "### 서비스를 시작하는 중.###"

timeout /nobreak /t 2 > nul

sc query "Parallels Coherence Service" 
sc query "Parallels Tools Service"
echo "완료"

echo success press any key.
pause > nul
exit

:stop
sc stop "Parallels Coherence Service" 
sc stop "Parallels Tools Service"
echo "### 서비스를 stop 했습니다.###"

timeout /nobreak /t 2 > nul

echo "### 서비스를 stop 결과.###"
sc query "Parallels Coherence Service" 
sc query "Parallels Tools Service"

echo success press any key.
pause > nul
exit
