#!/bin/bash
if which dpkg &> /dev/null; then
  sudo apt-get install -y git 
elif which rpm &> /dev/null; then
  sudo yum install -y git --disablerepo=epel
fi

(cd /home; git clone git://github.com/markusklems/clex.git)