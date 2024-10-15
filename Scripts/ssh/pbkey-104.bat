@echo off

:: Check if running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this script as an administrator.
    pause
    exit /b 1
)

:: Ensure the file is saved with UTF-8 encoding
powershell -Command "Get-Content -Path '%USERPROFILE%\.ssh\authorized_keys' | Set-Content -Path '%USERPROFILE%\.ssh\authorized_keys' -Encoding UTF8"

:: Paste the pubkey
echo ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICtinTMwQpzpT9POUllaAGapJK231Btp5zKPug1KY+fL abai@TR-104 > "%USERPROFILE%\.ssh\authorized_keys"

powershell -Command "Invoke-Item '%USERPROFILE%\.ssh'"

echo.
echo WARNIING! You should setup correct permissions! Go to github.com/bright-abai/setup/sshcontrol.md for further instructions
pause
