$camera_name="ILCE-7RM5"

usbipd detach -a
wsl -u root systemctl restart systemd-timesyncd --no-pager
wsl -u root systemctl status  systemd-timesyncd --no-pager
wsl timedatectl show

#
# WSL2環境にUSB経由でカメラを認識させる
# 突然認識が外れることがあるため、定期的に監視をつづける。
#
for(;;)
{
    $wsl_time = (wsl date +%H:%M:%S)
    $now = (Get-Date)
    Write-Host -NoNewline "Host:"$now.ToString('HH:mm:ss')"|WSL:"$wsl_time

    $usbipdList    = usbipd list
    $attachedCount = ($usbipdList|Select-String "Attached").Count
    if ($attachedCount -eq 0) {
        $shared_line = ($usbipdList | Select-String "Shared" | Select-String $camera_name)
        if( $null -ne $shared_line)
        {
            $busid = $shared_line.ToString().Split(" ")[0]
            while ($attachedCount -eq 0) {
                Write-Host "`nAttaching a Camera ID: $busid"
                usbipd attach --wsl --busid=$busid
                Start-Sleep 3

                $usbipdList    = usbipd list
                $attachedCount = ($usbipdList|Select-String "Attached").Count
                Start-Sleep 1
            }
            wsl --shell-type standard gphoto2 -q --auto-detect
        }
    }
    if ($attachedCount -eq 0) {
        Write-Host -NoNewline -ForegroundColor "Yellow" -BackgroundColor "DarkRed" "`t### Camera not connected! ###"
    }
    Write-Host -NoNewline "`r"
    Start-Sleep 1
}
