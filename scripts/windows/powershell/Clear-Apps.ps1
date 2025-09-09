$whitelist = @(
    "Microsoft*"
    , "*Windows*"
    , "Intel*"
    , "AMD*"
    , "Apple*"
    , "Mozilla*"
    , "Google Chrome*"
    , "Python*"
    , "Arduino*"
    , "*Microsoft Edge*"
    , "X-Mouse Button*"
    , "*Java*"
    , "*Discord*"
    , "Branding64" # Some AMD program

    # If need to whitelist the path, uncomment check for $uninstallString
    # "C:\Windows\*"
    # "C:\PROGRA~1\DIFX\*"
)

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
                Write-Host "CAN DELETE: $appName`n $uninstallString"
            }
            else {
                try {
                    Write-Host "Uninstalling $appName with $uninstallString"
                    Start-Process "$uninstallString" -ArgumentList "/s"
                    Start-Sleep -Seconds 3
                } catch {
                    Write-Error "Failed to uninstalll $appName"
                }
            }
        }
        else {
            if ($dryRun) {
                #Write-Host "SKIP: $appName`n"
            }
        }
    }

    Write-Host "Uninstalled apps"
}

function Clear-Downloads {
    $studentName = (Get-LocalUser | Where-Object { $_.Name -like 'ST-*' } | Select-Object -ExpandProperty Name)
    Get-ChildItem -Path "C:\Users\Admin\Downloads" -Recurse | Remove-Item -Force -Recurse
    Get-ChildItem -Path "C:\Users\$studentName\Downloads" -Recurse | Remove-Item -Force -Recurse

    Write-Host "Downloads folder cleared"
}

function Clear-Desktop {
    $studentName = (Get-LocalUser | Where-Object { $_.Name -like 'ST-*' } | Select-Object -ExpandProperty Name)
    Get-ChildItem -Path "C:\Users\Admin\Desktop" -Recurse | Where-Object { $_.Extension -ne '.lnk' } | Remove-Item -Force -Recurse
    Get-ChildItem -Path "C:\Users\$studentName\Desktop" -Recurse | Where-Object { $_.Extension -ne '.lnk' } | Remove-Item -Force -Recurse
    
    Write-Host "Desktop folders cleared, except shortcuts"
}

function Clear-VolumeD {
    if (Test-Path -Path "D:\") {
        Write-Host "D: drive found. Deleting all contents..."
        Get-ChildItem -Path $drivePath -Recurse -Force | Remove-Item -Force -Recurse
        Write-Host "All contents of D: have been deleted."
    } else {
        Write-Host "D: drive does not exist."
    }
}

Clear-Apps -WhiteList $whitelist -DryRun $true
Clear-Downloads
#Clear-Desktop
Clear-VolumeD