# nhkradio-record
NHKラジオ放送番組録音（AM/FM）

# 概要
- これはNHKラジオ放送（NHK ONE らじる★らじる：AM / FM）の番組を**録音**するものです。
- 放送中の全ての番組を録音出来ます（定時・予約録音）。
- 番組名指定（主に文化・教育分野）の定期録音が出来ます(CRON)。
- **nhkradio-record-lite** (旧版) は番組名指定は出来ません。

### 【注意】
- 2026年度のNHK番組改定（3月30日）に伴う再編（2波体制）に対応すると共に各種機能強化を行いました。  
[ラジオ再編](https://www.nhk.or.jp/radio/saihen/)  
[NHKラジオ らじる★らじる / ネットラジオ番組表](https://www.nhk.or.jp/radio/hensei/)  

# 動作環境  
- Linux（Debian: bash 使用）
- ffmpeg のインストールが必要です。
 ```
 # apt-get install ffmpeg
 ```

# 録音方法  
1. 作業フォルダを作成し nhkradio-record.sh を置きます。  

2. nhkradio-record.sh にアクセス権の実行を許可します。  
 ```
 # chmod 744 nhkradio-record.sh (-rwxr--r--)
 ```
3. オプションを付して実行します。  
  **【設定値】**  
  
<table>
<tr>
  <th>オプション</th><th>コマンド</th><th>説明</th>
</tr>  

<tr>
  <td>ヘルプ</td>
  <td>-h</td>
  <td>
 ヘルプ及び「番組表」を表示します。
  </td>
</tr>

<tr>
  <td>録音する番組</td>
  <td>-i [ ID ]</td>
  <td>
 「番組表」より録音する番組の「ID番号」を指定します。<br>  
 【例】-i 12 <br>  
 ※ 指定の無い場合「NHKラジオ放送番組」が設定されます。
  </td>
</tr>

<tr>
  <td>放送波（チャンネル）</td>
  <td>-w [ am | fm ]</td>
  <td>
    録音するNHKラジオ放送のチャンネルを指定します。 
<table>
<tr>
  <td>NHK-AM</td><td>am</td>
</tr>
 <tr>
  <td>NHK-FM</td><td>fm</td>
</tr>
</table>
    ※ デフォルト(未入力)は NHK-FM （fm）が設定されます。
  </td>
</tr>
  
<tr>
  <td>録音時間</td>
  <td>-r [ 00:00:00 ]  </td>
  <td>
 録音する時間を指定します。<br>  
 【例】-r　00:30:00 （30分）<br>  
 ※ デフォルト(未入力)は15分
  </td>
</tr>

  
<tr>
  <td>番組タイトル</td>
  <td>-t [ TITLE ]</td>
  <td>
録音する番組タイトル名。<br>  
【例】-t NHKきょうのニュース<br>  
※ 無記入の場合は、「NHKAM放送番組」が設定されます。
  </td>
</tr>

 <tr>
  <td>録音ディレクトリ</td>
  <td>-d [ directory ]</td>
  <td>
 保存ディレクトリ名を指定します。<br>  
 【例】-d audio <br>  
 ※ 指定の無い場合は「ID番組名」か直下に保存されます。
  </td>
</tr>
  
<tr>
  <td>開始時刻の遅延</td>
  <td>-s [ 60 | 1h50m30s ]</td>
  <td>
 開始時刻を遅延させます（予約的機能として使用されます）<br>  
【例】-s 60s (or 60) ：60秒後に録音開始<br>  
　　　-s 1h5m30s　：1時間5分30秒後に録音開始<br>  
※ "h" "m" "s" の間には「スペース」を挟みません。<br>
※ スクリプト上では、「sleep 1h 5m 30s」と表記します。   
  </td>
</tr>
</table>

**【実行例】**  
　※ シェルは **bash** を使用して下さい。<br>
　※ オプション -d  の指定の無い場合は、直下に保存されます。<br>
　(1) NHK-AM番組を「NHKニュース」として 15 分間録音<br>
  　　 $ **bash ./nhkradio-record.sh -w am -r 00:15:00 -t NHKきょうのニュース**<br>  
　(2) 30分後（予約）にNHK-AM番組を「NHKニュース」として 15 分間録音しディレクトリ「audio」に保存<br>
  　　 $ **bash ./nhkradio-record.sh -w am -r 00:15:00 -t NHKニュース -d audio -s 30m**<br>  
　(3) 番組表による「番組ID」を指定し 5 分 30 秒後に録音（予約）<br>
　　　※ ファイルは「番組名ディレクトリ」に保存されます(/番組名ディレクトリ/番組名ファイル)。<br>
  　　 $ **bash ./nhkradio-record.sh -i 4 -s 5m30s**<br>    
  

# 定時録音
  
- CRON を使い定期的に自動定時録音が可能です。
- **username** には通常 root か ユーザー名 が入ります。  
　※ シェルは **bash** を指定して下さい。
```
# vi /etc/crontab  

// 月〜金曜日 7 時 50 分に起動し 8 分間録音する。　
50 7 * * 1-5 username bash /your/directory/name/nhkradio-record.sh -w am -r 00:08:00 -t ニュース・天気予報  

// 「番組ID」を指定し月〜金曜日 7 時 50 分に起動し録音(番組指定により通常 15 分)する。　
50 7 * * 1-5 username bash /your/directory/name/nhkradio-record.sh -i 23  
　　※ ファイルは「番組名ディレクトリ」に保存されます(/番組名ディレクトリ/番組名ファイル)。

// 同上「保存ディレクトリ」を指定　
50 7 * * 1-5 username bash /your/directory/name/nhkradio-record.sh -i 23 -d nhk 
　　※ ファイルは指定の「nhk」に保存されます(/nhk/番組名ファイル)。
```

### 録音開始時間の微調整   
- 回線状況や配信（放送時刻）とPCの時計の時刻が正確に合致していない場合など、録音開始時間に**誤差**の生じる場合があります。  
- 当方の PC の内蔵時計では日本標準時との誤差は 0.2 秒でしたが、およそ**36秒**の遅延調整が必要でした。  
　　[情報通信研究機構/日本標準時](https://www.nict.go.jp/JST/JST5.html)

**(A)** 開始時刻を遅らせる場合：録音開始時間調整の　**sleep** の値を変更します（初期値：0）。  

　【例】開始時刻を**36秒**遅らせる  
- オプションで指定する場合：-s **36**  
　　……/nhkradio-record.sh ……… **-s 36**  

- 直接スクリプトを書き換える場合：
```
SLPSECONDS=36 # 開始時刻遅延初期値： 秒

或いは、

sleep 36　  
```
- CRON でも時間の**ずれ**を修正することが出来ます。  
　**40** 秒を設定する場合：**sleep 40;**（<strong>；</strong>に注意）  
 ```
// 月〜金曜日 7 時 50 分に起動、40 秒後に開始し 8 分間録音する。　
50 7 * * 1-5 sleep 40; username bash /your/directory/name/nhkradio-record.sh …………  
```

**(B)** 開始時刻を早める場合（稀なケース）： CRON で行います（CRON の再起動が必要）。  
　例：録音開始時刻を**20秒**早める：開始時刻を**1分**早め（初期値：50 ⇒ 49）開始時刻まで**40秒** sleep させます。
```
sleep 40

# CRON
49 8 * * 1-5 sleep 40; username bash /your/directory/name/nhkradio-record.sh ………… 
```

# 実働前テスト  
- 録音時間を**10秒**程度に設定し実動前のテストを行って下さい。  
 　※ シェルは **bash** を使用して下さい。
```
$ bash ./nhkradio-record.sh -w am -r 00:00:10 -t NHK番組録音テスト
　※ 直下に「NHK番組録音テスト.m4a」が保存されれば正常終了です。
```

# 録音ファイル  

- 録音データファイルは指定の無い場合、スクリプトファイルのあるディレクトリに保存されます。  
- 保存された **m4a** は音声データフォーマットであり、iTunes や通常のプレイヤーで視聴出来ます。 

# 注意  
- ストリーミング配信URLは変更されています。  
<!--
旧URL: "https://nhkradioakr2-i.akamaihd.net/hls/live/511929/1-r2/1-r2-01.m3u8"  
新URL: "https://radio-stream.nhk.jp/hls/live/2023501/nhkradiruakr2/master.m3u8"
-->
　【東京の場合】  
　　　AM: https://simul.drdi.st.nhk/live/3/joined/master.m3u8  
　　　FM: https://simul.drdi.st.nhk/live/5/joined/master.m3u8  
  　　※ 回線の都合等、他地域からの配信が必要な場合は、以下でURIを取得出来ます。  
    　　　ソース内の**番号部分**を変更して下さい。  
  　　　https://www.nhk.or.jp/radio/config/config_web.xml

- **録音データは著作権上私的利用のみに限定されていますのでご注意下さい。**



