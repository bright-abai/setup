### OpenSSH server

```
`Get-WindowsCapability -Online | Where-Object Name -like ‘OpenSSH.Server*’ | Add-WindowsCapability –Online`
```

```
New-NetFirewallRule -Name "OpenSSH Server (sshd)" -DisplayName "OpenSSH Server (sshd)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 ; Set-Service -Name sshd -StartupType 'Automatic' ;  Start-Service sshd

```

```
Get-WindowsCapability -Online | Where-Object Name -like ‘OpenSSH.Server*’ | Add-WindowsCapability –Online ; New-NetFirewallRule -Name "OpenSSH Server (sshd)" -DisplayName "OpenSSH Server (sshd)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 ; Set-Service -Name sshd -StartupType 'Automatic' ;  Start-Service sshd
```
###### Check

```
netstat -na| find ":22"

Get-NetFirewallRule -Name *OpenSSH-Server* |select Name, DisplayName, Description, Enabled
```


# enzFFTaS