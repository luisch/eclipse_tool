@echo off
net session >NUL 2>nul
if %errorlevel% neq 0 (
 @powershell start-process %~0 -verb runas
 exit
)

wsl -u root timedatectl set-ntp true
sc start W32Time
sc config "W32Time" start=auto

w32tm /resync
