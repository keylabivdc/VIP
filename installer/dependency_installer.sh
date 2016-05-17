#!/bin/bash
#
#	installer.sh
#
#	This script will install VIP and its dependencies. It has been tested with Ubuntu 14.04 LTS.
#
#	quick guide:
#
#	./installer.sh
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-07-05
### Copyright (C) 2014 Yang Li - All Rights Reserved


#Change below folders as desired in order to change installation location.
VIP_PATH="/usr/VIP"
VIP_BIN="$VIP_PATH/bin"
##
sudo sh -c 'echo "export VIP_DIR=/usr/VIP/bin" >> ~/.bashrc'
sudo sh -c 'echo "PATH=\$PATH:/usr/VIP/bin" >> ~/.bashrc'

if [ ! -d $VIP_PATH ]
then
	mkdir $VIP_PATH
fi

if [ ! -d $VIP_BIN ]
then
	mkdir $VIP_BIN
fi

cwd=$(pwd)

### install VIP scripts

cd $VIP_BIN
sudo git clone https://github.com/keylabivdc/VIP
cd VIP
chmod 755 *
chmod 755 */*
cp * $VIP_BIN
mv edirect $VIP_PATH
cd $VIP_BIN
rm -rf VIP
cd $cwd
echo "PATH=\$PATH:$VIP_PATH" >> ~/.bashrc
echo "PATH=\$PATH:$VIP_PATH/edirect" >> ~/.bashrc
echo "PATH=\$PATH:$VIP_BIN" >> ~/.bashrc

### install & update Ubuntu packages

sudo -E apt-get update -y
sudo -E apt-get install -y make htop python-dev gcc unzip g++ g++-4.6 cpanminus python-matplotlib git pigz ncbi-blast+ curl
sudo -E apt-get upgrade -y

### install Perl Modules
sudo cpanm DBI
sudo cpanm DBD::SQLite
sudo cpanm Template
### install VIP software dependencies

### install Bowtie2
sudo apt-get install bowtie2

### install oasis velvet
sudo apt-get install velvet

### install picard-tools
sudo apt-get install picard-tools

### install mafft
sudo apt-get install mafft

### install ete2
sudo apt-get install python-numpy python-qt4 python-lxml
curl "https://bootstrap.pypa.io/get-pip.py" > get-pip.py
sudo python get-pip.py
rm -f get-pip.py
sudo -H pip install --upgrade ete2

### install pandas
sudo -H pip install --upgrade pandas
