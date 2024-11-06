$whitelist = @(
    "Microsoft*"
    , "*Windows*"
    , "Intel*"
    , "AMD*"
    , "Apple*"
    , "Mozilla*"
    , "Branding64" # Some AMD program

    # If need to whitelist the path, uncomment check for $uninstallString
    # "C:\Windows\*"
    # "C:\PROGRA~1\DIFX\*"
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

function Clear-Apps {
    param (
        [string[]]$whitelist,
        [bool]$dryRun
    )

    $installedApps = Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" |
                 Where-Object { $_.GetValue("DisplayName") -and $_.GetValue("UninstallString") }

    if (Test-Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") {
        $installedApps += Get-ChildItem -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" |
                        Where-Object { $_.GetValue("DisplayName") -and $_.GetValue("UninstallString") }
    }

    foreach ($app in $installedApps) {
        $uninstall = $true
        $appName = $app.GetValue("DisplayName")
        $uninstallString = $app.GetValue("UninstallString")
        foreach ($item in $whitelist) {
            if ($appName -like $item) { # -or $uninstallString -like $item) {
                $uninstall = $false
            }
        }
        if ($uninstall) {
            if ($dryRun) {
                Write-Host "DELETE: $appName`n $uninstallString"
            }
            else {
                try {
                    Write-Host "Uninstalling $appName"
                    Start-Process -FilePath $uninstallString -ArgumentList "/quiet", "/uninstall" -Wait
                } catch {
                    Write-Error "Failed to uninstalll $appName"
                }
            }
        }
        else {
            if ($dryRun) {
                Write-Host "SKIP: $appName`n"
            }
        }
    }

    Write-Host "Uninstallation process complete!"
}

Clear-Apps -WhiteList $whitelist -DryRun $true