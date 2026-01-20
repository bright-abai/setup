# For each student Windows machine

1. Download and install [OpenSSH](https://github.com/bright-abai/setup/blob/main/files/OpenSSH-Win64-v10.0.0.0.msi)
2. Download and run as administrator [server_setup](https://github.com/bright-abai/setup/blob/main/scripts/windows/ssh_server.bat) and [public_key_xxx](https://github.com/bright-abai/setup/blob/main/scripts/windows/ssh_104.bat) (the public key should be modified for each situation)
3. Download and copy to `C:\Control` [firefox_blacklist_update](https://github.com/bright-abai/setup/blob/main/scripts/windows/Apply_BlockFromGithub.ps1)
4. Perform Registry change using `Apply-Wallpaper.ps1` and `Disable_ChangeSettings`

# On the teacher machine

1. `ssh-keygen -t ed25519` [^1] (no passphrase is advised, because there was one time when I mistyped the password twice)
2. `ssh-add C:\Users\Abai\.ssh\id_ed25519`
3. Run `ssh teacher@student-104-1` or `ssh teacher@192.168.104.101` to connnect to the first computer in 104 cabinet

[^1]: this keymethod provides the minimal size pubkey
