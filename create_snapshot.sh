#!/bin/bash

nodetool snapshot -t backupusertable
sleep 5
mv /var/lib/cassandra/data/usertable/data/snapshots/backupusertable/ /var/lib