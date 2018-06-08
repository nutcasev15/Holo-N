#!/system/bin/sh
# SPECTRUM KERNEL MANAGER
# Profile initialization script by nathanchance

# Check If Spectrum App is Installed
if [[ ! -z $(pm list packages | grep "org.frap129.spectrum") ]]; then
	setprop spectrum.support 1;
fi;

# Setup Profile Metadata Folder
if [[ ! -f /storage/emulated/0/Spectrum/profile_id ]]; then
	mkdir -p /storage/emulated/0/Spectrum;
	echo 0 > /storage/emulated/0/Spectrum/profile_id;
elif [[ -f /storage/emulated/0/Spectrum/profile_id ]]; then
	setprop persist.spectrum.profile $(cat /storage/emulated/0/Spectrum/profile_id);
fi;

# If there is no persist value, we need to set one
if [ ! -f /data/property/persist.spectrum.profile ]; then
	setprop persist.spectrum.profile 0;
fi;

# This was added by Holo
