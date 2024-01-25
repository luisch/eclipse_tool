#!/usr/bin/env sh
. ./eclipse-env.sh

#
# WSL2環境にUSB経由でカメラを認識させる
#
if [ $(usbipd list|grep Attached|wc -l) -eq 0 ]; then
  usbipd attach --wsl --busid=$(usbipd list|grep Shared|grep ILCE-7RM5|cut -d' ' -f 1)
fi
if [ $(usbipd list|grep Attached|wc -l) -eq 0 ]; then
  echo "### Camera not connected! ###"
  exit 1
fi

wsl --exec gphoto2 -q --auto-detect
