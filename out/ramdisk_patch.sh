# Ramdisk Modification Script
# /sbin/sh

# Date Convention is Followed for Releases
RMD_VERSION=20180315;

# Define Methods

# sets recursive file permissions
set_perm_recursive() {
  dirs=$(echo $* | awk '{ print substr($0, index($0,$5)) }');
  for i in $dirs; do
    chown -R $1.$2 $i; chown -R $1:$2 $i;
    find "$i" -type d -exec chmod $3 {} +;
    find "$i" -type f -exec chmod $4 {} +;
  done;
}

# contains <string> <substring>
contains() { test "${1#*$2}" != "$1" && return 0 || return 1; }

# replace_section <file> <begin search string> <end search string> <replacement string>
replace_section() {
  begin=`grep -n "$2" $1 | head -n1 | cut -d: -f1`;
  for end in `grep -n "$3" $1 | cut -d: -f1`; do
    if [ "$begin" -lt "$end" ]; then
      if [ "$3" == " " -o -z "$3" ]; then
        sed -i "/${2//\//\\/}/,/^\s*$/d" $1;
      else
        sed -i "/${2//\//\\/}/,/${3//\//\\/}/d" $1;
      fi;
      sed -i "${begin}s;^;${4}\n;" $1;
      break;
    fi;
  done;
}

# remove_section <file> <begin search string> <end search string>
remove_section() {
  begin=`grep -n "$2" $1 | head -n1 | cut -d: -f1`;
  for end in `grep -n "$3" $1 | cut -d: -f1`; do
    if [ "$begin" -lt "$end" ]; then
      if [ "$3" == " " -o -z "$3" ]; then
        sed -i "/${2//\//\\/}/,/^\s*$/d" $1;
      else
        sed -i "/${2//\//\\/}/,/${3//\//\\/}/d" $1;
      fi;
      break;
    fi;
  done;
}

# insert_line <file> <if search string> <before|after> <line match string> <inserted line>
insert_line() {
  if [ -z "$(grep "$2" $1)" ]; then
    case $3 in
      before) offset=0;;
      after) offset=1;;
    esac;
    line=$((`grep -n "$4" $1 | head -n1 | cut -d: -f1` + offset));
    if [ "$(wc -l $1 | cut -d\  -f1)" -le "$line" ]; then
      echo "$5" >> $1;
    else
      sed -i "${line}s;^;${5}\n;" $1;
    fi;
  fi;
}

# replace_line <file> <line replace string> <replacement line>
replace_line() {
  if [ ! -z "$(grep "$2" $1)" ]; then
    line=`grep -n "$2" $1 | head -n1 | cut -d: -f1`;
    sed -i "${line}s;.*;${3};" $1;
  fi;
}

# remove_line <file> <line match string>
remove_line() {
  if [ ! -z "$(grep "$2" $1)" ]; then
    line=`grep -n "$2" $1 | head -n1 | cut -d: -f1`;
    sed -i "${line}d" $1;
  fi;
}

# append_line <file> <line>
append_line() {
  echo "$2" >> $1;
}

# replace_file <file> <permissions> <patch file>
replace_file() {
  cp -pf $3 $1;
  chmod $2 $1;
}

# Update Ramdisk Files
update_ramdisk_files() {
# Copy Modified Files
  cp -prf /tmp/anykernel/ramdisk/mods/. /tmp/anykernel/ramdisk/unpack/;
# Mark Ramdisk As Modified & Finish
  echo "$RMD_VERSION" > /tmp/anykernel/ramdisk/unpack/ramdisk_version;
}

# End Methods

# Begin Script

mkdir -p /tmp/anykernel/ramdisk/unpack;
cd /tmp/anykernel/ramdisk/unpack;
gunzip -c /tmp/anykernel/initramfs.cpio.gz | cpio -idvm;
if [[ "$(cat /tmp/anykernel/ramdisk/unpack/ramdisk_version)" -lt "$RMD_VERSION" ]] || [[ -f /tmp/anykernel/ramdisk/unpack/modified_version ]]; then
  update_ramdisk_files;
else
  cd /tmp/anykernel;
  rm -rf /tmp/anykernel/ramdisk/unpack;
  exit 0;
fi;
set_perm_recursive 0 0 0755 0755 /tmp/anykernel/ramdisk/unpack/;
ls -f;
find . | cpio -odvmH newc | gzip > /tmp/anykernel/ramdisk/unpack/initramfs.cpio.gz;
replace_file /tmp/anykernel/initramfs.cpio.gz 755 /tmp/anykernel/ramdisk/unpack/initramfs.cpio.gz;
cd /tmp/anykernel;
rm -rf /tmp/anykernel/ramdisk/unpack;
echo "Modifications Complete. Ramdisk Version set to $RMD_VERSION";

# End Script
