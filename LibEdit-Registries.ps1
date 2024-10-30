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
        try{ 
            New-ItemProperty -Path $path -Name $prop -Value $value -PropertyType $type -ErrorAction Stop -Force 1>$null  
        } catch { 
            throw "new itemprop fail, $path, $prop"
        }
        
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
    $fileHive = "C:\Users\$username\NTUSER.DAT"
    $regHiveLoad = "HKU\$username"
    $regHiveEdit = "registry::HKEY_USERS:\$username"

    if (-Not (Test-Path $fileHive)) { throw "Failed to find $fileHive" }

    reg load $regHiveLoad $fileHive
    if ($LASTEXITCODE -ne 0) { throw "Failed to load regHive $regHiveLoad $fileHive" }
    if (-Not (Test-Path $regHiveLoad)) { throw "Failed to find $regHiveLoad" }
    
    foreach ($reg in $regs) {
        Edit-Registry -Path "$regHiveEdit\$($reg[0])" -Prop $reg[1] -Type $reg[2] -Value $reg[3]
    }
    
    reg unload $regHiveLoad 
    if ($LASTEXITCODE -ne 0) { throw "Failed to unload regHive" }
}

function Edit-RegistriesMachine {
    param(
        [string[][]]$regs
    )
    foreach ($reg in $regs) {
        Edit-Registry -Path $reg[0] -Prop $reg[1] -Type $reg[2] -Value $reg[3]
    }
}
