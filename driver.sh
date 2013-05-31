#!/bin/bash
cd /usr/src
apt-get update
apt-get install -y kernel-package build-essential linux-source
tar --bzip2 -xvf linux-source-*.tar.bz2
ln -s `find . -type d -name "linux-source-*"` linux

cd /usr/src/linux/drivers/media/video/gspca
mv ov534.c ov534.c.old
wget https://raw.github.com/Azique/ov534/master/ov534.c 

cd /usr/src
cp -p linux-headers-$(uname -r)/Module.symvers linux

cd /usr/src/linux
make oldconfig
make modules_prepare
make SUBDIRS=drivers/media/video/gspca modules 


cd /usr/src/linux
cp -p drivers/media/video/gspca/gspca_main.ko /lib/modules/$(uname -r)/kernel/drivers/media/video/gspca
cp -p drivers/media/video/gspca/gspca_ov534.ko /lib/modules/$(uname -r)/kernel/drivers/media/video/gspca
depmod


modprobe -r gspca_ov534 gspca_main
modprobe gspca_ov534
