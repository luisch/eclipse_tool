#!/usr/bin/env sh

#
# 日食関連情報
#

C1_TIME="17:23:16" #第1接触の時刻(UTC)
C2_TIME="18:40:41" #第2接触の時刻(UTC)
MX_TIME="18:42:37" #最大の時刻(UTC)
C3_TIME="18:44:28" #第3接触の時刻(UTC)
C4_TIME="20:02:40" #第4接触の時刻(UTC)

# 部分日食中の撮影間隔(秒)
# 第2接触までの残り時間がCAPTURE_INTERVAL+WAIT_BEFORE_C2*2より少なくなったら撮影を終える
CAPTURE_INTERVAL=300

#C2の何秒前に連写撮影を始めるか
WAIT_BEFORE_C2=25

#C3の何秒前に連写撮影を始めるか
WAIT_BEFORE_C3=45

# ダイヤモンドリング中の連写時間(秒数)
CAPTURE_DURATION_DURING_DIAMONDRING=45

#C3の何秒後に部分日食撮影を開始するか
WAIT_AFTER_C3=30
