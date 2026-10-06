#!/system/bin/sh

# Wait until the device actually registers an IP address on wlan0
while [ -z "$(ip addr show wlan0 | grep 'inet ')" ]; do
    sleep 3
done

# Extra safety buffer to let the network stack settle down
sleep 5

# Start native button controller daemon
/system/bin/wink_manager &

# Run the Zigbee Socat Server for Home Assistant tracking on local port 54321
(
    while true; do
        /system/bin/socat -d -d -ls tcp-l:54321,reuseaddr,fork file:/dev/ttymxc1,nonblock,raw,echo=0,b57600,icanon=0,parenb=0,cstopb=0,cs8
        sleep 10
    done
) &

# Run the standalone WallPanel crash monitoring daemon loop
/data/local/tmp/monitor_wp.sh &
