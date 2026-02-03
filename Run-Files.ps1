for ($i = 101; $i -le 123; $i++) {
    # ssh teacher@192.168.104.$i "powershell C:\Control\Disable-ChangeSettings.ps1"
    # ssh teacher@192.168.104.$i "powershell C:\Control\Apply-BlockFromGithub.ps1"
    # ssh teacher@192.168.104.$i "powershell C:\Control\Block-OtherBrowsers.ps1"
    ssh teacher@192.168.104.$i "powershell Remove-Item -Path "C:\Users\student\Downloads\*" -Recurse -Force -ErrorAction SilentlyContinue"
}