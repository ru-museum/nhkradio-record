# nhkradio-record
NHKラジオ放送番組録音（第1、第2、FM）

- これはNHKラジオ放送（らじる★らじる：第1、第2、FM）の番組を**録音**するものです。
- 放送中の全ての番組を録音出来ます（定時録音も可能）。

[NHKラジオ らじる★らじる / ネットラジオ番組表](https://www.nhk.or.jp/radio/hensei/)  

# 動作環境  
- Linux（Debian: bash 使用）
- ffmpeg のインストールが必要です。

# 録音方法  
1. 作業フォルダを作成し nhkradio-record.sh を置きます。  

2. nhkradio-record.sh にアクセス権の実行を許可します。  
 ```
 # chmod 755 nhkradio-record.sh
 ```
3. オプションを付して実行します。  
  **【設定値】**  
  
<table>
<tr>
  <th>オプション</th><th>記述</th><th>説明</th>
</tr>  

<tr>
  <td>ヘルプ</td>
  <td>-h　|　--help  </td>
  <td>
 ヘルプを表示します。
  </td>
</tr>

<tr>
  <td>チャンネル</td>
  <td>-c　 [　r1　|　r2　|　fm　]</td>
  <td>
    録音するNHKラジオ放送のチャンネルを指定します。 
<table>
<tr>
  <td>ラジオ第1</td><td>r1</td>
</tr>
<tr>
  <td>ラジオ第2</td><td>r2</td>
</tr>
<tr>
  <td>NHK-FM</td><td>fm</td>
</tr>
</table>
    ※ デフォルト(未入力)は ラジオ第1 （r1）が設定されます。
  </td>
</tr>
  
<tr>
  <td>録音時間</td>
  <td>-r　00:00:00  </td>
  <td>
 録音する時間を指定します。<br>  
 【例】-r　00:30:00 （30分）<br>  
 ※ デフォルト(未入力)は15分
  </td>
</tr>

  
<tr>
  <td>番組タイトル</td>
  <td>-t　TITLE</td>
  <td>
録音する番組タイトル名。<br>  
【例】-t NHKきょうのニュース<br>  
※ 無記入の場合は、「NHKR1放送番組」が設定されます。
  
  </td>
</tr>

  
<tr>
  <td>開始時刻の遅延</td>
  <td>-s　[　60　|　00m　00s　]</td>
  <td>
 開始時刻を遅延させます（予約的機能として使用されます）<br>  
【例】-s 60 　　：60秒後に録音開始<br>  
　　　-s 5m 30s ：5分30秒後に録音開始<br>  
※ "5m" と "30s" の間には<strong>スペース</strong>が必要です。  
  </td>
</tr>
</table>

**【実行例】**  
　※ シェルは **bash** を使用して下さい。
- ラジオ第1番組「NHKきょうのニュース」を 15 分間録音  
  $ **bash ./nhkradio-record.sh -c r1 -r 00:15:00 -t NHKきょうのニュース**    
- 同 5 分 30 秒後に録音（予約）  
  $ **bash ./nhkradio-record.sh -c r1 -r 00:15:00 -t NHKきょうのニュース -s 5m 30s**    
  

# 定時録音
  
- CRON を使い定時に自動録音が可能です。
- **username** には通常 root か ユーザー名 が入ります。  
　※ シェルは **bash** を指定して下さい。
```
# vi /etc/crontab  

// 月〜金曜日 7 時 50 分に起動し 8 分間録音する。　
50 7 * * 1-5 username bash /your/directory/name/nhkradio-record.sh -c r1 -r 00:08:00 -t ニュース・天気予報  
```

### 録音開始時間の微調整   
- 回線状況や配信（放送時刻）とPCの時計の時刻が正確に合致していない場合など、録音開始時間に**誤差**の生じる場合があります。  
- 当方の PC の内蔵時計では日本標準時との誤差は 0.2 秒でしたが、**36秒**の遅延調整が必要でした。  
　　[情報通信研究機構/日本標準時](https://www.nict.go.jp/JST/JST5.html)

**(A)** 開始時刻を遅らせる場合：録音開始時間調整の　**sleep** の値を変更します（初期値：0）。  

　【例】開始時刻を**36秒**遅らせる  
- オプションで指定する場合：-s **36**  
　　……/nhkradio-record.sh ……… **-s 36**  

- 直接書き換える場合：
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

# テスト  
- 録音時間を**10秒**程度に設定し実動テストをして下さい。  
 　※ シェルは **bash** を使用して下さい。
```
$ bash ./nhkradio-record.sh -c r1 -r 00:00:10 -t NHK番組録音テスト
```

# 録音ファイル  

- 録音データファイルはスクリプトファイルのあるディレクトリに保存されます。  
- 保存された **m4a** は音声データフォーマットであり、iTunes や通常のプレイヤーで視聴出来ます。 

# 注意  
- 配信 URL は時期は不明ですが変更されています。  
旧URL: "https://nhkradioakr2-i.akamaihd.net/hls/live/511929/1-r2/1-r2-01.m3u8"  
新URL: "https://radio-stream.nhk.jp/hls/live/2023501/nhkradiruakr2/master.m3u8"
- **録音データは著作権上私的利用のみに限定されていますのでご注意下さい。**



