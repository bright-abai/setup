function Load-Username {
    param (
        [string]$username
    )

    $sid = (New-Object System.Security.Principal.NTAccount($username)).Translate([System.Security.Principal.SecurityIdentifier]).Value
    $loaded = $false

    if (-not (Test-Path Registry::HKEY_USERS\$sid)) {
        reg load "HKEY_USERS\$username" "C:\Users\$username\NTUSER.DAT"
        $sid = $username
        $loaded = $true
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

    if (-not (Test-Path $path)) {
        New-Item -Path $path -Force 1>$null
    }

    try {
        $current = Get-ItemProperty -Path $path -Name $prop -ErrorAction Stop
        Set-ItemProperty -Path $path -Name $prop -Value $value 1>$null
        Write-Host "Property $prop at $path updated for $username with $value, replacing $($current.$prop)"
    
    } catch {
        New-ItemProperty -Path $path -Name $prop -Value $value -PropertyType $type 1>$null
        Write-Host "Property $prop at $path created for $username with $value."
    }
}

# 0 - path
# 1 - property
# 2 - type
# 3 - value

function Edit-RegistriesUser {
    param(
        [string]$username,
        [string[][]]$regs
    )
    
    $sid = Load-Username -Username $username
    foreach ($reg in $regs) {
        Edit-Registry -Path "HKU\$sid[0]\$($reg[0])" -Prop $reg[1] -Type $reg[2] -Value $reg[3]
    }
    
    if ($sid[1]) {
        reg unload
    }
}

function Edit-RegistriesMachine {
    param(
        [string[][]]$regs
    )
    foreach ($reg in $regs) {
        Edit-Registry -Path $reg[0] -Prop $reg[1] -Type $reg[2] -Value $reg[3]
    }
}
