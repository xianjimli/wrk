#!/bin/bash

C=1000 #connections
T=1000 #Thread
D=100 #Duration
JSON=$1
SCRIPT=scripts/run.lua
LINK="-v /etc/hosts:/etc/hosts"
URL= #fill url at here

if [[ -z "$JSON" ]]
then
  JSON="scripts/default.json"
fi

echo docker run --rm $LINK -v `pwd`/scripts:/scripts -v `pwd`/data:/data wrk-json wrk \
    -c"$C" -t"$T" -d"$D"s -s /$SCRIPT $URL $JSON
docker run --rm $LINK -v `pwd`/scripts:/scripts -v `pwd`/data:/data wrk-json wrk \
    -c"$C" -t"$T" -d"$D"s -s /$SCRIPT $URL $JSON

