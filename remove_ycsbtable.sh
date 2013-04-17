#!/bin/bash
#cqlsh -f /home/clex/drop_ycsbtable
rm -Rf /var/lib/cassandra/*
mkdir -p /var/lib/cassandra/data
mkdir -p /var/lib/cassandra/commitlog
mkdir -p /var/lib/cassandra/saved_caches
chown cassandra -R /var/lib/cassandra
exit