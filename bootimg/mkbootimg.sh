#!/sbin/sh
mkdir /tmp/newramdisk
cd /tmp/newramdisk
gunzip -c /tmp/boot.img-ramdisk.gz | cpio -i
if [ -d /tmp/ramdisk ]; then
    cp -rf /tmp/ramdisk/. .
else
    if [ ! -f /tmp/zImage ]; then
        [ -d /sdcard/BootImage ] || mkdir -p /sdcard/BootImage
        [ -d /sdcard/BootImage/ramdisk ] && rm -rf /sdcard/BootImage/ramdisk
        cp -rf /tmp/newramdisk /sdcard/BootImage/ramdisk
        cp -f /tmp/boot.img-zImage /sdcard/BootImage/zImage
    fi
fi
find . | cpio -o -H newc | gzip > /tmp/newramdisk.gz
[ -f /tmp/zImage ] || mv /tmp/boot.img-zImage /tmp/zImage
echo \#!/sbin/sh > /tmp/createnewboot.sh
echo /tmp/mkbootimg --kernel /tmp/zImage --ramdisk /tmp/newramdisk.gz --cmdline \"$(cat /tmp/boot.img-cmdline)\" --base $(cat /tmp/boot.img-base) --output /tmp/newboot.img >> /tmp/createnewboot.sh
chmod 777 /tmp/createnewboot.sh
/tmp/createnewboot.sh
return $?
