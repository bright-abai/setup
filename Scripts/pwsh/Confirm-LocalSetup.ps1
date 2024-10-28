# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as an administrator."
    Pause
    exit 1
}

function Confirm-OpenSSH {
    $openssh = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
    if ($openssh.State -ne 'Installed') {
        Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    }


    # Add firewall rule for SSH if it doesn't already exist
    if (-not (Get-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -ErrorAction SilentlyContinue)) {
        New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH SSH Server' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
    }

    Set-Service -Name sshd -StartupType 'Automatic'
    Start-Service sshd

    # Navigate to user profile and create .ssh directory
    $sshDir = [System.IO.Path]::Combine($env:USERPROFILE, ".ssh")
    if (-not (Test-Path $sshDir)) {
        New-Item -Path $sshDir -ItemType Directory
    }

    # Create authorized_keys file if it doesn't exist
    $authorizedKeysFile = [System.IO.Path]::Combine($sshDir, "authorized_keys")
    if (-not (Test-Path $authorizedKeysFile)) {
        New-Item -Path $authorizedKeysFile -ItemType File
    }

    # Modify sshd_config to comment out Match Group administrators section
    $configFile = "C:\ProgramData\ssh\sshd_config"
    $tempFile = Join-Path $env:TEMP "sshd_config.tmp"
    (Get-Content -Path $configFile) -replace '^Match Group administrators', '# Match Group administrators' `
        -replace '^\s*AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys', '# AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys' | 
        Set-Content -Path $tempFile
    Move-Item -Path $tempFile -Destination $configFile -Force

    Restart-Service sshd
    Write-Host "OpenSSH confirmed."
}

$wallpapersFolder = "C:\Wallpapers"
$controlFolder = "C:\Control"
$studentName = (Get-LocalUser | Where-Object { $_.Name -like 'ST-*' } | Select-Object -ExpandProperty Name)

function Confirm-Folders {
    if (-Not (Test-Path $wallpapersFolder)) {
        New-Item -Path $wallpapersFolder -ItemType Directory -Force
    }
    $acl = Get-Acl $wallpapersFolder
    $acl.SetAccessRuleProtection($true, $false)
    $allowUsrs = New-Object System.Security.AccessControl.FileSystemAccessRule($studentName, "Read", "Allow")
    $acl.SetAccessRule($allowUsrs)
    $denyUsrs  = New-Object System.Security.AccessControl.FileSystemAccessRule($studentName, "Delete, Modify", "Deny")
    $acl.SetAccessRule($denyUsrs)
    $allowAdms = New-Object System.Security.AccessControl.FileSystemAccessRule("Admin", "FullControl", "Allow")
    $acl.SetAccessRule($allowAdms)
    $AllowSys  = New-Object System.Security.AccessControl.FileSystemAccessRule("System" , "FullControl", "Allow")
    $acl.SetAccessRule($AllowSys)
    Set-Acl -Path $wallpapersFolder -AclObject $acl
    

    if (-Not (Test-Path $controlFolder)) {
        New-Item -Path $controlFolder -ItemType Directory -Force
    }
    $acl = Get-Acl $controlFolder
    $acl.SetAccessRuleProtection($true, $false)
    $denyUsrs  = New-Object System.Security.AccessControl.FileSystemAccessRule($studentName, "Read, Delete, Modify", "Deny")
    $acl.SetAccessRule($denyUsrs)
    $allowAdms = New-Object System.Security.AccessControl.FileSystemAccessRule("Admin", "FullControl", "Allow")
    $acl.SetAccessRule($allowAdms)
    $AllowSys  = New-Object System.Security.AccessControl.FileSystemAccessRule("System" , "FullControl", "Allow")
    $acl.SetAccessRule($AllowSys)
    Set-Acl -Path $controlFolder -AclObject $acl
    
    Write-Host "Folders confirmed"
}

Confirm-OpenSSH
Confirm-Folders
