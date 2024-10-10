### OpenSSH server
### [1NFBW8TP](https://pastebin.com/raw/1NFBW8TP)

##### Server (Student):

```
Get-WindowsCapability -Online | Where-Object Name -like ‘OpenSSH.Server*’ | Add-WindowsCapability –Online ; New-NetFirewallRule -Name "OpenSSH Server (sshd)" -DisplayName "OpenSSH Server (sshd)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 ; Set-Service -Name sshd -StartupType 'Automatic' ;  Start-Service sshd

```

1. Login to admin on server:
```
cd $env:USERPROFILE; mkdir .ssh; cd .ssh; New-Item authorized_keys ; code .
```
- Click "Disable inheritance";
- Choose "Convert inherited permissions into explicit permissions on this object" when prompted;
- Only two entries should be left
- Remove match group from config:
```
`C:\ProgramData\ssh\sshd_config`
```
##### Client (Teacher) 
```
Get-WindowsCapability -Online | Where-Object Name -like ‘OpenSSH.Server*’ | Add-WindowsCapability –Online ; Set-Service -Name ssh-agent -StartupType 'Automatic'; Start-Service ssh-agent; ssh-keygen -t ed25519 ; ssh-add C:\Users\Abai\.ssh\id_ed25519 ; Get-Content $HOME\.ssh\id_ed25519.pub
```

###### Check

```
netstat -na| find ":22"

Get-NetFirewallRule -Name *OpenSSH-Server* |select Name, DisplayName, Description, Enabled
```
### Public key

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICtinTMwQpzpT9POUllaAGapJK231Btp5zKPug1KY+fL abai@TR-104
```


