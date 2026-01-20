# For each student Windows machine

1. Download and install [OpenSSH](https://github.com/bright-abai/setup/blob/main/files/OpenSSH-Win64-v10.0.0.0.msi)
2. Download and run as administrator [server_setup](https://github.com/bright-abai/setup/blob/main/scripts/windows/ssh_server.bat) and [public_key_xxx](https://github.com/bright-abai/setup/blob/main/scripts/windows/ssh_104.bat) (the public key should be modified for each situation)
3. Download and copy to `C:\Control` [firefox_blacklist_update](https://github.com/bright-abai/setup/blob/main/scripts/windows/Apply_BlockFromGithub.ps1)
4. Perform Registry change using `Apply-Wallpaper.ps1` and `Disable_ChangeSettings`


# Misc

```
notepad C:\Users\teacher\.ssh\authorized_keys & icacls "C:\Users\teacher\.ssh" /inheritance:r /grant teacher:F & icacls "C:\Users\teacher\.ssh\authorized_keys" /inheritance:r /grant teacher:F
```

```
wmic UserAccount where Name='ST-!suffix!' set PasswordExpires=False
```


# Manual setup of port 2222 on dual boot machine on Win10
```
notepad C:\ProgramData\ssh\sshd_config & New-NetFirewallRule -DisplayName "SSH Port 2222" -Direction Inbound -LocalPort 2222 -Protocol TCP -Action Allow
```
Change `Port 22` to `Port 2222`
```
Rename-LocalUser -Name "Admin" -NewName "teacher"  ; net stop sshd ; net start sshd
```

