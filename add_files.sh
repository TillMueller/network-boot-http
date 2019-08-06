#!/bin/sh
HDD=$1
FILESYSTEM=$2
SERVER=$3

cd /network-boot
mkdir -p /network-boot/mnt
mount -t $FILESYSTEM $HDD /network-boot/mnt
#get files here
wget -q -O /network-boot/mnt/etc/motd $SERVER/files/motd
date >> /network-boot/mnt/etc/motd
if [ ! -d "/network-boot/mnt/lib/modules/4.19.0-5-amd64" ]; then
	wget -q $SERVER/modules/modules_4.19.0-5-amd64.tar
	tar xf modules_4.19.0-5-amd64.tar -C /network-boot/mnt/lib/modules/
fi
#cleanup
umount /network-boot/mnt
