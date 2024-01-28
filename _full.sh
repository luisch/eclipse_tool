#!/usr/bin/env bash
. ./eclipse-env.sh
. ./shoot.sh

#
## ダイヤモンドリング(第２接触)
#
# 第２接触の${WAIT_BEFORE_C2}秒前まで待つ
#
wait_until "第２接触" "${C2_TIME}" "-${WAIT_BEFORE_C2}"
#
# ダイヤモンドリング撮影関数を1回だけ起動
#
shoot_diamondring

## 皆既中
#
# 定期的にコロナ撮影関数を起動
#
start_time=$(date --utc +%s)
while true; do
    echo $(date --utc +%H:%M:%S)
    shoot_corona

    # 終了条件はC3の${WAIT_BEFORE_C3}+3秒前
    current_time=$(date --utc +%s)
    if [ $current_time -gt $(echo $(date --utc -d "$C3_TIME" +%s) - ${WAIT_BEFORE_C3} - 3|bc) ]; then
        break
    fi
    
done

## ダイヤモンドリング(第３接触)
#
# ダイヤモンドリング撮影関数を1回だけ起動
#
shoot_diamondring

echo "End Full Eclipse"
