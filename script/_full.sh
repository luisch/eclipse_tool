#!/usr/bin/env bash
. ../settings.sh
. ./_func.sh
. ../shoot.sh

#
## ダイヤモンドリング(第２接触)
#
# 第２接触の${WAIT_BEFORE_C2}秒前まで待つ
#
wait_until "第２接触" "${C2_TIME}" "-${WAIT_BEFORE_C2}"
#
# ダイヤモンドリング撮影関数を1回だけ起動
#
echo -e "shoot diamondring"
init_diamondring > /dev/null
shoot_diamondring > /dev/null

## 皆既中
#
# 定期的にコロナ撮影関数を起動
#
echo -e "shoot corona"
init_corona > /dev/null
start_time=$(date --utc +%s)
while true; do
    echo -ne "."
    shoot_corona > /dev/null

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
echo -e "shoot diamondring"
init_diamondring > /dev/null
shoot_diamondring > /dev/null

echo "End Full Eclipse"
wait_until "部分食の終了" ${C4_TIME}
