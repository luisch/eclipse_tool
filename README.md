# eclipse_tool

## What is eclipse_tool?
eclipse_toolは、gphoto2を利用した皆既日食撮影の自動化ツール（スクリプト）で、Windows上のWSL2環境で動作します。

ソニーのミラーレスカメラ(α7Rv)で開発しましたが、gphoto2対応カメラ一般に適用可能です。

### 動作環境

* Windows10または11のWSL2（Ubuntu）
* gphoto2対応カメラ(SONY, NIKON, CANON, FUJIなど)

## 利用開始手順

#### Windowsターミナルのインストール

以下を参考にWindowsターミナルをインストールします。

> https://learn.microsoft.com/ja-jp/windows/terminal/install

#### WSL2/gphoto2のインストール

以下を参考に、WSL2のUbuntu環境を用意します。

> https://dev.classmethod.jp/articles/how-to-setup-wsl2-for-windows11/
> 
> https://learn.microsoft.com/ja-jp/windows/wsl/install

インストールできたらWindowsターミナルでUbuntuを開き、以下のコマンドでgphoto2, bc, git, wgetをインストールします。

```
sudo apt install gphoto2 bc git
```

#### eclipse-toolの入手

```
mkdir -p /mnt/c/eclipse-tool
cd /mnt/c/eclipse-tool
git clone ... #これ
```

#### usbipdのインストール

以下を参考に、usbipdのversion4以降を入手します。version4.0以前では動作しません。

> https://learn.microsoft.com/ja-jp/windows/wsl/connect-usb

## USBでカメラと接続

#### 初期設定

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

### 撮影方法の修正

ご自身の撮影計画に合わせ、shoot.shを修正します。詳細はファイルの中のコメント行を確認してください。

* α7Rvでしか確認していません。同じαでも機種やファームウェアによってだいぶ変わると思います。
* 特にSony Camera Remote SDK( https://support.d-imaging.sony.co.jp/app/sdk/ja/index.html )非対応機種の場合、ダイヤモンドリング撮影箇所の修正が必要です。
* お手持ちのカメラをつなぎ、WSL2環境下でgphoto2 --list-all-configと実行して得られる結果を見ながら色々試して下さい。
* gphoto2が動作するならキヤノンやニコン、フジでも理論上対応可能です。

### 観測地情報の設定

観測予定地に合わせ、eclipse-env.shを修正します。詳細はファイル内のコメント行を確認してください。

* Eclipse Orchestratorのフリー版などに緯度・経度を入力すると算出できます。
* 時刻は世界時(UTC)で記載します。現地時刻ではありません。

## 動作テスト

#### カメラ側の設定

* カメラの初期設定  
  自身の撮影計画に合わせて初期設定を行ってください。メモリ登録すると便利です。
  eclipse-toolでは次の設定になっている前提で記載しています。
  * ドライブモード：１枚撮影
  * 絞り：F8.0～9.0
  * ISO：100
  * シャッター：1/500
* α7Rvの場合  
「リモート撮影設定」の「静止画の保存先」を「カメラ本体のみ」にする、または「保存画像のサイズ」を2Mにしてください。それ以外では撮影途中にカメラがフリーズする可能性があります。
フリーズしたら一旦電池とUSBを抜き差しすると復帰するようです。（α7Rv firmware 2.01 にて確認）

#### 時計の調整

Windowsのタイムゾーンと時刻を日食発生時刻の少し前に変更します。
Windows Timeサービスをあらかじめ無効化しておいて下さい。

settime-20240408CDT.batを利用すると、当日12:20に時計修正＆Windows Timeサービスの無効化できます。

### テスト実行

* 省電設定（一定期間経過後に自動スリープになる）をオフを推奨します。
* 現地でネットワーク接続がない場合、機内モードにしてください。
 * この場合、usbが正常動作しない可能性があります。下記「備考」参照。
* USBでカメラと接続する。
 * 接続の直前にカメラバッテリーの抜き差しによるリセットを推奨します。
* ツール起動
　* run.batを実行します．

撮影監視ウインドウを開くので、Eclipse Orchestrator等のシミューレーター等と並行にカメラ挙動を確認してください。

#### 備考

* usbipd: warning: A third-party firewall may be blocking the connection; ensure TCP port 3240 is allowed.と表示され固まる場合  
WindowsFirewallの設定を開き、「WindowsFirewallの有効化または無効化」から「パブリックネットワークの設定」で「許可されたアプリの一覧にあるアプリも含め、すべての着信接続をブロックする」のチェックを外してください。
またはWindows Defenderファイアウォールをすべて無効にしてください。(※撮影終了後、元に戻すことを推奨します。)

## 当日作業

* PCのチェック
  * 時計が正確であること
  * バッテリーが十分充電されていること
  * 省電設定（一定期間経過後に自動スリープになる）をオフにする
* ツール設定のチェック
  * eclipse-env.shの日食イベント時刻定義が正確であること。（UTCで記載。現地時刻ではありません。）
* カメラ接続
  * カメラのバッテリーを抜き差しした後、USB接続する。
* ツール起動
  * run.batを実行。

あとは皆既日食を目で楽しみましょう！

## ライセンス

BSDライセンスに準拠します。完全な動作保証ならびに発生した結果について一切の責任を負いません。
