#!/sbin/sh
cd /tmp/newramdisk
find . | cpio -o -H newc | gzip > /tmp/newramdisk.gz
[ -f /tmp/zImage ] || mv /tmp/boot.img-zImage /tmp/zImage
echo \#!/sbin/sh > /tmp/createnewboot.sh
echo /tmp/mkbootimg --kernel /tmp/zImage --ramdisk /tmp/newramdisk.gz --cmdline \"$(cat /tmp/boot.img-cmdline)\" --base $(cat /tmp/boot.img-base) --output /tmp/newboot.img >> /tmp/createnewboot.sh
chmod 777 /tmp/createnewboot.sh
/tmp/createnewboot.sh
return $?
