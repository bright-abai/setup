$wallpapersFolder = "C:\Wallpapers"
$controlFolder = "C:\Control"
$studentName = (Get-LocalUser | Where-Object { $_.Name -like 'ST-*' } | Select-Object -ExpandProperty Name)
$studentNumber = $studentName[-2..-1] -join ''

. "$PSScriptRoot\LibEdit-Registries.ps1"

function Set-Wallpaper {
    param (
        [string]$username,
        [string]$sourceImage,
        [string]$destinationImage
    )

    Copy-Item -Path $sourceImage -Destination $destinationImage -Force

    $regs = @(
        @("Registry::HKEY_USERS:\$sid\software\microsoft\windows\currentVersion\policies\system", "Wallpaper"     , "String", $destinationImage), #HKU is not found somehow
        @("Registry::HKEY_USERS:\$sid\software\microsoft\windows\currentVersion\policies\system", "WallpaperStyle", "DWord" , 3)
    )
    Edit-Registries -Username $username -Regs $regs
}

$userSource  = [System.IO.Path]::Combine($controlFolder, "numbers", "$studentNumber.jpg")
$adminSource = [System.IO.Path]::Combine($controlFolder, "bright.jpg")
$userDestination  = [System.IO.Path]::Combine($wallpapersFolder, "$studentName.jpg")
$adminDestination = [System.IO.Path]::Combine($wallpapersFolder, "admin.jpg")

Set-Wallpaper -UserName $student -SourceImage $userSource -DestinationImage $userDestination
Set-Wallpaper -UserName "Admin" -SourceImage $adminSource -DestinationImage $adminDestination

$path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
$props = @("LockScreenImagePath", "LockScreenImageUrl", "LockScreenImageStatus")
$types = @("String", "String", "DWord")
$vals = @($adminDestination, "$adminDestination", 1)
Edit-Registry -Path $path -Prop $props[0]-Type $types[0] -Value $vals[0]
Edit-Registry -Path $path -Prop $props[1]-Type $types[1] -Value $vals[1]
Edit-Registry -Path $path -Prop $props[2]-Type $types[2] -Value $vals[2]

RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

# @("HKLM\software\policies\microsoft\windows\personalization", "LockScreenImage", "String", "path/to/img")
