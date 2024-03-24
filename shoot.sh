#!/usr/bin/env sh
#
# 撮影関数の定義
# ここではパラメーターの変更と撮影を行う
#

#
# 部分日食時間の撮影モード設定
#
init_partial(){
    #
    # 撮影パラメータを設定
    #
    # 以下の例では、シャッター速度1/500, ドライブモードを連射LOに設定する。
    #
    # gphoto2初期化
    gphoto2 -q --set-config /main/capturesettings/shutterspeed="1/500"
    gphoto2 -q --set-config /main/capturesettings/capturemode="Continuous Low Speed"
}
#
# 部分日食時間の撮影コマンド
# この関数は CAPTURE_INTERVAL 秒の間隔で定期的に呼び出される。
# 関数内処理が CAPTURE_INTERVALより時間が掛かってしまった場合は処理終了後即呼び出される。
#
shoot_partial() {
    #
    # 撮影パラメータを変更しながら撮影。
    #
    # 以下の例では、シャッター速度1/1000, 1/500, 1/250を0.8秒間隔で撮影する。
    # CAPTURE_INTERVAL秒以上の時間が掛からないように注意。
    #
    # 0.8秒待っているのは、撮影コマンド実行からわずかな時間、カメラがシャッター速度等の変更を受け付けない時間があるため。
    # α7Rvで実験したところ0.5～0.7秒程度あるらしい。
    #
    
    # A7Rvではshutterspeed=45が1/1000
    gphoto2 -q --set-config /main/capturesettings/shutterspeed="1/1000" --trigger-capture
    sleep 0.8
    
    # A7Rvではshutterspeed=45が1/500
    gphoto2 -q --set-config /main/capturesettings/shutterspeed="1/500" --trigger-capture
    sleep 0.8

    # A7Rvではshutterspeed=45が1/250
    gphoto2 -q --set-config /main/capturesettings/shutterspeed="1/250" --trigger-capture
    sleep 0.8
}

#
# ダイアモンドリング撮影
# この関数は、第２接触の WAIT_BEFORE_C2秒前と、第３接触のWAIT_BEFORE_C3秒前にそれぞれ１回だけ呼び出される。
#
init_diamondring(){
    #
    # 撮影パラメータを設定
    #
    # 以下の例では、シャッター速度1/500, ドライブモードを連写LOに設定する。
    #
    # gphoto2初期化
    gphoto2 -q --set-config /main/capturesettings/shutterspeed="1/500"
    gphoto2 -q --set-config /main/capturesettings/capturemode="Continuous Low Speed"
}
shoot_diamondring() {
    #
    # α7Rvでは、gphoto2で１秒あたり１枚程度の連続撮影が限度。連写モードに設定はできるがシャッター押しっぱなしにできない。
    # libgphoto2のα7Rvの対応にバグがあるらしく、一般的なPTPデバイスとしてしか使えずこのような制御が不可。
    #
    # それ以外のソニーカメラでは、/main/actions/captureを1に設定するとシャッターを押した状態に維持できる模様で、
    # 多分以下のようなコードで実現できる。
    #
    #  gphoto2 -q --set-config /main/actions/capture=1
    #  sleep ${CAPTURE_DURATION_DURING_DIAMONDRING}
    #  gphoto2 -q --set-config /main/actions/capture=0
    #
    # α7Rvでは代わりにSony Remote SDKで「指定秒数ただボタンを押すコマンド」を作成した。
    # ただ残念ながらこのプログラムは起動後ボタン押下処理が走るまで約4秒の時間を要する。
    # ダイヤモンドリングにおいてはシャッター切るタイミングを少し早めに設定しておく必要がある。
    #
    #
    # sony remote sdkで作った「指定秒シャッターを切り続けるプログラム」を起動
    echo "Connect to A7RV.."
    ../bin/push-shutter ${CAPTURE_DURATION_DURING_DIAMONDRING}
}

#
# コロナ撮影
# この関数は コロナ時間中連続的に呼び出される。
#
init_corona(){
    #
    # 撮影パラメータを設定
    #
    # シャッタースピードはshootしながら変更するためここでは操作しない。
    # ドライブモードを1枚撮りに設定するには次のコマンドを実行する。
    # ただ、α7Rvでは保存バッファが残ってる間ドライブモード変更ができない（read onlyになる）ため、エラーになる。
    # バッファが捌けるのを待っていると1分くらいロスする上に連写モードになっていてもあまり実害ないので、このままにする。
    # gphoto2 -q --set-config /main/capturesettings/capturemode=0
    :
}
shoot_corona() {
    #
    # --capture-imageでは直前のダイヤモンドリングで連写したバッファが残っている間は撮影が進まない。そこでtrigger-captureを用いている。
    # 0.8秒待っているのは、撮影コマンド実行からわずかな時間、カメラがシャッター速度等の変更を受け付けない時間があるため。
    #
    # 1/500秒
    gphoto2 -q --set-config /main/capturesettings/shutterspeed="1/500" --trigger-capture
    sleep 0.8
    gphoto2 -q --set-config /main/capturesettings/shutterspeed="1/250" --trigger-capture
    sleep 0.8
    gphoto2 -q --set-config /main/capturesettings/shutterspeed="1/125" --trigger-capture
    sleep 0.8
    gphoto2 -q --set-config /main/capturesettings/shutterspeed="1/60" --trigger-capture
    sleep 0.8
    gphoto2 -q --set-config /main/capturesettings/shutterspeed="1/30" --trigger-capture
    sleep 0.8
    gphoto2 -q --set-config /main/capturesettings/shutterspeed="1/15" --trigger-capture
    sleep 0.8
    gphoto2 -q --set-config /main/capturesettings/shutterspeed="1/8" --trigger-capture
    sleep 0.8
    gphoto2 -q --set-config /main/capturesettings/shutterspeed="1/4" --trigger-capture
    sleep 0.7
    gphoto2 -q --set-config /main/capturesettings/shutterspeed="1/2" --trigger-capture
    sleep 0.6
}
