#!/bin/bash

sudo /sbin/iptables -A INPUT -p tcp --dport 7000 -j ACCEPT
sudo /sbin/iptables -A INPUT -p tcp --dport 9160 -j ACCEPT
sudo /sbin/service iptables save
sudo /sbin/service iptables restart
