# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as an administrator."
    Pause
    exit 1
}

. "$PSScriptRoot\LibEdit-Registries.ps1"

$regsMachine = @(
    @("HKLM:\software\microsoft\policymanager\default\settings\allowlanguage", "value"               , "DWord", "0"),
    @("HKLM:\software\policies\microsoft\windows\personalization"            , "NoChangingLockScreen", "DWord", "1")
)

$regsUser = @(
    @("software\microsoft\windows\currentversion\policies\system"        , "NoDispAppearancePage"   , "DWord", "1"),
    @("software\microsoft\windows\currentversion\policies\system"        , "NoDispBackgroundPage"   , "DWord", "1"),
    @("software\microsoft\windows\currentversion\policies\system"        , "NoColorChoice"          , "DWord", "1"),
    @("software\microsoft\windows\currentversion\policies\explorer"      , "NoThemesTab"            , "DWord", "1"),
    @("software\microsoft\windows\currentversion\policies\explorer"      , "NoDesktop"              , "DWord", "1"),
    @("software\microsoft\windows\currentversion\policies\explorer"      , "NoCloseDragDropBands"   , "DWord", "1"),
    @("software\microsoft\windows\currentversion\policies\explorer"      , "NoMovingBands"          , "DWord", "1"),
    @("software\microsoft\windows\currentversion\policies\explorer"      , "NoActiveDesktop"        , "DWord", "1"),
    @("software\microsoft\windows\currentversion\policies\activedesktop" , "NoChangingWallPaper"    , "DWord", "1"),
    @("software\policies\microsoft\windows\personalization"              , "NoChangingMousePointers", "DWord", "1")
)

Edit-RegistriesMachine -Regs $regsMachine
Edit-RegistriesUser -UserName "student" -Regs $regsUser
Edit-RegistriesUser -UserName "teacher" -Regs $regsUser
