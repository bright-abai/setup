$url = "https://raw.githubusercontent.com/bright-abai/setup/main/firefox/whitelist_policies.json"
$firefoxPath = "C:\Program Files\Mozilla Firefox\distribution"
$destFile = Join-Path $firefoxPath "policies.json"
Invoke-WebRequest -Uri $url -OutFile $destFile
Write-Host "Policy file installed to $destFile"
