param (
    [Parameter(Mandatory = $true)] [string]$username
)

. "$PSScriptRoot\LibEditRegistries.ps1"

$paths = @(
    "HKLM:\software\microsoft\policymanager\default\settings"                  # 01.
    , "HKCU:\software\microsoft\windows\currentversion\policies\system"        # 02.
    , "HKCU:\software\microsoft\windows\currentversion\policies\system"        # 03.
    , "HKCU:\software\microsoft\windows\currentversion\policies\system"        # 04.
    , "HKCU:\software\microsoft\windows\currentversion\policies\explorer"      # 05.
    , "HKCU:\software\microsoft\windows\currentversion\policies\explorer"      # 06.
    , "HKCU:\software\microsoft\windows\currentversion\policies\explorer"      # 07.
    , "HKCU:\software\microsoft\windows\currentversion\policies\explorer"      # 08.
    , "HKCU:\software\microsoft\windows\currentversion\policies\explorer"      # 09.
    , "HKCU:\software\microsoft\windows\currentversion\policies\activedesktop" # 10.
    , "HKCU:\software\policies\microsoft\windows\personalization"              # 11.

)
$props = @(
    "AllowLanguage"              # 01. settings
    , "NoDispAppearancePage"     # 02. system
    , "NoDispBackgroundPage"     # 03. system
    , "NoColorChoice"            # 04. system
    , "NoThemesTab"              # 05. explorer
    , "NoDesktop"                # 06. explorer
    , "NoCloseDragDropBands"     # 07. explorer Toolbar
    , "NoMovingBands"            # 08. explorer Toolbar
    , "NoActiveDesktop"          # 09. explorer (active desktop is not needed featuer, but no changing wallpaper is located under it)
    , "NoChangingWallPaper"      # 10. activedesktop
    , "NoChangingMousePointers"  # 11. personalization

)
$types = @(
    "DWord"     # 01. settings
    , "DWord"   # 02. system
    , "DWord"   # 03. system
    , "DWord"   # 04. system
    , "DWord"   # 05. explorer
    , "DWord"   # 06. explorer
    , "DWord"   # 07. explorer
    , "DWord"   # 08. explorer
    , "DWord"   # 09. explorer
    , "DWord"   # 10. activedesktop
    , "DWord"   # 11. personalization

)
$vals  = @(
    1   # 01. AllowLanguage settings
    , 0 # 02. system
    , 0 # 03. system
    , 0 # 04. system
    , 0 # 05. explorer
    , 0 # 06. explorer
    , 0 # 07. explorer
    , 0 # 08. explorer
    , 0 # 09. explorer
    , 0 # 10. activedesktop
    , 0 # 11. personalization
)

EditRegitries -username $username -path $paths -prop $props -type $types -val $vals