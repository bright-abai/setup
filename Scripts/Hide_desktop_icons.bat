@echo off

:: Created by: Shawn Brink
:: Created on: November 30, 2023
:: Tutorial: https://www.elevenforum.com/t/hide-or-show-desktop-icons-in-windows-11.4824/

REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V HideIcons /T REG_DWORD /D 1 /F
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /V NoDesktop /T REG_DWORD /D 1 /F

taskkill /f /im explorer.exe
start explorer.exe