param (
    [Parameter(Mandatory = $true)] [string]$username
)

. "$PSScriptRoot\LibEditRegistries.ps1"

$regs = @(
    @("HKLM:\software\microsoft\policymanager\default\settings"                , "AllowLanguage"          , "DWord", "1"),
    @("HKCU:\software\microsoft\windows\currentversion\policies\system"        , "NoDispAppearancePage"   , "DWord", "0"),
    @("HKCU:\software\microsoft\windows\currentversion\policies\system"        , "NoDispBackgroundPage"   , "DWord", "0"),
    @("HKCU:\software\microsoft\windows\currentversion\policies\system"        , "NoColorChoice"          , "DWord", "0"),
    @("HKCU:\software\microsoft\windows\currentversion\policies\explorer"      , "NoThemesTab"            , "DWord", "0"),
    @("HKCU:\software\microsoft\windows\currentversion\policies\explorer"      , "NoDesktop"              , "DWord", "0"),
    @("HKCU:\software\microsoft\windows\currentversion\policies\explorer"      , "NoCloseDragDropBands"   , "DWord", "0"),
    @("HKCU:\software\microsoft\windows\currentversion\policies\explorer"      , "NoMovingBands"          , "DWord", "0"),
    @("HKCU:\software\microsoft\windows\currentversion\policies\explorer"      , "NoActiveDesktop"        , "DWord", "0"),
    @("HKCU:\software\microsoft\windows\currentversion\policies\activedesktop" , "NoChangingWallPaper"    , "DWord", "0"),
    @("HKCU:\software\policies\microsoft\windows\personalization"              , "NoChangingMousePointers", "DWord", "0"),
)

Edit-Regitries -Username $username -Regs $regs