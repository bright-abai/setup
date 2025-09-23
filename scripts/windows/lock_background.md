1. Create a file in `/etc/dconf/db/local.d/01-background`:
```                                                                          
[org/cinnamon/desktop/background]
picture-uri='file:///usr/share/backgrounds/linuxmint-wallpapers/jpanchal_curved.jpg'
picture-uri-dark = 'file:///usr/share/backgrounds/linuxmint-wallpapers/jpanchal_curved.jpg'
```
2. Create locks file `/etc/dconf/db/local.d/locks/background`:
```
/org/cinnamon/desktop/background/picture-uri
/org/cinnamon/desktop/background/picture-uri-dark
```
3. Run
```
sudo dconf update
```
