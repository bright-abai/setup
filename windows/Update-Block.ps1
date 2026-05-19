for ($i = 101; $i -le 123; $i++) {
    Write-Host "Current loop index is ${i}"
    ssh teacher@192.168.104.${i} powershell C:\Control\Whitelist.ps1
}