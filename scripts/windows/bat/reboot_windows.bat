@echo off
REM Windows Switch Script - Boots to next OS using efibootmgr
REM Run as Administrator

echo Switching to Windows on all machines...
echo.

for /l %%i in (1,1,22) do (
    setlocal enabledelayedexpansion
    if %%i lss 10 (set "suffix=0%%i") else (set "suffix=%%i")
    set "address=Admin@ST-104-!suffix!"
    
    echo Connecting to ST-104-!suffix!...
    
    start /b ssh !address! "efibootmgr --bootnext 0000 && shutdown -r now"
    
    endlocal
)

echo.
echo Reboot commands sent to all machines
pause