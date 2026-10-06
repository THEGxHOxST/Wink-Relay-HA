# Wink-Relay-HA
Replacing wink apps tools
You'll need a TTL and WiFI connection to start

Via ADB
# Push the su binary to a temporary folder
adb push arm/su /data/local/tmp/su

# Push the Superuser app management APK
adb push common/Superuser.apk /data/local/tmp/Superuser.apk

Via TTL
# Remount the system partition as read-write
mount -o remount,rw /system

# Move the su binary and give it dual symbolic placement
cp /data/local/tmp/su /system/xbin/su
cp /data/local/tmp/su /system/bin/su

# Move the APK to the system app folder
cp /data/local/tmp/Superuser.apk /system/app/Superuser.apk

# Grant absolute ownership to root
chown 0.0 /system/xbin/su
chown 0.0 /system/bin/su

# Set permissions (6755 adds the SUID sticky bit)
chmod 6755 /system/xbin/su
chmod 6755 /system/bin/su

# Set standard application permissions for the APK
chmod 0644 /system/app/Superuser.apk

/system/xbin/su --daemon &
echo "/system/xbin/su --daemon &" >> /system/etc/install-recovery.sh
chmod 0755 /system/etc/install-recovery.sh
reboot

Via ADB
adb install /data/local/tmp/Superuser.apk

su

cd /system/app
cp Edison* /sdcard/
rm Edison*
reboot

adb push socat /sdcard/socat

mount -o rw,remount /system
cp /sdcard/socat /system/bin/socat
chmod 755 /system/bin/socat

/system/bin/socat -d -d -ls tcp-l:54321,reuseaddr,fork file:/dev/ttymxc1,nonblock,raw,echo=0,b57600,icanon=0,parenb=0,cstopb=0,cs8,waitlock=/cache/ttymxc1 </dev/null &

socat -d -d pty,link=/dev/zig,waitslave,ignoreeof tcp:192.168.20.58:54321

adb shell am start -n com.android.launcher/com.android.launcher2.Launcher

adb push wink_manager /sdcard/
adb push wink_manager.ini /sdcard/

su
# Disable the default factory launcher framework
pm disable com.quirky.android.wink.projectone

# Mount the operational filesystem tree for alterations
mount -o rw,remount /system

# Clean up and swap the default listener tool
rm /system/bin/edisonwink
cp /sdcard/wink_manager /system/bin/edisonwink

# Assign proper root execution attributes and reload
chmod 755 /system/bin/edisonwink
reboot



