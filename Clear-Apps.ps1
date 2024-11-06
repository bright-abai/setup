$whitelist = @(
    "Microsoft Windows Terminal",    # Example app name to keep
    "Microsoft Edge",                # Another example app to keep
    "C:\Program Files\SomeApp",      # Path to folder to keep
    "C:\Program Files (x86)\AnotherApp" # Another folder to keep
)

function Uninstall-App {
    param (
        [string]$appName,
        [string]$uninstallString
    )
    
    try {
        # Ask the user for confirmation before proceeding with uninstallation
        $confirmation = Read-Host "Do you want to uninstall '$appName'? (Y/N)"
        
        if ($confirmation -match '^[Yy]$') {
            Write-Host "Uninstalling app: $appName"
            
            if ($uninstallString) {
                # Run the uninstall command
                Start-Process -FilePath $uninstallString -ArgumentList "/quiet", "/uninstall" -Wait
                Write-Host "$appName has been uninstalled."
            } else {
                Write-Host "No uninstall string found for $appName. Skipping..."
            }
        } else {
            Write-Host "Skipping uninstallation of $appName."
        }
    } catch {
        Write-Host "Error uninstalling ${appName}: $_"
    }
}


Write-Host "Checking installed applications..."
$installedApps = Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" |
                 Where-Object { $_.GetValue("DisplayName") -and $_.GetValue("UninstallString") }

if (Test-Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") {
    $installedApps += Get-ChildItem -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" |
                     Where-Object { $_.GetValue("DisplayName") -and $_.GetValue("UninstallString") }
}

foreach ($app in $installedApps) {
    $appName = $app.GetValue("DisplayName")
    $uninstallString = $app.GetValue("UninstallString")
    
    if ($whitelist -notcontains $appName -and $whitelist -notcontains $app.PSPath) {
        Uninstall-App -appName $appName -uninstallString $uninstallString
    } else {
        Write-Host "Skipping whitelisted app: $appName"
    }
}

Write-Host "Uninstallation process complete!"
