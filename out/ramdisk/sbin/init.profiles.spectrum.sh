#!/system/bin/sh
# SPECTRUM KERNEL MANAGER

# Variables
BLU_PLUG_SUPPORTED=$(if [[ -f /sys/module/blu_plug/parameters/enabled ]]; then echo true; else echo false; fi;);
MAX_NO_OC_FREQ=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies | cut -d " " -f3);
MAX_OC_FREQ=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies | cut -d " " -f1);
PROFILE_ID=$1;

# Functions

# Apply Defaults
apply_defaults() {
	chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
	echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
	chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
	chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
	echo "ondemand" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
	chmod 444 /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
	chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
	echo "ondemand" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
	chmod 444 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
	echo 1 > /sys/devices/system/cpu/cpu1/online;
	chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
	echo "ondemand" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
	chmod 444 /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
	chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
	echo $MAX_NO_OC_FREQ > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
	chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
	chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq;
	echo $MAX_NO_OC_FREQ > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq;
	chmod 444 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq;
	chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq;
	echo $MAX_NO_OC_FREQ > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq;
	chmod 444 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq;
	chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq;
	echo $MAX_NO_OC_FREQ > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq;
	chmod 444 /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq;
	chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq;
	echo 500000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq;
	chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq;
	chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq;
	echo 500000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq;
	chmod 444 /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq;
	chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq;
	echo 500000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq;
	chmod 444 /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq;
	chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq;
	echo 500000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq;
	chmod 444 /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq;
	echo 99 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold;
	echo 0 > /sys/devices/system/cpu/cpufreq/ondemand/powersave_bias;
	echo 30000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate;
	echo "Y" > /sys/module/workqueue/parameters/power_efficient;
	echo 100 > /sys/devices/virtual/misc/batterylifeextender/charging_limit;
	echo "cfq" > /sys/block/mmcblk0/queue/scheduler;
	echo 1024 > /sys/block/mmcblk0/queue/read_ahead_kb;
	echo 1 > /sys/block/mmcblk0/queue/iostats;
	echo "N" > /sys/module/sync/parameters/fsync_enabled;
	echo 1 > /sys/block/mmcblk0/queue/rq_affinity;
	if [[ $BLU_PLUG_SUPPORTED ]]; then
		echo 0 > /sys/module/blu_plug/parameters/enabled;
	fi;
	echo 128 > /proc/sys/kernel/random/read_wakeup_threshold;
	echo 128 > /proc/sys/kernel/random/write_wakeup_threshold;
	echo "performance" > /sys/devices/platform/dfrgx/devfreq/dfrgx/governor;
	echo 457000 > /sys/devices/platform/dfrgx/devfreq/dfrgx/min_freq;
}

# Profile_ID 1
apply_performance_profile() {
	chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
	echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
	chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
	chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
	echo "ondemand" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
	chmod 444 /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
	chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
	echo "ondemand" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
	chmod 444 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
	echo 1 > /sys/devices/system/cpu/cpu1/online;
	chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
	echo "ondemand" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
	chmod 444 /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
	chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
	echo $MAX_OC_FREQ > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
	chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
	chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq;
	echo $MAX_OC_FREQ > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq;
	chmod 444 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq;
	chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq;
	echo $MAX_OC_FREQ > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq;
	chmod 444 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq;
	chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq;
	echo $MAX_OC_FREQ > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq;
	chmod 444 /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq;
	chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq;
	echo 833000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq;
	chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq;
	chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq;
	echo 833000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq;
	chmod 444 /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq;
	chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq;
	echo 833000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq;
	chmod 444 /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq;
	chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq;
	echo 833000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq;
	chmod 444 /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq;
	echo 60 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold;
	echo 0 > /sys/devices/system/cpu/cpufreq/ondemand/powersave_bias;
	echo 50000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate;
	echo "N" > /sys/module/workqueue/parameters/power_efficient;
	echo 98 > /sys/devices/virtual/misc/batterylifeextender/charging_limit;
	if [[ $BLU_PLUG_SUPPORTED ]]; then
		echo "zen" > /sys/block/mmcblk0/queue/scheduler;
	else
		echo "deadline" > /sys/block/mmcblk0/queue/scheduler;
	fi;
	echo 1536 > /sys/block/mmcblk0/queue/read_ahead_kb;
	echo 0 > /sys/block/mmcblk0/queue/iostats;
	echo "Y" > /sys/module/sync/parameters/fsync_enabled;
	echo 0 > /sys/block/mmcblk0/queue/rq_affinity;
	if [[ $BLU_PLUG_SUPPORTED ]]; then
		echo 0 > /sys/module/blu_plug/parameters/enabled;
	fi;
	echo 256 > /proc/sys/kernel/random/read_wakeup_threshold;
	echo 256 > /proc/sys/kernel/random/write_wakeup_threshold;
	echo "performance" > /sys/devices/platform/dfrgx/devfreq/dfrgx/governor;
	echo 457000 > /sys/devices/platform/dfrgx/devfreq/dfrgx/min_freq;
}

# Profile_ID 2
apply_battery_profile() {
	chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
	echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
	chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
	chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
	echo "interactive" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
	chmod 444 /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
	chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
	echo "interactive" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
	chmod 444 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
	echo 1 > /sys/devices/system/cpu/cpu1/online;
	chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
	echo "interactive" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
	chmod 444 /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
	chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
	echo 1833000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
	chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
	chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq;
	echo 1833000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq;
	chmod 444 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq;
	chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq;
	echo 1833000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq;
	chmod 444 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq;
	chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq;
	echo 1833000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq;
	chmod 444 /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq;
	chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq;
	echo 500000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq;
	chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq;
	chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq;
	echo 416000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq;
	chmod 444 /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq;
	chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq;
	echo 416000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq;
	chmod 444 /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq;
	chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq;
	echo 333000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq;
	chmod 444 /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq;
	echo 100 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load;
	echo 8000 > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay;
	echo 833000 > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq;
	echo 1 > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy;
	echo 33000 > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time;
	echo 583000 > /sys/devices/system/cpu/cpufreq/interactive/sleep_max_freq;
	if [[ !$BLU_PLUG_SUPPORTED ]]; then
		echo 2 > /sys/devices/system/cpu/cpufreq/interactive/nr_cpus_sleep;
	fi;
	echo 25000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate;
	echo 25000 > /sys/devices/system/cpu/cpufreq/interactive/timer_slack;
	echo 3200 > /sys/devices/system/cpu/cpufreq/interactive/touchboostpulse_duration;
	echo 500000 > /sys/devices/system/cpu/cpufreq/interactive/touchboost_freq;
	echo "88 333000:35 416000:40 500000:50 583000:60 666000:70 750000:80 833000:82 1250000:86 1416000:90 1833000:92" > /sys/devices/system/cpu/cpufreq/interactive/target_loads;
	echo 98 > /sys/devices/virtual/misc/batterylifeextender/charging_limit;
	echo 0 > /sys/block/mmcblk0/queue/iostats;
	echo "Y" > /sys/module/sync/parameters/fsync_enabled;
	echo "Y" > /sys/module/workqueue/parameters/power_efficient;
	echo 1280 > /sys/block/mmcblk0/queue/read_ahead_kb;
	if [[ $BLU_PLUG_SUPPORTED ]]; then
		echo 1 > /sys/module/blu_plug/parameters/enabled;
		echo 4 > /sys/module/blu_plug/parameters/min_online;
		echo 4 > /sys/module/blu_plug/parameters/max_online;
		echo 1 > /sys/module/blu_plug/parameters/up_threshold;
	fi;
	echo "deadline" > /sys/block/mmcblk0/queue/scheduler;
	echo 2 > /sys/block/mmcblk0/queue/rq_affinity;
	echo 128 > /proc/sys/kernel/random/read_wakeup_threshold;
	echo 128 > /proc/sys/kernel/random/write_wakeup_threshold;
	echo "simple_ondemand" > /sys/devices/platform/dfrgx/devfreq/dfrgx/governor;
	echo 200000 > /sys/devices/platform/dfrgx/devfreq/dfrgx/min_freq;
}

# Profile_ID 3
apply_gaming_profile() {
	chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
	echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
	chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
	chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
	echo "ondemand" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
	chmod 444 /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
	chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
	echo "ondemand" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
	chmod 444 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
	echo 1 > /sys/devices/system/cpu/cpu1/online;
	chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
	echo "ondemand" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
	chmod 444 /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
	chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
	echo $MAX_OC_FREQ > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
	chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
	chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq;
	echo $MAX_OC_FREQ > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq;
	chmod 444 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq;
	chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq;
	echo $MAX_NO_OC_FREQ > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq;
	chmod 444 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq;
	chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq;
	echo $MAX_NO_OC_FREQ > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq;
	chmod 444 /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq;
	chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq;
	echo 833000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq;
	chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq;
	chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq;
	echo 833000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq;
	chmod 444 /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq;
	chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq;
	echo 750000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq;
	chmod 444 /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq;
	chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq;
	echo 500000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq;
	chmod 444 /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq;
	echo 70 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold;
	echo 0 > /sys/devices/system/cpu/cpufreq/ondemand/powersave_bias;
	echo 20000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate;
	echo 0 > /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load;
	echo 98 > /sys/devices/virtual/misc/batterylifeextender/charging_limit;
	if [[ $BLU_PLUG_SUPPORTED ]]; then
		echo "zen" > /sys/block/mmcblk0/queue/scheduler;
	else
		echo "deadline" > /sys/block/mmcblk0/queue/scheduler;
	fi;
	echo 0 > /sys/block/mmcblk0/queue/iostats;
	echo "Y" > /sys/module/sync/parameters/fsync_enabled;
	echo "Y" > /sys/module/workqueue/parameters/power_efficient;
	echo 256 > /proc/sys/kernel/random/read_wakeup_threshold;
	echo 256 > /proc/sys/kernel/random/write_wakeup_threshold;
	echo 1280 > /sys/block/mmcblk0/queue/read_ahead_kb;
	echo 0 > /sys/block/mmcblk0/queue/rq_affinity;
	if [[ $BLU_PLUG_SUPPORTED ]]; then
		echo 1 > /sys/module/blu_plug/parameters/enabled;
		echo 4 > /sys/module/blu_plug/parameters/min_online;
		echo 4 > /sys/module/blu_plug/parameters/max_online;
		echo 1 > /sys/module/blu_plug/parameters/up_threshold;
	fi;
	echo "performance" > /sys/devices/platform/dfrgx/devfreq/dfrgx/governor;
	echo 457000 > /sys/devices/platform/dfrgx/devfreq/dfrgx/min_freq;
}

# Da Script
case $PROFILE_ID in
	0)
		apply_defaults;
		echo 0 > /storage/emulated/0/Spectrum/profile_id;
		break;;
	1)
		apply_performance_profile;
		echo 1 > /storage/emulated/0/Spectrum/profile_id;
		break;;
	2)
		apply_battery_profile;
		echo 2 > /storage/emulated/0/Spectrum/profile_id;
		break;;
	3)
		apply_gaming_profile;
		echo 3 > /storage/emulated/0/Spectrum/profile_id;
		break;;
	*)
		break;;
esac;
	
# This was added by Holo

