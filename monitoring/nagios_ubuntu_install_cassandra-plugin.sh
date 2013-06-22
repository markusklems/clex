#!/bin/bash
USER=root
NAGIOS_HOST_IP=217.160.108.3
HOSTS_FILE=/home/clex/hosts.txt
# setup remote monitoring for the cluster
sudo apt-get -y install nagios3 nagios-nrpe-plugin
# pssh into the node servers and install the agents
sudo parallel-ssh -h $HOSTS_FILE -l $USER -o /tmp/nagios-install "sudo apt-get -y install nagios-nrpe-server; sudo sed -i.bak -r -e 's/allowed_hosts=127.0.0.1/allowed_hosts=$NAGIOS_HOST_IP/g' /etc/nagios/nrpe.cfg; sudo /etc/init.d/nagios-nrpe-server restart"

# install jmx plugin for access to all jmx info
(wget http://downloads.sourceforge.net/project/nagioscheckjmx/nagioscheckjmx/1.0/check_jmx.tar.gz; tar xvfz check_jmx.tar.gz; mv check_jmx/nagios/plugin/check_jmx /usr/lib/nagios/plugins/; cp check_jmx/nagios/plugin/jmxquery.jar /usr/lib/nagios/plugins/)
chmod a+x /usr/lib/nagios/plugins/check_jmx
rm /etc/nagios3/conf.d/cassandra_cmd.cfg
cp /home/clex/monitoring/nagios_cassandra_command.cfg /etc/nagios3/conf.d/cassandra_cmd.cfg
sudo parallel-ssh -h $HOSTS_FILE -l $USER -o /tmp/nagios-jmx-plugin "(wget http://downloads.sourceforge.net/project/nagioscheckjmx/nagioscheckjmx/1.0/check_jmx.tar.gz; tar xvfz check_jmx.tar.gz; mv check_jmx/nagios/plugin/check_jmx /usr/lib/nagios/plugins/); chmod a+x /usr/lib/nagios/plugins/check_jmx; rm /etc/nagios-plugins/config/cassandra_cmd.cfg; cp /home/clex/monitoring/nagios_cassandra_command.cfg /etc/nagios-plugins/config/cassandra_cmd.cfg; cp ~/check_jmx/nagios/plugin/jmxquery.jar /usr/lib/nagios/plugins/"

# install a simpler nagios-cassandra plugin as an alternative
sudo apt-get install libwww-perl libjson-perl
git clone git://github.com/causes/cassandra-nagios.git /home/cassandra-nagios
sudo parallel-ssh -h $HOSTS_FILE -l $USER -o /tmp/nagios-cassandra-plugin "sudo apt-get install libwww-perl libjson-perl; git clone git://github.com/causes/cassandra-nagios.git /home/cassandra-nagios"

# setup the nagios server conf
sudo rm /etc/nagios3/conf.d/cassandra.cfg
N=11
while read h; do
	echo "define host{
	        use                     generic-host            ; Name of host template to use
	        host_name               machine$N
	        alias                   Cassandra $N
	        address                 $h
	        }
define service{
        use                             generic-service         ; Name of service template to use
        host_name                       machine$N
        service_description             Check heap memory with check_jmx.
        check_command                   check_jmx_mem
        }
define service{
        use                             generic-service         ; Name of service template to use
        host_name                       machine$N
        service_description             Check heap memory.
        check_command                   check_cassandra_metrics_cache
        }" | sudo tee -a /etc/nagios3/conf.d/cassandra.cfg
N=`expr $N + 1`
done < hosts.txt
# check if things are OK
sudo /usr/sbin/nagios3 -v /etc/nagios3/nagios.cfg

sudo /etc/init.d/nagios3 restart