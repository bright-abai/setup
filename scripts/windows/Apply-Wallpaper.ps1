. "$PSScriptRoot\LibEdit-Registries.ps1"

$controlFolder = "C:\Control"

function Set-Wallpaper {
    param (
        [string]$username,
        [string]$image
    )

    $regs = @(
        @("software\microsoft\windows\currentVersion\policies\system", "Wallpaper"     , "String", $image),
        @("software\microsoft\windows\currentVersion\policies\system", "WallpaperStyle", "DWord" , 3)
    )
    Edit-RegistriesUser -Username $username -Regs $regs
}

function Set-Permissions {
    param (
        [string]$adminImage,
        [string]$userImage
    )

    $computerName = $env:COMPUTERNAME
    $fullStudent = "$computerName\student"
    $fullAdmin = "$computerName\teacher"

    $acl = Get-Acl $adminImage
    $acl.SetAccessRuleProtection($true, $false)
    $denyUsrs  = New-Object System.Security.AccessControl.FileSystemAccessRule($fullStudent, "Read, Delete, Modify", "Deny")
    $acl.SetAccessRule($denyUsrs)
    $allowAdms = New-Object System.Security.AccessControl.FileSystemAccessRule($fullAdmin, "FullControl", "Allow")
    $acl.SetAccessRule($allowAdms)
    $AllowSys  = New-Object System.Security.AccessControl.FileSystemAccessRule("System" , "FullControl", "Allow")
    $acl.SetAccessRule($AllowSys)
    Set-Acl $adminImage $acl

    $acl = Get-Acl $userImage
    $acl.SetAccessRuleProtection($true, $false)
    $allowUsrs = New-Object System.Security.AccessControl.FileSystemAccessRule($fullStudent, "Read", "Allow")
    $acl.SetAccessRule($allowUsrs)
    $denyUsrs  = New-Object System.Security.AccessControl.FileSystemAccessRule($fullStudent, "Write", "Deny")
    $acl.SetAccessRule($denyUsrs)
    $allowAdms = New-Object System.Security.AccessControl.FileSystemAccessRule($fullAdmin, "FullControl", "Allow")
    $acl.SetAccessRule($allowAdms)
    $AllowSys  = New-Object System.Security.AccessControl.FileSystemAccessRule("System" , "FullControl", "Allow")
    $acl.SetAccessRule($AllowSys)
    Set-Acl $userImage $acl
}

$userImagePath = Read-Host "Enter the path to the user image (e.g., C:\Control\images\userImage.jpg)"
$adminImagePath = [System.IO.Path]::Combine($controlFolder, "images", "bright.jpg")

if (-Not (Test-Path $userImagePath)) {
    Write-Host "User image path does not exist. Please check the path."
    exit
}

Set-Wallpaper -UserName "student" -Image $userImagePath
Set-Wallpaper -UserName "teacher" -Image $adminImagePath

$path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
$props = @("LockScreenImagePath", "LockScreenImageUrl", "LockScreenImageStatus")
$types = @("String", "String", "DWord")
$vals = @($adminImagePath, "$adminImagePath", 1)
Edit-Registry -Path $path -Prop $props[0] -Type $types[0] -Value $vals[0]
Edit-Registry -Path $path -Prop $props[1] -Type $types[1] -Value $vals[1]
Edit-Registry -Path $path -Prop $props[2] -Type $types[2] -Value $vals[2]

Set-Permissions -adminImage $adminImagePath -userImage $userImagePath

RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

Write-Host "Wallpaper and permissions updated successfully."
