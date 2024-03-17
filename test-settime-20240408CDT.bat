@echo off
net session >NUL 2>nul
if %errorlevel% neq 0 (
 @powershell start-process %~0 -verb runas
 exit
)

wsl -u root timedatectl set-ntp false
sc stop W32Time
sc config "W32Time" start=disabled
tzutil /s "Central Standard Time"

date 2024/04/08
time 12:18
