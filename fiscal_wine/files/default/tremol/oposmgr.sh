#!/bin/bash

USER=`whoami`
DISPLAY=:0
export PATH=/opt/knowhowERP/util:/usr/bin:/bin:/usr/sbin:/sbin

CUR_DIR=`pwd`


if [[ "$WINEPREFIX" == "" ]];then
   export WINEPREFIX=~/.wine_tremol
fi

echo WINEPREFIX=$WINEPREFIX

cd $WINEPREFIX/drive_c/Tremol
wine OposMngr.exe
cd $CUR_DIR

