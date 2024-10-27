Copy-Item -Path "$PSScriptRooot\numbers" -Destination $controlFolder
Copy-Item -Path "$PSScriptRooot\bright.jpg" -Destination [System.IO.Path]::Combine($controlFolder, "admin.jpg")