$base = "HKLM:\SOFTWARE\Policies\Google\Chrome"

# Clear existing policies to avoid conflicts
foreach ($key in "URLBlocklist", "URLAllowlist") {
    Remove-Item -Path "$base\$key" -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -Path "$base\$key" -Force | Out-Null
}

Write-Host "Allowed all websites" -ForegroundColor Green