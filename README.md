The cross-compilation process is described here: https://maxammann.org/posts/2019/04/2019-04-13-crosscompiling-ros-raspbian/

To setup the final image do the following:

* Install and enable dnsmasq in chroot
* Enable SSH server in chroot 
* Disable hciuart service for uart
* Install zsh
* Run `chsh root --shell /bin/zsh`
* Run `chsh pi --shell /bin/zsh`
* Copy configs directory to image: sudo rsync -ra configs/ crosscompile/sysroot-release
* Run `ldconfig` to update library paths changed by `configs`
* Run for each user: `rsync -r /etc/skel/ ~`
* Change password by running: `passwd pi`
* Create new parition using fdisk
* Expand fs: `mkfs.ext4 -L recordings /dev/mmcblk0p3`

