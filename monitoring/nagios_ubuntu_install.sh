#!/bin/bash
USER=${1:-root}
NAGIOS_HOST_IP=${2:-217.160.108.3}
HOSTS_FILE=/home/clex/hosts.txt
# http://askubuntu.com/questions/145518/how-do-i-install-nagios
sudo apt-get install -y nagios3
# you can reset the password like this:
# sudo htpasswd -c /etc/nagios3/htpasswd.users nagiosadmin
