@echo off
REM SSH Configuration Script for Windows 10
REM Run as Administrator

echo Configuring SSH...
echo.

REM Allow PubkeyAuth
powershell -Command "(Get-Content 'C:\ProgramData\ssh\sshd_config') -replace '^#?PubkeyAuthentication yes', 'PubkeyAuthentication yes' | Set-Content 'C:\ProgramData\ssh\sshd_config'"
echo Port changed to 2222

REM Create firewall rule
powershell -Command "New-NetFirewallRule -DisplayName 'SSH Port 2222' -Direction Inbound -LocalPort 2222 -Protocol TCP -Action Allow" >nul 2>&1
echo Firewall rule created

REM Restart SSH service
net stop sshd >nul 2>&1
net start sshd >nul 2>&1
echo SSH service restarted

REM Create .ssh directory and authorized_keys
if not exist "C:\Users\teacher\.ssh" mkdir "C:\Users\teacher\.ssh"
echo ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJjQql2FUXpoMhzJoqHGjlKO1584BJIZGH2VDJPxiADH teacher@TEACHER-104 > "C:\Users\teacher\.ssh\authorized_keys"

REM Set permissions
icacls "C:\Users\teacher\.ssh" /inheritance:r /grant "teacher:F" /grant "SYSTEM:F" >nul 2>&1
icacls "C:\Users\teacher\.ssh\authorized_keys" /inheritance:r /grant teacher:F /grant "SYSTEM:F" >nul 2>&1
echo Permissions configured

echo.
echo Done!
pause
