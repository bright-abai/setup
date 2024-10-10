@echo off

:: Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with administrative privileges.
) else (
    echo Please run this script as an administrator.
    pause
    exit /b 1
)

:: Create or overwrite authorized_keys file with your SSH key
echo ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICtinTMwQpzpT9POUllaAGapJK231Btp5zKPug1KY+fL abai@TR-104>"%USERPROFILE%\.ssh\authorized_keys"

:: Ensure the file is saved with UTF-8 encoding
powershell -Command "Get-Content -Path '%USERPROFILE%\.ssh\authorized_keys' | Set-Content -Path '%USERPROFILE%\.ssh\authorized_keys' -Encoding UTF8"

:: Restart sshd service to apply changes
powershell -command "Restart-Service sshd"

echo.
echo Applied public key.
pause