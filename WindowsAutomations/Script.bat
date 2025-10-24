@REM Merge three scripts into a single file, so it will be easy to run on systems.


@echo off
setlocal enabledelayedexpansion

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script must be run as Administrator.
    pause
    exit /b
)



@REM Windows Rename

set /p NewPCName=Enter the new computer name (15 chars max, letters/numbers/hyphens, no spaces): 
if "%NewPCName%"=="" (
    echo No computer name entered. Aborting rename.
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
    echo Rename aborted.
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

echo Rename completed.




@REM Disbale AU

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoRebootWithLoggedOnUsers /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v ScheduledInstallDay /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v ScheduledInstallTime /t REG_DWORD /d 3 /f

echo Windows Auto Update disabled.




@REM Automatic Shutdown

schtasks /Change /RU "" /RP "12345678" /TN "%TaskName%" /ST %ShutdownTime%

echo Auto Shutdown task updated.




echo All operations completed. A restart may be required for some changes to take effect.
pause