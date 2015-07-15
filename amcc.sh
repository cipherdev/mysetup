#!/bin/sh
# *****************************************
# Copyright  2015
# AMCC, Inc. All Rights Reserved
# Proprietary and Confidential
# *****************************************
#
# Author: HuyLe,email: hule@apm.com
#
###########################################
function device_ata()
{
	lsscsi | grep 'ATA' > /tmp/ata.txt
        wc -l /tmp/ata.txt > /tmp/line.txt
        cut -c1-2 /tmp/line.txt > /tmp/numline.txt
        x=`cat /tmp/numline.txt`
        echo -e '\e[40;32m'"\033[1m ============================== \033[0m"
        echo -e '\e[40;32m'"\033[1m ==> Total device: ${x} HDD   <== \033[0m"
        echo -e '\e[40;32m'"\033[1m ============================== \033[0m"
}
###############
# HDD TESTING #
###############
function xdd_ata()
{
	#for ((i=0; i<=$x; ++i))
	device_ata
	for i in `seq 1 $x`
	do
		echo -e '\e[40;32m'"\033[1m ==> Device: ${i} \033[0m"
	        #sed -n "${i}p" /tmp/ata.txt > /tmp/${i}.txt
		head -"${i}" /tmp/ata.txt > /tmp/${i}.txt
	        y=`cat /tmp/$i.txt`
		echo "${y:${#y}-4:3}" > /tmp/result_$i.txt
	        echo -e '\e[40;32m'"\033[1m ==> `cat /tmp/result_${i}.txt` \033[0m"
		z=`cat /tmp/result_${i}.txt`
		for DEVICE in $z
		do 
			echo -e '\e[40;32m'"\033[1m ==> XDD write to the ${DEVICE}. \033[0m"
			xdd -op write -target /dev/${DEVICE} -reqsize 2048 -mbytes 4096 -dio -verbose -passes 3
			echo -e '\e[40;32m'"\033[1m ==> XDD read to the ${DEVICE}. \033[0m"
			xdd -op read -target /dev/${DEVICE} -reqsize 2048 -mbytes 4096 -dio -verbose -passes 3
			sleep 2m
		done
	done
	echo -e '\e[40;32m'"\033[1m ==> XDD for ${x} device done.\033[0m"
}
function mount_ata(){
	device_ata
	for i in `seq 1 $x`
        do
                echo -e '\e[40;32m'"\033[1m ==> Device: ${i} \033[0m"
                #sed -n "${i}p" /tmp/ata.txt > /tmp/${i}.txt
                head -"${i}" /tmp/ata.txt > /tmp/${i}.txt
                y=`cat /tmp/$i.txt`
                echo "${y:${#y}-4:3}" > /tmp/result_$i.txt
                echo -e '\e[40;32m'"\033[1m ==> `cat /tmp/result_${i}.txt` \033[0m"
                z=`cat /tmp/result_${i}.txt`
                for DEVICE in $z
                do
                        echo -e '\e[40;32m'"\033[1m ==> Format and mount to ${DEVICE}. \033[0m"
			parted -s "/dev/${DEVICE}" -- mklabel gpt mkpart primary ext4 1049K 100% && mkfs.ext4 "/dev/${DEVICE}1"
			mkdir /tmp/${DEVICE}1
			mount /dev/${DEVICE}1 /tmp/${DEVICE}1
			touch /tmp/${DEVICE}1/${DEVICE}1.txt && echo "${DEVICE}1" > /tmp/${DEVICE}1/${DEVICE}1.txt
                done
        done
	df -h
}
function umount_ata(){
        device_ata
        for i in `seq 1 $x`
        do
                echo -e '\e[40;32m'"\033[1m ==> Device: ${i} \033[0m"
                #sed -n "${i}p" /tmp/ata.txt > /tmp/${i}.txt
                head -"${i}" /tmp/ata.txt > /tmp/${i}.txt
                y=`cat /tmp/$i.txt`
                echo "${y:${#y}-4:3}" > /tmp/result_$i.txt
                echo -e '\e[40;32m'"\033[1m ==> `cat /tmp/result_${i}.txt` \033[0m"
                z=`cat /tmp/result_${i}.txt`
                for DEVICE in $z
                do
                        echo -e '\e[40;32m'"\033[1m ==> Umount to ${DEVICE}. \033[0m"
                        umount /dev/${DEVICE}1
                done
        done
        df -h
}
function device_usb()
{
	ls -l /sys/block/ | grep "usb" > /tmp/usb.txt
	wc -l /tmp/usb.txt > /tmp/numusb.txt
	cut -c1 /tmp/numusb.txt > /tmp/numline.txt
        x=`cat /tmp/numline.txt`
	echo -e '\e[40;32m'"\033[1m ============================== \033[0m"
        echo -e '\e[40;32m'"\033[1m ==> Total device USB: ${x} HDD   <== \033[0m"
        echo -e '\e[40;32m'"\033[1m ============================== \033[0m"
}

###############
# USB TESTING #
###############
function mount_usb(){
        device_usb
        for i in `seq 1 $x`
        do
                echo -e '\e[40;32m'"\033[1m ==> Device: ${i} \033[0m"
                sed -n "${i}p" /tmp/usb.txt > /tmp/${i}.txt
                # head -"${i}" /tmp/usb.txt > /tmp/${i}.txt 
                y=`cat /tmp/$i.txt`
                echo "${y:${#y}-3:3}" > /tmp/result_$i.txt
                echo -e '\e[40;32m'"\033[1m ==> `cat /tmp/result_${i}.txt` \033[0m"
                z=`cat /tmp/result_${i}.txt`
                for DEVICE in $z
                do
                        echo -e '\e[40;32m'"\033[1m ==> Fortmat VFAT for ${DEVICE}. \033[0m"
                        mkfs.vfat /dev/${DEVICE}
			echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/${DEVICE}
			mkfs.vfat /dev/${DEVICE}1
			echo -e '\e[40;32m'"\033[1m ==> Mount to ${DEVICE}. \033[0m"
			mkdir /tmp/${DEVICE}1
                        mount /dev/${DEVICE}1 /tmp/${DEVICE}1
			touch /tmp/${DEVICE}1/${DEVICE}1.txt && echo "${DEVICE}1" > /tmp/${DEVICE}1/${DEVICE}1.txt
                done
        done
        df -h
}

function umount_usb(){
        device_usb
        for i in `seq 1 $x`
        do
                echo -e '\e[40;32m'"\033[1m ==> Device: ${i} \033[0m"
                sed -n "${i}p" /tmp/usb.txt > /tmp/${i}.txt
                # head -"${i}" /tmp/usb.txt > /tmp/${i}.txt 
                y=`cat /tmp/$i.txt`
                echo "${y:${#y}-3:3}" > /tmp/result_$i.txt
                echo -e '\e[40;32m'"\033[1m ==> `cat /tmp/result_${i}.txt` \033[0m"
                z=`cat /tmp/result_${i}.txt`
                for DEVICE in $z
                do
                        echo -e '\e[40;32m'"\033[1m ==> Umount to ${DEVICE}. \033[0m"
                        umount /dev/${DEVICE}1
                done
        done
        df -h
}
##################
# IOZONE TESTING #
##################
function iozone_ata(){
    device_ata
	for i in `seq 1 $x`
        do
                echo -e '\e[40;32m'"\033[1m ==> Device: ${i} \033[0m"
                #sed -n "${i}p" /tmp/ata.txt > /tmp/${i}.txt
                head -"${i}" /tmp/ata.txt > /tmp/${i}.txt
                y=`cat /tmp/$i.txt`
                echo "${y:${#y}-4:3}" > /tmp/result_$i.txt
                echo -e '\e[40;32m'"\033[1m ==> `cat /tmp/result_${i}.txt` \033[0m"
                z=`cat /tmp/result_${i}.txt`
                for DEVICE in $z
                do
                        echo -e '\e[40;32m'"\033[1m ==> IOZONE LINUX TO ${DEVICE}. \033[0m"
			iozone -I -i 0 -i 1 -i 2 -r 64K -s 1G -t 1 -F /dev/${DEVICE}
                done
        done
}
###############
# FIO TESTING #
###############
function fio_ata(){
	echo -e '\e[40;32m'"\033[1m ==> Don't support testing FIO. \033[0m"
	#device_ata
	#mdadm --create --assume-clean --run /dev/md5 --chunk=64 --level=5 --raid-devices=4 /dev/sda /dev/sdb /dev/sdc /dev/sdd
	#mdadm --create --verbose /dev/md0 --level=$2 --raid-devices=$3 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
	#mdadm --misc -D /dev/md0 
}
#####################
# DATE-TIME TESTING #
#####################
function date_t(){
	#Set the Hardware Clock to the current System Time.
	hwclock --systohc  # or hwclock -w
	#Set the System Time from the Hardware Clock.
	hwclock --hctosys # or hwclock -s
	echo -e '\e[40;32m'"\033[1m#========================================================================================#\033[0m"
	echo -e '\e[40;32m'"\033[1mSystem Time: \033[0m"
	date
	echo -e '\e[40;32m'"\033[1mHardware Clock: \033[0m"
	hwclock -r
	
	echo -e '\e[40;32m'"\033[1m#========================================================================================#\033[0m"
	echo -e '\e[40;32m'"\033[1mSet the time to System Time: 2050-06-25 12:00:56 \033[0m"
	date -s '2050-06-25 12:00:56'
	#echo -e '\e[40;32m'"\033[1mSystem Time: \033[0m"
	#date
	echo -e '\e[40;32m'"\033[1mHardware Clock: \033[0m"
	hwclock -r
	
	echo -e '\e[40;32m'"\033[1m#========================================================================================#\033[0m"
	echo -e '\e[40;32m'"\033[1mSet the Hardware Clock to the current System Time\033[0m"
	hwclock --systohc
	sleep 3
	echo -e '\e[40;32m'"\033[1mSystem Time: \033[0m"
	date
	echo -e '\e[40;32m'"\033[1mHardware Clock: \033[0m"
	hwclock -r
	
	echo -e '\e[40;32m'"\033[1m#========================================================================================#\033[0m"
	echo -e '\e[40;32m'"\033[1mSet the System Time from the Hardware Clock.\033[0m"
	hwclock --set --date="2013-7-31 09:30"
	sleep 1
	hwclock --hctosys
	sleep 2
	echo -e '\e[40;32m'"\033[1mHardware Clock: \033[0m"
	hwclock -r
	echo -e '\e[40;32m'"\033[1mSystem Time: \033[0m"
	date

  	echo -e '\e[40;32m'"\033[1m#========================================================================================#\033[0m"
	echo -e '\e[40;32m'"\033[1mStop NTP \033[0m"
	/etc/init.d/S49ntp stop
	echo -e '\e[40;32m'"\033[1mUpdate System Time: time.nist.gov  \033[0m"
	ntpdate time.nist.gov
	date
	echo -e '\e[40;32m'"\033[1mUpdate Hardware Clock Time  \033[0m"
	hwclock -w
	sleep 3
	hwclock -r
	echo -e '\e[40;32m'"\033[1m#========================================================================================#\033[0m"

}
function inf(){
	echo -e '\e[40;32m'"\033[1m \t Information\033[0m"
	echo -e "\n"
	cat /proc/version
	lscpu
	# lscpu | grep "CPU(s):" | cut -d':' -f2 > cores.txt
	free -t -m 
	vmstat -s
}
function help(){
	echo -e '\e[40;32m'"\033[1m#==============================#\033[0m"
	echo -e '\e[40;32m'"\033[1m#             HELP             #\033[0m"
	echo -e '\e[40;32m'"\033[1m#==============================#\033[0m"
	echo -e '\e[40;32m'"\033[1m# Function name:               #\033[0m"
	echo -e '\e[40;32m'"\033[1m# 1. xdd                       #\033[0m"
	echo -e '\e[40;32m'"\033[1m# 2. iozone                    #\033[0m"
	echo -e '\e[40;32m'"\033[1m# 3. date                      #\033[0m"
	echo -e '\e[40;32m'"\033[1m# 4. inf                       #\033[0m"
	echo -e '\e[40;32m'"\033[1m# 5. fio	               #\033[0m"
	echo -e '\e[40;32m'"\033[1m# 6. mounthdd                  #\033[0m"
	echo -e '\e[40;32m'"\033[1m# 7. umounthdd                 #\033[0m"
	echo -e '\e[40;32m'"\033[1m# 8. mountusb                  #\033[0m"
	echo -e '\e[40;32m'"\033[1m# 9. umountusb                 #\033[0m"
	echo -e '\e[40;32m'"\033[1m#------------------------------#\033[0m"
	echo -e '\e[40;32m'"\033[1m Ex: Test for XDD               \033[0m"
	echo -e '\e[40;32m'"\033[5m 		./amcc.sh xdd  \033[0m"
	echo -e '\e[40;32m'"\033[1m#==============================#\033[0m"
}
# function progress {
#         let progress=(${1}*100/${2}*100)/100
#         let done=(${progress}*4)/10
#         let left=40-${done}
#         fill=$(printf "%${done}s")
#         empty=$(printf "%${left}s")
#         printf "\rProgress : [${fill// /#}${empty// /-}]# ${progress}%%"
# }
# function runprogress(){
# 	_start=1
# 	_end=100
# 	for number in $(seq ${_start} ${_end})
# 	do
# 	    sleep 0.1
# 	    progress ${number} ${_end}
# 	done
# 	printf '\nFinished!\n'
# }
###############
# MAIN SCRIPT #
###############
function echo_(){
    echo -ne '#####                     (33%)\r'
    sleep 1
    echo -ne '#############             (66%)\r'
    sleep 1
    echo -ne '#######################   (100%)\r'
    echo -ne '\n'
}
main() 
{	
	case "$1" in
	    'mounthdd')
		mount_ata
		;; 
	    'umounthdd')
		umount_ata
		;;
	    'mountusb')
		mount_usb
		;;
	    'umountusb')
		umount_usb
		;;
	    'xdd')
		xdd_ata
		;;
	    'iozone')
		iozone_ata
		;;
	    'fio')
		#runprogress
		echo_
		fio_ata
		;;
	    'date')
		date_t
		;;
	    'inf')
		inf
		;;
	    *)
		help
		;;
	esac	
}
main $*
