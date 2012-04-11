@echo off
call EXTmrez.bat
cls
rem be beep /D1 /F200
rem be beep /D3 /F250
:ponovo
cls
@ echo --------- * EXT * sigma-com software ----- RS br. 1
@ echo .
@ echo Odabir firme 01-25
@ echo ------------------------------
@ echo 97. arhiviraj sve
@ echo 98. pocisti i instalisi
@ echo ------------------------------
@ echo 99. Kraj
@ echo .
@ echo .
be2
if errorlevel  99 goto KRAJ
if errorlevel  98 goto CEXT1
if errorlevel  97 goto ASVE
rem if errorlevel         25 goto Firma251
rem if errorlevel         24 goto Firma241
rem if errorlevel         23 goto Firma231
rem if errorlevel         22 goto Firma221
rem if errorlevel         21 goto Firma211
if errorlevel         20 goto Firma201
if errorlevel         19 goto Firma191
if errorlevel         18 goto Firma181
if errorlevel         17 goto Firma171
if errorlevel         16 goto Firma161
if errorlevel         15 goto Firma151
if errorlevel         14 goto Firma141
if errorlevel         13 goto Firma131
if errorlevel         12 goto Firma121
if errorlevel         11 goto Firma111
if errorlevel         10 goto Firma101
if errorlevel          9 goto Firma91
if errorlevel          8 goto Firma81
if errorlevel          7 goto Firma71
if errorlevel          6 goto Firma61
if errorlevel          5 goto Firma51
if errorlevel          4 goto Firma41
if errorlevel          3 goto Firma31
if errorlevel          2 goto Firma21
if errorlevel          1 goto Firma11
goto ponovo

:firma11
call firma11
goto ponovo

:firma21
call firma21
goto ponovo

:firma31
call firma31
goto ponovo

:firma41
call firma41
goto ponovo

:firma51
call firma51
goto ponovo

:firma61
call firma61
goto ponovo

:firma71
call firma71
goto ponovo

:firma81
call firma81
goto ponovo

:firma91
call firma91
goto ponovo

:firma101
call firma101
goto ponovo

:firma111
call firma111
goto ponovo

:firma121
call firma121
goto ponovo

:firma131
call firma131
goto ponovo

:firma141
call firma141
goto ponovo

:firma151
call firma151
goto ponovo

:firma161
call firma161
goto ponovo

:firma171
call firma171
goto ponovo

:firma181
call firma181
goto ponovo

:firma191
call firma191
goto ponovo

:firma201
call firma201
goto ponovo

:firma211
call firma211
goto ponovo

:firma221
call firma221
goto ponovo

:firma231
call firma231
goto ponovo

:firma241
call firma241
goto ponovo

:firma251
call firma251
goto ponovo

:CEXT1
cls
C:
cd C:\KASE
call cEXT1
C:
cd C:\KASE
goto ponovo
:ASVE
cls
C:
cd C:\KASE
echo MENI: ARHIVIRANJE SVIH PODATAKA
echo -------------------------------
echo  1. Arhiviranje na flopy diskete 
echo  2. Arhiviranje na tvrdi disk
echo  3. Brisanje diskete
echo  4. Formatiranje diskete
echo  5. Pregled sadrzaja diskete
echo  9. Prethodni meni
echo -------------------------------
be ask "Izaberite opciju (1/2/3/4/5/9): "  123459 DEFAULT=9
echo .
if errorlevel==6 goto ponovo
if errorlevel==5 goto FDDDIR
if errorlevel==4 goto FDDFOR
if errorlevel==3 goto FDDBRI
if errorlevel==2 goto ANAHDD
if errorlevel==1 goto ANAFDD
goto ASVE
:FDDBRI
cls
echo Stavite flopy disketu i pritisnite neku tipku
pause
echo Za brisanje sadrzaja flopy diskete kucajte Y!
del A:.
C:
cd C:\KASE
cls
goto ASVE
:FDDFOR
cls
echo Stavite floppy disketu i pritisnite neku tipku za pocetak formatiranja
format A:
C:
cd C:\KASE
cls
goto ASVE
:FDDDIR
cls
echo Stavite floppy disketu i pritisnite neku tipku radi pregleda sadrzaja diskete
pause
dir A: /p
echo Pregled zavrsen! Pritisnite neku tipku za nastavak.
pause
C:
cd C:\KASE
cls
goto ASVE
:ANAFDD
cls
echo MENI: ARHIVIRANJE SVIH PODATAKA NA DISKETE
echo -------------------------------------------------
echo  1. Arhivirati samo podatke tekuce sezone
echo  2. Arhivirati sve podatke (tekuca+prosle sezone)
echo  9. Prethodni meni
echo -------------------------------------------------
be ask "Izaberite opciju (1/2/9): "  129 DEFAULT=9
echo .
if errorlevel==3 goto ASVE
if errorlevel==2 goto ANAFDDS
if errorlevel==1 goto ANAFDDT
goto ANAFDD
:ANAFDDS
cls
echo Stavite floppy disketu i pritisnite neku tipku za pocetak arhiviranja
pause
arj a -vva -r -jt A:\EXTS C:\KASE\*.db? C:\KASE\*.fp? 
goto ANAFDDK
:ANAFDDT
cls
echo Stavite floppy disketu i pritisnite neku tipku za pocetak arhiviranja
pause
arj a -vva -jt A:\EXT !C:\KASE\LISTA.ARH
goto ANAFDDK
:ANAFDDK
echo Arhiviranje zavrseno! Pritisnite neku tipku za nastavak.
pause
C:
cd C:\KASE
cls
goto ASVE
:ANAHDD
cls
C:
cd C:\KASE
echo Pritisnite bilo koju tipku za pocetak arhiviranja na tvrdi disk
pause
del \EXT.arj
arj a -r -jt \EXT *.db? *.fp? 
echo Arhiviranje zavrseno! Pritisnite neku tipku za nastavak.
pause
C:
cd C:\KASE
cls
goto ASVE
:KRAJ
cls
exit
