#!/bin/bash
# Peter Senna Tschudin - peter.senna@gmail.com

#Ramdisk size
RamdiskSize=15723

# FILEs
DownloadFile=/tmp/ramdisk/download
TimeFile=/tmp/downloadTimes
LogFile=/var/log/bandwidth.mrtg

if [ $1 ]; then
	if [ $2 ]; then
		wget -nv --spider $1 &> /dev/null
		FirstRet=$?
		if [ $FirstRet != 0 ]; then
			date >> $LogFile
			echo ERROR DOWNLOADING $1 >> $LogFile
		fi
		wget -nv --spider $2 &> /dev/null
		SecondRet=$?
		if [ $SecondRet != 0 ]; then
			date >> $LogFile
			echo ERROR DOWNLOADING $2 >> $LogFile
		fi
	else
		echo Requires 2 URLs
		exit
	fi
else
	echo Requires 2 URLs
	exit
fi

# Ramdisk Stuff
umount /tmp/ramdisk &>/dev/null
rm -rf /tmp/ramdisk &>/dev/null
mkdir /tmp/ramdisk &>/dev/null

mke2fs -m 0 /dev/ram0 &>/dev/null
tune2fs -c 0 /dev/ram0 &>/dev/null
mount /dev/ram0 /tmp/ramdisk &>/dev/null
mount |grep /tmp/ramdisk &> /dev/null
if [ $? != 0 ];then
	echo Ramdisk error. Exiting...
	echo Ramdisk error. Exiting... >> $LogFile
	exit
fi

#First
if [ $FirstRet == 0 ]; then
	date +%s > $TimeFile
	wget -nv --no-cache $1 -O $DownloadFile &> /dev/null
	date +%s >> $TimeFile

	let "FirstTimeSpent=`tail -n 1 $TimeFile` - `head -n 1 $TimeFile`"

	# 15660 / 1.875 == 8.3. If it took less than 7 seconds there is something wrong. 
	if [ $FirstTimeSpent -lt 7 ];then
		echo 0
	else
		let "FirstBand=$RamdiskSize/$FirstTimeSpent"
		echo $FirstBand
	fi
else
	echo 0
fi

#Second
if [ $SecondRet == 0 ]; then
	date +%s > $TimeFile
	wget -nv --no-cache $2 -O $DownloadFile &> /dev/null
	date +%s >> $TimeFile

	let "SecondTimeSpent=`tail -n 1 $TimeFile` - `head -n 1 $TimeFile`"
	# 15660 / 1.875 == 8.3. If it took less than 7 seconds there is something wrong. 
	if [ $SecondTimeSpent -lt 7 ];then
		echo 0
	else
		let "SecondBand=$RamdiskSize/$SecondTimeSpent"
		echo $SecondBand
	fi      
else
	echo 0
fi

# Ramdisk Stuff
umount /tmp/ramdisk &>/dev/null

