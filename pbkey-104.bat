@echo off

:: Check if running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this script as an administrator.
    pause
    exit /b 1
)

:: Stop sshd service to release any locks on files
powershell -command "Stop-Service sshd"

:: Create or overwrite authorized_keys file with your SSH key
echo ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICtinTMwQpzpT9POUllaAGapJK231Btp5zKPug1KY+fL abai@TR-104 > "%USERPROFILE%\.ssh\authorized_keys"

:: Ensure the file is saved with UTF-8 encoding
powershell -Command "Get-Content -Path '%USERPROFILE%\.ssh\authorized_keys' | Set-Content -Path '%USERPROFILE%\.ssh\authorized_keys' -Encoding UTF8"

:: Remove all permissions and disable inheritance on .ssh directory
icacls "%USERPROFILE%\.ssh" /inheritance:r /remove:g "Administrators" /remove:g "Администраторы" /grant:r "%USERNAME%:F" "SYSTEM:F"

:: Remove all permissions and disable inheritance on authorized_keys file
icacls "%USERPROFILE%\.ssh\authorized_keys" /inheritance:r /remove:g "Administrators" /remove:g "Администраторы" /grant:r "%USERNAME%:F" "SYSTEM:F"

:: Start sshd service
powershell -command "Start-Service sshd"

echo.
echo Applied public key with correct permissions.
pause
