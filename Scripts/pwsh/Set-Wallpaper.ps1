param (
    [Parameter(Mandatory = $true)]
    [string]$img
)

function Edit-Registry {
    param (
        [string]$username,
        [string]$path,
        [string]$prop,
        [string]$value,
        [string]$type
    )

    try {
        $current = Get-ItemProperty -Path $path -Name $prop -ErrorAction Stop
        Set-ItemProperty -Path $path -Name $prop -Value $value
        Write-Host "Property $prop at $path updated for $username with $value, replacing $($current.$prop)"
    
    } catch {
        if (-not (Test-Path $path)) {
            New-Item -Path $path
        }
        New-ItemProperty -Path $path -Name $prop -Value $value -PropertyType $type
        Write-Host "Property $prop at $path created for $username with $value."
    }
}

function Edit-AccessRule {
    param (
        [string[]]$paths
    )

    foreach ($p in $paths) {
        $acl = Get-Acl $p
        $system = "S-1-5-18"
        $adms   = "S-1-5-32-544"
        $usrs   = "S-1-5-32-545"

        $acl.SetAccessRuleProtection($true, $false) # remove inheritance, remove other rules
        $denyUsers  = New-Object System.Security.AccessControl.FileSystemAccessRule($usrs, "Delete, Modify", "Deny")
        $acl.SetAccessRule($denyUsers)
        $allowAdmins = New-Object System.Security.AccessControl.FileSystemAccessRule($adms, "FullControl", "Allow")
        $acl.SetAccessRule($allowAdms)
        $allowSystem = New-Object System.Security.AccessControl.FileSystemAccessRule($system, "FullControl", "Allow")
        $acl.SetAccessRule($allowAdms)

        Set-Acl -Path $p -AclObject $acl
    }
}


$wallpapers = "C:\Users\Admin\Wallpapers"
$srcUsrImg = Join-Path -Path $PSScriptRoot -ChildPath "numbers\$img.jpg"
$srcAdmImg = Join-Path -Path $PSScriptRoot -ChildPath "Bright.jpg"
$usrImg = "C:\Users\Admin\Wallpapers\$img.jpg"
$admImg = "C:\Users\Admin\Wallpapers\Bright.jpg"

if (-not (Test-Path -Path $wallpapers)) {
    New-Item -Path $wallpapers -ItemType Directory -Force
    Write-Host "Created destination directory: $wallpapers"
}

Copy-Item -Path $srcUsrImg -Destination $usrImg -Force
Copy-Item -Path $srcAdmImg -Destination $admImg -Force

Edit-AccessRule -path $usrImg

Write-Host "Images copied to C:\Users\Wallpapers. Access rule is modified for $usrImg"

$usr = "ST-20"
$adm = "Admin"

$usrSID = (New-Object System.Security.Principal.NTAccount($usr)).Translate([System.Security.Principal.SecurityIdentifier]).Value
$admSID = (New-Object System.Security.Principal.NTAccount($adm)).Translate([System.Security.Principal.SecurityIdentifier]).Value

$usrLoaded = Confirm-UserSID -sid $usrSID -name $usr
$usrLoaded = Confirm-UserSID -sid $admSID -name $adm

Edit-Registry -username "ST-20" -path "Registry::HKEY_USERS\$usrSID\software\microsoft\windows\currentVersion\policies\system" -prop "Wallpaper" -value $usrImg -type  "String"
Edit-Registry -username "Admin" -path "Registry::HKEY_USERS\$usrSID\software\microsoft\windows\currentVersion\policies\system" -prop "WallpaperStyle" -value 3 -type  "DWord"

Edit-Registry -username "ST-20" -path "Registry::HKEY_USERS\$admSID\software\microsoft\windows\currentVersion\policies\system" -prop "Wallpaper" -value $admImg -type  "String"
Edit-Registry -username "Admin" -path "Registry::HKEY_USERS\$admSID\software\microsoft\windows\currentVersion\policies\system" -prop "WallpaperStyle" -value 3 -type  "DWord"

if ($usrLoaded) {
    reg unload "HKEY_USERS\$usr"
    Write-Host "Unloaded hive for $usr"
}
if ($admLoaded) {
    reg unload "HKEY_USERS\$adm"
    Write-Host "Unloaded hive for $adm"
}

Edit-Registry -username "Machine" -path "Registry::HKEY_LOCAL_MACHINE\software\policies\microsoft\windows\personalization" -prop "LockScreenImage" -value $usrImg -type  "String"
Edit-Registry -username "Machine" -path "Registry::HKEY_LOCAL_MACHINE\software\policies\microsoft\windows\personalization" -prop "NoChangingLockScreen" -value 1 -type  "DWord"

#RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters