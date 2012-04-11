#!/bin/bash

AUTHOR=hernad@bring.out.ba
VER=1.0.0
DATE=02.04.2012

echo $AUTHOR,  $VER, $DATE


USER=bringout
WINEPREFIX=~/.wine_tremol
EXE_PATH="C:\\Tremol\\FP_server.exe"
EXE=FP_exe
FISC_DIR=$WINEPREFIX/drive_c/fiscal
XVFB=0
SMB=0
# broj procesa koji se prate 
PS_CNT=1

PATH=/usr/bin:/usr/sbin:/bin:/usr/local/sbin:/usr/local/bin


usage () 
{
  echo usage: $0 start, stop, restart,  status 
}


xvfb() {

rm /tmp/Xvfb_101.log
echo start XvFb
export DISPLAY=:101  
echo run: su - $USER -c 'Xvfb :101 -ac &'
su - $USER -c "Xvfb :101 -ac &> /tmp/Xvfb_101.log&"
echo run: sleep 5
sleep 5


}

start () {


echo rm logs
rm /tmp/${EXE}_wine.log

if [[ "$XVFB" == "1" ]] ; then
  xvfb
fi

echo run: su - $USER -c "wine '$EXE_PATH'"
su - $USER -c "WINEPREFIX=$WINEPREFIX wine '$EXE_PATH' &> /tmp/${EXE}_wine.log&" > /dev/null

}

stop () {

echo ubijam sve procese i njihove aplikacije
killall wine

if [[ "$XVFB" == "1" ]] ; then
  killall Xvfb
fi

killall $EXE

CNT=`ps ax | grep $EXE | grep -c -v "grep"`

if [ $CNT -eq 0 ]
then
  echo "uspjesno ubijeni procesi ... bye ..."
  
else
  echo "CNT proces = $CNT ?!"
  
fi

}

restart () {

stop 
start 
status

}

status() {

echo "required process status:"
echo "---------------------------------------------------------------"

if [[ $XVFB == "1" ]] ; then
  ps ax | grep "Xvfb" | grep -v "grep"
fi

ps ax | grep $EXE | grep  -v "grep"

if [[ $SMB == "1" ]] ; then
  ps ax | grep "smbd" | grep  -v "grep" | grep Ss 
fi

echo " "
echo " "
echo "fiscal root dir $FISC_DIR:"
echo "---------------------------------------------------------------"
ls -l  $FISC_DIR
echo " "
echo " "
echo "fiscal answer dir $FISC_DIR/answer:"
echo "---------------------------------------------------------------"
ls -l  $FISC_DIR/answer
echo " "
echo " "

CNT=0

if [[ $XVFB == "1" ]] ; then
  let CNT=`ps ax | grep "Xvfb" | grep -c -v "grep"`
fi

let CNT=CNT+`ps ax | grep $EXE | grep  -c -v "grep"`

if [[ $SMB == "1" ]] ; then
  let CNT=CNT+`ps ax | grep "smbd"| grep Ss | grep  -c -v "grep"`
fi

if [ $CNT = $PS_CNT ]
then
  echo "" 
  echo "" 
  echo "" 
  echo "" 
  echo "$EXE wine app status OK, cnt = $CNT"
  echo "" 
  echo "" 
  echo "" 
  echo "" 
  exit 0
else
  echo "$EXE not started !"
  exit -1
fi


}

if [ "$1" == "" ]
then
    usage
    exit -1
fi


case "$1" in

   start )
        start  
        ;;

   stop )

       stop 
       ;;
   
   status )

      status 
      ;;
   restart )
      
      restart 
      ;;
    
esac

