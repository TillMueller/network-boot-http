#!/bin/sh
HDD=$1
FILESYSTEM=$2
KERNEL=$3
INITRD=$4
CMDLINE=$5

cd /network-boot
mkdir -p /network-boot/mnt
mount -o ro -t $FILESYSTEM $HDD /network-boot/mnt
./kexec -l mnt$KERNEL --initrd=mnt$INITRD --command-line="$CMDLINE"
umount /network-boot/mnt
./kexec -e
