param(
    [Parameter(Mandatory=$true)]
    [string]$Domain,
    
    [Parameter(Mandatory=$false)]
    [string]$PolicyFile = "C:\Program Files\Mozilla Firefox\distribution\policies.json"
)

# Check for administrator privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Error "This script requires administrator privileges. Please run PowerShell as Administrator."
    exit 1
}

# Check if the policy file exists
if (-not (Test-Path $PolicyFile)) {
    Write-Error "Policy file not found: $PolicyFile"
    exit 1
}

try {
    # Create backup of the original file
    $backupFile = "$PolicyFile.backup"
    Copy-Item $PolicyFile $backupFile -Force
    Write-Host "Backup created: $backupFile" -ForegroundColor Yellow
    
    # Read the JSON file
    $jsonContent = Get-Content $PolicyFile -Raw | ConvertFrom-Json
    
    # Create the blocked URL pattern
    $blockedPattern = "*://*.$Domain/*"
    
    # Check if the pattern already exists
    if ($jsonContent.policies.WebsiteFilter.Block -contains $blockedPattern) {
        Write-Warning "The domain '$Domain' is already blocked."
        exit 0
    }
    
    # Add the new blocked pattern to the array
    $jsonContent.policies.WebsiteFilter.Block += $blockedPattern
    
    # Sort the blocked list to keep it organized
    $jsonContent.policies.WebsiteFilter.Block = $jsonContent.policies.WebsiteFilter.Block | Sort-Object
    
    # Convert back to JSON with proper formatting
    $jsonOutput = $jsonContent | ConvertTo-Json -Depth 10
    
    # Save the updated JSON back to the file
    $jsonOutput | Set-Content $PolicyFile -Encoding UTF8
    
    Write-Host "Successfully added block for: $blockedPattern" -ForegroundColor Green
    Write-Host "Total blocked sites: $($jsonContent.policies.WebsiteFilter.Block.Count)" -ForegroundColor Cyan
    
} catch {
    Write-Error "An error occurred: $_"
    exit 1
}
