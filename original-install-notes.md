1. Start docker with debian:stretch
    * pip install catkin_pkg <- used instead of repo one
    * Run `apt-get install build-essential pkg-config cmake unzip gzip rsync`
    * Run `apt-get install python-rosdep python-rosinstall-generator python-wstool python-rosinstall python-empy`
    * Install catkin_pkg from pip and remove from debian distro
2. Chroot into raspbian sysroot from host
    * Setup qemu-setup-static
    * Mount raspbian image
    * Run copy script
    * sudo mount --bind /sys sysroot/sys
    * sudo mount --bind /proc sysroot/proc
    * sudo mount --bind /dev sysroot/dev
    * sudo mount --bind /dev/pts sysroot/dev/pts
    * sudo chroot sysroot /bin/bash
    * On raspbian: Run `export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin`
    * On raspbian: Run `apt-get install pkg-config python2.7 python-dev python-pip sbcl libboost-all-dev ~libtinyxml-dev~ libgtest-dev liblz4-dev libbz2-dev libyaml-dev python-nose python-empy python-netifaces python-defusedxml`
    * On raspbian: pip install -U rospkg catkin_pkg
    * apt install libpoco-dev

3. Edit sysroot
Remove absolute paths from:  ./usr/lib/arm-linux-gnueabihf/libc.so ./usr/lib/arm-linux-gnueabihf/libpthread.so

/* GNU ld script
   Use the shared library, but some functions are only in
   the static library, so try that secondarily.  */
OUTPUT_FORMAT(elf32-littlearm)
GROUP ( /lib/arm-linux-gnueabihf/libc.so.6 /usr/lib/arm-linux-gnueabihf/libc_nonshared.a  AS_NEEDED ( /lib/arm-linux-gnueabihf/ld-linux-armhf.so.3 ) )
/* GNU ld script
   Use the shared library, but some functions are only in
   the static library, so try that secondarily.  */
OUTPUT_FORMAT(elf32-littlearm)
GROUP ( libc.so.6 libc_nonshared.a  AS_NEEDED ( ld-linux-armhf.so.3 ) )

/* GNU ld script
   Use the shared library, but some functions are only in
   the static library, so try that secondarily.  */
OUTPUT_FORMAT(elf32-littlearm)
GROUP ( /lib/arm-linux-gnueabihf/libpthread.so.0 /usr/lib/arm-linux-gnueabihf/libpthread_nonshared.a )
/* GNU ld script
   Use the shared library, but some functions are only in
   the static library, so try that secondarily.  */
OUTPUT_FORMAT(elf32-littlearm)
GROUP ( libpthread.so.0 libpthread_nonshared.a )




3. Run crosscompilation on docker
    * apt install libgtest-dev
    * mkdir gtest && cd gtest
    * cmake -D CMAKE_TOOLCHAIN_FILE=/build_ros/crosscompile/toolchain.cmake /build_ros/crosscompile/sysroot/usr/src/gtest
    * make
    * make install DESTDIR=/build_ros/crosscompile/sysroot

    * compile tinyxml2: https://answers.ros.org/question/278733/rospack-find-throws-exception-error/  https://github.com/mavlink/mavros/issues/896

    * git clone https://github.com/ros/console_bridge
    * cd console_bridge
    * mkdir build
    * cd build
    * cmake -D CMAKE_TOOLCHAIN_FILE=/build_ros/crosscompile/toolchain.cmake /build_ros/crosscompile/console_bridge/
    * make
    * make install DESTDIR=/build_ros/crosscompile/sysroot


    * rosdep init
    * rosdep update
    * Geneate rosinstall
    wstool init -j8 src melodic-ros_comm-wet.rosinstall
    * rosdep install --from-paths src --ignore-src --rosdistro melodic --os=debian:stretch --as-root apt:false -y -r
    * rsync -par . /build_ros/crosscompile/sysroot/catkin

5. On chroot:
    * chroot sysroot /bin/bash (export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin)
    * cd /catkin
    * apt install python-rosdep
    * rosdep init && rosdep update
    * rosdep install --from-paths src --ignore-src --rosdistro melodic -r --os=debian:stretch
    * Maybe update relativaptive paths from outside chroot: sudo python sysroot-relativelinks.py sysroot/ TODO: Ignore dev,proc, sys in script

    * pip uninstall PyYAML && pip install PyYAML==3.13

6. Run crosscompilation on docker
    * ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=/build_ros/crosscompile/toolchain.cmake

The installation of mavros/rapicam_node follows the same concept. Please note raspicam needs opencv3. Compile this aswell! https://docs.opencv.org/3.3.0/d7/d9f/tutorial_linux_install.html https://github.com/opencv/opencv/issues/11833
cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/build_ros/crosscompile/sysroot-release/usr/local -D CMAKE_TOOLCHAIN_FILE=/build_ros/crosscompile/toolchain.cmake  /build_ros/crosscompile/opencv-3.4.5
Run: rosinstall_generator ros_comm --rosdistro melodic --deps --tar > melodic-ros_comm.rosinstall
Run: wstool merge -t src  mavros_missing-dependencies.rosinstall
Run in chroot and docker: rosdep install --from-paths src --ignore-src --rosdistro melodic -s --os=debian:stretch

If you want to releas the image later it is good to start with a fresh chroot. Install all the dependencies from the other chroot and copy the release data. e.g. cat /var/log/apt/history.log | grep install:
/usr/bin/apt install python-rosdep
/usr/bin/apt-get install libgpgme-dev
/usr/bin/apt-get install -y cmake
<!--/usr/bin/apt-get install -y libtinyxml2-dev-->
/usr/bin/apt-get install -y liblog4cxx-dev
/usr/bin/apt-get install -y libssl-dev
/usr/bin/apt-get install -y python-numpy
/usr/bin/apt-get install -y python-imaging
/usr/bin/apt-get install -y python-gnupg
/usr/bin/apt-get install -y python-coverage
/usr/bin/apt-get install -y libpoco-dev
/usr/bin/apt-get install -y libconsole-bridge-dev
/usr/bin/apt-get install -y google-mock
/usr/bin/apt-get install -y python-paramiko
/usr/bin/apt-get install -y python-psutil
/usr/bin/apt-get install -y libbullet-dev
/usr/bin/apt-get install -y liburdfdom-headers-dev
/usr/bin/apt-get install -y python-pyproj
/usr/bin/apt-get install -y libgeographic-dev
/usr/bin/apt-get install -y python-future
/usr/bin/apt-get install -y libeigen3-dev
/usr/bin/apt-get install -y python-sip-dev
/usr/bin/apt-get install -y geographiclib-tools
/usr/bin/apt-get install -y graphviz
/usr/bin/apt-get install -y python-wxtools
/usr/bin/apt-get install -y libcppunit-dev
/usr/bin/apt-get install -y python-lxml
/usr/bin/apt-get install -y liburdfdom-dev
/usr/bin/apt-get install -y hddtemp
/usr/bin/apt install libraspberrypi0
/usr/bin/apt-get install -y libtheora-dev
/usr/bin/apt-get install -y libyaml-cpp-dev
apt install libgtest-dev
/usr/bin/apt-get install -y libopencv-dev /* required because we sysroot has these dependencies */
/usr/bin/apt-get install -y python-opencv
/usr/bin/apt-get install build-essential git cmake pkg-config libtiff5-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libgtk2.0-dev libatlas-base-dev gfortran
* In this case: make install console_bridge, opencv, copy installed catkin
* Run https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
* Make sure /build_ros does not exist

Resize image:
* dd if=/dev/zero bs=1M count=512 >> 2019-04-05-raspbian-stretch-lite-ros.img
* fdisk 2019-04-05-raspbian-stretch-lite-ros.img: Delete parition 2 and create new one starting at the **same** block as the previous parition
* sudo ./loopback-root.sh 2019-04-05-raspbian-stretch-lite-ros.img
* sudo e2fsck -f /dev/loop0
* sudo resize2fs /dev/loop0
* sudo losetup -d /dev/loop0

Mount whole image with boot:
* losetup -P /dev/loop0 2019-04-09-raspbian-stretch-lite-ros.img
* mount /dev/loop0p2 crosscompile/sysroot-release
* mount /dev/loop0p1 crosscompile/sysroot-release/boot
* ./chroot-raspbian.sh crosscompile/sysroot-release


Post compilation:
https://github.com/PX4/Firmware/issues/11662 PyYaml

./src/mavros/mavros/scripts/install_geographiclib_datasets.sh


    /build_ros/crosscompile/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf/bin/../lib/gcc/arm-linux-gnueabihf/6.3.1/../../../../arm-linux-gnueabihf/bin/ld: warning: libconsole_bridge.so.0.2, needed by /build_ros/crosscompile/sysroot/usr/lib/arm-linux-gnueabihf/liburdfdom_sensor.so, may conflict with libconsole_bridge.so.0.4

/build_ros/crosscompile/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf/bin/../lib/gcc/arm-linux-gnueabihf/6.3.1/../../../../arm-linux-gnueabihf/bin/ld: warning: libconsole_bridge.so.0.2, needed by /build_ros/crosscompile/sysroot/usr/lib/arm-linux-gnueabihf/liburdfdom_sensor.so, may conflict with libconsole_bridge.so.0.4


Enable serial https://www.raspberrypi.org/documentation/configuration/uart.md
https://learn.adafruit.com/adafruits-raspberry-pi-lesson-5-using-a-console-cable/enabling-serial-console

ARMv6: https://en.wikipedia.org/wiki/Raspberry_Pi#Pi_Zero

original config: https://raw.githubusercontent.com/raspberrypi/tools/master/configs/arm-rpi-4.9.3-linux-gnueabihf.config


Eventuelles Problem: Toolchain uses libraries from  host and not from sysroot. console_bridge war nicht nötig 

Final config:
* Install and enable dnsmasq in chroot
* Enable SSH server in chroot 
* Disable hciuart service for uart
* Install zsh
* Run chsh root --shell /bin/zsh
* Run chsh pi --shell /bin/zsh
* Copy configs directory to image: sudo rsync -ra . ../sysroot-release
* Run ldconfig  to update libs changed by configs
* Run for each user: rsync -r /etc/skel/ ~
* Change password by running: passwd pi

* create new parition using fdisk
* Expand fs: sudo mkfs.ext4 -L recordings /dev/mmcblk0p3
