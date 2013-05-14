#!/bin/bash
# c.f. http://www.ibm.com/developerworks/cloud/library/cl-cloudtip-lvmconfig/
# Gold instance
# Partition and initialize LVM PV for device /dev/vdb
sudo dd if=/dev/zero of=/dev/vdb bs=1024 count=1
sudo blockdev --rereadpt /dev/vdb
echo "

n
p
1


t
8e
w" |sudo fdisk -c -u /dev/vdb
sudo pvcreate /dev/vdb1
  
# Partition and initialize LVM PV for device /dev/vdc
sudo dd if=/dev/zero of=/dev/vdc bs=1024 count=1
sudo blockdev --rereadpt /dev/vdc
echo "

n
p
1


t
8e
w" | sudo fdisk -c -u /dev/vdc
sudo pvcreate /dev/vdc1

# create volume group, logical volume
sudo vgcreate -A y localvg /dev/vdb1 /dev/vdc1
sudo lvcreate -A y -l 100%VG -n datalv localvg

sudo mkdir /cassandra
sudo mkfs.ext4 -L datalv /dev/localvg/datalv
echo "/dev/localvg/datalv  /cassandra        ext4    defaults        0 1" | sudo tee -a /etc/fstab
sudo mount /cassandra
sudo rm -Rf /var/lib/cassandra
sudo ln -s /cassandra /var/lib
sudo mkdir /var/lib/cassandra/data
sudo mkdir /var/lib/cassandra/commitlog
sudo mkdir /var/lib/cassandra/saved_caches