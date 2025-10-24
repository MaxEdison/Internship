@REM This script just renames computer name and User Fullname (Which is shown in Windows Login Page)
@REM Requires administrator privileges - right-click and run as admin.
@REM A restart is required for changes to fully take effect, especially on the login screen.


@echo off
setlocal enabledelayedexpansion



net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script must be run as Administrator.
    pause
    exit /b
)


set /p NewPCName=Enter the new computer name (15 chars max, letters/numbers/hyphens, no spaces): 
if "%NewPCName%"=="" (
    echo No computer name entered. Aborting.
    pause
    exit /b
)

set "INVALID=0"
if "!NewPCName!" neq "!NewPCName: =!" set INVALID=1
if "!INVALID!"=="1" (
    echo Invalid computer name: No spaces allowed.
    pause
    exit /b
)

if not "!NewPCName:~15!"=="" (
    echo Invalid computer name: Must be 15 characters or fewer.
    pause
    exit /b
)

set /p NewFullname=Enter the new full name for user %USERNAME%: 
if "%NewFullname%"=="" (
    echo No full name entered. Using current full name.
    set NewFullname=
)



echo.

echo Summary of changes:
echo - Computer name: %COMPUTERNAME% to %NewPCName%

if not "%NewFullname%"=="" echo - Full name: From current to "%NewFullname%"

set /p CONFIRM=Proceed with these changes? (Y/N): 
if /i not "%CONFIRM%"=="Y" (
    echo Aborted.
    pause
    exit /b
)


if not "%NewFullname%"=="" (
    net user %USERNAME% /fullname:"%NewFullname%"
    if %errorlevel%==0 (
        echo Full name changed successfully.
    ) else (
        echo Failed to change full name. Check input and try again.
        pause
        exit /b
    )
)


wmic computersystem where name="%COMPUTERNAME%" call rename name="%NewPCName%"
if %errorlevel%==0 (
    echo Computer name change initiated successfully.
) else (
    echo Failed to change computer name. Check input and try again.
    pause
    exit /b
)


echo DONE !
