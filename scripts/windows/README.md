# For each student Windows machine

1. Copy bat/hosts to C:\Windows\System32\drivers\etc\
2. Run bat/sshserver.bat
3. Run bat/ssh_[104 or 106].bat




# Manual setup of port 2222 on dual boot machine on Win10
```
notepad C:\ProgramData\ssh\sshd_config & New-NetFirewallRule -DisplayName "SSH Port 2222" -Direction Inbound -LocalPort 2222 -Protocol TCP -Action Allow
```
Change `Port 22` to `Port 2222`
```
Rename-LocalUser -Name "Admin" -NewName "teacher"  ; net stop sshd ; net start sshd
```

# auth keys
1. Manually Copy the Public Key to the Target Windows Machine
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgqenzvSp5q3Riv7kguB86krzHMWROfxGj/nnxlH884 teacher@TR-104
```
```
notepad C:\Users\teacher\.ssh\authorized_keys & icacls "C:\Users\teacher\.ssh" /inheritance:r /grant teacher:F & icacls "C:\Users\teacher\.ssh\authorized_keys" /inheritance:r /grant teacher:F
```