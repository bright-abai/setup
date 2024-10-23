function Edit-Registry {
    param (
        [string]$path,
        [string]$prop,
        [string]$value,
        [string]$type
    )

    try {
        $current = Get-ItemProperty -Path $path -Name $prop -ErrorAction Stop
        Set-ItemProperty -Path $path -Name $prop -Value $value
        Write-Host "Property $prop at $path updated for $username with $value, replacing $($current.$prop)"
    
    } catch {
        New-ItemProperty -Path $path -Name $prop -Value $value -PropertyType $type
        Write-Host "Property $prop at $path created for $username with $value."
    }

    Write-Host "Completed"
}

# Define the user SID and registry path
$username = "ST-20"
$userSID = (Get-LocalUser -Name $username).SID

Edit-Registry -path "Registry::HKEY_USERS\$userSID\software\microsoft\windows\currentVersion\policies\system" -prop "Wallpaper" -value "C:\Users\Admin\Pictures\numbers\22.jpg" -type  "String"
