#!/bin/bash

DIR=$1
if [[ $DIR == "" ]];then
	echo I need FULL path as argument
	exit 1
fi

umount $DIR/tmp $DIR/proc $DIR/sys $DIR/dev/pts $DIR/dev
umount $DIR/tmp $DIR/proc $DIR/sys $DIR/dev/pts $DIR/dev

mount /tmp		$DIR/tmp			-o bind
mount /lib/modules	$DIR/lib/modules		-o bind
mount proc		$DIR/proc	-t proc		-o nosuid,noexec,nodev
mount sysfs		$DIR/sys	-t sysfs	-o nosuid,noexec,nodev
mount devtmpfs		$DIR/dev	-t devtmpfs	-o mode=0755,nosuid
mount devpts		$DIR/dev/pts	-t devpts	-o gid=5,mode=620

cp -a /etc/resolv.conf $DIR/etc/resolv.conf

chroot $DIR /etc/init.d/ssh stop
chroot $DIR /etc/init.d/ssh start
