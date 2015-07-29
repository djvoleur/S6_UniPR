#!/system/bin/sh

# Tweaks
echo "140"	> /proc/sys/vm/swappiness
echo "35"	> /proc/sys/vm/vfs_cache_pressure
echo "500"	> /proc/sys/vm/dirty_writeback_centisecs
echo "1000"	> /proc/sys/vm/dirty_expire_centisecs
echo "25"	> /sys/module/zswap/parameters/max_pool_percent

#set bigger swap area of 1.8gb
swapoff /dev/block/vnswap0
echo "1932525568" > /sys/block/vnswap0/disksize
mkswap /dev/block/vnswap0
swapon /dev/block/vnswap0

#  Start SuperSU daemon
#  Wait for 5 seconds from boot before starting the SuperSU daemon
sleep 5
/system/xbin/daemonsu --auto-daemon &

# Interactive tuning
# Wait 10 seconds total from boot
sleep 5

#set apollo interactive governor
echo "90" 	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
echo "85" 	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads

#set atlas interactive governor
echo "98" 	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
echo "95" 	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads

#gapps wakelock fix
sleep 40
su -c "pm enable com.google.android.gms/.update.SystemUpdateActivity"
su -c "pm enable com.google.android.gms/.update.SystemUpdateService"
su -c "pm enable com.google.android.gms/.update.SystemUpdateService$ActiveReceiver"
su -c "pm enable com.google.android.gms/.update.SystemUpdateService$Receiver"
su -c "pm enable com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver"
su -c "pm enable com.google.android.gsf/.update.SystemUpdateActivity"
su -c "pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity"
su -c "pm enable com.google.android.gsf/.update.SystemUpdateService"
su -c "pm enable com.google.android.gsf/.update.SystemUpdateService$Receiver"
su -c "pm enable com.google.android.gsf/.update.SystemUpdateService$SecretCodeReceiver"
