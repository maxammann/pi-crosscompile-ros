#!/bin/sh

# sync
rsync -auHW {/mnt/usr,/mnt/sbin,/mnt/bin,/mnt/lib,/mnt/etc,/mnt/home,/mnt/var,/mnt/dev,/mnt/proc,/mnt/sys} sysroot

# fix links
TARGET_ROOT="$(pwd)/sysroot"

echo $TARGET_ROOT
