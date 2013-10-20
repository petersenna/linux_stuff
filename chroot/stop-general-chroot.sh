#!/bin/bash

DIR=$1
if [[ $DIR == "" ]];then
        echo I need FULL path as argument
        exit 1
fi

chroot $DIR /etc/init.d/ssh stop

umount $DIR/tmp $DIR/proc $DIR/sys $DIR/dev/pts $DIR/dev $DIR/lib/modules
umount $DIR/tmp $DIR/proc $DIR/sys $DIR/dev/pts $DIR/dev $DIR/lib/modules
