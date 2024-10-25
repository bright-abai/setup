@echo off
for /l %%i in (1,1,20) do (
    setlocal enabledelayedexpansion
    if %%i lss 10 (set "suffix=0%%i") else (set "suffix=%%i")
    set "address=Admin@ST-104-!suffix!"
    
    echo Starting connection to !address! in parallel...
    
    start /b ssh !address! "wmic UserAccount where Name='ST-!suffix!' set PasswordExpires=False"
    
    endlocal
)
pause
