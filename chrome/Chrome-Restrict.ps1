$base = "HKLM:\SOFTWARE\Policies\Google\Chrome"
New-Item -Path $base -Force | Out-Null

function Set-Dword($name, $value) {
    Set-ItemProperty -Path $base -Name $name -Value $value -Type DWord
}
function Set-Str($name, $value) {
    Set-ItemProperty -Path $base -Name $name -Value $value -Type String
}


# Profiles
Set-Dword "ForceEphemeralProfiles"  1
Set-Dword "PasswordManagerEnabled"  0
Set-Dword "BrowserSignin"           0 
Set-Dword "BrowserAddPersonEnabled"            0
Set-Dword "BrowserGuestModeEnabled"            0
Set-Dword "ProfilePickerOnStartupAvailability" 1

# --- New tab page (FirefoxHome, wallpaper lock) ---
Set-Dword "NTPCardsVisible"             0
Set-Dword "NTPCustomBackgroundEnabled"  0

# --- Block all extensions (ExtensionSettings) ---
Set-Str "ExtensionSettings" '{"*":{"installation_mode":"blocked"}}'


Write-Host "Chrome policies applied. Open chrome://policy and click 'Reload policies'." -ForegroundColor Green
