$studentName = (Get-LocalUser | Where-Object { $_.Name -like 'ST-*' } | Select-Object -ExpandProperty Name)
. "$PSScriptRoot\LibEdit-Registries.ps1"

$regs = @(
    @("control panel\international", "Locale"    , "String", "0409"),
    @("control panel\international", "LocaleName", "String", "en-US"),
    @("Software\Policies\Microsoft\Control Panel\Desktop", "MultiUILanguageID", "String", "00000409"),
    @("Software\Policies\Microsoft\Control Panel\Desktop", "PreferredUILanguages", "String", "en-US")
)

Edit-RegistriesUser -Username $studentName -Regs $regs
Edit-RegistriesUser -Username "Admin" -Regs $regs

$regs = @(
    @("HKLM:\Software\Policies\Microsoft\MUI\Settings", "MachineUILock", "DWord", 1), 
    @("HKLM:\system\CurrentControlSet\Control\Nls\Language", "InstallLanguage", "String", "0409"),
    @("HKLM:\system\CurrentControlSet\Control\Nls\Language", "InstallLanguageFallback", "String", "en-US")
)
Edit-RegistriesMachine -Regs $regs

# $en = "en-US"
# Set-WinUILanguageOverride -Language $en
# Set-WinDefaultInputMethodOverride -InputTip "0409:00000409"
# Set-WinUILanguageOverride -Language $en

# Set-WinSystemLocale $en
# Set-WinUserLanguageList $en -Force

# Set-SystemPreferredUILanguage en-US -PassThru