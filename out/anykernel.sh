# AnyKernel 2.0 Ramdisk Mod Script 
# osm0sis @ xda-developers

## AnyKernel setup
# EDIFY properties
kernel.string=AnyKernel_Script
do.devicecheck=1
do.initd=1
do.modules=0
do.cleanup=0
device.name1=Z00A
device.name2=Z008
device.name3=Z00AD
device.name4=
device.name5=

# shell variables
block=/dev/block/by-name/boot;
match=0;

## end setup


## AnyKernel methods (DO NOT CHANGE)
# set up extracted files and directories
ramdisk=/tmp/anykernel/ramdisk;
bin=/tmp/anykernel/tools;
split_img=/tmp/anykernel/split_img;
patch=/tmp/anykernel/patch;

chmod -R 777 $bin;
mkdir -p $ramdisk $split_img;
#cd /tmp/anykernel;

OUTFD=`ps | grep -v "grep" | grep -oE "update(.*)" | cut -d" " -f3`;
ui_print() { echo "ui_print $1" >&$OUTFD; echo "ui_print" >&$OUTFD; }

# dump boot and extract ramdisk
dump_boot() {
  dd if=$block of=/tmp/anykernel/boot.img;
  /tmp/anykernel/tools/unmkbootimg /tmp/anykernel/boot.img;
   #/tmp/anykernel/tools/unmkbootimg /tmp/anykernel/boot.img;
  if [ $? != 0 ]; then
    ui_print "Dumping/unpacking image failed. Aborting...";
    echo "Unpack Failed" > /tmp/anykernel/exitcode; exit;
  fi;
}

file_getprop() { grep "^$2" "$1" | cut -d= -f2; }
getprop() { test -e /sbin/getprop && /sbin/getprop $1 || file_getprop /default.prop $1; }
mount -o ro /system;

# repack ramdisk then build and write image
write_boot() {
  /tmp/anykernel/tools/mkbootimg --kernel /tmp/anykernel/bzImage --ramdisk /tmp/anykernel/initramfs.cpio.gz --cmdline "init=/init pci=noearly loglevel=0 vmalloc=256M androidboot.hardware=mofd_v1 watchdog.watchdog_thresh=60 androidboot.spid=xxxx:xxxx:xxxx:xxxx:xxxx:xxxx androidboot.serialno=01234567890123456789 snd_pcm.maximum_substreams=8 ip=50.0.0.2:50.0.0.1::255.255.255.0::usb0:on debug_locks=0 bootboost=1 androidboot.selinux=permissive" --base 0x10000000 --pagesize 2048 --ramdisk_offset 0x01000000 --tags_offset 0x00000100 --second /tmp/anykernel/second.gz -o /tmp/anykernel/boot-new.img;

if [ "$(file_getprop /tmp/anykernel/anykernel.sh do.devicecheck)" == 1 ]; then
  ui_print "Checking device...";
    testname="$(file_getprop /tmp/anykernel/anykernel.sh device.name1)";
    if [ "$(getprop ro.product.device)" == "$testname" -o "$(getprop ro.build.product)" == "$testname" ]; then
      match=1;
    cat boot-new.img /tmp/anykernel/Z00A.sig > boot1.img;
    mv boot1.img boot-new.img;
    dd if=/tmp/anykernel/boot-new.img of=$block;
    fi;
  ui_print " ";
  if [ "$match" == 0 ]; then
    cat boot-new.img /tmp/anykernel/Z008.sig > boot1.img;
    mv boot1.img boot-new.img;
    dd if=/tmp/anykernel/boot-new.img of=$block;
  fi;
fi;

}

## end methods

## AnyKernel install
dump_boot;

write_boot;

## end install
