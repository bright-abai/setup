function Load-Username {
    param (
        [string]$username
    )

    $sid = (New-Object System.Security.Principal.NTAccount($username)).Translate([System.Security.Principal.SecurityIdentifier]).Value
    $loaded = $false

    if (-not (Test-Path Registry::HKEY_USERS\$sid)) {
        reg load "HKEY_USERS\$username" "C:\Users\$username\NTUSER.DAT"
        $sid = $username
        $loaded = true
    } 

    return @($sid, $loaded)
}

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
}

function Edit-Registries {
    param(
        [string]$username
        [string[]]$path
        [string[]]$prop
        [string[]]$type
        [string[]]$val
    )
    
    $sid = Load-Username -username $username
    for ($i = 0; $i -lt $path.Length; $i++) {
        Edit-Registry -path $($path[$i]) -prop $($prop[$i]) -value $($val[$i]) -type $($type[$i])"
    }
    
    if ($sid[1]) {
        reg unload
    }
}
