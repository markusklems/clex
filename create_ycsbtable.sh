#!/bin/bash
cp /home/clex/create_ycsbtable /home/clex/create_ycsbtable_tmp
sed -i -e "s|# 'replication_factor':X|'replication_factor':$1|" /home/clex/create_ycsbtable_tmp
cqlsh -f /home/clex/create_ycsbtable_tmp
rm /home/clex/create_ycsbtable_tmp