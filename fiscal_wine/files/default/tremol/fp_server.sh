#!/bin/bash

CUR_DIR=`pwd`

USER=`whoami`
DISPLAY=:0
export PATH=/opt/knowhowERP/util:/usr/bin:/bin:/usr/sbin:/sbin


export WINEDEBUG="-all,-shell,-thread,+ole"

for f in 1 2 3 4 5 6 7 8 9
do

FP_SERVER=`ps ax | grep -v grep | grep -c FP_Server.exe`

if [[ ! $FP_SERVER -eq 0 ]]; then

  echo $f : killall FP_Server.exe
  killall FP_Server.exe

else
  echo $f : nema aktivnih procesa FP_Server.exe
  break
fi

done

if [[ "$WINEPREFIX" == "" ]];then
   export WINEPREFIX=~/.wine_tremol
fi

cd $WINEPREFIX

DEST_CONFIG=drive_c/users/$USER/Application\ Data/Tremol/FP_Server.config

cp -av FP_server_minimize.config "$DEST_CONFIG"

echo WINEPREFIX=$WINEPREFIX

cd $WINEPREFIX/drive_c/Tremol/Tools
wine FP_Server.exe  &>$WINEPREFIX/wine.log & 
cd $CUR_DIR

