$gameKeywords = @(
    "Minecraft",
    "Roblox",
    "Counter-Strike"
)

# Define common game installation directories
$gameDirectories = @(
    "C:\Program Files",
    "C:\Program Files (x86)",
    "C:\ProgramData",
    "$env:USERPROFILE\Documents\My Games"
)

# Loop through each game directory
foreach ($dir in $gameDirectories) {
    if (Test-Path $dir) {
        $games = Get-ChildItem -Path $dir -Recurse -ErrorAction SilentlyContinue | Where-Object { 
            $_.PSIsContainer -and ($_.Name -like "*$($gameKeywords -join '*')*") 
        }
        
        foreach ($game in $games) {
            $gameFolder = $($game.FullName)
            Write-Host "Found game directory: $gameFolder"
            
            # Attempt to locate an uninstaller if available
            $uninstallPath = Join-Path $gameFolder "uninstall.exe"
            if (Test-Path $uninstallPath) {
                try { & cmd.exe /c $uninstallPath ; Write-Host "Successfully uninstalled: $uninstallPath"} 
                catch { Write-Host "Failed to uninstall: $uninstallPath - $_" }
            } else {
                Write-Host "No uninstaller found for: $($game.Name)"
                $confirmation = Read-Host "Are you sure you want to delete the folder '$folderPath'? (Y/N)"
    
                if ($confirmation -eq 'Y' -or $confirmation -eq 'y') {
                    Remove-Item -Path $gameFolder -Recurse -Force
                    Write-Host "The folder '$gameFolder' has been deleted."
                } else {
                    Write-Host "Operation canceled. The folder '$gameFolder' was not deleted."
                }
            }
        }
    }
}
