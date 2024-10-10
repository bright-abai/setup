@echo off
setlocal enabledelayedexpansion

for /L %%i in (1,1,20) do (
    set "hostname=ST-104-0%%i"
    if %%i gtr 9 set "hostname=ST-104-%%i"
    
    ssh Admin@!hostname! "shutdown /s /t 0"
    if errorlevel 1 (
        echo Failed to connect or execute shutdown on !hostname!
    ) else (
        echo Successfully shut down !hostname!
    )
)
pause
