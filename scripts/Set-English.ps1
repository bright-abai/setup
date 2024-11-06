$studentName = (Get-LocalUser | Where-Object { $_.Name -like 'ST-*' } | Select-Object -ExpandProperty Name)

$english = Get-InstalledLanguage | Where-Object { $_.LanguageId -eq "en-US"}
if ($english.Count -eq 0) {
    Install-Language en-US
}

Set-WinSystemLocale -SystemLocale en-US
Set-SystemPreferredUILanguage en-US
Set-WinUILanguageOverride
Set-WinDefaultInputMethodOverride -InputTip "0409:00000409"

. "$PSScriptRoot\LibEdit-Registries.ps1"

$regs = @(
    @("control panel\international", "Locale"    , "String", "0409"),
    @("control panel\international", "LocaleName", "String", "en-US")
)
Edit-RegistriesUser -Username $studentName -Regs $regs
Edit-RegistriesUser -Username "Admin" -Regs $regs