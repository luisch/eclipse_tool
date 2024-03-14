$camera_name="ILCE-7RM5"
usbipd detach -a

#
# WSL2環境にUSB経由でカメラを認識させる
# 突然認識が外れることがあるため、定期的に監視をつづける。
#
while($true)
{
    $now = (Get-Date)
    Write-Host -NoNewline $now.ToString('yyyy-MM-dd HH:mm:ss')"|"$now.ToUniversalTime().ToString('HH:mm:ss')

    $usbipdList    = usbipd list
    $attachedCount = ($usbipdList|Select-String "Attached").Count
    if ($attachedCount -eq 0) {
        $shared_line = ($usbipdList | Select-String "Shared" | Select-String $camera_name)
        if( $null -ne $shared_line)
        {
            $busid = $shared_line.ToString().Split(" ")[0]
            Write-Host "`nAttaching a Camera ID: $busid"
            usbipd attach --wsl --busid=$busid
            Write-Host "`n"

            # gphoto2初期化
            Start-Sleep 5
            wsl --shell-type standard gphoto2 -q --auto-detect
            $usbipdList    = usbipd list
            $attachedCount = ($usbipdList|Select-String "Attached").Count
        }
    }
    if ($attachedCount -eq 0) {
        Write-Host -NoNewline "`t### Camera not connected! ###"
    }
    Write-Host -NoNewline "`r"
    Start-Sleep 1
}
