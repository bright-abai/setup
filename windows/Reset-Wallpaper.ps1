function Remove-Registry {
    param (
        [string]$path,
        [string]$prop
    )
    if (Test-Path $path) {
        if ($prop) {
            Remove-ItemProperty -Path $path -Name $prop -ErrorAction SilentlyContinue
            Write-Host "Removed property $prop from $path"
        } else {
            Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "Removed key path $path"
        }
    }
}

function Remove-RegistriesUser {
    param(
        [string]$username,
        [string[]]$propsToRemove # Just the names of the properties to delete
    )  
    $userProfile = Get-WmiObject -Class Win32_UserProfile | Where-Object { $_.LocalPath -like "*\$username" }
    if (-not $userProfile) { throw "User $username not found" }
    $sid = $userProfile.SID
    
    $loadedHive = $false
    if (-not (Test-Path "Registry::HKEY_USERS\$sid")) { 
        $fileHive = "C:\Users\$username\NTUSER.DAT"
        reg load "HKU\$sid" $fileHive
        $loadedHive = $true
    }

    $policyPath = "Registry::HKEY_USERS\$sid\Software\Microsoft\Windows\CurrentVersion\Policies\System"
    
    foreach ($prop in $propsToRemove) {
        Remove-Registry -path $policyPath -prop $prop
    }

    if ($loadedHive) { 
        [GC]::Collect() # Ensure handle is released
        reg unload "HKU\$sid" 
    }
}

Remove-RegistriesUser -username "student" -propsToRemove @("Wallpaper", "WallpaperStyle")
Write-Host "Registry changes undone. Users can now change their own backgrounds."
