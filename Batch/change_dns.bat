REM Created 27.03.2018
REM Changes the current DNS Server  

@echo off
title DNS Changer
echo.

SET adapterName=

FOR /F "tokens=* delims=:" %%a IN ('IPCONFIG ^| FIND /I "ETHERNET-ADAPTER"') DO SET adapterName=%%a

SET adapterName=%adapterName:~17%
SET adapterName=%adapterName:~0,-1%

echo -------------------------
echo 1:	Cloudflare DNS
echo 2:	Eigene DNS angeben
echo 3:	Standard DNS
echo 99:	Abbrechen
echo -------------------------
echo.
echo Bitte auswaehlen:

SET /p choice1=

IF '%choice1%' == '1' GOTO 1
IF '%choice1%' == '2' GOTO 2
IF '%choice1%' == '3' GOTO 3
IF '%choice1%' == '99' GOTO 99

:1
netsh interface ip set dnsservers "%adapterName%" static 1.1.1.1 PRIMARY
netsh interface ip add dnsservers "%adapterName%" 1.0.0.1 index=2

echo ...Fertig!
echo Aktuelle Netzwerkeinstellungen:
ipconfig /all
pause

:2
echo Bevorzugter DNS Server:
set /p dns1=
echo Alternativer DNS Server:
set /p dns2=

netsh interface ip set dnsservers "%adapterName%" static %dns1%
netsh interface ip add dnsservers "%adapterName%" %dns2% index=2

echo ...Fertig!
echo Aktuelle Netzwerkeinstellungen:
ipconfig /all
pause

:3
netsh interface ip set dnsservers "%adapterName%" static 192.168.1.1 PRIMARY
netsh interface ip add dnsservers "%adapterName%" 192.168.1.254 index=2

echo ...Fertig!
echo Aktuelle Netzwerkeinstellungen:
ipconfig /all
pause
