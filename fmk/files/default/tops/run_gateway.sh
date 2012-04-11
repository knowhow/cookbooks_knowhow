#!/bin/bash

RUN_GATEWAY=`ps ax | grep -v grep | grep -c gateway.exe`

if [[ ! $RUN_GATEWAY -eq 0 ]]
then
  sudo killall gateway.exe
fi


sudo wine c:\\tops\\gateway.exe &

