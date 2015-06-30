
# *****************************************
# Copyright  2014
# Inc. All Rights Reserved
# Proprietary and Confidential
# *****************************************
# <anhhuy@live.com>
# *****************************************

#1. Installing the build toolchain
sudo apt-get install openssl
sudo apt-get install libssl-dev
sudo apt-get install gcc-arm-linux-gnueabi
#apt-get install sudo
visudo
#Look for the line
ROOT ALL=(ALL) ALL
#Add a new line after that:
cmos ALL=(ALL) ALL
#2.# ********** Uboot **********
wget ftp://ftp.denx.de/pub/u-boot/u-boot-latest.tar.bz2
tar -xjf u-boot-latest.tar.bz2	#Extract it
#cd u-boot-<version>	
#Building <= v1014.07: 
	make tools-only	
#Building >= v1014.10: 
	make sandbox_defconfig tools-only	

sudo install tools/mkimage /usr/local/bin	#Installs the mkimage program

#3.##################### Kernel##################
git clone git://github.com/beagleboard/kernel.git
cd kernel
export PATH=/usr/bin:$PATH
git checkout 3.8
./patch.sh
cp configs/beaglebone kernel/arch/arm/configs/beaglebone_defconfig
wget http://arago-project.org/git/projects/?p=am33x-cm3.git\;a=blob_plain\;f=bin/am335x-pm-firmware.bin\;hb=HEAD -O kernel/firmware/am335x-pm-firmware.bin
cd kernel
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- beaglebone_defconfig
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- uImage dtbs
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- uImage-dtb.am335x-boneblack
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- modules
#in the kernel/arch/arm/boot folder, there will be a uImage-dtb.am335x-boneblack file, you can rename file > uImage-BBB
mkimage -l uImage-BBB
setenv autoload no
setenv bootargs console=ttyO0,115200n8 quiet root=/dev/mmcblk0p2 ro rootfstype=ext4 rootwait
#dhcp
setenv ipaddr 192.168.1.16
setenv serverip 192.168.1.13
setenv netmask 255.255.255.0
setenv gatewayip 192.168.1.1
tftpboot 0x80200000 uImage-BBB
bootm 0x80200000
#http://elinux.org/Building_BBB_Kernel#Downloading_and_building_the_Linux_Kernel

