@echo off
:pocetak
cls
@echo ******************** Grbavica - 02 ******************** RS br.1 ****
@echo .
@echo A. TOPS  trgovacka kasa         K. install TOPS    L. arhiva TOPS 
@echo ----------------------------------------------------------------------
@echo 9. Kraj
be ask "->" AKL9 DEF=9 bright yellow
if errorlevel  4 goto KRAJ
if errorlevel  3 goto ATOPS
if errorlevel  2 goto ITOPS
if errorlevel  1 goto TOPS
goto kraj
:TOPS
C:
cd C:\KASE\TOPS
TOPS 21 21
cd C:\KASE
goto pocetak
:ITOPS
C:
cd C:\KASE\TOPS
ITOPS 21 21
cd C:\KASE
goto pocetak
:ATOPS
C:
cd C:\KASE\TOPS
CALL ARHIVA 21 21
cd C:\KASE
goto pocetak
:kraj
cls
