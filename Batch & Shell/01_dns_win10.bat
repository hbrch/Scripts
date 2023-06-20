REM Created 25.04.2023
REM Changes the IP, Subnet, Gateway and primary and secondary DNS Servers
REM Made for the latest Windows 10 Version
@echo off
title Network settings changer

setlocal enabledelayedexpansion

REM DNS Variables
set primaryDNS=192.168.1.1
set secondaryDNS=192.168.1.254
set ip_addr=192.168.1.83
set custom_subnet=255.255.255.0
set custom_gateway=192.168.1.254

echo Please choose:
echo 1) Custom (static IP Address)
echo 2) DHCP (dynamic IP Address)
echo 3) Exit

set /p choice=

REM Choice 1 = Custom
if "%choice%"=="1" (
    echo Configuring Network...
    REM 1: IP Adress; 2: Subnetmask; 3: Standardgateway
    netsh interface ipv4 set address name="Ethernet" static %ip_addr% %custom_subnet% %custom_gateway%
    netsh interface ipv4 set dns name="Ethernet" static %primaryDNS% primary
    netsh interface ipv4 add dns name="Ethernet" %secondaryDNS% index=2
    echo Finished.
    
REM Choice 2 = DHCP
) else if "%choice%"=="2" (
    echo Configuring Network...
    REM DNS and IP will be set using DHCP
    netsh interface ip set address name="Ethernet" source=dhcp
    netsh interface ip set dns name="Ethernet" source=dhcp
    netsh interface ip set address name="Wi-Fi" source=dhcp
    netsh interface ip set dns name="Wi-Fi" source=dhcp
    echo Finished.

REM Choice 3 = Exit
) else if "%choice%"=="3" (
    echo Exiting...
    exit
) else (
    echo Wrong choice. Please enter 1, 2 or 3.
    pause
)
