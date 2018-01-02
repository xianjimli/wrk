#!/bin/bash

C=5000 #connections
T=5000 #Thread
D=100 #Duration

URL=$1
JSON=$2
SCRIPT=scripts/run.lua

if [[ -z "$JSON" ]]
then
  JSON="data/status.json"
fi

if [[ -z "$URL" ]]
then
  URL="https://www.zlgcloud.com"
fi
ulimit -n 10240
export LUA_PATH=/usr/local/wrk/?.lua
wrk-json -c"$C" -t"$T" -d"$D"s -s /usr/local/wrk/$SCRIPT $URL $JSON
