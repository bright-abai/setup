# Define the path for secure storage
$wallpaperPath = "C:\SecureWallpapers"
$wallpaperFile = "C:\Path\To\Your\Wallpaper.jpg"

# Create the directory if it doesn't exist
if (-Not (Test-Path $wallpaperPath)) {
    New-Item -Path $wallpaperPath -ItemType Directory -Force
}

# Copy the wallpaper file to the secure directory
Copy-Item -Path $wallpaperFile -Destination $wallpaperPath -Force

# Set NTFS permissions
$acl = Get-Acl $wallpaperPath

# Disable inheritance and protect existing permissions
$acl.SetAccessRuleProtection($true, $false)

# Deny delete and modify permissions for Users group
$denyRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Users", "Delete, Modify", "Deny")
$acl.AddAccessRule($denyRule)

# Allow full control to Administrators group
$allowRuleAdmin = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "FullControl", "Allow")
$acl.AddAccessRule($allowRuleAdmin)

# Allow full control to SYSTEM account
$allowRuleSystem = New-Object System.Security.AccessControl.FileSystemAccessRule("SYSTEM", "FullControl", "Allow")
$acl.AddAccessRule($allowRuleSystem)

# Apply the updated ACL to the directory
Set-Acl -Path $wallpaperPath -AclObject $acl

# Set the desktop wallpaper (if needed)
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "Wallpaper" -Value "$wallpaperPath\Wallpaper.jpg"
