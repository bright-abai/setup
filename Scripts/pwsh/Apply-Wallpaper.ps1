param (
    [Parameter(Mandatory = $true)][string]$userIndex
)

$wallpapersFolder = "C:\Wallpapers"
$controlFolder = "C:\Control"
$student = "ST-{0:D2}" -f $userIndex

. "$PSScriptRoot\LibEditRegistries.ps1"

function Set-Wallpaper {
    param (
        [string]$username
        [string]$sourceImage
        [string]$destinationImage
    )

    Copy-Item -Path $sourceImage -Destination $destinationImage -Force

    $regs = @(
        @("HKU:\$sid\software\microsoft\windows\currentVersion\policies\system", "Wallpaper"     , "String", $destinationImage),
        @("HKU:\$sid\software\microsoft\windows\currentVersion\policies\system", "WallpaperStyle", "DWord" , 3)
    )
    EditRegitries -Username $username -Regs $regs
}

$userSource  = [System.IO.Path]::Combine($controlFolder, "numbers", "$userIndex.jpg")
$adminSource = [System.IO.Path]::Combine($controlFolder, "bright.jpg")
$userDestination  = [System.IO.Path]::Combine($wallpapersFolder, "$student.jpg")
$adminDestination = [System.IO.Path]::Combine($wallpapersFolder, "admin.jpg")

Set-Wallpaper -UserName $student -SourceImage $userSource -DestinationImage $userDestination
Set-Wallpaper -UserName "Admin" -SourceImage $adminSource -DestinationImage $adminDestination

$path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
$props = @("LockScreenImagePath", "LockScreenImageUrl", "LockScreenImageStatus")
$types = @("String", "String", "DWord")
$vals = @($adminDestination, "$adminDestination", 1)
EditRegitry -Path $path -Prop $props[0]-Type $types[0] -Value $vals[0]
EditRegitry -Path $path -Prop $props[1]-Type $types[1] -Value $vals[1]
EditRegitry -Path $path -Prop $props[2]-Type $types[2] -Value $vals[2]

RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

# @("HKLM\software\policies\microsoft\windows\personalization", "LockScreenImage", "String", "path/to/img")