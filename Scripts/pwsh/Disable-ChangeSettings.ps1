param (
    [Parameter(Mandatory = $true)] [string]$username
)

. "$PSScriptRoot\LibEdit-Registries.ps1"

$regs = @(
    @("HKLM:\software\microsoft\policymanager\default\settings"                , "AllowLanguage"          , "DWord", "0"),
    @("HKLM:\software\policies\microsoft\windows\personalization"              , "NoChangingLockScreen"   , "DWord", "1"),
    @("HKCU:\software\microsoft\windows\currentversion\policies\system"        , "NoDispAppearancePage"   , "DWord", "1"),
    @("HKCU:\software\microsoft\windows\currentversion\policies\system"        , "NoDispBackgroundPage"   , "DWord", "1"),
    @("HKCU:\software\microsoft\windows\currentversion\policies\system"        , "NoColorChoice"          , "DWord", "1"),
    @("HKCU:\software\microsoft\windows\currentversion\policies\explorer"      , "NoThemesTab"            , "DWord", "1"),
    @("HKCU:\software\microsoft\windows\currentversion\policies\explorer"      , "NoDesktop"              , "DWord", "1"),
    @("HKCU:\software\microsoft\windows\currentversion\policies\explorer"      , "NoCloseDragDropBands"   , "DWord", "1"),
    @("HKCU:\software\microsoft\windows\currentversion\policies\explorer"      , "NoMovingBands"          , "DWord", "1"),
    @("HKCU:\software\microsoft\windows\currentversion\policies\explorer"      , "NoActiveDesktop"        , "DWord", "1"),
    @("HKCU:\software\microsoft\windows\currentversion\policies\activedesktop" , "NoChangingWallPaper"    , "DWord", "1"),
    @("HKCU:\software\policies\microsoft\windows\personalization"              , "NoChangingMousePointers", "DWord", "1")
)

Edit-Registries -Username $username -Regs $regs
