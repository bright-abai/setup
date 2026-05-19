# Load the Windows Media assembly to support MP3 playback
Add-Type -AssemblyName presentationCore

$LessonEnds = @("09:40", "9:58", "10:30", "10:45", "11:35", "12:25", "13:15", "13:55", "14:45", "15:35")
$Today = (Get-Date).ToString("yyyy-MM-dd")

foreach ($Time in $LessonEnds) {
    $EndDateTime = [datetime]::ParseExact("$Today $Time", "yyyy-MM-dd HH:mm", $null)
    
    $TargetTime = $EndDateTime.AddMinutes(-1).AddSeconds(-25)
    $TimeDifference = ($TargetTime - (Get-Date)).TotalSeconds

    if ($TimeDifference -le 0) {
        continue
    }

    Start-Sleep -Seconds $TimeDifference
    
    $player = New-Object System.Windows.Media.MediaPlayer
    $player.Open("C:\Control\files\End Times.mp3") 
    
    $player.Play()
    Start-Sleep -Seconds 85
    $player.Stop()
    $player.Close()
}
