#Set-ExecutionPolicy -ExecutionPolicy Bypass

param(
    [Parameter(Mandatory = $true)] [string]$cabinet,
    [Parameter(Mandatory = $true)] [int]$count
)

$files = "*.ps1 bright.jpg -r numbers"
$destination = "C:/Temp/"

$runspacePool = [runspacefactory]::CreateRunspacePool(1, 20) # Adjust max threads as needed
$runspacePool.Open()
$runspaces = @()

for ($student = 1; $student -le $count; $student++) {
    $remote = "Admin@ST-${cabinet}-${student}:${destination}"
    $scriptBlock = {
        param ($files, $remote)
        $scpCommand = "scp $files $remote"
        Invoke-Expression $scpCommand
    }
    $runspace = [powershell]::Create().AddScript($scriptBlock).AddArgument($files).AddArgument($remote)
    $runspace.RunspacePool = $runspacePool
    $runspaces += [pscustomobject]@{ Pipe = $runspace; Status = $runspace.BeginInvoke() }
}

# Monitor runspace completion
while ($runspaces.Status -contains $true) {
    Start-Sleep -Milliseconds 500
    foreach ($runspace in $runspaces) {
        if ($runspace.Status.IsCompleted) {
            $runspace.Pipe.EndInvoke($runspace.Status)
            $runspace.Pipe.Dispose()
            $runspaces = $runspaces | Where-Object { $_.Status.IsCompleted -eq $false }
        }
    }
}

# Close the runspace pool
$runspacePool.Close()
$runspacePool.Dispose()
