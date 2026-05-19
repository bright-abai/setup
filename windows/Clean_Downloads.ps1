for ($i = 115; $i -le 123; $i++) {
    # ssh teacher@192.168.104.${i} powershell
    # scp teacher@192.168.104.${i}:\C:\
    Write-Host "Current loop index is ${i}"
    ssh teacher@192.168.104.${i} powershell Remove-Item -Path "C:\Users\student\Downloads\*" -Recurse -Force
}