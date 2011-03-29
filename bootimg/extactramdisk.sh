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

