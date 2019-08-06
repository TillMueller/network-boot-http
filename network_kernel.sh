#!/bin/sh
SERVER=$1
KERNEL=$2
INITRD=$3
CMDLINE=$4
HDD=$5

cd /network-boot
wget -q $SERVER/kernels/$KERNEL
wget -q $SERVER/kernels/$INITRD
./kexec -l $KERNEL --initrd=$INITRD --command-line="$CMDLINE"
./kexec -e
