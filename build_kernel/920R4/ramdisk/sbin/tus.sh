#!/system/bin/sh

# Tweak VM and Swap
echo "120"	> /proc/sys/vm/swappiness
echo "120"	> /sys/fs/cgroup/memory/sw/memory.swappiness
echo "35"	> /proc/sys/vm/vfs_cache_pressure
echo "500"	> /proc/sys/vm/dirty_writeback_centisecs
echo "1000"	> /proc/sys/vm/dirty_expire_centisecs
echo "25"	> /sys/module/zswap/parameters/max_pool_percent

#set bigger swap area
swapoff /dev/block/vnswap0
echo "1932525568" > /sys/block/vnswap0/disksize
mkswap /dev/block/vnswap0
swapon /dev/block/vnswap0

#  Start SuperSU daemon
#  Wait for 5 seconds from boot before starting the SuperSU daemon
sleep 5
/system/xbin/daemonsu --auto-daemon &

#  Set interactive governor tuning
#  Wait for 10 seconds from boot so we can ovverride TouchWiz's overrides
sleep 5

#set apollo interactive governor
echo "10000" 	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
echo "50000" 	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
echo "85" 	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
echo "900000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
echo "1" 	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
echo "25000" 	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
echo "80" 	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
echo "15000" 	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
echo "15000" 	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack

#set atlas interactive governor
echo "10000 1600000:3000 1704000:3000 1800000:3000 1896000:3000 2000000:3000 2100000:3000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
echo "40000" 	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration
echo "95" 	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
echo "1200000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
echo "1" 	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
echo "15000" 	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
echo "90" 	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
echo "15000" 	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
echo "15000" 	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack

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
