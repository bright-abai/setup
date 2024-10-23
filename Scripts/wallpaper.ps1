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
        New-ItemProperty -Path $path -Name $prop -Value $value -PropertyType $type
        Write-Host "Property $prop at $path created for $username with $value."
    }

    Write-Host "Completed"
}

param(
    [Parameter(Mandatory = $true)]
    [string]$img
)

$wallpapers = "C:\Users\Wallpapers"
$srcUsrImg = Join-Path -Path $PSScriptRoot -ChildPath "numbers\$img.jpg"
$srcAdmImg = Join-Path -Path $PSScriptRoot -ChildPath "Bright.jpg"
$usrImg = "C:\Users\Wallpapers\$img.jpg"
$admImg = "C:\Users\Wallpapers\Bright.jpg"

if (-not (Test-Path -Path $wallpapers)) {
    New-Item -Path $wallpapers -ItemType Directory -Force
    Write-Host "Created destination directory: $wallpapers"
}

Copy-Item -Path $srcUsrImg -Destination $usrImg -Force
Copy-Item -Path $srcAdmImg -Destination $admImg -Force

Write-Host "Images copied to C:\Users\Wallpapers."

$usr = (Get-LocalUser -Name "ST-20").SID
$adm = (Get-LocalUser -Name "Admin").SID

Edit-Registry -username "ST-20" -path "Registry::HKEY_USERS\$usr\software\microsoft\windows\currentVersion\policies\system" -prop "Wallpaper" -value $usrImg -type  "String"
Edit-Registry -username "Admin" -path "Registry::HKEY_USERS\$usr\software\microsoft\windows\currentVersion\policies\system" -prop "WallpaperStyle" -value "3" -type  "String"

Edit-Registry -username "ST-20" -path "Registry::HKEY_USERS\$adm\software\microsoft\windows\currentVersion\policies\system" -prop "Wallpaper" -value $admImg -type  "String"
Edit-Registry -username "Admin" -path "Registry::HKEY_USERS\$adm\software\microsoft\windows\currentVersion\policies\system" -prop "WallpaperStyle" -value "3" -type  "String"

