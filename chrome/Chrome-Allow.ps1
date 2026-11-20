$base = "HKLM:\SOFTWARE\Policies\Google\Chrome"
New-Item -Path $base -Force | Out-Null

function Set-Dword($name, $value) {
    Set-ItemProperty -Path $base -Name $name -Value $value -Type DWord
}
function Set-Str($name, $value) {
    Set-ItemProperty -Path $base -Name $name -Value $value -Type String
}
function Remove-Policy($name) {
    Remove-ItemProperty -Path $base -Name $name -Force -ErrorAction SilentlyContinue
}

# Profiles
Remove-Policy "ForceEphemeralProfiles"  1
Remove-Policy "PasswordManagerEnabled"  0
Remove-Policy "BrowserSignin"           0 
Remove-Policy "BrowserAddPersonEnabled"            0
Remove-Policy "BrowserGuestModeEnabled"            0
Remove-Policy "ProfilePickerOnStartupAvailability" 1

# --- Passwords: allowed ---
Remove-Policy "PasswordManagerEnabled"

# --- New tab page: cards visible, custom backgrounds allowed ---
Remove-Policy "NTPCardsVisible"             
Remove-Policy "NTPCustomBackgroundEnabled"  

# --- Extensions: allow all ---
Remove-Policy "ExtensionSettings"

Write-Host "Chrome policies removed. Open chrome://policy and click 'Reload policies'." -ForegroundColor Green