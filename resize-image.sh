#!/bin/bash


dd if=/dev/zero bs=1M count=1024 >> $1

(
echo p
echo d
echo 2 
echo n # Add a new partition
echo p # Primary partition
echo 2 # Partition number
echo 98304  # First sector (Accept default: 1)
echo # Last sector (Accept default: varies)
echo w # Write changes
) | fdisk $1

losetup /dev/loop0 $1 -o 50331648

e2fsck -f /dev/loop0
resize2fs /dev/loop0

losetup -d /dev/loop0



