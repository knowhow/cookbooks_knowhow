#!/bin/bash

RUN_GATEWAY=`ps ax | grep -v grep | grep -c gateway.exe`

if [[ ! $RUN_GATEWAY -eq 0 ]]
then
  killall gateway.exe
fi

wine c:\\tops\\gateway.exe &

