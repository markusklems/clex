#!/bin/bash
apt-get install xfsprogs
lvcreate -L 700G -n cassandra vg00
mkfs.xfs /dev/vg00/cassandra
xfs_growfs /dev/vg00/cassandra
echo "/dev/vg00/cassandra /cassandra xfs defaults 0 2" | tee -a /etc/fstab
mkdir /cassandra
mount -a
ln -s /cassandra /var/lib/cassandra