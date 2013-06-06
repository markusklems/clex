#!/bin/bash

OSP=6379
LSP=5114
MSP=27017

sudo /sbin/iptables -A INPUT -p tcp --dport $OSP -j ACCEPT
sudo /sbin/iptables -A INPUT -p udp --dport $LSP -j ACCEPT
sudo /sbin/iptables -A INPUT -p tcp --dport $MSP -j ACCEPT
sudo /sbin/service iptables save
sudo /sbin/service iptables restart