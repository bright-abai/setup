# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as an administrator."
    Pause
    exit 1
}

. "$PSScriptRoot\LibEdit-Registries.ps1"

# The reason is to allow teacher access to the control panel
Edit-RegistriesUser -UserName "student" -Regs @(@("software\microsoft\windows\currentversion\policies\explorer", "NoControlPanel", "DWord", "1"), "")
