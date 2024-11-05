# Get the computer name in the format ST-104-xx
$computerName = $env:COMPUTERNAME

# Extract the computer number from the name (e.g., ST-104-07 → 07)
$match = [regex]::Match($computerName, "ST-\d{3}-(\d{2})")
if ($match.Success) {
    $computerNumber = $match.Groups[1].Value
} else {
    Write-Host "Computer name does not match the expected format ST-xxx-xx"
    exit
}

# Define the expected local user name based on the computer number
$expectedUserName = "ST-$computerNumber"

# Check if the user exists
$user = Get-LocalUser | Where-Object { $_.Name -eq $expectedUserName }

if ($user) {
    Write-Host "User '$expectedUserName' already exists."
} else {
    # If the user doesn't exist, rename the existing user (if any) to match
    $existingUser = Get-LocalUser | Where-Object { $_.Name -like "ST-*" }

    if ($existingUser) {
        Write-Host "Renaming user '$($existingUser.Name)' to '$expectedUserName'..."
        Rename-LocalUser -Name $existingUser.Name -NewName $expectedUserName
    } else {
        Write-Host "No matching user found to rename."
    }
}
