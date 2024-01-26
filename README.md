# eclipse_tool

## What is eclipse_tool?
eclipse_toolは、2024年春の米国皆既日食でソニー機対応の日食撮影の自動化ツール（スクリプト）です。

このツールでは以下の基本シナリオで撮影を自動化します。前後秒数や撮影パラメータなどは各自調整可能です。（gphoto2を利用）

## 利用方法

WindowsのWSL2環境で動作させます。

### WSL2のインストール

以下を参考に、WSL2のUbuntu環境を用意します。

> https://dev.classmethod.jp/articles/how-to-setup-wsl2-for-windows11/
> 
> https://learn.microsoft.com/ja-jp/windows/wsl/install

### WSL2環境の整備

aptでgphoto2を導入します。

```
sudo apt install gphoto2 git
```

### ソニー機の長秒シャッター押下プログラムを入手

```
cd ~
mkdir bin
wget https://... #どこかに公開する
unzip ....zip
```

以下のファイルが展開されます。

### eclipse-toolの入手

```
mkdir -p /mnt/c/eclipse-tool
cd /mnt/c/eclipse-tool
git clone ... #これ
```

### カメラのUSB接続設定

#### usbipdのインストール

以下を参考に、usbipdのversion4以降を入手します。version4.0以前では動作しません。

> https://learn.microsoft.com/ja-jp/windows/wsl/connect-usb

#### カメラのUSB接続設定

次にコマンドプロンプト（管理者）を開き、次のコマンドを入力します。
リストが表示されるので、接続したいカメラ名を確認します。

```
usbipd list
```

次に、c:\eclipse-toolにあるstart.ps1をエディタで開き、先頭行のcamera_nameを書き換えます。
> $camera_name="ILCE-7RM5"

ファイルを上書き保存して閉じます。

### 撮影方法・日食パラメータの変更

### 撮影方法の修正



### テスト実行

Windowsのタイムゾーンと時刻を日食発生時刻の少し前に変更します。
Windows Timeサービスをあらかじめ無効化しておいて下さい。

「コマンドプロンプト（管理者）」から
```
date 2024/04/08
time 12:20
```
と入力すれば変更可能です。

カメラをUSBでつなぎ、start.ps1を実行すると撮影監視ウインドウが開きます。

### 当日実行

eclipse-env.shの日食イベント時刻定義を再確認して下さい。（UTCで記載します。現地時刻ではありません。）

カメラのバッテリーを一旦抜き差しした後、USBでカメラと接続します。

start.ps1を起動して、あとは待つだけです。
