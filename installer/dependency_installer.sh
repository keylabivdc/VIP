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
sudo git clone https://github.com/keylabivdc/Virus-Identification-Pipeline
cd $cwd
echo "PATH=\$PATH:$VIP_PATH" >> ~/.bashrc
echo "PATH=\$PATH:$VIP_BIN" >> ~/.bashrc

### install & update Ubuntu packages

sudo -E apt-get update -y
sudo -E apt-get install -y make csh htop python-dev gcc unzip g++ g++-4.6 cpanminus ghostscript blast2 python-matplotlib git pigz parallel ncbi-blast+
sudo -E apt-get upgrade -y

### install Perl Modules
sudo cpanm DBI
sudo cpanm DBD::SQLite

### install VIP software dependencies

### install seqtk
curl "https://codeload.github.com/lh3/seqtk/zip/1.0" > seqtk.zip
unzip seqtk.zip
cd seqtk-1.0
make
sudo mv seqtk "$VIP_BIN/"
cd $cwd

### install prinseq-lite.pl
curl -O "http://iweb.dl.sourceforge.net/project/prinseq/standalone/prinseq-lite-0.20.3.tar.gz"
tar xvfz prinseq-lite-0.20.3.tar.gz
sudo cp prinseq-lite-0.20.3/prinseq-lite.pl "$VIP_BIN/"

### install Bowtie2
sudo apt-get install bowtie2

### install picard-tools
sudo apt-get install picard-tools

### install oases
git clone --recursive https://github.com/dzerbino/oases 
cd oases
make
sudo cp oases "$VIP_BIN/"
sudo cp ./scripts/oases_pipeline.py "$VIP_BIN/"

### install RAPSearch
curl "http://omics.informatics.indiana.edu/mg/get.php?justdoit=yes&software=rapsearch2.12_64bits.tar.gz" > rapsearch2.12_64bits.tar.gz
tar xvfz rapsearch2.12_64bits.tar.gz
cd RAPSearch2.12_64bits
./install
sudo cp bin/* "$VIP_BIN/"

### install mafft
sudo apt-get install mafft

### install ete2
sudo apt-get install python-numpy python-qt4 python-lxml
curl "https://bootstrap.pypa.io/get-pip.py" > get-pip.py
sudo python get-pip.py
sudo -H pip install --upgrade ete2

### install pandas
sudo -H pip install --upgrade pandas

### install edirect
cd $cwd
perl -MNet::FTP -e \
    '$ftp = new Net::FTP("ftp.ncbi.nlm.nih.gov", Passive => 1); $ftp->login;
     $ftp->binary; $ftp->get("/entrez/entrezdirect/edirect.zip");'
unzip -u -q edirect.zip
rm edirect.zip
export PATH=$PATH:$cwd/edirect
./edirect/setup.sh
cd $cwd
sudo chmod 777 $VIP_BIN/*
