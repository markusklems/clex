#!/bin/bash
#cqlsh -f /home/clex/drop_ycsbtable
nodetool invalidatekeycache
nodetool invalidaterowcache
nodetool clearsnapshot
(echo "DROP KEYSPACE usertable;" > /tmp/dropkeyspace; cqlsh -f /tmp/dropkeyspace; rm /tmp/dropkeyspace)
sleep 20
rm -Rf /var/lib/cassandra/data/usertable/*
rm -Rf /var/lib/cassandra/commitlog/*
rm -Rf /var/lib/cassandra/saved_caches/*
#mkdir -p /var/lib/cassandra/data
#mkdir -p /var/lib/cassandra/commitlog
#mkdir -p /var/lib/cassandra/saved_caches
#chown cassandra -R /var/lib/cassandra
exit