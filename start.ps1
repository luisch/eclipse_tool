# 接続先カメラ名を記載。usbipdで以下の名前を持つカメラをWSLに認識させる
$camera_name="ILCE-7RM5"

# 再起動はすべてを解決する
# ※wsl下の時計がスリープ後にずれたりする問題をこれで解決します
wsl --shutdown

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

# wsl2下のgphoto2でカメラを認識させる
wsl --exec gphoto2 -q --auto-detect

# 監視用ターミナルを起動し、スクリプト開始
wt.exe -d . wsl -e ./c1.sh ";" split-pane -V -d . wsl -e ./c2.sh
