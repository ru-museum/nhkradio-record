#!/bin/bash

set -euo pipefail

# --------------------------------------------------
#
# NHKラジオ放送番組録音（AM、FM）
#
# --------------------------------------------------
#【注記】
# 現在のラジオ3波（ラジオ第1放送、ラジオ第2放送、FM放送）は、
# 2026年度の番組改定(3月30日)により、「NHK AM」と「NHK FM」
# の2波に再編されました。
# 
# ストリーミング配信URL
#  AM: https://simul.drdi.st.nhk/live/3/joined/master.m3u8
#  FM: https://simul.drdi.st.nhk/live/5/joined/master.m3u8
# 放送波URLは以下で取得出来ます。
#  https://www.nhk.or.jp/radio/config/config_web.xml

URLHEAD="https://simul.drdi.st.nhk/live"
URLTAIL="master.m3u8"
# NHKラジオ放送：AM、FM
declare -A NHK_URIS=(
  ["am"]="3/joined"
  ["fm"]="5/joined"
)

# 作業ディレクトリの PATH を取得。
SCRIPT_DIR=$(cd $(dirname $0) && pwd)

# 日時生成
arr=("日" "月" "火" "水" "木" "金" "土")
DAY=`date '+%w'`
_DAY="(${arr[$DAY]})"
YEAR=`date '+%Y'`
DATE1=`date '+%m%d'`
DATE2=`date '+%H:%M'`
DATE="${YEAR}${DATE1}${_DAY}-${DATE2}"

# DEFAULT 初期値：入力値のない場合の録音設定値
CHANNEL="am"        # NHKラジオ第一放送
RECTIMES="00:15:00" # 録音時間： 15分
SLPSECONDS=0        # 開始時刻遅延： 秒
USERTITLE=""        # ユーザー設定の番組タイトル

# --------------------------------------------------
# HELPの表示
function dspHelp {
  cat <<EOM
--------------------------------------------------------------------------------------------------------------
Usage: bash ./$(basename "$0") -c [ am | fm ] -r [ 00:00:00 ] -t [ 番組タイトル ] -s [ 00(秒) | 00m 00s ]
--------------------------------------------------------------------------------------------------------------
  -h            ヘルプ（この画面）を表示します。
  -c [VALUE]    録音するNHKラジオ放送のチャンネルを指定します。
                [設定値]  NHK-AM ： am
                          NHK-FM ： fm
                【例】-c am（NHK-AM）
                ※ デフォルト(未入力)は NHK-AM （am）が設定されます。
  -r [VALUE]    録音する時間を指定します。
                    【例】-r 00:30:00 （30分）
                ※ デフォルト(未入力)は15分
  -t [VALUE]    録音する番組タイトル名。
                    【例】-t NHKきょうのニュース
                ※ 無記入の場合は、「NHKAM放送番組」が設定されます。
  -s [VALUE]    開始時刻を遅延させます（予約的機能として使用されます）
                    【例】-s 60 　　：60秒後に録音開始
                      　　-s 5m 30s ：5分30秒後に録音開始
                      ※ "5m" と "30s" の間には[スペース]が必要です。

  ※ 録音データファイルは、このスクリプトファイルのあるディレクトリに保存されます。


EOM

   exit 2
}

# --------------------------------------------------
# OPTION 引数別の処理定義
while getopts ":c:r:s:t:h" optKey; do
  case "$optKey" in
    # OPTION 入力値
    c)
      CHANNEL="${OPTARG}"     # 放送チャンネル
      ;;
    r)
      RECTIMES="${OPTARG}"    # 録音時間
      ;;
    s)
      SLPSECONDS="${OPTARG}"  # 開始時刻遅延
      ;;
    t)
      USERTITLE="${OPTARG}"   # ユーザー設定の番組タイトル
      ;;
    '-h'|'--help'|* )
      dspHelp
      ;;
  esac
done

# 放送チャンネルによるURI
if [ $CHANNEL != "" ]; then
   M3U8URL="${URLHEAD}/${NHK_URIS[$CHANNEL]}/${URLTAIL}"
fi

# 処理メッセージ：１
echo ">> 録音処理の準備を行っています"

# ユーザー設定の番組タイトル
TITLE="${USERTITLE}"
# 指定が無ければ "NHK-AM放送番組"
if [ "$TITLE" = "" ]; then
   TITLE="NHK${CHANNEL^^}放送番組"
fi

# 保存ディレクトリ / 保存ファイル名
SAVEFILE_PATH="${SCRIPT_DIR}/${TITLE}-${DATE}"

# 録音時間設定：　時：分：秒　
# 秒で設定する場合： "900"（15分 x 60秒）
if [ $RECTIMES != "" ]; then

  REC_TIME="${RECTIMES}" # デフォルト値："00:15:00"

  # 処理メッセージ：２
  echo ">> 録音時間は　${RECTIMES}　に設定されました"

fi

# 開始時刻を遅延させる： 秒
# sleep 5m 50s （分：秒）
if [ $SLPSECONDS != "" ]; then

  # 処理メッセージ：３
  echo ">> 録音処理中です：待機時間は　$SLPSECONDS　( 秒 | 分秒 )です"
  
  sleep $SLPSECONDS

fi

# 録音したファイルを保存
if [ $CHANNEL != "" ]; then

  # 処理メッセージ：４
  echo ">> 録音処理中です"

  # 録音して保存
  ffmpeg -i "${M3U8URL}" -loglevel error -t "${REC_TIME}" -c copy "${SAVEFILE_PATH}".m4a

  # 処理メッセージ：５
  echo ">> 録音処理は正常に終了しました"

else
  echo "OPTION: -i [ID] で番号を指定して下さい" 1>&2
  exit 1
fi

exit
