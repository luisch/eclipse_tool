#!/usr/bin/env bash
. ./eclipse-env.sh

#
## 部分日食
#
# F9.0, ISO100, SS1/1000,1/500,1/250
# で、5分に１回程度の頻度で撮影
#
# gphoto2でやるならこんな感じか。スクリプトを分けて中断可能にした方がよいだろう。
#

## 第1接触まで待つ
wait_until "第１接触" "${C1_TIME}"

# 第１接触期間中、${CAPTURE_INTERVAL}ごとに撮影
# 第２接触の${CAPTURE_INTERVAL}+${WAIT_BEFORE_C2}*2秒より少なくなったら終了する
while true; do
    start_time=$(date --utc +%H:%M:%S)
    
    # 撮影
    echo "$start_time"
    shoot_partial

    # 前半部分日食の撮影終了条件
    current_time=$(date --utc +%s)
    if [ $current_time -gt $(echo $(date --utc -d "$C2_TIME" +%s) - $CAPTURE_INTERVAL - ${WAIT_BEFORE_C2} \* 2|bc) ]; then
        echo "C1 time end."
        break
    fi

	# 次の撮影タイミングまで待機
	wait_until "partial" "$start_time" "+$CAPTURE_INTERVAL"
done


## 第3接触の${WAIT_AFTER_C3}秒後まで待つ
wait_until "第３接触" "${C3_TIME}" "+${WAIT_AFTER_C3}"

# 第3接触後、${CAPTURE_INTERVAL}ごとに撮影
# 第4接触を${CAPTURE_INTERVAL}以上過ぎたら終了する
while true; do
    start_time=$(date --utc +%H:%M:%S)
    
    # 撮影
    echo "$start_time"
    shoot_partial

    # 後半部分日食の撮影終了条件
    current_time=$(date +%s)
    if [ $current_time -gt $(echo $(date --utc -d "$C4_TIME" +%s) + ${CAPTURE_INTERVAL}|bc) ]; then
        echo "C4 time end."
        break
    fi

	# 次の撮影タイミングまで待機
	wait_until "partial" "$start_time" "+$CAPTURE_INTERVAL"
done
