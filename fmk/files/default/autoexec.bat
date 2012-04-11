@echo off
path c:\tops;c:\sigma;c:\bout;z:\bin;z:\gnu;z:\dosemu
set TEMP=c:\tmp
prompt $P$G
unix -s DOSDRIVE_D
if "%DOSDRIVE_D%" == "" goto nodrived
lredir del d: > nul
lredir d: linux\fs%DOSDRIVE_D%
:nodrived
unix -s DOSEMU_VERSION
echo Welcome to dosemu %DOSEMU_VERSION%!
unix -e

echo c:\bout je lokacija FMK exe fajlova
echo.
echo Podesite font terminala na FreeMono
