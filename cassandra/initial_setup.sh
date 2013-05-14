#!/bin/bash
myhostname=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
seed="82.165.133.125,217.160.4.155,217.160.94.220,217.160.94.217,82.165.197.212,87.106.52.227,217.160.94.227,87.106.252.93"
config_file="/etc/cassandra/cassandra.yaml"
sed -i -e "s|- seeds: \"127.0.0.1\"|- seeds: \"${seed}\"|" $config_file
sed -i -e "s|listen_address: localhost|listen_address: $myip|" $config_file
sed -i -e "s|rpc_address: localhost|rpc_address: 0.0.0.0|" $config_file
sed -i -e "s|initial_token|# initial_token|" $config_file
sed -i -e "s|# num_tokens: 256|num_tokens: 256|" $config_file