# 接続先カメラ名を記載。usbipdで以下の名前を持つカメラをWSLに認識させる
$camera_name="ILCE-7RM5"

# 再起動はすべてを解決する
# ※wsl下の時計がスリープ後にずれたりする問題をこれで解決します
wsl -e echo "restart WSL2.."
wsl --shutdown
wsl -e echo "WSL2 had restarted"

#
# WSL2環境にUSB経由でカメラを認識させる
#
$usbipdList    = usbipd list
$attachedCount = ($usbipdList|Select-String "Attached").Count
if ($attachedCount -eq 0) {
    $busid = ($usbipdList | Select-String "Shared" | Select-String $camera_name).ToString().Split(" ")[0]
    usbipd attach --wsl --busid=$busid
}
$usbipdList    = usbipd list
$attachedCount = ($usbipdList|Select-String "Attached").Count
if ($attachedCount -eq 0) {
    Write-Output "### Camera not connected! ###"
    exit 1
}


# 監視用ターミナルを起動し、スクリプト開始
Start-Sleep 5

#以下はWSL2下で監視スクリプトを回す。
#
#{NOTE]
# WSL2は内部時計がWindows本体とずれる可能性があるので、
# これが問題になる場合は別途Cygwinなどを入れて2行目のように実行する。
# その場合はshoot.sh内でgphoto2を呼び出すときに wsl -eを先頭につけること。
# また裏でWSLのターミナルを開いておかないとエラーが出るっぽい。

#wt.exe -p "Ubuntu" ";" new-tab -p "Ubuntu" -d . wsl -e ./_part.sh ";" split-pane -V -p "Ubuntu" -d . wsl -e ./_full.sh # WSL2で起動
wt.exe -p "Ubuntu" ";" new-tab -d . cmd.exe /c bash ./_part.sh ";"  split-pane -V -d . cmd.exe /c bash ./_full.sh #Cygwinで起動
