# 1. Install the C++ Toolchain (GCC, G++, GDB)
Write-Host "Installing GCC Toolchain (this may take a few minutes)..." -ForegroundColor Cyan
& "C:\Programs\Cpp\usr\bin\bash.exe" -lc "pacman -S --needed --noconfirm base-devel mingw-w64-ucrt-x86_64-toolchain"

# 2. Add the compiler to your Windows PATH
$mingwPath = "C:\Programs\Cpp\ucrt64\bin"
# Using "User" scope for the current student/user
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

if ($currentPath -notlike "*$mingwPath*") {
    Write-Host "Adding MinGW to PATH..." -ForegroundColor Green
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$mingwPath", "Machine")
    $env:Path += ";$mingwPath"
}

Write-Host "Setup Complete! Please RESTART PowerShell to apply changes." -ForegroundColor Yellow