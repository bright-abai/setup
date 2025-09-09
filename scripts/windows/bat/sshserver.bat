@echo off

:: Check if running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this script as an administrator.
    pause
    exit /b 1
)

:: Install OpenSSH Server
powershell -command "Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*' | Add-WindowsCapability -Online"

:: Add firewall rule for SSH if it doesn't already exist
powershell -Command "if (-Not (Get-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -ErrorAction SilentlyContinue)) { New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH SSH Server' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 }"


:: Set sshd service to start automatically
powershell -command "Set-Service -Name sshd -StartupType 'Automatic'"

:: Start sshd service
powershell -command "Start-Service sshd"

:: Navigate to user profile and create .ssh directory
cd %USERPROFILE%
if not exist ".ssh" (
    mkdir .ssh
)
cd .ssh

:: Create authorized_keys file if it doesn't exist
if not exist "authorized_keys" (
    type nul > authorized_keys
)

:: Modify sshd_config to comment out Match Group administrators section
set "configFile=C:\ProgramData\ssh\sshd_config"
set "tempFile=%TEMP%\sshd_config.tmp"

powershell -command "((Get-Content -Path '%configFile%') -replace '^Match Group administrators', '# Match Group administrators' -replace '^\s*AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys', '# AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys') | Set-Content -Path '%tempFile%'"

:: Replace original config file with modified one
move /Y "%tempFile%" "%configFile%"

:: Restart sshd service to apply changes
powershell -command "Restart-Service sshd"

echo.
echo OpenSSH Server setup is complete.
pause
