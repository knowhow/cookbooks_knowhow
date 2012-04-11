#!/bin/bash

RUN_TOPS=`ps ax | grep -v grep | grep -c dosemu.*tops.*ee`

if [[ ! $RUN_TOPS -eq 0 ]]
then
    sudo killall dosemu.bin
fi

#full screen
#dosemu -w -E c:\\tops\\ee_dosem.bat &

dosemu -E c:\\tops\\ee_dosem.bat &
