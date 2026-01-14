# Turn off all computers
## 104
```
for i in {1..23}; do ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no teacher@192.168.104.$i "sudo shutdown -h now" & done
```
## 106
```
for i in {1..22}; do ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no teacher@192.168.106.$i "sudo shutdown -h now" & done
```
## block update script
```
$url = "https://raw.githubusercontent.com/bright-abai/setup/main/scripts/blacklist_policies.json"
$firefoxPath = "C:\Program Files\Mozilla Firefox\distribution"
$destFile = Join-Path $firefoxPath "policies.json"
Invoke-WebRequest -Uri $url -OutFile $destFile
Write-Host "Policy file installed to $destFile"
```
