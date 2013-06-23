#!/bin/bash
sudo apt-get install libcgi-pm-perl librrds-perl
sudo apt-get install libgd-gd2-perl libnagios-object-perl
(cd /tmp; wget http://downloads.sourceforge.net/project/nagiosgraph/nagiosgraph/1.4.4/nagiosgraph-1.4.4.tar.gz; tar xvfz nagiosgraph-1.4.4.tar.gz; cd nagiosgraph-1.4.4; sudo ./install.pl)

echo "process_performance_data=1
service_perfdata_file=/tmp/perfdata.log
service_perfdata_file_template=$LASTSERVICECHECK$||$HOSTNAME$||$SERVICEDESC$||$SERVICEOUTPUT$||$SERVICEPERFDATA$
service_perfdata_file_mode=a
service_perfdata_file_processing_interval=30
service_perfdata_file_processing_command=process-service-perfdata-for-nagiosgraph
" | sudo tee -a /etc/nagios3/nagios.cfg

echo "define command {
  command_name process-service-perfdata-for-nagiosgraph
  command_line /usr/local/nagiosgraph/bin/insert.pl
}" | sudo tee -a /etc/nagios3/commands.cfg

echo "include /usr/local/nagiosgraph/etc/nagiosgraph-apache.conf" | sudo tee -a /etc/apache2/httpd.conf

echo "Options +Indexes" | sudo tee -a /usr/local/nagiosgraph/.htaccess

sudo service nagios3 restart
sudo service apache2 restart