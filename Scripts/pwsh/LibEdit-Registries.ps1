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
        [string]$type,
        [string]$value
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

# 0 - path
# 1 - property
# 2 - type
# 3 - value

function Edit-Registries {
    param(
        [string]$username
        [string[][]]$regs
    )
    
    $sid = Load-Username -Username $username
    for ($i = 0; $i -lt $regs.Length; $i++) {
        Edit-Registry -Path $regs[$i][0] -Prop $regs[$i][1] -Type $regs[$i][2] -Value $regs[$i][3]
    }
    
    if ($sid[1]) {
        reg unload
    }
}
