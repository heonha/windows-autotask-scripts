@echo off
::�����ڸ��
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
echo ######### ������̸� : %username% ###########
echo ################################################
echo ################################################
echo #PC�̸��� �����մϴ�. 
echo �Ʒ��� PC�� ���� �ڻ��ȣ�� �Է����ּ��� ����: 1-20-001
set /p setPcName=�ڻ��ȣ : 
wmic computersystem where caption="%computername%" call rename name="%setPcName%"
echo #������ Ȯ�� �Ϸ�. 