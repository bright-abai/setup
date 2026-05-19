@echo off
:: SSH Configuration Script for Windows 11
:: Run as Administrator

echo Configuring SSH...
echo.

:: Allow PubkeyAuth
powershell -Command "(Get-Content 'C:\ProgramData\ssh\sshd_config') -replace '^#?PubkeyAuthentication yes', 'PubkeyAuthentication yes' | Set-Content 'C:\ProgramData\ssh\sshd_config'"
echo PubkeyAuthentication yes in sshd_config

:: Create firewall rule
powershell -Command "New-NetFirewallRule -DisplayName 'SSH Port 22' -Direction Inbound -LocalPort 22 -Protocol TCP -Action Allow" >nul 2>&1
echo Firewall rule created

:: Restart SSH service
net stop sshd >nul 2>&1
net start sshd >nul 2>&1
echo SSH service restarted

:: Create .ssh directory and authorized_keys
if not exist "C:\Users\teacher\.ssh" mkdir "C:\Users\teacher\.ssh"
echo ssh-ed25519 <insert key here> <insert user here>@TEACHER-<104 or 106> > "C:\Users\teacher\.ssh\authorized_keys"

:: Set permissions
icacls "C:\Users\teacher\.ssh" /inheritance:r /grant "teacher:F" /grant "SYSTEM:F" >nul 2>&1
icacls "C:\Users\teacher\.ssh\authorized_keys" /inheritance:r /grant teacher:F /grant "SYSTEM:F" >nul 2>&1
echo Permissions configured

echo.
echo Done!
pause
