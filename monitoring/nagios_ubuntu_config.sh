#!/bin/bash
# http://askubuntu.com/questions/145518/how-do-i-install-nagios
sudo sed -i -e "s|- check_external_commands=0|- check_external_commands=1|" /etc/nagios3/nagios.cfg
sudo service apache2 restart
sudo sed -i -e '/^nagios:x:/ s/$/ :www-data/' /etc/group
sudo chmod g+x /var/lib/nagios3/rw
sudo chmod g+x /var/lib/nagios3
sudo service nagios3 restart
sudo service apache2 restart