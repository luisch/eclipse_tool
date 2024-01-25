#!/usr/bin/env sh

#
# 日食関連情報
#

C1_TIME="17:23:16" #C1/UTC
C2_TIME="18:40:41" #C2/UTC
MX_TIME="18:42:37" #MAX/UTC
C3_TIME="18:44:28" #C3/UTC
C4_TIME="20:02:40" #C4/UTC

# 部分日食中の撮影間隔(秒)
# 第2接触までの残り時間がCAPTURE_INTERVAL+WAIT_BEFORE_C2*2より少なくなったら撮影を終える
CAPTURE_INTERVAL=300

#C2の何秒前に連写撮影を始めるか
WAIT_BEFORE_C2=25

#C3の何秒前に連写撮影を始めるか
WAIT_BEFORE_C3=45

# ダイヤモンドリング中の連写時間(ミリ秒数)
CAPTURE_DURATION_WITH_DIAMONDRING=45000

#C3の何秒後に部分日食撮影を開始するか
WAIT_AFTER_C3=30

#
# 撮影関数
# ここではパラメーターの変更と撮影を行う
#

#
# 部分日食時間の撮影
# この関数は CAPTURE_INTERVAL 秒間隔に呼び出される。
#
shoot_partial() {
    wsl --exec gphoto2 -q --set-config /main/capturesettings/shutterspeed=45 --trigger-capture
    sleep 0.8
    wsl --exec gphoto2 -q --set-config /main/capturesettings/shutterspeed=42 --trigger-capture
    sleep 0.8
    wsl --exec gphoto2 -q --set-config /main/capturesettings/shutterspeed=39 --trigger-capture
    sleep 0.8
}

#
# ダイアモンドリング撮影
# この関数は、第２接触の WAIT_BEFORE_C2秒前と、第３接触のWAIT_BEFORE_C3秒前にそれぞれ１回だけ呼び出される。
#
shoot_diamondring() {
   #
   # 撮影パラメータを設定
   #
   wsl --exec gphoto2 -q \
       --set-config /main/capturesettings/shutterspeed=42 \
       --set-config /main/capturesettings/capturemode=4
   #
   # gphoto2では１秒あたり１枚程度の連続撮影が限度。連写モードに設定はできるがシャッター押しっぱなしにできない。
   # libgphoto2のα7Rvの対応にバグがあるらしく、一般的なPTPデバイスとしてしか使えないため、captureステートを変更できないためと思われる。
   # したがってSony SDKで「ただボタンを押すツール」を作る必要がある。これは作成できたが、起動からボタン押下まで約4秒待たされる。
   # ダイヤモンドリングにおいてはシャッター切るタイミングを少し早めに回す必要がある。
   #
   # sony remote sdkで作った「指定秒シャッターを切り続けるプログラム」を起動
   #
   echo "Connect to A7RV.."
   wsl --exec ~/bin/push-shutter ${CAPTURE_DURATION_WITH_DIAMONDRING}
}

#
# コロナ撮影
# この関数は コロナ時間中連続的に呼び出される。
#
shoot_corona() {
    #
    # --capture-imageでは連射バッファが残っている間は撮影が止まる。
    # trigger-captureなら問題ないが、早すぎてカメラがshutterspeed変更を受け付けてくれないため sleepを入れる
    # wait-eventでもよさそうだが、よくわからない警告がいっぱい出るので精神的によくない
    #
    wsl --exec gphoto2 -q --set-config /main/capturesettings/shutterspeed=45 --trigger-capture
    sleep 0.8
    wsl --exec gphoto2 -q --set-config /main/capturesettings/shutterspeed=42 --trigger-capture
    sleep 0.8
    wsl --exec gphoto2 -q --set-config /main/capturesettings/shutterspeed=39 --trigger-capture
    sleep 0.8
}

#
# 共通関数
#

# 特定時刻まで待つ関数
wait_until() {
  EVENT_NAME=$1
  TIME=$2
  ADJUST=$3
  
  echo -ne "\n"
  
  target_timestamp=$(echo $(date --utc -d "${TIME}" +%s) $ADJUST|bc)
  while true; do
      current_timestamp=$(date --utc +%s)
      time_remaining=$((target_timestamp - current_timestamp))
      if [ $time_remaining -le 0 ]; then
          break
      fi
      echo -ne "\r$(date --utc +%H:%M:%S) - next ${EVENT_NAME}(${TIME}${ADJUST}s)-$(date --utc -d @$time_remaining +%H:%M:%S)"
      sleep 0.2
  done
  
  echo -ne "\n"
}

