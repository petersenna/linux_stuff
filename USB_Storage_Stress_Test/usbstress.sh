#!/bin/bash
# Peter Senna Tschudin - peter.senna AT gmail.com - 29/10/2008
# This is useful to test USB stability.
# ./usbstress.sh /dev/sdc1 <- replace sdc1 with your usb storage device
 
# SIZE * 1024
SIZE=500000
 
date=`date +"%Y-%m-%d_%H.%M.%S"`
mkdir -p /mnt/$date
 
# trap ctrl-c and call ctrl_c()
trap ctrl_c INT
 
function ctrl_c() {
	echo Exiting... Please wait!
	umount /mnt/$date
	rm -rf /mnt/$date
	exit 1
}
 
umount $1
 
i=0
 
while [ TRUE ];do
	echo . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
	echo $i-`date +"%Y-%m-%d_%H.%M.%S"`
	let i++
	mount $1 /mnt/$date
	if [ $? != 0 ];then
		exit 1
	fi
	echo PC to USB:
	dd if=/dev/zero of=/mnt/$date/file bs=1024 count=$SIZE
	sync
	umount $1
	mount $1 /mnt/$date
	if [ $? != 0 ];then
		exit 1
	fi
 
	echo USB to PC:
	dd if=/mnt/$date/file of=/dev/null bs=1024
	rm -rf /mnt/$date/file
	umount $1
	echo "/var/log/dmesg"
	tail -n 3 /var/log/dmesg
	echo "/var/log/messages"
	tail -n 3 /var/log/messages
done
