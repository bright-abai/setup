# SSH Control setup

## For each server (student):
1. Rename computer in settings to ST-10x-xx
2. Use sshserver.bat[^1] as admin on the server. (If console print restart needed, restart and rerun).
3. Double check that pbkey10x.bat contains your public key, and then run pbkey10x.bat[^2] 
4. pbkey1x.bat opens a folder where authorised_keys is located. You should go security settings for that file, turn of inheritance and remove administrators group manually. [^3]

## For the client (techer, controller)
1. `ssh-keygen -t ed25519` [^4] (no passphrase is advised, because there was one time when I mistyped the password twice)
2. `ssh-add C:\Users\Abai\.ssh\id_ed25519`

## Usage

- Run `ssh Admin@ST-10x-xx` ST-10x-xx is the name of the computer. You should login without password.
- Run `shutdown_106.bat` to turn off computers remotely. This script also acts as an example for how to run commands on each computer.

Hopefully i have documented my process fully.


![image from Legends of Runeterra](https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/09d8c379-3e43-4e63-9d66-4ae4c16a42fb/deijukq-0244c5a6-3f6f-4e84-8f7c-8606257953fe.jpg/v1/fill/w_1024,h_500,q_75,strp/xenotype_researchers_by_dopaprime_deijukq-fullview.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9NTAwIiwicGF0aCI6IlwvZlwvMDlkOGMzNzktM2U0My00ZTYzLTlkNjYtNGFlNGMxNmE0MmZiXC9kZWlqdWtxLTAyNDRjNWE2LTNmNmYtNGU4NC04ZjdjLTg2MDYyNTc5NTNmZS5qcGciLCJ3aWR0aCI6Ijw9MTAyNCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.35oTjyVi2nwckWlW5LhjIvII2B8J_Kj9JaRVGNPrG_E)


[^1]: it should install openssh server additional component, setup firewall rules and open port, remove match group from sshd_config
[^2]: should copy the correct key, if i had not forgotten do modify the .bat file last time.
[^3]: i have tried automating this step, but did not succeed. Russian version has `Администраторы`, which i think was not recognised by my script.
[^4]: this keymethod provides the minimal size pubkey
