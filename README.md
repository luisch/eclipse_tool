# eclipse_tool

## What is eclipse_tool?
eclipse_toolは、2024年春の米国皆既日食でソニー機対応の日食撮影の自動化ツール（スクリプト）です。

このツールでは以下の基本シナリオで撮影を自動化します。前後秒数や撮影パラメータなどは各自調整可能です。（gphoto2を利用）

## 利用開始手順

WindowsのWSL2環境で動作させます。

### 環境整備

#### Windowsターミナル

以下を参考にWindowsターミナルをインストールします。

> https://learn.microsoft.com/ja-jp/windows/terminal/install

#### WSL2のインストール

以下を参考に、WSL2のUbuntu環境を用意します。

> https://dev.classmethod.jp/articles/how-to-setup-wsl2-for-windows11/
> 
> https://learn.microsoft.com/ja-jp/windows/wsl/install

#### ソニー機の長秒シャッター押下プログラムのダウンロード

```
cd ~
mkdir bin
wget https://... #どこかに公開する
unzip ....zip
```

※Sony Remote SDK ( https://support.d-imaging.sony.co.jp/app/sdk/en/index.html ) がサポートするデバイスのみ対応です。それ以前の機種についてはgphoto2調査の上でshoot.shの修正が必要です。

#### eclipse-toolの入手

```
mkdir -p /mnt/c/eclipse-tool
cd /mnt/c/eclipse-tool
git clone ... #これ
```

#### usbipdのインストール

以下を参考に、usbipdのversion4以降を入手します。version4.0以前では動作しません。

> https://learn.microsoft.com/ja-jp/windows/wsl/connect-usb

### USB接続設定

#### WSL2環境整備

WindowsターミナルでUbuntuを開き、以下のコマンドでgphoto2, bc, git, wgetをインストールします。

```
sudo apt install gphoto2 bc git
```

#### カメラとUSB接続

スタートボタンを右クリックしコマンドプロンプト（管理者）を開き、usbipd listと入力し実行します。
リストが表示されるので、接続したいカメラ名を確認します。

```
usbipd list

Connected:
BUSID  VID:PID    DEVICE                                                        STATE
 ：
2-14   054c:0e0c  ILCE-7RM5                                                     Not shared
```

この場合、ILCE-7RM5が BUSID 2-14 に繋がっています。（差すUSB口が同じならIDも変わらない模様）

次のコマンドを入力します。

```
usbipd bind --busid=2-14
```

再度usbipd listを実行すると、STATEが「Shared」になっています。

```
usbipd list

Connected:
BUSID  VID:PID    DEVICE                                                        STATE
 ：
2-14   054c:0e0c  ILCE-7RM5                                                     Shared
```

正常に動作しなかった場合、次のコマンドでwsl2を最新版にアップデートしてみてください。

```
wsl --update
```

※Windows11のみ検証。Windows10では異なるかも。

#### 環境変数の設定

c:\eclipse-toolにあるstart.ps1をエディタで開き、先頭行のcamera_nameを上のusbipd listで得られたデバイス名に書き換えます。

> $camera_name="ILCE-7RM5"

ファイルを上書き保存して閉じます。

## チューニング

### 撮影方法・日食パラメータの変更

### 撮影方法の修正

shoot.shを修正します。詳細はファイルの中のコメント行を確認してください。

α7Rv用に記載してありますが、同じαでも機種やファームウェアによってだいぶ変わると思います。お手持ちのカメラをつなぎ、WSL2環境下でgphoto2 --list-all-configと実行して得られる結果を見ながら色々試して下さい。

gphoto2さえ動けばキヤノンやニコン、フジなどでも対応可能じゃないかと思います。

## 動作テスト

#### カメラ側の設定

* カメラの初期設定  
  次の設定にしておいてください（メモリ登録すると便利です。）
  * ドライブモード：１枚撮影
  * 絞り：F9.0
  * ISO：100
  * シャッター：1/500
* α7Rvの場合  
「リモート撮影設定」の「静止画の保存先」を「カメラ本体のみ」にする、または「保存画像のサイズ」を2Mにしてください。それ以外では撮影途中にカメラがフリーズする可能性があります。
フリーズしたら一旦電池とUSBを抜き差しすると復帰するようです。（α7Rv firmware 2.01 にて確認）

#### 時計の調整

Windowsのタイムゾーンと時刻を日食発生時刻の少し前に変更します。
Windows Timeサービスをあらかじめ無効化しておいて下さい。

「コマンドプロンプト（管理者）」から
```
date 2024/04/08
time 12:20
```
と入力すれば変更可能です。

### テスト実行

カメラをUSBでつなぎ、run.batを実行すると、カメラとUSB接続し撮影監視ウインドウを開きます。

Eclipse Orchestratorなどと一緒にカメラの挙動を確認してください。

## 当日

PCの時計が正確であることを確認します。

eclipse-env.shの日食イベント時刻定義を再確認します。（UTCで記載します。現地時刻ではありません。）

カメラのバッテリーを一旦抜き差しした後、USBでカメラと接続します。

run.batを起動して、あとは待つだけです。

## ライセンス

BSDライセンスに準拠します。完全な動作保証ならびに発生した結果について一切の責任を負いません。
