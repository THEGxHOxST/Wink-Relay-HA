#!/system/bin/sh

# Start Zigbee Socat Server for Home Assistant
(
    while true; do
        /system/bin/socat -d -d -ls tcp-l:54321,reuseaddr,fork file:/dev/ttymxc1,nonblock,raw,echo=0,b57600,icanon=0,parenb=0,cstopb=0,cs8
        sleep 10
    done
) &
