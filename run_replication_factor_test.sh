#!/bin/bash
master="82.165.133.125"
mkdir log
mkdir results

for i in 1 2 3 4 5
do
   TIME=$(date +%s)
   echo "$TIME, start experiment with replication factor $i" >> log/experiment_log.txt
   sudo parallel-ssh -h hosts.txt -l root -o /tmp/cassandra-ycsb-exp 'service cassandra stop'
   sudo parallel-ssh -h hosts.txt -l root -o /tmp/cassandra-ycsb-exp 'sh /home/clex/remove_data.sh'
   sudo parallel-ssh -h hosts.txt -l root -o /tmp/cassandra-ycsb-exp 'service cassandra start'
   sleep 60
   ssh $master 'bash -s' < create_ycsbtable.sh $i
   sleep 10

   TIME2=$(date +%s)
   echo "$TIME2, start load phase" >> log/experiment_log.txt
   /home/ycsb/bin/ycsb load cassandra-10 -P "`pwd`/workloads/workloada" -s > "results/load-workloada-N$i.txt"
   TIME3=$(date +%s)
   echo "$TIME3, end load phase" >> log/experiment_log.txt
   sleep 60
   TIME4=$(date +%s)
   echo "$TIME4, start run phase" >> log/experiment_log.txt
   /home/ycsb/bin/ycsb run cassandra-10 -P "`pwd`/workloads/workloada" -s > "results/run-workloada-N$i.txt"
   TIME5=$(date +%s)
   echo "$TIME5, end run phase" >> log/experiment_log.txt
done