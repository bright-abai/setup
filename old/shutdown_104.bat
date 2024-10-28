@echo off
for /l %%i in (1,1,20) do (
    setlocal enabledelayedexpansion
    if %%i lss 10 (set "suffix=0%%i") else (set "suffix=%%i")
    set "address=Admin@ST-104-!suffix!"
    
    echo Starting connection to !address! in parallel...
    
    start cmd /c ssh !address! "shutdown -s -t 0"
    
    endlocal
)
pause
