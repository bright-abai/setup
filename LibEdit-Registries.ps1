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
        Set-ItemProperty -Path $path -Name $prop -Value $value -Force 1>$null
        Write-Host "Property $prop at $path updated for $username with $value, replacing $($current.$prop)"
    
    } catch {
        New-ItemProperty -Path $path -Name $prop -Value $value -PropertyType $type -Force 1>$null
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
    
    reg load "HKEY_USERS\$username" "C:\Users\$username\NTUSER.DAT"

    foreach ($reg in $regs) {
        Edit-Registry -Path "HKU\$username\$($reg[0])" -Prop $reg[1] -Type $reg[2] -Value $reg[3]
    }
    
    reg unload "HKU\$username"

}

function Edit-RegistriesMachine {
    param(
        [string[][]]$regs
    )
    foreach ($reg in $regs) {
        Edit-Registry -Path $reg[0] -Prop $reg[1] -Type $reg[2] -Value $reg[3]
    }
}
