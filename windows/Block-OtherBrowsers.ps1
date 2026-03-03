# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as an administrator."
    Pause
    exit 1
}

. "$PSScriptRoot\LibEdit-Registries.ps1"

$regsUser = @(
    @("software\microsoft\windows\currentversion\policies\explorer", "DisallowRun", "DWord", "1"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun",  "1", "String", "chrome.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun",  "2", "String", "msedge.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun",  "3", "String", "brave.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun",  "4", "String", "browser.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun",  "5", "String", "opera.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun",  "6", "String", "iexplore.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun",  "7", "String", "safari.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun",  "8", "String", "vivaldi.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun",  "9", "String", "chromium.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun", "10", "String", "AvastBrowser.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun", "11", "String", "RobloxPlayerBeta.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun", "12", "String", "RobloxPlayer.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun", "13", "String", "RobloxStudioBeta.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun", "14", "String", "RobloxStudio.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun", "15", "String", "MinecraftLauncher.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun", "16", "String", "minecraft.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun", "17", "String", "javaw.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun", "18", "String", "KLauncher.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun", "19", "String", "LL.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun", "20", "String", "StartAllBackCfg.exe"),
    @("software\microsoft\windows\currentversion\policies\explorer\disallowrun", "21", "String", "GrannyLegacy.exe")
)

Edit-RegistriesUser -UserName "student" -Regs $regsUser
