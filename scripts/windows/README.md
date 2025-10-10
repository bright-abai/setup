# For each student Windows machine

1. Apply policies.json to firefox, so no other browser is installed and it is not possible to download a new one
2. Run ssh_server.bat
3. Run ssh_[104 or 106].bat
4. Run Apply-Wallpaper.ps1 with powershell, supplying a student image to set
5. Run Disable-ChangeSettings.ps1



# Manual setup of port 2222 on dual boot machine on Win10
```
notepad C:\ProgramData\ssh\sshd_config & New-NetFirewallRule -DisplayName "SSH Port 2222" -Direction Inbound -LocalPort 2222 -Protocol TCP -Action Allow
```
Change `Port 22` to `Port 2222`
```
Rename-LocalUser -Name "Admin" -NewName "teacher"  ; net stop sshd ; net start sshd
```

# Misc

```
notepad C:\Users\teacher\.ssh\authorized_keys & icacls "C:\Users\teacher\.ssh" /inheritance:r /grant teacher:F & icacls "C:\Users\teacher\.ssh\authorized_keys" /inheritance:r /grant teacher:F
```

```
wmic UserAccount where Name='ST-!suffix!' set PasswordExpires=False
```