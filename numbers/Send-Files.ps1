#Set-ExecutionPolicy -ExecutionPolicy Bypass

param(
    [Parameter(Mandatory = $true)] [string]$cabinet,
    [Parameter(Mandatory = $true)] [string]$count
)

$files = "*.ps1 bright.jpg -r numbers"
$destination = "\C:\Temp\"

$jobs = @()
for ($student = 0; $student -le $count; $i++) {
    $remote = Admin@${cabinet}-${student}:${destination}
    $jobs += Start-Job -ScriptBlock {
        param ($files, $remote)
        $scpCommand = "scp $files $remote"
        Invoke-Expression $scpCommand
    } -ArgumentList $files, $remote
    $scpCommand = "scp $files $remote"
    Invoke-Expression $scpCommand
}

$jobs | ForEach-Object { $_ | Wait-Job | Receive-Job }
$jobs | ForEach-Object { Remove-Job -Job $_ }

Pause
