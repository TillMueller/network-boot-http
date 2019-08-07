#!/bin/sh
#consts
BOOT_MODE="NETWORK"
KERNEL="vmlinuz-4.19.0-5-amd64"
INITRD="initrd.img-4.19.0-5-amd64"
SERVER="192.168.123.216" #may not contain spaces
HDD="/dev/vda1"
FILESYSTEM="ext4"
CMDLINE="root=$HDD ro quiet panic=1"

#BOOT_MODE="HDD"
#KERNEL="/boot/vmlinuz-4.9.0-9-amd64"
#INITRD="/boot/initrd.img-4.9.0-9-amd64"

clear
cd /network-boot
wget -q $SERVER/index.html
cat index.html

wget -q $SERVER/add_files.sh
chmod +x add_files.sh
./add_files.sh "$HDD" "$FILESYSTEM" "$SERVER"

case "$BOOT_MODE" in
	HDD)
		wget -q $SERVER/hdd_kernel.sh
		chmod +x hdd_kernel.sh
		./hdd_kernel.sh "$HDD" "$FILESYSTEM" "$KERNEL" "$INITRD" "$CMDLINE"
		;;
	NETWORK)
		wget -q $SERVER/network_kernel.sh
		chmod +x network_kernel.sh
		./network_kernel.sh $SERVER "$KERNEL" "$INITRD" "$CMDLINE" "$HDD"
		;;
esac
