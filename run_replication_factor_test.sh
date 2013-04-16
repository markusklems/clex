#!/bin/bash
hostsstring="82.165.133.125,217.160.4.155,217.160.94.220,217.160.94.217,82.165.197.212,87.106.52.227,217.160.94.227,87.106.252.93"
hosts=('82.165.133.125' '217.160.4.155' '217.160.94.220' '217.160.94.217' '82.165.197.212' '87.106.52.227' '217.160.94.227' '87.106.252.93');
master="82.165.133.125"

for i in {1..5}
do
   TIME=$(date +%s)
   echo "$TIME, start experiment with replication factor $i" >> experiment_log.txt
   for host in $hosts
   do
      ssh $host 'bash -s' < drop_ycsbtable.sh
   done
   sleep 50
   ssh $master 'bash -s' < create_ycsbtable.sh $i
   TIME2=$(date +%s)
   echo "$TIME2, start load phase" >> experiment_log.txt
   /home/ycsb/bin/ycsb load cassandra-10 -P workloads/workloada -p hosts=$hostsstring -s > "/home/ycsb/load-workloada-N$1.txt"
   TIME3=$(date +%s)
   echo "$TIME3, end load phase" >> experiment_log.txt
   sleep 60
   TIME4=$(date +%s)
   echo "$TIME4, start run phase" >> experiment_log.txt
   /home/ycsb/bin/ycsb run cassandra-10 -P workloads/workloada -p hosts=$hostsstring -s > "/home/ycsb/run-workloada-N$1.txt"
   TIME5=$(date +%s)
   echo "$TIME5, end run phase" >> experiment_log.txt
done