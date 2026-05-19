for ($i = 101; $i -le 123; $i++) {
    # scp teacher@192.168.104.${i}:\C:\
    # ssh teacher@192.168.104.${i} powershell
    Write-Host "Current loop index is ${i}"
    scp .\Word-DisableAutoSave.ps1 teacher@192.168.104.${i}:\C:\Control\
    ssh teacher@192.168.104.${i} powershell C:\Control\Word-DisableAutoSave.ps1
}