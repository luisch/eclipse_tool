@echo off

REM UTF-8
chcp 65001

REM "再起動はすべてを解決する"
REM "※wsl下の時計がスリープ後にずれたりする問題をこれで解決する"

wsl -e echo "restart WSL2.."
wsl --shutdown
wsl -e echo "WSL2 had restarted"

REM "WSL2環境にUSB経由でカメラを認識させる"

REM "監視用ターミナルを起動し、スクリプト開始"
REM "以下はWSL2下で監視スクリプトを回す。"

REM "WSL2は内部時計がWindows本体とずれる可能性があるので、"
REM "これが問題になる場合は別途Cygwinなどを入れて2行目のように実行する。"
REM "その場合はshoot.sh内でgphoto2を呼び出すときに wsl -eを先頭につけること。"
REM "また裏でWSLのターミナルを開いておかないとエラーが出るっぽい。"

wt.exe -pwt -d . powershell -NoExit -ExecutionPolicy Unrestricted -Command ".\script\_watchdog.ps1" ";" split-pane -s 0.7 -H -p "Ubuntu" -d ./script wsl --shell-type standard -- bash ./_part.sh ";" split-pane -V -p "Ubuntu" -d ./script wsl --shell-type standard -- bash ./_full.sh

REM pause > nul
exit
