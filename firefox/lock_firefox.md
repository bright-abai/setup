# How to whitelist sites

Create a file `policies.json` in `/etc/firefox/policies`, it will be read by firefox each time it starts. 
If on Win10, the path is "C:\Program Files\Mozilla Firefox\distribution"

To remove restrictions, rename or delete the policies.json

To protect the folder:
```
icacls "C:\Program Files\Mozilla Firefox\distribution" /deny "Users:(W)"
```