#!/usr/bin/env bash
. ./eclipse-env.sh

#
## ダイヤモンドリング(第２接触)
#
# F9.0, ISO100, SS1/500でLO連写
#
## 第２接触の${WAIT_BEFORE_C2}秒前まで待つ
wait_until "第２接触" "${C2_TIME}" "-${WAIT_BEFORE_C2}"

## 撮影パラメーターを変更して撮影関数を起動
shoot_diamondring

## 皆既中
#
# F9.0, ISO100, SS1/1000(45),1/500(42),1/250(39)を5秒間隔で撮影
#
start_time=$(date --utc +%s)
while true; do
    echo $(date --utc +%H:%M:%S)
    shoot_corona

    # 終了条件はC3の${WAIT_BEFORE_C3}+3秒前
    current_time=$(date --utc +%s)
    if [ $current_time -gt $(echo $(date --utc -d "$C3_TIME" +%s) - ${WAIT_BEFORE_C3} - 3|bc) ]; then
        echo "End Full Eclipse"
        break
    fi
    
done

## ダイヤモンドリング(第３接触)
#
# ここも少し早め（４秒前）に開始する必要あり。
#
shoot_diamondring

