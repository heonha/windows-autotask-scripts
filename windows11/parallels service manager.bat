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



:menu
cls
echo 1. Parallels ���� ����
echo 2. Parallels ���� ����
echo 3. ����

set /p choice=���ϴ� �۾��� �����ϼ��� (1, 2, �Ǵ� 3): 

if "%choice%"=="1" (
    goto start
) else if "%choice%"=="2" (
    goto stop
) else if "%choice%"=="3" (
    echo ���α׷��� �����մϴ�.
    exit /b
) else (
    echo �ùٸ� ������ �ƴմϴ�. �ٽ� �����ϼ���.
    timeout /nobreak /t 2 > nul
    goto menu
)

:start
REM ���� ���

sc start "Parallels Coherence Service" 
sc start "Parallels Tools Service"

cls
echo "### ���񽺸� �����ϴ� ��.###"

timeout /nobreak /t 2 > nul

sc query "Parallels Coherence Service" 
sc query "Parallels Tools Service"
echo "�Ϸ�"

echo success press any key.
pause > nul
exit

:stop
sc stop "Parallels Coherence Service" 
sc stop "Parallels Tools Service"
echo "### ���񽺸� stop �߽��ϴ�.###"

timeout /nobreak /t 2 > nul

echo "### ���񽺸� stop ���.###"
sc query "Parallels Coherence Service" 
sc query "Parallels Tools Service"

echo success press any key.
pause > nul
exit
