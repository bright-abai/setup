param (
    [Parameter(Mandatory = $true)][string]$userIndex
)

. "$PSScriptRoot\LibEditRegistries.ps1"

$wallpapersFolder = "C:\Wallpapers"
$controlFolder = "C:\Control"

function Set-Wallpaper {
    param (
        [string]$username
    )
    $dst = [System.IO.Path]::Combine($wallpapersFolder, "$username.jpg")
    Copy-Item -Path $src -Destination $dst -Force

    $regs = @(
        @("HKU:\$sid\software\microsoft\windows\currentVersion\policies\system", "Wallpaper"     , "String", $dst),
        @("HKU:\$sid\software\microsoft\windows\currentVersion\policies\system", "WallpaperStyle", "DWord" , 3)
    )
    EditRegitries -Username $username -Regs $regs
    Edit-Registry -Path $regs[$i][0] -Prop $regs[$i][1] -Type $regs[$i][2] -Value $regs[$i][3]

    Edit-Registry -username "ST-20" -path "Registry::HKU:\$usrSID\software\microsoft\windows\currentVersion\policies\system" -prop "Wallpaper" -value $usrImg -type  "String"
Edit-Registry -username "Admin" -path "Registry::HKEY_USERS\$usrSID\software\microsoft\windows\currentVersion\policies\system" -prop "WallpaperStyle" -value 3 -type  "DWord"

Edit-Registry -username "ST-20" -path "Registry::HKEY_USERS\$admSID\software\microsoft\windows\currentVersion\policies\system" -prop "Wallpaper" -value $admImg -type  "String"
Edit-Registry -username "Admin" -path "Registry::HKEY_USERS\$admSID\software\microsoft\windows\currentVersion\policies\system" -prop "WallpaperStyle" -value 3 -type  "DWord"
}

function Confirm-Folders {
    if (-Not (Test-Path $wallpapersFolder)) {
        New-Item -Path $wallpapersFolder -ItemType Directory -Force
        $acl = Get-Acl $wallpapersFolder
        $acl.SetAccessRuleProtection($true, $false)
        $allowUsrs = New-Object System.Security.AccessControl.FileSystemAccessRule("S-1-5-32-545", "Read", "Allow")
        $acl.SetAccessRule($allowUsrs)
        $denyUsrs  = New-Object System.Security.AccessControl.FileSystemAccessRule("S-1-5-32-545", "Delete, Modify", "Deny")
        $acl.SetccessRule($denyUsrs)
        $allowAdms = New-Object System.Security.AccessControl.FileSystemAccessRule("S-1-5-32-544", "FullControl", "Allow")
        $acl.SetAccessRule($allowAdms)
        $AllowSys  = New-Object System.Security.AccessControl.FileSystemAccessRule("S-1-5-18" , "FullControl", "Allow")
        $acl.SetAccessRule($AllowSys)
        Set-Acl -Path $wallpapersFolder -AclObject $acl
    }

    if (-Not (Test-Path $controlFolder)) {
        New-Item -Path $controlFolder -ItemType Directory -Force
        $acl = Get-Acl $controlFolder
        $acl.SetAccessRuleProtection($true, $false)
        $denyUsrs  = New-Object System.Security.AccessControl.FileSystemAccessRule("S-1-5-32-545", "Read, Delete, Modify", "Deny")
        $acl.SetccessRule($denyUsrs)
        $allowAdms = New-Object System.Security.AccessControl.FileSystemAccessRule("S-1-5-32-544", "FullControl", "Allow")
        $acl.SetAccessRule($allowAdms)
        $AllowSys  = New-Object System.Security.AccessControl.FileSystemAccessRule("S-1-5-18" , "FullControl", "Allow")
        $acl.SetAccessRule($AllowSys)
        Set-Acl -Path $controlFolder -AclObject $acl
    }
}

Confirm-Folders

# Set the desktop wallpaper (if needed)
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "Wallpaper" -Value "$wallpaperPath\Wallpaper.jpg"
$src = [System.IO.Path]::Combine($PSScriptRoot, "numbers", "$userIndex.jpg")