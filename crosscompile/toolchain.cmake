set( RPI_ROOTFS "/build_ros/crosscompile/sysroot" )

#set(CMAKE_SYSROOT ${RPI_ROOTFS})

set(CMAKE_EXE_LINKER_FLAGS "-Wl,-rpath,${CMAKE_SYSROOT}/lib:${CMAKE_SYSROOT}/lib/arm-linux-gnueabihf")


#set( CROSS_BIN "/build_ros/crosscompile/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf/bin")
set (CROSS_BIN "/root/x-tools6h-new/arm-rpio-linux-gnueabihf/bin" )


#set( CMAKE_C_COMPILER   "${CROSS_BIN}/arm-linux-gnueabihf-gcc")
#set( CMAKE_CXX_COMPILER "${CROSS_BIN}/arm-linux-gnueabihf-g++")
#set( CMAKE_AR           "${CROSS_BIN}/arm-linux-gnueabihf-ar" CACHE STRING "")
#set( CMAKE_RANLIB       "${CROSS_BIN}/arm-linux-gnueabihf-ranlib" CACHE STRING "")
set( CMAKE_C_COMPILER   "${CROSS_BIN}/arm-rpio-linux-gnueabihf-gcc" CACHE STRING "")
set( CMAKE_CXX_COMPILER "${CROSS_BIN}/arm-rpio-linux-gnueabihf-c++" CACHE STRING "")
set( CMAKE_AR           "${CROSS_BIN}/arm-rpio-linux-gnueabihf-ar" CACHE STRING "")
set( CMAKE_RANLIB       "${CROSS_BIN}/arm-rpio-linux-gnueabihf-ranlib" CACHE STRING "")

# Platform
set( CMAKE_SYSTEM_NAME Linux )
set( CMAKE_SYSTEM_VERSION 1 )
set( CMAKE_SYSTEM_PROCESSOR arm )
set( CMAKE_LIBRARY_ARCHITECTURE arm-linux-gnueabihf )
set( FLOAT_ABI_SUFFIX "hf" )
#add_definitions( "-mcpu=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard -marm" )

# setup RPI include/lib/pkgconfig directories for compiler/pkgconfig
set( RPI_INCLUDE_DIR "${RPI_INCLUDE_DIR} -isystem ${RPI_ROOTFS}/usr/include/arm-linux-gnueabihf")
set( RPI_INCLUDE_DIR "${RPI_INCLUDE_DIR} -isystem ${RPI_ROOTFS}/usr/include")
set( RPI_INCLUDE_DIR "${RPI_INCLUDE_DIR} -isystem ${RPI_ROOTFS}/usr/local/include")
set( RPI_INCLUDE_DIR "${RPI_INCLUDE_DIR} -isystem ${RPI_ROOTFS}/usr/include/python2.7")
set( RPI_INCLUDE_DIR "${RPI_INCLUDE_DIR} -isystem ${RPI_ROOTFS}/opt/vc/include")

set( RPI_LIBRARY_DIR "${RPI_LIBRARY_DIR} -Wl,-rpath ${RPI_ROOTFS}/usr/lib/arm-linux-gnueabihf")
set( RPI_LIBRARY_DIR "${RPI_LIBRARY_DIR} -Wl,-rpath ${RPI_ROOTFS}/lib/arm-linux-gnueabihf")
set( RPI_LIBRARY_DIR "${RPI_LIBRARY_DIR} -Wl,-rpath ${RPI_ROOTFS}/opt/vc/lib")

set( RPI_PKGCONFIG_LIBDIR "${RPI_PKGCONFIG_LIBDIR}:${RPI_ROOTFS}/usr/lib/arm-linux-gnueabihf/pkgconfig" )
set( RPI_PKGCONFIG_LIBDIR "${RPI_PKGCONFIG_LIBDIR}:${RPI_ROOTFS}/usr/share/pkgconfig" )
set( RPI_PKGCONFIG_LIBDIR "${RPI_PKGCONFIG_LIBDIR}:${RPI_ROOTFS}/opt/vc/lib/pkgconfig" )

# C/CXX flags
set( CMAKE_CXX_FLAGS        "${CMAKE_CXX_FLAGS} ${RPI_INCLUDE_DIR}" CACHE STRING "" FORCE)
set( CMAKE_C_FLAGS          "${CMAKE_CXX_FLAGS} ${RPI_INCLUDE_DIR}" CACHE STRING "" FORCE)
set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${RPI_LIBRARY_DIR}" CACHE STRING "" FORCE)
set( CMAKE_SHARED_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${RPI_LIBRARY_DIR}" CACHE STRING "" FORCE)
#set( CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -L${RPI_ROOTFS}/lib/arm-linux-gnueabihf -L${RPI_ROOTFS}/usr/lib/arm-linux-gnueabihf" CACHE STRING "" FORCE)

# Pkg-config settings
set( PKG_CONFIG_EXECUTABLE "/usr/bin/pkg-config")
set( ENV{PKG_CONFIG_DIR}         "")
set( ENV{PKG_CONFIG_LIBDIR}      "${RPI_PKGCONFIG_LIBDIR}")
set( ENV{PKG_CONFIG_SYSROOT_DIR} "${RPI_ROOTFS}" )

# Python2.7
set( PYTHON_EXECUTABLE          "/usr/bin/python2.7" CACHE STRING "")
set( PYTHON_LIBRARY_DEBUG       "${RPI_ROOTFS}/usr/lib/arm-linux-gnueabihf/libpython2.7.so" CACHE STRING "")
set( PYTHON_LIBRARY_RELEASE     "${RPI_ROOTFS}/usr/lib/arm-linux-gnueabihf/libpython2.7.so" CACHE STRING "")
set( PYTHON_LIBRARY             "${RPI_ROOTFS}/usr/lib/arm-linux-gnueabihf/libpython2.7.so" CACHE STRING "")
set( PYTHON_INCLUDE_DIR         "${RPI_ROOTFS}/usr/include/python2.7")
set( PYTHON2_NUMPY_INCLUDE_DIRS "${RPI_ROOTFS}/usr/lib/python2.7/dist-packages/numpy/core/include" CACHE STRING "")
set( PYTHON2_PACKAGES_PATH      "${RPI_ROOTFS}/usr/local/lib/python2.7/site-packages" CACHE STRING "")
set( PYTHON2_PACKAGES_PATH      "${RPI_ROOTFS}/usr/local/lib/python2.7/dist-packages" CACHE STRING "")

# Boost
#set( BOOST_LIBRARYDIR "${RPI_ROOTFS}/usr/lib/arm-linux-gnueabihf/" CACHE STRING "")

# OpenCV
#set( OpenCV_DIR       "${RPI_ROOTFS}/usr/share/OpenCV/" CACHE STRING "")

# Userland / VideoCore
set( USERLAND_DIR     "${RPI_ROOTFS}/usr/src/userland" CACHE STRING "")

set(CMAKE_FIND_ROOT_PATH ${RPI_ROOTFS})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
#set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

