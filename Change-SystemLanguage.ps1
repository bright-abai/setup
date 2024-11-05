# Set system language to English (en-US)
Write-Host "Changing system language to English (en-US)..."

# Set the display language to English (US)
Set-WinUILanguageOverride -Language en-US

# Set the input method for the language (Optional: you can change to other languages if needed)
Set-WinDefaultInputMethodOverride -InputTip "0409:00000409"  # English (US)

# Set the system locale
Set-WinSystemLocale en-US

# Optionally, you can reboot the system to apply language changes
Write-Host "Rebooting system to apply language settings..."
Restart-Computer -Force