#!/bin/bash

mount --bind /dev $1/dev 
mount --bind /dev/pts $1/dev/pts
mount --bind /sys $1/sys
mount --bind /proc $1/proc

chroot $1 /bin/bash

umount $1/dev/pts
umount $1/dev 
umount $1/sys
umount $1/proc

