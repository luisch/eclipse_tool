#!/usr/bin/env sh
set -o errtrace

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

#
# ログ出力
#
LOG_FILE="../$(date --utc +%Y%m%d).log"
exec 2> >(while read line; do echo "$(date '+%H:%M:%S') [ERROR] $line"; done | tee -a $LOG_FILE)

#
# エラー時処理
#
function retry_shot() {
  echo -e "##エラー検知、コマンド再試行します##\n -> $@" 1>&2
  trap - ERR
   sleep 1.0
   gphoto2 --reset
   gphoto2 --auto-detect > /dev/null
   eval "$1"
   if [ $? -ne 0 ]; then
     echo "コマンド失敗" 1>&2
   else
     echo "コマンド成功"
   fi
  trap 'retry_shot "$BASH_COMMAND"' ERR
}
trap 'retry_shot "$BASH_COMMAND"' ERR
