# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as an administrator."
    Pause
    exit 1
}

. "$PSScriptRoot\LibEdit-Registries.ps1"

$regsMachine = @(
    @("HKLM:\software\microsoft\policymanager\default\settings\allowlanguage", "value"               , "DWord", "1"),
    @("HKLM:\software\policies\microsoft\windows\personalization"            , "NoChangingLockScreen", "DWord", "0")
)

$regsUser = @(
    @("software\microsoft\windows\currentversion\policies\system"        , "NoDispAppearancePage"   , "DWord", "0"),
    @("software\microsoft\windows\currentversion\policies\system"        , "NoDispBackgroundPage"   , "DWord", "0"),
    @("software\microsoft\windows\currentversion\policies\system"        , "NoColorChoice"          , "DWord", "0"),
    @("software\microsoft\windows\currentversion\policies\explorer"      , "NoThemesTab"            , "DWord", "0"),
    @("software\microsoft\windows\currentversion\policies\explorer"      , "NoDesktop"              , "DWord", "0"),
    @("software\microsoft\windows\currentversion\policies\explorer"      , "NoCloseDragDropBands"   , "DWord", "0"),
    @("software\microsoft\windows\currentversion\policies\explorer"      , "NoMovingBands"          , "DWord", "0"),
    @("software\microsoft\windows\currentversion\policies\explorer"      , "NoActiveDesktop"        , "DWord", "0"),
    @("software\microsoft\windows\currentversion\policies\explorer")     , "NoSettaskbar"           , "DWord", "0"),
    @("software\microsoft\windows\currentversion\policies\activedesktop" , "NoChangingWallPaper"    , "DWord", "0"),
    @("software\policies\microsoft\windows\personalization"              , "NoChangingMousePointers", "DWord", "0"),
    @("software\policies\microsoft\windows\explorer"                     , "NoPinningToTaskbar"     , "DWord", "0")
)

Edit-RegistriesMachine -Regs $regsMachine
Edit-RegistriesUser -UserName "student" -Regs $regsUser
Edit-RegistriesUser -UserName "teacher" -Regs $regsUser

Edit-RegistriesUser -UserName "student" -Regs @(@("software\microsoft\windows\currentversion\policies\explorer", "NoControlPanel", "DWord", "0"), "")
