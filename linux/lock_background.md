# Automatic script:
```
#!/bin/bash

# Script to set up system-wide Cinnamon desktop background
# This script must be run with sudo privileges

echo "Setting up system-wide Cinnamon desktop background..."

# Create the dconf directory structure if it doesn't exist
echo "Creating dconf directories..."
mkdir -p /etc/dconf/db/local.d
mkdir -p /etc/dconf/db/local.d/locks
mkdir -p /etc/dconf/profile

# Create the dconf profile file to set local database as system database
echo "Creating dconf profile..."
cat > /etc/dconf/profile/user << 'EOF'
system-db:local
EOF
    

# Create the background configuration file
echo "Creating background configuration..."
cat > /etc/dconf/db/local.d/01-background << 'EOF'
[org/cinnamon/desktop/background]
picture-uri='file:///usr/share/backgrounds/linuxmint-wallpapers/jpanchal_curved.jpg'
picture-uri-dark = 'file:///usr/share/backgrounds/linuxmint-wallpapers/jpanchal_curved.jpg'
EOF

# Create the locks file to prevent users from changing the background
echo "Creating locks file..."
cat > /etc/dconf/db/local.d/locks/background << 'EOF'
/org/cinnamon/desktop/background/picture-uri
/org/cinnamon/desktop/background/picture-uri-dark
EOF

# Update the dconf database
echo "Updating dconf database..."
dconf update
```

# Manual

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
3. Create user profile `etc/dconf/profiles/user:`
```
system-db:local
```
3. Run
```
sudo dconf update
```
