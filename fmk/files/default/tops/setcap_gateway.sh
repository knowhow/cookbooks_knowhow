#!/bin/sh

/sbin/setcap 'cap_net_bind_service=+ep' /usr/bin/wineserver
/sbin/setcap 'cap_net_bind_service=+ep' /usr/bin/wine-preloader

