@echo off
setlocal enabledelayedexpansion

::start /b scp hosts Admin@ST-104-01:C:\Windows\System32\drivers\etc\

for /l %%i in (1,1,22) do (
    if %%i lss 10 (
        set "suffix=0%%i"
    ) else (
        set "suffix=%%i"
    )

    set "address=Admin@ST-104-!suffix!"
    
    echo Starting connection to !address!
    
    start /b scp AcrylicHosts.txt !address!:C:\Control\AcrylicDNS\
    start /b ssh !address! C:\Control\AcrylicDNS\AcrylicUI.exe RestartAcrylicService

)

endlocal
pause
