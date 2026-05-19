# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as an administrator."
    Pause
    exit 1
}

. "$PSScriptRoot\LibEdit-Registries.ps1"

$regsUser = @(
    @("software\microsoft\windows\currentversion\restartmanager" , "UserApps"   , "DWord", "0"),
    @("software\microsoft\office\16.0\word\options", "SaveAutoRecoverInfo", "DWord", "1"),
    @("software\microsoft\office\16.0\word\options", "KeepLastAutoRecoveredVersion", "DWord", "0")
)

Edit-RegistriesUser -UserName "student" -Regs $regsUser