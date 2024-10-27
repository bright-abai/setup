param (
    [Parameter(Mandatory = $true)] [string]$username
)

. "$PSScriptRoot\LibEditRegistries.ps1"

$paths = @(
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\Settings",
)
$props = @(
    "AllowLanguage",
)
$types = @(
    "DWord",
)
$vals  = @(
    0,
)

EditRegitries -username $username -path $paths -prop $props -type $types -val $vals